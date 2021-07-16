#ifndef __FAT32_FILE_SYSTEM_HPP
#define __FAT32_FILE_SYSTEM_HPP
#include "fs/fat/fat.hpp"
#include "fs/vfs_file.h"
#include "fs/vfs/file_system.hpp"
#include "map.hpp"
#include "StartOS.hpp"

namespace vfs {
namespace fat32 {

  const uint8_t  kMsdosRootIno = 1; /* == MINIX_ROOT_INO */
  const uint16_t kMaxSzOfName = 30;
  // 该类存放需要用到的Fat32的一些数据
  struct Fat32Info
  {
    uint32_t              first_data_sector_;
    uint32_t              cluster_count_;
    uint16_t              bytes_per_cluster_;
    uint16_t              bytes_per_sector_;
    uint16_t              sectors_per_fat_;
    uint8_t               fat_num_;
    uint_t                sectors_per_cluster;
    uint16_t              reserve_sectors_;
    struct MsdosInodeInfo root_;
  };

  class Fat32FileSystem : public FileSystem0 {
  public:
    Fat32FileSystem(int dev);
    ~Fat32FileSystem();

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

    /**
     * @brief 输出当前文件系统的全部inode
     * 命令行输入~,会调用该函数
     */
    void DebugInfo() override;

    // /**
    //  * @brief 删除一个空目录，该方法被系统调用rmdir调用
    //  *
    //  * @return int 成功返回0, 失败返回-1
    //  */
    // int Rmdir();

  private:
    /**
     * @brief 初始化fat32文件系统
     *
     * @return int
     */
    int Init();
    /**
     * @brief 计算文件的簇号在磁盘中的簇号, 若logi_cluster
     * 大于文件的最大簇号 ，则返回-1。
     *
     * @note 若logi_cluster大于inode的sz，则会申请相应的对应的
     * 簇。但是这里只有WriteInode函数会触发，ReadInode函数不会
     * 触发，它保证在读数据时不会超过文件内容的长度。
     *
     *
     * @note bmap为比较通用命名，故在这里不遵循
     * google规范
     *
     * @param logi_cluster 相对于文件的簇号
     * @return 成功返回0，失败返回-1
     */
    int bmap(struct inode *ip, uint_t logi_cluster);

    /**
     * @brief 获取一个inode
     * @note 它会做下面三件事
     * 1、它会在inode_cache_map_查找有没有对应的inode，
     * 如果有就直接返回对应inode。
     * 2、若果没有对应inode且缓存数量未达上限，则创建
     * 一个对应inode
     * 3、如果inode达到上限且存在ref为0的inode，则使用
     * LRU策略驱逐一个inode供当前inode使用
     * 4、如果上述条件均不满足，则panic。
     *
     * @param pos 目录项在磁盘中的字节偏移量
     * @return struct inode* pos对应的inode
     */
    struct inode *GetInode(uint64_t pos);

    /**
     * @brief 找到给定目录下可容纳n个连续的
     * 目录项的空闲空间
     *
     * @return 这块空间的起始地址
     */
    uint64_t FindFreeEntry(struct inode *dir, int n);

    /**
     * @brief 获取一个entry相关的inode，并初始化
     * 部分数据字段
     *
     * @param entry
     * @param pos
     * @return struct inode*
     */
    struct inode *BuildInode(MsdosEntry &entry, uint64_t pos, struct inode *ip);

    /**
     * @brief 申请使用一个空闲簇
     */
    uint32_t AllocCluster();

    /**
     * @brief 将给定的簇的内容全部置为0
     */
    void ZeroCluster(uint32_t cluster);

    /**
     * @brief 获取cluster在fat表中对应的表项相所属的扇区
     * @note 可以将fat表看做是一个很大的uint32数组，cluster是其
     * 下标，则offset = cluster * sizeof(uint32)。可以通过该
     *  offset得到cluster对应的fat表项所属扇区号和扇区中的偏移量
     *
     * @param cluster 簇号
     * @return uint32_t 扇区号
     */
    inline uint32_t FatSectorOfCluster(uint32_t cluster);

    /**
     * @brief 获取cluster在所属扇区的偏移量，通常和
     * FatSectorOfCluster方法一起使用。
     *
     * @param cluster 簇号
     * @return uint32_t 相对于扇区的偏移量
     */
    inline uint32_t FatOffsetOfCluster(uint32_t cluster);

    /**
     * @brief 计算给定簇的第一个扇区号
     * @note 簇号从2开始，0、1号簇具用特殊作用，没有与其对应的
     * 数据簇
     *
     * @param cluster 簇号
     * @return uint32_t 给定簇的第一个扇区号
     */
    inline uint32_t FirstSectorOfCluster(uint32_t cluster);

    /**
     * @brief 向fat表的指定cluster写入value，cluster不能
     * 大于中簇数
     *
     * @param cluster 需要修改的簇
     * @param value 写入的值
     * @return 成功返回0，失败返回一个负数
     */
    inline int SetFatEntey(uint32_t cluster, uint32_t value);

    /**
     * @brief 读取给定cluster在fat表上的内容
     *
     * @param cluster 簇号
     */
    inline uint32_t GetFatEntry(uint32_t cluster);

    /**
     * @brief 释放cluster链
     *
     * @param cluster cluster链的起点
     */
    inline void FreeClusterChain(uint32_t cluster);
    /**
     * @brief 将off之前或之后的连续|n|个目录项
     * 在磁盘中标记为已删除，往前或往后取决于n为
     * 正数还是负数。
     *
     * @param off 标记删除的基准偏移量
     * @param n 正数向前删除，负数向后删除
     */
    void MarkEntryDeleted(struct inode *ip, uint32_t off, int n) noexcept;

    /**
     * @brief 写指定簇
     */
    inline int WriteCluster(uint32_t cluster, bool user, uint64_t buf, int n);

    /**
     * @brief 读指定簇
     * @note 这会调用FirstSectorOfCluster得到cluster的第一个
     * 扇区，并向后读取k个扇区，k为每簇扇区数。
     */
    inline int ReadCluster(uint32_t cluster, bool user, uint64_t buf, int n);

    /**
     * @brief 读指定扇区
     */
    int ReadSector(int sector, char *data);

    /**
     * @brief 写指定扇区
     */
    int WriteSector(int sector, char *data);

  public:
    Fat32Info info_;  // fat32文件系统需要维护的数据

  private:
    FatBpb    fat_bpb_;        // fat32启动扇区
    FatFsInfo fat_fs_info_;    // fat32信息扇区
    int       dev_;            // 挂载设备号
    int       max_inode_num_;  // inode缓存最大数量
    std::map<uint64_t, struct inode *> *inode_cache_map_;
  };

}  // namespace fat32
}  // namespace vfs
#endif