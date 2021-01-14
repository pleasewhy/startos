#include "types.h"

void *memset(void *dst, int c, uint n) {
    char *cdst = (char *) dst;
    int i;
    for (i = 0; i < n; i++) {
        cdst[i] = c;
    }
    return dst;
}

void *memmove(void *vdst, const void *vsrc, int n) {
    char *dst;
    const char *src;

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

uint strlen(const char *s) {
    int n;
    for (n = 0; s[n]; n++);
    return n;
}

char * strncpy(char *s, const char *t, int n) {
    char *os;

    os = s;
    while (n-- > 0 && (*s++ = *t++) != 0);
    while (n-- > 0)
        *s++ = 0;
    return os;
}
int strncmp(const char *p, const char *q, uint n)
{
    while(n > 0 && *p && *p == *q)
        n--, p++, q++;
    if(n == 0)
        return 0;
    return (uchar)*p - (uchar)*q;
}
