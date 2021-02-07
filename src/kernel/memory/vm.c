//
// Created by hy on 2021/1/22.
//

#include "../param.h"
#include "../types.h"
#include "../memlayout.h"
#include "../riscv.h"
#include "../lock/lock.h"
#include "../process.h"
#include "../defs.h"

pagetable_t kernel_pagetable;

extern char etext[];  // kernel会设置这个为内核代码结束

extern char trampoline[]; // trampoline.S

void kernel_vm_init() {
    kernel_pagetable = (pagetable_t) kalloc();
    memset(kernel_pagetable, 0, PGSIZE);

    // uart寄存器
    kernel_vm_map(UART0, UART0, PGSIZE, PTE_R | PTE_W);

    // virtio mmio 磁盘接口
    kernel_vm_map(VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);

    // CLINT
    kernel_vm_map(CLINT, CLINT, 0x10000, PTE_R | PTE_W);

    // PLIC
    kernel_vm_map(PLIC, PLIC, 0x400000, PTE_R | PTE_W);

    // map内核text可执行和可读
    kernel_vm_map(KERNBASE, KERNBASE, (uint64) etext - KERNBASE, PTE_R | PTE_X);

    // map kernel data and the physical RAM we'll make use of.
    // 映射我们需要使用的kernel data和物理RAM
    kernel_vm_map((uint64) etext, (uint64) etext, PHYSTOP - (uint64) etext, PTE_R | PTE_W);

    // trampolinez作为trap的entry/exit，会被映射到虚拟地址的顶端
    kernel_vm_map(TRAMPOLINE, (uint64) trampoline, PGSIZE, PTE_R | PTE_X);
}

/**
 * 切换页表寄存器为内核页表并启用分页
 */
void vm_hart_init() {
    w_satp(MAKE_SATP(kernel_pagetable));
    sfence_vma();
}

/**
 * 返回pagetable中与va相关联的PTE地址, 如果alloc!=0, 就会创建
 * 任何需要的页表。
 *
 * risc-v Sv39方案中，虚拟地址有三级页表页。一个页表页包含512个64位的PTE
 * 64位的虚拟地址被分为5个区域
 *   39..63 -- 必须为0
 *   30..38 -- level-2索引的9位
 *   21..29 -- level-1索引的9位
 *   12..20 -- level-0索引的9位
 *    0..11 -- 页内偏移量的12位
 *
 * @param pagetable 页表
 * @param va 需要查找PTE的va
 * @param alloc 是否创建缺失的页表
 * @return
 */
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc) {
    if (va >= MAXVA)
        panic("walk");
    for (int level = 2; level > 0; level--) {
        pte_t *pte = &pagetable[PX(level, va)];
        if (*pte & PTE_V) {
            pagetable = (pagetable_t) PTE2PA(*pte);
        } else {
            if (!alloc || (pagetable = (pte_t *) kalloc()) == 0)
                return 0;
            memset(pagetable, 0, PGSIZE);
            *pte = PA2PTE(pagetable) | PTE_V;
        }
    }
    return &pagetable[PX(0, va)];
}

/**
 * 为虚拟地址创建PTE, 将连续的虚拟地址映射到连续的物理地址。
 * 虚拟地址可能没有对齐页的大小。成功返回0, 如果walk()
 * 不能分配一个页表页就返回-1。
 *
 * @param pagetable 页表
 * @param va 虚拟地址起始地址
 * @param sz 要映射地址的大小
 * @param pa 物理地址的起始地址
 * @param perm PTE的权限
*/
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm) {
    uint64 a, last;
    pte_t *pte;

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

/**
 * 翻译一个虚拟地址, 返回相应的物理地址，如果虚拟地址不存在返回0。
 * 只能用于翻译用户空间地址。
 * @param pagetable 虚拟地址所属根页表
 * @param va 虚拟地址
 * @return 物理地址
 */
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
    pte_t *pte;
    uint64 pa;

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

/**
 * 添加虚拟地址和物理地址的映射到内核页表，只会在
 * 启动的过程中使用，在调用该函数时还没有flush TLB
 * 也没有启用分页。
 *
 */
void kernel_vm_map(uint64 va, uint64 pa, uint64 sz, int perm) {
    if (mappages(kernel_pagetable, va, sz, pa, perm) != 0)
        panic("kvmmap");
}

// Allocate PTEs and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
/**
 * 增长进程的sz从oldsz到newsz, 并分配相应PTE和物理内存，newsz不需要对齐页。
 * 返回新的sz，错误返回0
 *
 * @param pagetable
 * @param oldsz
 * @param newsz
 * @return
 */
uint64 user_vm_alloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz) {
    char *mem;
    uint64 a;
    if (newsz < oldsz)
        return oldsz;

    oldsz = PGROUNDUP(oldsz);
    for (a = oldsz; a < newsz; a += PGSIZE) {
        mem = kalloc();
        if (mem == 0) {
//            uvmdealloc(pagetable, a, oldsz);
            // TODO 失败释放
            return 0;
        }
        memset(mem, 0, PGSIZE);
        if (mappages(pagetable, a, PGSIZE, (uint64) mem, PTE_W | PTE_X | PTE_R | PTE_U) != 0) {
            kfree(mem);
//            uvmdealloc(pagetable, a, oldsz);
            // TODO 失败释放
            return 0;
        }
    }
    return newsz;
}

