
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00004117          	auipc	sp,0x4
    80000004:	12010113          	addi	sp,sp,288 # 80004120 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	070000ef          	jal	ra,80000086 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:

// 配置机器模式下的时钟中断，使其能够被kernelvec.S中的
// timervec函数处理，timervec会抛出一个软件中断让，trap.c
// 中的devintr()处理
void timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
    // 每个cpu都有自己的时钟中断源
    int id = r_mhartid();

    // 向CLINT请求时钟中断
    int interval = 1000000; // 周期, 在qemu中差不多是1/10秒
    *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80000026:	0037961b          	slliw	a2,a5,0x3
    8000002a:	02004737          	lui	a4,0x2004
    8000002e:	963a                	add	a2,a2,a4
    80000030:	0200c737          	lui	a4,0x200c
    80000034:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80000038:	000f46b7          	lui	a3,0xf4
    8000003c:	24068693          	addi	a3,a3,576 # f4240 <_entry-0x7ff0bdc0>
    80000040:	9736                	add	a4,a4,a3
    80000042:	e218                	sd	a4,0(a2)

    // 为timervec准备scratch[]中的内容
    // scratch[0..3]: timervec保存寄存器的空间
    // scratch[4]: CLINT MTIMECMP寄存器的地址
    // scratch[5]: 将时钟中断周期设置为intverval
    uint64 *scratch = &mscratch0[32 * id];
    80000044:	0057979b          	slliw	a5,a5,0x5
    80000048:	078e                	slli	a5,a5,0x3
    8000004a:	00004717          	auipc	a4,0x4
    8000004e:	fd670713          	addi	a4,a4,-42 # 80004020 <mscratch0>
    80000052:	97ba                	add	a5,a5,a4
    scratch[4] = CLINT_MTIMECMP(id);
    80000054:	f390                	sd	a2,32(a5)
    scratch[5] = interval;
    80000056:	f794                	sd	a3,40(a5)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000058:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000005c:	00001797          	auipc	a5,0x1
    80000060:	a7478793          	addi	a5,a5,-1420 # 80000ad0 <timervec>
    80000064:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus

    // 设置机器模式下的trap处理程序
    w_mtvec((uint64)timervec);

    // 允许机器模式中断
    w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000006c:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000070:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000074:	304027f3          	csrr	a5,mie

    // 允许机器模式时钟中断
    w_mie(r_mie() | MIE_MTIE);
    80000078:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000007c:	30479073          	csrw	mie,a5
    80000080:	6422                	ld	s0,8(sp)
    80000082:	0141                	addi	sp,sp,16
    80000084:	8082                	ret

