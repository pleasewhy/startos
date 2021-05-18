#include "StartOS.hpp"
#include "common/logger.h"
#include "common/string.hpp"
#include "fs/vfs/FileSystem.hpp"
#include "memory/MemAllocator.hpp"
#include "os/Syscall.hpp"
#include "os/TaskScheduler.hpp"
#include "param.hpp"
#include "riscv.hpp"
#include "types.hpp"

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
    if (fetchaddr(uargv + sizeof(uint64_t) * i, &uarg) < 0) goto bad;
    if (uarg == 0) {
      argv[i] = 0;
      break;
    }
    argv[i] = reinterpret_cast<char *>(memAllocator.alloc());
    if (argv[i] == 0) goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0) goto bad;
  }
  LOG_DEBUG("path=%s", path);
  ret = exec(path, argv);
  for (int i = 0; i <= MAXARG && argv[i] != 0; i++) memAllocator.free(argv[i]);
  LOG_DEBUG("exec over");
  return ret;

bad:
  LOG_TRACE("exec bad");
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
  if(pid == -1){
    return wait(uaddr);
  }
  return wait4(pid, uaddr);
}

uint64_t sys_getpid() { return myTask()->pid; }
uint64_t sys_getppid() { return myTask()->parent->pid; }

uint64_t sys_sched_yield(){
  yield();
  return 0;
}