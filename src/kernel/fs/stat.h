#define T_DIR     1   // 目录
#define T_FILE    2   // 文件
#define T_DEVICE  3   // 设备

struct stat {
    int dev;     // 文件系统的磁盘设备
    uint ino;    // inode号
    short type;  // 文件类型
    short nlink; // 该文件的链接数量
    uint64 size; // 文件大小(字节)
};
