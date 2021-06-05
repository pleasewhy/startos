#ifndef BUFFER_LAYER_HPP
#define BUFFER_LAYER_HPP
#include "os/SpinLock.hpp"
#include "os/SleepLock.hpp"


#define BUFFER_NUM 100
#define BSIZE 512

struct buf {
  int valid;  // has data been read from disk?
  int disk;   // does disk "own" buf?
  int dev;
  int blockno;
  uint64_t last_use_tick;
  SleepLock sleeplock;
  uint_t refcnt;
  uchar_t data[BSIZE];
};

class BufferLayer {
 public:
  /**
   * @brief 初始化Buffer层
   *
   */
  void init();

  /**
   * @brief 申请一个buffer，使用优先选择
   *        未cache的buffer，若全部buffer都包含cache，
   *        则使用LRU算法进行淘汰
   * @note 一个buffer只能同时被一个线程所持有
   *
   */
  struct buf* allocBuffer(int dev, int blockno);

  /**
   * @brief 释放一个buffer，该buffer暂时不会保存
   *        的数据暂时不会被清除，会被cache，下次
   *        使用就不用再次读取磁盘了
   */
  void freeBuffer(struct buf *b);

  /**
   * @brief 读取给定块的的内容，返回一个包含
   *        该内容的buffer。
   */
  struct buf *read(int dev, int blockno);

  /**
   * @brief 将缓冲区写入磁盘
   * 
   */
  void write(struct buf *b);

 public:
  struct buf bufCache[BUFFER_NUM];
  SpinLock spinlock;
};
#endif