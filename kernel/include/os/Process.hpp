#ifndef PROCESS_HPP
#define PROCESS_HPP
#include "StartOS.hpp"
#include "os/SpinLock.hpp"
#include "param.hpp"
#include "riscv.hpp"
#include "types.hpp"
// 内核切换进程需要保存的寄存器
struct context {
  uint64_t ra;
  uint64_t sp;

  // 被调用者保存
  // 不需要保存pc的原因是, 当调用pswitch切换上下文时，
  // pc是caller-saved寄存器, 会被保存在栈中, 当
  // pswitch函数返回会被恢复, 这是因为保存了ra(return
  // address)寄存器的。
  uint64_t s0;
  uint64_t s1;
  uint64_t s2;
  uint64_t s3;
  uint64_t s4;
  uint64_t s5;
  uint64_t s6;
  uint64_t s7;
  uint64_t s8;
  uint64_t s9;
  uint64_t s10;
  uint64_t s11;
};

struct trapframe {
  /*   0 */ uint64_t kernel_satp;    // kernel page table
  /*   8 */ uint64_t kernel_sp;      // top of process's kernel stack
  /*  16 */ uint64_t kernel_trap;    // usertrap()
  /*  24 */ uint64_t epc;            // saved user program counter
  /*  32 */ uint64_t kernel_hartid;  // saved kernel tp
  /*  40 */ uint64_t ra;
  /*  48 */ uint64_t sp;
  /*  56 */ uint64_t gp;
  /*  64 */ uint64_t tp;
  /*  72 */ uint64_t t0;
  /*  80 */ uint64_t t1;
  /*  88 */ uint64_t t2;
  /*  96 */ uint64_t s0;
  /* 104 */ uint64_t s1;
  /* 112 */ uint64_t a0;
  /* 120 */ uint64_t a1;
  /* 128 */ uint64_t a2;
  /* 136 */ uint64_t a3;
  /* 144 */ uint64_t a4;
  /* 152 */ uint64_t a5;
  /* 160 */ uint64_t a6;
  /* 168 */ uint64_t a7;
  /* 176 */ uint64_t s2;
  /* 184 */ uint64_t s3;
  /* 192 */ uint64_t s4;
  /* 200 */ uint64_t s5;
  /* 208 */ uint64_t s6;
  /* 216 */ uint64_t s7;
  /* 224 */ uint64_t s8;
  /* 232 */ uint64_t s9;
  /* 240 */ uint64_t s10;
  /* 248 */ uint64_t s11;
  /* 256 */ uint64_t t3;
  /* 264 */ uint64_t t4;
  /* 272 */ uint64_t t5;
  /* 280 */ uint64_t t6;
};

// extern struct cpu cpus[NCPU];
enum procstate { UNUSED, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };

struct vma {
  uint64_t addr;
  int length;
  int prot;
  struct file *f;
  int flag;
};

// 进程
class Task {
 public:
  SpinLock lock;                // 进程锁
  enum procstate state;         // 进程的状态
  Task *parent;                 // 父进程
  void *chan;                   // 如果非空，将在chan睡眠
  int killed;                   // 如果非空，将被杀死
  int xstate;                   // 返回给父进程的退出状态
  int pid;                      // 进程ID
  struct trapframe *trapframe;  // trampoline.S保存进程数据在这里
  pagetable_t pagetable;        // 用户页表
  // struct inode *current_dir;       // 当前目录
  struct file *openFiles[NOFILE];  // 用户打开文件，其下标为文件描述符。
  char currentDir[MAXPATH];
  uint64_t entry;
  int sticks;  // 程序在用户态下运行的时间
  int uticks;  // 程序在内核态下运行的时间
  struct vma *vma[NOMMAPFILE];
  uint64_t kstack;         // 进程的内核空间栈。
  struct context context;  // 被保存的寄存器，用于pswitch
  char name[16];           // 进程名
  int sz;                  // 进程使用空间的大小
};
#endif  // PROCESS_HPP
