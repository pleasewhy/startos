#include "os/Timer.hpp"
#include "common/printk.hpp"
#include "common/sbi.h"
#include "riscv.hpp"
#include "types.hpp"
#include "StartOS.hpp"

// extern "C" void timervec();

Timer::Timer(uint32_t interval) : interval(interval) {
}

void Timer::init() {
  spinLock.init("timer");
  setTimeout();
}

void Timer::setTimeout() {
  int t = r_time() + INTERVAL;
  sbi_set_timer(t);
}

void Timer::handleIntr() {
  this->spinLock.lock();
  this->ticks++;
  this->spinLock.unlock();
  setTimeout();
}