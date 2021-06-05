#ifndef __VIRTIO_DISK_HPP
#define __VIRTIO_DISK_HPP

#include "device/RwDevice.hpp"

namespace dev {
class VirtioDisk : public RwDevice {
public:
  /**
   * @brief 无参数构造函数, 暂时无用
   */
  VirtioDisk(){};

  /**
   * @brief 无参数构造函数, 暂时无用
   */
  VirtioDisk(const char *name);

  /**
   * @brief 销毁资源，目前无资源
   */
  ~VirtioDisk(){};

  /**
   * @brief 初始化该virtio
   */

  void init();

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

}  // namespace dev
#endif