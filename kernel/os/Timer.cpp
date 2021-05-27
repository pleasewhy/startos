#include "os/Timer.hpp"
#include "StartOS.hpp"
#include "common/printk.hpp"
#include "common/sbi.h"
#include "driver/sysctl.hpp"
#include "os/TaskScheduler.hpp"
#include "riscv.hpp"
#include "types.hpp"

namespace timer {
int ticks;
SpinLock spinLock;
uint32_t interval = 152343;
void init() {
  ticks = 0;
  spinLock.init("timer");
  uint32_t freq = sysctl_clock_get_freq(sysctl_clock_t((int)(timer::TIMER_DEVICE_1) + (int)SYSCTL_CLOCK_TIMER0));
  // printf("freq=%d\n", freq);
  // freq=1523437
  uint64_t tmp = freq * INTERVAL;
  interval = tmp / 1000;
  // 100ms, interval=152343
  // interval = 152343;
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