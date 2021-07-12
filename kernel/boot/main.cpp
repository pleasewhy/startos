#include "StartOS.hpp"
#include "common/logger.h"
#include "common/printk.hpp"
#include "common/sbi.h"
#include "device/Clock.hpp"
#include "device/Console.hpp"
#include "device/DeviceManager.hpp"
#include "driver/Plic.hpp"
#include "driver/dmac.hpp"
#include "driver/fpioa.hpp"
#include "memlayout.hpp"
#include "memory/BuddyAllocator.hpp"
#include "memory/MemAllocator.hpp"
#include "fs/buf/BufferLayer.hpp"
#include "memory/VmManager.hpp"
#include "os/Cpu.hpp"
#include "os/SpinLock.hpp"
#include "os/Syscall.hpp"
#include "os/TaskScheduler.hpp"
#include "os/Timer.hpp"
#include "os/trap.hpp"
#include "types.hpp"

Console             console;
Cpu                 cpus[2];
MemAllocator        memAllocator;  // 用于分配页
mem::BuddyAllocator buddy_alloc_;  // 用于通用内存内配
BufferLayer         buffer_layer;

static inline void inithartid(unsigned long hartid)
{
  asm volatile("mv tp, %0" : : "r"(hartid & 0x1));
}

volatile static int started = 0;

void print_logo()
{
  printf("\n");
  printf("  _____   _                 _      ____     _____\n");
  printf(" / ____| | |               | |    / __ \\   / ____|\n");
  printf("| (___   | |_   __ _  _ __ | |_  | |  | | | (___\n");
  printf(" \\___  \\ | __| / _` || '__|| __| | |  | |  \\___ \\\n");
  printf(" ____) | | |_ | (_| || |   | |_  | |__| |  ____) |\n");
  printf("|_____/  \\__|  \\____||_|   \\___|  \\_____/ |_____/\n");
  printf("\n");
}

typedef void (*function_t)();
// 由链接脚本提供
extern "C" function_t __init_array_start[];
extern "C" function_t __init_array_end[];

void _call_global_constructor()
{
  // 调用全局对象构造函数
  for (function_t *fn = __init_array_start; fn < __init_array_end; fn++) {
    (*fn)();
  }
}

extern "C" void main(unsigned long hartid, unsigned long dtb_pa)
{
  inithartid(hartid);  // 将hartid保存在tp寄存器中
  cpus[hartid].init();
  if (hartid == 0) {
    console.init();  // 初始化控制台
    printfinit();
    print_logo();
    _call_global_constructor();  // 初始化全局对象
    memAllocator.init();         // 初始化page分配器
    buddy_alloc_.init();         // 初始化通用内存分配器
    initKernelVm();              // 初始化内核虚拟内存
    initHartVm();                // 启用分页
    timer::init();
    buffer_layer.init();  // 初始化缓存区
    // InitVmaTable();       // 初始化全部vma
    trapinithart();       // 初始化trap
    syscall_init();       // 初始化系统调用
    plic::init();         // 初始化plic
    plic::initHart();

    dev::Init();  // 初始化已有设备

    initTaskTable();
    initFirstTask();
    for (int i = 1; i < NCPU; i++) {
      unsigned long mask = 1 << i;
      sbi_send_ipi(&mask);
    }
    printf("hart %d finish init\n", r_tp());
    __sync_synchronize();
    started = 1;
  }
  else {
    intr_off();
    // hart 1
    while (started == 0)
      ;
    __sync_synchronize();
    initHartVm();      //  启用分页
    trapinithart();    // 初始化trap
    plic::initHart();  // ask PLIC for device interrupts
    printf("hart %d finish init\n", r_tp());
    // while (1) {
    // }
  }
  scheduler();
}
