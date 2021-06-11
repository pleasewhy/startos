#ifndef K_FILE_H
#define K_FILE_H
#include "types.hpp"
#include "param.hpp"
#include "os/SleepLock.hpp"
#include "fs/Pipe.hpp"

/**
 *
 * @note 如果某个文件系统没有inode，则需要相应文件系统
 * 提供inode需要的信息。
 *
 * @note Fat32文件系统中没有inum，故将inum替换为
 * 该短文件目录项的字节偏移量
 */
struct inode
{
  uint_t    dev;        // 设备号
  uint64_t  inum;       // Inode number
  int       ref;        // 引用计数
  SleepLock sleeplock;  // 用于保护inode
  short     mode;       // inode的类型:目录
  short     nlink;
  uint_t    sz;
};

class FileSystem;
struct dirent
{
  char *         name;
  FileSystem *   file_system;
  struct inode * inode;
  struct dirent *parent;
};

struct file
{
  char     filepath[MAXPATH];
  bool     directory;
  uint64_t size;
  int      ref;  // reference count
  bool     readable;
  bool     writable;
  enum { FD_NONE, FD_PIPE, FD_ENTRY, FD_DEVICE } type;
  Pipe *        pipe;
  struct inode *inode;
  size_t        offset;
};
#endif