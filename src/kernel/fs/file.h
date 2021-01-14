//
// Created by hy on 2021/1/10.
//

#ifndef SRC_FILE_H
#define SRC_FILE_H

#endif //SRC_FILE_H

// inode在内存中的拷贝
struct inode {
  uint dev;           // Device number
  uint inum;          // Inode number
  int ref;            // Reference count
  struct sleeplock lock; // protects everything below here
  int valid;          // inode has been read from disk?

  short type;         // copy of disk inode
  short major;
  short minor;
  short nlink;
  uint size;
  uint addrs[NDIRECT+1];
};
