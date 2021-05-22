#include "types.hpp"
#include "device/Clock.hpp"
#include "common/printk.hpp"
#include "driver/rtc.h"
#include "os/TaskScheduler.hpp"

namespace clock {

bool leapYears[100];  // 1970~2070之间每年和1970年的闰年数量

int setDateTime(int year, int month, int day, int hour, int minute, int second) {
  return rtc_timer_set(year, month, day, hour, minute, second);
}

int getDateTime(int *year, int *month, int *day, int *hour, int *minute, int *second) {
  return rtc_timer_get(year, month, day, hour, minute, second);
}

uint64_t getTimestamp() {
  struct tm *tm = rtc_timer_get_tm();
  int off = tm->tm_year - 1970;
  int lys = leapYears[off - 1];
  uint64_t days = lys * 366 + (off - 1 - lys) * 365 + tm->tm_yday;
  long ts = days * 86400 + tm->tm_hour * 3600 + tm->tm_sec;
  return ts;
}

void initLeapYears() {
  int year = 0;
  year = 1970;
  leapYears[0] = 0;  // 1970不是闰年
  for (int i = 1; i < 100; i++) {
    year = i + 1970;
    if (((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)) {
      leapYears[i] += leapYears[i] + 1;
    } else {
      leapYears[i] += leapYears[i];
    }
  }
}

void init() {
  rtc_init();
  initLeapYears();
  rtc_timer_set(2021, 5, 22, 13, 55, 0);
  // 45763000
}

}  // namespace clock