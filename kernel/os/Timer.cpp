#include "os/Timer.hpp"
#include "StartOS.hpp"
#include "common/printk.hpp"
#include "common/sbi.h"
#include "os/TaskScheduler.hpp"
#include "riscv.hpp"
#include "types.hpp"

namespace timer {
int ticks;
SpinLock spinLock;
uint32_t interval;
void init() {
  spinLock.init("timer");
  setTimeout();
}

void setTimeout() {
  int t = r_time() + INTERVAL;
  sbi_set_timer(t);
}

void handleIntr() {
  spinLock.lock();
  ticks++;
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