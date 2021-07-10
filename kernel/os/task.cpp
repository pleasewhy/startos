#include "os/Process.hpp"
#include "os/TaskScheduler.hpp"
#include "fs/vfs_file.h"
#include "common/string.hpp"

bool Task::LoadIfValid(uint64_t va)
{
  for (int i = 0; i < NOMMAPFILE; i++) {
    if (this->vma[i] != 0 && this->vma[i]->LoadIfContain(this->pagetable, va)) {
      return true;
    }
  }
  return false;
}