#include "types.h"
#include "fcntl.h"
#include "file.h"

int fork();
int exit(int status);
int wait(int *status);
int execve(const char *path, char *argv[], char *envp[]);
int open(const char *filename, int flags);
int dup(int fd);

void printf(const char *fmt, ...);
