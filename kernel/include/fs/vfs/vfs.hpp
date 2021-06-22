#ifndef VFS_HPP
#define VFS_HPP

#include "fs/vfs/file_system.hpp"
#include "StartOS.hpp"
#include "file.h"
#include "types.hpp"

/**
 * 这个文件定义了虚拟文件系统对外提供的接口,
 * 有以下几个点需要注意一下:
 * 1、内核主要通过struct inode指针操作文件,而
 * 用户程序主要是通过struct file指针操作文件。
 * 2、为了降低vfs的复杂性，在vfs的实现中不会涉
 * 及到文件描述符，即所有的操作只能通过inode或
 * file进行。
 * 3、所有接口都要求struct file指针和struct inode指针
 * 都不能为空。
 * 4、返回值都遵循这样的约定：
 *    int: 成功返回0，失败返回负数，用来表明
 *         错误类型。
 *    指针:成功返回有效指针，失败返回nullptr，
 *        但是不会表明错误。
 *    后续可能会采用更好的异常处理方式
 */

namespace vfs {

const uint8_t kMaxFileName = 20;
const uint8_t kMountPointNumber = 5;

// 维护挂载点数据
struct MountPoint
{
  char        mp_path[MAXPATH];      // 挂载点绝对路径
  char        device_path[MAXPATH];  // 挂载设备(or文件)绝对路径
  int         dev;                   // 挂载设备号
  FileSystem0 *fs;                    // 挂载的文件系统实例
};

/**
 * @brief 目前已支持文件系统的类型
 */
enum class FileSystemType {
  FAT32 = 1,     ///< FAT32
  SYSFS = 2,     ///< Sysfs
  DEVFS = 3,     ///< Devfs
  PROCFS = 4,    ///< Procfs
  UNKNOWN = 100  ///< Unknown file system
};

// 静态类
class VfsManager {
public:
  /**
   * @brief 初始化虚拟文件系统
   * 这会初始化一些虚拟文件系统需要用到的一些数据，并且挂载
   * 一些文件系统
   */
  static void Init();

  /**
   * @brief 更新文件的偏移量，系统调用lleek调用它
   *
   * @param fp 文件指针
   * @param new_off 移动距离
   * @return uint32_t
   */
  static uint32_t llseek(struct file *fp, uint32_t new_off);

  /**
   * @brief 打开指定目录下的文件
   *
   * @note filepath为要打开文件路径。如果filepath是相对路
   * 径，则它是相对于dirfd目录而言的。如果filepath是相对路
   * 径，且filepath的值为AT_FDCWD，则它是相对于当前路径而
   * 言的。如果filepath是绝对路径，则dirfd被忽略。
   *      与此类似的函数为mkdirat等所有以at结尾的函数。
   *
   * @param dir 文件所属目录，AT_FDCWD代表进程当前目录
   * @param filepath 文件路径，可为相对路径或绝对路径
   * @param flags 文件标志位，如RDONLY
   * @param mode 只在创建的时候有用，用于给文件设置权限，或创建文件的类型
   * @return 成功返回struct file指针，失败返回nullptr
   */
  static struct file *
  openat(struct file *dir, const char *filepath, size_t flags, mode_t mode);

  /**
   * @brief 关闭文件，系统调用close会调用该函数
   */
  static void close(struct file *fp);

  /**
   * @brief 创建目录
   * @note see vfs::openat()
   *
   * @param dir 文件所属目录，AT_FDCWD代表进程当前目录
   * @param filepath 目录的路径可为相对路径或者绝对路径
   * @return 成功返回0，失败返回-1
   */
  static int mkdirat(struct file *dir, const char *filepath);

  /**
   * @brief 读取文件数据
   *
   * @param fp 需要读取数据的文件指针
   * @param buf 储存数据的缓存区
   * @param n 读取字节数
   * @return int 读取字节数
   */
  static int read(struct file *fp, char *buf, int n, bool);

  /**
   * @brief 向文件写入数据
   *
   * @param fp 需要写入数据的文件指针
   * @param buf 数据缓存区
   * @param n 期望写入的字节数
   * @return int 实际写入的字节数
   */
  static int write(struct file *fp, const char *buf, int n);

  /**
   * @brief 将source路径中包含的文件系统(通常为设备，也可以是文件)
   * 挂载到target路径(目录或者文件).
   *
   *
   * @note source目前支持设备 // TODO(2021/6/20) fix me!
   *
   * @param source 文件路径
   * @param target 文件路径
   * @param type source中包含的文件系统类型
   * @return int 成功返回0，失败返回一个负数
   */
  static int Mount(const char *source, const char *target, FileSystemType type);

private:
  /**
   * @brief 挂载"/"目录，该函数只会被VfsManager::Init()调用
   */
  static void MountRoot();

  /**
   * @brief 挂载"/dev"目录，该函数只会被VfsManager::Init()调用
   */
  static void MountDev();

  static MountPoint *March(const char *source);

  /**
   * @brief 获取下一个路径元素，并将其复制 到%name中
   * 返回一个指向剩下元素的指针。
   * @note 返回的路径不以'/'开始，所以调用者必须要检查*path=='\0'
   * 来判断%name是否为最后一个元素。
   * @note 如果没有元素获取，则直接返回0
   *
   * Example:
   *    skipelem("a/bb/c", name) = "bb/c", setting name = "a"
   *    skipelem("///a//bb", name) = "bb", setting name = "a"
   *    skipelem("a", name) = "", setting name = "a"
   *    skipelem("", name) = skipelem("////", name) = 0
   */
  static char *SkipElememt(char *path, char *name);

  /**
   * @brief 获取%path路径下%name对应的文件的inode
   *
   *
   * @param fs 文件所属文件系统
   * @param dir_path 父目录的路径
   * @param nameiparent if nameiparent==true，则返回path对应的文件的inode,
   * 并且将path的最后一个元素复制到name中
   * @param name 文件名指针，根据nameiparent的取值有不同的含义。
   * @return struct inode*
   */
  static struct inode *
  namex(FileSystem0 *fs, char *path, bool nameiparent, char *name);

  static struct inode *namei();

private:
  static SleepLock  vfs_sleeplock_;
  static MountPoint mount_points_[kMountPointNumber];
};

static inline FileSystem0 *createFileSystem(FileSystemType type, int dev)
{
  switch (type) {
    // case FileSystemType::DEVFS:
    // return new DeviceFileSystem(mountPoint, specialDev);
    case FileSystemType::FAT32: return new fat32::Fat32FileSystem(dev);
    default: panic("create file system"); break;
  }
  return nullptr;
}

}  // end of namespace vfs

#endif
