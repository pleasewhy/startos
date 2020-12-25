
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
    80000060:	a1478793          	addi	a5,a5,-1516 # 80000a70 <timervec>
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
    80000094:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <disk+0xffffffff7ffb57ff>
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
#include "riscv.h"
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
    800000f8:	078080e7          	jalr	120(ra) # 8000016c <uart_init>
    printf("\n");
    800000fc:	00003517          	auipc	a0,0x3
    80000100:	47c50513          	addi	a0,a0,1148 # 80003578 <digits+0x540>
    80000104:	00000097          	auipc	ra,0x0
    80000108:	3be080e7          	jalr	958(ra) # 800004c2 <printf>
    printf("xv6 kernel is booting\n");
    8000010c:	00003517          	auipc	a0,0x3
    80000110:	ef450513          	addi	a0,a0,-268 # 80003000 <virtio_disk_intr+0x107e>
    80000114:	00000097          	auipc	ra,0x0
    80000118:	3ae080e7          	jalr	942(ra) # 800004c2 <printf>
    printf("\n");
    8000011c:	00003517          	auipc	a0,0x3
    80000120:	45c50513          	addi	a0,a0,1116 # 80003578 <digits+0x540>
    80000124:	00000097          	auipc	ra,0x0
    80000128:	39e080e7          	jalr	926(ra) # 800004c2 <printf>
    trapinit();             // 初始化trap
    8000012c:	00000097          	auipc	ra,0x0
    80000130:	5d8080e7          	jalr	1496(ra) # 80000704 <trapinit>
    plicinit();             // 初始化plic
    80000134:	00000097          	auipc	ra,0x0
    80000138:	77c080e7          	jalr	1916(ra) # 800008b0 <plicinit>
    plicinithart();         
    8000013c:	00000097          	auipc	ra,0x0
    80000140:	78a080e7          	jalr	1930(ra) # 800008c6 <plicinithart>
    init_process_table();   // 初始化进程表
    80000144:	00001097          	auipc	ra,0x1
    80000148:	b0e080e7          	jalr	-1266(ra) # 80000c52 <init_process_table>
    init_first_process();   // 初始化第一个进程
    8000014c:	00001097          	auipc	ra,0x1
    80000150:	ba4080e7          	jalr	-1116(ra) # 80000cf0 <init_first_process>
    virtio_disk_init();
    80000154:	00002097          	auipc	ra,0x2
    80000158:	a5a080e7          	jalr	-1446(ra) # 80001bae <virtio_disk_init>
    scheduler();
    8000015c:	00001097          	auipc	ra,0x1
    80000160:	ce8080e7          	jalr	-792(ra) # 80000e44 <scheduler>
    80000164:	60a2                	ld	ra,8(sp)
    80000166:	6402                	ld	s0,0(sp)
    80000168:	0141                	addi	sp,sp,16
    8000016a:	8082                	ret

000000008000016c <uart_init>:
#define FCR_FIFO_CLEAR (3 << 1)  // 清除两个FIFO的内容
#define IER_RX_ENABLE (1 << 0)   // 读中断允许
#define IER_TX_ENABLE (1 << 1)   // 传输中断允许

void uart_init()
{
    8000016c:	1141                	addi	sp,sp,-16
    8000016e:	e422                	sd	s0,8(sp)
    80000170:	0800                	addi	s0,sp,16
  // 禁用中断
  WriteReg(IER, 0x0);
    80000172:	100007b7          	lui	a5,0x10000
    80000176:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // 配置波特率模式
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000017a:	f8000713          	li	a4,-128
    8000017e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000182:	470d                	li	a4,3
    80000184:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000188:	000780a3          	sb	zero,1(a5)

  // 退出 设置波特率模式
  // 设置字宽为8位，不校验
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000018c:	46a1                	li	a3,8
    8000018e:	00d781a3          	sb	a3,3(a5)

  // 重置和允许FIFO
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000192:	469d                	li	a3,7
    80000194:	00d78123          	sb	a3,2(a5)

  // 允许传输和接受中断
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80000198:	00e780a3          	sb	a4,1(a5)

  // initlock(&uart_tx_lock, "uart");
}
    8000019c:	6422                	ld	s0,8(sp)
    8000019e:	0141                	addi	sp,sp,16
    800001a0:	8082                	ret

00000000800001a2 <uartputc_sync>:

void uartputc_sync(int c)
{
    800001a2:	1141                	addi	sp,sp,-16
    800001a4:	e422                	sd	s0,8(sp)
    800001a6:	0800                	addi	s0,sp,16
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800001a8:	10000737          	lui	a4,0x10000
    800001ac:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800001b0:	0ff7f793          	andi	a5,a5,255
    800001b4:	0207f793          	andi	a5,a5,32
    800001b8:	dbf5                	beqz	a5,800001ac <uartputc_sync+0xa>
    ;
  WriteReg(THR, c);
    800001ba:	0ff57513          	andi	a0,a0,255
    800001be:	100007b7          	lui	a5,0x10000
    800001c2:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>
}
    800001c6:	6422                	ld	s0,8(sp)
    800001c8:	0141                	addi	sp,sp,16
    800001ca:	8082                	ret

00000000800001cc <uartgetc>:

int uartgetc(void)
{
    800001cc:	1141                	addi	sp,sp,-16
    800001ce:	e422                	sd	s0,8(sp)
    800001d0:	0800                	addi	s0,sp,16
  //
  if (ReadReg(LSR) & 0x01)
    800001d2:	100007b7          	lui	a5,0x10000
    800001d6:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800001da:	8b85                	andi	a5,a5,1
    800001dc:	cb91                	beqz	a5,800001f0 <uartgetc+0x24>
  {
    return ReadReg(RHR);
    800001de:	100007b7          	lui	a5,0x10000
    800001e2:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800001e6:	0ff57513          	andi	a0,a0,255
  }
  else
  {
    return -1;
  }
}
    800001ea:	6422                	ld	s0,8(sp)
    800001ec:	0141                	addi	sp,sp,16
    800001ee:	8082                	ret
    return -1;
    800001f0:	557d                	li	a0,-1
    800001f2:	bfe5                	j	800001ea <uartgetc+0x1e>

00000000800001f4 <uart_intr>:

