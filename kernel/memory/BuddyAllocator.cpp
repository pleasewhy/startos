#include "memory/BuddyAllocator.hpp"
#include "Bitmap.hpp"
#include "common/logger.h"
#include "memory/MemAllocator.hpp"
#include "types.hpp"

extern MemAllocator memAllocator;

namespace mem {

// 向上取整到2的幂
static inline uint64_t _roundup_pot(uint64_t v)
{
  v--;
  v |= v >> 1;
  v |= v >> 2;
  v |= v >> 4;
  v |= v >> 8;
  v |= v >> 16;
  v |= v >> 32;
  return ++v;
}

// 计算大小代表的级别
static inline int _calc_level(size_t size)
{
  int lv = MIN_LEVEL;
  size_t sz = 1 << lv;
  while (size > sz) {
    sz <<= 1;
    lv++;
  }
  return lv;
}

// 通过xor即可以取到伙伴的地址，比如：
// 从左孩子取右孩子：offsetaddr=10000, lv=3: buddyaddr = 10000 ^ (1 << 3) =
// 10000^1000 = 11000 从右孩子取左孩子：offsetaddr=11000, lv=3: buddyaddr =
// 11000 ^ (1 << 3) = 11000^1000 = 10000
static inline buddy_block_t* _get_buddy(buddy_block_t* block, int lv)
{
  uintptr_t buddyaddr = (uint64_t)block ^ (1 << lv);
  return (buddy_block_t*)buddyaddr;
}

void BuddyAllocator::init()
{
  this->maxlv = MAX_LEVEL;
  this->minlv = MIN_LEVEL;

  for (int i = 0; i <= MAX_LEVEL; i++) {
    this->freelist[i] = NULL;
  }
}

void* BuddyAllocator::alloc(size_t sz)
{
  sz += 8;                   // 多8个字节，用于存放level和对齐
  int lv = _calc_level(sz);  // 得到该块的级别
  printf("sz=%d lv=%d\n", sz, lv);
  // 向后查找可用的内存块，越往后内存块越大
  int i = lv;
  buddy_block_t* block = NULL;
  for (;; ++i) {
    // 从链表取出内存块
    if (this->freelist[i] != NULL) {
      block = this->freelist[i];
      this->freelist[i] = this->freelist[i]->next;
      break;
    }
    if (i >= this->maxlv) {
      break;
    }
  }

  if (block == NULL) {
    block = (buddy_block_t*)(memAllocator.alloc());
  }

  // 将内存块一级一级分割，并放入相应的freelist
  buddy_block_t* buddy;
  for (; i > lv; i--) {
    buddy = _get_buddy(block, i - 1);  // 分割成两块
    buddy->next = NULL;
    printf("lv=%d,%p\n", i - 1, buddy);
    this->freelist[i - 1] = buddy;
  }

  printf("alloc addr=%p\n", block);
  // 记录该内存块的level，在free的时候会用到
  // 这个level是放在block的前一个字节的
  uint8_t* b = (uint8_t*)(block);
  *b = lv;
  // 8字节对齐
  return b + 8;
}

void BuddyAllocator::free(void* pa)
{
  int i = *((uint8_t*)pa - 8);
  buddy_block_t* block = (buddy_block_t*)((uint8_t*)pa - 8);

  buddy_block_t* buddy;
  buddy_block_t** list;
  this->mem_info();
  for (;; ++i) {
    // 如果该内存块大小为PGSIZE，则将该块归还到page分配器
    if (i == this->maxlv) {
      memAllocator.free(block);
      break;
    }
    printf("free lv=%d\n", i);
    // 取当前块的buddy块
    buddy = _get_buddy(block, i);

    // 判断buddy块是否有在该级别的freelist中
    list = &this->freelist[i];
    while ((*list != NULL) && (*list != buddy))
      list = &(*list)->next;

    if (*list != buddy) {
      // 如果没找到buddy块，将block加入freelist
      block->next = this->freelist[i];
      this->freelist[i] = block;
      return;
    }
    else {
      // 如果找到，将block和buddy合并成大块
      block = block < buddy ? block : buddy;
      // 从链表删除，然后继续循环合并块
      *list = (*list)->next;
    }
  }
}

void BuddyAllocator::mem_info()
{
  printf("========================================\n");
  for (int i = this->minlv; i <= this->maxlv; ++i) {
    buddy_block_t* block = this->freelist[i];
    size_t sz = LEVEL_2_SIZE(i);
    printf("Lv %-2d (%lu) : ", i, sz);
    while (block) {
      printf("(%p--%p), ", block, (uint8_t*)block + sz);
      block = block->next;
    }
    printf("\n");
  }
  printf("========================================\n");
}

}  // namespace mem
