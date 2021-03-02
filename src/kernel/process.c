#include "types.h"
#include "param.h"
#include "riscv.h"
#include "memlayout.h"
#include "lock/lock.h"
#include "process.h"
#include "defs.h"

struct cpu cpus[NCPU];

struct proc proc_table[NPROC];

extern uint64 ticks;
extern struct spinlock ticks_lock;

extern char trampoline[], uservec[], userret[];

struct proc *initproc;

extern char trampoline[]; // trampoline.S


char stack[PGSIZE * 2 * (NPROC + 1)];

// 初始化进程表
void init_process_table() {
    struct proc *p;
    for (int i = 0; i < NPROC; i++) {
        p = &proc_table[i];
        spinlock_init(&p->proc_lock, "proc");
        p->pid = i;
//        p->kstack = (uint64) kalloc();
        p->kstack = (uint64) (stack + PGSIZE * i);
        p->trapframe = 0;
        p->state = UNUSED;
    }
}

// 该程序执行exec("/init"), 然后退出
// 通过 od -t xC initcode 生成
uchar initcode[] = {
        0x17, 0x05, 0x00, 0x00, 0x13, 0x05, 0x45, 0x02,
        0x97, 0x05, 0x00, 0x00, 0x93, 0x85, 0x35, 0x02,
        0x93, 0x08, 0x20, 0x00, 0x73, 0x00, 0x00, 0x00,
        0x93, 0x08, 0x30, 0x00, 0x73, 0x00, 0x00, 0x00,
        0xef, 0xf0, 0x9f, 0xff, 0x2f, 0x69, 0x6e, 0x69,
        0x74, 0x00, 0x00, 0x24, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00
};

// 初始化第一个进程
void init_first_process() {
    struct proc *p = alloc_proc();
    // 为进程分配一页内存，并将初始化的指令和数据写入
    user_vm_init(p->pagetable, initcode, sizeof(initcode));

    p->sz = PGSIZE;
    // 内核空间第一次进入用户空间
    p->trapframe->epc = 0;
    p->trapframe->sp = PGSIZE;

    memmove(p->name, "initcode", sizeof(p->name));
    p->current_dir = namei("/");

    for (int i = 0; i < NOFILE; i++)
        p->open_file[i] = 0;
    p->state = RUNNABLE;
    initproc = p;
    printf("over");
}

// fork的子进程的会从此处开始执行
void forkret(void) {
    static int first = 1;

    // 这里需要释放进程锁
    spin_unlock(&myproc()->proc_lock);

    if (first) {
        // File system initialization must be run in the context of a
        // regular process (e.g., because it calls sleep), and thus cannot
        // be run from main().
        //
        first = 0;
        init_fs();
    }

    usertrapret();
}

// 分配一个进程，并设置其初始执行函数为forkret
struct proc *alloc_proc() {
    struct proc *p;
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
        spin_lock(&p->proc_lock);
        if (p->state == UNUSED) {
            goto found;
        } else {
            spin_unlock(&p->proc_lock);
        }
    }
    return 0;

    found:
    if ((p->trapframe = (struct trapframe *) kalloc()) == 0) {
        spin_unlock(&p->proc_lock);
        return 0;
    }

    // 为进程创建页表
    p->pagetable = proc_pagetable(p);

    memset(&p->context, 0, sizeof(p->context));
    memset(p->trapframe, 0, sizeof(*p->trapframe));

    p->context.sp = p->kstack + PGSIZE;
    p->context.ra = (uint64) forkret;

    spin_unlock(&p->proc_lock);
    return p;
}

/**
 *
 * 创建一个进程可以使用的pagetable, 只映射了trampoline页,
 * 用于进入和离开内核空间
 *
 * @return
 */
