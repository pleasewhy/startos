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