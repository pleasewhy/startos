#include "StartOS.hpp"
#include "common/logger.h"
#include "common/string.hpp"
#include "fcntl.h"
#include "file.h"
#include "fs/vfs/FileSystem.hpp"
#include "fs/vfs/Vfs.hpp"
#include "memory/MemAllocator.hpp"
#include "os/Syscall.hpp"
#include "os/TaskScheduler.hpp"
#include "param.hpp"
#include "riscv.hpp"
#include "types.hpp"

uint64_t sys_getcwd(void)
{
  uint64_t userBuf;
  int      n;
  LOG_DEBUG("cwd");
  if (argaddr(0, &userBuf) < 0 || argint(1, &n) < 0) {
    return -1;
  }
  char *cwd = myTask()->currentDir;
  if (strlen(cwd) > n) {
    return -1;
  }
  if (either_copyout(true, userBuf, reinterpret_cast<void *>(cwd),
                     strlen(cwd)) < 0) {
    return 0;
  }
  return userBuf;
}

uint64_t sys_open(void)
{
  char path[MAXPATH];
  int  fd, mode;
  int  n;
  LOG_DEBUG("sys_open");
  if ((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &mode) < 0) {
    return -1;
  }

  fd = vfs::open(path, mode);
  return fd;
}

uint64_t sys_unlinkat()
{
  int  fd;
  char filepath[MAXPATH];
  int  flags;
  LOG_DEBUG("sys_unlinkat");
  if (argint(0, &fd) < 0 || argstr(1, filepath, MAXPATH) < 0 ||
      argint(2, &flags) < 0) {
    LOG_DEBUG("error");
    return -1;
  }
  return vfs::rm(fd, filepath);
}

uint64_t sys_openat(void)
{
  char filename[MAXPATH];
  int  fd, mode, flags;
  int  n;
  LOG_DEBUG("sys_openat");
  if (argint(0, &fd) < 0 || (n = argstr(1, filename, MAXPATH)) < 0) {
    return -1;
  }

  if (argint(2, &flags) || argint(3, &mode)) {
    return -1;
  }
  fd = vfs::openat(fd, filename, flags, mode);
  // fd = vfs::open(filename, flags);
  LOG_DEBUG("openat fd=%d", fd);
  return fd;
}

uint64_t sys_close(void)
{
  int fd;
  if (argint(0, &fd) < 0) {
    return -1;
  }
  LOG_DEBUG("sys_close fd=%d", fd);
  struct file *fp = getFileByfd(fd);
  struct Task *task = myTask();
  vfs::close(fp);
  task->lock.lock();
  task->openFiles[fd] = NULL;
  task->lock.unlock();
  LOG_DEBUG("sys_close complete");
  return 0;
}

uint64_t sys_write(void)
{
  int      fd, n;
  uint64_t uaddr;
  // LOG_DEBUG("sys_write");
  if (argint(0, &fd) < 0 || argint(2, &n) < 0 || argaddr(1, &uaddr) < 0)
    return -1;
  if (fd >= 3) {
    LOG_DEBUG("sys_write n=%d", n);
  }
  return vfs::write(fd, true, reinterpret_cast<char *>(uaddr), n, 0);
}

uint64_t sys_read(void)
{
  int      fd, n;
  uint64_t uaddr;
  // LOG_DEBUG("sys_read");
  if (argint(0, &fd) < 0 || argint(2, &n) < 0 || argaddr(1, &uaddr) < 0)
    return -1;

  return vfs::read(fd, true, reinterpret_cast<char *>(uaddr), n, 0);
}

uint64_t sys_dup(void)
{
  int fd;
  if (argint(0, &fd) < 0) {
    return -1;
  }
  struct file *fp = getFileByfd(fd);
  if (fp == NULL) {
    return -1;
  }
  LOG_DEBUG("dup fd=%d fp=%p fp->ref=%d\n", fd, fp, fp->ref);
  vfs::dup(fp);
  return registerFileHandle(fp);
}

uint64_t sys_dup3(void)
{
  int oldfd, newfd, ansfd;
  if (argint(0, &oldfd) < 0 || argint(1, &newfd) < 0) {
    return -1;
  }
  LOG_DEBUG("old fd=%d new fd=%d", oldfd, newfd);
  struct file *fp = getFileByfd(oldfd);
  vfs::dup(fp);
  ansfd = registerFileHandle(fp, newfd);
  if (ansfd < 0) {
    vfs::close(fp);
  }
  return ansfd;
}

uint64_t sys_mkdirat(void)
{
  int  fd;
  char path[MAXPATH];
  if (argint(0, &fd) < 0 || argstr(1, path, MAXPATH) < 0) {
    return -1;
  }
  vfs::mkdirat(fd, path);
  return 0;
}

uint64_t sys_chdir(void)
{
  char path[MAXPATH];
  memset(path, 0, MAXPATH);
  if (argstr(0, path, MAXPATH) < 0) {
    return -1;
  }
  LOG_DEBUG("chdir path=%s", path);
  return vfs::chdir(path);
}

