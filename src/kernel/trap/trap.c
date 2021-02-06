#include "../types.h"
#include "../param.h"
#include "../riscv.h"
#include "../memlayout.h"
#include "../lock/lock.h"
#include "../process.h"
#include "../defs.h"

// kernelvec.S, 调用kerneltrap
void kernelvec();

extern int device_intr();

uint64 ticks; // 定时器中断次数，可用于计时
struct spinlock ticks_lock;

extern char trampoline[], uservec[], userret[];


// 配置中断处理程序
void trapinit(void) {
    w_stvec((uint64) kernelvec);
}

//
// 处理进程error的情况
// 中断处理程序检测到错误将会返回到这里
//
void proc_err() {
    exit(-1);
}


/**
 *  处理用户空间的interrupt, exception, 系统调用
 *  trampoline.S会调用该函数
 */
void usertrap(void) {
    int which_dev = 0;
    if ((r_sstatus() & SSTATUS_SPP) != 0)
        panic("usertrap: not from user mode");


    // 由于现在处于内核空间, 所以需要更改中断向量为kerneltrap()
    w_stvec((uint64) kernelvec);


    struct proc *p = myproc();

    // 保存用户空间的PC
    p->trapframe->epc = r_sepc();

    if (r_scause() == 8) {
        // 系统调用
        if (p->killed)
            exit(-1);

        // sepc指向了ecall指令, 但是我们希望返回到ecall的下一条指令。
        p->trapframe->epc += 4;
        // 中断会改变部分寄存器，如sstatus，所以在使用完这些寄存器
        // 之前不能开中断
        intr_on();
        syscall();
    } else if ((which_dev = device_intr()) != 0) {
        // ok
    } else {
        printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
        printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
        p->killed = 1;
    }

    if (p->killed)
        exit(-1);

    // 若是时钟中断则放弃CPU
    if (which_dev == 2) {
        yield();
    }

    usertrapret();
}

void usertrapret() {
    struct proc *p = myproc();

    // 现在将trap处理程序从kerneltrap()切换为usertrap(), 因此需要
    // 禁用中断直到我们返回用户空间。
    intr_off();

    // 现在返回用户空间，设置中断处理函数为trampoline.S的uservec()
    w_stvec(TRAMPOLINE + (uservec - trampoline));

    // 设置trapframe, 以便下次的trap能够正常运行
    p->trapframe->kernel_satp = r_satp();         // 内核页表
    p->trapframe->kernel_sp = p->kstack + PGSIZE; // 进程的内核栈
    p->trapframe->kernel_trap = (uint64) usertrap;
    p->trapframe->kernel_hartid = r_tp();         // cpu id

    // 设置trampoline.S中的sret返回用户空间所需要的寄存器

    // 设置S Previous Privilege(SPP)为User
    unsigned long x = r_sstatus();
    x &= ~SSTATUS_SPP; // 为用户模式清除SPP
    x |= SSTATUS_SPIE; // 允许用户模式下的中断
    w_sstatus(x);

    // 设置S的Exception Program Counter(epc)为保存的pc
    w_sepc(p->trapframe->epc);

    // 将用户页表转换为satp寄存器需要的格式
    uint64 satp = MAKE_SATP(p->pagetable);

    // 跳转到虚拟内存顶端的trampoline.S, 它会切换页表为用户页表, 恢复用户
    // 寄存器, 并通过sret切换到用户模式。

    uint64 fn = TRAMPOLINE + (userret - trampoline);
    ((void (*)(uint64, uint64)) fn)(TRAPFRAME, satp);
}

//
// 需要调度时返回到这里
//


// kernel空间trap处理程序，
// TODO 添加用户空间时修改
uint64 trap_ra;

void kerneltrap() {
    int which_dev = 0;
    struct proc *p = myproc();
    uint64 sepc = r_sepc(); // 监督者模式下的异常程序寄存器
    uint64 sstatus = r_sstatus(); // 监督者模式下的状态寄存器，用于保存异常的的一些信息
    uint64 scause = r_scause(); // 异常的种类

    // 判断异常的来源, 若来自用户空间直接宕机
    if ((sstatus & SSTATUS_SPP) == 0)
        panic("kerneltrap: not from supervisor mode");

    // 判读是否允许中断, 若不允许直接宕机
    if (intr_get() != 0)
        panic("kerneltrap: interrupts enabled");

    which_dev = device_intr();
    if (which_dev == 0) { // 未知来源
        printf("scause %p\n", scause);
        printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
        panic("kerneltrap");
    }

    if (which_dev == 2 && p != 0 && p->state == RUNNING) { // 时钟中断
        yield();
    }
    w_sepc(sepc);
    w_sstatus(sstatus);
}

// 定时器中断处理程序
void clockintr() {
    spin_lock(&ticks_lock);
    ticks++;
    spin_unlock(&ticks_lock);
    wakeup(&ticks);
}

// 设备中断处理程序
// 用于判断中断是否为外部和软件中断，并处理它
// 2: 时钟中断
// 1: 其他设备中断
// 0: 无法识别的中断
int device_intr() {
    uint64 scause = r_scause();

    if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
        // 这是监督者的外部中断, 通过PLIC
        // irq 表明设备的种类
        int irq = plic_claim();
        if (irq == UART0_IRQ) {
            uart_intr();
        } else if (irq == VIRTIO0_IRQ) {
            virtio_disk_intr();
        } else if (irq) {
            printf("unexpected interrupt irq=%d\n", irq);
        }

        // PLIC只允许设备同时最多抛出一个中断;
        // 告诉PLIC该设备现在被允许再次抛出中断
        if (irq)
            plic_complete(irq);

        return 1;
    } else if (scause == 0x8000000000000001L) {
        // 软件中断, 机器模式下的时钟中断抛出,
        // 将在kernelvec.S后被调用
        if (cpuid() == 0) {
            clockintr();
        }
        // 告知以收到软件中断，通过清除sip的SSIP位
        w_sip(r_sip() & ~2);
        return 2;
    } else {
        return 0;
    }
}
