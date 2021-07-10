#ifndef _MEMORY_MMAP_HPP
#define _MEMORY_MMAP_HPP
#include "types.hpp"
#include "riscv.hpp"

struct vma
{
  uint64_t addr;
  enum { PROG, DATA } type;
  int           length;
  int           prot;
  int           flag;
  struct file * f;
  struct inode *ip;
  uint32_t      offset;

  /**
   * @brief 释放vma结构体
   */
  void free();

  /**
   * @brief 若va包含在vma中，则为它分配物理
   * 内存, 如果必要，会读取文件
   *
   * @return 是否包含va
   */
  bool LoadIfContain(pagetable_t pagetable, uint64_t va);
};

struct vma *allocVma();

#endif