uint64_t sys_pipe(void)
{
  uint64_t fdarray;
  int      fds[2];
  LOG_DEBUG("pipe");
  Task *task = myTask();
  if (argaddr(0, &fdarray) < 0) {
    return -1;
  }

  vfs::createPipe(fds);
  if (copyout(task->pagetable, fdarray, (char *)&fds[0], sizeof(fds[0])) < 0 ||
      copyout(task->pagetable, fdarray + sizeof(fds[0]), (char *)&fds[1],
              sizeof(fds[0])) < 0) {
    vfs::close(getFileByfd(fds[0]));
    vfs::close(getFileByfd(fds[1]));
    return -1;
  }
  return 0;
}

uint64_t sys_getdents64(void)
{
  uint64_t addr;
  int      fd;
  int      len;
  if (argint(0, &fd) < 0 || argaddr(1, &addr) || argint(2, &len)) {
    return -1;
  }
  LOG_DEBUG("getdents64 fd=%d", fd);
  int n = vfs::ls(fd, (char *)addr, len, true);
  LOG_DEBUG("getdents64 nread=%d", n);
  // printf("%d",n);
  return n;
}

uint64_t sys_mount()
{
  char special[MAXPATH];
  char dir[MAXPATH];
  char fstype[MAXFSTYPE];
  if (argstr(0, special, MAXPATH) < 0 || argstr(1, dir, MAXPATH) < 0 ||
      argstr(2, fstype, MAXFSTYPE) < 0) {
    return -1;
  }

  if (strncmp(fstype, "vfat", 4) == 0) {
    vfs::mount(vfs::FileSystemType::FAT32, dir, special);
    return 0;
  }
  return -1;
}

uint64_t sys_umount2()
{
  char dir[MAXPATH];
  int  type;
  if (argstr(0, dir, MAXPATH) < 0 || argint(1, &type) < 0) {
    return -1;
  }
  return vfs::umount(dir);
}

uint64_t sys_fstat()
{
  int          fd;
  struct file *fp;
  struct kstat kst;
  uint64_t     kstAddr;
  if (argfd(0, &fd, &fp) < 0 || argaddr(1, &kstAddr) < 0) {
    return -1;
  }
  memset(&kst, 0, sizeof(struct kstat));
  kst.st_dev = 1;
  kst.st_size = fp->size;
  kst.st_nlink = 1;
  if (fp->directory)
    kst.st_mode |= __S_IFDIR;
  else
    kst.st_mode |= __S_IFREG;
  return copyout(myTask()->pagetable, kstAddr, reinterpret_cast<char *>(&kst),
                 sizeof(struct kstat));
}

uint64_t sys_mmap(void)
{
  uint64_t     addr;
  int          length, prot, flags, fd, offset;
  int          vmasz = 0;
  struct vma * a;
  struct file *f;
  Task *       task = myTask();
  if (argaddr(0, &addr) < 0)
    return -1;

  if (argint(1, &length) < 0)
    return -1;

  if (argint(2, &prot) < 0)
    return -1;

  if (argint(3, &flags) < 0)
    return -1;

  if (argfd(4, &fd, &f) < 0)
    return -1;

  if (argint(5, &offset) < 0)
    return -1;

  if (!f->readable && (prot & PROT_READ))
    return -1;

  if (!f->writable && (prot & PROT_WRITE) && (flags & MAP_SHARED))
    return -1;

  a = allocVma();

  vfs::dup(f);
  f->offset = 0;
  vfs::rewind(f);

  a->f = f;
  a->length = length;
  for (int i = 0; i < NOMMAPFILE; i++) {
    if (task->vma[i] != 0)
      vmasz += task->vma[i]->length;
  }
  a->addr = PGROUNDDOWN(MAXVA - PGSIZE * 5 - vmasz - length);
  // 设置权限
  a->prot = prot;
  a->flag = flags;
  for (int i = 0; i < NOMMAPFILE; i++) {
    if (task->vma[i] == 0) {
      task->vma[i] = a;
      break;
    }
  }
  return a->addr;
}

uint64_t sys_munmap(void)
{
  LOG_DEBUG("mummap");
  Task *      task = myTask();
  uint64_t    addr;
  struct vma *vma = 0;
  int         index = 0;
  int         sz;
  if (task->vma == 0)
    return -1;

  if (argaddr(0, &addr) < 0)
    return -1;
  if (argint(1, &sz) < 0)
    return -1;

  for (int i = 0; i < NOMMAPFILE; i++) {
    if (task->vma[i] != 0 && addr >= task->vma[i]->addr &&
        addr < task->vma[i]->addr + task->vma[i]->length) {
      vma = task->vma[i];
      index = i;
      break;
    }
  }
  if (vma == 0)
    return -1;
  if (vma->flag & MAP_SHARED) {
    vfs::rewind(vma->f);
    vfs::write(vma->f, true, (const char *)(vma->addr), sz, 0);
  }
  userUnmap(task->pagetable, addr, PGROUNDUP(sz) / PGSIZE, 0);
  vma->length -= sz;
  if (vma->length == 0) {
    vfs::close(vma->f);
    freeVma(vma);
    task->vma[index] = 0;
  }
  LOG_DEBUG("mummap finish");
  return 0;
}