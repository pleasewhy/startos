#include "fs/vfs/Vfs.hpp"

#include "common/logger.h"
#include "common/printk.hpp"
#include "common/string.hpp"
#include "fcntl.h"
#include "fs/devfs/DeviceFileSystem.hpp"
#include "fs/fat/Fat32.hpp"
#include "os/SpinLock.hpp"
#include "os/TaskScheduler.hpp"
#include "param.hpp"

// Fat32FileSystem *fat32;
// DeviceFileSystem *devFs;

namespace vfs {

struct file fileTable[NFILE];
SpinLock    fileTableLock;
FileSystem *mountedFS[NFILESYSTEM];
SpinLock    mountedFsLock;

FileSystem *createFileSystem(FileSystemType type,
                             const char *   mountPoint,
                             const char *   specialDev)
{
  switch (type) {
    case FileSystemType::DEVFS:
      return new DeviceFileSystem(mountPoint, specialDev);
    case FileSystemType::FAT32:
      return new Fat32FileSystem(mountPoint, specialDev);
    default: panic("create file system"); break;
  }
  return nullptr;
}

struct file *allocFileHandle()
{
  fileTableLock.lock();
  struct file *fp;
  for (fp = fileTable; fp < fileTable + NFILE; fp++) {
    if (fp->ref == 0 && fp->type == fp->FD_NONE) {
      fileTableLock.unlock();
      fp->ref = 1;
      return fp;
    }
  }
  panic("alloc file");
  return NULL;
}

void freeFileHandle(struct file *f)
{
  memset(f, 0, sizeof(struct file));
  f->type = f->FD_NONE;
}

/**
 * @brief 找到filepath所属的文件系统
 *
 * @param filepath
 * @return FileSystem*
 */
FileSystem *getFs(const char *filepath)
{
  int bestMatch = 0;
  int bestLength = 0;
  // 找出最适配的文件系统
  for (size_t i = 0; i < NFILESYSTEM; ++i) {
    if (mountedFS[i] == NULL)
      continue;

    auto &mp = mountedFS[i];

    bool match = true;
    for (size_t j = 0; mp->mountPoint[j] != 0 && filepath[i] != 0; ++j) {
      if (mp->mountPoint[j] != filepath[j]) {
        match = false;
        break;
      }
    }

    if (match && strlen(mp->mountPoint) > bestLength) {
      bestLength = strlen(mp->mountPoint);
      bestMatch = i;
    }
  }
  return mountedFS[bestMatch];
}

/**
 * @brief 计算oldpath的绝对路径，newpath用于新的路径
 */
void getAbsolutePath(const char *path, char *newPath)
{
  const char *curdir = myTask()->currentDir;
  const char *oldpath = path;
  memset(newPath, 0, MAXPATH);

  if (oldpath[0] == '.' && oldpath[1] == '/') {
    oldpath += 2;
  }

  if (oldpath[0] == '/') {
    memmove(newPath, oldpath, strlen(oldpath));
  }
  else {
    myTask()->lock.lock();
    memmove(newPath, curdir, strlen(curdir));
    memmove(newPath + strlen(curdir), oldpath, strlen(oldpath));
    myTask()->lock.unlock();
  }
}

/**
 * @brief 获取绝对路径原地修改
 *
 * @param path
 */
void calAbsolute(char *path)
{
  char  newPath[MAXPATH];
  char *oldpath = path;
  memset(newPath, 0, MAXPATH);
  const char *curdir = myTask()->currentDir;

  if (oldpath[0] == '.' && oldpath[1] == '/') {
    oldpath += 2;
  }

  if (oldpath[0] == '/') {
    memmove(newPath, oldpath, strlen(oldpath));
  }
  else {
    myTask()->lock.lock();
    memmove(newPath, curdir, strlen(curdir));
    memmove(newPath + strlen(curdir), oldpath, strlen(oldpath));
    myTask()->lock.unlock();
  }
  memmove(path, newPath, sizeof(newPath));
}

/**
 * @brief 初始化虚拟文件系统，其将会初始化fileSystems和fileTable,
 *
 */
void init()
{
  LOG_TRACE("enter func: vfs init");
  struct file *fp;

  // 初始化mountedFS
  for (int i = 0; i < NFILESYSTEM; i++) {
    mountedFS[i] = NULL;
  }

  // 初始化filetable
  memset(fileTable, 0, sizeof(struct file) * NFILE);
  for (fp = fileTable; fp < fileTable + NFILE; fp++) {
    fp->type = fp->FD_NONE;
  }
  fileTableLock.init("fileTable");

  mountedFsLock.init("mount fs");
  mount(FileSystemType::DEVFS, "/dev", "");
  mount(FileSystemType::FAT32, "/", "/dev/hda1");
}

int open(const char *filename, size_t flags)
{
  char path[MAXPATH];
  memset(path, 0, MAXPATH);
  getAbsolutePath((char *)filename, path);

  auto fs = getFs(path);
  LOG_DEBUG("open path=%s, fs mount point=%s", path, fs->mountPoint);
  struct file *fp = allocFileHandle();
  if (fs->open(path, flags, fp) == -1) {
    freeFileHandle(fp);
    return -1;
  }

  safestrcpy(fp->filepath, path, strlen(path) + 1);
  fp->readable = !(flags & O_WRONLY);
  fp->writable = (flags & O_WRONLY) || (flags & O_RDWR);
  int fd = registerFileHandle(fp);
  LOG_DEBUG("fd=%d fp=%p fp->ref=%d sz=%d", fd, fp, fp->ref, fp->size);
  return fd;
}

// 打开指定目录下的文件
int openat(int dirfd, const char *filename, size_t flags, mode_t mode)
{
  struct file *dir_fp = getFileByfd(dirfd);
  if (dir_fp == nullptr) {
    return -1;
  }

  // 打开文件的绝对路径
  char path[MAXPATH];
  memset(path, 0, MAXPATH);
  strncpy(path, dir_fp->filepath, strlen(dir_fp->filepath));
  path[strlen(dir_fp->filepath)] = '/';
  memmove(path + strlen(dir_fp->filepath) + 1, filename, strlen(filename));

  auto fs = getFs(path);
  LOG_DEBUG("openat dir path=%s, fs mount point=%s", path, fs->mountPoint);
  struct file *fp = allocFileHandle();
  if (fs->open(path, flags, fp) == -1) {
    freeFileHandle(fp);
    return -1;
  }

  safestrcpy(fp->filepath, path, strlen(path) + 1);
  fp->readable = !(flags & O_WRONLY);
  fp->writable = (flags & O_WRONLY) || (flags & O_RDWR);
  int fd = registerFileHandle(fp);
  LOG_DEBUG("fd=%d fp=%p fp->ref=%d sz=%d", fd, fp, fp->ref, fp->size);
  return fd;
}

size_t read(int fd, bool user, char *dst, size_t n, size_t offset)
{
  struct file *f = getFileByfd(fd);
  if (f == NULL || !f->readable) {
    return -1;
  }
  return read(f, user, dst, n, offset);
}

size_t read(struct file *fp, bool user, char *dst, size_t n, size_t offset)
{
  int r = 0;
  if (fp == NULL || !fp->readable) {
    return -1;
  }
  auto fs = getFs(fp->filepath);

  // if () strncpy(path, dir, strlen(dir));
  // strncpy(path + strlen(dir), f->file_name, strlen(f->file_name));

  LOG_DEBUG("read filename=%s", fp->filepath);

  switch (fp->type) {
    case fp->FD_PIPE:
      r = fp->pipe->read(reinterpret_cast<uint64_t>(dst), n);
      break;
    case fp->FD_DEVICE: r = fs->read(fp->filepath, user, dst, 0, n); break;
    case fp->FD_ENTRY:
      r = fs->read(fp->filepath, user, dst, fp->offset, n);
      fp->offset += r;
      break;
    default: panic("vfs::read");
  }
  return r;
}

size_t write(int fd, bool user, const char *src, size_t n, size_t offset)
{
  struct file *f = getFileByfd(fd);

  if (f == NULL || !f->writable) {
    return -1;
  }
  return write(f, user, src, n, offset);
}

size_t
write(struct file *fp, bool user, const char *src, size_t n, size_t offset)
{
  int r = 0;

  if (fp == NULL || !fp->writable) {
    return -1;
  }

  auto fs = getFs(fp->filepath);

  // LOG_DEBUG("write filename=%s", fp->filepath);

  switch (fp->type) {
    case fp->FD_PIPE:
      r = fp->pipe->write(reinterpret_cast<uint64_t>(src), n);
      break;
    case fp->FD_DEVICE: r = fs->write(fp->filepath, user, src, 0, n); break;
    case fp->FD_ENTRY:
      // fat32->read(fp->filepath, user, dst, fp->offset, 0);
      r = fs->write(fp->filepath, user, src, fp->offset, n);
      LOG_DEBUG("write file sz=%d pos=%d r=%d n=%d", fp->size, fp->offset, r,
                n);
      fp->size = fp->offset + r < fp->size ? fp->size : fp->offset + r;
      fp->offset += r;
      break;
    default: panic("vfs::write"); return 0;
  }
  return r;
}

// 递减ref，当ref = 0时关闭
void close(struct file *fp)
{
  struct file ff;
  fileTableLock.lock();
  if (fp->ref < 1) {
    panic("vfs::close");
  }
  if (--fp->ref > 0) {
    fileTableLock.unlock();
    return;
  }
  ff = *fp;
  freeFileHandle(fp);

  fileTableLock.unlock();

  if (ff.type == ff.FD_PIPE) {
    if (ff.writable)
      ff.pipe->close(ff.pipe->WRITE_END);
    if (ff.readable)
      ff.pipe->close(ff.pipe->READ_END);
  }
  else if (ff.type == ff.FD_ENTRY) {
  }
  else if (ff.type == ff.FD_DEVICE) {
  }
};

int mkdirat(int dirfd, const char *filepath)
{
  char path[MAXPATH];
  memset(path, 0, MAXPATH);
  struct file *fp;
  if (dirfd == AT_FDCWD) {
    getAbsolutePath((char *)filepath, path);
  }
  else {
    if (filepath[0] == '/') {
      memmove(path, filepath, strlen(filepath));
    }
    else {
      fp = getFileByfd(dirfd);
      memmove(path, fp->filepath, strlen(fp->filepath));
      memmove(path + strlen(fp->filepath), filepath, strlen(filepath));
    }
  }
  LOG_DEBUG("mkdir=%s\n", path);
  auto fs = getFs(path);
  return fs->mkdir(path);
  // return 0;
};

int openat(int dirfd, const char *filepath, int flags)
{
  char path[MAXPATH];
  memset(path, 0, MAXPATH);
  struct file *fp = NULL;
  if (dirfd == AT_FDCWD) {
    getAbsolutePath((char *)filepath, path);
  }
  else {
    if (filepath[0] == '/') {
      memmove(path, filepath, strlen(filepath));
    }
    else {
      fp = getFileByfd(dirfd);
      memmove(path, fp->filepath, strlen(fp->filepath));
      memmove(path + strlen(fp->filepath), filepath, strlen(filepath));
    }
  }
  LOG_DEBUG("openat dir=%s", path);
  return open(filepath, flags);
}

int rm(int dirfd, char *filepath)
{
  char path[MAXPATH];
  memset(path, 0, MAXPATH);
  struct file *fp = NULL;
  if (dirfd == AT_FDCWD) {
    getAbsolutePath((char *)filepath, path);
  }
  else {
    if (filepath[0] == '/') {
      memmove(path, filepath, strlen(filepath));
    }
    else {
      fp = getFileByfd(dirfd);
      memmove(path, fp->filepath, strlen(fp->filepath));
      memmove(path + strlen(fp->filepath), filepath, strlen(filepath));
    }
  }
  // TODO 判断是否被打开
  // for(int i=0;i<NFILE;i++){
  //   fileTable[i].
  // }
  auto fs = getFs(path);
  LOG_DEBUG("rm path=%s, fs mount point=%s", path, fs->mountPoint);
  return fs->rm(path);
};

size_t ls(int fd, char *buffer, int len, bool user = false)
{
  struct file *fp = getFileByfd(fd);
  if (fp == NULL || !fp->directory) {
    LOG_DEBUG("not directory");
    return -1;
  }
  auto fs = getFs(fp->filepath);
  LOG_DEBUG("ls");
  return fs->ls(fp->filepath, buffer, len, user);
}

size_t mounts(char *buffer, size_t size)
{
  return 0;
}

int mount(FileSystemType type, const char *mountPoint, const char *specialDev)
{
  char absolutMp[MAXPATH];
  getAbsolutePath(mountPoint, absolutMp);
  auto fs = createFileSystem(type, absolutMp, specialDev);
  fs->init();
  mountedFsLock.lock();
  for (int i = 0; i < NFILESYSTEM; i++) {
    if (mountedFS[i] == NULL) {
      mountedFsLock.unlock();
      LOG_DEBUG("mount fs: specialDev = %s mount point=%s", specialDev,
                fs->mountPoint);
      mountedFS[i] = fs;
      return 0;
    }
  }
  mountedFsLock.unlock();
  panic("mount file system");
  return -1;
}

int umount(const char *mpdir)
{
  char        absolutMp[MAXPATH];
  FileSystem *fs;

  getAbsolutePath(mpdir, absolutMp);

  int absolutMpLen = strlen(absolutMp);
  int n = 0;
  mountedFsLock.lock();
  for (int i = 0; i < NFILESYSTEM; i++) {
    fs = mountedFS[i];
    if (fs == NULL) {
      continue;
    }
    n = strlen(fs->mountPoint);
    if (strncmp(fs->mountPoint, absolutMp, max(n, absolutMpLen)) == 0) {
      mountedFS[i] = NULL;
      mountedFsLock.unlock();
      LOG_DEBUG("umount fs: specialDev = %s mount point=%s", fs->specialDev,
                fs->mountPoint);
      delete fs;
      return 0;
    }
  }
  mountedFsLock.unlock();
  return -1;
}

size_t direct_read(const char *file, char *buffer, size_t count, size_t offset)
{
  auto fs = getFs(file);
  LOG_TRACE("fs mount point=%s", fs->mountPoint);
  int r = fs->read(file, false, buffer, offset, count);
  LOG_TRACE("bytes of read=%d", r);
  return r;
}

size_t
direct_write(const char *file, const char *buffer, size_t count, size_t offset)
{
  auto fs = getFs(file);
  LOG_TRACE("fs mount point=%s", fs->mountPoint);
  int r = fs->write(file, false, buffer, offset, count);
  LOG_TRACE("bytes of write=%d", r);
  return r;
}

struct file *dup(struct file *fp)
{
  fileTableLock.lock();
  LOG_DEBUG("error");
  if (fp->ref < 1) {
    panic("vfs::dup");
  }
  fp->ref++;
  fileTableLock.unlock();
  return fp;
}

int chdir(char *filepath)
{
  char  path[MAXPATH];
  Task *task = myTask();

  memset(path, 0, MAXPATH);
  struct file *fp = allocFileHandle();
  getAbsolutePath((char *)filepath, path);
  auto fs = getFs(path);

  if (fs->open(path, O_RDONLY, fp) < 0) {
    return -1;
  }

  if (!fp->directory) {
    LOG_DEBUG("chdir a file=%s", path);
    freeFileHandle(fp);
    return -1;
  }

  int n = strlen(path);
  if (path[n - 1] != '/') {
    path[n] = '/';
    path[n + 1] = 0;
  }
  task->lock.lock();
  safestrcpy(task->currentDir, path, strlen(path) + 1);
  task->lock.unlock();
  freeFileHandle(fp);
  return 0;
}

int createPipe(int fds[])
{
  struct file *f0 = allocFileHandle();
  struct file *f1 = allocFileHandle();
  Pipe *       pipe = new Pipe(f0, f1);
  if (pipe == NULL) {
    freeFileHandle(f0);
    freeFileHandle(f1);
    return -1;
  }
  int fd0 = registerFileHandle(f0);
  int fd1 = registerFileHandle(f1);
  fds[0] = fd0;
  fds[1] = fd1;
  return 0;
}

struct file *rewind(struct file *fp)
{
  fileTableLock.lock();
  if (fp->ref < 1)
    panic("filerewind");
  fp->offset = 0;
  fileTableLock.unlock();
  return fp;
}

}  // namespace vfs