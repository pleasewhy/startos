#include "memory/mmap.hpp"
#include "common/string.hpp"
#include "common/logger.h"
#include "riscv.hpp"
#include "fcntl.h"
#include "memory/MemAllocator.hpp"
#include "memory/VmManager.hpp"
#include "fs/vfs_file.h"

extern MemAllocator memAllocator;

#define NVMA 60
struct vma vma_table_[NVMA];

/**
 * @brief
 *
 * @note [...bss...|...load...]和[...load...|...bss...]
 *  当先触发bss的page fault时，那么同一页的load段就不会触发page fault,
 *  从而不会从文件中读取数据
 * @param pagetable
 * @param va
 * @return true
 * @return false
 */
bool vma::LoadIfContain(pagetable_t pagetable, uint64_t va)
{
  uint64_t start = PGROUNDDOWN(this->addr);
  uint64_t end = PGROUNDUP(this->addr + this->length);
  if (va < start || va >= end) {
    return false;
  }

  if (va < this->addr) {  // [...bss...|...load...]
    panic("load if contain");
    va = this->addr;
  }

  if (va >= this->addr + this->length) {
    panic("load if contain");
    va = this->addr + this->length - 1;
  }

  // 表明改地址已被加载
  if (walkAddr(pagetable, va) != 0)
    return false;

  char *mem = (char *)memAllocator.alloc();
  memset(mem, 0, PGSIZE);
  // uint64_t va0 = va;
  va = PGROUNDDOWN(va);

  // 设置权限
  int perm = PTE_V | PTE_U;
  if (this->prot & PROT_READ)
    perm |= PTE_R;
  if (this->prot & PROT_WRITE)
    perm |= PTE_W;
  if (this->prot & PROT_EXEC)
    perm |= PTE_X;
  // LOG_TRACE("map page va=%p", this->addr);
  mappages(pagetable, va, PGSIZE, (uint64_t)mem, perm);

  if (ip == nullptr)
    return true;
  // eaddr不能小于this->addr，即vma的起始地址，因为
  // 不能保证this->addr对齐PGSIZE。
  va = this->addr > va ? this->addr : va;
  uint64_t high = PGROUNDUP(va + 1);
  uint64_t high_max = this->addr + this->length;
  high = high > high_max ? high_max : high;

  int nread = high - va;
  nread = nread > PGSIZE ? PGSIZE : nread;
  uint32_t file_off = this->offset + (va - this->addr);
  uint64_t pa = (uint64_t)mem + va - PGROUNDDOWN(va);
  this->ip->read((char *)pa, file_off, nread, false);
  return true;
}

void vma::free()
{
  if (ip != 0)
    ip->free();
  memset(this, 0, sizeof(struct vma));
}

struct vma *allocVma()
{
  struct vma *a;
  for (a = vma_table_; a < vma_table_ + NVMA; a++) {
    if (a->ip == 0 && a->addr == 0 && a->length == 0) {
      return a;
    }
  }
  panic("not enough vma");
  return 0;
}

void InitVmaTable()
{
  memset(vma_table_, 0, sizeof(struct vma) * NVMA);
}