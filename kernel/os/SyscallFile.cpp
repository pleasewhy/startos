#include "StartOS.hpp"
#include "common/logger.h"
#include "common/string.hpp"
#include "fs/vfs/FileSystem.hpp"
#include "fs/vfs/Vfs.hpp"
#include "memory/MemAllocator.hpp"
#include "os/Syscall.hpp"
#include "os/TaskScheduler.hpp"
#include "param.hpp"
#include "riscv.hpp"
#include "types.hpp"

uint64_t sys_getcwd(void) {
  uint64_t userBuf;
  int n;
  LOG_DEBUG("cwd");
  if (argaddr(0, &userBuf) < 0 || argint(1, &n) < 0) {
    return -1;
  }
  char *cwd = myTask()->currentDir;
  if (strlen(cwd) > n) {
    return -1;
  }
  if (either_copyout(true, userBuf, reinterpret_cast<void *>(cwd), strlen(cwd)) < 0) {
    return 0;
  }
  return userBuf;
}

uint64_t sys_open(void) {
  char path[MAXPATH];
  int fd, mode;
  int n;
  LOG_DEBUG("sys_open");
  if ((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &mode) < 0) {
    return -1;
  }

  fd = vfs::open(path, mode);
  return fd;
}

uint64_t sys_openat(void) {
  char filename[MAXPATH];
  int fd, mode, flags;
  int n;
  LOG_DEBUG("sys_openat");
  if (argint(0, &fd) < 0 || (n = argstr(1, filename, MAXPATH)) < 0) {
    return -1;
  }

  if (argint(2, &flags) || argint(3, &mode)) {
    return -1;
  }
  fd = vfs::open(filename, flags);
  LOG_DEBUG("openat fd=%d", fd);
  return fd;
}

uint64_t sys_close(void) {
  int fd;
  if (argint(0, &fd) < 0) {
    return -1;
  }
  LOG_DEBUG("sys_close");
  struct file *fp = getFileByfd(fd);
  struct Task *task = myTask();
  vfs::close(fp);
  task->lock.lock();
  task->openFiles[fd] = NULL;
  task->lock.unlock();
  LOG_DEBUG("sys_close complete");
  return 0;
}

uint64_t sys_write(void) {
  int fd, n;
  uint64_t uaddr;
  // LOG_DEBUG("sys_write");
  if (argint(0, &fd) < 0 || argint(2, &n) < 0 || argaddr(1, &uaddr) < 0) return -1;

  return vfs::write(fd, true, reinterpret_cast<char *>(uaddr), n, 0);
}

uint64_t sys_read(void) {
  int fd, n;
  uint64_t uaddr;
  // LOG_DEBUG("sys_read");
  if (argint(0, &fd) < 0 || argint(2, &n) < 0 || argaddr(1, &uaddr) < 0) return -1;

  return vfs::read(fd, true, reinterpret_cast<char *>(uaddr), n, 0);
}

uint64_t sys_dup(void) {
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

uint64_t sys_dup3(void) {
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

uint64_t sys_mkdirat(void) {
  int fd;
  char path[MAXPATH];
  if (argint(0, &fd) < 0 || argstr(1, path, MAXPATH) < 0) {
    return -1;
  }
  vfs::mkdirat(fd, path);
  return 0;
}

uint64_t sys_chdir(void) {
  char path[MAXPATH];
  memset(path, 0, MAXPATH);
  if (argstr(0, path, MAXPATH) < 0) {
    return -1;
  }
  LOG_DEBUG("chdir path=%s", path);
  return vfs::chdir(path);
}

uint64_t sys_pipe(void) {
  uint64_t fdarray;
  int fds[2];
  LOG_DEBUG("pipe");
  Task *task = myTask();
  if (argaddr(0, &fdarray) < 0) {
    return -1;
  }

  vfs::createPipe(fds);
  if (copyout(task->pagetable, fdarray, (char *)&fds[0], sizeof(fds[0])) < 0 ||
      copyout(task->pagetable, fdarray + sizeof(fds[0]), (char *)&fds[1], sizeof(fds[0])) < 0) {
    vfs::close(getFileByfd(fds[0]));
    vfs::close(getFileByfd(fds[1]));
    return -1;
  }
  return 0;
}