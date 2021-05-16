#ifndef SLEEP_LOCK_HPP
#define SLEEP_LOCK_HPP
#include "os/SpinLock.hpp"
#include "types.hpp"
#include "StartOS.hpp"

class SleepLock {
 public:
  void init(const char *name);
  void lock();
  void unlock();
  int holding();

 private:
  uint_t locked;
  SpinLock spinlock;  // 保护睡眠锁

  // For debugging:
  const char *name;  // 锁的名称
  int pid;     // 持有该锁的进程
};
#endif