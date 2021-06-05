#include "driver/virtio.hpp"
#include "common/printk.hpp"
#include "common/string.hpp"
#include "memlayout.hpp"
#include "os/Process.hpp"
#include "os/TaskScheduler.hpp"
#include "types.hpp"
#include "StartOS.hpp"

alignas(4096) struct VirtioDisk virtioDisk;

#define BSIZE 512

/**
 * @brief 在读写磁盘需要用到的工具函数，主要是用来管理
 *        descriptor。
 *
 * @return int
 */
static int  alloc_desc();
static void free_desc(int i);
static void free_chain(int i);
static int  alloc3_desc(int *idx);

void VirtioInit()
{
  uint32_t status = 0;

  virtioDisk.vdiskLock.init("virtio_disk");

  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
      *R(VIRTIO_MMIO_VERSION) != 1 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    panic("could not find virtio disk");
  }

  status |= VIRTIO_CONFIG_S_ACKNOWLEDGE;
  *R(VIRTIO_MMIO_STATUS) = status;

  status |= VIRTIO_CONFIG_S_DRIVER;
  *R(VIRTIO_MMIO_STATUS) = status;

  // negotiate features
  uint64_t features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
  features &= ~(1 << VIRTIO_BLK_F_RO);
  features &= ~(1 << VIRTIO_BLK_F_SCSI);
  features &= ~(1 << VIRTIO_BLK_F_CONFIG_WCE);
  features &= ~(1 << VIRTIO_BLK_F_MQ);
  features &= ~(1 << VIRTIO_F_ANY_LAYOUT);
  features &= ~(1 << VIRTIO_RING_F_EVENT_IDX);
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;

  // tell device that feature negotiation is complete.
  status |= VIRTIO_CONFIG_S_FEATURES_OK;
  *R(VIRTIO_MMIO_STATUS) = status;

  // tell device we're completely ready.
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
  *R(VIRTIO_MMIO_STATUS) = status;

  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;

  // initialize queue 0.
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
  uint32_t max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
  if (max == 0)
    panic("virtio disk has no queue 0");
  if (max < NUM)
    panic("virtio disk max queue too short");
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
  memset(virtioDisk.pages, 0, sizeof(virtioDisk.pages));
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64_t)virtioDisk.pages) >> PGSHIFT;

  // desc = pages -- num * virtq_desc
  // avail = pages + 0x40 -- 2 * uint16_t, then num * uint16_t
  // used = pages + 4096 -- 2 * uint16_t, then num * vRingUsedElem

  virtioDisk.desc = (struct virtq_desc *)virtioDisk.pages;
  virtioDisk.avail = (struct virtq_avail *)(virtioDisk.pages +
                                            NUM * sizeof(struct virtq_desc));
  virtioDisk.used = (struct virtq_used *)(virtioDisk.pages + PGSIZE);

  // all NUM descriptors start out unused.
  for (int i = 0; i < NUM; i++)
    virtioDisk.free[i] = 1;

  // plic.c and trap.c arrange for interrupts from VIRTIO0_IRQ.
}

// find a free descriptor, mark it non-free, return its index.
int alloc_desc()
{
  for (int i = 0; i < NUM; i++) {
    if (virtioDisk.free[i]) {
      virtioDisk.free[i] = 0;
      return i;
    }
  }
  return -1;
}

// mark a descriptor as free.
void free_desc(int i)
{
  if (i >= NUM)
    panic("free_desc 1");
  if (virtioDisk.free[i])
    panic("free_desc 2");
  virtioDisk.desc[i].addr = 0;
  virtioDisk.desc[i].len = 0;
  virtioDisk.desc[i].flags = 0;
  virtioDisk.desc[i].next = 0;
  virtioDisk.free[i] = 1;
  wakeup(&virtioDisk.free[0]);
}

// free a chain of descriptors.
void free_chain(int i)
{
  while (1) {
    int flag = virtioDisk.desc[i].flags;
    int nxt = virtioDisk.desc[i].next;
    free_desc(i);
    if (flag & VRING_DESC_F_NEXT)
      i = nxt;
    else
      break;
  }
}

