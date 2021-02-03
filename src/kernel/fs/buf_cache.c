//
// Created by hy on 2020/12/26.
//

#include "../types.h"
#include "../lock/lock.h"
#include "fs.h"
#include "../riscv.h"
#include "buf.h"
#include "../defs.h"

#define BUFFER_NUM 100

struct buf buf_cache[BUFFER_NUM];
struct spinlock cache_lock;

void init_buf() {
    spinlock_init(&cache_lock, "cache lock");
    for (int i = 0; i < BUFFER_NUM; i++) {
        sleeplock_init(&buf_cache->lock, "buf");
    }
}

extern uint64 ticks;


// 申请使用一个缓冲区，该缓冲区会被锁定
// 先进先出算法
struct buf *alloc_buf(int dev, int blockno) {
    struct buf *b;
    struct buf *earliest = 0;
    spin_lock(&cache_lock);
    for (b = buf_cache; b < buf_cache + BUFFER_NUM; b++) {
        if (b->refcnt == 0 &&
            (earliest == 0 || b->last_use_tick < earliest->last_use_tick)) {
            earliest = b;
        }
        if (b->blockno == blockno) {
            spin_unlock(&cache_lock);
            b->refcnt++;
            b->last_use_tick = ticks;
            sleep_lock(&b->lock);
            return b;
        }
    }
    spin_unlock(&cache_lock);
    if (earliest == 0) {
        panic("alloc buf");
    }
    b = earliest;
    b->valid = 0;
    b->refcnt = 1;
    b->blockno = blockno;
    b->dev = dev;
    b->last_use_tick = ticks;
    return b;
}

// 释放缓冲区
void relse_buf(struct buf *b) {
    spin_lock(&cache_lock);
    b->refcnt--;
    spin_unlock(&cache_lock);
    buf_write(b);
    sleep_unlock(&b->lock);
}

// 读取给定块的内容，返回一个包含该内容的buf
struct buf *buf_read(int dev, int blockno) {
    struct buf *b = alloc_buf(dev, blockno);
    if (!b->valid) {
        virtio_disk_rw(b, 0);
    }
    b->valid = 1;
    return b;
}

// 将缓冲区写入磁盘
void buf_write(struct buf *b) {
    virtio_disk_rw(b, 1);
}