0000000080000086 <start>:
{
    80000086:	1141                	addi	sp,sp,-16
    80000088:	e406                	sd	ra,8(sp)
    8000008a:	e022                	sd	s0,0(sp)
    8000008c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000008e:	300027f3          	csrr	a5,mstatus
    x &= ~MSTATUS_MPP_MASK;
    80000092:	7779                	lui	a4,0xffffe
    80000094:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <buf_cache+0xffffffff7ffabd27>
    80000098:	8ff9                	and	a5,a5,a4
    x |= MSTATUS_MPP_S;
    8000009a:	6705                	lui	a4,0x1
    8000009c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000a6:	00000797          	auipc	a5,0x0
    800000aa:	04678793          	addi	a5,a5,70 # 800000ec <main>
    800000ae:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b2:	4781                	li	a5,0
    800000b4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000b8:	67c1                	lui	a5,0x10
    800000ba:	17fd                	addi	a5,a5,-1
    800000bc:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c0:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000c4:	104027f3          	csrr	a5,sie
    w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000c8:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000cc:	10479073          	csrw	sie,a5
    timerinit();
    800000d0:	00000097          	auipc	ra,0x0
    800000d4:	f4c080e7          	jalr	-180(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000d8:	f14027f3          	csrr	a5,mhartid
    w_tp(id);
    800000dc:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000de:	823e                	mv	tp,a5
    asm volatile("mret");
    800000e0:	30200073          	mret
}
    800000e4:	60a2                	ld	ra,8(sp)
    800000e6:	6402                	ld	s0,0(sp)
    800000e8:	0141                	addi	sp,sp,16
    800000ea:	8082                	ret

00000000800000ec <main>:
#include "lock/lock.h"
#include "process.h"
#include "defs.h"

void main()
{
    800000ec:	1141                	addi	sp,sp,-16
    800000ee:	e406                	sd	ra,8(sp)
    800000f0:	e022                	sd	s0,0(sp)
    800000f2:	0800                	addi	s0,sp,16
    uart_init();            // 初始化uart
    800000f4:	00000097          	auipc	ra,0x0
    800000f8:	088080e7          	jalr	136(ra) # 8000017c <uart_init>
    printf("\n");
    800000fc:	00003517          	auipc	a0,0x3
    80000100:	40c50513          	addi	a0,a0,1036 # 80003508 <digits+0x4d0>
    80000104:	00000097          	auipc	ra,0x0
    80000108:	3ce080e7          	jalr	974(ra) # 800004d2 <printf>
    printf("xv6 kernel is booting\n");
    8000010c:	00003517          	auipc	a0,0x3
    80000110:	ef450513          	addi	a0,a0,-268 # 80003000 <sleep_holding+0x7a>
    80000114:	00000097          	auipc	ra,0x0
    80000118:	3be080e7          	jalr	958(ra) # 800004d2 <printf>
    printf("\n");
    8000011c:	00003517          	auipc	a0,0x3
    80000120:	3ec50513          	addi	a0,a0,1004 # 80003508 <digits+0x4d0>
    80000124:	00000097          	auipc	ra,0x0
    80000128:	3ae080e7          	jalr	942(ra) # 800004d2 <printf>
    trapinit();             // 初始化trap
    8000012c:	00000097          	auipc	ra,0x0
    80000130:	60e080e7          	jalr	1550(ra) # 8000073a <trapinit>
    plicinit();             // 初始化plic
    80000134:	00000097          	auipc	ra,0x0
    80000138:	7d8080e7          	jalr	2008(ra) # 8000090c <plicinit>
    plicinithart();
    8000013c:	00000097          	auipc	ra,0x0
    80000140:	7e6080e7          	jalr	2022(ra) # 80000922 <plicinithart>
    virtio_disk_init();     // 初始化磁盘
    80000144:	00002097          	auipc	ra,0x2
    80000148:	b04080e7          	jalr	-1276(ra) # 80001c48 <virtio_disk_init>
//    init_fs();              // 初始化文件系统
    init_inode_cache();     // 初始化inode cache
    8000014c:	00002097          	auipc	ra,0x2
    80000150:	32e080e7          	jalr	814(ra) # 8000247a <init_inode_cache>
    init_buf();          // 初始化磁盘块缓冲
    80000154:	00003097          	auipc	ra,0x3
    80000158:	9e2080e7          	jalr	-1566(ra) # 80002b36 <init_buf>
    init_process_table();   // 初始化进程表
    8000015c:	00001097          	auipc	ra,0x1
    80000160:	b26080e7          	jalr	-1242(ra) # 80000c82 <init_process_table>
    init_first_process();   // 初始化第一个进程
    80000164:	00001097          	auipc	ra,0x1
    80000168:	bf4080e7          	jalr	-1036(ra) # 80000d58 <init_first_process>
    scheduler();
    8000016c:	00001097          	auipc	ra,0x1
    80000170:	e92080e7          	jalr	-366(ra) # 80000ffe <scheduler>
}
    80000174:	60a2                	ld	ra,8(sp)
    80000176:	6402                	ld	s0,0(sp)
    80000178:	0141                	addi	sp,sp,16
    8000017a:	8082                	ret

000000008000017c <uart_init>:
#define FCR_FIFO_CLEAR (3 << 1)  // 清除两个FIFO的内容
#define IER_RX_ENABLE (1 << 0)   // 读中断允许
#define IER_TX_ENABLE (1 << 1)   // 传输中断允许

void uart_init()
{
    8000017c:	1141                	addi	sp,sp,-16
    8000017e:	e422                	sd	s0,8(sp)
    80000180:	0800                	addi	s0,sp,16
  // 禁用中断
  WriteReg(IER, 0x0);
    80000182:	100007b7          	lui	a5,0x10000
    80000186:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // 配置波特率模式
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000018a:	f8000713          	li	a4,-128
    8000018e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000192:	470d                	li	a4,3
    80000194:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000198:	000780a3          	sb	zero,1(a5)

  // 退出 设置波特率模式
  // 设置字宽为8位，不校验
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000019c:	46a1                	li	a3,8
    8000019e:	00d781a3          	sb	a3,3(a5)

  // 重置和允许FIFO
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800001a2:	469d                	li	a3,7
    800001a4:	00d78123          	sb	a3,2(a5)

  // 允许传输和接受中断
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800001a8:	00e780a3          	sb	a4,1(a5)

  // initlock(&uart_tx_lock, "uart");
}
    800001ac:	6422                	ld	s0,8(sp)
    800001ae:	0141                	addi	sp,sp,16
    800001b0:	8082                	ret

00000000800001b2 <uartputc_sync>:

void uartputc_sync(int c)
{
    800001b2:	1141                	addi	sp,sp,-16
    800001b4:	e422                	sd	s0,8(sp)
    800001b6:	0800                	addi	s0,sp,16
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800001b8:	10000737          	lui	a4,0x10000
    800001bc:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800001c0:	0ff7f793          	andi	a5,a5,255
    800001c4:	0207f793          	andi	a5,a5,32
    800001c8:	dbf5                	beqz	a5,800001bc <uartputc_sync+0xa>
    ;
  WriteReg(THR, c);
    800001ca:	0ff57513          	andi	a0,a0,255
    800001ce:	100007b7          	lui	a5,0x10000
    800001d2:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>
}
    800001d6:	6422                	ld	s0,8(sp)
    800001d8:	0141                	addi	sp,sp,16
    800001da:	8082                	ret

00000000800001dc <uartgetc>:

int uartgetc(void)
{
    800001dc:	1141                	addi	sp,sp,-16
    800001de:	e422                	sd	s0,8(sp)
    800001e0:	0800                	addi	s0,sp,16
  //
  if (ReadReg(LSR) & 0x01)
    800001e2:	100007b7          	lui	a5,0x10000
    800001e6:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800001ea:	8b85                	andi	a5,a5,1
    800001ec:	cb91                	beqz	a5,80000200 <uartgetc+0x24>
  {
    return ReadReg(RHR);
    800001ee:	100007b7          	lui	a5,0x10000
    800001f2:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800001f6:	0ff57513          	andi	a0,a0,255
  }
  else
  {
    return -1;
  }
}
    800001fa:	6422                	ld	s0,8(sp)
    800001fc:	0141                	addi	sp,sp,16
    800001fe:	8082                	ret
    return -1;
    80000200:	557d                	li	a0,-1
    80000202:	bfe5                	j	800001fa <uartgetc+0x1e>

0000000080000204 <uart_intr>:

void uart_intr()
{
    80000204:	1101                	addi	sp,sp,-32
    80000206:	ec06                	sd	ra,24(sp)
    80000208:	e822                	sd	s0,16(sp)
    8000020a:	e426                	sd	s1,8(sp)
    8000020c:	1000                	addi	s0,sp,32
  while (1)
  {
    int c = uartgetc();
    if (c == -1)
    8000020e:	54fd                	li	s1,-1
    int c = uartgetc();
    80000210:	00000097          	auipc	ra,0x0
    80000214:	fcc080e7          	jalr	-52(ra) # 800001dc <uartgetc>
    if (c == -1)
    80000218:	00950963          	beq	a0,s1,8000022a <uart_intr+0x26>
      break;
    console_intr(c);
    8000021c:	0ff57513          	andi	a0,a0,255
    80000220:	00000097          	auipc	ra,0x0
    80000224:	40a080e7          	jalr	1034(ra) # 8000062a <console_intr>
  {
    80000228:	b7e5                	j	80000210 <uart_intr+0xc>
  }
}
    8000022a:	60e2                	ld	ra,24(sp)
    8000022c:	6442                	ld	s0,16(sp)
    8000022e:	64a2                	ld	s1,8(sp)
    80000230:	6105                	addi	sp,sp,32
    80000232:	8082                	ret

0000000080000234 <printint>:

static char digits[] = "0123456789ABCDEF";

static void
printint(int fd, int xx, int base, int sgn)
{
    80000234:	7179                	addi	sp,sp,-48
    80000236:	f406                	sd	ra,40(sp)
    80000238:	f022                	sd	s0,32(sp)
    8000023a:	ec26                	sd	s1,24(sp)
    8000023c:	e84a                	sd	s2,16(sp)
    8000023e:	1800                	addi	s0,sp,48
    char buf[16];
    int i, neg;
    uint x;

    neg = 0;
    if (sgn && xx < 0) {
    80000240:	c299                	beqz	a3,80000246 <printint+0x12>
    80000242:	0805c663          	bltz	a1,800002ce <printint+0x9a>
        neg = 1;
        x = -xx;
    } else {
        x = xx;
    80000246:	2581                	sext.w	a1,a1
    neg = 0;
    80000248:	4881                	li	a7,0
    8000024a:	fd040693          	addi	a3,s0,-48
    }

    i = 0;
    8000024e:	4701                	li	a4,0
    do {
        buf[i++] = digits[x % base];
    80000250:	2601                	sext.w	a2,a2
    80000252:	00003517          	auipc	a0,0x3
    80000256:	de650513          	addi	a0,a0,-538 # 80003038 <digits>
    8000025a:	883a                	mv	a6,a4
    8000025c:	2705                	addiw	a4,a4,1
    8000025e:	02c5f7bb          	remuw	a5,a1,a2
    80000262:	1782                	slli	a5,a5,0x20
    80000264:	9381                	srli	a5,a5,0x20
    80000266:	97aa                	add	a5,a5,a0
    80000268:	0007c783          	lbu	a5,0(a5)
    8000026c:	00f68023          	sb	a5,0(a3)
    } while ((x /= base) != 0);
    80000270:	0005879b          	sext.w	a5,a1
    80000274:	02c5d5bb          	divuw	a1,a1,a2
    80000278:	0685                	addi	a3,a3,1
    8000027a:	fec7f0e3          	bgeu	a5,a2,8000025a <printint+0x26>
    if (neg)
    8000027e:	00088b63          	beqz	a7,80000294 <printint+0x60>
        buf[i++] = '-';
    80000282:	fe040793          	addi	a5,s0,-32
    80000286:	973e                	add	a4,a4,a5
    80000288:	02d00793          	li	a5,45
    8000028c:	fef70823          	sb	a5,-16(a4)
    80000290:	0028071b          	addiw	a4,a6,2

    while (--i >= 0)
    80000294:	02e05763          	blez	a4,800002c2 <printint+0x8e>
    80000298:	fd040793          	addi	a5,s0,-48
    8000029c:	00e784b3          	add	s1,a5,a4
    800002a0:	fff78913          	addi	s2,a5,-1
    800002a4:	993a                	add	s2,s2,a4
    800002a6:	377d                	addiw	a4,a4,-1
    800002a8:	1702                	slli	a4,a4,0x20
    800002aa:	9301                	srli	a4,a4,0x20
    800002ac:	40e90933          	sub	s2,s2,a4
    int write_index;
} consloe_buf;

void putc(int fd, char ch)
{
    uartputc_sync(ch);
    800002b0:	fff4c503          	lbu	a0,-1(s1)
    800002b4:	00000097          	auipc	ra,0x0
    800002b8:	efe080e7          	jalr	-258(ra) # 800001b2 <uartputc_sync>
    800002bc:	14fd                	addi	s1,s1,-1
    800002be:	ff2499e3          	bne	s1,s2,800002b0 <printint+0x7c>
        putc(fd, buf[i]);
}
    800002c2:	70a2                	ld	ra,40(sp)
    800002c4:	7402                	ld	s0,32(sp)
    800002c6:	64e2                	ld	s1,24(sp)
    800002c8:	6942                	ld	s2,16(sp)
    800002ca:	6145                	addi	sp,sp,48
    800002cc:	8082                	ret
        x = -xx;
    800002ce:	40b005bb          	negw	a1,a1
        neg = 1;
    800002d2:	4885                	li	a7,1
        x = -xx;
    800002d4:	bf9d                	j	8000024a <printint+0x16>

00000000800002d6 <vprintf>:
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char* fmt, va_list ap)
{
    800002d6:	7119                	addi	sp,sp,-128
    800002d8:	fc86                	sd	ra,120(sp)
    800002da:	f8a2                	sd	s0,112(sp)
    800002dc:	f4a6                	sd	s1,104(sp)
    800002de:	f0ca                	sd	s2,96(sp)
    800002e0:	ecce                	sd	s3,88(sp)
    800002e2:	e8d2                	sd	s4,80(sp)
    800002e4:	e4d6                	sd	s5,72(sp)
    800002e6:	e0da                	sd	s6,64(sp)
    800002e8:	fc5e                	sd	s7,56(sp)
    800002ea:	f862                	sd	s8,48(sp)
    800002ec:	f466                	sd	s9,40(sp)
    800002ee:	f06a                	sd	s10,32(sp)
    800002f0:	ec6e                	sd	s11,24(sp)
    800002f2:	0100                	addi	s0,sp,128
    800002f4:	f8a43423          	sd	a0,-120(s0)
    char* s;
    int c, i, state;

    state = 0;
    for (i = 0; fmt[i]; i++) {
    800002f8:	0005c483          	lbu	s1,0(a1)
    800002fc:	18048563          	beqz	s1,80000486 <vprintf+0x1b0>
    80000300:	8ab2                	mv	s5,a2
    80000302:	00158913          	addi	s2,a1,1
    state = 0;
    80000306:	4981                	li	s3,0
            if (c == '%') {
                state = '%';
            } else {
                putc(fd, c);
            }
        } else if (state == '%') {
    80000308:	02500a13          	li	s4,37
            if (c == 'd') {
    8000030c:	06400b93          	li	s7,100
                printint(fd, va_arg(ap, int), 10, 1);
            } else if (c == 'l') {
    80000310:	06c00c13          	li	s8,108
                printint(fd, va_arg(ap, uint64), 10, 0);
            } else if (c == 'x') {
    80000314:	07800c93          	li	s9,120
                printint(fd, va_arg(ap, int), 16, 0);
            } else if (c == 'p') {
    80000318:	07000d13          	li	s10,112
                printptr(fd, va_arg(ap, uint64));
            } else if (c == 's') {
    8000031c:	07300d93          	li	s11,115
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000320:	00003b17          	auipc	s6,0x3
    80000324:	d18b0b13          	addi	s6,s6,-744 # 80003038 <digits>
    80000328:	a831                	j	80000344 <vprintf+0x6e>
    8000032a:	8526                	mv	a0,s1
    8000032c:	00000097          	auipc	ra,0x0
    80000330:	e86080e7          	jalr	-378(ra) # 800001b2 <uartputc_sync>
}
    80000334:	a019                	j	8000033a <vprintf+0x64>
        } else if (state == '%') {
    80000336:	01498e63          	beq	s3,s4,80000352 <vprintf+0x7c>
    for (i = 0; fmt[i]; i++) {
    8000033a:	0905                	addi	s2,s2,1
    8000033c:	fff94483          	lbu	s1,-1(s2)
    80000340:	14048363          	beqz	s1,80000486 <vprintf+0x1b0>
        c = fmt[i] & 0xff;
    80000344:	2481                	sext.w	s1,s1
        if (state == 0) {
    80000346:	fe0998e3          	bnez	s3,80000336 <vprintf+0x60>
            if (c == '%') {
    8000034a:	ff4490e3          	bne	s1,s4,8000032a <vprintf+0x54>
                state = '%';
    8000034e:	89a6                	mv	s3,s1
    80000350:	b7ed                	j	8000033a <vprintf+0x64>
            if (c == 'd') {
    80000352:	03748c63          	beq	s1,s7,8000038a <vprintf+0xb4>
            } else if (c == 'l') {
    80000356:	05848963          	beq	s1,s8,800003a8 <vprintf+0xd2>
            } else if (c == 'x') {
    8000035a:	07948663          	beq	s1,s9,800003c6 <vprintf+0xf0>
            } else if (c == 'p') {
    8000035e:	09a48363          	beq	s1,s10,800003e4 <vprintf+0x10e>
            } else if (c == 's') {
    80000362:	0db48363          	beq	s1,s11,80000428 <vprintf+0x152>
                    s = "(null)";
                while (*s != 0) {
                    putc(fd, *s);
                    s++;
                }
            } else if (c == 'c') {
    80000366:	06300793          	li	a5,99
    8000036a:	0ef48963          	beq	s1,a5,8000045c <vprintf+0x186>
                putc(fd, va_arg(ap, uint));
            } else if (c == '%') {
    8000036e:	11448263          	beq	s1,s4,80000472 <vprintf+0x19c>
    uartputc_sync(ch);
    80000372:	8552                	mv	a0,s4
    80000374:	00000097          	auipc	ra,0x0
    80000378:	e3e080e7          	jalr	-450(ra) # 800001b2 <uartputc_sync>
    8000037c:	8526                	mv	a0,s1
    8000037e:	00000097          	auipc	ra,0x0
    80000382:	e34080e7          	jalr	-460(ra) # 800001b2 <uartputc_sync>
            } else {
                // Unknown % sequence.  Print it to draw attention.
                putc(fd, '%');
                putc(fd, c);
            }
            state = 0;
    80000386:	4981                	li	s3,0
}
    80000388:	bf4d                	j	8000033a <vprintf+0x64>
                printint(fd, va_arg(ap, int), 10, 1);
    8000038a:	008a8493          	addi	s1,s5,8
    8000038e:	4685                	li	a3,1
    80000390:	4629                	li	a2,10
    80000392:	000aa583          	lw	a1,0(s5)
    80000396:	f8843503          	ld	a0,-120(s0)
    8000039a:	00000097          	auipc	ra,0x0
    8000039e:	e9a080e7          	jalr	-358(ra) # 80000234 <printint>
    800003a2:	8aa6                	mv	s5,s1
            state = 0;
    800003a4:	4981                	li	s3,0
    800003a6:	bf51                	j	8000033a <vprintf+0x64>
                printint(fd, va_arg(ap, uint64), 10, 0);
    800003a8:	008a8493          	addi	s1,s5,8
    800003ac:	4681                	li	a3,0
    800003ae:	4629                	li	a2,10
    800003b0:	000aa583          	lw	a1,0(s5)
    800003b4:	f8843503          	ld	a0,-120(s0)
    800003b8:	00000097          	auipc	ra,0x0
    800003bc:	e7c080e7          	jalr	-388(ra) # 80000234 <printint>
    800003c0:	8aa6                	mv	s5,s1
            state = 0;
    800003c2:	4981                	li	s3,0
    800003c4:	bf9d                	j	8000033a <vprintf+0x64>
                printint(fd, va_arg(ap, int), 16, 0);
    800003c6:	008a8493          	addi	s1,s5,8
    800003ca:	4681                	li	a3,0
    800003cc:	4641                	li	a2,16
    800003ce:	000aa583          	lw	a1,0(s5)
    800003d2:	f8843503          	ld	a0,-120(s0)
    800003d6:	00000097          	auipc	ra,0x0
    800003da:	e5e080e7          	jalr	-418(ra) # 80000234 <printint>
    800003de:	8aa6                	mv	s5,s1
            state = 0;
    800003e0:	4981                	li	s3,0
    800003e2:	bfa1                	j	8000033a <vprintf+0x64>
                printptr(fd, va_arg(ap, uint64));
    800003e4:	008a8793          	addi	a5,s5,8
    800003e8:	f8f43023          	sd	a5,-128(s0)
    800003ec:	000ab983          	ld	s3,0(s5)
    uartputc_sync(ch);
    800003f0:	03000513          	li	a0,48
    800003f4:	00000097          	auipc	ra,0x0
    800003f8:	dbe080e7          	jalr	-578(ra) # 800001b2 <uartputc_sync>
    800003fc:	8566                	mv	a0,s9
    800003fe:	00000097          	auipc	ra,0x0
    80000402:	db4080e7          	jalr	-588(ra) # 800001b2 <uartputc_sync>
    80000406:	44c1                	li	s1,16
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000408:	03c9d793          	srli	a5,s3,0x3c
    8000040c:	97da                	add	a5,a5,s6
    8000040e:	0007c503          	lbu	a0,0(a5)
    80000412:	00000097          	auipc	ra,0x0
    80000416:	da0080e7          	jalr	-608(ra) # 800001b2 <uartputc_sync>
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000041a:	0992                	slli	s3,s3,0x4
    8000041c:	34fd                	addiw	s1,s1,-1
    8000041e:	f4ed                	bnez	s1,80000408 <vprintf+0x132>
                printptr(fd, va_arg(ap, uint64));
    80000420:	f8043a83          	ld	s5,-128(s0)
            state = 0;
    80000424:	4981                	li	s3,0
    80000426:	bf11                	j	8000033a <vprintf+0x64>
                s = va_arg(ap, char*);
    80000428:	008a8993          	addi	s3,s5,8
    8000042c:	000ab483          	ld	s1,0(s5)
                if (s == 0)
    80000430:	cc99                	beqz	s1,8000044e <vprintf+0x178>
                while (*s != 0) {
    80000432:	0004c503          	lbu	a0,0(s1)
    80000436:	c529                	beqz	a0,80000480 <vprintf+0x1aa>
    80000438:	00000097          	auipc	ra,0x0
    8000043c:	d7a080e7          	jalr	-646(ra) # 800001b2 <uartputc_sync>
                    s++;
    80000440:	0485                	addi	s1,s1,1
                while (*s != 0) {
    80000442:	0004c503          	lbu	a0,0(s1)
    80000446:	f96d                	bnez	a0,80000438 <vprintf+0x162>
                s = va_arg(ap, char*);
    80000448:	8ace                	mv	s5,s3
            state = 0;
    8000044a:	4981                	li	s3,0
    8000044c:	b5fd                	j	8000033a <vprintf+0x64>
                    s = "(null)";
    8000044e:	00003497          	auipc	s1,0x3
    80000452:	bca48493          	addi	s1,s1,-1078 # 80003018 <sleep_holding+0x92>
                while (*s != 0) {
    80000456:	02800513          	li	a0,40
    8000045a:	bff9                	j	80000438 <vprintf+0x162>
                putc(fd, va_arg(ap, uint));
    8000045c:	008a8493          	addi	s1,s5,8
    80000460:	000ac503          	lbu	a0,0(s5)
    80000464:	00000097          	auipc	ra,0x0
    80000468:	d4e080e7          	jalr	-690(ra) # 800001b2 <uartputc_sync>
    8000046c:	8aa6                	mv	s5,s1
            state = 0;
    8000046e:	4981                	li	s3,0
}
    80000470:	b5e9                	j	8000033a <vprintf+0x64>
    uartputc_sync(ch);
    80000472:	8552                	mv	a0,s4
    80000474:	00000097          	auipc	ra,0x0
    80000478:	d3e080e7          	jalr	-706(ra) # 800001b2 <uartputc_sync>
    8000047c:	4981                	li	s3,0
}
    8000047e:	bd75                	j	8000033a <vprintf+0x64>
                s = va_arg(ap, char*);
    80000480:	8ace                	mv	s5,s3
            state = 0;
    80000482:	4981                	li	s3,0
    80000484:	bd5d                	j	8000033a <vprintf+0x64>
        }
    }
}
    80000486:	70e6                	ld	ra,120(sp)
    80000488:	7446                	ld	s0,112(sp)
    8000048a:	74a6                	ld	s1,104(sp)
    8000048c:	7906                	ld	s2,96(sp)
    8000048e:	69e6                	ld	s3,88(sp)
    80000490:	6a46                	ld	s4,80(sp)
    80000492:	6aa6                	ld	s5,72(sp)
    80000494:	6b06                	ld	s6,64(sp)
    80000496:	7be2                	ld	s7,56(sp)
    80000498:	7c42                	ld	s8,48(sp)
    8000049a:	7ca2                	ld	s9,40(sp)
    8000049c:	7d02                	ld	s10,32(sp)
    8000049e:	6de2                	ld	s11,24(sp)
    800004a0:	6109                	addi	sp,sp,128
    800004a2:	8082                	ret

00000000800004a4 <fprintf>:

void fprintf(int fd, const char* fmt, ...)
{
    800004a4:	715d                	addi	sp,sp,-80
    800004a6:	ec06                	sd	ra,24(sp)
    800004a8:	e822                	sd	s0,16(sp)
    800004aa:	1000                	addi	s0,sp,32
    800004ac:	e010                	sd	a2,0(s0)
    800004ae:	e414                	sd	a3,8(s0)
    800004b0:	e818                	sd	a4,16(s0)
    800004b2:	ec1c                	sd	a5,24(s0)
    800004b4:	03043023          	sd	a6,32(s0)
    800004b8:	03143423          	sd	a7,40(s0)
    va_list ap;

    va_start(ap, fmt);
    800004bc:	fe843423          	sd	s0,-24(s0)
    vprintf(fd, fmt, ap);
    800004c0:	8622                	mv	a2,s0
    800004c2:	00000097          	auipc	ra,0x0
    800004c6:	e14080e7          	jalr	-492(ra) # 800002d6 <vprintf>
}
    800004ca:	60e2                	ld	ra,24(sp)
    800004cc:	6442                	ld	s0,16(sp)
    800004ce:	6161                	addi	sp,sp,80
    800004d0:	8082                	ret

00000000800004d2 <printf>:

void printf(const char* fmt, ...)
{
    800004d2:	711d                	addi	sp,sp,-96
    800004d4:	ec06                	sd	ra,24(sp)
    800004d6:	e822                	sd	s0,16(sp)
    800004d8:	1000                	addi	s0,sp,32
    800004da:	e40c                	sd	a1,8(s0)
    800004dc:	e810                	sd	a2,16(s0)
    800004de:	ec14                	sd	a3,24(s0)
    800004e0:	f018                	sd	a4,32(s0)
    800004e2:	f41c                	sd	a5,40(s0)
    800004e4:	03043823          	sd	a6,48(s0)
    800004e8:	03143c23          	sd	a7,56(s0)
    va_list ap;

    va_start(ap, fmt);
    800004ec:	00840613          	addi	a2,s0,8
    800004f0:	fec43423          	sd	a2,-24(s0)
    vprintf(1, fmt, ap);
    800004f4:	85aa                	mv	a1,a0
    800004f6:	4505                	li	a0,1
    800004f8:	00000097          	auipc	ra,0x0
    800004fc:	dde080e7          	jalr	-546(ra) # 800002d6 <vprintf>
}
    80000500:	60e2                	ld	ra,24(sp)
    80000502:	6442                	ld	s0,16(sp)
    80000504:	6125                	addi	sp,sp,96
    80000506:	8082                	ret

0000000080000508 <puts>:

void puts(const char* str)
{
    80000508:	1141                	addi	sp,sp,-16
    8000050a:	e406                	sd	ra,8(sp)
    8000050c:	e022                	sd	s0,0(sp)
    8000050e:	0800                	addi	s0,sp,16
    80000510:	85aa                	mv	a1,a0
    printf("%s\n", str);
    80000512:	00003517          	auipc	a0,0x3
    80000516:	b0e50513          	addi	a0,a0,-1266 # 80003020 <sleep_holding+0x9a>
    8000051a:	00000097          	auipc	ra,0x0
    8000051e:	fb8080e7          	jalr	-72(ra) # 800004d2 <printf>
}
    80000522:	60a2                	ld	ra,8(sp)
    80000524:	6402                	ld	s0,0(sp)
    80000526:	0141                	addi	sp,sp,16
    80000528:	8082                	ret

000000008000052a <putc>:
{
    8000052a:	1141                	addi	sp,sp,-16
    8000052c:	e406                	sd	ra,8(sp)
    8000052e:	e022                	sd	s0,0(sp)
    80000530:	0800                	addi	s0,sp,16
    uartputc_sync(ch);
    80000532:	852e                	mv	a0,a1
    80000534:	00000097          	auipc	ra,0x0
    80000538:	c7e080e7          	jalr	-898(ra) # 800001b2 <uartputc_sync>
}
    8000053c:	60a2                	ld	ra,8(sp)
    8000053e:	6402                	ld	s0,0(sp)
    80000540:	0141                	addi	sp,sp,16
    80000542:	8082                	ret

0000000080000544 <read_line>:

int read_line(char* s)
{
    80000544:	1101                	addi	sp,sp,-32
    80000546:	ec06                	sd	ra,24(sp)
    80000548:	e822                	sd	s0,16(sp)
    8000054a:	e426                	sd	s1,8(sp)
    8000054c:	e04a                	sd	s2,0(sp)
    8000054e:	1000                	addi	s0,sp,32
    80000550:	892a                	mv	s2,a0
    int cnt = 0;

    spin_lock(&consloe_buf.lock);
    80000552:	00005497          	auipc	s1,0x5
    80000556:	bce48493          	addi	s1,s1,-1074 # 80005120 <consloe_buf>
    8000055a:	8526                	mv	a0,s1
    8000055c:	00003097          	auipc	ra,0x3
    80000560:	826080e7          	jalr	-2010(ra) # 80002d82 <spin_lock>
    sleep(&consloe_buf, &consloe_buf.lock);
    80000564:	85a6                	mv	a1,s1
    80000566:	8526                	mv	a0,s1
    80000568:	00001097          	auipc	ra,0x1
    8000056c:	950080e7          	jalr	-1712(ra) # 80000eb8 <sleep>
    for (int i = consloe_buf.read_index; i < consloe_buf.write_index; i++) {
    80000570:	0e04a783          	lw	a5,224(s1)
    80000574:	0e44a703          	lw	a4,228(s1)
    80000578:	02e7d963          	bge	a5,a4,800005aa <read_line+0x66>
    8000057c:	864a                	mv	a2,s2
    int cnt = 0;
    8000057e:	4681                	li	a3,0
        s[cnt++] = consloe_buf.buf[i % INPUT_BUF];
    80000580:	85a6                	mv	a1,s1
    80000582:	0c800813          	li	a6,200
        if (consloe_buf.buf[i % INPUT_BUF] == '\n') {
    80000586:	4529                	li	a0,10
        s[cnt++] = consloe_buf.buf[i % INPUT_BUF];
    80000588:	84b6                	mv	s1,a3
    8000058a:	2685                	addiw	a3,a3,1
    8000058c:	0307e73b          	remw	a4,a5,a6
    80000590:	972e                	add	a4,a4,a1
    80000592:	01874703          	lbu	a4,24(a4)
    80000596:	00e60023          	sb	a4,0(a2)
        if (consloe_buf.buf[i % INPUT_BUF] == '\n') {
    8000059a:	02a70863          	beq	a4,a0,800005ca <read_line+0x86>
    for (int i = consloe_buf.read_index; i < consloe_buf.write_index; i++) {
    8000059e:	2785                	addiw	a5,a5,1
    800005a0:	0605                	addi	a2,a2,1
    800005a2:	0e45a703          	lw	a4,228(a1)
    800005a6:	fee7c1e3          	blt	a5,a4,80000588 <read_line+0x44>
            s[cnt - 1] = 0;
            spin_unlock(&consloe_buf.lock);
            return cnt - 1;
        }
    }
    spin_unlock(&consloe_buf.lock);
    800005aa:	00005517          	auipc	a0,0x5
    800005ae:	b7650513          	addi	a0,a0,-1162 # 80005120 <consloe_buf>
    800005b2:	00003097          	auipc	ra,0x3
    800005b6:	8a4080e7          	jalr	-1884(ra) # 80002e56 <spin_unlock>
    return -1;
    800005ba:	54fd                	li	s1,-1
}
    800005bc:	8526                	mv	a0,s1
    800005be:	60e2                	ld	ra,24(sp)
    800005c0:	6442                	ld	s0,16(sp)
    800005c2:	64a2                	ld	s1,8(sp)
    800005c4:	6902                	ld	s2,0(sp)
    800005c6:	6105                	addi	sp,sp,32
    800005c8:	8082                	ret
            consloe_buf.read_index = i + 1;
    800005ca:	00005517          	auipc	a0,0x5
    800005ce:	b5650513          	addi	a0,a0,-1194 # 80005120 <consloe_buf>
    800005d2:	2785                	addiw	a5,a5,1
    800005d4:	0ef52023          	sw	a5,224(a0)
            s[cnt - 1] = 0;
    800005d8:	96ca                	add	a3,a3,s2
    800005da:	fe068fa3          	sb	zero,-1(a3)
            spin_unlock(&consloe_buf.lock);
    800005de:	00003097          	auipc	ra,0x3
    800005e2:	878080e7          	jalr	-1928(ra) # 80002e56 <spin_unlock>
            return cnt - 1;
    800005e6:	bfd9                	j	800005bc <read_line+0x78>

00000000800005e8 <console_putc>:

void console_putc(int c)
{
    800005e8:	1141                	addi	sp,sp,-16
    800005ea:	e406                	sd	ra,8(sp)
    800005ec:	e022                	sd	s0,0(sp)
    800005ee:	0800                	addi	s0,sp,16
    if (c == BACKSPACE) {
    800005f0:	10000793          	li	a5,256
    800005f4:	00f50a63          	beq	a0,a5,80000608 <console_putc+0x20>
        // if the user typed backspace, overwrite with a space.
        uartputc_sync('\b');
        uartputc_sync(' ');
        uartputc_sync('\b');
    } else {
        uartputc_sync(c);
    800005f8:	00000097          	auipc	ra,0x0
    800005fc:	bba080e7          	jalr	-1094(ra) # 800001b2 <uartputc_sync>
    }
}
    80000600:	60a2                	ld	ra,8(sp)
    80000602:	6402                	ld	s0,0(sp)
    80000604:	0141                	addi	sp,sp,16
    80000606:	8082                	ret
        uartputc_sync('\b');
    80000608:	4521                	li	a0,8
    8000060a:	00000097          	auipc	ra,0x0
    8000060e:	ba8080e7          	jalr	-1112(ra) # 800001b2 <uartputc_sync>
        uartputc_sync(' ');
    80000612:	02000513          	li	a0,32
    80000616:	00000097          	auipc	ra,0x0
    8000061a:	b9c080e7          	jalr	-1124(ra) # 800001b2 <uartputc_sync>
        uartputc_sync('\b');
    8000061e:	4521                	li	a0,8
    80000620:	00000097          	auipc	ra,0x0
    80000624:	b92080e7          	jalr	-1134(ra) # 800001b2 <uartputc_sync>
    80000628:	bfe1                	j	80000600 <console_putc+0x18>

000000008000062a <console_intr>:

void console_intr(char c)
{
    8000062a:	1101                	addi	sp,sp,-32
    8000062c:	ec06                	sd	ra,24(sp)
    8000062e:	e822                	sd	s0,16(sp)
    80000630:	e426                	sd	s1,8(sp)
    80000632:	1000                	addi	s0,sp,32
    switch (c) {
    80000634:	47c1                	li	a5,16
    80000636:	04f50263          	beq	a0,a5,8000067a <console_intr+0x50>
    8000063a:	84aa                	mv	s1,a0
    8000063c:	07f00793          	li	a5,127
    80000640:	04f51663          	bne	a0,a5,8000068c <console_intr+0x62>

    case '\x7f': // 退格
        if (consloe_buf.read_index != consloe_buf.write_index) {
    80000644:	00005717          	auipc	a4,0x5
    80000648:	adc70713          	addi	a4,a4,-1316 # 80005120 <consloe_buf>
    8000064c:	0e472783          	lw	a5,228(a4)
    80000650:	0e072703          	lw	a4,224(a4)
    80000654:	02f70763          	beq	a4,a5,80000682 <console_intr+0x58>
            consloe_buf.write_index--;
    80000658:	37fd                	addiw	a5,a5,-1
    8000065a:	00005717          	auipc	a4,0x5
    8000065e:	baf72523          	sw	a5,-1110(a4) # 80005204 <consloe_buf+0xe4>
            console_putc(BACKSPACE);
    80000662:	10000513          	li	a0,256
    80000666:	00000097          	auipc	ra,0x0
    8000066a:	f82080e7          	jalr	-126(ra) # 800005e8 <console_putc>
            console_putc('\a');
    8000066e:	451d                	li	a0,7
    80000670:	00000097          	auipc	ra,0x0
    80000674:	f78080e7          	jalr	-136(ra) # 800005e8 <console_putc>
    80000678:	a029                	j	80000682 <console_intr+0x58>
        }
        break;
    case CTRL('P'):
        print_proc();
    8000067a:	00001097          	auipc	ra,0x1
    8000067e:	18c080e7          	jalr	396(ra) # 80001806 <print_proc>
        if (c == '\n') {
            wakeup(&consloe_buf);
        }
        break;
    }
}
    80000682:	60e2                	ld	ra,24(sp)
    80000684:	6442                	ld	s0,16(sp)
    80000686:	64a2                	ld	s1,8(sp)
    80000688:	6105                	addi	sp,sp,32
    8000068a:	8082                	ret
        c = (c == '\r') ? '\n' : c;
    8000068c:	47b5                	li	a5,13
    8000068e:	02f50b63          	beq	a0,a5,800006c4 <console_intr+0x9a>
        console_putc(c);
    80000692:	00000097          	auipc	ra,0x0
    80000696:	f56080e7          	jalr	-170(ra) # 800005e8 <console_putc>
        consloe_buf.buf[consloe_buf.write_index++ % INPUT_BUF] = c;
    8000069a:	00005797          	auipc	a5,0x5
    8000069e:	a8678793          	addi	a5,a5,-1402 # 80005120 <consloe_buf>
    800006a2:	0e47a703          	lw	a4,228(a5)
    800006a6:	0017069b          	addiw	a3,a4,1
    800006aa:	0ed7a223          	sw	a3,228(a5)
    800006ae:	0c800693          	li	a3,200
    800006b2:	02d7673b          	remw	a4,a4,a3
    800006b6:	97ba                	add	a5,a5,a4
    800006b8:	00978c23          	sb	s1,24(a5)
        if (c == '\n') {
    800006bc:	47a9                	li	a5,10
    800006be:	fcf492e3          	bne	s1,a5,80000682 <console_intr+0x58>
    800006c2:	a805                	j	800006f2 <console_intr+0xc8>
        console_putc(c);
    800006c4:	4529                	li	a0,10
    800006c6:	00000097          	auipc	ra,0x0
    800006ca:	f22080e7          	jalr	-222(ra) # 800005e8 <console_putc>
        consloe_buf.buf[consloe_buf.write_index++ % INPUT_BUF] = c;
    800006ce:	00005797          	auipc	a5,0x5
    800006d2:	a5278793          	addi	a5,a5,-1454 # 80005120 <consloe_buf>
    800006d6:	0e47a703          	lw	a4,228(a5)
    800006da:	0017069b          	addiw	a3,a4,1
    800006de:	0ed7a223          	sw	a3,228(a5)
    800006e2:	0c800693          	li	a3,200
    800006e6:	02d7673b          	remw	a4,a4,a3
    800006ea:	97ba                	add	a5,a5,a4
    800006ec:	4729                	li	a4,10
    800006ee:	00e78c23          	sb	a4,24(a5)
            wakeup(&consloe_buf);
    800006f2:	00005517          	auipc	a0,0x5
    800006f6:	a2e50513          	addi	a0,a0,-1490 # 80005120 <consloe_buf>
    800006fa:	00001097          	auipc	ra,0x1
    800006fe:	8ca080e7          	jalr	-1846(ra) # 80000fc4 <wakeup>
}
    80000702:	b741                	j	80000682 <console_intr+0x58>

0000000080000704 <panic>:

void panic(char* s)
{
    80000704:	1141                	addi	sp,sp,-16
    80000706:	e406                	sd	ra,8(sp)
    80000708:	e022                	sd	s0,0(sp)
    8000070a:	0800                	addi	s0,sp,16
    8000070c:	85aa                	mv	a1,a0
    printf("panic:%s", s);
    8000070e:	00003517          	auipc	a0,0x3
    80000712:	91a50513          	addi	a0,a0,-1766 # 80003028 <sleep_holding+0xa2>
    80000716:	00000097          	auipc	ra,0x0
    8000071a:	dbc080e7          	jalr	-580(ra) # 800004d2 <printf>

    for (;;) {
    8000071e:	a001                	j	8000071e <panic+0x1a>

0000000080000720 <proc_err>:
//
// 处理进程error的情况
// 中断处理程序检测到错误将会返回到这里
//
void proc_err()
{
    80000720:	1141                	addi	sp,sp,-16
    80000722:	e406                	sd	ra,8(sp)
    80000724:	e022                	sd	s0,0(sp)
    80000726:	0800                	addi	s0,sp,16
    exit(-1);
    80000728:	557d                	li	a0,-1
    8000072a:	00001097          	auipc	ra,0x1
    8000072e:	aa8080e7          	jalr	-1368(ra) # 800011d2 <exit>
}
    80000732:	60a2                	ld	ra,8(sp)
    80000734:	6402                	ld	s0,0(sp)
    80000736:	0141                	addi	sp,sp,16
    80000738:	8082                	ret

000000008000073a <trapinit>:
{
    8000073a:	1141                	addi	sp,sp,-16
    8000073c:	e422                	sd	s0,8(sp)
    8000073e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80000740:	00000797          	auipc	a5,0x0
    80000744:	27078793          	addi	a5,a5,624 # 800009b0 <kernelvec>
    80000748:	10579073          	csrw	stvec,a5
}
    8000074c:	6422                	ld	s0,8(sp)
    8000074e:	0141                	addi	sp,sp,16
    80000750:	8082                	ret

0000000080000752 <clockintr>:
    w_sstatus(sstatus);
}

// 定时器中断处理程序
void clockintr()
{
    80000752:	1101                	addi	sp,sp,-32
    80000754:	ec06                	sd	ra,24(sp)
    80000756:	e822                	sd	s0,16(sp)
    80000758:	e426                	sd	s1,8(sp)
    8000075a:	e04a                	sd	s2,0(sp)
    8000075c:	1000                	addi	s0,sp,32
    spin_lock(&ticks_lock);
    8000075e:	00005917          	auipc	s2,0x5
    80000762:	aaa90913          	addi	s2,s2,-1366 # 80005208 <ticks_lock>
    80000766:	854a                	mv	a0,s2
    80000768:	00002097          	auipc	ra,0x2
    8000076c:	61a080e7          	jalr	1562(ra) # 80002d82 <spin_lock>
    ticks++;
    80000770:	00004497          	auipc	s1,0x4
    80000774:	8a048493          	addi	s1,s1,-1888 # 80004010 <ticks>
    80000778:	609c                	ld	a5,0(s1)
    8000077a:	0785                	addi	a5,a5,1
    8000077c:	e09c                	sd	a5,0(s1)
    spin_unlock(&ticks_lock);
    8000077e:	854a                	mv	a0,s2
    80000780:	00002097          	auipc	ra,0x2
    80000784:	6d6080e7          	jalr	1750(ra) # 80002e56 <spin_unlock>
    wakeup(&ticks);
    80000788:	8526                	mv	a0,s1
    8000078a:	00001097          	auipc	ra,0x1
    8000078e:	83a080e7          	jalr	-1990(ra) # 80000fc4 <wakeup>
}
    80000792:	60e2                	ld	ra,24(sp)
    80000794:	6442                	ld	s0,16(sp)
    80000796:	64a2                	ld	s1,8(sp)
    80000798:	6902                	ld	s2,0(sp)
    8000079a:	6105                	addi	sp,sp,32
    8000079c:	8082                	ret

000000008000079e <device_intr>:
// 用于判断中断是否为外部和软件中断，并处理它
// 2: 时钟中断
// 1: 其他设备中断
// 0: 无法识别的中断
int device_intr()
{
    8000079e:	1101                	addi	sp,sp,-32
    800007a0:	ec06                	sd	ra,24(sp)
    800007a2:	e822                	sd	s0,16(sp)
    800007a4:	e426                	sd	s1,8(sp)
    800007a6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800007a8:	14202773          	csrr	a4,scause
    uint64 scause = r_scause();

    if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    800007ac:	00074d63          	bltz	a4,800007c6 <device_intr+0x28>
        // 告诉PLIC该设备现在被允许再次抛出中断
        if (irq)
            plic_complete(irq);

        return 1;
    } else if (scause == 0x8000000000000001L) {
    800007b0:	57fd                	li	a5,-1
    800007b2:	17fe                	slli	a5,a5,0x3f
    800007b4:	0785                	addi	a5,a5,1
        }
        // 告知以收到软件中断，通过清除sip的SSIP位
        w_sip(r_sip() & ~2);
        return 2;
    } else {
        return 0;
    800007b6:	4501                	li	a0,0
    } else if (scause == 0x8000000000000001L) {
    800007b8:	06f70363          	beq	a4,a5,8000081e <device_intr+0x80>
    }
}
    800007bc:	60e2                	ld	ra,24(sp)
    800007be:	6442                	ld	s0,16(sp)
    800007c0:	64a2                	ld	s1,8(sp)
    800007c2:	6105                	addi	sp,sp,32
    800007c4:	8082                	ret
    if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    800007c6:	0ff77793          	andi	a5,a4,255
    800007ca:	46a5                	li	a3,9
    800007cc:	fed792e3          	bne	a5,a3,800007b0 <device_intr+0x12>
        int irq = plic_claim();
    800007d0:	00000097          	auipc	ra,0x0
    800007d4:	18a080e7          	jalr	394(ra) # 8000095a <plic_claim>
    800007d8:	84aa                	mv	s1,a0
        if (irq == UART0_IRQ) {
    800007da:	47a9                	li	a5,10
    800007dc:	02f50763          	beq	a0,a5,8000080a <device_intr+0x6c>
        } else if (irq == VIRTIO0_IRQ) {
    800007e0:	4785                	li	a5,1
    800007e2:	02f50963          	beq	a0,a5,80000814 <device_intr+0x76>
        return 1;
    800007e6:	4505                	li	a0,1
        } else if (irq) {
    800007e8:	d8f1                	beqz	s1,800007bc <device_intr+0x1e>
            panic("unexpected interrupt irq=%d\n", irq);
    800007ea:	85a6                	mv	a1,s1
    800007ec:	00003517          	auipc	a0,0x3
    800007f0:	86450513          	addi	a0,a0,-1948 # 80003050 <digits+0x18>
    800007f4:	00000097          	auipc	ra,0x0
    800007f8:	f10080e7          	jalr	-240(ra) # 80000704 <panic>
            plic_complete(irq);
    800007fc:	8526                	mv	a0,s1
    800007fe:	00000097          	auipc	ra,0x0
    80000802:	180080e7          	jalr	384(ra) # 8000097e <plic_complete>
        return 1;
    80000806:	4505                	li	a0,1
    80000808:	bf55                	j	800007bc <device_intr+0x1e>
            uart_intr();
    8000080a:	00000097          	auipc	ra,0x0
    8000080e:	9fa080e7          	jalr	-1542(ra) # 80000204 <uart_intr>
    80000812:	b7ed                	j	800007fc <device_intr+0x5e>
            virtio_disk_intr();
    80000814:	00002097          	auipc	ra,0x2
    80000818:	852080e7          	jalr	-1966(ra) # 80002066 <virtio_disk_intr>
    8000081c:	b7c5                	j	800007fc <device_intr+0x5e>
        if (cpuid() == 0) {
    8000081e:	00000097          	auipc	ra,0x0
    80000822:	56a080e7          	jalr	1386(ra) # 80000d88 <cpuid>
    80000826:	c901                	beqz	a0,80000836 <device_intr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80000828:	144027f3          	csrr	a5,sip
        w_sip(r_sip() & ~2);
    8000082c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    8000082e:	14479073          	csrw	sip,a5
        return 2;
    80000832:	4509                	li	a0,2
    80000834:	b761                	j	800007bc <device_intr+0x1e>
            clockintr();
    80000836:	00000097          	auipc	ra,0x0
    8000083a:	f1c080e7          	jalr	-228(ra) # 80000752 <clockintr>
    8000083e:	b7ed                	j	80000828 <device_intr+0x8a>

0000000080000840 <kerneltrap>:
{
    80000840:	7179                	addi	sp,sp,-48
    80000842:	f406                	sd	ra,40(sp)
    80000844:	f022                	sd	s0,32(sp)
    80000846:	ec26                	sd	s1,24(sp)
    80000848:	e84a                	sd	s2,16(sp)
    8000084a:	e44e                	sd	s3,8(sp)
    8000084c:	e052                	sd	s4,0(sp)
    8000084e:	1800                	addi	s0,sp,48
    struct proc* p = myproc();
    80000850:	00000097          	auipc	ra,0x0
    80000854:	564080e7          	jalr	1380(ra) # 80000db4 <myproc>
    80000858:	84aa                	mv	s1,a0
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000085a:	141029f3          	csrr	s3,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000085e:	10002973          	csrr	s2,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80000862:	14202a73          	csrr	s4,scause
    if ((sstatus & SSTATUS_SPP) == 0)
    80000866:	10097793          	andi	a5,s2,256
    8000086a:	cb8d                	beqz	a5,8000089c <kerneltrap+0x5c>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000086c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000870:	8b89                	andi	a5,a5,2
    if (intr_get() != 0)
    80000872:	ef95                	bnez	a5,800008ae <kerneltrap+0x6e>
    which_dev = device_intr();
    80000874:	00000097          	auipc	ra,0x0
    80000878:	f2a080e7          	jalr	-214(ra) # 8000079e <device_intr>
    if (which_dev == 0) { // 未知来源
    8000087c:	c131                	beqz	a0,800008c0 <kerneltrap+0x80>
    } else if (which_dev == 2 && p != 0 && p->state == RUNNING) { // 时钟中断
    8000087e:	4789                	li	a5,2
    80000880:	06f50863          	beq	a0,a5,800008f0 <kerneltrap+0xb0>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80000884:	14199073          	csrw	sepc,s3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000888:	10091073          	csrw	sstatus,s2
}
    8000088c:	70a2                	ld	ra,40(sp)
    8000088e:	7402                	ld	s0,32(sp)
    80000890:	64e2                	ld	s1,24(sp)
    80000892:	6942                	ld	s2,16(sp)
    80000894:	69a2                	ld	s3,8(sp)
    80000896:	6a02                	ld	s4,0(sp)
    80000898:	6145                	addi	sp,sp,48
    8000089a:	8082                	ret
        panic("kerneltrap: not from supervisor mode");
    8000089c:	00002517          	auipc	a0,0x2
    800008a0:	7d450513          	addi	a0,a0,2004 # 80003070 <digits+0x38>
    800008a4:	00000097          	auipc	ra,0x0
    800008a8:	e60080e7          	jalr	-416(ra) # 80000704 <panic>
    800008ac:	b7c1                	j	8000086c <kerneltrap+0x2c>
        panic("kerneltrap: interrupts enabled");
    800008ae:	00002517          	auipc	a0,0x2
    800008b2:	7ea50513          	addi	a0,a0,2026 # 80003098 <digits+0x60>
    800008b6:	00000097          	auipc	ra,0x0
    800008ba:	e4e080e7          	jalr	-434(ra) # 80000704 <panic>
    800008be:	bf5d                	j	80000874 <kerneltrap+0x34>
        printf("pid=%d error\n", p->pid);
    800008c0:	508c                	lw	a1,32(s1)
    800008c2:	00002517          	auipc	a0,0x2
    800008c6:	7f650513          	addi	a0,a0,2038 # 800030b8 <digits+0x80>
    800008ca:	00000097          	auipc	ra,0x0
    800008ce:	c08080e7          	jalr	-1016(ra) # 800004d2 <printf>
        printf("scause=%d sepc=%p\n", scause, sepc);
    800008d2:	864e                	mv	a2,s3
    800008d4:	85d2                	mv	a1,s4
    800008d6:	00002517          	auipc	a0,0x2
    800008da:	7f250513          	addi	a0,a0,2034 # 800030c8 <digits+0x90>
    800008de:	00000097          	auipc	ra,0x0
    800008e2:	bf4080e7          	jalr	-1036(ra) # 800004d2 <printf>
        sepc = (uint64)proc_err; // 将异常的返回地址设置为proc_err
    800008e6:	00000997          	auipc	s3,0x0
    800008ea:	e3a98993          	addi	s3,s3,-454 # 80000720 <proc_err>
    800008ee:	bf59                	j	80000884 <kerneltrap+0x44>
    } else if (which_dev == 2 && p != 0 && p->state == RUNNING) { // 时钟中断
    800008f0:	d8d1                	beqz	s1,80000884 <kerneltrap+0x44>
    800008f2:	4098                	lw	a4,0(s1)
    800008f4:	478d                	li	a5,3
    800008f6:	f8f717e3          	bne	a4,a5,80000884 <kerneltrap+0x44>
        trap_pc = sepc;
    800008fa:	00003797          	auipc	a5,0x3
    800008fe:	7137b723          	sd	s3,1806(a5) # 80004008 <trap_pc>
        sepc =(uint64)proc_sched;
    80000902:	00000997          	auipc	s3,0x0
    80000906:	13e98993          	addi	s3,s3,318 # 80000a40 <proc_sched>
    8000090a:	bfad                	j	80000884 <kerneltrap+0x44>

000000008000090c <plicinit>:
//


void
plicinit(void)
{
    8000090c:	1141                	addi	sp,sp,-16
    8000090e:	e422                	sd	s0,8(sp)
    80000910:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  // 设置IRQ的属性为非零
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80000912:	0c0007b7          	lui	a5,0xc000
    80000916:	4705                	li	a4,1
    80000918:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000091a:	c3d8                	sw	a4,4(a5)
}
    8000091c:	6422                	ld	s0,8(sp)
    8000091e:	0141                	addi	sp,sp,16
    80000920:	8082                	ret

0000000080000922 <plicinithart>:

void
plicinithart(void)
{
    80000922:	1141                	addi	sp,sp,-16
    80000924:	e406                	sd	ra,8(sp)
    80000926:	e022                	sd	s0,0(sp)
    80000928:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000092a:	00000097          	auipc	ra,0x0
    8000092e:	45e080e7          	jalr	1118(ra) # 80000d88 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80000932:	0085171b          	slliw	a4,a0,0x8
    80000936:	0c0027b7          	lui	a5,0xc002
    8000093a:	97ba                	add	a5,a5,a4
    8000093c:	40200713          	li	a4,1026
    80000940:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80000944:	00d5151b          	slliw	a0,a0,0xd
    80000948:	0c2017b7          	lui	a5,0xc201
    8000094c:	953e                	add	a0,a0,a5
    8000094e:	00052023          	sw	zero,0(a0)
}
    80000952:	60a2                	ld	ra,8(sp)
    80000954:	6402                	ld	s0,0(sp)
    80000956:	0141                	addi	sp,sp,16
    80000958:	8082                	ret

000000008000095a <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000095a:	1141                	addi	sp,sp,-16
    8000095c:	e406                	sd	ra,8(sp)
    8000095e:	e022                	sd	s0,0(sp)
    80000960:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80000962:	00000097          	auipc	ra,0x0
    80000966:	426080e7          	jalr	1062(ra) # 80000d88 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000096a:	00d5179b          	slliw	a5,a0,0xd
    8000096e:	0c201537          	lui	a0,0xc201
    80000972:	953e                	add	a0,a0,a5
  return irq;
}
    80000974:	4148                	lw	a0,4(a0)
    80000976:	60a2                	ld	ra,8(sp)
    80000978:	6402                	ld	s0,0(sp)
    8000097a:	0141                	addi	sp,sp,16
    8000097c:	8082                	ret

000000008000097e <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000097e:	1101                	addi	sp,sp,-32
    80000980:	ec06                	sd	ra,24(sp)
    80000982:	e822                	sd	s0,16(sp)
    80000984:	e426                	sd	s1,8(sp)
    80000986:	1000                	addi	s0,sp,32
    80000988:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000098a:	00000097          	auipc	ra,0x0
    8000098e:	3fe080e7          	jalr	1022(ra) # 80000d88 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80000992:	00d5151b          	slliw	a0,a0,0xd
    80000996:	0c2017b7          	lui	a5,0xc201
    8000099a:	97aa                	add	a5,a5,a0
    8000099c:	c3c4                	sw	s1,4(a5)
}
    8000099e:	60e2                	ld	ra,24(sp)
    800009a0:	6442                	ld	s0,16(sp)
    800009a2:	64a2                	ld	s1,8(sp)
    800009a4:	6105                	addi	sp,sp,32
    800009a6:	8082                	ret
	...

00000000800009b0 <kernelvec>:
    800009b0:	7111                	addi	sp,sp,-256
    800009b2:	e006                	sd	ra,0(sp)
    800009b4:	e40a                	sd	sp,8(sp)
    800009b6:	e80e                	sd	gp,16(sp)
    800009b8:	ec12                	sd	tp,24(sp)
    800009ba:	f016                	sd	t0,32(sp)
    800009bc:	f41a                	sd	t1,40(sp)
    800009be:	f81e                	sd	t2,48(sp)
    800009c0:	fc22                	sd	s0,56(sp)
    800009c2:	e0a6                	sd	s1,64(sp)
    800009c4:	e4aa                	sd	a0,72(sp)
    800009c6:	e8ae                	sd	a1,80(sp)
    800009c8:	ecb2                	sd	a2,88(sp)
    800009ca:	f0b6                	sd	a3,96(sp)
    800009cc:	f4ba                	sd	a4,104(sp)
    800009ce:	f8be                	sd	a5,112(sp)
    800009d0:	fcc2                	sd	a6,120(sp)
    800009d2:	e146                	sd	a7,128(sp)
    800009d4:	e54a                	sd	s2,136(sp)
    800009d6:	e94e                	sd	s3,144(sp)
    800009d8:	ed52                	sd	s4,152(sp)
    800009da:	f156                	sd	s5,160(sp)
    800009dc:	f55a                	sd	s6,168(sp)
    800009de:	f95e                	sd	s7,176(sp)
    800009e0:	fd62                	sd	s8,184(sp)
    800009e2:	e1e6                	sd	s9,192(sp)
    800009e4:	e5ea                	sd	s10,200(sp)
    800009e6:	e9ee                	sd	s11,208(sp)
    800009e8:	edf2                	sd	t3,216(sp)
    800009ea:	f1f6                	sd	t4,224(sp)
    800009ec:	f5fa                	sd	t5,232(sp)
    800009ee:	f9fe                	sd	t6,240(sp)
    800009f0:	e51ff0ef          	jal	ra,80000840 <kerneltrap>
    800009f4:	6082                	ld	ra,0(sp)
    800009f6:	6122                	ld	sp,8(sp)
    800009f8:	61c2                	ld	gp,16(sp)
    800009fa:	6262                	ld	tp,24(sp)
    800009fc:	7282                	ld	t0,32(sp)
    800009fe:	7322                	ld	t1,40(sp)
    80000a00:	73c2                	ld	t2,48(sp)
    80000a02:	7462                	ld	s0,56(sp)
    80000a04:	6486                	ld	s1,64(sp)
    80000a06:	6526                	ld	a0,72(sp)
    80000a08:	65c6                	ld	a1,80(sp)
    80000a0a:	6666                	ld	a2,88(sp)
    80000a0c:	7686                	ld	a3,96(sp)
    80000a0e:	7726                	ld	a4,104(sp)
    80000a10:	77c6                	ld	a5,112(sp)
    80000a12:	7866                	ld	a6,120(sp)
    80000a14:	688a                	ld	a7,128(sp)
    80000a16:	692a                	ld	s2,136(sp)
    80000a18:	69ca                	ld	s3,144(sp)
    80000a1a:	6a6a                	ld	s4,152(sp)
    80000a1c:	7a8a                	ld	s5,160(sp)
    80000a1e:	7b2a                	ld	s6,168(sp)
    80000a20:	7bca                	ld	s7,176(sp)
    80000a22:	7c6a                	ld	s8,184(sp)
    80000a24:	6c8e                	ld	s9,192(sp)
    80000a26:	6d2e                	ld	s10,200(sp)
    80000a28:	6dce                	ld	s11,208(sp)
    80000a2a:	6e6e                	ld	t3,216(sp)
    80000a2c:	7e8e                	ld	t4,224(sp)
    80000a2e:	7f2e                	ld	t5,232(sp)
    80000a30:	7fce                	ld	t6,240(sp)
    80000a32:	6111                	addi	sp,sp,256
    80000a34:	10200073          	sret
    80000a38:	00000013          	nop
    80000a3c:	00000013          	nop

0000000080000a40 <proc_sched>:
    80000a40:	7111                	addi	sp,sp,-256
    80000a42:	e006                	sd	ra,0(sp)
    80000a44:	e40a                	sd	sp,8(sp)
    80000a46:	e80e                	sd	gp,16(sp)
    80000a48:	ec12                	sd	tp,24(sp)
    80000a4a:	f016                	sd	t0,32(sp)
    80000a4c:	f41a                	sd	t1,40(sp)
    80000a4e:	f81e                	sd	t2,48(sp)
    80000a50:	fc22                	sd	s0,56(sp)
    80000a52:	e0a6                	sd	s1,64(sp)
    80000a54:	e4aa                	sd	a0,72(sp)
    80000a56:	e8ae                	sd	a1,80(sp)
    80000a58:	ecb2                	sd	a2,88(sp)
    80000a5a:	f0b6                	sd	a3,96(sp)
    80000a5c:	f4ba                	sd	a4,104(sp)
    80000a5e:	f8be                	sd	a5,112(sp)
    80000a60:	fcc2                	sd	a6,120(sp)
    80000a62:	e146                	sd	a7,128(sp)
    80000a64:	e54a                	sd	s2,136(sp)
    80000a66:	e94e                	sd	s3,144(sp)
    80000a68:	ed52                	sd	s4,152(sp)
    80000a6a:	f156                	sd	s5,160(sp)
    80000a6c:	f55a                	sd	s6,168(sp)
    80000a6e:	f95e                	sd	s7,176(sp)
    80000a70:	fd62                	sd	s8,184(sp)
    80000a72:	e1e6                	sd	s9,192(sp)
    80000a74:	e5ea                	sd	s10,200(sp)
    80000a76:	e9ee                	sd	s11,208(sp)
    80000a78:	edf2                	sd	t3,216(sp)
    80000a7a:	f1f6                	sd	t4,224(sp)
    80000a7c:	f5fa                	sd	t5,232(sp)
    80000a7e:	f9fe                	sd	t6,240(sp)
    80000a80:	044010ef          	jal	ra,80001ac4 <yeild>
    80000a84:	6082                	ld	ra,0(sp)
    80000a86:	6122                	ld	sp,8(sp)
    80000a88:	61c2                	ld	gp,16(sp)
    80000a8a:	6262                	ld	tp,24(sp)
    80000a8c:	7282                	ld	t0,32(sp)
    80000a8e:	7322                	ld	t1,40(sp)
    80000a90:	73c2                	ld	t2,48(sp)
    80000a92:	7462                	ld	s0,56(sp)
    80000a94:	6486                	ld	s1,64(sp)
    80000a96:	6526                	ld	a0,72(sp)
    80000a98:	65c6                	ld	a1,80(sp)
    80000a9a:	6666                	ld	a2,88(sp)
    80000a9c:	7686                	ld	a3,96(sp)
    80000a9e:	7726                	ld	a4,104(sp)
    80000aa0:	77c6                	ld	a5,112(sp)
    80000aa2:	7866                	ld	a6,120(sp)
    80000aa4:	688a                	ld	a7,128(sp)
    80000aa6:	692a                	ld	s2,136(sp)
    80000aa8:	69ca                	ld	s3,144(sp)
    80000aaa:	6a6a                	ld	s4,152(sp)
    80000aac:	7a8a                	ld	s5,160(sp)
    80000aae:	7b2a                	ld	s6,168(sp)
    80000ab0:	7bca                	ld	s7,176(sp)
    80000ab2:	7c6a                	ld	s8,184(sp)
    80000ab4:	6c8e                	ld	s9,192(sp)
    80000ab6:	6d2e                	ld	s10,200(sp)
    80000ab8:	6dce                	ld	s11,208(sp)
    80000aba:	6e6e                	ld	t3,216(sp)
    80000abc:	7e8e                	ld	t4,224(sp)
    80000abe:	7f2e                	ld	t5,232(sp)
    80000ac0:	7fce                	ld	t6,240(sp)
    80000ac2:	6111                	addi	sp,sp,256
    80000ac4:	00003297          	auipc	t0,0x3
    80000ac8:	5442b283          	ld	t0,1348(t0) # 80004008 <trap_pc>
    80000acc:	8282                	jr	t0
    80000ace:	0001                	nop

0000000080000ad0 <timervec>:
    80000ad0:	34051573          	csrrw	a0,mscratch,a0
    80000ad4:	e10c                	sd	a1,0(a0)
    80000ad6:	e510                	sd	a2,8(a0)
    80000ad8:	e914                	sd	a3,16(a0)
    80000ada:	710c                	ld	a1,32(a0)
    80000adc:	7510                	ld	a2,40(a0)
    80000ade:	6194                	ld	a3,0(a1)
    80000ae0:	96b2                	add	a3,a3,a2
    80000ae2:	e194                	sd	a3,0(a1)
    80000ae4:	4589                	li	a1,2
    80000ae6:	14459073          	csrw	sip,a1
    80000aea:	6914                	ld	a3,16(a0)
    80000aec:	6510                	ld	a2,8(a0)
    80000aee:	610c                	ld	a1,0(a0)
    80000af0:	34051573          	csrrw	a0,mscratch,a0
    80000af4:	30200073          	mret

0000000080000af8 <execret>:
void execra(struct context *, struct context *, uint64);

extern void userret(uint64 fn, uint64 sp);

// exec返回函数, 该函数释放进程锁，并返回到需要执行的代码
void execret() {
    80000af8:	1101                	addi	sp,sp,-32
    80000afa:	ec06                	sd	ra,24(sp)
    80000afc:	e822                	sd	s0,16(sp)
    80000afe:	e426                	sd	s1,8(sp)
    80000b00:	1000                	addi	s0,sp,32
  asm volatile("mv %0, tp" : "=r" (x) );
    80000b02:	8792                	mv	a5,tp
    return mycpu()->proc;
    80000b04:	2781                	sext.w	a5,a5
    80000b06:	079e                	slli	a5,a5,0x7
    80000b08:	00004717          	auipc	a4,0x4
    80000b0c:	71870713          	addi	a4,a4,1816 # 80005220 <cpus>
    80000b10:	97ba                	add	a5,a5,a4
    80000b12:	6384                	ld	s1,0(a5)
    struct proc *p = myproc();
    printf("%p\n",p->trapframe.a0);
    80000b14:	6ccc                	ld	a1,152(s1)
    80000b16:	00002517          	auipc	a0,0x2
    80000b1a:	5ca50513          	addi	a0,a0,1482 # 800030e0 <digits+0xa8>
    80000b1e:	00000097          	auipc	ra,0x0
    80000b22:	9b4080e7          	jalr	-1612(ra) # 800004d2 <printf>
    spin_unlock(&p->proc_lock);
    80000b26:	14848513          	addi	a0,s1,328
    80000b2a:	00002097          	auipc	ra,0x2
    80000b2e:	32c080e7          	jalr	812(ra) # 80002e56 <spin_unlock>
    userret(p->trapframe.a0, p->context.sp);
    80000b32:	1704b583          	ld	a1,368(s1)
    80000b36:	6cc8                	ld	a0,152(s1)
    80000b38:	00001097          	auipc	ra,0x1
    80000b3c:	058080e7          	jalr	88(ra) # 80001b90 <userret>
}
    80000b40:	60e2                	ld	ra,24(sp)
    80000b42:	6442                	ld	s0,16(sp)
    80000b44:	64a2                	ld	s1,8(sp)
    80000b46:	6105                	addi	sp,sp,32
    80000b48:	8082                	ret

0000000080000b4a <strcpy>:
#include "kernel/types.h"

//string utils
char* strcpy(char* s, const char* t)
{
    80000b4a:	1141                	addi	sp,sp,-16
    80000b4c:	e422                	sd	s0,8(sp)
    80000b4e:	0800                	addi	s0,sp,16
    char* os;
    os = s;
    while ((*s++ = *t++) != 0)
    80000b50:	87aa                	mv	a5,a0
    80000b52:	0585                	addi	a1,a1,1
    80000b54:	0785                	addi	a5,a5,1
    80000b56:	fff5c703          	lbu	a4,-1(a1)
    80000b5a:	fee78fa3          	sb	a4,-1(a5) # c200fff <_entry-0x73dff001>
    80000b5e:	fb75                	bnez	a4,80000b52 <strcpy+0x8>
        ;
    return os;
}
    80000b60:	6422                	ld	s0,8(sp)
    80000b62:	0141                	addi	sp,sp,16
    80000b64:	8082                	ret

0000000080000b66 <strcmp>:

int strcmp(const char* p, const char* q)
{
    80000b66:	1141                	addi	sp,sp,-16
    80000b68:	e422                	sd	s0,8(sp)
    80000b6a:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
    80000b6c:	00054783          	lbu	a5,0(a0)
    80000b70:	cb91                	beqz	a5,80000b84 <strcmp+0x1e>
    80000b72:	0005c703          	lbu	a4,0(a1)
    80000b76:	00f71763          	bne	a4,a5,80000b84 <strcmp+0x1e>
        p++, q++;
    80000b7a:	0505                	addi	a0,a0,1
    80000b7c:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
    80000b7e:	00054783          	lbu	a5,0(a0)
    80000b82:	fbe5                	bnez	a5,80000b72 <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
    80000b84:	0005c503          	lbu	a0,0(a1)
}
    80000b88:	40a7853b          	subw	a0,a5,a0
    80000b8c:	6422                	ld	s0,8(sp)
    80000b8e:	0141                	addi	sp,sp,16
    80000b90:	8082                	ret

0000000080000b92 <strchr>:

char* strchr(const char* s, char c)
{
    80000b92:	1141                	addi	sp,sp,-16
    80000b94:	e422                	sd	s0,8(sp)
    80000b96:	0800                	addi	s0,sp,16
    for (; *s; s++)
    80000b98:	00054783          	lbu	a5,0(a0)
    80000b9c:	cb99                	beqz	a5,80000bb2 <strchr+0x20>
        if (*s == c)
    80000b9e:	00f58763          	beq	a1,a5,80000bac <strchr+0x1a>
    for (; *s; s++)
    80000ba2:	0505                	addi	a0,a0,1
    80000ba4:	00054783          	lbu	a5,0(a0)
    80000ba8:	fbfd                	bnez	a5,80000b9e <strchr+0xc>
            return (char*)s;
    return 0;
    80000baa:	4501                	li	a0,0
}
    80000bac:	6422                	ld	s0,8(sp)
    80000bae:	0141                	addi	sp,sp,16
    80000bb0:	8082                	ret
    return 0;
    80000bb2:	4501                	li	a0,0
    80000bb4:	bfe5                	j	80000bac <strchr+0x1a>

0000000080000bb6 <atoi>:
//     buf[i] = '\0';
//     return buf;
// }

int atoi(const char* s)
{
    80000bb6:	1141                	addi	sp,sp,-16
    80000bb8:	e422                	sd	s0,8(sp)
    80000bba:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
    80000bbc:	00054603          	lbu	a2,0(a0)
    80000bc0:	fd06079b          	addiw	a5,a2,-48
    80000bc4:	0ff7f793          	andi	a5,a5,255
    80000bc8:	4725                	li	a4,9
    80000bca:	02f76963          	bltu	a4,a5,80000bfc <atoi+0x46>
    80000bce:	86aa                	mv	a3,a0
    n = 0;
    80000bd0:	4501                	li	a0,0
    while ('0' <= *s && *s <= '9')
    80000bd2:	45a5                	li	a1,9
        n = n * 10 + *s++ - '0';
    80000bd4:	0685                	addi	a3,a3,1
    80000bd6:	0025179b          	slliw	a5,a0,0x2
    80000bda:	9fa9                	addw	a5,a5,a0
    80000bdc:	0017979b          	slliw	a5,a5,0x1
    80000be0:	9fb1                	addw	a5,a5,a2
    80000be2:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
    80000be6:	0006c603          	lbu	a2,0(a3)
    80000bea:	fd06071b          	addiw	a4,a2,-48
    80000bee:	0ff77713          	andi	a4,a4,255
    80000bf2:	fee5f1e3          	bgeu	a1,a4,80000bd4 <atoi+0x1e>
    return n;
}
    80000bf6:	6422                	ld	s0,8(sp)
    80000bf8:	0141                	addi	sp,sp,16
    80000bfa:	8082                	ret
    n = 0;
    80000bfc:	4501                	li	a0,0
    80000bfe:	bfe5                	j	80000bf6 <atoi+0x40>

0000000080000c00 <memcmp>:
//     }
//     return vdst;
// }

int memcmp(const void* s1, const void* s2, uint n)
{
    80000c00:	1141                	addi	sp,sp,-16
    80000c02:	e422                	sd	s0,8(sp)
    80000c04:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0) {
    80000c06:	ca05                	beqz	a2,80000c36 <memcmp+0x36>
    80000c08:	fff6069b          	addiw	a3,a2,-1
    80000c0c:	1682                	slli	a3,a3,0x20
    80000c0e:	9281                	srli	a3,a3,0x20
    80000c10:	0685                	addi	a3,a3,1
    80000c12:	96aa                	add	a3,a3,a0
        if (*p1 != *p2) {
    80000c14:	00054783          	lbu	a5,0(a0)
    80000c18:	0005c703          	lbu	a4,0(a1)
    80000c1c:	00e79863          	bne	a5,a4,80000c2c <memcmp+0x2c>
            return *p1 - *p2;
        }
        p1++;
    80000c20:	0505                	addi	a0,a0,1
        p2++;
    80000c22:	0585                	addi	a1,a1,1
    while (n-- > 0) {
    80000c24:	fed518e3          	bne	a0,a3,80000c14 <memcmp+0x14>
    }
    return 0;
    80000c28:	4501                	li	a0,0
    80000c2a:	a019                	j	80000c30 <memcmp+0x30>
            return *p1 - *p2;
    80000c2c:	40e7853b          	subw	a0,a5,a4
}
    80000c30:	6422                	ld	s0,8(sp)
    80000c32:	0141                	addi	sp,sp,16
    80000c34:	8082                	ret
    return 0;
    80000c36:	4501                	li	a0,0
    80000c38:	bfe5                	j	80000c30 <memcmp+0x30>

0000000080000c3a <memcpy>:

void* memcpy(void* dst, const void* src, uint n)
{
    80000c3a:	1141                	addi	sp,sp,-16
    80000c3c:	e406                	sd	ra,8(sp)
    80000c3e:	e022                	sd	s0,0(sp)
    80000c40:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
    80000c42:	00001097          	auipc	ra,0x1
    80000c46:	c4a080e7          	jalr	-950(ra) # 8000188c <memmove>
}
    80000c4a:	60a2                	ld	ra,8(sp)
    80000c4c:	6402                	ld	s0,0(sp)
    80000c4e:	0141                	addi	sp,sp,16
    80000c50:	8082                	ret

0000000080000c52 <min>:

//math utils
int min(int a, int b)
{
    80000c52:	1141                	addi	sp,sp,-16
    80000c54:	e422                	sd	s0,8(sp)
    80000c56:	0800                	addi	s0,sp,16
    return a < b ? a : b;
    80000c58:	87ae                	mv	a5,a1
    80000c5a:	00b55363          	bge	a0,a1,80000c60 <min+0xe>
    80000c5e:	87aa                	mv	a5,a0
}
    80000c60:	0007851b          	sext.w	a0,a5
    80000c64:	6422                	ld	s0,8(sp)
    80000c66:	0141                	addi	sp,sp,16
    80000c68:	8082                	ret

0000000080000c6a <max>:
int max(int a, int b)
{
    80000c6a:	1141                	addi	sp,sp,-16
    80000c6c:	e422                	sd	s0,8(sp)
    80000c6e:	0800                	addi	s0,sp,16
    return a > b ? a : b;
    80000c70:	87ae                	mv	a5,a1
    80000c72:	00a5d363          	bge	a1,a0,80000c78 <max+0xe>
    80000c76:	87aa                	mv	a5,a0
}
    80000c78:	0007851b          	sext.w	a0,a5
    80000c7c:	6422                	ld	s0,8(sp)
    80000c7e:	0141                	addi	sp,sp,16
    80000c80:	8082                	ret

0000000080000c82 <init_process_table>:
void init_process_table() {
    80000c82:	7139                	addi	sp,sp,-64
    80000c84:	fc06                	sd	ra,56(sp)
    80000c86:	f822                	sd	s0,48(sp)
    80000c88:	f426                	sd	s1,40(sp)
    80000c8a:	f04a                	sd	s2,32(sp)
    80000c8c:	ec4e                	sd	s3,24(sp)
    80000c8e:	e852                	sd	s4,16(sp)
    80000c90:	e456                	sd	s5,8(sp)
    80000c92:	e05a                	sd	s6,0(sp)
    80000c94:	0080                	addi	s0,sp,64
    for (int i = 0; i < NPROC; i++) {
    80000c96:	00046497          	auipc	s1,0x46
    80000c9a:	89a48493          	addi	s1,s1,-1894 # 80046530 <proc_table+0x148>
    80000c9e:	00004997          	auipc	s3,0x4
    80000ca2:	74a98993          	addi	s3,s3,1866 # 800053e8 <stack>
    80000ca6:	4901                	li	s2,0
        spinlock_init(&p->proc_lock, "proc");
    80000ca8:	00002b17          	auipc	s6,0x2
    80000cac:	440b0b13          	addi	s6,s6,1088 # 800030e8 <digits+0xb0>
    80000cb0:	6a85                	lui	s5,0x1
    for (int i = 0; i < NPROC; i++) {
    80000cb2:	04000a13          	li	s4,64
        spinlock_init(&p->proc_lock, "proc");
    80000cb6:	85da                	mv	a1,s6
    80000cb8:	8526                	mv	a0,s1
    80000cba:	00002097          	auipc	ra,0x2
    80000cbe:	038080e7          	jalr	56(ra) # 80002cf2 <spinlock_init>
        p->pid = i;
    80000cc2:	ed24ac23          	sw	s2,-296(s1)
        p->kstack = (uint64) stack + PGSIZE * i;
    80000cc6:	0134bc23          	sd	s3,24(s1)
        p->state = UNUSED;
    80000cca:	ea04ac23          	sw	zero,-328(s1)
    for (int i = 0; i < NPROC; i++) {
    80000cce:	2905                	addiw	s2,s2,1
    80000cd0:	1e848493          	addi	s1,s1,488
    80000cd4:	99d6                	add	s3,s3,s5
    80000cd6:	ff4910e3          	bne	s2,s4,80000cb6 <init_process_table+0x34>
}
    80000cda:	70e2                	ld	ra,56(sp)
    80000cdc:	7442                	ld	s0,48(sp)
    80000cde:	74a2                	ld	s1,40(sp)
    80000ce0:	7902                	ld	s2,32(sp)
    80000ce2:	69e2                	ld	s3,24(sp)
    80000ce4:	6a42                	ld	s4,16(sp)
    80000ce6:	6aa2                	ld	s5,8(sp)
    80000ce8:	6b02                	ld	s6,0(sp)
    80000cea:	6121                	addi	sp,sp,64
    80000cec:	8082                	ret

0000000080000cee <alloc_proc>:
struct proc *alloc_proc() {
    80000cee:	1101                	addi	sp,sp,-32
    80000cf0:	ec06                	sd	ra,24(sp)
    80000cf2:	e822                	sd	s0,16(sp)
    80000cf4:	e426                	sd	s1,8(sp)
    80000cf6:	1000                	addi	s0,sp,32
    for (int i = 0; i < NPROC; i++) {
    80000cf8:	00045717          	auipc	a4,0x45
    80000cfc:	6f070713          	addi	a4,a4,1776 # 800463e8 <proc_table>
    80000d00:	4781                	li	a5,0
    80000d02:	04000613          	li	a2,64
        if (p->state == UNUSED) {
    80000d06:	4314                	lw	a3,0(a4)
    80000d08:	ca81                	beqz	a3,80000d18 <alloc_proc+0x2a>
    for (int i = 0; i < NPROC; i++) {
    80000d0a:	2785                	addiw	a5,a5,1
    80000d0c:	1e870713          	addi	a4,a4,488
    80000d10:	fec79be3          	bne	a5,a2,80000d06 <alloc_proc+0x18>
    return 0;
    80000d14:	4481                	li	s1,0
    80000d16:	a81d                	j	80000d4c <alloc_proc+0x5e>
    80000d18:	1e800513          	li	a0,488
    80000d1c:	02a787b3          	mul	a5,a5,a0
        p = &proc_table[i];
    80000d20:	00045517          	auipc	a0,0x45
    80000d24:	6c850513          	addi	a0,a0,1736 # 800463e8 <proc_table>
    80000d28:	00a784b3          	add	s1,a5,a0
            memset(&p->context, 0, sizeof(p->context));
    80000d2c:	16878793          	addi	a5,a5,360
    80000d30:	07000613          	li	a2,112
    80000d34:	4581                	li	a1,0
    80000d36:	953e                	add	a0,a0,a5
    80000d38:	00001097          	auipc	ra,0x1
    80000d3c:	b2e080e7          	jalr	-1234(ra) # 80001866 <memset>
            p->context.sp = p->kstack + PGSIZE;
    80000d40:	1604b783          	ld	a5,352(s1)
    80000d44:	6705                	lui	a4,0x1
    80000d46:	97ba                	add	a5,a5,a4
    80000d48:	16f4b823          	sd	a5,368(s1)
}
    80000d4c:	8526                	mv	a0,s1
    80000d4e:	60e2                	ld	ra,24(sp)
    80000d50:	6442                	ld	s0,16(sp)
    80000d52:	64a2                	ld	s1,8(sp)
    80000d54:	6105                	addi	sp,sp,32
    80000d56:	8082                	ret

0000000080000d58 <init_first_process>:
void init_first_process() {
    80000d58:	1141                	addi	sp,sp,-16
    80000d5a:	e406                	sd	ra,8(sp)
    80000d5c:	e022                	sd	s0,0(sp)
    80000d5e:	0800                	addi	s0,sp,16
    struct proc *p = alloc_proc();
    80000d60:	00000097          	auipc	ra,0x0
    80000d64:	f8e080e7          	jalr	-114(ra) # 80000cee <alloc_proc>
    p->context.ra = (uint64) init;
    80000d68:	00001797          	auipc	a5,0x1
    80000d6c:	a0278793          	addi	a5,a5,-1534 # 8000176a <init>
    80000d70:	16f53423          	sd	a5,360(a0)
    p->state = RUNNABLE;
    80000d74:	4789                	li	a5,2
    80000d76:	c11c                	sw	a5,0(a0)
    initproc = p;
    80000d78:	00003797          	auipc	a5,0x3
    80000d7c:	2aa7b023          	sd	a0,672(a5) # 80004018 <initproc>
}
    80000d80:	60a2                	ld	ra,8(sp)
    80000d82:	6402                	ld	s0,0(sp)
    80000d84:	0141                	addi	sp,sp,16
    80000d86:	8082                	ret

0000000080000d88 <cpuid>:
int cpuid() {
    80000d88:	1141                	addi	sp,sp,-16
    80000d8a:	e422                	sd	s0,8(sp)
    80000d8c:	0800                	addi	s0,sp,16
    80000d8e:	8512                	mv	a0,tp
}
    80000d90:	2501                	sext.w	a0,a0
    80000d92:	6422                	ld	s0,8(sp)
    80000d94:	0141                	addi	sp,sp,16
    80000d96:	8082                	ret

0000000080000d98 <mycpu>:
struct cpu *mycpu(void) {
    80000d98:	1141                	addi	sp,sp,-16
    80000d9a:	e422                	sd	s0,8(sp)
    80000d9c:	0800                	addi	s0,sp,16
    80000d9e:	8792                	mv	a5,tp
    struct cpu *c = &cpus[id];
    80000da0:	2781                	sext.w	a5,a5
    80000da2:	079e                	slli	a5,a5,0x7
}
    80000da4:	00004517          	auipc	a0,0x4
    80000da8:	47c50513          	addi	a0,a0,1148 # 80005220 <cpus>
    80000dac:	953e                	add	a0,a0,a5
    80000dae:	6422                	ld	s0,8(sp)
    80000db0:	0141                	addi	sp,sp,16
    80000db2:	8082                	ret

0000000080000db4 <myproc>:
struct proc *myproc() {
    80000db4:	1141                	addi	sp,sp,-16
    80000db6:	e422                	sd	s0,8(sp)
    80000db8:	0800                	addi	s0,sp,16
    80000dba:	8792                	mv	a5,tp
    return mycpu()->proc;
    80000dbc:	2781                	sext.w	a5,a5
    80000dbe:	079e                	slli	a5,a5,0x7
    80000dc0:	00004717          	auipc	a4,0x4
    80000dc4:	46070713          	addi	a4,a4,1120 # 80005220 <cpus>
    80000dc8:	97ba                	add	a5,a5,a4
}
    80000dca:	6388                	ld	a0,0(a5)
    80000dcc:	6422                	ld	s0,8(sp)
    80000dce:	0141                	addi	sp,sp,16
    80000dd0:	8082                	ret

0000000080000dd2 <before_sched>:
void before_sched() {
    80000dd2:	7179                	addi	sp,sp,-48
    80000dd4:	f406                	sd	ra,40(sp)
    80000dd6:	f022                	sd	s0,32(sp)
    80000dd8:	ec26                	sd	s1,24(sp)
    80000dda:	e84a                	sd	s2,16(sp)
    80000ddc:	e44e                	sd	s3,8(sp)
    80000dde:	1800                	addi	s0,sp,48
    80000de0:	8792                	mv	a5,tp
    return mycpu()->proc;
    80000de2:	2781                	sext.w	a5,a5
    80000de4:	079e                	slli	a5,a5,0x7
    80000de6:	00004717          	auipc	a4,0x4
    80000dea:	43a70713          	addi	a4,a4,1082 # 80005220 <cpus>
    80000dee:	97ba                	add	a5,a5,a4
    80000df0:	0007b903          	ld	s2,0(a5)
    if (!spin_holding(&p->proc_lock))
    80000df4:	14890513          	addi	a0,s2,328
    80000df8:	00002097          	auipc	ra,0x2
    80000dfc:	f10080e7          	jalr	-240(ra) # 80002d08 <spin_holding>
    80000e00:	c925                	beqz	a0,80000e70 <before_sched+0x9e>
    80000e02:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    80000e04:	2781                	sext.w	a5,a5
    80000e06:	079e                	slli	a5,a5,0x7
    80000e08:	00004717          	auipc	a4,0x4
    80000e0c:	41870713          	addi	a4,a4,1048 # 80005220 <cpus>
    80000e10:	97ba                	add	a5,a5,a4
    80000e12:	5fb8                	lw	a4,120(a5)
    80000e14:	4785                	li	a5,1
    80000e16:	06f71663          	bne	a4,a5,80000e82 <before_sched+0xb0>
    if (p->state == RUNNING)
    80000e1a:	00092703          	lw	a4,0(s2)
    80000e1e:	478d                	li	a5,3
    80000e20:	06f70a63          	beq	a4,a5,80000e94 <before_sched+0xc2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000e24:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000e28:	8b89                	andi	a5,a5,2
    if (intr_get())
    80000e2a:	efb5                	bnez	a5,80000ea6 <before_sched+0xd4>
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e2c:	8792                	mv	a5,tp
    intr_enable = mycpu()->intr_enable;
    80000e2e:	00004497          	auipc	s1,0x4
    80000e32:	3f248493          	addi	s1,s1,1010 # 80005220 <cpus>
    80000e36:	2781                	sext.w	a5,a5
    80000e38:	079e                	slli	a5,a5,0x7
    80000e3a:	97a6                	add	a5,a5,s1
    80000e3c:	07c7a983          	lw	s3,124(a5)
    80000e40:	8592                	mv	a1,tp
    pswitch(&p->context, &mycpu()->context);
    80000e42:	2581                	sext.w	a1,a1
    80000e44:	059e                	slli	a1,a1,0x7
    80000e46:	05a1                	addi	a1,a1,8
    80000e48:	95a6                	add	a1,a1,s1
    80000e4a:	16890513          	addi	a0,s2,360
    80000e4e:	00001097          	auipc	ra,0x1
    80000e52:	b3e080e7          	jalr	-1218(ra) # 8000198c <pswitch>
    80000e56:	8792                	mv	a5,tp
    mycpu()->intr_enable = intr_enable;
    80000e58:	2781                	sext.w	a5,a5
    80000e5a:	079e                	slli	a5,a5,0x7
    80000e5c:	94be                	add	s1,s1,a5
    80000e5e:	0734ae23          	sw	s3,124(s1)
}
    80000e62:	70a2                	ld	ra,40(sp)
    80000e64:	7402                	ld	s0,32(sp)
    80000e66:	64e2                	ld	s1,24(sp)
    80000e68:	6942                	ld	s2,16(sp)
    80000e6a:	69a2                	ld	s3,8(sp)
    80000e6c:	6145                	addi	sp,sp,48
    80000e6e:	8082                	ret
        panic("sched p->lock");
    80000e70:	00002517          	auipc	a0,0x2
    80000e74:	28050513          	addi	a0,a0,640 # 800030f0 <digits+0xb8>
    80000e78:	00000097          	auipc	ra,0x0
    80000e7c:	88c080e7          	jalr	-1908(ra) # 80000704 <panic>
    80000e80:	b749                	j	80000e02 <before_sched+0x30>
        panic("sched locks");
    80000e82:	00002517          	auipc	a0,0x2
    80000e86:	27e50513          	addi	a0,a0,638 # 80003100 <digits+0xc8>
    80000e8a:	00000097          	auipc	ra,0x0
    80000e8e:	87a080e7          	jalr	-1926(ra) # 80000704 <panic>
    80000e92:	b761                	j	80000e1a <before_sched+0x48>
        panic("sched running");
    80000e94:	00002517          	auipc	a0,0x2
    80000e98:	27c50513          	addi	a0,a0,636 # 80003110 <digits+0xd8>
    80000e9c:	00000097          	auipc	ra,0x0
    80000ea0:	868080e7          	jalr	-1944(ra) # 80000704 <panic>
    80000ea4:	b741                	j	80000e24 <before_sched+0x52>
        panic("sched interruptible");
    80000ea6:	00002517          	auipc	a0,0x2
    80000eaa:	27a50513          	addi	a0,a0,634 # 80003120 <digits+0xe8>
    80000eae:	00000097          	auipc	ra,0x0
    80000eb2:	856080e7          	jalr	-1962(ra) # 80000704 <panic>
    80000eb6:	bf9d                	j	80000e2c <before_sched+0x5a>

0000000080000eb8 <sleep>:
void sleep(void *chan, struct spinlock *lock) {
    80000eb8:	7179                	addi	sp,sp,-48
    80000eba:	f406                	sd	ra,40(sp)
    80000ebc:	f022                	sd	s0,32(sp)
    80000ebe:	ec26                	sd	s1,24(sp)
    80000ec0:	e84a                	sd	s2,16(sp)
    80000ec2:	e44e                	sd	s3,8(sp)
    80000ec4:	e052                	sd	s4,0(sp)
    80000ec6:	1800                	addi	s0,sp,48
    80000ec8:	89aa                	mv	s3,a0
    80000eca:	8792                	mv	a5,tp
    return mycpu()->proc;
    80000ecc:	2781                	sext.w	a5,a5
    80000ece:	079e                	slli	a5,a5,0x7
    80000ed0:	00004717          	auipc	a4,0x4
    80000ed4:	35070713          	addi	a4,a4,848 # 80005220 <cpus>
    80000ed8:	97ba                	add	a5,a5,a4
    80000eda:	0007b903          	ld	s2,0(a5)
    if (lock != &p->proc_lock) {  //DOC: sleeplock0
    80000ede:	14890a13          	addi	s4,s2,328
    80000ee2:	04ba0a63          	beq	s4,a1,80000f36 <sleep+0x7e>
    80000ee6:	84ae                	mv	s1,a1
        spin_lock(&p->proc_lock);  //DOC: sleeplock1
    80000ee8:	8552                	mv	a0,s4
    80000eea:	00002097          	auipc	ra,0x2
    80000eee:	e98080e7          	jalr	-360(ra) # 80002d82 <spin_lock>
        spin_unlock(lock);
    80000ef2:	8526                	mv	a0,s1
    80000ef4:	00002097          	auipc	ra,0x2
    80000ef8:	f62080e7          	jalr	-158(ra) # 80002e56 <spin_unlock>
    p->chan = chan;
    80000efc:	01393823          	sd	s3,16(s2)
    p->state = SLEEPING;
    80000f00:	4785                	li	a5,1
    80000f02:	00f92023          	sw	a5,0(s2)
    before_sched();
    80000f06:	00000097          	auipc	ra,0x0
    80000f0a:	ecc080e7          	jalr	-308(ra) # 80000dd2 <before_sched>
    p->chan = 0;
    80000f0e:	00093823          	sd	zero,16(s2)
        spin_unlock(&p->proc_lock);
    80000f12:	8552                	mv	a0,s4
    80000f14:	00002097          	auipc	ra,0x2
    80000f18:	f42080e7          	jalr	-190(ra) # 80002e56 <spin_unlock>
        spin_lock(lock);
    80000f1c:	8526                	mv	a0,s1
    80000f1e:	00002097          	auipc	ra,0x2
    80000f22:	e64080e7          	jalr	-412(ra) # 80002d82 <spin_lock>
}
    80000f26:	70a2                	ld	ra,40(sp)
    80000f28:	7402                	ld	s0,32(sp)
    80000f2a:	64e2                	ld	s1,24(sp)
    80000f2c:	6942                	ld	s2,16(sp)
    80000f2e:	69a2                	ld	s3,8(sp)
    80000f30:	6a02                	ld	s4,0(sp)
    80000f32:	6145                	addi	sp,sp,48
    80000f34:	8082                	ret
    p->chan = chan;
    80000f36:	00a93823          	sd	a0,16(s2)
    p->state = SLEEPING;
    80000f3a:	4785                	li	a5,1
    80000f3c:	00f92023          	sw	a5,0(s2)
    before_sched();
    80000f40:	00000097          	auipc	ra,0x0
    80000f44:	e92080e7          	jalr	-366(ra) # 80000dd2 <before_sched>
    p->chan = 0;
    80000f48:	00093823          	sd	zero,16(s2)
    if (lock != &p->proc_lock) {
    80000f4c:	bfe9                	j	80000f26 <sleep+0x6e>

0000000080000f4e <sleep_time>:
void sleep_time(uint64 sleep_ticks) {
    80000f4e:	7179                	addi	sp,sp,-48
    80000f50:	f406                	sd	ra,40(sp)
    80000f52:	f022                	sd	s0,32(sp)
    80000f54:	ec26                	sd	s1,24(sp)
    80000f56:	e84a                	sd	s2,16(sp)
    80000f58:	e44e                	sd	s3,8(sp)
    80000f5a:	e052                	sd	s4,0(sp)
    80000f5c:	1800                	addi	s0,sp,48
    80000f5e:	892a                	mv	s2,a0
    uint64 now = ticks;
    80000f60:	00003497          	auipc	s1,0x3
    80000f64:	0b048493          	addi	s1,s1,176 # 80004010 <ticks>
    80000f68:	0004b983          	ld	s3,0(s1)
    spin_lock(&ticks_lock);
    80000f6c:	00004517          	auipc	a0,0x4
    80000f70:	29c50513          	addi	a0,a0,668 # 80005208 <ticks_lock>
    80000f74:	00002097          	auipc	ra,0x2
    80000f78:	e0e080e7          	jalr	-498(ra) # 80002d82 <spin_lock>
    for (; ticks - now < sleep_ticks;) {
    80000f7c:	609c                	ld	a5,0(s1)
    80000f7e:	413787b3          	sub	a5,a5,s3
    80000f82:	0327f163          	bgeu	a5,s2,80000fa4 <sleep_time+0x56>
        sleep(&ticks, &ticks_lock);
    80000f86:	00004a17          	auipc	s4,0x4
    80000f8a:	282a0a13          	addi	s4,s4,642 # 80005208 <ticks_lock>
    80000f8e:	85d2                	mv	a1,s4
    80000f90:	8526                	mv	a0,s1
    80000f92:	00000097          	auipc	ra,0x0
    80000f96:	f26080e7          	jalr	-218(ra) # 80000eb8 <sleep>
    for (; ticks - now < sleep_ticks;) {
    80000f9a:	609c                	ld	a5,0(s1)
    80000f9c:	413787b3          	sub	a5,a5,s3
    80000fa0:	ff27e7e3          	bltu	a5,s2,80000f8e <sleep_time+0x40>
    spin_unlock(&ticks_lock);
    80000fa4:	00004517          	auipc	a0,0x4
    80000fa8:	26450513          	addi	a0,a0,612 # 80005208 <ticks_lock>
    80000fac:	00002097          	auipc	ra,0x2
    80000fb0:	eaa080e7          	jalr	-342(ra) # 80002e56 <spin_unlock>
}
    80000fb4:	70a2                	ld	ra,40(sp)
    80000fb6:	7402                	ld	s0,32(sp)
    80000fb8:	64e2                	ld	s1,24(sp)
    80000fba:	6942                	ld	s2,16(sp)
    80000fbc:	69a2                	ld	s3,8(sp)
    80000fbe:	6a02                	ld	s4,0(sp)
    80000fc0:	6145                	addi	sp,sp,48
    80000fc2:	8082                	ret

0000000080000fc4 <wakeup>:
void wakeup(void *chan) {
    80000fc4:	1141                	addi	sp,sp,-16
    80000fc6:	e422                	sd	s0,8(sp)
    80000fc8:	0800                	addi	s0,sp,16
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80000fca:	00045797          	auipc	a5,0x45
    80000fce:	41e78793          	addi	a5,a5,1054 # 800463e8 <proc_table>
        if (p->state == SLEEPING && p->chan == chan) {
    80000fd2:	4605                	li	a2,1
            p->state = RUNNABLE;
    80000fd4:	4589                	li	a1,2
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80000fd6:	0004d697          	auipc	a3,0x4d
    80000fda:	e1268693          	addi	a3,a3,-494 # 8004dde8 <proc_table+0x7a00>
    80000fde:	a031                	j	80000fea <wakeup+0x26>
            p->state = RUNNABLE;
    80000fe0:	c38c                	sw	a1,0(a5)
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80000fe2:	1e878793          	addi	a5,a5,488
    80000fe6:	00d78963          	beq	a5,a3,80000ff8 <wakeup+0x34>
        if (p->state == SLEEPING && p->chan == chan) {
    80000fea:	4398                	lw	a4,0(a5)
    80000fec:	fec71be3          	bne	a4,a2,80000fe2 <wakeup+0x1e>
    80000ff0:	6b98                	ld	a4,16(a5)
    80000ff2:	fea718e3          	bne	a4,a0,80000fe2 <wakeup+0x1e>
    80000ff6:	b7ed                	j	80000fe0 <wakeup+0x1c>
}
    80000ff8:	6422                	ld	s0,8(sp)
    80000ffa:	0141                	addi	sp,sp,16
    80000ffc:	8082                	ret

0000000080000ffe <scheduler>:
void scheduler() {
    80000ffe:	711d                	addi	sp,sp,-96
    80001000:	ec86                	sd	ra,88(sp)
    80001002:	e8a2                	sd	s0,80(sp)
    80001004:	e4a6                	sd	s1,72(sp)
    80001006:	e0ca                	sd	s2,64(sp)
    80001008:	fc4e                	sd	s3,56(sp)
    8000100a:	f852                	sd	s4,48(sp)
    8000100c:	f456                	sd	s5,40(sp)
    8000100e:	f05a                	sd	s6,32(sp)
    80001010:	ec5e                	sd	s7,24(sp)
    80001012:	e862                	sd	s8,16(sp)
    80001014:	e466                	sd	s9,8(sp)
    80001016:	e06a                	sd	s10,0(sp)
    80001018:	1080                	addi	s0,sp,96
    8000101a:	8792                	mv	a5,tp
    int id = r_tp();
    8000101c:	2781                	sext.w	a5,a5
                pswitch(&c->context, &p->context);
    8000101e:	00779c93          	slli	s9,a5,0x7
    80001022:	00004717          	auipc	a4,0x4
    80001026:	20670713          	addi	a4,a4,518 # 80005228 <cpus+0x8>
    8000102a:	9cba                	add	s9,s9,a4
                wakeup(initproc);
    8000102c:	00003d17          	auipc	s10,0x3
    80001030:	fecd0d13          	addi	s10,s10,-20 # 80004018 <initproc>
            if (p->state == RUNNABLE) {
    80001034:	4a89                	li	s5,2
                c->proc = p;
    80001036:	079e                	slli	a5,a5,0x7
    80001038:	00004b97          	auipc	s7,0x4
    8000103c:	1e8b8b93          	addi	s7,s7,488 # 80005220 <cpus>
    80001040:	9bbe                	add	s7,s7,a5
    80001042:	a0a5                	j	800010aa <scheduler+0xac>
            spin_unlock(&p->proc_lock);
    80001044:	854a                	mv	a0,s2
    80001046:	00002097          	auipc	ra,0x2
    8000104a:	e10080e7          	jalr	-496(ra) # 80002e56 <spin_unlock>
        for (int i = 0; i < NPROC; i++) {
    8000104e:	1e848493          	addi	s1,s1,488
    80001052:	05348263          	beq	s1,s3,80001096 <scheduler+0x98>
            spin_lock(&p->proc_lock);
    80001056:	8926                	mv	s2,s1
    80001058:	8526                	mv	a0,s1
    8000105a:	00002097          	auipc	ra,0x2
    8000105e:	d28080e7          	jalr	-728(ra) # 80002d82 <spin_lock>
            if (p->state != UNUSED && p->state != ZOMBIE) {
    80001062:	eb84a783          	lw	a5,-328(s1)
    80001066:	dff9                	beqz	a5,80001044 <scheduler+0x46>
    80001068:	07678363          	beq	a5,s6,800010ce <scheduler+0xd0>
                alive_p++;
    8000106c:	2a05                	addiw	s4,s4,1
            if (p->state == RUNNABLE) {
    8000106e:	eb892783          	lw	a5,-328(s2)
    80001072:	fd5799e3          	bne	a5,s5,80001044 <scheduler+0x46>
                p->state = RUNNING;
    80001076:	eb892c23          	sw	s8,-328(s2)
                c->proc = p;
    8000107a:	eb848793          	addi	a5,s1,-328
    8000107e:	00fbb023          	sd	a5,0(s7)
                pswitch(&c->context, &p->context);
    80001082:	02048593          	addi	a1,s1,32
    80001086:	8566                	mv	a0,s9
    80001088:	00001097          	auipc	ra,0x1
    8000108c:	904080e7          	jalr	-1788(ra) # 8000198c <pswitch>
                c->proc = 0;
    80001090:	000bb023          	sd	zero,0(s7)
    80001094:	bf45                	j	80001044 <scheduler+0x46>
        if (alive_p <= 2) {
    80001096:	014aca63          	blt	s5,s4,800010aa <scheduler+0xac>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000109a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000109e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800010a2:	10079073          	csrw	sstatus,a5
            asm volatile("wfi");
    800010a6:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800010aa:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800010ae:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800010b2:	10079073          	csrw	sstatus,a5
        for (int i = 0; i < NPROC; i++) {
    800010b6:	00045497          	auipc	s1,0x45
    800010ba:	47a48493          	addi	s1,s1,1146 # 80046530 <proc_table+0x148>
    800010be:	0004d997          	auipc	s3,0x4d
    800010c2:	e7298993          	addi	s3,s3,-398 # 8004df30 <proc_table+0x7b48>
        alive_p = 0;
    800010c6:	4a01                	li	s4,0
            if (p->state != UNUSED && p->state != ZOMBIE) {
    800010c8:	4b11                	li	s6,4
                p->state = RUNNING;
    800010ca:	4c0d                	li	s8,3
    800010cc:	b769                	j	80001056 <scheduler+0x58>
                wakeup(initproc);
    800010ce:	000d3503          	ld	a0,0(s10)
    800010d2:	00000097          	auipc	ra,0x0
    800010d6:	ef2080e7          	jalr	-270(ra) # 80000fc4 <wakeup>
    800010da:	bf51                	j	8000106e <scheduler+0x70>

00000000800010dc <wait>:
int wait(int *status) {
    800010dc:	711d                	addi	sp,sp,-96
    800010de:	ec86                	sd	ra,88(sp)
    800010e0:	e8a2                	sd	s0,80(sp)
    800010e2:	e4a6                	sd	s1,72(sp)
    800010e4:	e0ca                	sd	s2,64(sp)
    800010e6:	fc4e                	sd	s3,56(sp)
    800010e8:	f852                	sd	s4,48(sp)
    800010ea:	f456                	sd	s5,40(sp)
    800010ec:	f05a                	sd	s6,32(sp)
    800010ee:	ec5e                	sd	s7,24(sp)
    800010f0:	e862                	sd	s8,16(sp)
    800010f2:	e466                	sd	s9,8(sp)
    800010f4:	e06a                	sd	s10,0(sp)
    800010f6:	1080                	addi	s0,sp,96
    800010f8:	8baa                	mv	s7,a0
  asm volatile("mv %0, tp" : "=r" (x) );
    800010fa:	8792                	mv	a5,tp
    return mycpu()->proc;
    800010fc:	2781                	sext.w	a5,a5
    800010fe:	079e                	slli	a5,a5,0x7
    80001100:	00004717          	auipc	a4,0x4
    80001104:	12070713          	addi	a4,a4,288 # 80005220 <cpus>
    80001108:	97ba                	add	a5,a5,a4
    8000110a:	0007b903          	ld	s2,0(a5)
    spin_lock(&p->proc_lock);
    8000110e:	14890c13          	addi	s8,s2,328
    80001112:	8562                	mv	a0,s8
    80001114:	00002097          	auipc	ra,0x2
    80001118:	c6e080e7          	jalr	-914(ra) # 80002d82 <spin_lock>
        havechild = 0;
    8000111c:	4c81                	li	s9,0
                if (cp->state == ZOMBIE) {
    8000111e:	4a91                	li	s5,4
        for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    80001120:	0004d997          	auipc	s3,0x4d
    80001124:	cc898993          	addi	s3,s3,-824 # 8004dde8 <proc_table+0x7a00>
                havechild = 1;
    80001128:	4b05                	li	s6,1
    return mycpu()->proc;
    8000112a:	00004d17          	auipc	s10,0x4
    8000112e:	0f6d0d13          	addi	s10,s10,246 # 80005220 <cpus>
        havechild = 0;
    80001132:	8766                	mv	a4,s9
        for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    80001134:	00045497          	auipc	s1,0x45
    80001138:	2b448493          	addi	s1,s1,692 # 800463e8 <proc_table>
    8000113c:	a80d                	j	8000116e <wait+0x92>
                    pid = cp->pid;
    8000113e:	0204a903          	lw	s2,32(s1)
                    if (status) {
    80001142:	000b8563          	beqz	s7,8000114c <wait+0x70>
                        *status = cp->xstate;
    80001146:	4cdc                	lw	a5,28(s1)
    80001148:	00fba023          	sw	a5,0(s7)
                    cp->state = UNUSED;
    8000114c:	0004a023          	sw	zero,0(s1)
                    spin_unlock(&cp->proc_lock);
    80001150:	8552                	mv	a0,s4
    80001152:	00002097          	auipc	ra,0x2
    80001156:	d04080e7          	jalr	-764(ra) # 80002e56 <spin_unlock>
                    spin_unlock(&p->proc_lock);
    8000115a:	8562                	mv	a0,s8
    8000115c:	00002097          	auipc	ra,0x2
    80001160:	cfa080e7          	jalr	-774(ra) # 80002e56 <spin_unlock>
                    return pid;
    80001164:	a81d                	j	8000119a <wait+0xbe>
        for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    80001166:	1e848493          	addi	s1,s1,488
    8000116a:	03348663          	beq	s1,s3,80001196 <wait+0xba>
            if (cp->parent == p) {
    8000116e:	649c                	ld	a5,8(s1)
    80001170:	ff279be3          	bne	a5,s2,80001166 <wait+0x8a>
                spin_lock(&cp->proc_lock);
    80001174:	14848a13          	addi	s4,s1,328
    80001178:	8552                	mv	a0,s4
    8000117a:	00002097          	auipc	ra,0x2
    8000117e:	c08080e7          	jalr	-1016(ra) # 80002d82 <spin_lock>
                if (cp->state == ZOMBIE) {
    80001182:	409c                	lw	a5,0(s1)
    80001184:	fb578de3          	beq	a5,s5,8000113e <wait+0x62>
                spin_unlock(&cp->proc_lock);
    80001188:	8552                	mv	a0,s4
    8000118a:	00002097          	auipc	ra,0x2
    8000118e:	ccc080e7          	jalr	-820(ra) # 80002e56 <spin_unlock>
                havechild = 1;
    80001192:	875a                	mv	a4,s6
    80001194:	bfc9                	j	80001166 <wait+0x8a>
        if (!havechild) {
    80001196:	e30d                	bnez	a4,800011b8 <wait+0xdc>
            return -1;
    80001198:	597d                	li	s2,-1
}
    8000119a:	854a                	mv	a0,s2
    8000119c:	60e6                	ld	ra,88(sp)
    8000119e:	6446                	ld	s0,80(sp)
    800011a0:	64a6                	ld	s1,72(sp)
    800011a2:	6906                	ld	s2,64(sp)
    800011a4:	79e2                	ld	s3,56(sp)
    800011a6:	7a42                	ld	s4,48(sp)
    800011a8:	7aa2                	ld	s5,40(sp)
    800011aa:	7b02                	ld	s6,32(sp)
    800011ac:	6be2                	ld	s7,24(sp)
    800011ae:	6c42                	ld	s8,16(sp)
    800011b0:	6ca2                	ld	s9,8(sp)
    800011b2:	6d02                	ld	s10,0(sp)
    800011b4:	6125                	addi	sp,sp,96
    800011b6:	8082                	ret
    800011b8:	8792                	mv	a5,tp
    return mycpu()->proc;
    800011ba:	2781                	sext.w	a5,a5
    800011bc:	079e                	slli	a5,a5,0x7
    800011be:	97ea                	add	a5,a5,s10
        sleep(p, &myproc()->proc_lock); // 等待子进程唤醒
    800011c0:	638c                	ld	a1,0(a5)
    800011c2:	14858593          	addi	a1,a1,328
    800011c6:	854a                	mv	a0,s2
    800011c8:	00000097          	auipc	ra,0x0
    800011cc:	cf0080e7          	jalr	-784(ra) # 80000eb8 <sleep>
        havechild = 0;
    800011d0:	b78d                	j	80001132 <wait+0x56>

00000000800011d2 <exit>:
void exit(int status) {
    800011d2:	1141                	addi	sp,sp,-16
    800011d4:	e406                	sd	ra,8(sp)
    800011d6:	e022                	sd	s0,0(sp)
    800011d8:	0800                	addi	s0,sp,16
    800011da:	8792                	mv	a5,tp
    return mycpu()->proc;
    800011dc:	2781                	sext.w	a5,a5
    800011de:	079e                	slli	a5,a5,0x7
    800011e0:	00004717          	auipc	a4,0x4
    800011e4:	04070713          	addi	a4,a4,64 # 80005220 <cpus>
    800011e8:	97ba                	add	a5,a5,a4
    800011ea:	6394                	ld	a3,0(a5)
    p->state = ZOMBIE;
    800011ec:	4791                	li	a5,4
    800011ee:	c29c                	sw	a5,0(a3)
    p->xstate = status;
    800011f0:	cec8                	sw	a0,28(a3)
            cp->parent = initproc;
    800011f2:	00003597          	auipc	a1,0x3
    800011f6:	e265b583          	ld	a1,-474(a1) # 80004018 <initproc>
    for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    800011fa:	00045797          	auipc	a5,0x45
    800011fe:	1ee78793          	addi	a5,a5,494 # 800463e8 <proc_table>
    80001202:	0004d617          	auipc	a2,0x4d
    80001206:	be660613          	addi	a2,a2,-1050 # 8004dde8 <proc_table+0x7a00>
    8000120a:	a031                	j	80001216 <exit+0x44>
            cp->parent = initproc;
    8000120c:	e78c                	sd	a1,8(a5)
    for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    8000120e:	1e878793          	addi	a5,a5,488
    80001212:	00c78663          	beq	a5,a2,8000121e <exit+0x4c>
        if (cp->parent == p) {
    80001216:	6798                	ld	a4,8(a5)
    80001218:	fed71be3          	bne	a4,a3,8000120e <exit+0x3c>
    8000121c:	bfc5                	j	8000120c <exit+0x3a>
    wakeup(p->parent);
    8000121e:	6688                	ld	a0,8(a3)
    80001220:	00000097          	auipc	ra,0x0
    80001224:	da4080e7          	jalr	-604(ra) # 80000fc4 <wakeup>
    80001228:	8712                	mv	a4,tp
    8000122a:	8792                	mv	a5,tp
    pswitch(&(myproc()->context), &(mycpu()->context));
    8000122c:	00004597          	auipc	a1,0x4
    80001230:	ff458593          	addi	a1,a1,-12 # 80005220 <cpus>
    80001234:	2781                	sext.w	a5,a5
    80001236:	079e                	slli	a5,a5,0x7
    80001238:	07a1                	addi	a5,a5,8
    return mycpu()->proc;
    8000123a:	2701                	sext.w	a4,a4
    8000123c:	071e                	slli	a4,a4,0x7
    8000123e:	972e                	add	a4,a4,a1
    pswitch(&(myproc()->context), &(mycpu()->context));
    80001240:	6308                	ld	a0,0(a4)
    80001242:	95be                	add	a1,a1,a5
    80001244:	16850513          	addi	a0,a0,360
    80001248:	00000097          	auipc	ra,0x0
    8000124c:	744080e7          	jalr	1860(ra) # 8000198c <pswitch>
}
    80001250:	60a2                	ld	ra,8(sp)
    80001252:	6402                	ld	s0,0(sp)
    80001254:	0141                	addi	sp,sp,16
    80001256:	8082                	ret

0000000080001258 <hello>:

void hello()
{
    80001258:	1141                	addi	sp,sp,-16
    8000125a:	e406                	sd	ra,8(sp)
    8000125c:	e022                	sd	s0,0(sp)
    8000125e:	0800                	addi	s0,sp,16
    puts("Hello, world!\n\t\tfrom startOS with osh");
    80001260:	00002517          	auipc	a0,0x2
    80001264:	ed850513          	addi	a0,a0,-296 # 80003138 <digits+0x100>
    80001268:	fffff097          	auipc	ra,0xfffff
    8000126c:	2a0080e7          	jalr	672(ra) # 80000508 <puts>
    exit(0);
    80001270:	4501                	li	a0,0
    80001272:	00000097          	auipc	ra,0x0
    80001276:	f60080e7          	jalr	-160(ra) # 800011d2 <exit>
}
    8000127a:	60a2                	ld	ra,8(sp)
    8000127c:	6402                	ld	s0,0(sp)
    8000127e:	0141                	addi	sp,sp,16
    80001280:	8082                	ret

0000000080001282 <cowsay>:
void cowsay(){
    80001282:	1141                	addi	sp,sp,-16
    80001284:	e406                	sd	ra,8(sp)
    80001286:	e022                	sd	s0,0(sp)
    80001288:	0800                	addi	s0,sp,16
    puts("    ____________");
    8000128a:	00002517          	auipc	a0,0x2
    8000128e:	ed650513          	addi	a0,a0,-298 # 80003160 <digits+0x128>
    80001292:	fffff097          	auipc	ra,0xfffff
    80001296:	276080e7          	jalr	630(ra) # 80000508 <puts>
    puts("    < hi, there >");
    8000129a:	00002517          	auipc	a0,0x2
    8000129e:	ede50513          	addi	a0,a0,-290 # 80003178 <digits+0x140>
    800012a2:	fffff097          	auipc	ra,0xfffff
    800012a6:	266080e7          	jalr	614(ra) # 80000508 <puts>
    puts("    ------------");
    800012aa:	00002517          	auipc	a0,0x2
    800012ae:	ee650513          	addi	a0,a0,-282 # 80003190 <digits+0x158>
    800012b2:	fffff097          	auipc	ra,0xfffff
    800012b6:	256080e7          	jalr	598(ra) # 80000508 <puts>
    puts("         \\   ^__^");
    800012ba:	00002517          	auipc	a0,0x2
    800012be:	eee50513          	addi	a0,a0,-274 # 800031a8 <digits+0x170>
    800012c2:	fffff097          	auipc	ra,0xfffff
    800012c6:	246080e7          	jalr	582(ra) # 80000508 <puts>
    puts("          \\  (oo)\\_______");
    800012ca:	00002517          	auipc	a0,0x2
    800012ce:	ef650513          	addi	a0,a0,-266 # 800031c0 <digits+0x188>
    800012d2:	fffff097          	auipc	ra,0xfffff
    800012d6:	236080e7          	jalr	566(ra) # 80000508 <puts>
    puts("             (__)\\       )\\/\\");
    800012da:	00002517          	auipc	a0,0x2
    800012de:	f0650513          	addi	a0,a0,-250 # 800031e0 <digits+0x1a8>
    800012e2:	fffff097          	auipc	ra,0xfffff
    800012e6:	226080e7          	jalr	550(ra) # 80000508 <puts>
    puts("                 ||----w |");
    800012ea:	00002517          	auipc	a0,0x2
    800012ee:	f1650513          	addi	a0,a0,-234 # 80003200 <digits+0x1c8>
    800012f2:	fffff097          	auipc	ra,0xfffff
    800012f6:	216080e7          	jalr	534(ra) # 80000508 <puts>
    puts("                 ||     ||");
    800012fa:	00002517          	auipc	a0,0x2
    800012fe:	f2650513          	addi	a0,a0,-218 # 80003220 <digits+0x1e8>
    80001302:	fffff097          	auipc	ra,0xfffff
    80001306:	206080e7          	jalr	518(ra) # 80000508 <puts>
    exit(0);
    8000130a:	4501                	li	a0,0
    8000130c:	00000097          	auipc	ra,0x0
    80001310:	ec6080e7          	jalr	-314(ra) # 800011d2 <exit>
}
    80001314:	60a2                	ld	ra,8(sp)
    80001316:	6402                	ld	s0,0(sp)
    80001318:	0141                	addi	sp,sp,16
    8000131a:	8082                	ret

000000008000131c <mew>:
void mew(){
    8000131c:	1141                	addi	sp,sp,-16
    8000131e:	e406                	sd	ra,8(sp)
    80001320:	e022                	sd	s0,0(sp)
    80001322:	0800                	addi	s0,sp,16
    puts("          ＿＿");
    80001324:	00002517          	auipc	a0,0x2
    80001328:	f1c50513          	addi	a0,a0,-228 # 80003240 <digits+0x208>
    8000132c:	fffff097          	auipc	ra,0xfffff
    80001330:	1dc080e7          	jalr	476(ra) # 80000508 <puts>
    puts("　　　／＞　　フ");
    80001334:	00002517          	auipc	a0,0x2
    80001338:	f2450513          	addi	a0,a0,-220 # 80003258 <digits+0x220>
    8000133c:	fffff097          	auipc	ra,0xfffff
    80001340:	1cc080e7          	jalr	460(ra) # 80000508 <puts>
    puts("　　　|   _　 _ |");
    80001344:	00002517          	auipc	a0,0x2
    80001348:	f3450513          	addi	a0,a0,-204 # 80003278 <digits+0x240>
    8000134c:	fffff097          	auipc	ra,0xfffff
    80001350:	1bc080e7          	jalr	444(ra) # 80000508 <puts>
    puts("　　／`  ミ＿xノ");
    80001354:	00002517          	auipc	a0,0x2
    80001358:	f3c50513          	addi	a0,a0,-196 # 80003290 <digits+0x258>
    8000135c:	fffff097          	auipc	ra,0xfffff
    80001360:	1ac080e7          	jalr	428(ra) # 80000508 <puts>
    puts(" 　 /　　　 　 |");
    80001364:	00002517          	auipc	a0,0x2
    80001368:	f4450513          	addi	a0,a0,-188 # 800032a8 <digits+0x270>
    8000136c:	fffff097          	auipc	ra,0xfffff
    80001370:	19c080e7          	jalr	412(ra) # 80000508 <puts>
    puts("　 /　 ヽ　　 ﾉ");
    80001374:	00002517          	auipc	a0,0x2
    80001378:	f4c50513          	addi	a0,a0,-180 # 800032c0 <digits+0x288>
    8000137c:	fffff097          	auipc	ra,0xfffff
    80001380:	18c080e7          	jalr	396(ra) # 80000508 <puts>
    exit(0);
    80001384:	4501                	li	a0,0
    80001386:	00000097          	auipc	ra,0x0
    8000138a:	e4c080e7          	jalr	-436(ra) # 800011d2 <exit>
    8000138e:	60a2                	ld	ra,8(sp)
    80001390:	6402                	ld	s0,0(sp)
    80001392:	0141                	addi	sp,sp,16
    80001394:	8082                	ret

0000000080001396 <help>:
//#include "user/usertests.c"

void showHistory();

void help()
{
    80001396:	1141                	addi	sp,sp,-16
    80001398:	e406                	sd	ra,8(sp)
    8000139a:	e022                	sd	s0,0(sp)
    8000139c:	0800                	addi	s0,sp,16
    puts("All available commmands:");
    8000139e:	00002517          	auipc	a0,0x2
    800013a2:	f3a50513          	addi	a0,a0,-198 # 800032d8 <digits+0x2a0>
    800013a6:	fffff097          	auipc	ra,0xfffff
    800013aa:	162080e7          	jalr	354(ra) # 80000508 <puts>
    puts("help\tshow this helping message");
    800013ae:	00002517          	auipc	a0,0x2
    800013b2:	f4a50513          	addi	a0,a0,-182 # 800032f8 <digits+0x2c0>
    800013b6:	fffff097          	auipc	ra,0xfffff
    800013ba:	152080e7          	jalr	338(ra) # 80000508 <puts>
    puts("hello\tprint test hello world message");
    800013be:	00002517          	auipc	a0,0x2
    800013c2:	f5a50513          	addi	a0,a0,-166 # 80003318 <digits+0x2e0>
    800013c6:	fffff097          	auipc	ra,0xfffff
    800013ca:	142080e7          	jalr	322(ra) # 80000508 <puts>
    puts("history\tshow recent commands you input");
    800013ce:	00002517          	auipc	a0,0x2
    800013d2:	f7250513          	addi	a0,a0,-142 # 80003340 <digits+0x308>
    800013d6:	fffff097          	auipc	ra,0xfffff
    800013da:	132080e7          	jalr	306(ra) # 80000508 <puts>
    puts("usertests\texec test function");
    800013de:	00002517          	auipc	a0,0x2
    800013e2:	f8a50513          	addi	a0,a0,-118 # 80003368 <digits+0x330>
    800013e6:	fffff097          	auipc	ra,0xfffff
    800013ea:	122080e7          	jalr	290(ra) # 80000508 <puts>
    puts("cowsay\tcowsay");
    800013ee:	00002517          	auipc	a0,0x2
    800013f2:	f9a50513          	addi	a0,a0,-102 # 80003388 <digits+0x350>
    800013f6:	fffff097          	auipc	ra,0xfffff
    800013fa:	112080e7          	jalr	274(ra) # 80000508 <puts>
    puts("mew\tmew mew");
    800013fe:	00002517          	auipc	a0,0x2
    80001402:	f9a50513          	addi	a0,a0,-102 # 80003398 <digits+0x360>
    80001406:	fffff097          	auipc	ra,0xfffff
    8000140a:	102080e7          	jalr	258(ra) # 80000508 <puts>
    exit(0);
    8000140e:	4501                	li	a0,0
    80001410:	00000097          	auipc	ra,0x0
    80001414:	dc2080e7          	jalr	-574(ra) # 800011d2 <exit>
}
    80001418:	60a2                	ld	ra,8(sp)
    8000141a:	6402                	ld	s0,0(sp)
    8000141c:	0141                	addi	sp,sp,16
    8000141e:	8082                	ret

0000000080001420 <showHistory>:
    }
    exit(0);
}

void showHistory()
{
    80001420:	715d                	addi	sp,sp,-80
    80001422:	e486                	sd	ra,72(sp)
    80001424:	e0a2                	sd	s0,64(sp)
    80001426:	fc26                	sd	s1,56(sp)
    80001428:	f84a                	sd	s2,48(sp)
    8000142a:	f44e                	sd	s3,40(sp)
    8000142c:	f052                	sd	s4,32(sp)
    8000142e:	ec56                	sd	s5,24(sp)
    80001430:	e85a                	sd	s6,16(sp)
    80001432:	e45e                	sd	s7,8(sp)
    80001434:	0880                	addi	s0,sp,80
    int startP=h.currentP;
    for (int k = MAX_HISTORY_NUM, i = (MAX_HISTORY_NUM + startP) % MAX_HISTORY_NUM; k > 0; i++, k--) {
    80001436:	00004497          	auipc	s1,0x4
    8000143a:	faa4a483          	lw	s1,-86(s1) # 800053e0 <h+0x140>
    8000143e:	2495                	addiw	s1,s1,5
    80001440:	4795                	li	a5,5
    80001442:	02f4e4bb          	remw	s1,s1,a5
    80001446:	4915                	li	s2,5
        if (i >= MAX_HISTORY_NUM)
            i = i % MAX_HISTORY_NUM;
        if (h.cmdlist[i][0] == '\0') 
    80001448:	00004997          	auipc	s3,0x4
    8000144c:	dd898993          	addi	s3,s3,-552 # 80005220 <cpus>
            continue;
        else {
            printf("#%d\t%s\n", k, h.cmdlist[i]);
    80001450:	00004b97          	auipc	s7,0x4
    80001454:	e50b8b93          	addi	s7,s7,-432 # 800052a0 <h>
    80001458:	00002b17          	auipc	s6,0x2
    8000145c:	f50b0b13          	addi	s6,s6,-176 # 800033a8 <digits+0x370>
        if (i >= MAX_HISTORY_NUM)
    80001460:	4a11                	li	s4,4
            i = i % MAX_HISTORY_NUM;
    80001462:	4a95                	li	s5,5
    80001464:	a821                	j	8000147c <showHistory+0x5c>
    for (int k = MAX_HISTORY_NUM, i = (MAX_HISTORY_NUM + startP) % MAX_HISTORY_NUM; k > 0; i++, k--) {
    80001466:	0014879b          	addiw	a5,s1,1
    8000146a:	0007849b          	sext.w	s1,a5
    8000146e:	397d                	addiw	s2,s2,-1
    80001470:	02090763          	beqz	s2,8000149e <showHistory+0x7e>
        if (i >= MAX_HISTORY_NUM)
    80001474:	009a5463          	bge	s4,s1,8000147c <showHistory+0x5c>
            i = i % MAX_HISTORY_NUM;
    80001478:	0357e4bb          	remw	s1,a5,s5
    8000147c:	0009059b          	sext.w	a1,s2
        if (h.cmdlist[i][0] == '\0') 
    80001480:	00649793          	slli	a5,s1,0x6
    80001484:	97ce                	add	a5,a5,s3
    80001486:	0807c783          	lbu	a5,128(a5)
    8000148a:	dff1                	beqz	a5,80001466 <showHistory+0x46>
            printf("#%d\t%s\n", k, h.cmdlist[i]);
    8000148c:	00649613          	slli	a2,s1,0x6
    80001490:	965e                	add	a2,a2,s7
    80001492:	855a                	mv	a0,s6
    80001494:	fffff097          	auipc	ra,0xfffff
    80001498:	03e080e7          	jalr	62(ra) # 800004d2 <printf>
    8000149c:	b7e9                	j	80001466 <showHistory+0x46>
        }
    }
    exit(0);
    8000149e:	4501                	li	a0,0
    800014a0:	00000097          	auipc	ra,0x0
    800014a4:	d32080e7          	jalr	-718(ra) # 800011d2 <exit>
}
    800014a8:	60a6                	ld	ra,72(sp)
    800014aa:	6406                	ld	s0,64(sp)
    800014ac:	74e2                	ld	s1,56(sp)
    800014ae:	7942                	ld	s2,48(sp)
    800014b0:	79a2                	ld	s3,40(sp)
    800014b2:	7a02                	ld	s4,32(sp)
    800014b4:	6ae2                	ld	s5,24(sp)
    800014b6:	6b42                	ld	s6,16(sp)
    800014b8:	6ba2                	ld	s7,8(sp)
    800014ba:	6161                	addi	sp,sp,80
    800014bc:	8082                	ret

00000000800014be <exec>:

// 使进程执行其他函数
void exec(uint64 fn) {
    800014be:	7179                	addi	sp,sp,-48
    800014c0:	f406                	sd	ra,40(sp)
    800014c2:	f022                	sd	s0,32(sp)
    800014c4:	ec26                	sd	s1,24(sp)
    800014c6:	e84a                	sd	s2,16(sp)
    800014c8:	e44e                	sd	s3,8(sp)
    800014ca:	e052                	sd	s4,0(sp)
    800014cc:	1800                	addi	s0,sp,48
    800014ce:	892a                	mv	s2,a0
    800014d0:	8792                	mv	a5,tp
    return mycpu()->proc;
    800014d2:	00004997          	auipc	s3,0x4
    800014d6:	d4e98993          	addi	s3,s3,-690 # 80005220 <cpus>
    800014da:	2781                	sext.w	a5,a5
    800014dc:	079e                	slli	a5,a5,0x7
    800014de:	97ce                	add	a5,a5,s3
    800014e0:	6384                	ld	s1,0(a5)
    struct proc *p = myproc();
    memset(&p->context, 0, sizeof(struct context));
    800014e2:	16848a13          	addi	s4,s1,360
    800014e6:	07000613          	li	a2,112
    800014ea:	4581                	li	a1,0
    800014ec:	8552                	mv	a0,s4
    800014ee:	00000097          	auipc	ra,0x0
    800014f2:	378080e7          	jalr	888(ra) # 80001866 <memset>
    p->state = RUNNABLE;
    800014f6:	4789                	li	a5,2
    800014f8:	c09c                	sw	a5,0(s1)
    p->context.sp = p->kstack + PGSIZE;
    800014fa:	1604b783          	ld	a5,352(s1)
    800014fe:	6705                	lui	a4,0x1
    80001500:	97ba                	add	a5,a5,a4
    80001502:	16f4b823          	sd	a5,368(s1)
    spin_lock(&p->proc_lock);
    80001506:	14848513          	addi	a0,s1,328
    8000150a:	00002097          	auipc	ra,0x2
    8000150e:	878080e7          	jalr	-1928(ra) # 80002d82 <spin_lock>
    p->trapframe.a0 = fn;
    80001512:	0924bc23          	sd	s2,152(s1)
    80001516:	8592                	mv	a1,tp
    execra(&p->context, &mycpu()->context, (uint64)execret);
    80001518:	2581                	sext.w	a1,a1
    8000151a:	059e                	slli	a1,a1,0x7
    8000151c:	05a1                	addi	a1,a1,8
    8000151e:	fffff617          	auipc	a2,0xfffff
    80001522:	5da60613          	addi	a2,a2,1498 # 80000af8 <execret>
    80001526:	95ce                	add	a1,a1,s3
    80001528:	8552                	mv	a0,s4
    8000152a:	00000097          	auipc	ra,0x0
    8000152e:	626080e7          	jalr	1574(ra) # 80001b50 <execra>
    // 不会返回
    panic("exec");
    80001532:	00002517          	auipc	a0,0x2
    80001536:	e7e50513          	addi	a0,a0,-386 # 800033b0 <digits+0x378>
    8000153a:	fffff097          	auipc	ra,0xfffff
    8000153e:	1ca080e7          	jalr	458(ra) # 80000704 <panic>
}
    80001542:	70a2                	ld	ra,40(sp)
    80001544:	7402                	ld	s0,32(sp)
    80001546:	64e2                	ld	s1,24(sp)
    80001548:	6942                	ld	s2,16(sp)
    8000154a:	69a2                	ld	s3,8(sp)
    8000154c:	6a02                	ld	s4,0(sp)
    8000154e:	6145                	addi	sp,sp,48
    80001550:	8082                	ret

0000000080001552 <run>:

void run(uint64 fn)
{
    80001552:	1101                	addi	sp,sp,-32
    80001554:	ec06                	sd	ra,24(sp)
    80001556:	e822                	sd	s0,16(sp)
    80001558:	e426                	sd	s1,8(sp)
    8000155a:	1000                	addi	s0,sp,32
    8000155c:	84aa                	mv	s1,a0
    if (fork() > 0) {
    8000155e:	00000097          	auipc	ra,0x0
    80001562:	498080e7          	jalr	1176(ra) # 800019f6 <fork>
    80001566:	00a05c63          	blez	a0,8000157e <run+0x2c>
        wait(0);
    8000156a:	4501                	li	a0,0
    8000156c:	00000097          	auipc	ra,0x0
    80001570:	b70080e7          	jalr	-1168(ra) # 800010dc <wait>
    } else {
        exec(fn);
    }
}
    80001574:	60e2                	ld	ra,24(sp)
    80001576:	6442                	ld	s0,16(sp)
    80001578:	64a2                	ld	s1,8(sp)
    8000157a:	6105                	addi	sp,sp,32
    8000157c:	8082                	ret
        exec(fn);
    8000157e:	8526                	mv	a0,s1
    80001580:	00000097          	auipc	ra,0x0
    80001584:	f3e080e7          	jalr	-194(ra) # 800014be <exec>
}
    80001588:	b7f5                	j	80001574 <run+0x22>

000000008000158a <runcmd>:
void runcmd(char* cmdstr)
{
    8000158a:	1101                	addi	sp,sp,-32
    8000158c:	ec06                	sd	ra,24(sp)
    8000158e:	e822                	sd	s0,16(sp)
    80001590:	e426                	sd	s1,8(sp)
    80001592:	1000                	addi	s0,sp,32
    80001594:	84aa                	mv	s1,a0
    if (strlen(cmdstr) == 0)
    80001596:	00000097          	auipc	ra,0x0
    8000159a:	352080e7          	jalr	850(ra) # 800018e8 <strlen>
    8000159e:	0005079b          	sext.w	a5,a0
    800015a2:	e791                	bnez	a5,800015ae <runcmd+0x24>
        run((uint64)mew);
    else {
        puts("■■No such command.");
        return;
    }
}
    800015a4:	60e2                	ld	ra,24(sp)
    800015a6:	6442                	ld	s0,16(sp)
    800015a8:	64a2                	ld	s1,8(sp)
    800015aa:	6105                	addi	sp,sp,32
    800015ac:	8082                	ret
    else if (strcmp(cmdstr, "hello") == 0)
    800015ae:	00002597          	auipc	a1,0x2
    800015b2:	e0a58593          	addi	a1,a1,-502 # 800033b8 <digits+0x380>
    800015b6:	8526                	mv	a0,s1
    800015b8:	fffff097          	auipc	ra,0xfffff
    800015bc:	5ae080e7          	jalr	1454(ra) # 80000b66 <strcmp>
    800015c0:	e911                	bnez	a0,800015d4 <runcmd+0x4a>
        run((uint64)hello);
    800015c2:	00000517          	auipc	a0,0x0
    800015c6:	c9650513          	addi	a0,a0,-874 # 80001258 <hello>
    800015ca:	00000097          	auipc	ra,0x0
    800015ce:	f88080e7          	jalr	-120(ra) # 80001552 <run>
    800015d2:	bfc9                	j	800015a4 <runcmd+0x1a>
    else if (strcmp(cmdstr, "help") == 0)
    800015d4:	00002597          	auipc	a1,0x2
    800015d8:	dec58593          	addi	a1,a1,-532 # 800033c0 <digits+0x388>
    800015dc:	8526                	mv	a0,s1
    800015de:	fffff097          	auipc	ra,0xfffff
    800015e2:	588080e7          	jalr	1416(ra) # 80000b66 <strcmp>
    800015e6:	e911                	bnez	a0,800015fa <runcmd+0x70>
        run((uint64)help);
    800015e8:	00000517          	auipc	a0,0x0
    800015ec:	dae50513          	addi	a0,a0,-594 # 80001396 <help>
    800015f0:	00000097          	auipc	ra,0x0
    800015f4:	f62080e7          	jalr	-158(ra) # 80001552 <run>
    800015f8:	b775                	j	800015a4 <runcmd+0x1a>
    else if (strcmp(cmdstr, "history") == 0)
    800015fa:	00002597          	auipc	a1,0x2
    800015fe:	dce58593          	addi	a1,a1,-562 # 800033c8 <digits+0x390>
    80001602:	8526                	mv	a0,s1
    80001604:	fffff097          	auipc	ra,0xfffff
    80001608:	562080e7          	jalr	1378(ra) # 80000b66 <strcmp>
    8000160c:	e911                	bnez	a0,80001620 <runcmd+0x96>
        run((uint64)showHistory);
    8000160e:	00000517          	auipc	a0,0x0
    80001612:	e1250513          	addi	a0,a0,-494 # 80001420 <showHistory>
    80001616:	00000097          	auipc	ra,0x0
    8000161a:	f3c080e7          	jalr	-196(ra) # 80001552 <run>
    8000161e:	b759                	j	800015a4 <runcmd+0x1a>
    else if(strcmp(cmdstr, "cowsay") == 0)
    80001620:	00002597          	auipc	a1,0x2
    80001624:	db058593          	addi	a1,a1,-592 # 800033d0 <digits+0x398>
    80001628:	8526                	mv	a0,s1
    8000162a:	fffff097          	auipc	ra,0xfffff
    8000162e:	53c080e7          	jalr	1340(ra) # 80000b66 <strcmp>
    80001632:	e911                	bnez	a0,80001646 <runcmd+0xbc>
        run((uint64)cowsay);
    80001634:	00000517          	auipc	a0,0x0
    80001638:	c4e50513          	addi	a0,a0,-946 # 80001282 <cowsay>
    8000163c:	00000097          	auipc	ra,0x0
    80001640:	f16080e7          	jalr	-234(ra) # 80001552 <run>
    80001644:	b785                	j	800015a4 <runcmd+0x1a>
    else if(strcmp(cmdstr, "mew") == 0)
    80001646:	00002597          	auipc	a1,0x2
    8000164a:	d5a58593          	addi	a1,a1,-678 # 800033a0 <digits+0x368>
    8000164e:	8526                	mv	a0,s1
    80001650:	fffff097          	auipc	ra,0xfffff
    80001654:	516080e7          	jalr	1302(ra) # 80000b66 <strcmp>
    80001658:	e911                	bnez	a0,8000166c <runcmd+0xe2>
        run((uint64)mew);
    8000165a:	00000517          	auipc	a0,0x0
    8000165e:	cc250513          	addi	a0,a0,-830 # 8000131c <mew>
    80001662:	00000097          	auipc	ra,0x0
    80001666:	ef0080e7          	jalr	-272(ra) # 80001552 <run>
    8000166a:	bf2d                	j	800015a4 <runcmd+0x1a>
        puts("■■No such command.");
    8000166c:	00002517          	auipc	a0,0x2
    80001670:	d6c50513          	addi	a0,a0,-660 # 800033d8 <digits+0x3a0>
    80001674:	fffff097          	auipc	ra,0xfffff
    80001678:	e94080e7          	jalr	-364(ra) # 80000508 <puts>
        return;
    8000167c:	b725                	j	800015a4 <runcmd+0x1a>

000000008000167e <osh>:
{
    8000167e:	7119                	addi	sp,sp,-128
    80001680:	fc86                	sd	ra,120(sp)
    80001682:	f8a2                	sd	s0,112(sp)
    80001684:	f4a6                	sd	s1,104(sp)
    80001686:	f0ca                	sd	s2,96(sp)
    80001688:	ecce                	sd	s3,88(sp)
    8000168a:	e8d2                	sd	s4,80(sp)
    8000168c:	e4d6                	sd	s5,72(sp)
    8000168e:	e0da                	sd	s6,64(sp)
    80001690:	0100                	addi	s0,sp,128
    printf("\n==========================Start OS=========================\n");
    80001692:	00002517          	auipc	a0,0x2
    80001696:	d5e50513          	addi	a0,a0,-674 # 800033f0 <digits+0x3b8>
    8000169a:	fffff097          	auipc	ra,0xfffff
    8000169e:	e38080e7          	jalr	-456(ra) # 800004d2 <printf>
    puts("Welcome to startOS! Use following commands to get started.");
    800016a2:	00002517          	auipc	a0,0x2
    800016a6:	d8e50513          	addi	a0,a0,-626 # 80003430 <digits+0x3f8>
    800016aa:	fffff097          	auipc	ra,0xfffff
    800016ae:	e5e080e7          	jalr	-418(ra) # 80000508 <puts>
    puts("  * hello - print test hello world message");
    800016b2:	00002517          	auipc	a0,0x2
    800016b6:	dbe50513          	addi	a0,a0,-578 # 80003470 <digits+0x438>
    800016ba:	fffff097          	auipc	ra,0xfffff
    800016be:	e4e080e7          	jalr	-434(ra) # 80000508 <puts>
    puts("  * help - list all available commands");
    800016c2:	00002517          	auipc	a0,0x2
    800016c6:	dde50513          	addi	a0,a0,-546 # 800034a0 <digits+0x468>
    800016ca:	fffff097          	auipc	ra,0xfffff
    800016ce:	e3e080e7          	jalr	-450(ra) # 80000508 <puts>
    h.currentP = 0; //当前指令即将写入的位置
    800016d2:	00004797          	auipc	a5,0x4
    800016d6:	d007a723          	sw	zero,-754(a5) # 800053e0 <h+0x140>
        printf("osh>> ");
    800016da:	00002497          	auipc	s1,0x2
    800016de:	dee48493          	addi	s1,s1,-530 # 800034c8 <digits+0x490>
            if (strcmp(buf, "!!") == 0)
    800016e2:	00002997          	auipc	s3,0x2
    800016e6:	dee98993          	addi	s3,s3,-530 # 800034d0 <digits+0x498>
                if (h.currentP >= MAX_HISTORY_NUM)
    800016ea:	00004917          	auipc	s2,0x4
    800016ee:	b3690913          	addi	s2,s2,-1226 # 80005220 <cpus>
    800016f2:	4a91                	li	s5,4
                strcpy(h.cmdlist[h.currentP++], buf);
    800016f4:	00004a17          	auipc	s4,0x4
    800016f8:	baca0a13          	addi	s4,s4,-1108 # 800052a0 <h>
                    h.currentP = h.currentP % MAX_HISTORY_NUM;
    800016fc:	4b15                	li	s6,5
    800016fe:	a82d                	j	80001738 <osh+0xba>
                runcmd(buf);
    80001700:	f8040513          	addi	a0,s0,-128
    80001704:	00000097          	auipc	ra,0x0
    80001708:	e86080e7          	jalr	-378(ra) # 8000158a <runcmd>
                if (h.currentP >= MAX_HISTORY_NUM)
    8000170c:	1c092783          	lw	a5,448(s2)
    80001710:	00fad663          	bge	s5,a5,8000171c <osh+0x9e>
                    h.currentP = h.currentP % MAX_HISTORY_NUM;
    80001714:	0367e7bb          	remw	a5,a5,s6
    80001718:	1cf92023          	sw	a5,448(s2)
                strcpy(h.cmdlist[h.currentP++], buf);
    8000171c:	1c092503          	lw	a0,448(s2)
    80001720:	0015079b          	addiw	a5,a0,1
    80001724:	1cf92023          	sw	a5,448(s2)
    80001728:	051a                	slli	a0,a0,0x6
    8000172a:	f8040593          	addi	a1,s0,-128
    8000172e:	9552                	add	a0,a0,s4
    80001730:	fffff097          	auipc	ra,0xfffff
    80001734:	41a080e7          	jalr	1050(ra) # 80000b4a <strcpy>
        printf("osh>> ");
    80001738:	8526                	mv	a0,s1
    8000173a:	fffff097          	auipc	ra,0xfffff
    8000173e:	d98080e7          	jalr	-616(ra) # 800004d2 <printf>
        if (read_line(buf) != 0) {
    80001742:	f8040513          	addi	a0,s0,-128
    80001746:	fffff097          	auipc	ra,0xfffff
    8000174a:	dfe080e7          	jalr	-514(ra) # 80000544 <read_line>
    8000174e:	d56d                	beqz	a0,80001738 <osh+0xba>
            if (strcmp(buf, "!!") == 0)
    80001750:	85ce                	mv	a1,s3
    80001752:	f8040513          	addi	a0,s0,-128
    80001756:	fffff097          	auipc	ra,0xfffff
    8000175a:	410080e7          	jalr	1040(ra) # 80000b66 <strcmp>
    8000175e:	f14d                	bnez	a0,80001700 <osh+0x82>
                showHistory();
    80001760:	00000097          	auipc	ra,0x0
    80001764:	cc0080e7          	jalr	-832(ra) # 80001420 <showHistory>
    80001768:	bfc1                	j	80001738 <osh+0xba>

000000008000176a <init>:
void init() {
    8000176a:	1141                	addi	sp,sp,-16
    8000176c:	e406                	sd	ra,8(sp)
    8000176e:	e022                	sd	s0,0(sp)
    80001770:	0800                	addi	s0,sp,16
    80001772:	8792                	mv	a5,tp
    return mycpu()->proc;
    80001774:	2781                	sext.w	a5,a5
    80001776:	079e                	slli	a5,a5,0x7
    80001778:	00004717          	auipc	a4,0x4
    8000177c:	aa870713          	addi	a4,a4,-1368 # 80005220 <cpus>
    80001780:	97ba                	add	a5,a5,a4
    spin_unlock(&myproc()->proc_lock);
    80001782:	6388                	ld	a0,0(a5)
    80001784:	14850513          	addi	a0,a0,328
    80001788:	00001097          	auipc	ra,0x1
    8000178c:	6ce080e7          	jalr	1742(ra) # 80002e56 <spin_unlock>
    int pid = fork();
    80001790:	00000097          	auipc	ra,0x0
    80001794:	266080e7          	jalr	614(ra) # 800019f6 <fork>
    if (pid < 0) {
    80001798:	04054563          	bltz	a0,800017e2 <init+0x78>
    } else if (pid == 0) {
    8000179c:	cd21                	beqz	a0,800017f4 <init+0x8a>
    printf("init0\n");
    8000179e:	00002517          	auipc	a0,0x2
    800017a2:	d4250513          	addi	a0,a0,-702 # 800034e0 <digits+0x4a8>
    800017a6:	fffff097          	auipc	ra,0xfffff
    800017aa:	d2c080e7          	jalr	-724(ra) # 800004d2 <printf>
    init_fs();
    800017ae:	00001097          	auipc	ra,0x1
    800017b2:	ad6080e7          	jalr	-1322(ra) # 80002284 <init_fs>
    printf("init1\n");
    800017b6:	00002517          	auipc	a0,0x2
    800017ba:	d3250513          	addi	a0,a0,-718 # 800034e8 <digits+0x4b0>
    800017be:	fffff097          	auipc	ra,0xfffff
    800017c2:	d14080e7          	jalr	-748(ra) # 800004d2 <printf>
    fstest();
    800017c6:	00001097          	auipc	ra,0x1
    800017ca:	97c080e7          	jalr	-1668(ra) # 80002142 <fstest>
    dirtest();
    800017ce:	00001097          	auipc	ra,0x1
    800017d2:	9ee080e7          	jalr	-1554(ra) # 800021bc <dirtest>
        wait(0);
    800017d6:	4501                	li	a0,0
    800017d8:	00000097          	auipc	ra,0x0
    800017dc:	904080e7          	jalr	-1788(ra) # 800010dc <wait>
    for (;;) {
    800017e0:	bfdd                	j	800017d6 <init+0x6c>
        panic("init");
    800017e2:	00002517          	auipc	a0,0x2
    800017e6:	cf650513          	addi	a0,a0,-778 # 800034d8 <digits+0x4a0>
    800017ea:	fffff097          	auipc	ra,0xfffff
    800017ee:	f1a080e7          	jalr	-230(ra) # 80000704 <panic>
    800017f2:	b775                	j	8000179e <init+0x34>
        exec((uint64) osh);
    800017f4:	00000517          	auipc	a0,0x0
    800017f8:	e8a50513          	addi	a0,a0,-374 # 8000167e <osh>
    800017fc:	00000097          	auipc	ra,0x0
    80001800:	cc2080e7          	jalr	-830(ra) # 800014be <exec>
    80001804:	bf69                	j	8000179e <init+0x34>

0000000080001806 <print_proc>:

void print_proc() {
    80001806:	7179                	addi	sp,sp,-48
    80001808:	f406                	sd	ra,40(sp)
    8000180a:	f022                	sd	s0,32(sp)
    8000180c:	ec26                	sd	s1,24(sp)
    8000180e:	e84a                	sd	s2,16(sp)
    80001810:	e44e                	sd	s3,8(sp)
    80001812:	1800                	addi	s0,sp,48
    struct proc *p;
    printf(" \npid\tstate\n");
    80001814:	00002517          	auipc	a0,0x2
    80001818:	cdc50513          	addi	a0,a0,-804 # 800034f0 <digits+0x4b8>
    8000181c:	fffff097          	auipc	ra,0xfffff
    80001820:	cb6080e7          	jalr	-842(ra) # 800004d2 <printf>
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80001824:	00045497          	auipc	s1,0x45
    80001828:	bc448493          	addi	s1,s1,-1084 # 800463e8 <proc_table>
        if (p->state == UNUSED)
            continue;
        printf(" %d\t  %d\n", p->pid, p->state);
    8000182c:	00002997          	auipc	s3,0x2
    80001830:	cd498993          	addi	s3,s3,-812 # 80003500 <digits+0x4c8>
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80001834:	0004c917          	auipc	s2,0x4c
    80001838:	5b490913          	addi	s2,s2,1460 # 8004dde8 <proc_table+0x7a00>
    8000183c:	a029                	j	80001846 <print_proc+0x40>
    8000183e:	1e848493          	addi	s1,s1,488
    80001842:	01248b63          	beq	s1,s2,80001858 <print_proc+0x52>
        if (p->state == UNUSED)
    80001846:	4090                	lw	a2,0(s1)
    80001848:	da7d                	beqz	a2,8000183e <print_proc+0x38>
        printf(" %d\t  %d\n", p->pid, p->state);
    8000184a:	508c                	lw	a1,32(s1)
    8000184c:	854e                	mv	a0,s3
    8000184e:	fffff097          	auipc	ra,0xfffff
    80001852:	c84080e7          	jalr	-892(ra) # 800004d2 <printf>
    80001856:	b7e5                	j	8000183e <print_proc+0x38>
    }
}
    80001858:	70a2                	ld	ra,40(sp)
    8000185a:	7402                	ld	s0,32(sp)
    8000185c:	64e2                	ld	s1,24(sp)
    8000185e:	6942                	ld	s2,16(sp)
    80001860:	69a2                	ld	s3,8(sp)
    80001862:	6145                	addi	sp,sp,48
    80001864:	8082                	ret

0000000080001866 <memset>:
#include "types.h"

void *memset(void *dst, int c, uint n) {
    80001866:	1141                	addi	sp,sp,-16
    80001868:	e422                	sd	s0,8(sp)
    8000186a:	0800                	addi	s0,sp,16
    char *cdst = (char *) dst;
    int i;
    for (i = 0; i < n; i++) {
    8000186c:	ce09                	beqz	a2,80001886 <memset+0x20>
    8000186e:	87aa                	mv	a5,a0
    80001870:	fff6071b          	addiw	a4,a2,-1
    80001874:	1702                	slli	a4,a4,0x20
    80001876:	9301                	srli	a4,a4,0x20
    80001878:	0705                	addi	a4,a4,1
    8000187a:	972a                	add	a4,a4,a0
        cdst[i] = c;
    8000187c:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++) {
    80001880:	0785                	addi	a5,a5,1
    80001882:	fee79de3          	bne	a5,a4,8000187c <memset+0x16>
    }
    return dst;
}
    80001886:	6422                	ld	s0,8(sp)
    80001888:	0141                	addi	sp,sp,16
    8000188a:	8082                	ret

000000008000188c <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
    8000188c:	1141                	addi	sp,sp,-16
    8000188e:	e422                	sd	s0,8(sp)
    80001890:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst) {
    80001892:	02b57663          	bgeu	a0,a1,800018be <memmove+0x32>
        while (n-- > 0)
    80001896:	02c05163          	blez	a2,800018b8 <memmove+0x2c>
    8000189a:	fff6079b          	addiw	a5,a2,-1
    8000189e:	1782                	slli	a5,a5,0x20
    800018a0:	9381                	srli	a5,a5,0x20
    800018a2:	0785                	addi	a5,a5,1
    800018a4:	97aa                	add	a5,a5,a0
    dst = vdst;
    800018a6:	872a                	mv	a4,a0
            *dst++ = *src++;
    800018a8:	0585                	addi	a1,a1,1
    800018aa:	0705                	addi	a4,a4,1
    800018ac:	fff5c683          	lbu	a3,-1(a1)
    800018b0:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
    800018b4:	fee79ae3          	bne	a5,a4,800018a8 <memmove+0x1c>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
    800018b8:	6422                	ld	s0,8(sp)
    800018ba:	0141                	addi	sp,sp,16
    800018bc:	8082                	ret
        dst += n;
    800018be:	00c50733          	add	a4,a0,a2
        src += n;
    800018c2:	95b2                	add	a1,a1,a2
        while (n-- > 0)
    800018c4:	fec05ae3          	blez	a2,800018b8 <memmove+0x2c>
    800018c8:	fff6079b          	addiw	a5,a2,-1
    800018cc:	1782                	slli	a5,a5,0x20
    800018ce:	9381                	srli	a5,a5,0x20
    800018d0:	fff7c793          	not	a5,a5
    800018d4:	97ba                	add	a5,a5,a4
            *--dst = *--src;
    800018d6:	15fd                	addi	a1,a1,-1
    800018d8:	177d                	addi	a4,a4,-1
    800018da:	0005c683          	lbu	a3,0(a1)
    800018de:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
    800018e2:	fee79ae3          	bne	a5,a4,800018d6 <memmove+0x4a>
    800018e6:	bfc9                	j	800018b8 <memmove+0x2c>

00000000800018e8 <strlen>:

uint strlen(const char *s) {
    800018e8:	1141                	addi	sp,sp,-16
    800018ea:	e422                	sd	s0,8(sp)
    800018ec:	0800                	addi	s0,sp,16
    int n;
    for (n = 0; s[n]; n++);
    800018ee:	00054783          	lbu	a5,0(a0)
    800018f2:	cf91                	beqz	a5,8000190e <strlen+0x26>
    800018f4:	0505                	addi	a0,a0,1
    800018f6:	87aa                	mv	a5,a0
    800018f8:	4685                	li	a3,1
    800018fa:	9e89                	subw	a3,a3,a0
    800018fc:	00f6853b          	addw	a0,a3,a5
    80001900:	0785                	addi	a5,a5,1
    80001902:	fff7c703          	lbu	a4,-1(a5)
    80001906:	fb7d                	bnez	a4,800018fc <strlen+0x14>
    return n;
}
    80001908:	6422                	ld	s0,8(sp)
    8000190a:	0141                	addi	sp,sp,16
    8000190c:	8082                	ret
    for (n = 0; s[n]; n++);
    8000190e:	4501                	li	a0,0
    80001910:	bfe5                	j	80001908 <strlen+0x20>

0000000080001912 <strncpy>:

char * strncpy(char *s, const char *t, int n) {
    80001912:	1141                	addi	sp,sp,-16
    80001914:	e422                	sd	s0,8(sp)
    80001916:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while (n-- > 0 && (*s++ = *t++) != 0);
    80001918:	872a                	mv	a4,a0
    8000191a:	8832                	mv	a6,a2
    8000191c:	367d                	addiw	a2,a2,-1
    8000191e:	01005963          	blez	a6,80001930 <strncpy+0x1e>
    80001922:	0705                	addi	a4,a4,1
    80001924:	0005c783          	lbu	a5,0(a1)
    80001928:	fef70fa3          	sb	a5,-1(a4)
    8000192c:	0585                	addi	a1,a1,1
    8000192e:	f7f5                	bnez	a5,8000191a <strncpy+0x8>
    while (n-- > 0)
    80001930:	00c05d63          	blez	a2,8000194a <strncpy+0x38>
    80001934:	86ba                	mv	a3,a4
        *s++ = 0;
    80001936:	0685                	addi	a3,a3,1
    80001938:	fe068fa3          	sb	zero,-1(a3)
    while (n-- > 0)
    8000193c:	fff6c793          	not	a5,a3
    80001940:	9fb9                	addw	a5,a5,a4
    80001942:	010787bb          	addw	a5,a5,a6
    80001946:	fef048e3          	bgtz	a5,80001936 <strncpy+0x24>
    return os;
}
    8000194a:	6422                	ld	s0,8(sp)
    8000194c:	0141                	addi	sp,sp,16
    8000194e:	8082                	ret

0000000080001950 <strncmp>:
int strncmp(const char *p, const char *q, uint n)
{
    80001950:	1141                	addi	sp,sp,-16
    80001952:	e422                	sd	s0,8(sp)
    80001954:	0800                	addi	s0,sp,16
    while(n > 0 && *p && *p == *q)
    80001956:	ce11                	beqz	a2,80001972 <strncmp+0x22>
    80001958:	00054783          	lbu	a5,0(a0)
    8000195c:	cf89                	beqz	a5,80001976 <strncmp+0x26>
    8000195e:	0005c703          	lbu	a4,0(a1)
    80001962:	00f71a63          	bne	a4,a5,80001976 <strncmp+0x26>
        n--, p++, q++;
    80001966:	367d                	addiw	a2,a2,-1
    80001968:	0505                	addi	a0,a0,1
    8000196a:	0585                	addi	a1,a1,1
    while(n > 0 && *p && *p == *q)
    8000196c:	f675                	bnez	a2,80001958 <strncmp+0x8>
    if(n == 0)
        return 0;
    8000196e:	4501                	li	a0,0
    80001970:	a809                	j	80001982 <strncmp+0x32>
    80001972:	4501                	li	a0,0
    80001974:	a039                	j	80001982 <strncmp+0x32>
    if(n == 0)
    80001976:	ca09                	beqz	a2,80001988 <strncmp+0x38>
    return (uchar)*p - (uchar)*q;
    80001978:	00054503          	lbu	a0,0(a0)
    8000197c:	0005c783          	lbu	a5,0(a1)
    80001980:	9d1d                	subw	a0,a0,a5
}
    80001982:	6422                	ld	s0,8(sp)
    80001984:	0141                	addi	sp,sp,16
    80001986:	8082                	ret
        return 0;
    80001988:	4501                	li	a0,0
    8000198a:	bfe5                	j	80001982 <strncmp+0x32>

000000008000198c <pswitch>:
    8000198c:	00153023          	sd	ra,0(a0)
    80001990:	00253423          	sd	sp,8(a0)
    80001994:	e900                	sd	s0,16(a0)
    80001996:	ed04                	sd	s1,24(a0)
    80001998:	03253023          	sd	s2,32(a0)
    8000199c:	03353423          	sd	s3,40(a0)
    800019a0:	03453823          	sd	s4,48(a0)
    800019a4:	03553c23          	sd	s5,56(a0)
    800019a8:	05653023          	sd	s6,64(a0)
    800019ac:	05753423          	sd	s7,72(a0)
    800019b0:	05853823          	sd	s8,80(a0)
    800019b4:	05953c23          	sd	s9,88(a0)
    800019b8:	07a53023          	sd	s10,96(a0)
    800019bc:	07b53423          	sd	s11,104(a0)
    800019c0:	0005b083          	ld	ra,0(a1)
    800019c4:	0085b103          	ld	sp,8(a1)
    800019c8:	6980                	ld	s0,16(a1)
    800019ca:	6d84                	ld	s1,24(a1)
    800019cc:	0205b903          	ld	s2,32(a1)
    800019d0:	0285b983          	ld	s3,40(a1)
    800019d4:	0305ba03          	ld	s4,48(a1)
    800019d8:	0385ba83          	ld	s5,56(a1)
    800019dc:	0405bb03          	ld	s6,64(a1)
    800019e0:	0485bb83          	ld	s7,72(a1)
    800019e4:	0505bc03          	ld	s8,80(a1)
    800019e8:	0585bc83          	ld	s9,88(a1)
    800019ec:	0605bd03          	ld	s10,96(a1)
    800019f0:	0685bd83          	ld	s11,104(a1)
    800019f4:	8082                	ret

00000000800019f6 <fork>:
// fork的简单实现
// fork失败返回-1
// 父进程返回子进程id
// 子进程返回0
//
int fork() {
    800019f6:	1101                	addi	sp,sp,-32
    800019f8:	ec06                	sd	ra,24(sp)
    800019fa:	e822                	sd	s0,16(sp)
    800019fc:	e426                	sd	s1,8(sp)
    800019fe:	e04a                	sd	s2,0(sp)
    80001a00:	1000                	addi	s0,sp,32
    struct proc *p;
    struct proc *np;
    if ((np = alloc_proc()) == 0) {
    80001a02:	fffff097          	auipc	ra,0xfffff
    80001a06:	2ec080e7          	jalr	748(ra) # 80000cee <alloc_proc>
    80001a0a:	c951                	beqz	a0,80001a9e <fork+0xa8>
    80001a0c:	84aa                	mv	s1,a0
        return -1;
    }
    p = myproc();
    80001a0e:	fffff097          	auipc	ra,0xfffff
    80001a12:	3a6080e7          	jalr	934(ra) # 80000db4 <myproc>
    80001a16:	892a                	mv	s2,a0
    memmove((char *) np->kstack, (char *) p->kstack, PGSIZE);
    80001a18:	6605                	lui	a2,0x1
    80001a1a:	16053583          	ld	a1,352(a0)
    80001a1e:	1604b503          	ld	a0,352(s1)
    80001a22:	00000097          	auipc	ra,0x0
    80001a26:	e6a080e7          	jalr	-406(ra) # 8000188c <memmove>
    np->parent = p;
    80001a2a:	0124b423          	sd	s2,8(s1)
    np->state = RUNNABLE;
    80001a2e:	4789                	li	a5,2
    80001a30:	c09c                	sw	a5,0(s1)
    forkra(&np->context, p->kstack, np->kstack);
    80001a32:	1604b603          	ld	a2,352(s1)
    80001a36:	16093583          	ld	a1,352(s2)
    80001a3a:	16848513          	addi	a0,s1,360
    80001a3e:	00000097          	auipc	ra,0x0
    80001a42:	0d2080e7          	jalr	210(ra) # 80001b10 <forkra>
    if (myproc() == np) {
    80001a46:	fffff097          	auipc	ra,0xfffff
    80001a4a:	36e080e7          	jalr	878(ra) # 80000db4 <myproc>
    80001a4e:	02a48163          	beq	s1,a0,80001a70 <fork+0x7a>
        printf("child\n");
        spin_unlock(&np->proc_lock);
        printf("child2\n");
    }
    return myproc() == np ? 0 : np->pid;
    80001a52:	fffff097          	auipc	ra,0xfffff
    80001a56:	362080e7          	jalr	866(ra) # 80000db4 <myproc>
    80001a5a:	87aa                	mv	a5,a0
    80001a5c:	4501                	li	a0,0
    80001a5e:	00f48363          	beq	s1,a5,80001a64 <fork+0x6e>
    80001a62:	5088                	lw	a0,32(s1)
}
    80001a64:	60e2                	ld	ra,24(sp)
    80001a66:	6442                	ld	s0,16(sp)
    80001a68:	64a2                	ld	s1,8(sp)
    80001a6a:	6902                	ld	s2,0(sp)
    80001a6c:	6105                	addi	sp,sp,32
    80001a6e:	8082                	ret
        printf("child\n");
    80001a70:	00002517          	auipc	a0,0x2
    80001a74:	aa050513          	addi	a0,a0,-1376 # 80003510 <digits+0x4d8>
    80001a78:	fffff097          	auipc	ra,0xfffff
    80001a7c:	a5a080e7          	jalr	-1446(ra) # 800004d2 <printf>
        spin_unlock(&np->proc_lock);
    80001a80:	14848513          	addi	a0,s1,328
    80001a84:	00001097          	auipc	ra,0x1
    80001a88:	3d2080e7          	jalr	978(ra) # 80002e56 <spin_unlock>
        printf("child2\n");
    80001a8c:	00002517          	auipc	a0,0x2
    80001a90:	a8c50513          	addi	a0,a0,-1396 # 80003518 <digits+0x4e0>
    80001a94:	fffff097          	auipc	ra,0xfffff
    80001a98:	a3e080e7          	jalr	-1474(ra) # 800004d2 <printf>
    80001a9c:	bf5d                	j	80001a52 <fork+0x5c>
        return -1;
    80001a9e:	557d                	li	a0,-1
    80001aa0:	b7d1                	j	80001a64 <fork+0x6e>

0000000080001aa2 <sleep_sec>:

//
// 睡眠指定秒数
//
void sleep_sec(int seconds) {
    80001aa2:	1141                	addi	sp,sp,-16
    80001aa4:	e406                	sd	ra,8(sp)
    80001aa6:	e022                	sd	s0,0(sp)
    80001aa8:	0800                	addi	s0,sp,16
    sleep_time(seconds * 10);
    80001aaa:	0025179b          	slliw	a5,a0,0x2
    80001aae:	9d3d                	addw	a0,a0,a5
    80001ab0:	0015151b          	slliw	a0,a0,0x1
    80001ab4:	fffff097          	auipc	ra,0xfffff
    80001ab8:	49a080e7          	jalr	1178(ra) # 80000f4e <sleep_time>
}
    80001abc:	60a2                	ld	ra,8(sp)
    80001abe:	6402                	ld	s0,0(sp)
    80001ac0:	0141                	addi	sp,sp,16
    80001ac2:	8082                	ret

0000000080001ac4 <yeild>:

//
// 让出cpu
//
void yeild() {
    80001ac4:	1101                	addi	sp,sp,-32
    80001ac6:	ec06                	sd	ra,24(sp)
    80001ac8:	e822                	sd	s0,16(sp)
    80001aca:	e426                	sd	s1,8(sp)
    80001acc:	e04a                	sd	s2,0(sp)
    80001ace:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    80001ad0:	fffff097          	auipc	ra,0xfffff
    80001ad4:	2e4080e7          	jalr	740(ra) # 80000db4 <myproc>
    80001ad8:	84aa                	mv	s1,a0
    spin_lock(&p->proc_lock);
    80001ada:	14850913          	addi	s2,a0,328
    80001ade:	854a                	mv	a0,s2
    80001ae0:	00001097          	auipc	ra,0x1
    80001ae4:	2a2080e7          	jalr	674(ra) # 80002d82 <spin_lock>
    p->state = RUNNABLE;
    80001ae8:	4789                	li	a5,2
    80001aea:	c09c                	sw	a5,0(s1)
//    pswitch(&(myproc()->context), &(mycpu()->context));
    before_sched();
    80001aec:	fffff097          	auipc	ra,0xfffff
    80001af0:	2e6080e7          	jalr	742(ra) # 80000dd2 <before_sched>
    spin_unlock(&p->proc_lock);
    80001af4:	854a                	mv	a0,s2
    80001af6:	00001097          	auipc	ra,0x1
    80001afa:	360080e7          	jalr	864(ra) # 80002e56 <spin_unlock>
}
    80001afe:	60e2                	ld	ra,24(sp)
    80001b00:	6442                	ld	s0,16(sp)
    80001b02:	64a2                	ld	s1,8(sp)
    80001b04:	6902                	ld	s2,0(sp)
    80001b06:	6105                	addi	sp,sp,32
    80001b08:	8082                	ret
    80001b0a:	0000                	unimp
    80001b0c:	0000                	unimp
	...

0000000080001b10 <forkra>:
    80001b10:	40b102b3          	sub	t0,sp,a1
    80001b14:	92b2                	add	t0,t0,a2
    80001b16:	00153023          	sd	ra,0(a0)
    80001b1a:	00553423          	sd	t0,8(a0)
    80001b1e:	e900                	sd	s0,16(a0)
    80001b20:	ed04                	sd	s1,24(a0)
    80001b22:	03253023          	sd	s2,32(a0)
    80001b26:	03353423          	sd	s3,40(a0)
    80001b2a:	03453823          	sd	s4,48(a0)
    80001b2e:	03553c23          	sd	s5,56(a0)
    80001b32:	05653023          	sd	s6,64(a0)
    80001b36:	05753423          	sd	s7,72(a0)
    80001b3a:	05853823          	sd	s8,80(a0)
    80001b3e:	05953c23          	sd	s9,88(a0)
    80001b42:	07a53023          	sd	s10,96(a0)
    80001b46:	07b53423          	sd	s11,104(a0)
    80001b4a:	8082                	ret
    80001b4c:	00000013          	nop

0000000080001b50 <execra>:
    80001b50:	e110                	sd	a2,0(a0)
    80001b52:	0005b083          	ld	ra,0(a1)
    80001b56:	0085b103          	ld	sp,8(a1)
    80001b5a:	6980                	ld	s0,16(a1)
    80001b5c:	6d84                	ld	s1,24(a1)
    80001b5e:	0205b903          	ld	s2,32(a1)
    80001b62:	0285b983          	ld	s3,40(a1)
    80001b66:	0305ba03          	ld	s4,48(a1)
    80001b6a:	0385ba83          	ld	s5,56(a1)
    80001b6e:	0405bb03          	ld	s6,64(a1)
    80001b72:	0485bb83          	ld	s7,72(a1)
    80001b76:	0505bc03          	ld	s8,80(a1)
    80001b7a:	0585bc83          	ld	s9,88(a1)
    80001b7e:	0605bd03          	ld	s10,96(a1)
    80001b82:	0685bd83          	ld	s11,104(a1)
    80001b86:	8082                	ret
    80001b88:	00000013          	nop
    80001b8c:	00000013          	nop

0000000080001b90 <userret>:
    80001b90:	00050093          	mv	ra,a0
    80001b94:	00058113          	mv	sp,a1
    80001b98:	8082                	ret
	...

0000000080001ba2 <free_desc>:
    return -1;
}

// mark a descriptor as free.
static void
free_desc(int i) {
    80001ba2:	1101                	addi	sp,sp,-32
    80001ba4:	ec06                	sd	ra,24(sp)
    80001ba6:	e822                	sd	s0,16(sp)
    80001ba8:	e426                	sd	s1,8(sp)
    80001baa:	1000                	addi	s0,sp,32
    80001bac:	84aa                	mv	s1,a0
    if (i >= NUM)
    80001bae:	479d                	li	a5,7
    80001bb0:	06a7ca63          	blt	a5,a0,80001c24 <free_desc+0x82>
        panic("free_desc 1");
    if (disk.free[i])
    80001bb4:	0004c797          	auipc	a5,0x4c
    80001bb8:	44c78793          	addi	a5,a5,1100 # 8004e000 <disk>
    80001bbc:	00978733          	add	a4,a5,s1
    80001bc0:	6789                	lui	a5,0x2
    80001bc2:	97ba                	add	a5,a5,a4
    80001bc4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80001bc8:	e7bd                	bnez	a5,80001c36 <free_desc+0x94>
        panic("free_desc 2");
    disk.desc[i].addr = 0;
    80001bca:	00449793          	slli	a5,s1,0x4
    80001bce:	0004e717          	auipc	a4,0x4e
    80001bd2:	43270713          	addi	a4,a4,1074 # 80050000 <disk+0x2000>
    80001bd6:	6314                	ld	a3,0(a4)
    80001bd8:	96be                	add	a3,a3,a5
    80001bda:	0006b023          	sd	zero,0(a3)
    disk.desc[i].len = 0;
    80001bde:	6314                	ld	a3,0(a4)
    80001be0:	96be                	add	a3,a3,a5
    80001be2:	0006a423          	sw	zero,8(a3)
    disk.desc[i].flags = 0;
    80001be6:	6314                	ld	a3,0(a4)
    80001be8:	96be                	add	a3,a3,a5
    80001bea:	00069623          	sh	zero,12(a3)
    disk.desc[i].next = 0;
    80001bee:	6318                	ld	a4,0(a4)
    80001bf0:	97ba                	add	a5,a5,a4
    80001bf2:	00079723          	sh	zero,14(a5)
    disk.free[i] = 1;
    80001bf6:	0004c517          	auipc	a0,0x4c
    80001bfa:	40a50513          	addi	a0,a0,1034 # 8004e000 <disk>
    80001bfe:	9526                	add	a0,a0,s1
    80001c00:	6489                	lui	s1,0x2
    80001c02:	94aa                	add	s1,s1,a0
    80001c04:	4785                	li	a5,1
    80001c06:	00f48c23          	sb	a5,24(s1) # 2018 <_entry-0x7fffdfe8>
    wakeup(&disk.free[0]);
    80001c0a:	0004e517          	auipc	a0,0x4e
    80001c0e:	40e50513          	addi	a0,a0,1038 # 80050018 <disk+0x2018>
    80001c12:	fffff097          	auipc	ra,0xfffff
    80001c16:	3b2080e7          	jalr	946(ra) # 80000fc4 <wakeup>
}
    80001c1a:	60e2                	ld	ra,24(sp)
    80001c1c:	6442                	ld	s0,16(sp)
    80001c1e:	64a2                	ld	s1,8(sp)
    80001c20:	6105                	addi	sp,sp,32
    80001c22:	8082                	ret
        panic("free_desc 1");
    80001c24:	00002517          	auipc	a0,0x2
    80001c28:	8fc50513          	addi	a0,a0,-1796 # 80003520 <digits+0x4e8>
    80001c2c:	fffff097          	auipc	ra,0xfffff
    80001c30:	ad8080e7          	jalr	-1320(ra) # 80000704 <panic>
    80001c34:	b741                	j	80001bb4 <free_desc+0x12>
        panic("free_desc 2");
    80001c36:	00002517          	auipc	a0,0x2
    80001c3a:	8fa50513          	addi	a0,a0,-1798 # 80003530 <digits+0x4f8>
    80001c3e:	fffff097          	auipc	ra,0xfffff
    80001c42:	ac6080e7          	jalr	-1338(ra) # 80000704 <panic>
    80001c46:	b751                	j	80001bca <free_desc+0x28>

0000000080001c48 <virtio_disk_init>:
virtio_disk_init(void) {
    80001c48:	1101                	addi	sp,sp,-32
    80001c4a:	ec06                	sd	ra,24(sp)
    80001c4c:	e822                	sd	s0,16(sp)
    80001c4e:	e426                	sd	s1,8(sp)
    80001c50:	1000                	addi	s0,sp,32
    spinlock_init(&disk.vdisk_lock, "virtio_disk");
    80001c52:	00002597          	auipc	a1,0x2
    80001c56:	8ee58593          	addi	a1,a1,-1810 # 80003540 <digits+0x508>
    80001c5a:	0004e517          	auipc	a0,0x4e
    80001c5e:	4ce50513          	addi	a0,a0,1230 # 80050128 <disk+0x2128>
    80001c62:	00001097          	auipc	ra,0x1
    80001c66:	090080e7          	jalr	144(ra) # 80002cf2 <spinlock_init>
    if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80001c6a:	100017b7          	lui	a5,0x10001
    80001c6e:	4398                	lw	a4,0(a5)
    80001c70:	2701                	sext.w	a4,a4
    80001c72:	747277b7          	lui	a5,0x74727
    80001c76:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80001c7a:	00f71963          	bne	a4,a5,80001c8c <virtio_disk_init+0x44>
        *R(VIRTIO_MMIO_VERSION) != 1 ||
    80001c7e:	100017b7          	lui	a5,0x10001
    80001c82:	43dc                	lw	a5,4(a5)
    80001c84:	2781                	sext.w	a5,a5
    if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80001c86:	4705                	li	a4,1
    80001c88:	0ce78163          	beq	a5,a4,80001d4a <virtio_disk_init+0x102>
        panic("could not find virtio disk");
    80001c8c:	00002517          	auipc	a0,0x2
    80001c90:	8c450513          	addi	a0,a0,-1852 # 80003550 <digits+0x518>
    80001c94:	fffff097          	auipc	ra,0xfffff
    80001c98:	a70080e7          	jalr	-1424(ra) # 80000704 <panic>
    *R(VIRTIO_MMIO_STATUS) = status;
    80001c9c:	100017b7          	lui	a5,0x10001
    80001ca0:	4705                	li	a4,1
    80001ca2:	dbb8                	sw	a4,112(a5)
    *R(VIRTIO_MMIO_STATUS) = status;
    80001ca4:	470d                	li	a4,3
    80001ca6:	dbb8                	sw	a4,112(a5)
    uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80001ca8:	4b94                	lw	a3,16(a5)
    features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80001caa:	c7ffe737          	lui	a4,0xc7ffe
    80001cae:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <buf_cache+0xffffffff47fabc87>
    80001cb2:	8f75                	and	a4,a4,a3
    *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80001cb4:	2701                	sext.w	a4,a4
    80001cb6:	d398                	sw	a4,32(a5)
    *R(VIRTIO_MMIO_STATUS) = status;
    80001cb8:	472d                	li	a4,11
    80001cba:	dbb8                	sw	a4,112(a5)
    *R(VIRTIO_MMIO_STATUS) = status;
    80001cbc:	473d                	li	a4,15
    80001cbe:	dbb8                	sw	a4,112(a5)
    *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80001cc0:	6705                	lui	a4,0x1
    80001cc2:	d798                	sw	a4,40(a5)
    *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80001cc4:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
    uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80001cc8:	5bdc                	lw	a5,52(a5)
    80001cca:	2781                	sext.w	a5,a5
    if (max == 0)
    80001ccc:	c3cd                	beqz	a5,80001d6e <virtio_disk_init+0x126>
    if (max < NUM)
    80001cce:	471d                	li	a4,7
    80001cd0:	0af77763          	bgeu	a4,a5,80001d7e <virtio_disk_init+0x136>
    *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80001cd4:	100014b7          	lui	s1,0x10001
    80001cd8:	47a1                	li	a5,8
    80001cda:	dc9c                	sw	a5,56(s1)
    memset(disk.pages, 0, sizeof(disk.pages));
    80001cdc:	6609                	lui	a2,0x2
    80001cde:	4581                	li	a1,0
    80001ce0:	0004c517          	auipc	a0,0x4c
    80001ce4:	32050513          	addi	a0,a0,800 # 8004e000 <disk>
    80001ce8:	00000097          	auipc	ra,0x0
    80001cec:	b7e080e7          	jalr	-1154(ra) # 80001866 <memset>
    *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64) disk.pages) >> PGSHIFT;
    80001cf0:	0004c717          	auipc	a4,0x4c
    80001cf4:	31070713          	addi	a4,a4,784 # 8004e000 <disk>
    80001cf8:	00c75793          	srli	a5,a4,0xc
    80001cfc:	2781                	sext.w	a5,a5
    80001cfe:	c0bc                	sw	a5,64(s1)
    disk.desc = (struct virtq_desc *) disk.pages;
    80001d00:	0004e797          	auipc	a5,0x4e
    80001d04:	30078793          	addi	a5,a5,768 # 80050000 <disk+0x2000>
    80001d08:	e398                	sd	a4,0(a5)
    disk.avail = (struct virtq_avail *) (disk.pages + NUM * sizeof(struct virtq_desc));
    80001d0a:	0004c717          	auipc	a4,0x4c
    80001d0e:	37670713          	addi	a4,a4,886 # 8004e080 <disk+0x80>
    80001d12:	e798                	sd	a4,8(a5)
    disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80001d14:	0004d717          	auipc	a4,0x4d
    80001d18:	2ec70713          	addi	a4,a4,748 # 8004f000 <disk+0x1000>
    80001d1c:	eb98                	sd	a4,16(a5)
        disk.free[i] = 1;
    80001d1e:	4705                	li	a4,1
    80001d20:	00e78c23          	sb	a4,24(a5)
    80001d24:	00e78ca3          	sb	a4,25(a5)
    80001d28:	00e78d23          	sb	a4,26(a5)
    80001d2c:	00e78da3          	sb	a4,27(a5)
    80001d30:	00e78e23          	sb	a4,28(a5)
    80001d34:	00e78ea3          	sb	a4,29(a5)
    80001d38:	00e78f23          	sb	a4,30(a5)
    80001d3c:	00e78fa3          	sb	a4,31(a5)
}
    80001d40:	60e2                	ld	ra,24(sp)
    80001d42:	6442                	ld	s0,16(sp)
    80001d44:	64a2                	ld	s1,8(sp)
    80001d46:	6105                	addi	sp,sp,32
    80001d48:	8082                	ret
        *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80001d4a:	100017b7          	lui	a5,0x10001
    80001d4e:	479c                	lw	a5,8(a5)
    80001d50:	2781                	sext.w	a5,a5
        *R(VIRTIO_MMIO_VERSION) != 1 ||
    80001d52:	4709                	li	a4,2
    80001d54:	f2e79ce3          	bne	a5,a4,80001c8c <virtio_disk_init+0x44>
        *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    80001d58:	100017b7          	lui	a5,0x10001
    80001d5c:	47d8                	lw	a4,12(a5)
    80001d5e:	2701                	sext.w	a4,a4
        *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80001d60:	554d47b7          	lui	a5,0x554d4
    80001d64:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80001d68:	f2f712e3          	bne	a4,a5,80001c8c <virtio_disk_init+0x44>
    80001d6c:	bf05                	j	80001c9c <virtio_disk_init+0x54>
        panic("virtio disk has no queue 0");
    80001d6e:	00002517          	auipc	a0,0x2
    80001d72:	80250513          	addi	a0,a0,-2046 # 80003570 <digits+0x538>
    80001d76:	fffff097          	auipc	ra,0xfffff
    80001d7a:	98e080e7          	jalr	-1650(ra) # 80000704 <panic>
        panic("virtio disk max queue too short");
    80001d7e:	00002517          	auipc	a0,0x2
    80001d82:	81250513          	addi	a0,a0,-2030 # 80003590 <digits+0x558>
    80001d86:	fffff097          	auipc	ra,0xfffff
    80001d8a:	97e080e7          	jalr	-1666(ra) # 80000704 <panic>
    80001d8e:	b799                	j	80001cd4 <virtio_disk_init+0x8c>

0000000080001d90 <virtio_disk_rw>:
    }
    return 0;
}

void
virtio_disk_rw(struct buf *b, int write) {
    80001d90:	7159                	addi	sp,sp,-112
    80001d92:	f486                	sd	ra,104(sp)
    80001d94:	f0a2                	sd	s0,96(sp)
    80001d96:	eca6                	sd	s1,88(sp)
    80001d98:	e8ca                	sd	s2,80(sp)
    80001d9a:	e4ce                	sd	s3,72(sp)
    80001d9c:	e0d2                	sd	s4,64(sp)
    80001d9e:	fc56                	sd	s5,56(sp)
    80001da0:	f85a                	sd	s6,48(sp)
    80001da2:	f45e                	sd	s7,40(sp)
    80001da4:	f062                	sd	s8,32(sp)
    80001da6:	ec66                	sd	s9,24(sp)
    80001da8:	e86a                	sd	s10,16(sp)
    80001daa:	1880                	addi	s0,sp,112
    80001dac:	892a                	mv	s2,a0
    80001dae:	8d2e                	mv	s10,a1
    uint64 sector = b->blockno * (BSIZE / 512);
    80001db0:	00c52c83          	lw	s9,12(a0)
    80001db4:	001c9c9b          	slliw	s9,s9,0x1
    80001db8:	1c82                	slli	s9,s9,0x20
    80001dba:	020cdc93          	srli	s9,s9,0x20
    spin_lock(&disk.vdisk_lock);
    80001dbe:	0004e517          	auipc	a0,0x4e
    80001dc2:	36a50513          	addi	a0,a0,874 # 80050128 <disk+0x2128>
    80001dc6:	00001097          	auipc	ra,0x1
    80001dca:	fbc080e7          	jalr	-68(ra) # 80002d82 <spin_lock>
    for (int i = 0; i < 3; i++) {
    80001dce:	4981                	li	s3,0
    for (int i = 0; i < NUM; i++) {
    80001dd0:	4c21                	li	s8,8
            disk.free[i] = 0;
    80001dd2:	0004cb97          	auipc	s7,0x4c
    80001dd6:	22eb8b93          	addi	s7,s7,558 # 8004e000 <disk>
    80001dda:	6b09                	lui	s6,0x2
    for (int i = 0; i < 3; i++) {
    80001ddc:	4a8d                	li	s5,3
    for (int i = 0; i < NUM; i++) {
    80001dde:	8a4e                	mv	s4,s3
    80001de0:	a051                	j	80001e64 <virtio_disk_rw+0xd4>
            disk.free[i] = 0;
    80001de2:	00fb86b3          	add	a3,s7,a5
    80001de6:	96da                	add	a3,a3,s6
    80001de8:	00068c23          	sb	zero,24(a3)
        idx[i] = alloc_desc();
    80001dec:	c21c                	sw	a5,0(a2)
        if (idx[i] < 0) {
    80001dee:	0207c563          	bltz	a5,80001e18 <virtio_disk_rw+0x88>
    for (int i = 0; i < 3; i++) {
    80001df2:	2485                	addiw	s1,s1,1
    80001df4:	0711                	addi	a4,a4,4
    80001df6:	25548063          	beq	s1,s5,80002036 <virtio_disk_rw+0x2a6>
        idx[i] = alloc_desc();
    80001dfa:	863a                	mv	a2,a4
    for (int i = 0; i < NUM; i++) {
    80001dfc:	0004e697          	auipc	a3,0x4e
    80001e00:	21c68693          	addi	a3,a3,540 # 80050018 <disk+0x2018>
    80001e04:	87d2                	mv	a5,s4
        if (disk.free[i]) {
    80001e06:	0006c583          	lbu	a1,0(a3)
    80001e0a:	fde1                	bnez	a1,80001de2 <virtio_disk_rw+0x52>
    for (int i = 0; i < NUM; i++) {
    80001e0c:	2785                	addiw	a5,a5,1
    80001e0e:	0685                	addi	a3,a3,1
    80001e10:	ff879be3          	bne	a5,s8,80001e06 <virtio_disk_rw+0x76>
        idx[i] = alloc_desc();
    80001e14:	57fd                	li	a5,-1
    80001e16:	c21c                	sw	a5,0(a2)
            for (int j = 0; j < i; j++)
    80001e18:	02905a63          	blez	s1,80001e4c <virtio_disk_rw+0xbc>
                free_desc(idx[j]);
    80001e1c:	f9042503          	lw	a0,-112(s0)
    80001e20:	00000097          	auipc	ra,0x0
    80001e24:	d82080e7          	jalr	-638(ra) # 80001ba2 <free_desc>
            for (int j = 0; j < i; j++)
    80001e28:	4785                	li	a5,1
    80001e2a:	0297d163          	bge	a5,s1,80001e4c <virtio_disk_rw+0xbc>
                free_desc(idx[j]);
    80001e2e:	f9442503          	lw	a0,-108(s0)
    80001e32:	00000097          	auipc	ra,0x0
    80001e36:	d70080e7          	jalr	-656(ra) # 80001ba2 <free_desc>
            for (int j = 0; j < i; j++)
    80001e3a:	4789                	li	a5,2
    80001e3c:	0097d863          	bge	a5,s1,80001e4c <virtio_disk_rw+0xbc>
                free_desc(idx[j]);
    80001e40:	f9842503          	lw	a0,-104(s0)
    80001e44:	00000097          	auipc	ra,0x0
    80001e48:	d5e080e7          	jalr	-674(ra) # 80001ba2 <free_desc>
    int idx[3];
    while (1) {
        if (alloc3_desc(idx) == 0) {
            break;
        }
        sleep(&disk.free[0], &disk.vdisk_lock);
    80001e4c:	0004e597          	auipc	a1,0x4e
    80001e50:	2dc58593          	addi	a1,a1,732 # 80050128 <disk+0x2128>
    80001e54:	0004e517          	auipc	a0,0x4e
    80001e58:	1c450513          	addi	a0,a0,452 # 80050018 <disk+0x2018>
    80001e5c:	fffff097          	auipc	ra,0xfffff
    80001e60:	05c080e7          	jalr	92(ra) # 80000eb8 <sleep>
    for (int i = 0; i < 3; i++) {
    80001e64:	f9040713          	addi	a4,s0,-112
    80001e68:	84ce                	mv	s1,s3
    80001e6a:	bf41                	j	80001dfa <virtio_disk_rw+0x6a>
    // format the three descriptors.
    // qemu's virtio-blk.c reads them.
    struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

    if (write)
        buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80001e6c:	20058713          	addi	a4,a1,512
    80001e70:	00471693          	slli	a3,a4,0x4
    80001e74:	0004c717          	auipc	a4,0x4c
    80001e78:	18c70713          	addi	a4,a4,396 # 8004e000 <disk>
    80001e7c:	9736                	add	a4,a4,a3
    80001e7e:	4685                	li	a3,1
    80001e80:	0ad72423          	sw	a3,168(a4)
    else
        buf0->type = VIRTIO_BLK_T_IN; // read the disk
    buf0->reserved = 0;
    80001e84:	20058713          	addi	a4,a1,512
    80001e88:	00471693          	slli	a3,a4,0x4
    80001e8c:	0004c717          	auipc	a4,0x4c
    80001e90:	17470713          	addi	a4,a4,372 # 8004e000 <disk>
    80001e94:	9736                	add	a4,a4,a3
    80001e96:	0a072623          	sw	zero,172(a4)
    buf0->sector = sector;
    80001e9a:	0b973823          	sd	s9,176(a4)

    disk.desc[idx[0]].addr = (uint64) buf0;
    80001e9e:	7679                	lui	a2,0xffffe
    80001ea0:	963e                	add	a2,a2,a5
    80001ea2:	0004e697          	auipc	a3,0x4e
    80001ea6:	15e68693          	addi	a3,a3,350 # 80050000 <disk+0x2000>
    80001eaa:	6298                	ld	a4,0(a3)
    80001eac:	9732                	add	a4,a4,a2
    80001eae:	e308                	sd	a0,0(a4)
    disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80001eb0:	6298                	ld	a4,0(a3)
    80001eb2:	9732                	add	a4,a4,a2
    80001eb4:	4541                	li	a0,16
    80001eb6:	c708                	sw	a0,8(a4)
    disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80001eb8:	6298                	ld	a4,0(a3)
    80001eba:	9732                	add	a4,a4,a2
    80001ebc:	4505                	li	a0,1
    80001ebe:	00a71623          	sh	a0,12(a4)
    disk.desc[idx[0]].next = idx[1];
    80001ec2:	f9442703          	lw	a4,-108(s0)
    80001ec6:	6288                	ld	a0,0(a3)
    80001ec8:	962a                	add	a2,a2,a0
    80001eca:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <buf_cache+0xffffffff7ffab536>

    disk.desc[idx[1]].addr = (uint64) b->data;
    80001ece:	0712                	slli	a4,a4,0x4
    80001ed0:	6290                	ld	a2,0(a3)
    80001ed2:	963a                	add	a2,a2,a4
    80001ed4:	04c90513          	addi	a0,s2,76
    80001ed8:	e208                	sd	a0,0(a2)
    disk.desc[idx[1]].len = BSIZE;
    80001eda:	6294                	ld	a3,0(a3)
    80001edc:	96ba                	add	a3,a3,a4
    80001ede:	40000613          	li	a2,1024
    80001ee2:	c690                	sw	a2,8(a3)
    if (write)
    80001ee4:	140d0063          	beqz	s10,80002024 <virtio_disk_rw+0x294>
        disk.desc[idx[1]].flags = 0; // device reads b->data
    80001ee8:	0004e697          	auipc	a3,0x4e
    80001eec:	1186b683          	ld	a3,280(a3) # 80050000 <disk+0x2000>
    80001ef0:	96ba                	add	a3,a3,a4
    80001ef2:	00069623          	sh	zero,12(a3)
    else
        disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80001ef6:	0004c817          	auipc	a6,0x4c
    80001efa:	10a80813          	addi	a6,a6,266 # 8004e000 <disk>
    80001efe:	0004e517          	auipc	a0,0x4e
    80001f02:	10250513          	addi	a0,a0,258 # 80050000 <disk+0x2000>
    80001f06:	6114                	ld	a3,0(a0)
    80001f08:	96ba                	add	a3,a3,a4
    80001f0a:	00c6d603          	lhu	a2,12(a3)
    80001f0e:	00166613          	ori	a2,a2,1
    80001f12:	00c69623          	sh	a2,12(a3)
    disk.desc[idx[1]].next = idx[2];
    80001f16:	f9842683          	lw	a3,-104(s0)
    80001f1a:	6110                	ld	a2,0(a0)
    80001f1c:	9732                	add	a4,a4,a2
    80001f1e:	00d71723          	sh	a3,14(a4)

    disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80001f22:	20058613          	addi	a2,a1,512
    80001f26:	0612                	slli	a2,a2,0x4
    80001f28:	9642                	add	a2,a2,a6
    80001f2a:	577d                	li	a4,-1
    80001f2c:	02e60823          	sb	a4,48(a2)
    disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80001f30:	00469713          	slli	a4,a3,0x4
    80001f34:	6114                	ld	a3,0(a0)
    80001f36:	96ba                	add	a3,a3,a4
    80001f38:	03078793          	addi	a5,a5,48
    80001f3c:	97c2                	add	a5,a5,a6
    80001f3e:	e29c                	sd	a5,0(a3)
    disk.desc[idx[2]].len = 1;
    80001f40:	611c                	ld	a5,0(a0)
    80001f42:	97ba                	add	a5,a5,a4
    80001f44:	4685                	li	a3,1
    80001f46:	c794                	sw	a3,8(a5)
    disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80001f48:	611c                	ld	a5,0(a0)
    80001f4a:	97ba                	add	a5,a5,a4
    80001f4c:	4809                	li	a6,2
    80001f4e:	01079623          	sh	a6,12(a5)
    disk.desc[idx[2]].next = 0;
    80001f52:	611c                	ld	a5,0(a0)
    80001f54:	973e                	add	a4,a4,a5
    80001f56:	00071723          	sh	zero,14(a4)

    // record struct buf for virtio_disk_intr().
    b->disk = 1;
    80001f5a:	00d92223          	sw	a3,4(s2)
    disk.info[idx[0]].b = b;
    80001f5e:	03263423          	sd	s2,40(a2)

    // tell the device the first index in our chain of descriptors.
    disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80001f62:	6518                	ld	a4,8(a0)
    80001f64:	00275783          	lhu	a5,2(a4)
    80001f68:	8b9d                	andi	a5,a5,7
    80001f6a:	0786                	slli	a5,a5,0x1
    80001f6c:	97ba                	add	a5,a5,a4
    80001f6e:	00b79223          	sh	a1,4(a5)

    __sync_synchronize();
    80001f72:	0ff0000f          	fence

    // tell the device another avail ring entry is available.
    disk.avail->idx += 1; // not % NUM ...
    80001f76:	6518                	ld	a4,8(a0)
    80001f78:	00275783          	lhu	a5,2(a4)
    80001f7c:	2785                	addiw	a5,a5,1
    80001f7e:	00f71123          	sh	a5,2(a4)

    __sync_synchronize();
    80001f82:	0ff0000f          	fence

    *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80001f86:	100017b7          	lui	a5,0x10001
    80001f8a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

    // Wait for virtio_disk_intr() to say request has finished.
    while (b->disk == 1) {
    80001f8e:	00492703          	lw	a4,4(s2)
    80001f92:	4785                	li	a5,1
    80001f94:	02f71163          	bne	a4,a5,80001fb6 <virtio_disk_rw+0x226>
        sleep(b, &disk.vdisk_lock);
    80001f98:	0004e997          	auipc	s3,0x4e
    80001f9c:	19098993          	addi	s3,s3,400 # 80050128 <disk+0x2128>
    while (b->disk == 1) {
    80001fa0:	4485                	li	s1,1
        sleep(b, &disk.vdisk_lock);
    80001fa2:	85ce                	mv	a1,s3
    80001fa4:	854a                	mv	a0,s2
    80001fa6:	fffff097          	auipc	ra,0xfffff
    80001faa:	f12080e7          	jalr	-238(ra) # 80000eb8 <sleep>
    while (b->disk == 1) {
    80001fae:	00492783          	lw	a5,4(s2)
    80001fb2:	fe9788e3          	beq	a5,s1,80001fa2 <virtio_disk_rw+0x212>
    }

    disk.info[idx[0]].b = 0;
    80001fb6:	f9042903          	lw	s2,-112(s0)
    80001fba:	20090793          	addi	a5,s2,512
    80001fbe:	00479713          	slli	a4,a5,0x4
    80001fc2:	0004c797          	auipc	a5,0x4c
    80001fc6:	03e78793          	addi	a5,a5,62 # 8004e000 <disk>
    80001fca:	97ba                	add	a5,a5,a4
    80001fcc:	0207b423          	sd	zero,40(a5)
        int flag = disk.desc[i].flags;
    80001fd0:	0004e997          	auipc	s3,0x4e
    80001fd4:	03098993          	addi	s3,s3,48 # 80050000 <disk+0x2000>
    80001fd8:	00491713          	slli	a4,s2,0x4
    80001fdc:	0009b783          	ld	a5,0(s3)
    80001fe0:	97ba                	add	a5,a5,a4
    80001fe2:	00c7d483          	lhu	s1,12(a5)
        int nxt = disk.desc[i].next;
    80001fe6:	854a                	mv	a0,s2
    80001fe8:	00e7d903          	lhu	s2,14(a5)
        free_desc(i);
    80001fec:	00000097          	auipc	ra,0x0
    80001ff0:	bb6080e7          	jalr	-1098(ra) # 80001ba2 <free_desc>
        if (flag & VRING_DESC_F_NEXT)
    80001ff4:	8885                	andi	s1,s1,1
    80001ff6:	f0ed                	bnez	s1,80001fd8 <virtio_disk_rw+0x248>
    free_chain(idx[0]);
    spin_unlock(&disk.vdisk_lock);
    80001ff8:	0004e517          	auipc	a0,0x4e
    80001ffc:	13050513          	addi	a0,a0,304 # 80050128 <disk+0x2128>
    80002000:	00001097          	auipc	ra,0x1
    80002004:	e56080e7          	jalr	-426(ra) # 80002e56 <spin_unlock>
}
    80002008:	70a6                	ld	ra,104(sp)
    8000200a:	7406                	ld	s0,96(sp)
    8000200c:	64e6                	ld	s1,88(sp)
    8000200e:	6946                	ld	s2,80(sp)
    80002010:	69a6                	ld	s3,72(sp)
    80002012:	6a06                	ld	s4,64(sp)
    80002014:	7ae2                	ld	s5,56(sp)
    80002016:	7b42                	ld	s6,48(sp)
    80002018:	7ba2                	ld	s7,40(sp)
    8000201a:	7c02                	ld	s8,32(sp)
    8000201c:	6ce2                	ld	s9,24(sp)
    8000201e:	6d42                	ld	s10,16(sp)
    80002020:	6165                	addi	sp,sp,112
    80002022:	8082                	ret
        disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80002024:	0004e697          	auipc	a3,0x4e
    80002028:	fdc6b683          	ld	a3,-36(a3) # 80050000 <disk+0x2000>
    8000202c:	96ba                	add	a3,a3,a4
    8000202e:	4609                	li	a2,2
    80002030:	00c69623          	sh	a2,12(a3)
    80002034:	b5c9                	j	80001ef6 <virtio_disk_rw+0x166>
    struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80002036:	f9042583          	lw	a1,-112(s0)
    8000203a:	20058793          	addi	a5,a1,512
    8000203e:	0792                	slli	a5,a5,0x4
    80002040:	0004c517          	auipc	a0,0x4c
    80002044:	06850513          	addi	a0,a0,104 # 8004e0a8 <disk+0xa8>
    80002048:	953e                	add	a0,a0,a5
    if (write)
    8000204a:	e20d11e3          	bnez	s10,80001e6c <virtio_disk_rw+0xdc>
        buf0->type = VIRTIO_BLK_T_IN; // read the disk
    8000204e:	20058713          	addi	a4,a1,512
    80002052:	00471693          	slli	a3,a4,0x4
    80002056:	0004c717          	auipc	a4,0x4c
    8000205a:	faa70713          	addi	a4,a4,-86 # 8004e000 <disk>
    8000205e:	9736                	add	a4,a4,a3
    80002060:	0a072423          	sw	zero,168(a4)
    80002064:	b505                	j	80001e84 <virtio_disk_rw+0xf4>

0000000080002066 <virtio_disk_intr>:

void
virtio_disk_intr() {
    80002066:	7179                	addi	sp,sp,-48
    80002068:	f406                	sd	ra,40(sp)
    8000206a:	f022                	sd	s0,32(sp)
    8000206c:	ec26                	sd	s1,24(sp)
    8000206e:	e84a                	sd	s2,16(sp)
    80002070:	e44e                	sd	s3,8(sp)
    80002072:	e052                	sd	s4,0(sp)
    80002074:	1800                	addi	s0,sp,48
    spin_lock(&disk.vdisk_lock);
    80002076:	0004e517          	auipc	a0,0x4e
    8000207a:	0b250513          	addi	a0,a0,178 # 80050128 <disk+0x2128>
    8000207e:	00001097          	auipc	ra,0x1
    80002082:	d04080e7          	jalr	-764(ra) # 80002d82 <spin_lock>
    // we've seen this interrupt, which the following line does.
    // this may race with the device writing new entries to
    // the "used" ring, in which case we may process the new
    // completion entries in this interrupt, and have nothing to do
    // in the next interrupt, which is harmless.
    *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80002086:	10001737          	lui	a4,0x10001
    8000208a:	533c                	lw	a5,96(a4)
    8000208c:	8b8d                	andi	a5,a5,3
    8000208e:	d37c                	sw	a5,100(a4)

    __sync_synchronize();
    80002090:	0ff0000f          	fence

    // the device increments disk.used->idx when it
    // adds an entry to the used ring.
    while (disk.used_idx != disk.used->idx) {
    80002094:	0004e797          	auipc	a5,0x4e
    80002098:	f6c78793          	addi	a5,a5,-148 # 80050000 <disk+0x2000>
    8000209c:	6b94                	ld	a3,16(a5)
    8000209e:	0207d703          	lhu	a4,32(a5)
    800020a2:	0026d783          	lhu	a5,2(a3)
    800020a6:	06f70e63          	beq	a4,a5,80002122 <virtio_disk_intr+0xbc>
        __sync_synchronize();
        int id = disk.used->ring[disk.used_idx % NUM].id;
    800020aa:	0004c997          	auipc	s3,0x4c
    800020ae:	f5698993          	addi	s3,s3,-170 # 8004e000 <disk>
    800020b2:	0004e917          	auipc	s2,0x4e
    800020b6:	f4e90913          	addi	s2,s2,-178 # 80050000 <disk+0x2000>

        if (disk.info[id].status != 0)
            panic("virtio_disk_intr status");
    800020ba:	00001a17          	auipc	s4,0x1
    800020be:	4f6a0a13          	addi	s4,s4,1270 # 800035b0 <digits+0x578>
    800020c2:	a835                	j	800020fe <virtio_disk_intr+0x98>
    800020c4:	8552                	mv	a0,s4
    800020c6:	ffffe097          	auipc	ra,0xffffe
    800020ca:	63e080e7          	jalr	1598(ra) # 80000704 <panic>

        struct buf *b = disk.info[id].b;
    800020ce:	20048493          	addi	s1,s1,512 # 10001200 <_entry-0x6fffee00>
    800020d2:	0492                	slli	s1,s1,0x4
    800020d4:	94ce                	add	s1,s1,s3
    800020d6:	7488                	ld	a0,40(s1)
        b->disk = 0;   // disk is done with buf
    800020d8:	00052223          	sw	zero,4(a0)
        wakeup(b);
    800020dc:	fffff097          	auipc	ra,0xfffff
    800020e0:	ee8080e7          	jalr	-280(ra) # 80000fc4 <wakeup>

        disk.used_idx += 1;
    800020e4:	02095783          	lhu	a5,32(s2)
    800020e8:	2785                	addiw	a5,a5,1
    800020ea:	17c2                	slli	a5,a5,0x30
    800020ec:	93c1                	srli	a5,a5,0x30
    800020ee:	02f91023          	sh	a5,32(s2)
    while (disk.used_idx != disk.used->idx) {
    800020f2:	01093703          	ld	a4,16(s2)
    800020f6:	00275703          	lhu	a4,2(a4) # 10001002 <_entry-0x6fffeffe>
    800020fa:	02f70463          	beq	a4,a5,80002122 <virtio_disk_intr+0xbc>
        __sync_synchronize();
    800020fe:	0ff0000f          	fence
        int id = disk.used->ring[disk.used_idx % NUM].id;
    80002102:	01093703          	ld	a4,16(s2)
    80002106:	02095783          	lhu	a5,32(s2)
    8000210a:	8b9d                	andi	a5,a5,7
    8000210c:	078e                	slli	a5,a5,0x3
    8000210e:	97ba                	add	a5,a5,a4
    80002110:	43c4                	lw	s1,4(a5)
        if (disk.info[id].status != 0)
    80002112:	20048793          	addi	a5,s1,512
    80002116:	0792                	slli	a5,a5,0x4
    80002118:	97ce                	add	a5,a5,s3
    8000211a:	0307c783          	lbu	a5,48(a5)
    8000211e:	dbc5                	beqz	a5,800020ce <virtio_disk_intr+0x68>
    80002120:	b755                	j	800020c4 <virtio_disk_intr+0x5e>
    }
    spin_unlock(&disk.vdisk_lock);
    80002122:	0004e517          	auipc	a0,0x4e
    80002126:	00650513          	addi	a0,a0,6 # 80050128 <disk+0x2128>
    8000212a:	00001097          	auipc	ra,0x1
    8000212e:	d2c080e7          	jalr	-724(ra) # 80002e56 <spin_unlock>
}
    80002132:	70a2                	ld	ra,40(sp)
    80002134:	7402                	ld	s0,32(sp)
    80002136:	64e2                	ld	s1,24(sp)
    80002138:	6942                	ld	s2,16(sp)
    8000213a:	69a2                	ld	s3,8(sp)
    8000213c:	6a02                	ld	s4,0(sp)
    8000213e:	6145                	addi	sp,sp,48
    80002140:	8082                	ret

0000000080002142 <fstest>:
#include "file.h"
#include "virtio.h"
#include "../defs.h"
#include "fstest.h"

void fstest() {
    80002142:	715d                	addi	sp,sp,-80
    80002144:	e486                	sd	ra,72(sp)
    80002146:	e0a2                	sd	s0,64(sp)
    80002148:	fc26                	sd	s1,56(sp)
    8000214a:	f84a                	sd	s2,48(sp)
    8000214c:	0880                	addi	s0,sp,80
    struct inode *inode;
    struct superblock sb;
    read_superblock(&sb);
    8000214e:	fc840513          	addi	a0,s0,-56
    80002152:	00000097          	auipc	ra,0x0
    80002156:	0e6080e7          	jalr	230(ra) # 80002238 <read_superblock>
    inode = alloc_inode(T_FILE);
    8000215a:	4509                	li	a0,2
    8000215c:	00000097          	auipc	ra,0x0
    80002160:	510080e7          	jalr	1296(ra) # 8000266c <alloc_inode>
    80002164:	84aa                	mv	s1,a0
    char *str = "hello world!";
    write_inode(inode, (uint64) str, 0, strlen(str));
    80002166:	00001917          	auipc	s2,0x1
    8000216a:	46290913          	addi	s2,s2,1122 # 800035c8 <digits+0x590>
    8000216e:	854a                	mv	a0,s2
    80002170:	fffff097          	auipc	ra,0xfffff
    80002174:	778080e7          	jalr	1912(ra) # 800018e8 <strlen>
    80002178:	0005069b          	sext.w	a3,a0
    8000217c:	4601                	li	a2,0
    8000217e:	85ca                	mv	a1,s2
    80002180:	8526                	mv	a0,s1
    80002182:	00000097          	auipc	ra,0x0
    80002186:	70e080e7          	jalr	1806(ra) # 80002890 <write_inode>
    char s[20];
    read_inode(inode, (uint64) s, 0, 30);
    8000218a:	46f9                	li	a3,30
    8000218c:	4601                	li	a2,0
    8000218e:	fb040593          	addi	a1,s0,-80
    80002192:	8526                	mv	a0,s1
    80002194:	00000097          	auipc	ra,0x0
    80002198:	632080e7          	jalr	1586(ra) # 800027c6 <read_inode>
    printf("%s\n", s);
    8000219c:	fb040593          	addi	a1,s0,-80
    800021a0:	00001517          	auipc	a0,0x1
    800021a4:	e8050513          	addi	a0,a0,-384 # 80003020 <sleep_holding+0x9a>
    800021a8:	ffffe097          	auipc	ra,0xffffe
    800021ac:	32a080e7          	jalr	810(ra) # 800004d2 <printf>
}
    800021b0:	60a6                	ld	ra,72(sp)
    800021b2:	6406                	ld	s0,64(sp)
    800021b4:	74e2                	ld	s1,56(sp)
    800021b6:	7942                	ld	s2,48(sp)
    800021b8:	6161                	addi	sp,sp,80
    800021ba:	8082                	ret

00000000800021bc <dirtest>:

// 输出根目录下的direntry
void dirtest() {
    800021bc:	7139                	addi	sp,sp,-64
    800021be:	fc06                	sd	ra,56(sp)
    800021c0:	f822                	sd	s0,48(sp)
    800021c2:	f426                	sd	s1,40(sp)
    800021c4:	f04a                	sd	s2,32(sp)
    800021c6:	ec4e                	sd	s3,24(sp)
    800021c8:	e852                	sd	s4,16(sp)
    800021ca:	0080                	addi	s0,sp,64
    int off = 0;
    struct direntry de;
    struct inode *ip = get_inode(ROOTINO);
    800021cc:	4501                	li	a0,0
    800021ce:	00000097          	auipc	ra,0x0
    800021d2:	398080e7          	jalr	920(ra) # 80002566 <get_inode>
    800021d6:	892a                	mv	s2,a0
    int off = 0;
    800021d8:	4481                	li	s1,0
    while (read_inode(ip, (uint64)&de, off, sizeof(de)) == sizeof(de)) {
        off += sizeof(de);
        printf("name=%s,inum=%d\n", de.name, de.inum);
    800021da:	00001a17          	auipc	s4,0x1
    800021de:	3fea0a13          	addi	s4,s4,1022 # 800035d8 <digits+0x5a0>
        printf("addr=%d\n",ip->addrs[0]);
    800021e2:	00001997          	auipc	s3,0x1
    800021e6:	40e98993          	addi	s3,s3,1038 # 800035f0 <digits+0x5b8>
    while (read_inode(ip, (uint64)&de, off, sizeof(de)) == sizeof(de)) {
    800021ea:	2481                	sext.w	s1,s1
    800021ec:	46c1                	li	a3,16
    800021ee:	8626                	mv	a2,s1
    800021f0:	fc040593          	addi	a1,s0,-64
    800021f4:	854a                	mv	a0,s2
    800021f6:	00000097          	auipc	ra,0x0
    800021fa:	5d0080e7          	jalr	1488(ra) # 800027c6 <read_inode>
    800021fe:	47c1                	li	a5,16
    80002200:	02f51463          	bne	a0,a5,80002228 <dirtest+0x6c>
        off += sizeof(de);
    80002204:	24c1                	addiw	s1,s1,16
        printf("name=%s,inum=%d\n", de.name, de.inum);
    80002206:	fc045603          	lhu	a2,-64(s0)
    8000220a:	fc240593          	addi	a1,s0,-62
    8000220e:	8552                	mv	a0,s4
    80002210:	ffffe097          	auipc	ra,0xffffe
    80002214:	2c2080e7          	jalr	706(ra) # 800004d2 <printf>
        printf("addr=%d\n",ip->addrs[0]);
    80002218:	05092583          	lw	a1,80(s2)
    8000221c:	854e                	mv	a0,s3
    8000221e:	ffffe097          	auipc	ra,0xffffe
    80002222:	2b4080e7          	jalr	692(ra) # 800004d2 <printf>
    80002226:	b7d1                	j	800021ea <dirtest+0x2e>
    }
}
    80002228:	70e2                	ld	ra,56(sp)
    8000222a:	7442                	ld	s0,48(sp)
    8000222c:	74a2                	ld	s1,40(sp)
    8000222e:	7902                	ld	s2,32(sp)
    80002230:	69e2                	ld	s3,24(sp)
    80002232:	6a42                	ld	s4,16(sp)
    80002234:	6121                	addi	sp,sp,64
    80002236:	8082                	ret

0000000080002238 <read_superblock>:

#define min(a, b) ((a) < (b) ? (a) : (b))
struct superblock sb;

// 读取超级块
void read_superblock(struct superblock *sb) {
    80002238:	b9010113          	addi	sp,sp,-1136
    8000223c:	46113423          	sd	ra,1128(sp)
    80002240:	46813023          	sd	s0,1120(sp)
    80002244:	44913c23          	sd	s1,1112(sp)
    80002248:	47010413          	addi	s0,sp,1136
    8000224c:	84aa                	mv	s1,a0
    struct buf b;
    b.blockno = 1;
    8000224e:	4785                	li	a5,1
    80002250:	b8f42e23          	sw	a5,-1124(s0)
    virtio_disk_rw(&b, 0);
    80002254:	4581                	li	a1,0
    80002256:	b9040513          	addi	a0,s0,-1136
    8000225a:	00000097          	auipc	ra,0x0
    8000225e:	b36080e7          	jalr	-1226(ra) # 80001d90 <virtio_disk_rw>
    memmove(sb, &b.data, sizeof(*sb));
    80002262:	4661                	li	a2,24
    80002264:	bdc40593          	addi	a1,s0,-1060
    80002268:	8526                	mv	a0,s1
    8000226a:	fffff097          	auipc	ra,0xfffff
    8000226e:	622080e7          	jalr	1570(ra) # 8000188c <memmove>
    return;
}
    80002272:	46813083          	ld	ra,1128(sp)
    80002276:	46013403          	ld	s0,1120(sp)
    8000227a:	45813483          	ld	s1,1112(sp)
    8000227e:	47010113          	addi	sp,sp,1136
    80002282:	8082                	ret

0000000080002284 <init_fs>:

// 初始化文件系统
void init_fs() {
    80002284:	1101                	addi	sp,sp,-32
    80002286:	ec06                	sd	ra,24(sp)
    80002288:	e822                	sd	s0,16(sp)
    8000228a:	e426                	sd	s1,8(sp)
    8000228c:	1000                	addi	s0,sp,32
    read_superblock(&sb);
    8000228e:	0004f497          	auipc	s1,0x4f
    80002292:	d7248493          	addi	s1,s1,-654 # 80051000 <sb>
    80002296:	8526                	mv	a0,s1
    80002298:	00000097          	auipc	ra,0x0
    8000229c:	fa0080e7          	jalr	-96(ra) # 80002238 <read_superblock>
    if (sb.magic != FSMAGIC) {
    800022a0:	4098                	lw	a4,0(s1)
    800022a2:	102037b7          	lui	a5,0x10203
    800022a6:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800022aa:	00f71763          	bne	a4,a5,800022b8 <init_fs+0x34>
        panic("fs init");
    }
}
    800022ae:	60e2                	ld	ra,24(sp)
    800022b0:	6442                	ld	s0,16(sp)
    800022b2:	64a2                	ld	s1,8(sp)
    800022b4:	6105                	addi	sp,sp,32
    800022b6:	8082                	ret
        panic("fs init");
    800022b8:	00001517          	auipc	a0,0x1
    800022bc:	34850513          	addi	a0,a0,840 # 80003600 <digits+0x5c8>
    800022c0:	ffffe097          	auipc	ra,0xffffe
    800022c4:	444080e7          	jalr	1092(ra) # 80000704 <panic>
}
    800022c8:	b7dd                	j	800022ae <init_fs+0x2a>

00000000800022ca <zero_block>:

// 格式化磁盘块中的数据
void zero_block(int blockno) {
    800022ca:	1101                	addi	sp,sp,-32
    800022cc:	ec06                	sd	ra,24(sp)
    800022ce:	e822                	sd	s0,16(sp)
    800022d0:	e426                	sd	s1,8(sp)
    800022d2:	1000                	addi	s0,sp,32
    800022d4:	85aa                	mv	a1,a0
    struct buf *bp;
    bp = buf_read(0, blockno);
    800022d6:	4501                	li	a0,0
    800022d8:	00001097          	auipc	ra,0x1
    800022dc:	99c080e7          	jalr	-1636(ra) # 80002c74 <buf_read>
    800022e0:	84aa                	mv	s1,a0
    memset(bp->data, 0, BSIZE);
    800022e2:	40000613          	li	a2,1024
    800022e6:	4581                	li	a1,0
    800022e8:	04c50513          	addi	a0,a0,76
    800022ec:	fffff097          	auipc	ra,0xfffff
    800022f0:	57a080e7          	jalr	1402(ra) # 80001866 <memset>
    buf_write(bp);
    800022f4:	8526                	mv	a0,s1
    800022f6:	00001097          	auipc	ra,0x1
    800022fa:	9b2080e7          	jalr	-1614(ra) # 80002ca8 <buf_write>
    relse_buf(bp);
    800022fe:	8526                	mv	a0,s1
    80002300:	00001097          	auipc	ra,0x1
    80002304:	9c2080e7          	jalr	-1598(ra) # 80002cc2 <relse_buf>
}
    80002308:	60e2                	ld	ra,24(sp)
    8000230a:	6442                	ld	s0,16(sp)
    8000230c:	64a2                	ld	s1,8(sp)
    8000230e:	6105                	addi	sp,sp,32
    80002310:	8082                	ret

0000000080002312 <alloc_disk_block>:

// 申请空闲的磁盘块, 返回块号
uint alloc_disk_block() {
    80002312:	715d                	addi	sp,sp,-80
    80002314:	e486                	sd	ra,72(sp)
    80002316:	e0a2                	sd	s0,64(sp)
    80002318:	fc26                	sd	s1,56(sp)
    8000231a:	f84a                	sd	s2,48(sp)
    8000231c:	f44e                	sd	s3,40(sp)
    8000231e:	f052                	sd	s4,32(sp)
    80002320:	ec56                	sd	s5,24(sp)
    80002322:	e85a                	sd	s6,16(sp)
    80002324:	e45e                	sd	s7,8(sp)
    80002326:	0880                	addi	s0,sp,80
    int b, bi, m;
    struct buf *bitmap;

    for (b = 0; b < sb.size; b += BPB) { // 遍历bitmap
    80002328:	0004f797          	auipc	a5,0x4f
    8000232c:	cdc7a783          	lw	a5,-804(a5) # 80051004 <sb+0x4>
    80002330:	c3e9                	beqz	a5,800023f2 <alloc_disk_block+0xe0>
    80002332:	4a81                	li	s5,0
        bitmap = buf_read(0, BBLOCK(b, sb));
    80002334:	0004fb17          	auipc	s6,0x4f
    80002338:	cccb0b13          	addi	s6,s6,-820 # 80051000 <sb>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) { //遍历bitmap的每一位
            m = 1 << (bi % 8);
    8000233c:	4985                	li	s3,1
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) { //遍历bitmap的每一位
    8000233e:	6a09                	lui	s4,0x2
    for (b = 0; b < sb.size; b += BPB) { // 遍历bitmap
    80002340:	6b89                	lui	s7,0x2
    80002342:	a0b1                	j	8000238e <alloc_disk_block+0x7c>
            if ((bitmap->data[bi / 8] & m) == 0) { // 判断块是否被使用
                bitmap->data[bi / 8] |= m; // 标记块被使用
    80002344:	972a                	add	a4,a4,a0
    80002346:	8fd5                	or	a5,a5,a3
    80002348:	04f70623          	sb	a5,76(a4)
                relse_buf(bitmap);
    8000234c:	00001097          	auipc	ra,0x1
    80002350:	976080e7          	jalr	-1674(ra) # 80002cc2 <relse_buf>
                zero_block(b + bi);
    80002354:	854a                	mv	a0,s2
    80002356:	00000097          	auipc	ra,0x0
    8000235a:	f74080e7          	jalr	-140(ra) # 800022ca <zero_block>
        }
        relse_buf(bitmap);
    }
    panic("balloc: out of blocks");
    return 0;
}
    8000235e:	8526                	mv	a0,s1
    80002360:	60a6                	ld	ra,72(sp)
    80002362:	6406                	ld	s0,64(sp)
    80002364:	74e2                	ld	s1,56(sp)
    80002366:	7942                	ld	s2,48(sp)
    80002368:	79a2                	ld	s3,40(sp)
    8000236a:	7a02                	ld	s4,32(sp)
    8000236c:	6ae2                	ld	s5,24(sp)
    8000236e:	6b42                	ld	s6,16(sp)
    80002370:	6ba2                	ld	s7,8(sp)
    80002372:	6161                	addi	sp,sp,80
    80002374:	8082                	ret
        relse_buf(bitmap);
    80002376:	00001097          	auipc	ra,0x1
    8000237a:	94c080e7          	jalr	-1716(ra) # 80002cc2 <relse_buf>
    for (b = 0; b < sb.size; b += BPB) { // 遍历bitmap
    8000237e:	015b87bb          	addw	a5,s7,s5
    80002382:	00078a9b          	sext.w	s5,a5
    80002386:	004b2703          	lw	a4,4(s6)
    8000238a:	06eaf463          	bgeu	s5,a4,800023f2 <alloc_disk_block+0xe0>
        bitmap = buf_read(0, BBLOCK(b, sb));
    8000238e:	41fad79b          	sraiw	a5,s5,0x1f
    80002392:	0137d79b          	srliw	a5,a5,0x13
    80002396:	015787bb          	addw	a5,a5,s5
    8000239a:	40d7d79b          	sraiw	a5,a5,0xd
    8000239e:	014b2583          	lw	a1,20(s6)
    800023a2:	9dbd                	addw	a1,a1,a5
    800023a4:	4501                	li	a0,0
    800023a6:	00001097          	auipc	ra,0x1
    800023aa:	8ce080e7          	jalr	-1842(ra) # 80002c74 <buf_read>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) { //遍历bitmap的每一位
    800023ae:	004b2803          	lw	a6,4(s6)
    800023b2:	000a849b          	sext.w	s1,s5
    800023b6:	4601                	li	a2,0
    800023b8:	0004891b          	sext.w	s2,s1
    800023bc:	fb04fde3          	bgeu	s1,a6,80002376 <alloc_disk_block+0x64>
            m = 1 << (bi % 8);
    800023c0:	41f6579b          	sraiw	a5,a2,0x1f
    800023c4:	01d7d69b          	srliw	a3,a5,0x1d
    800023c8:	00c6873b          	addw	a4,a3,a2
    800023cc:	00777793          	andi	a5,a4,7
    800023d0:	9f95                	subw	a5,a5,a3
    800023d2:	00f997bb          	sllw	a5,s3,a5
            if ((bitmap->data[bi / 8] & m) == 0) { // 判断块是否被使用
    800023d6:	4037571b          	sraiw	a4,a4,0x3
    800023da:	00e506b3          	add	a3,a0,a4
    800023de:	04c6c683          	lbu	a3,76(a3)
    800023e2:	00d7f5b3          	and	a1,a5,a3
    800023e6:	ddb9                	beqz	a1,80002344 <alloc_disk_block+0x32>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) { //遍历bitmap的每一位
    800023e8:	2605                	addiw	a2,a2,1
    800023ea:	2485                	addiw	s1,s1,1
    800023ec:	fd4616e3          	bne	a2,s4,800023b8 <alloc_disk_block+0xa6>
    800023f0:	b759                	j	80002376 <alloc_disk_block+0x64>
    panic("balloc: out of blocks");
    800023f2:	00001517          	auipc	a0,0x1
    800023f6:	21650513          	addi	a0,a0,534 # 80003608 <digits+0x5d0>
    800023fa:	ffffe097          	auipc	ra,0xffffe
    800023fe:	30a080e7          	jalr	778(ra) # 80000704 <panic>
    return 0;
    80002402:	4481                	li	s1,0
    80002404:	bfa9                	j	8000235e <alloc_disk_block+0x4c>

0000000080002406 <free_disk_block>:

// 释放磁盘块
void free_disk_block(int blockno) {
    80002406:	1101                	addi	sp,sp,-32
    80002408:	ec06                	sd	ra,24(sp)
    8000240a:	e822                	sd	s0,16(sp)
    8000240c:	e426                	sd	s1,8(sp)
    8000240e:	e04a                	sd	s2,0(sp)
    80002410:	1000                	addi	s0,sp,32
    struct buf *bitmap;
    int bi, m;
    bitmap = buf_read(0, BBLOCK(blockno, sb));
    80002412:	41f5549b          	sraiw	s1,a0,0x1f
    80002416:	0134d91b          	srliw	s2,s1,0x13
    8000241a:	00a904bb          	addw	s1,s2,a0
    8000241e:	40d4d59b          	sraiw	a1,s1,0xd
    80002422:	0004f797          	auipc	a5,0x4f
    80002426:	bf27a783          	lw	a5,-1038(a5) # 80051014 <sb+0x14>
    8000242a:	9dbd                	addw	a1,a1,a5
    8000242c:	4501                	li	a0,0
    8000242e:	00001097          	auipc	ra,0x1
    80002432:	846080e7          	jalr	-1978(ra) # 80002c74 <buf_read>
    bi = blockno % BPB;
    80002436:	14ce                	slli	s1,s1,0x33
    80002438:	90cd                	srli	s1,s1,0x33
    8000243a:	412484bb          	subw	s1,s1,s2
    m = 1 << (bi % 8);

    bitmap->data[bi / 8] &= ~m;
    8000243e:	41f4d79b          	sraiw	a5,s1,0x1f
    80002442:	01d7d79b          	srliw	a5,a5,0x1d
    80002446:	9cbd                	addw	s1,s1,a5
    80002448:	4034d71b          	sraiw	a4,s1,0x3
    8000244c:	972a                	add	a4,a4,a0
    m = 1 << (bi % 8);
    8000244e:	889d                	andi	s1,s1,7
    80002450:	9c9d                	subw	s1,s1,a5
    bitmap->data[bi / 8] &= ~m;
    80002452:	4785                	li	a5,1
    80002454:	009794bb          	sllw	s1,a5,s1
    80002458:	fff4c493          	not	s1,s1
    8000245c:	04c74783          	lbu	a5,76(a4)
    80002460:	8cfd                	and	s1,s1,a5
    80002462:	04970623          	sb	s1,76(a4)
    relse_buf(bitmap);
    80002466:	00001097          	auipc	ra,0x1
    8000246a:	85c080e7          	jalr	-1956(ra) # 80002cc2 <relse_buf>
}
    8000246e:	60e2                	ld	ra,24(sp)
    80002470:	6442                	ld	s0,16(sp)
    80002472:	64a2                	ld	s1,8(sp)
    80002474:	6902                	ld	s2,0(sp)
    80002476:	6105                	addi	sp,sp,32
    80002478:	8082                	ret

000000008000247a <init_inode_cache>:
} inode_cache;

//static struct inode* get_inode(int inum);

// 初始化inode的缓存
void init_inode_cache() {
    8000247a:	7179                	addi	sp,sp,-48
    8000247c:	f406                	sd	ra,40(sp)
    8000247e:	f022                	sd	s0,32(sp)
    80002480:	ec26                	sd	s1,24(sp)
    80002482:	e84a                	sd	s2,16(sp)
    80002484:	e44e                	sd	s3,8(sp)
    80002486:	1800                	addi	s0,sp,48
    spinlock_init(&inode_cache.lock, "inode cache");
    80002488:	00001597          	auipc	a1,0x1
    8000248c:	19858593          	addi	a1,a1,408 # 80003620 <digits+0x5e8>
    80002490:	0004f517          	auipc	a0,0x4f
    80002494:	b8850513          	addi	a0,a0,-1144 # 80051018 <inode_cache>
    80002498:	00001097          	auipc	ra,0x1
    8000249c:	85a080e7          	jalr	-1958(ra) # 80002cf2 <spinlock_init>
//  struct inode i;
    for (int i = 0; i < NINODE; i++) {
    800024a0:	0004f497          	auipc	s1,0x4f
    800024a4:	ba048493          	addi	s1,s1,-1120 # 80051040 <inode_cache+0x28>
    800024a8:	00050997          	auipc	s3,0x50
    800024ac:	62898993          	addi	s3,s3,1576 # 80052ad0 <cache_lock+0x10>
        sleeplock_init(&inode_cache.inode[i].lock, "inode");
    800024b0:	00001917          	auipc	s2,0x1
    800024b4:	18090913          	addi	s2,s2,384 # 80003630 <digits+0x5f8>
    800024b8:	85ca                	mv	a1,s2
    800024ba:	8526                	mv	a0,s1
    800024bc:	00001097          	auipc	ra,0x1
    800024c0:	9f6080e7          	jalr	-1546(ra) # 80002eb2 <sleeplock_init>
    for (int i = 0; i < NINODE; i++) {
    800024c4:	08848493          	addi	s1,s1,136
    800024c8:	ff3498e3          	bne	s1,s3,800024b8 <init_inode_cache+0x3e>
    }
}
    800024cc:	70a2                	ld	ra,40(sp)
    800024ce:	7402                	ld	s0,32(sp)
    800024d0:	64e2                	ld	s1,24(sp)
    800024d2:	6942                	ld	s2,16(sp)
    800024d4:	69a2                	ld	s3,8(sp)
    800024d6:	6145                	addi	sp,sp,48
    800024d8:	8082                	ret

00000000800024da <update_inode>:
    panic("alloc_inode: no inodes");
    return 0;
}

// 将内存中的inode写入到磁盘中,
void update_inode(struct inode *ip) {
    800024da:	1101                	addi	sp,sp,-32
    800024dc:	ec06                	sd	ra,24(sp)
    800024de:	e822                	sd	s0,16(sp)
    800024e0:	e426                	sd	s1,8(sp)
    800024e2:	e04a                	sd	s2,0(sp)
    800024e4:	1000                	addi	s0,sp,32
    800024e6:	84aa                	mv	s1,a0
    struct buf *bp;
    struct dinode *dip;

    bp = buf_read(ip->dev, IBLOCK(ip->inum, sb));
    800024e8:	415c                	lw	a5,4(a0)
    800024ea:	0047d79b          	srliw	a5,a5,0x4
    800024ee:	0004f597          	auipc	a1,0x4f
    800024f2:	b225a583          	lw	a1,-1246(a1) # 80051010 <sb+0x10>
    800024f6:	9dbd                	addw	a1,a1,a5
    800024f8:	4108                	lw	a0,0(a0)
    800024fa:	00000097          	auipc	ra,0x0
    800024fe:	77a080e7          	jalr	1914(ra) # 80002c74 <buf_read>
    80002502:	892a                	mv	s2,a0
    dip = (struct dinode *) bp->data + ip->inum % IPB;
    80002504:	04c50793          	addi	a5,a0,76
    80002508:	40c8                	lw	a0,4(s1)
    8000250a:	893d                	andi	a0,a0,15
    8000250c:	051a                	slli	a0,a0,0x6
    8000250e:	953e                	add	a0,a0,a5
    dip->type = ip->type;
    80002510:	04449703          	lh	a4,68(s1)
    80002514:	00e51023          	sh	a4,0(a0)
    dip->major = ip->major;
    80002518:	04649703          	lh	a4,70(s1)
    8000251c:	00e51123          	sh	a4,2(a0)
    dip->minor = ip->minor;
    80002520:	04849703          	lh	a4,72(s1)
    80002524:	00e51223          	sh	a4,4(a0)
    dip->nlink = ip->nlink;
    80002528:	04a49703          	lh	a4,74(s1)
    8000252c:	00e51323          	sh	a4,6(a0)
    dip->size = ip->size;
    80002530:	44f8                	lw	a4,76(s1)
    80002532:	c518                	sw	a4,8(a0)
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002534:	03400613          	li	a2,52
    80002538:	05048593          	addi	a1,s1,80
    8000253c:	0531                	addi	a0,a0,12
    8000253e:	fffff097          	auipc	ra,0xfffff
    80002542:	34e080e7          	jalr	846(ra) # 8000188c <memmove>
    buf_write(bp);
    80002546:	854a                	mv	a0,s2
    80002548:	00000097          	auipc	ra,0x0
    8000254c:	760080e7          	jalr	1888(ra) # 80002ca8 <buf_write>
    relse_buf(bp);
    80002550:	854a                	mv	a0,s2
    80002552:	00000097          	auipc	ra,0x0
    80002556:	770080e7          	jalr	1904(ra) # 80002cc2 <relse_buf>
}
    8000255a:	60e2                	ld	ra,24(sp)
    8000255c:	6442                	ld	s0,16(sp)
    8000255e:	64a2                	ld	s1,8(sp)
    80002560:	6902                	ld	s2,0(sp)
    80002562:	6105                	addi	sp,sp,32
    80002564:	8082                	ret

0000000080002566 <get_inode>:

// 通过inum从缓冲池中获取一个inode
struct inode *get_inode(int inum) {
    80002566:	7179                	addi	sp,sp,-48
    80002568:	f406                	sd	ra,40(sp)
    8000256a:	f022                	sd	s0,32(sp)
    8000256c:	ec26                	sd	s1,24(sp)
    8000256e:	e84a                	sd	s2,16(sp)
    80002570:	e44e                	sd	s3,8(sp)
    80002572:	1800                	addi	s0,sp,48
    80002574:	89aa                	mv	s3,a0
    struct inode *empty;
    struct buf *bp;
    struct dinode *dip;

//    spin_lock(&inode_cache.lock);
    empty = 0;
    80002576:	4901                	li	s2,0
    for (ip = &inode_cache.inode[0]; ip < &inode_cache.inode[NINODE]; ip++) {
    80002578:	0004f497          	auipc	s1,0x4f
    8000257c:	ab848493          	addi	s1,s1,-1352 # 80051030 <inode_cache+0x18>
        if (ip->ref > 0 && ip->inum == inum) {
    80002580:	0005061b          	sext.w	a2,a0
    for (ip = &inode_cache.inode[0]; ip < &inode_cache.inode[NINODE]; ip++) {
    80002584:	00050697          	auipc	a3,0x50
    80002588:	53c68693          	addi	a3,a3,1340 # 80052ac0 <cache_lock>
    8000258c:	a039                	j	8000259a <get_inode+0x34>
            ip->ref++;
            spin_unlock(&inode_cache.lock);
            return ip;
        }
        if (empty == 0 && ip->ref == 0) { // 记住未使用缓冲项
    8000258e:	02090f63          	beqz	s2,800025cc <get_inode+0x66>
    for (ip = &inode_cache.inode[0]; ip < &inode_cache.inode[NINODE]; ip++) {
    80002592:	08848493          	addi	s1,s1,136
    80002596:	02d48e63          	beq	s1,a3,800025d2 <get_inode+0x6c>
        if (ip->ref > 0 && ip->inum == inum) {
    8000259a:	449c                	lw	a5,8(s1)
    8000259c:	fef059e3          	blez	a5,8000258e <get_inode+0x28>
    800025a0:	40d8                	lw	a4,4(s1)
    800025a2:	fec716e3          	bne	a4,a2,8000258e <get_inode+0x28>
            ip->ref++;
    800025a6:	2785                	addiw	a5,a5,1
    800025a8:	c49c                	sw	a5,8(s1)
            spin_unlock(&inode_cache.lock);
    800025aa:	0004f517          	auipc	a0,0x4f
    800025ae:	a6e50513          	addi	a0,a0,-1426 # 80051018 <inode_cache>
    800025b2:	00001097          	auipc	ra,0x1
    800025b6:	8a4080e7          	jalr	-1884(ra) # 80002e56 <spin_unlock>
            return ip;
    800025ba:	8926                	mv	s2,s1
    if (ip->type == 0)
        panic("get_inode: no type");

//    spin_unlock(&inode_cache.lock);
    return ip;
}
    800025bc:	854a                	mv	a0,s2
    800025be:	70a2                	ld	ra,40(sp)
    800025c0:	7402                	ld	s0,32(sp)
    800025c2:	64e2                	ld	s1,24(sp)
    800025c4:	6942                	ld	s2,16(sp)
    800025c6:	69a2                	ld	s3,8(sp)
    800025c8:	6145                	addi	sp,sp,48
    800025ca:	8082                	ret
        if (empty == 0 && ip->ref == 0) { // 记住未使用缓冲项
    800025cc:	f3f9                	bnez	a5,80002592 <get_inode+0x2c>
    800025ce:	8926                	mv	s2,s1
    800025d0:	b7c9                	j	80002592 <get_inode+0x2c>
    if (empty == 0) {
    800025d2:	08090463          	beqz	s2,8000265a <get_inode+0xf4>
    bp = buf_read(0, IBLOCK(inum, sb));
    800025d6:	0049d793          	srli	a5,s3,0x4
    800025da:	0004f597          	auipc	a1,0x4f
    800025de:	a365a583          	lw	a1,-1482(a1) # 80051010 <sb+0x10>
    800025e2:	9dbd                	addw	a1,a1,a5
    800025e4:	4501                	li	a0,0
    800025e6:	00000097          	auipc	ra,0x0
    800025ea:	68e080e7          	jalr	1678(ra) # 80002c74 <buf_read>
    800025ee:	84aa                	mv	s1,a0
    dip = (struct dinode *) bp->data + inum % IPB;
    800025f0:	04c50593          	addi	a1,a0,76
    800025f4:	00f9f793          	andi	a5,s3,15
    800025f8:	079a                	slli	a5,a5,0x6
    800025fa:	95be                	add	a1,a1,a5
    ip->inum = inum;
    800025fc:	01392223          	sw	s3,4(s2)
    ip->type = dip->type;
    80002600:	00059783          	lh	a5,0(a1)
    80002604:	04f91223          	sh	a5,68(s2)
    ip->major = dip->major;
    80002608:	00259783          	lh	a5,2(a1)
    8000260c:	04f91323          	sh	a5,70(s2)
    ip->minor = dip->minor;
    80002610:	00459783          	lh	a5,4(a1)
    80002614:	04f91423          	sh	a5,72(s2)
    ip->nlink = dip->nlink;
    80002618:	00659783          	lh	a5,6(a1)
    8000261c:	04f91523          	sh	a5,74(s2)
    ip->size = dip->size;
    80002620:	459c                	lw	a5,8(a1)
    80002622:	04f92623          	sw	a5,76(s2)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002626:	03400613          	li	a2,52
    8000262a:	05b1                	addi	a1,a1,12
    8000262c:	05090513          	addi	a0,s2,80
    80002630:	fffff097          	auipc	ra,0xfffff
    80002634:	25c080e7          	jalr	604(ra) # 8000188c <memmove>
    relse_buf(bp);
    80002638:	8526                	mv	a0,s1
    8000263a:	00000097          	auipc	ra,0x0
    8000263e:	688080e7          	jalr	1672(ra) # 80002cc2 <relse_buf>
    if (ip->type == 0)
    80002642:	04491783          	lh	a5,68(s2)
    80002646:	fbbd                	bnez	a5,800025bc <get_inode+0x56>
        panic("get_inode: no type");
    80002648:	00001517          	auipc	a0,0x1
    8000264c:	00050513          	mv	a0,a0
    80002650:	ffffe097          	auipc	ra,0xffffe
    80002654:	0b4080e7          	jalr	180(ra) # 80000704 <panic>
    80002658:	b795                	j	800025bc <get_inode+0x56>
        panic("get_inode");
    8000265a:	00001517          	auipc	a0,0x1
    8000265e:	fde50513          	addi	a0,a0,-34 # 80003638 <digits+0x600>
    80002662:	ffffe097          	auipc	ra,0xffffe
    80002666:	0a2080e7          	jalr	162(ra) # 80000704 <panic>
    8000266a:	b7b5                	j	800025d6 <get_inode+0x70>

000000008000266c <alloc_inode>:
struct inode *alloc_inode(short type) {
    8000266c:	7139                	addi	sp,sp,-64
    8000266e:	fc06                	sd	ra,56(sp)
    80002670:	f822                	sd	s0,48(sp)
    80002672:	f426                	sd	s1,40(sp)
    80002674:	f04a                	sd	s2,32(sp)
    80002676:	ec4e                	sd	s3,24(sp)
    80002678:	e852                	sd	s4,16(sp)
    8000267a:	e456                	sd	s5,8(sp)
    8000267c:	e05a                	sd	s6,0(sp)
    8000267e:	0080                	addi	s0,sp,64
    for (inum = 1; inum < sb.ninodes; inum++) {
    80002680:	0004f717          	auipc	a4,0x4f
    80002684:	98c72703          	lw	a4,-1652(a4) # 8005100c <sb+0xc>
    80002688:	4785                	li	a5,1
    8000268a:	04e7f963          	bgeu	a5,a4,800026dc <alloc_inode+0x70>
    8000268e:	8b2a                	mv	s6,a0
    80002690:	4905                	li	s2,1
        bp = buf_read(0, IBLOCK(inum, sb));
    80002692:	0004fa97          	auipc	s5,0x4f
    80002696:	96ea8a93          	addi	s5,s5,-1682 # 80051000 <sb>
    8000269a:	00090a1b          	sext.w	s4,s2
    8000269e:	00495593          	srli	a1,s2,0x4
    800026a2:	010aa783          	lw	a5,16(s5)
    800026a6:	9dbd                	addw	a1,a1,a5
    800026a8:	4501                	li	a0,0
    800026aa:	00000097          	auipc	ra,0x0
    800026ae:	5ca080e7          	jalr	1482(ra) # 80002c74 <buf_read>
    800026b2:	84aa                	mv	s1,a0
        dip = (struct dinode *) bp->data + inum % IPB;
    800026b4:	04c50993          	addi	s3,a0,76
    800026b8:	00fa7793          	andi	a5,s4,15
    800026bc:	079a                	slli	a5,a5,0x6
    800026be:	99be                	add	s3,s3,a5
        if (dip->type == 0) { // a free inode
    800026c0:	00099783          	lh	a5,0(s3)
    800026c4:	cf9d                	beqz	a5,80002702 <alloc_inode+0x96>
        relse_buf(bp);
    800026c6:	00000097          	auipc	ra,0x0
    800026ca:	5fc080e7          	jalr	1532(ra) # 80002cc2 <relse_buf>
    for (inum = 1; inum < sb.ninodes; inum++) {
    800026ce:	0905                	addi	s2,s2,1
    800026d0:	00caa703          	lw	a4,12(s5)
    800026d4:	0009079b          	sext.w	a5,s2
    800026d8:	fce7e1e3          	bltu	a5,a4,8000269a <alloc_inode+0x2e>
    panic("alloc_inode: no inodes");
    800026dc:	00001517          	auipc	a0,0x1
    800026e0:	f8450513          	addi	a0,a0,-124 # 80003660 <digits+0x628>
    800026e4:	ffffe097          	auipc	ra,0xffffe
    800026e8:	020080e7          	jalr	32(ra) # 80000704 <panic>
    return 0;
    800026ec:	4501                	li	a0,0
}
    800026ee:	70e2                	ld	ra,56(sp)
    800026f0:	7442                	ld	s0,48(sp)
    800026f2:	74a2                	ld	s1,40(sp)
    800026f4:	7902                	ld	s2,32(sp)
    800026f6:	69e2                	ld	s3,24(sp)
    800026f8:	6a42                	ld	s4,16(sp)
    800026fa:	6aa2                	ld	s5,8(sp)
    800026fc:	6b02                	ld	s6,0(sp)
    800026fe:	6121                	addi	sp,sp,64
    80002700:	8082                	ret
            memset(dip, 0, sizeof(*dip));
    80002702:	04000613          	li	a2,64
    80002706:	4581                	li	a1,0
    80002708:	854e                	mv	a0,s3
    8000270a:	fffff097          	auipc	ra,0xfffff
    8000270e:	15c080e7          	jalr	348(ra) # 80001866 <memset>
            dip->type = type;
    80002712:	01699023          	sh	s6,0(s3)
            buf_write(bp); // 写回磁盘
    80002716:	8526                	mv	a0,s1
    80002718:	00000097          	auipc	ra,0x0
    8000271c:	590080e7          	jalr	1424(ra) # 80002ca8 <buf_write>
            relse_buf(bp);
    80002720:	8526                	mv	a0,s1
    80002722:	00000097          	auipc	ra,0x0
    80002726:	5a0080e7          	jalr	1440(ra) # 80002cc2 <relse_buf>
            return get_inode(inum);
    8000272a:	8552                	mv	a0,s4
    8000272c:	00000097          	auipc	ra,0x0
    80002730:	e3a080e7          	jalr	-454(ra) # 80002566 <get_inode>
    80002734:	bf6d                	j	800026ee <alloc_inode+0x82>

0000000080002736 <putback_inode>:

// 通过inum从缓冲池中获取一个inode
void putback_inode(struct inode *ip) {
    80002736:	1101                	addi	sp,sp,-32
    80002738:	ec06                	sd	ra,24(sp)
    8000273a:	e822                	sd	s0,16(sp)
    8000273c:	e426                	sd	s1,8(sp)
    8000273e:	1000                	addi	s0,sp,32
    80002740:	84aa                	mv	s1,a0
    spin_lock(&inode_cache.lock);
    80002742:	0004f517          	auipc	a0,0x4f
    80002746:	8d650513          	addi	a0,a0,-1834 # 80051018 <inode_cache>
    8000274a:	00000097          	auipc	ra,0x0
    8000274e:	638080e7          	jalr	1592(ra) # 80002d82 <spin_lock>
    ip->ref--;
    80002752:	449c                	lw	a5,8(s1)
    80002754:	37fd                	addiw	a5,a5,-1
    80002756:	c49c                	sw	a5,8(s1)
    spin_unlock(&inode_cache.lock);
    80002758:	0004f517          	auipc	a0,0x4f
    8000275c:	8c050513          	addi	a0,a0,-1856 # 80051018 <inode_cache>
    80002760:	00000097          	auipc	ra,0x0
    80002764:	6f6080e7          	jalr	1782(ra) # 80002e56 <spin_unlock>
}
    80002768:	60e2                	ld	ra,24(sp)
    8000276a:	6442                	ld	s0,16(sp)
    8000276c:	64a2                	ld	s1,8(sp)
    8000276e:	6105                	addi	sp,sp,32
    80002770:	8082                	ret

0000000080002772 <bmap>:

// 数据块包含直接块和间接块，这里只实现了直接块
// 获取inode的第bn个数据块对应的磁盘块号
uint bmap(struct inode *ip, uint bn) {
    80002772:	1101                	addi	sp,sp,-32
    80002774:	ec06                	sd	ra,24(sp)
    80002776:	e822                	sd	s0,16(sp)
    80002778:	e426                	sd	s1,8(sp)
    8000277a:	1000                	addi	s0,sp,32
    uint64 addr;
    if (bn < NDIRECT) {
    8000277c:	47ad                	li	a5,11
    8000277e:	02b7ea63          	bltu	a5,a1,800027b2 <bmap+0x40>
        if ((addr = ip->addrs[bn]) == 0)
    80002782:	1582                	slli	a1,a1,0x20
    80002784:	9181                	srli	a1,a1,0x20
    80002786:	058a                	slli	a1,a1,0x2
    80002788:	00b504b3          	add	s1,a0,a1
    8000278c:	0504e783          	lwu	a5,80(s1)
    80002790:	cb81                	beqz	a5,800027a0 <bmap+0x2e>
            ip->addrs[bn] = addr = alloc_disk_block();
        return addr;
    80002792:	0007851b          	sext.w	a0,a5
    }

    panic("bmap");
    return 0;
}
    80002796:	60e2                	ld	ra,24(sp)
    80002798:	6442                	ld	s0,16(sp)
    8000279a:	64a2                	ld	s1,8(sp)
    8000279c:	6105                	addi	sp,sp,32
    8000279e:	8082                	ret
            ip->addrs[bn] = addr = alloc_disk_block();
    800027a0:	00000097          	auipc	ra,0x0
    800027a4:	b72080e7          	jalr	-1166(ra) # 80002312 <alloc_disk_block>
    800027a8:	02051793          	slli	a5,a0,0x20
    800027ac:	9381                	srli	a5,a5,0x20
    800027ae:	c8a8                	sw	a0,80(s1)
    800027b0:	b7cd                	j	80002792 <bmap+0x20>
    panic("bmap");
    800027b2:	00001517          	auipc	a0,0x1
    800027b6:	ec650513          	addi	a0,a0,-314 # 80003678 <digits+0x640>
    800027ba:	ffffe097          	auipc	ra,0xffffe
    800027be:	f4a080e7          	jalr	-182(ra) # 80000704 <panic>
    return 0;
    800027c2:	4501                	li	a0,0
    800027c4:	bfc9                	j	80002796 <bmap+0x24>

00000000800027c6 <read_inode>:

// 从inode中读取数据
int read_inode(struct inode *ip, uint64 dst, uint off, int n) {
    800027c6:	711d                	addi	sp,sp,-96
    800027c8:	ec86                	sd	ra,88(sp)
    800027ca:	e8a2                	sd	s0,80(sp)
    800027cc:	e4a6                	sd	s1,72(sp)
    800027ce:	e0ca                	sd	s2,64(sp)
    800027d0:	fc4e                	sd	s3,56(sp)
    800027d2:	f852                	sd	s4,48(sp)
    800027d4:	f456                	sd	s5,40(sp)
    800027d6:	f05a                	sd	s6,32(sp)
    800027d8:	ec5e                	sd	s7,24(sp)
    800027da:	e862                	sd	s8,16(sp)
    800027dc:	e466                	sd	s9,8(sp)
    800027de:	1080                	addi	s0,sp,96
    int total = 0, m = 0;
    struct buf *bp;
    if (off > ip->size || off + n < off) {
    800027e0:	457c                	lw	a5,76(a0)
        return 0;
    800027e2:	4981                	li	s3,0
    if (off > ip->size || off + n < off) {
    800027e4:	02c7e463          	bltu	a5,a2,8000280c <read_inode+0x46>
    800027e8:	8baa                	mv	s7,a0
    800027ea:	8aae                	mv	s5,a1
    800027ec:	84b2                	mv	s1,a2
    800027ee:	8b36                	mv	s6,a3
    800027f0:	00c6873b          	addw	a4,a3,a2
        return 0;
    800027f4:	4981                	li	s3,0
    if (off > ip->size || off + n < off) {
    800027f6:	00c76b63          	bltu	a4,a2,8000280c <read_inode+0x46>
    }
    if (off + n > ip->size) {
    800027fa:	00e7f463          	bgeu	a5,a4,80002802 <read_inode+0x3c>
        n = ip->size - off;
    800027fe:	40c78b3b          	subw	s6,a5,a2
    }

    for (; total < n; total += m, off += m, dst += m) {
    80002802:	4981                	li	s3,0
        bp = buf_read(0, bmap(ip, off / BSIZE));
        m = min(BSIZE - off % BSIZE, n - total);
    80002804:	40000c13          	li	s8,1024
    for (; total < n; total += m, off += m, dst += m) {
    80002808:	05604763          	bgtz	s6,80002856 <read_inode+0x90>
        memmove((uint64 *) (dst), bp->data + (off % BSIZE), m);
        relse_buf(bp);
    }
    return total;
}
    8000280c:	854e                	mv	a0,s3
    8000280e:	60e6                	ld	ra,88(sp)
    80002810:	6446                	ld	s0,80(sp)
    80002812:	64a6                	ld	s1,72(sp)
    80002814:	6906                	ld	s2,64(sp)
    80002816:	79e2                	ld	s3,56(sp)
    80002818:	7a42                	ld	s4,48(sp)
    8000281a:	7aa2                	ld	s5,40(sp)
    8000281c:	7b02                	ld	s6,32(sp)
    8000281e:	6be2                	ld	s7,24(sp)
    80002820:	6c42                	ld	s8,16(sp)
    80002822:	6ca2                	ld	s9,8(sp)
    80002824:	6125                	addi	sp,sp,96
    80002826:	8082                	ret
        m = min(BSIZE - off % BSIZE, n - total);
    80002828:	000a0c9b          	sext.w	s9,s4
        memmove((uint64 *) (dst), bp->data + (off % BSIZE), m);
    8000282c:	04c90593          	addi	a1,s2,76
    80002830:	8666                	mv	a2,s9
    80002832:	95ba                	add	a1,a1,a4
    80002834:	8556                	mv	a0,s5
    80002836:	fffff097          	auipc	ra,0xfffff
    8000283a:	056080e7          	jalr	86(ra) # 8000188c <memmove>
        relse_buf(bp);
    8000283e:	854a                	mv	a0,s2
    80002840:	00000097          	auipc	ra,0x0
    80002844:	482080e7          	jalr	1154(ra) # 80002cc2 <relse_buf>
    for (; total < n; total += m, off += m, dst += m) {
    80002848:	013a09bb          	addw	s3,s4,s3
    8000284c:	009a04bb          	addw	s1,s4,s1
    80002850:	9ae6                	add	s5,s5,s9
    80002852:	fb69dde3          	bge	s3,s6,8000280c <read_inode+0x46>
        bp = buf_read(0, bmap(ip, off / BSIZE));
    80002856:	00a4d59b          	srliw	a1,s1,0xa
    8000285a:	855e                	mv	a0,s7
    8000285c:	00000097          	auipc	ra,0x0
    80002860:	f16080e7          	jalr	-234(ra) # 80002772 <bmap>
    80002864:	0005059b          	sext.w	a1,a0
    80002868:	4501                	li	a0,0
    8000286a:	00000097          	auipc	ra,0x0
    8000286e:	40a080e7          	jalr	1034(ra) # 80002c74 <buf_read>
    80002872:	892a                	mv	s2,a0
        m = min(BSIZE - off % BSIZE, n - total);
    80002874:	3ff4f713          	andi	a4,s1,1023
    80002878:	413b07bb          	subw	a5,s6,s3
    8000287c:	40ec06bb          	subw	a3,s8,a4
    80002880:	8a3e                	mv	s4,a5
    80002882:	2781                	sext.w	a5,a5
    80002884:	0006861b          	sext.w	a2,a3
    80002888:	faf670e3          	bgeu	a2,a5,80002828 <read_inode+0x62>
    8000288c:	8a36                	mv	s4,a3
    8000288e:	bf69                	j	80002828 <read_inode+0x62>

0000000080002890 <write_inode>:

// 将数据写入inode
int write_inode(struct inode *ip, uint64 src, uint64 off, int n) {
    80002890:	711d                	addi	sp,sp,-96
    80002892:	ec86                	sd	ra,88(sp)
    80002894:	e8a2                	sd	s0,80(sp)
    80002896:	e4a6                	sd	s1,72(sp)
    80002898:	e0ca                	sd	s2,64(sp)
    8000289a:	fc4e                	sd	s3,56(sp)
    8000289c:	f852                	sd	s4,48(sp)
    8000289e:	f456                	sd	s5,40(sp)
    800028a0:	f05a                	sd	s6,32(sp)
    800028a2:	ec5e                	sd	s7,24(sp)
    800028a4:	e862                	sd	s8,16(sp)
    800028a6:	e466                	sd	s9,8(sp)
    800028a8:	1080                	addi	s0,sp,96
    uint total, m;
    struct buf *bp;

    if (off > ip->size || off + n < off)
    800028aa:	04c56783          	lwu	a5,76(a0)
    800028ae:	0cc7e763          	bltu	a5,a2,8000297c <write_inode+0xec>
    800028b2:	8baa                	mv	s7,a0
    800028b4:	8aae                	mv	s5,a1
    800028b6:	89b2                	mv	s3,a2
    800028b8:	8cb6                	mv	s9,a3
    800028ba:	00c687b3          	add	a5,a3,a2
    800028be:	0cc7e163          	bltu	a5,a2,80002980 <write_inode+0xf0>
        return -1;
    if (off + n > MAXFILE * BSIZE)
    800028c2:	00043737          	lui	a4,0x43
    800028c6:	0af76f63          	bltu	a4,a5,80002984 <write_inode+0xf4>
        return -1;
    for (total = 0; total < n; total += m, off += m, src += m) {
    800028ca:	00068b1b          	sext.w	s6,a3
    800028ce:	0a0b0d63          	beqz	s6,80002988 <write_inode+0xf8>
    800028d2:	4a01                	li	s4,0
        bp = buf_read(0, bmap(ip, off / BSIZE));
        m = min(BSIZE - off % BSIZE, n - total);
    800028d4:	40000c13          	li	s8,1024
    800028d8:	a81d                	j	8000290e <write_inode+0x7e>
        memmove(bp->data + (off % BSIZE), (uint64 *) (src), m);
    800028da:	04c90513          	addi	a0,s2,76
    800028de:	0004861b          	sext.w	a2,s1
    800028e2:	85d6                	mv	a1,s5
    800028e4:	953e                	add	a0,a0,a5
    800028e6:	fffff097          	auipc	ra,0xfffff
    800028ea:	fa6080e7          	jalr	-90(ra) # 8000188c <memmove>
        buf_write(bp);
    800028ee:	854a                	mv	a0,s2
    800028f0:	00000097          	auipc	ra,0x0
    800028f4:	3b8080e7          	jalr	952(ra) # 80002ca8 <buf_write>
        relse_buf(bp);
    800028f8:	854a                	mv	a0,s2
    800028fa:	00000097          	auipc	ra,0x0
    800028fe:	3c8080e7          	jalr	968(ra) # 80002cc2 <relse_buf>
    for (total = 0; total < n; total += m, off += m, src += m) {
    80002902:	01448a3b          	addw	s4,s1,s4
    80002906:	99a6                	add	s3,s3,s1
    80002908:	9aa6                	add	s5,s5,s1
    8000290a:	036a7e63          	bgeu	s4,s6,80002946 <write_inode+0xb6>
        bp = buf_read(0, bmap(ip, off / BSIZE));
    8000290e:	00a9d593          	srli	a1,s3,0xa
    80002912:	2581                	sext.w	a1,a1
    80002914:	855e                	mv	a0,s7
    80002916:	00000097          	auipc	ra,0x0
    8000291a:	e5c080e7          	jalr	-420(ra) # 80002772 <bmap>
    8000291e:	0005059b          	sext.w	a1,a0
    80002922:	4501                	li	a0,0
    80002924:	00000097          	auipc	ra,0x0
    80002928:	350080e7          	jalr	848(ra) # 80002c74 <buf_read>
    8000292c:	892a                	mv	s2,a0
        m = min(BSIZE - off % BSIZE, n - total);
    8000292e:	3ff9f793          	andi	a5,s3,1023
    80002932:	414b04bb          	subw	s1,s6,s4
    80002936:	40fc0733          	sub	a4,s8,a5
    8000293a:	1482                	slli	s1,s1,0x20
    8000293c:	9081                	srli	s1,s1,0x20
    8000293e:	f8977ee3          	bgeu	a4,s1,800028da <write_inode+0x4a>
    80002942:	84ba                	mv	s1,a4
    80002944:	bf59                	j	800028da <write_inode+0x4a>
    }
    if (n > 0) {
    80002946:	01905d63          	blez	s9,80002960 <write_inode+0xd0>
        if (off > ip->size)
    8000294a:	04cbe783          	lwu	a5,76(s7) # 204c <_entry-0x7fffdfb4>
    8000294e:	0137f463          	bgeu	a5,s3,80002956 <write_inode+0xc6>
            ip->size = off;
    80002952:	053ba623          	sw	s3,76(s7)
        // 将内存中的inode写入磁盘，即使没有写入数据，也需要更新，因为循环中可能
        //调用了bmap()或者在ip->addrs[]里面添加了数据块
        update_inode(ip);
    80002956:	855e                	mv	a0,s7
    80002958:	00000097          	auipc	ra,0x0
    8000295c:	b82080e7          	jalr	-1150(ra) # 800024da <update_inode>
    }
    return n;
}
    80002960:	8566                	mv	a0,s9
    80002962:	60e6                	ld	ra,88(sp)
    80002964:	6446                	ld	s0,80(sp)
    80002966:	64a6                	ld	s1,72(sp)
    80002968:	6906                	ld	s2,64(sp)
    8000296a:	79e2                	ld	s3,56(sp)
    8000296c:	7a42                	ld	s4,48(sp)
    8000296e:	7aa2                	ld	s5,40(sp)
    80002970:	7b02                	ld	s6,32(sp)
    80002972:	6be2                	ld	s7,24(sp)
    80002974:	6c42                	ld	s8,16(sp)
    80002976:	6ca2                	ld	s9,8(sp)
    80002978:	6125                	addi	sp,sp,96
    8000297a:	8082                	ret
        return -1;
    8000297c:	5cfd                	li	s9,-1
    8000297e:	b7cd                	j	80002960 <write_inode+0xd0>
    80002980:	5cfd                	li	s9,-1
    80002982:	bff9                	j	80002960 <write_inode+0xd0>
        return -1;
    80002984:	5cfd                	li	s9,-1
    80002986:	bfe9                	j	80002960 <write_inode+0xd0>
    return n;
    80002988:	4c81                	li	s9,0
    8000298a:	bfd9                	j	80002960 <write_inode+0xd0>

000000008000298c <namecmp>:
// 目录层
// 第一个inode为根目录，该目录在mkfs/makefs下创建
//

int namecmp(const char *s, const char *t)
{
    8000298c:	1141                	addi	sp,sp,-16
    8000298e:	e406                	sd	ra,8(sp)
    80002990:	e022                	sd	s0,0(sp)
    80002992:	0800                	addi	s0,sp,16
    return strncmp(s, t, DIRSIZ);
    80002994:	4639                	li	a2,14
    80002996:	fffff097          	auipc	ra,0xfffff
    8000299a:	fba080e7          	jalr	-70(ra) # 80001950 <strncmp>
}
    8000299e:	60a2                	ld	ra,8(sp)
    800029a0:	6402                	ld	s0,0(sp)
    800029a2:	0141                	addi	sp,sp,16
    800029a4:	8082                	ret

00000000800029a6 <dirlookup>:
//  dirlookup 在一个目录中搜索一个带有给定名称的条目。如果找到
// 了，它返回一个指向相应 inode 的指针，解锁该 inode，并将*poff
// 设置为目录中条目的字节偏移量，以便调用者编辑它。
//
struct inode* dirlookup(struct inode *dp, char *name, uint *poff)
{
    800029a6:	715d                	addi	sp,sp,-80
    800029a8:	e486                	sd	ra,72(sp)
    800029aa:	e0a2                	sd	s0,64(sp)
    800029ac:	fc26                	sd	s1,56(sp)
    800029ae:	f84a                	sd	s2,48(sp)
    800029b0:	f44e                	sd	s3,40(sp)
    800029b2:	f052                	sd	s4,32(sp)
    800029b4:	ec56                	sd	s5,24(sp)
    800029b6:	0880                	addi	s0,sp,80
    800029b8:	892a                	mv	s2,a0
    800029ba:	89ae                	mv	s3,a1
    800029bc:	8ab2                	mv	s5,a2
    uint off, inum;
    struct direntry de;

    if(dp->type != T_DIR)
    800029be:	04451703          	lh	a4,68(a0)
    800029c2:	4785                	li	a5,1
    800029c4:	00f71b63          	bne	a4,a5,800029da <dirlookup+0x34>
        panic("dirlookup not DIR");

    for(off = 0; off < dp->size; off += sizeof(de)){
    800029c8:	04c92783          	lw	a5,76(s2)
    800029cc:	c7d9                	beqz	a5,80002a5a <dirlookup+0xb4>
    800029ce:	4481                	li	s1,0
        if(read_inode(dp, (uint64)&de, off, sizeof(de)) != sizeof(de))
            panic("dirlookup read");
    800029d0:	00001a17          	auipc	s4,0x1
    800029d4:	cc8a0a13          	addi	s4,s4,-824 # 80003698 <digits+0x660>
    800029d8:	a02d                	j	80002a02 <dirlookup+0x5c>
        panic("dirlookup not DIR");
    800029da:	00001517          	auipc	a0,0x1
    800029de:	ca650513          	addi	a0,a0,-858 # 80003680 <digits+0x648>
    800029e2:	ffffe097          	auipc	ra,0xffffe
    800029e6:	d22080e7          	jalr	-734(ra) # 80000704 <panic>
    800029ea:	bff9                	j	800029c8 <dirlookup+0x22>
            panic("dirlookup read");
    800029ec:	8552                	mv	a0,s4
    800029ee:	ffffe097          	auipc	ra,0xffffe
    800029f2:	d16080e7          	jalr	-746(ra) # 80000704 <panic>
    800029f6:	a015                	j	80002a1a <dirlookup+0x74>
    for(off = 0; off < dp->size; off += sizeof(de)){
    800029f8:	24c1                	addiw	s1,s1,16
    800029fa:	04c92783          	lw	a5,76(s2)
    800029fe:	04f4f463          	bgeu	s1,a5,80002a46 <dirlookup+0xa0>
        if(read_inode(dp, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002a02:	46c1                	li	a3,16
    80002a04:	8626                	mv	a2,s1
    80002a06:	fb040593          	addi	a1,s0,-80
    80002a0a:	854a                	mv	a0,s2
    80002a0c:	00000097          	auipc	ra,0x0
    80002a10:	dba080e7          	jalr	-582(ra) # 800027c6 <read_inode>
    80002a14:	47c1                	li	a5,16
    80002a16:	fcf51be3          	bne	a0,a5,800029ec <dirlookup+0x46>
        if(de.inum == 0)
    80002a1a:	fb045783          	lhu	a5,-80(s0)
    80002a1e:	dfe9                	beqz	a5,800029f8 <dirlookup+0x52>
            continue;
        if(namecmp(name, de.name) == 0){
    80002a20:	fb240593          	addi	a1,s0,-78
    80002a24:	854e                	mv	a0,s3
    80002a26:	00000097          	auipc	ra,0x0
    80002a2a:	f66080e7          	jalr	-154(ra) # 8000298c <namecmp>
    80002a2e:	f569                	bnez	a0,800029f8 <dirlookup+0x52>
            // 该目录包含该该名称
            if(poff)
    80002a30:	000a8463          	beqz	s5,80002a38 <dirlookup+0x92>
                *poff = off;
    80002a34:	009aa023          	sw	s1,0(s5)
            inum = de.inum;
            return get_inode(inum);
    80002a38:	fb045503          	lhu	a0,-80(s0)
    80002a3c:	00000097          	auipc	ra,0x0
    80002a40:	b2a080e7          	jalr	-1238(ra) # 80002566 <get_inode>
    80002a44:	a011                	j	80002a48 <dirlookup+0xa2>
        }
    }

    return 0;
    80002a46:	4501                	li	a0,0
}
    80002a48:	60a6                	ld	ra,72(sp)
    80002a4a:	6406                	ld	s0,64(sp)
    80002a4c:	74e2                	ld	s1,56(sp)
    80002a4e:	7942                	ld	s2,48(sp)
    80002a50:	79a2                	ld	s3,40(sp)
    80002a52:	7a02                	ld	s4,32(sp)
    80002a54:	6ae2                	ld	s5,24(sp)
    80002a56:	6161                	addi	sp,sp,80
    80002a58:	8082                	ret
    return 0;
    80002a5a:	4501                	li	a0,0
    80002a5c:	b7f5                	j	80002a48 <dirlookup+0xa2>

0000000080002a5e <dirlink>:

// dirlink会在当前目录 dp中,通过给定的名称和 inode号创建一个新的目录项。
// 如果名称已经存在，dirlink 将返回一个错误
int dirlink(struct inode *dp, char *name, uint inum) {
    80002a5e:	715d                	addi	sp,sp,-80
    80002a60:	e486                	sd	ra,72(sp)
    80002a62:	e0a2                	sd	s0,64(sp)
    80002a64:	fc26                	sd	s1,56(sp)
    80002a66:	f84a                	sd	s2,48(sp)
    80002a68:	f44e                	sd	s3,40(sp)
    80002a6a:	f052                	sd	s4,32(sp)
    80002a6c:	ec56                	sd	s5,24(sp)
    80002a6e:	e85a                	sd	s6,16(sp)
    80002a70:	0880                	addi	s0,sp,80
    80002a72:	89aa                	mv	s3,a0
    80002a74:	8b2e                	mv	s6,a1
    80002a76:	8ab2                	mv	s5,a2
    int off;
    struct direntry de;
    struct inode *ip;

    // 检查该name是否存在
    if((ip = dirlookup(dp, name, 0)) != 0){
    80002a78:	4601                	li	a2,0
    80002a7a:	00000097          	auipc	ra,0x0
    80002a7e:	f2c080e7          	jalr	-212(ra) # 800029a6 <dirlookup>
    80002a82:	ed21                	bnez	a0,80002ada <dirlink+0x7c>
        putback_inode(ip);
        return -1;
    }

    // 寻找一个空的目录项
    for(off = 0; off < dp->size; off += sizeof(de)){
    80002a84:	04c9a783          	lw	a5,76(s3)
    80002a88:	4481                	li	s1,0
    80002a8a:	4901                	li	s2,0
        if(read_inode(dp, (uint64)&de, off, sizeof(de)) != sizeof(de))
            panic("dirlink read");
    80002a8c:	00001a17          	auipc	s4,0x1
    80002a90:	c1ca0a13          	addi	s4,s4,-996 # 800036a8 <digits+0x670>
    for(off = 0; off < dp->size; off += sizeof(de)){
    80002a94:	ebb5                	bnez	a5,80002b08 <dirlink+0xaa>
        if(de.inum == 0)
            break;
    }
    strncpy(de.name, name, DIRSIZ);
    80002a96:	4639                	li	a2,14
    80002a98:	85da                	mv	a1,s6
    80002a9a:	fb240513          	addi	a0,s0,-78
    80002a9e:	fffff097          	auipc	ra,0xfffff
    80002aa2:	e74080e7          	jalr	-396(ra) # 80001912 <strncpy>
    de.inum = inum;
    80002aa6:	fb541823          	sh	s5,-80(s0)
    if(write_inode(dp, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002aaa:	46c1                	li	a3,16
    80002aac:	8626                	mv	a2,s1
    80002aae:	fb040593          	addi	a1,s0,-80
    80002ab2:	854e                	mv	a0,s3
    80002ab4:	00000097          	auipc	ra,0x0
    80002ab8:	ddc080e7          	jalr	-548(ra) # 80002890 <write_inode>
    80002abc:	872a                	mv	a4,a0
    80002abe:	47c1                	li	a5,16
        panic("dirlink");

    return 0;
    80002ac0:	4501                	li	a0,0
    if(write_inode(dp, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002ac2:	06f71063          	bne	a4,a5,80002b22 <dirlink+0xc4>
}
    80002ac6:	60a6                	ld	ra,72(sp)
    80002ac8:	6406                	ld	s0,64(sp)
    80002aca:	74e2                	ld	s1,56(sp)
    80002acc:	7942                	ld	s2,48(sp)
    80002ace:	79a2                	ld	s3,40(sp)
    80002ad0:	7a02                	ld	s4,32(sp)
    80002ad2:	6ae2                	ld	s5,24(sp)
    80002ad4:	6b42                	ld	s6,16(sp)
    80002ad6:	6161                	addi	sp,sp,80
    80002ad8:	8082                	ret
        putback_inode(ip);
    80002ada:	00000097          	auipc	ra,0x0
    80002ade:	c5c080e7          	jalr	-932(ra) # 80002736 <putback_inode>
        return -1;
    80002ae2:	557d                	li	a0,-1
    80002ae4:	b7cd                	j	80002ac6 <dirlink+0x68>
            panic("dirlink read");
    80002ae6:	8552                	mv	a0,s4
    80002ae8:	ffffe097          	auipc	ra,0xffffe
    80002aec:	c1c080e7          	jalr	-996(ra) # 80000704 <panic>
        if(de.inum == 0)
    80002af0:	fb045783          	lhu	a5,-80(s0)
    80002af4:	d3cd                	beqz	a5,80002a96 <dirlink+0x38>
    for(off = 0; off < dp->size; off += sizeof(de)){
    80002af6:	0109079b          	addiw	a5,s2,16
    80002afa:	0007891b          	sext.w	s2,a5
    80002afe:	84ca                	mv	s1,s2
    80002b00:	04c9a783          	lw	a5,76(s3)
    80002b04:	f8f979e3          	bgeu	s2,a5,80002a96 <dirlink+0x38>
        if(read_inode(dp, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002b08:	46c1                	li	a3,16
    80002b0a:	864a                	mv	a2,s2
    80002b0c:	fb040593          	addi	a1,s0,-80
    80002b10:	854e                	mv	a0,s3
    80002b12:	00000097          	auipc	ra,0x0
    80002b16:	cb4080e7          	jalr	-844(ra) # 800027c6 <read_inode>
    80002b1a:	47c1                	li	a5,16
    80002b1c:	fcf50ae3          	beq	a0,a5,80002af0 <dirlink+0x92>
    80002b20:	b7d9                	j	80002ae6 <dirlink+0x88>
        panic("dirlink");
    80002b22:	00001517          	auipc	a0,0x1
    80002b26:	b9650513          	addi	a0,a0,-1130 # 800036b8 <digits+0x680>
    80002b2a:	ffffe097          	auipc	ra,0xffffe
    80002b2e:	bda080e7          	jalr	-1062(ra) # 80000704 <panic>
    return 0;
    80002b32:	4501                	li	a0,0
    80002b34:	bf49                	j	80002ac6 <dirlink+0x68>

0000000080002b36 <init_buf>:
#define BUFFER_NUM 100

struct buf buf_cache[BUFFER_NUM];
struct spinlock cache_lock;

void init_buf() {
    80002b36:	7179                	addi	sp,sp,-48
    80002b38:	f406                	sd	ra,40(sp)
    80002b3a:	f022                	sd	s0,32(sp)
    80002b3c:	ec26                	sd	s1,24(sp)
    80002b3e:	e84a                	sd	s2,16(sp)
    80002b40:	e44e                	sd	s3,8(sp)
    80002b42:	1800                	addi	s0,sp,48
    spinlock_init(&cache_lock, "cache lock");
    80002b44:	00001597          	auipc	a1,0x1
    80002b48:	b7c58593          	addi	a1,a1,-1156 # 800036c0 <digits+0x688>
    80002b4c:	00050517          	auipc	a0,0x50
    80002b50:	f7450513          	addi	a0,a0,-140 # 80052ac0 <cache_lock>
    80002b54:	00000097          	auipc	ra,0x0
    80002b58:	19e080e7          	jalr	414(ra) # 80002cf2 <spinlock_init>
    80002b5c:	06400493          	li	s1,100
    for (int i = 0; i < BUFFER_NUM; i++) {
        sleeplock_init(&buf_cache->lock, "buf");
    80002b60:	00001997          	auipc	s3,0x1
    80002b64:	b7098993          	addi	s3,s3,-1168 # 800036d0 <digits+0x698>
    80002b68:	00050917          	auipc	s2,0x50
    80002b6c:	f8890913          	addi	s2,s2,-120 # 80052af0 <buf_cache+0x18>
    80002b70:	85ce                	mv	a1,s3
    80002b72:	854a                	mv	a0,s2
    80002b74:	00000097          	auipc	ra,0x0
    80002b78:	33e080e7          	jalr	830(ra) # 80002eb2 <sleeplock_init>
    for (int i = 0; i < BUFFER_NUM; i++) {
    80002b7c:	34fd                	addiw	s1,s1,-1
    80002b7e:	f8ed                	bnez	s1,80002b70 <init_buf+0x3a>
    }
}
    80002b80:	70a2                	ld	ra,40(sp)
    80002b82:	7402                	ld	s0,32(sp)
    80002b84:	64e2                	ld	s1,24(sp)
    80002b86:	6942                	ld	s2,16(sp)
    80002b88:	69a2                	ld	s3,8(sp)
    80002b8a:	6145                	addi	sp,sp,48
    80002b8c:	8082                	ret

0000000080002b8e <alloc_buf>:
extern uint64 ticks;


// 申请使用一个缓冲区，该缓冲区会被锁定
// 先进先出算法
struct buf *alloc_buf(int dev, int blockno) {
    80002b8e:	7179                	addi	sp,sp,-48
    80002b90:	f406                	sd	ra,40(sp)
    80002b92:	f022                	sd	s0,32(sp)
    80002b94:	ec26                	sd	s1,24(sp)
    80002b96:	e84a                	sd	s2,16(sp)
    80002b98:	e44e                	sd	s3,8(sp)
    80002b9a:	e052                	sd	s4,0(sp)
    80002b9c:	1800                	addi	s0,sp,48
    80002b9e:	8a2a                	mv	s4,a0
    80002ba0:	892e                	mv	s2,a1
    struct buf *b;
    struct buf *earliest = 0;
    spin_lock(&cache_lock);
    80002ba2:	00050517          	auipc	a0,0x50
    80002ba6:	f1e50513          	addi	a0,a0,-226 # 80052ac0 <cache_lock>
    80002baa:	00000097          	auipc	ra,0x0
    80002bae:	1d8080e7          	jalr	472(ra) # 80002d82 <spin_lock>
    struct buf *earliest = 0;
    80002bb2:	4981                	li	s3,0
    for (b = buf_cache; b < buf_cache + BUFFER_NUM; b++) {
    80002bb4:	00050497          	auipc	s1,0x50
    80002bb8:	f2448493          	addi	s1,s1,-220 # 80052ad8 <buf_cache>
        if (b->refcnt == 0 &&
            (earliest == 0 || b->last_use_tick < earliest->last_use_tick)) {
            earliest = b;
        }
        if (b->blockno == blockno) {
    80002bbc:	2901                	sext.w	s2,s2
    for (b = buf_cache; b < buf_cache + BUFFER_NUM; b++) {
    80002bbe:	0006b717          	auipc	a4,0x6b
    80002bc2:	e5a70713          	addi	a4,a4,-422 # 8006da18 <buf_cache+0x1af40>
    80002bc6:	a809                	j	80002bd8 <alloc_buf+0x4a>
    80002bc8:	89a6                	mv	s3,s1
        if (b->blockno == blockno) {
    80002bca:	44dc                	lw	a5,12(s1)
    80002bcc:	03278163          	beq	a5,s2,80002bee <alloc_buf+0x60>
    for (b = buf_cache; b < buf_cache + BUFFER_NUM; b++) {
    80002bd0:	45048493          	addi	s1,s1,1104
    80002bd4:	04e48c63          	beq	s1,a4,80002c2c <alloc_buf+0x9e>
        if (b->refcnt == 0 &&
    80002bd8:	44bc                	lw	a5,72(s1)
    80002bda:	fbe5                	bnez	a5,80002bca <alloc_buf+0x3c>
    80002bdc:	fe0986e3          	beqz	s3,80002bc8 <alloc_buf+0x3a>
            (earliest == 0 || b->last_use_tick < earliest->last_use_tick)) {
    80002be0:	6894                	ld	a3,16(s1)
    80002be2:	0109b783          	ld	a5,16(s3)
    80002be6:	fef6f2e3          	bgeu	a3,a5,80002bca <alloc_buf+0x3c>
    80002bea:	89a6                	mv	s3,s1
    80002bec:	bff9                	j	80002bca <alloc_buf+0x3c>
            spin_unlock(&cache_lock);
    80002bee:	00050517          	auipc	a0,0x50
    80002bf2:	ed250513          	addi	a0,a0,-302 # 80052ac0 <cache_lock>
    80002bf6:	00000097          	auipc	ra,0x0
    80002bfa:	260080e7          	jalr	608(ra) # 80002e56 <spin_unlock>
            b->refcnt++;
    80002bfe:	44bc                	lw	a5,72(s1)
    80002c00:	2785                	addiw	a5,a5,1
    80002c02:	c4bc                	sw	a5,72(s1)
            b->last_use_tick = ticks;
    80002c04:	00001797          	auipc	a5,0x1
    80002c08:	40c7b783          	ld	a5,1036(a5) # 80004010 <ticks>
    80002c0c:	e89c                	sd	a5,16(s1)
            sleep_lock(&b->lock);
    80002c0e:	01848513          	addi	a0,s1,24
    80002c12:	00000097          	auipc	ra,0x0
    80002c16:	2da080e7          	jalr	730(ra) # 80002eec <sleep_lock>
    b->refcnt = 1;
    b->blockno = blockno;
    b->dev = dev;
    b->last_use_tick = ticks;
    return b;
}
    80002c1a:	8526                	mv	a0,s1
    80002c1c:	70a2                	ld	ra,40(sp)
    80002c1e:	7402                	ld	s0,32(sp)
    80002c20:	64e2                	ld	s1,24(sp)
    80002c22:	6942                	ld	s2,16(sp)
    80002c24:	69a2                	ld	s3,8(sp)
    80002c26:	6a02                	ld	s4,0(sp)
    80002c28:	6145                	addi	sp,sp,48
    80002c2a:	8082                	ret
    spin_unlock(&cache_lock);
    80002c2c:	00050517          	auipc	a0,0x50
    80002c30:	e9450513          	addi	a0,a0,-364 # 80052ac0 <cache_lock>
    80002c34:	00000097          	auipc	ra,0x0
    80002c38:	222080e7          	jalr	546(ra) # 80002e56 <spin_unlock>
    if (earliest == 0) {
    80002c3c:	02098363          	beqz	s3,80002c62 <alloc_buf+0xd4>
    b->valid = 0;
    80002c40:	0009a023          	sw	zero,0(s3)
    b->refcnt = 1;
    80002c44:	4785                	li	a5,1
    80002c46:	04f9a423          	sw	a5,72(s3)
    b->blockno = blockno;
    80002c4a:	0129a623          	sw	s2,12(s3)
    b->dev = dev;
    80002c4e:	0149a423          	sw	s4,8(s3)
    b->last_use_tick = ticks;
    80002c52:	00001797          	auipc	a5,0x1
    80002c56:	3be7b783          	ld	a5,958(a5) # 80004010 <ticks>
    80002c5a:	00f9b823          	sd	a5,16(s3)
    return b;
    80002c5e:	84ce                	mv	s1,s3
    80002c60:	bf6d                	j	80002c1a <alloc_buf+0x8c>
        panic("alloc buf");
    80002c62:	00001517          	auipc	a0,0x1
    80002c66:	a7650513          	addi	a0,a0,-1418 # 800036d8 <digits+0x6a0>
    80002c6a:	ffffe097          	auipc	ra,0xffffe
    80002c6e:	a9a080e7          	jalr	-1382(ra) # 80000704 <panic>
    80002c72:	b7f9                	j	80002c40 <alloc_buf+0xb2>

0000000080002c74 <buf_read>:
//    spin_unlock(&cache_lock);
    sleep_unlock(&b->lock);
}

// 读取给定块的内容，返回一个包含该内容的buf
struct buf *buf_read(int dev, int blockno) {
    80002c74:	1101                	addi	sp,sp,-32
    80002c76:	ec06                	sd	ra,24(sp)
    80002c78:	e822                	sd	s0,16(sp)
    80002c7a:	e426                	sd	s1,8(sp)
    80002c7c:	1000                	addi	s0,sp,32
    struct buf *b = alloc_buf(dev, blockno);
    80002c7e:	00000097          	auipc	ra,0x0
    80002c82:	f10080e7          	jalr	-240(ra) # 80002b8e <alloc_buf>
    80002c86:	84aa                	mv	s1,a0
    if (!b->valid) {
    80002c88:	411c                	lw	a5,0(a0)
    80002c8a:	cb89                	beqz	a5,80002c9c <buf_read+0x28>
        virtio_disk_rw(b, 0);
    }
    b->valid = 1;
    80002c8c:	4785                	li	a5,1
    80002c8e:	c09c                	sw	a5,0(s1)
    return b;
}
    80002c90:	8526                	mv	a0,s1
    80002c92:	60e2                	ld	ra,24(sp)
    80002c94:	6442                	ld	s0,16(sp)
    80002c96:	64a2                	ld	s1,8(sp)
    80002c98:	6105                	addi	sp,sp,32
    80002c9a:	8082                	ret
        virtio_disk_rw(b, 0);
    80002c9c:	4581                	li	a1,0
    80002c9e:	fffff097          	auipc	ra,0xfffff
    80002ca2:	0f2080e7          	jalr	242(ra) # 80001d90 <virtio_disk_rw>
    80002ca6:	b7dd                	j	80002c8c <buf_read+0x18>

0000000080002ca8 <buf_write>:

// 将缓冲区写入磁盘
void buf_write(struct buf *b) {
    80002ca8:	1141                	addi	sp,sp,-16
    80002caa:	e406                	sd	ra,8(sp)
    80002cac:	e022                	sd	s0,0(sp)
    80002cae:	0800                	addi	s0,sp,16
    virtio_disk_rw(b, 1);
    80002cb0:	4585                	li	a1,1
    80002cb2:	fffff097          	auipc	ra,0xfffff
    80002cb6:	0de080e7          	jalr	222(ra) # 80001d90 <virtio_disk_rw>
}
    80002cba:	60a2                	ld	ra,8(sp)
    80002cbc:	6402                	ld	s0,0(sp)
    80002cbe:	0141                	addi	sp,sp,16
    80002cc0:	8082                	ret

0000000080002cc2 <relse_buf>:
void relse_buf(struct buf *b) {
    80002cc2:	1101                	addi	sp,sp,-32
    80002cc4:	ec06                	sd	ra,24(sp)
    80002cc6:	e822                	sd	s0,16(sp)
    80002cc8:	e426                	sd	s1,8(sp)
    80002cca:	1000                	addi	s0,sp,32
    80002ccc:	84aa                	mv	s1,a0
    b->refcnt--;
    80002cce:	453c                	lw	a5,72(a0)
    80002cd0:	37fd                	addiw	a5,a5,-1
    80002cd2:	c53c                	sw	a5,72(a0)
    buf_write(b);
    80002cd4:	00000097          	auipc	ra,0x0
    80002cd8:	fd4080e7          	jalr	-44(ra) # 80002ca8 <buf_write>
    sleep_unlock(&b->lock);
    80002cdc:	01848513          	addi	a0,s1,24
    80002ce0:	00000097          	auipc	ra,0x0
    80002ce4:	262080e7          	jalr	610(ra) # 80002f42 <sleep_unlock>
}
    80002ce8:	60e2                	ld	ra,24(sp)
    80002cea:	6442                	ld	s0,16(sp)
    80002cec:	64a2                	ld	s1,8(sp)
    80002cee:	6105                	addi	sp,sp,32
    80002cf0:	8082                	ret

0000000080002cf2 <spinlock_init>:
#include "lock.h"
#include "../process.h"
#include "../riscv.h"
#include "../defs.h"

void spinlock_init(struct spinlock *lk, char *name) {
    80002cf2:	1141                	addi	sp,sp,-16
    80002cf4:	e422                	sd	s0,8(sp)
    80002cf6:	0800                	addi	s0,sp,16
    lk->cpu = 0;
    80002cf8:	00053423          	sd	zero,8(a0)
    lk->name = name;
    80002cfc:	e90c                	sd	a1,16(a0)
    lk->locked = 0;
    80002cfe:	00052023          	sw	zero,0(a0)
}
    80002d02:	6422                	ld	s0,8(sp)
    80002d04:	0141                	addi	sp,sp,16
    80002d06:	8082                	ret

0000000080002d08 <spin_holding>:

// 检查当前cpu是否持有这个锁
// 需要关中断
int spin_holding(struct spinlock *lk) {
    int r;
    r = (lk->locked && lk->cpu == mycpu());
    80002d08:	411c                	lw	a5,0(a0)
    80002d0a:	e399                	bnez	a5,80002d10 <spin_holding+0x8>
    80002d0c:	4501                	li	a0,0
    return r;
}
    80002d0e:	8082                	ret
int spin_holding(struct spinlock *lk) {
    80002d10:	1101                	addi	sp,sp,-32
    80002d12:	ec06                	sd	ra,24(sp)
    80002d14:	e822                	sd	s0,16(sp)
    80002d16:	e426                	sd	s1,8(sp)
    80002d18:	1000                	addi	s0,sp,32
    r = (lk->locked && lk->cpu == mycpu());
    80002d1a:	6504                	ld	s1,8(a0)
    80002d1c:	ffffe097          	auipc	ra,0xffffe
    80002d20:	07c080e7          	jalr	124(ra) # 80000d98 <mycpu>
    80002d24:	40a48533          	sub	a0,s1,a0
    80002d28:	00153513          	seqz	a0,a0
}
    80002d2c:	60e2                	ld	ra,24(sp)
    80002d2e:	6442                	ld	s0,16(sp)
    80002d30:	64a2                	ld	s1,8(sp)
    80002d32:	6105                	addi	sp,sp,32
    80002d34:	8082                	ret

0000000080002d36 <push_off>:

// push_off/pop_off 和 intr_off/intr_on 差不多，只是使得
// 开关中断可以嵌套使用。
void push_off(void) {
    80002d36:	1101                	addi	sp,sp,-32
    80002d38:	ec06                	sd	ra,24(sp)
    80002d3a:	e822                	sd	s0,16(sp)
    80002d3c:	e426                	sd	s1,8(sp)
    80002d3e:	1000                	addi	s0,sp,32

static inline uint64
r_sstatus()
{
  uint64 x;
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d40:	100024f3          	csrr	s1,sstatus
    80002d44:	100027f3          	csrr	a5,sstatus

// disable device interrupts
static inline void
intr_off()
{
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002d48:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002d4a:	10079073          	csrw	sstatus,a5
    int old = intr_get();
    intr_off();
    if (mycpu()->noff == 0)
    80002d4e:	ffffe097          	auipc	ra,0xffffe
    80002d52:	04a080e7          	jalr	74(ra) # 80000d98 <mycpu>
    80002d56:	5d3c                	lw	a5,120(a0)
    80002d58:	cf89                	beqz	a5,80002d72 <push_off+0x3c>
        mycpu()->intr_enable = old;
    mycpu()->noff += 1;
    80002d5a:	ffffe097          	auipc	ra,0xffffe
    80002d5e:	03e080e7          	jalr	62(ra) # 80000d98 <mycpu>
    80002d62:	5d3c                	lw	a5,120(a0)
    80002d64:	2785                	addiw	a5,a5,1
    80002d66:	dd3c                	sw	a5,120(a0)
}
    80002d68:	60e2                	ld	ra,24(sp)
    80002d6a:	6442                	ld	s0,16(sp)
    80002d6c:	64a2                	ld	s1,8(sp)
    80002d6e:	6105                	addi	sp,sp,32
    80002d70:	8082                	ret
        mycpu()->intr_enable = old;
    80002d72:	ffffe097          	auipc	ra,0xffffe
    80002d76:	026080e7          	jalr	38(ra) # 80000d98 <mycpu>
// are device interrupts enabled?
static inline int
intr_get()
{
  uint64 x = r_sstatus();
  return (x & SSTATUS_SIE) != 0;
    80002d7a:	8085                	srli	s1,s1,0x1
    80002d7c:	8885                	andi	s1,s1,1
    80002d7e:	dd64                	sw	s1,124(a0)
    80002d80:	bfe9                	j	80002d5a <push_off+0x24>

0000000080002d82 <spin_lock>:
void spin_lock(struct spinlock *lk) {
    80002d82:	1101                	addi	sp,sp,-32
    80002d84:	ec06                	sd	ra,24(sp)
    80002d86:	e822                	sd	s0,16(sp)
    80002d88:	e426                	sd	s1,8(sp)
    80002d8a:	1000                	addi	s0,sp,32
    80002d8c:	84aa                	mv	s1,a0
    push_off(); // 禁用中断以避免死锁。
    80002d8e:	00000097          	auipc	ra,0x0
    80002d92:	fa8080e7          	jalr	-88(ra) # 80002d36 <push_off>
    if (spin_holding(lk)){
    80002d96:	8526                	mv	a0,s1
    80002d98:	00000097          	auipc	ra,0x0
    80002d9c:	f70080e7          	jalr	-144(ra) # 80002d08 <spin_holding>
    80002da0:	e11d                	bnez	a0,80002dc6 <spin_lock+0x44>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0);
    80002da2:	4705                	li	a4,1
    80002da4:	87ba                	mv	a5,a4
    80002da6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80002daa:	2781                	sext.w	a5,a5
    80002dac:	ffe5                	bnez	a5,80002da4 <spin_lock+0x22>
    __sync_synchronize();
    80002dae:	0ff0000f          	fence
    lk->cpu = mycpu();
    80002db2:	ffffe097          	auipc	ra,0xffffe
    80002db6:	fe6080e7          	jalr	-26(ra) # 80000d98 <mycpu>
    80002dba:	e488                	sd	a0,8(s1)
}
    80002dbc:	60e2                	ld	ra,24(sp)
    80002dbe:	6442                	ld	s0,16(sp)
    80002dc0:	64a2                	ld	s1,8(sp)
    80002dc2:	6105                	addi	sp,sp,32
    80002dc4:	8082                	ret
        printf("lock=%s",lk->name);
    80002dc6:	688c                	ld	a1,16(s1)
    80002dc8:	00001517          	auipc	a0,0x1
    80002dcc:	92050513          	addi	a0,a0,-1760 # 800036e8 <digits+0x6b0>
    80002dd0:	ffffd097          	auipc	ra,0xffffd
    80002dd4:	702080e7          	jalr	1794(ra) # 800004d2 <printf>
        panic("re-acquire");
    80002dd8:	00001517          	auipc	a0,0x1
    80002ddc:	91850513          	addi	a0,a0,-1768 # 800036f0 <digits+0x6b8>
    80002de0:	ffffe097          	auipc	ra,0xffffe
    80002de4:	924080e7          	jalr	-1756(ra) # 80000704 <panic>
    80002de8:	bf6d                	j	80002da2 <spin_lock+0x20>

0000000080002dea <pop_off>:

void pop_off(void) {
    80002dea:	1101                	addi	sp,sp,-32
    80002dec:	ec06                	sd	ra,24(sp)
    80002dee:	e822                	sd	s0,16(sp)
    80002df0:	e426                	sd	s1,8(sp)
    80002df2:	1000                	addi	s0,sp,32
    struct cpu *c = mycpu();
    80002df4:	ffffe097          	auipc	ra,0xffffe
    80002df8:	fa4080e7          	jalr	-92(ra) # 80000d98 <mycpu>
    80002dfc:	84aa                	mv	s1,a0
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002dfe:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002e02:	8b89                	andi	a5,a5,2
    if (intr_get())
    80002e04:	e79d                	bnez	a5,80002e32 <pop_off+0x48>
        panic("pop_off - interruptible");
    if (c->noff < 1)
    80002e06:	5cbc                	lw	a5,120(s1)
    80002e08:	02f05e63          	blez	a5,80002e44 <pop_off+0x5a>
        panic("pop_off");
    c->noff -= 1;
    80002e0c:	5cbc                	lw	a5,120(s1)
    80002e0e:	37fd                	addiw	a5,a5,-1
    80002e10:	0007871b          	sext.w	a4,a5
    80002e14:	dcbc                	sw	a5,120(s1)
    if (c->noff == 0 && c->intr_enable)
    80002e16:	eb09                	bnez	a4,80002e28 <pop_off+0x3e>
    80002e18:	5cfc                	lw	a5,124(s1)
    80002e1a:	c799                	beqz	a5,80002e28 <pop_off+0x3e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e1c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002e20:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002e24:	10079073          	csrw	sstatus,a5
        intr_on();
}
    80002e28:	60e2                	ld	ra,24(sp)
    80002e2a:	6442                	ld	s0,16(sp)
    80002e2c:	64a2                	ld	s1,8(sp)
    80002e2e:	6105                	addi	sp,sp,32
    80002e30:	8082                	ret
        panic("pop_off - interruptible");
    80002e32:	00001517          	auipc	a0,0x1
    80002e36:	8ce50513          	addi	a0,a0,-1842 # 80003700 <digits+0x6c8>
    80002e3a:	ffffe097          	auipc	ra,0xffffe
    80002e3e:	8ca080e7          	jalr	-1846(ra) # 80000704 <panic>
    80002e42:	b7d1                	j	80002e06 <pop_off+0x1c>
        panic("pop_off");
    80002e44:	00001517          	auipc	a0,0x1
    80002e48:	8d450513          	addi	a0,a0,-1836 # 80003718 <digits+0x6e0>
    80002e4c:	ffffe097          	auipc	ra,0xffffe
    80002e50:	8b8080e7          	jalr	-1864(ra) # 80000704 <panic>
    80002e54:	bf65                	j	80002e0c <pop_off+0x22>

0000000080002e56 <spin_unlock>:
void spin_unlock(struct spinlock *lk) {
    80002e56:	1101                	addi	sp,sp,-32
    80002e58:	ec06                	sd	ra,24(sp)
    80002e5a:	e822                	sd	s0,16(sp)
    80002e5c:	e426                	sd	s1,8(sp)
    80002e5e:	1000                	addi	s0,sp,32
    80002e60:	84aa                	mv	s1,a0
    if (!spin_holding(lk)){
    80002e62:	00000097          	auipc	ra,0x0
    80002e66:	ea6080e7          	jalr	-346(ra) # 80002d08 <spin_holding>
    80002e6a:	c115                	beqz	a0,80002e8e <spin_unlock+0x38>
    lk->cpu = 0;
    80002e6c:	0004b423          	sd	zero,8(s1)
    __sync_synchronize();
    80002e70:	0ff0000f          	fence
    __sync_lock_release(&lk->locked);
    80002e74:	0f50000f          	fence	iorw,ow
    80002e78:	0804a02f          	amoswap.w	zero,zero,(s1)
    pop_off();
    80002e7c:	00000097          	auipc	ra,0x0
    80002e80:	f6e080e7          	jalr	-146(ra) # 80002dea <pop_off>
}
    80002e84:	60e2                	ld	ra,24(sp)
    80002e86:	6442                	ld	s0,16(sp)
    80002e88:	64a2                	ld	s1,8(sp)
    80002e8a:	6105                	addi	sp,sp,32
    80002e8c:	8082                	ret
        printf("%s\n", lk->name);
    80002e8e:	688c                	ld	a1,16(s1)
    80002e90:	00000517          	auipc	a0,0x0
    80002e94:	19050513          	addi	a0,a0,400 # 80003020 <sleep_holding+0x9a>
    80002e98:	ffffd097          	auipc	ra,0xffffd
    80002e9c:	63a080e7          	jalr	1594(ra) # 800004d2 <printf>
        panic("release");
    80002ea0:	00001517          	auipc	a0,0x1
    80002ea4:	88050513          	addi	a0,a0,-1920 # 80003720 <digits+0x6e8>
    80002ea8:	ffffe097          	auipc	ra,0xffffe
    80002eac:	85c080e7          	jalr	-1956(ra) # 80000704 <panic>
    80002eb0:	bf75                	j	80002e6c <spin_unlock+0x16>

0000000080002eb2 <sleeplock_init>:
#include "../process.h"
#include "../riscv.h"
#include "../defs.h"

void sleeplock_init(struct sleeplock* lk, char* name)
{
    80002eb2:	1101                	addi	sp,sp,-32
    80002eb4:	ec06                	sd	ra,24(sp)
    80002eb6:	e822                	sd	s0,16(sp)
    80002eb8:	e426                	sd	s1,8(sp)
    80002eba:	e04a                	sd	s2,0(sp)
    80002ebc:	1000                	addi	s0,sp,32
    80002ebe:	84aa                	mv	s1,a0
    80002ec0:	892e                	mv	s2,a1
  spinlock_init(&lk->lk, "sleep lock");
    80002ec2:	00001597          	auipc	a1,0x1
    80002ec6:	86658593          	addi	a1,a1,-1946 # 80003728 <digits+0x6f0>
    80002eca:	0521                	addi	a0,a0,8
    80002ecc:	00000097          	auipc	ra,0x0
    80002ed0:	e26080e7          	jalr	-474(ra) # 80002cf2 <spinlock_init>
  lk->name = name;
    80002ed4:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80002ed8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80002edc:	0204a423          	sw	zero,40(s1)
}
    80002ee0:	60e2                	ld	ra,24(sp)
    80002ee2:	6442                	ld	s0,16(sp)
    80002ee4:	64a2                	ld	s1,8(sp)
    80002ee6:	6902                	ld	s2,0(sp)
    80002ee8:	6105                	addi	sp,sp,32
    80002eea:	8082                	ret

0000000080002eec <sleep_lock>:

void sleep_lock(struct sleeplock* lk)
{
    80002eec:	1101                	addi	sp,sp,-32
    80002eee:	ec06                	sd	ra,24(sp)
    80002ef0:	e822                	sd	s0,16(sp)
    80002ef2:	e426                	sd	s1,8(sp)
    80002ef4:	e04a                	sd	s2,0(sp)
    80002ef6:	1000                	addi	s0,sp,32
    80002ef8:	84aa                	mv	s1,a0
  spin_lock(&lk->lk);
    80002efa:	00850913          	addi	s2,a0,8
    80002efe:	854a                	mv	a0,s2
    80002f00:	00000097          	auipc	ra,0x0
    80002f04:	e82080e7          	jalr	-382(ra) # 80002d82 <spin_lock>
  while (lk->locked) {
    80002f08:	409c                	lw	a5,0(s1)
    80002f0a:	cb89                	beqz	a5,80002f1c <sleep_lock+0x30>
    sleep(lk, &lk->lk);
    80002f0c:	85ca                	mv	a1,s2
    80002f0e:	8526                	mv	a0,s1
    80002f10:	ffffe097          	auipc	ra,0xffffe
    80002f14:	fa8080e7          	jalr	-88(ra) # 80000eb8 <sleep>
  while (lk->locked) {
    80002f18:	409c                	lw	a5,0(s1)
    80002f1a:	fbed                	bnez	a5,80002f0c <sleep_lock+0x20>
  }
  lk->locked = 1;
    80002f1c:	4785                	li	a5,1
    80002f1e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80002f20:	ffffe097          	auipc	ra,0xffffe
    80002f24:	e94080e7          	jalr	-364(ra) # 80000db4 <myproc>
    80002f28:	511c                	lw	a5,32(a0)
    80002f2a:	d49c                	sw	a5,40(s1)
  spin_unlock(&lk->lk);
    80002f2c:	854a                	mv	a0,s2
    80002f2e:	00000097          	auipc	ra,0x0
    80002f32:	f28080e7          	jalr	-216(ra) # 80002e56 <spin_unlock>
}
    80002f36:	60e2                	ld	ra,24(sp)
    80002f38:	6442                	ld	s0,16(sp)
    80002f3a:	64a2                	ld	s1,8(sp)
    80002f3c:	6902                	ld	s2,0(sp)
    80002f3e:	6105                	addi	sp,sp,32
    80002f40:	8082                	ret

0000000080002f42 <sleep_unlock>:

void sleep_unlock(struct sleeplock* lk)
{
    80002f42:	1101                	addi	sp,sp,-32
    80002f44:	ec06                	sd	ra,24(sp)
    80002f46:	e822                	sd	s0,16(sp)
    80002f48:	e426                	sd	s1,8(sp)
    80002f4a:	e04a                	sd	s2,0(sp)
    80002f4c:	1000                	addi	s0,sp,32
    80002f4e:	84aa                	mv	s1,a0
  spin_lock(&lk->lk);
    80002f50:	00850913          	addi	s2,a0,8
    80002f54:	854a                	mv	a0,s2
    80002f56:	00000097          	auipc	ra,0x0
    80002f5a:	e2c080e7          	jalr	-468(ra) # 80002d82 <spin_lock>
  lk->locked = 0;
    80002f5e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80002f62:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80002f66:	8526                	mv	a0,s1
    80002f68:	ffffe097          	auipc	ra,0xffffe
    80002f6c:	05c080e7          	jalr	92(ra) # 80000fc4 <wakeup>
  spin_unlock(&lk->lk);
    80002f70:	854a                	mv	a0,s2
    80002f72:	00000097          	auipc	ra,0x0
    80002f76:	ee4080e7          	jalr	-284(ra) # 80002e56 <spin_unlock>
}
    80002f7a:	60e2                	ld	ra,24(sp)
    80002f7c:	6442                	ld	s0,16(sp)
    80002f7e:	64a2                	ld	s1,8(sp)
    80002f80:	6902                	ld	s2,0(sp)
    80002f82:	6105                	addi	sp,sp,32
    80002f84:	8082                	ret

0000000080002f86 <sleep_holding>:

int sleep_holding(struct sleeplock* lk)
{
    80002f86:	7179                	addi	sp,sp,-48
    80002f88:	f406                	sd	ra,40(sp)
    80002f8a:	f022                	sd	s0,32(sp)
    80002f8c:	ec26                	sd	s1,24(sp)
    80002f8e:	e84a                	sd	s2,16(sp)
    80002f90:	e44e                	sd	s3,8(sp)
    80002f92:	1800                	addi	s0,sp,48
    80002f94:	84aa                	mv	s1,a0
  int r;
  spin_lock(&lk->lk);
    80002f96:	00850913          	addi	s2,a0,8
    80002f9a:	854a                	mv	a0,s2
    80002f9c:	00000097          	auipc	ra,0x0
    80002fa0:	de6080e7          	jalr	-538(ra) # 80002d82 <spin_lock>
  r = lk->locked && (lk->pid == myproc()->pid);
    80002fa4:	409c                	lw	a5,0(s1)
    80002fa6:	ef99                	bnez	a5,80002fc4 <sleep_holding+0x3e>
    80002fa8:	4481                	li	s1,0
  spin_unlock(&lk->lk);
    80002faa:	854a                	mv	a0,s2
    80002fac:	00000097          	auipc	ra,0x0
    80002fb0:	eaa080e7          	jalr	-342(ra) # 80002e56 <spin_unlock>
  return r;
}
    80002fb4:	8526                	mv	a0,s1
    80002fb6:	70a2                	ld	ra,40(sp)
    80002fb8:	7402                	ld	s0,32(sp)
    80002fba:	64e2                	ld	s1,24(sp)
    80002fbc:	6942                	ld	s2,16(sp)
    80002fbe:	69a2                	ld	s3,8(sp)
    80002fc0:	6145                	addi	sp,sp,48
    80002fc2:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80002fc4:	0284a983          	lw	s3,40(s1)
    80002fc8:	ffffe097          	auipc	ra,0xffffe
    80002fcc:	dec080e7          	jalr	-532(ra) # 80000db4 <myproc>
    80002fd0:	5104                	lw	s1,32(a0)
    80002fd2:	413484b3          	sub	s1,s1,s3
    80002fd6:	0014b493          	seqz	s1,s1
    80002fda:	bfc1                	j	80002faa <sleep_holding+0x24>
	...
