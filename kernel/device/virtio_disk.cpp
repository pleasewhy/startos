#include "device/virtio_disk.hpp"
#include "driver/virtio.hpp"
#include "common/string.hpp"

namespace dev {

VirtioDisk::VirtioDisk(const char *name)
{
  memset(this->name, 0, DEV_NAME_SIZE);
  strncpy(this->name, name, strlen(name));
}

void VirtioDisk::init()
{
  VirtioInit();
}

int VirtioDisk::read(char *buf, int offset, int n)
{
  if (512 != n || 0 != offset % 512) {
    return -1;
  }
  int sector = offset / 512;
  VirtioRead(buf, sector);
  return 512;
}

int VirtioDisk::write(char *buf, int offset, int n)
{
  if (512 != n || 0 != offset % 512) {
    return -1;
  }
  int sector = offset / 512;
  VirtioWrite(buf, sector);
  return 512;
}
}  // namespace dev