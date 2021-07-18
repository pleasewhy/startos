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
#include "memory/MemAllocator.hpp"
#include "sysinfo.h"
#include "signal.h"

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
  auto trapframe = myTask()->trapframe;
  printf("%p %p %p %p\n", trapframe->a0, trapframe->a1, trapframe->a2,
         trapframe->a3);
  if (stackHighAddr == 0) {
    printf("do fork");
    int pid = fork();
    LOG_TRACE("do fork over");
    return pid;
  }
  else {
    printf("do clone");
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

uint64_t sys_gettid()
{
  return (uint64_t)myTask();
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
  LOG_TRACE("sys_brk");
  if (argaddr(0, &addr) < 0) {
    return -1;
  }
  LOG_TRACE("sys_brk0 addr=%p", addr);
  Task *task = myTask();
  if (addr == 0)
    return task->sz;
  LOG_TRACE("before=%p", task->sz);
  growtask(addr - task->sz);
  LOG_TRACE("after=%p, grow=%d", task->sz);
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

  if (clock_id != CLOCK_REALTIME_COARSE && clock_id != CLOCK_REALTIME) {
    printf("clockid=%d\n", clock_id);
    panic("clock only support CLOCK_REALTIME_COARSE");
  }

  time::CurrentTimeSpec(&ts);
  copyout(myTask()->pagetable, addr, (char *)&ts, sizeof(ts));
  return 0;
}

uint64_t sys_clock_nanosleep(void)
{
  time::timespec request;
  request.tv_nsec = 0;
  request.tv_sec = 0;
  LOG_TRACE("clock gettime");
  uint64_t request_addr;
  uint64_t remain_addr;
  int      clock_id;
  int      flags;
  if (argint(0, &clock_id) < 0 || argint(1, &flags) < 0)
    return -1;
  if (argaddr(2, &request_addr) < 0 || argaddr(3, &remain_addr) < 0)
    return -1;
  LOG_TRACE("addr=%p %p\n", request_addr, remain_addr);
  if (copyin(myTask()->pagetable, (char *)&request, request_addr,
             sizeof(request)) < 0)
    return -1;
  LOG_TRACE("clock id=%d flag=%p sec=%p nsec=%d\n", clock_id, flags,
            request.tv_sec, request.tv_nsec);
  request.tv_sec = 1;
  sleepTime((request.tv_sec * 1000 + request.tv_nsec / 1000000) / INTERVAL);
  return 1;
}

struct sigaction act_tmp;

uint64_t         sys_rt_sigaction(void)
{
  int              signum;
  uint64_t         act_addr, old_act_addr;
  // struct sigaction act;
  if (argint(0, &signum) < 0 || argaddr(1, &act_addr) < 0 ||
      argaddr(2, &old_act_addr) < 0)
    return -1;
  if (act_addr != 0)
    either_copyin(true, &act_tmp, act_addr, sizeof(act_tmp));

  if(old_act_addr != 0)
    either_copyout(true, old_act_addr, &act_tmp, sizeof(act_tmp));
  LOG_DEBUG("signum=%d, act=%p old act=%p\n", signum, act_addr, old_act_addr);
  LOG_TRACE("rt_sigaction");
  return 0;
}

uint64_t sys_rt_sigprocmask(void)
{
  int      how, sigsetsize;
  uint64_t set_addr, old_set_addr;
  if (argint(0, &how) < 0 || argaddr(1, &set_addr) < 0)
    return -1;
  if (argaddr(2, &old_set_addr) < 0 || argint(3, &sigsetsize))
    return -1;
  LOG_DEBUG("how=%d set=%p old set=%p sigsetsz=%d", how, set_addr, old_set_addr,
            sigsetsize);
  LOG_TRACE("rt_sigprocmask");
  return 0;
}

uint64_t sys_set_tid_address(void)
{
  LOG_TRACE("set_tid_address");
  return 0;
}

uint64_t sys_kill()
{
  int pid, sig;
  if (argint(0, &pid) < 0 || argint(1, &sig) < 0) {
    return -1;
  }
  return kill(pid, sig);
}

extern MemAllocator memAllocator;

uint64_t sys_sysinfo(void)
{
  struct sysinfo info;
  uint64_t       uaddr;
  if (argaddr(0, &uaddr) < 0) {
    return -1;
  }
  info.uptime = timer::ticks * INTERVAL / 1000;
  info.freeram = memAllocator.FreeMemOfBytes();
  info.totalram = memAllocator.TotalMemOfBytes();
  info.sharedram = 0;
  info.freeswap = 0;
  info.bufferram = 0;
  info.procs = CountOfTask();
  if (either_copyout(myTask()->pagetable, uaddr, &info, sizeof(info)) < 0) {
    return -1;
  }
  return 0;
}
