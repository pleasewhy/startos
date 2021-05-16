
#include "fs/devfs/DeviceFileSystem.hpp"
#include "device/Console.hpp"

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
  return console.read(reinterpret_cast<uint64_t>(buf), user, n);
}

size_t DeviceFileSystem::write(const char *path, bool user, const char *buf, int offset, int n) {
  // LOG_DEBUG("dev write %d",user);
  return console.write(reinterpret_cast<uint64_t>(buf), user, n);
}

size_t DeviceFileSystem::clear(const char *filepath, size_t count, size_t offset, size_t &written) { return 0; }

size_t DeviceFileSystem::truncate(const char *filepath, size_t size) { return 0; }

int DeviceFileSystem::get_file(const char *filepath, struct file *fp) { return 0; }

size_t DeviceFileSystem::touch(const char *filepath) { return 0; }

size_t DeviceFileSystem::rm(const char *filepath) { return 0; }

int DeviceFileSystem::ls(const char *filepath, char *contents, bool user){return 0;}