pagetable_t proc_pagetable(struct proc *p) {
    pagetable_t pagetable;

    // 创建一个空的页表
    pagetable = user_vm_create();
    if (pagetable == 0)
        return 0;

    // 映射trampoline代码(用于系统调用)到虚拟地址的顶端
    if (mappages(pagetable, TRAMPOLINE, PGSIZE,
                 (uint64) trampoline, PTE_R | PTE_X) < 0) {
        // TODO 失败释放内存
        return 0;
    }
    // 将进程的trapframe映射到TRAPFRAME, TRAMPOLINE的低位一页
    if (mappages(pagetable, TRAPFRAME, PGSIZE,
                 (uint64) (p->trapframe), PTE_R | PTE_W) < 0) {
//        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
//        uvmfree(pagetable, 0);
        return 0;
    }
    return pagetable;
}


/**
 * 调度函数，for循环寻找RUNABLE的进程，
 * 并执行，当使用只有一个进程时(shell),
 * 使CPU进入低功率模式。
 *  内核调度线程将一直执行该函数
 */
void scheduler() {
    struct proc *p;
    struct cpu *c = mycpu();
    int alive_p = 0;
    for (;;) {
        intr_on();
        alive_p = 0;
        for (int i = 0; i < NPROC; i++) {
            p = &proc_table[i];
            spin_lock(&p->proc_lock);
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
            spin_unlock(&p->proc_lock);
        }
        if (alive_p <= 2) {
            intr_on();
            asm volatile("wfi");
        }
    }
}

// 获取当前cpu的id
int cpuid() {
    int id = r_tp();
    return id;
}

// 获取当前cpu
struct cpu *mycpu(void) {
    int id = cpuid();
    struct cpu *c = &cpus[id];
    return c;
}

// 获取当前进程
struct proc *myproc() {
    return mycpu()->proc;
}

// 睡眠在chan上
void sleep(void *chan, struct spinlock *lock) {
    struct proc *p = myproc();

    // 由于要改变p->state所以需要持有p->proc_lock, 然后
    // 调用before_sched。只要持有了p->proc_lock，就能够保证不会
    // 丢失wakeup(wakeup 会锁定p->proc_lock)，
    // 所以解锁lock是可以的
    if (lock != &p->proc_lock) {  //DOC: sleeplock0
        spin_lock(&p->proc_lock);  //DOC: sleeplock1
        spin_unlock(lock);
    }
    // sleep
    p->chan = chan;
    p->state = SLEEPING;

    before_sched();

    // 重置chan
    p->chan = 0;

    // Reacquire original lock.
    if (lock != &p->proc_lock) {
        spin_unlock(&p->proc_lock);
        spin_lock(lock);
    }
}

void before_sched() {
    int intr_enable;
    struct proc *p = myproc();

    if (!spin_holding(&p->proc_lock))
        panic("sched p->lock");
    if (mycpu()->noff != 1)
        panic("sched locks");
    if (p->state == RUNNING)
        panic("sched running");
    if (intr_get())
        panic("sched interruptible");

    intr_enable = mycpu()->intr_enable;
    pswitch(&p->context, &mycpu()->context);
    mycpu()->intr_enable = intr_enable;
}

// 睡眠一定时间
void sleep_time(uint64 sleep_ticks) {
    uint64 now = ticks;
    spin_lock(&ticks_lock);
    for (; ticks - now < sleep_ticks;) {
        sleep(&ticks, &ticks_lock);
    }
    spin_unlock(&ticks_lock);
}

// 唤醒指定chan上的进程
void wakeup(void *chan) {
    struct proc *p;
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
        if (p->state == SLEEPING && p->chan == chan) {
            p->state = RUNNABLE;
        }
    }
}

int fork() {
    struct proc *child;
    struct proc *p = myproc();
    int i;
    // 分配一个新的进程
    if ((child = alloc_proc()) == 0) {
        printf("\n\n\nuser\n\n\n");
        return -1;
    }

    // 将父进程的内存复制到子进程中
    if (user_vm_copy(p->pagetable, child->pagetable, p->sz) < 0) {
        return -1;
    }
    child->sz = p->sz;
    child->parent = p;

    // 复制父进程的用户空间的寄存器
    *(child->trapframe) = *(p->trapframe);

    // 设置子进程fork的返回值为0
    child->trapframe->a0 = 0;

    //
    for (i = 0; i < NOFILE; i++) {
        if (p->open_file[i] != 0) {
            child->open_file[i] = file_dup(p->open_file[i]);
        }
    }
    child->current_dir = dup_inode(p->current_dir);

    safestrcpy(child->name, p->name, sizeof(p->name));

    child->state = RUNNABLE;
    return child->pid;
}


