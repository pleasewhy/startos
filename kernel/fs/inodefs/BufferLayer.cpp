//
// Created by hy on 2020/12/26.
//

#include "common/printk.hpp"
#include "os/SleepLock.hpp"
#include "fs/inodefs/BufferLayer.hpp"
#include "fs/disk/Disk.hpp"
#include "os/TaskScheduler.hpp"
#include "os/Timer.hpp"
#include "param.hpp"
#include "riscv.hpp"
#include "types.hpp"
#include "StartOS.hpp"

#define BUFFER_NUM 100

void BufferLayer::init() {
  this->spinlock.init("cache buffer");
  for (int i = 0; i < BUFFER_NUM; i++) {
    this->bufCache->sleeplock.init("buf");
  }
}

// 申请使用一个缓冲区，该缓冲区会被锁定
// 先进先出算法
struct buf *BufferLayer::allocBuffer(int dev, int blockno) {
  struct buf *b;
  struct buf *earliest = 0;
  this->spinlock.lock();
  for (b = this->bufCache; b < this->bufCache + BUFFER_NUM; b++) {
    if (b->refcnt == 0 && (earliest == 0 || b->last_use_tick < earliest->last_use_tick)) {
      earliest = b;
    }
    if (b->blockno == blockno) {
      this->spinlock.unlock();
      b->refcnt++;
      b->last_use_tick = timer::ticks;
      b->sleeplock.lock();
      return b;
    }
  }
  this->spinlock.unlock();
  if (earliest == 0) {
    panic("alloc buf");
  }
  b = earliest;
  b->valid = 0;
  b->refcnt = 1;
  b->blockno = blockno;
  b->dev = dev;
  b->last_use_tick = timer::ticks;
  b->sleeplock.lock();
  return b;
}

// 释放缓冲区
void BufferLayer::freeBuffer(struct buf *b) {
  this->spinlock.lock();
  b->refcnt--;
  this->spinlock.unlock();
	this->write(b);
	b->sleeplock.unlock();
}

// 读取给定块的内容，返回一个包含该内容的buf
struct buf *BufferLayer::read(int dev, int blockno) {
  struct buf *b = allocBuffer(dev, blockno);
  if (!b->valid) {
    disk_read(b);
  }
  b->valid = 1;
  return b;
}

// 将缓冲区写入磁盘
void BufferLayer::write(struct buf *b){
	disk_write(b);
};
