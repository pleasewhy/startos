#ifndef NEW_DEVICE_SYSTEM_HPP
#define NEW_DEVICE_SYSTEM_HPP

#include "fs/vfs/file_system.hpp"
#include "list.hpp"

namespace vfs {
namespace devfs {
  /*
   * 用于在内存中存放，Fat32文件系统inode数据
   */
  struct DevInodeInfo
  {
    std::list<DevInodeInfo *> *children_list;
    struct inode               vfs_inode;
    DevInodeInfo()
    {
      children_list = new std::list<DevInodeInfo *>();
    }
    DevInodeInfo()
    {
      children_list = new std::list<DevInodeInfo *>();
    }
  };

  static inline struct DevInodeInfo *MSDOS_I(struct inode *inode)
  {
    return container_of(inode, struct DevInodeInfo, vfs_inode);
  }

  class DeviceFileSystem : public FileSystem0 {
  public:
    DeviceFileSystem(int dev);
    ~DeviceFileSystem();

    /**
     * @brief 在该文件系统下创建和初始化一个inode
     */
    struct inode *AllocInode() override;

    /**
     * @brief 获取Root inode
     *
     */
    struct inode *GetRootInode() override;

    /**
     * @brief 在给定目录下创建一个新的文件
     */
    int Create(struct inode *dir, const char *name, int mode);

    /**
     * @brief 在最后一个指向inode的引用被释放后，
     * 会调用该函数，它只是简单的将释放inode所占
     * 用的内存。
     */
    void DeleteInode(struct inode *inode);

    /**
     * @brief 更新inode的元数据
     * @note 在fat32中更新的是对应短文件目录项的
     * 数据即可，MsdosInodeInfo记录着短文件目录
     * 项在磁盘中的偏移量，故可以很方便的进行更新。
     *
     * @return int
     */
    int UpdateInode(struct inode *ip);

    /**
     * @brief 从inode中读取数据
     * @note 调用者需要持有inode->lock,如果user为true
     * 则buf为用户虚拟地址，否则dst为内核地址
     *
     * @param user 用于判断buf是否为用户空间地址
     * @param buf 读取数据缓存区
     *
     */
    int ReadInode(
        struct inode *ip, bool user, uint64_t buf, uint64_t off, uint_t n);

    /**
     * @brief 向inode写入数据
     * @note 调用者需要持有inode->lock,如果user为true
     * 则buf为用户虚拟地址，否则dst为内核地址
     * @return 成功返回0，失败返回-1
     */
    int WriteInode(
        struct inode *ip, bool user, uint64_t buf, uint64_t off, uint_t n);

    /**
     * @brief 在dir目录下查找name目录项
     * @note 需要创建对应的inode
     *
     * @return 返回dir目录项相应的目录项
     *
     */
    struct inode *Lookup(struct inode *dir, const char *name);

    /**
     * @brief 读取目录文件内容,调用者需要只有inode->lock
     * @note 这个方法主要是用于getdents系统调用,
     * 它以Fat32中目录项的定义，遍历每一个目录项，
     * 并提供目录项的name和type，并将其复制到相应
     * 的输出缓冲区中。
     *
     * @param fp 目录文件，主要使用其pos字段
     * @param ip 目录对应的inode
     * @param buf linux_dirent缓冲区
     * @param max_len linux_dirent长度(byte)
     * @param user 判断buf是否为用户地址
     *
     * @return int 成功返回0，失败返回负数
     */
    int ReadDir(
        struct file *fp, struct inode *ip, char *buf, int max_len, bool user);

    /**
     * @brief 在dir目录下创建一个新的目录，该方法为系统调用
     * mkdir的底层实现
     *
     * @param dir 给定的目录
     * @param name 创建目录的名称
     * @param mode 该目录的文件类型和访问权限
     * @return int 成功返回0.失败返回-1
     *
     */
    int Mkdir(struct inode *dir, const char *name, int mode);

    /**
     * @brief 删除dir目录下name对应的目录项, 并递减对应
     * 索引节点的nlink。
     *
     * @note Fat文件系统中不存在inode这一结构，该调用对于
     * 普通文件直接删除，对于目录，若为空则删除，不为空则
     * 失败
     *
     * @exception 文件不存在，name对应的文件为非空目录
     * @return 失败返回-1，成功返回0
     */
    int Unlink(struct inode *dir, const char *name);

  private:
    struct DevInodeInfo *root_;
    // struct
  };
}  // namespace devfs
}  // namespace vfs
#endif