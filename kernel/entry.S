	# qemu -kernel 将内核添加到0x80000000
        # 并将每个cpu的pc都设置为这个地址.
        # kernel.ld 将下面的代码放置在0x80000000

.section .text
.global entry
_entry:
	# 为C代码配置栈.
        # stack0 定义在 start.c,
        # 每个cpu有4096个字节的栈.
        # sp = stack0 + (hartid * 4096)
        la sp, stack0
        li a0, 1024*4
	csrr a1, mhartid
        addi a1, a1, 1
        mul a0, a0, a1
        add sp, sp, a0
	# jump to start() in start.c
        call start
spin:
        j spin
