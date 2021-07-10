#include "Elf.hpp"
#include "startos/binformat.hpp"
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

const char *env[] = {
    "SHELL=shell",
    "PWD=/",
    "HOME=/",
    "USER=root",
    "MOTD_SHOWN=pam",
    "LANG=C.UTF-8",
    "INVOCATION_ID=e9500a871cf044d9886a157f53826684",
    "TERM=vt220",
    "SHLVL=2",
    "JOURNAL_STREAM=8:9265",
    "PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games",
    "OLDPWD=/root",
    "_=busybox",
    0};

__attribute__((used)) static int loadseg(pagetable_t   pagetable,
                                         uint64_t      va,
                                         struct inode *ip,
                                         uint_t        offset,
                                         uint_t        sz);

#define ELF_MIN_ALIGN PGSIZE

#define ELF_PAGESTART(_v) ((_v) & ~(unsigned long)(ELF_MIN_ALIGN - 1))
#define ELF_PAGEOFFSET(_v) ((_v) & (ELF_MIN_ALIGN - 1))
#define ELF_PAGEALIGN(_v) (((_v) + ELF_MIN_ALIGN - 1) & ~(ELF_MIN_ALIGN - 1))

static int LazyLoadSeg(struct Task *task, struct inode *ip, struct proghdr *ph)
{
  struct vma *vma = allocVma();
  // LOG_DEBUG("\nfilesz=%d, vaddr=%d mmsize=%d\n", ph->filesz, ph->vaddr);
  // unsigned long size = ph->filesz + ELF_PAGEOFFSET(ph->vaddr);
  // unsigned long off = ph->off - ELF_PAGEOFFSET(ph->vaddr);

  // uint64_t addr = ELF_PAGESTART(ph->vaddr);
  // size = ELF_PAGEALIGN(size);

  vma->ip = ip->dup();
  vma->flag = MAP_PRIVATE;
  vma->prot = PROT_EXEC | PROT_READ | PROT_WRITE;
  vma->offset = ph->off;
  vma->type = vma->PROG;
  vma->length = ph->filesz;
  vma->addr = ph->vaddr;
  for (int i = 0; i < NOMMAPFILE; i++) {
    if (task->vma[i] == 0) {
      task->vma[i] = vma;
      return 0;
    }
  }
  panic("lazy load segment");
  return -1;
}

uint64_t CreateUserStack(struct BinProgram *bin_program, struct elfhdr *elf)
{
  int index = bin_program->argc + bin_program->envc + 2;

  uint64_t filename = bin_program->CopyString("./busybox");
#define NEW_AUX_ENT(id, val)                                                   \
  do {                                                                         \
    bin_program->ustack[index++] = id;                                         \
    bin_program->ustack[index++] = val;                                        \
  } while (0)

  // 1
  // 2
  NEW_AUX_ENT(0x28, 0);
  NEW_AUX_ENT(0x29, 0);
  NEW_AUX_ENT(0x2a, 0);
  NEW_AUX_ENT(0x2b, 0);
  NEW_AUX_ENT(0x2c, 0);
  NEW_AUX_ENT(0x2d, 0);

  NEW_AUX_ENT(AT_PHDR, elf->phoff);               // 3
  NEW_AUX_ENT(AT_PHENT, sizeof(struct proghdr));  // 4
  NEW_AUX_ENT(AT_PHNUM, elf->phnum);              // 5
  NEW_AUX_ENT(AT_PAGESZ, 0x1000);                 // 6
  NEW_AUX_ENT(AT_BASE, 0);                        // 7
  NEW_AUX_ENT(AT_FLAGS, 0);                       // 8
  NEW_AUX_ENT(AT_ENTRY, elf->entry);              // 9
  NEW_AUX_ENT(AT_UID, 0);                         // 11
  NEW_AUX_ENT(AT_EUID, 0);                        // 12
  NEW_AUX_ENT(AT_GID, 0);                         // 13
  NEW_AUX_ENT(AT_EGID, 0);                        // 14
  NEW_AUX_ENT(AT_HWCAP, 0x112d);                  // 16
  NEW_AUX_ENT(AT_CLKTCK, 64);                     // 17
  NEW_AUX_ENT(AT_EXECFN, filename);               // 31
  NEW_AUX_ENT(0, 0);
#undef NEW_AUX_ENT
  bin_program->sp -= sizeof(uint64_t) * index;
  if (copyout(bin_program->pagetable, bin_program->sp,
              (char *)bin_program->ustack, sizeof(uint64_t) * index)) {
    return -1;
  }
  uint64_t argc = bin_program->argc;
  bin_program->sp -= sizeof(uint64_t);
  copyout(bin_program->pagetable, bin_program->sp, (char *)&argc,
          sizeof(uint64_t));
  return 0;
}

int exec(char *path, char **argv)
{
  int            i, off, oldsz;
  uint64_t       sz = 0, stackbase, sp, a0 = 0;
  uint64_t       ustack[MAXARG + 1];  // 最后一项为0，用于标记结束
  pagetable_t    old_pagetable;
  struct elfhdr  elf;
  struct inode * ip;
  struct proghdr ph;
  pagetable_t    pagetable = 0;
  Task *         task = myTask();
  BinProgram     bin_prog;

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
    if (LazyLoadSeg(task, ip, &ph) < 0) {
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

  sp -= sizeof(uint64_t);
  a0 = sp;

  // 先将参数push到用户栈中，并准备ustack数组，它的每一个
  // 元素都按顺序指向参数。

  bin_prog.stack_top = 0;
  bin_prog.sp = sp;
  bin_prog.stackbase = stackbase;
  bin_prog.pagetable = pagetable;
  bin_prog.ustack = ustack;

  bin_prog.argc = bin_prog.CopyString2Stack(argv);
  bin_prog.envc = bin_prog.CopyString2Stack((char **)env);
  CreateUserStack(&bin_prog, &elf);

  sp = bin_prog.sp;

  // 用户代码main(argc, argv)的参数
  // argc通过系统调用返回，也就是a0
  task->trapframe->a1 = sp;
  // 保存程序名
  char *last, *s;
  for (last = s = path; *s; s++)
    if (*s == '/')
      last = s + 1;
  safestrcpy(task->name, last, sizeof(task->name) + 1);

  task->trapframe->ra = 0;
  old_pagetable = task->pagetable;
  task->pagetable = pagetable;
  task->sz = sz;
  task->trapframe->epc = elf.entry;
  task->trapframe->sp = sp;
  LOG_DEBUG("sp=%p oldsz=%d entry=%p", sp, oldsz, elf.entry);
  FreeTaskPagetable(old_pagetable, oldsz);
  ip->free();
  task->lock.lock();
  task->lock.unlock();
  return -20;

bad:
  ip->free();
  LOG_DEBUG("exec bad, path=%s", path);
  // TODO FIXME 释放VMA
  if (pagetable)
    FreeTaskPagetable(pagetable, sz);
  return a0;
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
