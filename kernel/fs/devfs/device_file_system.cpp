#include "fs/devfs/device_file_system.hpp"
#include "list.hpp"
#include "utility.hpp"
#include "device/RwDevice.hpp"

namespace vfs {
namespace devfs {
  extern dev::RwDevice *rw_devs[10];

  DeviceFileSystem::DeviceFileSystem(int dev)
  {
    for (int i = 0; i < 10; i++) {
      DevInodeInfo *info = new DevInodeInfo();
      root_->children_list->insert(std::move(info));
    }
  }

  struct inode *DeviceFileSystem::AllocInode()
  {
    DevInodeInfo *dev_inode_info = new DevInodeInfo;
    return &dev_inode_info->vfs_inode;
  }

  /**
   * @brief 获取Root inode
   *
   */
  struct inode *DeviceFileSystem::GetRootInode()
  {
    return &root_->vfs_inode;
  }

  int Create(struct inode *dir, const char *name, int mode)
  {
    return 0;
  }

  void DeleteInode(struct inode *inode) {}

  int UpdateInode(struct inode *ip)
  {
    return 0;
  }

  int ReadInode(
      struct inode *ip, bool user, uint64_t buf, uint64_t off, uint_t n)
  {
  }

  int WriteInode(
      struct inode *ip, bool user, uint64_t buf, uint64_t off, uint_t n)
  {
  }

  struct inode *Lookup(struct inode *dir, const char *name) {}

  int ReadDir(
      struct file *fp, struct inode *ip, char *buf, int max_len, bool user)
  {
  }

  int Mkdir(struct inode *dir, const char *name, int mode)
  {
    return -1;
  }

  int Unlink(struct inode *dir, const char *name)
  {
    return -1;
  }

}  // namespace devfs
}  // namespace vfs