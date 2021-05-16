#ifndef VIRTIO_DISK_HPP
#define VIRTIO_DISK_HPP

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
#define VIRTIO_MMIO_GUEST_PAGE_SIZE 0x028   // PFN的页面大小, write-only
#define VIRTIO_MMIO_QUEUE_SEL 0x030         // select queue, write-only
#define VIRTIO_MMIO_QUEUE_NUM_MAX 0x034     // max size of current queue, read-only
#define VIRTIO_MMIO_QUEUE_NUM 0x038         // size of current queue, write-only
#define VIRTIO_MMIO_QUEUE_ALIGN 0x03c       // used ring alignment, write-only
#define VIRTIO_MMIO_QUEUE_PFN 0x040         // physical page number for queue, read/write
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
struct virtq_desc {
  uint64_t addr;
  uint32_t len;
  uint16_t flags;
  uint16_t next;
};
#define VRING_DESC_F_NEXT 1   // next是否指向下一个描述符
#define VRING_DESC_F_WRITE 2  // 设备可写，否则为可读

// available ring, 来自于文档
struct virtq_avail {
  uint16_t flags;      // 一直为0
  uint16_t idx;        // driver will write ring[idx] next
  uint16_t ring[NUM];  // descriptor numbers of chain heads
  uint16_t unused;
};

// one entry in the "used" ring, with which the
// device tells the driver about completed requests.
// "used" ring 中的一项，告诉设备完整的request
struct virtq_used_elem {
  uint32_t id;  // 描述符链的头
  uint32_t len;
};

struct virtq_used {
  uint16_t flags;  // always zero
  uint16_t idx;    // device increments when it adds a ring[] entry
  struct virtq_used_elem ring[NUM];
};

// these are specific to virtio block devices, e.g. disks,
// described in Section 5.2 of the spec.

#define VIRTIO_BLK_T_IN 0   // read the disk
#define VIRTIO_BLK_T_OUT 1  // write the disk

// the format of the first descriptor in a disk request.
// to be followed by two more descriptors containing
// the block, and a one-byte status.
struct virtio_blk_req {
  uint32_t type;  // VIRTIO_BLK_T_IN or ..._OUT
  uint32_t reserved;
  uint64_t sector;
};

/**
 * @brief 初始化磁盘，配置一些参数，详细流程可以查看
 *        virtio文档5.2节
 *        https://docs.oasis-open.org/virtio/virtio/v1.1/virtio-v1.1.pdf
 *
 */
void virtio_init();

/**
 * @brief 读取磁盘的b->blockno/2和b->blockno/2+1号
 * 扇区的数据，并将其存放在b->data中。
 * @note 一个block为1024字节，一个sector为512字节
 */
void virtio_read(struct buf *b);

/**
 *  @brief 将b->data写入到磁盘的b->blockno/2号
 *        和b->blockno/2+1号扇区。
 *  @note 一个block为1024字节，一个sector为512字节
 */
void virtio_write(struct buf *b);

/**
 * @brief virtio中断处理函数
 *
 */
void virtio_disk_intr();

/**
 * @brief 读写磁盘
 *
 * @param b
 * @param write 0代表读，1代表写
 */
void virtio_disk_rw(struct buf *b, int write);

#endif