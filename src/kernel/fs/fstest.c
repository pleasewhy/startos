//
// Created by hy on 2021/1/10.
//
#include "../types.h"
#include "fs.h"
#include "../riscv.h"
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
    printf("测试inode能否读写");
    char *str = "hello world!!";
    write_inode(inode, (uint64) str, 0, strlen(str));
    char s[20];
    read_inode(inode, (uint64) s, 0, 30);
    printf("%s\n", s);
}

// 输出根目录下的direntry
void dirtest() {
    int off = 0;
    char str[1024];
    printf("aa\n");
    struct inode *ip = namei("/readme.txt");
    printf("bb\n");
    lock_inode(ip);
    read_inode(ip, (uint64)str, off, 1024);
    printf("%s\n",str);
    unlock_inode(ip);
}
