    # 下面的代码切换user和kernel空间
    #
    # 下面的代码在用户空间和内核空间会被映射到相同的
    # 虚拟地址(TRAMPOLINE)，这是为了让下面的代码
    # 在切换页表时也能够正常工作
	# kernel.ld 使得该函数按照页对齐
	.section trampsec
.globl trampoline
trampoline:

# 切换页表并且执行程序的入口
# execute(uint64 trapframe, uint64 satp)
.globl execute
.align 4
execute:

    # 首先切换到用户页表，此时仍然属于supervisor
    csrw satp, a1
    sfence.vma zero, zero

    # 恢复寄存器
    ld sp, 48(a0)

    # 返回用户之前执行的位置
    ld t0, 24(a0) # epc
    jr t0

