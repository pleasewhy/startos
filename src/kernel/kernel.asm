
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
    80000094:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <buf_cache+0xffffffff7ffb0d3f>
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
    80000100:	3a450513          	addi	a0,a0,932 # 800034a0 <digits+0x468>
    80000104:	00000097          	auipc	ra,0x0
    80000108:	3be080e7          	jalr	958(ra) # 800004c2 <printf>
    printf("xv6 kernel is booting\n");
    8000010c:	00003517          	auipc	a0,0x3
    80000110:	ef450513          	addi	a0,a0,-268 # 80003000 <sleep_holding+0x7d0>
    80000114:	00000097          	auipc	ra,0x0
    80000118:	3ae080e7          	jalr	942(ra) # 800004c2 <printf>
    printf("\n");
    8000011c:	00003517          	auipc	a0,0x3
    80000120:	38450513          	addi	a0,a0,900 # 800034a0 <digits+0x468>
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
    80000148:	a8c080e7          	jalr	-1396(ra) # 80000bd0 <init_process_table>
    init_first_process();   // 初始化第一个进程
    8000014c:	00001097          	auipc	ra,0x1
    80000150:	b22080e7          	jalr	-1246(ra) # 80000c6e <init_first_process>
    virtio_disk_init();
    80000154:	00001097          	auipc	ra,0x1
    80000158:	6da080e7          	jalr	1754(ra) # 8000182e <virtio_disk_init>
    scheduler();
    8000015c:	00001097          	auipc	ra,0x1
    80000160:	c46080e7          	jalr	-954(ra) # 80000da2 <scheduler>
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
    80000442:	bda48493          	addi	s1,s1,-1062 # 80003018 <sleep_holding+0x7e8>
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
    80000506:	b1e50513          	addi	a0,a0,-1250 # 80003020 <sleep_holding+0x7f0>
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
    8000054c:	00000097          	auipc	ra,0x0
    80000550:	79a080e7          	jalr	1946(ra) # 80000ce6 <sleep>
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
    80000648:	e7e080e7          	jalr	-386(ra) # 800014c2 <print_proc>
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
    800006c8:	6a4080e7          	jalr	1700(ra) # 80000d68 <wakeup>
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
    800006dc:	95050513          	addi	a0,a0,-1712 # 80003028 <sleep_holding+0x7f8>
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
    800006f8:	802080e7          	jalr	-2046(ra) # 80000ef6 <exit>
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
    80000736:	636080e7          	jalr	1590(ra) # 80000d68 <wakeup>
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
    800007bc:	460080e7          	jalr	1120(ra) # 80001c18 <virtio_disk_intr>
    800007c0:	b7c5                	j	800007a0 <device_intr+0x5e>
        if (cpuid() == 0) {
    800007c2:	00000097          	auipc	ra,0x0
    800007c6:	4da080e7          	jalr	1242(ra) # 80000c9c <cpuid>
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
    800007f8:	4d4080e7          	jalr	1236(ra) # 80000cc8 <myproc>
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
    800008d2:	3ce080e7          	jalr	974(ra) # 80000c9c <cpuid>
  
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
    8000090a:	396080e7          	jalr	918(ra) # 80000c9c <cpuid>
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
    80000932:	36e080e7          	jalr	878(ra) # 80000c9c <cpuid>
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
    80000a20:	4a7000ef          	jal	ra,800016c6 <yeild>
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

0000000080000a98 <strcpy>:
#include "kernel/types.h"

//string utils
char* strcpy(char* s, const char* t)
{
    80000a98:	1141                	addi	sp,sp,-16
    80000a9a:	e422                	sd	s0,8(sp)
    80000a9c:	0800                	addi	s0,sp,16
    char* os;
    os = s;
    while ((*s++ = *t++) != 0)
    80000a9e:	87aa                	mv	a5,a0
    80000aa0:	0585                	addi	a1,a1,1
    80000aa2:	0785                	addi	a5,a5,1
    80000aa4:	fff5c703          	lbu	a4,-1(a1)
    80000aa8:	fee78fa3          	sb	a4,-1(a5) # c200fff <_entry-0x73dff001>
    80000aac:	fb75                	bnez	a4,80000aa0 <strcpy+0x8>
        ;
    return os;
}
    80000aae:	6422                	ld	s0,8(sp)
    80000ab0:	0141                	addi	sp,sp,16
    80000ab2:	8082                	ret

0000000080000ab4 <strcmp>:

int strcmp(const char* p, const char* q)
{
    80000ab4:	1141                	addi	sp,sp,-16
    80000ab6:	e422                	sd	s0,8(sp)
    80000ab8:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
    80000aba:	00054783          	lbu	a5,0(a0) # c201000 <_entry-0x73dff000>
    80000abe:	cb91                	beqz	a5,80000ad2 <strcmp+0x1e>
    80000ac0:	0005c703          	lbu	a4,0(a1)
    80000ac4:	00f71763          	bne	a4,a5,80000ad2 <strcmp+0x1e>
        p++, q++;
    80000ac8:	0505                	addi	a0,a0,1
    80000aca:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
    80000acc:	00054783          	lbu	a5,0(a0)
    80000ad0:	fbe5                	bnez	a5,80000ac0 <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
    80000ad2:	0005c503          	lbu	a0,0(a1)
}
    80000ad6:	40a7853b          	subw	a0,a5,a0
    80000ada:	6422                	ld	s0,8(sp)
    80000adc:	0141                	addi	sp,sp,16
    80000ade:	8082                	ret

0000000080000ae0 <strchr>:

char* strchr(const char* s, char c)
{
    80000ae0:	1141                	addi	sp,sp,-16
    80000ae2:	e422                	sd	s0,8(sp)
    80000ae4:	0800                	addi	s0,sp,16
    for (; *s; s++)
    80000ae6:	00054783          	lbu	a5,0(a0)
    80000aea:	cb99                	beqz	a5,80000b00 <strchr+0x20>
        if (*s == c)
    80000aec:	00f58763          	beq	a1,a5,80000afa <strchr+0x1a>
    for (; *s; s++)
    80000af0:	0505                	addi	a0,a0,1
    80000af2:	00054783          	lbu	a5,0(a0)
    80000af6:	fbfd                	bnez	a5,80000aec <strchr+0xc>
            return (char*)s;
    return 0;
    80000af8:	4501                	li	a0,0
}
    80000afa:	6422                	ld	s0,8(sp)
    80000afc:	0141                	addi	sp,sp,16
    80000afe:	8082                	ret
    return 0;
    80000b00:	4501                	li	a0,0
    80000b02:	bfe5                	j	80000afa <strchr+0x1a>

0000000080000b04 <atoi>:
//     buf[i] = '\0';
//     return buf;
// }

int atoi(const char* s)
{
    80000b04:	1141                	addi	sp,sp,-16
    80000b06:	e422                	sd	s0,8(sp)
    80000b08:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
    80000b0a:	00054603          	lbu	a2,0(a0)
    80000b0e:	fd06079b          	addiw	a5,a2,-48
    80000b12:	0ff7f793          	andi	a5,a5,255
    80000b16:	4725                	li	a4,9
    80000b18:	02f76963          	bltu	a4,a5,80000b4a <atoi+0x46>
    80000b1c:	86aa                	mv	a3,a0
    n = 0;
    80000b1e:	4501                	li	a0,0
    while ('0' <= *s && *s <= '9')
    80000b20:	45a5                	li	a1,9
        n = n * 10 + *s++ - '0';
    80000b22:	0685                	addi	a3,a3,1
    80000b24:	0025179b          	slliw	a5,a0,0x2
    80000b28:	9fa9                	addw	a5,a5,a0
    80000b2a:	0017979b          	slliw	a5,a5,0x1
    80000b2e:	9fb1                	addw	a5,a5,a2
    80000b30:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
    80000b34:	0006c603          	lbu	a2,0(a3)
    80000b38:	fd06071b          	addiw	a4,a2,-48
    80000b3c:	0ff77713          	andi	a4,a4,255
    80000b40:	fee5f1e3          	bgeu	a1,a4,80000b22 <atoi+0x1e>
    return n;
}
    80000b44:	6422                	ld	s0,8(sp)
    80000b46:	0141                	addi	sp,sp,16
    80000b48:	8082                	ret
    n = 0;
    80000b4a:	4501                	li	a0,0
    80000b4c:	bfe5                	j	80000b44 <atoi+0x40>

0000000080000b4e <memcmp>:
//     }
//     return vdst;
// }

int memcmp(const void* s1, const void* s2, uint n)
{
    80000b4e:	1141                	addi	sp,sp,-16
    80000b50:	e422                	sd	s0,8(sp)
    80000b52:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0) {
    80000b54:	ca05                	beqz	a2,80000b84 <memcmp+0x36>
    80000b56:	fff6069b          	addiw	a3,a2,-1
    80000b5a:	1682                	slli	a3,a3,0x20
    80000b5c:	9281                	srli	a3,a3,0x20
    80000b5e:	0685                	addi	a3,a3,1
    80000b60:	96aa                	add	a3,a3,a0
        if (*p1 != *p2) {
    80000b62:	00054783          	lbu	a5,0(a0)
    80000b66:	0005c703          	lbu	a4,0(a1)
    80000b6a:	00e79863          	bne	a5,a4,80000b7a <memcmp+0x2c>
            return *p1 - *p2;
        }
        p1++;
    80000b6e:	0505                	addi	a0,a0,1
        p2++;
    80000b70:	0585                	addi	a1,a1,1
    while (n-- > 0) {
    80000b72:	fed518e3          	bne	a0,a3,80000b62 <memcmp+0x14>
    }
    return 0;
    80000b76:	4501                	li	a0,0
    80000b78:	a019                	j	80000b7e <memcmp+0x30>
            return *p1 - *p2;
    80000b7a:	40e7853b          	subw	a0,a5,a4
}
    80000b7e:	6422                	ld	s0,8(sp)
    80000b80:	0141                	addi	sp,sp,16
    80000b82:	8082                	ret
    return 0;
    80000b84:	4501                	li	a0,0
    80000b86:	bfe5                	j	80000b7e <memcmp+0x30>

0000000080000b88 <memcpy>:

void* memcpy(void* dst, const void* src, uint n)
{
    80000b88:	1141                	addi	sp,sp,-16
    80000b8a:	e406                	sd	ra,8(sp)
    80000b8c:	e022                	sd	s0,0(sp)
    80000b8e:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
    80000b90:	00001097          	auipc	ra,0x1
    80000b94:	9b8080e7          	jalr	-1608(ra) # 80001548 <memmove>
}
    80000b98:	60a2                	ld	ra,8(sp)
    80000b9a:	6402                	ld	s0,0(sp)
    80000b9c:	0141                	addi	sp,sp,16
    80000b9e:	8082                	ret

0000000080000ba0 <min>:

//math utils
int min(int a, int b)
{
    80000ba0:	1141                	addi	sp,sp,-16
    80000ba2:	e422                	sd	s0,8(sp)
    80000ba4:	0800                	addi	s0,sp,16
    return a < b ? a : b;
    80000ba6:	87ae                	mv	a5,a1
    80000ba8:	00b55363          	bge	a0,a1,80000bae <min+0xe>
    80000bac:	87aa                	mv	a5,a0
}
    80000bae:	0007851b          	sext.w	a0,a5
    80000bb2:	6422                	ld	s0,8(sp)
    80000bb4:	0141                	addi	sp,sp,16
    80000bb6:	8082                	ret

0000000080000bb8 <max>:
int max(int a, int b)
{
    80000bb8:	1141                	addi	sp,sp,-16
    80000bba:	e422                	sd	s0,8(sp)
    80000bbc:	0800                	addi	s0,sp,16
    return a > b ? a : b;
    80000bbe:	87ae                	mv	a5,a1
    80000bc0:	00a5d363          	bge	a1,a0,80000bc6 <max+0xe>
    80000bc4:	87aa                	mv	a5,a0
}
    80000bc6:	0007851b          	sext.w	a0,a5
    80000bca:	6422                	ld	s0,8(sp)
    80000bcc:	0141                	addi	sp,sp,16
    80000bce:	8082                	ret

0000000080000bd0 <init_process_table>:

char stack[PGSIZE * (NPROC + 1)];

// 初始化进程表
void init_process_table()
{
    80000bd0:	1141                	addi	sp,sp,-16
    80000bd2:	e422                	sd	s0,8(sp)
    80000bd4:	0800                	addi	s0,sp,16
    struct proc* p;
    for (int i = 0; i < NPROC; i++) {
    80000bd6:	00045797          	auipc	a5,0x45
    80000bda:	7e278793          	addi	a5,a5,2018 # 800463b8 <proc_table>
    80000bde:	00004697          	auipc	a3,0x4
    80000be2:	7da68693          	addi	a3,a3,2010 # 800053b8 <stack>
    80000be6:	4701                	li	a4,0
    80000be8:	6585                	lui	a1,0x1
    80000bea:	04000613          	li	a2,64
        p = &proc_table[i];
        p->pid = i;
    80000bee:	d398                	sw	a4,32(a5)
        p->kstack = (uint64)stack + PGSIZE * i;
    80000bf0:	f794                	sd	a3,40(a5)
        p->state = UNUSED;
    80000bf2:	0007a023          	sw	zero,0(a5)
    for (int i = 0; i < NPROC; i++) {
    80000bf6:	2705                	addiw	a4,a4,1
    80000bf8:	0b078793          	addi	a5,a5,176
    80000bfc:	96ae                	add	a3,a3,a1
    80000bfe:	fec718e3          	bne	a4,a2,80000bee <init_process_table+0x1e>
    }
}
    80000c02:	6422                	ld	s0,8(sp)
    80000c04:	0141                	addi	sp,sp,16
    80000c06:	8082                	ret

0000000080000c08 <alloc_proc>:
void trapret();
void kerneltrap();

// 分配一个进程
struct proc* alloc_proc()
{
    80000c08:	1101                	addi	sp,sp,-32
    80000c0a:	ec06                	sd	ra,24(sp)
    80000c0c:	e822                	sd	s0,16(sp)
    80000c0e:	e426                	sd	s1,8(sp)
    80000c10:	1000                	addi	s0,sp,32
    struct proc* p;
    for (int i = 0; i < NPROC; i++) {
    80000c12:	00045717          	auipc	a4,0x45
    80000c16:	7a670713          	addi	a4,a4,1958 # 800463b8 <proc_table>
    80000c1a:	4781                	li	a5,0
    80000c1c:	04000613          	li	a2,64
        p = &proc_table[i];
        if (p->state == UNUSED) {
    80000c20:	4314                	lw	a3,0(a4)
    80000c22:	ca81                	beqz	a3,80000c32 <alloc_proc+0x2a>
    for (int i = 0; i < NPROC; i++) {
    80000c24:	2785                	addiw	a5,a5,1
    80000c26:	0b070713          	addi	a4,a4,176
    80000c2a:	fec79be3          	bne	a5,a2,80000c20 <alloc_proc+0x18>
            memset(&p->context, 0, sizeof(p->context));
            p->context.sp = p->kstack + PGSIZE;
            return p;
        }
    }
    return 0;
    80000c2e:	4481                	li	s1,0
    80000c30:	a80d                	j	80000c62 <alloc_proc+0x5a>
    80000c32:	0b000513          	li	a0,176
    80000c36:	02a787b3          	mul	a5,a5,a0
        p = &proc_table[i];
    80000c3a:	00045517          	auipc	a0,0x45
    80000c3e:	77e50513          	addi	a0,a0,1918 # 800463b8 <proc_table>
    80000c42:	00a784b3          	add	s1,a5,a0
            memset(&p->context, 0, sizeof(p->context));
    80000c46:	03078793          	addi	a5,a5,48
    80000c4a:	07000613          	li	a2,112
    80000c4e:	4581                	li	a1,0
    80000c50:	953e                	add	a0,a0,a5
    80000c52:	00001097          	auipc	ra,0x1
    80000c56:	8d0080e7          	jalr	-1840(ra) # 80001522 <memset>
            p->context.sp = p->kstack + PGSIZE;
    80000c5a:	749c                	ld	a5,40(s1)
    80000c5c:	6705                	lui	a4,0x1
    80000c5e:	97ba                	add	a5,a5,a4
    80000c60:	fc9c                	sd	a5,56(s1)
}
    80000c62:	8526                	mv	a0,s1
    80000c64:	60e2                	ld	ra,24(sp)
    80000c66:	6442                	ld	s0,16(sp)
    80000c68:	64a2                	ld	s1,8(sp)
    80000c6a:	6105                	addi	sp,sp,32
    80000c6c:	8082                	ret

0000000080000c6e <init_first_process>:
{
    80000c6e:	1141                	addi	sp,sp,-16
    80000c70:	e406                	sd	ra,8(sp)
    80000c72:	e022                	sd	s0,0(sp)
    80000c74:	0800                	addi	s0,sp,16
    struct proc* p = alloc_proc();
    80000c76:	00000097          	auipc	ra,0x0
    80000c7a:	f92080e7          	jalr	-110(ra) # 80000c08 <alloc_proc>
    p->context.ra = (uint64)init;
    80000c7e:	00000797          	auipc	a5,0x0
    80000c82:	7f678793          	addi	a5,a5,2038 # 80001474 <init>
    80000c86:	f91c                	sd	a5,48(a0)
    p->state = RUNNABLE;
    80000c88:	4789                	li	a5,2
    80000c8a:	c11c                	sw	a5,0(a0)
    initproc = p;
    80000c8c:	00003797          	auipc	a5,0x3
    80000c90:	38a7b623          	sd	a0,908(a5) # 80004018 <initproc>
}
    80000c94:	60a2                	ld	ra,8(sp)
    80000c96:	6402                	ld	s0,0(sp)
    80000c98:	0141                	addi	sp,sp,16
    80000c9a:	8082                	ret

0000000080000c9c <cpuid>:
    }
}

// 获取当前cpu的id
int cpuid()
{
    80000c9c:	1141                	addi	sp,sp,-16
    80000c9e:	e422                	sd	s0,8(sp)
    80000ca0:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000ca2:	8512                	mv	a0,tp
    int id = r_tp();
    return id;
}
    80000ca4:	2501                	sext.w	a0,a0
    80000ca6:	6422                	ld	s0,8(sp)
    80000ca8:	0141                	addi	sp,sp,16
    80000caa:	8082                	ret

0000000080000cac <mycpu>:

// 获取当前cpu
struct cpu* mycpu(void)
{
    80000cac:	1141                	addi	sp,sp,-16
    80000cae:	e422                	sd	s0,8(sp)
    80000cb0:	0800                	addi	s0,sp,16
    80000cb2:	8792                	mv	a5,tp
    int id = cpuid();
    struct cpu* c = &cpus[id];
    80000cb4:	2781                	sext.w	a5,a5
    80000cb6:	079e                	slli	a5,a5,0x7
    return c;
}
    80000cb8:	00004517          	auipc	a0,0x4
    80000cbc:	53850513          	addi	a0,a0,1336 # 800051f0 <cpus>
    80000cc0:	953e                	add	a0,a0,a5
    80000cc2:	6422                	ld	s0,8(sp)
    80000cc4:	0141                	addi	sp,sp,16
    80000cc6:	8082                	ret

0000000080000cc8 <myproc>:

// 获取当前进程
struct proc* myproc()
{
    80000cc8:	1141                	addi	sp,sp,-16
    80000cca:	e422                	sd	s0,8(sp)
    80000ccc:	0800                	addi	s0,sp,16
    80000cce:	8792                	mv	a5,tp
    return mycpu()->proc;
    80000cd0:	2781                	sext.w	a5,a5
    80000cd2:	079e                	slli	a5,a5,0x7
    80000cd4:	00004717          	auipc	a4,0x4
    80000cd8:	51c70713          	addi	a4,a4,1308 # 800051f0 <cpus>
    80000cdc:	97ba                	add	a5,a5,a4
}
    80000cde:	6388                	ld	a0,0(a5)
    80000ce0:	6422                	ld	s0,8(sp)
    80000ce2:	0141                	addi	sp,sp,16
    80000ce4:	8082                	ret

0000000080000ce6 <sleep>:

// 睡眠在chan上
void sleep(void* chan)
{
    80000ce6:	1141                	addi	sp,sp,-16
    80000ce8:	e406                	sd	ra,8(sp)
    80000cea:	e022                	sd	s0,0(sp)
    80000cec:	0800                	addi	s0,sp,16
    80000cee:	8792                	mv	a5,tp
    return mycpu()->proc;
    80000cf0:	00004597          	auipc	a1,0x4
    80000cf4:	50058593          	addi	a1,a1,1280 # 800051f0 <cpus>
    80000cf8:	2781                	sext.w	a5,a5
    80000cfa:	079e                	slli	a5,a5,0x7
    80000cfc:	97ae                	add	a5,a5,a1
    80000cfe:	6398                	ld	a4,0(a5)
    struct proc* p;
    p = myproc();
    p->state = SLEEPING;
    80000d00:	4785                	li	a5,1
    80000d02:	c31c                	sw	a5,0(a4)
    p->chan = chan;
    80000d04:	eb08                	sd	a0,16(a4)
    80000d06:	8792                	mv	a5,tp
    pswitch(&p->context, &mycpu()->context);
    80000d08:	2781                	sext.w	a5,a5
    80000d0a:	079e                	slli	a5,a5,0x7
    80000d0c:	07a1                	addi	a5,a5,8
    80000d0e:	95be                	add	a1,a1,a5
    80000d10:	03070513          	addi	a0,a4,48
    80000d14:	00001097          	auipc	ra,0x1
    80000d18:	8ba080e7          	jalr	-1862(ra) # 800015ce <pswitch>
}
    80000d1c:	60a2                	ld	ra,8(sp)
    80000d1e:	6402                	ld	s0,0(sp)
    80000d20:	0141                	addi	sp,sp,16
    80000d22:	8082                	ret

0000000080000d24 <sleep_time>:

// 睡眠一定时间
void sleep_time(uint64 sleep_ticks)
{
    80000d24:	7179                	addi	sp,sp,-48
    80000d26:	f406                	sd	ra,40(sp)
    80000d28:	f022                	sd	s0,32(sp)
    80000d2a:	ec26                	sd	s1,24(sp)
    80000d2c:	e84a                	sd	s2,16(sp)
    80000d2e:	e44e                	sd	s3,8(sp)
    80000d30:	1800                	addi	s0,sp,48
    uint64 now = ticks;
    80000d32:	00003997          	auipc	s3,0x3
    80000d36:	2de9b983          	ld	s3,734(s3) # 80004010 <ticks>
    for (; ticks - now < sleep_ticks;) {
    80000d3a:	c105                	beqz	a0,80000d5a <sleep_time+0x36>
    80000d3c:	892a                	mv	s2,a0
        sleep(&ticks);
    80000d3e:	00003497          	auipc	s1,0x3
    80000d42:	2d248493          	addi	s1,s1,722 # 80004010 <ticks>
    80000d46:	8526                	mv	a0,s1
    80000d48:	00000097          	auipc	ra,0x0
    80000d4c:	f9e080e7          	jalr	-98(ra) # 80000ce6 <sleep>
    for (; ticks - now < sleep_ticks;) {
    80000d50:	609c                	ld	a5,0(s1)
    80000d52:	413787b3          	sub	a5,a5,s3
    80000d56:	ff27e8e3          	bltu	a5,s2,80000d46 <sleep_time+0x22>
    }
}
    80000d5a:	70a2                	ld	ra,40(sp)
    80000d5c:	7402                	ld	s0,32(sp)
    80000d5e:	64e2                	ld	s1,24(sp)
    80000d60:	6942                	ld	s2,16(sp)
    80000d62:	69a2                	ld	s3,8(sp)
    80000d64:	6145                	addi	sp,sp,48
    80000d66:	8082                	ret

0000000080000d68 <wakeup>:

// 唤醒指定chan上的进程
void wakeup(void* chan)
{
    80000d68:	1141                	addi	sp,sp,-16
    80000d6a:	e422                	sd	s0,8(sp)
    80000d6c:	0800                	addi	s0,sp,16
    struct proc* p;
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80000d6e:	00045797          	auipc	a5,0x45
    80000d72:	64a78793          	addi	a5,a5,1610 # 800463b8 <proc_table>
        if (p->state == SLEEPING && p->chan == chan) {
    80000d76:	4605                	li	a2,1
            p->state = RUNNABLE;
    80000d78:	4589                	li	a1,2
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80000d7a:	00048697          	auipc	a3,0x48
    80000d7e:	23e68693          	addi	a3,a3,574 # 80048fb8 <proc_table+0x2c00>
    80000d82:	a031                	j	80000d8e <wakeup+0x26>
            p->state = RUNNABLE;
    80000d84:	c38c                	sw	a1,0(a5)
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80000d86:	0b078793          	addi	a5,a5,176
    80000d8a:	00d78963          	beq	a5,a3,80000d9c <wakeup+0x34>
        if (p->state == SLEEPING && p->chan == chan) {
    80000d8e:	4398                	lw	a4,0(a5)
    80000d90:	fec71be3          	bne	a4,a2,80000d86 <wakeup+0x1e>
    80000d94:	6b98                	ld	a4,16(a5)
    80000d96:	fea718e3          	bne	a4,a0,80000d86 <wakeup+0x1e>
    80000d9a:	b7ed                	j	80000d84 <wakeup+0x1c>
        }
    }
}
    80000d9c:	6422                	ld	s0,8(sp)
    80000d9e:	0141                	addi	sp,sp,16
    80000da0:	8082                	ret

0000000080000da2 <scheduler>:
{
    80000da2:	711d                	addi	sp,sp,-96
    80000da4:	ec86                	sd	ra,88(sp)
    80000da6:	e8a2                	sd	s0,80(sp)
    80000da8:	e4a6                	sd	s1,72(sp)
    80000daa:	e0ca                	sd	s2,64(sp)
    80000dac:	fc4e                	sd	s3,56(sp)
    80000dae:	f852                	sd	s4,48(sp)
    80000db0:	f456                	sd	s5,40(sp)
    80000db2:	f05a                	sd	s6,32(sp)
    80000db4:	ec5e                	sd	s7,24(sp)
    80000db6:	e862                	sd	s8,16(sp)
    80000db8:	e466                	sd	s9,8(sp)
    80000dba:	e06a                	sd	s10,0(sp)
    80000dbc:	1080                	addi	s0,sp,96
    80000dbe:	8792                	mv	a5,tp
    int id = r_tp();
    80000dc0:	2781                	sext.w	a5,a5
                pswitch(&c->context, &p->context);
    80000dc2:	00779c93          	slli	s9,a5,0x7
    80000dc6:	00004717          	auipc	a4,0x4
    80000dca:	43270713          	addi	a4,a4,1074 # 800051f8 <cpus+0x8>
    80000dce:	9cba                	add	s9,s9,a4
                wakeup(initproc);
    80000dd0:	00003d17          	auipc	s10,0x3
    80000dd4:	248d0d13          	addi	s10,s10,584 # 80004018 <initproc>
            if (p->state == RUNNABLE) {
    80000dd8:	4a89                	li	s5,2
                c->proc = p;
    80000dda:	079e                	slli	a5,a5,0x7
    80000ddc:	00004b97          	auipc	s7,0x4
    80000de0:	414b8b93          	addi	s7,s7,1044 # 800051f0 <cpus>
    80000de4:	9bbe                	add	s7,s7,a5
    80000de6:	a0b9                	j	80000e34 <scheduler+0x92>
        for (int i = 0; i < NPROC; i++) {
    80000de8:	0b048493          	addi	s1,s1,176
    80000dec:	03348a63          	beq	s1,s3,80000e20 <scheduler+0x7e>
            if (p->state != UNUSED && p->state != ZOMBIE) {
    80000df0:	8926                	mv	s2,s1
    80000df2:	409c                	lw	a5,0(s1)
    80000df4:	dbf5                	beqz	a5,80000de8 <scheduler+0x46>
    80000df6:	07678163          	beq	a5,s6,80000e58 <scheduler+0xb6>
                alive_p++;
    80000dfa:	2a05                	addiw	s4,s4,1
            if (p->state == RUNNABLE) {
    80000dfc:	00092783          	lw	a5,0(s2)
    80000e00:	ff5794e3          	bne	a5,s5,80000de8 <scheduler+0x46>
                p->state = RUNNING;
    80000e04:	01892023          	sw	s8,0(s2)
                c->proc = p;
    80000e08:	012bb023          	sd	s2,0(s7)
                pswitch(&c->context, &p->context);
    80000e0c:	03048593          	addi	a1,s1,48
    80000e10:	8566                	mv	a0,s9
    80000e12:	00000097          	auipc	ra,0x0
    80000e16:	7bc080e7          	jalr	1980(ra) # 800015ce <pswitch>
                c->proc = 0;
    80000e1a:	000bb023          	sd	zero,0(s7)
    80000e1e:	b7e9                	j	80000de8 <scheduler+0x46>
        if (alive_p <= 2) {
    80000e20:	014aca63          	blt	s5,s4,80000e34 <scheduler+0x92>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000e24:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000e28:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000e2c:	10079073          	csrw	sstatus,a5
            asm volatile("wfi");
    80000e30:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000e34:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000e38:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000e3c:	10079073          	csrw	sstatus,a5
        for (int i = 0; i < NPROC; i++) {
    80000e40:	00045497          	auipc	s1,0x45
    80000e44:	57848493          	addi	s1,s1,1400 # 800463b8 <proc_table>
    80000e48:	00048997          	auipc	s3,0x48
    80000e4c:	17098993          	addi	s3,s3,368 # 80048fb8 <proc_table+0x2c00>
        alive_p = 0;
    80000e50:	4a01                	li	s4,0
            if (p->state != UNUSED && p->state != ZOMBIE) {
    80000e52:	4b11                	li	s6,4
                p->state = RUNNING;
    80000e54:	4c0d                	li	s8,3
    80000e56:	bf69                	j	80000df0 <scheduler+0x4e>
                wakeup(initproc);
    80000e58:	000d3503          	ld	a0,0(s10)
    80000e5c:	00000097          	auipc	ra,0x0
    80000e60:	f0c080e7          	jalr	-244(ra) # 80000d68 <wakeup>
    80000e64:	bf61                	j	80000dfc <scheduler+0x5a>

0000000080000e66 <wait>:
// 等待子进程退出, 返回其子进程id
// 没有子进程返回-1， 将退出状态复
// 制到status中。
//
int wait(int* status)
{
    80000e66:	7139                	addi	sp,sp,-64
    80000e68:	fc06                	sd	ra,56(sp)
    80000e6a:	f822                	sd	s0,48(sp)
    80000e6c:	f426                	sd	s1,40(sp)
    80000e6e:	f04a                	sd	s2,32(sp)
    80000e70:	ec4e                	sd	s3,24(sp)
    80000e72:	e852                	sd	s4,16(sp)
    80000e74:	e456                	sd	s5,8(sp)
    80000e76:	e05a                	sd	s6,0(sp)
    80000e78:	0080                	addi	s0,sp,64
    80000e7a:	8aaa                	mv	s5,a0
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e7c:	8792                	mv	a5,tp
    return mycpu()->proc;
    80000e7e:	2781                	sext.w	a5,a5
    80000e80:	079e                	slli	a5,a5,0x7
    80000e82:	00004717          	auipc	a4,0x4
    80000e86:	36e70713          	addi	a4,a4,878 # 800051f0 <cpus>
    80000e8a:	97ba                	add	a5,a5,a4
    80000e8c:	6384                	ld	s1,0(a5)
    struct proc* cp; // 子进程
    struct proc* p;
    int havechild, pid;
    p = myproc();
    for (;;) {
        havechild = 0;
    80000e8e:	4b01                	li	s6,0
        for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
            if (cp->parent == p) {
                havechild = 1;
                if (cp->state == ZOMBIE) {
    80000e90:	4991                	li	s3,4
        for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    80000e92:	00048917          	auipc	s2,0x48
    80000e96:	12690913          	addi	s2,s2,294 # 80048fb8 <proc_table+0x2c00>
                havechild = 1;
    80000e9a:	4a05                	li	s4,1
        havechild = 0;
    80000e9c:	86da                	mv	a3,s6
        for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    80000e9e:	00045797          	auipc	a5,0x45
    80000ea2:	51a78793          	addi	a5,a5,1306 # 800463b8 <proc_table>
    80000ea6:	a03d                	j	80000ed4 <wait+0x6e>
                    pid = cp->pid;
    80000ea8:	5388                	lw	a0,32(a5)
                    if (status) {
    80000eaa:	000a8563          	beqz	s5,80000eb4 <wait+0x4e>
                        *status = cp->xstate;
    80000eae:	4fd8                	lw	a4,28(a5)
    80000eb0:	00eaa023          	sw	a4,0(s5)
                    }
                    cp->state = UNUSED;
    80000eb4:	0007a023          	sw	zero,0(a5)
        if (!havechild) {
            return -1;
        }
        sleep(p); // 等待子进程唤醒
    }
}
    80000eb8:	70e2                	ld	ra,56(sp)
    80000eba:	7442                	ld	s0,48(sp)
    80000ebc:	74a2                	ld	s1,40(sp)
    80000ebe:	7902                	ld	s2,32(sp)
    80000ec0:	69e2                	ld	s3,24(sp)
    80000ec2:	6a42                	ld	s4,16(sp)
    80000ec4:	6aa2                	ld	s5,8(sp)
    80000ec6:	6b02                	ld	s6,0(sp)
    80000ec8:	6121                	addi	sp,sp,64
    80000eca:	8082                	ret
        for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    80000ecc:	0b078793          	addi	a5,a5,176
    80000ed0:	01278a63          	beq	a5,s2,80000ee4 <wait+0x7e>
            if (cp->parent == p) {
    80000ed4:	6798                	ld	a4,8(a5)
    80000ed6:	fe971be3          	bne	a4,s1,80000ecc <wait+0x66>
                if (cp->state == ZOMBIE) {
    80000eda:	4398                	lw	a4,0(a5)
    80000edc:	fd3706e3          	beq	a4,s3,80000ea8 <wait+0x42>
                havechild = 1;
    80000ee0:	86d2                	mv	a3,s4
    80000ee2:	b7ed                	j	80000ecc <wait+0x66>
        if (!havechild) {
    80000ee4:	e299                	bnez	a3,80000eea <wait+0x84>
            return -1;
    80000ee6:	557d                	li	a0,-1
    80000ee8:	bfc1                	j	80000eb8 <wait+0x52>
        sleep(p); // 等待子进程唤醒
    80000eea:	8526                	mv	a0,s1
    80000eec:	00000097          	auipc	ra,0x0
    80000ef0:	dfa080e7          	jalr	-518(ra) # 80000ce6 <sleep>
        havechild = 0;
    80000ef4:	b765                	j	80000e9c <wait+0x36>

0000000080000ef6 <exit>:
// 若父进程已经exit, 则会由init进
// 程来完成父进程在exit时，会将其
// 子进程的parent设置为init进程
//
void exit(int status)
{
    80000ef6:	1141                	addi	sp,sp,-16
    80000ef8:	e406                	sd	ra,8(sp)
    80000efa:	e022                	sd	s0,0(sp)
    80000efc:	0800                	addi	s0,sp,16
    80000efe:	8792                	mv	a5,tp
    return mycpu()->proc;
    80000f00:	2781                	sext.w	a5,a5
    80000f02:	079e                	slli	a5,a5,0x7
    80000f04:	00004717          	auipc	a4,0x4
    80000f08:	2ec70713          	addi	a4,a4,748 # 800051f0 <cpus>
    80000f0c:	97ba                	add	a5,a5,a4
    80000f0e:	6394                	ld	a3,0(a5)
    struct proc *p, *cp;
    p = myproc();
    p->state = ZOMBIE;
    80000f10:	4791                	li	a5,4
    80000f12:	c29c                	sw	a5,0(a3)
    p->xstate = status;
    80000f14:	cec8                	sw	a0,28(a3)
    for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
        if (cp->parent == p) {
            cp->parent = initproc;
    80000f16:	00003597          	auipc	a1,0x3
    80000f1a:	1025b583          	ld	a1,258(a1) # 80004018 <initproc>
    for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    80000f1e:	00045797          	auipc	a5,0x45
    80000f22:	49a78793          	addi	a5,a5,1178 # 800463b8 <proc_table>
    80000f26:	00048617          	auipc	a2,0x48
    80000f2a:	09260613          	addi	a2,a2,146 # 80048fb8 <proc_table+0x2c00>
    80000f2e:	a031                	j	80000f3a <exit+0x44>
            cp->parent = initproc;
    80000f30:	e78c                	sd	a1,8(a5)
    for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    80000f32:	0b078793          	addi	a5,a5,176
    80000f36:	00c78663          	beq	a5,a2,80000f42 <exit+0x4c>
        if (cp->parent == p) {
    80000f3a:	6798                	ld	a4,8(a5)
    80000f3c:	fed71be3          	bne	a4,a3,80000f32 <exit+0x3c>
    80000f40:	bfc5                	j	80000f30 <exit+0x3a>
        }
    }
    wakeup(p->parent);
    80000f42:	6688                	ld	a0,8(a3)
    80000f44:	00000097          	auipc	ra,0x0
    80000f48:	e24080e7          	jalr	-476(ra) # 80000d68 <wakeup>
    80000f4c:	8712                	mv	a4,tp
    80000f4e:	8792                	mv	a5,tp
    pswitch(&(myproc()->context), &(mycpu()->context));
    80000f50:	00004597          	auipc	a1,0x4
    80000f54:	2a058593          	addi	a1,a1,672 # 800051f0 <cpus>
    80000f58:	2781                	sext.w	a5,a5
    80000f5a:	079e                	slli	a5,a5,0x7
    80000f5c:	07a1                	addi	a5,a5,8
    return mycpu()->proc;
    80000f5e:	2701                	sext.w	a4,a4
    80000f60:	071e                	slli	a4,a4,0x7
    80000f62:	972e                	add	a4,a4,a1
    pswitch(&(myproc()->context), &(mycpu()->context));
    80000f64:	6308                	ld	a0,0(a4)
    80000f66:	95be                	add	a1,a1,a5
    80000f68:	03050513          	addi	a0,a0,48
    80000f6c:	00000097          	auipc	ra,0x0
    80000f70:	662080e7          	jalr	1634(ra) # 800015ce <pswitch>
}
    80000f74:	60a2                	ld	ra,8(sp)
    80000f76:	6402                	ld	s0,0(sp)
    80000f78:	0141                	addi	sp,sp,16
    80000f7a:	8082                	ret

0000000080000f7c <hello>:

void hello()
{
    80000f7c:	1141                	addi	sp,sp,-16
    80000f7e:	e406                	sd	ra,8(sp)
    80000f80:	e022                	sd	s0,0(sp)
    80000f82:	0800                	addi	s0,sp,16
    puts("Hello, world!\n\t\tfrom startOS with osh");
    80000f84:	00002517          	auipc	a0,0x2
    80000f88:	15c50513          	addi	a0,a0,348 # 800030e0 <digits+0xa8>
    80000f8c:	fffff097          	auipc	ra,0xfffff
    80000f90:	56c080e7          	jalr	1388(ra) # 800004f8 <puts>
    exit(0);
    80000f94:	4501                	li	a0,0
    80000f96:	00000097          	auipc	ra,0x0
    80000f9a:	f60080e7          	jalr	-160(ra) # 80000ef6 <exit>
}
    80000f9e:	60a2                	ld	ra,8(sp)
    80000fa0:	6402                	ld	s0,0(sp)
    80000fa2:	0141                	addi	sp,sp,16
    80000fa4:	8082                	ret

0000000080000fa6 <cowsay>:
void cowsay(){
    80000fa6:	1141                	addi	sp,sp,-16
    80000fa8:	e406                	sd	ra,8(sp)
    80000faa:	e022                	sd	s0,0(sp)
    80000fac:	0800                	addi	s0,sp,16
    puts("    ____________");
    80000fae:	00002517          	auipc	a0,0x2
    80000fb2:	15a50513          	addi	a0,a0,346 # 80003108 <digits+0xd0>
    80000fb6:	fffff097          	auipc	ra,0xfffff
    80000fba:	542080e7          	jalr	1346(ra) # 800004f8 <puts>
    puts("    < hi, there >");
    80000fbe:	00002517          	auipc	a0,0x2
    80000fc2:	16250513          	addi	a0,a0,354 # 80003120 <digits+0xe8>
    80000fc6:	fffff097          	auipc	ra,0xfffff
    80000fca:	532080e7          	jalr	1330(ra) # 800004f8 <puts>
    puts("    ------------");
    80000fce:	00002517          	auipc	a0,0x2
    80000fd2:	16a50513          	addi	a0,a0,362 # 80003138 <digits+0x100>
    80000fd6:	fffff097          	auipc	ra,0xfffff
    80000fda:	522080e7          	jalr	1314(ra) # 800004f8 <puts>
    puts("         \\   ^__^");
    80000fde:	00002517          	auipc	a0,0x2
    80000fe2:	17250513          	addi	a0,a0,370 # 80003150 <digits+0x118>
    80000fe6:	fffff097          	auipc	ra,0xfffff
    80000fea:	512080e7          	jalr	1298(ra) # 800004f8 <puts>
    puts("          \\  (oo)\\_______");
    80000fee:	00002517          	auipc	a0,0x2
    80000ff2:	17a50513          	addi	a0,a0,378 # 80003168 <digits+0x130>
    80000ff6:	fffff097          	auipc	ra,0xfffff
    80000ffa:	502080e7          	jalr	1282(ra) # 800004f8 <puts>
    puts("             (__)\\       )\\/\\");
    80000ffe:	00002517          	auipc	a0,0x2
    80001002:	18a50513          	addi	a0,a0,394 # 80003188 <digits+0x150>
    80001006:	fffff097          	auipc	ra,0xfffff
    8000100a:	4f2080e7          	jalr	1266(ra) # 800004f8 <puts>
    puts("                 ||----w |");
    8000100e:	00002517          	auipc	a0,0x2
    80001012:	19a50513          	addi	a0,a0,410 # 800031a8 <digits+0x170>
    80001016:	fffff097          	auipc	ra,0xfffff
    8000101a:	4e2080e7          	jalr	1250(ra) # 800004f8 <puts>
    puts("                 ||     ||");
    8000101e:	00002517          	auipc	a0,0x2
    80001022:	1aa50513          	addi	a0,a0,426 # 800031c8 <digits+0x190>
    80001026:	fffff097          	auipc	ra,0xfffff
    8000102a:	4d2080e7          	jalr	1234(ra) # 800004f8 <puts>
    exit(0);
    8000102e:	4501                	li	a0,0
    80001030:	00000097          	auipc	ra,0x0
    80001034:	ec6080e7          	jalr	-314(ra) # 80000ef6 <exit>
}
    80001038:	60a2                	ld	ra,8(sp)
    8000103a:	6402                	ld	s0,0(sp)
    8000103c:	0141                	addi	sp,sp,16
    8000103e:	8082                	ret

0000000080001040 <mew>:
void mew(){
    80001040:	1141                	addi	sp,sp,-16
    80001042:	e406                	sd	ra,8(sp)
    80001044:	e022                	sd	s0,0(sp)
    80001046:	0800                	addi	s0,sp,16
    puts("          ＿＿");
    80001048:	00002517          	auipc	a0,0x2
    8000104c:	1a050513          	addi	a0,a0,416 # 800031e8 <digits+0x1b0>
    80001050:	fffff097          	auipc	ra,0xfffff
    80001054:	4a8080e7          	jalr	1192(ra) # 800004f8 <puts>
    puts("　　　／＞　　フ");
    80001058:	00002517          	auipc	a0,0x2
    8000105c:	1a850513          	addi	a0,a0,424 # 80003200 <digits+0x1c8>
    80001060:	fffff097          	auipc	ra,0xfffff
    80001064:	498080e7          	jalr	1176(ra) # 800004f8 <puts>
    puts("　　　|   _　 _ |");
    80001068:	00002517          	auipc	a0,0x2
    8000106c:	1b850513          	addi	a0,a0,440 # 80003220 <digits+0x1e8>
    80001070:	fffff097          	auipc	ra,0xfffff
    80001074:	488080e7          	jalr	1160(ra) # 800004f8 <puts>
    puts("　　／`  ミ＿xノ");
    80001078:	00002517          	auipc	a0,0x2
    8000107c:	1c050513          	addi	a0,a0,448 # 80003238 <digits+0x200>
    80001080:	fffff097          	auipc	ra,0xfffff
    80001084:	478080e7          	jalr	1144(ra) # 800004f8 <puts>
    puts(" 　 /　　　 　 |");
    80001088:	00002517          	auipc	a0,0x2
    8000108c:	1c850513          	addi	a0,a0,456 # 80003250 <digits+0x218>
    80001090:	fffff097          	auipc	ra,0xfffff
    80001094:	468080e7          	jalr	1128(ra) # 800004f8 <puts>
    puts("　 /　 ヽ　　 ﾉ");
    80001098:	00002517          	auipc	a0,0x2
    8000109c:	1d050513          	addi	a0,a0,464 # 80003268 <digits+0x230>
    800010a0:	fffff097          	auipc	ra,0xfffff
    800010a4:	458080e7          	jalr	1112(ra) # 800004f8 <puts>
    exit(0);
    800010a8:	4501                	li	a0,0
    800010aa:	00000097          	auipc	ra,0x0
    800010ae:	e4c080e7          	jalr	-436(ra) # 80000ef6 <exit>
    800010b2:	60a2                	ld	ra,8(sp)
    800010b4:	6402                	ld	s0,0(sp)
    800010b6:	0141                	addi	sp,sp,16
    800010b8:	8082                	ret

00000000800010ba <help>:
//#include "user/usertests.c"

void showHistory();

void help()
{
    800010ba:	1141                	addi	sp,sp,-16
    800010bc:	e406                	sd	ra,8(sp)
    800010be:	e022                	sd	s0,0(sp)
    800010c0:	0800                	addi	s0,sp,16
    puts("All available commmands:");
    800010c2:	00002517          	auipc	a0,0x2
    800010c6:	1be50513          	addi	a0,a0,446 # 80003280 <digits+0x248>
    800010ca:	fffff097          	auipc	ra,0xfffff
    800010ce:	42e080e7          	jalr	1070(ra) # 800004f8 <puts>
    puts("help\tshow this helping message");
    800010d2:	00002517          	auipc	a0,0x2
    800010d6:	1ce50513          	addi	a0,a0,462 # 800032a0 <digits+0x268>
    800010da:	fffff097          	auipc	ra,0xfffff
    800010de:	41e080e7          	jalr	1054(ra) # 800004f8 <puts>
    puts("hello\tprint test hello world message");
    800010e2:	00002517          	auipc	a0,0x2
    800010e6:	1de50513          	addi	a0,a0,478 # 800032c0 <digits+0x288>
    800010ea:	fffff097          	auipc	ra,0xfffff
    800010ee:	40e080e7          	jalr	1038(ra) # 800004f8 <puts>
    puts("history\tshow recent commands you input");
    800010f2:	00002517          	auipc	a0,0x2
    800010f6:	1f650513          	addi	a0,a0,502 # 800032e8 <digits+0x2b0>
    800010fa:	fffff097          	auipc	ra,0xfffff
    800010fe:	3fe080e7          	jalr	1022(ra) # 800004f8 <puts>
    puts("usertests\texec test function");
    80001102:	00002517          	auipc	a0,0x2
    80001106:	20e50513          	addi	a0,a0,526 # 80003310 <digits+0x2d8>
    8000110a:	fffff097          	auipc	ra,0xfffff
    8000110e:	3ee080e7          	jalr	1006(ra) # 800004f8 <puts>
    puts("cowsay\tcowsay");
    80001112:	00002517          	auipc	a0,0x2
    80001116:	21e50513          	addi	a0,a0,542 # 80003330 <digits+0x2f8>
    8000111a:	fffff097          	auipc	ra,0xfffff
    8000111e:	3de080e7          	jalr	990(ra) # 800004f8 <puts>
    puts("mew\tmew mew");
    80001122:	00002517          	auipc	a0,0x2
    80001126:	21e50513          	addi	a0,a0,542 # 80003340 <digits+0x308>
    8000112a:	fffff097          	auipc	ra,0xfffff
    8000112e:	3ce080e7          	jalr	974(ra) # 800004f8 <puts>
    exit(0);
    80001132:	4501                	li	a0,0
    80001134:	00000097          	auipc	ra,0x0
    80001138:	dc2080e7          	jalr	-574(ra) # 80000ef6 <exit>
}
    8000113c:	60a2                	ld	ra,8(sp)
    8000113e:	6402                	ld	s0,0(sp)
    80001140:	0141                	addi	sp,sp,16
    80001142:	8082                	ret

0000000080001144 <showHistory>:
    }
    exit(0);
}

void showHistory()
{
    80001144:	715d                	addi	sp,sp,-80
    80001146:	e486                	sd	ra,72(sp)
    80001148:	e0a2                	sd	s0,64(sp)
    8000114a:	fc26                	sd	s1,56(sp)
    8000114c:	f84a                	sd	s2,48(sp)
    8000114e:	f44e                	sd	s3,40(sp)
    80001150:	f052                	sd	s4,32(sp)
    80001152:	ec56                	sd	s5,24(sp)
    80001154:	e85a                	sd	s6,16(sp)
    80001156:	e45e                	sd	s7,8(sp)
    80001158:	0880                	addi	s0,sp,80
    int startP=h.currentP;
    for (int k = MAX_HISTORY_NUM, i = (MAX_HISTORY_NUM + startP) % MAX_HISTORY_NUM; k > 0; i++, k--) {
    8000115a:	00004497          	auipc	s1,0x4
    8000115e:	2564a483          	lw	s1,598(s1) # 800053b0 <h+0x140>
    80001162:	2495                	addiw	s1,s1,5
    80001164:	4795                	li	a5,5
    80001166:	02f4e4bb          	remw	s1,s1,a5
    8000116a:	4915                	li	s2,5
        if (i >= MAX_HISTORY_NUM)
            i = i % MAX_HISTORY_NUM;
        if (h.cmdlist[i][0] == '\0') 
    8000116c:	00004997          	auipc	s3,0x4
    80001170:	08498993          	addi	s3,s3,132 # 800051f0 <cpus>
            continue;
        else {
            printf("#%d\t%s\n", k, h.cmdlist[i]);
    80001174:	00004b97          	auipc	s7,0x4
    80001178:	0fcb8b93          	addi	s7,s7,252 # 80005270 <h>
    8000117c:	00002b17          	auipc	s6,0x2
    80001180:	1d4b0b13          	addi	s6,s6,468 # 80003350 <digits+0x318>
        if (i >= MAX_HISTORY_NUM)
    80001184:	4a11                	li	s4,4
            i = i % MAX_HISTORY_NUM;
    80001186:	4a95                	li	s5,5
    80001188:	a821                	j	800011a0 <showHistory+0x5c>
    for (int k = MAX_HISTORY_NUM, i = (MAX_HISTORY_NUM + startP) % MAX_HISTORY_NUM; k > 0; i++, k--) {
    8000118a:	0014879b          	addiw	a5,s1,1
    8000118e:	0007849b          	sext.w	s1,a5
    80001192:	397d                	addiw	s2,s2,-1
    80001194:	02090763          	beqz	s2,800011c2 <showHistory+0x7e>
        if (i >= MAX_HISTORY_NUM)
    80001198:	009a5463          	bge	s4,s1,800011a0 <showHistory+0x5c>
            i = i % MAX_HISTORY_NUM;
    8000119c:	0357e4bb          	remw	s1,a5,s5
    800011a0:	0009059b          	sext.w	a1,s2
        if (h.cmdlist[i][0] == '\0') 
    800011a4:	00649793          	slli	a5,s1,0x6
    800011a8:	97ce                	add	a5,a5,s3
    800011aa:	0807c783          	lbu	a5,128(a5)
    800011ae:	dff1                	beqz	a5,8000118a <showHistory+0x46>
            printf("#%d\t%s\n", k, h.cmdlist[i]);
    800011b0:	00649613          	slli	a2,s1,0x6
    800011b4:	965e                	add	a2,a2,s7
    800011b6:	855a                	mv	a0,s6
    800011b8:	fffff097          	auipc	ra,0xfffff
    800011bc:	30a080e7          	jalr	778(ra) # 800004c2 <printf>
    800011c0:	b7e9                	j	8000118a <showHistory+0x46>
        }
    }
    exit(0);
    800011c2:	4501                	li	a0,0
    800011c4:	00000097          	auipc	ra,0x0
    800011c8:	d32080e7          	jalr	-718(ra) # 80000ef6 <exit>
}
    800011cc:	60a6                	ld	ra,72(sp)
    800011ce:	6406                	ld	s0,64(sp)
    800011d0:	74e2                	ld	s1,56(sp)
    800011d2:	7942                	ld	s2,48(sp)
    800011d4:	79a2                	ld	s3,40(sp)
    800011d6:	7a02                	ld	s4,32(sp)
    800011d8:	6ae2                	ld	s5,24(sp)
    800011da:	6b42                	ld	s6,16(sp)
    800011dc:	6ba2                	ld	s7,8(sp)
    800011de:	6161                	addi	sp,sp,80
    800011e0:	8082                	ret

00000000800011e2 <exec>:

void execra(struct context*, struct context*, uint64);

// 使进程执行其他函数
void exec(uint64 fn)
{
    800011e2:	7179                	addi	sp,sp,-48
    800011e4:	f406                	sd	ra,40(sp)
    800011e6:	f022                	sd	s0,32(sp)
    800011e8:	ec26                	sd	s1,24(sp)
    800011ea:	e84a                	sd	s2,16(sp)
    800011ec:	e44e                	sd	s3,8(sp)
    800011ee:	e052                	sd	s4,0(sp)
    800011f0:	1800                	addi	s0,sp,48
    800011f2:	892a                	mv	s2,a0
    800011f4:	8792                	mv	a5,tp
    return mycpu()->proc;
    800011f6:	00004997          	auipc	s3,0x4
    800011fa:	ffa98993          	addi	s3,s3,-6 # 800051f0 <cpus>
    800011fe:	2781                	sext.w	a5,a5
    80001200:	079e                	slli	a5,a5,0x7
    80001202:	97ce                	add	a5,a5,s3
    80001204:	6384                	ld	s1,0(a5)
    struct proc* p = myproc();
    memset(&p->context, 0, sizeof(struct context));
    80001206:	03048a13          	addi	s4,s1,48
    8000120a:	07000613          	li	a2,112
    8000120e:	4581                	li	a1,0
    80001210:	8552                	mv	a0,s4
    80001212:	00000097          	auipc	ra,0x0
    80001216:	310080e7          	jalr	784(ra) # 80001522 <memset>
    p->state = RUNNABLE;
    8000121a:	4789                	li	a5,2
    8000121c:	c09c                	sw	a5,0(s1)
    p->context.sp = p->kstack + PGSIZE;
    8000121e:	749c                	ld	a5,40(s1)
    80001220:	6705                	lui	a4,0x1
    80001222:	97ba                	add	a5,a5,a4
    80001224:	fc9c                	sd	a5,56(s1)
    80001226:	8592                	mv	a1,tp
    execra(&p->context, &mycpu()->context, fn);
    80001228:	2581                	sext.w	a1,a1
    8000122a:	059e                	slli	a1,a1,0x7
    8000122c:	05a1                	addi	a1,a1,8
    8000122e:	864a                	mv	a2,s2
    80001230:	95ce                	add	a1,a1,s3
    80001232:	8552                	mv	a0,s4
    80001234:	00000097          	auipc	ra,0x0
    80001238:	51c080e7          	jalr	1308(ra) # 80001750 <execra>
    // 不会返回
    panic("exec");
    8000123c:	00002517          	auipc	a0,0x2
    80001240:	11c50513          	addi	a0,a0,284 # 80003358 <digits+0x320>
    80001244:	fffff097          	auipc	ra,0xfffff
    80001248:	48a080e7          	jalr	1162(ra) # 800006ce <panic>
}
    8000124c:	70a2                	ld	ra,40(sp)
    8000124e:	7402                	ld	s0,32(sp)
    80001250:	64e2                	ld	s1,24(sp)
    80001252:	6942                	ld	s2,16(sp)
    80001254:	69a2                	ld	s3,8(sp)
    80001256:	6a02                	ld	s4,0(sp)
    80001258:	6145                	addi	sp,sp,48
    8000125a:	8082                	ret

000000008000125c <run>:

void run(uint64 fn)
{
    8000125c:	1101                	addi	sp,sp,-32
    8000125e:	ec06                	sd	ra,24(sp)
    80001260:	e822                	sd	s0,16(sp)
    80001262:	e426                	sd	s1,8(sp)
    80001264:	1000                	addi	s0,sp,32
    80001266:	84aa                	mv	s1,a0
    if (fork() > 0) {
    80001268:	00000097          	auipc	ra,0x0
    8000126c:	3d0080e7          	jalr	976(ra) # 80001638 <fork>
    80001270:	00a05c63          	blez	a0,80001288 <run+0x2c>
        wait(0);
    80001274:	4501                	li	a0,0
    80001276:	00000097          	auipc	ra,0x0
    8000127a:	bf0080e7          	jalr	-1040(ra) # 80000e66 <wait>
    } else {
        exec(fn);
    }
}
    8000127e:	60e2                	ld	ra,24(sp)
    80001280:	6442                	ld	s0,16(sp)
    80001282:	64a2                	ld	s1,8(sp)
    80001284:	6105                	addi	sp,sp,32
    80001286:	8082                	ret
        exec(fn);
    80001288:	8526                	mv	a0,s1
    8000128a:	00000097          	auipc	ra,0x0
    8000128e:	f58080e7          	jalr	-168(ra) # 800011e2 <exec>
}
    80001292:	b7f5                	j	8000127e <run+0x22>

0000000080001294 <runcmd>:
void runcmd(char* cmdstr)
{
    80001294:	1101                	addi	sp,sp,-32
    80001296:	ec06                	sd	ra,24(sp)
    80001298:	e822                	sd	s0,16(sp)
    8000129a:	e426                	sd	s1,8(sp)
    8000129c:	1000                	addi	s0,sp,32
    8000129e:	84aa                	mv	s1,a0
    if (strlen(cmdstr) == 0)
    800012a0:	00000097          	auipc	ra,0x0
    800012a4:	304080e7          	jalr	772(ra) # 800015a4 <strlen>
    800012a8:	0005079b          	sext.w	a5,a0
    800012ac:	e791                	bnez	a5,800012b8 <runcmd+0x24>
        run((uint64)mew);
    else {
        puts("■■No such command.");
        return;
    }
}
    800012ae:	60e2                	ld	ra,24(sp)
    800012b0:	6442                	ld	s0,16(sp)
    800012b2:	64a2                	ld	s1,8(sp)
    800012b4:	6105                	addi	sp,sp,32
    800012b6:	8082                	ret
    else if (strcmp(cmdstr, "hello") == 0)
    800012b8:	00002597          	auipc	a1,0x2
    800012bc:	0a858593          	addi	a1,a1,168 # 80003360 <digits+0x328>
    800012c0:	8526                	mv	a0,s1
    800012c2:	fffff097          	auipc	ra,0xfffff
    800012c6:	7f2080e7          	jalr	2034(ra) # 80000ab4 <strcmp>
    800012ca:	e911                	bnez	a0,800012de <runcmd+0x4a>
        run((uint64)hello);
    800012cc:	00000517          	auipc	a0,0x0
    800012d0:	cb050513          	addi	a0,a0,-848 # 80000f7c <hello>
    800012d4:	00000097          	auipc	ra,0x0
    800012d8:	f88080e7          	jalr	-120(ra) # 8000125c <run>
    800012dc:	bfc9                	j	800012ae <runcmd+0x1a>
    else if (strcmp(cmdstr, "help") == 0)
    800012de:	00002597          	auipc	a1,0x2
    800012e2:	08a58593          	addi	a1,a1,138 # 80003368 <digits+0x330>
    800012e6:	8526                	mv	a0,s1
    800012e8:	fffff097          	auipc	ra,0xfffff
    800012ec:	7cc080e7          	jalr	1996(ra) # 80000ab4 <strcmp>
    800012f0:	e911                	bnez	a0,80001304 <runcmd+0x70>
        run((uint64)help);
    800012f2:	00000517          	auipc	a0,0x0
    800012f6:	dc850513          	addi	a0,a0,-568 # 800010ba <help>
    800012fa:	00000097          	auipc	ra,0x0
    800012fe:	f62080e7          	jalr	-158(ra) # 8000125c <run>
    80001302:	b775                	j	800012ae <runcmd+0x1a>
    else if (strcmp(cmdstr, "history") == 0)
    80001304:	00002597          	auipc	a1,0x2
    80001308:	06c58593          	addi	a1,a1,108 # 80003370 <digits+0x338>
    8000130c:	8526                	mv	a0,s1
    8000130e:	fffff097          	auipc	ra,0xfffff
    80001312:	7a6080e7          	jalr	1958(ra) # 80000ab4 <strcmp>
    80001316:	e911                	bnez	a0,8000132a <runcmd+0x96>
        run((uint64)showHistory);
    80001318:	00000517          	auipc	a0,0x0
    8000131c:	e2c50513          	addi	a0,a0,-468 # 80001144 <showHistory>
    80001320:	00000097          	auipc	ra,0x0
    80001324:	f3c080e7          	jalr	-196(ra) # 8000125c <run>
    80001328:	b759                	j	800012ae <runcmd+0x1a>
    else if(strcmp(cmdstr, "cowsay") == 0)
    8000132a:	00002597          	auipc	a1,0x2
    8000132e:	04e58593          	addi	a1,a1,78 # 80003378 <digits+0x340>
    80001332:	8526                	mv	a0,s1
    80001334:	fffff097          	auipc	ra,0xfffff
    80001338:	780080e7          	jalr	1920(ra) # 80000ab4 <strcmp>
    8000133c:	e911                	bnez	a0,80001350 <runcmd+0xbc>
        run((uint64)cowsay);
    8000133e:	00000517          	auipc	a0,0x0
    80001342:	c6850513          	addi	a0,a0,-920 # 80000fa6 <cowsay>
    80001346:	00000097          	auipc	ra,0x0
    8000134a:	f16080e7          	jalr	-234(ra) # 8000125c <run>
    8000134e:	b785                	j	800012ae <runcmd+0x1a>
    else if(strcmp(cmdstr, "mew") == 0)
    80001350:	00002597          	auipc	a1,0x2
    80001354:	ff858593          	addi	a1,a1,-8 # 80003348 <digits+0x310>
    80001358:	8526                	mv	a0,s1
    8000135a:	fffff097          	auipc	ra,0xfffff
    8000135e:	75a080e7          	jalr	1882(ra) # 80000ab4 <strcmp>
    80001362:	e911                	bnez	a0,80001376 <runcmd+0xe2>
        run((uint64)mew);
    80001364:	00000517          	auipc	a0,0x0
    80001368:	cdc50513          	addi	a0,a0,-804 # 80001040 <mew>
    8000136c:	00000097          	auipc	ra,0x0
    80001370:	ef0080e7          	jalr	-272(ra) # 8000125c <run>
    80001374:	bf2d                	j	800012ae <runcmd+0x1a>
        puts("■■No such command.");
    80001376:	00002517          	auipc	a0,0x2
    8000137a:	00a50513          	addi	a0,a0,10 # 80003380 <digits+0x348>
    8000137e:	fffff097          	auipc	ra,0xfffff
    80001382:	17a080e7          	jalr	378(ra) # 800004f8 <puts>
        return;
    80001386:	b725                	j	800012ae <runcmd+0x1a>

0000000080001388 <osh>:
{
    80001388:	7119                	addi	sp,sp,-128
    8000138a:	fc86                	sd	ra,120(sp)
    8000138c:	f8a2                	sd	s0,112(sp)
    8000138e:	f4a6                	sd	s1,104(sp)
    80001390:	f0ca                	sd	s2,96(sp)
    80001392:	ecce                	sd	s3,88(sp)
    80001394:	e8d2                	sd	s4,80(sp)
    80001396:	e4d6                	sd	s5,72(sp)
    80001398:	e0da                	sd	s6,64(sp)
    8000139a:	0100                	addi	s0,sp,128
    printf("\n==========================Start OS=========================\n");
    8000139c:	00002517          	auipc	a0,0x2
    800013a0:	ffc50513          	addi	a0,a0,-4 # 80003398 <digits+0x360>
    800013a4:	fffff097          	auipc	ra,0xfffff
    800013a8:	11e080e7          	jalr	286(ra) # 800004c2 <printf>
    puts("Welcome to startOS! Use following commands to get started.");
    800013ac:	00002517          	auipc	a0,0x2
    800013b0:	02c50513          	addi	a0,a0,44 # 800033d8 <digits+0x3a0>
    800013b4:	fffff097          	auipc	ra,0xfffff
    800013b8:	144080e7          	jalr	324(ra) # 800004f8 <puts>
    puts("  * hello - print test hello world message");
    800013bc:	00002517          	auipc	a0,0x2
    800013c0:	05c50513          	addi	a0,a0,92 # 80003418 <digits+0x3e0>
    800013c4:	fffff097          	auipc	ra,0xfffff
    800013c8:	134080e7          	jalr	308(ra) # 800004f8 <puts>
    puts("  * help - list all available commands");
    800013cc:	00002517          	auipc	a0,0x2
    800013d0:	07c50513          	addi	a0,a0,124 # 80003448 <digits+0x410>
    800013d4:	fffff097          	auipc	ra,0xfffff
    800013d8:	124080e7          	jalr	292(ra) # 800004f8 <puts>
    h.currentP = 0; //当前指令即将写入的位置
    800013dc:	00004797          	auipc	a5,0x4
    800013e0:	fc07aa23          	sw	zero,-44(a5) # 800053b0 <h+0x140>
        printf("osh>> ");
    800013e4:	00002497          	auipc	s1,0x2
    800013e8:	08c48493          	addi	s1,s1,140 # 80003470 <digits+0x438>
            if (strcmp(buf, "!!") == 0)
    800013ec:	00002997          	auipc	s3,0x2
    800013f0:	08c98993          	addi	s3,s3,140 # 80003478 <digits+0x440>
                if (h.currentP >= MAX_HISTORY_NUM)
    800013f4:	00004917          	auipc	s2,0x4
    800013f8:	dfc90913          	addi	s2,s2,-516 # 800051f0 <cpus>
    800013fc:	4a91                	li	s5,4
                strcpy(h.cmdlist[h.currentP++], buf);
    800013fe:	00004a17          	auipc	s4,0x4
    80001402:	e72a0a13          	addi	s4,s4,-398 # 80005270 <h>
                    h.currentP = h.currentP % MAX_HISTORY_NUM;
    80001406:	4b15                	li	s6,5
    80001408:	a82d                	j	80001442 <osh+0xba>
                runcmd(buf);
    8000140a:	f8040513          	addi	a0,s0,-128
    8000140e:	00000097          	auipc	ra,0x0
    80001412:	e86080e7          	jalr	-378(ra) # 80001294 <runcmd>
                if (h.currentP >= MAX_HISTORY_NUM)
    80001416:	1c092783          	lw	a5,448(s2)
    8000141a:	00fad663          	bge	s5,a5,80001426 <osh+0x9e>
                    h.currentP = h.currentP % MAX_HISTORY_NUM;
    8000141e:	0367e7bb          	remw	a5,a5,s6
    80001422:	1cf92023          	sw	a5,448(s2)
                strcpy(h.cmdlist[h.currentP++], buf);
    80001426:	1c092503          	lw	a0,448(s2)
    8000142a:	0015079b          	addiw	a5,a0,1
    8000142e:	1cf92023          	sw	a5,448(s2)
    80001432:	051a                	slli	a0,a0,0x6
    80001434:	f8040593          	addi	a1,s0,-128
    80001438:	9552                	add	a0,a0,s4
    8000143a:	fffff097          	auipc	ra,0xfffff
    8000143e:	65e080e7          	jalr	1630(ra) # 80000a98 <strcpy>
        printf("osh>> ");
    80001442:	8526                	mv	a0,s1
    80001444:	fffff097          	auipc	ra,0xfffff
    80001448:	07e080e7          	jalr	126(ra) # 800004c2 <printf>
        if (read_line(buf) != 0) {
    8000144c:	f8040513          	addi	a0,s0,-128
    80001450:	fffff097          	auipc	ra,0xfffff
    80001454:	0e4080e7          	jalr	228(ra) # 80000534 <read_line>
    80001458:	d56d                	beqz	a0,80001442 <osh+0xba>
            if (strcmp(buf, "!!") == 0)
    8000145a:	85ce                	mv	a1,s3
    8000145c:	f8040513          	addi	a0,s0,-128
    80001460:	fffff097          	auipc	ra,0xfffff
    80001464:	654080e7          	jalr	1620(ra) # 80000ab4 <strcmp>
    80001468:	f14d                	bnez	a0,8000140a <osh+0x82>
                showHistory();
    8000146a:	00000097          	auipc	ra,0x0
    8000146e:	cda080e7          	jalr	-806(ra) # 80001144 <showHistory>
    80001472:	bfc1                	j	80001442 <osh+0xba>

0000000080001474 <init>:
{
    80001474:	1141                	addi	sp,sp,-16
    80001476:	e406                	sd	ra,8(sp)
    80001478:	e022                	sd	s0,0(sp)
    8000147a:	0800                	addi	s0,sp,16
    int pid = fork();
    8000147c:	00000097          	auipc	ra,0x0
    80001480:	1bc080e7          	jalr	444(ra) # 80001638 <fork>
    if (pid < 0) {
    80001484:	00054d63          	bltz	a0,8000149e <init+0x2a>
    } else if (pid == 0) {
    80001488:	c505                	beqz	a0,800014b0 <init+0x3c>
    fstest();
    8000148a:	00001097          	auipc	ra,0x1
    8000148e:	84c080e7          	jalr	-1972(ra) # 80001cd6 <fstest>
        wait(0);
    80001492:	4501                	li	a0,0
    80001494:	00000097          	auipc	ra,0x0
    80001498:	9d2080e7          	jalr	-1582(ra) # 80000e66 <wait>
    for (;;) {
    8000149c:	bfdd                	j	80001492 <init+0x1e>
        panic("init");
    8000149e:	00002517          	auipc	a0,0x2
    800014a2:	fe250513          	addi	a0,a0,-30 # 80003480 <digits+0x448>
    800014a6:	fffff097          	auipc	ra,0xfffff
    800014aa:	228080e7          	jalr	552(ra) # 800006ce <panic>
    800014ae:	bff1                	j	8000148a <init+0x16>
        exec((uint64)osh);
    800014b0:	00000517          	auipc	a0,0x0
    800014b4:	ed850513          	addi	a0,a0,-296 # 80001388 <osh>
    800014b8:	00000097          	auipc	ra,0x0
    800014bc:	d2a080e7          	jalr	-726(ra) # 800011e2 <exec>
    800014c0:	b7e9                	j	8000148a <init+0x16>

00000000800014c2 <print_proc>:

void print_proc()
{
    800014c2:	7179                	addi	sp,sp,-48
    800014c4:	f406                	sd	ra,40(sp)
    800014c6:	f022                	sd	s0,32(sp)
    800014c8:	ec26                	sd	s1,24(sp)
    800014ca:	e84a                	sd	s2,16(sp)
    800014cc:	e44e                	sd	s3,8(sp)
    800014ce:	1800                	addi	s0,sp,48
    struct proc* p;
    printf(" \npid\tstate\n");
    800014d0:	00002517          	auipc	a0,0x2
    800014d4:	fb850513          	addi	a0,a0,-72 # 80003488 <digits+0x450>
    800014d8:	fffff097          	auipc	ra,0xfffff
    800014dc:	fea080e7          	jalr	-22(ra) # 800004c2 <printf>
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    800014e0:	00045497          	auipc	s1,0x45
    800014e4:	ed848493          	addi	s1,s1,-296 # 800463b8 <proc_table>
        if (p->state == UNUSED)
            continue;
        printf(" %d\t  %d\n", p->pid, p->state);
    800014e8:	00002997          	auipc	s3,0x2
    800014ec:	fb098993          	addi	s3,s3,-80 # 80003498 <digits+0x460>
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    800014f0:	00048917          	auipc	s2,0x48
    800014f4:	ac890913          	addi	s2,s2,-1336 # 80048fb8 <proc_table+0x2c00>
    800014f8:	a029                	j	80001502 <print_proc+0x40>
    800014fa:	0b048493          	addi	s1,s1,176
    800014fe:	01248b63          	beq	s1,s2,80001514 <print_proc+0x52>
        if (p->state == UNUSED)
    80001502:	4090                	lw	a2,0(s1)
    80001504:	da7d                	beqz	a2,800014fa <print_proc+0x38>
        printf(" %d\t  %d\n", p->pid, p->state);
    80001506:	508c                	lw	a1,32(s1)
    80001508:	854e                	mv	a0,s3
    8000150a:	fffff097          	auipc	ra,0xfffff
    8000150e:	fb8080e7          	jalr	-72(ra) # 800004c2 <printf>
    80001512:	b7e5                	j	800014fa <print_proc+0x38>
    }
}
    80001514:	70a2                	ld	ra,40(sp)
    80001516:	7402                	ld	s0,32(sp)
    80001518:	64e2                	ld	s1,24(sp)
    8000151a:	6942                	ld	s2,16(sp)
    8000151c:	69a2                	ld	s3,8(sp)
    8000151e:	6145                	addi	sp,sp,48
    80001520:	8082                	ret

0000000080001522 <memset>:
#include "types.h"

void* memset(void* dst, int c, uint n)
{
    80001522:	1141                	addi	sp,sp,-16
    80001524:	e422                	sd	s0,8(sp)
    80001526:	0800                	addi	s0,sp,16
    char* cdst = (char*)dst;
    int i;
    for (i = 0; i < n; i++) {
    80001528:	ce09                	beqz	a2,80001542 <memset+0x20>
    8000152a:	87aa                	mv	a5,a0
    8000152c:	fff6071b          	addiw	a4,a2,-1
    80001530:	1702                	slli	a4,a4,0x20
    80001532:	9301                	srli	a4,a4,0x20
    80001534:	0705                	addi	a4,a4,1
    80001536:	972a                	add	a4,a4,a0
        cdst[i] = c;
    80001538:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++) {
    8000153c:	0785                	addi	a5,a5,1
    8000153e:	fee79de3          	bne	a5,a4,80001538 <memset+0x16>
    }
    return dst;
}
    80001542:	6422                	ld	s0,8(sp)
    80001544:	0141                	addi	sp,sp,16
    80001546:	8082                	ret

0000000080001548 <memmove>:

void* memmove(void* vdst, const void* vsrc, int n)
{
    80001548:	1141                	addi	sp,sp,-16
    8000154a:	e422                	sd	s0,8(sp)
    8000154c:	0800                	addi	s0,sp,16
    char* dst;
    const char* src;

    dst = vdst;
    src = vsrc;
    if (src > dst) {
    8000154e:	02b57663          	bgeu	a0,a1,8000157a <memmove+0x32>
        while (n-- > 0)
    80001552:	02c05163          	blez	a2,80001574 <memmove+0x2c>
    80001556:	fff6079b          	addiw	a5,a2,-1
    8000155a:	1782                	slli	a5,a5,0x20
    8000155c:	9381                	srli	a5,a5,0x20
    8000155e:	0785                	addi	a5,a5,1
    80001560:	97aa                	add	a5,a5,a0
    dst = vdst;
    80001562:	872a                	mv	a4,a0
            *dst++ = *src++;
    80001564:	0585                	addi	a1,a1,1
    80001566:	0705                	addi	a4,a4,1
    80001568:	fff5c683          	lbu	a3,-1(a1)
    8000156c:	fed70fa3          	sb	a3,-1(a4) # fff <_entry-0x7ffff001>
        while (n-- > 0)
    80001570:	fee79ae3          	bne	a5,a4,80001564 <memmove+0x1c>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
    80001574:	6422                	ld	s0,8(sp)
    80001576:	0141                	addi	sp,sp,16
    80001578:	8082                	ret
        dst += n;
    8000157a:	00c50733          	add	a4,a0,a2
        src += n;
    8000157e:	95b2                	add	a1,a1,a2
        while (n-- > 0)
    80001580:	fec05ae3          	blez	a2,80001574 <memmove+0x2c>
    80001584:	fff6079b          	addiw	a5,a2,-1
    80001588:	1782                	slli	a5,a5,0x20
    8000158a:	9381                	srli	a5,a5,0x20
    8000158c:	fff7c793          	not	a5,a5
    80001590:	97ba                	add	a5,a5,a4
            *--dst = *--src;
    80001592:	15fd                	addi	a1,a1,-1
    80001594:	177d                	addi	a4,a4,-1
    80001596:	0005c683          	lbu	a3,0(a1)
    8000159a:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
    8000159e:	fee79ae3          	bne	a5,a4,80001592 <memmove+0x4a>
    800015a2:	bfc9                	j	80001574 <memmove+0x2c>

00000000800015a4 <strlen>:

uint strlen(const char* s)
{
    800015a4:	1141                	addi	sp,sp,-16
    800015a6:	e422                	sd	s0,8(sp)
    800015a8:	0800                	addi	s0,sp,16
  int n;
  for (n = 0; s[n]; n++)
    800015aa:	00054783          	lbu	a5,0(a0)
    800015ae:	cf91                	beqz	a5,800015ca <strlen+0x26>
    800015b0:	0505                	addi	a0,a0,1
    800015b2:	87aa                	mv	a5,a0
    800015b4:	4685                	li	a3,1
    800015b6:	9e89                	subw	a3,a3,a0
    800015b8:	00f6853b          	addw	a0,a3,a5
    800015bc:	0785                	addi	a5,a5,1
    800015be:	fff7c703          	lbu	a4,-1(a5)
    800015c2:	fb7d                	bnez	a4,800015b8 <strlen+0x14>
    ;
  return n;
}
    800015c4:	6422                	ld	s0,8(sp)
    800015c6:	0141                	addi	sp,sp,16
    800015c8:	8082                	ret
  for (n = 0; s[n]; n++)
    800015ca:	4501                	li	a0,0
    800015cc:	bfe5                	j	800015c4 <strlen+0x20>

00000000800015ce <pswitch>:
    800015ce:	00153023          	sd	ra,0(a0)
    800015d2:	00253423          	sd	sp,8(a0)
    800015d6:	e900                	sd	s0,16(a0)
    800015d8:	ed04                	sd	s1,24(a0)
    800015da:	03253023          	sd	s2,32(a0)
    800015de:	03353423          	sd	s3,40(a0)
    800015e2:	03453823          	sd	s4,48(a0)
    800015e6:	03553c23          	sd	s5,56(a0)
    800015ea:	05653023          	sd	s6,64(a0)
    800015ee:	05753423          	sd	s7,72(a0)
    800015f2:	05853823          	sd	s8,80(a0)
    800015f6:	05953c23          	sd	s9,88(a0)
    800015fa:	07a53023          	sd	s10,96(a0)
    800015fe:	07b53423          	sd	s11,104(a0)
    80001602:	0005b083          	ld	ra,0(a1)
    80001606:	0085b103          	ld	sp,8(a1)
    8000160a:	6980                	ld	s0,16(a1)
    8000160c:	6d84                	ld	s1,24(a1)
    8000160e:	0205b903          	ld	s2,32(a1)
    80001612:	0285b983          	ld	s3,40(a1)
    80001616:	0305ba03          	ld	s4,48(a1)
    8000161a:	0385ba83          	ld	s5,56(a1)
    8000161e:	0405bb03          	ld	s6,64(a1)
    80001622:	0485bb83          	ld	s7,72(a1)
    80001626:	0505bc03          	ld	s8,80(a1)
    8000162a:	0585bc83          	ld	s9,88(a1)
    8000162e:	0605bd03          	ld	s10,96(a1)
    80001632:	0685bd83          	ld	s11,104(a1)
    80001636:	8082                	ret

0000000080001638 <fork>:
// fork失败返回-1
// 父进程返回子进程id
// 子进程返回0
//
int fork()
{
    80001638:	1101                	addi	sp,sp,-32
    8000163a:	ec06                	sd	ra,24(sp)
    8000163c:	e822                	sd	s0,16(sp)
    8000163e:	e426                	sd	s1,8(sp)
    80001640:	e04a                	sd	s2,0(sp)
    80001642:	1000                	addi	s0,sp,32
    struct proc* p;
    struct proc* np;
    if ((np = alloc_proc()) == 0) {
    80001644:	fffff097          	auipc	ra,0xfffff
    80001648:	5c4080e7          	jalr	1476(ra) # 80000c08 <alloc_proc>
    8000164c:	c931                	beqz	a0,800016a0 <fork+0x68>
    8000164e:	84aa                	mv	s1,a0
        return -1;
    }
    p = myproc();
    80001650:	fffff097          	auipc	ra,0xfffff
    80001654:	678080e7          	jalr	1656(ra) # 80000cc8 <myproc>
    80001658:	892a                	mv	s2,a0
    memmove((char*)np->kstack, (char*)p->kstack, PGSIZE);
    8000165a:	6605                	lui	a2,0x1
    8000165c:	750c                	ld	a1,40(a0)
    8000165e:	7488                	ld	a0,40(s1)
    80001660:	00000097          	auipc	ra,0x0
    80001664:	ee8080e7          	jalr	-280(ra) # 80001548 <memmove>
    np->parent = p;
    80001668:	0124b423          	sd	s2,8(s1)
    np->state = RUNNABLE;
    8000166c:	4789                	li	a5,2
    8000166e:	c09c                	sw	a5,0(s1)
    forkra(&np->context, p->kstack, np->kstack);
    80001670:	7490                	ld	a2,40(s1)
    80001672:	02893583          	ld	a1,40(s2)
    80001676:	03048513          	addi	a0,s1,48
    8000167a:	00000097          	auipc	ra,0x0
    8000167e:	096080e7          	jalr	150(ra) # 80001710 <forkra>
    return myproc() == np ? 0 : np->pid;
    80001682:	fffff097          	auipc	ra,0xfffff
    80001686:	646080e7          	jalr	1606(ra) # 80000cc8 <myproc>
    8000168a:	87aa                	mv	a5,a0
    8000168c:	4501                	li	a0,0
    8000168e:	00f48363          	beq	s1,a5,80001694 <fork+0x5c>
    80001692:	5088                	lw	a0,32(s1)
}
    80001694:	60e2                	ld	ra,24(sp)
    80001696:	6442                	ld	s0,16(sp)
    80001698:	64a2                	ld	s1,8(sp)
    8000169a:	6902                	ld	s2,0(sp)
    8000169c:	6105                	addi	sp,sp,32
    8000169e:	8082                	ret
        return -1;
    800016a0:	557d                	li	a0,-1
    800016a2:	bfcd                	j	80001694 <fork+0x5c>

00000000800016a4 <sleep_sec>:

//
// 睡眠指定秒数
//
void sleep_sec(int seconds)
{
    800016a4:	1141                	addi	sp,sp,-16
    800016a6:	e406                	sd	ra,8(sp)
    800016a8:	e022                	sd	s0,0(sp)
    800016aa:	0800                	addi	s0,sp,16
    sleep_time(seconds * 10);
    800016ac:	0025179b          	slliw	a5,a0,0x2
    800016b0:	9d3d                	addw	a0,a0,a5
    800016b2:	0015151b          	slliw	a0,a0,0x1
    800016b6:	fffff097          	auipc	ra,0xfffff
    800016ba:	66e080e7          	jalr	1646(ra) # 80000d24 <sleep_time>
}
    800016be:	60a2                	ld	ra,8(sp)
    800016c0:	6402                	ld	s0,0(sp)
    800016c2:	0141                	addi	sp,sp,16
    800016c4:	8082                	ret

00000000800016c6 <yeild>:

//
// 让出cpu
//
void yeild()
{
    800016c6:	1101                	addi	sp,sp,-32
    800016c8:	ec06                	sd	ra,24(sp)
    800016ca:	e822                	sd	s0,16(sp)
    800016cc:	e426                	sd	s1,8(sp)
    800016ce:	1000                	addi	s0,sp,32
    myproc()->state = RUNNABLE;
    800016d0:	fffff097          	auipc	ra,0xfffff
    800016d4:	5f8080e7          	jalr	1528(ra) # 80000cc8 <myproc>
    800016d8:	4789                	li	a5,2
    800016da:	c11c                	sw	a5,0(a0)
    pswitch(&(myproc()->context), &(mycpu()->context));
    800016dc:	fffff097          	auipc	ra,0xfffff
    800016e0:	5ec080e7          	jalr	1516(ra) # 80000cc8 <myproc>
    800016e4:	84aa                	mv	s1,a0
    800016e6:	fffff097          	auipc	ra,0xfffff
    800016ea:	5c6080e7          	jalr	1478(ra) # 80000cac <mycpu>
    800016ee:	00850593          	addi	a1,a0,8
    800016f2:	03048513          	addi	a0,s1,48
    800016f6:	00000097          	auipc	ra,0x0
    800016fa:	ed8080e7          	jalr	-296(ra) # 800015ce <pswitch>
}
    800016fe:	60e2                	ld	ra,24(sp)
    80001700:	6442                	ld	s0,16(sp)
    80001702:	64a2                	ld	s1,8(sp)
    80001704:	6105                	addi	sp,sp,32
    80001706:	8082                	ret
	...

0000000080001710 <forkra>:
    80001710:	40b102b3          	sub	t0,sp,a1
    80001714:	92b2                	add	t0,t0,a2
    80001716:	00153023          	sd	ra,0(a0)
    8000171a:	00553423          	sd	t0,8(a0)
    8000171e:	e900                	sd	s0,16(a0)
    80001720:	ed04                	sd	s1,24(a0)
    80001722:	03253023          	sd	s2,32(a0)
    80001726:	03353423          	sd	s3,40(a0)
    8000172a:	03453823          	sd	s4,48(a0)
    8000172e:	03553c23          	sd	s5,56(a0)
    80001732:	05653023          	sd	s6,64(a0)
    80001736:	05753423          	sd	s7,72(a0)
    8000173a:	05853823          	sd	s8,80(a0)
    8000173e:	05953c23          	sd	s9,88(a0)
    80001742:	07a53023          	sd	s10,96(a0)
    80001746:	07b53423          	sd	s11,104(a0)
    8000174a:	8082                	ret
    8000174c:	00000013          	nop

0000000080001750 <execra>:
    80001750:	e110                	sd	a2,0(a0)
    80001752:	0005b083          	ld	ra,0(a1)
    80001756:	0085b103          	ld	sp,8(a1)
    8000175a:	6980                	ld	s0,16(a1)
    8000175c:	6d84                	ld	s1,24(a1)
    8000175e:	0205b903          	ld	s2,32(a1)
    80001762:	0285b983          	ld	s3,40(a1)
    80001766:	0305ba03          	ld	s4,48(a1)
    8000176a:	0385ba83          	ld	s5,56(a1)
    8000176e:	0405bb03          	ld	s6,64(a1)
    80001772:	0485bb83          	ld	s7,72(a1)
    80001776:	0505bc03          	ld	s8,80(a1)
    8000177a:	0585bc83          	ld	s9,88(a1)
    8000177e:	0605bd03          	ld	s10,96(a1)
    80001782:	0685bd83          	ld	s11,104(a1)
    80001786:	8082                	ret

0000000080001788 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80001788:	1101                	addi	sp,sp,-32
    8000178a:	ec06                	sd	ra,24(sp)
    8000178c:	e822                	sd	s0,16(sp)
    8000178e:	e426                	sd	s1,8(sp)
    80001790:	1000                	addi	s0,sp,32
    80001792:	84aa                	mv	s1,a0
  if(i >= NUM)
    80001794:	479d                	li	a5,7
    80001796:	06a7ca63          	blt	a5,a0,8000180a <free_desc+0x82>
    panic("free_desc 1");
  if(disk.free[i])
    8000179a:	00048797          	auipc	a5,0x48
    8000179e:	86678793          	addi	a5,a5,-1946 # 80049000 <disk>
    800017a2:	00978733          	add	a4,a5,s1
    800017a6:	6789                	lui	a5,0x2
    800017a8:	97ba                	add	a5,a5,a4
    800017aa:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800017ae:	e7bd                	bnez	a5,8000181c <free_desc+0x94>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800017b0:	00449793          	slli	a5,s1,0x4
    800017b4:	0004a717          	auipc	a4,0x4a
    800017b8:	84c70713          	addi	a4,a4,-1972 # 8004b000 <disk+0x2000>
    800017bc:	6314                	ld	a3,0(a4)
    800017be:	96be                	add	a3,a3,a5
    800017c0:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800017c4:	6314                	ld	a3,0(a4)
    800017c6:	96be                	add	a3,a3,a5
    800017c8:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800017cc:	6314                	ld	a3,0(a4)
    800017ce:	96be                	add	a3,a3,a5
    800017d0:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800017d4:	6318                	ld	a4,0(a4)
    800017d6:	97ba                	add	a5,a5,a4
    800017d8:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800017dc:	00048517          	auipc	a0,0x48
    800017e0:	82450513          	addi	a0,a0,-2012 # 80049000 <disk>
    800017e4:	9526                	add	a0,a0,s1
    800017e6:	6489                	lui	s1,0x2
    800017e8:	94aa                	add	s1,s1,a0
    800017ea:	4785                	li	a5,1
    800017ec:	00f48c23          	sb	a5,24(s1) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800017f0:	0004a517          	auipc	a0,0x4a
    800017f4:	82850513          	addi	a0,a0,-2008 # 8004b018 <disk+0x2018>
    800017f8:	fffff097          	auipc	ra,0xfffff
    800017fc:	570080e7          	jalr	1392(ra) # 80000d68 <wakeup>
}
    80001800:	60e2                	ld	ra,24(sp)
    80001802:	6442                	ld	s0,16(sp)
    80001804:	64a2                	ld	s1,8(sp)
    80001806:	6105                	addi	sp,sp,32
    80001808:	8082                	ret
    panic("free_desc 1");
    8000180a:	00002517          	auipc	a0,0x2
    8000180e:	c9e50513          	addi	a0,a0,-866 # 800034a8 <digits+0x470>
    80001812:	fffff097          	auipc	ra,0xfffff
    80001816:	ebc080e7          	jalr	-324(ra) # 800006ce <panic>
    8000181a:	b741                	j	8000179a <free_desc+0x12>
    panic("free_desc 2");
    8000181c:	00002517          	auipc	a0,0x2
    80001820:	c9c50513          	addi	a0,a0,-868 # 800034b8 <digits+0x480>
    80001824:	fffff097          	auipc	ra,0xfffff
    80001828:	eaa080e7          	jalr	-342(ra) # 800006ce <panic>
    8000182c:	b751                	j	800017b0 <free_desc+0x28>

000000008000182e <virtio_disk_init>:
{
    8000182e:	1101                	addi	sp,sp,-32
    80001830:	ec06                	sd	ra,24(sp)
    80001832:	e822                	sd	s0,16(sp)
    80001834:	e426                	sd	s1,8(sp)
    80001836:	1000                	addi	s0,sp,32
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80001838:	100017b7          	lui	a5,0x10001
    8000183c:	4398                	lw	a4,0(a5)
    8000183e:	2701                	sext.w	a4,a4
    80001840:	747277b7          	lui	a5,0x74727
    80001844:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80001848:	00f71963          	bne	a4,a5,8000185a <virtio_disk_init+0x2c>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000184c:	100017b7          	lui	a5,0x10001
    80001850:	43dc                	lw	a5,4(a5)
    80001852:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80001854:	4705                	li	a4,1
    80001856:	0ce78163          	beq	a5,a4,80001918 <virtio_disk_init+0xea>
    panic("could not find virtio disk");
    8000185a:	00002517          	auipc	a0,0x2
    8000185e:	c6e50513          	addi	a0,a0,-914 # 800034c8 <digits+0x490>
    80001862:	fffff097          	auipc	ra,0xfffff
    80001866:	e6c080e7          	jalr	-404(ra) # 800006ce <panic>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000186a:	100017b7          	lui	a5,0x10001
    8000186e:	4705                	li	a4,1
    80001870:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80001872:	470d                	li	a4,3
    80001874:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80001876:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80001878:	c7ffe737          	lui	a4,0xc7ffe
    8000187c:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <buf_cache+0xffffffff47fb0c9f>
    80001880:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80001882:	2701                	sext.w	a4,a4
    80001884:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80001886:	472d                	li	a4,11
    80001888:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000188a:	473d                	li	a4,15
    8000188c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000188e:	6705                	lui	a4,0x1
    80001890:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80001892:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80001896:	5bdc                	lw	a5,52(a5)
    80001898:	2781                	sext.w	a5,a5
  if(max == 0)
    8000189a:	c3cd                	beqz	a5,8000193c <virtio_disk_init+0x10e>
  if(max < NUM)
    8000189c:	471d                	li	a4,7
    8000189e:	0af77763          	bgeu	a4,a5,8000194c <virtio_disk_init+0x11e>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800018a2:	100014b7          	lui	s1,0x10001
    800018a6:	47a1                	li	a5,8
    800018a8:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800018aa:	6609                	lui	a2,0x2
    800018ac:	4581                	li	a1,0
    800018ae:	00047517          	auipc	a0,0x47
    800018b2:	75250513          	addi	a0,a0,1874 # 80049000 <disk>
    800018b6:	00000097          	auipc	ra,0x0
    800018ba:	c6c080e7          	jalr	-916(ra) # 80001522 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800018be:	00047717          	auipc	a4,0x47
    800018c2:	74270713          	addi	a4,a4,1858 # 80049000 <disk>
    800018c6:	00c75793          	srli	a5,a4,0xc
    800018ca:	2781                	sext.w	a5,a5
    800018cc:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800018ce:	00049797          	auipc	a5,0x49
    800018d2:	73278793          	addi	a5,a5,1842 # 8004b000 <disk+0x2000>
    800018d6:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800018d8:	00047717          	auipc	a4,0x47
    800018dc:	7a870713          	addi	a4,a4,1960 # 80049080 <disk+0x80>
    800018e0:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800018e2:	00048717          	auipc	a4,0x48
    800018e6:	71e70713          	addi	a4,a4,1822 # 8004a000 <disk+0x1000>
    800018ea:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800018ec:	4705                	li	a4,1
    800018ee:	00e78c23          	sb	a4,24(a5)
    800018f2:	00e78ca3          	sb	a4,25(a5)
    800018f6:	00e78d23          	sb	a4,26(a5)
    800018fa:	00e78da3          	sb	a4,27(a5)
    800018fe:	00e78e23          	sb	a4,28(a5)
    80001902:	00e78ea3          	sb	a4,29(a5)
    80001906:	00e78f23          	sb	a4,30(a5)
    8000190a:	00e78fa3          	sb	a4,31(a5)
}
    8000190e:	60e2                	ld	ra,24(sp)
    80001910:	6442                	ld	s0,16(sp)
    80001912:	64a2                	ld	s1,8(sp)
    80001914:	6105                	addi	sp,sp,32
    80001916:	8082                	ret
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80001918:	100017b7          	lui	a5,0x10001
    8000191c:	479c                	lw	a5,8(a5)
    8000191e:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80001920:	4709                	li	a4,2
    80001922:	f2e79ce3          	bne	a5,a4,8000185a <virtio_disk_init+0x2c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80001926:	100017b7          	lui	a5,0x10001
    8000192a:	47d8                	lw	a4,12(a5)
    8000192c:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000192e:	554d47b7          	lui	a5,0x554d4
    80001932:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80001936:	f2f712e3          	bne	a4,a5,8000185a <virtio_disk_init+0x2c>
    8000193a:	bf05                	j	8000186a <virtio_disk_init+0x3c>
    panic("virtio disk has no queue 0");
    8000193c:	00002517          	auipc	a0,0x2
    80001940:	bac50513          	addi	a0,a0,-1108 # 800034e8 <digits+0x4b0>
    80001944:	fffff097          	auipc	ra,0xfffff
    80001948:	d8a080e7          	jalr	-630(ra) # 800006ce <panic>
    panic("virtio disk max queue too short");
    8000194c:	00002517          	auipc	a0,0x2
    80001950:	bbc50513          	addi	a0,a0,-1092 # 80003508 <digits+0x4d0>
    80001954:	fffff097          	auipc	ra,0xfffff
    80001958:	d7a080e7          	jalr	-646(ra) # 800006ce <panic>
    8000195c:	b799                	j	800018a2 <virtio_disk_init+0x74>

000000008000195e <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    8000195e:	7159                	addi	sp,sp,-112
    80001960:	f486                	sd	ra,104(sp)
    80001962:	f0a2                	sd	s0,96(sp)
    80001964:	eca6                	sd	s1,88(sp)
    80001966:	e8ca                	sd	s2,80(sp)
    80001968:	e4ce                	sd	s3,72(sp)
    8000196a:	e0d2                	sd	s4,64(sp)
    8000196c:	fc56                	sd	s5,56(sp)
    8000196e:	f85a                	sd	s6,48(sp)
    80001970:	f45e                	sd	s7,40(sp)
    80001972:	f062                	sd	s8,32(sp)
    80001974:	ec66                	sd	s9,24(sp)
    80001976:	e86a                	sd	s10,16(sp)
    80001978:	1880                	addi	s0,sp,112
    8000197a:	892a                	mv	s2,a0
    8000197c:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000197e:	00c52c83          	lw	s9,12(a0)
    80001982:	001c9c9b          	slliw	s9,s9,0x1
    80001986:	1c82                	slli	s9,s9,0x20
    80001988:	020cdc93          	srli	s9,s9,0x20

static inline uint64
r_sstatus()
{
  uint64 x;
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000198c:	100027f3          	csrr	a5,sstatus

// disable device interrupts
static inline void
intr_off()
{
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001990:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001992:	10079073          	csrw	sstatus,a5
  for(int i = 0; i < 3; i++){
    80001996:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80001998:	4c21                	li	s8,8
      disk.free[i] = 0;
    8000199a:	00047b97          	auipc	s7,0x47
    8000199e:	666b8b93          	addi	s7,s7,1638 # 80049000 <disk>
    800019a2:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800019a4:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800019a6:	8a4e                	mv	s4,s3
}
    800019a8:	a8b5                	j	80001a24 <virtio_disk_rw+0xc6>
      disk.free[i] = 0;
    800019aa:	00fb86b3          	add	a3,s7,a5
    800019ae:	96da                	add	a3,a3,s6
    800019b0:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800019b4:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800019b6:	0207c563          	bltz	a5,800019e0 <virtio_disk_rw+0x82>
  for(int i = 0; i < 3; i++){
    800019ba:	2485                	addiw	s1,s1,1
    800019bc:	0711                	addi	a4,a4,4
    800019be:	23548563          	beq	s1,s5,80001be8 <virtio_disk_rw+0x28a>
    idx[i] = alloc_desc();
    800019c2:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800019c4:	00049697          	auipc	a3,0x49
    800019c8:	65468693          	addi	a3,a3,1620 # 8004b018 <disk+0x2018>
    800019cc:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800019ce:	0006c583          	lbu	a1,0(a3)
    800019d2:	fde1                	bnez	a1,800019aa <virtio_disk_rw+0x4c>
  for(int i = 0; i < NUM; i++){
    800019d4:	2785                	addiw	a5,a5,1
    800019d6:	0685                	addi	a3,a3,1
    800019d8:	ff879be3          	bne	a5,s8,800019ce <virtio_disk_rw+0x70>
    idx[i] = alloc_desc();
    800019dc:	57fd                	li	a5,-1
    800019de:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800019e0:	02905a63          	blez	s1,80001a14 <virtio_disk_rw+0xb6>
        free_desc(idx[j]);
    800019e4:	f9042503          	lw	a0,-112(s0)
    800019e8:	00000097          	auipc	ra,0x0
    800019ec:	da0080e7          	jalr	-608(ra) # 80001788 <free_desc>
      for(int j = 0; j < i; j++)
    800019f0:	4785                	li	a5,1
    800019f2:	0297d163          	bge	a5,s1,80001a14 <virtio_disk_rw+0xb6>
        free_desc(idx[j]);
    800019f6:	f9442503          	lw	a0,-108(s0)
    800019fa:	00000097          	auipc	ra,0x0
    800019fe:	d8e080e7          	jalr	-626(ra) # 80001788 <free_desc>
      for(int j = 0; j < i; j++)
    80001a02:	4789                	li	a5,2
    80001a04:	0097d863          	bge	a5,s1,80001a14 <virtio_disk_rw+0xb6>
        free_desc(idx[j]);
    80001a08:	f9842503          	lw	a0,-104(s0)
    80001a0c:	00000097          	auipc	ra,0x0
    80001a10:	d7c080e7          	jalr	-644(ra) # 80001788 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0]);
    80001a14:	00049517          	auipc	a0,0x49
    80001a18:	60450513          	addi	a0,a0,1540 # 8004b018 <disk+0x2018>
    80001a1c:	fffff097          	auipc	ra,0xfffff
    80001a20:	2ca080e7          	jalr	714(ra) # 80000ce6 <sleep>
  for(int i = 0; i < 3; i++){
    80001a24:	f9040713          	addi	a4,s0,-112
    80001a28:	84ce                	mv	s1,s3
    80001a2a:	bf61                	j	800019c2 <virtio_disk_rw+0x64>
  // format the three descriptors.
  // qemu's virtio-blk.c reads them.
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80001a2c:	20058713          	addi	a4,a1,512
    80001a30:	00471693          	slli	a3,a4,0x4
    80001a34:	00047717          	auipc	a4,0x47
    80001a38:	5cc70713          	addi	a4,a4,1484 # 80049000 <disk>
    80001a3c:	9736                	add	a4,a4,a3
    80001a3e:	4685                	li	a3,1
    80001a40:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80001a44:	20058713          	addi	a4,a1,512
    80001a48:	00471693          	slli	a3,a4,0x4
    80001a4c:	00047717          	auipc	a4,0x47
    80001a50:	5b470713          	addi	a4,a4,1460 # 80049000 <disk>
    80001a54:	9736                	add	a4,a4,a3
    80001a56:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80001a5a:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80001a5e:	7679                	lui	a2,0xffffe
    80001a60:	963e                	add	a2,a2,a5
    80001a62:	00049697          	auipc	a3,0x49
    80001a66:	59e68693          	addi	a3,a3,1438 # 8004b000 <disk+0x2000>
    80001a6a:	6298                	ld	a4,0(a3)
    80001a6c:	9732                	add	a4,a4,a2
    80001a6e:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80001a70:	6298                	ld	a4,0(a3)
    80001a72:	9732                	add	a4,a4,a2
    80001a74:	4541                	li	a0,16
    80001a76:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80001a78:	6298                	ld	a4,0(a3)
    80001a7a:	9732                	add	a4,a4,a2
    80001a7c:	4505                	li	a0,1
    80001a7e:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80001a82:	f9442703          	lw	a4,-108(s0)
    80001a86:	6288                	ld	a0,0(a3)
    80001a88:	962a                	add	a2,a2,a0
    80001a8a:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <buf_cache+0xffffffff7ffb054e>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80001a8e:	0712                	slli	a4,a4,0x4
    80001a90:	6290                	ld	a2,0(a3)
    80001a92:	963a                	add	a2,a2,a4
    80001a94:	01490513          	addi	a0,s2,20
    80001a98:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80001a9a:	6294                	ld	a3,0(a3)
    80001a9c:	96ba                	add	a3,a3,a4
    80001a9e:	40000613          	li	a2,1024
    80001aa2:	c690                	sw	a2,8(a3)
  if(write)
    80001aa4:	120d0963          	beqz	s10,80001bd6 <virtio_disk_rw+0x278>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80001aa8:	00049697          	auipc	a3,0x49
    80001aac:	5586b683          	ld	a3,1368(a3) # 8004b000 <disk+0x2000>
    80001ab0:	96ba                	add	a3,a3,a4
    80001ab2:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80001ab6:	00047817          	auipc	a6,0x47
    80001aba:	54a80813          	addi	a6,a6,1354 # 80049000 <disk>
    80001abe:	00049517          	auipc	a0,0x49
    80001ac2:	54250513          	addi	a0,a0,1346 # 8004b000 <disk+0x2000>
    80001ac6:	6114                	ld	a3,0(a0)
    80001ac8:	96ba                	add	a3,a3,a4
    80001aca:	00c6d603          	lhu	a2,12(a3)
    80001ace:	00166613          	ori	a2,a2,1
    80001ad2:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80001ad6:	f9842683          	lw	a3,-104(s0)
    80001ada:	6110                	ld	a2,0(a0)
    80001adc:	9732                	add	a4,a4,a2
    80001ade:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80001ae2:	20058613          	addi	a2,a1,512
    80001ae6:	0612                	slli	a2,a2,0x4
    80001ae8:	9642                	add	a2,a2,a6
    80001aea:	577d                	li	a4,-1
    80001aec:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80001af0:	00469713          	slli	a4,a3,0x4
    80001af4:	6114                	ld	a3,0(a0)
    80001af6:	96ba                	add	a3,a3,a4
    80001af8:	03078793          	addi	a5,a5,48
    80001afc:	97c2                	add	a5,a5,a6
    80001afe:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80001b00:	611c                	ld	a5,0(a0)
    80001b02:	97ba                	add	a5,a5,a4
    80001b04:	4685                	li	a3,1
    80001b06:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80001b08:	611c                	ld	a5,0(a0)
    80001b0a:	97ba                	add	a5,a5,a4
    80001b0c:	4809                	li	a6,2
    80001b0e:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80001b12:	611c                	ld	a5,0(a0)
    80001b14:	973e                	add	a4,a4,a5
    80001b16:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80001b1a:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80001b1e:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80001b22:	6518                	ld	a4,8(a0)
    80001b24:	00275783          	lhu	a5,2(a4)
    80001b28:	8b9d                	andi	a5,a5,7
    80001b2a:	0786                	slli	a5,a5,0x1
    80001b2c:	97ba                	add	a5,a5,a4
    80001b2e:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80001b32:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80001b36:	6518                	ld	a4,8(a0)
    80001b38:	00275783          	lhu	a5,2(a4)
    80001b3c:	2785                	addiw	a5,a5,1
    80001b3e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80001b42:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80001b46:	100017b7          	lui	a5,0x10001
    80001b4a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b4e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001b52:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b56:	10079073          	csrw	sstatus,a5

  // Wait for virtio_disk_intr() to say request has finished.
  intr_on();
  while(b->disk == 1) {
    80001b5a:	00492703          	lw	a4,4(s2)
    80001b5e:	4785                	li	a5,1
    80001b60:	00f71c63          	bne	a4,a5,80001b78 <virtio_disk_rw+0x21a>
    80001b64:	4485                	li	s1,1
    sleep(b);
    80001b66:	854a                	mv	a0,s2
    80001b68:	fffff097          	auipc	ra,0xfffff
    80001b6c:	17e080e7          	jalr	382(ra) # 80000ce6 <sleep>
  while(b->disk == 1) {
    80001b70:	00492783          	lw	a5,4(s2)
    80001b74:	fe9789e3          	beq	a5,s1,80001b66 <virtio_disk_rw+0x208>
  }

  disk.info[idx[0]].b = 0;
    80001b78:	f9042903          	lw	s2,-112(s0)
    80001b7c:	20090793          	addi	a5,s2,512
    80001b80:	00479713          	slli	a4,a5,0x4
    80001b84:	00047797          	auipc	a5,0x47
    80001b88:	47c78793          	addi	a5,a5,1148 # 80049000 <disk>
    80001b8c:	97ba                	add	a5,a5,a4
    80001b8e:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80001b92:	00049997          	auipc	s3,0x49
    80001b96:	46e98993          	addi	s3,s3,1134 # 8004b000 <disk+0x2000>
    80001b9a:	00491713          	slli	a4,s2,0x4
    80001b9e:	0009b783          	ld	a5,0(s3)
    80001ba2:	97ba                	add	a5,a5,a4
    80001ba4:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80001ba8:	854a                	mv	a0,s2
    80001baa:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80001bae:	00000097          	auipc	ra,0x0
    80001bb2:	bda080e7          	jalr	-1062(ra) # 80001788 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80001bb6:	8885                	andi	s1,s1,1
    80001bb8:	f0ed                	bnez	s1,80001b9a <virtio_disk_rw+0x23c>
  free_chain(idx[0]);

//   release(&disk.vdisk_lock);
}
    80001bba:	70a6                	ld	ra,104(sp)
    80001bbc:	7406                	ld	s0,96(sp)
    80001bbe:	64e6                	ld	s1,88(sp)
    80001bc0:	6946                	ld	s2,80(sp)
    80001bc2:	69a6                	ld	s3,72(sp)
    80001bc4:	6a06                	ld	s4,64(sp)
    80001bc6:	7ae2                	ld	s5,56(sp)
    80001bc8:	7b42                	ld	s6,48(sp)
    80001bca:	7ba2                	ld	s7,40(sp)
    80001bcc:	7c02                	ld	s8,32(sp)
    80001bce:	6ce2                	ld	s9,24(sp)
    80001bd0:	6d42                	ld	s10,16(sp)
    80001bd2:	6165                	addi	sp,sp,112
    80001bd4:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80001bd6:	00049697          	auipc	a3,0x49
    80001bda:	42a6b683          	ld	a3,1066(a3) # 8004b000 <disk+0x2000>
    80001bde:	96ba                	add	a3,a3,a4
    80001be0:	4609                	li	a2,2
    80001be2:	00c69623          	sh	a2,12(a3)
    80001be6:	bdc1                	j	80001ab6 <virtio_disk_rw+0x158>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80001be8:	f9042583          	lw	a1,-112(s0)
    80001bec:	20058793          	addi	a5,a1,512
    80001bf0:	0792                	slli	a5,a5,0x4
    80001bf2:	00047517          	auipc	a0,0x47
    80001bf6:	4b650513          	addi	a0,a0,1206 # 800490a8 <disk+0xa8>
    80001bfa:	953e                	add	a0,a0,a5
  if(write)
    80001bfc:	e20d18e3          	bnez	s10,80001a2c <virtio_disk_rw+0xce>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80001c00:	20058713          	addi	a4,a1,512
    80001c04:	00471693          	slli	a3,a4,0x4
    80001c08:	00047717          	auipc	a4,0x47
    80001c0c:	3f870713          	addi	a4,a4,1016 # 80049000 <disk>
    80001c10:	9736                	add	a4,a4,a3
    80001c12:	0a072423          	sw	zero,168(a4)
    80001c16:	b53d                	j	80001a44 <virtio_disk_rw+0xe6>

0000000080001c18 <virtio_disk_intr>:
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80001c18:	10001737          	lui	a4,0x10001
    80001c1c:	533c                	lw	a5,96(a4)
    80001c1e:	8b8d                	andi	a5,a5,3
    80001c20:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80001c22:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.
  while(disk.used_idx != disk.used->idx){
    80001c26:	00049797          	auipc	a5,0x49
    80001c2a:	3da78793          	addi	a5,a5,986 # 8004b000 <disk+0x2000>
    80001c2e:	6b94                	ld	a3,16(a5)
    80001c30:	0207d703          	lhu	a4,32(a5)
    80001c34:	0026d783          	lhu	a5,2(a3)
    80001c38:	08f70e63          	beq	a4,a5,80001cd4 <virtio_disk_intr+0xbc>
{
    80001c3c:	7179                	addi	sp,sp,-48
    80001c3e:	f406                	sd	ra,40(sp)
    80001c40:	f022                	sd	s0,32(sp)
    80001c42:	ec26                	sd	s1,24(sp)
    80001c44:	e84a                	sd	s2,16(sp)
    80001c46:	e44e                	sd	s3,8(sp)
    80001c48:	e052                	sd	s4,0(sp)
    80001c4a:	1800                	addi	s0,sp,48
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80001c4c:	00047997          	auipc	s3,0x47
    80001c50:	3b498993          	addi	s3,s3,948 # 80049000 <disk>
    80001c54:	00049917          	auipc	s2,0x49
    80001c58:	3ac90913          	addi	s2,s2,940 # 8004b000 <disk+0x2000>

    if(disk.info[id].status != 0)
      panic("virtio_disk_intr status");
    80001c5c:	00002a17          	auipc	s4,0x2
    80001c60:	8cca0a13          	addi	s4,s4,-1844 # 80003528 <digits+0x4f0>
    80001c64:	a835                	j	80001ca0 <virtio_disk_intr+0x88>
    80001c66:	8552                	mv	a0,s4
    80001c68:	fffff097          	auipc	ra,0xfffff
    80001c6c:	a66080e7          	jalr	-1434(ra) # 800006ce <panic>

    struct buf *b = disk.info[id].b;
    80001c70:	20048493          	addi	s1,s1,512 # 10001200 <_entry-0x6fffee00>
    80001c74:	0492                	slli	s1,s1,0x4
    80001c76:	94ce                	add	s1,s1,s3
    80001c78:	7488                	ld	a0,40(s1)
    b->disk = 0;   // disk is done with buf
    80001c7a:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80001c7e:	fffff097          	auipc	ra,0xfffff
    80001c82:	0ea080e7          	jalr	234(ra) # 80000d68 <wakeup>

    disk.used_idx += 1;
    80001c86:	02095783          	lhu	a5,32(s2)
    80001c8a:	2785                	addiw	a5,a5,1
    80001c8c:	17c2                	slli	a5,a5,0x30
    80001c8e:	93c1                	srli	a5,a5,0x30
    80001c90:	02f91023          	sh	a5,32(s2)
  while(disk.used_idx != disk.used->idx){
    80001c94:	01093703          	ld	a4,16(s2)
    80001c98:	00275703          	lhu	a4,2(a4) # 10001002 <_entry-0x6fffeffe>
    80001c9c:	02f70463          	beq	a4,a5,80001cc4 <virtio_disk_intr+0xac>
    __sync_synchronize();
    80001ca0:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80001ca4:	01093703          	ld	a4,16(s2)
    80001ca8:	02095783          	lhu	a5,32(s2)
    80001cac:	8b9d                	andi	a5,a5,7
    80001cae:	078e                	slli	a5,a5,0x3
    80001cb0:	97ba                	add	a5,a5,a4
    80001cb2:	43c4                	lw	s1,4(a5)
    if(disk.info[id].status != 0)
    80001cb4:	20048793          	addi	a5,s1,512
    80001cb8:	0792                	slli	a5,a5,0x4
    80001cba:	97ce                	add	a5,a5,s3
    80001cbc:	0307c783          	lbu	a5,48(a5)
    80001cc0:	dbc5                	beqz	a5,80001c70 <virtio_disk_intr+0x58>
    80001cc2:	b755                	j	80001c66 <virtio_disk_intr+0x4e>
  }

//   release(&disk.vdisk_lock);
}
    80001cc4:	70a2                	ld	ra,40(sp)
    80001cc6:	7402                	ld	s0,32(sp)
    80001cc8:	64e2                	ld	s1,24(sp)
    80001cca:	6942                	ld	s2,16(sp)
    80001ccc:	69a2                	ld	s3,8(sp)
    80001cce:	6a02                	ld	s4,0(sp)
    80001cd0:	6145                	addi	sp,sp,48
    80001cd2:	8082                	ret
    80001cd4:	8082                	ret

0000000080001cd6 <fstest>:
#include "file.h"
#include "virtio.h"
#include "../defs.h"
#include "fstest.h"
void fstest()
{
    80001cd6:	715d                	addi	sp,sp,-80
    80001cd8:	e486                	sd	ra,72(sp)
    80001cda:	e0a2                	sd	s0,64(sp)
    80001cdc:	fc26                	sd	s1,56(sp)
    80001cde:	f84a                	sd	s2,48(sp)
    80001ce0:	0880                	addi	s0,sp,80
  struct inode* inode;
  struct superblock sb;
  read_superblock(&sb);
    80001ce2:	fc840513          	addi	a0,s0,-56
    80001ce6:	00000097          	auipc	ra,0x0
    80001cea:	07e080e7          	jalr	126(ra) # 80001d64 <read_superblock>
  printf("%p\n", sb.magic);
    80001cee:	fc842583          	lw	a1,-56(s0)
    80001cf2:	00002517          	auipc	a0,0x2
    80001cf6:	84e50513          	addi	a0,a0,-1970 # 80003540 <digits+0x508>
    80001cfa:	ffffe097          	auipc	ra,0xffffe
    80001cfe:	7c8080e7          	jalr	1992(ra) # 800004c2 <printf>
  inode = alloc_inode(T_FILE);
    80001d02:	4509                	li	a0,2
    80001d04:	00000097          	auipc	ra,0x0
    80001d08:	4cc080e7          	jalr	1228(ra) # 800021d0 <alloc_inode>
    80001d0c:	84aa                	mv	s1,a0
  char* str = "hello world!";
  write_inode(inode, (uint64)str, 0, strlen(str));
    80001d0e:	00002917          	auipc	s2,0x2
    80001d12:	83a90913          	addi	s2,s2,-1990 # 80003548 <digits+0x510>
    80001d16:	854a                	mv	a0,s2
    80001d18:	00000097          	auipc	ra,0x0
    80001d1c:	88c080e7          	jalr	-1908(ra) # 800015a4 <strlen>
    80001d20:	0005069b          	sext.w	a3,a0
    80001d24:	4601                	li	a2,0
    80001d26:	85ca                	mv	a1,s2
    80001d28:	8526                	mv	a0,s1
    80001d2a:	00000097          	auipc	ra,0x0
    80001d2e:	6ca080e7          	jalr	1738(ra) # 800023f4 <write_inode>
  char s[20];
  read_inode(inode, (uint64)s, 0, 30);
    80001d32:	46f9                	li	a3,30
    80001d34:	4601                	li	a2,0
    80001d36:	fb040593          	addi	a1,s0,-80
    80001d3a:	8526                	mv	a0,s1
    80001d3c:	00000097          	auipc	ra,0x0
    80001d40:	5ee080e7          	jalr	1518(ra) # 8000232a <read_inode>
  printf("%s",s);
    80001d44:	fb040593          	addi	a1,s0,-80
    80001d48:	00002517          	auipc	a0,0x2
    80001d4c:	81050513          	addi	a0,a0,-2032 # 80003558 <digits+0x520>
    80001d50:	ffffe097          	auipc	ra,0xffffe
    80001d54:	772080e7          	jalr	1906(ra) # 800004c2 <printf>
}
    80001d58:	60a6                	ld	ra,72(sp)
    80001d5a:	6406                	ld	s0,64(sp)
    80001d5c:	74e2                	ld	s1,56(sp)
    80001d5e:	7942                	ld	s2,48(sp)
    80001d60:	6161                	addi	sp,sp,80
    80001d62:	8082                	ret

0000000080001d64 <read_superblock>:
#define min(a, b) ((a) < (b) ? (a) : (b))
struct superblock sb;

// 读取超级块
void read_superblock(struct superblock* sb)
{
    80001d64:	bc010113          	addi	sp,sp,-1088
    80001d68:	42113c23          	sd	ra,1080(sp)
    80001d6c:	42813823          	sd	s0,1072(sp)
    80001d70:	42913423          	sd	s1,1064(sp)
    80001d74:	44010413          	addi	s0,sp,1088
    80001d78:	84aa                	mv	s1,a0
  struct buf b;
  b.blockno = 1;
    80001d7a:	4785                	li	a5,1
    80001d7c:	bcf42a23          	sw	a5,-1068(s0)
  virtio_disk_rw(&b, DISK_READ);
    80001d80:	4581                	li	a1,0
    80001d82:	bc840513          	addi	a0,s0,-1080
    80001d86:	00000097          	auipc	ra,0x0
    80001d8a:	bd8080e7          	jalr	-1064(ra) # 8000195e <virtio_disk_rw>
  memmove(sb, &b.data, sizeof(*sb));
    80001d8e:	4661                	li	a2,24
    80001d90:	bdc40593          	addi	a1,s0,-1060
    80001d94:	8526                	mv	a0,s1
    80001d96:	fffff097          	auipc	ra,0xfffff
    80001d9a:	7b2080e7          	jalr	1970(ra) # 80001548 <memmove>
  printf("num=%d\n", b.data[0]);
    80001d9e:	bdc44583          	lbu	a1,-1060(s0)
    80001da2:	00001517          	auipc	a0,0x1
    80001da6:	7be50513          	addi	a0,a0,1982 # 80003560 <digits+0x528>
    80001daa:	ffffe097          	auipc	ra,0xffffe
    80001dae:	718080e7          	jalr	1816(ra) # 800004c2 <printf>
  return;
}
    80001db2:	43813083          	ld	ra,1080(sp)
    80001db6:	43013403          	ld	s0,1072(sp)
    80001dba:	42813483          	ld	s1,1064(sp)
    80001dbe:	44010113          	addi	sp,sp,1088
    80001dc2:	8082                	ret

0000000080001dc4 <init_fs>:

// 初始化文件系统
void init_fs()
{
    80001dc4:	1101                	addi	sp,sp,-32
    80001dc6:	ec06                	sd	ra,24(sp)
    80001dc8:	e822                	sd	s0,16(sp)
    80001dca:	e426                	sd	s1,8(sp)
    80001dcc:	1000                	addi	s0,sp,32
  read_superblock(&sb);
    80001dce:	0004a497          	auipc	s1,0x4a
    80001dd2:	23248493          	addi	s1,s1,562 # 8004c000 <sb>
    80001dd6:	8526                	mv	a0,s1
    80001dd8:	00000097          	auipc	ra,0x0
    80001ddc:	f8c080e7          	jalr	-116(ra) # 80001d64 <read_superblock>
  if (sb.magic != FSMAGIC) {
    80001de0:	4098                	lw	a4,0(s1)
    80001de2:	102037b7          	lui	a5,0x10203
    80001de6:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80001dea:	00f71763          	bne	a4,a5,80001df8 <init_fs+0x34>
    panic("fs init");
  }
}
    80001dee:	60e2                	ld	ra,24(sp)
    80001df0:	6442                	ld	s0,16(sp)
    80001df2:	64a2                	ld	s1,8(sp)
    80001df4:	6105                	addi	sp,sp,32
    80001df6:	8082                	ret
    panic("fs init");
    80001df8:	00001517          	auipc	a0,0x1
    80001dfc:	77050513          	addi	a0,a0,1904 # 80003568 <digits+0x530>
    80001e00:	fffff097          	auipc	ra,0xfffff
    80001e04:	8ce080e7          	jalr	-1842(ra) # 800006ce <panic>
}
    80001e08:	b7dd                	j	80001dee <init_fs+0x2a>

0000000080001e0a <zero_block>:

// 格式化磁盘块中的数据
void zero_block(int blockno)
{
    80001e0a:	1101                	addi	sp,sp,-32
    80001e0c:	ec06                	sd	ra,24(sp)
    80001e0e:	e822                	sd	s0,16(sp)
    80001e10:	e426                	sd	s1,8(sp)
    80001e12:	1000                	addi	s0,sp,32
    80001e14:	85aa                	mv	a1,a0
  struct buf *bp;
  bp = buf_read(0,blockno);
    80001e16:	4501                	li	a0,0
    80001e18:	00000097          	auipc	ra,0x0
    80001e1c:	766080e7          	jalr	1894(ra) # 8000257e <buf_read>
    80001e20:	84aa                	mv	s1,a0
  memset(bp->data, 0, BSIZE);
    80001e22:	40000613          	li	a2,1024
    80001e26:	4581                	li	a1,0
    80001e28:	0551                	addi	a0,a0,20
    80001e2a:	fffff097          	auipc	ra,0xfffff
    80001e2e:	6f8080e7          	jalr	1784(ra) # 80001522 <memset>
  buf_write(bp);
    80001e32:	8526                	mv	a0,s1
    80001e34:	00000097          	auipc	ra,0x0
    80001e38:	774080e7          	jalr	1908(ra) # 800025a8 <buf_write>
  relse_buf(bp);
    80001e3c:	8526                	mv	a0,s1
    80001e3e:	00000097          	auipc	ra,0x0
    80001e42:	700080e7          	jalr	1792(ra) # 8000253e <relse_buf>
}
    80001e46:	60e2                	ld	ra,24(sp)
    80001e48:	6442                	ld	s0,16(sp)
    80001e4a:	64a2                	ld	s1,8(sp)
    80001e4c:	6105                	addi	sp,sp,32
    80001e4e:	8082                	ret

0000000080001e50 <alloc_disk_block>:

// 申请空闲的磁盘块, 返回块号
uint alloc_disk_block()
{
    80001e50:	715d                	addi	sp,sp,-80
    80001e52:	e486                	sd	ra,72(sp)
    80001e54:	e0a2                	sd	s0,64(sp)
    80001e56:	fc26                	sd	s1,56(sp)
    80001e58:	f84a                	sd	s2,48(sp)
    80001e5a:	f44e                	sd	s3,40(sp)
    80001e5c:	f052                	sd	s4,32(sp)
    80001e5e:	ec56                	sd	s5,24(sp)
    80001e60:	e85a                	sd	s6,16(sp)
    80001e62:	e45e                	sd	s7,8(sp)
    80001e64:	0880                	addi	s0,sp,80
  int b, bi, m;
  struct buf* bitmap;

  bitmap = 0;
  for (b = 0; b < sb.size; b += BPB) { // 遍历bitmap
    80001e66:	0004a797          	auipc	a5,0x4a
    80001e6a:	19e7a783          	lw	a5,414(a5) # 8004c004 <sb+0x4>
    80001e6e:	c3e9                	beqz	a5,80001f30 <alloc_disk_block+0xe0>
    80001e70:	4a81                	li	s5,0
    bitmap = buf_read(0, BBLOCK(b, sb));
    80001e72:	0004ab17          	auipc	s6,0x4a
    80001e76:	18eb0b13          	addi	s6,s6,398 # 8004c000 <sb>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) { //遍历bitmap的每一位
      m = 1 << (bi % 8);
    80001e7a:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) { //遍历bitmap的每一位
    80001e7c:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB) { // 遍历bitmap
    80001e7e:	6b89                	lui	s7,0x2
    80001e80:	a0b1                	j	80001ecc <alloc_disk_block+0x7c>
      if ((bitmap->data[bi / 8] & m) == 0) { // 判断块是否被使用
        bitmap->data[bi / 8] |= m; // 标记块被使用
    80001e82:	972a                	add	a4,a4,a0
    80001e84:	8fd5                	or	a5,a5,a3
    80001e86:	00f70a23          	sb	a5,20(a4)
        relse_buf(bitmap);
    80001e8a:	00000097          	auipc	ra,0x0
    80001e8e:	6b4080e7          	jalr	1716(ra) # 8000253e <relse_buf>
        zero_block(b + bi);
    80001e92:	854a                	mv	a0,s2
    80001e94:	00000097          	auipc	ra,0x0
    80001e98:	f76080e7          	jalr	-138(ra) # 80001e0a <zero_block>
    }
    relse_buf(bitmap);
  }
  panic("balloc: out of blocks");
  return 0;
}
    80001e9c:	8526                	mv	a0,s1
    80001e9e:	60a6                	ld	ra,72(sp)
    80001ea0:	6406                	ld	s0,64(sp)
    80001ea2:	74e2                	ld	s1,56(sp)
    80001ea4:	7942                	ld	s2,48(sp)
    80001ea6:	79a2                	ld	s3,40(sp)
    80001ea8:	7a02                	ld	s4,32(sp)
    80001eaa:	6ae2                	ld	s5,24(sp)
    80001eac:	6b42                	ld	s6,16(sp)
    80001eae:	6ba2                	ld	s7,8(sp)
    80001eb0:	6161                	addi	sp,sp,80
    80001eb2:	8082                	ret
    relse_buf(bitmap);
    80001eb4:	00000097          	auipc	ra,0x0
    80001eb8:	68a080e7          	jalr	1674(ra) # 8000253e <relse_buf>
  for (b = 0; b < sb.size; b += BPB) { // 遍历bitmap
    80001ebc:	015b87bb          	addw	a5,s7,s5
    80001ec0:	00078a9b          	sext.w	s5,a5
    80001ec4:	004b2703          	lw	a4,4(s6)
    80001ec8:	06eaf463          	bgeu	s5,a4,80001f30 <alloc_disk_block+0xe0>
    bitmap = buf_read(0, BBLOCK(b, sb));
    80001ecc:	41fad79b          	sraiw	a5,s5,0x1f
    80001ed0:	0137d79b          	srliw	a5,a5,0x13
    80001ed4:	015787bb          	addw	a5,a5,s5
    80001ed8:	40d7d79b          	sraiw	a5,a5,0xd
    80001edc:	014b2583          	lw	a1,20(s6)
    80001ee0:	9dbd                	addw	a1,a1,a5
    80001ee2:	4501                	li	a0,0
    80001ee4:	00000097          	auipc	ra,0x0
    80001ee8:	69a080e7          	jalr	1690(ra) # 8000257e <buf_read>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) { //遍历bitmap的每一位
    80001eec:	004b2803          	lw	a6,4(s6)
    80001ef0:	000a849b          	sext.w	s1,s5
    80001ef4:	4601                	li	a2,0
    80001ef6:	0004891b          	sext.w	s2,s1
    80001efa:	fb04fde3          	bgeu	s1,a6,80001eb4 <alloc_disk_block+0x64>
      m = 1 << (bi % 8);
    80001efe:	41f6579b          	sraiw	a5,a2,0x1f
    80001f02:	01d7d69b          	srliw	a3,a5,0x1d
    80001f06:	00c6873b          	addw	a4,a3,a2
    80001f0a:	00777793          	andi	a5,a4,7
    80001f0e:	9f95                	subw	a5,a5,a3
    80001f10:	00f997bb          	sllw	a5,s3,a5
      if ((bitmap->data[bi / 8] & m) == 0) { // 判断块是否被使用
    80001f14:	4037571b          	sraiw	a4,a4,0x3
    80001f18:	00e506b3          	add	a3,a0,a4
    80001f1c:	0146c683          	lbu	a3,20(a3)
    80001f20:	00d7f5b3          	and	a1,a5,a3
    80001f24:	ddb9                	beqz	a1,80001e82 <alloc_disk_block+0x32>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) { //遍历bitmap的每一位
    80001f26:	2605                	addiw	a2,a2,1
    80001f28:	2485                	addiw	s1,s1,1
    80001f2a:	fd4616e3          	bne	a2,s4,80001ef6 <alloc_disk_block+0xa6>
    80001f2e:	b759                	j	80001eb4 <alloc_disk_block+0x64>
  panic("balloc: out of blocks");
    80001f30:	00001517          	auipc	a0,0x1
    80001f34:	64050513          	addi	a0,a0,1600 # 80003570 <digits+0x538>
    80001f38:	ffffe097          	auipc	ra,0xffffe
    80001f3c:	796080e7          	jalr	1942(ra) # 800006ce <panic>
  return 0;
    80001f40:	4481                	li	s1,0
    80001f42:	bfa9                	j	80001e9c <alloc_disk_block+0x4c>

0000000080001f44 <free_disk_block>:

// 释放磁盘块
void free_disk_block(int blockno)
{
    80001f44:	1101                	addi	sp,sp,-32
    80001f46:	ec06                	sd	ra,24(sp)
    80001f48:	e822                	sd	s0,16(sp)
    80001f4a:	e426                	sd	s1,8(sp)
    80001f4c:	e04a                	sd	s2,0(sp)
    80001f4e:	1000                	addi	s0,sp,32
  struct buf* bitmap;
  int bi, m;
  bitmap = buf_read(0, BBLOCK(blockno, sb));
    80001f50:	41f5549b          	sraiw	s1,a0,0x1f
    80001f54:	0134d91b          	srliw	s2,s1,0x13
    80001f58:	00a904bb          	addw	s1,s2,a0
    80001f5c:	40d4d59b          	sraiw	a1,s1,0xd
    80001f60:	0004a797          	auipc	a5,0x4a
    80001f64:	0b47a783          	lw	a5,180(a5) # 8004c014 <sb+0x14>
    80001f68:	9dbd                	addw	a1,a1,a5
    80001f6a:	4501                	li	a0,0
    80001f6c:	00000097          	auipc	ra,0x0
    80001f70:	612080e7          	jalr	1554(ra) # 8000257e <buf_read>
  bi = blockno % BPB;
    80001f74:	14ce                	slli	s1,s1,0x33
    80001f76:	90cd                	srli	s1,s1,0x33
    80001f78:	412484bb          	subw	s1,s1,s2
  m = 1 << (bi % 8);

  bitmap->data[bi / 8] &= ~m;
    80001f7c:	41f4d79b          	sraiw	a5,s1,0x1f
    80001f80:	01d7d79b          	srliw	a5,a5,0x1d
    80001f84:	9cbd                	addw	s1,s1,a5
    80001f86:	4034d71b          	sraiw	a4,s1,0x3
    80001f8a:	972a                	add	a4,a4,a0
  m = 1 << (bi % 8);
    80001f8c:	889d                	andi	s1,s1,7
    80001f8e:	9c9d                	subw	s1,s1,a5
  bitmap->data[bi / 8] &= ~m;
    80001f90:	4785                	li	a5,1
    80001f92:	009794bb          	sllw	s1,a5,s1
    80001f96:	fff4c493          	not	s1,s1
    80001f9a:	01474783          	lbu	a5,20(a4)
    80001f9e:	8cfd                	and	s1,s1,a5
    80001fa0:	00970a23          	sb	s1,20(a4)
  relse_buf(bitmap);
    80001fa4:	00000097          	auipc	ra,0x0
    80001fa8:	59a080e7          	jalr	1434(ra) # 8000253e <relse_buf>
}
    80001fac:	60e2                	ld	ra,24(sp)
    80001fae:	6442                	ld	s0,16(sp)
    80001fb0:	64a2                	ld	s1,8(sp)
    80001fb2:	6902                	ld	s2,0(sp)
    80001fb4:	6105                	addi	sp,sp,32
    80001fb6:	8082                	ret

0000000080001fb8 <init_inode_cache>:

//static struct inode* get_inode(int inum);

// 初始化inode的缓存
void init_inode_cache()
{
    80001fb8:	7179                	addi	sp,sp,-48
    80001fba:	f406                	sd	ra,40(sp)
    80001fbc:	f022                	sd	s0,32(sp)
    80001fbe:	ec26                	sd	s1,24(sp)
    80001fc0:	e84a                	sd	s2,16(sp)
    80001fc2:	e44e                	sd	s3,8(sp)
    80001fc4:	1800                	addi	s0,sp,48
  spinlock_init(&inode_cache.lock, "inode cache");
    80001fc6:	00001597          	auipc	a1,0x1
    80001fca:	5c258593          	addi	a1,a1,1474 # 80003588 <digits+0x550>
    80001fce:	0004a517          	auipc	a0,0x4a
    80001fd2:	04a50513          	addi	a0,a0,74 # 8004c018 <inode_cache>
    80001fd6:	00000097          	auipc	ra,0x0
    80001fda:	5ec080e7          	jalr	1516(ra) # 800025c2 <spinlock_init>
//  struct inode i;
  for (int i = 0; i < NINODE; i++) {
    80001fde:	0004a497          	auipc	s1,0x4a
    80001fe2:	06248493          	addi	s1,s1,98 # 8004c040 <inode_cache+0x28>
    80001fe6:	0004c997          	auipc	s3,0x4c
    80001fea:	aea98993          	addi	s3,s3,-1302 # 8004dad0 <buf_cache+0x10>
    sleeplock_init(&inode_cache.inode[i].lock, "inode");
    80001fee:	00001917          	auipc	s2,0x1
    80001ff2:	5aa90913          	addi	s2,s2,1450 # 80003598 <digits+0x560>
    80001ff6:	85ca                	mv	a1,s2
    80001ff8:	8526                	mv	a0,s1
    80001ffa:	00000097          	auipc	ra,0x0
    80001ffe:	764080e7          	jalr	1892(ra) # 8000275e <sleeplock_init>
  for (int i = 0; i < NINODE; i++) {
    80002002:	08848493          	addi	s1,s1,136
    80002006:	ff3498e3          	bne	s1,s3,80001ff6 <init_inode_cache+0x3e>
  }
}
    8000200a:	70a2                	ld	ra,40(sp)
    8000200c:	7402                	ld	s0,32(sp)
    8000200e:	64e2                	ld	s1,24(sp)
    80002010:	6942                	ld	s2,16(sp)
    80002012:	69a2                	ld	s3,8(sp)
    80002014:	6145                	addi	sp,sp,48
    80002016:	8082                	ret

0000000080002018 <update_inode>:
  return 0;
}

// 将内存中的inode写入到磁盘中,
void update_inode(struct inode* ip)
{
    80002018:	1101                	addi	sp,sp,-32
    8000201a:	ec06                	sd	ra,24(sp)
    8000201c:	e822                	sd	s0,16(sp)
    8000201e:	e426                	sd	s1,8(sp)
    80002020:	e04a                	sd	s2,0(sp)
    80002022:	1000                	addi	s0,sp,32
    80002024:	84aa                	mv	s1,a0
  struct buf* bp;
  struct dinode* dip;

  bp = buf_read(ip->dev, IBLOCK(ip->inum, sb));
    80002026:	415c                	lw	a5,4(a0)
    80002028:	0047d79b          	srliw	a5,a5,0x4
    8000202c:	0004a597          	auipc	a1,0x4a
    80002030:	fe45a583          	lw	a1,-28(a1) # 8004c010 <sb+0x10>
    80002034:	9dbd                	addw	a1,a1,a5
    80002036:	4108                	lw	a0,0(a0)
    80002038:	00000097          	auipc	ra,0x0
    8000203c:	546080e7          	jalr	1350(ra) # 8000257e <buf_read>
    80002040:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum % IPB;
    80002042:	01450793          	addi	a5,a0,20
    80002046:	40c8                	lw	a0,4(s1)
    80002048:	893d                	andi	a0,a0,15
    8000204a:	051a                	slli	a0,a0,0x6
    8000204c:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    8000204e:	04449703          	lh	a4,68(s1)
    80002052:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002056:	04649703          	lh	a4,70(s1)
    8000205a:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    8000205e:	04849703          	lh	a4,72(s1)
    80002062:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002066:	04a49703          	lh	a4,74(s1)
    8000206a:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    8000206e:	44f8                	lw	a4,76(s1)
    80002070:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002072:	03400613          	li	a2,52
    80002076:	05048593          	addi	a1,s1,80
    8000207a:	0531                	addi	a0,a0,12
    8000207c:	fffff097          	auipc	ra,0xfffff
    80002080:	4cc080e7          	jalr	1228(ra) # 80001548 <memmove>
  buf_write(bp);
    80002084:	854a                	mv	a0,s2
    80002086:	00000097          	auipc	ra,0x0
    8000208a:	522080e7          	jalr	1314(ra) # 800025a8 <buf_write>
  relse_buf(bp);
    8000208e:	854a                	mv	a0,s2
    80002090:	00000097          	auipc	ra,0x0
    80002094:	4ae080e7          	jalr	1198(ra) # 8000253e <relse_buf>
}
    80002098:	60e2                	ld	ra,24(sp)
    8000209a:	6442                	ld	s0,16(sp)
    8000209c:	64a2                	ld	s1,8(sp)
    8000209e:	6902                	ld	s2,0(sp)
    800020a0:	6105                	addi	sp,sp,32
    800020a2:	8082                	ret

00000000800020a4 <get_inode>:

// 通过inum从缓冲池中获取一个inode
struct inode* get_inode(int inum)
{
    800020a4:	7179                	addi	sp,sp,-48
    800020a6:	f406                	sd	ra,40(sp)
    800020a8:	f022                	sd	s0,32(sp)
    800020aa:	ec26                	sd	s1,24(sp)
    800020ac:	e84a                	sd	s2,16(sp)
    800020ae:	e44e                	sd	s3,8(sp)
    800020b0:	1800                	addi	s0,sp,48
    800020b2:	89aa                	mv	s3,a0
  struct inode* ip;
  struct inode* empty;
  struct buf* bp;
  struct dinode* dip;

  spin_lock(&inode_cache.lock);
    800020b4:	0004a517          	auipc	a0,0x4a
    800020b8:	f6450513          	addi	a0,a0,-156 # 8004c018 <inode_cache>
    800020bc:	00000097          	auipc	ra,0x0
    800020c0:	596080e7          	jalr	1430(ra) # 80002652 <spin_lock>
  empty = 0;
    800020c4:	4901                	li	s2,0
  for (ip = &inode_cache.inode[0]; ip < &inode_cache.inode[NINODE]; ip++) {
    800020c6:	0004a497          	auipc	s1,0x4a
    800020ca:	f6a48493          	addi	s1,s1,-150 # 8004c030 <inode_cache+0x18>
    if (ip->ref > 0 && ip->inum == inum) {
    800020ce:	0009861b          	sext.w	a2,s3
  for (ip = &inode_cache.inode[0]; ip < &inode_cache.inode[NINODE]; ip++) {
    800020d2:	0004c697          	auipc	a3,0x4c
    800020d6:	9ee68693          	addi	a3,a3,-1554 # 8004dac0 <buf_cache>
    800020da:	a039                	j	800020e8 <get_inode+0x44>
      ip->ref++;
      spin_unlock(&inode_cache.lock);
      return ip;
    }
    if (empty == 0 && ip->ref == 0) { // 记住未使用缓冲项
    800020dc:	02090e63          	beqz	s2,80002118 <get_inode+0x74>
  for (ip = &inode_cache.inode[0]; ip < &inode_cache.inode[NINODE]; ip++) {
    800020e0:	08848493          	addi	s1,s1,136
    800020e4:	02d48d63          	beq	s1,a3,8000211e <get_inode+0x7a>
    if (ip->ref > 0 && ip->inum == inum) {
    800020e8:	449c                	lw	a5,8(s1)
    800020ea:	fef059e3          	blez	a5,800020dc <get_inode+0x38>
    800020ee:	40d8                	lw	a4,4(s1)
    800020f0:	fec716e3          	bne	a4,a2,800020dc <get_inode+0x38>
      ip->ref++;
    800020f4:	2785                	addiw	a5,a5,1
    800020f6:	c49c                	sw	a5,8(s1)
      spin_unlock(&inode_cache.lock);
    800020f8:	0004a517          	auipc	a0,0x4a
    800020fc:	f2050513          	addi	a0,a0,-224 # 8004c018 <inode_cache>
    80002100:	00000097          	auipc	ra,0x0
    80002104:	614080e7          	jalr	1556(ra) # 80002714 <spin_unlock>
  if (ip->type == 0)
    panic("ilock: no type");

  spin_unlock(&inode_cache.lock);
  return ip;
}
    80002108:	8526                	mv	a0,s1
    8000210a:	70a2                	ld	ra,40(sp)
    8000210c:	7402                	ld	s0,32(sp)
    8000210e:	64e2                	ld	s1,24(sp)
    80002110:	6942                	ld	s2,16(sp)
    80002112:	69a2                	ld	s3,8(sp)
    80002114:	6145                	addi	sp,sp,48
    80002116:	8082                	ret
    if (empty == 0 && ip->ref == 0) { // 记住未使用缓冲项
    80002118:	f7e1                	bnez	a5,800020e0 <get_inode+0x3c>
    8000211a:	8926                	mv	s2,s1
    8000211c:	b7d1                	j	800020e0 <get_inode+0x3c>
  if (empty == 0) {
    8000211e:	08090763          	beqz	s2,800021ac <get_inode+0x108>
  bp = buf_read(ip->dev, IBLOCK(ip->inum, sb));
    80002122:	00492783          	lw	a5,4(s2)
    80002126:	0047d79b          	srliw	a5,a5,0x4
    8000212a:	0004a597          	auipc	a1,0x4a
    8000212e:	ee65a583          	lw	a1,-282(a1) # 8004c010 <sb+0x10>
    80002132:	9dbd                	addw	a1,a1,a5
    80002134:	00092503          	lw	a0,0(s2)
    80002138:	00000097          	auipc	ra,0x0
    8000213c:	446080e7          	jalr	1094(ra) # 8000257e <buf_read>
    80002140:	84aa                	mv	s1,a0
  dip = (struct dinode*)bp->data + ip->inum % IPB;
    80002142:	01450593          	addi	a1,a0,20
    80002146:	00492783          	lw	a5,4(s2)
    8000214a:	8bbd                	andi	a5,a5,15
    8000214c:	079a                	slli	a5,a5,0x6
    8000214e:	95be                	add	a1,a1,a5
  ip->type = dip->type;
    80002150:	00059783          	lh	a5,0(a1)
    80002154:	04f91223          	sh	a5,68(s2)
  ip->major = dip->major;
    80002158:	00259783          	lh	a5,2(a1)
    8000215c:	04f91323          	sh	a5,70(s2)
  ip->minor = dip->minor;
    80002160:	00459783          	lh	a5,4(a1)
    80002164:	04f91423          	sh	a5,72(s2)
  ip->nlink = dip->nlink;
    80002168:	00659783          	lh	a5,6(a1)
    8000216c:	04f91523          	sh	a5,74(s2)
  ip->size = dip->size;
    80002170:	459c                	lw	a5,8(a1)
    80002172:	04f92623          	sw	a5,76(s2)
  memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002176:	03400613          	li	a2,52
    8000217a:	05b1                	addi	a1,a1,12
    8000217c:	05090513          	addi	a0,s2,80
    80002180:	fffff097          	auipc	ra,0xfffff
    80002184:	3c8080e7          	jalr	968(ra) # 80001548 <memmove>
  relse_buf(bp);
    80002188:	8526                	mv	a0,s1
    8000218a:	00000097          	auipc	ra,0x0
    8000218e:	3b4080e7          	jalr	948(ra) # 8000253e <relse_buf>
  if (ip->type == 0)
    80002192:	04491783          	lh	a5,68(s2)
    80002196:	c785                	beqz	a5,800021be <get_inode+0x11a>
  spin_unlock(&inode_cache.lock);
    80002198:	0004a517          	auipc	a0,0x4a
    8000219c:	e8050513          	addi	a0,a0,-384 # 8004c018 <inode_cache>
    800021a0:	00000097          	auipc	ra,0x0
    800021a4:	574080e7          	jalr	1396(ra) # 80002714 <spin_unlock>
  return ip;
    800021a8:	84ca                	mv	s1,s2
    800021aa:	bfb9                	j	80002108 <get_inode+0x64>
    panic("get_inode");
    800021ac:	00001517          	auipc	a0,0x1
    800021b0:	3f450513          	addi	a0,a0,1012 # 800035a0 <digits+0x568>
    800021b4:	ffffe097          	auipc	ra,0xffffe
    800021b8:	51a080e7          	jalr	1306(ra) # 800006ce <panic>
    800021bc:	b79d                	j	80002122 <get_inode+0x7e>
    panic("ilock: no type");
    800021be:	00001517          	auipc	a0,0x1
    800021c2:	3f250513          	addi	a0,a0,1010 # 800035b0 <digits+0x578>
    800021c6:	ffffe097          	auipc	ra,0xffffe
    800021ca:	508080e7          	jalr	1288(ra) # 800006ce <panic>
    800021ce:	b7e9                	j	80002198 <get_inode+0xf4>

00000000800021d0 <alloc_inode>:
{
    800021d0:	7139                	addi	sp,sp,-64
    800021d2:	fc06                	sd	ra,56(sp)
    800021d4:	f822                	sd	s0,48(sp)
    800021d6:	f426                	sd	s1,40(sp)
    800021d8:	f04a                	sd	s2,32(sp)
    800021da:	ec4e                	sd	s3,24(sp)
    800021dc:	e852                	sd	s4,16(sp)
    800021de:	e456                	sd	s5,8(sp)
    800021e0:	e05a                	sd	s6,0(sp)
    800021e2:	0080                	addi	s0,sp,64
  for (inum = 1; inum < sb.ninodes; inum++) {
    800021e4:	0004a717          	auipc	a4,0x4a
    800021e8:	e2872703          	lw	a4,-472(a4) # 8004c00c <sb+0xc>
    800021ec:	4785                	li	a5,1
    800021ee:	04e7f963          	bgeu	a5,a4,80002240 <alloc_inode+0x70>
    800021f2:	8b2a                	mv	s6,a0
    800021f4:	4905                	li	s2,1
    bp = buf_read(0, IBLOCK(inum, sb));
    800021f6:	0004aa97          	auipc	s5,0x4a
    800021fa:	e0aa8a93          	addi	s5,s5,-502 # 8004c000 <sb>
    800021fe:	00090a1b          	sext.w	s4,s2
    80002202:	00495593          	srli	a1,s2,0x4
    80002206:	010aa783          	lw	a5,16(s5)
    8000220a:	9dbd                	addw	a1,a1,a5
    8000220c:	4501                	li	a0,0
    8000220e:	00000097          	auipc	ra,0x0
    80002212:	370080e7          	jalr	880(ra) # 8000257e <buf_read>
    80002216:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum % IPB;
    80002218:	01450993          	addi	s3,a0,20
    8000221c:	00fa7793          	andi	a5,s4,15
    80002220:	079a                	slli	a5,a5,0x6
    80002222:	99be                	add	s3,s3,a5
    if (dip->type == 0) { // a free inode
    80002224:	00099783          	lh	a5,0(s3)
    80002228:	cf9d                	beqz	a5,80002266 <alloc_inode+0x96>
    relse_buf(bp);
    8000222a:	00000097          	auipc	ra,0x0
    8000222e:	314080e7          	jalr	788(ra) # 8000253e <relse_buf>
  for (inum = 1; inum < sb.ninodes; inum++) {
    80002232:	0905                	addi	s2,s2,1
    80002234:	00caa703          	lw	a4,12(s5)
    80002238:	0009079b          	sext.w	a5,s2
    8000223c:	fce7e1e3          	bltu	a5,a4,800021fe <alloc_inode+0x2e>
  panic("alloc_inode: no inodes");
    80002240:	00001517          	auipc	a0,0x1
    80002244:	38050513          	addi	a0,a0,896 # 800035c0 <digits+0x588>
    80002248:	ffffe097          	auipc	ra,0xffffe
    8000224c:	486080e7          	jalr	1158(ra) # 800006ce <panic>
  return 0;
    80002250:	4501                	li	a0,0
}
    80002252:	70e2                	ld	ra,56(sp)
    80002254:	7442                	ld	s0,48(sp)
    80002256:	74a2                	ld	s1,40(sp)
    80002258:	7902                	ld	s2,32(sp)
    8000225a:	69e2                	ld	s3,24(sp)
    8000225c:	6a42                	ld	s4,16(sp)
    8000225e:	6aa2                	ld	s5,8(sp)
    80002260:	6b02                	ld	s6,0(sp)
    80002262:	6121                	addi	sp,sp,64
    80002264:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002266:	04000613          	li	a2,64
    8000226a:	4581                	li	a1,0
    8000226c:	854e                	mv	a0,s3
    8000226e:	fffff097          	auipc	ra,0xfffff
    80002272:	2b4080e7          	jalr	692(ra) # 80001522 <memset>
      dip->type = type;
    80002276:	01699023          	sh	s6,0(s3)
      buf_write(bp); // mark it allocated on the disk
    8000227a:	8526                	mv	a0,s1
    8000227c:	00000097          	auipc	ra,0x0
    80002280:	32c080e7          	jalr	812(ra) # 800025a8 <buf_write>
      relse_buf(bp);
    80002284:	8526                	mv	a0,s1
    80002286:	00000097          	auipc	ra,0x0
    8000228a:	2b8080e7          	jalr	696(ra) # 8000253e <relse_buf>
      return get_inode(inum);
    8000228e:	8552                	mv	a0,s4
    80002290:	00000097          	auipc	ra,0x0
    80002294:	e14080e7          	jalr	-492(ra) # 800020a4 <get_inode>
    80002298:	bf6d                	j	80002252 <alloc_inode+0x82>

000000008000229a <putback_inode>:

// 通过inum从缓冲池中获取一个inode
void putback_inode(struct inode* ip)
{
    8000229a:	1101                	addi	sp,sp,-32
    8000229c:	ec06                	sd	ra,24(sp)
    8000229e:	e822                	sd	s0,16(sp)
    800022a0:	e426                	sd	s1,8(sp)
    800022a2:	1000                	addi	s0,sp,32
    800022a4:	84aa                	mv	s1,a0
  spin_lock(&inode_cache.lock);
    800022a6:	0004a517          	auipc	a0,0x4a
    800022aa:	d7250513          	addi	a0,a0,-654 # 8004c018 <inode_cache>
    800022ae:	00000097          	auipc	ra,0x0
    800022b2:	3a4080e7          	jalr	932(ra) # 80002652 <spin_lock>
  ip->ref--;
    800022b6:	449c                	lw	a5,8(s1)
    800022b8:	37fd                	addiw	a5,a5,-1
    800022ba:	c49c                	sw	a5,8(s1)
  spin_unlock(&inode_cache.lock);
    800022bc:	0004a517          	auipc	a0,0x4a
    800022c0:	d5c50513          	addi	a0,a0,-676 # 8004c018 <inode_cache>
    800022c4:	00000097          	auipc	ra,0x0
    800022c8:	450080e7          	jalr	1104(ra) # 80002714 <spin_unlock>
}
    800022cc:	60e2                	ld	ra,24(sp)
    800022ce:	6442                	ld	s0,16(sp)
    800022d0:	64a2                	ld	s1,8(sp)
    800022d2:	6105                	addi	sp,sp,32
    800022d4:	8082                	ret

00000000800022d6 <bmap>:

// 数据块包含直接块和间接块，这里只实现了直接块
// 获取inode的第bn个数据块对应的磁盘块号
uint bmap(struct inode* ip, uint bn)
{
    800022d6:	1101                	addi	sp,sp,-32
    800022d8:	ec06                	sd	ra,24(sp)
    800022da:	e822                	sd	s0,16(sp)
    800022dc:	e426                	sd	s1,8(sp)
    800022de:	1000                	addi	s0,sp,32
  uint64 addr;
  if (bn < NDIRECT) {
    800022e0:	47ad                	li	a5,11
    800022e2:	02b7ea63          	bltu	a5,a1,80002316 <bmap+0x40>
    if ((addr = ip->addrs[bn]) == 0)
    800022e6:	1582                	slli	a1,a1,0x20
    800022e8:	9181                	srli	a1,a1,0x20
    800022ea:	058a                	slli	a1,a1,0x2
    800022ec:	00b504b3          	add	s1,a0,a1
    800022f0:	0504e783          	lwu	a5,80(s1)
    800022f4:	cb81                	beqz	a5,80002304 <bmap+0x2e>
      ip->addrs[bn] = addr = alloc_disk_block();
    return addr;
    800022f6:	0007851b          	sext.w	a0,a5
  }
  panic("bmap");
  return 0;
}
    800022fa:	60e2                	ld	ra,24(sp)
    800022fc:	6442                	ld	s0,16(sp)
    800022fe:	64a2                	ld	s1,8(sp)
    80002300:	6105                	addi	sp,sp,32
    80002302:	8082                	ret
      ip->addrs[bn] = addr = alloc_disk_block();
    80002304:	00000097          	auipc	ra,0x0
    80002308:	b4c080e7          	jalr	-1204(ra) # 80001e50 <alloc_disk_block>
    8000230c:	02051793          	slli	a5,a0,0x20
    80002310:	9381                	srli	a5,a5,0x20
    80002312:	c8a8                	sw	a0,80(s1)
    80002314:	b7cd                	j	800022f6 <bmap+0x20>
  panic("bmap");
    80002316:	00001517          	auipc	a0,0x1
    8000231a:	2c250513          	addi	a0,a0,706 # 800035d8 <digits+0x5a0>
    8000231e:	ffffe097          	auipc	ra,0xffffe
    80002322:	3b0080e7          	jalr	944(ra) # 800006ce <panic>
  return 0;
    80002326:	4501                	li	a0,0
    80002328:	bfc9                	j	800022fa <bmap+0x24>

000000008000232a <read_inode>:

// 从inode中读取数据
int read_inode(struct inode* ip, uint64 dst, uint off, int n)
{
    8000232a:	711d                	addi	sp,sp,-96
    8000232c:	ec86                	sd	ra,88(sp)
    8000232e:	e8a2                	sd	s0,80(sp)
    80002330:	e4a6                	sd	s1,72(sp)
    80002332:	e0ca                	sd	s2,64(sp)
    80002334:	fc4e                	sd	s3,56(sp)
    80002336:	f852                	sd	s4,48(sp)
    80002338:	f456                	sd	s5,40(sp)
    8000233a:	f05a                	sd	s6,32(sp)
    8000233c:	ec5e                	sd	s7,24(sp)
    8000233e:	e862                	sd	s8,16(sp)
    80002340:	e466                	sd	s9,8(sp)
    80002342:	1080                	addi	s0,sp,96
  int total = 0, m = 0;
  struct buf* bp;
  if (off > ip->size || off + n < off) {
    80002344:	457c                	lw	a5,76(a0)
    return 0;
    80002346:	4981                	li	s3,0
  if (off > ip->size || off + n < off) {
    80002348:	02c7e463          	bltu	a5,a2,80002370 <read_inode+0x46>
    8000234c:	8baa                	mv	s7,a0
    8000234e:	8aae                	mv	s5,a1
    80002350:	84b2                	mv	s1,a2
    80002352:	8b36                	mv	s6,a3
    80002354:	00c6873b          	addw	a4,a3,a2
    return 0;
    80002358:	4981                	li	s3,0
  if (off > ip->size || off + n < off) {
    8000235a:	00c76b63          	bltu	a4,a2,80002370 <read_inode+0x46>
  }
  if (off + n > ip->size) {
    8000235e:	00e7f463          	bgeu	a5,a4,80002366 <read_inode+0x3c>
    n = ip->size - off;
    80002362:	40c78b3b          	subw	s6,a5,a2
  }

  for (; total < n; total += m, off += m, dst += m) {
    80002366:	4981                	li	s3,0
    bp = buf_read(0, bmap(ip, off / BSIZE));
    m = min(BSIZE - off % BSIZE, n - total);
    80002368:	40000c13          	li	s8,1024
  for (; total < n; total += m, off += m, dst += m) {
    8000236c:	05604763          	bgtz	s6,800023ba <read_inode+0x90>
    memmove((uint64*)(dst), bp->data + (off % BSIZE), m);
    relse_buf(bp);
  }
  return total;
}
    80002370:	854e                	mv	a0,s3
    80002372:	60e6                	ld	ra,88(sp)
    80002374:	6446                	ld	s0,80(sp)
    80002376:	64a6                	ld	s1,72(sp)
    80002378:	6906                	ld	s2,64(sp)
    8000237a:	79e2                	ld	s3,56(sp)
    8000237c:	7a42                	ld	s4,48(sp)
    8000237e:	7aa2                	ld	s5,40(sp)
    80002380:	7b02                	ld	s6,32(sp)
    80002382:	6be2                	ld	s7,24(sp)
    80002384:	6c42                	ld	s8,16(sp)
    80002386:	6ca2                	ld	s9,8(sp)
    80002388:	6125                	addi	sp,sp,96
    8000238a:	8082                	ret
    m = min(BSIZE - off % BSIZE, n - total);
    8000238c:	000a0c9b          	sext.w	s9,s4
    memmove((uint64*)(dst), bp->data + (off % BSIZE), m);
    80002390:	01490593          	addi	a1,s2,20
    80002394:	8666                	mv	a2,s9
    80002396:	95ba                	add	a1,a1,a4
    80002398:	8556                	mv	a0,s5
    8000239a:	fffff097          	auipc	ra,0xfffff
    8000239e:	1ae080e7          	jalr	430(ra) # 80001548 <memmove>
    relse_buf(bp);
    800023a2:	854a                	mv	a0,s2
    800023a4:	00000097          	auipc	ra,0x0
    800023a8:	19a080e7          	jalr	410(ra) # 8000253e <relse_buf>
  for (; total < n; total += m, off += m, dst += m) {
    800023ac:	013a09bb          	addw	s3,s4,s3
    800023b0:	009a04bb          	addw	s1,s4,s1
    800023b4:	9ae6                	add	s5,s5,s9
    800023b6:	fb69dde3          	bge	s3,s6,80002370 <read_inode+0x46>
    bp = buf_read(0, bmap(ip, off / BSIZE));
    800023ba:	00a4d59b          	srliw	a1,s1,0xa
    800023be:	855e                	mv	a0,s7
    800023c0:	00000097          	auipc	ra,0x0
    800023c4:	f16080e7          	jalr	-234(ra) # 800022d6 <bmap>
    800023c8:	0005059b          	sext.w	a1,a0
    800023cc:	4501                	li	a0,0
    800023ce:	00000097          	auipc	ra,0x0
    800023d2:	1b0080e7          	jalr	432(ra) # 8000257e <buf_read>
    800023d6:	892a                	mv	s2,a0
    m = min(BSIZE - off % BSIZE, n - total);
    800023d8:	3ff4f713          	andi	a4,s1,1023
    800023dc:	413b07bb          	subw	a5,s6,s3
    800023e0:	40ec06bb          	subw	a3,s8,a4
    800023e4:	8a3e                	mv	s4,a5
    800023e6:	2781                	sext.w	a5,a5
    800023e8:	0006861b          	sext.w	a2,a3
    800023ec:	faf670e3          	bgeu	a2,a5,8000238c <read_inode+0x62>
    800023f0:	8a36                	mv	s4,a3
    800023f2:	bf69                	j	8000238c <read_inode+0x62>

00000000800023f4 <write_inode>:

int write_inode(struct inode* ip, uint64 src, uint64 off, int n)
{
    800023f4:	711d                	addi	sp,sp,-96
    800023f6:	ec86                	sd	ra,88(sp)
    800023f8:	e8a2                	sd	s0,80(sp)
    800023fa:	e4a6                	sd	s1,72(sp)
    800023fc:	e0ca                	sd	s2,64(sp)
    800023fe:	fc4e                	sd	s3,56(sp)
    80002400:	f852                	sd	s4,48(sp)
    80002402:	f456                	sd	s5,40(sp)
    80002404:	f05a                	sd	s6,32(sp)
    80002406:	ec5e                	sd	s7,24(sp)
    80002408:	e862                	sd	s8,16(sp)
    8000240a:	e466                	sd	s9,8(sp)
    8000240c:	1080                	addi	s0,sp,96
  uint total, m;
  struct buf* bp;

  if (off > ip->size || off + n < off)
    8000240e:	04c56783          	lwu	a5,76(a0)
    80002412:	0cc7e263          	bltu	a5,a2,800024d6 <write_inode+0xe2>
    80002416:	8baa                	mv	s7,a0
    80002418:	8aae                	mv	s5,a1
    8000241a:	89b2                	mv	s3,a2
    8000241c:	8cb6                	mv	s9,a3
    8000241e:	00c687b3          	add	a5,a3,a2
    80002422:	0ac7ec63          	bltu	a5,a2,800024da <write_inode+0xe6>
    return -1;
  if (off + n > MAXFILE * BSIZE)
    80002426:	00043737          	lui	a4,0x43
    8000242a:	0af76a63          	bltu	a4,a5,800024de <write_inode+0xea>
    return -1;
  for (total=0; total < n; total += m, off += m, src += m) {
    8000242e:	00068b1b          	sext.w	s6,a3
    80002432:	0a0b0863          	beqz	s6,800024e2 <write_inode+0xee>
    80002436:	4a01                	li	s4,0
    bp = buf_read(0, bmap(ip, off / BSIZE));
    m = min(BSIZE - off % BSIZE, n - total);
    80002438:	40000c13          	li	s8,1024
    8000243c:	a035                	j	80002468 <write_inode+0x74>
    memmove((uint64*)(src), bp->data + (off % BSIZE), m);
    8000243e:	01490593          	addi	a1,s2,20
    80002442:	0004861b          	sext.w	a2,s1
    80002446:	95be                	add	a1,a1,a5
    80002448:	8556                	mv	a0,s5
    8000244a:	fffff097          	auipc	ra,0xfffff
    8000244e:	0fe080e7          	jalr	254(ra) # 80001548 <memmove>
    relse_buf(bp);
    80002452:	854a                	mv	a0,s2
    80002454:	00000097          	auipc	ra,0x0
    80002458:	0ea080e7          	jalr	234(ra) # 8000253e <relse_buf>
  for (total=0; total < n; total += m, off += m, src += m) {
    8000245c:	01448a3b          	addw	s4,s1,s4
    80002460:	99a6                	add	s3,s3,s1
    80002462:	9aa6                	add	s5,s5,s1
    80002464:	036a7e63          	bgeu	s4,s6,800024a0 <write_inode+0xac>
    bp = buf_read(0, bmap(ip, off / BSIZE));
    80002468:	00a9d593          	srli	a1,s3,0xa
    8000246c:	2581                	sext.w	a1,a1
    8000246e:	855e                	mv	a0,s7
    80002470:	00000097          	auipc	ra,0x0
    80002474:	e66080e7          	jalr	-410(ra) # 800022d6 <bmap>
    80002478:	0005059b          	sext.w	a1,a0
    8000247c:	4501                	li	a0,0
    8000247e:	00000097          	auipc	ra,0x0
    80002482:	100080e7          	jalr	256(ra) # 8000257e <buf_read>
    80002486:	892a                	mv	s2,a0
    m = min(BSIZE - off % BSIZE, n - total);
    80002488:	3ff9f793          	andi	a5,s3,1023
    8000248c:	414b04bb          	subw	s1,s6,s4
    80002490:	40fc0733          	sub	a4,s8,a5
    80002494:	1482                	slli	s1,s1,0x20
    80002496:	9081                	srli	s1,s1,0x20
    80002498:	fa9773e3          	bgeu	a4,s1,8000243e <write_inode+0x4a>
    8000249c:	84ba                	mv	s1,a4
    8000249e:	b745                	j	8000243e <write_inode+0x4a>
  }
  if (n > 0) {
    800024a0:	01905d63          	blez	s9,800024ba <write_inode+0xc6>
    if (off > ip->size)
    800024a4:	04cbe783          	lwu	a5,76(s7) # 204c <_entry-0x7fffdfb4>
    800024a8:	0137f463          	bgeu	a5,s3,800024b0 <write_inode+0xbc>
      ip->size = off;
    800024ac:	053ba623          	sw	s3,76(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    // 将内存中的inode写入磁盘，即使没有写入数据，也需要更新，因为循环中可能
    //调用了bmap()或者在ip->addrs[]里面添加了数据块
    update_inode(ip);
    800024b0:	855e                	mv	a0,s7
    800024b2:	00000097          	auipc	ra,0x0
    800024b6:	b66080e7          	jalr	-1178(ra) # 80002018 <update_inode>
  }
  return n;
}
    800024ba:	8566                	mv	a0,s9
    800024bc:	60e6                	ld	ra,88(sp)
    800024be:	6446                	ld	s0,80(sp)
    800024c0:	64a6                	ld	s1,72(sp)
    800024c2:	6906                	ld	s2,64(sp)
    800024c4:	79e2                	ld	s3,56(sp)
    800024c6:	7a42                	ld	s4,48(sp)
    800024c8:	7aa2                	ld	s5,40(sp)
    800024ca:	7b02                	ld	s6,32(sp)
    800024cc:	6be2                	ld	s7,24(sp)
    800024ce:	6c42                	ld	s8,16(sp)
    800024d0:	6ca2                	ld	s9,8(sp)
    800024d2:	6125                	addi	sp,sp,96
    800024d4:	8082                	ret
    return -1;
    800024d6:	5cfd                	li	s9,-1
    800024d8:	b7cd                	j	800024ba <write_inode+0xc6>
    800024da:	5cfd                	li	s9,-1
    800024dc:	bff9                	j	800024ba <write_inode+0xc6>
    return -1;
    800024de:	5cfd                	li	s9,-1
    800024e0:	bfe9                	j	800024ba <write_inode+0xc6>
  return n;
    800024e2:	4c81                	li	s9,0
    800024e4:	bfd9                	j	800024ba <write_inode+0xc6>

00000000800024e6 <alloc_buf>:
struct buf buf_cache[BUFFER_NUM];


// 申请使用一个缓冲区
struct buf* alloc_buf(int dev, int blockno)
{
    800024e6:	86aa                	mv	a3,a0
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800024e8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800024ec:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800024ee:	10079073          	csrw	sstatus,a5
  intr_off();
  struct buf* b;
  for (b = buf_cache; b < buf_cache + BUFFER_NUM; b++) {
    800024f2:	0004b517          	auipc	a0,0x4b
    800024f6:	5ce50513          	addi	a0,a0,1486 # 8004dac0 <buf_cache>
    800024fa:	00065717          	auipc	a4,0x65
    800024fe:	d9670713          	addi	a4,a4,-618 # 80067290 <buf_cache+0x197d0>
    if (b->refcnt == 0) {
    80002502:	491c                	lw	a5,16(a0)
    80002504:	c395                	beqz	a5,80002528 <alloc_buf+0x42>
  for (b = buf_cache; b < buf_cache + BUFFER_NUM; b++) {
    80002506:	41450513          	addi	a0,a0,1044
    8000250a:	fee51ce3          	bne	a0,a4,80002502 <alloc_buf+0x1c>
{
    8000250e:	1141                	addi	sp,sp,-16
    80002510:	e406                	sd	ra,8(sp)
    80002512:	e022                	sd	s0,0(sp)
    80002514:	0800                	addi	s0,sp,16
      b->dev = dev;
      intr_on();
      return b;
    }
  }
  panic();
    80002516:	ffffe097          	auipc	ra,0xffffe
    8000251a:	1b8080e7          	jalr	440(ra) # 800006ce <panic>
  return 0;
    8000251e:	4501                	li	a0,0
}
    80002520:	60a2                	ld	ra,8(sp)
    80002522:	6402                	ld	s0,0(sp)
    80002524:	0141                	addi	sp,sp,16
    80002526:	8082                	ret
      b->refcnt = 1;
    80002528:	4785                	li	a5,1
    8000252a:	c91c                	sw	a5,16(a0)
      b->blockno = blockno;
    8000252c:	c54c                	sw	a1,12(a0)
      b->dev = dev;
    8000252e:	c514                	sw	a3,8(a0)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002530:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002534:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002538:	10079073          	csrw	sstatus,a5
}
    8000253c:	8082                	ret

000000008000253e <relse_buf>:

// 释放缓冲区
void relse_buf(struct buf* b)
{
    8000253e:	1141                	addi	sp,sp,-16
    80002540:	e406                	sd	ra,8(sp)
    80002542:	e022                	sd	s0,0(sp)
    80002544:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002546:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000254a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000254c:	10079073          	csrw	sstatus,a5
  intr_off();
  b->refcnt = 0;
    80002550:	00052823          	sw	zero,16(a0)
  b->blockno = 0;
    80002554:	00052623          	sw	zero,12(a0)
  memset(b->data, 0, sizeof(buf_cache));
    80002558:	6665                	lui	a2,0x19
    8000255a:	7d060613          	addi	a2,a2,2000 # 197d0 <_entry-0x7ffe6830>
    8000255e:	4581                	li	a1,0
    80002560:	0551                	addi	a0,a0,20
    80002562:	fffff097          	auipc	ra,0xfffff
    80002566:	fc0080e7          	jalr	-64(ra) # 80001522 <memset>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000256a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000256e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002572:	10079073          	csrw	sstatus,a5
  intr_on();
}
    80002576:	60a2                	ld	ra,8(sp)
    80002578:	6402                	ld	s0,0(sp)
    8000257a:	0141                	addi	sp,sp,16
    8000257c:	8082                	ret

000000008000257e <buf_read>:

// 读取给定块的内容，返回一个包含该内容的buf
struct buf* buf_read(int dev, int blockno)
{
    8000257e:	1101                	addi	sp,sp,-32
    80002580:	ec06                	sd	ra,24(sp)
    80002582:	e822                	sd	s0,16(sp)
    80002584:	e426                	sd	s1,8(sp)
    80002586:	1000                	addi	s0,sp,32
  struct buf* b = alloc_buf(dev, blockno);
    80002588:	00000097          	auipc	ra,0x0
    8000258c:	f5e080e7          	jalr	-162(ra) # 800024e6 <alloc_buf>
    80002590:	84aa                	mv	s1,a0
  virtio_disk_rw(b, 0);
    80002592:	4581                	li	a1,0
    80002594:	fffff097          	auipc	ra,0xfffff
    80002598:	3ca080e7          	jalr	970(ra) # 8000195e <virtio_disk_rw>
  return b;
}
    8000259c:	8526                	mv	a0,s1
    8000259e:	60e2                	ld	ra,24(sp)
    800025a0:	6442                	ld	s0,16(sp)
    800025a2:	64a2                	ld	s1,8(sp)
    800025a4:	6105                	addi	sp,sp,32
    800025a6:	8082                	ret

00000000800025a8 <buf_write>:

// 将缓冲区写入磁盘
void buf_write(struct buf* b)
{
    800025a8:	1141                	addi	sp,sp,-16
    800025aa:	e406                	sd	ra,8(sp)
    800025ac:	e022                	sd	s0,0(sp)
    800025ae:	0800                	addi	s0,sp,16
  virtio_disk_rw(b, 0);
    800025b0:	4581                	li	a1,0
    800025b2:	fffff097          	auipc	ra,0xfffff
    800025b6:	3ac080e7          	jalr	940(ra) # 8000195e <virtio_disk_rw>
}
    800025ba:	60a2                	ld	ra,8(sp)
    800025bc:	6402                	ld	s0,0(sp)
    800025be:	0141                	addi	sp,sp,16
    800025c0:	8082                	ret

00000000800025c2 <spinlock_init>:
#include "../riscv.h"
#include "lock.h"
#include "../defs.h"

void spinlock_init(struct spinlock* lk, char* name)
{
    800025c2:	1141                	addi	sp,sp,-16
    800025c4:	e422                	sd	s0,8(sp)
    800025c6:	0800                	addi	s0,sp,16
  lk->cpu = 0;
    800025c8:	00053423          	sd	zero,8(a0)
  lk->name = name;
    800025cc:	e90c                	sd	a1,16(a0)
  lk->locked = 0;
    800025ce:	00052023          	sw	zero,0(a0)
}
    800025d2:	6422                	ld	s0,8(sp)
    800025d4:	0141                	addi	sp,sp,16
    800025d6:	8082                	ret

00000000800025d8 <spin_holding>:
// 检查当前cpu是否持有这个锁
// 需要关中断
int spin_holding(struct spinlock* lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800025d8:	411c                	lw	a5,0(a0)
    800025da:	e399                	bnez	a5,800025e0 <spin_holding+0x8>
    800025dc:	4501                	li	a0,0
  return r;
}
    800025de:	8082                	ret
{
    800025e0:	1101                	addi	sp,sp,-32
    800025e2:	ec06                	sd	ra,24(sp)
    800025e4:	e822                	sd	s0,16(sp)
    800025e6:	e426                	sd	s1,8(sp)
    800025e8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800025ea:	6504                	ld	s1,8(a0)
    800025ec:	ffffe097          	auipc	ra,0xffffe
    800025f0:	6c0080e7          	jalr	1728(ra) # 80000cac <mycpu>
    800025f4:	40a48533          	sub	a0,s1,a0
    800025f8:	00153513          	seqz	a0,a0
}
    800025fc:	60e2                	ld	ra,24(sp)
    800025fe:	6442                	ld	s0,16(sp)
    80002600:	64a2                	ld	s1,8(sp)
    80002602:	6105                	addi	sp,sp,32
    80002604:	8082                	ret

0000000080002606 <push_off>:

// push_off/pop_off 和 intr_off/intr_on 差不多，只是使得
// 开关中断可以嵌套使用。
void push_off(void)
{
    80002606:	1101                	addi	sp,sp,-32
    80002608:	ec06                	sd	ra,24(sp)
    8000260a:	e822                	sd	s0,16(sp)
    8000260c:	e426                	sd	s1,8(sp)
    8000260e:	1000                	addi	s0,sp,32

static inline uint64
r_sstatus()
{
  uint64 x;
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002610:	100024f3          	csrr	s1,sstatus
    80002614:	100027f3          	csrr	a5,sstatus

// disable device interrupts
static inline void
intr_off()
{
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002618:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000261a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if (mycpu()->noff == 0)
    8000261e:	ffffe097          	auipc	ra,0xffffe
    80002622:	68e080e7          	jalr	1678(ra) # 80000cac <mycpu>
    80002626:	5d3c                	lw	a5,120(a0)
    80002628:	cf89                	beqz	a5,80002642 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000262a:	ffffe097          	auipc	ra,0xffffe
    8000262e:	682080e7          	jalr	1666(ra) # 80000cac <mycpu>
    80002632:	5d3c                	lw	a5,120(a0)
    80002634:	2785                	addiw	a5,a5,1
    80002636:	dd3c                	sw	a5,120(a0)
}
    80002638:	60e2                	ld	ra,24(sp)
    8000263a:	6442                	ld	s0,16(sp)
    8000263c:	64a2                	ld	s1,8(sp)
    8000263e:	6105                	addi	sp,sp,32
    80002640:	8082                	ret
    mycpu()->intena = old;
    80002642:	ffffe097          	auipc	ra,0xffffe
    80002646:	66a080e7          	jalr	1642(ra) # 80000cac <mycpu>
// are device interrupts enabled?
static inline int
intr_get()
{
  uint64 x = r_sstatus();
  return (x & SSTATUS_SIE) != 0;
    8000264a:	8085                	srli	s1,s1,0x1
    8000264c:	8885                	andi	s1,s1,1
    8000264e:	dd64                	sw	s1,124(a0)
    80002650:	bfe9                	j	8000262a <push_off+0x24>

0000000080002652 <spin_lock>:
{
    80002652:	1101                	addi	sp,sp,-32
    80002654:	ec06                	sd	ra,24(sp)
    80002656:	e822                	sd	s0,16(sp)
    80002658:	e426                	sd	s1,8(sp)
    8000265a:	1000                	addi	s0,sp,32
    8000265c:	84aa                	mv	s1,a0
  push_off(); // 禁用中断以避免死锁。
    8000265e:	00000097          	auipc	ra,0x0
    80002662:	fa8080e7          	jalr	-88(ra) # 80002606 <push_off>
  if (spin_holding(lk))
    80002666:	8526                	mv	a0,s1
    80002668:	00000097          	auipc	ra,0x0
    8000266c:	f70080e7          	jalr	-144(ra) # 800025d8 <spin_holding>
    80002670:	e11d                	bnez	a0,80002696 <spin_lock+0x44>
  while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80002672:	4705                	li	a4,1
    80002674:	87ba                	mv	a5,a4
    80002676:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000267a:	2781                	sext.w	a5,a5
    8000267c:	ffe5                	bnez	a5,80002674 <spin_lock+0x22>
  __sync_synchronize();
    8000267e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80002682:	ffffe097          	auipc	ra,0xffffe
    80002686:	62a080e7          	jalr	1578(ra) # 80000cac <mycpu>
    8000268a:	e488                	sd	a0,8(s1)
}
    8000268c:	60e2                	ld	ra,24(sp)
    8000268e:	6442                	ld	s0,16(sp)
    80002690:	64a2                	ld	s1,8(sp)
    80002692:	6105                	addi	sp,sp,32
    80002694:	8082                	ret
    panic("re-acquire");
    80002696:	00001517          	auipc	a0,0x1
    8000269a:	f4a50513          	addi	a0,a0,-182 # 800035e0 <digits+0x5a8>
    8000269e:	ffffe097          	auipc	ra,0xffffe
    800026a2:	030080e7          	jalr	48(ra) # 800006ce <panic>
    800026a6:	b7f1                	j	80002672 <spin_lock+0x20>

00000000800026a8 <pop_off>:

void pop_off(void)
{
    800026a8:	1101                	addi	sp,sp,-32
    800026aa:	ec06                	sd	ra,24(sp)
    800026ac:	e822                	sd	s0,16(sp)
    800026ae:	e426                	sd	s1,8(sp)
    800026b0:	1000                	addi	s0,sp,32
  struct cpu* c = mycpu();
    800026b2:	ffffe097          	auipc	ra,0xffffe
    800026b6:	5fa080e7          	jalr	1530(ra) # 80000cac <mycpu>
    800026ba:	84aa                	mv	s1,a0
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026bc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800026c0:	8b89                	andi	a5,a5,2
  if (intr_get())
    800026c2:	e79d                	bnez	a5,800026f0 <pop_off+0x48>
    panic("pop_off - interruptible");
  if (c->noff < 1)
    800026c4:	5cbc                	lw	a5,120(s1)
    800026c6:	02f05e63          	blez	a5,80002702 <pop_off+0x5a>
    panic("pop_off");
  c->noff -= 1;
    800026ca:	5cbc                	lw	a5,120(s1)
    800026cc:	37fd                	addiw	a5,a5,-1
    800026ce:	0007871b          	sext.w	a4,a5
    800026d2:	dcbc                	sw	a5,120(s1)
  if (c->noff == 0 && c->intena)
    800026d4:	eb09                	bnez	a4,800026e6 <pop_off+0x3e>
    800026d6:	5cfc                	lw	a5,124(s1)
    800026d8:	c799                	beqz	a5,800026e6 <pop_off+0x3e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026da:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800026de:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026e2:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800026e6:	60e2                	ld	ra,24(sp)
    800026e8:	6442                	ld	s0,16(sp)
    800026ea:	64a2                	ld	s1,8(sp)
    800026ec:	6105                	addi	sp,sp,32
    800026ee:	8082                	ret
    panic("pop_off - interruptible");
    800026f0:	00001517          	auipc	a0,0x1
    800026f4:	f0050513          	addi	a0,a0,-256 # 800035f0 <digits+0x5b8>
    800026f8:	ffffe097          	auipc	ra,0xffffe
    800026fc:	fd6080e7          	jalr	-42(ra) # 800006ce <panic>
    80002700:	b7d1                	j	800026c4 <pop_off+0x1c>
    panic("pop_off");
    80002702:	00001517          	auipc	a0,0x1
    80002706:	f0650513          	addi	a0,a0,-250 # 80003608 <digits+0x5d0>
    8000270a:	ffffe097          	auipc	ra,0xffffe
    8000270e:	fc4080e7          	jalr	-60(ra) # 800006ce <panic>
    80002712:	bf65                	j	800026ca <pop_off+0x22>

0000000080002714 <spin_unlock>:
{
    80002714:	1101                	addi	sp,sp,-32
    80002716:	ec06                	sd	ra,24(sp)
    80002718:	e822                	sd	s0,16(sp)
    8000271a:	e426                	sd	s1,8(sp)
    8000271c:	1000                	addi	s0,sp,32
    8000271e:	84aa                	mv	s1,a0
  if (!spin_holding(lk))
    80002720:	00000097          	auipc	ra,0x0
    80002724:	eb8080e7          	jalr	-328(ra) # 800025d8 <spin_holding>
    80002728:	c115                	beqz	a0,8000274c <spin_unlock+0x38>
  lk->cpu = 0;
    8000272a:	0004b423          	sd	zero,8(s1)
  __sync_synchronize();
    8000272e:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80002732:	0f50000f          	fence	iorw,ow
    80002736:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000273a:	00000097          	auipc	ra,0x0
    8000273e:	f6e080e7          	jalr	-146(ra) # 800026a8 <pop_off>
}
    80002742:	60e2                	ld	ra,24(sp)
    80002744:	6442                	ld	s0,16(sp)
    80002746:	64a2                	ld	s1,8(sp)
    80002748:	6105                	addi	sp,sp,32
    8000274a:	8082                	ret
    panic("release");
    8000274c:	00001517          	auipc	a0,0x1
    80002750:	ec450513          	addi	a0,a0,-316 # 80003610 <digits+0x5d8>
    80002754:	ffffe097          	auipc	ra,0xffffe
    80002758:	f7a080e7          	jalr	-134(ra) # 800006ce <panic>
    8000275c:	b7f9                	j	8000272a <spin_unlock+0x16>

000000008000275e <sleeplock_init>:
#include "../riscv.h"
#include "lock.h"
#include "../defs.h"

void sleeplock_init(struct sleeplock* lk, char* name)
{
    8000275e:	1101                	addi	sp,sp,-32
    80002760:	ec06                	sd	ra,24(sp)
    80002762:	e822                	sd	s0,16(sp)
    80002764:	e426                	sd	s1,8(sp)
    80002766:	e04a                	sd	s2,0(sp)
    80002768:	1000                	addi	s0,sp,32
    8000276a:	84aa                	mv	s1,a0
    8000276c:	892e                	mv	s2,a1
  spinlock_init(&lk->lk, "sleep lock");
    8000276e:	00001597          	auipc	a1,0x1
    80002772:	eaa58593          	addi	a1,a1,-342 # 80003618 <digits+0x5e0>
    80002776:	0521                	addi	a0,a0,8
    80002778:	00000097          	auipc	ra,0x0
    8000277c:	e4a080e7          	jalr	-438(ra) # 800025c2 <spinlock_init>
  lk->name = name;
    80002780:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80002784:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80002788:	0204a423          	sw	zero,40(s1)
}
    8000278c:	60e2                	ld	ra,24(sp)
    8000278e:	6442                	ld	s0,16(sp)
    80002790:	64a2                	ld	s1,8(sp)
    80002792:	6902                	ld	s2,0(sp)
    80002794:	6105                	addi	sp,sp,32
    80002796:	8082                	ret

0000000080002798 <sleep_lock>:

void sleep_lock(struct sleeplock* lk)
{
    80002798:	1101                	addi	sp,sp,-32
    8000279a:	ec06                	sd	ra,24(sp)
    8000279c:	e822                	sd	s0,16(sp)
    8000279e:	e426                	sd	s1,8(sp)
    800027a0:	e04a                	sd	s2,0(sp)
    800027a2:	1000                	addi	s0,sp,32
    800027a4:	84aa                	mv	s1,a0
  spin_lock(&lk->lk);
    800027a6:	00850913          	addi	s2,a0,8
    800027aa:	854a                	mv	a0,s2
    800027ac:	00000097          	auipc	ra,0x0
    800027b0:	ea6080e7          	jalr	-346(ra) # 80002652 <spin_lock>
  while (lk->locked) {
    800027b4:	409c                	lw	a5,0(s1)
    800027b6:	cb81                	beqz	a5,800027c6 <sleep_lock+0x2e>
    sleep(lk);
    800027b8:	8526                	mv	a0,s1
    800027ba:	ffffe097          	auipc	ra,0xffffe
    800027be:	52c080e7          	jalr	1324(ra) # 80000ce6 <sleep>
  while (lk->locked) {
    800027c2:	409c                	lw	a5,0(s1)
    800027c4:	fbf5                	bnez	a5,800027b8 <sleep_lock+0x20>
  }
  lk->locked = 1;
    800027c6:	4785                	li	a5,1
    800027c8:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800027ca:	ffffe097          	auipc	ra,0xffffe
    800027ce:	4fe080e7          	jalr	1278(ra) # 80000cc8 <myproc>
    800027d2:	511c                	lw	a5,32(a0)
    800027d4:	d49c                	sw	a5,40(s1)
  spin_unlock(&lk->lk);
    800027d6:	854a                	mv	a0,s2
    800027d8:	00000097          	auipc	ra,0x0
    800027dc:	f3c080e7          	jalr	-196(ra) # 80002714 <spin_unlock>
}
    800027e0:	60e2                	ld	ra,24(sp)
    800027e2:	6442                	ld	s0,16(sp)
    800027e4:	64a2                	ld	s1,8(sp)
    800027e6:	6902                	ld	s2,0(sp)
    800027e8:	6105                	addi	sp,sp,32
    800027ea:	8082                	ret

00000000800027ec <sleep_unlock>:

void sleep_unlock(struct sleeplock* lk)
{
    800027ec:	1101                	addi	sp,sp,-32
    800027ee:	ec06                	sd	ra,24(sp)
    800027f0:	e822                	sd	s0,16(sp)
    800027f2:	e426                	sd	s1,8(sp)
    800027f4:	e04a                	sd	s2,0(sp)
    800027f6:	1000                	addi	s0,sp,32
    800027f8:	84aa                	mv	s1,a0
  spin_lock(&lk->lk);
    800027fa:	00850913          	addi	s2,a0,8
    800027fe:	854a                	mv	a0,s2
    80002800:	00000097          	auipc	ra,0x0
    80002804:	e52080e7          	jalr	-430(ra) # 80002652 <spin_lock>
  lk->locked = 0;
    80002808:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000280c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80002810:	8526                	mv	a0,s1
    80002812:	ffffe097          	auipc	ra,0xffffe
    80002816:	556080e7          	jalr	1366(ra) # 80000d68 <wakeup>
  spin_unlock(&lk->lk);
    8000281a:	854a                	mv	a0,s2
    8000281c:	00000097          	auipc	ra,0x0
    80002820:	ef8080e7          	jalr	-264(ra) # 80002714 <spin_unlock>
}
    80002824:	60e2                	ld	ra,24(sp)
    80002826:	6442                	ld	s0,16(sp)
    80002828:	64a2                	ld	s1,8(sp)
    8000282a:	6902                	ld	s2,0(sp)
    8000282c:	6105                	addi	sp,sp,32
    8000282e:	8082                	ret

0000000080002830 <sleep_holding>:

int sleep_holding(struct sleeplock* lk)
{
    80002830:	7179                	addi	sp,sp,-48
    80002832:	f406                	sd	ra,40(sp)
    80002834:	f022                	sd	s0,32(sp)
    80002836:	ec26                	sd	s1,24(sp)
    80002838:	e84a                	sd	s2,16(sp)
    8000283a:	e44e                	sd	s3,8(sp)
    8000283c:	1800                	addi	s0,sp,48
    8000283e:	84aa                	mv	s1,a0
  int r;
  spin_lock(&lk->lk);
    80002840:	00850913          	addi	s2,a0,8
    80002844:	854a                	mv	a0,s2
    80002846:	00000097          	auipc	ra,0x0
    8000284a:	e0c080e7          	jalr	-500(ra) # 80002652 <spin_lock>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000284e:	409c                	lw	a5,0(s1)
    80002850:	ef99                	bnez	a5,8000286e <sleep_holding+0x3e>
    80002852:	4481                	li	s1,0
  spin_unlock(&lk->lk);
    80002854:	854a                	mv	a0,s2
    80002856:	00000097          	auipc	ra,0x0
    8000285a:	ebe080e7          	jalr	-322(ra) # 80002714 <spin_unlock>
  return r;
}
    8000285e:	8526                	mv	a0,s1
    80002860:	70a2                	ld	ra,40(sp)
    80002862:	7402                	ld	s0,32(sp)
    80002864:	64e2                	ld	s1,24(sp)
    80002866:	6942                	ld	s2,16(sp)
    80002868:	69a2                	ld	s3,8(sp)
    8000286a:	6145                	addi	sp,sp,48
    8000286c:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000286e:	0284a983          	lw	s3,40(s1)
    80002872:	ffffe097          	auipc	ra,0xffffe
    80002876:	456080e7          	jalr	1110(ra) # 80000cc8 <myproc>
    8000287a:	5104                	lw	s1,32(a0)
    8000287c:	413484b3          	sub	s1,s1,s3
    80002880:	0014b493          	seqz	s1,s1
    80002884:	bfc1                	j	80002854 <sleep_holding+0x24>
	...
