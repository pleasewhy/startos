

#include "os/trap.hpp"
#include "driver/dmac.hpp"
#include "driver/virtio.hpp"
#include "StartOS.hpp"
#include "common/logger.h"
#include "common/printk.hpp"
#include "common/sbi.h"
#include "common/string.hpp"
#include "device/Console.hpp"
#include "fcntl.h"
#include "fs/vfs/Vfs.hpp"
#include "memlayout.hpp"
#include "memory/MemAllocator.hpp"
#include "os/Cpu.hpp"
#include "driver/Plic.hpp"
#include "os/SpinLock.hpp"
#include "os/Syscall.hpp"
#include "os/TaskScheduler.hpp"
#include "os/Timer.hpp"
#include "riscv.hpp"
#include "types.hpp"

// kernelvec.S, 调用kerneltrap
extern "C" void kernelvec();

extern int device_intr();

extern Console      console;
extern MemAllocator memAllocator;

extern "C" char trampoline[], uservec[], userret[];

// 配置中断处理程序
void trapinit(void)
{
  w_stvec((uint64_t)kernelvec);
}

void trapinithart(void)
{
  w_stvec((uint64_t)kernelvec);
  w_sstatus(r_sstatus() | SSTATUS_SIE);
  // enable supervisor-mode timer interrupts.
  w_sie(r_sie() | SIE_SEIE | SIE_SSIE | SIE_STIE);
  timer::setTimeout();
}

void trapframedump(struct trapframe *tf);

/**
 *  处理用户空间的interrupt, exception, 系统调用
 *  trampoline.S会调用该函数
 */
void usertrap(void)
{
  int which_dev = 0;
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    panic("usertrap: not from user mode");

  // 由于现在处于内核空间, 所以需要更改中断向量为kerneltrap()
  w_stvec((uint64_t)kernelvec);
  //    printf("usertrap: sp=%p\n",r_sp());

  Task *task = myTask();

  // 保存用户空间的PC
  task->trapframe->epc = r_sepc();
  if (r_scause() == 8) {
    // 系统调用
    if (task->killed) {
      LOG_DEBUG("usertrap killed");
      exit(-1);
    }
    // sepc指向了ecall指令, 但是我们希望返回到ecall的下一条指令。
    task->trapframe->epc += 4;
    // 中断会改变部分寄存器，如sstatus，所以在使用完这些寄存器
    // 之前不能开中断
    intr_on();
    syscall();
  }
  else if (r_scause() == 13 || r_scause() == 5) {
    uint64_t    eaddr;
    struct vma *vma = 0;
    char *      mem;
    eaddr = r_stval();
    for (int i = 0; i < NOMMAPFILE; i++) {
      if (task->vma[i] != 0 && eaddr >= task->vma[i]->addr &&
          eaddr < task->vma[i]->addr + task->vma[i]->length) {
        vma = task->vma[i];
        break;
      }
    }
    if (vma != 0) {
      mem = (char *)memAllocator.alloc();
      memset(mem, 0, PGSIZE);
      eaddr = PGROUNDDOWN(eaddr);
      int perm = PTE_V | PTE_U;
      if (vma->prot & PROT_READ)
        perm |= PTE_R;
      if (vma->prot & PROT_WRITE)
        perm |= PTE_W;
      mappages(task->pagetable, eaddr, PGSIZE, (uint64_t)mem, perm);
      vfs::read(vma->f, false, mem, PGSIZE, eaddr - vma->addr);
    }
    else {
      task->killed = 1;
    }
  }
  else if ((which_dev = device_intr()) != 0) {
    // ok
  }
  else {
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), task->pid);
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    task->killed = 1;
  }

  if (task->killed)
    exit(-1);

  // 若是时钟中断则放弃CPU
  if (which_dev == 2) {
    yield();
  }

  usertrapret();
}

void usertrapret()
{
  Task *task = myTask();

  // 现在将trap处理程序从kerneltrap()切换为usertrap(), 因此需要
  // 禁用中断直到我们返回用户空间。
  intr_off();

  // 现在返回用户空间，设置中断处理函数为trampoline.S的uservec()
  w_stvec(TRAMPOLINE + ((uint64_t)uservec - (uint64_t)trampoline));

  // 设置trapframe, 以便下次的trap能够正常运行
  task->trapframe->kernel_satp = r_satp();             // 内核页表
  task->trapframe->kernel_sp = task->kstack + PGSIZE;  // 进程的内核栈
  task->trapframe->kernel_trap = (uint64_t)usertrap;
  task->trapframe->kernel_hartid = r_tp();  // cpu id

  // 设置trampoline.S中的sret返回用户空间所需要的寄存器

  // 设置S Previous Privilege(SPP)为User
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP;  // 为用户模式清除SPP
  x |= SSTATUS_SPIE;  // 允许用户模式下的中断
  w_sstatus(x);

  // 设置S的Exception Program Counter(epc)为保存的pc
  w_sepc(task->trapframe->epc);

  // 将用户页表转换为satp寄存器需要的格式
  uint64_t satp = MAKE_SATP(task->pagetable);

  // 跳转到虚拟内存顶端的trampoline.S, 它会切换页表为用户页表, 恢复用户
  // 寄存器, 并通过sret切换到用户模式。

  uint64_t fn = TRAMPOLINE + ((uint64_t)userret - (uint64_t)trampoline);
  ((void (*)(uint64_t, uint64_t))fn)(TRAPFRAME, satp);
}

