// 内核切换进程需要保存的寄存器
struct context {
  uint64 ra;
  uint64 sp;

  // 被调用者保存
  // 不需要保存pc的原因是, 当调用pswitch切换上下文时，
  // pc是caller-saved寄存器, 会被保存在栈中, 当
  // pswitch函数返回会被恢复, 这是因为保存了ra(return
  // address)寄存器的。
  uint64 s0;
  uint64 s1;
  uint64 s2;
  uint64 s3;
  uint64 s4;
  uint64 s5;
  uint64 s6;
  uint64 s7;
  uint64 s8;
  uint64 s9;
  uint64 s10;
  uint64 s11;
};

// cpu
struct cpu {
  struct proc* proc; // 当前运行在该CPU的进程。
  struct context context; // 内核调度线程的上下文。
  int noff; // push_off嵌套的深度。
  int intena; // 在push_off之前是否允许中断？
};

extern struct cpu cpus[NCPU];

enum procstate { UNUSED,
  SLEEPING,
  RUNNABLE,
  RUNNING,
  ZOMBIE };

// 进程
struct proc {
  enum procstate state; // 进程的状态
  struct proc* parent; // 父进程
  void* chan; // 如果非空，将在chan睡眠
  int killed; // 如果非空，将被杀死
  int xstate; // 返回给父进程的退出状态
  int pid; // 进程ID

  uint64 kstack; // 进程的内核空间栈。
  struct context context; // 被保存的寄存器，用于pswitch
  char name[16]; // 进程名
};
