#include "fs/fat/fat.hpp"
#include "common/printk.hpp"
#include "device/DeviceManager.hpp"
#include "common/string.hpp"
#include "common/logger.h"
#include "fs/fat/fat32_file_system.hpp"
#include "file.h"
#include "os/TaskScheduler.hpp"
#include "map.hpp"
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
  printf("   Second Signature:%p\n", info->signature_middle);
  printf("   Third Signature: %p\n", info->signature_end);
  printf("     Free Clusters: %d\n", info->free_clusters);
  printf("Allocated Clusters: %d\n", info->allocated_clusters);
  printf("\n");
}

Fat32FileSystem::Fat32FileSystem(int dev) : dev_(dev)
{
  // 创建一个长度为32=2^5的hash表
  inode_cache_map_ = new std::map<uint64_t, struct inode *>(5);
  max_inode_num_ = 1 << 5;
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
#ifdef LOG_TRACE_ENABLE
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
  info_.reserve_sectors_ = fat_bpb_.reserved_sectors;
  info_.bytes_per_sector_ = fat_bpb_.bytes_per_sector;

  info_.root_.i_start = fat_bpb_.root_directory_cluster_start;
  info_.root_.i_pos =
      FirstSectorOfCluster(info_.root_.i_start) * fat_bpb_.bytes_per_sector;

  info_.root_.vfs_inode.mode |= __S_IFDIR;
  info_.root_.vfs_inode.nlink++;
  info_.root_.vfs_inode.inum = kMsdosRootIno;
  info_.root_.vfs_inode.sleeplock.init("fat32 root");

  LOG_DEBUG("first data sector=%d", info_.first_data_sector_);
  char        buf[512];
  int         i = 0;
  MsdosEntry *entry = (MsdosEntry *)buf;
  while (true) {
    memset(buf, 0, 512);
    ReadInode(&info_.root_.vfs_inode, false, (uint64_t)buf,
              i * sizeof(MsdosEntry), sizeof(MsdosEntry));
    if (entry->sfn.name[0] == 0) {
      printf("null\n");
      break;
    }
    if (entry->sfn.attrib != kFatAttrLongEntry) {
      printf("attr=%p short name=%s\n", entry->sfn.attrib, entry->sfn.name);
    }
    ++i;
  }
  struct file f;
  f.inode = &info_.root_.vfs_inode;
  f.offset = 0;
  linux_dirent *de = (linux_dirent *)buf;
  memset(buf, 0, 512);
  ReadDir(&f, f.inode, buf, 512, false);
  while (de->d_reclen != 0) {
    LOG_DEBUG("dirent=%s", de->d_name);
    de = (linux_dirent *)(de->d_off);
  }
  struct inode *ip = Lookup(&info_.root_.vfs_inode, "cat");
  printf("seconds=%d\n", ip->mtime);
  ip = Lookup(&info_.root_.vfs_inode, "bin");
  printf("seconds=%d\n", ip->ctime);
  LOG_DEBUG("lookup sz=%d", ip->sz);
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

static void FillShortFile(ShortEntry *entry, const char *name, int mode) {
  return;
}

/**
 * @brief 找到给定目录下可容纳n个连续的
 * 目录项的空闲空间
 * 
 * @return 这块空间的起始地址
 */
static uint64_t FindFreeEntry(int n){
  
}

int Fat32FileSystem::Create(struct inode *dir, const char *name, int mode)
{
  char *     data = new char[info_.bytes_per_cluster_];
  LongEntry  long_entry;
  ShortEntry short_entry;
  memset(&long_entry, 0, sizeof(long_entry));
  memset(&short_entry, 0, sizeof(short_entry));
  time::timespec now_ts;
  time::CurrentTimeSpec(&now_ts);
  int name_len = strlen(name);
  // (a+b-1)/b: a/b向上取整
  int lfn_num = (name_len + kLongNameLength - 1) / kLongNameLength;
  if (S_ISDIR(mode)) {
    short_entry.attrib |= __S_IFDIR;
  }
  else {
    short_entry.attrib |= __S_IFREG;
  }
  UnixTime2Fat(&now_ts, &short_entry.creation_date, &short_entry.creation_time);
  // 短文件目录项没有访问时间，故这里使用creation_time
  UnixTime2Fat(&now_ts, &short_entry.accessed_date, &short_entry.creation_time);
  UnixTime2Fat(&now_ts, &short_entry.modification_date,
               &short_entry.modification_time);
  return 0;
}

struct inode *Fat32FileSystem::GetInode(uint64_t pos)
{
  struct inode *ip = nullptr;
  LOG_DEBUG("%p", ip);
  ip = inode_cache_map_->get(pos);
  LOG_DEBUG("%p", ip);
  if (ip != nullptr) {
    return ip->dup();
  }
  return nullptr;
  // TODO(2021/6/15) 但是现在不想写LRU.

  // if (inode_cache_map_->size() < max_inode_num_) {
  //   ip = AllocInode();
  //   inode_cache_map_->put(pos, ip);
  //   return ip->dup();
  // }
  // auto iter = inode_cache_map_->begin();
  // while (iter != nullptr && iter->val->ref == 0) {
  //   iter++;
  // }
  // if (iter != nullptr) {
  //   ip = iter->val;
  // }
  // return nullptr;
}

struct inode *Fat32FileSystem::BuildInode(MsdosEntry &  entry,
                                          uint64_t      pos,
                                          struct inode *parent)
{
  LOG_DEBUG("build inode");
  struct inode *ip = GetInode(pos);
  if (ip != nullptr)
    return ip;
  ip = AllocInode();
  inode_cache_map_->put(pos, ip);
  MsdosInodeInfo *inode_info = MSDOS_I(ip);

  // 填充对应MsdosInodeInfo数据
  inode_info->i_pos = pos;
  inode_info->i_start = GetFirstCluster(entry);
  // 填充inode数据
  ip->dev = this->dev_;
  ip->inum = GetFirstCluster(entry);
  ip->parent = parent->dup();
  ip->sz = entry.sfn.file_size;
  ip->sleeplock.init("inode");
  ip->nlink = 0;
  FatTime2Unix(&ip->ctime, entry.sfn.creation_date, entry.sfn.creation_time);
  FatTime2Unix(&ip->atime, entry.sfn.accessed_date, 0);
  FatTime2Unix(&ip->mtime, entry.sfn.modification_date,
               entry.sfn.modification_time);
  // ip->file_system = this;
  // 目录项类型
  if (entry.sfn.attrib & kFatAttrDirentory) {
    ip->mode |= __S_IFDIR;
  }
  else
    ip->mode |= __S_IFREG;
  return ip;
}

void Fat32FileSystem::DeleteInode(struct inode *inode)
{
  // inode->free();
  delete MSDOS_I(inode);
}

uint32_t Fat32FileSystem::AllocCluster()
{
  char *data = new char[kSectorSize];
  // 遍历全部fat表，获取一个空闲的cluster
  // TODO 是否可以将fat表全部缓存到内存中？
  LOG_DEBUG("%d", info_.fat_num_ * info_.sectors_per_fat_);
  uint_t enteies_of_sector = kSectorSize / kFatEntryBytes;
  for (size_t sector = info_.reserve_sectors_;
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
  // MsdosInodeInfo *msdos_info = MSDOS_I(ip);

  if (offset > ip->sz || offset + n < offset)
    return 0;
  if (offset + n > ip->sz)
    n = ip->sz - offset;

  uint_t nread, total, mod;
  char * data = new char[info_.bytes_per_cluster_];
  for (total = 0; total < n; total += nread, buf += nread) {
    ReadCluster(bmap(ip, (offset / info_.bytes_per_cluster_)), data);

    mod = offset % info_.bytes_per_cluster_;
    nread = min(n - total, info_.bytes_per_cluster_ - mod);
    if (either_copyout(user, buf, data + mod, nread) < 0) {
      total = -1;
      break;
    }
  }
  return total;
}

int Fat32FileSystem::UpdateInode(struct inode *ip)
{
  ShortEntry entry;
  entry.file_size = ip->sz;
  int   sector = MSDOS_I(ip)->i_pos / info_.bytes_per_sector_;
  int   off = MSDOS_I(ip)->i_pos / info_.bytes_per_sector_;
  char *data = new char[info_.bytes_per_sector_];
  ReadSector(sector, data);
  memmove(data + off, &entry, sizeof(entry));
  return 0;
}

int Fat32FileSystem::WriteInode(
    struct inode *ip, bool user, uint64_t buf, uint64_t off, uint_t n)
{
  size_t total, nwrite, mod;
  if (off > ip->sz || off + n < off) {
    return -1;
  }
  char *data = new char[info_.bytes_per_cluster_];
  for (total = 0, nwrite = 0; total < n;
       total += nwrite, off += nwrite, buf += nwrite) {
    ReadCluster(bmap(ip, (off / info_.bytes_per_cluster_)), data);
    mod = off % info_.bytes_per_cluster_;
    nwrite = min(nwrite - total, info_.bytes_per_cluster_ - mod);
    if (either_copyin(user, (void *)buf, (uint64_t)(data + mod), nwrite) < 0) {
      total = -1;
      break;
    }
  }
  if (off > ip->sz) {
    ip->sz = off;
  }
  UpdateInode(ip);
  return total;
}

// 得到短文件名
__attribute__((used)) static int copysfn(const char *sfn, char *dst)
{
  int n = 0, i = 0;
  // 计算文件名的长度
  for (i = 0; i < 8 && sfn[i] != 0x20; i++) {
    n++;
  }
  memmove(reinterpret_cast<void *>(dst), sfn, i);
  // 计算扩展名的长度
  for (i = 8; i < 11 && sfn[i] != 0x20; i++) {}
  // 扩展名为空
  if (i == 8) {
    return n;
  }
  memmove(reinterpret_cast<void *>(dst + n), (void *)".", 1);
  n += 1;
  memmove(reinterpret_cast<void *>(dst + n), sfn + 8, i - 8);
  n += (i - 8);
  dst[n] = 0;
  return n;
}

// fat32长文件目录项的文件名的储存格式为unicode
// 其宽度为2, 为了方便处理将所有的Unicode都装换为
// 单字节格式
__attribute__((used)) static inline int copylfn(const MsdosEntry &entry,
                                                char *            dst)
{
  int sno = entry.lfn.sequence_number & ~0x40;

  // 通过长文件名目录项的序列号，计算当前lfn的name偏移量
  int offset = kLongNameLength * (sno - 1);

  // 这样复制可能会浪费空间
  CopyWcharToChar(dst + offset, (uint16_t *)entry.lfn.name0_4, 5);
  CopyWcharToChar(dst + offset + 5, (uint16_t *)entry.lfn.name5_10, 6);
  CopyWcharToChar(dst + offset + 11, (uint16_t *)entry.lfn.name11_12, 2);

  dst[kLongNameLength] = 0;
  return kLongNameLength;
}

struct inode *Fat32FileSystem::Lookup(struct inode *dir, const char *name)
{
  LOG_DEBUG("lookup");
  if (strncmp(".", name, strlen(name)) == 0) {
    dir->dup();
    return dir;
  }

  if (strncmp("..", name, strlen(name)) == 0) {
    dir->parent->dup();
    return dir->parent;
  }

  MsdosEntry entry;
  char       tmp_name[64];
  uint64_t   off = 0;
  while (ReadInode(dir, false, reinterpret_cast<uint64_t>(&entry), off,
                   sizeof(entry)) == sizeof(entry)) {
    off += sizeof(entry);
    if (entry.sfn.name[0] == 0x00) {
      goto bad;
    }
    if (entry.sfn.attrib != kFatAttrLongEntry) {  // 短文件目录项
      // 设置目录项类型
      copysfn(entry.sfn.name, tmp_name);
    }
    else if ((entry.lfn.sequence_number & 0xc0) == 0x40) {
      int nlfn = entry.lfn.sequence_number & ~0x40;  // 长文件目录项的数量
      int name_len = 0;
      name_len += copylfn(entry, tmp_name);
      for (int i = 1; i < nlfn; i++) {  // 读取剩下的lfn
        if (ReadInode(dir, false, reinterpret_cast<uint64_t>(&entry), off,
                      sizeof(entry)) != sizeof(entry)) {
          goto bad;
        }
        off += sizeof(entry);
        name_len += copylfn(entry, tmp_name + name_len);
      }
      // 获取长文件目录项序列后面的短文件目录项
      if (ReadInode(dir, false, reinterpret_cast<uint64_t>(&entry), off,
                    sizeof(entry)) != sizeof(entry)) {
        panic("except sfn");
      }
      off += sizeof(entry);
    }
    if (strncmp(name, tmp_name, kShortNameLength) != 0) {
      continue;
    }
    LOG_DEBUG("found");
    return BuildInode(entry, off - sizeof(entry), dir);
  }

bad:
  // fp->offset = off;
  // return read_dir_header.used;
  return nullptr;
}

// 方便readdir维护缓冲区空间
// 的大小
struct ReadDirHeader
{
  char *direntData;
  int   free;  // direntData剩余空间大小(byte)
  int   used;  // 已使用空间
  bool  user;  // direntData是否为user空间地址
};

// 成功返回0，失败返回-1
static int filldir(struct ReadDirHeader *direntHeader,
                   const char *          name,
                   int                   name_len,
                   uint64_t              ino,
                   uint_t                type)
{
  char *               buf = direntHeader->direntData + direntHeader->used;
  unsigned int         reclen;
  struct linux_dirent *de = reinterpret_cast<struct linux_dirent *>(buf);

  reclen = ALIGN(sizeof(struct linux_dirent) + name_len, sizeof(uint64_t));
  if (reclen > direntHeader->free) {
    return -1;
  }
  direntHeader->free -= reclen;
  direntHeader->used += reclen;
  de->d_off = reinterpret_cast<uint64_t>(buf + reclen);
  de->d_ino = ino;
  de->d_type = type;
  memcpy(de->d_name, name, name_len);
  de->d_reclen = reclen;
  return 0;
}

int Fat32FileSystem::ReadDir(
    struct file *fp, struct inode *ip, char *buf, int max_len, bool user)
{
  // struct linux_dirent *dirent;
  MsdosEntry    entry;
  ReadDirHeader read_dir_header;
  char          name[64];
  read_dir_header.direntData = buf;
  read_dir_header.free = max_len;
  read_dir_header.used = 0;
  read_dir_header.user = user;
  int off = fp->offset;
  int d_type;
  // 根目录，需要添加虚假的.和..节点
  // 用off=1代表"."
  //  off=2代表".."
  // 但实际目录内容中，不包含这两个目录项，
  // 故需要从0开始读
  if (ip->inum == kMsdosRootIno) {
    while (off < 2) {
      printf("off=%d\n", off);
      if (filldir(&read_dir_header, "..", off + 1, kMsdosRootIno, DT_DIR) < 0) {
        return read_dir_header.used;
      }
      off++;
      fp->offset++;
    }
    off = 0;  // 从off=0开始读
  }

  while (ReadInode(ip, false, reinterpret_cast<uint64_t>(&entry), off,
                   sizeof(entry)) == sizeof(entry)) {
    off += sizeof(entry);
    if (entry.sfn.name[0] == 0x00) {
      return read_dir_header.used;
    }
    if (entry.sfn.attrib != kFatAttrLongEntry) {  // 短文件目录项
      // 设置目录项类型
      if (entry.sfn.attrib & kFatAttrDirentory)
        d_type = DT_DIR;
      else
        d_type = DT_REG;
      int n = copysfn(entry.sfn.name, name);
      filldir(&read_dir_header, name, n, GetFirstCluster(entry), d_type);
    }
    else if ((entry.lfn.sequence_number & 0xc0) == 0x40) {  // 长文件名目录项
      int nlfn = entry.lfn.sequence_number & ~0x40;  // 长文件目录项的数量
      int name_len = 0;
      name_len += copylfn(entry, name);
      for (int i = 1; i < nlfn; i++) {  // 读取剩下的lfn
        if (ReadInode(ip, false, reinterpret_cast<uint64_t>(&entry), off,
                      sizeof(entry)) != sizeof(entry)) {
          goto out;
        }
        off += sizeof(entry);
        name_len += copylfn(entry, name + name_len);
      }
      // 获取长文件目录项序列后面的短文件目录项
      if (ReadInode(ip, false, reinterpret_cast<uint64_t>(&entry), off,
                    sizeof(entry)) != sizeof(entry)) {
        panic("except sfn");
      }
      off += sizeof(entry);

      // 设置目录项类型
      if (entry.sfn.attrib & kFatAttrDirentory)
        d_type = DT_DIR;
      else
        d_type = DT_REG;
      filldir(&read_dir_header, name, name_len, GetFirstCluster(entry), d_type);
    }
  }

out:
  fp->offset = off;
  return read_dir_header.used;
}

inline uint32_t Fat32FileSystem::FirstSectorOfCluster(uint32_t cluster)
{
  return info_.first_data_sector_ + ((cluster - 2) * info_.sectors_per_cluster);
}

int Fat32FileSystem::bmap(struct inode *ip, uint_t logi_cluster)
{
  MsdosInodeInfo *msdos_info = MSDOS_I(ip);

  uint32_t cur = msdos_info->i_start;
  size_t   i;
  for (i = 1; i <= logi_cluster && cur != kEndOfCluster32; i++) {
    uint32_t now = GetFatEntry(cur);
    if (now == kEndOfCluster32) {
      now = AllocCluster();
    }
    SetFatEntey(cur, now);
    cur = now;
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

inline uint32_t Fat32FileSystem::FatSectorOfCluster(uint32_t cluster)
{
  return info_.reserve_sectors_ + (cluster << 2) / info_.bytes_per_sector_;
}

inline uint32_t Fat32FileSystem::FatOffsetOfCluster(uint32_t cluster)
{
  return (cluster << 2) % info_.bytes_per_sector_;
}

inline int Fat32FileSystem::SetFatEntey(uint32_t cluster, uint32_t value)
{
  if (cluster > info_.cluster_count_) {
    return -1;
  }

  char *   data = new char[info_.bytes_per_sector_];
  uint32_t fat_sector = FatSectorOfCluster(cluster);
  uint32_t fat_offset = FatOffsetOfCluster(cluster);
  ReadSector(fat_sector, data);
  *reinterpret_cast<uint32_t *>(data + fat_offset) = value;
  WriteSector(fat_sector, data);
  return 0;
}

inline uint32_t Fat32FileSystem::GetFatEntry(uint32_t cluster)
{
  if (cluster > info_.cluster_count_) {
    return -1;
  }

  char *   data = new char[info_.bytes_per_sector_];
  uint32_t fat_sector = FatSectorOfCluster(cluster);
  uint32_t fat_offset = FatOffsetOfCluster(cluster);
  ReadSector(fat_sector, data);
  return *reinterpret_cast<uint32_t *>(data + fat_offset);
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
    ReadSector(FirstSectorOfCluster(cluster) + i, data + kSectorSize * i);
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