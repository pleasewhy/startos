#include "os/TaskScheduler.hpp"
#include "common/logger.h"
#include "common/printk.hpp"
#include "common/string.hpp"
#include "device/Console.hpp"
#include "fcntl.h"
#include "file.h"
#include "fs/disk/Disk.hpp"
#include "fs/fat/Fat32.hpp"
#include "fs/inodefs/BufferLayer.hpp"
#include "fs/vfs/Vfs.hpp"
#include "memlayout.hpp"
#include "memory/MemAllocator.hpp"
#include "memory/VmManager.hpp"
#include "os/Cpu.hpp"
#include "os/Intr.hpp"
#include "os/Process.hpp"
#include "os/Timer.hpp"
#include "os/trap.hpp"
#include "param.hpp"
#include "time.h"

#define NVMA 15

extern MemAllocator memAllocator;
extern Console console;
extern BufferLayer bufferLayer;
extern Fat32FileSystem fatFs;

extern char trampoline[], uservec[], userret[];

extern char trampoline[];  // trampoline.S

Task *initTask;
struct vma vma[NVMA];
Task taskTable[NTASK];

#define KSTACK_SIZE (PGSIZE * 2)
alignas(4096) char stack[KSTACK_SIZE * 2 * (NTASK + 1)];

// 初始化任务表
void initTaskTable() {
  Task *task;
  for (int i = 0; i < NTASK; i++) {
    task = &taskTable[i];
    task->lock.init("task");
    task->pid = i;
    // task->kstack = (uint64_t) kalloc();
    task->kstack = (uint64_t)(stack + KSTACK_SIZE * i);
    task->trapframe = 0;
    task->state = UNUSED;
    task->killed = 0;
    task->xstate = 0;
    task->sz = 0;
    task->sticks = 0;
    memset(task->vma, 0, sizeof(struct vma *) * NOMMAPFILE);
    task->uticks = 0;
    memset(task->currentDir, 0, MAXPATH);
    memset(task->openFiles, 0, sizeof(struct file *) * NOFILE);
  }
  memset(vma, 0, sizeof(struct vma) * NVMA);
}

// // 该程序执行exec("/init"), 然后退出
// // 通过 od -t xC initcode 生成

