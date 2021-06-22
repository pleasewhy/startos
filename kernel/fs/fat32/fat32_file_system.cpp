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

namespace vfs {
namespace fat32 {

  // 测试的入口函数
  static void Test(Fat32FileSystem *fs);

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

  Fat32FileSystem::~Fat32FileSystem()
  {
    delete inode_cache_map_;
  }

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
    // struct inode *ip = Lookup(&info_.root_.vfs_inode, "cat");
#ifdef TEST_FAT32
    Test(this);
#endif
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

  struct inode *Fat32FileSystem::GetRootInode()
  {
    return info_.root_.vfs_inode.dup();
  }

  static char toUpCase(char c)
  {
    if (c >= 'a' && c <= 'z') {
      return c - 32;
    }
    return c;
  }

  // 暂时不处理文件名重复的情况
  static void
  FillShortFile(ShortEntry *entry, const char *name, uint32_t cluster, int mode)
  {
    // fill name
    char *dot = strrchr(name, '.');
    int   len;

    memset(entry->name, kShortNameFillStuff, 11);
    if (dot != 0) {
      len = strlen(dot + 1);
      len = len > 3 ? 3 : len;
      strncpy(entry->name + 8, dot + 1, len);
      len = dot - name;  // dot前的长度
    }
    else
      len = strlen(name);
    if (len > 8) {
      strncpy(entry->name, name, 6);
      entry->name[6] = '~';
      entry->name[7] = '1';
    }
    else {
      strncpy(entry->name, name, len);
    }
    for (int i = 0; i < len; i++) {
      entry->name[i] = toUpCase(entry->name[i]);
    }

    // fill attribute
    entry->attrib = mkattr(mode);

    // fill time
    time::timespec now_ts;
    time::CurrentTimeSpec(&now_ts);
    UnixTime2Fat(&now_ts, &entry->creation_date, &entry->creation_time);
    // 短文件目录项没有访问时间，故这里使用creation_time
    UnixTime2Fat(&now_ts, &entry->accessed_date, &entry->creation_time);
    UnixTime2Fat(&now_ts, &entry->modification_date, &entry->modification_time);

    // fill first cluster
    entry->cluster_low = (uint16_t)(cluster & 0xffff);
    entry->cluster_high = (uint16_t)(cluster >> 16);

    entry->file_size = 0;
  }

  uint64_t Fat32FileSystem::FindFreeEntry(struct inode *dir, int n)
  {
    MsdosEntry entry;
    uint64_t   off = 0;
    int        nfree = 0;  // 空闲目录项数量
    while (ReadInode(dir, false, reinterpret_cast<uint64_t>(&entry), off,
                     sizeof(entry)) == sizeof(entry)) {
      off += sizeof(entry);
      if (IsDeleted(entry) || IsFree(entry)) {
        nfree++;
      }
      else {
        nfree = 0;
      }
      if (nfree == n) {
        return off - nfree * sizeof(entry);
      }
    }
    panic("fat32:can't find free entry");
    return 0;
  }

