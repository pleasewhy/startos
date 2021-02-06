#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"

__attribute__((aligned(16))) char stack0[4096 * NCPU];

// 为定时器中断准备的scratch区域, 每个CPU一个
uint64 mscratch0[NCPU * 32];

void main();
void timerinit();
extern void timervec();
extern void kernelvec();

void start()
{
    // 将机器模式的"先前模式"设置为监督者模式, 
    // 供mret使用
    unsigned long x = r_mstatus();
    x &= ~MSTATUS_MPP_MASK;
    x |= MSTATUS_MPP_S;
    w_mstatus(x);

    // 设置M机器模式的异常程序计数器为main, 供mret使用
    // 需要 gcc -mcmode=medany
    w_mepc((uint64)main);

    // 禁用分页
    w_satp(0);

    // 将全部中断和异常委托给监督者模式处理
    w_medeleg(0xffff);
    w_mideleg(0xffff);
    w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);

    // 请求时钟中断
    timerinit();

    // 将cpu的hartid保存在tp寄存器中, for cpuid().
    int id = r_mhartid();
    w_tp(id);

    // 切换到监督者模式，并跳转到main函数.
    asm volatile("mret");
}

// 配置机器模式下的时钟中断，使其能够被kernelvec.S中的
// timervec函数处理，timervec会抛出一个软件中断让，trap.c
// 中的devintr()处理
void timerinit()
{
    // 每个cpu都有自己的时钟中断源
    int id = r_mhartid();

    // 向CLINT请求时钟中断
    int interval = 1000000*10; // 周期, 在qemu中差不多是1/10秒
    *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;

    // 为timervec准备scratch[]中的内容
    // scratch[0..3]: timervec保存寄存器的空间
    // scratch[4]: CLINT MTIMECMP寄存器的地址
    // scratch[5]: 将时钟中断周期设置为intverval
    uint64 *scratch = &mscratch0[32 * id];
    scratch[4] = CLINT_MTIMECMP(id);
    scratch[5] = interval;
    w_mscratch((uint64)scratch);

    // 设置机器模式下的trap处理程序
    w_mtvec((uint64)timervec);

    // 允许机器模式中断
    w_mstatus(r_mstatus() | MSTATUS_MIE);

    // 允许机器模式时钟中断
    w_mie(r_mie() | MIE_MTIE);
}