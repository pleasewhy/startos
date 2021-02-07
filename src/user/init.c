//
// Created by hy on 2021/2/5.
//

#include "user.h"

int main() {
    char buf[100];
    int pid = fork();
    printf("pid=%d\n", pid);
    read(buf);
    printf("%s",buf);
    for(;;)
        printf("pid=%d\n", pid);
    return 0;
}
