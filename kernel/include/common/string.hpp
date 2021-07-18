#ifndef STRING_HPP
#define STRING_HPP
#include "types.hpp"
#include "StartOS.hpp"

extern "C" void  memset(void *dst, int c, uint_t n);
int   memcmp(const void *v1, const void *v2, uint_t n);
void *memmove(void *dst, const void *src, uint_t n);
extern "C" void *memcpy(void *dst, const void *src, uint_t n);
char *strncpy(char *s, const char *t, int n);
char *safestrcpy(char *s, const char *t, int n);
int   strlen(const char *s);
int   strcmp(const char *p, const char *q);
int   strncmp(const char *p, const char *q, uint_t n);
int   strncasecmp(const char *s1, const char *s2, size_t n);
char *strchr(const char *s, char c);
char *strrchr(const char *s, char c);
// void  snstr(char* dst, wchar_t const* src, int len);
// void  wnstr(wchar_t* dst, char const* src, int len);
void CopyWcharToChar(char *dst, uint16_t const *src, int len);
void CopyCharToWchar(uint16_t *dst, char const *src, int len);
#endif