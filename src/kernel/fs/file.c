//
// Created by hy on 2021/1/12.
//

#include "../types.h"
#include "../param.h"
#include "../riscv.h"
#include "../memlayout.h"
#include "../lock/lock.h"
#include "fs.h"
#include "file.h"
#include "stat.h"
#include "../process.h"
#include "../defs.h"

// 保存各个设备的读写接口
struct dev_rw dev_rw[NDEV];

struct {
    struct spinlock lock;
    struct file file[NFILE];
} file_table;

void fileinit(void) {
    spinlock_init(&file_table.lock, "file table");
}

// 申请使用一个文件结构体
struct file *file_alloc(void) {
    struct file *f;
    spin_lock(&file_table.lock);
    for (f = file_table.file; f < file_table.file + NFILE; ++f) {
        if (f->ref == 0) {
            f->ref = 1;
            spin_unlock(&file_table.lock);
            return f;
        }
    }
    spin_unlock(&file_table.lock);
    return 0;
}

// 递增文件f的的引用数量
struct file *file_dup(struct file *f) {
    spin_lock(&file_table.lock);
    if (f->ref < 1) {
        panic("file dup");
    }
    f->ref++;
    spin_unlock(&file_table.lock);
    return f;
}

// 关闭文件(递减文件f的引用数量,为0时关闭文件)。
void file_close(struct file *f) {
    struct file ff;
    spin_lock(&file_table.lock);
    if (f->ref < 1)
        panic("file close");
    if (--f->ref > 0) {
        spin_unlock(&file_table.lock);
        return;
    }
    ff = *f;
    f->type = FD_NONE;
    f->ref = 0;
    spin_unlock(&file_table.lock);

    if (ff.type == FD_INODE || ff.type == FD_DEVICE) {
        putback_inode(ff.ip);
    }
}

/**
 * 获取文件f的元数据
 * @param addr 用户空间地址，应该指向一个stat结构体
 * @return
 */
int file_stat(struct file *f, uint64 addr) {
    struct proc *p = myproc();
    struct stat st;
    if (f->type == FD_INODE || f->type == FD_DEVICE) {
        lock_inode(f->ip);
        stat_inode(f->ip, &st);
        unlock_inode(f->ip);
        if (copyout(p->pagetable, addr, (char *) &st, sizeof(st)) < 0) {
            return -1;
        }
        return 0;
    }
    return -1;
}

/**
 * 读取文件数据
 *
 * @param addr 用户空间虚拟地址
 * @param n 读取字节数
 */
int file_read(struct file *f, uint64 addr, int n) {

    int len = 0;

    if (f->readable == 0) {
        return -1;
    }
    if (f->type == FD_DEVICE) {
        if (f->major < 0 || f->major > NDEV || !dev_rw[f->major].read) {
            return -1;
        }
        len = dev_rw[f->major].read(1, addr, n);
    } else if (f->type == FD_INODE) {
        lock_inode(f->ip);
        if ((len = read_inode(f->ip, 1, addr, f->off, n)) > 0) {
            f->off += len;
        }
        unlock_inode(f->ip);
    }

    return len;
}

/**
 * 向文件f写入数据, 根据不同的文件类型，选择相应的写入方式
 * 若文件为设备文件则调用相应的设备的write函数进行写入，若文件
 * 为inode文件，
 *
 * @param addr 用户空间虚拟地址
 * @param n 写入字节数
 */
int file_write(struct file *f, uint64 addr, int n) {
    int ret = 0;
    if (f->type == FD_DEVICE) {
        if (f->major < 0 || f->major >= NDEV || !dev_rw[f->major].write)
            return -1;
        ret = dev_rw[f->major].write(1, addr, n);
    } else if (f->type == FD_INODE) {
        lock_inode(f->ip);
        ret = write_inode(f->ip, 1, addr, f->off, n);
        unlock_inode(f->ip);
    }
    return ret;
}