  int Fat32FileSystem::Create(struct inode *dir, const char *name, int mode)
  {
    LongEntry  long_entry;
    ShortEntry short_entry;
    memset(&long_entry, 0, sizeof(long_entry));
    memset(&short_entry, 0, sizeof(short_entry));

    int name_len = strlen(name);
    // (a+b-1)/b: a/b向上取整
    int lfn_num = (name_len + kLongNameLength - 1) / kLongNameLength;
    LOG_DEBUG("lfn num=%d", lfn_num);
    // 获取短文件目录项的写入位置
    uint32_t off = FindFreeEntry(dir, lfn_num + 1) + lfn_num * kMsdosEntrySize;
    LOG_DEBUG("off=%d", off);
    // 填充短文件目录项
    FillShortFile(&short_entry, name, AllocCluster(), mode);

    // 写入短文件目录项
    WriteInode(dir, false, reinterpret_cast<uint64_t>(&short_entry), off,
               sizeof(short_entry));
    off -= sizeof(short_entry);

    // 写入长文件目录名
    uchar_t checksum = FatChecksum(short_entry.name);
    LOG_DEBUG("%s len=%d", name, lfn_num);
    for (uint8_t seq = 1; seq <= lfn_num; seq++) {
      memset(&long_entry, 0xff, kMsdosEntrySize);
      long_entry.sequence_number = seq;
      if (seq == lfn_num) {  // 最后一个lfn的序列号与0x40进行或运算
        long_entry.sequence_number |= 0x40;
      }
      CopyCharToWchar(long_entry.name0_4, name, 5);
      CopyCharToWchar(long_entry.name5_10, name + 5, 6);
      CopyCharToWchar(long_entry.name11_12, name + 11, 2);
      name += kLongNameLength;
      long_entry.checksum = checksum;
      long_entry.attrib = kFatAttrLongEntry;
      WriteInode(dir, false, reinterpret_cast<uint64_t>(&long_entry), off,
                 kMsdosEntrySize);
      off -= kMsdosEntrySize;
    }
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
    inode_info->i_start = GetStartCluster(entry);
    // 填充inode数据
    ip->dev = this->dev_;
    ip->inum = GetStartCluster(entry);
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
    char *fat_sector = new char[kSectorSize];
    // 遍历全部fat表，获取一个空闲的cluster
    // TODO 是否可以将fat表全部缓存到内存中？
    uint_t enteies_of_sector = kSectorSize / kFatEntryBytes;
    for (size_t sector = info_.reserve_sectors_;
         sector < info_.fat_num_ * info_.sectors_per_fat_; sector++) {
      ReadSector(sector, fat_sector);
      for (size_t i = 0; i < enteies_of_sector; i++) {
        if (reinterpret_cast<uint32_t *>(fat_sector)[i] == 0x00) {
          reinterpret_cast<uint32_t *>(fat_sector)[i] = kEndOfCluster32;
          WriteSector(sector, fat_sector);
          uint32_t cluster =
              enteies_of_sector * (sector - info_.reserve_sectors_) + i;
          ZeroCluster(cluster);
          LOG_DEBUG("alloc cluster=%d", cluster);
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
      uint32_t cluster = bmap(ip, (off / info_.bytes_per_cluster_));
      ReadCluster(cluster, data);
      mod = off % info_.bytes_per_cluster_;
      nwrite = min(n - total, info_.bytes_per_cluster_ - mod);
      if (either_copyin(user, (data + mod), buf, nwrite) < 0) {
        total = -1;
        break;
      }
      WriteCluster(cluster, data);
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
  // 这会根据entry->sequence_number计算entry的名称应该
  // 写入到dst的位置
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
    // dst[kLongNameLength] = 0;
    return kLongNameLength;
  }

  struct inode *Fat32FileSystem::Lookup(struct inode *dir, const char *name)
  {
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
    int        name_len = 0;
    while (ReadInode(dir, false, reinterpret_cast<uint64_t>(&entry), off,
                     sizeof(entry)) == sizeof(entry)) {
      off += sizeof(entry);
      if (entry.sfn.name[0] == 0x00) {
        goto bad;
      }

      if (entry.sfn.attrib != kFatAttrLongEntry) {  // 短文件目录项
        // 不应该进入该分支
        copysfn(entry.sfn.name, tmp_name);
      }
      else if ((entry.lfn.sequence_number & 0xc0) == 0x40) {
        int nlfn = entry.lfn.sequence_number & ~0x40;  // 长文件目录项的数量
        name_len = 0;
        name_len += copylfn(entry, tmp_name);
        for (int i = 1; i < nlfn; i++) {  // 读取剩下的lfn
          if (ReadInode(dir, false, reinterpret_cast<uint64_t>(&entry), off,
                        sizeof(entry)) != sizeof(entry)) {
            goto bad;
          }
          off += sizeof(entry);
          name_len += copylfn(entry, tmp_name);
        }
        // 获取长文件目录项序列后面的短文件目录项
        if (ReadInode(dir, false, reinterpret_cast<uint64_t>(&entry), off,
                      sizeof(entry)) != sizeof(entry)) {
          panic("except sfn");
        }
        off += sizeof(entry);
      }
      if (strncmp(name, tmp_name, name_len) != 0) {
        continue;
      }
      LOG_DEBUG("found");
      uint64_t cluster =
          (off - sizeof(entry)) / info_.bytes_per_cluster_;  // 获取当前逻辑簇
      uint64_t pos = FirstSectorOfCluster(bmap(dir, cluster)) * kSectorSize;
      pos += (off - sizeof(entry)) % info_.bytes_per_cluster_;
      return BuildInode(entry, pos, dir);
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
    char *               direntData;
    int                  free;         // direntData剩余空间大小(byte)
    int                  used;         // 已使用空间
    struct linux_dirent *last_dirent;  // 上一个目录项
    bool                 user;         // direntData是否为user空间地址
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
      direntHeader->last_dirent->d_off = 0;
      LOG_DEBUG("readdir::filedir: reach max size");
      return -1;
    }
    direntHeader->free -= reclen;
    direntHeader->used += reclen;
    de->d_off = reinterpret_cast<uint64_t>(buf + reclen);
    de->d_ino = ino;
    de->d_type = type;
    memcpy(de->d_name, name, name_len);
    de->d_reclen = reclen;
    direntHeader->last_dirent = de;
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
    read_dir_header.last_dirent = 0;

    int off = fp->offset - 2;  // 前两字节是虚拟的，磁盘上不存在
    int d_type;
    // 根目录，需要添加虚假的.和..节点
    // 用off=1代表"."
    //  off=2代表".."
    // 但实际目录内容中，不包含这两个目录项，
    // 故需要从0开始读
    if (ip->inum == kMsdosRootIno) {
      while (off < 0) {
        if (filldir(&read_dir_header, "..", off + 3, kMsdosRootIno, DT_DIR) <
            0) {
          return read_dir_header.used;
        }
        off++;
        fp->offset++;
      }
    }
    int begin_off = off;
    while (ReadInode(ip, false, reinterpret_cast<uint64_t>(&entry), off,
                     sizeof(entry)) == sizeof(entry)) {
      begin_off = off;
      off += sizeof(entry);
      if (entry.sfn.name[0] == 0x00) {
        goto out;
      }

      // 不应该进入该分支
      if (entry.sfn.attrib != kFatAttrLongEntry) {  // 短文件目录项
        // 设置目录项类型
        if (entry.sfn.attrib & kFatAttrDirentory)
          d_type = DT_DIR;
        else
          d_type = DT_REG;
        int n = copysfn(entry.sfn.name, name);
        if (filldir(&read_dir_header, name, n, GetStartCluster(entry),
                    d_type)) {
          goto out;
        }
      }
      else if ((entry.lfn.sequence_number & 0xc0) == 0x40) {  // 长文件名目录项
        int nlfn = entry.lfn.sequence_number & ~0x40;  // 长文件目录项的数量
        memset(name, 0, 64);
        int name_len = 0;
        name_len += copylfn(entry, name);
        for (int i = 1; i < nlfn; i++) {  // 读取剩下的lfn
          if (ReadInode(ip, false, reinterpret_cast<uint64_t>(&entry), off,
                        sizeof(entry)) != sizeof(entry)) {
            goto out;
          }
          off += sizeof(entry);
          name_len += copylfn(entry, name);
        }
        // 获取长文件目录项序列后面的短文件目录项
        if (ReadInode(ip, false, reinterpret_cast<uint64_t>(&entry), off,
                      sizeof(entry)) != sizeof(entry)) {
          goto out;
        }
        off += sizeof(entry);

        // 设置目录项类型
        if (entry.sfn.attrib & kFatAttrDirentory)
          d_type = DT_DIR;
        else
          d_type = DT_REG;
        LOG_DEBUG("read_dir=%s", name);
        if (filldir(&read_dir_header, name, name_len, GetStartCluster(entry),
                    d_type) < 0) {
          goto out;
        }
      }
    }

  out:
    fp->offset = begin_off + 2;
    return read_dir_header.used;
  }

  int Fat32FileSystem::Mkdir(struct inode *dir, const char *name, int mode)
  {
    if (Create(dir, name, mode | __S_IFDIR) < 0) {
      return -1;
    }
    struct inode *ip = Lookup(dir, name);
    ShortEntry    short_entries[2];
    FillShortFile(short_entries, "", MSDOS_I(ip)->i_start, mode);
    FillShortFile(short_entries + 1, "", MSDOS_I(dir)->i_start, dir->mode);

    // 设置文件名
    short_entries[0].name[0] = short_entries[1].name[0] = '.';
    short_entries[1].name[1] = '.';

    return WriteInode(ip, false, reinterpret_cast<uint64_t>(short_entries), 0,
                      sizeof(short_entries));
  }

  int Fat32FileSystem::Unlink(struct inode *dir, const char *name)
  {
    MsdosEntry entry;
    char       tmp_name[64];
    uint32_t   off = 0;
    int        name_len = 0;
    int        nlfn = 0;  // 长文件名目录项的数量
    while (ReadInode(dir, false, reinterpret_cast<uint64_t>(&entry), off,
                     sizeof(entry)) == sizeof(entry)) {
      off += sizeof(entry);
      if (entry.sfn.name[0] == 0x00) {
        goto out;
      }

      if (entry.sfn.attrib != kFatAttrLongEntry) {  // 短文件目录项
        // 不应该进入该分支
        // copysfn(entry.sfn.name, tmp_name);
      }
      else if ((entry.lfn.sequence_number & 0xc0) == 0x40) {
        nlfn = entry.lfn.sequence_number & ~0x40;  // 长文件目录项的数量
        name_len = 0;
        name_len += copylfn(entry, tmp_name);
        for (int i = 1; i < nlfn; i++) {  // 读取剩下的lfn
          if (ReadInode(dir, false, reinterpret_cast<uint64_t>(&entry), off,
                        sizeof(entry)) != sizeof(entry)) {
            goto out;
          }
          off += sizeof(entry);
          name_len += copylfn(entry, tmp_name);
        }
        // 获取长文件目录项序列后面的短文件目录项
        if (ReadInode(dir, false, reinterpret_cast<uint64_t>(&entry), off,
                      sizeof(entry)) != sizeof(entry)) {
          panic("except sfn");
        }
        off += sizeof(entry);
      }

      if (strncmp(name, tmp_name, name_len) != 0) {
        continue;
      }

      uint64_t cluster =
          (off - sizeof(entry)) / info_.bytes_per_cluster_;  // 获取当前逻辑簇
      uint64_t pos = FirstSectorOfCluster(bmap(dir, cluster)) * kSectorSize;
      pos += (off - sizeof(entry)) % info_.bytes_per_cluster_;
      struct inode *ip = GetInode(pos);
      if (ip != nullptr) {  // 判断该inode是否在被使用
        ip->free();
        return -1;
      }

      MarkEntryDeleted(dir, off - sizeof(entry), -(nlfn + 1));
      FreeClusterChain(GetStartCluster(entry));
      return 0;
    }

  out:
    return 0;

    // bad:
    //   return -1;
  }

  inline uint32_t Fat32FileSystem::FirstSectorOfCluster(uint32_t cluster)
  {
    return info_.first_data_sector_ +
           ((cluster - 2) * info_.sectors_per_cluster);
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

  void Fat32FileSystem::FreeClusterChain(uint32_t cluster)
  {
    int next_cluster = cluster;
    while (cluster != kEndOfCluster32) {
      next_cluster = GetFatEntry(cluster);
      SetFatEntey(cluster, 0);
      cluster = next_cluster;
    }
  }
  void Fat32FileSystem::MarkEntryDeleted(struct inode *ip,
                                         uint32_t      off,
                                         int           n) noexcept
  {
    if (n == 0)
      return;
    int        flag = n > 0 ? 1 : -1;
    MsdosEntry entry;
    n = n > 0 ? n : -n;
    while (n-- > 0) {
      if (ReadInode(ip, false, reinterpret_cast<uint64_t>(&entry), off,
                    sizeof(entry)) != sizeof(entry)) {
        return;
      }
      entry.sfn.name[0] = kDeletedMark;
      if (WriteInode(ip, false, reinterpret_cast<uint64_t>(&entry), off,
                     sizeof(entry)) != sizeof(entry)) {
        return;
      }
      off += flag * sizeof(entry);
    }
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

  /******************Test Function Start****************************/
  void TestReadDir(Fat32FileSystem *fs)
  {
    struct file f;
    f.inode = &fs->info_.root_.vfs_inode;
    f.offset = 0;
    char buf[512];
    memset(buf, 0, sizeof(buf));
    linux_dirent *de = (linux_dirent *)buf;
    memset(buf, 0, 512);
    LOG_DEBUG("Test ReadDir");
    while (true) {
      int nread = fs->ReadDir(&f, f.inode, buf, 512, false);
      if (nread == 0)
        break;
      de = (linux_dirent *)buf;
      while (de != 0 && de->d_reclen != 0) {
        LOG_DEBUG("dirent=%s", de->d_name);
        de = (linux_dirent *)(de->d_off);
      }
    }
    LOG_DEBUG("Test ReadDir success");
  }

  void TestCreate(Fat32FileSystem *fs)
  {
    LOG_DEBUG("test create short name entry");
    fs->Create(&fs->info_.root_.vfs_inode, "test", __S_IFREG);
    LOG_DEBUG("test create long name entry");
    fs->Create(&fs->info_.root_.vfs_inode, "test_create_long_name_file",
               __S_IFREG);
  }

  void TestPrintShortName(Fat32FileSystem *fs, struct inode *ip)
  {
    char        buf[512];
    int         i = 0;
    MsdosEntry *entry = (MsdosEntry *)buf;
    while (true) {
      memset(buf, 0, 512);
      fs->ReadInode(ip, false, (uint64_t)buf, i * sizeof(MsdosEntry),
                    sizeof(MsdosEntry));
      if (entry->sfn.name[0] == 0) {
        break;
      }
      if (entry->sfn.attrib != kFatAttrLongEntry) {
        printf("attr=%p short name=%s\n", entry->sfn.attrib, entry->sfn.name);
      }
      ++i;
    }
  }

  void TestMkdir(Fat32FileSystem *fs)
  {
    fs->Mkdir(&fs->info_.root_.vfs_inode, "test_mkdir", __S_IFDIR);
    TestPrintShortName(fs,
                       fs->Lookup(&fs->info_.root_.vfs_inode, "test_mkdir"));
  }

  // void

  __attribute__((used)) void Test(Fat32FileSystem *fs)
  {
    TestCreate(fs);
    TestPrintShortName(fs, &fs->info_.root_.vfs_inode);
    TestMkdir(fs);
    TestReadDir(fs);
  }
  /******************Test Function Start****************************/
}  // namespace fat32
}  // namespace vfs