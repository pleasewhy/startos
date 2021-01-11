#include "types.h"

void* memset(void* dst, int c, uint n)
{
    char* cdst = (char*)dst;
    int i;
    for (i = 0; i < n; i++) {
        cdst[i] = c;
    }
    return dst;
}

void* memmove(void* vdst, const void* vsrc, int n)
{
    char* dst;
    const char* src;

    dst = vdst;
    src = vsrc;
    if (src > dst) {
        while (n-- > 0)
            *dst++ = *src++;
    } else {
        dst += n;
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}

uint strlen(const char* s)
{
  int n;
  for (n = 0; s[n]; n++)
    ;
  return n;
}
