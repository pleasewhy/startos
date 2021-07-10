#include "memory/mmap.hpp"
#include "common/string.hpp"
#include "common/logger.h"
#include "riscv.hpp"
#include "fcntl.h"
#include "memory/MemAllocator.hpp"
#include "memory/VmManager.hpp"
#include "fs/vfs_file.h"

extern MemAllocator memAllocator;

#define NVMA 30
struct vma vma_table_[NVMA];

bool vma::LoadIfContain(pagetable_t pagetable, uint64_t va)
{
  if (va < this->addr || va >= this->addr + this->length) {
    return false;
  }

  char *mem = (char *)memAllocator.alloc();
  memset(mem, 0, PGSIZE);
  va = PGROUNDDOWN(va);

  // 设置权限
  int perm = PTE_V | PTE_U;
  if (this->prot & PROT_READ)
    perm |= PTE_R;
  if (this->prot & PROT_WRITE)
    perm |= PTE_W;
  if (this->prot & PROT_EXEC)
    perm |= PTE_X;
  // LOG_DEBUG("map page va=%p", this->addr);
  mappages(pagetable, va, PGSIZE, (uint64_t)mem, perm);

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
  LOG_DEBUG("cal va=%p len=%d nread=%d file_off=%d", va, this->length, nread,
            file_off);
  int n = this->ip->read((char *)pa, file_off, nread, false);
  LOG_DEBUG("n=%d", n);
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
    if (a->ip == 0) {
      return a;
    }
  }
  panic("not enough vma");
  return 0;
}