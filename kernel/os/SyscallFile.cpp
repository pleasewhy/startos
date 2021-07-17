#include "StartOS.hpp"
#include "common/logger.h"
#include "common/string.hpp"
#include "fcntl.h"
#include "file.h"
#include "fs/vfs/FileSystem.hpp"
#include "fs/vfs/Vfs.hpp"
#include "fs/vfs/vfs.hpp"
#include "memory/MemAllocator.hpp"
#include "os/Syscall.hpp"
#include "os/TaskScheduler.hpp"
#include "param.hpp"
#include "riscv.hpp"
#include "types.hpp"
#include "io.h"
#include "poll.h"

uint64_t sys_getcwd(void)
{
  uint64_t userBuf;
  int      n;
  LOG_TRACE("cwd");
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
  int  flag;
  int  n;
  LOG_TRACE("sys_open");
  if ((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &flag) < 0) {
    LOG_TRACE("error");
    return -1;
  }
  struct file *fp = vfs::VfsManager::openat(nullptr, path, flag, 0);
  if (fp == nullptr) {
    return -1;
  }
  return registerFileHandle(fp);
}

uint64_t sys_unlinkat()
{
  int  fd;
  char filepath[MAXPATH];
  int  flags;
  LOG_TRACE("sys_unlinkat");
  if (argint(0, &fd) < 0 || argstr(1, filepath, MAXPATH) < 0 ||
      argint(2, &flags) < 0) {
    LOG_TRACE("error");
    return -1;
  }
  return vfs::rm(fd, filepath);
}

uint64_t sys_openat(void)
{
  char filename[MAXPATH];
  int  dirfd, mode, flags;
  int  n;
  LOG_TRACE("sys_openat dirfd=%d");
  if (argint(0, &dirfd) < 0 || (n = argstr(1, filename, MAXPATH)) < 0) {
    return -1;
  }

  if (argint(2, &flags) || argint(3, &mode)) {
    return -1;
  }
  struct file *dirfp = getFileByfd(dirfd);
  struct file *fp = vfs::VfsManager::openat(dirfp, filename, flags, mode);
  if (fp == nullptr) {
    return -1;
  }
  int fd = registerFileHandle(fp);
  LOG_TRACE("openat fd=%d", fd);
  return fd;
}

uint64_t sys_close(void)
{
  int fd;
  if (argint(0, &fd) < 0) {
    return -1;
  }
  if (fd < 0) {
    return -1;
  }
  LOG_TRACE("sys_close fd=%d", fd);
  struct file *fp = getFileByfd(fd);
  struct Task *task = myTask();
  vfs::VfsManager::close(fp);
  task->lock.lock();
  task->openFiles[fd] = NULL;
  task->lock.unlock();
  LOG_TRACE("sys_close complete");
  return 0;
}

uint64_t sys_write(void)
{
  int      fd, n;
  uint64_t uaddr;
  // LOG_TRACE("sys_write");
  if (argint(0, &fd) < 0 || argint(2, &n) < 0 || argaddr(1, &uaddr) < 0)
    return -1;
  if (fd >= 3) {
    LOG_TRACE("sys_write fd=%d n=%d", fd, n);
  }
  struct file *fp = getFileByfd(fd);
  return vfs::VfsManager::write(fp, (const char *)(uaddr), n, true);
  // return vfs::write(fd, true, reinterpret_cast<char *>(uaddr), n, 0);
}

uint64_t sys_writev()
{
  int      fd;
  int      n;
  uint64_t iovec_addr;
  if (argint(0, &fd) < 0 || argint(2, &n) < 0 || argaddr(1, &iovec_addr) < 0)
    return -1;
  if (n > 10)
    return -1;
  struct iovec vec[10];
  if (copyin(myTask()->pagetable, (char *)vec, iovec_addr,
             n * sizeof(struct iovec)) < 0)
    return -1;
  struct file *fp = getFileByfd(fd);

  int nwrite = 0;
  for (int i = 0; i < n; i++) {
    nwrite += vfs::VfsManager::write(fp, (const char *)(vec[i].iov_base),
                                     vec[i].iov_len, true);
  }
  return nwrite;
}

uint64_t sys_read(void)
{
  int      fd, n;
  uint64_t uaddr;
  // LOG_TRACE("sys_read");
  if (argint(0, &fd) < 0 || argint(2, &n) < 0 || argaddr(1, &uaddr) < 0)
    return -1;
  struct file *fp = getFileByfd(fd);
  return vfs::VfsManager::read(fp, reinterpret_cast<char *>(uaddr), n, true);
}

