//
// Created by hy on 2021/1/10.
//
#include "../types.h"
#include "fs.h"
#include "../lock/lock.h"
#include "buf.h"
#include "file.h"
#include "virtio.h"
#include "../defs.h"
#include "fstest.h"

void fstest() {
    struct inode *inode;
    struct superblock sb;
    read_superblock(&sb);
    inode = alloc_inode(T_FILE);
    char *str = "hello world!";
    write_inode(inode, (uint64) str, 0, strlen(str));
    char s[20];
    read_inode(inode, (uint64) s, 0, 30);
    printf("%s\n", s);
}

// 输出根目录下的direntry
void dirtest() {
    int off = 0;
    struct direntry de;
    struct inode *ip = get_inode(ROOTINO);
    while (read_inode(ip, (uint64)&de, off, sizeof(de)) == sizeof(de)) {
        off += sizeof(de);
        printf("name=%s,inum=%d\n", de.name, de.inum);
        printf("addr=%d\n",ip->addrs[0]);
    }
}