void uart_intr()
{
    800001f4:	1101                	addi	sp,sp,-32
    800001f6:	ec06                	sd	ra,24(sp)
    800001f8:	e822                	sd	s0,16(sp)
    800001fa:	e426                	sd	s1,8(sp)
    800001fc:	1000                	addi	s0,sp,32
  while (1)
  {
    int c = uartgetc();
    if (c == -1)
    800001fe:	54fd                	li	s1,-1
    int c = uartgetc();
    80000200:	00000097          	auipc	ra,0x0
    80000204:	fcc080e7          	jalr	-52(ra) # 800001cc <uartgetc>
    if (c == -1)
    80000208:	00950963          	beq	a0,s1,8000021a <uart_intr+0x26>
      break;
    console_intr(c);
    8000020c:	0ff57513          	andi	a0,a0,255
    80000210:	00000097          	auipc	ra,0x0
    80000214:	3e4080e7          	jalr	996(ra) # 800005f4 <console_intr>
  {
    80000218:	b7e5                	j	80000200 <uart_intr+0xc>
  }
    8000021a:	60e2                	ld	ra,24(sp)
    8000021c:	6442                	ld	s0,16(sp)
    8000021e:	64a2                	ld	s1,8(sp)
    80000220:	6105                	addi	sp,sp,32
    80000222:	8082                	ret

0000000080000224 <printint>:

static char digits[] = "0123456789ABCDEF";

static void
printint(int fd, int xx, int base, int sgn)
{
    80000224:	7179                	addi	sp,sp,-48
    80000226:	f406                	sd	ra,40(sp)
    80000228:	f022                	sd	s0,32(sp)
    8000022a:	ec26                	sd	s1,24(sp)
    8000022c:	e84a                	sd	s2,16(sp)
    8000022e:	1800                	addi	s0,sp,48
    char buf[16];
    int i, neg;
    uint x;

    neg = 0;
    if (sgn && xx < 0) {
    80000230:	c299                	beqz	a3,80000236 <printint+0x12>
    80000232:	0805c663          	bltz	a1,800002be <printint+0x9a>
        neg = 1;
        x = -xx;
    } else {
        x = xx;
    80000236:	2581                	sext.w	a1,a1
    neg = 0;
    80000238:	4881                	li	a7,0
    8000023a:	fd040693          	addi	a3,s0,-48
    }

    i = 0;
    8000023e:	4701                	li	a4,0
    do {
        buf[i++] = digits[x % base];
    80000240:	2601                	sext.w	a2,a2
    80000242:	00003517          	auipc	a0,0x3
    80000246:	df650513          	addi	a0,a0,-522 # 80003038 <digits>
    8000024a:	883a                	mv	a6,a4
    8000024c:	2705                	addiw	a4,a4,1
    8000024e:	02c5f7bb          	remuw	a5,a1,a2
    80000252:	1782                	slli	a5,a5,0x20
    80000254:	9381                	srli	a5,a5,0x20
    80000256:	97aa                	add	a5,a5,a0
    80000258:	0007c783          	lbu	a5,0(a5)
    8000025c:	00f68023          	sb	a5,0(a3)
    } while ((x /= base) != 0);
    80000260:	0005879b          	sext.w	a5,a1
    80000264:	02c5d5bb          	divuw	a1,a1,a2
    80000268:	0685                	addi	a3,a3,1
    8000026a:	fec7f0e3          	bgeu	a5,a2,8000024a <printint+0x26>
    if (neg)
    8000026e:	00088b63          	beqz	a7,80000284 <printint+0x60>
        buf[i++] = '-';
    80000272:	fe040793          	addi	a5,s0,-32
    80000276:	973e                	add	a4,a4,a5
    80000278:	02d00793          	li	a5,45
    8000027c:	fef70823          	sb	a5,-16(a4)
    80000280:	0028071b          	addiw	a4,a6,2

    while (--i >= 0)
    80000284:	02e05763          	blez	a4,800002b2 <printint+0x8e>
    80000288:	fd040793          	addi	a5,s0,-48
    8000028c:	00e784b3          	add	s1,a5,a4
    80000290:	fff78913          	addi	s2,a5,-1
    80000294:	993a                	add	s2,s2,a4
    80000296:	377d                	addiw	a4,a4,-1
    80000298:	1702                	slli	a4,a4,0x20
    8000029a:	9301                	srli	a4,a4,0x20
    8000029c:	40e90933          	sub	s2,s2,a4
    int write_index;
} consloe_buf;

void putc(int fd, char ch)
{
    uartputc_sync(ch);
    800002a0:	fff4c503          	lbu	a0,-1(s1)
    800002a4:	00000097          	auipc	ra,0x0
    800002a8:	efe080e7          	jalr	-258(ra) # 800001a2 <uartputc_sync>
    800002ac:	14fd                	addi	s1,s1,-1
    800002ae:	ff2499e3          	bne	s1,s2,800002a0 <printint+0x7c>
        putc(fd, buf[i]);
}
    800002b2:	70a2                	ld	ra,40(sp)
    800002b4:	7402                	ld	s0,32(sp)
    800002b6:	64e2                	ld	s1,24(sp)
    800002b8:	6942                	ld	s2,16(sp)
    800002ba:	6145                	addi	sp,sp,48
    800002bc:	8082                	ret
        x = -xx;
    800002be:	40b005bb          	negw	a1,a1
        neg = 1;
    800002c2:	4885                	li	a7,1
        x = -xx;
    800002c4:	bf9d                	j	8000023a <printint+0x16>

00000000800002c6 <vprintf>:
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char* fmt, va_list ap)
{
    800002c6:	7119                	addi	sp,sp,-128
    800002c8:	fc86                	sd	ra,120(sp)
    800002ca:	f8a2                	sd	s0,112(sp)
    800002cc:	f4a6                	sd	s1,104(sp)
    800002ce:	f0ca                	sd	s2,96(sp)
    800002d0:	ecce                	sd	s3,88(sp)
    800002d2:	e8d2                	sd	s4,80(sp)
    800002d4:	e4d6                	sd	s5,72(sp)
    800002d6:	e0da                	sd	s6,64(sp)
    800002d8:	fc5e                	sd	s7,56(sp)
    800002da:	f862                	sd	s8,48(sp)
    800002dc:	f466                	sd	s9,40(sp)
    800002de:	f06a                	sd	s10,32(sp)
    800002e0:	ec6e                	sd	s11,24(sp)
    800002e2:	0100                	addi	s0,sp,128
    800002e4:	f8a43423          	sd	a0,-120(s0)
    char* s;
    int c, i, state;

    state = 0;
    for (i = 0; fmt[i]; i++) {
    800002e8:	0005c483          	lbu	s1,0(a1)
    800002ec:	18048563          	beqz	s1,80000476 <vprintf+0x1b0>
    800002f0:	8ab2                	mv	s5,a2
    800002f2:	00158913          	addi	s2,a1,1
    state = 0;
    800002f6:	4981                	li	s3,0
            if (c == '%') {
                state = '%';
            } else {
                putc(fd, c);
            }
        } else if (state == '%') {
    800002f8:	02500a13          	li	s4,37
            if (c == 'd') {
    800002fc:	06400b93          	li	s7,100
                printint(fd, va_arg(ap, int), 10, 1);
            } else if (c == 'l') {
    80000300:	06c00c13          	li	s8,108
                printint(fd, va_arg(ap, uint64), 10, 0);
            } else if (c == 'x') {
    80000304:	07800c93          	li	s9,120
                printint(fd, va_arg(ap, int), 16, 0);
            } else if (c == 'p') {
    80000308:	07000d13          	li	s10,112
                printptr(fd, va_arg(ap, uint64));
            } else if (c == 's') {
    8000030c:	07300d93          	li	s11,115
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000310:	00003b17          	auipc	s6,0x3
    80000314:	d28b0b13          	addi	s6,s6,-728 # 80003038 <digits>
    80000318:	a831                	j	80000334 <vprintf+0x6e>
    8000031a:	8526                	mv	a0,s1
    8000031c:	00000097          	auipc	ra,0x0
    80000320:	e86080e7          	jalr	-378(ra) # 800001a2 <uartputc_sync>
}
    80000324:	a019                	j	8000032a <vprintf+0x64>
        } else if (state == '%') {
    80000326:	01498e63          	beq	s3,s4,80000342 <vprintf+0x7c>
    for (i = 0; fmt[i]; i++) {
    8000032a:	0905                	addi	s2,s2,1
    8000032c:	fff94483          	lbu	s1,-1(s2)
    80000330:	14048363          	beqz	s1,80000476 <vprintf+0x1b0>
        c = fmt[i] & 0xff;
    80000334:	2481                	sext.w	s1,s1
        if (state == 0) {
    80000336:	fe0998e3          	bnez	s3,80000326 <vprintf+0x60>
            if (c == '%') {
    8000033a:	ff4490e3          	bne	s1,s4,8000031a <vprintf+0x54>
                state = '%';
    8000033e:	89a6                	mv	s3,s1
    80000340:	b7ed                	j	8000032a <vprintf+0x64>
            if (c == 'd') {
    80000342:	03748c63          	beq	s1,s7,8000037a <vprintf+0xb4>
            } else if (c == 'l') {
    80000346:	05848963          	beq	s1,s8,80000398 <vprintf+0xd2>
            } else if (c == 'x') {
    8000034a:	07948663          	beq	s1,s9,800003b6 <vprintf+0xf0>
            } else if (c == 'p') {
    8000034e:	09a48363          	beq	s1,s10,800003d4 <vprintf+0x10e>
            } else if (c == 's') {
    80000352:	0db48363          	beq	s1,s11,80000418 <vprintf+0x152>
                    s = "(null)";
                while (*s != 0) {
                    putc(fd, *s);
                    s++;
                }
            } else if (c == 'c') {
    80000356:	06300793          	li	a5,99
    8000035a:	0ef48963          	beq	s1,a5,8000044c <vprintf+0x186>
                putc(fd, va_arg(ap, uint));
            } else if (c == '%') {
    8000035e:	11448263          	beq	s1,s4,80000462 <vprintf+0x19c>
    uartputc_sync(ch);
    80000362:	8552                	mv	a0,s4
    80000364:	00000097          	auipc	ra,0x0
    80000368:	e3e080e7          	jalr	-450(ra) # 800001a2 <uartputc_sync>
    8000036c:	8526                	mv	a0,s1
    8000036e:	00000097          	auipc	ra,0x0
    80000372:	e34080e7          	jalr	-460(ra) # 800001a2 <uartputc_sync>
            } else {
                // Unknown % sequence.  Print it to draw attention.
                putc(fd, '%');
                putc(fd, c);
            }
            state = 0;
    80000376:	4981                	li	s3,0
}
    80000378:	bf4d                	j	8000032a <vprintf+0x64>
                printint(fd, va_arg(ap, int), 10, 1);
    8000037a:	008a8493          	addi	s1,s5,8
    8000037e:	4685                	li	a3,1
    80000380:	4629                	li	a2,10
    80000382:	000aa583          	lw	a1,0(s5)
    80000386:	f8843503          	ld	a0,-120(s0)
    8000038a:	00000097          	auipc	ra,0x0
    8000038e:	e9a080e7          	jalr	-358(ra) # 80000224 <printint>
    80000392:	8aa6                	mv	s5,s1
            state = 0;
    80000394:	4981                	li	s3,0
    80000396:	bf51                	j	8000032a <vprintf+0x64>
                printint(fd, va_arg(ap, uint64), 10, 0);
    80000398:	008a8493          	addi	s1,s5,8
    8000039c:	4681                	li	a3,0
    8000039e:	4629                	li	a2,10
    800003a0:	000aa583          	lw	a1,0(s5)
    800003a4:	f8843503          	ld	a0,-120(s0)
    800003a8:	00000097          	auipc	ra,0x0
    800003ac:	e7c080e7          	jalr	-388(ra) # 80000224 <printint>
    800003b0:	8aa6                	mv	s5,s1
            state = 0;
    800003b2:	4981                	li	s3,0
    800003b4:	bf9d                	j	8000032a <vprintf+0x64>
                printint(fd, va_arg(ap, int), 16, 0);
    800003b6:	008a8493          	addi	s1,s5,8
    800003ba:	4681                	li	a3,0
    800003bc:	4641                	li	a2,16
    800003be:	000aa583          	lw	a1,0(s5)
    800003c2:	f8843503          	ld	a0,-120(s0)
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	e5e080e7          	jalr	-418(ra) # 80000224 <printint>
    800003ce:	8aa6                	mv	s5,s1
            state = 0;
    800003d0:	4981                	li	s3,0
    800003d2:	bfa1                	j	8000032a <vprintf+0x64>
                printptr(fd, va_arg(ap, uint64));
    800003d4:	008a8793          	addi	a5,s5,8
    800003d8:	f8f43023          	sd	a5,-128(s0)
    800003dc:	000ab983          	ld	s3,0(s5)
    uartputc_sync(ch);
    800003e0:	03000513          	li	a0,48
    800003e4:	00000097          	auipc	ra,0x0
    800003e8:	dbe080e7          	jalr	-578(ra) # 800001a2 <uartputc_sync>
    800003ec:	8566                	mv	a0,s9
    800003ee:	00000097          	auipc	ra,0x0
    800003f2:	db4080e7          	jalr	-588(ra) # 800001a2 <uartputc_sync>
    800003f6:	44c1                	li	s1,16
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    800003f8:	03c9d793          	srli	a5,s3,0x3c
    800003fc:	97da                	add	a5,a5,s6
    800003fe:	0007c503          	lbu	a0,0(a5)
    80000402:	00000097          	auipc	ra,0x0
    80000406:	da0080e7          	jalr	-608(ra) # 800001a2 <uartputc_sync>
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000040a:	0992                	slli	s3,s3,0x4
    8000040c:	34fd                	addiw	s1,s1,-1
    8000040e:	f4ed                	bnez	s1,800003f8 <vprintf+0x132>
                printptr(fd, va_arg(ap, uint64));
    80000410:	f8043a83          	ld	s5,-128(s0)
            state = 0;
    80000414:	4981                	li	s3,0
    80000416:	bf11                	j	8000032a <vprintf+0x64>
                s = va_arg(ap, char*);
    80000418:	008a8993          	addi	s3,s5,8
    8000041c:	000ab483          	ld	s1,0(s5)
                if (s == 0)
    80000420:	cc99                	beqz	s1,8000043e <vprintf+0x178>
                while (*s != 0) {
    80000422:	0004c503          	lbu	a0,0(s1)
    80000426:	c529                	beqz	a0,80000470 <vprintf+0x1aa>
    80000428:	00000097          	auipc	ra,0x0
    8000042c:	d7a080e7          	jalr	-646(ra) # 800001a2 <uartputc_sync>
                    s++;
    80000430:	0485                	addi	s1,s1,1
                while (*s != 0) {
    80000432:	0004c503          	lbu	a0,0(s1)
    80000436:	f96d                	bnez	a0,80000428 <vprintf+0x162>
                s = va_arg(ap, char*);
    80000438:	8ace                	mv	s5,s3
            state = 0;
    8000043a:	4981                	li	s3,0
    8000043c:	b5fd                	j	8000032a <vprintf+0x64>
                    s = "(null)";
    8000043e:	00003497          	auipc	s1,0x3
    80000442:	bda48493          	addi	s1,s1,-1062 # 80003018 <virtio_disk_intr+0x1096>
                while (*s != 0) {
    80000446:	02800513          	li	a0,40
    8000044a:	bff9                	j	80000428 <vprintf+0x162>
                putc(fd, va_arg(ap, uint));
    8000044c:	008a8493          	addi	s1,s5,8
    80000450:	000ac503          	lbu	a0,0(s5)
    80000454:	00000097          	auipc	ra,0x0
    80000458:	d4e080e7          	jalr	-690(ra) # 800001a2 <uartputc_sync>
    8000045c:	8aa6                	mv	s5,s1
            state = 0;
    8000045e:	4981                	li	s3,0
}
    80000460:	b5e9                	j	8000032a <vprintf+0x64>
    uartputc_sync(ch);
    80000462:	8552                	mv	a0,s4
    80000464:	00000097          	auipc	ra,0x0
    80000468:	d3e080e7          	jalr	-706(ra) # 800001a2 <uartputc_sync>
    8000046c:	4981                	li	s3,0
}
    8000046e:	bd75                	j	8000032a <vprintf+0x64>
                s = va_arg(ap, char*);
    80000470:	8ace                	mv	s5,s3
            state = 0;
    80000472:	4981                	li	s3,0
    80000474:	bd5d                	j	8000032a <vprintf+0x64>
        }
    }
}
    80000476:	70e6                	ld	ra,120(sp)
    80000478:	7446                	ld	s0,112(sp)
    8000047a:	74a6                	ld	s1,104(sp)
    8000047c:	7906                	ld	s2,96(sp)
    8000047e:	69e6                	ld	s3,88(sp)
    80000480:	6a46                	ld	s4,80(sp)
    80000482:	6aa6                	ld	s5,72(sp)
    80000484:	6b06                	ld	s6,64(sp)
    80000486:	7be2                	ld	s7,56(sp)
    80000488:	7c42                	ld	s8,48(sp)
    8000048a:	7ca2                	ld	s9,40(sp)
    8000048c:	7d02                	ld	s10,32(sp)
    8000048e:	6de2                	ld	s11,24(sp)
    80000490:	6109                	addi	sp,sp,128
    80000492:	8082                	ret

0000000080000494 <fprintf>:

void fprintf(int fd, const char* fmt, ...)
{
    80000494:	715d                	addi	sp,sp,-80
    80000496:	ec06                	sd	ra,24(sp)
    80000498:	e822                	sd	s0,16(sp)
    8000049a:	1000                	addi	s0,sp,32
    8000049c:	e010                	sd	a2,0(s0)
    8000049e:	e414                	sd	a3,8(s0)
    800004a0:	e818                	sd	a4,16(s0)
    800004a2:	ec1c                	sd	a5,24(s0)
    800004a4:	03043023          	sd	a6,32(s0)
    800004a8:	03143423          	sd	a7,40(s0)
    va_list ap;

    va_start(ap, fmt);
    800004ac:	fe843423          	sd	s0,-24(s0)
    vprintf(fd, fmt, ap);
    800004b0:	8622                	mv	a2,s0
    800004b2:	00000097          	auipc	ra,0x0
    800004b6:	e14080e7          	jalr	-492(ra) # 800002c6 <vprintf>
}
    800004ba:	60e2                	ld	ra,24(sp)
    800004bc:	6442                	ld	s0,16(sp)
    800004be:	6161                	addi	sp,sp,80
    800004c0:	8082                	ret

00000000800004c2 <printf>:

void printf(const char* fmt, ...)
{
    800004c2:	711d                	addi	sp,sp,-96
    800004c4:	ec06                	sd	ra,24(sp)
    800004c6:	e822                	sd	s0,16(sp)
    800004c8:	1000                	addi	s0,sp,32
    800004ca:	e40c                	sd	a1,8(s0)
    800004cc:	e810                	sd	a2,16(s0)
    800004ce:	ec14                	sd	a3,24(s0)
    800004d0:	f018                	sd	a4,32(s0)
    800004d2:	f41c                	sd	a5,40(s0)
    800004d4:	03043823          	sd	a6,48(s0)
    800004d8:	03143c23          	sd	a7,56(s0)
    va_list ap;

    va_start(ap, fmt);
    800004dc:	00840613          	addi	a2,s0,8
    800004e0:	fec43423          	sd	a2,-24(s0)
    vprintf(1, fmt, ap);
    800004e4:	85aa                	mv	a1,a0
    800004e6:	4505                	li	a0,1
    800004e8:	00000097          	auipc	ra,0x0
    800004ec:	dde080e7          	jalr	-546(ra) # 800002c6 <vprintf>
}
    800004f0:	60e2                	ld	ra,24(sp)
    800004f2:	6442                	ld	s0,16(sp)
    800004f4:	6125                	addi	sp,sp,96
    800004f6:	8082                	ret

00000000800004f8 <puts>:

void puts(const char* str)
{
    800004f8:	1141                	addi	sp,sp,-16
    800004fa:	e406                	sd	ra,8(sp)
    800004fc:	e022                	sd	s0,0(sp)
    800004fe:	0800                	addi	s0,sp,16
    80000500:	85aa                	mv	a1,a0
    printf("%s\n", str);
    80000502:	00003517          	auipc	a0,0x3
    80000506:	b1e50513          	addi	a0,a0,-1250 # 80003020 <virtio_disk_intr+0x109e>
    8000050a:	00000097          	auipc	ra,0x0
    8000050e:	fb8080e7          	jalr	-72(ra) # 800004c2 <printf>
}
    80000512:	60a2                	ld	ra,8(sp)
    80000514:	6402                	ld	s0,0(sp)
    80000516:	0141                	addi	sp,sp,16
    80000518:	8082                	ret

000000008000051a <putc>:
{
    8000051a:	1141                	addi	sp,sp,-16
    8000051c:	e406                	sd	ra,8(sp)
    8000051e:	e022                	sd	s0,0(sp)
    80000520:	0800                	addi	s0,sp,16
    uartputc_sync(ch);
    80000522:	852e                	mv	a0,a1
    80000524:	00000097          	auipc	ra,0x0
    80000528:	c7e080e7          	jalr	-898(ra) # 800001a2 <uartputc_sync>
}
    8000052c:	60a2                	ld	ra,8(sp)
    8000052e:	6402                	ld	s0,0(sp)
    80000530:	0141                	addi	sp,sp,16
    80000532:	8082                	ret

0000000080000534 <read_line>:

int read_line(char* s)
{
    80000534:	1101                	addi	sp,sp,-32
    80000536:	ec06                	sd	ra,24(sp)
    80000538:	e822                	sd	s0,16(sp)
    8000053a:	e426                	sd	s1,8(sp)
    8000053c:	e04a                	sd	s2,0(sp)
    8000053e:	1000                	addi	s0,sp,32
    80000540:	84aa                	mv	s1,a0
    int cnt = 0;
    sleep(&consloe_buf);
    80000542:	00005917          	auipc	s2,0x5
    80000546:	bde90913          	addi	s2,s2,-1058 # 80005120 <consloe_buf>
    8000054a:	854a                	mv	a0,s2
    8000054c:	00001097          	auipc	ra,0x1
    80000550:	82c080e7          	jalr	-2004(ra) # 80000d78 <sleep>
    for (int i = consloe_buf.read_index; i < consloe_buf.write_index; i++) {
    80000554:	0c892783          	lw	a5,200(s2)
    80000558:	0cc92703          	lw	a4,204(s2)
    8000055c:	04e7d963          	bge	a5,a4,800005ae <read_line+0x7a>
    80000560:	8626                	mv	a2,s1
    int cnt = 0;
    80000562:	4681                	li	a3,0
        s[cnt++] = consloe_buf.buf[i % INPUT_BUF];
    80000564:	85ca                	mv	a1,s2
    80000566:	0c800893          	li	a7,200
        if (consloe_buf.buf[i % INPUT_BUF] == '\n') {
    8000056a:	4829                	li	a6,10
        s[cnt++] = consloe_buf.buf[i % INPUT_BUF];
    8000056c:	8536                	mv	a0,a3
    8000056e:	2685                	addiw	a3,a3,1
    80000570:	0317e73b          	remw	a4,a5,a7
    80000574:	972e                	add	a4,a4,a1
    80000576:	00074703          	lbu	a4,0(a4)
    8000057a:	00e60023          	sb	a4,0(a2)
        if (consloe_buf.buf[i % INPUT_BUF] == '\n') {
    8000057e:	01070a63          	beq	a4,a6,80000592 <read_line+0x5e>
    for (int i = consloe_buf.read_index; i < consloe_buf.write_index; i++) {
    80000582:	2785                	addiw	a5,a5,1
    80000584:	0605                	addi	a2,a2,1
    80000586:	0cc5a703          	lw	a4,204(a1)
    8000058a:	fee7c1e3          	blt	a5,a4,8000056c <read_line+0x38>
            consloe_buf.read_index = i + 1;
            s[cnt - 1] = 0;
            return cnt - 1;
        }
    }
    return -1;
    8000058e:	557d                	li	a0,-1
    80000590:	a809                	j	800005a2 <read_line+0x6e>
            consloe_buf.read_index = i + 1;
    80000592:	2785                	addiw	a5,a5,1
    80000594:	00005717          	auipc	a4,0x5
    80000598:	c4f72a23          	sw	a5,-940(a4) # 800051e8 <consloe_buf+0xc8>
            s[cnt - 1] = 0;
    8000059c:	96a6                	add	a3,a3,s1
    8000059e:	fe068fa3          	sb	zero,-1(a3)
}
    800005a2:	60e2                	ld	ra,24(sp)
    800005a4:	6442                	ld	s0,16(sp)
    800005a6:	64a2                	ld	s1,8(sp)
    800005a8:	6902                	ld	s2,0(sp)
    800005aa:	6105                	addi	sp,sp,32
    800005ac:	8082                	ret
    return -1;
    800005ae:	557d                	li	a0,-1
    800005b0:	bfcd                	j	800005a2 <read_line+0x6e>

00000000800005b2 <console_putc>:

void console_putc(int c)
{
    800005b2:	1141                	addi	sp,sp,-16
    800005b4:	e406                	sd	ra,8(sp)
    800005b6:	e022                	sd	s0,0(sp)
    800005b8:	0800                	addi	s0,sp,16
    if (c == BACKSPACE) {
    800005ba:	10000793          	li	a5,256
    800005be:	00f50a63          	beq	a0,a5,800005d2 <console_putc+0x20>
        // if the user typed backspace, overwrite with a space.
        uartputc_sync('\b');
        uartputc_sync(' ');
        uartputc_sync('\b');
    } else {
        uartputc_sync(c);
    800005c2:	00000097          	auipc	ra,0x0
    800005c6:	be0080e7          	jalr	-1056(ra) # 800001a2 <uartputc_sync>
    }
}
    800005ca:	60a2                	ld	ra,8(sp)
    800005cc:	6402                	ld	s0,0(sp)
    800005ce:	0141                	addi	sp,sp,16
    800005d0:	8082                	ret
        uartputc_sync('\b');
    800005d2:	4521                	li	a0,8
    800005d4:	00000097          	auipc	ra,0x0
    800005d8:	bce080e7          	jalr	-1074(ra) # 800001a2 <uartputc_sync>
        uartputc_sync(' ');
    800005dc:	02000513          	li	a0,32
    800005e0:	00000097          	auipc	ra,0x0
    800005e4:	bc2080e7          	jalr	-1086(ra) # 800001a2 <uartputc_sync>
        uartputc_sync('\b');
    800005e8:	4521                	li	a0,8
    800005ea:	00000097          	auipc	ra,0x0
    800005ee:	bb8080e7          	jalr	-1096(ra) # 800001a2 <uartputc_sync>
    800005f2:	bfe1                	j	800005ca <console_putc+0x18>

00000000800005f4 <console_intr>:

void console_intr(char c)
{
    800005f4:	1101                	addi	sp,sp,-32
    800005f6:	ec06                	sd	ra,24(sp)
    800005f8:	e822                	sd	s0,16(sp)
    800005fa:	e426                	sd	s1,8(sp)
    800005fc:	1000                	addi	s0,sp,32
    switch (c) {
    800005fe:	47c1                	li	a5,16
    80000600:	04f50263          	beq	a0,a5,80000644 <console_intr+0x50>
    80000604:	84aa                	mv	s1,a0
    80000606:	07f00793          	li	a5,127
    8000060a:	04f51663          	bne	a0,a5,80000656 <console_intr+0x62>

    case '\x7f': // 退格
        if (consloe_buf.read_index != consloe_buf.write_index) {
    8000060e:	00005717          	auipc	a4,0x5
    80000612:	b1270713          	addi	a4,a4,-1262 # 80005120 <consloe_buf>
    80000616:	0cc72783          	lw	a5,204(a4)
    8000061a:	0c872703          	lw	a4,200(a4)
    8000061e:	02f70763          	beq	a4,a5,8000064c <console_intr+0x58>
            consloe_buf.write_index--;
    80000622:	37fd                	addiw	a5,a5,-1
    80000624:	00005717          	auipc	a4,0x5
    80000628:	bcf72423          	sw	a5,-1080(a4) # 800051ec <consloe_buf+0xcc>
            console_putc(BACKSPACE);
    8000062c:	10000513          	li	a0,256
    80000630:	00000097          	auipc	ra,0x0
    80000634:	f82080e7          	jalr	-126(ra) # 800005b2 <console_putc>
            console_putc('\a');
    80000638:	451d                	li	a0,7
    8000063a:	00000097          	auipc	ra,0x0
    8000063e:	f78080e7          	jalr	-136(ra) # 800005b2 <console_putc>
    80000642:	a029                	j	8000064c <console_intr+0x58>
        }
        break;
    case CTRL('P'):
        print_proc();
    80000644:	00001097          	auipc	ra,0x1
    80000648:	22e080e7          	jalr	558(ra) # 80001872 <print_proc>
        if (c == '\n') {
            wakeup(&consloe_buf);
        }
        break;
    }
}
    8000064c:	60e2                	ld	ra,24(sp)
    8000064e:	6442                	ld	s0,16(sp)
    80000650:	64a2                	ld	s1,8(sp)
    80000652:	6105                	addi	sp,sp,32
    80000654:	8082                	ret
        c = (c == '\r') ? '\n' : c;
    80000656:	47b5                	li	a5,13
    80000658:	02f50b63          	beq	a0,a5,8000068e <console_intr+0x9a>
        console_putc(c);
    8000065c:	00000097          	auipc	ra,0x0
    80000660:	f56080e7          	jalr	-170(ra) # 800005b2 <console_putc>
        consloe_buf.buf[consloe_buf.write_index++ % INPUT_BUF] = c;
    80000664:	00005797          	auipc	a5,0x5
    80000668:	abc78793          	addi	a5,a5,-1348 # 80005120 <consloe_buf>
    8000066c:	0cc7a703          	lw	a4,204(a5)
    80000670:	0017069b          	addiw	a3,a4,1
    80000674:	0cd7a623          	sw	a3,204(a5)
    80000678:	0c800693          	li	a3,200
    8000067c:	02d7673b          	remw	a4,a4,a3
    80000680:	97ba                	add	a5,a5,a4
    80000682:	00978023          	sb	s1,0(a5)
        if (c == '\n') {
    80000686:	47a9                	li	a5,10
    80000688:	fcf492e3          	bne	s1,a5,8000064c <console_intr+0x58>
    8000068c:	a805                	j	800006bc <console_intr+0xc8>
        console_putc(c);
    8000068e:	4529                	li	a0,10
    80000690:	00000097          	auipc	ra,0x0
    80000694:	f22080e7          	jalr	-222(ra) # 800005b2 <console_putc>
        consloe_buf.buf[consloe_buf.write_index++ % INPUT_BUF] = c;
    80000698:	00005797          	auipc	a5,0x5
    8000069c:	a8878793          	addi	a5,a5,-1400 # 80005120 <consloe_buf>
    800006a0:	0cc7a703          	lw	a4,204(a5)
    800006a4:	0017069b          	addiw	a3,a4,1
    800006a8:	0cd7a623          	sw	a3,204(a5)
    800006ac:	0c800693          	li	a3,200
    800006b0:	02d7673b          	remw	a4,a4,a3
    800006b4:	97ba                	add	a5,a5,a4
    800006b6:	4729                	li	a4,10
    800006b8:	00e78023          	sb	a4,0(a5)
            wakeup(&consloe_buf);
    800006bc:	00005517          	auipc	a0,0x5
    800006c0:	a6450513          	addi	a0,a0,-1436 # 80005120 <consloe_buf>
    800006c4:	00000097          	auipc	ra,0x0
    800006c8:	746080e7          	jalr	1862(ra) # 80000e0a <wakeup>
}
    800006cc:	b741                	j	8000064c <console_intr+0x58>

00000000800006ce <panic>:

void panic(char* s)
{
    800006ce:	1141                	addi	sp,sp,-16
    800006d0:	e406                	sd	ra,8(sp)
    800006d2:	e022                	sd	s0,0(sp)
    800006d4:	0800                	addi	s0,sp,16
    800006d6:	85aa                	mv	a1,a0
    printf("panic:%s", s);
    800006d8:	00003517          	auipc	a0,0x3
    800006dc:	95050513          	addi	a0,a0,-1712 # 80003028 <virtio_disk_intr+0x10a6>
    800006e0:	00000097          	auipc	ra,0x0
    800006e4:	de2080e7          	jalr	-542(ra) # 800004c2 <printf>

    for (;;) {
    800006e8:	a001                	j	800006e8 <panic+0x1a>

00000000800006ea <proc_err>:
//
// 处理进程error的情况
// 中断处理程序检测到错误将会返回到这里
//
void proc_err()
{
    800006ea:	1141                	addi	sp,sp,-16
    800006ec:	e406                	sd	ra,8(sp)
    800006ee:	e022                	sd	s0,0(sp)
    800006f0:	0800                	addi	s0,sp,16
    exit(-1);
    800006f2:	557d                	li	a0,-1
    800006f4:	00001097          	auipc	ra,0x1
    800006f8:	992080e7          	jalr	-1646(ra) # 80001086 <exit>
}
    800006fc:	60a2                	ld	ra,8(sp)
    800006fe:	6402                	ld	s0,0(sp)
    80000700:	0141                	addi	sp,sp,16
    80000702:	8082                	ret

0000000080000704 <trapinit>:
{
    80000704:	1141                	addi	sp,sp,-16
    80000706:	e422                	sd	s0,8(sp)
    80000708:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000070a:	00000797          	auipc	a5,0x0
    8000070e:	24678793          	addi	a5,a5,582 # 80000950 <kernelvec>
    80000712:	10579073          	csrw	stvec,a5
}
    80000716:	6422                	ld	s0,8(sp)
    80000718:	0141                	addi	sp,sp,16
    8000071a:	8082                	ret

000000008000071c <clockintr>:
    w_sstatus(sstatus);
}

// 定时器中断处理程序
void clockintr()
{
    8000071c:	1141                	addi	sp,sp,-16
    8000071e:	e406                	sd	ra,8(sp)
    80000720:	e022                	sd	s0,0(sp)
    80000722:	0800                	addi	s0,sp,16
    ticks++;
    80000724:	00004517          	auipc	a0,0x4
    80000728:	8ec50513          	addi	a0,a0,-1812 # 80004010 <ticks>
    8000072c:	611c                	ld	a5,0(a0)
    8000072e:	0785                	addi	a5,a5,1
    80000730:	e11c                	sd	a5,0(a0)
    wakeup(&ticks);
    80000732:	00000097          	auipc	ra,0x0
    80000736:	6d8080e7          	jalr	1752(ra) # 80000e0a <wakeup>
}
    8000073a:	60a2                	ld	ra,8(sp)
    8000073c:	6402                	ld	s0,0(sp)
    8000073e:	0141                	addi	sp,sp,16
    80000740:	8082                	ret

0000000080000742 <device_intr>:
// 用于判断中断是否为外部和软件中断，并处理它
// 2: 时钟中断
// 1: 其他设备中断
// 0: 无法识别的中断
int device_intr()
{
    80000742:	1101                	addi	sp,sp,-32
    80000744:	ec06                	sd	ra,24(sp)
    80000746:	e822                	sd	s0,16(sp)
    80000748:	e426                	sd	s1,8(sp)
    8000074a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000074c:	14202773          	csrr	a4,scause
    uint64 scause = r_scause();

    if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80000750:	00074d63          	bltz	a4,8000076a <device_intr+0x28>
        // 告诉PLIC该设备现在被允许再次抛出中断
        if (irq)
            plic_complete(irq);

        return 1;
    } else if (scause == 0x8000000000000001L) {
    80000754:	57fd                	li	a5,-1
    80000756:	17fe                	slli	a5,a5,0x3f
    80000758:	0785                	addi	a5,a5,1
        }
        // 告知以收到软件中断，通过清除sip的SSIP位
        w_sip(r_sip() & ~2);
        return 2;
    } else {
        return 0;
    8000075a:	4501                	li	a0,0
    } else if (scause == 0x8000000000000001L) {
    8000075c:	06f70363          	beq	a4,a5,800007c2 <device_intr+0x80>
    }
    80000760:	60e2                	ld	ra,24(sp)
    80000762:	6442                	ld	s0,16(sp)
    80000764:	64a2                	ld	s1,8(sp)
    80000766:	6105                	addi	sp,sp,32
    80000768:	8082                	ret
    if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    8000076a:	0ff77793          	andi	a5,a4,255
    8000076e:	46a5                	li	a3,9
    80000770:	fed792e3          	bne	a5,a3,80000754 <device_intr+0x12>
        int irq = plic_claim();
    80000774:	00000097          	auipc	ra,0x0
    80000778:	18a080e7          	jalr	394(ra) # 800008fe <plic_claim>
    8000077c:	84aa                	mv	s1,a0
        if (irq == UART0_IRQ) {
    8000077e:	47a9                	li	a5,10
    80000780:	02f50763          	beq	a0,a5,800007ae <device_intr+0x6c>
        } else if (irq == VIRTIO0_IRQ) {
    80000784:	4785                	li	a5,1
    80000786:	02f50963          	beq	a0,a5,800007b8 <device_intr+0x76>
        return 1;
    8000078a:	4505                	li	a0,1
        } else if (irq) {
    8000078c:	d8f1                	beqz	s1,80000760 <device_intr+0x1e>
            panic("unexpected interrupt irq=%d\n", irq);
    8000078e:	85a6                	mv	a1,s1
    80000790:	00003517          	auipc	a0,0x3
    80000794:	8c050513          	addi	a0,a0,-1856 # 80003050 <digits+0x18>
    80000798:	00000097          	auipc	ra,0x0
    8000079c:	f36080e7          	jalr	-202(ra) # 800006ce <panic>
            plic_complete(irq);
    800007a0:	8526                	mv	a0,s1
    800007a2:	00000097          	auipc	ra,0x0
    800007a6:	180080e7          	jalr	384(ra) # 80000922 <plic_complete>
        return 1;
    800007aa:	4505                	li	a0,1
    800007ac:	bf55                	j	80000760 <device_intr+0x1e>
            uart_intr();
    800007ae:	00000097          	auipc	ra,0x0
    800007b2:	a46080e7          	jalr	-1466(ra) # 800001f4 <uart_intr>
    800007b6:	b7ed                	j	800007a0 <device_intr+0x5e>
            virtio_disk_intr();
    800007b8:	00001097          	auipc	ra,0x1
    800007bc:	7ca080e7          	jalr	1994(ra) # 80001f82 <virtio_disk_intr>
    800007c0:	b7c5                	j	800007a0 <device_intr+0x5e>
        if (cpuid() == 0) {
    800007c2:	00000097          	auipc	ra,0x0
    800007c6:	55c080e7          	jalr	1372(ra) # 80000d1e <cpuid>
    800007ca:	c901                	beqz	a0,800007da <device_intr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    800007cc:	144027f3          	csrr	a5,sip
        w_sip(r_sip() & ~2);
    800007d0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    800007d2:	14479073          	csrw	sip,a5
        return 2;
    800007d6:	4509                	li	a0,2
    800007d8:	b761                	j	80000760 <device_intr+0x1e>
            clockintr();
    800007da:	00000097          	auipc	ra,0x0
    800007de:	f42080e7          	jalr	-190(ra) # 8000071c <clockintr>
    800007e2:	b7ed                	j	800007cc <device_intr+0x8a>

00000000800007e4 <kerneltrap>:
{
    800007e4:	7179                	addi	sp,sp,-48
    800007e6:	f406                	sd	ra,40(sp)
    800007e8:	f022                	sd	s0,32(sp)
    800007ea:	ec26                	sd	s1,24(sp)
    800007ec:	e84a                	sd	s2,16(sp)
    800007ee:	e44e                	sd	s3,8(sp)
    800007f0:	e052                	sd	s4,0(sp)
    800007f2:	1800                	addi	s0,sp,48
    struct proc* p = myproc();
    800007f4:	00000097          	auipc	ra,0x0
    800007f8:	55e080e7          	jalr	1374(ra) # 80000d52 <myproc>
    800007fc:	84aa                	mv	s1,a0
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800007fe:	141029f3          	csrr	s3,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000802:	10002973          	csrr	s2,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80000806:	14202a73          	csrr	s4,scause
    if ((sstatus & SSTATUS_SPP) == 0)
    8000080a:	10097793          	andi	a5,s2,256
    8000080e:	cb8d                	beqz	a5,80000840 <kerneltrap+0x5c>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000810:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000814:	8b89                	andi	a5,a5,2
    if (intr_get() != 0)
    80000816:	ef95                	bnez	a5,80000852 <kerneltrap+0x6e>
    which_dev = device_intr();
    80000818:	00000097          	auipc	ra,0x0
    8000081c:	f2a080e7          	jalr	-214(ra) # 80000742 <device_intr>
    if (which_dev == 0) { // 未知来源
    80000820:	c131                	beqz	a0,80000864 <kerneltrap+0x80>
    } else if (which_dev == 2 && p != 0 && p->state == RUNNING) { // 时钟中断
    80000822:	4789                	li	a5,2
    80000824:	06f50863          	beq	a0,a5,80000894 <kerneltrap+0xb0>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80000828:	14199073          	csrw	sepc,s3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000082c:	10091073          	csrw	sstatus,s2
}
    80000830:	70a2                	ld	ra,40(sp)
    80000832:	7402                	ld	s0,32(sp)
    80000834:	64e2                	ld	s1,24(sp)
    80000836:	6942                	ld	s2,16(sp)
    80000838:	69a2                	ld	s3,8(sp)
    8000083a:	6a02                	ld	s4,0(sp)
    8000083c:	6145                	addi	sp,sp,48
    8000083e:	8082                	ret
        panic("kerneltrap: not from supervisor mode");
    80000840:	00003517          	auipc	a0,0x3
    80000844:	83050513          	addi	a0,a0,-2000 # 80003070 <digits+0x38>
    80000848:	00000097          	auipc	ra,0x0
    8000084c:	e86080e7          	jalr	-378(ra) # 800006ce <panic>
    80000850:	b7c1                	j	80000810 <kerneltrap+0x2c>
        panic("kerneltrap: interrupts enabled");
    80000852:	00003517          	auipc	a0,0x3
    80000856:	84650513          	addi	a0,a0,-1978 # 80003098 <digits+0x60>
    8000085a:	00000097          	auipc	ra,0x0
    8000085e:	e74080e7          	jalr	-396(ra) # 800006ce <panic>
    80000862:	bf5d                	j	80000818 <kerneltrap+0x34>
        printf("pid=%d error\n", p->pid);
    80000864:	508c                	lw	a1,32(s1)
    80000866:	00003517          	auipc	a0,0x3
    8000086a:	85250513          	addi	a0,a0,-1966 # 800030b8 <digits+0x80>
    8000086e:	00000097          	auipc	ra,0x0
    80000872:	c54080e7          	jalr	-940(ra) # 800004c2 <printf>
        printf("scause=%d sepc=%p\n", scause, sepc);
    80000876:	864e                	mv	a2,s3
    80000878:	85d2                	mv	a1,s4
    8000087a:	00003517          	auipc	a0,0x3
    8000087e:	84e50513          	addi	a0,a0,-1970 # 800030c8 <digits+0x90>
    80000882:	00000097          	auipc	ra,0x0
    80000886:	c40080e7          	jalr	-960(ra) # 800004c2 <printf>
        sepc = (uint64)proc_err; // 将异常的返回地址设置为proc_err
    8000088a:	00000997          	auipc	s3,0x0
    8000088e:	e6098993          	addi	s3,s3,-416 # 800006ea <proc_err>
    80000892:	bf59                	j	80000828 <kerneltrap+0x44>
    } else if (which_dev == 2 && p != 0 && p->state == RUNNING) { // 时钟中断
    80000894:	d8d1                	beqz	s1,80000828 <kerneltrap+0x44>
    80000896:	4098                	lw	a4,0(s1)
    80000898:	478d                	li	a5,3
    8000089a:	f8f717e3          	bne	a4,a5,80000828 <kerneltrap+0x44>
        trap_pc = sepc;
    8000089e:	00003797          	auipc	a5,0x3
    800008a2:	7737b523          	sd	s3,1898(a5) # 80004008 <trap_pc>
        sepc =(uint64)proc_sched;
    800008a6:	00000997          	auipc	s3,0x0
    800008aa:	13a98993          	addi	s3,s3,314 # 800009e0 <proc_sched>
    800008ae:	bfad                	j	80000828 <kerneltrap+0x44>

00000000800008b0 <plicinit>:
//


void
plicinit(void)
{
    800008b0:	1141                	addi	sp,sp,-16
    800008b2:	e422                	sd	s0,8(sp)
    800008b4:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  // 设置IRQ的属性为非零
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800008b6:	0c0007b7          	lui	a5,0xc000
    800008ba:	4705                	li	a4,1
    800008bc:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800008be:	c3d8                	sw	a4,4(a5)
}
    800008c0:	6422                	ld	s0,8(sp)
    800008c2:	0141                	addi	sp,sp,16
    800008c4:	8082                	ret

00000000800008c6 <plicinithart>:

void
plicinithart(void)
{
    800008c6:	1141                	addi	sp,sp,-16
    800008c8:	e406                	sd	ra,8(sp)
    800008ca:	e022                	sd	s0,0(sp)
    800008cc:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800008ce:	00000097          	auipc	ra,0x0
    800008d2:	450080e7          	jalr	1104(ra) # 80000d1e <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800008d6:	0085171b          	slliw	a4,a0,0x8
    800008da:	0c0027b7          	lui	a5,0xc002
    800008de:	97ba                	add	a5,a5,a4
    800008e0:	40200713          	li	a4,1026
    800008e4:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800008e8:	00d5151b          	slliw	a0,a0,0xd
    800008ec:	0c2017b7          	lui	a5,0xc201
    800008f0:	953e                	add	a0,a0,a5
    800008f2:	00052023          	sw	zero,0(a0)
}
    800008f6:	60a2                	ld	ra,8(sp)
    800008f8:	6402                	ld	s0,0(sp)
    800008fa:	0141                	addi	sp,sp,16
    800008fc:	8082                	ret

00000000800008fe <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800008fe:	1141                	addi	sp,sp,-16
    80000900:	e406                	sd	ra,8(sp)
    80000902:	e022                	sd	s0,0(sp)
    80000904:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80000906:	00000097          	auipc	ra,0x0
    8000090a:	418080e7          	jalr	1048(ra) # 80000d1e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000090e:	00d5179b          	slliw	a5,a0,0xd
    80000912:	0c201537          	lui	a0,0xc201
    80000916:	953e                	add	a0,a0,a5
  return irq;
}
    80000918:	4148                	lw	a0,4(a0)
    8000091a:	60a2                	ld	ra,8(sp)
    8000091c:	6402                	ld	s0,0(sp)
    8000091e:	0141                	addi	sp,sp,16
    80000920:	8082                	ret

0000000080000922 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80000922:	1101                	addi	sp,sp,-32
    80000924:	ec06                	sd	ra,24(sp)
    80000926:	e822                	sd	s0,16(sp)
    80000928:	e426                	sd	s1,8(sp)
    8000092a:	1000                	addi	s0,sp,32
    8000092c:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000092e:	00000097          	auipc	ra,0x0
    80000932:	3f0080e7          	jalr	1008(ra) # 80000d1e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80000936:	00d5151b          	slliw	a0,a0,0xd
    8000093a:	0c2017b7          	lui	a5,0xc201
    8000093e:	97aa                	add	a5,a5,a0
    80000940:	c3c4                	sw	s1,4(a5)
}
    80000942:	60e2                	ld	ra,24(sp)
    80000944:	6442                	ld	s0,16(sp)
    80000946:	64a2                	ld	s1,8(sp)
    80000948:	6105                	addi	sp,sp,32
    8000094a:	8082                	ret
    8000094c:	0000                	unimp
	...

0000000080000950 <kernelvec>:
    80000950:	7111                	addi	sp,sp,-256
    80000952:	e006                	sd	ra,0(sp)
    80000954:	e40a                	sd	sp,8(sp)
    80000956:	e80e                	sd	gp,16(sp)
    80000958:	ec12                	sd	tp,24(sp)
    8000095a:	f016                	sd	t0,32(sp)
    8000095c:	f41a                	sd	t1,40(sp)
    8000095e:	f81e                	sd	t2,48(sp)
    80000960:	fc22                	sd	s0,56(sp)
    80000962:	e0a6                	sd	s1,64(sp)
    80000964:	e4aa                	sd	a0,72(sp)
    80000966:	e8ae                	sd	a1,80(sp)
    80000968:	ecb2                	sd	a2,88(sp)
    8000096a:	f0b6                	sd	a3,96(sp)
    8000096c:	f4ba                	sd	a4,104(sp)
    8000096e:	f8be                	sd	a5,112(sp)
    80000970:	fcc2                	sd	a6,120(sp)
    80000972:	e146                	sd	a7,128(sp)
    80000974:	e54a                	sd	s2,136(sp)
    80000976:	e94e                	sd	s3,144(sp)
    80000978:	ed52                	sd	s4,152(sp)
    8000097a:	f156                	sd	s5,160(sp)
    8000097c:	f55a                	sd	s6,168(sp)
    8000097e:	f95e                	sd	s7,176(sp)
    80000980:	fd62                	sd	s8,184(sp)
    80000982:	e1e6                	sd	s9,192(sp)
    80000984:	e5ea                	sd	s10,200(sp)
    80000986:	e9ee                	sd	s11,208(sp)
    80000988:	edf2                	sd	t3,216(sp)
    8000098a:	f1f6                	sd	t4,224(sp)
    8000098c:	f5fa                	sd	t5,232(sp)
    8000098e:	f9fe                	sd	t6,240(sp)
    80000990:	e55ff0ef          	jal	ra,800007e4 <kerneltrap>
    80000994:	6082                	ld	ra,0(sp)
    80000996:	6122                	ld	sp,8(sp)
    80000998:	61c2                	ld	gp,16(sp)
    8000099a:	6262                	ld	tp,24(sp)
    8000099c:	7282                	ld	t0,32(sp)
    8000099e:	7322                	ld	t1,40(sp)
    800009a0:	73c2                	ld	t2,48(sp)
    800009a2:	7462                	ld	s0,56(sp)
    800009a4:	6486                	ld	s1,64(sp)
    800009a6:	6526                	ld	a0,72(sp)
    800009a8:	65c6                	ld	a1,80(sp)
    800009aa:	6666                	ld	a2,88(sp)
    800009ac:	7686                	ld	a3,96(sp)
    800009ae:	7726                	ld	a4,104(sp)
    800009b0:	77c6                	ld	a5,112(sp)
    800009b2:	7866                	ld	a6,120(sp)
    800009b4:	688a                	ld	a7,128(sp)
    800009b6:	692a                	ld	s2,136(sp)
    800009b8:	69ca                	ld	s3,144(sp)
    800009ba:	6a6a                	ld	s4,152(sp)
    800009bc:	7a8a                	ld	s5,160(sp)
    800009be:	7b2a                	ld	s6,168(sp)
    800009c0:	7bca                	ld	s7,176(sp)
    800009c2:	7c6a                	ld	s8,184(sp)
    800009c4:	6c8e                	ld	s9,192(sp)
    800009c6:	6d2e                	ld	s10,200(sp)
    800009c8:	6dce                	ld	s11,208(sp)
    800009ca:	6e6e                	ld	t3,216(sp)
    800009cc:	7e8e                	ld	t4,224(sp)
    800009ce:	7f2e                	ld	t5,232(sp)
    800009d0:	7fce                	ld	t6,240(sp)
    800009d2:	6111                	addi	sp,sp,256
    800009d4:	10200073          	sret
    800009d8:	00000013          	nop
    800009dc:	00000013          	nop

00000000800009e0 <proc_sched>:
    800009e0:	7111                	addi	sp,sp,-256
    800009e2:	e006                	sd	ra,0(sp)
    800009e4:	e40a                	sd	sp,8(sp)
    800009e6:	e80e                	sd	gp,16(sp)
    800009e8:	ec12                	sd	tp,24(sp)
    800009ea:	f016                	sd	t0,32(sp)
    800009ec:	f41a                	sd	t1,40(sp)
    800009ee:	f81e                	sd	t2,48(sp)
    800009f0:	fc22                	sd	s0,56(sp)
    800009f2:	e0a6                	sd	s1,64(sp)
    800009f4:	e4aa                	sd	a0,72(sp)
    800009f6:	e8ae                	sd	a1,80(sp)
    800009f8:	ecb2                	sd	a2,88(sp)
    800009fa:	f0b6                	sd	a3,96(sp)
    800009fc:	f4ba                	sd	a4,104(sp)
    800009fe:	f8be                	sd	a5,112(sp)
    80000a00:	fcc2                	sd	a6,120(sp)
    80000a02:	e146                	sd	a7,128(sp)
    80000a04:	e54a                	sd	s2,136(sp)
    80000a06:	e94e                	sd	s3,144(sp)
    80000a08:	ed52                	sd	s4,152(sp)
    80000a0a:	f156                	sd	s5,160(sp)
    80000a0c:	f55a                	sd	s6,168(sp)
    80000a0e:	f95e                	sd	s7,176(sp)
    80000a10:	fd62                	sd	s8,184(sp)
    80000a12:	e1e6                	sd	s9,192(sp)
    80000a14:	e5ea                	sd	s10,200(sp)
    80000a16:	e9ee                	sd	s11,208(sp)
    80000a18:	edf2                	sd	t3,216(sp)
    80000a1a:	f1f6                	sd	t4,224(sp)
    80000a1c:	f5fa                	sd	t5,232(sp)
    80000a1e:	f9fe                	sd	t6,240(sp)
    80000a20:	02c010ef          	jal	ra,80001a4c <yeild>
    80000a24:	6082                	ld	ra,0(sp)
    80000a26:	6122                	ld	sp,8(sp)
    80000a28:	61c2                	ld	gp,16(sp)
    80000a2a:	6262                	ld	tp,24(sp)
    80000a2c:	7282                	ld	t0,32(sp)
    80000a2e:	7322                	ld	t1,40(sp)
    80000a30:	73c2                	ld	t2,48(sp)
    80000a32:	7462                	ld	s0,56(sp)
    80000a34:	6486                	ld	s1,64(sp)
    80000a36:	6526                	ld	a0,72(sp)
    80000a38:	65c6                	ld	a1,80(sp)
    80000a3a:	6666                	ld	a2,88(sp)
    80000a3c:	7686                	ld	a3,96(sp)
    80000a3e:	7726                	ld	a4,104(sp)
    80000a40:	77c6                	ld	a5,112(sp)
    80000a42:	7866                	ld	a6,120(sp)
    80000a44:	688a                	ld	a7,128(sp)
    80000a46:	692a                	ld	s2,136(sp)
    80000a48:	69ca                	ld	s3,144(sp)
    80000a4a:	6a6a                	ld	s4,152(sp)
    80000a4c:	7a8a                	ld	s5,160(sp)
    80000a4e:	7b2a                	ld	s6,168(sp)
    80000a50:	7bca                	ld	s7,176(sp)
    80000a52:	7c6a                	ld	s8,184(sp)
    80000a54:	6c8e                	ld	s9,192(sp)
    80000a56:	6d2e                	ld	s10,200(sp)
    80000a58:	6dce                	ld	s11,208(sp)
    80000a5a:	6e6e                	ld	t3,216(sp)
    80000a5c:	7e8e                	ld	t4,224(sp)
    80000a5e:	7f2e                	ld	t5,232(sp)
    80000a60:	7fce                	ld	t6,240(sp)
    80000a62:	6111                	addi	sp,sp,256
    80000a64:	00003297          	auipc	t0,0x3
    80000a68:	5a42b283          	ld	t0,1444(t0) # 80004008 <trap_pc>
    80000a6c:	8282                	jr	t0
    80000a6e:	0001                	nop

0000000080000a70 <timervec>:
    80000a70:	34051573          	csrrw	a0,mscratch,a0
    80000a74:	e10c                	sd	a1,0(a0)
    80000a76:	e510                	sd	a2,8(a0)
    80000a78:	e914                	sd	a3,16(a0)
    80000a7a:	710c                	ld	a1,32(a0)
    80000a7c:	7510                	ld	a2,40(a0)
    80000a7e:	6194                	ld	a3,0(a1)
    80000a80:	96b2                	add	a3,a3,a2
    80000a82:	e194                	sd	a3,0(a1)
    80000a84:	4589                	li	a1,2
    80000a86:	14459073          	csrw	sip,a1
    80000a8a:	6914                	ld	a3,16(a0)
    80000a8c:	6510                	ld	a2,8(a0)
    80000a8e:	610c                	ld	a1,0(a0)
    80000a90:	34051573          	csrrw	a0,mscratch,a0
    80000a94:	30200073          	mret

0000000080000a98 <fstest>:
    } else {
        exec((uint64)print_hello);
    }
}

void fstest(){
    80000a98:	bb010113          	addi	sp,sp,-1104
    80000a9c:	44113423          	sd	ra,1096(sp)
    80000aa0:	44813023          	sd	s0,1088(sp)
    80000aa4:	45010413          	addi	s0,sp,1104
    struct buf b;
    b.blockno = 1;
    80000aa8:	4785                	li	a5,1
    80000aaa:	bcf42a23          	sw	a5,-1068(s0)
    virtio_disk_rw(&b, 0);
    80000aae:	4581                	li	a1,0
    80000ab0:	bc840513          	addi	a0,s0,-1080
    80000ab4:	00001097          	auipc	ra,0x1
    80000ab8:	22a080e7          	jalr	554(ra) # 80001cde <virtio_disk_rw>
    struct superblock sb;
    memmove(&sb, b.data,sizeof(sb));
    80000abc:	4661                	li	a2,24
    80000abe:	bdc40593          	addi	a1,s0,-1060
    80000ac2:	bb040513          	addi	a0,s0,-1104
    80000ac6:	00001097          	auipc	ra,0x1
    80000aca:	e32080e7          	jalr	-462(ra) # 800018f8 <memmove>
    printf("%p\n", sb.magic);
    80000ace:	bb042583          	lw	a1,-1104(s0)
    80000ad2:	00002517          	auipc	a0,0x2
    80000ad6:	60e50513          	addi	a0,a0,1550 # 800030e0 <digits+0xa8>
    80000ada:	00000097          	auipc	ra,0x0
    80000ade:	9e8080e7          	jalr	-1560(ra) # 800004c2 <printf>
}
    80000ae2:	44813083          	ld	ra,1096(sp)
    80000ae6:	44013403          	ld	s0,1088(sp)
    80000aea:	45010113          	addi	sp,sp,1104
    80000aee:	8082                	ret

0000000080000af0 <strcpy>:
#include "kernel/types.h"

//string utils
char* strcpy(char* s, const char* t)
{
    80000af0:	1141                	addi	sp,sp,-16
    80000af2:	e422                	sd	s0,8(sp)
    80000af4:	0800                	addi	s0,sp,16
    char* os;
    os = s;
    while ((*s++ = *t++) != 0)
    80000af6:	87aa                	mv	a5,a0
    80000af8:	0585                	addi	a1,a1,1
    80000afa:	0785                	addi	a5,a5,1
    80000afc:	fff5c703          	lbu	a4,-1(a1)
    80000b00:	fee78fa3          	sb	a4,-1(a5) # c200fff <_entry-0x73dff001>
    80000b04:	fb75                	bnez	a4,80000af8 <strcpy+0x8>
        ;
    return os;
}
    80000b06:	6422                	ld	s0,8(sp)
    80000b08:	0141                	addi	sp,sp,16
    80000b0a:	8082                	ret

0000000080000b0c <strcmp>:

int strcmp(const char* p, const char* q)
{
    80000b0c:	1141                	addi	sp,sp,-16
    80000b0e:	e422                	sd	s0,8(sp)
    80000b10:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
    80000b12:	00054783          	lbu	a5,0(a0)
    80000b16:	cb91                	beqz	a5,80000b2a <strcmp+0x1e>
    80000b18:	0005c703          	lbu	a4,0(a1)
    80000b1c:	00f71763          	bne	a4,a5,80000b2a <strcmp+0x1e>
        p++, q++;
    80000b20:	0505                	addi	a0,a0,1
    80000b22:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
    80000b24:	00054783          	lbu	a5,0(a0)
    80000b28:	fbe5                	bnez	a5,80000b18 <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
    80000b2a:	0005c503          	lbu	a0,0(a1)
}
    80000b2e:	40a7853b          	subw	a0,a5,a0
    80000b32:	6422                	ld	s0,8(sp)
    80000b34:	0141                	addi	sp,sp,16
    80000b36:	8082                	ret

0000000080000b38 <strlen>:

uint strlen(const char* s)
{
    80000b38:	1141                	addi	sp,sp,-16
    80000b3a:	e422                	sd	s0,8(sp)
    80000b3c:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
    80000b3e:	00054783          	lbu	a5,0(a0)
    80000b42:	cf91                	beqz	a5,80000b5e <strlen+0x26>
    80000b44:	0505                	addi	a0,a0,1
    80000b46:	87aa                	mv	a5,a0
    80000b48:	4685                	li	a3,1
    80000b4a:	9e89                	subw	a3,a3,a0
    80000b4c:	00f6853b          	addw	a0,a3,a5
    80000b50:	0785                	addi	a5,a5,1
    80000b52:	fff7c703          	lbu	a4,-1(a5)
    80000b56:	fb7d                	bnez	a4,80000b4c <strlen+0x14>
        ;
    return n;
}
    80000b58:	6422                	ld	s0,8(sp)
    80000b5a:	0141                	addi	sp,sp,16
    80000b5c:	8082                	ret
    for (n = 0; s[n]; n++)
    80000b5e:	4501                	li	a0,0
    80000b60:	bfe5                	j	80000b58 <strlen+0x20>

0000000080000b62 <strchr>:

char* strchr(const char* s, char c)
{
    80000b62:	1141                	addi	sp,sp,-16
    80000b64:	e422                	sd	s0,8(sp)
    80000b66:	0800                	addi	s0,sp,16
    for (; *s; s++)
    80000b68:	00054783          	lbu	a5,0(a0)
    80000b6c:	cb99                	beqz	a5,80000b82 <strchr+0x20>
        if (*s == c)
    80000b6e:	00f58763          	beq	a1,a5,80000b7c <strchr+0x1a>
    for (; *s; s++)
    80000b72:	0505                	addi	a0,a0,1
    80000b74:	00054783          	lbu	a5,0(a0)
    80000b78:	fbfd                	bnez	a5,80000b6e <strchr+0xc>
            return (char*)s;
    return 0;
    80000b7a:	4501                	li	a0,0
}
    80000b7c:	6422                	ld	s0,8(sp)
    80000b7e:	0141                	addi	sp,sp,16
    80000b80:	8082                	ret
    return 0;
    80000b82:	4501                	li	a0,0
    80000b84:	bfe5                	j	80000b7c <strchr+0x1a>

0000000080000b86 <atoi>:
//     buf[i] = '\0';
//     return buf;
// }

int atoi(const char* s)
{
    80000b86:	1141                	addi	sp,sp,-16
    80000b88:	e422                	sd	s0,8(sp)
    80000b8a:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
    80000b8c:	00054603          	lbu	a2,0(a0)
    80000b90:	fd06079b          	addiw	a5,a2,-48
    80000b94:	0ff7f793          	andi	a5,a5,255
    80000b98:	4725                	li	a4,9
    80000b9a:	02f76963          	bltu	a4,a5,80000bcc <atoi+0x46>
    80000b9e:	86aa                	mv	a3,a0
    n = 0;
    80000ba0:	4501                	li	a0,0
    while ('0' <= *s && *s <= '9')
    80000ba2:	45a5                	li	a1,9
        n = n * 10 + *s++ - '0';
    80000ba4:	0685                	addi	a3,a3,1
    80000ba6:	0025179b          	slliw	a5,a0,0x2
    80000baa:	9fa9                	addw	a5,a5,a0
    80000bac:	0017979b          	slliw	a5,a5,0x1
    80000bb0:	9fb1                	addw	a5,a5,a2
    80000bb2:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
    80000bb6:	0006c603          	lbu	a2,0(a3)
    80000bba:	fd06071b          	addiw	a4,a2,-48
    80000bbe:	0ff77713          	andi	a4,a4,255
    80000bc2:	fee5f1e3          	bgeu	a1,a4,80000ba4 <atoi+0x1e>
    return n;
}
    80000bc6:	6422                	ld	s0,8(sp)
    80000bc8:	0141                	addi	sp,sp,16
    80000bca:	8082                	ret
    n = 0;
    80000bcc:	4501                	li	a0,0
    80000bce:	bfe5                	j	80000bc6 <atoi+0x40>

0000000080000bd0 <memcmp>:
//     }
//     return vdst;
// }

int memcmp(const void* s1, const void* s2, uint n)
{
    80000bd0:	1141                	addi	sp,sp,-16
    80000bd2:	e422                	sd	s0,8(sp)
    80000bd4:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0) {
    80000bd6:	ca05                	beqz	a2,80000c06 <memcmp+0x36>
    80000bd8:	fff6069b          	addiw	a3,a2,-1
    80000bdc:	1682                	slli	a3,a3,0x20
    80000bde:	9281                	srli	a3,a3,0x20
    80000be0:	0685                	addi	a3,a3,1
    80000be2:	96aa                	add	a3,a3,a0
        if (*p1 != *p2) {
    80000be4:	00054783          	lbu	a5,0(a0)
    80000be8:	0005c703          	lbu	a4,0(a1)
    80000bec:	00e79863          	bne	a5,a4,80000bfc <memcmp+0x2c>
            return *p1 - *p2;
        }
        p1++;
    80000bf0:	0505                	addi	a0,a0,1
        p2++;
    80000bf2:	0585                	addi	a1,a1,1
    while (n-- > 0) {
    80000bf4:	fed518e3          	bne	a0,a3,80000be4 <memcmp+0x14>
    }
    return 0;
    80000bf8:	4501                	li	a0,0
    80000bfa:	a019                	j	80000c00 <memcmp+0x30>
            return *p1 - *p2;
    80000bfc:	40e7853b          	subw	a0,a5,a4
}
    80000c00:	6422                	ld	s0,8(sp)
    80000c02:	0141                	addi	sp,sp,16
    80000c04:	8082                	ret
    return 0;
    80000c06:	4501                	li	a0,0
    80000c08:	bfe5                	j	80000c00 <memcmp+0x30>

0000000080000c0a <memcpy>:

void* memcpy(void* dst, const void* src, uint n)
{
    80000c0a:	1141                	addi	sp,sp,-16
    80000c0c:	e406                	sd	ra,8(sp)
    80000c0e:	e022                	sd	s0,0(sp)
    80000c10:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
    80000c12:	00001097          	auipc	ra,0x1
    80000c16:	ce6080e7          	jalr	-794(ra) # 800018f8 <memmove>
}
    80000c1a:	60a2                	ld	ra,8(sp)
    80000c1c:	6402                	ld	s0,0(sp)
    80000c1e:	0141                	addi	sp,sp,16
    80000c20:	8082                	ret

0000000080000c22 <min>:

//math utils
int min(int a, int b)
{
    80000c22:	1141                	addi	sp,sp,-16
    80000c24:	e422                	sd	s0,8(sp)
    80000c26:	0800                	addi	s0,sp,16
    return a < b ? a : b;
    80000c28:	87ae                	mv	a5,a1
    80000c2a:	00b55363          	bge	a0,a1,80000c30 <min+0xe>
    80000c2e:	87aa                	mv	a5,a0
}
    80000c30:	0007851b          	sext.w	a0,a5
    80000c34:	6422                	ld	s0,8(sp)
    80000c36:	0141                	addi	sp,sp,16
    80000c38:	8082                	ret

0000000080000c3a <max>:
int max(int a, int b)
{
    80000c3a:	1141                	addi	sp,sp,-16
    80000c3c:	e422                	sd	s0,8(sp)
    80000c3e:	0800                	addi	s0,sp,16
    return a > b ? a : b;
    80000c40:	87ae                	mv	a5,a1
    80000c42:	00a5d363          	bge	a1,a0,80000c48 <max+0xe>
    80000c46:	87aa                	mv	a5,a0
    80000c48:	0007851b          	sext.w	a0,a5
    80000c4c:	6422                	ld	s0,8(sp)
    80000c4e:	0141                	addi	sp,sp,16
    80000c50:	8082                	ret

0000000080000c52 <init_process_table>:

char stack[PGSIZE * (NPROC + 1)];

// 初始化进程表
void init_process_table()
{
    80000c52:	1141                	addi	sp,sp,-16
    80000c54:	e422                	sd	s0,8(sp)
    80000c56:	0800                	addi	s0,sp,16
    struct proc* p;
    for (int i = 0; i < NPROC; i++) {
    80000c58:	00045797          	auipc	a5,0x45
    80000c5c:	75878793          	addi	a5,a5,1880 # 800463b0 <proc_table>
    80000c60:	00004697          	auipc	a3,0x4
    80000c64:	75068693          	addi	a3,a3,1872 # 800053b0 <stack>
    80000c68:	4701                	li	a4,0
    80000c6a:	6585                	lui	a1,0x1
    80000c6c:	04000613          	li	a2,64
        p = &proc_table[i];
        p->pid = i;
    80000c70:	d398                	sw	a4,32(a5)
        p->kstack = (uint64)stack + PGSIZE * i;
    80000c72:	f794                	sd	a3,40(a5)
        p->state = UNUSED;
    80000c74:	0007a023          	sw	zero,0(a5)
    for (int i = 0; i < NPROC; i++) {
    80000c78:	2705                	addiw	a4,a4,1
    80000c7a:	0b078793          	addi	a5,a5,176
    80000c7e:	96ae                	add	a3,a3,a1
    80000c80:	fec718e3          	bne	a4,a2,80000c70 <init_process_table+0x1e>
    }
}
    80000c84:	6422                	ld	s0,8(sp)
    80000c86:	0141                	addi	sp,sp,16
    80000c88:	8082                	ret

0000000080000c8a <alloc_proc>:
void trapret();
void kerneltrap();

// 分配一个进程
struct proc* alloc_proc()
{
    80000c8a:	1101                	addi	sp,sp,-32
    80000c8c:	ec06                	sd	ra,24(sp)
    80000c8e:	e822                	sd	s0,16(sp)
    80000c90:	e426                	sd	s1,8(sp)
    80000c92:	1000                	addi	s0,sp,32
    struct proc* p;
    for (int i = 0; i < NPROC; i++) {
    80000c94:	00045717          	auipc	a4,0x45
    80000c98:	71c70713          	addi	a4,a4,1820 # 800463b0 <proc_table>
    80000c9c:	4781                	li	a5,0
    80000c9e:	04000613          	li	a2,64
        p = &proc_table[i];
        if (p->state == UNUSED) {
    80000ca2:	4314                	lw	a3,0(a4)
    80000ca4:	ca81                	beqz	a3,80000cb4 <alloc_proc+0x2a>
    for (int i = 0; i < NPROC; i++) {
    80000ca6:	2785                	addiw	a5,a5,1
    80000ca8:	0b070713          	addi	a4,a4,176
    80000cac:	fec79be3          	bne	a5,a2,80000ca2 <alloc_proc+0x18>
            memset(&p->context, 0, sizeof(p->context));
            p->context.sp = p->kstack + PGSIZE;
            return p;
        }
    }
    return 0;
    80000cb0:	4481                	li	s1,0
    80000cb2:	a80d                	j	80000ce4 <alloc_proc+0x5a>
    80000cb4:	0b000513          	li	a0,176
    80000cb8:	02a787b3          	mul	a5,a5,a0
        p = &proc_table[i];
    80000cbc:	00045517          	auipc	a0,0x45
    80000cc0:	6f450513          	addi	a0,a0,1780 # 800463b0 <proc_table>
    80000cc4:	00a784b3          	add	s1,a5,a0
            memset(&p->context, 0, sizeof(p->context));
    80000cc8:	03078793          	addi	a5,a5,48
    80000ccc:	07000613          	li	a2,112
    80000cd0:	4581                	li	a1,0
    80000cd2:	953e                	add	a0,a0,a5
    80000cd4:	00001097          	auipc	ra,0x1
    80000cd8:	bfe080e7          	jalr	-1026(ra) # 800018d2 <memset>
            p->context.sp = p->kstack + PGSIZE;
    80000cdc:	749c                	ld	a5,40(s1)
    80000cde:	6705                	lui	a4,0x1
    80000ce0:	97ba                	add	a5,a5,a4
    80000ce2:	fc9c                	sd	a5,56(s1)
}
    80000ce4:	8526                	mv	a0,s1
    80000ce6:	60e2                	ld	ra,24(sp)
    80000ce8:	6442                	ld	s0,16(sp)
    80000cea:	64a2                	ld	s1,8(sp)
    80000cec:	6105                	addi	sp,sp,32
    80000cee:	8082                	ret

0000000080000cf0 <init_first_process>:
{
    80000cf0:	1141                	addi	sp,sp,-16
    80000cf2:	e406                	sd	ra,8(sp)
    80000cf4:	e022                	sd	s0,0(sp)
    80000cf6:	0800                	addi	s0,sp,16
    struct proc* p = alloc_proc();
    80000cf8:	00000097          	auipc	ra,0x0
    80000cfc:	f92080e7          	jalr	-110(ra) # 80000c8a <alloc_proc>
    p->context.ra = (uint64)init;
    80000d00:	00001797          	auipc	a5,0x1
    80000d04:	b2c78793          	addi	a5,a5,-1236 # 8000182c <init>
    80000d08:	f91c                	sd	a5,48(a0)
    p->state = RUNNABLE;
    80000d0a:	4789                	li	a5,2
    80000d0c:	c11c                	sw	a5,0(a0)
    initproc = p;
    80000d0e:	00003797          	auipc	a5,0x3
    80000d12:	30a7b523          	sd	a0,778(a5) # 80004018 <initproc>
}
    80000d16:	60a2                	ld	ra,8(sp)
    80000d18:	6402                	ld	s0,0(sp)
    80000d1a:	0141                	addi	sp,sp,16
    80000d1c:	8082                	ret

0000000080000d1e <cpuid>:
    }
}

// 获取当前cpu的id
int cpuid()
{
    80000d1e:	1141                	addi	sp,sp,-16
    80000d20:	e422                	sd	s0,8(sp)
    80000d22:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000d24:	8512                	mv	a0,tp
    int id = r_tp();
    return id;
}
    80000d26:	2501                	sext.w	a0,a0
    80000d28:	6422                	ld	s0,8(sp)
    80000d2a:	0141                	addi	sp,sp,16
    80000d2c:	8082                	ret

0000000080000d2e <mycpu>:

// 获取当前cpu
struct cpu* mycpu(void)
{
    80000d2e:	1141                	addi	sp,sp,-16
    80000d30:	e422                	sd	s0,8(sp)
    80000d32:	0800                	addi	s0,sp,16
    80000d34:	8792                	mv	a5,tp
    int id = cpuid();
    struct cpu* c = &cpus[id];
    80000d36:	0007851b          	sext.w	a0,a5
    80000d3a:	00451793          	slli	a5,a0,0x4
    80000d3e:	8f89                	sub	a5,a5,a0
    80000d40:	078e                	slli	a5,a5,0x3
    return c;
}
    80000d42:	00004517          	auipc	a0,0x4
    80000d46:	4ae50513          	addi	a0,a0,1198 # 800051f0 <cpus>
    80000d4a:	953e                	add	a0,a0,a5
    80000d4c:	6422                	ld	s0,8(sp)
    80000d4e:	0141                	addi	sp,sp,16
    80000d50:	8082                	ret

0000000080000d52 <myproc>:

// 获取当前进程
struct proc* myproc()
{
    80000d52:	1141                	addi	sp,sp,-16
    80000d54:	e422                	sd	s0,8(sp)
    80000d56:	0800                	addi	s0,sp,16
    80000d58:	8792                	mv	a5,tp
    return mycpu()->proc;
    80000d5a:	0007871b          	sext.w	a4,a5
    80000d5e:	00471793          	slli	a5,a4,0x4
    80000d62:	8f99                	sub	a5,a5,a4
    80000d64:	078e                	slli	a5,a5,0x3
    80000d66:	00004717          	auipc	a4,0x4
    80000d6a:	48a70713          	addi	a4,a4,1162 # 800051f0 <cpus>
    80000d6e:	97ba                	add	a5,a5,a4
}
    80000d70:	6388                	ld	a0,0(a5)
    80000d72:	6422                	ld	s0,8(sp)
    80000d74:	0141                	addi	sp,sp,16
    80000d76:	8082                	ret

0000000080000d78 <sleep>:

// 睡眠在chan上
void sleep(void* chan)
{
    80000d78:	1141                	addi	sp,sp,-16
    80000d7a:	e406                	sd	ra,8(sp)
    80000d7c:	e022                	sd	s0,0(sp)
    80000d7e:	0800                	addi	s0,sp,16
    80000d80:	8792                	mv	a5,tp
    return mycpu()->proc;
    80000d82:	00004597          	auipc	a1,0x4
    80000d86:	46e58593          	addi	a1,a1,1134 # 800051f0 <cpus>
    80000d8a:	0007871b          	sext.w	a4,a5
    80000d8e:	00471793          	slli	a5,a4,0x4
    80000d92:	8f99                	sub	a5,a5,a4
    80000d94:	078e                	slli	a5,a5,0x3
    80000d96:	97ae                	add	a5,a5,a1
    80000d98:	6394                	ld	a3,0(a5)
    struct proc* p;
    p = myproc();
    p->state = SLEEPING;
    80000d9a:	4785                	li	a5,1
    80000d9c:	c29c                	sw	a5,0(a3)
    p->chan = chan;
    80000d9e:	ea88                	sd	a0,16(a3)
    80000da0:	8792                	mv	a5,tp
    pswitch(&p->context, &mycpu()->context);
    80000da2:	0007871b          	sext.w	a4,a5
    80000da6:	00471793          	slli	a5,a4,0x4
    80000daa:	8f99                	sub	a5,a5,a4
    80000dac:	078e                	slli	a5,a5,0x3
    80000dae:	07a1                	addi	a5,a5,8
    80000db0:	95be                	add	a1,a1,a5
    80000db2:	03068513          	addi	a0,a3,48
    80000db6:	00001097          	auipc	ra,0x1
    80000dba:	b9e080e7          	jalr	-1122(ra) # 80001954 <pswitch>
}
    80000dbe:	60a2                	ld	ra,8(sp)
    80000dc0:	6402                	ld	s0,0(sp)
    80000dc2:	0141                	addi	sp,sp,16
    80000dc4:	8082                	ret

0000000080000dc6 <sleep_time>:

// 睡眠一定时间
void sleep_time(uint64 sleep_ticks)
{
    80000dc6:	7179                	addi	sp,sp,-48
    80000dc8:	f406                	sd	ra,40(sp)
    80000dca:	f022                	sd	s0,32(sp)
    80000dcc:	ec26                	sd	s1,24(sp)
    80000dce:	e84a                	sd	s2,16(sp)
    80000dd0:	e44e                	sd	s3,8(sp)
    80000dd2:	1800                	addi	s0,sp,48
    uint64 now = ticks;
    80000dd4:	00003997          	auipc	s3,0x3
    80000dd8:	23c9b983          	ld	s3,572(s3) # 80004010 <ticks>
    for (; ticks - now < sleep_ticks;) {
    80000ddc:	c105                	beqz	a0,80000dfc <sleep_time+0x36>
    80000dde:	892a                	mv	s2,a0
        sleep(&ticks);
    80000de0:	00003497          	auipc	s1,0x3
    80000de4:	23048493          	addi	s1,s1,560 # 80004010 <ticks>
    80000de8:	8526                	mv	a0,s1
    80000dea:	00000097          	auipc	ra,0x0
    80000dee:	f8e080e7          	jalr	-114(ra) # 80000d78 <sleep>
    for (; ticks - now < sleep_ticks;) {
    80000df2:	609c                	ld	a5,0(s1)
    80000df4:	413787b3          	sub	a5,a5,s3
    80000df8:	ff27e8e3          	bltu	a5,s2,80000de8 <sleep_time+0x22>
    }
}
    80000dfc:	70a2                	ld	ra,40(sp)
    80000dfe:	7402                	ld	s0,32(sp)
    80000e00:	64e2                	ld	s1,24(sp)
    80000e02:	6942                	ld	s2,16(sp)
    80000e04:	69a2                	ld	s3,8(sp)
    80000e06:	6145                	addi	sp,sp,48
    80000e08:	8082                	ret

0000000080000e0a <wakeup>:

// 唤醒指定chan上的进程
void wakeup(void* chan)
{
    80000e0a:	1141                	addi	sp,sp,-16
    80000e0c:	e422                	sd	s0,8(sp)
    80000e0e:	0800                	addi	s0,sp,16
    struct proc* p;
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80000e10:	00045797          	auipc	a5,0x45
    80000e14:	5a078793          	addi	a5,a5,1440 # 800463b0 <proc_table>
        if (p->state == SLEEPING && p->chan == chan) {
    80000e18:	4605                	li	a2,1
            p->state = RUNNABLE;
    80000e1a:	4589                	li	a1,2
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80000e1c:	00048697          	auipc	a3,0x48
    80000e20:	19468693          	addi	a3,a3,404 # 80048fb0 <proc_table+0x2c00>
    80000e24:	a031                	j	80000e30 <wakeup+0x26>
            p->state = RUNNABLE;
    80000e26:	c38c                	sw	a1,0(a5)
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80000e28:	0b078793          	addi	a5,a5,176
    80000e2c:	00d78963          	beq	a5,a3,80000e3e <wakeup+0x34>
        if (p->state == SLEEPING && p->chan == chan) {
    80000e30:	4398                	lw	a4,0(a5)
    80000e32:	fec71be3          	bne	a4,a2,80000e28 <wakeup+0x1e>
    80000e36:	6b98                	ld	a4,16(a5)
    80000e38:	fea718e3          	bne	a4,a0,80000e28 <wakeup+0x1e>
    80000e3c:	b7ed                	j	80000e26 <wakeup+0x1c>
        }
    }
}
    80000e3e:	6422                	ld	s0,8(sp)
    80000e40:	0141                	addi	sp,sp,16
    80000e42:	8082                	ret

0000000080000e44 <scheduler>:
{
    80000e44:	711d                	addi	sp,sp,-96
    80000e46:	ec86                	sd	ra,88(sp)
    80000e48:	e8a2                	sd	s0,80(sp)
    80000e4a:	e4a6                	sd	s1,72(sp)
    80000e4c:	e0ca                	sd	s2,64(sp)
    80000e4e:	fc4e                	sd	s3,56(sp)
    80000e50:	f852                	sd	s4,48(sp)
    80000e52:	f456                	sd	s5,40(sp)
    80000e54:	f05a                	sd	s6,32(sp)
    80000e56:	ec5e                	sd	s7,24(sp)
    80000e58:	e862                	sd	s8,16(sp)
    80000e5a:	e466                	sd	s9,8(sp)
    80000e5c:	1080                	addi	s0,sp,96
    80000e5e:	8792                	mv	a5,tp
    int id = r_tp();
    80000e60:	2781                	sext.w	a5,a5
                pswitch(&c->context, &p->context);
    80000e62:	00479c13          	slli	s8,a5,0x4
    80000e66:	40fc0c33          	sub	s8,s8,a5
    80000e6a:	0c0e                	slli	s8,s8,0x3
    80000e6c:	00004717          	auipc	a4,0x4
    80000e70:	38c70713          	addi	a4,a4,908 # 800051f8 <cpus+0x8>
    80000e74:	9c3a                	add	s8,s8,a4
                wakeup(initproc);
    80000e76:	00003c97          	auipc	s9,0x3
    80000e7a:	1a2c8c93          	addi	s9,s9,418 # 80004018 <initproc>
                c->proc = p;
    80000e7e:	00479713          	slli	a4,a5,0x4
    80000e82:	40f707b3          	sub	a5,a4,a5
    80000e86:	078e                	slli	a5,a5,0x3
    80000e88:	00004b97          	auipc	s7,0x4
    80000e8c:	368b8b93          	addi	s7,s7,872 # 800051f0 <cpus>
    80000e90:	9bbe                	add	s7,s7,a5
    80000e92:	a889                	j	80000ee4 <scheduler+0xa0>
        for (int i = 0; i < NPROC; i++) {
    80000e94:	0b048493          	addi	s1,s1,176
    80000e98:	03348b63          	beq	s1,s3,80000ece <scheduler+0x8a>
            if (p->state != UNUSED && p->state != ZOMBIE) {
    80000e9c:	8926                	mv	s2,s1
    80000e9e:	409c                	lw	a5,0(s1)
    80000ea0:	dbf5                	beqz	a5,80000e94 <scheduler+0x50>
    80000ea2:	07678363          	beq	a5,s6,80000f08 <scheduler+0xc4>
                alive_p++;
    80000ea6:	2a05                	addiw	s4,s4,1
            if (p->state == RUNNABLE) {
    80000ea8:	00092783          	lw	a5,0(s2)
    80000eac:	ff5794e3          	bne	a5,s5,80000e94 <scheduler+0x50>
                p->state = RUNNING;
    80000eb0:	478d                	li	a5,3
    80000eb2:	00f92023          	sw	a5,0(s2)
                c->proc = p;
    80000eb6:	012bb023          	sd	s2,0(s7)
                pswitch(&c->context, &p->context);
    80000eba:	03048593          	addi	a1,s1,48
    80000ebe:	8562                	mv	a0,s8
    80000ec0:	00001097          	auipc	ra,0x1
    80000ec4:	a94080e7          	jalr	-1388(ra) # 80001954 <pswitch>
                c->proc = 0;
    80000ec8:	000bb023          	sd	zero,0(s7)
    80000ecc:	b7e1                	j	80000e94 <scheduler+0x50>
        if (alive_p <= 2) {
    80000ece:	4789                	li	a5,2
    80000ed0:	0147ca63          	blt	a5,s4,80000ee4 <scheduler+0xa0>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000ed4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000ed8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000edc:	10079073          	csrw	sstatus,a5
            asm volatile("wfi");
    80000ee0:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000ee4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000ee8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000eec:	10079073          	csrw	sstatus,a5
        for (int i = 0; i < NPROC; i++) {
    80000ef0:	00045497          	auipc	s1,0x45
    80000ef4:	4c048493          	addi	s1,s1,1216 # 800463b0 <proc_table>
    80000ef8:	00048997          	auipc	s3,0x48
    80000efc:	0b898993          	addi	s3,s3,184 # 80048fb0 <proc_table+0x2c00>
        alive_p = 0;
    80000f00:	4a01                	li	s4,0
            if (p->state != UNUSED && p->state != ZOMBIE) {
    80000f02:	4b11                	li	s6,4
            if (p->state == RUNNABLE) {
    80000f04:	4a89                	li	s5,2
    80000f06:	bf59                	j	80000e9c <scheduler+0x58>
                wakeup(initproc);
    80000f08:	000cb503          	ld	a0,0(s9)
    80000f0c:	00000097          	auipc	ra,0x0
    80000f10:	efe080e7          	jalr	-258(ra) # 80000e0a <wakeup>
    80000f14:	bf51                	j	80000ea8 <scheduler+0x64>

0000000080000f16 <wait>:
// 等待子进程退出, 返回其子进程id
// 没有子进程返回-1， 将退出状态复
// 制到status中。
//
int wait(int* status)
{
    80000f16:	7139                	addi	sp,sp,-64
    80000f18:	fc06                	sd	ra,56(sp)
    80000f1a:	f822                	sd	s0,48(sp)
    80000f1c:	f426                	sd	s1,40(sp)
    80000f1e:	f04a                	sd	s2,32(sp)
    80000f20:	ec4e                	sd	s3,24(sp)
    80000f22:	e852                	sd	s4,16(sp)
    80000f24:	e456                	sd	s5,8(sp)
    80000f26:	e05a                	sd	s6,0(sp)
    80000f28:	0080                	addi	s0,sp,64
    80000f2a:	8aaa                	mv	s5,a0
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f2c:	8792                	mv	a5,tp
    return mycpu()->proc;
    80000f2e:	0007871b          	sext.w	a4,a5
    80000f32:	00471793          	slli	a5,a4,0x4
    80000f36:	8f99                	sub	a5,a5,a4
    80000f38:	078e                	slli	a5,a5,0x3
    80000f3a:	00004717          	auipc	a4,0x4
    80000f3e:	2b670713          	addi	a4,a4,694 # 800051f0 <cpus>
    80000f42:	97ba                	add	a5,a5,a4
    80000f44:	6384                	ld	s1,0(a5)
    struct proc* cp; // 子进程
    struct proc* p;
    int havechild, pid;
    p = myproc();
    for (;;) {
        havechild = 0;
    80000f46:	4b01                	li	s6,0
        for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
            if (cp->parent == p) {
                havechild = 1;
                if (cp->state == ZOMBIE) {
    80000f48:	4991                	li	s3,4
        for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    80000f4a:	00048917          	auipc	s2,0x48
    80000f4e:	06690913          	addi	s2,s2,102 # 80048fb0 <proc_table+0x2c00>
                havechild = 1;
    80000f52:	4a05                	li	s4,1
        havechild = 0;
    80000f54:	86da                	mv	a3,s6
        for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    80000f56:	00045797          	auipc	a5,0x45
    80000f5a:	45a78793          	addi	a5,a5,1114 # 800463b0 <proc_table>
    80000f5e:	a03d                	j	80000f8c <wait+0x76>
                    pid = cp->pid;
    80000f60:	5388                	lw	a0,32(a5)
                    if (status) {
    80000f62:	000a8563          	beqz	s5,80000f6c <wait+0x56>
                        *status = cp->xstate;
    80000f66:	4fd8                	lw	a4,28(a5)
    80000f68:	00eaa023          	sw	a4,0(s5)
                    }
                    cp->state = UNUSED;
    80000f6c:	0007a023          	sw	zero,0(a5)
        if (!havechild) {
            return -1;
        }
        sleep(p); // 等待子进程唤醒
    }
}
    80000f70:	70e2                	ld	ra,56(sp)
    80000f72:	7442                	ld	s0,48(sp)
    80000f74:	74a2                	ld	s1,40(sp)
    80000f76:	7902                	ld	s2,32(sp)
    80000f78:	69e2                	ld	s3,24(sp)
    80000f7a:	6a42                	ld	s4,16(sp)
    80000f7c:	6aa2                	ld	s5,8(sp)
    80000f7e:	6b02                	ld	s6,0(sp)
    80000f80:	6121                	addi	sp,sp,64
    80000f82:	8082                	ret
        for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    80000f84:	0b078793          	addi	a5,a5,176
    80000f88:	01278a63          	beq	a5,s2,80000f9c <wait+0x86>
            if (cp->parent == p) {
    80000f8c:	6798                	ld	a4,8(a5)
    80000f8e:	fe971be3          	bne	a4,s1,80000f84 <wait+0x6e>
                if (cp->state == ZOMBIE) {
    80000f92:	4398                	lw	a4,0(a5)
    80000f94:	fd3706e3          	beq	a4,s3,80000f60 <wait+0x4a>
                havechild = 1;
    80000f98:	86d2                	mv	a3,s4
    80000f9a:	b7ed                	j	80000f84 <wait+0x6e>
        if (!havechild) {
    80000f9c:	e299                	bnez	a3,80000fa2 <wait+0x8c>
            return -1;
    80000f9e:	557d                	li	a0,-1
    80000fa0:	bfc1                	j	80000f70 <wait+0x5a>
        sleep(p); // 等待子进程唤醒
    80000fa2:	8526                	mv	a0,s1
    80000fa4:	00000097          	auipc	ra,0x0
    80000fa8:	dd4080e7          	jalr	-556(ra) # 80000d78 <sleep>
        havechild = 0;
    80000fac:	b765                	j	80000f54 <wait+0x3e>

0000000080000fae <forktest>:
{
    80000fae:	7179                	addi	sp,sp,-48
    80000fb0:	f406                	sd	ra,40(sp)
    80000fb2:	f022                	sd	s0,32(sp)
    80000fb4:	ec26                	sd	s1,24(sp)
    80000fb6:	e84a                	sd	s2,16(sp)
    80000fb8:	1800                	addi	s0,sp,48
    pid = fork();
    80000fba:	00001097          	auipc	ra,0x1
    80000fbe:	a04080e7          	jalr	-1532(ra) # 800019be <fork>
    if (pid > 0) {
    80000fc2:	04a04e63          	bgtz	a0,8000101e <forktest+0x70>
    a = ((int*)(&a))[0xfffffffffffff];
    80000fc6:	4785                	li	a5,1
    80000fc8:	17da                	slli	a5,a5,0x36
    80000fca:	fe040713          	addi	a4,s0,-32
    80000fce:	97ba                	add	a5,a5,a4
    printf("a=%d\n", a); // 不能删除这一句，不然上一句会被编译器优化掉。
    80000fd0:	ff87a583          	lw	a1,-8(a5)
    80000fd4:	00002517          	auipc	a0,0x2
    80000fd8:	14c50513          	addi	a0,a0,332 # 80003120 <digits+0xe8>
    80000fdc:	fffff097          	auipc	ra,0xfffff
    80000fe0:	4e6080e7          	jalr	1254(ra) # 800004c2 <printf>
    return mycpu()->proc;
    80000fe4:	00004917          	auipc	s2,0x4
    80000fe8:	20c90913          	addi	s2,s2,524 # 800051f0 <cpus>
        printf("%d\n", myproc()->pid);
    80000fec:	00002497          	auipc	s1,0x2
    80000ff0:	13c48493          	addi	s1,s1,316 # 80003128 <digits+0xf0>
    80000ff4:	8792                	mv	a5,tp
    80000ff6:	0007871b          	sext.w	a4,a5
    80000ffa:	00471793          	slli	a5,a4,0x4
    80000ffe:	8f99                	sub	a5,a5,a4
    80001000:	078e                	slli	a5,a5,0x3
    80001002:	97ca                	add	a5,a5,s2
    80001004:	639c                	ld	a5,0(a5)
    80001006:	538c                	lw	a1,32(a5)
    80001008:	8526                	mv	a0,s1
    8000100a:	fffff097          	auipc	ra,0xfffff
    8000100e:	4b8080e7          	jalr	1208(ra) # 800004c2 <printf>
        sleep_sec(1);
    80001012:	4505                	li	a0,1
    80001014:	00001097          	auipc	ra,0x1
    80001018:	a16080e7          	jalr	-1514(ra) # 80001a2a <sleep_sec>
    for (;;) {
    8000101c:	bfe1                	j	80000ff4 <forktest+0x46>
    8000101e:	862a                	mv	a2,a0
    80001020:	8792                	mv	a5,tp
    80001022:	0007871b          	sext.w	a4,a5
    80001026:	00471793          	slli	a5,a4,0x4
    8000102a:	8f99                	sub	a5,a5,a4
    8000102c:	078e                	slli	a5,a5,0x3
    8000102e:	00004717          	auipc	a4,0x4
    80001032:	1c270713          	addi	a4,a4,450 # 800051f0 <cpus>
    80001036:	97ba                	add	a5,a5,a4
        printf("pid=%d,child=%d\n", myproc()->pid, pid);
    80001038:	639c                	ld	a5,0(a5)
    8000103a:	538c                	lw	a1,32(a5)
    8000103c:	00002517          	auipc	a0,0x2
    80001040:	0ac50513          	addi	a0,a0,172 # 800030e8 <digits+0xb0>
    80001044:	fffff097          	auipc	ra,0xfffff
    80001048:	47e080e7          	jalr	1150(ra) # 800004c2 <printf>
        pid = wait(&status);
    8000104c:	fd840513          	addi	a0,s0,-40
    80001050:	00000097          	auipc	ra,0x0
    80001054:	ec6080e7          	jalr	-314(ra) # 80000f16 <wait>
    80001058:	84aa                	mv	s1,a0
        sleep_sec(1);
    8000105a:	4505                	li	a0,1
    8000105c:	00001097          	auipc	ra,0x1
    80001060:	9ce080e7          	jalr	-1586(ra) # 80001a2a <sleep_sec>
        printf("child=%d killed status=%d\n", pid, status);
    80001064:	fd842603          	lw	a2,-40(s0)
    80001068:	85a6                	mv	a1,s1
    8000106a:	00002517          	auipc	a0,0x2
    8000106e:	09650513          	addi	a0,a0,150 # 80003100 <digits+0xc8>
    80001072:	fffff097          	auipc	ra,0xfffff
    80001076:	450080e7          	jalr	1104(ra) # 800004c2 <printf>
}
    8000107a:	70a2                	ld	ra,40(sp)
    8000107c:	7402                	ld	s0,32(sp)
    8000107e:	64e2                	ld	s1,24(sp)
    80001080:	6942                	ld	s2,16(sp)
    80001082:	6145                	addi	sp,sp,48
    80001084:	8082                	ret

0000000080001086 <exit>:
// 若父进程已经exit, 则会由init进
// 程来完成父进程在exit时，会将其
// 子进程的parent设置为init进程
//
void exit(int status)
{
    80001086:	1141                	addi	sp,sp,-16
    80001088:	e406                	sd	ra,8(sp)
    8000108a:	e022                	sd	s0,0(sp)
    8000108c:	0800                	addi	s0,sp,16
    8000108e:	8792                	mv	a5,tp
    return mycpu()->proc;
    80001090:	0007871b          	sext.w	a4,a5
    80001094:	00471793          	slli	a5,a4,0x4
    80001098:	8f99                	sub	a5,a5,a4
    8000109a:	078e                	slli	a5,a5,0x3
    8000109c:	00004717          	auipc	a4,0x4
    800010a0:	15470713          	addi	a4,a4,340 # 800051f0 <cpus>
    800010a4:	97ba                	add	a5,a5,a4
    800010a6:	6394                	ld	a3,0(a5)
    struct proc *p, *cp;
    p = myproc();
    p->state = ZOMBIE;
    800010a8:	4791                	li	a5,4
    800010aa:	c29c                	sw	a5,0(a3)
    p->xstate = status;
    800010ac:	cec8                	sw	a0,28(a3)
    for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
        if (cp->parent == p) {
            cp->parent = initproc;
    800010ae:	00003597          	auipc	a1,0x3
    800010b2:	f6a5b583          	ld	a1,-150(a1) # 80004018 <initproc>
    for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    800010b6:	00045797          	auipc	a5,0x45
    800010ba:	2fa78793          	addi	a5,a5,762 # 800463b0 <proc_table>
    800010be:	00048617          	auipc	a2,0x48
    800010c2:	ef260613          	addi	a2,a2,-270 # 80048fb0 <proc_table+0x2c00>
    800010c6:	a031                	j	800010d2 <exit+0x4c>
            cp->parent = initproc;
    800010c8:	e78c                	sd	a1,8(a5)
    for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    800010ca:	0b078793          	addi	a5,a5,176
    800010ce:	00c78663          	beq	a5,a2,800010da <exit+0x54>
        if (cp->parent == p) {
    800010d2:	6798                	ld	a4,8(a5)
    800010d4:	fed71be3          	bne	a4,a3,800010ca <exit+0x44>
    800010d8:	bfc5                	j	800010c8 <exit+0x42>
        }
    }
    wakeup(p->parent);
    800010da:	6688                	ld	a0,8(a3)
    800010dc:	00000097          	auipc	ra,0x0
    800010e0:	d2e080e7          	jalr	-722(ra) # 80000e0a <wakeup>
    800010e4:	8712                	mv	a4,tp
    800010e6:	8792                	mv	a5,tp
    pswitch(&(myproc()->context), &(mycpu()->context));
    800010e8:	00004597          	auipc	a1,0x4
    800010ec:	10858593          	addi	a1,a1,264 # 800051f0 <cpus>
    800010f0:	0007869b          	sext.w	a3,a5
    800010f4:	00469793          	slli	a5,a3,0x4
    800010f8:	8f95                	sub	a5,a5,a3
    800010fa:	078e                	slli	a5,a5,0x3
    800010fc:	07a1                	addi	a5,a5,8
    return mycpu()->proc;
    800010fe:	0007069b          	sext.w	a3,a4
    80001102:	00469713          	slli	a4,a3,0x4
    80001106:	8f15                	sub	a4,a4,a3
    80001108:	070e                	slli	a4,a4,0x3
    8000110a:	972e                	add	a4,a4,a1
    pswitch(&(myproc()->context), &(mycpu()->context));
    8000110c:	6308                	ld	a0,0(a4)
    8000110e:	95be                	add	a1,a1,a5
    80001110:	03050513          	addi	a0,a0,48
    80001114:	00001097          	auipc	ra,0x1
    80001118:	840080e7          	jalr	-1984(ra) # 80001954 <pswitch>
}
    8000111c:	60a2                	ld	ra,8(sp)
    8000111e:	6402                	ld	s0,0(sp)
    80001120:	0141                	addi	sp,sp,16
    80001122:	8082                	ret

0000000080001124 <hello>:

void hello()
{
    80001124:	1141                	addi	sp,sp,-16
    80001126:	e406                	sd	ra,8(sp)
    80001128:	e022                	sd	s0,0(sp)
    8000112a:	0800                	addi	s0,sp,16
    puts("Hello, world!\n\t\tfrom startOS with osh");
    8000112c:	00002517          	auipc	a0,0x2
    80001130:	00450513          	addi	a0,a0,4 # 80003130 <digits+0xf8>
    80001134:	fffff097          	auipc	ra,0xfffff
    80001138:	3c4080e7          	jalr	964(ra) # 800004f8 <puts>
    exit(0);
    8000113c:	4501                	li	a0,0
    8000113e:	00000097          	auipc	ra,0x0
    80001142:	f48080e7          	jalr	-184(ra) # 80001086 <exit>
}
    80001146:	60a2                	ld	ra,8(sp)
    80001148:	6402                	ld	s0,0(sp)
    8000114a:	0141                	addi	sp,sp,16
    8000114c:	8082                	ret

000000008000114e <cowsay>:
void cowsay(){
    8000114e:	1141                	addi	sp,sp,-16
    80001150:	e406                	sd	ra,8(sp)
    80001152:	e022                	sd	s0,0(sp)
    80001154:	0800                	addi	s0,sp,16
    puts("    ____________");
    80001156:	00002517          	auipc	a0,0x2
    8000115a:	00250513          	addi	a0,a0,2 # 80003158 <digits+0x120>
    8000115e:	fffff097          	auipc	ra,0xfffff
    80001162:	39a080e7          	jalr	922(ra) # 800004f8 <puts>
    puts("    < hi, there >");
    80001166:	00002517          	auipc	a0,0x2
    8000116a:	00a50513          	addi	a0,a0,10 # 80003170 <digits+0x138>
    8000116e:	fffff097          	auipc	ra,0xfffff
    80001172:	38a080e7          	jalr	906(ra) # 800004f8 <puts>
    puts("    ------------");
    80001176:	00002517          	auipc	a0,0x2
    8000117a:	01250513          	addi	a0,a0,18 # 80003188 <digits+0x150>
    8000117e:	fffff097          	auipc	ra,0xfffff
    80001182:	37a080e7          	jalr	890(ra) # 800004f8 <puts>
    puts("         \\   ^__^");
    80001186:	00002517          	auipc	a0,0x2
    8000118a:	01a50513          	addi	a0,a0,26 # 800031a0 <digits+0x168>
    8000118e:	fffff097          	auipc	ra,0xfffff
    80001192:	36a080e7          	jalr	874(ra) # 800004f8 <puts>
    puts("          \\  (oo)\\_______");
    80001196:	00002517          	auipc	a0,0x2
    8000119a:	02250513          	addi	a0,a0,34 # 800031b8 <digits+0x180>
    8000119e:	fffff097          	auipc	ra,0xfffff
    800011a2:	35a080e7          	jalr	858(ra) # 800004f8 <puts>
    puts("             (__)\\       )\\/\\");
    800011a6:	00002517          	auipc	a0,0x2
    800011aa:	03250513          	addi	a0,a0,50 # 800031d8 <digits+0x1a0>
    800011ae:	fffff097          	auipc	ra,0xfffff
    800011b2:	34a080e7          	jalr	842(ra) # 800004f8 <puts>
    puts("                 ||----w |");
    800011b6:	00002517          	auipc	a0,0x2
    800011ba:	04250513          	addi	a0,a0,66 # 800031f8 <digits+0x1c0>
    800011be:	fffff097          	auipc	ra,0xfffff
    800011c2:	33a080e7          	jalr	826(ra) # 800004f8 <puts>
    puts("                 ||     ||");
    800011c6:	00002517          	auipc	a0,0x2
    800011ca:	05250513          	addi	a0,a0,82 # 80003218 <digits+0x1e0>
    800011ce:	fffff097          	auipc	ra,0xfffff
    800011d2:	32a080e7          	jalr	810(ra) # 800004f8 <puts>
    exit(0);
    800011d6:	4501                	li	a0,0
    800011d8:	00000097          	auipc	ra,0x0
    800011dc:	eae080e7          	jalr	-338(ra) # 80001086 <exit>
}
    800011e0:	60a2                	ld	ra,8(sp)
    800011e2:	6402                	ld	s0,0(sp)
    800011e4:	0141                	addi	sp,sp,16
    800011e6:	8082                	ret

00000000800011e8 <mew>:
void mew(){
    800011e8:	1141                	addi	sp,sp,-16
    800011ea:	e406                	sd	ra,8(sp)
    800011ec:	e022                	sd	s0,0(sp)
    800011ee:	0800                	addi	s0,sp,16
    puts("          ＿＿");
    800011f0:	00002517          	auipc	a0,0x2
    800011f4:	04850513          	addi	a0,a0,72 # 80003238 <digits+0x200>
    800011f8:	fffff097          	auipc	ra,0xfffff
    800011fc:	300080e7          	jalr	768(ra) # 800004f8 <puts>
    puts("　　　／＞　　フ");
    80001200:	00002517          	auipc	a0,0x2
    80001204:	05050513          	addi	a0,a0,80 # 80003250 <digits+0x218>
    80001208:	fffff097          	auipc	ra,0xfffff
    8000120c:	2f0080e7          	jalr	752(ra) # 800004f8 <puts>
    puts("　　　|   _　 _ |");
    80001210:	00002517          	auipc	a0,0x2
    80001214:	06050513          	addi	a0,a0,96 # 80003270 <digits+0x238>
    80001218:	fffff097          	auipc	ra,0xfffff
    8000121c:	2e0080e7          	jalr	736(ra) # 800004f8 <puts>
    puts("　　／`  ミ＿xノ");
    80001220:	00002517          	auipc	a0,0x2
    80001224:	06850513          	addi	a0,a0,104 # 80003288 <digits+0x250>
    80001228:	fffff097          	auipc	ra,0xfffff
    8000122c:	2d0080e7          	jalr	720(ra) # 800004f8 <puts>
    puts(" 　 /　　　 　 |");
    80001230:	00002517          	auipc	a0,0x2
    80001234:	07050513          	addi	a0,a0,112 # 800032a0 <digits+0x268>
    80001238:	fffff097          	auipc	ra,0xfffff
    8000123c:	2c0080e7          	jalr	704(ra) # 800004f8 <puts>
    puts("　 /　 ヽ　　 ﾉ");
    80001240:	00002517          	auipc	a0,0x2
    80001244:	07850513          	addi	a0,a0,120 # 800032b8 <digits+0x280>
    80001248:	fffff097          	auipc	ra,0xfffff
    8000124c:	2b0080e7          	jalr	688(ra) # 800004f8 <puts>
    exit(0);
    80001250:	4501                	li	a0,0
    80001252:	00000097          	auipc	ra,0x0
    80001256:	e34080e7          	jalr	-460(ra) # 80001086 <exit>
    8000125a:	60a2                	ld	ra,8(sp)
    8000125c:	6402                	ld	s0,0(sp)
    8000125e:	0141                	addi	sp,sp,16
    80001260:	8082                	ret

0000000080001262 <timertest>:
{  //时间片测试
    80001262:	7139                	addi	sp,sp,-64
    80001264:	fc06                	sd	ra,56(sp)
    80001266:	f822                	sd	s0,48(sp)
    80001268:	f426                	sd	s1,40(sp)
    8000126a:	f04a                	sd	s2,32(sp)
    8000126c:	ec4e                	sd	s3,24(sp)
    8000126e:	e852                	sd	s4,16(sp)
    80001270:	e456                	sd	s5,8(sp)
    80001272:	0080                	addi	s0,sp,64
    80001274:	4491                	li	s1,4
    80001276:	4a15                	li	s4,5
    return mycpu()->proc;
    80001278:	00004997          	auipc	s3,0x4
    8000127c:	f7898993          	addi	s3,s3,-136 # 800051f0 <cpus>
                printf("I'm process %d\n", myproc()->pid);
    80001280:	00002917          	auipc	s2,0x2
    80001284:	05090913          	addi	s2,s2,80 # 800032d0 <digits+0x298>
    80001288:	a801                	j	80001298 <timertest+0x36>
            exit(-1);
    8000128a:	557d                	li	a0,-1
    8000128c:	00000097          	auipc	ra,0x0
    80001290:	dfa080e7          	jalr	-518(ra) # 80001086 <exit>
    for (int i = 0; i < 4; i++) {
    80001294:	34fd                	addiw	s1,s1,-1
    80001296:	c4b1                	beqz	s1,800012e2 <timertest+0x80>
        pid = fork();
    80001298:	00000097          	auipc	ra,0x0
    8000129c:	726080e7          	jalr	1830(ra) # 800019be <fork>
        if (pid < 0) {
    800012a0:	fe0545e3          	bltz	a0,8000128a <timertest+0x28>
        } else if (pid == 0) {
    800012a4:	f965                	bnez	a0,80001294 <timertest+0x32>
    800012a6:	8ad2                	mv	s5,s4
    800012a8:	8792                	mv	a5,tp
    800012aa:	0007871b          	sext.w	a4,a5
    800012ae:	00471793          	slli	a5,a4,0x4
    800012b2:	8f99                	sub	a5,a5,a4
    800012b4:	078e                	slli	a5,a5,0x3
    800012b6:	97ce                	add	a5,a5,s3
                printf("I'm process %d\n", myproc()->pid);
    800012b8:	639c                	ld	a5,0(a5)
    800012ba:	538c                	lw	a1,32(a5)
    800012bc:	854a                	mv	a0,s2
    800012be:	fffff097          	auipc	ra,0xfffff
    800012c2:	204080e7          	jalr	516(ra) # 800004c2 <printf>
                sleep_sec(1);
    800012c6:	4505                	li	a0,1
    800012c8:	00000097          	auipc	ra,0x0
    800012cc:	762080e7          	jalr	1890(ra) # 80001a2a <sleep_sec>
            for (int j = 0; j < 5; j++) {
    800012d0:	3afd                	addiw	s5,s5,-1
    800012d2:	fc0a9be3          	bnez	s5,800012a8 <timertest+0x46>
            exit(0);
    800012d6:	4501                	li	a0,0
    800012d8:	00000097          	auipc	ra,0x0
    800012dc:	dae080e7          	jalr	-594(ra) # 80001086 <exit>
    800012e0:	bf55                	j	80001294 <timertest+0x32>
    wait(0);
    800012e2:	4501                	li	a0,0
    800012e4:	00000097          	auipc	ra,0x0
    800012e8:	c32080e7          	jalr	-974(ra) # 80000f16 <wait>
}
    800012ec:	70e2                	ld	ra,56(sp)
    800012ee:	7442                	ld	s0,48(sp)
    800012f0:	74a2                	ld	s1,40(sp)
    800012f2:	7902                	ld	s2,32(sp)
    800012f4:	69e2                	ld	s3,24(sp)
    800012f6:	6a42                	ld	s4,16(sp)
    800012f8:	6aa2                	ld	s5,8(sp)
    800012fa:	6121                	addi	sp,sp,64
    800012fc:	8082                	ret

00000000800012fe <print_hello>:
{
    800012fe:	1141                	addi	sp,sp,-16
    80001300:	e406                	sd	ra,8(sp)
    80001302:	e022                	sd	s0,0(sp)
    80001304:	0800                	addi	s0,sp,16
    printf("hello world!\n");
    80001306:	00002517          	auipc	a0,0x2
    8000130a:	fda50513          	addi	a0,a0,-38 # 800032e0 <digits+0x2a8>
    8000130e:	fffff097          	auipc	ra,0xfffff
    80001312:	1b4080e7          	jalr	436(ra) # 800004c2 <printf>
    exit(0);
    80001316:	4501                	li	a0,0
    80001318:	00000097          	auipc	ra,0x0
    8000131c:	d6e080e7          	jalr	-658(ra) # 80001086 <exit>
}
    80001320:	60a2                	ld	ra,8(sp)
    80001322:	6402                	ld	s0,0(sp)
    80001324:	0141                	addi	sp,sp,16
    80001326:	8082                	ret

0000000080001328 <runtest>:

void runtest(void f(void), char* s)
{
    80001328:	1101                	addi	sp,sp,-32
    8000132a:	ec06                	sd	ra,24(sp)
    8000132c:	e822                	sd	s0,16(sp)
    8000132e:	e426                	sd	s1,8(sp)
    80001330:	1000                	addi	s0,sp,32
    80001332:	84aa                	mv	s1,a0
    printf("\ntest %s: \n", s);
    80001334:	00002517          	auipc	a0,0x2
    80001338:	fbc50513          	addi	a0,a0,-68 # 800032f0 <digits+0x2b8>
    8000133c:	fffff097          	auipc	ra,0xfffff
    80001340:	186080e7          	jalr	390(ra) # 800004c2 <printf>
    int pid = fork();
    80001344:	00000097          	auipc	ra,0x0
    80001348:	67a080e7          	jalr	1658(ra) # 800019be <fork>
    if (pid < 0) {
    8000134c:	02054363          	bltz	a0,80001372 <runtest+0x4a>
        printf("fork error\n");
        exit(-1);
    } else if (pid == 0) {
    80001350:	e519                	bnez	a0,8000135e <runtest+0x36>
        f();
    80001352:	9482                	jalr	s1
        exit(0);
    80001354:	4501                	li	a0,0
    80001356:	00000097          	auipc	ra,0x0
    8000135a:	d30080e7          	jalr	-720(ra) # 80001086 <exit>
    }
    wait(0);
    8000135e:	4501                	li	a0,0
    80001360:	00000097          	auipc	ra,0x0
    80001364:	bb6080e7          	jalr	-1098(ra) # 80000f16 <wait>
}
    80001368:	60e2                	ld	ra,24(sp)
    8000136a:	6442                	ld	s0,16(sp)
    8000136c:	64a2                	ld	s1,8(sp)
    8000136e:	6105                	addi	sp,sp,32
    80001370:	8082                	ret
        printf("fork error\n");
    80001372:	00002517          	auipc	a0,0x2
    80001376:	f8e50513          	addi	a0,a0,-114 # 80003300 <digits+0x2c8>
    8000137a:	fffff097          	auipc	ra,0xfffff
    8000137e:	148080e7          	jalr	328(ra) # 800004c2 <printf>
        exit(-1);
    80001382:	557d                	li	a0,-1
    80001384:	00000097          	auipc	ra,0x0
    80001388:	d02080e7          	jalr	-766(ra) # 80001086 <exit>
    8000138c:	bfc9                	j	8000135e <runtest+0x36>

000000008000138e <usertests>:
    { fstest,  "fstest" },
    { 0, 0 },
};

void usertests()
{
    8000138e:	1101                	addi	sp,sp,-32
    80001390:	ec06                	sd	ra,24(sp)
    80001392:	e822                	sd	s0,16(sp)
    80001394:	e426                	sd	s1,8(sp)
    80001396:	1000                	addi	s0,sp,32
    struct test* t;
    int i = 0;
    printf("usertest:\n");
    80001398:	00002517          	auipc	a0,0x2
    8000139c:	f7850513          	addi	a0,a0,-136 # 80003310 <digits+0x2d8>
    800013a0:	fffff097          	auipc	ra,0xfffff
    800013a4:	122080e7          	jalr	290(ra) # 800004c2 <printf>
    800013a8:	00002497          	auipc	s1,0x2
    800013ac:	27848493          	addi	s1,s1,632 # 80003620 <tests>
    800013b0:	a039                	j	800013be <usertests+0x30>
    while (1) {
        t = &tests[i++];
        if (t->f == 0 && t->s == 0) {
            break;
        }
        runtest(t->f, t->s);
    800013b2:	678c                	ld	a1,8(a5)
    800013b4:	00000097          	auipc	ra,0x0
    800013b8:	f74080e7          	jalr	-140(ra) # 80001328 <runtest>
    while (1) {
    800013bc:	04c1                	addi	s1,s1,16
        if (t->f == 0 && t->s == 0) {
    800013be:	87a6                	mv	a5,s1
    800013c0:	6088                	ld	a0,0(s1)
    800013c2:	f965                	bnez	a0,800013b2 <usertests+0x24>
    800013c4:	6498                	ld	a4,8(s1)
    800013c6:	f775                	bnez	a4,800013b2 <usertests+0x24>
    }
    printf("\nusertest finish\n\n");
    800013c8:	00002517          	auipc	a0,0x2
    800013cc:	f5850513          	addi	a0,a0,-168 # 80003320 <digits+0x2e8>
    800013d0:	fffff097          	auipc	ra,0xfffff
    800013d4:	0f2080e7          	jalr	242(ra) # 800004c2 <printf>
    exit(0);
    800013d8:	4501                	li	a0,0
    800013da:	00000097          	auipc	ra,0x0
    800013de:	cac080e7          	jalr	-852(ra) # 80001086 <exit>
    800013e2:	60e2                	ld	ra,24(sp)
    800013e4:	6442                	ld	s0,16(sp)
    800013e6:	64a2                	ld	s1,8(sp)
    800013e8:	6105                	addi	sp,sp,32
    800013ea:	8082                	ret

00000000800013ec <help>:
#include "user/usertests.c"

void showHistory();

void help()
{
    800013ec:	1141                	addi	sp,sp,-16
    800013ee:	e406                	sd	ra,8(sp)
    800013f0:	e022                	sd	s0,0(sp)
    800013f2:	0800                	addi	s0,sp,16
    puts("All available commmands:");
    800013f4:	00002517          	auipc	a0,0x2
    800013f8:	f4450513          	addi	a0,a0,-188 # 80003338 <digits+0x300>
    800013fc:	fffff097          	auipc	ra,0xfffff
    80001400:	0fc080e7          	jalr	252(ra) # 800004f8 <puts>
    puts("help\tshow this helping message");
    80001404:	00002517          	auipc	a0,0x2
    80001408:	f5450513          	addi	a0,a0,-172 # 80003358 <digits+0x320>
    8000140c:	fffff097          	auipc	ra,0xfffff
    80001410:	0ec080e7          	jalr	236(ra) # 800004f8 <puts>
    puts("hello\tprint test hello world message");
    80001414:	00002517          	auipc	a0,0x2
    80001418:	f6450513          	addi	a0,a0,-156 # 80003378 <digits+0x340>
    8000141c:	fffff097          	auipc	ra,0xfffff
    80001420:	0dc080e7          	jalr	220(ra) # 800004f8 <puts>
    puts("history\tshow recent commands you input");
    80001424:	00002517          	auipc	a0,0x2
    80001428:	f7c50513          	addi	a0,a0,-132 # 800033a0 <digits+0x368>
    8000142c:	fffff097          	auipc	ra,0xfffff
    80001430:	0cc080e7          	jalr	204(ra) # 800004f8 <puts>
    puts("usertests\texec test function");
    80001434:	00002517          	auipc	a0,0x2
    80001438:	f9450513          	addi	a0,a0,-108 # 800033c8 <digits+0x390>
    8000143c:	fffff097          	auipc	ra,0xfffff
    80001440:	0bc080e7          	jalr	188(ra) # 800004f8 <puts>
    puts("cowsay\tcowsay");
    80001444:	00002517          	auipc	a0,0x2
    80001448:	fa450513          	addi	a0,a0,-92 # 800033e8 <digits+0x3b0>
    8000144c:	fffff097          	auipc	ra,0xfffff
    80001450:	0ac080e7          	jalr	172(ra) # 800004f8 <puts>
    puts("mew\tmew mew");
    80001454:	00002517          	auipc	a0,0x2
    80001458:	fa450513          	addi	a0,a0,-92 # 800033f8 <digits+0x3c0>
    8000145c:	fffff097          	auipc	ra,0xfffff
    80001460:	09c080e7          	jalr	156(ra) # 800004f8 <puts>
    exit(0);
    80001464:	4501                	li	a0,0
    80001466:	00000097          	auipc	ra,0x0
    8000146a:	c20080e7          	jalr	-992(ra) # 80001086 <exit>
}
    8000146e:	60a2                	ld	ra,8(sp)
    80001470:	6402                	ld	s0,0(sp)
    80001472:	0141                	addi	sp,sp,16
    80001474:	8082                	ret

0000000080001476 <showHistory>:
    }
    exit(0);
}

void showHistory()
{
    80001476:	715d                	addi	sp,sp,-80
    80001478:	e486                	sd	ra,72(sp)
    8000147a:	e0a2                	sd	s0,64(sp)
    8000147c:	fc26                	sd	s1,56(sp)
    8000147e:	f84a                	sd	s2,48(sp)
    80001480:	f44e                	sd	s3,40(sp)
    80001482:	f052                	sd	s4,32(sp)
    80001484:	ec56                	sd	s5,24(sp)
    80001486:	e85a                	sd	s6,16(sp)
    80001488:	e45e                	sd	s7,8(sp)
    8000148a:	0880                	addi	s0,sp,80
    int startP=h.currentP;
    for (int k = MAX_HISTORY_NUM, i = (MAX_HISTORY_NUM + startP) % MAX_HISTORY_NUM; k > 0; i++, k--) {
    8000148c:	00004497          	auipc	s1,0x4
    80001490:	f1c4a483          	lw	s1,-228(s1) # 800053a8 <h+0x140>
    80001494:	2495                	addiw	s1,s1,5
    80001496:	4795                	li	a5,5
    80001498:	02f4e4bb          	remw	s1,s1,a5
    8000149c:	4915                	li	s2,5
        if (i >= MAX_HISTORY_NUM)
            i = i % MAX_HISTORY_NUM;
        if (h.cmdlist[i][0] == '\0') 
    8000149e:	00004997          	auipc	s3,0x4
    800014a2:	d5298993          	addi	s3,s3,-686 # 800051f0 <cpus>
            continue;
        else {
            printf("#%d\t%s\n", k, h.cmdlist[i]);
    800014a6:	00004b97          	auipc	s7,0x4
    800014aa:	dc2b8b93          	addi	s7,s7,-574 # 80005268 <h>
    800014ae:	00002b17          	auipc	s6,0x2
    800014b2:	f5ab0b13          	addi	s6,s6,-166 # 80003408 <digits+0x3d0>
        if (i >= MAX_HISTORY_NUM)
    800014b6:	4a11                	li	s4,4
            i = i % MAX_HISTORY_NUM;
    800014b8:	4a95                	li	s5,5
    800014ba:	a821                	j	800014d2 <showHistory+0x5c>
    for (int k = MAX_HISTORY_NUM, i = (MAX_HISTORY_NUM + startP) % MAX_HISTORY_NUM; k > 0; i++, k--) {
    800014bc:	0014879b          	addiw	a5,s1,1
    800014c0:	0007849b          	sext.w	s1,a5
    800014c4:	397d                	addiw	s2,s2,-1
    800014c6:	02090763          	beqz	s2,800014f4 <showHistory+0x7e>
        if (i >= MAX_HISTORY_NUM)
    800014ca:	009a5463          	bge	s4,s1,800014d2 <showHistory+0x5c>
            i = i % MAX_HISTORY_NUM;
    800014ce:	0357e4bb          	remw	s1,a5,s5
    800014d2:	0009059b          	sext.w	a1,s2
        if (h.cmdlist[i][0] == '\0') 
    800014d6:	00649793          	slli	a5,s1,0x6
    800014da:	97ce                	add	a5,a5,s3
    800014dc:	0787c783          	lbu	a5,120(a5)
    800014e0:	dff1                	beqz	a5,800014bc <showHistory+0x46>
            printf("#%d\t%s\n", k, h.cmdlist[i]);
    800014e2:	00649613          	slli	a2,s1,0x6
    800014e6:	965e                	add	a2,a2,s7
    800014e8:	855a                	mv	a0,s6
    800014ea:	fffff097          	auipc	ra,0xfffff
    800014ee:	fd8080e7          	jalr	-40(ra) # 800004c2 <printf>
    800014f2:	b7e9                	j	800014bc <showHistory+0x46>
        }
    }
    exit(0);
    800014f4:	4501                	li	a0,0
    800014f6:	00000097          	auipc	ra,0x0
    800014fa:	b90080e7          	jalr	-1136(ra) # 80001086 <exit>
}
    800014fe:	60a6                	ld	ra,72(sp)
    80001500:	6406                	ld	s0,64(sp)
    80001502:	74e2                	ld	s1,56(sp)
    80001504:	7942                	ld	s2,48(sp)
    80001506:	79a2                	ld	s3,40(sp)
    80001508:	7a02                	ld	s4,32(sp)
    8000150a:	6ae2                	ld	s5,24(sp)
    8000150c:	6b42                	ld	s6,16(sp)
    8000150e:	6ba2                	ld	s7,8(sp)
    80001510:	6161                	addi	sp,sp,80
    80001512:	8082                	ret

0000000080001514 <exec>:

void execra(struct context*, struct context*, uint64);

// 使进程执行其他函数
void exec(uint64 fn)
{
    80001514:	7179                	addi	sp,sp,-48
    80001516:	f406                	sd	ra,40(sp)
    80001518:	f022                	sd	s0,32(sp)
    8000151a:	ec26                	sd	s1,24(sp)
    8000151c:	e84a                	sd	s2,16(sp)
    8000151e:	e44e                	sd	s3,8(sp)
    80001520:	e052                	sd	s4,0(sp)
    80001522:	1800                	addi	s0,sp,48
    80001524:	84aa                	mv	s1,a0
    80001526:	8792                	mv	a5,tp
    return mycpu()->proc;
    80001528:	00004917          	auipc	s2,0x4
    8000152c:	cc890913          	addi	s2,s2,-824 # 800051f0 <cpus>
    80001530:	0007871b          	sext.w	a4,a5
    80001534:	00471793          	slli	a5,a4,0x4
    80001538:	8f99                	sub	a5,a5,a4
    8000153a:	078e                	slli	a5,a5,0x3
    8000153c:	97ca                	add	a5,a5,s2
    8000153e:	0007b983          	ld	s3,0(a5)
    struct proc* p = myproc();
    memset(&p->context, 0, sizeof(struct context));
    80001542:	03098a13          	addi	s4,s3,48
    80001546:	07000613          	li	a2,112
    8000154a:	4581                	li	a1,0
    8000154c:	8552                	mv	a0,s4
    8000154e:	00000097          	auipc	ra,0x0
    80001552:	384080e7          	jalr	900(ra) # 800018d2 <memset>
    p->state = RUNNABLE;
    80001556:	4789                	li	a5,2
    80001558:	00f9a023          	sw	a5,0(s3)
    p->context.sp = p->kstack + PGSIZE;
    8000155c:	0289b783          	ld	a5,40(s3)
    80001560:	6705                	lui	a4,0x1
    80001562:	97ba                	add	a5,a5,a4
    80001564:	02f9bc23          	sd	a5,56(s3)
    80001568:	8592                	mv	a1,tp
    execra(&p->context, &mycpu()->context, fn);
    8000156a:	0005879b          	sext.w	a5,a1
    8000156e:	00479593          	slli	a1,a5,0x4
    80001572:	8d9d                	sub	a1,a1,a5
    80001574:	058e                	slli	a1,a1,0x3
    80001576:	05a1                	addi	a1,a1,8
    80001578:	8626                	mv	a2,s1
    8000157a:	95ca                	add	a1,a1,s2
    8000157c:	8552                	mv	a0,s4
    8000157e:	00000097          	auipc	ra,0x0
    80001582:	552080e7          	jalr	1362(ra) # 80001ad0 <execra>
    // 不会返回
    panic("exec");
    80001586:	00002517          	auipc	a0,0x2
    8000158a:	e8a50513          	addi	a0,a0,-374 # 80003410 <digits+0x3d8>
    8000158e:	fffff097          	auipc	ra,0xfffff
    80001592:	140080e7          	jalr	320(ra) # 800006ce <panic>
}
    80001596:	70a2                	ld	ra,40(sp)
    80001598:	7402                	ld	s0,32(sp)
    8000159a:	64e2                	ld	s1,24(sp)
    8000159c:	6942                	ld	s2,16(sp)
    8000159e:	69a2                	ld	s3,8(sp)
    800015a0:	6a02                	ld	s4,0(sp)
    800015a2:	6145                	addi	sp,sp,48
    800015a4:	8082                	ret

00000000800015a6 <exectest>:
{  //exec测试
    800015a6:	1141                	addi	sp,sp,-16
    800015a8:	e406                	sd	ra,8(sp)
    800015aa:	e022                	sd	s0,0(sp)
    800015ac:	0800                	addi	s0,sp,16
    if (fork() > 0) {
    800015ae:	00000097          	auipc	ra,0x0
    800015b2:	410080e7          	jalr	1040(ra) # 800019be <fork>
    800015b6:	02a05363          	blez	a0,800015dc <exectest+0x36>
        wait(0);
    800015ba:	4501                	li	a0,0
    800015bc:	00000097          	auipc	ra,0x0
    800015c0:	95a080e7          	jalr	-1702(ra) # 80000f16 <wait>
        printf("child exit\n");
    800015c4:	00002517          	auipc	a0,0x2
    800015c8:	e5450513          	addi	a0,a0,-428 # 80003418 <digits+0x3e0>
    800015cc:	fffff097          	auipc	ra,0xfffff
    800015d0:	ef6080e7          	jalr	-266(ra) # 800004c2 <printf>
}
    800015d4:	60a2                	ld	ra,8(sp)
    800015d6:	6402                	ld	s0,0(sp)
    800015d8:	0141                	addi	sp,sp,16
    800015da:	8082                	ret
        exec((uint64)print_hello);
    800015dc:	00000517          	auipc	a0,0x0
    800015e0:	d2250513          	addi	a0,a0,-734 # 800012fe <print_hello>
    800015e4:	00000097          	auipc	ra,0x0
    800015e8:	f30080e7          	jalr	-208(ra) # 80001514 <exec>
}
    800015ec:	b7e5                	j	800015d4 <exectest+0x2e>

00000000800015ee <run>:

void run(uint64 fn)
{
    800015ee:	1101                	addi	sp,sp,-32
    800015f0:	ec06                	sd	ra,24(sp)
    800015f2:	e822                	sd	s0,16(sp)
    800015f4:	e426                	sd	s1,8(sp)
    800015f6:	1000                	addi	s0,sp,32
    800015f8:	84aa                	mv	s1,a0
    if (fork() > 0) {
    800015fa:	00000097          	auipc	ra,0x0
    800015fe:	3c4080e7          	jalr	964(ra) # 800019be <fork>
    80001602:	00a05c63          	blez	a0,8000161a <run+0x2c>
        wait(0);
    80001606:	4501                	li	a0,0
    80001608:	00000097          	auipc	ra,0x0
    8000160c:	90e080e7          	jalr	-1778(ra) # 80000f16 <wait>
    } else {
        exec(fn);
    }
}
    80001610:	60e2                	ld	ra,24(sp)
    80001612:	6442                	ld	s0,16(sp)
    80001614:	64a2                	ld	s1,8(sp)
    80001616:	6105                	addi	sp,sp,32
    80001618:	8082                	ret
        exec(fn);
    8000161a:	8526                	mv	a0,s1
    8000161c:	00000097          	auipc	ra,0x0
    80001620:	ef8080e7          	jalr	-264(ra) # 80001514 <exec>
}
    80001624:	b7f5                	j	80001610 <run+0x22>

0000000080001626 <runcmd>:
void runcmd(char* cmdstr)
{
    80001626:	1101                	addi	sp,sp,-32
    80001628:	ec06                	sd	ra,24(sp)
    8000162a:	e822                	sd	s0,16(sp)
    8000162c:	e426                	sd	s1,8(sp)
    8000162e:	1000                	addi	s0,sp,32
    80001630:	84aa                	mv	s1,a0
    if (strlen(cmdstr) == 0)
    80001632:	fffff097          	auipc	ra,0xfffff
    80001636:	506080e7          	jalr	1286(ra) # 80000b38 <strlen>
    8000163a:	0005079b          	sext.w	a5,a0
    8000163e:	e791                	bnez	a5,8000164a <runcmd+0x24>
        run((uint64)mew);
    else {
        puts("■■No such command.");
        return;
    }
}
    80001640:	60e2                	ld	ra,24(sp)
    80001642:	6442                	ld	s0,16(sp)
    80001644:	64a2                	ld	s1,8(sp)
    80001646:	6105                	addi	sp,sp,32
    80001648:	8082                	ret
    else if (strcmp(cmdstr, "hello") == 0)
    8000164a:	00002597          	auipc	a1,0x2
    8000164e:	dde58593          	addi	a1,a1,-546 # 80003428 <digits+0x3f0>
    80001652:	8526                	mv	a0,s1
    80001654:	fffff097          	auipc	ra,0xfffff
    80001658:	4b8080e7          	jalr	1208(ra) # 80000b0c <strcmp>
    8000165c:	e911                	bnez	a0,80001670 <runcmd+0x4a>
        run((uint64)hello);
    8000165e:	00000517          	auipc	a0,0x0
    80001662:	ac650513          	addi	a0,a0,-1338 # 80001124 <hello>
    80001666:	00000097          	auipc	ra,0x0
    8000166a:	f88080e7          	jalr	-120(ra) # 800015ee <run>
    8000166e:	bfc9                	j	80001640 <runcmd+0x1a>
    else if (strcmp(cmdstr, "help") == 0)
    80001670:	00002597          	auipc	a1,0x2
    80001674:	dc058593          	addi	a1,a1,-576 # 80003430 <digits+0x3f8>
    80001678:	8526                	mv	a0,s1
    8000167a:	fffff097          	auipc	ra,0xfffff
    8000167e:	492080e7          	jalr	1170(ra) # 80000b0c <strcmp>
    80001682:	e911                	bnez	a0,80001696 <runcmd+0x70>
        run((uint64)help);
    80001684:	00000517          	auipc	a0,0x0
    80001688:	d6850513          	addi	a0,a0,-664 # 800013ec <help>
    8000168c:	00000097          	auipc	ra,0x0
    80001690:	f62080e7          	jalr	-158(ra) # 800015ee <run>
    80001694:	b775                	j	80001640 <runcmd+0x1a>
    else if (strcmp(cmdstr, "history") == 0)
    80001696:	00002597          	auipc	a1,0x2
    8000169a:	da258593          	addi	a1,a1,-606 # 80003438 <digits+0x400>
    8000169e:	8526                	mv	a0,s1
    800016a0:	fffff097          	auipc	ra,0xfffff
    800016a4:	46c080e7          	jalr	1132(ra) # 80000b0c <strcmp>
    800016a8:	e911                	bnez	a0,800016bc <runcmd+0x96>
        run((uint64)showHistory);
    800016aa:	00000517          	auipc	a0,0x0
    800016ae:	dcc50513          	addi	a0,a0,-564 # 80001476 <showHistory>
    800016b2:	00000097          	auipc	ra,0x0
    800016b6:	f3c080e7          	jalr	-196(ra) # 800015ee <run>
    800016ba:	b759                	j	80001640 <runcmd+0x1a>
    else if (strcmp(cmdstr, "usertests") == 0)
    800016bc:	00002597          	auipc	a1,0x2
    800016c0:	d8458593          	addi	a1,a1,-636 # 80003440 <digits+0x408>
    800016c4:	8526                	mv	a0,s1
    800016c6:	fffff097          	auipc	ra,0xfffff
    800016ca:	446080e7          	jalr	1094(ra) # 80000b0c <strcmp>
    800016ce:	e911                	bnez	a0,800016e2 <runcmd+0xbc>
        run((uint64)usertests);
    800016d0:	00000517          	auipc	a0,0x0
    800016d4:	cbe50513          	addi	a0,a0,-834 # 8000138e <usertests>
    800016d8:	00000097          	auipc	ra,0x0
    800016dc:	f16080e7          	jalr	-234(ra) # 800015ee <run>
    800016e0:	b785                	j	80001640 <runcmd+0x1a>
    else if(strcmp(cmdstr, "cowsay") == 0)
    800016e2:	00002597          	auipc	a1,0x2
    800016e6:	d6e58593          	addi	a1,a1,-658 # 80003450 <digits+0x418>
    800016ea:	8526                	mv	a0,s1
    800016ec:	fffff097          	auipc	ra,0xfffff
    800016f0:	420080e7          	jalr	1056(ra) # 80000b0c <strcmp>
    800016f4:	e911                	bnez	a0,80001708 <runcmd+0xe2>
        run((uint64)cowsay);
    800016f6:	00000517          	auipc	a0,0x0
    800016fa:	a5850513          	addi	a0,a0,-1448 # 8000114e <cowsay>
    800016fe:	00000097          	auipc	ra,0x0
    80001702:	ef0080e7          	jalr	-272(ra) # 800015ee <run>
    80001706:	bf2d                	j	80001640 <runcmd+0x1a>
    else if(strcmp(cmdstr, "mew") == 0)
    80001708:	00002597          	auipc	a1,0x2
    8000170c:	cf858593          	addi	a1,a1,-776 # 80003400 <digits+0x3c8>
    80001710:	8526                	mv	a0,s1
    80001712:	fffff097          	auipc	ra,0xfffff
    80001716:	3fa080e7          	jalr	1018(ra) # 80000b0c <strcmp>
    8000171a:	e911                	bnez	a0,8000172e <runcmd+0x108>
        run((uint64)mew);
    8000171c:	00000517          	auipc	a0,0x0
    80001720:	acc50513          	addi	a0,a0,-1332 # 800011e8 <mew>
    80001724:	00000097          	auipc	ra,0x0
    80001728:	eca080e7          	jalr	-310(ra) # 800015ee <run>
    8000172c:	bf11                	j	80001640 <runcmd+0x1a>
        puts("■■No such command.");
    8000172e:	00002517          	auipc	a0,0x2
    80001732:	d2a50513          	addi	a0,a0,-726 # 80003458 <digits+0x420>
    80001736:	fffff097          	auipc	ra,0xfffff
    8000173a:	dc2080e7          	jalr	-574(ra) # 800004f8 <puts>
        return;
    8000173e:	b709                	j	80001640 <runcmd+0x1a>

0000000080001740 <osh>:
{
    80001740:	7119                	addi	sp,sp,-128
    80001742:	fc86                	sd	ra,120(sp)
    80001744:	f8a2                	sd	s0,112(sp)
    80001746:	f4a6                	sd	s1,104(sp)
    80001748:	f0ca                	sd	s2,96(sp)
    8000174a:	ecce                	sd	s3,88(sp)
    8000174c:	e8d2                	sd	s4,80(sp)
    8000174e:	e4d6                	sd	s5,72(sp)
    80001750:	e0da                	sd	s6,64(sp)
    80001752:	0100                	addi	s0,sp,128
    printf("\n==========================Start OS=========================\n");
    80001754:	00002517          	auipc	a0,0x2
    80001758:	d1c50513          	addi	a0,a0,-740 # 80003470 <digits+0x438>
    8000175c:	fffff097          	auipc	ra,0xfffff
    80001760:	d66080e7          	jalr	-666(ra) # 800004c2 <printf>
    puts("Welcome to startOS! Use following commands to get started.");
    80001764:	00002517          	auipc	a0,0x2
    80001768:	d4c50513          	addi	a0,a0,-692 # 800034b0 <digits+0x478>
    8000176c:	fffff097          	auipc	ra,0xfffff
    80001770:	d8c080e7          	jalr	-628(ra) # 800004f8 <puts>
    puts("  * hello - print test hello world message");
    80001774:	00002517          	auipc	a0,0x2
    80001778:	d7c50513          	addi	a0,a0,-644 # 800034f0 <digits+0x4b8>
    8000177c:	fffff097          	auipc	ra,0xfffff
    80001780:	d7c080e7          	jalr	-644(ra) # 800004f8 <puts>
    puts("  * help - list all available commands");
    80001784:	00002517          	auipc	a0,0x2
    80001788:	d9c50513          	addi	a0,a0,-612 # 80003520 <digits+0x4e8>
    8000178c:	fffff097          	auipc	ra,0xfffff
    80001790:	d6c080e7          	jalr	-660(ra) # 800004f8 <puts>
    h.currentP = 0; //当前指令即将写入的位置
    80001794:	00004797          	auipc	a5,0x4
    80001798:	c007aa23          	sw	zero,-1004(a5) # 800053a8 <h+0x140>
        printf("osh>> ");
    8000179c:	00002497          	auipc	s1,0x2
    800017a0:	dac48493          	addi	s1,s1,-596 # 80003548 <digits+0x510>
            if (strcmp(buf, "!!") == 0)
    800017a4:	00002997          	auipc	s3,0x2
    800017a8:	dac98993          	addi	s3,s3,-596 # 80003550 <digits+0x518>
                if (h.currentP >= MAX_HISTORY_NUM)
    800017ac:	00004917          	auipc	s2,0x4
    800017b0:	a4490913          	addi	s2,s2,-1468 # 800051f0 <cpus>
    800017b4:	4a91                	li	s5,4
                strcpy(h.cmdlist[h.currentP++], buf);
    800017b6:	00004a17          	auipc	s4,0x4
    800017ba:	ab2a0a13          	addi	s4,s4,-1358 # 80005268 <h>
                    h.currentP = h.currentP % MAX_HISTORY_NUM;
    800017be:	4b15                	li	s6,5
    800017c0:	a82d                	j	800017fa <osh+0xba>
                runcmd(buf);
    800017c2:	f8040513          	addi	a0,s0,-128
    800017c6:	00000097          	auipc	ra,0x0
    800017ca:	e60080e7          	jalr	-416(ra) # 80001626 <runcmd>
                if (h.currentP >= MAX_HISTORY_NUM)
    800017ce:	1b892783          	lw	a5,440(s2)
    800017d2:	00fad663          	bge	s5,a5,800017de <osh+0x9e>
                    h.currentP = h.currentP % MAX_HISTORY_NUM;
    800017d6:	0367e7bb          	remw	a5,a5,s6
    800017da:	1af92c23          	sw	a5,440(s2)
                strcpy(h.cmdlist[h.currentP++], buf);
    800017de:	1b892503          	lw	a0,440(s2)
    800017e2:	0015079b          	addiw	a5,a0,1
    800017e6:	1af92c23          	sw	a5,440(s2)
    800017ea:	051a                	slli	a0,a0,0x6
    800017ec:	f8040593          	addi	a1,s0,-128
    800017f0:	9552                	add	a0,a0,s4
    800017f2:	fffff097          	auipc	ra,0xfffff
    800017f6:	2fe080e7          	jalr	766(ra) # 80000af0 <strcpy>
        printf("osh>> ");
    800017fa:	8526                	mv	a0,s1
    800017fc:	fffff097          	auipc	ra,0xfffff
    80001800:	cc6080e7          	jalr	-826(ra) # 800004c2 <printf>
        if (read_line(buf) != 0) {
    80001804:	f8040513          	addi	a0,s0,-128
    80001808:	fffff097          	auipc	ra,0xfffff
    8000180c:	d2c080e7          	jalr	-724(ra) # 80000534 <read_line>
    80001810:	d56d                	beqz	a0,800017fa <osh+0xba>
            if (strcmp(buf, "!!") == 0)
    80001812:	85ce                	mv	a1,s3
    80001814:	f8040513          	addi	a0,s0,-128
    80001818:	fffff097          	auipc	ra,0xfffff
    8000181c:	2f4080e7          	jalr	756(ra) # 80000b0c <strcmp>
    80001820:	f14d                	bnez	a0,800017c2 <osh+0x82>
                showHistory();
    80001822:	00000097          	auipc	ra,0x0
    80001826:	c54080e7          	jalr	-940(ra) # 80001476 <showHistory>
    8000182a:	bfc1                	j	800017fa <osh+0xba>

000000008000182c <init>:
{
    8000182c:	1141                	addi	sp,sp,-16
    8000182e:	e406                	sd	ra,8(sp)
    80001830:	e022                	sd	s0,0(sp)
    80001832:	0800                	addi	s0,sp,16
    int pid = fork();
    80001834:	00000097          	auipc	ra,0x0
    80001838:	18a080e7          	jalr	394(ra) # 800019be <fork>
    if (pid < 0) {
    8000183c:	00054963          	bltz	a0,8000184e <init+0x22>
    } else if (pid == 0) {
    80001840:	c105                	beqz	a0,80001860 <init+0x34>
        wait(0);
    80001842:	4501                	li	a0,0
    80001844:	fffff097          	auipc	ra,0xfffff
    80001848:	6d2080e7          	jalr	1746(ra) # 80000f16 <wait>
    for (;;) {
    8000184c:	bfdd                	j	80001842 <init+0x16>
        panic("init");
    8000184e:	00002517          	auipc	a0,0x2
    80001852:	d0a50513          	addi	a0,a0,-758 # 80003558 <digits+0x520>
    80001856:	fffff097          	auipc	ra,0xfffff
    8000185a:	e78080e7          	jalr	-392(ra) # 800006ce <panic>
    8000185e:	b7d5                	j	80001842 <init+0x16>
        exec((uint64)osh);
    80001860:	00000517          	auipc	a0,0x0
    80001864:	ee050513          	addi	a0,a0,-288 # 80001740 <osh>
    80001868:	00000097          	auipc	ra,0x0
    8000186c:	cac080e7          	jalr	-852(ra) # 80001514 <exec>
    80001870:	bfc9                	j	80001842 <init+0x16>

0000000080001872 <print_proc>:

void print_proc()
{
    80001872:	7179                	addi	sp,sp,-48
    80001874:	f406                	sd	ra,40(sp)
    80001876:	f022                	sd	s0,32(sp)
    80001878:	ec26                	sd	s1,24(sp)
    8000187a:	e84a                	sd	s2,16(sp)
    8000187c:	e44e                	sd	s3,8(sp)
    8000187e:	1800                	addi	s0,sp,48
    struct proc* p;
    printf(" \npid\tstate\n");
    80001880:	00002517          	auipc	a0,0x2
    80001884:	ce050513          	addi	a0,a0,-800 # 80003560 <digits+0x528>
    80001888:	fffff097          	auipc	ra,0xfffff
    8000188c:	c3a080e7          	jalr	-966(ra) # 800004c2 <printf>
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80001890:	00045497          	auipc	s1,0x45
    80001894:	b2048493          	addi	s1,s1,-1248 # 800463b0 <proc_table>
        if (p->state == UNUSED)
            continue;
        printf(" %d\t  %d\n", p->pid, p->state);
    80001898:	00002997          	auipc	s3,0x2
    8000189c:	cd898993          	addi	s3,s3,-808 # 80003570 <digits+0x538>
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    800018a0:	00047917          	auipc	s2,0x47
    800018a4:	71090913          	addi	s2,s2,1808 # 80048fb0 <proc_table+0x2c00>
    800018a8:	a029                	j	800018b2 <print_proc+0x40>
    800018aa:	0b048493          	addi	s1,s1,176
    800018ae:	01248b63          	beq	s1,s2,800018c4 <print_proc+0x52>
        if (p->state == UNUSED)
    800018b2:	4090                	lw	a2,0(s1)
    800018b4:	da7d                	beqz	a2,800018aa <print_proc+0x38>
        printf(" %d\t  %d\n", p->pid, p->state);
    800018b6:	508c                	lw	a1,32(s1)
    800018b8:	854e                	mv	a0,s3
    800018ba:	fffff097          	auipc	ra,0xfffff
    800018be:	c08080e7          	jalr	-1016(ra) # 800004c2 <printf>
    800018c2:	b7e5                	j	800018aa <print_proc+0x38>
    }
    800018c4:	70a2                	ld	ra,40(sp)
    800018c6:	7402                	ld	s0,32(sp)
    800018c8:	64e2                	ld	s1,24(sp)
    800018ca:	6942                	ld	s2,16(sp)
    800018cc:	69a2                	ld	s3,8(sp)
    800018ce:	6145                	addi	sp,sp,48
    800018d0:	8082                	ret

00000000800018d2 <memset>:
#include "types.h"

void* memset(void* dst, int c, uint n)
{
    800018d2:	1141                	addi	sp,sp,-16
    800018d4:	e422                	sd	s0,8(sp)
    800018d6:	0800                	addi	s0,sp,16
    char* cdst = (char*)dst;
    int i;
    for (i = 0; i < n; i++) {
    800018d8:	ce09                	beqz	a2,800018f2 <memset+0x20>
    800018da:	87aa                	mv	a5,a0
    800018dc:	fff6071b          	addiw	a4,a2,-1
    800018e0:	1702                	slli	a4,a4,0x20
    800018e2:	9301                	srli	a4,a4,0x20
    800018e4:	0705                	addi	a4,a4,1
    800018e6:	972a                	add	a4,a4,a0
        cdst[i] = c;
    800018e8:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++) {
    800018ec:	0785                	addi	a5,a5,1
    800018ee:	fee79de3          	bne	a5,a4,800018e8 <memset+0x16>
    }
    return dst;
}
    800018f2:	6422                	ld	s0,8(sp)
    800018f4:	0141                	addi	sp,sp,16
    800018f6:	8082                	ret

00000000800018f8 <memmove>:

void* memmove(void* vdst, const void* vsrc, int n)
{
    800018f8:	1141                	addi	sp,sp,-16
    800018fa:	e422                	sd	s0,8(sp)
    800018fc:	0800                	addi	s0,sp,16
    char* dst;
    const char* src;

    dst = vdst;
    src = vsrc;
    if (src > dst) {
    800018fe:	02b57663          	bgeu	a0,a1,8000192a <memmove+0x32>
        while (n-- > 0)
    80001902:	02c05163          	blez	a2,80001924 <memmove+0x2c>
    80001906:	fff6079b          	addiw	a5,a2,-1
    8000190a:	1782                	slli	a5,a5,0x20
    8000190c:	9381                	srli	a5,a5,0x20
    8000190e:	0785                	addi	a5,a5,1
    80001910:	97aa                	add	a5,a5,a0
    dst = vdst;
    80001912:	872a                	mv	a4,a0
            *dst++ = *src++;
    80001914:	0585                	addi	a1,a1,1
    80001916:	0705                	addi	a4,a4,1
    80001918:	fff5c683          	lbu	a3,-1(a1)
    8000191c:	fed70fa3          	sb	a3,-1(a4) # fff <_entry-0x7ffff001>
        while (n-- > 0)
    80001920:	fee79ae3          	bne	a5,a4,80001914 <memmove+0x1c>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
    80001924:	6422                	ld	s0,8(sp)
    80001926:	0141                	addi	sp,sp,16
    80001928:	8082                	ret
        dst += n;
    8000192a:	00c50733          	add	a4,a0,a2
        src += n;
    8000192e:	95b2                	add	a1,a1,a2
        while (n-- > 0)
    80001930:	fec05ae3          	blez	a2,80001924 <memmove+0x2c>
    80001934:	fff6079b          	addiw	a5,a2,-1
    80001938:	1782                	slli	a5,a5,0x20
    8000193a:	9381                	srli	a5,a5,0x20
    8000193c:	fff7c793          	not	a5,a5
    80001940:	97ba                	add	a5,a5,a4
            *--dst = *--src;
    80001942:	15fd                	addi	a1,a1,-1
    80001944:	177d                	addi	a4,a4,-1
    80001946:	0005c683          	lbu	a3,0(a1)
    8000194a:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
    8000194e:	fee79ae3          	bne	a5,a4,80001942 <memmove+0x4a>
    80001952:	bfc9                	j	80001924 <memmove+0x2c>

0000000080001954 <pswitch>:
    80001954:	00153023          	sd	ra,0(a0)
    80001958:	00253423          	sd	sp,8(a0)
    8000195c:	e900                	sd	s0,16(a0)
    8000195e:	ed04                	sd	s1,24(a0)
    80001960:	03253023          	sd	s2,32(a0)
    80001964:	03353423          	sd	s3,40(a0)
    80001968:	03453823          	sd	s4,48(a0)
    8000196c:	03553c23          	sd	s5,56(a0)
    80001970:	05653023          	sd	s6,64(a0)
    80001974:	05753423          	sd	s7,72(a0)
    80001978:	05853823          	sd	s8,80(a0)
    8000197c:	05953c23          	sd	s9,88(a0)
    80001980:	07a53023          	sd	s10,96(a0)
    80001984:	07b53423          	sd	s11,104(a0)
    80001988:	0005b083          	ld	ra,0(a1)
    8000198c:	0085b103          	ld	sp,8(a1)
    80001990:	6980                	ld	s0,16(a1)
    80001992:	6d84                	ld	s1,24(a1)
    80001994:	0205b903          	ld	s2,32(a1)
    80001998:	0285b983          	ld	s3,40(a1)
    8000199c:	0305ba03          	ld	s4,48(a1)
    800019a0:	0385ba83          	ld	s5,56(a1)
    800019a4:	0405bb03          	ld	s6,64(a1)
    800019a8:	0485bb83          	ld	s7,72(a1)
    800019ac:	0505bc03          	ld	s8,80(a1)
    800019b0:	0585bc83          	ld	s9,88(a1)
    800019b4:	0605bd03          	ld	s10,96(a1)
    800019b8:	0685bd83          	ld	s11,104(a1)
    800019bc:	8082                	ret

00000000800019be <fork>:
// fork失败返回-1
// 父进程返回子进程id
// 子进程返回0
//
int fork()
{
    800019be:	1101                	addi	sp,sp,-32
    800019c0:	ec06                	sd	ra,24(sp)
    800019c2:	e822                	sd	s0,16(sp)
    800019c4:	e426                	sd	s1,8(sp)
    800019c6:	e04a                	sd	s2,0(sp)
    800019c8:	1000                	addi	s0,sp,32
    struct proc* p;
    struct proc* np;
    if ((np = alloc_proc()) == 0) {
    800019ca:	fffff097          	auipc	ra,0xfffff
    800019ce:	2c0080e7          	jalr	704(ra) # 80000c8a <alloc_proc>
    800019d2:	c931                	beqz	a0,80001a26 <fork+0x68>
    800019d4:	84aa                	mv	s1,a0
        return -1;
    }
    p = myproc();
    800019d6:	fffff097          	auipc	ra,0xfffff
    800019da:	37c080e7          	jalr	892(ra) # 80000d52 <myproc>
    800019de:	892a                	mv	s2,a0
    memmove((char*)np->kstack, (char*)p->kstack, PGSIZE);
    800019e0:	6605                	lui	a2,0x1
    800019e2:	750c                	ld	a1,40(a0)
    800019e4:	7488                	ld	a0,40(s1)
    800019e6:	00000097          	auipc	ra,0x0
    800019ea:	f12080e7          	jalr	-238(ra) # 800018f8 <memmove>
    np->parent = p;
    800019ee:	0124b423          	sd	s2,8(s1)
    np->state = RUNNABLE;
    800019f2:	4789                	li	a5,2
    800019f4:	c09c                	sw	a5,0(s1)
    forkra(&np->context, p->kstack, np->kstack);
    800019f6:	7490                	ld	a2,40(s1)
    800019f8:	02893583          	ld	a1,40(s2)
    800019fc:	03048513          	addi	a0,s1,48
    80001a00:	00000097          	auipc	ra,0x0
    80001a04:	090080e7          	jalr	144(ra) # 80001a90 <forkra>
    return myproc() == np ? 0 : np->pid;
    80001a08:	fffff097          	auipc	ra,0xfffff
    80001a0c:	34a080e7          	jalr	842(ra) # 80000d52 <myproc>
    80001a10:	87aa                	mv	a5,a0
    80001a12:	4501                	li	a0,0
    80001a14:	00f48363          	beq	s1,a5,80001a1a <fork+0x5c>
    80001a18:	5088                	lw	a0,32(s1)
}
    80001a1a:	60e2                	ld	ra,24(sp)
    80001a1c:	6442                	ld	s0,16(sp)
    80001a1e:	64a2                	ld	s1,8(sp)
    80001a20:	6902                	ld	s2,0(sp)
    80001a22:	6105                	addi	sp,sp,32
    80001a24:	8082                	ret
        return -1;
    80001a26:	557d                	li	a0,-1
    80001a28:	bfcd                	j	80001a1a <fork+0x5c>

0000000080001a2a <sleep_sec>:

//
// 睡眠指定秒数
//
void sleep_sec(int seconds)
{
    80001a2a:	1141                	addi	sp,sp,-16
    80001a2c:	e406                	sd	ra,8(sp)
    80001a2e:	e022                	sd	s0,0(sp)
    80001a30:	0800                	addi	s0,sp,16
    sleep_time(seconds * 10);
    80001a32:	0025179b          	slliw	a5,a0,0x2
    80001a36:	9d3d                	addw	a0,a0,a5
    80001a38:	0015151b          	slliw	a0,a0,0x1
    80001a3c:	fffff097          	auipc	ra,0xfffff
    80001a40:	38a080e7          	jalr	906(ra) # 80000dc6 <sleep_time>
}
    80001a44:	60a2                	ld	ra,8(sp)
    80001a46:	6402                	ld	s0,0(sp)
    80001a48:	0141                	addi	sp,sp,16
    80001a4a:	8082                	ret

0000000080001a4c <yeild>:

//
// 让出cpu
//
void yeild()
{
    80001a4c:	1101                	addi	sp,sp,-32
    80001a4e:	ec06                	sd	ra,24(sp)
    80001a50:	e822                	sd	s0,16(sp)
    80001a52:	e426                	sd	s1,8(sp)
    80001a54:	1000                	addi	s0,sp,32
    myproc()->state = RUNNABLE;
    80001a56:	fffff097          	auipc	ra,0xfffff
    80001a5a:	2fc080e7          	jalr	764(ra) # 80000d52 <myproc>
    80001a5e:	4789                	li	a5,2
    80001a60:	c11c                	sw	a5,0(a0)
    pswitch(&(myproc()->context), &(mycpu()->context));
    80001a62:	fffff097          	auipc	ra,0xfffff
    80001a66:	2f0080e7          	jalr	752(ra) # 80000d52 <myproc>
    80001a6a:	84aa                	mv	s1,a0
    80001a6c:	fffff097          	auipc	ra,0xfffff
    80001a70:	2c2080e7          	jalr	706(ra) # 80000d2e <mycpu>
    80001a74:	00850593          	addi	a1,a0,8
    80001a78:	03048513          	addi	a0,s1,48
    80001a7c:	00000097          	auipc	ra,0x0
    80001a80:	ed8080e7          	jalr	-296(ra) # 80001954 <pswitch>
}
    80001a84:	60e2                	ld	ra,24(sp)
    80001a86:	6442                	ld	s0,16(sp)
    80001a88:	64a2                	ld	s1,8(sp)
    80001a8a:	6105                	addi	sp,sp,32
    80001a8c:	8082                	ret
	...

0000000080001a90 <forkra>:
    80001a90:	40b102b3          	sub	t0,sp,a1
    80001a94:	92b2                	add	t0,t0,a2
    80001a96:	00153023          	sd	ra,0(a0)
    80001a9a:	00553423          	sd	t0,8(a0)
    80001a9e:	e900                	sd	s0,16(a0)
    80001aa0:	ed04                	sd	s1,24(a0)
    80001aa2:	03253023          	sd	s2,32(a0)
    80001aa6:	03353423          	sd	s3,40(a0)
    80001aaa:	03453823          	sd	s4,48(a0)
    80001aae:	03553c23          	sd	s5,56(a0)
    80001ab2:	05653023          	sd	s6,64(a0)
    80001ab6:	05753423          	sd	s7,72(a0)
    80001aba:	05853823          	sd	s8,80(a0)
    80001abe:	05953c23          	sd	s9,88(a0)
    80001ac2:	07a53023          	sd	s10,96(a0)
    80001ac6:	07b53423          	sd	s11,104(a0)
    80001aca:	8082                	ret
    80001acc:	00000013          	nop

0000000080001ad0 <execra>:
    80001ad0:	e110                	sd	a2,0(a0)
    80001ad2:	0005b083          	ld	ra,0(a1)
    80001ad6:	0085b103          	ld	sp,8(a1)
    80001ada:	6980                	ld	s0,16(a1)
    80001adc:	6d84                	ld	s1,24(a1)
    80001ade:	0205b903          	ld	s2,32(a1)
    80001ae2:	0285b983          	ld	s3,40(a1)
    80001ae6:	0305ba03          	ld	s4,48(a1)
    80001aea:	0385ba83          	ld	s5,56(a1)
    80001aee:	0405bb03          	ld	s6,64(a1)
    80001af2:	0485bb83          	ld	s7,72(a1)
    80001af6:	0505bc03          	ld	s8,80(a1)
    80001afa:	0585bc83          	ld	s9,88(a1)
    80001afe:	0605bd03          	ld	s10,96(a1)
    80001b02:	0685bd83          	ld	s11,104(a1)
    80001b06:	8082                	ret

0000000080001b08 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80001b08:	1101                	addi	sp,sp,-32
    80001b0a:	ec06                	sd	ra,24(sp)
    80001b0c:	e822                	sd	s0,16(sp)
    80001b0e:	e426                	sd	s1,8(sp)
    80001b10:	1000                	addi	s0,sp,32
    80001b12:	84aa                	mv	s1,a0
  if(i >= NUM)
    80001b14:	479d                	li	a5,7
    80001b16:	06a7ca63          	blt	a5,a0,80001b8a <free_desc+0x82>
    panic("free_desc 1");
  if(disk.free[i])
    80001b1a:	00047797          	auipc	a5,0x47
    80001b1e:	4e678793          	addi	a5,a5,1254 # 80049000 <disk>
    80001b22:	00978733          	add	a4,a5,s1
    80001b26:	6789                	lui	a5,0x2
    80001b28:	97ba                	add	a5,a5,a4
    80001b2a:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80001b2e:	e7bd                	bnez	a5,80001b9c <free_desc+0x94>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80001b30:	00449793          	slli	a5,s1,0x4
    80001b34:	00049717          	auipc	a4,0x49
    80001b38:	4cc70713          	addi	a4,a4,1228 # 8004b000 <disk+0x2000>
    80001b3c:	6314                	ld	a3,0(a4)
    80001b3e:	96be                	add	a3,a3,a5
    80001b40:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80001b44:	6314                	ld	a3,0(a4)
    80001b46:	96be                	add	a3,a3,a5
    80001b48:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80001b4c:	6314                	ld	a3,0(a4)
    80001b4e:	96be                	add	a3,a3,a5
    80001b50:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80001b54:	6318                	ld	a4,0(a4)
    80001b56:	97ba                	add	a5,a5,a4
    80001b58:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80001b5c:	00047517          	auipc	a0,0x47
    80001b60:	4a450513          	addi	a0,a0,1188 # 80049000 <disk>
    80001b64:	9526                	add	a0,a0,s1
    80001b66:	6489                	lui	s1,0x2
    80001b68:	94aa                	add	s1,s1,a0
    80001b6a:	4785                	li	a5,1
    80001b6c:	00f48c23          	sb	a5,24(s1) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80001b70:	00049517          	auipc	a0,0x49
    80001b74:	4a850513          	addi	a0,a0,1192 # 8004b018 <disk+0x2018>
    80001b78:	fffff097          	auipc	ra,0xfffff
    80001b7c:	292080e7          	jalr	658(ra) # 80000e0a <wakeup>
}
    80001b80:	60e2                	ld	ra,24(sp)
    80001b82:	6442                	ld	s0,16(sp)
    80001b84:	64a2                	ld	s1,8(sp)
    80001b86:	6105                	addi	sp,sp,32
    80001b88:	8082                	ret
    panic("free_desc 1");
    80001b8a:	00002517          	auipc	a0,0x2
    80001b8e:	9fe50513          	addi	a0,a0,-1538 # 80003588 <digits+0x550>
    80001b92:	fffff097          	auipc	ra,0xfffff
    80001b96:	b3c080e7          	jalr	-1220(ra) # 800006ce <panic>
    80001b9a:	b741                	j	80001b1a <free_desc+0x12>
    panic("free_desc 2");
    80001b9c:	00002517          	auipc	a0,0x2
    80001ba0:	9fc50513          	addi	a0,a0,-1540 # 80003598 <digits+0x560>
    80001ba4:	fffff097          	auipc	ra,0xfffff
    80001ba8:	b2a080e7          	jalr	-1238(ra) # 800006ce <panic>
    80001bac:	b751                	j	80001b30 <free_desc+0x28>

0000000080001bae <virtio_disk_init>:
{
    80001bae:	1101                	addi	sp,sp,-32
    80001bb0:	ec06                	sd	ra,24(sp)
    80001bb2:	e822                	sd	s0,16(sp)
    80001bb4:	e426                	sd	s1,8(sp)
    80001bb6:	1000                	addi	s0,sp,32
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80001bb8:	100017b7          	lui	a5,0x10001
    80001bbc:	4398                	lw	a4,0(a5)
    80001bbe:	2701                	sext.w	a4,a4
    80001bc0:	747277b7          	lui	a5,0x74727
    80001bc4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80001bc8:	00f71963          	bne	a4,a5,80001bda <virtio_disk_init+0x2c>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80001bcc:	100017b7          	lui	a5,0x10001
    80001bd0:	43dc                	lw	a5,4(a5)
    80001bd2:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80001bd4:	4705                	li	a4,1
    80001bd6:	0ce78163          	beq	a5,a4,80001c98 <virtio_disk_init+0xea>
    panic("could not find virtio disk");
    80001bda:	00002517          	auipc	a0,0x2
    80001bde:	9ce50513          	addi	a0,a0,-1586 # 800035a8 <digits+0x570>
    80001be2:	fffff097          	auipc	ra,0xfffff
    80001be6:	aec080e7          	jalr	-1300(ra) # 800006ce <panic>
  *R(VIRTIO_MMIO_STATUS) = status;
    80001bea:	100017b7          	lui	a5,0x10001
    80001bee:	4705                	li	a4,1
    80001bf0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80001bf2:	470d                	li	a4,3
    80001bf4:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80001bf6:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80001bf8:	c7ffe737          	lui	a4,0xc7ffe
    80001bfc:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <disk+0xffffffff47fb575f>
    80001c00:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80001c02:	2701                	sext.w	a4,a4
    80001c04:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80001c06:	472d                	li	a4,11
    80001c08:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80001c0a:	473d                	li	a4,15
    80001c0c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80001c0e:	6705                	lui	a4,0x1
    80001c10:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80001c12:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80001c16:	5bdc                	lw	a5,52(a5)
    80001c18:	2781                	sext.w	a5,a5
  if(max == 0)
    80001c1a:	c3cd                	beqz	a5,80001cbc <virtio_disk_init+0x10e>
  if(max < NUM)
    80001c1c:	471d                	li	a4,7
    80001c1e:	0af77763          	bgeu	a4,a5,80001ccc <virtio_disk_init+0x11e>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80001c22:	100014b7          	lui	s1,0x10001
    80001c26:	47a1                	li	a5,8
    80001c28:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80001c2a:	6609                	lui	a2,0x2
    80001c2c:	4581                	li	a1,0
    80001c2e:	00047517          	auipc	a0,0x47
    80001c32:	3d250513          	addi	a0,a0,978 # 80049000 <disk>
    80001c36:	00000097          	auipc	ra,0x0
    80001c3a:	c9c080e7          	jalr	-868(ra) # 800018d2 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80001c3e:	00047717          	auipc	a4,0x47
    80001c42:	3c270713          	addi	a4,a4,962 # 80049000 <disk>
    80001c46:	00c75793          	srli	a5,a4,0xc
    80001c4a:	2781                	sext.w	a5,a5
    80001c4c:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80001c4e:	00049797          	auipc	a5,0x49
    80001c52:	3b278793          	addi	a5,a5,946 # 8004b000 <disk+0x2000>
    80001c56:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80001c58:	00047717          	auipc	a4,0x47
    80001c5c:	42870713          	addi	a4,a4,1064 # 80049080 <disk+0x80>
    80001c60:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80001c62:	00048717          	auipc	a4,0x48
    80001c66:	39e70713          	addi	a4,a4,926 # 8004a000 <disk+0x1000>
    80001c6a:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80001c6c:	4705                	li	a4,1
    80001c6e:	00e78c23          	sb	a4,24(a5)
    80001c72:	00e78ca3          	sb	a4,25(a5)
    80001c76:	00e78d23          	sb	a4,26(a5)
    80001c7a:	00e78da3          	sb	a4,27(a5)
    80001c7e:	00e78e23          	sb	a4,28(a5)
    80001c82:	00e78ea3          	sb	a4,29(a5)
    80001c86:	00e78f23          	sb	a4,30(a5)
    80001c8a:	00e78fa3          	sb	a4,31(a5)
}
    80001c8e:	60e2                	ld	ra,24(sp)
    80001c90:	6442                	ld	s0,16(sp)
    80001c92:	64a2                	ld	s1,8(sp)
    80001c94:	6105                	addi	sp,sp,32
    80001c96:	8082                	ret
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80001c98:	100017b7          	lui	a5,0x10001
    80001c9c:	479c                	lw	a5,8(a5)
    80001c9e:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80001ca0:	4709                	li	a4,2
    80001ca2:	f2e79ce3          	bne	a5,a4,80001bda <virtio_disk_init+0x2c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80001ca6:	100017b7          	lui	a5,0x10001
    80001caa:	47d8                	lw	a4,12(a5)
    80001cac:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80001cae:	554d47b7          	lui	a5,0x554d4
    80001cb2:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80001cb6:	f2f712e3          	bne	a4,a5,80001bda <virtio_disk_init+0x2c>
    80001cba:	bf05                	j	80001bea <virtio_disk_init+0x3c>
    panic("virtio disk has no queue 0");
    80001cbc:	00002517          	auipc	a0,0x2
    80001cc0:	90c50513          	addi	a0,a0,-1780 # 800035c8 <digits+0x590>
    80001cc4:	fffff097          	auipc	ra,0xfffff
    80001cc8:	a0a080e7          	jalr	-1526(ra) # 800006ce <panic>
    panic("virtio disk max queue too short");
    80001ccc:	00002517          	auipc	a0,0x2
    80001cd0:	91c50513          	addi	a0,a0,-1764 # 800035e8 <digits+0x5b0>
    80001cd4:	fffff097          	auipc	ra,0xfffff
    80001cd8:	9fa080e7          	jalr	-1542(ra) # 800006ce <panic>
    80001cdc:	b799                	j	80001c22 <virtio_disk_init+0x74>

0000000080001cde <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80001cde:	7159                	addi	sp,sp,-112
    80001ce0:	f486                	sd	ra,104(sp)
    80001ce2:	f0a2                	sd	s0,96(sp)
    80001ce4:	eca6                	sd	s1,88(sp)
    80001ce6:	e8ca                	sd	s2,80(sp)
    80001ce8:	e4ce                	sd	s3,72(sp)
    80001cea:	e0d2                	sd	s4,64(sp)
    80001cec:	fc56                	sd	s5,56(sp)
    80001cee:	f85a                	sd	s6,48(sp)
    80001cf0:	f45e                	sd	s7,40(sp)
    80001cf2:	f062                	sd	s8,32(sp)
    80001cf4:	ec66                	sd	s9,24(sp)
    80001cf6:	e86a                	sd	s10,16(sp)
    80001cf8:	1880                	addi	s0,sp,112
    80001cfa:	892a                	mv	s2,a0
    80001cfc:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80001cfe:	00c52c83          	lw	s9,12(a0)
    80001d02:	001c9c9b          	slliw	s9,s9,0x1
    80001d06:	1c82                	slli	s9,s9,0x20
    80001d08:	020cdc93          	srli	s9,s9,0x20
  for(int i = 0; i < 3; i++){
    80001d0c:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80001d0e:	4c21                	li	s8,8
      disk.free[i] = 0;
    80001d10:	00047b97          	auipc	s7,0x47
    80001d14:	2f0b8b93          	addi	s7,s7,752 # 80049000 <disk>
    80001d18:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80001d1a:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80001d1c:	8a4e                	mv	s4,s3
    80001d1e:	a8b5                	j	80001d9a <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    80001d20:	00fb86b3          	add	a3,s7,a5
    80001d24:	96da                	add	a3,a3,s6
    80001d26:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80001d2a:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80001d2c:	0207c563          	bltz	a5,80001d56 <virtio_disk_rw+0x78>
  for(int i = 0; i < 3; i++){
    80001d30:	2485                	addiw	s1,s1,1
    80001d32:	0711                	addi	a4,a4,4
    80001d34:	21548f63          	beq	s1,s5,80001f52 <virtio_disk_rw+0x274>
    idx[i] = alloc_desc();
    80001d38:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80001d3a:	00049697          	auipc	a3,0x49
    80001d3e:	2de68693          	addi	a3,a3,734 # 8004b018 <disk+0x2018>
    80001d42:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80001d44:	0006c583          	lbu	a1,0(a3)
    80001d48:	fde1                	bnez	a1,80001d20 <virtio_disk_rw+0x42>
  for(int i = 0; i < NUM; i++){
    80001d4a:	2785                	addiw	a5,a5,1
    80001d4c:	0685                	addi	a3,a3,1
    80001d4e:	ff879be3          	bne	a5,s8,80001d44 <virtio_disk_rw+0x66>
    idx[i] = alloc_desc();
    80001d52:	57fd                	li	a5,-1
    80001d54:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80001d56:	02905a63          	blez	s1,80001d8a <virtio_disk_rw+0xac>
        free_desc(idx[j]);
    80001d5a:	f9042503          	lw	a0,-112(s0)
    80001d5e:	00000097          	auipc	ra,0x0
    80001d62:	daa080e7          	jalr	-598(ra) # 80001b08 <free_desc>
      for(int j = 0; j < i; j++)
    80001d66:	4785                	li	a5,1
    80001d68:	0297d163          	bge	a5,s1,80001d8a <virtio_disk_rw+0xac>
        free_desc(idx[j]);
    80001d6c:	f9442503          	lw	a0,-108(s0)
    80001d70:	00000097          	auipc	ra,0x0
    80001d74:	d98080e7          	jalr	-616(ra) # 80001b08 <free_desc>
      for(int j = 0; j < i; j++)
    80001d78:	4789                	li	a5,2
    80001d7a:	0097d863          	bge	a5,s1,80001d8a <virtio_disk_rw+0xac>
        free_desc(idx[j]);
    80001d7e:	f9842503          	lw	a0,-104(s0)
    80001d82:	00000097          	auipc	ra,0x0
    80001d86:	d86080e7          	jalr	-634(ra) # 80001b08 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0]);
    80001d8a:	00049517          	auipc	a0,0x49
    80001d8e:	28e50513          	addi	a0,a0,654 # 8004b018 <disk+0x2018>
    80001d92:	fffff097          	auipc	ra,0xfffff
    80001d96:	fe6080e7          	jalr	-26(ra) # 80000d78 <sleep>
  for(int i = 0; i < 3; i++){
    80001d9a:	f9040713          	addi	a4,s0,-112
    80001d9e:	84ce                	mv	s1,s3
    80001da0:	bf61                	j	80001d38 <virtio_disk_rw+0x5a>
  // format the three descriptors.
  // qemu's virtio-blk.c reads them.
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80001da2:	20058713          	addi	a4,a1,512
    80001da6:	00471693          	slli	a3,a4,0x4
    80001daa:	00047717          	auipc	a4,0x47
    80001dae:	25670713          	addi	a4,a4,598 # 80049000 <disk>
    80001db2:	9736                	add	a4,a4,a3
    80001db4:	4685                	li	a3,1
    80001db6:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80001dba:	20058713          	addi	a4,a1,512
    80001dbe:	00471693          	slli	a3,a4,0x4
    80001dc2:	00047717          	auipc	a4,0x47
    80001dc6:	23e70713          	addi	a4,a4,574 # 80049000 <disk>
    80001dca:	9736                	add	a4,a4,a3
    80001dcc:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80001dd0:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80001dd4:	7679                	lui	a2,0xffffe
    80001dd6:	963e                	add	a2,a2,a5
    80001dd8:	00049697          	auipc	a3,0x49
    80001ddc:	22868693          	addi	a3,a3,552 # 8004b000 <disk+0x2000>
    80001de0:	6298                	ld	a4,0(a3)
    80001de2:	9732                	add	a4,a4,a2
    80001de4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80001de6:	6298                	ld	a4,0(a3)
    80001de8:	9732                	add	a4,a4,a2
    80001dea:	4541                	li	a0,16
    80001dec:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80001dee:	6298                	ld	a4,0(a3)
    80001df0:	9732                	add	a4,a4,a2
    80001df2:	4505                	li	a0,1
    80001df4:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80001df8:	f9442703          	lw	a4,-108(s0)
    80001dfc:	6288                	ld	a0,0(a3)
    80001dfe:	962a                	add	a2,a2,a0
    80001e00:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <disk+0xffffffff7ffb500e>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80001e04:	0712                	slli	a4,a4,0x4
    80001e06:	6290                	ld	a2,0(a3)
    80001e08:	963a                	add	a2,a2,a4
    80001e0a:	01490513          	addi	a0,s2,20
    80001e0e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80001e10:	6294                	ld	a3,0(a3)
    80001e12:	96ba                	add	a3,a3,a4
    80001e14:	40000613          	li	a2,1024
    80001e18:	c690                	sw	a2,8(a3)
  if(write)
    80001e1a:	120d0363          	beqz	s10,80001f40 <virtio_disk_rw+0x262>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80001e1e:	00049697          	auipc	a3,0x49
    80001e22:	1e26b683          	ld	a3,482(a3) # 8004b000 <disk+0x2000>
    80001e26:	96ba                	add	a3,a3,a4
    80001e28:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80001e2c:	00047817          	auipc	a6,0x47
    80001e30:	1d480813          	addi	a6,a6,468 # 80049000 <disk>
    80001e34:	00049517          	auipc	a0,0x49
    80001e38:	1cc50513          	addi	a0,a0,460 # 8004b000 <disk+0x2000>
    80001e3c:	6114                	ld	a3,0(a0)
    80001e3e:	96ba                	add	a3,a3,a4
    80001e40:	00c6d603          	lhu	a2,12(a3)
    80001e44:	00166613          	ori	a2,a2,1
    80001e48:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80001e4c:	f9842683          	lw	a3,-104(s0)
    80001e50:	6110                	ld	a2,0(a0)
    80001e52:	9732                	add	a4,a4,a2
    80001e54:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80001e58:	20058613          	addi	a2,a1,512
    80001e5c:	0612                	slli	a2,a2,0x4
    80001e5e:	9642                	add	a2,a2,a6
    80001e60:	577d                	li	a4,-1
    80001e62:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80001e66:	00469713          	slli	a4,a3,0x4
    80001e6a:	6114                	ld	a3,0(a0)
    80001e6c:	96ba                	add	a3,a3,a4
    80001e6e:	03078793          	addi	a5,a5,48
    80001e72:	97c2                	add	a5,a5,a6
    80001e74:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80001e76:	611c                	ld	a5,0(a0)
    80001e78:	97ba                	add	a5,a5,a4
    80001e7a:	4685                	li	a3,1
    80001e7c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80001e7e:	611c                	ld	a5,0(a0)
    80001e80:	97ba                	add	a5,a5,a4
    80001e82:	4809                	li	a6,2
    80001e84:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80001e88:	611c                	ld	a5,0(a0)
    80001e8a:	973e                	add	a4,a4,a5
    80001e8c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80001e90:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80001e94:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80001e98:	6518                	ld	a4,8(a0)
    80001e9a:	00275783          	lhu	a5,2(a4)
    80001e9e:	8b9d                	andi	a5,a5,7
    80001ea0:	0786                	slli	a5,a5,0x1
    80001ea2:	97ba                	add	a5,a5,a4
    80001ea4:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80001ea8:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80001eac:	6518                	ld	a4,8(a0)
    80001eae:	00275783          	lhu	a5,2(a4)
    80001eb2:	2785                	addiw	a5,a5,1
    80001eb4:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80001eb8:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80001ebc:	100017b7          	lui	a5,0x10001
    80001ec0:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80001ec4:	00492703          	lw	a4,4(s2)
    80001ec8:	4785                	li	a5,1
    80001eca:	00f71c63          	bne	a4,a5,80001ee2 <virtio_disk_rw+0x204>
    80001ece:	4485                	li	s1,1
    sleep(b);
    80001ed0:	854a                	mv	a0,s2
    80001ed2:	fffff097          	auipc	ra,0xfffff
    80001ed6:	ea6080e7          	jalr	-346(ra) # 80000d78 <sleep>
  while(b->disk == 1) {
    80001eda:	00492783          	lw	a5,4(s2)
    80001ede:	fe9789e3          	beq	a5,s1,80001ed0 <virtio_disk_rw+0x1f2>
  }

  disk.info[idx[0]].b = 0;
    80001ee2:	f9042903          	lw	s2,-112(s0)
    80001ee6:	20090793          	addi	a5,s2,512
    80001eea:	00479713          	slli	a4,a5,0x4
    80001eee:	00047797          	auipc	a5,0x47
    80001ef2:	11278793          	addi	a5,a5,274 # 80049000 <disk>
    80001ef6:	97ba                	add	a5,a5,a4
    80001ef8:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80001efc:	00049997          	auipc	s3,0x49
    80001f00:	10498993          	addi	s3,s3,260 # 8004b000 <disk+0x2000>
    80001f04:	00491713          	slli	a4,s2,0x4
    80001f08:	0009b783          	ld	a5,0(s3)
    80001f0c:	97ba                	add	a5,a5,a4
    80001f0e:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80001f12:	854a                	mv	a0,s2
    80001f14:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80001f18:	00000097          	auipc	ra,0x0
    80001f1c:	bf0080e7          	jalr	-1040(ra) # 80001b08 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80001f20:	8885                	andi	s1,s1,1
    80001f22:	f0ed                	bnez	s1,80001f04 <virtio_disk_rw+0x226>
  free_chain(idx[0]);

//   release(&disk.vdisk_lock);
}
    80001f24:	70a6                	ld	ra,104(sp)
    80001f26:	7406                	ld	s0,96(sp)
    80001f28:	64e6                	ld	s1,88(sp)
    80001f2a:	6946                	ld	s2,80(sp)
    80001f2c:	69a6                	ld	s3,72(sp)
    80001f2e:	6a06                	ld	s4,64(sp)
    80001f30:	7ae2                	ld	s5,56(sp)
    80001f32:	7b42                	ld	s6,48(sp)
    80001f34:	7ba2                	ld	s7,40(sp)
    80001f36:	7c02                	ld	s8,32(sp)
    80001f38:	6ce2                	ld	s9,24(sp)
    80001f3a:	6d42                	ld	s10,16(sp)
    80001f3c:	6165                	addi	sp,sp,112
    80001f3e:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80001f40:	00049697          	auipc	a3,0x49
    80001f44:	0c06b683          	ld	a3,192(a3) # 8004b000 <disk+0x2000>
    80001f48:	96ba                	add	a3,a3,a4
    80001f4a:	4609                	li	a2,2
    80001f4c:	00c69623          	sh	a2,12(a3)
    80001f50:	bdf1                	j	80001e2c <virtio_disk_rw+0x14e>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80001f52:	f9042583          	lw	a1,-112(s0)
    80001f56:	20058793          	addi	a5,a1,512
    80001f5a:	0792                	slli	a5,a5,0x4
    80001f5c:	00047517          	auipc	a0,0x47
    80001f60:	14c50513          	addi	a0,a0,332 # 800490a8 <disk+0xa8>
    80001f64:	953e                	add	a0,a0,a5
  if(write)
    80001f66:	e20d1ee3          	bnez	s10,80001da2 <virtio_disk_rw+0xc4>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80001f6a:	20058713          	addi	a4,a1,512
    80001f6e:	00471693          	slli	a3,a4,0x4
    80001f72:	00047717          	auipc	a4,0x47
    80001f76:	08e70713          	addi	a4,a4,142 # 80049000 <disk>
    80001f7a:	9736                	add	a4,a4,a3
    80001f7c:	0a072423          	sw	zero,168(a4)
    80001f80:	bd2d                	j	80001dba <virtio_disk_rw+0xdc>

0000000080001f82 <virtio_disk_intr>:
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80001f82:	10001737          	lui	a4,0x10001
    80001f86:	533c                	lw	a5,96(a4)
    80001f88:	8b8d                	andi	a5,a5,3
    80001f8a:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80001f8c:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80001f90:	00049797          	auipc	a5,0x49
    80001f94:	07078793          	addi	a5,a5,112 # 8004b000 <disk+0x2000>
    80001f98:	6b94                	ld	a3,16(a5)
    80001f9a:	0207d703          	lhu	a4,32(a5)
    80001f9e:	0026d783          	lhu	a5,2(a3)
    80001fa2:	08f70e63          	beq	a4,a5,8000203e <virtio_disk_intr+0xbc>
{
    80001fa6:	7179                	addi	sp,sp,-48
    80001fa8:	f406                	sd	ra,40(sp)
    80001faa:	f022                	sd	s0,32(sp)
    80001fac:	ec26                	sd	s1,24(sp)
    80001fae:	e84a                	sd	s2,16(sp)
    80001fb0:	e44e                	sd	s3,8(sp)
    80001fb2:	e052                	sd	s4,0(sp)
    80001fb4:	1800                	addi	s0,sp,48
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80001fb6:	00047997          	auipc	s3,0x47
    80001fba:	04a98993          	addi	s3,s3,74 # 80049000 <disk>
    80001fbe:	00049917          	auipc	s2,0x49
    80001fc2:	04290913          	addi	s2,s2,66 # 8004b000 <disk+0x2000>

    if(disk.info[id].status != 0)
      panic("virtio_disk_intr status");
    80001fc6:	00001a17          	auipc	s4,0x1
    80001fca:	642a0a13          	addi	s4,s4,1602 # 80003608 <digits+0x5d0>
    80001fce:	a835                	j	8000200a <virtio_disk_intr+0x88>
    80001fd0:	8552                	mv	a0,s4
    80001fd2:	ffffe097          	auipc	ra,0xffffe
    80001fd6:	6fc080e7          	jalr	1788(ra) # 800006ce <panic>

    struct buf *b = disk.info[id].b;
    80001fda:	20048493          	addi	s1,s1,512 # 10001200 <_entry-0x6fffee00>
    80001fde:	0492                	slli	s1,s1,0x4
    80001fe0:	94ce                	add	s1,s1,s3
    80001fe2:	7488                	ld	a0,40(s1)
    b->disk = 0;   // disk is done with buf
    80001fe4:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80001fe8:	fffff097          	auipc	ra,0xfffff
    80001fec:	e22080e7          	jalr	-478(ra) # 80000e0a <wakeup>

    disk.used_idx += 1;
    80001ff0:	02095783          	lhu	a5,32(s2)
    80001ff4:	2785                	addiw	a5,a5,1
    80001ff6:	17c2                	slli	a5,a5,0x30
    80001ff8:	93c1                	srli	a5,a5,0x30
    80001ffa:	02f91023          	sh	a5,32(s2)
  while(disk.used_idx != disk.used->idx){
    80001ffe:	01093703          	ld	a4,16(s2)
    80002002:	00275703          	lhu	a4,2(a4) # 10001002 <_entry-0x6fffeffe>
    80002006:	02f70463          	beq	a4,a5,8000202e <virtio_disk_intr+0xac>
    __sync_synchronize();
    8000200a:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000200e:	01093703          	ld	a4,16(s2)
    80002012:	02095783          	lhu	a5,32(s2)
    80002016:	8b9d                	andi	a5,a5,7
    80002018:	078e                	slli	a5,a5,0x3
    8000201a:	97ba                	add	a5,a5,a4
    8000201c:	43c4                	lw	s1,4(a5)
    if(disk.info[id].status != 0)
    8000201e:	20048793          	addi	a5,s1,512
    80002022:	0792                	slli	a5,a5,0x4
    80002024:	97ce                	add	a5,a5,s3
    80002026:	0307c783          	lbu	a5,48(a5)
    8000202a:	dbc5                	beqz	a5,80001fda <virtio_disk_intr+0x58>
    8000202c:	b755                	j	80001fd0 <virtio_disk_intr+0x4e>
  }

//   release(&disk.vdisk_lock);
}
    8000202e:	70a2                	ld	ra,40(sp)
    80002030:	7402                	ld	s0,32(sp)
    80002032:	64e2                	ld	s1,24(sp)
    80002034:	6942                	ld	s2,16(sp)
    80002036:	69a2                	ld	s3,8(sp)
    80002038:	6a02                	ld	s4,0(sp)
    8000203a:	6145                	addi	sp,sp,48
    8000203c:	8082                	ret
    8000203e:	8082                	ret
	...
