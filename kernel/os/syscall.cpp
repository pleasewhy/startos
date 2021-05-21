#include "os/Syscall.hpp"
#include "StartOS.hpp"
#include "common/printk.hpp"
#include "common/string.hpp"
#include "memlayout.hpp"
#include "os/SyscallNum.hpp"
#include "os/TaskScheduler.hpp"
#include "param.hpp"
#include "riscv.hpp"
#include "types.hpp"

uint64_t argraw(int n) {
  Task *task = myTask();
  switch (n) {
    case 0:
      return task->trapframe->a0;
    case 1:
      return task->trapframe->a1;
    case 2:
      return task->trapframe->a2;
    case 3:
      return task->trapframe->a3;
    case 4:
      return task->trapframe->a4;
    case 5:
      return task->trapframe->a5;
  }
  panic("argraw");
  return -1;
}

// 获取当前进程addr处的一个uint64_t值
int fetchaddr(uint64_t addr, uint64_t *ip) {
  Task *task = myTask();
  if (addr >= static_cast<uint64_t>(task->sz) || addr + sizeof(uint64_t) > static_cast<uint64_t>(task->sz)) return -1;
  if (copyin(task->pagetable, (char *)ip, addr, sizeof(*ip)) != 0) return -1;
  return 0;
}

/**
 * 获取第n个int类型参数
 */
int argint(int n, int *addr) {
  *addr = argraw(n);
  return 0;
}

/**
 * 获取传入的指针，这里不需要检验合法性,
 * copyin/copyout会检验。
 *
 * @param n 参数的偏移量
 * @param ip 结果地址
 * @return
 */
int argaddr(int n, uint64_t *addr) {
  *addr = argraw(n);
  return 0;
}

// 从当前进程取出以0结束的字符串
/**
 * 从当前进程的addr位置取出0结束的字符串。
 * 返回字符串的长度, 不包括0, 失败返回-1
 * @return
 */
int fetchstr(uint64_t addr, char *buf, int max) {
  Task *task = myTask();
  int err = copyinstr(task->pagetable, buf, addr, max);
  if (err < 0) return err;
  return strlen(buf);
}

/**
 * 获取第n个系统调用参数作为0结束的字符串
 *  复制到buf中, 最多复制max
 */
int argstr(int n, char *buf, int max) {
  uint64_t addr;
  if (argaddr(n, &addr) < 0) return -1;
  return fetchstr(addr, buf, max);
}

extern uint64_t sys_getcwd(void);
extern uint64_t sys_exec(void);
extern uint64_t sys_open(void);
extern uint64_t sys_write(void);
extern uint64_t sys_read(void);
extern uint64_t sys_dup(void);
extern uint64_t sys_dup3(void);
extern uint64_t sys_getpid(void);
extern uint64_t sys_getppid(void);
extern uint64_t sys_fork(void);
extern uint64_t sys_exit(void);
extern uint64_t sys_wait(void);
extern uint64_t sys_wait4(void);
extern uint64_t sys_chdir(void);
extern uint64_t sys_close(void);
extern uint64_t sys_mkdirat(void);
extern uint64_t sys_openat(void);
extern uint64_t sys_sched_yield(void);
extern uint64_t sys_brk(void);
extern uint64_t sys_uname(void);
extern uint64_t sys_pipe(void);
extern uint64_t sys_getdents64(void);
extern uint64_t sys_mount(void);
extern uint64_t sys_umount2(void);
extern uint64_t sys_times(void);
extern uint64_t sys_gettimeofday(void);

static uint64_t (*syscalls[400])(void);

// #define NELEM(x) (sizeof(x) / sizeof((x)[0]))

void syscall_init() {
  memset((void*)syscalls, 0, sizeof(uint64_t)*400);
  syscalls[SYS_execve] = sys_exec;
  syscalls[SYS_open] = sys_open;
  syscalls[SYS_write] = sys_write;
  syscalls[SYS_read] = sys_read;
  syscalls[SYS_dup] = sys_dup;
  syscalls[SYS_dup3] = sys_dup3;
  syscalls[SYS_getcwd] = sys_getcwd;
  syscalls[SYS_getpid] = sys_getpid;
  syscalls[SYS_getppid] = sys_getppid;
  syscalls[SYS_fork] = sys_fork;
  syscalls[SYS_clone] = sys_fork;
  syscalls[SYS_exit] = sys_exit;
  syscalls[SYS_wait] = sys_wait;
  syscalls[SYS_wait4] = sys_wait4;
  syscalls[SYS_chdir] = sys_chdir;
  syscalls[SYS_close] = sys_close;
  syscalls[SYS_mkdirat] = sys_mkdirat;
  syscalls[SYS_openat] = sys_openat;
  syscalls[SYS_sched_yield] = sys_sched_yield;
  syscalls[SYS_brk] = sys_brk;
  syscalls[SYS_uname] = sys_uname;
  syscalls[SYS_pipe2] = sys_pipe;
  syscalls[SYS_getdents64] = sys_getdents64;
  syscalls[SYS_mount] = sys_mount;
  syscalls[SYS_umount2] = sys_umount2;
  syscalls[SYS_times] = sys_times;
  syscalls[SYS_gettimeofday] = sys_gettimeofday;
}

void syscall(void) {
  int num;
  Task *task = myTask();
  num = task->trapframe->a7;
  if (num > 0 && static_cast<uint64_t>(num) < NELEM(syscalls) && syscalls[num]) {
    task->trapframe->a0 = syscalls[num]();
  } else {
    printf("%d %s: unknown sys call %d\n", task->pid, task->name, num);
    task->trapframe->a0 = -1;
    panic("syscall error");
  }
}
