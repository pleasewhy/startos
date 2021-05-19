#ifndef VFS_HPP
#define VFS_HPP

#include "FileSystem.hpp"
#include "StartOS.hpp"
#include "types.hpp"

#define NFILESYSTEM 5
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
 * @param path 要创建的目录的名称。如果path是相对路
 * 径，则它是相对于dirfd目录而言的。如果path是相对路
 * 径，且dirfd的值为AT_FDCWD，则它是相对于当前路径而
 * 言的。如果path是绝对路径，则dirfd被忽略。
 * @return 成功返回0，失败返回-1
 */
int mkdirat(int dirfd, const char *path);

/**
 * @brief 删除文件
 * @param file 需要删除文件的路径
 * @return a status code
 */
void rm(const char *file);

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
 * @brief 写文件，这个文件可以是设备，磁盘文件，管道等。
 * @param fd 文件描述符，用来找到对应的文件
 * @param src 需要写入的数据
 * @param n 写入数据的sz
 * @param offset 写入的开始位置
 * @return 成功返回写入字节数，失败返回-1
 */
size_t write(int fd, bool user, const char *src, size_t n, size_t offset = 0);

/**
 * @brief Clear parts of a file content
 * @param fd The file descriptor to the file
 * @param count The number of bytes to write
 * @param offset The index where to start writting the file
 * @return a status code
 */
size_t clear(int fd, size_t count, size_t offset = 0);

/**
 * @brief Truncate the size of a file
 * @param fd The file descriptor
 * @param size The new size
 * @return a status code
 */
void truncate(int fd, size_t size);

/**
 * @brief List entries in the given directory
 * @param fd The file descriptor
 * @param buffer The buffer to fill with the entries
 * @param size The maximum size of the buffer
 * @return a status code
 */
size_t ls(int fd, char *buffer, bool user);

/**
 * @brief List mounted file systems.
 * @param buffer The buffer to fill with the entries
 * @param size The maximum size of the buffer
 * @return a status code
 */
size_t mounts(char *buffer, size_t size);

/**
 * @brief Mount a new partition
 * @param type The type of partition
 * @param mp_fd Mount point file descriptor
 * @param dev_fd Device file descriptor
 * @return a status code
 */
// void mount(partition_type type, int mp_fd, int dev_fd);

/**
 * @brief Mount a new partition
 *
 * This function is intended for direct mount from the OS code.
 *
 * @param type The type of partition
 * @param mount_point Mount point path
 * @param device Device path
 * @return a status code
 */
void mount(FileSystemType type, const char *mountPoint, const char *device);

/**
 * @brief Directly read a file or a device
 *
 * This is meant to be used by file system drivers.
 *
 * @param file Path to the file (or device)
 * @param buffer The output buffer
 * @param count The number of bytes to read
 * @param offset The offset where to start reading
 *
 * @return An error code if something went wrong, 0 otherwise
 */
size_t direct_read(const char *file, char *buffer, size_t count, size_t offset = 0);

/**
 * @brief Directly write a file or a device
 *
 * This is meant to be used by file system drivers.
 *
 * @param file Path to the file (or device)
 * @param buffer The input buffer
 * @param count The number of bytes to write
 * @param offset The offset where to start writing
 *
 * @return An error code if something went wrong, 0 otherwise
 */
size_t direct_write(const char *file, const char *buffer, size_t count, size_t offset = 0);

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
}  // end of namespace vfs

#endif