// kernel空间trap处理程序，
extern "C" void kerneltrap()
{
  int      which_dev = 0;
  Task *   task = myTask();
  uint64_t sepc = r_sepc();  // 监督者模式下的异常程序寄存器
  uint64_t sstatus =
      r_sstatus();  // 监督者模式下的状态寄存器，用于保存异常的的一些信息
  uint64_t scause = r_scause();  // 异常的种类

  // 判断异常的来源, 若来自用户空间直接宕机
  if ((sstatus & SSTATUS_SPP) == 0)
    panic("kerneltrap: not from supervisor mode");

  // 判读是否允许中断, 若不允许直接宕机
  if (intr_get() != 0)
    panic("kerneltrap: interrupts enabled");
  which_dev = device_intr();
  if (which_dev == 0) {  // 未知来源
    printf("scause %p\n", scause);
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    // printf("process id = %d",myproc()->pid);
    panic("kerneltrap");
  }

  if (which_dev == 2 && task != 0 && task->state == RUNNING) {  // 时钟中断
    yield();
  }

  w_sepc(sepc);
  w_sstatus(sstatus);
}

// 设备中断处理程序
// 用于判断中断是否为外部和软件中断，并处理它
// 2: 时钟中断
// 1: 其他设备中断
// 0: 无法识别的中断
int device_intr()
{
  uint64_t scause = r_scause();
#ifdef QEMU
  // handle external interrupt
  if ((0x8000000000000000L & scause) && 9 == (scause & 0xff))
#else
  // k210上没有监督者外部中断，这里外部中断是通过rustsbi提供的
  if (0x8000000000000001L == scause && 9 == r_stval())
#endif
  {
    int irq = plic::claim();
    if (UART_IRQ == irq) {
      // LOG_DEBUG("uart");
      // keyboard input
      int c = sbi_console_getchar();
      if (-1 != c) {
        console.console_intr(c);
      }
    }
    else if (DMA0_IRQ == irq) {
#ifdef K210
      dmac_intr(DMAC_CHANNEL0);
#endif
    }
    else if (VIRTIO_IRQ == irq) {
#ifdef QEMU
      VirtioIntr();
#endif
    }
    else if (irq) {
      printf("unexpected interrupt irq = %d\n", irq);
    }

    if (irq) {
      plic::complete(irq);
    }

#ifndef QEMU
    w_sip(r_sip() & ~2);  // clear pending bit
    sbi_set_mie();
#endif

    return 1;
  }
  else if (0x8000000000000005L == scause) {
    timer::handleIntr();
    return 2;
  }
  else {
    return 0;
  }
}
void trapframedump(struct trapframe *tf)
{
  printf("a0: %p\t", tf->a0);
  printf("a1: %p\t", tf->a1);
  printf("a2: %p\t", tf->a2);
  printf("a3: %p\n", tf->a3);
  printf("a4: %p\t", tf->a4);
  printf("a5: %p\t", tf->a5);
  printf("a6: %p\t", tf->a6);
  printf("a7: %p\n", tf->a7);
  printf("t0: %p\t", tf->t0);
  printf("t1: %p\t", tf->t1);
  printf("t2: %p\t", tf->t2);
  printf("t3: %p\n", tf->t3);
  printf("t4: %p\t", tf->t4);
  printf("t5: %p\t", tf->t5);
  printf("t6: %p\t", tf->t6);
  printf("s0: %p\n", tf->s0);
  printf("s1: %p\t", tf->s1);
  printf("s2: %p\t", tf->s2);
  printf("s3: %p\t", tf->s3);
  printf("s4: %p\n", tf->s4);
  printf("s5: %p\t", tf->s5);
  printf("s6: %p\t", tf->s6);
  printf("s7: %p\t", tf->s7);
  printf("s8: %p\n", tf->s8);
  printf("s9: %p\t", tf->s9);
  printf("s10: %p\t", tf->s10);
  printf("s11: %p\t", tf->s11);
  printf("ra: %p\n", tf->ra);
  printf("sp: %p\t", tf->sp);
  printf("gp: %p\t", tf->gp);
  printf("tp: %p\t", tf->tp);
  printf("epc: %p\n", tf->epc);
}
