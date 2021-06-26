#include "device/Console.hpp"
#include "common/logger.h"
#include "common/sbi.h"
#include "os/SpinLock.hpp"
#include "fs/vfs/vfs.hpp"
#include "os/TaskScheduler.hpp"

#define Enter (13)
#define BACKSPACE (0x100)
#define CTRL(x) (x - '@')

extern Console console;

void Console::init()
{
  this->spinLock.init("console");
  this->read_index = 0;
  this->write_index = 0;
}

Console::Console() {}

void Console::putc(int c)
{
  if (c == BACKSPACE) {
    // 处理退格
    sbi_console_putchar('\b');
    sbi_console_putchar(' ');
    sbi_console_putchar('\b');
  }
  else {
    sbi_console_putchar(c);
  }
}

int Console::read(uint64_t dst, bool user, int n)
{
  char c;
  int  expect = n;
  this->spinLock.lock();
  while (n > 0) {
    while (this->read_index == this->write_index) {
      sleep(&this->read_index, &this->spinLock);
    }
    c = this->buf[this->read_index++ % INPUT_BUF];
    if (either_copyout(user, dst, &c, 1) < 0)
      break;
    dst++;
    n--;
    // 当输入一整行时，需要返回
    if (c == '\n') {
      break;
    }
  }
  this->spinLock.unlock();
  LOG_DEBUG("console read=%d", expect - n);
  return expect - n;
}

int Console::write(uint64_t src, bool user, int n)
{
  int i;

  this->spinLock.lock();
  for (i = 0; i < n; i++) {
    char c;
    if (either_copyin(user, &c, src + i, 1) == -1)
      break;
    sbi_console_putchar(c);
  }
  this->spinLock.unlock();

  return i;
}

void Console::console_intr(char c)
{
  switch (c) {
    case '\x08':  // backspace
    case '\x7f':  // del
      if (this->read_index != this->write_index) {
        this->write_index--;
        this->putc(BACKSPACE);
        this->putc('\a');
      }
      break;
    case CTRL('P'):
      // print_proc();
      break;
    case '~': // 输出文件系统debug信息
      vfs::VfsManager::DebugInfo();
      break;
    default:
// 显示输出字符
// 各个操作系统下的回车键对应的ascii码:
//    mac:      '\r'
//    linux:    '\n'
//    windows:  '\r\n'
#ifdef K210
      if (c == '\r')
        break;
#else
      c = (c == '\r') ? '\n' : c;
#endif
      this->putc(c);
      // 保存输入字符
      this->buf[this->write_index++ % INPUT_BUF] = c;
      if (c == '\n') {
        wakeup(&this->read_index);
      }
      break;
  }
}