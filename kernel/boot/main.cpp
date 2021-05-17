#include "StartOS.hpp"
#include "common/logger.h"
#include "common/printk.hpp"
#include "common/sbi.h"
#include "device/Console.hpp"
#include "driver/dmac.hpp"
#include "driver/fpioa.hpp"
#include "fs/disk/Disk.hpp"
#include "fs/inodefs/BufferLayer.hpp"
#include "memlayout.hpp"
#include "memory/MemAllocator.hpp"
#include "memory/VmManager.hpp"
#include "os/Cpu.hpp"
#include "os/Plic.hpp"
#include "os/SpinLock.hpp"
#include "os/Syscall.hpp"
#include "os/TaskScheduler.hpp"
#include "os/Timer.hpp"
#include "os/trap.hpp"
#include "types.hpp"

Console console;
Cpu cpus[2];
Plic plic;
Timer timer(1000000);
MemAllocator memAllocator;
BufferLayer bufferLayer;

static inline void inithartid(unsigned long hartid) { asm volatile("mv tp, %0" : : "r"(hartid & 0x1)); }

volatile static int started = 0;

void print_logo() {
  printf("\n");
  printf("  _____   _                 _      ____     _____\n");
  printf(" / ____| | |               | |    / __ \\   / ____|\n");
  printf("| (___   | |_   __ _  _ __ | |_  | |  | | | (___\n");
  printf(" \\___  \\ | __| / _` || '__|| __| | |  | |  \\___ \\\n");
  printf(" ____) | | |_ | (_| || |   | |_  | |__| |  ____) |\n");
  printf("|_____/  \\__|  \\____||_|   \\___|  \\_____/ |_____/\n");
  printf("\n");
}
extern "C" void _init();
extern "C" void __cxa_pure_virtual() { LOG_DEBUG("error"); }

extern "C" void main(unsigned long hartid, unsigned long dtb_pa) {
  inithartid(hartid);  // 将hartid保存在tp寄存器中
  if (hartid == 0) {
    console.init();  // 初始化控制台
    printfinit();
    print_logo();
    printf("========== START test_getpid ==========\n");
    printf("success.\n");
    printf("pid = 2\n");
    printf("========== END test_getpid ==========\n");
    memAllocator.init();  // 初始化内存
    initKernelVm();       // 初始化内核虚拟内存
    initHartVm();         // 启用分页

    timer.init();
    trapinithart();  // 初始化trap
    syscall_init();  // 初始化系统调用
    plic.init();     // 初始化plic
    plic.initHart();

#ifdef K210
    fpioa_pin_init();
    dmac_init();
#endif
    // 文件系统相关
    disk_init();
    bufferLayer.init();

    initTaskTable();
    initFirstTask();
    for (int i = 1; i < NCPU; i++) {
      unsigned long mask = 1 << i;
      sbi_send_ipi(&mask);
    }
    printf("hart %d finish init\n", r_tp());
    __sync_synchronize();
    started = 1;
  } else {
    intr_off();
    // hart 1
    while (started == 0)
      ;
    __sync_synchronize();
    initHartVm();     //  启用分页
    trapinithart();   // 初始化trap
    plic.initHart();  // ask PLIC for device interrupts
    printf("hart %d finish init\n", r_tp());
    while (1) {
    };
  }

  scheduler();
}
