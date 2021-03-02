#include <assert.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "../kernel/fs/fs.h"

#define FSSIZE 1000


// 磁盘布局
// [ boot block | super block | inode block | free bit map | data block]

int bitmap_blocks = FSSIZE / (BSIZE * 8) + 1; // 位图块的数量
int inode_blocks = NINODE / IPB + 1; // inode块的数量
int nmeta; // meta data block数量 (boot, superblock, inode, bitmap)
int data_blocks; // data block数量
int fsfd;   // “磁盘”的文件描述符
int free_inode_num = 1;
int free_data_block;  // 根据元数据得到

struct superblock sb;

void balloc(int used);

uint alloc_inode(short type);

void write_inode(uint inum, struct dinode *ip);

void read_inode(uint inum, struct dinode *ip);

void inode_append(uint inum, void *data, int n);

void write_block(int blockno, char *buf) {
    if (lseek(fsfd, blockno * BSIZE, 0) != blockno * BSIZE) {
        perror("lseek");
        exit(1);
    }
    if (write(fsfd, buf, BSIZE) != BSIZE) {
        perror("write");
        exit(1);
    }
}

void read_block(int blockno, char *buf) {
    if (lseek(fsfd, blockno * BSIZE, 0) != blockno * BSIZE) {
        perror("lseek");
        exit(1);
    }
    if (read(fsfd, buf, BSIZE) != BSIZE) {
        perror("read");
        exit(1);
    }
}

int main(int argc, char *argv[]) {
    char buf[BSIZE], zeros[BSIZE];
    uint rootino, inum;
    struct direntry de;
    memset(zeros, 0, BSIZE);
    memset(buf, 0, BSIZE);
    fsfd = open("fs.img", O_RDWR | O_CREAT | O_TRUNC, 0666);
    if (fsfd < 0) {
        perror(argv[1]);
        exit(1);
    }

    nmeta = 2 + inode_blocks + bitmap_blocks;
    free_data_block = nmeta;    // 数据块的起始块号
    data_blocks = FSSIZE - nmeta;

    printf("meta=%d(boot, super, inode blocks=%d, bitmap blocks=%d)\ndata block=%d\ntotal=%d\n",
           nmeta, inode_blocks, bitmap_blocks, data_blocks, FSSIZE);
    sb.magic = FSMAGIC;
    sb.size = FSSIZE;
    sb.nblocks = data_blocks;
    sb.ninodes = NINODE;
    sb.inodestart = 2;
    sb.bmapstart = 2 + inode_blocks;

    // 初始化磁盘数据为0
    for (int i = 0; i < FSSIZE; i++) {
        write_block(i, zeros);
    }

    // 写super block
    memmove(buf, &sb, sizeof(sb));
    write_block(1, buf);

    // 创建根目录
    rootino = alloc_inode(T_DIR);
    assert(rootino == ROOTINO);

    // 添加 . 目录项，指向当前目录
    de.inum = ROOTINO;
    strcpy(de.name, ".");
    inode_append(rootino, &de, sizeof(de));

    // 根目录下的 .. 指向根目录
    de.inum = ROOTINO;
    strcpy(de.name, "..");
    inode_append(rootino, &de, sizeof(de));

    // 添加用户程序
    int fd, n;
    for (int i = 2; i < argc; i++) {
        // 去除前缀 "user/"
        char *shortname;
        if (strncmp(argv[i], "user/", 5) == 0)
            shortname = argv[i] + 5;
        else
            shortname = argv[i];

        assert(index(shortname, '/') == 0);

        if ((fd = open(argv[i], 0)) < 0) {
            perror(argv[i]);
            exit(1);
        }
        printf("%s\n", shortname);
        // 由于一些用户程序会和原系统的用户程序，所以需要再前面添加"_"
        // 这里将它们去除，再写入文件系统中
        if (shortname[0] == '_')
            shortname += 1;

        inum = alloc_inode(T_FILE);

        bzero(&de, sizeof(de));

        de.inum = inum;
        strncpy(de.name, shortname, DIRSIZ);
        inode_append(rootino, &de, sizeof(de));

        while ((n = read(fd, buf, sizeof(buf))) > 0)
            inode_append(inum, buf, n);

        close(fd);
    }

    balloc(free_data_block);
    struct dinode dip;
    read_inode(1, &dip);
    printf("%d\n", dip.nlink);
    close(fsfd);
}


// 在bitmap中标记前used个块已经使用
void balloc(int used) {
    unsigned char buf[BSIZE];
    int i;

    printf("balloc: 前%d个块已被使用\n", used);
    assert(used < BSIZE * 8);
    bzero(buf, BSIZE);
    for (i = 0; i < used; i++) {
        buf[i / 8] = buf[i / 8] | (0x1 << (i % 8));
    }
    printf("balloc: 在扇区%d写入bitmap\n", sb.bmapstart);
    write_block(sb.bmapstart, (char *) buf);
}

// 申请一个inode
uint alloc_inode(short type) {
    uint inum = free_inode_num++;
    struct dinode dinode;

    bzero(&dinode, sizeof(dinode));
    dinode.type = type;
    dinode.nlink = 1;
    dinode.size = 0;
    write_inode(inum, &dinode);
    return inum;
}

# define min(a, b) ((a) < (b) ? (a) :(b));

// inode添加数据
void inode_append(uint inum, void *data, int n) {
    char *p = (char *) data;
    uint bn, off, m;
    struct dinode din;
    char buf[BSIZE];
    uint indirect[NINDIRECT];
    read_inode(inum, &din);

    off = din.size;
    int datano;  // 数据块号
    while (n > 0) {
        bn = off / BSIZE;
        assert(bn < MAXFILE);
        printf("bn=%d\n", bn);

        if (bn < NDIRECT) {
            if (din.addrs[bn] == 0) {
                din.addrs[bn] = free_data_block++;
            }
            datano = din.addrs[bn];
        } else {
            if (din.addrs[NDIRECT] == 0) {
                din.addrs[NDIRECT] = free_data_block++;
            }
            read_block(din.addrs[NDIRECT], (char *) indirect);
            if (indirect[bn - NDIRECT] == 0) {
                indirect[bn - NDIRECT] = free_data_block++;
                write_block(din.addrs[NDIRECT], (char *) indirect);
            }
            datano = indirect[bn - NDIRECT];
        }

        m = min(n, (bn + 1) * BSIZE - off);
        read_block(datano, buf);
        bcopy(p, buf + off - (bn * BSIZE), m);
        write_block(datano, buf);
        p += m;
        n -= m;
        off += m;
    }
    din.size = off;
    write_inode(inum, &din);
}

// 更新磁盘上的inode
void write_inode(uint inum, struct dinode *ip) {
    char buf[BSIZE];
    uint bn;
    struct dinode *dip;

    bn = IBLOCK(inum, sb);
    read_block(bn, buf);
    dip = ((struct dinode *) buf) + (inum % IPB);
    *dip = *ip;
    write_block(bn, buf);
}

// 读取磁盘上的inode
void read_inode(uint inum, struct dinode *ip) {
    char buf[BSIZE];
    uint bn;
    struct dinode *dip;

    bn = IBLOCK(inum, sb);
    read_block(bn, buf);
    dip = ((struct dinode *) buf) + (inum % IPB);
    *ip = *dip;
}
