
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00006117          	auipc	sp,0x6
    80000004:	13010113          	addi	sp,sp,304 # 80006130 <stack0>
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
    80000026:	0200c737          	lui	a4,0x200c
    8000002a:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000002e:	0037961b          	slliw	a2,a5,0x3
    80000032:	020046b7          	lui	a3,0x2004
    80000036:	9636                	add	a2,a2,a3
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
    8000004a:	00006717          	auipc	a4,0x6
    8000004e:	fe670713          	addi	a4,a4,-26 # 80006030 <mscratch0>
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
    w_mscratch((uint64)scratch);

    // 设置机器模式下的trap处理程序
    w_mtvec((uint64)timervec);
    8000005c:	00000797          	auipc	a5,0x0
    80000060:	76478793          	addi	a5,a5,1892 # 800007c0 <timervec>
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000064:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus

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
    80000094:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ff92de7>
    80000098:	8ff9                	and	a5,a5,a4
    x |= MSTATUS_MPP_S;
    8000009a:	6705                	lui	a4,0x1
    8000009c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a2:	30079073          	csrw	mstatus,a5
    w_mepc((uint64)main);
    800000a6:	00000797          	auipc	a5,0x0
    800000aa:	04678793          	addi	a5,a5,70 # 800000ec <main>
  asm volatile("csrw mepc, %0" : : "r" (x));
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
    int id = r_mhartid();
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
    80000100:	05c50513          	addi	a0,a0,92 # 80005158 <etext+0x158>
    80000104:	00001097          	auipc	ra,0x1
    80000108:	420080e7          	jalr	1056(ra) # 80001524 <printf>
    printf("xv6 kernel is booting\n");
    8000010c:	00005517          	auipc	a0,0x5
    80000110:	ef450513          	addi	a0,a0,-268 # 80005000 <etext>
    80000114:	00001097          	auipc	ra,0x1
    80000118:	410080e7          	jalr	1040(ra) # 80001524 <printf>
    printf("\n");
    8000011c:	00005517          	auipc	a0,0x5
    80000120:	03c50513          	addi	a0,a0,60 # 80005158 <etext+0x158>
    80000124:	00001097          	auipc	ra,0x1
    80000128:	400080e7          	jalr	1024(ra) # 80001524 <printf>
    trapinit();             // 初始化trap
    8000012c:	00000097          	auipc	ra,0x0
    80000130:	2f2080e7          	jalr	754(ra) # 8000041e <trapinit>
    plicinit();             // 初始化plic
    80000134:	00000097          	auipc	ra,0x0
    80000138:	4c4080e7          	jalr	1220(ra) # 800005f8 <plicinit>
    plicinithart();
    8000013c:	00000097          	auipc	ra,0x0
    80000140:	4d2080e7          	jalr	1234(ra) # 8000060e <plicinithart>
    kernel_mem_init();      // 初始化内存
    80000144:	00002097          	auipc	ra,0x2
    80000148:	9bc080e7          	jalr	-1604(ra) # 80001b00 <kernel_mem_init>
    kernel_vm_init();       // 初始化内核虚拟内存
    8000014c:	00002097          	auipc	ra,0x2
    80000150:	c16080e7          	jalr	-1002(ra) # 80001d62 <kernel_vm_init>
    vm_hart_init();         // 启用分页
    80000154:	00002097          	auipc	ra,0x2
    80000158:	a3e080e7          	jalr	-1474(ra) # 80001b92 <vm_hart_init>
    virtio_disk_init();     // 初始化磁盘
    8000015c:	00002097          	auipc	ra,0x2
    80000160:	044080e7          	jalr	68(ra) # 800021a0 <virtio_disk_init>
    init_inode_cache();     // 初始化inode cache
    80000164:	00003097          	auipc	ra,0x3
    80000168:	a80080e7          	jalr	-1408(ra) # 80002be4 <init_inode_cache>
    init_buf();             // 初始化磁盘块缓冲
    8000016c:	00003097          	auipc	ra,0x3
    80000170:	464080e7          	jalr	1124(ra) # 800035d0 <init_buf>
    init_process_table();   // 初始化进程表
    80000174:	00000097          	auipc	ra,0x0
    80000178:	674080e7          	jalr	1652(ra) # 800007e8 <init_process_table>
    init_first_process();   // 初始化第一个进程
    8000017c:	00000097          	auipc	ra,0x0
    80000180:	760080e7          	jalr	1888(ra) # 800008dc <init_first_process>
    scheduler();
    80000184:	00001097          	auipc	ra,0x1
    80000188:	a6a080e7          	jalr	-1430(ra) # 80000bee <scheduler>
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
    800001d0:	100007b7          	lui	a5,0x10000
    800001d4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800001d8:	0ff7f793          	andi	a5,a5,255
    800001dc:	0207f793          	andi	a5,a5,32
    800001e0:	dbe5                	beqz	a5,800001d0 <uartputc_sync+0x6>
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
    8000021c:	1141                	addi	sp,sp,-16
    8000021e:	e406                	sd	ra,8(sp)
    80000220:	e022                	sd	s0,0(sp)
    80000222:	0800                	addi	s0,sp,16
  while (1)
  {
    int c = uartgetc();
    80000224:	00000097          	auipc	ra,0x0
    80000228:	fd0080e7          	jalr	-48(ra) # 800001f4 <uartgetc>
    if (c == -1)
    8000022c:	57fd                	li	a5,-1
    8000022e:	00f50963          	beq	a0,a5,80000240 <uart_intr+0x24>
      break;
    console_intr(c);
    80000232:	0ff57513          	andi	a0,a0,255
    80000236:	00000097          	auipc	ra,0x0
    8000023a:	11e080e7          	jalr	286(ra) # 80000354 <console_intr>
  {
    8000023e:	b7dd                	j	80000224 <uart_intr+0x8>
  }
}
    80000240:	60a2                	ld	ra,8(sp)
    80000242:	6402                	ld	s0,0(sp)
    80000244:	0141                	addi	sp,sp,16
    80000246:	8082                	ret

0000000080000248 <putc>:
    int read_index;
    int write_index;
} consloe_buf;

void putc(int fd, char ch)
{
    80000248:	1141                	addi	sp,sp,-16
    8000024a:	e406                	sd	ra,8(sp)
    8000024c:	e022                	sd	s0,0(sp)
    8000024e:	0800                	addi	s0,sp,16
    uartputc_sync(ch);
    80000250:	852e                	mv	a0,a1
    80000252:	00000097          	auipc	ra,0x0
    80000256:	f78080e7          	jalr	-136(ra) # 800001ca <uartputc_sync>
}
    8000025a:	60a2                	ld	ra,8(sp)
    8000025c:	6402                	ld	s0,0(sp)
    8000025e:	0141                	addi	sp,sp,16
    80000260:	8082                	ret

0000000080000262 <read_line>:

int read_line(char* s)
{
    80000262:	1101                	addi	sp,sp,-32
    80000264:	ec06                	sd	ra,24(sp)
    80000266:	e822                	sd	s0,16(sp)
    80000268:	e426                	sd	s1,8(sp)
    8000026a:	e04a                	sd	s2,0(sp)
    8000026c:	1000                	addi	s0,sp,32
    8000026e:	892a                	mv	s2,a0
    int cnt = 0;

    spin_lock(&consloe_buf.lock);
    80000270:	00007497          	auipc	s1,0x7
    80000274:	ec048493          	addi	s1,s1,-320 # 80007130 <consloe_buf>
    80000278:	8526                	mv	a0,s1
    8000027a:	00003097          	auipc	ra,0x3
    8000027e:	5c4080e7          	jalr	1476(ra) # 8000383e <spin_lock>
    sleep(&consloe_buf, &consloe_buf.lock);
    80000282:	85a6                	mv	a1,s1
    80000284:	8526                	mv	a0,s1
    80000286:	00001097          	auipc	ra,0x1
    8000028a:	850080e7          	jalr	-1968(ra) # 80000ad6 <sleep>
    for (int i = consloe_buf.read_index; i < consloe_buf.write_index; i++) {
    8000028e:	0e04a703          	lw	a4,224(s1)
    int cnt = 0;
    80000292:	4481                	li	s1,0
    for (int i = consloe_buf.read_index; i < consloe_buf.write_index; i++) {
    80000294:	00007797          	auipc	a5,0x7
    80000298:	f807a783          	lw	a5,-128(a5) # 80007214 <consloe_buf+0xe4>
    8000029c:	04f75b63          	bge	a4,a5,800002f2 <read_line+0x90>
        s[cnt++] = consloe_buf.buf[i % INPUT_BUF];
    800002a0:	0c800793          	li	a5,200
    800002a4:	02f7663b          	remw	a2,a4,a5
    800002a8:	0014859b          	addiw	a1,s1,1
    800002ac:	009906b3          	add	a3,s2,s1
    800002b0:	00007797          	auipc	a5,0x7
    800002b4:	e8078793          	addi	a5,a5,-384 # 80007130 <consloe_buf>
    800002b8:	97b2                	add	a5,a5,a2
    800002ba:	0187c603          	lbu	a2,24(a5)
    800002be:	00c68023          	sb	a2,0(a3)
        if (consloe_buf.buf[i % INPUT_BUF] == '\n') {
    800002c2:	0187c683          	lbu	a3,24(a5)
    800002c6:	47a9                	li	a5,10
    800002c8:	00f68563          	beq	a3,a5,800002d2 <read_line+0x70>
    for (int i = consloe_buf.read_index; i < consloe_buf.write_index; i++) {
    800002cc:	2705                	addiw	a4,a4,1
        s[cnt++] = consloe_buf.buf[i % INPUT_BUF];
    800002ce:	84ae                	mv	s1,a1
    800002d0:	b7d1                	j	80000294 <read_line+0x32>
            consloe_buf.read_index = i + 1;
    800002d2:	2705                	addiw	a4,a4,1
    800002d4:	00007517          	auipc	a0,0x7
    800002d8:	e5c50513          	addi	a0,a0,-420 # 80007130 <consloe_buf>
    800002dc:	0ee52023          	sw	a4,224(a0)
            s[cnt - 1] = 0;
    800002e0:	15fd                	addi	a1,a1,-1
    800002e2:	95ca                	add	a1,a1,s2
    800002e4:	00058023          	sb	zero,0(a1)
            spin_unlock(&consloe_buf.lock);
    800002e8:	00003097          	auipc	ra,0x3
    800002ec:	628080e7          	jalr	1576(ra) # 80003910 <spin_unlock>
            return cnt - 1;
    800002f0:	a811                	j	80000304 <read_line+0xa2>
        }
    }
    spin_unlock(&consloe_buf.lock);
    800002f2:	00007517          	auipc	a0,0x7
    800002f6:	e3e50513          	addi	a0,a0,-450 # 80007130 <consloe_buf>
    800002fa:	00003097          	auipc	ra,0x3
    800002fe:	616080e7          	jalr	1558(ra) # 80003910 <spin_unlock>
    return -1;
    80000302:	54fd                	li	s1,-1
}
    80000304:	8526                	mv	a0,s1
    80000306:	60e2                	ld	ra,24(sp)
    80000308:	6442                	ld	s0,16(sp)
    8000030a:	64a2                	ld	s1,8(sp)
    8000030c:	6902                	ld	s2,0(sp)
    8000030e:	6105                	addi	sp,sp,32
    80000310:	8082                	ret

0000000080000312 <console_putc>:

void console_putc(int c)
{
    80000312:	1141                	addi	sp,sp,-16
    80000314:	e406                	sd	ra,8(sp)
    80000316:	e022                	sd	s0,0(sp)
    80000318:	0800                	addi	s0,sp,16
    if (c == BACKSPACE) {
    8000031a:	10000793          	li	a5,256
    8000031e:	00f50a63          	beq	a0,a5,80000332 <console_putc+0x20>
        // if the user typed backspace, overwrite with a space.
        uartputc_sync('\b');
        uartputc_sync(' ');
        uartputc_sync('\b');
    } else {
        uartputc_sync(c);
    80000322:	00000097          	auipc	ra,0x0
    80000326:	ea8080e7          	jalr	-344(ra) # 800001ca <uartputc_sync>
    }
}
    8000032a:	60a2                	ld	ra,8(sp)
    8000032c:	6402                	ld	s0,0(sp)
    8000032e:	0141                	addi	sp,sp,16
    80000330:	8082                	ret
        uartputc_sync('\b');
    80000332:	4521                	li	a0,8
    80000334:	00000097          	auipc	ra,0x0
    80000338:	e96080e7          	jalr	-362(ra) # 800001ca <uartputc_sync>
        uartputc_sync(' ');
    8000033c:	02000513          	li	a0,32
    80000340:	00000097          	auipc	ra,0x0
    80000344:	e8a080e7          	jalr	-374(ra) # 800001ca <uartputc_sync>
        uartputc_sync('\b');
    80000348:	4521                	li	a0,8
    8000034a:	00000097          	auipc	ra,0x0
    8000034e:	e80080e7          	jalr	-384(ra) # 800001ca <uartputc_sync>
    80000352:	bfe1                	j	8000032a <console_putc+0x18>

0000000080000354 <console_intr>:

void console_intr(char c)
{
    80000354:	1101                	addi	sp,sp,-32
    80000356:	ec06                	sd	ra,24(sp)
    80000358:	e822                	sd	s0,16(sp)
    8000035a:	e426                	sd	s1,8(sp)
    8000035c:	1000                	addi	s0,sp,32
    switch (c) {
    8000035e:	47c1                	li	a5,16
    80000360:	04f50263          	beq	a0,a5,800003a4 <console_intr+0x50>
    80000364:	84aa                	mv	s1,a0
    80000366:	07f00793          	li	a5,127
    8000036a:	04f51663          	bne	a0,a5,800003b6 <console_intr+0x62>

    case '\x7f': // 退格
        if (consloe_buf.read_index != consloe_buf.write_index) {
    8000036e:	00007797          	auipc	a5,0x7
    80000372:	dc278793          	addi	a5,a5,-574 # 80007130 <consloe_buf>
    80000376:	0e07a703          	lw	a4,224(a5)
    8000037a:	0e47a783          	lw	a5,228(a5)
    8000037e:	02f70763          	beq	a4,a5,800003ac <console_intr+0x58>
            consloe_buf.write_index--;
    80000382:	37fd                	addiw	a5,a5,-1
    80000384:	00007717          	auipc	a4,0x7
    80000388:	e8f72823          	sw	a5,-368(a4) # 80007214 <consloe_buf+0xe4>
            console_putc(BACKSPACE);
    8000038c:	10000513          	li	a0,256
    80000390:	00000097          	auipc	ra,0x0
    80000394:	f82080e7          	jalr	-126(ra) # 80000312 <console_putc>
            console_putc('\a');
    80000398:	451d                	li	a0,7
    8000039a:	00000097          	auipc	ra,0x0
    8000039e:	f78080e7          	jalr	-136(ra) # 80000312 <console_putc>
    800003a2:	a029                	j	800003ac <console_intr+0x58>
        }
        break;
    case CTRL('P'):
        print_proc();
    800003a4:	00001097          	auipc	ra,0x1
    800003a8:	bc8080e7          	jalr	-1080(ra) # 80000f6c <print_proc>
        if (c == '\n') {
            wakeup(&consloe_buf);
        }
        break;
    }
}
    800003ac:	60e2                	ld	ra,24(sp)
    800003ae:	6442                	ld	s0,16(sp)
    800003b0:	64a2                	ld	s1,8(sp)
    800003b2:	6105                	addi	sp,sp,32
    800003b4:	8082                	ret
        c = (c == '\r') ? '\n' : c;
    800003b6:	47b5                	li	a5,13
    800003b8:	04f50463          	beq	a0,a5,80000400 <console_intr+0xac>
        console_putc(c);
    800003bc:	8526                	mv	a0,s1
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	f54080e7          	jalr	-172(ra) # 80000312 <console_putc>
        consloe_buf.buf[consloe_buf.write_index++ % INPUT_BUF] = c;
    800003c6:	00007797          	auipc	a5,0x7
    800003ca:	d6a78793          	addi	a5,a5,-662 # 80007130 <consloe_buf>
    800003ce:	0e47a703          	lw	a4,228(a5)
    800003d2:	0017069b          	addiw	a3,a4,1
    800003d6:	0ed7a223          	sw	a3,228(a5)
    800003da:	0c800693          	li	a3,200
    800003de:	02d7673b          	remw	a4,a4,a3
    800003e2:	97ba                	add	a5,a5,a4
    800003e4:	00978c23          	sb	s1,24(a5)
        if (c == '\n') {
    800003e8:	47a9                	li	a5,10
    800003ea:	fcf491e3          	bne	s1,a5,800003ac <console_intr+0x58>
            wakeup(&consloe_buf);
    800003ee:	00007517          	auipc	a0,0x7
    800003f2:	d4250513          	addi	a0,a0,-702 # 80007130 <consloe_buf>
    800003f6:	00000097          	auipc	ra,0x0
    800003fa:	7be080e7          	jalr	1982(ra) # 80000bb4 <wakeup>
}
    800003fe:	b77d                	j	800003ac <console_intr+0x58>
        c = (c == '\r') ? '\n' : c;
    80000400:	44a9                	li	s1,10
    80000402:	bf6d                	j	800003bc <console_intr+0x68>

0000000080000404 <proc_err>:

//
// 处理进程error的情况
// 中断处理程序检测到错误将会返回到这里
//
void proc_err() {
    80000404:	1141                	addi	sp,sp,-16
    80000406:	e406                	sd	ra,8(sp)
    80000408:	e022                	sd	s0,0(sp)
    8000040a:	0800                	addi	s0,sp,16
    exit(-1);
    8000040c:	557d                	li	a0,-1
    8000040e:	00001097          	auipc	ra,0x1
    80000412:	98a080e7          	jalr	-1654(ra) # 80000d98 <exit>
}
    80000416:	60a2                	ld	ra,8(sp)
    80000418:	6402                	ld	s0,0(sp)
    8000041a:	0141                	addi	sp,sp,16
    8000041c:	8082                	ret

000000008000041e <trapinit>:
void trapinit(void) {
    8000041e:	1141                	addi	sp,sp,-16
    80000420:	e422                	sd	s0,8(sp)
    80000422:	0800                	addi	s0,sp,16
    w_stvec((uint64) kernelvec);
    80000424:	00000797          	auipc	a5,0x0
    80000428:	27c78793          	addi	a5,a5,636 # 800006a0 <kernelvec>
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000042c:	10579073          	csrw	stvec,a5
}
    80000430:	6422                	ld	s0,8(sp)
    80000432:	0141                	addi	sp,sp,16
    80000434:	8082                	ret

0000000080000436 <clockintr>:
    w_sepc(sepc);
    w_sstatus(sstatus);
}

// 定时器中断处理程序
void clockintr() {
    80000436:	1101                	addi	sp,sp,-32
    80000438:	ec06                	sd	ra,24(sp)
    8000043a:	e822                	sd	s0,16(sp)
    8000043c:	e426                	sd	s1,8(sp)
    8000043e:	e04a                	sd	s2,0(sp)
    80000440:	1000                	addi	s0,sp,32
    spin_lock(&ticks_lock);
    80000442:	00007917          	auipc	s2,0x7
    80000446:	dd690913          	addi	s2,s2,-554 # 80007218 <ticks_lock>
    8000044a:	854a                	mv	a0,s2
    8000044c:	00003097          	auipc	ra,0x3
    80000450:	3f2080e7          	jalr	1010(ra) # 8000383e <spin_lock>
    ticks++;
    80000454:	00006497          	auipc	s1,0x6
    80000458:	bbc48493          	addi	s1,s1,-1092 # 80006010 <ticks>
    8000045c:	609c                	ld	a5,0(s1)
    8000045e:	0785                	addi	a5,a5,1
    80000460:	e09c                	sd	a5,0(s1)
    spin_unlock(&ticks_lock);
    80000462:	854a                	mv	a0,s2
    80000464:	00003097          	auipc	ra,0x3
    80000468:	4ac080e7          	jalr	1196(ra) # 80003910 <spin_unlock>
    wakeup(&ticks);
    8000046c:	8526                	mv	a0,s1
    8000046e:	00000097          	auipc	ra,0x0
    80000472:	746080e7          	jalr	1862(ra) # 80000bb4 <wakeup>
}
    80000476:	60e2                	ld	ra,24(sp)
    80000478:	6442                	ld	s0,16(sp)
    8000047a:	64a2                	ld	s1,8(sp)
    8000047c:	6902                	ld	s2,0(sp)
    8000047e:	6105                	addi	sp,sp,32
    80000480:	8082                	ret

0000000080000482 <device_intr>:
// 设备中断处理程序
// 用于判断中断是否为外部和软件中断，并处理它
// 2: 时钟中断
// 1: 其他设备中断
// 0: 无法识别的中断
int device_intr() {
    80000482:	1101                	addi	sp,sp,-32
    80000484:	ec06                	sd	ra,24(sp)
    80000486:	e822                	sd	s0,16(sp)
    80000488:	e426                	sd	s1,8(sp)
    8000048a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000048c:	14202773          	csrr	a4,scause
    uint64 scause = r_scause();

    if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80000490:	00074d63          	bltz	a4,800004aa <device_intr+0x28>
        // 告诉PLIC该设备现在被允许再次抛出中断
        if (irq)
            plic_complete(irq);

        return 1;
    } else if (scause == 0x8000000000000001L) {
    80000494:	57fd                	li	a5,-1
    80000496:	17fe                	slli	a5,a5,0x3f
    80000498:	0785                	addi	a5,a5,1
    8000049a:	06f70663          	beq	a4,a5,80000506 <device_intr+0x84>
        }
        // 告知以收到软件中断，通过清除sip的SSIP位
        w_sip(r_sip() & ~2);
        return 2;
    } else {
        return 0;
    8000049e:	4501                	li	a0,0
    }
}
    800004a0:	60e2                	ld	ra,24(sp)
    800004a2:	6442                	ld	s0,16(sp)
    800004a4:	64a2                	ld	s1,8(sp)
    800004a6:	6105                	addi	sp,sp,32
    800004a8:	8082                	ret
    if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    800004aa:	0ff77793          	andi	a5,a4,255
    800004ae:	46a5                	li	a3,9
    800004b0:	fed792e3          	bne	a5,a3,80000494 <device_intr+0x12>
        int irq = plic_claim();
    800004b4:	00000097          	auipc	ra,0x0
    800004b8:	194080e7          	jalr	404(ra) # 80000648 <plic_claim>
    800004bc:	84aa                	mv	s1,a0
        if (irq == UART0_IRQ) {
    800004be:	47a9                	li	a5,10
    800004c0:	00f50963          	beq	a0,a5,800004d2 <device_intr+0x50>
        } else if (irq == VIRTIO0_IRQ) {
    800004c4:	4785                	li	a5,1
    800004c6:	00f50b63          	beq	a0,a5,800004dc <device_intr+0x5a>
        } else if (irq) {
    800004ca:	ed11                	bnez	a0,800004e6 <device_intr+0x64>
        if (irq)
    800004cc:	e49d                	bnez	s1,800004fa <device_intr+0x78>
        return 1;
    800004ce:	4505                	li	a0,1
    800004d0:	bfc1                	j	800004a0 <device_intr+0x1e>
            uart_intr();
    800004d2:	00000097          	auipc	ra,0x0
    800004d6:	d4a080e7          	jalr	-694(ra) # 8000021c <uart_intr>
    800004da:	bfcd                	j	800004cc <device_intr+0x4a>
            virtio_disk_intr();
    800004dc:	00002097          	auipc	ra,0x2
    800004e0:	04c080e7          	jalr	76(ra) # 80002528 <virtio_disk_intr>
    800004e4:	b7e5                	j	800004cc <device_intr+0x4a>
            printf("unexpected interrupt irq=%d\n", irq);
    800004e6:	85aa                	mv	a1,a0
    800004e8:	00005517          	auipc	a0,0x5
    800004ec:	b3050513          	addi	a0,a0,-1232 # 80005018 <etext+0x18>
    800004f0:	00001097          	auipc	ra,0x1
    800004f4:	034080e7          	jalr	52(ra) # 80001524 <printf>
    800004f8:	bfd1                	j	800004cc <device_intr+0x4a>
            plic_complete(irq);
    800004fa:	8526                	mv	a0,s1
    800004fc:	00000097          	auipc	ra,0x0
    80000500:	172080e7          	jalr	370(ra) # 8000066e <plic_complete>
    80000504:	b7e9                	j	800004ce <device_intr+0x4c>
        if (cpuid() == 0) {
    80000506:	00000097          	auipc	ra,0x0
    8000050a:	48a080e7          	jalr	1162(ra) # 80000990 <cpuid>
    8000050e:	c901                	beqz	a0,8000051e <device_intr+0x9c>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80000510:	144027f3          	csrr	a5,sip
        w_sip(r_sip() & ~2);
    80000514:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80000516:	14479073          	csrw	sip,a5
        return 2;
    8000051a:	4509                	li	a0,2
    8000051c:	b751                	j	800004a0 <device_intr+0x1e>
            clockintr();
    8000051e:	00000097          	auipc	ra,0x0
    80000522:	f18080e7          	jalr	-232(ra) # 80000436 <clockintr>
    80000526:	b7ed                	j	80000510 <device_intr+0x8e>

0000000080000528 <kerneltrap>:
void kerneltrap() {
    80000528:	7179                	addi	sp,sp,-48
    8000052a:	f406                	sd	ra,40(sp)
    8000052c:	f022                	sd	s0,32(sp)
    8000052e:	ec26                	sd	s1,24(sp)
    80000530:	e84a                	sd	s2,16(sp)
    80000532:	e44e                	sd	s3,8(sp)
    80000534:	e052                	sd	s4,0(sp)
    80000536:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80000538:	00000097          	auipc	ra,0x0
    8000053c:	48c080e7          	jalr	1164(ra) # 800009c4 <myproc>
    80000540:	84aa                	mv	s1,a0
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80000542:	141029f3          	csrr	s3,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000546:	10002973          	csrr	s2,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000054a:	14202a73          	csrr	s4,scause
    if ((sstatus & SSTATUS_SPP) == 0)
    8000054e:	10097793          	andi	a5,s2,256
    80000552:	cf95                	beqz	a5,8000058e <kerneltrap+0x66>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000554:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000558:	8b89                	andi	a5,a5,2
    if (intr_get() != 0)
    8000055a:	e3b9                	bnez	a5,800005a0 <kerneltrap+0x78>
    which_dev = device_intr();
    8000055c:	00000097          	auipc	ra,0x0
    80000560:	f26080e7          	jalr	-218(ra) # 80000482 <device_intr>
    if (which_dev == 0) { // 未知来源
    80000564:	c539                	beqz	a0,800005b2 <kerneltrap+0x8a>
    } else if (which_dev == 1) { // uart中断
    80000566:	4785                	li	a5,1
    80000568:	06f50c63          	beq	a0,a5,800005e0 <kerneltrap+0xb8>
    } else if (which_dev == 2 && p != 0 && p->state == RUNNING) { // 时钟中断
    8000056c:	4789                	li	a5,2
    8000056e:	06f51963          	bne	a0,a5,800005e0 <kerneltrap+0xb8>
    80000572:	c4bd                	beqz	s1,800005e0 <kerneltrap+0xb8>
    80000574:	4c98                	lw	a4,24(s1)
    80000576:	478d                	li	a5,3
    80000578:	06f71463          	bne	a4,a5,800005e0 <kerneltrap+0xb8>
        trap_pc = sepc;
    8000057c:	00006797          	auipc	a5,0x6
    80000580:	a937b623          	sd	s3,-1396(a5) # 80006008 <trap_pc>
        sepc = (uint64) proc_sched;
    80000584:	00000997          	auipc	s3,0x0
    80000588:	1ac98993          	addi	s3,s3,428 # 80000730 <proc_sched>
    8000058c:	a891                	j	800005e0 <kerneltrap+0xb8>
        panic("kerneltrap: not from supervisor mode");
    8000058e:	00005517          	auipc	a0,0x5
    80000592:	aaa50513          	addi	a0,a0,-1366 # 80005038 <etext+0x38>
    80000596:	00001097          	auipc	ra,0x1
    8000059a:	046080e7          	jalr	70(ra) # 800015dc <panic>
    8000059e:	bf5d                	j	80000554 <kerneltrap+0x2c>
        panic("kerneltrap: interrupts enabled");
    800005a0:	00005517          	auipc	a0,0x5
    800005a4:	ac050513          	addi	a0,a0,-1344 # 80005060 <etext+0x60>
    800005a8:	00001097          	auipc	ra,0x1
    800005ac:	034080e7          	jalr	52(ra) # 800015dc <panic>
    800005b0:	b775                	j	8000055c <kerneltrap+0x34>
        printf("pid=%d error\n", p->pid);
    800005b2:	5c8c                	lw	a1,56(s1)
    800005b4:	00005517          	auipc	a0,0x5
    800005b8:	acc50513          	addi	a0,a0,-1332 # 80005080 <etext+0x80>
    800005bc:	00001097          	auipc	ra,0x1
    800005c0:	f68080e7          	jalr	-152(ra) # 80001524 <printf>
        printf("scause=%d sepc=%p\n", scause, sepc);
    800005c4:	864e                	mv	a2,s3
    800005c6:	85d2                	mv	a1,s4
    800005c8:	00005517          	auipc	a0,0x5
    800005cc:	ac850513          	addi	a0,a0,-1336 # 80005090 <etext+0x90>
    800005d0:	00001097          	auipc	ra,0x1
    800005d4:	f54080e7          	jalr	-172(ra) # 80001524 <printf>
        sepc = (uint64) proc_err; // 将异常的返回地址设置为proc_err
    800005d8:	00000997          	auipc	s3,0x0
    800005dc:	e2c98993          	addi	s3,s3,-468 # 80000404 <proc_err>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800005e0:	14199073          	csrw	sepc,s3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800005e4:	10091073          	csrw	sstatus,s2
}
    800005e8:	70a2                	ld	ra,40(sp)
    800005ea:	7402                	ld	s0,32(sp)
    800005ec:	64e2                	ld	s1,24(sp)
    800005ee:	6942                	ld	s2,16(sp)
    800005f0:	69a2                	ld	s3,8(sp)
    800005f2:	6a02                	ld	s4,0(sp)
    800005f4:	6145                	addi	sp,sp,48
    800005f6:	8082                	ret

00000000800005f8 <plicinit>:
//


void
plicinit(void)
{
    800005f8:	1141                	addi	sp,sp,-16
    800005fa:	e422                	sd	s0,8(sp)
    800005fc:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  // 设置IRQ的属性为非零
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800005fe:	0c0007b7          	lui	a5,0xc000
    80000602:	4705                	li	a4,1
    80000604:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80000606:	c3d8                	sw	a4,4(a5)
}
    80000608:	6422                	ld	s0,8(sp)
    8000060a:	0141                	addi	sp,sp,16
    8000060c:	8082                	ret

000000008000060e <plicinithart>:

void
plicinithart(void)
{
    8000060e:	1141                	addi	sp,sp,-16
    80000610:	e406                	sd	ra,8(sp)
    80000612:	e022                	sd	s0,0(sp)
    80000614:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80000616:	00000097          	auipc	ra,0x0
    8000061a:	37a080e7          	jalr	890(ra) # 80000990 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    8000061e:	0085179b          	slliw	a5,a0,0x8
    80000622:	0c002737          	lui	a4,0xc002
    80000626:	08070713          	addi	a4,a4,128 # c002080 <_entry-0x73ffdf80>
    8000062a:	97ba                	add	a5,a5,a4
    8000062c:	40200713          	li	a4,1026
    80000630:	c398                	sw	a4,0(a5)

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80000632:	00d5151b          	slliw	a0,a0,0xd
    80000636:	0c2017b7          	lui	a5,0xc201
    8000063a:	953e                	add	a0,a0,a5
    8000063c:	00052023          	sw	zero,0(a0)
}
    80000640:	60a2                	ld	ra,8(sp)
    80000642:	6402                	ld	s0,0(sp)
    80000644:	0141                	addi	sp,sp,16
    80000646:	8082                	ret

0000000080000648 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80000648:	1141                	addi	sp,sp,-16
    8000064a:	e406                	sd	ra,8(sp)
    8000064c:	e022                	sd	s0,0(sp)
    8000064e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80000650:	00000097          	auipc	ra,0x0
    80000654:	340080e7          	jalr	832(ra) # 80000990 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80000658:	00d5151b          	slliw	a0,a0,0xd
    8000065c:	0c2017b7          	lui	a5,0xc201
    80000660:	0791                	addi	a5,a5,4
    80000662:	953e                	add	a0,a0,a5
  return irq;
}
    80000664:	4108                	lw	a0,0(a0)
    80000666:	60a2                	ld	ra,8(sp)
    80000668:	6402                	ld	s0,0(sp)
    8000066a:	0141                	addi	sp,sp,16
    8000066c:	8082                	ret

000000008000066e <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000066e:	1101                	addi	sp,sp,-32
    80000670:	ec06                	sd	ra,24(sp)
    80000672:	e822                	sd	s0,16(sp)
    80000674:	e426                	sd	s1,8(sp)
    80000676:	1000                	addi	s0,sp,32
    80000678:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000067a:	00000097          	auipc	ra,0x0
    8000067e:	316080e7          	jalr	790(ra) # 80000990 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80000682:	00d5179b          	slliw	a5,a0,0xd
    80000686:	0c201537          	lui	a0,0xc201
    8000068a:	0511                	addi	a0,a0,4
    8000068c:	97aa                	add	a5,a5,a0
    8000068e:	c384                	sw	s1,0(a5)
}
    80000690:	60e2                	ld	ra,24(sp)
    80000692:	6442                	ld	s0,16(sp)
    80000694:	64a2                	ld	s1,8(sp)
    80000696:	6105                	addi	sp,sp,32
    80000698:	8082                	ret
    8000069a:	0000                	unimp
    8000069c:	0000                	unimp
	...

00000000800006a0 <kernelvec>:
    800006a0:	7111                	addi	sp,sp,-256
    800006a2:	e006                	sd	ra,0(sp)
    800006a4:	e40a                	sd	sp,8(sp)
    800006a6:	e80e                	sd	gp,16(sp)
    800006a8:	ec12                	sd	tp,24(sp)
    800006aa:	f016                	sd	t0,32(sp)
    800006ac:	f41a                	sd	t1,40(sp)
    800006ae:	f81e                	sd	t2,48(sp)
    800006b0:	fc22                	sd	s0,56(sp)
    800006b2:	e0a6                	sd	s1,64(sp)
    800006b4:	e4aa                	sd	a0,72(sp)
    800006b6:	e8ae                	sd	a1,80(sp)
    800006b8:	ecb2                	sd	a2,88(sp)
    800006ba:	f0b6                	sd	a3,96(sp)
    800006bc:	f4ba                	sd	a4,104(sp)
    800006be:	f8be                	sd	a5,112(sp)
    800006c0:	fcc2                	sd	a6,120(sp)
    800006c2:	e146                	sd	a7,128(sp)
    800006c4:	e54a                	sd	s2,136(sp)
    800006c6:	e94e                	sd	s3,144(sp)
    800006c8:	ed52                	sd	s4,152(sp)
    800006ca:	f156                	sd	s5,160(sp)
    800006cc:	f55a                	sd	s6,168(sp)
    800006ce:	f95e                	sd	s7,176(sp)
    800006d0:	fd62                	sd	s8,184(sp)
    800006d2:	e1e6                	sd	s9,192(sp)
    800006d4:	e5ea                	sd	s10,200(sp)
    800006d6:	e9ee                	sd	s11,208(sp)
    800006d8:	edf2                	sd	t3,216(sp)
    800006da:	f1f6                	sd	t4,224(sp)
    800006dc:	f5fa                	sd	t5,232(sp)
    800006de:	f9fe                	sd	t6,240(sp)
    800006e0:	e49ff0ef          	jal	ra,80000528 <kerneltrap>
    800006e4:	6082                	ld	ra,0(sp)
    800006e6:	6122                	ld	sp,8(sp)
    800006e8:	61c2                	ld	gp,16(sp)
    800006ea:	6262                	ld	tp,24(sp)
    800006ec:	7282                	ld	t0,32(sp)
    800006ee:	7322                	ld	t1,40(sp)
    800006f0:	73c2                	ld	t2,48(sp)
    800006f2:	7462                	ld	s0,56(sp)
    800006f4:	6486                	ld	s1,64(sp)
    800006f6:	6526                	ld	a0,72(sp)
    800006f8:	65c6                	ld	a1,80(sp)
    800006fa:	6666                	ld	a2,88(sp)
    800006fc:	7686                	ld	a3,96(sp)
    800006fe:	7726                	ld	a4,104(sp)
    80000700:	77c6                	ld	a5,112(sp)
    80000702:	7866                	ld	a6,120(sp)
    80000704:	688a                	ld	a7,128(sp)
    80000706:	692a                	ld	s2,136(sp)
    80000708:	69ca                	ld	s3,144(sp)
    8000070a:	6a6a                	ld	s4,152(sp)
    8000070c:	7a8a                	ld	s5,160(sp)
    8000070e:	7b2a                	ld	s6,168(sp)
    80000710:	7bca                	ld	s7,176(sp)
    80000712:	7c6a                	ld	s8,184(sp)
    80000714:	6c8e                	ld	s9,192(sp)
    80000716:	6d2e                	ld	s10,200(sp)
    80000718:	6dce                	ld	s11,208(sp)
    8000071a:	6e6e                	ld	t3,216(sp)
    8000071c:	7e8e                	ld	t4,224(sp)
    8000071e:	7f2e                	ld	t5,232(sp)
    80000720:	7fce                	ld	t6,240(sp)
    80000722:	6111                	addi	sp,sp,256
    80000724:	10200073          	sret
    80000728:	00000013          	nop
    8000072c:	00000013          	nop

0000000080000730 <proc_sched>:
    80000730:	7111                	addi	sp,sp,-256
    80000732:	e006                	sd	ra,0(sp)
    80000734:	e40a                	sd	sp,8(sp)
    80000736:	e80e                	sd	gp,16(sp)
    80000738:	ec12                	sd	tp,24(sp)
    8000073a:	f016                	sd	t0,32(sp)
    8000073c:	f41a                	sd	t1,40(sp)
    8000073e:	f81e                	sd	t2,48(sp)
    80000740:	fc22                	sd	s0,56(sp)
    80000742:	e0a6                	sd	s1,64(sp)
    80000744:	e4aa                	sd	a0,72(sp)
    80000746:	e8ae                	sd	a1,80(sp)
    80000748:	ecb2                	sd	a2,88(sp)
    8000074a:	f0b6                	sd	a3,96(sp)
    8000074c:	f4ba                	sd	a4,104(sp)
    8000074e:	f8be                	sd	a5,112(sp)
    80000750:	fcc2                	sd	a6,120(sp)
    80000752:	e146                	sd	a7,128(sp)
    80000754:	e54a                	sd	s2,136(sp)
    80000756:	e94e                	sd	s3,144(sp)
    80000758:	ed52                	sd	s4,152(sp)
    8000075a:	f156                	sd	s5,160(sp)
    8000075c:	f55a                	sd	s6,168(sp)
    8000075e:	f95e                	sd	s7,176(sp)
    80000760:	fd62                	sd	s8,184(sp)
    80000762:	e1e6                	sd	s9,192(sp)
    80000764:	e5ea                	sd	s10,200(sp)
    80000766:	e9ee                	sd	s11,208(sp)
    80000768:	edf2                	sd	t3,216(sp)
    8000076a:	f1f6                	sd	t4,224(sp)
    8000076c:	f5fa                	sd	t5,232(sp)
    8000076e:	f9fe                	sd	t6,240(sp)
    80000770:	2b3000ef          	jal	ra,80001222 <yield>
    80000774:	6082                	ld	ra,0(sp)
    80000776:	6122                	ld	sp,8(sp)
    80000778:	61c2                	ld	gp,16(sp)
    8000077a:	6262                	ld	tp,24(sp)
    8000077c:	7282                	ld	t0,32(sp)
    8000077e:	7322                	ld	t1,40(sp)
    80000780:	73c2                	ld	t2,48(sp)
    80000782:	7462                	ld	s0,56(sp)
    80000784:	6486                	ld	s1,64(sp)
    80000786:	6526                	ld	a0,72(sp)
    80000788:	65c6                	ld	a1,80(sp)
    8000078a:	6666                	ld	a2,88(sp)
    8000078c:	7686                	ld	a3,96(sp)
    8000078e:	7726                	ld	a4,104(sp)
    80000790:	77c6                	ld	a5,112(sp)
    80000792:	7866                	ld	a6,120(sp)
    80000794:	688a                	ld	a7,128(sp)
    80000796:	692a                	ld	s2,136(sp)
    80000798:	69ca                	ld	s3,144(sp)
    8000079a:	6a6a                	ld	s4,152(sp)
    8000079c:	7a8a                	ld	s5,160(sp)
    8000079e:	7b2a                	ld	s6,168(sp)
    800007a0:	7bca                	ld	s7,176(sp)
    800007a2:	7c6a                	ld	s8,184(sp)
    800007a4:	6c8e                	ld	s9,192(sp)
    800007a6:	6d2e                	ld	s10,200(sp)
    800007a8:	6dce                	ld	s11,208(sp)
    800007aa:	6e6e                	ld	t3,216(sp)
    800007ac:	7e8e                	ld	t4,224(sp)
    800007ae:	7f2e                	ld	t5,232(sp)
    800007b0:	7fce                	ld	t6,240(sp)
    800007b2:	6111                	addi	sp,sp,256
    800007b4:	00006297          	auipc	t0,0x6
    800007b8:	8542b283          	ld	t0,-1964(t0) # 80006008 <trap_pc>
    800007bc:	8282                	jr	t0
    800007be:	0001                	nop

00000000800007c0 <timervec>:
    800007c0:	34051573          	csrrw	a0,mscratch,a0
    800007c4:	e10c                	sd	a1,0(a0)
    800007c6:	e510                	sd	a2,8(a0)
    800007c8:	e914                	sd	a3,16(a0)
    800007ca:	710c                	ld	a1,32(a0)
    800007cc:	7510                	ld	a2,40(a0)
    800007ce:	6194                	ld	a3,0(a1)
    800007d0:	96b2                	add	a3,a3,a2
    800007d2:	e194                	sd	a3,0(a1)
    800007d4:	4589                	li	a1,2
    800007d6:	14459073          	csrw	sip,a1
    800007da:	6914                	ld	a3,16(a0)
    800007dc:	6510                	ld	a2,8(a0)
    800007de:	610c                	ld	a1,0(a0)
    800007e0:	34051573          	csrrw	a0,mscratch,a0
    800007e4:	30200073          	mret

00000000800007e8 <init_process_table>:


char stack[PGSIZE * (NPROC + 1)];

// 初始化进程表
void init_process_table() {
    800007e8:	1101                	addi	sp,sp,-32
    800007ea:	ec06                	sd	ra,24(sp)
    800007ec:	e822                	sd	s0,16(sp)
    800007ee:	e426                	sd	s1,8(sp)
    800007f0:	e04a                	sd	s2,0(sp)
    800007f2:	1000                	addi	s0,sp,32
    struct proc *p;
    for (int i = 0; i < NPROC; i++) {
    800007f4:	4901                	li	s2,0
    800007f6:	a83d                	j	80000834 <init_process_table+0x4c>
        p = &proc_table[i];
        spinlock_init(&p->proc_lock, "proc");
    800007f8:	0e800493          	li	s1,232
    800007fc:	029904b3          	mul	s1,s2,s1
    80000800:	00048797          	auipc	a5,0x48
    80000804:	ab078793          	addi	a5,a5,-1360 # 800482b0 <proc_table>
    80000808:	94be                	add	s1,s1,a5
    8000080a:	00005597          	auipc	a1,0x5
    8000080e:	89e58593          	addi	a1,a1,-1890 # 800050a8 <etext+0xa8>
    80000812:	8526                	mv	a0,s1
    80000814:	00003097          	auipc	ra,0x3
    80000818:	f96080e7          	jalr	-106(ra) # 800037aa <spinlock_init>
        p->pid = i;
    8000081c:	0324ac23          	sw	s2,56(s1)
        p->kstack = (uint64) kalloc();
    80000820:	00001097          	auipc	ra,0x1
    80000824:	31c080e7          	jalr	796(ra) # 80001b3c <kalloc>
    80000828:	f0a8                	sd	a0,96(s1)
//        p->kstack = (uint64) stack + PGSIZE * i;
        p->trapframe = 0;
    8000082a:	0404b023          	sd	zero,64(s1)
        p->state = UNUSED;
    8000082e:	0004ac23          	sw	zero,24(s1)
    for (int i = 0; i < NPROC; i++) {
    80000832:	2905                	addiw	s2,s2,1
    80000834:	03f00793          	li	a5,63
    80000838:	fd27d0e3          	bge	a5,s2,800007f8 <init_process_table+0x10>
    }
}
    8000083c:	60e2                	ld	ra,24(sp)
    8000083e:	6442                	ld	s0,16(sp)
    80000840:	64a2                	ld	s1,8(sp)
    80000842:	6902                	ld	s2,0(sp)
    80000844:	6105                	addi	sp,sp,32
    80000846:	8082                	ret

0000000080000848 <alloc_proc>:
void trapret();

void kerneltrap();

// 分配一个进程
struct proc *alloc_proc() {
    80000848:	7179                	addi	sp,sp,-48
    8000084a:	f406                	sd	ra,40(sp)
    8000084c:	f022                	sd	s0,32(sp)
    8000084e:	ec26                	sd	s1,24(sp)
    80000850:	e84a                	sd	s2,16(sp)
    80000852:	e44e                	sd	s3,8(sp)
    80000854:	1800                	addi	s0,sp,48
    struct proc *p;
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80000856:	00048497          	auipc	s1,0x48
    8000085a:	a5a48493          	addi	s1,s1,-1446 # 800482b0 <proc_table>
    8000085e:	0004b797          	auipc	a5,0x4b
    80000862:	45278793          	addi	a5,a5,1106 # 8004bcb0 <h>
    80000866:	06f4f263          	bgeu	s1,a5,800008ca <alloc_proc+0x82>
        spin_lock(&p->proc_lock);
    8000086a:	8526                	mv	a0,s1
    8000086c:	00003097          	auipc	ra,0x3
    80000870:	fd2080e7          	jalr	-46(ra) # 8000383e <spin_lock>
        if (p->state == UNUSED) {
    80000874:	4c9c                	lw	a5,24(s1)
    80000876:	cb89                	beqz	a5,80000888 <alloc_proc+0x40>
            goto found;
        } else {
            spin_unlock(&p->proc_lock);
    80000878:	8526                	mv	a0,s1
    8000087a:	00003097          	auipc	ra,0x3
    8000087e:	096080e7          	jalr	150(ra) # 80003910 <spin_unlock>
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80000882:	0e848493          	addi	s1,s1,232
    80000886:	bfe1                	j	8000085e <alloc_proc+0x16>
        }
    }
    return 0;

    found:
    if ((p->trapframe = (struct trapframe *) kalloc()) == 0) {
    80000888:	00001097          	auipc	ra,0x1
    8000088c:	2b4080e7          	jalr	692(ra) # 80001b3c <kalloc>
    80000890:	89aa                	mv	s3,a0
    80000892:	e0a8                	sd	a0,64(s1)
    80000894:	cd0d                	beqz	a0,800008ce <alloc_proc+0x86>
        spin_unlock(&p->proc_lock);
        return 0;
    }
    memset(&p->context, 0, sizeof(p->context));
    80000896:	07000613          	li	a2,112
    8000089a:	4581                	li	a1,0
    8000089c:	06848513          	addi	a0,s1,104
    800008a0:	00000097          	auipc	ra,0x0
    800008a4:	722080e7          	jalr	1826(ra) # 80000fc2 <memset>
    p->context.sp = p->kstack + PGSIZE;
    800008a8:	70bc                	ld	a5,96(s1)
    800008aa:	6705                	lui	a4,0x1
    800008ac:	97ba                	add	a5,a5,a4
    800008ae:	f8bc                	sd	a5,112(s1)
    spin_unlock(&p->proc_lock);
    800008b0:	8526                	mv	a0,s1
    800008b2:	00003097          	auipc	ra,0x3
    800008b6:	05e080e7          	jalr	94(ra) # 80003910 <spin_unlock>
    return p;
}
    800008ba:	8526                	mv	a0,s1
    800008bc:	70a2                	ld	ra,40(sp)
    800008be:	7402                	ld	s0,32(sp)
    800008c0:	64e2                	ld	s1,24(sp)
    800008c2:	6942                	ld	s2,16(sp)
    800008c4:	69a2                	ld	s3,8(sp)
    800008c6:	6145                	addi	sp,sp,48
    800008c8:	8082                	ret
    return 0;
    800008ca:	4481                	li	s1,0
    800008cc:	b7fd                	j	800008ba <alloc_proc+0x72>
        spin_unlock(&p->proc_lock);
    800008ce:	8526                	mv	a0,s1
    800008d0:	00003097          	auipc	ra,0x3
    800008d4:	040080e7          	jalr	64(ra) # 80003910 <spin_unlock>
        return 0;
    800008d8:	84ce                	mv	s1,s3
    800008da:	b7c5                	j	800008ba <alloc_proc+0x72>

00000000800008dc <init_first_process>:
void init_first_process() {
    800008dc:	1101                	addi	sp,sp,-32
    800008de:	ec06                	sd	ra,24(sp)
    800008e0:	e822                	sd	s0,16(sp)
    800008e2:	e426                	sd	s1,8(sp)
    800008e4:	1000                	addi	s0,sp,32
    struct proc *p = alloc_proc();
    800008e6:	00000097          	auipc	ra,0x0
    800008ea:	f62080e7          	jalr	-158(ra) # 80000848 <alloc_proc>
    800008ee:	84aa                	mv	s1,a0
    p->context.ra = (uint64) init;
    800008f0:	00000797          	auipc	a5,0x0
    800008f4:	5a278793          	addi	a5,a5,1442 # 80000e92 <init>
    800008f8:	f53c                	sd	a5,104(a0)
    p->current_dir = namei("/");
    800008fa:	00004517          	auipc	a0,0x4
    800008fe:	7b650513          	addi	a0,a0,1974 # 800050b0 <etext+0xb0>
    80000902:	00003097          	auipc	ra,0x3
    80000906:	c94080e7          	jalr	-876(ra) # 80003596 <namei>
    8000090a:	e8a8                	sd	a0,80(s1)
    p->state = RUNNABLE;
    8000090c:	4789                	li	a5,2
    8000090e:	cc9c                	sw	a5,24(s1)
    initproc = p;
    80000910:	00005797          	auipc	a5,0x5
    80000914:	7097b423          	sd	s1,1800(a5) # 80006018 <initproc>
}
    80000918:	60e2                	ld	ra,24(sp)
    8000091a:	6442                	ld	s0,16(sp)
    8000091c:	64a2                	ld	s1,8(sp)
    8000091e:	6105                	addi	sp,sp,32
    80000920:	8082                	ret

0000000080000922 <proc_pagetable>:
 * 创建一个进程可以使用的pagetable, 只映射了trampoline页,
 * 用于进入和离开内核空间
 *
 * @return
 */
pagetable_t proc_pagetable(struct proc *p) {
    80000922:	1101                	addi	sp,sp,-32
    80000924:	ec06                	sd	ra,24(sp)
    80000926:	e822                	sd	s0,16(sp)
    80000928:	e426                	sd	s1,8(sp)
    8000092a:	e04a                	sd	s2,0(sp)
    8000092c:	1000                	addi	s0,sp,32
    8000092e:	892a                	mv	s2,a0
    pagetable_t pagetable;

    // 创建一个空的页表
    pagetable = user_vm_create();
    80000930:	00001097          	auipc	ra,0x1
    80000934:	586080e7          	jalr	1414(ra) # 80001eb6 <user_vm_create>
    80000938:	84aa                	mv	s1,a0
    if (pagetable == 0)
    8000093a:	c121                	beqz	a0,8000097a <proc_pagetable+0x58>
        return 0;

    // 映射trampoline代码(用于系统调用)到虚拟地址的顶端
    // TODO PTE权限应该添加PTE_U
    if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000093c:	4729                	li	a4,10
    8000093e:	00003697          	auipc	a3,0x3
    80000942:	6c268693          	addi	a3,a3,1730 # 80004000 <_trampoline>
    80000946:	6605                	lui	a2,0x1
    80000948:	040005b7          	lui	a1,0x4000
    8000094c:	15fd                	addi	a1,a1,-1
    8000094e:	05b2                	slli	a1,a1,0xc
    80000950:	00001097          	auipc	ra,0x1
    80000954:	314080e7          	jalr	788(ra) # 80001c64 <mappages>
    80000958:	02054863          	bltz	a0,80000988 <proc_pagetable+0x66>
        // TODO 失败释放内存
        return 0;
    }

    // 将进程的trapframe映射到TRAPFRAME, TRAMPOLINE的低位一页
    if (mappages(pagetable, TRAPFRAME, PGSIZE,
    8000095c:	4719                	li	a4,6
    8000095e:	04093683          	ld	a3,64(s2)
    80000962:	6605                	lui	a2,0x1
    80000964:	020005b7          	lui	a1,0x2000
    80000968:	15fd                	addi	a1,a1,-1
    8000096a:	05b6                	slli	a1,a1,0xd
    8000096c:	8526                	mv	a0,s1
    8000096e:	00001097          	auipc	ra,0x1
    80000972:	2f6080e7          	jalr	758(ra) # 80001c64 <mappages>
    80000976:	00054b63          	bltz	a0,8000098c <proc_pagetable+0x6a>
//        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
//        uvmfree(pagetable, 0);
        return 0;
    }
    return pagetable;
}
    8000097a:	8526                	mv	a0,s1
    8000097c:	60e2                	ld	ra,24(sp)
    8000097e:	6442                	ld	s0,16(sp)
    80000980:	64a2                	ld	s1,8(sp)
    80000982:	6902                	ld	s2,0(sp)
    80000984:	6105                	addi	sp,sp,32
    80000986:	8082                	ret
        return 0;
    80000988:	4481                	li	s1,0
    8000098a:	bfc5                	j	8000097a <proc_pagetable+0x58>
        return 0;
    8000098c:	4481                	li	s1,0
    8000098e:	b7f5                	j	8000097a <proc_pagetable+0x58>

0000000080000990 <cpuid>:
        }
    }
}

// 获取当前cpu的id
int cpuid() {
    80000990:	1141                	addi	sp,sp,-16
    80000992:	e422                	sd	s0,8(sp)
    80000994:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000996:	8512                	mv	a0,tp
    int id = r_tp();
    return id;
}
    80000998:	2501                	sext.w	a0,a0
    8000099a:	6422                	ld	s0,8(sp)
    8000099c:	0141                	addi	sp,sp,16
    8000099e:	8082                	ret

00000000800009a0 <mycpu>:

// 获取当前cpu
struct cpu *mycpu(void) {
    800009a0:	1141                	addi	sp,sp,-16
    800009a2:	e406                	sd	ra,8(sp)
    800009a4:	e022                	sd	s0,0(sp)
    800009a6:	0800                	addi	s0,sp,16
    int id = cpuid();
    800009a8:	00000097          	auipc	ra,0x0
    800009ac:	fe8080e7          	jalr	-24(ra) # 80000990 <cpuid>
    struct cpu *c = &cpus[id];
    800009b0:	051e                	slli	a0,a0,0x7
    return c;
}
    800009b2:	00007797          	auipc	a5,0x7
    800009b6:	87e78793          	addi	a5,a5,-1922 # 80007230 <cpus>
    800009ba:	953e                	add	a0,a0,a5
    800009bc:	60a2                	ld	ra,8(sp)
    800009be:	6402                	ld	s0,0(sp)
    800009c0:	0141                	addi	sp,sp,16
    800009c2:	8082                	ret

00000000800009c4 <myproc>:

// 获取当前进程
struct proc *myproc() {
    800009c4:	1141                	addi	sp,sp,-16
    800009c6:	e406                	sd	ra,8(sp)
    800009c8:	e022                	sd	s0,0(sp)
    800009ca:	0800                	addi	s0,sp,16
    return mycpu()->proc;
    800009cc:	00000097          	auipc	ra,0x0
    800009d0:	fd4080e7          	jalr	-44(ra) # 800009a0 <mycpu>
}
    800009d4:	6108                	ld	a0,0(a0)
    800009d6:	60a2                	ld	ra,8(sp)
    800009d8:	6402                	ld	s0,0(sp)
    800009da:	0141                	addi	sp,sp,16
    800009dc:	8082                	ret

00000000800009de <execret>:
void execra(struct context *, struct context *, uint64);

extern void userret(uint64 fn, uint64 sp);

// exec返回函数, 该函数释放进程锁，并返回到需要执行的代码
void execret() {
    800009de:	1101                	addi	sp,sp,-32
    800009e0:	ec06                	sd	ra,24(sp)
    800009e2:	e822                	sd	s0,16(sp)
    800009e4:	e426                	sd	s1,8(sp)
    800009e6:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    800009e8:	00000097          	auipc	ra,0x0
    800009ec:	fdc080e7          	jalr	-36(ra) # 800009c4 <myproc>
    800009f0:	84aa                	mv	s1,a0
    spin_unlock(&p->proc_lock);
    800009f2:	00003097          	auipc	ra,0x3
    800009f6:	f1e080e7          	jalr	-226(ra) # 80003910 <spin_unlock>
    userret(p->trapframe->a0, p->context.sp);
    800009fa:	60bc                	ld	a5,64(s1)
    800009fc:	78ac                	ld	a1,112(s1)
    800009fe:	7ba8                	ld	a0,112(a5)
    80000a00:	00001097          	auipc	ra,0x1
    80000a04:	610080e7          	jalr	1552(ra) # 80002010 <userret>
}
    80000a08:	60e2                	ld	ra,24(sp)
    80000a0a:	6442                	ld	s0,16(sp)
    80000a0c:	64a2                	ld	s1,8(sp)
    80000a0e:	6105                	addi	sp,sp,32
    80000a10:	8082                	ret

0000000080000a12 <before_sched>:
void before_sched() {
    80000a12:	1101                	addi	sp,sp,-32
    80000a14:	ec06                	sd	ra,24(sp)
    80000a16:	e822                	sd	s0,16(sp)
    80000a18:	e426                	sd	s1,8(sp)
    80000a1a:	e04a                	sd	s2,0(sp)
    80000a1c:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    80000a1e:	00000097          	auipc	ra,0x0
    80000a22:	fa6080e7          	jalr	-90(ra) # 800009c4 <myproc>
    80000a26:	84aa                	mv	s1,a0
    if (!spin_holding(&p->proc_lock))
    80000a28:	00003097          	auipc	ra,0x3
    80000a2c:	d98080e7          	jalr	-616(ra) # 800037c0 <spin_holding>
    80000a30:	cd39                	beqz	a0,80000a8e <before_sched+0x7c>
    if (mycpu()->noff != 1)
    80000a32:	00000097          	auipc	ra,0x0
    80000a36:	f6e080e7          	jalr	-146(ra) # 800009a0 <mycpu>
    80000a3a:	5d38                	lw	a4,120(a0)
    80000a3c:	4785                	li	a5,1
    80000a3e:	06f71163          	bne	a4,a5,80000aa0 <before_sched+0x8e>
    if (p->state == RUNNING)
    80000a42:	4c98                	lw	a4,24(s1)
    80000a44:	478d                	li	a5,3
    80000a46:	06f70663          	beq	a4,a5,80000ab2 <before_sched+0xa0>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000a4a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000a4e:	8b89                	andi	a5,a5,2
    if (intr_get())
    80000a50:	ebb5                	bnez	a5,80000ac4 <before_sched+0xb2>
    intr_enable = mycpu()->intr_enable;
    80000a52:	00000097          	auipc	ra,0x0
    80000a56:	f4e080e7          	jalr	-178(ra) # 800009a0 <mycpu>
    80000a5a:	07c52903          	lw	s2,124(a0)
    pswitch(&p->context, &mycpu()->context);
    80000a5e:	00000097          	auipc	ra,0x0
    80000a62:	f42080e7          	jalr	-190(ra) # 800009a0 <mycpu>
    80000a66:	00850593          	addi	a1,a0,8
    80000a6a:	06848513          	addi	a0,s1,104
    80000a6e:	00000097          	auipc	ra,0x0
    80000a72:	696080e7          	jalr	1686(ra) # 80001104 <pswitch>
    mycpu()->intr_enable = intr_enable;
    80000a76:	00000097          	auipc	ra,0x0
    80000a7a:	f2a080e7          	jalr	-214(ra) # 800009a0 <mycpu>
    80000a7e:	07252e23          	sw	s2,124(a0)
}
    80000a82:	60e2                	ld	ra,24(sp)
    80000a84:	6442                	ld	s0,16(sp)
    80000a86:	64a2                	ld	s1,8(sp)
    80000a88:	6902                	ld	s2,0(sp)
    80000a8a:	6105                	addi	sp,sp,32
    80000a8c:	8082                	ret
        panic("sched p->lock");
    80000a8e:	00004517          	auipc	a0,0x4
    80000a92:	62a50513          	addi	a0,a0,1578 # 800050b8 <etext+0xb8>
    80000a96:	00001097          	auipc	ra,0x1
    80000a9a:	b46080e7          	jalr	-1210(ra) # 800015dc <panic>
    80000a9e:	bf51                	j	80000a32 <before_sched+0x20>
        panic("sched locks");
    80000aa0:	00004517          	auipc	a0,0x4
    80000aa4:	62850513          	addi	a0,a0,1576 # 800050c8 <etext+0xc8>
    80000aa8:	00001097          	auipc	ra,0x1
    80000aac:	b34080e7          	jalr	-1228(ra) # 800015dc <panic>
    80000ab0:	bf49                	j	80000a42 <before_sched+0x30>
        panic("sched running");
    80000ab2:	00004517          	auipc	a0,0x4
    80000ab6:	62650513          	addi	a0,a0,1574 # 800050d8 <etext+0xd8>
    80000aba:	00001097          	auipc	ra,0x1
    80000abe:	b22080e7          	jalr	-1246(ra) # 800015dc <panic>
    80000ac2:	b761                	j	80000a4a <before_sched+0x38>
        panic("sched interruptible");
    80000ac4:	00004517          	auipc	a0,0x4
    80000ac8:	62450513          	addi	a0,a0,1572 # 800050e8 <etext+0xe8>
    80000acc:	00001097          	auipc	ra,0x1
    80000ad0:	b10080e7          	jalr	-1264(ra) # 800015dc <panic>
    80000ad4:	bfbd                	j	80000a52 <before_sched+0x40>

0000000080000ad6 <sleep>:
void sleep(void *chan, struct spinlock *lock) {
    80000ad6:	7179                	addi	sp,sp,-48
    80000ad8:	f406                	sd	ra,40(sp)
    80000ada:	f022                	sd	s0,32(sp)
    80000adc:	ec26                	sd	s1,24(sp)
    80000ade:	e84a                	sd	s2,16(sp)
    80000ae0:	e44e                	sd	s3,8(sp)
    80000ae2:	e052                	sd	s4,0(sp)
    80000ae4:	1800                	addi	s0,sp,48
    80000ae6:	89aa                	mv	s3,a0
    80000ae8:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80000aea:	00000097          	auipc	ra,0x0
    80000aee:	eda080e7          	jalr	-294(ra) # 800009c4 <myproc>
    80000af2:	84aa                	mv	s1,a0
    if (lock != &p->proc_lock) {  //DOC: sleeplock0
    80000af4:	8a2a                	mv	s4,a0
    80000af6:	01250b63          	beq	a0,s2,80000b0c <sleep+0x36>
        spin_lock(&p->proc_lock);  //DOC: sleeplock1
    80000afa:	00003097          	auipc	ra,0x3
    80000afe:	d44080e7          	jalr	-700(ra) # 8000383e <spin_lock>
        spin_unlock(lock);
    80000b02:	854a                	mv	a0,s2
    80000b04:	00003097          	auipc	ra,0x3
    80000b08:	e0c080e7          	jalr	-500(ra) # 80003910 <spin_unlock>
    p->chan = chan;
    80000b0c:	0334b423          	sd	s3,40(s1)
    p->state = SLEEPING;
    80000b10:	4785                	li	a5,1
    80000b12:	cc9c                	sw	a5,24(s1)
    before_sched();
    80000b14:	00000097          	auipc	ra,0x0
    80000b18:	efe080e7          	jalr	-258(ra) # 80000a12 <before_sched>
    p->chan = 0;
    80000b1c:	0204b423          	sd	zero,40(s1)
    if (lock != &p->proc_lock) {
    80000b20:	012a0c63          	beq	s4,s2,80000b38 <sleep+0x62>
        spin_unlock(&p->proc_lock);
    80000b24:	8526                	mv	a0,s1
    80000b26:	00003097          	auipc	ra,0x3
    80000b2a:	dea080e7          	jalr	-534(ra) # 80003910 <spin_unlock>
        spin_lock(lock);
    80000b2e:	854a                	mv	a0,s2
    80000b30:	00003097          	auipc	ra,0x3
    80000b34:	d0e080e7          	jalr	-754(ra) # 8000383e <spin_lock>
}
    80000b38:	70a2                	ld	ra,40(sp)
    80000b3a:	7402                	ld	s0,32(sp)
    80000b3c:	64e2                	ld	s1,24(sp)
    80000b3e:	6942                	ld	s2,16(sp)
    80000b40:	69a2                	ld	s3,8(sp)
    80000b42:	6a02                	ld	s4,0(sp)
    80000b44:	6145                	addi	sp,sp,48
    80000b46:	8082                	ret

0000000080000b48 <sleep_time>:
void sleep_time(uint64 sleep_ticks) {
    80000b48:	1101                	addi	sp,sp,-32
    80000b4a:	ec06                	sd	ra,24(sp)
    80000b4c:	e822                	sd	s0,16(sp)
    80000b4e:	e426                	sd	s1,8(sp)
    80000b50:	e04a                	sd	s2,0(sp)
    80000b52:	1000                	addi	s0,sp,32
    80000b54:	84aa                	mv	s1,a0
    uint64 now = ticks;
    80000b56:	00005917          	auipc	s2,0x5
    80000b5a:	4ba93903          	ld	s2,1210(s2) # 80006010 <ticks>
    spin_lock(&ticks_lock);
    80000b5e:	00006517          	auipc	a0,0x6
    80000b62:	6ba50513          	addi	a0,a0,1722 # 80007218 <ticks_lock>
    80000b66:	00003097          	auipc	ra,0x3
    80000b6a:	cd8080e7          	jalr	-808(ra) # 8000383e <spin_lock>
    for (; ticks - now < sleep_ticks;) {
    80000b6e:	00005797          	auipc	a5,0x5
    80000b72:	4a27b783          	ld	a5,1186(a5) # 80006010 <ticks>
    80000b76:	412787b3          	sub	a5,a5,s2
    80000b7a:	0097ff63          	bgeu	a5,s1,80000b98 <sleep_time+0x50>
        sleep(&ticks, &ticks_lock);
    80000b7e:	00006597          	auipc	a1,0x6
    80000b82:	69a58593          	addi	a1,a1,1690 # 80007218 <ticks_lock>
    80000b86:	00005517          	auipc	a0,0x5
    80000b8a:	48a50513          	addi	a0,a0,1162 # 80006010 <ticks>
    80000b8e:	00000097          	auipc	ra,0x0
    80000b92:	f48080e7          	jalr	-184(ra) # 80000ad6 <sleep>
    80000b96:	bfe1                	j	80000b6e <sleep_time+0x26>
    spin_unlock(&ticks_lock);
    80000b98:	00006517          	auipc	a0,0x6
    80000b9c:	68050513          	addi	a0,a0,1664 # 80007218 <ticks_lock>
    80000ba0:	00003097          	auipc	ra,0x3
    80000ba4:	d70080e7          	jalr	-656(ra) # 80003910 <spin_unlock>
}
    80000ba8:	60e2                	ld	ra,24(sp)
    80000baa:	6442                	ld	s0,16(sp)
    80000bac:	64a2                	ld	s1,8(sp)
    80000bae:	6902                	ld	s2,0(sp)
    80000bb0:	6105                	addi	sp,sp,32
    80000bb2:	8082                	ret

0000000080000bb4 <wakeup>:
void wakeup(void *chan) {
    80000bb4:	1141                	addi	sp,sp,-16
    80000bb6:	e422                	sd	s0,8(sp)
    80000bb8:	0800                	addi	s0,sp,16
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80000bba:	00047797          	auipc	a5,0x47
    80000bbe:	6f678793          	addi	a5,a5,1782 # 800482b0 <proc_table>
    80000bc2:	a029                	j	80000bcc <wakeup+0x18>
            p->state = RUNNABLE;
    80000bc4:	4709                	li	a4,2
    80000bc6:	cf98                	sw	a4,24(a5)
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80000bc8:	0e878793          	addi	a5,a5,232
    80000bcc:	0004b717          	auipc	a4,0x4b
    80000bd0:	0e470713          	addi	a4,a4,228 # 8004bcb0 <h>
    80000bd4:	00e7fa63          	bgeu	a5,a4,80000be8 <wakeup+0x34>
        if (p->state == SLEEPING && p->chan == chan) {
    80000bd8:	4f94                	lw	a3,24(a5)
    80000bda:	4705                	li	a4,1
    80000bdc:	fee696e3          	bne	a3,a4,80000bc8 <wakeup+0x14>
    80000be0:	7798                	ld	a4,40(a5)
    80000be2:	fea713e3          	bne	a4,a0,80000bc8 <wakeup+0x14>
    80000be6:	bff9                	j	80000bc4 <wakeup+0x10>
}
    80000be8:	6422                	ld	s0,8(sp)
    80000bea:	0141                	addi	sp,sp,16
    80000bec:	8082                	ret

0000000080000bee <scheduler>:
void scheduler() {
    80000bee:	7179                	addi	sp,sp,-48
    80000bf0:	f406                	sd	ra,40(sp)
    80000bf2:	f022                	sd	s0,32(sp)
    80000bf4:	ec26                	sd	s1,24(sp)
    80000bf6:	e84a                	sd	s2,16(sp)
    80000bf8:	e44e                	sd	s3,8(sp)
    80000bfa:	e052                	sd	s4,0(sp)
    80000bfc:	1800                	addi	s0,sp,48
    struct cpu *c = mycpu();
    80000bfe:	00000097          	auipc	ra,0x0
    80000c02:	da2080e7          	jalr	-606(ra) # 800009a0 <mycpu>
    80000c06:	8a2a                	mv	s4,a0
    int alive_p = 0;
    80000c08:	a87d                	j	80000cc6 <scheduler+0xd8>
                alive_p++;
    80000c0a:	2985                	addiw	s3,s3,1
            if (p->state == ZOMBIE) {
    80000c0c:	4711                	li	a4,4
    80000c0e:	04e78d63          	beq	a5,a4,80000c68 <scheduler+0x7a>
            if (p->state == RUNNABLE) {
    80000c12:	0e800793          	li	a5,232
    80000c16:	02f90733          	mul	a4,s2,a5
    80000c1a:	00047797          	auipc	a5,0x47
    80000c1e:	69678793          	addi	a5,a5,1686 # 800482b0 <proc_table>
    80000c22:	97ba                	add	a5,a5,a4
    80000c24:	4f98                	lw	a4,24(a5)
    80000c26:	4789                	li	a5,2
    80000c28:	04f70963          	beq	a4,a5,80000c7a <scheduler+0x8c>
            spin_unlock(&p->proc_lock);
    80000c2c:	8526                	mv	a0,s1
    80000c2e:	00003097          	auipc	ra,0x3
    80000c32:	ce2080e7          	jalr	-798(ra) # 80003910 <spin_unlock>
        for (int i = 0; i < NPROC; i++) {
    80000c36:	2905                	addiw	s2,s2,1
    80000c38:	03f00793          	li	a5,63
    80000c3c:	0727ca63          	blt	a5,s2,80000cb0 <scheduler+0xc2>
            p = &proc_table[i];
    80000c40:	0e800493          	li	s1,232
    80000c44:	029904b3          	mul	s1,s2,s1
    80000c48:	00047797          	auipc	a5,0x47
    80000c4c:	66878793          	addi	a5,a5,1640 # 800482b0 <proc_table>
    80000c50:	94be                	add	s1,s1,a5
            spin_lock(&p->proc_lock);
    80000c52:	8526                	mv	a0,s1
    80000c54:	00003097          	auipc	ra,0x3
    80000c58:	bea080e7          	jalr	-1046(ra) # 8000383e <spin_lock>
            if (p->state != UNUSED && p->state != ZOMBIE) {
    80000c5c:	4c9c                	lw	a5,24(s1)
    80000c5e:	d7dd                	beqz	a5,80000c0c <scheduler+0x1e>
    80000c60:	4711                	li	a4,4
    80000c62:	fae794e3          	bne	a5,a4,80000c0a <scheduler+0x1c>
    80000c66:	b75d                	j	80000c0c <scheduler+0x1e>
                wakeup(initproc);
    80000c68:	00005517          	auipc	a0,0x5
    80000c6c:	3b053503          	ld	a0,944(a0) # 80006018 <initproc>
    80000c70:	00000097          	auipc	ra,0x0
    80000c74:	f44080e7          	jalr	-188(ra) # 80000bb4 <wakeup>
    80000c78:	bf69                	j	80000c12 <scheduler+0x24>
                p->state = RUNNING;
    80000c7a:	00047597          	auipc	a1,0x47
    80000c7e:	63658593          	addi	a1,a1,1590 # 800482b0 <proc_table>
    80000c82:	0e800793          	li	a5,232
    80000c86:	02f907b3          	mul	a5,s2,a5
    80000c8a:	00f58733          	add	a4,a1,a5
    80000c8e:	468d                	li	a3,3
    80000c90:	cf14                	sw	a3,24(a4)
                c->proc = p;
    80000c92:	009a3023          	sd	s1,0(s4)
                pswitch(&c->context, &p->context);
    80000c96:	06078793          	addi	a5,a5,96
    80000c9a:	95be                	add	a1,a1,a5
    80000c9c:	05a1                	addi	a1,a1,8
    80000c9e:	008a0513          	addi	a0,s4,8
    80000ca2:	00000097          	auipc	ra,0x0
    80000ca6:	462080e7          	jalr	1122(ra) # 80001104 <pswitch>
                c->proc = 0;
    80000caa:	000a3023          	sd	zero,0(s4)
    80000cae:	bfbd                	j	80000c2c <scheduler+0x3e>
        if (alive_p <= 2) {
    80000cb0:	4789                	li	a5,2
    80000cb2:	0137ca63          	blt	a5,s3,80000cc6 <scheduler+0xd8>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000cb6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000cba:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000cbe:	10079073          	csrw	sstatus,a5
            asm volatile("wfi");
    80000cc2:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000cc6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000cca:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000cce:	10079073          	csrw	sstatus,a5
        for (int i = 0; i < NPROC; i++) {
    80000cd2:	4901                	li	s2,0
        alive_p = 0;
    80000cd4:	4981                	li	s3,0
        for (int i = 0; i < NPROC; i++) {
    80000cd6:	b78d                	j	80000c38 <scheduler+0x4a>

0000000080000cd8 <wait>:
int wait(int *status) {
    80000cd8:	7139                	addi	sp,sp,-64
    80000cda:	fc06                	sd	ra,56(sp)
    80000cdc:	f822                	sd	s0,48(sp)
    80000cde:	f426                	sd	s1,40(sp)
    80000ce0:	f04a                	sd	s2,32(sp)
    80000ce2:	ec4e                	sd	s3,24(sp)
    80000ce4:	e852                	sd	s4,16(sp)
    80000ce6:	e456                	sd	s5,8(sp)
    80000ce8:	0080                	addi	s0,sp,64
    80000cea:	8aaa                	mv	s5,a0
    p = myproc();
    80000cec:	00000097          	auipc	ra,0x0
    80000cf0:	cd8080e7          	jalr	-808(ra) # 800009c4 <myproc>
    80000cf4:	892a                	mv	s2,a0
    spin_lock(&p->proc_lock);
    80000cf6:	00003097          	auipc	ra,0x3
    80000cfa:	b48080e7          	jalr	-1208(ra) # 8000383e <spin_lock>
        havechild = 0;
    80000cfe:	4701                	li	a4,0
        for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    80000d00:	00047497          	auipc	s1,0x47
    80000d04:	5b048493          	addi	s1,s1,1456 # 800482b0 <proc_table>
    80000d08:	a03d                	j	80000d36 <wait+0x5e>
                    pid = cp->pid;
    80000d0a:	0384aa03          	lw	s4,56(s1)
                    if (status) {
    80000d0e:	000a8563          	beqz	s5,80000d18 <wait+0x40>
                        *status = cp->xstate;
    80000d12:	58dc                	lw	a5,52(s1)
    80000d14:	00faa023          	sw	a5,0(s5)
                    cp->state = UNUSED;
    80000d18:	0004ac23          	sw	zero,24(s1)
                    spin_unlock(&cp->proc_lock);
    80000d1c:	854e                	mv	a0,s3
    80000d1e:	00003097          	auipc	ra,0x3
    80000d22:	bf2080e7          	jalr	-1038(ra) # 80003910 <spin_unlock>
                    spin_unlock(&p->proc_lock);
    80000d26:	854a                	mv	a0,s2
    80000d28:	00003097          	auipc	ra,0x3
    80000d2c:	be8080e7          	jalr	-1048(ra) # 80003910 <spin_unlock>
                    return pid;
    80000d30:	a83d                	j	80000d6e <wait+0x96>
        for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    80000d32:	0e848493          	addi	s1,s1,232
    80000d36:	0004b797          	auipc	a5,0x4b
    80000d3a:	f7a78793          	addi	a5,a5,-134 # 8004bcb0 <h>
    80000d3e:	02f4f663          	bgeu	s1,a5,80000d6a <wait+0x92>
            if (cp->parent == p) {
    80000d42:	709c                	ld	a5,32(s1)
    80000d44:	ff2797e3          	bne	a5,s2,80000d32 <wait+0x5a>
                spin_lock(&cp->proc_lock);
    80000d48:	89a6                	mv	s3,s1
    80000d4a:	8526                	mv	a0,s1
    80000d4c:	00003097          	auipc	ra,0x3
    80000d50:	af2080e7          	jalr	-1294(ra) # 8000383e <spin_lock>
                if (cp->state == ZOMBIE) {
    80000d54:	4c98                	lw	a4,24(s1)
    80000d56:	4791                	li	a5,4
    80000d58:	faf709e3          	beq	a4,a5,80000d0a <wait+0x32>
                spin_unlock(&cp->proc_lock);
    80000d5c:	8526                	mv	a0,s1
    80000d5e:	00003097          	auipc	ra,0x3
    80000d62:	bb2080e7          	jalr	-1102(ra) # 80003910 <spin_unlock>
                havechild = 1;
    80000d66:	4705                	li	a4,1
    80000d68:	b7e9                	j	80000d32 <wait+0x5a>
        if (!havechild) {
    80000d6a:	ef01                	bnez	a4,80000d82 <wait+0xaa>
            return -1;
    80000d6c:	5a7d                	li	s4,-1
}
    80000d6e:	8552                	mv	a0,s4
    80000d70:	70e2                	ld	ra,56(sp)
    80000d72:	7442                	ld	s0,48(sp)
    80000d74:	74a2                	ld	s1,40(sp)
    80000d76:	7902                	ld	s2,32(sp)
    80000d78:	69e2                	ld	s3,24(sp)
    80000d7a:	6a42                	ld	s4,16(sp)
    80000d7c:	6aa2                	ld	s5,8(sp)
    80000d7e:	6121                	addi	sp,sp,64
    80000d80:	8082                	ret
        sleep(p, &myproc()->proc_lock); // 等待子进程唤醒
    80000d82:	00000097          	auipc	ra,0x0
    80000d86:	c42080e7          	jalr	-958(ra) # 800009c4 <myproc>
    80000d8a:	85aa                	mv	a1,a0
    80000d8c:	854a                	mv	a0,s2
    80000d8e:	00000097          	auipc	ra,0x0
    80000d92:	d48080e7          	jalr	-696(ra) # 80000ad6 <sleep>
        havechild = 0;
    80000d96:	b7a5                	j	80000cfe <wait+0x26>

0000000080000d98 <exit>:
void exit(int status) {
    80000d98:	1101                	addi	sp,sp,-32
    80000d9a:	ec06                	sd	ra,24(sp)
    80000d9c:	e822                	sd	s0,16(sp)
    80000d9e:	e426                	sd	s1,8(sp)
    80000da0:	e04a                	sd	s2,0(sp)
    80000da2:	1000                	addi	s0,sp,32
    80000da4:	892a                	mv	s2,a0
    p = myproc();
    80000da6:	00000097          	auipc	ra,0x0
    80000daa:	c1e080e7          	jalr	-994(ra) # 800009c4 <myproc>
    80000dae:	84aa                	mv	s1,a0
    p->state = ZOMBIE;
    80000db0:	4791                	li	a5,4
    80000db2:	cd1c                	sw	a5,24(a0)
    p->xstate = status;
    80000db4:	03252a23          	sw	s2,52(a0)
    for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    80000db8:	00047797          	auipc	a5,0x47
    80000dbc:	4f878793          	addi	a5,a5,1272 # 800482b0 <proc_table>
    80000dc0:	a801                	j	80000dd0 <exit+0x38>
            cp->parent = initproc;
    80000dc2:	00005717          	auipc	a4,0x5
    80000dc6:	25673703          	ld	a4,598(a4) # 80006018 <initproc>
    80000dca:	f398                	sd	a4,32(a5)
    for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    80000dcc:	0e878793          	addi	a5,a5,232
    80000dd0:	0004b717          	auipc	a4,0x4b
    80000dd4:	ee070713          	addi	a4,a4,-288 # 8004bcb0 <h>
    80000dd8:	00e7f663          	bgeu	a5,a4,80000de4 <exit+0x4c>
        if (cp->parent == p) {
    80000ddc:	7398                	ld	a4,32(a5)
    80000dde:	fe9717e3          	bne	a4,s1,80000dcc <exit+0x34>
    80000de2:	b7c5                	j	80000dc2 <exit+0x2a>
    wakeup(p->parent);
    80000de4:	7088                	ld	a0,32(s1)
    80000de6:	00000097          	auipc	ra,0x0
    80000dea:	dce080e7          	jalr	-562(ra) # 80000bb4 <wakeup>
    spin_lock(&p->proc_lock);
    80000dee:	8526                	mv	a0,s1
    80000df0:	00003097          	auipc	ra,0x3
    80000df4:	a4e080e7          	jalr	-1458(ra) # 8000383e <spin_lock>
    before_sched();
    80000df8:	00000097          	auipc	ra,0x0
    80000dfc:	c1a080e7          	jalr	-998(ra) # 80000a12 <before_sched>
}
    80000e00:	60e2                	ld	ra,24(sp)
    80000e02:	6442                	ld	s0,16(sp)
    80000e04:	64a2                	ld	s1,8(sp)
    80000e06:	6902                	ld	s2,0(sp)
    80000e08:	6105                	addi	sp,sp,32
    80000e0a:	8082                	ret

0000000080000e0c <exec>:

// 使进程执行其他函数
void exec(uint64 fn) {
    80000e0c:	7179                	addi	sp,sp,-48
    80000e0e:	f406                	sd	ra,40(sp)
    80000e10:	f022                	sd	s0,32(sp)
    80000e12:	ec26                	sd	s1,24(sp)
    80000e14:	e84a                	sd	s2,16(sp)
    80000e16:	e44e                	sd	s3,8(sp)
    80000e18:	1800                	addi	s0,sp,48
    80000e1a:	892a                	mv	s2,a0
    struct proc *p = myproc();
    80000e1c:	00000097          	auipc	ra,0x0
    80000e20:	ba8080e7          	jalr	-1112(ra) # 800009c4 <myproc>
    80000e24:	84aa                	mv	s1,a0
    memset(&p->context, 0, sizeof(struct context));
    80000e26:	06850993          	addi	s3,a0,104
    80000e2a:	07000613          	li	a2,112
    80000e2e:	4581                	li	a1,0
    80000e30:	854e                	mv	a0,s3
    80000e32:	00000097          	auipc	ra,0x0
    80000e36:	190080e7          	jalr	400(ra) # 80000fc2 <memset>
    p->state = RUNNABLE;
    80000e3a:	4789                	li	a5,2
    80000e3c:	cc9c                	sw	a5,24(s1)
    p->context.sp = p->kstack + PGSIZE;
    80000e3e:	70bc                	ld	a5,96(s1)
    80000e40:	6705                	lui	a4,0x1
    80000e42:	97ba                	add	a5,a5,a4
    80000e44:	f8bc                	sd	a5,112(s1)
    spin_lock(&p->proc_lock);
    80000e46:	8526                	mv	a0,s1
    80000e48:	00003097          	auipc	ra,0x3
    80000e4c:	9f6080e7          	jalr	-1546(ra) # 8000383e <spin_lock>
    p->trapframe->a0 = fn;
    80000e50:	60bc                	ld	a5,64(s1)
    80000e52:	0727b823          	sd	s2,112(a5)
    execra(&p->context, &mycpu()->context, (uint64) execret);
    80000e56:	00000097          	auipc	ra,0x0
    80000e5a:	b4a080e7          	jalr	-1206(ra) # 800009a0 <mycpu>
    80000e5e:	00000617          	auipc	a2,0x0
    80000e62:	b8060613          	addi	a2,a2,-1152 # 800009de <execret>
    80000e66:	00850593          	addi	a1,a0,8
    80000e6a:	854e                	mv	a0,s3
    80000e6c:	00001097          	auipc	ra,0x1
    80000e70:	164080e7          	jalr	356(ra) # 80001fd0 <execra>
    // 不会返回
    panic("exec");
    80000e74:	00004517          	auipc	a0,0x4
    80000e78:	28c50513          	addi	a0,a0,652 # 80005100 <etext+0x100>
    80000e7c:	00000097          	auipc	ra,0x0
    80000e80:	760080e7          	jalr	1888(ra) # 800015dc <panic>
}
    80000e84:	70a2                	ld	ra,40(sp)
    80000e86:	7402                	ld	s0,32(sp)
    80000e88:	64e2                	ld	s1,24(sp)
    80000e8a:	6942                	ld	s2,16(sp)
    80000e8c:	69a2                	ld	s3,8(sp)
    80000e8e:	6145                	addi	sp,sp,48
    80000e90:	8082                	ret

0000000080000e92 <init>:
void init() {
    80000e92:	1101                	addi	sp,sp,-32
    80000e94:	ec06                	sd	ra,24(sp)
    80000e96:	e822                	sd	s0,16(sp)
    80000e98:	e426                	sd	s1,8(sp)
    80000e9a:	1000                	addi	s0,sp,32
    spin_unlock(&myproc()->proc_lock);
    80000e9c:	00000097          	auipc	ra,0x0
    80000ea0:	b28080e7          	jalr	-1240(ra) # 800009c4 <myproc>
    80000ea4:	00003097          	auipc	ra,0x3
    80000ea8:	a6c080e7          	jalr	-1428(ra) # 80003910 <spin_unlock>
    int pid = fork();
    80000eac:	00000097          	auipc	ra,0x0
    80000eb0:	2c2080e7          	jalr	706(ra) # 8000116e <fork>
    if (pid < 0) {
    80000eb4:	08054163          	bltz	a0,80000f36 <init+0xa4>
    } else if (pid == 0) {
    80000eb8:	c941                	beqz	a0,80000f48 <init+0xb6>
    printf("TRAMPOLINE=%p\n", TRAMPOLINE);
    80000eba:	040005b7          	lui	a1,0x4000
    80000ebe:	15fd                	addi	a1,a1,-1
    80000ec0:	05b2                	slli	a1,a1,0xc
    80000ec2:	00004517          	auipc	a0,0x4
    80000ec6:	24e50513          	addi	a0,a0,590 # 80005110 <etext+0x110>
    80000eca:	00000097          	auipc	ra,0x0
    80000ece:	65a080e7          	jalr	1626(ra) # 80001524 <printf>
    init_fs();
    80000ed2:	00002097          	auipc	ra,0x2
    80000ed6:	b2e080e7          	jalr	-1234(ra) # 80002a00 <init_fs>
    struct proc *p = exec0("proc", 0);
    80000eda:	4581                	li	a1,0
    80000edc:	00004517          	auipc	a0,0x4
    80000ee0:	1cc50513          	addi	a0,a0,460 # 800050a8 <etext+0xa8>
    80000ee4:	00002097          	auipc	ra,0x2
    80000ee8:	8e4080e7          	jalr	-1820(ra) # 800027c8 <exec0>
    80000eec:	84aa                	mv	s1,a0
    if(p==0){
    80000eee:	c535                	beqz	a0,80000f5a <init+0xc8>
    vmprint(p->pagetable, 1);
    80000ef0:	4585                	li	a1,1
    80000ef2:	64a8                	ld	a0,72(s1)
    80000ef4:	00001097          	auipc	ra,0x1
    80000ef8:	ff0080e7          	jalr	-16(ra) # 80001ee4 <vmprint>
    printf("pagetable=%p\n", p->pagetable);
    80000efc:	64ac                	ld	a1,72(s1)
    80000efe:	00004517          	auipc	a0,0x4
    80000f02:	23250513          	addi	a0,a0,562 # 80005130 <etext+0x130>
    80000f06:	00000097          	auipc	ra,0x0
    80000f0a:	61e080e7          	jalr	1566(ra) # 80001524 <printf>
    ((void (*)(uint64, uint64)) fn)(TRAPFRAME, MAKE_SATP(p->pagetable));
    80000f0e:	64ac                	ld	a1,72(s1)
    80000f10:	81b1                	srli	a1,a1,0xc
    80000f12:	040007b7          	lui	a5,0x4000
    80000f16:	577d                	li	a4,-1
    80000f18:	177e                	slli	a4,a4,0x3f
    80000f1a:	8dd9                	or	a1,a1,a4
    80000f1c:	02000537          	lui	a0,0x2000
    80000f20:	157d                	addi	a0,a0,-1
    80000f22:	0536                	slli	a0,a0,0xd
    80000f24:	17fd                	addi	a5,a5,-1
    80000f26:	07b2                	slli	a5,a5,0xc
    80000f28:	9782                	jalr	a5
        wait(0);
    80000f2a:	4501                	li	a0,0
    80000f2c:	00000097          	auipc	ra,0x0
    80000f30:	dac080e7          	jalr	-596(ra) # 80000cd8 <wait>
    for (;;) {
    80000f34:	bfdd                	j	80000f2a <init+0x98>
        panic("init");
    80000f36:	00004517          	auipc	a0,0x4
    80000f3a:	1d250513          	addi	a0,a0,466 # 80005108 <etext+0x108>
    80000f3e:	00000097          	auipc	ra,0x0
    80000f42:	69e080e7          	jalr	1694(ra) # 800015dc <panic>
    80000f46:	bf95                	j	80000eba <init+0x28>
        exec((uint64) osh);
    80000f48:	00001517          	auipc	a0,0x1
    80000f4c:	a2a50513          	addi	a0,a0,-1494 # 80001972 <osh>
    80000f50:	00000097          	auipc	ra,0x0
    80000f54:	ebc080e7          	jalr	-324(ra) # 80000e0c <exec>
    80000f58:	b78d                	j	80000eba <init+0x28>
        panic("proc init\n");
    80000f5a:	00004517          	auipc	a0,0x4
    80000f5e:	1c650513          	addi	a0,a0,454 # 80005120 <etext+0x120>
    80000f62:	00000097          	auipc	ra,0x0
    80000f66:	67a080e7          	jalr	1658(ra) # 800015dc <panic>
    80000f6a:	b759                	j	80000ef0 <init+0x5e>

0000000080000f6c <print_proc>:

void print_proc() {
    80000f6c:	1101                	addi	sp,sp,-32
    80000f6e:	ec06                	sd	ra,24(sp)
    80000f70:	e822                	sd	s0,16(sp)
    80000f72:	e426                	sd	s1,8(sp)
    80000f74:	1000                	addi	s0,sp,32
    struct proc *p;
    printf(" \npid\tstate\n");
    80000f76:	00004517          	auipc	a0,0x4
    80000f7a:	1ca50513          	addi	a0,a0,458 # 80005140 <etext+0x140>
    80000f7e:	00000097          	auipc	ra,0x0
    80000f82:	5a6080e7          	jalr	1446(ra) # 80001524 <printf>
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80000f86:	00047497          	auipc	s1,0x47
    80000f8a:	32a48493          	addi	s1,s1,810 # 800482b0 <proc_table>
    80000f8e:	a019                	j	80000f94 <print_proc+0x28>
    80000f90:	0e848493          	addi	s1,s1,232
    80000f94:	0004b797          	auipc	a5,0x4b
    80000f98:	d1c78793          	addi	a5,a5,-740 # 8004bcb0 <h>
    80000f9c:	00f4fe63          	bgeu	s1,a5,80000fb8 <print_proc+0x4c>
        if (p->state == UNUSED)
    80000fa0:	4c90                	lw	a2,24(s1)
    80000fa2:	d67d                	beqz	a2,80000f90 <print_proc+0x24>
            continue;
        printf(" %d\t  %d\n", p->pid, p->state);
    80000fa4:	5c8c                	lw	a1,56(s1)
    80000fa6:	00004517          	auipc	a0,0x4
    80000faa:	1aa50513          	addi	a0,a0,426 # 80005150 <etext+0x150>
    80000fae:	00000097          	auipc	ra,0x0
    80000fb2:	576080e7          	jalr	1398(ra) # 80001524 <printf>
    80000fb6:	bfe9                	j	80000f90 <print_proc+0x24>
    }
}
    80000fb8:	60e2                	ld	ra,24(sp)
    80000fba:	6442                	ld	s0,16(sp)
    80000fbc:	64a2                	ld	s1,8(sp)
    80000fbe:	6105                	addi	sp,sp,32
    80000fc0:	8082                	ret

0000000080000fc2 <memset>:
#include "types.h"

void *memset(void *dst, int c, uint n) {
    80000fc2:	1141                	addi	sp,sp,-16
    80000fc4:	e422                	sd	s0,8(sp)
    80000fc6:	0800                	addi	s0,sp,16
    char *cdst = (char *) dst;
    int i;
    for (i = 0; i < n; i++) {
    80000fc8:	4781                	li	a5,0
    80000fca:	0007871b          	sext.w	a4,a5
    80000fce:	00c77863          	bgeu	a4,a2,80000fde <memset+0x1c>
        cdst[i] = c;
    80000fd2:	00f50733          	add	a4,a0,a5
    80000fd6:	00b70023          	sb	a1,0(a4) # 1000 <_entry-0x7ffff000>
    for (i = 0; i < n; i++) {
    80000fda:	2785                	addiw	a5,a5,1
    80000fdc:	b7fd                	j	80000fca <memset+0x8>
    }
    return dst;
}
    80000fde:	6422                	ld	s0,8(sp)
    80000fe0:	0141                	addi	sp,sp,16
    80000fe2:	8082                	ret

0000000080000fe4 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
    80000fe4:	1141                	addi	sp,sp,-16
    80000fe6:	e422                	sd	s0,8(sp)
    80000fe8:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst) {
    80000fea:	02b56163          	bltu	a0,a1,8000100c <memmove+0x28>
        while (n-- > 0)
            *dst++ = *src++;
    } else {
        dst += n;
    80000fee:	00c507b3          	add	a5,a0,a2
        src += n;
    80000ff2:	95b2                	add	a1,a1,a2
        while (n-- > 0)
    80000ff4:	fff6071b          	addiw	a4,a2,-1
    80000ff8:	02c05763          	blez	a2,80001026 <memmove+0x42>
            *--dst = *--src;
    80000ffc:	15fd                	addi	a1,a1,-1
    80000ffe:	17fd                	addi	a5,a5,-1
    80001000:	0005c683          	lbu	a3,0(a1) # 4000000 <_entry-0x7c000000>
    80001004:	00d78023          	sb	a3,0(a5)
        while (n-- > 0)
    80001008:	863a                	mv	a2,a4
    8000100a:	b7ed                	j	80000ff4 <memmove+0x10>
    dst = vdst;
    8000100c:	87aa                	mv	a5,a0
        while (n-- > 0)
    8000100e:	fff6071b          	addiw	a4,a2,-1
    80001012:	00c05a63          	blez	a2,80001026 <memmove+0x42>
            *dst++ = *src++;
    80001016:	0005c683          	lbu	a3,0(a1)
    8000101a:	00d78023          	sb	a3,0(a5)
    8000101e:	0585                	addi	a1,a1,1
    80001020:	0785                	addi	a5,a5,1
        while (n-- > 0)
    80001022:	863a                	mv	a2,a4
    80001024:	b7ed                	j	8000100e <memmove+0x2a>
    }
    return vdst;
}
    80001026:	6422                	ld	s0,8(sp)
    80001028:	0141                	addi	sp,sp,16
    8000102a:	8082                	ret

000000008000102c <strlen>:

uint strlen(const char *s) {
    8000102c:	1141                	addi	sp,sp,-16
    8000102e:	e422                	sd	s0,8(sp)
    80001030:	0800                	addi	s0,sp,16
    80001032:	872a                	mv	a4,a0
    int n;
    for (n = 0; s[n]; n++);
    80001034:	4501                	li	a0,0
    80001036:	00a707b3          	add	a5,a4,a0
    8000103a:	0007c783          	lbu	a5,0(a5)
    8000103e:	c399                	beqz	a5,80001044 <strlen+0x18>
    80001040:	2505                	addiw	a0,a0,1
    80001042:	bfd5                	j	80001036 <strlen+0xa>
    return n;
}
    80001044:	6422                	ld	s0,8(sp)
    80001046:	0141                	addi	sp,sp,16
    80001048:	8082                	ret

000000008000104a <strcpy>:

char* strcpy(char* s, const char* t)
{
    8000104a:	1141                	addi	sp,sp,-16
    8000104c:	e422                	sd	s0,8(sp)
    8000104e:	0800                	addi	s0,sp,16
    char* os;
    os = s;
    while ((*s++ = *t++) != 0)
    80001050:	86aa                	mv	a3,a0
    80001052:	0005c703          	lbu	a4,0(a1)
    80001056:	0585                	addi	a1,a1,1
    80001058:	00e68023          	sb	a4,0(a3)
    8000105c:	0685                	addi	a3,a3,1
    8000105e:	fb75                	bnez	a4,80001052 <strcpy+0x8>
        ;
    return os;
}
    80001060:	6422                	ld	s0,8(sp)
    80001062:	0141                	addi	sp,sp,16
    80001064:	8082                	ret

0000000080001066 <strncpy>:

char * strncpy(char *s, const char *t, int n) {
    80001066:	1141                	addi	sp,sp,-16
    80001068:	e422                	sd	s0,8(sp)
    8000106a:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while (n-- > 0 && (*s++ = *t++) != 0);
    8000106c:	87aa                	mv	a5,a0
    8000106e:	a019                	j	80001074 <strncpy+0xe>
    80001070:	85c2                	mv	a1,a6
    80001072:	87b6                	mv	a5,a3
    80001074:	8732                	mv	a4,a2
    80001076:	367d                	addiw	a2,a2,-1
    80001078:	02e05163          	blez	a4,8000109a <strncpy+0x34>
    8000107c:	00158813          	addi	a6,a1,1
    80001080:	00178693          	addi	a3,a5,1
    80001084:	0005c703          	lbu	a4,0(a1)
    80001088:	00e78023          	sb	a4,0(a5)
    8000108c:	f375                	bnez	a4,80001070 <strncpy+0xa>
    8000108e:	87b6                	mv	a5,a3
    80001090:	a029                	j	8000109a <strncpy+0x34>
    while (n-- > 0)
        *s++ = 0;
    80001092:	00078023          	sb	zero,0(a5)
    while (n-- > 0)
    80001096:	863a                	mv	a2,a4
        *s++ = 0;
    80001098:	0785                	addi	a5,a5,1
    while (n-- > 0)
    8000109a:	fff6071b          	addiw	a4,a2,-1
    8000109e:	fec04ae3          	bgtz	a2,80001092 <strncpy+0x2c>
    return os;
}
    800010a2:	6422                	ld	s0,8(sp)
    800010a4:	0141                	addi	sp,sp,16
    800010a6:	8082                	ret

00000000800010a8 <strcmp>:

int strcmp(const char* p, const char* q)
{
    800010a8:	1141                	addi	sp,sp,-16
    800010aa:	e422                	sd	s0,8(sp)
    800010ac:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
    800010ae:	00054783          	lbu	a5,0(a0)
    800010b2:	cb81                	beqz	a5,800010c2 <strcmp+0x1a>
    800010b4:	0005c703          	lbu	a4,0(a1)
    800010b8:	00e79563          	bne	a5,a4,800010c2 <strcmp+0x1a>
        p++, q++;
    800010bc:	0505                	addi	a0,a0,1
    800010be:	0585                	addi	a1,a1,1
    800010c0:	b7fd                	j	800010ae <strcmp+0x6>
    return (uchar)*p - (uchar)*q;
    800010c2:	0005c503          	lbu	a0,0(a1)
}
    800010c6:	40a7853b          	subw	a0,a5,a0
    800010ca:	6422                	ld	s0,8(sp)
    800010cc:	0141                	addi	sp,sp,16
    800010ce:	8082                	ret

00000000800010d0 <strncmp>:

int strncmp(const char *p, const char *q, uint n)
{
    800010d0:	1141                	addi	sp,sp,-16
    800010d2:	e422                	sd	s0,8(sp)
    800010d4:	0800                	addi	s0,sp,16
    while(n > 0 && *p && *p == *q)
    800010d6:	a021                	j	800010de <strncmp+0xe>
        n--, p++, q++;
    800010d8:	367d                	addiw	a2,a2,-1
    800010da:	0505                	addi	a0,a0,1
    800010dc:	0585                	addi	a1,a1,1
    while(n > 0 && *p && *p == *q)
    800010de:	ca01                	beqz	a2,800010ee <strncmp+0x1e>
    800010e0:	00054783          	lbu	a5,0(a0)
    800010e4:	c789                	beqz	a5,800010ee <strncmp+0x1e>
    800010e6:	0005c703          	lbu	a4,0(a1)
    800010ea:	fee787e3          	beq	a5,a4,800010d8 <strncmp+0x8>
    if(n == 0)
    800010ee:	ca09                	beqz	a2,80001100 <strncmp+0x30>
        return 0;
    return (uchar)*p - (uchar)*q;
    800010f0:	00054503          	lbu	a0,0(a0)
    800010f4:	0005c783          	lbu	a5,0(a1)
    800010f8:	9d1d                	subw	a0,a0,a5
}
    800010fa:	6422                	ld	s0,8(sp)
    800010fc:	0141                	addi	sp,sp,16
    800010fe:	8082                	ret
        return 0;
    80001100:	4501                	li	a0,0
    80001102:	bfe5                	j	800010fa <strncmp+0x2a>

0000000080001104 <pswitch>:
    80001104:	00153023          	sd	ra,0(a0)
    80001108:	00253423          	sd	sp,8(a0)
    8000110c:	e900                	sd	s0,16(a0)
    8000110e:	ed04                	sd	s1,24(a0)
    80001110:	03253023          	sd	s2,32(a0)
    80001114:	03353423          	sd	s3,40(a0)
    80001118:	03453823          	sd	s4,48(a0)
    8000111c:	03553c23          	sd	s5,56(a0)
    80001120:	05653023          	sd	s6,64(a0)
    80001124:	05753423          	sd	s7,72(a0)
    80001128:	05853823          	sd	s8,80(a0)
    8000112c:	05953c23          	sd	s9,88(a0)
    80001130:	07a53023          	sd	s10,96(a0)
    80001134:	07b53423          	sd	s11,104(a0)
    80001138:	0005b083          	ld	ra,0(a1)
    8000113c:	0085b103          	ld	sp,8(a1)
    80001140:	6980                	ld	s0,16(a1)
    80001142:	6d84                	ld	s1,24(a1)
    80001144:	0205b903          	ld	s2,32(a1)
    80001148:	0285b983          	ld	s3,40(a1)
    8000114c:	0305ba03          	ld	s4,48(a1)
    80001150:	0385ba83          	ld	s5,56(a1)
    80001154:	0405bb03          	ld	s6,64(a1)
    80001158:	0485bb83          	ld	s7,72(a1)
    8000115c:	0505bc03          	ld	s8,80(a1)
    80001160:	0585bc83          	ld	s9,88(a1)
    80001164:	0605bd03          	ld	s10,96(a1)
    80001168:	0685bd83          	ld	s11,104(a1)
    8000116c:	8082                	ret

000000008000116e <fork>:
// fork的简单实现
// fork失败返回-1
// 父进程返回子进程id
// 子进程返回0
//
int fork() {
    8000116e:	1101                	addi	sp,sp,-32
    80001170:	ec06                	sd	ra,24(sp)
    80001172:	e822                	sd	s0,16(sp)
    80001174:	e426                	sd	s1,8(sp)
    80001176:	e04a                	sd	s2,0(sp)
    80001178:	1000                	addi	s0,sp,32
    struct proc *p;
    struct proc *np;
    if ((np = alloc_proc()) == 0) {
    8000117a:	fffff097          	auipc	ra,0xfffff
    8000117e:	6ce080e7          	jalr	1742(ra) # 80000848 <alloc_proc>
    80001182:	c93d                	beqz	a0,800011f8 <fork+0x8a>
    80001184:	84aa                	mv	s1,a0
        return -1;
    }
    p = myproc();
    80001186:	00000097          	auipc	ra,0x0
    8000118a:	83e080e7          	jalr	-1986(ra) # 800009c4 <myproc>
    8000118e:	892a                	mv	s2,a0
    memmove((char *) np->kstack, (char *) p->kstack, PGSIZE);
    80001190:	6605                	lui	a2,0x1
    80001192:	712c                	ld	a1,96(a0)
    80001194:	70a8                	ld	a0,96(s1)
    80001196:	00000097          	auipc	ra,0x0
    8000119a:	e4e080e7          	jalr	-434(ra) # 80000fe4 <memmove>
    np->parent = p;
    8000119e:	0324b023          	sd	s2,32(s1)
    np->state = RUNNABLE;
    800011a2:	4789                	li	a5,2
    800011a4:	cc9c                	sw	a5,24(s1)
    np->current_dir = dup_inode(p->current_dir);
    800011a6:	05093503          	ld	a0,80(s2)
    800011aa:	00002097          	auipc	ra,0x2
    800011ae:	e56080e7          	jalr	-426(ra) # 80003000 <dup_inode>
    800011b2:	e8a8                	sd	a0,80(s1)
    forkra(&np->context, p->kstack, np->kstack);
    800011b4:	70b0                	ld	a2,96(s1)
    800011b6:	06093583          	ld	a1,96(s2)
    800011ba:	06848513          	addi	a0,s1,104
    800011be:	00001097          	auipc	ra,0x1
    800011c2:	dd2080e7          	jalr	-558(ra) # 80001f90 <forkra>
    if (myproc() == np) {
    800011c6:	fffff097          	auipc	ra,0xfffff
    800011ca:	7fe080e7          	jalr	2046(ra) # 800009c4 <myproc>
    800011ce:	00a48f63          	beq	s1,a0,800011ec <fork+0x7e>
        spin_unlock(&np->proc_lock);
    }
    return myproc() == np ? 0 : np->pid;
    800011d2:	fffff097          	auipc	ra,0xfffff
    800011d6:	7f2080e7          	jalr	2034(ra) # 800009c4 <myproc>
    800011da:	02a48163          	beq	s1,a0,800011fc <fork+0x8e>
    800011de:	5c88                	lw	a0,56(s1)
}
    800011e0:	60e2                	ld	ra,24(sp)
    800011e2:	6442                	ld	s0,16(sp)
    800011e4:	64a2                	ld	s1,8(sp)
    800011e6:	6902                	ld	s2,0(sp)
    800011e8:	6105                	addi	sp,sp,32
    800011ea:	8082                	ret
        spin_unlock(&np->proc_lock);
    800011ec:	8526                	mv	a0,s1
    800011ee:	00002097          	auipc	ra,0x2
    800011f2:	722080e7          	jalr	1826(ra) # 80003910 <spin_unlock>
    800011f6:	bff1                	j	800011d2 <fork+0x64>
        return -1;
    800011f8:	557d                	li	a0,-1
    800011fa:	b7dd                	j	800011e0 <fork+0x72>
    return myproc() == np ? 0 : np->pid;
    800011fc:	4501                	li	a0,0
    800011fe:	b7cd                	j	800011e0 <fork+0x72>

0000000080001200 <sleep_sec>:

//
// 睡眠指定秒数
//
void sleep_sec(int seconds) {
    80001200:	1141                	addi	sp,sp,-16
    80001202:	e406                	sd	ra,8(sp)
    80001204:	e022                	sd	s0,0(sp)
    80001206:	0800                	addi	s0,sp,16
    sleep_time(seconds * 10);
    80001208:	0025179b          	slliw	a5,a0,0x2
    8000120c:	9d3d                	addw	a0,a0,a5
    8000120e:	0015151b          	slliw	a0,a0,0x1
    80001212:	00000097          	auipc	ra,0x0
    80001216:	936080e7          	jalr	-1738(ra) # 80000b48 <sleep_time>
}
    8000121a:	60a2                	ld	ra,8(sp)
    8000121c:	6402                	ld	s0,0(sp)
    8000121e:	0141                	addi	sp,sp,16
    80001220:	8082                	ret

0000000080001222 <yield>:

//
// 让出cpu
//
void yield() {
    80001222:	1101                	addi	sp,sp,-32
    80001224:	ec06                	sd	ra,24(sp)
    80001226:	e822                	sd	s0,16(sp)
    80001228:	e426                	sd	s1,8(sp)
    8000122a:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    8000122c:	fffff097          	auipc	ra,0xfffff
    80001230:	798080e7          	jalr	1944(ra) # 800009c4 <myproc>
    80001234:	84aa                	mv	s1,a0
    spin_lock(&p->proc_lock);
    80001236:	00002097          	auipc	ra,0x2
    8000123a:	608080e7          	jalr	1544(ra) # 8000383e <spin_lock>
    p->state = RUNNABLE;
    8000123e:	4789                	li	a5,2
    80001240:	cc9c                	sw	a5,24(s1)
    before_sched();
    80001242:	fffff097          	auipc	ra,0xfffff
    80001246:	7d0080e7          	jalr	2000(ra) # 80000a12 <before_sched>
    spin_unlock(&p->proc_lock);
    8000124a:	8526                	mv	a0,s1
    8000124c:	00002097          	auipc	ra,0x2
    80001250:	6c4080e7          	jalr	1732(ra) # 80003910 <spin_unlock>
}
    80001254:	60e2                	ld	ra,24(sp)
    80001256:	6442                	ld	s0,16(sp)
    80001258:	64a2                	ld	s1,8(sp)
    8000125a:	6105                	addi	sp,sp,32
    8000125c:	8082                	ret

000000008000125e <printint>:

static char digits[] = "0123456789ABCDEF";

static void
printint(int fd, int xx, int base, int sgn)
{
    8000125e:	7179                	addi	sp,sp,-48
    80001260:	f406                	sd	ra,40(sp)
    80001262:	f022                	sd	s0,32(sp)
    80001264:	ec26                	sd	s1,24(sp)
    80001266:	e84a                	sd	s2,16(sp)
    80001268:	1800                	addi	s0,sp,48
    8000126a:	892a                	mv	s2,a0
    char buf[16];
    int i, neg;
    uint x;

    neg = 0;
    if (sgn && xx < 0) {
    8000126c:	c299                	beqz	a3,80001272 <printint+0x14>
    8000126e:	0405cc63          	bltz	a1,800012c6 <printint+0x68>
        neg = 1;
        x = -xx;
    } else {
        x = xx;
    80001272:	2581                	sext.w	a1,a1
    neg = 0;
    80001274:	4801                	li	a6,0
    }

    i = 0;
    80001276:	4481                	li	s1,0
    do {
        buf[i++] = digits[x % base];
    80001278:	0006079b          	sext.w	a5,a2
    8000127c:	02c5f73b          	remuw	a4,a1,a2
    80001280:	8526                	mv	a0,s1
    80001282:	2485                	addiw	s1,s1,1
    80001284:	02071693          	slli	a3,a4,0x20
    80001288:	9281                	srli	a3,a3,0x20
    8000128a:	00004717          	auipc	a4,0x4
    8000128e:	f0e70713          	addi	a4,a4,-242 # 80005198 <digits>
    80001292:	9736                	add	a4,a4,a3
    80001294:	00074683          	lbu	a3,0(a4)
    80001298:	fe040713          	addi	a4,s0,-32
    8000129c:	972a                	add	a4,a4,a0
    8000129e:	fed70823          	sb	a3,-16(a4)
    } while ((x /= base) != 0);
    800012a2:	0005871b          	sext.w	a4,a1
    800012a6:	02c5d5bb          	divuw	a1,a1,a2
    800012aa:	fcf777e3          	bgeu	a4,a5,80001278 <printint+0x1a>
    if (neg)
    800012ae:	02080a63          	beqz	a6,800012e2 <printint+0x84>
        buf[i++] = '-';
    800012b2:	fe040793          	addi	a5,s0,-32
    800012b6:	94be                	add	s1,s1,a5
    800012b8:	02d00793          	li	a5,45
    800012bc:	fef48823          	sb	a5,-16(s1)
    800012c0:	0025049b          	addiw	s1,a0,2
    800012c4:	a839                	j	800012e2 <printint+0x84>
        x = -xx;
    800012c6:	40b005bb          	negw	a1,a1
        neg = 1;
    800012ca:	4805                	li	a6,1
        x = -xx;
    800012cc:	b76d                	j	80001276 <printint+0x18>

    while (--i >= 0)
        putc(fd, buf[i]);
    800012ce:	fe040793          	addi	a5,s0,-32
    800012d2:	97a6                	add	a5,a5,s1
    800012d4:	ff07c583          	lbu	a1,-16(a5)
    800012d8:	854a                	mv	a0,s2
    800012da:	fffff097          	auipc	ra,0xfffff
    800012de:	f6e080e7          	jalr	-146(ra) # 80000248 <putc>
    while (--i >= 0)
    800012e2:	34fd                	addiw	s1,s1,-1
    800012e4:	fe04d5e3          	bgez	s1,800012ce <printint+0x70>
}
    800012e8:	70a2                	ld	ra,40(sp)
    800012ea:	7402                	ld	s0,32(sp)
    800012ec:	64e2                	ld	s1,24(sp)
    800012ee:	6942                	ld	s2,16(sp)
    800012f0:	6145                	addi	sp,sp,48
    800012f2:	8082                	ret

00000000800012f4 <printptr>:

static void
printptr(int fd, uint64 x)
{
    800012f4:	7179                	addi	sp,sp,-48
    800012f6:	f406                	sd	ra,40(sp)
    800012f8:	f022                	sd	s0,32(sp)
    800012fa:	ec26                	sd	s1,24(sp)
    800012fc:	e84a                	sd	s2,16(sp)
    800012fe:	e44e                	sd	s3,8(sp)
    80001300:	1800                	addi	s0,sp,48
    80001302:	89aa                	mv	s3,a0
    80001304:	84ae                	mv	s1,a1
    int i;
    putc(fd, '0');
    80001306:	03000593          	li	a1,48
    8000130a:	fffff097          	auipc	ra,0xfffff
    8000130e:	f3e080e7          	jalr	-194(ra) # 80000248 <putc>
    putc(fd, 'x');
    80001312:	07800593          	li	a1,120
    80001316:	854e                	mv	a0,s3
    80001318:	fffff097          	auipc	ra,0xfffff
    8000131c:	f30080e7          	jalr	-208(ra) # 80000248 <putc>
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80001320:	4901                	li	s2,0
    80001322:	0009079b          	sext.w	a5,s2
    80001326:	473d                	li	a4,15
    80001328:	02f76363          	bltu	a4,a5,8000134e <printptr+0x5a>
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000132c:	03c4d713          	srli	a4,s1,0x3c
    80001330:	00004797          	auipc	a5,0x4
    80001334:	e6878793          	addi	a5,a5,-408 # 80005198 <digits>
    80001338:	97ba                	add	a5,a5,a4
    8000133a:	0007c583          	lbu	a1,0(a5)
    8000133e:	854e                	mv	a0,s3
    80001340:	fffff097          	auipc	ra,0xfffff
    80001344:	f08080e7          	jalr	-248(ra) # 80000248 <putc>
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80001348:	2905                	addiw	s2,s2,1
    8000134a:	0492                	slli	s1,s1,0x4
    8000134c:	bfd9                	j	80001322 <printptr+0x2e>
}
    8000134e:	70a2                	ld	ra,40(sp)
    80001350:	7402                	ld	s0,32(sp)
    80001352:	64e2                	ld	s1,24(sp)
    80001354:	6942                	ld	s2,16(sp)
    80001356:	69a2                	ld	s3,8(sp)
    80001358:	6145                	addi	sp,sp,48
    8000135a:	8082                	ret

000000008000135c <vprintf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char* fmt, va_list ap)
{
    8000135c:	715d                	addi	sp,sp,-80
    8000135e:	e486                	sd	ra,72(sp)
    80001360:	e0a2                	sd	s0,64(sp)
    80001362:	fc26                	sd	s1,56(sp)
    80001364:	f84a                	sd	s2,48(sp)
    80001366:	f44e                	sd	s3,40(sp)
    80001368:	f052                	sd	s4,32(sp)
    8000136a:	ec56                	sd	s5,24(sp)
    8000136c:	0880                	addi	s0,sp,80
    8000136e:	8aaa                	mv	s5,a0
    80001370:	8a2e                	mv	s4,a1
    80001372:	fac43c23          	sd	a2,-72(s0)
    char* s;
    int c, i, state;

    state = 0;
    80001376:	4981                	li	s3,0
    for (i = 0; fmt[i]; i++) {
    80001378:	4901                	li	s2,0
    8000137a:	a829                	j	80001394 <vprintf+0x38>
        c = fmt[i] & 0xff;
        if (state == 0) {
            if (c == '%') {
                state = '%';
            } else {
                putc(fd, c);
    8000137c:	85a6                	mv	a1,s1
    8000137e:	8556                	mv	a0,s5
    80001380:	fffff097          	auipc	ra,0xfffff
    80001384:	ec8080e7          	jalr	-312(ra) # 80000248 <putc>
    80001388:	a029                	j	80001392 <vprintf+0x36>
            }
        } else if (state == '%') {
    8000138a:	02500713          	li	a4,37
    8000138e:	02e98363          	beq	s3,a4,800013b4 <vprintf+0x58>
    for (i = 0; fmt[i]; i++) {
    80001392:	2905                	addiw	s2,s2,1
    80001394:	012a07b3          	add	a5,s4,s2
    80001398:	0007c483          	lbu	s1,0(a5)
    8000139c:	14048463          	beqz	s1,800014e4 <vprintf+0x188>
        c = fmt[i] & 0xff;
    800013a0:	0004879b          	sext.w	a5,s1
        if (state == 0) {
    800013a4:	fe0993e3          	bnez	s3,8000138a <vprintf+0x2e>
            if (c == '%') {
    800013a8:	02500713          	li	a4,37
    800013ac:	fce798e3          	bne	a5,a4,8000137c <vprintf+0x20>
                state = '%';
    800013b0:	89be                	mv	s3,a5
    800013b2:	b7c5                	j	80001392 <vprintf+0x36>
            if (c == 'd') {
    800013b4:	06400713          	li	a4,100
    800013b8:	04e78963          	beq	a5,a4,8000140a <vprintf+0xae>
                printint(fd, va_arg(ap, int), 10, 1);
            } else if (c == 'l') {
    800013bc:	06c00713          	li	a4,108
    800013c0:	06e78563          	beq	a5,a4,8000142a <vprintf+0xce>
                printint(fd, va_arg(ap, uint64), 10, 0);
            } else if (c == 'x') {
    800013c4:	07800713          	li	a4,120
    800013c8:	08e78163          	beq	a5,a4,8000144a <vprintf+0xee>
                printint(fd, va_arg(ap, int), 16, 0);
            } else if (c == 'p') {
    800013cc:	07000713          	li	a4,112
    800013d0:	08e78d63          	beq	a5,a4,8000146a <vprintf+0x10e>
                printptr(fd, va_arg(ap, uint64));
            } else if (c == 's') {
    800013d4:	07300713          	li	a4,115
    800013d8:	0ae78763          	beq	a5,a4,80001486 <vprintf+0x12a>
                    s = "(null)";
                while (*s != 0) {
                    putc(fd, *s);
                    s++;
                }
            } else if (c == 'c') {
    800013dc:	06300713          	li	a4,99
    800013e0:	0ce78b63          	beq	a5,a4,800014b6 <vprintf+0x15a>
                putc(fd, va_arg(ap, uint));
            } else if (c == '%') {
    800013e4:	02500713          	li	a4,37
    800013e8:	0ee78663          	beq	a5,a4,800014d4 <vprintf+0x178>
                putc(fd, c);
            } else {
                // Unknown % sequence.  Print it to draw attention.
                putc(fd, '%');
    800013ec:	02500593          	li	a1,37
    800013f0:	8556                	mv	a0,s5
    800013f2:	fffff097          	auipc	ra,0xfffff
    800013f6:	e56080e7          	jalr	-426(ra) # 80000248 <putc>
                putc(fd, c);
    800013fa:	85a6                	mv	a1,s1
    800013fc:	8556                	mv	a0,s5
    800013fe:	fffff097          	auipc	ra,0xfffff
    80001402:	e4a080e7          	jalr	-438(ra) # 80000248 <putc>
            }
            state = 0;
    80001406:	4981                	li	s3,0
    80001408:	b769                	j	80001392 <vprintf+0x36>
                printint(fd, va_arg(ap, int), 10, 1);
    8000140a:	fb843783          	ld	a5,-72(s0)
    8000140e:	00878713          	addi	a4,a5,8
    80001412:	fae43c23          	sd	a4,-72(s0)
    80001416:	4685                	li	a3,1
    80001418:	4629                	li	a2,10
    8000141a:	438c                	lw	a1,0(a5)
    8000141c:	8556                	mv	a0,s5
    8000141e:	00000097          	auipc	ra,0x0
    80001422:	e40080e7          	jalr	-448(ra) # 8000125e <printint>
            state = 0;
    80001426:	4981                	li	s3,0
    80001428:	b7ad                	j	80001392 <vprintf+0x36>
                printint(fd, va_arg(ap, uint64), 10, 0);
    8000142a:	fb843783          	ld	a5,-72(s0)
    8000142e:	00878713          	addi	a4,a5,8
    80001432:	fae43c23          	sd	a4,-72(s0)
    80001436:	4681                	li	a3,0
    80001438:	4629                	li	a2,10
    8000143a:	438c                	lw	a1,0(a5)
    8000143c:	8556                	mv	a0,s5
    8000143e:	00000097          	auipc	ra,0x0
    80001442:	e20080e7          	jalr	-480(ra) # 8000125e <printint>
            state = 0;
    80001446:	4981                	li	s3,0
    80001448:	b7a9                	j	80001392 <vprintf+0x36>
                printint(fd, va_arg(ap, int), 16, 0);
    8000144a:	fb843783          	ld	a5,-72(s0)
    8000144e:	00878713          	addi	a4,a5,8
    80001452:	fae43c23          	sd	a4,-72(s0)
    80001456:	4681                	li	a3,0
    80001458:	4641                	li	a2,16
    8000145a:	438c                	lw	a1,0(a5)
    8000145c:	8556                	mv	a0,s5
    8000145e:	00000097          	auipc	ra,0x0
    80001462:	e00080e7          	jalr	-512(ra) # 8000125e <printint>
            state = 0;
    80001466:	4981                	li	s3,0
    80001468:	b72d                	j	80001392 <vprintf+0x36>
                printptr(fd, va_arg(ap, uint64));
    8000146a:	fb843783          	ld	a5,-72(s0)
    8000146e:	00878713          	addi	a4,a5,8
    80001472:	fae43c23          	sd	a4,-72(s0)
    80001476:	638c                	ld	a1,0(a5)
    80001478:	8556                	mv	a0,s5
    8000147a:	00000097          	auipc	ra,0x0
    8000147e:	e7a080e7          	jalr	-390(ra) # 800012f4 <printptr>
            state = 0;
    80001482:	4981                	li	s3,0
    80001484:	b739                	j	80001392 <vprintf+0x36>
                s = va_arg(ap, char*);
    80001486:	fb843783          	ld	a5,-72(s0)
    8000148a:	00878713          	addi	a4,a5,8
    8000148e:	fae43c23          	sd	a4,-72(s0)
    80001492:	6384                	ld	s1,0(a5)
                if (s == 0)
    80001494:	ec81                	bnez	s1,800014ac <vprintf+0x150>
                    s = "(null)";
    80001496:	00004497          	auipc	s1,0x4
    8000149a:	cca48493          	addi	s1,s1,-822 # 80005160 <etext+0x160>
    8000149e:	a039                	j	800014ac <vprintf+0x150>
                    putc(fd, *s);
    800014a0:	8556                	mv	a0,s5
    800014a2:	fffff097          	auipc	ra,0xfffff
    800014a6:	da6080e7          	jalr	-602(ra) # 80000248 <putc>
                    s++;
    800014aa:	0485                	addi	s1,s1,1
                while (*s != 0) {
    800014ac:	0004c583          	lbu	a1,0(s1)
    800014b0:	f9e5                	bnez	a1,800014a0 <vprintf+0x144>
            state = 0;
    800014b2:	4981                	li	s3,0
    800014b4:	bdf9                	j	80001392 <vprintf+0x36>
                putc(fd, va_arg(ap, uint));
    800014b6:	fb843783          	ld	a5,-72(s0)
    800014ba:	00878713          	addi	a4,a5,8
    800014be:	fae43c23          	sd	a4,-72(s0)
    800014c2:	0007c583          	lbu	a1,0(a5)
    800014c6:	8556                	mv	a0,s5
    800014c8:	fffff097          	auipc	ra,0xfffff
    800014cc:	d80080e7          	jalr	-640(ra) # 80000248 <putc>
            state = 0;
    800014d0:	4981                	li	s3,0
    800014d2:	b5c1                	j	80001392 <vprintf+0x36>
                putc(fd, c);
    800014d4:	85a6                	mv	a1,s1
    800014d6:	8556                	mv	a0,s5
    800014d8:	fffff097          	auipc	ra,0xfffff
    800014dc:	d70080e7          	jalr	-656(ra) # 80000248 <putc>
            state = 0;
    800014e0:	4981                	li	s3,0
    800014e2:	bd45                	j	80001392 <vprintf+0x36>
        }
    }
}
    800014e4:	60a6                	ld	ra,72(sp)
    800014e6:	6406                	ld	s0,64(sp)
    800014e8:	74e2                	ld	s1,56(sp)
    800014ea:	7942                	ld	s2,48(sp)
    800014ec:	79a2                	ld	s3,40(sp)
    800014ee:	7a02                	ld	s4,32(sp)
    800014f0:	6ae2                	ld	s5,24(sp)
    800014f2:	6161                	addi	sp,sp,80
    800014f4:	8082                	ret

00000000800014f6 <fprintf>:

void fprintf(int fd, const char* fmt, ...)
{
    800014f6:	715d                	addi	sp,sp,-80
    800014f8:	ec06                	sd	ra,24(sp)
    800014fa:	e822                	sd	s0,16(sp)
    800014fc:	1000                	addi	s0,sp,32
    800014fe:	e010                	sd	a2,0(s0)
    80001500:	e414                	sd	a3,8(s0)
    80001502:	e818                	sd	a4,16(s0)
    80001504:	ec1c                	sd	a5,24(s0)
    80001506:	03043023          	sd	a6,32(s0)
    8000150a:	03143423          	sd	a7,40(s0)
    va_list ap;

    va_start(ap, fmt);
    8000150e:	fe843423          	sd	s0,-24(s0)
    vprintf(fd, fmt, ap);
    80001512:	8622                	mv	a2,s0
    80001514:	00000097          	auipc	ra,0x0
    80001518:	e48080e7          	jalr	-440(ra) # 8000135c <vprintf>
}
    8000151c:	60e2                	ld	ra,24(sp)
    8000151e:	6442                	ld	s0,16(sp)
    80001520:	6161                	addi	sp,sp,80
    80001522:	8082                	ret

0000000080001524 <printf>:

void printf(const char* fmt, ...)
{
    80001524:	711d                	addi	sp,sp,-96
    80001526:	ec06                	sd	ra,24(sp)
    80001528:	e822                	sd	s0,16(sp)
    8000152a:	1000                	addi	s0,sp,32
    8000152c:	e40c                	sd	a1,8(s0)
    8000152e:	e810                	sd	a2,16(s0)
    80001530:	ec14                	sd	a3,24(s0)
    80001532:	f018                	sd	a4,32(s0)
    80001534:	f41c                	sd	a5,40(s0)
    80001536:	03043823          	sd	a6,48(s0)
    8000153a:	03143c23          	sd	a7,56(s0)
    va_list ap;

    va_start(ap, fmt);
    8000153e:	00840613          	addi	a2,s0,8
    80001542:	fec43423          	sd	a2,-24(s0)
    vprintf(1, fmt, ap);
    80001546:	85aa                	mv	a1,a0
    80001548:	4505                	li	a0,1
    8000154a:	00000097          	auipc	ra,0x0
    8000154e:	e12080e7          	jalr	-494(ra) # 8000135c <vprintf>
}
    80001552:	60e2                	ld	ra,24(sp)
    80001554:	6442                	ld	s0,16(sp)
    80001556:	6125                	addi	sp,sp,96
    80001558:	8082                	ret

000000008000155a <puts>:

void puts(const char* str)
{
    8000155a:	1141                	addi	sp,sp,-16
    8000155c:	e406                	sd	ra,8(sp)
    8000155e:	e022                	sd	s0,0(sp)
    80001560:	0800                	addi	s0,sp,16
    80001562:	85aa                	mv	a1,a0
    printf("%s\n", str);
    80001564:	00004517          	auipc	a0,0x4
    80001568:	c0450513          	addi	a0,a0,-1020 # 80005168 <etext+0x168>
    8000156c:	00000097          	auipc	ra,0x0
    80001570:	fb8080e7          	jalr	-72(ra) # 80001524 <printf>
}
    80001574:	60a2                	ld	ra,8(sp)
    80001576:	6402                	ld	s0,0(sp)
    80001578:	0141                	addi	sp,sp,16
    8000157a:	8082                	ret

000000008000157c <backtrace>:

void backtrace()
{
    8000157c:	7179                	addi	sp,sp,-48
    8000157e:	f406                	sd	ra,40(sp)
    80001580:	f022                	sd	s0,32(sp)
    80001582:	ec26                	sd	s1,24(sp)
    80001584:	e84a                	sd	s2,16(sp)
    80001586:	e44e                	sd	s3,8(sp)
    80001588:	1800                	addi	s0,sp,48
    asm volatile("mv %0, s0" : "=r" (x) );
    8000158a:	84a2                	mv	s1,s0
    uint64 s0 = r_fp();
    uint64 stack_top = PGROUNDUP(s0);
    8000158c:	6905                	lui	s2,0x1
    8000158e:	197d                	addi	s2,s2,-1
    80001590:	9926                	add	s2,s2,s1
    80001592:	79fd                	lui	s3,0xfffff
    80001594:	01397933          	and	s2,s2,s3
    uint64 stack_bottom = PGROUNDDOWN(s0);
    80001598:	0134f9b3          	and	s3,s1,s3
    uint64 fp = s0;

    printf("backtrace:\n");
    8000159c:	00004517          	auipc	a0,0x4
    800015a0:	bd450513          	addi	a0,a0,-1068 # 80005170 <etext+0x170>
    800015a4:	00000097          	auipc	ra,0x0
    800015a8:	f80080e7          	jalr	-128(ra) # 80001524 <printf>
    while (fp != stack_top && fp != stack_bottom)
    800015ac:	03248163          	beq	s1,s2,800015ce <backtrace+0x52>
    800015b0:	01348f63          	beq	s1,s3,800015ce <backtrace+0x52>
    {
        printf("%p\n", *(uint64*)(fp - 8));
    800015b4:	ff84b583          	ld	a1,-8(s1)
    800015b8:	00004517          	auipc	a0,0x4
    800015bc:	bc850513          	addi	a0,a0,-1080 # 80005180 <etext+0x180>
    800015c0:	00000097          	auipc	ra,0x0
    800015c4:	f64080e7          	jalr	-156(ra) # 80001524 <printf>
        fp = *(uint64*)(fp - 16);
    800015c8:	ff04b483          	ld	s1,-16(s1)
    800015cc:	b7c5                	j	800015ac <backtrace+0x30>
    }
}
    800015ce:	70a2                	ld	ra,40(sp)
    800015d0:	7402                	ld	s0,32(sp)
    800015d2:	64e2                	ld	s1,24(sp)
    800015d4:	6942                	ld	s2,16(sp)
    800015d6:	69a2                	ld	s3,8(sp)
    800015d8:	6145                	addi	sp,sp,48
    800015da:	8082                	ret

00000000800015dc <panic>:

void panic(char* s)
{
    800015dc:	1141                	addi	sp,sp,-16
    800015de:	e406                	sd	ra,8(sp)
    800015e0:	e022                	sd	s0,0(sp)
    800015e2:	0800                	addi	s0,sp,16
    800015e4:	85aa                	mv	a1,a0
    printf("panic:%s", s);
    800015e6:	00004517          	auipc	a0,0x4
    800015ea:	ba250513          	addi	a0,a0,-1118 # 80005188 <etext+0x188>
    800015ee:	00000097          	auipc	ra,0x0
    800015f2:	f36080e7          	jalr	-202(ra) # 80001524 <printf>
    backtrace();
    800015f6:	00000097          	auipc	ra,0x0
    800015fa:	f86080e7          	jalr	-122(ra) # 8000157c <backtrace>
    for (;;) {
    800015fe:	a001                	j	800015fe <panic+0x22>

0000000080001600 <showHistory>:
} history;

history h;

void showHistory()
{
    80001600:	1101                	addi	sp,sp,-32
    80001602:	ec06                	sd	ra,24(sp)
    80001604:	e822                	sd	s0,16(sp)
    80001606:	e426                	sd	s1,8(sp)
    80001608:	e04a                	sd	s2,0(sp)
    8000160a:	1000                	addi	s0,sp,32
    int startP=h.currentP;
    8000160c:	0004a497          	auipc	s1,0x4a
    80001610:	7e44a483          	lw	s1,2020(s1) # 8004bdf0 <h+0x140>
    for (int k = MAX_HISTORY_NUM, i = (MAX_HISTORY_NUM + startP) % MAX_HISTORY_NUM; k > 0; i++, k--) {
    80001614:	2495                	addiw	s1,s1,5
    80001616:	4795                	li	a5,5
    80001618:	02f4e4bb          	remw	s1,s1,a5
    8000161c:	4915                	li	s2,5
    8000161e:	a019                	j	80001624 <showHistory+0x24>
    80001620:	2485                	addiw	s1,s1,1
    80001622:	397d                	addiw	s2,s2,-1
    80001624:	05205263          	blez	s2,80001668 <showHistory+0x68>
        if (i >= MAX_HISTORY_NUM)
    80001628:	4791                	li	a5,4
    8000162a:	0097d563          	bge	a5,s1,80001634 <showHistory+0x34>
            i = i % MAX_HISTORY_NUM;
    8000162e:	4795                	li	a5,5
    80001630:	02f4e4bb          	remw	s1,s1,a5
        if (h.cmdlist[i][0] == '\0')
    80001634:	00649713          	slli	a4,s1,0x6
    80001638:	0004a797          	auipc	a5,0x4a
    8000163c:	67878793          	addi	a5,a5,1656 # 8004bcb0 <h>
    80001640:	97ba                	add	a5,a5,a4
    80001642:	0007c783          	lbu	a5,0(a5)
    80001646:	dfe9                	beqz	a5,80001620 <showHistory+0x20>
            continue;
        else {
            printf("#%d\t%s\n", k, h.cmdlist[i]);
    80001648:	0004a797          	auipc	a5,0x4a
    8000164c:	66878793          	addi	a5,a5,1640 # 8004bcb0 <h>
    80001650:	00e78633          	add	a2,a5,a4
    80001654:	85ca                	mv	a1,s2
    80001656:	00004517          	auipc	a0,0x4
    8000165a:	b5a50513          	addi	a0,a0,-1190 # 800051b0 <digits+0x18>
    8000165e:	00000097          	auipc	ra,0x0
    80001662:	ec6080e7          	jalr	-314(ra) # 80001524 <printf>
    80001666:	bf6d                	j	80001620 <showHistory+0x20>
        }
    }
    exit(0);
    80001668:	4501                	li	a0,0
    8000166a:	fffff097          	auipc	ra,0xfffff
    8000166e:	72e080e7          	jalr	1838(ra) # 80000d98 <exit>
}
    80001672:	60e2                	ld	ra,24(sp)
    80001674:	6442                	ld	s0,16(sp)
    80001676:	64a2                	ld	s1,8(sp)
    80001678:	6902                	ld	s2,0(sp)
    8000167a:	6105                	addi	sp,sp,32
    8000167c:	8082                	ret

000000008000167e <hello>:

void hello()
{
    8000167e:	1141                	addi	sp,sp,-16
    80001680:	e406                	sd	ra,8(sp)
    80001682:	e022                	sd	s0,0(sp)
    80001684:	0800                	addi	s0,sp,16
    puts("Hello, world!\n\t\tfrom startOS with osh");
    80001686:	00004517          	auipc	a0,0x4
    8000168a:	b3250513          	addi	a0,a0,-1230 # 800051b8 <digits+0x20>
    8000168e:	00000097          	auipc	ra,0x0
    80001692:	ecc080e7          	jalr	-308(ra) # 8000155a <puts>
    exit(0);
    80001696:	4501                	li	a0,0
    80001698:	fffff097          	auipc	ra,0xfffff
    8000169c:	700080e7          	jalr	1792(ra) # 80000d98 <exit>
}
    800016a0:	60a2                	ld	ra,8(sp)
    800016a2:	6402                	ld	s0,0(sp)
    800016a4:	0141                	addi	sp,sp,16
    800016a6:	8082                	ret

00000000800016a8 <cowsay>:

void cowsay(){
    800016a8:	1141                	addi	sp,sp,-16
    800016aa:	e406                	sd	ra,8(sp)
    800016ac:	e022                	sd	s0,0(sp)
    800016ae:	0800                	addi	s0,sp,16
    puts("    ____________");
    800016b0:	00004517          	auipc	a0,0x4
    800016b4:	b3050513          	addi	a0,a0,-1232 # 800051e0 <digits+0x48>
    800016b8:	00000097          	auipc	ra,0x0
    800016bc:	ea2080e7          	jalr	-350(ra) # 8000155a <puts>
    puts("    < hi, there >");
    800016c0:	00004517          	auipc	a0,0x4
    800016c4:	b3850513          	addi	a0,a0,-1224 # 800051f8 <digits+0x60>
    800016c8:	00000097          	auipc	ra,0x0
    800016cc:	e92080e7          	jalr	-366(ra) # 8000155a <puts>
    puts("    ------------");
    800016d0:	00004517          	auipc	a0,0x4
    800016d4:	b4050513          	addi	a0,a0,-1216 # 80005210 <digits+0x78>
    800016d8:	00000097          	auipc	ra,0x0
    800016dc:	e82080e7          	jalr	-382(ra) # 8000155a <puts>
    puts("         \\   ^__^");
    800016e0:	00004517          	auipc	a0,0x4
    800016e4:	b4850513          	addi	a0,a0,-1208 # 80005228 <digits+0x90>
    800016e8:	00000097          	auipc	ra,0x0
    800016ec:	e72080e7          	jalr	-398(ra) # 8000155a <puts>
    puts("          \\  (oo)\\_______");
    800016f0:	00004517          	auipc	a0,0x4
    800016f4:	b5050513          	addi	a0,a0,-1200 # 80005240 <digits+0xa8>
    800016f8:	00000097          	auipc	ra,0x0
    800016fc:	e62080e7          	jalr	-414(ra) # 8000155a <puts>
    puts("             (__)\\       )\\/\\");
    80001700:	00004517          	auipc	a0,0x4
    80001704:	b6050513          	addi	a0,a0,-1184 # 80005260 <digits+0xc8>
    80001708:	00000097          	auipc	ra,0x0
    8000170c:	e52080e7          	jalr	-430(ra) # 8000155a <puts>
    puts("                 ||----w |");
    80001710:	00004517          	auipc	a0,0x4
    80001714:	b7050513          	addi	a0,a0,-1168 # 80005280 <digits+0xe8>
    80001718:	00000097          	auipc	ra,0x0
    8000171c:	e42080e7          	jalr	-446(ra) # 8000155a <puts>
    puts("                 ||     ||");
    80001720:	00004517          	auipc	a0,0x4
    80001724:	b8050513          	addi	a0,a0,-1152 # 800052a0 <digits+0x108>
    80001728:	00000097          	auipc	ra,0x0
    8000172c:	e32080e7          	jalr	-462(ra) # 8000155a <puts>
    exit(0);
    80001730:	4501                	li	a0,0
    80001732:	fffff097          	auipc	ra,0xfffff
    80001736:	666080e7          	jalr	1638(ra) # 80000d98 <exit>
}
    8000173a:	60a2                	ld	ra,8(sp)
    8000173c:	6402                	ld	s0,0(sp)
    8000173e:	0141                	addi	sp,sp,16
    80001740:	8082                	ret

0000000080001742 <mew>:

void mew(){
    80001742:	1141                	addi	sp,sp,-16
    80001744:	e406                	sd	ra,8(sp)
    80001746:	e022                	sd	s0,0(sp)
    80001748:	0800                	addi	s0,sp,16
    puts("          ＿＿");
    8000174a:	00004517          	auipc	a0,0x4
    8000174e:	b7650513          	addi	a0,a0,-1162 # 800052c0 <digits+0x128>
    80001752:	00000097          	auipc	ra,0x0
    80001756:	e08080e7          	jalr	-504(ra) # 8000155a <puts>
    puts("　　　／＞　　フ");
    8000175a:	00004517          	auipc	a0,0x4
    8000175e:	b7e50513          	addi	a0,a0,-1154 # 800052d8 <digits+0x140>
    80001762:	00000097          	auipc	ra,0x0
    80001766:	df8080e7          	jalr	-520(ra) # 8000155a <puts>
    puts("　　　|   _　 _ |");
    8000176a:	00004517          	auipc	a0,0x4
    8000176e:	b8e50513          	addi	a0,a0,-1138 # 800052f8 <digits+0x160>
    80001772:	00000097          	auipc	ra,0x0
    80001776:	de8080e7          	jalr	-536(ra) # 8000155a <puts>
    puts("　　／`  ミ＿xノ");
    8000177a:	00004517          	auipc	a0,0x4
    8000177e:	b9650513          	addi	a0,a0,-1130 # 80005310 <digits+0x178>
    80001782:	00000097          	auipc	ra,0x0
    80001786:	dd8080e7          	jalr	-552(ra) # 8000155a <puts>
    puts(" 　 /　　　 　 |");
    8000178a:	00004517          	auipc	a0,0x4
    8000178e:	b9e50513          	addi	a0,a0,-1122 # 80005328 <digits+0x190>
    80001792:	00000097          	auipc	ra,0x0
    80001796:	dc8080e7          	jalr	-568(ra) # 8000155a <puts>
    puts("　 /　 ヽ　　 ﾉ");
    8000179a:	00004517          	auipc	a0,0x4
    8000179e:	ba650513          	addi	a0,a0,-1114 # 80005340 <digits+0x1a8>
    800017a2:	00000097          	auipc	ra,0x0
    800017a6:	db8080e7          	jalr	-584(ra) # 8000155a <puts>
    exit(0);
    800017aa:	4501                	li	a0,0
    800017ac:	fffff097          	auipc	ra,0xfffff
    800017b0:	5ec080e7          	jalr	1516(ra) # 80000d98 <exit>
}
    800017b4:	60a2                	ld	ra,8(sp)
    800017b6:	6402                	ld	s0,0(sp)
    800017b8:	0141                	addi	sp,sp,16
    800017ba:	8082                	ret

00000000800017bc <help>:

void help()
{
    800017bc:	1141                	addi	sp,sp,-16
    800017be:	e406                	sd	ra,8(sp)
    800017c0:	e022                	sd	s0,0(sp)
    800017c2:	0800                	addi	s0,sp,16
    puts("All available commmands:");
    800017c4:	00004517          	auipc	a0,0x4
    800017c8:	b9450513          	addi	a0,a0,-1132 # 80005358 <digits+0x1c0>
    800017cc:	00000097          	auipc	ra,0x0
    800017d0:	d8e080e7          	jalr	-626(ra) # 8000155a <puts>
    puts("help\tshow this helping message");
    800017d4:	00004517          	auipc	a0,0x4
    800017d8:	ba450513          	addi	a0,a0,-1116 # 80005378 <digits+0x1e0>
    800017dc:	00000097          	auipc	ra,0x0
    800017e0:	d7e080e7          	jalr	-642(ra) # 8000155a <puts>
    puts("hello\tprint test hello world message");
    800017e4:	00004517          	auipc	a0,0x4
    800017e8:	bb450513          	addi	a0,a0,-1100 # 80005398 <digits+0x200>
    800017ec:	00000097          	auipc	ra,0x0
    800017f0:	d6e080e7          	jalr	-658(ra) # 8000155a <puts>
    puts("history\tshow recent commands you input");
    800017f4:	00004517          	auipc	a0,0x4
    800017f8:	bcc50513          	addi	a0,a0,-1076 # 800053c0 <digits+0x228>
    800017fc:	00000097          	auipc	ra,0x0
    80001800:	d5e080e7          	jalr	-674(ra) # 8000155a <puts>
    puts("usertests\texec test function");
    80001804:	00004517          	auipc	a0,0x4
    80001808:	be450513          	addi	a0,a0,-1052 # 800053e8 <digits+0x250>
    8000180c:	00000097          	auipc	ra,0x0
    80001810:	d4e080e7          	jalr	-690(ra) # 8000155a <puts>
    puts("cowsay\tcowsay");
    80001814:	00004517          	auipc	a0,0x4
    80001818:	bf450513          	addi	a0,a0,-1036 # 80005408 <digits+0x270>
    8000181c:	00000097          	auipc	ra,0x0
    80001820:	d3e080e7          	jalr	-706(ra) # 8000155a <puts>
    puts("mew\tmew mew");
    80001824:	00004517          	auipc	a0,0x4
    80001828:	bf450513          	addi	a0,a0,-1036 # 80005418 <digits+0x280>
    8000182c:	00000097          	auipc	ra,0x0
    80001830:	d2e080e7          	jalr	-722(ra) # 8000155a <puts>
    exit(0);
    80001834:	4501                	li	a0,0
    80001836:	fffff097          	auipc	ra,0xfffff
    8000183a:	562080e7          	jalr	1378(ra) # 80000d98 <exit>
}
    8000183e:	60a2                	ld	ra,8(sp)
    80001840:	6402                	ld	s0,0(sp)
    80001842:	0141                	addi	sp,sp,16
    80001844:	8082                	ret

0000000080001846 <run>:

void run(uint64 fn)
{
    80001846:	1101                	addi	sp,sp,-32
    80001848:	ec06                	sd	ra,24(sp)
    8000184a:	e822                	sd	s0,16(sp)
    8000184c:	e426                	sd	s1,8(sp)
    8000184e:	1000                	addi	s0,sp,32
    80001850:	84aa                	mv	s1,a0
    if (fork() > 0) {
    80001852:	00000097          	auipc	ra,0x0
    80001856:	91c080e7          	jalr	-1764(ra) # 8000116e <fork>
    8000185a:	00a05c63          	blez	a0,80001872 <run+0x2c>
        wait(0);
    8000185e:	4501                	li	a0,0
    80001860:	fffff097          	auipc	ra,0xfffff
    80001864:	478080e7          	jalr	1144(ra) # 80000cd8 <wait>
    } else {
        exec(fn);
    }
}
    80001868:	60e2                	ld	ra,24(sp)
    8000186a:	6442                	ld	s0,16(sp)
    8000186c:	64a2                	ld	s1,8(sp)
    8000186e:	6105                	addi	sp,sp,32
    80001870:	8082                	ret
        exec(fn);
    80001872:	8526                	mv	a0,s1
    80001874:	fffff097          	auipc	ra,0xfffff
    80001878:	598080e7          	jalr	1432(ra) # 80000e0c <exec>
}
    8000187c:	b7f5                	j	80001868 <run+0x22>

000000008000187e <runcmd>:

void runcmd(char* cmdstr)
{
    8000187e:	1101                	addi	sp,sp,-32
    80001880:	ec06                	sd	ra,24(sp)
    80001882:	e822                	sd	s0,16(sp)
    80001884:	e426                	sd	s1,8(sp)
    80001886:	1000                	addi	s0,sp,32
    80001888:	84aa                	mv	s1,a0
    if (strlen(cmdstr) == 0)
    8000188a:	fffff097          	auipc	ra,0xfffff
    8000188e:	7a2080e7          	jalr	1954(ra) # 8000102c <strlen>
    80001892:	0005079b          	sext.w	a5,a0
    80001896:	e791                	bnez	a5,800018a2 <runcmd+0x24>
        run((uint64)mew);
    else {
        puts("■■No such command.");
        return;
    }
}
    80001898:	60e2                	ld	ra,24(sp)
    8000189a:	6442                	ld	s0,16(sp)
    8000189c:	64a2                	ld	s1,8(sp)
    8000189e:	6105                	addi	sp,sp,32
    800018a0:	8082                	ret
    else if (strcmp(cmdstr, "hello") == 0)
    800018a2:	00004597          	auipc	a1,0x4
    800018a6:	b8658593          	addi	a1,a1,-1146 # 80005428 <digits+0x290>
    800018aa:	8526                	mv	a0,s1
    800018ac:	fffff097          	auipc	ra,0xfffff
    800018b0:	7fc080e7          	jalr	2044(ra) # 800010a8 <strcmp>
    800018b4:	e911                	bnez	a0,800018c8 <runcmd+0x4a>
        run((uint64)hello);
    800018b6:	00000517          	auipc	a0,0x0
    800018ba:	dc850513          	addi	a0,a0,-568 # 8000167e <hello>
    800018be:	00000097          	auipc	ra,0x0
    800018c2:	f88080e7          	jalr	-120(ra) # 80001846 <run>
    800018c6:	bfc9                	j	80001898 <runcmd+0x1a>
    else if (strcmp(cmdstr, "help") == 0)
    800018c8:	00004597          	auipc	a1,0x4
    800018cc:	b6858593          	addi	a1,a1,-1176 # 80005430 <digits+0x298>
    800018d0:	8526                	mv	a0,s1
    800018d2:	fffff097          	auipc	ra,0xfffff
    800018d6:	7d6080e7          	jalr	2006(ra) # 800010a8 <strcmp>
    800018da:	e911                	bnez	a0,800018ee <runcmd+0x70>
        run((uint64)help);
    800018dc:	00000517          	auipc	a0,0x0
    800018e0:	ee050513          	addi	a0,a0,-288 # 800017bc <help>
    800018e4:	00000097          	auipc	ra,0x0
    800018e8:	f62080e7          	jalr	-158(ra) # 80001846 <run>
    800018ec:	b775                	j	80001898 <runcmd+0x1a>
    else if (strcmp(cmdstr, "history") == 0)
    800018ee:	00004597          	auipc	a1,0x4
    800018f2:	b4a58593          	addi	a1,a1,-1206 # 80005438 <digits+0x2a0>
    800018f6:	8526                	mv	a0,s1
    800018f8:	fffff097          	auipc	ra,0xfffff
    800018fc:	7b0080e7          	jalr	1968(ra) # 800010a8 <strcmp>
    80001900:	e911                	bnez	a0,80001914 <runcmd+0x96>
        run((uint64)showHistory);
    80001902:	00000517          	auipc	a0,0x0
    80001906:	cfe50513          	addi	a0,a0,-770 # 80001600 <showHistory>
    8000190a:	00000097          	auipc	ra,0x0
    8000190e:	f3c080e7          	jalr	-196(ra) # 80001846 <run>
    80001912:	b759                	j	80001898 <runcmd+0x1a>
    else if(strcmp(cmdstr, "cowsay") == 0)
    80001914:	00004597          	auipc	a1,0x4
    80001918:	b2c58593          	addi	a1,a1,-1236 # 80005440 <digits+0x2a8>
    8000191c:	8526                	mv	a0,s1
    8000191e:	fffff097          	auipc	ra,0xfffff
    80001922:	78a080e7          	jalr	1930(ra) # 800010a8 <strcmp>
    80001926:	e911                	bnez	a0,8000193a <runcmd+0xbc>
        run((uint64)cowsay);
    80001928:	00000517          	auipc	a0,0x0
    8000192c:	d8050513          	addi	a0,a0,-640 # 800016a8 <cowsay>
    80001930:	00000097          	auipc	ra,0x0
    80001934:	f16080e7          	jalr	-234(ra) # 80001846 <run>
    80001938:	b785                	j	80001898 <runcmd+0x1a>
    else if(strcmp(cmdstr, "mew") == 0)
    8000193a:	00004597          	auipc	a1,0x4
    8000193e:	ae658593          	addi	a1,a1,-1306 # 80005420 <digits+0x288>
    80001942:	8526                	mv	a0,s1
    80001944:	fffff097          	auipc	ra,0xfffff
    80001948:	764080e7          	jalr	1892(ra) # 800010a8 <strcmp>
    8000194c:	e911                	bnez	a0,80001960 <runcmd+0xe2>
        run((uint64)mew);
    8000194e:	00000517          	auipc	a0,0x0
    80001952:	df450513          	addi	a0,a0,-524 # 80001742 <mew>
    80001956:	00000097          	auipc	ra,0x0
    8000195a:	ef0080e7          	jalr	-272(ra) # 80001846 <run>
    8000195e:	bf2d                	j	80001898 <runcmd+0x1a>
        puts("■■No such command.");
    80001960:	00004517          	auipc	a0,0x4
    80001964:	ae850513          	addi	a0,a0,-1304 # 80005448 <digits+0x2b0>
    80001968:	00000097          	auipc	ra,0x0
    8000196c:	bf2080e7          	jalr	-1038(ra) # 8000155a <puts>
        return;
    80001970:	b725                	j	80001898 <runcmd+0x1a>

0000000080001972 <osh>:

int osh()
{
    80001972:	715d                	addi	sp,sp,-80
    80001974:	e486                	sd	ra,72(sp)
    80001976:	e0a2                	sd	s0,64(sp)
    80001978:	0880                	addi	s0,sp,80
    printf("\n==========================Start OS=========================\n");
    8000197a:	00004517          	auipc	a0,0x4
    8000197e:	ae650513          	addi	a0,a0,-1306 # 80005460 <digits+0x2c8>
    80001982:	00000097          	auipc	ra,0x0
    80001986:	ba2080e7          	jalr	-1118(ra) # 80001524 <printf>
    puts("Welcome to startOS! Use following commands to get started.");
    8000198a:	00004517          	auipc	a0,0x4
    8000198e:	b1650513          	addi	a0,a0,-1258 # 800054a0 <digits+0x308>
    80001992:	00000097          	auipc	ra,0x0
    80001996:	bc8080e7          	jalr	-1080(ra) # 8000155a <puts>
    puts("  * hello - print test hello world message");
    8000199a:	00004517          	auipc	a0,0x4
    8000199e:	b4650513          	addi	a0,a0,-1210 # 800054e0 <digits+0x348>
    800019a2:	00000097          	auipc	ra,0x0
    800019a6:	bb8080e7          	jalr	-1096(ra) # 8000155a <puts>
    puts("  * help - list all available commands");
    800019aa:	00004517          	auipc	a0,0x4
    800019ae:	b6650513          	addi	a0,a0,-1178 # 80005510 <digits+0x378>
    800019b2:	00000097          	auipc	ra,0x0
    800019b6:	ba8080e7          	jalr	-1112(ra) # 8000155a <puts>

    char buf[MAX_BUFFER_SIZE];
    h.currentP = 0; //当前指令即将写入的位置
    800019ba:	0004a797          	auipc	a5,0x4a
    800019be:	4207ab23          	sw	zero,1078(a5) # 8004bdf0 <h+0x140>
    800019c2:	a0b9                	j	80001a10 <osh+0x9e>
        printf("osh>> ");
        if (read_line(buf) != 0) {
            if (strcmp(buf, "!!") == 0)
                showHistory();
            else {
                runcmd(buf);
    800019c4:	fb040513          	addi	a0,s0,-80
    800019c8:	00000097          	auipc	ra,0x0
    800019cc:	eb6080e7          	jalr	-330(ra) # 8000187e <runcmd>
                if (h.currentP >= MAX_HISTORY_NUM)
    800019d0:	0004a797          	auipc	a5,0x4a
    800019d4:	4207a783          	lw	a5,1056(a5) # 8004bdf0 <h+0x140>
    800019d8:	4711                	li	a4,4
    800019da:	00f75963          	bge	a4,a5,800019ec <osh+0x7a>
                    h.currentP = h.currentP % MAX_HISTORY_NUM;
    800019de:	4715                	li	a4,5
    800019e0:	02e7e7bb          	remw	a5,a5,a4
    800019e4:	0004a717          	auipc	a4,0x4a
    800019e8:	40f72623          	sw	a5,1036(a4) # 8004bdf0 <h+0x140>
                strcpy(h.cmdlist[h.currentP++], buf);
    800019ec:	0004a517          	auipc	a0,0x4a
    800019f0:	2c450513          	addi	a0,a0,708 # 8004bcb0 <h>
    800019f4:	14052783          	lw	a5,320(a0)
    800019f8:	0017871b          	addiw	a4,a5,1
    800019fc:	14e52023          	sw	a4,320(a0)
    80001a00:	079a                	slli	a5,a5,0x6
    80001a02:	fb040593          	addi	a1,s0,-80
    80001a06:	953e                	add	a0,a0,a5
    80001a08:	fffff097          	auipc	ra,0xfffff
    80001a0c:	642080e7          	jalr	1602(ra) # 8000104a <strcpy>
        printf("osh>> ");
    80001a10:	00004517          	auipc	a0,0x4
    80001a14:	b2850513          	addi	a0,a0,-1240 # 80005538 <digits+0x3a0>
    80001a18:	00000097          	auipc	ra,0x0
    80001a1c:	b0c080e7          	jalr	-1268(ra) # 80001524 <printf>
        if (read_line(buf) != 0) {
    80001a20:	fb040513          	addi	a0,s0,-80
    80001a24:	fffff097          	auipc	ra,0xfffff
    80001a28:	83e080e7          	jalr	-1986(ra) # 80000262 <read_line>
    80001a2c:	d175                	beqz	a0,80001a10 <osh+0x9e>
            if (strcmp(buf, "!!") == 0)
    80001a2e:	00004597          	auipc	a1,0x4
    80001a32:	b1258593          	addi	a1,a1,-1262 # 80005540 <digits+0x3a8>
    80001a36:	fb040513          	addi	a0,s0,-80
    80001a3a:	fffff097          	auipc	ra,0xfffff
    80001a3e:	66e080e7          	jalr	1646(ra) # 800010a8 <strcmp>
    80001a42:	f149                	bnez	a0,800019c4 <osh+0x52>
                showHistory();
    80001a44:	00000097          	auipc	ra,0x0
    80001a48:	bbc080e7          	jalr	-1092(ra) # 80001600 <showHistory>
    80001a4c:	b7d1                	j	80001a10 <osh+0x9e>

0000000080001a4e <kfree>:
}


// 释放一页pa指向的物理空间
void kfree(void *pa)
{
    80001a4e:	1101                	addi	sp,sp,-32
    80001a50:	ec06                	sd	ra,24(sp)
    80001a52:	e822                	sd	s0,16(sp)
    80001a54:	e426                	sd	s1,8(sp)
    80001a56:	e04a                	sd	s2,0(sp)
    80001a58:	1000                	addi	s0,sp,32
    80001a5a:	84aa                	mv	s1,a0
    struct node *r;

    if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80001a5c:	6785                	lui	a5,0x1
    80001a5e:	17fd                	addi	a5,a5,-1
    80001a60:	8fe9                	and	a5,a5,a0
    80001a62:	eb99                	bnez	a5,80001a78 <kfree+0x2a>
    80001a64:	0006a797          	auipc	a5,0x6a
    80001a68:	fb478793          	addi	a5,a5,-76 # 8006ba18 <end>
    80001a6c:	00f56663          	bltu	a0,a5,80001a78 <kfree+0x2a>
    80001a70:	47c5                	li	a5,17
    80001a72:	07ee                	slli	a5,a5,0x1b
    80001a74:	00f56a63          	bltu	a0,a5,80001a88 <kfree+0x3a>
        panic("kfree");
    80001a78:	00004517          	auipc	a0,0x4
    80001a7c:	ad050513          	addi	a0,a0,-1328 # 80005548 <digits+0x3b0>
    80001a80:	00000097          	auipc	ra,0x0
    80001a84:	b5c080e7          	jalr	-1188(ra) # 800015dc <panic>

    // 填充无效值
    memset(pa, 1, PGSIZE);
    80001a88:	6605                	lui	a2,0x1
    80001a8a:	4585                	li	a1,1
    80001a8c:	8526                	mv	a0,s1
    80001a8e:	fffff097          	auipc	ra,0xfffff
    80001a92:	534080e7          	jalr	1332(ra) # 80000fc2 <memset>

    r = (struct node*)pa;

    spin_lock(&kmem.lock);
    80001a96:	0004a917          	auipc	s2,0x4a
    80001a9a:	36290913          	addi	s2,s2,866 # 8004bdf8 <kmem>
    80001a9e:	854a                	mv	a0,s2
    80001aa0:	00002097          	auipc	ra,0x2
    80001aa4:	d9e080e7          	jalr	-610(ra) # 8000383e <spin_lock>
    r->next = kmem.freelist;
    80001aa8:	01893783          	ld	a5,24(s2)
    80001aac:	e09c                	sd	a5,0(s1)
    kmem.freelist = r;
    80001aae:	00993c23          	sd	s1,24(s2)
    spin_unlock(&kmem.lock);
    80001ab2:	854a                	mv	a0,s2
    80001ab4:	00002097          	auipc	ra,0x2
    80001ab8:	e5c080e7          	jalr	-420(ra) # 80003910 <spin_unlock>
}
    80001abc:	60e2                	ld	ra,24(sp)
    80001abe:	6442                	ld	s0,16(sp)
    80001ac0:	64a2                	ld	s1,8(sp)
    80001ac2:	6902                	ld	s2,0(sp)
    80001ac4:	6105                	addi	sp,sp,32
    80001ac6:	8082                	ret

0000000080001ac8 <free_range>:
{
    80001ac8:	1101                	addi	sp,sp,-32
    80001aca:	ec06                	sd	ra,24(sp)
    80001acc:	e822                	sd	s0,16(sp)
    80001ace:	e426                	sd	s1,8(sp)
    80001ad0:	e04a                	sd	s2,0(sp)
    80001ad2:	1000                	addi	s0,sp,32
    80001ad4:	892e                	mv	s2,a1
    p = (char*)PGROUNDUP((uint64)pa_start);
    80001ad6:	6785                	lui	a5,0x1
    80001ad8:	17fd                	addi	a5,a5,-1
    80001ada:	953e                	add	a0,a0,a5
    80001adc:	77fd                	lui	a5,0xfffff
    80001ade:	8d7d                	and	a0,a0,a5
    for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80001ae0:	6485                	lui	s1,0x1
    80001ae2:	94aa                	add	s1,s1,a0
    80001ae4:	00996863          	bltu	s2,s1,80001af4 <free_range+0x2c>
        kfree(p);
    80001ae8:	00000097          	auipc	ra,0x0
    80001aec:	f66080e7          	jalr	-154(ra) # 80001a4e <kfree>
    for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80001af0:	8526                	mv	a0,s1
    80001af2:	b7fd                	j	80001ae0 <free_range+0x18>
}
    80001af4:	60e2                	ld	ra,24(sp)
    80001af6:	6442                	ld	s0,16(sp)
    80001af8:	64a2                	ld	s1,8(sp)
    80001afa:	6902                	ld	s2,0(sp)
    80001afc:	6105                	addi	sp,sp,32
    80001afe:	8082                	ret

0000000080001b00 <kernel_mem_init>:
{
    80001b00:	1141                	addi	sp,sp,-16
    80001b02:	e406                	sd	ra,8(sp)
    80001b04:	e022                	sd	s0,0(sp)
    80001b06:	0800                	addi	s0,sp,16
    spinlock_init(&kmem.lock, "kmem");
    80001b08:	00004597          	auipc	a1,0x4
    80001b0c:	a4858593          	addi	a1,a1,-1464 # 80005550 <digits+0x3b8>
    80001b10:	0004a517          	auipc	a0,0x4a
    80001b14:	2e850513          	addi	a0,a0,744 # 8004bdf8 <kmem>
    80001b18:	00002097          	auipc	ra,0x2
    80001b1c:	c92080e7          	jalr	-878(ra) # 800037aa <spinlock_init>
    free_range(end, (void*)PHYSTOP);
    80001b20:	45c5                	li	a1,17
    80001b22:	05ee                	slli	a1,a1,0x1b
    80001b24:	0006a517          	auipc	a0,0x6a
    80001b28:	ef450513          	addi	a0,a0,-268 # 8006ba18 <end>
    80001b2c:	00000097          	auipc	ra,0x0
    80001b30:	f9c080e7          	jalr	-100(ra) # 80001ac8 <free_range>
}
    80001b34:	60a2                	ld	ra,8(sp)
    80001b36:	6402                	ld	s0,0(sp)
    80001b38:	0141                	addi	sp,sp,16
    80001b3a:	8082                	ret

0000000080001b3c <kalloc>:

// 分配一个4096字节的物理页，返回内核能够使用的指针, 如果
// 内存耗尽会返回0。
void * kalloc(void)
{
    80001b3c:	1101                	addi	sp,sp,-32
    80001b3e:	ec06                	sd	ra,24(sp)
    80001b40:	e822                	sd	s0,16(sp)
    80001b42:	e426                	sd	s1,8(sp)
    80001b44:	1000                	addi	s0,sp,32
    struct node *r;

    spin_lock(&kmem.lock);
    80001b46:	0004a497          	auipc	s1,0x4a
    80001b4a:	2b248493          	addi	s1,s1,690 # 8004bdf8 <kmem>
    80001b4e:	8526                	mv	a0,s1
    80001b50:	00002097          	auipc	ra,0x2
    80001b54:	cee080e7          	jalr	-786(ra) # 8000383e <spin_lock>
    r = kmem.freelist;
    80001b58:	6c84                	ld	s1,24(s1)
    if(r)
    80001b5a:	c491                	beqz	s1,80001b66 <kalloc+0x2a>
        kmem.freelist = r->next;
    80001b5c:	609c                	ld	a5,0(s1)
    80001b5e:	0004a717          	auipc	a4,0x4a
    80001b62:	2af73923          	sd	a5,690(a4) # 8004be10 <kmem+0x18>
    spin_unlock(&kmem.lock);
    80001b66:	0004a517          	auipc	a0,0x4a
    80001b6a:	29250513          	addi	a0,a0,658 # 8004bdf8 <kmem>
    80001b6e:	00002097          	auipc	ra,0x2
    80001b72:	da2080e7          	jalr	-606(ra) # 80003910 <spin_unlock>

    if(r)
    80001b76:	c881                	beqz	s1,80001b86 <kalloc+0x4a>
        memset((char*)r, 5, PGSIZE); // fill with junk
    80001b78:	6605                	lui	a2,0x1
    80001b7a:	4595                	li	a1,5
    80001b7c:	8526                	mv	a0,s1
    80001b7e:	fffff097          	auipc	ra,0xfffff
    80001b82:	444080e7          	jalr	1092(ra) # 80000fc2 <memset>
    return (void*)r;
}
    80001b86:	8526                	mv	a0,s1
    80001b88:	60e2                	ld	ra,24(sp)
    80001b8a:	6442                	ld	s0,16(sp)
    80001b8c:	64a2                	ld	s1,8(sp)
    80001b8e:	6105                	addi	sp,sp,32
    80001b90:	8082                	ret

0000000080001b92 <vm_hart_init>:
}

/**
 * 切换页表寄存器为内核页表并启用分页
 */
void vm_hart_init() {
    80001b92:	1141                	addi	sp,sp,-16
    80001b94:	e422                	sd	s0,8(sp)
    80001b96:	0800                	addi	s0,sp,16
    w_satp(MAKE_SATP(kernel_pagetable));
    80001b98:	00004797          	auipc	a5,0x4
    80001b9c:	4887b783          	ld	a5,1160(a5) # 80006020 <kernel_pagetable>
    80001ba0:	83b1                	srli	a5,a5,0xc
    80001ba2:	577d                	li	a4,-1
    80001ba4:	177e                	slli	a4,a4,0x3f
    80001ba6:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80001ba8:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80001bac:	12000073          	sfence.vma
    sfence_vma();
}
    80001bb0:	6422                	ld	s0,8(sp)
    80001bb2:	0141                	addi	sp,sp,16
    80001bb4:	8082                	ret

0000000080001bb6 <walk>:
 * @param pagetable 页表
 * @param va 需要查找PTE的va
 * @param alloc 是否创建缺失的页表
 * @return
 */
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc) {
    80001bb6:	7139                	addi	sp,sp,-64
    80001bb8:	fc06                	sd	ra,56(sp)
    80001bba:	f822                	sd	s0,48(sp)
    80001bbc:	f426                	sd	s1,40(sp)
    80001bbe:	f04a                	sd	s2,32(sp)
    80001bc0:	ec4e                	sd	s3,24(sp)
    80001bc2:	e852                	sd	s4,16(sp)
    80001bc4:	e456                	sd	s5,8(sp)
    80001bc6:	0080                	addi	s0,sp,64
    80001bc8:	892a                	mv	s2,a0
    80001bca:	89ae                	mv	s3,a1
    80001bcc:	8ab2                	mv	s5,a2
    if (va >= MAXVA)
    80001bce:	57fd                	li	a5,-1
    80001bd0:	83e9                	srli	a5,a5,0x1a
    80001bd2:	00b7e463          	bltu	a5,a1,80001bda <walk+0x24>
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc) {
    80001bd6:	4a09                	li	s4,2
    80001bd8:	a83d                	j	80001c16 <walk+0x60>
        panic("walk");
    80001bda:	00004517          	auipc	a0,0x4
    80001bde:	97e50513          	addi	a0,a0,-1666 # 80005558 <digits+0x3c0>
    80001be2:	00000097          	auipc	ra,0x0
    80001be6:	9fa080e7          	jalr	-1542(ra) # 800015dc <panic>
    80001bea:	b7f5                	j	80001bd6 <walk+0x20>
    for (int level = 2; level > 0; level--) {
        pte_t *pte = &pagetable[PX(level, va)];
        if (*pte & PTE_V) {
            pagetable = (pagetable_t) PTE2PA(*pte);
        } else {
            if (!alloc || (pagetable = (pte_t *) kalloc()) == 0)
    80001bec:	040a8b63          	beqz	s5,80001c42 <walk+0x8c>
    80001bf0:	00000097          	auipc	ra,0x0
    80001bf4:	f4c080e7          	jalr	-180(ra) # 80001b3c <kalloc>
    80001bf8:	892a                	mv	s2,a0
    80001bfa:	c521                	beqz	a0,80001c42 <walk+0x8c>
                return 0;
            memset(pagetable, 0, PGSIZE);
    80001bfc:	6605                	lui	a2,0x1
    80001bfe:	4581                	li	a1,0
    80001c00:	fffff097          	auipc	ra,0xfffff
    80001c04:	3c2080e7          	jalr	962(ra) # 80000fc2 <memset>
            *pte = PA2PTE(pagetable) | PTE_V;
    80001c08:	00c95793          	srli	a5,s2,0xc
    80001c0c:	07aa                	slli	a5,a5,0xa
    80001c0e:	0017e793          	ori	a5,a5,1
    80001c12:	e09c                	sd	a5,0(s1)
    for (int level = 2; level > 0; level--) {
    80001c14:	3a7d                	addiw	s4,s4,-1
    80001c16:	03405863          	blez	s4,80001c46 <walk+0x90>
        pte_t *pte = &pagetable[PX(level, va)];
    80001c1a:	003a149b          	slliw	s1,s4,0x3
    80001c1e:	014484bb          	addw	s1,s1,s4
    80001c22:	24b1                	addiw	s1,s1,12
    80001c24:	0099d4b3          	srl	s1,s3,s1
    80001c28:	1ff4f493          	andi	s1,s1,511
    80001c2c:	048e                	slli	s1,s1,0x3
    80001c2e:	94ca                	add	s1,s1,s2
        if (*pte & PTE_V) {
    80001c30:	0004b903          	ld	s2,0(s1)
    80001c34:	00197793          	andi	a5,s2,1
    80001c38:	dbd5                	beqz	a5,80001bec <walk+0x36>
            pagetable = (pagetable_t) PTE2PA(*pte);
    80001c3a:	00a95913          	srli	s2,s2,0xa
    80001c3e:	0932                	slli	s2,s2,0xc
    80001c40:	bfd1                	j	80001c14 <walk+0x5e>
                return 0;
    80001c42:	4501                	li	a0,0
    80001c44:	a039                	j	80001c52 <walk+0x9c>
        }
    }
    return &pagetable[PX(0, va)];
    80001c46:	00c9d513          	srli	a0,s3,0xc
    80001c4a:	1ff57513          	andi	a0,a0,511
    80001c4e:	050e                	slli	a0,a0,0x3
    80001c50:	954a                	add	a0,a0,s2
}
    80001c52:	70e2                	ld	ra,56(sp)
    80001c54:	7442                	ld	s0,48(sp)
    80001c56:	74a2                	ld	s1,40(sp)
    80001c58:	7902                	ld	s2,32(sp)
    80001c5a:	69e2                	ld	s3,24(sp)
    80001c5c:	6a42                	ld	s4,16(sp)
    80001c5e:	6aa2                	ld	s5,8(sp)
    80001c60:	6121                	addi	sp,sp,64
    80001c62:	8082                	ret

0000000080001c64 <mappages>:
 * @param va 虚拟地址起始地址
 * @param sz 要映射地址的大小
 * @param pa 物理地址的起始地址
 * @param perm PTE的权限
*/
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm) {
    80001c64:	7139                	addi	sp,sp,-64
    80001c66:	fc06                	sd	ra,56(sp)
    80001c68:	f822                	sd	s0,48(sp)
    80001c6a:	f426                	sd	s1,40(sp)
    80001c6c:	f04a                	sd	s2,32(sp)
    80001c6e:	ec4e                	sd	s3,24(sp)
    80001c70:	e852                	sd	s4,16(sp)
    80001c72:	e456                	sd	s5,8(sp)
    80001c74:	e05a                	sd	s6,0(sp)
    80001c76:	0080                	addi	s0,sp,64
    80001c78:	8aaa                	mv	s5,a0
    80001c7a:	89b6                	mv	s3,a3
    80001c7c:	8b3a                	mv	s6,a4
    uint64 a, last;
    pte_t *pte;

    a = PGROUNDDOWN(va);
    80001c7e:	77fd                	lui	a5,0xfffff
    80001c80:	00f5f933          	and	s2,a1,a5
    last = PGROUNDDOWN(va + size - 1);
    80001c84:	00c58a33          	add	s4,a1,a2
    80001c88:	1a7d                	addi	s4,s4,-1
    80001c8a:	00fa7a33          	and	s4,s4,a5
    80001c8e:	a035                	j	80001cba <mappages+0x56>
    for (;;) {
        if ((pte = walk(pagetable, a, 1)) == 0)
            return -1;
        if (*pte & PTE_V)
            panic("remap");
    80001c90:	00004517          	auipc	a0,0x4
    80001c94:	8d050513          	addi	a0,a0,-1840 # 80005560 <digits+0x3c8>
    80001c98:	00000097          	auipc	ra,0x0
    80001c9c:	944080e7          	jalr	-1724(ra) # 800015dc <panic>
        *pte = PA2PTE(pa) | perm | PTE_V;
    80001ca0:	00c9d793          	srli	a5,s3,0xc
    80001ca4:	07aa                	slli	a5,a5,0xa
    80001ca6:	00fb67b3          	or	a5,s6,a5
    80001caa:	0017e793          	ori	a5,a5,1
    80001cae:	e09c                	sd	a5,0(s1)
        if (a == last) {
    80001cb0:	03490d63          	beq	s2,s4,80001cea <mappages+0x86>
            break;
        }
        a += PGSIZE;
    80001cb4:	6785                	lui	a5,0x1
    80001cb6:	993e                	add	s2,s2,a5
        pa += PGSIZE;
    80001cb8:	99be                	add	s3,s3,a5
        if ((pte = walk(pagetable, a, 1)) == 0)
    80001cba:	4605                	li	a2,1
    80001cbc:	85ca                	mv	a1,s2
    80001cbe:	8556                	mv	a0,s5
    80001cc0:	00000097          	auipc	ra,0x0
    80001cc4:	ef6080e7          	jalr	-266(ra) # 80001bb6 <walk>
    80001cc8:	84aa                	mv	s1,a0
    80001cca:	c509                	beqz	a0,80001cd4 <mappages+0x70>
        if (*pte & PTE_V)
    80001ccc:	611c                	ld	a5,0(a0)
    80001cce:	8b85                	andi	a5,a5,1
    80001cd0:	dbe1                	beqz	a5,80001ca0 <mappages+0x3c>
    80001cd2:	bf7d                	j	80001c90 <mappages+0x2c>
            return -1;
    80001cd4:	557d                	li	a0,-1
    }
    return 0;
}
    80001cd6:	70e2                	ld	ra,56(sp)
    80001cd8:	7442                	ld	s0,48(sp)
    80001cda:	74a2                	ld	s1,40(sp)
    80001cdc:	7902                	ld	s2,32(sp)
    80001cde:	69e2                	ld	s3,24(sp)
    80001ce0:	6a42                	ld	s4,16(sp)
    80001ce2:	6aa2                	ld	s5,8(sp)
    80001ce4:	6b02                	ld	s6,0(sp)
    80001ce6:	6121                	addi	sp,sp,64
    80001ce8:	8082                	ret
    return 0;
    80001cea:	4501                	li	a0,0
    80001cec:	b7ed                	j	80001cd6 <mappages+0x72>

0000000080001cee <walkaddr>:
 */
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
    pte_t *pte;
    uint64 pa;

    if (va >= MAXVA)
    80001cee:	57fd                	li	a5,-1
    80001cf0:	83e9                	srli	a5,a5,0x1a
    80001cf2:	00b7f463          	bgeu	a5,a1,80001cfa <walkaddr+0xc>
        return 0;
    80001cf6:	4501                	li	a0,0
    // TODO 用户空间时修改
//    if ((*pte & PTE_U) == 0)
//        return 0;
    pa = PTE2PA(*pte);
    return pa;
}
    80001cf8:	8082                	ret
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
    80001cfa:	1141                	addi	sp,sp,-16
    80001cfc:	e406                	sd	ra,8(sp)
    80001cfe:	e022                	sd	s0,0(sp)
    80001d00:	0800                	addi	s0,sp,16
    pte = walk(pagetable, va, 0);
    80001d02:	4601                	li	a2,0
    80001d04:	00000097          	auipc	ra,0x0
    80001d08:	eb2080e7          	jalr	-334(ra) # 80001bb6 <walk>
    if (pte == 0)
    80001d0c:	cd01                	beqz	a0,80001d24 <walkaddr+0x36>
    if ((*pte & PTE_V) == 0)
    80001d0e:	611c                	ld	a5,0(a0)
    80001d10:	0017f513          	andi	a0,a5,1
    80001d14:	c501                	beqz	a0,80001d1c <walkaddr+0x2e>
    pa = PTE2PA(*pte);
    80001d16:	00a7d513          	srli	a0,a5,0xa
    80001d1a:	0532                	slli	a0,a0,0xc
}
    80001d1c:	60a2                	ld	ra,8(sp)
    80001d1e:	6402                	ld	s0,0(sp)
    80001d20:	0141                	addi	sp,sp,16
    80001d22:	8082                	ret
        return 0;
    80001d24:	4501                	li	a0,0
    80001d26:	bfdd                	j	80001d1c <walkaddr+0x2e>

0000000080001d28 <kernel_vm_map>:
 * 添加虚拟地址和物理地址的映射到内核页表，只会在
 * 启动的过程中使用，在调用该函数时还没有flush TLB
 * 也没有启用分页。
 *
 */
void kernel_vm_map(uint64 va, uint64 pa, uint64 sz, int perm) {
    80001d28:	1141                	addi	sp,sp,-16
    80001d2a:	e406                	sd	ra,8(sp)
    80001d2c:	e022                	sd	s0,0(sp)
    80001d2e:	0800                	addi	s0,sp,16
    80001d30:	8736                	mv	a4,a3
    if (mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    80001d32:	86ae                	mv	a3,a1
    80001d34:	85aa                	mv	a1,a0
    80001d36:	00004517          	auipc	a0,0x4
    80001d3a:	2ea53503          	ld	a0,746(a0) # 80006020 <kernel_pagetable>
    80001d3e:	00000097          	auipc	ra,0x0
    80001d42:	f26080e7          	jalr	-218(ra) # 80001c64 <mappages>
    80001d46:	e509                	bnez	a0,80001d50 <kernel_vm_map+0x28>
        panic("kvmmap");
}
    80001d48:	60a2                	ld	ra,8(sp)
    80001d4a:	6402                	ld	s0,0(sp)
    80001d4c:	0141                	addi	sp,sp,16
    80001d4e:	8082                	ret
        panic("kvmmap");
    80001d50:	00004517          	auipc	a0,0x4
    80001d54:	81850513          	addi	a0,a0,-2024 # 80005568 <digits+0x3d0>
    80001d58:	00000097          	auipc	ra,0x0
    80001d5c:	884080e7          	jalr	-1916(ra) # 800015dc <panic>
}
    80001d60:	b7e5                	j	80001d48 <kernel_vm_map+0x20>

0000000080001d62 <kernel_vm_init>:
void kernel_vm_init() {
    80001d62:	1101                	addi	sp,sp,-32
    80001d64:	ec06                	sd	ra,24(sp)
    80001d66:	e822                	sd	s0,16(sp)
    80001d68:	e426                	sd	s1,8(sp)
    80001d6a:	1000                	addi	s0,sp,32
    kernel_pagetable = (pagetable_t) kalloc();
    80001d6c:	00000097          	auipc	ra,0x0
    80001d70:	dd0080e7          	jalr	-560(ra) # 80001b3c <kalloc>
    80001d74:	00004797          	auipc	a5,0x4
    80001d78:	2aa7b623          	sd	a0,684(a5) # 80006020 <kernel_pagetable>
    memset(kernel_pagetable, 0, PGSIZE);
    80001d7c:	6605                	lui	a2,0x1
    80001d7e:	4581                	li	a1,0
    80001d80:	fffff097          	auipc	ra,0xfffff
    80001d84:	242080e7          	jalr	578(ra) # 80000fc2 <memset>
    kernel_vm_map(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001d88:	4699                	li	a3,6
    80001d8a:	6605                	lui	a2,0x1
    80001d8c:	100005b7          	lui	a1,0x10000
    80001d90:	10000537          	lui	a0,0x10000
    80001d94:	00000097          	auipc	ra,0x0
    80001d98:	f94080e7          	jalr	-108(ra) # 80001d28 <kernel_vm_map>
    kernel_vm_map(VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001d9c:	4699                	li	a3,6
    80001d9e:	6605                	lui	a2,0x1
    80001da0:	100015b7          	lui	a1,0x10001
    80001da4:	10001537          	lui	a0,0x10001
    80001da8:	00000097          	auipc	ra,0x0
    80001dac:	f80080e7          	jalr	-128(ra) # 80001d28 <kernel_vm_map>
    kernel_vm_map(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    80001db0:	4699                	li	a3,6
    80001db2:	6641                	lui	a2,0x10
    80001db4:	020005b7          	lui	a1,0x2000
    80001db8:	02000537          	lui	a0,0x2000
    80001dbc:	00000097          	auipc	ra,0x0
    80001dc0:	f6c080e7          	jalr	-148(ra) # 80001d28 <kernel_vm_map>
    kernel_vm_map(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001dc4:	4699                	li	a3,6
    80001dc6:	00400637          	lui	a2,0x400
    80001dca:	0c0005b7          	lui	a1,0xc000
    80001dce:	0c000537          	lui	a0,0xc000
    80001dd2:	00000097          	auipc	ra,0x0
    80001dd6:	f56080e7          	jalr	-170(ra) # 80001d28 <kernel_vm_map>
    kernel_vm_map(KERNBASE, KERNBASE, (uint64) etext - KERNBASE, PTE_R | PTE_X);
    80001dda:	00003497          	auipc	s1,0x3
    80001dde:	22648493          	addi	s1,s1,550 # 80005000 <etext>
    80001de2:	46a9                	li	a3,10
    80001de4:	80003617          	auipc	a2,0x80003
    80001de8:	21c60613          	addi	a2,a2,540 # 5000 <_entry-0x7fffb000>
    80001dec:	4585                	li	a1,1
    80001dee:	05fe                	slli	a1,a1,0x1f
    80001df0:	852e                	mv	a0,a1
    80001df2:	00000097          	auipc	ra,0x0
    80001df6:	f36080e7          	jalr	-202(ra) # 80001d28 <kernel_vm_map>
    kernel_vm_map((uint64) etext, (uint64) etext, PHYSTOP - (uint64) etext, PTE_R | PTE_W);
    80001dfa:	4699                	li	a3,6
    80001dfc:	4645                	li	a2,17
    80001dfe:	066e                	slli	a2,a2,0x1b
    80001e00:	8e05                	sub	a2,a2,s1
    80001e02:	85a6                	mv	a1,s1
    80001e04:	8526                	mv	a0,s1
    80001e06:	00000097          	auipc	ra,0x0
    80001e0a:	f22080e7          	jalr	-222(ra) # 80001d28 <kernel_vm_map>
    kernel_vm_map(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001e0e:	46a9                	li	a3,10
    80001e10:	6605                	lui	a2,0x1
    80001e12:	00002597          	auipc	a1,0x2
    80001e16:	1ee58593          	addi	a1,a1,494 # 80004000 <_trampoline>
    80001e1a:	04000537          	lui	a0,0x4000
    80001e1e:	157d                	addi	a0,a0,-1
    80001e20:	0532                	slli	a0,a0,0xc
    80001e22:	00000097          	auipc	ra,0x0
    80001e26:	f06080e7          	jalr	-250(ra) # 80001d28 <kernel_vm_map>
}
    80001e2a:	60e2                	ld	ra,24(sp)
    80001e2c:	6442                	ld	s0,16(sp)
    80001e2e:	64a2                	ld	s1,8(sp)
    80001e30:	6105                	addi	sp,sp,32
    80001e32:	8082                	ret

0000000080001e34 <user_vm_alloc>:
 * @return
 */
uint64 user_vm_alloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz) {
    char *mem;
    uint64 a;
    if (newsz < oldsz)
    80001e34:	06b66d63          	bltu	a2,a1,80001eae <user_vm_alloc+0x7a>
uint64 user_vm_alloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz) {
    80001e38:	7179                	addi	sp,sp,-48
    80001e3a:	f406                	sd	ra,40(sp)
    80001e3c:	f022                	sd	s0,32(sp)
    80001e3e:	ec26                	sd	s1,24(sp)
    80001e40:	e84a                	sd	s2,16(sp)
    80001e42:	e44e                	sd	s3,8(sp)
    80001e44:	e052                	sd	s4,0(sp)
    80001e46:	1800                	addi	s0,sp,48
    80001e48:	8a2a                	mv	s4,a0
    80001e4a:	89b2                	mv	s3,a2
        return oldsz;

    oldsz = PGROUNDUP(oldsz);
    80001e4c:	6905                	lui	s2,0x1
    80001e4e:	197d                	addi	s2,s2,-1
    80001e50:	992e                	add	s2,s2,a1
    80001e52:	77fd                	lui	a5,0xfffff
    80001e54:	00f97933          	and	s2,s2,a5
    for (a = oldsz; a < newsz; a += PGSIZE) {
    80001e58:	a019                	j	80001e5e <user_vm_alloc+0x2a>
    80001e5a:	6785                	lui	a5,0x1
    80001e5c:	993e                	add	s2,s2,a5
    80001e5e:	03397f63          	bgeu	s2,s3,80001e9c <user_vm_alloc+0x68>
        mem = kalloc();
    80001e62:	00000097          	auipc	ra,0x0
    80001e66:	cda080e7          	jalr	-806(ra) # 80001b3c <kalloc>
    80001e6a:	84aa                	mv	s1,a0
        if (mem == 0) {
    80001e6c:	c139                	beqz	a0,80001eb2 <user_vm_alloc+0x7e>
//            uvmdealloc(pagetable, a, oldsz);
            // TODO 失败释放
            return 0;
        }
        memset(mem, 0, PGSIZE);
    80001e6e:	6605                	lui	a2,0x1
    80001e70:	4581                	li	a1,0
    80001e72:	fffff097          	auipc	ra,0xfffff
    80001e76:	150080e7          	jalr	336(ra) # 80000fc2 <memset>
        if (mappages(pagetable, a, PGSIZE, (uint64) mem, PTE_W | PTE_X | PTE_R) != 0) {
    80001e7a:	4739                	li	a4,14
    80001e7c:	86a6                	mv	a3,s1
    80001e7e:	6605                	lui	a2,0x1
    80001e80:	85ca                	mv	a1,s2
    80001e82:	8552                	mv	a0,s4
    80001e84:	00000097          	auipc	ra,0x0
    80001e88:	de0080e7          	jalr	-544(ra) # 80001c64 <mappages>
    80001e8c:	d579                	beqz	a0,80001e5a <user_vm_alloc+0x26>
            kfree(mem);
    80001e8e:	8526                	mv	a0,s1
    80001e90:	00000097          	auipc	ra,0x0
    80001e94:	bbe080e7          	jalr	-1090(ra) # 80001a4e <kfree>
//            uvmdealloc(pagetable, a, oldsz);
            // TODO 失败释放
            return 0;
    80001e98:	4501                	li	a0,0
    80001e9a:	a011                	j	80001e9e <user_vm_alloc+0x6a>
        }
    }
    return newsz;
    80001e9c:	854e                	mv	a0,s3
}
    80001e9e:	70a2                	ld	ra,40(sp)
    80001ea0:	7402                	ld	s0,32(sp)
    80001ea2:	64e2                	ld	s1,24(sp)
    80001ea4:	6942                	ld	s2,16(sp)
    80001ea6:	69a2                	ld	s3,8(sp)
    80001ea8:	6a02                	ld	s4,0(sp)
    80001eaa:	6145                	addi	sp,sp,48
    80001eac:	8082                	ret
        return oldsz;
    80001eae:	852e                	mv	a0,a1
}
    80001eb0:	8082                	ret
            return 0;
    80001eb2:	4501                	li	a0,0
    80001eb4:	b7ed                	j	80001e9e <user_vm_alloc+0x6a>

0000000080001eb6 <user_vm_create>:
/**
 * 创建空的用户页表
 * 失败返回0
 * @return
 */
pagetable_t user_vm_create() {
    80001eb6:	1101                	addi	sp,sp,-32
    80001eb8:	ec06                	sd	ra,24(sp)
    80001eba:	e822                	sd	s0,16(sp)
    80001ebc:	e426                	sd	s1,8(sp)
    80001ebe:	1000                	addi	s0,sp,32
    pagetable_t pagetable;
    pagetable = (pagetable_t) kalloc();
    80001ec0:	00000097          	auipc	ra,0x0
    80001ec4:	c7c080e7          	jalr	-900(ra) # 80001b3c <kalloc>
    80001ec8:	84aa                	mv	s1,a0
    if (pagetable == 0)
    80001eca:	c519                	beqz	a0,80001ed8 <user_vm_create+0x22>
        return 0;
    memset(pagetable, 0, PGSIZE);
    80001ecc:	6605                	lui	a2,0x1
    80001ece:	4581                	li	a1,0
    80001ed0:	fffff097          	auipc	ra,0xfffff
    80001ed4:	0f2080e7          	jalr	242(ra) # 80000fc2 <memset>
    return pagetable;
}
    80001ed8:	8526                	mv	a0,s1
    80001eda:	60e2                	ld	ra,24(sp)
    80001edc:	6442                	ld	s0,16(sp)
    80001ede:	64a2                	ld	s1,8(sp)
    80001ee0:	6105                	addi	sp,sp,32
    80001ee2:	8082                	ret

0000000080001ee4 <vmprint>:

void vmprint(pagetable_t pagetable, int n)
{
    80001ee4:	7139                	addi	sp,sp,-64
    80001ee6:	fc06                	sd	ra,56(sp)
    80001ee8:	f822                	sd	s0,48(sp)
    80001eea:	f426                	sd	s1,40(sp)
    80001eec:	f04a                	sd	s2,32(sp)
    80001eee:	ec4e                	sd	s3,24(sp)
    80001ef0:	e852                	sd	s4,16(sp)
    80001ef2:	e456                	sd	s5,8(sp)
    80001ef4:	0080                	addi	s0,sp,64
    80001ef6:	8aaa                	mv	s5,a0
    80001ef8:	8a2e                	mv	s4,a1
    if (n == 1)
    80001efa:	4785                	li	a5,1
    80001efc:	00f58763          	beq	a1,a5,80001f0a <vmprint+0x26>
    {
        printf("page table %p\n", pagetable);
    }
    if (n >= 4)
    80001f00:	478d                	li	a5,3
    80001f02:	0747cd63          	blt	a5,s4,80001f7c <vmprint+0x98>
    {
        return;
    }
    for (int i = 0; i < 512; i++)
    80001f06:	4481                	li	s1,0
    80001f08:	a8a1                	j	80001f60 <vmprint+0x7c>
        printf("page table %p\n", pagetable);
    80001f0a:	85aa                	mv	a1,a0
    80001f0c:	00003517          	auipc	a0,0x3
    80001f10:	66450513          	addi	a0,a0,1636 # 80005570 <digits+0x3d8>
    80001f14:	fffff097          	auipc	ra,0xfffff
    80001f18:	610080e7          	jalr	1552(ra) # 80001524 <printf>
    80001f1c:	b7d5                	j	80001f00 <vmprint+0x1c>
        pte_t pte = pagetable[i];
        if (pte & PTE_V)
        {
            for (int j = 1; j <= n; j++)
            {
                printf(".. ");
    80001f1e:	00003517          	auipc	a0,0x3
    80001f22:	66250513          	addi	a0,a0,1634 # 80005580 <digits+0x3e8>
    80001f26:	fffff097          	auipc	ra,0xfffff
    80001f2a:	5fe080e7          	jalr	1534(ra) # 80001524 <printf>
            for (int j = 1; j <= n; j++)
    80001f2e:	2905                	addiw	s2,s2,1
    80001f30:	ff2a57e3          	bge	s4,s2,80001f1e <vmprint+0x3a>
            }
            uint64 child = PTE2PA(pte);
    80001f34:	00a9d913          	srli	s2,s3,0xa
    80001f38:	0932                	slli	s2,s2,0xc
            printf("%d: pte %p pa %p\n", i, pte, child);
    80001f3a:	86ca                	mv	a3,s2
    80001f3c:	864e                	mv	a2,s3
    80001f3e:	85a6                	mv	a1,s1
    80001f40:	00003517          	auipc	a0,0x3
    80001f44:	64850513          	addi	a0,a0,1608 # 80005588 <digits+0x3f0>
    80001f48:	fffff097          	auipc	ra,0xfffff
    80001f4c:	5dc080e7          	jalr	1500(ra) # 80001524 <printf>
            vmprint((pagetable_t)child, n + 1);
    80001f50:	001a059b          	addiw	a1,s4,1
    80001f54:	854a                	mv	a0,s2
    80001f56:	00000097          	auipc	ra,0x0
    80001f5a:	f8e080e7          	jalr	-114(ra) # 80001ee4 <vmprint>
    for (int i = 0; i < 512; i++)
    80001f5e:	2485                	addiw	s1,s1,1
    80001f60:	1ff00793          	li	a5,511
    80001f64:	0097cc63          	blt	a5,s1,80001f7c <vmprint+0x98>
        pte_t pte = pagetable[i];
    80001f68:	00349793          	slli	a5,s1,0x3
    80001f6c:	97d6                	add	a5,a5,s5
    80001f6e:	0007b983          	ld	s3,0(a5) # 1000 <_entry-0x7ffff000>
        if (pte & PTE_V)
    80001f72:	0019f793          	andi	a5,s3,1
    80001f76:	d7e5                	beqz	a5,80001f5e <vmprint+0x7a>
            for (int j = 1; j <= n; j++)
    80001f78:	4905                	li	s2,1
    80001f7a:	bf5d                	j	80001f30 <vmprint+0x4c>
        }
    }
    80001f7c:	70e2                	ld	ra,56(sp)
    80001f7e:	7442                	ld	s0,48(sp)
    80001f80:	74a2                	ld	s1,40(sp)
    80001f82:	7902                	ld	s2,32(sp)
    80001f84:	69e2                	ld	s3,24(sp)
    80001f86:	6a42                	ld	s4,16(sp)
    80001f88:	6aa2                	ld	s5,8(sp)
    80001f8a:	6121                	addi	sp,sp,64
    80001f8c:	8082                	ret
	...

0000000080001f90 <forkra>:
    80001f90:	40b102b3          	sub	t0,sp,a1
    80001f94:	92b2                	add	t0,t0,a2
    80001f96:	00153023          	sd	ra,0(a0)
    80001f9a:	00553423          	sd	t0,8(a0)
    80001f9e:	e900                	sd	s0,16(a0)
    80001fa0:	ed04                	sd	s1,24(a0)
    80001fa2:	03253023          	sd	s2,32(a0)
    80001fa6:	03353423          	sd	s3,40(a0)
    80001faa:	03453823          	sd	s4,48(a0)
    80001fae:	03553c23          	sd	s5,56(a0)
    80001fb2:	05653023          	sd	s6,64(a0)
    80001fb6:	05753423          	sd	s7,72(a0)
    80001fba:	05853823          	sd	s8,80(a0)
    80001fbe:	05953c23          	sd	s9,88(a0)
    80001fc2:	07a53023          	sd	s10,96(a0)
    80001fc6:	07b53423          	sd	s11,104(a0)
    80001fca:	8082                	ret
    80001fcc:	00000013          	nop

0000000080001fd0 <execra>:
    80001fd0:	e110                	sd	a2,0(a0)
    80001fd2:	0005b083          	ld	ra,0(a1)
    80001fd6:	0085b103          	ld	sp,8(a1)
    80001fda:	6980                	ld	s0,16(a1)
    80001fdc:	6d84                	ld	s1,24(a1)
    80001fde:	0205b903          	ld	s2,32(a1)
    80001fe2:	0285b983          	ld	s3,40(a1)
    80001fe6:	0305ba03          	ld	s4,48(a1)
    80001fea:	0385ba83          	ld	s5,56(a1)
    80001fee:	0405bb03          	ld	s6,64(a1)
    80001ff2:	0485bb83          	ld	s7,72(a1)
    80001ff6:	0505bc03          	ld	s8,80(a1)
    80001ffa:	0585bc83          	ld	s9,88(a1)
    80001ffe:	0605bd03          	ld	s10,96(a1)
    80002002:	0685bd83          	ld	s11,104(a1)
    80002006:	8082                	ret
    80002008:	00000013          	nop
    8000200c:	00000013          	nop

0000000080002010 <userret>:
    80002010:	00050093          	mv	ra,a0
    80002014:	00058113          	mv	sp,a1
    80002018:	8082                	ret
	...

0000000080002022 <alloc_desc>:
    // plic.c and trap.c arrange for interrupts from VIRTIO0_IRQ.
}

// find a free descriptor, mark it non-free, return its index.
static int
alloc_desc() {
    80002022:	1141                	addi	sp,sp,-16
    80002024:	e422                	sd	s0,8(sp)
    80002026:	0800                	addi	s0,sp,16
    for (int i = 0; i < NUM; i++) {
    80002028:	4501                	li	a0,0
    8000202a:	a011                	j	8000202e <alloc_desc+0xc>
    8000202c:	2505                	addiw	a0,a0,1
    8000202e:	479d                	li	a5,7
    80002030:	02a7c263          	blt	a5,a0,80002054 <alloc_desc+0x32>
        if (disk.free[i]) {
    80002034:	0004a797          	auipc	a5,0x4a
    80002038:	fcc78793          	addi	a5,a5,-52 # 8004c000 <disk>
    8000203c:	00a78733          	add	a4,a5,a0
    80002040:	6789                	lui	a5,0x2
    80002042:	97ba                	add	a5,a5,a4
    80002044:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80002048:	d3f5                	beqz	a5,8000202c <alloc_desc+0xa>
            disk.free[i] = 0;
    8000204a:	6789                	lui	a5,0x2
    8000204c:	97ba                	add	a5,a5,a4
    8000204e:	00078c23          	sb	zero,24(a5) # 2018 <_entry-0x7fffdfe8>
            return i;
    80002052:	a011                	j	80002056 <alloc_desc+0x34>
        }
    }
    return -1;
    80002054:	557d                	li	a0,-1
}
    80002056:	6422                	ld	s0,8(sp)
    80002058:	0141                	addi	sp,sp,16
    8000205a:	8082                	ret

000000008000205c <free_desc>:

// mark a descriptor as free.
static void
free_desc(int i) {
    8000205c:	1101                	addi	sp,sp,-32
    8000205e:	ec06                	sd	ra,24(sp)
    80002060:	e822                	sd	s0,16(sp)
    80002062:	e426                	sd	s1,8(sp)
    80002064:	1000                	addi	s0,sp,32
    80002066:	84aa                	mv	s1,a0
    if (i >= NUM)
    80002068:	479d                	li	a5,7
    8000206a:	06a7ca63          	blt	a5,a0,800020de <free_desc+0x82>
        panic("free_desc 1");
    if (disk.free[i])
    8000206e:	0004a797          	auipc	a5,0x4a
    80002072:	f9278793          	addi	a5,a5,-110 # 8004c000 <disk>
    80002076:	00978733          	add	a4,a5,s1
    8000207a:	6789                	lui	a5,0x2
    8000207c:	97ba                	add	a5,a5,a4
    8000207e:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80002082:	e7bd                	bnez	a5,800020f0 <free_desc+0x94>
        panic("free_desc 2");
    disk.desc[i].addr = 0;
    80002084:	0004c717          	auipc	a4,0x4c
    80002088:	f7c70713          	addi	a4,a4,-132 # 8004e000 <disk+0x2000>
    8000208c:	6314                	ld	a3,0(a4)
    8000208e:	00449793          	slli	a5,s1,0x4
    80002092:	96be                	add	a3,a3,a5
    80002094:	0006b023          	sd	zero,0(a3)
    disk.desc[i].len = 0;
    80002098:	6314                	ld	a3,0(a4)
    8000209a:	96be                	add	a3,a3,a5
    8000209c:	0006a423          	sw	zero,8(a3)
    disk.desc[i].flags = 0;
    800020a0:	6314                	ld	a3,0(a4)
    800020a2:	96be                	add	a3,a3,a5
    800020a4:	00069623          	sh	zero,12(a3)
    disk.desc[i].next = 0;
    800020a8:	6318                	ld	a4,0(a4)
    800020aa:	97ba                	add	a5,a5,a4
    800020ac:	00079723          	sh	zero,14(a5)
    disk.free[i] = 1;
    800020b0:	0004a517          	auipc	a0,0x4a
    800020b4:	f5050513          	addi	a0,a0,-176 # 8004c000 <disk>
    800020b8:	9526                	add	a0,a0,s1
    800020ba:	6489                	lui	s1,0x2
    800020bc:	94aa                	add	s1,s1,a0
    800020be:	4785                	li	a5,1
    800020c0:	00f48c23          	sb	a5,24(s1) # 2018 <_entry-0x7fffdfe8>
    wakeup(&disk.free[0]);
    800020c4:	0004c517          	auipc	a0,0x4c
    800020c8:	f5450513          	addi	a0,a0,-172 # 8004e018 <disk+0x2018>
    800020cc:	fffff097          	auipc	ra,0xfffff
    800020d0:	ae8080e7          	jalr	-1304(ra) # 80000bb4 <wakeup>
}
    800020d4:	60e2                	ld	ra,24(sp)
    800020d6:	6442                	ld	s0,16(sp)
    800020d8:	64a2                	ld	s1,8(sp)
    800020da:	6105                	addi	sp,sp,32
    800020dc:	8082                	ret
        panic("free_desc 1");
    800020de:	00003517          	auipc	a0,0x3
    800020e2:	4c250513          	addi	a0,a0,1218 # 800055a0 <digits+0x408>
    800020e6:	fffff097          	auipc	ra,0xfffff
    800020ea:	4f6080e7          	jalr	1270(ra) # 800015dc <panic>
    800020ee:	b741                	j	8000206e <free_desc+0x12>
        panic("free_desc 2");
    800020f0:	00003517          	auipc	a0,0x3
    800020f4:	4c050513          	addi	a0,a0,1216 # 800055b0 <digits+0x418>
    800020f8:	fffff097          	auipc	ra,0xfffff
    800020fc:	4e4080e7          	jalr	1252(ra) # 800015dc <panic>
    80002100:	b751                	j	80002084 <free_desc+0x28>

0000000080002102 <alloc3_desc>:
}

// allocate three descriptors (they need not be contiguous).
// disk transfers always use three descriptors.
static int
alloc3_desc(int *idx) {
    80002102:	7179                	addi	sp,sp,-48
    80002104:	f406                	sd	ra,40(sp)
    80002106:	f022                	sd	s0,32(sp)
    80002108:	ec26                	sd	s1,24(sp)
    8000210a:	e84a                	sd	s2,16(sp)
    8000210c:	e44e                	sd	s3,8(sp)
    8000210e:	1800                	addi	s0,sp,48
    80002110:	89aa                	mv	s3,a0
    for (int i = 0; i < 3; i++) {
    80002112:	4481                	li	s1,0
    80002114:	a839                	j	80002132 <alloc3_desc+0x30>
        idx[i] = alloc_desc();
        if (idx[i] < 0) {
            for (int j = 0; j < i; j++)
                free_desc(idx[j]);
    80002116:	00291793          	slli	a5,s2,0x2
    8000211a:	97ce                	add	a5,a5,s3
    8000211c:	4388                	lw	a0,0(a5)
    8000211e:	00000097          	auipc	ra,0x0
    80002122:	f3e080e7          	jalr	-194(ra) # 8000205c <free_desc>
            for (int j = 0; j < i; j++)
    80002126:	2905                	addiw	s2,s2,1
    80002128:	fe9947e3          	blt	s2,s1,80002116 <alloc3_desc+0x14>
            return -1;
    8000212c:	557d                	li	a0,-1
    8000212e:	a01d                	j	80002154 <alloc3_desc+0x52>
    for (int i = 0; i < 3; i++) {
    80002130:	2485                	addiw	s1,s1,1
    80002132:	4789                	li	a5,2
    80002134:	0097cf63          	blt	a5,s1,80002152 <alloc3_desc+0x50>
        idx[i] = alloc_desc();
    80002138:	00249913          	slli	s2,s1,0x2
    8000213c:	994e                	add	s2,s2,s3
    8000213e:	00000097          	auipc	ra,0x0
    80002142:	ee4080e7          	jalr	-284(ra) # 80002022 <alloc_desc>
    80002146:	00a92023          	sw	a0,0(s2) # 1000 <_entry-0x7ffff000>
        if (idx[i] < 0) {
    8000214a:	fe0553e3          	bgez	a0,80002130 <alloc3_desc+0x2e>
            for (int j = 0; j < i; j++)
    8000214e:	4901                	li	s2,0
    80002150:	bfe1                	j	80002128 <alloc3_desc+0x26>
        }
    }
    return 0;
    80002152:	4501                	li	a0,0
}
    80002154:	70a2                	ld	ra,40(sp)
    80002156:	7402                	ld	s0,32(sp)
    80002158:	64e2                	ld	s1,24(sp)
    8000215a:	6942                	ld	s2,16(sp)
    8000215c:	69a2                	ld	s3,8(sp)
    8000215e:	6145                	addi	sp,sp,48
    80002160:	8082                	ret

0000000080002162 <free_chain>:
free_chain(int i) {
    80002162:	1101                	addi	sp,sp,-32
    80002164:	ec06                	sd	ra,24(sp)
    80002166:	e822                	sd	s0,16(sp)
    80002168:	e426                	sd	s1,8(sp)
    8000216a:	e04a                	sd	s2,0(sp)
    8000216c:	1000                	addi	s0,sp,32
    8000216e:	892a                	mv	s2,a0
        int flag = disk.desc[i].flags;
    80002170:	00491713          	slli	a4,s2,0x4
    80002174:	0004c797          	auipc	a5,0x4c
    80002178:	e8c7b783          	ld	a5,-372(a5) # 8004e000 <disk+0x2000>
    8000217c:	97ba                	add	a5,a5,a4
    8000217e:	00c7d483          	lhu	s1,12(a5)
        int nxt = disk.desc[i].next;
    80002182:	854a                	mv	a0,s2
    80002184:	00e7d903          	lhu	s2,14(a5)
        free_desc(i);
    80002188:	00000097          	auipc	ra,0x0
    8000218c:	ed4080e7          	jalr	-300(ra) # 8000205c <free_desc>
        if (flag & VRING_DESC_F_NEXT)
    80002190:	8885                	andi	s1,s1,1
    80002192:	fcf9                	bnez	s1,80002170 <free_chain+0xe>
}
    80002194:	60e2                	ld	ra,24(sp)
    80002196:	6442                	ld	s0,16(sp)
    80002198:	64a2                	ld	s1,8(sp)
    8000219a:	6902                	ld	s2,0(sp)
    8000219c:	6105                	addi	sp,sp,32
    8000219e:	8082                	ret

00000000800021a0 <virtio_disk_init>:
virtio_disk_init(void) {
    800021a0:	1101                	addi	sp,sp,-32
    800021a2:	ec06                	sd	ra,24(sp)
    800021a4:	e822                	sd	s0,16(sp)
    800021a6:	e426                	sd	s1,8(sp)
    800021a8:	1000                	addi	s0,sp,32
    spinlock_init(&disk.vdisk_lock, "virtio_disk");
    800021aa:	00003597          	auipc	a1,0x3
    800021ae:	41658593          	addi	a1,a1,1046 # 800055c0 <digits+0x428>
    800021b2:	0004c517          	auipc	a0,0x4c
    800021b6:	f7650513          	addi	a0,a0,-138 # 8004e128 <disk+0x2128>
    800021ba:	00001097          	auipc	ra,0x1
    800021be:	5f0080e7          	jalr	1520(ra) # 800037aa <spinlock_init>
    if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800021c2:	100017b7          	lui	a5,0x10001
    800021c6:	4398                	lw	a4,0(a5)
    800021c8:	2701                	sext.w	a4,a4
    800021ca:	747277b7          	lui	a5,0x74727
    800021ce:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800021d2:	00f71963          	bne	a4,a5,800021e4 <virtio_disk_init+0x44>
        *R(VIRTIO_MMIO_VERSION) != 1 ||
    800021d6:	100017b7          	lui	a5,0x10001
    800021da:	43dc                	lw	a5,4(a5)
    800021dc:	2781                	sext.w	a5,a5
    if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800021de:	4705                	li	a4,1
    800021e0:	08e78f63          	beq	a5,a4,8000227e <virtio_disk_init+0xde>
        panic("could not find virtio disk");
    800021e4:	00003517          	auipc	a0,0x3
    800021e8:	3ec50513          	addi	a0,a0,1004 # 800055d0 <digits+0x438>
    800021ec:	fffff097          	auipc	ra,0xfffff
    800021f0:	3f0080e7          	jalr	1008(ra) # 800015dc <panic>
    *R(VIRTIO_MMIO_STATUS) = status;
    800021f4:	100017b7          	lui	a5,0x10001
    800021f8:	4705                	li	a4,1
    800021fa:	dbb8                	sw	a4,112(a5)
    *R(VIRTIO_MMIO_STATUS) = status;
    800021fc:	470d                	li	a4,3
    800021fe:	dbb8                	sw	a4,112(a5)
    uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80002200:	4b98                	lw	a4,16(a5)
    80002202:	1702                	slli	a4,a4,0x20
    80002204:	9301                	srli	a4,a4,0x20
    features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80002206:	c7ffe6b7          	lui	a3,0xc7ffe
    8000220a:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47f92d47>
    8000220e:	8f75                	and	a4,a4,a3
    *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80002210:	2701                	sext.w	a4,a4
    80002212:	d398                	sw	a4,32(a5)
    *R(VIRTIO_MMIO_STATUS) = status;
    80002214:	472d                	li	a4,11
    80002216:	dbb8                	sw	a4,112(a5)
    *R(VIRTIO_MMIO_STATUS) = status;
    80002218:	473d                	li	a4,15
    8000221a:	dbb8                	sw	a4,112(a5)
    *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000221c:	6705                	lui	a4,0x1
    8000221e:	d798                	sw	a4,40(a5)
    *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80002220:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
    uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80002224:	5bc4                	lw	s1,52(a5)
    80002226:	2481                	sext.w	s1,s1
    if (max == 0)
    80002228:	ccad                	beqz	s1,800022a2 <virtio_disk_init+0x102>
    if (max < NUM)
    8000222a:	479d                	li	a5,7
    8000222c:	0897f463          	bgeu	a5,s1,800022b4 <virtio_disk_init+0x114>
    *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80002230:	100014b7          	lui	s1,0x10001
    80002234:	47a1                	li	a5,8
    80002236:	dc9c                	sw	a5,56(s1)
    memset(disk.pages, 0, sizeof(disk.pages));
    80002238:	6609                	lui	a2,0x2
    8000223a:	4581                	li	a1,0
    8000223c:	0004a517          	auipc	a0,0x4a
    80002240:	dc450513          	addi	a0,a0,-572 # 8004c000 <disk>
    80002244:	fffff097          	auipc	ra,0xfffff
    80002248:	d7e080e7          	jalr	-642(ra) # 80000fc2 <memset>
    *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64) disk.pages) >> PGSHIFT;
    8000224c:	0004a717          	auipc	a4,0x4a
    80002250:	db470713          	addi	a4,a4,-588 # 8004c000 <disk>
    80002254:	00c75793          	srli	a5,a4,0xc
    80002258:	2781                	sext.w	a5,a5
    8000225a:	c0bc                	sw	a5,64(s1)
    disk.desc = (struct virtq_desc *) disk.pages;
    8000225c:	0004c797          	auipc	a5,0x4c
    80002260:	da478793          	addi	a5,a5,-604 # 8004e000 <disk+0x2000>
    80002264:	e398                	sd	a4,0(a5)
    disk.avail = (struct virtq_avail *) (disk.pages + NUM * sizeof(struct virtq_desc));
    80002266:	0004a717          	auipc	a4,0x4a
    8000226a:	e1a70713          	addi	a4,a4,-486 # 8004c080 <disk+0x80>
    8000226e:	e798                	sd	a4,8(a5)
    disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80002270:	0004b717          	auipc	a4,0x4b
    80002274:	d9070713          	addi	a4,a4,-624 # 8004d000 <disk+0x1000>
    80002278:	eb98                	sd	a4,16(a5)
    for (int i = 0; i < NUM; i++)
    8000227a:	4781                	li	a5,0
    8000227c:	a08d                	j	800022de <virtio_disk_init+0x13e>
        *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000227e:	100017b7          	lui	a5,0x10001
    80002282:	479c                	lw	a5,8(a5)
    80002284:	2781                	sext.w	a5,a5
        *R(VIRTIO_MMIO_VERSION) != 1 ||
    80002286:	4709                	li	a4,2
    80002288:	f4e79ee3          	bne	a5,a4,800021e4 <virtio_disk_init+0x44>
        *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    8000228c:	100017b7          	lui	a5,0x10001
    80002290:	47d8                	lw	a4,12(a5)
    80002292:	2701                	sext.w	a4,a4
        *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80002294:	554d47b7          	lui	a5,0x554d4
    80002298:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000229c:	f4f714e3          	bne	a4,a5,800021e4 <virtio_disk_init+0x44>
    800022a0:	bf91                	j	800021f4 <virtio_disk_init+0x54>
        panic("virtio disk has no queue 0");
    800022a2:	00003517          	auipc	a0,0x3
    800022a6:	34e50513          	addi	a0,a0,846 # 800055f0 <digits+0x458>
    800022aa:	fffff097          	auipc	ra,0xfffff
    800022ae:	332080e7          	jalr	818(ra) # 800015dc <panic>
    800022b2:	bfa5                	j	8000222a <virtio_disk_init+0x8a>
        panic("virtio disk max queue too short");
    800022b4:	00003517          	auipc	a0,0x3
    800022b8:	35c50513          	addi	a0,a0,860 # 80005610 <digits+0x478>
    800022bc:	fffff097          	auipc	ra,0xfffff
    800022c0:	320080e7          	jalr	800(ra) # 800015dc <panic>
    800022c4:	b7b5                	j	80002230 <virtio_disk_init+0x90>
        disk.free[i] = 1;
    800022c6:	0004a717          	auipc	a4,0x4a
    800022ca:	d3a70713          	addi	a4,a4,-710 # 8004c000 <disk>
    800022ce:	00f706b3          	add	a3,a4,a5
    800022d2:	6709                	lui	a4,0x2
    800022d4:	9736                	add	a4,a4,a3
    800022d6:	4685                	li	a3,1
    800022d8:	00d70c23          	sb	a3,24(a4) # 2018 <_entry-0x7fffdfe8>
    for (int i = 0; i < NUM; i++)
    800022dc:	2785                	addiw	a5,a5,1
    800022de:	471d                	li	a4,7
    800022e0:	fef753e3          	bge	a4,a5,800022c6 <virtio_disk_init+0x126>
}
    800022e4:	60e2                	ld	ra,24(sp)
    800022e6:	6442                	ld	s0,16(sp)
    800022e8:	64a2                	ld	s1,8(sp)
    800022ea:	6105                	addi	sp,sp,32
    800022ec:	8082                	ret

00000000800022ee <virtio_disk_rw>:

void
virtio_disk_rw(struct buf *b, int write) {
    800022ee:	7139                	addi	sp,sp,-64
    800022f0:	fc06                	sd	ra,56(sp)
    800022f2:	f822                	sd	s0,48(sp)
    800022f4:	f426                	sd	s1,40(sp)
    800022f6:	f04a                	sd	s2,32(sp)
    800022f8:	ec4e                	sd	s3,24(sp)
    800022fa:	0080                	addi	s0,sp,64
    800022fc:	84aa                	mv	s1,a0
    800022fe:	892e                	mv	s2,a1
    uint64 sector = b->blockno * (BSIZE / 512);
    80002300:	00c52983          	lw	s3,12(a0)
    80002304:	0019999b          	slliw	s3,s3,0x1
    80002308:	1982                	slli	s3,s3,0x20
    8000230a:	0209d993          	srli	s3,s3,0x20
    spin_lock(&disk.vdisk_lock);
    8000230e:	0004c517          	auipc	a0,0x4c
    80002312:	e1a50513          	addi	a0,a0,-486 # 8004e128 <disk+0x2128>
    80002316:	00001097          	auipc	ra,0x1
    8000231a:	528080e7          	jalr	1320(ra) # 8000383e <spin_lock>
    // data, one for a 1-byte status result.

    // allocate the three descriptors.
    int idx[3];
    while (1) {
        if (alloc3_desc(idx) == 0) {
    8000231e:	fc040513          	addi	a0,s0,-64
    80002322:	00000097          	auipc	ra,0x0
    80002326:	de0080e7          	jalr	-544(ra) # 80002102 <alloc3_desc>
    8000232a:	cd11                	beqz	a0,80002346 <virtio_disk_rw+0x58>
            break;
        }
        sleep(&disk.free[0], &disk.vdisk_lock);
    8000232c:	0004c597          	auipc	a1,0x4c
    80002330:	dfc58593          	addi	a1,a1,-516 # 8004e128 <disk+0x2128>
    80002334:	0004c517          	auipc	a0,0x4c
    80002338:	ce450513          	addi	a0,a0,-796 # 8004e018 <disk+0x2018>
    8000233c:	ffffe097          	auipc	ra,0xffffe
    80002340:	79a080e7          	jalr	1946(ra) # 80000ad6 <sleep>
        if (alloc3_desc(idx) == 0) {
    80002344:	bfe9                	j	8000231e <virtio_disk_rw+0x30>
    }

    // format the three descriptors.
    // qemu's virtio-blk.c reads them.
    struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80002346:	fc042683          	lw	a3,-64(s0)
    8000234a:	20068793          	addi	a5,a3,512
    8000234e:	0792                	slli	a5,a5,0x4
    80002350:	0004a717          	auipc	a4,0x4a
    80002354:	cb070713          	addi	a4,a4,-848 # 8004c000 <disk>
    80002358:	97ba                	add	a5,a5,a4
    8000235a:	0a878793          	addi	a5,a5,168

    if (write)
    8000235e:	14090363          	beqz	s2,800024a4 <virtio_disk_rw+0x1b6>
        buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80002362:	20068713          	addi	a4,a3,512
    80002366:	00471613          	slli	a2,a4,0x4
    8000236a:	0004a717          	auipc	a4,0x4a
    8000236e:	c9670713          	addi	a4,a4,-874 # 8004c000 <disk>
    80002372:	9732                	add	a4,a4,a2
    80002374:	4605                	li	a2,1
    80002376:	0ac72423          	sw	a2,168(a4)
    else
        buf0->type = VIRTIO_BLK_T_IN; // read the disk
    buf0->reserved = 0;
    8000237a:	20068713          	addi	a4,a3,512
    8000237e:	00471613          	slli	a2,a4,0x4
    80002382:	0004a717          	auipc	a4,0x4a
    80002386:	c7e70713          	addi	a4,a4,-898 # 8004c000 <disk>
    8000238a:	9732                	add	a4,a4,a2
    8000238c:	0a072623          	sw	zero,172(a4)
    buf0->sector = sector;
    80002390:	0b373823          	sd	s3,176(a4)

    disk.desc[idx[0]].addr = (uint64) buf0;
    80002394:	0004c717          	auipc	a4,0x4c
    80002398:	c6c70713          	addi	a4,a4,-916 # 8004e000 <disk+0x2000>
    8000239c:	6310                	ld	a2,0(a4)
    8000239e:	0692                	slli	a3,a3,0x4
    800023a0:	96b2                	add	a3,a3,a2
    800023a2:	e29c                	sd	a5,0(a3)
    disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800023a4:	6314                	ld	a3,0(a4)
    800023a6:	fc042783          	lw	a5,-64(s0)
    800023aa:	0792                	slli	a5,a5,0x4
    800023ac:	96be                	add	a3,a3,a5
    800023ae:	4641                	li	a2,16
    800023b0:	c690                	sw	a2,8(a3)
    disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800023b2:	6314                	ld	a3,0(a4)
    800023b4:	96be                	add	a3,a3,a5
    800023b6:	4605                	li	a2,1
    800023b8:	00c69623          	sh	a2,12(a3)
    disk.desc[idx[0]].next = idx[1];
    800023bc:	fc442683          	lw	a3,-60(s0)
    800023c0:	6310                	ld	a2,0(a4)
    800023c2:	97b2                	add	a5,a5,a2
    800023c4:	00d79723          	sh	a3,14(a5)

    disk.desc[idx[1]].addr = (uint64) b->data;
    800023c8:	04c48613          	addi	a2,s1,76 # 1000104c <_entry-0x6fffefb4>
    800023cc:	631c                	ld	a5,0(a4)
    800023ce:	0692                	slli	a3,a3,0x4
    800023d0:	96be                	add	a3,a3,a5
    800023d2:	e290                	sd	a2,0(a3)
    disk.desc[idx[1]].len = BSIZE;
    800023d4:	6318                	ld	a4,0(a4)
    800023d6:	fc442783          	lw	a5,-60(s0)
    800023da:	0792                	slli	a5,a5,0x4
    800023dc:	973e                	add	a4,a4,a5
    800023de:	40000693          	li	a3,1024
    800023e2:	c714                	sw	a3,8(a4)
    if (write)
    800023e4:	0c090c63          	beqz	s2,800024bc <virtio_disk_rw+0x1ce>
        disk.desc[idx[1]].flags = 0; // device reads b->data
    800023e8:	0004c717          	auipc	a4,0x4c
    800023ec:	c1873703          	ld	a4,-1000(a4) # 8004e000 <disk+0x2000>
    800023f0:	973e                	add	a4,a4,a5
    800023f2:	00071623          	sh	zero,12(a4)
    else
        disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800023f6:	0004a697          	auipc	a3,0x4a
    800023fa:	c0a68693          	addi	a3,a3,-1014 # 8004c000 <disk>
    800023fe:	0004c717          	auipc	a4,0x4c
    80002402:	c0270713          	addi	a4,a4,-1022 # 8004e000 <disk+0x2000>
    80002406:	6310                	ld	a2,0(a4)
    80002408:	963e                	add	a2,a2,a5
    8000240a:	00c65583          	lhu	a1,12(a2) # 200c <_entry-0x7fffdff4>
    8000240e:	0015e593          	ori	a1,a1,1
    80002412:	00b61623          	sh	a1,12(a2)
    disk.desc[idx[1]].next = idx[2];
    80002416:	fc842603          	lw	a2,-56(s0)
    8000241a:	630c                	ld	a1,0(a4)
    8000241c:	97ae                	add	a5,a5,a1
    8000241e:	00c79723          	sh	a2,14(a5)

    disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80002422:	fc042783          	lw	a5,-64(s0)
    80002426:	20078793          	addi	a5,a5,512
    8000242a:	0792                	slli	a5,a5,0x4
    8000242c:	97b6                	add	a5,a5,a3
    8000242e:	55fd                	li	a1,-1
    80002430:	02b78823          	sb	a1,48(a5)
    disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80002434:	03078793          	addi	a5,a5,48
    80002438:	630c                	ld	a1,0(a4)
    8000243a:	0612                	slli	a2,a2,0x4
    8000243c:	962e                	add	a2,a2,a1
    8000243e:	e21c                	sd	a5,0(a2)
    disk.desc[idx[2]].len = 1;
    80002440:	631c                	ld	a5,0(a4)
    80002442:	fc842603          	lw	a2,-56(s0)
    80002446:	0612                	slli	a2,a2,0x4
    80002448:	97b2                	add	a5,a5,a2
    8000244a:	4585                	li	a1,1
    8000244c:	c78c                	sw	a1,8(a5)
    disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000244e:	6310                	ld	a2,0(a4)
    80002450:	fc842783          	lw	a5,-56(s0)
    80002454:	0792                	slli	a5,a5,0x4
    80002456:	963e                	add	a2,a2,a5
    80002458:	4509                	li	a0,2
    8000245a:	00a61623          	sh	a0,12(a2)
    disk.desc[idx[2]].next = 0;
    8000245e:	6310                	ld	a2,0(a4)
    80002460:	97b2                	add	a5,a5,a2
    80002462:	00079723          	sh	zero,14(a5)

    // record struct buf for virtio_disk_intr().
    b->disk = 1;
    80002466:	c0cc                	sw	a1,4(s1)
    disk.info[idx[0]].b = b;
    80002468:	fc042603          	lw	a2,-64(s0)
    8000246c:	20060793          	addi	a5,a2,512
    80002470:	0792                	slli	a5,a5,0x4
    80002472:	96be                	add	a3,a3,a5
    80002474:	f684                	sd	s1,40(a3)

    // tell the device the first index in our chain of descriptors.
    disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80002476:	6714                	ld	a3,8(a4)
    80002478:	0026d783          	lhu	a5,2(a3)
    8000247c:	8b9d                	andi	a5,a5,7
    8000247e:	0786                	slli	a5,a5,0x1
    80002480:	97b6                	add	a5,a5,a3
    80002482:	00c79223          	sh	a2,4(a5)

    __sync_synchronize();
    80002486:	0ff0000f          	fence

    // tell the device another avail ring entry is available.
    disk.avail->idx += 1; // not % NUM ...
    8000248a:	6718                	ld	a4,8(a4)
    8000248c:	00275783          	lhu	a5,2(a4)
    80002490:	2785                	addiw	a5,a5,1
    80002492:	00f71123          	sh	a5,2(a4)

    __sync_synchronize();
    80002496:	0ff0000f          	fence

    *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000249a:	100017b7          	lui	a5,0x10001
    8000249e:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

    // Wait for virtio_disk_intr() to say request has finished.
    while (b->disk == 1) {
    800024a2:	a83d                	j	800024e0 <virtio_disk_rw+0x1f2>
        buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800024a4:	20068713          	addi	a4,a3,512
    800024a8:	00471613          	slli	a2,a4,0x4
    800024ac:	0004a717          	auipc	a4,0x4a
    800024b0:	b5470713          	addi	a4,a4,-1196 # 8004c000 <disk>
    800024b4:	9732                	add	a4,a4,a2
    800024b6:	0a072423          	sw	zero,168(a4)
    800024ba:	b5c1                	j	8000237a <virtio_disk_rw+0x8c>
        disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800024bc:	0004c717          	auipc	a4,0x4c
    800024c0:	b4473703          	ld	a4,-1212(a4) # 8004e000 <disk+0x2000>
    800024c4:	973e                	add	a4,a4,a5
    800024c6:	4689                	li	a3,2
    800024c8:	00d71623          	sh	a3,12(a4)
    800024cc:	b72d                	j	800023f6 <virtio_disk_rw+0x108>
        sleep(b, &disk.vdisk_lock);
    800024ce:	0004c597          	auipc	a1,0x4c
    800024d2:	c5a58593          	addi	a1,a1,-934 # 8004e128 <disk+0x2128>
    800024d6:	8526                	mv	a0,s1
    800024d8:	ffffe097          	auipc	ra,0xffffe
    800024dc:	5fe080e7          	jalr	1534(ra) # 80000ad6 <sleep>
    while (b->disk == 1) {
    800024e0:	40d8                	lw	a4,4(s1)
    800024e2:	4785                	li	a5,1
    800024e4:	fef705e3          	beq	a4,a5,800024ce <virtio_disk_rw+0x1e0>
    }

    disk.info[idx[0]].b = 0;
    800024e8:	fc042503          	lw	a0,-64(s0)
    800024ec:	20050793          	addi	a5,a0,512
    800024f0:	00479713          	slli	a4,a5,0x4
    800024f4:	0004a797          	auipc	a5,0x4a
    800024f8:	b0c78793          	addi	a5,a5,-1268 # 8004c000 <disk>
    800024fc:	97ba                	add	a5,a5,a4
    800024fe:	0207b423          	sd	zero,40(a5)
    free_chain(idx[0]);
    80002502:	00000097          	auipc	ra,0x0
    80002506:	c60080e7          	jalr	-928(ra) # 80002162 <free_chain>
    spin_unlock(&disk.vdisk_lock);
    8000250a:	0004c517          	auipc	a0,0x4c
    8000250e:	c1e50513          	addi	a0,a0,-994 # 8004e128 <disk+0x2128>
    80002512:	00001097          	auipc	ra,0x1
    80002516:	3fe080e7          	jalr	1022(ra) # 80003910 <spin_unlock>
}
    8000251a:	70e2                	ld	ra,56(sp)
    8000251c:	7442                	ld	s0,48(sp)
    8000251e:	74a2                	ld	s1,40(sp)
    80002520:	7902                	ld	s2,32(sp)
    80002522:	69e2                	ld	s3,24(sp)
    80002524:	6121                	addi	sp,sp,64
    80002526:	8082                	ret

0000000080002528 <virtio_disk_intr>:

void
virtio_disk_intr() {
    80002528:	1101                	addi	sp,sp,-32
    8000252a:	ec06                	sd	ra,24(sp)
    8000252c:	e822                	sd	s0,16(sp)
    8000252e:	e426                	sd	s1,8(sp)
    80002530:	1000                	addi	s0,sp,32
    spin_lock(&disk.vdisk_lock);
    80002532:	0004c517          	auipc	a0,0x4c
    80002536:	bf650513          	addi	a0,a0,-1034 # 8004e128 <disk+0x2128>
    8000253a:	00001097          	auipc	ra,0x1
    8000253e:	304080e7          	jalr	772(ra) # 8000383e <spin_lock>
    // we've seen this interrupt, which the following line does.
    // this may race with the device writing new entries to
    // the "used" ring, in which case we may process the new
    // completion entries in this interrupt, and have nothing to do
    // in the next interrupt, which is harmless.
    *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80002542:	10001737          	lui	a4,0x10001
    80002546:	533c                	lw	a5,96(a4)
    80002548:	8b8d                	andi	a5,a5,3
    8000254a:	d37c                	sw	a5,100(a4)

    __sync_synchronize();
    8000254c:	0ff0000f          	fence

    // the device increments disk.used->idx when it
    // adds an entry to the used ring.
    while (disk.used_idx != disk.used->idx) {
    80002550:	a089                	j	80002592 <virtio_disk_intr+0x6a>
        __sync_synchronize();
        int id = disk.used->ring[disk.used_idx % NUM].id;

        if (disk.info[id].status != 0)
            panic("virtio_disk_intr status");
    80002552:	00003517          	auipc	a0,0x3
    80002556:	0de50513          	addi	a0,a0,222 # 80005630 <digits+0x498>
    8000255a:	fffff097          	auipc	ra,0xfffff
    8000255e:	082080e7          	jalr	130(ra) # 800015dc <panic>

        struct buf *b = disk.info[id].b;
    80002562:	20048493          	addi	s1,s1,512
    80002566:	0492                	slli	s1,s1,0x4
    80002568:	0004a797          	auipc	a5,0x4a
    8000256c:	a9878793          	addi	a5,a5,-1384 # 8004c000 <disk>
    80002570:	94be                	add	s1,s1,a5
    80002572:	7488                	ld	a0,40(s1)
        b->disk = 0;   // disk is done with buf
    80002574:	00052223          	sw	zero,4(a0)
        wakeup(b);
    80002578:	ffffe097          	auipc	ra,0xffffe
    8000257c:	63c080e7          	jalr	1596(ra) # 80000bb4 <wakeup>

        disk.used_idx += 1;
    80002580:	0004c717          	auipc	a4,0x4c
    80002584:	a8070713          	addi	a4,a4,-1408 # 8004e000 <disk+0x2000>
    80002588:	02075783          	lhu	a5,32(a4)
    8000258c:	2785                	addiw	a5,a5,1
    8000258e:	02f71023          	sh	a5,32(a4)
    while (disk.used_idx != disk.used->idx) {
    80002592:	0004c797          	auipc	a5,0x4c
    80002596:	a6e78793          	addi	a5,a5,-1426 # 8004e000 <disk+0x2000>
    8000259a:	6b94                	ld	a3,16(a5)
    8000259c:	0207d703          	lhu	a4,32(a5)
    800025a0:	0026d783          	lhu	a5,2(a3)
    800025a4:	02f70c63          	beq	a4,a5,800025dc <virtio_disk_intr+0xb4>
        __sync_synchronize();
    800025a8:	0ff0000f          	fence
        int id = disk.used->ring[disk.used_idx % NUM].id;
    800025ac:	0004c797          	auipc	a5,0x4c
    800025b0:	a5478793          	addi	a5,a5,-1452 # 8004e000 <disk+0x2000>
    800025b4:	6b98                	ld	a4,16(a5)
    800025b6:	0207d783          	lhu	a5,32(a5)
    800025ba:	8b9d                	andi	a5,a5,7
    800025bc:	078e                	slli	a5,a5,0x3
    800025be:	97ba                	add	a5,a5,a4
    800025c0:	43c4                	lw	s1,4(a5)
        if (disk.info[id].status != 0)
    800025c2:	20048793          	addi	a5,s1,512
    800025c6:	00479713          	slli	a4,a5,0x4
    800025ca:	0004a797          	auipc	a5,0x4a
    800025ce:	a3678793          	addi	a5,a5,-1482 # 8004c000 <disk>
    800025d2:	97ba                	add	a5,a5,a4
    800025d4:	0307c783          	lbu	a5,48(a5)
    800025d8:	d7c9                	beqz	a5,80002562 <virtio_disk_intr+0x3a>
    800025da:	bfa5                	j	80002552 <virtio_disk_intr+0x2a>
    }
    spin_unlock(&disk.vdisk_lock);
    800025dc:	0004c517          	auipc	a0,0x4c
    800025e0:	b4c50513          	addi	a0,a0,-1204 # 8004e128 <disk+0x2128>
    800025e4:	00001097          	auipc	ra,0x1
    800025e8:	32c080e7          	jalr	812(ra) # 80003910 <spin_unlock>
}
    800025ec:	60e2                	ld	ra,24(sp)
    800025ee:	6442                	ld	s0,16(sp)
    800025f0:	64a2                	ld	s1,8(sp)
    800025f2:	6105                	addi	sp,sp,32
    800025f4:	8082                	ret

00000000800025f6 <fstest>:
#include "file.h"
#include "virtio.h"
#include "../defs.h"
#include "fstest.h"

void fstest() {
    800025f6:	715d                	addi	sp,sp,-80
    800025f8:	e486                	sd	ra,72(sp)
    800025fa:	e0a2                	sd	s0,64(sp)
    800025fc:	fc26                	sd	s1,56(sp)
    800025fe:	f84a                	sd	s2,48(sp)
    80002600:	0880                	addi	s0,sp,80
    struct inode *inode;
    struct superblock sb;
    read_superblock(&sb);
    80002602:	fc840513          	addi	a0,s0,-56
    80002606:	00000097          	auipc	ra,0x0
    8000260a:	3ae080e7          	jalr	942(ra) # 800029b4 <read_superblock>
    inode = alloc_inode(T_FILE);
    8000260e:	4509                	li	a0,2
    80002610:	00000097          	auipc	ra,0x0
    80002614:	776080e7          	jalr	1910(ra) # 80002d86 <alloc_inode>
    80002618:	84aa                	mv	s1,a0
    printf("测试inode能否读写");
    8000261a:	00003517          	auipc	a0,0x3
    8000261e:	02e50513          	addi	a0,a0,46 # 80005648 <digits+0x4b0>
    80002622:	fffff097          	auipc	ra,0xfffff
    80002626:	f02080e7          	jalr	-254(ra) # 80001524 <printf>
    char *str = "hello world!!";
    write_inode(inode, (uint64) str, 0, strlen(str));
    8000262a:	00003917          	auipc	s2,0x3
    8000262e:	03690913          	addi	s2,s2,54 # 80005660 <digits+0x4c8>
    80002632:	854a                	mv	a0,s2
    80002634:	fffff097          	auipc	ra,0xfffff
    80002638:	9f8080e7          	jalr	-1544(ra) # 8000102c <strlen>
    8000263c:	0005069b          	sext.w	a3,a0
    80002640:	4601                	li	a2,0
    80002642:	85ca                	mv	a1,s2
    80002644:	8526                	mv	a0,s1
    80002646:	00001097          	auipc	ra,0x1
    8000264a:	bf0080e7          	jalr	-1040(ra) # 80003236 <write_inode>
    char s[20];
    read_inode(inode, (uint64) s, 0, 30);
    8000264e:	46f9                	li	a3,30
    80002650:	4601                	li	a2,0
    80002652:	fb040593          	addi	a1,s0,-80
    80002656:	8526                	mv	a0,s1
    80002658:	00001097          	auipc	ra,0x1
    8000265c:	b1a080e7          	jalr	-1254(ra) # 80003172 <read_inode>
    printf("%s\n", s);
    80002660:	fb040593          	addi	a1,s0,-80
    80002664:	00003517          	auipc	a0,0x3
    80002668:	b0450513          	addi	a0,a0,-1276 # 80005168 <etext+0x168>
    8000266c:	fffff097          	auipc	ra,0xfffff
    80002670:	eb8080e7          	jalr	-328(ra) # 80001524 <printf>
}
    80002674:	60a6                	ld	ra,72(sp)
    80002676:	6406                	ld	s0,64(sp)
    80002678:	74e2                	ld	s1,56(sp)
    8000267a:	7942                	ld	s2,48(sp)
    8000267c:	6161                	addi	sp,sp,80
    8000267e:	8082                	ret

0000000080002680 <dirtest>:

// 输出根目录下的direntry
void dirtest() {
    80002680:	be010113          	addi	sp,sp,-1056
    80002684:	40113c23          	sd	ra,1048(sp)
    80002688:	40813823          	sd	s0,1040(sp)
    8000268c:	40913423          	sd	s1,1032(sp)
    80002690:	42010413          	addi	s0,sp,1056
    int off = 0;
    char str[1024];
    printf("aa\n");
    80002694:	00003517          	auipc	a0,0x3
    80002698:	fdc50513          	addi	a0,a0,-36 # 80005670 <digits+0x4d8>
    8000269c:	fffff097          	auipc	ra,0xfffff
    800026a0:	e88080e7          	jalr	-376(ra) # 80001524 <printf>
    struct inode *ip = namei("/readme.txt");
    800026a4:	00003517          	auipc	a0,0x3
    800026a8:	fd450513          	addi	a0,a0,-44 # 80005678 <digits+0x4e0>
    800026ac:	00001097          	auipc	ra,0x1
    800026b0:	eea080e7          	jalr	-278(ra) # 80003596 <namei>
    800026b4:	84aa                	mv	s1,a0
    printf("bb\n");
    800026b6:	00003517          	auipc	a0,0x3
    800026ba:	fd250513          	addi	a0,a0,-46 # 80005688 <digits+0x4f0>
    800026be:	fffff097          	auipc	ra,0xfffff
    800026c2:	e66080e7          	jalr	-410(ra) # 80001524 <printf>
    lock_inode(ip);
    800026c6:	8526                	mv	a0,s1
    800026c8:	00001097          	auipc	ra,0x1
    800026cc:	976080e7          	jalr	-1674(ra) # 8000303e <lock_inode>
    read_inode(ip, (uint64)str, off, 1024);
    800026d0:	40000693          	li	a3,1024
    800026d4:	4601                	li	a2,0
    800026d6:	be040593          	addi	a1,s0,-1056
    800026da:	8526                	mv	a0,s1
    800026dc:	00001097          	auipc	ra,0x1
    800026e0:	a96080e7          	jalr	-1386(ra) # 80003172 <read_inode>
    printf("%s\n",str);
    800026e4:	be040593          	addi	a1,s0,-1056
    800026e8:	00003517          	auipc	a0,0x3
    800026ec:	a8050513          	addi	a0,a0,-1408 # 80005168 <etext+0x168>
    800026f0:	fffff097          	auipc	ra,0xfffff
    800026f4:	e34080e7          	jalr	-460(ra) # 80001524 <printf>
    unlock_inode(ip);
    800026f8:	8526                	mv	a0,s1
    800026fa:	00001097          	auipc	ra,0x1
    800026fe:	a0a080e7          	jalr	-1526(ra) # 80003104 <unlock_inode>
}
    80002702:	41813083          	ld	ra,1048(sp)
    80002706:	41013403          	ld	s0,1040(sp)
    8000270a:	40813483          	ld	s1,1032(sp)
    8000270e:	42010113          	addi	sp,sp,1056
    80002712:	8082                	ret

0000000080002714 <loadseg>:
 * @param ip 该可执行文件的inode
 * @param offset
 * @param sz 段在文件中的偏移量
 * @return 是否成功
 */
static int loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz) {
    80002714:	715d                	addi	sp,sp,-80
    80002716:	e486                	sd	ra,72(sp)
    80002718:	e0a2                	sd	s0,64(sp)
    8000271a:	fc26                	sd	s1,56(sp)
    8000271c:	f84a                	sd	s2,48(sp)
    8000271e:	f44e                	sd	s3,40(sp)
    80002720:	f052                	sd	s4,32(sp)
    80002722:	ec56                	sd	s5,24(sp)
    80002724:	e85a                	sd	s6,16(sp)
    80002726:	e45e                	sd	s7,8(sp)
    80002728:	e062                	sd	s8,0(sp)
    8000272a:	0880                	addi	s0,sp,80
    8000272c:	8b2a                	mv	s6,a0
    8000272e:	8aae                	mv	s5,a1
    80002730:	8bb2                	mv	s7,a2
    80002732:	8c36                	mv	s8,a3
    80002734:	8a3a                	mv	s4,a4
    uint i, n;
    uint64 pa;

    if ((va % PGSIZE) != 0)
    80002736:	6785                	lui	a5,0x1
    80002738:	17fd                	addi	a5,a5,-1
    8000273a:	8fed                	and	a5,a5,a1
    8000273c:	e399                	bnez	a5,80002742 <loadseg+0x2e>
        if (pa == 0)
            panic("loadseg: address should exist");
        if (sz - i < PGSIZE)
            n = sz - i;
        else
            n = PGSIZE;
    8000273e:	4481                	li	s1,0
    80002740:	a089                	j	80002782 <loadseg+0x6e>
        panic("loadseg: va must be page aligned");
    80002742:	00003517          	auipc	a0,0x3
    80002746:	f4e50513          	addi	a0,a0,-178 # 80005690 <digits+0x4f8>
    8000274a:	fffff097          	auipc	ra,0xfffff
    8000274e:	e92080e7          	jalr	-366(ra) # 800015dc <panic>
    80002752:	b7f5                	j	8000273e <loadseg+0x2a>
            panic("loadseg: address should exist");
    80002754:	00003517          	auipc	a0,0x3
    80002758:	f6450513          	addi	a0,a0,-156 # 800056b8 <digits+0x520>
    8000275c:	fffff097          	auipc	ra,0xfffff
    80002760:	e80080e7          	jalr	-384(ra) # 800015dc <panic>
    80002764:	a825                	j	8000279c <loadseg+0x88>
        if (read_inode(ip, (uint64) pa, offset + i, n) != n)
    80002766:	86ce                	mv	a3,s3
    80002768:	0184863b          	addw	a2,s1,s8
    8000276c:	85ca                	mv	a1,s2
    8000276e:	855e                	mv	a0,s7
    80002770:	00001097          	auipc	ra,0x1
    80002774:	a02080e7          	jalr	-1534(ra) # 80003172 <read_inode>
    80002778:	2501                	sext.w	a0,a0
    8000277a:	05351563          	bne	a0,s3,800027c4 <loadseg+0xb0>
    for (i = 0; i < sz; i += PGSIZE) {
    8000277e:	6785                	lui	a5,0x1
    80002780:	9cbd                	addw	s1,s1,a5
    80002782:	0344f463          	bgeu	s1,s4,800027aa <loadseg+0x96>
        pa = walkaddr(pagetable, va + i);
    80002786:	02049593          	slli	a1,s1,0x20
    8000278a:	9181                	srli	a1,a1,0x20
    8000278c:	95d6                	add	a1,a1,s5
    8000278e:	855a                	mv	a0,s6
    80002790:	fffff097          	auipc	ra,0xfffff
    80002794:	55e080e7          	jalr	1374(ra) # 80001cee <walkaddr>
    80002798:	892a                	mv	s2,a0
        if (pa == 0)
    8000279a:	dd4d                	beqz	a0,80002754 <loadseg+0x40>
        if (sz - i < PGSIZE)
    8000279c:	409a09bb          	subw	s3,s4,s1
    800027a0:	6785                	lui	a5,0x1
    800027a2:	fcf9e2e3          	bltu	s3,a5,80002766 <loadseg+0x52>
            n = PGSIZE;
    800027a6:	6985                	lui	s3,0x1
    800027a8:	bf7d                	j	80002766 <loadseg+0x52>
            return -1;
    }

    return 0;
    800027aa:	4501                	li	a0,0
}
    800027ac:	60a6                	ld	ra,72(sp)
    800027ae:	6406                	ld	s0,64(sp)
    800027b0:	74e2                	ld	s1,56(sp)
    800027b2:	7942                	ld	s2,48(sp)
    800027b4:	79a2                	ld	s3,40(sp)
    800027b6:	7a02                	ld	s4,32(sp)
    800027b8:	6ae2                	ld	s5,24(sp)
    800027ba:	6b42                	ld	s6,16(sp)
    800027bc:	6ba2                	ld	s7,8(sp)
    800027be:	6c02                	ld	s8,0(sp)
    800027c0:	6161                	addi	sp,sp,80
    800027c2:	8082                	ret
            return -1;
    800027c4:	557d                	li	a0,-1
    800027c6:	b7dd                	j	800027ac <loadseg+0x98>

00000000800027c8 <exec0>:
struct proc *exec0(char *path, char **argv) {
    800027c8:	7131                	addi	sp,sp,-192
    800027ca:	fd06                	sd	ra,184(sp)
    800027cc:	f922                	sd	s0,176(sp)
    800027ce:	f526                	sd	s1,168(sp)
    800027d0:	f14a                	sd	s2,160(sp)
    800027d2:	ed4e                	sd	s3,152(sp)
    800027d4:	e952                	sd	s4,144(sp)
    800027d6:	e556                	sd	s5,136(sp)
    800027d8:	e15a                	sd	s6,128(sp)
    800027da:	0180                	addi	s0,sp,192
    800027dc:	84aa                	mv	s1,a0
    struct proc *p = alloc_proc();
    800027de:	ffffe097          	auipc	ra,0xffffe
    800027e2:	06a080e7          	jalr	106(ra) # 80000848 <alloc_proc>
    800027e6:	8b2a                	mv	s6,a0
    if((pagetable = proc_pagetable(p))==0){
    800027e8:	ffffe097          	auipc	ra,0xffffe
    800027ec:	13a080e7          	jalr	314(ra) # 80000922 <proc_pagetable>
    800027f0:	8aaa                	mv	s5,a0
    800027f2:	c16d                	beqz	a0,800028d4 <exec0+0x10c>
    if ((ip = namei(path)) == 0) {
    800027f4:	8526                	mv	a0,s1
    800027f6:	00001097          	auipc	ra,0x1
    800027fa:	da0080e7          	jalr	-608(ra) # 80003596 <namei>
    800027fe:	89aa                	mv	s3,a0
    80002800:	12050463          	beqz	a0,80002928 <exec0+0x160>
    lock_inode(ip);
    80002804:	00001097          	auipc	ra,0x1
    80002808:	83a080e7          	jalr	-1990(ra) # 8000303e <lock_inode>
    if (read_inode(ip, (uint64) &elf, 0, sizeof(elf)) != sizeof(elf))
    8000280c:	04000693          	li	a3,64
    80002810:	4601                	li	a2,0
    80002812:	f8040593          	addi	a1,s0,-128
    80002816:	854e                	mv	a0,s3
    80002818:	00001097          	auipc	ra,0x1
    8000281c:	95a080e7          	jalr	-1702(ra) # 80003172 <read_inode>
    80002820:	04000793          	li	a5,64
    80002824:	08f51f63          	bne	a0,a5,800028c2 <exec0+0xfa>
    if (elf.magic != ELF_MAGIC)
    80002828:	f8042703          	lw	a4,-128(s0)
    8000282c:	464c47b7          	lui	a5,0x464c4
    80002830:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80002834:	08f71763          	bne	a4,a5,800028c2 <exec0+0xfa>
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80002838:	fa042483          	lw	s1,-96(s0)
    uint64 sz = 0;
    8000283c:	4a01                	li	s4,0
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    8000283e:	4901                	li	s2,0
    80002840:	a021                	j	80002848 <exec0+0x80>
    80002842:	2905                	addiw	s2,s2,1
    80002844:	0384849b          	addiw	s1,s1,56
    80002848:	fb845783          	lhu	a5,-72(s0)
    8000284c:	08f95f63          	bge	s2,a5,800028ea <exec0+0x122>
        if (read_inode(ip, (uint64) &ph, off, sizeof(ph)) != sizeof(ph))
    80002850:	2481                	sext.w	s1,s1
    80002852:	03800693          	li	a3,56
    80002856:	8626                	mv	a2,s1
    80002858:	f4840593          	addi	a1,s0,-184
    8000285c:	854e                	mv	a0,s3
    8000285e:	00001097          	auipc	ra,0x1
    80002862:	914080e7          	jalr	-1772(ra) # 80003172 <read_inode>
    80002866:	03800793          	li	a5,56
    8000286a:	04f51c63          	bne	a0,a5,800028c2 <exec0+0xfa>
        if (ph.type != ELF_PROG_LOAD)
    8000286e:	f4842703          	lw	a4,-184(s0)
    80002872:	4785                	li	a5,1
    80002874:	fcf717e3          	bne	a4,a5,80002842 <exec0+0x7a>
        if (ph.memsz < ph.filesz)
    80002878:	f7043603          	ld	a2,-144(s0)
    8000287c:	f6843783          	ld	a5,-152(s0)
    80002880:	04f66163          	bltu	a2,a5,800028c2 <exec0+0xfa>
        if (ph.vaddr + ph.memsz < ph.vaddr)
    80002884:	f5843783          	ld	a5,-168(s0)
    80002888:	963e                	add	a2,a2,a5
    8000288a:	02f66c63          	bltu	a2,a5,800028c2 <exec0+0xfa>
        if ((sz1 = user_vm_alloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000288e:	85d2                	mv	a1,s4
    80002890:	8556                	mv	a0,s5
    80002892:	fffff097          	auipc	ra,0xfffff
    80002896:	5a2080e7          	jalr	1442(ra) # 80001e34 <user_vm_alloc>
    8000289a:	8a2a                	mv	s4,a0
    8000289c:	c11d                	beqz	a0,800028c2 <exec0+0xfa>
        if (ph.vaddr % PGSIZE != 0)
    8000289e:	f5843583          	ld	a1,-168(s0)
    800028a2:	6785                	lui	a5,0x1
    800028a4:	17fd                	addi	a5,a5,-1
    800028a6:	8fed                	and	a5,a5,a1
    800028a8:	ef89                	bnez	a5,800028c2 <exec0+0xfa>
        if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800028aa:	f6842703          	lw	a4,-152(s0)
    800028ae:	f5042683          	lw	a3,-176(s0)
    800028b2:	864e                	mv	a2,s3
    800028b4:	8556                	mv	a0,s5
    800028b6:	00000097          	auipc	ra,0x0
    800028ba:	e5e080e7          	jalr	-418(ra) # 80002714 <loadseg>
    800028be:	f80552e3          	bgez	a0,80002842 <exec0+0x7a>
    panic("exec");
    800028c2:	00003517          	auipc	a0,0x3
    800028c6:	83e50513          	addi	a0,a0,-1986 # 80005100 <etext+0x100>
    800028ca:	fffff097          	auipc	ra,0xfffff
    800028ce:	d12080e7          	jalr	-750(ra) # 800015dc <panic>
    return 0;
    800028d2:	4a81                	li	s5,0
}
    800028d4:	8556                	mv	a0,s5
    800028d6:	70ea                	ld	ra,184(sp)
    800028d8:	744a                	ld	s0,176(sp)
    800028da:	74aa                	ld	s1,168(sp)
    800028dc:	790a                	ld	s2,160(sp)
    800028de:	69ea                	ld	s3,152(sp)
    800028e0:	6a4a                	ld	s4,144(sp)
    800028e2:	6aaa                	ld	s5,136(sp)
    800028e4:	6b0a                	ld	s6,128(sp)
    800028e6:	6129                	addi	sp,sp,192
    800028e8:	8082                	ret
    unlock_and_putback(ip);
    800028ea:	854e                	mv	a0,s3
    800028ec:	00001097          	auipc	ra,0x1
    800028f0:	85e080e7          	jalr	-1954(ra) # 8000314a <unlock_and_putback>
    sz = PGROUNDUP(sz);
    800028f4:	6605                	lui	a2,0x1
    800028f6:	fff60593          	addi	a1,a2,-1 # fff <_entry-0x7ffff001>
    800028fa:	9a2e                	add	s4,s4,a1
    800028fc:	75fd                	lui	a1,0xfffff
    800028fe:	00ba75b3          	and	a1,s4,a1
    if ((sz1 = user_vm_alloc(pagetable, sz, sz+PGSIZE)) == 0)
    80002902:	962e                	add	a2,a2,a1
    80002904:	8556                	mv	a0,s5
    80002906:	fffff097          	auipc	ra,0xfffff
    8000290a:	52e080e7          	jalr	1326(ra) # 80001e34 <user_vm_alloc>
    8000290e:	d955                	beqz	a0,800028c2 <exec0+0xfa>
    p->pagetable = pagetable;
    80002910:	055b3423          	sd	s5,72(s6)
    p->trapframe->epc = elf.entry;
    80002914:	040b3783          	ld	a5,64(s6)
    80002918:	f9843703          	ld	a4,-104(s0)
    8000291c:	ef98                	sd	a4,24(a5)
    p->trapframe->sp = sz;
    8000291e:	040b3783          	ld	a5,64(s6)
    80002922:	fb88                	sd	a0,48(a5)
    return p;
    80002924:	8ada                	mv	s5,s6
    80002926:	b77d                	j	800028d4 <exec0+0x10c>
        return 0;
    80002928:	8aaa                	mv	s5,a0
    8000292a:	b76d                	j	800028d4 <exec0+0x10c>

000000008000292c <skipelem>:
//   skipelem("a/bb/c", name) = "bb/c", setting name = "a"
//   skipelem("///a//bb", name) = "bb", setting name = "a"
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char *skipelem(char *path, char *name) {
    8000292c:	7179                	addi	sp,sp,-48
    8000292e:	f406                	sd	ra,40(sp)
    80002930:	f022                	sd	s0,32(sp)
    80002932:	ec26                	sd	s1,24(sp)
    80002934:	e84a                	sd	s2,16(sp)
    80002936:	e44e                	sd	s3,8(sp)
    80002938:	1800                	addi	s0,sp,48
    8000293a:	892e                	mv	s2,a1
    char *s;
    int len;

    while (*path == '/')
    8000293c:	00054783          	lbu	a5,0(a0)
    80002940:	02f00713          	li	a4,47
    80002944:	00e79463          	bne	a5,a4,8000294c <skipelem+0x20>
        path++;
    80002948:	0505                	addi	a0,a0,1
    8000294a:	bfcd                	j	8000293c <skipelem+0x10>
    if (*path == 0)
    8000294c:	c3b5                	beqz	a5,800029b0 <skipelem+0x84>
    8000294e:	84aa                	mv	s1,a0
    80002950:	a011                	j	80002954 <skipelem+0x28>
        return 0;
    s = path;
    while (*path != '/' && *path != 0)
        path++;
    80002952:	0485                	addi	s1,s1,1
    while (*path != '/' && *path != 0)
    80002954:	0004c783          	lbu	a5,0(s1)
    80002958:	02f00713          	li	a4,47
    8000295c:	00e78363          	beq	a5,a4,80002962 <skipelem+0x36>
    80002960:	fbed                	bnez	a5,80002952 <skipelem+0x26>
    len = path - s;
    80002962:	40a489bb          	subw	s3,s1,a0
    if (len >= DIRSIZ)
    80002966:	47b5                	li	a5,13
    80002968:	0137da63          	bge	a5,s3,8000297c <skipelem+0x50>
        memmove(name, s, DIRSIZ);
    8000296c:	4639                	li	a2,14
    8000296e:	85aa                	mv	a1,a0
    80002970:	854a                	mv	a0,s2
    80002972:	ffffe097          	auipc	ra,0xffffe
    80002976:	672080e7          	jalr	1650(ra) # 80000fe4 <memmove>
    8000297a:	a829                	j	80002994 <skipelem+0x68>
    else {
        memmove(name, s, len);
    8000297c:	864e                	mv	a2,s3
    8000297e:	85aa                	mv	a1,a0
    80002980:	854a                	mv	a0,s2
    80002982:	ffffe097          	auipc	ra,0xffffe
    80002986:	662080e7          	jalr	1634(ra) # 80000fe4 <memmove>
        name[len] = 0;
    8000298a:	994e                	add	s2,s2,s3
    8000298c:	00090023          	sb	zero,0(s2)
    80002990:	a011                	j	80002994 <skipelem+0x68>
    }
    while (*path == '/')
        path++;
    80002992:	0485                	addi	s1,s1,1
    while (*path == '/')
    80002994:	0004c703          	lbu	a4,0(s1)
    80002998:	02f00793          	li	a5,47
    8000299c:	fef70be3          	beq	a4,a5,80002992 <skipelem+0x66>
    return path;
}
    800029a0:	8526                	mv	a0,s1
    800029a2:	70a2                	ld	ra,40(sp)
    800029a4:	7402                	ld	s0,32(sp)
    800029a6:	64e2                	ld	s1,24(sp)
    800029a8:	6942                	ld	s2,16(sp)
    800029aa:	69a2                	ld	s3,8(sp)
    800029ac:	6145                	addi	sp,sp,48
    800029ae:	8082                	ret
        return 0;
    800029b0:	4481                	li	s1,0
    800029b2:	b7fd                	j	800029a0 <skipelem+0x74>

00000000800029b4 <read_superblock>:
void read_superblock(struct superblock *sb) {
    800029b4:	b9010113          	addi	sp,sp,-1136
    800029b8:	46113423          	sd	ra,1128(sp)
    800029bc:	46813023          	sd	s0,1120(sp)
    800029c0:	44913c23          	sd	s1,1112(sp)
    800029c4:	47010413          	addi	s0,sp,1136
    800029c8:	84aa                	mv	s1,a0
    b.blockno = 1;
    800029ca:	4785                	li	a5,1
    800029cc:	b8f42e23          	sw	a5,-1124(s0)
    virtio_disk_rw(&b, 0);
    800029d0:	4581                	li	a1,0
    800029d2:	b9040513          	addi	a0,s0,-1136
    800029d6:	00000097          	auipc	ra,0x0
    800029da:	918080e7          	jalr	-1768(ra) # 800022ee <virtio_disk_rw>
    memmove(sb, &b.data, sizeof(*sb));
    800029de:	4661                	li	a2,24
    800029e0:	bdc40593          	addi	a1,s0,-1060
    800029e4:	8526                	mv	a0,s1
    800029e6:	ffffe097          	auipc	ra,0xffffe
    800029ea:	5fe080e7          	jalr	1534(ra) # 80000fe4 <memmove>
}
    800029ee:	46813083          	ld	ra,1128(sp)
    800029f2:	46013403          	ld	s0,1120(sp)
    800029f6:	45813483          	ld	s1,1112(sp)
    800029fa:	47010113          	addi	sp,sp,1136
    800029fe:	8082                	ret

0000000080002a00 <init_fs>:
void init_fs() {
    80002a00:	1101                	addi	sp,sp,-32
    80002a02:	ec06                	sd	ra,24(sp)
    80002a04:	e822                	sd	s0,16(sp)
    80002a06:	e426                	sd	s1,8(sp)
    80002a08:	1000                	addi	s0,sp,32
    read_superblock(&sb);
    80002a0a:	0004c497          	auipc	s1,0x4c
    80002a0e:	5f648493          	addi	s1,s1,1526 # 8004f000 <sb>
    80002a12:	8526                	mv	a0,s1
    80002a14:	00000097          	auipc	ra,0x0
    80002a18:	fa0080e7          	jalr	-96(ra) # 800029b4 <read_superblock>
    if (sb.magic != FSMAGIC) {
    80002a1c:	4098                	lw	a4,0(s1)
    80002a1e:	102037b7          	lui	a5,0x10203
    80002a22:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a26:	00f71763          	bne	a4,a5,80002a34 <init_fs+0x34>
}
    80002a2a:	60e2                	ld	ra,24(sp)
    80002a2c:	6442                	ld	s0,16(sp)
    80002a2e:	64a2                	ld	s1,8(sp)
    80002a30:	6105                	addi	sp,sp,32
    80002a32:	8082                	ret
        panic("fs init");
    80002a34:	00003517          	auipc	a0,0x3
    80002a38:	ca450513          	addi	a0,a0,-860 # 800056d8 <digits+0x540>
    80002a3c:	fffff097          	auipc	ra,0xfffff
    80002a40:	ba0080e7          	jalr	-1120(ra) # 800015dc <panic>
}
    80002a44:	b7dd                	j	80002a2a <init_fs+0x2a>

0000000080002a46 <zero_block>:
void zero_block(int blockno) {
    80002a46:	1101                	addi	sp,sp,-32
    80002a48:	ec06                	sd	ra,24(sp)
    80002a4a:	e822                	sd	s0,16(sp)
    80002a4c:	e426                	sd	s1,8(sp)
    80002a4e:	1000                	addi	s0,sp,32
    80002a50:	85aa                	mv	a1,a0
    bp = buf_read(0, blockno);
    80002a52:	4501                	li	a0,0
    80002a54:	00001097          	auipc	ra,0x1
    80002a58:	cb6080e7          	jalr	-842(ra) # 8000370a <buf_read>
    80002a5c:	84aa                	mv	s1,a0
    memset(bp->data, 0, BSIZE);
    80002a5e:	40000613          	li	a2,1024
    80002a62:	4581                	li	a1,0
    80002a64:	04c50513          	addi	a0,a0,76
    80002a68:	ffffe097          	auipc	ra,0xffffe
    80002a6c:	55a080e7          	jalr	1370(ra) # 80000fc2 <memset>
    buf_write(bp);
    80002a70:	8526                	mv	a0,s1
    80002a72:	00001097          	auipc	ra,0x1
    80002a76:	ccc080e7          	jalr	-820(ra) # 8000373e <buf_write>
    relse_buf(bp);
    80002a7a:	8526                	mv	a0,s1
    80002a7c:	00001097          	auipc	ra,0x1
    80002a80:	cdc080e7          	jalr	-804(ra) # 80003758 <relse_buf>
}
    80002a84:	60e2                	ld	ra,24(sp)
    80002a86:	6442                	ld	s0,16(sp)
    80002a88:	64a2                	ld	s1,8(sp)
    80002a8a:	6105                	addi	sp,sp,32
    80002a8c:	8082                	ret

0000000080002a8e <alloc_disk_block>:
uint alloc_disk_block() {
    80002a8e:	7179                	addi	sp,sp,-48
    80002a90:	f406                	sd	ra,40(sp)
    80002a92:	f022                	sd	s0,32(sp)
    80002a94:	ec26                	sd	s1,24(sp)
    80002a96:	e84a                	sd	s2,16(sp)
    80002a98:	e44e                	sd	s3,8(sp)
    80002a9a:	1800                	addi	s0,sp,48
    for (b = 0; b < sb.size; b += BPB) { // 遍历bitmap
    80002a9c:	4981                	li	s3,0
    80002a9e:	a82d                	j	80002ad8 <alloc_disk_block+0x4a>
                bitmap->data[bi / 8] |= m; // 标记块被使用
    80002aa0:	972a                	add	a4,a4,a0
    80002aa2:	8ed1                	or	a3,a3,a2
    80002aa4:	04d70623          	sb	a3,76(a4)
                relse_buf(bitmap);
    80002aa8:	00001097          	auipc	ra,0x1
    80002aac:	cb0080e7          	jalr	-848(ra) # 80003758 <relse_buf>
                zero_block(b + bi);
    80002ab0:	854a                	mv	a0,s2
    80002ab2:	00000097          	auipc	ra,0x0
    80002ab6:	f94080e7          	jalr	-108(ra) # 80002a46 <zero_block>
}
    80002aba:	8526                	mv	a0,s1
    80002abc:	70a2                	ld	ra,40(sp)
    80002abe:	7402                	ld	s0,32(sp)
    80002ac0:	64e2                	ld	s1,24(sp)
    80002ac2:	6942                	ld	s2,16(sp)
    80002ac4:	69a2                	ld	s3,8(sp)
    80002ac6:	6145                	addi	sp,sp,48
    80002ac8:	8082                	ret
        relse_buf(bitmap);
    80002aca:	00001097          	auipc	ra,0x1
    80002ace:	c8e080e7          	jalr	-882(ra) # 80003758 <relse_buf>
    for (b = 0; b < sb.size; b += BPB) { // 遍历bitmap
    80002ad2:	6789                	lui	a5,0x2
    80002ad4:	013789bb          	addw	s3,a5,s3
    80002ad8:	0004c717          	auipc	a4,0x4c
    80002adc:	52c72703          	lw	a4,1324(a4) # 8004f004 <sb+0x4>
    80002ae0:	0009879b          	sext.w	a5,s3
    80002ae4:	06e7fa63          	bgeu	a5,a4,80002b58 <alloc_disk_block+0xca>
        bitmap = buf_read(0, BBLOCK(b, sb));
    80002ae8:	41f9d79b          	sraiw	a5,s3,0x1f
    80002aec:	0137d79b          	srliw	a5,a5,0x13
    80002af0:	013787bb          	addw	a5,a5,s3
    80002af4:	40d7d79b          	sraiw	a5,a5,0xd
    80002af8:	0004c597          	auipc	a1,0x4c
    80002afc:	51c5a583          	lw	a1,1308(a1) # 8004f014 <sb+0x14>
    80002b00:	9dbd                	addw	a1,a1,a5
    80002b02:	4501                	li	a0,0
    80002b04:	00001097          	auipc	ra,0x1
    80002b08:	c06080e7          	jalr	-1018(ra) # 8000370a <buf_read>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) { //遍历bitmap的每一位
    80002b0c:	4781                	li	a5,0
    80002b0e:	6709                	lui	a4,0x2
    80002b10:	fae7dde3          	bge	a5,a4,80002aca <alloc_disk_block+0x3c>
    80002b14:	00f984bb          	addw	s1,s3,a5
    80002b18:	0004891b          	sext.w	s2,s1
    80002b1c:	84ca                	mv	s1,s2
    80002b1e:	0004c717          	auipc	a4,0x4c
    80002b22:	4e672703          	lw	a4,1254(a4) # 8004f004 <sb+0x4>
    80002b26:	fae972e3          	bgeu	s2,a4,80002aca <alloc_disk_block+0x3c>
            m = 1 << (bi % 8);
    80002b2a:	41f7d69b          	sraiw	a3,a5,0x1f
    80002b2e:	01d6d69b          	srliw	a3,a3,0x1d
    80002b32:	00f6873b          	addw	a4,a3,a5
    80002b36:	00777613          	andi	a2,a4,7
    80002b3a:	9e15                	subw	a2,a2,a3
    80002b3c:	4685                	li	a3,1
    80002b3e:	00c696bb          	sllw	a3,a3,a2
            if ((bitmap->data[bi / 8] & m) == 0) { // 判断块是否被使用
    80002b42:	4037571b          	sraiw	a4,a4,0x3
    80002b46:	00e50633          	add	a2,a0,a4
    80002b4a:	04c64603          	lbu	a2,76(a2)
    80002b4e:	00d675b3          	and	a1,a2,a3
    80002b52:	d5b9                	beqz	a1,80002aa0 <alloc_disk_block+0x12>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) { //遍历bitmap的每一位
    80002b54:	2785                	addiw	a5,a5,1
    80002b56:	bf65                	j	80002b0e <alloc_disk_block+0x80>
    panic("balloc: out of blocks");
    80002b58:	00003517          	auipc	a0,0x3
    80002b5c:	b8850513          	addi	a0,a0,-1144 # 800056e0 <digits+0x548>
    80002b60:	fffff097          	auipc	ra,0xfffff
    80002b64:	a7c080e7          	jalr	-1412(ra) # 800015dc <panic>
    return 0;
    80002b68:	4481                	li	s1,0
    80002b6a:	bf81                	j	80002aba <alloc_disk_block+0x2c>

0000000080002b6c <free_disk_block>:
void free_disk_block(int blockno) {
    80002b6c:	1101                	addi	sp,sp,-32
    80002b6e:	ec06                	sd	ra,24(sp)
    80002b70:	e822                	sd	s0,16(sp)
    80002b72:	e426                	sd	s1,8(sp)
    80002b74:	e04a                	sd	s2,0(sp)
    80002b76:	1000                	addi	s0,sp,32
    bitmap = buf_read(0, BBLOCK(blockno, sb));
    80002b78:	41f5549b          	sraiw	s1,a0,0x1f
    80002b7c:	0134d91b          	srliw	s2,s1,0x13
    80002b80:	00a904bb          	addw	s1,s2,a0
    80002b84:	40d4d59b          	sraiw	a1,s1,0xd
    80002b88:	0004c797          	auipc	a5,0x4c
    80002b8c:	48c7a783          	lw	a5,1164(a5) # 8004f014 <sb+0x14>
    80002b90:	9dbd                	addw	a1,a1,a5
    80002b92:	4501                	li	a0,0
    80002b94:	00001097          	auipc	ra,0x1
    80002b98:	b76080e7          	jalr	-1162(ra) # 8000370a <buf_read>
    bi = blockno % BPB;
    80002b9c:	6789                	lui	a5,0x2
    80002b9e:	17fd                	addi	a5,a5,-1
    80002ba0:	8cfd                	and	s1,s1,a5
    80002ba2:	412484bb          	subw	s1,s1,s2
    m = 1 << (bi % 8);
    80002ba6:	41f4d79b          	sraiw	a5,s1,0x1f
    80002baa:	01d7d79b          	srliw	a5,a5,0x1d
    80002bae:	9cbd                	addw	s1,s1,a5
    80002bb0:	0074f713          	andi	a4,s1,7
    80002bb4:	9f1d                	subw	a4,a4,a5
    80002bb6:	4785                	li	a5,1
    80002bb8:	00e797bb          	sllw	a5,a5,a4
    bitmap->data[bi / 8] &= ~m;
    80002bbc:	4034d49b          	sraiw	s1,s1,0x3
    80002bc0:	94aa                	add	s1,s1,a0
    80002bc2:	fff7c793          	not	a5,a5
    80002bc6:	04c4c703          	lbu	a4,76(s1)
    80002bca:	8ff9                	and	a5,a5,a4
    80002bcc:	04f48623          	sb	a5,76(s1)
    relse_buf(bitmap);
    80002bd0:	00001097          	auipc	ra,0x1
    80002bd4:	b88080e7          	jalr	-1144(ra) # 80003758 <relse_buf>
}
    80002bd8:	60e2                	ld	ra,24(sp)
    80002bda:	6442                	ld	s0,16(sp)
    80002bdc:	64a2                	ld	s1,8(sp)
    80002bde:	6902                	ld	s2,0(sp)
    80002be0:	6105                	addi	sp,sp,32
    80002be2:	8082                	ret

0000000080002be4 <init_inode_cache>:
void init_inode_cache() {
    80002be4:	1101                	addi	sp,sp,-32
    80002be6:	ec06                	sd	ra,24(sp)
    80002be8:	e822                	sd	s0,16(sp)
    80002bea:	e426                	sd	s1,8(sp)
    80002bec:	1000                	addi	s0,sp,32
    spinlock_init(&inode_cache.lock, "inode cache");
    80002bee:	00003597          	auipc	a1,0x3
    80002bf2:	b0a58593          	addi	a1,a1,-1270 # 800056f8 <digits+0x560>
    80002bf6:	0004c517          	auipc	a0,0x4c
    80002bfa:	42250513          	addi	a0,a0,1058 # 8004f018 <inode_cache>
    80002bfe:	00001097          	auipc	ra,0x1
    80002c02:	bac080e7          	jalr	-1108(ra) # 800037aa <spinlock_init>
    for (int i = 0; i < NINODE; i++) {
    80002c06:	4481                	li	s1,0
    80002c08:	03100793          	li	a5,49
    80002c0c:	0297c963          	blt	a5,s1,80002c3e <init_inode_cache+0x5a>
        sleeplock_init(&inode_cache.inode[i].lock, "inode");
    80002c10:	00449793          	slli	a5,s1,0x4
    80002c14:	97a6                	add	a5,a5,s1
    80002c16:	00379513          	slli	a0,a5,0x3
    80002c1a:	02050513          	addi	a0,a0,32
    80002c1e:	0004c797          	auipc	a5,0x4c
    80002c22:	3fa78793          	addi	a5,a5,1018 # 8004f018 <inode_cache>
    80002c26:	953e                	add	a0,a0,a5
    80002c28:	00003597          	auipc	a1,0x3
    80002c2c:	ae058593          	addi	a1,a1,-1312 # 80005708 <digits+0x570>
    80002c30:	0521                	addi	a0,a0,8
    80002c32:	00001097          	auipc	ra,0x1
    80002c36:	d3a080e7          	jalr	-710(ra) # 8000396c <sleeplock_init>
    for (int i = 0; i < NINODE; i++) {
    80002c3a:	2485                	addiw	s1,s1,1
    80002c3c:	b7f1                	j	80002c08 <init_inode_cache+0x24>
}
    80002c3e:	60e2                	ld	ra,24(sp)
    80002c40:	6442                	ld	s0,16(sp)
    80002c42:	64a2                	ld	s1,8(sp)
    80002c44:	6105                	addi	sp,sp,32
    80002c46:	8082                	ret

0000000080002c48 <update_inode>:
void update_inode(struct inode *ip) {
    80002c48:	1101                	addi	sp,sp,-32
    80002c4a:	ec06                	sd	ra,24(sp)
    80002c4c:	e822                	sd	s0,16(sp)
    80002c4e:	e426                	sd	s1,8(sp)
    80002c50:	e04a                	sd	s2,0(sp)
    80002c52:	1000                	addi	s0,sp,32
    80002c54:	84aa                	mv	s1,a0
    bp = buf_read(ip->dev, IBLOCK(ip->inum, sb));
    80002c56:	415c                	lw	a5,4(a0)
    80002c58:	0004c597          	auipc	a1,0x4c
    80002c5c:	3b85a583          	lw	a1,952(a1) # 8004f010 <sb+0x10>
    80002c60:	0047d79b          	srliw	a5,a5,0x4
    80002c64:	9dbd                	addw	a1,a1,a5
    80002c66:	4108                	lw	a0,0(a0)
    80002c68:	00001097          	auipc	ra,0x1
    80002c6c:	aa2080e7          	jalr	-1374(ra) # 8000370a <buf_read>
    80002c70:	892a                	mv	s2,a0
    dip = (struct dinode *) bp->data + ip->inum % IPB;
    80002c72:	04c50793          	addi	a5,a0,76
    80002c76:	40c8                	lw	a0,4(s1)
    80002c78:	893d                	andi	a0,a0,15
    80002c7a:	051a                	slli	a0,a0,0x6
    80002c7c:	953e                	add	a0,a0,a5
    dip->type = ip->type;
    80002c7e:	04449703          	lh	a4,68(s1)
    80002c82:	00e51023          	sh	a4,0(a0)
    dip->major = ip->major;
    80002c86:	04649703          	lh	a4,70(s1)
    80002c8a:	00e51123          	sh	a4,2(a0)
    dip->minor = ip->minor;
    80002c8e:	04849703          	lh	a4,72(s1)
    80002c92:	00e51223          	sh	a4,4(a0)
    dip->nlink = ip->nlink;
    80002c96:	04a49703          	lh	a4,74(s1)
    80002c9a:	00e51323          	sh	a4,6(a0)
    dip->size = ip->size;
    80002c9e:	44f8                	lw	a4,76(s1)
    80002ca0:	c518                	sw	a4,8(a0)
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002ca2:	03400613          	li	a2,52
    80002ca6:	05048593          	addi	a1,s1,80
    80002caa:	0531                	addi	a0,a0,12
    80002cac:	ffffe097          	auipc	ra,0xffffe
    80002cb0:	338080e7          	jalr	824(ra) # 80000fe4 <memmove>
    buf_write(bp);
    80002cb4:	854a                	mv	a0,s2
    80002cb6:	00001097          	auipc	ra,0x1
    80002cba:	a88080e7          	jalr	-1400(ra) # 8000373e <buf_write>
    relse_buf(bp);
    80002cbe:	854a                	mv	a0,s2
    80002cc0:	00001097          	auipc	ra,0x1
    80002cc4:	a98080e7          	jalr	-1384(ra) # 80003758 <relse_buf>
}
    80002cc8:	60e2                	ld	ra,24(sp)
    80002cca:	6442                	ld	s0,16(sp)
    80002ccc:	64a2                	ld	s1,8(sp)
    80002cce:	6902                	ld	s2,0(sp)
    80002cd0:	6105                	addi	sp,sp,32
    80002cd2:	8082                	ret

0000000080002cd4 <get_inode>:
struct inode *get_inode(int inum) {
    80002cd4:	7179                	addi	sp,sp,-48
    80002cd6:	f406                	sd	ra,40(sp)
    80002cd8:	f022                	sd	s0,32(sp)
    80002cda:	ec26                	sd	s1,24(sp)
    80002cdc:	e84a                	sd	s2,16(sp)
    80002cde:	e44e                	sd	s3,8(sp)
    80002ce0:	1800                	addi	s0,sp,48
    80002ce2:	89aa                	mv	s3,a0
    spin_lock(&inode_cache.lock);
    80002ce4:	0004c517          	auipc	a0,0x4c
    80002ce8:	33450513          	addi	a0,a0,820 # 8004f018 <inode_cache>
    80002cec:	00001097          	auipc	ra,0x1
    80002cf0:	b52080e7          	jalr	-1198(ra) # 8000383e <spin_lock>
    empty = 0;
    80002cf4:	4901                	li	s2,0
    for (ip = &inode_cache.inode[0]; ip < &inode_cache.inode[NINODE]; ip++) {
    80002cf6:	0004c497          	auipc	s1,0x4c
    80002cfa:	33a48493          	addi	s1,s1,826 # 8004f030 <inode_cache+0x18>
    80002cfe:	a029                	j	80002d08 <get_inode+0x34>
        if (empty == 0 && ip->ref == 0) { // 记住未使用缓冲项
    80002d00:	04090463          	beqz	s2,80002d48 <get_inode+0x74>
    for (ip = &inode_cache.inode[0]; ip < &inode_cache.inode[NINODE]; ip++) {
    80002d04:	08848493          	addi	s1,s1,136
    80002d08:	0004e797          	auipc	a5,0x4e
    80002d0c:	db878793          	addi	a5,a5,-584 # 80050ac0 <cache_lock>
    80002d10:	02f4ff63          	bgeu	s1,a5,80002d4e <get_inode+0x7a>
        if (ip->ref > 0 && ip->inum == inum) {
    80002d14:	449c                	lw	a5,8(s1)
    80002d16:	fef055e3          	blez	a5,80002d00 <get_inode+0x2c>
    80002d1a:	40d4                	lw	a3,4(s1)
    80002d1c:	0009871b          	sext.w	a4,s3
    80002d20:	fee690e3          	bne	a3,a4,80002d00 <get_inode+0x2c>
            ip->ref++;
    80002d24:	2785                	addiw	a5,a5,1
    80002d26:	c49c                	sw	a5,8(s1)
            spin_unlock(&inode_cache.lock);
    80002d28:	0004c517          	auipc	a0,0x4c
    80002d2c:	2f050513          	addi	a0,a0,752 # 8004f018 <inode_cache>
    80002d30:	00001097          	auipc	ra,0x1
    80002d34:	be0080e7          	jalr	-1056(ra) # 80003910 <spin_unlock>
}
    80002d38:	8526                	mv	a0,s1
    80002d3a:	70a2                	ld	ra,40(sp)
    80002d3c:	7402                	ld	s0,32(sp)
    80002d3e:	64e2                	ld	s1,24(sp)
    80002d40:	6942                	ld	s2,16(sp)
    80002d42:	69a2                	ld	s3,8(sp)
    80002d44:	6145                	addi	sp,sp,48
    80002d46:	8082                	ret
        if (empty == 0 && ip->ref == 0) { // 记住未使用缓冲项
    80002d48:	ffd5                	bnez	a5,80002d04 <get_inode+0x30>
            empty = ip;
    80002d4a:	8926                	mv	s2,s1
    80002d4c:	bf65                	j	80002d04 <get_inode+0x30>
    if (empty == 0) {
    80002d4e:	02090363          	beqz	s2,80002d74 <get_inode+0xa0>
    ip->inum = inum;
    80002d52:	01392223          	sw	s3,4(s2)
    ip->ref = 1;
    80002d56:	4785                	li	a5,1
    80002d58:	00f92423          	sw	a5,8(s2)
    ip->valid = 0;
    80002d5c:	04092023          	sw	zero,64(s2)
    spin_unlock(&inode_cache.lock);
    80002d60:	0004c517          	auipc	a0,0x4c
    80002d64:	2b850513          	addi	a0,a0,696 # 8004f018 <inode_cache>
    80002d68:	00001097          	auipc	ra,0x1
    80002d6c:	ba8080e7          	jalr	-1112(ra) # 80003910 <spin_unlock>
    return ip;
    80002d70:	84ca                	mv	s1,s2
    80002d72:	b7d9                	j	80002d38 <get_inode+0x64>
        panic("get_inode");
    80002d74:	00003517          	auipc	a0,0x3
    80002d78:	99c50513          	addi	a0,a0,-1636 # 80005710 <digits+0x578>
    80002d7c:	fffff097          	auipc	ra,0xfffff
    80002d80:	860080e7          	jalr	-1952(ra) # 800015dc <panic>
    80002d84:	b7f9                	j	80002d52 <get_inode+0x7e>

0000000080002d86 <alloc_inode>:
struct inode *alloc_inode(short type) {
    80002d86:	7179                	addi	sp,sp,-48
    80002d88:	f406                	sd	ra,40(sp)
    80002d8a:	f022                	sd	s0,32(sp)
    80002d8c:	ec26                	sd	s1,24(sp)
    80002d8e:	e84a                	sd	s2,16(sp)
    80002d90:	e44e                	sd	s3,8(sp)
    80002d92:	e052                	sd	s4,0(sp)
    80002d94:	1800                	addi	s0,sp,48
    80002d96:	8a2a                	mv	s4,a0
    for (inum = 1; inum < sb.ninodes; inum++) {
    80002d98:	4485                	li	s1,1
    80002d9a:	0004c717          	auipc	a4,0x4c
    80002d9e:	27272703          	lw	a4,626(a4) # 8004f00c <sb+0xc>
    80002da2:	0004879b          	sext.w	a5,s1
    80002da6:	06e7f863          	bgeu	a5,a4,80002e16 <alloc_inode+0x90>
        bp = buf_read(0, IBLOCK(inum, sb));
    80002daa:	0044d593          	srli	a1,s1,0x4
    80002dae:	0004c797          	auipc	a5,0x4c
    80002db2:	2627a783          	lw	a5,610(a5) # 8004f010 <sb+0x10>
    80002db6:	9dbd                	addw	a1,a1,a5
    80002db8:	4501                	li	a0,0
    80002dba:	00001097          	auipc	ra,0x1
    80002dbe:	950080e7          	jalr	-1712(ra) # 8000370a <buf_read>
    80002dc2:	892a                	mv	s2,a0
        dip = (struct dinode *) bp->data + inum % IPB;
    80002dc4:	04c50993          	addi	s3,a0,76
    80002dc8:	00f4f793          	andi	a5,s1,15
    80002dcc:	079a                	slli	a5,a5,0x6
    80002dce:	99be                	add	s3,s3,a5
        if (dip->type == 0) { // a free inode
    80002dd0:	00099783          	lh	a5,0(s3) # 1000 <_entry-0x7ffff000>
    80002dd4:	c799                	beqz	a5,80002de2 <alloc_inode+0x5c>
        relse_buf(bp);
    80002dd6:	00001097          	auipc	ra,0x1
    80002dda:	982080e7          	jalr	-1662(ra) # 80003758 <relse_buf>
    for (inum = 1; inum < sb.ninodes; inum++) {
    80002dde:	2485                	addiw	s1,s1,1
    80002de0:	bf6d                	j	80002d9a <alloc_inode+0x14>
            memset(dip, 0, sizeof(*dip));
    80002de2:	04000613          	li	a2,64
    80002de6:	4581                	li	a1,0
    80002de8:	854e                	mv	a0,s3
    80002dea:	ffffe097          	auipc	ra,0xffffe
    80002dee:	1d8080e7          	jalr	472(ra) # 80000fc2 <memset>
            dip->type = type;
    80002df2:	01499023          	sh	s4,0(s3)
            buf_write(bp); // 写回磁盘
    80002df6:	854a                	mv	a0,s2
    80002df8:	00001097          	auipc	ra,0x1
    80002dfc:	946080e7          	jalr	-1722(ra) # 8000373e <buf_write>
            relse_buf(bp);
    80002e00:	854a                	mv	a0,s2
    80002e02:	00001097          	auipc	ra,0x1
    80002e06:	956080e7          	jalr	-1706(ra) # 80003758 <relse_buf>
            return get_inode(inum);
    80002e0a:	8526                	mv	a0,s1
    80002e0c:	00000097          	auipc	ra,0x0
    80002e10:	ec8080e7          	jalr	-312(ra) # 80002cd4 <get_inode>
    80002e14:	a811                	j	80002e28 <alloc_inode+0xa2>
    panic("alloc_inode: no inodes");
    80002e16:	00003517          	auipc	a0,0x3
    80002e1a:	90a50513          	addi	a0,a0,-1782 # 80005720 <digits+0x588>
    80002e1e:	ffffe097          	auipc	ra,0xffffe
    80002e22:	7be080e7          	jalr	1982(ra) # 800015dc <panic>
    return 0;
    80002e26:	4501                	li	a0,0
}
    80002e28:	70a2                	ld	ra,40(sp)
    80002e2a:	7402                	ld	s0,32(sp)
    80002e2c:	64e2                	ld	s1,24(sp)
    80002e2e:	6942                	ld	s2,16(sp)
    80002e30:	69a2                	ld	s3,8(sp)
    80002e32:	6a02                	ld	s4,0(sp)
    80002e34:	6145                	addi	sp,sp,48
    80002e36:	8082                	ret

0000000080002e38 <bmap>:
uint bmap(struct inode *ip, uint bn) {
    80002e38:	1101                	addi	sp,sp,-32
    80002e3a:	ec06                	sd	ra,24(sp)
    80002e3c:	e822                	sd	s0,16(sp)
    80002e3e:	e426                	sd	s1,8(sp)
    80002e40:	e04a                	sd	s2,0(sp)
    80002e42:	1000                	addi	s0,sp,32
    if (bn < NDIRECT) {
    80002e44:	47ad                	li	a5,11
    80002e46:	04b7e363          	bltu	a5,a1,80002e8c <bmap+0x54>
    80002e4a:	892a                	mv	s2,a0
    80002e4c:	84ae                	mv	s1,a1
        if ((addr = ip->addrs[bn]) == 0)
    80002e4e:	02059793          	slli	a5,a1,0x20
    80002e52:	9381                	srli	a5,a5,0x20
    80002e54:	07d1                	addi	a5,a5,20
    80002e56:	078a                	slli	a5,a5,0x2
    80002e58:	97aa                	add	a5,a5,a0
    80002e5a:	0007e783          	lwu	a5,0(a5)
    80002e5e:	cb89                	beqz	a5,80002e70 <bmap+0x38>
        return addr;
    80002e60:	0007851b          	sext.w	a0,a5
}
    80002e64:	60e2                	ld	ra,24(sp)
    80002e66:	6442                	ld	s0,16(sp)
    80002e68:	64a2                	ld	s1,8(sp)
    80002e6a:	6902                	ld	s2,0(sp)
    80002e6c:	6105                	addi	sp,sp,32
    80002e6e:	8082                	ret
            ip->addrs[bn] = addr = alloc_disk_block();
    80002e70:	00000097          	auipc	ra,0x0
    80002e74:	c1e080e7          	jalr	-994(ra) # 80002a8e <alloc_disk_block>
    80002e78:	02051793          	slli	a5,a0,0x20
    80002e7c:	9381                	srli	a5,a5,0x20
    80002e7e:	1482                	slli	s1,s1,0x20
    80002e80:	9081                	srli	s1,s1,0x20
    80002e82:	04d1                	addi	s1,s1,20
    80002e84:	048a                	slli	s1,s1,0x2
    80002e86:	94ca                	add	s1,s1,s2
    80002e88:	c088                	sw	a0,0(s1)
    80002e8a:	bfd9                	j	80002e60 <bmap+0x28>
    panic("bmap");
    80002e8c:	00003517          	auipc	a0,0x3
    80002e90:	8ac50513          	addi	a0,a0,-1876 # 80005738 <digits+0x5a0>
    80002e94:	ffffe097          	auipc	ra,0xffffe
    80002e98:	748080e7          	jalr	1864(ra) # 800015dc <panic>
    return 0;
    80002e9c:	4501                	li	a0,0
    80002e9e:	b7d9                	j	80002e64 <bmap+0x2c>

0000000080002ea0 <trunc_inode>:
void trunc_inode(struct inode *ip) {
    80002ea0:	7179                	addi	sp,sp,-48
    80002ea2:	f406                	sd	ra,40(sp)
    80002ea4:	f022                	sd	s0,32(sp)
    80002ea6:	ec26                	sd	s1,24(sp)
    80002ea8:	e84a                	sd	s2,16(sp)
    80002eaa:	e44e                	sd	s3,8(sp)
    80002eac:	e052                	sd	s4,0(sp)
    80002eae:	1800                	addi	s0,sp,48
    80002eb0:	892a                	mv	s2,a0
    for (i = 0; i < NDIRECT; i++) {
    80002eb2:	4481                	li	s1,0
    80002eb4:	a011                	j	80002eb8 <trunc_inode+0x18>
    80002eb6:	2485                	addiw	s1,s1,1
    80002eb8:	47ad                	li	a5,11
    80002eba:	0297c363          	blt	a5,s1,80002ee0 <trunc_inode+0x40>
        if (ip->addrs[i]) {
    80002ebe:	01448793          	addi	a5,s1,20
    80002ec2:	078a                	slli	a5,a5,0x2
    80002ec4:	97ca                	add	a5,a5,s2
    80002ec6:	4388                	lw	a0,0(a5)
    80002ec8:	d57d                	beqz	a0,80002eb6 <trunc_inode+0x16>
            free_disk_block(ip->addrs[i]);
    80002eca:	00000097          	auipc	ra,0x0
    80002ece:	ca2080e7          	jalr	-862(ra) # 80002b6c <free_disk_block>
            ip->addrs[i] = 0;
    80002ed2:	01448793          	addi	a5,s1,20
    80002ed6:	078a                	slli	a5,a5,0x2
    80002ed8:	97ca                	add	a5,a5,s2
    80002eda:	0007a023          	sw	zero,0(a5)
    80002ede:	bfe1                	j	80002eb6 <trunc_inode+0x16>
    if (ip->addrs[NDIRECT]) {
    80002ee0:	08092583          	lw	a1,128(s2)
    80002ee4:	e185                	bnez	a1,80002f04 <trunc_inode+0x64>
    ip->size = 0;
    80002ee6:	04092623          	sw	zero,76(s2)
    update_inode(ip);
    80002eea:	854a                	mv	a0,s2
    80002eec:	00000097          	auipc	ra,0x0
    80002ef0:	d5c080e7          	jalr	-676(ra) # 80002c48 <update_inode>
}
    80002ef4:	70a2                	ld	ra,40(sp)
    80002ef6:	7402                	ld	s0,32(sp)
    80002ef8:	64e2                	ld	s1,24(sp)
    80002efa:	6942                	ld	s2,16(sp)
    80002efc:	69a2                	ld	s3,8(sp)
    80002efe:	6a02                	ld	s4,0(sp)
    80002f00:	6145                	addi	sp,sp,48
    80002f02:	8082                	ret
        bp = buf_read(ip->dev, ip->addrs[NDIRECT]);
    80002f04:	00092503          	lw	a0,0(s2)
    80002f08:	00001097          	auipc	ra,0x1
    80002f0c:	802080e7          	jalr	-2046(ra) # 8000370a <buf_read>
    80002f10:	8a2a                	mv	s4,a0
        a = (uint *) bp->data;
    80002f12:	04c50993          	addi	s3,a0,76
        for (j = 0; j < NINDIRECT; j++) {
    80002f16:	4481                	li	s1,0
    80002f18:	a031                	j	80002f24 <trunc_inode+0x84>
                free_disk_block(a[j]);
    80002f1a:	00000097          	auipc	ra,0x0
    80002f1e:	c52080e7          	jalr	-942(ra) # 80002b6c <free_disk_block>
        for (j = 0; j < NINDIRECT; j++) {
    80002f22:	2485                	addiw	s1,s1,1
    80002f24:	0004879b          	sext.w	a5,s1
    80002f28:	0ff00713          	li	a4,255
    80002f2c:	00f76863          	bltu	a4,a5,80002f3c <trunc_inode+0x9c>
            if (a[j])
    80002f30:	00249793          	slli	a5,s1,0x2
    80002f34:	97ce                	add	a5,a5,s3
    80002f36:	4388                	lw	a0,0(a5)
    80002f38:	d56d                	beqz	a0,80002f22 <trunc_inode+0x82>
    80002f3a:	b7c5                	j	80002f1a <trunc_inode+0x7a>
        relse_buf(bp);
    80002f3c:	8552                	mv	a0,s4
    80002f3e:	00001097          	auipc	ra,0x1
    80002f42:	81a080e7          	jalr	-2022(ra) # 80003758 <relse_buf>
        free_disk_block(ip->addrs[NDIRECT]);
    80002f46:	08092503          	lw	a0,128(s2)
    80002f4a:	00000097          	auipc	ra,0x0
    80002f4e:	c22080e7          	jalr	-990(ra) # 80002b6c <free_disk_block>
        ip->addrs[NDIRECT] = 0;
    80002f52:	08092023          	sw	zero,128(s2)
    80002f56:	bf41                	j	80002ee6 <trunc_inode+0x46>

0000000080002f58 <putback_inode>:
void putback_inode(struct inode *ip) {
    80002f58:	1101                	addi	sp,sp,-32
    80002f5a:	ec06                	sd	ra,24(sp)
    80002f5c:	e822                	sd	s0,16(sp)
    80002f5e:	e426                	sd	s1,8(sp)
    80002f60:	e04a                	sd	s2,0(sp)
    80002f62:	1000                	addi	s0,sp,32
    80002f64:	84aa                	mv	s1,a0
    spin_lock(&inode_cache.lock);
    80002f66:	0004c517          	auipc	a0,0x4c
    80002f6a:	0b250513          	addi	a0,a0,178 # 8004f018 <inode_cache>
    80002f6e:	00001097          	auipc	ra,0x1
    80002f72:	8d0080e7          	jalr	-1840(ra) # 8000383e <spin_lock>
    if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    80002f76:	4498                	lw	a4,8(s1)
    80002f78:	4785                	li	a5,1
    80002f7a:	02f70363          	beq	a4,a5,80002fa0 <putback_inode+0x48>
    ip->ref--;
    80002f7e:	449c                	lw	a5,8(s1)
    80002f80:	37fd                	addiw	a5,a5,-1
    80002f82:	c49c                	sw	a5,8(s1)
    spin_unlock(&inode_cache.lock);
    80002f84:	0004c517          	auipc	a0,0x4c
    80002f88:	09450513          	addi	a0,a0,148 # 8004f018 <inode_cache>
    80002f8c:	00001097          	auipc	ra,0x1
    80002f90:	984080e7          	jalr	-1660(ra) # 80003910 <spin_unlock>
}
    80002f94:	60e2                	ld	ra,24(sp)
    80002f96:	6442                	ld	s0,16(sp)
    80002f98:	64a2                	ld	s1,8(sp)
    80002f9a:	6902                	ld	s2,0(sp)
    80002f9c:	6105                	addi	sp,sp,32
    80002f9e:	8082                	ret
    if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    80002fa0:	40bc                	lw	a5,64(s1)
    80002fa2:	dff1                	beqz	a5,80002f7e <putback_inode+0x26>
    80002fa4:	04a49783          	lh	a5,74(s1)
    80002fa8:	fbf9                	bnez	a5,80002f7e <putback_inode+0x26>
        sleep_lock(&ip->lock);
    80002faa:	01048913          	addi	s2,s1,16
    80002fae:	854a                	mv	a0,s2
    80002fb0:	00001097          	auipc	ra,0x1
    80002fb4:	9f6080e7          	jalr	-1546(ra) # 800039a6 <sleep_lock>
        spin_unlock(&inode_cache.lock);
    80002fb8:	0004c517          	auipc	a0,0x4c
    80002fbc:	06050513          	addi	a0,a0,96 # 8004f018 <inode_cache>
    80002fc0:	00001097          	auipc	ra,0x1
    80002fc4:	950080e7          	jalr	-1712(ra) # 80003910 <spin_unlock>
        trunc_inode(ip);
    80002fc8:	8526                	mv	a0,s1
    80002fca:	00000097          	auipc	ra,0x0
    80002fce:	ed6080e7          	jalr	-298(ra) # 80002ea0 <trunc_inode>
        ip->type = 0;
    80002fd2:	04049223          	sh	zero,68(s1)
        update_inode(ip);
    80002fd6:	8526                	mv	a0,s1
    80002fd8:	00000097          	auipc	ra,0x0
    80002fdc:	c70080e7          	jalr	-912(ra) # 80002c48 <update_inode>
        ip->valid = 0;
    80002fe0:	0404a023          	sw	zero,64(s1)
        sleep_unlock(&ip->lock);
    80002fe4:	854a                	mv	a0,s2
    80002fe6:	00001097          	auipc	ra,0x1
    80002fea:	a14080e7          	jalr	-1516(ra) # 800039fa <sleep_unlock>
        spin_lock(&inode_cache.lock);
    80002fee:	0004c517          	auipc	a0,0x4c
    80002ff2:	02a50513          	addi	a0,a0,42 # 8004f018 <inode_cache>
    80002ff6:	00001097          	auipc	ra,0x1
    80002ffa:	848080e7          	jalr	-1976(ra) # 8000383e <spin_lock>
    80002ffe:	b741                	j	80002f7e <putback_inode+0x26>

0000000080003000 <dup_inode>:
struct inode *dup_inode(struct inode *ip) {
    80003000:	1101                	addi	sp,sp,-32
    80003002:	ec06                	sd	ra,24(sp)
    80003004:	e822                	sd	s0,16(sp)
    80003006:	e426                	sd	s1,8(sp)
    80003008:	1000                	addi	s0,sp,32
    8000300a:	84aa                	mv	s1,a0
    spin_lock(&inode_cache.lock);
    8000300c:	0004c517          	auipc	a0,0x4c
    80003010:	00c50513          	addi	a0,a0,12 # 8004f018 <inode_cache>
    80003014:	00001097          	auipc	ra,0x1
    80003018:	82a080e7          	jalr	-2006(ra) # 8000383e <spin_lock>
    ip->ref++;
    8000301c:	449c                	lw	a5,8(s1)
    8000301e:	2785                	addiw	a5,a5,1
    80003020:	c49c                	sw	a5,8(s1)
    spin_unlock(&inode_cache.lock);
    80003022:	0004c517          	auipc	a0,0x4c
    80003026:	ff650513          	addi	a0,a0,-10 # 8004f018 <inode_cache>
    8000302a:	00001097          	auipc	ra,0x1
    8000302e:	8e6080e7          	jalr	-1818(ra) # 80003910 <spin_unlock>
}
    80003032:	8526                	mv	a0,s1
    80003034:	60e2                	ld	ra,24(sp)
    80003036:	6442                	ld	s0,16(sp)
    80003038:	64a2                	ld	s1,8(sp)
    8000303a:	6105                	addi	sp,sp,32
    8000303c:	8082                	ret

000000008000303e <lock_inode>:
void lock_inode(struct inode *ip) {
    8000303e:	1101                	addi	sp,sp,-32
    80003040:	ec06                	sd	ra,24(sp)
    80003042:	e822                	sd	s0,16(sp)
    80003044:	e426                	sd	s1,8(sp)
    80003046:	e04a                	sd	s2,0(sp)
    80003048:	1000                	addi	s0,sp,32
    8000304a:	84aa                	mv	s1,a0
    if (ip == 0 || ip->ref < 1)
    8000304c:	c501                	beqz	a0,80003054 <lock_inode+0x16>
    8000304e:	451c                	lw	a5,8(a0)
    80003050:	00f04a63          	bgtz	a5,80003064 <lock_inode+0x26>
        panic("lock_inode");
    80003054:	00002517          	auipc	a0,0x2
    80003058:	6ec50513          	addi	a0,a0,1772 # 80005740 <digits+0x5a8>
    8000305c:	ffffe097          	auipc	ra,0xffffe
    80003060:	580080e7          	jalr	1408(ra) # 800015dc <panic>
    sleep_lock(&ip->lock);
    80003064:	01048513          	addi	a0,s1,16
    80003068:	00001097          	auipc	ra,0x1
    8000306c:	93e080e7          	jalr	-1730(ra) # 800039a6 <sleep_lock>
    if (ip->valid == 0) {
    80003070:	40bc                	lw	a5,64(s1)
    80003072:	c799                	beqz	a5,80003080 <lock_inode+0x42>
}
    80003074:	60e2                	ld	ra,24(sp)
    80003076:	6442                	ld	s0,16(sp)
    80003078:	64a2                	ld	s1,8(sp)
    8000307a:	6902                	ld	s2,0(sp)
    8000307c:	6105                	addi	sp,sp,32
    8000307e:	8082                	ret
        bp = buf_read(ip->dev, IBLOCK(ip->inum, sb));
    80003080:	40dc                	lw	a5,4(s1)
    80003082:	0004c597          	auipc	a1,0x4c
    80003086:	f8e5a583          	lw	a1,-114(a1) # 8004f010 <sb+0x10>
    8000308a:	0047d79b          	srliw	a5,a5,0x4
    8000308e:	9dbd                	addw	a1,a1,a5
    80003090:	4088                	lw	a0,0(s1)
    80003092:	00000097          	auipc	ra,0x0
    80003096:	678080e7          	jalr	1656(ra) # 8000370a <buf_read>
    8000309a:	892a                	mv	s2,a0
        dip = (struct dinode *) bp->data + ip->inum % IPB;
    8000309c:	04c50593          	addi	a1,a0,76
    800030a0:	40dc                	lw	a5,4(s1)
    800030a2:	8bbd                	andi	a5,a5,15
    800030a4:	079a                	slli	a5,a5,0x6
    800030a6:	95be                	add	a1,a1,a5
        ip->type = dip->type;
    800030a8:	00059783          	lh	a5,0(a1)
    800030ac:	04f49223          	sh	a5,68(s1)
        ip->major = dip->major;
    800030b0:	00259783          	lh	a5,2(a1)
    800030b4:	04f49323          	sh	a5,70(s1)
        ip->minor = dip->minor;
    800030b8:	00459783          	lh	a5,4(a1)
    800030bc:	04f49423          	sh	a5,72(s1)
        ip->nlink = dip->nlink;
    800030c0:	00659783          	lh	a5,6(a1)
    800030c4:	04f49523          	sh	a5,74(s1)
        ip->size = dip->size;
    800030c8:	459c                	lw	a5,8(a1)
    800030ca:	c4fc                	sw	a5,76(s1)
        memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800030cc:	03400613          	li	a2,52
    800030d0:	05b1                	addi	a1,a1,12
    800030d2:	05048513          	addi	a0,s1,80
    800030d6:	ffffe097          	auipc	ra,0xffffe
    800030da:	f0e080e7          	jalr	-242(ra) # 80000fe4 <memmove>
        relse_buf(bp);
    800030de:	854a                	mv	a0,s2
    800030e0:	00000097          	auipc	ra,0x0
    800030e4:	678080e7          	jalr	1656(ra) # 80003758 <relse_buf>
        ip->valid = 1;
    800030e8:	4785                	li	a5,1
    800030ea:	c0bc                	sw	a5,64(s1)
        if (ip->type == 0)
    800030ec:	04449783          	lh	a5,68(s1)
    800030f0:	f3d1                	bnez	a5,80003074 <lock_inode+0x36>
            panic("lock_inode: no type");
    800030f2:	00002517          	auipc	a0,0x2
    800030f6:	65e50513          	addi	a0,a0,1630 # 80005750 <digits+0x5b8>
    800030fa:	ffffe097          	auipc	ra,0xffffe
    800030fe:	4e2080e7          	jalr	1250(ra) # 800015dc <panic>
}
    80003102:	bf8d                	j	80003074 <lock_inode+0x36>

0000000080003104 <unlock_inode>:
void unlock_inode(struct inode *ip) {
    80003104:	1101                	addi	sp,sp,-32
    80003106:	ec06                	sd	ra,24(sp)
    80003108:	e822                	sd	s0,16(sp)
    8000310a:	e426                	sd	s1,8(sp)
    8000310c:	1000                	addi	s0,sp,32
    8000310e:	84aa                	mv	s1,a0
    if (ip == 0 || !sleep_holding(&ip->lock) || ip->ref < 1)
    80003110:	c911                	beqz	a0,80003124 <unlock_inode+0x20>
    80003112:	0541                	addi	a0,a0,16
    80003114:	00001097          	auipc	ra,0x1
    80003118:	92a080e7          	jalr	-1750(ra) # 80003a3e <sleep_holding>
    8000311c:	c501                	beqz	a0,80003124 <unlock_inode+0x20>
    8000311e:	449c                	lw	a5,8(s1)
    80003120:	00f04a63          	bgtz	a5,80003134 <unlock_inode+0x30>
        panic("unlock_inode");
    80003124:	00002517          	auipc	a0,0x2
    80003128:	64450513          	addi	a0,a0,1604 # 80005768 <digits+0x5d0>
    8000312c:	ffffe097          	auipc	ra,0xffffe
    80003130:	4b0080e7          	jalr	1200(ra) # 800015dc <panic>
    sleep_unlock(&ip->lock);
    80003134:	01048513          	addi	a0,s1,16
    80003138:	00001097          	auipc	ra,0x1
    8000313c:	8c2080e7          	jalr	-1854(ra) # 800039fa <sleep_unlock>
}
    80003140:	60e2                	ld	ra,24(sp)
    80003142:	6442                	ld	s0,16(sp)
    80003144:	64a2                	ld	s1,8(sp)
    80003146:	6105                	addi	sp,sp,32
    80003148:	8082                	ret

000000008000314a <unlock_and_putback>:
void unlock_and_putback(struct inode *ip) {
    8000314a:	1101                	addi	sp,sp,-32
    8000314c:	ec06                	sd	ra,24(sp)
    8000314e:	e822                	sd	s0,16(sp)
    80003150:	e426                	sd	s1,8(sp)
    80003152:	1000                	addi	s0,sp,32
    80003154:	84aa                	mv	s1,a0
    unlock_inode(ip);
    80003156:	00000097          	auipc	ra,0x0
    8000315a:	fae080e7          	jalr	-82(ra) # 80003104 <unlock_inode>
    putback_inode(ip);
    8000315e:	8526                	mv	a0,s1
    80003160:	00000097          	auipc	ra,0x0
    80003164:	df8080e7          	jalr	-520(ra) # 80002f58 <putback_inode>
}
    80003168:	60e2                	ld	ra,24(sp)
    8000316a:	6442                	ld	s0,16(sp)
    8000316c:	64a2                	ld	s1,8(sp)
    8000316e:	6105                	addi	sp,sp,32
    80003170:	8082                	ret

0000000080003172 <read_inode>:
int read_inode(struct inode *ip, uint64 dst, uint off, int n) {
    80003172:	715d                	addi	sp,sp,-80
    80003174:	e486                	sd	ra,72(sp)
    80003176:	e0a2                	sd	s0,64(sp)
    80003178:	fc26                	sd	s1,56(sp)
    8000317a:	f84a                	sd	s2,48(sp)
    8000317c:	f44e                	sd	s3,40(sp)
    8000317e:	f052                	sd	s4,32(sp)
    80003180:	ec56                	sd	s5,24(sp)
    80003182:	e85a                	sd	s6,16(sp)
    80003184:	e45e                	sd	s7,8(sp)
    80003186:	e062                	sd	s8,0(sp)
    80003188:	0880                	addi	s0,sp,80
    if (off > ip->size || off + n < off) {
    8000318a:	457c                	lw	a5,76(a0)
    8000318c:	08c7e563          	bltu	a5,a2,80003216 <read_inode+0xa4>
    80003190:	8baa                	mv	s7,a0
    80003192:	8aae                	mv	s5,a1
    80003194:	84b2                	mv	s1,a2
    80003196:	8b36                	mv	s6,a3
    80003198:	00c6873b          	addw	a4,a3,a2
    8000319c:	08c76b63          	bltu	a4,a2,80003232 <read_inode+0xc0>
    if (off + n > ip->size) {
    800031a0:	00e7f463          	bgeu	a5,a4,800031a8 <read_inode+0x36>
        n = ip->size - off;
    800031a4:	40c78b3b          	subw	s6,a5,a2
int read_inode(struct inode *ip, uint64 dst, uint off, int n) {
    800031a8:	4981                	li	s3,0
    800031aa:	a035                	j	800031d6 <read_inode+0x64>
        m = min(BSIZE - off % BSIZE, n - total);
    800031ac:	000a0c1b          	sext.w	s8,s4
        memmove((uint64 *) (dst), bp->data + (off % BSIZE), m);
    800031b0:	04c90593          	addi	a1,s2,76
    800031b4:	8662                	mv	a2,s8
    800031b6:	95b6                	add	a1,a1,a3
    800031b8:	8556                	mv	a0,s5
    800031ba:	ffffe097          	auipc	ra,0xffffe
    800031be:	e2a080e7          	jalr	-470(ra) # 80000fe4 <memmove>
        relse_buf(bp);
    800031c2:	854a                	mv	a0,s2
    800031c4:	00000097          	auipc	ra,0x0
    800031c8:	594080e7          	jalr	1428(ra) # 80003758 <relse_buf>
    for (; total < n; total += m, off += m, dst += m) {
    800031cc:	013a09bb          	addw	s3,s4,s3
    800031d0:	009a04bb          	addw	s1,s4,s1
    800031d4:	9ae2                	add	s5,s5,s8
    800031d6:	0569d163          	bge	s3,s6,80003218 <read_inode+0xa6>
        bp = buf_read(0, bmap(ip, off / BSIZE));
    800031da:	00a4d59b          	srliw	a1,s1,0xa
    800031de:	855e                	mv	a0,s7
    800031e0:	00000097          	auipc	ra,0x0
    800031e4:	c58080e7          	jalr	-936(ra) # 80002e38 <bmap>
    800031e8:	0005059b          	sext.w	a1,a0
    800031ec:	4501                	li	a0,0
    800031ee:	00000097          	auipc	ra,0x0
    800031f2:	51c080e7          	jalr	1308(ra) # 8000370a <buf_read>
    800031f6:	892a                	mv	s2,a0
        m = min(BSIZE - off % BSIZE, n - total);
    800031f8:	413b07bb          	subw	a5,s6,s3
    800031fc:	3ff4f693          	andi	a3,s1,1023
    80003200:	40000713          	li	a4,1024
    80003204:	9f15                	subw	a4,a4,a3
    80003206:	8a3e                	mv	s4,a5
    80003208:	2781                	sext.w	a5,a5
    8000320a:	0007061b          	sext.w	a2,a4
    8000320e:	f8f67fe3          	bgeu	a2,a5,800031ac <read_inode+0x3a>
    80003212:	8a3a                	mv	s4,a4
    80003214:	bf61                	j	800031ac <read_inode+0x3a>
        return 0;
    80003216:	4981                	li	s3,0
}
    80003218:	854e                	mv	a0,s3
    8000321a:	60a6                	ld	ra,72(sp)
    8000321c:	6406                	ld	s0,64(sp)
    8000321e:	74e2                	ld	s1,56(sp)
    80003220:	7942                	ld	s2,48(sp)
    80003222:	79a2                	ld	s3,40(sp)
    80003224:	7a02                	ld	s4,32(sp)
    80003226:	6ae2                	ld	s5,24(sp)
    80003228:	6b42                	ld	s6,16(sp)
    8000322a:	6ba2                	ld	s7,8(sp)
    8000322c:	6c02                	ld	s8,0(sp)
    8000322e:	6161                	addi	sp,sp,80
    80003230:	8082                	ret
        return 0;
    80003232:	4981                	li	s3,0
    80003234:	b7d5                	j	80003218 <read_inode+0xa6>

0000000080003236 <write_inode>:
int write_inode(struct inode *ip, uint64 src, uint64 off, int n) {
    80003236:	715d                	addi	sp,sp,-80
    80003238:	e486                	sd	ra,72(sp)
    8000323a:	e0a2                	sd	s0,64(sp)
    8000323c:	fc26                	sd	s1,56(sp)
    8000323e:	f84a                	sd	s2,48(sp)
    80003240:	f44e                	sd	s3,40(sp)
    80003242:	f052                	sd	s4,32(sp)
    80003244:	ec56                	sd	s5,24(sp)
    80003246:	e85a                	sd	s6,16(sp)
    80003248:	e45e                	sd	s7,8(sp)
    8000324a:	e062                	sd	s8,0(sp)
    8000324c:	0880                	addi	s0,sp,80
    if (off > ip->size || off + n < off)
    8000324e:	04c56783          	lwu	a5,76(a0)
    80003252:	0cc7e663          	bltu	a5,a2,8000331e <write_inode+0xe8>
    80003256:	8baa                	mv	s7,a0
    80003258:	8aae                	mv	s5,a1
    8000325a:	89b2                	mv	s3,a2
    8000325c:	8b36                	mv	s6,a3
    8000325e:	00c687b3          	add	a5,a3,a2
    80003262:	0cc7e063          	bltu	a5,a2,80003322 <write_inode+0xec>
    if (off + n > MAXFILE * BSIZE)
    80003266:	00043737          	lui	a4,0x43
    8000326a:	0af76e63          	bltu	a4,a5,80003326 <write_inode+0xf0>
    for (total = 0; total < n; total += m, off += m, src += m) {
    8000326e:	4a01                	li	s4,0
    80003270:	a825                	j	800032a8 <write_inode+0x72>
        m = min(BSIZE - off % BSIZE, n - total);
    80003272:	00048c1b          	sext.w	s8,s1
        memmove(bp->data + (off % BSIZE), (uint64 *) (src), m);
    80003276:	04c90513          	addi	a0,s2,76
    8000327a:	8662                	mv	a2,s8
    8000327c:	85d6                	mv	a1,s5
    8000327e:	953a                	add	a0,a0,a4
    80003280:	ffffe097          	auipc	ra,0xffffe
    80003284:	d64080e7          	jalr	-668(ra) # 80000fe4 <memmove>
        buf_write(bp);
    80003288:	854a                	mv	a0,s2
    8000328a:	00000097          	auipc	ra,0x0
    8000328e:	4b4080e7          	jalr	1204(ra) # 8000373e <buf_write>
        relse_buf(bp);
    80003292:	854a                	mv	a0,s2
    80003294:	00000097          	auipc	ra,0x0
    80003298:	4c4080e7          	jalr	1220(ra) # 80003758 <relse_buf>
    for (total = 0; total < n; total += m, off += m, src += m) {
    8000329c:	018a0a3b          	addw	s4,s4,s8
    800032a0:	1482                	slli	s1,s1,0x20
    800032a2:	9081                	srli	s1,s1,0x20
    800032a4:	99a6                	add	s3,s3,s1
    800032a6:	9aa6                	add	s5,s5,s1
    800032a8:	000b049b          	sext.w	s1,s6
    800032ac:	029a7f63          	bgeu	s4,s1,800032ea <write_inode+0xb4>
        bp = buf_read(0, bmap(ip, off / BSIZE));
    800032b0:	00a9d593          	srli	a1,s3,0xa
    800032b4:	2581                	sext.w	a1,a1
    800032b6:	855e                	mv	a0,s7
    800032b8:	00000097          	auipc	ra,0x0
    800032bc:	b80080e7          	jalr	-1152(ra) # 80002e38 <bmap>
    800032c0:	0005059b          	sext.w	a1,a0
    800032c4:	4501                	li	a0,0
    800032c6:	00000097          	auipc	ra,0x0
    800032ca:	444080e7          	jalr	1092(ra) # 8000370a <buf_read>
    800032ce:	892a                	mv	s2,a0
        m = min(BSIZE - off % BSIZE, n - total);
    800032d0:	414484bb          	subw	s1,s1,s4
    800032d4:	3ff9f713          	andi	a4,s3,1023
    800032d8:	40000793          	li	a5,1024
    800032dc:	8f99                	sub	a5,a5,a4
    800032de:	1482                	slli	s1,s1,0x20
    800032e0:	9081                	srli	s1,s1,0x20
    800032e2:	f897f8e3          	bgeu	a5,s1,80003272 <write_inode+0x3c>
    800032e6:	84be                	mv	s1,a5
    800032e8:	b769                	j	80003272 <write_inode+0x3c>
    if (n > 0) {
    800032ea:	01605d63          	blez	s6,80003304 <write_inode+0xce>
        if (off > ip->size)
    800032ee:	04cbe783          	lwu	a5,76(s7)
    800032f2:	0137f463          	bgeu	a5,s3,800032fa <write_inode+0xc4>
            ip->size = off;
    800032f6:	053ba623          	sw	s3,76(s7)
        update_inode(ip);
    800032fa:	855e                	mv	a0,s7
    800032fc:	00000097          	auipc	ra,0x0
    80003300:	94c080e7          	jalr	-1716(ra) # 80002c48 <update_inode>
}
    80003304:	855a                	mv	a0,s6
    80003306:	60a6                	ld	ra,72(sp)
    80003308:	6406                	ld	s0,64(sp)
    8000330a:	74e2                	ld	s1,56(sp)
    8000330c:	7942                	ld	s2,48(sp)
    8000330e:	79a2                	ld	s3,40(sp)
    80003310:	7a02                	ld	s4,32(sp)
    80003312:	6ae2                	ld	s5,24(sp)
    80003314:	6b42                	ld	s6,16(sp)
    80003316:	6ba2                	ld	s7,8(sp)
    80003318:	6c02                	ld	s8,0(sp)
    8000331a:	6161                	addi	sp,sp,80
    8000331c:	8082                	ret
        return -1;
    8000331e:	5b7d                	li	s6,-1
    80003320:	b7d5                	j	80003304 <write_inode+0xce>
    80003322:	5b7d                	li	s6,-1
    80003324:	b7c5                	j	80003304 <write_inode+0xce>
        return -1;
    80003326:	5b7d                	li	s6,-1
    80003328:	bff1                	j	80003304 <write_inode+0xce>

000000008000332a <namecmp>:
int namecmp(const char *s, const char *t) {
    8000332a:	1141                	addi	sp,sp,-16
    8000332c:	e406                	sd	ra,8(sp)
    8000332e:	e022                	sd	s0,0(sp)
    80003330:	0800                	addi	s0,sp,16
    return strncmp(s, t, DIRSIZ);
    80003332:	4639                	li	a2,14
    80003334:	ffffe097          	auipc	ra,0xffffe
    80003338:	d9c080e7          	jalr	-612(ra) # 800010d0 <strncmp>
}
    8000333c:	60a2                	ld	ra,8(sp)
    8000333e:	6402                	ld	s0,0(sp)
    80003340:	0141                	addi	sp,sp,16
    80003342:	8082                	ret

0000000080003344 <dirlookup>:
struct inode *dirlookup(struct inode *dp, char *name, uint *poff) {
    80003344:	7139                	addi	sp,sp,-64
    80003346:	fc06                	sd	ra,56(sp)
    80003348:	f822                	sd	s0,48(sp)
    8000334a:	f426                	sd	s1,40(sp)
    8000334c:	f04a                	sd	s2,32(sp)
    8000334e:	ec4e                	sd	s3,24(sp)
    80003350:	e852                	sd	s4,16(sp)
    80003352:	0080                	addi	s0,sp,64
    80003354:	892a                	mv	s2,a0
    80003356:	89ae                	mv	s3,a1
    80003358:	8a32                	mv	s4,a2
    if (dp->type != T_DIR)
    8000335a:	04451703          	lh	a4,68(a0)
    8000335e:	4785                	li	a5,1
    80003360:	00f71463          	bne	a4,a5,80003368 <dirlookup+0x24>
struct inode *dirlookup(struct inode *dp, char *name, uint *poff) {
    80003364:	4481                	li	s1,0
    80003366:	a025                	j	8000338e <dirlookup+0x4a>
        panic("dirlookup not DIR");
    80003368:	00002517          	auipc	a0,0x2
    8000336c:	41050513          	addi	a0,a0,1040 # 80005778 <digits+0x5e0>
    80003370:	ffffe097          	auipc	ra,0xffffe
    80003374:	26c080e7          	jalr	620(ra) # 800015dc <panic>
    80003378:	b7f5                	j	80003364 <dirlookup+0x20>
            panic("dirlookup read");
    8000337a:	00002517          	auipc	a0,0x2
    8000337e:	41650513          	addi	a0,a0,1046 # 80005790 <digits+0x5f8>
    80003382:	ffffe097          	auipc	ra,0xffffe
    80003386:	25a080e7          	jalr	602(ra) # 800015dc <panic>
    8000338a:	a015                	j	800033ae <dirlookup+0x6a>
    for (off = 0; off < dp->size; off += sizeof(de)) {
    8000338c:	24c1                	addiw	s1,s1,16
    8000338e:	04c92783          	lw	a5,76(s2)
    80003392:	04f4f463          	bgeu	s1,a5,800033da <dirlookup+0x96>
        if (read_inode(dp, (uint64) &de, off, sizeof(de)) != sizeof(de))
    80003396:	46c1                	li	a3,16
    80003398:	8626                	mv	a2,s1
    8000339a:	fc040593          	addi	a1,s0,-64
    8000339e:	854a                	mv	a0,s2
    800033a0:	00000097          	auipc	ra,0x0
    800033a4:	dd2080e7          	jalr	-558(ra) # 80003172 <read_inode>
    800033a8:	47c1                	li	a5,16
    800033aa:	fcf518e3          	bne	a0,a5,8000337a <dirlookup+0x36>
        if (de.inum == 0)
    800033ae:	fc045783          	lhu	a5,-64(s0)
    800033b2:	dfe9                	beqz	a5,8000338c <dirlookup+0x48>
        if (namecmp(name, de.name) == 0) {
    800033b4:	fc240593          	addi	a1,s0,-62
    800033b8:	854e                	mv	a0,s3
    800033ba:	00000097          	auipc	ra,0x0
    800033be:	f70080e7          	jalr	-144(ra) # 8000332a <namecmp>
    800033c2:	f569                	bnez	a0,8000338c <dirlookup+0x48>
            if (poff)
    800033c4:	000a0463          	beqz	s4,800033cc <dirlookup+0x88>
                *poff = off;
    800033c8:	009a2023          	sw	s1,0(s4)
            return get_inode(inum);
    800033cc:	fc045503          	lhu	a0,-64(s0)
    800033d0:	00000097          	auipc	ra,0x0
    800033d4:	904080e7          	jalr	-1788(ra) # 80002cd4 <get_inode>
    800033d8:	a011                	j	800033dc <dirlookup+0x98>
    return 0;
    800033da:	4501                	li	a0,0
}
    800033dc:	70e2                	ld	ra,56(sp)
    800033de:	7442                	ld	s0,48(sp)
    800033e0:	74a2                	ld	s1,40(sp)
    800033e2:	7902                	ld	s2,32(sp)
    800033e4:	69e2                	ld	s3,24(sp)
    800033e6:	6a42                	ld	s4,16(sp)
    800033e8:	6121                	addi	sp,sp,64
    800033ea:	8082                	ret

00000000800033ec <namex>:

// 根据path返回一个inode
// 该函数供nameiparent和namei使用
// 如果parent!=0返回父目录的inode并且复制最后一个元素到name中，
// name必须拥有足够的空间来存储DIRSIZE字节的字符串。
static struct inode *namex(char *path, int nameiparent, char *name) {
    800033ec:	7139                	addi	sp,sp,-64
    800033ee:	fc06                	sd	ra,56(sp)
    800033f0:	f822                	sd	s0,48(sp)
    800033f2:	f426                	sd	s1,40(sp)
    800033f4:	f04a                	sd	s2,32(sp)
    800033f6:	ec4e                	sd	s3,24(sp)
    800033f8:	e852                	sd	s4,16(sp)
    800033fa:	e456                	sd	s5,8(sp)
    800033fc:	0080                	addi	s0,sp,64
    800033fe:	84aa                	mv	s1,a0
    80003400:	8aae                	mv	s5,a1
    80003402:	8a32                	mv	s4,a2
    struct inode *ip, *next;
    struct proc *p = myproc();
    80003404:	ffffd097          	auipc	ra,0xffffd
    80003408:	5c0080e7          	jalr	1472(ra) # 800009c4 <myproc>
    if (*path == '/')
    8000340c:	0004c703          	lbu	a4,0(s1)
    80003410:	02f00793          	li	a5,47
    80003414:	00f70a63          	beq	a4,a5,80003428 <namex+0x3c>
        ip = get_inode(ROOTINO);
    else
        ip = get_inode(p->current_dir->inum); // TODO 修改：从进程的当前path
    80003418:	693c                	ld	a5,80(a0)
    8000341a:	43c8                	lw	a0,4(a5)
    8000341c:	00000097          	auipc	ra,0x0
    80003420:	8b8080e7          	jalr	-1864(ra) # 80002cd4 <get_inode>
    80003424:	892a                	mv	s2,a0
    80003426:	a0b9                	j	80003474 <namex+0x88>
        ip = get_inode(ROOTINO);
    80003428:	4501                	li	a0,0
    8000342a:	00000097          	auipc	ra,0x0
    8000342e:	8aa080e7          	jalr	-1878(ra) # 80002cd4 <get_inode>
    80003432:	892a                	mv	s2,a0
    80003434:	a081                	j	80003474 <namex+0x88>

    while ((path = skipelem(path, name)) != 0) {
        lock_inode(ip);
        if (ip->type != T_DIR) {
            unlock_and_putback(ip);
    80003436:	854a                	mv	a0,s2
    80003438:	00000097          	auipc	ra,0x0
    8000343c:	d12080e7          	jalr	-750(ra) # 8000314a <unlock_and_putback>
            return 0;
    80003440:	4901                	li	s2,0
    if (nameiparent) {
        putback_inode(ip);
        return 0;
    }
    return ip;
}
    80003442:	854a                	mv	a0,s2
    80003444:	70e2                	ld	ra,56(sp)
    80003446:	7442                	ld	s0,48(sp)
    80003448:	74a2                	ld	s1,40(sp)
    8000344a:	7902                	ld	s2,32(sp)
    8000344c:	69e2                	ld	s3,24(sp)
    8000344e:	6a42                	ld	s4,16(sp)
    80003450:	6aa2                	ld	s5,8(sp)
    80003452:	6121                	addi	sp,sp,64
    80003454:	8082                	ret
        if ((next = dirlookup(ip, name, 0)) == 0) {
    80003456:	4601                	li	a2,0
    80003458:	85d2                	mv	a1,s4
    8000345a:	854a                	mv	a0,s2
    8000345c:	00000097          	auipc	ra,0x0
    80003460:	ee8080e7          	jalr	-280(ra) # 80003344 <dirlookup>
    80003464:	89aa                	mv	s3,a0
    80003466:	c521                	beqz	a0,800034ae <namex+0xc2>
        unlock_and_putback(ip);
    80003468:	854a                	mv	a0,s2
    8000346a:	00000097          	auipc	ra,0x0
    8000346e:	ce0080e7          	jalr	-800(ra) # 8000314a <unlock_and_putback>
        ip = next;
    80003472:	894e                	mv	s2,s3
    while ((path = skipelem(path, name)) != 0) {
    80003474:	85d2                	mv	a1,s4
    80003476:	8526                	mv	a0,s1
    80003478:	fffff097          	auipc	ra,0xfffff
    8000347c:	4b4080e7          	jalr	1204(ra) # 8000292c <skipelem>
    80003480:	84aa                	mv	s1,a0
    80003482:	cd0d                	beqz	a0,800034bc <namex+0xd0>
        lock_inode(ip);
    80003484:	854a                	mv	a0,s2
    80003486:	00000097          	auipc	ra,0x0
    8000348a:	bb8080e7          	jalr	-1096(ra) # 8000303e <lock_inode>
        if (ip->type != T_DIR) {
    8000348e:	04491703          	lh	a4,68(s2)
    80003492:	4785                	li	a5,1
    80003494:	faf711e3          	bne	a4,a5,80003436 <namex+0x4a>
        if (nameiparent && *path == '\0') {
    80003498:	fa0a8fe3          	beqz	s5,80003456 <namex+0x6a>
    8000349c:	0004c783          	lbu	a5,0(s1)
    800034a0:	fbdd                	bnez	a5,80003456 <namex+0x6a>
            unlock_inode(ip);
    800034a2:	854a                	mv	a0,s2
    800034a4:	00000097          	auipc	ra,0x0
    800034a8:	c60080e7          	jalr	-928(ra) # 80003104 <unlock_inode>
            return ip;
    800034ac:	bf59                	j	80003442 <namex+0x56>
            unlock_and_putback(ip);
    800034ae:	854a                	mv	a0,s2
    800034b0:	00000097          	auipc	ra,0x0
    800034b4:	c9a080e7          	jalr	-870(ra) # 8000314a <unlock_and_putback>
            return 0;
    800034b8:	894e                	mv	s2,s3
    800034ba:	b761                	j	80003442 <namex+0x56>
    if (nameiparent) {
    800034bc:	f80a83e3          	beqz	s5,80003442 <namex+0x56>
        putback_inode(ip);
    800034c0:	854a                	mv	a0,s2
    800034c2:	00000097          	auipc	ra,0x0
    800034c6:	a96080e7          	jalr	-1386(ra) # 80002f58 <putback_inode>
        return 0;
    800034ca:	8926                	mv	s2,s1
    800034cc:	bf9d                	j	80003442 <namex+0x56>

00000000800034ce <dirlink>:
int dirlink(struct inode *dp, char *name, uint inum) {
    800034ce:	715d                	addi	sp,sp,-80
    800034d0:	e486                	sd	ra,72(sp)
    800034d2:	e0a2                	sd	s0,64(sp)
    800034d4:	fc26                	sd	s1,56(sp)
    800034d6:	f84a                	sd	s2,48(sp)
    800034d8:	f44e                	sd	s3,40(sp)
    800034da:	f052                	sd	s4,32(sp)
    800034dc:	ec56                	sd	s5,24(sp)
    800034de:	0880                	addi	s0,sp,80
    800034e0:	892a                	mv	s2,a0
    800034e2:	8a2e                	mv	s4,a1
    800034e4:	8ab2                	mv	s5,a2
    if ((ip = dirlookup(dp, name, 0)) != 0) {
    800034e6:	4601                	li	a2,0
    800034e8:	00000097          	auipc	ra,0x0
    800034ec:	e5c080e7          	jalr	-420(ra) # 80003344 <dirlookup>
    800034f0:	e119                	bnez	a0,800034f6 <dirlink+0x28>
    for (off = 0; off < dp->size; off += sizeof(de)) {
    800034f2:	4981                	li	s3,0
    800034f4:	a025                	j	8000351c <dirlink+0x4e>
        putback_inode(ip);
    800034f6:	00000097          	auipc	ra,0x0
    800034fa:	a62080e7          	jalr	-1438(ra) # 80002f58 <putback_inode>
        return -1;
    800034fe:	557d                	li	a0,-1
    80003500:	a885                	j	80003570 <dirlink+0xa2>
            panic("dirlink read");
    80003502:	00002517          	auipc	a0,0x2
    80003506:	29e50513          	addi	a0,a0,670 # 800057a0 <digits+0x608>
    8000350a:	ffffe097          	auipc	ra,0xffffe
    8000350e:	0d2080e7          	jalr	210(ra) # 800015dc <panic>
        if (de.inum == 0)
    80003512:	fb045783          	lhu	a5,-80(s0)
    80003516:	c795                	beqz	a5,80003542 <dirlink+0x74>
    for (off = 0; off < dp->size; off += sizeof(de)) {
    80003518:	0104899b          	addiw	s3,s1,16
    8000351c:	04c92783          	lw	a5,76(s2)
    80003520:	0009849b          	sext.w	s1,s3
    80003524:	00f4ff63          	bgeu	s1,a5,80003542 <dirlink+0x74>
        if (read_inode(dp, (uint64) &de, off, sizeof(de)) != sizeof(de))
    80003528:	46c1                	li	a3,16
    8000352a:	8626                	mv	a2,s1
    8000352c:	fb040593          	addi	a1,s0,-80
    80003530:	854a                	mv	a0,s2
    80003532:	00000097          	auipc	ra,0x0
    80003536:	c40080e7          	jalr	-960(ra) # 80003172 <read_inode>
    8000353a:	47c1                	li	a5,16
    8000353c:	fcf50be3          	beq	a0,a5,80003512 <dirlink+0x44>
    80003540:	b7c9                	j	80003502 <dirlink+0x34>
    strncpy(de.name, name, DIRSIZ);
    80003542:	4639                	li	a2,14
    80003544:	85d2                	mv	a1,s4
    80003546:	fb240513          	addi	a0,s0,-78
    8000354a:	ffffe097          	auipc	ra,0xffffe
    8000354e:	b1c080e7          	jalr	-1252(ra) # 80001066 <strncpy>
    de.inum = inum;
    80003552:	fb541823          	sh	s5,-80(s0)
    if (write_inode(dp, (uint64) &de, off, sizeof(de)) != sizeof(de))
    80003556:	46c1                	li	a3,16
    80003558:	864e                	mv	a2,s3
    8000355a:	fb040593          	addi	a1,s0,-80
    8000355e:	854a                	mv	a0,s2
    80003560:	00000097          	auipc	ra,0x0
    80003564:	cd6080e7          	jalr	-810(ra) # 80003236 <write_inode>
    80003568:	47c1                	li	a5,16
    8000356a:	00f51c63          	bne	a0,a5,80003582 <dirlink+0xb4>
    return 0;
    8000356e:	4501                	li	a0,0
}
    80003570:	60a6                	ld	ra,72(sp)
    80003572:	6406                	ld	s0,64(sp)
    80003574:	74e2                	ld	s1,56(sp)
    80003576:	7942                	ld	s2,48(sp)
    80003578:	79a2                	ld	s3,40(sp)
    8000357a:	7a02                	ld	s4,32(sp)
    8000357c:	6ae2                	ld	s5,24(sp)
    8000357e:	6161                	addi	sp,sp,80
    80003580:	8082                	ret
        panic("dirlink");
    80003582:	00002517          	auipc	a0,0x2
    80003586:	22e50513          	addi	a0,a0,558 # 800057b0 <digits+0x618>
    8000358a:	ffffe097          	auipc	ra,0xffffe
    8000358e:	052080e7          	jalr	82(ra) # 800015dc <panic>
    return 0;
    80003592:	4501                	li	a0,0
    80003594:	bff1                	j	80003570 <dirlink+0xa2>

0000000080003596 <namei>:

struct inode *namei(char *path) {
    80003596:	1101                	addi	sp,sp,-32
    80003598:	ec06                	sd	ra,24(sp)
    8000359a:	e822                	sd	s0,16(sp)
    8000359c:	1000                	addi	s0,sp,32
    char name[DIRSIZ];
    return namex(path, 0, name);
    8000359e:	fe040613          	addi	a2,s0,-32
    800035a2:	4581                	li	a1,0
    800035a4:	00000097          	auipc	ra,0x0
    800035a8:	e48080e7          	jalr	-440(ra) # 800033ec <namex>
}
    800035ac:	60e2                	ld	ra,24(sp)
    800035ae:	6442                	ld	s0,16(sp)
    800035b0:	6105                	addi	sp,sp,32
    800035b2:	8082                	ret

00000000800035b4 <nameiparent>:

struct inode *nameiparent(char *path, char *name) {
    800035b4:	1141                	addi	sp,sp,-16
    800035b6:	e406                	sd	ra,8(sp)
    800035b8:	e022                	sd	s0,0(sp)
    800035ba:	0800                	addi	s0,sp,16
    800035bc:	862e                	mv	a2,a1
    return namex(path, 1, name);
    800035be:	4585                	li	a1,1
    800035c0:	00000097          	auipc	ra,0x0
    800035c4:	e2c080e7          	jalr	-468(ra) # 800033ec <namex>
    800035c8:	60a2                	ld	ra,8(sp)
    800035ca:	6402                	ld	s0,0(sp)
    800035cc:	0141                	addi	sp,sp,16
    800035ce:	8082                	ret

00000000800035d0 <init_buf>:
#define BUFFER_NUM 100

struct buf buf_cache[BUFFER_NUM];
struct spinlock cache_lock;

void init_buf() {
    800035d0:	1101                	addi	sp,sp,-32
    800035d2:	ec06                	sd	ra,24(sp)
    800035d4:	e822                	sd	s0,16(sp)
    800035d6:	e426                	sd	s1,8(sp)
    800035d8:	1000                	addi	s0,sp,32
    spinlock_init(&cache_lock, "cache lock");
    800035da:	00002597          	auipc	a1,0x2
    800035de:	1de58593          	addi	a1,a1,478 # 800057b8 <digits+0x620>
    800035e2:	0004d517          	auipc	a0,0x4d
    800035e6:	4de50513          	addi	a0,a0,1246 # 80050ac0 <cache_lock>
    800035ea:	00000097          	auipc	ra,0x0
    800035ee:	1c0080e7          	jalr	448(ra) # 800037aa <spinlock_init>
    for (int i = 0; i < BUFFER_NUM; i++) {
    800035f2:	4481                	li	s1,0
    800035f4:	06300793          	li	a5,99
    800035f8:	0297c063          	blt	a5,s1,80003618 <init_buf+0x48>
        sleeplock_init(&buf_cache->lock, "buf");
    800035fc:	00002597          	auipc	a1,0x2
    80003600:	1cc58593          	addi	a1,a1,460 # 800057c8 <digits+0x630>
    80003604:	0004d517          	auipc	a0,0x4d
    80003608:	4ec50513          	addi	a0,a0,1260 # 80050af0 <buf_cache+0x18>
    8000360c:	00000097          	auipc	ra,0x0
    80003610:	360080e7          	jalr	864(ra) # 8000396c <sleeplock_init>
    for (int i = 0; i < BUFFER_NUM; i++) {
    80003614:	2485                	addiw	s1,s1,1
    80003616:	bff9                	j	800035f4 <init_buf+0x24>
    }
}
    80003618:	60e2                	ld	ra,24(sp)
    8000361a:	6442                	ld	s0,16(sp)
    8000361c:	64a2                	ld	s1,8(sp)
    8000361e:	6105                	addi	sp,sp,32
    80003620:	8082                	ret

0000000080003622 <alloc_buf>:
extern uint64 ticks;


// 申请使用一个缓冲区，该缓冲区会被锁定
// 先进先出算法
struct buf *alloc_buf(int dev, int blockno) {
    80003622:	7179                	addi	sp,sp,-48
    80003624:	f406                	sd	ra,40(sp)
    80003626:	f022                	sd	s0,32(sp)
    80003628:	ec26                	sd	s1,24(sp)
    8000362a:	e84a                	sd	s2,16(sp)
    8000362c:	e44e                	sd	s3,8(sp)
    8000362e:	e052                	sd	s4,0(sp)
    80003630:	1800                	addi	s0,sp,48
    80003632:	8a2a                	mv	s4,a0
    80003634:	89ae                	mv	s3,a1
    struct buf *b;
    struct buf *earliest = 0;
    spin_lock(&cache_lock);
    80003636:	0004d517          	auipc	a0,0x4d
    8000363a:	48a50513          	addi	a0,a0,1162 # 80050ac0 <cache_lock>
    8000363e:	00000097          	auipc	ra,0x0
    80003642:	200080e7          	jalr	512(ra) # 8000383e <spin_lock>
    struct buf *earliest = 0;
    80003646:	4901                	li	s2,0
    for (b = buf_cache; b < buf_cache + BUFFER_NUM; b++) {
    80003648:	0004d497          	auipc	s1,0x4d
    8000364c:	49048493          	addi	s1,s1,1168 # 80050ad8 <buf_cache>
    80003650:	a809                	j	80003662 <alloc_buf+0x40>
        if (b->refcnt == 0 &&
            (earliest == 0 || b->last_use_tick < earliest->last_use_tick)) {
            earliest = b;
    80003652:	8926                	mv	s2,s1
        }
        if (b->blockno == blockno) {
    80003654:	44d8                	lw	a4,12(s1)
    80003656:	0009879b          	sext.w	a5,s3
    8000365a:	02f70563          	beq	a4,a5,80003684 <alloc_buf+0x62>
    for (b = buf_cache; b < buf_cache + BUFFER_NUM; b++) {
    8000365e:	45048493          	addi	s1,s1,1104
    80003662:	00068797          	auipc	a5,0x68
    80003666:	3b678793          	addi	a5,a5,950 # 8006ba18 <end>
    8000366a:	04f4fc63          	bgeu	s1,a5,800036c2 <alloc_buf+0xa0>
        if (b->refcnt == 0 &&
    8000366e:	44bc                	lw	a5,72(s1)
    80003670:	f3f5                	bnez	a5,80003654 <alloc_buf+0x32>
    80003672:	fe0900e3          	beqz	s2,80003652 <alloc_buf+0x30>
            (earliest == 0 || b->last_use_tick < earliest->last_use_tick)) {
    80003676:	6898                	ld	a4,16(s1)
    80003678:	01093783          	ld	a5,16(s2)
    8000367c:	fcf77ce3          	bgeu	a4,a5,80003654 <alloc_buf+0x32>
            earliest = b;
    80003680:	8926                	mv	s2,s1
    80003682:	bfc9                	j	80003654 <alloc_buf+0x32>
            spin_unlock(&cache_lock);
    80003684:	0004d517          	auipc	a0,0x4d
    80003688:	43c50513          	addi	a0,a0,1084 # 80050ac0 <cache_lock>
    8000368c:	00000097          	auipc	ra,0x0
    80003690:	284080e7          	jalr	644(ra) # 80003910 <spin_unlock>
            b->refcnt++;
    80003694:	44bc                	lw	a5,72(s1)
    80003696:	2785                	addiw	a5,a5,1
    80003698:	c4bc                	sw	a5,72(s1)
            b->last_use_tick = ticks;
    8000369a:	00003797          	auipc	a5,0x3
    8000369e:	9767b783          	ld	a5,-1674(a5) # 80006010 <ticks>
    800036a2:	e89c                	sd	a5,16(s1)
            sleep_lock(&b->lock);
    800036a4:	01848513          	addi	a0,s1,24
    800036a8:	00000097          	auipc	ra,0x0
    800036ac:	2fe080e7          	jalr	766(ra) # 800039a6 <sleep_lock>
    b->refcnt = 1;
    b->blockno = blockno;
    b->dev = dev;
    b->last_use_tick = ticks;
    return b;
}
    800036b0:	8526                	mv	a0,s1
    800036b2:	70a2                	ld	ra,40(sp)
    800036b4:	7402                	ld	s0,32(sp)
    800036b6:	64e2                	ld	s1,24(sp)
    800036b8:	6942                	ld	s2,16(sp)
    800036ba:	69a2                	ld	s3,8(sp)
    800036bc:	6a02                	ld	s4,0(sp)
    800036be:	6145                	addi	sp,sp,48
    800036c0:	8082                	ret
    spin_unlock(&cache_lock);
    800036c2:	0004d517          	auipc	a0,0x4d
    800036c6:	3fe50513          	addi	a0,a0,1022 # 80050ac0 <cache_lock>
    800036ca:	00000097          	auipc	ra,0x0
    800036ce:	246080e7          	jalr	582(ra) # 80003910 <spin_unlock>
    if (earliest == 0) {
    800036d2:	02090363          	beqz	s2,800036f8 <alloc_buf+0xd6>
    b->valid = 0;
    800036d6:	00092023          	sw	zero,0(s2)
    b->refcnt = 1;
    800036da:	4785                	li	a5,1
    800036dc:	04f92423          	sw	a5,72(s2)
    b->blockno = blockno;
    800036e0:	01392623          	sw	s3,12(s2)
    b->dev = dev;
    800036e4:	01492423          	sw	s4,8(s2)
    b->last_use_tick = ticks;
    800036e8:	00003797          	auipc	a5,0x3
    800036ec:	9287b783          	ld	a5,-1752(a5) # 80006010 <ticks>
    800036f0:	00f93823          	sd	a5,16(s2)
    return b;
    800036f4:	84ca                	mv	s1,s2
    800036f6:	bf6d                	j	800036b0 <alloc_buf+0x8e>
        panic("alloc buf");
    800036f8:	00002517          	auipc	a0,0x2
    800036fc:	0d850513          	addi	a0,a0,216 # 800057d0 <digits+0x638>
    80003700:	ffffe097          	auipc	ra,0xffffe
    80003704:	edc080e7          	jalr	-292(ra) # 800015dc <panic>
    80003708:	b7f9                	j	800036d6 <alloc_buf+0xb4>

000000008000370a <buf_read>:
    buf_write(b);
    sleep_unlock(&b->lock);
}

// 读取给定块的内容，返回一个包含该内容的buf
struct buf *buf_read(int dev, int blockno) {
    8000370a:	1101                	addi	sp,sp,-32
    8000370c:	ec06                	sd	ra,24(sp)
    8000370e:	e822                	sd	s0,16(sp)
    80003710:	e426                	sd	s1,8(sp)
    80003712:	1000                	addi	s0,sp,32
    struct buf *b = alloc_buf(dev, blockno);
    80003714:	00000097          	auipc	ra,0x0
    80003718:	f0e080e7          	jalr	-242(ra) # 80003622 <alloc_buf>
    8000371c:	84aa                	mv	s1,a0
    if (!b->valid) {
    8000371e:	411c                	lw	a5,0(a0)
    80003720:	cb89                	beqz	a5,80003732 <buf_read+0x28>
        virtio_disk_rw(b, 0);
    }
    b->valid = 1;
    80003722:	4785                	li	a5,1
    80003724:	c09c                	sw	a5,0(s1)
    return b;
}
    80003726:	8526                	mv	a0,s1
    80003728:	60e2                	ld	ra,24(sp)
    8000372a:	6442                	ld	s0,16(sp)
    8000372c:	64a2                	ld	s1,8(sp)
    8000372e:	6105                	addi	sp,sp,32
    80003730:	8082                	ret
        virtio_disk_rw(b, 0);
    80003732:	4581                	li	a1,0
    80003734:	fffff097          	auipc	ra,0xfffff
    80003738:	bba080e7          	jalr	-1094(ra) # 800022ee <virtio_disk_rw>
    8000373c:	b7dd                	j	80003722 <buf_read+0x18>

000000008000373e <buf_write>:

// 将缓冲区写入磁盘
void buf_write(struct buf *b) {
    8000373e:	1141                	addi	sp,sp,-16
    80003740:	e406                	sd	ra,8(sp)
    80003742:	e022                	sd	s0,0(sp)
    80003744:	0800                	addi	s0,sp,16
    virtio_disk_rw(b, 1);
    80003746:	4585                	li	a1,1
    80003748:	fffff097          	auipc	ra,0xfffff
    8000374c:	ba6080e7          	jalr	-1114(ra) # 800022ee <virtio_disk_rw>
}
    80003750:	60a2                	ld	ra,8(sp)
    80003752:	6402                	ld	s0,0(sp)
    80003754:	0141                	addi	sp,sp,16
    80003756:	8082                	ret

0000000080003758 <relse_buf>:
void relse_buf(struct buf *b) {
    80003758:	1101                	addi	sp,sp,-32
    8000375a:	ec06                	sd	ra,24(sp)
    8000375c:	e822                	sd	s0,16(sp)
    8000375e:	e426                	sd	s1,8(sp)
    80003760:	e04a                	sd	s2,0(sp)
    80003762:	1000                	addi	s0,sp,32
    80003764:	84aa                	mv	s1,a0
    spin_lock(&cache_lock);
    80003766:	0004d917          	auipc	s2,0x4d
    8000376a:	35a90913          	addi	s2,s2,858 # 80050ac0 <cache_lock>
    8000376e:	854a                	mv	a0,s2
    80003770:	00000097          	auipc	ra,0x0
    80003774:	0ce080e7          	jalr	206(ra) # 8000383e <spin_lock>
    b->refcnt--;
    80003778:	44bc                	lw	a5,72(s1)
    8000377a:	37fd                	addiw	a5,a5,-1
    8000377c:	c4bc                	sw	a5,72(s1)
    spin_unlock(&cache_lock);
    8000377e:	854a                	mv	a0,s2
    80003780:	00000097          	auipc	ra,0x0
    80003784:	190080e7          	jalr	400(ra) # 80003910 <spin_unlock>
    buf_write(b);
    80003788:	8526                	mv	a0,s1
    8000378a:	00000097          	auipc	ra,0x0
    8000378e:	fb4080e7          	jalr	-76(ra) # 8000373e <buf_write>
    sleep_unlock(&b->lock);
    80003792:	01848513          	addi	a0,s1,24
    80003796:	00000097          	auipc	ra,0x0
    8000379a:	264080e7          	jalr	612(ra) # 800039fa <sleep_unlock>
}
    8000379e:	60e2                	ld	ra,24(sp)
    800037a0:	6442                	ld	s0,16(sp)
    800037a2:	64a2                	ld	s1,8(sp)
    800037a4:	6902                	ld	s2,0(sp)
    800037a6:	6105                	addi	sp,sp,32
    800037a8:	8082                	ret

00000000800037aa <spinlock_init>:
#include "lock.h"
#include "../riscv.h"
#include "../process.h"
#include "../defs.h"

void spinlock_init(struct spinlock *lk, char *name) {
    800037aa:	1141                	addi	sp,sp,-16
    800037ac:	e422                	sd	s0,8(sp)
    800037ae:	0800                	addi	s0,sp,16
    lk->cpu = 0;
    800037b0:	00053423          	sd	zero,8(a0)
    lk->name = name;
    800037b4:	e90c                	sd	a1,16(a0)
    lk->locked = 0;
    800037b6:	00052023          	sw	zero,0(a0)
}
    800037ba:	6422                	ld	s0,8(sp)
    800037bc:	0141                	addi	sp,sp,16
    800037be:	8082                	ret

00000000800037c0 <spin_holding>:

// 检查当前cpu是否持有这个锁
// 需要关中断
int spin_holding(struct spinlock *lk) {
    int r;
    r = (lk->locked && lk->cpu == mycpu());
    800037c0:	411c                	lw	a5,0(a0)
    800037c2:	e399                	bnez	a5,800037c8 <spin_holding+0x8>
    800037c4:	4501                	li	a0,0
    return r;
}
    800037c6:	8082                	ret
int spin_holding(struct spinlock *lk) {
    800037c8:	1101                	addi	sp,sp,-32
    800037ca:	ec06                	sd	ra,24(sp)
    800037cc:	e822                	sd	s0,16(sp)
    800037ce:	e426                	sd	s1,8(sp)
    800037d0:	1000                	addi	s0,sp,32
    r = (lk->locked && lk->cpu == mycpu());
    800037d2:	6504                	ld	s1,8(a0)
    800037d4:	ffffd097          	auipc	ra,0xffffd
    800037d8:	1cc080e7          	jalr	460(ra) # 800009a0 <mycpu>
    800037dc:	00a48863          	beq	s1,a0,800037ec <spin_holding+0x2c>
    800037e0:	4501                	li	a0,0
}
    800037e2:	60e2                	ld	ra,24(sp)
    800037e4:	6442                	ld	s0,16(sp)
    800037e6:	64a2                	ld	s1,8(sp)
    800037e8:	6105                	addi	sp,sp,32
    800037ea:	8082                	ret
    r = (lk->locked && lk->cpu == mycpu());
    800037ec:	4505                	li	a0,1
    800037ee:	bfd5                	j	800037e2 <spin_holding+0x22>

00000000800037f0 <push_off>:

// push_off/pop_off 和 intr_off/intr_on 差不多，只是使得
// 开关中断可以嵌套使用。
void push_off(void) {
    800037f0:	1101                	addi	sp,sp,-32
    800037f2:	ec06                	sd	ra,24(sp)
    800037f4:	e822                	sd	s0,16(sp)
    800037f6:	e426                	sd	s1,8(sp)
    800037f8:	1000                	addi	s0,sp,32

static inline uint64
r_sstatus()
{
  uint64 x;
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800037fa:	100027f3          	csrr	a5,sstatus
// are device interrupts enabled?
static inline int
intr_get()
{
  uint64 x = r_sstatus();
  return (x & SSTATUS_SIE) != 0;
    800037fe:	8b89                	andi	a5,a5,2
    80003800:	00f034b3          	snez	s1,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003804:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80003808:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000380a:	10079073          	csrw	sstatus,a5
    int old = intr_get();
    intr_off();
    if (mycpu()->noff == 0)
    8000380e:	ffffd097          	auipc	ra,0xffffd
    80003812:	192080e7          	jalr	402(ra) # 800009a0 <mycpu>
    80003816:	5d3c                	lw	a5,120(a0)
    80003818:	cf89                	beqz	a5,80003832 <push_off+0x42>
        mycpu()->intr_enable = old;
    mycpu()->noff += 1;
    8000381a:	ffffd097          	auipc	ra,0xffffd
    8000381e:	186080e7          	jalr	390(ra) # 800009a0 <mycpu>
    80003822:	5d3c                	lw	a5,120(a0)
    80003824:	2785                	addiw	a5,a5,1
    80003826:	dd3c                	sw	a5,120(a0)
}
    80003828:	60e2                	ld	ra,24(sp)
    8000382a:	6442                	ld	s0,16(sp)
    8000382c:	64a2                	ld	s1,8(sp)
    8000382e:	6105                	addi	sp,sp,32
    80003830:	8082                	ret
        mycpu()->intr_enable = old;
    80003832:	ffffd097          	auipc	ra,0xffffd
    80003836:	16e080e7          	jalr	366(ra) # 800009a0 <mycpu>
    8000383a:	dd64                	sw	s1,124(a0)
    8000383c:	bff9                	j	8000381a <push_off+0x2a>

000000008000383e <spin_lock>:
void spin_lock(struct spinlock *lk) {
    8000383e:	1101                	addi	sp,sp,-32
    80003840:	ec06                	sd	ra,24(sp)
    80003842:	e822                	sd	s0,16(sp)
    80003844:	e426                	sd	s1,8(sp)
    80003846:	1000                	addi	s0,sp,32
    80003848:	84aa                	mv	s1,a0
    push_off(); // 禁用中断以避免死锁。
    8000384a:	00000097          	auipc	ra,0x0
    8000384e:	fa6080e7          	jalr	-90(ra) # 800037f0 <push_off>
    if (spin_holding(lk)){
    80003852:	8526                	mv	a0,s1
    80003854:	00000097          	auipc	ra,0x0
    80003858:	f6c080e7          	jalr	-148(ra) # 800037c0 <spin_holding>
    8000385c:	e115                	bnez	a0,80003880 <spin_lock+0x42>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0);
    8000385e:	4785                	li	a5,1
    80003860:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80003864:	2781                	sext.w	a5,a5
    80003866:	ffe5                	bnez	a5,8000385e <spin_lock+0x20>
    __sync_synchronize();
    80003868:	0ff0000f          	fence
    lk->cpu = mycpu();
    8000386c:	ffffd097          	auipc	ra,0xffffd
    80003870:	134080e7          	jalr	308(ra) # 800009a0 <mycpu>
    80003874:	e488                	sd	a0,8(s1)
}
    80003876:	60e2                	ld	ra,24(sp)
    80003878:	6442                	ld	s0,16(sp)
    8000387a:	64a2                	ld	s1,8(sp)
    8000387c:	6105                	addi	sp,sp,32
    8000387e:	8082                	ret
        printf("lock=%s",lk->name);
    80003880:	688c                	ld	a1,16(s1)
    80003882:	00002517          	auipc	a0,0x2
    80003886:	f5e50513          	addi	a0,a0,-162 # 800057e0 <digits+0x648>
    8000388a:	ffffe097          	auipc	ra,0xffffe
    8000388e:	c9a080e7          	jalr	-870(ra) # 80001524 <printf>
        panic("re-acquire");
    80003892:	00002517          	auipc	a0,0x2
    80003896:	f5650513          	addi	a0,a0,-170 # 800057e8 <digits+0x650>
    8000389a:	ffffe097          	auipc	ra,0xffffe
    8000389e:	d42080e7          	jalr	-702(ra) # 800015dc <panic>
    800038a2:	bf75                	j	8000385e <spin_lock+0x20>

00000000800038a4 <pop_off>:

void pop_off(void) {
    800038a4:	1101                	addi	sp,sp,-32
    800038a6:	ec06                	sd	ra,24(sp)
    800038a8:	e822                	sd	s0,16(sp)
    800038aa:	e426                	sd	s1,8(sp)
    800038ac:	1000                	addi	s0,sp,32
    struct cpu *c = mycpu();
    800038ae:	ffffd097          	auipc	ra,0xffffd
    800038b2:	0f2080e7          	jalr	242(ra) # 800009a0 <mycpu>
    800038b6:	84aa                	mv	s1,a0
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800038b8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800038bc:	8b89                	andi	a5,a5,2
    if (intr_get())
    800038be:	e79d                	bnez	a5,800038ec <pop_off+0x48>
        panic("pop_off - interruptible");
    if (c->noff < 1)
    800038c0:	5cbc                	lw	a5,120(s1)
    800038c2:	02f05e63          	blez	a5,800038fe <pop_off+0x5a>
        panic("pop_off");
    c->noff -= 1;
    800038c6:	5cbc                	lw	a5,120(s1)
    800038c8:	37fd                	addiw	a5,a5,-1
    800038ca:	0007871b          	sext.w	a4,a5
    800038ce:	dcbc                	sw	a5,120(s1)
    if (c->noff == 0 && c->intr_enable)
    800038d0:	eb09                	bnez	a4,800038e2 <pop_off+0x3e>
    800038d2:	5cfc                	lw	a5,124(s1)
    800038d4:	c799                	beqz	a5,800038e2 <pop_off+0x3e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800038d6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800038da:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800038de:	10079073          	csrw	sstatus,a5
        intr_on();
}
    800038e2:	60e2                	ld	ra,24(sp)
    800038e4:	6442                	ld	s0,16(sp)
    800038e6:	64a2                	ld	s1,8(sp)
    800038e8:	6105                	addi	sp,sp,32
    800038ea:	8082                	ret
        panic("pop_off - interruptible");
    800038ec:	00002517          	auipc	a0,0x2
    800038f0:	f0c50513          	addi	a0,a0,-244 # 800057f8 <digits+0x660>
    800038f4:	ffffe097          	auipc	ra,0xffffe
    800038f8:	ce8080e7          	jalr	-792(ra) # 800015dc <panic>
    800038fc:	b7d1                	j	800038c0 <pop_off+0x1c>
        panic("pop_off");
    800038fe:	00002517          	auipc	a0,0x2
    80003902:	f1250513          	addi	a0,a0,-238 # 80005810 <digits+0x678>
    80003906:	ffffe097          	auipc	ra,0xffffe
    8000390a:	cd6080e7          	jalr	-810(ra) # 800015dc <panic>
    8000390e:	bf65                	j	800038c6 <pop_off+0x22>

0000000080003910 <spin_unlock>:
void spin_unlock(struct spinlock *lk) {
    80003910:	1101                	addi	sp,sp,-32
    80003912:	ec06                	sd	ra,24(sp)
    80003914:	e822                	sd	s0,16(sp)
    80003916:	e426                	sd	s1,8(sp)
    80003918:	1000                	addi	s0,sp,32
    8000391a:	84aa                	mv	s1,a0
    if (!spin_holding(lk)){
    8000391c:	00000097          	auipc	ra,0x0
    80003920:	ea4080e7          	jalr	-348(ra) # 800037c0 <spin_holding>
    80003924:	c115                	beqz	a0,80003948 <spin_unlock+0x38>
    lk->cpu = 0;
    80003926:	0004b423          	sd	zero,8(s1)
    __sync_synchronize();
    8000392a:	0ff0000f          	fence
    __sync_lock_release(&lk->locked);
    8000392e:	0f50000f          	fence	iorw,ow
    80003932:	0804a02f          	amoswap.w	zero,zero,(s1)
    pop_off();
    80003936:	00000097          	auipc	ra,0x0
    8000393a:	f6e080e7          	jalr	-146(ra) # 800038a4 <pop_off>
}
    8000393e:	60e2                	ld	ra,24(sp)
    80003940:	6442                	ld	s0,16(sp)
    80003942:	64a2                	ld	s1,8(sp)
    80003944:	6105                	addi	sp,sp,32
    80003946:	8082                	ret
        printf("%s\n", lk->name);
    80003948:	688c                	ld	a1,16(s1)
    8000394a:	00002517          	auipc	a0,0x2
    8000394e:	81e50513          	addi	a0,a0,-2018 # 80005168 <etext+0x168>
    80003952:	ffffe097          	auipc	ra,0xffffe
    80003956:	bd2080e7          	jalr	-1070(ra) # 80001524 <printf>
        panic("release");
    8000395a:	00002517          	auipc	a0,0x2
    8000395e:	ebe50513          	addi	a0,a0,-322 # 80005818 <digits+0x680>
    80003962:	ffffe097          	auipc	ra,0xffffe
    80003966:	c7a080e7          	jalr	-902(ra) # 800015dc <panic>
    8000396a:	bf75                	j	80003926 <spin_unlock+0x16>

000000008000396c <sleeplock_init>:
#include "lock.h"
#include "../process.h"
#include "../defs.h"

void sleeplock_init(struct sleeplock* lk, char* name)
{
    8000396c:	1101                	addi	sp,sp,-32
    8000396e:	ec06                	sd	ra,24(sp)
    80003970:	e822                	sd	s0,16(sp)
    80003972:	e426                	sd	s1,8(sp)
    80003974:	e04a                	sd	s2,0(sp)
    80003976:	1000                	addi	s0,sp,32
    80003978:	84aa                	mv	s1,a0
    8000397a:	892e                	mv	s2,a1
  spinlock_init(&lk->lk, "sleep lock");
    8000397c:	00002597          	auipc	a1,0x2
    80003980:	ea458593          	addi	a1,a1,-348 # 80005820 <digits+0x688>
    80003984:	0521                	addi	a0,a0,8
    80003986:	00000097          	auipc	ra,0x0
    8000398a:	e24080e7          	jalr	-476(ra) # 800037aa <spinlock_init>
  lk->name = name;
    8000398e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003992:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003996:	0204a423          	sw	zero,40(s1)
}
    8000399a:	60e2                	ld	ra,24(sp)
    8000399c:	6442                	ld	s0,16(sp)
    8000399e:	64a2                	ld	s1,8(sp)
    800039a0:	6902                	ld	s2,0(sp)
    800039a2:	6105                	addi	sp,sp,32
    800039a4:	8082                	ret

00000000800039a6 <sleep_lock>:

void sleep_lock(struct sleeplock* lk)
{
    800039a6:	1101                	addi	sp,sp,-32
    800039a8:	ec06                	sd	ra,24(sp)
    800039aa:	e822                	sd	s0,16(sp)
    800039ac:	e426                	sd	s1,8(sp)
    800039ae:	e04a                	sd	s2,0(sp)
    800039b0:	1000                	addi	s0,sp,32
    800039b2:	84aa                	mv	s1,a0
  spin_lock(&lk->lk);
    800039b4:	00850913          	addi	s2,a0,8
    800039b8:	854a                	mv	a0,s2
    800039ba:	00000097          	auipc	ra,0x0
    800039be:	e84080e7          	jalr	-380(ra) # 8000383e <spin_lock>
  while (lk->locked) {
    800039c2:	409c                	lw	a5,0(s1)
    800039c4:	cb81                	beqz	a5,800039d4 <sleep_lock+0x2e>
    sleep(lk, &lk->lk);
    800039c6:	85ca                	mv	a1,s2
    800039c8:	8526                	mv	a0,s1
    800039ca:	ffffd097          	auipc	ra,0xffffd
    800039ce:	10c080e7          	jalr	268(ra) # 80000ad6 <sleep>
    800039d2:	bfc5                	j	800039c2 <sleep_lock+0x1c>
  }
  lk->locked = 1;
    800039d4:	4785                	li	a5,1
    800039d6:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800039d8:	ffffd097          	auipc	ra,0xffffd
    800039dc:	fec080e7          	jalr	-20(ra) # 800009c4 <myproc>
    800039e0:	5d1c                	lw	a5,56(a0)
    800039e2:	d49c                	sw	a5,40(s1)
  spin_unlock(&lk->lk);
    800039e4:	854a                	mv	a0,s2
    800039e6:	00000097          	auipc	ra,0x0
    800039ea:	f2a080e7          	jalr	-214(ra) # 80003910 <spin_unlock>
}
    800039ee:	60e2                	ld	ra,24(sp)
    800039f0:	6442                	ld	s0,16(sp)
    800039f2:	64a2                	ld	s1,8(sp)
    800039f4:	6902                	ld	s2,0(sp)
    800039f6:	6105                	addi	sp,sp,32
    800039f8:	8082                	ret

00000000800039fa <sleep_unlock>:

void sleep_unlock(struct sleeplock* lk)
{
    800039fa:	1101                	addi	sp,sp,-32
    800039fc:	ec06                	sd	ra,24(sp)
    800039fe:	e822                	sd	s0,16(sp)
    80003a00:	e426                	sd	s1,8(sp)
    80003a02:	e04a                	sd	s2,0(sp)
    80003a04:	1000                	addi	s0,sp,32
    80003a06:	84aa                	mv	s1,a0
  spin_lock(&lk->lk);
    80003a08:	00850913          	addi	s2,a0,8
    80003a0c:	854a                	mv	a0,s2
    80003a0e:	00000097          	auipc	ra,0x0
    80003a12:	e30080e7          	jalr	-464(ra) # 8000383e <spin_lock>
  lk->locked = 0;
    80003a16:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a1a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a1e:	8526                	mv	a0,s1
    80003a20:	ffffd097          	auipc	ra,0xffffd
    80003a24:	194080e7          	jalr	404(ra) # 80000bb4 <wakeup>
  spin_unlock(&lk->lk);
    80003a28:	854a                	mv	a0,s2
    80003a2a:	00000097          	auipc	ra,0x0
    80003a2e:	ee6080e7          	jalr	-282(ra) # 80003910 <spin_unlock>
}
    80003a32:	60e2                	ld	ra,24(sp)
    80003a34:	6442                	ld	s0,16(sp)
    80003a36:	64a2                	ld	s1,8(sp)
    80003a38:	6902                	ld	s2,0(sp)
    80003a3a:	6105                	addi	sp,sp,32
    80003a3c:	8082                	ret

0000000080003a3e <sleep_holding>:

int sleep_holding(struct sleeplock* lk)
{
    80003a3e:	1101                	addi	sp,sp,-32
    80003a40:	ec06                	sd	ra,24(sp)
    80003a42:	e822                	sd	s0,16(sp)
    80003a44:	e426                	sd	s1,8(sp)
    80003a46:	e04a                	sd	s2,0(sp)
    80003a48:	1000                	addi	s0,sp,32
    80003a4a:	84aa                	mv	s1,a0
  int r;
  spin_lock(&lk->lk);
    80003a4c:	00850913          	addi	s2,a0,8
    80003a50:	854a                	mv	a0,s2
    80003a52:	00000097          	auipc	ra,0x0
    80003a56:	dec080e7          	jalr	-532(ra) # 8000383e <spin_lock>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a5a:	409c                	lw	a5,0(s1)
    80003a5c:	ef91                	bnez	a5,80003a78 <sleep_holding+0x3a>
    80003a5e:	4481                	li	s1,0
  spin_unlock(&lk->lk);
    80003a60:	854a                	mv	a0,s2
    80003a62:	00000097          	auipc	ra,0x0
    80003a66:	eae080e7          	jalr	-338(ra) # 80003910 <spin_unlock>
  return r;
}
    80003a6a:	8526                	mv	a0,s1
    80003a6c:	60e2                	ld	ra,24(sp)
    80003a6e:	6442                	ld	s0,16(sp)
    80003a70:	64a2                	ld	s1,8(sp)
    80003a72:	6902                	ld	s2,0(sp)
    80003a74:	6105                	addi	sp,sp,32
    80003a76:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a78:	5484                	lw	s1,40(s1)
    80003a7a:	ffffd097          	auipc	ra,0xffffd
    80003a7e:	f4a080e7          	jalr	-182(ra) # 800009c4 <myproc>
    80003a82:	5d1c                	lw	a5,56(a0)
    80003a84:	00f48463          	beq	s1,a5,80003a8c <sleep_holding+0x4e>
    80003a88:	4481                	li	s1,0
    80003a8a:	bfd9                	j	80003a60 <sleep_holding+0x22>
    80003a8c:	4485                	li	s1,1
    80003a8e:	bfc9                	j	80003a60 <sleep_holding+0x22>
	...

0000000080004000 <_trampoline>:
    80004000:	18059073          	csrw	satp,a1
    80004004:	12000073          	sfence.vma
    80004008:	03053103          	ld	sp,48(a0)
    8000400c:	01853283          	ld	t0,24(a0)
    80004010:	8282                	jr	t0
	...