// uchar_t initcode[] = {0x17, 0x05, 0x00, 0x00, 0x13, 0x05, 0x45, 0x02, 0x97, 0x05, 0x00, 0x00, 0x93,
//                       0x85, 0x35, 0x02, 0x93, 0x08, 0xd0, 0x0d, 0x73, 0x00, 0x00, 0x00, 0x93, 0x08,
//                       0xd0, 0x05, 0x73, 0x00, 0x00, 0x00, 0xef, 0xf0, 0x9f, 0xff, 0x2f, 0x69, 0x6e,
//                       0x69, 0x74, 0x00, 0x00, 0x24, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
alignas(PGSIZE) uchar_t initcode[] = {
    0x01,0x11,0x06,0xec,0x22,0xe8,0x26,0xe4,0x4a,0xe0,0x00,0x10,0xaa,0x84,0x2e,0x89,
0x97,0x00,0x00,0x00,0xe7,0x80,0x00,0x2a,0x11,0xed,0x01,0x46,0xca,0x85,0x26,0x85,
0x97,0x00,0x00,0x00,0xe7,0x80,0x60,0x3a,0xe2,0x60,0x42,0x64,0xa2,0x64,0x02,0x69,
0x05,0x61,0x82,0x80,0x01,0x45,0x97,0x00,0x00,0x00,0xe7,0x80,0x20,0x28,0xed,0xb7,
0x41,0x11,0x06,0xe4,0x22,0xe0,0x00,0x08,0x89,0x45,0x17,0x15,0x00,0x00,0x13,0x05,
0x65,0x8d,0x97,0x00,0x00,0x00,0xe7,0x80,0xe0,0x26,0x01,0x45,0x97,0x00,0x00,0x00,
0xe7,0x80,0x40,0x27,0x01,0x45,0x97,0x00,0x00,0x00,0xe7,0x80,0xa0,0x26,0x81,0x45,
0x17,0x15,0x00,0x00,0x13,0x05,0x85,0x8b,0x97,0x00,0x00,0x00,0xe7,0x80,0x80,0xf8,
0x81,0x45,0x17,0x15,0x00,0x00,0x13,0x05,0xe5,0x8a,0x97,0x00,0x00,0x00,0xe7,0x80,
0x60,0xf7,0x81,0x45,0x17,0x15,0x00,0x00,0x13,0x05,0xc5,0x8a,0x97,0x00,0x00,0x00,
0xe7,0x80,0x40,0xf6,0x81,0x45,0x17,0x15,0x00,0x00,0x13,0x05,0x25,0x8a,0x97,0x00,
0x00,0x00,0xe7,0x80,0x20,0xf5,0x81,0x45,0x17,0x15,0x00,0x00,0x13,0x05,0x85,0x89,
0x97,0x00,0x00,0x00,0xe7,0x80,0x00,0xf4,0x81,0x45,0x17,0x15,0x00,0x00,0x13,0x05,
0xe5,0x88,0x97,0x00,0x00,0x00,0xe7,0x80,0xe0,0xf2,0x81,0x45,0x17,0x15,0x00,0x00,
0x13,0x05,0x45,0x88,0x97,0x00,0x00,0x00,0xe7,0x80,0xc0,0xf1,0x81,0x45,0x17,0x15,
0x00,0x00,0x13,0x05,0xa5,0x87,0x97,0x00,0x00,0x00,0xe7,0x80,0xa0,0xf0,0x81,0x45,
0x17,0x15,0x00,0x00,0x13,0x05,0x05,0x87,0x97,0x00,0x00,0x00,0xe7,0x80,0x80,0xef,
0x81,0x45,0x17,0x15,0x00,0x00,0x13,0x05,0x65,0x86,0x97,0x00,0x00,0x00,0xe7,0x80,
0x60,0xee,0x81,0x45,0x17,0x15,0x00,0x00,0x13,0x05,0xc5,0x85,0x97,0x00,0x00,0x00,
0xe7,0x80,0x40,0xed,0x81,0x45,0x17,0x15,0x00,0x00,0x13,0x05,0x25,0x85,0x97,0x00,
0x00,0x00,0xe7,0x80,0x20,0xec,0x81,0x45,0x17,0x15,0x00,0x00,0x13,0x05,0x05,0x85,
0x97,0x00,0x00,0x00,0xe7,0x80,0x00,0xeb,0x81,0x45,0x17,0x15,0x00,0x00,0x13,0x05,
0x65,0x84,0x97,0x00,0x00,0x00,0xe7,0x80,0xe0,0xe9,0x81,0x45,0x17,0x15,0x00,0x00,
0x13,0x05,0xc5,0x83,0x97,0x00,0x00,0x00,0xe7,0x80,0xc0,0xe8,0x81,0x45,0x17,0x15,
0x00,0x00,0x13,0x05,0x25,0x83,0x97,0x00,0x00,0x00,0xe7,0x80,0xa0,0xe7,0x81,0x45,
0x17,0x15,0x00,0x00,0x13,0x05,0x85,0x82,0x97,0x00,0x00,0x00,0xe7,0x80,0x80,0xe6,
0x81,0x45,0x17,0x15,0x00,0x00,0x13,0x05,0xe5,0x81,0x97,0x00,0x00,0x00,0xe7,0x80,
0x60,0xe5,0x81,0x45,0x17,0x15,0x00,0x00,0x13,0x05,0x45,0x81,0x97,0x00,0x00,0x00,
0xe7,0x80,0x40,0xe4,0x81,0x45,0x17,0x15,0x00,0x00,0x13,0x05,0xa5,0x80,0x97,0x00,
0x00,0x00,0xe7,0x80,0x20,0xe3,0x81,0x45,0x17,0x15,0x00,0x00,0x13,0x05,0x05,0x80,
0x97,0x00,0x00,0x00,0xe7,0x80,0x00,0xe2,0x81,0x45,0x17,0x05,0x00,0x00,0x13,0x05,
0x65,0x7f,0x97,0x00,0x00,0x00,0xe7,0x80,0xe0,0xe0,0x81,0x45,0x17,0x05,0x00,0x00,
0x13,0x05,0x45,0x7f,0x97,0x00,0x00,0x00,0xe7,0x80,0xc0,0xdf,0x81,0x45,0x17,0x05,
0x00,0x00,0x13,0x05,0xa5,0x7e,0x97,0x00,0x00,0x00,0xe7,0x80,0xa0,0xde,0x81,0x45,
0x17,0x05,0x00,0x00,0x13,0x05,0x05,0x7e,0x97,0x00,0x00,0x00,0xe7,0x80,0x80,0xdd,
0x81,0x45,0x17,0x05,0x00,0x00,0x13,0x05,0x65,0x7d,0x97,0x00,0x00,0x00,0xe7,0x80,
0x60,0xdc,0x81,0x45,0x17,0x05,0x00,0x00,0x13,0x05,0x45,0x7d,0x97,0x00,0x00,0x00,
0xe7,0x80,0x40,0xdb,0x81,0x45,0x17,0x05,0x00,0x00,0x13,0x05,0xa5,0x7c,0x97,0x00,
0x00,0x00,0xe7,0x80,0x20,0xda,0x81,0x45,0x17,0x05,0x00,0x00,0x13,0x05,0x05,0x7c,
0x97,0x00,0x00,0x00,0xe7,0x80,0x00,0xd9,0x81,0x45,0x17,0x05,0x00,0x00,0x13,0x05,
0x65,0x7b,0x97,0x00,0x00,0x00,0xe7,0x80,0xe0,0xd7,0x81,0x45,0x17,0x05,0x00,0x00,
0x13,0x05,0xc5,0x7a,0x97,0x00,0x00,0x00,0xe7,0x80,0xc0,0xd6,0x81,0x45,0x17,0x05,
0x00,0x00,0x13,0x05,0x25,0x7a,0x97,0x00,0x00,0x00,0xe7,0x80,0xa0,0xd5,0x01,0xa0,
0x85,0x48,0x73,0x00,0x00,0x00,0x82,0x80,0x8d,0x48,0x73,0x00,0x00,0x00,0x82,0x80,
0x89,0x48,0x73,0x00,0x00,0x00,0x82,0x80,0xc5,0x48,0x73,0x00,0x00,0x00,0x82,0x80,
0xdd,0x48,0x73,0x00,0x00,0x00,0x82,0x80,0xe1,0x48,0x73,0x00,0x00,0x00,0x82,0x80,
0x93,0x08,0x20,0x02,0x73,0x00,0x00,0x00,0x82,0x80,0x93,0x08,0x30,0x02,0x73,0x00,
0x00,0x00,0x82,0x80,0x93,0x08,0x50,0x02,0x73,0x00,0x00,0x00,0x82,0x80,0x93,0x08,
0x70,0x02,0x73,0x00,0x00,0x00,0x82,0x80,0x93,0x08,0x80,0x02,0x73,0x00,0x00,0x00,
0x82,0x80,0x93,0x08,0x10,0x03,0x73,0x00,0x00,0x00,0x82,0x80,0x93,0x08,0x90,0x03,
0x73,0x00,0x00,0x00,0x82,0x80,0x93,0x08,0xb0,0x03,0x73,0x00,0x00,0x00,0x82,0x80,
0x93,0x08,0xd0,0x03,0x73,0x00,0x00,0x00,0x82,0x80,0x93,0x08,0xf0,0x03,0x73,0x00,
0x00,0x00,0x82,0x80,0x93,0x08,0x00,0x04,0x73,0x00,0x00,0x00,0x82,0x80,0x93,0x08,
0x00,0x05,0x73,0x00,0x00,0x00,0x82,0x80,0x93,0x08,0xd0,0x05,0x73,0x00,0x00,0x00,
0x82,0x80,0x93,0x08,0x50,0x06,0x73,0x00,0x00,0x00,0x82,0x80,0x93,0x08,0xc0,0x07,
0x73,0x00,0x00,0x00,0x82,0x80,0x93,0x08,0x90,0x09,0x73,0x00,0x00,0x00,0x82,0x80,
0x93,0x08,0x00,0x0a,0x73,0x00,0x00,0x00,0x82,0x80,0x93,0x08,0x90,0x0a,0x73,0x00,
0x00,0x00,0x82,0x80,0x93,0x08,0x60,0x0d,0x73,0x00,0x00,0x00,0x82,0x80,0x93,0x08,
0x70,0x0d,0x73,0x00,0x00,0x00,0x82,0x80,0x93,0x08,0xc0,0x0a,0x73,0x00,0x00,0x00,
0x82,0x80,0x93,0x08,0xd0,0x0a,0x73,0x00,0x00,0x00,0x82,0x80,0x93,0x08,0xc0,0x0d,
0x73,0x00,0x00,0x00,0x82,0x80,0x93,0x08,0xd0,0x0d,0x73,0x00,0x00,0x00,0x82,0x80,
0x93,0x08,0xe0,0x0d,0x73,0x00,0x00,0x00,0x82,0x80,0x93,0x08,0x40,0x10,0x73,0x00,
0x00,0x00,0x82,0x80,0x41,0x11,0x22,0xe4,0x00,0x08,0xaa,0x87,0x85,0x05,0x85,0x07,
0x03,0xc7,0xf5,0xff,0xa3,0x8f,0xe7,0xfe,0x75,0xfb,0x22,0x64,0x41,0x01,0x82,0x80,
0x41,0x11,0x22,0xe4,0x00,0x08,0x83,0x47,0x05,0x00,0x91,0xcb,0x03,0xc7,0x05,0x00,
0x63,0x17,0xf7,0x00,0x05,0x05,0x85,0x05,0x83,0x47,0x05,0x00,0xe5,0xfb,0x03,0xc5,
0x05,0x00,0x3b,0x85,0xa7,0x40,0x22,0x64,0x41,0x01,0x82,0x80,0x41,0x11,0x22,0xe4,
0x00,0x08,0x83,0x47,0x05,0x00,0x91,0xcf,0x05,0x05,0xaa,0x87,0x85,0x46,0x89,0x9e,
0x3b,0x85,0xf6,0x00,0x85,0x07,0x03,0xc7,0xf7,0xff,0x7d,0xfb,0x22,0x64,0x41,0x01,
0x82,0x80,0x01,0x45,0xe5,0xbf,0x41,0x11,0x22,0xe4,0x00,0x08,0x09,0xce,0xaa,0x87,
0x1b,0x07,0xf6,0xff,0x02,0x17,0x01,0x93,0x05,0x07,0x2a,0x97,0x23,0x80,0xb7,0x00,
0x85,0x07,0xe3,0x9d,0xe7,0xfe,0x22,0x64,0x41,0x01,0x82,0x80,0x41,0x11,0x22,0xe4,
0x00,0x08,0x83,0x47,0x05,0x00,0x99,0xcb,0x63,0x87,0xf5,0x00,0x05,0x05,0x83,0x47,
0x05,0x00,0xfd,0xfb,0x01,0x45,0x22,0x64,0x41,0x01,0x82,0x80,0x01,0x45,0xe5,0xbf,
0x1d,0x71,0x86,0xec,0xa2,0xe8,0xa6,0xe4,0xca,0xe0,0x4e,0xfc,0x52,0xf8,0x56,0xf4,
0x5a,0xf0,0x5e,0xec,0x80,0x10,0xaa,0x8b,0x2e,0x8a,0x2a,0x89,0x81,0x44,0xa9,0x4a,
0x35,0x4b,0xa6,0x89,0x85,0x24,0x63,0xd8,0x44,0x03,0x05,0x46,0x93,0x05,0xf4,0xfa,
0x01,0x45,0x97,0x00,0x00,0x00,0xe7,0x80,0x80,0xe6,0x63,0x5e,0xa0,0x00,0x83,0x47,
0xf4,0xfa,0x23,0x00,0xf9,0x00,0x63,0x87,0x57,0x01,0x05,0x09,0xe3,0x9b,0x67,0xfd,
0xa6,0x89,0x11,0xa0,0xa6,0x89,0xde,0x99,0x23,0x80,0x09,0x00,0x5e,0x85,0xe6,0x60,
0x46,0x64,0xa6,0x64,0x06,0x69,0xe2,0x79,0x42,0x7a,0xa2,0x7a,0x02,0x7b,0xe2,0x6b,
0x25,0x61,0x82,0x80,0x41,0x11,0x22,0xe4,0x00,0x08,0x03,0x46,0x05,0x00,0x9b,0x07,
0x06,0xfd,0x93,0xf7,0xf7,0x0f,0x25,0x47,0x63,0x69,0xf7,0x02,0xaa,0x86,0x01,0x45,
0xa5,0x45,0x85,0x06,0x9b,0x17,0x25,0x00,0xa9,0x9f,0x9b,0x97,0x17,0x00,0xb1,0x9f,
0x1b,0x85,0x07,0xfd,0x03,0xc6,0x06,0x00,0x1b,0x07,0x06,0xfd,0x13,0x77,0xf7,0x0f,
0xe3,0xf1,0xe5,0xfe,0x22,0x64,0x41,0x01,0x82,0x80,0x01,0x45,0xe5,0xbf,0x41,0x11,
0x22,0xe4,0x00,0x08,0x63,0x76,0xb5,0x02,0x63,0x51,0xc0,0x02,0x9b,0x07,0xf6,0xff,
0x82,0x17,0x81,0x93,0x85,0x07,0xaa,0x97,0x2a,0x87,0x85,0x05,0x05,0x07,0x83,0xc6,
0xf5,0xff,0xa3,0x0f,0xd7,0xfe,0xe3,0x9a,0xe7,0xfe,0x22,0x64,0x41,0x01,0x82,0x80,
0x33,0x07,0xc5,0x00,0xb2,0x95,0xe3,0x5a,0xc0,0xfe,0x9b,0x07,0xf6,0xff,0x82,0x17,
0x81,0x93,0x93,0xc7,0xf7,0xff,0xba,0x97,0xfd,0x15,0x7d,0x17,0x83,0xc6,0x05,0x00,
0x23,0x00,0xd7,0x00,0xe3,0x9a,0xe7,0xfe,0xc9,0xbf,0x41,0x11,0x22,0xe4,0x00,0x08,
0x05,0xca,0x9b,0x06,0xf6,0xff,0x82,0x16,0x81,0x92,0x85,0x06,0xaa,0x96,0x83,0x47,
0x05,0x00,0x03,0xc7,0x05,0x00,0x63,0x98,0xe7,0x00,0x05,0x05,0x85,0x05,0xe3,0x18,
0xd5,0xfe,0x01,0x45,0x19,0xa0,0x3b,0x85,0xe7,0x40,0x22,0x64,0x41,0x01,0x82,0x80,
0x01,0x45,0xe5,0xbf,0x41,0x11,0x06,0xe4,0x22,0xe0,0x00,0x08,0x97,0x00,0x00,0x00,
0xe7,0x80,0x20,0xf6,0xa2,0x60,0x02,0x64,0x41,0x01,0x82,0x80,0x01,0x11,0x06,0xec,
0x22,0xe8,0x00,0x10,0xa3,0x07,0xb4,0xfe,0x05,0x46,0x93,0x05,0xf4,0xfe,0x97,0x00,
0x00,0x00,0xe7,0x80,0x60,0xd2,0xe2,0x60,0x42,0x64,0x05,0x61,0x82,0x80,0x39,0x71,
0x06,0xfc,0x22,0xf8,0x26,0xf4,0x4a,0xf0,0x4e,0xec,0x80,0x00,0xaa,0x84,0x99,0xc2,
0x63,0xc8,0x05,0x08,0x81,0x25,0x81,0x48,0x93,0x06,0x04,0xfc,0x01,0x47,0x01,0x26,
0x17,0x05,0x00,0x00,0x13,0x05,0x05,0x40,0x3a,0x88,0x05,0x27,0xbb,0xf7,0xc5,0x02,
0x82,0x17,0x81,0x93,0xaa,0x97,0x83,0xc7,0x07,0x00,0x23,0x80,0xf6,0x00,0x9b,0x87,
0x05,0x00,0xbb,0xd5,0xc5,0x02,0x85,0x06,0xe3,0xf0,0xc7,0xfe,0x63,0x8b,0x08,0x00,
0x93,0x07,0x04,0xfd,0x3e,0x97,0x93,0x07,0xd0,0x02,0x23,0x08,0xf7,0xfe,0x1b,0x07,
0x28,0x00,0x63,0x58,0xe0,0x02,0x93,0x07,0x04,0xfc,0x33,0x89,0xe7,0x00,0x93,0x89,
0xf7,0xff,0xba,0x99,0x7d,0x37,0x02,0x17,0x01,0x93,0xb3,0x89,0xe9,0x40,0x83,0x45,
0xf9,0xff,0x26,0x85,0x97,0x00,0x00,0x00,0xe7,0x80,0x80,0xf5,0x7d,0x19,0xe3,0x18,
0x39,0xff,0xe2,0x70,0x42,0x74,0xa2,0x74,0x02,0x79,0xe2,0x69,0x21,0x61,0x82,0x80,
0xbb,0x05,0xb0,0x40,0x85,0x48,0x8d,0xbf,0x19,0x71,0x86,0xfc,0xa2,0xf8,0xa6,0xf4,
0xca,0xf0,0xce,0xec,0xd2,0xe8,0xd6,0xe4,0xda,0xe0,0x5e,0xfc,0x62,0xf8,0x66,0xf4,
0x6a,0xf0,0x6e,0xec,0x00,0x01,0x03,0xc9,0x05,0x00,0x63,0x0f,0x09,0x18,0xaa,0x8a,
0x32,0x8b,0x93,0x84,0x15,0x00,0x81,0x49,0x13,0x0a,0x50,0x02,0x13,0x0c,0x40,0x06,
0x93,0x0c,0xc0,0x06,0x13,0x0d,0x80,0x07,0x93,0x0d,0x00,0x07,0x97,0x0b,0x00,0x00,
0x93,0x8b,0x4b,0x33,0x39,0xa8,0xca,0x85,0x56,0x85,0x97,0x00,0x00,0x00,0xe7,0x80,
0x20,0xee,0x19,0xa0,0x63,0x8f,0x49,0x01,0x85,0x04,0x03,0xc9,0xf4,0xff,0x63,0x0d,
0x09,0x14,0x9b,0x07,0x09,0x00,0xe3,0x97,0x09,0xfe,0xe3,0x9e,0x47,0xfd,0xbe,0x89,
0xe5,0xb7,0x63,0x80,0x87,0x05,0x63,0x8c,0x97,0x05,0x63,0x88,0xa7,0x07,0x63,0x84,
0xb7,0x09,0x13,0x07,0x30,0x07,0x63,0x86,0xe7,0x0c,0x13,0x07,0x30,0x06,0x63,0x8e,
0xe7,0x0e,0x63,0x88,0x47,0x11,0xd2,0x85,0x56,0x85,0x97,0x00,0x00,0x00,0xe7,0x80,
0x20,0xe9,0xca,0x85,0x56,0x85,0x97,0x00,0x00,0x00,0xe7,0x80,0x60,0xe8,0x81,0x49,
0x65,0xb7,0x13,0x09,0x8b,0x00,0x85,0x46,0x29,0x46,0x83,0x25,0x0b,0x00,0x56,0x85,
0x97,0x00,0x00,0x00,0xe7,0x80,0xe0,0xe8,0x4a,0x8b,0x81,0x49,0x71,0xb7,0x13,0x09,
0x8b,0x00,0x81,0x46,0x29,0x46,0x83,0x25,0x0b,0x00,0x56,0x85,0x97,0x00,0x00,0x00,
0xe7,0x80,0x20,0xe7,0x4a,0x8b,0x81,0x49,0x85,0xbf,0x13,0x09,0x8b,0x00,0x81,0x46,
0x41,0x46,0x83,0x25,0x0b,0x00,0x56,0x85,0x97,0x00,0x00,0x00,0xe7,0x80,0x60,0xe5,
0x4a,0x8b,0x81,0x49,0x91,0xbf,0x93,0x07,0x8b,0x00,0x23,0x34,0xf4,0xf8,0x83,0x39,
0x0b,0x00,0x93,0x05,0x00,0x03,0x56,0x85,0x97,0x00,0x00,0x00,0xe7,0x80,0x40,0xe1,
0xea,0x85,0x56,0x85,0x97,0x00,0x00,0x00,0xe7,0x80,0x80,0xe0,0x41,0x49,0x93,0xd7,
0xc9,0x03,0xde,0x97,0x83,0xc5,0x07,0x00,0x56,0x85,0x97,0x00,0x00,0x00,0xe7,0x80,
0x20,0xdf,0x92,0x09,0x7d,0x39,0xe3,0x14,0x09,0xfe,0x03,0x3b,0x84,0xf8,0x81,0x49,
0x21,0xb7,0x93,0x09,0x8b,0x00,0x03,0x39,0x0b,0x00,0x63,0x01,0x09,0x02,0x83,0x45,
0x09,0x00,0xa1,0xc9,0x56,0x85,0x97,0x00,0x00,0x00,0xe7,0x80,0x60,0xdc,0x05,0x09,
0x83,0x45,0x09,0x00,0xe5,0xf9,0x4e,0x8b,0x81,0x49,0xf9,0xbd,0x17,0x09,0x00,0x00,
0x13,0x09,0xc9,0x1e,0x93,0x05,0x80,0x02,0xf1,0xbf,0x13,0x09,0x8b,0x00,0x83,0x45,
0x0b,0x00,0x56,0x85,0x97,0x00,0x00,0x00,0xe7,0x80,0x80,0xd9,0x4a,0x8b,0x81,0x49,
0x65,0xbd,0xd2,0x85,0x56,0x85,0x97,0x00,0x00,0x00,0xe7,0x80,0x60,0xd8,0x81,0x49,
0x65,0xb5,0x4e,0x8b,0x81,0x49,0x4d,0xb5,0xe6,0x70,0x46,0x74,0xa6,0x74,0x06,0x79,
0xe6,0x69,0x46,0x6a,0xa6,0x6a,0x06,0x6b,0xe2,0x7b,0x42,0x7c,0xa2,0x7c,0x02,0x7d,
0xe2,0x6d,0x09,0x61,0x82,0x80,0x5d,0x71,0x06,0xec,0x22,0xe8,0x00,0x10,0x10,0xe0,
0x14,0xe4,0x18,0xe8,0x1c,0xec,0x23,0x30,0x04,0x03,0x23,0x34,0x14,0x03,0x23,0x34,
0x84,0xfe,0x22,0x86,0x97,0x00,0x00,0x00,0xe7,0x80,0x40,0xe0,0xe2,0x60,0x42,0x64,
0x61,0x61,0x82,0x80,0x1d,0x71,0x06,0xec,0x22,0xe8,0x00,0x10,0x0c,0xe4,0x10,0xe8,
0x14,0xec,0x18,0xf0,0x1c,0xf4,0x23,0x38,0x04,0x03,0x23,0x3c,0x14,0x03,0x13,0x06,
0x84,0x00,0x23,0x34,0xc4,0xfe,0xaa,0x85,0x05,0x45,0x97,0x00,0x00,0x00,0xe7,0x80,
0xe0,0xdc,0xe2,0x60,0x42,0x64,0x25,0x61,0x82,0x80,0x00,0x00,0x00,0x00,0x00,0x00,
0x64,0x65,0x76,0x2f,0x74,0x74,0x79,0x00,0x2f,0x67,0x65,0x74,0x70,0x69,0x64,0x00,
0x2f,0x67,0x65,0x74,0x70,0x70,0x69,0x64,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x2f,0x67,0x65,0x74,0x63,0x77,0x64,0x00,0x2f,0x66,0x6f,0x72,0x6b,0x00,0x00,0x00,
0x2f,0x65,0x78,0x69,0x74,0x00,0x00,0x00,0x2f,0x6d,0x6b,0x64,0x69,0x72,0x5f,0x00,
0x2f,0x64,0x75,0x70,0x00,0x00,0x00,0x00,0x2f,0x77,0x72,0x69,0x74,0x65,0x00,0x00,
0x2f,0x72,0x65,0x61,0x64,0x00,0x00,0x00,0x2f,0x6f,0x70,0x65,0x6e,0x00,0x00,0x00,
0x2f,0x77,0x61,0x69,0x74,0x00,0x00,0x00,0x2f,0x77,0x61,0x69,0x74,0x70,0x69,0x64,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x2f,0x79,0x69,0x65,0x6c,0x64,0x00,0x00,
0x2f,0x6f,0x70,0x65,0x6e,0x61,0x74,0x00,0x2f,0x63,0x6c,0x6f,0x73,0x65,0x00,0x00,
0x2f,0x63,0x68,0x64,0x69,0x72,0x00,0x00,0x2f,0x65,0x78,0x65,0x63,0x76,0x65,0x00,
0x2f,0x64,0x75,0x70,0x32,0x00,0x00,0x00,0x2f,0x62,0x72,0x6b,0x00,0x00,0x00,0x00,
0x2f,0x75,0x6e,0x61,0x6d,0x65,0x00,0x00,0x2f,0x70,0x69,0x70,0x65,0x00,0x00,0x00,
0x2f,0x67,0x65,0x74,0x64,0x65,0x6e,0x74,0x73,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x2f,0x6d,0x6f,0x75,0x6e,0x74,0x00,0x00,0x2f,0x75,0x6d,0x6f,0x75,0x6e,0x74,0x00,
0x2f,0x74,0x69,0x6d,0x65,0x73,0x00,0x00,0x2f,0x67,0x65,0x74,0x74,0x69,0x6d,0x65,
0x6f,0x66,0x64,0x61,0x79,0x00,0x00,0x00,0x2f,0x6d,0x6d,0x61,0x70,0x00,0x00,0x00,
0x2f,0x6d,0x75,0x6e,0x6d,0x61,0x70,0x00,0x2f,0x66,0x73,0x74,0x61,0x74,0x00,0x00,
0x2f,0x75,0x6e,0x6c,0x69,0x6e,0x6b,0x00,0x2f,0x63,0x6c,0x6f,0x6e,0x65,0x00,0x00,
0x2f,0x73,0x6c,0x65,0x65,0x70,0x00,0x00,0x28,0x6e,0x75,0x6c,0x6c,0x29,0x00,0x00,
0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x41,0x42,0x43,0x44,0x45,0x46,
0x00,
};
// 初始化第一个进程
void initFirstTask() {
  Task *task = allocTask();
  // 为进程分配一页内存，并将初始化的指令和数据写入
  UserVmInit(task->pagetable, initcode, sizeof(initcode));
  // mappages(task->pagetable, PGSIZE, PGSIZE, )
  task->sz = PGSIZE;
  // 内核空间第一次进入用户空间
  task->trapframe->epc = 0x40;
  task->trapframe->sp = PGSIZE;

  memmove(task->name, "initcode", sizeof(task->name));
  // task->current_dir = namei("/");
  task->currentDir[0] = '/';

  // for (int i = 0; i < NOFILE; i++) task->openFiles[i] = 0;
  task->state = RUNNABLE;
  initTask = task;
}

