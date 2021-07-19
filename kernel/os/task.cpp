#include "os/Process.hpp"
#include "os/TaskScheduler.hpp"
#include "fs/vfs_file.h"
#include "common/string.hpp"
#include "common/logger.h"
#include "fcntl.h"
#include "memory/MemAllocator.hpp"
#include "riscv.hpp"

extern MemAllocator memAllocator;

bool Task::LoadIfValid(uint64_t va)
{
  // printf("load va=%p\n", va);
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
  LOG_ERROR("from=%d to=%d", from, to);
  panic("alloc fd");
  return 0;
}

static int MkPtePerm(int prot)
{
  int perm = 0;
  if (prot & PROT_READ)
    perm |= PTE_R;
  if (prot & PROT_WRITE)
    perm |= PTE_W;
  if (prot & PROT_EXEC)
    perm |= PTE_X;
  return perm;
}

int Task::ModifyMemProt(uint64_t va, int len, int prot)
{
  for (int i = 0; i < NOMMAPFILE; i++) {
    if (vma[i] == nullptr)
      continue;
    struct vma *a = vma[i];
    if (va >= a->addr && va < a->addr + len) {
      a->prot |= prot;
      pte_t *pte;
      if ((pte = walk(pagetable, PGROUNDDOWN(va), 0)) == 0)
        continue;
      LOG_TRACE("ModifyMemProt: walk va");
      int perm = MkPtePerm(prot);
      *pte |= perm;
    }
  }
  return 0;
}