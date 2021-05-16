#include "types.hpp"

struct stat;

// system call
int exit(int);
int fork();
int exec(char *path, char **argv);
int wait(int *status);
int read(int fd, void* buf, int n);
int write(int fd, char* buf, int n);
int open(const char *path, int mode);
int mknod(char *path, int major, int minor);
int mkdir(char *path);
int chdir(char *path);
int dup(int fd);
int fstat(int fd, struct stat *stat);

// printf.c
void printf(const char*, ...);

// ulib.c
char * strncpy(char *s, const char *t, int n);
char* strcpy(char* s, const char* t);
unsigned int strlen(const char *s);
int strcmp(const char* p, const char* q);
char* strchr(const char* s, char c);
int atoi(const char* s);
void* memset(void* dst, int c, unsigned int n);
void* memmove(void* vdst, const void* vsrc, int n);
int memcmp(const void* s1, const void* s2, unsigned int n);
void* memcpy(void* dst, const void* src, unsigned int n);
int min(int a, int b);
int max(int a, int b);
int stat(const char *s, struct stat *st);