// fork的子进程的会从此处开始执行
void forkret(void) {
  static int first = 1;

  // 这里需要释放进程锁
  myTask()->lock.unlock();

  if (first) {
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    //
    first = 0;
    vfs::init();
    // char buf[1000];
    // memset(buf, 0, 1000);
    // int fd = vfs::open("/", O_RDONLY);
    // // LOG_DEBUG("fd=%d",fd);
    // // while (1)
    // // {
    // //   /* code */
    // // }

    // vfs::ls(fd, buf, false);
    // struct dirent *dt = (struct dirent *)buf;

    // LOG_DEBUG("name=%s", ((struct dirent *)(dt->d_off))->d_name);
    // while (1)
    //   ;
    // ;
  }
  LOG_DEBUG("cpuid=%d task=%p", Cpu::cpuid(), Cpu::mycpu()->task);
  usertrapret();
}

// 分配一个进程，并设置其初始执行函数为forkret
Task *allocTask() {
  Task *task;
  for (task = taskTable + 1; task < &taskTable[NTASK]; task++) {
    task->lock.lock();
    if (task->state == UNUSED) {
      goto found;
    } else {
      task->lock.unlock();
    }
  }
  return 0;

found:
  if ((task->trapframe = (struct trapframe *)memAllocator.alloc()) == 0) {
    task->lock.unlock();
    return 0;
  }

  // 为进程创建页表
  task->pagetable = taskPagetable(task);

  memset(&task->context, 0, sizeof(task->context));
  memset(task->trapframe, 0, sizeof(*task->trapframe));

  task->context.sp = task->kstack + PGSIZE;
  task->context.ra = (uint64_t)forkret;
  task->lock.unlock();
  return task;
}

