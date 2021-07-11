#include "StartOS.hpp"
#include "types.hpp"
#include "common/printk.hpp"

extern "C" void memset(void *dst, int c, uint_t n)
{
  char * cdst = (char *)dst;
  size_t i;
  for (i = 0; i < n; i++) {
    cdst[i] = c;
  }
}

int memcmp(const void *v1, const void *v2, uint_t n)
{
  const uchar_t *s1, *s2;

  s1 = static_cast<const uchar_t *>(v1);
  s2 = static_cast<const uchar_t *>(v2);
  while (n-- > 0) {
    if (*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}

void *memmove(void *dst, const void *src, uint_t n)
{
  const char *s;
  char *      d;

  s = static_cast<const char *>(src);
  d = static_cast<char *>(dst);
  if (s < d && s + n > d) {
    s += n;
    d += n;
    while (n-- > 0)
      *--d = *--s;
  }
  else
    while (n-- > 0)
      *d++ = *s++;

  return dst;
}

// memcpy exists to placate GCC.  Use memmove.
void *memcpy(void *dst, const void *src, uint_t n)
{
  return memmove(dst, src, n);
}

// guarantee p, q to end with '\0'
int strcmp(const char *p, const char *q)
{
  while (*p && *q && *p == *q) {
    p++, q++;
  }
  return (uchar_t)*p - (uchar_t)*q;
}

int strncmp(const char *p, const char *q, uint_t n)
{
  while (n > 0 && *p && *p == *q)
    n--, p++, q++;
  if (n == 0)
    return 0;
  return (uchar_t)*p - (uchar_t)*q;
}

static inline char toLowCase(char c)
{
  if (c >= 'A' && c <= 'Z') {
    return c + 32;
  }
  return c;
}

int strncasecmp(const char *s1, const char *s2, size_t n)
{
  int result;

  const unsigned char *p1 = (const unsigned char *)s1;
  const unsigned char *p2 = (const unsigned char *)s2;

  if (p1 == p2 || n == 0)
    return 0;

  while ((result = toLowCase(*p1) - toLowCase(*p2++)) == 0)
    if (*p1++ == '\0' || --n == 0)
      break;
  return result;
}

char *strncpy(char *s, const char *t, int n)
{
  char *os;

  os = s;
  while (n-- > 0 && (*s++ = *t++) != 0)
    ;
  while (n-- > 0)
    *s++ = 0;
  return os;
}

// Like strncpy but guaranteed to NUL-terminate.
char *safestrcpy(char *s, const char *t, int n)
{
  char *os;

  os = s;
  if (n <= 0)
    return os;
  while (--n > 0 && (*s++ = *t++) != 0)
    ;
  *s = 0;
  return os;
}

int strlen(const char *s)
{
  int n;

  for (n = 0; s[n]; n++)
    ;
  return n;
}

char *strchr(const char *s, char c)
{
  for (; *s; s++)
    if (*s == c)
      return (char *)s;
  return 0;
}

char *strrchr(const char *s, char c)
{
  char *ans = 0;
  for (; *s; s++)
    if (*s == c)
      ans = (char *)s;
  return ans;
}

// 将char字符串转换为wchar字符串
void CopyCharToWchar(uint16_t *dst, char const *src, int len)
{
  int i;
  for (i = 0; i < len; i++) {
    *dst = *src++;
    dst++;
  }
  for (; i < len; i++) {
    *dst++ = 0;
  }
}

// 将wchar字符串装换为char字符串
void CopyWcharToChar(char *dst, uint16_t const *src, int len)
{
  int   i;
  char *s = (char *)src;
  for (i = 0; i < len; i++) {
    *dst++ = s[i * 2];
    src++;
  }
  for (; i < len; i++) {
    *dst++ = 0;
  }
}

int wcsncmp(wchar_t const *s1, wchar_t const *s2, int len)
{
  int ret = 0;

  while (len-- && *s1) {
    ret = (int)(*s1++ - *s2++);
    if (ret)
      break;
  }

  return ret;
}
