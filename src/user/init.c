//
// Created by hy on 2021/2/5.
//

#include "../kernel/types.h"
#include "../kernel/lock/lock.h"
#include "../kernel/fs/fs.h"
#include "../kernel/fs/fcntl.h"
#include "../kernel/fs/file.h"
#include "user.h"

char *argv[] = { "sh", 0 };

int main() {
    if (open("/console", O_RDWR) < 0) {
        mknod("/console", CONSOLE, 0);
        open("/console", O_RDWR);
    }
    dup(0); // stdout
    dup(0); // stderr
    char *s = "write: hello world!\n";
    printf("%s", s);
    int pid = fork();
    if (pid == 0) {
        exec("/sh\0", argv);
        exit(0);
    }
    for (;;) {
        wait(0);
    }
    return 0;
}
