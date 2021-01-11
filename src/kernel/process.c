#include "types.h"
#include "param.h"
#include "riscv.h"
#include "process.h"
#include "user/sh.c"
#include "defs.h"
#include "fs/fstest.h"

struct cpu cpus[NCPU];

struct proc proc_table[NPROC];

extern uint64 ticks;

struct proc* initproc;

char stack[PGSIZE * (NPROC + 1)];

// 初始化进程表
void init_process_table()
{
    struct proc* p;
    for (int i = 0; i < NPROC; i++) {
        p = &proc_table[i];
        p->pid = i;
        p->kstack = (uint64)stack + PGSIZE * i;
        p->state = UNUSED;
    }
}

// 第一个进程, 创建osh进程
// 后循环wait
void init()
{
    int pid = fork();
    if (pid < 0) {
        panic("init");
    } else if (pid == 0) {
        exec((uint64)osh);
    }
    fstest();
    for (;;) {
        wait(0);
    }
}

// 初始化第一个进程
void init_first_process()
{
    struct proc* p = alloc_proc();
    p->context.ra = (uint64)init;
    p->state = RUNNABLE;
    initproc = p;
}

void trapret();
void kerneltrap();

// 分配一个进程
struct proc* alloc_proc()
{
    struct proc* p;
    for (int i = 0; i < NPROC; i++) {
        p = &proc_table[i];
        if (p->state == UNUSED) {
            memset(&p->context, 0, sizeof(p->context));
            p->context.sp = p->kstack + PGSIZE;
            return p;
        }
    }
    return 0;
}

// 调度函数，for循环寻找RUNABLE的进程，
// 并执行，当使用进程只有一个时(shell),
// 使CPU进入低功率模式。
// 内核调度线程将一直执行该函数
void scheduler()
{
    struct proc* p;
    struct cpu* c = mycpu();
    int alive_p = 0;
    for (;;) {
        intr_on();
        alive_p = 0;
        for (int i = 0; i < NPROC; i++) {
            p = &proc_table[i];
            if (p->state != UNUSED && p->state != ZOMBIE) {
                alive_p++;
            }
            if (p->state == ZOMBIE) {
                wakeup(initproc);
            }
            if (p->state == RUNNABLE) {
                p->state = RUNNING;
                c->proc = p;
                pswitch(&c->context, &p->context);
                c->proc = 0;
            }
        }
        if (alive_p <= 2) {
            intr_on();
            asm volatile("wfi");
        }
    }
}

// 获取当前cpu的id
int cpuid()
{
    int id = r_tp();
    return id;
}

// 获取当前cpu
struct cpu* mycpu(void)
{
    int id = cpuid();
    struct cpu* c = &cpus[id];
    return c;
}

// 获取当前进程
struct proc* myproc()
{
    return mycpu()->proc;
}

// 睡眠在chan上
void sleep(void* chan)
{
    struct proc* p;
    p = myproc();
    p->state = SLEEPING;
    p->chan = chan;
    pswitch(&p->context, &mycpu()->context);
}

// 睡眠一定时间
void sleep_time(uint64 sleep_ticks)
{
    uint64 now = ticks;
    for (; ticks - now < sleep_ticks;) {
        sleep(&ticks);
    }
}

// 唤醒指定chan上的进程
void wakeup(void* chan)
{
    struct proc* p;
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
        if (p->state == SLEEPING && p->chan == chan) {
            p->state = RUNNABLE;
        }
    }
}

//
// 等待子进程退出, 返回其子进程id
// 没有子进程返回-1， 将退出状态复
// 制到status中。
//
int wait(int* status)
{
    struct proc* cp; // 子进程
    struct proc* p;
    int havechild, pid;
    p = myproc();
    for (;;) {
        havechild = 0;
        for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
            if (cp->parent == p) {
                havechild = 1;
                if (cp->state == ZOMBIE) {
                    pid = cp->pid;
                    if (status) {
                        *status = cp->xstate;
                    }
                    cp->state = UNUSED;
                    return pid;
                }
            }
        }
        if (!havechild) {
            return -1;
        }
        sleep(p); // 等待子进程唤醒
    }
}

//
// 进程退出
// 不需要释放资源，因为没有
//
// 这里将state设置为ZOMBIE,
// 让父进程来设置其state为UNUSED
// 若父进程已经exit, 则会由init进
// 程来完成父进程在exit时，会将其
// 子进程的parent设置为init进程
//
void exit(int status)
{
    struct proc *p, *cp;
    p = myproc();
    p->state = ZOMBIE;
    p->xstate = status;
    for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
        if (cp->parent == p) {
            cp->parent = initproc;
        }
    }
    wakeup(p->parent);
    pswitch(&(myproc()->context), &(mycpu()->context));
}

void execra(struct context*, struct context*, uint64);

// 使进程执行其他函数
void exec(uint64 fn)
{
    struct proc* p = myproc();
    memset(&p->context, 0, sizeof(struct context));
    p->state = RUNNABLE;
    p->context.sp = p->kstack + PGSIZE;
    execra(&p->context, &mycpu()->context, fn);
    // 不会返回
    panic("exec");
}

void print_proc()
{
    struct proc* p;
    printf(" \npid\tstate\n");
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
        if (p->state == UNUSED)
            continue;
        printf(" %d\t  %d\n", p->pid, p->state);
    }
}
