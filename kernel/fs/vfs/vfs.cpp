#include "fs/vfs/vfs.hpp"
#include "fcntl.h"
#include "fs/fat/fat32_file_system.hpp"
#include "fs/devfs/device_file_system.hpp"
#include "common/string.hpp"
#include "os/TaskScheduler.hpp"

namespace vfs {
void Test();

SleepLock     VfsManager::vfs_sleeplock_;
MountPoint    VfsManager::mount_points_[kMountPointNumber];
struct inode *VfsManager::root_;

void VfsManager::Init()
{
  memset(mount_points_, 0, sizeof(mount_points_));
  LOG_TRACE("mount");
  MountRoot();
  MountDev();
  LOG_TRACE("mount over");
#ifdef TEST_VFS
  Test();
#endif
}

struct file *
VfsManager::openat(struct file *dir, char *filepath, size_t flags, mode_t mode)
{
  LOG_WARN("vfs::openat filepath=%s", filepath);
  struct inode *ip = nullptr;

  struct inode *dp = nullptr;  // 父目录inode
  if (dir != nullptr) {
    dp = dir->inode->dup();
  }
  else if (filepath[0] == '/') {
    dp = root_->dup();
  }
  else {
    LOG_WARN("cwd");
    dp = myTask()->cwd->dup();
  }

  if (O_CREATE & flags) {
    char name[kMaxFileName];
    nameiparent(dp, filepath, name);
    if (dp->file_system->Create(dp, name, mode) < 0) {
      panic("can't create file");
      // return -1;
    }
    ip = namei(dp, name);
  }
  else {
    LOG_WARN("file=%s", filepath);
    ip = namei(dp, filepath);
  }
  if (ip == nullptr) {
    return nullptr;
  }
  LOG_WARN("namei=%s", ip->test_name);
  struct file *fp = new struct file;
  fp->inode = ip;
  fp->readable = !(flags & O_WRONLY);
  fp->writable = (flags & O_WRONLY) || (flags & O_RDWR);
  fp->offset = 0;
  fp->pipe = nullptr;
  fp->type = fp->FD_INODE;
  fp->ref = 1;
  fp->size = ip->sz;
  return fp;
}

int VfsManager::read(struct file *fp, char *buf, int n, bool user)
{
  if (fp == nullptr) {
    panic("fp is nullptr");
  }
  int nread = 0;
  switch (fp->type) {
    case fp->FD_PIPE:
      nread = fp->pipe->read(reinterpret_cast<uint64_t>(buf), n);
      break;
    case fp->FD_INODE:
      nread = fp->inode->read(buf, fp->offset, n, user);
      break;
    default:
      panic("unknown file type");
      break;
  }
  fp->offset += nread;
  return nread;
}

int VfsManager::write(struct file *fp, const char *buf, int n, bool user)
{
  if (fp == nullptr) {
    panic("fp is nullptr");
  }
  if (!fp->writable) {
    return -1;
  }
  int nwrite = 0;
  switch (fp->type) {
    case fp->FD_PIPE:
      nwrite = fp->pipe->write(reinterpret_cast<uint64_t>(buf), n);
      break;
    case fp->FD_INODE:
      nwrite = fp->inode->write(buf, fp->offset, n, user);
      fp->size =
          fp->offset + nwrite > fp->size ? fp->offset + nwrite : fp->size;
      break;
    default:
      panic("unknown file type");
      break;
  }
  fp->offset += nwrite;
  return nwrite;
}

// 递减ref，当ref = 0时关闭
void VfsManager::close(struct file *fp)
{
  struct file ff;
  fp->ref_lock.lock();
  if (fp->ref < 1) {
    panic("vfs::close");
  }
  if (--fp->ref > 0) {
    fp->ref_lock.unlock();
    return;
  }
  fp->ref_lock.unlock();
  ff = *fp;
  LOG_TRACE("delete fp");
  delete fp;

  if (ff.type == ff.FD_PIPE) {
    if (ff.writable)
      ff.pipe->close(ff.pipe->WRITE_END);
    if (ff.readable)
      ff.pipe->close(ff.pipe->READ_END);
  }
  else if (ff.type == ff.FD_INODE) {
    ff.inode->free();
  }
  else if (ff.type == ff.FD_DEVICE) {
  }
  LOG_TRACE("delete fp finish");
};

struct file *VfsManager::rewind(struct file *fp)
{
  fp->ref_lock.lock();
  if (fp->ref < 1)
    panic("filerewind");
  fp->offset = 0;
  fp->ref_lock.unlock();
  return fp;
}

struct file *VfsManager::dup(struct file *fp)
{
  fp->ref_lock.lock();
  LOG_TRACE("file=%d", fp->ref);
  if (fp->ref < 1) {
    panic("vfs::dup");
  }
  fp->ref++;
  fp->ref_lock.unlock();
  return fp;
}

int VfsManager::createPipe(int fds[])
{
  struct file *f0 = new struct file;
  struct file *f1 = new struct file;
  Pipe *       pipe = new Pipe(f0, f1);
  if (pipe == NULL) {
    delete f0;
    delete f1;
    return -1;
  }
  f0->ref = 1;
  f1->ref = 1;
  int fd0 = registerFileHandle(f0);
  int fd1 = registerFileHandle(f1);
  fds[0] = fd0;
  fds[1] = fd1;
  return 0;
}

int VfsManager::ReadDir(struct file *fp, char *buf, int max_len, bool user)
{
  if (!fp->readable) {
    return -1;
  }
  auto fs = fp->inode->file_system;
  return fs->ReadDir(fp, fp->inode, buf, max_len, user);
}

int VfsManager::Mount(const char *        source,
                      const char *        target,
                      FileSystemType_DTMP type)
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

void VfsManager::DebugInfo()
{
  for (int i = 0; i < kMountPointNumber; i++) {
    if (mount_points_[i].fs != nullptr) {
      mount_points_[i].fs->DebugInfo();
    }
  }
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
  MountPoint *root_mp = mount_points_;  // 固定第一个
  root_mp->dev = 0;                     // 先硬编码
  root_mp->fs = new fat32::Fat32FileSystem(0);
  strncpy(root_mp->mp_path, "/", 1);
  root_ = root_mp->fs->GetRootInode();
  LOG_WARN("root=%s", root_);
  // 不需要设置设备路径
}

void VfsManager::MountDev()
{
  MountPoint *dev_mp = mount_points_ + 1;  // 固定第二个

  dev_mp->dev = 0;  // 先硬编码
  dev_mp->fs = new devfs::DeviceFileSystem(-1);
  strncpy(dev_mp->mp_path, "/dev", 4);
  struct inode *dev = root_->file_system->Lookup(root_, "dev");
  if (dev == nullptr) {
    panic("expect dev directory");
  }
  dev_mp->origin = dev;
  dev_mp->target = dev_mp->fs->GetRootInode();
  dev->is_mp_target = true;
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

struct inode *VfsManager::ConvertInodeByMp(struct inode *ip)
{
  for (int i = 0; i < kMountPointNumber; i++) {
    if (mount_points_[i].origin == ip) {
      LOG_TRACE("convert");
      ip->free();
      return mount_points_[i].target->dup();
    }
  }
  return ip;
}

struct inode *
VfsManager::namex(struct inode *ip, char *path, bool nameiparent, char *name)
{
  struct inode *next;
  auto          fs = ip->file_system;

  while ((path = SkipElememt(path, name)) != 0) {
    ip->lock();
    if (!S_ISDIR(ip->mode)) {
      ip->unlock();
      ip->free();
      LOG_TRACE("error0");
      return 0;
    }
    if (nameiparent && *path == '\0') {
      // Stop one level early.
      ip->unlock();
      LOG_TRACE("error1");
      return ip;
    }
    if ((next = fs->Lookup(ip, name)) == 0) {
      ip->unlock();
      ip->free();
      return 0;
    }
    ip->unlock();
    ip->free();
    ip = ConvertInodeByMp(next);
    fs = ip->file_system;
  }
  if (nameiparent) {
    ip->free();
    return 0;
  }
  LOG_TRACE("return");
  return ip;
}

struct inode *VfsManager::namei(struct inode *dir, char *path)
{
  if (dir == nullptr) {  // 不指定目录
    LOG_TRACE("name=%s", path);
    if (path[0] == '/') {  // "/"开始，根目录
      dir = root_->dup();
      // ip = namei(root_->dup(), path);
    }
    else {
      LOG_TRACE("openat cwd");  // 当前目录
      dir = myTask()->cwd->dup();
      // ip = namei(myTask()->cwd->dup(), path);
    }
  }
  char name[kMaxFileName];
  LOG_WARN("ip=%s ref=%d", dir->test_name, dir->ref);
  return namex(dir, path, false, name);
}

struct inode *VfsManager::nameiparent(struct inode *dir, char *path, char *name)
{
  return namex(dir, path, true, name);
}

void TestOpenat()
{
  LOG_TRACE("Test Openat");
  char         buf[100];
  struct file *fp = VfsManager::openat(nullptr, (char *)"/dev/tty", O_RDWR, 0);
  printf("enter sometime:");
  VfsManager::read(fp, buf, 5, false);
  printf("read from tty, content=%s\n", buf);
  fp = VfsManager::openat(nullptr, (char *)"/this_is_long_name_file.txt",
                          O_RDWR, 0);
  VfsManager::read(fp, buf, 40, false);
  printf("read from fat32, content=%s\n", buf);
  VfsManager::write(fp, "test text message", 18, false);
  fp->offset = 0;
  VfsManager::read(fp, buf, 100, false);
  printf("read from fat32, content=%s\n", buf);
}
void Test()
{
  TestOpenat();
}
}  // namespace vfs