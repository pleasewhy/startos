#ifndef MEMALLOCATOR_HPP
#define MEMALLOCATOR_HPP
#include "os/SpinLock.hpp"

struct Node
{
  struct Node *next;
};

class MemAllocator {
public:
  /**
   * @brief 初始化内存分配器
   * @note 该函数会将系统可用内存添加至该分配器，以供内核和用户程序使用
   */
  void init();

  /**
   * @brief 释放pa指向的物理空间，每次释放1页
   *
   * @note 需要保证pa是按页对齐的，且是一个有效的地址
   *
   * @param pa 物理空间的起始地址
   */
  void free(void *pa);

  /**
   * @brief 分配一页物理内存
   *
   * @return void* 一页物理空间的起始地址，该页会被填充垃圾值
   */
  void *alloc();

  /**
   * @brief 将一段范围内的内存空间添加至内存分配器
   * @note 地址必须是物理地址
   *
   */
  void freeRange(void *paStart, void *paEnd);

  /**
   * @brief 获取空闲的内存(bytes)
   */
  uint64_t FreeMemOfBytes();

  /**
   * @brief 获取全部内存
   */
  uint64_t TotalMemOfBytes();

  void DebugInfo();

private:
  SpinLock     spinLock;
  struct Node *freeList;
  int          npage;
  int          total_page_;
};
#endif