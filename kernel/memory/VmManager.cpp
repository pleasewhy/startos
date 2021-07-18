#include "memory/VmManager.hpp"
#include "common/logger.h"
#include "common/printk.hpp"
#include "common/string.hpp"
#include "memlayout.hpp"
#include "memory/MemAllocator.hpp"
#include "param.hpp"
#include "riscv.hpp"

extern "C" char         trampoline[];  // trampoline.S
extern "C" MemAllocator memAllocator;
extern "C" char etext[];  // 链接器会设置这个为内核代码结束
pagetable_t     kernel_pagetable;

void initKernelVm()
{
  kernel_pagetable = (pagetable_t)memAllocator.alloc();
  memset(kernel_pagetable, 0, PGSIZE);

  // uart寄存器
  kernel_vm_map(UART, UART, PGSIZE, PTE_R | PTE_W);

#ifdef QEMU
  // virtio mmio 磁盘接口
  kernel_vm_map(VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
#endif

  // PLIC
  kernel_vm_map(PLIC, PLIC, 0x4000, PTE_R | PTE_W);
  kernel_vm_map(PLIC + 0x200000, PLIC + 0x200000, 0x4000, PTE_R | PTE_W);

  // 内核
  kernel_vm_map(KERNBASE, KERNBASE, (uint64_t)etext - KERNBASE, PTE_R | PTE_X);

  // 映射剩下的内存
  kernel_vm_map((uint64_t)etext, (uint64_t)etext, PHYSTOP - (uint64_t)etext,
                PTE_R | PTE_W);

  // trampoline作为trap的entry/exit，会被映射到虚拟地址的顶端
  kernel_vm_map(TRAMPOLINE, (uint64_t)trampoline, PGSIZE, PTE_R | PTE_X);

#ifdef K210
  // GPIOHS
  kernel_vm_map(GPIOHS, GPIOHS, 0x1000, PTE_R | PTE_W);

  // DMAC
  kernel_vm_map(DMAC, DMAC, 0x1000, PTE_R | PTE_W);

  // GPIO
  // kvmmap(GPIO, GPIO, 0x1000, PTE_R | PTE_W);

  // SPI_SLAVE
  kernel_vm_map(SPI_SLAVE, SPI_SLAVE, 0x1000, PTE_R | PTE_W);

  // FPIOA
  kernel_vm_map(FPIOA, FPIOA, 0x1000, PTE_R | PTE_W);

  // SPI0
  kernel_vm_map(SPI0, SPI0, 0x1000, PTE_R | PTE_W);

  // SPI1
  kernel_vm_map(SPI1, SPI1, 0x1000, PTE_R | PTE_W);

  // SPI2
  kernel_vm_map(SPI2, SPI2, 0x1000, PTE_R | PTE_W);

  // SYSCTL
  kernel_vm_map(SYSCTL, SYSCTL, 0x1000, PTE_R | PTE_W);

  // clock
  kernel_vm_map(RTC, RTC, 0x1000, PTE_R | PTE_W);
#endif
}

void initHartVm()
{
  w_satp(MAKE_SATP(kernel_pagetable));
  sfence_vma();
#ifdef K210
  // sfence_vm();
  asm volatile("fence.i");
  asm volatile("fence");
#endif
}

pte_t *walk(pagetable_t pagetable, uint64_t va, int alloc)
{
  if (va >= MAXVA)
    panic("walk");

  for (int level = 2; level > 0; level--) {
    pte_t *pte = &pagetable[PX(level, va)];
    if (*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    }
    else {
      if (!alloc || (pagetable = (pte_t *)memAllocator.alloc()) == NULL)
        return NULL;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
}

int mappages(
    pagetable_t pagetable, uint64_t va, uint64_t size, uint64_t pa, int perm)
{
  uint64_t a, last;
  pte_t *  pte;

  a = PGROUNDDOWN(va);
  last = PGROUNDDOWN(va + size - 1);
  for (;;) {
    if ((pte = walk(pagetable, a, 1)) == 0)
      return -1;
    if (*pte & PTE_V)
      panic("remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last) {
      break;
    }
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}

uint64_t walkAddr(pagetable_t pagetable, uint64_t va)
{
  pte_t *  pte;
  uint64_t pa;

  if (va >= MAXVA)
    return 0;

  pte = walk(pagetable, va, 0);
  if (pte == 0)
    return 0;
  if ((*pte & PTE_V) == 0)
    return 0;
  // TODO 用户空间时修改
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}

void kernel_vm_map(uint64_t va, uint64_t pa, uint64_t sz, int perm)
{
  if (mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    panic("kvmmap");
}

/**
 * @brief 递归的释放页表，该页表不能包含任何映射
 * 关系。
 *
 * @param pagetable 需要释放的页表
 */
void freewalk(pagetable_t pagetable)
{
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++) {
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
      // this PTE points to a lower-level page table.
      uint64_t child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    }
    else if (pte & PTE_V) {
      panic("freewalk: leaf");
    }
  }
  memAllocator.free((void *)pagetable);
}

/**
 * @brief 释放用户页表, 首先移除全部映射关系
 * 并且释放相应的物理内存，然后释放页表包含的
 * 全部页表项
 *
 * @param pagetable 需要释放的页表
 * @param sz 页表的大小
 */
void FreeUserPageTable(pagetable_t pagetable, uint64_t sz)
{
  if (sz > 0) {
    userUnmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, true);
  }
  freewalk(pagetable);
}

uint64_t userAlloc(pagetable_t pagetable, uint64_t oldsz, uint64_t newsz)
{
  char *   mem;
  uint64_t a;
  if (newsz < oldsz)
    return oldsz;

  oldsz = PGROUNDUP(oldsz);
  for (a = oldsz; a < newsz; a += PGSIZE) {
    mem = static_cast<char *>(memAllocator.alloc());
    if (mem == 0) {
      LOG_WARN("user alloc failed");
      userDealloc(pagetable, a, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if (mappages(pagetable, a, PGSIZE, (uint64_t)mem,
                 PTE_W | PTE_X | PTE_R | PTE_U | PTE_V) != 0) {
      LOG_WARN("user map page failed");
      memAllocator.free(mem);
      userDealloc(pagetable, a, oldsz);
      return 0;
    }
  }
  return newsz;
}

void userUnmap(pagetable_t pagetable,
               uint64_t    va,
               uint64_t    npages,
               bool        do_free)
{
  uint64_t a;
  pte_t *  pte;

  if ((va % PGSIZE) != 0)
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    if ((pte = walk(pagetable, a, 0)) == 0) {
      // panic("uvmunmap: walk");
      continue;
    }
    if ((*pte & PTE_V) == 0) {
      // LOG_WARN("uvmunmap: not mapped");
      continue;
    }
    if (PTE_FLAGS(*pte) == PTE_V)
      panic("uvmunmap: not a leaf");
    if (do_free) {
      uint64_t pa = PTE2PA(*pte);
      memAllocator.free(reinterpret_cast<void *>(pa));
    }
    *pte = 0;
  }
}

uint64_t userDealloc(pagetable_t pagetable, uint64_t oldsz, uint64_t newsz)
{
  if (newsz >= oldsz)
    return oldsz;

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    userUnmap(pagetable, PGROUNDUP(newsz), npages, true);
  }

  return newsz;
}

pagetable_t userCreate()
{
  pagetable_t pagetable;
  pagetable = (pagetable_t)memAllocator.alloc();
  if (pagetable == 0)
    return 0;
  memset(pagetable, 0, PGSIZE);
  return pagetable;
}

void UserVmInit(pagetable_t pagetable, uchar_t *src, uint_t sz)
{
  char *mem;

  if (sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = static_cast<char *>(memAllocator.alloc());
  memset(mem, 0, PGSIZE);
  mappages(pagetable, 0, PGSIZE, (uint64_t)mem,
           PTE_W | PTE_R | PTE_X | PTE_U | PTE_V);
  memmove(mem, src, sz);
}

int copyin(pagetable_t pagetable, char *dst, uint64_t vsrc, uint64_t len)
{
  uint64_t n, va0, pa0;
  while (len > 0) {
    va0 = PGROUNDDOWN(vsrc);
    pa0 = walkAddr(pagetable, va0);
    if (pa0 == 0) {
      return -1;
    }
    n = PGSIZE - (vsrc - va0);
    if (n > len) {
      n = len;
    }
    memmove(dst, (void *)(pa0 + (vsrc - va0)), n);
    len -= n;
    dst += n;
    vsrc += n;
  }
  return 0;
}

int copyinstr(pagetable_t pagetable, char *dst, uint64_t vsrc, int maxsz)
{
  uint64_t va0, pa0 = 0;
  int      got_null = 0, n;
  while (got_null == 0 && maxsz > 0) {
    va0 = PGROUNDDOWN(vsrc);
    pa0 = walkAddr(pagetable, va0);
    if (pa0 == 0) {
      return -1;
    }
    n = PGSIZE - (vsrc - va0);
    if (n > maxsz) {
      n = maxsz;
    }
    char *p = (char *)(pa0 + (vsrc - va0));

    while (n > 0) {
      if (*p == 0) {
        *dst = 0;
        got_null = 1;
        break;
      }
      else {
        *dst = *p;
      }
      n--;
      maxsz--;
      dst++;
      p++;
    }
    vsrc = va0 + PGSIZE;
  }
  if (got_null) {
    return 0;
  }
  return -1;
}

int copyout(pagetable_t pagetable, uint64_t vdst, char *src, int len)
{
  uint64_t va0, pa0;
  int      n;
  while (len > 0) {
    va0 = PGROUNDDOWN(vdst);
    pa0 = walkAddr(pagetable, va0);
    if (pa0 == 0) {
      return -1;
    }
    n = PGSIZE - (vdst - va0);
    if (n > len) {
      n = len;
    }
    memmove((void *)(pa0 + (vdst - va0)), src, n);
    len -= n;
    vdst += n;
    src += n;
  }
  return 0;
}

int userVmCopy(pagetable_t oldPg, pagetable_t newPg, int sz)
{
  pte_t *  pte;
  uint64_t pa;
  uint_t   flags;
  char *   mem;
  for (int i = 0; i < sz; i += PGSIZE) {
    if ((pte = walk(oldPg, i, 0)) == 0) {
      panic("userVmCopy: pte not present");
    }
    if ((*pte & PTE_V) == 0) {
      // panic("userVmCopy: pte invalid");
      continue;
    }
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if ((mem = static_cast<char *>(memAllocator.alloc())) == 0) {
      panic("userVmCopy: alloc mem fail");
    }
    memmove(mem, (void *)pa, PGSIZE);
    if (mappages(newPg, i, PGSIZE, (uint64_t)mem, flags) < 0) {
      memAllocator.free(mem);
      panic("userVmCopy: mappages fail");
    }
  }
  return 0;
}

void vmprint(pagetable_t pagetable, int n)
{
  if (n == 1) {
    printf("page table %p\n", pagetable);
  }
  if (n >= 4) {
    return;
  }
  for (int i = 0; i < 512; i++) {
    pte_t pte = pagetable[i];
    if (pte & PTE_V) {
      for (int j = 1; j <= n; j++) {
        printf(".. ");
      }
      uint64_t child = PTE2PA(pte);
      printf("%d: pte %p pa %p\n", i, pte, child);
      vmprint((pagetable_t)child, n + 1);
    }
  }
}