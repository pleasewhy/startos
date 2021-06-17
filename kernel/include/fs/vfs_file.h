#ifndef K_FILE_H
#define K_FILE_H
#include "types.hpp"
#include "param.hpp"
#include "os/SleepLock.hpp"
#include "fs/Pipe.hpp"
#include "os/time.hpp"

class FileSystem;

/**
 *
 * @note 如果某个文件系统没有inode，则需要相应文件系统
 * 提供inode需要的信息。
 *
 * @note Fat32文件系统中没有inum，故将inum替换为
 * 该短文件目录项在磁盘中偏移量
 */
struct inode
{
  uint_t          dev;          // 设备号
  uint64_t        inum;         // Inode number
  int             ref;          // 引用计数
  SleepLock       sleeplock;    // 用于保护inode
  short           mode;         // inode的类型和权限
  FileSystem *    file_system;  // inode 所属文件系统
  struct inode *  parent;       // 当前inode的父目录
  short           nlink;  // 链接该inode的目录项,fat32中目录使用该字段作为目录项的数量
  uint_t          sz;     // 文件大小
  struct time::timespec atime;  // 最后访问时间
  struct time::timespec mtime;  // 最后修改时间(文件内容)
  struct time::timespec ctime;  // 最后改变时间(元数据)

public:
  /**
   * @brief 递增ref
   */
  struct inode *dup();

  /**
   * @brief 递减ref，当为0时删除它
   */
  void free();
};

struct dirent
{
  int            ref;
  char *         name;
  FileSystem *   file_system;
  struct inode * inode;
  struct dirent *parent;

  /**
   * @brief 递增ref
   */
  int dup();

  /**
   * @brief 递减ref，当为0时删除它
   */
  int free();
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

  /**
   * @brief 递增ref
   */
  int dup();

  /**
   * @brief 递减ref，当为0时删除它
   */
  int free();
};
#endif