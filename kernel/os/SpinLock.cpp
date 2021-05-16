// #include "os/SpinLock.hpp"
#include "common/printk.hpp"
#include "os/Cpu.hpp"
// #include "os/SpinLock.hpp"
#include "os/Intr.hpp"
SpinLock::SpinLock() {}
SpinLock::SpinLock(const char *name) {
  this->name = name;
  locked = false;
  this->cpuid = Cpu::cpuid();
}

void SpinLock::init(const char *name) {
  this->name = name;
  locked = false;
  this->cpuid = Cpu::cpuid();
}

void SpinLock::lock() {
  Intr::push_off();  // 禁用中断以避免死锁。
  if (holding()) {
    printf("%s ", this->name);
    panic("re-acquire");
  }

  // 在RISC-V中，sync_lock_test_and_set会转化成原子swap：
  //   a5 = 1
  //   s1 = &lk->locked
  //   amoswap.w.aq a5, a5, (s1)
  while (__sync_lock_test_and_set(&(this->locked), 1) != 0)
    ;

  // 告诉C编译器和处理器在这之后就不要不要移动load和store指令，
  // 确保临界区中的内存引用会在锁获取之后进行。
  // 在RISC-V中, 这个函数生成fence指令。
  __sync_synchronize();

  // 记录获取锁的cpu
  cpuid = Cpu::cpuid();
}

// 自旋锁unlock
void SpinLock::unlock() {
  if (!holding()) {
    printf("%s ",this->name);
    panic("unlock");
  }

  this->cpuid = -1;

  // 内存屏障，防止将编译器或者CPU将该语句上方的
  // 语句re-order到语句下方。
  // 在RISC-V中，将生成fence指令
  __sync_synchronize();

  // 释放锁, 相当于lk->locked=0.
  // 代码里不能使用C引用, 因为C标准指明了引用会被翻译成多个store机器指令
  // 在RISC-V中,sync_lock_release会被翻译为原子交换：
  // s1 = &lk->locked
  // amoswap.w zero, zero, (s1)
  __sync_lock_release(&locked);

  Intr::pop_off();
}

bool SpinLock::holding() {
  int r;
  r = (this->locked && this->cpuid == Cpu::cpuid());
  return r;
}
