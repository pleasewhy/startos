#ifndef STARTOS_TIMER_HPP
#define STARTOS_TIMER_HPP

#include "StartOS.hpp"
#include "os/SpinLock.hpp"
#include "param.hpp"
#include "types.hpp"

/**
 * Timer类用于定义，管理系统时钟相关的函数
 * 现在的主要功能，用于初始化时钟和维护ticks
 *
 */
namespace timer {
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

extern int ticks;
extern SpinLock spinLock;
extern uint32_t interval;
};  // namespace timer
#endif