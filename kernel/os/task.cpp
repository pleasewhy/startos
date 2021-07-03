#include "os/Process.hpp"
#include "os/TaskScheduler.hpp"
#include "fs/vfs_file.h"
#include "common/string.hpp"

void vma::free()
{
  if (ip != 0)
    ip->free();
  memset(this, 0, sizeof(struct vma));
  freeVma(this);
}