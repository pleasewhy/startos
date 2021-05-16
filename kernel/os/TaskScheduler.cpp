#include "os/TaskScheduler.hpp"
#include "common/logger.h"
#include "common/printk.hpp"
#include "common/string.hpp"
#include "device/Console.hpp"
#include "fs/disk/Disk.hpp"
#include "fs/disk/SdCard.hpp"
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
#include "file.h"
#include "param.hpp"

Task taskTable[NTASK];

extern MemAllocator memAllocator;
extern Timer timer;
extern Console console;
extern BufferLayer bufferLayer;
extern Fat32FileSystem fatFs;

extern char trampoline[], uservec[], userret[];

Task *initTask;

extern char trampoline[];  // trampoline.S

alignas(4096) char stack[PGSIZE * 2 * (NTASK + 1)];

// 初始化任务表
void initTaskTable() {
  Task *task;
  for (int i = 0; i < NTASK; i++) {
    task = &taskTable[i];
    task->lock.init("task");
    task->pid = i;
    // task->kstack = (uint64_t) kalloc();
    task->kstack = (uint64_t)(stack + PGSIZE * i);
    task->trapframe = 0;
    task->state = UNUSED;
    task->killed = 0;
    task->xstate = 0;
    task->sz = 0;
    memset(task->currentDir, 0, MAXPATH);
    memset(task->openFiles, 0, sizeof(struct file *) * NOFILE);
  }
}

// // 该程序执行exec("/init"), 然后退出
// // 通过 od -t xC initcode 生成
// uchar_t initcode[] = {0x17, 0x05, 0x00, 0x00, 0x13, 0x05, 0x45, 0x02, 0x97, 0x05, 0x00, 0x00, 0x93,
//                       0x85, 0x35, 0x02, 0x93, 0x08, 0x20, 0x00, 0x73, 0x00, 0x00, 0x00, 0x93, 0x08,
//                       0x30, 0x00, 0x73, 0x00, 0x00, 0x00, 0xef, 0xf0, 0x9f, 0xff, 0x2f, 0x69, 0x6e,
//                       0x69, 0x74, 0x00, 0x00, 0x24, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
uchar_t initcode[] = {0x17, 0x05, 0x00, 0x00, 0x13, 0x05, 0x45, 0x02, 0x97, 0x05, 0x00, 0x00, 0x93,
                      0x85, 0x35, 0x02, 0x93, 0x08, 0xd0, 0x0d, 0x73, 0x00, 0x00, 0x00, 0x93, 0x08,
                      0xd0, 0x05, 0x73, 0x00, 0x00, 0x00, 0xef, 0xf0, 0x9f, 0xff, 0x2f, 0x69, 0x6e,
                      0x69, 0x74, 0x00, 0x00, 0x24, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};

// 初始化第一个进程
void initFirstTask() {
  Task *task = allocTask();
  // 为进程分配一页内存，并将初始化的指令和数据写入
  user_vm_init(task->pagetable, initcode, sizeof(initcode));

  task->sz = PGSIZE;
  // 内核空间第一次进入用户空间
  task->trapframe->epc = 0;
  task->trapframe->sp = PGSIZE;

  memmove(task->name, "initcode", sizeof(task->name));
  // task->current_dir = namei("/");
  task->currentDir[0] = '/';

  // for (int i = 0; i < NOFILE; i++) task->openFiles[i] = 0;
  task->state = RUNNABLE;
  initTask = task;
  printf("over");
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
    // uint8_t buf[512];
    // memset(buf, 0, 512);
    // sdcard_read_sector(buf,0);
    // if (strncmp((char const*)(buf + 82), "FAT32", 5))
    //     panic("not FAT32 volume");
    vfs::init();
    char buf[100];
    memset(buf, 0, 100);
    int fd = vfs::open("/bin", O_RDONLY);
    vfs::ls(fd, buf, false);
    struct dirent *dt = (struct dirent *)buf;

    LOG_DEBUG("name=%s",dt->d_name);
    while(1);
    // struct buf *b0 = bufferLayer.allocBuffer(0, 0);
    // memset(b0->data, 0, 512);
    // memmove(b0->data, "hello world!", 13);
    // printf("write=%s\n", b0->data);
    // bufferLayer.write(b0);
    // sdcard_write_sector((uint8_t*)b0->data, 0);
    // printf("write over\n");
    // memset(b0->data, 0, 512);
    // sdcard_read_sector((uint8_t*)b0->data, 0);
    // printf("read=%s\n", b0->data);
    // while (1)
    //   ;
    // struct buf bufferLayer.read(0,0);
    // test_sdcard();
  }
  LOG_DEBUG("cpuid=%d task=%p", Cpu::cpuid(), Cpu::mycpu()->task);
  usertrapret();
}

// 分配一个进程，并设置其初始执行函数为forkret
Task *allocTask() {
  Task *task;
  for (task = taskTable; task < &taskTable[NTASK]; task++) {
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
    // TODO 失败释放内存
    return 0;
  }
  // 将进程的trapframe映射到TRAPFRAME, TRAMPOLINE的低位一页
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64_t)(task->trapframe), PTE_R | PTE_W) < 0) {
    //        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    //        uvmfree(pagetable, 0);
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
  uint64_t now = timer.ticks;
  timer.spinLock.lock();
  for (; timer.ticks - now < sleep_ticks;) {
    sleep(&timer.ticks, &timer.spinLock);
  }
  timer.spinLock.unlock();
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
  if (user_vm_copy(task->pagetable, child->pagetable, task->sz) < 0) {
    return -1;
  }
  child->sz = task->sz;
  child->parent = task;

  // 复制父进程的用户空间的寄存器
  *(child->trapframe) = *(task->trapframe);
  // memmove(child->trapframe, task->trapframe, sizeof(struct trapframe));
  // 设置子进程fork的返回值为0
  child->trapframe->a0 = 0;

  for (int i = 0; i < NOFILE; i++) {
    if (task->openFiles[i] != 0) {
      child->openFiles[i] = vfs::dup(task->openFiles[i]);
    }
  }
  safestrcpy(child->currentDir, task->currentDir, strlen(task->currentDir) + 1);

  safestrcpy(child->name, task->name, sizeof(task->name) + 1);

  child->state = RUNNABLE;
  return child->pid;
}

static void freeTask(Task *task) {
  if (task->trapframe) memAllocator.free(task->trapframe);
  task->trapframe = 0;
  // TODO 释放页表
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
  task->state = ZOMBIE;
  task->xstate = status;
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
  if (task->openFiles[fd] != NULL) {
    task->lock.unlock();
    return fd;
  }
  return -1;
}

/**
 * @brief 获取fd对应的file
 *
 * @param fd 文件描述符
 * @return struct file* 对应的文件描述符
 */
struct file *getFileByfd(int fd) {
  Task *task = myTask();
  task->lock.lock();
  struct file *fp = myTask()->openFiles[fd];
  task->lock.unlock();
  return fp;
}