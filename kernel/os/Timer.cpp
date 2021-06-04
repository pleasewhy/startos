#include "os/Timer.hpp"
#include "StartOS.hpp"
#include "common/printk.hpp"
#include "common/sbi.h"
#include "common/logger.h"
#include "driver/sysctl.hpp"
#include "os/TaskScheduler.hpp"
#include "riscv.hpp"
#include "types.hpp"

namespace timer {
int ticks;
SpinLock spinLock;
uint32_t interval;
void init() {
  ticks = 0;
  spinLock.init("timer");
#ifdef K210
  // 不知道具体数值，选一个比较接近的
  // k210中mtime的增长频率应该是CPU频率的1/n，不清楚sipeed dock
  // 这块板子的具体数值。测试了一下好像24比较合适
  uint32_t freq = sysctl_clock_get_freq(SYSCTL_CLOCK_CPU) / 24; // 24比较接近，误差在10ms以内
  size_t value = INTERVAL * freq / 1000;
  LOG_INFO("timer freq=%d value=%d\n",freq ,value);
  interval = value;
#else
  // qemu中这差不多是100ms
  interval = 1000000;
#endif
  setTimeout();
}

void setTimeout() {
  int t = r_time() + interval;
  sbi_set_timer(t);
}

void handleIntr() {
  spinLock.lock();
  ticks++;
  wakeup(&ticks);
  spinLock.unlock();
  Task *task = myTask();
  if (task == 0) {
    setTimeout();
    return;
  }
  if ((r_sstatus() & SSTATUS_SPP) == 0) {  // user
    task->lock.lock();
    task->uticks++;
    task->lock.unlock();
  } else {  // kernel
    task->lock.lock();
    task->sticks++;
    task->lock.unlock();
  }
  setTimeout();
}
}  // namespace timer