#ifndef CPU_HPP
#define CPU_HPP
#include "os/Process.hpp"
#include "riscv.hpp"
class Cpu {
 public:
  Task *task;              // 当前运行在该CPU的进程。
  struct context context;  // 内核调度线程的上下文。
  int noff;                // push_off 嵌套的深度。
  bool intr_enable;        // 在进入内核调度线程之前是否允许中断？

  /**
   * @brief 初始化
   *
   */
  void init();

  /**
   * 获取当前CPU结构
   */
  static Cpu *mycpu();

  /**
   * 获取当前CPU ID, 即tp寄存器
   */
  static int cpuid();
};
#endif  // cpu.hpp