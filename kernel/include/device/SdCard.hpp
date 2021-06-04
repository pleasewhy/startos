#ifndef __SDCARD_H
#define __SDCARD_H

#include "device/RwDevice.hpp"
#include "os/SleepLock.hpp"
#include "types.hpp"

class SdCard : public RwDevice {
 private:
  SleepLock sleepLock;

 public:
  SdCard(const char *name);
  ~SdCard(){};

  /**
   * @brief 初始化sd卡
   *
   */
  void sdcard_init(void);

  /**
   * @brief 读取sd卡的指定扇区
   *
   * @param buf 读取数据缓存区
   * @param sectorno 读取扇区号
   */
  void sdcard_read_sector(char *buf, int sectorno);

  /**
   * @brief 写sd卡指定扇区
   *
   * @param buf 写入数据缓存区
   * @param sectorno 写入扇区数
   */
  void sdcard_write_sector(char *buf, int sectorno);

  /**
   * @brief device/RwDevice.hpp:read
   *
   */
  virtual int read(char *buf, int offset, int n) override;

  /**
   * @brief device/RwDevice.hpp:write
   *
   */
  virtual int write(char *buf, int offset, int n) override;
};

#endif