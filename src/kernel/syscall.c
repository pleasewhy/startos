#include "types.h"
#include "param.h"
#include "riscv.h"
#include "lock/lock.h"
#include "process.h"
#include "defs.h"

void forkra(struct context *ctx, uint64 pkstack, uint64 ckstack);

//
// fork的简单实现
// fork失败返回-1
// 父进程返回子进程id
// 子进程返回0
//
int fork() {
    struct proc *p;
    struct proc *np;
    if ((np = alloc_proc()) == 0) {
        return -1;
    }
    p = myproc();
    memmove((char *) np->kstack, (char *) p->kstack, PGSIZE);
    np->parent = p;
    np->state = RUNNABLE;
    forkra(&np->context, p->kstack, np->kstack);
    if (myproc() == np) {
        printf("child\n");
        spin_unlock(&np->proc_lock);
        printf("child2\n");
    }
    return myproc() == np ? 0 : np->pid;
}

//
// 睡眠指定秒数
//
void sleep_sec(int seconds) {
    sleep_time(seconds * 10);
}

//
// 让出cpu
//
void yeild() {
    struct proc *p = myproc();
    spin_lock(&p->proc_lock);
    p->state = RUNNABLE;
//    pswitch(&(myproc()->context), &(mycpu()->context));
    before_sched();
    spin_unlock(&p->proc_lock);
}
