#ifndef __VIRTIO_HPP
#define __VIRTIO_HPP

#include "os/SpinLock.hpp"
#include "riscv.hpp"
#include "types.hpp"
#include "StartOS.hpp"

// virtio mmio 控制寄存器, 被映射到0x1000100
#define VIRTIO_MMIO_MAGIC_VALUE 0x000  // 0x74726976
#define VIRTIO_MMIO_VERSION 0x004      // version; 1 is legacy
#define VIRTIO_MMIO_DEVICE_ID 0x008    // device type; 1 is net, 2 is disk
#define VIRTIO_MMIO_VENDOR_ID 0x00c    // 0x554d4551
#define VIRTIO_MMIO_DEVICE_FEATURES 0x010
#define VIRTIO_MMIO_DRIVER_FEATURES 0x020
#define VIRTIO_MMIO_GUEST_PAGE_SIZE 0x028  // PFN的页面大小, write-only
#define VIRTIO_MMIO_QUEUE_SEL 0x030        // select queue, write-only
#define VIRTIO_MMIO_QUEUE_NUM_MAX 0x034  // max size of current queue, read-only
#define VIRTIO_MMIO_QUEUE_NUM 0x038      // size of current queue, write-only
#define VIRTIO_MMIO_QUEUE_ALIGN 0x03c    // used ring alignment, write-only
#define VIRTIO_MMIO_QUEUE_PFN                                                  \
  0x040  // physical page number for queue,read/write
#define VIRTIO_MMIO_QUEUE_READY 0x044       // ready bit
#define VIRTIO_MMIO_QUEUE_NOTIFY 0x050      // write-only
#define VIRTIO_MMIO_INTERRUPT_STATUS 0x060  // read-only
#define VIRTIO_MMIO_INTERRUPT_ACK 0x064     // write-only
#define VIRTIO_MMIO_STATUS 0x070            // read/write

// 状态寄存器位, 来自于qemu的virtio_config.h
#define VIRTIO_CONFIG_S_ACKNOWLEDGE 1
#define VIRTIO_CONFIG_S_DRIVER 2
#define VIRTIO_CONFIG_S_DRIVER_OK 4
#define VIRTIO_CONFIG_S_FEATURES_OK 8

// 设备feature位
#define VIRTIO_BLK_F_RO 5          /* Disk is read-only */
#define VIRTIO_BLK_F_SCSI 7        /* Supports scsi command passthru */
#define VIRTIO_BLK_F_CONFIG_WCE 11 /* Writeback mode available in config */
#define VIRTIO_BLK_F_MQ 12         /* support more than one vq */
#define VIRTIO_F_ANY_LAYOUT 27
#define VIRTIO_RING_F_INDIRECT_DESC 28
#define VIRTIO_RING_F_EVENT_IDX 29

// virtio描述符的数量，必须是2的幂
#define NUM 8

// 描述符的定义，来自于文档
struct virtq_desc
{
  uint64_t addr;
  uint32_t len;
  uint16_t flags;
  uint16_t next;
};
#define VRING_DESC_F_NEXT 1   // next是否指向下一个描述符
#define VRING_DESC_F_WRITE 2  // 设备可写，否则为可读

// available ring, 来自于文档
struct virtq_avail
{
  uint16_t flags;      // 一直为0
  uint16_t idx;        // driver will write ring[idx] next
  uint16_t ring[NUM];  // descriptor numbers of chain heads
  uint16_t unused;
};

// one entry in the "used" ring, with which the
// device tells the driver about completed requests.
// "used" ring 中的一项，告诉设备完整的request
struct virtq_used_elem
{
  uint32_t id;  // 描述符链的头
  uint32_t len;
};

struct virtq_used
{
  uint16_t               flags;  // always zero
  uint16_t               idx;  // device increments when it adds a ring[] entry
  struct virtq_used_elem ring[NUM];
};

// these are specific to virtio block devices, e.g. disks,
// described in Section 5.2 of the spec.

#define VIRTIO_BLK_T_IN 0   // read the disk
#define VIRTIO_BLK_T_OUT 1  // write the disk

// the format of the first descriptor in a disk request.
// to be followed by two more descriptors containing
// the block, and a one-byte status.
struct virtio_blk_req
{
  uint32_t type;  // VIRTIO_BLK_T_IN or ..._OUT
  uint32_t reserved;
  uint64_t sector;
};

// the address of virtio mmio register r.
#define R(r) ((volatile uint32_t *)(VIRTIO0 + (r)))
struct VirtioDisk
{
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
  char     free[NUM];  // is a descriptor free?
  uint16_t used_idx;   // we've looked this far in used[2..NUM].

  // track info about in-flight operations,
  // for use when completion interrupt arrives.
  // indexed by first descriptor index of chain.
  struct
  {
    char *data;
    bool  finish;
    char  status;
  } info[NUM];

  // disk command headers.
  // one-for-one with descriptors, for convenience.
  struct virtio_blk_req ops[NUM];

  SpinLock vdiskLock;
};

/**
 * @brief 初始化磁盘，配置一些参数，详细流程可以查看
 *        virtio文档5.2节
 *        https://docs.oasis-open.org/virtio/virtio/v1.1/virtio-v1.1.pdf
 *
 */
void VirtioInit();

/**
 * @brief 读取磁盘的相应扇区到b->data
 */
void VirtioRead(char *buf, int sectorno);

/**
 *  @brief 将b->data写入到磁盘对应扇区
 */
void VirtioWrite(char *buf, int sectorno);

/**
 * @brief virtio中断处理函数
 *
 */
void VirtioIntr();

/**
 * @brief 读写磁盘
 *
 * @param buf   读写数据缓存区
 * @param write 0代表读，1代表写
 */
void VirtioRw(char *buf, uint64_t sector, int write);

#endif