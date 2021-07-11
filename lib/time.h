#ifndef _TIME_H
#define _TIME_H

/* Identifier for system-wide realtime clock.  */
#define CLOCK_REALTIME 0
/* Monotonic system-wide clock.  */
#define CLOCK_MONOTONIC 1
/* High-resolution timer from the CPU.  */
#define CLOCK_PROCESS_CPUTIME_ID 2
/* Thread-specific CPU-time clock.  */
#define CLOCK_THREAD_CPUTIME_ID 3
/* Monotonic system-wide clock, not adjusted for frequency scaling.  */
#define CLOCK_MONOTONIC_RAW 4
/* Identifier for system-wide realtime clock, updated only on ticks.  */
#define CLOCK_REALTIME_COARSE 5
/* Monotonic system-wide clock, updated only on ticks.  */
#define CLOCK_MONOTONIC_COARSE 6
/* Monotonic system-wide clock that includes time spent in suspension.  */
#define CLOCK_BOOTTIME 7
/* Like CLOCK_REALTIME but also wakes suspended system.  */
#define CLOCK_REALTIME_ALARM 8
/* Like CLOCK_BOOTTIME but also wakes suspended system.  */
#define CLOCK_BOOTTIME_ALARM 9
/* Like CLOCK_REALTIME but in International Atomic Time.  */
#define CLOCK_TAI 11

#define NanoSecond (1)
#define MicroSecond (1000 * NanoSecond)
#define MilliSecond (1000 * MicroSecond)
#define Second (1000 * MilliSecond)

#define SecByMicro Second / MicroSecond
#define MilliByMicro MilliSecond / MicroSecond

struct tm
{
  int tm_sec;   /* Seconds.	[0-60] (1 leap second) */
  int tm_min;   /* Minutes.	[0-59] */
  int tm_hour;  /* Hours.	[0-23] */
  int tm_mday;  /* Day.		[1-31] */
  int tm_mon;   /* Month.	[0-11] */
  int tm_year;  /* Year	- 1900.  */
  int tm_wday;  /* Day of week.	[0-6] */
  int tm_yday;  /* Days in year.[0-365]	*/
  int tm_isdst; /* DST.		[-1/0/1]*/
};

struct tms
{
  long tms_utime;  /* 程序在用户态下运行的时间 */
  long tms_stime;  /* 程序在内核态下运行的时间 */
  long tms_cutime; /* 程序的所有子进程用户态下运行的时间 */
  long tms_cstime; /* 所有子进程内核态下运行的时间 */
};

typedef struct
{
  uint64_t sec;   // 自 Unix 纪元起的秒数
  uint64_t usec;  // 微秒数
} TimeVal;

#endif