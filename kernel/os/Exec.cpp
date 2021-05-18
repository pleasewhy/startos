#include "Elf.hpp"
#include "common/printk.hpp"
#include "common/string.hpp"
#include "fs/vfs/Vfs.hpp"
#include "memlayout.hpp"
#include "os/TaskScheduler.hpp"
#include "param.hpp"
#include "riscv.hpp"
#include "common/logger.h"
#include "types.hpp"

static int loadseg(pte_t *pagetable, uint64_t addr, const char *path, uint_t offset, uint_t sz);

int exec(char *path, char **argv) {
  int i, off, argc;
  uint64_t sz = 0, stackbase, sp;
  uint64_t ustack[MAXARG + 1];  // 最后一项为0，用于标记结束
  struct elfhdr elf;
  // struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0;
  Task *task = myTask();

  if ((pagetable = taskPagetable(task)) == 0) {
    return 0;
  }

  // if ((ip = namei(path)) == 0) {
  //     return 0;
  // }

  // lock_inode(ip);

  // 检查ELF头
    LOG_DEBUG("exec0");
  if (vfs::direct_read(path, reinterpret_cast<char *>(&elf), sizeof(elf), 0) != sizeof(elf)) {
    LOG_DEBUG("exec read error");
    goto bad;
  }
  LOG_DEBUG("exec1");
  // if (read_inode(ip, 0, (uint64_t) &elf, 0, sizeof(elf)) != sizeof(elf))
  //     goto bad;
  if (elf.magic != ELF_MAGIC) goto bad;

  // 加载程序到内存中
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    if (vfs::direct_read(path, reinterpret_cast<char *>(&ph), sizeof(ph), off) != sizeof(ph)) {
      goto bad;
    }
    // if (read_inode(ip, 0, (uint64_t) &ph, off, sizeof(ph)) != sizeof(ph))
    //     goto bad;
    if (ph.type != ELF_PROG_LOAD) continue;
    if (ph.memsz < ph.filesz) goto bad;
    if (ph.vaddr + ph.memsz < ph.vaddr) goto bad;
    uint64_t sz1;
    if ((sz1 = userAlloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0) goto bad;
    sz = sz1;
    if (ph.vaddr % PGSIZE != 0) goto bad;
    if (loadseg(pagetable, ph.vaddr, path, ph.off, ph.filesz) < 0) goto bad;
  }
  // unlock_and_putback(ip);
  // ip = 0;
  LOG_DEBUG("exec2");
  // 设置用户空间栈
  // 用户空间栈大小为一页(4096字节), 其被放置在程序空间最后一页
  // 的下一页, 注意，栈是从上向下增长的。
  sz = PGROUNDUP(sz);
  uint64_t sz1;
  if ((sz1 = userAlloc(pagetable, sz, sz + PGSIZE)) == 0) goto bad;
  sz = sz1;
  sp = sz;
  stackbase = sz - PGSIZE;

  // 先将参数push到用户栈中，并准备ustack数组，它的每一个
  // 元素都按顺序指向参数。
  for (argc = 0; argv[argc]; argc++) {
    if (argc > MAXARG) goto bad;
    sp -= strlen(argv[argc]) + 1;
    sp -= sp % 16;
    if (sp < stackbase) {
      goto bad;
    }
    if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0) goto bad;
    ustack[argc] = sp;
  }
  ustack[argc] = 0;

  // push argv指针数组
  sp -= (argc + 1) * sizeof(uint64_t);
  sp -= sp % 16;
  if (sp < stackbase) {
    goto bad;
  }
  if (copyout(pagetable, sp, (char *)ustack, (argc + 2) * sizeof(uint64_t)) < 0) goto bad;

  // 用户代码main(argc, argv)的参数
  // argc通过系统调用返回，也就是a0
  task->trapframe->a1 = sp;
  // 保存程序名
  char *last, *s;
  for (last = s = path; *s; s++)
    if (*s == '/') last = s + 1;
  safestrcpy(task->name, last, sizeof(task->name)+1);

  task->pagetable = pagetable;
  task->sz = sz;
  task->trapframe->epc = elf.entry;
  task->trapframe->sp = sp;
  return argc;

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
static int loadseg(pagetable_t pagetable, uint64_t va, const char *path, uint_t offset, uint_t sz) {
  uint_t i, n;
  uint64_t pa;

  if ((va % PGSIZE) != 0) panic("loadseg: va must be page aligned");

  for (i = 0; i < sz; i += PGSIZE) {
    pa = walkAddr(pagetable, va + i);
    if (pa == 0) panic("loadseg: address should exist");
    if (sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(vfs::direct_read(path, reinterpret_cast<char *>(pa), n, offset + i) != n)
      return -1;
    // if (read_inode(ip, 0, (uint64_t)pa, offset + i, n) != n) return -1;
  }

  return 0;
}
