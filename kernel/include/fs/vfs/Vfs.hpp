#ifndef VFS_HPP
#define VFS_HPP

#include "FileSystem.hpp"
#include "StartOS.hpp"
#include "file.h"
#include "types.hpp"

#define NFILESYSTEM 5
#define MAXFSTYPE 10

namespace vfs {

// using int = size_t;

/**
 * @brief Enumeration for all supported partition types
 */
enum class FileSystemType {
  FAT32 = 1,     ///< FAT32
  SYSFS = 2,     ///< Sysfs
  DEVFS = 3,     ///< Devfs
  PROCFS = 4,    ///< Procfs
  UNKNOWN = 100  ///< Unknown file system
};

/**
 * @brief 初始化虚拟文件系统
 * 这会初始化一些虚拟文件系统需要用到的一些数据，并且mount
 * 一些文件系统
 */
void init();

/**
 * @brief 通过给定的路径打开文件
 * @param file 文件路径
 * @param flags 文件标志位
 * @return 成功返回fd，失败返回-1
 */
int open(const char *filePath, size_t flags);

/**
 * @brief 打开指定目录下的文件
 * @param dirfd 目录文件描述符
 * @param filename 该目录下的文件名
 * @param flags 文件标志位，如RDONLY
 * @param mode 只在创建的时候有用，用于给文件设置权限，或创建文件的类型
 * @return 成功返回fd，失败返回-1
 */
int openat(int dirfd, const char *filename, size_t flags, mode_t mode);

/**
 * @brief 关闭给定的文件描述符
 */
void close(struct file *fp);

/**
 * @brief 获取给定文件描述符对应文件的信息
 * @param fd 文件描述符
 * @param info 文件信息
 */
// void stat(int fd, vfs::stat_info& info);

/**
 * @brief 返回文件系统的信息
 * @param mount_point The mount point
 * @param info The info to fill
 * @return a status code
 */
// void statfs(const char* mount_point, vfs::statfs_info& info);

/**
 * @brief 创建目录
 * @param dirfd 要创建的目录所在的目录的文件描述符
 * @param path 要创建的目录的路径。如果path是相对路
 * 径，则它是相对于dirfd目录而言的。如果path是相对路
 * 径，且dirfd的值为AT_FDCWD，则它是相对于当前路径而
 * 言的。如果path是绝对路径，则dirfd被忽略。
 * @return 成功返回0，失败返回-1
 */
int mkdirat(int dirfd, const char *path);

/**
 * @brief 删除文件
 * @param dirfd 要创建的目录所在的目录的文件描述符
 * @param path 要删除文件路径。如果path是相对路
 * 径，则它是相对于dirfd目录而言的。如果path是相对路
 * 径，且dirfd的值为AT_FDCWD，则它是相对于当前路径而
 * 言的。如果path是绝对路径，则dirfd被忽略。
 * @return 成功返回0，失败返回-1
 */
int rm(int dirfd, char *path);

/**
 * @brief 读取文件
 * @param fd 文件对应的fd
 * @param user dst是否为用户页表中的地址
 * @param buffer 写入的位置
 * @param count 读取字节数
 * @param offset The index where to start reading the file
 * @return a status code
 */
size_t read(int fd, bool user, char *dst, size_t count, size_t offset = 0);

/**
 * @brief 读取文件
 * @param fp 文件指针
 * @param user dst是否为用户页表中的地址
 * @param buffer 写入的位置
 * @param count 读取字节数
 * @param offset The index where to start reading the file
 * @return a status code
 */
size_t
read(struct file *fp, bool user, char *dst, size_t count, size_t offset = 0);

/**
 * @brief 写文件，这个文件可以是设备，磁盘文件，管道等。
 * @param fp 文件指针
 * @param src 需要写入的数据
 * @param n 写入数据的sz
 * @param offset 写入的开始位置
 * @return 成功返回写入字节数，失败返回-1
 */
size_t
write(struct file *fp, bool user, const char *src, size_t n, size_t offset = 0);

/**
 * @brief 写文件，这个文件可以是设备，磁盘文件，管道等。
 * @param fd 文件描述符，用来找到对应的文件
 * @param src 需要写入的数据
 * @param n 写入数据的sz
 * @param offset 写入的开始位置
 * @return 成功返回写入字节数，失败返回-1
 */
size_t write(int fd, bool user, const char *src, size_t n, size_t offset = 0);

/**
 * @brief 列出一个目录下的全部目录项
 * @param fd 目录的文件描述符
 * @param buffer 输出缓存区
 * @param len 缓冲区的大小
 * @param size 缓存区的大小
 * @return 成功返回写入缓存区的字节数，失败返回-1
 */
size_t ls(int fd, char *buffer, int len, bool user);

/**
 * @brief 显示已挂载的设备
 * @param buffer 输出缓存区
 * @param size 缓存区的到校
 * @return 成功返回0，失败返回-1
 */
size_t mounts(char *buffer, size_t size);

/**
 * @brief 挂载一个设备到指定位置
 *
 * @param type 文件系统的类型
 * @param mount_point 挂载的位置
 * @param device 挂载的设备
 * @return 成功返回0，失败返回-1
 */
int mount(FileSystemType type, const char *mountPoint, const char *specialDev);

/**
 * @brief 卸载一个设备
 *
 *
 * @param mpdir 挂载路径
 * @return 成功返回0，失败返回-1
 */
int umount(const char *mpdir);

/**
 * @brief 直接通过path读取一个设备或者文件的数据
 *
 *
 * @param file 文件或者设备的路径
 * @param buffer 输出混缓冲区
 * @param count 读取字节数
 * @param offset 读取的起始点偏移量
 *
 * @return 失败返回-1，成功返回0
 */
size_t
direct_read(const char *file, char *buffer, size_t count, size_t offset = 0);

/**
 * @brief 直接通过path向一个设备或者文件写入数据
 *
 *
 * @param file 文件或者设备的路径
 * @param buffer 输入混缓冲区
 * @param count 写入字节数
 * @param offset 写入的起始点偏移量
 *
 * @return 失败返回-1，成功返回0
 */
size_t direct_write(const char *file,
                    const char *buffer,
                    size_t      count,
                    size_t      offset = 0);

/**
 * @brief 增长文件的ref计数
 */
struct file *dup(struct file *fp);

/**
 * @brief 改变用户当前工作目录
 *
 * @param filepath 相对路径或者绝对路径
 * @return int 成功返回0，失败返回-1
 */
int chdir(char *filepath);

/**
 * @brief 通过相对路径计算绝对路径，若是相对路径
 *        则newpath=oldpath
 *
 * @param oldpath
 * @param newPath
 */
void calAbsolute(char *oldpath);

/**
 * @brief 创建管道
 *
 * @param fds 接收管道的读写文件描述符
 * @return int 成功返回0，失败返回-1
 */
int createPipe(int fds[]);

/**
 * @brief 将fp偏移量置为0
 *
 */
struct file *rewind(struct file *fp);
}  // end of namespace vfs

#endif
