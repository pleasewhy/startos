#ifndef __FAT32_FILE_SYSTEM_HPP
#define __FAT32_FILE_SYSTEM_HPP
#include "fs/fat/fat.hpp"
#include "fs/vfs_file.h"
#include "StartOS.hpp"

namespace fat32 {

const uint_t kSectorSize = 512;

// 该类存放需要用到的Fat32的一些数据
struct Fat32Info
{
  uint32_t     first_data_sector_;
  uint32_t     cluster_count_;
  uint32_t     bytes_per_cluster_;
  uint_t       sectors_per_fat_;
  uint_t       fat_num_;
  uint_t       sectors_per_cluster;
  uint_t       reserve_cluster_;
  struct inode root;
};

class Fat32FileSystem {
public:
  Fat32FileSystem(int dev);
  ~Fat32FileSystem();

  /**
   * @brief 初始化fat32文件系统
   *
   * @return int
   */
  int Init();

  /**
   * @brief 在该文件系统下创建和初始化一个inode
   */
  struct inode *AllocInode();

  /**
   * @brief 释放inode
   */
  void FreeInode(struct inode *inode);

  /**
   * @brief 从inode中读取数据
   * @note 调用者需要持有inode->lock,如果user为true
   * 则buf为用户虚拟地址，否则dst为内核地址
   */
  int ReadInode(
      struct inode *ip, bool user, uint64_t buf, uint64_t off, uint_t n);

private:
  /**
   * @brief 计算文件的簇号在磁盘中的簇号, 若logi_cluster
   * 大于文件的最大簇号 ，则返回-1。
   * @note bmap为比较通用命名，故在这里不遵循
   * google规范
   *
   * @param logi_cluster 相对于文件的簇号
   * @return 成功返回0，失败返回-1
   */
  int bmap(struct inode *ip, uint_t logi_cluster);

  /**
   * @brief 申请使用一个空闲簇
   */
  uint32_t AllocCluster();

  /**
   * @brief 将给定的簇的内容全部置为0
   */
  void ZeroCluster(uint32_t cluster);

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
   * @brief 向fat表的指定cluster写入value
   *
   * @param cluster 需要修改的簇
   * @param value 写入的值
   */
  inline void WriteFat(uint32_t cluster, uint32_t value);

  /**
   * @brief 读取给定cluster在fat表上的内容
   *
   * @param cluster 簇号
   */
  inline uint32_t ReadFat(uint32_t cluster);

  /**
   * @brief 写指定簇
   */
  inline int WriteCluster(uint32_t cluster, char *data);

  /**
   * @brief 读指定簇
   * @note 这会调用FirstSectorOfCluster得到cluster的第一个
   * 扇区，并向后读取k个扇区，k为每簇扇区数。
   */
  inline int ReadCluster(uint32_t cluster, char *data);

  /**
   * @brief 读指定扇区
   */
  int ReadSector(int sector, char *data);

  /**
   * @brief 写指定扇区
   */
  int WriteSector(int sector, char *data);

private:
  FatBpb    fat_bpb_;      // fat32启动扇区
  FatFsInfo fat_fs_info_;  // fat32信息扇区
  int       dev_;          // 挂载设备号
  Fat32Info info_;         // fat32文件系统需要维护的数据
};

/*
 * 用于在内存中存放，Fat32文件系统inode数据
 */
struct MsdosInodeInfo
{
  int          i_start;     // 第一个簇号或0
  int          i_logstart;  // 逻辑簇
  int          i_attrs;     // 属性
  uint64_t     i_pos;       // 目录项在磁盘上的位置或0
  struct inode vfs_inode;
};

static inline struct MsdosInodeInfo *MSDOS_I(struct inode *inode)
{
  return container_of(inode, struct MsdosInodeInfo, vfs_inode);
}

}  // namespace fat32
#endif