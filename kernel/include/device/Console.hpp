#ifndef CONSOLE_HPP
#define CONSOLE_HPP
#include "os/SpinLock.hpp"

#include "StartOS.hpp"
#include "types.hpp"

#define INPUT_BUF 128

class Console {
 public:
  /**
   * 通过uart创建一个控制台设备
   */
  Console();

  /**
   * 初始化控制台
   */
  void init();

  /**
   *  从字符设备中读取数据
   *
   *  每次读取size字节或者一行，不包含'\n'
   *
   *  @param dst      数据存放地址
   *  @param n        读取的字节数
   *  @return         成功返回读取字节数，失败返回一个负数
   */
  int read(uint64_t dst, bool user, int n);

  /**
   *  向字符设备写入数据
   *
   *
   *  @param src      需要写入数据的地址
   *  @param n        写入的字节数
   *  @return         返回写入的字节数
   */
  int write(uint64_t src, bool user, int n);

  /**
   * 向控制台写入一个字符
   */
  void putc(int c);

  /**
   *  控制台中断处理程序，当发生uart中断时，会被执行。
   *  它处理uart接收的到字符：
   *    1、显示输入字符
   *    2、退格
   *    3、打印进程
   *    4、保存输入字符
   *
   *  @param c      该次中断uart接收到的字符
   */
  void console_intr(char c);

 private:
  char buf[INPUT_BUF];
  int read_index;
  int write_index;
  SpinLock spinLock;
};

#endif  // console.h