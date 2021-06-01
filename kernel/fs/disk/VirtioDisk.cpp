#include "fs/disk/VirtioDisk.hpp"
#include "common/printk.hpp"
#include "common/string.hpp"
#include "fs/inodefs/BufferLayer.hpp"
#include "memlayout.hpp"
#include "os/Process.hpp"
#include "os/TaskScheduler.hpp"
#include "types.hpp"
#include "StartOS.hpp"

// using namespace virtio;
// the address of virtio mmio register r.
#define R(r) ((volatile uint32_t *)(VIRTIO0 + (r)))
struct alignas(4096) VirtioDisk {
 public:
  // the virtio driver and device mostly communicate through a set of
  // structures in RAM. pages[] allocates that memory. pages[] is a
  // global (instead of calls to kalloc()) because it must consist of
  // two contiguous pages of page-aligned physical memory.
  char pages[2 * PGSIZE];

  // pages[] is divided into three regions (descriptors, avail, and
  // used), as explained in Section 2.6 of the virtio specification
  // for the legacy interface.
  // https://docs.oasis-open.org/virtio/virtio/v1.1/virtio-v1.1.pdf

  // the first region of pages[] is a set (not a ring) of DMA
  // descriptors, with which the driver tells the device where to read
  // and write individual disk operations. there are NUM descriptors.
  // most commands consist of a "chain" (a linked list) of a couple of
  // these descriptors.
  // points into pages[].
  struct virtq_desc *desc;

  // next is a ring in which the driver writes descriptor numbers
  // that the driver would like the device to process.  it only
  // includes the head descriptor of each chain. the ring has
  // NUM elements.
  // points into pages[].
  struct virtq_avail *avail;

  // finally a ring in which the device writes descriptor numbers that
  // the device has finished processing (just the head of each chain).
  // there are NUM used ring entries.
  // points into pages[].
  struct virtq_used *used;

  // our own book-keeping.
  char free[NUM];     // is a descriptor free?
  uint16_t used_idx;  // we've looked this far in used[2..NUM].

  // track info about in-flight operations,
  // for use when completion interrupt arrives.
  // indexed by first descriptor index of chain.
  struct {
    struct buf *b;
    char status;
  } info[NUM];

  // disk command headers.
  // one-for-one with descriptors, for convenience.
  struct virtio_blk_req ops[NUM];

  SpinLock vdiskLock;
} virtioDisk;

/**
 * @brief 在读写磁盘需要用到的工具函数，主要是用来管理
 *        descriptor。
 *
 * @return int
 */
int alloc_desc();
void free_desc(int i);
void free_chain(int i);
int alloc3_desc(int *idx);

void virtio_init() {
  uint32_t status = 0;

  virtioDisk.vdiskLock.init("virtio_disk");

  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 || *R(VIRTIO_MMIO_VERSION) != 1 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
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
  if (max == 0) panic("virtio disk has no queue 0");
  if (max < NUM) panic("virtio disk max queue too short");
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
  memset(virtioDisk.pages, 0, sizeof(virtioDisk.pages));
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64_t)virtioDisk.pages) >> PGSHIFT;

  // desc = pages -- num * virtq_desc
  // avail = pages + 0x40 -- 2 * uint16_t, then num * uint16_t
  // used = pages + 4096 -- 2 * uint16_t, then num * vRingUsedElem

  virtioDisk.desc = (struct virtq_desc *)virtioDisk.pages;
  virtioDisk.avail = (struct virtq_avail *)(virtioDisk.pages + NUM * sizeof(struct virtq_desc));
  virtioDisk.used = (struct virtq_used *)(virtioDisk.pages + PGSIZE);

  // all NUM descriptors start out unused.
  for (int i = 0; i < NUM; i++) virtioDisk.free[i] = 1;

  // plic.c and trap.c arrange for interrupts from VIRTIO0_IRQ.
}

// find a free descriptor, mark it non-free, return its index.
int alloc_desc() {
  for (int i = 0; i < NUM; i++) {
    if (virtioDisk.free[i]) {
      virtioDisk.free[i] = 0;
      return i;
    }
  }
  return -1;
}

// mark a descriptor as free.
void free_desc(int i) {
  if (i >= NUM) panic("free_desc 1");
  if (virtioDisk.free[i]) panic("free_desc 2");
  virtioDisk.desc[i].addr = 0;
  virtioDisk.desc[i].len = 0;
  virtioDisk.desc[i].flags = 0;
  virtioDisk.desc[i].next = 0;
  virtioDisk.free[i] = 1;
  wakeup(&virtioDisk.free[0]);
}

// free a chain of descriptors.
void free_chain(int i) {
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
int alloc3_desc(int *idx) {
  for (int i = 0; i < 3; i++) {
    idx[i] = alloc_desc();
    if (idx[i] < 0) {
      for (int j = 0; j < i; j++) free_desc(idx[j]);
      return -1;
    }
  }
  return 0;
}

struct virtio_blk_req *buf0;
void virtio_disk_rw(struct buf *b, int write) {
  uint64_t sector = b->blockno;
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

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.
  buf0 = &virtioDisk.ops[idx[0]];

  if (write)
    buf0->type = VIRTIO_BLK_T_OUT;  // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN;  // read the disk
  buf0->reserved = 0;
  buf0->sector = sector;

  virtioDisk.desc[idx[0]].addr = (uint64_t)buf0;
  virtioDisk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
  virtioDisk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
  virtioDisk.desc[idx[0]].next = idx[1];

  virtioDisk.desc[idx[1]].addr = (uint64_t)b->data;
  virtioDisk.desc[idx[1]].len = BSIZE;
  if (write)
    virtioDisk.desc[idx[1]].flags = 0;  // device reads b->data
  else
    virtioDisk.desc[idx[1]].flags = VRING_DESC_F_WRITE;  // device writes b->data
  virtioDisk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
  virtioDisk.desc[idx[1]].next = idx[2];

  virtioDisk.info[idx[0]].status = 0xff;  // device writes 0 on success
  virtioDisk.desc[idx[2]].addr = (uint64_t) & virtioDisk.info[idx[0]].status;
  virtioDisk.desc[idx[2]].len = 1;
  virtioDisk.desc[idx[2]].flags = VRING_DESC_F_WRITE;  // device writes the status
  virtioDisk.desc[idx[2]].next = 0;

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
  virtioDisk.info[idx[0]].b = b;

  // tell the device the first index in our chain of descriptors.
  virtioDisk.avail->ring[virtioDisk.avail->idx % NUM] = idx[0];

  __sync_synchronize();

  // tell the device another avail ring entry is available.
  virtioDisk.avail->idx += 1;  // not % NUM ...

  __sync_synchronize();

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0;  // value is queue number

  // Wait for virtio_disk_intr() to say request has finished.
  while (b->disk == 1) {
    sleep(b, &virtioDisk.vdiskLock);
  }

  virtioDisk.info[idx[0]].b = 0;
  free_chain(idx[0]);
  virtioDisk.vdiskLock.unlock();
}

void virtio_disk_intr() {
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
      // printf("%d",di)
      printf("intr:%d %d\n", buf0->sector, buf0->type);
      panic("virtio_disk_intr status");
    }

    struct buf *b = virtioDisk.info[id].b;
    b->disk = 0;  // disk is done with buf
    wakeup(b);

    virtioDisk.used_idx += 1;
  }
  virtioDisk.vdiskLock.unlock();
}

void virtio_read(struct buf *b) { virtio_disk_rw(b, 0); }
void virtio_write(struct buf *b) { virtio_disk_rw(b, 1); }