static void
proc_free(struct proc *p) {
    if(p->trapframe)
        kfree(p->trapframe);
    p->trapframe = 0;
    // TODO 释放页表
    p->pagetable = 0;
    p->sz = 0;
    p->name[0] = 0;
    p->chan = 0;
    p->killed = 0;
    p->xstate = 0;
    p->state = UNUSED;
    p->parent = 0;
}

//
// 等待子进程退出, 返回其子进程id
// 没有子进程返回-1， 将退出状态复
// 制到status中。
//
int wait(uint64 vaddr) {
    struct proc *cp; // 子进程
    struct proc *p;
    int havechild, pid;
    p = myproc();
    spin_lock(&p->proc_lock);
    for (;;) {
        havechild = 0;
        for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
            if (cp->parent == p) {
                spin_lock(&cp->proc_lock);
                havechild = 1;
                if (cp->state == ZOMBIE) {
                    pid = cp->pid;
                    if (vaddr != 0 && copyout(cp->pagetable, vaddr, (char *) &cp->xstate,
                                              sizeof(cp->xstate)) < 0) {
                        spin_unlock(&cp->proc_lock);
                        spin_unlock(&p->proc_lock);
                        return -1;
                    }
                    proc_free(cp);
                    spin_unlock(&cp->proc_lock);
                    spin_unlock(&p->proc_lock);
                    return pid;
                }
                spin_unlock(&cp->proc_lock);
            }
        }
        if (!havechild) {
            return -1;
        }
        sleep(p, &myproc()->proc_lock); // 等待子进程唤醒
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
void exit(int status) {
    struct proc *p, *cp;
    p = myproc();
    p->state = ZOMBIE;
    p->xstate = status;

    // 关闭打开的文件
    for (int fd = 0; fd < NOFILE; fd++) {
        if (p->open_file[fd]) {
            file_close(p->open_file[fd]);
            p->open_file[fd] = 0;
        }
    }

    // 归还当前目录inode
    putback_inode(p->current_dir);

    for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
        if (cp->parent == p) {
            cp->parent = initproc;
        }
    }
    wakeup(p->parent);
    spin_lock(&p->proc_lock);
    before_sched();
    panic("exit");
}

void print_proc() {
    struct proc *p;
    printf(" \npid\tstate\n");
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
        if (p->state == UNUSED)
            continue;
        printf(" %d\t  %d\n", p->pid, p->state);
    }
}

//
// 让出cpu
//
void yield() {
    struct proc *p = myproc();
    spin_lock(&p->proc_lock);
    p->state = RUNNABLE;
    before_sched();
    spin_unlock(&p->proc_lock);
}

/**
 *  根据user_dst将源数据复制内核地址或用户地址
 *  @param user_dst dst是否为用户空间地址
 *  @param copy的长度
 * @return 成功返回0，失败返回-1
 */
int either_copyout(int user_dst, uint64 dst, void *src, int len) {
    struct proc *p = myproc();
    if (user_dst) {
        return copyout(p->pagetable, dst, src, len);
    } else {
        memmove((char *) dst, src, len);
        return 0;
    }
}

/**
 *  根据user_dst将数据从内核地址或用户地址copy到dst中
 *  @param user_src dst是否为用户空间地址
 *  @param copy的长度
 * @return 成功返回0，失败返回-1
 */
int either_copyin(void *dst, int user_src, uint64 src, uint64 len) {
    struct proc *p = myproc();
    if (user_src) {
        return copyin(p->pagetable, dst, src, len);
    } else {
        memmove(dst, (char *) src, len);
        return 0;
    }
}