/**
 *
 * 创建一个进程可以使用的pagetable, 只映射了trampoline页,
 * 用于进入和离开内核空间
 *
 * @return
 */
pagetable_t taskPagetable(Task *task) {
  pagetable_t pagetable;

  // 创建一个空的页表
  pagetable = userCreate();
  if (pagetable == 0) return 0;

  // 映射trampoline代码(用于系统调用)到虚拟地址的顶端
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64_t)trampoline, PTE_R | PTE_X) < 0) {
    userFreePagetable(pagetable, 0);
    return 0;
  }
  // 将进程的trapframe映射到TRAPFRAME, TRAMPOLINE的低位一页
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64_t)(task->trapframe), PTE_R | PTE_W) < 0) {
    userUnmap(pagetable, TRAMPOLINE, 1, 0);
    userFreePagetable(pagetable, 0);
    return 0;
  }
  return pagetable;
}

/**
 * 调度函数，for循环寻找RUNABLE的进程，
 * 并执行，当使用只有一个进程时(shell),
 * 使CPU进入低功率模式。
 *  内核调度线程将一直执行该函数
 */
void scheduler() {
  Task *task;
  Cpu *c = Cpu::mycpu();
  int alive = 0;
  c->task = 0;
  for (;;) {
    intr_on();
    alive = 0;
    for (int i = 0; i < NTASK; i++) {
      task = &taskTable[i];
      task->lock.lock();
      if (task->state != UNUSED && task->state != ZOMBIE) {
        alive++;
      }
      if (task->state == ZOMBIE) {
        // LOG_DEBUG("wake up");
        wakeup(initTask);
      }
      if (task->state == RUNNABLE) {
        task->state = RUNNING;
        c->task = task;
        pswitch(&c->context, &task->context);
        c->task = 0;
      }
      task->lock.unlock();
    }
    if (alive <= 2) {
      intr_on();
      asm volatile("wfi");
    }
  }
}

