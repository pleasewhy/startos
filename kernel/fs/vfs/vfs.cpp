#include "fs/vfs/vfs.hpp"
#include "fcntl.h"
#include "fs/fat/fat32_file_system.hpp"
#include "common/string.hpp"
#include "os/TaskScheduler.hpp"

namespace vfs {

void VfsManager::Init()
{
  memset(mount_points_, 0, sizeof(mount_points_));
  MountRoot();
}

int VfsManager::Mount(const char *   source,
                      const char *   target,
                      FileSystemType type)
{
  MountPoint *mp = nullptr;
  // 找到一个没有被使用的MountPoint结构
  vfs_sleeplock_.lock();
  for (int i = 0; i < NELEM(mount_points_); i++) {
    if (mount_points_[i].mp_path[0] == 0) {
      mp = mount_points_ + i;
    }
  }

  if (mp == nullptr) {
    panic("vfs::mount: haven't enough free mount point");
    return -1;
  }
  strncpy(mp->device_path, source, strlen(source));
  strncpy(mp->mp_path, target, strlen(target));
  // MountPoint *source_mp = March(source);
  // MountPoint *target_mp = March(target);
  // source_mp->fs.l
  vfs_sleeplock_.unlock();
  return 0;
}

//                        88
//                        ""                          ,d
//                                                    88
// 8b,dPPYba,  8b,dPPYba, 88 8b       d8 ,adPPYYba, MM88MMM ,adPPYba,
// 88P'    "8a 88P'   "Y8 88 `8b     d8' ""     `Y8   88   a8P_____88
// 88       d8 88         88  `8b   d8'  ,adPPPPP88   88   8PP"""""""
// 88b,   ,a8" 88         88   `8b,d8'   88,    ,88   88,  "8b,   ,aa
// 88`YbbdP"'  88         88     "8"     `"8bbdP"Y8   "Y888 `"Ybbd8"'
// 88
// 88

void VfsManager::MountRoot()
{
  MountPoint *root_mp = mount_points_;
  root_mp->dev = 0;  // 先硬编码
  root_mp->fs = new fat32::Fat32FileSystem(0);
  strncpy(root_mp->mp_path, "/", 1);
  // 不需要设置设备路径
}

void VfsManager::MountDev()
{
  MountPoint *root_mp = mount_points_;
  root_mp->dev = 0;  // 先硬编码
  root_mp->fs = new fat32::Fat32FileSystem(0);
  strncpy(root_mp->mp_path, "/dev", 1);
  // 不需要设置设备路径
}

MountPoint *VfsManager::March(const char *path)
{
  int bestMatch = 0;
  int bestLength = 0;
  // 找出最适配的文件系统
  for (size_t i = 0; i < kMountPointNumber; ++i) {
    if (mount_points_->fs == nullptr)
      continue;

    auto &mp = mount_points_[i];

    bool match = true;
    for (size_t j = 0; mp.mp_path[j] != 0 && path[i] != 0; ++j) {
      if (mp.mp_path[j] != path[j]) {
        match = false;
        break;
      }
    }

    if (match && strlen(mp.mp_path) > bestLength) {
      bestLength = strlen(mp.mp_path);
      bestMatch = i;
    }
  }
  return &mount_points_[bestMatch];
}

char *VfsManager::SkipElememt(char *path, char *name)
{
  char *s;
  int   len;

  while (*path == '/')
    path++;
  if (*path == 0)
    return 0;
  s = path;
  while (*path != '/' && *path != 0)
    path++;
  len = path - s;
  if (len >= kMaxFileName)
    memmove(name, s, kMaxFileName);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while (*path == '/')
    path++;
  return path;
}

struct inode *
VfsManager::namex(FileSystem0 *fs, char *dir_path, bool nameiparent, char *name)
{
  struct inode *ip, *next;

  if (*dir_path == '/')
    ip = fs->GetRootInode();
  else
    ip = myTask()->cwd->dup();

  while ((dir_path = SkipElememt(dir_path, name)) != 0) {
    ip->lock();
    if (S_ISDIR(ip->mode)) {
      ip->unlock();
      ip->free();
      return 0;
    }
    if (nameiparent && *dir_path == '\0') {
      // Stop one level early.
      ip->unlock();
      return ip;
    }
    if ((next = fs->Lookup(ip, name)) == 0) {
      ip->unlock();
      ip->free();
      return 0;
    }
    ip->unlock();
    ip->free();
    ip = next;
  }
  if (nameiparent) {
    ip->free();
    return 0;
  }
  return ip;
}

}  // namespace vfs