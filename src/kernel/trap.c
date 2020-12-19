#include "types.h"
#include "param.h"
#include "riscv.h"
#include "memlayout.h"
#include "process.h"
#include "defs.h"

// kernelvec.S, 调用kerneltrap
void kernelvec();

extern int device_intr();

uint64 ticks; // 定时器中断次数，可用于计时

// 配置中断处理程序
void trapinit(void)
{
    w_stvec((uint64)kernelvec);
}

//
// 处理进程error的情况
// 中断处理程序检测到错误将会返回到这里
//
void proc_err()
{
    exit(-1);
}

//
// 需要调度时返回到这里
//
void proc_sched();
uint64 trap_pc;

// kernel空间trap处理程序，
// TODO 添加用户空间时修改
uint64 trap_ra;
void kerneltrap()
{
    int which_dev = 0;
    struct proc* p = myproc();
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
        printf("pid=%d error\n", p->pid);
        printf("scause=%d sepc=%p\n", scause, sepc);
        sepc = (uint64)proc_err; // 将异常的返回地址设置为proc_err
    } else if (which_dev == 1) { // uart中断
        // 这里不用处理
    } else if (which_dev == 2 && p != 0 && p->state == RUNNING) { // 时钟中断
        // 将进程context的ra设置为sepc, 中断时的pc。
        trap_pc = sepc;
        sepc =(uint64)proc_sched;
    }
    w_sepc(sepc);
    w_sstatus(sstatus);
}

// 定时器中断处理程序
void clockintr()
{
    ticks++;
    wakeup(&ticks);
}

// 设备中断处理程序
// 用于判断中断是否为外部和软件中断，并处理它
// 2: 时钟中断
// 1: 其他设备中断
// 0: 无法识别的中断
int device_intr()
{
    uint64 scause = r_scause();

    if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
        // 这是监督者的外部中断, 通过PLIC
        // irq 表明设备的种类
        int irq = plic_claim();

        if (irq == UART0_IRQ) {
            uart_intr();
        } else if (irq == VIRTIO0_IRQ) {
            // 没有磁盘
            panic("no disk irq=%d\n", irq);
        } else if (irq) {
            panic("unexpected interrupt irq=%d\n", irq);
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