// 获取当前进程
Task *myTask() {
  Intr::push_off();
  Task *task = Cpu::mycpu()->task;
  Intr::pop_off();
  return task;
}

// // 睡眠在chan上
void sleep(void *chan, SpinLock *lock) {
  Task *task = myTask();

  // 由于要改变p->state所以需要持有p->proc_lock, 然后
  // 调用before_sched。只要持有了p->proc_lock，就能够保证不会
  // 丢失wakeup(wakeup 会锁定p->proc_lock)，
  // 所以解锁lock是可以的
  if (lock != &task->lock) {  // DOC: sleeplock0
    task->lock.lock();        // DOC: sleeplock1
    lock->unlock();
  }
  // sleep
  task->chan = chan;
  task->state = SLEEPING;

  prepareSched();

  // 重置chan
  task->chan = 0;

  // Reacquire original lock.
  if (lock != &task->lock) {
    task->lock.unlock();
    lock->lock();
  }
}

void prepareSched() {
  int intr_enable;
  Task *task = myTask();

  if (!task->lock.holding()) panic("sched p->lock");
  if (Cpu::mycpu()->noff != 1) panic("sched locks");
  if (task->state == RUNNING) panic("sched running");
  if (intr_get()) panic("sched interruptible");

  intr_enable = Cpu::mycpu()->intr_enable;
  // LOG_INFO("enter switch cpuid=%d task=%p gp=%d", Cpu::cpuid(), Cpu::mycpu()->task, r_gp());
  pswitch(&task->context, &Cpu::mycpu()->context);
  // LOG_INFO("leave switch cpuid=%d task=%p gp=%d", Cpu::cpuid(), Cpu::mycpu()->task, r_gp());
  // LOG_DEBUG("epc=%p", myTask()->trapframe->epc);
  Cpu::mycpu()->intr_enable = intr_enable;
}

