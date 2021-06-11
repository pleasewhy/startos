#include "fs/fat/fat.hpp"
#include "common/printk.hpp"
#include "device/DeviceManager.hpp"
#include "common/string.hpp"
#include "common/logger.h"
#include "fs/fat/fat32_file_system.hpp"
#include "file.h"
#include "memory/VmManager.hpp"
#include "os/TaskScheduler.hpp"
#include "fcntl.h"

namespace fat32 {
__attribute__((used)) static void PrintBootSectorInfo(FatBpb *bpb)
{
  printf("================= BIOS PARAMETER BLOCK =================\n");
  printf("   Boot Instruction: %x%x%x\n", bpb->jump[0], bpb->jump[1],
         bpb->jump[2]);
  printf("           OEM Name: '%s'\n", bpb->oem_name);
  printf("   Bytes per Sector: %d\n", bpb->bytes_per_sector);
  printf("Sectors per Cluster: %d\n", bpb->sectors_per_cluster);
  printf("   Reserved Sectors: %d\n", bpb->reserved_sectors);
  printf("               FATS: %d\n", bpb->number_of_fat);
  printf("      Fat Size (16): %d\n", bpb->sectors_per_fat);
  printf("  Sectors per Track: %d\n", bpb->sectors_per_track);
  printf("    Number of Heads: %d\n", bpb->track_heads);
  printf("     Hidden Sectors: %d\n", bpb->hidden_sectors);
  printf(" Total Sectors (16): %d\n", bpb->total_sectors);
  printf(" Total Sectors (32): %d\n", bpb->total_sectors_long);

  printf("     FAT Size (32b): %d\n", bpb->sectors_per_fat_v32);
  printf("         FS Version: %x\n", bpb->version);
  printf("       Root Cluster: %d\n", bpb->root_directory_cluster_start);
  printf("      FSINFO Sector: %d\n", bpb->fs_information_sector);
  printf("Bkup BootRec Sector: %d\n", bpb->boot_sectors_copy_sector);
  printf("       Drive Number: %d\n", bpb->physical_drive_number);
  printf("     Boot Signature: %x\n", bpb->extended_boot_signature);
  printf("          Volume ID: %x\n", bpb->volume_id);
  printf("       Volume Label: '%s'\n", bpb->volume_label);
  printf("     FileSystemType: '%s'\n", bpb->file_system_type);

  printf("\n");
}

__attribute__((used)) static void PrintFsInfo(FatFsInfo *info)
{
  printf("================= FAT32 FS INFO =================\n");
  printf("   First Signature: %p\n", info->signature_start);
  printf("  Second Signature:%p\n", info->signature_middle);
  printf("   Third Signature: %p\n", info->signature_end);
  printf("     Free Clusters: %d\n", info->free_clusters);
  printf("Allocated Clusters: %d\n", info->allocated_clusters);
  printf("\n");
}

Fat32FileSystem::Fat32FileSystem(int dev) : dev_(dev)
{
  this->Init();
}

Fat32FileSystem::~Fat32FileSystem() {}

int Fat32FileSystem::Init()
{
  memset((char *)&this->fat_fs_info_, 0, 512);
  memset((char *)&this->fat_bpb_, 0, 512);
  dev::RwDevRead(this->dev_, (char *)&this->fat_bpb_, 0, sizeof(fat_bpb_));
  dev::RwDevRead(this->dev_, (char *)&this->fat_fs_info_,
                 this->fat_bpb_.fs_information_sector, sizeof(fat_fs_info_));
#ifdef LOG_DEBUG_ENABLED
  PrintBootSectorInfo(&this->fat_bpb_);
  PrintFsInfo(&this->fat_fs_info_);
#endif

  info_.bytes_per_cluster_ =
      fat_bpb_.bytes_per_sector * fat_bpb_.sectors_per_cluster;

  info_.cluster_count_ =
      fat_bpb_.total_sectors_long / fat_bpb_.sectors_per_cluster;

  info_.first_data_sector_ =
      fat_bpb_.reserved_sectors +
      fat_bpb_.number_of_fat * fat_bpb_.sectors_per_fat_v32;

  info_.fat_num_ = fat_bpb_.number_of_fat;
  info_.sectors_per_fat_ =
      fat_bpb_.sectors_per_fat_v32 * fat_bpb_.bytes_per_sector;
  info_.sectors_per_cluster = fat_bpb_.sectors_per_cluster;
  info_.reserve_cluster_ = fat_bpb_.reserved_sectors;

  info_.root.inum = fat_bpb_.root_directory_cluster_start;
  info_.root.ref++;
  info_.root.mode |= __S_IFDIR;

  uint32_t cluster = AllocCluster();
  printf("cluster=%d\n", cluster);
  return 0;
}

struct inode *Fat32FileSystem::AllocInode()
{
  MsdosInodeInfo *ms_inode = new MsdosInodeInfo();
  if (ms_inode == nullptr) {
    return nullptr;
  }
  ms_inode->i_start = 0;
  ms_inode->i_pos = 0;
  ms_inode->i_logstart = 0;
  ms_inode->i_attrs = 0;

