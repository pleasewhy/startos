#include "device/Clock.hpp"
#include "common/printk.hpp"
#include "driver/rtc.h"
#include "driver/sysctl.hpp"
#include "os/TaskScheduler.hpp"
#include "time.h"
#include "types.hpp"

namespace clock {

int      leapYears[100];  // 1970~2070之间每年和1970年的闰年数量
uint32_t freq;
int setDateTime(int year, int month, int day, int hour, int minute, int second)
{
  return rtc_timer_set(year, month, day, hour, minute, second);
}

int getDateTime(
    int *year, int *month, int *day, int *hour, int *minute, int *second)
{
  return rtc_timer_get(year, month, day, hour, minute, second);
}

// 时间系统
void getTimeVal(TimeVal &timeVal)
{
  struct tm *tm = rtc_timer_get_tm();

  int      off = tm->tm_year - 70;  // tm->tm_year = year - 1900
  int      leaps = leapYears[off - 1];
  uint64_t days = leaps * 366 + (off - leaps) * 365 + tm->tm_yday;
  uint64_t sec = days * 86400 + tm->tm_hour * 3600 + tm->tm_sec;
  uint32_t count = rtc_timer_get_clock_count_value();

  uint64_t us = (count % freq) / (freq / 1000000);
  timeVal.sec = sec;
  timeVal.usec = us;
}

void initLeapYears()
{
  int year = 0;
  year = 1970;
  leapYears[0] = 0;  // 1970不是闰年
  for (int i = 1; i < 100; i++) {
    year = i + 1970;
    if (((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)) {
      leapYears[i] = leapYears[i - 1] + 1;
    }
    else {
      leapYears[i] = leapYears[i - 1];
    }
    // printf("leap years=%d\n", leapYears[i]);
  }
}

void init()
{
  rtc_init();
  initLeapYears();
  freq = sysctl_clock_get_freq(SYSCTL_CLOCK_IN0);
  rtc_timer_set(2021, 6, 1, 23, 59, 59);
  printf("rtc init\n");
  // 45763000
}

}  // namespace clock