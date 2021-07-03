#include "Elf.hpp"
#include "common/printk.hpp"
#include "common/string.hpp"
#include "fs/vfs/Vfs.hpp"
#include "fs/vfs/vfs.hpp"
#include "memlayout.hpp"
#include "os/TaskScheduler.hpp"
#include "param.hpp"
#include "riscv.hpp"
#include "common/logger.h"
#include "types.hpp"

__attribute__((used)) static int loadseg(pagetable_t   pagetable,
                                         uint64_t      va,
                                         struct inode *ip,
                                         uint_t        offset,
                                         uint_t        sz);

static int LazyLoadSeg(
    struct Task *task, struct inode *ip, uint32_t off, uint64_t va, int len)
{
  struct vma *vma = allocVma();
  vma->ip = ip->dup();
  vma->flag = MAP_PRIVATE;
  vma->prot = PROT_EXEC | PROT_READ | PROT_WRITE;
  vma->offset = off;
  vma->type = vma->PROG;
  vma->length = len;
  vma->addr = (va);
  for (int i = 0; i < NOMMAPFILE; i++) {
    if (task->vma[i] == 0) {
      task->vma[i] = vma;
      return 0;
    }
  }
  panic("lazy load segment");
  return -1;
}

int exec(char *path, char **argv)
{
  int            i, off, argc, oldsz;
  uint64_t       sz = 0, stackbase, sp;
  uint64_t       ustack[MAXARG + 1];  // 最后一项为0，用于标记结束
  pagetable_t    old_pagetable;
  struct elfhdr  elf;
  struct inode * ip;
  struct proghdr ph;
  pagetable_t    pagetable = 0;
  Task *         task = myTask();

  LOG_DEBUG("exec start");
  if ((pagetable = taskPagetable(task)) == 0) {
    return 0;
  }
  if ((ip = vfs::VfsManager::namei(nullptr, path)) == nullptr) {
    return 0;
  }

  // lock_inode(ip);
  // ip->lock();
  // 检查ELF头
  memset(&elf, 0, sizeof(elf));
  if (ip->read(reinterpret_cast<char *>(&elf), 0, sizeof(elf), false) !=
      sizeof(elf)) {
    LOG_DEBUG("exec read error");
    goto bad;
  }
  // if (read_inode(ip, 0, (uint64_t) &elf, 0, sizeof(elf)) != sizeof(elf))
  //     goto bad;
  for (int i = 0; i < NOMMAPFILE; i++) {
    struct vma *a = task->vma[i];
    if (a != 0 && a->type == a->PROG) {
      a->free();
      LOG_DEBUG("free vma");
      task->vma[i] = 0;
    }
  }

  if (elf.magic != ELF_MAGIC) {
    LOG_DEBUG("not a elf file,elf=%p", elf.magic);
    LOG_DEBUG("entry=%d", elf.entry);
    LOG_DEBUG("version=%d", elf.version);
    LOG_DEBUG("sz=%d", ip->sz);
    LOG_DEBUG("name=%s", ip->test_name);
    goto bad;
  }
  oldsz = task->sz;
  // 加载程序到内存中
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    LOG_DEBUG("i=%d", i);
    if (ip->read(reinterpret_cast<char *>(&ph), off, sizeof(ph), false) !=
        sizeof(ph)) {
      LOG_DEBUG("read inode error");
      goto bad;
    }
    // if (vfs::direct_read(path, reinterpret_cast<char *>(&ph), sizeof(ph),
    //                      off) != sizeof(ph)) {
    //   goto bad;
    // }
    if (ph.type != ELF_PROG_LOAD)
      continue;
    if (ph.memsz < ph.filesz)
      goto bad;
    if (ph.vaddr + ph.memsz < ph.vaddr)
      goto bad;
    uint64_t sz1;
    sz1 = ph.vaddr + ph.memsz;
    // if ((sz1 = userAlloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    //   goto bad;
    sz = sz1;
    if (ph.vaddr % PGSIZE != 0) {
      LOG_DEBUG("type=%d", ph.type);
      LOG_DEBUG("need align pgsize");
      // goto bad;
    }
    if (LazyLoadSeg(task, ip, ph.off, ph.vaddr, ph.filesz) < 0) {
      goto bad;
    }
    // if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    // goto bad;
  }
  LOG_DEBUG("exec2");
  // unlock_and_putback(ip);
  // ip = 0;
  // LOG_DEBUG("exec2");
  // 设置用户空间栈
  // 用户空间栈大小为一页(4096字节), 其被放置在程序空间最后一页
  // 的下一页, 注意，栈是从上向下增长的。
  LOG_DEBUG("exec task sz=%x", sz);
  sz = PGROUNDUP(sz);
  uint64_t sz1;
  if ((sz1 = userAlloc(pagetable, sz, sz + PGSIZE)) == 0)
    goto bad;
  sz = sz1;
  sp = sz;
  stackbase = sz - PGSIZE;

  // 先将参数push到用户栈中，并准备ustack数组，它的每一个
  // 元素都按顺序指向参数。
  for (argc = 0; argv[argc]; argc++) {
    if (argc > MAXARG)
      goto bad;
    sp -= strlen(argv[argc]) + 1;
    sp -= sp % 16;
    if (sp < stackbase) {
      goto bad;
    }
    if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[argc] = sp;
  }
  ustack[argc] = 0;

  // push argv指针数组
  sp -= (argc + 1) * sizeof(uint64_t);
  sp -= sp % 16;
  if (sp < stackbase) {
    goto bad;
  }

  if (copyout(pagetable, sp, (char *)ustack, (argc + 2) * sizeof(uint64_t)) < 0)
    goto bad;

  // 用户代码main(argc, argv)的参数
  // argc通过系统调用返回，也就是a0
  task->trapframe->a1 = sp;
  // 保存程序名
  char *last, *s;
  for (last = s = path; *s; s++)
    if (*s == '/')
      last = s + 1;
  safestrcpy(task->name, last, sizeof(task->name) + 1);

  old_pagetable = task->pagetable;
  task->pagetable = pagetable;
  task->sz = sz;
  task->trapframe->epc = elf.entry;
  task->trapframe->sp = sp;
  LOG_DEBUG("sp=%p oldsz=%d", sp, oldsz);
  FreeTaskPagetable(old_pagetable, oldsz);
  ip->free();
  task->lock.lock();
  task->lock.unlock();
  return argc;

