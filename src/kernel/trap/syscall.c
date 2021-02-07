//
// Created by hy on 2021/2/3.
//
#include "../types.h"
#include "../param.h"
#include "../riscv.h"
#include "../memlayout.h"
#include "../lock/lock.h"
#include "../process.h"
#include "../defs.h"
#include "syscall.h"


uint64 argraw(int n) {
    struct proc *p = myproc();
    switch (n) {
        case 0:
            return p->trapframe->a0;
        case 1:
            return p->trapframe->a1;
        case 2:
            return p->trapframe->a2;
        case 3:
            return p->trapframe->a3;
        case 4:
            return p->trapframe->a4;
        case 5:
            return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
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
int argaddr(int n, uint64 *addr) {
    *addr = argraw(n);
    return 0;
}

// 从当前进程取出以0结束的字符串
/**
 * 从当前进程的addr位置取出0结束的字符串。
 * 返回字符串的长度, 不包括0, 失败返回-1
 * @return
 */
int fetchstr(uint64 addr, char *buf, int max) {
    struct proc *p = myproc();
    int err = copyinstr(p->pagetable, buf, addr, max);
    if (err < 0)
        return err;
    return strlen(buf);
}

/**
 * 获取第n个系统调用参数作为0结束的字符串
 *  复制到buf中, 最多复制max
 */

int argstr(int n, char *buf, int max) {
    uint64 addr;
    if (argaddr(n, &addr) < 0)
        return -1;
    return fetchstr(addr, buf, max);
}

extern uint64 sys_putchar(void);
extern uint64 sys_exec(void);
extern uint64 sys_read(void);
extern uint64 sys_exit(void);
extern uint64 sys_fork(void);

static uint64 (*syscalls[])(void) = {
        [SYS_putchar] sys_putchar,
        [SYS_exec] sys_exec,
        [SYS_read] sys_read,
        [SYS_exit] sys_exit,
        [SYS_fork] sys_fork,
};

#define NELEM(x) (sizeof(x)/sizeof((x)[0]))

void syscall(void) {
    int num;
    struct proc *p = myproc();

    num = p->trapframe->a7;
    if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
        p->trapframe->a0 = syscalls[num]();
    } else {
        printf("%d %s: unknown sys call %d\n",
               p->pid, p->name, num);
        p->trapframe->a0 = -1;
        panic("syscall error");
    }
}