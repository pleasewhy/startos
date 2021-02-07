#include "../types.h"
#include "../param.h"
#include "../memlayout.h"
#include "../riscv.h"
#include "../lock/lock.h"
#include "../process.h"
#include "../defs.h"
#include "elf.h"

static int loadseg(pte_t *pagetable, uint64 addr, struct inode *ip, uint offset, uint sz);

int exec(char *path, char **argv) {

    int i, off;
    uint64 sz = 0;
    struct elfhdr elf;
    struct inode *ip;
    struct proghdr ph;
    pagetable_t pagetable = 0;
    struct proc *p = myproc();


    if((pagetable = proc_pagetable(p))==0){
        return 0;
    }

    if ((ip = namei(path)) == 0) {
        return 0;
    }
    lock_inode(ip);

    // 检查ELF头
    if (read_inode(ip, (uint64) &elf, 0, sizeof(elf)) != sizeof(elf))
        goto bad;
    if (elf.magic != ELF_MAGIC)
        goto bad;

    // 加载程序到内存中
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
        if (read_inode(ip, (uint64) &ph, off, sizeof(ph)) != sizeof(ph))
            goto bad;
        if (ph.type != ELF_PROG_LOAD)
            continue;
        if (ph.memsz < ph.filesz)
            goto bad;
        if (ph.vaddr + ph.memsz < ph.vaddr)
            goto bad;
        uint64 sz1;
        if ((sz1 = user_vm_alloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
            goto bad;
        sz = sz1;
        if (ph.vaddr % PGSIZE != 0)
            goto bad;
        if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
            goto bad;
    }
    unlock_and_putback(ip);
    ip = 0;

    // 设置用户空间栈
    // 用户空间栈大小为一页(4096字节), 其被放置在程序空间最后一页
    // 的下一页, 注意，栈是从上向下增长的。
    sz = PGROUNDUP(sz);
    uint64 sz1;
    if ((sz1 = user_vm_alloc(pagetable, sz, sz+PGSIZE)) == 0)
        goto bad;
    sz = sz1;
    // TODO 将运行程序的参数添加到栈中
    p->pagetable = pagetable;
    p->trapframe->epc = elf.entry;
    p->trapframe->sp = sz;
    p->sz = sz;
    return 0;

    bad:
    panic("exec");
    // TODO 处理失败情况
    return 0;
}


/**
 * 将程序段加载到给定的pagetable的虚拟地址va处。
 * va必须是按列对齐的并且va到va+sz的虚拟地址必须已经被映射。
 * 成功返回0，失败返回-1。
 *
 * @param pagetable 给定的pagetable
 * @param va 段被加载到的虚拟地址
 * @param ip 该可执行文件的inode
 * @param offset
 * @param sz 段在文件中的偏移量
 * @return 是否成功
 */
static int loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz) {
    uint i, n;
    uint64 pa;

    if ((va % PGSIZE) != 0)
        panic("loadseg: va must be page aligned");

    for (i = 0; i < sz; i += PGSIZE) {
        pa = walkaddr(pagetable, va + i);
        if (pa == 0)
            panic("loadseg: address should exist");
        if (sz - i < PGSIZE)
            n = sz - i;
        else
            n = PGSIZE;
        if (read_inode(ip, (uint64) pa, offset + i, n) != n)
            return -1;
    }

    return 0;
}

