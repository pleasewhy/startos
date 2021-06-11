#include "types.h"
#include "fcntl.h"
#include "file.h"

// #define O_RDONLY 0x000
// #define O_WRONLY 0x001
// #define O_RDWR 0x002
// #define O_CREATE 0x200
// #define O_TRUNC 0x400

int   fork();
int   exit(int status);
int   wait(int *status);
int   wait4(int pid, int *status);
int   getcwd(char *buf, int sz);  // sz为缓冲区的大小
int   read(int fd, void *buf, int n);
int   write(int fd, char *buf, int n);
int   open(const char *filename, int flags);
int   openat(int dirfd, const char *pathname, int flags, mode_t mode);
int   close(int fd);
int   dup(int fd);
int   dup3(int oldfd, int newfd);
int   chdir(const char *path);
int   execve(const char *path, char *argv[], char *envp[]);
int   getpid();
int   getppid();
int   mkdirat(int dirfd, const char *path, int mode);
char *sbrk(uint64_t n);
int   pipe2(int p[]);
int   getdents64(int fd, struct dirent *dirp64, unsigned long len);
int   fstat(int fd, struct kstat *st);

// ulib.c
char * strcpy(char *s, const char *t);
int    strcmp(const char *p, const char *q);
uint_t strlen(const char *s);
void * memset(void *dst, int c, uint_t n);
char * strchr(const char *s, char c);
char * gets(char *buf, int max);
// int stat(const char *n, struct stat *st);
int   atoi(const char *s);
void *memmove(void *vdst, const void *vsrc, int n);
int   memcmp(const void *s1, const void *s2, uint_t n);
void *memcpy(void *dst, const void *src, uint_t n);

// printf.c
void printf(const char *fmt, ...);
void fprintf(int fd, const char *fmt, ...);

// malloc.c
void *malloc(uint_t);
void  free(void *);
