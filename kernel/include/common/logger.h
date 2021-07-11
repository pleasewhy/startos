#ifndef LOGGER_HPP
#define LOGGER_HPP

using cstr = const char *;
#include "common/printk.hpp"

// 日志打印级别
#define LOG_LEVEL_OFF  1000
#define LOG_LEVEL_ERROR  500
#define LOG_LEVEL_WARN  400
#define LOG_LEVEL_INFO  300
#define LOG_LEVEL_DEBUG  200
#define LOG_LEVEL_TRACE  100
#define LOG_LEVEL_ALL  0

// https://blog.galowicz.de/2016/02/20/short_file_macro/
// 缩短__FILE__宏的长度
static constexpr cstr PastLastSlash(cstr a, cstr b) {
  return *a == '\0' ? b : *b == '/' ? PastLastSlash(a + 1, a + 1) : PastLastSlash(a + 1, b);
}

static constexpr cstr PastLastSlash(cstr a) { return PastLastSlash(a, a); }

#define __SHORT_FILE__                            \
  ({                                              \
    constexpr cstr sf__{PastLastSlash(__FILE__)}; \
    sf__;                                         \
  })

#ifndef LOG_LEVEL
// #define LOG_LEVEL  LOG_LEVEL_DEBUG
// #define LOG_LEVEL  LOG_LEVEL_TRACE
// #define LOG_LEVEL  LOG_LEVEL_INFO
// #define LOG_LEVEL  LOG_LEVEL_ERROR
#define LOG_LEVEL  LOG_LEVEL_WARN
#endif

void OutputLogHeader(const char *file, int line, const char *func, int level);

// 使用宏debug可以很方便"删除"调试代码

// error
#if LOG_LEVEL <= LOG_LEVEL_ERROR
#define LOG_ERROR(...)                                                      \
  OutputLogHeader(__SHORT_FILE__, __LINE__, __FUNCTION__, LOG_LEVEL_ERROR); \
  printf(__VA_ARGS__);                                                      \
  printf("\n")
#else
#define LOG_ERROR(...) ((void)0)
#endif

// warn
#if LOG_LEVEL <= LOG_LEVEL_WARN
#define LOG_WARN_ENABLED
#define LOG_WARN(...)                                                      \
  OutputLogHeader(__SHORT_FILE__, __LINE__, __FUNCTION__, LOG_LEVEL_WARN); \
  printf(__VA_ARGS__);                                                     \
  printf("\n");
#else
#define LOG_WARN(...) ((void)0)
#endif

// info
#if LOG_LEVEL <= LOG_LEVEL_INFO
#define LOG_INFO_ENABLED
// #pragma message("LOG_INFO was enabled.")
#define LOG_INFO(...)                                                      \
  OutputLogHeader(__SHORT_FILE__, __LINE__, __FUNCTION__, LOG_LEVEL_INFO); \
  printf(__VA_ARGS__);                                                     \
  printf("\n");
#else
#define LOG_INFO(...) ((void)0)
#endif

// debug
#if LOG_LEVEL <= LOG_LEVEL_DEBUG
#define LOG_DEBUG_ENABLED
// #pragma message("LOG_DEBUG was enabled.")
#define LOG_DEBUG(...)                                                      \
  OutputLogHeader(__SHORT_FILE__, __LINE__, __FUNCTION__, LOG_LEVEL_DEBUG); \
  printf(__VA_ARGS__);                                                      \
  printf("\n");
#else
#define LOG_DEBUG(...) ((void)0)
#endif

// trace
#if LOG_LEVEL <= LOG_LEVEL_TRACE
#define LOG_TRACE_ENABLED
#define LOG_TRACE(...)                                                      \
  OutputLogHeader(__SHORT_FILE__, __LINE__, __FUNCTION__, LOG_LEVEL_TRACE); \
  printf(__VA_ARGS__);                                                      \
  printf("\n");
#else
#define LOG_TRACE(...) ((void)0)
#endif

// 输出日志信息，其格式为[type] [file:line:function] - XXXXXXXXXXXXXXX

inline void OutputLogHeader(const char *file, int line, const char *func, int level) {
  const char *type;
  switch (level) {
    case LOG_LEVEL_ERROR:
      type = "ERROR";
      break;
    case LOG_LEVEL_WARN:
      type = "WARN ";
      break;
    case LOG_LEVEL_INFO:
      type = "INFO ";
      break;
    case LOG_LEVEL_DEBUG:
      type = "DEBUG";
      break;
    case LOG_LEVEL_TRACE:
      type = "TRACE";
      break;
    default:
      type = "UNKWN";
  }
  printf("%s [%s:%d:%s] - ", type, file, line, func);
}

#endif  // logger.hpp