//
// Created by hy on 2021/1/22.
//

#include "../types.h"
#include "../param.h"
#include "../memlayout.h"
#include "../lock/lock.h"
#include "../riscv.h"
#include "../defs.h"

void free_range(void *pa_start, void *pa_end);

extern char end[]; // 内核使用的空间后的第一个地址, 在kernel.ld中定义

struct node {
    struct node *next;
};

struct {
    struct spinlock lock;
    struct node *freelist;
} kmem;

void kernel_mem_init()
{
    spinlock_init(&kmem.lock, "kmem");
    free_range(end, (void*)PHYSTOP);
}

void free_range(void *pa_start, void *pa_end)
{
    char *p;
    p = (char*)PGROUNDUP((uint64)pa_start);
    for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
        kfree(p);
}


// 释放一页pa指向的物理空间
void kfree(void *pa)
{
    struct node *r;

    if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
        panic("kfree");

    // 填充无效值
    memset(pa, 1, PGSIZE);

    r = (struct node*)pa;

    spin_lock(&kmem.lock);
    r->next = kmem.freelist;
    kmem.freelist = r;
    spin_unlock(&kmem.lock);
}

// 分配一个4096字节的物理页，返回内核能够使用的指针, 如果
// 内存耗尽会返回0。
void * kalloc(void)
{
    struct node *r;

    spin_lock(&kmem.lock);
    r = kmem.freelist;
    if(r)
        kmem.freelist = r->next;
    spin_unlock(&kmem.lock);

    if(r)
        memset((char*)r, 5, PGSIZE); // fill with junk
    return (void*)r;
}