// 睡眠一定时间
void sleepTime(uint64_t sleep_ticks) {
  uint64_t now = timer::ticks;
  LOG_DEBUG("ticks=%d\n",sleep_ticks);
  timer::spinLock.lock();
  for (; timer::ticks - now < sleep_ticks;) {
    sleep(&timer::ticks, &timer::spinLock);
  }
  timer::spinLock.unlock();
}

// 唤醒指定chan上的进程
void wakeup(void *chan) {
  Task *task;
  for (task = taskTable; task < &taskTable[NTASK]; task++) {
    // task->lock.lock();
    if (task->state == SLEEPING && task->chan == chan) {
      task->state = RUNNABLE;
    }
    // task->lock.unlock();
  }
}

int fork() {
  Task *child;
  Task *task = myTask();
  // 分配一个新的进程
  if ((child = allocTask()) == 0) {
    return -1;
  }

  // 将父进程的内存复制到子进程中
  if (userVmCopy(task->pagetable, child->pagetable, task->sz) < 0) {
    return -1;
  }
  child->sz = task->sz;
  child->parent = task;
  // child->trapframe->ra = MAXVA;

  // 复制父进程的用户空间的寄存器
  *(child->trapframe) = *(task->trapframe);
  // memmove(child->trapframe, task->trapframe, sizeof(struct trapframe));
  // 设置子进程fork的返回值为0
  child->trapframe->a0 = 0;

  // 复制文件资源
  for (int i = 0; i < NOFILE; i++) {
    if (task->openFiles[i] != 0) {
      child->openFiles[i] = vfs::dup(task->openFiles[i]);
    }
  }

  struct vma *vma, *childVma;
  for (int i = 0; i < NOMMAPFILE; i++) {
    vma = task->vma[i];
    child->vma[i] = 0;
    if (vma) {
      childVma = allocVma();
      *(childVma) = *(vma);
      vfs::dup(vma->f);
      child->vma[i] = childVma;
    }
  }

  safestrcpy(child->currentDir, task->currentDir, strlen(task->currentDir) + 1);

  safestrcpy(child->name, task->name, sizeof(task->name) + 1);

  child->state = RUNNABLE;
  return child->pid;
}

