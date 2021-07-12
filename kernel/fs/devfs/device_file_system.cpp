#include "fs/devfs/device_file_system.hpp"
#include "list.hpp"
#include "fcntl.h"
#include "device/Console.hpp"
#include "common/logger.h"
#include "common/string.hpp"
#include "utility.hpp"
#include "device/RwDevice.hpp"
#include "device/DeviceManager.hpp"

extern Console console;
namespace dev {
extern RwDevice *rw_devs[10];
}
using namespace dev;

namespace vfs {
namespace devfs {

  void    Test(DeviceFileSystem *fs);
  uint8_t kConsoleIno = 5;
  uint8_t kDevFsRootIno = 1;

  DeviceFileSystem::DeviceFileSystem(int dev)
  {
    // 添加块设备
    int dev_no = 2;

    root_ = new DevInodeInfo();
    FillInode(&root_->vfs_inode, &root_->vfs_inode, -1, kDevFsRootIno,
              __S_IFDIR);
    for (int i = 0; i < 10; i++) {
      if (rw_devs[i] == nullptr) {
        continue;
      }
      LOG_INFO("device filesystem: dev=%s", rw_devs[i]->name);
      DevInodeInfo *info = new DevInodeInfo();
      safestrcpy(info->name, rw_devs[i]->name, strlen(rw_devs[i]->name) + 1);
      LOG_TRACE("before insert");
      FillInode(&info->vfs_inode, &root_->vfs_inode, dev_no++, kConsoleIno,
                __S_IFBLK);
      root_->children_list->insert(std::move(info));
      LOG_TRACE("after insert");
    }
    // 添加字符设备，这里不想重写console，就这样简单的实现下吧
    DevInodeInfo *info = new DevInodeInfo();
    safestrcpy(info->name, "tty", 4);
    FillInode(&info->vfs_inode, &root_->vfs_inode, kConsoleIno, kConsoleIno,
              __S_IFCHR);
    root_->children_list->insert(std::move(info));
    Test(this);
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
    return root_->vfs_inode.dup();
  }

  int DeviceFileSystem::Create(struct inode *dir, const char *name, int mode)
  {
    LOG_WARN("Create isn't support in device file system");
    return 0;
  }

  void DeviceFileSystem::DeleteInode(struct inode *inode)
  {
    LOG_WARN("DeleteInode isn't support in device file system");
  }

  int DeviceFileSystem::UpdateInode(struct inode *ip)
  {
    LOG_WARN("UpdateInode isn't support in device file system");
    return 0;
  }

  int DeviceFileSystem::ReadInode(
      struct inode *ip, bool user, uint64_t buf, uint64_t off, uint_t n)
  {
    if (ip->dev == kConsoleIno) {
      return console.read(buf, user, n);
    }
    else {
      return dev::RwDevRead(ip->dev, reinterpret_cast<char *>(buf), 0, n);
    }
  }

  int DeviceFileSystem::WriteInode(
      struct inode *ip, bool user, uint64_t buf, uint64_t off, uint_t n)
  {
    if (ip->dev == kConsoleIno) {
      return console.write(buf, user, n);
    }
    else {
      return dev::RwDevWrite(ip->dev, reinterpret_cast<char *>(buf), 0, n);
    }
  }

  struct inode *DeviceFileSystem::Lookup(struct inode *dir, const char *name)
  {
    auto iter = root_->children_list->begin();
    while (iter != nullptr) {
      if (strcmp(iter->data->name, name) == 0) {
        return iter->data->vfs_inode.dup();
      }
      ++iter;
    }
    return nullptr;
  }

  int DeviceFileSystem::ReadDir(
      struct file *fp, struct inode *ip, char *buf, int max_len, bool user)
  {
    ReadDirHeader read_dir_header;
    read_dir_header.direntData = buf;
    read_dir_header.free = max_len;
    read_dir_header.used = 0;
    read_dir_header.user = user;
    read_dir_header.last_dirent = 0;

    int off = fp->offset;
    // 根目录，需要添加虚假的.和..节点
    // 用off=1代表"."
    //  off=2代表".."
    if (ip->inum == kDevFsRootIno) {
      while (fp->offset < 2) {
        if (filldir(&read_dir_header, "..", off + 1, kDevFsRootIno, DT_DIR) <
            0) {
          return read_dir_header.used;
        }
        off++;
        fp->offset++;
      }
    }

    auto iter = root_->children_list->begin();
    // 定位上次读取目录项
    int i = 2;
    while (i < off && iter != nullptr) {
      ++iter;
      i++;
    }

    while (iter != nullptr) {
      DevInodeInfo *info = iter->data;
      if (filldir(&read_dir_header, info->name, strlen(info->name),
                  info->vfs_inode.inum, DT_REG) < 0) {
        return read_dir_header.used;
      }
      iter++;
      off++;
    }
    fp->offset = off;
    LOG_TRACE("off=%d", off);
    return read_dir_header.used;
  }

  int DeviceFileSystem::Mkdir(struct inode *dir, const char *name, int mode)
  {
    LOG_WARN("mkdir isn't support in device file system");
    return -1;
  }

  int DeviceFileSystem::Unlink(struct inode *dir, const char *name)
  {
    LOG_WARN("unlink isn't support in device file system");
    return -1;
  }

  void DeviceFileSystem::FillInode(
      struct inode *ip, struct inode *parent, int dev, int ino, mode_t mode)
  {
    ip->file_system = this;
    ip->inum = ino;
    ip->dev = dev;
    ip->parent = parent->dup();
    ip->sz = -1;
    ip->mode = mode;
    ip->file_system = this;
  }

  void TestReadDir(DeviceFileSystem *fs)
  {
    struct file f;
    f.inode = fs->GetRootInode();
    f.offset = 0;
    char buf[512];
    memset(buf, 0, sizeof(buf));
    linux_dirent *de = (linux_dirent *)buf;
    memset(buf, 0, 512);
    LOG_TRACE("Test ReadDir");
    while (true) {
      int nread = fs->ReadDir(&f, f.inode, buf, 512, false);
      if (nread == 0)
        break;
      de = (linux_dirent *)buf;
      while (de != 0 && de->d_reclen != 0) {
        LOG_TRACE("dirent=%s", de->d_name);
        de = (linux_dirent *)(de->d_off);
      }
    }
    LOG_TRACE("Test ReadDir success");
    f.inode->free();
  }

  void TestRead(DeviceFileSystem *fs)
  {
    struct inode *root = fs->GetRootInode();
    struct inode *ip = fs->Lookup(root, "tty");
    fs->WriteInode(ip, false, (uint64_t) "hello world~\n", 0, 14);
    root->free();
    LOG_TRACE("test read success");
  }

  void Test(DeviceFileSystem *fs)
  {
    TestReadDir(fs);
    TestRead(fs);
  }
}  // namespace devfs
}  // namespace vfs