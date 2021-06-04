#ifndef __DEVICE_MANAGER_HPP
#define __DEVICE_MANAGER_HPP

#define DEV_NAME_SIZE 10
#define NDEV 10
namespace dev {

/**
 * @brief 初始化设备管理
 * @brief 这会初始化全部设备
 */
void Init();

/**
 * @brief 获取设备的设备号
 *
 * @name 设备名称
 */
int FindDevByName(const char* name);

/**
 * @brief 读设备
 *
 * @param dev 设备号
 */
int RwDevRead(int dev, char* buf, int offset, int n);

/**
 * @brief 写设备
 *
 * @param dev 设备号
 */
int RwDevWrite(int dev, const char* buf, int offset, int n);

}  // namespace dev
#endif