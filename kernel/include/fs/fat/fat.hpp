#ifndef __FAT_HPP
#define __FAT_HPP

#include "types.hpp"

namespace fat32 {

#pragma pack(push, 1)

// 短文件目录项属性
const uint8_t kFatAttrReadOnly = 0x01;
const uint8_t kFatAttrHidden = 0x02;
const uint8_t kFatAttrSystem = 0x04;
const uint8_t kFatAttrVolumeLabel = 0x08;
const uint8_t kFatAttrDirentory = 0x10;
const uint8_t kFatAttrArchive = 0x20;
const uint8_t kFatAttrDevice = 0x40;
const uint8_t kFatAttrUnused = 0x80;
const uint8_t kFatAttrLongEntry = 0xF;  // 为此值时表示该目录项为长文件名目录项

const uint32_t kBadCluster32 = 0x0ffffff7;
const uint32_t kEndOfCluster32 = 0x0fffffff;  // 文件结束标志
const uint8_t  kFatEntryBytes = 4;            // fat表项为4个字节

// Bios Parameter Block
struct FatBpb
{
  uint8_t  jump[3];
  char     oem_name[8];
  uint16_t bytes_per_sector;          // 扇区字节数
  uint8_t  sectors_per_cluster;       // cluster 包含的扇区数
  uint16_t reserved_sectors;          // 保留的扇区数
  uint8_t  number_of_fat;             // fat表的数量
  uint16_t root_directories_entries;  // 根目录cluster
  uint16_t total_sectors;             // 总的扇区数(fat12/fat16)
  uint8_t  media_descriptor;
  uint16_t sectors_per_fat;               // fat包含扇区数(fat12/16)
  uint16_t sectors_per_track;             // 磁道扇区数
  uint16_t track_heads;                   // 磁头数
  uint32_t hidden_sectors;                // 分区已使用扇区数
  uint32_t total_sectors_long;            // 文件系统总扇区数(fat32)
  uint32_t sectors_per_fat_v32;           // fat表扇区数(fat32)
  uint16_t drive_description;             // 介质描述符
  uint16_t version;                       // 版本
  uint32_t root_directory_cluster_start;  // 根目录簇号(通常为2)
  uint16_t fs_information_sector;         // 文件系统信息扇区
  uint16_t boot_sectors_copy_sector;      // 备份引导扇区
  uint8_t  filler[12];                    // 未使用
  uint8_t  physical_drive_number;         //
  uint8_t  reserved;                      // 保留
  uint8_t  extended_boot_signature;       // 扩展引导标志
  uint32_t volume_id;                     // 卷序列号,通常为随机值
  char     volume_label[11];              // 卷标(ASCII码)
  char     file_system_type[8];           // 文件系统格式
  uint8_t  boot_code[420];                // 未使用
  uint16_t signature;                     // 签名标志
};

// FAT 32 Information sector
struct FatFsInfo
{
  uint32_t signature_start;  // 签名
  uint8_t  reserved[480];    // 保留
  uint32_t signature_middle;
  uint32_t free_clusters;       // 空闲簇数
  uint32_t allocated_clusters;  // 已分配的簇数
  uint8_t  reserved_2[12];      // 保留
  uint32_t signature_end;
};

static_assert(sizeof(FatFsInfo) == 512,
              "FAT Boot Sector is exactly one disk sector");

// 短文件目录项
typedef struct ShortEntryStruct
{
  char     name[11];
  uint8_t  attrib;
  uint8_t  reserved;
  uint8_t  creation_time_seconds;
  uint16_t creation_time;
  uint16_t creation_date;
  uint16_t accessed_date;
  uint16_t cluster_high;
  uint16_t modification_time;
  uint16_t modification_date;
  uint16_t cluster_low;
  uint32_t file_size;
} ShortEntry;

// 长文件目录项
typedef struct LongEntryStruct
{
  uint8_t  sequence_number;
  uint16_t name_first[5];
  uint8_t  attrib;
  uint8_t  reserved;
  uint8_t  alias_checksum;
  uint16_t name_second[6];
  uint16_t starting_cluster;
  uint16_t name_third[2];
} LongEntry;

union ClusterEntry
{
  LongEntry  long_entry;
  ShortEntry short_entry;
};

static_assert(sizeof(ShortEntry) == 32, "A cluster entry is 32 bytes");
static_assert(sizeof(LongEntry) == 32, "A cluster entry is 32 bytes");
#pragma pack(pop)

inline bool IsLongEntry(ClusterEntry entry)
{
  return entry.long_entry.attrib == kFatAttrLongEntry;
}

/**
 * @brief 判断该目录项是否被使用
 * @note 当entry的第一个字节为0xe5时,表明该entry
 * 曾经使用过，但被删除了为0x00,表明该entry没有
 * 被使用过
 */
inline bool IsAllocated(ClusterEntry entry)
{
  return entry.short_entry.name[0] != 0x00 && entry.short_entry.name[0] != 0xe5;
}

}  // namespace fat32

#endif