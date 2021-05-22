
#include "fs/devfs/DeviceFileSystem.hpp"
#include "device/Console.hpp"
#include "fs/disk/Disk.hpp"
#include "fs/disk/SdCard.hpp"

extern Console console;
void DeviceFileSystem::init() {}

int DeviceFileSystem::open(const char *filePath, uint64_t flags, struct file *fp) {
  fp->type = fp->FD_DEVICE;
  fp->directory = false;
  return 0;
}

int DeviceFileSystem::mkdir(const char *filepath) {
  LOG_WARN("dev fs not support mkdir");
  return -1;
}

size_t DeviceFileSystem::read(const char *path, bool user, char *buf, int offset, int n) {
  // LOG_DEBUG("dev read");
  if (strncmp(path, "/dev/tty", strlen(path)) == 0) {
    return console.read(reinterpret_cast<uint64_t>(buf), user, n);
  }
#ifdef K210
  else if (strncmp(path, "/dev/vda2", strlen(path)) == 0) {
    sdcard_read_sector(reinterpret_cast<uint8_t *>(buf), offset / 512);
  } else if (strncmp(path, "/dev/hda1", strlen("/dev/hda1")) == 0) {
    // LOG_DEBUG("read hda1");
    sdcard_read_sector(reinterpret_cast<uint8_t *>(buf), offset / 512);
  } else {
    panic("not support path");
  }
#endif
  return 0;
}

size_t DeviceFileSystem::write(const char *path, bool user, const char *buf, int offset, int n) {
  if (strncmp(path, "/dev/tty", strlen(path)) == 0) {
    return console.write(reinterpret_cast<uint64_t>(buf), user, n);
  }
#ifdef K210
  else if (strncmp(path, "/dev/vda2", strlen("/dev/vda2")) == 0) {
    sdcard_write_sector((uint8_t *)(buf), offset / 512);
  } else if (strncmp(path, "/dev/hda1", strlen("/dev/hda1")) == 0) {
    sdcard_write_sector((uint8_t *)(buf), offset / 512);
  } else {
    panic("not support path");
  }
#endif
  return 0;
}

size_t DeviceFileSystem::clear(const char *filepath, size_t count, size_t offset, size_t &written) { return 0; }

size_t DeviceFileSystem::truncate(const char *filepath, size_t size) { return 0; }

int DeviceFileSystem::get_file(const char *filepath, struct file *fp) { return 0; }

size_t DeviceFileSystem::touch(const char *filepath) { return 0; }

size_t DeviceFileSystem::rm(const char *filepath) { return 0; }

int DeviceFileSystem::ls(const char *filepath, char *contents, int len,bool user) { return 0; }