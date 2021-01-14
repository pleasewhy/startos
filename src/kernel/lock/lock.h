//
// Created by hy on 2020/12/26.
//

struct spinlock {
  uint locked;
  struct cpu* cpu;
  char* name;
};

struct sleeplock {
  uint locked;
  struct spinlock lk; // 保护睡眠锁

  // For debugging:
  char* name; // 锁的名称
  int pid; // 持有该锁的进程
};
