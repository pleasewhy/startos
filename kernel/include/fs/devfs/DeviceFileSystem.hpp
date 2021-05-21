#ifndef DEVICE_FILE_SYSTEM_HPP
#define DEVICE_FILE_SYSTEM_HPP
#include "StartOS.hpp"
#include "common/logger.h"
#include "common/string.hpp"
#include "fs/vfs/FileSystem.hpp"
#include "types.hpp"

struct DeviceFileSystem final : public FileSystem {
 public:
 /**
  * @brief 析构函数
  */
  ~DeviceFileSystem() override{};
  /**
   * @brief 默认构造函数
   */
  DeviceFileSystem(){};

  /**
   * @brief
   */
  DeviceFileSystem(const char *mountPoint, const char *specialDev) {
    safestrcpy(this->mountPoint, mountPoint, strlen(mountPoint) + 1);
    safestrcpy(this->specialDev, specialDev, strlen(specialDev) + 1);
  };

  /**
   * @brief 初始化文件系统
   *
   */
  void init();

  /**
   * @brief 打开一个文件
   *
   * @param filePath
   * @param flags
   * @param fp
   * @return int
   */
  int open(const char *filePath, uint64_t flags, struct file *fp) override;

  /**
   * @brief 从指定文件的指定位置读取n个字节到buf中
   *
   * @param path 文件路径
   * @param buf  保存文件数据的缓冲区
   * @param offset 读取偏移量
   * @param n 期望读取的字节数
   * @return size_t 读取字节数，失败返回-1
   */
  size_t read(const char *path, bool user, char *buf, int offset, int n) override;

  /**
   * @brief 将buf写入到指定文件的指定位置
   *
   * @param path 文件路径
   * @param buf 需要写入的数据
   * @param offset 写入偏移量
   * @param n 写入字节数
   * @return size_t 写入字节数，失败返回-1
   */
  size_t write(const char *path, bool user, const char *buf, int offset, int n) override;

  /**
   * @brief Clear a portion of a file (write zeroes)
   * @param filepath The path to the file to write
   * @param count The amount of bytes to write
   * @param offset The offset at which to start writing
   * @param written output reference to indicate the number of bytes written
   * @return 0 on success, an error code otherwise
   */
  size_t clear(const char *filepath, size_t count, size_t offset, size_t &written) override;

  /**
   * @brief 截断文件
   * @param filepath 需要截断文件的绝对路径
   * @param size 文件的新路径
   * @return 成功返回0，失败返回-1
   */
  size_t truncate(const char *filepath, size_t size) override;

  /**
   * @brief 通过文件路径获取文件信息
   * @param filepath 文件的绝对路径
   * @param fp 指向文件信息指针
   * @return 0成功，-1，失败
   */
  int get_file(const char *filepath, struct file *fp) override;

  /**
   * @brief 获取给定目录下的目录项
   * @param filepath 目录的绝对路径
   * @param contents
   * @return 返回该目录下的目录项的数量
   */
  int ls(const char *filepath, char *contents, bool user = false) override;

  /**
   * @brief Create the given file on the file system
   * @param filepath The path to the file to create
   * @return 0 on success, an error code otherwise
   */
  size_t touch(const char *filepath) override;

  /**
   * @brief Create the given directory on the file system
   * @param filepath The path to the directory to create
   * @return 0 on success, an error code otherwise
   */
  int mkdir(const char *filepath) override;

  /**
   * @brief Remove the given file from the file system
   * @param filepath The path to the file to remove
   * @return 0 on success, an error code otherwise
   */
  size_t rm(const char *filepath) override;
};
#endif