int clone(uint64_t stack, int flags) {
  Task *child;
  Task *task = myTask();
  // 分配一个新的进程
  if ((child = allocTask()) == 0) {
    return -1;
  }

  // 将父进程的内存复制到子进程中
  if (userVmCopy(task->pagetable, child->pagetable, task->sz) < 0) {
    return -1;
  }
  child->sz = task->sz;
  child->parent = task;
  // 复制父进程的用户空间的寄存器
  *(child->trapframe) = *(task->trapframe);
  // memmove(child->trapframe, task->trapframe, sizeof(struct trapframe));
  // 设置子进程fork的返回值为0
  child->trapframe->a0 = 0;

  // 复制文件资源
  for (int i = 0; i < NOFILE; i++) {
    if (task->openFiles[i] != 0) {
      child->openFiles[i] = vfs::dup(task->openFiles[i]);
    }
  }

  // 复制vma
  struct vma *vma, *childVma;
  for (int i = 0; i < NOMMAPFILE; i++) {
    vma = task->vma[i];
    child->vma[i] = 0;
    if (vma) {
      childVma = allocVma();
      *(childVma) = *(vma);
      vfs::dup(vma->f);
      child->vma[i] = childVma;
    }
  }

  safestrcpy(child->currentDir, task->currentDir, strlen(task->currentDir) + 1);

  safestrcpy(child->name, task->name, sizeof(task->name) + 1);

  child->trapframe->sp = stack;

  child->state = RUNNABLE;
  return child->pid;
}

// int clone() {
//   // Task *child;
//   // Task *task = myTask();
// }

/**
 * @brief 增加或者减少用户内存n字节, 该函数
 * 不会释放页表，只是的unmap
 *
 * @param n 大于0增加，小于0减少
 * @return int 成功返回0，失败返回-1
 */
int growtask(int n) {
  uint_t sz;
  Task *task = myTask();
  sz = task->sz;
  if (n > 0) {
    if ((sz = userAlloc(task->pagetable, sz, sz + n)) == 0) {
      return -1;
    }
  } else if (n < 0) {
    sz = userDealloc(task->pagetable, sz, sz + n);
  }
  task->sz = sz;
  return 0;
}

static void freeTaskPagetable(pagetable_t pagetable, uint64_t sz) {
  userUnmap(pagetable, TRAMPOLINE, 1, 0);
  userUnmap(pagetable, TRAPFRAME, 1, 0);
  userFreePagetable(pagetable, sz);
}

static void freeTask(Task *task) {
  if (task->trapframe) memAllocator.free(task->trapframe);
  task->trapframe = 0;
  LOG_DEBUG("free task sz=%d", task->sz);
  if (task->pagetable != 0) {
    freeTaskPagetable(task->pagetable, task->sz);
  }
  memset(task->vma, 0, sizeof(struct vma *) * NOMMAPFILE);
  task->pagetable = 0;
  task->sz = 0;
  task->name[0] = 0;
  task->chan = 0;
  task->killed = 0;
  task->xstate = 0;
  task->state = UNUSED;
  task->parent = 0;
}

/**
 * 等待子进程退出, 返回其子进程id
 * 没有子进程返回-1， 将退出状态复
 * 制到status中。
 */
int wait(uint64_t vaddr) {
  Task *child;  // 子进程
  Task *task;
  int pid;
  bool havechild;
  task = myTask();
  task->lock.lock();
  for (;;) {
    havechild = 0;
    for (child = taskTable; child < &taskTable[NTASK]; child++) {
      if (child->parent == task) {
        child->lock.lock();
        havechild = true;
        if (child->state == ZOMBIE) {
          pid = child->pid;
          if (vaddr != 0 && copyout(task->pagetable, vaddr, (char *)&child->xstate, sizeof(child->xstate)) < 0) {
            child->lock.unlock();
            task->lock.unlock();
            return -1;
          }
          LOG_DEBUG("child pid=%d xstate=%d", child->pid, child->xstate);
          freeTask(child);
          child->lock.unlock();
          task->lock.unlock();
          return pid;
        }
        child->lock.unlock();
      }
    }
    if (!havechild) {
      return -1;
    }
    sleep(task, &myTask()->lock);  // 等待子进程唤醒
  }
}

