#ifndef _CLOCK_HPP
#define _CLOCK_HPP

namespace clock {
/**
 * @brief 初始化rtc芯片，并为其设置一个初始
 * 时间
 *
 */
void init();

/**
 * @brief 设置当前时间
 *
 * @param year 年
 * @param month 月
 * @param day 日
 * @param hour 时
 * @param minute 分
 * @param second 秒
 * @return int 成功返回0，失败返回其他
 */
int setDateTime(int year, int month, int day, int hour, int minute, int second);

/**
 * @brief 获取当前时间
 *
 * @param year 年
 * @param month 月
 * @param day 日
 * @param hour 时
 * @param minute 分
 * @param second 秒
 * @return int 成功返回0，失败返回其他
 */
int getDateTime(int *year, int *month, int *day, int *hour, int *minute, int *second);

/**
 * @brief 获取1970年1月1日到现在时间经过的秒数
 *
 * @return uint64_t
 */
uint64_t getTimestamp();

}  // namespace clock
#endif