//
// Created by hy on 2020/12/26.
//

#include "common/printk.hpp"
#include "os/SleepLock.hpp"
#include "device/DeviceManager.hpp"
#include "common/string.hpp"
#include "fs/buf/BufferLayer.hpp"
#include "os/TaskScheduler.hpp"
#include "os/Timer.hpp"
#include "param.hpp"
#include "riscv.hpp"
#include "types.hpp"
#include "StartOS.hpp"
#include "fs/fat/fat.hpp"

void BufferLayer::init()
{
  this->spinlock.init("cache buffer");
  memset(bufCache, 0, sizeof(struct buf) * BUFFER_NUM);
  for (int i = 0; i < BUFFER_NUM; i++) {
    this->bufCache->sleeplock.init("buf");
  }
}

// 申请使用一个缓冲区，该缓冲区会被锁定
// 先进先出算法
struct buf *BufferLayer::allocBuffer(int dev, int blockno)
{
  struct buf *b;
  struct buf *earliest = 0;
  this->spinlock.lock();
  for (b = this->bufCache; b < this->bufCache + BUFFER_NUM; b++) {
    if (b->refcnt == 0 &&
        (earliest == 0 || b->last_use_tick < earliest->last_use_tick)) {
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
  // printf("expel\n");
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
void BufferLayer::freeBuffer(struct buf *b)
{
  this->spinlock.lock();
  b->refcnt--;
  this->spinlock.unlock();
  // this->write(b);
  b->sleeplock.unlock();
}

// 读取给定块的内容，返回一个包含该内容的buf
struct buf *BufferLayer::read(int dev, int cluster)
{
  struct buf *b = allocBuffer(dev, cluster);
  if (!b->valid) {
    uint64_t sector = FirstSectorOfCluster(cluster);
    dev::RwDevRead(dev, b->data, sector * 512, BSIZE);
  }
  b->valid = 1;
  return b;
}

// 将缓冲区写入磁盘
void BufferLayer::write(struct buf *b)
{
  uint64_t sector = FirstSectorOfCluster(b->blockno);
  dev::RwDevWrite(b->dev, b->data, sector * 512, BSIZE);
};

uint32_t BufferLayer::FirstSectorOfCluster(uint32_t cluster)
{
  return first_data_sector + ((cluster - 2) * sectors_per_cluster);
}
