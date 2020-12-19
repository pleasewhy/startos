// 磁盘上的文件系统


#define ROOTINO  1   // root i-number
#define BSIZE 1024  // 块的大小

// Disk layout:
// [ boot block | super block | log | inode blocks |
//                                          free bit map | data blocks]
//
// mkfs computes the super block and builds an initial file system. The
// super block describes the disk layout:
struct superblock {
  uint magic;        // 魔法数字
  uint size;         // 文件映像中块的数量
  uint nblocks;      // 数据块的数量
  uint ninodes;      // inode的数量
  uint nlog;         // 日志块的数量
  uint logstart;     // Block number of first log block
  uint inodestart;   // 第一个inode块的块号
  uint bmapstart;    // 第一个bitmap块的块号
};

#define FSMAGIC 0x10203040

#define NDIRECT 12
#define NINDIRECT (BSIZE / sizeof(uint))
#define MAXFILE (NDIRECT + NINDIRECT)

// 磁盘上inode的结构体
struct dinode {
  short type;           // 文件类型
  short major;          // Major device number (T_DEVICE only)
  short minor;          // Minor device number (T_DEVICE only)
  short nlink;          // 文件系统中链接该inode的数量
  uint size;            // 文件的大小
  uint addrs[NDIRECT+1];   // 数据块地址
};

// Inodes per block.
#define IPB           (BSIZE / sizeof(struct dinode))

// Block containing inode i
#define IBLOCK(i, sb)     ((i) / IPB + sb.inodestart)

// Bitmap bits per block
#define BPB           (BSIZE*8)

// Block of free map containing bit for block b
#define BBLOCK(b, sb) ((b)/BPB + sb.bmapstart)

// Directory is a file containing a sequence of dirent structures.
// 目录是一个一种特殊的文件，包含dirent
#define DIRSIZ 14

struct dirent {
  ushort inum;
  char name[DIRSIZ];
};

