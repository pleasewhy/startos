#ifndef SPIN_LOCK_HPP
#define SPIN_LOCK_HPP

#include "types.hpp"
#include "StartOS.hpp"

class SpinLock {
 private:
  bool locked;
  const char *name;
  int cpuid;

 public:

  SpinLock();
  /**
   * 创建并初始化SpinLock
   *
   * @param name  锁的名称，用于debug
   */
  SpinLock(const char *name);

  /**
   * 初始化此锁
   * @note  由于内核中使用的对象都是静态的，
   *        即很难通过构造函数初始化。
   */
  void init(const char* name);

  /**
   * 循环等待直到获取锁，这个过程中会禁用中断
   * 即持有锁的这段时间会中断时处于禁用状态。
   */
  void lock();

  /**
   * unlock此自旋锁，这个过程会允许中断，该锁
   * 必须被locked状态，并且之前lock此锁的CPU
   * 必须是当前这个CPU
   */
  void unlock();

  /**
   * 检查当前CPU是否持有该锁
   * 需要关中断
   */
  bool holding();

};

#endif  // SpinLock.hpp