/**
 * 创建空的用户页表
 * 失败返回0
 * @return
 */
pagetable_t user_vm_create() {
    pagetable_t pagetable;
    pagetable = (pagetable_t) kalloc();
    if (pagetable == 0)
        return 0;
    memset(pagetable, 0, PGSIZE);
    return pagetable;
}

/**
 * 将用户initcode加载进入pagetable，只在
 * 初始化第一个进程时才会调用该函数，sz必须
 * 小于PGSIZE
 */

void user_vm_init(pagetable_t pagetable, uchar *src, uint sz) {
    char *mem;

    if (sz >= PGSIZE)
        panic("inituvm: more than a page");
    mem = kalloc();
    memset(mem, 0, PGSIZE);
    mappages(pagetable, 0, PGSIZE, (uint64) mem, PTE_W | PTE_R | PTE_X | PTE_U);
    memmove(mem, src, sz);
}

/**
 * 将用户页表中的数据copy到内核中。
 * 从给定的pagetable中，以vsrc为起点向后copy len字节到内核中的dst处。
 * 成功返回0，失败返回-1。
 */
int copyin(pagetable_t pagetable, char *dst, uint64 vsrc, uint64 len) {
    uint64 n, va0, pa0;
    while (len > 0) {
        va0 = PGROUNDDOWN(vsrc);
        pa0 = walkaddr(pagetable, va0);
        if (pa0 == 0) {
            return -1;
        }
        n = PGSIZE - (vsrc - va0);
        if (n > len) {
            n = len;
        }
        memmove(dst, (void *) (pa0 + (vsrc - va0)), n);
        len -= n;
        dst += n;
        vsrc += n;
    }
    return 0;
}

/**
 * copy用户空间的以0结束的字符串到内核空间中。
 *
 * @param pagetable 用户页表
 * @param dst 内核空间目的地址
 * @param vsrc 用户页表字符串虚拟地址
 * @param maxsz  复制字符串的最大长度
 * @return 成功返回0，错误返回-1。
 */
int copyinstr(pagetable_t pagetable, char *dst, uint64 vsrc, int maxsz) {
    uint64 n, va0, pa0 = 0;
    int got_null = 0;

    while (got_null == 0 && maxsz > 0) {
        va0 = PGROUNDDOWN(vsrc);
        pa0 = walkaddr(pagetable, va0);
        if (pa0 == 0) {
            return -1;
        }
        n = PGSIZE - (vsrc - va0);
        if (n > maxsz) {
            n = maxsz;
        }
        char *p = (char *) (pa0 + (vsrc - va0));

        while (n > 0) {
            if (*p == 0) {
                *dst = 0;
                got_null = 1;
                break;
            } else {
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

/**
 * 复制内核数据到用户页表中
 * @param pagetable 用户页表
 * @param vdst 目的用户虚拟地址
 * @param src 内核数据
 * @param len copy长度
 * @return 成功返回0，失败返回-1
 */
int copyout(pagetable_t pagetable, uint64 vdst, char *src, int len) {
    uint64 n, va0, pa0;
    while (len > 0) {
        va0 = PGROUNDDOWN(vdst);
        pa0 = walkaddr(pagetable, va0);
        if (pa0 == 0) {
            return -1;
        }
        n = PGSIZE - (vdst - va0);
        if (n > len) {
            n = len;
        }
        memmove((void *) (pa0 + (vdst - va0)), src, n);
        len -= n;
        vdst += n;
        src += n;
    }
    return 0;
}

/**
 * 将父进程的内存复制到子进程中，页表和物理内存都会被复制。
 * 成功返回0, 失败返回-1。
 * 失败会释放任何已经分配的页。
 */
int user_vm_copy(pagetable_t old, pagetable_t new, int sz) {
    pte_t *pte;
    uint64 pa;
    uint flags;
    char *mem;
    for (int i = 0; i < sz; i += PGSIZE) {
        if ((pte = walk(old, i, 0)) == 0) {
            panic("user_vm_copy: pte not present");
        }
        if ((*pte & PTE_V) == 0) {
            panic("user_vm_copy: pte invalid");
        }
        pa = PTE2PA(*pte);
        flags = PTE_FLAGS(*pte);

        if ((mem = kalloc()) == 0) {
            panic("user_vm_copy: alloc mem fail");
        }
        memmove(mem, (void *) pa, PGSIZE);
        if (mappages(new, i, PGSIZE, (uint64) mem, flags) < 0) {
            kfree(mem);
            panic("user_vm_copy: mappages fail");
        }
    }
    return 0;
}

void vmprint(pagetable_t pagetable, int n) {
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
            uint64 child = PTE2PA(pte);
            printf("%d: pte %p pa %p\n", i, pte, child);
            vmprint((pagetable_t) child, n + 1);
        }
    }
}