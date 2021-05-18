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
SpinLock fileTableLock;
FileSystem *mountedFS[NFILESYSTEM];

FileSystem *createFileSystem(FileSystemType type, const char *mountPoint, const char *dev) {
  switch (type) {
    case FileSystemType::DEVFS:
      return new DeviceFileSystem(mountPoint, dev);
    case FileSystemType::FAT32:
      return new Fat32FileSystem(mountPoint, dev);
    default:
      panic("create file system");
      break;
  }
  return nullptr;
}

struct file *allocFileHandle() {
  fileTableLock.lock();
  struct file *fp;
  for (fp = fileTable; fp < fileTable + NFILE; fp++) {
    if (fp->type == fp->FD_NONE) {
      fileTableLock.unlock();
      return fp;
    }
  }
  panic("alloc file");
  return NULL;
}

void freeFileHandle(struct file *f) { memset(f, 0, sizeof(struct file)); }

/**
 * @brief 找到filepath所属的文件系统
 *
 * @param filepath
 * @return FileSystem*
 */
FileSystem *getFs(const char *filepath) {
  int bestMatch = 0;
  int bestLength = 0;
  // 找出最适配的文件系统
  for (size_t i = 0; i < NFILESYSTEM; ++i) {
    if (mountedFS[i] == NULL) continue;

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
 * @brief 计算oldpath的绝对路径
 */
void getAbsolutePath(char *oldpath, char *newPath) {
  const char *curdir = myTask()->currentDir;

  if (oldpath[0] == '/') {
    memcpy(newPath, oldpath, strlen(oldpath));
  } else {
    myTask()->lock.lock();
    memcpy(newPath, curdir, strlen(curdir));
    memcpy(newPath + strlen(curdir), oldpath, strlen(oldpath));
    myTask()->lock.unlock();
  }
}

void calAbsolute(char *oldpath) {
  char newPath[MAXPATH];
  memset(newPath, 0, MAXPATH);
  const char *curdir = myTask()->currentDir;

  if (oldpath[0] == '/') {
    memcpy(newPath, oldpath, strlen(oldpath));
  } else {
    myTask()->lock.lock();
    memcpy(newPath, curdir, strlen(curdir));
    memcpy(newPath + strlen(curdir), oldpath, strlen(oldpath));
    myTask()->lock.unlock();
  }
  memcpy(oldpath, newPath, sizeof(newPath));
}

/**
 * @brief 初始化虚拟文件系统，其将会初始化fileSystems和fileTable,
 *
 */
void init() {
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

  mount(FileSystemType::DEVFS, "/dev", "");
  mount(FileSystemType::FAT32, "/", "/dev/hda1");
}

int open(const char *filename, size_t flags) {
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
  fp->ref++;
  int fd = registerFileHandle(fp);
  LOG_DEBUG("fd=%d fp=%p fp->ref=%d", fd, fp);
  return fd;
}

size_t read(int fd, bool user, char *dst, size_t n, size_t offset) {
  int r = 0;
  struct file *f = getFileByfd(fd);
  if (f == NULL || !f->readable) {
    return -1;
  }
  auto fs = getFs(f->filepath);

  // if () strncpy(path, dir, strlen(dir));
  // strncpy(path + strlen(dir), f->file_name, strlen(f->file_name));

  LOG_DEBUG("read filename=%s", f->filepath);

  switch (f->type) {
    case f->FD_PIPE:
      // r = piperead(f->pipe, addr, n);
      panic("vfs::read");
      break;
    case f->FD_DEVICE:
      // if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read) return -1;
      // r = devsw[f->major].read(1, addr, n);
      r = fs->read(f->filepath, user, dst, 0, n);
      break;
    case f->FD_ENTRY:
      r = fs->read(f->filepath, user, dst, f->position, n);
      break;
    default:
      panic("vfs::read");
  }
  return r;
}

size_t write(int fd, bool user, const char *buffer, size_t count, size_t offset) {
  int r = 0;
  struct file *f = getFileByfd(fd);

  if (f == NULL || !f->readable) {
    return -1;
  }

  auto fs = getFs(f->filepath);

  if (f == NULL || !f->writable) {
    return -1;
  }

  // LOG_DEBUG("write filename=%s", f->filepath);

  switch (f->type) {
    case f->FD_PIPE:
      // r = piperead(f->pipe, addr, n);
      panic("vfs::write");
      break;
    case f->FD_DEVICE:
      r = fs->write(f->filepath, user, buffer, 0, count);
      break;
    case f->FD_ENTRY:
      // fat32->read(f->filepath, user, dst, f->position, 0);
      fs->write(f->filepath, user, buffer, 0, count);
      break;
    default:
      panic("vfs::write");
      return 0;
  }
  return r;
}

// 递减ref，当ref = 0时关闭
void close(struct file *fp) {
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
  fp->type = fp->FD_NONE;
  fp->ref = 0;
  fileTableLock.unlock();

  if (ff.type == ff.FD_PIPE) {
  } else if (ff.type == ff.FD_ENTRY) {
  } else if (ff.type == ff.FD_DEVICE) {
  }
};

int mkdirat(int dirfd, const char *filepath) {
  char path[MAXPATH];
  memset(path, 0, MAXPATH);
  struct file *fp;
  if (dirfd == AT_FDCWD) {
    getAbsolutePath((char *)filepath, path);
  } else {
    if (filepath[0] == '/') {
      memcpy(path, filepath, strlen(filepath));
    } else {
      fp = getFileByfd(dirfd);
      memcpy(path, fp->filepath, strlen(fp->filepath));
      memcpy(path + strlen(fp->filepath), filepath, strlen(filepath));
    }
  }
  LOG_DEBUG("mkdir=%s\n", path);
  auto fs = getFs(path);
  return fs->mkdir(path);
  // return 0;
};

int openat(int dirfd, const char *filepath, int flags) {
  char path[MAXPATH];
  memset(path, 0, MAXPATH);
  struct file *fp;
  if (dirfd == AT_FDCWD) {
    getAbsolutePath((char *)filepath, path);
  } else {
    if (filepath[0] == '/') {
      memcpy(path, filepath, strlen(filepath));
    } else {
      fp = getFileByfd(dirfd);
      memcpy(path, fp->filepath, strlen(fp->filepath));
      memcpy(path + strlen(fp->filepath), filepath, strlen(filepath));
    }
  }
  LOG_DEBUG("openat=%s", path);
  return open(filepath, flags);
}

void rm(const char *file){};

size_t clear(int fd, size_t count, size_t offset) { return 0; }

void truncate(int fd, size_t size) {}

size_t ls(int fd, char *buffer, bool user = false) {
  struct file *fp = getFileByfd(fd);
  if (fp == NULL || !fp->directory) {
    LOG_DEBUG("not directory");
    return -1;
  }
  auto fs = getFs(fp->filepath);
  LOG_DEBUG("ls");
  return fs->ls(fp->filepath, buffer, user);
}

size_t mounts(char *buffer, size_t size) { return 0; }

void mount(FileSystemType type, const char *mountPoint, const char *device) {
  auto fs = createFileSystem(type, mountPoint, device);
  fs->init();
  for (int i = 0; i < NFILESYSTEM; i++) {
    if (mountedFS[i] == NULL) {
      mountedFS[i] = fs;
      return;
    }
  }
  panic("mount file system");
}

size_t direct_read(const char *file, char *buffer, size_t count, size_t offset) {
  auto fs = getFs(file);
  LOG_TRACE("fs mount point=%s", fs->mountPoint);
  int r = fs->read(file, false, buffer, offset, count);
  LOG_TRACE("bytes of read=%d", r);
  return r;
}
size_t direct_write(const char *file, const char *buffer, size_t count, size_t offset) { return 0; }

struct file *dup(struct file *fp) {
  fileTableLock.lock();
  if (fp->ref < 1) {
    panic("vfs::dup");
    panic("vfs::dup");
  }
  fp->ref++;
  fileTableLock.unlock();
  return fp;
}

int chdir(char *filepath) {
  char path[MAXPATH];
  Task *task = myTask();

  memset(path, 0, MAXPATH);
  struct file *fp = allocFileHandle();
  getAbsolutePath((char *)filepath, path);
  auto fs = getFs(path);

  if (fs->open(path, O_RDONLY, fp) < 0) {
    return -1;
  }

  if (!fp->directory) {
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

}  // namespace vfs