
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00006117          	auipc	sp,0x6
    80000004:	12010113          	addi	sp,sp,288 # 80006120 <stack0>
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
    int interval = 1000000*10; // 周期, 在qemu中差不多是1/10秒
    *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80000026:	0037961b          	slliw	a2,a5,0x3
    8000002a:	02004737          	lui	a4,0x2004
    8000002e:	963a                	add	a2,a2,a4
    80000030:	0200c737          	lui	a4,0x200c
    80000034:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80000038:	009896b7          	lui	a3,0x989
    8000003c:	68068693          	addi	a3,a3,1664 # 989680 <_entry-0x7f676980>
    80000040:	9736                	add	a4,a4,a3
    80000042:	e218                	sd	a4,0(a2)

    // 为timervec准备scratch[]中的内容
    // scratch[0..3]: timervec保存寄存器的空间
    // scratch[4]: CLINT MTIMECMP寄存器的地址
    // scratch[5]: 将时钟中断周期设置为intverval
    uint64 *scratch = &mscratch0[32 * id];
    80000044:	0057979b          	slliw	a5,a5,0x5
    80000048:	078e                	slli	a5,a5,0x3
    8000004a:	00006717          	auipc	a4,0x6
    8000004e:	fd670713          	addi	a4,a4,-42 # 80006020 <mscratch0>
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
    8000005c:	00000797          	auipc	a5,0x0
    80000060:	50478793          	addi	a5,a5,1284 # 80000560 <timervec>
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
    80000094:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ff92dcf>
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
    800000f8:	0a0080e7          	jalr	160(ra) # 80000194 <uart_init>
    printf("\n");
    800000fc:	00005517          	auipc	a0,0x5
    80000100:	fac50513          	addi	a0,a0,-84 # 800050a8 <etext+0xa8>
    80000104:	00001097          	auipc	ra,0x1
    80000108:	0b6080e7          	jalr	182(ra) # 800011ba <printf>
    printf("xv6 kernel is booting\n");
    8000010c:	00005517          	auipc	a0,0x5
    80000110:	ef450513          	addi	a0,a0,-268 # 80005000 <etext>
    80000114:	00001097          	auipc	ra,0x1
    80000118:	0a6080e7          	jalr	166(ra) # 800011ba <printf>
    printf("\n");
    8000011c:	00005517          	auipc	a0,0x5
    80000120:	f8c50513          	addi	a0,a0,-116 # 800050a8 <etext+0xa8>
    80000124:	00001097          	auipc	ra,0x1
    80000128:	096080e7          	jalr	150(ra) # 800011ba <printf>
    trapinit();             // 初始化trap
    8000012c:	00003097          	auipc	ra,0x3
    80000130:	37a080e7          	jalr	890(ra) # 800034a6 <trapinit>
    plicinit();             // 初始化plic
    80000134:	00000097          	auipc	ra,0x0
    80000138:	2f2080e7          	jalr	754(ra) # 80000426 <plicinit>
    plicinithart();
    8000013c:	00000097          	auipc	ra,0x0
    80000140:	300080e7          	jalr	768(ra) # 8000043c <plicinithart>
    kernel_mem_init();      // 初始化内存
    80000144:	00001097          	auipc	ra,0x1
    80000148:	220080e7          	jalr	544(ra) # 80001364 <kernel_mem_init>
    kernel_vm_init();       // 初始化内核虚拟内存
    8000014c:	00001097          	auipc	ra,0x1
    80000150:	49c080e7          	jalr	1180(ra) # 800015e8 <kernel_vm_init>
    vm_hart_init();         // 启用分页
    80000154:	00001097          	auipc	ra,0x1
    80000158:	2ac080e7          	jalr	684(ra) # 80001400 <vm_hart_init>
    virtio_disk_init();     // 初始化磁盘
    8000015c:	00002097          	auipc	ra,0x2
    80000160:	9ca080e7          	jalr	-1590(ra) # 80001b26 <virtio_disk_init>
    init_inode_cache();     // 初始化inode cache
    80000164:	00002097          	auipc	ra,0x2
    80000168:	402080e7          	jalr	1026(ra) # 80002566 <init_inode_cache>
    init_buf();             // 初始化磁盘块缓冲
    8000016c:	00003097          	auipc	ra,0x3
    80000170:	e72080e7          	jalr	-398(ra) # 80002fde <init_buf>
    init_process_table();   // 初始化进程表
    80000174:	00000097          	auipc	ra,0x0
    80000178:	462080e7          	jalr	1122(ra) # 800005d6 <init_process_table>
    init_first_process();   // 初始化第一个进程
    8000017c:	00000097          	auipc	ra,0x0
    80000180:	5de080e7          	jalr	1502(ra) # 8000075a <init_first_process>
    scheduler();
    80000184:	00001097          	auipc	ra,0x1
    80000188:	8c4080e7          	jalr	-1852(ra) # 80000a48 <scheduler>
}
    8000018c:	60a2                	ld	ra,8(sp)
    8000018e:	6402                	ld	s0,0(sp)
    80000190:	0141                	addi	sp,sp,16
    80000192:	8082                	ret

0000000080000194 <uart_init>:
#define FCR_FIFO_CLEAR (3 << 1)  // 清除两个FIFO的内容
#define IER_RX_ENABLE (1 << 0)   // 读中断允许
#define IER_TX_ENABLE (1 << 1)   // 传输中断允许

void uart_init()
{
    80000194:	1141                	addi	sp,sp,-16
    80000196:	e422                	sd	s0,8(sp)
    80000198:	0800                	addi	s0,sp,16
  // 禁用中断
  WriteReg(IER, 0x0);
    8000019a:	100007b7          	lui	a5,0x10000
    8000019e:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // 配置波特率模式
  WriteReg(LCR, LCR_BAUD_LATCH);
    800001a2:	f8000713          	li	a4,-128
    800001a6:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800001aa:	470d                	li	a4,3
    800001ac:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800001b0:	000780a3          	sb	zero,1(a5)

  // 退出 设置波特率模式
  // 设置字宽为8位，不校验
  WriteReg(LCR, LCR_EIGHT_BITS);
    800001b4:	46a1                	li	a3,8
    800001b6:	00d781a3          	sb	a3,3(a5)

  // 重置和允许FIFO
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800001ba:	469d                	li	a3,7
    800001bc:	00d78123          	sb	a3,2(a5)

  // 允许传输和接受中断
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800001c0:	00e780a3          	sb	a4,1(a5)

  // initlock(&uart_tx_lock, "uart");
}
    800001c4:	6422                	ld	s0,8(sp)
    800001c6:	0141                	addi	sp,sp,16
    800001c8:	8082                	ret

00000000800001ca <uartputc_sync>:

void uartputc_sync(int c)
{
    800001ca:	1141                	addi	sp,sp,-16
    800001cc:	e422                	sd	s0,8(sp)
    800001ce:	0800                	addi	s0,sp,16
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800001d0:	10000737          	lui	a4,0x10000
    800001d4:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800001d8:	0ff7f793          	andi	a5,a5,255
    800001dc:	0207f793          	andi	a5,a5,32
    800001e0:	dbf5                	beqz	a5,800001d4 <uartputc_sync+0xa>
    ;
  WriteReg(THR, c);
    800001e2:	0ff57513          	andi	a0,a0,255
    800001e6:	100007b7          	lui	a5,0x10000
    800001ea:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>
}
    800001ee:	6422                	ld	s0,8(sp)
    800001f0:	0141                	addi	sp,sp,16
    800001f2:	8082                	ret

00000000800001f4 <uartgetc>:

int uartgetc(void)
{
    800001f4:	1141                	addi	sp,sp,-16
    800001f6:	e422                	sd	s0,8(sp)
    800001f8:	0800                	addi	s0,sp,16
  //
  if (ReadReg(LSR) & 0x01)
    800001fa:	100007b7          	lui	a5,0x10000
    800001fe:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000202:	8b85                	andi	a5,a5,1
    80000204:	cb91                	beqz	a5,80000218 <uartgetc+0x24>
  {
    return ReadReg(RHR);
    80000206:	100007b7          	lui	a5,0x10000
    8000020a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000020e:	0ff57513          	andi	a0,a0,255
  }
  else
  {
    return -1;
  }
}
    80000212:	6422                	ld	s0,8(sp)
    80000214:	0141                	addi	sp,sp,16
    80000216:	8082                	ret
    return -1;
    80000218:	557d                	li	a0,-1
    8000021a:	bfe5                	j	80000212 <uartgetc+0x1e>

000000008000021c <uart_intr>:

void uart_intr()
{
    8000021c:	1101                	addi	sp,sp,-32
    8000021e:	ec06                	sd	ra,24(sp)
    80000220:	e822                	sd	s0,16(sp)
    80000222:	e426                	sd	s1,8(sp)
    80000224:	1000                	addi	s0,sp,32
  while (1)
  {
    int c = uartgetc();
    if (c == -1)
    80000226:	54fd                	li	s1,-1
    int c = uartgetc();
    80000228:	00000097          	auipc	ra,0x0
    8000022c:	fcc080e7          	jalr	-52(ra) # 800001f4 <uartgetc>
    if (c == -1)
    80000230:	00950963          	beq	a0,s1,80000242 <uart_intr+0x26>
      break;
    console_intr(c);
    80000234:	0ff57513          	andi	a0,a0,255
    80000238:	00000097          	auipc	ra,0x0
    8000023c:	114080e7          	jalr	276(ra) # 8000034c <console_intr>
  {
    80000240:	b7e5                	j	80000228 <uart_intr+0xc>
  }
}
    80000242:	60e2                	ld	ra,24(sp)
    80000244:	6442                	ld	s0,16(sp)
    80000246:	64a2                	ld	s1,8(sp)
    80000248:	6105                	addi	sp,sp,32
    8000024a:	8082                	ret

000000008000024c <putc>:
    int read_index;
    int write_index;
} consloe_buf;

void putc(int fs, char ch)
{
    8000024c:	1141                	addi	sp,sp,-16
    8000024e:	e406                	sd	ra,8(sp)
    80000250:	e022                	sd	s0,0(sp)
    80000252:	0800                	addi	s0,sp,16
    uartputc_sync(ch);
    80000254:	852e                	mv	a0,a1
    80000256:	00000097          	auipc	ra,0x0
    8000025a:	f74080e7          	jalr	-140(ra) # 800001ca <uartputc_sync>
}
    8000025e:	60a2                	ld	ra,8(sp)
    80000260:	6402                	ld	s0,0(sp)
    80000262:	0141                	addi	sp,sp,16
    80000264:	8082                	ret

0000000080000266 <read_line>:

int read_line(char* s)
{
    80000266:	1101                	addi	sp,sp,-32
    80000268:	ec06                	sd	ra,24(sp)
    8000026a:	e822                	sd	s0,16(sp)
    8000026c:	e426                	sd	s1,8(sp)
    8000026e:	e04a                	sd	s2,0(sp)
    80000270:	1000                	addi	s0,sp,32
    80000272:	892a                	mv	s2,a0
    int cnt = 0;

    spin_lock(&consloe_buf.lock);
    80000274:	00007497          	auipc	s1,0x7
    80000278:	eac48493          	addi	s1,s1,-340 # 80007120 <consloe_buf>
    8000027c:	8526                	mv	a0,s1
    8000027e:	00003097          	auipc	ra,0x3
    80000282:	fce080e7          	jalr	-50(ra) # 8000324c <spin_lock>
    sleep(&consloe_buf, &consloe_buf.lock);
    80000286:	85a6                	mv	a1,s1
    80000288:	8526                	mv	a0,s1
    8000028a:	00000097          	auipc	ra,0x0
    8000028e:	688080e7          	jalr	1672(ra) # 80000912 <sleep>
    for (int i = consloe_buf.read_index; i < consloe_buf.write_index; i++) {
    80000292:	0e04a783          	lw	a5,224(s1)
    80000296:	0e44a703          	lw	a4,228(s1)
    8000029a:	02e7d963          	bge	a5,a4,800002cc <read_line+0x66>
    8000029e:	864a                	mv	a2,s2
    int cnt = 0;
    800002a0:	4681                	li	a3,0
        s[cnt++] = consloe_buf.buf[i % INPUT_BUF];
    800002a2:	85a6                	mv	a1,s1
    800002a4:	0c800813          	li	a6,200
        if (consloe_buf.buf[i % INPUT_BUF] == '\n') {
    800002a8:	4529                	li	a0,10
        s[cnt++] = consloe_buf.buf[i % INPUT_BUF];
    800002aa:	84b6                	mv	s1,a3
    800002ac:	2685                	addiw	a3,a3,1
    800002ae:	0307e73b          	remw	a4,a5,a6
    800002b2:	972e                	add	a4,a4,a1
    800002b4:	01874703          	lbu	a4,24(a4)
    800002b8:	00e60023          	sb	a4,0(a2)
        if (consloe_buf.buf[i % INPUT_BUF] == '\n') {
    800002bc:	02a70863          	beq	a4,a0,800002ec <read_line+0x86>
    for (int i = consloe_buf.read_index; i < consloe_buf.write_index; i++) {
    800002c0:	2785                	addiw	a5,a5,1
    800002c2:	0605                	addi	a2,a2,1
    800002c4:	0e45a703          	lw	a4,228(a1)
    800002c8:	fee7c1e3          	blt	a5,a4,800002aa <read_line+0x44>
            s[cnt - 1] = 0;
            spin_unlock(&consloe_buf.lock);
            return cnt - 1;
        }
    }
    spin_unlock(&consloe_buf.lock);
    800002cc:	00007517          	auipc	a0,0x7
    800002d0:	e5450513          	addi	a0,a0,-428 # 80007120 <consloe_buf>
    800002d4:	00003097          	auipc	ra,0x3
    800002d8:	04c080e7          	jalr	76(ra) # 80003320 <spin_unlock>
    return -1;
    800002dc:	54fd                	li	s1,-1
}
    800002de:	8526                	mv	a0,s1
    800002e0:	60e2                	ld	ra,24(sp)
    800002e2:	6442                	ld	s0,16(sp)
    800002e4:	64a2                	ld	s1,8(sp)
    800002e6:	6902                	ld	s2,0(sp)
    800002e8:	6105                	addi	sp,sp,32
    800002ea:	8082                	ret
            consloe_buf.read_index = i + 1;
    800002ec:	00007517          	auipc	a0,0x7
    800002f0:	e3450513          	addi	a0,a0,-460 # 80007120 <consloe_buf>
    800002f4:	2785                	addiw	a5,a5,1
    800002f6:	0ef52023          	sw	a5,224(a0)
            s[cnt - 1] = 0;
    800002fa:	96ca                	add	a3,a3,s2
    800002fc:	fe068fa3          	sb	zero,-1(a3)
            spin_unlock(&consloe_buf.lock);
    80000300:	00003097          	auipc	ra,0x3
    80000304:	020080e7          	jalr	32(ra) # 80003320 <spin_unlock>
            return cnt - 1;
    80000308:	bfd9                	j	800002de <read_line+0x78>

000000008000030a <console_putc>:

void console_putc(int c)
{
    8000030a:	1141                	addi	sp,sp,-16
    8000030c:	e406                	sd	ra,8(sp)
    8000030e:	e022                	sd	s0,0(sp)
    80000310:	0800                	addi	s0,sp,16
    if (c == BACKSPACE) {
    80000312:	10000793          	li	a5,256
    80000316:	00f50a63          	beq	a0,a5,8000032a <console_putc+0x20>
        // if the user typed backspace, overwrite with a space.
        uartputc_sync('\b');
        uartputc_sync(' ');
        uartputc_sync('\b');
    } else {
        uartputc_sync(c);
    8000031a:	00000097          	auipc	ra,0x0
    8000031e:	eb0080e7          	jalr	-336(ra) # 800001ca <uartputc_sync>
    }
}
    80000322:	60a2                	ld	ra,8(sp)
    80000324:	6402                	ld	s0,0(sp)
    80000326:	0141                	addi	sp,sp,16
    80000328:	8082                	ret
        uartputc_sync('\b');
    8000032a:	4521                	li	a0,8
    8000032c:	00000097          	auipc	ra,0x0
    80000330:	e9e080e7          	jalr	-354(ra) # 800001ca <uartputc_sync>
        uartputc_sync(' ');
    80000334:	02000513          	li	a0,32
    80000338:	00000097          	auipc	ra,0x0
    8000033c:	e92080e7          	jalr	-366(ra) # 800001ca <uartputc_sync>
        uartputc_sync('\b');
    80000340:	4521                	li	a0,8
    80000342:	00000097          	auipc	ra,0x0
    80000346:	e88080e7          	jalr	-376(ra) # 800001ca <uartputc_sync>
    8000034a:	bfe1                	j	80000322 <console_putc+0x18>

000000008000034c <console_intr>:

void console_intr(char c)
{
    8000034c:	1101                	addi	sp,sp,-32
    8000034e:	ec06                	sd	ra,24(sp)
    80000350:	e822                	sd	s0,16(sp)
    80000352:	e426                	sd	s1,8(sp)
    80000354:	1000                	addi	s0,sp,32
    switch (c) {
    80000356:	47c1                	li	a5,16
    80000358:	04f50263          	beq	a0,a5,8000039c <console_intr+0x50>
    8000035c:	84aa                	mv	s1,a0
    8000035e:	07f00793          	li	a5,127
    80000362:	04f51663          	bne	a0,a5,800003ae <console_intr+0x62>

    case '\x7f': // 退格
        if (consloe_buf.read_index != consloe_buf.write_index) {
    80000366:	00007717          	auipc	a4,0x7
    8000036a:	dba70713          	addi	a4,a4,-582 # 80007120 <consloe_buf>
    8000036e:	0e472783          	lw	a5,228(a4)
    80000372:	0e072703          	lw	a4,224(a4)
    80000376:	02f70763          	beq	a4,a5,800003a4 <console_intr+0x58>
            consloe_buf.write_index--;
    8000037a:	37fd                	addiw	a5,a5,-1
    8000037c:	00007717          	auipc	a4,0x7
    80000380:	e8f72423          	sw	a5,-376(a4) # 80007204 <consloe_buf+0xe4>
            console_putc(BACKSPACE);
    80000384:	10000513          	li	a0,256
    80000388:	00000097          	auipc	ra,0x0
    8000038c:	f82080e7          	jalr	-126(ra) # 8000030a <console_putc>
            console_putc('\a');
    80000390:	451d                	li	a0,7
    80000392:	00000097          	auipc	ra,0x0
    80000396:	f78080e7          	jalr	-136(ra) # 8000030a <console_putc>
    8000039a:	a029                	j	800003a4 <console_intr+0x58>
        }
        break;
    case CTRL('P'):
        print_proc();
    8000039c:	00001097          	auipc	ra,0x1
    800003a0:	8ea080e7          	jalr	-1814(ra) # 80000c86 <print_proc>
        if (c == '\n') {
            wakeup(&consloe_buf);
        }
        break;
    }
}
    800003a4:	60e2                	ld	ra,24(sp)
    800003a6:	6442                	ld	s0,16(sp)
    800003a8:	64a2                	ld	s1,8(sp)
    800003aa:	6105                	addi	sp,sp,32
    800003ac:	8082                	ret
        c = (c == '\r') ? '\n' : c;
    800003ae:	47b5                	li	a5,13
    800003b0:	02f50b63          	beq	a0,a5,800003e6 <console_intr+0x9a>
        console_putc(c);
    800003b4:	00000097          	auipc	ra,0x0
    800003b8:	f56080e7          	jalr	-170(ra) # 8000030a <console_putc>
        consloe_buf.buf[consloe_buf.write_index++ % INPUT_BUF] = c;
    800003bc:	00007797          	auipc	a5,0x7
    800003c0:	d6478793          	addi	a5,a5,-668 # 80007120 <consloe_buf>
    800003c4:	0e47a703          	lw	a4,228(a5)
    800003c8:	0017069b          	addiw	a3,a4,1
    800003cc:	0ed7a223          	sw	a3,228(a5)
    800003d0:	0c800693          	li	a3,200
    800003d4:	02d7673b          	remw	a4,a4,a3
    800003d8:	97ba                	add	a5,a5,a4
    800003da:	00978c23          	sb	s1,24(a5)
        if (c == '\n') {
    800003de:	47a9                	li	a5,10
    800003e0:	fcf492e3          	bne	s1,a5,800003a4 <console_intr+0x58>
    800003e4:	a805                	j	80000414 <console_intr+0xc8>
        console_putc(c);
    800003e6:	4529                	li	a0,10
    800003e8:	00000097          	auipc	ra,0x0
    800003ec:	f22080e7          	jalr	-222(ra) # 8000030a <console_putc>
        consloe_buf.buf[consloe_buf.write_index++ % INPUT_BUF] = c;
    800003f0:	00007797          	auipc	a5,0x7
    800003f4:	d3078793          	addi	a5,a5,-720 # 80007120 <consloe_buf>
    800003f8:	0e47a703          	lw	a4,228(a5)
    800003fc:	0017069b          	addiw	a3,a4,1
    80000400:	0ed7a223          	sw	a3,228(a5)
    80000404:	0c800693          	li	a3,200
    80000408:	02d7673b          	remw	a4,a4,a3
    8000040c:	97ba                	add	a5,a5,a4
    8000040e:	4729                	li	a4,10
    80000410:	00e78c23          	sb	a4,24(a5)
            wakeup(&consloe_buf);
    80000414:	00007517          	auipc	a0,0x7
    80000418:	d0c50513          	addi	a0,a0,-756 # 80007120 <consloe_buf>
    8000041c:	00000097          	auipc	ra,0x0
    80000420:	5f2080e7          	jalr	1522(ra) # 80000a0e <wakeup>
}
    80000424:	b741                	j	800003a4 <console_intr+0x58>

0000000080000426 <plicinit>:
//


void
plicinit(void)
{
    80000426:	1141                	addi	sp,sp,-16
    80000428:	e422                	sd	s0,8(sp)
    8000042a:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  // 设置IRQ的属性为非零
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    8000042c:	0c0007b7          	lui	a5,0xc000
    80000430:	4705                	li	a4,1
    80000432:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80000434:	c3d8                	sw	a4,4(a5)
}
    80000436:	6422                	ld	s0,8(sp)
    80000438:	0141                	addi	sp,sp,16
    8000043a:	8082                	ret

000000008000043c <plicinithart>:

void
plicinithart(void)
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e406                	sd	ra,8(sp)
    80000440:	e022                	sd	s0,0(sp)
    80000442:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80000444:	00000097          	auipc	ra,0x0
    80000448:	3a0080e7          	jalr	928(ra) # 800007e4 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    8000044c:	0085171b          	slliw	a4,a0,0x8
    80000450:	0c0027b7          	lui	a5,0xc002
    80000454:	97ba                	add	a5,a5,a4
    80000456:	40200713          	li	a4,1026
    8000045a:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    8000045e:	00d5151b          	slliw	a0,a0,0xd
    80000462:	0c2017b7          	lui	a5,0xc201
    80000466:	953e                	add	a0,a0,a5
    80000468:	00052023          	sw	zero,0(a0)
}
    8000046c:	60a2                	ld	ra,8(sp)
    8000046e:	6402                	ld	s0,0(sp)
    80000470:	0141                	addi	sp,sp,16
    80000472:	8082                	ret

0000000080000474 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80000474:	1141                	addi	sp,sp,-16
    80000476:	e406                	sd	ra,8(sp)
    80000478:	e022                	sd	s0,0(sp)
    8000047a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000047c:	00000097          	auipc	ra,0x0
    80000480:	368080e7          	jalr	872(ra) # 800007e4 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80000484:	00d5179b          	slliw	a5,a0,0xd
    80000488:	0c201537          	lui	a0,0xc201
    8000048c:	953e                	add	a0,a0,a5
  return irq;
}
    8000048e:	4148                	lw	a0,4(a0)
    80000490:	60a2                	ld	ra,8(sp)
    80000492:	6402                	ld	s0,0(sp)
    80000494:	0141                	addi	sp,sp,16
    80000496:	8082                	ret

0000000080000498 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80000498:	1101                	addi	sp,sp,-32
    8000049a:	ec06                	sd	ra,24(sp)
    8000049c:	e822                	sd	s0,16(sp)
    8000049e:	e426                	sd	s1,8(sp)
    800004a0:	1000                	addi	s0,sp,32
    800004a2:	84aa                	mv	s1,a0
  int hart = cpuid();
    800004a4:	00000097          	auipc	ra,0x0
    800004a8:	340080e7          	jalr	832(ra) # 800007e4 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800004ac:	00d5151b          	slliw	a0,a0,0xd
    800004b0:	0c2017b7          	lui	a5,0xc201
    800004b4:	97aa                	add	a5,a5,a0
    800004b6:	c3c4                	sw	s1,4(a5)
}
    800004b8:	60e2                	ld	ra,24(sp)
    800004ba:	6442                	ld	s0,16(sp)
    800004bc:	64a2                	ld	s1,8(sp)
    800004be:	6105                	addi	sp,sp,32
    800004c0:	8082                	ret
	...

00000000800004d0 <kernelvec>:
    800004d0:	7111                	addi	sp,sp,-256
    800004d2:	e006                	sd	ra,0(sp)
    800004d4:	e40a                	sd	sp,8(sp)
    800004d6:	e80e                	sd	gp,16(sp)
    800004d8:	ec12                	sd	tp,24(sp)
    800004da:	f016                	sd	t0,32(sp)
    800004dc:	f41a                	sd	t1,40(sp)
    800004de:	f81e                	sd	t2,48(sp)
    800004e0:	fc22                	sd	s0,56(sp)
    800004e2:	e0a6                	sd	s1,64(sp)
    800004e4:	e4aa                	sd	a0,72(sp)
    800004e6:	e8ae                	sd	a1,80(sp)
    800004e8:	ecb2                	sd	a2,88(sp)
    800004ea:	f0b6                	sd	a3,96(sp)
    800004ec:	f4ba                	sd	a4,104(sp)
    800004ee:	f8be                	sd	a5,112(sp)
    800004f0:	fcc2                	sd	a6,120(sp)
    800004f2:	e146                	sd	a7,128(sp)
    800004f4:	e54a                	sd	s2,136(sp)
    800004f6:	e94e                	sd	s3,144(sp)
    800004f8:	ed52                	sd	s4,152(sp)
    800004fa:	f156                	sd	s5,160(sp)
    800004fc:	f55a                	sd	s6,168(sp)
    800004fe:	f95e                	sd	s7,176(sp)
    80000500:	fd62                	sd	s8,184(sp)
    80000502:	e1e6                	sd	s9,192(sp)
    80000504:	e5ea                	sd	s10,200(sp)
    80000506:	e9ee                	sd	s11,208(sp)
    80000508:	edf2                	sd	t3,216(sp)
    8000050a:	f1f6                	sd	t4,224(sp)
    8000050c:	f5fa                	sd	t5,232(sp)
    8000050e:	f9fe                	sd	t6,240(sp)
    80000510:	24a030ef          	jal	ra,8000375a <kerneltrap>
    80000514:	6082                	ld	ra,0(sp)
    80000516:	6122                	ld	sp,8(sp)
    80000518:	61c2                	ld	gp,16(sp)
    8000051a:	6262                	ld	tp,24(sp)
    8000051c:	7282                	ld	t0,32(sp)
    8000051e:	7322                	ld	t1,40(sp)
    80000520:	73c2                	ld	t2,48(sp)
    80000522:	7462                	ld	s0,56(sp)
    80000524:	6486                	ld	s1,64(sp)
    80000526:	6526                	ld	a0,72(sp)
    80000528:	65c6                	ld	a1,80(sp)
    8000052a:	6666                	ld	a2,88(sp)
    8000052c:	7686                	ld	a3,96(sp)
    8000052e:	7726                	ld	a4,104(sp)
    80000530:	77c6                	ld	a5,112(sp)
    80000532:	7866                	ld	a6,120(sp)
    80000534:	688a                	ld	a7,128(sp)
    80000536:	692a                	ld	s2,136(sp)
    80000538:	69ca                	ld	s3,144(sp)
    8000053a:	6a6a                	ld	s4,152(sp)
    8000053c:	7a8a                	ld	s5,160(sp)
    8000053e:	7b2a                	ld	s6,168(sp)
    80000540:	7bca                	ld	s7,176(sp)
    80000542:	7c6a                	ld	s8,184(sp)
    80000544:	6c8e                	ld	s9,192(sp)
    80000546:	6d2e                	ld	s10,200(sp)
    80000548:	6dce                	ld	s11,208(sp)
    8000054a:	6e6e                	ld	t3,216(sp)
    8000054c:	7e8e                	ld	t4,224(sp)
    8000054e:	7f2e                	ld	t5,232(sp)
    80000550:	7fce                	ld	t6,240(sp)
    80000552:	6111                	addi	sp,sp,256
    80000554:	10200073          	sret
    80000558:	00000013          	nop
    8000055c:	00000013          	nop

0000000080000560 <timervec>:
    80000560:	34051573          	csrrw	a0,mscratch,a0
    80000564:	e10c                	sd	a1,0(a0)
    80000566:	e510                	sd	a2,8(a0)
    80000568:	e914                	sd	a3,16(a0)
    8000056a:	710c                	ld	a1,32(a0)
    8000056c:	7510                	ld	a2,40(a0)
    8000056e:	6194                	ld	a3,0(a1)
    80000570:	96b2                	add	a3,a3,a2
    80000572:	e194                	sd	a3,0(a1)
    80000574:	4589                	li	a1,2
    80000576:	14459073          	csrw	sip,a1
    8000057a:	6914                	ld	a3,16(a0)
    8000057c:	6510                	ld	a2,8(a0)
    8000057e:	610c                	ld	a1,0(a0)
    80000580:	34051573          	csrrw	a0,mscratch,a0
    80000584:	30200073          	mret

0000000080000588 <forkret>:
    initproc = p;
    printf("over");
}

// fork的子进程的会从此处开始执行
void forkret(void) {
    80000588:	1141                	addi	sp,sp,-16
    8000058a:	e406                	sd	ra,8(sp)
    8000058c:	e022                	sd	s0,0(sp)
    8000058e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000590:	8792                	mv	a5,tp
    return c;
}

// 获取当前进程
struct proc *myproc() {
    return mycpu()->proc;
    80000592:	2781                	sext.w	a5,a5
    80000594:	079e                	slli	a5,a5,0x7
    80000596:	00007717          	auipc	a4,0x7
    8000059a:	c7270713          	addi	a4,a4,-910 # 80007208 <cpus>
    8000059e:	97ba                	add	a5,a5,a4
    spin_unlock(&myproc()->proc_lock);
    800005a0:	6388                	ld	a0,0(a5)
    800005a2:	00003097          	auipc	ra,0x3
    800005a6:	d7e080e7          	jalr	-642(ra) # 80003320 <spin_unlock>
    if (first) {
    800005aa:	00005797          	auipc	a5,0x5
    800005ae:	fc67a783          	lw	a5,-58(a5) # 80005570 <first.1447>
    800005b2:	eb89                	bnez	a5,800005c4 <forkret+0x3c>
    usertrapret();
    800005b4:	00003097          	auipc	ra,0x3
    800005b8:	f24080e7          	jalr	-220(ra) # 800034d8 <usertrapret>
}
    800005bc:	60a2                	ld	ra,8(sp)
    800005be:	6402                	ld	s0,0(sp)
    800005c0:	0141                	addi	sp,sp,16
    800005c2:	8082                	ret
        first = 0;
    800005c4:	00005797          	auipc	a5,0x5
    800005c8:	fa07a623          	sw	zero,-84(a5) # 80005570 <first.1447>
        init_fs();
    800005cc:	00002097          	auipc	ra,0x2
    800005d0:	da4080e7          	jalr	-604(ra) # 80002370 <init_fs>
    800005d4:	b7c5                	j	800005b4 <forkret+0x2c>

00000000800005d6 <init_process_table>:
void init_process_table() {
    800005d6:	7179                	addi	sp,sp,-48
    800005d8:	f406                	sd	ra,40(sp)
    800005da:	f022                	sd	s0,32(sp)
    800005dc:	ec26                	sd	s1,24(sp)
    800005de:	e84a                	sd	s2,16(sp)
    800005e0:	e44e                	sd	s3,8(sp)
    800005e2:	e052                	sd	s4,0(sp)
    800005e4:	1800                	addi	s0,sp,48
    for (int i = 0; i < NPROC; i++) {
    800005e6:	00048497          	auipc	s1,0x48
    800005ea:	ca248493          	addi	s1,s1,-862 # 80048288 <proc_table>
    800005ee:	4901                	li	s2,0
        spinlock_init(&p->proc_lock, "proc");
    800005f0:	00005a17          	auipc	s4,0x5
    800005f4:	a28a0a13          	addi	s4,s4,-1496 # 80005018 <etext+0x18>
    for (int i = 0; i < NPROC; i++) {
    800005f8:	04000993          	li	s3,64
        spinlock_init(&p->proc_lock, "proc");
    800005fc:	85d2                	mv	a1,s4
    800005fe:	8526                	mv	a0,s1
    80000600:	00003097          	auipc	ra,0x3
    80000604:	bbc080e7          	jalr	-1092(ra) # 800031bc <spinlock_init>
        p->pid = i;
    80000608:	0324ac23          	sw	s2,56(s1)
        p->kstack = (uint64) kalloc();
    8000060c:	00001097          	auipc	ra,0x1
    80000610:	d94080e7          	jalr	-620(ra) # 800013a0 <kalloc>
    80000614:	f0a8                	sd	a0,96(s1)
        p->trapframe = 0;
    80000616:	0404b023          	sd	zero,64(s1)
        p->state = UNUSED;
    8000061a:	0004ac23          	sw	zero,24(s1)
    for (int i = 0; i < NPROC; i++) {
    8000061e:	2905                	addiw	s2,s2,1
    80000620:	0f048493          	addi	s1,s1,240
    80000624:	fd391ce3          	bne	s2,s3,800005fc <init_process_table+0x26>
}
    80000628:	70a2                	ld	ra,40(sp)
    8000062a:	7402                	ld	s0,32(sp)
    8000062c:	64e2                	ld	s1,24(sp)
    8000062e:	6942                	ld	s2,16(sp)
    80000630:	69a2                	ld	s3,8(sp)
    80000632:	6a02                	ld	s4,0(sp)
    80000634:	6145                	addi	sp,sp,48
    80000636:	8082                	ret

0000000080000638 <proc_pagetable>:
pagetable_t proc_pagetable(struct proc *p) {
    80000638:	1101                	addi	sp,sp,-32
    8000063a:	ec06                	sd	ra,24(sp)
    8000063c:	e822                	sd	s0,16(sp)
    8000063e:	e426                	sd	s1,8(sp)
    80000640:	e04a                	sd	s2,0(sp)
    80000642:	1000                	addi	s0,sp,32
    80000644:	892a                	mv	s2,a0
    pagetable = user_vm_create();
    80000646:	00001097          	auipc	ra,0x1
    8000064a:	0fc080e7          	jalr	252(ra) # 80001742 <user_vm_create>
    8000064e:	84aa                	mv	s1,a0
    if (pagetable == 0)
    80000650:	c131                	beqz	a0,80000694 <proc_pagetable+0x5c>
    if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000652:	4729                	li	a4,10
    80000654:	00004697          	auipc	a3,0x4
    80000658:	9ac68693          	addi	a3,a3,-1620 # 80004000 <_trampoline>
    8000065c:	6605                	lui	a2,0x1
    8000065e:	040005b7          	lui	a1,0x4000
    80000662:	15fd                	addi	a1,a1,-1
    80000664:	05b2                	slli	a1,a1,0xc
    80000666:	00001097          	auipc	ra,0x1
    8000066a:	e68080e7          	jalr	-408(ra) # 800014ce <mappages>
    8000066e:	02054a63          	bltz	a0,800006a2 <proc_pagetable+0x6a>
    if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80000672:	4719                	li	a4,6
    80000674:	04093683          	ld	a3,64(s2)
    80000678:	6605                	lui	a2,0x1
    8000067a:	020005b7          	lui	a1,0x2000
    8000067e:	15fd                	addi	a1,a1,-1
    80000680:	05b6                	slli	a1,a1,0xd
    80000682:	8526                	mv	a0,s1
    80000684:	00001097          	auipc	ra,0x1
    80000688:	e4a080e7          	jalr	-438(ra) # 800014ce <mappages>
        return 0;
    8000068c:	fff54513          	not	a0,a0
    80000690:	957d                	srai	a0,a0,0x3f
    80000692:	8ce9                	and	s1,s1,a0
}
    80000694:	8526                	mv	a0,s1
    80000696:	60e2                	ld	ra,24(sp)
    80000698:	6442                	ld	s0,16(sp)
    8000069a:	64a2                	ld	s1,8(sp)
    8000069c:	6902                	ld	s2,0(sp)
    8000069e:	6105                	addi	sp,sp,32
    800006a0:	8082                	ret
        return 0;
    800006a2:	4481                	li	s1,0
    800006a4:	bfc5                	j	80000694 <proc_pagetable+0x5c>

00000000800006a6 <alloc_proc>:
struct proc *alloc_proc() {
    800006a6:	1101                	addi	sp,sp,-32
    800006a8:	ec06                	sd	ra,24(sp)
    800006aa:	e822                	sd	s0,16(sp)
    800006ac:	e426                	sd	s1,8(sp)
    800006ae:	e04a                	sd	s2,0(sp)
    800006b0:	1000                	addi	s0,sp,32
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    800006b2:	00048497          	auipc	s1,0x48
    800006b6:	bd648493          	addi	s1,s1,-1066 # 80048288 <proc_table>
    800006ba:	0004b917          	auipc	s2,0x4b
    800006be:	7ce90913          	addi	s2,s2,1998 # 8004be88 <kmem>
        spin_lock(&p->proc_lock);
    800006c2:	8526                	mv	a0,s1
    800006c4:	00003097          	auipc	ra,0x3
    800006c8:	b88080e7          	jalr	-1144(ra) # 8000324c <spin_lock>
        if (p->state == UNUSED) {
    800006cc:	4c9c                	lw	a5,24(s1)
    800006ce:	cf81                	beqz	a5,800006e6 <alloc_proc+0x40>
            spin_unlock(&p->proc_lock);
    800006d0:	8526                	mv	a0,s1
    800006d2:	00003097          	auipc	ra,0x3
    800006d6:	c4e080e7          	jalr	-946(ra) # 80003320 <spin_unlock>
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    800006da:	0f048493          	addi	s1,s1,240
    800006de:	ff2492e3          	bne	s1,s2,800006c2 <alloc_proc+0x1c>
    return 0;
    800006e2:	4481                	li	s1,0
    800006e4:	a8a9                	j	8000073e <alloc_proc+0x98>
    if ((p->trapframe = (struct trapframe *) kalloc()) == 0) {
    800006e6:	00001097          	auipc	ra,0x1
    800006ea:	cba080e7          	jalr	-838(ra) # 800013a0 <kalloc>
    800006ee:	892a                	mv	s2,a0
    800006f0:	e0a8                	sd	a0,64(s1)
    800006f2:	cd29                	beqz	a0,8000074c <alloc_proc+0xa6>
    p->pagetable = proc_pagetable(p);
    800006f4:	8526                	mv	a0,s1
    800006f6:	00000097          	auipc	ra,0x0
    800006fa:	f42080e7          	jalr	-190(ra) # 80000638 <proc_pagetable>
    800006fe:	e4a8                	sd	a0,72(s1)
    memset(&p->context, 0, sizeof(p->context));
    80000700:	07000613          	li	a2,112
    80000704:	4581                	li	a1,0
    80000706:	06848513          	addi	a0,s1,104
    8000070a:	00000097          	auipc	ra,0x0
    8000070e:	622080e7          	jalr	1570(ra) # 80000d2c <memset>
    memset(p->trapframe, 0, sizeof(*p->trapframe));
    80000712:	12000613          	li	a2,288
    80000716:	4581                	li	a1,0
    80000718:	60a8                	ld	a0,64(s1)
    8000071a:	00000097          	auipc	ra,0x0
    8000071e:	612080e7          	jalr	1554(ra) # 80000d2c <memset>
    p->context.sp = p->kstack + PGSIZE;
    80000722:	70bc                	ld	a5,96(s1)
    80000724:	6705                	lui	a4,0x1
    80000726:	97ba                	add	a5,a5,a4
    80000728:	f8bc                	sd	a5,112(s1)
    p->context.ra = (uint64) forkret;
    8000072a:	00000797          	auipc	a5,0x0
    8000072e:	e5e78793          	addi	a5,a5,-418 # 80000588 <forkret>
    80000732:	f4bc                	sd	a5,104(s1)
    spin_unlock(&p->proc_lock);
    80000734:	8526                	mv	a0,s1
    80000736:	00003097          	auipc	ra,0x3
    8000073a:	bea080e7          	jalr	-1046(ra) # 80003320 <spin_unlock>
}
    8000073e:	8526                	mv	a0,s1
    80000740:	60e2                	ld	ra,24(sp)
    80000742:	6442                	ld	s0,16(sp)
    80000744:	64a2                	ld	s1,8(sp)
    80000746:	6902                	ld	s2,0(sp)
    80000748:	6105                	addi	sp,sp,32
    8000074a:	8082                	ret
        spin_unlock(&p->proc_lock);
    8000074c:	8526                	mv	a0,s1
    8000074e:	00003097          	auipc	ra,0x3
    80000752:	bd2080e7          	jalr	-1070(ra) # 80003320 <spin_unlock>
        return 0;
    80000756:	84ca                	mv	s1,s2
    80000758:	b7dd                	j	8000073e <alloc_proc+0x98>

000000008000075a <init_first_process>:
void init_first_process() {
    8000075a:	1101                	addi	sp,sp,-32
    8000075c:	ec06                	sd	ra,24(sp)
    8000075e:	e822                	sd	s0,16(sp)
    80000760:	e426                	sd	s1,8(sp)
    80000762:	1000                	addi	s0,sp,32
    struct proc *p = alloc_proc();
    80000764:	00000097          	auipc	ra,0x0
    80000768:	f42080e7          	jalr	-190(ra) # 800006a6 <alloc_proc>
    8000076c:	84aa                	mv	s1,a0
    user_vm_init(p->pagetable, initcode, sizeof(initcode));
    8000076e:	03400613          	li	a2,52
    80000772:	00005597          	auipc	a1,0x5
    80000776:	e0e58593          	addi	a1,a1,-498 # 80005580 <initcode>
    8000077a:	6528                	ld	a0,72(a0)
    8000077c:	00001097          	auipc	ra,0x1
    80000780:	ff4080e7          	jalr	-12(ra) # 80001770 <user_vm_init>
    p->sz = PGSIZE;
    80000784:	6785                	lui	a5,0x1
    80000786:	0ef4a423          	sw	a5,232(s1)
    p->trapframe->epc = 0;
    8000078a:	60bc                	ld	a5,64(s1)
    8000078c:	0007bc23          	sd	zero,24(a5) # 1018 <_entry-0x7fffefe8>
    p->trapframe->sp = PGSIZE;
    80000790:	60bc                	ld	a5,64(s1)
    80000792:	6705                	lui	a4,0x1
    80000794:	fb98                	sd	a4,48(a5)
    memmove(p->name, "initcode", sizeof(p->name));
    80000796:	4641                	li	a2,16
    80000798:	00005597          	auipc	a1,0x5
    8000079c:	88858593          	addi	a1,a1,-1912 # 80005020 <etext+0x20>
    800007a0:	0d848513          	addi	a0,s1,216
    800007a4:	00000097          	auipc	ra,0x0
    800007a8:	5ae080e7          	jalr	1454(ra) # 80000d52 <memmove>
    p->current_dir = namei("/");
    800007ac:	00005517          	auipc	a0,0x5
    800007b0:	88450513          	addi	a0,a0,-1916 # 80005030 <etext+0x30>
    800007b4:	00002097          	auipc	ra,0x2
    800007b8:	7f0080e7          	jalr	2032(ra) # 80002fa4 <namei>
    800007bc:	e8a8                	sd	a0,80(s1)
    p->state = RUNNABLE;
    800007be:	4789                	li	a5,2
    800007c0:	cc9c                	sw	a5,24(s1)
    initproc = p;
    800007c2:	00006797          	auipc	a5,0x6
    800007c6:	8297bf23          	sd	s1,-1986(a5) # 80006000 <initproc>
    printf("over");
    800007ca:	00005517          	auipc	a0,0x5
    800007ce:	86e50513          	addi	a0,a0,-1938 # 80005038 <etext+0x38>
    800007d2:	00001097          	auipc	ra,0x1
    800007d6:	9e8080e7          	jalr	-1560(ra) # 800011ba <printf>
}
    800007da:	60e2                	ld	ra,24(sp)
    800007dc:	6442                	ld	s0,16(sp)
    800007de:	64a2                	ld	s1,8(sp)
    800007e0:	6105                	addi	sp,sp,32
    800007e2:	8082                	ret

00000000800007e4 <cpuid>:
int cpuid() {
    800007e4:	1141                	addi	sp,sp,-16
    800007e6:	e422                	sd	s0,8(sp)
    800007e8:	0800                	addi	s0,sp,16
    800007ea:	8512                	mv	a0,tp
}
    800007ec:	2501                	sext.w	a0,a0
    800007ee:	6422                	ld	s0,8(sp)
    800007f0:	0141                	addi	sp,sp,16
    800007f2:	8082                	ret

00000000800007f4 <mycpu>:
struct cpu *mycpu(void) {
    800007f4:	1141                	addi	sp,sp,-16
    800007f6:	e422                	sd	s0,8(sp)
    800007f8:	0800                	addi	s0,sp,16
    800007fa:	8792                	mv	a5,tp
    struct cpu *c = &cpus[id];
    800007fc:	2781                	sext.w	a5,a5
    800007fe:	079e                	slli	a5,a5,0x7
}
    80000800:	00007517          	auipc	a0,0x7
    80000804:	a0850513          	addi	a0,a0,-1528 # 80007208 <cpus>
    80000808:	953e                	add	a0,a0,a5
    8000080a:	6422                	ld	s0,8(sp)
    8000080c:	0141                	addi	sp,sp,16
    8000080e:	8082                	ret

0000000080000810 <myproc>:
struct proc *myproc() {
    80000810:	1141                	addi	sp,sp,-16
    80000812:	e422                	sd	s0,8(sp)
    80000814:	0800                	addi	s0,sp,16
    80000816:	8792                	mv	a5,tp
    return mycpu()->proc;
    80000818:	2781                	sext.w	a5,a5
    8000081a:	079e                	slli	a5,a5,0x7
    8000081c:	00007717          	auipc	a4,0x7
    80000820:	9ec70713          	addi	a4,a4,-1556 # 80007208 <cpus>
    80000824:	97ba                	add	a5,a5,a4
}
    80000826:	6388                	ld	a0,0(a5)
    80000828:	6422                	ld	s0,8(sp)
    8000082a:	0141                	addi	sp,sp,16
    8000082c:	8082                	ret

000000008000082e <before_sched>:
        spin_unlock(&p->proc_lock);
        spin_lock(lock);
    }
}

void before_sched() {
    8000082e:	7179                	addi	sp,sp,-48
    80000830:	f406                	sd	ra,40(sp)
    80000832:	f022                	sd	s0,32(sp)
    80000834:	ec26                	sd	s1,24(sp)
    80000836:	e84a                	sd	s2,16(sp)
    80000838:	e44e                	sd	s3,8(sp)
    8000083a:	1800                	addi	s0,sp,48
    8000083c:	8792                	mv	a5,tp
    return mycpu()->proc;
    8000083e:	2781                	sext.w	a5,a5
    80000840:	079e                	slli	a5,a5,0x7
    80000842:	00007717          	auipc	a4,0x7
    80000846:	9c670713          	addi	a4,a4,-1594 # 80007208 <cpus>
    8000084a:	97ba                	add	a5,a5,a4
    8000084c:	0007b903          	ld	s2,0(a5)
    int intr_enable;
    struct proc *p = myproc();

    if (!spin_holding(&p->proc_lock))
    80000850:	854a                	mv	a0,s2
    80000852:	00003097          	auipc	ra,0x3
    80000856:	980080e7          	jalr	-1664(ra) # 800031d2 <spin_holding>
    8000085a:	c925                	beqz	a0,800008ca <before_sched+0x9c>
    8000085c:	8792                	mv	a5,tp
        panic("sched p->lock");
    if (mycpu()->noff != 1)
    8000085e:	2781                	sext.w	a5,a5
    80000860:	079e                	slli	a5,a5,0x7
    80000862:	00007717          	auipc	a4,0x7
    80000866:	9a670713          	addi	a4,a4,-1626 # 80007208 <cpus>
    8000086a:	97ba                	add	a5,a5,a4
    8000086c:	5fb8                	lw	a4,120(a5)
    8000086e:	4785                	li	a5,1
    80000870:	06f71663          	bne	a4,a5,800008dc <before_sched+0xae>
        panic("sched locks");
    if (p->state == RUNNING)
    80000874:	01892703          	lw	a4,24(s2)
    80000878:	478d                	li	a5,3
    8000087a:	06f70a63          	beq	a4,a5,800008ee <before_sched+0xc0>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000087e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000882:	8b89                	andi	a5,a5,2
        panic("sched running");
    if (intr_get())
    80000884:	efb5                	bnez	a5,80000900 <before_sched+0xd2>
  asm volatile("mv %0, tp" : "=r" (x) );
    80000886:	8792                	mv	a5,tp
        panic("sched interruptible");

    intr_enable = mycpu()->intr_enable;
    80000888:	00007497          	auipc	s1,0x7
    8000088c:	98048493          	addi	s1,s1,-1664 # 80007208 <cpus>
    80000890:	2781                	sext.w	a5,a5
    80000892:	079e                	slli	a5,a5,0x7
    80000894:	97a6                	add	a5,a5,s1
    80000896:	07c7a983          	lw	s3,124(a5)
    8000089a:	8592                	mv	a1,tp
    pswitch(&p->context, &mycpu()->context);
    8000089c:	2581                	sext.w	a1,a1
    8000089e:	059e                	slli	a1,a1,0x7
    800008a0:	05a1                	addi	a1,a1,8
    800008a2:	95a6                	add	a1,a1,s1
    800008a4:	06890513          	addi	a0,s2,104
    800008a8:	00000097          	auipc	ra,0x0
    800008ac:	5f2080e7          	jalr	1522(ra) # 80000e9a <pswitch>
    800008b0:	8792                	mv	a5,tp
    mycpu()->intr_enable = intr_enable;
    800008b2:	2781                	sext.w	a5,a5
    800008b4:	079e                	slli	a5,a5,0x7
    800008b6:	94be                	add	s1,s1,a5
    800008b8:	0734ae23          	sw	s3,124(s1)
}
    800008bc:	70a2                	ld	ra,40(sp)
    800008be:	7402                	ld	s0,32(sp)
    800008c0:	64e2                	ld	s1,24(sp)
    800008c2:	6942                	ld	s2,16(sp)
    800008c4:	69a2                	ld	s3,8(sp)
    800008c6:	6145                	addi	sp,sp,48
    800008c8:	8082                	ret
        panic("sched p->lock");
    800008ca:	00004517          	auipc	a0,0x4
    800008ce:	77650513          	addi	a0,a0,1910 # 80005040 <etext+0x40>
    800008d2:	00001097          	auipc	ra,0x1
    800008d6:	9ac080e7          	jalr	-1620(ra) # 8000127e <panic>
    800008da:	b749                	j	8000085c <before_sched+0x2e>
        panic("sched locks");
    800008dc:	00004517          	auipc	a0,0x4
    800008e0:	77450513          	addi	a0,a0,1908 # 80005050 <etext+0x50>
    800008e4:	00001097          	auipc	ra,0x1
    800008e8:	99a080e7          	jalr	-1638(ra) # 8000127e <panic>
    800008ec:	b761                	j	80000874 <before_sched+0x46>
        panic("sched running");
    800008ee:	00004517          	auipc	a0,0x4
    800008f2:	77250513          	addi	a0,a0,1906 # 80005060 <etext+0x60>
    800008f6:	00001097          	auipc	ra,0x1
    800008fa:	988080e7          	jalr	-1656(ra) # 8000127e <panic>
    800008fe:	b741                	j	8000087e <before_sched+0x50>
        panic("sched interruptible");
    80000900:	00004517          	auipc	a0,0x4
    80000904:	77050513          	addi	a0,a0,1904 # 80005070 <etext+0x70>
    80000908:	00001097          	auipc	ra,0x1
    8000090c:	976080e7          	jalr	-1674(ra) # 8000127e <panic>
    80000910:	bf9d                	j	80000886 <before_sched+0x58>

0000000080000912 <sleep>:
void sleep(void *chan, struct spinlock *lock) {
    80000912:	7179                	addi	sp,sp,-48
    80000914:	f406                	sd	ra,40(sp)
    80000916:	f022                	sd	s0,32(sp)
    80000918:	ec26                	sd	s1,24(sp)
    8000091a:	e84a                	sd	s2,16(sp)
    8000091c:	e44e                	sd	s3,8(sp)
    8000091e:	1800                	addi	s0,sp,48
    80000920:	89aa                	mv	s3,a0
    80000922:	8792                	mv	a5,tp
    return mycpu()->proc;
    80000924:	2781                	sext.w	a5,a5
    80000926:	079e                	slli	a5,a5,0x7
    80000928:	00007717          	auipc	a4,0x7
    8000092c:	8e070713          	addi	a4,a4,-1824 # 80007208 <cpus>
    80000930:	97ba                	add	a5,a5,a4
    80000932:	6384                	ld	s1,0(a5)
    if (lock != &p->proc_lock) {  //DOC: sleeplock0
    80000934:	04b48863          	beq	s1,a1,80000984 <sleep+0x72>
    80000938:	892e                	mv	s2,a1
        spin_lock(&p->proc_lock);  //DOC: sleeplock1
    8000093a:	8526                	mv	a0,s1
    8000093c:	00003097          	auipc	ra,0x3
    80000940:	910080e7          	jalr	-1776(ra) # 8000324c <spin_lock>
        spin_unlock(lock);
    80000944:	854a                	mv	a0,s2
    80000946:	00003097          	auipc	ra,0x3
    8000094a:	9da080e7          	jalr	-1574(ra) # 80003320 <spin_unlock>
    p->chan = chan;
    8000094e:	0334b423          	sd	s3,40(s1)
    p->state = SLEEPING;
    80000952:	4785                	li	a5,1
    80000954:	cc9c                	sw	a5,24(s1)
    before_sched();
    80000956:	00000097          	auipc	ra,0x0
    8000095a:	ed8080e7          	jalr	-296(ra) # 8000082e <before_sched>
    p->chan = 0;
    8000095e:	0204b423          	sd	zero,40(s1)
        spin_unlock(&p->proc_lock);
    80000962:	8526                	mv	a0,s1
    80000964:	00003097          	auipc	ra,0x3
    80000968:	9bc080e7          	jalr	-1604(ra) # 80003320 <spin_unlock>
        spin_lock(lock);
    8000096c:	854a                	mv	a0,s2
    8000096e:	00003097          	auipc	ra,0x3
    80000972:	8de080e7          	jalr	-1826(ra) # 8000324c <spin_lock>
}
    80000976:	70a2                	ld	ra,40(sp)
    80000978:	7402                	ld	s0,32(sp)
    8000097a:	64e2                	ld	s1,24(sp)
    8000097c:	6942                	ld	s2,16(sp)
    8000097e:	69a2                	ld	s3,8(sp)
    80000980:	6145                	addi	sp,sp,48
    80000982:	8082                	ret
    p->chan = chan;
    80000984:	f488                	sd	a0,40(s1)
    p->state = SLEEPING;
    80000986:	4785                	li	a5,1
    80000988:	cc9c                	sw	a5,24(s1)
    before_sched();
    8000098a:	00000097          	auipc	ra,0x0
    8000098e:	ea4080e7          	jalr	-348(ra) # 8000082e <before_sched>
    p->chan = 0;
    80000992:	0204b423          	sd	zero,40(s1)
    if (lock != &p->proc_lock) {
    80000996:	b7c5                	j	80000976 <sleep+0x64>

0000000080000998 <sleep_time>:

// 睡眠一定时间
void sleep_time(uint64 sleep_ticks) {
    80000998:	7179                	addi	sp,sp,-48
    8000099a:	f406                	sd	ra,40(sp)
    8000099c:	f022                	sd	s0,32(sp)
    8000099e:	ec26                	sd	s1,24(sp)
    800009a0:	e84a                	sd	s2,16(sp)
    800009a2:	e44e                	sd	s3,8(sp)
    800009a4:	e052                	sd	s4,0(sp)
    800009a6:	1800                	addi	s0,sp,48
    800009a8:	892a                	mv	s2,a0
    uint64 now = ticks;
    800009aa:	00005497          	auipc	s1,0x5
    800009ae:	66e48493          	addi	s1,s1,1646 # 80006018 <ticks>
    800009b2:	0004b983          	ld	s3,0(s1)
    spin_lock(&ticks_lock);
    800009b6:	0006b517          	auipc	a0,0x6b
    800009ba:	06250513          	addi	a0,a0,98 # 8006ba18 <ticks_lock>
    800009be:	00003097          	auipc	ra,0x3
    800009c2:	88e080e7          	jalr	-1906(ra) # 8000324c <spin_lock>
    for (; ticks - now < sleep_ticks;) {
    800009c6:	609c                	ld	a5,0(s1)
    800009c8:	413787b3          	sub	a5,a5,s3
    800009cc:	0327f163          	bgeu	a5,s2,800009ee <sleep_time+0x56>
        sleep(&ticks, &ticks_lock);
    800009d0:	0006ba17          	auipc	s4,0x6b
    800009d4:	048a0a13          	addi	s4,s4,72 # 8006ba18 <ticks_lock>
    800009d8:	85d2                	mv	a1,s4
    800009da:	8526                	mv	a0,s1
    800009dc:	00000097          	auipc	ra,0x0
    800009e0:	f36080e7          	jalr	-202(ra) # 80000912 <sleep>
    for (; ticks - now < sleep_ticks;) {
    800009e4:	609c                	ld	a5,0(s1)
    800009e6:	413787b3          	sub	a5,a5,s3
    800009ea:	ff27e7e3          	bltu	a5,s2,800009d8 <sleep_time+0x40>
    }
    spin_unlock(&ticks_lock);
    800009ee:	0006b517          	auipc	a0,0x6b
    800009f2:	02a50513          	addi	a0,a0,42 # 8006ba18 <ticks_lock>
    800009f6:	00003097          	auipc	ra,0x3
    800009fa:	92a080e7          	jalr	-1750(ra) # 80003320 <spin_unlock>
}
    800009fe:	70a2                	ld	ra,40(sp)
    80000a00:	7402                	ld	s0,32(sp)
    80000a02:	64e2                	ld	s1,24(sp)
    80000a04:	6942                	ld	s2,16(sp)
    80000a06:	69a2                	ld	s3,8(sp)
    80000a08:	6a02                	ld	s4,0(sp)
    80000a0a:	6145                	addi	sp,sp,48
    80000a0c:	8082                	ret

0000000080000a0e <wakeup>:

// 唤醒指定chan上的进程
void wakeup(void *chan) {
    80000a0e:	1141                	addi	sp,sp,-16
    80000a10:	e422                	sd	s0,8(sp)
    80000a12:	0800                	addi	s0,sp,16
    struct proc *p;
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80000a14:	00048797          	auipc	a5,0x48
    80000a18:	87478793          	addi	a5,a5,-1932 # 80048288 <proc_table>
        if (p->state == SLEEPING && p->chan == chan) {
    80000a1c:	4605                	li	a2,1
            p->state = RUNNABLE;
    80000a1e:	4589                	li	a1,2
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80000a20:	0004b697          	auipc	a3,0x4b
    80000a24:	46868693          	addi	a3,a3,1128 # 8004be88 <kmem>
    80000a28:	a031                	j	80000a34 <wakeup+0x26>
            p->state = RUNNABLE;
    80000a2a:	cf8c                	sw	a1,24(a5)
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80000a2c:	0f078793          	addi	a5,a5,240
    80000a30:	00d78963          	beq	a5,a3,80000a42 <wakeup+0x34>
        if (p->state == SLEEPING && p->chan == chan) {
    80000a34:	4f98                	lw	a4,24(a5)
    80000a36:	fec71be3          	bne	a4,a2,80000a2c <wakeup+0x1e>
    80000a3a:	7798                	ld	a4,40(a5)
    80000a3c:	fea718e3          	bne	a4,a0,80000a2c <wakeup+0x1e>
    80000a40:	b7ed                	j	80000a2a <wakeup+0x1c>
        }
    }
}
    80000a42:	6422                	ld	s0,8(sp)
    80000a44:	0141                	addi	sp,sp,16
    80000a46:	8082                	ret

0000000080000a48 <scheduler>:
void scheduler() {
    80000a48:	711d                	addi	sp,sp,-96
    80000a4a:	ec86                	sd	ra,88(sp)
    80000a4c:	e8a2                	sd	s0,80(sp)
    80000a4e:	e4a6                	sd	s1,72(sp)
    80000a50:	e0ca                	sd	s2,64(sp)
    80000a52:	fc4e                	sd	s3,56(sp)
    80000a54:	f852                	sd	s4,48(sp)
    80000a56:	f456                	sd	s5,40(sp)
    80000a58:	f05a                	sd	s6,32(sp)
    80000a5a:	ec5e                	sd	s7,24(sp)
    80000a5c:	e862                	sd	s8,16(sp)
    80000a5e:	e466                	sd	s9,8(sp)
    80000a60:	e06a                	sd	s10,0(sp)
    80000a62:	1080                	addi	s0,sp,96
    80000a64:	8792                	mv	a5,tp
    int id = r_tp();
    80000a66:	2781                	sext.w	a5,a5
                pswitch(&c->context, &p->context);
    80000a68:	00779c93          	slli	s9,a5,0x7
    80000a6c:	00006717          	auipc	a4,0x6
    80000a70:	7a470713          	addi	a4,a4,1956 # 80007210 <cpus+0x8>
    80000a74:	9cba                	add	s9,s9,a4
                wakeup(initproc);
    80000a76:	00005d17          	auipc	s10,0x5
    80000a7a:	58ad0d13          	addi	s10,s10,1418 # 80006000 <initproc>
            if (p->state == RUNNABLE) {
    80000a7e:	4a89                	li	s5,2
                c->proc = p;
    80000a80:	079e                	slli	a5,a5,0x7
    80000a82:	00006b97          	auipc	s7,0x6
    80000a86:	786b8b93          	addi	s7,s7,1926 # 80007208 <cpus>
    80000a8a:	9bbe                	add	s7,s7,a5
    80000a8c:	a08d                	j	80000aee <scheduler+0xa6>
            spin_unlock(&p->proc_lock);
    80000a8e:	854a                	mv	a0,s2
    80000a90:	00003097          	auipc	ra,0x3
    80000a94:	890080e7          	jalr	-1904(ra) # 80003320 <spin_unlock>
        for (int i = 0; i < NPROC; i++) {
    80000a98:	0f048493          	addi	s1,s1,240
    80000a9c:	03348f63          	beq	s1,s3,80000ada <scheduler+0x92>
            p = &proc_table[i];
    80000aa0:	8926                	mv	s2,s1
            spin_lock(&p->proc_lock);
    80000aa2:	8526                	mv	a0,s1
    80000aa4:	00002097          	auipc	ra,0x2
    80000aa8:	7a8080e7          	jalr	1960(ra) # 8000324c <spin_lock>
            if (p->state != UNUSED && p->state != ZOMBIE) {
    80000aac:	4c9c                	lw	a5,24(s1)
    80000aae:	d3e5                	beqz	a5,80000a8e <scheduler+0x46>
    80000ab0:	07678163          	beq	a5,s6,80000b12 <scheduler+0xca>
                alive_p++;
    80000ab4:	2a05                	addiw	s4,s4,1
            if (p->state == RUNNABLE) {
    80000ab6:	01892783          	lw	a5,24(s2)
    80000aba:	fd579ae3          	bne	a5,s5,80000a8e <scheduler+0x46>
                p->state = RUNNING;
    80000abe:	01892c23          	sw	s8,24(s2)
                c->proc = p;
    80000ac2:	012bb023          	sd	s2,0(s7)
                pswitch(&c->context, &p->context);
    80000ac6:	06848593          	addi	a1,s1,104
    80000aca:	8566                	mv	a0,s9
    80000acc:	00000097          	auipc	ra,0x0
    80000ad0:	3ce080e7          	jalr	974(ra) # 80000e9a <pswitch>
                c->proc = 0;
    80000ad4:	000bb023          	sd	zero,0(s7)
    80000ad8:	bf5d                	j	80000a8e <scheduler+0x46>
        if (alive_p <= 2) {
    80000ada:	014aca63          	blt	s5,s4,80000aee <scheduler+0xa6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000ade:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000ae2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000ae6:	10079073          	csrw	sstatus,a5
            asm volatile("wfi");
    80000aea:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000aee:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000af2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000af6:	10079073          	csrw	sstatus,a5
        for (int i = 0; i < NPROC; i++) {
    80000afa:	00047497          	auipc	s1,0x47
    80000afe:	78e48493          	addi	s1,s1,1934 # 80048288 <proc_table>
    80000b02:	0004b997          	auipc	s3,0x4b
    80000b06:	38698993          	addi	s3,s3,902 # 8004be88 <kmem>
        alive_p = 0;
    80000b0a:	4a01                	li	s4,0
            if (p->state != UNUSED && p->state != ZOMBIE) {
    80000b0c:	4b11                	li	s6,4
                p->state = RUNNING;
    80000b0e:	4c0d                	li	s8,3
    80000b10:	bf41                	j	80000aa0 <scheduler+0x58>
                wakeup(initproc);
    80000b12:	000d3503          	ld	a0,0(s10)
    80000b16:	00000097          	auipc	ra,0x0
    80000b1a:	ef8080e7          	jalr	-264(ra) # 80000a0e <wakeup>
    80000b1e:	bf61                	j	80000ab6 <scheduler+0x6e>

0000000080000b20 <wait>:
//
// 等待子进程退出, 返回其子进程id
// 没有子进程返回-1， 将退出状态复
// 制到status中。
//
int wait(int *status) {
    80000b20:	715d                	addi	sp,sp,-80
    80000b22:	e486                	sd	ra,72(sp)
    80000b24:	e0a2                	sd	s0,64(sp)
    80000b26:	fc26                	sd	s1,56(sp)
    80000b28:	f84a                	sd	s2,48(sp)
    80000b2a:	f44e                	sd	s3,40(sp)
    80000b2c:	f052                	sd	s4,32(sp)
    80000b2e:	ec56                	sd	s5,24(sp)
    80000b30:	e85a                	sd	s6,16(sp)
    80000b32:	e45e                	sd	s7,8(sp)
    80000b34:	e062                	sd	s8,0(sp)
    80000b36:	0880                	addi	s0,sp,80
    80000b38:	8b2a                	mv	s6,a0
  asm volatile("mv %0, tp" : "=r" (x) );
    80000b3a:	8792                	mv	a5,tp
    return mycpu()->proc;
    80000b3c:	2781                	sext.w	a5,a5
    80000b3e:	079e                	slli	a5,a5,0x7
    80000b40:	00006717          	auipc	a4,0x6
    80000b44:	6c870713          	addi	a4,a4,1736 # 80007208 <cpus>
    80000b48:	97ba                	add	a5,a5,a4
    80000b4a:	0007b903          	ld	s2,0(a5)
    struct proc *cp; // 子进程
    struct proc *p;
    int havechild, pid;
    p = myproc();
    spin_lock(&p->proc_lock);
    80000b4e:	854a                	mv	a0,s2
    80000b50:	00002097          	auipc	ra,0x2
    80000b54:	6fc080e7          	jalr	1788(ra) # 8000324c <spin_lock>
    for (;;) {
        havechild = 0;
    80000b58:	4b81                	li	s7,0
        for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
            if (cp->parent == p) {
                spin_lock(&cp->proc_lock);
                havechild = 1;
                if (cp->state == ZOMBIE) {
    80000b5a:	4a11                	li	s4,4
        for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    80000b5c:	0004b997          	auipc	s3,0x4b
    80000b60:	32c98993          	addi	s3,s3,812 # 8004be88 <kmem>
                havechild = 1;
    80000b64:	4a85                	li	s5,1
    return mycpu()->proc;
    80000b66:	00006c17          	auipc	s8,0x6
    80000b6a:	6a2c0c13          	addi	s8,s8,1698 # 80007208 <cpus>
        havechild = 0;
    80000b6e:	875e                	mv	a4,s7
        for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    80000b70:	00047497          	auipc	s1,0x47
    80000b74:	71848493          	addi	s1,s1,1816 # 80048288 <proc_table>
    80000b78:	a80d                	j	80000baa <wait+0x8a>
                    pid = cp->pid;
    80000b7a:	0384a983          	lw	s3,56(s1)
                    if (status) {
    80000b7e:	000b0563          	beqz	s6,80000b88 <wait+0x68>
                        *status = cp->xstate;
    80000b82:	58dc                	lw	a5,52(s1)
    80000b84:	00fb2023          	sw	a5,0(s6)
                    }
                    cp->state = UNUSED;
    80000b88:	0004ac23          	sw	zero,24(s1)
                    spin_unlock(&cp->proc_lock);
    80000b8c:	8526                	mv	a0,s1
    80000b8e:	00002097          	auipc	ra,0x2
    80000b92:	792080e7          	jalr	1938(ra) # 80003320 <spin_unlock>
                    spin_unlock(&p->proc_lock);
    80000b96:	854a                	mv	a0,s2
    80000b98:	00002097          	auipc	ra,0x2
    80000b9c:	788080e7          	jalr	1928(ra) # 80003320 <spin_unlock>
                    return pid;
    80000ba0:	a80d                	j	80000bd2 <wait+0xb2>
        for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    80000ba2:	0f048493          	addi	s1,s1,240
    80000ba6:	03348463          	beq	s1,s3,80000bce <wait+0xae>
            if (cp->parent == p) {
    80000baa:	709c                	ld	a5,32(s1)
    80000bac:	ff279be3          	bne	a5,s2,80000ba2 <wait+0x82>
                spin_lock(&cp->proc_lock);
    80000bb0:	8526                	mv	a0,s1
    80000bb2:	00002097          	auipc	ra,0x2
    80000bb6:	69a080e7          	jalr	1690(ra) # 8000324c <spin_lock>
                if (cp->state == ZOMBIE) {
    80000bba:	4c9c                	lw	a5,24(s1)
    80000bbc:	fb478fe3          	beq	a5,s4,80000b7a <wait+0x5a>
                }
                spin_unlock(&cp->proc_lock);
    80000bc0:	8526                	mv	a0,s1
    80000bc2:	00002097          	auipc	ra,0x2
    80000bc6:	75e080e7          	jalr	1886(ra) # 80003320 <spin_unlock>
                havechild = 1;
    80000bca:	8756                	mv	a4,s5
    80000bcc:	bfd9                	j	80000ba2 <wait+0x82>
            }
        }
        if (!havechild) {
    80000bce:	ef19                	bnez	a4,80000bec <wait+0xcc>
            return -1;
    80000bd0:	59fd                	li	s3,-1
        }
        sleep(p, &myproc()->proc_lock); // 等待子进程唤醒
    }
}
    80000bd2:	854e                	mv	a0,s3
    80000bd4:	60a6                	ld	ra,72(sp)
    80000bd6:	6406                	ld	s0,64(sp)
    80000bd8:	74e2                	ld	s1,56(sp)
    80000bda:	7942                	ld	s2,48(sp)
    80000bdc:	79a2                	ld	s3,40(sp)
    80000bde:	7a02                	ld	s4,32(sp)
    80000be0:	6ae2                	ld	s5,24(sp)
    80000be2:	6b42                	ld	s6,16(sp)
    80000be4:	6ba2                	ld	s7,8(sp)
    80000be6:	6c02                	ld	s8,0(sp)
    80000be8:	6161                	addi	sp,sp,80
    80000bea:	8082                	ret
    80000bec:	8792                	mv	a5,tp
    return mycpu()->proc;
    80000bee:	2781                	sext.w	a5,a5
    80000bf0:	079e                	slli	a5,a5,0x7
    80000bf2:	97e2                	add	a5,a5,s8
        sleep(p, &myproc()->proc_lock); // 等待子进程唤醒
    80000bf4:	638c                	ld	a1,0(a5)
    80000bf6:	854a                	mv	a0,s2
    80000bf8:	00000097          	auipc	ra,0x0
    80000bfc:	d1a080e7          	jalr	-742(ra) # 80000912 <sleep>
        havechild = 0;
    80000c00:	b7bd                	j	80000b6e <wait+0x4e>

0000000080000c02 <exit>:
// 让父进程来设置其state为UNUSED
// 若父进程已经exit, 则会由init进
// 程来完成父进程在exit时，会将其
// 子进程的parent设置为init进程
//
void exit(int status) {
    80000c02:	1101                	addi	sp,sp,-32
    80000c04:	ec06                	sd	ra,24(sp)
    80000c06:	e822                	sd	s0,16(sp)
    80000c08:	e426                	sd	s1,8(sp)
    80000c0a:	1000                	addi	s0,sp,32
    80000c0c:	8792                	mv	a5,tp
    return mycpu()->proc;
    80000c0e:	2781                	sext.w	a5,a5
    80000c10:	079e                	slli	a5,a5,0x7
    80000c12:	00006717          	auipc	a4,0x6
    80000c16:	5f670713          	addi	a4,a4,1526 # 80007208 <cpus>
    80000c1a:	97ba                	add	a5,a5,a4
    80000c1c:	6384                	ld	s1,0(a5)
    struct proc *p, *cp;
    p = myproc();
    p->state = ZOMBIE;
    80000c1e:	4791                	li	a5,4
    80000c20:	cc9c                	sw	a5,24(s1)
    p->xstate = status;
    80000c22:	d8c8                	sw	a0,52(s1)
    for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
        if (cp->parent == p) {
            cp->parent = initproc;
    80000c24:	00005617          	auipc	a2,0x5
    80000c28:	3dc63603          	ld	a2,988(a2) # 80006000 <initproc>
    for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    80000c2c:	00047797          	auipc	a5,0x47
    80000c30:	65c78793          	addi	a5,a5,1628 # 80048288 <proc_table>
    80000c34:	0004b697          	auipc	a3,0x4b
    80000c38:	25468693          	addi	a3,a3,596 # 8004be88 <kmem>
    80000c3c:	a031                	j	80000c48 <exit+0x46>
            cp->parent = initproc;
    80000c3e:	f390                	sd	a2,32(a5)
    for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    80000c40:	0f078793          	addi	a5,a5,240
    80000c44:	00d78663          	beq	a5,a3,80000c50 <exit+0x4e>
        if (cp->parent == p) {
    80000c48:	7398                	ld	a4,32(a5)
    80000c4a:	fe971be3          	bne	a4,s1,80000c40 <exit+0x3e>
    80000c4e:	bfc5                	j	80000c3e <exit+0x3c>
        }
    }
    wakeup(p->parent);
    80000c50:	7088                	ld	a0,32(s1)
    80000c52:	00000097          	auipc	ra,0x0
    80000c56:	dbc080e7          	jalr	-580(ra) # 80000a0e <wakeup>
    spin_lock(&p->proc_lock);
    80000c5a:	8526                	mv	a0,s1
    80000c5c:	00002097          	auipc	ra,0x2
    80000c60:	5f0080e7          	jalr	1520(ra) # 8000324c <spin_lock>
    before_sched();
    80000c64:	00000097          	auipc	ra,0x0
    80000c68:	bca080e7          	jalr	-1078(ra) # 8000082e <before_sched>
    panic("exit");
    80000c6c:	00004517          	auipc	a0,0x4
    80000c70:	41c50513          	addi	a0,a0,1052 # 80005088 <etext+0x88>
    80000c74:	00000097          	auipc	ra,0x0
    80000c78:	60a080e7          	jalr	1546(ra) # 8000127e <panic>
}
    80000c7c:	60e2                	ld	ra,24(sp)
    80000c7e:	6442                	ld	s0,16(sp)
    80000c80:	64a2                	ld	s1,8(sp)
    80000c82:	6105                	addi	sp,sp,32
    80000c84:	8082                	ret

0000000080000c86 <print_proc>:

void print_proc() {
    80000c86:	7179                	addi	sp,sp,-48
    80000c88:	f406                	sd	ra,40(sp)
    80000c8a:	f022                	sd	s0,32(sp)
    80000c8c:	ec26                	sd	s1,24(sp)
    80000c8e:	e84a                	sd	s2,16(sp)
    80000c90:	e44e                	sd	s3,8(sp)
    80000c92:	1800                	addi	s0,sp,48
    struct proc *p;
    printf(" \npid\tstate\n");
    80000c94:	00004517          	auipc	a0,0x4
    80000c98:	3fc50513          	addi	a0,a0,1020 # 80005090 <etext+0x90>
    80000c9c:	00000097          	auipc	ra,0x0
    80000ca0:	51e080e7          	jalr	1310(ra) # 800011ba <printf>
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80000ca4:	00047497          	auipc	s1,0x47
    80000ca8:	5e448493          	addi	s1,s1,1508 # 80048288 <proc_table>
        if (p->state == UNUSED)
            continue;
        printf(" %d\t  %d\n", p->pid, p->state);
    80000cac:	00004997          	auipc	s3,0x4
    80000cb0:	3f498993          	addi	s3,s3,1012 # 800050a0 <etext+0xa0>
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80000cb4:	0004b917          	auipc	s2,0x4b
    80000cb8:	1d490913          	addi	s2,s2,468 # 8004be88 <kmem>
    80000cbc:	a029                	j	80000cc6 <print_proc+0x40>
    80000cbe:	0f048493          	addi	s1,s1,240
    80000cc2:	01248b63          	beq	s1,s2,80000cd8 <print_proc+0x52>
        if (p->state == UNUSED)
    80000cc6:	4c90                	lw	a2,24(s1)
    80000cc8:	da7d                	beqz	a2,80000cbe <print_proc+0x38>
        printf(" %d\t  %d\n", p->pid, p->state);
    80000cca:	5c8c                	lw	a1,56(s1)
    80000ccc:	854e                	mv	a0,s3
    80000cce:	00000097          	auipc	ra,0x0
    80000cd2:	4ec080e7          	jalr	1260(ra) # 800011ba <printf>
    80000cd6:	b7e5                	j	80000cbe <print_proc+0x38>
    }
}
    80000cd8:	70a2                	ld	ra,40(sp)
    80000cda:	7402                	ld	s0,32(sp)
    80000cdc:	64e2                	ld	s1,24(sp)
    80000cde:	6942                	ld	s2,16(sp)
    80000ce0:	69a2                	ld	s3,8(sp)
    80000ce2:	6145                	addi	sp,sp,48
    80000ce4:	8082                	ret

0000000080000ce6 <yield>:

//
// 让出cpu
//
void yield() {
    80000ce6:	1101                	addi	sp,sp,-32
    80000ce8:	ec06                	sd	ra,24(sp)
    80000cea:	e822                	sd	s0,16(sp)
    80000cec:	e426                	sd	s1,8(sp)
    80000cee:	1000                	addi	s0,sp,32
    80000cf0:	8792                	mv	a5,tp
    return mycpu()->proc;
    80000cf2:	2781                	sext.w	a5,a5
    80000cf4:	079e                	slli	a5,a5,0x7
    80000cf6:	00006717          	auipc	a4,0x6
    80000cfa:	51270713          	addi	a4,a4,1298 # 80007208 <cpus>
    80000cfe:	97ba                	add	a5,a5,a4
    80000d00:	6384                	ld	s1,0(a5)
    struct proc *p = myproc();
    spin_lock(&p->proc_lock);
    80000d02:	8526                	mv	a0,s1
    80000d04:	00002097          	auipc	ra,0x2
    80000d08:	548080e7          	jalr	1352(ra) # 8000324c <spin_lock>
    p->state = RUNNABLE;
    80000d0c:	4789                	li	a5,2
    80000d0e:	cc9c                	sw	a5,24(s1)
    before_sched();
    80000d10:	00000097          	auipc	ra,0x0
    80000d14:	b1e080e7          	jalr	-1250(ra) # 8000082e <before_sched>
    spin_unlock(&p->proc_lock);
    80000d18:	8526                	mv	a0,s1
    80000d1a:	00002097          	auipc	ra,0x2
    80000d1e:	606080e7          	jalr	1542(ra) # 80003320 <spin_unlock>
}
    80000d22:	60e2                	ld	ra,24(sp)
    80000d24:	6442                	ld	s0,16(sp)
    80000d26:	64a2                	ld	s1,8(sp)
    80000d28:	6105                	addi	sp,sp,32
    80000d2a:	8082                	ret

0000000080000d2c <memset>:
#include "types.h"

void *memset(void *dst, int c, uint n) {
    80000d2c:	1141                	addi	sp,sp,-16
    80000d2e:	e422                	sd	s0,8(sp)
    80000d30:	0800                	addi	s0,sp,16
    char *cdst = (char *) dst;
    int i;
    for (i = 0; i < n; i++) {
    80000d32:	ce09                	beqz	a2,80000d4c <memset+0x20>
    80000d34:	87aa                	mv	a5,a0
    80000d36:	fff6071b          	addiw	a4,a2,-1
    80000d3a:	1702                	slli	a4,a4,0x20
    80000d3c:	9301                	srli	a4,a4,0x20
    80000d3e:	0705                	addi	a4,a4,1
    80000d40:	972a                	add	a4,a4,a0
        cdst[i] = c;
    80000d42:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++) {
    80000d46:	0785                	addi	a5,a5,1
    80000d48:	fee79de3          	bne	a5,a4,80000d42 <memset+0x16>
    }
    return dst;
}
    80000d4c:	6422                	ld	s0,8(sp)
    80000d4e:	0141                	addi	sp,sp,16
    80000d50:	8082                	ret

0000000080000d52 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
    80000d52:	1141                	addi	sp,sp,-16
    80000d54:	e422                	sd	s0,8(sp)
    80000d56:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst) {
    80000d58:	02b57663          	bgeu	a0,a1,80000d84 <memmove+0x32>
        while (n-- > 0)
    80000d5c:	02c05163          	blez	a2,80000d7e <memmove+0x2c>
    80000d60:	fff6079b          	addiw	a5,a2,-1
    80000d64:	1782                	slli	a5,a5,0x20
    80000d66:	9381                	srli	a5,a5,0x20
    80000d68:	0785                	addi	a5,a5,1
    80000d6a:	97aa                	add	a5,a5,a0
    dst = vdst;
    80000d6c:	872a                	mv	a4,a0
            *dst++ = *src++;
    80000d6e:	0585                	addi	a1,a1,1
    80000d70:	0705                	addi	a4,a4,1
    80000d72:	fff5c683          	lbu	a3,-1(a1)
    80000d76:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
    80000d7a:	fee79ae3          	bne	a5,a4,80000d6e <memmove+0x1c>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
    80000d7e:	6422                	ld	s0,8(sp)
    80000d80:	0141                	addi	sp,sp,16
    80000d82:	8082                	ret
        dst += n;
    80000d84:	00c50733          	add	a4,a0,a2
        src += n;
    80000d88:	95b2                	add	a1,a1,a2
        while (n-- > 0)
    80000d8a:	fec05ae3          	blez	a2,80000d7e <memmove+0x2c>
    80000d8e:	fff6079b          	addiw	a5,a2,-1
    80000d92:	1782                	slli	a5,a5,0x20
    80000d94:	9381                	srli	a5,a5,0x20
    80000d96:	fff7c793          	not	a5,a5
    80000d9a:	97ba                	add	a5,a5,a4
            *--dst = *--src;
    80000d9c:	15fd                	addi	a1,a1,-1
    80000d9e:	177d                	addi	a4,a4,-1
    80000da0:	0005c683          	lbu	a3,0(a1)
    80000da4:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
    80000da8:	fee79ae3          	bne	a5,a4,80000d9c <memmove+0x4a>
    80000dac:	bfc9                	j	80000d7e <memmove+0x2c>

0000000080000dae <strlen>:

uint strlen(const char *s) {
    80000dae:	1141                	addi	sp,sp,-16
    80000db0:	e422                	sd	s0,8(sp)
    80000db2:	0800                	addi	s0,sp,16
    int n;
    for (n = 0; s[n]; n++);
    80000db4:	00054783          	lbu	a5,0(a0)
    80000db8:	cf91                	beqz	a5,80000dd4 <strlen+0x26>
    80000dba:	0505                	addi	a0,a0,1
    80000dbc:	87aa                	mv	a5,a0
    80000dbe:	4685                	li	a3,1
    80000dc0:	9e89                	subw	a3,a3,a0
    80000dc2:	00f6853b          	addw	a0,a3,a5
    80000dc6:	0785                	addi	a5,a5,1
    80000dc8:	fff7c703          	lbu	a4,-1(a5)
    80000dcc:	fb7d                	bnez	a4,80000dc2 <strlen+0x14>
    return n;
}
    80000dce:	6422                	ld	s0,8(sp)
    80000dd0:	0141                	addi	sp,sp,16
    80000dd2:	8082                	ret
    for (n = 0; s[n]; n++);
    80000dd4:	4501                	li	a0,0
    80000dd6:	bfe5                	j	80000dce <strlen+0x20>

0000000080000dd8 <strcpy>:

char* strcpy(char* s, const char* t)
{
    80000dd8:	1141                	addi	sp,sp,-16
    80000dda:	e422                	sd	s0,8(sp)
    80000ddc:	0800                	addi	s0,sp,16
    char* os;
    os = s;
    while ((*s++ = *t++) != 0)
    80000dde:	87aa                	mv	a5,a0
    80000de0:	0585                	addi	a1,a1,1
    80000de2:	0785                	addi	a5,a5,1
    80000de4:	fff5c703          	lbu	a4,-1(a1)
    80000de8:	fee78fa3          	sb	a4,-1(a5)
    80000dec:	fb75                	bnez	a4,80000de0 <strcpy+0x8>
        ;
    return os;
}
    80000dee:	6422                	ld	s0,8(sp)
    80000df0:	0141                	addi	sp,sp,16
    80000df2:	8082                	ret

0000000080000df4 <strncpy>:

char * strncpy(char *s, const char *t, int n) {
    80000df4:	1141                	addi	sp,sp,-16
    80000df6:	e422                	sd	s0,8(sp)
    80000df8:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while (n-- > 0 && (*s++ = *t++) != 0);
    80000dfa:	872a                	mv	a4,a0
    80000dfc:	8832                	mv	a6,a2
    80000dfe:	367d                	addiw	a2,a2,-1
    80000e00:	01005963          	blez	a6,80000e12 <strncpy+0x1e>
    80000e04:	0705                	addi	a4,a4,1
    80000e06:	0005c783          	lbu	a5,0(a1)
    80000e0a:	fef70fa3          	sb	a5,-1(a4)
    80000e0e:	0585                	addi	a1,a1,1
    80000e10:	f7f5                	bnez	a5,80000dfc <strncpy+0x8>
    while (n-- > 0)
    80000e12:	00c05d63          	blez	a2,80000e2c <strncpy+0x38>
    80000e16:	86ba                	mv	a3,a4
        *s++ = 0;
    80000e18:	0685                	addi	a3,a3,1
    80000e1a:	fe068fa3          	sb	zero,-1(a3)
    while (n-- > 0)
    80000e1e:	fff6c793          	not	a5,a3
    80000e22:	9fb9                	addw	a5,a5,a4
    80000e24:	010787bb          	addw	a5,a5,a6
    80000e28:	fef048e3          	bgtz	a5,80000e18 <strncpy+0x24>
    return os;
}
    80000e2c:	6422                	ld	s0,8(sp)
    80000e2e:	0141                	addi	sp,sp,16
    80000e30:	8082                	ret

0000000080000e32 <strcmp>:

int strcmp(const char* p, const char* q)
{
    80000e32:	1141                	addi	sp,sp,-16
    80000e34:	e422                	sd	s0,8(sp)
    80000e36:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
    80000e38:	00054783          	lbu	a5,0(a0)
    80000e3c:	cb91                	beqz	a5,80000e50 <strcmp+0x1e>
    80000e3e:	0005c703          	lbu	a4,0(a1)
    80000e42:	00f71763          	bne	a4,a5,80000e50 <strcmp+0x1e>
        p++, q++;
    80000e46:	0505                	addi	a0,a0,1
    80000e48:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
    80000e4a:	00054783          	lbu	a5,0(a0)
    80000e4e:	fbe5                	bnez	a5,80000e3e <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
    80000e50:	0005c503          	lbu	a0,0(a1)
}
    80000e54:	40a7853b          	subw	a0,a5,a0
    80000e58:	6422                	ld	s0,8(sp)
    80000e5a:	0141                	addi	sp,sp,16
    80000e5c:	8082                	ret

0000000080000e5e <strncmp>:

int strncmp(const char *p, const char *q, uint n)
{
    80000e5e:	1141                	addi	sp,sp,-16
    80000e60:	e422                	sd	s0,8(sp)
    80000e62:	0800                	addi	s0,sp,16
    while(n > 0 && *p && *p == *q)
    80000e64:	ce11                	beqz	a2,80000e80 <strncmp+0x22>
    80000e66:	00054783          	lbu	a5,0(a0)
    80000e6a:	cf89                	beqz	a5,80000e84 <strncmp+0x26>
    80000e6c:	0005c703          	lbu	a4,0(a1)
    80000e70:	00f71a63          	bne	a4,a5,80000e84 <strncmp+0x26>
        n--, p++, q++;
    80000e74:	367d                	addiw	a2,a2,-1
    80000e76:	0505                	addi	a0,a0,1
    80000e78:	0585                	addi	a1,a1,1
    while(n > 0 && *p && *p == *q)
    80000e7a:	f675                	bnez	a2,80000e66 <strncmp+0x8>
    if(n == 0)
        return 0;
    80000e7c:	4501                	li	a0,0
    80000e7e:	a809                	j	80000e90 <strncmp+0x32>
    80000e80:	4501                	li	a0,0
    80000e82:	a039                	j	80000e90 <strncmp+0x32>
    if(n == 0)
    80000e84:	ca09                	beqz	a2,80000e96 <strncmp+0x38>
    return (uchar)*p - (uchar)*q;
    80000e86:	00054503          	lbu	a0,0(a0)
    80000e8a:	0005c783          	lbu	a5,0(a1)
    80000e8e:	9d1d                	subw	a0,a0,a5
}
    80000e90:	6422                	ld	s0,8(sp)
    80000e92:	0141                	addi	sp,sp,16
    80000e94:	8082                	ret
        return 0;
    80000e96:	4501                	li	a0,0
    80000e98:	bfe5                	j	80000e90 <strncmp+0x32>

0000000080000e9a <pswitch>:
    80000e9a:	00153023          	sd	ra,0(a0)
    80000e9e:	00253423          	sd	sp,8(a0)
    80000ea2:	e900                	sd	s0,16(a0)
    80000ea4:	ed04                	sd	s1,24(a0)
    80000ea6:	03253023          	sd	s2,32(a0)
    80000eaa:	03353423          	sd	s3,40(a0)
    80000eae:	03453823          	sd	s4,48(a0)
    80000eb2:	03553c23          	sd	s5,56(a0)
    80000eb6:	05653023          	sd	s6,64(a0)
    80000eba:	05753423          	sd	s7,72(a0)
    80000ebe:	05853823          	sd	s8,80(a0)
    80000ec2:	05953c23          	sd	s9,88(a0)
    80000ec6:	07a53023          	sd	s10,96(a0)
    80000eca:	07b53423          	sd	s11,104(a0)
    80000ece:	0005b083          	ld	ra,0(a1)
    80000ed2:	0085b103          	ld	sp,8(a1)
    80000ed6:	6980                	ld	s0,16(a1)
    80000ed8:	6d84                	ld	s1,24(a1)
    80000eda:	0205b903          	ld	s2,32(a1)
    80000ede:	0285b983          	ld	s3,40(a1)
    80000ee2:	0305ba03          	ld	s4,48(a1)
    80000ee6:	0385ba83          	ld	s5,56(a1)
    80000eea:	0405bb03          	ld	s6,64(a1)
    80000eee:	0485bb83          	ld	s7,72(a1)
    80000ef2:	0505bc03          	ld	s8,80(a1)
    80000ef6:	0585bc83          	ld	s9,88(a1)
    80000efa:	0605bd03          	ld	s10,96(a1)
    80000efe:	0685bd83          	ld	s11,104(a1)
    80000f02:	8082                	ret

0000000080000f04 <printint>:

static char digits[] = "0123456789ABCDEF";

static void
printint(int fd, int xx, int base, int sgn)
{
    80000f04:	7139                	addi	sp,sp,-64
    80000f06:	fc06                	sd	ra,56(sp)
    80000f08:	f822                	sd	s0,48(sp)
    80000f0a:	f426                	sd	s1,40(sp)
    80000f0c:	f04a                	sd	s2,32(sp)
    80000f0e:	ec4e                	sd	s3,24(sp)
    80000f10:	0080                	addi	s0,sp,64
    80000f12:	84aa                	mv	s1,a0
    char buf[16];
    int i, neg;
    uint x;

    neg = 0;
    if (sgn && xx < 0) {
    80000f14:	c299                	beqz	a3,80000f1a <printint+0x16>
    80000f16:	0805c863          	bltz	a1,80000fa6 <printint+0xa2>
        neg = 1;
        x = -xx;
    } else {
        x = xx;
    80000f1a:	2581                	sext.w	a1,a1
    neg = 0;
    80000f1c:	4881                	li	a7,0
    80000f1e:	fc040693          	addi	a3,s0,-64
    }

    i = 0;
    80000f22:	4701                	li	a4,0
    do {
        buf[i++] = digits[x % base];
    80000f24:	2601                	sext.w	a2,a2
    80000f26:	00004517          	auipc	a0,0x4
    80000f2a:	1c250513          	addi	a0,a0,450 # 800050e8 <digits>
    80000f2e:	883a                	mv	a6,a4
    80000f30:	2705                	addiw	a4,a4,1
    80000f32:	02c5f7bb          	remuw	a5,a1,a2
    80000f36:	1782                	slli	a5,a5,0x20
    80000f38:	9381                	srli	a5,a5,0x20
    80000f3a:	97aa                	add	a5,a5,a0
    80000f3c:	0007c783          	lbu	a5,0(a5)
    80000f40:	00f68023          	sb	a5,0(a3)
    } while ((x /= base) != 0);
    80000f44:	0005879b          	sext.w	a5,a1
    80000f48:	02c5d5bb          	divuw	a1,a1,a2
    80000f4c:	0685                	addi	a3,a3,1
    80000f4e:	fec7f0e3          	bgeu	a5,a2,80000f2e <printint+0x2a>
    if (neg)
    80000f52:	00088b63          	beqz	a7,80000f68 <printint+0x64>
        buf[i++] = '-';
    80000f56:	fd040793          	addi	a5,s0,-48
    80000f5a:	973e                	add	a4,a4,a5
    80000f5c:	02d00793          	li	a5,45
    80000f60:	fef70823          	sb	a5,-16(a4)
    80000f64:	0028071b          	addiw	a4,a6,2

    while (--i >= 0)
    80000f68:	02e05863          	blez	a4,80000f98 <printint+0x94>
    80000f6c:	fc040793          	addi	a5,s0,-64
    80000f70:	00e78933          	add	s2,a5,a4
    80000f74:	fff78993          	addi	s3,a5,-1
    80000f78:	99ba                	add	s3,s3,a4
    80000f7a:	377d                	addiw	a4,a4,-1
    80000f7c:	1702                	slli	a4,a4,0x20
    80000f7e:	9301                	srli	a4,a4,0x20
    80000f80:	40e989b3          	sub	s3,s3,a4
        putc(fd, buf[i]);
    80000f84:	fff94583          	lbu	a1,-1(s2)
    80000f88:	8526                	mv	a0,s1
    80000f8a:	fffff097          	auipc	ra,0xfffff
    80000f8e:	2c2080e7          	jalr	706(ra) # 8000024c <putc>
    while (--i >= 0)
    80000f92:	197d                	addi	s2,s2,-1
    80000f94:	ff3918e3          	bne	s2,s3,80000f84 <printint+0x80>
}
    80000f98:	70e2                	ld	ra,56(sp)
    80000f9a:	7442                	ld	s0,48(sp)
    80000f9c:	74a2                	ld	s1,40(sp)
    80000f9e:	7902                	ld	s2,32(sp)
    80000fa0:	69e2                	ld	s3,24(sp)
    80000fa2:	6121                	addi	sp,sp,64
    80000fa4:	8082                	ret
        x = -xx;
    80000fa6:	40b005bb          	negw	a1,a1
        neg = 1;
    80000faa:	4885                	li	a7,1
        x = -xx;
    80000fac:	bf8d                	j	80000f1e <printint+0x1a>

0000000080000fae <vprintf>:
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char* fmt, va_list ap)
{
    80000fae:	7119                	addi	sp,sp,-128
    80000fb0:	fc86                	sd	ra,120(sp)
    80000fb2:	f8a2                	sd	s0,112(sp)
    80000fb4:	f4a6                	sd	s1,104(sp)
    80000fb6:	f0ca                	sd	s2,96(sp)
    80000fb8:	ecce                	sd	s3,88(sp)
    80000fba:	e8d2                	sd	s4,80(sp)
    80000fbc:	e4d6                	sd	s5,72(sp)
    80000fbe:	e0da                	sd	s6,64(sp)
    80000fc0:	fc5e                	sd	s7,56(sp)
    80000fc2:	f862                	sd	s8,48(sp)
    80000fc4:	f466                	sd	s9,40(sp)
    80000fc6:	f06a                	sd	s10,32(sp)
    80000fc8:	ec6e                	sd	s11,24(sp)
    80000fca:	0100                	addi	s0,sp,128
    char* s;
    int c, i, state;

    state = 0;
    for (i = 0; fmt[i]; i++) {
    80000fcc:	0005c903          	lbu	s2,0(a1)
    80000fd0:	18090f63          	beqz	s2,8000116e <vprintf+0x1c0>
    80000fd4:	8aaa                	mv	s5,a0
    80000fd6:	8b32                	mv	s6,a2
    80000fd8:	00158493          	addi	s1,a1,1
    state = 0;
    80000fdc:	4981                	li	s3,0
            if (c == '%') {
                state = '%';
            } else {
                putc(fd, c);
            }
        } else if (state == '%') {
    80000fde:	02500a13          	li	s4,37
            if (c == 'd') {
    80000fe2:	06400c13          	li	s8,100
                printint(fd, va_arg(ap, int), 10, 1);
            } else if (c == 'l') {
    80000fe6:	06c00c93          	li	s9,108
                printint(fd, va_arg(ap, uint64), 10, 0);
            } else if (c == 'x') {
    80000fea:	07800d13          	li	s10,120
                printint(fd, va_arg(ap, int), 16, 0);
            } else if (c == 'p') {
    80000fee:	07000d93          	li	s11,112
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000ff2:	00004b97          	auipc	s7,0x4
    80000ff6:	0f6b8b93          	addi	s7,s7,246 # 800050e8 <digits>
    80000ffa:	a839                	j	80001018 <vprintf+0x6a>
                putc(fd, c);
    80000ffc:	85ca                	mv	a1,s2
    80000ffe:	8556                	mv	a0,s5
    80001000:	fffff097          	auipc	ra,0xfffff
    80001004:	24c080e7          	jalr	588(ra) # 8000024c <putc>
    80001008:	a019                	j	8000100e <vprintf+0x60>
        } else if (state == '%') {
    8000100a:	01498f63          	beq	s3,s4,80001028 <vprintf+0x7a>
    for (i = 0; fmt[i]; i++) {
    8000100e:	0485                	addi	s1,s1,1
    80001010:	fff4c903          	lbu	s2,-1(s1)
    80001014:	14090d63          	beqz	s2,8000116e <vprintf+0x1c0>
        c = fmt[i] & 0xff;
    80001018:	0009079b          	sext.w	a5,s2
        if (state == 0) {
    8000101c:	fe0997e3          	bnez	s3,8000100a <vprintf+0x5c>
            if (c == '%') {
    80001020:	fd479ee3          	bne	a5,s4,80000ffc <vprintf+0x4e>
                state = '%';
    80001024:	89be                	mv	s3,a5
    80001026:	b7e5                	j	8000100e <vprintf+0x60>
            if (c == 'd') {
    80001028:	05878063          	beq	a5,s8,80001068 <vprintf+0xba>
            } else if (c == 'l') {
    8000102c:	05978c63          	beq	a5,s9,80001084 <vprintf+0xd6>
            } else if (c == 'x') {
    80001030:	07a78863          	beq	a5,s10,800010a0 <vprintf+0xf2>
            } else if (c == 'p') {
    80001034:	09b78463          	beq	a5,s11,800010bc <vprintf+0x10e>
                printptr(fd, va_arg(ap, uint64));
            } else if (c == 's') {
    80001038:	07300713          	li	a4,115
    8000103c:	0ce78663          	beq	a5,a4,80001108 <vprintf+0x15a>
                    s = "(null)";
                while (*s != 0) {
                    putc(fd, *s);
                    s++;
                }
            } else if (c == 'c') {
    80001040:	06300713          	li	a4,99
    80001044:	0ee78e63          	beq	a5,a4,80001140 <vprintf+0x192>
                putc(fd, va_arg(ap, uint));
            } else if (c == '%') {
    80001048:	11478863          	beq	a5,s4,80001158 <vprintf+0x1aa>
                putc(fd, c);
            } else {
                // Unknown % sequence.  Print it to draw attention.
                putc(fd, '%');
    8000104c:	85d2                	mv	a1,s4
    8000104e:	8556                	mv	a0,s5
    80001050:	fffff097          	auipc	ra,0xfffff
    80001054:	1fc080e7          	jalr	508(ra) # 8000024c <putc>
                putc(fd, c);
    80001058:	85ca                	mv	a1,s2
    8000105a:	8556                	mv	a0,s5
    8000105c:	fffff097          	auipc	ra,0xfffff
    80001060:	1f0080e7          	jalr	496(ra) # 8000024c <putc>
            }
            state = 0;
    80001064:	4981                	li	s3,0
    80001066:	b765                	j	8000100e <vprintf+0x60>
                printint(fd, va_arg(ap, int), 10, 1);
    80001068:	008b0913          	addi	s2,s6,8
    8000106c:	4685                	li	a3,1
    8000106e:	4629                	li	a2,10
    80001070:	000b2583          	lw	a1,0(s6)
    80001074:	8556                	mv	a0,s5
    80001076:	00000097          	auipc	ra,0x0
    8000107a:	e8e080e7          	jalr	-370(ra) # 80000f04 <printint>
    8000107e:	8b4a                	mv	s6,s2
            state = 0;
    80001080:	4981                	li	s3,0
    80001082:	b771                	j	8000100e <vprintf+0x60>
                printint(fd, va_arg(ap, uint64), 10, 0);
    80001084:	008b0913          	addi	s2,s6,8
    80001088:	4681                	li	a3,0
    8000108a:	4629                	li	a2,10
    8000108c:	000b2583          	lw	a1,0(s6)
    80001090:	8556                	mv	a0,s5
    80001092:	00000097          	auipc	ra,0x0
    80001096:	e72080e7          	jalr	-398(ra) # 80000f04 <printint>
    8000109a:	8b4a                	mv	s6,s2
            state = 0;
    8000109c:	4981                	li	s3,0
    8000109e:	bf85                	j	8000100e <vprintf+0x60>
                printint(fd, va_arg(ap, int), 16, 0);
    800010a0:	008b0913          	addi	s2,s6,8
    800010a4:	4681                	li	a3,0
    800010a6:	4641                	li	a2,16
    800010a8:	000b2583          	lw	a1,0(s6)
    800010ac:	8556                	mv	a0,s5
    800010ae:	00000097          	auipc	ra,0x0
    800010b2:	e56080e7          	jalr	-426(ra) # 80000f04 <printint>
    800010b6:	8b4a                	mv	s6,s2
            state = 0;
    800010b8:	4981                	li	s3,0
    800010ba:	bf91                	j	8000100e <vprintf+0x60>
                printptr(fd, va_arg(ap, uint64));
    800010bc:	008b0793          	addi	a5,s6,8
    800010c0:	f8f43423          	sd	a5,-120(s0)
    800010c4:	000b3983          	ld	s3,0(s6)
    putc(fd, '0');
    800010c8:	03000593          	li	a1,48
    800010cc:	8556                	mv	a0,s5
    800010ce:	fffff097          	auipc	ra,0xfffff
    800010d2:	17e080e7          	jalr	382(ra) # 8000024c <putc>
    putc(fd, 'x');
    800010d6:	85ea                	mv	a1,s10
    800010d8:	8556                	mv	a0,s5
    800010da:	fffff097          	auipc	ra,0xfffff
    800010de:	172080e7          	jalr	370(ra) # 8000024c <putc>
    800010e2:	4941                	li	s2,16
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    800010e4:	03c9d793          	srli	a5,s3,0x3c
    800010e8:	97de                	add	a5,a5,s7
    800010ea:	0007c583          	lbu	a1,0(a5)
    800010ee:	8556                	mv	a0,s5
    800010f0:	fffff097          	auipc	ra,0xfffff
    800010f4:	15c080e7          	jalr	348(ra) # 8000024c <putc>
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800010f8:	0992                	slli	s3,s3,0x4
    800010fa:	397d                	addiw	s2,s2,-1
    800010fc:	fe0914e3          	bnez	s2,800010e4 <vprintf+0x136>
                printptr(fd, va_arg(ap, uint64));
    80001100:	f8843b03          	ld	s6,-120(s0)
            state = 0;
    80001104:	4981                	li	s3,0
    80001106:	b721                	j	8000100e <vprintf+0x60>
                s = va_arg(ap, char*);
    80001108:	008b0993          	addi	s3,s6,8
    8000110c:	000b3903          	ld	s2,0(s6)
                if (s == 0)
    80001110:	02090163          	beqz	s2,80001132 <vprintf+0x184>
                while (*s != 0) {
    80001114:	00094583          	lbu	a1,0(s2)
    80001118:	c9a1                	beqz	a1,80001168 <vprintf+0x1ba>
                    putc(fd, *s);
    8000111a:	8556                	mv	a0,s5
    8000111c:	fffff097          	auipc	ra,0xfffff
    80001120:	130080e7          	jalr	304(ra) # 8000024c <putc>
                    s++;
    80001124:	0905                	addi	s2,s2,1
                while (*s != 0) {
    80001126:	00094583          	lbu	a1,0(s2)
    8000112a:	f9e5                	bnez	a1,8000111a <vprintf+0x16c>
                s = va_arg(ap, char*);
    8000112c:	8b4e                	mv	s6,s3
            state = 0;
    8000112e:	4981                	li	s3,0
    80001130:	bdf9                	j	8000100e <vprintf+0x60>
                    s = "(null)";
    80001132:	00004917          	auipc	s2,0x4
    80001136:	f7e90913          	addi	s2,s2,-130 # 800050b0 <etext+0xb0>
                while (*s != 0) {
    8000113a:	02800593          	li	a1,40
    8000113e:	bff1                	j	8000111a <vprintf+0x16c>
                putc(fd, va_arg(ap, uint));
    80001140:	008b0913          	addi	s2,s6,8
    80001144:	000b4583          	lbu	a1,0(s6)
    80001148:	8556                	mv	a0,s5
    8000114a:	fffff097          	auipc	ra,0xfffff
    8000114e:	102080e7          	jalr	258(ra) # 8000024c <putc>
    80001152:	8b4a                	mv	s6,s2
            state = 0;
    80001154:	4981                	li	s3,0
    80001156:	bd65                	j	8000100e <vprintf+0x60>
                putc(fd, c);
    80001158:	85d2                	mv	a1,s4
    8000115a:	8556                	mv	a0,s5
    8000115c:	fffff097          	auipc	ra,0xfffff
    80001160:	0f0080e7          	jalr	240(ra) # 8000024c <putc>
            state = 0;
    80001164:	4981                	li	s3,0
    80001166:	b565                	j	8000100e <vprintf+0x60>
                s = va_arg(ap, char*);
    80001168:	8b4e                	mv	s6,s3
            state = 0;
    8000116a:	4981                	li	s3,0
    8000116c:	b54d                	j	8000100e <vprintf+0x60>
        }
    }
}
    8000116e:	70e6                	ld	ra,120(sp)
    80001170:	7446                	ld	s0,112(sp)
    80001172:	74a6                	ld	s1,104(sp)
    80001174:	7906                	ld	s2,96(sp)
    80001176:	69e6                	ld	s3,88(sp)
    80001178:	6a46                	ld	s4,80(sp)
    8000117a:	6aa6                	ld	s5,72(sp)
    8000117c:	6b06                	ld	s6,64(sp)
    8000117e:	7be2                	ld	s7,56(sp)
    80001180:	7c42                	ld	s8,48(sp)
    80001182:	7ca2                	ld	s9,40(sp)
    80001184:	7d02                	ld	s10,32(sp)
    80001186:	6de2                	ld	s11,24(sp)
    80001188:	6109                	addi	sp,sp,128
    8000118a:	8082                	ret

000000008000118c <fprintf>:

void fprintf(int fd, const char* fmt, ...)
{
    8000118c:	715d                	addi	sp,sp,-80
    8000118e:	ec06                	sd	ra,24(sp)
    80001190:	e822                	sd	s0,16(sp)
    80001192:	1000                	addi	s0,sp,32
    80001194:	e010                	sd	a2,0(s0)
    80001196:	e414                	sd	a3,8(s0)
    80001198:	e818                	sd	a4,16(s0)
    8000119a:	ec1c                	sd	a5,24(s0)
    8000119c:	03043023          	sd	a6,32(s0)
    800011a0:	03143423          	sd	a7,40(s0)
    va_list ap;

    va_start(ap, fmt);
    800011a4:	fe843423          	sd	s0,-24(s0)
    vprintf(fd, fmt, ap);
    800011a8:	8622                	mv	a2,s0
    800011aa:	00000097          	auipc	ra,0x0
    800011ae:	e04080e7          	jalr	-508(ra) # 80000fae <vprintf>
}
    800011b2:	60e2                	ld	ra,24(sp)
    800011b4:	6442                	ld	s0,16(sp)
    800011b6:	6161                	addi	sp,sp,80
    800011b8:	8082                	ret

00000000800011ba <printf>:

void printf(const char* fmt, ...)
{
    800011ba:	711d                	addi	sp,sp,-96
    800011bc:	ec06                	sd	ra,24(sp)
    800011be:	e822                	sd	s0,16(sp)
    800011c0:	1000                	addi	s0,sp,32
    800011c2:	e40c                	sd	a1,8(s0)
    800011c4:	e810                	sd	a2,16(s0)
    800011c6:	ec14                	sd	a3,24(s0)
    800011c8:	f018                	sd	a4,32(s0)
    800011ca:	f41c                	sd	a5,40(s0)
    800011cc:	03043823          	sd	a6,48(s0)
    800011d0:	03143c23          	sd	a7,56(s0)
    va_list ap;

    va_start(ap, fmt);
    800011d4:	00840613          	addi	a2,s0,8
    800011d8:	fec43423          	sd	a2,-24(s0)
    vprintf(1, fmt, ap);
    800011dc:	85aa                	mv	a1,a0
    800011de:	4505                	li	a0,1
    800011e0:	00000097          	auipc	ra,0x0
    800011e4:	dce080e7          	jalr	-562(ra) # 80000fae <vprintf>
}
    800011e8:	60e2                	ld	ra,24(sp)
    800011ea:	6442                	ld	s0,16(sp)
    800011ec:	6125                	addi	sp,sp,96
    800011ee:	8082                	ret

00000000800011f0 <puts>:

void puts(const char* str)
{
    800011f0:	1141                	addi	sp,sp,-16
    800011f2:	e406                	sd	ra,8(sp)
    800011f4:	e022                	sd	s0,0(sp)
    800011f6:	0800                	addi	s0,sp,16
    800011f8:	85aa                	mv	a1,a0
    printf("%s\n", str);
    800011fa:	00004517          	auipc	a0,0x4
    800011fe:	ebe50513          	addi	a0,a0,-322 # 800050b8 <etext+0xb8>
    80001202:	00000097          	auipc	ra,0x0
    80001206:	fb8080e7          	jalr	-72(ra) # 800011ba <printf>
}
    8000120a:	60a2                	ld	ra,8(sp)
    8000120c:	6402                	ld	s0,0(sp)
    8000120e:	0141                	addi	sp,sp,16
    80001210:	8082                	ret

0000000080001212 <backtrace>:

void backtrace()
{
    80001212:	7179                	addi	sp,sp,-48
    80001214:	f406                	sd	ra,40(sp)
    80001216:	f022                	sd	s0,32(sp)
    80001218:	ec26                	sd	s1,24(sp)
    8000121a:	e84a                	sd	s2,16(sp)
    8000121c:	e44e                	sd	s3,8(sp)
    8000121e:	e052                	sd	s4,0(sp)
    80001220:	1800                	addi	s0,sp,48
    asm volatile("mv %0, s0" : "=r" (x) );
    80001222:	84a2                	mv	s1,s0
    uint64 s0 = r_fp();
    uint64 stack_top = PGROUNDUP(s0);
    80001224:	6905                	lui	s2,0x1
    80001226:	197d                	addi	s2,s2,-1
    80001228:	9926                	add	s2,s2,s1
    8000122a:	79fd                	lui	s3,0xfffff
    8000122c:	01397933          	and	s2,s2,s3
    uint64 stack_bottom = PGROUNDDOWN(s0);
    80001230:	0134f9b3          	and	s3,s1,s3
    uint64 fp = s0;

    printf("backtrace:\n");
    80001234:	00004517          	auipc	a0,0x4
    80001238:	e8c50513          	addi	a0,a0,-372 # 800050c0 <etext+0xc0>
    8000123c:	00000097          	auipc	ra,0x0
    80001240:	f7e080e7          	jalr	-130(ra) # 800011ba <printf>
    while (fp != stack_top && fp != stack_bottom)
    80001244:	02990563          	beq	s2,s1,8000126e <backtrace+0x5c>
    80001248:	02998363          	beq	s3,s1,8000126e <backtrace+0x5c>
    {
        printf("%p\n", *(uint64*)(fp - 8));
    8000124c:	00004a17          	auipc	s4,0x4
    80001250:	e84a0a13          	addi	s4,s4,-380 # 800050d0 <etext+0xd0>
    80001254:	ff84b583          	ld	a1,-8(s1)
    80001258:	8552                	mv	a0,s4
    8000125a:	00000097          	auipc	ra,0x0
    8000125e:	f60080e7          	jalr	-160(ra) # 800011ba <printf>
        fp = *(uint64*)(fp - 16);
    80001262:	ff04b483          	ld	s1,-16(s1)
    while (fp != stack_top && fp != stack_bottom)
    80001266:	00990463          	beq	s2,s1,8000126e <backtrace+0x5c>
    8000126a:	fe9995e3          	bne	s3,s1,80001254 <backtrace+0x42>
    }
}
    8000126e:	70a2                	ld	ra,40(sp)
    80001270:	7402                	ld	s0,32(sp)
    80001272:	64e2                	ld	s1,24(sp)
    80001274:	6942                	ld	s2,16(sp)
    80001276:	69a2                	ld	s3,8(sp)
    80001278:	6a02                	ld	s4,0(sp)
    8000127a:	6145                	addi	sp,sp,48
    8000127c:	8082                	ret

000000008000127e <panic>:

void panic(char* s)
{
    8000127e:	1141                	addi	sp,sp,-16
    80001280:	e406                	sd	ra,8(sp)
    80001282:	e022                	sd	s0,0(sp)
    80001284:	0800                	addi	s0,sp,16
    80001286:	85aa                	mv	a1,a0
    printf("panic:%s", s);
    80001288:	00004517          	auipc	a0,0x4
    8000128c:	e5050513          	addi	a0,a0,-432 # 800050d8 <etext+0xd8>
    80001290:	00000097          	auipc	ra,0x0
    80001294:	f2a080e7          	jalr	-214(ra) # 800011ba <printf>
    backtrace();
    80001298:	00000097          	auipc	ra,0x0
    8000129c:	f7a080e7          	jalr	-134(ra) # 80001212 <backtrace>
    for (;;) {
    800012a0:	a001                	j	800012a0 <panic+0x22>

00000000800012a2 <kfree>:
}


// 释放一页pa指向的物理空间
void kfree(void *pa)
{
    800012a2:	1101                	addi	sp,sp,-32
    800012a4:	ec06                	sd	ra,24(sp)
    800012a6:	e822                	sd	s0,16(sp)
    800012a8:	e426                	sd	s1,8(sp)
    800012aa:	e04a                	sd	s2,0(sp)
    800012ac:	1000                	addi	s0,sp,32
    800012ae:	84aa                	mv	s1,a0
    struct node *r;

    if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800012b0:	03451793          	slli	a5,a0,0x34
    800012b4:	eb99                	bnez	a5,800012ca <kfree+0x28>
    800012b6:	0006a797          	auipc	a5,0x6a
    800012ba:	77a78793          	addi	a5,a5,1914 # 8006ba30 <end>
    800012be:	00f56663          	bltu	a0,a5,800012ca <kfree+0x28>
    800012c2:	47c5                	li	a5,17
    800012c4:	07ee                	slli	a5,a5,0x1b
    800012c6:	00f56a63          	bltu	a0,a5,800012da <kfree+0x38>
        panic("kfree");
    800012ca:	00004517          	auipc	a0,0x4
    800012ce:	e3650513          	addi	a0,a0,-458 # 80005100 <digits+0x18>
    800012d2:	00000097          	auipc	ra,0x0
    800012d6:	fac080e7          	jalr	-84(ra) # 8000127e <panic>

    // 填充无效值
    memset(pa, 1, PGSIZE);
    800012da:	6605                	lui	a2,0x1
    800012dc:	4585                	li	a1,1
    800012de:	8526                	mv	a0,s1
    800012e0:	00000097          	auipc	ra,0x0
    800012e4:	a4c080e7          	jalr	-1460(ra) # 80000d2c <memset>

    r = (struct node*)pa;

    spin_lock(&kmem.lock);
    800012e8:	0004b917          	auipc	s2,0x4b
    800012ec:	ba090913          	addi	s2,s2,-1120 # 8004be88 <kmem>
    800012f0:	854a                	mv	a0,s2
    800012f2:	00002097          	auipc	ra,0x2
    800012f6:	f5a080e7          	jalr	-166(ra) # 8000324c <spin_lock>
    r->next = kmem.freelist;
    800012fa:	01893783          	ld	a5,24(s2)
    800012fe:	e09c                	sd	a5,0(s1)
    kmem.freelist = r;
    80001300:	00993c23          	sd	s1,24(s2)
    spin_unlock(&kmem.lock);
    80001304:	854a                	mv	a0,s2
    80001306:	00002097          	auipc	ra,0x2
    8000130a:	01a080e7          	jalr	26(ra) # 80003320 <spin_unlock>
}
    8000130e:	60e2                	ld	ra,24(sp)
    80001310:	6442                	ld	s0,16(sp)
    80001312:	64a2                	ld	s1,8(sp)
    80001314:	6902                	ld	s2,0(sp)
    80001316:	6105                	addi	sp,sp,32
    80001318:	8082                	ret

000000008000131a <free_range>:
{
    8000131a:	7179                	addi	sp,sp,-48
    8000131c:	f406                	sd	ra,40(sp)
    8000131e:	f022                	sd	s0,32(sp)
    80001320:	ec26                	sd	s1,24(sp)
    80001322:	e84a                	sd	s2,16(sp)
    80001324:	e44e                	sd	s3,8(sp)
    80001326:	e052                	sd	s4,0(sp)
    80001328:	1800                	addi	s0,sp,48
    p = (char*)PGROUNDUP((uint64)pa_start);
    8000132a:	6785                	lui	a5,0x1
    8000132c:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80001330:	94aa                	add	s1,s1,a0
    80001332:	757d                	lui	a0,0xfffff
    80001334:	8ce9                	and	s1,s1,a0
    for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80001336:	94be                	add	s1,s1,a5
    80001338:	0095ee63          	bltu	a1,s1,80001354 <free_range+0x3a>
    8000133c:	892e                	mv	s2,a1
        kfree(p);
    8000133e:	7a7d                	lui	s4,0xfffff
    for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80001340:	6985                	lui	s3,0x1
        kfree(p);
    80001342:	01448533          	add	a0,s1,s4
    80001346:	00000097          	auipc	ra,0x0
    8000134a:	f5c080e7          	jalr	-164(ra) # 800012a2 <kfree>
    for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000134e:	94ce                	add	s1,s1,s3
    80001350:	fe9979e3          	bgeu	s2,s1,80001342 <free_range+0x28>
}
    80001354:	70a2                	ld	ra,40(sp)
    80001356:	7402                	ld	s0,32(sp)
    80001358:	64e2                	ld	s1,24(sp)
    8000135a:	6942                	ld	s2,16(sp)
    8000135c:	69a2                	ld	s3,8(sp)
    8000135e:	6a02                	ld	s4,0(sp)
    80001360:	6145                	addi	sp,sp,48
    80001362:	8082                	ret

0000000080001364 <kernel_mem_init>:
{
    80001364:	1141                	addi	sp,sp,-16
    80001366:	e406                	sd	ra,8(sp)
    80001368:	e022                	sd	s0,0(sp)
    8000136a:	0800                	addi	s0,sp,16
    spinlock_init(&kmem.lock, "kmem");
    8000136c:	00004597          	auipc	a1,0x4
    80001370:	d9c58593          	addi	a1,a1,-612 # 80005108 <digits+0x20>
    80001374:	0004b517          	auipc	a0,0x4b
    80001378:	b1450513          	addi	a0,a0,-1260 # 8004be88 <kmem>
    8000137c:	00002097          	auipc	ra,0x2
    80001380:	e40080e7          	jalr	-448(ra) # 800031bc <spinlock_init>
    free_range(end, (void*)PHYSTOP);
    80001384:	45c5                	li	a1,17
    80001386:	05ee                	slli	a1,a1,0x1b
    80001388:	0006a517          	auipc	a0,0x6a
    8000138c:	6a850513          	addi	a0,a0,1704 # 8006ba30 <end>
    80001390:	00000097          	auipc	ra,0x0
    80001394:	f8a080e7          	jalr	-118(ra) # 8000131a <free_range>
}
    80001398:	60a2                	ld	ra,8(sp)
    8000139a:	6402                	ld	s0,0(sp)
    8000139c:	0141                	addi	sp,sp,16
    8000139e:	8082                	ret

00000000800013a0 <kalloc>:

// 分配一个4096字节的物理页，返回内核能够使用的指针, 如果
// 内存耗尽会返回0。
void * kalloc(void)
{
    800013a0:	1101                	addi	sp,sp,-32
    800013a2:	ec06                	sd	ra,24(sp)
    800013a4:	e822                	sd	s0,16(sp)
    800013a6:	e426                	sd	s1,8(sp)
    800013a8:	1000                	addi	s0,sp,32
    struct node *r;

    spin_lock(&kmem.lock);
    800013aa:	0004b497          	auipc	s1,0x4b
    800013ae:	ade48493          	addi	s1,s1,-1314 # 8004be88 <kmem>
    800013b2:	8526                	mv	a0,s1
    800013b4:	00002097          	auipc	ra,0x2
    800013b8:	e98080e7          	jalr	-360(ra) # 8000324c <spin_lock>
    r = kmem.freelist;
    800013bc:	6c84                	ld	s1,24(s1)
    if(r)
    800013be:	c885                	beqz	s1,800013ee <kalloc+0x4e>
        kmem.freelist = r->next;
    800013c0:	609c                	ld	a5,0(s1)
    800013c2:	0004b517          	auipc	a0,0x4b
    800013c6:	ac650513          	addi	a0,a0,-1338 # 8004be88 <kmem>
    800013ca:	ed1c                	sd	a5,24(a0)
    spin_unlock(&kmem.lock);
    800013cc:	00002097          	auipc	ra,0x2
    800013d0:	f54080e7          	jalr	-172(ra) # 80003320 <spin_unlock>

    if(r)
        memset((char*)r, 5, PGSIZE); // fill with junk
    800013d4:	6605                	lui	a2,0x1
    800013d6:	4595                	li	a1,5
    800013d8:	8526                	mv	a0,s1
    800013da:	00000097          	auipc	ra,0x0
    800013de:	952080e7          	jalr	-1710(ra) # 80000d2c <memset>
    return (void*)r;
}
    800013e2:	8526                	mv	a0,s1
    800013e4:	60e2                	ld	ra,24(sp)
    800013e6:	6442                	ld	s0,16(sp)
    800013e8:	64a2                	ld	s1,8(sp)
    800013ea:	6105                	addi	sp,sp,32
    800013ec:	8082                	ret
    spin_unlock(&kmem.lock);
    800013ee:	0004b517          	auipc	a0,0x4b
    800013f2:	a9a50513          	addi	a0,a0,-1382 # 8004be88 <kmem>
    800013f6:	00002097          	auipc	ra,0x2
    800013fa:	f2a080e7          	jalr	-214(ra) # 80003320 <spin_unlock>
    if(r)
    800013fe:	b7d5                	j	800013e2 <kalloc+0x42>

0000000080001400 <vm_hart_init>:
}

/**
 * 切换页表寄存器为内核页表并启用分页
 */
void vm_hart_init() {
    80001400:	1141                	addi	sp,sp,-16
    80001402:	e422                	sd	s0,8(sp)
    80001404:	0800                	addi	s0,sp,16
    w_satp(MAKE_SATP(kernel_pagetable));
    80001406:	00005797          	auipc	a5,0x5
    8000140a:	c027b783          	ld	a5,-1022(a5) # 80006008 <kernel_pagetable>
    8000140e:	83b1                	srli	a5,a5,0xc
    80001410:	577d                	li	a4,-1
    80001412:	177e                	slli	a4,a4,0x3f
    80001414:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80001416:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000141a:	12000073          	sfence.vma
    sfence_vma();
}
    8000141e:	6422                	ld	s0,8(sp)
    80001420:	0141                	addi	sp,sp,16
    80001422:	8082                	ret

0000000080001424 <walk>:
 * @param pagetable 页表
 * @param va 需要查找PTE的va
 * @param alloc 是否创建缺失的页表
 * @return
 */
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc) {
    80001424:	7139                	addi	sp,sp,-64
    80001426:	fc06                	sd	ra,56(sp)
    80001428:	f822                	sd	s0,48(sp)
    8000142a:	f426                	sd	s1,40(sp)
    8000142c:	f04a                	sd	s2,32(sp)
    8000142e:	ec4e                	sd	s3,24(sp)
    80001430:	e852                	sd	s4,16(sp)
    80001432:	e456                	sd	s5,8(sp)
    80001434:	e05a                	sd	s6,0(sp)
    80001436:	0080                	addi	s0,sp,64
    80001438:	84aa                	mv	s1,a0
    8000143a:	89ae                	mv	s3,a1
    8000143c:	8ab2                	mv	s5,a2
    if (va >= MAXVA)
    8000143e:	57fd                	li	a5,-1
    80001440:	83e9                	srli	a5,a5,0x1a
    80001442:	00b7e563          	bltu	a5,a1,8000144c <walk+0x28>
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc) {
    80001446:	4a79                	li	s4,30
        panic("walk");
    for (int level = 2; level > 0; level--) {
    80001448:	4b31                	li	s6,12
    8000144a:	a091                	j	8000148e <walk+0x6a>
        panic("walk");
    8000144c:	00004517          	auipc	a0,0x4
    80001450:	cc450513          	addi	a0,a0,-828 # 80005110 <digits+0x28>
    80001454:	00000097          	auipc	ra,0x0
    80001458:	e2a080e7          	jalr	-470(ra) # 8000127e <panic>
    8000145c:	b7ed                	j	80001446 <walk+0x22>
        pte_t *pte = &pagetable[PX(level, va)];
        if (*pte & PTE_V) {
            pagetable = (pagetable_t) PTE2PA(*pte);
        } else {
            if (!alloc || (pagetable = (pte_t *) kalloc()) == 0)
    8000145e:	060a8663          	beqz	s5,800014ca <walk+0xa6>
    80001462:	00000097          	auipc	ra,0x0
    80001466:	f3e080e7          	jalr	-194(ra) # 800013a0 <kalloc>
    8000146a:	84aa                	mv	s1,a0
    8000146c:	c529                	beqz	a0,800014b6 <walk+0x92>
                return 0;
            memset(pagetable, 0, PGSIZE);
    8000146e:	6605                	lui	a2,0x1
    80001470:	4581                	li	a1,0
    80001472:	00000097          	auipc	ra,0x0
    80001476:	8ba080e7          	jalr	-1862(ra) # 80000d2c <memset>
            *pte = PA2PTE(pagetable) | PTE_V;
    8000147a:	00c4d793          	srli	a5,s1,0xc
    8000147e:	07aa                	slli	a5,a5,0xa
    80001480:	0017e793          	ori	a5,a5,1
    80001484:	00f93023          	sd	a5,0(s2)
    for (int level = 2; level > 0; level--) {
    80001488:	3a5d                	addiw	s4,s4,-9
    8000148a:	036a0063          	beq	s4,s6,800014aa <walk+0x86>
        pte_t *pte = &pagetable[PX(level, va)];
    8000148e:	0149d933          	srl	s2,s3,s4
    80001492:	1ff97913          	andi	s2,s2,511
    80001496:	090e                	slli	s2,s2,0x3
    80001498:	9926                	add	s2,s2,s1
        if (*pte & PTE_V) {
    8000149a:	00093483          	ld	s1,0(s2)
    8000149e:	0014f793          	andi	a5,s1,1
    800014a2:	dfd5                	beqz	a5,8000145e <walk+0x3a>
            pagetable = (pagetable_t) PTE2PA(*pte);
    800014a4:	80a9                	srli	s1,s1,0xa
    800014a6:	04b2                	slli	s1,s1,0xc
    800014a8:	b7c5                	j	80001488 <walk+0x64>
        }
    }
    return &pagetable[PX(0, va)];
    800014aa:	00c9d513          	srli	a0,s3,0xc
    800014ae:	1ff57513          	andi	a0,a0,511
    800014b2:	050e                	slli	a0,a0,0x3
    800014b4:	9526                	add	a0,a0,s1
}
    800014b6:	70e2                	ld	ra,56(sp)
    800014b8:	7442                	ld	s0,48(sp)
    800014ba:	74a2                	ld	s1,40(sp)
    800014bc:	7902                	ld	s2,32(sp)
    800014be:	69e2                	ld	s3,24(sp)
    800014c0:	6a42                	ld	s4,16(sp)
    800014c2:	6aa2                	ld	s5,8(sp)
    800014c4:	6b02                	ld	s6,0(sp)
    800014c6:	6121                	addi	sp,sp,64
    800014c8:	8082                	ret
                return 0;
    800014ca:	4501                	li	a0,0
    800014cc:	b7ed                	j	800014b6 <walk+0x92>

00000000800014ce <mappages>:
 * @param va 虚拟地址起始地址
 * @param sz 要映射地址的大小
 * @param pa 物理地址的起始地址
 * @param perm PTE的权限
*/
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm) {
    800014ce:	711d                	addi	sp,sp,-96
    800014d0:	ec86                	sd	ra,88(sp)
    800014d2:	e8a2                	sd	s0,80(sp)
    800014d4:	e4a6                	sd	s1,72(sp)
    800014d6:	e0ca                	sd	s2,64(sp)
    800014d8:	fc4e                	sd	s3,56(sp)
    800014da:	f852                	sd	s4,48(sp)
    800014dc:	f456                	sd	s5,40(sp)
    800014de:	f05a                	sd	s6,32(sp)
    800014e0:	ec5e                	sd	s7,24(sp)
    800014e2:	e862                	sd	s8,16(sp)
    800014e4:	e466                	sd	s9,8(sp)
    800014e6:	1080                	addi	s0,sp,96
    800014e8:	8b2a                	mv	s6,a0
    800014ea:	8bba                	mv	s7,a4
    uint64 a, last;
    pte_t *pte;

    a = PGROUNDDOWN(va);
    800014ec:	777d                	lui	a4,0xfffff
    800014ee:	00e5f7b3          	and	a5,a1,a4
    last = PGROUNDDOWN(va + size - 1);
    800014f2:	167d                	addi	a2,a2,-1
    800014f4:	00b60a33          	add	s4,a2,a1
    800014f8:	00ea7a33          	and	s4,s4,a4
    a = PGROUNDDOWN(va);
    800014fc:	89be                	mv	s3,a5
    800014fe:	40f68ab3          	sub	s5,a3,a5
    for (;;) {
        if ((pte = walk(pagetable, a, 1)) == 0)
            return -1;
        if (*pte & PTE_V)
            panic("remap");
    80001502:	00004c97          	auipc	s9,0x4
    80001506:	c16c8c93          	addi	s9,s9,-1002 # 80005118 <digits+0x30>
        *pte = PA2PTE(pa) | perm | PTE_V;
        if (a == last) {
            break;
        }
        a += PGSIZE;
    8000150a:	6c05                	lui	s8,0x1
    8000150c:	a00d                	j	8000152e <mappages+0x60>
            panic("remap");
    8000150e:	8566                	mv	a0,s9
    80001510:	00000097          	auipc	ra,0x0
    80001514:	d6e080e7          	jalr	-658(ra) # 8000127e <panic>
        *pte = PA2PTE(pa) | perm | PTE_V;
    80001518:	80b1                	srli	s1,s1,0xc
    8000151a:	04aa                	slli	s1,s1,0xa
    8000151c:	0174e4b3          	or	s1,s1,s7
    80001520:	0014e493          	ori	s1,s1,1
    80001524:	00993023          	sd	s1,0(s2)
        if (a == last) {
    80001528:	05498063          	beq	s3,s4,80001568 <mappages+0x9a>
        a += PGSIZE;
    8000152c:	99e2                	add	s3,s3,s8
    for (;;) {
    8000152e:	013a84b3          	add	s1,s5,s3
        if ((pte = walk(pagetable, a, 1)) == 0)
    80001532:	4605                	li	a2,1
    80001534:	85ce                	mv	a1,s3
    80001536:	855a                	mv	a0,s6
    80001538:	00000097          	auipc	ra,0x0
    8000153c:	eec080e7          	jalr	-276(ra) # 80001424 <walk>
    80001540:	892a                	mv	s2,a0
    80001542:	c509                	beqz	a0,8000154c <mappages+0x7e>
        if (*pte & PTE_V)
    80001544:	611c                	ld	a5,0(a0)
    80001546:	8b85                	andi	a5,a5,1
    80001548:	dbe1                	beqz	a5,80001518 <mappages+0x4a>
    8000154a:	b7d1                	j	8000150e <mappages+0x40>
            return -1;
    8000154c:	557d                	li	a0,-1
        pa += PGSIZE;
    }
    return 0;
}
    8000154e:	60e6                	ld	ra,88(sp)
    80001550:	6446                	ld	s0,80(sp)
    80001552:	64a6                	ld	s1,72(sp)
    80001554:	6906                	ld	s2,64(sp)
    80001556:	79e2                	ld	s3,56(sp)
    80001558:	7a42                	ld	s4,48(sp)
    8000155a:	7aa2                	ld	s5,40(sp)
    8000155c:	7b02                	ld	s6,32(sp)
    8000155e:	6be2                	ld	s7,24(sp)
    80001560:	6c42                	ld	s8,16(sp)
    80001562:	6ca2                	ld	s9,8(sp)
    80001564:	6125                	addi	sp,sp,96
    80001566:	8082                	ret
    return 0;
    80001568:	4501                	li	a0,0
    8000156a:	b7d5                	j	8000154e <mappages+0x80>

000000008000156c <walkaddr>:
 */
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
    pte_t *pte;
    uint64 pa;

    if (va >= MAXVA)
    8000156c:	57fd                	li	a5,-1
    8000156e:	83e9                	srli	a5,a5,0x1a
    80001570:	00b7f463          	bgeu	a5,a1,80001578 <walkaddr+0xc>
        return 0;
    80001574:	4501                	li	a0,0
    // TODO 用户空间时修改
    if ((*pte & PTE_U) == 0)
        return 0;
    pa = PTE2PA(*pte);
    return pa;
}
    80001576:	8082                	ret
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
    80001578:	1141                	addi	sp,sp,-16
    8000157a:	e406                	sd	ra,8(sp)
    8000157c:	e022                	sd	s0,0(sp)
    8000157e:	0800                	addi	s0,sp,16
    pte = walk(pagetable, va, 0);
    80001580:	4601                	li	a2,0
    80001582:	00000097          	auipc	ra,0x0
    80001586:	ea2080e7          	jalr	-350(ra) # 80001424 <walk>
    if (pte == 0)
    8000158a:	c105                	beqz	a0,800015aa <walkaddr+0x3e>
    if ((*pte & PTE_V) == 0)
    8000158c:	611c                	ld	a5,0(a0)
    if ((*pte & PTE_U) == 0)
    8000158e:	0117f693          	andi	a3,a5,17
    80001592:	4745                	li	a4,17
        return 0;
    80001594:	4501                	li	a0,0
    if ((*pte & PTE_U) == 0)
    80001596:	00e68663          	beq	a3,a4,800015a2 <walkaddr+0x36>
}
    8000159a:	60a2                	ld	ra,8(sp)
    8000159c:	6402                	ld	s0,0(sp)
    8000159e:	0141                	addi	sp,sp,16
    800015a0:	8082                	ret
    pa = PTE2PA(*pte);
    800015a2:	00a7d513          	srli	a0,a5,0xa
    800015a6:	0532                	slli	a0,a0,0xc
    return pa;
    800015a8:	bfcd                	j	8000159a <walkaddr+0x2e>
        return 0;
    800015aa:	4501                	li	a0,0
    800015ac:	b7fd                	j	8000159a <walkaddr+0x2e>

00000000800015ae <kernel_vm_map>:
 * 添加虚拟地址和物理地址的映射到内核页表，只会在
 * 启动的过程中使用，在调用该函数时还没有flush TLB
 * 也没有启用分页。
 *
 */
void kernel_vm_map(uint64 va, uint64 pa, uint64 sz, int perm) {
    800015ae:	1141                	addi	sp,sp,-16
    800015b0:	e406                	sd	ra,8(sp)
    800015b2:	e022                	sd	s0,0(sp)
    800015b4:	0800                	addi	s0,sp,16
    800015b6:	8736                	mv	a4,a3
    if (mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    800015b8:	86ae                	mv	a3,a1
    800015ba:	85aa                	mv	a1,a0
    800015bc:	00005517          	auipc	a0,0x5
    800015c0:	a4c53503          	ld	a0,-1460(a0) # 80006008 <kernel_pagetable>
    800015c4:	00000097          	auipc	ra,0x0
    800015c8:	f0a080e7          	jalr	-246(ra) # 800014ce <mappages>
    800015cc:	e509                	bnez	a0,800015d6 <kernel_vm_map+0x28>
        panic("kvmmap");
}
    800015ce:	60a2                	ld	ra,8(sp)
    800015d0:	6402                	ld	s0,0(sp)
    800015d2:	0141                	addi	sp,sp,16
    800015d4:	8082                	ret
        panic("kvmmap");
    800015d6:	00004517          	auipc	a0,0x4
    800015da:	b4a50513          	addi	a0,a0,-1206 # 80005120 <digits+0x38>
    800015de:	00000097          	auipc	ra,0x0
    800015e2:	ca0080e7          	jalr	-864(ra) # 8000127e <panic>
}
    800015e6:	b7e5                	j	800015ce <kernel_vm_map+0x20>

00000000800015e8 <kernel_vm_init>:
void kernel_vm_init() {
    800015e8:	1101                	addi	sp,sp,-32
    800015ea:	ec06                	sd	ra,24(sp)
    800015ec:	e822                	sd	s0,16(sp)
    800015ee:	e426                	sd	s1,8(sp)
    800015f0:	1000                	addi	s0,sp,32
    kernel_pagetable = (pagetable_t) kalloc();
    800015f2:	00000097          	auipc	ra,0x0
    800015f6:	dae080e7          	jalr	-594(ra) # 800013a0 <kalloc>
    800015fa:	00005797          	auipc	a5,0x5
    800015fe:	a0a7b723          	sd	a0,-1522(a5) # 80006008 <kernel_pagetable>
    memset(kernel_pagetable, 0, PGSIZE);
    80001602:	6605                	lui	a2,0x1
    80001604:	4581                	li	a1,0
    80001606:	fffff097          	auipc	ra,0xfffff
    8000160a:	726080e7          	jalr	1830(ra) # 80000d2c <memset>
    kernel_vm_map(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000160e:	4699                	li	a3,6
    80001610:	6605                	lui	a2,0x1
    80001612:	100005b7          	lui	a1,0x10000
    80001616:	10000537          	lui	a0,0x10000
    8000161a:	00000097          	auipc	ra,0x0
    8000161e:	f94080e7          	jalr	-108(ra) # 800015ae <kernel_vm_map>
    kernel_vm_map(VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001622:	4699                	li	a3,6
    80001624:	6605                	lui	a2,0x1
    80001626:	100015b7          	lui	a1,0x10001
    8000162a:	10001537          	lui	a0,0x10001
    8000162e:	00000097          	auipc	ra,0x0
    80001632:	f80080e7          	jalr	-128(ra) # 800015ae <kernel_vm_map>
    kernel_vm_map(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    80001636:	4699                	li	a3,6
    80001638:	6641                	lui	a2,0x10
    8000163a:	020005b7          	lui	a1,0x2000
    8000163e:	02000537          	lui	a0,0x2000
    80001642:	00000097          	auipc	ra,0x0
    80001646:	f6c080e7          	jalr	-148(ra) # 800015ae <kernel_vm_map>
    kernel_vm_map(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000164a:	4699                	li	a3,6
    8000164c:	00400637          	lui	a2,0x400
    80001650:	0c0005b7          	lui	a1,0xc000
    80001654:	0c000537          	lui	a0,0xc000
    80001658:	00000097          	auipc	ra,0x0
    8000165c:	f56080e7          	jalr	-170(ra) # 800015ae <kernel_vm_map>
    kernel_vm_map(KERNBASE, KERNBASE, (uint64) etext - KERNBASE, PTE_R | PTE_X);
    80001660:	00004497          	auipc	s1,0x4
    80001664:	9a048493          	addi	s1,s1,-1632 # 80005000 <etext>
    80001668:	46a9                	li	a3,10
    8000166a:	80004617          	auipc	a2,0x80004
    8000166e:	99660613          	addi	a2,a2,-1642 # 5000 <_entry-0x7fffb000>
    80001672:	4585                	li	a1,1
    80001674:	05fe                	slli	a1,a1,0x1f
    80001676:	852e                	mv	a0,a1
    80001678:	00000097          	auipc	ra,0x0
    8000167c:	f36080e7          	jalr	-202(ra) # 800015ae <kernel_vm_map>
    kernel_vm_map((uint64) etext, (uint64) etext, PHYSTOP - (uint64) etext, PTE_R | PTE_W);
    80001680:	4699                	li	a3,6
    80001682:	4645                	li	a2,17
    80001684:	066e                	slli	a2,a2,0x1b
    80001686:	8e05                	sub	a2,a2,s1
    80001688:	85a6                	mv	a1,s1
    8000168a:	8526                	mv	a0,s1
    8000168c:	00000097          	auipc	ra,0x0
    80001690:	f22080e7          	jalr	-222(ra) # 800015ae <kernel_vm_map>
    kernel_vm_map(TRAMPOLINE, (uint64) trampoline, PGSIZE, PTE_R | PTE_X);
    80001694:	46a9                	li	a3,10
    80001696:	6605                	lui	a2,0x1
    80001698:	00003597          	auipc	a1,0x3
    8000169c:	96858593          	addi	a1,a1,-1688 # 80004000 <_trampoline>
    800016a0:	04000537          	lui	a0,0x4000
    800016a4:	157d                	addi	a0,a0,-1
    800016a6:	0532                	slli	a0,a0,0xc
    800016a8:	00000097          	auipc	ra,0x0
    800016ac:	f06080e7          	jalr	-250(ra) # 800015ae <kernel_vm_map>
}
    800016b0:	60e2                	ld	ra,24(sp)
    800016b2:	6442                	ld	s0,16(sp)
    800016b4:	64a2                	ld	s1,8(sp)
    800016b6:	6105                	addi	sp,sp,32
    800016b8:	8082                	ret

00000000800016ba <user_vm_alloc>:
 * @return
 */
uint64 user_vm_alloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz) {
    char *mem;
    uint64 a;
    if (newsz < oldsz)
    800016ba:	06b66763          	bltu	a2,a1,80001728 <user_vm_alloc+0x6e>
uint64 user_vm_alloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz) {
    800016be:	7179                	addi	sp,sp,-48
    800016c0:	f406                	sd	ra,40(sp)
    800016c2:	f022                	sd	s0,32(sp)
    800016c4:	ec26                	sd	s1,24(sp)
    800016c6:	e84a                	sd	s2,16(sp)
    800016c8:	e44e                	sd	s3,8(sp)
    800016ca:	e052                	sd	s4,0(sp)
    800016cc:	1800                	addi	s0,sp,48
    800016ce:	8a2a                	mv	s4,a0
    800016d0:	89b2                	mv	s3,a2
        return oldsz;

    oldsz = PGROUNDUP(oldsz);
    800016d2:	6905                	lui	s2,0x1
    800016d4:	197d                	addi	s2,s2,-1
    800016d6:	992e                	add	s2,s2,a1
    800016d8:	77fd                	lui	a5,0xfffff
    800016da:	00f97933          	and	s2,s2,a5
    for (a = oldsz; a < newsz; a += PGSIZE) {
    800016de:	04c97763          	bgeu	s2,a2,8000172c <user_vm_alloc+0x72>
        mem = kalloc();
    800016e2:	00000097          	auipc	ra,0x0
    800016e6:	cbe080e7          	jalr	-834(ra) # 800013a0 <kalloc>
    800016ea:	84aa                	mv	s1,a0
        if (mem == 0) {
    800016ec:	c131                	beqz	a0,80001730 <user_vm_alloc+0x76>
//            uvmdealloc(pagetable, a, oldsz);
            // TODO 失败释放
            return 0;
        }
        memset(mem, 0, PGSIZE);
    800016ee:	6605                	lui	a2,0x1
    800016f0:	4581                	li	a1,0
    800016f2:	fffff097          	auipc	ra,0xfffff
    800016f6:	63a080e7          	jalr	1594(ra) # 80000d2c <memset>
        if (mappages(pagetable, a, PGSIZE, (uint64) mem, PTE_W | PTE_X | PTE_R | PTE_U) != 0) {
    800016fa:	4779                	li	a4,30
    800016fc:	86a6                	mv	a3,s1
    800016fe:	6605                	lui	a2,0x1
    80001700:	85ca                	mv	a1,s2
    80001702:	8552                	mv	a0,s4
    80001704:	00000097          	auipc	ra,0x0
    80001708:	dca080e7          	jalr	-566(ra) # 800014ce <mappages>
    8000170c:	e519                	bnez	a0,8000171a <user_vm_alloc+0x60>
    for (a = oldsz; a < newsz; a += PGSIZE) {
    8000170e:	6785                	lui	a5,0x1
    80001710:	993e                	add	s2,s2,a5
    80001712:	fd3968e3          	bltu	s2,s3,800016e2 <user_vm_alloc+0x28>
//            uvmdealloc(pagetable, a, oldsz);
            // TODO 失败释放
            return 0;
        }
    }
    return newsz;
    80001716:	854e                	mv	a0,s3
    80001718:	a829                	j	80001732 <user_vm_alloc+0x78>
            kfree(mem);
    8000171a:	8526                	mv	a0,s1
    8000171c:	00000097          	auipc	ra,0x0
    80001720:	b86080e7          	jalr	-1146(ra) # 800012a2 <kfree>
            return 0;
    80001724:	4501                	li	a0,0
    80001726:	a031                	j	80001732 <user_vm_alloc+0x78>
        return oldsz;
    80001728:	852e                	mv	a0,a1
}
    8000172a:	8082                	ret
    return newsz;
    8000172c:	8532                	mv	a0,a2
    8000172e:	a011                	j	80001732 <user_vm_alloc+0x78>
            return 0;
    80001730:	4501                	li	a0,0
}
    80001732:	70a2                	ld	ra,40(sp)
    80001734:	7402                	ld	s0,32(sp)
    80001736:	64e2                	ld	s1,24(sp)
    80001738:	6942                	ld	s2,16(sp)
    8000173a:	69a2                	ld	s3,8(sp)
    8000173c:	6a02                	ld	s4,0(sp)
    8000173e:	6145                	addi	sp,sp,48
    80001740:	8082                	ret

0000000080001742 <user_vm_create>:
/**
 * 创建空的用户页表
 * 失败返回0
 * @return
 */
pagetable_t user_vm_create() {
    80001742:	1101                	addi	sp,sp,-32
    80001744:	ec06                	sd	ra,24(sp)
    80001746:	e822                	sd	s0,16(sp)
    80001748:	e426                	sd	s1,8(sp)
    8000174a:	1000                	addi	s0,sp,32
    pagetable_t pagetable;
    pagetable = (pagetable_t) kalloc();
    8000174c:	00000097          	auipc	ra,0x0
    80001750:	c54080e7          	jalr	-940(ra) # 800013a0 <kalloc>
    80001754:	84aa                	mv	s1,a0
    if (pagetable == 0)
    80001756:	c519                	beqz	a0,80001764 <user_vm_create+0x22>
        return 0;
    memset(pagetable, 0, PGSIZE);
    80001758:	6605                	lui	a2,0x1
    8000175a:	4581                	li	a1,0
    8000175c:	fffff097          	auipc	ra,0xfffff
    80001760:	5d0080e7          	jalr	1488(ra) # 80000d2c <memset>
    return pagetable;
}
    80001764:	8526                	mv	a0,s1
    80001766:	60e2                	ld	ra,24(sp)
    80001768:	6442                	ld	s0,16(sp)
    8000176a:	64a2                	ld	s1,8(sp)
    8000176c:	6105                	addi	sp,sp,32
    8000176e:	8082                	ret

0000000080001770 <user_vm_init>:
 * 将用户initcode加载进入pagetable，只在
 * 初始化第一个进程时才会调用该函数，sz必须
 * 小于PGSIZE
 */

void user_vm_init(pagetable_t pagetable, uchar *src, uint sz) {
    80001770:	7179                	addi	sp,sp,-48
    80001772:	f406                	sd	ra,40(sp)
    80001774:	f022                	sd	s0,32(sp)
    80001776:	ec26                	sd	s1,24(sp)
    80001778:	e84a                	sd	s2,16(sp)
    8000177a:	e44e                	sd	s3,8(sp)
    8000177c:	e052                	sd	s4,0(sp)
    8000177e:	1800                	addi	s0,sp,48
    80001780:	8a2a                	mv	s4,a0
    80001782:	89ae                	mv	s3,a1
    80001784:	8932                	mv	s2,a2
    char *mem;

    if (sz >= PGSIZE)
    80001786:	6785                	lui	a5,0x1
    80001788:	04f67563          	bgeu	a2,a5,800017d2 <user_vm_init+0x62>
        panic("inituvm: more than a page");
    mem = kalloc();
    8000178c:	00000097          	auipc	ra,0x0
    80001790:	c14080e7          	jalr	-1004(ra) # 800013a0 <kalloc>
    80001794:	84aa                	mv	s1,a0
    memset(mem, 0, PGSIZE);
    80001796:	6605                	lui	a2,0x1
    80001798:	4581                	li	a1,0
    8000179a:	fffff097          	auipc	ra,0xfffff
    8000179e:	592080e7          	jalr	1426(ra) # 80000d2c <memset>
    mappages(pagetable, 0, PGSIZE, (uint64) mem, PTE_W | PTE_R | PTE_X | PTE_U);
    800017a2:	4779                	li	a4,30
    800017a4:	86a6                	mv	a3,s1
    800017a6:	6605                	lui	a2,0x1
    800017a8:	4581                	li	a1,0
    800017aa:	8552                	mv	a0,s4
    800017ac:	00000097          	auipc	ra,0x0
    800017b0:	d22080e7          	jalr	-734(ra) # 800014ce <mappages>
    memmove(mem, src, sz);
    800017b4:	864a                	mv	a2,s2
    800017b6:	85ce                	mv	a1,s3
    800017b8:	8526                	mv	a0,s1
    800017ba:	fffff097          	auipc	ra,0xfffff
    800017be:	598080e7          	jalr	1432(ra) # 80000d52 <memmove>
}
    800017c2:	70a2                	ld	ra,40(sp)
    800017c4:	7402                	ld	s0,32(sp)
    800017c6:	64e2                	ld	s1,24(sp)
    800017c8:	6942                	ld	s2,16(sp)
    800017ca:	69a2                	ld	s3,8(sp)
    800017cc:	6a02                	ld	s4,0(sp)
    800017ce:	6145                	addi	sp,sp,48
    800017d0:	8082                	ret
        panic("inituvm: more than a page");
    800017d2:	00004517          	auipc	a0,0x4
    800017d6:	95650513          	addi	a0,a0,-1706 # 80005128 <digits+0x40>
    800017da:	00000097          	auipc	ra,0x0
    800017de:	aa4080e7          	jalr	-1372(ra) # 8000127e <panic>
    800017e2:	b76d                	j	8000178c <user_vm_init+0x1c>

00000000800017e4 <copyin>:
 * 从给定的pagetable中，以vsrc为起点向后copy len字节到内核中的dst处。
 * 成功返回0，失败返回-1。
 */
int copyin(pagetable_t pagetable, char *dst, uint64 vsrc, uint64 len) {
    uint64 n, va0, pa0;
    while (len > 0) {
    800017e4:	c6b5                	beqz	a3,80001850 <copyin+0x6c>
int copyin(pagetable_t pagetable, char *dst, uint64 vsrc, uint64 len) {
    800017e6:	715d                	addi	sp,sp,-80
    800017e8:	e486                	sd	ra,72(sp)
    800017ea:	e0a2                	sd	s0,64(sp)
    800017ec:	fc26                	sd	s1,56(sp)
    800017ee:	f84a                	sd	s2,48(sp)
    800017f0:	f44e                	sd	s3,40(sp)
    800017f2:	f052                	sd	s4,32(sp)
    800017f4:	ec56                	sd	s5,24(sp)
    800017f6:	e85a                	sd	s6,16(sp)
    800017f8:	e45e                	sd	s7,8(sp)
    800017fa:	e062                	sd	s8,0(sp)
    800017fc:	0880                	addi	s0,sp,80
    800017fe:	8b2a                	mv	s6,a0
    80001800:	8aae                	mv	s5,a1
    80001802:	8932                	mv	s2,a2
    80001804:	89b6                	mv	s3,a3
        va0 = PGROUNDDOWN(vsrc);
    80001806:	7bfd                	lui	s7,0xfffff
        pa0 = walkaddr(pagetable, va0);
        if (pa0 == 0) {
            return -1;
        }
        n = PGSIZE - (vsrc - va0);
    80001808:	6c05                	lui	s8,0x1
    8000180a:	a00d                	j	8000182c <copyin+0x48>
        if (n > len) {
            n = len;
        }
        memmove(dst, (void *) (pa0 + (vsrc - va0)), n);
    8000180c:	954a                	add	a0,a0,s2
    8000180e:	0004861b          	sext.w	a2,s1
    80001812:	414505b3          	sub	a1,a0,s4
    80001816:	8556                	mv	a0,s5
    80001818:	fffff097          	auipc	ra,0xfffff
    8000181c:	53a080e7          	jalr	1338(ra) # 80000d52 <memmove>
        len -= n;
    80001820:	409989b3          	sub	s3,s3,s1
        dst += n;
    80001824:	9aa6                	add	s5,s5,s1
        vsrc += n;
    80001826:	9926                	add	s2,s2,s1
    while (len > 0) {
    80001828:	02098263          	beqz	s3,8000184c <copyin+0x68>
        va0 = PGROUNDDOWN(vsrc);
    8000182c:	01797a33          	and	s4,s2,s7
        pa0 = walkaddr(pagetable, va0);
    80001830:	85d2                	mv	a1,s4
    80001832:	855a                	mv	a0,s6
    80001834:	00000097          	auipc	ra,0x0
    80001838:	d38080e7          	jalr	-712(ra) # 8000156c <walkaddr>
        if (pa0 == 0) {
    8000183c:	cd01                	beqz	a0,80001854 <copyin+0x70>
        n = PGSIZE - (vsrc - va0);
    8000183e:	412a04b3          	sub	s1,s4,s2
    80001842:	94e2                	add	s1,s1,s8
        if (n > len) {
    80001844:	fc99f4e3          	bgeu	s3,s1,8000180c <copyin+0x28>
    80001848:	84ce                	mv	s1,s3
    8000184a:	b7c9                	j	8000180c <copyin+0x28>
    }
    return 0;
    8000184c:	4501                	li	a0,0
    8000184e:	a021                	j	80001856 <copyin+0x72>
    80001850:	4501                	li	a0,0
}
    80001852:	8082                	ret
            return -1;
    80001854:	557d                	li	a0,-1
}
    80001856:	60a6                	ld	ra,72(sp)
    80001858:	6406                	ld	s0,64(sp)
    8000185a:	74e2                	ld	s1,56(sp)
    8000185c:	7942                	ld	s2,48(sp)
    8000185e:	79a2                	ld	s3,40(sp)
    80001860:	7a02                	ld	s4,32(sp)
    80001862:	6ae2                	ld	s5,24(sp)
    80001864:	6b42                	ld	s6,16(sp)
    80001866:	6ba2                	ld	s7,8(sp)
    80001868:	6c02                	ld	s8,0(sp)
    8000186a:	6161                	addi	sp,sp,80
    8000186c:	8082                	ret

000000008000186e <copyinstr>:
 */
int copyinstr(pagetable_t pagetable, char *dst, uint64 vsrc, int maxsz) {
    uint64 n, va0, pa0 = 0;
    int got_null = 0;

    while (got_null == 0 && maxsz > 0) {
    8000186e:	0ad05963          	blez	a3,80001920 <copyinstr+0xb2>
int copyinstr(pagetable_t pagetable, char *dst, uint64 vsrc, int maxsz) {
    80001872:	715d                	addi	sp,sp,-80
    80001874:	e486                	sd	ra,72(sp)
    80001876:	e0a2                	sd	s0,64(sp)
    80001878:	fc26                	sd	s1,56(sp)
    8000187a:	f84a                	sd	s2,48(sp)
    8000187c:	f44e                	sd	s3,40(sp)
    8000187e:	f052                	sd	s4,32(sp)
    80001880:	ec56                	sd	s5,24(sp)
    80001882:	e85a                	sd	s6,16(sp)
    80001884:	e45e                	sd	s7,8(sp)
    80001886:	0880                	addi	s0,sp,80
    80001888:	8a2a                	mv	s4,a0
    8000188a:	84ae                	mv	s1,a1
    8000188c:	8bb2                	mv	s7,a2
    8000188e:	8b36                	mv	s6,a3
        va0 = PGROUNDDOWN(vsrc);
    80001890:	7afd                	lui	s5,0xfffff
        pa0 = walkaddr(pagetable, va0);
        if (pa0 == 0) {
            return -1;
        }
        n = PGSIZE - (vsrc - va0);
    80001892:	6985                	lui	s3,0x1
    80001894:	a03d                	j	800018c2 <copyinstr+0x54>
        }
        char *p = (char *) (pa0 + (vsrc - va0));

        while (n > 0) {
            if (*p == 0) {
                *dst = 0;
    80001896:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    8000189a:	4785                	li	a5,1
            dst++;
            p++;
        }
        vsrc = va0 + PGSIZE;
    }
    if (got_null) {
    8000189c:	0017b793          	seqz	a5,a5
    800018a0:	40f00533          	neg	a0,a5
        return 0;
    }
    return -1;
}
    800018a4:	60a6                	ld	ra,72(sp)
    800018a6:	6406                	ld	s0,64(sp)
    800018a8:	74e2                	ld	s1,56(sp)
    800018aa:	7942                	ld	s2,48(sp)
    800018ac:	79a2                	ld	s3,40(sp)
    800018ae:	7a02                	ld	s4,32(sp)
    800018b0:	6ae2                	ld	s5,24(sp)
    800018b2:	6b42                	ld	s6,16(sp)
    800018b4:	6ba2                	ld	s7,8(sp)
    800018b6:	6161                	addi	sp,sp,80
    800018b8:	8082                	ret
        vsrc = va0 + PGSIZE;
    800018ba:	01390bb3          	add	s7,s2,s3
    while (got_null == 0 && maxsz > 0) {
    800018be:	05605d63          	blez	s6,80001918 <copyinstr+0xaa>
        va0 = PGROUNDDOWN(vsrc);
    800018c2:	015bf933          	and	s2,s7,s5
        pa0 = walkaddr(pagetable, va0);
    800018c6:	85ca                	mv	a1,s2
    800018c8:	8552                	mv	a0,s4
    800018ca:	00000097          	auipc	ra,0x0
    800018ce:	ca2080e7          	jalr	-862(ra) # 8000156c <walkaddr>
        if (pa0 == 0) {
    800018d2:	c529                	beqz	a0,8000191c <copyinstr+0xae>
        n = PGSIZE - (vsrc - va0);
    800018d4:	417907b3          	sub	a5,s2,s7
    800018d8:	97ce                	add	a5,a5,s3
        if (n > maxsz) {
    800018da:	885a                	mv	a6,s6
    800018dc:	0167f363          	bgeu	a5,s6,800018e2 <copyinstr+0x74>
    800018e0:	883e                	mv	a6,a5
        char *p = (char *) (pa0 + (vsrc - va0));
    800018e2:	955e                	add	a0,a0,s7
    800018e4:	41250533          	sub	a0,a0,s2
        while (n > 0) {
    800018e8:	fc0809e3          	beqz	a6,800018ba <copyinstr+0x4c>
    800018ec:	9826                	add	a6,a6,s1
    800018ee:	87a6                	mv	a5,s1
            if (*p == 0) {
    800018f0:	40950633          	sub	a2,a0,s1
    800018f4:	009b04bb          	addw	s1,s6,s1
    800018f8:	fff4859b          	addiw	a1,s1,-1
    800018fc:	00c78733          	add	a4,a5,a2
    80001900:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ff935d0>
    80001904:	db49                	beqz	a4,80001896 <copyinstr+0x28>
                *dst = *p;
    80001906:	00e78023          	sb	a4,0(a5)
            maxsz--;
    8000190a:	40f58b3b          	subw	s6,a1,a5
            dst++;
    8000190e:	0785                	addi	a5,a5,1
        while (n > 0) {
    80001910:	ff0796e3          	bne	a5,a6,800018fc <copyinstr+0x8e>
            dst++;
    80001914:	84c2                	mv	s1,a6
    80001916:	b755                	j	800018ba <copyinstr+0x4c>
    80001918:	4781                	li	a5,0
    8000191a:	b749                	j	8000189c <copyinstr+0x2e>
            return -1;
    8000191c:	557d                	li	a0,-1
    8000191e:	b759                	j	800018a4 <copyinstr+0x36>
    int got_null = 0;
    80001920:	4781                	li	a5,0
    if (got_null) {
    80001922:	0017b793          	seqz	a5,a5
    80001926:	40f00533          	neg	a0,a5
}
    8000192a:	8082                	ret

000000008000192c <copyout>:
 * @param len copy长度
 * @return 成功返回0，失败返回-1
 */
int copyout(pagetable_t pagetable, uint64 vdst, char *src, int len) {
    uint64 n, va0, pa0;
    while (len > 0) {
    8000192c:	06d05863          	blez	a3,8000199c <copyout+0x70>
int copyout(pagetable_t pagetable, uint64 vdst, char *src, int len) {
    80001930:	715d                	addi	sp,sp,-80
    80001932:	e486                	sd	ra,72(sp)
    80001934:	e0a2                	sd	s0,64(sp)
    80001936:	fc26                	sd	s1,56(sp)
    80001938:	f84a                	sd	s2,48(sp)
    8000193a:	f44e                	sd	s3,40(sp)
    8000193c:	f052                	sd	s4,32(sp)
    8000193e:	ec56                	sd	s5,24(sp)
    80001940:	e85a                	sd	s6,16(sp)
    80001942:	e45e                	sd	s7,8(sp)
    80001944:	e062                	sd	s8,0(sp)
    80001946:	0880                	addi	s0,sp,80
    80001948:	8b2a                	mv	s6,a0
    8000194a:	89ae                	mv	s3,a1
    8000194c:	8ab2                	mv	s5,a2
    8000194e:	8936                	mv	s2,a3
        va0 = PGROUNDDOWN(vdst);
    80001950:	7bfd                	lui	s7,0xfffff
        pa0 = walkaddr(pagetable, va0);
        if (pa0 == 0) {
            return -1;
        }
        n = PGSIZE - (vdst - va0);
    80001952:	6c05                	lui	s8,0x1
    80001954:	a00d                	j	80001976 <copyout+0x4a>
        if (n > len) {
            n = len;
        }
        memmove((void *) (pa0 + (vdst - va0)), src, n);
    80001956:	954e                	add	a0,a0,s3
    80001958:	0004861b          	sext.w	a2,s1
    8000195c:	85d6                	mv	a1,s5
    8000195e:	41450533          	sub	a0,a0,s4
    80001962:	fffff097          	auipc	ra,0xfffff
    80001966:	3f0080e7          	jalr	1008(ra) # 80000d52 <memmove>
        len -= n;
    8000196a:	4099093b          	subw	s2,s2,s1
        vdst += n;
    8000196e:	99a6                	add	s3,s3,s1
        src += n;
    80001970:	9aa6                	add	s5,s5,s1
    while (len > 0) {
    80001972:	03205363          	blez	s2,80001998 <copyout+0x6c>
        va0 = PGROUNDDOWN(vdst);
    80001976:	0179fa33          	and	s4,s3,s7
        pa0 = walkaddr(pagetable, va0);
    8000197a:	85d2                	mv	a1,s4
    8000197c:	855a                	mv	a0,s6
    8000197e:	00000097          	auipc	ra,0x0
    80001982:	bee080e7          	jalr	-1042(ra) # 8000156c <walkaddr>
        if (pa0 == 0) {
    80001986:	cd09                	beqz	a0,800019a0 <copyout+0x74>
        n = PGSIZE - (vdst - va0);
    80001988:	413a07b3          	sub	a5,s4,s3
    8000198c:	97e2                	add	a5,a5,s8
        if (n > len) {
    8000198e:	84ca                	mv	s1,s2
    80001990:	fd27f3e3          	bgeu	a5,s2,80001956 <copyout+0x2a>
    80001994:	84be                	mv	s1,a5
    80001996:	b7c1                	j	80001956 <copyout+0x2a>
    }
    return 0;
    80001998:	4501                	li	a0,0
    8000199a:	a021                	j	800019a2 <copyout+0x76>
    8000199c:	4501                	li	a0,0
}
    8000199e:	8082                	ret
            return -1;
    800019a0:	557d                	li	a0,-1
}
    800019a2:	60a6                	ld	ra,72(sp)
    800019a4:	6406                	ld	s0,64(sp)
    800019a6:	74e2                	ld	s1,56(sp)
    800019a8:	7942                	ld	s2,48(sp)
    800019aa:	79a2                	ld	s3,40(sp)
    800019ac:	7a02                	ld	s4,32(sp)
    800019ae:	6ae2                	ld	s5,24(sp)
    800019b0:	6b42                	ld	s6,16(sp)
    800019b2:	6ba2                	ld	s7,8(sp)
    800019b4:	6c02                	ld	s8,0(sp)
    800019b6:	6161                	addi	sp,sp,80
    800019b8:	8082                	ret

00000000800019ba <vmprint>:

void vmprint(pagetable_t pagetable, int n) {
    800019ba:	711d                	addi	sp,sp,-96
    800019bc:	ec86                	sd	ra,88(sp)
    800019be:	e8a2                	sd	s0,80(sp)
    800019c0:	e4a6                	sd	s1,72(sp)
    800019c2:	e0ca                	sd	s2,64(sp)
    800019c4:	fc4e                	sd	s3,56(sp)
    800019c6:	f852                	sd	s4,48(sp)
    800019c8:	f456                	sd	s5,40(sp)
    800019ca:	f05a                	sd	s6,32(sp)
    800019cc:	ec5e                	sd	s7,24(sp)
    800019ce:	e862                	sd	s8,16(sp)
    800019d0:	e466                	sd	s9,8(sp)
    800019d2:	e06a                	sd	s10,0(sp)
    800019d4:	1080                	addi	s0,sp,96
    800019d6:	892a                	mv	s2,a0
    800019d8:	8c2e                	mv	s8,a1
    if (n == 1) {
    800019da:	4785                	li	a5,1
    800019dc:	02f58463          	beq	a1,a5,80001a04 <vmprint+0x4a>
        printf("page table %p\n", pagetable);
    }
    if (n >= 4) {
    800019e0:	478d                	li	a5,3
    800019e2:	08b7c163          	blt	a5,a1,80001a64 <vmprint+0xaa>
        return;
    }
    for (int i = 0; i < 512; i++) {
    800019e6:	4481                	li	s1,0
        if (pte & PTE_V) {
            for (int j = 1; j <= n; j++) {
                printf(".. ");
            }
            uint64 child = PTE2PA(pte);
            printf("%d: pte %p pa %p\n", i, pte, child);
    800019e8:	00003c97          	auipc	s9,0x3
    800019ec:	778c8c93          	addi	s9,s9,1912 # 80005160 <digits+0x78>
            vmprint((pagetable_t) child, n + 1);
    800019f0:	001c0a9b          	addiw	s5,s8,1
            for (int j = 1; j <= n; j++) {
    800019f4:	4d05                	li	s10,1
                printf(".. ");
    800019f6:	00003b97          	auipc	s7,0x3
    800019fa:	762b8b93          	addi	s7,s7,1890 # 80005158 <digits+0x70>
    for (int i = 0; i < 512; i++) {
    800019fe:	20000b13          	li	s6,512
    80001a02:	a081                	j	80001a42 <vmprint+0x88>
        printf("page table %p\n", pagetable);
    80001a04:	85aa                	mv	a1,a0
    80001a06:	00003517          	auipc	a0,0x3
    80001a0a:	74250513          	addi	a0,a0,1858 # 80005148 <digits+0x60>
    80001a0e:	fffff097          	auipc	ra,0xfffff
    80001a12:	7ac080e7          	jalr	1964(ra) # 800011ba <printf>
    if (n >= 4) {
    80001a16:	bfc1                	j	800019e6 <vmprint+0x2c>
            uint64 child = PTE2PA(pte);
    80001a18:	00aa5993          	srli	s3,s4,0xa
    80001a1c:	09b2                	slli	s3,s3,0xc
            printf("%d: pte %p pa %p\n", i, pte, child);
    80001a1e:	86ce                	mv	a3,s3
    80001a20:	8652                	mv	a2,s4
    80001a22:	85a6                	mv	a1,s1
    80001a24:	8566                	mv	a0,s9
    80001a26:	fffff097          	auipc	ra,0xfffff
    80001a2a:	794080e7          	jalr	1940(ra) # 800011ba <printf>
            vmprint((pagetable_t) child, n + 1);
    80001a2e:	85d6                	mv	a1,s5
    80001a30:	854e                	mv	a0,s3
    80001a32:	00000097          	auipc	ra,0x0
    80001a36:	f88080e7          	jalr	-120(ra) # 800019ba <vmprint>
    for (int i = 0; i < 512; i++) {
    80001a3a:	2485                	addiw	s1,s1,1
    80001a3c:	0921                	addi	s2,s2,8
    80001a3e:	03648363          	beq	s1,s6,80001a64 <vmprint+0xaa>
        pte_t pte = pagetable[i];
    80001a42:	00093a03          	ld	s4,0(s2) # 1000 <_entry-0x7ffff000>
        if (pte & PTE_V) {
    80001a46:	001a7793          	andi	a5,s4,1
    80001a4a:	dbe5                	beqz	a5,80001a3a <vmprint+0x80>
            for (int j = 1; j <= n; j++) {
    80001a4c:	fd8056e3          	blez	s8,80001a18 <vmprint+0x5e>
    80001a50:	89ea                	mv	s3,s10
                printf(".. ");
    80001a52:	855e                	mv	a0,s7
    80001a54:	fffff097          	auipc	ra,0xfffff
    80001a58:	766080e7          	jalr	1894(ra) # 800011ba <printf>
            for (int j = 1; j <= n; j++) {
    80001a5c:	2985                	addiw	s3,s3,1
    80001a5e:	ff3a9ae3          	bne	s5,s3,80001a52 <vmprint+0x98>
    80001a62:	bf5d                	j	80001a18 <vmprint+0x5e>
        }
    }
    80001a64:	60e6                	ld	ra,88(sp)
    80001a66:	6446                	ld	s0,80(sp)
    80001a68:	64a6                	ld	s1,72(sp)
    80001a6a:	6906                	ld	s2,64(sp)
    80001a6c:	79e2                	ld	s3,56(sp)
    80001a6e:	7a42                	ld	s4,48(sp)
    80001a70:	7aa2                	ld	s5,40(sp)
    80001a72:	7b02                	ld	s6,32(sp)
    80001a74:	6be2                	ld	s7,24(sp)
    80001a76:	6c42                	ld	s8,16(sp)
    80001a78:	6ca2                	ld	s9,8(sp)
    80001a7a:	6d02                	ld	s10,0(sp)
    80001a7c:	6125                	addi	sp,sp,96
    80001a7e:	8082                	ret

0000000080001a80 <free_desc>:
    return -1;
}

// mark a descriptor as free.
static void
free_desc(int i) {
    80001a80:	1101                	addi	sp,sp,-32
    80001a82:	ec06                	sd	ra,24(sp)
    80001a84:	e822                	sd	s0,16(sp)
    80001a86:	e426                	sd	s1,8(sp)
    80001a88:	1000                	addi	s0,sp,32
    80001a8a:	84aa                	mv	s1,a0
    if (i >= NUM)
    80001a8c:	479d                	li	a5,7
    80001a8e:	06a7ca63          	blt	a5,a0,80001b02 <free_desc+0x82>
        panic("free_desc 1");
    if (disk.free[i])
    80001a92:	0004a797          	auipc	a5,0x4a
    80001a96:	56e78793          	addi	a5,a5,1390 # 8004c000 <disk>
    80001a9a:	00978733          	add	a4,a5,s1
    80001a9e:	6789                	lui	a5,0x2
    80001aa0:	97ba                	add	a5,a5,a4
    80001aa2:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80001aa6:	e7bd                	bnez	a5,80001b14 <free_desc+0x94>
        panic("free_desc 2");
    disk.desc[i].addr = 0;
    80001aa8:	00449793          	slli	a5,s1,0x4
    80001aac:	0004c717          	auipc	a4,0x4c
    80001ab0:	55470713          	addi	a4,a4,1364 # 8004e000 <disk+0x2000>
    80001ab4:	6314                	ld	a3,0(a4)
    80001ab6:	96be                	add	a3,a3,a5
    80001ab8:	0006b023          	sd	zero,0(a3)
    disk.desc[i].len = 0;
    80001abc:	6314                	ld	a3,0(a4)
    80001abe:	96be                	add	a3,a3,a5
    80001ac0:	0006a423          	sw	zero,8(a3)
    disk.desc[i].flags = 0;
    80001ac4:	6314                	ld	a3,0(a4)
    80001ac6:	96be                	add	a3,a3,a5
    80001ac8:	00069623          	sh	zero,12(a3)
    disk.desc[i].next = 0;
    80001acc:	6318                	ld	a4,0(a4)
    80001ace:	97ba                	add	a5,a5,a4
    80001ad0:	00079723          	sh	zero,14(a5)
    disk.free[i] = 1;
    80001ad4:	0004a517          	auipc	a0,0x4a
    80001ad8:	52c50513          	addi	a0,a0,1324 # 8004c000 <disk>
    80001adc:	9526                	add	a0,a0,s1
    80001ade:	6489                	lui	s1,0x2
    80001ae0:	94aa                	add	s1,s1,a0
    80001ae2:	4785                	li	a5,1
    80001ae4:	00f48c23          	sb	a5,24(s1) # 2018 <_entry-0x7fffdfe8>
    wakeup(&disk.free[0]);
    80001ae8:	0004c517          	auipc	a0,0x4c
    80001aec:	53050513          	addi	a0,a0,1328 # 8004e018 <disk+0x2018>
    80001af0:	fffff097          	auipc	ra,0xfffff
    80001af4:	f1e080e7          	jalr	-226(ra) # 80000a0e <wakeup>
}
    80001af8:	60e2                	ld	ra,24(sp)
    80001afa:	6442                	ld	s0,16(sp)
    80001afc:	64a2                	ld	s1,8(sp)
    80001afe:	6105                	addi	sp,sp,32
    80001b00:	8082                	ret
        panic("free_desc 1");
    80001b02:	00003517          	auipc	a0,0x3
    80001b06:	67650513          	addi	a0,a0,1654 # 80005178 <digits+0x90>
    80001b0a:	fffff097          	auipc	ra,0xfffff
    80001b0e:	774080e7          	jalr	1908(ra) # 8000127e <panic>
    80001b12:	b741                	j	80001a92 <free_desc+0x12>
        panic("free_desc 2");
    80001b14:	00003517          	auipc	a0,0x3
    80001b18:	67450513          	addi	a0,a0,1652 # 80005188 <digits+0xa0>
    80001b1c:	fffff097          	auipc	ra,0xfffff
    80001b20:	762080e7          	jalr	1890(ra) # 8000127e <panic>
    80001b24:	b751                	j	80001aa8 <free_desc+0x28>

0000000080001b26 <virtio_disk_init>:
virtio_disk_init(void) {
    80001b26:	1101                	addi	sp,sp,-32
    80001b28:	ec06                	sd	ra,24(sp)
    80001b2a:	e822                	sd	s0,16(sp)
    80001b2c:	e426                	sd	s1,8(sp)
    80001b2e:	1000                	addi	s0,sp,32
    spinlock_init(&disk.vdisk_lock, "virtio_disk");
    80001b30:	00003597          	auipc	a1,0x3
    80001b34:	66858593          	addi	a1,a1,1640 # 80005198 <digits+0xb0>
    80001b38:	0004c517          	auipc	a0,0x4c
    80001b3c:	5f050513          	addi	a0,a0,1520 # 8004e128 <disk+0x2128>
    80001b40:	00001097          	auipc	ra,0x1
    80001b44:	67c080e7          	jalr	1660(ra) # 800031bc <spinlock_init>
    if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80001b48:	100017b7          	lui	a5,0x10001
    80001b4c:	4398                	lw	a4,0(a5)
    80001b4e:	2701                	sext.w	a4,a4
    80001b50:	747277b7          	lui	a5,0x74727
    80001b54:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80001b58:	00f71963          	bne	a4,a5,80001b6a <virtio_disk_init+0x44>
        *R(VIRTIO_MMIO_VERSION) != 1 ||
    80001b5c:	100017b7          	lui	a5,0x10001
    80001b60:	43dc                	lw	a5,4(a5)
    80001b62:	2781                	sext.w	a5,a5
    if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80001b64:	4705                	li	a4,1
    80001b66:	0ce78163          	beq	a5,a4,80001c28 <virtio_disk_init+0x102>
        panic("could not find virtio disk");
    80001b6a:	00003517          	auipc	a0,0x3
    80001b6e:	63e50513          	addi	a0,a0,1598 # 800051a8 <digits+0xc0>
    80001b72:	fffff097          	auipc	ra,0xfffff
    80001b76:	70c080e7          	jalr	1804(ra) # 8000127e <panic>
    *R(VIRTIO_MMIO_STATUS) = status;
    80001b7a:	100017b7          	lui	a5,0x10001
    80001b7e:	4705                	li	a4,1
    80001b80:	dbb8                	sw	a4,112(a5)
    *R(VIRTIO_MMIO_STATUS) = status;
    80001b82:	470d                	li	a4,3
    80001b84:	dbb8                	sw	a4,112(a5)
    uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80001b86:	4b94                	lw	a3,16(a5)
    features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80001b88:	c7ffe737          	lui	a4,0xc7ffe
    80001b8c:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47f92d2f>
    80001b90:	8f75                	and	a4,a4,a3
    *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80001b92:	2701                	sext.w	a4,a4
    80001b94:	d398                	sw	a4,32(a5)
    *R(VIRTIO_MMIO_STATUS) = status;
    80001b96:	472d                	li	a4,11
    80001b98:	dbb8                	sw	a4,112(a5)
    *R(VIRTIO_MMIO_STATUS) = status;
    80001b9a:	473d                	li	a4,15
    80001b9c:	dbb8                	sw	a4,112(a5)
    *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80001b9e:	6705                	lui	a4,0x1
    80001ba0:	d798                	sw	a4,40(a5)
    *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80001ba2:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
    uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80001ba6:	5bdc                	lw	a5,52(a5)
    80001ba8:	2781                	sext.w	a5,a5
    if (max == 0)
    80001baa:	c3cd                	beqz	a5,80001c4c <virtio_disk_init+0x126>
    if (max < NUM)
    80001bac:	471d                	li	a4,7
    80001bae:	0af77763          	bgeu	a4,a5,80001c5c <virtio_disk_init+0x136>
    *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80001bb2:	100014b7          	lui	s1,0x10001
    80001bb6:	47a1                	li	a5,8
    80001bb8:	dc9c                	sw	a5,56(s1)
    memset(disk.pages, 0, sizeof(disk.pages));
    80001bba:	6609                	lui	a2,0x2
    80001bbc:	4581                	li	a1,0
    80001bbe:	0004a517          	auipc	a0,0x4a
    80001bc2:	44250513          	addi	a0,a0,1090 # 8004c000 <disk>
    80001bc6:	fffff097          	auipc	ra,0xfffff
    80001bca:	166080e7          	jalr	358(ra) # 80000d2c <memset>
    *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64) disk.pages) >> PGSHIFT;
    80001bce:	0004a717          	auipc	a4,0x4a
    80001bd2:	43270713          	addi	a4,a4,1074 # 8004c000 <disk>
    80001bd6:	00c75793          	srli	a5,a4,0xc
    80001bda:	2781                	sext.w	a5,a5
    80001bdc:	c0bc                	sw	a5,64(s1)
    disk.desc = (struct virtq_desc *) disk.pages;
    80001bde:	0004c797          	auipc	a5,0x4c
    80001be2:	42278793          	addi	a5,a5,1058 # 8004e000 <disk+0x2000>
    80001be6:	e398                	sd	a4,0(a5)
    disk.avail = (struct virtq_avail *) (disk.pages + NUM * sizeof(struct virtq_desc));
    80001be8:	0004a717          	auipc	a4,0x4a
    80001bec:	49870713          	addi	a4,a4,1176 # 8004c080 <disk+0x80>
    80001bf0:	e798                	sd	a4,8(a5)
    disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80001bf2:	0004b717          	auipc	a4,0x4b
    80001bf6:	40e70713          	addi	a4,a4,1038 # 8004d000 <disk+0x1000>
    80001bfa:	eb98                	sd	a4,16(a5)
        disk.free[i] = 1;
    80001bfc:	4705                	li	a4,1
    80001bfe:	00e78c23          	sb	a4,24(a5)
    80001c02:	00e78ca3          	sb	a4,25(a5)
    80001c06:	00e78d23          	sb	a4,26(a5)
    80001c0a:	00e78da3          	sb	a4,27(a5)
    80001c0e:	00e78e23          	sb	a4,28(a5)
    80001c12:	00e78ea3          	sb	a4,29(a5)
    80001c16:	00e78f23          	sb	a4,30(a5)
    80001c1a:	00e78fa3          	sb	a4,31(a5)
}
    80001c1e:	60e2                	ld	ra,24(sp)
    80001c20:	6442                	ld	s0,16(sp)
    80001c22:	64a2                	ld	s1,8(sp)
    80001c24:	6105                	addi	sp,sp,32
    80001c26:	8082                	ret
        *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80001c28:	100017b7          	lui	a5,0x10001
    80001c2c:	479c                	lw	a5,8(a5)
    80001c2e:	2781                	sext.w	a5,a5
        *R(VIRTIO_MMIO_VERSION) != 1 ||
    80001c30:	4709                	li	a4,2
    80001c32:	f2e79ce3          	bne	a5,a4,80001b6a <virtio_disk_init+0x44>
        *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    80001c36:	100017b7          	lui	a5,0x10001
    80001c3a:	47d8                	lw	a4,12(a5)
    80001c3c:	2701                	sext.w	a4,a4
        *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80001c3e:	554d47b7          	lui	a5,0x554d4
    80001c42:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80001c46:	f2f712e3          	bne	a4,a5,80001b6a <virtio_disk_init+0x44>
    80001c4a:	bf05                	j	80001b7a <virtio_disk_init+0x54>
        panic("virtio disk has no queue 0");
    80001c4c:	00003517          	auipc	a0,0x3
    80001c50:	57c50513          	addi	a0,a0,1404 # 800051c8 <digits+0xe0>
    80001c54:	fffff097          	auipc	ra,0xfffff
    80001c58:	62a080e7          	jalr	1578(ra) # 8000127e <panic>
        panic("virtio disk max queue too short");
    80001c5c:	00003517          	auipc	a0,0x3
    80001c60:	58c50513          	addi	a0,a0,1420 # 800051e8 <digits+0x100>
    80001c64:	fffff097          	auipc	ra,0xfffff
    80001c68:	61a080e7          	jalr	1562(ra) # 8000127e <panic>
    80001c6c:	b799                	j	80001bb2 <virtio_disk_init+0x8c>

0000000080001c6e <virtio_disk_rw>:
    }
    return 0;
}

void
virtio_disk_rw(struct buf *b, int write) {
    80001c6e:	7159                	addi	sp,sp,-112
    80001c70:	f486                	sd	ra,104(sp)
    80001c72:	f0a2                	sd	s0,96(sp)
    80001c74:	eca6                	sd	s1,88(sp)
    80001c76:	e8ca                	sd	s2,80(sp)
    80001c78:	e4ce                	sd	s3,72(sp)
    80001c7a:	e0d2                	sd	s4,64(sp)
    80001c7c:	fc56                	sd	s5,56(sp)
    80001c7e:	f85a                	sd	s6,48(sp)
    80001c80:	f45e                	sd	s7,40(sp)
    80001c82:	f062                	sd	s8,32(sp)
    80001c84:	ec66                	sd	s9,24(sp)
    80001c86:	e86a                	sd	s10,16(sp)
    80001c88:	1880                	addi	s0,sp,112
    80001c8a:	892a                	mv	s2,a0
    80001c8c:	8d2e                	mv	s10,a1
    uint64 sector = b->blockno * (BSIZE / 512);
    80001c8e:	00c52c83          	lw	s9,12(a0)
    80001c92:	001c9c9b          	slliw	s9,s9,0x1
    80001c96:	1c82                	slli	s9,s9,0x20
    80001c98:	020cdc93          	srli	s9,s9,0x20
    spin_lock(&disk.vdisk_lock);
    80001c9c:	0004c517          	auipc	a0,0x4c
    80001ca0:	48c50513          	addi	a0,a0,1164 # 8004e128 <disk+0x2128>
    80001ca4:	00001097          	auipc	ra,0x1
    80001ca8:	5a8080e7          	jalr	1448(ra) # 8000324c <spin_lock>
    for (int i = 0; i < 3; i++) {
    80001cac:	4981                	li	s3,0
    for (int i = 0; i < NUM; i++) {
    80001cae:	4c21                	li	s8,8
            disk.free[i] = 0;
    80001cb0:	0004ab97          	auipc	s7,0x4a
    80001cb4:	350b8b93          	addi	s7,s7,848 # 8004c000 <disk>
    80001cb8:	6b09                	lui	s6,0x2
    for (int i = 0; i < 3; i++) {
    80001cba:	4a8d                	li	s5,3
    for (int i = 0; i < NUM; i++) {
    80001cbc:	8a4e                	mv	s4,s3
    80001cbe:	a051                	j	80001d42 <virtio_disk_rw+0xd4>
            disk.free[i] = 0;
    80001cc0:	00fb86b3          	add	a3,s7,a5
    80001cc4:	96da                	add	a3,a3,s6
    80001cc6:	00068c23          	sb	zero,24(a3)
        idx[i] = alloc_desc();
    80001cca:	c21c                	sw	a5,0(a2)
        if (idx[i] < 0) {
    80001ccc:	0207c563          	bltz	a5,80001cf6 <virtio_disk_rw+0x88>
    for (int i = 0; i < 3; i++) {
    80001cd0:	2485                	addiw	s1,s1,1
    80001cd2:	0711                	addi	a4,a4,4
    80001cd4:	25548063          	beq	s1,s5,80001f14 <virtio_disk_rw+0x2a6>
        idx[i] = alloc_desc();
    80001cd8:	863a                	mv	a2,a4
    for (int i = 0; i < NUM; i++) {
    80001cda:	0004c697          	auipc	a3,0x4c
    80001cde:	33e68693          	addi	a3,a3,830 # 8004e018 <disk+0x2018>
    80001ce2:	87d2                	mv	a5,s4
        if (disk.free[i]) {
    80001ce4:	0006c583          	lbu	a1,0(a3)
    80001ce8:	fde1                	bnez	a1,80001cc0 <virtio_disk_rw+0x52>
    for (int i = 0; i < NUM; i++) {
    80001cea:	2785                	addiw	a5,a5,1
    80001cec:	0685                	addi	a3,a3,1
    80001cee:	ff879be3          	bne	a5,s8,80001ce4 <virtio_disk_rw+0x76>
        idx[i] = alloc_desc();
    80001cf2:	57fd                	li	a5,-1
    80001cf4:	c21c                	sw	a5,0(a2)
            for (int j = 0; j < i; j++)
    80001cf6:	02905a63          	blez	s1,80001d2a <virtio_disk_rw+0xbc>
                free_desc(idx[j]);
    80001cfa:	f9042503          	lw	a0,-112(s0)
    80001cfe:	00000097          	auipc	ra,0x0
    80001d02:	d82080e7          	jalr	-638(ra) # 80001a80 <free_desc>
            for (int j = 0; j < i; j++)
    80001d06:	4785                	li	a5,1
    80001d08:	0297d163          	bge	a5,s1,80001d2a <virtio_disk_rw+0xbc>
                free_desc(idx[j]);
    80001d0c:	f9442503          	lw	a0,-108(s0)
    80001d10:	00000097          	auipc	ra,0x0
    80001d14:	d70080e7          	jalr	-656(ra) # 80001a80 <free_desc>
            for (int j = 0; j < i; j++)
    80001d18:	4789                	li	a5,2
    80001d1a:	0097d863          	bge	a5,s1,80001d2a <virtio_disk_rw+0xbc>
                free_desc(idx[j]);
    80001d1e:	f9842503          	lw	a0,-104(s0)
    80001d22:	00000097          	auipc	ra,0x0
    80001d26:	d5e080e7          	jalr	-674(ra) # 80001a80 <free_desc>
    int idx[3];
    while (1) {
        if (alloc3_desc(idx) == 0) {
            break;
        }
        sleep(&disk.free[0], &disk.vdisk_lock);
    80001d2a:	0004c597          	auipc	a1,0x4c
    80001d2e:	3fe58593          	addi	a1,a1,1022 # 8004e128 <disk+0x2128>
    80001d32:	0004c517          	auipc	a0,0x4c
    80001d36:	2e650513          	addi	a0,a0,742 # 8004e018 <disk+0x2018>
    80001d3a:	fffff097          	auipc	ra,0xfffff
    80001d3e:	bd8080e7          	jalr	-1064(ra) # 80000912 <sleep>
    for (int i = 0; i < 3; i++) {
    80001d42:	f9040713          	addi	a4,s0,-112
    80001d46:	84ce                	mv	s1,s3
    80001d48:	bf41                	j	80001cd8 <virtio_disk_rw+0x6a>
    // format the three descriptors.
    // qemu's virtio-blk.c reads them.
    struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

    if (write)
        buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80001d4a:	20058713          	addi	a4,a1,512
    80001d4e:	00471693          	slli	a3,a4,0x4
    80001d52:	0004a717          	auipc	a4,0x4a
    80001d56:	2ae70713          	addi	a4,a4,686 # 8004c000 <disk>
    80001d5a:	9736                	add	a4,a4,a3
    80001d5c:	4685                	li	a3,1
    80001d5e:	0ad72423          	sw	a3,168(a4)
    else
        buf0->type = VIRTIO_BLK_T_IN; // read the disk
    buf0->reserved = 0;
    80001d62:	20058713          	addi	a4,a1,512
    80001d66:	00471693          	slli	a3,a4,0x4
    80001d6a:	0004a717          	auipc	a4,0x4a
    80001d6e:	29670713          	addi	a4,a4,662 # 8004c000 <disk>
    80001d72:	9736                	add	a4,a4,a3
    80001d74:	0a072623          	sw	zero,172(a4)
    buf0->sector = sector;
    80001d78:	0b973823          	sd	s9,176(a4)

    disk.desc[idx[0]].addr = (uint64) buf0;
    80001d7c:	7679                	lui	a2,0xffffe
    80001d7e:	963e                	add	a2,a2,a5
    80001d80:	0004c697          	auipc	a3,0x4c
    80001d84:	28068693          	addi	a3,a3,640 # 8004e000 <disk+0x2000>
    80001d88:	6298                	ld	a4,0(a3)
    80001d8a:	9732                	add	a4,a4,a2
    80001d8c:	e308                	sd	a0,0(a4)
    disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80001d8e:	6298                	ld	a4,0(a3)
    80001d90:	9732                	add	a4,a4,a2
    80001d92:	4541                	li	a0,16
    80001d94:	c708                	sw	a0,8(a4)
    disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80001d96:	6298                	ld	a4,0(a3)
    80001d98:	9732                	add	a4,a4,a2
    80001d9a:	4505                	li	a0,1
    80001d9c:	00a71623          	sh	a0,12(a4)
    disk.desc[idx[0]].next = idx[1];
    80001da0:	f9442703          	lw	a4,-108(s0)
    80001da4:	6288                	ld	a0,0(a3)
    80001da6:	962a                	add	a2,a2,a0
    80001da8:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ff925de>

    disk.desc[idx[1]].addr = (uint64) b->data;
    80001dac:	0712                	slli	a4,a4,0x4
    80001dae:	6290                	ld	a2,0(a3)
    80001db0:	963a                	add	a2,a2,a4
    80001db2:	04c90513          	addi	a0,s2,76
    80001db6:	e208                	sd	a0,0(a2)
    disk.desc[idx[1]].len = BSIZE;
    80001db8:	6294                	ld	a3,0(a3)
    80001dba:	96ba                	add	a3,a3,a4
    80001dbc:	40000613          	li	a2,1024
    80001dc0:	c690                	sw	a2,8(a3)
    if (write)
    80001dc2:	140d0063          	beqz	s10,80001f02 <virtio_disk_rw+0x294>
        disk.desc[idx[1]].flags = 0; // device reads b->data
    80001dc6:	0004c697          	auipc	a3,0x4c
    80001dca:	23a6b683          	ld	a3,570(a3) # 8004e000 <disk+0x2000>
    80001dce:	96ba                	add	a3,a3,a4
    80001dd0:	00069623          	sh	zero,12(a3)
    else
        disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80001dd4:	0004a817          	auipc	a6,0x4a
    80001dd8:	22c80813          	addi	a6,a6,556 # 8004c000 <disk>
    80001ddc:	0004c517          	auipc	a0,0x4c
    80001de0:	22450513          	addi	a0,a0,548 # 8004e000 <disk+0x2000>
    80001de4:	6114                	ld	a3,0(a0)
    80001de6:	96ba                	add	a3,a3,a4
    80001de8:	00c6d603          	lhu	a2,12(a3)
    80001dec:	00166613          	ori	a2,a2,1
    80001df0:	00c69623          	sh	a2,12(a3)
    disk.desc[idx[1]].next = idx[2];
    80001df4:	f9842683          	lw	a3,-104(s0)
    80001df8:	6110                	ld	a2,0(a0)
    80001dfa:	9732                	add	a4,a4,a2
    80001dfc:	00d71723          	sh	a3,14(a4)

    disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80001e00:	20058613          	addi	a2,a1,512
    80001e04:	0612                	slli	a2,a2,0x4
    80001e06:	9642                	add	a2,a2,a6
    80001e08:	577d                	li	a4,-1
    80001e0a:	02e60823          	sb	a4,48(a2)
    disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80001e0e:	00469713          	slli	a4,a3,0x4
    80001e12:	6114                	ld	a3,0(a0)
    80001e14:	96ba                	add	a3,a3,a4
    80001e16:	03078793          	addi	a5,a5,48
    80001e1a:	97c2                	add	a5,a5,a6
    80001e1c:	e29c                	sd	a5,0(a3)
    disk.desc[idx[2]].len = 1;
    80001e1e:	611c                	ld	a5,0(a0)
    80001e20:	97ba                	add	a5,a5,a4
    80001e22:	4685                	li	a3,1
    80001e24:	c794                	sw	a3,8(a5)
    disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80001e26:	611c                	ld	a5,0(a0)
    80001e28:	97ba                	add	a5,a5,a4
    80001e2a:	4809                	li	a6,2
    80001e2c:	01079623          	sh	a6,12(a5)
    disk.desc[idx[2]].next = 0;
    80001e30:	611c                	ld	a5,0(a0)
    80001e32:	973e                	add	a4,a4,a5
    80001e34:	00071723          	sh	zero,14(a4)

    // record struct buf for virtio_disk_intr().
    b->disk = 1;
    80001e38:	00d92223          	sw	a3,4(s2)
    disk.info[idx[0]].b = b;
    80001e3c:	03263423          	sd	s2,40(a2)

    // tell the device the first index in our chain of descriptors.
    disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80001e40:	6518                	ld	a4,8(a0)
    80001e42:	00275783          	lhu	a5,2(a4)
    80001e46:	8b9d                	andi	a5,a5,7
    80001e48:	0786                	slli	a5,a5,0x1
    80001e4a:	97ba                	add	a5,a5,a4
    80001e4c:	00b79223          	sh	a1,4(a5)

    __sync_synchronize();
    80001e50:	0ff0000f          	fence

    // tell the device another avail ring entry is available.
    disk.avail->idx += 1; // not % NUM ...
    80001e54:	6518                	ld	a4,8(a0)
    80001e56:	00275783          	lhu	a5,2(a4)
    80001e5a:	2785                	addiw	a5,a5,1
    80001e5c:	00f71123          	sh	a5,2(a4)

    __sync_synchronize();
    80001e60:	0ff0000f          	fence

    *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80001e64:	100017b7          	lui	a5,0x10001
    80001e68:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

    // Wait for virtio_disk_intr() to say request has finished.
    while (b->disk == 1) {
    80001e6c:	00492703          	lw	a4,4(s2)
    80001e70:	4785                	li	a5,1
    80001e72:	02f71163          	bne	a4,a5,80001e94 <virtio_disk_rw+0x226>
        sleep(b, &disk.vdisk_lock);
    80001e76:	0004c997          	auipc	s3,0x4c
    80001e7a:	2b298993          	addi	s3,s3,690 # 8004e128 <disk+0x2128>
    while (b->disk == 1) {
    80001e7e:	4485                	li	s1,1
        sleep(b, &disk.vdisk_lock);
    80001e80:	85ce                	mv	a1,s3
    80001e82:	854a                	mv	a0,s2
    80001e84:	fffff097          	auipc	ra,0xfffff
    80001e88:	a8e080e7          	jalr	-1394(ra) # 80000912 <sleep>
    while (b->disk == 1) {
    80001e8c:	00492783          	lw	a5,4(s2)
    80001e90:	fe9788e3          	beq	a5,s1,80001e80 <virtio_disk_rw+0x212>
    }

    disk.info[idx[0]].b = 0;
    80001e94:	f9042903          	lw	s2,-112(s0)
    80001e98:	20090793          	addi	a5,s2,512
    80001e9c:	00479713          	slli	a4,a5,0x4
    80001ea0:	0004a797          	auipc	a5,0x4a
    80001ea4:	16078793          	addi	a5,a5,352 # 8004c000 <disk>
    80001ea8:	97ba                	add	a5,a5,a4
    80001eaa:	0207b423          	sd	zero,40(a5)
        int flag = disk.desc[i].flags;
    80001eae:	0004c997          	auipc	s3,0x4c
    80001eb2:	15298993          	addi	s3,s3,338 # 8004e000 <disk+0x2000>
    80001eb6:	00491713          	slli	a4,s2,0x4
    80001eba:	0009b783          	ld	a5,0(s3)
    80001ebe:	97ba                	add	a5,a5,a4
    80001ec0:	00c7d483          	lhu	s1,12(a5)
        int nxt = disk.desc[i].next;
    80001ec4:	854a                	mv	a0,s2
    80001ec6:	00e7d903          	lhu	s2,14(a5)
        free_desc(i);
    80001eca:	00000097          	auipc	ra,0x0
    80001ece:	bb6080e7          	jalr	-1098(ra) # 80001a80 <free_desc>
        if (flag & VRING_DESC_F_NEXT)
    80001ed2:	8885                	andi	s1,s1,1
    80001ed4:	f0ed                	bnez	s1,80001eb6 <virtio_disk_rw+0x248>
    free_chain(idx[0]);
    spin_unlock(&disk.vdisk_lock);
    80001ed6:	0004c517          	auipc	a0,0x4c
    80001eda:	25250513          	addi	a0,a0,594 # 8004e128 <disk+0x2128>
    80001ede:	00001097          	auipc	ra,0x1
    80001ee2:	442080e7          	jalr	1090(ra) # 80003320 <spin_unlock>
}
    80001ee6:	70a6                	ld	ra,104(sp)
    80001ee8:	7406                	ld	s0,96(sp)
    80001eea:	64e6                	ld	s1,88(sp)
    80001eec:	6946                	ld	s2,80(sp)
    80001eee:	69a6                	ld	s3,72(sp)
    80001ef0:	6a06                	ld	s4,64(sp)
    80001ef2:	7ae2                	ld	s5,56(sp)
    80001ef4:	7b42                	ld	s6,48(sp)
    80001ef6:	7ba2                	ld	s7,40(sp)
    80001ef8:	7c02                	ld	s8,32(sp)
    80001efa:	6ce2                	ld	s9,24(sp)
    80001efc:	6d42                	ld	s10,16(sp)
    80001efe:	6165                	addi	sp,sp,112
    80001f00:	8082                	ret
        disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80001f02:	0004c697          	auipc	a3,0x4c
    80001f06:	0fe6b683          	ld	a3,254(a3) # 8004e000 <disk+0x2000>
    80001f0a:	96ba                	add	a3,a3,a4
    80001f0c:	4609                	li	a2,2
    80001f0e:	00c69623          	sh	a2,12(a3)
    80001f12:	b5c9                	j	80001dd4 <virtio_disk_rw+0x166>
    struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80001f14:	f9042583          	lw	a1,-112(s0)
    80001f18:	20058793          	addi	a5,a1,512
    80001f1c:	0792                	slli	a5,a5,0x4
    80001f1e:	0004a517          	auipc	a0,0x4a
    80001f22:	18a50513          	addi	a0,a0,394 # 8004c0a8 <disk+0xa8>
    80001f26:	953e                	add	a0,a0,a5
    if (write)
    80001f28:	e20d11e3          	bnez	s10,80001d4a <virtio_disk_rw+0xdc>
        buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80001f2c:	20058713          	addi	a4,a1,512
    80001f30:	00471693          	slli	a3,a4,0x4
    80001f34:	0004a717          	auipc	a4,0x4a
    80001f38:	0cc70713          	addi	a4,a4,204 # 8004c000 <disk>
    80001f3c:	9736                	add	a4,a4,a3
    80001f3e:	0a072423          	sw	zero,168(a4)
    80001f42:	b505                	j	80001d62 <virtio_disk_rw+0xf4>

0000000080001f44 <virtio_disk_intr>:

void
virtio_disk_intr() {
    80001f44:	7179                	addi	sp,sp,-48
    80001f46:	f406                	sd	ra,40(sp)
    80001f48:	f022                	sd	s0,32(sp)
    80001f4a:	ec26                	sd	s1,24(sp)
    80001f4c:	e84a                	sd	s2,16(sp)
    80001f4e:	e44e                	sd	s3,8(sp)
    80001f50:	e052                	sd	s4,0(sp)
    80001f52:	1800                	addi	s0,sp,48
    spin_lock(&disk.vdisk_lock);
    80001f54:	0004c517          	auipc	a0,0x4c
    80001f58:	1d450513          	addi	a0,a0,468 # 8004e128 <disk+0x2128>
    80001f5c:	00001097          	auipc	ra,0x1
    80001f60:	2f0080e7          	jalr	752(ra) # 8000324c <spin_lock>
    // we've seen this interrupt, which the following line does.
    // this may race with the device writing new entries to
    // the "used" ring, in which case we may process the new
    // completion entries in this interrupt, and have nothing to do
    // in the next interrupt, which is harmless.
    *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80001f64:	10001737          	lui	a4,0x10001
    80001f68:	533c                	lw	a5,96(a4)
    80001f6a:	8b8d                	andi	a5,a5,3
    80001f6c:	d37c                	sw	a5,100(a4)

    __sync_synchronize();
    80001f6e:	0ff0000f          	fence

    // the device increments disk.used->idx when it
    // adds an entry to the used ring.
    while (disk.used_idx != disk.used->idx) {
    80001f72:	0004c797          	auipc	a5,0x4c
    80001f76:	08e78793          	addi	a5,a5,142 # 8004e000 <disk+0x2000>
    80001f7a:	6b94                	ld	a3,16(a5)
    80001f7c:	0207d703          	lhu	a4,32(a5)
    80001f80:	0026d783          	lhu	a5,2(a3)
    80001f84:	06f70e63          	beq	a4,a5,80002000 <virtio_disk_intr+0xbc>
        __sync_synchronize();
        int id = disk.used->ring[disk.used_idx % NUM].id;
    80001f88:	0004a997          	auipc	s3,0x4a
    80001f8c:	07898993          	addi	s3,s3,120 # 8004c000 <disk>
    80001f90:	0004c917          	auipc	s2,0x4c
    80001f94:	07090913          	addi	s2,s2,112 # 8004e000 <disk+0x2000>

        if (disk.info[id].status != 0)
            panic("virtio_disk_intr status");
    80001f98:	00003a17          	auipc	s4,0x3
    80001f9c:	270a0a13          	addi	s4,s4,624 # 80005208 <digits+0x120>
    80001fa0:	a835                	j	80001fdc <virtio_disk_intr+0x98>
    80001fa2:	8552                	mv	a0,s4
    80001fa4:	fffff097          	auipc	ra,0xfffff
    80001fa8:	2da080e7          	jalr	730(ra) # 8000127e <panic>

        struct buf *b = disk.info[id].b;
    80001fac:	20048493          	addi	s1,s1,512 # 10001200 <_entry-0x6fffee00>
    80001fb0:	0492                	slli	s1,s1,0x4
    80001fb2:	94ce                	add	s1,s1,s3
    80001fb4:	7488                	ld	a0,40(s1)
        b->disk = 0;   // disk is done with buf
    80001fb6:	00052223          	sw	zero,4(a0)
        wakeup(b);
    80001fba:	fffff097          	auipc	ra,0xfffff
    80001fbe:	a54080e7          	jalr	-1452(ra) # 80000a0e <wakeup>

        disk.used_idx += 1;
    80001fc2:	02095783          	lhu	a5,32(s2)
    80001fc6:	2785                	addiw	a5,a5,1
    80001fc8:	17c2                	slli	a5,a5,0x30
    80001fca:	93c1                	srli	a5,a5,0x30
    80001fcc:	02f91023          	sh	a5,32(s2)
    while (disk.used_idx != disk.used->idx) {
    80001fd0:	01093703          	ld	a4,16(s2)
    80001fd4:	00275703          	lhu	a4,2(a4) # 10001002 <_entry-0x6fffeffe>
    80001fd8:	02f70463          	beq	a4,a5,80002000 <virtio_disk_intr+0xbc>
        __sync_synchronize();
    80001fdc:	0ff0000f          	fence
        int id = disk.used->ring[disk.used_idx % NUM].id;
    80001fe0:	01093703          	ld	a4,16(s2)
    80001fe4:	02095783          	lhu	a5,32(s2)
    80001fe8:	8b9d                	andi	a5,a5,7
    80001fea:	078e                	slli	a5,a5,0x3
    80001fec:	97ba                	add	a5,a5,a4
    80001fee:	43c4                	lw	s1,4(a5)
        if (disk.info[id].status != 0)
    80001ff0:	20048793          	addi	a5,s1,512
    80001ff4:	0792                	slli	a5,a5,0x4
    80001ff6:	97ce                	add	a5,a5,s3
    80001ff8:	0307c783          	lbu	a5,48(a5)
    80001ffc:	dbc5                	beqz	a5,80001fac <virtio_disk_intr+0x68>
    80001ffe:	b755                	j	80001fa2 <virtio_disk_intr+0x5e>
    }
    spin_unlock(&disk.vdisk_lock);
    80002000:	0004c517          	auipc	a0,0x4c
    80002004:	12850513          	addi	a0,a0,296 # 8004e128 <disk+0x2128>
    80002008:	00001097          	auipc	ra,0x1
    8000200c:	318080e7          	jalr	792(ra) # 80003320 <spin_unlock>
}
    80002010:	70a2                	ld	ra,40(sp)
    80002012:	7402                	ld	s0,32(sp)
    80002014:	64e2                	ld	s1,24(sp)
    80002016:	6942                	ld	s2,16(sp)
    80002018:	69a2                	ld	s3,8(sp)
    8000201a:	6a02                	ld	s4,0(sp)
    8000201c:	6145                	addi	sp,sp,48
    8000201e:	8082                	ret

0000000080002020 <fstest>:
#include "file.h"
#include "virtio.h"
#include "../defs.h"
#include "fstest.h"

void fstest() {
    80002020:	715d                	addi	sp,sp,-80
    80002022:	e486                	sd	ra,72(sp)
    80002024:	e0a2                	sd	s0,64(sp)
    80002026:	fc26                	sd	s1,56(sp)
    80002028:	f84a                	sd	s2,48(sp)
    8000202a:	0880                	addi	s0,sp,80
    struct inode *inode;
    struct superblock sb;
    read_superblock(&sb);
    8000202c:	fc840513          	addi	a0,s0,-56
    80002030:	00000097          	auipc	ra,0x0
    80002034:	2f4080e7          	jalr	756(ra) # 80002324 <read_superblock>
    inode = alloc_inode(T_FILE);
    80002038:	4509                	li	a0,2
    8000203a:	00000097          	auipc	ra,0x0
    8000203e:	6ca080e7          	jalr	1738(ra) # 80002704 <alloc_inode>
    80002042:	84aa                	mv	s1,a0
    printf("测试inode能否读写");
    80002044:	00003517          	auipc	a0,0x3
    80002048:	1dc50513          	addi	a0,a0,476 # 80005220 <digits+0x138>
    8000204c:	fffff097          	auipc	ra,0xfffff
    80002050:	16e080e7          	jalr	366(ra) # 800011ba <printf>
    char *str = "hello world!!";
    write_inode(inode, (uint64) str, 0, strlen(str));
    80002054:	00003917          	auipc	s2,0x3
    80002058:	1e490913          	addi	s2,s2,484 # 80005238 <digits+0x150>
    8000205c:	854a                	mv	a0,s2
    8000205e:	fffff097          	auipc	ra,0xfffff
    80002062:	d50080e7          	jalr	-688(ra) # 80000dae <strlen>
    80002066:	0005069b          	sext.w	a3,a0
    8000206a:	4601                	li	a2,0
    8000206c:	85ca                	mv	a1,s2
    8000206e:	8526                	mv	a0,s1
    80002070:	00001097          	auipc	ra,0x1
    80002074:	b36080e7          	jalr	-1226(ra) # 80002ba6 <write_inode>
    char s[20];
    read_inode(inode, (uint64) s, 0, 30);
    80002078:	46f9                	li	a3,30
    8000207a:	4601                	li	a2,0
    8000207c:	fb040593          	addi	a1,s0,-80
    80002080:	8526                	mv	a0,s1
    80002082:	00001097          	auipc	ra,0x1
    80002086:	a5a080e7          	jalr	-1446(ra) # 80002adc <read_inode>
    printf("%s\n", s);
    8000208a:	fb040593          	addi	a1,s0,-80
    8000208e:	00003517          	auipc	a0,0x3
    80002092:	02a50513          	addi	a0,a0,42 # 800050b8 <etext+0xb8>
    80002096:	fffff097          	auipc	ra,0xfffff
    8000209a:	124080e7          	jalr	292(ra) # 800011ba <printf>
}
    8000209e:	60a6                	ld	ra,72(sp)
    800020a0:	6406                	ld	s0,64(sp)
    800020a2:	74e2                	ld	s1,56(sp)
    800020a4:	7942                	ld	s2,48(sp)
    800020a6:	6161                	addi	sp,sp,80
    800020a8:	8082                	ret

00000000800020aa <dirtest>:

// 输出根目录下的direntry
void dirtest() {
    800020aa:	be010113          	addi	sp,sp,-1056
    800020ae:	40113c23          	sd	ra,1048(sp)
    800020b2:	40813823          	sd	s0,1040(sp)
    800020b6:	40913423          	sd	s1,1032(sp)
    800020ba:	42010413          	addi	s0,sp,1056
    int off = 0;
    char str[1024];
    printf("aa\n");
    800020be:	00003517          	auipc	a0,0x3
    800020c2:	18a50513          	addi	a0,a0,394 # 80005248 <digits+0x160>
    800020c6:	fffff097          	auipc	ra,0xfffff
    800020ca:	0f4080e7          	jalr	244(ra) # 800011ba <printf>
    struct inode *ip = namei("/readme.txt");
    800020ce:	00003517          	auipc	a0,0x3
    800020d2:	18250513          	addi	a0,a0,386 # 80005250 <digits+0x168>
    800020d6:	00001097          	auipc	ra,0x1
    800020da:	ece080e7          	jalr	-306(ra) # 80002fa4 <namei>
    800020de:	84aa                	mv	s1,a0
    printf("bb\n");
    800020e0:	00003517          	auipc	a0,0x3
    800020e4:	18050513          	addi	a0,a0,384 # 80005260 <digits+0x178>
    800020e8:	fffff097          	auipc	ra,0xfffff
    800020ec:	0d2080e7          	jalr	210(ra) # 800011ba <printf>
    lock_inode(ip);
    800020f0:	8526                	mv	a0,s1
    800020f2:	00001097          	auipc	ra,0x1
    800020f6:	8b6080e7          	jalr	-1866(ra) # 800029a8 <lock_inode>
    read_inode(ip, (uint64)str, off, 1024);
    800020fa:	40000693          	li	a3,1024
    800020fe:	4601                	li	a2,0
    80002100:	be040593          	addi	a1,s0,-1056
    80002104:	8526                	mv	a0,s1
    80002106:	00001097          	auipc	ra,0x1
    8000210a:	9d6080e7          	jalr	-1578(ra) # 80002adc <read_inode>
    printf("%s\n",str);
    8000210e:	be040593          	addi	a1,s0,-1056
    80002112:	00003517          	auipc	a0,0x3
    80002116:	fa650513          	addi	a0,a0,-90 # 800050b8 <etext+0xb8>
    8000211a:	fffff097          	auipc	ra,0xfffff
    8000211e:	0a0080e7          	jalr	160(ra) # 800011ba <printf>
    unlock_inode(ip);
    80002122:	8526                	mv	a0,s1
    80002124:	00001097          	auipc	ra,0x1
    80002128:	94a080e7          	jalr	-1718(ra) # 80002a6e <unlock_inode>
}
    8000212c:	41813083          	ld	ra,1048(sp)
    80002130:	41013403          	ld	s0,1040(sp)
    80002134:	40813483          	ld	s1,1032(sp)
    80002138:	42010113          	addi	sp,sp,1056
    8000213c:	8082                	ret

000000008000213e <exec>:
#include "../defs.h"
#include "elf.h"

static int loadseg(pte_t *pagetable, uint64 addr, struct inode *ip, uint offset, uint sz);

int exec(char *path, char **argv) {
    8000213e:	716d                	addi	sp,sp,-272
    80002140:	e606                	sd	ra,264(sp)
    80002142:	e222                	sd	s0,256(sp)
    80002144:	fda6                	sd	s1,248(sp)
    80002146:	f9ca                	sd	s2,240(sp)
    80002148:	f5ce                	sd	s3,232(sp)
    8000214a:	f1d2                	sd	s4,224(sp)
    8000214c:	edd6                	sd	s5,216(sp)
    8000214e:	e9da                	sd	s6,208(sp)
    80002150:	e5de                	sd	s7,200(sp)
    80002152:	e1e2                	sd	s8,192(sp)
    80002154:	fd66                	sd	s9,184(sp)
    80002156:	f96a                	sd	s10,176(sp)
    80002158:	f56e                	sd	s11,168(sp)
    8000215a:	0a00                	addi	s0,sp,272
    8000215c:	84aa                	mv	s1,a0
    uint64 sz = 0;
    struct elfhdr elf;
    struct inode *ip;
    struct proghdr ph;
    pagetable_t pagetable = 0;
    struct proc *p = myproc();
    8000215e:	ffffe097          	auipc	ra,0xffffe
    80002162:	6b2080e7          	jalr	1714(ra) # 80000810 <myproc>
    80002166:	f0a43023          	sd	a0,-256(s0)


    if((pagetable = proc_pagetable(p))==0){
    8000216a:	ffffe097          	auipc	ra,0xffffe
    8000216e:	4ce080e7          	jalr	1230(ra) # 80000638 <proc_pagetable>
    80002172:	18050963          	beqz	a0,80002304 <exec+0x1c6>
    80002176:	8b2a                	mv	s6,a0
        return 0;
    }

    if ((ip = namei(path)) == 0) {
    80002178:	8526                	mv	a0,s1
    8000217a:	00001097          	auipc	ra,0x1
    8000217e:	e2a080e7          	jalr	-470(ra) # 80002fa4 <namei>
    80002182:	8a2a                	mv	s4,a0
    80002184:	18050063          	beqz	a0,80002304 <exec+0x1c6>
        return 0;
    }
    lock_inode(ip);
    80002188:	00001097          	auipc	ra,0x1
    8000218c:	820080e7          	jalr	-2016(ra) # 800029a8 <lock_inode>

    // 检查ELF头
    if (read_inode(ip, (uint64) &elf, 0, sizeof(elf)) != sizeof(elf))
    80002190:	04000693          	li	a3,64
    80002194:	4601                	li	a2,0
    80002196:	f5040593          	addi	a1,s0,-176
    8000219a:	8552                	mv	a0,s4
    8000219c:	00001097          	auipc	ra,0x1
    800021a0:	940080e7          	jalr	-1728(ra) # 80002adc <read_inode>
    800021a4:	04000793          	li	a5,64
    800021a8:	14f51663          	bne	a0,a5,800022f4 <exec+0x1b6>
        goto bad;
    if (elf.magic != ELF_MAGIC)
    800021ac:	f5042703          	lw	a4,-176(s0)
    800021b0:	464c47b7          	lui	a5,0x464c4
    800021b4:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800021b8:	12f71e63          	bne	a4,a5,800022f4 <exec+0x1b6>
        goto bad;

    // 加载程序到内存中
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800021bc:	f7042983          	lw	s3,-144(s0)
    800021c0:	f8845783          	lhu	a5,-120(s0)
    800021c4:	c7fd                	beqz	a5,800022b2 <exec+0x174>
    uint64 sz = 0;
    800021c6:	f0043423          	sd	zero,-248(s0)
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800021ca:	4c01                	li	s8,0
            goto bad;
        uint64 sz1;
        if ((sz1 = user_vm_alloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
            goto bad;
        sz = sz1;
        if (ph.vaddr % PGSIZE != 0)
    800021cc:	6785                	lui	a5,0x1
    800021ce:	17fd                	addi	a5,a5,-1
    800021d0:	eef43c23          	sd	a5,-264(s0)
    800021d4:	a0b5                	j	80002240 <exec+0x102>
        panic("loadseg: va must be page aligned");

    for (i = 0; i < sz; i += PGSIZE) {
        pa = walkaddr(pagetable, va + i);
        if (pa == 0)
            panic("loadseg: address should exist");
    800021d6:	00003517          	auipc	a0,0x3
    800021da:	09250513          	addi	a0,a0,146 # 80005268 <digits+0x180>
    800021de:	fffff097          	auipc	ra,0xfffff
    800021e2:	0a0080e7          	jalr	160(ra) # 8000127e <panic>
    800021e6:	a081                	j	80002226 <exec+0xe8>
        if (sz - i < PGSIZE)
            n = sz - i;
        else
            n = PGSIZE;
        if (read_inode(ip, (uint64) pa, offset + i, n) != n)
    800021e8:	000b869b          	sext.w	a3,s7
    800021ec:	009d863b          	addw	a2,s11,s1
    800021f0:	85ca                	mv	a1,s2
    800021f2:	8552                	mv	a0,s4
    800021f4:	00001097          	auipc	ra,0x1
    800021f8:	8e8080e7          	jalr	-1816(ra) # 80002adc <read_inode>
    800021fc:	2501                	sext.w	a0,a0
    800021fe:	0eab9b63          	bne	s7,a0,800022f4 <exec+0x1b6>
    for (i = 0; i < sz; i += PGSIZE) {
    80002202:	6785                	lui	a5,0x1
    80002204:	9cbd                	addw	s1,s1,a5
    80002206:	77fd                	lui	a5,0xfffff
    80002208:	01578abb          	addw	s5,a5,s5
    8000220c:	0394f363          	bgeu	s1,s9,80002232 <exec+0xf4>
        pa = walkaddr(pagetable, va + i);
    80002210:	02049593          	slli	a1,s1,0x20
    80002214:	9181                	srli	a1,a1,0x20
    80002216:	95ea                	add	a1,a1,s10
    80002218:	855a                	mv	a0,s6
    8000221a:	fffff097          	auipc	ra,0xfffff
    8000221e:	352080e7          	jalr	850(ra) # 8000156c <walkaddr>
    80002222:	892a                	mv	s2,a0
        if (pa == 0)
    80002224:	d94d                	beqz	a0,800021d6 <exec+0x98>
            n = PGSIZE;
    80002226:	6b85                	lui	s7,0x1
        if (sz - i < PGSIZE)
    80002228:	6785                	lui	a5,0x1
    8000222a:	fafaffe3          	bgeu	s5,a5,800021e8 <exec+0xaa>
            n = sz - i;
    8000222e:	8bd6                	mv	s7,s5
    80002230:	bf65                	j	800021e8 <exec+0xaa>
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80002232:	2c05                	addiw	s8,s8,1
    80002234:	0389899b          	addiw	s3,s3,56
    80002238:	f8845783          	lhu	a5,-120(s0)
    8000223c:	06fc5d63          	bge	s8,a5,800022b6 <exec+0x178>
        if (read_inode(ip, (uint64) &ph, off, sizeof(ph)) != sizeof(ph))
    80002240:	2981                	sext.w	s3,s3
    80002242:	03800693          	li	a3,56
    80002246:	864e                	mv	a2,s3
    80002248:	f1840593          	addi	a1,s0,-232
    8000224c:	8552                	mv	a0,s4
    8000224e:	00001097          	auipc	ra,0x1
    80002252:	88e080e7          	jalr	-1906(ra) # 80002adc <read_inode>
    80002256:	03800793          	li	a5,56
    8000225a:	08f51d63          	bne	a0,a5,800022f4 <exec+0x1b6>
        if (ph.type != ELF_PROG_LOAD)
    8000225e:	f1842703          	lw	a4,-232(s0)
    80002262:	4785                	li	a5,1
    80002264:	fcf717e3          	bne	a4,a5,80002232 <exec+0xf4>
        if (ph.memsz < ph.filesz)
    80002268:	f4043603          	ld	a2,-192(s0)
    8000226c:	f3843783          	ld	a5,-200(s0)
    80002270:	08f66263          	bltu	a2,a5,800022f4 <exec+0x1b6>
        if (ph.vaddr + ph.memsz < ph.vaddr)
    80002274:	f2843783          	ld	a5,-216(s0)
    80002278:	963e                	add	a2,a2,a5
    8000227a:	06f66d63          	bltu	a2,a5,800022f4 <exec+0x1b6>
        if ((sz1 = user_vm_alloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000227e:	f0843583          	ld	a1,-248(s0)
    80002282:	855a                	mv	a0,s6
    80002284:	fffff097          	auipc	ra,0xfffff
    80002288:	436080e7          	jalr	1078(ra) # 800016ba <user_vm_alloc>
    8000228c:	f0a43423          	sd	a0,-248(s0)
    80002290:	c135                	beqz	a0,800022f4 <exec+0x1b6>
        if (ph.vaddr % PGSIZE != 0)
    80002292:	f2843d03          	ld	s10,-216(s0)
    80002296:	ef843783          	ld	a5,-264(s0)
    8000229a:	00fd77b3          	and	a5,s10,a5
    8000229e:	ebb9                	bnez	a5,800022f4 <exec+0x1b6>
        if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800022a0:	f2042d83          	lw	s11,-224(s0)
    800022a4:	f3842c83          	lw	s9,-200(s0)
    for (i = 0; i < sz; i += PGSIZE) {
    800022a8:	f80c85e3          	beqz	s9,80002232 <exec+0xf4>
    800022ac:	8ae6                	mv	s5,s9
    800022ae:	4481                	li	s1,0
    800022b0:	b785                	j	80002210 <exec+0xd2>
    uint64 sz = 0;
    800022b2:	f0043423          	sd	zero,-248(s0)
    unlock_and_putback(ip);
    800022b6:	8552                	mv	a0,s4
    800022b8:	00000097          	auipc	ra,0x0
    800022bc:	7fc080e7          	jalr	2044(ra) # 80002ab4 <unlock_and_putback>
    sz = PGROUNDUP(sz);
    800022c0:	6605                	lui	a2,0x1
    800022c2:	fff60593          	addi	a1,a2,-1 # fff <_entry-0x7ffff001>
    800022c6:	f0843783          	ld	a5,-248(s0)
    800022ca:	95be                	add	a1,a1,a5
    800022cc:	77fd                	lui	a5,0xfffff
    800022ce:	8dfd                	and	a1,a1,a5
    if ((sz1 = user_vm_alloc(pagetable, sz, sz+PGSIZE)) == 0)
    800022d0:	962e                	add	a2,a2,a1
    800022d2:	855a                	mv	a0,s6
    800022d4:	fffff097          	auipc	ra,0xfffff
    800022d8:	3e6080e7          	jalr	998(ra) # 800016ba <user_vm_alloc>
    800022dc:	cd01                	beqz	a0,800022f4 <exec+0x1b6>
    p->pagetable = pagetable;
    800022de:	f0043683          	ld	a3,-256(s0)
    800022e2:	0566b423          	sd	s6,72(a3)
    p->trapframe->epc = elf.entry;
    800022e6:	62bc                	ld	a5,64(a3)
    800022e8:	f6843703          	ld	a4,-152(s0)
    800022ec:	ef98                	sd	a4,24(a5)
    p->trapframe->sp = sz;
    800022ee:	62bc                	ld	a5,64(a3)
    800022f0:	fb88                	sd	a0,48(a5)
    return 0;
    800022f2:	a809                	j	80002304 <exec+0x1c6>
    panic("exec");
    800022f4:	00003517          	auipc	a0,0x3
    800022f8:	f9450513          	addi	a0,a0,-108 # 80005288 <digits+0x1a0>
    800022fc:	fffff097          	auipc	ra,0xfffff
    80002300:	f82080e7          	jalr	-126(ra) # 8000127e <panic>
}
    80002304:	4501                	li	a0,0
    80002306:	60b2                	ld	ra,264(sp)
    80002308:	6412                	ld	s0,256(sp)
    8000230a:	74ee                	ld	s1,248(sp)
    8000230c:	794e                	ld	s2,240(sp)
    8000230e:	79ae                	ld	s3,232(sp)
    80002310:	7a0e                	ld	s4,224(sp)
    80002312:	6aee                	ld	s5,216(sp)
    80002314:	6b4e                	ld	s6,208(sp)
    80002316:	6bae                	ld	s7,200(sp)
    80002318:	6c0e                	ld	s8,192(sp)
    8000231a:	7cea                	ld	s9,184(sp)
    8000231c:	7d4a                	ld	s10,176(sp)
    8000231e:	7daa                	ld	s11,168(sp)
    80002320:	6151                	addi	sp,sp,272
    80002322:	8082                	ret

0000000080002324 <read_superblock>:

#define min(a, b) ((a) < (b) ? (a) : (b))
struct superblock sb;

// 读取超级块
void read_superblock(struct superblock *sb) {
    80002324:	b9010113          	addi	sp,sp,-1136
    80002328:	46113423          	sd	ra,1128(sp)
    8000232c:	46813023          	sd	s0,1120(sp)
    80002330:	44913c23          	sd	s1,1112(sp)
    80002334:	47010413          	addi	s0,sp,1136
    80002338:	84aa                	mv	s1,a0
    struct buf b;
    b.blockno = 1;
    8000233a:	4785                	li	a5,1
    8000233c:	b8f42e23          	sw	a5,-1124(s0)
    virtio_disk_rw(&b, 0);
    80002340:	4581                	li	a1,0
    80002342:	b9040513          	addi	a0,s0,-1136
    80002346:	00000097          	auipc	ra,0x0
    8000234a:	928080e7          	jalr	-1752(ra) # 80001c6e <virtio_disk_rw>
    memmove(sb, &b.data, sizeof(*sb));
    8000234e:	4661                	li	a2,24
    80002350:	bdc40593          	addi	a1,s0,-1060
    80002354:	8526                	mv	a0,s1
    80002356:	fffff097          	auipc	ra,0xfffff
    8000235a:	9fc080e7          	jalr	-1540(ra) # 80000d52 <memmove>
    return;
}
    8000235e:	46813083          	ld	ra,1128(sp)
    80002362:	46013403          	ld	s0,1120(sp)
    80002366:	45813483          	ld	s1,1112(sp)
    8000236a:	47010113          	addi	sp,sp,1136
    8000236e:	8082                	ret

0000000080002370 <init_fs>:

// 初始化文件系统
void init_fs() {
    80002370:	1101                	addi	sp,sp,-32
    80002372:	ec06                	sd	ra,24(sp)
    80002374:	e822                	sd	s0,16(sp)
    80002376:	e426                	sd	s1,8(sp)
    80002378:	1000                	addi	s0,sp,32
    read_superblock(&sb);
    8000237a:	0004d497          	auipc	s1,0x4d
    8000237e:	c8648493          	addi	s1,s1,-890 # 8004f000 <sb>
    80002382:	8526                	mv	a0,s1
    80002384:	00000097          	auipc	ra,0x0
    80002388:	fa0080e7          	jalr	-96(ra) # 80002324 <read_superblock>
    if (sb.magic != FSMAGIC) {
    8000238c:	4098                	lw	a4,0(s1)
    8000238e:	102037b7          	lui	a5,0x10203
    80002392:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002396:	00f71763          	bne	a4,a5,800023a4 <init_fs+0x34>
        panic("fs init");
    }
}
    8000239a:	60e2                	ld	ra,24(sp)
    8000239c:	6442                	ld	s0,16(sp)
    8000239e:	64a2                	ld	s1,8(sp)
    800023a0:	6105                	addi	sp,sp,32
    800023a2:	8082                	ret
        panic("fs init");
    800023a4:	00003517          	auipc	a0,0x3
    800023a8:	eec50513          	addi	a0,a0,-276 # 80005290 <digits+0x1a8>
    800023ac:	fffff097          	auipc	ra,0xfffff
    800023b0:	ed2080e7          	jalr	-302(ra) # 8000127e <panic>
}
    800023b4:	b7dd                	j	8000239a <init_fs+0x2a>

00000000800023b6 <zero_block>:
//
// 数据块，下面的block通常指数据块
//

// 格式化磁盘块中的数据
void zero_block(int blockno) {
    800023b6:	1101                	addi	sp,sp,-32
    800023b8:	ec06                	sd	ra,24(sp)
    800023ba:	e822                	sd	s0,16(sp)
    800023bc:	e426                	sd	s1,8(sp)
    800023be:	1000                	addi	s0,sp,32
    800023c0:	85aa                	mv	a1,a0
    struct buf *bp;
    bp = buf_read(0, blockno);
    800023c2:	4501                	li	a0,0
    800023c4:	00001097          	auipc	ra,0x1
    800023c8:	d58080e7          	jalr	-680(ra) # 8000311c <buf_read>
    800023cc:	84aa                	mv	s1,a0
    memset(bp->data, 0, BSIZE);
    800023ce:	40000613          	li	a2,1024
    800023d2:	4581                	li	a1,0
    800023d4:	04c50513          	addi	a0,a0,76
    800023d8:	fffff097          	auipc	ra,0xfffff
    800023dc:	954080e7          	jalr	-1708(ra) # 80000d2c <memset>
    buf_write(bp);
    800023e0:	8526                	mv	a0,s1
    800023e2:	00001097          	auipc	ra,0x1
    800023e6:	d6e080e7          	jalr	-658(ra) # 80003150 <buf_write>
    relse_buf(bp);
    800023ea:	8526                	mv	a0,s1
    800023ec:	00001097          	auipc	ra,0x1
    800023f0:	d7e080e7          	jalr	-642(ra) # 8000316a <relse_buf>
}
    800023f4:	60e2                	ld	ra,24(sp)
    800023f6:	6442                	ld	s0,16(sp)
    800023f8:	64a2                	ld	s1,8(sp)
    800023fa:	6105                	addi	sp,sp,32
    800023fc:	8082                	ret

00000000800023fe <alloc_disk_block>:

// 申请空闲的磁盘块, 且格式化为0，返回块号。
uint alloc_disk_block() {
    800023fe:	715d                	addi	sp,sp,-80
    80002400:	e486                	sd	ra,72(sp)
    80002402:	e0a2                	sd	s0,64(sp)
    80002404:	fc26                	sd	s1,56(sp)
    80002406:	f84a                	sd	s2,48(sp)
    80002408:	f44e                	sd	s3,40(sp)
    8000240a:	f052                	sd	s4,32(sp)
    8000240c:	ec56                	sd	s5,24(sp)
    8000240e:	e85a                	sd	s6,16(sp)
    80002410:	e45e                	sd	s7,8(sp)
    80002412:	0880                	addi	s0,sp,80
    int b, bi, m;
    struct buf *bitmap;

    for (b = 0; b < sb.size; b += BPB) { // 遍历bitmap
    80002414:	0004d797          	auipc	a5,0x4d
    80002418:	bf07a783          	lw	a5,-1040(a5) # 8004f004 <sb+0x4>
    8000241c:	c3e9                	beqz	a5,800024de <alloc_disk_block+0xe0>
    8000241e:	4a81                	li	s5,0
        bitmap = buf_read(0, BBLOCK(b, sb));
    80002420:	0004db17          	auipc	s6,0x4d
    80002424:	be0b0b13          	addi	s6,s6,-1056 # 8004f000 <sb>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) { //遍历bitmap的每一位
            m = 1 << (bi % 8);
    80002428:	4985                	li	s3,1
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) { //遍历bitmap的每一位
    8000242a:	6a09                	lui	s4,0x2
    for (b = 0; b < sb.size; b += BPB) { // 遍历bitmap
    8000242c:	6b89                	lui	s7,0x2
    8000242e:	a0b1                	j	8000247a <alloc_disk_block+0x7c>
            if ((bitmap->data[bi / 8] & m) == 0) { // 判断块是否被使用
                bitmap->data[bi / 8] |= m; // 标记块被使用
    80002430:	972a                	add	a4,a4,a0
    80002432:	8fd5                	or	a5,a5,a3
    80002434:	04f70623          	sb	a5,76(a4)
                relse_buf(bitmap);
    80002438:	00001097          	auipc	ra,0x1
    8000243c:	d32080e7          	jalr	-718(ra) # 8000316a <relse_buf>
                zero_block(b + bi);
    80002440:	854a                	mv	a0,s2
    80002442:	00000097          	auipc	ra,0x0
    80002446:	f74080e7          	jalr	-140(ra) # 800023b6 <zero_block>
        }
        relse_buf(bitmap);
    }
    panic("balloc: out of blocks");
    return 0;
}
    8000244a:	8526                	mv	a0,s1
    8000244c:	60a6                	ld	ra,72(sp)
    8000244e:	6406                	ld	s0,64(sp)
    80002450:	74e2                	ld	s1,56(sp)
    80002452:	7942                	ld	s2,48(sp)
    80002454:	79a2                	ld	s3,40(sp)
    80002456:	7a02                	ld	s4,32(sp)
    80002458:	6ae2                	ld	s5,24(sp)
    8000245a:	6b42                	ld	s6,16(sp)
    8000245c:	6ba2                	ld	s7,8(sp)
    8000245e:	6161                	addi	sp,sp,80
    80002460:	8082                	ret
        relse_buf(bitmap);
    80002462:	00001097          	auipc	ra,0x1
    80002466:	d08080e7          	jalr	-760(ra) # 8000316a <relse_buf>
    for (b = 0; b < sb.size; b += BPB) { // 遍历bitmap
    8000246a:	015b87bb          	addw	a5,s7,s5
    8000246e:	00078a9b          	sext.w	s5,a5
    80002472:	004b2703          	lw	a4,4(s6)
    80002476:	06eaf463          	bgeu	s5,a4,800024de <alloc_disk_block+0xe0>
        bitmap = buf_read(0, BBLOCK(b, sb));
    8000247a:	41fad79b          	sraiw	a5,s5,0x1f
    8000247e:	0137d79b          	srliw	a5,a5,0x13
    80002482:	015787bb          	addw	a5,a5,s5
    80002486:	40d7d79b          	sraiw	a5,a5,0xd
    8000248a:	014b2583          	lw	a1,20(s6)
    8000248e:	9dbd                	addw	a1,a1,a5
    80002490:	4501                	li	a0,0
    80002492:	00001097          	auipc	ra,0x1
    80002496:	c8a080e7          	jalr	-886(ra) # 8000311c <buf_read>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) { //遍历bitmap的每一位
    8000249a:	004b2803          	lw	a6,4(s6)
    8000249e:	000a849b          	sext.w	s1,s5
    800024a2:	4601                	li	a2,0
    800024a4:	0004891b          	sext.w	s2,s1
    800024a8:	fb04fde3          	bgeu	s1,a6,80002462 <alloc_disk_block+0x64>
            m = 1 << (bi % 8);
    800024ac:	41f6579b          	sraiw	a5,a2,0x1f
    800024b0:	01d7d69b          	srliw	a3,a5,0x1d
    800024b4:	00c6873b          	addw	a4,a3,a2
    800024b8:	00777793          	andi	a5,a4,7
    800024bc:	9f95                	subw	a5,a5,a3
    800024be:	00f997bb          	sllw	a5,s3,a5
            if ((bitmap->data[bi / 8] & m) == 0) { // 判断块是否被使用
    800024c2:	4037571b          	sraiw	a4,a4,0x3
    800024c6:	00e506b3          	add	a3,a0,a4
    800024ca:	04c6c683          	lbu	a3,76(a3)
    800024ce:	00d7f5b3          	and	a1,a5,a3
    800024d2:	ddb9                	beqz	a1,80002430 <alloc_disk_block+0x32>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) { //遍历bitmap的每一位
    800024d4:	2605                	addiw	a2,a2,1
    800024d6:	2485                	addiw	s1,s1,1
    800024d8:	fd4616e3          	bne	a2,s4,800024a4 <alloc_disk_block+0xa6>
    800024dc:	b759                	j	80002462 <alloc_disk_block+0x64>
    panic("balloc: out of blocks");
    800024de:	00003517          	auipc	a0,0x3
    800024e2:	dba50513          	addi	a0,a0,-582 # 80005298 <digits+0x1b0>
    800024e6:	fffff097          	auipc	ra,0xfffff
    800024ea:	d98080e7          	jalr	-616(ra) # 8000127e <panic>
    return 0;
    800024ee:	4481                	li	s1,0
    800024f0:	bfa9                	j	8000244a <alloc_disk_block+0x4c>

00000000800024f2 <free_disk_block>:

// 释放磁盘块, 通过重置bitmap对应位。
void free_disk_block(int blockno) {
    800024f2:	1101                	addi	sp,sp,-32
    800024f4:	ec06                	sd	ra,24(sp)
    800024f6:	e822                	sd	s0,16(sp)
    800024f8:	e426                	sd	s1,8(sp)
    800024fa:	e04a                	sd	s2,0(sp)
    800024fc:	1000                	addi	s0,sp,32
    struct buf *bitmap;
    int bi, m;
    bitmap = buf_read(0, BBLOCK(blockno, sb));
    800024fe:	41f5549b          	sraiw	s1,a0,0x1f
    80002502:	0134d91b          	srliw	s2,s1,0x13
    80002506:	00a904bb          	addw	s1,s2,a0
    8000250a:	40d4d59b          	sraiw	a1,s1,0xd
    8000250e:	0004d797          	auipc	a5,0x4d
    80002512:	b067a783          	lw	a5,-1274(a5) # 8004f014 <sb+0x14>
    80002516:	9dbd                	addw	a1,a1,a5
    80002518:	4501                	li	a0,0
    8000251a:	00001097          	auipc	ra,0x1
    8000251e:	c02080e7          	jalr	-1022(ra) # 8000311c <buf_read>
    bi = blockno % BPB;
    80002522:	14ce                	slli	s1,s1,0x33
    80002524:	90cd                	srli	s1,s1,0x33
    80002526:	412484bb          	subw	s1,s1,s2
    m = 1 << (bi % 8);
    bitmap->data[bi / 8] &= ~m;
    8000252a:	41f4d79b          	sraiw	a5,s1,0x1f
    8000252e:	01d7d79b          	srliw	a5,a5,0x1d
    80002532:	9cbd                	addw	s1,s1,a5
    80002534:	4034d71b          	sraiw	a4,s1,0x3
    80002538:	972a                	add	a4,a4,a0
    m = 1 << (bi % 8);
    8000253a:	889d                	andi	s1,s1,7
    8000253c:	9c9d                	subw	s1,s1,a5
    bitmap->data[bi / 8] &= ~m;
    8000253e:	4785                	li	a5,1
    80002540:	009794bb          	sllw	s1,a5,s1
    80002544:	fff4c493          	not	s1,s1
    80002548:	04c74783          	lbu	a5,76(a4)
    8000254c:	8cfd                	and	s1,s1,a5
    8000254e:	04970623          	sb	s1,76(a4)
    relse_buf(bitmap);
    80002552:	00001097          	auipc	ra,0x1
    80002556:	c18080e7          	jalr	-1000(ra) # 8000316a <relse_buf>
}
    8000255a:	60e2                	ld	ra,24(sp)
    8000255c:	6442                	ld	s0,16(sp)
    8000255e:	64a2                	ld	s1,8(sp)
    80002560:	6902                	ld	s2,0(sp)
    80002562:	6105                	addi	sp,sp,32
    80002564:	8082                	ret

0000000080002566 <init_inode_cache>:
    struct inode inode[NINODE];
} inode_cache;


// 初始化inode的缓存
void init_inode_cache() {
    80002566:	7179                	addi	sp,sp,-48
    80002568:	f406                	sd	ra,40(sp)
    8000256a:	f022                	sd	s0,32(sp)
    8000256c:	ec26                	sd	s1,24(sp)
    8000256e:	e84a                	sd	s2,16(sp)
    80002570:	e44e                	sd	s3,8(sp)
    80002572:	1800                	addi	s0,sp,48
    spinlock_init(&inode_cache.lock, "inode cache");
    80002574:	00003597          	auipc	a1,0x3
    80002578:	d3c58593          	addi	a1,a1,-708 # 800052b0 <digits+0x1c8>
    8000257c:	0004d517          	auipc	a0,0x4d
    80002580:	a9c50513          	addi	a0,a0,-1380 # 8004f018 <inode_cache>
    80002584:	00001097          	auipc	ra,0x1
    80002588:	c38080e7          	jalr	-968(ra) # 800031bc <spinlock_init>
    for (int i = 0; i < NINODE; i++) {
    8000258c:	0004d497          	auipc	s1,0x4d
    80002590:	ab448493          	addi	s1,s1,-1356 # 8004f040 <inode_cache+0x28>
    80002594:	0004e997          	auipc	s3,0x4e
    80002598:	53c98993          	addi	s3,s3,1340 # 80050ad0 <cache_lock+0x10>
        sleeplock_init(&inode_cache.inode[i].lock, "inode");
    8000259c:	00003917          	auipc	s2,0x3
    800025a0:	d2490913          	addi	s2,s2,-732 # 800052c0 <digits+0x1d8>
    800025a4:	85ca                	mv	a1,s2
    800025a6:	8526                	mv	a0,s1
    800025a8:	00001097          	auipc	ra,0x1
    800025ac:	dd4080e7          	jalr	-556(ra) # 8000337c <sleeplock_init>
    for (int i = 0; i < NINODE; i++) {
    800025b0:	08848493          	addi	s1,s1,136
    800025b4:	ff3498e3          	bne	s1,s3,800025a4 <init_inode_cache+0x3e>
    }
}
    800025b8:	70a2                	ld	ra,40(sp)
    800025ba:	7402                	ld	s0,32(sp)
    800025bc:	64e2                	ld	s1,24(sp)
    800025be:	6942                	ld	s2,16(sp)
    800025c0:	69a2                	ld	s3,8(sp)
    800025c2:	6145                	addi	sp,sp,48
    800025c4:	8082                	ret

00000000800025c6 <update_inode>:

// 将内存中的inode写入到磁盘中,
// 每次改变磁盘上的ip->xxx字段都需要调用该函数，
// 因为inode cache是write-through。
// 调用者必须持有ip->lock.
void update_inode(struct inode *ip) {
    800025c6:	1101                	addi	sp,sp,-32
    800025c8:	ec06                	sd	ra,24(sp)
    800025ca:	e822                	sd	s0,16(sp)
    800025cc:	e426                	sd	s1,8(sp)
    800025ce:	e04a                	sd	s2,0(sp)
    800025d0:	1000                	addi	s0,sp,32
    800025d2:	84aa                	mv	s1,a0
    struct buf *bp;
    struct dinode *dip;

    bp = buf_read(ip->dev, IBLOCK(ip->inum, sb));
    800025d4:	415c                	lw	a5,4(a0)
    800025d6:	0047d79b          	srliw	a5,a5,0x4
    800025da:	0004d597          	auipc	a1,0x4d
    800025de:	a365a583          	lw	a1,-1482(a1) # 8004f010 <sb+0x10>
    800025e2:	9dbd                	addw	a1,a1,a5
    800025e4:	4108                	lw	a0,0(a0)
    800025e6:	00001097          	auipc	ra,0x1
    800025ea:	b36080e7          	jalr	-1226(ra) # 8000311c <buf_read>
    800025ee:	892a                	mv	s2,a0
    dip = (struct dinode *) bp->data + ip->inum % IPB;
    800025f0:	04c50793          	addi	a5,a0,76
    800025f4:	40c8                	lw	a0,4(s1)
    800025f6:	893d                	andi	a0,a0,15
    800025f8:	051a                	slli	a0,a0,0x6
    800025fa:	953e                	add	a0,a0,a5
    dip->type = ip->type;
    800025fc:	04449703          	lh	a4,68(s1)
    80002600:	00e51023          	sh	a4,0(a0)
    dip->major = ip->major;
    80002604:	04649703          	lh	a4,70(s1)
    80002608:	00e51123          	sh	a4,2(a0)
    dip->minor = ip->minor;
    8000260c:	04849703          	lh	a4,72(s1)
    80002610:	00e51223          	sh	a4,4(a0)
    dip->nlink = ip->nlink;
    80002614:	04a49703          	lh	a4,74(s1)
    80002618:	00e51323          	sh	a4,6(a0)
    dip->size = ip->size;
    8000261c:	44f8                	lw	a4,76(s1)
    8000261e:	c518                	sw	a4,8(a0)
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002620:	03400613          	li	a2,52
    80002624:	05048593          	addi	a1,s1,80
    80002628:	0531                	addi	a0,a0,12
    8000262a:	ffffe097          	auipc	ra,0xffffe
    8000262e:	728080e7          	jalr	1832(ra) # 80000d52 <memmove>
    buf_write(bp);
    80002632:	854a                	mv	a0,s2
    80002634:	00001097          	auipc	ra,0x1
    80002638:	b1c080e7          	jalr	-1252(ra) # 80003150 <buf_write>
    relse_buf(bp);
    8000263c:	854a                	mv	a0,s2
    8000263e:	00001097          	auipc	ra,0x1
    80002642:	b2c080e7          	jalr	-1236(ra) # 8000316a <relse_buf>
}
    80002646:	60e2                	ld	ra,24(sp)
    80002648:	6442                	ld	s0,16(sp)
    8000264a:	64a2                	ld	s1,8(sp)
    8000264c:	6902                	ld	s2,0(sp)
    8000264e:	6105                	addi	sp,sp,32
    80002650:	8082                	ret

0000000080002652 <get_inode>:

// 通过inum从缓冲池中获取一个inode
struct inode *get_inode(int inum) {
    80002652:	7179                	addi	sp,sp,-48
    80002654:	f406                	sd	ra,40(sp)
    80002656:	f022                	sd	s0,32(sp)
    80002658:	ec26                	sd	s1,24(sp)
    8000265a:	e84a                	sd	s2,16(sp)
    8000265c:	e44e                	sd	s3,8(sp)
    8000265e:	1800                	addi	s0,sp,48
    80002660:	89aa                	mv	s3,a0
    struct inode *ip;
    struct inode *empty;
//    struct buf *bp;
//    struct dinode *dip;

    spin_lock(&inode_cache.lock);
    80002662:	0004d517          	auipc	a0,0x4d
    80002666:	9b650513          	addi	a0,a0,-1610 # 8004f018 <inode_cache>
    8000266a:	00001097          	auipc	ra,0x1
    8000266e:	be2080e7          	jalr	-1054(ra) # 8000324c <spin_lock>
    empty = 0;
    80002672:	4901                	li	s2,0
    for (ip = &inode_cache.inode[0]; ip < &inode_cache.inode[NINODE]; ip++) {
    80002674:	0004d497          	auipc	s1,0x4d
    80002678:	9bc48493          	addi	s1,s1,-1604 # 8004f030 <inode_cache+0x18>
        if (ip->ref > 0 && ip->inum == inum) {
    8000267c:	0009861b          	sext.w	a2,s3
    for (ip = &inode_cache.inode[0]; ip < &inode_cache.inode[NINODE]; ip++) {
    80002680:	0004e697          	auipc	a3,0x4e
    80002684:	44068693          	addi	a3,a3,1088 # 80050ac0 <cache_lock>
    80002688:	a039                	j	80002696 <get_inode+0x44>
            ip->ref++;
            spin_unlock(&inode_cache.lock);
            return ip;
        }
        if (empty == 0 && ip->ref == 0) { // 记住未使用缓冲项
    8000268a:	02090e63          	beqz	s2,800026c6 <get_inode+0x74>
    for (ip = &inode_cache.inode[0]; ip < &inode_cache.inode[NINODE]; ip++) {
    8000268e:	08848493          	addi	s1,s1,136
    80002692:	02d48d63          	beq	s1,a3,800026cc <get_inode+0x7a>
        if (ip->ref > 0 && ip->inum == inum) {
    80002696:	449c                	lw	a5,8(s1)
    80002698:	fef059e3          	blez	a5,8000268a <get_inode+0x38>
    8000269c:	40d8                	lw	a4,4(s1)
    8000269e:	fec716e3          	bne	a4,a2,8000268a <get_inode+0x38>
            ip->ref++;
    800026a2:	2785                	addiw	a5,a5,1
    800026a4:	c49c                	sw	a5,8(s1)
            spin_unlock(&inode_cache.lock);
    800026a6:	0004d517          	auipc	a0,0x4d
    800026aa:	97250513          	addi	a0,a0,-1678 # 8004f018 <inode_cache>
    800026ae:	00001097          	auipc	ra,0x1
    800026b2:	c72080e7          	jalr	-910(ra) # 80003320 <spin_unlock>
    ip->inum = inum;
    ip->ref = 1;
    ip->valid = 0;
    spin_unlock(&inode_cache.lock);
    return ip;
}
    800026b6:	8526                	mv	a0,s1
    800026b8:	70a2                	ld	ra,40(sp)
    800026ba:	7402                	ld	s0,32(sp)
    800026bc:	64e2                	ld	s1,24(sp)
    800026be:	6942                	ld	s2,16(sp)
    800026c0:	69a2                	ld	s3,8(sp)
    800026c2:	6145                	addi	sp,sp,48
    800026c4:	8082                	ret
        if (empty == 0 && ip->ref == 0) { // 记住未使用缓冲项
    800026c6:	f7e1                	bnez	a5,8000268e <get_inode+0x3c>
    800026c8:	8926                	mv	s2,s1
    800026ca:	b7d1                	j	8000268e <get_inode+0x3c>
    if (empty == 0) {
    800026cc:	02090363          	beqz	s2,800026f2 <get_inode+0xa0>
    ip->inum = inum;
    800026d0:	01392223          	sw	s3,4(s2)
    ip->ref = 1;
    800026d4:	4785                	li	a5,1
    800026d6:	00f92423          	sw	a5,8(s2)
    ip->valid = 0;
    800026da:	04092023          	sw	zero,64(s2)
    spin_unlock(&inode_cache.lock);
    800026de:	0004d517          	auipc	a0,0x4d
    800026e2:	93a50513          	addi	a0,a0,-1734 # 8004f018 <inode_cache>
    800026e6:	00001097          	auipc	ra,0x1
    800026ea:	c3a080e7          	jalr	-966(ra) # 80003320 <spin_unlock>
    return ip;
    800026ee:	84ca                	mv	s1,s2
    800026f0:	b7d9                	j	800026b6 <get_inode+0x64>
        panic("get_inode");
    800026f2:	00003517          	auipc	a0,0x3
    800026f6:	bd650513          	addi	a0,a0,-1066 # 800052c8 <digits+0x1e0>
    800026fa:	fffff097          	auipc	ra,0xfffff
    800026fe:	b84080e7          	jalr	-1148(ra) # 8000127e <panic>
    80002702:	b7f9                	j	800026d0 <get_inode+0x7e>

0000000080002704 <alloc_inode>:
struct inode *alloc_inode(short type) {
    80002704:	7139                	addi	sp,sp,-64
    80002706:	fc06                	sd	ra,56(sp)
    80002708:	f822                	sd	s0,48(sp)
    8000270a:	f426                	sd	s1,40(sp)
    8000270c:	f04a                	sd	s2,32(sp)
    8000270e:	ec4e                	sd	s3,24(sp)
    80002710:	e852                	sd	s4,16(sp)
    80002712:	e456                	sd	s5,8(sp)
    80002714:	e05a                	sd	s6,0(sp)
    80002716:	0080                	addi	s0,sp,64
    for (inum = 1; inum < sb.ninodes; inum++) {
    80002718:	0004d717          	auipc	a4,0x4d
    8000271c:	8f472703          	lw	a4,-1804(a4) # 8004f00c <sb+0xc>
    80002720:	4785                	li	a5,1
    80002722:	04e7f963          	bgeu	a5,a4,80002774 <alloc_inode+0x70>
    80002726:	8b2a                	mv	s6,a0
    80002728:	4905                	li	s2,1
        bp = buf_read(0, IBLOCK(inum, sb));
    8000272a:	0004da97          	auipc	s5,0x4d
    8000272e:	8d6a8a93          	addi	s5,s5,-1834 # 8004f000 <sb>
    80002732:	00090a1b          	sext.w	s4,s2
    80002736:	00495593          	srli	a1,s2,0x4
    8000273a:	010aa783          	lw	a5,16(s5)
    8000273e:	9dbd                	addw	a1,a1,a5
    80002740:	4501                	li	a0,0
    80002742:	00001097          	auipc	ra,0x1
    80002746:	9da080e7          	jalr	-1574(ra) # 8000311c <buf_read>
    8000274a:	84aa                	mv	s1,a0
        dip = (struct dinode *) bp->data + inum % IPB;
    8000274c:	04c50993          	addi	s3,a0,76
    80002750:	00fa7793          	andi	a5,s4,15
    80002754:	079a                	slli	a5,a5,0x6
    80002756:	99be                	add	s3,s3,a5
        if (dip->type == 0) { // a free inode
    80002758:	00099783          	lh	a5,0(s3)
    8000275c:	cf9d                	beqz	a5,8000279a <alloc_inode+0x96>
        relse_buf(bp);
    8000275e:	00001097          	auipc	ra,0x1
    80002762:	a0c080e7          	jalr	-1524(ra) # 8000316a <relse_buf>
    for (inum = 1; inum < sb.ninodes; inum++) {
    80002766:	0905                	addi	s2,s2,1
    80002768:	00caa703          	lw	a4,12(s5)
    8000276c:	0009079b          	sext.w	a5,s2
    80002770:	fce7e1e3          	bltu	a5,a4,80002732 <alloc_inode+0x2e>
    panic("alloc_inode: no inodes");
    80002774:	00003517          	auipc	a0,0x3
    80002778:	b6450513          	addi	a0,a0,-1180 # 800052d8 <digits+0x1f0>
    8000277c:	fffff097          	auipc	ra,0xfffff
    80002780:	b02080e7          	jalr	-1278(ra) # 8000127e <panic>
    return 0;
    80002784:	4501                	li	a0,0
}
    80002786:	70e2                	ld	ra,56(sp)
    80002788:	7442                	ld	s0,48(sp)
    8000278a:	74a2                	ld	s1,40(sp)
    8000278c:	7902                	ld	s2,32(sp)
    8000278e:	69e2                	ld	s3,24(sp)
    80002790:	6a42                	ld	s4,16(sp)
    80002792:	6aa2                	ld	s5,8(sp)
    80002794:	6b02                	ld	s6,0(sp)
    80002796:	6121                	addi	sp,sp,64
    80002798:	8082                	ret
            memset(dip, 0, sizeof(*dip));
    8000279a:	04000613          	li	a2,64
    8000279e:	4581                	li	a1,0
    800027a0:	854e                	mv	a0,s3
    800027a2:	ffffe097          	auipc	ra,0xffffe
    800027a6:	58a080e7          	jalr	1418(ra) # 80000d2c <memset>
            dip->type = type;
    800027aa:	01699023          	sh	s6,0(s3)
            buf_write(bp); // 写回磁盘
    800027ae:	8526                	mv	a0,s1
    800027b0:	00001097          	auipc	ra,0x1
    800027b4:	9a0080e7          	jalr	-1632(ra) # 80003150 <buf_write>
            relse_buf(bp);
    800027b8:	8526                	mv	a0,s1
    800027ba:	00001097          	auipc	ra,0x1
    800027be:	9b0080e7          	jalr	-1616(ra) # 8000316a <relse_buf>
            return get_inode(inum);
    800027c2:	8552                	mv	a0,s4
    800027c4:	00000097          	auipc	ra,0x0
    800027c8:	e8e080e7          	jalr	-370(ra) # 80002652 <get_inode>
    800027cc:	bf6d                	j	80002786 <alloc_inode+0x82>

00000000800027ce <bmap>:
    spin_unlock(&inode_cache.lock);
}

// 数据块包含直接块和间接块，这里只实现了直接块
// 获取inode的第bn个数据块对应的磁盘块号
uint bmap(struct inode *ip, uint bn) {
    800027ce:	1101                	addi	sp,sp,-32
    800027d0:	ec06                	sd	ra,24(sp)
    800027d2:	e822                	sd	s0,16(sp)
    800027d4:	e426                	sd	s1,8(sp)
    800027d6:	1000                	addi	s0,sp,32
    uint64 addr;
    if (bn < NDIRECT) {
    800027d8:	47ad                	li	a5,11
    800027da:	02b7ea63          	bltu	a5,a1,8000280e <bmap+0x40>
        if ((addr = ip->addrs[bn]) == 0)
    800027de:	1582                	slli	a1,a1,0x20
    800027e0:	9181                	srli	a1,a1,0x20
    800027e2:	058a                	slli	a1,a1,0x2
    800027e4:	00b504b3          	add	s1,a0,a1
    800027e8:	0504e783          	lwu	a5,80(s1)
    800027ec:	cb81                	beqz	a5,800027fc <bmap+0x2e>
            ip->addrs[bn] = addr = alloc_disk_block();
        return addr;
    800027ee:	0007851b          	sext.w	a0,a5
    }

    panic("bmap");
    return 0;
}
    800027f2:	60e2                	ld	ra,24(sp)
    800027f4:	6442                	ld	s0,16(sp)
    800027f6:	64a2                	ld	s1,8(sp)
    800027f8:	6105                	addi	sp,sp,32
    800027fa:	8082                	ret
            ip->addrs[bn] = addr = alloc_disk_block();
    800027fc:	00000097          	auipc	ra,0x0
    80002800:	c02080e7          	jalr	-1022(ra) # 800023fe <alloc_disk_block>
    80002804:	02051793          	slli	a5,a0,0x20
    80002808:	9381                	srli	a5,a5,0x20
    8000280a:	c8a8                	sw	a0,80(s1)
    8000280c:	b7cd                	j	800027ee <bmap+0x20>
    panic("bmap");
    8000280e:	00003517          	auipc	a0,0x3
    80002812:	ae250513          	addi	a0,a0,-1310 # 800052f0 <digits+0x208>
    80002816:	fffff097          	auipc	ra,0xfffff
    8000281a:	a68080e7          	jalr	-1432(ra) # 8000127e <panic>
    return 0;
    8000281e:	4501                	li	a0,0
    80002820:	bfc9                	j	800027f2 <bmap+0x24>

0000000080002822 <trunc_inode>:

// Truncate inode(移除内容)
// 调用者必须持有ip->lock
void trunc_inode(struct inode *ip) {
    80002822:	7179                	addi	sp,sp,-48
    80002824:	f406                	sd	ra,40(sp)
    80002826:	f022                	sd	s0,32(sp)
    80002828:	ec26                	sd	s1,24(sp)
    8000282a:	e84a                	sd	s2,16(sp)
    8000282c:	e44e                	sd	s3,8(sp)
    8000282e:	e052                	sd	s4,0(sp)
    80002830:	1800                	addi	s0,sp,48
    80002832:	89aa                	mv	s3,a0
    int i, j;
    struct buf *bp;
    uint *a;

    for (i = 0; i < NDIRECT; i++) {
    80002834:	05050493          	addi	s1,a0,80
    80002838:	08050913          	addi	s2,a0,128
    8000283c:	a021                	j	80002844 <trunc_inode+0x22>
    8000283e:	0491                	addi	s1,s1,4
    80002840:	01248b63          	beq	s1,s2,80002856 <trunc_inode+0x34>
        if (ip->addrs[i]) {
    80002844:	4088                	lw	a0,0(s1)
    80002846:	dd65                	beqz	a0,8000283e <trunc_inode+0x1c>
            free_disk_block(ip->addrs[i]);
    80002848:	00000097          	auipc	ra,0x0
    8000284c:	caa080e7          	jalr	-854(ra) # 800024f2 <free_disk_block>
            ip->addrs[i] = 0;
    80002850:	0004a023          	sw	zero,0(s1)
    80002854:	b7ed                	j	8000283e <trunc_inode+0x1c>
        }
    }

    if (ip->addrs[NDIRECT]) {
    80002856:	0809a583          	lw	a1,128(s3)
    8000285a:	e185                	bnez	a1,8000287a <trunc_inode+0x58>
        relse_buf(bp);
        free_disk_block(ip->addrs[NDIRECT]);
        ip->addrs[NDIRECT] = 0;
    }

    ip->size = 0;
    8000285c:	0409a623          	sw	zero,76(s3)
    update_inode(ip);
    80002860:	854e                	mv	a0,s3
    80002862:	00000097          	auipc	ra,0x0
    80002866:	d64080e7          	jalr	-668(ra) # 800025c6 <update_inode>
}
    8000286a:	70a2                	ld	ra,40(sp)
    8000286c:	7402                	ld	s0,32(sp)
    8000286e:	64e2                	ld	s1,24(sp)
    80002870:	6942                	ld	s2,16(sp)
    80002872:	69a2                	ld	s3,8(sp)
    80002874:	6a02                	ld	s4,0(sp)
    80002876:	6145                	addi	sp,sp,48
    80002878:	8082                	ret
        bp = buf_read(ip->dev, ip->addrs[NDIRECT]);
    8000287a:	0009a503          	lw	a0,0(s3)
    8000287e:	00001097          	auipc	ra,0x1
    80002882:	89e080e7          	jalr	-1890(ra) # 8000311c <buf_read>
    80002886:	8a2a                	mv	s4,a0
        for (j = 0; j < NINDIRECT; j++) {
    80002888:	04c50493          	addi	s1,a0,76
    8000288c:	44c50913          	addi	s2,a0,1100
    80002890:	a801                	j	800028a0 <trunc_inode+0x7e>
                free_disk_block(a[j]);
    80002892:	00000097          	auipc	ra,0x0
    80002896:	c60080e7          	jalr	-928(ra) # 800024f2 <free_disk_block>
        for (j = 0; j < NINDIRECT; j++) {
    8000289a:	0491                	addi	s1,s1,4
    8000289c:	01248563          	beq	s1,s2,800028a6 <trunc_inode+0x84>
            if (a[j])
    800028a0:	4088                	lw	a0,0(s1)
    800028a2:	dd65                	beqz	a0,8000289a <trunc_inode+0x78>
    800028a4:	b7fd                	j	80002892 <trunc_inode+0x70>
        relse_buf(bp);
    800028a6:	8552                	mv	a0,s4
    800028a8:	00001097          	auipc	ra,0x1
    800028ac:	8c2080e7          	jalr	-1854(ra) # 8000316a <relse_buf>
        free_disk_block(ip->addrs[NDIRECT]);
    800028b0:	0809a503          	lw	a0,128(s3)
    800028b4:	00000097          	auipc	ra,0x0
    800028b8:	c3e080e7          	jalr	-962(ra) # 800024f2 <free_disk_block>
        ip->addrs[NDIRECT] = 0;
    800028bc:	0809a023          	sw	zero,128(s3)
    800028c0:	bf71                	j	8000285c <trunc_inode+0x3a>

00000000800028c2 <putback_inode>:
void putback_inode(struct inode *ip) {
    800028c2:	1101                	addi	sp,sp,-32
    800028c4:	ec06                	sd	ra,24(sp)
    800028c6:	e822                	sd	s0,16(sp)
    800028c8:	e426                	sd	s1,8(sp)
    800028ca:	e04a                	sd	s2,0(sp)
    800028cc:	1000                	addi	s0,sp,32
    800028ce:	84aa                	mv	s1,a0
    spin_lock(&inode_cache.lock);
    800028d0:	0004c517          	auipc	a0,0x4c
    800028d4:	74850513          	addi	a0,a0,1864 # 8004f018 <inode_cache>
    800028d8:	00001097          	auipc	ra,0x1
    800028dc:	974080e7          	jalr	-1676(ra) # 8000324c <spin_lock>
    if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    800028e0:	4498                	lw	a4,8(s1)
    800028e2:	4785                	li	a5,1
    800028e4:	02f70363          	beq	a4,a5,8000290a <putback_inode+0x48>
    ip->ref--;
    800028e8:	449c                	lw	a5,8(s1)
    800028ea:	37fd                	addiw	a5,a5,-1
    800028ec:	c49c                	sw	a5,8(s1)
    spin_unlock(&inode_cache.lock);
    800028ee:	0004c517          	auipc	a0,0x4c
    800028f2:	72a50513          	addi	a0,a0,1834 # 8004f018 <inode_cache>
    800028f6:	00001097          	auipc	ra,0x1
    800028fa:	a2a080e7          	jalr	-1494(ra) # 80003320 <spin_unlock>
}
    800028fe:	60e2                	ld	ra,24(sp)
    80002900:	6442                	ld	s0,16(sp)
    80002902:	64a2                	ld	s1,8(sp)
    80002904:	6902                	ld	s2,0(sp)
    80002906:	6105                	addi	sp,sp,32
    80002908:	8082                	ret
    if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    8000290a:	40bc                	lw	a5,64(s1)
    8000290c:	dff1                	beqz	a5,800028e8 <putback_inode+0x26>
    8000290e:	04a49783          	lh	a5,74(s1)
    80002912:	fbf9                	bnez	a5,800028e8 <putback_inode+0x26>
        sleep_lock(&ip->lock);
    80002914:	01048913          	addi	s2,s1,16
    80002918:	854a                	mv	a0,s2
    8000291a:	00001097          	auipc	ra,0x1
    8000291e:	a9c080e7          	jalr	-1380(ra) # 800033b6 <sleep_lock>
        spin_unlock(&inode_cache.lock);
    80002922:	0004c517          	auipc	a0,0x4c
    80002926:	6f650513          	addi	a0,a0,1782 # 8004f018 <inode_cache>
    8000292a:	00001097          	auipc	ra,0x1
    8000292e:	9f6080e7          	jalr	-1546(ra) # 80003320 <spin_unlock>
        trunc_inode(ip);
    80002932:	8526                	mv	a0,s1
    80002934:	00000097          	auipc	ra,0x0
    80002938:	eee080e7          	jalr	-274(ra) # 80002822 <trunc_inode>
        ip->type = 0;
    8000293c:	04049223          	sh	zero,68(s1)
        update_inode(ip);
    80002940:	8526                	mv	a0,s1
    80002942:	00000097          	auipc	ra,0x0
    80002946:	c84080e7          	jalr	-892(ra) # 800025c6 <update_inode>
        ip->valid = 0;
    8000294a:	0404a023          	sw	zero,64(s1)
        sleep_unlock(&ip->lock);
    8000294e:	854a                	mv	a0,s2
    80002950:	00001097          	auipc	ra,0x1
    80002954:	abc080e7          	jalr	-1348(ra) # 8000340c <sleep_unlock>
        spin_lock(&inode_cache.lock);
    80002958:	0004c517          	auipc	a0,0x4c
    8000295c:	6c050513          	addi	a0,a0,1728 # 8004f018 <inode_cache>
    80002960:	00001097          	auipc	ra,0x1
    80002964:	8ec080e7          	jalr	-1812(ra) # 8000324c <spin_lock>
    80002968:	b741                	j	800028e8 <putback_inode+0x26>

000000008000296a <dup_inode>:

// 递增ip->ref
struct inode *dup_inode(struct inode *ip) {
    8000296a:	1101                	addi	sp,sp,-32
    8000296c:	ec06                	sd	ra,24(sp)
    8000296e:	e822                	sd	s0,16(sp)
    80002970:	e426                	sd	s1,8(sp)
    80002972:	1000                	addi	s0,sp,32
    80002974:	84aa                	mv	s1,a0
    spin_lock(&inode_cache.lock);
    80002976:	0004c517          	auipc	a0,0x4c
    8000297a:	6a250513          	addi	a0,a0,1698 # 8004f018 <inode_cache>
    8000297e:	00001097          	auipc	ra,0x1
    80002982:	8ce080e7          	jalr	-1842(ra) # 8000324c <spin_lock>
    ip->ref++;
    80002986:	449c                	lw	a5,8(s1)
    80002988:	2785                	addiw	a5,a5,1
    8000298a:	c49c                	sw	a5,8(s1)
    spin_unlock(&inode_cache.lock);
    8000298c:	0004c517          	auipc	a0,0x4c
    80002990:	68c50513          	addi	a0,a0,1676 # 8004f018 <inode_cache>
    80002994:	00001097          	auipc	ra,0x1
    80002998:	98c080e7          	jalr	-1652(ra) # 80003320 <spin_unlock>
    return ip;
}
    8000299c:	8526                	mv	a0,s1
    8000299e:	60e2                	ld	ra,24(sp)
    800029a0:	6442                	ld	s0,16(sp)
    800029a2:	64a2                	ld	s1,8(sp)
    800029a4:	6105                	addi	sp,sp,32
    800029a6:	8082                	ret

00000000800029a8 <lock_inode>:

// 锁定给定的inode
// 需要时读取从磁盘读数据
void lock_inode(struct inode *ip) {
    800029a8:	1101                	addi	sp,sp,-32
    800029aa:	ec06                	sd	ra,24(sp)
    800029ac:	e822                	sd	s0,16(sp)
    800029ae:	e426                	sd	s1,8(sp)
    800029b0:	e04a                	sd	s2,0(sp)
    800029b2:	1000                	addi	s0,sp,32
    800029b4:	84aa                	mv	s1,a0
    struct buf *bp;
    struct dinode *dip;

    if (ip == 0 || ip->ref < 1)
    800029b6:	c501                	beqz	a0,800029be <lock_inode+0x16>
    800029b8:	451c                	lw	a5,8(a0)
    800029ba:	00f04a63          	bgtz	a5,800029ce <lock_inode+0x26>
        panic("lock_inode");
    800029be:	00003517          	auipc	a0,0x3
    800029c2:	93a50513          	addi	a0,a0,-1734 # 800052f8 <digits+0x210>
    800029c6:	fffff097          	auipc	ra,0xfffff
    800029ca:	8b8080e7          	jalr	-1864(ra) # 8000127e <panic>

    sleep_lock(&ip->lock);
    800029ce:	01048513          	addi	a0,s1,16
    800029d2:	00001097          	auipc	ra,0x1
    800029d6:	9e4080e7          	jalr	-1564(ra) # 800033b6 <sleep_lock>

    if (ip->valid == 0) {
    800029da:	40bc                	lw	a5,64(s1)
    800029dc:	c799                	beqz	a5,800029ea <lock_inode+0x42>
        relse_buf(bp);
        ip->valid = 1;
        if (ip->type == 0)
            panic("lock_inode: no type");
    }
}
    800029de:	60e2                	ld	ra,24(sp)
    800029e0:	6442                	ld	s0,16(sp)
    800029e2:	64a2                	ld	s1,8(sp)
    800029e4:	6902                	ld	s2,0(sp)
    800029e6:	6105                	addi	sp,sp,32
    800029e8:	8082                	ret
        bp = buf_read(ip->dev, IBLOCK(ip->inum, sb));
    800029ea:	40dc                	lw	a5,4(s1)
    800029ec:	0047d79b          	srliw	a5,a5,0x4
    800029f0:	0004c597          	auipc	a1,0x4c
    800029f4:	6205a583          	lw	a1,1568(a1) # 8004f010 <sb+0x10>
    800029f8:	9dbd                	addw	a1,a1,a5
    800029fa:	4088                	lw	a0,0(s1)
    800029fc:	00000097          	auipc	ra,0x0
    80002a00:	720080e7          	jalr	1824(ra) # 8000311c <buf_read>
    80002a04:	892a                	mv	s2,a0
        dip = (struct dinode *) bp->data + ip->inum % IPB;
    80002a06:	04c50593          	addi	a1,a0,76
    80002a0a:	40dc                	lw	a5,4(s1)
    80002a0c:	8bbd                	andi	a5,a5,15
    80002a0e:	079a                	slli	a5,a5,0x6
    80002a10:	95be                	add	a1,a1,a5
        ip->type = dip->type;
    80002a12:	00059783          	lh	a5,0(a1)
    80002a16:	04f49223          	sh	a5,68(s1)
        ip->major = dip->major;
    80002a1a:	00259783          	lh	a5,2(a1)
    80002a1e:	04f49323          	sh	a5,70(s1)
        ip->minor = dip->minor;
    80002a22:	00459783          	lh	a5,4(a1)
    80002a26:	04f49423          	sh	a5,72(s1)
        ip->nlink = dip->nlink;
    80002a2a:	00659783          	lh	a5,6(a1)
    80002a2e:	04f49523          	sh	a5,74(s1)
        ip->size = dip->size;
    80002a32:	459c                	lw	a5,8(a1)
    80002a34:	c4fc                	sw	a5,76(s1)
        memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002a36:	03400613          	li	a2,52
    80002a3a:	05b1                	addi	a1,a1,12
    80002a3c:	05048513          	addi	a0,s1,80
    80002a40:	ffffe097          	auipc	ra,0xffffe
    80002a44:	312080e7          	jalr	786(ra) # 80000d52 <memmove>
        relse_buf(bp);
    80002a48:	854a                	mv	a0,s2
    80002a4a:	00000097          	auipc	ra,0x0
    80002a4e:	720080e7          	jalr	1824(ra) # 8000316a <relse_buf>
        ip->valid = 1;
    80002a52:	4785                	li	a5,1
    80002a54:	c0bc                	sw	a5,64(s1)
        if (ip->type == 0)
    80002a56:	04449783          	lh	a5,68(s1)
    80002a5a:	f3d1                	bnez	a5,800029de <lock_inode+0x36>
            panic("lock_inode: no type");
    80002a5c:	00003517          	auipc	a0,0x3
    80002a60:	8ac50513          	addi	a0,a0,-1876 # 80005308 <digits+0x220>
    80002a64:	fffff097          	auipc	ra,0xfffff
    80002a68:	81a080e7          	jalr	-2022(ra) # 8000127e <panic>
}
    80002a6c:	bf8d                	j	800029de <lock_inode+0x36>

0000000080002a6e <unlock_inode>:

// 解锁inode.
void unlock_inode(struct inode *ip) {
    80002a6e:	1101                	addi	sp,sp,-32
    80002a70:	ec06                	sd	ra,24(sp)
    80002a72:	e822                	sd	s0,16(sp)
    80002a74:	e426                	sd	s1,8(sp)
    80002a76:	1000                	addi	s0,sp,32
    80002a78:	84aa                	mv	s1,a0
    if (ip == 0 || !sleep_holding(&ip->lock) || ip->ref < 1)
    80002a7a:	c911                	beqz	a0,80002a8e <unlock_inode+0x20>
    80002a7c:	0541                	addi	a0,a0,16
    80002a7e:	00001097          	auipc	ra,0x1
    80002a82:	9d2080e7          	jalr	-1582(ra) # 80003450 <sleep_holding>
    80002a86:	c501                	beqz	a0,80002a8e <unlock_inode+0x20>
    80002a88:	449c                	lw	a5,8(s1)
    80002a8a:	00f04a63          	bgtz	a5,80002a9e <unlock_inode+0x30>
        panic("unlock_inode");
    80002a8e:	00003517          	auipc	a0,0x3
    80002a92:	89250513          	addi	a0,a0,-1902 # 80005320 <digits+0x238>
    80002a96:	ffffe097          	auipc	ra,0xffffe
    80002a9a:	7e8080e7          	jalr	2024(ra) # 8000127e <panic>
    sleep_unlock(&ip->lock);
    80002a9e:	01048513          	addi	a0,s1,16
    80002aa2:	00001097          	auipc	ra,0x1
    80002aa6:	96a080e7          	jalr	-1686(ra) # 8000340c <sleep_unlock>
}
    80002aaa:	60e2                	ld	ra,24(sp)
    80002aac:	6442                	ld	s0,16(sp)
    80002aae:	64a2                	ld	s1,8(sp)
    80002ab0:	6105                	addi	sp,sp,32
    80002ab2:	8082                	ret

0000000080002ab4 <unlock_and_putback>:

void unlock_and_putback(struct inode *ip) {
    80002ab4:	1101                	addi	sp,sp,-32
    80002ab6:	ec06                	sd	ra,24(sp)
    80002ab8:	e822                	sd	s0,16(sp)
    80002aba:	e426                	sd	s1,8(sp)
    80002abc:	1000                	addi	s0,sp,32
    80002abe:	84aa                	mv	s1,a0
    unlock_inode(ip);
    80002ac0:	00000097          	auipc	ra,0x0
    80002ac4:	fae080e7          	jalr	-82(ra) # 80002a6e <unlock_inode>
    putback_inode(ip);
    80002ac8:	8526                	mv	a0,s1
    80002aca:	00000097          	auipc	ra,0x0
    80002ace:	df8080e7          	jalr	-520(ra) # 800028c2 <putback_inode>
}
    80002ad2:	60e2                	ld	ra,24(sp)
    80002ad4:	6442                	ld	s0,16(sp)
    80002ad6:	64a2                	ld	s1,8(sp)
    80002ad8:	6105                	addi	sp,sp,32
    80002ada:	8082                	ret

0000000080002adc <read_inode>:

// 从inode中读取数据
int read_inode(struct inode *ip, uint64 dst, uint off, int n) {
    80002adc:	711d                	addi	sp,sp,-96
    80002ade:	ec86                	sd	ra,88(sp)
    80002ae0:	e8a2                	sd	s0,80(sp)
    80002ae2:	e4a6                	sd	s1,72(sp)
    80002ae4:	e0ca                	sd	s2,64(sp)
    80002ae6:	fc4e                	sd	s3,56(sp)
    80002ae8:	f852                	sd	s4,48(sp)
    80002aea:	f456                	sd	s5,40(sp)
    80002aec:	f05a                	sd	s6,32(sp)
    80002aee:	ec5e                	sd	s7,24(sp)
    80002af0:	e862                	sd	s8,16(sp)
    80002af2:	e466                	sd	s9,8(sp)
    80002af4:	1080                	addi	s0,sp,96
    int total = 0, m = 0;
    struct buf *bp;
    if (off > ip->size || off + n < off) {
    80002af6:	457c                	lw	a5,76(a0)
        return 0;
    80002af8:	4981                	li	s3,0
    if (off > ip->size || off + n < off) {
    80002afa:	02c7e463          	bltu	a5,a2,80002b22 <read_inode+0x46>
    80002afe:	8baa                	mv	s7,a0
    80002b00:	8aae                	mv	s5,a1
    80002b02:	84b2                	mv	s1,a2
    80002b04:	8b36                	mv	s6,a3
    80002b06:	00c6873b          	addw	a4,a3,a2
        return 0;
    80002b0a:	4981                	li	s3,0
    if (off > ip->size || off + n < off) {
    80002b0c:	00c76b63          	bltu	a4,a2,80002b22 <read_inode+0x46>
    }
    if (off + n > ip->size) {
    80002b10:	00e7f463          	bgeu	a5,a4,80002b18 <read_inode+0x3c>
        n = ip->size - off;
    80002b14:	40c78b3b          	subw	s6,a5,a2
    }

    for (; total < n; total += m, off += m, dst += m) {
    80002b18:	4981                	li	s3,0
        bp = buf_read(0, bmap(ip, off / BSIZE));
        m = min(BSIZE - off % BSIZE, n - total);
    80002b1a:	40000c13          	li	s8,1024
    for (; total < n; total += m, off += m, dst += m) {
    80002b1e:	05604763          	bgtz	s6,80002b6c <read_inode+0x90>
        memmove((uint64 *) (dst), bp->data + (off % BSIZE), m);
        relse_buf(bp);
    }
    return total;
}
    80002b22:	854e                	mv	a0,s3
    80002b24:	60e6                	ld	ra,88(sp)
    80002b26:	6446                	ld	s0,80(sp)
    80002b28:	64a6                	ld	s1,72(sp)
    80002b2a:	6906                	ld	s2,64(sp)
    80002b2c:	79e2                	ld	s3,56(sp)
    80002b2e:	7a42                	ld	s4,48(sp)
    80002b30:	7aa2                	ld	s5,40(sp)
    80002b32:	7b02                	ld	s6,32(sp)
    80002b34:	6be2                	ld	s7,24(sp)
    80002b36:	6c42                	ld	s8,16(sp)
    80002b38:	6ca2                	ld	s9,8(sp)
    80002b3a:	6125                	addi	sp,sp,96
    80002b3c:	8082                	ret
        m = min(BSIZE - off % BSIZE, n - total);
    80002b3e:	000a0c9b          	sext.w	s9,s4
        memmove((uint64 *) (dst), bp->data + (off % BSIZE), m);
    80002b42:	04c90593          	addi	a1,s2,76
    80002b46:	8666                	mv	a2,s9
    80002b48:	95ba                	add	a1,a1,a4
    80002b4a:	8556                	mv	a0,s5
    80002b4c:	ffffe097          	auipc	ra,0xffffe
    80002b50:	206080e7          	jalr	518(ra) # 80000d52 <memmove>
        relse_buf(bp);
    80002b54:	854a                	mv	a0,s2
    80002b56:	00000097          	auipc	ra,0x0
    80002b5a:	614080e7          	jalr	1556(ra) # 8000316a <relse_buf>
    for (; total < n; total += m, off += m, dst += m) {
    80002b5e:	013a09bb          	addw	s3,s4,s3
    80002b62:	009a04bb          	addw	s1,s4,s1
    80002b66:	9ae6                	add	s5,s5,s9
    80002b68:	fb69dde3          	bge	s3,s6,80002b22 <read_inode+0x46>
        bp = buf_read(0, bmap(ip, off / BSIZE));
    80002b6c:	00a4d59b          	srliw	a1,s1,0xa
    80002b70:	855e                	mv	a0,s7
    80002b72:	00000097          	auipc	ra,0x0
    80002b76:	c5c080e7          	jalr	-932(ra) # 800027ce <bmap>
    80002b7a:	0005059b          	sext.w	a1,a0
    80002b7e:	4501                	li	a0,0
    80002b80:	00000097          	auipc	ra,0x0
    80002b84:	59c080e7          	jalr	1436(ra) # 8000311c <buf_read>
    80002b88:	892a                	mv	s2,a0
        m = min(BSIZE - off % BSIZE, n - total);
    80002b8a:	3ff4f713          	andi	a4,s1,1023
    80002b8e:	413b07bb          	subw	a5,s6,s3
    80002b92:	40ec06bb          	subw	a3,s8,a4
    80002b96:	8a3e                	mv	s4,a5
    80002b98:	2781                	sext.w	a5,a5
    80002b9a:	0006861b          	sext.w	a2,a3
    80002b9e:	faf670e3          	bgeu	a2,a5,80002b3e <read_inode+0x62>
    80002ba2:	8a36                	mv	s4,a3
    80002ba4:	bf69                	j	80002b3e <read_inode+0x62>

0000000080002ba6 <write_inode>:

// 将数据写入inode
int write_inode(struct inode *ip, uint64 src, uint64 off, int n) {
    80002ba6:	711d                	addi	sp,sp,-96
    80002ba8:	ec86                	sd	ra,88(sp)
    80002baa:	e8a2                	sd	s0,80(sp)
    80002bac:	e4a6                	sd	s1,72(sp)
    80002bae:	e0ca                	sd	s2,64(sp)
    80002bb0:	fc4e                	sd	s3,56(sp)
    80002bb2:	f852                	sd	s4,48(sp)
    80002bb4:	f456                	sd	s5,40(sp)
    80002bb6:	f05a                	sd	s6,32(sp)
    80002bb8:	ec5e                	sd	s7,24(sp)
    80002bba:	e862                	sd	s8,16(sp)
    80002bbc:	e466                	sd	s9,8(sp)
    80002bbe:	1080                	addi	s0,sp,96
    uint total, m;
    struct buf *bp;

    if (off > ip->size || off + n < off)
    80002bc0:	04c56783          	lwu	a5,76(a0)
    80002bc4:	0cc7e763          	bltu	a5,a2,80002c92 <write_inode+0xec>
    80002bc8:	8baa                	mv	s7,a0
    80002bca:	8aae                	mv	s5,a1
    80002bcc:	89b2                	mv	s3,a2
    80002bce:	8cb6                	mv	s9,a3
    80002bd0:	00c687b3          	add	a5,a3,a2
    80002bd4:	0cc7e163          	bltu	a5,a2,80002c96 <write_inode+0xf0>
        return -1;
    if (off + n > MAXFILE * BSIZE)
    80002bd8:	00043737          	lui	a4,0x43
    80002bdc:	0af76f63          	bltu	a4,a5,80002c9a <write_inode+0xf4>
        return -1;
    for (total = 0; total < n; total += m, off += m, src += m) {
    80002be0:	00068b1b          	sext.w	s6,a3
    80002be4:	0a0b0d63          	beqz	s6,80002c9e <write_inode+0xf8>
    80002be8:	4a01                	li	s4,0
        bp = buf_read(0, bmap(ip, off / BSIZE));
        m = min(BSIZE - off % BSIZE, n - total);
    80002bea:	40000c13          	li	s8,1024
    80002bee:	a81d                	j	80002c24 <write_inode+0x7e>
        memmove(bp->data + (off % BSIZE), (uint64 *) (src), m);
    80002bf0:	04c90513          	addi	a0,s2,76
    80002bf4:	0004861b          	sext.w	a2,s1
    80002bf8:	85d6                	mv	a1,s5
    80002bfa:	953e                	add	a0,a0,a5
    80002bfc:	ffffe097          	auipc	ra,0xffffe
    80002c00:	156080e7          	jalr	342(ra) # 80000d52 <memmove>
        buf_write(bp);
    80002c04:	854a                	mv	a0,s2
    80002c06:	00000097          	auipc	ra,0x0
    80002c0a:	54a080e7          	jalr	1354(ra) # 80003150 <buf_write>
        relse_buf(bp);
    80002c0e:	854a                	mv	a0,s2
    80002c10:	00000097          	auipc	ra,0x0
    80002c14:	55a080e7          	jalr	1370(ra) # 8000316a <relse_buf>
    for (total = 0; total < n; total += m, off += m, src += m) {
    80002c18:	01448a3b          	addw	s4,s1,s4
    80002c1c:	99a6                	add	s3,s3,s1
    80002c1e:	9aa6                	add	s5,s5,s1
    80002c20:	036a7e63          	bgeu	s4,s6,80002c5c <write_inode+0xb6>
        bp = buf_read(0, bmap(ip, off / BSIZE));
    80002c24:	00a9d593          	srli	a1,s3,0xa
    80002c28:	2581                	sext.w	a1,a1
    80002c2a:	855e                	mv	a0,s7
    80002c2c:	00000097          	auipc	ra,0x0
    80002c30:	ba2080e7          	jalr	-1118(ra) # 800027ce <bmap>
    80002c34:	0005059b          	sext.w	a1,a0
    80002c38:	4501                	li	a0,0
    80002c3a:	00000097          	auipc	ra,0x0
    80002c3e:	4e2080e7          	jalr	1250(ra) # 8000311c <buf_read>
    80002c42:	892a                	mv	s2,a0
        m = min(BSIZE - off % BSIZE, n - total);
    80002c44:	3ff9f793          	andi	a5,s3,1023
    80002c48:	414b04bb          	subw	s1,s6,s4
    80002c4c:	40fc0733          	sub	a4,s8,a5
    80002c50:	1482                	slli	s1,s1,0x20
    80002c52:	9081                	srli	s1,s1,0x20
    80002c54:	f8977ee3          	bgeu	a4,s1,80002bf0 <write_inode+0x4a>
    80002c58:	84ba                	mv	s1,a4
    80002c5a:	bf59                	j	80002bf0 <write_inode+0x4a>
    }
    if (n > 0) {
    80002c5c:	01905d63          	blez	s9,80002c76 <write_inode+0xd0>
        if (off > ip->size)
    80002c60:	04cbe783          	lwu	a5,76(s7) # 204c <_entry-0x7fffdfb4>
    80002c64:	0137f463          	bgeu	a5,s3,80002c6c <write_inode+0xc6>
            ip->size = off;
    80002c68:	053ba623          	sw	s3,76(s7)
        // 将内存中的inode写入磁盘，即使没有写入数据，也需要更新，因为循环中可能
        //调用了bmap()或者在ip->addrs[]里面添加了数据块
        update_inode(ip);
    80002c6c:	855e                	mv	a0,s7
    80002c6e:	00000097          	auipc	ra,0x0
    80002c72:	958080e7          	jalr	-1704(ra) # 800025c6 <update_inode>
    }
    return n;
}
    80002c76:	8566                	mv	a0,s9
    80002c78:	60e6                	ld	ra,88(sp)
    80002c7a:	6446                	ld	s0,80(sp)
    80002c7c:	64a6                	ld	s1,72(sp)
    80002c7e:	6906                	ld	s2,64(sp)
    80002c80:	79e2                	ld	s3,56(sp)
    80002c82:	7a42                	ld	s4,48(sp)
    80002c84:	7aa2                	ld	s5,40(sp)
    80002c86:	7b02                	ld	s6,32(sp)
    80002c88:	6be2                	ld	s7,24(sp)
    80002c8a:	6c42                	ld	s8,16(sp)
    80002c8c:	6ca2                	ld	s9,8(sp)
    80002c8e:	6125                	addi	sp,sp,96
    80002c90:	8082                	ret
        return -1;
    80002c92:	5cfd                	li	s9,-1
    80002c94:	b7cd                	j	80002c76 <write_inode+0xd0>
    80002c96:	5cfd                	li	s9,-1
    80002c98:	bff9                	j	80002c76 <write_inode+0xd0>
        return -1;
    80002c9a:	5cfd                	li	s9,-1
    80002c9c:	bfe9                	j	80002c76 <write_inode+0xd0>
    return n;
    80002c9e:	4c81                	li	s9,0
    80002ca0:	bfd9                	j	80002c76 <write_inode+0xd0>

0000000080002ca2 <namecmp>:
// 目录层
//
// 第一个inode为根目录，该目录在mkfs/makefs下创建
//

int namecmp(const char *s, const char *t) {
    80002ca2:	1141                	addi	sp,sp,-16
    80002ca4:	e406                	sd	ra,8(sp)
    80002ca6:	e022                	sd	s0,0(sp)
    80002ca8:	0800                	addi	s0,sp,16
    return strncmp(s, t, DIRSIZ);
    80002caa:	4639                	li	a2,14
    80002cac:	ffffe097          	auipc	ra,0xffffe
    80002cb0:	1b2080e7          	jalr	434(ra) # 80000e5e <strncmp>
}
    80002cb4:	60a2                	ld	ra,8(sp)
    80002cb6:	6402                	ld	s0,0(sp)
    80002cb8:	0141                	addi	sp,sp,16
    80002cba:	8082                	ret

0000000080002cbc <dirlookup>:
//
//  dirlookup 在一个目录中搜索一个带有给定名称的条目。如果找到
// 了，它返回一个指向相应 inode 的指针，解锁该 inode，并将*poff
// 设置为目录中条目的字节偏移量，以便调用者编辑它。
//
struct inode *dirlookup(struct inode *dp, char *name, uint *poff) {
    80002cbc:	715d                	addi	sp,sp,-80
    80002cbe:	e486                	sd	ra,72(sp)
    80002cc0:	e0a2                	sd	s0,64(sp)
    80002cc2:	fc26                	sd	s1,56(sp)
    80002cc4:	f84a                	sd	s2,48(sp)
    80002cc6:	f44e                	sd	s3,40(sp)
    80002cc8:	f052                	sd	s4,32(sp)
    80002cca:	ec56                	sd	s5,24(sp)
    80002ccc:	0880                	addi	s0,sp,80
    80002cce:	892a                	mv	s2,a0
    80002cd0:	89ae                	mv	s3,a1
    80002cd2:	8ab2                	mv	s5,a2
    uint off, inum;
    struct direntry de;

    if (dp->type != T_DIR)
    80002cd4:	04451703          	lh	a4,68(a0)
    80002cd8:	4785                	li	a5,1
    80002cda:	00f71b63          	bne	a4,a5,80002cf0 <dirlookup+0x34>
        panic("dirlookup not DIR");

    for (off = 0; off < dp->size; off += sizeof(de)) {
    80002cde:	04c92783          	lw	a5,76(s2)
    80002ce2:	c7d9                	beqz	a5,80002d70 <dirlookup+0xb4>
    80002ce4:	4481                	li	s1,0
        if (read_inode(dp, (uint64) &de, off, sizeof(de)) != sizeof(de))
            panic("dirlookup read");
    80002ce6:	00002a17          	auipc	s4,0x2
    80002cea:	662a0a13          	addi	s4,s4,1634 # 80005348 <digits+0x260>
    80002cee:	a02d                	j	80002d18 <dirlookup+0x5c>
        panic("dirlookup not DIR");
    80002cf0:	00002517          	auipc	a0,0x2
    80002cf4:	64050513          	addi	a0,a0,1600 # 80005330 <digits+0x248>
    80002cf8:	ffffe097          	auipc	ra,0xffffe
    80002cfc:	586080e7          	jalr	1414(ra) # 8000127e <panic>
    80002d00:	bff9                	j	80002cde <dirlookup+0x22>
            panic("dirlookup read");
    80002d02:	8552                	mv	a0,s4
    80002d04:	ffffe097          	auipc	ra,0xffffe
    80002d08:	57a080e7          	jalr	1402(ra) # 8000127e <panic>
    80002d0c:	a015                	j	80002d30 <dirlookup+0x74>
    for (off = 0; off < dp->size; off += sizeof(de)) {
    80002d0e:	24c1                	addiw	s1,s1,16
    80002d10:	04c92783          	lw	a5,76(s2)
    80002d14:	04f4f463          	bgeu	s1,a5,80002d5c <dirlookup+0xa0>
        if (read_inode(dp, (uint64) &de, off, sizeof(de)) != sizeof(de))
    80002d18:	46c1                	li	a3,16
    80002d1a:	8626                	mv	a2,s1
    80002d1c:	fb040593          	addi	a1,s0,-80
    80002d20:	854a                	mv	a0,s2
    80002d22:	00000097          	auipc	ra,0x0
    80002d26:	dba080e7          	jalr	-582(ra) # 80002adc <read_inode>
    80002d2a:	47c1                	li	a5,16
    80002d2c:	fcf51be3          	bne	a0,a5,80002d02 <dirlookup+0x46>
        if (de.inum == 0)
    80002d30:	fb045783          	lhu	a5,-80(s0)
    80002d34:	dfe9                	beqz	a5,80002d0e <dirlookup+0x52>
            continue;
        if (namecmp(name, de.name) == 0) {
    80002d36:	fb240593          	addi	a1,s0,-78
    80002d3a:	854e                	mv	a0,s3
    80002d3c:	00000097          	auipc	ra,0x0
    80002d40:	f66080e7          	jalr	-154(ra) # 80002ca2 <namecmp>
    80002d44:	f569                	bnez	a0,80002d0e <dirlookup+0x52>
            // 该目录包含该该名称
            if (poff)
    80002d46:	000a8463          	beqz	s5,80002d4e <dirlookup+0x92>
                *poff = off;
    80002d4a:	009aa023          	sw	s1,0(s5)
            inum = de.inum;
            return get_inode(inum);
    80002d4e:	fb045503          	lhu	a0,-80(s0)
    80002d52:	00000097          	auipc	ra,0x0
    80002d56:	900080e7          	jalr	-1792(ra) # 80002652 <get_inode>
    80002d5a:	a011                	j	80002d5e <dirlookup+0xa2>
        }
    }

    return 0;
    80002d5c:	4501                	li	a0,0
}
    80002d5e:	60a6                	ld	ra,72(sp)
    80002d60:	6406                	ld	s0,64(sp)
    80002d62:	74e2                	ld	s1,56(sp)
    80002d64:	7942                	ld	s2,48(sp)
    80002d66:	79a2                	ld	s3,40(sp)
    80002d68:	7a02                	ld	s4,32(sp)
    80002d6a:	6ae2                	ld	s5,24(sp)
    80002d6c:	6161                	addi	sp,sp,80
    80002d6e:	8082                	ret
    return 0;
    80002d70:	4501                	li	a0,0
    80002d72:	b7f5                	j	80002d5e <dirlookup+0xa2>

0000000080002d74 <namex>:

// 根据path返回一个inode
// 该函数供nameiparent和namei使用
// 如果parent!=0返回父目录的inode并且复制最后一个元素到name中，
// name必须拥有足够的空间来存储DIRSIZE字节的字符串。
static struct inode *namex(char *path, int nameiparent, char *name) {
    80002d74:	711d                	addi	sp,sp,-96
    80002d76:	ec86                	sd	ra,88(sp)
    80002d78:	e8a2                	sd	s0,80(sp)
    80002d7a:	e4a6                	sd	s1,72(sp)
    80002d7c:	e0ca                	sd	s2,64(sp)
    80002d7e:	fc4e                	sd	s3,56(sp)
    80002d80:	f852                	sd	s4,48(sp)
    80002d82:	f456                	sd	s5,40(sp)
    80002d84:	f05a                	sd	s6,32(sp)
    80002d86:	ec5e                	sd	s7,24(sp)
    80002d88:	e862                	sd	s8,16(sp)
    80002d8a:	e466                	sd	s9,8(sp)
    80002d8c:	1080                	addi	s0,sp,96
    80002d8e:	84aa                	mv	s1,a0
    80002d90:	8b2e                	mv	s6,a1
    80002d92:	8ab2                	mv	s5,a2
    struct inode *ip, *next;
    struct proc *p = myproc();
    80002d94:	ffffe097          	auipc	ra,0xffffe
    80002d98:	a7c080e7          	jalr	-1412(ra) # 80000810 <myproc>
    if (*path == '/')
    80002d9c:	0004c703          	lbu	a4,0(s1)
    80002da0:	02f00793          	li	a5,47
    80002da4:	00f70f63          	beq	a4,a5,80002dc2 <namex+0x4e>
        ip = get_inode(ROOTINO);
    else
        ip = get_inode(p->current_dir->inum); // TODO 修改：从进程的当前path
    80002da8:	693c                	ld	a5,80(a0)
    80002daa:	43c8                	lw	a0,4(a5)
    80002dac:	00000097          	auipc	ra,0x0
    80002db0:	8a6080e7          	jalr	-1882(ra) # 80002652 <get_inode>
    80002db4:	89aa                	mv	s3,a0
    while (*path == '/')
    80002db6:	02f00913          	li	s2,47
    len = path - s;
    80002dba:	4b81                	li	s7,0
    if (len >= DIRSIZ)
    80002dbc:	4cb5                	li	s9,13

    while ((path = skipelem(path, name)) != 0) {
        lock_inode(ip);
        if (ip->type != T_DIR) {
    80002dbe:	4c05                	li	s8,1
    80002dc0:	a84d                	j	80002e72 <namex+0xfe>
        ip = get_inode(ROOTINO);
    80002dc2:	4501                	li	a0,0
    80002dc4:	00000097          	auipc	ra,0x0
    80002dc8:	88e080e7          	jalr	-1906(ra) # 80002652 <get_inode>
    80002dcc:	89aa                	mv	s3,a0
    80002dce:	b7e5                	j	80002db6 <namex+0x42>
            unlock_and_putback(ip);
    80002dd0:	854e                	mv	a0,s3
    80002dd2:	00000097          	auipc	ra,0x0
    80002dd6:	ce2080e7          	jalr	-798(ra) # 80002ab4 <unlock_and_putback>
            return 0;
    80002dda:	4981                	li	s3,0
    if (nameiparent) {
        putback_inode(ip);
        return 0;
    }
    return ip;
}
    80002ddc:	854e                	mv	a0,s3
    80002dde:	60e6                	ld	ra,88(sp)
    80002de0:	6446                	ld	s0,80(sp)
    80002de2:	64a6                	ld	s1,72(sp)
    80002de4:	6906                	ld	s2,64(sp)
    80002de6:	79e2                	ld	s3,56(sp)
    80002de8:	7a42                	ld	s4,48(sp)
    80002dea:	7aa2                	ld	s5,40(sp)
    80002dec:	7b02                	ld	s6,32(sp)
    80002dee:	6be2                	ld	s7,24(sp)
    80002df0:	6c42                	ld	s8,16(sp)
    80002df2:	6ca2                	ld	s9,8(sp)
    80002df4:	6125                	addi	sp,sp,96
    80002df6:	8082                	ret
            unlock_inode(ip);
    80002df8:	854e                	mv	a0,s3
    80002dfa:	00000097          	auipc	ra,0x0
    80002dfe:	c74080e7          	jalr	-908(ra) # 80002a6e <unlock_inode>
            return ip;
    80002e02:	bfe9                	j	80002ddc <namex+0x68>
            unlock_and_putback(ip);
    80002e04:	854e                	mv	a0,s3
    80002e06:	00000097          	auipc	ra,0x0
    80002e0a:	cae080e7          	jalr	-850(ra) # 80002ab4 <unlock_and_putback>
            return 0;
    80002e0e:	89d2                	mv	s3,s4
    80002e10:	b7f1                	j	80002ddc <namex+0x68>
    len = path - s;
    80002e12:	40b48a3b          	subw	s4,s1,a1
    if (len >= DIRSIZ)
    80002e16:	094cd363          	bge	s9,s4,80002e9c <namex+0x128>
        memmove(name, s, DIRSIZ);
    80002e1a:	4639                	li	a2,14
    80002e1c:	8556                	mv	a0,s5
    80002e1e:	ffffe097          	auipc	ra,0xffffe
    80002e22:	f34080e7          	jalr	-204(ra) # 80000d52 <memmove>
    while (*path == '/')
    80002e26:	0004c783          	lbu	a5,0(s1)
    80002e2a:	01279763          	bne	a5,s2,80002e38 <namex+0xc4>
        path++;
    80002e2e:	0485                	addi	s1,s1,1
    while (*path == '/')
    80002e30:	0004c783          	lbu	a5,0(s1)
    80002e34:	ff278de3          	beq	a5,s2,80002e2e <namex+0xba>
        lock_inode(ip);
    80002e38:	854e                	mv	a0,s3
    80002e3a:	00000097          	auipc	ra,0x0
    80002e3e:	b6e080e7          	jalr	-1170(ra) # 800029a8 <lock_inode>
        if (ip->type != T_DIR) {
    80002e42:	04499783          	lh	a5,68(s3)
    80002e46:	f98795e3          	bne	a5,s8,80002dd0 <namex+0x5c>
        if (nameiparent && *path == '\0') {
    80002e4a:	000b0563          	beqz	s6,80002e54 <namex+0xe0>
    80002e4e:	0004c783          	lbu	a5,0(s1)
    80002e52:	d3dd                	beqz	a5,80002df8 <namex+0x84>
        if ((next = dirlookup(ip, name, 0)) == 0) {
    80002e54:	865e                	mv	a2,s7
    80002e56:	85d6                	mv	a1,s5
    80002e58:	854e                	mv	a0,s3
    80002e5a:	00000097          	auipc	ra,0x0
    80002e5e:	e62080e7          	jalr	-414(ra) # 80002cbc <dirlookup>
    80002e62:	8a2a                	mv	s4,a0
    80002e64:	d145                	beqz	a0,80002e04 <namex+0x90>
        unlock_and_putback(ip);
    80002e66:	854e                	mv	a0,s3
    80002e68:	00000097          	auipc	ra,0x0
    80002e6c:	c4c080e7          	jalr	-948(ra) # 80002ab4 <unlock_and_putback>
        ip = next;
    80002e70:	89d2                	mv	s3,s4
    while (*path == '/')
    80002e72:	0004c783          	lbu	a5,0(s1)
    80002e76:	05279663          	bne	a5,s2,80002ec2 <namex+0x14e>
        path++;
    80002e7a:	0485                	addi	s1,s1,1
    while (*path == '/')
    80002e7c:	0004c783          	lbu	a5,0(s1)
    80002e80:	ff278de3          	beq	a5,s2,80002e7a <namex+0x106>
    if (*path == 0)
    80002e84:	c795                	beqz	a5,80002eb0 <namex+0x13c>
        path++;
    80002e86:	85a6                	mv	a1,s1
    len = path - s;
    80002e88:	8a5e                	mv	s4,s7
    while (*path != '/' && *path != 0)
    80002e8a:	01278963          	beq	a5,s2,80002e9c <namex+0x128>
    80002e8e:	d3d1                	beqz	a5,80002e12 <namex+0x9e>
        path++;
    80002e90:	0485                	addi	s1,s1,1
    while (*path != '/' && *path != 0)
    80002e92:	0004c783          	lbu	a5,0(s1)
    80002e96:	ff279ce3          	bne	a5,s2,80002e8e <namex+0x11a>
    80002e9a:	bfa5                	j	80002e12 <namex+0x9e>
        memmove(name, s, len);
    80002e9c:	8652                	mv	a2,s4
    80002e9e:	8556                	mv	a0,s5
    80002ea0:	ffffe097          	auipc	ra,0xffffe
    80002ea4:	eb2080e7          	jalr	-334(ra) # 80000d52 <memmove>
        name[len] = 0;
    80002ea8:	9a56                	add	s4,s4,s5
    80002eaa:	000a0023          	sb	zero,0(s4)
    80002eae:	bfa5                	j	80002e26 <namex+0xb2>
    if (nameiparent) {
    80002eb0:	f20b06e3          	beqz	s6,80002ddc <namex+0x68>
        putback_inode(ip);
    80002eb4:	854e                	mv	a0,s3
    80002eb6:	00000097          	auipc	ra,0x0
    80002eba:	a0c080e7          	jalr	-1524(ra) # 800028c2 <putback_inode>
        return 0;
    80002ebe:	4981                	li	s3,0
    80002ec0:	bf31                	j	80002ddc <namex+0x68>
    if (*path == 0)
    80002ec2:	d7fd                	beqz	a5,80002eb0 <namex+0x13c>
    while (*path != '/' && *path != 0)
    80002ec4:	0004c783          	lbu	a5,0(s1)
    80002ec8:	85a6                	mv	a1,s1
    80002eca:	b7d1                	j	80002e8e <namex+0x11a>

0000000080002ecc <dirlink>:
int dirlink(struct inode *dp, char *name, uint inum) {
    80002ecc:	715d                	addi	sp,sp,-80
    80002ece:	e486                	sd	ra,72(sp)
    80002ed0:	e0a2                	sd	s0,64(sp)
    80002ed2:	fc26                	sd	s1,56(sp)
    80002ed4:	f84a                	sd	s2,48(sp)
    80002ed6:	f44e                	sd	s3,40(sp)
    80002ed8:	f052                	sd	s4,32(sp)
    80002eda:	ec56                	sd	s5,24(sp)
    80002edc:	e85a                	sd	s6,16(sp)
    80002ede:	0880                	addi	s0,sp,80
    80002ee0:	89aa                	mv	s3,a0
    80002ee2:	8b2e                	mv	s6,a1
    80002ee4:	8ab2                	mv	s5,a2
    if ((ip = dirlookup(dp, name, 0)) != 0) {
    80002ee6:	4601                	li	a2,0
    80002ee8:	00000097          	auipc	ra,0x0
    80002eec:	dd4080e7          	jalr	-556(ra) # 80002cbc <dirlookup>
    80002ef0:	ed21                	bnez	a0,80002f48 <dirlink+0x7c>
    for (off = 0; off < dp->size; off += sizeof(de)) {
    80002ef2:	04c9a783          	lw	a5,76(s3)
    80002ef6:	4481                	li	s1,0
    80002ef8:	4901                	li	s2,0
            panic("dirlink read");
    80002efa:	00002a17          	auipc	s4,0x2
    80002efe:	45ea0a13          	addi	s4,s4,1118 # 80005358 <digits+0x270>
    for (off = 0; off < dp->size; off += sizeof(de)) {
    80002f02:	ebb5                	bnez	a5,80002f76 <dirlink+0xaa>
    strncpy(de.name, name, DIRSIZ);
    80002f04:	4639                	li	a2,14
    80002f06:	85da                	mv	a1,s6
    80002f08:	fb240513          	addi	a0,s0,-78
    80002f0c:	ffffe097          	auipc	ra,0xffffe
    80002f10:	ee8080e7          	jalr	-280(ra) # 80000df4 <strncpy>
    de.inum = inum;
    80002f14:	fb541823          	sh	s5,-80(s0)
    if (write_inode(dp, (uint64) &de, off, sizeof(de)) != sizeof(de))
    80002f18:	46c1                	li	a3,16
    80002f1a:	8626                	mv	a2,s1
    80002f1c:	fb040593          	addi	a1,s0,-80
    80002f20:	854e                	mv	a0,s3
    80002f22:	00000097          	auipc	ra,0x0
    80002f26:	c84080e7          	jalr	-892(ra) # 80002ba6 <write_inode>
    80002f2a:	872a                	mv	a4,a0
    80002f2c:	47c1                	li	a5,16
    return 0;
    80002f2e:	4501                	li	a0,0
    if (write_inode(dp, (uint64) &de, off, sizeof(de)) != sizeof(de))
    80002f30:	06f71063          	bne	a4,a5,80002f90 <dirlink+0xc4>
}
    80002f34:	60a6                	ld	ra,72(sp)
    80002f36:	6406                	ld	s0,64(sp)
    80002f38:	74e2                	ld	s1,56(sp)
    80002f3a:	7942                	ld	s2,48(sp)
    80002f3c:	79a2                	ld	s3,40(sp)
    80002f3e:	7a02                	ld	s4,32(sp)
    80002f40:	6ae2                	ld	s5,24(sp)
    80002f42:	6b42                	ld	s6,16(sp)
    80002f44:	6161                	addi	sp,sp,80
    80002f46:	8082                	ret
        putback_inode(ip);
    80002f48:	00000097          	auipc	ra,0x0
    80002f4c:	97a080e7          	jalr	-1670(ra) # 800028c2 <putback_inode>
        return -1;
    80002f50:	557d                	li	a0,-1
    80002f52:	b7cd                	j	80002f34 <dirlink+0x68>
            panic("dirlink read");
    80002f54:	8552                	mv	a0,s4
    80002f56:	ffffe097          	auipc	ra,0xffffe
    80002f5a:	328080e7          	jalr	808(ra) # 8000127e <panic>
        if (de.inum == 0)
    80002f5e:	fb045783          	lhu	a5,-80(s0)
    80002f62:	d3cd                	beqz	a5,80002f04 <dirlink+0x38>
    for (off = 0; off < dp->size; off += sizeof(de)) {
    80002f64:	0109079b          	addiw	a5,s2,16
    80002f68:	0007891b          	sext.w	s2,a5
    80002f6c:	84ca                	mv	s1,s2
    80002f6e:	04c9a783          	lw	a5,76(s3)
    80002f72:	f8f979e3          	bgeu	s2,a5,80002f04 <dirlink+0x38>
        if (read_inode(dp, (uint64) &de, off, sizeof(de)) != sizeof(de))
    80002f76:	46c1                	li	a3,16
    80002f78:	864a                	mv	a2,s2
    80002f7a:	fb040593          	addi	a1,s0,-80
    80002f7e:	854e                	mv	a0,s3
    80002f80:	00000097          	auipc	ra,0x0
    80002f84:	b5c080e7          	jalr	-1188(ra) # 80002adc <read_inode>
    80002f88:	47c1                	li	a5,16
    80002f8a:	fcf50ae3          	beq	a0,a5,80002f5e <dirlink+0x92>
    80002f8e:	b7d9                	j	80002f54 <dirlink+0x88>
        panic("dirlink");
    80002f90:	00002517          	auipc	a0,0x2
    80002f94:	3d850513          	addi	a0,a0,984 # 80005368 <digits+0x280>
    80002f98:	ffffe097          	auipc	ra,0xffffe
    80002f9c:	2e6080e7          	jalr	742(ra) # 8000127e <panic>
    return 0;
    80002fa0:	4501                	li	a0,0
    80002fa2:	bf49                	j	80002f34 <dirlink+0x68>

0000000080002fa4 <namei>:

struct inode *namei(char *path) {
    80002fa4:	1101                	addi	sp,sp,-32
    80002fa6:	ec06                	sd	ra,24(sp)
    80002fa8:	e822                	sd	s0,16(sp)
    80002faa:	1000                	addi	s0,sp,32
    char name[DIRSIZ];
    return namex(path, 0, name);
    80002fac:	fe040613          	addi	a2,s0,-32
    80002fb0:	4581                	li	a1,0
    80002fb2:	00000097          	auipc	ra,0x0
    80002fb6:	dc2080e7          	jalr	-574(ra) # 80002d74 <namex>
}
    80002fba:	60e2                	ld	ra,24(sp)
    80002fbc:	6442                	ld	s0,16(sp)
    80002fbe:	6105                	addi	sp,sp,32
    80002fc0:	8082                	ret

0000000080002fc2 <nameiparent>:

struct inode *nameiparent(char *path, char *name) {
    80002fc2:	1141                	addi	sp,sp,-16
    80002fc4:	e406                	sd	ra,8(sp)
    80002fc6:	e022                	sd	s0,0(sp)
    80002fc8:	0800                	addi	s0,sp,16
    80002fca:	862e                	mv	a2,a1
    return namex(path, 1, name);
    80002fcc:	4585                	li	a1,1
    80002fce:	00000097          	auipc	ra,0x0
    80002fd2:	da6080e7          	jalr	-602(ra) # 80002d74 <namex>
    80002fd6:	60a2                	ld	ra,8(sp)
    80002fd8:	6402                	ld	s0,0(sp)
    80002fda:	0141                	addi	sp,sp,16
    80002fdc:	8082                	ret

0000000080002fde <init_buf>:
#define BUFFER_NUM 100

struct buf buf_cache[BUFFER_NUM];
struct spinlock cache_lock;

void init_buf() {
    80002fde:	7179                	addi	sp,sp,-48
    80002fe0:	f406                	sd	ra,40(sp)
    80002fe2:	f022                	sd	s0,32(sp)
    80002fe4:	ec26                	sd	s1,24(sp)
    80002fe6:	e84a                	sd	s2,16(sp)
    80002fe8:	e44e                	sd	s3,8(sp)
    80002fea:	1800                	addi	s0,sp,48
    spinlock_init(&cache_lock, "cache lock");
    80002fec:	00002597          	auipc	a1,0x2
    80002ff0:	38458593          	addi	a1,a1,900 # 80005370 <digits+0x288>
    80002ff4:	0004e517          	auipc	a0,0x4e
    80002ff8:	acc50513          	addi	a0,a0,-1332 # 80050ac0 <cache_lock>
    80002ffc:	00000097          	auipc	ra,0x0
    80003000:	1c0080e7          	jalr	448(ra) # 800031bc <spinlock_init>
    80003004:	06400493          	li	s1,100
    for (int i = 0; i < BUFFER_NUM; i++) {
        sleeplock_init(&buf_cache->lock, "buf");
    80003008:	00002997          	auipc	s3,0x2
    8000300c:	37898993          	addi	s3,s3,888 # 80005380 <digits+0x298>
    80003010:	0004e917          	auipc	s2,0x4e
    80003014:	ae090913          	addi	s2,s2,-1312 # 80050af0 <buf_cache+0x18>
    80003018:	85ce                	mv	a1,s3
    8000301a:	854a                	mv	a0,s2
    8000301c:	00000097          	auipc	ra,0x0
    80003020:	360080e7          	jalr	864(ra) # 8000337c <sleeplock_init>
    for (int i = 0; i < BUFFER_NUM; i++) {
    80003024:	34fd                	addiw	s1,s1,-1
    80003026:	f8ed                	bnez	s1,80003018 <init_buf+0x3a>
    }
}
    80003028:	70a2                	ld	ra,40(sp)
    8000302a:	7402                	ld	s0,32(sp)
    8000302c:	64e2                	ld	s1,24(sp)
    8000302e:	6942                	ld	s2,16(sp)
    80003030:	69a2                	ld	s3,8(sp)
    80003032:	6145                	addi	sp,sp,48
    80003034:	8082                	ret

0000000080003036 <alloc_buf>:
extern uint64 ticks;


// 申请使用一个缓冲区，该缓冲区会被锁定
// 先进先出算法
struct buf *alloc_buf(int dev, int blockno) {
    80003036:	7179                	addi	sp,sp,-48
    80003038:	f406                	sd	ra,40(sp)
    8000303a:	f022                	sd	s0,32(sp)
    8000303c:	ec26                	sd	s1,24(sp)
    8000303e:	e84a                	sd	s2,16(sp)
    80003040:	e44e                	sd	s3,8(sp)
    80003042:	e052                	sd	s4,0(sp)
    80003044:	1800                	addi	s0,sp,48
    80003046:	8a2a                	mv	s4,a0
    80003048:	892e                	mv	s2,a1
    struct buf *b;
    struct buf *earliest = 0;
    spin_lock(&cache_lock);
    8000304a:	0004e517          	auipc	a0,0x4e
    8000304e:	a7650513          	addi	a0,a0,-1418 # 80050ac0 <cache_lock>
    80003052:	00000097          	auipc	ra,0x0
    80003056:	1fa080e7          	jalr	506(ra) # 8000324c <spin_lock>
    struct buf *earliest = 0;
    8000305a:	4981                	li	s3,0
    for (b = buf_cache; b < buf_cache + BUFFER_NUM; b++) {
    8000305c:	0004e497          	auipc	s1,0x4e
    80003060:	a7c48493          	addi	s1,s1,-1412 # 80050ad8 <buf_cache>
        if (b->refcnt == 0 &&
            (earliest == 0 || b->last_use_tick < earliest->last_use_tick)) {
            earliest = b;
        }
        if (b->blockno == blockno) {
    80003064:	2901                	sext.w	s2,s2
    for (b = buf_cache; b < buf_cache + BUFFER_NUM; b++) {
    80003066:	00069717          	auipc	a4,0x69
    8000306a:	9b270713          	addi	a4,a4,-1614 # 8006ba18 <ticks_lock>
    8000306e:	a809                	j	80003080 <alloc_buf+0x4a>
    80003070:	89a6                	mv	s3,s1
        if (b->blockno == blockno) {
    80003072:	44dc                	lw	a5,12(s1)
    80003074:	03278163          	beq	a5,s2,80003096 <alloc_buf+0x60>
    for (b = buf_cache; b < buf_cache + BUFFER_NUM; b++) {
    80003078:	45048493          	addi	s1,s1,1104
    8000307c:	04e48c63          	beq	s1,a4,800030d4 <alloc_buf+0x9e>
        if (b->refcnt == 0 &&
    80003080:	44bc                	lw	a5,72(s1)
    80003082:	fbe5                	bnez	a5,80003072 <alloc_buf+0x3c>
    80003084:	fe0986e3          	beqz	s3,80003070 <alloc_buf+0x3a>
            (earliest == 0 || b->last_use_tick < earliest->last_use_tick)) {
    80003088:	6894                	ld	a3,16(s1)
    8000308a:	0109b783          	ld	a5,16(s3)
    8000308e:	fef6f2e3          	bgeu	a3,a5,80003072 <alloc_buf+0x3c>
    80003092:	89a6                	mv	s3,s1
    80003094:	bff9                	j	80003072 <alloc_buf+0x3c>
            spin_unlock(&cache_lock);
    80003096:	0004e517          	auipc	a0,0x4e
    8000309a:	a2a50513          	addi	a0,a0,-1494 # 80050ac0 <cache_lock>
    8000309e:	00000097          	auipc	ra,0x0
    800030a2:	282080e7          	jalr	642(ra) # 80003320 <spin_unlock>
            b->refcnt++;
    800030a6:	44bc                	lw	a5,72(s1)
    800030a8:	2785                	addiw	a5,a5,1
    800030aa:	c4bc                	sw	a5,72(s1)
            b->last_use_tick = ticks;
    800030ac:	00003797          	auipc	a5,0x3
    800030b0:	f6c7b783          	ld	a5,-148(a5) # 80006018 <ticks>
    800030b4:	e89c                	sd	a5,16(s1)
            sleep_lock(&b->lock);
    800030b6:	01848513          	addi	a0,s1,24
    800030ba:	00000097          	auipc	ra,0x0
    800030be:	2fc080e7          	jalr	764(ra) # 800033b6 <sleep_lock>
    b->refcnt = 1;
    b->blockno = blockno;
    b->dev = dev;
    b->last_use_tick = ticks;
    return b;
}
    800030c2:	8526                	mv	a0,s1
    800030c4:	70a2                	ld	ra,40(sp)
    800030c6:	7402                	ld	s0,32(sp)
    800030c8:	64e2                	ld	s1,24(sp)
    800030ca:	6942                	ld	s2,16(sp)
    800030cc:	69a2                	ld	s3,8(sp)
    800030ce:	6a02                	ld	s4,0(sp)
    800030d0:	6145                	addi	sp,sp,48
    800030d2:	8082                	ret
    spin_unlock(&cache_lock);
    800030d4:	0004e517          	auipc	a0,0x4e
    800030d8:	9ec50513          	addi	a0,a0,-1556 # 80050ac0 <cache_lock>
    800030dc:	00000097          	auipc	ra,0x0
    800030e0:	244080e7          	jalr	580(ra) # 80003320 <spin_unlock>
    if (earliest == 0) {
    800030e4:	02098363          	beqz	s3,8000310a <alloc_buf+0xd4>
    b->valid = 0;
    800030e8:	0009a023          	sw	zero,0(s3)
    b->refcnt = 1;
    800030ec:	4785                	li	a5,1
    800030ee:	04f9a423          	sw	a5,72(s3)
    b->blockno = blockno;
    800030f2:	0129a623          	sw	s2,12(s3)
    b->dev = dev;
    800030f6:	0149a423          	sw	s4,8(s3)
    b->last_use_tick = ticks;
    800030fa:	00003797          	auipc	a5,0x3
    800030fe:	f1e7b783          	ld	a5,-226(a5) # 80006018 <ticks>
    80003102:	00f9b823          	sd	a5,16(s3)
    return b;
    80003106:	84ce                	mv	s1,s3
    80003108:	bf6d                	j	800030c2 <alloc_buf+0x8c>
        panic("alloc buf");
    8000310a:	00002517          	auipc	a0,0x2
    8000310e:	27e50513          	addi	a0,a0,638 # 80005388 <digits+0x2a0>
    80003112:	ffffe097          	auipc	ra,0xffffe
    80003116:	16c080e7          	jalr	364(ra) # 8000127e <panic>
    8000311a:	b7f9                	j	800030e8 <alloc_buf+0xb2>

000000008000311c <buf_read>:
    buf_write(b);
    sleep_unlock(&b->lock);
}

// 读取给定块的内容，返回一个包含该内容的buf
struct buf *buf_read(int dev, int blockno) {
    8000311c:	1101                	addi	sp,sp,-32
    8000311e:	ec06                	sd	ra,24(sp)
    80003120:	e822                	sd	s0,16(sp)
    80003122:	e426                	sd	s1,8(sp)
    80003124:	1000                	addi	s0,sp,32
    struct buf *b = alloc_buf(dev, blockno);
    80003126:	00000097          	auipc	ra,0x0
    8000312a:	f10080e7          	jalr	-240(ra) # 80003036 <alloc_buf>
    8000312e:	84aa                	mv	s1,a0
    if (!b->valid) {
    80003130:	411c                	lw	a5,0(a0)
    80003132:	cb89                	beqz	a5,80003144 <buf_read+0x28>
        virtio_disk_rw(b, 0);
    }
    b->valid = 1;
    80003134:	4785                	li	a5,1
    80003136:	c09c                	sw	a5,0(s1)
    return b;
}
    80003138:	8526                	mv	a0,s1
    8000313a:	60e2                	ld	ra,24(sp)
    8000313c:	6442                	ld	s0,16(sp)
    8000313e:	64a2                	ld	s1,8(sp)
    80003140:	6105                	addi	sp,sp,32
    80003142:	8082                	ret
        virtio_disk_rw(b, 0);
    80003144:	4581                	li	a1,0
    80003146:	fffff097          	auipc	ra,0xfffff
    8000314a:	b28080e7          	jalr	-1240(ra) # 80001c6e <virtio_disk_rw>
    8000314e:	b7dd                	j	80003134 <buf_read+0x18>

0000000080003150 <buf_write>:

// 将缓冲区写入磁盘
void buf_write(struct buf *b) {
    80003150:	1141                	addi	sp,sp,-16
    80003152:	e406                	sd	ra,8(sp)
    80003154:	e022                	sd	s0,0(sp)
    80003156:	0800                	addi	s0,sp,16
    virtio_disk_rw(b, 1);
    80003158:	4585                	li	a1,1
    8000315a:	fffff097          	auipc	ra,0xfffff
    8000315e:	b14080e7          	jalr	-1260(ra) # 80001c6e <virtio_disk_rw>
}
    80003162:	60a2                	ld	ra,8(sp)
    80003164:	6402                	ld	s0,0(sp)
    80003166:	0141                	addi	sp,sp,16
    80003168:	8082                	ret

000000008000316a <relse_buf>:
void relse_buf(struct buf *b) {
    8000316a:	1101                	addi	sp,sp,-32
    8000316c:	ec06                	sd	ra,24(sp)
    8000316e:	e822                	sd	s0,16(sp)
    80003170:	e426                	sd	s1,8(sp)
    80003172:	e04a                	sd	s2,0(sp)
    80003174:	1000                	addi	s0,sp,32
    80003176:	84aa                	mv	s1,a0
    spin_lock(&cache_lock);
    80003178:	0004e917          	auipc	s2,0x4e
    8000317c:	94890913          	addi	s2,s2,-1720 # 80050ac0 <cache_lock>
    80003180:	854a                	mv	a0,s2
    80003182:	00000097          	auipc	ra,0x0
    80003186:	0ca080e7          	jalr	202(ra) # 8000324c <spin_lock>
    b->refcnt--;
    8000318a:	44bc                	lw	a5,72(s1)
    8000318c:	37fd                	addiw	a5,a5,-1
    8000318e:	c4bc                	sw	a5,72(s1)
    spin_unlock(&cache_lock);
    80003190:	854a                	mv	a0,s2
    80003192:	00000097          	auipc	ra,0x0
    80003196:	18e080e7          	jalr	398(ra) # 80003320 <spin_unlock>
    buf_write(b);
    8000319a:	8526                	mv	a0,s1
    8000319c:	00000097          	auipc	ra,0x0
    800031a0:	fb4080e7          	jalr	-76(ra) # 80003150 <buf_write>
    sleep_unlock(&b->lock);
    800031a4:	01848513          	addi	a0,s1,24
    800031a8:	00000097          	auipc	ra,0x0
    800031ac:	264080e7          	jalr	612(ra) # 8000340c <sleep_unlock>
}
    800031b0:	60e2                	ld	ra,24(sp)
    800031b2:	6442                	ld	s0,16(sp)
    800031b4:	64a2                	ld	s1,8(sp)
    800031b6:	6902                	ld	s2,0(sp)
    800031b8:	6105                	addi	sp,sp,32
    800031ba:	8082                	ret

00000000800031bc <spinlock_init>:
#include "lock.h"
#include "../riscv.h"
#include "../process.h"
#include "../defs.h"

void spinlock_init(struct spinlock *lk, char *name) {
    800031bc:	1141                	addi	sp,sp,-16
    800031be:	e422                	sd	s0,8(sp)
    800031c0:	0800                	addi	s0,sp,16
    lk->cpu = 0;
    800031c2:	00053423          	sd	zero,8(a0)
    lk->name = name;
    800031c6:	e90c                	sd	a1,16(a0)
    lk->locked = 0;
    800031c8:	00052023          	sw	zero,0(a0)
}
    800031cc:	6422                	ld	s0,8(sp)
    800031ce:	0141                	addi	sp,sp,16
    800031d0:	8082                	ret

00000000800031d2 <spin_holding>:

// 检查当前cpu是否持有这个锁
// 需要关中断
int spin_holding(struct spinlock *lk) {
    int r;
    r = (lk->locked && lk->cpu == mycpu());
    800031d2:	411c                	lw	a5,0(a0)
    800031d4:	e399                	bnez	a5,800031da <spin_holding+0x8>
    800031d6:	4501                	li	a0,0
    return r;
}
    800031d8:	8082                	ret
int spin_holding(struct spinlock *lk) {
    800031da:	1101                	addi	sp,sp,-32
    800031dc:	ec06                	sd	ra,24(sp)
    800031de:	e822                	sd	s0,16(sp)
    800031e0:	e426                	sd	s1,8(sp)
    800031e2:	1000                	addi	s0,sp,32
    r = (lk->locked && lk->cpu == mycpu());
    800031e4:	6504                	ld	s1,8(a0)
    800031e6:	ffffd097          	auipc	ra,0xffffd
    800031ea:	60e080e7          	jalr	1550(ra) # 800007f4 <mycpu>
    800031ee:	40a48533          	sub	a0,s1,a0
    800031f2:	00153513          	seqz	a0,a0
}
    800031f6:	60e2                	ld	ra,24(sp)
    800031f8:	6442                	ld	s0,16(sp)
    800031fa:	64a2                	ld	s1,8(sp)
    800031fc:	6105                	addi	sp,sp,32
    800031fe:	8082                	ret

0000000080003200 <push_off>:

// push_off/pop_off 和 intr_off/intr_on 差不多，只是使得
// 开关中断可以嵌套使用。
void push_off(void) {
    80003200:	1101                	addi	sp,sp,-32
    80003202:	ec06                	sd	ra,24(sp)
    80003204:	e822                	sd	s0,16(sp)
    80003206:	e426                	sd	s1,8(sp)
    80003208:	1000                	addi	s0,sp,32

static inline uint64
r_sstatus()
{
  uint64 x;
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000320a:	100024f3          	csrr	s1,sstatus
    8000320e:	100027f3          	csrr	a5,sstatus

// disable device interrupts
static inline void
intr_off()
{
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80003212:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003214:	10079073          	csrw	sstatus,a5
    int old = intr_get();
    intr_off();
    if (mycpu()->noff == 0)
    80003218:	ffffd097          	auipc	ra,0xffffd
    8000321c:	5dc080e7          	jalr	1500(ra) # 800007f4 <mycpu>
    80003220:	5d3c                	lw	a5,120(a0)
    80003222:	cf89                	beqz	a5,8000323c <push_off+0x3c>
        mycpu()->intr_enable = old;
    mycpu()->noff += 1;
    80003224:	ffffd097          	auipc	ra,0xffffd
    80003228:	5d0080e7          	jalr	1488(ra) # 800007f4 <mycpu>
    8000322c:	5d3c                	lw	a5,120(a0)
    8000322e:	2785                	addiw	a5,a5,1
    80003230:	dd3c                	sw	a5,120(a0)
}
    80003232:	60e2                	ld	ra,24(sp)
    80003234:	6442                	ld	s0,16(sp)
    80003236:	64a2                	ld	s1,8(sp)
    80003238:	6105                	addi	sp,sp,32
    8000323a:	8082                	ret
        mycpu()->intr_enable = old;
    8000323c:	ffffd097          	auipc	ra,0xffffd
    80003240:	5b8080e7          	jalr	1464(ra) # 800007f4 <mycpu>
// are device interrupts enabled?
static inline int
intr_get()
{
  uint64 x = r_sstatus();
  return (x & SSTATUS_SIE) != 0;
    80003244:	8085                	srli	s1,s1,0x1
    80003246:	8885                	andi	s1,s1,1
    80003248:	dd64                	sw	s1,124(a0)
    8000324a:	bfe9                	j	80003224 <push_off+0x24>

000000008000324c <spin_lock>:
void spin_lock(struct spinlock *lk) {
    8000324c:	1101                	addi	sp,sp,-32
    8000324e:	ec06                	sd	ra,24(sp)
    80003250:	e822                	sd	s0,16(sp)
    80003252:	e426                	sd	s1,8(sp)
    80003254:	1000                	addi	s0,sp,32
    80003256:	84aa                	mv	s1,a0
    push_off(); // 禁用中断以避免死锁。
    80003258:	00000097          	auipc	ra,0x0
    8000325c:	fa8080e7          	jalr	-88(ra) # 80003200 <push_off>
    if (spin_holding(lk)){
    80003260:	8526                	mv	a0,s1
    80003262:	00000097          	auipc	ra,0x0
    80003266:	f70080e7          	jalr	-144(ra) # 800031d2 <spin_holding>
    8000326a:	e11d                	bnez	a0,80003290 <spin_lock+0x44>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0);
    8000326c:	4705                	li	a4,1
    8000326e:	87ba                	mv	a5,a4
    80003270:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80003274:	2781                	sext.w	a5,a5
    80003276:	ffe5                	bnez	a5,8000326e <spin_lock+0x22>
    __sync_synchronize();
    80003278:	0ff0000f          	fence
    lk->cpu = mycpu();
    8000327c:	ffffd097          	auipc	ra,0xffffd
    80003280:	578080e7          	jalr	1400(ra) # 800007f4 <mycpu>
    80003284:	e488                	sd	a0,8(s1)
}
    80003286:	60e2                	ld	ra,24(sp)
    80003288:	6442                	ld	s0,16(sp)
    8000328a:	64a2                	ld	s1,8(sp)
    8000328c:	6105                	addi	sp,sp,32
    8000328e:	8082                	ret
        printf("lock=%s",lk->name);
    80003290:	688c                	ld	a1,16(s1)
    80003292:	00002517          	auipc	a0,0x2
    80003296:	10650513          	addi	a0,a0,262 # 80005398 <digits+0x2b0>
    8000329a:	ffffe097          	auipc	ra,0xffffe
    8000329e:	f20080e7          	jalr	-224(ra) # 800011ba <printf>
        panic("re-acquire");
    800032a2:	00002517          	auipc	a0,0x2
    800032a6:	0fe50513          	addi	a0,a0,254 # 800053a0 <digits+0x2b8>
    800032aa:	ffffe097          	auipc	ra,0xffffe
    800032ae:	fd4080e7          	jalr	-44(ra) # 8000127e <panic>
    800032b2:	bf6d                	j	8000326c <spin_lock+0x20>

00000000800032b4 <pop_off>:

void pop_off(void) {
    800032b4:	1101                	addi	sp,sp,-32
    800032b6:	ec06                	sd	ra,24(sp)
    800032b8:	e822                	sd	s0,16(sp)
    800032ba:	e426                	sd	s1,8(sp)
    800032bc:	1000                	addi	s0,sp,32
    struct cpu *c = mycpu();
    800032be:	ffffd097          	auipc	ra,0xffffd
    800032c2:	536080e7          	jalr	1334(ra) # 800007f4 <mycpu>
    800032c6:	84aa                	mv	s1,a0
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800032c8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800032cc:	8b89                	andi	a5,a5,2
    if (intr_get())
    800032ce:	e79d                	bnez	a5,800032fc <pop_off+0x48>
        panic("pop_off - interruptible");
    if (c->noff < 1)
    800032d0:	5cbc                	lw	a5,120(s1)
    800032d2:	02f05e63          	blez	a5,8000330e <pop_off+0x5a>
        panic("pop_off");
    c->noff -= 1;
    800032d6:	5cbc                	lw	a5,120(s1)
    800032d8:	37fd                	addiw	a5,a5,-1
    800032da:	0007871b          	sext.w	a4,a5
    800032de:	dcbc                	sw	a5,120(s1)
    if (c->noff == 0 && c->intr_enable)
    800032e0:	eb09                	bnez	a4,800032f2 <pop_off+0x3e>
    800032e2:	5cfc                	lw	a5,124(s1)
    800032e4:	c799                	beqz	a5,800032f2 <pop_off+0x3e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800032e6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800032ea:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800032ee:	10079073          	csrw	sstatus,a5
        intr_on();
}
    800032f2:	60e2                	ld	ra,24(sp)
    800032f4:	6442                	ld	s0,16(sp)
    800032f6:	64a2                	ld	s1,8(sp)
    800032f8:	6105                	addi	sp,sp,32
    800032fa:	8082                	ret
        panic("pop_off - interruptible");
    800032fc:	00002517          	auipc	a0,0x2
    80003300:	0b450513          	addi	a0,a0,180 # 800053b0 <digits+0x2c8>
    80003304:	ffffe097          	auipc	ra,0xffffe
    80003308:	f7a080e7          	jalr	-134(ra) # 8000127e <panic>
    8000330c:	b7d1                	j	800032d0 <pop_off+0x1c>
        panic("pop_off");
    8000330e:	00002517          	auipc	a0,0x2
    80003312:	0ba50513          	addi	a0,a0,186 # 800053c8 <digits+0x2e0>
    80003316:	ffffe097          	auipc	ra,0xffffe
    8000331a:	f68080e7          	jalr	-152(ra) # 8000127e <panic>
    8000331e:	bf65                	j	800032d6 <pop_off+0x22>

0000000080003320 <spin_unlock>:
void spin_unlock(struct spinlock *lk) {
    80003320:	1101                	addi	sp,sp,-32
    80003322:	ec06                	sd	ra,24(sp)
    80003324:	e822                	sd	s0,16(sp)
    80003326:	e426                	sd	s1,8(sp)
    80003328:	1000                	addi	s0,sp,32
    8000332a:	84aa                	mv	s1,a0
    if (!spin_holding(lk)){
    8000332c:	00000097          	auipc	ra,0x0
    80003330:	ea6080e7          	jalr	-346(ra) # 800031d2 <spin_holding>
    80003334:	c115                	beqz	a0,80003358 <spin_unlock+0x38>
    lk->cpu = 0;
    80003336:	0004b423          	sd	zero,8(s1)
    __sync_synchronize();
    8000333a:	0ff0000f          	fence
    __sync_lock_release(&lk->locked);
    8000333e:	0f50000f          	fence	iorw,ow
    80003342:	0804a02f          	amoswap.w	zero,zero,(s1)
    pop_off();
    80003346:	00000097          	auipc	ra,0x0
    8000334a:	f6e080e7          	jalr	-146(ra) # 800032b4 <pop_off>
}
    8000334e:	60e2                	ld	ra,24(sp)
    80003350:	6442                	ld	s0,16(sp)
    80003352:	64a2                	ld	s1,8(sp)
    80003354:	6105                	addi	sp,sp,32
    80003356:	8082                	ret
        printf("%s\n", lk->name);
    80003358:	688c                	ld	a1,16(s1)
    8000335a:	00002517          	auipc	a0,0x2
    8000335e:	d5e50513          	addi	a0,a0,-674 # 800050b8 <etext+0xb8>
    80003362:	ffffe097          	auipc	ra,0xffffe
    80003366:	e58080e7          	jalr	-424(ra) # 800011ba <printf>
        panic("release");
    8000336a:	00002517          	auipc	a0,0x2
    8000336e:	06650513          	addi	a0,a0,102 # 800053d0 <digits+0x2e8>
    80003372:	ffffe097          	auipc	ra,0xffffe
    80003376:	f0c080e7          	jalr	-244(ra) # 8000127e <panic>
    8000337a:	bf75                	j	80003336 <spin_unlock+0x16>

000000008000337c <sleeplock_init>:
#include "lock.h"
#include "../process.h"
#include "../defs.h"

void sleeplock_init(struct sleeplock* lk, char* name)
{
    8000337c:	1101                	addi	sp,sp,-32
    8000337e:	ec06                	sd	ra,24(sp)
    80003380:	e822                	sd	s0,16(sp)
    80003382:	e426                	sd	s1,8(sp)
    80003384:	e04a                	sd	s2,0(sp)
    80003386:	1000                	addi	s0,sp,32
    80003388:	84aa                	mv	s1,a0
    8000338a:	892e                	mv	s2,a1
  spinlock_init(&lk->lk, "sleep lock");
    8000338c:	00002597          	auipc	a1,0x2
    80003390:	04c58593          	addi	a1,a1,76 # 800053d8 <digits+0x2f0>
    80003394:	0521                	addi	a0,a0,8
    80003396:	00000097          	auipc	ra,0x0
    8000339a:	e26080e7          	jalr	-474(ra) # 800031bc <spinlock_init>
  lk->name = name;
    8000339e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800033a2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800033a6:	0204a423          	sw	zero,40(s1)
}
    800033aa:	60e2                	ld	ra,24(sp)
    800033ac:	6442                	ld	s0,16(sp)
    800033ae:	64a2                	ld	s1,8(sp)
    800033b0:	6902                	ld	s2,0(sp)
    800033b2:	6105                	addi	sp,sp,32
    800033b4:	8082                	ret

00000000800033b6 <sleep_lock>:

void sleep_lock(struct sleeplock* lk)
{
    800033b6:	1101                	addi	sp,sp,-32
    800033b8:	ec06                	sd	ra,24(sp)
    800033ba:	e822                	sd	s0,16(sp)
    800033bc:	e426                	sd	s1,8(sp)
    800033be:	e04a                	sd	s2,0(sp)
    800033c0:	1000                	addi	s0,sp,32
    800033c2:	84aa                	mv	s1,a0
  spin_lock(&lk->lk);
    800033c4:	00850913          	addi	s2,a0,8
    800033c8:	854a                	mv	a0,s2
    800033ca:	00000097          	auipc	ra,0x0
    800033ce:	e82080e7          	jalr	-382(ra) # 8000324c <spin_lock>
  while (lk->locked) {
    800033d2:	409c                	lw	a5,0(s1)
    800033d4:	cb89                	beqz	a5,800033e6 <sleep_lock+0x30>
    sleep(lk, &lk->lk);
    800033d6:	85ca                	mv	a1,s2
    800033d8:	8526                	mv	a0,s1
    800033da:	ffffd097          	auipc	ra,0xffffd
    800033de:	538080e7          	jalr	1336(ra) # 80000912 <sleep>
  while (lk->locked) {
    800033e2:	409c                	lw	a5,0(s1)
    800033e4:	fbed                	bnez	a5,800033d6 <sleep_lock+0x20>
  }
  lk->locked = 1;
    800033e6:	4785                	li	a5,1
    800033e8:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800033ea:	ffffd097          	auipc	ra,0xffffd
    800033ee:	426080e7          	jalr	1062(ra) # 80000810 <myproc>
    800033f2:	5d1c                	lw	a5,56(a0)
    800033f4:	d49c                	sw	a5,40(s1)
  spin_unlock(&lk->lk);
    800033f6:	854a                	mv	a0,s2
    800033f8:	00000097          	auipc	ra,0x0
    800033fc:	f28080e7          	jalr	-216(ra) # 80003320 <spin_unlock>
}
    80003400:	60e2                	ld	ra,24(sp)
    80003402:	6442                	ld	s0,16(sp)
    80003404:	64a2                	ld	s1,8(sp)
    80003406:	6902                	ld	s2,0(sp)
    80003408:	6105                	addi	sp,sp,32
    8000340a:	8082                	ret

000000008000340c <sleep_unlock>:

void sleep_unlock(struct sleeplock* lk)
{
    8000340c:	1101                	addi	sp,sp,-32
    8000340e:	ec06                	sd	ra,24(sp)
    80003410:	e822                	sd	s0,16(sp)
    80003412:	e426                	sd	s1,8(sp)
    80003414:	e04a                	sd	s2,0(sp)
    80003416:	1000                	addi	s0,sp,32
    80003418:	84aa                	mv	s1,a0
  spin_lock(&lk->lk);
    8000341a:	00850913          	addi	s2,a0,8
    8000341e:	854a                	mv	a0,s2
    80003420:	00000097          	auipc	ra,0x0
    80003424:	e2c080e7          	jalr	-468(ra) # 8000324c <spin_lock>
  lk->locked = 0;
    80003428:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000342c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003430:	8526                	mv	a0,s1
    80003432:	ffffd097          	auipc	ra,0xffffd
    80003436:	5dc080e7          	jalr	1500(ra) # 80000a0e <wakeup>
  spin_unlock(&lk->lk);
    8000343a:	854a                	mv	a0,s2
    8000343c:	00000097          	auipc	ra,0x0
    80003440:	ee4080e7          	jalr	-284(ra) # 80003320 <spin_unlock>
}
    80003444:	60e2                	ld	ra,24(sp)
    80003446:	6442                	ld	s0,16(sp)
    80003448:	64a2                	ld	s1,8(sp)
    8000344a:	6902                	ld	s2,0(sp)
    8000344c:	6105                	addi	sp,sp,32
    8000344e:	8082                	ret

0000000080003450 <sleep_holding>:

int sleep_holding(struct sleeplock* lk)
{
    80003450:	7179                	addi	sp,sp,-48
    80003452:	f406                	sd	ra,40(sp)
    80003454:	f022                	sd	s0,32(sp)
    80003456:	ec26                	sd	s1,24(sp)
    80003458:	e84a                	sd	s2,16(sp)
    8000345a:	e44e                	sd	s3,8(sp)
    8000345c:	1800                	addi	s0,sp,48
    8000345e:	84aa                	mv	s1,a0
  int r;
  spin_lock(&lk->lk);
    80003460:	00850913          	addi	s2,a0,8
    80003464:	854a                	mv	a0,s2
    80003466:	00000097          	auipc	ra,0x0
    8000346a:	de6080e7          	jalr	-538(ra) # 8000324c <spin_lock>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000346e:	409c                	lw	a5,0(s1)
    80003470:	ef99                	bnez	a5,8000348e <sleep_holding+0x3e>
    80003472:	4481                	li	s1,0
  spin_unlock(&lk->lk);
    80003474:	854a                	mv	a0,s2
    80003476:	00000097          	auipc	ra,0x0
    8000347a:	eaa080e7          	jalr	-342(ra) # 80003320 <spin_unlock>
  return r;
}
    8000347e:	8526                	mv	a0,s1
    80003480:	70a2                	ld	ra,40(sp)
    80003482:	7402                	ld	s0,32(sp)
    80003484:	64e2                	ld	s1,24(sp)
    80003486:	6942                	ld	s2,16(sp)
    80003488:	69a2                	ld	s3,8(sp)
    8000348a:	6145                	addi	sp,sp,48
    8000348c:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000348e:	0284a983          	lw	s3,40(s1)
    80003492:	ffffd097          	auipc	ra,0xffffd
    80003496:	37e080e7          	jalr	894(ra) # 80000810 <myproc>
    8000349a:	5d04                	lw	s1,56(a0)
    8000349c:	413484b3          	sub	s1,s1,s3
    800034a0:	0014b493          	seqz	s1,s1
    800034a4:	bfc1                	j	80003474 <sleep_holding+0x24>

00000000800034a6 <trapinit>:

extern char trampoline[], uservec[], userret[];


// 配置中断处理程序
void trapinit(void) {
    800034a6:	1141                	addi	sp,sp,-16
    800034a8:	e422                	sd	s0,8(sp)
    800034aa:	0800                	addi	s0,sp,16
// Supervisor Trap-Vector Base Address
// low two bits are mode.
static inline void 
w_stvec(uint64 x)
{
  asm volatile("csrw stvec, %0" : : "r" (x));
    800034ac:	ffffd797          	auipc	a5,0xffffd
    800034b0:	02478793          	addi	a5,a5,36 # 800004d0 <kernelvec>
    800034b4:	10579073          	csrw	stvec,a5
    w_stvec((uint64) kernelvec);
}
    800034b8:	6422                	ld	s0,8(sp)
    800034ba:	0141                	addi	sp,sp,16
    800034bc:	8082                	ret

00000000800034be <proc_err>:

//
// 处理进程error的情况
// 中断处理程序检测到错误将会返回到这里
//
void proc_err() {
    800034be:	1141                	addi	sp,sp,-16
    800034c0:	e406                	sd	ra,8(sp)
    800034c2:	e022                	sd	s0,0(sp)
    800034c4:	0800                	addi	s0,sp,16
    exit(-1);
    800034c6:	557d                	li	a0,-1
    800034c8:	ffffd097          	auipc	ra,0xffffd
    800034cc:	73a080e7          	jalr	1850(ra) # 80000c02 <exit>
}
    800034d0:	60a2                	ld	ra,8(sp)
    800034d2:	6402                	ld	s0,0(sp)
    800034d4:	0141                	addi	sp,sp,16
    800034d6:	8082                	ret

00000000800034d8 <usertrapret>:
    }

    usertrapret();
}

void usertrapret() {
    800034d8:	1141                	addi	sp,sp,-16
    800034da:	e406                	sd	ra,8(sp)
    800034dc:	e022                	sd	s0,0(sp)
    800034de:	0800                	addi	s0,sp,16
    struct proc *p = myproc();
    800034e0:	ffffd097          	auipc	ra,0xffffd
    800034e4:	330080e7          	jalr	816(ra) # 80000810 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800034e8:	100027f3          	csrr	a5,sstatus

// disable device interrupts
static inline void
intr_off()
{
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800034ec:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800034ee:	10079073          	csrw	sstatus,a5
    // 现在将trap处理程序从kerneltrap()切换为usertrap(), 因此需要
    // 禁用中断直到我们返回用户空间。
    intr_off();

    // 现在返回用户空间，设置中断处理函数为trampoline.S的uservec()
    w_stvec(TRAMPOLINE + (uservec - trampoline));
    800034f2:	00001617          	auipc	a2,0x1
    800034f6:	b0e60613          	addi	a2,a2,-1266 # 80004000 <_trampoline>
    800034fa:	00001697          	auipc	a3,0x1
    800034fe:	b0668693          	addi	a3,a3,-1274 # 80004000 <_trampoline>
    80003502:	8e91                	sub	a3,a3,a2
    80003504:	040007b7          	lui	a5,0x4000
    80003508:	17fd                	addi	a5,a5,-1
    8000350a:	07b2                	slli	a5,a5,0xc
    8000350c:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000350e:	10569073          	csrw	stvec,a3

    // 设置trapframe, 以便下次的trap能够正常运行
    p->trapframe->kernel_satp = r_satp();         // 内核页表
    80003512:	6138                	ld	a4,64(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80003514:	180026f3          	csrr	a3,satp
    80003518:	e314                	sd	a3,0(a4)
    p->trapframe->kernel_sp = p->kstack + PGSIZE; // 进程的内核栈
    8000351a:	6138                	ld	a4,64(a0)
    8000351c:	7134                	ld	a3,96(a0)
    8000351e:	6585                	lui	a1,0x1
    80003520:	96ae                	add	a3,a3,a1
    80003522:	e714                	sd	a3,8(a4)
    p->trapframe->kernel_trap = (uint64) usertrap;
    80003524:	6138                	ld	a4,64(a0)
    80003526:	00000697          	auipc	a3,0x0
    8000352a:	13e68693          	addi	a3,a3,318 # 80003664 <usertrap>
    8000352e:	eb14                	sd	a3,16(a4)
    p->trapframe->kernel_hartid = r_tp();         // cpu id
    80003530:	6138                	ld	a4,64(a0)
// this core's hartid (core number), the index into cpus[].
static inline uint64
r_tp()
{
  uint64 x;
  asm volatile("mv %0, tp" : "=r" (x) );
    80003532:	8692                	mv	a3,tp
    80003534:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003536:	100026f3          	csrr	a3,sstatus

    // 设置trampoline.S中的sret返回用户空间所需要的寄存器

    // 设置S Previous Privilege(SPP)为User
    unsigned long x = r_sstatus();
    x &= ~SSTATUS_SPP; // 为用户模式清除SPP
    8000353a:	eff6f693          	andi	a3,a3,-257
    x |= SSTATUS_SPIE; // 允许用户模式下的中断
    8000353e:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003542:	10069073          	csrw	sstatus,a3
    w_sstatus(x);

    // 设置S的Exception Program Counter(epc)为保存的pc
    w_sepc(p->trapframe->epc);
    80003546:	6138                	ld	a4,64(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80003548:	6f18                	ld	a4,24(a4)
    8000354a:	14171073          	csrw	sepc,a4

    // 将用户页表转换为satp寄存器需要的格式
    uint64 satp = MAKE_SATP(p->pagetable);
    8000354e:	652c                	ld	a1,72(a0)
    80003550:	81b1                	srli	a1,a1,0xc

    // 跳转到虚拟内存顶端的trampoline.S, 它会切换页表为用户页表, 恢复用户
    // 寄存器, 并通过sret切换到用户模式。

    uint64 fn = TRAMPOLINE + (userret - trampoline);
    80003552:	00001717          	auipc	a4,0x1
    80003556:	b3e70713          	addi	a4,a4,-1218 # 80004090 <userret>
    8000355a:	8f11                	sub	a4,a4,a2
    8000355c:	97ba                	add	a5,a5,a4
    ((void (*)(uint64, uint64)) fn)(TRAPFRAME, satp);
    8000355e:	577d                	li	a4,-1
    80003560:	177e                	slli	a4,a4,0x3f
    80003562:	8dd9                	or	a1,a1,a4
    80003564:	02000537          	lui	a0,0x2000
    80003568:	157d                	addi	a0,a0,-1
    8000356a:	0536                	slli	a0,a0,0xd
    8000356c:	9782                	jalr	a5
}
    8000356e:	60a2                	ld	ra,8(sp)
    80003570:	6402                	ld	s0,0(sp)
    80003572:	0141                	addi	sp,sp,16
    80003574:	8082                	ret

0000000080003576 <clockintr>:
    w_sepc(sepc);
    w_sstatus(sstatus);
}

// 定时器中断处理程序
void clockintr() {
    80003576:	1101                	addi	sp,sp,-32
    80003578:	ec06                	sd	ra,24(sp)
    8000357a:	e822                	sd	s0,16(sp)
    8000357c:	e426                	sd	s1,8(sp)
    8000357e:	e04a                	sd	s2,0(sp)
    80003580:	1000                	addi	s0,sp,32
    spin_lock(&ticks_lock);
    80003582:	00068917          	auipc	s2,0x68
    80003586:	49690913          	addi	s2,s2,1174 # 8006ba18 <ticks_lock>
    8000358a:	854a                	mv	a0,s2
    8000358c:	00000097          	auipc	ra,0x0
    80003590:	cc0080e7          	jalr	-832(ra) # 8000324c <spin_lock>
    ticks++;
    80003594:	00003497          	auipc	s1,0x3
    80003598:	a8448493          	addi	s1,s1,-1404 # 80006018 <ticks>
    8000359c:	609c                	ld	a5,0(s1)
    8000359e:	0785                	addi	a5,a5,1
    800035a0:	e09c                	sd	a5,0(s1)
    spin_unlock(&ticks_lock);
    800035a2:	854a                	mv	a0,s2
    800035a4:	00000097          	auipc	ra,0x0
    800035a8:	d7c080e7          	jalr	-644(ra) # 80003320 <spin_unlock>
    wakeup(&ticks);
    800035ac:	8526                	mv	a0,s1
    800035ae:	ffffd097          	auipc	ra,0xffffd
    800035b2:	460080e7          	jalr	1120(ra) # 80000a0e <wakeup>
}
    800035b6:	60e2                	ld	ra,24(sp)
    800035b8:	6442                	ld	s0,16(sp)
    800035ba:	64a2                	ld	s1,8(sp)
    800035bc:	6902                	ld	s2,0(sp)
    800035be:	6105                	addi	sp,sp,32
    800035c0:	8082                	ret

00000000800035c2 <device_intr>:
// 设备中断处理程序
// 用于判断中断是否为外部和软件中断，并处理它
// 2: 时钟中断
// 1: 其他设备中断
// 0: 无法识别的中断
int device_intr() {
    800035c2:	1101                	addi	sp,sp,-32
    800035c4:	ec06                	sd	ra,24(sp)
    800035c6:	e822                	sd	s0,16(sp)
    800035c8:	e426                	sd	s1,8(sp)
    800035ca:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800035cc:	14202773          	csrr	a4,scause
    uint64 scause = r_scause();

    if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    800035d0:	00074d63          	bltz	a4,800035ea <device_intr+0x28>
        // 告诉PLIC该设备现在被允许再次抛出中断
        if (irq)
            plic_complete(irq);

        return 1;
    } else if (scause == 0x8000000000000001L) {
    800035d4:	57fd                	li	a5,-1
    800035d6:	17fe                	slli	a5,a5,0x3f
    800035d8:	0785                	addi	a5,a5,1
        }
        // 告知以收到软件中断，通过清除sip的SSIP位
        w_sip(r_sip() & ~2);
        return 2;
    } else {
        return 0;
    800035da:	4501                	li	a0,0
    } else if (scause == 0x8000000000000001L) {
    800035dc:	06f70363          	beq	a4,a5,80003642 <device_intr+0x80>
    }
}
    800035e0:	60e2                	ld	ra,24(sp)
    800035e2:	6442                	ld	s0,16(sp)
    800035e4:	64a2                	ld	s1,8(sp)
    800035e6:	6105                	addi	sp,sp,32
    800035e8:	8082                	ret
    if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    800035ea:	0ff77793          	andi	a5,a4,255
    800035ee:	46a5                	li	a3,9
    800035f0:	fed792e3          	bne	a5,a3,800035d4 <device_intr+0x12>
        int irq = plic_claim();
    800035f4:	ffffd097          	auipc	ra,0xffffd
    800035f8:	e80080e7          	jalr	-384(ra) # 80000474 <plic_claim>
    800035fc:	84aa                	mv	s1,a0
        if (irq == UART0_IRQ) {
    800035fe:	47a9                	li	a5,10
    80003600:	02f50763          	beq	a0,a5,8000362e <device_intr+0x6c>
        } else if (irq == VIRTIO0_IRQ) {
    80003604:	4785                	li	a5,1
    80003606:	02f50963          	beq	a0,a5,80003638 <device_intr+0x76>
        return 1;
    8000360a:	4505                	li	a0,1
        } else if (irq) {
    8000360c:	d8f1                	beqz	s1,800035e0 <device_intr+0x1e>
            printf("unexpected interrupt irq=%d\n", irq);
    8000360e:	85a6                	mv	a1,s1
    80003610:	00002517          	auipc	a0,0x2
    80003614:	dd850513          	addi	a0,a0,-552 # 800053e8 <digits+0x300>
    80003618:	ffffe097          	auipc	ra,0xffffe
    8000361c:	ba2080e7          	jalr	-1118(ra) # 800011ba <printf>
            plic_complete(irq);
    80003620:	8526                	mv	a0,s1
    80003622:	ffffd097          	auipc	ra,0xffffd
    80003626:	e76080e7          	jalr	-394(ra) # 80000498 <plic_complete>
        return 1;
    8000362a:	4505                	li	a0,1
    8000362c:	bf55                	j	800035e0 <device_intr+0x1e>
            uart_intr();
    8000362e:	ffffd097          	auipc	ra,0xffffd
    80003632:	bee080e7          	jalr	-1042(ra) # 8000021c <uart_intr>
    80003636:	b7ed                	j	80003620 <device_intr+0x5e>
            virtio_disk_intr();
    80003638:	fffff097          	auipc	ra,0xfffff
    8000363c:	90c080e7          	jalr	-1780(ra) # 80001f44 <virtio_disk_intr>
    80003640:	b7c5                	j	80003620 <device_intr+0x5e>
        if (cpuid() == 0) {
    80003642:	ffffd097          	auipc	ra,0xffffd
    80003646:	1a2080e7          	jalr	418(ra) # 800007e4 <cpuid>
    8000364a:	c901                	beqz	a0,8000365a <device_intr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    8000364c:	144027f3          	csrr	a5,sip
        w_sip(r_sip() & ~2);
    80003650:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80003652:	14479073          	csrw	sip,a5
        return 2;
    80003656:	4509                	li	a0,2
    80003658:	b761                	j	800035e0 <device_intr+0x1e>
            clockintr();
    8000365a:	00000097          	auipc	ra,0x0
    8000365e:	f1c080e7          	jalr	-228(ra) # 80003576 <clockintr>
    80003662:	b7ed                	j	8000364c <device_intr+0x8a>

0000000080003664 <usertrap>:
void usertrap(void) {
    80003664:	1101                	addi	sp,sp,-32
    80003666:	ec06                	sd	ra,24(sp)
    80003668:	e822                	sd	s0,16(sp)
    8000366a:	e426                	sd	s1,8(sp)
    8000366c:	e04a                	sd	s2,0(sp)
    8000366e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003670:	100027f3          	csrr	a5,sstatus
    if ((r_sstatus() & SSTATUS_SPP) != 0)
    80003674:	1007f793          	andi	a5,a5,256
    80003678:	e3ad                	bnez	a5,800036da <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000367a:	ffffd797          	auipc	a5,0xffffd
    8000367e:	e5678793          	addi	a5,a5,-426 # 800004d0 <kernelvec>
    80003682:	10579073          	csrw	stvec,a5
    struct proc *p = myproc();
    80003686:	ffffd097          	auipc	ra,0xffffd
    8000368a:	18a080e7          	jalr	394(ra) # 80000810 <myproc>
    8000368e:	84aa                	mv	s1,a0
    p->trapframe->epc = r_sepc();
    80003690:	613c                	ld	a5,64(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003692:	14102773          	csrr	a4,sepc
    80003696:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003698:	14202773          	csrr	a4,scause
    if (r_scause() == 8) {
    8000369c:	47a1                	li	a5,8
    8000369e:	04f71d63          	bne	a4,a5,800036f8 <usertrap+0x94>
        if (p->killed)
    800036a2:	591c                	lw	a5,48(a0)
    800036a4:	e7a1                	bnez	a5,800036ec <usertrap+0x88>
        p->trapframe->epc += 4;
    800036a6:	60b8                	ld	a4,64(s1)
    800036a8:	6f1c                	ld	a5,24(a4)
    800036aa:	0791                	addi	a5,a5,4
    800036ac:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800036ae:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800036b2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800036b6:	10079073          	csrw	sstatus,a5
        syscall();
    800036ba:	00000097          	auipc	ra,0x0
    800036be:	276080e7          	jalr	630(ra) # 80003930 <syscall>
    if (p->killed)
    800036c2:	589c                	lw	a5,48(s1)
    800036c4:	ebc9                	bnez	a5,80003756 <usertrap+0xf2>
    usertrapret();
    800036c6:	00000097          	auipc	ra,0x0
    800036ca:	e12080e7          	jalr	-494(ra) # 800034d8 <usertrapret>
}
    800036ce:	60e2                	ld	ra,24(sp)
    800036d0:	6442                	ld	s0,16(sp)
    800036d2:	64a2                	ld	s1,8(sp)
    800036d4:	6902                	ld	s2,0(sp)
    800036d6:	6105                	addi	sp,sp,32
    800036d8:	8082                	ret
        panic("usertrap: not from user mode");
    800036da:	00002517          	auipc	a0,0x2
    800036de:	d2e50513          	addi	a0,a0,-722 # 80005408 <digits+0x320>
    800036e2:	ffffe097          	auipc	ra,0xffffe
    800036e6:	b9c080e7          	jalr	-1124(ra) # 8000127e <panic>
    800036ea:	bf41                	j	8000367a <usertrap+0x16>
            exit(-1);
    800036ec:	557d                	li	a0,-1
    800036ee:	ffffd097          	auipc	ra,0xffffd
    800036f2:	514080e7          	jalr	1300(ra) # 80000c02 <exit>
    800036f6:	bf45                	j	800036a6 <usertrap+0x42>
    } else if ((which_dev = device_intr()) != 0) {
    800036f8:	00000097          	auipc	ra,0x0
    800036fc:	eca080e7          	jalr	-310(ra) # 800035c2 <device_intr>
    80003700:	892a                	mv	s2,a0
    80003702:	c501                	beqz	a0,8000370a <usertrap+0xa6>
    if (p->killed)
    80003704:	589c                	lw	a5,48(s1)
    80003706:	c3a1                	beqz	a5,80003746 <usertrap+0xe2>
    80003708:	a815                	j	8000373c <usertrap+0xd8>
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000370a:	142025f3          	csrr	a1,scause
        printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    8000370e:	5c90                	lw	a2,56(s1)
    80003710:	00002517          	auipc	a0,0x2
    80003714:	d1850513          	addi	a0,a0,-744 # 80005428 <digits+0x340>
    80003718:	ffffe097          	auipc	ra,0xffffe
    8000371c:	aa2080e7          	jalr	-1374(ra) # 800011ba <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003720:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80003724:	14302673          	csrr	a2,stval
        printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003728:	00002517          	auipc	a0,0x2
    8000372c:	d3050513          	addi	a0,a0,-720 # 80005458 <digits+0x370>
    80003730:	ffffe097          	auipc	ra,0xffffe
    80003734:	a8a080e7          	jalr	-1398(ra) # 800011ba <printf>
        p->killed = 1;
    80003738:	4785                	li	a5,1
    8000373a:	d89c                	sw	a5,48(s1)
        exit(-1);
    8000373c:	557d                	li	a0,-1
    8000373e:	ffffd097          	auipc	ra,0xffffd
    80003742:	4c4080e7          	jalr	1220(ra) # 80000c02 <exit>
    if (which_dev == 2) {
    80003746:	4789                	li	a5,2
    80003748:	f6f91fe3          	bne	s2,a5,800036c6 <usertrap+0x62>
        yield();
    8000374c:	ffffd097          	auipc	ra,0xffffd
    80003750:	59a080e7          	jalr	1434(ra) # 80000ce6 <yield>
    80003754:	bf8d                	j	800036c6 <usertrap+0x62>
    int which_dev = 0;
    80003756:	4901                	li	s2,0
    80003758:	b7d5                	j	8000373c <usertrap+0xd8>

000000008000375a <kerneltrap>:
void kerneltrap() {
    8000375a:	7179                	addi	sp,sp,-48
    8000375c:	f406                	sd	ra,40(sp)
    8000375e:	f022                	sd	s0,32(sp)
    80003760:	ec26                	sd	s1,24(sp)
    80003762:	e84a                	sd	s2,16(sp)
    80003764:	e44e                	sd	s3,8(sp)
    80003766:	e052                	sd	s4,0(sp)
    80003768:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    8000376a:	ffffd097          	auipc	ra,0xffffd
    8000376e:	0a6080e7          	jalr	166(ra) # 80000810 <myproc>
    80003772:	84aa                	mv	s1,a0
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003774:	141029f3          	csrr	s3,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003778:	10002973          	csrr	s2,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000377c:	14202a73          	csrr	s4,scause
    if ((sstatus & SSTATUS_SPP) == 0)
    80003780:	10097793          	andi	a5,s2,256
    80003784:	c79d                	beqz	a5,800037b2 <kerneltrap+0x58>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003786:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000378a:	8b89                	andi	a5,a5,2
    if (intr_get() != 0)
    8000378c:	ef85                	bnez	a5,800037c4 <kerneltrap+0x6a>
    which_dev = device_intr();
    8000378e:	00000097          	auipc	ra,0x0
    80003792:	e34080e7          	jalr	-460(ra) # 800035c2 <device_intr>
    if (which_dev == 0) { // 未知来源
    80003796:	c121                	beqz	a0,800037d6 <kerneltrap+0x7c>
    if (which_dev == 2 && p != 0 && p->state == RUNNING) { // 时钟中断
    80003798:	4789                	li	a5,2
    8000379a:	06f51b63          	bne	a0,a5,80003810 <kerneltrap+0xb6>
    8000379e:	c8ad                	beqz	s1,80003810 <kerneltrap+0xb6>
    800037a0:	4c98                	lw	a4,24(s1)
    800037a2:	478d                	li	a5,3
    800037a4:	06f71663          	bne	a4,a5,80003810 <kerneltrap+0xb6>
        yield();
    800037a8:	ffffd097          	auipc	ra,0xffffd
    800037ac:	53e080e7          	jalr	1342(ra) # 80000ce6 <yield>
    800037b0:	a085                	j	80003810 <kerneltrap+0xb6>
        panic("kerneltrap: not from supervisor mode");
    800037b2:	00002517          	auipc	a0,0x2
    800037b6:	cc650513          	addi	a0,a0,-826 # 80005478 <digits+0x390>
    800037ba:	ffffe097          	auipc	ra,0xffffe
    800037be:	ac4080e7          	jalr	-1340(ra) # 8000127e <panic>
    800037c2:	b7d1                	j	80003786 <kerneltrap+0x2c>
        panic("kerneltrap: interrupts enabled");
    800037c4:	00002517          	auipc	a0,0x2
    800037c8:	cdc50513          	addi	a0,a0,-804 # 800054a0 <digits+0x3b8>
    800037cc:	ffffe097          	auipc	ra,0xffffe
    800037d0:	ab2080e7          	jalr	-1358(ra) # 8000127e <panic>
    800037d4:	bf6d                	j	8000378e <kerneltrap+0x34>
        printf("scause %p\n", scause);
    800037d6:	85d2                	mv	a1,s4
    800037d8:	00002517          	auipc	a0,0x2
    800037dc:	ce850513          	addi	a0,a0,-792 # 800054c0 <digits+0x3d8>
    800037e0:	ffffe097          	auipc	ra,0xffffe
    800037e4:	9da080e7          	jalr	-1574(ra) # 800011ba <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800037e8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800037ec:	14302673          	csrr	a2,stval
        printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    800037f0:	00002517          	auipc	a0,0x2
    800037f4:	ce050513          	addi	a0,a0,-800 # 800054d0 <digits+0x3e8>
    800037f8:	ffffe097          	auipc	ra,0xffffe
    800037fc:	9c2080e7          	jalr	-1598(ra) # 800011ba <printf>
        panic("kerneltrap");
    80003800:	00002517          	auipc	a0,0x2
    80003804:	ce850513          	addi	a0,a0,-792 # 800054e8 <digits+0x400>
    80003808:	ffffe097          	auipc	ra,0xffffe
    8000380c:	a76080e7          	jalr	-1418(ra) # 8000127e <panic>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80003810:	14199073          	csrw	sepc,s3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003814:	10091073          	csrw	sstatus,s2
}
    80003818:	70a2                	ld	ra,40(sp)
    8000381a:	7402                	ld	s0,32(sp)
    8000381c:	64e2                	ld	s1,24(sp)
    8000381e:	6942                	ld	s2,16(sp)
    80003820:	69a2                	ld	s3,8(sp)
    80003822:	6a02                	ld	s4,0(sp)
    80003824:	6145                	addi	sp,sp,48
    80003826:	8082                	ret

0000000080003828 <argraw>:
#include "../process.h"
#include "../defs.h"
#include "syscall.h"


uint64 argraw(int n) {
    80003828:	1101                	addi	sp,sp,-32
    8000382a:	ec06                	sd	ra,24(sp)
    8000382c:	e822                	sd	s0,16(sp)
    8000382e:	e426                	sd	s1,8(sp)
    80003830:	1000                	addi	s0,sp,32
    80003832:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80003834:	ffffd097          	auipc	ra,0xffffd
    80003838:	fdc080e7          	jalr	-36(ra) # 80000810 <myproc>
    switch (n) {
    8000383c:	4795                	li	a5,5
    8000383e:	0497e163          	bltu	a5,s1,80003880 <argraw+0x58>
    80003842:	048a                	slli	s1,s1,0x2
    80003844:	00002717          	auipc	a4,0x2
    80003848:	ce470713          	addi	a4,a4,-796 # 80005528 <digits+0x440>
    8000384c:	94ba                	add	s1,s1,a4
    8000384e:	409c                	lw	a5,0(s1)
    80003850:	97ba                	add	a5,a5,a4
    80003852:	8782                	jr	a5
        case 0:
            return p->trapframe->a0;
    80003854:	613c                	ld	a5,64(a0)
    80003856:	7ba8                	ld	a0,112(a5)
        case 5:
            return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    80003858:	60e2                	ld	ra,24(sp)
    8000385a:	6442                	ld	s0,16(sp)
    8000385c:	64a2                	ld	s1,8(sp)
    8000385e:	6105                	addi	sp,sp,32
    80003860:	8082                	ret
            return p->trapframe->a1;
    80003862:	613c                	ld	a5,64(a0)
    80003864:	7fa8                	ld	a0,120(a5)
    80003866:	bfcd                	j	80003858 <argraw+0x30>
            return p->trapframe->a2;
    80003868:	613c                	ld	a5,64(a0)
    8000386a:	63c8                	ld	a0,128(a5)
    8000386c:	b7f5                	j	80003858 <argraw+0x30>
            return p->trapframe->a3;
    8000386e:	613c                	ld	a5,64(a0)
    80003870:	67c8                	ld	a0,136(a5)
    80003872:	b7dd                	j	80003858 <argraw+0x30>
            return p->trapframe->a4;
    80003874:	613c                	ld	a5,64(a0)
    80003876:	6bc8                	ld	a0,144(a5)
    80003878:	b7c5                	j	80003858 <argraw+0x30>
            return p->trapframe->a5;
    8000387a:	613c                	ld	a5,64(a0)
    8000387c:	6fc8                	ld	a0,152(a5)
    8000387e:	bfe9                	j	80003858 <argraw+0x30>
    panic("argraw");
    80003880:	00002517          	auipc	a0,0x2
    80003884:	c7850513          	addi	a0,a0,-904 # 800054f8 <digits+0x410>
    80003888:	ffffe097          	auipc	ra,0xffffe
    8000388c:	9f6080e7          	jalr	-1546(ra) # 8000127e <panic>
    return -1;
    80003890:	557d                	li	a0,-1
    80003892:	b7d9                	j	80003858 <argraw+0x30>

0000000080003894 <argaddr>:
 *
 * @param n 参数的偏移量
 * @param ip 结果地址
 * @return
 */
int argaddr(int n, uint64 *ip) {
    80003894:	1101                	addi	sp,sp,-32
    80003896:	ec06                	sd	ra,24(sp)
    80003898:	e822                	sd	s0,16(sp)
    8000389a:	e426                	sd	s1,8(sp)
    8000389c:	1000                	addi	s0,sp,32
    8000389e:	84ae                	mv	s1,a1
    *ip = argraw(n);
    800038a0:	00000097          	auipc	ra,0x0
    800038a4:	f88080e7          	jalr	-120(ra) # 80003828 <argraw>
    800038a8:	e088                	sd	a0,0(s1)
    return 0;
}
    800038aa:	4501                	li	a0,0
    800038ac:	60e2                	ld	ra,24(sp)
    800038ae:	6442                	ld	s0,16(sp)
    800038b0:	64a2                	ld	s1,8(sp)
    800038b2:	6105                	addi	sp,sp,32
    800038b4:	8082                	ret

00000000800038b6 <fetchstr>:
/**
 * 从当前进程的addr位置取出0结束的字符串。
 * 返回字符串的长度, 不包括0, 失败返回-1
 * @return
 */
int fetchstr(uint64 addr, char *buf, int max) {
    800038b6:	7179                	addi	sp,sp,-48
    800038b8:	f406                	sd	ra,40(sp)
    800038ba:	f022                	sd	s0,32(sp)
    800038bc:	ec26                	sd	s1,24(sp)
    800038be:	e84a                	sd	s2,16(sp)
    800038c0:	e44e                	sd	s3,8(sp)
    800038c2:	1800                	addi	s0,sp,48
    800038c4:	892a                	mv	s2,a0
    800038c6:	84ae                	mv	s1,a1
    800038c8:	89b2                	mv	s3,a2
    struct proc *p = myproc();
    800038ca:	ffffd097          	auipc	ra,0xffffd
    800038ce:	f46080e7          	jalr	-186(ra) # 80000810 <myproc>
    int err = copyinstr(p->pagetable, buf, addr, max);
    800038d2:	86ce                	mv	a3,s3
    800038d4:	864a                	mv	a2,s2
    800038d6:	85a6                	mv	a1,s1
    800038d8:	6528                	ld	a0,72(a0)
    800038da:	ffffe097          	auipc	ra,0xffffe
    800038de:	f94080e7          	jalr	-108(ra) # 8000186e <copyinstr>
    if (err < 0)
    800038e2:	00054863          	bltz	a0,800038f2 <fetchstr+0x3c>
        return err;
    return strlen(buf);
    800038e6:	8526                	mv	a0,s1
    800038e8:	ffffd097          	auipc	ra,0xffffd
    800038ec:	4c6080e7          	jalr	1222(ra) # 80000dae <strlen>
    800038f0:	2501                	sext.w	a0,a0
}
    800038f2:	70a2                	ld	ra,40(sp)
    800038f4:	7402                	ld	s0,32(sp)
    800038f6:	64e2                	ld	s1,24(sp)
    800038f8:	6942                	ld	s2,16(sp)
    800038fa:	69a2                	ld	s3,8(sp)
    800038fc:	6145                	addi	sp,sp,48
    800038fe:	8082                	ret

0000000080003900 <argstr>:
/**
 * 获取第n个系统调用参数作为0结束的字符串
 *  复制到buf中, 最多复制max
 */

int argstr(int n, char *buf, int max) {
    80003900:	1101                	addi	sp,sp,-32
    80003902:	ec06                	sd	ra,24(sp)
    80003904:	e822                	sd	s0,16(sp)
    80003906:	e426                	sd	s1,8(sp)
    80003908:	e04a                	sd	s2,0(sp)
    8000390a:	1000                	addi	s0,sp,32
    8000390c:	84ae                	mv	s1,a1
    8000390e:	8932                	mv	s2,a2
    *ip = argraw(n);
    80003910:	00000097          	auipc	ra,0x0
    80003914:	f18080e7          	jalr	-232(ra) # 80003828 <argraw>
    uint64 addr;
    if (argaddr(n, &addr) < 0)
        return -1;
    return fetchstr(addr, buf, max);
    80003918:	864a                	mv	a2,s2
    8000391a:	85a6                	mv	a1,s1
    8000391c:	00000097          	auipc	ra,0x0
    80003920:	f9a080e7          	jalr	-102(ra) # 800038b6 <fetchstr>
}
    80003924:	60e2                	ld	ra,24(sp)
    80003926:	6442                	ld	s0,16(sp)
    80003928:	64a2                	ld	s1,8(sp)
    8000392a:	6902                	ld	s2,0(sp)
    8000392c:	6105                	addi	sp,sp,32
    8000392e:	8082                	ret

0000000080003930 <syscall>:
        [SYS_read] sys_read,
};

#define NELEM(x) (sizeof(x)/sizeof((x)[0]))

void syscall(void) {
    80003930:	1101                	addi	sp,sp,-32
    80003932:	ec06                	sd	ra,24(sp)
    80003934:	e822                	sd	s0,16(sp)
    80003936:	e426                	sd	s1,8(sp)
    80003938:	e04a                	sd	s2,0(sp)
    8000393a:	1000                	addi	s0,sp,32
    int num;
    struct proc *p = myproc();
    8000393c:	ffffd097          	auipc	ra,0xffffd
    80003940:	ed4080e7          	jalr	-300(ra) # 80000810 <myproc>
    80003944:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    80003946:	04053903          	ld	s2,64(a0)
    8000394a:	0a893783          	ld	a5,168(s2)
    8000394e:	0007869b          	sext.w	a3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80003952:	37fd                	addiw	a5,a5,-1
    80003954:	470d                	li	a4,3
    80003956:	00f76f63          	bltu	a4,a5,80003974 <syscall+0x44>
    8000395a:	00369713          	slli	a4,a3,0x3
    8000395e:	00002797          	auipc	a5,0x2
    80003962:	be278793          	addi	a5,a5,-1054 # 80005540 <syscalls>
    80003966:	97ba                	add	a5,a5,a4
    80003968:	639c                	ld	a5,0(a5)
    8000396a:	c789                	beqz	a5,80003974 <syscall+0x44>
        p->trapframe->a0 = syscalls[num]();
    8000396c:	9782                	jalr	a5
    8000396e:	06a93823          	sd	a0,112(s2)
    80003972:	a03d                	j	800039a0 <syscall+0x70>
    } else {
        printf("%d %s: unknown sys call %d\n",
    80003974:	0d848613          	addi	a2,s1,216
    80003978:	5c8c                	lw	a1,56(s1)
    8000397a:	00002517          	auipc	a0,0x2
    8000397e:	b8650513          	addi	a0,a0,-1146 # 80005500 <digits+0x418>
    80003982:	ffffe097          	auipc	ra,0xffffe
    80003986:	838080e7          	jalr	-1992(ra) # 800011ba <printf>
               p->pid, p->name, num);
        p->trapframe->a0 = -1;
    8000398a:	60bc                	ld	a5,64(s1)
    8000398c:	577d                	li	a4,-1
    8000398e:	fbb8                	sd	a4,112(a5)
        panic("error");
    80003990:	00002517          	auipc	a0,0x2
    80003994:	b9050513          	addi	a0,a0,-1136 # 80005520 <digits+0x438>
    80003998:	ffffe097          	auipc	ra,0xffffe
    8000399c:	8e6080e7          	jalr	-1818(ra) # 8000127e <panic>
    }
    800039a0:	60e2                	ld	ra,24(sp)
    800039a2:	6442                	ld	s0,16(sp)
    800039a4:	64a2                	ld	s1,8(sp)
    800039a6:	6902                	ld	s2,0(sp)
    800039a8:	6105                	addi	sp,sp,32
    800039aa:	8082                	ret

00000000800039ac <sys_putchar>:
#include "../memlayout.h"
#include "../lock/lock.h"
#include "../process.h"
#include "../defs.h"

uint64 sys_putchar(void) {
    800039ac:	1141                	addi	sp,sp,-16
    800039ae:	e406                	sd	ra,8(sp)
    800039b0:	e022                	sd	s0,0(sp)
    800039b2:	0800                	addi	s0,sp,16
    putc(0, argraw(0));
    800039b4:	4501                	li	a0,0
    800039b6:	00000097          	auipc	ra,0x0
    800039ba:	e72080e7          	jalr	-398(ra) # 80003828 <argraw>
    800039be:	0ff57593          	andi	a1,a0,255
    800039c2:	4501                	li	a0,0
    800039c4:	ffffd097          	auipc	ra,0xffffd
    800039c8:	888080e7          	jalr	-1912(ra) # 8000024c <putc>
    return 0;
}
    800039cc:	4501                	li	a0,0
    800039ce:	60a2                	ld	ra,8(sp)
    800039d0:	6402                	ld	s0,0(sp)
    800039d2:	0141                	addi	sp,sp,16
    800039d4:	8082                	ret

00000000800039d6 <sys_exec>:

uint64 sys_exec(void) {
    800039d6:	7175                	addi	sp,sp,-144
    800039d8:	e506                	sd	ra,136(sp)
    800039da:	e122                	sd	s0,128(sp)
    800039dc:	0900                	addi	s0,sp,144
    char path[MAXPATH];
    if (argstr(0, path, MAXPATH) < 0) {
    800039de:	08000613          	li	a2,128
    800039e2:	f7040593          	addi	a1,s0,-144
    800039e6:	4501                	li	a0,0
    800039e8:	00000097          	auipc	ra,0x0
    800039ec:	f18080e7          	jalr	-232(ra) # 80003900 <argstr>
    800039f0:	87aa                	mv	a5,a0
        return -1;
    800039f2:	557d                	li	a0,-1
    if (argstr(0, path, MAXPATH) < 0) {
    800039f4:	0207c363          	bltz	a5,80003a1a <sys_exec+0x44>
    }
    printf("%s\n",path);
    800039f8:	f7040593          	addi	a1,s0,-144
    800039fc:	00001517          	auipc	a0,0x1
    80003a00:	6bc50513          	addi	a0,a0,1724 # 800050b8 <etext+0xb8>
    80003a04:	ffffd097          	auipc	ra,0xffffd
    80003a08:	7b6080e7          	jalr	1974(ra) # 800011ba <printf>
    return exec(path, 0);
    80003a0c:	4581                	li	a1,0
    80003a0e:	f7040513          	addi	a0,s0,-144
    80003a12:	ffffe097          	auipc	ra,0xffffe
    80003a16:	72c080e7          	jalr	1836(ra) # 8000213e <exec>
}
    80003a1a:	60aa                	ld	ra,136(sp)
    80003a1c:	640a                	ld	s0,128(sp)
    80003a1e:	6149                	addi	sp,sp,144
    80003a20:	8082                	ret

0000000080003a22 <sys_read>:

uint64 sys_read(void) {
    80003a22:	7139                	addi	sp,sp,-64
    80003a24:	fc06                	sd	ra,56(sp)
    80003a26:	f822                	sd	s0,48(sp)
    80003a28:	f426                	sd	s1,40(sp)
    80003a2a:	f04a                	sd	s2,32(sp)
    80003a2c:	ec4e                	sd	s3,24(sp)
    80003a2e:	0080                	addi	s0,sp,64
    80003a30:	737d                	lui	t1,0xfffff
    80003a32:	911a                	add	sp,sp,t1
    uint64 va = 0;
    80003a34:	fc043423          	sd	zero,-56(s0)
    char buf[PGSIZE];
    if (argaddr(0, &va) < 0) {
    80003a38:	fc840593          	addi	a1,s0,-56
    80003a3c:	4501                	li	a0,0
    80003a3e:	00000097          	auipc	ra,0x0
    80003a42:	e56080e7          	jalr	-426(ra) # 80003894 <argaddr>
        return -1;
    80003a46:	57fd                	li	a5,-1
    if (argaddr(0, &va) < 0) {
    80003a48:	04054363          	bltz	a0,80003a8e <sys_read+0x6c>
    }
    read_line(buf);
    80003a4c:	74fd                	lui	s1,0xfffff
    80003a4e:	14e1                	addi	s1,s1,-8
    80003a50:	fd040793          	addi	a5,s0,-48
    80003a54:	94be                	add	s1,s1,a5
    80003a56:	8526                	mv	a0,s1
    80003a58:	ffffd097          	auipc	ra,0xffffd
    80003a5c:	80e080e7          	jalr	-2034(ra) # 80000266 <read_line>
    copyout(myproc()->pagetable, va, buf, strlen(buf));
    80003a60:	ffffd097          	auipc	ra,0xffffd
    80003a64:	db0080e7          	jalr	-592(ra) # 80000810 <myproc>
    80003a68:	04853903          	ld	s2,72(a0)
    80003a6c:	fc843983          	ld	s3,-56(s0)
    80003a70:	8526                	mv	a0,s1
    80003a72:	ffffd097          	auipc	ra,0xffffd
    80003a76:	33c080e7          	jalr	828(ra) # 80000dae <strlen>
    80003a7a:	0005069b          	sext.w	a3,a0
    80003a7e:	8626                	mv	a2,s1
    80003a80:	85ce                	mv	a1,s3
    80003a82:	854a                	mv	a0,s2
    80003a84:	ffffe097          	auipc	ra,0xffffe
    80003a88:	ea8080e7          	jalr	-344(ra) # 8000192c <copyout>
    return 0;
    80003a8c:	4781                	li	a5,0
}
    80003a8e:	853e                	mv	a0,a5
    80003a90:	6305                	lui	t1,0x1
    80003a92:	911a                	add	sp,sp,t1
    80003a94:	70e2                	ld	ra,56(sp)
    80003a96:	7442                	ld	s0,48(sp)
    80003a98:	74a2                	ld	s1,40(sp)
    80003a9a:	7902                	ld	s2,32(sp)
    80003a9c:	69e2                	ld	s3,24(sp)
    80003a9e:	6121                	addi	sp,sp,64
    80003aa0:	8082                	ret
	...

0000000080004000 <_trampoline>:
    80004000:	14051573          	csrrw	a0,sscratch,a0
    80004004:	02153423          	sd	ra,40(a0)
    80004008:	02253823          	sd	sp,48(a0)
    8000400c:	02353c23          	sd	gp,56(a0)
    80004010:	04453023          	sd	tp,64(a0)
    80004014:	04553423          	sd	t0,72(a0)
    80004018:	04653823          	sd	t1,80(a0)
    8000401c:	04753c23          	sd	t2,88(a0)
    80004020:	f120                	sd	s0,96(a0)
    80004022:	f524                	sd	s1,104(a0)
    80004024:	fd2c                	sd	a1,120(a0)
    80004026:	e150                	sd	a2,128(a0)
    80004028:	e554                	sd	a3,136(a0)
    8000402a:	e958                	sd	a4,144(a0)
    8000402c:	ed5c                	sd	a5,152(a0)
    8000402e:	0b053023          	sd	a6,160(a0)
    80004032:	0b153423          	sd	a7,168(a0)
    80004036:	0b253823          	sd	s2,176(a0)
    8000403a:	0b353c23          	sd	s3,184(a0)
    8000403e:	0d453023          	sd	s4,192(a0)
    80004042:	0d553423          	sd	s5,200(a0)
    80004046:	0d653823          	sd	s6,208(a0)
    8000404a:	0d753c23          	sd	s7,216(a0)
    8000404e:	0f853023          	sd	s8,224(a0)
    80004052:	0f953423          	sd	s9,232(a0)
    80004056:	0fa53823          	sd	s10,240(a0)
    8000405a:	0fb53c23          	sd	s11,248(a0)
    8000405e:	11c53023          	sd	t3,256(a0)
    80004062:	11d53423          	sd	t4,264(a0)
    80004066:	11e53823          	sd	t5,272(a0)
    8000406a:	11f53c23          	sd	t6,280(a0)
    8000406e:	140022f3          	csrr	t0,sscratch
    80004072:	06553823          	sd	t0,112(a0)
    80004076:	00853103          	ld	sp,8(a0)
    8000407a:	02053203          	ld	tp,32(a0)
    8000407e:	01053283          	ld	t0,16(a0)
    80004082:	00053303          	ld	t1,0(a0)
    80004086:	18031073          	csrw	satp,t1
    8000408a:	12000073          	sfence.vma
    8000408e:	8282                	jr	t0

0000000080004090 <userret>:
    80004090:	18059073          	csrw	satp,a1
    80004094:	12000073          	sfence.vma
    80004098:	07053283          	ld	t0,112(a0)
    8000409c:	14029073          	csrw	sscratch,t0
    800040a0:	02853083          	ld	ra,40(a0)
    800040a4:	03053103          	ld	sp,48(a0)
    800040a8:	03853183          	ld	gp,56(a0)
    800040ac:	04053203          	ld	tp,64(a0)
    800040b0:	04853283          	ld	t0,72(a0)
    800040b4:	05053303          	ld	t1,80(a0)
    800040b8:	05853383          	ld	t2,88(a0)
    800040bc:	7120                	ld	s0,96(a0)
    800040be:	7524                	ld	s1,104(a0)
    800040c0:	7d2c                	ld	a1,120(a0)
    800040c2:	6150                	ld	a2,128(a0)
    800040c4:	6554                	ld	a3,136(a0)
    800040c6:	6958                	ld	a4,144(a0)
    800040c8:	6d5c                	ld	a5,152(a0)
    800040ca:	0a053803          	ld	a6,160(a0)
    800040ce:	0a853883          	ld	a7,168(a0)
    800040d2:	0b053903          	ld	s2,176(a0)
    800040d6:	0b853983          	ld	s3,184(a0)
    800040da:	0c053a03          	ld	s4,192(a0)
    800040de:	0c853a83          	ld	s5,200(a0)
    800040e2:	0d053b03          	ld	s6,208(a0)
    800040e6:	0d853b83          	ld	s7,216(a0)
    800040ea:	0e053c03          	ld	s8,224(a0)
    800040ee:	0e853c83          	ld	s9,232(a0)
    800040f2:	0f053d03          	ld	s10,240(a0)
    800040f6:	0f853d83          	ld	s11,248(a0)
    800040fa:	10053e03          	ld	t3,256(a0)
    800040fe:	10853e83          	ld	t4,264(a0)
    80004102:	11053f03          	ld	t5,272(a0)
    80004106:	11853f83          	ld	t6,280(a0)
    8000410a:	14051573          	csrrw	a0,sscratch,a0
    8000410e:	10200073          	sret
	...
