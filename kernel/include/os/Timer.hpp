#ifndef STARTOS_TIMER_HPP
#define STARTOS_TIMER_HPP

#include "os/SpinLock.hpp"
#include "param.hpp"
#include "types.hpp"
#include "StartOS.hpp"


/**
 * Timer类用于定义，管理系统时钟相关的函数
 * 现在的主要功能，用于初始化时钟和维护ticks
 *
 */
class Timer {
 public:
  /**
   *  @brief 创建一个timer
   *
   *  @param  interval      时钟周期
   *
   *  @note 该类只会被创建一次
   */
  Timer(uint32_t interval);

  /**
   *  配置机器模式下的时钟中断，使其能够被kernelvec.S中的
   *  timervec函数处理，timervec会抛出一个软件中断让，trap.c
   *  中的devintr()处理
   */
  void init();

  /**
   * @brief 设置timer的下一次超时时间
   */
  void setTimeout();

  /**
   * @brief 定时器中断处理函数，主要是递增ticks和唤醒线程
   */
  void handleIntr();

 public:
  int ticks;
  SpinLock spinLock;
  uint32_t interval;
};
#endif