uint64_t sys_readlinkat()
{
  int        dirfd, n;
  char       filename[MAXPATH];
  const char s[] = "/busybox";
  LOG_TRACE("readlinkat");
  uint64_t ubuf;  // 用户缓冲区
  if (argint(0, &dirfd) < 0 || argstr(1, filename, MAXPATH) < 0)
    return -1;
  if (argaddr(2, &ubuf) < 0 || argint(3, &n))
    return -1;
  copyout(myTask()->pagetable, ubuf, (char *)s, sizeof(s) + 1);
  LOG_TRACE("s=%s n=%d", s, sizeof(s));
  return sizeof(s);
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
  LOG_TRACE("dup fd=%d fp=%p fp->ref=%d\n", fd, fp, fp->ref);
  fp = vfs::VfsManager::dup(fp);
  return registerFileHandle(fp);
}

uint64_t sys_dup3(void)
{
  int oldfd, newfd, ansfd;
  if (argint(0, &oldfd) < 0 || argint(1, &newfd) < 0) {
    return -1;
  }
  printf("old fd=%d new fd=%d\n", oldfd, newfd);
  struct file *fp = getFileByfd(oldfd);
  fp = vfs::VfsManager::dup(fp);
  if (myTask()->openFiles[newfd] != nullptr) {
    vfs::VfsManager::close(myTask()->openFiles[newfd]);
    myTask()->openFiles[newfd] = nullptr;
  }
  ansfd = registerFileHandle(fp, newfd);
  if (ansfd < 0) {
    vfs::VfsManager::close(fp);
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
  LOG_TRACE("chdir path=%s", path);
  return vfs::chdir(path);
}

uint64_t sys_pipe(void)
{
  uint64_t fdarray;
  int      fds[2];
  LOG_TRACE("pipe");
  Task *task = myTask();
  if (argaddr(0, &fdarray) < 0) {
    return -1;
  }

  vfs::VfsManager::createPipe(fds);
  if (copyout(task->pagetable, fdarray, (char *)&fds[0], sizeof(fds[0])) < 0 ||
      copyout(task->pagetable, fdarray + sizeof(fds[0]), (char *)&fds[1],
              sizeof(fds[0])) < 0) {
    vfs::VfsManager::close(getFileByfd(fds[0]));
    vfs::VfsManager::close(getFileByfd(fds[1]));
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
  LOG_TRACE("getdents64 fd=%d", fd);
  int nread =
      vfs::VfsManager::ReadDir(getFileByfd(fd), (char *)addr, len, true);
  // int n = vfs::ls(fd, (char *)addr, len, true);
  LOG_TRACE("getdents64 nread=%d", nread);
  // printf("%d",n);
  return nread;
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
  LOG_TRACE("sys_fstat");
  memset(&kst, 0, sizeof(struct kstat));
  kst.st_dev = 1;
  kst.st_size = fp->size;
  kst.st_nlink = 1;
  kst.st_mode = fp->inode->mode;
  return copyout(myTask()->pagetable, kstAddr, reinterpret_cast<char *>(&kst),
                 sizeof(struct kstat));
}

uint64_t sys_fstatat()
{
  int          dirfd;
  struct file *fp;
  char         filepath[MAXPATH];
  struct kstat kst;
  uint64_t     kst_addr;
  if (argint(0, &dirfd) < 0 || argstr(1, filepath, MAXPATH) < 0 ||
      argaddr(2, &kst_addr) < 0) {
    return -1;
  }
  LOG_TRACE("sys_fstatat");
  fp = vfs::VfsManager::openat(nullptr, filepath, O_RDWR, 0);
  if (fp == nullptr)
    return -1;
  memset(&kst, 0, sizeof(struct kstat));
  kst.st_dev = 1;
  kst.st_size = fp->size;
  kst.st_nlink = 1;
  kst.st_mode = fp->inode->mode;
  vfs::VfsManager::close(fp);
  if (copyout(myTask()->pagetable, kst_addr, reinterpret_cast<char *>(&kst),
              sizeof(struct kstat)) < 0) {
    return -1;
  }
  return 0;
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

  if (argint(4, &fd) < 0)
    return -1;

  if (argint(5, &offset) < 0)
    return -1;

  LOG_TRACE("lenth=%d pro=%p flags=%d fd=%d offset=%d", length, prot, flags, fd,
            offset);
  f = getFileByfd(fd);

  if (f != nullptr)
    panic("sys_mmap");
  // if (f == nullptr && prot != 0)
  //   return -1;

  a = allocVma();
  a->f = nullptr;
  a->ip = nullptr;
  a->length = length;
  for (int i = 0; i < NOMMAPFILE; i++) {
    if (task->vma[i] != 0)
      vmasz += task->vma[i]->length;
  }
  LOG_TRACE("vmasz=%d", vmasz);
  a->addr = PGROUNDDOWN(MAXVA - PGSIZE * 5 - vmasz - length);
  a->prot = prot | PROT_READ | PROT_WRITE | PROT_EXEC;
  a->flag = flags;

  for (int i = 0; i < NOMMAPFILE; i++) {
    if (task->vma[i] == 0) {
      LOG_TRACE("mmap addr=%p", a->addr);
      task->vma[i] = a;
      return a->addr;
    }
  }
  LOG_TRACE("mmap addr=%p", a->addr);
  panic("mmap: not enough vma im task");
  return 0;
  // if (!f->readable && (prot & PROT_READ))
  //   return -1;

  // if (!f->writable && (prot & PROT_WRITE) && (flags & MAP_SHARED))
  //   return -1;

  // // a = allocVma();

  // vfs::VfsManager::dup(f);
  // f->offset = 0;
  // vfs::rewind(f);

  // a->f = f;
  // a->length = length;
  // for (int i = 0; i < NOMMAPFILE; i++) {
  //   if (task->vma[i] != 0)
  //     vmasz += task->vma[i]->length;
  // }
  // a->addr = PGROUNDDOWN(MAXVA - PGSIZE * 5 - vmasz - length);
  // // 设置权限
  // a->prot = prot;
  // a->flag = flags;
  // for (int i = 0; i < NOMMAPFILE; i++) {
  //   if (task->vma[i] == 0) {
  //     task->vma[i] = a;
  //     break;
  //   }
  // }
  // return a->addr;
}

uint64_t sys_munmap(void)
{
  LOG_TRACE("mummap");
  // Task *      task = myTask();
  // uint64_t    addr;
  // struct vma *vma = 0;
  // int         index = 0;
  // int         sz;
  // if (task->vma == 0)
  //   return -1;

  // if (argaddr(0, &addr) < 0)
  //   return -1;
  // if (argint(1, &sz) < 0)
  //   return -1;

  // for (int i = 0; i < NOMMAPFILE; i++) {
  //   if (task->vma[i] != 0 && addr >= task->vma[i]->addr &&
  //       addr < task->vma[i]->addr + task->vma[i]->length) {
  //     vma = task->vma[i];
  //     index = i;
  //     break;
  //   }
  // }
  // if (vma == 0)
  //   return -1;
  // if (vma->flag & MAP_SHARED) {
  //   vfs::rewind(vma->f);
  //   vfs::write(vma->f, true, (const char *)(vma->addr), sz, 0);
  // }
  // userUnmap(task->pagetable, addr, PGROUNDUP(sz) / PGSIZE, 0);
  // vma->length -= sz;
  // if (vma->length == 0) {
  //   vfs::VfsManager::close(vma->f);
  //   vma->free();
  //   task->vma[index] = 0;
  // }
  // LOG_TRACE("mummap finish");
  return 0;
}

uint64_t sys_ioctl(void)
{
  return 0;
}

uint64_t sys_fcntl(void)
{
  int fd = 0;
  int cmd = 0;
  LOG_TRACE("fcntl");
  if (argint(0, &fd) < 0 || argint(1, &cmd) < 0) {
    return -1;
  }
  LOG_TRACE("fd=%d cmd=%d", fd, cmd);
  // if (cmd == F_DUPFD || cmd == F_DUPFD_CLOEXEC) {
  LOG_TRACE("F_DUPFD, F_DUPFD_CLOEXEC");
  int new_fd;
  if (argint(2, &new_fd) < 0)
    return -1;
  struct file *fp = getFileByfd(fd);
  fp = vfs::VfsManager::dup(fp);
  new_fd = myTask()->AllocFd(new_fd, -1);
  int dupfd = registerFileHandle(fp, new_fd);
  LOG_TRACE("fd=%d", dupfd);
  return dupfd;
  // }
  // return 0;
}

uint64_t sys_ppoll()
{
  struct pollfd fds[10];
  int           nfd;
  uint64_t      fds_addr;

  if (argaddr(0, &fds_addr) < 0 || argint(1, &nfd) < 0) {
    return -1;
  }
  if (nfd != 1) {
    printf("%d\n", nfd);
    panic("only support 1 pollfd");
  }

  if (copyin(myTask()->pagetable, (char *)fds, fds_addr,
             sizeof(struct pollfd) * nfd)) {
    return -1;
  }

  // if (fds[0].events)
  return 1;
}

uint64_t sys_mprotect()
{
  // uint64_t addr;
  // int      length, prot;
  LOG_TRACE("sys_mprotect");
  return 0;
  // if (argaddr(0, &addr) < 0)
  //   return -1;
  // if (argint(1, &length) < 0)
  //   return -1;
  // if (argint(2, &prot) < 0)
  //   return -1;
  // return myTask()->ModifyMemProt(addr, length, prot);
}