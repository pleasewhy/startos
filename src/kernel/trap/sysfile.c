//
// Created by hy on 2021/2/3.
//

#include "../types.h"
#include "../param.h"
#include "../riscv.h"
#include "../memlayout.h"
#include "../lock/lock.h"
#include "../process.h"
#include "../defs.h"

uint64 sys_putchar(void) {
    putc(0, argraw(0));
    return 0;
}

uint64 sys_exec(void) {
    char path[MAXPATH];
    if (argstr(0, path, MAXPATH) < 0) {
        return -1;
    }
    return exec(path, 0);
}

uint64 sys_read(void) {
    uint64 va = 0;
    char buf[100];
    if (argaddr(0, &va) < 0) {
        return -1;
    }
//    read_line(buf);
    buf[0] = 'a';
    buf[1] = 0;
    printf("buf=%s", buf);
    copyout(myproc()->pagetable, va, buf, strlen(buf));
    return strlen(buf);
}


//
// 进程相关的系统调用
//

uint64 sys_exit(void) {
    int status = 0;
    if (argint(0, &status) < 0) {
        return -1;
    }
    exit(status);
    return 0;
}

uint64 sys_fork(void) {
    return fork();
}
