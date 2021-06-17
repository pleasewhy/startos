#include "os/time.hpp"
#include "driver/rtc.h"
#include "driver/sysctl.hpp"

namespace time {
/**
 * @brief 将格林高利时间转化为自1970-01-01 00:00:00以来的seconds。
 *这里假定输入的参数是一个合法的日期格式，i.e.1980-12-31 23:59:59
 * => year=1980, mon=12, day=31, hour=23, min=59, sec=59.
 *
 *
 * @param year0
 * @param mon0
 * @param day
 * @param hour
 * @param min
 * @param sec
 * @return unsigned long
 */
unsigned long mktime(const unsigned int year0,
                     const unsigned int mon0,
                     const unsigned int day,
                     const unsigned int hour,
                     const unsigned int min,
                     const unsigned int sec)
{
  unsigned int mon = mon0, year = year0;

  /* 1..12 -> 11,12,1..10 */
  if (0 >= (int)(mon -= 2)) {
    mon += 12; /* Puts Feb last since it has leap day */
    year -= 1;
  }

  return ((((unsigned long)(year / 4 - year / 100 + year / 400 +
                            367 * mon / 12 + day) +
            year * 365 - 719499) *
               24 +
           hour /* now have hours */
           ) * 60 +
          min /* now have minutes */
          ) * 60 +
         sec; /* finally seconds */

  // return ((((unsigned long)
  // 	  (year/4 - year/100 + year/400 + 367*mon/12 + day) +
  // 	  year*365 - 719499
  //     )*24 + hour /* now have hours */
  //   )*60 + min /* now have minutes */
  // )*60 + sec; /* finally seconds */
}

/**
 * @brief 获取当前时间
 *
 */
void CurrentTimeSpec(struct timespec *ts)
{
#ifdef K210
  int year, month, day, hour, minute, second;
  rtc_timer_get(&year, &month, &day, &hour, &minute, &second);
  long unix_time = mktime(year, month, day, hour, minute, second);
  ts->tv_sec = unix_time;
  uint32_t count = rtc_timer_get_clock_count_value();
  uint32_t freq = sysctl_clock_get_freq(SYSCTL_CLOCK_IN0);
  uint64_t us = (count % freq) / (freq / 1000000);
#else
  ts->tv_nsec = 1234567;
  ts->tv_sec = 1623832156;
#endif
}

}  // namespace time