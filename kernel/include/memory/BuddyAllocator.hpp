#ifndef __BUDDY_ALLOCATOR_HPP
#define __BUDDY_ALLOCATOR_HPP
#include "Bitmap.hpp"
#include "types.hpp"

namespace mem {

// 取块的级别，级别存在块的前一个字节处
#define GET_LEVEL(b) (*((uint8_t *)(b)-1))

// 计算级别代表的内存大小
#define LEVEL_2_SIZE(lv) (1 << (lv))

// 最小可分配块的级别，16字节
#define MIN_LEVEL 4

// 最大可分配块级别，4096字节
#define MAX_LEVEL 12

// 内存块
typedef struct buddy_block {
  struct buddy_block *next;
} buddy_block_t;

class BuddyAllocator {
 private:
  struct buddy_block
      *freelist[MAX_LEVEL + 1];  // freelist数组，每一个slot存放一个freelist，内存块尺寸=2^i，i即是slot的索引。
  int maxlv;                     // 最大级
  int minlv;                     // 最小级
 public:
  BuddyAllocator(){};
  ~BuddyAllocator(){};

  /**
   * @brief 初始化buddy分配器
   *
   */
  void init();
  /**
   * @brief 申请指定sz的内存，注意只能申请小于4096字节的
   * 内存
   *
   * @param sz 申请的内存的大小
   * @return void* 内存地址
   */
  void *alloc(size_t sz);

  /**
   * @brief 释放内存
   *
   * @param pa alloc返回的地址
   */
  void free(void *pa);

  /**
   * @brief 输出内存信息到控制台
   *
   */
  void mem_info();
};
}  // namespace mem
#endif