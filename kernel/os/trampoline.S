    # 下面的代码切换user和kernel空间
    #
    # 下面的代码在用户空间和内核空间会被映射到相同的
    # 虚拟地址(TRAMPOLINE)，这是为了让下面的代码
    # 在切换页表时也能够正常工作
	# kernel.ld 使得该函数按照页对齐
	.section trampsec
.globl trampoline
trampoline:

.section trampsec
.globl trampoline
trampoline:
.align 4
.globl uservec
uservec:
	#
        # trap.c sets stvec to point here, so
        # traps from user space start here,
        # in supervisor mode, but with a
        # user page table.
        #
        # sscratch points to where the process's p->trapframe is
        # mapped into user space, at TRAPFRAME.
        #
        # trap.c设置stvec指向这里，因此来自内核的trap会从这里开始
        # 虽然是supervisor模式，却是用户页表
        #
        # sscratch保存了进程的trapframe

        # 交换a0和sscratch
        # 现在a0为TRAPFRAME
        csrrw a0, sscratch, a0
        # save the user registers in TRAPFRAME
        # 将用户寄存器保存在TRAPFRAME
        sd ra, 40(a0)
        sd sp, 48(a0)
        sd gp, 56(a0)
        sd tp, 64(a0)
        sd t0, 72(a0)
        sd t1, 80(a0)
        sd t2, 88(a0)
        sd s0, 96(a0)
        sd s1, 104(a0)
        sd a1, 120(a0)
        sd a2, 128(a0)
        sd a3, 136(a0)
        sd a4, 144(a0)
        sd a5, 152(a0)
        sd a6, 160(a0)
        sd a7, 168(a0)
        sd s2, 176(a0)
        sd s3, 184(a0)
        sd s4, 192(a0)
        sd s5, 200(a0)
        sd s6, 208(a0)
        sd s7, 216(a0)
        sd s8, 224(a0)
        sd s9, 232(a0)
        sd s10, 240(a0)
        sd s11, 248(a0)
        sd t3, 256(a0)
        sd t4, 264(a0)
        sd t5, 272(a0)
        sd t6, 280(a0)

	    # 保存用户的a0在p->trapframe->a0
        csrr t0, sscratch
        sd t0, 112(a0)

        # 恢复进程的内核栈指针(p->trapframe->kernel_sp)
        ld sp, 8(a0)

        # 维护tp寄存器保持当前的hartid(p->trapframe->kernel_hartid)
        ld tp, 32(a0)

        # load usertrap的地址(p->trapframe->kernel_trap)
        ld t0, 16(a0)

        # 恢复内核页表(p->trapframe->kernel_satp)
        ld t1, 0(a0)
        csrw satp, t1
        sfence.vma zero, zero

        # a0不再有效, 因为内核页表没有专门映射p->trapframe

        # 跳转到usertrap(), 不会返回
        jr t0

# 切换页表并且执行程序的入口
# userret(uint64 trapframe, uint64 satp)
.globl userret
.align 4
userret:

    csrw satp, a1
    sfence.vma zero, zero

    # 先将a0保存在sscratch中，在加载完寄存器后悔交换回来
    ld t0, 112(a0)
    csrw sscratch, t0

    # 从TRAPFRAME中恢复除了a0其余全部寄存器
    ld ra, 40(a0)
    ld sp, 48(a0)
    ld gp, 56(a0)
    ld tp, 64(a0)
    ld t0, 72(a0)
    ld t1, 80(a0)
    ld t2, 88(a0)
    ld s0, 96(a0)
    ld s1, 104(a0)
    ld a1, 120(a0)
    ld a2, 128(a0)
    ld a3, 136(a0)
    ld a4, 144(a0)
    ld a5, 152(a0)
    ld a6, 160(a0)
    ld a7, 168(a0)
    ld s2, 176(a0)
    ld s3, 184(a0)
    ld s4, 192(a0)
    ld s5, 200(a0)
    ld s6, 208(a0)
    ld s7, 216(a0)
    ld s8, 224(a0)
    ld s9, 232(a0)
    ld s10, 240(a0)
    ld s11, 248(a0)
    ld t3, 256(a0)
    ld t4, 264(a0)
    ld t5, 272(a0)
    ld t6, 280(a0)

    # restore user a0, and save TRAPFRAME in sscratch
    csrrw a0, sscratch, a0

    # return to user mode and user pc.
    # usertrapret() set up sstatus and sepc.
    sret

