#include "os/SleepLock.hpp"
#include "os/TaskScheduler.hpp"
#include "os/Process.hpp"

void SleepLock::init(const char *name) {
  this->spinlock.init("sleep lock");
  this->name = name;
  this->locked = 0;
  this->pid = 0;
}

void SleepLock::lock() {
  this->spinlock.lock();
  while (this->locked) {
    sleep(this, &this->spinlock);
  }
  this->locked = 1;
  this->pid = myTask()->pid;
  this->spinlock.unlock();
}

void SleepLock::unlock(){
  this->spinlock.lock();
  this->locked = 0;
  this->pid = 0;
  wakeup(this);
  this->spinlock.unlock();
}