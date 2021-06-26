#include "fs/vfs_file.h"
#include "fs/vfs/FileSystem.hpp"
#include "common/printk.hpp"

struct inode *inode::dup()
{
  sleeplock.lock();
  ref++;
  sleeplock.unlock();
  return this;
}

void inode::free()
{
  sleeplock.lock();
  if (ref < 1) {
    panic("inode free");
  }
  if (ref-- == 0) {
    delete this;
  }
  // this->file_system;
  sleeplock.unlock();
}

void inode::lock()
{
  this->sleeplock.lock();
}

void inode::unlock()
{
  this->sleeplock.unlock();
}

int inode::read(char *buf, uint32_t off, int n, bool user)
{
  this->lock();
  int ans = file_system->ReadInode(this, user, (uint64_t)buf, off, n);
  this->unlock();
  return ans;
}

int inode::write(const char *buf, uint32_t off, int n, bool user)
{
  this->lock();
  int ans = file_system->WriteInode(this, user, (uint64_t)buf, off, n);
  this->unlock();
  return ans;
}