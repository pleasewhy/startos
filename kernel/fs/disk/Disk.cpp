#ifndef DISK_HPP
#define DISK_HPP
#include "fs/inodefs/BufferLayer.hpp"
#include "fs/disk/Disk.hpp"
#ifdef QEMU
#include "fs/disk/VirtioDisk.hpp"
#else
#include "device/SdCard.hpp"
#include "driver/dmac.hpp"
#endif


void disk_init(void) {
#ifdef QEMU
  virtio_init();
#endif
}

void disk_read(struct buf *b) {
#ifdef QEMU
  virtio_read(b);
#endif
}

void disk_write(struct buf *b) {
#ifdef QEMU
  virtio_write(b);
#endif
}

void disk_intr(void) {
#ifdef QEMU
  virtio_disk_intr();
#else
  dmac_intr(DMAC_CHANNEL0);
#endif
}
#endif