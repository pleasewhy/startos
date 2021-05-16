#include "memory/MemAllocator.hpp"
#include "common/printk.hpp"
#include "common/string.hpp"
#include "memlayout.hpp"
#include "riscv.hpp"
#include "types.hpp"
#include "StartOS.hpp"




extern "C" char end[];  // 内核使用的空间后的第一个地址, 在kernel.ld中定义
void MemAllocator::init() {
  this->spinLock.init("memAlloc");
  freeRange(end, (void *)PHYSTOP);
}

void MemAllocator::freeRange(void *paStart, void *paEnd) {
  char *p;
  p = (char *)PGROUNDUP((uint64_t)paStart);
  for (; p + PGSIZE <= (char *)paEnd; p += PGSIZE) free(p);
}

void *MemAllocator::alloc() {
  struct Node *r;

  this->spinLock.lock();
  r = this->freeList;
  if (r) this->freeList = r->next;
  this->spinLock.unlock();

  if (r) memset((char *)r, 5, PGSIZE);  // fill with junk
  return (void *)r;
}

void MemAllocator::free(void *pa) {
  struct Node *r;
  if (((uint64_t)pa % PGSIZE) != 0 || (char *)pa < end || (uint64_t)pa >= PHYSTOP) panic("kfree");

  // 填充无效值
  memset(pa, 1, PGSIZE);

  r = static_cast<struct Node *>(pa);
  spinLock.lock();
  r->next = this->freeList;
  this->freeList = r;
  spinLock.unlock();
}