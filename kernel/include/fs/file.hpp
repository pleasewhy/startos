// #ifndef FILE_HPP
// #define FILE_HPP

// #include "types.hpp"
// #include "StartOS.hpp"
// #include "fs/fs.hpp"

// // inode在内存中的拷贝
// struct inode {
//     uint_t dev;             // 设备号, 没有实现多个磁盘，所以没啥用
//     uint_t inum;            // Inode number
//     int ref;              // 引用数量
//     SleepLock lock; // 保护下面的字段
//     int valid;            // 表明inode是否已经从磁盘中读取?

//     short type;           // inode的类型
//     short major;          // 主要设备号
//     short minor;          // 次要设备号
//     short nlink;          // inode的链接数
//     uint_t size;            // 文件的大小
//     uint_t addrs[NDIRECT + 1];// 前NDIRECT为直接块，最后一个为间接块
// };

// struct file{
//     enum { FD_NONE, FD_PIPE, FD_INODE, FD_DEVICE } type;
//     int ref;        // 引用数量
//     char readable;
//     char writable;
//     struct inode *ip;
//     uint_t off;       // 文件偏移量
//     short major;    // 主要设备号
// };

// // 映射主要设备号对应的处理函数
// struct dev_rw {
//     int (*read)(int, uint64_t, int);
//     int (*write)(int, uint64_t, int);
// };

// extern struct dev_rw dev_rw[];

// #define CONSOLE 1

// #endif