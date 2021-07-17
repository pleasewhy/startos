#ifndef TASK_SCHEDULER_HPP
#define TASK_SCHEDULER_HPP

#include "StartOS.hpp"
#include "memory/VmManager.hpp"
#include "os/Process.hpp"
#include "os/Timer.hpp"
#include "param.hpp"
#include "types.hpp"

// /**
//  * @brief 初始化任务表
//  */
void initTaskTable();

// /**
//  * @brief 初始化第一个进程
//  */
void initFirstTask();

/**
 * @brief 分配一个进程，并设置其初始执行函数forkret
 */
Task *allocTask();

// /**
//  * @brief 创建一个进程可以使用的pagetable,
//  *        只映射了trampoline页, 用于进入和离开内核空间
//  *
//  * @return pagetable_t 进程可用的pagetable
//  */
// pagetable_t getTaskPagetable();

// /**
//  * @brief 调度函数
//  *
//  * @note 调度函数，for循环寻找RUNABLE的进程，
//  *       并执行，当使用只有一个进程时(shell),
//  *       CPU会进入低功率模式。
//  *      该函数不会返回
//  */
void scheduler();

extern "C" void pswitch(struct context *, struct context *);

/**
 * @brief sleep在chan上
 *
 */
void sleep(void *chan, SpinLock *lock);

/**
 * @brief 睡眠一段时间
 *
 * @param sleep_ticks 需要睡眠的tick数
 */
void sleepTime(uint64_t sleep_ticks);

/**
 * @brief 进入调度线程之前需要检查当前的cpu和线程状态
 *
 */
void prepareSched();

/**
 * @brief 唤醒sleep在指定chan上的进程
 *
 */
void wakeup(void *chan);

/**
 * @brief 打印当前任务
 *
 */
void printTask();

/**
 * @brief 让出cpu
 *
 */
void yield();

/**
 * @brief 获取当前CPU的在运行的进程
 */
Task *myTask();

/**
 * @brief 获取task可用的页表
 *
 * @param task
 * @return pagetable_t
 */
pagetable_t taskPagetable(Task *task);

/**
 * @brief 创建一个与当前进程一致的新进程
 *
 * @return int 子进程返回0，父进程返回子进程的id
 */
int fork();

/**
 * @brief 创建一个子线程，并执行fn函数
 *
 * @param fn
 * @param stack
 * @param stackSz
 * @param flags
 * @return int
 */
int clone(uint64_t stack, int flags);

/**
 * @brief 等待子进程退出, 返回其子进程id
 * 没有子进程返回-1， 将退出状态复
 * 制到status中。
 * @return 成功返回0，失败返回-1
 */
int wait(uint64_t vaddr);

/**
 * @brief 增加或者减少用户内存n字节
 *
 * @param n 大于0增加，小于0减少
 * @return int 成功返回0，失败返回-1
 */
int growtask(int n);

/**
 * @brief 等待某一子进程退出
 *
 * @param pid 等待的子进程id
 * @param vaddr 用于子进程exit code，为0时忽略exit code
 * @return int 成功返回子进程id，失败返回-1
 */
int wait4(int pid, uint64_t vaddr);

/**
 * @brief 进程退出，释放资源 这里将state
 *        设置为ZOMBIE, 让父进程来设置其state为UNUSED
 *        若父进程已经exit, 则会由init进
 *        程来完成父进程在exit时，会将其
 *        子进程的parent设置为init进程
 *
 */
void exit(int status);

/**
 *  根据user_dst将数据从内核地址或用户地址copy到dst中
 *  @param user_src dst是否为用户空间地址
 *  @param copy的长度
 * @return 成功返回0，失败返回-1
 */
int either_copyin(bool user_src, void *dst, uint64_t src, uint64_t len);

/**
 *  根据user_dst将源数据复制内核地址或用户地址
 *  @param user_dst dst是否为用户空间地址
 *  @param copy的长度
 * @return 成功返回0，失败返回-1
 */
int either_copyout(bool user_dst, uint64_t dst, void *src, int len);

/**
 * @brief 将fp添加到进程的打开文件列表中
 *
 * @param fp 需要添加的文件指针
 * @return 成功返回文件描述符，失败返回-1
 */
int registerFileHandle(struct file *fp, int fd = -1);

/**
 * @brief 获取fd对应的文件
 *
 * @param fd 文件描述符
 * @return struct file* fd对应的文件
 */
struct file *getFileByfd(int fd);

/**
 * @brief 执行给定可执行文件
 *
 * @param path
 * @param argv
 * @return int
 */
int exec(char *path, char **argv);

/**
 * @brief 获取进程的时间用户态运行时间和内核态运行时间
 * 及其子进程时间信息
 *
 * @param tm 保存相关的时间信息
 * @return int 成功返回0，失败返回-1
 */
int taskTimes(struct tms *tm);

/**
 * @brief 设置pid对应的进程的信号
 *
 * @param pid
 * @param sig
 * @return int
 */
int kill(int pid, int sig);

/**
 * @brief 释放进程的页表
 * @note ummap进程的trapframe和trampoline，并释放
 * 递归的释放该页表所拥有的全部物理内存
 *
 */
void FreeTaskPagetable(pagetable_t pagetable, uint64_t sz);

#endif  // TASK_SCHEDULER_HPP