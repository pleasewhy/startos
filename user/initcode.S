# Initial process that execs /init.
# This code runs in user space.

#include "os/SyscallNum.hpp"

# exec(init, argv)
.globl start
start:
        la a0, init
        la a1, argv
        li a7, SYS_execve
        ecall

# for(;;) exit();
exit:
        li a7, SYS_exit
        ecall
        jal exit

# char init[] = "/init\0";
init:
  .string "/init\0"

# char *argv[] = { init, 0 };
.p2align 2
argv:
  .long init
  .long 0
