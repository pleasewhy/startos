#include "fs/Pipe.hpp"
#include "common/logger.h"
#include "fs/vfs/FileSystem.hpp"
#include "os/TaskScheduler.hpp"

Pipe::Pipe(struct file *f0, struct file *f1) {
  this->readopen = true;
  this->writeopen = true;
  this->nwrite = 0;
  this->nread = 0;
  this->lock_.init("pipe");
  f0->type = f0->FD_PIPE;
  f0->readable = true;
  f0->writable = false;
  f0->pipe = this;

  f1->type = f1->FD_PIPE;
  f1->readable = false;
  f1->writable = true;
  f1->pipe = this;
}

int Pipe::read(uint64_t addr, int n) {
  int i;
  Task *task = myTask();
  char ch;
  this->lock_.lock();

  // 无数据可读，等待数据写入管道
  while (this->nread == this->nwrite && this->writeopen) {
    if (task->killed) {
      this->lock_.unlock();
      return -1;
    }
    sleep(&this->nread, &this->lock_);
  }

  // 读取n字节数据
  for (i = 0; i < n; i++) {
    if (this->nread == this->nwrite) break;
    ch = this->data[this->nread++ % PIPESIZE];
    if (copyout(task->pagetable, addr + i, &ch, 1) == -1) break;
  }
  wakeup(&this->nwrite);
  this->lock_.unlock();
  // LOG_TRACE("pipe read complete i=%d write=%d read=%d", i, this->nwrite, this->nread);
  return i;
}

int Pipe::write(uint64_t addr, int n) {
  LOG_TRACE("pipe write");
  int i;
  char ch;
  Task *task = myTask();

  this->lock_.lock();
  for (i = 0; i < n; i++) {
    // 缓存区满了，等待读取
    while (this->nwrite == this->nread + PIPESIZE) {
      if (this->readopen == 0 || task->killed) {
        this->lock_.unlock();
        return -1;
      }
      wakeup(&this->nread);
      sleep(&this->nwrite, &this->lock_);
    }
    if (copyin(task->pagetable, &ch, addr + i, 1) == -1) break;
    this->data[this->nwrite++ % PIPESIZE] = ch;
  }
  wakeup(&this->nread);
  this->lock_.unlock();
  LOG_TRACE("pipe write finish i=%d", i);
  return i;
}

void Pipe::close(EndType ty) {
  this->lock_.lock();
  if (ty == EndType::READ_END) {
    this->readopen = false;
    wakeup(&this->nwrite);
  } else {
    this->writeopen = false;
    wakeup(&this->nread);
  }
  if ((!this->readopen) && (!this->writeopen)) {
    this->lock_.unlock();
    delete this;
  } else {
    this->lock_.unlock();
  }
}
