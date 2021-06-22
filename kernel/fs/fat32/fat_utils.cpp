#include "types.hpp"
#include "StartOS.hpp"
#include "fs/fat/fat.hpp"
#include "os/time.hpp"

namespace vfs {
namespace fat32 {
// #if BYTE_ORDER == LITTLE_ENDIAN
#define le16_to_cpu(val) (val)
#define le32_to_cpu(val) (val)
// #endif
// #if BYTE_ORDER == BIG_ENDIAN
// #  define le16_to_cpu(val) bswap_16(val)
// #  define le32_to_cpu(val) bswap_32(val)
// #endif

/*
 * The epoch of FAT timestamp is 1980.
 *     :  bits :     value
 * date:  0 -  4: day	(1 -  31)
 * date:  5 -  8: month	(1 -  12)
 * date:  9 - 15: year	(0 - 127) from 1980
 * time:  0 -  4: sec	(0 -  29) 2sec counts
 * time:  5 - 10: min	(0 -  59)
 * time: 11 - 15: hour	(0 -  23)
 */
#define SECS_PER_MIN 60
#define SECS_PER_HOUR (60 * 60)
#define SECS_PER_DAY (SECS_PER_HOUR * 24)
#define UNIX_SECS_1980 315532800L
// #if BITS_PER_LONG == 64
#define UNIX_SECS_2108 4354819200L
// #endif
/* days between 1.1.70 and 1.1.80 (2 leap days) */
#define DAYS_DELTA (365 * 10 + 2)
/* 120 (2100 - 1980) 不是闰年 */
#define YEAR_2100 120
#define IS_LEAP_YEAR(y) (!((y)&3) && (y) != YEAR_2100)

  // 前n月有多少天，不包含第n月
  static time_t days_in_year[] = {
      /* Jan  Feb  Mar  Apr  May  Jun  Jul  Aug  Sep  Oct  Nov  Dec */
      0, 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 0, 0, 0,
  };

  /**
   * @brief 将FAT时间格式转换为UNIX时间(1970年1月1日之后的经过的秒)
   *
   * @param ts 用于存放计算结果
   * @param __date  FAT时间格式(年月日)
   * @param __time  FAT时间格式(时分秒)
   */
  void FatTime2Unix(struct time::timespec *ts, uint16_t __date, uint16_t __time)
  {
    uint16_t time = le16_to_cpu(__time), date = le16_to_cpu(__date);
    time_t   second, day, leap_day, month, year;

    year = date >> 9;
    month = max(1, ((date >> 5) & 0xf));
    day = max(1, (date & 0x1f)) - 1;

    leap_day = (year + 3) / 4;
    if (year > YEAR_2100) /* 2100 isn't leap year */
      leap_day--;
    if (IS_LEAP_YEAR(year) && month > 2)
      leap_day++;

    second = (time & 0x1f) << 1;
    second += ((time >> 5) & 0x3f) * SECS_PER_MIN;
    second += (time >> 11) * SECS_PER_HOUR;
    second += (year * 365 + leap_day + days_in_year[month] + day + DAYS_DELTA) *
              SECS_PER_DAY;

    ts->tv_sec = second;
    ts->tv_nsec = 0;
  }

  /* Convert linear UNIX date to a FAT time/date pair. */
  void UnixTime2Fat(struct time::timespec *ts, uint16_t *date, uint16_t *time)
  {
    time_t second = ts->tv_sec;
    time_t day, leap_day, month, year;

    /* Jan 1 GMT 00:00:00 1980. But what about another time zone? */
    if (second < UNIX_SECS_1980) {
      *time = 0;
      *date = ((0 << 9) | (1 << 5) | 1);
      return;
    }
    if (second >= UNIX_SECS_2108) {
      *time = ((23 << 11) | (59 << 5) | 29);
      *date = ((127 << 9) | (12 << 5) | 31);
      return;
    }

    day = second / SECS_PER_DAY - DAYS_DELTA;
    year = day / 365;
    leap_day = (year + 3) / 4;
    if (year > YEAR_2100) /* 2100 isn't leap year */
      leap_day--;
    if (year * 365 + leap_day > day)
      year--;
    leap_day = (year + 3) / 4;
    if (year > YEAR_2100) /* 2100 isn't leap year */
      leap_day--;
    day -= year * 365 + leap_day;

    if (IS_LEAP_YEAR(year) && day == days_in_year[3]) {
      month = 2;
    }
    else {
      if (IS_LEAP_YEAR(year) && day > days_in_year[3])
        day--;
      for (month = 1; month < 12; month++) {
        if (days_in_year[month + 1] > day)
          break;
      }
    }
    day -= days_in_year[month];

    *time =
        (((second / SECS_PER_HOUR) % 24) << 11 |
         ((second / SECS_PER_MIN) % 60) << 5 | (second % SECS_PER_MIN) >> 1);
    *date = ((year << 9) | (month << 5) | (day + 1));
  }
}  // namespace fat32
}  // namespace vfs