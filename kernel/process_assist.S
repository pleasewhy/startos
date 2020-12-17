# 为fork的子进程设置ra和sp, 并且保存callee-saved
# 寄存器, 可以让pswitch却换进程时能够正确执行。
# 
# 子进程的sp相对于其kstack偏移量和父进程的相同, 可
# 以利用这个来计算子进程的sp。
# 
# 这里不能用C语言函数是因为, ra需要被设置为调用
# 保存信息后的下一条指令, 所以这里可以通过调用函数的方式
# 来满足这个条件, 若使用C语言函数, ra是正确的，但是sp可
# 能会被修改。
#
# void forkra(struct context* ctx, uint64 pkstack, uint64 ckstack)
#
.globl forkra
.align 4
forkra:
    sub t0, sp, a1 # 计算sp
    add t0, t0, a2
    sd  ra, 0(a0)
    sd  t0, 8(a0)  # sp
    sd  s0, 16(a0)
    sd  s1, 24(a0)
    sd  s2, 32(a0)
    sd  s3, 40(a0)
    sd  s4, 48(a0)
    sd  s5, 56(a0)
    sd  s6, 64(a0)
    sd  s7, 72(a0)
    sd  s8, 80(a0)
    sd  s9, 88(a0)
    sd  s10, 96(a0)
    sd  s11, 104(a0)
    ret


#
# 使调用exec的函数能够能够切换执行的指令
# 类似于pswitch, 只是保存context的时候
# 需要让进程执行指定位置的指令, 即ra参数
# 并且不保存sp寄存器
# void execra(struct context* ctx, struct context* sch, uint64 ra)
#
#
.globl execra
.align 4
execra:
    # 这里使用需要执行新的指令的地址
    # 使得pswitch能够返回到正确位置。
    sd  a2, 0(a0)
    # 不保存sp, 因为在调用
    # 该函数之前就已经保存了
    
    # 加载调度线程的context
    ld ra, 0(a1)
    ld sp, 8(a1)
    ld s0, 16(a1)
    ld s1, 24(a1)
    ld s2, 32(a1)
    ld s3, 40(a1)
    ld s4, 48(a1)
    ld s5, 56(a1)
    ld s6, 64(a1)
    ld s7, 72(a1)
    ld s8, 80(a1)
    ld s9, 88(a1)
    ld s10, 96(a1)
    ld s11, 104(a1)
    ret