bad:
  ip->free();
  LOG_DEBUG("exec bad, path=%s", path);
  // TODO FIXME 释放VMA
  if (pagetable)
    FreeTaskPagetable(pagetable, sz);
  return -1;
}

/**
 * 将程序段加载到给定的pagetable的虚拟地址va处。
 * va必须是按列对齐的并且va到va+sz的虚拟地址必须已经被映射。
 * 成功返回0，失败返回-1。
 *
 * @param pagetable 给定的pagetable
 * @param va 段被加载到的虚拟地址
 * @param ip 该可执行文件的inode
 * @param offset 段在文件中的偏移量
 * @param sz
 * @return 是否成功
 */
static int loadseg(pagetable_t   pagetable,
                   uint64_t      va,
                   struct inode *ip,
                   uint_t        offset,
                   uint_t        sz)
{
  uint_t   i, n;
  uint64_t pa;

  LOG_DEBUG("sz=%d", sz);
  // if ((va % PGSIZE) != 0)
  //   panic("loadseg: va must be page aligned");

  uint32_t newsz = sz > 10 * PGSIZE ? 10 * PGSIZE : sz;

  for (i = 0; i < newsz; i += n) {
    LOG_DEBUG("i=%d offset=%p newsz=%d", i, offset, newsz);
    pa = walkAddr(pagetable, va + i);
    if (pa == 0)
      panic("loadseg: address should exist");
    pa += (va + i) % PGSIZE;
    n = min(newsz - i, PGSIZE - pa % PGSIZE);
    LOG_DEBUG("va=%p pa=%p n=%d", va, pa, n);
    // if (newsz - i < PGSIZE)
    // n = newsz - i;
    // else
    // n = PGSIZE;
    if (ip->read(reinterpret_cast<char *>(pa), offset + i, n, false) != n) {
      return -1;
    }
  }
  return 0;
}
