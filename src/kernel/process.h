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



struct trapframe {
    /*   0 */ uint64 kernel_satp;   // kernel page table
    /*   8 */ uint64 kernel_sp;     // top of process's kernel stack
    /*  16 */ uint64 kernel_trap;   // usertrap()
    /*  24 */ uint64 epc;           // saved user program counter
    /*  32 */ uint64 kernel_hartid; // saved kernel tp
    /*  40 */ uint64 ra;
    /*  48 */ uint64 sp;
    /*  56 */ uint64 gp;
    /*  64 */ uint64 tp;
    /*  72 */ uint64 t0;
    /*  80 */ uint64 t1;
    /*  88 */ uint64 t2;
    /*  96 */ uint64 s0;
    /* 104 */ uint64 s1;
    /* 112 */ uint64 a0;
    /* 120 */ uint64 a1;
    /* 128 */ uint64 a2;
    /* 136 */ uint64 a3;
    /* 144 */ uint64 a4;
    /* 152 */ uint64 a5;
    /* 160 */ uint64 a6;
    /* 168 */ uint64 a7;
    /* 176 */ uint64 s2;
    /* 184 */ uint64 s3;
    /* 192 */ uint64 s4;
    /* 200 */ uint64 s5;
    /* 208 */ uint64 s6;
    /* 216 */ uint64 s7;
    /* 224 */ uint64 s8;
    /* 232 */ uint64 s9;
    /* 240 */ uint64 s10;
    /* 248 */ uint64 s11;
    /* 256 */ uint64 t3;
    /* 264 */ uint64 t4;
    /* 272 */ uint64 t5;
    /* 280 */ uint64 t6;
};

// cpu
struct cpu {
    struct proc *proc; // 当前运行在该CPU的进程。
    struct context context; // 内核调度线程的上下文。
    int noff; // push_off 嵌套的深度。
    int intr_enable; // 在进入内核调度线程之前是否允许中断？
};

extern struct cpu cpus[NCPU];

enum procstate {
    UNUSED,
    SLEEPING,
    RUNNABLE,
    RUNNING,
    ZOMBIE
};

// 进程
struct proc {
    enum procstate state; // 进程的状态
    struct proc *parent; // 父进程
    void *chan; // 如果非空，将在chan睡眠
    int killed; // 如果非空，将被杀死
    int xstate; // 返回给父进程的退出状态
    int pid; // 进程ID
    struct trapframe trapframe;
    struct spinlock proc_lock;
    struct inode *current_dir;

    uint64 kstack; // 进程的内核空间栈。
    struct context context; // 被保存的寄存器，用于pswitch
    char name[16]; // 进程名
};
