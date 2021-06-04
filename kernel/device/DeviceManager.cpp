#include "device/DeviceManager.hpp"
#include "device/Clock.hpp"
#include "device/Console.hpp"
#include "device/SdCard.hpp"
#include "driver/dmac.hpp"
#include "driver/fpioa.hpp"
#include "fs/disk/Disk.hpp"
#include "common/printk.hpp"
// #include "memory/MemoryPool.hpp"
#include "fs/inodefs/BufferLayer.hpp"
#include "common/string.hpp"

namespace dev {

BufferLayer bufferLayer;
RwDevice *  rw_devs[10];

void Init()
{
  for (int i = 0; i < NDEV; i++) {
    rw_devs[i] = nullptr;
  }
#ifdef K210
  clock::init();  // 初始化实时时钟
  fpioa_pin_init();
  dmac_init();
#endif
  printf("dev init");
  // 文件系统相关
  disk_init();
  SdCard *sd = new SdCard("hda1");
  sd->sdcard_init();
  rw_devs[0] = sd;

  bufferLayer.init();
};

int FindDevByName(const char *dev_name)
{
  printf("dev name=%s\n", dev_name);
  for (int i = 0; i < NDEV; i++) {
    if (rw_devs[i] != nullptr && strcmp(rw_devs[i]->name, dev_name) == 0) {
      return i;
    }
  }
  return 0;
}

/**
 * @brief 读设备
 *
 * @param dev 设备号
 */
int RwDevRead(int dev, char *buf, int offset, int n)
{
  return rw_devs[dev]->read(buf, offset, n);
}

/**
 * @brief 写设备
 *
 * @param dev 设备号
 */
int RwDevWrite(int dev, const char *buf, int offset, int n)
{
  return rw_devs[dev]->write((char *)buf, offset, n);
}

}  // namespace dev