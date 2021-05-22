#include "StartOS.hpp"
#include "common/logger.h"
#include "common/string.hpp"
// #ifdef K210
#include "device/Clock.hpp"
// #endif
#include "fs/vfs/FileSystem.hpp"
#include "fs/vfs/Vfs.hpp"
#include "memory/MemAllocator.hpp"
#include "os/Syscall.hpp"
#include "os/TaskScheduler.hpp"
#include "os/Timer.hpp"
#include "param.hpp"
#include "riscv.hpp"
#include "time.h"
#include "types.hpp"
#include "utsname.h"

extern MemAllocator memAllocator;

uint64_t sys_exit(void) {
  int n;
  if (argint(0, &n) < 0) return -1;
  exit(n);
  return 0;  // not reached
}

uint64_t sys_fork(void) {
  LOG_DEBUG("fork");
  return fork();
}

uint64_t sys_exec(void) {
  char path[MAXPATH], *argv[MAXARG];
  LOG_DEBUG("exec");
  uint64_t uargv, uarg = 0;
  int ret = 0;
  if (argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0) return -1;
  if (strlen(path) < 1) return -1;
  memset(argv, 0, sizeof(argv));
  for (int i = 0;; i++) {
    if (i > MAXARG) goto bad;
    if (uargv != 0 && fetchaddr(uargv + sizeof(uint64_t) * i, &uarg) < 0) goto bad;
    if (uarg == 0 || uargv == 0) {
      argv[i] = 0;
      break;
    }
    argv[i] = reinterpret_cast<char *>(memAllocator.alloc());
    if (argv[i] == 0) goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0) goto bad;
  }
  vfs::calAbsolute(path);
  LOG_DEBUG("path=%s", path);
  ret = exec(path, argv);
  for (int i = 0; i <= MAXARG && argv[i] != 0; i++) memAllocator.free(argv[i]);
  LOG_DEBUG("exec over");
  return ret;

bad:
  LOG_DEBUG("exec bad");
  for (int i = 0; i <= MAXARG && argv[i] != 0; i++) memAllocator.free(argv[i]);
  return -1;
}

uint64_t sys_wait(void) {
  uint64_t vaddr;
  if (argaddr(0, &vaddr) < 0) {
    return -1;
  }
  return wait(vaddr);
}

uint64_t sys_wait4(void) {
  int pid;
  uint64_t uaddr;
  if (argint(0, &pid) < 0 || argaddr(1, &uaddr) < 0) {
    return -1;
  }
  LOG_DEBUG("wait4");
  if (pid == -1) {
    return wait(uaddr);
  }
  return wait4(pid, uaddr);
}

uint64_t sys_getpid() { return myTask()->pid; }
uint64_t sys_getppid() { return myTask()->parent->pid; }

uint64_t sys_sched_yield() {
  yield();
  return 0;
}

uint64_t sys_brk(void) {
  uint64_t addr;
  if (argaddr(0, &addr) < 0) {
    return -1;
  }
  LOG_DEBUG("sys_brk");
  Task *task = myTask();
  if (addr == 0) return task->sz;
  growtask(addr - task->sz);
  return task->sz;
}

#define OFFSET(structure, member) ((uint64_t)(&((structure *)0)->member));

const char *sysname = "startos";
const char *nodename = "test";
const char *release = "statos hasn't been released yet";
const char *version = "0.0.1";
#ifdef K210
const char *machine = "Sipeed M1 DOCK";
#else
const char *machine = "QEMU emulator version 4.2.1";
#endif

const char *domainname = "NIS domain name";

uint64_t sys_uname(void) {
  uint64_t addr, off;
  if (argaddr(0, &addr) < 0) {
    return -1;
  }

  off = OFFSET(struct utsname, sysname);
  either_copyout(true, addr + off, (void *)sysname, strlen(sysname));

  off = OFFSET(struct utsname, nodename);
  either_copyout(true, addr + off, (void *)nodename, strlen(nodename));

  off = OFFSET(struct utsname, release);
  either_copyout(true, addr + off, (void *)release, strlen(release));

  off = OFFSET(struct utsname, version);
  either_copyout(true, addr + off, (void *)version, strlen(version));

  off = OFFSET(struct utsname, machine);
  either_copyout(true, addr + off, (void *)machine, strlen(machine));

  off = OFFSET(struct utsname, version);
  either_copyout(true, addr + off, (void *)domainname, strlen(domainname));
  return 0;
}

uint64_t sys_times(void) {
  struct tms tm;
  uint64_t utmaddr;
  int start = timer::ticks;
  if (argaddr(0, &utmaddr) < 0) {
    return -1;
  }
  taskTimes(&tm);
  copyout(myTask()->pagetable, utmaddr, (char *)&tm, sizeof(struct tms));
  return timer::ticks - start;
}

uint64_t sys_gettimeofday() {
  uint64_t addr;
  if (argaddr(0, &addr) < 0) {
    return -1;
  }
  TimeVal tm;
#ifdef K210
  tm.sec = clock::getTimestamp();
  tm.usec = 0;
#endif
  copyout(myTask()->pagetable, addr, reinterpret_cast<char *>(&tm), sizeof(TimeVal));
  return 0;
}
