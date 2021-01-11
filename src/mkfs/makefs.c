#include <assert.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "../kernel/fs/fs.h"

#define FSSIZE 1000
#define INODE_NUM 200


// 磁盘布局
// [ boot block | super block | inode block | free bit map | data block]

int bitmap_blocks = FSSIZE / (BSIZE * 8) + 1; // 位图块的数量
int inode_blocks = INODE_NUM / IPB + 1; // inode块的数量
int nmeta; // meta data block数量 (boot, superblock, inode, bitmap)
int data_blocks; // data block数量
int fsfd;

void init_disk(int fsfd)
{
    char buf[1024];
    memset(buf, sizeof(char), 1024);
    for (int i = 0; i < 100000; i++)
        write(fsfd, buf, 1024);
}

void write_block(int blockno, char* buf)
{
    printf("%d\n",blockno*BSIZE);
    if (lseek(fsfd, blockno * BSIZE, 0) != blockno * BSIZE) {
        perror("lseek");
        exit(1);
    }
    if (write(fsfd, buf, BSIZE) != BSIZE) {
        perror("write");
        exit(1);
    }
}

int main(int argc, char* argv[])
{
    struct superblock sb;
    char buf[BSIZE];
    char zeros[BSIZE];
    memset(zeros, sizeof(char), BSIZE);
    memset(buf, sizeof(char), BSIZE);
    fsfd = open("fs.img", O_RDWR | O_CREAT | O_TRUNC, 0666);
    if (fsfd < 0) {
        perror(argv[1]);
        exit(1);
    }
    sb.magic = FSMAGIC;
    sb.size = FSSIZE;
    sb.nblocks = data_blocks;
    sb.ninodes = INODE_NUM;
    sb.inodestart = 2;
    sb.bmapstart = 2 + inode_blocks;

    // 初始化磁盘数据为0
    for (int i = 0; i < FSSIZE; i++) {
      zeros[0] = i;
        write_block(i, zeros);
    }

    // 写super block
    memmove(buf, &sb, sizeof(sb));

    write_block(1, buf);
    close(fsfd);
}
