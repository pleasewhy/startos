#ifndef DISK_HPP
#define DISK_HPP
#include "fs/inodefs/BufferLayer.hpp"
#include "fs/disk/Disk.hpp"
#ifdef QEMU
#include "fs/disk/VirtioDisk.hpp"
#else
#include "fs/disk/SdCard.hpp"
#include "driver/dmac.hpp"
#endif


void disk_init(void) {
#ifdef QEMU
  virtio_init();
#else
  sdcard_init();
#endif
}

void disk_read(struct buf *b) {
#ifdef QEMU
  virtio_read(b);
#else
sdcard_read_sector(b->data, b->blockno);
#endif
}

void disk_write(struct buf *b) {
#ifdef QEMU
  virtio_write(b);
#else
  sdcard_write_sector(b->data, b->blockno);
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