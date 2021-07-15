#include "StartOS.hpp"
#include "common/logger.h"
#include "common/string.hpp"
#include "param.hpp"
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

uint64_t sys_exit(void)
{
  int n;
  if (argint(0, &n) < 0)
    return -1;
  exit(n);
  return 0;  // not reached
}

uint64_t sys_exit_group(void)
{
  int n;
  if (argint(0, &n) < 0)
    return -1;
  exit(n);
  return 0;  // not reached
}

uint64_t sys_fork(void)
{
  LOG_TRACE("fork");
  return fork();
}

uint64_t sys_clone(void)
{
  LOG_TRACE("sys_clone");
  int      flags;
  uint64_t stackHighAddr;
  if (argint(0, &flags) < 0 || argaddr(1, &stackHighAddr) < 0) {
    return -1;
  }
  if (stackHighAddr == 0) {
    printf("do fork");
    LOG_TRACE("do fork");
    int pid = fork();
    LOG_TRACE("do fork over");
    return pid;
  }
  else {
    LOG_TRACE("do clone");
    return clone(stackHighAddr, flags);
  }
}

//   uint64_t sys_clone(void){

// }

uint64_t sys_exec(void)
{
  char path[MAXPATH], *argv[MAXARG];
  LOG_TRACE("exec");
  uint64_t uargv, uarg = 0;
  int      ret = 0;
  if (argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0)
    return -1;
  if (strlen(path) < 1)
    return -1;
  memset(argv, 0, sizeof(argv));
  for (int i = 0;; i++) {
    if (i > MAXARG)
      goto bad;
    if (uargv != 0 && fetchaddr(uargv + sizeof(uint64_t) * i, &uarg) < 0)
      goto bad;
    if (uarg == 0 || uargv == 0) {
      argv[i] = 0;
      break;
    }
    argv[i] = reinterpret_cast<char *>(memAllocator.alloc());
    if (argv[i] == 0)
      goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
      goto bad;
  }
  vfs::calAbsolute(path);
  LOG_TRACE("path=%s", path);
  ret = exec(path, argv);
  for (int i = 0; i <= MAXARG && argv[i] != 0; i++)
    memAllocator.free(argv[i]);
  LOG_TRACE("exec over");
  return ret;

bad:
  LOG_TRACE("exec bad");
  for (int i = 0; i <= MAXARG && argv[i] != 0; i++)
    memAllocator.free(argv[i]);
  return -1;
}

uint64_t sys_wait(void)
{
  uint64_t vaddr;
  if (argaddr(0, &vaddr) < 0) {
    return -1;
  }
  return wait(vaddr);
}

uint64_t sys_wait4(void)
{
  int      pid;
  uint64_t uaddr;
  if (argint(0, &pid) < 0 || argaddr(1, &uaddr) < 0) {
    return -1;
  }
  LOG_TRACE("wait4");
  if (pid == -1) {
    return wait(uaddr);
  }
  return wait4(pid, uaddr);
}

uint64_t sys_getpid()
{
  return myTask()->pid;
}

uint64_t sys_getuid()
{
  return 0;
}

uint64_t sys_geteuid()
{
  return 0;
}

uint64_t sys_setpgid()
{
  // myTask()->gid =
  return 0;
}

uint64_t sys_getpgid()
{
  return 0;
}

uint64_t sys_getppid()
{
  return myTask()->parent->pid;
}

uint64_t sys_sched_yield()
{
  yield();
  return 0;
}

uint64_t sys_sbrk(void)
{
  uint64_t n;
  uint64_t addr;
  if (argaddr(0, &n) < 0) {
    return -1;
  }
  LOG_TRACE("sys_sbrk pid=%d", myTask()->pid);
  Task *task = myTask();
  if (n == 0)
    return task->sz;
  addr = task->sz;
  growtask(n);
  LOG_TRACE("sys_sbrk success n=%d", n);
  return addr;
}

uint64_t sys_brk(void)
{
  uint64_t addr;
  if (argaddr(0, &addr) < 0) {
    return -1;
  }
  LOG_TRACE("sys_brk0 addr=%p", addr);
  Task *task = myTask();
  if (addr == 0)
    return task->sz;
  growtask(addr - task->sz);
  return task->sz;
}

#define OFFSET(structure, member) ((uint64_t)(&((structure *)0)->member));

const char *sysname = "linux";
const char *nodename = "debian";
const char *release = "5.8.0-59-generic";
const char *version = "#66~20.04.1-Ubuntu";
#ifdef K210
const char *machine = "Sipeed M1 DOCK";
#else
const char *machine = "QEMU emulator version 4.2.1";
#endif

const char *domainname = "NIS domain name";

uint64_t sys_uname(void)
{
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

uint64_t sys_times(void)
{
  struct tms tm;
  uint64_t   utmaddr;
  int        start = timer::ticks;
  if (argaddr(0, &utmaddr) < 0) {
    return -1;
  }
  taskTimes(&tm);
  copyout(myTask()->pagetable, utmaddr, (char *)&tm, sizeof(struct tms));
  return timer::ticks - start;
}

uint64_t sys_gettimeofday()
{
  uint64_t addr;
  if (argaddr(0, &addr) < 0) {
    return -1;
  }
  TimeVal tv;

#ifdef K210
  clock::getTimeVal(tv);
#endif
  LOG_TRACE("sec=%d usec=%d", tv.sec, tv.usec);
  copyout(myTask()->pagetable, addr, reinterpret_cast<char *>(&tv),
          sizeof(TimeVal));
  return 0;
}

uint64_t sys_nanosleep(void)
{
  TimeVal  tv;
  uint64_t addr;
  if (argaddr(1, &addr) < 0) {
    return -1;
  }
  if (copyin(myTask()->pagetable, reinterpret_cast<char *>(&tv), addr,
             sizeof(TimeVal)) < 0) {
    return -1;
  }

  sleepTime((tv.sec * 1000 + tv.usec / 1000) / INTERVAL);
  return 0;
}

uint64_t sys_clock_gettime(void)
{
  time::timespec ts;
  LOG_TRACE("clock gettime");
  uint64_t addr;
  int      clock_id;
  if (argint(0, &clock_id) < 0 && argaddr(1, &addr) < 0) {
    return -1;
  }
  if (clock_id != CLOCK_REALTIME_COARSE)
    panic("clock only support CLOCK_REALTIME_COARSE");
  time::CurrentTimeSpec(&ts);
  copyout(myTask()->pagetable, addr, (char *)&ts, sizeof(ts));
  return 0;
}

uint64_t sys_rt_sigaction(void)
{
  printf("rt_sigaction\n");
  return 0;
}
