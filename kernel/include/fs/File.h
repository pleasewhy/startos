#ifndef K_FILE_H
#define K_FILE_H
#include "types.hpp"
#include "param.hpp"
#include "fs/Pipe.hpp"

#define O_RDONLY 0x000
#define O_WRONLY 0x001
#define O_RDWR 0x002
#define O_CREATE 0x40
// #define O_TRUNC 0x400
#define O_DIRECTORY 0x0200000

#define DIR 0x040000
#define FILE 0x100000

#define T_DIR 1     // 目录
#define T_FILE 2    // 文件
#define T_DEVICE 3  // 设备

struct file {
  // char file_name[];
  char filepath[MAXPATH];
  bool directory;
  // bool hidden;
  // bool system;
  uint64_t size;
  int ref;  // reference count
  bool readable;
  bool writable;
  enum { FD_NONE, FD_PIPE, FD_ENTRY, FD_DEVICE } type;
  Pipe *pipe;
  // rtc::datetime created;
  // rtc::datetime modified;
  // rtc::datetime accessed;

  // File system specific
  size_t location;
  size_t position;
};
#endif