  return &ms_inode->vfs_inode;
}

/**
 * @brief 释放inode
 */
void Fat32FileSystem::FreeInode(struct inode *inode)
{
  delete MSDOS_I(inode);
}

inline uint32_t Fat32FileSystem::FirstSectorOfCluster(uint32_t cluster)
{
  return info_.first_data_sector_ + (cluster - 2) * info_.sectors_per_cluster;
}

int Fat32FileSystem::bmap(struct inode *ip, uint_t logi_cluster)
{
  MsdosInodeInfo *msdos_info = MSDOS_I(ip);

  uint32_t cur = msdos_info->i_start;
  size_t   i;
  for (i = 1; i <= logi_cluster && cur != kEndOfCluster32; i++) {
    cur = ReadFat(cur);
  }
  if (cur == kEndOfCluster32) {
    return -1;
  }
  return cur;
}

void Fat32FileSystem::ZeroCluster(uint32_t cluster)
{
  char *data = new char[kSectorSize];
  memset(data, 0, kSectorSize);
  for (size_t i = 0; i < info_.sectors_per_cluster; i++) {
    WriteSector(FirstSectorOfCluster(cluster) + i, data);
  }
}

uint32_t Fat32FileSystem::AllocCluster()
{
  char *data = new char[kSectorSize];

  // 遍历全部fat表，获取一个空闲的cluster
  // TODO 是否可以将fat表全部缓存到内存中？
  LOG_DEBUG("%d", info_.fat_num_ * info_.sectors_per_fat_);
  uint_t enteies_of_sector = kSectorSize / kFatEntryBytes;
  for (size_t sector = info_.reserve_cluster_;
       sector < info_.fat_num_ * info_.sectors_per_fat_; sector++) {
    ReadSector(sector, data);
    for (size_t i = 0; i < enteies_of_sector; i++) {
      if (reinterpret_cast<uint32_t *>(data)[i] == 0x00) {
        reinterpret_cast<uint32_t *>(data)[i] = kEndOfCluster32;
        WriteSector(sector, data);
        uint32_t cluster = enteies_of_sector * sector + i;
        ZeroCluster(cluster);
        return cluster;
      }
    }
  }
  panic("alloc cluster");
  return 0;
}

// 需要持有锁
int Fat32FileSystem::ReadInode(
    struct inode *ip, bool user, uint64_t buf, uint64_t offset, uint_t n)
{
  MsdosInodeInfo *msdos_info = MSDOS_I(ip);

  if (offset > ip->sz || offset + n < offset)
    return 0;
  if (offset + n > ip->sz)
    n = ip->sz - offset;

  uint_t readn, total, mod;
  char * data = new char[info_.bytes_per_cluster_];
  for (total = 0; total < n; total += readn, buf += readn) {
    ReadCluster(bmap(ip, (offset / info_.cluster_count_)), data);
    mod = offset % info_.bytes_per_cluster_;
    readn = min(n - total, info_.bytes_per_cluster_ - mod);
    if (either_copyout(user, buf, data + mod, readn)) {
      total = -1;
      break;
    }
  }
  return total;
}

inline void WriteFat(uint32_t cluster, uint32_t value);

inline uint32_t ReadFat(uint32_t cluster){
  
}

inline int Fat32FileSystem::WriteCluster(uint32_t cluster, char *data)
{
  for (size_t i = 0; i < info_.sectors_per_cluster; i++) {
    WriteSector(FirstSectorOfCluster(cluster) + i, data + kSectorSize * i);
  }
  return 0;
};

inline int Fat32FileSystem::ReadCluster(uint32_t cluster, char *data)
{
  for (size_t i = 0; i < info_.sectors_per_cluster; i++) {
    ReadSector(FirstSectorOfCluster(cluster) + i, data + kSectorSize);
  }
  return 0;
};

/**
 * @brief 读指定扇区
 */
int Fat32FileSystem::ReadSector(int sector, char *data)
{
  return dev::RwDevRead(this->dev_, data,
                        sector * this->fat_bpb_.bytes_per_sector,
                        this->fat_bpb_.bytes_per_sector);
}

/**
 * @brief 写指定扇区
 */
int Fat32FileSystem::WriteSector(int sector, char *data)
{
  return dev::RwDevWrite(this->dev_, data,
                         sector * this->fat_bpb_.bytes_per_sector,
                         this->fat_bpb_.bytes_per_sector);
}

}  // namespace fat32