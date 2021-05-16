#include "types.hpp"
#include "StartOS.hpp"

#define min(a, b) ((a) < (b) ? (a) : (b))

#define ROOTINO 1 // root i-number, 不知道为什么0不行
#define BSIZE 1024 // 块的大小

#define FSMAGIC 0x10203040

#define NDIRECT 12
#define NINDIRECT (BSIZE / sizeof(uint_t))
#define MAXFILE (NDIRECT + NINDIRECT)

// 每个块可以存放inode的数量
#define IPB (BSIZE / sizeof(struct dinode))

// Block containing inode i
// 得到包含inode i的块
#define IBLOCK(i, sb) ((i) / IPB + sb.inodestart)

// 块的位数，用于Bitmap
#define BPB (BSIZE * 8)

// 包含块b的bitmap块号
#define BBLOCK(b, sb) ((b) / BPB + sb.bmapstart)

// 目录是一个一种特殊的文件，包含dirent
#define DIRSIZ 14

#define NINODE 50

#define T_DIR     1   // Directory
#define T_FILE    2   // File
#define T_DEVICE  3   // Device

// Disk layout:
// [ boot block | super block | log | inode blocks |
//                                          free bit map | data blocks]
//
// mkfs computes the super block and builds an initial file system. The
// super block describes the disk layout:
struct superblock {
    uint_t magic; // 魔法数字
    uint_t size; // 文件映像中块的数量
    uint_t nblocks; // 数据块的数量
    uint_t ninodes; // inode的数量
    uint_t inodestart; // 第一个inode块的块号
    uint_t bmapstart; // 第一个bitmap块的块号
};

// 磁盘上inode的结构体
struct dinode {
    short type; // 文件类型
    short major; // Major device number (T_DEVICE)
    short minor; // Minor device number (T_DEVICE)
    short nlink; // 文件系统中链接该inode的数量
    uint_t size; // 文件的大小
    uint_t addrs[NDIRECT + 1]; // 数据块地址
};

struct direntry {
    ushort_t inum;    // 目录项对应的inode
    char name[DIRSIZ];  // 名称
};