// allocate three descriptors (they need not be contiguous).
// disk transfers always use three descriptors.
int alloc3_desc(int *idx)
{
  for (int i = 0; i < 3; i++) {
    idx[i] = alloc_desc();
    if (idx[i] < 0) {
      for (int j = 0; j < i; j++)
        free_desc(idx[j]);
      return -1;
    }
  }
  return 0;
}

void VirtioRw(char *buf, uint64_t sector, int write)
{
  // uint64_t sector = b->blockno;
  virtioDisk.vdiskLock.lock();

  // the spec's Section 5.2 says that legacy block operations use
  // three descriptors: one for type/reserved/sector, one for the
  // data, one for a 1-byte status result.

  // allocate the three descriptors.
  int idx[3];
  while (1) {
    if (alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&virtioDisk.free[0], &virtioDisk.vdiskLock);
  }

  struct virtio_blk_req *req;

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.
  req = &virtioDisk.ops[idx[0]];

  if (write)
    req->type = VIRTIO_BLK_T_OUT;  // write the disk
  else
    req->type = VIRTIO_BLK_T_IN;  // read the disk
  req->reserved = 0;
  req->sector = sector;

  virtioDisk.desc[idx[0]].addr = (uint64_t)req;
  virtioDisk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
  virtioDisk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
  virtioDisk.desc[idx[0]].next = idx[1];

  virtioDisk.desc[idx[1]].addr = (uint64_t)buf;
  virtioDisk.desc[idx[1]].len = BSIZE;
  if (write)
    virtioDisk.desc[idx[1]].flags = 0;  // device reads b->data
  else
    virtioDisk.desc[idx[1]].flags =
        VRING_DESC_F_WRITE;  // device writes b->data
  virtioDisk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
  virtioDisk.desc[idx[1]].next = idx[2];

  virtioDisk.info[idx[0]].status = 0xff;  // device writes 0 on success
  virtioDisk.desc[idx[2]].addr = (uint64_t)&virtioDisk.info[idx[0]].status;
  virtioDisk.desc[idx[2]].len = 1;

  // device writes the status
  virtioDisk.desc[idx[2]].flags = VRING_DESC_F_WRITE;

  virtioDisk.desc[idx[2]].next = 0;

  // record struct buf for virtio_disk_intr().
  virtioDisk.info[idx[0]].finish = false;
  virtioDisk.info[idx[0]].data = buf;

  // tell the device the first index in our chain of descriptors.
  virtioDisk.avail->ring[virtioDisk.avail->idx % NUM] = idx[0];

  __sync_synchronize();

  // tell the device another avail ring entry is available.
  virtioDisk.avail->idx += 1;  // not % NUM ...

  __sync_synchronize();

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0;  // value is queue number

  // Wait for virtio_disk_intr() to say request has finished.
  while (virtioDisk.info[idx[0]].finish == false) {
    sleep(buf, &virtioDisk.vdiskLock);
  }

  virtioDisk.info[idx[0]].data = 0;
  free_chain(idx[0]);
  virtioDisk.vdiskLock.unlock();
}

void VirtioIntr()
{
  virtioDisk.vdiskLock.lock();

  // the device won't raise another interrupt until we tell it
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;

  __sync_synchronize();

  // the device increments virtioDisk.used->idx when it
  // adds an entry to the used ring.
  while (virtioDisk.used_idx != virtioDisk.used->idx) {
    __sync_synchronize();
    int id = virtioDisk.used->ring[virtioDisk.used_idx % NUM].id;

    if (virtioDisk.info[id].status != 0) {
      panic("virtio_disk_intr status");
    }

    virtioDisk.info[id].finish = true;  // disk is done with buf
    wakeup(virtioDisk.info[id].data);

    virtioDisk.used_idx += 1;
  }
  virtioDisk.vdiskLock.unlock();
}

void VirtioRead(char *buf, int sectorno)
{
  VirtioRw(buf, sectorno, 0);
}

void VirtioWrite(char *buf, int sectorno)
{
  VirtioRw(buf, sectorno, 1);
}