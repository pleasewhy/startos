#ifndef __RW_DEVICE_HPP
#define __RW_DEVICE_HPP

#include "device/DeviceManager.hpp"

namespace dev{
class RwDevice {
public:
  char name[DEV_NAME_SIZE];

public:
  RwDevice(){};
  ~RwDevice(){};

  /**
   * @brief 读取设备数据
   *
   * @param buf 读取数据缓存区
   * @param offset 读取偏移量
   * @param n 期望读取字节数
   * @return int 实际读取的字节数
   */
  virtual int read(char *buf, int offset, int n);

  /**
   * @brief 向设备写入数据
   *
   * @param buf 写入数据缓存区
   * @param offset 写入偏移量
   * @param n 期望写入数据字节数
   * @return int 实际写入的字节数
   */
  virtual int write(char *buf, int offset, int n);
};
}
#endif