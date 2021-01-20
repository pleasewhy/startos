
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00005117          	auipc	sp,0x5
    80000004:	12010113          	addi	sp,sp,288 # 80005120 <stack0>
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
    8000004a:	00005717          	auipc	a4,0x5
    8000004e:	fd670713          	addi	a4,a4,-42 # 80005020 <mscratch0>
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
    80000060:	ae478793          	addi	a5,a5,-1308 # 80000b40 <timervec>
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
    80000094:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <buf_cache+0xffffffff7ffaad27>
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
    800000fc:	00004517          	auipc	a0,0x4
    80000100:	41450513          	addi	a0,a0,1044 # 80004510 <digits+0x4c0>
    80000104:	00000097          	auipc	ra,0x0
    80000108:	3ce080e7          	jalr	974(ra) # 800004d2 <printf>
    printf("xv6 kernel is booting\n");
    8000010c:	00004517          	auipc	a0,0x4
    80000110:	ef450513          	addi	a0,a0,-268 # 80004000 <sleep_holding+0xc42>
    80000114:	00000097          	auipc	ra,0x0
    80000118:	3be080e7          	jalr	958(ra) # 800004d2 <printf>
    printf("\n");
    8000011c:	00004517          	auipc	a0,0x4
    80000120:	3f450513          	addi	a0,a0,1012 # 80004510 <digits+0x4c0>
    80000124:	00000097          	auipc	ra,0x0
    80000128:	3ae080e7          	jalr	942(ra) # 800004d2 <printf>
    trapinit();             // 初始化trap
    8000012c:	00000097          	auipc	ra,0x0
    80000130:	682080e7          	jalr	1666(ra) # 800007ae <trapinit>
    plicinit();             // 初始化plic
    80000134:	00001097          	auipc	ra,0x1
    80000138:	84c080e7          	jalr	-1972(ra) # 80000980 <plicinit>
    plicinithart();
    8000013c:	00001097          	auipc	ra,0x1
    80000140:	85a080e7          	jalr	-1958(ra) # 80000996 <plicinithart>
    virtio_disk_init();     // 初始化磁盘
    80000144:	00002097          	auipc	ra,0x2
    80000148:	b34080e7          	jalr	-1228(ra) # 80001c78 <virtio_disk_init>
    init_inode_cache();     // 初始化inode cache
    8000014c:	00002097          	auipc	ra,0x2
    80000150:	386080e7          	jalr	902(ra) # 800024d2 <init_inode_cache>
    init_buf();          // 初始化磁盘块缓冲
    80000154:	00003097          	auipc	ra,0x3
    80000158:	df8080e7          	jalr	-520(ra) # 80002f4c <init_buf>
    init_process_table();   // 初始化进程表
    8000015c:	00001097          	auipc	ra,0x1
    80000160:	b84080e7          	jalr	-1148(ra) # 80000ce0 <init_process_table>
    init_first_process();   // 初始化第一个进程
    80000164:	00001097          	auipc	ra,0x1
    80000168:	c60080e7          	jalr	-928(ra) # 80000dc4 <init_first_process>
    scheduler();
    8000016c:	00001097          	auipc	ra,0x1
    80000170:	f18080e7          	jalr	-232(ra) # 80001084 <scheduler>
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
    80000252:	00004517          	auipc	a0,0x4
    80000256:	dfe50513          	addi	a0,a0,-514 # 80004050 <digits>
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
    80000320:	00004b17          	auipc	s6,0x4
    80000324:	d30b0b13          	addi	s6,s6,-720 # 80004050 <digits>
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
    8000044e:	00004497          	auipc	s1,0x4
    80000452:	bca48493          	addi	s1,s1,-1078 # 80004018 <sleep_holding+0xc5a>
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
    80000512:	00004517          	auipc	a0,0x4
    80000516:	b0e50513          	addi	a0,a0,-1266 # 80004020 <sleep_holding+0xc62>
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
    80000552:	00006497          	auipc	s1,0x6
    80000556:	bce48493          	addi	s1,s1,-1074 # 80006120 <consloe_buf>
    8000055a:	8526                	mv	a0,s1
    8000055c:	00003097          	auipc	ra,0x3
    80000560:	c5e080e7          	jalr	-930(ra) # 800031ba <spin_lock>
    sleep(&consloe_buf, &consloe_buf.lock);
    80000564:	85a6                	mv	a1,s1
    80000566:	8526                	mv	a0,s1
    80000568:	00001097          	auipc	ra,0x1
    8000056c:	9d6080e7          	jalr	-1578(ra) # 80000f3e <sleep>
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
    800005aa:	00006517          	auipc	a0,0x6
    800005ae:	b7650513          	addi	a0,a0,-1162 # 80006120 <consloe_buf>
    800005b2:	00003097          	auipc	ra,0x3
    800005b6:	cdc080e7          	jalr	-804(ra) # 8000328e <spin_unlock>
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
    800005ca:	00006517          	auipc	a0,0x6
    800005ce:	b5650513          	addi	a0,a0,-1194 # 80006120 <consloe_buf>
    800005d2:	2785                	addiw	a5,a5,1
    800005d4:	0ef52023          	sw	a5,224(a0)
            s[cnt - 1] = 0;
    800005d8:	96ca                	add	a3,a3,s2
    800005da:	fe068fa3          	sb	zero,-1(a3)
            spin_unlock(&consloe_buf.lock);
    800005de:	00003097          	auipc	ra,0x3
    800005e2:	cb0080e7          	jalr	-848(ra) # 8000328e <spin_unlock>
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
    80000644:	00006717          	auipc	a4,0x6
    80000648:	adc70713          	addi	a4,a4,-1316 # 80006120 <consloe_buf>
    8000064c:	0e472783          	lw	a5,228(a4)
    80000650:	0e072703          	lw	a4,224(a4)
    80000654:	02f70763          	beq	a4,a5,80000682 <console_intr+0x58>
            consloe_buf.write_index--;
    80000658:	37fd                	addiw	a5,a5,-1
    8000065a:	00006717          	auipc	a4,0x6
    8000065e:	baf72523          	sw	a5,-1110(a4) # 80006204 <consloe_buf+0xe4>
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
    8000067e:	1d2080e7          	jalr	466(ra) # 8000184c <print_proc>
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
    8000069a:	00006797          	auipc	a5,0x6
    8000069e:	a8678793          	addi	a5,a5,-1402 # 80006120 <consloe_buf>
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
    800006ce:	00006797          	auipc	a5,0x6
    800006d2:	a5278793          	addi	a5,a5,-1454 # 80006120 <consloe_buf>
    800006d6:	0e47a703          	lw	a4,228(a5)
    800006da:	0017069b          	addiw	a3,a4,1
    800006de:	0ed7a223          	sw	a3,228(a5)
    800006e2:	0c800693          	li	a3,200
    800006e6:	02d7673b          	remw	a4,a4,a3
    800006ea:	97ba                	add	a5,a5,a4
    800006ec:	4729                	li	a4,10
    800006ee:	00e78c23          	sb	a4,24(a5)
            wakeup(&consloe_buf);
    800006f2:	00006517          	auipc	a0,0x6
    800006f6:	a2e50513          	addi	a0,a0,-1490 # 80006120 <consloe_buf>
    800006fa:	00001097          	auipc	ra,0x1
    800006fe:	950080e7          	jalr	-1712(ra) # 8000104a <wakeup>
}
    80000702:	b741                	j	80000682 <console_intr+0x58>

0000000080000704 <backtrace>:

void backtrace()
{
    80000704:	7179                	addi	sp,sp,-48
    80000706:	f406                	sd	ra,40(sp)
    80000708:	f022                	sd	s0,32(sp)
    8000070a:	ec26                	sd	s1,24(sp)
    8000070c:	e84a                	sd	s2,16(sp)
    8000070e:	e44e                	sd	s3,8(sp)
    80000710:	e052                	sd	s4,0(sp)
    80000712:	1800                	addi	s0,sp,48
    asm volatile("mv %0, s0" : "=r" (x) );
    80000714:	84a2                	mv	s1,s0
    uint64 s0 = r_fp();
    uint64 stack_top = PGROUNDUP(s0);
    80000716:	6905                	lui	s2,0x1
    80000718:	197d                	addi	s2,s2,-1
    8000071a:	9926                	add	s2,s2,s1
    8000071c:	79fd                	lui	s3,0xfffff
    8000071e:	01397933          	and	s2,s2,s3
    uint64 stack_bottom = PGROUNDDOWN(s0);
    80000722:	0134f9b3          	and	s3,s1,s3
    uint64 fp = s0;

    printf("backtrace:\n");
    80000726:	00004517          	auipc	a0,0x4
    8000072a:	90250513          	addi	a0,a0,-1790 # 80004028 <sleep_holding+0xc6a>
    8000072e:	00000097          	auipc	ra,0x0
    80000732:	da4080e7          	jalr	-604(ra) # 800004d2 <printf>
    while (fp != stack_top && fp != stack_bottom)
    80000736:	02990563          	beq	s2,s1,80000760 <backtrace+0x5c>
    8000073a:	02998363          	beq	s3,s1,80000760 <backtrace+0x5c>
    {
        printf("%p\n", *(uint64*)(fp - 8));
    8000073e:	00004a17          	auipc	s4,0x4
    80000742:	8faa0a13          	addi	s4,s4,-1798 # 80004038 <sleep_holding+0xc7a>
    80000746:	ff84b583          	ld	a1,-8(s1)
    8000074a:	8552                	mv	a0,s4
    8000074c:	00000097          	auipc	ra,0x0
    80000750:	d86080e7          	jalr	-634(ra) # 800004d2 <printf>
        fp = *(uint64*)(fp - 16);
    80000754:	ff04b483          	ld	s1,-16(s1)
    while (fp != stack_top && fp != stack_bottom)
    80000758:	00990463          	beq	s2,s1,80000760 <backtrace+0x5c>
    8000075c:	fe9995e3          	bne	s3,s1,80000746 <backtrace+0x42>
    }
}
    80000760:	70a2                	ld	ra,40(sp)
    80000762:	7402                	ld	s0,32(sp)
    80000764:	64e2                	ld	s1,24(sp)
    80000766:	6942                	ld	s2,16(sp)
    80000768:	69a2                	ld	s3,8(sp)
    8000076a:	6a02                	ld	s4,0(sp)
    8000076c:	6145                	addi	sp,sp,48
    8000076e:	8082                	ret

0000000080000770 <panic>:

void panic(char* s)
{
    80000770:	1141                	addi	sp,sp,-16
    80000772:	e406                	sd	ra,8(sp)
    80000774:	e022                	sd	s0,0(sp)
    80000776:	0800                	addi	s0,sp,16
    80000778:	85aa                	mv	a1,a0
    printf("panic:%s", s);
    8000077a:	00004517          	auipc	a0,0x4
    8000077e:	8c650513          	addi	a0,a0,-1850 # 80004040 <sleep_holding+0xc82>
    80000782:	00000097          	auipc	ra,0x0
    80000786:	d50080e7          	jalr	-688(ra) # 800004d2 <printf>
    backtrace();
    8000078a:	00000097          	auipc	ra,0x0
    8000078e:	f7a080e7          	jalr	-134(ra) # 80000704 <backtrace>
    for (;;) {
    80000792:	a001                	j	80000792 <panic+0x22>

0000000080000794 <proc_err>:

//
// 处理进程error的情况
// 中断处理程序检测到错误将会返回到这里
//
void proc_err() {
    80000794:	1141                	addi	sp,sp,-16
    80000796:	e406                	sd	ra,8(sp)
    80000798:	e022                	sd	s0,0(sp)
    8000079a:	0800                	addi	s0,sp,16
    exit(-1);
    8000079c:	557d                	li	a0,-1
    8000079e:	00001097          	auipc	ra,0x1
    800007a2:	aba080e7          	jalr	-1350(ra) # 80001258 <exit>
}
    800007a6:	60a2                	ld	ra,8(sp)
    800007a8:	6402                	ld	s0,0(sp)
    800007aa:	0141                	addi	sp,sp,16
    800007ac:	8082                	ret

00000000800007ae <trapinit>:
void trapinit(void) {
    800007ae:	1141                	addi	sp,sp,-16
    800007b0:	e422                	sd	s0,8(sp)
    800007b2:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800007b4:	00000797          	auipc	a5,0x0
    800007b8:	26c78793          	addi	a5,a5,620 # 80000a20 <kernelvec>
    800007bc:	10579073          	csrw	stvec,a5
}
    800007c0:	6422                	ld	s0,8(sp)
    800007c2:	0141                	addi	sp,sp,16
    800007c4:	8082                	ret

00000000800007c6 <clockintr>:
    w_sepc(sepc);
    w_sstatus(sstatus);
}

// 定时器中断处理程序
void clockintr() {
    800007c6:	1101                	addi	sp,sp,-32
    800007c8:	ec06                	sd	ra,24(sp)
    800007ca:	e822                	sd	s0,16(sp)
    800007cc:	e426                	sd	s1,8(sp)
    800007ce:	e04a                	sd	s2,0(sp)
    800007d0:	1000                	addi	s0,sp,32
    spin_lock(&ticks_lock);
    800007d2:	00006917          	auipc	s2,0x6
    800007d6:	a3690913          	addi	s2,s2,-1482 # 80006208 <ticks_lock>
    800007da:	854a                	mv	a0,s2
    800007dc:	00003097          	auipc	ra,0x3
    800007e0:	9de080e7          	jalr	-1570(ra) # 800031ba <spin_lock>
    ticks++;
    800007e4:	00005497          	auipc	s1,0x5
    800007e8:	82c48493          	addi	s1,s1,-2004 # 80005010 <ticks>
    800007ec:	609c                	ld	a5,0(s1)
    800007ee:	0785                	addi	a5,a5,1
    800007f0:	e09c                	sd	a5,0(s1)
    spin_unlock(&ticks_lock);
    800007f2:	854a                	mv	a0,s2
    800007f4:	00003097          	auipc	ra,0x3
    800007f8:	a9a080e7          	jalr	-1382(ra) # 8000328e <spin_unlock>
    wakeup(&ticks);
    800007fc:	8526                	mv	a0,s1
    800007fe:	00001097          	auipc	ra,0x1
    80000802:	84c080e7          	jalr	-1972(ra) # 8000104a <wakeup>
}
    80000806:	60e2                	ld	ra,24(sp)
    80000808:	6442                	ld	s0,16(sp)
    8000080a:	64a2                	ld	s1,8(sp)
    8000080c:	6902                	ld	s2,0(sp)
    8000080e:	6105                	addi	sp,sp,32
    80000810:	8082                	ret

0000000080000812 <device_intr>:
// 设备中断处理程序
// 用于判断中断是否为外部和软件中断，并处理它
// 2: 时钟中断
// 1: 其他设备中断
// 0: 无法识别的中断
int device_intr() {
    80000812:	1101                	addi	sp,sp,-32
    80000814:	ec06                	sd	ra,24(sp)
    80000816:	e822                	sd	s0,16(sp)
    80000818:	e426                	sd	s1,8(sp)
    8000081a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000081c:	14202773          	csrr	a4,scause
    uint64 scause = r_scause();

    if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80000820:	00074d63          	bltz	a4,8000083a <device_intr+0x28>
        // 告诉PLIC该设备现在被允许再次抛出中断
        if (irq)
            plic_complete(irq);

        return 1;
    } else if (scause == 0x8000000000000001L) {
    80000824:	57fd                	li	a5,-1
    80000826:	17fe                	slli	a5,a5,0x3f
    80000828:	0785                	addi	a5,a5,1
        }
        // 告知以收到软件中断，通过清除sip的SSIP位
        w_sip(r_sip() & ~2);
        return 2;
    } else {
        return 0;
    8000082a:	4501                	li	a0,0
    } else if (scause == 0x8000000000000001L) {
    8000082c:	06f70363          	beq	a4,a5,80000892 <device_intr+0x80>
    }
}
    80000830:	60e2                	ld	ra,24(sp)
    80000832:	6442                	ld	s0,16(sp)
    80000834:	64a2                	ld	s1,8(sp)
    80000836:	6105                	addi	sp,sp,32
    80000838:	8082                	ret
    if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    8000083a:	0ff77793          	andi	a5,a4,255
    8000083e:	46a5                	li	a3,9
    80000840:	fed792e3          	bne	a5,a3,80000824 <device_intr+0x12>
        int irq = plic_claim();
    80000844:	00000097          	auipc	ra,0x0
    80000848:	18a080e7          	jalr	394(ra) # 800009ce <plic_claim>
    8000084c:	84aa                	mv	s1,a0
        if (irq == UART0_IRQ) {
    8000084e:	47a9                	li	a5,10
    80000850:	02f50763          	beq	a0,a5,8000087e <device_intr+0x6c>
        } else if (irq == VIRTIO0_IRQ) {
    80000854:	4785                	li	a5,1
    80000856:	02f50963          	beq	a0,a5,80000888 <device_intr+0x76>
        return 1;
    8000085a:	4505                	li	a0,1
        } else if (irq) {
    8000085c:	d8f1                	beqz	s1,80000830 <device_intr+0x1e>
            panic("unexpected interrupt irq=%d\n", irq);
    8000085e:	85a6                	mv	a1,s1
    80000860:	00004517          	auipc	a0,0x4
    80000864:	80850513          	addi	a0,a0,-2040 # 80004068 <digits+0x18>
    80000868:	00000097          	auipc	ra,0x0
    8000086c:	f08080e7          	jalr	-248(ra) # 80000770 <panic>
            plic_complete(irq);
    80000870:	8526                	mv	a0,s1
    80000872:	00000097          	auipc	ra,0x0
    80000876:	180080e7          	jalr	384(ra) # 800009f2 <plic_complete>
        return 1;
    8000087a:	4505                	li	a0,1
    8000087c:	bf55                	j	80000830 <device_intr+0x1e>
            uart_intr();
    8000087e:	00000097          	auipc	ra,0x0
    80000882:	986080e7          	jalr	-1658(ra) # 80000204 <uart_intr>
    80000886:	b7ed                	j	80000870 <device_intr+0x5e>
            virtio_disk_intr();
    80000888:	00002097          	auipc	ra,0x2
    8000088c:	80e080e7          	jalr	-2034(ra) # 80002096 <virtio_disk_intr>
    80000890:	b7c5                	j	80000870 <device_intr+0x5e>
        if (cpuid() == 0) {
    80000892:	00000097          	auipc	ra,0x0
    80000896:	57c080e7          	jalr	1404(ra) # 80000e0e <cpuid>
    8000089a:	c901                	beqz	a0,800008aa <device_intr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    8000089c:	144027f3          	csrr	a5,sip
        w_sip(r_sip() & ~2);
    800008a0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    800008a2:	14479073          	csrw	sip,a5
        return 2;
    800008a6:	4509                	li	a0,2
    800008a8:	b761                	j	80000830 <device_intr+0x1e>
            clockintr();
    800008aa:	00000097          	auipc	ra,0x0
    800008ae:	f1c080e7          	jalr	-228(ra) # 800007c6 <clockintr>
    800008b2:	b7ed                	j	8000089c <device_intr+0x8a>

00000000800008b4 <kerneltrap>:
void kerneltrap() {
    800008b4:	7179                	addi	sp,sp,-48
    800008b6:	f406                	sd	ra,40(sp)
    800008b8:	f022                	sd	s0,32(sp)
    800008ba:	ec26                	sd	s1,24(sp)
    800008bc:	e84a                	sd	s2,16(sp)
    800008be:	e44e                	sd	s3,8(sp)
    800008c0:	e052                	sd	s4,0(sp)
    800008c2:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    800008c4:	00000097          	auipc	ra,0x0
    800008c8:	576080e7          	jalr	1398(ra) # 80000e3a <myproc>
    800008cc:	84aa                	mv	s1,a0
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800008ce:	141029f3          	csrr	s3,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800008d2:	10002973          	csrr	s2,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800008d6:	14202a73          	csrr	s4,scause
    if ((sstatus & SSTATUS_SPP) == 0)
    800008da:	10097793          	andi	a5,s2,256
    800008de:	cb8d                	beqz	a5,80000910 <kerneltrap+0x5c>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800008e0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800008e4:	8b89                	andi	a5,a5,2
    if (intr_get() != 0)
    800008e6:	ef95                	bnez	a5,80000922 <kerneltrap+0x6e>
    which_dev = device_intr();
    800008e8:	00000097          	auipc	ra,0x0
    800008ec:	f2a080e7          	jalr	-214(ra) # 80000812 <device_intr>
    if (which_dev == 0) { // 未知来源
    800008f0:	c131                	beqz	a0,80000934 <kerneltrap+0x80>
    } else if (which_dev == 2 && p != 0 && p->state == RUNNING) { // 时钟中断
    800008f2:	4789                	li	a5,2
    800008f4:	06f50863          	beq	a0,a5,80000964 <kerneltrap+0xb0>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800008f8:	14199073          	csrw	sepc,s3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800008fc:	10091073          	csrw	sstatus,s2
}
    80000900:	70a2                	ld	ra,40(sp)
    80000902:	7402                	ld	s0,32(sp)
    80000904:	64e2                	ld	s1,24(sp)
    80000906:	6942                	ld	s2,16(sp)
    80000908:	69a2                	ld	s3,8(sp)
    8000090a:	6a02                	ld	s4,0(sp)
    8000090c:	6145                	addi	sp,sp,48
    8000090e:	8082                	ret
        panic("kerneltrap: not from supervisor mode");
    80000910:	00003517          	auipc	a0,0x3
    80000914:	77850513          	addi	a0,a0,1912 # 80004088 <digits+0x38>
    80000918:	00000097          	auipc	ra,0x0
    8000091c:	e58080e7          	jalr	-424(ra) # 80000770 <panic>
    80000920:	b7c1                	j	800008e0 <kerneltrap+0x2c>
        panic("kerneltrap: interrupts enabled");
    80000922:	00003517          	auipc	a0,0x3
    80000926:	78e50513          	addi	a0,a0,1934 # 800040b0 <digits+0x60>
    8000092a:	00000097          	auipc	ra,0x0
    8000092e:	e46080e7          	jalr	-442(ra) # 80000770 <panic>
    80000932:	bf5d                	j	800008e8 <kerneltrap+0x34>
        printf("pid=%d error\n", p->pid);
    80000934:	508c                	lw	a1,32(s1)
    80000936:	00003517          	auipc	a0,0x3
    8000093a:	79a50513          	addi	a0,a0,1946 # 800040d0 <digits+0x80>
    8000093e:	00000097          	auipc	ra,0x0
    80000942:	b94080e7          	jalr	-1132(ra) # 800004d2 <printf>
        printf("scause=%d sepc=%p\n", scause, sepc);
    80000946:	864e                	mv	a2,s3
    80000948:	85d2                	mv	a1,s4
    8000094a:	00003517          	auipc	a0,0x3
    8000094e:	79650513          	addi	a0,a0,1942 # 800040e0 <digits+0x90>
    80000952:	00000097          	auipc	ra,0x0
    80000956:	b80080e7          	jalr	-1152(ra) # 800004d2 <printf>
        sepc = (uint64) proc_err; // 将异常的返回地址设置为proc_err
    8000095a:	00000997          	auipc	s3,0x0
    8000095e:	e3a98993          	addi	s3,s3,-454 # 80000794 <proc_err>
    80000962:	bf59                	j	800008f8 <kerneltrap+0x44>
    } else if (which_dev == 2 && p != 0 && p->state == RUNNING) { // 时钟中断
    80000964:	d8d1                	beqz	s1,800008f8 <kerneltrap+0x44>
    80000966:	4098                	lw	a4,0(s1)
    80000968:	478d                	li	a5,3
    8000096a:	f8f717e3          	bne	a4,a5,800008f8 <kerneltrap+0x44>
        trap_pc = sepc;
    8000096e:	00004797          	auipc	a5,0x4
    80000972:	6937bd23          	sd	s3,1690(a5) # 80005008 <trap_pc>
        sepc = (uint64) proc_sched;
    80000976:	00000997          	auipc	s3,0x0
    8000097a:	13a98993          	addi	s3,s3,314 # 80000ab0 <proc_sched>
    8000097e:	bfad                	j	800008f8 <kerneltrap+0x44>

0000000080000980 <plicinit>:
//


void
plicinit(void)
{
    80000980:	1141                	addi	sp,sp,-16
    80000982:	e422                	sd	s0,8(sp)
    80000984:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  // 设置IRQ的属性为非零
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80000986:	0c0007b7          	lui	a5,0xc000
    8000098a:	4705                	li	a4,1
    8000098c:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000098e:	c3d8                	sw	a4,4(a5)
}
    80000990:	6422                	ld	s0,8(sp)
    80000992:	0141                	addi	sp,sp,16
    80000994:	8082                	ret

0000000080000996 <plicinithart>:

void
plicinithart(void)
{
    80000996:	1141                	addi	sp,sp,-16
    80000998:	e406                	sd	ra,8(sp)
    8000099a:	e022                	sd	s0,0(sp)
    8000099c:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000099e:	00000097          	auipc	ra,0x0
    800009a2:	470080e7          	jalr	1136(ra) # 80000e0e <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800009a6:	0085171b          	slliw	a4,a0,0x8
    800009aa:	0c0027b7          	lui	a5,0xc002
    800009ae:	97ba                	add	a5,a5,a4
    800009b0:	40200713          	li	a4,1026
    800009b4:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800009b8:	00d5151b          	slliw	a0,a0,0xd
    800009bc:	0c2017b7          	lui	a5,0xc201
    800009c0:	953e                	add	a0,a0,a5
    800009c2:	00052023          	sw	zero,0(a0)
}
    800009c6:	60a2                	ld	ra,8(sp)
    800009c8:	6402                	ld	s0,0(sp)
    800009ca:	0141                	addi	sp,sp,16
    800009cc:	8082                	ret

00000000800009ce <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800009ce:	1141                	addi	sp,sp,-16
    800009d0:	e406                	sd	ra,8(sp)
    800009d2:	e022                	sd	s0,0(sp)
    800009d4:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800009d6:	00000097          	auipc	ra,0x0
    800009da:	438080e7          	jalr	1080(ra) # 80000e0e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800009de:	00d5179b          	slliw	a5,a0,0xd
    800009e2:	0c201537          	lui	a0,0xc201
    800009e6:	953e                	add	a0,a0,a5
  return irq;
}
    800009e8:	4148                	lw	a0,4(a0)
    800009ea:	60a2                	ld	ra,8(sp)
    800009ec:	6402                	ld	s0,0(sp)
    800009ee:	0141                	addi	sp,sp,16
    800009f0:	8082                	ret

00000000800009f2 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800009f2:	1101                	addi	sp,sp,-32
    800009f4:	ec06                	sd	ra,24(sp)
    800009f6:	e822                	sd	s0,16(sp)
    800009f8:	e426                	sd	s1,8(sp)
    800009fa:	1000                	addi	s0,sp,32
    800009fc:	84aa                	mv	s1,a0
  int hart = cpuid();
    800009fe:	00000097          	auipc	ra,0x0
    80000a02:	410080e7          	jalr	1040(ra) # 80000e0e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80000a06:	00d5151b          	slliw	a0,a0,0xd
    80000a0a:	0c2017b7          	lui	a5,0xc201
    80000a0e:	97aa                	add	a5,a5,a0
    80000a10:	c3c4                	sw	s1,4(a5)
}
    80000a12:	60e2                	ld	ra,24(sp)
    80000a14:	6442                	ld	s0,16(sp)
    80000a16:	64a2                	ld	s1,8(sp)
    80000a18:	6105                	addi	sp,sp,32
    80000a1a:	8082                	ret
    80000a1c:	0000                	unimp
	...

0000000080000a20 <kernelvec>:
    80000a20:	7111                	addi	sp,sp,-256
    80000a22:	e006                	sd	ra,0(sp)
    80000a24:	e40a                	sd	sp,8(sp)
    80000a26:	e80e                	sd	gp,16(sp)
    80000a28:	ec12                	sd	tp,24(sp)
    80000a2a:	f016                	sd	t0,32(sp)
    80000a2c:	f41a                	sd	t1,40(sp)
    80000a2e:	f81e                	sd	t2,48(sp)
    80000a30:	fc22                	sd	s0,56(sp)
    80000a32:	e0a6                	sd	s1,64(sp)
    80000a34:	e4aa                	sd	a0,72(sp)
    80000a36:	e8ae                	sd	a1,80(sp)
    80000a38:	ecb2                	sd	a2,88(sp)
    80000a3a:	f0b6                	sd	a3,96(sp)
    80000a3c:	f4ba                	sd	a4,104(sp)
    80000a3e:	f8be                	sd	a5,112(sp)
    80000a40:	fcc2                	sd	a6,120(sp)
    80000a42:	e146                	sd	a7,128(sp)
    80000a44:	e54a                	sd	s2,136(sp)
    80000a46:	e94e                	sd	s3,144(sp)
    80000a48:	ed52                	sd	s4,152(sp)
    80000a4a:	f156                	sd	s5,160(sp)
    80000a4c:	f55a                	sd	s6,168(sp)
    80000a4e:	f95e                	sd	s7,176(sp)
    80000a50:	fd62                	sd	s8,184(sp)
    80000a52:	e1e6                	sd	s9,192(sp)
    80000a54:	e5ea                	sd	s10,200(sp)
    80000a56:	e9ee                	sd	s11,208(sp)
    80000a58:	edf2                	sd	t3,216(sp)
    80000a5a:	f1f6                	sd	t4,224(sp)
    80000a5c:	f5fa                	sd	t5,232(sp)
    80000a5e:	f9fe                	sd	t6,240(sp)
    80000a60:	e55ff0ef          	jal	ra,800008b4 <kerneltrap>
    80000a64:	6082                	ld	ra,0(sp)
    80000a66:	6122                	ld	sp,8(sp)
    80000a68:	61c2                	ld	gp,16(sp)
    80000a6a:	6262                	ld	tp,24(sp)
    80000a6c:	7282                	ld	t0,32(sp)
    80000a6e:	7322                	ld	t1,40(sp)
    80000a70:	73c2                	ld	t2,48(sp)
    80000a72:	7462                	ld	s0,56(sp)
    80000a74:	6486                	ld	s1,64(sp)
    80000a76:	6526                	ld	a0,72(sp)
    80000a78:	65c6                	ld	a1,80(sp)
    80000a7a:	6666                	ld	a2,88(sp)
    80000a7c:	7686                	ld	a3,96(sp)
    80000a7e:	7726                	ld	a4,104(sp)
    80000a80:	77c6                	ld	a5,112(sp)
    80000a82:	7866                	ld	a6,120(sp)
    80000a84:	688a                	ld	a7,128(sp)
    80000a86:	692a                	ld	s2,136(sp)
    80000a88:	69ca                	ld	s3,144(sp)
    80000a8a:	6a6a                	ld	s4,152(sp)
    80000a8c:	7a8a                	ld	s5,160(sp)
    80000a8e:	7b2a                	ld	s6,168(sp)
    80000a90:	7bca                	ld	s7,176(sp)
    80000a92:	7c6a                	ld	s8,184(sp)
    80000a94:	6c8e                	ld	s9,192(sp)
    80000a96:	6d2e                	ld	s10,200(sp)
    80000a98:	6dce                	ld	s11,208(sp)
    80000a9a:	6e6e                	ld	t3,216(sp)
    80000a9c:	7e8e                	ld	t4,224(sp)
    80000a9e:	7f2e                	ld	t5,232(sp)
    80000aa0:	7fce                	ld	t6,240(sp)
    80000aa2:	6111                	addi	sp,sp,256
    80000aa4:	10200073          	sret
    80000aa8:	00000013          	nop
    80000aac:	00000013          	nop

0000000080000ab0 <proc_sched>:
    80000ab0:	7111                	addi	sp,sp,-256
    80000ab2:	e006                	sd	ra,0(sp)
    80000ab4:	e40a                	sd	sp,8(sp)
    80000ab6:	e80e                	sd	gp,16(sp)
    80000ab8:	ec12                	sd	tp,24(sp)
    80000aba:	f016                	sd	t0,32(sp)
    80000abc:	f41a                	sd	t1,40(sp)
    80000abe:	f81e                	sd	t2,48(sp)
    80000ac0:	fc22                	sd	s0,56(sp)
    80000ac2:	e0a6                	sd	s1,64(sp)
    80000ac4:	e4aa                	sd	a0,72(sp)
    80000ac6:	e8ae                	sd	a1,80(sp)
    80000ac8:	ecb2                	sd	a2,88(sp)
    80000aca:	f0b6                	sd	a3,96(sp)
    80000acc:	f4ba                	sd	a4,104(sp)
    80000ace:	f8be                	sd	a5,112(sp)
    80000ad0:	fcc2                	sd	a6,120(sp)
    80000ad2:	e146                	sd	a7,128(sp)
    80000ad4:	e54a                	sd	s2,136(sp)
    80000ad6:	e94e                	sd	s3,144(sp)
    80000ad8:	ed52                	sd	s4,152(sp)
    80000ada:	f156                	sd	s5,160(sp)
    80000adc:	f55a                	sd	s6,168(sp)
    80000ade:	f95e                	sd	s7,176(sp)
    80000ae0:	fd62                	sd	s8,184(sp)
    80000ae2:	e1e6                	sd	s9,192(sp)
    80000ae4:	e5ea                	sd	s10,200(sp)
    80000ae6:	e9ee                	sd	s11,208(sp)
    80000ae8:	edf2                	sd	t3,216(sp)
    80000aea:	f1f6                	sd	t4,224(sp)
    80000aec:	f5fa                	sd	t5,232(sp)
    80000aee:	f9fe                	sd	t6,240(sp)
    80000af0:	00a010ef          	jal	ra,80001afa <yield>
    80000af4:	6082                	ld	ra,0(sp)
    80000af6:	6122                	ld	sp,8(sp)
    80000af8:	61c2                	ld	gp,16(sp)
    80000afa:	6262                	ld	tp,24(sp)
    80000afc:	7282                	ld	t0,32(sp)
    80000afe:	7322                	ld	t1,40(sp)
    80000b00:	73c2                	ld	t2,48(sp)
    80000b02:	7462                	ld	s0,56(sp)
    80000b04:	6486                	ld	s1,64(sp)
    80000b06:	6526                	ld	a0,72(sp)
    80000b08:	65c6                	ld	a1,80(sp)
    80000b0a:	6666                	ld	a2,88(sp)
    80000b0c:	7686                	ld	a3,96(sp)
    80000b0e:	7726                	ld	a4,104(sp)
    80000b10:	77c6                	ld	a5,112(sp)
    80000b12:	7866                	ld	a6,120(sp)
    80000b14:	688a                	ld	a7,128(sp)
    80000b16:	692a                	ld	s2,136(sp)
    80000b18:	69ca                	ld	s3,144(sp)
    80000b1a:	6a6a                	ld	s4,152(sp)
    80000b1c:	7a8a                	ld	s5,160(sp)
    80000b1e:	7b2a                	ld	s6,168(sp)
    80000b20:	7bca                	ld	s7,176(sp)
    80000b22:	7c6a                	ld	s8,184(sp)
    80000b24:	6c8e                	ld	s9,192(sp)
    80000b26:	6d2e                	ld	s10,200(sp)
    80000b28:	6dce                	ld	s11,208(sp)
    80000b2a:	6e6e                	ld	t3,216(sp)
    80000b2c:	7e8e                	ld	t4,224(sp)
    80000b2e:	7f2e                	ld	t5,232(sp)
    80000b30:	7fce                	ld	t6,240(sp)
    80000b32:	6111                	addi	sp,sp,256
    80000b34:	00004297          	auipc	t0,0x4
    80000b38:	4d42b283          	ld	t0,1236(t0) # 80005008 <trap_pc>
    80000b3c:	8282                	jr	t0
    80000b3e:	0001                	nop

0000000080000b40 <timervec>:
    80000b40:	34051573          	csrrw	a0,mscratch,a0
    80000b44:	e10c                	sd	a1,0(a0)
    80000b46:	e510                	sd	a2,8(a0)
    80000b48:	e914                	sd	a3,16(a0)
    80000b4a:	710c                	ld	a1,32(a0)
    80000b4c:	7510                	ld	a2,40(a0)
    80000b4e:	6194                	ld	a3,0(a1)
    80000b50:	96b2                	add	a3,a3,a2
    80000b52:	e194                	sd	a3,0(a1)
    80000b54:	4589                	li	a1,2
    80000b56:	14459073          	csrw	sip,a1
    80000b5a:	6914                	ld	a3,16(a0)
    80000b5c:	6510                	ld	a2,8(a0)
    80000b5e:	610c                	ld	a1,0(a0)
    80000b60:	34051573          	csrrw	a0,mscratch,a0
    80000b64:	30200073          	mret

0000000080000b68 <execret>:
void execra(struct context *, struct context *, uint64);

extern void userret(uint64 fn, uint64 sp);

// exec返回函数, 该函数释放进程锁，并返回到需要执行的代码
void execret() {
    80000b68:	1101                	addi	sp,sp,-32
    80000b6a:	ec06                	sd	ra,24(sp)
    80000b6c:	e822                	sd	s0,16(sp)
    80000b6e:	e426                	sd	s1,8(sp)
    80000b70:	1000                	addi	s0,sp,32
  asm volatile("mv %0, tp" : "=r" (x) );
    80000b72:	8792                	mv	a5,tp
    return mycpu()->proc;
    80000b74:	2781                	sext.w	a5,a5
    80000b76:	079e                	slli	a5,a5,0x7
    80000b78:	00005717          	auipc	a4,0x5
    80000b7c:	6a870713          	addi	a4,a4,1704 # 80006220 <cpus>
    80000b80:	97ba                	add	a5,a5,a4
    80000b82:	6384                	ld	s1,0(a5)
    struct proc *p = myproc();
    spin_unlock(&p->proc_lock);
    80000b84:	14848513          	addi	a0,s1,328
    80000b88:	00002097          	auipc	ra,0x2
    80000b8c:	706080e7          	jalr	1798(ra) # 8000328e <spin_unlock>
    userret(p->trapframe.a0, p->context.sp);
    80000b90:	1784b583          	ld	a1,376(s1)
    80000b94:	6cc8                	ld	a0,152(s1)
    80000b96:	00001097          	auipc	ra,0x1
    80000b9a:	02a080e7          	jalr	42(ra) # 80001bc0 <userret>
}
    80000b9e:	60e2                	ld	ra,24(sp)
    80000ba0:	6442                	ld	s0,16(sp)
    80000ba2:	64a2                	ld	s1,8(sp)
    80000ba4:	6105                	addi	sp,sp,32
    80000ba6:	8082                	ret

0000000080000ba8 <strcpy>:
#include "kernel/types.h"

//string utils
char* strcpy(char* s, const char* t)
{
    80000ba8:	1141                	addi	sp,sp,-16
    80000baa:	e422                	sd	s0,8(sp)
    80000bac:	0800                	addi	s0,sp,16
    char* os;
    os = s;
    while ((*s++ = *t++) != 0)
    80000bae:	87aa                	mv	a5,a0
    80000bb0:	0585                	addi	a1,a1,1
    80000bb2:	0785                	addi	a5,a5,1
    80000bb4:	fff5c703          	lbu	a4,-1(a1)
    80000bb8:	fee78fa3          	sb	a4,-1(a5) # c200fff <_entry-0x73dff001>
    80000bbc:	fb75                	bnez	a4,80000bb0 <strcpy+0x8>
        ;
    return os;
}
    80000bbe:	6422                	ld	s0,8(sp)
    80000bc0:	0141                	addi	sp,sp,16
    80000bc2:	8082                	ret

0000000080000bc4 <strcmp>:

int strcmp(const char* p, const char* q)
{
    80000bc4:	1141                	addi	sp,sp,-16
    80000bc6:	e422                	sd	s0,8(sp)
    80000bc8:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
    80000bca:	00054783          	lbu	a5,0(a0) # c201000 <_entry-0x73dff000>
    80000bce:	cb91                	beqz	a5,80000be2 <strcmp+0x1e>
    80000bd0:	0005c703          	lbu	a4,0(a1)
    80000bd4:	00f71763          	bne	a4,a5,80000be2 <strcmp+0x1e>
        p++, q++;
    80000bd8:	0505                	addi	a0,a0,1
    80000bda:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
    80000bdc:	00054783          	lbu	a5,0(a0)
    80000be0:	fbe5                	bnez	a5,80000bd0 <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
    80000be2:	0005c503          	lbu	a0,0(a1)
}
    80000be6:	40a7853b          	subw	a0,a5,a0
    80000bea:	6422                	ld	s0,8(sp)
    80000bec:	0141                	addi	sp,sp,16
    80000bee:	8082                	ret

0000000080000bf0 <strchr>:

char* strchr(const char* s, char c)
{
    80000bf0:	1141                	addi	sp,sp,-16
    80000bf2:	e422                	sd	s0,8(sp)
    80000bf4:	0800                	addi	s0,sp,16
    for (; *s; s++)
    80000bf6:	00054783          	lbu	a5,0(a0)
    80000bfa:	cb99                	beqz	a5,80000c10 <strchr+0x20>
        if (*s == c)
    80000bfc:	00f58763          	beq	a1,a5,80000c0a <strchr+0x1a>
    for (; *s; s++)
    80000c00:	0505                	addi	a0,a0,1
    80000c02:	00054783          	lbu	a5,0(a0)
    80000c06:	fbfd                	bnez	a5,80000bfc <strchr+0xc>
            return (char*)s;
    return 0;
    80000c08:	4501                	li	a0,0
}
    80000c0a:	6422                	ld	s0,8(sp)
    80000c0c:	0141                	addi	sp,sp,16
    80000c0e:	8082                	ret
    return 0;
    80000c10:	4501                	li	a0,0
    80000c12:	bfe5                	j	80000c0a <strchr+0x1a>

0000000080000c14 <atoi>:
//     buf[i] = '\0';
//     return buf;
// }

int atoi(const char* s)
{
    80000c14:	1141                	addi	sp,sp,-16
    80000c16:	e422                	sd	s0,8(sp)
    80000c18:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
    80000c1a:	00054603          	lbu	a2,0(a0)
    80000c1e:	fd06079b          	addiw	a5,a2,-48
    80000c22:	0ff7f793          	andi	a5,a5,255
    80000c26:	4725                	li	a4,9
    80000c28:	02f76963          	bltu	a4,a5,80000c5a <atoi+0x46>
    80000c2c:	86aa                	mv	a3,a0
    n = 0;
    80000c2e:	4501                	li	a0,0
    while ('0' <= *s && *s <= '9')
    80000c30:	45a5                	li	a1,9
        n = n * 10 + *s++ - '0';
    80000c32:	0685                	addi	a3,a3,1
    80000c34:	0025179b          	slliw	a5,a0,0x2
    80000c38:	9fa9                	addw	a5,a5,a0
    80000c3a:	0017979b          	slliw	a5,a5,0x1
    80000c3e:	9fb1                	addw	a5,a5,a2
    80000c40:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
    80000c44:	0006c603          	lbu	a2,0(a3)
    80000c48:	fd06071b          	addiw	a4,a2,-48
    80000c4c:	0ff77713          	andi	a4,a4,255
    80000c50:	fee5f1e3          	bgeu	a1,a4,80000c32 <atoi+0x1e>
    return n;
}
    80000c54:	6422                	ld	s0,8(sp)
    80000c56:	0141                	addi	sp,sp,16
    80000c58:	8082                	ret
    n = 0;
    80000c5a:	4501                	li	a0,0
    80000c5c:	bfe5                	j	80000c54 <atoi+0x40>

0000000080000c5e <memcmp>:
//     }
//     return vdst;
// }

int memcmp(const void* s1, const void* s2, uint n)
{
    80000c5e:	1141                	addi	sp,sp,-16
    80000c60:	e422                	sd	s0,8(sp)
    80000c62:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0) {
    80000c64:	ca05                	beqz	a2,80000c94 <memcmp+0x36>
    80000c66:	fff6069b          	addiw	a3,a2,-1
    80000c6a:	1682                	slli	a3,a3,0x20
    80000c6c:	9281                	srli	a3,a3,0x20
    80000c6e:	0685                	addi	a3,a3,1
    80000c70:	96aa                	add	a3,a3,a0
        if (*p1 != *p2) {
    80000c72:	00054783          	lbu	a5,0(a0)
    80000c76:	0005c703          	lbu	a4,0(a1)
    80000c7a:	00e79863          	bne	a5,a4,80000c8a <memcmp+0x2c>
            return *p1 - *p2;
        }
        p1++;
    80000c7e:	0505                	addi	a0,a0,1
        p2++;
    80000c80:	0585                	addi	a1,a1,1
    while (n-- > 0) {
    80000c82:	fed518e3          	bne	a0,a3,80000c72 <memcmp+0x14>
    }
    return 0;
    80000c86:	4501                	li	a0,0
    80000c88:	a019                	j	80000c8e <memcmp+0x30>
            return *p1 - *p2;
    80000c8a:	40e7853b          	subw	a0,a5,a4
}
    80000c8e:	6422                	ld	s0,8(sp)
    80000c90:	0141                	addi	sp,sp,16
    80000c92:	8082                	ret
    return 0;
    80000c94:	4501                	li	a0,0
    80000c96:	bfe5                	j	80000c8e <memcmp+0x30>

0000000080000c98 <memcpy>:

void* memcpy(void* dst, const void* src, uint n)
{
    80000c98:	1141                	addi	sp,sp,-16
    80000c9a:	e406                	sd	ra,8(sp)
    80000c9c:	e022                	sd	s0,0(sp)
    80000c9e:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
    80000ca0:	00001097          	auipc	ra,0x1
    80000ca4:	c32080e7          	jalr	-974(ra) # 800018d2 <memmove>
}
    80000ca8:	60a2                	ld	ra,8(sp)
    80000caa:	6402                	ld	s0,0(sp)
    80000cac:	0141                	addi	sp,sp,16
    80000cae:	8082                	ret

0000000080000cb0 <min>:

//math utils
int min(int a, int b)
{
    80000cb0:	1141                	addi	sp,sp,-16
    80000cb2:	e422                	sd	s0,8(sp)
    80000cb4:	0800                	addi	s0,sp,16
    return a < b ? a : b;
    80000cb6:	87ae                	mv	a5,a1
    80000cb8:	00b55363          	bge	a0,a1,80000cbe <min+0xe>
    80000cbc:	87aa                	mv	a5,a0
}
    80000cbe:	0007851b          	sext.w	a0,a5
    80000cc2:	6422                	ld	s0,8(sp)
    80000cc4:	0141                	addi	sp,sp,16
    80000cc6:	8082                	ret

0000000080000cc8 <max>:
int max(int a, int b)
{
    80000cc8:	1141                	addi	sp,sp,-16
    80000cca:	e422                	sd	s0,8(sp)
    80000ccc:	0800                	addi	s0,sp,16
    return a > b ? a : b;
    80000cce:	87ae                	mv	a5,a1
    80000cd0:	00a5d363          	bge	a1,a0,80000cd6 <max+0xe>
    80000cd4:	87aa                	mv	a5,a0
}
    80000cd6:	0007851b          	sext.w	a0,a5
    80000cda:	6422                	ld	s0,8(sp)
    80000cdc:	0141                	addi	sp,sp,16
    80000cde:	8082                	ret

0000000080000ce0 <init_process_table>:
void init_process_table() {
    80000ce0:	7139                	addi	sp,sp,-64
    80000ce2:	fc06                	sd	ra,56(sp)
    80000ce4:	f822                	sd	s0,48(sp)
    80000ce6:	f426                	sd	s1,40(sp)
    80000ce8:	f04a                	sd	s2,32(sp)
    80000cea:	ec4e                	sd	s3,24(sp)
    80000cec:	e852                	sd	s4,16(sp)
    80000cee:	e456                	sd	s5,8(sp)
    80000cf0:	e05a                	sd	s6,0(sp)
    80000cf2:	0080                	addi	s0,sp,64
    for (int i = 0; i < NPROC; i++) {
    80000cf4:	00047497          	auipc	s1,0x47
    80000cf8:	83c48493          	addi	s1,s1,-1988 # 80047530 <proc_table+0x148>
    80000cfc:	00005997          	auipc	s3,0x5
    80000d00:	6ec98993          	addi	s3,s3,1772 # 800063e8 <stack>
    80000d04:	4901                	li	s2,0
        spinlock_init(&p->proc_lock, "proc");
    80000d06:	00003b17          	auipc	s6,0x3
    80000d0a:	3f2b0b13          	addi	s6,s6,1010 # 800040f8 <digits+0xa8>
    80000d0e:	6a85                	lui	s5,0x1
    for (int i = 0; i < NPROC; i++) {
    80000d10:	04000a13          	li	s4,64
        spinlock_init(&p->proc_lock, "proc");
    80000d14:	85da                	mv	a1,s6
    80000d16:	8526                	mv	a0,s1
    80000d18:	00002097          	auipc	ra,0x2
    80000d1c:	412080e7          	jalr	1042(ra) # 8000312a <spinlock_init>
        p->pid = i;
    80000d20:	ed24ac23          	sw	s2,-296(s1)
        p->kstack = (uint64) stack + PGSIZE * i;
    80000d24:	0334b023          	sd	s3,32(s1)
        p->state = UNUSED;
    80000d28:	ea04ac23          	sw	zero,-328(s1)
    for (int i = 0; i < NPROC; i++) {
    80000d2c:	2905                	addiw	s2,s2,1
    80000d2e:	1f048493          	addi	s1,s1,496
    80000d32:	99d6                	add	s3,s3,s5
    80000d34:	ff4910e3          	bne	s2,s4,80000d14 <init_process_table+0x34>
}
    80000d38:	70e2                	ld	ra,56(sp)
    80000d3a:	7442                	ld	s0,48(sp)
    80000d3c:	74a2                	ld	s1,40(sp)
    80000d3e:	7902                	ld	s2,32(sp)
    80000d40:	69e2                	ld	s3,24(sp)
    80000d42:	6a42                	ld	s4,16(sp)
    80000d44:	6aa2                	ld	s5,8(sp)
    80000d46:	6b02                	ld	s6,0(sp)
    80000d48:	6121                	addi	sp,sp,64
    80000d4a:	8082                	ret

0000000080000d4c <alloc_proc>:
struct proc *alloc_proc() {
    80000d4c:	7179                	addi	sp,sp,-48
    80000d4e:	f406                	sd	ra,40(sp)
    80000d50:	f022                	sd	s0,32(sp)
    80000d52:	ec26                	sd	s1,24(sp)
    80000d54:	e84a                	sd	s2,16(sp)
    80000d56:	e44e                	sd	s3,8(sp)
    80000d58:	e052                	sd	s4,0(sp)
    80000d5a:	1800                	addi	s0,sp,48
    for (int i = 0; i < NPROC; i++) {
    80000d5c:	00046797          	auipc	a5,0x46
    80000d60:	68c78793          	addi	a5,a5,1676 # 800473e8 <proc_table>
    80000d64:	4481                	li	s1,0
    80000d66:	04000693          	li	a3,64
        if (p->state == UNUSED) {
    80000d6a:	4398                	lw	a4,0(a5)
    80000d6c:	cb01                	beqz	a4,80000d7c <alloc_proc+0x30>
    for (int i = 0; i < NPROC; i++) {
    80000d6e:	2485                	addiw	s1,s1,1
    80000d70:	1f078793          	addi	a5,a5,496
    80000d74:	fed49be3          	bne	s1,a3,80000d6a <alloc_proc+0x1e>
    return 0;
    80000d78:	4a01                	li	s4,0
    80000d7a:	a825                	j	80000db2 <alloc_proc+0x66>
    80000d7c:	00549913          	slli	s2,s1,0x5
    80000d80:	40990533          	sub	a0,s2,s1
    80000d84:	0512                	slli	a0,a0,0x4
        p = &proc_table[i];
    80000d86:	00046997          	auipc	s3,0x46
    80000d8a:	66298993          	addi	s3,s3,1634 # 800473e8 <proc_table>
    80000d8e:	01350a33          	add	s4,a0,s3
            memset(&p->context, 0, sizeof(p->context));
    80000d92:	17050513          	addi	a0,a0,368
    80000d96:	07000613          	li	a2,112
    80000d9a:	4581                	li	a1,0
    80000d9c:	954e                	add	a0,a0,s3
    80000d9e:	00001097          	auipc	ra,0x1
    80000da2:	b0e080e7          	jalr	-1266(ra) # 800018ac <memset>
            p->context.sp = p->kstack + PGSIZE;
    80000da6:	168a3783          	ld	a5,360(s4)
    80000daa:	6705                	lui	a4,0x1
    80000dac:	97ba                	add	a5,a5,a4
    80000dae:	16fa3c23          	sd	a5,376(s4)
}
    80000db2:	8552                	mv	a0,s4
    80000db4:	70a2                	ld	ra,40(sp)
    80000db6:	7402                	ld	s0,32(sp)
    80000db8:	64e2                	ld	s1,24(sp)
    80000dba:	6942                	ld	s2,16(sp)
    80000dbc:	69a2                	ld	s3,8(sp)
    80000dbe:	6a02                	ld	s4,0(sp)
    80000dc0:	6145                	addi	sp,sp,48
    80000dc2:	8082                	ret

0000000080000dc4 <init_first_process>:
void init_first_process() {
    80000dc4:	1101                	addi	sp,sp,-32
    80000dc6:	ec06                	sd	ra,24(sp)
    80000dc8:	e822                	sd	s0,16(sp)
    80000dca:	e426                	sd	s1,8(sp)
    80000dcc:	1000                	addi	s0,sp,32
    struct proc *p = alloc_proc();
    80000dce:	00000097          	auipc	ra,0x0
    80000dd2:	f7e080e7          	jalr	-130(ra) # 80000d4c <alloc_proc>
    80000dd6:	84aa                	mv	s1,a0
    p->context.ra = (uint64) init;
    80000dd8:	00001797          	auipc	a5,0x1
    80000ddc:	a0878793          	addi	a5,a5,-1528 # 800017e0 <init>
    80000de0:	16f53823          	sd	a5,368(a0)
    p->current_dir = namei("/");
    80000de4:	00003517          	auipc	a0,0x3
    80000de8:	31c50513          	addi	a0,a0,796 # 80004100 <digits+0xb0>
    80000dec:	00002097          	auipc	ra,0x2
    80000df0:	126080e7          	jalr	294(ra) # 80002f12 <namei>
    80000df4:	16a4b023          	sd	a0,352(s1)
    p->state = RUNNABLE;
    80000df8:	4789                	li	a5,2
    80000dfa:	c09c                	sw	a5,0(s1)
    initproc = p;
    80000dfc:	00004797          	auipc	a5,0x4
    80000e00:	2097be23          	sd	s1,540(a5) # 80005018 <initproc>
}
    80000e04:	60e2                	ld	ra,24(sp)
    80000e06:	6442                	ld	s0,16(sp)
    80000e08:	64a2                	ld	s1,8(sp)
    80000e0a:	6105                	addi	sp,sp,32
    80000e0c:	8082                	ret

0000000080000e0e <cpuid>:
int cpuid() {
    80000e0e:	1141                	addi	sp,sp,-16
    80000e10:	e422                	sd	s0,8(sp)
    80000e12:	0800                	addi	s0,sp,16
    80000e14:	8512                	mv	a0,tp
}
    80000e16:	2501                	sext.w	a0,a0
    80000e18:	6422                	ld	s0,8(sp)
    80000e1a:	0141                	addi	sp,sp,16
    80000e1c:	8082                	ret

0000000080000e1e <mycpu>:
struct cpu *mycpu(void) {
    80000e1e:	1141                	addi	sp,sp,-16
    80000e20:	e422                	sd	s0,8(sp)
    80000e22:	0800                	addi	s0,sp,16
    80000e24:	8792                	mv	a5,tp
    struct cpu *c = &cpus[id];
    80000e26:	2781                	sext.w	a5,a5
    80000e28:	079e                	slli	a5,a5,0x7
}
    80000e2a:	00005517          	auipc	a0,0x5
    80000e2e:	3f650513          	addi	a0,a0,1014 # 80006220 <cpus>
    80000e32:	953e                	add	a0,a0,a5
    80000e34:	6422                	ld	s0,8(sp)
    80000e36:	0141                	addi	sp,sp,16
    80000e38:	8082                	ret

0000000080000e3a <myproc>:
struct proc *myproc() {
    80000e3a:	1141                	addi	sp,sp,-16
    80000e3c:	e422                	sd	s0,8(sp)
    80000e3e:	0800                	addi	s0,sp,16
    80000e40:	8792                	mv	a5,tp
    return mycpu()->proc;
    80000e42:	2781                	sext.w	a5,a5
    80000e44:	079e                	slli	a5,a5,0x7
    80000e46:	00005717          	auipc	a4,0x5
    80000e4a:	3da70713          	addi	a4,a4,986 # 80006220 <cpus>
    80000e4e:	97ba                	add	a5,a5,a4
}
    80000e50:	6388                	ld	a0,0(a5)
    80000e52:	6422                	ld	s0,8(sp)
    80000e54:	0141                	addi	sp,sp,16
    80000e56:	8082                	ret

0000000080000e58 <before_sched>:
void before_sched() {
    80000e58:	7179                	addi	sp,sp,-48
    80000e5a:	f406                	sd	ra,40(sp)
    80000e5c:	f022                	sd	s0,32(sp)
    80000e5e:	ec26                	sd	s1,24(sp)
    80000e60:	e84a                	sd	s2,16(sp)
    80000e62:	e44e                	sd	s3,8(sp)
    80000e64:	1800                	addi	s0,sp,48
    80000e66:	8792                	mv	a5,tp
    return mycpu()->proc;
    80000e68:	2781                	sext.w	a5,a5
    80000e6a:	079e                	slli	a5,a5,0x7
    80000e6c:	00005717          	auipc	a4,0x5
    80000e70:	3b470713          	addi	a4,a4,948 # 80006220 <cpus>
    80000e74:	97ba                	add	a5,a5,a4
    80000e76:	0007b903          	ld	s2,0(a5)
    if (!spin_holding(&p->proc_lock))
    80000e7a:	14890513          	addi	a0,s2,328
    80000e7e:	00002097          	auipc	ra,0x2
    80000e82:	2c2080e7          	jalr	706(ra) # 80003140 <spin_holding>
    80000e86:	c925                	beqz	a0,80000ef6 <before_sched+0x9e>
    80000e88:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    80000e8a:	2781                	sext.w	a5,a5
    80000e8c:	079e                	slli	a5,a5,0x7
    80000e8e:	00005717          	auipc	a4,0x5
    80000e92:	39270713          	addi	a4,a4,914 # 80006220 <cpus>
    80000e96:	97ba                	add	a5,a5,a4
    80000e98:	5fb8                	lw	a4,120(a5)
    80000e9a:	4785                	li	a5,1
    80000e9c:	06f71663          	bne	a4,a5,80000f08 <before_sched+0xb0>
    if (p->state == RUNNING)
    80000ea0:	00092703          	lw	a4,0(s2)
    80000ea4:	478d                	li	a5,3
    80000ea6:	06f70a63          	beq	a4,a5,80000f1a <before_sched+0xc2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000eaa:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000eae:	8b89                	andi	a5,a5,2
    if (intr_get())
    80000eb0:	efb5                	bnez	a5,80000f2c <before_sched+0xd4>
  asm volatile("mv %0, tp" : "=r" (x) );
    80000eb2:	8792                	mv	a5,tp
    intr_enable = mycpu()->intr_enable;
    80000eb4:	00005497          	auipc	s1,0x5
    80000eb8:	36c48493          	addi	s1,s1,876 # 80006220 <cpus>
    80000ebc:	2781                	sext.w	a5,a5
    80000ebe:	079e                	slli	a5,a5,0x7
    80000ec0:	97a6                	add	a5,a5,s1
    80000ec2:	07c7a983          	lw	s3,124(a5)
    80000ec6:	8592                	mv	a1,tp
    pswitch(&p->context, &mycpu()->context);
    80000ec8:	2581                	sext.w	a1,a1
    80000eca:	059e                	slli	a1,a1,0x7
    80000ecc:	05a1                	addi	a1,a1,8
    80000ece:	95a6                	add	a1,a1,s1
    80000ed0:	17090513          	addi	a0,s2,368
    80000ed4:	00001097          	auipc	ra,0x1
    80000ed8:	afe080e7          	jalr	-1282(ra) # 800019d2 <pswitch>
    80000edc:	8792                	mv	a5,tp
    mycpu()->intr_enable = intr_enable;
    80000ede:	2781                	sext.w	a5,a5
    80000ee0:	079e                	slli	a5,a5,0x7
    80000ee2:	94be                	add	s1,s1,a5
    80000ee4:	0734ae23          	sw	s3,124(s1)
}
    80000ee8:	70a2                	ld	ra,40(sp)
    80000eea:	7402                	ld	s0,32(sp)
    80000eec:	64e2                	ld	s1,24(sp)
    80000eee:	6942                	ld	s2,16(sp)
    80000ef0:	69a2                	ld	s3,8(sp)
    80000ef2:	6145                	addi	sp,sp,48
    80000ef4:	8082                	ret
        panic("sched p->lock");
    80000ef6:	00003517          	auipc	a0,0x3
    80000efa:	21250513          	addi	a0,a0,530 # 80004108 <digits+0xb8>
    80000efe:	00000097          	auipc	ra,0x0
    80000f02:	872080e7          	jalr	-1934(ra) # 80000770 <panic>
    80000f06:	b749                	j	80000e88 <before_sched+0x30>
        panic("sched locks");
    80000f08:	00003517          	auipc	a0,0x3
    80000f0c:	21050513          	addi	a0,a0,528 # 80004118 <digits+0xc8>
    80000f10:	00000097          	auipc	ra,0x0
    80000f14:	860080e7          	jalr	-1952(ra) # 80000770 <panic>
    80000f18:	b761                	j	80000ea0 <before_sched+0x48>
        panic("sched running");
    80000f1a:	00003517          	auipc	a0,0x3
    80000f1e:	20e50513          	addi	a0,a0,526 # 80004128 <digits+0xd8>
    80000f22:	00000097          	auipc	ra,0x0
    80000f26:	84e080e7          	jalr	-1970(ra) # 80000770 <panic>
    80000f2a:	b741                	j	80000eaa <before_sched+0x52>
        panic("sched interruptible");
    80000f2c:	00003517          	auipc	a0,0x3
    80000f30:	20c50513          	addi	a0,a0,524 # 80004138 <digits+0xe8>
    80000f34:	00000097          	auipc	ra,0x0
    80000f38:	83c080e7          	jalr	-1988(ra) # 80000770 <panic>
    80000f3c:	bf9d                	j	80000eb2 <before_sched+0x5a>

0000000080000f3e <sleep>:
void sleep(void *chan, struct spinlock *lock) {
    80000f3e:	7179                	addi	sp,sp,-48
    80000f40:	f406                	sd	ra,40(sp)
    80000f42:	f022                	sd	s0,32(sp)
    80000f44:	ec26                	sd	s1,24(sp)
    80000f46:	e84a                	sd	s2,16(sp)
    80000f48:	e44e                	sd	s3,8(sp)
    80000f4a:	e052                	sd	s4,0(sp)
    80000f4c:	1800                	addi	s0,sp,48
    80000f4e:	89aa                	mv	s3,a0
    80000f50:	8792                	mv	a5,tp
    return mycpu()->proc;
    80000f52:	2781                	sext.w	a5,a5
    80000f54:	079e                	slli	a5,a5,0x7
    80000f56:	00005717          	auipc	a4,0x5
    80000f5a:	2ca70713          	addi	a4,a4,714 # 80006220 <cpus>
    80000f5e:	97ba                	add	a5,a5,a4
    80000f60:	0007b903          	ld	s2,0(a5)
    if (lock != &p->proc_lock) {  //DOC: sleeplock0
    80000f64:	14890a13          	addi	s4,s2,328
    80000f68:	04ba0a63          	beq	s4,a1,80000fbc <sleep+0x7e>
    80000f6c:	84ae                	mv	s1,a1
        spin_lock(&p->proc_lock);  //DOC: sleeplock1
    80000f6e:	8552                	mv	a0,s4
    80000f70:	00002097          	auipc	ra,0x2
    80000f74:	24a080e7          	jalr	586(ra) # 800031ba <spin_lock>
        spin_unlock(lock);
    80000f78:	8526                	mv	a0,s1
    80000f7a:	00002097          	auipc	ra,0x2
    80000f7e:	314080e7          	jalr	788(ra) # 8000328e <spin_unlock>
    p->chan = chan;
    80000f82:	01393823          	sd	s3,16(s2)
    p->state = SLEEPING;
    80000f86:	4785                	li	a5,1
    80000f88:	00f92023          	sw	a5,0(s2)
    before_sched();
    80000f8c:	00000097          	auipc	ra,0x0
    80000f90:	ecc080e7          	jalr	-308(ra) # 80000e58 <before_sched>
    p->chan = 0;
    80000f94:	00093823          	sd	zero,16(s2)
        spin_unlock(&p->proc_lock);
    80000f98:	8552                	mv	a0,s4
    80000f9a:	00002097          	auipc	ra,0x2
    80000f9e:	2f4080e7          	jalr	756(ra) # 8000328e <spin_unlock>
        spin_lock(lock);
    80000fa2:	8526                	mv	a0,s1
    80000fa4:	00002097          	auipc	ra,0x2
    80000fa8:	216080e7          	jalr	534(ra) # 800031ba <spin_lock>
}
    80000fac:	70a2                	ld	ra,40(sp)
    80000fae:	7402                	ld	s0,32(sp)
    80000fb0:	64e2                	ld	s1,24(sp)
    80000fb2:	6942                	ld	s2,16(sp)
    80000fb4:	69a2                	ld	s3,8(sp)
    80000fb6:	6a02                	ld	s4,0(sp)
    80000fb8:	6145                	addi	sp,sp,48
    80000fba:	8082                	ret
    p->chan = chan;
    80000fbc:	00a93823          	sd	a0,16(s2)
    p->state = SLEEPING;
    80000fc0:	4785                	li	a5,1
    80000fc2:	00f92023          	sw	a5,0(s2)
    before_sched();
    80000fc6:	00000097          	auipc	ra,0x0
    80000fca:	e92080e7          	jalr	-366(ra) # 80000e58 <before_sched>
    p->chan = 0;
    80000fce:	00093823          	sd	zero,16(s2)
    if (lock != &p->proc_lock) {
    80000fd2:	bfe9                	j	80000fac <sleep+0x6e>

0000000080000fd4 <sleep_time>:
void sleep_time(uint64 sleep_ticks) {
    80000fd4:	7179                	addi	sp,sp,-48
    80000fd6:	f406                	sd	ra,40(sp)
    80000fd8:	f022                	sd	s0,32(sp)
    80000fda:	ec26                	sd	s1,24(sp)
    80000fdc:	e84a                	sd	s2,16(sp)
    80000fde:	e44e                	sd	s3,8(sp)
    80000fe0:	e052                	sd	s4,0(sp)
    80000fe2:	1800                	addi	s0,sp,48
    80000fe4:	892a                	mv	s2,a0
    uint64 now = ticks;
    80000fe6:	00004497          	auipc	s1,0x4
    80000fea:	02a48493          	addi	s1,s1,42 # 80005010 <ticks>
    80000fee:	0004b983          	ld	s3,0(s1)
    spin_lock(&ticks_lock);
    80000ff2:	00005517          	auipc	a0,0x5
    80000ff6:	21650513          	addi	a0,a0,534 # 80006208 <ticks_lock>
    80000ffa:	00002097          	auipc	ra,0x2
    80000ffe:	1c0080e7          	jalr	448(ra) # 800031ba <spin_lock>
    for (; ticks - now < sleep_ticks;) {
    80001002:	609c                	ld	a5,0(s1)
    80001004:	413787b3          	sub	a5,a5,s3
    80001008:	0327f163          	bgeu	a5,s2,8000102a <sleep_time+0x56>
        sleep(&ticks, &ticks_lock);
    8000100c:	00005a17          	auipc	s4,0x5
    80001010:	1fca0a13          	addi	s4,s4,508 # 80006208 <ticks_lock>
    80001014:	85d2                	mv	a1,s4
    80001016:	8526                	mv	a0,s1
    80001018:	00000097          	auipc	ra,0x0
    8000101c:	f26080e7          	jalr	-218(ra) # 80000f3e <sleep>
    for (; ticks - now < sleep_ticks;) {
    80001020:	609c                	ld	a5,0(s1)
    80001022:	413787b3          	sub	a5,a5,s3
    80001026:	ff27e7e3          	bltu	a5,s2,80001014 <sleep_time+0x40>
    spin_unlock(&ticks_lock);
    8000102a:	00005517          	auipc	a0,0x5
    8000102e:	1de50513          	addi	a0,a0,478 # 80006208 <ticks_lock>
    80001032:	00002097          	auipc	ra,0x2
    80001036:	25c080e7          	jalr	604(ra) # 8000328e <spin_unlock>
}
    8000103a:	70a2                	ld	ra,40(sp)
    8000103c:	7402                	ld	s0,32(sp)
    8000103e:	64e2                	ld	s1,24(sp)
    80001040:	6942                	ld	s2,16(sp)
    80001042:	69a2                	ld	s3,8(sp)
    80001044:	6a02                	ld	s4,0(sp)
    80001046:	6145                	addi	sp,sp,48
    80001048:	8082                	ret

000000008000104a <wakeup>:
void wakeup(void *chan) {
    8000104a:	1141                	addi	sp,sp,-16
    8000104c:	e422                	sd	s0,8(sp)
    8000104e:	0800                	addi	s0,sp,16
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80001050:	00046797          	auipc	a5,0x46
    80001054:	39878793          	addi	a5,a5,920 # 800473e8 <proc_table>
        if (p->state == SLEEPING && p->chan == chan) {
    80001058:	4605                	li	a2,1
            p->state = RUNNABLE;
    8000105a:	4589                	li	a1,2
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    8000105c:	0004e697          	auipc	a3,0x4e
    80001060:	f8c68693          	addi	a3,a3,-116 # 8004efe8 <proc_table+0x7c00>
    80001064:	a031                	j	80001070 <wakeup+0x26>
            p->state = RUNNABLE;
    80001066:	c38c                	sw	a1,0(a5)
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80001068:	1f078793          	addi	a5,a5,496
    8000106c:	00d78963          	beq	a5,a3,8000107e <wakeup+0x34>
        if (p->state == SLEEPING && p->chan == chan) {
    80001070:	4398                	lw	a4,0(a5)
    80001072:	fec71be3          	bne	a4,a2,80001068 <wakeup+0x1e>
    80001076:	6b98                	ld	a4,16(a5)
    80001078:	fea718e3          	bne	a4,a0,80001068 <wakeup+0x1e>
    8000107c:	b7ed                	j	80001066 <wakeup+0x1c>
}
    8000107e:	6422                	ld	s0,8(sp)
    80001080:	0141                	addi	sp,sp,16
    80001082:	8082                	ret

0000000080001084 <scheduler>:
void scheduler() {
    80001084:	711d                	addi	sp,sp,-96
    80001086:	ec86                	sd	ra,88(sp)
    80001088:	e8a2                	sd	s0,80(sp)
    8000108a:	e4a6                	sd	s1,72(sp)
    8000108c:	e0ca                	sd	s2,64(sp)
    8000108e:	fc4e                	sd	s3,56(sp)
    80001090:	f852                	sd	s4,48(sp)
    80001092:	f456                	sd	s5,40(sp)
    80001094:	f05a                	sd	s6,32(sp)
    80001096:	ec5e                	sd	s7,24(sp)
    80001098:	e862                	sd	s8,16(sp)
    8000109a:	e466                	sd	s9,8(sp)
    8000109c:	e06a                	sd	s10,0(sp)
    8000109e:	1080                	addi	s0,sp,96
    800010a0:	8792                	mv	a5,tp
    int id = r_tp();
    800010a2:	2781                	sext.w	a5,a5
                pswitch(&c->context, &p->context);
    800010a4:	00779c93          	slli	s9,a5,0x7
    800010a8:	00005717          	auipc	a4,0x5
    800010ac:	18070713          	addi	a4,a4,384 # 80006228 <cpus+0x8>
    800010b0:	9cba                	add	s9,s9,a4
                wakeup(initproc);
    800010b2:	00004d17          	auipc	s10,0x4
    800010b6:	f66d0d13          	addi	s10,s10,-154 # 80005018 <initproc>
            if (p->state == RUNNABLE) {
    800010ba:	4a89                	li	s5,2
                c->proc = p;
    800010bc:	079e                	slli	a5,a5,0x7
    800010be:	00005b97          	auipc	s7,0x5
    800010c2:	162b8b93          	addi	s7,s7,354 # 80006220 <cpus>
    800010c6:	9bbe                	add	s7,s7,a5
    800010c8:	a0a5                	j	80001130 <scheduler+0xac>
            spin_unlock(&p->proc_lock);
    800010ca:	854a                	mv	a0,s2
    800010cc:	00002097          	auipc	ra,0x2
    800010d0:	1c2080e7          	jalr	450(ra) # 8000328e <spin_unlock>
        for (int i = 0; i < NPROC; i++) {
    800010d4:	1f048493          	addi	s1,s1,496
    800010d8:	05348263          	beq	s1,s3,8000111c <scheduler+0x98>
            spin_lock(&p->proc_lock);
    800010dc:	8926                	mv	s2,s1
    800010de:	8526                	mv	a0,s1
    800010e0:	00002097          	auipc	ra,0x2
    800010e4:	0da080e7          	jalr	218(ra) # 800031ba <spin_lock>
            if (p->state != UNUSED && p->state != ZOMBIE) {
    800010e8:	eb84a783          	lw	a5,-328(s1)
    800010ec:	dff9                	beqz	a5,800010ca <scheduler+0x46>
    800010ee:	07678363          	beq	a5,s6,80001154 <scheduler+0xd0>
                alive_p++;
    800010f2:	2a05                	addiw	s4,s4,1
            if (p->state == RUNNABLE) {
    800010f4:	eb892783          	lw	a5,-328(s2)
    800010f8:	fd5799e3          	bne	a5,s5,800010ca <scheduler+0x46>
                p->state = RUNNING;
    800010fc:	eb892c23          	sw	s8,-328(s2)
                c->proc = p;
    80001100:	eb848793          	addi	a5,s1,-328
    80001104:	00fbb023          	sd	a5,0(s7)
                pswitch(&c->context, &p->context);
    80001108:	02848593          	addi	a1,s1,40
    8000110c:	8566                	mv	a0,s9
    8000110e:	00001097          	auipc	ra,0x1
    80001112:	8c4080e7          	jalr	-1852(ra) # 800019d2 <pswitch>
                c->proc = 0;
    80001116:	000bb023          	sd	zero,0(s7)
    8000111a:	bf45                	j	800010ca <scheduler+0x46>
        if (alive_p <= 2) {
    8000111c:	014aca63          	blt	s5,s4,80001130 <scheduler+0xac>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001120:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001124:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001128:	10079073          	csrw	sstatus,a5
            asm volatile("wfi");
    8000112c:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001130:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001134:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001138:	10079073          	csrw	sstatus,a5
        for (int i = 0; i < NPROC; i++) {
    8000113c:	00046497          	auipc	s1,0x46
    80001140:	3f448493          	addi	s1,s1,1012 # 80047530 <proc_table+0x148>
    80001144:	0004e997          	auipc	s3,0x4e
    80001148:	fec98993          	addi	s3,s3,-20 # 8004f130 <disk+0x130>
        alive_p = 0;
    8000114c:	4a01                	li	s4,0
            if (p->state != UNUSED && p->state != ZOMBIE) {
    8000114e:	4b11                	li	s6,4
                p->state = RUNNING;
    80001150:	4c0d                	li	s8,3
    80001152:	b769                	j	800010dc <scheduler+0x58>
                wakeup(initproc);
    80001154:	000d3503          	ld	a0,0(s10)
    80001158:	00000097          	auipc	ra,0x0
    8000115c:	ef2080e7          	jalr	-270(ra) # 8000104a <wakeup>
    80001160:	bf51                	j	800010f4 <scheduler+0x70>

0000000080001162 <wait>:
int wait(int *status) {
    80001162:	711d                	addi	sp,sp,-96
    80001164:	ec86                	sd	ra,88(sp)
    80001166:	e8a2                	sd	s0,80(sp)
    80001168:	e4a6                	sd	s1,72(sp)
    8000116a:	e0ca                	sd	s2,64(sp)
    8000116c:	fc4e                	sd	s3,56(sp)
    8000116e:	f852                	sd	s4,48(sp)
    80001170:	f456                	sd	s5,40(sp)
    80001172:	f05a                	sd	s6,32(sp)
    80001174:	ec5e                	sd	s7,24(sp)
    80001176:	e862                	sd	s8,16(sp)
    80001178:	e466                	sd	s9,8(sp)
    8000117a:	e06a                	sd	s10,0(sp)
    8000117c:	1080                	addi	s0,sp,96
    8000117e:	8baa                	mv	s7,a0
  asm volatile("mv %0, tp" : "=r" (x) );
    80001180:	8792                	mv	a5,tp
    return mycpu()->proc;
    80001182:	2781                	sext.w	a5,a5
    80001184:	079e                	slli	a5,a5,0x7
    80001186:	00005717          	auipc	a4,0x5
    8000118a:	09a70713          	addi	a4,a4,154 # 80006220 <cpus>
    8000118e:	97ba                	add	a5,a5,a4
    80001190:	0007b903          	ld	s2,0(a5)
    spin_lock(&p->proc_lock);
    80001194:	14890c13          	addi	s8,s2,328
    80001198:	8562                	mv	a0,s8
    8000119a:	00002097          	auipc	ra,0x2
    8000119e:	020080e7          	jalr	32(ra) # 800031ba <spin_lock>
        havechild = 0;
    800011a2:	4c81                	li	s9,0
                if (cp->state == ZOMBIE) {
    800011a4:	4a91                	li	s5,4
        for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    800011a6:	0004e997          	auipc	s3,0x4e
    800011aa:	e4298993          	addi	s3,s3,-446 # 8004efe8 <proc_table+0x7c00>
                havechild = 1;
    800011ae:	4b05                	li	s6,1
    return mycpu()->proc;
    800011b0:	00005d17          	auipc	s10,0x5
    800011b4:	070d0d13          	addi	s10,s10,112 # 80006220 <cpus>
        havechild = 0;
    800011b8:	8766                	mv	a4,s9
        for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    800011ba:	00046497          	auipc	s1,0x46
    800011be:	22e48493          	addi	s1,s1,558 # 800473e8 <proc_table>
    800011c2:	a80d                	j	800011f4 <wait+0x92>
                    pid = cp->pid;
    800011c4:	0204a903          	lw	s2,32(s1)
                    if (status) {
    800011c8:	000b8563          	beqz	s7,800011d2 <wait+0x70>
                        *status = cp->xstate;
    800011cc:	4cdc                	lw	a5,28(s1)
    800011ce:	00fba023          	sw	a5,0(s7)
                    cp->state = UNUSED;
    800011d2:	0004a023          	sw	zero,0(s1)
                    spin_unlock(&cp->proc_lock);
    800011d6:	8552                	mv	a0,s4
    800011d8:	00002097          	auipc	ra,0x2
    800011dc:	0b6080e7          	jalr	182(ra) # 8000328e <spin_unlock>
                    spin_unlock(&p->proc_lock);
    800011e0:	8562                	mv	a0,s8
    800011e2:	00002097          	auipc	ra,0x2
    800011e6:	0ac080e7          	jalr	172(ra) # 8000328e <spin_unlock>
                    return pid;
    800011ea:	a81d                	j	80001220 <wait+0xbe>
        for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    800011ec:	1f048493          	addi	s1,s1,496
    800011f0:	03348663          	beq	s1,s3,8000121c <wait+0xba>
            if (cp->parent == p) {
    800011f4:	649c                	ld	a5,8(s1)
    800011f6:	ff279be3          	bne	a5,s2,800011ec <wait+0x8a>
                spin_lock(&cp->proc_lock);
    800011fa:	14848a13          	addi	s4,s1,328
    800011fe:	8552                	mv	a0,s4
    80001200:	00002097          	auipc	ra,0x2
    80001204:	fba080e7          	jalr	-70(ra) # 800031ba <spin_lock>
                if (cp->state == ZOMBIE) {
    80001208:	409c                	lw	a5,0(s1)
    8000120a:	fb578de3          	beq	a5,s5,800011c4 <wait+0x62>
                spin_unlock(&cp->proc_lock);
    8000120e:	8552                	mv	a0,s4
    80001210:	00002097          	auipc	ra,0x2
    80001214:	07e080e7          	jalr	126(ra) # 8000328e <spin_unlock>
                havechild = 1;
    80001218:	875a                	mv	a4,s6
    8000121a:	bfc9                	j	800011ec <wait+0x8a>
        if (!havechild) {
    8000121c:	e30d                	bnez	a4,8000123e <wait+0xdc>
            return -1;
    8000121e:	597d                	li	s2,-1
}
    80001220:	854a                	mv	a0,s2
    80001222:	60e6                	ld	ra,88(sp)
    80001224:	6446                	ld	s0,80(sp)
    80001226:	64a6                	ld	s1,72(sp)
    80001228:	6906                	ld	s2,64(sp)
    8000122a:	79e2                	ld	s3,56(sp)
    8000122c:	7a42                	ld	s4,48(sp)
    8000122e:	7aa2                	ld	s5,40(sp)
    80001230:	7b02                	ld	s6,32(sp)
    80001232:	6be2                	ld	s7,24(sp)
    80001234:	6c42                	ld	s8,16(sp)
    80001236:	6ca2                	ld	s9,8(sp)
    80001238:	6d02                	ld	s10,0(sp)
    8000123a:	6125                	addi	sp,sp,96
    8000123c:	8082                	ret
    8000123e:	8792                	mv	a5,tp
    return mycpu()->proc;
    80001240:	2781                	sext.w	a5,a5
    80001242:	079e                	slli	a5,a5,0x7
    80001244:	97ea                	add	a5,a5,s10
        sleep(p, &myproc()->proc_lock); // 等待子进程唤醒
    80001246:	638c                	ld	a1,0(a5)
    80001248:	14858593          	addi	a1,a1,328
    8000124c:	854a                	mv	a0,s2
    8000124e:	00000097          	auipc	ra,0x0
    80001252:	cf0080e7          	jalr	-784(ra) # 80000f3e <sleep>
        havechild = 0;
    80001256:	b78d                	j	800011b8 <wait+0x56>

0000000080001258 <exit>:
void exit(int status) {
    80001258:	1101                	addi	sp,sp,-32
    8000125a:	ec06                	sd	ra,24(sp)
    8000125c:	e822                	sd	s0,16(sp)
    8000125e:	e426                	sd	s1,8(sp)
    80001260:	1000                	addi	s0,sp,32
    80001262:	8792                	mv	a5,tp
    return mycpu()->proc;
    80001264:	2781                	sext.w	a5,a5
    80001266:	079e                	slli	a5,a5,0x7
    80001268:	00005717          	auipc	a4,0x5
    8000126c:	fb870713          	addi	a4,a4,-72 # 80006220 <cpus>
    80001270:	97ba                	add	a5,a5,a4
    80001272:	6384                	ld	s1,0(a5)
    p->state = ZOMBIE;
    80001274:	4791                	li	a5,4
    80001276:	c09c                	sw	a5,0(s1)
    p->xstate = status;
    80001278:	ccc8                	sw	a0,28(s1)
            cp->parent = initproc;
    8000127a:	00004617          	auipc	a2,0x4
    8000127e:	d9e63603          	ld	a2,-610(a2) # 80005018 <initproc>
    for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    80001282:	00046797          	auipc	a5,0x46
    80001286:	16678793          	addi	a5,a5,358 # 800473e8 <proc_table>
    8000128a:	0004e697          	auipc	a3,0x4e
    8000128e:	d5e68693          	addi	a3,a3,-674 # 8004efe8 <proc_table+0x7c00>
    80001292:	a031                	j	8000129e <exit+0x46>
            cp->parent = initproc;
    80001294:	e790                	sd	a2,8(a5)
    for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    80001296:	1f078793          	addi	a5,a5,496
    8000129a:	00d78663          	beq	a5,a3,800012a6 <exit+0x4e>
        if (cp->parent == p) {
    8000129e:	6798                	ld	a4,8(a5)
    800012a0:	fe971be3          	bne	a4,s1,80001296 <exit+0x3e>
    800012a4:	bfc5                	j	80001294 <exit+0x3c>
    wakeup(p->parent);
    800012a6:	6488                	ld	a0,8(s1)
    800012a8:	00000097          	auipc	ra,0x0
    800012ac:	da2080e7          	jalr	-606(ra) # 8000104a <wakeup>
    spin_lock(&p->proc_lock);
    800012b0:	14848513          	addi	a0,s1,328
    800012b4:	00002097          	auipc	ra,0x2
    800012b8:	f06080e7          	jalr	-250(ra) # 800031ba <spin_lock>
    before_sched();
    800012bc:	00000097          	auipc	ra,0x0
    800012c0:	b9c080e7          	jalr	-1124(ra) # 80000e58 <before_sched>
}
    800012c4:	60e2                	ld	ra,24(sp)
    800012c6:	6442                	ld	s0,16(sp)
    800012c8:	64a2                	ld	s1,8(sp)
    800012ca:	6105                	addi	sp,sp,32
    800012cc:	8082                	ret

00000000800012ce <hello>:

void hello()
{
    800012ce:	1141                	addi	sp,sp,-16
    800012d0:	e406                	sd	ra,8(sp)
    800012d2:	e022                	sd	s0,0(sp)
    800012d4:	0800                	addi	s0,sp,16
    puts("Hello, world!\n\t\tfrom startOS with osh");
    800012d6:	00003517          	auipc	a0,0x3
    800012da:	e7a50513          	addi	a0,a0,-390 # 80004150 <digits+0x100>
    800012de:	fffff097          	auipc	ra,0xfffff
    800012e2:	22a080e7          	jalr	554(ra) # 80000508 <puts>
    exit(0);
    800012e6:	4501                	li	a0,0
    800012e8:	00000097          	auipc	ra,0x0
    800012ec:	f70080e7          	jalr	-144(ra) # 80001258 <exit>
}
    800012f0:	60a2                	ld	ra,8(sp)
    800012f2:	6402                	ld	s0,0(sp)
    800012f4:	0141                	addi	sp,sp,16
    800012f6:	8082                	ret

00000000800012f8 <cowsay>:
void cowsay(){
    800012f8:	1141                	addi	sp,sp,-16
    800012fa:	e406                	sd	ra,8(sp)
    800012fc:	e022                	sd	s0,0(sp)
    800012fe:	0800                	addi	s0,sp,16
    puts("    ____________");
    80001300:	00003517          	auipc	a0,0x3
    80001304:	e7850513          	addi	a0,a0,-392 # 80004178 <digits+0x128>
    80001308:	fffff097          	auipc	ra,0xfffff
    8000130c:	200080e7          	jalr	512(ra) # 80000508 <puts>
    puts("    < hi, there >");
    80001310:	00003517          	auipc	a0,0x3
    80001314:	e8050513          	addi	a0,a0,-384 # 80004190 <digits+0x140>
    80001318:	fffff097          	auipc	ra,0xfffff
    8000131c:	1f0080e7          	jalr	496(ra) # 80000508 <puts>
    puts("    ------------");
    80001320:	00003517          	auipc	a0,0x3
    80001324:	e8850513          	addi	a0,a0,-376 # 800041a8 <digits+0x158>
    80001328:	fffff097          	auipc	ra,0xfffff
    8000132c:	1e0080e7          	jalr	480(ra) # 80000508 <puts>
    puts("         \\   ^__^");
    80001330:	00003517          	auipc	a0,0x3
    80001334:	e9050513          	addi	a0,a0,-368 # 800041c0 <digits+0x170>
    80001338:	fffff097          	auipc	ra,0xfffff
    8000133c:	1d0080e7          	jalr	464(ra) # 80000508 <puts>
    puts("          \\  (oo)\\_______");
    80001340:	00003517          	auipc	a0,0x3
    80001344:	e9850513          	addi	a0,a0,-360 # 800041d8 <digits+0x188>
    80001348:	fffff097          	auipc	ra,0xfffff
    8000134c:	1c0080e7          	jalr	448(ra) # 80000508 <puts>
    puts("             (__)\\       )\\/\\");
    80001350:	00003517          	auipc	a0,0x3
    80001354:	ea850513          	addi	a0,a0,-344 # 800041f8 <digits+0x1a8>
    80001358:	fffff097          	auipc	ra,0xfffff
    8000135c:	1b0080e7          	jalr	432(ra) # 80000508 <puts>
    puts("                 ||----w |");
    80001360:	00003517          	auipc	a0,0x3
    80001364:	eb850513          	addi	a0,a0,-328 # 80004218 <digits+0x1c8>
    80001368:	fffff097          	auipc	ra,0xfffff
    8000136c:	1a0080e7          	jalr	416(ra) # 80000508 <puts>
    puts("                 ||     ||");
    80001370:	00003517          	auipc	a0,0x3
    80001374:	ec850513          	addi	a0,a0,-312 # 80004238 <digits+0x1e8>
    80001378:	fffff097          	auipc	ra,0xfffff
    8000137c:	190080e7          	jalr	400(ra) # 80000508 <puts>
    exit(0);
    80001380:	4501                	li	a0,0
    80001382:	00000097          	auipc	ra,0x0
    80001386:	ed6080e7          	jalr	-298(ra) # 80001258 <exit>
}
    8000138a:	60a2                	ld	ra,8(sp)
    8000138c:	6402                	ld	s0,0(sp)
    8000138e:	0141                	addi	sp,sp,16
    80001390:	8082                	ret

0000000080001392 <mew>:
void mew(){
    80001392:	1141                	addi	sp,sp,-16
    80001394:	e406                	sd	ra,8(sp)
    80001396:	e022                	sd	s0,0(sp)
    80001398:	0800                	addi	s0,sp,16
    puts("          ＿＿");
    8000139a:	00003517          	auipc	a0,0x3
    8000139e:	ebe50513          	addi	a0,a0,-322 # 80004258 <digits+0x208>
    800013a2:	fffff097          	auipc	ra,0xfffff
    800013a6:	166080e7          	jalr	358(ra) # 80000508 <puts>
    puts("　　　／＞　　フ");
    800013aa:	00003517          	auipc	a0,0x3
    800013ae:	ec650513          	addi	a0,a0,-314 # 80004270 <digits+0x220>
    800013b2:	fffff097          	auipc	ra,0xfffff
    800013b6:	156080e7          	jalr	342(ra) # 80000508 <puts>
    puts("　　　|   _　 _ |");
    800013ba:	00003517          	auipc	a0,0x3
    800013be:	ed650513          	addi	a0,a0,-298 # 80004290 <digits+0x240>
    800013c2:	fffff097          	auipc	ra,0xfffff
    800013c6:	146080e7          	jalr	326(ra) # 80000508 <puts>
    puts("　　／`  ミ＿xノ");
    800013ca:	00003517          	auipc	a0,0x3
    800013ce:	ede50513          	addi	a0,a0,-290 # 800042a8 <digits+0x258>
    800013d2:	fffff097          	auipc	ra,0xfffff
    800013d6:	136080e7          	jalr	310(ra) # 80000508 <puts>
    puts(" 　 /　　　 　 |");
    800013da:	00003517          	auipc	a0,0x3
    800013de:	ee650513          	addi	a0,a0,-282 # 800042c0 <digits+0x270>
    800013e2:	fffff097          	auipc	ra,0xfffff
    800013e6:	126080e7          	jalr	294(ra) # 80000508 <puts>
    puts("　 /　 ヽ　　 ﾉ");
    800013ea:	00003517          	auipc	a0,0x3
    800013ee:	eee50513          	addi	a0,a0,-274 # 800042d8 <digits+0x288>
    800013f2:	fffff097          	auipc	ra,0xfffff
    800013f6:	116080e7          	jalr	278(ra) # 80000508 <puts>
    exit(0);
    800013fa:	4501                	li	a0,0
    800013fc:	00000097          	auipc	ra,0x0
    80001400:	e5c080e7          	jalr	-420(ra) # 80001258 <exit>
    80001404:	60a2                	ld	ra,8(sp)
    80001406:	6402                	ld	s0,0(sp)
    80001408:	0141                	addi	sp,sp,16
    8000140a:	8082                	ret

000000008000140c <help>:
//#include "user/usertests.c"

void showHistory();

void help()
{
    8000140c:	1141                	addi	sp,sp,-16
    8000140e:	e406                	sd	ra,8(sp)
    80001410:	e022                	sd	s0,0(sp)
    80001412:	0800                	addi	s0,sp,16
    puts("All available commmands:");
    80001414:	00003517          	auipc	a0,0x3
    80001418:	edc50513          	addi	a0,a0,-292 # 800042f0 <digits+0x2a0>
    8000141c:	fffff097          	auipc	ra,0xfffff
    80001420:	0ec080e7          	jalr	236(ra) # 80000508 <puts>
    puts("help\tshow this helping message");
    80001424:	00003517          	auipc	a0,0x3
    80001428:	eec50513          	addi	a0,a0,-276 # 80004310 <digits+0x2c0>
    8000142c:	fffff097          	auipc	ra,0xfffff
    80001430:	0dc080e7          	jalr	220(ra) # 80000508 <puts>
    puts("hello\tprint test hello world message");
    80001434:	00003517          	auipc	a0,0x3
    80001438:	efc50513          	addi	a0,a0,-260 # 80004330 <digits+0x2e0>
    8000143c:	fffff097          	auipc	ra,0xfffff
    80001440:	0cc080e7          	jalr	204(ra) # 80000508 <puts>
    puts("history\tshow recent commands you input");
    80001444:	00003517          	auipc	a0,0x3
    80001448:	f1450513          	addi	a0,a0,-236 # 80004358 <digits+0x308>
    8000144c:	fffff097          	auipc	ra,0xfffff
    80001450:	0bc080e7          	jalr	188(ra) # 80000508 <puts>
    puts("usertests\texec test function");
    80001454:	00003517          	auipc	a0,0x3
    80001458:	f2c50513          	addi	a0,a0,-212 # 80004380 <digits+0x330>
    8000145c:	fffff097          	auipc	ra,0xfffff
    80001460:	0ac080e7          	jalr	172(ra) # 80000508 <puts>
    puts("cowsay\tcowsay");
    80001464:	00003517          	auipc	a0,0x3
    80001468:	f3c50513          	addi	a0,a0,-196 # 800043a0 <digits+0x350>
    8000146c:	fffff097          	auipc	ra,0xfffff
    80001470:	09c080e7          	jalr	156(ra) # 80000508 <puts>
    puts("mew\tmew mew");
    80001474:	00003517          	auipc	a0,0x3
    80001478:	f3c50513          	addi	a0,a0,-196 # 800043b0 <digits+0x360>
    8000147c:	fffff097          	auipc	ra,0xfffff
    80001480:	08c080e7          	jalr	140(ra) # 80000508 <puts>
    exit(0);
    80001484:	4501                	li	a0,0
    80001486:	00000097          	auipc	ra,0x0
    8000148a:	dd2080e7          	jalr	-558(ra) # 80001258 <exit>
}
    8000148e:	60a2                	ld	ra,8(sp)
    80001490:	6402                	ld	s0,0(sp)
    80001492:	0141                	addi	sp,sp,16
    80001494:	8082                	ret

0000000080001496 <showHistory>:
    }
    exit(0);
}

void showHistory()
{
    80001496:	715d                	addi	sp,sp,-80
    80001498:	e486                	sd	ra,72(sp)
    8000149a:	e0a2                	sd	s0,64(sp)
    8000149c:	fc26                	sd	s1,56(sp)
    8000149e:	f84a                	sd	s2,48(sp)
    800014a0:	f44e                	sd	s3,40(sp)
    800014a2:	f052                	sd	s4,32(sp)
    800014a4:	ec56                	sd	s5,24(sp)
    800014a6:	e85a                	sd	s6,16(sp)
    800014a8:	e45e                	sd	s7,8(sp)
    800014aa:	0880                	addi	s0,sp,80
    int startP=h.currentP;
    for (int k = MAX_HISTORY_NUM, i = (MAX_HISTORY_NUM + startP) % MAX_HISTORY_NUM; k > 0; i++, k--) {
    800014ac:	00005497          	auipc	s1,0x5
    800014b0:	f344a483          	lw	s1,-204(s1) # 800063e0 <h+0x140>
    800014b4:	2495                	addiw	s1,s1,5
    800014b6:	4795                	li	a5,5
    800014b8:	02f4e4bb          	remw	s1,s1,a5
    800014bc:	4915                	li	s2,5
        if (i >= MAX_HISTORY_NUM)
            i = i % MAX_HISTORY_NUM;
        if (h.cmdlist[i][0] == '\0') 
    800014be:	00005997          	auipc	s3,0x5
    800014c2:	d6298993          	addi	s3,s3,-670 # 80006220 <cpus>
            continue;
        else {
            printf("#%d\t%s\n", k, h.cmdlist[i]);
    800014c6:	00005b97          	auipc	s7,0x5
    800014ca:	ddab8b93          	addi	s7,s7,-550 # 800062a0 <h>
    800014ce:	00003b17          	auipc	s6,0x3
    800014d2:	ef2b0b13          	addi	s6,s6,-270 # 800043c0 <digits+0x370>
        if (i >= MAX_HISTORY_NUM)
    800014d6:	4a11                	li	s4,4
            i = i % MAX_HISTORY_NUM;
    800014d8:	4a95                	li	s5,5
    800014da:	a821                	j	800014f2 <showHistory+0x5c>
    for (int k = MAX_HISTORY_NUM, i = (MAX_HISTORY_NUM + startP) % MAX_HISTORY_NUM; k > 0; i++, k--) {
    800014dc:	0014879b          	addiw	a5,s1,1
    800014e0:	0007849b          	sext.w	s1,a5
    800014e4:	397d                	addiw	s2,s2,-1
    800014e6:	02090763          	beqz	s2,80001514 <showHistory+0x7e>
        if (i >= MAX_HISTORY_NUM)
    800014ea:	009a5463          	bge	s4,s1,800014f2 <showHistory+0x5c>
            i = i % MAX_HISTORY_NUM;
    800014ee:	0357e4bb          	remw	s1,a5,s5
    800014f2:	0009059b          	sext.w	a1,s2
        if (h.cmdlist[i][0] == '\0') 
    800014f6:	00649793          	slli	a5,s1,0x6
    800014fa:	97ce                	add	a5,a5,s3
    800014fc:	0807c783          	lbu	a5,128(a5)
    80001500:	dff1                	beqz	a5,800014dc <showHistory+0x46>
            printf("#%d\t%s\n", k, h.cmdlist[i]);
    80001502:	00649613          	slli	a2,s1,0x6
    80001506:	965e                	add	a2,a2,s7
    80001508:	855a                	mv	a0,s6
    8000150a:	fffff097          	auipc	ra,0xfffff
    8000150e:	fc8080e7          	jalr	-56(ra) # 800004d2 <printf>
    80001512:	b7e9                	j	800014dc <showHistory+0x46>
        }
    }
    exit(0);
    80001514:	4501                	li	a0,0
    80001516:	00000097          	auipc	ra,0x0
    8000151a:	d42080e7          	jalr	-702(ra) # 80001258 <exit>
}
    8000151e:	60a6                	ld	ra,72(sp)
    80001520:	6406                	ld	s0,64(sp)
    80001522:	74e2                	ld	s1,56(sp)
    80001524:	7942                	ld	s2,48(sp)
    80001526:	79a2                	ld	s3,40(sp)
    80001528:	7a02                	ld	s4,32(sp)
    8000152a:	6ae2                	ld	s5,24(sp)
    8000152c:	6b42                	ld	s6,16(sp)
    8000152e:	6ba2                	ld	s7,8(sp)
    80001530:	6161                	addi	sp,sp,80
    80001532:	8082                	ret

0000000080001534 <exec>:

// 使进程执行其他函数
void exec(uint64 fn) {
    80001534:	7179                	addi	sp,sp,-48
    80001536:	f406                	sd	ra,40(sp)
    80001538:	f022                	sd	s0,32(sp)
    8000153a:	ec26                	sd	s1,24(sp)
    8000153c:	e84a                	sd	s2,16(sp)
    8000153e:	e44e                	sd	s3,8(sp)
    80001540:	e052                	sd	s4,0(sp)
    80001542:	1800                	addi	s0,sp,48
    80001544:	892a                	mv	s2,a0
    80001546:	8792                	mv	a5,tp
    return mycpu()->proc;
    80001548:	00005997          	auipc	s3,0x5
    8000154c:	cd898993          	addi	s3,s3,-808 # 80006220 <cpus>
    80001550:	2781                	sext.w	a5,a5
    80001552:	079e                	slli	a5,a5,0x7
    80001554:	97ce                	add	a5,a5,s3
    80001556:	6384                	ld	s1,0(a5)
    struct proc *p = myproc();
    memset(&p->context, 0, sizeof(struct context));
    80001558:	17048a13          	addi	s4,s1,368
    8000155c:	07000613          	li	a2,112
    80001560:	4581                	li	a1,0
    80001562:	8552                	mv	a0,s4
    80001564:	00000097          	auipc	ra,0x0
    80001568:	348080e7          	jalr	840(ra) # 800018ac <memset>
    p->state = RUNNABLE;
    8000156c:	4789                	li	a5,2
    8000156e:	c09c                	sw	a5,0(s1)
    p->context.sp = p->kstack + PGSIZE;
    80001570:	1684b783          	ld	a5,360(s1)
    80001574:	6705                	lui	a4,0x1
    80001576:	97ba                	add	a5,a5,a4
    80001578:	16f4bc23          	sd	a5,376(s1)
    spin_lock(&p->proc_lock);
    8000157c:	14848513          	addi	a0,s1,328
    80001580:	00002097          	auipc	ra,0x2
    80001584:	c3a080e7          	jalr	-966(ra) # 800031ba <spin_lock>
    p->trapframe.a0 = fn;
    80001588:	0924bc23          	sd	s2,152(s1)
    8000158c:	8592                	mv	a1,tp
    execra(&p->context, &mycpu()->context, (uint64)execret);
    8000158e:	2581                	sext.w	a1,a1
    80001590:	059e                	slli	a1,a1,0x7
    80001592:	05a1                	addi	a1,a1,8
    80001594:	fffff617          	auipc	a2,0xfffff
    80001598:	5d460613          	addi	a2,a2,1492 # 80000b68 <execret>
    8000159c:	95ce                	add	a1,a1,s3
    8000159e:	8552                	mv	a0,s4
    800015a0:	00000097          	auipc	ra,0x0
    800015a4:	5e0080e7          	jalr	1504(ra) # 80001b80 <execra>
    // 不会返回
    panic("exec");
    800015a8:	00003517          	auipc	a0,0x3
    800015ac:	e2050513          	addi	a0,a0,-480 # 800043c8 <digits+0x378>
    800015b0:	fffff097          	auipc	ra,0xfffff
    800015b4:	1c0080e7          	jalr	448(ra) # 80000770 <panic>
}
    800015b8:	70a2                	ld	ra,40(sp)
    800015ba:	7402                	ld	s0,32(sp)
    800015bc:	64e2                	ld	s1,24(sp)
    800015be:	6942                	ld	s2,16(sp)
    800015c0:	69a2                	ld	s3,8(sp)
    800015c2:	6a02                	ld	s4,0(sp)
    800015c4:	6145                	addi	sp,sp,48
    800015c6:	8082                	ret

00000000800015c8 <run>:

void run(uint64 fn)
{
    800015c8:	1101                	addi	sp,sp,-32
    800015ca:	ec06                	sd	ra,24(sp)
    800015cc:	e822                	sd	s0,16(sp)
    800015ce:	e426                	sd	s1,8(sp)
    800015d0:	1000                	addi	s0,sp,32
    800015d2:	84aa                	mv	s1,a0
    if (fork() > 0) {
    800015d4:	00000097          	auipc	ra,0x0
    800015d8:	468080e7          	jalr	1128(ra) # 80001a3c <fork>
    800015dc:	00a05c63          	blez	a0,800015f4 <run+0x2c>
        wait(0);
    800015e0:	4501                	li	a0,0
    800015e2:	00000097          	auipc	ra,0x0
    800015e6:	b80080e7          	jalr	-1152(ra) # 80001162 <wait>
    } else {
        exec(fn);
    }
}
    800015ea:	60e2                	ld	ra,24(sp)
    800015ec:	6442                	ld	s0,16(sp)
    800015ee:	64a2                	ld	s1,8(sp)
    800015f0:	6105                	addi	sp,sp,32
    800015f2:	8082                	ret
        exec(fn);
    800015f4:	8526                	mv	a0,s1
    800015f6:	00000097          	auipc	ra,0x0
    800015fa:	f3e080e7          	jalr	-194(ra) # 80001534 <exec>
}
    800015fe:	b7f5                	j	800015ea <run+0x22>

0000000080001600 <runcmd>:
void runcmd(char* cmdstr)
{
    80001600:	1101                	addi	sp,sp,-32
    80001602:	ec06                	sd	ra,24(sp)
    80001604:	e822                	sd	s0,16(sp)
    80001606:	e426                	sd	s1,8(sp)
    80001608:	1000                	addi	s0,sp,32
    8000160a:	84aa                	mv	s1,a0
    if (strlen(cmdstr) == 0)
    8000160c:	00000097          	auipc	ra,0x0
    80001610:	322080e7          	jalr	802(ra) # 8000192e <strlen>
    80001614:	0005079b          	sext.w	a5,a0
    80001618:	e791                	bnez	a5,80001624 <runcmd+0x24>
        run((uint64)mew);
    else {
        puts("■■No such command.");
        return;
    }
}
    8000161a:	60e2                	ld	ra,24(sp)
    8000161c:	6442                	ld	s0,16(sp)
    8000161e:	64a2                	ld	s1,8(sp)
    80001620:	6105                	addi	sp,sp,32
    80001622:	8082                	ret
    else if (strcmp(cmdstr, "hello") == 0)
    80001624:	00003597          	auipc	a1,0x3
    80001628:	dac58593          	addi	a1,a1,-596 # 800043d0 <digits+0x380>
    8000162c:	8526                	mv	a0,s1
    8000162e:	fffff097          	auipc	ra,0xfffff
    80001632:	596080e7          	jalr	1430(ra) # 80000bc4 <strcmp>
    80001636:	e911                	bnez	a0,8000164a <runcmd+0x4a>
        run((uint64)hello);
    80001638:	00000517          	auipc	a0,0x0
    8000163c:	c9650513          	addi	a0,a0,-874 # 800012ce <hello>
    80001640:	00000097          	auipc	ra,0x0
    80001644:	f88080e7          	jalr	-120(ra) # 800015c8 <run>
    80001648:	bfc9                	j	8000161a <runcmd+0x1a>
    else if (strcmp(cmdstr, "help") == 0)
    8000164a:	00003597          	auipc	a1,0x3
    8000164e:	d8e58593          	addi	a1,a1,-626 # 800043d8 <digits+0x388>
    80001652:	8526                	mv	a0,s1
    80001654:	fffff097          	auipc	ra,0xfffff
    80001658:	570080e7          	jalr	1392(ra) # 80000bc4 <strcmp>
    8000165c:	e911                	bnez	a0,80001670 <runcmd+0x70>
        run((uint64)help);
    8000165e:	00000517          	auipc	a0,0x0
    80001662:	dae50513          	addi	a0,a0,-594 # 8000140c <help>
    80001666:	00000097          	auipc	ra,0x0
    8000166a:	f62080e7          	jalr	-158(ra) # 800015c8 <run>
    8000166e:	b775                	j	8000161a <runcmd+0x1a>
    else if (strcmp(cmdstr, "history") == 0)
    80001670:	00003597          	auipc	a1,0x3
    80001674:	d7058593          	addi	a1,a1,-656 # 800043e0 <digits+0x390>
    80001678:	8526                	mv	a0,s1
    8000167a:	fffff097          	auipc	ra,0xfffff
    8000167e:	54a080e7          	jalr	1354(ra) # 80000bc4 <strcmp>
    80001682:	e911                	bnez	a0,80001696 <runcmd+0x96>
        run((uint64)showHistory);
    80001684:	00000517          	auipc	a0,0x0
    80001688:	e1250513          	addi	a0,a0,-494 # 80001496 <showHistory>
    8000168c:	00000097          	auipc	ra,0x0
    80001690:	f3c080e7          	jalr	-196(ra) # 800015c8 <run>
    80001694:	b759                	j	8000161a <runcmd+0x1a>
    else if(strcmp(cmdstr, "cowsay") == 0)
    80001696:	00003597          	auipc	a1,0x3
    8000169a:	d5258593          	addi	a1,a1,-686 # 800043e8 <digits+0x398>
    8000169e:	8526                	mv	a0,s1
    800016a0:	fffff097          	auipc	ra,0xfffff
    800016a4:	524080e7          	jalr	1316(ra) # 80000bc4 <strcmp>
    800016a8:	e911                	bnez	a0,800016bc <runcmd+0xbc>
        run((uint64)cowsay);
    800016aa:	00000517          	auipc	a0,0x0
    800016ae:	c4e50513          	addi	a0,a0,-946 # 800012f8 <cowsay>
    800016b2:	00000097          	auipc	ra,0x0
    800016b6:	f16080e7          	jalr	-234(ra) # 800015c8 <run>
    800016ba:	b785                	j	8000161a <runcmd+0x1a>
    else if(strcmp(cmdstr, "mew") == 0)
    800016bc:	00003597          	auipc	a1,0x3
    800016c0:	cfc58593          	addi	a1,a1,-772 # 800043b8 <digits+0x368>
    800016c4:	8526                	mv	a0,s1
    800016c6:	fffff097          	auipc	ra,0xfffff
    800016ca:	4fe080e7          	jalr	1278(ra) # 80000bc4 <strcmp>
    800016ce:	e911                	bnez	a0,800016e2 <runcmd+0xe2>
        run((uint64)mew);
    800016d0:	00000517          	auipc	a0,0x0
    800016d4:	cc250513          	addi	a0,a0,-830 # 80001392 <mew>
    800016d8:	00000097          	auipc	ra,0x0
    800016dc:	ef0080e7          	jalr	-272(ra) # 800015c8 <run>
    800016e0:	bf2d                	j	8000161a <runcmd+0x1a>
        puts("■■No such command.");
    800016e2:	00003517          	auipc	a0,0x3
    800016e6:	d0e50513          	addi	a0,a0,-754 # 800043f0 <digits+0x3a0>
    800016ea:	fffff097          	auipc	ra,0xfffff
    800016ee:	e1e080e7          	jalr	-482(ra) # 80000508 <puts>
        return;
    800016f2:	b725                	j	8000161a <runcmd+0x1a>

00000000800016f4 <osh>:
{
    800016f4:	7119                	addi	sp,sp,-128
    800016f6:	fc86                	sd	ra,120(sp)
    800016f8:	f8a2                	sd	s0,112(sp)
    800016fa:	f4a6                	sd	s1,104(sp)
    800016fc:	f0ca                	sd	s2,96(sp)
    800016fe:	ecce                	sd	s3,88(sp)
    80001700:	e8d2                	sd	s4,80(sp)
    80001702:	e4d6                	sd	s5,72(sp)
    80001704:	e0da                	sd	s6,64(sp)
    80001706:	0100                	addi	s0,sp,128
    printf("\n==========================Start OS=========================\n");
    80001708:	00003517          	auipc	a0,0x3
    8000170c:	d0050513          	addi	a0,a0,-768 # 80004408 <digits+0x3b8>
    80001710:	fffff097          	auipc	ra,0xfffff
    80001714:	dc2080e7          	jalr	-574(ra) # 800004d2 <printf>
    puts("Welcome to startOS! Use following commands to get started.");
    80001718:	00003517          	auipc	a0,0x3
    8000171c:	d3050513          	addi	a0,a0,-720 # 80004448 <digits+0x3f8>
    80001720:	fffff097          	auipc	ra,0xfffff
    80001724:	de8080e7          	jalr	-536(ra) # 80000508 <puts>
    puts("  * hello - print test hello world message");
    80001728:	00003517          	auipc	a0,0x3
    8000172c:	d6050513          	addi	a0,a0,-672 # 80004488 <digits+0x438>
    80001730:	fffff097          	auipc	ra,0xfffff
    80001734:	dd8080e7          	jalr	-552(ra) # 80000508 <puts>
    puts("  * help - list all available commands");
    80001738:	00003517          	auipc	a0,0x3
    8000173c:	d8050513          	addi	a0,a0,-640 # 800044b8 <digits+0x468>
    80001740:	fffff097          	auipc	ra,0xfffff
    80001744:	dc8080e7          	jalr	-568(ra) # 80000508 <puts>
    h.currentP = 0; //当前指令即将写入的位置
    80001748:	00005797          	auipc	a5,0x5
    8000174c:	c807ac23          	sw	zero,-872(a5) # 800063e0 <h+0x140>
        printf("osh>> ");
    80001750:	00003497          	auipc	s1,0x3
    80001754:	d9048493          	addi	s1,s1,-624 # 800044e0 <digits+0x490>
            if (strcmp(buf, "!!") == 0)
    80001758:	00003997          	auipc	s3,0x3
    8000175c:	d9098993          	addi	s3,s3,-624 # 800044e8 <digits+0x498>
                if (h.currentP >= MAX_HISTORY_NUM)
    80001760:	00005917          	auipc	s2,0x5
    80001764:	ac090913          	addi	s2,s2,-1344 # 80006220 <cpus>
    80001768:	4a91                	li	s5,4
                strcpy(h.cmdlist[h.currentP++], buf);
    8000176a:	00005a17          	auipc	s4,0x5
    8000176e:	b36a0a13          	addi	s4,s4,-1226 # 800062a0 <h>
                    h.currentP = h.currentP % MAX_HISTORY_NUM;
    80001772:	4b15                	li	s6,5
    80001774:	a82d                	j	800017ae <osh+0xba>
                runcmd(buf);
    80001776:	f8040513          	addi	a0,s0,-128
    8000177a:	00000097          	auipc	ra,0x0
    8000177e:	e86080e7          	jalr	-378(ra) # 80001600 <runcmd>
                if (h.currentP >= MAX_HISTORY_NUM)
    80001782:	1c092783          	lw	a5,448(s2)
    80001786:	00fad663          	bge	s5,a5,80001792 <osh+0x9e>
                    h.currentP = h.currentP % MAX_HISTORY_NUM;
    8000178a:	0367e7bb          	remw	a5,a5,s6
    8000178e:	1cf92023          	sw	a5,448(s2)
                strcpy(h.cmdlist[h.currentP++], buf);
    80001792:	1c092503          	lw	a0,448(s2)
    80001796:	0015079b          	addiw	a5,a0,1
    8000179a:	1cf92023          	sw	a5,448(s2)
    8000179e:	051a                	slli	a0,a0,0x6
    800017a0:	f8040593          	addi	a1,s0,-128
    800017a4:	9552                	add	a0,a0,s4
    800017a6:	fffff097          	auipc	ra,0xfffff
    800017aa:	402080e7          	jalr	1026(ra) # 80000ba8 <strcpy>
        printf("osh>> ");
    800017ae:	8526                	mv	a0,s1
    800017b0:	fffff097          	auipc	ra,0xfffff
    800017b4:	d22080e7          	jalr	-734(ra) # 800004d2 <printf>
        if (read_line(buf) != 0) {
    800017b8:	f8040513          	addi	a0,s0,-128
    800017bc:	fffff097          	auipc	ra,0xfffff
    800017c0:	d88080e7          	jalr	-632(ra) # 80000544 <read_line>
    800017c4:	d56d                	beqz	a0,800017ae <osh+0xba>
            if (strcmp(buf, "!!") == 0)
    800017c6:	85ce                	mv	a1,s3
    800017c8:	f8040513          	addi	a0,s0,-128
    800017cc:	fffff097          	auipc	ra,0xfffff
    800017d0:	3f8080e7          	jalr	1016(ra) # 80000bc4 <strcmp>
    800017d4:	f14d                	bnez	a0,80001776 <osh+0x82>
                showHistory();
    800017d6:	00000097          	auipc	ra,0x0
    800017da:	cc0080e7          	jalr	-832(ra) # 80001496 <showHistory>
    800017de:	bfc1                	j	800017ae <osh+0xba>

00000000800017e0 <init>:
void init() {
    800017e0:	1141                	addi	sp,sp,-16
    800017e2:	e406                	sd	ra,8(sp)
    800017e4:	e022                	sd	s0,0(sp)
    800017e6:	0800                	addi	s0,sp,16
    800017e8:	8792                	mv	a5,tp
    return mycpu()->proc;
    800017ea:	2781                	sext.w	a5,a5
    800017ec:	079e                	slli	a5,a5,0x7
    800017ee:	00005717          	auipc	a4,0x5
    800017f2:	a3270713          	addi	a4,a4,-1486 # 80006220 <cpus>
    800017f6:	97ba                	add	a5,a5,a4
    spin_unlock(&myproc()->proc_lock);
    800017f8:	6388                	ld	a0,0(a5)
    800017fa:	14850513          	addi	a0,a0,328
    800017fe:	00002097          	auipc	ra,0x2
    80001802:	a90080e7          	jalr	-1392(ra) # 8000328e <spin_unlock>
    int pid = fork();
    80001806:	00000097          	auipc	ra,0x0
    8000180a:	236080e7          	jalr	566(ra) # 80001a3c <fork>
    if (pid < 0) {
    8000180e:	00054d63          	bltz	a0,80001828 <init+0x48>
    } else if (pid == 0) {
    80001812:	c505                	beqz	a0,8000183a <init+0x5a>
    init_fs();
    80001814:	00001097          	auipc	ra,0x1
    80001818:	ac8080e7          	jalr	-1336(ra) # 800022dc <init_fs>
        wait(0);
    8000181c:	4501                	li	a0,0
    8000181e:	00000097          	auipc	ra,0x0
    80001822:	944080e7          	jalr	-1724(ra) # 80001162 <wait>
    for (;;) {
    80001826:	bfdd                	j	8000181c <init+0x3c>
        panic("init");
    80001828:	00003517          	auipc	a0,0x3
    8000182c:	cc850513          	addi	a0,a0,-824 # 800044f0 <digits+0x4a0>
    80001830:	fffff097          	auipc	ra,0xfffff
    80001834:	f40080e7          	jalr	-192(ra) # 80000770 <panic>
    80001838:	bff1                	j	80001814 <init+0x34>
        exec((uint64) osh);
    8000183a:	00000517          	auipc	a0,0x0
    8000183e:	eba50513          	addi	a0,a0,-326 # 800016f4 <osh>
    80001842:	00000097          	auipc	ra,0x0
    80001846:	cf2080e7          	jalr	-782(ra) # 80001534 <exec>
    8000184a:	b7e9                	j	80001814 <init+0x34>

000000008000184c <print_proc>:

void print_proc() {
    8000184c:	7179                	addi	sp,sp,-48
    8000184e:	f406                	sd	ra,40(sp)
    80001850:	f022                	sd	s0,32(sp)
    80001852:	ec26                	sd	s1,24(sp)
    80001854:	e84a                	sd	s2,16(sp)
    80001856:	e44e                	sd	s3,8(sp)
    80001858:	1800                	addi	s0,sp,48
    struct proc *p;
    printf(" \npid\tstate\n");
    8000185a:	00003517          	auipc	a0,0x3
    8000185e:	c9e50513          	addi	a0,a0,-866 # 800044f8 <digits+0x4a8>
    80001862:	fffff097          	auipc	ra,0xfffff
    80001866:	c70080e7          	jalr	-912(ra) # 800004d2 <printf>
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    8000186a:	00046497          	auipc	s1,0x46
    8000186e:	b7e48493          	addi	s1,s1,-1154 # 800473e8 <proc_table>
        if (p->state == UNUSED)
            continue;
        printf(" %d\t  %d\n", p->pid, p->state);
    80001872:	00003997          	auipc	s3,0x3
    80001876:	c9698993          	addi	s3,s3,-874 # 80004508 <digits+0x4b8>
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    8000187a:	0004d917          	auipc	s2,0x4d
    8000187e:	76e90913          	addi	s2,s2,1902 # 8004efe8 <proc_table+0x7c00>
    80001882:	a029                	j	8000188c <print_proc+0x40>
    80001884:	1f048493          	addi	s1,s1,496
    80001888:	01248b63          	beq	s1,s2,8000189e <print_proc+0x52>
        if (p->state == UNUSED)
    8000188c:	4090                	lw	a2,0(s1)
    8000188e:	da7d                	beqz	a2,80001884 <print_proc+0x38>
        printf(" %d\t  %d\n", p->pid, p->state);
    80001890:	508c                	lw	a1,32(s1)
    80001892:	854e                	mv	a0,s3
    80001894:	fffff097          	auipc	ra,0xfffff
    80001898:	c3e080e7          	jalr	-962(ra) # 800004d2 <printf>
    8000189c:	b7e5                	j	80001884 <print_proc+0x38>
    }
}
    8000189e:	70a2                	ld	ra,40(sp)
    800018a0:	7402                	ld	s0,32(sp)
    800018a2:	64e2                	ld	s1,24(sp)
    800018a4:	6942                	ld	s2,16(sp)
    800018a6:	69a2                	ld	s3,8(sp)
    800018a8:	6145                	addi	sp,sp,48
    800018aa:	8082                	ret

00000000800018ac <memset>:
#include "types.h"

void *memset(void *dst, int c, uint n) {
    800018ac:	1141                	addi	sp,sp,-16
    800018ae:	e422                	sd	s0,8(sp)
    800018b0:	0800                	addi	s0,sp,16
    char *cdst = (char *) dst;
    int i;
    for (i = 0; i < n; i++) {
    800018b2:	ce09                	beqz	a2,800018cc <memset+0x20>
    800018b4:	87aa                	mv	a5,a0
    800018b6:	fff6071b          	addiw	a4,a2,-1
    800018ba:	1702                	slli	a4,a4,0x20
    800018bc:	9301                	srli	a4,a4,0x20
    800018be:	0705                	addi	a4,a4,1
    800018c0:	972a                	add	a4,a4,a0
        cdst[i] = c;
    800018c2:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++) {
    800018c6:	0785                	addi	a5,a5,1
    800018c8:	fee79de3          	bne	a5,a4,800018c2 <memset+0x16>
    }
    return dst;
}
    800018cc:	6422                	ld	s0,8(sp)
    800018ce:	0141                	addi	sp,sp,16
    800018d0:	8082                	ret

00000000800018d2 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
    800018d2:	1141                	addi	sp,sp,-16
    800018d4:	e422                	sd	s0,8(sp)
    800018d6:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst) {
    800018d8:	02b57663          	bgeu	a0,a1,80001904 <memmove+0x32>
        while (n-- > 0)
    800018dc:	02c05163          	blez	a2,800018fe <memmove+0x2c>
    800018e0:	fff6079b          	addiw	a5,a2,-1
    800018e4:	1782                	slli	a5,a5,0x20
    800018e6:	9381                	srli	a5,a5,0x20
    800018e8:	0785                	addi	a5,a5,1
    800018ea:	97aa                	add	a5,a5,a0
    dst = vdst;
    800018ec:	872a                	mv	a4,a0
            *dst++ = *src++;
    800018ee:	0585                	addi	a1,a1,1
    800018f0:	0705                	addi	a4,a4,1
    800018f2:	fff5c683          	lbu	a3,-1(a1)
    800018f6:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
    800018fa:	fee79ae3          	bne	a5,a4,800018ee <memmove+0x1c>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
    800018fe:	6422                	ld	s0,8(sp)
    80001900:	0141                	addi	sp,sp,16
    80001902:	8082                	ret
        dst += n;
    80001904:	00c50733          	add	a4,a0,a2
        src += n;
    80001908:	95b2                	add	a1,a1,a2
        while (n-- > 0)
    8000190a:	fec05ae3          	blez	a2,800018fe <memmove+0x2c>
    8000190e:	fff6079b          	addiw	a5,a2,-1
    80001912:	1782                	slli	a5,a5,0x20
    80001914:	9381                	srli	a5,a5,0x20
    80001916:	fff7c793          	not	a5,a5
    8000191a:	97ba                	add	a5,a5,a4
            *--dst = *--src;
    8000191c:	15fd                	addi	a1,a1,-1
    8000191e:	177d                	addi	a4,a4,-1
    80001920:	0005c683          	lbu	a3,0(a1)
    80001924:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
    80001928:	fee79ae3          	bne	a5,a4,8000191c <memmove+0x4a>
    8000192c:	bfc9                	j	800018fe <memmove+0x2c>

000000008000192e <strlen>:

uint strlen(const char *s) {
    8000192e:	1141                	addi	sp,sp,-16
    80001930:	e422                	sd	s0,8(sp)
    80001932:	0800                	addi	s0,sp,16
    int n;
    for (n = 0; s[n]; n++);
    80001934:	00054783          	lbu	a5,0(a0)
    80001938:	cf91                	beqz	a5,80001954 <strlen+0x26>
    8000193a:	0505                	addi	a0,a0,1
    8000193c:	87aa                	mv	a5,a0
    8000193e:	4685                	li	a3,1
    80001940:	9e89                	subw	a3,a3,a0
    80001942:	00f6853b          	addw	a0,a3,a5
    80001946:	0785                	addi	a5,a5,1
    80001948:	fff7c703          	lbu	a4,-1(a5)
    8000194c:	fb7d                	bnez	a4,80001942 <strlen+0x14>
    return n;
}
    8000194e:	6422                	ld	s0,8(sp)
    80001950:	0141                	addi	sp,sp,16
    80001952:	8082                	ret
    for (n = 0; s[n]; n++);
    80001954:	4501                	li	a0,0
    80001956:	bfe5                	j	8000194e <strlen+0x20>

0000000080001958 <strncpy>:

char * strncpy(char *s, const char *t, int n) {
    80001958:	1141                	addi	sp,sp,-16
    8000195a:	e422                	sd	s0,8(sp)
    8000195c:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while (n-- > 0 && (*s++ = *t++) != 0);
    8000195e:	872a                	mv	a4,a0
    80001960:	8832                	mv	a6,a2
    80001962:	367d                	addiw	a2,a2,-1
    80001964:	01005963          	blez	a6,80001976 <strncpy+0x1e>
    80001968:	0705                	addi	a4,a4,1
    8000196a:	0005c783          	lbu	a5,0(a1)
    8000196e:	fef70fa3          	sb	a5,-1(a4)
    80001972:	0585                	addi	a1,a1,1
    80001974:	f7f5                	bnez	a5,80001960 <strncpy+0x8>
    while (n-- > 0)
    80001976:	00c05d63          	blez	a2,80001990 <strncpy+0x38>
    8000197a:	86ba                	mv	a3,a4
        *s++ = 0;
    8000197c:	0685                	addi	a3,a3,1
    8000197e:	fe068fa3          	sb	zero,-1(a3)
    while (n-- > 0)
    80001982:	fff6c793          	not	a5,a3
    80001986:	9fb9                	addw	a5,a5,a4
    80001988:	010787bb          	addw	a5,a5,a6
    8000198c:	fef048e3          	bgtz	a5,8000197c <strncpy+0x24>
    return os;
}
    80001990:	6422                	ld	s0,8(sp)
    80001992:	0141                	addi	sp,sp,16
    80001994:	8082                	ret

0000000080001996 <strncmp>:
int strncmp(const char *p, const char *q, uint n)
{
    80001996:	1141                	addi	sp,sp,-16
    80001998:	e422                	sd	s0,8(sp)
    8000199a:	0800                	addi	s0,sp,16
    while(n > 0 && *p && *p == *q)
    8000199c:	ce11                	beqz	a2,800019b8 <strncmp+0x22>
    8000199e:	00054783          	lbu	a5,0(a0)
    800019a2:	cf89                	beqz	a5,800019bc <strncmp+0x26>
    800019a4:	0005c703          	lbu	a4,0(a1)
    800019a8:	00f71a63          	bne	a4,a5,800019bc <strncmp+0x26>
        n--, p++, q++;
    800019ac:	367d                	addiw	a2,a2,-1
    800019ae:	0505                	addi	a0,a0,1
    800019b0:	0585                	addi	a1,a1,1
    while(n > 0 && *p && *p == *q)
    800019b2:	f675                	bnez	a2,8000199e <strncmp+0x8>
    if(n == 0)
        return 0;
    800019b4:	4501                	li	a0,0
    800019b6:	a809                	j	800019c8 <strncmp+0x32>
    800019b8:	4501                	li	a0,0
    800019ba:	a039                	j	800019c8 <strncmp+0x32>
    if(n == 0)
    800019bc:	ca09                	beqz	a2,800019ce <strncmp+0x38>
    return (uchar)*p - (uchar)*q;
    800019be:	00054503          	lbu	a0,0(a0)
    800019c2:	0005c783          	lbu	a5,0(a1)
    800019c6:	9d1d                	subw	a0,a0,a5
}
    800019c8:	6422                	ld	s0,8(sp)
    800019ca:	0141                	addi	sp,sp,16
    800019cc:	8082                	ret
        return 0;
    800019ce:	4501                	li	a0,0
    800019d0:	bfe5                	j	800019c8 <strncmp+0x32>

00000000800019d2 <pswitch>:
    800019d2:	00153023          	sd	ra,0(a0)
    800019d6:	00253423          	sd	sp,8(a0)
    800019da:	e900                	sd	s0,16(a0)
    800019dc:	ed04                	sd	s1,24(a0)
    800019de:	03253023          	sd	s2,32(a0)
    800019e2:	03353423          	sd	s3,40(a0)
    800019e6:	03453823          	sd	s4,48(a0)
    800019ea:	03553c23          	sd	s5,56(a0)
    800019ee:	05653023          	sd	s6,64(a0)
    800019f2:	05753423          	sd	s7,72(a0)
    800019f6:	05853823          	sd	s8,80(a0)
    800019fa:	05953c23          	sd	s9,88(a0)
    800019fe:	07a53023          	sd	s10,96(a0)
    80001a02:	07b53423          	sd	s11,104(a0)
    80001a06:	0005b083          	ld	ra,0(a1)
    80001a0a:	0085b103          	ld	sp,8(a1)
    80001a0e:	6980                	ld	s0,16(a1)
    80001a10:	6d84                	ld	s1,24(a1)
    80001a12:	0205b903          	ld	s2,32(a1)
    80001a16:	0285b983          	ld	s3,40(a1)
    80001a1a:	0305ba03          	ld	s4,48(a1)
    80001a1e:	0385ba83          	ld	s5,56(a1)
    80001a22:	0405bb03          	ld	s6,64(a1)
    80001a26:	0485bb83          	ld	s7,72(a1)
    80001a2a:	0505bc03          	ld	s8,80(a1)
    80001a2e:	0585bc83          	ld	s9,88(a1)
    80001a32:	0605bd03          	ld	s10,96(a1)
    80001a36:	0685bd83          	ld	s11,104(a1)
    80001a3a:	8082                	ret

0000000080001a3c <fork>:
// fork的简单实现
// fork失败返回-1
// 父进程返回子进程id
// 子进程返回0
//
int fork() {
    80001a3c:	1101                	addi	sp,sp,-32
    80001a3e:	ec06                	sd	ra,24(sp)
    80001a40:	e822                	sd	s0,16(sp)
    80001a42:	e426                	sd	s1,8(sp)
    80001a44:	e04a                	sd	s2,0(sp)
    80001a46:	1000                	addi	s0,sp,32
    struct proc *p;
    struct proc *np;
    if ((np = alloc_proc()) == 0) {
    80001a48:	fffff097          	auipc	ra,0xfffff
    80001a4c:	304080e7          	jalr	772(ra) # 80000d4c <alloc_proc>
    80001a50:	c151                	beqz	a0,80001ad4 <fork+0x98>
    80001a52:	84aa                	mv	s1,a0
        return -1;
    }
    p = myproc();
    80001a54:	fffff097          	auipc	ra,0xfffff
    80001a58:	3e6080e7          	jalr	998(ra) # 80000e3a <myproc>
    80001a5c:	892a                	mv	s2,a0
    memmove((char *) np->kstack, (char *) p->kstack, PGSIZE);
    80001a5e:	6605                	lui	a2,0x1
    80001a60:	16853583          	ld	a1,360(a0)
    80001a64:	1684b503          	ld	a0,360(s1)
    80001a68:	00000097          	auipc	ra,0x0
    80001a6c:	e6a080e7          	jalr	-406(ra) # 800018d2 <memmove>
    np->parent = p;
    80001a70:	0124b423          	sd	s2,8(s1)
    np->state = RUNNABLE;
    80001a74:	4789                	li	a5,2
    80001a76:	c09c                	sw	a5,0(s1)
    np->current_dir = dup_inode(p->current_dir);
    80001a78:	16093503          	ld	a0,352(s2)
    80001a7c:	00001097          	auipc	ra,0x1
    80001a80:	e5a080e7          	jalr	-422(ra) # 800028d6 <dup_inode>
    80001a84:	16a4b023          	sd	a0,352(s1)
    forkra(&np->context, p->kstack, np->kstack);
    80001a88:	1684b603          	ld	a2,360(s1)
    80001a8c:	16893583          	ld	a1,360(s2)
    80001a90:	17048513          	addi	a0,s1,368
    80001a94:	00000097          	auipc	ra,0x0
    80001a98:	0ac080e7          	jalr	172(ra) # 80001b40 <forkra>
    if (myproc() == np) {
    80001a9c:	fffff097          	auipc	ra,0xfffff
    80001aa0:	39e080e7          	jalr	926(ra) # 80000e3a <myproc>
    80001aa4:	02a48163          	beq	s1,a0,80001ac6 <fork+0x8a>
        spin_unlock(&np->proc_lock);
    }
    return myproc() == np ? 0 : np->pid;
    80001aa8:	fffff097          	auipc	ra,0xfffff
    80001aac:	392080e7          	jalr	914(ra) # 80000e3a <myproc>
    80001ab0:	87aa                	mv	a5,a0
    80001ab2:	4501                	li	a0,0
    80001ab4:	00f48363          	beq	s1,a5,80001aba <fork+0x7e>
    80001ab8:	5088                	lw	a0,32(s1)
}
    80001aba:	60e2                	ld	ra,24(sp)
    80001abc:	6442                	ld	s0,16(sp)
    80001abe:	64a2                	ld	s1,8(sp)
    80001ac0:	6902                	ld	s2,0(sp)
    80001ac2:	6105                	addi	sp,sp,32
    80001ac4:	8082                	ret
        spin_unlock(&np->proc_lock);
    80001ac6:	14848513          	addi	a0,s1,328
    80001aca:	00001097          	auipc	ra,0x1
    80001ace:	7c4080e7          	jalr	1988(ra) # 8000328e <spin_unlock>
    80001ad2:	bfd9                	j	80001aa8 <fork+0x6c>
        return -1;
    80001ad4:	557d                	li	a0,-1
    80001ad6:	b7d5                	j	80001aba <fork+0x7e>

0000000080001ad8 <sleep_sec>:

//
// 睡眠指定秒数
//
void sleep_sec(int seconds) {
    80001ad8:	1141                	addi	sp,sp,-16
    80001ada:	e406                	sd	ra,8(sp)
    80001adc:	e022                	sd	s0,0(sp)
    80001ade:	0800                	addi	s0,sp,16
    sleep_time(seconds * 10);
    80001ae0:	0025179b          	slliw	a5,a0,0x2
    80001ae4:	9d3d                	addw	a0,a0,a5
    80001ae6:	0015151b          	slliw	a0,a0,0x1
    80001aea:	fffff097          	auipc	ra,0xfffff
    80001aee:	4ea080e7          	jalr	1258(ra) # 80000fd4 <sleep_time>
}
    80001af2:	60a2                	ld	ra,8(sp)
    80001af4:	6402                	ld	s0,0(sp)
    80001af6:	0141                	addi	sp,sp,16
    80001af8:	8082                	ret

0000000080001afa <yield>:

//
// 让出cpu
//
void yield() {
    80001afa:	1101                	addi	sp,sp,-32
    80001afc:	ec06                	sd	ra,24(sp)
    80001afe:	e822                	sd	s0,16(sp)
    80001b00:	e426                	sd	s1,8(sp)
    80001b02:	e04a                	sd	s2,0(sp)
    80001b04:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    80001b06:	fffff097          	auipc	ra,0xfffff
    80001b0a:	334080e7          	jalr	820(ra) # 80000e3a <myproc>
    80001b0e:	84aa                	mv	s1,a0
    spin_lock(&p->proc_lock);
    80001b10:	14850913          	addi	s2,a0,328
    80001b14:	854a                	mv	a0,s2
    80001b16:	00001097          	auipc	ra,0x1
    80001b1a:	6a4080e7          	jalr	1700(ra) # 800031ba <spin_lock>
    p->state = RUNNABLE;
    80001b1e:	4789                	li	a5,2
    80001b20:	c09c                	sw	a5,0(s1)
    before_sched();
    80001b22:	fffff097          	auipc	ra,0xfffff
    80001b26:	336080e7          	jalr	822(ra) # 80000e58 <before_sched>
    spin_unlock(&p->proc_lock);
    80001b2a:	854a                	mv	a0,s2
    80001b2c:	00001097          	auipc	ra,0x1
    80001b30:	762080e7          	jalr	1890(ra) # 8000328e <spin_unlock>
}
    80001b34:	60e2                	ld	ra,24(sp)
    80001b36:	6442                	ld	s0,16(sp)
    80001b38:	64a2                	ld	s1,8(sp)
    80001b3a:	6902                	ld	s2,0(sp)
    80001b3c:	6105                	addi	sp,sp,32
    80001b3e:	8082                	ret

0000000080001b40 <forkra>:
    80001b40:	40b102b3          	sub	t0,sp,a1
    80001b44:	92b2                	add	t0,t0,a2
    80001b46:	00153023          	sd	ra,0(a0)
    80001b4a:	00553423          	sd	t0,8(a0)
    80001b4e:	e900                	sd	s0,16(a0)
    80001b50:	ed04                	sd	s1,24(a0)
    80001b52:	03253023          	sd	s2,32(a0)
    80001b56:	03353423          	sd	s3,40(a0)
    80001b5a:	03453823          	sd	s4,48(a0)
    80001b5e:	03553c23          	sd	s5,56(a0)
    80001b62:	05653023          	sd	s6,64(a0)
    80001b66:	05753423          	sd	s7,72(a0)
    80001b6a:	05853823          	sd	s8,80(a0)
    80001b6e:	05953c23          	sd	s9,88(a0)
    80001b72:	07a53023          	sd	s10,96(a0)
    80001b76:	07b53423          	sd	s11,104(a0)
    80001b7a:	8082                	ret
    80001b7c:	00000013          	nop

0000000080001b80 <execra>:
    80001b80:	e110                	sd	a2,0(a0)
    80001b82:	0005b083          	ld	ra,0(a1)
    80001b86:	0085b103          	ld	sp,8(a1)
    80001b8a:	6980                	ld	s0,16(a1)
    80001b8c:	6d84                	ld	s1,24(a1)
    80001b8e:	0205b903          	ld	s2,32(a1)
    80001b92:	0285b983          	ld	s3,40(a1)
    80001b96:	0305ba03          	ld	s4,48(a1)
    80001b9a:	0385ba83          	ld	s5,56(a1)
    80001b9e:	0405bb03          	ld	s6,64(a1)
    80001ba2:	0485bb83          	ld	s7,72(a1)
    80001ba6:	0505bc03          	ld	s8,80(a1)
    80001baa:	0585bc83          	ld	s9,88(a1)
    80001bae:	0605bd03          	ld	s10,96(a1)
    80001bb2:	0685bd83          	ld	s11,104(a1)
    80001bb6:	8082                	ret
    80001bb8:	00000013          	nop
    80001bbc:	00000013          	nop

0000000080001bc0 <userret>:
    80001bc0:	00050093          	mv	ra,a0
    80001bc4:	00058113          	mv	sp,a1
    80001bc8:	8082                	ret
	...

0000000080001bd2 <free_desc>:
    return -1;
}

// mark a descriptor as free.
static void
free_desc(int i) {
    80001bd2:	1101                	addi	sp,sp,-32
    80001bd4:	ec06                	sd	ra,24(sp)
    80001bd6:	e822                	sd	s0,16(sp)
    80001bd8:	e426                	sd	s1,8(sp)
    80001bda:	1000                	addi	s0,sp,32
    80001bdc:	84aa                	mv	s1,a0
    if (i >= NUM)
    80001bde:	479d                	li	a5,7
    80001be0:	06a7ca63          	blt	a5,a0,80001c54 <free_desc+0x82>
        panic("free_desc 1");
    if (disk.free[i])
    80001be4:	0004d797          	auipc	a5,0x4d
    80001be8:	41c78793          	addi	a5,a5,1052 # 8004f000 <disk>
    80001bec:	00978733          	add	a4,a5,s1
    80001bf0:	6789                	lui	a5,0x2
    80001bf2:	97ba                	add	a5,a5,a4
    80001bf4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80001bf8:	e7bd                	bnez	a5,80001c66 <free_desc+0x94>
        panic("free_desc 2");
    disk.desc[i].addr = 0;
    80001bfa:	00449793          	slli	a5,s1,0x4
    80001bfe:	0004f717          	auipc	a4,0x4f
    80001c02:	40270713          	addi	a4,a4,1026 # 80051000 <disk+0x2000>
    80001c06:	6314                	ld	a3,0(a4)
    80001c08:	96be                	add	a3,a3,a5
    80001c0a:	0006b023          	sd	zero,0(a3)
    disk.desc[i].len = 0;
    80001c0e:	6314                	ld	a3,0(a4)
    80001c10:	96be                	add	a3,a3,a5
    80001c12:	0006a423          	sw	zero,8(a3)
    disk.desc[i].flags = 0;
    80001c16:	6314                	ld	a3,0(a4)
    80001c18:	96be                	add	a3,a3,a5
    80001c1a:	00069623          	sh	zero,12(a3)
    disk.desc[i].next = 0;
    80001c1e:	6318                	ld	a4,0(a4)
    80001c20:	97ba                	add	a5,a5,a4
    80001c22:	00079723          	sh	zero,14(a5)
    disk.free[i] = 1;
    80001c26:	0004d517          	auipc	a0,0x4d
    80001c2a:	3da50513          	addi	a0,a0,986 # 8004f000 <disk>
    80001c2e:	9526                	add	a0,a0,s1
    80001c30:	6489                	lui	s1,0x2
    80001c32:	94aa                	add	s1,s1,a0
    80001c34:	4785                	li	a5,1
    80001c36:	00f48c23          	sb	a5,24(s1) # 2018 <_entry-0x7fffdfe8>
    wakeup(&disk.free[0]);
    80001c3a:	0004f517          	auipc	a0,0x4f
    80001c3e:	3de50513          	addi	a0,a0,990 # 80051018 <disk+0x2018>
    80001c42:	fffff097          	auipc	ra,0xfffff
    80001c46:	408080e7          	jalr	1032(ra) # 8000104a <wakeup>
}
    80001c4a:	60e2                	ld	ra,24(sp)
    80001c4c:	6442                	ld	s0,16(sp)
    80001c4e:	64a2                	ld	s1,8(sp)
    80001c50:	6105                	addi	sp,sp,32
    80001c52:	8082                	ret
        panic("free_desc 1");
    80001c54:	00003517          	auipc	a0,0x3
    80001c58:	8c450513          	addi	a0,a0,-1852 # 80004518 <digits+0x4c8>
    80001c5c:	fffff097          	auipc	ra,0xfffff
    80001c60:	b14080e7          	jalr	-1260(ra) # 80000770 <panic>
    80001c64:	b741                	j	80001be4 <free_desc+0x12>
        panic("free_desc 2");
    80001c66:	00003517          	auipc	a0,0x3
    80001c6a:	8c250513          	addi	a0,a0,-1854 # 80004528 <digits+0x4d8>
    80001c6e:	fffff097          	auipc	ra,0xfffff
    80001c72:	b02080e7          	jalr	-1278(ra) # 80000770 <panic>
    80001c76:	b751                	j	80001bfa <free_desc+0x28>

0000000080001c78 <virtio_disk_init>:
virtio_disk_init(void) {
    80001c78:	1101                	addi	sp,sp,-32
    80001c7a:	ec06                	sd	ra,24(sp)
    80001c7c:	e822                	sd	s0,16(sp)
    80001c7e:	e426                	sd	s1,8(sp)
    80001c80:	1000                	addi	s0,sp,32
    spinlock_init(&disk.vdisk_lock, "virtio_disk");
    80001c82:	00003597          	auipc	a1,0x3
    80001c86:	8b658593          	addi	a1,a1,-1866 # 80004538 <digits+0x4e8>
    80001c8a:	0004f517          	auipc	a0,0x4f
    80001c8e:	49e50513          	addi	a0,a0,1182 # 80051128 <disk+0x2128>
    80001c92:	00001097          	auipc	ra,0x1
    80001c96:	498080e7          	jalr	1176(ra) # 8000312a <spinlock_init>
    if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80001c9a:	100017b7          	lui	a5,0x10001
    80001c9e:	4398                	lw	a4,0(a5)
    80001ca0:	2701                	sext.w	a4,a4
    80001ca2:	747277b7          	lui	a5,0x74727
    80001ca6:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80001caa:	00f71963          	bne	a4,a5,80001cbc <virtio_disk_init+0x44>
        *R(VIRTIO_MMIO_VERSION) != 1 ||
    80001cae:	100017b7          	lui	a5,0x10001
    80001cb2:	43dc                	lw	a5,4(a5)
    80001cb4:	2781                	sext.w	a5,a5
    if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80001cb6:	4705                	li	a4,1
    80001cb8:	0ce78163          	beq	a5,a4,80001d7a <virtio_disk_init+0x102>
        panic("could not find virtio disk");
    80001cbc:	00003517          	auipc	a0,0x3
    80001cc0:	88c50513          	addi	a0,a0,-1908 # 80004548 <digits+0x4f8>
    80001cc4:	fffff097          	auipc	ra,0xfffff
    80001cc8:	aac080e7          	jalr	-1364(ra) # 80000770 <panic>
    *R(VIRTIO_MMIO_STATUS) = status;
    80001ccc:	100017b7          	lui	a5,0x10001
    80001cd0:	4705                	li	a4,1
    80001cd2:	dbb8                	sw	a4,112(a5)
    *R(VIRTIO_MMIO_STATUS) = status;
    80001cd4:	470d                	li	a4,3
    80001cd6:	dbb8                	sw	a4,112(a5)
    uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80001cd8:	4b94                	lw	a3,16(a5)
    features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80001cda:	c7ffe737          	lui	a4,0xc7ffe
    80001cde:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <buf_cache+0xffffffff47faac87>
    80001ce2:	8f75                	and	a4,a4,a3
    *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80001ce4:	2701                	sext.w	a4,a4
    80001ce6:	d398                	sw	a4,32(a5)
    *R(VIRTIO_MMIO_STATUS) = status;
    80001ce8:	472d                	li	a4,11
    80001cea:	dbb8                	sw	a4,112(a5)
    *R(VIRTIO_MMIO_STATUS) = status;
    80001cec:	473d                	li	a4,15
    80001cee:	dbb8                	sw	a4,112(a5)
    *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80001cf0:	6705                	lui	a4,0x1
    80001cf2:	d798                	sw	a4,40(a5)
    *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80001cf4:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
    uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80001cf8:	5bdc                	lw	a5,52(a5)
    80001cfa:	2781                	sext.w	a5,a5
    if (max == 0)
    80001cfc:	c3cd                	beqz	a5,80001d9e <virtio_disk_init+0x126>
    if (max < NUM)
    80001cfe:	471d                	li	a4,7
    80001d00:	0af77763          	bgeu	a4,a5,80001dae <virtio_disk_init+0x136>
    *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80001d04:	100014b7          	lui	s1,0x10001
    80001d08:	47a1                	li	a5,8
    80001d0a:	dc9c                	sw	a5,56(s1)
    memset(disk.pages, 0, sizeof(disk.pages));
    80001d0c:	6609                	lui	a2,0x2
    80001d0e:	4581                	li	a1,0
    80001d10:	0004d517          	auipc	a0,0x4d
    80001d14:	2f050513          	addi	a0,a0,752 # 8004f000 <disk>
    80001d18:	00000097          	auipc	ra,0x0
    80001d1c:	b94080e7          	jalr	-1132(ra) # 800018ac <memset>
    *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64) disk.pages) >> PGSHIFT;
    80001d20:	0004d717          	auipc	a4,0x4d
    80001d24:	2e070713          	addi	a4,a4,736 # 8004f000 <disk>
    80001d28:	00c75793          	srli	a5,a4,0xc
    80001d2c:	2781                	sext.w	a5,a5
    80001d2e:	c0bc                	sw	a5,64(s1)
    disk.desc = (struct virtq_desc *) disk.pages;
    80001d30:	0004f797          	auipc	a5,0x4f
    80001d34:	2d078793          	addi	a5,a5,720 # 80051000 <disk+0x2000>
    80001d38:	e398                	sd	a4,0(a5)
    disk.avail = (struct virtq_avail *) (disk.pages + NUM * sizeof(struct virtq_desc));
    80001d3a:	0004d717          	auipc	a4,0x4d
    80001d3e:	34670713          	addi	a4,a4,838 # 8004f080 <disk+0x80>
    80001d42:	e798                	sd	a4,8(a5)
    disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80001d44:	0004e717          	auipc	a4,0x4e
    80001d48:	2bc70713          	addi	a4,a4,700 # 80050000 <disk+0x1000>
    80001d4c:	eb98                	sd	a4,16(a5)
        disk.free[i] = 1;
    80001d4e:	4705                	li	a4,1
    80001d50:	00e78c23          	sb	a4,24(a5)
    80001d54:	00e78ca3          	sb	a4,25(a5)
    80001d58:	00e78d23          	sb	a4,26(a5)
    80001d5c:	00e78da3          	sb	a4,27(a5)
    80001d60:	00e78e23          	sb	a4,28(a5)
    80001d64:	00e78ea3          	sb	a4,29(a5)
    80001d68:	00e78f23          	sb	a4,30(a5)
    80001d6c:	00e78fa3          	sb	a4,31(a5)
}
    80001d70:	60e2                	ld	ra,24(sp)
    80001d72:	6442                	ld	s0,16(sp)
    80001d74:	64a2                	ld	s1,8(sp)
    80001d76:	6105                	addi	sp,sp,32
    80001d78:	8082                	ret
        *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80001d7a:	100017b7          	lui	a5,0x10001
    80001d7e:	479c                	lw	a5,8(a5)
    80001d80:	2781                	sext.w	a5,a5
        *R(VIRTIO_MMIO_VERSION) != 1 ||
    80001d82:	4709                	li	a4,2
    80001d84:	f2e79ce3          	bne	a5,a4,80001cbc <virtio_disk_init+0x44>
        *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    80001d88:	100017b7          	lui	a5,0x10001
    80001d8c:	47d8                	lw	a4,12(a5)
    80001d8e:	2701                	sext.w	a4,a4
        *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80001d90:	554d47b7          	lui	a5,0x554d4
    80001d94:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80001d98:	f2f712e3          	bne	a4,a5,80001cbc <virtio_disk_init+0x44>
    80001d9c:	bf05                	j	80001ccc <virtio_disk_init+0x54>
        panic("virtio disk has no queue 0");
    80001d9e:	00002517          	auipc	a0,0x2
    80001da2:	7ca50513          	addi	a0,a0,1994 # 80004568 <digits+0x518>
    80001da6:	fffff097          	auipc	ra,0xfffff
    80001daa:	9ca080e7          	jalr	-1590(ra) # 80000770 <panic>
        panic("virtio disk max queue too short");
    80001dae:	00002517          	auipc	a0,0x2
    80001db2:	7da50513          	addi	a0,a0,2010 # 80004588 <digits+0x538>
    80001db6:	fffff097          	auipc	ra,0xfffff
    80001dba:	9ba080e7          	jalr	-1606(ra) # 80000770 <panic>
    80001dbe:	b799                	j	80001d04 <virtio_disk_init+0x8c>

0000000080001dc0 <virtio_disk_rw>:
    }
    return 0;
}

void
virtio_disk_rw(struct buf *b, int write) {
    80001dc0:	7159                	addi	sp,sp,-112
    80001dc2:	f486                	sd	ra,104(sp)
    80001dc4:	f0a2                	sd	s0,96(sp)
    80001dc6:	eca6                	sd	s1,88(sp)
    80001dc8:	e8ca                	sd	s2,80(sp)
    80001dca:	e4ce                	sd	s3,72(sp)
    80001dcc:	e0d2                	sd	s4,64(sp)
    80001dce:	fc56                	sd	s5,56(sp)
    80001dd0:	f85a                	sd	s6,48(sp)
    80001dd2:	f45e                	sd	s7,40(sp)
    80001dd4:	f062                	sd	s8,32(sp)
    80001dd6:	ec66                	sd	s9,24(sp)
    80001dd8:	e86a                	sd	s10,16(sp)
    80001dda:	1880                	addi	s0,sp,112
    80001ddc:	892a                	mv	s2,a0
    80001dde:	8d2e                	mv	s10,a1
    uint64 sector = b->blockno * (BSIZE / 512);
    80001de0:	00c52c83          	lw	s9,12(a0)
    80001de4:	001c9c9b          	slliw	s9,s9,0x1
    80001de8:	1c82                	slli	s9,s9,0x20
    80001dea:	020cdc93          	srli	s9,s9,0x20
    spin_lock(&disk.vdisk_lock);
    80001dee:	0004f517          	auipc	a0,0x4f
    80001df2:	33a50513          	addi	a0,a0,826 # 80051128 <disk+0x2128>
    80001df6:	00001097          	auipc	ra,0x1
    80001dfa:	3c4080e7          	jalr	964(ra) # 800031ba <spin_lock>
    for (int i = 0; i < 3; i++) {
    80001dfe:	4981                	li	s3,0
    for (int i = 0; i < NUM; i++) {
    80001e00:	4c21                	li	s8,8
            disk.free[i] = 0;
    80001e02:	0004db97          	auipc	s7,0x4d
    80001e06:	1feb8b93          	addi	s7,s7,510 # 8004f000 <disk>
    80001e0a:	6b09                	lui	s6,0x2
    for (int i = 0; i < 3; i++) {
    80001e0c:	4a8d                	li	s5,3
    for (int i = 0; i < NUM; i++) {
    80001e0e:	8a4e                	mv	s4,s3
    80001e10:	a051                	j	80001e94 <virtio_disk_rw+0xd4>
            disk.free[i] = 0;
    80001e12:	00fb86b3          	add	a3,s7,a5
    80001e16:	96da                	add	a3,a3,s6
    80001e18:	00068c23          	sb	zero,24(a3)
        idx[i] = alloc_desc();
    80001e1c:	c21c                	sw	a5,0(a2)
        if (idx[i] < 0) {
    80001e1e:	0207c563          	bltz	a5,80001e48 <virtio_disk_rw+0x88>
    for (int i = 0; i < 3; i++) {
    80001e22:	2485                	addiw	s1,s1,1
    80001e24:	0711                	addi	a4,a4,4
    80001e26:	25548063          	beq	s1,s5,80002066 <virtio_disk_rw+0x2a6>
        idx[i] = alloc_desc();
    80001e2a:	863a                	mv	a2,a4
    for (int i = 0; i < NUM; i++) {
    80001e2c:	0004f697          	auipc	a3,0x4f
    80001e30:	1ec68693          	addi	a3,a3,492 # 80051018 <disk+0x2018>
    80001e34:	87d2                	mv	a5,s4
        if (disk.free[i]) {
    80001e36:	0006c583          	lbu	a1,0(a3)
    80001e3a:	fde1                	bnez	a1,80001e12 <virtio_disk_rw+0x52>
    for (int i = 0; i < NUM; i++) {
    80001e3c:	2785                	addiw	a5,a5,1
    80001e3e:	0685                	addi	a3,a3,1
    80001e40:	ff879be3          	bne	a5,s8,80001e36 <virtio_disk_rw+0x76>
        idx[i] = alloc_desc();
    80001e44:	57fd                	li	a5,-1
    80001e46:	c21c                	sw	a5,0(a2)
            for (int j = 0; j < i; j++)
    80001e48:	02905a63          	blez	s1,80001e7c <virtio_disk_rw+0xbc>
                free_desc(idx[j]);
    80001e4c:	f9042503          	lw	a0,-112(s0)
    80001e50:	00000097          	auipc	ra,0x0
    80001e54:	d82080e7          	jalr	-638(ra) # 80001bd2 <free_desc>
            for (int j = 0; j < i; j++)
    80001e58:	4785                	li	a5,1
    80001e5a:	0297d163          	bge	a5,s1,80001e7c <virtio_disk_rw+0xbc>
                free_desc(idx[j]);
    80001e5e:	f9442503          	lw	a0,-108(s0)
    80001e62:	00000097          	auipc	ra,0x0
    80001e66:	d70080e7          	jalr	-656(ra) # 80001bd2 <free_desc>
            for (int j = 0; j < i; j++)
    80001e6a:	4789                	li	a5,2
    80001e6c:	0097d863          	bge	a5,s1,80001e7c <virtio_disk_rw+0xbc>
                free_desc(idx[j]);
    80001e70:	f9842503          	lw	a0,-104(s0)
    80001e74:	00000097          	auipc	ra,0x0
    80001e78:	d5e080e7          	jalr	-674(ra) # 80001bd2 <free_desc>
    int idx[3];
    while (1) {
        if (alloc3_desc(idx) == 0) {
            break;
        }
        sleep(&disk.free[0], &disk.vdisk_lock);
    80001e7c:	0004f597          	auipc	a1,0x4f
    80001e80:	2ac58593          	addi	a1,a1,684 # 80051128 <disk+0x2128>
    80001e84:	0004f517          	auipc	a0,0x4f
    80001e88:	19450513          	addi	a0,a0,404 # 80051018 <disk+0x2018>
    80001e8c:	fffff097          	auipc	ra,0xfffff
    80001e90:	0b2080e7          	jalr	178(ra) # 80000f3e <sleep>
    for (int i = 0; i < 3; i++) {
    80001e94:	f9040713          	addi	a4,s0,-112
    80001e98:	84ce                	mv	s1,s3
    80001e9a:	bf41                	j	80001e2a <virtio_disk_rw+0x6a>
    // format the three descriptors.
    // qemu's virtio-blk.c reads them.
    struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

    if (write)
        buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80001e9c:	20058713          	addi	a4,a1,512
    80001ea0:	00471693          	slli	a3,a4,0x4
    80001ea4:	0004d717          	auipc	a4,0x4d
    80001ea8:	15c70713          	addi	a4,a4,348 # 8004f000 <disk>
    80001eac:	9736                	add	a4,a4,a3
    80001eae:	4685                	li	a3,1
    80001eb0:	0ad72423          	sw	a3,168(a4)
    else
        buf0->type = VIRTIO_BLK_T_IN; // read the disk
    buf0->reserved = 0;
    80001eb4:	20058713          	addi	a4,a1,512
    80001eb8:	00471693          	slli	a3,a4,0x4
    80001ebc:	0004d717          	auipc	a4,0x4d
    80001ec0:	14470713          	addi	a4,a4,324 # 8004f000 <disk>
    80001ec4:	9736                	add	a4,a4,a3
    80001ec6:	0a072623          	sw	zero,172(a4)
    buf0->sector = sector;
    80001eca:	0b973823          	sd	s9,176(a4)

    disk.desc[idx[0]].addr = (uint64) buf0;
    80001ece:	7679                	lui	a2,0xffffe
    80001ed0:	963e                	add	a2,a2,a5
    80001ed2:	0004f697          	auipc	a3,0x4f
    80001ed6:	12e68693          	addi	a3,a3,302 # 80051000 <disk+0x2000>
    80001eda:	6298                	ld	a4,0(a3)
    80001edc:	9732                	add	a4,a4,a2
    80001ede:	e308                	sd	a0,0(a4)
    disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80001ee0:	6298                	ld	a4,0(a3)
    80001ee2:	9732                	add	a4,a4,a2
    80001ee4:	4541                	li	a0,16
    80001ee6:	c708                	sw	a0,8(a4)
    disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80001ee8:	6298                	ld	a4,0(a3)
    80001eea:	9732                	add	a4,a4,a2
    80001eec:	4505                	li	a0,1
    80001eee:	00a71623          	sh	a0,12(a4)
    disk.desc[idx[0]].next = idx[1];
    80001ef2:	f9442703          	lw	a4,-108(s0)
    80001ef6:	6288                	ld	a0,0(a3)
    80001ef8:	962a                	add	a2,a2,a0
    80001efa:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <buf_cache+0xffffffff7ffaa536>

    disk.desc[idx[1]].addr = (uint64) b->data;
    80001efe:	0712                	slli	a4,a4,0x4
    80001f00:	6290                	ld	a2,0(a3)
    80001f02:	963a                	add	a2,a2,a4
    80001f04:	04c90513          	addi	a0,s2,76
    80001f08:	e208                	sd	a0,0(a2)
    disk.desc[idx[1]].len = BSIZE;
    80001f0a:	6294                	ld	a3,0(a3)
    80001f0c:	96ba                	add	a3,a3,a4
    80001f0e:	40000613          	li	a2,1024
    80001f12:	c690                	sw	a2,8(a3)
    if (write)
    80001f14:	140d0063          	beqz	s10,80002054 <virtio_disk_rw+0x294>
        disk.desc[idx[1]].flags = 0; // device reads b->data
    80001f18:	0004f697          	auipc	a3,0x4f
    80001f1c:	0e86b683          	ld	a3,232(a3) # 80051000 <disk+0x2000>
    80001f20:	96ba                	add	a3,a3,a4
    80001f22:	00069623          	sh	zero,12(a3)
    else
        disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80001f26:	0004d817          	auipc	a6,0x4d
    80001f2a:	0da80813          	addi	a6,a6,218 # 8004f000 <disk>
    80001f2e:	0004f517          	auipc	a0,0x4f
    80001f32:	0d250513          	addi	a0,a0,210 # 80051000 <disk+0x2000>
    80001f36:	6114                	ld	a3,0(a0)
    80001f38:	96ba                	add	a3,a3,a4
    80001f3a:	00c6d603          	lhu	a2,12(a3)
    80001f3e:	00166613          	ori	a2,a2,1
    80001f42:	00c69623          	sh	a2,12(a3)
    disk.desc[idx[1]].next = idx[2];
    80001f46:	f9842683          	lw	a3,-104(s0)
    80001f4a:	6110                	ld	a2,0(a0)
    80001f4c:	9732                	add	a4,a4,a2
    80001f4e:	00d71723          	sh	a3,14(a4)

    disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80001f52:	20058613          	addi	a2,a1,512
    80001f56:	0612                	slli	a2,a2,0x4
    80001f58:	9642                	add	a2,a2,a6
    80001f5a:	577d                	li	a4,-1
    80001f5c:	02e60823          	sb	a4,48(a2)
    disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80001f60:	00469713          	slli	a4,a3,0x4
    80001f64:	6114                	ld	a3,0(a0)
    80001f66:	96ba                	add	a3,a3,a4
    80001f68:	03078793          	addi	a5,a5,48
    80001f6c:	97c2                	add	a5,a5,a6
    80001f6e:	e29c                	sd	a5,0(a3)
    disk.desc[idx[2]].len = 1;
    80001f70:	611c                	ld	a5,0(a0)
    80001f72:	97ba                	add	a5,a5,a4
    80001f74:	4685                	li	a3,1
    80001f76:	c794                	sw	a3,8(a5)
    disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80001f78:	611c                	ld	a5,0(a0)
    80001f7a:	97ba                	add	a5,a5,a4
    80001f7c:	4809                	li	a6,2
    80001f7e:	01079623          	sh	a6,12(a5)
    disk.desc[idx[2]].next = 0;
    80001f82:	611c                	ld	a5,0(a0)
    80001f84:	973e                	add	a4,a4,a5
    80001f86:	00071723          	sh	zero,14(a4)

    // record struct buf for virtio_disk_intr().
    b->disk = 1;
    80001f8a:	00d92223          	sw	a3,4(s2)
    disk.info[idx[0]].b = b;
    80001f8e:	03263423          	sd	s2,40(a2)

    // tell the device the first index in our chain of descriptors.
    disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80001f92:	6518                	ld	a4,8(a0)
    80001f94:	00275783          	lhu	a5,2(a4)
    80001f98:	8b9d                	andi	a5,a5,7
    80001f9a:	0786                	slli	a5,a5,0x1
    80001f9c:	97ba                	add	a5,a5,a4
    80001f9e:	00b79223          	sh	a1,4(a5)

    __sync_synchronize();
    80001fa2:	0ff0000f          	fence

    // tell the device another avail ring entry is available.
    disk.avail->idx += 1; // not % NUM ...
    80001fa6:	6518                	ld	a4,8(a0)
    80001fa8:	00275783          	lhu	a5,2(a4)
    80001fac:	2785                	addiw	a5,a5,1
    80001fae:	00f71123          	sh	a5,2(a4)

    __sync_synchronize();
    80001fb2:	0ff0000f          	fence

    *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80001fb6:	100017b7          	lui	a5,0x10001
    80001fba:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

    // Wait for virtio_disk_intr() to say request has finished.
    while (b->disk == 1) {
    80001fbe:	00492703          	lw	a4,4(s2)
    80001fc2:	4785                	li	a5,1
    80001fc4:	02f71163          	bne	a4,a5,80001fe6 <virtio_disk_rw+0x226>
        sleep(b, &disk.vdisk_lock);
    80001fc8:	0004f997          	auipc	s3,0x4f
    80001fcc:	16098993          	addi	s3,s3,352 # 80051128 <disk+0x2128>
    while (b->disk == 1) {
    80001fd0:	4485                	li	s1,1
        sleep(b, &disk.vdisk_lock);
    80001fd2:	85ce                	mv	a1,s3
    80001fd4:	854a                	mv	a0,s2
    80001fd6:	fffff097          	auipc	ra,0xfffff
    80001fda:	f68080e7          	jalr	-152(ra) # 80000f3e <sleep>
    while (b->disk == 1) {
    80001fde:	00492783          	lw	a5,4(s2)
    80001fe2:	fe9788e3          	beq	a5,s1,80001fd2 <virtio_disk_rw+0x212>
    }

    disk.info[idx[0]].b = 0;
    80001fe6:	f9042903          	lw	s2,-112(s0)
    80001fea:	20090793          	addi	a5,s2,512
    80001fee:	00479713          	slli	a4,a5,0x4
    80001ff2:	0004d797          	auipc	a5,0x4d
    80001ff6:	00e78793          	addi	a5,a5,14 # 8004f000 <disk>
    80001ffa:	97ba                	add	a5,a5,a4
    80001ffc:	0207b423          	sd	zero,40(a5)
        int flag = disk.desc[i].flags;
    80002000:	0004f997          	auipc	s3,0x4f
    80002004:	00098993          	mv	s3,s3
    80002008:	00491713          	slli	a4,s2,0x4
    8000200c:	0009b783          	ld	a5,0(s3) # 80051000 <disk+0x2000>
    80002010:	97ba                	add	a5,a5,a4
    80002012:	00c7d483          	lhu	s1,12(a5)
        int nxt = disk.desc[i].next;
    80002016:	854a                	mv	a0,s2
    80002018:	00e7d903          	lhu	s2,14(a5)
        free_desc(i);
    8000201c:	00000097          	auipc	ra,0x0
    80002020:	bb6080e7          	jalr	-1098(ra) # 80001bd2 <free_desc>
        if (flag & VRING_DESC_F_NEXT)
    80002024:	8885                	andi	s1,s1,1
    80002026:	f0ed                	bnez	s1,80002008 <virtio_disk_rw+0x248>
    free_chain(idx[0]);
    spin_unlock(&disk.vdisk_lock);
    80002028:	0004f517          	auipc	a0,0x4f
    8000202c:	10050513          	addi	a0,a0,256 # 80051128 <disk+0x2128>
    80002030:	00001097          	auipc	ra,0x1
    80002034:	25e080e7          	jalr	606(ra) # 8000328e <spin_unlock>
}
    80002038:	70a6                	ld	ra,104(sp)
    8000203a:	7406                	ld	s0,96(sp)
    8000203c:	64e6                	ld	s1,88(sp)
    8000203e:	6946                	ld	s2,80(sp)
    80002040:	69a6                	ld	s3,72(sp)
    80002042:	6a06                	ld	s4,64(sp)
    80002044:	7ae2                	ld	s5,56(sp)
    80002046:	7b42                	ld	s6,48(sp)
    80002048:	7ba2                	ld	s7,40(sp)
    8000204a:	7c02                	ld	s8,32(sp)
    8000204c:	6ce2                	ld	s9,24(sp)
    8000204e:	6d42                	ld	s10,16(sp)
    80002050:	6165                	addi	sp,sp,112
    80002052:	8082                	ret
        disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80002054:	0004f697          	auipc	a3,0x4f
    80002058:	fac6b683          	ld	a3,-84(a3) # 80051000 <disk+0x2000>
    8000205c:	96ba                	add	a3,a3,a4
    8000205e:	4609                	li	a2,2
    80002060:	00c69623          	sh	a2,12(a3)
    80002064:	b5c9                	j	80001f26 <virtio_disk_rw+0x166>
    struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80002066:	f9042583          	lw	a1,-112(s0)
    8000206a:	20058793          	addi	a5,a1,512
    8000206e:	0792                	slli	a5,a5,0x4
    80002070:	0004d517          	auipc	a0,0x4d
    80002074:	03850513          	addi	a0,a0,56 # 8004f0a8 <disk+0xa8>
    80002078:	953e                	add	a0,a0,a5
    if (write)
    8000207a:	e20d11e3          	bnez	s10,80001e9c <virtio_disk_rw+0xdc>
        buf0->type = VIRTIO_BLK_T_IN; // read the disk
    8000207e:	20058713          	addi	a4,a1,512
    80002082:	00471693          	slli	a3,a4,0x4
    80002086:	0004d717          	auipc	a4,0x4d
    8000208a:	f7a70713          	addi	a4,a4,-134 # 8004f000 <disk>
    8000208e:	9736                	add	a4,a4,a3
    80002090:	0a072423          	sw	zero,168(a4)
    80002094:	b505                	j	80001eb4 <virtio_disk_rw+0xf4>

0000000080002096 <virtio_disk_intr>:

void
virtio_disk_intr() {
    80002096:	7179                	addi	sp,sp,-48
    80002098:	f406                	sd	ra,40(sp)
    8000209a:	f022                	sd	s0,32(sp)
    8000209c:	ec26                	sd	s1,24(sp)
    8000209e:	e84a                	sd	s2,16(sp)
    800020a0:	e44e                	sd	s3,8(sp)
    800020a2:	e052                	sd	s4,0(sp)
    800020a4:	1800                	addi	s0,sp,48
    spin_lock(&disk.vdisk_lock);
    800020a6:	0004f517          	auipc	a0,0x4f
    800020aa:	08250513          	addi	a0,a0,130 # 80051128 <disk+0x2128>
    800020ae:	00001097          	auipc	ra,0x1
    800020b2:	10c080e7          	jalr	268(ra) # 800031ba <spin_lock>
    // we've seen this interrupt, which the following line does.
    // this may race with the device writing new entries to
    // the "used" ring, in which case we may process the new
    // completion entries in this interrupt, and have nothing to do
    // in the next interrupt, which is harmless.
    *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800020b6:	10001737          	lui	a4,0x10001
    800020ba:	533c                	lw	a5,96(a4)
    800020bc:	8b8d                	andi	a5,a5,3
    800020be:	d37c                	sw	a5,100(a4)

    __sync_synchronize();
    800020c0:	0ff0000f          	fence

    // the device increments disk.used->idx when it
    // adds an entry to the used ring.
    while (disk.used_idx != disk.used->idx) {
    800020c4:	0004f797          	auipc	a5,0x4f
    800020c8:	f3c78793          	addi	a5,a5,-196 # 80051000 <disk+0x2000>
    800020cc:	6b94                	ld	a3,16(a5)
    800020ce:	0207d703          	lhu	a4,32(a5)
    800020d2:	0026d783          	lhu	a5,2(a3)
    800020d6:	06f70e63          	beq	a4,a5,80002152 <virtio_disk_intr+0xbc>
        __sync_synchronize();
        int id = disk.used->ring[disk.used_idx % NUM].id;
    800020da:	0004d997          	auipc	s3,0x4d
    800020de:	f2698993          	addi	s3,s3,-218 # 8004f000 <disk>
    800020e2:	0004f917          	auipc	s2,0x4f
    800020e6:	f1e90913          	addi	s2,s2,-226 # 80051000 <disk+0x2000>

        if (disk.info[id].status != 0)
            panic("virtio_disk_intr status");
    800020ea:	00002a17          	auipc	s4,0x2
    800020ee:	4bea0a13          	addi	s4,s4,1214 # 800045a8 <digits+0x558>
    800020f2:	a835                	j	8000212e <virtio_disk_intr+0x98>
    800020f4:	8552                	mv	a0,s4
    800020f6:	ffffe097          	auipc	ra,0xffffe
    800020fa:	67a080e7          	jalr	1658(ra) # 80000770 <panic>

        struct buf *b = disk.info[id].b;
    800020fe:	20048493          	addi	s1,s1,512 # 10001200 <_entry-0x6fffee00>
    80002102:	0492                	slli	s1,s1,0x4
    80002104:	94ce                	add	s1,s1,s3
    80002106:	7488                	ld	a0,40(s1)
        b->disk = 0;   // disk is done with buf
    80002108:	00052223          	sw	zero,4(a0)
        wakeup(b);
    8000210c:	fffff097          	auipc	ra,0xfffff
    80002110:	f3e080e7          	jalr	-194(ra) # 8000104a <wakeup>

        disk.used_idx += 1;
    80002114:	02095783          	lhu	a5,32(s2)
    80002118:	2785                	addiw	a5,a5,1
    8000211a:	17c2                	slli	a5,a5,0x30
    8000211c:	93c1                	srli	a5,a5,0x30
    8000211e:	02f91023          	sh	a5,32(s2)
    while (disk.used_idx != disk.used->idx) {
    80002122:	01093703          	ld	a4,16(s2)
    80002126:	00275703          	lhu	a4,2(a4) # 10001002 <_entry-0x6fffeffe>
    8000212a:	02f70463          	beq	a4,a5,80002152 <virtio_disk_intr+0xbc>
        __sync_synchronize();
    8000212e:	0ff0000f          	fence
        int id = disk.used->ring[disk.used_idx % NUM].id;
    80002132:	01093703          	ld	a4,16(s2)
    80002136:	02095783          	lhu	a5,32(s2)
    8000213a:	8b9d                	andi	a5,a5,7
    8000213c:	078e                	slli	a5,a5,0x3
    8000213e:	97ba                	add	a5,a5,a4
    80002140:	43c4                	lw	s1,4(a5)
        if (disk.info[id].status != 0)
    80002142:	20048793          	addi	a5,s1,512
    80002146:	0792                	slli	a5,a5,0x4
    80002148:	97ce                	add	a5,a5,s3
    8000214a:	0307c783          	lbu	a5,48(a5)
    8000214e:	dbc5                	beqz	a5,800020fe <virtio_disk_intr+0x68>
    80002150:	b755                	j	800020f4 <virtio_disk_intr+0x5e>
    }
    spin_unlock(&disk.vdisk_lock);
    80002152:	0004f517          	auipc	a0,0x4f
    80002156:	fd650513          	addi	a0,a0,-42 # 80051128 <disk+0x2128>
    8000215a:	00001097          	auipc	ra,0x1
    8000215e:	134080e7          	jalr	308(ra) # 8000328e <spin_unlock>
}
    80002162:	70a2                	ld	ra,40(sp)
    80002164:	7402                	ld	s0,32(sp)
    80002166:	64e2                	ld	s1,24(sp)
    80002168:	6942                	ld	s2,16(sp)
    8000216a:	69a2                	ld	s3,8(sp)
    8000216c:	6a02                	ld	s4,0(sp)
    8000216e:	6145                	addi	sp,sp,48
    80002170:	8082                	ret

0000000080002172 <fstest>:
#include "file.h"
#include "virtio.h"
#include "../defs.h"
#include "fstest.h"

void fstest() {
    80002172:	715d                	addi	sp,sp,-80
    80002174:	e486                	sd	ra,72(sp)
    80002176:	e0a2                	sd	s0,64(sp)
    80002178:	fc26                	sd	s1,56(sp)
    8000217a:	f84a                	sd	s2,48(sp)
    8000217c:	0880                	addi	s0,sp,80
    struct inode *inode;
    struct superblock sb;
    read_superblock(&sb);
    8000217e:	fc840513          	addi	a0,s0,-56
    80002182:	00000097          	auipc	ra,0x0
    80002186:	10e080e7          	jalr	270(ra) # 80002290 <read_superblock>
    inode = alloc_inode(T_FILE);
    8000218a:	4509                	li	a0,2
    8000218c:	00000097          	auipc	ra,0x0
    80002190:	4e4080e7          	jalr	1252(ra) # 80002670 <alloc_inode>
    80002194:	84aa                	mv	s1,a0
    printf("测试inode能否读写");
    80002196:	00002517          	auipc	a0,0x2
    8000219a:	42a50513          	addi	a0,a0,1066 # 800045c0 <digits+0x570>
    8000219e:	ffffe097          	auipc	ra,0xffffe
    800021a2:	334080e7          	jalr	820(ra) # 800004d2 <printf>
    char *str = "hello world!!";
    write_inode(inode, (uint64) str, 0, strlen(str));
    800021a6:	00002917          	auipc	s2,0x2
    800021aa:	43290913          	addi	s2,s2,1074 # 800045d8 <digits+0x588>
    800021ae:	854a                	mv	a0,s2
    800021b0:	fffff097          	auipc	ra,0xfffff
    800021b4:	77e080e7          	jalr	1918(ra) # 8000192e <strlen>
    800021b8:	0005069b          	sext.w	a3,a0
    800021bc:	4601                	li	a2,0
    800021be:	85ca                	mv	a1,s2
    800021c0:	8526                	mv	a0,s1
    800021c2:	00001097          	auipc	ra,0x1
    800021c6:	950080e7          	jalr	-1712(ra) # 80002b12 <write_inode>
    char s[20];
    read_inode(inode, (uint64) s, 0, 30);
    800021ca:	46f9                	li	a3,30
    800021cc:	4601                	li	a2,0
    800021ce:	fb040593          	addi	a1,s0,-80
    800021d2:	8526                	mv	a0,s1
    800021d4:	00001097          	auipc	ra,0x1
    800021d8:	874080e7          	jalr	-1932(ra) # 80002a48 <read_inode>
    printf("%s\n", s);
    800021dc:	fb040593          	addi	a1,s0,-80
    800021e0:	00002517          	auipc	a0,0x2
    800021e4:	e4050513          	addi	a0,a0,-448 # 80004020 <sleep_holding+0xc62>
    800021e8:	ffffe097          	auipc	ra,0xffffe
    800021ec:	2ea080e7          	jalr	746(ra) # 800004d2 <printf>
}
    800021f0:	60a6                	ld	ra,72(sp)
    800021f2:	6406                	ld	s0,64(sp)
    800021f4:	74e2                	ld	s1,56(sp)
    800021f6:	7942                	ld	s2,48(sp)
    800021f8:	6161                	addi	sp,sp,80
    800021fa:	8082                	ret

00000000800021fc <dirtest>:

// 输出根目录下的direntry
void dirtest() {
    800021fc:	be010113          	addi	sp,sp,-1056
    80002200:	40113c23          	sd	ra,1048(sp)
    80002204:	40813823          	sd	s0,1040(sp)
    80002208:	40913423          	sd	s1,1032(sp)
    8000220c:	42010413          	addi	s0,sp,1056
    int off = 0;
    char str[1024];
    printf("aa\n");
    80002210:	00002517          	auipc	a0,0x2
    80002214:	3d850513          	addi	a0,a0,984 # 800045e8 <digits+0x598>
    80002218:	ffffe097          	auipc	ra,0xffffe
    8000221c:	2ba080e7          	jalr	698(ra) # 800004d2 <printf>
    struct inode *ip = namei("/readme.txt");
    80002220:	00002517          	auipc	a0,0x2
    80002224:	3d050513          	addi	a0,a0,976 # 800045f0 <digits+0x5a0>
    80002228:	00001097          	auipc	ra,0x1
    8000222c:	cea080e7          	jalr	-790(ra) # 80002f12 <namei>
    80002230:	84aa                	mv	s1,a0
    printf("bb\n");
    80002232:	00002517          	auipc	a0,0x2
    80002236:	3ce50513          	addi	a0,a0,974 # 80004600 <digits+0x5b0>
    8000223a:	ffffe097          	auipc	ra,0xffffe
    8000223e:	298080e7          	jalr	664(ra) # 800004d2 <printf>
    lock_inode(ip);
    80002242:	8526                	mv	a0,s1
    80002244:	00000097          	auipc	ra,0x0
    80002248:	6d0080e7          	jalr	1744(ra) # 80002914 <lock_inode>
    read_inode(ip, (uint64)str, off, 1024);
    8000224c:	40000693          	li	a3,1024
    80002250:	4601                	li	a2,0
    80002252:	be040593          	addi	a1,s0,-1056
    80002256:	8526                	mv	a0,s1
    80002258:	00000097          	auipc	ra,0x0
    8000225c:	7f0080e7          	jalr	2032(ra) # 80002a48 <read_inode>
    printf("%s\n",str);
    80002260:	be040593          	addi	a1,s0,-1056
    80002264:	00002517          	auipc	a0,0x2
    80002268:	dbc50513          	addi	a0,a0,-580 # 80004020 <sleep_holding+0xc62>
    8000226c:	ffffe097          	auipc	ra,0xffffe
    80002270:	266080e7          	jalr	614(ra) # 800004d2 <printf>
    unlock_inode(ip);
    80002274:	8526                	mv	a0,s1
    80002276:	00000097          	auipc	ra,0x0
    8000227a:	764080e7          	jalr	1892(ra) # 800029da <unlock_inode>
}
    8000227e:	41813083          	ld	ra,1048(sp)
    80002282:	41013403          	ld	s0,1040(sp)
    80002286:	40813483          	ld	s1,1032(sp)
    8000228a:	42010113          	addi	sp,sp,1056
    8000228e:	8082                	ret

0000000080002290 <read_superblock>:

#define min(a, b) ((a) < (b) ? (a) : (b))
struct superblock sb;

// 读取超级块
void read_superblock(struct superblock *sb) {
    80002290:	b9010113          	addi	sp,sp,-1136
    80002294:	46113423          	sd	ra,1128(sp)
    80002298:	46813023          	sd	s0,1120(sp)
    8000229c:	44913c23          	sd	s1,1112(sp)
    800022a0:	47010413          	addi	s0,sp,1136
    800022a4:	84aa                	mv	s1,a0
    struct buf b;
    b.blockno = 1;
    800022a6:	4785                	li	a5,1
    800022a8:	b8f42e23          	sw	a5,-1124(s0)
    virtio_disk_rw(&b, 0);
    800022ac:	4581                	li	a1,0
    800022ae:	b9040513          	addi	a0,s0,-1136
    800022b2:	00000097          	auipc	ra,0x0
    800022b6:	b0e080e7          	jalr	-1266(ra) # 80001dc0 <virtio_disk_rw>
    memmove(sb, &b.data, sizeof(*sb));
    800022ba:	4661                	li	a2,24
    800022bc:	bdc40593          	addi	a1,s0,-1060
    800022c0:	8526                	mv	a0,s1
    800022c2:	fffff097          	auipc	ra,0xfffff
    800022c6:	610080e7          	jalr	1552(ra) # 800018d2 <memmove>
    return;
}
    800022ca:	46813083          	ld	ra,1128(sp)
    800022ce:	46013403          	ld	s0,1120(sp)
    800022d2:	45813483          	ld	s1,1112(sp)
    800022d6:	47010113          	addi	sp,sp,1136
    800022da:	8082                	ret

00000000800022dc <init_fs>:

// 初始化文件系统
void init_fs() {
    800022dc:	1101                	addi	sp,sp,-32
    800022de:	ec06                	sd	ra,24(sp)
    800022e0:	e822                	sd	s0,16(sp)
    800022e2:	e426                	sd	s1,8(sp)
    800022e4:	1000                	addi	s0,sp,32
    read_superblock(&sb);
    800022e6:	00050497          	auipc	s1,0x50
    800022ea:	d1a48493          	addi	s1,s1,-742 # 80052000 <sb>
    800022ee:	8526                	mv	a0,s1
    800022f0:	00000097          	auipc	ra,0x0
    800022f4:	fa0080e7          	jalr	-96(ra) # 80002290 <read_superblock>
    if (sb.magic != FSMAGIC) {
    800022f8:	4098                	lw	a4,0(s1)
    800022fa:	102037b7          	lui	a5,0x10203
    800022fe:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002302:	00f71763          	bne	a4,a5,80002310 <init_fs+0x34>
        panic("fs init");
    }
}
    80002306:	60e2                	ld	ra,24(sp)
    80002308:	6442                	ld	s0,16(sp)
    8000230a:	64a2                	ld	s1,8(sp)
    8000230c:	6105                	addi	sp,sp,32
    8000230e:	8082                	ret
        panic("fs init");
    80002310:	00002517          	auipc	a0,0x2
    80002314:	2f850513          	addi	a0,a0,760 # 80004608 <digits+0x5b8>
    80002318:	ffffe097          	auipc	ra,0xffffe
    8000231c:	458080e7          	jalr	1112(ra) # 80000770 <panic>
}
    80002320:	b7dd                	j	80002306 <init_fs+0x2a>

0000000080002322 <zero_block>:
//
// 数据块，下面的block通常指数据块
//

// 格式化磁盘块中的数据
void zero_block(int blockno) {
    80002322:	1101                	addi	sp,sp,-32
    80002324:	ec06                	sd	ra,24(sp)
    80002326:	e822                	sd	s0,16(sp)
    80002328:	e426                	sd	s1,8(sp)
    8000232a:	1000                	addi	s0,sp,32
    8000232c:	85aa                	mv	a1,a0
    struct buf *bp;
    bp = buf_read(0, blockno);
    8000232e:	4501                	li	a0,0
    80002330:	00001097          	auipc	ra,0x1
    80002334:	d5a080e7          	jalr	-678(ra) # 8000308a <buf_read>
    80002338:	84aa                	mv	s1,a0
    memset(bp->data, 0, BSIZE);
    8000233a:	40000613          	li	a2,1024
    8000233e:	4581                	li	a1,0
    80002340:	04c50513          	addi	a0,a0,76
    80002344:	fffff097          	auipc	ra,0xfffff
    80002348:	568080e7          	jalr	1384(ra) # 800018ac <memset>
    buf_write(bp);
    8000234c:	8526                	mv	a0,s1
    8000234e:	00001097          	auipc	ra,0x1
    80002352:	d70080e7          	jalr	-656(ra) # 800030be <buf_write>
    relse_buf(bp);
    80002356:	8526                	mv	a0,s1
    80002358:	00001097          	auipc	ra,0x1
    8000235c:	d80080e7          	jalr	-640(ra) # 800030d8 <relse_buf>
}
    80002360:	60e2                	ld	ra,24(sp)
    80002362:	6442                	ld	s0,16(sp)
    80002364:	64a2                	ld	s1,8(sp)
    80002366:	6105                	addi	sp,sp,32
    80002368:	8082                	ret

000000008000236a <alloc_disk_block>:

// 申请空闲的磁盘块, 且格式化为0，返回块号。
uint alloc_disk_block() {
    8000236a:	715d                	addi	sp,sp,-80
    8000236c:	e486                	sd	ra,72(sp)
    8000236e:	e0a2                	sd	s0,64(sp)
    80002370:	fc26                	sd	s1,56(sp)
    80002372:	f84a                	sd	s2,48(sp)
    80002374:	f44e                	sd	s3,40(sp)
    80002376:	f052                	sd	s4,32(sp)
    80002378:	ec56                	sd	s5,24(sp)
    8000237a:	e85a                	sd	s6,16(sp)
    8000237c:	e45e                	sd	s7,8(sp)
    8000237e:	0880                	addi	s0,sp,80
    int b, bi, m;
    struct buf *bitmap;

    for (b = 0; b < sb.size; b += BPB) { // 遍历bitmap
    80002380:	00050797          	auipc	a5,0x50
    80002384:	c847a783          	lw	a5,-892(a5) # 80052004 <sb+0x4>
    80002388:	c3e9                	beqz	a5,8000244a <alloc_disk_block+0xe0>
    8000238a:	4a81                	li	s5,0
        bitmap = buf_read(0, BBLOCK(b, sb));
    8000238c:	00050b17          	auipc	s6,0x50
    80002390:	c74b0b13          	addi	s6,s6,-908 # 80052000 <sb>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) { //遍历bitmap的每一位
            m = 1 << (bi % 8);
    80002394:	4985                	li	s3,1
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) { //遍历bitmap的每一位
    80002396:	6a09                	lui	s4,0x2
    for (b = 0; b < sb.size; b += BPB) { // 遍历bitmap
    80002398:	6b89                	lui	s7,0x2
    8000239a:	a0b1                	j	800023e6 <alloc_disk_block+0x7c>
            if ((bitmap->data[bi / 8] & m) == 0) { // 判断块是否被使用
                bitmap->data[bi / 8] |= m; // 标记块被使用
    8000239c:	972a                	add	a4,a4,a0
    8000239e:	8fd5                	or	a5,a5,a3
    800023a0:	04f70623          	sb	a5,76(a4)
                relse_buf(bitmap);
    800023a4:	00001097          	auipc	ra,0x1
    800023a8:	d34080e7          	jalr	-716(ra) # 800030d8 <relse_buf>
                zero_block(b + bi);
    800023ac:	854a                	mv	a0,s2
    800023ae:	00000097          	auipc	ra,0x0
    800023b2:	f74080e7          	jalr	-140(ra) # 80002322 <zero_block>
        }
        relse_buf(bitmap);
    }
    panic("balloc: out of blocks");
    return 0;
}
    800023b6:	8526                	mv	a0,s1
    800023b8:	60a6                	ld	ra,72(sp)
    800023ba:	6406                	ld	s0,64(sp)
    800023bc:	74e2                	ld	s1,56(sp)
    800023be:	7942                	ld	s2,48(sp)
    800023c0:	79a2                	ld	s3,40(sp)
    800023c2:	7a02                	ld	s4,32(sp)
    800023c4:	6ae2                	ld	s5,24(sp)
    800023c6:	6b42                	ld	s6,16(sp)
    800023c8:	6ba2                	ld	s7,8(sp)
    800023ca:	6161                	addi	sp,sp,80
    800023cc:	8082                	ret
        relse_buf(bitmap);
    800023ce:	00001097          	auipc	ra,0x1
    800023d2:	d0a080e7          	jalr	-758(ra) # 800030d8 <relse_buf>
    for (b = 0; b < sb.size; b += BPB) { // 遍历bitmap
    800023d6:	015b87bb          	addw	a5,s7,s5
    800023da:	00078a9b          	sext.w	s5,a5
    800023de:	004b2703          	lw	a4,4(s6)
    800023e2:	06eaf463          	bgeu	s5,a4,8000244a <alloc_disk_block+0xe0>
        bitmap = buf_read(0, BBLOCK(b, sb));
    800023e6:	41fad79b          	sraiw	a5,s5,0x1f
    800023ea:	0137d79b          	srliw	a5,a5,0x13
    800023ee:	015787bb          	addw	a5,a5,s5
    800023f2:	40d7d79b          	sraiw	a5,a5,0xd
    800023f6:	014b2583          	lw	a1,20(s6)
    800023fa:	9dbd                	addw	a1,a1,a5
    800023fc:	4501                	li	a0,0
    800023fe:	00001097          	auipc	ra,0x1
    80002402:	c8c080e7          	jalr	-884(ra) # 8000308a <buf_read>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) { //遍历bitmap的每一位
    80002406:	004b2803          	lw	a6,4(s6)
    8000240a:	000a849b          	sext.w	s1,s5
    8000240e:	4601                	li	a2,0
    80002410:	0004891b          	sext.w	s2,s1
    80002414:	fb04fde3          	bgeu	s1,a6,800023ce <alloc_disk_block+0x64>
            m = 1 << (bi % 8);
    80002418:	41f6579b          	sraiw	a5,a2,0x1f
    8000241c:	01d7d69b          	srliw	a3,a5,0x1d
    80002420:	00c6873b          	addw	a4,a3,a2
    80002424:	00777793          	andi	a5,a4,7
    80002428:	9f95                	subw	a5,a5,a3
    8000242a:	00f997bb          	sllw	a5,s3,a5
            if ((bitmap->data[bi / 8] & m) == 0) { // 判断块是否被使用
    8000242e:	4037571b          	sraiw	a4,a4,0x3
    80002432:	00e506b3          	add	a3,a0,a4
    80002436:	04c6c683          	lbu	a3,76(a3)
    8000243a:	00d7f5b3          	and	a1,a5,a3
    8000243e:	ddb9                	beqz	a1,8000239c <alloc_disk_block+0x32>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) { //遍历bitmap的每一位
    80002440:	2605                	addiw	a2,a2,1
    80002442:	2485                	addiw	s1,s1,1
    80002444:	fd4616e3          	bne	a2,s4,80002410 <alloc_disk_block+0xa6>
    80002448:	b759                	j	800023ce <alloc_disk_block+0x64>
    panic("balloc: out of blocks");
    8000244a:	00002517          	auipc	a0,0x2
    8000244e:	1c650513          	addi	a0,a0,454 # 80004610 <digits+0x5c0>
    80002452:	ffffe097          	auipc	ra,0xffffe
    80002456:	31e080e7          	jalr	798(ra) # 80000770 <panic>
    return 0;
    8000245a:	4481                	li	s1,0
    8000245c:	bfa9                	j	800023b6 <alloc_disk_block+0x4c>

000000008000245e <free_disk_block>:

// 释放磁盘块, 通过重置bitmap对应位。
void free_disk_block(int blockno) {
    8000245e:	1101                	addi	sp,sp,-32
    80002460:	ec06                	sd	ra,24(sp)
    80002462:	e822                	sd	s0,16(sp)
    80002464:	e426                	sd	s1,8(sp)
    80002466:	e04a                	sd	s2,0(sp)
    80002468:	1000                	addi	s0,sp,32
    struct buf *bitmap;
    int bi, m;
    bitmap = buf_read(0, BBLOCK(blockno, sb));
    8000246a:	41f5549b          	sraiw	s1,a0,0x1f
    8000246e:	0134d91b          	srliw	s2,s1,0x13
    80002472:	00a904bb          	addw	s1,s2,a0
    80002476:	40d4d59b          	sraiw	a1,s1,0xd
    8000247a:	00050797          	auipc	a5,0x50
    8000247e:	b9a7a783          	lw	a5,-1126(a5) # 80052014 <sb+0x14>
    80002482:	9dbd                	addw	a1,a1,a5
    80002484:	4501                	li	a0,0
    80002486:	00001097          	auipc	ra,0x1
    8000248a:	c04080e7          	jalr	-1020(ra) # 8000308a <buf_read>
    bi = blockno % BPB;
    8000248e:	14ce                	slli	s1,s1,0x33
    80002490:	90cd                	srli	s1,s1,0x33
    80002492:	412484bb          	subw	s1,s1,s2
    m = 1 << (bi % 8);
    bitmap->data[bi / 8] &= ~m;
    80002496:	41f4d79b          	sraiw	a5,s1,0x1f
    8000249a:	01d7d79b          	srliw	a5,a5,0x1d
    8000249e:	9cbd                	addw	s1,s1,a5
    800024a0:	4034d71b          	sraiw	a4,s1,0x3
    800024a4:	972a                	add	a4,a4,a0
    m = 1 << (bi % 8);
    800024a6:	889d                	andi	s1,s1,7
    800024a8:	9c9d                	subw	s1,s1,a5
    bitmap->data[bi / 8] &= ~m;
    800024aa:	4785                	li	a5,1
    800024ac:	009794bb          	sllw	s1,a5,s1
    800024b0:	fff4c493          	not	s1,s1
    800024b4:	04c74783          	lbu	a5,76(a4)
    800024b8:	8cfd                	and	s1,s1,a5
    800024ba:	04970623          	sb	s1,76(a4)
    relse_buf(bitmap);
    800024be:	00001097          	auipc	ra,0x1
    800024c2:	c1a080e7          	jalr	-998(ra) # 800030d8 <relse_buf>
}
    800024c6:	60e2                	ld	ra,24(sp)
    800024c8:	6442                	ld	s0,16(sp)
    800024ca:	64a2                	ld	s1,8(sp)
    800024cc:	6902                	ld	s2,0(sp)
    800024ce:	6105                	addi	sp,sp,32
    800024d0:	8082                	ret

00000000800024d2 <init_inode_cache>:
    struct inode inode[NINODE];
} inode_cache;


// 初始化inode的缓存
void init_inode_cache() {
    800024d2:	7179                	addi	sp,sp,-48
    800024d4:	f406                	sd	ra,40(sp)
    800024d6:	f022                	sd	s0,32(sp)
    800024d8:	ec26                	sd	s1,24(sp)
    800024da:	e84a                	sd	s2,16(sp)
    800024dc:	e44e                	sd	s3,8(sp)
    800024de:	1800                	addi	s0,sp,48
    spinlock_init(&inode_cache.lock, "inode cache");
    800024e0:	00002597          	auipc	a1,0x2
    800024e4:	14858593          	addi	a1,a1,328 # 80004628 <digits+0x5d8>
    800024e8:	00050517          	auipc	a0,0x50
    800024ec:	b3050513          	addi	a0,a0,-1232 # 80052018 <inode_cache>
    800024f0:	00001097          	auipc	ra,0x1
    800024f4:	c3a080e7          	jalr	-966(ra) # 8000312a <spinlock_init>
    for (int i = 0; i < NINODE; i++) {
    800024f8:	00050497          	auipc	s1,0x50
    800024fc:	b4848493          	addi	s1,s1,-1208 # 80052040 <inode_cache+0x28>
    80002500:	00051997          	auipc	s3,0x51
    80002504:	5d098993          	addi	s3,s3,1488 # 80053ad0 <cache_lock+0x10>
        sleeplock_init(&inode_cache.inode[i].lock, "inode");
    80002508:	00002917          	auipc	s2,0x2
    8000250c:	13090913          	addi	s2,s2,304 # 80004638 <digits+0x5e8>
    80002510:	85ca                	mv	a1,s2
    80002512:	8526                	mv	a0,s1
    80002514:	00001097          	auipc	ra,0x1
    80002518:	dd6080e7          	jalr	-554(ra) # 800032ea <sleeplock_init>
    for (int i = 0; i < NINODE; i++) {
    8000251c:	08848493          	addi	s1,s1,136
    80002520:	ff3498e3          	bne	s1,s3,80002510 <init_inode_cache+0x3e>
    }
}
    80002524:	70a2                	ld	ra,40(sp)
    80002526:	7402                	ld	s0,32(sp)
    80002528:	64e2                	ld	s1,24(sp)
    8000252a:	6942                	ld	s2,16(sp)
    8000252c:	69a2                	ld	s3,8(sp)
    8000252e:	6145                	addi	sp,sp,48
    80002530:	8082                	ret

0000000080002532 <update_inode>:

// 将内存中的inode写入到磁盘中,
// 每次改变磁盘上的ip->xxx字段都需要调用该函数，
// 因为inode cache是write-through。
// 调用者必须持有ip->lock.
void update_inode(struct inode *ip) {
    80002532:	1101                	addi	sp,sp,-32
    80002534:	ec06                	sd	ra,24(sp)
    80002536:	e822                	sd	s0,16(sp)
    80002538:	e426                	sd	s1,8(sp)
    8000253a:	e04a                	sd	s2,0(sp)
    8000253c:	1000                	addi	s0,sp,32
    8000253e:	84aa                	mv	s1,a0
    struct buf *bp;
    struct dinode *dip;

    bp = buf_read(ip->dev, IBLOCK(ip->inum, sb));
    80002540:	415c                	lw	a5,4(a0)
    80002542:	0047d79b          	srliw	a5,a5,0x4
    80002546:	00050597          	auipc	a1,0x50
    8000254a:	aca5a583          	lw	a1,-1334(a1) # 80052010 <sb+0x10>
    8000254e:	9dbd                	addw	a1,a1,a5
    80002550:	4108                	lw	a0,0(a0)
    80002552:	00001097          	auipc	ra,0x1
    80002556:	b38080e7          	jalr	-1224(ra) # 8000308a <buf_read>
    8000255a:	892a                	mv	s2,a0
    dip = (struct dinode *) bp->data + ip->inum % IPB;
    8000255c:	04c50793          	addi	a5,a0,76
    80002560:	40c8                	lw	a0,4(s1)
    80002562:	893d                	andi	a0,a0,15
    80002564:	051a                	slli	a0,a0,0x6
    80002566:	953e                	add	a0,a0,a5
    dip->type = ip->type;
    80002568:	04449703          	lh	a4,68(s1)
    8000256c:	00e51023          	sh	a4,0(a0)
    dip->major = ip->major;
    80002570:	04649703          	lh	a4,70(s1)
    80002574:	00e51123          	sh	a4,2(a0)
    dip->minor = ip->minor;
    80002578:	04849703          	lh	a4,72(s1)
    8000257c:	00e51223          	sh	a4,4(a0)
    dip->nlink = ip->nlink;
    80002580:	04a49703          	lh	a4,74(s1)
    80002584:	00e51323          	sh	a4,6(a0)
    dip->size = ip->size;
    80002588:	44f8                	lw	a4,76(s1)
    8000258a:	c518                	sw	a4,8(a0)
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000258c:	03400613          	li	a2,52
    80002590:	05048593          	addi	a1,s1,80
    80002594:	0531                	addi	a0,a0,12
    80002596:	fffff097          	auipc	ra,0xfffff
    8000259a:	33c080e7          	jalr	828(ra) # 800018d2 <memmove>
    buf_write(bp);
    8000259e:	854a                	mv	a0,s2
    800025a0:	00001097          	auipc	ra,0x1
    800025a4:	b1e080e7          	jalr	-1250(ra) # 800030be <buf_write>
    relse_buf(bp);
    800025a8:	854a                	mv	a0,s2
    800025aa:	00001097          	auipc	ra,0x1
    800025ae:	b2e080e7          	jalr	-1234(ra) # 800030d8 <relse_buf>
}
    800025b2:	60e2                	ld	ra,24(sp)
    800025b4:	6442                	ld	s0,16(sp)
    800025b6:	64a2                	ld	s1,8(sp)
    800025b8:	6902                	ld	s2,0(sp)
    800025ba:	6105                	addi	sp,sp,32
    800025bc:	8082                	ret

00000000800025be <get_inode>:

// 通过inum从缓冲池中获取一个inode
struct inode *get_inode(int inum) {
    800025be:	7179                	addi	sp,sp,-48
    800025c0:	f406                	sd	ra,40(sp)
    800025c2:	f022                	sd	s0,32(sp)
    800025c4:	ec26                	sd	s1,24(sp)
    800025c6:	e84a                	sd	s2,16(sp)
    800025c8:	e44e                	sd	s3,8(sp)
    800025ca:	1800                	addi	s0,sp,48
    800025cc:	89aa                	mv	s3,a0
    struct inode *ip;
    struct inode *empty;
//    struct buf *bp;
//    struct dinode *dip;

    spin_lock(&inode_cache.lock);
    800025ce:	00050517          	auipc	a0,0x50
    800025d2:	a4a50513          	addi	a0,a0,-1462 # 80052018 <inode_cache>
    800025d6:	00001097          	auipc	ra,0x1
    800025da:	be4080e7          	jalr	-1052(ra) # 800031ba <spin_lock>
    empty = 0;
    800025de:	4901                	li	s2,0
    for (ip = &inode_cache.inode[0]; ip < &inode_cache.inode[NINODE]; ip++) {
    800025e0:	00050497          	auipc	s1,0x50
    800025e4:	a5048493          	addi	s1,s1,-1456 # 80052030 <inode_cache+0x18>
        if (ip->ref > 0 && ip->inum == inum) {
    800025e8:	0009861b          	sext.w	a2,s3
    for (ip = &inode_cache.inode[0]; ip < &inode_cache.inode[NINODE]; ip++) {
    800025ec:	00051697          	auipc	a3,0x51
    800025f0:	4d468693          	addi	a3,a3,1236 # 80053ac0 <cache_lock>
    800025f4:	a039                	j	80002602 <get_inode+0x44>
            ip->ref++;
            spin_unlock(&inode_cache.lock);
            return ip;
        }
        if (empty == 0 && ip->ref == 0) { // 记住未使用缓冲项
    800025f6:	02090e63          	beqz	s2,80002632 <get_inode+0x74>
    for (ip = &inode_cache.inode[0]; ip < &inode_cache.inode[NINODE]; ip++) {
    800025fa:	08848493          	addi	s1,s1,136
    800025fe:	02d48d63          	beq	s1,a3,80002638 <get_inode+0x7a>
        if (ip->ref > 0 && ip->inum == inum) {
    80002602:	449c                	lw	a5,8(s1)
    80002604:	fef059e3          	blez	a5,800025f6 <get_inode+0x38>
    80002608:	40d8                	lw	a4,4(s1)
    8000260a:	fec716e3          	bne	a4,a2,800025f6 <get_inode+0x38>
            ip->ref++;
    8000260e:	2785                	addiw	a5,a5,1
    80002610:	c49c                	sw	a5,8(s1)
            spin_unlock(&inode_cache.lock);
    80002612:	00050517          	auipc	a0,0x50
    80002616:	a0650513          	addi	a0,a0,-1530 # 80052018 <inode_cache>
    8000261a:	00001097          	auipc	ra,0x1
    8000261e:	c74080e7          	jalr	-908(ra) # 8000328e <spin_unlock>
    ip->inum = inum;
    ip->ref = 1;
    ip->valid = 0;
    spin_unlock(&inode_cache.lock);
    return ip;
}
    80002622:	8526                	mv	a0,s1
    80002624:	70a2                	ld	ra,40(sp)
    80002626:	7402                	ld	s0,32(sp)
    80002628:	64e2                	ld	s1,24(sp)
    8000262a:	6942                	ld	s2,16(sp)
    8000262c:	69a2                	ld	s3,8(sp)
    8000262e:	6145                	addi	sp,sp,48
    80002630:	8082                	ret
        if (empty == 0 && ip->ref == 0) { // 记住未使用缓冲项
    80002632:	f7e1                	bnez	a5,800025fa <get_inode+0x3c>
    80002634:	8926                	mv	s2,s1
    80002636:	b7d1                	j	800025fa <get_inode+0x3c>
    if (empty == 0) {
    80002638:	02090363          	beqz	s2,8000265e <get_inode+0xa0>
    ip->inum = inum;
    8000263c:	01392223          	sw	s3,4(s2)
    ip->ref = 1;
    80002640:	4785                	li	a5,1
    80002642:	00f92423          	sw	a5,8(s2)
    ip->valid = 0;
    80002646:	04092023          	sw	zero,64(s2)
    spin_unlock(&inode_cache.lock);
    8000264a:	00050517          	auipc	a0,0x50
    8000264e:	9ce50513          	addi	a0,a0,-1586 # 80052018 <inode_cache>
    80002652:	00001097          	auipc	ra,0x1
    80002656:	c3c080e7          	jalr	-964(ra) # 8000328e <spin_unlock>
    return ip;
    8000265a:	84ca                	mv	s1,s2
    8000265c:	b7d9                	j	80002622 <get_inode+0x64>
        panic("get_inode");
    8000265e:	00002517          	auipc	a0,0x2
    80002662:	fe250513          	addi	a0,a0,-30 # 80004640 <digits+0x5f0>
    80002666:	ffffe097          	auipc	ra,0xffffe
    8000266a:	10a080e7          	jalr	266(ra) # 80000770 <panic>
    8000266e:	b7f9                	j	8000263c <get_inode+0x7e>

0000000080002670 <alloc_inode>:
struct inode *alloc_inode(short type) {
    80002670:	7139                	addi	sp,sp,-64
    80002672:	fc06                	sd	ra,56(sp)
    80002674:	f822                	sd	s0,48(sp)
    80002676:	f426                	sd	s1,40(sp)
    80002678:	f04a                	sd	s2,32(sp)
    8000267a:	ec4e                	sd	s3,24(sp)
    8000267c:	e852                	sd	s4,16(sp)
    8000267e:	e456                	sd	s5,8(sp)
    80002680:	e05a                	sd	s6,0(sp)
    80002682:	0080                	addi	s0,sp,64
    for (inum = 1; inum < sb.ninodes; inum++) {
    80002684:	00050717          	auipc	a4,0x50
    80002688:	98872703          	lw	a4,-1656(a4) # 8005200c <sb+0xc>
    8000268c:	4785                	li	a5,1
    8000268e:	04e7f963          	bgeu	a5,a4,800026e0 <alloc_inode+0x70>
    80002692:	8b2a                	mv	s6,a0
    80002694:	4905                	li	s2,1
        bp = buf_read(0, IBLOCK(inum, sb));
    80002696:	00050a97          	auipc	s5,0x50
    8000269a:	96aa8a93          	addi	s5,s5,-1686 # 80052000 <sb>
    8000269e:	00090a1b          	sext.w	s4,s2
    800026a2:	00495593          	srli	a1,s2,0x4
    800026a6:	010aa783          	lw	a5,16(s5)
    800026aa:	9dbd                	addw	a1,a1,a5
    800026ac:	4501                	li	a0,0
    800026ae:	00001097          	auipc	ra,0x1
    800026b2:	9dc080e7          	jalr	-1572(ra) # 8000308a <buf_read>
    800026b6:	84aa                	mv	s1,a0
        dip = (struct dinode *) bp->data + inum % IPB;
    800026b8:	04c50993          	addi	s3,a0,76
    800026bc:	00fa7793          	andi	a5,s4,15
    800026c0:	079a                	slli	a5,a5,0x6
    800026c2:	99be                	add	s3,s3,a5
        if (dip->type == 0) { // a free inode
    800026c4:	00099783          	lh	a5,0(s3)
    800026c8:	cf9d                	beqz	a5,80002706 <alloc_inode+0x96>
        relse_buf(bp);
    800026ca:	00001097          	auipc	ra,0x1
    800026ce:	a0e080e7          	jalr	-1522(ra) # 800030d8 <relse_buf>
    for (inum = 1; inum < sb.ninodes; inum++) {
    800026d2:	0905                	addi	s2,s2,1
    800026d4:	00caa703          	lw	a4,12(s5)
    800026d8:	0009079b          	sext.w	a5,s2
    800026dc:	fce7e1e3          	bltu	a5,a4,8000269e <alloc_inode+0x2e>
    panic("alloc_inode: no inodes");
    800026e0:	00002517          	auipc	a0,0x2
    800026e4:	f7050513          	addi	a0,a0,-144 # 80004650 <digits+0x600>
    800026e8:	ffffe097          	auipc	ra,0xffffe
    800026ec:	088080e7          	jalr	136(ra) # 80000770 <panic>
    return 0;
    800026f0:	4501                	li	a0,0
}
    800026f2:	70e2                	ld	ra,56(sp)
    800026f4:	7442                	ld	s0,48(sp)
    800026f6:	74a2                	ld	s1,40(sp)
    800026f8:	7902                	ld	s2,32(sp)
    800026fa:	69e2                	ld	s3,24(sp)
    800026fc:	6a42                	ld	s4,16(sp)
    800026fe:	6aa2                	ld	s5,8(sp)
    80002700:	6b02                	ld	s6,0(sp)
    80002702:	6121                	addi	sp,sp,64
    80002704:	8082                	ret
            memset(dip, 0, sizeof(*dip));
    80002706:	04000613          	li	a2,64
    8000270a:	4581                	li	a1,0
    8000270c:	854e                	mv	a0,s3
    8000270e:	fffff097          	auipc	ra,0xfffff
    80002712:	19e080e7          	jalr	414(ra) # 800018ac <memset>
            dip->type = type;
    80002716:	01699023          	sh	s6,0(s3)
            buf_write(bp); // 写回磁盘
    8000271a:	8526                	mv	a0,s1
    8000271c:	00001097          	auipc	ra,0x1
    80002720:	9a2080e7          	jalr	-1630(ra) # 800030be <buf_write>
            relse_buf(bp);
    80002724:	8526                	mv	a0,s1
    80002726:	00001097          	auipc	ra,0x1
    8000272a:	9b2080e7          	jalr	-1614(ra) # 800030d8 <relse_buf>
            return get_inode(inum);
    8000272e:	8552                	mv	a0,s4
    80002730:	00000097          	auipc	ra,0x0
    80002734:	e8e080e7          	jalr	-370(ra) # 800025be <get_inode>
    80002738:	bf6d                	j	800026f2 <alloc_inode+0x82>

000000008000273a <bmap>:
    spin_unlock(&inode_cache.lock);
}

// 数据块包含直接块和间接块，这里只实现了直接块
// 获取inode的第bn个数据块对应的磁盘块号
uint bmap(struct inode *ip, uint bn) {
    8000273a:	1101                	addi	sp,sp,-32
    8000273c:	ec06                	sd	ra,24(sp)
    8000273e:	e822                	sd	s0,16(sp)
    80002740:	e426                	sd	s1,8(sp)
    80002742:	1000                	addi	s0,sp,32
    uint64 addr;
    if (bn < NDIRECT) {
    80002744:	47ad                	li	a5,11
    80002746:	02b7ea63          	bltu	a5,a1,8000277a <bmap+0x40>
        if ((addr = ip->addrs[bn]) == 0)
    8000274a:	1582                	slli	a1,a1,0x20
    8000274c:	9181                	srli	a1,a1,0x20
    8000274e:	058a                	slli	a1,a1,0x2
    80002750:	00b504b3          	add	s1,a0,a1
    80002754:	0504e783          	lwu	a5,80(s1)
    80002758:	cb81                	beqz	a5,80002768 <bmap+0x2e>
            ip->addrs[bn] = addr = alloc_disk_block();
        return addr;
    8000275a:	0007851b          	sext.w	a0,a5
    }

    panic("bmap");
    return 0;
}
    8000275e:	60e2                	ld	ra,24(sp)
    80002760:	6442                	ld	s0,16(sp)
    80002762:	64a2                	ld	s1,8(sp)
    80002764:	6105                	addi	sp,sp,32
    80002766:	8082                	ret
            ip->addrs[bn] = addr = alloc_disk_block();
    80002768:	00000097          	auipc	ra,0x0
    8000276c:	c02080e7          	jalr	-1022(ra) # 8000236a <alloc_disk_block>
    80002770:	02051793          	slli	a5,a0,0x20
    80002774:	9381                	srli	a5,a5,0x20
    80002776:	c8a8                	sw	a0,80(s1)
    80002778:	b7cd                	j	8000275a <bmap+0x20>
    panic("bmap");
    8000277a:	00002517          	auipc	a0,0x2
    8000277e:	eee50513          	addi	a0,a0,-274 # 80004668 <digits+0x618>
    80002782:	ffffe097          	auipc	ra,0xffffe
    80002786:	fee080e7          	jalr	-18(ra) # 80000770 <panic>
    return 0;
    8000278a:	4501                	li	a0,0
    8000278c:	bfc9                	j	8000275e <bmap+0x24>

000000008000278e <trunc_inode>:

// Truncate inode(移除内容)
// 调用者必须持有ip->lock
void trunc_inode(struct inode *ip) {
    8000278e:	7179                	addi	sp,sp,-48
    80002790:	f406                	sd	ra,40(sp)
    80002792:	f022                	sd	s0,32(sp)
    80002794:	ec26                	sd	s1,24(sp)
    80002796:	e84a                	sd	s2,16(sp)
    80002798:	e44e                	sd	s3,8(sp)
    8000279a:	e052                	sd	s4,0(sp)
    8000279c:	1800                	addi	s0,sp,48
    8000279e:	89aa                	mv	s3,a0
    int i, j;
    struct buf *bp;
    uint *a;

    for (i = 0; i < NDIRECT; i++) {
    800027a0:	05050493          	addi	s1,a0,80
    800027a4:	08050913          	addi	s2,a0,128
    800027a8:	a021                	j	800027b0 <trunc_inode+0x22>
    800027aa:	0491                	addi	s1,s1,4
    800027ac:	01248b63          	beq	s1,s2,800027c2 <trunc_inode+0x34>
        if (ip->addrs[i]) {
    800027b0:	4088                	lw	a0,0(s1)
    800027b2:	dd65                	beqz	a0,800027aa <trunc_inode+0x1c>
            free_disk_block(ip->addrs[i]);
    800027b4:	00000097          	auipc	ra,0x0
    800027b8:	caa080e7          	jalr	-854(ra) # 8000245e <free_disk_block>
            ip->addrs[i] = 0;
    800027bc:	0004a023          	sw	zero,0(s1)
    800027c0:	b7ed                	j	800027aa <trunc_inode+0x1c>
        }
    }

    if (ip->addrs[NDIRECT]) {
    800027c2:	0809a583          	lw	a1,128(s3)
    800027c6:	e185                	bnez	a1,800027e6 <trunc_inode+0x58>
        relse_buf(bp);
        free_disk_block(ip->addrs[NDIRECT]);
        ip->addrs[NDIRECT] = 0;
    }

    ip->size = 0;
    800027c8:	0409a623          	sw	zero,76(s3)
    update_inode(ip);
    800027cc:	854e                	mv	a0,s3
    800027ce:	00000097          	auipc	ra,0x0
    800027d2:	d64080e7          	jalr	-668(ra) # 80002532 <update_inode>
}
    800027d6:	70a2                	ld	ra,40(sp)
    800027d8:	7402                	ld	s0,32(sp)
    800027da:	64e2                	ld	s1,24(sp)
    800027dc:	6942                	ld	s2,16(sp)
    800027de:	69a2                	ld	s3,8(sp)
    800027e0:	6a02                	ld	s4,0(sp)
    800027e2:	6145                	addi	sp,sp,48
    800027e4:	8082                	ret
        bp = buf_read(ip->dev, ip->addrs[NDIRECT]);
    800027e6:	0009a503          	lw	a0,0(s3)
    800027ea:	00001097          	auipc	ra,0x1
    800027ee:	8a0080e7          	jalr	-1888(ra) # 8000308a <buf_read>
    800027f2:	8a2a                	mv	s4,a0
        for (j = 0; j < NINDIRECT; j++) {
    800027f4:	04c50493          	addi	s1,a0,76
    800027f8:	44c50913          	addi	s2,a0,1100
    800027fc:	a801                	j	8000280c <trunc_inode+0x7e>
                free_disk_block(a[j]);
    800027fe:	00000097          	auipc	ra,0x0
    80002802:	c60080e7          	jalr	-928(ra) # 8000245e <free_disk_block>
        for (j = 0; j < NINDIRECT; j++) {
    80002806:	0491                	addi	s1,s1,4
    80002808:	01248563          	beq	s1,s2,80002812 <trunc_inode+0x84>
            if (a[j])
    8000280c:	4088                	lw	a0,0(s1)
    8000280e:	dd65                	beqz	a0,80002806 <trunc_inode+0x78>
    80002810:	b7fd                	j	800027fe <trunc_inode+0x70>
        relse_buf(bp);
    80002812:	8552                	mv	a0,s4
    80002814:	00001097          	auipc	ra,0x1
    80002818:	8c4080e7          	jalr	-1852(ra) # 800030d8 <relse_buf>
        free_disk_block(ip->addrs[NDIRECT]);
    8000281c:	0809a503          	lw	a0,128(s3)
    80002820:	00000097          	auipc	ra,0x0
    80002824:	c3e080e7          	jalr	-962(ra) # 8000245e <free_disk_block>
        ip->addrs[NDIRECT] = 0;
    80002828:	0809a023          	sw	zero,128(s3)
    8000282c:	bf71                	j	800027c8 <trunc_inode+0x3a>

000000008000282e <putback_inode>:
void putback_inode(struct inode *ip) {
    8000282e:	1101                	addi	sp,sp,-32
    80002830:	ec06                	sd	ra,24(sp)
    80002832:	e822                	sd	s0,16(sp)
    80002834:	e426                	sd	s1,8(sp)
    80002836:	e04a                	sd	s2,0(sp)
    80002838:	1000                	addi	s0,sp,32
    8000283a:	84aa                	mv	s1,a0
    spin_lock(&inode_cache.lock);
    8000283c:	0004f517          	auipc	a0,0x4f
    80002840:	7dc50513          	addi	a0,a0,2012 # 80052018 <inode_cache>
    80002844:	00001097          	auipc	ra,0x1
    80002848:	976080e7          	jalr	-1674(ra) # 800031ba <spin_lock>
    if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    8000284c:	4498                	lw	a4,8(s1)
    8000284e:	4785                	li	a5,1
    80002850:	02f70363          	beq	a4,a5,80002876 <putback_inode+0x48>
    ip->ref--;
    80002854:	449c                	lw	a5,8(s1)
    80002856:	37fd                	addiw	a5,a5,-1
    80002858:	c49c                	sw	a5,8(s1)
    spin_unlock(&inode_cache.lock);
    8000285a:	0004f517          	auipc	a0,0x4f
    8000285e:	7be50513          	addi	a0,a0,1982 # 80052018 <inode_cache>
    80002862:	00001097          	auipc	ra,0x1
    80002866:	a2c080e7          	jalr	-1492(ra) # 8000328e <spin_unlock>
}
    8000286a:	60e2                	ld	ra,24(sp)
    8000286c:	6442                	ld	s0,16(sp)
    8000286e:	64a2                	ld	s1,8(sp)
    80002870:	6902                	ld	s2,0(sp)
    80002872:	6105                	addi	sp,sp,32
    80002874:	8082                	ret
    if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    80002876:	40bc                	lw	a5,64(s1)
    80002878:	dff1                	beqz	a5,80002854 <putback_inode+0x26>
    8000287a:	04a49783          	lh	a5,74(s1)
    8000287e:	fbf9                	bnez	a5,80002854 <putback_inode+0x26>
        sleep_lock(&ip->lock);
    80002880:	01048913          	addi	s2,s1,16
    80002884:	854a                	mv	a0,s2
    80002886:	00001097          	auipc	ra,0x1
    8000288a:	a9e080e7          	jalr	-1378(ra) # 80003324 <sleep_lock>
        spin_unlock(&inode_cache.lock);
    8000288e:	0004f517          	auipc	a0,0x4f
    80002892:	78a50513          	addi	a0,a0,1930 # 80052018 <inode_cache>
    80002896:	00001097          	auipc	ra,0x1
    8000289a:	9f8080e7          	jalr	-1544(ra) # 8000328e <spin_unlock>
        trunc_inode(ip);
    8000289e:	8526                	mv	a0,s1
    800028a0:	00000097          	auipc	ra,0x0
    800028a4:	eee080e7          	jalr	-274(ra) # 8000278e <trunc_inode>
        ip->type = 0;
    800028a8:	04049223          	sh	zero,68(s1)
        update_inode(ip);
    800028ac:	8526                	mv	a0,s1
    800028ae:	00000097          	auipc	ra,0x0
    800028b2:	c84080e7          	jalr	-892(ra) # 80002532 <update_inode>
        ip->valid = 0;
    800028b6:	0404a023          	sw	zero,64(s1)
        sleep_unlock(&ip->lock);
    800028ba:	854a                	mv	a0,s2
    800028bc:	00001097          	auipc	ra,0x1
    800028c0:	abe080e7          	jalr	-1346(ra) # 8000337a <sleep_unlock>
        spin_lock(&inode_cache.lock);
    800028c4:	0004f517          	auipc	a0,0x4f
    800028c8:	75450513          	addi	a0,a0,1876 # 80052018 <inode_cache>
    800028cc:	00001097          	auipc	ra,0x1
    800028d0:	8ee080e7          	jalr	-1810(ra) # 800031ba <spin_lock>
    800028d4:	b741                	j	80002854 <putback_inode+0x26>

00000000800028d6 <dup_inode>:

// 递增ip->ref
struct inode *dup_inode(struct inode *ip) {
    800028d6:	1101                	addi	sp,sp,-32
    800028d8:	ec06                	sd	ra,24(sp)
    800028da:	e822                	sd	s0,16(sp)
    800028dc:	e426                	sd	s1,8(sp)
    800028de:	1000                	addi	s0,sp,32
    800028e0:	84aa                	mv	s1,a0
    spin_lock(&inode_cache.lock);
    800028e2:	0004f517          	auipc	a0,0x4f
    800028e6:	73650513          	addi	a0,a0,1846 # 80052018 <inode_cache>
    800028ea:	00001097          	auipc	ra,0x1
    800028ee:	8d0080e7          	jalr	-1840(ra) # 800031ba <spin_lock>
    ip->ref++;
    800028f2:	449c                	lw	a5,8(s1)
    800028f4:	2785                	addiw	a5,a5,1
    800028f6:	c49c                	sw	a5,8(s1)
    spin_unlock(&inode_cache.lock);
    800028f8:	0004f517          	auipc	a0,0x4f
    800028fc:	72050513          	addi	a0,a0,1824 # 80052018 <inode_cache>
    80002900:	00001097          	auipc	ra,0x1
    80002904:	98e080e7          	jalr	-1650(ra) # 8000328e <spin_unlock>
    return ip;
}
    80002908:	8526                	mv	a0,s1
    8000290a:	60e2                	ld	ra,24(sp)
    8000290c:	6442                	ld	s0,16(sp)
    8000290e:	64a2                	ld	s1,8(sp)
    80002910:	6105                	addi	sp,sp,32
    80002912:	8082                	ret

0000000080002914 <lock_inode>:

// 锁定给定的inode
// 需要时读取从磁盘读数据
void lock_inode(struct inode *ip) {
    80002914:	1101                	addi	sp,sp,-32
    80002916:	ec06                	sd	ra,24(sp)
    80002918:	e822                	sd	s0,16(sp)
    8000291a:	e426                	sd	s1,8(sp)
    8000291c:	e04a                	sd	s2,0(sp)
    8000291e:	1000                	addi	s0,sp,32
    80002920:	84aa                	mv	s1,a0
    struct buf *bp;
    struct dinode *dip;

    if (ip == 0 || ip->ref < 1)
    80002922:	c501                	beqz	a0,8000292a <lock_inode+0x16>
    80002924:	451c                	lw	a5,8(a0)
    80002926:	00f04a63          	bgtz	a5,8000293a <lock_inode+0x26>
        panic("lock_inode");
    8000292a:	00002517          	auipc	a0,0x2
    8000292e:	d4650513          	addi	a0,a0,-698 # 80004670 <digits+0x620>
    80002932:	ffffe097          	auipc	ra,0xffffe
    80002936:	e3e080e7          	jalr	-450(ra) # 80000770 <panic>

    sleep_lock(&ip->lock);
    8000293a:	01048513          	addi	a0,s1,16
    8000293e:	00001097          	auipc	ra,0x1
    80002942:	9e6080e7          	jalr	-1562(ra) # 80003324 <sleep_lock>

    if (ip->valid == 0) {
    80002946:	40bc                	lw	a5,64(s1)
    80002948:	c799                	beqz	a5,80002956 <lock_inode+0x42>
        relse_buf(bp);
        ip->valid = 1;
        if (ip->type == 0)
            panic("lock_inode: no type");
    }
}
    8000294a:	60e2                	ld	ra,24(sp)
    8000294c:	6442                	ld	s0,16(sp)
    8000294e:	64a2                	ld	s1,8(sp)
    80002950:	6902                	ld	s2,0(sp)
    80002952:	6105                	addi	sp,sp,32
    80002954:	8082                	ret
        bp = buf_read(ip->dev, IBLOCK(ip->inum, sb));
    80002956:	40dc                	lw	a5,4(s1)
    80002958:	0047d79b          	srliw	a5,a5,0x4
    8000295c:	0004f597          	auipc	a1,0x4f
    80002960:	6b45a583          	lw	a1,1716(a1) # 80052010 <sb+0x10>
    80002964:	9dbd                	addw	a1,a1,a5
    80002966:	4088                	lw	a0,0(s1)
    80002968:	00000097          	auipc	ra,0x0
    8000296c:	722080e7          	jalr	1826(ra) # 8000308a <buf_read>
    80002970:	892a                	mv	s2,a0
        dip = (struct dinode *) bp->data + ip->inum % IPB;
    80002972:	04c50593          	addi	a1,a0,76
    80002976:	40dc                	lw	a5,4(s1)
    80002978:	8bbd                	andi	a5,a5,15
    8000297a:	079a                	slli	a5,a5,0x6
    8000297c:	95be                	add	a1,a1,a5
        ip->type = dip->type;
    8000297e:	00059783          	lh	a5,0(a1)
    80002982:	04f49223          	sh	a5,68(s1)
        ip->major = dip->major;
    80002986:	00259783          	lh	a5,2(a1)
    8000298a:	04f49323          	sh	a5,70(s1)
        ip->minor = dip->minor;
    8000298e:	00459783          	lh	a5,4(a1)
    80002992:	04f49423          	sh	a5,72(s1)
        ip->nlink = dip->nlink;
    80002996:	00659783          	lh	a5,6(a1)
    8000299a:	04f49523          	sh	a5,74(s1)
        ip->size = dip->size;
    8000299e:	459c                	lw	a5,8(a1)
    800029a0:	c4fc                	sw	a5,76(s1)
        memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800029a2:	03400613          	li	a2,52
    800029a6:	05b1                	addi	a1,a1,12
    800029a8:	05048513          	addi	a0,s1,80
    800029ac:	fffff097          	auipc	ra,0xfffff
    800029b0:	f26080e7          	jalr	-218(ra) # 800018d2 <memmove>
        relse_buf(bp);
    800029b4:	854a                	mv	a0,s2
    800029b6:	00000097          	auipc	ra,0x0
    800029ba:	722080e7          	jalr	1826(ra) # 800030d8 <relse_buf>
        ip->valid = 1;
    800029be:	4785                	li	a5,1
    800029c0:	c0bc                	sw	a5,64(s1)
        if (ip->type == 0)
    800029c2:	04449783          	lh	a5,68(s1)
    800029c6:	f3d1                	bnez	a5,8000294a <lock_inode+0x36>
            panic("lock_inode: no type");
    800029c8:	00002517          	auipc	a0,0x2
    800029cc:	cb850513          	addi	a0,a0,-840 # 80004680 <digits+0x630>
    800029d0:	ffffe097          	auipc	ra,0xffffe
    800029d4:	da0080e7          	jalr	-608(ra) # 80000770 <panic>
}
    800029d8:	bf8d                	j	8000294a <lock_inode+0x36>

00000000800029da <unlock_inode>:

// 解锁inode.
void unlock_inode(struct inode *ip) {
    800029da:	1101                	addi	sp,sp,-32
    800029dc:	ec06                	sd	ra,24(sp)
    800029de:	e822                	sd	s0,16(sp)
    800029e0:	e426                	sd	s1,8(sp)
    800029e2:	1000                	addi	s0,sp,32
    800029e4:	84aa                	mv	s1,a0
    if (ip == 0 || !sleep_holding(&ip->lock) || ip->ref < 1)
    800029e6:	c911                	beqz	a0,800029fa <unlock_inode+0x20>
    800029e8:	0541                	addi	a0,a0,16
    800029ea:	00001097          	auipc	ra,0x1
    800029ee:	9d4080e7          	jalr	-1580(ra) # 800033be <sleep_holding>
    800029f2:	c501                	beqz	a0,800029fa <unlock_inode+0x20>
    800029f4:	449c                	lw	a5,8(s1)
    800029f6:	00f04a63          	bgtz	a5,80002a0a <unlock_inode+0x30>
        panic("unlock_inode");
    800029fa:	00002517          	auipc	a0,0x2
    800029fe:	c9e50513          	addi	a0,a0,-866 # 80004698 <digits+0x648>
    80002a02:	ffffe097          	auipc	ra,0xffffe
    80002a06:	d6e080e7          	jalr	-658(ra) # 80000770 <panic>
    sleep_unlock(&ip->lock);
    80002a0a:	01048513          	addi	a0,s1,16
    80002a0e:	00001097          	auipc	ra,0x1
    80002a12:	96c080e7          	jalr	-1684(ra) # 8000337a <sleep_unlock>
}
    80002a16:	60e2                	ld	ra,24(sp)
    80002a18:	6442                	ld	s0,16(sp)
    80002a1a:	64a2                	ld	s1,8(sp)
    80002a1c:	6105                	addi	sp,sp,32
    80002a1e:	8082                	ret

0000000080002a20 <unlock_and_putback>:

void unlock_and_putback(struct inode *ip) {
    80002a20:	1101                	addi	sp,sp,-32
    80002a22:	ec06                	sd	ra,24(sp)
    80002a24:	e822                	sd	s0,16(sp)
    80002a26:	e426                	sd	s1,8(sp)
    80002a28:	1000                	addi	s0,sp,32
    80002a2a:	84aa                	mv	s1,a0
    unlock_inode(ip);
    80002a2c:	00000097          	auipc	ra,0x0
    80002a30:	fae080e7          	jalr	-82(ra) # 800029da <unlock_inode>
    putback_inode(ip);
    80002a34:	8526                	mv	a0,s1
    80002a36:	00000097          	auipc	ra,0x0
    80002a3a:	df8080e7          	jalr	-520(ra) # 8000282e <putback_inode>
}
    80002a3e:	60e2                	ld	ra,24(sp)
    80002a40:	6442                	ld	s0,16(sp)
    80002a42:	64a2                	ld	s1,8(sp)
    80002a44:	6105                	addi	sp,sp,32
    80002a46:	8082                	ret

0000000080002a48 <read_inode>:

// 从inode中读取数据
int read_inode(struct inode *ip, uint64 dst, uint off, int n) {
    80002a48:	711d                	addi	sp,sp,-96
    80002a4a:	ec86                	sd	ra,88(sp)
    80002a4c:	e8a2                	sd	s0,80(sp)
    80002a4e:	e4a6                	sd	s1,72(sp)
    80002a50:	e0ca                	sd	s2,64(sp)
    80002a52:	fc4e                	sd	s3,56(sp)
    80002a54:	f852                	sd	s4,48(sp)
    80002a56:	f456                	sd	s5,40(sp)
    80002a58:	f05a                	sd	s6,32(sp)
    80002a5a:	ec5e                	sd	s7,24(sp)
    80002a5c:	e862                	sd	s8,16(sp)
    80002a5e:	e466                	sd	s9,8(sp)
    80002a60:	1080                	addi	s0,sp,96
    int total = 0, m = 0;
    struct buf *bp;
    if (off > ip->size || off + n < off) {
    80002a62:	457c                	lw	a5,76(a0)
        return 0;
    80002a64:	4981                	li	s3,0
    if (off > ip->size || off + n < off) {
    80002a66:	02c7e463          	bltu	a5,a2,80002a8e <read_inode+0x46>
    80002a6a:	8baa                	mv	s7,a0
    80002a6c:	8aae                	mv	s5,a1
    80002a6e:	84b2                	mv	s1,a2
    80002a70:	8b36                	mv	s6,a3
    80002a72:	00c6873b          	addw	a4,a3,a2
        return 0;
    80002a76:	4981                	li	s3,0
    if (off > ip->size || off + n < off) {
    80002a78:	00c76b63          	bltu	a4,a2,80002a8e <read_inode+0x46>
    }
    if (off + n > ip->size) {
    80002a7c:	00e7f463          	bgeu	a5,a4,80002a84 <read_inode+0x3c>
        n = ip->size - off;
    80002a80:	40c78b3b          	subw	s6,a5,a2
    }

    for (; total < n; total += m, off += m, dst += m) {
    80002a84:	4981                	li	s3,0
        bp = buf_read(0, bmap(ip, off / BSIZE));
        m = min(BSIZE - off % BSIZE, n - total);
    80002a86:	40000c13          	li	s8,1024
    for (; total < n; total += m, off += m, dst += m) {
    80002a8a:	05604763          	bgtz	s6,80002ad8 <read_inode+0x90>
        memmove((uint64 *) (dst), bp->data + (off % BSIZE), m);
        relse_buf(bp);
    }
    return total;
}
    80002a8e:	854e                	mv	a0,s3
    80002a90:	60e6                	ld	ra,88(sp)
    80002a92:	6446                	ld	s0,80(sp)
    80002a94:	64a6                	ld	s1,72(sp)
    80002a96:	6906                	ld	s2,64(sp)
    80002a98:	79e2                	ld	s3,56(sp)
    80002a9a:	7a42                	ld	s4,48(sp)
    80002a9c:	7aa2                	ld	s5,40(sp)
    80002a9e:	7b02                	ld	s6,32(sp)
    80002aa0:	6be2                	ld	s7,24(sp)
    80002aa2:	6c42                	ld	s8,16(sp)
    80002aa4:	6ca2                	ld	s9,8(sp)
    80002aa6:	6125                	addi	sp,sp,96
    80002aa8:	8082                	ret
        m = min(BSIZE - off % BSIZE, n - total);
    80002aaa:	000a0c9b          	sext.w	s9,s4
        memmove((uint64 *) (dst), bp->data + (off % BSIZE), m);
    80002aae:	04c90593          	addi	a1,s2,76
    80002ab2:	8666                	mv	a2,s9
    80002ab4:	95ba                	add	a1,a1,a4
    80002ab6:	8556                	mv	a0,s5
    80002ab8:	fffff097          	auipc	ra,0xfffff
    80002abc:	e1a080e7          	jalr	-486(ra) # 800018d2 <memmove>
        relse_buf(bp);
    80002ac0:	854a                	mv	a0,s2
    80002ac2:	00000097          	auipc	ra,0x0
    80002ac6:	616080e7          	jalr	1558(ra) # 800030d8 <relse_buf>
    for (; total < n; total += m, off += m, dst += m) {
    80002aca:	013a09bb          	addw	s3,s4,s3
    80002ace:	009a04bb          	addw	s1,s4,s1
    80002ad2:	9ae6                	add	s5,s5,s9
    80002ad4:	fb69dde3          	bge	s3,s6,80002a8e <read_inode+0x46>
        bp = buf_read(0, bmap(ip, off / BSIZE));
    80002ad8:	00a4d59b          	srliw	a1,s1,0xa
    80002adc:	855e                	mv	a0,s7
    80002ade:	00000097          	auipc	ra,0x0
    80002ae2:	c5c080e7          	jalr	-932(ra) # 8000273a <bmap>
    80002ae6:	0005059b          	sext.w	a1,a0
    80002aea:	4501                	li	a0,0
    80002aec:	00000097          	auipc	ra,0x0
    80002af0:	59e080e7          	jalr	1438(ra) # 8000308a <buf_read>
    80002af4:	892a                	mv	s2,a0
        m = min(BSIZE - off % BSIZE, n - total);
    80002af6:	3ff4f713          	andi	a4,s1,1023
    80002afa:	413b07bb          	subw	a5,s6,s3
    80002afe:	40ec06bb          	subw	a3,s8,a4
    80002b02:	8a3e                	mv	s4,a5
    80002b04:	2781                	sext.w	a5,a5
    80002b06:	0006861b          	sext.w	a2,a3
    80002b0a:	faf670e3          	bgeu	a2,a5,80002aaa <read_inode+0x62>
    80002b0e:	8a36                	mv	s4,a3
    80002b10:	bf69                	j	80002aaa <read_inode+0x62>

0000000080002b12 <write_inode>:

// 将数据写入inode
int write_inode(struct inode *ip, uint64 src, uint64 off, int n) {
    80002b12:	711d                	addi	sp,sp,-96
    80002b14:	ec86                	sd	ra,88(sp)
    80002b16:	e8a2                	sd	s0,80(sp)
    80002b18:	e4a6                	sd	s1,72(sp)
    80002b1a:	e0ca                	sd	s2,64(sp)
    80002b1c:	fc4e                	sd	s3,56(sp)
    80002b1e:	f852                	sd	s4,48(sp)
    80002b20:	f456                	sd	s5,40(sp)
    80002b22:	f05a                	sd	s6,32(sp)
    80002b24:	ec5e                	sd	s7,24(sp)
    80002b26:	e862                	sd	s8,16(sp)
    80002b28:	e466                	sd	s9,8(sp)
    80002b2a:	1080                	addi	s0,sp,96
    uint total, m;
    struct buf *bp;

    if (off > ip->size || off + n < off)
    80002b2c:	04c56783          	lwu	a5,76(a0)
    80002b30:	0cc7e763          	bltu	a5,a2,80002bfe <write_inode+0xec>
    80002b34:	8baa                	mv	s7,a0
    80002b36:	8aae                	mv	s5,a1
    80002b38:	89b2                	mv	s3,a2
    80002b3a:	8cb6                	mv	s9,a3
    80002b3c:	00c687b3          	add	a5,a3,a2
    80002b40:	0cc7e163          	bltu	a5,a2,80002c02 <write_inode+0xf0>
        return -1;
    if (off + n > MAXFILE * BSIZE)
    80002b44:	00043737          	lui	a4,0x43
    80002b48:	0af76f63          	bltu	a4,a5,80002c06 <write_inode+0xf4>
        return -1;
    for (total = 0; total < n; total += m, off += m, src += m) {
    80002b4c:	00068b1b          	sext.w	s6,a3
    80002b50:	0a0b0d63          	beqz	s6,80002c0a <write_inode+0xf8>
    80002b54:	4a01                	li	s4,0
        bp = buf_read(0, bmap(ip, off / BSIZE));
        m = min(BSIZE - off % BSIZE, n - total);
    80002b56:	40000c13          	li	s8,1024
    80002b5a:	a81d                	j	80002b90 <write_inode+0x7e>
        memmove(bp->data + (off % BSIZE), (uint64 *) (src), m);
    80002b5c:	04c90513          	addi	a0,s2,76
    80002b60:	0004861b          	sext.w	a2,s1
    80002b64:	85d6                	mv	a1,s5
    80002b66:	953e                	add	a0,a0,a5
    80002b68:	fffff097          	auipc	ra,0xfffff
    80002b6c:	d6a080e7          	jalr	-662(ra) # 800018d2 <memmove>
        buf_write(bp);
    80002b70:	854a                	mv	a0,s2
    80002b72:	00000097          	auipc	ra,0x0
    80002b76:	54c080e7          	jalr	1356(ra) # 800030be <buf_write>
        relse_buf(bp);
    80002b7a:	854a                	mv	a0,s2
    80002b7c:	00000097          	auipc	ra,0x0
    80002b80:	55c080e7          	jalr	1372(ra) # 800030d8 <relse_buf>
    for (total = 0; total < n; total += m, off += m, src += m) {
    80002b84:	01448a3b          	addw	s4,s1,s4
    80002b88:	99a6                	add	s3,s3,s1
    80002b8a:	9aa6                	add	s5,s5,s1
    80002b8c:	036a7e63          	bgeu	s4,s6,80002bc8 <write_inode+0xb6>
        bp = buf_read(0, bmap(ip, off / BSIZE));
    80002b90:	00a9d593          	srli	a1,s3,0xa
    80002b94:	2581                	sext.w	a1,a1
    80002b96:	855e                	mv	a0,s7
    80002b98:	00000097          	auipc	ra,0x0
    80002b9c:	ba2080e7          	jalr	-1118(ra) # 8000273a <bmap>
    80002ba0:	0005059b          	sext.w	a1,a0
    80002ba4:	4501                	li	a0,0
    80002ba6:	00000097          	auipc	ra,0x0
    80002baa:	4e4080e7          	jalr	1252(ra) # 8000308a <buf_read>
    80002bae:	892a                	mv	s2,a0
        m = min(BSIZE - off % BSIZE, n - total);
    80002bb0:	3ff9f793          	andi	a5,s3,1023
    80002bb4:	414b04bb          	subw	s1,s6,s4
    80002bb8:	40fc0733          	sub	a4,s8,a5
    80002bbc:	1482                	slli	s1,s1,0x20
    80002bbe:	9081                	srli	s1,s1,0x20
    80002bc0:	f8977ee3          	bgeu	a4,s1,80002b5c <write_inode+0x4a>
    80002bc4:	84ba                	mv	s1,a4
    80002bc6:	bf59                	j	80002b5c <write_inode+0x4a>
    }
    if (n > 0) {
    80002bc8:	01905d63          	blez	s9,80002be2 <write_inode+0xd0>
        if (off > ip->size)
    80002bcc:	04cbe783          	lwu	a5,76(s7) # 204c <_entry-0x7fffdfb4>
    80002bd0:	0137f463          	bgeu	a5,s3,80002bd8 <write_inode+0xc6>
            ip->size = off;
    80002bd4:	053ba623          	sw	s3,76(s7)
        // 将内存中的inode写入磁盘，即使没有写入数据，也需要更新，因为循环中可能
        //调用了bmap()或者在ip->addrs[]里面添加了数据块
        update_inode(ip);
    80002bd8:	855e                	mv	a0,s7
    80002bda:	00000097          	auipc	ra,0x0
    80002bde:	958080e7          	jalr	-1704(ra) # 80002532 <update_inode>
    }
    return n;
}
    80002be2:	8566                	mv	a0,s9
    80002be4:	60e6                	ld	ra,88(sp)
    80002be6:	6446                	ld	s0,80(sp)
    80002be8:	64a6                	ld	s1,72(sp)
    80002bea:	6906                	ld	s2,64(sp)
    80002bec:	79e2                	ld	s3,56(sp)
    80002bee:	7a42                	ld	s4,48(sp)
    80002bf0:	7aa2                	ld	s5,40(sp)
    80002bf2:	7b02                	ld	s6,32(sp)
    80002bf4:	6be2                	ld	s7,24(sp)
    80002bf6:	6c42                	ld	s8,16(sp)
    80002bf8:	6ca2                	ld	s9,8(sp)
    80002bfa:	6125                	addi	sp,sp,96
    80002bfc:	8082                	ret
        return -1;
    80002bfe:	5cfd                	li	s9,-1
    80002c00:	b7cd                	j	80002be2 <write_inode+0xd0>
    80002c02:	5cfd                	li	s9,-1
    80002c04:	bff9                	j	80002be2 <write_inode+0xd0>
        return -1;
    80002c06:	5cfd                	li	s9,-1
    80002c08:	bfe9                	j	80002be2 <write_inode+0xd0>
    return n;
    80002c0a:	4c81                	li	s9,0
    80002c0c:	bfd9                	j	80002be2 <write_inode+0xd0>

0000000080002c0e <namecmp>:
// 目录层
//
// 第一个inode为根目录，该目录在mkfs/makefs下创建
//

int namecmp(const char *s, const char *t) {
    80002c0e:	1141                	addi	sp,sp,-16
    80002c10:	e406                	sd	ra,8(sp)
    80002c12:	e022                	sd	s0,0(sp)
    80002c14:	0800                	addi	s0,sp,16
    return strncmp(s, t, DIRSIZ);
    80002c16:	4639                	li	a2,14
    80002c18:	fffff097          	auipc	ra,0xfffff
    80002c1c:	d7e080e7          	jalr	-642(ra) # 80001996 <strncmp>
}
    80002c20:	60a2                	ld	ra,8(sp)
    80002c22:	6402                	ld	s0,0(sp)
    80002c24:	0141                	addi	sp,sp,16
    80002c26:	8082                	ret

0000000080002c28 <dirlookup>:
//
//  dirlookup 在一个目录中搜索一个带有给定名称的条目。如果找到
// 了，它返回一个指向相应 inode 的指针，解锁该 inode，并将*poff
// 设置为目录中条目的字节偏移量，以便调用者编辑它。
//
struct inode *dirlookup(struct inode *dp, char *name, uint *poff) {
    80002c28:	715d                	addi	sp,sp,-80
    80002c2a:	e486                	sd	ra,72(sp)
    80002c2c:	e0a2                	sd	s0,64(sp)
    80002c2e:	fc26                	sd	s1,56(sp)
    80002c30:	f84a                	sd	s2,48(sp)
    80002c32:	f44e                	sd	s3,40(sp)
    80002c34:	f052                	sd	s4,32(sp)
    80002c36:	ec56                	sd	s5,24(sp)
    80002c38:	0880                	addi	s0,sp,80
    80002c3a:	892a                	mv	s2,a0
    80002c3c:	89ae                	mv	s3,a1
    80002c3e:	8ab2                	mv	s5,a2
    uint off, inum;
    struct direntry de;

    if (dp->type != T_DIR)
    80002c40:	04451703          	lh	a4,68(a0)
    80002c44:	4785                	li	a5,1
    80002c46:	00f71b63          	bne	a4,a5,80002c5c <dirlookup+0x34>
        panic("dirlookup not DIR");

    for (off = 0; off < dp->size; off += sizeof(de)) {
    80002c4a:	04c92783          	lw	a5,76(s2)
    80002c4e:	c7d9                	beqz	a5,80002cdc <dirlookup+0xb4>
    80002c50:	4481                	li	s1,0
        if (read_inode(dp, (uint64) &de, off, sizeof(de)) != sizeof(de))
            panic("dirlookup read");
    80002c52:	00002a17          	auipc	s4,0x2
    80002c56:	a6ea0a13          	addi	s4,s4,-1426 # 800046c0 <digits+0x670>
    80002c5a:	a02d                	j	80002c84 <dirlookup+0x5c>
        panic("dirlookup not DIR");
    80002c5c:	00002517          	auipc	a0,0x2
    80002c60:	a4c50513          	addi	a0,a0,-1460 # 800046a8 <digits+0x658>
    80002c64:	ffffe097          	auipc	ra,0xffffe
    80002c68:	b0c080e7          	jalr	-1268(ra) # 80000770 <panic>
    80002c6c:	bff9                	j	80002c4a <dirlookup+0x22>
            panic("dirlookup read");
    80002c6e:	8552                	mv	a0,s4
    80002c70:	ffffe097          	auipc	ra,0xffffe
    80002c74:	b00080e7          	jalr	-1280(ra) # 80000770 <panic>
    80002c78:	a015                	j	80002c9c <dirlookup+0x74>
    for (off = 0; off < dp->size; off += sizeof(de)) {
    80002c7a:	24c1                	addiw	s1,s1,16
    80002c7c:	04c92783          	lw	a5,76(s2)
    80002c80:	04f4f463          	bgeu	s1,a5,80002cc8 <dirlookup+0xa0>
        if (read_inode(dp, (uint64) &de, off, sizeof(de)) != sizeof(de))
    80002c84:	46c1                	li	a3,16
    80002c86:	8626                	mv	a2,s1
    80002c88:	fb040593          	addi	a1,s0,-80
    80002c8c:	854a                	mv	a0,s2
    80002c8e:	00000097          	auipc	ra,0x0
    80002c92:	dba080e7          	jalr	-582(ra) # 80002a48 <read_inode>
    80002c96:	47c1                	li	a5,16
    80002c98:	fcf51be3          	bne	a0,a5,80002c6e <dirlookup+0x46>
        if (de.inum == 0)
    80002c9c:	fb045783          	lhu	a5,-80(s0)
    80002ca0:	dfe9                	beqz	a5,80002c7a <dirlookup+0x52>
            continue;
        if (namecmp(name, de.name) == 0) {
    80002ca2:	fb240593          	addi	a1,s0,-78
    80002ca6:	854e                	mv	a0,s3
    80002ca8:	00000097          	auipc	ra,0x0
    80002cac:	f66080e7          	jalr	-154(ra) # 80002c0e <namecmp>
    80002cb0:	f569                	bnez	a0,80002c7a <dirlookup+0x52>
            // 该目录包含该该名称
            if (poff)
    80002cb2:	000a8463          	beqz	s5,80002cba <dirlookup+0x92>
                *poff = off;
    80002cb6:	009aa023          	sw	s1,0(s5)
            inum = de.inum;
            return get_inode(inum);
    80002cba:	fb045503          	lhu	a0,-80(s0)
    80002cbe:	00000097          	auipc	ra,0x0
    80002cc2:	900080e7          	jalr	-1792(ra) # 800025be <get_inode>
    80002cc6:	a011                	j	80002cca <dirlookup+0xa2>
        }
    }

    return 0;
    80002cc8:	4501                	li	a0,0
}
    80002cca:	60a6                	ld	ra,72(sp)
    80002ccc:	6406                	ld	s0,64(sp)
    80002cce:	74e2                	ld	s1,56(sp)
    80002cd0:	7942                	ld	s2,48(sp)
    80002cd2:	79a2                	ld	s3,40(sp)
    80002cd4:	7a02                	ld	s4,32(sp)
    80002cd6:	6ae2                	ld	s5,24(sp)
    80002cd8:	6161                	addi	sp,sp,80
    80002cda:	8082                	ret
    return 0;
    80002cdc:	4501                	li	a0,0
    80002cde:	b7f5                	j	80002cca <dirlookup+0xa2>

0000000080002ce0 <namex>:

// 根据path返回一个inode
// 该函数供nameiparent和namei使用
// 如果parent!=0返回父目录的inode并且复制最后一个元素到name中，
// name必须拥有足够的空间来存储DIRSIZE字节的字符串。
static struct inode *namex(char *path, int nameiparent, char *name) {
    80002ce0:	711d                	addi	sp,sp,-96
    80002ce2:	ec86                	sd	ra,88(sp)
    80002ce4:	e8a2                	sd	s0,80(sp)
    80002ce6:	e4a6                	sd	s1,72(sp)
    80002ce8:	e0ca                	sd	s2,64(sp)
    80002cea:	fc4e                	sd	s3,56(sp)
    80002cec:	f852                	sd	s4,48(sp)
    80002cee:	f456                	sd	s5,40(sp)
    80002cf0:	f05a                	sd	s6,32(sp)
    80002cf2:	ec5e                	sd	s7,24(sp)
    80002cf4:	e862                	sd	s8,16(sp)
    80002cf6:	e466                	sd	s9,8(sp)
    80002cf8:	1080                	addi	s0,sp,96
    80002cfa:	84aa                	mv	s1,a0
    80002cfc:	8b2e                	mv	s6,a1
    80002cfe:	8ab2                	mv	s5,a2
    struct inode *ip, *next;
    struct proc *p = myproc();
    80002d00:	ffffe097          	auipc	ra,0xffffe
    80002d04:	13a080e7          	jalr	314(ra) # 80000e3a <myproc>
    if (*path == '/')
    80002d08:	0004c703          	lbu	a4,0(s1)
    80002d0c:	02f00793          	li	a5,47
    80002d10:	02f70063          	beq	a4,a5,80002d30 <namex+0x50>
        ip = get_inode(ROOTINO);
    else
        ip = get_inode(p->current_dir->inum); // TODO 修改：从进程的当前path
    80002d14:	16053783          	ld	a5,352(a0)
    80002d18:	43c8                	lw	a0,4(a5)
    80002d1a:	00000097          	auipc	ra,0x0
    80002d1e:	8a4080e7          	jalr	-1884(ra) # 800025be <get_inode>
    80002d22:	89aa                	mv	s3,a0
    while (*path == '/')
    80002d24:	02f00913          	li	s2,47
    len = path - s;
    80002d28:	4b81                	li	s7,0
    if (len >= DIRSIZ)
    80002d2a:	4cb5                	li	s9,13

    while ((path = skipelem(path, name)) != 0) {
        lock_inode(ip);
        if (ip->type != T_DIR) {
    80002d2c:	4c05                	li	s8,1
    80002d2e:	a84d                	j	80002de0 <namex+0x100>
        ip = get_inode(ROOTINO);
    80002d30:	4501                	li	a0,0
    80002d32:	00000097          	auipc	ra,0x0
    80002d36:	88c080e7          	jalr	-1908(ra) # 800025be <get_inode>
    80002d3a:	89aa                	mv	s3,a0
    80002d3c:	b7e5                	j	80002d24 <namex+0x44>
            unlock_and_putback(ip);
    80002d3e:	854e                	mv	a0,s3
    80002d40:	00000097          	auipc	ra,0x0
    80002d44:	ce0080e7          	jalr	-800(ra) # 80002a20 <unlock_and_putback>
            return 0;
    80002d48:	4981                	li	s3,0
    if (nameiparent) {
        putback_inode(ip);
        return 0;
    }
    return ip;
}
    80002d4a:	854e                	mv	a0,s3
    80002d4c:	60e6                	ld	ra,88(sp)
    80002d4e:	6446                	ld	s0,80(sp)
    80002d50:	64a6                	ld	s1,72(sp)
    80002d52:	6906                	ld	s2,64(sp)
    80002d54:	79e2                	ld	s3,56(sp)
    80002d56:	7a42                	ld	s4,48(sp)
    80002d58:	7aa2                	ld	s5,40(sp)
    80002d5a:	7b02                	ld	s6,32(sp)
    80002d5c:	6be2                	ld	s7,24(sp)
    80002d5e:	6c42                	ld	s8,16(sp)
    80002d60:	6ca2                	ld	s9,8(sp)
    80002d62:	6125                	addi	sp,sp,96
    80002d64:	8082                	ret
            unlock_inode(ip);
    80002d66:	854e                	mv	a0,s3
    80002d68:	00000097          	auipc	ra,0x0
    80002d6c:	c72080e7          	jalr	-910(ra) # 800029da <unlock_inode>
            return ip;
    80002d70:	bfe9                	j	80002d4a <namex+0x6a>
            unlock_and_putback(ip);
    80002d72:	854e                	mv	a0,s3
    80002d74:	00000097          	auipc	ra,0x0
    80002d78:	cac080e7          	jalr	-852(ra) # 80002a20 <unlock_and_putback>
            return 0;
    80002d7c:	89d2                	mv	s3,s4
    80002d7e:	b7f1                	j	80002d4a <namex+0x6a>
    len = path - s;
    80002d80:	40b48a3b          	subw	s4,s1,a1
    if (len >= DIRSIZ)
    80002d84:	094cd363          	bge	s9,s4,80002e0a <namex+0x12a>
        memmove(name, s, DIRSIZ);
    80002d88:	4639                	li	a2,14
    80002d8a:	8556                	mv	a0,s5
    80002d8c:	fffff097          	auipc	ra,0xfffff
    80002d90:	b46080e7          	jalr	-1210(ra) # 800018d2 <memmove>
    while (*path == '/')
    80002d94:	0004c783          	lbu	a5,0(s1)
    80002d98:	01279763          	bne	a5,s2,80002da6 <namex+0xc6>
        path++;
    80002d9c:	0485                	addi	s1,s1,1
    while (*path == '/')
    80002d9e:	0004c783          	lbu	a5,0(s1)
    80002da2:	ff278de3          	beq	a5,s2,80002d9c <namex+0xbc>
        lock_inode(ip);
    80002da6:	854e                	mv	a0,s3
    80002da8:	00000097          	auipc	ra,0x0
    80002dac:	b6c080e7          	jalr	-1172(ra) # 80002914 <lock_inode>
        if (ip->type != T_DIR) {
    80002db0:	04499783          	lh	a5,68(s3)
    80002db4:	f98795e3          	bne	a5,s8,80002d3e <namex+0x5e>
        if (nameiparent && *path == '\0') {
    80002db8:	000b0563          	beqz	s6,80002dc2 <namex+0xe2>
    80002dbc:	0004c783          	lbu	a5,0(s1)
    80002dc0:	d3dd                	beqz	a5,80002d66 <namex+0x86>
        if ((next = dirlookup(ip, name, 0)) == 0) {
    80002dc2:	865e                	mv	a2,s7
    80002dc4:	85d6                	mv	a1,s5
    80002dc6:	854e                	mv	a0,s3
    80002dc8:	00000097          	auipc	ra,0x0
    80002dcc:	e60080e7          	jalr	-416(ra) # 80002c28 <dirlookup>
    80002dd0:	8a2a                	mv	s4,a0
    80002dd2:	d145                	beqz	a0,80002d72 <namex+0x92>
        unlock_and_putback(ip);
    80002dd4:	854e                	mv	a0,s3
    80002dd6:	00000097          	auipc	ra,0x0
    80002dda:	c4a080e7          	jalr	-950(ra) # 80002a20 <unlock_and_putback>
        ip = next;
    80002dde:	89d2                	mv	s3,s4
    while (*path == '/')
    80002de0:	0004c783          	lbu	a5,0(s1)
    80002de4:	05279663          	bne	a5,s2,80002e30 <namex+0x150>
        path++;
    80002de8:	0485                	addi	s1,s1,1
    while (*path == '/')
    80002dea:	0004c783          	lbu	a5,0(s1)
    80002dee:	ff278de3          	beq	a5,s2,80002de8 <namex+0x108>
    if (*path == 0)
    80002df2:	c795                	beqz	a5,80002e1e <namex+0x13e>
        path++;
    80002df4:	85a6                	mv	a1,s1
    len = path - s;
    80002df6:	8a5e                	mv	s4,s7
    while (*path != '/' && *path != 0)
    80002df8:	01278963          	beq	a5,s2,80002e0a <namex+0x12a>
    80002dfc:	d3d1                	beqz	a5,80002d80 <namex+0xa0>
        path++;
    80002dfe:	0485                	addi	s1,s1,1
    while (*path != '/' && *path != 0)
    80002e00:	0004c783          	lbu	a5,0(s1)
    80002e04:	ff279ce3          	bne	a5,s2,80002dfc <namex+0x11c>
    80002e08:	bfa5                	j	80002d80 <namex+0xa0>
        memmove(name, s, len);
    80002e0a:	8652                	mv	a2,s4
    80002e0c:	8556                	mv	a0,s5
    80002e0e:	fffff097          	auipc	ra,0xfffff
    80002e12:	ac4080e7          	jalr	-1340(ra) # 800018d2 <memmove>
        name[len] = 0;
    80002e16:	9a56                	add	s4,s4,s5
    80002e18:	000a0023          	sb	zero,0(s4)
    80002e1c:	bfa5                	j	80002d94 <namex+0xb4>
    if (nameiparent) {
    80002e1e:	f20b06e3          	beqz	s6,80002d4a <namex+0x6a>
        putback_inode(ip);
    80002e22:	854e                	mv	a0,s3
    80002e24:	00000097          	auipc	ra,0x0
    80002e28:	a0a080e7          	jalr	-1526(ra) # 8000282e <putback_inode>
        return 0;
    80002e2c:	4981                	li	s3,0
    80002e2e:	bf31                	j	80002d4a <namex+0x6a>
    if (*path == 0)
    80002e30:	d7fd                	beqz	a5,80002e1e <namex+0x13e>
    while (*path != '/' && *path != 0)
    80002e32:	0004c783          	lbu	a5,0(s1)
    80002e36:	85a6                	mv	a1,s1
    80002e38:	b7d1                	j	80002dfc <namex+0x11c>

0000000080002e3a <dirlink>:
int dirlink(struct inode *dp, char *name, uint inum) {
    80002e3a:	715d                	addi	sp,sp,-80
    80002e3c:	e486                	sd	ra,72(sp)
    80002e3e:	e0a2                	sd	s0,64(sp)
    80002e40:	fc26                	sd	s1,56(sp)
    80002e42:	f84a                	sd	s2,48(sp)
    80002e44:	f44e                	sd	s3,40(sp)
    80002e46:	f052                	sd	s4,32(sp)
    80002e48:	ec56                	sd	s5,24(sp)
    80002e4a:	e85a                	sd	s6,16(sp)
    80002e4c:	0880                	addi	s0,sp,80
    80002e4e:	89aa                	mv	s3,a0
    80002e50:	8b2e                	mv	s6,a1
    80002e52:	8ab2                	mv	s5,a2
    if ((ip = dirlookup(dp, name, 0)) != 0) {
    80002e54:	4601                	li	a2,0
    80002e56:	00000097          	auipc	ra,0x0
    80002e5a:	dd2080e7          	jalr	-558(ra) # 80002c28 <dirlookup>
    80002e5e:	ed21                	bnez	a0,80002eb6 <dirlink+0x7c>
    for (off = 0; off < dp->size; off += sizeof(de)) {
    80002e60:	04c9a783          	lw	a5,76(s3)
    80002e64:	4481                	li	s1,0
    80002e66:	4901                	li	s2,0
            panic("dirlink read");
    80002e68:	00002a17          	auipc	s4,0x2
    80002e6c:	868a0a13          	addi	s4,s4,-1944 # 800046d0 <digits+0x680>
    for (off = 0; off < dp->size; off += sizeof(de)) {
    80002e70:	ebb5                	bnez	a5,80002ee4 <dirlink+0xaa>
    strncpy(de.name, name, DIRSIZ);
    80002e72:	4639                	li	a2,14
    80002e74:	85da                	mv	a1,s6
    80002e76:	fb240513          	addi	a0,s0,-78
    80002e7a:	fffff097          	auipc	ra,0xfffff
    80002e7e:	ade080e7          	jalr	-1314(ra) # 80001958 <strncpy>
    de.inum = inum;
    80002e82:	fb541823          	sh	s5,-80(s0)
    if (write_inode(dp, (uint64) &de, off, sizeof(de)) != sizeof(de))
    80002e86:	46c1                	li	a3,16
    80002e88:	8626                	mv	a2,s1
    80002e8a:	fb040593          	addi	a1,s0,-80
    80002e8e:	854e                	mv	a0,s3
    80002e90:	00000097          	auipc	ra,0x0
    80002e94:	c82080e7          	jalr	-894(ra) # 80002b12 <write_inode>
    80002e98:	872a                	mv	a4,a0
    80002e9a:	47c1                	li	a5,16
    return 0;
    80002e9c:	4501                	li	a0,0
    if (write_inode(dp, (uint64) &de, off, sizeof(de)) != sizeof(de))
    80002e9e:	06f71063          	bne	a4,a5,80002efe <dirlink+0xc4>
}
    80002ea2:	60a6                	ld	ra,72(sp)
    80002ea4:	6406                	ld	s0,64(sp)
    80002ea6:	74e2                	ld	s1,56(sp)
    80002ea8:	7942                	ld	s2,48(sp)
    80002eaa:	79a2                	ld	s3,40(sp)
    80002eac:	7a02                	ld	s4,32(sp)
    80002eae:	6ae2                	ld	s5,24(sp)
    80002eb0:	6b42                	ld	s6,16(sp)
    80002eb2:	6161                	addi	sp,sp,80
    80002eb4:	8082                	ret
        putback_inode(ip);
    80002eb6:	00000097          	auipc	ra,0x0
    80002eba:	978080e7          	jalr	-1672(ra) # 8000282e <putback_inode>
        return -1;
    80002ebe:	557d                	li	a0,-1
    80002ec0:	b7cd                	j	80002ea2 <dirlink+0x68>
            panic("dirlink read");
    80002ec2:	8552                	mv	a0,s4
    80002ec4:	ffffe097          	auipc	ra,0xffffe
    80002ec8:	8ac080e7          	jalr	-1876(ra) # 80000770 <panic>
        if (de.inum == 0)
    80002ecc:	fb045783          	lhu	a5,-80(s0)
    80002ed0:	d3cd                	beqz	a5,80002e72 <dirlink+0x38>
    for (off = 0; off < dp->size; off += sizeof(de)) {
    80002ed2:	0109079b          	addiw	a5,s2,16
    80002ed6:	0007891b          	sext.w	s2,a5
    80002eda:	84ca                	mv	s1,s2
    80002edc:	04c9a783          	lw	a5,76(s3)
    80002ee0:	f8f979e3          	bgeu	s2,a5,80002e72 <dirlink+0x38>
        if (read_inode(dp, (uint64) &de, off, sizeof(de)) != sizeof(de))
    80002ee4:	46c1                	li	a3,16
    80002ee6:	864a                	mv	a2,s2
    80002ee8:	fb040593          	addi	a1,s0,-80
    80002eec:	854e                	mv	a0,s3
    80002eee:	00000097          	auipc	ra,0x0
    80002ef2:	b5a080e7          	jalr	-1190(ra) # 80002a48 <read_inode>
    80002ef6:	47c1                	li	a5,16
    80002ef8:	fcf50ae3          	beq	a0,a5,80002ecc <dirlink+0x92>
    80002efc:	b7d9                	j	80002ec2 <dirlink+0x88>
        panic("dirlink");
    80002efe:	00001517          	auipc	a0,0x1
    80002f02:	7e250513          	addi	a0,a0,2018 # 800046e0 <digits+0x690>
    80002f06:	ffffe097          	auipc	ra,0xffffe
    80002f0a:	86a080e7          	jalr	-1942(ra) # 80000770 <panic>
    return 0;
    80002f0e:	4501                	li	a0,0
    80002f10:	bf49                	j	80002ea2 <dirlink+0x68>

0000000080002f12 <namei>:

struct inode *namei(char *path) {
    80002f12:	1101                	addi	sp,sp,-32
    80002f14:	ec06                	sd	ra,24(sp)
    80002f16:	e822                	sd	s0,16(sp)
    80002f18:	1000                	addi	s0,sp,32
    char name[DIRSIZ];
    return namex(path, 0, name);
    80002f1a:	fe040613          	addi	a2,s0,-32
    80002f1e:	4581                	li	a1,0
    80002f20:	00000097          	auipc	ra,0x0
    80002f24:	dc0080e7          	jalr	-576(ra) # 80002ce0 <namex>
}
    80002f28:	60e2                	ld	ra,24(sp)
    80002f2a:	6442                	ld	s0,16(sp)
    80002f2c:	6105                	addi	sp,sp,32
    80002f2e:	8082                	ret

0000000080002f30 <nameiparent>:

struct inode *nameiparent(char *path, char *name) {
    80002f30:	1141                	addi	sp,sp,-16
    80002f32:	e406                	sd	ra,8(sp)
    80002f34:	e022                	sd	s0,0(sp)
    80002f36:	0800                	addi	s0,sp,16
    80002f38:	862e                	mv	a2,a1
    return namex(path, 1, name);
    80002f3a:	4585                	li	a1,1
    80002f3c:	00000097          	auipc	ra,0x0
    80002f40:	da4080e7          	jalr	-604(ra) # 80002ce0 <namex>
    80002f44:	60a2                	ld	ra,8(sp)
    80002f46:	6402                	ld	s0,0(sp)
    80002f48:	0141                	addi	sp,sp,16
    80002f4a:	8082                	ret

0000000080002f4c <init_buf>:
#define BUFFER_NUM 100

struct buf buf_cache[BUFFER_NUM];
struct spinlock cache_lock;

void init_buf() {
    80002f4c:	7179                	addi	sp,sp,-48
    80002f4e:	f406                	sd	ra,40(sp)
    80002f50:	f022                	sd	s0,32(sp)
    80002f52:	ec26                	sd	s1,24(sp)
    80002f54:	e84a                	sd	s2,16(sp)
    80002f56:	e44e                	sd	s3,8(sp)
    80002f58:	1800                	addi	s0,sp,48
    spinlock_init(&cache_lock, "cache lock");
    80002f5a:	00001597          	auipc	a1,0x1
    80002f5e:	78e58593          	addi	a1,a1,1934 # 800046e8 <digits+0x698>
    80002f62:	00051517          	auipc	a0,0x51
    80002f66:	b5e50513          	addi	a0,a0,-1186 # 80053ac0 <cache_lock>
    80002f6a:	00000097          	auipc	ra,0x0
    80002f6e:	1c0080e7          	jalr	448(ra) # 8000312a <spinlock_init>
    80002f72:	06400493          	li	s1,100
    for (int i = 0; i < BUFFER_NUM; i++) {
        sleeplock_init(&buf_cache->lock, "buf");
    80002f76:	00001997          	auipc	s3,0x1
    80002f7a:	78298993          	addi	s3,s3,1922 # 800046f8 <digits+0x6a8>
    80002f7e:	00051917          	auipc	s2,0x51
    80002f82:	b7290913          	addi	s2,s2,-1166 # 80053af0 <buf_cache+0x18>
    80002f86:	85ce                	mv	a1,s3
    80002f88:	854a                	mv	a0,s2
    80002f8a:	00000097          	auipc	ra,0x0
    80002f8e:	360080e7          	jalr	864(ra) # 800032ea <sleeplock_init>
    for (int i = 0; i < BUFFER_NUM; i++) {
    80002f92:	34fd                	addiw	s1,s1,-1
    80002f94:	f8ed                	bnez	s1,80002f86 <init_buf+0x3a>
    }
}
    80002f96:	70a2                	ld	ra,40(sp)
    80002f98:	7402                	ld	s0,32(sp)
    80002f9a:	64e2                	ld	s1,24(sp)
    80002f9c:	6942                	ld	s2,16(sp)
    80002f9e:	69a2                	ld	s3,8(sp)
    80002fa0:	6145                	addi	sp,sp,48
    80002fa2:	8082                	ret

0000000080002fa4 <alloc_buf>:
extern uint64 ticks;


// 申请使用一个缓冲区，该缓冲区会被锁定
// 先进先出算法
struct buf *alloc_buf(int dev, int blockno) {
    80002fa4:	7179                	addi	sp,sp,-48
    80002fa6:	f406                	sd	ra,40(sp)
    80002fa8:	f022                	sd	s0,32(sp)
    80002faa:	ec26                	sd	s1,24(sp)
    80002fac:	e84a                	sd	s2,16(sp)
    80002fae:	e44e                	sd	s3,8(sp)
    80002fb0:	e052                	sd	s4,0(sp)
    80002fb2:	1800                	addi	s0,sp,48
    80002fb4:	8a2a                	mv	s4,a0
    80002fb6:	892e                	mv	s2,a1
    struct buf *b;
    struct buf *earliest = 0;
    spin_lock(&cache_lock);
    80002fb8:	00051517          	auipc	a0,0x51
    80002fbc:	b0850513          	addi	a0,a0,-1272 # 80053ac0 <cache_lock>
    80002fc0:	00000097          	auipc	ra,0x0
    80002fc4:	1fa080e7          	jalr	506(ra) # 800031ba <spin_lock>
    struct buf *earliest = 0;
    80002fc8:	4981                	li	s3,0
    for (b = buf_cache; b < buf_cache + BUFFER_NUM; b++) {
    80002fca:	00051497          	auipc	s1,0x51
    80002fce:	b0e48493          	addi	s1,s1,-1266 # 80053ad8 <buf_cache>
        if (b->refcnt == 0 &&
            (earliest == 0 || b->last_use_tick < earliest->last_use_tick)) {
            earliest = b;
        }
        if (b->blockno == blockno) {
    80002fd2:	2901                	sext.w	s2,s2
    for (b = buf_cache; b < buf_cache + BUFFER_NUM; b++) {
    80002fd4:	0006c717          	auipc	a4,0x6c
    80002fd8:	a4470713          	addi	a4,a4,-1468 # 8006ea18 <buf_cache+0x1af40>
    80002fdc:	a809                	j	80002fee <alloc_buf+0x4a>
    80002fde:	89a6                	mv	s3,s1
        if (b->blockno == blockno) {
    80002fe0:	44dc                	lw	a5,12(s1)
    80002fe2:	03278163          	beq	a5,s2,80003004 <alloc_buf+0x60>
    for (b = buf_cache; b < buf_cache + BUFFER_NUM; b++) {
    80002fe6:	45048493          	addi	s1,s1,1104
    80002fea:	04e48c63          	beq	s1,a4,80003042 <alloc_buf+0x9e>
        if (b->refcnt == 0 &&
    80002fee:	44bc                	lw	a5,72(s1)
    80002ff0:	fbe5                	bnez	a5,80002fe0 <alloc_buf+0x3c>
    80002ff2:	fe0986e3          	beqz	s3,80002fde <alloc_buf+0x3a>
            (earliest == 0 || b->last_use_tick < earliest->last_use_tick)) {
    80002ff6:	6894                	ld	a3,16(s1)
    80002ff8:	0109b783          	ld	a5,16(s3)
    80002ffc:	fef6f2e3          	bgeu	a3,a5,80002fe0 <alloc_buf+0x3c>
    80003000:	89a6                	mv	s3,s1
    80003002:	bff9                	j	80002fe0 <alloc_buf+0x3c>
            spin_unlock(&cache_lock);
    80003004:	00051517          	auipc	a0,0x51
    80003008:	abc50513          	addi	a0,a0,-1348 # 80053ac0 <cache_lock>
    8000300c:	00000097          	auipc	ra,0x0
    80003010:	282080e7          	jalr	642(ra) # 8000328e <spin_unlock>
            b->refcnt++;
    80003014:	44bc                	lw	a5,72(s1)
    80003016:	2785                	addiw	a5,a5,1
    80003018:	c4bc                	sw	a5,72(s1)
            b->last_use_tick = ticks;
    8000301a:	00002797          	auipc	a5,0x2
    8000301e:	ff67b783          	ld	a5,-10(a5) # 80005010 <ticks>
    80003022:	e89c                	sd	a5,16(s1)
            sleep_lock(&b->lock);
    80003024:	01848513          	addi	a0,s1,24
    80003028:	00000097          	auipc	ra,0x0
    8000302c:	2fc080e7          	jalr	764(ra) # 80003324 <sleep_lock>
    b->refcnt = 1;
    b->blockno = blockno;
    b->dev = dev;
    b->last_use_tick = ticks;
    return b;
}
    80003030:	8526                	mv	a0,s1
    80003032:	70a2                	ld	ra,40(sp)
    80003034:	7402                	ld	s0,32(sp)
    80003036:	64e2                	ld	s1,24(sp)
    80003038:	6942                	ld	s2,16(sp)
    8000303a:	69a2                	ld	s3,8(sp)
    8000303c:	6a02                	ld	s4,0(sp)
    8000303e:	6145                	addi	sp,sp,48
    80003040:	8082                	ret
    spin_unlock(&cache_lock);
    80003042:	00051517          	auipc	a0,0x51
    80003046:	a7e50513          	addi	a0,a0,-1410 # 80053ac0 <cache_lock>
    8000304a:	00000097          	auipc	ra,0x0
    8000304e:	244080e7          	jalr	580(ra) # 8000328e <spin_unlock>
    if (earliest == 0) {
    80003052:	02098363          	beqz	s3,80003078 <alloc_buf+0xd4>
    b->valid = 0;
    80003056:	0009a023          	sw	zero,0(s3)
    b->refcnt = 1;
    8000305a:	4785                	li	a5,1
    8000305c:	04f9a423          	sw	a5,72(s3)
    b->blockno = blockno;
    80003060:	0129a623          	sw	s2,12(s3)
    b->dev = dev;
    80003064:	0149a423          	sw	s4,8(s3)
    b->last_use_tick = ticks;
    80003068:	00002797          	auipc	a5,0x2
    8000306c:	fa87b783          	ld	a5,-88(a5) # 80005010 <ticks>
    80003070:	00f9b823          	sd	a5,16(s3)
    return b;
    80003074:	84ce                	mv	s1,s3
    80003076:	bf6d                	j	80003030 <alloc_buf+0x8c>
        panic("alloc buf");
    80003078:	00001517          	auipc	a0,0x1
    8000307c:	68850513          	addi	a0,a0,1672 # 80004700 <digits+0x6b0>
    80003080:	ffffd097          	auipc	ra,0xffffd
    80003084:	6f0080e7          	jalr	1776(ra) # 80000770 <panic>
    80003088:	b7f9                	j	80003056 <alloc_buf+0xb2>

000000008000308a <buf_read>:
    buf_write(b);
    sleep_unlock(&b->lock);
}

// 读取给定块的内容，返回一个包含该内容的buf
struct buf *buf_read(int dev, int blockno) {
    8000308a:	1101                	addi	sp,sp,-32
    8000308c:	ec06                	sd	ra,24(sp)
    8000308e:	e822                	sd	s0,16(sp)
    80003090:	e426                	sd	s1,8(sp)
    80003092:	1000                	addi	s0,sp,32
    struct buf *b = alloc_buf(dev, blockno);
    80003094:	00000097          	auipc	ra,0x0
    80003098:	f10080e7          	jalr	-240(ra) # 80002fa4 <alloc_buf>
    8000309c:	84aa                	mv	s1,a0
    if (!b->valid) {
    8000309e:	411c                	lw	a5,0(a0)
    800030a0:	cb89                	beqz	a5,800030b2 <buf_read+0x28>
        virtio_disk_rw(b, 0);
    }
    b->valid = 1;
    800030a2:	4785                	li	a5,1
    800030a4:	c09c                	sw	a5,0(s1)
    return b;
}
    800030a6:	8526                	mv	a0,s1
    800030a8:	60e2                	ld	ra,24(sp)
    800030aa:	6442                	ld	s0,16(sp)
    800030ac:	64a2                	ld	s1,8(sp)
    800030ae:	6105                	addi	sp,sp,32
    800030b0:	8082                	ret
        virtio_disk_rw(b, 0);
    800030b2:	4581                	li	a1,0
    800030b4:	fffff097          	auipc	ra,0xfffff
    800030b8:	d0c080e7          	jalr	-756(ra) # 80001dc0 <virtio_disk_rw>
    800030bc:	b7dd                	j	800030a2 <buf_read+0x18>

00000000800030be <buf_write>:

// 将缓冲区写入磁盘
void buf_write(struct buf *b) {
    800030be:	1141                	addi	sp,sp,-16
    800030c0:	e406                	sd	ra,8(sp)
    800030c2:	e022                	sd	s0,0(sp)
    800030c4:	0800                	addi	s0,sp,16
    virtio_disk_rw(b, 1);
    800030c6:	4585                	li	a1,1
    800030c8:	fffff097          	auipc	ra,0xfffff
    800030cc:	cf8080e7          	jalr	-776(ra) # 80001dc0 <virtio_disk_rw>
}
    800030d0:	60a2                	ld	ra,8(sp)
    800030d2:	6402                	ld	s0,0(sp)
    800030d4:	0141                	addi	sp,sp,16
    800030d6:	8082                	ret

00000000800030d8 <relse_buf>:
void relse_buf(struct buf *b) {
    800030d8:	1101                	addi	sp,sp,-32
    800030da:	ec06                	sd	ra,24(sp)
    800030dc:	e822                	sd	s0,16(sp)
    800030de:	e426                	sd	s1,8(sp)
    800030e0:	e04a                	sd	s2,0(sp)
    800030e2:	1000                	addi	s0,sp,32
    800030e4:	84aa                	mv	s1,a0
    spin_lock(&cache_lock);
    800030e6:	00051917          	auipc	s2,0x51
    800030ea:	9da90913          	addi	s2,s2,-1574 # 80053ac0 <cache_lock>
    800030ee:	854a                	mv	a0,s2
    800030f0:	00000097          	auipc	ra,0x0
    800030f4:	0ca080e7          	jalr	202(ra) # 800031ba <spin_lock>
    b->refcnt--;
    800030f8:	44bc                	lw	a5,72(s1)
    800030fa:	37fd                	addiw	a5,a5,-1
    800030fc:	c4bc                	sw	a5,72(s1)
    spin_unlock(&cache_lock);
    800030fe:	854a                	mv	a0,s2
    80003100:	00000097          	auipc	ra,0x0
    80003104:	18e080e7          	jalr	398(ra) # 8000328e <spin_unlock>
    buf_write(b);
    80003108:	8526                	mv	a0,s1
    8000310a:	00000097          	auipc	ra,0x0
    8000310e:	fb4080e7          	jalr	-76(ra) # 800030be <buf_write>
    sleep_unlock(&b->lock);
    80003112:	01848513          	addi	a0,s1,24
    80003116:	00000097          	auipc	ra,0x0
    8000311a:	264080e7          	jalr	612(ra) # 8000337a <sleep_unlock>
}
    8000311e:	60e2                	ld	ra,24(sp)
    80003120:	6442                	ld	s0,16(sp)
    80003122:	64a2                	ld	s1,8(sp)
    80003124:	6902                	ld	s2,0(sp)
    80003126:	6105                	addi	sp,sp,32
    80003128:	8082                	ret

000000008000312a <spinlock_init>:
#include "lock.h"
#include "../process.h"
#include "../riscv.h"
#include "../defs.h"

void spinlock_init(struct spinlock *lk, char *name) {
    8000312a:	1141                	addi	sp,sp,-16
    8000312c:	e422                	sd	s0,8(sp)
    8000312e:	0800                	addi	s0,sp,16
    lk->cpu = 0;
    80003130:	00053423          	sd	zero,8(a0)
    lk->name = name;
    80003134:	e90c                	sd	a1,16(a0)
    lk->locked = 0;
    80003136:	00052023          	sw	zero,0(a0)
}
    8000313a:	6422                	ld	s0,8(sp)
    8000313c:	0141                	addi	sp,sp,16
    8000313e:	8082                	ret

0000000080003140 <spin_holding>:

// 检查当前cpu是否持有这个锁
// 需要关中断
int spin_holding(struct spinlock *lk) {
    int r;
    r = (lk->locked && lk->cpu == mycpu());
    80003140:	411c                	lw	a5,0(a0)
    80003142:	e399                	bnez	a5,80003148 <spin_holding+0x8>
    80003144:	4501                	li	a0,0
    return r;
}
    80003146:	8082                	ret
int spin_holding(struct spinlock *lk) {
    80003148:	1101                	addi	sp,sp,-32
    8000314a:	ec06                	sd	ra,24(sp)
    8000314c:	e822                	sd	s0,16(sp)
    8000314e:	e426                	sd	s1,8(sp)
    80003150:	1000                	addi	s0,sp,32
    r = (lk->locked && lk->cpu == mycpu());
    80003152:	6504                	ld	s1,8(a0)
    80003154:	ffffe097          	auipc	ra,0xffffe
    80003158:	cca080e7          	jalr	-822(ra) # 80000e1e <mycpu>
    8000315c:	40a48533          	sub	a0,s1,a0
    80003160:	00153513          	seqz	a0,a0
}
    80003164:	60e2                	ld	ra,24(sp)
    80003166:	6442                	ld	s0,16(sp)
    80003168:	64a2                	ld	s1,8(sp)
    8000316a:	6105                	addi	sp,sp,32
    8000316c:	8082                	ret

000000008000316e <push_off>:

// push_off/pop_off 和 intr_off/intr_on 差不多，只是使得
// 开关中断可以嵌套使用。
void push_off(void) {
    8000316e:	1101                	addi	sp,sp,-32
    80003170:	ec06                	sd	ra,24(sp)
    80003172:	e822                	sd	s0,16(sp)
    80003174:	e426                	sd	s1,8(sp)
    80003176:	1000                	addi	s0,sp,32

static inline uint64
r_sstatus()
{
  uint64 x;
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003178:	100024f3          	csrr	s1,sstatus
    8000317c:	100027f3          	csrr	a5,sstatus

// disable device interrupts
static inline void
intr_off()
{
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80003180:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003182:	10079073          	csrw	sstatus,a5
    int old = intr_get();
    intr_off();
    if (mycpu()->noff == 0)
    80003186:	ffffe097          	auipc	ra,0xffffe
    8000318a:	c98080e7          	jalr	-872(ra) # 80000e1e <mycpu>
    8000318e:	5d3c                	lw	a5,120(a0)
    80003190:	cf89                	beqz	a5,800031aa <push_off+0x3c>
        mycpu()->intr_enable = old;
    mycpu()->noff += 1;
    80003192:	ffffe097          	auipc	ra,0xffffe
    80003196:	c8c080e7          	jalr	-884(ra) # 80000e1e <mycpu>
    8000319a:	5d3c                	lw	a5,120(a0)
    8000319c:	2785                	addiw	a5,a5,1
    8000319e:	dd3c                	sw	a5,120(a0)
}
    800031a0:	60e2                	ld	ra,24(sp)
    800031a2:	6442                	ld	s0,16(sp)
    800031a4:	64a2                	ld	s1,8(sp)
    800031a6:	6105                	addi	sp,sp,32
    800031a8:	8082                	ret
        mycpu()->intr_enable = old;
    800031aa:	ffffe097          	auipc	ra,0xffffe
    800031ae:	c74080e7          	jalr	-908(ra) # 80000e1e <mycpu>
// are device interrupts enabled?
static inline int
intr_get()
{
  uint64 x = r_sstatus();
  return (x & SSTATUS_SIE) != 0;
    800031b2:	8085                	srli	s1,s1,0x1
    800031b4:	8885                	andi	s1,s1,1
    800031b6:	dd64                	sw	s1,124(a0)
    800031b8:	bfe9                	j	80003192 <push_off+0x24>

00000000800031ba <spin_lock>:
void spin_lock(struct spinlock *lk) {
    800031ba:	1101                	addi	sp,sp,-32
    800031bc:	ec06                	sd	ra,24(sp)
    800031be:	e822                	sd	s0,16(sp)
    800031c0:	e426                	sd	s1,8(sp)
    800031c2:	1000                	addi	s0,sp,32
    800031c4:	84aa                	mv	s1,a0
    push_off(); // 禁用中断以避免死锁。
    800031c6:	00000097          	auipc	ra,0x0
    800031ca:	fa8080e7          	jalr	-88(ra) # 8000316e <push_off>
    if (spin_holding(lk)){
    800031ce:	8526                	mv	a0,s1
    800031d0:	00000097          	auipc	ra,0x0
    800031d4:	f70080e7          	jalr	-144(ra) # 80003140 <spin_holding>
    800031d8:	e11d                	bnez	a0,800031fe <spin_lock+0x44>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0);
    800031da:	4705                	li	a4,1
    800031dc:	87ba                	mv	a5,a4
    800031de:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800031e2:	2781                	sext.w	a5,a5
    800031e4:	ffe5                	bnez	a5,800031dc <spin_lock+0x22>
    __sync_synchronize();
    800031e6:	0ff0000f          	fence
    lk->cpu = mycpu();
    800031ea:	ffffe097          	auipc	ra,0xffffe
    800031ee:	c34080e7          	jalr	-972(ra) # 80000e1e <mycpu>
    800031f2:	e488                	sd	a0,8(s1)
}
    800031f4:	60e2                	ld	ra,24(sp)
    800031f6:	6442                	ld	s0,16(sp)
    800031f8:	64a2                	ld	s1,8(sp)
    800031fa:	6105                	addi	sp,sp,32
    800031fc:	8082                	ret
        printf("lock=%s",lk->name);
    800031fe:	688c                	ld	a1,16(s1)
    80003200:	00001517          	auipc	a0,0x1
    80003204:	51050513          	addi	a0,a0,1296 # 80004710 <digits+0x6c0>
    80003208:	ffffd097          	auipc	ra,0xffffd
    8000320c:	2ca080e7          	jalr	714(ra) # 800004d2 <printf>
        panic("re-acquire");
    80003210:	00001517          	auipc	a0,0x1
    80003214:	50850513          	addi	a0,a0,1288 # 80004718 <digits+0x6c8>
    80003218:	ffffd097          	auipc	ra,0xffffd
    8000321c:	558080e7          	jalr	1368(ra) # 80000770 <panic>
    80003220:	bf6d                	j	800031da <spin_lock+0x20>

0000000080003222 <pop_off>:

void pop_off(void) {
    80003222:	1101                	addi	sp,sp,-32
    80003224:	ec06                	sd	ra,24(sp)
    80003226:	e822                	sd	s0,16(sp)
    80003228:	e426                	sd	s1,8(sp)
    8000322a:	1000                	addi	s0,sp,32
    struct cpu *c = mycpu();
    8000322c:	ffffe097          	auipc	ra,0xffffe
    80003230:	bf2080e7          	jalr	-1038(ra) # 80000e1e <mycpu>
    80003234:	84aa                	mv	s1,a0
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003236:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000323a:	8b89                	andi	a5,a5,2
    if (intr_get())
    8000323c:	e79d                	bnez	a5,8000326a <pop_off+0x48>
        panic("pop_off - interruptible");
    if (c->noff < 1)
    8000323e:	5cbc                	lw	a5,120(s1)
    80003240:	02f05e63          	blez	a5,8000327c <pop_off+0x5a>
        panic("pop_off");
    c->noff -= 1;
    80003244:	5cbc                	lw	a5,120(s1)
    80003246:	37fd                	addiw	a5,a5,-1
    80003248:	0007871b          	sext.w	a4,a5
    8000324c:	dcbc                	sw	a5,120(s1)
    if (c->noff == 0 && c->intr_enable)
    8000324e:	eb09                	bnez	a4,80003260 <pop_off+0x3e>
    80003250:	5cfc                	lw	a5,124(s1)
    80003252:	c799                	beqz	a5,80003260 <pop_off+0x3e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003254:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80003258:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000325c:	10079073          	csrw	sstatus,a5
        intr_on();
}
    80003260:	60e2                	ld	ra,24(sp)
    80003262:	6442                	ld	s0,16(sp)
    80003264:	64a2                	ld	s1,8(sp)
    80003266:	6105                	addi	sp,sp,32
    80003268:	8082                	ret
        panic("pop_off - interruptible");
    8000326a:	00001517          	auipc	a0,0x1
    8000326e:	4be50513          	addi	a0,a0,1214 # 80004728 <digits+0x6d8>
    80003272:	ffffd097          	auipc	ra,0xffffd
    80003276:	4fe080e7          	jalr	1278(ra) # 80000770 <panic>
    8000327a:	b7d1                	j	8000323e <pop_off+0x1c>
        panic("pop_off");
    8000327c:	00001517          	auipc	a0,0x1
    80003280:	4c450513          	addi	a0,a0,1220 # 80004740 <digits+0x6f0>
    80003284:	ffffd097          	auipc	ra,0xffffd
    80003288:	4ec080e7          	jalr	1260(ra) # 80000770 <panic>
    8000328c:	bf65                	j	80003244 <pop_off+0x22>

000000008000328e <spin_unlock>:
void spin_unlock(struct spinlock *lk) {
    8000328e:	1101                	addi	sp,sp,-32
    80003290:	ec06                	sd	ra,24(sp)
    80003292:	e822                	sd	s0,16(sp)
    80003294:	e426                	sd	s1,8(sp)
    80003296:	1000                	addi	s0,sp,32
    80003298:	84aa                	mv	s1,a0
    if (!spin_holding(lk)){
    8000329a:	00000097          	auipc	ra,0x0
    8000329e:	ea6080e7          	jalr	-346(ra) # 80003140 <spin_holding>
    800032a2:	c115                	beqz	a0,800032c6 <spin_unlock+0x38>
    lk->cpu = 0;
    800032a4:	0004b423          	sd	zero,8(s1)
    __sync_synchronize();
    800032a8:	0ff0000f          	fence
    __sync_lock_release(&lk->locked);
    800032ac:	0f50000f          	fence	iorw,ow
    800032b0:	0804a02f          	amoswap.w	zero,zero,(s1)
    pop_off();
    800032b4:	00000097          	auipc	ra,0x0
    800032b8:	f6e080e7          	jalr	-146(ra) # 80003222 <pop_off>
}
    800032bc:	60e2                	ld	ra,24(sp)
    800032be:	6442                	ld	s0,16(sp)
    800032c0:	64a2                	ld	s1,8(sp)
    800032c2:	6105                	addi	sp,sp,32
    800032c4:	8082                	ret
        printf("%s\n", lk->name);
    800032c6:	688c                	ld	a1,16(s1)
    800032c8:	00001517          	auipc	a0,0x1
    800032cc:	d5850513          	addi	a0,a0,-680 # 80004020 <sleep_holding+0xc62>
    800032d0:	ffffd097          	auipc	ra,0xffffd
    800032d4:	202080e7          	jalr	514(ra) # 800004d2 <printf>
        panic("release");
    800032d8:	00001517          	auipc	a0,0x1
    800032dc:	47050513          	addi	a0,a0,1136 # 80004748 <digits+0x6f8>
    800032e0:	ffffd097          	auipc	ra,0xffffd
    800032e4:	490080e7          	jalr	1168(ra) # 80000770 <panic>
    800032e8:	bf75                	j	800032a4 <spin_unlock+0x16>

00000000800032ea <sleeplock_init>:
#include "../process.h"
#include "../riscv.h"
#include "../defs.h"

void sleeplock_init(struct sleeplock* lk, char* name)
{
    800032ea:	1101                	addi	sp,sp,-32
    800032ec:	ec06                	sd	ra,24(sp)
    800032ee:	e822                	sd	s0,16(sp)
    800032f0:	e426                	sd	s1,8(sp)
    800032f2:	e04a                	sd	s2,0(sp)
    800032f4:	1000                	addi	s0,sp,32
    800032f6:	84aa                	mv	s1,a0
    800032f8:	892e                	mv	s2,a1
  spinlock_init(&lk->lk, "sleep lock");
    800032fa:	00001597          	auipc	a1,0x1
    800032fe:	45658593          	addi	a1,a1,1110 # 80004750 <digits+0x700>
    80003302:	0521                	addi	a0,a0,8
    80003304:	00000097          	auipc	ra,0x0
    80003308:	e26080e7          	jalr	-474(ra) # 8000312a <spinlock_init>
  lk->name = name;
    8000330c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003310:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003314:	0204a423          	sw	zero,40(s1)
}
    80003318:	60e2                	ld	ra,24(sp)
    8000331a:	6442                	ld	s0,16(sp)
    8000331c:	64a2                	ld	s1,8(sp)
    8000331e:	6902                	ld	s2,0(sp)
    80003320:	6105                	addi	sp,sp,32
    80003322:	8082                	ret

0000000080003324 <sleep_lock>:

void sleep_lock(struct sleeplock* lk)
{
    80003324:	1101                	addi	sp,sp,-32
    80003326:	ec06                	sd	ra,24(sp)
    80003328:	e822                	sd	s0,16(sp)
    8000332a:	e426                	sd	s1,8(sp)
    8000332c:	e04a                	sd	s2,0(sp)
    8000332e:	1000                	addi	s0,sp,32
    80003330:	84aa                	mv	s1,a0
  spin_lock(&lk->lk);
    80003332:	00850913          	addi	s2,a0,8
    80003336:	854a                	mv	a0,s2
    80003338:	00000097          	auipc	ra,0x0
    8000333c:	e82080e7          	jalr	-382(ra) # 800031ba <spin_lock>
  while (lk->locked) {
    80003340:	409c                	lw	a5,0(s1)
    80003342:	cb89                	beqz	a5,80003354 <sleep_lock+0x30>
    sleep(lk, &lk->lk);
    80003344:	85ca                	mv	a1,s2
    80003346:	8526                	mv	a0,s1
    80003348:	ffffe097          	auipc	ra,0xffffe
    8000334c:	bf6080e7          	jalr	-1034(ra) # 80000f3e <sleep>
  while (lk->locked) {
    80003350:	409c                	lw	a5,0(s1)
    80003352:	fbed                	bnez	a5,80003344 <sleep_lock+0x20>
  }
  lk->locked = 1;
    80003354:	4785                	li	a5,1
    80003356:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003358:	ffffe097          	auipc	ra,0xffffe
    8000335c:	ae2080e7          	jalr	-1310(ra) # 80000e3a <myproc>
    80003360:	511c                	lw	a5,32(a0)
    80003362:	d49c                	sw	a5,40(s1)
  spin_unlock(&lk->lk);
    80003364:	854a                	mv	a0,s2
    80003366:	00000097          	auipc	ra,0x0
    8000336a:	f28080e7          	jalr	-216(ra) # 8000328e <spin_unlock>
}
    8000336e:	60e2                	ld	ra,24(sp)
    80003370:	6442                	ld	s0,16(sp)
    80003372:	64a2                	ld	s1,8(sp)
    80003374:	6902                	ld	s2,0(sp)
    80003376:	6105                	addi	sp,sp,32
    80003378:	8082                	ret

000000008000337a <sleep_unlock>:

void sleep_unlock(struct sleeplock* lk)
{
    8000337a:	1101                	addi	sp,sp,-32
    8000337c:	ec06                	sd	ra,24(sp)
    8000337e:	e822                	sd	s0,16(sp)
    80003380:	e426                	sd	s1,8(sp)
    80003382:	e04a                	sd	s2,0(sp)
    80003384:	1000                	addi	s0,sp,32
    80003386:	84aa                	mv	s1,a0
  spin_lock(&lk->lk);
    80003388:	00850913          	addi	s2,a0,8
    8000338c:	854a                	mv	a0,s2
    8000338e:	00000097          	auipc	ra,0x0
    80003392:	e2c080e7          	jalr	-468(ra) # 800031ba <spin_lock>
  lk->locked = 0;
    80003396:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000339a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000339e:	8526                	mv	a0,s1
    800033a0:	ffffe097          	auipc	ra,0xffffe
    800033a4:	caa080e7          	jalr	-854(ra) # 8000104a <wakeup>
  spin_unlock(&lk->lk);
    800033a8:	854a                	mv	a0,s2
    800033aa:	00000097          	auipc	ra,0x0
    800033ae:	ee4080e7          	jalr	-284(ra) # 8000328e <spin_unlock>
}
    800033b2:	60e2                	ld	ra,24(sp)
    800033b4:	6442                	ld	s0,16(sp)
    800033b6:	64a2                	ld	s1,8(sp)
    800033b8:	6902                	ld	s2,0(sp)
    800033ba:	6105                	addi	sp,sp,32
    800033bc:	8082                	ret

00000000800033be <sleep_holding>:

int sleep_holding(struct sleeplock* lk)
{
    800033be:	7179                	addi	sp,sp,-48
    800033c0:	f406                	sd	ra,40(sp)
    800033c2:	f022                	sd	s0,32(sp)
    800033c4:	ec26                	sd	s1,24(sp)
    800033c6:	e84a                	sd	s2,16(sp)
    800033c8:	e44e                	sd	s3,8(sp)
    800033ca:	1800                	addi	s0,sp,48
    800033cc:	84aa                	mv	s1,a0
  int r;
  spin_lock(&lk->lk);
    800033ce:	00850913          	addi	s2,a0,8
    800033d2:	854a                	mv	a0,s2
    800033d4:	00000097          	auipc	ra,0x0
    800033d8:	de6080e7          	jalr	-538(ra) # 800031ba <spin_lock>
  r = lk->locked && (lk->pid == myproc()->pid);
    800033dc:	409c                	lw	a5,0(s1)
    800033de:	ef99                	bnez	a5,800033fc <sleep_holding+0x3e>
    800033e0:	4481                	li	s1,0
  spin_unlock(&lk->lk);
    800033e2:	854a                	mv	a0,s2
    800033e4:	00000097          	auipc	ra,0x0
    800033e8:	eaa080e7          	jalr	-342(ra) # 8000328e <spin_unlock>
  return r;
}
    800033ec:	8526                	mv	a0,s1
    800033ee:	70a2                	ld	ra,40(sp)
    800033f0:	7402                	ld	s0,32(sp)
    800033f2:	64e2                	ld	s1,24(sp)
    800033f4:	6942                	ld	s2,16(sp)
    800033f6:	69a2                	ld	s3,8(sp)
    800033f8:	6145                	addi	sp,sp,48
    800033fa:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800033fc:	0284a983          	lw	s3,40(s1)
    80003400:	ffffe097          	auipc	ra,0xffffe
    80003404:	a3a080e7          	jalr	-1478(ra) # 80000e3a <myproc>
    80003408:	5104                	lw	s1,32(a0)
    8000340a:	413484b3          	sub	s1,s1,s3
    8000340e:	0014b493          	seqz	s1,s1
    80003412:	bfc1                	j	800033e2 <sleep_holding+0x24>
	...
