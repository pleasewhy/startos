#ifndef _OS_TIME_HPP
#define _OS_TIME_HPP

#include "types.hpp"

namespace time {
struct timespec
{
  uint64_t tv_sec;  /* seconds */
  uint64_t tv_nsec; /* nanoseconds */
};

unsigned long mktime(const unsigned int year,
                     const unsigned int mon,
                     const unsigned int day,
                     const unsigned int hour,
                     const unsigned int min,
                     const unsigned int sec);

void CurrentTimeSpec(struct timespec *ts);
}  // namespace time
#endif