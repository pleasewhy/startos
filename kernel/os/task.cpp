#include "os/Process.hpp"
#include "os/TaskScheduler.hpp"
#include "fs/vfs_file.h"
#include "common/string.hpp"
#include "common/logger.h"
#include "memory/MemAllocator.hpp"
#include "riscv.hpp"

extern MemAllocator memAllocator;

bool Task::LoadIfValid(uint64_t va)
{
  if (walkAddr(pagetable, va) != 0)
    return false;
  for (int i = 0; i < NOMMAPFILE; i++) {
    if (this->vma[i] != 0 && this->vma[i]->LoadIfContain(this->pagetable, va)) {
      return true;
    }
  }

  // 检查是否为bss段
  if (va < this->sz) {
    LOG_TRACE("bss segment");
    char *mem = (char *)memAllocator.alloc();
    memset(mem, 0, PGSIZE);
    va = PGROUNDDOWN(va);

    // 设置权限
    int perm = PTE_V | PTE_U;
    perm |= PTE_R;
    perm |= PTE_W;
    // perm |= PTE_X;
    // LOG_DEBUG("map page va=%p", vma->addr);
    mappages(pagetable, va, PGSIZE, (uint64_t)mem, perm);
    return true;
  }
  return false;
}

int Task::AllocFd(int from, int to)
{
  lock.lock();
  from = from < 0 ? 0 : from;
  to = to < 0 ? NOFILE : to;
  for (int i = from; i < to; i++) {
    if (this->openFiles[i] == NULL) {
      lock.unlock();
      return i;
    }
  }
  lock.unlock();
  panic("alloc fd");
  return 0;
}