/**
 * @brief 等待某一子进程
 *
 * @param pid 子进程id
 * @param vaddr status地址
 * @return int
 */
int wait4(int pid, uint64_t vaddr) {
  if (pid >= NTASK) {
    return -1;
  }

  Task *task = myTask();
  Task *child = &taskTable[pid];
  child->lock.lock();
  if (child->parent != task) {
    child->lock.unlock();
    return -1;
  }
  child->lock.unlock();
  task->lock.lock();
  while (true) {
    child->lock.lock();
    child->xstate = child->xstate << 8;
    if (child->state == ZOMBIE) {
      if (vaddr != 0 && copyout(task->pagetable, vaddr, (char *)&child->xstate, sizeof(child->xstate)) < 0) {
        child->lock.unlock();
        task->lock.unlock();
        return -1;
      }
      freeTask(child);
      child->lock.unlock();
      task->lock.unlock();
      return pid;
    }
    child->lock.unlock();
    sleep(task, &myTask()->lock);  // 等待子进程唤醒
  }
}

//
// 进程退出，并释放资源
//
// 这里将state设置为ZOMBIE,
// 让父进程来设置其state为UNUSED
// 若父进程已经exit, 则会由init进
// 程来完成父进程在exit时，会将其
// 子进程的parent设置为init进程
//
void exit(int status) {
  Task *task, *child;
  task = myTask();
  LOG_DEBUG("pid=%d xstate=%d", task->pid, task->xstate);
  // 关闭打开的文件
  for (int fd = 0; fd < NOFILE; fd++) {
    if (task->openFiles[fd] != NULL) {
      vfs::close(task->openFiles[fd]);
      task->openFiles[fd] = 0;
    }
  }

  // 归还当前目录inode
  // putback_inode(task->current_dir);
  memset(task->currentDir, 0, MAXPATH);
  // 将子进程托付给init进程
  for (child = taskTable; child < &taskTable[NTASK]; child++) {
    if (child->parent == task) {
      child->parent = initTask;
    }
  }

  struct vma *vma;
  for (int i = 0; i < NOMMAPFILE; i++) {
    vma = task->vma[i];
    if (vma) {
      if (vma->flag & MAP_SHARED) {
        vfs::rewind(vma->f);
        vfs::write(vma->f, true, (const char *)(vma->addr), vma->length, 0);
      }
      LOG_DEBUG("vma.addr=%p", vma->addr);
      userUnmap(task->pagetable, vma->addr, PGROUNDUP(vma->length) / PGSIZE, 0);
      // uvmunmap(p->pagetable, vma->addr, PGROUNDUP(vma->length) / PGSIZE, 0);
      vfs::close(vma->f);
      freeVma(vma);
    }
  }
  task->state = ZOMBIE;
  task->xstate = status;
  wakeup(task->parent);
  task->lock.lock();
  LOG_DEBUG("exited\n");
  prepareSched();
  panic("exit");
}

// void print_proc() {
//   struct proc *p;
//   printf(" \npid\tstate\n");
//   for (p = proc_table; p < &proc_table[NTASK]; p++) {
//     if (p->state == UNUSED) continue;
//     printf(" %d\t  %d\n", p->pid, p->state);
//   }
// }

//
// 让出cpu
//
void yield() {
  Task *task = myTask();
  task->lock.lock();
  task->state = RUNNABLE;
  prepareSched();
  task->lock.unlock();
}

/**
 *  根据user_dst将源数据复制内核地址或用户地址
 *  @param user_dst dst是否为用户空间地址
 *  @param copy的长度
 * @return 成功返回0，失败返回-1
 */
int either_copyout(bool user_dst, uint64_t dst, void *src, int len) {
  Task *task = myTask();
  if (user_dst) {
    return copyout(task->pagetable, dst, static_cast<char *>(src), len);
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}

/**
 *  根据user_dst将数据从内核地址或用户地址copy到dst中
 *  @param user_src dst是否为用户空间地址
 *  @param len copy的长度
 * @return 成功返回0，失败返回-1
 */
int either_copyin(bool user_src, void *dst, uint64_t src, uint64_t len) {
  Task *task = myTask();
  if (user_src) {
    return copyin(task->pagetable, static_cast<char *>(dst), src, len);
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}

/**
 * @brief 将fp添加到进程的打开文件列表中
 *
 * @param fp 需要添加的文件指针
 * @return 成功返回文件描述符，失败返回-1
 */
int registerFileHandle(struct file *fp, int fd) {
  if (fd > NFILE) {
    return -1;
  }
  Task *task = myTask();
  task->lock.lock();
  if (fd < 0) {
    for (int i = 0; i < NOFILE; i++) {
      if (task->openFiles[i] == NULL) {
        task->openFiles[i] = fp;
        task->lock.unlock();
        return i;
      }
    }
    panic("register file handle");
  }
  if (task->openFiles[fd] == NULL) {
    task->openFiles[fd] = fp;
    task->lock.unlock();
    return fd;
  }
  task->lock.unlock();
  return -1;
}

/**
 * @brief 获取fd对应的file
 *
 * @param fd 文件描述符
 * @return struct file* 对应的文件描述符
 */
struct file *getFileByfd(int fd) {
  if (fd < 0 || fd > NOFILE) return NULL;

  Task *task = myTask();
  task->lock.lock();
  struct file *fp = myTask()->openFiles[fd];
  task->lock.unlock();
  return fp;
}

int taskTimes(struct tms *tm) {
  Task *task = myTask();
  Task *child;
  memset(tm, 0, sizeof(struct tms));
  tm->tms_stime = task->sticks;
  tm->tms_utime = task->uticks;

  for (child = taskTable; child < &taskTable[NTASK]; child++) {
    child->lock.lock();
    if (child->parent == task) {
      tm->tms_cutime += child->uticks;
      tm->tms_cstime += child->sticks;
    }
    child->lock.unlock();
  }
  return 0;
}

struct vma *allocVma() {
  struct vma *a;
  for (a = vma; a < vma + NVMA; a++) {
    if (a->f == 0) {
      return a;
    }
  }
  return 0;
}

void freeVma(struct vma *a) { memset(a, 0, sizeof(struct vma)); }