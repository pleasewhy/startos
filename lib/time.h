#ifndef _TIME_H
#define _TIME_H
struct tm {
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
	long tms_utime; /* 程序在用户态下运行的时间 */
	long tms_stime; /* 程序在内核态下运行的时间 */
	long tms_cutime; /* 程序的所有子进程用户态下运行的时间 */
	long tms_cstime; /* 所有子进程内核态下运行的时间 */
};

typedef struct
{
    uint64_t sec;  // 自 Unix 纪元起的秒数
    uint64_t usec; // 微秒数
} TimeVal;

#endif