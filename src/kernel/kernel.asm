
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
    80000094:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ff51dcf>
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
    80000100:	00c50513          	addi	a0,a0,12 # 80005108 <etext+0x108>
    80000104:	00001097          	auipc	ra,0x1
    80000108:	228080e7          	jalr	552(ra) # 8000132c <printf>
    printf("xv6 kernel is booting\n");
    8000010c:	00005517          	auipc	a0,0x5
    80000110:	ef450513          	addi	a0,a0,-268 # 80005000 <etext>
    80000114:	00001097          	auipc	ra,0x1
    80000118:	218080e7          	jalr	536(ra) # 8000132c <printf>
    printf("\n");
    8000011c:	00005517          	auipc	a0,0x5
    80000120:	fec50513          	addi	a0,a0,-20 # 80005108 <etext+0x108>
    80000124:	00001097          	auipc	ra,0x1
    80000128:	208080e7          	jalr	520(ra) # 8000132c <printf>
    trapinit();             // 初始化trap
    8000012c:	00003097          	auipc	ra,0x3
    80000130:	5f8080e7          	jalr	1528(ra) # 80003724 <trapinit>
    plicinit();             // 初始化plic
    80000134:	00000097          	auipc	ra,0x0
    80000138:	2f6080e7          	jalr	758(ra) # 8000042a <plicinit>
    plicinithart();
    8000013c:	00000097          	auipc	ra,0x0
    80000140:	304080e7          	jalr	772(ra) # 80000440 <plicinithart>
    kernel_mem_init();      // 初始化内存
    80000144:	00001097          	auipc	ra,0x1
    80000148:	38a080e7          	jalr	906(ra) # 800014ce <kernel_mem_init>
    kernel_vm_init();       // 初始化内核虚拟内存
    8000014c:	00001097          	auipc	ra,0x1
    80000150:	606080e7          	jalr	1542(ra) # 80001752 <kernel_vm_init>
    vm_hart_init();         // 启用分页
    80000154:	00001097          	auipc	ra,0x1
    80000158:	416080e7          	jalr	1046(ra) # 8000156a <vm_hart_init>
    virtio_disk_init();     // 初始化磁盘
    8000015c:	00002097          	auipc	ra,0x2
    80000160:	c44080e7          	jalr	-956(ra) # 80001da0 <virtio_disk_init>
    init_inode_cache();     // 初始化inode cache
    80000164:	00002097          	auipc	ra,0x2
    80000168:	680080e7          	jalr	1664(ra) # 800027e4 <init_inode_cache>
    init_buf();             // 初始化磁盘块缓冲
    8000016c:	00003097          	auipc	ra,0x3
    80000170:	0f0080e7          	jalr	240(ra) # 8000325c <init_buf>
    init_process_table();   // 初始化进程表
    80000174:	00000097          	auipc	ra,0x0
    80000178:	462080e7          	jalr	1122(ra) # 800005d6 <init_process_table>
    init_first_process();   // 初始化第一个进程
    8000017c:	00000097          	auipc	ra,0x0
    80000180:	604080e7          	jalr	1540(ra) # 80000780 <init_first_process>
    scheduler();
    80000184:	00001097          	auipc	ra,0x1
    80000188:	944080e7          	jalr	-1724(ra) # 80000ac8 <scheduler>
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
    8000023c:	118080e7          	jalr	280(ra) # 80000350 <console_intr>
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
    80000266:	7179                	addi	sp,sp,-48
    80000268:	f406                	sd	ra,40(sp)
    8000026a:	f022                	sd	s0,32(sp)
    8000026c:	ec26                	sd	s1,24(sp)
    8000026e:	e84a                	sd	s2,16(sp)
    80000270:	e44e                	sd	s3,8(sp)
    80000272:	1800                	addi	s0,sp,48
    80000274:	84aa                	mv	s1,a0
    int cnt = 0;
    struct proc *p = myproc();
    80000276:	00000097          	auipc	ra,0x0
    8000027a:	5c0080e7          	jalr	1472(ra) # 80000836 <myproc>
    8000027e:	892a                	mv	s2,a0
    spin_lock(&p->proc_lock);
    80000280:	00003097          	auipc	ra,0x3
    80000284:	24a080e7          	jalr	586(ra) # 800034ca <spin_lock>
    sleep(&consloe_buf, &p->proc_lock);
    80000288:	00007997          	auipc	s3,0x7
    8000028c:	e9898993          	addi	s3,s3,-360 # 80007120 <consloe_buf>
    80000290:	85ca                	mv	a1,s2
    80000292:	854e                	mv	a0,s3
    80000294:	00000097          	auipc	ra,0x0
    80000298:	6de080e7          	jalr	1758(ra) # 80000972 <sleep>
    for (int i = consloe_buf.read_index; i < consloe_buf.write_index; i++) {
    8000029c:	0e09a783          	lw	a5,224(s3)
    800002a0:	0e49a703          	lw	a4,228(s3)
    800002a4:	02e7d963          	bge	a5,a4,800002d6 <read_line+0x70>
    800002a8:	8626                	mv	a2,s1
    int cnt = 0;
    800002aa:	4681                	li	a3,0
        s[cnt++] = consloe_buf.buf[i % INPUT_BUF];
    800002ac:	85ce                	mv	a1,s3
    800002ae:	0c800813          	li	a6,200
        if (consloe_buf.buf[i % INPUT_BUF] == '\n') {
    800002b2:	4529                	li	a0,10
        s[cnt++] = consloe_buf.buf[i % INPUT_BUF];
    800002b4:	89b6                	mv	s3,a3
    800002b6:	2685                	addiw	a3,a3,1
    800002b8:	0307e73b          	remw	a4,a5,a6
    800002bc:	972e                	add	a4,a4,a1
    800002be:	01874703          	lbu	a4,24(a4)
    800002c2:	00e60023          	sb	a4,0(a2)
        if (consloe_buf.buf[i % INPUT_BUF] == '\n') {
    800002c6:	02a70663          	beq	a4,a0,800002f2 <read_line+0x8c>
    for (int i = consloe_buf.read_index; i < consloe_buf.write_index; i++) {
    800002ca:	2785                	addiw	a5,a5,1
    800002cc:	0605                	addi	a2,a2,1
    800002ce:	0e45a703          	lw	a4,228(a1)
    800002d2:	fee7c1e3          	blt	a5,a4,800002b4 <read_line+0x4e>
            s[cnt - 1] = 0;
            spin_unlock(&p->proc_lock);
            return cnt - 1;
        }
    }
    spin_unlock(&p->proc_lock);
    800002d6:	854a                	mv	a0,s2
    800002d8:	00003097          	auipc	ra,0x3
    800002dc:	2c6080e7          	jalr	710(ra) # 8000359e <spin_unlock>
    return -1;
    800002e0:	59fd                	li	s3,-1
}
    800002e2:	854e                	mv	a0,s3
    800002e4:	70a2                	ld	ra,40(sp)
    800002e6:	7402                	ld	s0,32(sp)
    800002e8:	64e2                	ld	s1,24(sp)
    800002ea:	6942                	ld	s2,16(sp)
    800002ec:	69a2                	ld	s3,8(sp)
    800002ee:	6145                	addi	sp,sp,48
    800002f0:	8082                	ret
            consloe_buf.read_index = i + 1;
    800002f2:	2785                	addiw	a5,a5,1
    800002f4:	00007717          	auipc	a4,0x7
    800002f8:	f0f72623          	sw	a5,-244(a4) # 80007200 <consloe_buf+0xe0>
            s[cnt - 1] = 0;
    800002fc:	96a6                	add	a3,a3,s1
    800002fe:	fe068fa3          	sb	zero,-1(a3)
            spin_unlock(&p->proc_lock);
    80000302:	854a                	mv	a0,s2
    80000304:	00003097          	auipc	ra,0x3
    80000308:	29a080e7          	jalr	666(ra) # 8000359e <spin_unlock>
            return cnt - 1;
    8000030c:	bfd9                	j	800002e2 <read_line+0x7c>

000000008000030e <console_putc>:

void console_putc(int c)
{
    8000030e:	1141                	addi	sp,sp,-16
    80000310:	e406                	sd	ra,8(sp)
    80000312:	e022                	sd	s0,0(sp)
    80000314:	0800                	addi	s0,sp,16
    if (c == BACKSPACE) {
    80000316:	10000793          	li	a5,256
    8000031a:	00f50a63          	beq	a0,a5,8000032e <console_putc+0x20>
        // if the user typed backspace, overwrite with a space.
        uartputc_sync('\b');
        uartputc_sync(' ');
        uartputc_sync('\b');
    } else {
        uartputc_sync(c);
    8000031e:	00000097          	auipc	ra,0x0
    80000322:	eac080e7          	jalr	-340(ra) # 800001ca <uartputc_sync>
    }
}
    80000326:	60a2                	ld	ra,8(sp)
    80000328:	6402                	ld	s0,0(sp)
    8000032a:	0141                	addi	sp,sp,16
    8000032c:	8082                	ret
        uartputc_sync('\b');
    8000032e:	4521                	li	a0,8
    80000330:	00000097          	auipc	ra,0x0
    80000334:	e9a080e7          	jalr	-358(ra) # 800001ca <uartputc_sync>
        uartputc_sync(' ');
    80000338:	02000513          	li	a0,32
    8000033c:	00000097          	auipc	ra,0x0
    80000340:	e8e080e7          	jalr	-370(ra) # 800001ca <uartputc_sync>
        uartputc_sync('\b');
    80000344:	4521                	li	a0,8
    80000346:	00000097          	auipc	ra,0x0
    8000034a:	e84080e7          	jalr	-380(ra) # 800001ca <uartputc_sync>
    8000034e:	bfe1                	j	80000326 <console_putc+0x18>

0000000080000350 <console_intr>:

void console_intr(char c)
{
    80000350:	1101                	addi	sp,sp,-32
    80000352:	ec06                	sd	ra,24(sp)
    80000354:	e822                	sd	s0,16(sp)
    80000356:	e426                	sd	s1,8(sp)
    80000358:	1000                	addi	s0,sp,32
    switch (c) {
    8000035a:	47c1                	li	a5,16
    8000035c:	04f50263          	beq	a0,a5,800003a0 <console_intr+0x50>
    80000360:	84aa                	mv	s1,a0
    80000362:	07f00793          	li	a5,127
    80000366:	04f51663          	bne	a0,a5,800003b2 <console_intr+0x62>

    case '\x7f': // 退格
        if (consloe_buf.read_index != consloe_buf.write_index) {
    8000036a:	00007717          	auipc	a4,0x7
    8000036e:	db670713          	addi	a4,a4,-586 # 80007120 <consloe_buf>
    80000372:	0e472783          	lw	a5,228(a4)
    80000376:	0e072703          	lw	a4,224(a4)
    8000037a:	02f70763          	beq	a4,a5,800003a8 <console_intr+0x58>
            consloe_buf.write_index--;
    8000037e:	37fd                	addiw	a5,a5,-1
    80000380:	00007717          	auipc	a4,0x7
    80000384:	e8f72223          	sw	a5,-380(a4) # 80007204 <consloe_buf+0xe4>
            console_putc(BACKSPACE);
    80000388:	10000513          	li	a0,256
    8000038c:	00000097          	auipc	ra,0x0
    80000390:	f82080e7          	jalr	-126(ra) # 8000030e <console_putc>
            console_putc('\a');
    80000394:	451d                	li	a0,7
    80000396:	00000097          	auipc	ra,0x0
    8000039a:	f78080e7          	jalr	-136(ra) # 8000030e <console_putc>
    8000039e:	a029                	j	800003a8 <console_intr+0x58>
        }
        break;
    case CTRL('P'):
        print_proc();
    800003a0:	00001097          	auipc	ra,0x1
    800003a4:	a26080e7          	jalr	-1498(ra) # 80000dc6 <print_proc>
        if (c == '\n') {
            wakeup(&consloe_buf);
        }
        break;
    }
}
    800003a8:	60e2                	ld	ra,24(sp)
    800003aa:	6442                	ld	s0,16(sp)
    800003ac:	64a2                	ld	s1,8(sp)
    800003ae:	6105                	addi	sp,sp,32
    800003b0:	8082                	ret
        c = (c == '\r') ? '\n' : c;
    800003b2:	47b5                	li	a5,13
    800003b4:	02f50b63          	beq	a0,a5,800003ea <console_intr+0x9a>
        console_putc(c);
    800003b8:	00000097          	auipc	ra,0x0
    800003bc:	f56080e7          	jalr	-170(ra) # 8000030e <console_putc>
        consloe_buf.buf[consloe_buf.write_index++ % INPUT_BUF] = c;
    800003c0:	00007797          	auipc	a5,0x7
    800003c4:	d6078793          	addi	a5,a5,-672 # 80007120 <consloe_buf>
    800003c8:	0e47a703          	lw	a4,228(a5)
    800003cc:	0017069b          	addiw	a3,a4,1
    800003d0:	0ed7a223          	sw	a3,228(a5)
    800003d4:	0c800693          	li	a3,200
    800003d8:	02d7673b          	remw	a4,a4,a3
    800003dc:	97ba                	add	a5,a5,a4
    800003de:	00978c23          	sb	s1,24(a5)
        if (c == '\n') {
    800003e2:	47a9                	li	a5,10
    800003e4:	fcf492e3          	bne	s1,a5,800003a8 <console_intr+0x58>
    800003e8:	a805                	j	80000418 <console_intr+0xc8>
        console_putc(c);
    800003ea:	4529                	li	a0,10
    800003ec:	00000097          	auipc	ra,0x0
    800003f0:	f22080e7          	jalr	-222(ra) # 8000030e <console_putc>
        consloe_buf.buf[consloe_buf.write_index++ % INPUT_BUF] = c;
    800003f4:	00007797          	auipc	a5,0x7
    800003f8:	d2c78793          	addi	a5,a5,-724 # 80007120 <consloe_buf>
    800003fc:	0e47a703          	lw	a4,228(a5)
    80000400:	0017069b          	addiw	a3,a4,1
    80000404:	0ed7a223          	sw	a3,228(a5)
    80000408:	0c800693          	li	a3,200
    8000040c:	02d7673b          	remw	a4,a4,a3
    80000410:	97ba                	add	a5,a5,a4
    80000412:	4729                	li	a4,10
    80000414:	00e78c23          	sb	a4,24(a5)
            wakeup(&consloe_buf);
    80000418:	00007517          	auipc	a0,0x7
    8000041c:	d0850513          	addi	a0,a0,-760 # 80007120 <consloe_buf>
    80000420:	00000097          	auipc	ra,0x0
    80000424:	66e080e7          	jalr	1646(ra) # 80000a8e <wakeup>
}
    80000428:	b741                	j	800003a8 <console_intr+0x58>

000000008000042a <plicinit>:
//


void
plicinit(void)
{
    8000042a:	1141                	addi	sp,sp,-16
    8000042c:	e422                	sd	s0,8(sp)
    8000042e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  // 设置IRQ的属性为非零
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80000430:	0c0007b7          	lui	a5,0xc000
    80000434:	4705                	li	a4,1
    80000436:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80000438:	c3d8                	sw	a4,4(a5)
}
    8000043a:	6422                	ld	s0,8(sp)
    8000043c:	0141                	addi	sp,sp,16
    8000043e:	8082                	ret

0000000080000440 <plicinithart>:

void
plicinithart(void)
{
    80000440:	1141                	addi	sp,sp,-16
    80000442:	e406                	sd	ra,8(sp)
    80000444:	e022                	sd	s0,0(sp)
    80000446:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80000448:	00000097          	auipc	ra,0x0
    8000044c:	3c2080e7          	jalr	962(ra) # 8000080a <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80000450:	0085171b          	slliw	a4,a0,0x8
    80000454:	0c0027b7          	lui	a5,0xc002
    80000458:	97ba                	add	a5,a5,a4
    8000045a:	40200713          	li	a4,1026
    8000045e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80000462:	00d5151b          	slliw	a0,a0,0xd
    80000466:	0c2017b7          	lui	a5,0xc201
    8000046a:	953e                	add	a0,a0,a5
    8000046c:	00052023          	sw	zero,0(a0)
}
    80000470:	60a2                	ld	ra,8(sp)
    80000472:	6402                	ld	s0,0(sp)
    80000474:	0141                	addi	sp,sp,16
    80000476:	8082                	ret

0000000080000478 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80000478:	1141                	addi	sp,sp,-16
    8000047a:	e406                	sd	ra,8(sp)
    8000047c:	e022                	sd	s0,0(sp)
    8000047e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80000480:	00000097          	auipc	ra,0x0
    80000484:	38a080e7          	jalr	906(ra) # 8000080a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80000488:	00d5179b          	slliw	a5,a0,0xd
    8000048c:	0c201537          	lui	a0,0xc201
    80000490:	953e                	add	a0,a0,a5
  return irq;
}
    80000492:	4148                	lw	a0,4(a0)
    80000494:	60a2                	ld	ra,8(sp)
    80000496:	6402                	ld	s0,0(sp)
    80000498:	0141                	addi	sp,sp,16
    8000049a:	8082                	ret

000000008000049c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000049c:	1101                	addi	sp,sp,-32
    8000049e:	ec06                	sd	ra,24(sp)
    800004a0:	e822                	sd	s0,16(sp)
    800004a2:	e426                	sd	s1,8(sp)
    800004a4:	1000                	addi	s0,sp,32
    800004a6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800004a8:	00000097          	auipc	ra,0x0
    800004ac:	362080e7          	jalr	866(ra) # 8000080a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800004b0:	00d5151b          	slliw	a0,a0,0xd
    800004b4:	0c2017b7          	lui	a5,0xc201
    800004b8:	97aa                	add	a5,a5,a0
    800004ba:	c3c4                	sw	s1,4(a5)
}
    800004bc:	60e2                	ld	ra,24(sp)
    800004be:	6442                	ld	s0,16(sp)
    800004c0:	64a2                	ld	s1,8(sp)
    800004c2:	6105                	addi	sp,sp,32
    800004c4:	8082                	ret
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
    80000510:	4be030ef          	jal	ra,800039ce <kerneltrap>
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
    800005a6:	ffc080e7          	jalr	-4(ra) # 8000359e <spin_unlock>
    if (first) {
    800005aa:	00005797          	auipc	a5,0x5
    800005ae:	0d67a783          	lw	a5,214(a5) # 80005680 <first.1459>
    800005b2:	eb89                	bnez	a5,800005c4 <forkret+0x3c>
    usertrapret();
    800005b4:	00003097          	auipc	ra,0x3
    800005b8:	188080e7          	jalr	392(ra) # 8000373c <usertrapret>
}
    800005bc:	60a2                	ld	ra,8(sp)
    800005be:	6402                	ld	s0,0(sp)
    800005c0:	0141                	addi	sp,sp,16
    800005c2:	8082                	ret
        first = 0;
    800005c4:	00005797          	auipc	a5,0x5
    800005c8:	0a07ae23          	sw	zero,188(a5) # 80005680 <first.1459>
        init_fs();
    800005cc:	00002097          	auipc	ra,0x2
    800005d0:	022080e7          	jalr	34(ra) # 800025ee <init_fs>
    800005d4:	b7c5                	j	800005b4 <forkret+0x2c>

00000000800005d6 <init_process_table>:
void init_process_table() {
    800005d6:	7139                	addi	sp,sp,-64
    800005d8:	fc06                	sd	ra,56(sp)
    800005da:	f822                	sd	s0,48(sp)
    800005dc:	f426                	sd	s1,40(sp)
    800005de:	f04a                	sd	s2,32(sp)
    800005e0:	ec4e                	sd	s3,24(sp)
    800005e2:	e852                	sd	s4,16(sp)
    800005e4:	e456                	sd	s5,8(sp)
    800005e6:	e05a                	sd	s6,0(sp)
    800005e8:	0080                	addi	s0,sp,64
    for (int i = 0; i < NPROC; i++) {
    800005ea:	00089497          	auipc	s1,0x89
    800005ee:	c9e48493          	addi	s1,s1,-866 # 80089288 <proc_table>
    800005f2:	00007997          	auipc	s3,0x7
    800005f6:	c9698993          	addi	s3,s3,-874 # 80007288 <stack>
    800005fa:	4901                	li	s2,0
        spinlock_init(&p->proc_lock, "proc");
    800005fc:	00005b17          	auipc	s6,0x5
    80000600:	a1cb0b13          	addi	s6,s6,-1508 # 80005018 <etext+0x18>
    80000604:	6a85                	lui	s5,0x1
    for (int i = 0; i < NPROC; i++) {
    80000606:	04000a13          	li	s4,64
        spinlock_init(&p->proc_lock, "proc");
    8000060a:	85da                	mv	a1,s6
    8000060c:	8526                	mv	a0,s1
    8000060e:	00003097          	auipc	ra,0x3
    80000612:	e2c080e7          	jalr	-468(ra) # 8000343a <spinlock_init>
        p->pid = i;
    80000616:	0324ac23          	sw	s2,56(s1)
        p->kstack = (uint64) (stack + PGSIZE * i);
    8000061a:	0734b023          	sd	s3,96(s1)
        p->trapframe = 0;
    8000061e:	0404b023          	sd	zero,64(s1)
        p->state = UNUSED;
    80000622:	0004ac23          	sw	zero,24(s1)
    for (int i = 0; i < NPROC; i++) {
    80000626:	2905                	addiw	s2,s2,1
    80000628:	0f048493          	addi	s1,s1,240
    8000062c:	99d6                	add	s3,s3,s5
    8000062e:	fd491ee3          	bne	s2,s4,8000060a <init_process_table+0x34>
}
    80000632:	70e2                	ld	ra,56(sp)
    80000634:	7442                	ld	s0,48(sp)
    80000636:	74a2                	ld	s1,40(sp)
    80000638:	7902                	ld	s2,32(sp)
    8000063a:	69e2                	ld	s3,24(sp)
    8000063c:	6a42                	ld	s4,16(sp)
    8000063e:	6aa2                	ld	s5,8(sp)
    80000640:	6b02                	ld	s6,0(sp)
    80000642:	6121                	addi	sp,sp,64
    80000644:	8082                	ret

0000000080000646 <proc_pagetable>:
pagetable_t proc_pagetable(struct proc *p) {
    80000646:	1101                	addi	sp,sp,-32
    80000648:	ec06                	sd	ra,24(sp)
    8000064a:	e822                	sd	s0,16(sp)
    8000064c:	e426                	sd	s1,8(sp)
    8000064e:	e04a                	sd	s2,0(sp)
    80000650:	1000                	addi	s0,sp,32
    80000652:	892a                	mv	s2,a0
    pagetable = user_vm_create();
    80000654:	00001097          	auipc	ra,0x1
    80000658:	258080e7          	jalr	600(ra) # 800018ac <user_vm_create>
    8000065c:	84aa                	mv	s1,a0
    if (pagetable == 0)
    8000065e:	cd31                	beqz	a0,800006ba <proc_pagetable+0x74>
    if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000660:	4729                	li	a4,10
    80000662:	00004697          	auipc	a3,0x4
    80000666:	99e68693          	addi	a3,a3,-1634 # 80004000 <_trampoline>
    8000066a:	6605                	lui	a2,0x1
    8000066c:	040005b7          	lui	a1,0x4000
    80000670:	15fd                	addi	a1,a1,-1
    80000672:	05b2                	slli	a1,a1,0xc
    80000674:	00001097          	auipc	ra,0x1
    80000678:	fc4080e7          	jalr	-60(ra) # 80001638 <mappages>
    8000067c:	04054663          	bltz	a0,800006c8 <proc_pagetable+0x82>
    printf("TRAPOLINE=%p\n", TRAMPOLINE);
    80000680:	040005b7          	lui	a1,0x4000
    80000684:	15fd                	addi	a1,a1,-1
    80000686:	05b2                	slli	a1,a1,0xc
    80000688:	00005517          	auipc	a0,0x5
    8000068c:	99850513          	addi	a0,a0,-1640 # 80005020 <etext+0x20>
    80000690:	00001097          	auipc	ra,0x1
    80000694:	c9c080e7          	jalr	-868(ra) # 8000132c <printf>
    if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80000698:	4719                	li	a4,6
    8000069a:	04093683          	ld	a3,64(s2)
    8000069e:	6605                	lui	a2,0x1
    800006a0:	020005b7          	lui	a1,0x2000
    800006a4:	15fd                	addi	a1,a1,-1
    800006a6:	05b6                	slli	a1,a1,0xd
    800006a8:	8526                	mv	a0,s1
    800006aa:	00001097          	auipc	ra,0x1
    800006ae:	f8e080e7          	jalr	-114(ra) # 80001638 <mappages>
        return 0;
    800006b2:	fff54513          	not	a0,a0
    800006b6:	957d                	srai	a0,a0,0x3f
    800006b8:	8ce9                	and	s1,s1,a0
}
    800006ba:	8526                	mv	a0,s1
    800006bc:	60e2                	ld	ra,24(sp)
    800006be:	6442                	ld	s0,16(sp)
    800006c0:	64a2                	ld	s1,8(sp)
    800006c2:	6902                	ld	s2,0(sp)
    800006c4:	6105                	addi	sp,sp,32
    800006c6:	8082                	ret
        return 0;
    800006c8:	4481                	li	s1,0
    800006ca:	bfc5                	j	800006ba <proc_pagetable+0x74>

00000000800006cc <alloc_proc>:
struct proc *alloc_proc() {
    800006cc:	1101                	addi	sp,sp,-32
    800006ce:	ec06                	sd	ra,24(sp)
    800006d0:	e822                	sd	s0,16(sp)
    800006d2:	e426                	sd	s1,8(sp)
    800006d4:	e04a                	sd	s2,0(sp)
    800006d6:	1000                	addi	s0,sp,32
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    800006d8:	00089497          	auipc	s1,0x89
    800006dc:	bb048493          	addi	s1,s1,-1104 # 80089288 <proc_table>
    800006e0:	0008c917          	auipc	s2,0x8c
    800006e4:	7a890913          	addi	s2,s2,1960 # 8008ce88 <kmem>
        spin_lock(&p->proc_lock);
    800006e8:	8526                	mv	a0,s1
    800006ea:	00003097          	auipc	ra,0x3
    800006ee:	de0080e7          	jalr	-544(ra) # 800034ca <spin_lock>
        if (p->state == UNUSED) {
    800006f2:	4c9c                	lw	a5,24(s1)
    800006f4:	cf81                	beqz	a5,8000070c <alloc_proc+0x40>
            spin_unlock(&p->proc_lock);
    800006f6:	8526                	mv	a0,s1
    800006f8:	00003097          	auipc	ra,0x3
    800006fc:	ea6080e7          	jalr	-346(ra) # 8000359e <spin_unlock>
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80000700:	0f048493          	addi	s1,s1,240
    80000704:	ff2492e3          	bne	s1,s2,800006e8 <alloc_proc+0x1c>
    return 0;
    80000708:	4481                	li	s1,0
    8000070a:	a8a9                	j	80000764 <alloc_proc+0x98>
    if ((p->trapframe = (struct trapframe *) kalloc()) == 0) {
    8000070c:	00001097          	auipc	ra,0x1
    80000710:	dfe080e7          	jalr	-514(ra) # 8000150a <kalloc>
    80000714:	892a                	mv	s2,a0
    80000716:	e0a8                	sd	a0,64(s1)
    80000718:	cd29                	beqz	a0,80000772 <alloc_proc+0xa6>
    p->pagetable = proc_pagetable(p);
    8000071a:	8526                	mv	a0,s1
    8000071c:	00000097          	auipc	ra,0x0
    80000720:	f2a080e7          	jalr	-214(ra) # 80000646 <proc_pagetable>
    80000724:	e4a8                	sd	a0,72(s1)
    memset(&p->context, 0, sizeof(p->context));
    80000726:	07000613          	li	a2,112
    8000072a:	4581                	li	a1,0
    8000072c:	06848513          	addi	a0,s1,104
    80000730:	00000097          	auipc	ra,0x0
    80000734:	73c080e7          	jalr	1852(ra) # 80000e6c <memset>
    memset(p->trapframe, 0, sizeof(*p->trapframe));
    80000738:	12000613          	li	a2,288
    8000073c:	4581                	li	a1,0
    8000073e:	60a8                	ld	a0,64(s1)
    80000740:	00000097          	auipc	ra,0x0
    80000744:	72c080e7          	jalr	1836(ra) # 80000e6c <memset>
    p->context.sp = p->kstack + PGSIZE;
    80000748:	70bc                	ld	a5,96(s1)
    8000074a:	6705                	lui	a4,0x1
    8000074c:	97ba                	add	a5,a5,a4
    8000074e:	f8bc                	sd	a5,112(s1)
    p->context.ra = (uint64) forkret;
    80000750:	00000797          	auipc	a5,0x0
    80000754:	e3878793          	addi	a5,a5,-456 # 80000588 <forkret>
    80000758:	f4bc                	sd	a5,104(s1)
    spin_unlock(&p->proc_lock);
    8000075a:	8526                	mv	a0,s1
    8000075c:	00003097          	auipc	ra,0x3
    80000760:	e42080e7          	jalr	-446(ra) # 8000359e <spin_unlock>
}
    80000764:	8526                	mv	a0,s1
    80000766:	60e2                	ld	ra,24(sp)
    80000768:	6442                	ld	s0,16(sp)
    8000076a:	64a2                	ld	s1,8(sp)
    8000076c:	6902                	ld	s2,0(sp)
    8000076e:	6105                	addi	sp,sp,32
    80000770:	8082                	ret
        spin_unlock(&p->proc_lock);
    80000772:	8526                	mv	a0,s1
    80000774:	00003097          	auipc	ra,0x3
    80000778:	e2a080e7          	jalr	-470(ra) # 8000359e <spin_unlock>
        return 0;
    8000077c:	84ca                	mv	s1,s2
    8000077e:	b7dd                	j	80000764 <alloc_proc+0x98>

0000000080000780 <init_first_process>:
void init_first_process() {
    80000780:	1101                	addi	sp,sp,-32
    80000782:	ec06                	sd	ra,24(sp)
    80000784:	e822                	sd	s0,16(sp)
    80000786:	e426                	sd	s1,8(sp)
    80000788:	1000                	addi	s0,sp,32
    struct proc *p = alloc_proc();
    8000078a:	00000097          	auipc	ra,0x0
    8000078e:	f42080e7          	jalr	-190(ra) # 800006cc <alloc_proc>
    80000792:	84aa                	mv	s1,a0
    user_vm_init(p->pagetable, initcode, sizeof(initcode));
    80000794:	03400613          	li	a2,52
    80000798:	00005597          	auipc	a1,0x5
    8000079c:	ef858593          	addi	a1,a1,-264 # 80005690 <initcode>
    800007a0:	6528                	ld	a0,72(a0)
    800007a2:	00001097          	auipc	ra,0x1
    800007a6:	138080e7          	jalr	312(ra) # 800018da <user_vm_init>
    p->sz = PGSIZE;
    800007aa:	6785                	lui	a5,0x1
    800007ac:	0ef4a423          	sw	a5,232(s1)
    p->trapframe->epc = 0;
    800007b0:	60bc                	ld	a5,64(s1)
    800007b2:	0007bc23          	sd	zero,24(a5) # 1018 <_entry-0x7fffefe8>
    p->trapframe->sp = PGSIZE;
    800007b6:	60bc                	ld	a5,64(s1)
    800007b8:	6705                	lui	a4,0x1
    800007ba:	fb98                	sd	a4,48(a5)
    memmove(p->name, "initcode", sizeof(p->name));
    800007bc:	4641                	li	a2,16
    800007be:	00005597          	auipc	a1,0x5
    800007c2:	87258593          	addi	a1,a1,-1934 # 80005030 <etext+0x30>
    800007c6:	0d848513          	addi	a0,s1,216
    800007ca:	00000097          	auipc	ra,0x0
    800007ce:	6c8080e7          	jalr	1736(ra) # 80000e92 <memmove>
    p->current_dir = namei("/");
    800007d2:	00005517          	auipc	a0,0x5
    800007d6:	86e50513          	addi	a0,a0,-1938 # 80005040 <etext+0x40>
    800007da:	00003097          	auipc	ra,0x3
    800007de:	a48080e7          	jalr	-1464(ra) # 80003222 <namei>
    800007e2:	e8a8                	sd	a0,80(s1)
    p->state = RUNNABLE;
    800007e4:	4789                	li	a5,2
    800007e6:	cc9c                	sw	a5,24(s1)
    initproc = p;
    800007e8:	00006797          	auipc	a5,0x6
    800007ec:	8097bc23          	sd	s1,-2024(a5) # 80006000 <initproc>
    printf("over");
    800007f0:	00005517          	auipc	a0,0x5
    800007f4:	85850513          	addi	a0,a0,-1960 # 80005048 <etext+0x48>
    800007f8:	00001097          	auipc	ra,0x1
    800007fc:	b34080e7          	jalr	-1228(ra) # 8000132c <printf>
}
    80000800:	60e2                	ld	ra,24(sp)
    80000802:	6442                	ld	s0,16(sp)
    80000804:	64a2                	ld	s1,8(sp)
    80000806:	6105                	addi	sp,sp,32
    80000808:	8082                	ret

000000008000080a <cpuid>:
int cpuid() {
    8000080a:	1141                	addi	sp,sp,-16
    8000080c:	e422                	sd	s0,8(sp)
    8000080e:	0800                	addi	s0,sp,16
    80000810:	8512                	mv	a0,tp
}
    80000812:	2501                	sext.w	a0,a0
    80000814:	6422                	ld	s0,8(sp)
    80000816:	0141                	addi	sp,sp,16
    80000818:	8082                	ret

000000008000081a <mycpu>:
struct cpu *mycpu(void) {
    8000081a:	1141                	addi	sp,sp,-16
    8000081c:	e422                	sd	s0,8(sp)
    8000081e:	0800                	addi	s0,sp,16
    80000820:	8792                	mv	a5,tp
    struct cpu *c = &cpus[id];
    80000822:	2781                	sext.w	a5,a5
    80000824:	079e                	slli	a5,a5,0x7
}
    80000826:	00007517          	auipc	a0,0x7
    8000082a:	9e250513          	addi	a0,a0,-1566 # 80007208 <cpus>
    8000082e:	953e                	add	a0,a0,a5
    80000830:	6422                	ld	s0,8(sp)
    80000832:	0141                	addi	sp,sp,16
    80000834:	8082                	ret

0000000080000836 <myproc>:
struct proc *myproc() {
    80000836:	1141                	addi	sp,sp,-16
    80000838:	e422                	sd	s0,8(sp)
    8000083a:	0800                	addi	s0,sp,16
    8000083c:	8792                	mv	a5,tp
    return mycpu()->proc;
    8000083e:	2781                	sext.w	a5,a5
    80000840:	079e                	slli	a5,a5,0x7
    80000842:	00007717          	auipc	a4,0x7
    80000846:	9c670713          	addi	a4,a4,-1594 # 80007208 <cpus>
    8000084a:	97ba                	add	a5,a5,a4
}
    8000084c:	6388                	ld	a0,0(a5)
    8000084e:	6422                	ld	s0,8(sp)
    80000850:	0141                	addi	sp,sp,16
    80000852:	8082                	ret

0000000080000854 <before_sched>:
        spin_unlock(&p->proc_lock);
        spin_lock(lock);
    }
}

void before_sched() {
    80000854:	7179                	addi	sp,sp,-48
    80000856:	f406                	sd	ra,40(sp)
    80000858:	f022                	sd	s0,32(sp)
    8000085a:	ec26                	sd	s1,24(sp)
    8000085c:	e84a                	sd	s2,16(sp)
    8000085e:	e44e                	sd	s3,8(sp)
    80000860:	1800                	addi	s0,sp,48
    80000862:	8792                	mv	a5,tp
    return mycpu()->proc;
    80000864:	2781                	sext.w	a5,a5
    80000866:	079e                	slli	a5,a5,0x7
    80000868:	00007717          	auipc	a4,0x7
    8000086c:	9a070713          	addi	a4,a4,-1632 # 80007208 <cpus>
    80000870:	97ba                	add	a5,a5,a4
    80000872:	0007b903          	ld	s2,0(a5)
    int intr_enable;
    struct proc *p = myproc();

    if (!spin_holding(&p->proc_lock))
    80000876:	854a                	mv	a0,s2
    80000878:	00003097          	auipc	ra,0x3
    8000087c:	bd8080e7          	jalr	-1064(ra) # 80003450 <spin_holding>
    80000880:	c54d                	beqz	a0,8000092a <before_sched+0xd6>
    80000882:	8792                	mv	a5,tp
        panic("sched p->lock");
    if (mycpu()->noff != 1)
    80000884:	2781                	sext.w	a5,a5
    80000886:	079e                	slli	a5,a5,0x7
    80000888:	00007717          	auipc	a4,0x7
    8000088c:	98070713          	addi	a4,a4,-1664 # 80007208 <cpus>
    80000890:	97ba                	add	a5,a5,a4
    80000892:	5fb8                	lw	a4,120(a5)
    80000894:	4785                	li	a5,1
    80000896:	0af71363          	bne	a4,a5,8000093c <before_sched+0xe8>
        panic("sched locks");
    if (p->state == RUNNING)
    8000089a:	01892703          	lw	a4,24(s2)
    8000089e:	478d                	li	a5,3
    800008a0:	0af70763          	beq	a4,a5,8000094e <before_sched+0xfa>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800008a4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800008a8:	8b89                	andi	a5,a5,2
        panic("sched running");
    if (intr_get())
    800008aa:	ebdd                	bnez	a5,80000960 <before_sched+0x10c>
  asm volatile("mv %0, tp" : "=r" (x) );
    800008ac:	8792                	mv	a5,tp
        panic("sched interruptible");

    intr_enable = mycpu()->intr_enable;
    800008ae:	00007497          	auipc	s1,0x7
    800008b2:	95a48493          	addi	s1,s1,-1702 # 80007208 <cpus>
    800008b6:	2781                	sext.w	a5,a5
    800008b8:	079e                	slli	a5,a5,0x7
    800008ba:	97a6                	add	a5,a5,s1
    800008bc:	07c7a983          	lw	s3,124(a5)
    800008c0:	8592                	mv	a1,tp
    pswitch(&p->context, &mycpu()->context);
    800008c2:	2581                	sext.w	a1,a1
    800008c4:	059e                	slli	a1,a1,0x7
    800008c6:	05a1                	addi	a1,a1,8
    800008c8:	95a6                	add	a1,a1,s1
    800008ca:	06890513          	addi	a0,s2,104
    800008ce:	00000097          	auipc	ra,0x0
    800008d2:	73e080e7          	jalr	1854(ra) # 8000100c <pswitch>
    800008d6:	8792                	mv	a5,tp
    mycpu()->intr_enable = intr_enable;
    800008d8:	2781                	sext.w	a5,a5
    800008da:	079e                	slli	a5,a5,0x7
    800008dc:	97a6                	add	a5,a5,s1
    800008de:	0737ae23          	sw	s3,124(a5)
    800008e2:	8792                	mv	a5,tp
    return mycpu()->proc;
    800008e4:	2781                	sext.w	a5,a5
    800008e6:	079e                	slli	a5,a5,0x7
    800008e8:	97a6                	add	a5,a5,s1
    printf("sched now pid=%d\n", myproc()->pid);
    800008ea:	639c                	ld	a5,0(a5)
    800008ec:	5f8c                	lw	a1,56(a5)
    800008ee:	00004517          	auipc	a0,0x4
    800008f2:	7aa50513          	addi	a0,a0,1962 # 80005098 <etext+0x98>
    800008f6:	00001097          	auipc	ra,0x1
    800008fa:	a36080e7          	jalr	-1482(ra) # 8000132c <printf>
  asm volatile("mv %0, sp" : "=r" (x) );
    800008fe:	858a                	mv	a1,sp
  asm volatile("mv %0, tp" : "=r" (x) );
    80000900:	8792                	mv	a5,tp
    return mycpu()->proc;
    80000902:	2781                	sext.w	a5,a5
    80000904:	079e                	slli	a5,a5,0x7
    80000906:	94be                	add	s1,s1,a5
    printf("sp=%p stack bottom=%p \n", r_sp(), myproc()->kstack);
    80000908:	609c                	ld	a5,0(s1)
    8000090a:	73b0                	ld	a2,96(a5)
    8000090c:	00004517          	auipc	a0,0x4
    80000910:	7a450513          	addi	a0,a0,1956 # 800050b0 <etext+0xb0>
    80000914:	00001097          	auipc	ra,0x1
    80000918:	a18080e7          	jalr	-1512(ra) # 8000132c <printf>
}
    8000091c:	70a2                	ld	ra,40(sp)
    8000091e:	7402                	ld	s0,32(sp)
    80000920:	64e2                	ld	s1,24(sp)
    80000922:	6942                	ld	s2,16(sp)
    80000924:	69a2                	ld	s3,8(sp)
    80000926:	6145                	addi	sp,sp,48
    80000928:	8082                	ret
        panic("sched p->lock");
    8000092a:	00004517          	auipc	a0,0x4
    8000092e:	72650513          	addi	a0,a0,1830 # 80005050 <etext+0x50>
    80000932:	00001097          	auipc	ra,0x1
    80000936:	abe080e7          	jalr	-1346(ra) # 800013f0 <panic>
    8000093a:	b7a1                	j	80000882 <before_sched+0x2e>
        panic("sched locks");
    8000093c:	00004517          	auipc	a0,0x4
    80000940:	72450513          	addi	a0,a0,1828 # 80005060 <etext+0x60>
    80000944:	00001097          	auipc	ra,0x1
    80000948:	aac080e7          	jalr	-1364(ra) # 800013f0 <panic>
    8000094c:	b7b9                	j	8000089a <before_sched+0x46>
        panic("sched running");
    8000094e:	00004517          	auipc	a0,0x4
    80000952:	72250513          	addi	a0,a0,1826 # 80005070 <etext+0x70>
    80000956:	00001097          	auipc	ra,0x1
    8000095a:	a9a080e7          	jalr	-1382(ra) # 800013f0 <panic>
    8000095e:	b799                	j	800008a4 <before_sched+0x50>
        panic("sched interruptible");
    80000960:	00004517          	auipc	a0,0x4
    80000964:	72050513          	addi	a0,a0,1824 # 80005080 <etext+0x80>
    80000968:	00001097          	auipc	ra,0x1
    8000096c:	a88080e7          	jalr	-1400(ra) # 800013f0 <panic>
    80000970:	bf35                	j	800008ac <before_sched+0x58>

0000000080000972 <sleep>:
void sleep(void *chan, struct spinlock *lock) {
    80000972:	7179                	addi	sp,sp,-48
    80000974:	f406                	sd	ra,40(sp)
    80000976:	f022                	sd	s0,32(sp)
    80000978:	ec26                	sd	s1,24(sp)
    8000097a:	e84a                	sd	s2,16(sp)
    8000097c:	e44e                	sd	s3,8(sp)
    8000097e:	1800                	addi	s0,sp,48
    80000980:	89aa                	mv	s3,a0
    80000982:	8792                	mv	a5,tp
    return mycpu()->proc;
    80000984:	2781                	sext.w	a5,a5
    80000986:	079e                	slli	a5,a5,0x7
    80000988:	00007717          	auipc	a4,0x7
    8000098c:	88070713          	addi	a4,a4,-1920 # 80007208 <cpus>
    80000990:	97ba                	add	a5,a5,a4
    80000992:	6384                	ld	s1,0(a5)
    if (lock != &p->proc_lock) {  //DOC: sleeplock0
    80000994:	06b48063          	beq	s1,a1,800009f4 <sleep+0x82>
    80000998:	892e                	mv	s2,a1
        spin_lock(&p->proc_lock);  //DOC: sleeplock1
    8000099a:	8526                	mv	a0,s1
    8000099c:	00003097          	auipc	ra,0x3
    800009a0:	b2e080e7          	jalr	-1234(ra) # 800034ca <spin_lock>
        spin_unlock(lock);
    800009a4:	854a                	mv	a0,s2
    800009a6:	00003097          	auipc	ra,0x3
    800009aa:	bf8080e7          	jalr	-1032(ra) # 8000359e <spin_unlock>
    p->chan = chan;
    800009ae:	0334b423          	sd	s3,40(s1)
    p->state = SLEEPING;
    800009b2:	4785                	li	a5,1
    800009b4:	cc9c                	sw	a5,24(s1)
    before_sched();
    800009b6:	00000097          	auipc	ra,0x0
    800009ba:	e9e080e7          	jalr	-354(ra) # 80000854 <before_sched>
    printf("sleep over\n");
    800009be:	00004517          	auipc	a0,0x4
    800009c2:	70a50513          	addi	a0,a0,1802 # 800050c8 <etext+0xc8>
    800009c6:	00001097          	auipc	ra,0x1
    800009ca:	966080e7          	jalr	-1690(ra) # 8000132c <printf>
    p->chan = 0;
    800009ce:	0204b423          	sd	zero,40(s1)
        spin_unlock(&p->proc_lock);
    800009d2:	8526                	mv	a0,s1
    800009d4:	00003097          	auipc	ra,0x3
    800009d8:	bca080e7          	jalr	-1078(ra) # 8000359e <spin_unlock>
        spin_lock(lock);
    800009dc:	854a                	mv	a0,s2
    800009de:	00003097          	auipc	ra,0x3
    800009e2:	aec080e7          	jalr	-1300(ra) # 800034ca <spin_lock>
}
    800009e6:	70a2                	ld	ra,40(sp)
    800009e8:	7402                	ld	s0,32(sp)
    800009ea:	64e2                	ld	s1,24(sp)
    800009ec:	6942                	ld	s2,16(sp)
    800009ee:	69a2                	ld	s3,8(sp)
    800009f0:	6145                	addi	sp,sp,48
    800009f2:	8082                	ret
    p->chan = chan;
    800009f4:	f488                	sd	a0,40(s1)
    p->state = SLEEPING;
    800009f6:	4785                	li	a5,1
    800009f8:	cc9c                	sw	a5,24(s1)
    before_sched();
    800009fa:	00000097          	auipc	ra,0x0
    800009fe:	e5a080e7          	jalr	-422(ra) # 80000854 <before_sched>
    printf("sleep over\n");
    80000a02:	00004517          	auipc	a0,0x4
    80000a06:	6c650513          	addi	a0,a0,1734 # 800050c8 <etext+0xc8>
    80000a0a:	00001097          	auipc	ra,0x1
    80000a0e:	922080e7          	jalr	-1758(ra) # 8000132c <printf>
    p->chan = 0;
    80000a12:	0204b423          	sd	zero,40(s1)
    if (lock != &p->proc_lock) {
    80000a16:	bfc1                	j	800009e6 <sleep+0x74>

0000000080000a18 <sleep_time>:

// 睡眠一定时间
void sleep_time(uint64 sleep_ticks) {
    80000a18:	7179                	addi	sp,sp,-48
    80000a1a:	f406                	sd	ra,40(sp)
    80000a1c:	f022                	sd	s0,32(sp)
    80000a1e:	ec26                	sd	s1,24(sp)
    80000a20:	e84a                	sd	s2,16(sp)
    80000a22:	e44e                	sd	s3,8(sp)
    80000a24:	e052                	sd	s4,0(sp)
    80000a26:	1800                	addi	s0,sp,48
    80000a28:	892a                	mv	s2,a0
    uint64 now = ticks;
    80000a2a:	00005497          	auipc	s1,0x5
    80000a2e:	5e648493          	addi	s1,s1,1510 # 80006010 <ticks>
    80000a32:	0004b983          	ld	s3,0(s1)
    spin_lock(&ticks_lock);
    80000a36:	000ac517          	auipc	a0,0xac
    80000a3a:	fe250513          	addi	a0,a0,-30 # 800aca18 <ticks_lock>
    80000a3e:	00003097          	auipc	ra,0x3
    80000a42:	a8c080e7          	jalr	-1396(ra) # 800034ca <spin_lock>
    for (; ticks - now < sleep_ticks;) {
    80000a46:	609c                	ld	a5,0(s1)
    80000a48:	413787b3          	sub	a5,a5,s3
    80000a4c:	0327f163          	bgeu	a5,s2,80000a6e <sleep_time+0x56>
        sleep(&ticks, &ticks_lock);
    80000a50:	000aca17          	auipc	s4,0xac
    80000a54:	fc8a0a13          	addi	s4,s4,-56 # 800aca18 <ticks_lock>
    80000a58:	85d2                	mv	a1,s4
    80000a5a:	8526                	mv	a0,s1
    80000a5c:	00000097          	auipc	ra,0x0
    80000a60:	f16080e7          	jalr	-234(ra) # 80000972 <sleep>
    for (; ticks - now < sleep_ticks;) {
    80000a64:	609c                	ld	a5,0(s1)
    80000a66:	413787b3          	sub	a5,a5,s3
    80000a6a:	ff27e7e3          	bltu	a5,s2,80000a58 <sleep_time+0x40>
    }
    spin_unlock(&ticks_lock);
    80000a6e:	000ac517          	auipc	a0,0xac
    80000a72:	faa50513          	addi	a0,a0,-86 # 800aca18 <ticks_lock>
    80000a76:	00003097          	auipc	ra,0x3
    80000a7a:	b28080e7          	jalr	-1240(ra) # 8000359e <spin_unlock>
}
    80000a7e:	70a2                	ld	ra,40(sp)
    80000a80:	7402                	ld	s0,32(sp)
    80000a82:	64e2                	ld	s1,24(sp)
    80000a84:	6942                	ld	s2,16(sp)
    80000a86:	69a2                	ld	s3,8(sp)
    80000a88:	6a02                	ld	s4,0(sp)
    80000a8a:	6145                	addi	sp,sp,48
    80000a8c:	8082                	ret

0000000080000a8e <wakeup>:

// 唤醒指定chan上的进程
void wakeup(void *chan) {
    80000a8e:	1141                	addi	sp,sp,-16
    80000a90:	e422                	sd	s0,8(sp)
    80000a92:	0800                	addi	s0,sp,16
    struct proc *p;
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80000a94:	00088797          	auipc	a5,0x88
    80000a98:	7f478793          	addi	a5,a5,2036 # 80089288 <proc_table>
        if (p->state == SLEEPING && p->chan == chan) {
    80000a9c:	4605                	li	a2,1
            p->state = RUNNABLE;
    80000a9e:	4589                	li	a1,2
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80000aa0:	0008c697          	auipc	a3,0x8c
    80000aa4:	3e868693          	addi	a3,a3,1000 # 8008ce88 <kmem>
    80000aa8:	a031                	j	80000ab4 <wakeup+0x26>
            p->state = RUNNABLE;
    80000aaa:	cf8c                	sw	a1,24(a5)
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80000aac:	0f078793          	addi	a5,a5,240
    80000ab0:	00d78963          	beq	a5,a3,80000ac2 <wakeup+0x34>
        if (p->state == SLEEPING && p->chan == chan) {
    80000ab4:	4f98                	lw	a4,24(a5)
    80000ab6:	fec71be3          	bne	a4,a2,80000aac <wakeup+0x1e>
    80000aba:	7798                	ld	a4,40(a5)
    80000abc:	fea718e3          	bne	a4,a0,80000aac <wakeup+0x1e>
    80000ac0:	b7ed                	j	80000aaa <wakeup+0x1c>
        }
    }
}
    80000ac2:	6422                	ld	s0,8(sp)
    80000ac4:	0141                	addi	sp,sp,16
    80000ac6:	8082                	ret

0000000080000ac8 <scheduler>:
void scheduler() {
    80000ac8:	711d                	addi	sp,sp,-96
    80000aca:	ec86                	sd	ra,88(sp)
    80000acc:	e8a2                	sd	s0,80(sp)
    80000ace:	e4a6                	sd	s1,72(sp)
    80000ad0:	e0ca                	sd	s2,64(sp)
    80000ad2:	fc4e                	sd	s3,56(sp)
    80000ad4:	f852                	sd	s4,48(sp)
    80000ad6:	f456                	sd	s5,40(sp)
    80000ad8:	f05a                	sd	s6,32(sp)
    80000ada:	ec5e                	sd	s7,24(sp)
    80000adc:	e862                	sd	s8,16(sp)
    80000ade:	e466                	sd	s9,8(sp)
    80000ae0:	e06a                	sd	s10,0(sp)
    80000ae2:	1080                	addi	s0,sp,96
    80000ae4:	8792                	mv	a5,tp
    int id = r_tp();
    80000ae6:	2781                	sext.w	a5,a5
                pswitch(&c->context, &p->context);
    80000ae8:	00779c93          	slli	s9,a5,0x7
    80000aec:	00006717          	auipc	a4,0x6
    80000af0:	72470713          	addi	a4,a4,1828 # 80007210 <cpus+0x8>
    80000af4:	9cba                	add	s9,s9,a4
                wakeup(initproc);
    80000af6:	00005d17          	auipc	s10,0x5
    80000afa:	50ad0d13          	addi	s10,s10,1290 # 80006000 <initproc>
            if (p->state == RUNNABLE) {
    80000afe:	4a89                	li	s5,2
                c->proc = p;
    80000b00:	079e                	slli	a5,a5,0x7
    80000b02:	00006b97          	auipc	s7,0x6
    80000b06:	706b8b93          	addi	s7,s7,1798 # 80007208 <cpus>
    80000b0a:	9bbe                	add	s7,s7,a5
    80000b0c:	a08d                	j	80000b6e <scheduler+0xa6>
            spin_unlock(&p->proc_lock);
    80000b0e:	854a                	mv	a0,s2
    80000b10:	00003097          	auipc	ra,0x3
    80000b14:	a8e080e7          	jalr	-1394(ra) # 8000359e <spin_unlock>
        for (int i = 0; i < NPROC; i++) {
    80000b18:	0f048493          	addi	s1,s1,240
    80000b1c:	03348f63          	beq	s1,s3,80000b5a <scheduler+0x92>
            p = &proc_table[i];
    80000b20:	8926                	mv	s2,s1
            spin_lock(&p->proc_lock);
    80000b22:	8526                	mv	a0,s1
    80000b24:	00003097          	auipc	ra,0x3
    80000b28:	9a6080e7          	jalr	-1626(ra) # 800034ca <spin_lock>
            if (p->state != UNUSED && p->state != ZOMBIE) {
    80000b2c:	4c9c                	lw	a5,24(s1)
    80000b2e:	d3e5                	beqz	a5,80000b0e <scheduler+0x46>
    80000b30:	07678163          	beq	a5,s6,80000b92 <scheduler+0xca>
                alive_p++;
    80000b34:	2a05                	addiw	s4,s4,1
            if (p->state == RUNNABLE) {
    80000b36:	01892783          	lw	a5,24(s2)
    80000b3a:	fd579ae3          	bne	a5,s5,80000b0e <scheduler+0x46>
                p->state = RUNNING;
    80000b3e:	01892c23          	sw	s8,24(s2)
                c->proc = p;
    80000b42:	012bb023          	sd	s2,0(s7)
                pswitch(&c->context, &p->context);
    80000b46:	06848593          	addi	a1,s1,104
    80000b4a:	8566                	mv	a0,s9
    80000b4c:	00000097          	auipc	ra,0x0
    80000b50:	4c0080e7          	jalr	1216(ra) # 8000100c <pswitch>
                c->proc = 0;
    80000b54:	000bb023          	sd	zero,0(s7)
    80000b58:	bf5d                	j	80000b0e <scheduler+0x46>
        if (alive_p <= 2) {
    80000b5a:	014aca63          	blt	s5,s4,80000b6e <scheduler+0xa6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b5e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000b62:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b66:	10079073          	csrw	sstatus,a5
            asm volatile("wfi");
    80000b6a:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b6e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000b72:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b76:	10079073          	csrw	sstatus,a5
        for (int i = 0; i < NPROC; i++) {
    80000b7a:	00088497          	auipc	s1,0x88
    80000b7e:	70e48493          	addi	s1,s1,1806 # 80089288 <proc_table>
    80000b82:	0008c997          	auipc	s3,0x8c
    80000b86:	30698993          	addi	s3,s3,774 # 8008ce88 <kmem>
        alive_p = 0;
    80000b8a:	4a01                	li	s4,0
            if (p->state != UNUSED && p->state != ZOMBIE) {
    80000b8c:	4b11                	li	s6,4
                p->state = RUNNING;
    80000b8e:	4c0d                	li	s8,3
    80000b90:	bf41                	j	80000b20 <scheduler+0x58>
                wakeup(initproc);
    80000b92:	000d3503          	ld	a0,0(s10)
    80000b96:	00000097          	auipc	ra,0x0
    80000b9a:	ef8080e7          	jalr	-264(ra) # 80000a8e <wakeup>
    80000b9e:	bf61                	j	80000b36 <scheduler+0x6e>

0000000080000ba0 <fork>:

int fork() {
    80000ba0:	1101                	addi	sp,sp,-32
    80000ba2:	ec06                	sd	ra,24(sp)
    80000ba4:	e822                	sd	s0,16(sp)
    80000ba6:	e426                	sd	s1,8(sp)
    80000ba8:	e04a                	sd	s2,0(sp)
    80000baa:	1000                	addi	s0,sp,32
  asm volatile("mv %0, tp" : "=r" (x) );
    80000bac:	8792                	mv	a5,tp
    return mycpu()->proc;
    80000bae:	2781                	sext.w	a5,a5
    80000bb0:	079e                	slli	a5,a5,0x7
    80000bb2:	00006717          	auipc	a4,0x6
    80000bb6:	65670713          	addi	a4,a4,1622 # 80007208 <cpus>
    80000bba:	97ba                	add	a5,a5,a4
    80000bbc:	0007b903          	ld	s2,0(a5)
    struct proc *child;
    struct proc *p = myproc();

    // 分配一个新的进程
    if ((child = alloc_proc()) == 0) {
    80000bc0:	00000097          	auipc	ra,0x0
    80000bc4:	b0c080e7          	jalr	-1268(ra) # 800006cc <alloc_proc>
    80000bc8:	c941                	beqz	a0,80000c58 <fork+0xb8>
    80000bca:	84aa                	mv	s1,a0
        return -1;
    }

    // 将父进程的内存复制到子进程中
    if (user_vm_copy(p->pagetable, child->pagetable, p->sz) < 0) {
    80000bcc:	0e892603          	lw	a2,232(s2)
    80000bd0:	652c                	ld	a1,72(a0)
    80000bd2:	04893503          	ld	a0,72(s2)
    80000bd6:	00001097          	auipc	ra,0x1
    80000bda:	f4e080e7          	jalr	-178(ra) # 80001b24 <user_vm_copy>
    80000bde:	06054f63          	bltz	a0,80000c5c <fork+0xbc>
        return -1;
    }
    printf("p.sz=%d\n", p->sz);
    80000be2:	0e892583          	lw	a1,232(s2)
    80000be6:	00004517          	auipc	a0,0x4
    80000bea:	4f250513          	addi	a0,a0,1266 # 800050d8 <etext+0xd8>
    80000bee:	00000097          	auipc	ra,0x0
    80000bf2:	73e080e7          	jalr	1854(ra) # 8000132c <printf>
    child->sz = p->sz;
    80000bf6:	0e892783          	lw	a5,232(s2)
    80000bfa:	0ef4a423          	sw	a5,232(s1)
    child->parent = p;
    80000bfe:	0324b023          	sd	s2,32(s1)

    // 复制父进程的用户空间的寄存器
    *(child->trapframe) = *(p->trapframe);
    80000c02:	04093683          	ld	a3,64(s2)
    80000c06:	87b6                	mv	a5,a3
    80000c08:	60b8                	ld	a4,64(s1)
    80000c0a:	12068693          	addi	a3,a3,288
    80000c0e:	0007b803          	ld	a6,0(a5)
    80000c12:	6788                	ld	a0,8(a5)
    80000c14:	6b8c                	ld	a1,16(a5)
    80000c16:	6f90                	ld	a2,24(a5)
    80000c18:	01073023          	sd	a6,0(a4)
    80000c1c:	e708                	sd	a0,8(a4)
    80000c1e:	eb0c                	sd	a1,16(a4)
    80000c20:	ef10                	sd	a2,24(a4)
    80000c22:	02078793          	addi	a5,a5,32
    80000c26:	02070713          	addi	a4,a4,32
    80000c2a:	fed792e3          	bne	a5,a3,80000c0e <fork+0x6e>

    // 设置子进程fork的返回值为0
    child->trapframe->a0 = 0;
    80000c2e:	60bc                	ld	a5,64(s1)
    80000c30:	0607b823          	sd	zero,112(a5)

    safestrcpy(child->name, p->name, sizeof(p->name));
    80000c34:	4641                	li	a2,16
    80000c36:	0d890593          	addi	a1,s2,216
    80000c3a:	0d848513          	addi	a0,s1,216
    80000c3e:	00000097          	auipc	ra,0x0
    80000c42:	2f6080e7          	jalr	758(ra) # 80000f34 <safestrcpy>

    child->state = RUNNABLE;
    80000c46:	4789                	li	a5,2
    80000c48:	cc9c                	sw	a5,24(s1)

    return child->pid;
    80000c4a:	5c88                	lw	a0,56(s1)
}
    80000c4c:	60e2                	ld	ra,24(sp)
    80000c4e:	6442                	ld	s0,16(sp)
    80000c50:	64a2                	ld	s1,8(sp)
    80000c52:	6902                	ld	s2,0(sp)
    80000c54:	6105                	addi	sp,sp,32
    80000c56:	8082                	ret
        return -1;
    80000c58:	557d                	li	a0,-1
    80000c5a:	bfcd                	j	80000c4c <fork+0xac>
        return -1;
    80000c5c:	557d                	li	a0,-1
    80000c5e:	b7fd                	j	80000c4c <fork+0xac>

0000000080000c60 <wait>:
//
// 等待子进程退出, 返回其子进程id
// 没有子进程返回-1， 将退出状态复
// 制到status中。
//
int wait(int *status) {
    80000c60:	715d                	addi	sp,sp,-80
    80000c62:	e486                	sd	ra,72(sp)
    80000c64:	e0a2                	sd	s0,64(sp)
    80000c66:	fc26                	sd	s1,56(sp)
    80000c68:	f84a                	sd	s2,48(sp)
    80000c6a:	f44e                	sd	s3,40(sp)
    80000c6c:	f052                	sd	s4,32(sp)
    80000c6e:	ec56                	sd	s5,24(sp)
    80000c70:	e85a                	sd	s6,16(sp)
    80000c72:	e45e                	sd	s7,8(sp)
    80000c74:	e062                	sd	s8,0(sp)
    80000c76:	0880                	addi	s0,sp,80
    80000c78:	8b2a                	mv	s6,a0
    80000c7a:	8792                	mv	a5,tp
    return mycpu()->proc;
    80000c7c:	2781                	sext.w	a5,a5
    80000c7e:	079e                	slli	a5,a5,0x7
    80000c80:	00006717          	auipc	a4,0x6
    80000c84:	58870713          	addi	a4,a4,1416 # 80007208 <cpus>
    80000c88:	97ba                	add	a5,a5,a4
    80000c8a:	0007b903          	ld	s2,0(a5)
    struct proc *cp; // 子进程
    struct proc *p;
    int havechild, pid;
    p = myproc();
    spin_lock(&p->proc_lock);
    80000c8e:	854a                	mv	a0,s2
    80000c90:	00003097          	auipc	ra,0x3
    80000c94:	83a080e7          	jalr	-1990(ra) # 800034ca <spin_lock>
    for (;;) {
        havechild = 0;
    80000c98:	4b81                	li	s7,0
        for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
            if (cp->parent == p) {
                spin_lock(&cp->proc_lock);
                havechild = 1;
                if (cp->state == ZOMBIE) {
    80000c9a:	4a11                	li	s4,4
        for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    80000c9c:	0008c997          	auipc	s3,0x8c
    80000ca0:	1ec98993          	addi	s3,s3,492 # 8008ce88 <kmem>
                havechild = 1;
    80000ca4:	4a85                	li	s5,1
    return mycpu()->proc;
    80000ca6:	00006c17          	auipc	s8,0x6
    80000caa:	562c0c13          	addi	s8,s8,1378 # 80007208 <cpus>
        havechild = 0;
    80000cae:	875e                	mv	a4,s7
        for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    80000cb0:	00088497          	auipc	s1,0x88
    80000cb4:	5d848493          	addi	s1,s1,1496 # 80089288 <proc_table>
    80000cb8:	a80d                	j	80000cea <wait+0x8a>
                    pid = cp->pid;
    80000cba:	0384a983          	lw	s3,56(s1)
                    if (status) {
    80000cbe:	000b0563          	beqz	s6,80000cc8 <wait+0x68>
                        *status = cp->xstate;
    80000cc2:	58dc                	lw	a5,52(s1)
    80000cc4:	00fb2023          	sw	a5,0(s6)
                    }
                    cp->state = UNUSED;
    80000cc8:	0004ac23          	sw	zero,24(s1)
                    spin_unlock(&cp->proc_lock);
    80000ccc:	8526                	mv	a0,s1
    80000cce:	00003097          	auipc	ra,0x3
    80000cd2:	8d0080e7          	jalr	-1840(ra) # 8000359e <spin_unlock>
                    spin_unlock(&p->proc_lock);
    80000cd6:	854a                	mv	a0,s2
    80000cd8:	00003097          	auipc	ra,0x3
    80000cdc:	8c6080e7          	jalr	-1850(ra) # 8000359e <spin_unlock>
                    return pid;
    80000ce0:	a80d                	j	80000d12 <wait+0xb2>
        for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    80000ce2:	0f048493          	addi	s1,s1,240
    80000ce6:	03348463          	beq	s1,s3,80000d0e <wait+0xae>
            if (cp->parent == p) {
    80000cea:	709c                	ld	a5,32(s1)
    80000cec:	ff279be3          	bne	a5,s2,80000ce2 <wait+0x82>
                spin_lock(&cp->proc_lock);
    80000cf0:	8526                	mv	a0,s1
    80000cf2:	00002097          	auipc	ra,0x2
    80000cf6:	7d8080e7          	jalr	2008(ra) # 800034ca <spin_lock>
                if (cp->state == ZOMBIE) {
    80000cfa:	4c9c                	lw	a5,24(s1)
    80000cfc:	fb478fe3          	beq	a5,s4,80000cba <wait+0x5a>
                }
                spin_unlock(&cp->proc_lock);
    80000d00:	8526                	mv	a0,s1
    80000d02:	00003097          	auipc	ra,0x3
    80000d06:	89c080e7          	jalr	-1892(ra) # 8000359e <spin_unlock>
                havechild = 1;
    80000d0a:	8756                	mv	a4,s5
    80000d0c:	bfd9                	j	80000ce2 <wait+0x82>
            }
        }
        if (!havechild) {
    80000d0e:	ef19                	bnez	a4,80000d2c <wait+0xcc>
            return -1;
    80000d10:	59fd                	li	s3,-1
        }
        sleep(p, &myproc()->proc_lock); // 等待子进程唤醒
    }
}
    80000d12:	854e                	mv	a0,s3
    80000d14:	60a6                	ld	ra,72(sp)
    80000d16:	6406                	ld	s0,64(sp)
    80000d18:	74e2                	ld	s1,56(sp)
    80000d1a:	7942                	ld	s2,48(sp)
    80000d1c:	79a2                	ld	s3,40(sp)
    80000d1e:	7a02                	ld	s4,32(sp)
    80000d20:	6ae2                	ld	s5,24(sp)
    80000d22:	6b42                	ld	s6,16(sp)
    80000d24:	6ba2                	ld	s7,8(sp)
    80000d26:	6c02                	ld	s8,0(sp)
    80000d28:	6161                	addi	sp,sp,80
    80000d2a:	8082                	ret
    80000d2c:	8792                	mv	a5,tp
    return mycpu()->proc;
    80000d2e:	2781                	sext.w	a5,a5
    80000d30:	079e                	slli	a5,a5,0x7
    80000d32:	97e2                	add	a5,a5,s8
        sleep(p, &myproc()->proc_lock); // 等待子进程唤醒
    80000d34:	638c                	ld	a1,0(a5)
    80000d36:	854a                	mv	a0,s2
    80000d38:	00000097          	auipc	ra,0x0
    80000d3c:	c3a080e7          	jalr	-966(ra) # 80000972 <sleep>
        havechild = 0;
    80000d40:	b7bd                	j	80000cae <wait+0x4e>

0000000080000d42 <exit>:
// 让父进程来设置其state为UNUSED
// 若父进程已经exit, 则会由init进
// 程来完成父进程在exit时，会将其
// 子进程的parent设置为init进程
//
void exit(int status) {
    80000d42:	1101                	addi	sp,sp,-32
    80000d44:	ec06                	sd	ra,24(sp)
    80000d46:	e822                	sd	s0,16(sp)
    80000d48:	e426                	sd	s1,8(sp)
    80000d4a:	1000                	addi	s0,sp,32
    80000d4c:	8792                	mv	a5,tp
    return mycpu()->proc;
    80000d4e:	2781                	sext.w	a5,a5
    80000d50:	079e                	slli	a5,a5,0x7
    80000d52:	00006717          	auipc	a4,0x6
    80000d56:	4b670713          	addi	a4,a4,1206 # 80007208 <cpus>
    80000d5a:	97ba                	add	a5,a5,a4
    80000d5c:	6384                	ld	s1,0(a5)
    struct proc *p, *cp;
    p = myproc();
    p->state = ZOMBIE;
    80000d5e:	4791                	li	a5,4
    80000d60:	cc9c                	sw	a5,24(s1)
    p->xstate = status;
    80000d62:	d8c8                	sw	a0,52(s1)
    for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
        if (cp->parent == p) {
            cp->parent = initproc;
    80000d64:	00005617          	auipc	a2,0x5
    80000d68:	29c63603          	ld	a2,668(a2) # 80006000 <initproc>
    for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    80000d6c:	00088797          	auipc	a5,0x88
    80000d70:	51c78793          	addi	a5,a5,1308 # 80089288 <proc_table>
    80000d74:	0008c697          	auipc	a3,0x8c
    80000d78:	11468693          	addi	a3,a3,276 # 8008ce88 <kmem>
    80000d7c:	a031                	j	80000d88 <exit+0x46>
            cp->parent = initproc;
    80000d7e:	f390                	sd	a2,32(a5)
    for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    80000d80:	0f078793          	addi	a5,a5,240
    80000d84:	00d78663          	beq	a5,a3,80000d90 <exit+0x4e>
        if (cp->parent == p) {
    80000d88:	7398                	ld	a4,32(a5)
    80000d8a:	fe971be3          	bne	a4,s1,80000d80 <exit+0x3e>
    80000d8e:	bfc5                	j	80000d7e <exit+0x3c>
        }
    }
    wakeup(p->parent);
    80000d90:	7088                	ld	a0,32(s1)
    80000d92:	00000097          	auipc	ra,0x0
    80000d96:	cfc080e7          	jalr	-772(ra) # 80000a8e <wakeup>
    spin_lock(&p->proc_lock);
    80000d9a:	8526                	mv	a0,s1
    80000d9c:	00002097          	auipc	ra,0x2
    80000da0:	72e080e7          	jalr	1838(ra) # 800034ca <spin_lock>
    before_sched();
    80000da4:	00000097          	auipc	ra,0x0
    80000da8:	ab0080e7          	jalr	-1360(ra) # 80000854 <before_sched>
    panic("exit");
    80000dac:	00004517          	auipc	a0,0x4
    80000db0:	33c50513          	addi	a0,a0,828 # 800050e8 <etext+0xe8>
    80000db4:	00000097          	auipc	ra,0x0
    80000db8:	63c080e7          	jalr	1596(ra) # 800013f0 <panic>
}
    80000dbc:	60e2                	ld	ra,24(sp)
    80000dbe:	6442                	ld	s0,16(sp)
    80000dc0:	64a2                	ld	s1,8(sp)
    80000dc2:	6105                	addi	sp,sp,32
    80000dc4:	8082                	ret

0000000080000dc6 <print_proc>:

void print_proc() {
    80000dc6:	7179                	addi	sp,sp,-48
    80000dc8:	f406                	sd	ra,40(sp)
    80000dca:	f022                	sd	s0,32(sp)
    80000dcc:	ec26                	sd	s1,24(sp)
    80000dce:	e84a                	sd	s2,16(sp)
    80000dd0:	e44e                	sd	s3,8(sp)
    80000dd2:	1800                	addi	s0,sp,48
    struct proc *p;
    printf(" \npid\tstate\n");
    80000dd4:	00004517          	auipc	a0,0x4
    80000dd8:	31c50513          	addi	a0,a0,796 # 800050f0 <etext+0xf0>
    80000ddc:	00000097          	auipc	ra,0x0
    80000de0:	550080e7          	jalr	1360(ra) # 8000132c <printf>
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80000de4:	00088497          	auipc	s1,0x88
    80000de8:	4a448493          	addi	s1,s1,1188 # 80089288 <proc_table>
        if (p->state == UNUSED)
            continue;
        printf(" %d\t  %d\n", p->pid, p->state);
    80000dec:	00004997          	auipc	s3,0x4
    80000df0:	31498993          	addi	s3,s3,788 # 80005100 <etext+0x100>
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80000df4:	0008c917          	auipc	s2,0x8c
    80000df8:	09490913          	addi	s2,s2,148 # 8008ce88 <kmem>
    80000dfc:	a029                	j	80000e06 <print_proc+0x40>
    80000dfe:	0f048493          	addi	s1,s1,240
    80000e02:	01248b63          	beq	s1,s2,80000e18 <print_proc+0x52>
        if (p->state == UNUSED)
    80000e06:	4c90                	lw	a2,24(s1)
    80000e08:	da7d                	beqz	a2,80000dfe <print_proc+0x38>
        printf(" %d\t  %d\n", p->pid, p->state);
    80000e0a:	5c8c                	lw	a1,56(s1)
    80000e0c:	854e                	mv	a0,s3
    80000e0e:	00000097          	auipc	ra,0x0
    80000e12:	51e080e7          	jalr	1310(ra) # 8000132c <printf>
    80000e16:	b7e5                	j	80000dfe <print_proc+0x38>
    }
}
    80000e18:	70a2                	ld	ra,40(sp)
    80000e1a:	7402                	ld	s0,32(sp)
    80000e1c:	64e2                	ld	s1,24(sp)
    80000e1e:	6942                	ld	s2,16(sp)
    80000e20:	69a2                	ld	s3,8(sp)
    80000e22:	6145                	addi	sp,sp,48
    80000e24:	8082                	ret

0000000080000e26 <yield>:

//
// 让出cpu
//
void yield() {
    80000e26:	1101                	addi	sp,sp,-32
    80000e28:	ec06                	sd	ra,24(sp)
    80000e2a:	e822                	sd	s0,16(sp)
    80000e2c:	e426                	sd	s1,8(sp)
    80000e2e:	1000                	addi	s0,sp,32
    80000e30:	8792                	mv	a5,tp
    return mycpu()->proc;
    80000e32:	2781                	sext.w	a5,a5
    80000e34:	079e                	slli	a5,a5,0x7
    80000e36:	00006717          	auipc	a4,0x6
    80000e3a:	3d270713          	addi	a4,a4,978 # 80007208 <cpus>
    80000e3e:	97ba                	add	a5,a5,a4
    80000e40:	6384                	ld	s1,0(a5)
    struct proc *p = myproc();
    spin_lock(&p->proc_lock);
    80000e42:	8526                	mv	a0,s1
    80000e44:	00002097          	auipc	ra,0x2
    80000e48:	686080e7          	jalr	1670(ra) # 800034ca <spin_lock>
    p->state = RUNNABLE;
    80000e4c:	4789                	li	a5,2
    80000e4e:	cc9c                	sw	a5,24(s1)
    before_sched();
    80000e50:	00000097          	auipc	ra,0x0
    80000e54:	a04080e7          	jalr	-1532(ra) # 80000854 <before_sched>
    spin_unlock(&p->proc_lock);
    80000e58:	8526                	mv	a0,s1
    80000e5a:	00002097          	auipc	ra,0x2
    80000e5e:	744080e7          	jalr	1860(ra) # 8000359e <spin_unlock>
}
    80000e62:	60e2                	ld	ra,24(sp)
    80000e64:	6442                	ld	s0,16(sp)
    80000e66:	64a2                	ld	s1,8(sp)
    80000e68:	6105                	addi	sp,sp,32
    80000e6a:	8082                	ret

0000000080000e6c <memset>:
#include "types.h"

void *memset(void *dst, int c, uint n) {
    80000e6c:	1141                	addi	sp,sp,-16
    80000e6e:	e422                	sd	s0,8(sp)
    80000e70:	0800                	addi	s0,sp,16
    char *cdst = (char *) dst;
    int i;
    for (i = 0; i < n; i++) {
    80000e72:	ce09                	beqz	a2,80000e8c <memset+0x20>
    80000e74:	87aa                	mv	a5,a0
    80000e76:	fff6071b          	addiw	a4,a2,-1
    80000e7a:	1702                	slli	a4,a4,0x20
    80000e7c:	9301                	srli	a4,a4,0x20
    80000e7e:	0705                	addi	a4,a4,1
    80000e80:	972a                	add	a4,a4,a0
        cdst[i] = c;
    80000e82:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++) {
    80000e86:	0785                	addi	a5,a5,1
    80000e88:	fee79de3          	bne	a5,a4,80000e82 <memset+0x16>
    }
    return dst;
}
    80000e8c:	6422                	ld	s0,8(sp)
    80000e8e:	0141                	addi	sp,sp,16
    80000e90:	8082                	ret

0000000080000e92 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
    80000e92:	1141                	addi	sp,sp,-16
    80000e94:	e422                	sd	s0,8(sp)
    80000e96:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst) {
    80000e98:	02b57663          	bgeu	a0,a1,80000ec4 <memmove+0x32>
        while (n-- > 0)
    80000e9c:	02c05163          	blez	a2,80000ebe <memmove+0x2c>
    80000ea0:	fff6079b          	addiw	a5,a2,-1
    80000ea4:	1782                	slli	a5,a5,0x20
    80000ea6:	9381                	srli	a5,a5,0x20
    80000ea8:	0785                	addi	a5,a5,1
    80000eaa:	97aa                	add	a5,a5,a0
    dst = vdst;
    80000eac:	872a                	mv	a4,a0
            *dst++ = *src++;
    80000eae:	0585                	addi	a1,a1,1
    80000eb0:	0705                	addi	a4,a4,1
    80000eb2:	fff5c683          	lbu	a3,-1(a1)
    80000eb6:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
    80000eba:	fee79ae3          	bne	a5,a4,80000eae <memmove+0x1c>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
    80000ebe:	6422                	ld	s0,8(sp)
    80000ec0:	0141                	addi	sp,sp,16
    80000ec2:	8082                	ret
        dst += n;
    80000ec4:	00c50733          	add	a4,a0,a2
        src += n;
    80000ec8:	95b2                	add	a1,a1,a2
        while (n-- > 0)
    80000eca:	fec05ae3          	blez	a2,80000ebe <memmove+0x2c>
    80000ece:	fff6079b          	addiw	a5,a2,-1
    80000ed2:	1782                	slli	a5,a5,0x20
    80000ed4:	9381                	srli	a5,a5,0x20
    80000ed6:	fff7c793          	not	a5,a5
    80000eda:	97ba                	add	a5,a5,a4
            *--dst = *--src;
    80000edc:	15fd                	addi	a1,a1,-1
    80000ede:	177d                	addi	a4,a4,-1
    80000ee0:	0005c683          	lbu	a3,0(a1)
    80000ee4:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
    80000ee8:	fee79ae3          	bne	a5,a4,80000edc <memmove+0x4a>
    80000eec:	bfc9                	j	80000ebe <memmove+0x2c>

0000000080000eee <strlen>:

uint strlen(const char *s) {
    80000eee:	1141                	addi	sp,sp,-16
    80000ef0:	e422                	sd	s0,8(sp)
    80000ef2:	0800                	addi	s0,sp,16
    int n;
    for (n = 0; s[n]; n++);
    80000ef4:	00054783          	lbu	a5,0(a0)
    80000ef8:	cf91                	beqz	a5,80000f14 <strlen+0x26>
    80000efa:	0505                	addi	a0,a0,1
    80000efc:	87aa                	mv	a5,a0
    80000efe:	4685                	li	a3,1
    80000f00:	9e89                	subw	a3,a3,a0
    80000f02:	00f6853b          	addw	a0,a3,a5
    80000f06:	0785                	addi	a5,a5,1
    80000f08:	fff7c703          	lbu	a4,-1(a5)
    80000f0c:	fb7d                	bnez	a4,80000f02 <strlen+0x14>
    return n;
}
    80000f0e:	6422                	ld	s0,8(sp)
    80000f10:	0141                	addi	sp,sp,16
    80000f12:	8082                	ret
    for (n = 0; s[n]; n++);
    80000f14:	4501                	li	a0,0
    80000f16:	bfe5                	j	80000f0e <strlen+0x20>

0000000080000f18 <strcpy>:

char* strcpy(char* s, const char* t)
{
    80000f18:	1141                	addi	sp,sp,-16
    80000f1a:	e422                	sd	s0,8(sp)
    80000f1c:	0800                	addi	s0,sp,16
    char* os;
    os = s;
    while ((*s++ = *t++) != 0)
    80000f1e:	87aa                	mv	a5,a0
    80000f20:	0585                	addi	a1,a1,1
    80000f22:	0785                	addi	a5,a5,1
    80000f24:	fff5c703          	lbu	a4,-1(a1)
    80000f28:	fee78fa3          	sb	a4,-1(a5)
    80000f2c:	fb75                	bnez	a4,80000f20 <strcpy+0x8>
        ;
    return os;
}
    80000f2e:	6422                	ld	s0,8(sp)
    80000f30:	0141                	addi	sp,sp,16
    80000f32:	8082                	ret

0000000080000f34 <safestrcpy>:
// 和strncpy类似, 该函数会保证字符串以0结束。
char* safestrcpy(char *s, const char *t, int n)
{
    80000f34:	1141                	addi	sp,sp,-16
    80000f36:	e422                	sd	s0,8(sp)
    80000f38:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    if(n <= 0)
    80000f3a:	02c05363          	blez	a2,80000f60 <safestrcpy+0x2c>
    80000f3e:	fff6069b          	addiw	a3,a2,-1
    80000f42:	1682                	slli	a3,a3,0x20
    80000f44:	9281                	srli	a3,a3,0x20
    80000f46:	96ae                	add	a3,a3,a1
    80000f48:	87aa                	mv	a5,a0
        return os;
    while(--n > 0 && (*s++ = *t++) != 0)
    80000f4a:	00d58963          	beq	a1,a3,80000f5c <safestrcpy+0x28>
    80000f4e:	0585                	addi	a1,a1,1
    80000f50:	0785                	addi	a5,a5,1
    80000f52:	fff5c703          	lbu	a4,-1(a1)
    80000f56:	fee78fa3          	sb	a4,-1(a5)
    80000f5a:	fb65                	bnez	a4,80000f4a <safestrcpy+0x16>
        ;
    *s = 0;
    80000f5c:	00078023          	sb	zero,0(a5)
    return os;
}
    80000f60:	6422                	ld	s0,8(sp)
    80000f62:	0141                	addi	sp,sp,16
    80000f64:	8082                	ret

0000000080000f66 <strncpy>:
char * strncpy(char *s, const char *t, int n) {
    80000f66:	1141                	addi	sp,sp,-16
    80000f68:	e422                	sd	s0,8(sp)
    80000f6a:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while (n-- > 0 && (*s++ = *t++) != 0);
    80000f6c:	872a                	mv	a4,a0
    80000f6e:	8832                	mv	a6,a2
    80000f70:	367d                	addiw	a2,a2,-1
    80000f72:	01005963          	blez	a6,80000f84 <strncpy+0x1e>
    80000f76:	0705                	addi	a4,a4,1
    80000f78:	0005c783          	lbu	a5,0(a1)
    80000f7c:	fef70fa3          	sb	a5,-1(a4)
    80000f80:	0585                	addi	a1,a1,1
    80000f82:	f7f5                	bnez	a5,80000f6e <strncpy+0x8>
    while (n-- > 0)
    80000f84:	00c05d63          	blez	a2,80000f9e <strncpy+0x38>
    80000f88:	86ba                	mv	a3,a4
        *s++ = 0;
    80000f8a:	0685                	addi	a3,a3,1
    80000f8c:	fe068fa3          	sb	zero,-1(a3)
    while (n-- > 0)
    80000f90:	fff6c793          	not	a5,a3
    80000f94:	9fb9                	addw	a5,a5,a4
    80000f96:	010787bb          	addw	a5,a5,a6
    80000f9a:	fef048e3          	bgtz	a5,80000f8a <strncpy+0x24>
    return os;
}
    80000f9e:	6422                	ld	s0,8(sp)
    80000fa0:	0141                	addi	sp,sp,16
    80000fa2:	8082                	ret

0000000080000fa4 <strcmp>:

int strcmp(const char* p, const char* q)
{
    80000fa4:	1141                	addi	sp,sp,-16
    80000fa6:	e422                	sd	s0,8(sp)
    80000fa8:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
    80000faa:	00054783          	lbu	a5,0(a0)
    80000fae:	cb91                	beqz	a5,80000fc2 <strcmp+0x1e>
    80000fb0:	0005c703          	lbu	a4,0(a1)
    80000fb4:	00f71763          	bne	a4,a5,80000fc2 <strcmp+0x1e>
        p++, q++;
    80000fb8:	0505                	addi	a0,a0,1
    80000fba:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
    80000fbc:	00054783          	lbu	a5,0(a0)
    80000fc0:	fbe5                	bnez	a5,80000fb0 <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
    80000fc2:	0005c503          	lbu	a0,0(a1)
}
    80000fc6:	40a7853b          	subw	a0,a5,a0
    80000fca:	6422                	ld	s0,8(sp)
    80000fcc:	0141                	addi	sp,sp,16
    80000fce:	8082                	ret

0000000080000fd0 <strncmp>:

int strncmp(const char *p, const char *q, uint n)
{
    80000fd0:	1141                	addi	sp,sp,-16
    80000fd2:	e422                	sd	s0,8(sp)
    80000fd4:	0800                	addi	s0,sp,16
    while(n > 0 && *p && *p == *q)
    80000fd6:	ce11                	beqz	a2,80000ff2 <strncmp+0x22>
    80000fd8:	00054783          	lbu	a5,0(a0)
    80000fdc:	cf89                	beqz	a5,80000ff6 <strncmp+0x26>
    80000fde:	0005c703          	lbu	a4,0(a1)
    80000fe2:	00f71a63          	bne	a4,a5,80000ff6 <strncmp+0x26>
        n--, p++, q++;
    80000fe6:	367d                	addiw	a2,a2,-1
    80000fe8:	0505                	addi	a0,a0,1
    80000fea:	0585                	addi	a1,a1,1
    while(n > 0 && *p && *p == *q)
    80000fec:	f675                	bnez	a2,80000fd8 <strncmp+0x8>
    if(n == 0)
        return 0;
    80000fee:	4501                	li	a0,0
    80000ff0:	a809                	j	80001002 <strncmp+0x32>
    80000ff2:	4501                	li	a0,0
    80000ff4:	a039                	j	80001002 <strncmp+0x32>
    if(n == 0)
    80000ff6:	ca09                	beqz	a2,80001008 <strncmp+0x38>
    return (uchar)*p - (uchar)*q;
    80000ff8:	00054503          	lbu	a0,0(a0)
    80000ffc:	0005c783          	lbu	a5,0(a1)
    80001000:	9d1d                	subw	a0,a0,a5
}
    80001002:	6422                	ld	s0,8(sp)
    80001004:	0141                	addi	sp,sp,16
    80001006:	8082                	ret
        return 0;
    80001008:	4501                	li	a0,0
    8000100a:	bfe5                	j	80001002 <strncmp+0x32>

000000008000100c <pswitch>:
    8000100c:	00153023          	sd	ra,0(a0)
    80001010:	00253423          	sd	sp,8(a0)
    80001014:	e900                	sd	s0,16(a0)
    80001016:	ed04                	sd	s1,24(a0)
    80001018:	03253023          	sd	s2,32(a0)
    8000101c:	03353423          	sd	s3,40(a0)
    80001020:	03453823          	sd	s4,48(a0)
    80001024:	03553c23          	sd	s5,56(a0)
    80001028:	05653023          	sd	s6,64(a0)
    8000102c:	05753423          	sd	s7,72(a0)
    80001030:	05853823          	sd	s8,80(a0)
    80001034:	05953c23          	sd	s9,88(a0)
    80001038:	07a53023          	sd	s10,96(a0)
    8000103c:	07b53423          	sd	s11,104(a0)
    80001040:	0005b083          	ld	ra,0(a1)
    80001044:	0085b103          	ld	sp,8(a1)
    80001048:	6980                	ld	s0,16(a1)
    8000104a:	6d84                	ld	s1,24(a1)
    8000104c:	0205b903          	ld	s2,32(a1)
    80001050:	0285b983          	ld	s3,40(a1)
    80001054:	0305ba03          	ld	s4,48(a1)
    80001058:	0385ba83          	ld	s5,56(a1)
    8000105c:	0405bb03          	ld	s6,64(a1)
    80001060:	0485bb83          	ld	s7,72(a1)
    80001064:	0505bc03          	ld	s8,80(a1)
    80001068:	0585bc83          	ld	s9,88(a1)
    8000106c:	0605bd03          	ld	s10,96(a1)
    80001070:	0685bd83          	ld	s11,104(a1)
    80001074:	8082                	ret

0000000080001076 <printint>:

static char digits[] = "0123456789ABCDEF";

static void
printint(int fd, int xx, int base, int sgn)
{
    80001076:	7139                	addi	sp,sp,-64
    80001078:	fc06                	sd	ra,56(sp)
    8000107a:	f822                	sd	s0,48(sp)
    8000107c:	f426                	sd	s1,40(sp)
    8000107e:	f04a                	sd	s2,32(sp)
    80001080:	ec4e                	sd	s3,24(sp)
    80001082:	0080                	addi	s0,sp,64
    80001084:	84aa                	mv	s1,a0
    char buf[16];
    int i, neg;
    uint x;

    neg = 0;
    if (sgn && xx < 0) {
    80001086:	c299                	beqz	a3,8000108c <printint+0x16>
    80001088:	0805c863          	bltz	a1,80001118 <printint+0xa2>
        neg = 1;
        x = -xx;
    } else {
        x = xx;
    8000108c:	2581                	sext.w	a1,a1
    neg = 0;
    8000108e:	4881                	li	a7,0
    80001090:	fc040693          	addi	a3,s0,-64
    }

    i = 0;
    80001094:	4701                	li	a4,0
    do {
        buf[i++] = digits[x % base];
    80001096:	2601                	sext.w	a2,a2
    80001098:	00004517          	auipc	a0,0x4
    8000109c:	0b050513          	addi	a0,a0,176 # 80005148 <digits>
    800010a0:	883a                	mv	a6,a4
    800010a2:	2705                	addiw	a4,a4,1
    800010a4:	02c5f7bb          	remuw	a5,a1,a2
    800010a8:	1782                	slli	a5,a5,0x20
    800010aa:	9381                	srli	a5,a5,0x20
    800010ac:	97aa                	add	a5,a5,a0
    800010ae:	0007c783          	lbu	a5,0(a5)
    800010b2:	00f68023          	sb	a5,0(a3)
    } while ((x /= base) != 0);
    800010b6:	0005879b          	sext.w	a5,a1
    800010ba:	02c5d5bb          	divuw	a1,a1,a2
    800010be:	0685                	addi	a3,a3,1
    800010c0:	fec7f0e3          	bgeu	a5,a2,800010a0 <printint+0x2a>
    if (neg)
    800010c4:	00088b63          	beqz	a7,800010da <printint+0x64>
        buf[i++] = '-';
    800010c8:	fd040793          	addi	a5,s0,-48
    800010cc:	973e                	add	a4,a4,a5
    800010ce:	02d00793          	li	a5,45
    800010d2:	fef70823          	sb	a5,-16(a4)
    800010d6:	0028071b          	addiw	a4,a6,2

    while (--i >= 0)
    800010da:	02e05863          	blez	a4,8000110a <printint+0x94>
    800010de:	fc040793          	addi	a5,s0,-64
    800010e2:	00e78933          	add	s2,a5,a4
    800010e6:	fff78993          	addi	s3,a5,-1
    800010ea:	99ba                	add	s3,s3,a4
    800010ec:	377d                	addiw	a4,a4,-1
    800010ee:	1702                	slli	a4,a4,0x20
    800010f0:	9301                	srli	a4,a4,0x20
    800010f2:	40e989b3          	sub	s3,s3,a4
        putc(fd, buf[i]);
    800010f6:	fff94583          	lbu	a1,-1(s2)
    800010fa:	8526                	mv	a0,s1
    800010fc:	fffff097          	auipc	ra,0xfffff
    80001100:	150080e7          	jalr	336(ra) # 8000024c <putc>
    while (--i >= 0)
    80001104:	197d                	addi	s2,s2,-1
    80001106:	ff3918e3          	bne	s2,s3,800010f6 <printint+0x80>
}
    8000110a:	70e2                	ld	ra,56(sp)
    8000110c:	7442                	ld	s0,48(sp)
    8000110e:	74a2                	ld	s1,40(sp)
    80001110:	7902                	ld	s2,32(sp)
    80001112:	69e2                	ld	s3,24(sp)
    80001114:	6121                	addi	sp,sp,64
    80001116:	8082                	ret
        x = -xx;
    80001118:	40b005bb          	negw	a1,a1
        neg = 1;
    8000111c:	4885                	li	a7,1
        x = -xx;
    8000111e:	bf8d                	j	80001090 <printint+0x1a>

0000000080001120 <vprintf>:
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char* fmt, va_list ap)
{
    80001120:	7119                	addi	sp,sp,-128
    80001122:	fc86                	sd	ra,120(sp)
    80001124:	f8a2                	sd	s0,112(sp)
    80001126:	f4a6                	sd	s1,104(sp)
    80001128:	f0ca                	sd	s2,96(sp)
    8000112a:	ecce                	sd	s3,88(sp)
    8000112c:	e8d2                	sd	s4,80(sp)
    8000112e:	e4d6                	sd	s5,72(sp)
    80001130:	e0da                	sd	s6,64(sp)
    80001132:	fc5e                	sd	s7,56(sp)
    80001134:	f862                	sd	s8,48(sp)
    80001136:	f466                	sd	s9,40(sp)
    80001138:	f06a                	sd	s10,32(sp)
    8000113a:	ec6e                	sd	s11,24(sp)
    8000113c:	0100                	addi	s0,sp,128
    char* s;
    int c, i, state;

    state = 0;
    for (i = 0; fmt[i]; i++) {
    8000113e:	0005c903          	lbu	s2,0(a1)
    80001142:	18090f63          	beqz	s2,800012e0 <vprintf+0x1c0>
    80001146:	8aaa                	mv	s5,a0
    80001148:	8b32                	mv	s6,a2
    8000114a:	00158493          	addi	s1,a1,1
    state = 0;
    8000114e:	4981                	li	s3,0
            if (c == '%') {
                state = '%';
            } else {
                putc(fd, c);
            }
        } else if (state == '%') {
    80001150:	02500a13          	li	s4,37
            if (c == 'd') {
    80001154:	06400c13          	li	s8,100
                printint(fd, va_arg(ap, int), 10, 1);
            } else if (c == 'l') {
    80001158:	06c00c93          	li	s9,108
                printint(fd, va_arg(ap, uint64), 10, 0);
            } else if (c == 'x') {
    8000115c:	07800d13          	li	s10,120
                printint(fd, va_arg(ap, int), 16, 0);
            } else if (c == 'p') {
    80001160:	07000d93          	li	s11,112
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    80001164:	00004b97          	auipc	s7,0x4
    80001168:	fe4b8b93          	addi	s7,s7,-28 # 80005148 <digits>
    8000116c:	a839                	j	8000118a <vprintf+0x6a>
                putc(fd, c);
    8000116e:	85ca                	mv	a1,s2
    80001170:	8556                	mv	a0,s5
    80001172:	fffff097          	auipc	ra,0xfffff
    80001176:	0da080e7          	jalr	218(ra) # 8000024c <putc>
    8000117a:	a019                	j	80001180 <vprintf+0x60>
        } else if (state == '%') {
    8000117c:	01498f63          	beq	s3,s4,8000119a <vprintf+0x7a>
    for (i = 0; fmt[i]; i++) {
    80001180:	0485                	addi	s1,s1,1
    80001182:	fff4c903          	lbu	s2,-1(s1)
    80001186:	14090d63          	beqz	s2,800012e0 <vprintf+0x1c0>
        c = fmt[i] & 0xff;
    8000118a:	0009079b          	sext.w	a5,s2
        if (state == 0) {
    8000118e:	fe0997e3          	bnez	s3,8000117c <vprintf+0x5c>
            if (c == '%') {
    80001192:	fd479ee3          	bne	a5,s4,8000116e <vprintf+0x4e>
                state = '%';
    80001196:	89be                	mv	s3,a5
    80001198:	b7e5                	j	80001180 <vprintf+0x60>
            if (c == 'd') {
    8000119a:	05878063          	beq	a5,s8,800011da <vprintf+0xba>
            } else if (c == 'l') {
    8000119e:	05978c63          	beq	a5,s9,800011f6 <vprintf+0xd6>
            } else if (c == 'x') {
    800011a2:	07a78863          	beq	a5,s10,80001212 <vprintf+0xf2>
            } else if (c == 'p') {
    800011a6:	09b78463          	beq	a5,s11,8000122e <vprintf+0x10e>
                printptr(fd, va_arg(ap, uint64));
            } else if (c == 's') {
    800011aa:	07300713          	li	a4,115
    800011ae:	0ce78663          	beq	a5,a4,8000127a <vprintf+0x15a>
                    s = "(null)";
                while (*s != 0) {
                    putc(fd, *s);
                    s++;
                }
            } else if (c == 'c') {
    800011b2:	06300713          	li	a4,99
    800011b6:	0ee78e63          	beq	a5,a4,800012b2 <vprintf+0x192>
                putc(fd, va_arg(ap, uint));
            } else if (c == '%') {
    800011ba:	11478863          	beq	a5,s4,800012ca <vprintf+0x1aa>
                putc(fd, c);
            } else {
                // Unknown % sequence.  Print it to draw attention.
                putc(fd, '%');
    800011be:	85d2                	mv	a1,s4
    800011c0:	8556                	mv	a0,s5
    800011c2:	fffff097          	auipc	ra,0xfffff
    800011c6:	08a080e7          	jalr	138(ra) # 8000024c <putc>
                putc(fd, c);
    800011ca:	85ca                	mv	a1,s2
    800011cc:	8556                	mv	a0,s5
    800011ce:	fffff097          	auipc	ra,0xfffff
    800011d2:	07e080e7          	jalr	126(ra) # 8000024c <putc>
            }
            state = 0;
    800011d6:	4981                	li	s3,0
    800011d8:	b765                	j	80001180 <vprintf+0x60>
                printint(fd, va_arg(ap, int), 10, 1);
    800011da:	008b0913          	addi	s2,s6,8
    800011de:	4685                	li	a3,1
    800011e0:	4629                	li	a2,10
    800011e2:	000b2583          	lw	a1,0(s6)
    800011e6:	8556                	mv	a0,s5
    800011e8:	00000097          	auipc	ra,0x0
    800011ec:	e8e080e7          	jalr	-370(ra) # 80001076 <printint>
    800011f0:	8b4a                	mv	s6,s2
            state = 0;
    800011f2:	4981                	li	s3,0
    800011f4:	b771                	j	80001180 <vprintf+0x60>
                printint(fd, va_arg(ap, uint64), 10, 0);
    800011f6:	008b0913          	addi	s2,s6,8
    800011fa:	4681                	li	a3,0
    800011fc:	4629                	li	a2,10
    800011fe:	000b2583          	lw	a1,0(s6)
    80001202:	8556                	mv	a0,s5
    80001204:	00000097          	auipc	ra,0x0
    80001208:	e72080e7          	jalr	-398(ra) # 80001076 <printint>
    8000120c:	8b4a                	mv	s6,s2
            state = 0;
    8000120e:	4981                	li	s3,0
    80001210:	bf85                	j	80001180 <vprintf+0x60>
                printint(fd, va_arg(ap, int), 16, 0);
    80001212:	008b0913          	addi	s2,s6,8
    80001216:	4681                	li	a3,0
    80001218:	4641                	li	a2,16
    8000121a:	000b2583          	lw	a1,0(s6)
    8000121e:	8556                	mv	a0,s5
    80001220:	00000097          	auipc	ra,0x0
    80001224:	e56080e7          	jalr	-426(ra) # 80001076 <printint>
    80001228:	8b4a                	mv	s6,s2
            state = 0;
    8000122a:	4981                	li	s3,0
    8000122c:	bf91                	j	80001180 <vprintf+0x60>
                printptr(fd, va_arg(ap, uint64));
    8000122e:	008b0793          	addi	a5,s6,8
    80001232:	f8f43423          	sd	a5,-120(s0)
    80001236:	000b3983          	ld	s3,0(s6)
    putc(fd, '0');
    8000123a:	03000593          	li	a1,48
    8000123e:	8556                	mv	a0,s5
    80001240:	fffff097          	auipc	ra,0xfffff
    80001244:	00c080e7          	jalr	12(ra) # 8000024c <putc>
    putc(fd, 'x');
    80001248:	85ea                	mv	a1,s10
    8000124a:	8556                	mv	a0,s5
    8000124c:	fffff097          	auipc	ra,0xfffff
    80001250:	000080e7          	jalr	ra # 8000024c <putc>
    80001254:	4941                	li	s2,16
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    80001256:	03c9d793          	srli	a5,s3,0x3c
    8000125a:	97de                	add	a5,a5,s7
    8000125c:	0007c583          	lbu	a1,0(a5)
    80001260:	8556                	mv	a0,s5
    80001262:	fffff097          	auipc	ra,0xfffff
    80001266:	fea080e7          	jalr	-22(ra) # 8000024c <putc>
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000126a:	0992                	slli	s3,s3,0x4
    8000126c:	397d                	addiw	s2,s2,-1
    8000126e:	fe0914e3          	bnez	s2,80001256 <vprintf+0x136>
                printptr(fd, va_arg(ap, uint64));
    80001272:	f8843b03          	ld	s6,-120(s0)
            state = 0;
    80001276:	4981                	li	s3,0
    80001278:	b721                	j	80001180 <vprintf+0x60>
                s = va_arg(ap, char*);
    8000127a:	008b0993          	addi	s3,s6,8
    8000127e:	000b3903          	ld	s2,0(s6)
                if (s == 0)
    80001282:	02090163          	beqz	s2,800012a4 <vprintf+0x184>
                while (*s != 0) {
    80001286:	00094583          	lbu	a1,0(s2)
    8000128a:	c9a1                	beqz	a1,800012da <vprintf+0x1ba>
                    putc(fd, *s);
    8000128c:	8556                	mv	a0,s5
    8000128e:	fffff097          	auipc	ra,0xfffff
    80001292:	fbe080e7          	jalr	-66(ra) # 8000024c <putc>
                    s++;
    80001296:	0905                	addi	s2,s2,1
                while (*s != 0) {
    80001298:	00094583          	lbu	a1,0(s2)
    8000129c:	f9e5                	bnez	a1,8000128c <vprintf+0x16c>
                s = va_arg(ap, char*);
    8000129e:	8b4e                	mv	s6,s3
            state = 0;
    800012a0:	4981                	li	s3,0
    800012a2:	bdf9                	j	80001180 <vprintf+0x60>
                    s = "(null)";
    800012a4:	00004917          	auipc	s2,0x4
    800012a8:	e6c90913          	addi	s2,s2,-404 # 80005110 <etext+0x110>
                while (*s != 0) {
    800012ac:	02800593          	li	a1,40
    800012b0:	bff1                	j	8000128c <vprintf+0x16c>
                putc(fd, va_arg(ap, uint));
    800012b2:	008b0913          	addi	s2,s6,8
    800012b6:	000b4583          	lbu	a1,0(s6)
    800012ba:	8556                	mv	a0,s5
    800012bc:	fffff097          	auipc	ra,0xfffff
    800012c0:	f90080e7          	jalr	-112(ra) # 8000024c <putc>
    800012c4:	8b4a                	mv	s6,s2
            state = 0;
    800012c6:	4981                	li	s3,0
    800012c8:	bd65                	j	80001180 <vprintf+0x60>
                putc(fd, c);
    800012ca:	85d2                	mv	a1,s4
    800012cc:	8556                	mv	a0,s5
    800012ce:	fffff097          	auipc	ra,0xfffff
    800012d2:	f7e080e7          	jalr	-130(ra) # 8000024c <putc>
            state = 0;
    800012d6:	4981                	li	s3,0
    800012d8:	b565                	j	80001180 <vprintf+0x60>
                s = va_arg(ap, char*);
    800012da:	8b4e                	mv	s6,s3
            state = 0;
    800012dc:	4981                	li	s3,0
    800012de:	b54d                	j	80001180 <vprintf+0x60>
        }
    }
}
    800012e0:	70e6                	ld	ra,120(sp)
    800012e2:	7446                	ld	s0,112(sp)
    800012e4:	74a6                	ld	s1,104(sp)
    800012e6:	7906                	ld	s2,96(sp)
    800012e8:	69e6                	ld	s3,88(sp)
    800012ea:	6a46                	ld	s4,80(sp)
    800012ec:	6aa6                	ld	s5,72(sp)
    800012ee:	6b06                	ld	s6,64(sp)
    800012f0:	7be2                	ld	s7,56(sp)
    800012f2:	7c42                	ld	s8,48(sp)
    800012f4:	7ca2                	ld	s9,40(sp)
    800012f6:	7d02                	ld	s10,32(sp)
    800012f8:	6de2                	ld	s11,24(sp)
    800012fa:	6109                	addi	sp,sp,128
    800012fc:	8082                	ret

00000000800012fe <fprintf>:

void fprintf(int fd, const char* fmt, ...)
{
    800012fe:	715d                	addi	sp,sp,-80
    80001300:	ec06                	sd	ra,24(sp)
    80001302:	e822                	sd	s0,16(sp)
    80001304:	1000                	addi	s0,sp,32
    80001306:	e010                	sd	a2,0(s0)
    80001308:	e414                	sd	a3,8(s0)
    8000130a:	e818                	sd	a4,16(s0)
    8000130c:	ec1c                	sd	a5,24(s0)
    8000130e:	03043023          	sd	a6,32(s0)
    80001312:	03143423          	sd	a7,40(s0)
    va_list ap;

    va_start(ap, fmt);
    80001316:	fe843423          	sd	s0,-24(s0)
    vprintf(fd, fmt, ap);
    8000131a:	8622                	mv	a2,s0
    8000131c:	00000097          	auipc	ra,0x0
    80001320:	e04080e7          	jalr	-508(ra) # 80001120 <vprintf>
}
    80001324:	60e2                	ld	ra,24(sp)
    80001326:	6442                	ld	s0,16(sp)
    80001328:	6161                	addi	sp,sp,80
    8000132a:	8082                	ret

000000008000132c <printf>:

void printf(const char* fmt, ...)
{
    8000132c:	711d                	addi	sp,sp,-96
    8000132e:	ec06                	sd	ra,24(sp)
    80001330:	e822                	sd	s0,16(sp)
    80001332:	1000                	addi	s0,sp,32
    80001334:	e40c                	sd	a1,8(s0)
    80001336:	e810                	sd	a2,16(s0)
    80001338:	ec14                	sd	a3,24(s0)
    8000133a:	f018                	sd	a4,32(s0)
    8000133c:	f41c                	sd	a5,40(s0)
    8000133e:	03043823          	sd	a6,48(s0)
    80001342:	03143c23          	sd	a7,56(s0)
    va_list ap;

    va_start(ap, fmt);
    80001346:	00840613          	addi	a2,s0,8
    8000134a:	fec43423          	sd	a2,-24(s0)
    vprintf(1, fmt, ap);
    8000134e:	85aa                	mv	a1,a0
    80001350:	4505                	li	a0,1
    80001352:	00000097          	auipc	ra,0x0
    80001356:	dce080e7          	jalr	-562(ra) # 80001120 <vprintf>
}
    8000135a:	60e2                	ld	ra,24(sp)
    8000135c:	6442                	ld	s0,16(sp)
    8000135e:	6125                	addi	sp,sp,96
    80001360:	8082                	ret

0000000080001362 <puts>:

void puts(const char* str)
{
    80001362:	1141                	addi	sp,sp,-16
    80001364:	e406                	sd	ra,8(sp)
    80001366:	e022                	sd	s0,0(sp)
    80001368:	0800                	addi	s0,sp,16
    8000136a:	85aa                	mv	a1,a0
    printf("%s\n", str);
    8000136c:	00004517          	auipc	a0,0x4
    80001370:	dac50513          	addi	a0,a0,-596 # 80005118 <etext+0x118>
    80001374:	00000097          	auipc	ra,0x0
    80001378:	fb8080e7          	jalr	-72(ra) # 8000132c <printf>
}
    8000137c:	60a2                	ld	ra,8(sp)
    8000137e:	6402                	ld	s0,0(sp)
    80001380:	0141                	addi	sp,sp,16
    80001382:	8082                	ret

0000000080001384 <backtrace>:

void backtrace()
{
    80001384:	7179                	addi	sp,sp,-48
    80001386:	f406                	sd	ra,40(sp)
    80001388:	f022                	sd	s0,32(sp)
    8000138a:	ec26                	sd	s1,24(sp)
    8000138c:	e84a                	sd	s2,16(sp)
    8000138e:	e44e                	sd	s3,8(sp)
    80001390:	e052                	sd	s4,0(sp)
    80001392:	1800                	addi	s0,sp,48
    asm volatile("mv %0, s0" : "=r" (x) );
    80001394:	84a2                	mv	s1,s0
    uint64 s0 = r_fp();
    uint64 stack_top = PGROUNDUP(s0);
    80001396:	6905                	lui	s2,0x1
    80001398:	197d                	addi	s2,s2,-1
    8000139a:	9926                	add	s2,s2,s1
    8000139c:	79fd                	lui	s3,0xfffff
    8000139e:	01397933          	and	s2,s2,s3
    uint64 stack_bottom = PGROUNDDOWN(s0);
    800013a2:	0134f9b3          	and	s3,s1,s3
    uint64 fp = s0;

    printf("backtrace:\n");
    800013a6:	00004517          	auipc	a0,0x4
    800013aa:	d7a50513          	addi	a0,a0,-646 # 80005120 <etext+0x120>
    800013ae:	00000097          	auipc	ra,0x0
    800013b2:	f7e080e7          	jalr	-130(ra) # 8000132c <printf>
    while (fp != stack_top && fp != stack_bottom)
    800013b6:	02990563          	beq	s2,s1,800013e0 <backtrace+0x5c>
    800013ba:	02998363          	beq	s3,s1,800013e0 <backtrace+0x5c>
    {
        printf("%p\n", *(uint64*)(fp - 8));
    800013be:	00004a17          	auipc	s4,0x4
    800013c2:	d72a0a13          	addi	s4,s4,-654 # 80005130 <etext+0x130>
    800013c6:	ff84b583          	ld	a1,-8(s1)
    800013ca:	8552                	mv	a0,s4
    800013cc:	00000097          	auipc	ra,0x0
    800013d0:	f60080e7          	jalr	-160(ra) # 8000132c <printf>
        fp = *(uint64*)(fp - 16);
    800013d4:	ff04b483          	ld	s1,-16(s1)
    while (fp != stack_top && fp != stack_bottom)
    800013d8:	00990463          	beq	s2,s1,800013e0 <backtrace+0x5c>
    800013dc:	fe9995e3          	bne	s3,s1,800013c6 <backtrace+0x42>
    }
}
    800013e0:	70a2                	ld	ra,40(sp)
    800013e2:	7402                	ld	s0,32(sp)
    800013e4:	64e2                	ld	s1,24(sp)
    800013e6:	6942                	ld	s2,16(sp)
    800013e8:	69a2                	ld	s3,8(sp)
    800013ea:	6a02                	ld	s4,0(sp)
    800013ec:	6145                	addi	sp,sp,48
    800013ee:	8082                	ret

00000000800013f0 <panic>:

void panic(char* s)
{
    800013f0:	1141                	addi	sp,sp,-16
    800013f2:	e406                	sd	ra,8(sp)
    800013f4:	e022                	sd	s0,0(sp)
    800013f6:	0800                	addi	s0,sp,16
    800013f8:	85aa                	mv	a1,a0
    printf("panic:%s", s);
    800013fa:	00004517          	auipc	a0,0x4
    800013fe:	d3e50513          	addi	a0,a0,-706 # 80005138 <etext+0x138>
    80001402:	00000097          	auipc	ra,0x0
    80001406:	f2a080e7          	jalr	-214(ra) # 8000132c <printf>
//    backtrace();
    for (;;) {
    8000140a:	a001                	j	8000140a <panic+0x1a>

000000008000140c <kfree>:
}


// 释放一页pa指向的物理空间
void kfree(void *pa)
{
    8000140c:	1101                	addi	sp,sp,-32
    8000140e:	ec06                	sd	ra,24(sp)
    80001410:	e822                	sd	s0,16(sp)
    80001412:	e426                	sd	s1,8(sp)
    80001414:	e04a                	sd	s2,0(sp)
    80001416:	1000                	addi	s0,sp,32
    80001418:	84aa                	mv	s1,a0
    struct node *r;

    if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    8000141a:	03451793          	slli	a5,a0,0x34
    8000141e:	eb99                	bnez	a5,80001434 <kfree+0x28>
    80001420:	000ab797          	auipc	a5,0xab
    80001424:	61078793          	addi	a5,a5,1552 # 800aca30 <end>
    80001428:	00f56663          	bltu	a0,a5,80001434 <kfree+0x28>
    8000142c:	47c5                	li	a5,17
    8000142e:	07ee                	slli	a5,a5,0x1b
    80001430:	00f56a63          	bltu	a0,a5,80001444 <kfree+0x38>
        panic("kfree");
    80001434:	00004517          	auipc	a0,0x4
    80001438:	d2c50513          	addi	a0,a0,-724 # 80005160 <digits+0x18>
    8000143c:	00000097          	auipc	ra,0x0
    80001440:	fb4080e7          	jalr	-76(ra) # 800013f0 <panic>

    // 填充无效值
    memset(pa, 1, PGSIZE);
    80001444:	6605                	lui	a2,0x1
    80001446:	4585                	li	a1,1
    80001448:	8526                	mv	a0,s1
    8000144a:	00000097          	auipc	ra,0x0
    8000144e:	a22080e7          	jalr	-1502(ra) # 80000e6c <memset>

    r = (struct node*)pa;

    spin_lock(&kmem.lock);
    80001452:	0008c917          	auipc	s2,0x8c
    80001456:	a3690913          	addi	s2,s2,-1482 # 8008ce88 <kmem>
    8000145a:	854a                	mv	a0,s2
    8000145c:	00002097          	auipc	ra,0x2
    80001460:	06e080e7          	jalr	110(ra) # 800034ca <spin_lock>
    r->next = kmem.freelist;
    80001464:	01893783          	ld	a5,24(s2)
    80001468:	e09c                	sd	a5,0(s1)
    kmem.freelist = r;
    8000146a:	00993c23          	sd	s1,24(s2)
    spin_unlock(&kmem.lock);
    8000146e:	854a                	mv	a0,s2
    80001470:	00002097          	auipc	ra,0x2
    80001474:	12e080e7          	jalr	302(ra) # 8000359e <spin_unlock>
}
    80001478:	60e2                	ld	ra,24(sp)
    8000147a:	6442                	ld	s0,16(sp)
    8000147c:	64a2                	ld	s1,8(sp)
    8000147e:	6902                	ld	s2,0(sp)
    80001480:	6105                	addi	sp,sp,32
    80001482:	8082                	ret

0000000080001484 <free_range>:
{
    80001484:	7179                	addi	sp,sp,-48
    80001486:	f406                	sd	ra,40(sp)
    80001488:	f022                	sd	s0,32(sp)
    8000148a:	ec26                	sd	s1,24(sp)
    8000148c:	e84a                	sd	s2,16(sp)
    8000148e:	e44e                	sd	s3,8(sp)
    80001490:	e052                	sd	s4,0(sp)
    80001492:	1800                	addi	s0,sp,48
    p = (char*)PGROUNDUP((uint64)pa_start);
    80001494:	6785                	lui	a5,0x1
    80001496:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    8000149a:	94aa                	add	s1,s1,a0
    8000149c:	757d                	lui	a0,0xfffff
    8000149e:	8ce9                	and	s1,s1,a0
    for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800014a0:	94be                	add	s1,s1,a5
    800014a2:	0095ee63          	bltu	a1,s1,800014be <free_range+0x3a>
    800014a6:	892e                	mv	s2,a1
        kfree(p);
    800014a8:	7a7d                	lui	s4,0xfffff
    for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800014aa:	6985                	lui	s3,0x1
        kfree(p);
    800014ac:	01448533          	add	a0,s1,s4
    800014b0:	00000097          	auipc	ra,0x0
    800014b4:	f5c080e7          	jalr	-164(ra) # 8000140c <kfree>
    for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800014b8:	94ce                	add	s1,s1,s3
    800014ba:	fe9979e3          	bgeu	s2,s1,800014ac <free_range+0x28>
}
    800014be:	70a2                	ld	ra,40(sp)
    800014c0:	7402                	ld	s0,32(sp)
    800014c2:	64e2                	ld	s1,24(sp)
    800014c4:	6942                	ld	s2,16(sp)
    800014c6:	69a2                	ld	s3,8(sp)
    800014c8:	6a02                	ld	s4,0(sp)
    800014ca:	6145                	addi	sp,sp,48
    800014cc:	8082                	ret

00000000800014ce <kernel_mem_init>:
{
    800014ce:	1141                	addi	sp,sp,-16
    800014d0:	e406                	sd	ra,8(sp)
    800014d2:	e022                	sd	s0,0(sp)
    800014d4:	0800                	addi	s0,sp,16
    spinlock_init(&kmem.lock, "kmem");
    800014d6:	00004597          	auipc	a1,0x4
    800014da:	c9258593          	addi	a1,a1,-878 # 80005168 <digits+0x20>
    800014de:	0008c517          	auipc	a0,0x8c
    800014e2:	9aa50513          	addi	a0,a0,-1622 # 8008ce88 <kmem>
    800014e6:	00002097          	auipc	ra,0x2
    800014ea:	f54080e7          	jalr	-172(ra) # 8000343a <spinlock_init>
    free_range(end, (void*)PHYSTOP);
    800014ee:	45c5                	li	a1,17
    800014f0:	05ee                	slli	a1,a1,0x1b
    800014f2:	000ab517          	auipc	a0,0xab
    800014f6:	53e50513          	addi	a0,a0,1342 # 800aca30 <end>
    800014fa:	00000097          	auipc	ra,0x0
    800014fe:	f8a080e7          	jalr	-118(ra) # 80001484 <free_range>
}
    80001502:	60a2                	ld	ra,8(sp)
    80001504:	6402                	ld	s0,0(sp)
    80001506:	0141                	addi	sp,sp,16
    80001508:	8082                	ret

000000008000150a <kalloc>:

// 分配一个4096字节的物理页，返回内核能够使用的指针, 如果
// 内存耗尽会返回0。
void * kalloc(void)
{
    8000150a:	1101                	addi	sp,sp,-32
    8000150c:	ec06                	sd	ra,24(sp)
    8000150e:	e822                	sd	s0,16(sp)
    80001510:	e426                	sd	s1,8(sp)
    80001512:	1000                	addi	s0,sp,32
    struct node *r;

    spin_lock(&kmem.lock);
    80001514:	0008c497          	auipc	s1,0x8c
    80001518:	97448493          	addi	s1,s1,-1676 # 8008ce88 <kmem>
    8000151c:	8526                	mv	a0,s1
    8000151e:	00002097          	auipc	ra,0x2
    80001522:	fac080e7          	jalr	-84(ra) # 800034ca <spin_lock>
    r = kmem.freelist;
    80001526:	6c84                	ld	s1,24(s1)
    if(r)
    80001528:	c885                	beqz	s1,80001558 <kalloc+0x4e>
        kmem.freelist = r->next;
    8000152a:	609c                	ld	a5,0(s1)
    8000152c:	0008c517          	auipc	a0,0x8c
    80001530:	95c50513          	addi	a0,a0,-1700 # 8008ce88 <kmem>
    80001534:	ed1c                	sd	a5,24(a0)
    spin_unlock(&kmem.lock);
    80001536:	00002097          	auipc	ra,0x2
    8000153a:	068080e7          	jalr	104(ra) # 8000359e <spin_unlock>

    if(r)
        memset((char*)r, 5, PGSIZE); // fill with junk
    8000153e:	6605                	lui	a2,0x1
    80001540:	4595                	li	a1,5
    80001542:	8526                	mv	a0,s1
    80001544:	00000097          	auipc	ra,0x0
    80001548:	928080e7          	jalr	-1752(ra) # 80000e6c <memset>
    return (void*)r;
}
    8000154c:	8526                	mv	a0,s1
    8000154e:	60e2                	ld	ra,24(sp)
    80001550:	6442                	ld	s0,16(sp)
    80001552:	64a2                	ld	s1,8(sp)
    80001554:	6105                	addi	sp,sp,32
    80001556:	8082                	ret
    spin_unlock(&kmem.lock);
    80001558:	0008c517          	auipc	a0,0x8c
    8000155c:	93050513          	addi	a0,a0,-1744 # 8008ce88 <kmem>
    80001560:	00002097          	auipc	ra,0x2
    80001564:	03e080e7          	jalr	62(ra) # 8000359e <spin_unlock>
    if(r)
    80001568:	b7d5                	j	8000154c <kalloc+0x42>

000000008000156a <vm_hart_init>:
}

/**
 * 切换页表寄存器为内核页表并启用分页
 */
void vm_hart_init() {
    8000156a:	1141                	addi	sp,sp,-16
    8000156c:	e422                	sd	s0,8(sp)
    8000156e:	0800                	addi	s0,sp,16
    w_satp(MAKE_SATP(kernel_pagetable));
    80001570:	00005797          	auipc	a5,0x5
    80001574:	a987b783          	ld	a5,-1384(a5) # 80006008 <kernel_pagetable>
    80001578:	83b1                	srli	a5,a5,0xc
    8000157a:	577d                	li	a4,-1
    8000157c:	177e                	slli	a4,a4,0x3f
    8000157e:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80001580:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80001584:	12000073          	sfence.vma
    sfence_vma();
}
    80001588:	6422                	ld	s0,8(sp)
    8000158a:	0141                	addi	sp,sp,16
    8000158c:	8082                	ret

000000008000158e <walk>:
 * @param pagetable 页表
 * @param va 需要查找PTE的va
 * @param alloc 是否创建缺失的页表
 * @return
 */
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc) {
    8000158e:	7139                	addi	sp,sp,-64
    80001590:	fc06                	sd	ra,56(sp)
    80001592:	f822                	sd	s0,48(sp)
    80001594:	f426                	sd	s1,40(sp)
    80001596:	f04a                	sd	s2,32(sp)
    80001598:	ec4e                	sd	s3,24(sp)
    8000159a:	e852                	sd	s4,16(sp)
    8000159c:	e456                	sd	s5,8(sp)
    8000159e:	e05a                	sd	s6,0(sp)
    800015a0:	0080                	addi	s0,sp,64
    800015a2:	84aa                	mv	s1,a0
    800015a4:	89ae                	mv	s3,a1
    800015a6:	8ab2                	mv	s5,a2
    if (va >= MAXVA)
    800015a8:	57fd                	li	a5,-1
    800015aa:	83e9                	srli	a5,a5,0x1a
    800015ac:	00b7e563          	bltu	a5,a1,800015b6 <walk+0x28>
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc) {
    800015b0:	4a79                	li	s4,30
        panic("walk");
    for (int level = 2; level > 0; level--) {
    800015b2:	4b31                	li	s6,12
    800015b4:	a091                	j	800015f8 <walk+0x6a>
        panic("walk");
    800015b6:	00004517          	auipc	a0,0x4
    800015ba:	bba50513          	addi	a0,a0,-1094 # 80005170 <digits+0x28>
    800015be:	00000097          	auipc	ra,0x0
    800015c2:	e32080e7          	jalr	-462(ra) # 800013f0 <panic>
    800015c6:	b7ed                	j	800015b0 <walk+0x22>
        pte_t *pte = &pagetable[PX(level, va)];
        if (*pte & PTE_V) {
            pagetable = (pagetable_t) PTE2PA(*pte);
        } else {
            if (!alloc || (pagetable = (pte_t *) kalloc()) == 0)
    800015c8:	060a8663          	beqz	s5,80001634 <walk+0xa6>
    800015cc:	00000097          	auipc	ra,0x0
    800015d0:	f3e080e7          	jalr	-194(ra) # 8000150a <kalloc>
    800015d4:	84aa                	mv	s1,a0
    800015d6:	c529                	beqz	a0,80001620 <walk+0x92>
                return 0;
            memset(pagetable, 0, PGSIZE);
    800015d8:	6605                	lui	a2,0x1
    800015da:	4581                	li	a1,0
    800015dc:	00000097          	auipc	ra,0x0
    800015e0:	890080e7          	jalr	-1904(ra) # 80000e6c <memset>
            *pte = PA2PTE(pagetable) | PTE_V;
    800015e4:	00c4d793          	srli	a5,s1,0xc
    800015e8:	07aa                	slli	a5,a5,0xa
    800015ea:	0017e793          	ori	a5,a5,1
    800015ee:	00f93023          	sd	a5,0(s2)
    for (int level = 2; level > 0; level--) {
    800015f2:	3a5d                	addiw	s4,s4,-9
    800015f4:	036a0063          	beq	s4,s6,80001614 <walk+0x86>
        pte_t *pte = &pagetable[PX(level, va)];
    800015f8:	0149d933          	srl	s2,s3,s4
    800015fc:	1ff97913          	andi	s2,s2,511
    80001600:	090e                	slli	s2,s2,0x3
    80001602:	9926                	add	s2,s2,s1
        if (*pte & PTE_V) {
    80001604:	00093483          	ld	s1,0(s2)
    80001608:	0014f793          	andi	a5,s1,1
    8000160c:	dfd5                	beqz	a5,800015c8 <walk+0x3a>
            pagetable = (pagetable_t) PTE2PA(*pte);
    8000160e:	80a9                	srli	s1,s1,0xa
    80001610:	04b2                	slli	s1,s1,0xc
    80001612:	b7c5                	j	800015f2 <walk+0x64>
        }
    }
    return &pagetable[PX(0, va)];
    80001614:	00c9d513          	srli	a0,s3,0xc
    80001618:	1ff57513          	andi	a0,a0,511
    8000161c:	050e                	slli	a0,a0,0x3
    8000161e:	9526                	add	a0,a0,s1
}
    80001620:	70e2                	ld	ra,56(sp)
    80001622:	7442                	ld	s0,48(sp)
    80001624:	74a2                	ld	s1,40(sp)
    80001626:	7902                	ld	s2,32(sp)
    80001628:	69e2                	ld	s3,24(sp)
    8000162a:	6a42                	ld	s4,16(sp)
    8000162c:	6aa2                	ld	s5,8(sp)
    8000162e:	6b02                	ld	s6,0(sp)
    80001630:	6121                	addi	sp,sp,64
    80001632:	8082                	ret
                return 0;
    80001634:	4501                	li	a0,0
    80001636:	b7ed                	j	80001620 <walk+0x92>

0000000080001638 <mappages>:
 * @param va 虚拟地址起始地址
 * @param sz 要映射地址的大小
 * @param pa 物理地址的起始地址
 * @param perm PTE的权限
*/
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm) {
    80001638:	711d                	addi	sp,sp,-96
    8000163a:	ec86                	sd	ra,88(sp)
    8000163c:	e8a2                	sd	s0,80(sp)
    8000163e:	e4a6                	sd	s1,72(sp)
    80001640:	e0ca                	sd	s2,64(sp)
    80001642:	fc4e                	sd	s3,56(sp)
    80001644:	f852                	sd	s4,48(sp)
    80001646:	f456                	sd	s5,40(sp)
    80001648:	f05a                	sd	s6,32(sp)
    8000164a:	ec5e                	sd	s7,24(sp)
    8000164c:	e862                	sd	s8,16(sp)
    8000164e:	e466                	sd	s9,8(sp)
    80001650:	1080                	addi	s0,sp,96
    80001652:	8b2a                	mv	s6,a0
    80001654:	8bba                	mv	s7,a4
    uint64 a, last;
    pte_t *pte;

    a = PGROUNDDOWN(va);
    80001656:	777d                	lui	a4,0xfffff
    80001658:	00e5f7b3          	and	a5,a1,a4
    last = PGROUNDDOWN(va + size - 1);
    8000165c:	167d                	addi	a2,a2,-1
    8000165e:	00b60a33          	add	s4,a2,a1
    80001662:	00ea7a33          	and	s4,s4,a4
    a = PGROUNDDOWN(va);
    80001666:	89be                	mv	s3,a5
    80001668:	40f68ab3          	sub	s5,a3,a5
    for (;;) {
        if ((pte = walk(pagetable, a, 1)) == 0)
            return -1;
        if (*pte & PTE_V)
            panic("remap");
    8000166c:	00004c97          	auipc	s9,0x4
    80001670:	b0cc8c93          	addi	s9,s9,-1268 # 80005178 <digits+0x30>
        *pte = PA2PTE(pa) | perm | PTE_V;
        if (a == last) {
            break;
        }
        a += PGSIZE;
    80001674:	6c05                	lui	s8,0x1
    80001676:	a00d                	j	80001698 <mappages+0x60>
            panic("remap");
    80001678:	8566                	mv	a0,s9
    8000167a:	00000097          	auipc	ra,0x0
    8000167e:	d76080e7          	jalr	-650(ra) # 800013f0 <panic>
        *pte = PA2PTE(pa) | perm | PTE_V;
    80001682:	80b1                	srli	s1,s1,0xc
    80001684:	04aa                	slli	s1,s1,0xa
    80001686:	0174e4b3          	or	s1,s1,s7
    8000168a:	0014e493          	ori	s1,s1,1
    8000168e:	00993023          	sd	s1,0(s2)
        if (a == last) {
    80001692:	05498063          	beq	s3,s4,800016d2 <mappages+0x9a>
        a += PGSIZE;
    80001696:	99e2                	add	s3,s3,s8
    for (;;) {
    80001698:	013a84b3          	add	s1,s5,s3
        if ((pte = walk(pagetable, a, 1)) == 0)
    8000169c:	4605                	li	a2,1
    8000169e:	85ce                	mv	a1,s3
    800016a0:	855a                	mv	a0,s6
    800016a2:	00000097          	auipc	ra,0x0
    800016a6:	eec080e7          	jalr	-276(ra) # 8000158e <walk>
    800016aa:	892a                	mv	s2,a0
    800016ac:	c509                	beqz	a0,800016b6 <mappages+0x7e>
        if (*pte & PTE_V)
    800016ae:	611c                	ld	a5,0(a0)
    800016b0:	8b85                	andi	a5,a5,1
    800016b2:	dbe1                	beqz	a5,80001682 <mappages+0x4a>
    800016b4:	b7d1                	j	80001678 <mappages+0x40>
            return -1;
    800016b6:	557d                	li	a0,-1
        pa += PGSIZE;
    }
    return 0;
}
    800016b8:	60e6                	ld	ra,88(sp)
    800016ba:	6446                	ld	s0,80(sp)
    800016bc:	64a6                	ld	s1,72(sp)
    800016be:	6906                	ld	s2,64(sp)
    800016c0:	79e2                	ld	s3,56(sp)
    800016c2:	7a42                	ld	s4,48(sp)
    800016c4:	7aa2                	ld	s5,40(sp)
    800016c6:	7b02                	ld	s6,32(sp)
    800016c8:	6be2                	ld	s7,24(sp)
    800016ca:	6c42                	ld	s8,16(sp)
    800016cc:	6ca2                	ld	s9,8(sp)
    800016ce:	6125                	addi	sp,sp,96
    800016d0:	8082                	ret
    return 0;
    800016d2:	4501                	li	a0,0
    800016d4:	b7d5                	j	800016b8 <mappages+0x80>

00000000800016d6 <walkaddr>:
 */
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
    pte_t *pte;
    uint64 pa;

    if (va >= MAXVA)
    800016d6:	57fd                	li	a5,-1
    800016d8:	83e9                	srli	a5,a5,0x1a
    800016da:	00b7f463          	bgeu	a5,a1,800016e2 <walkaddr+0xc>
        return 0;
    800016de:	4501                	li	a0,0
    // TODO 用户空间时修改
    if ((*pte & PTE_U) == 0)
        return 0;
    pa = PTE2PA(*pte);
    return pa;
}
    800016e0:	8082                	ret
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
    800016e2:	1141                	addi	sp,sp,-16
    800016e4:	e406                	sd	ra,8(sp)
    800016e6:	e022                	sd	s0,0(sp)
    800016e8:	0800                	addi	s0,sp,16
    pte = walk(pagetable, va, 0);
    800016ea:	4601                	li	a2,0
    800016ec:	00000097          	auipc	ra,0x0
    800016f0:	ea2080e7          	jalr	-350(ra) # 8000158e <walk>
    if (pte == 0)
    800016f4:	c105                	beqz	a0,80001714 <walkaddr+0x3e>
    if ((*pte & PTE_V) == 0)
    800016f6:	611c                	ld	a5,0(a0)
    if ((*pte & PTE_U) == 0)
    800016f8:	0117f693          	andi	a3,a5,17
    800016fc:	4745                	li	a4,17
        return 0;
    800016fe:	4501                	li	a0,0
    if ((*pte & PTE_U) == 0)
    80001700:	00e68663          	beq	a3,a4,8000170c <walkaddr+0x36>
}
    80001704:	60a2                	ld	ra,8(sp)
    80001706:	6402                	ld	s0,0(sp)
    80001708:	0141                	addi	sp,sp,16
    8000170a:	8082                	ret
    pa = PTE2PA(*pte);
    8000170c:	00a7d513          	srli	a0,a5,0xa
    80001710:	0532                	slli	a0,a0,0xc
    return pa;
    80001712:	bfcd                	j	80001704 <walkaddr+0x2e>
        return 0;
    80001714:	4501                	li	a0,0
    80001716:	b7fd                	j	80001704 <walkaddr+0x2e>

0000000080001718 <kernel_vm_map>:
 * 添加虚拟地址和物理地址的映射到内核页表，只会在
 * 启动的过程中使用，在调用该函数时还没有flush TLB
 * 也没有启用分页。
 *
 */
void kernel_vm_map(uint64 va, uint64 pa, uint64 sz, int perm) {
    80001718:	1141                	addi	sp,sp,-16
    8000171a:	e406                	sd	ra,8(sp)
    8000171c:	e022                	sd	s0,0(sp)
    8000171e:	0800                	addi	s0,sp,16
    80001720:	8736                	mv	a4,a3
    if (mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    80001722:	86ae                	mv	a3,a1
    80001724:	85aa                	mv	a1,a0
    80001726:	00005517          	auipc	a0,0x5
    8000172a:	8e253503          	ld	a0,-1822(a0) # 80006008 <kernel_pagetable>
    8000172e:	00000097          	auipc	ra,0x0
    80001732:	f0a080e7          	jalr	-246(ra) # 80001638 <mappages>
    80001736:	e509                	bnez	a0,80001740 <kernel_vm_map+0x28>
        panic("kvmmap");
}
    80001738:	60a2                	ld	ra,8(sp)
    8000173a:	6402                	ld	s0,0(sp)
    8000173c:	0141                	addi	sp,sp,16
    8000173e:	8082                	ret
        panic("kvmmap");
    80001740:	00004517          	auipc	a0,0x4
    80001744:	a4050513          	addi	a0,a0,-1472 # 80005180 <digits+0x38>
    80001748:	00000097          	auipc	ra,0x0
    8000174c:	ca8080e7          	jalr	-856(ra) # 800013f0 <panic>
}
    80001750:	b7e5                	j	80001738 <kernel_vm_map+0x20>

0000000080001752 <kernel_vm_init>:
void kernel_vm_init() {
    80001752:	1101                	addi	sp,sp,-32
    80001754:	ec06                	sd	ra,24(sp)
    80001756:	e822                	sd	s0,16(sp)
    80001758:	e426                	sd	s1,8(sp)
    8000175a:	1000                	addi	s0,sp,32
    kernel_pagetable = (pagetable_t) kalloc();
    8000175c:	00000097          	auipc	ra,0x0
    80001760:	dae080e7          	jalr	-594(ra) # 8000150a <kalloc>
    80001764:	00005797          	auipc	a5,0x5
    80001768:	8aa7b223          	sd	a0,-1884(a5) # 80006008 <kernel_pagetable>
    memset(kernel_pagetable, 0, PGSIZE);
    8000176c:	6605                	lui	a2,0x1
    8000176e:	4581                	li	a1,0
    80001770:	fffff097          	auipc	ra,0xfffff
    80001774:	6fc080e7          	jalr	1788(ra) # 80000e6c <memset>
    kernel_vm_map(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001778:	4699                	li	a3,6
    8000177a:	6605                	lui	a2,0x1
    8000177c:	100005b7          	lui	a1,0x10000
    80001780:	10000537          	lui	a0,0x10000
    80001784:	00000097          	auipc	ra,0x0
    80001788:	f94080e7          	jalr	-108(ra) # 80001718 <kernel_vm_map>
    kernel_vm_map(VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000178c:	4699                	li	a3,6
    8000178e:	6605                	lui	a2,0x1
    80001790:	100015b7          	lui	a1,0x10001
    80001794:	10001537          	lui	a0,0x10001
    80001798:	00000097          	auipc	ra,0x0
    8000179c:	f80080e7          	jalr	-128(ra) # 80001718 <kernel_vm_map>
    kernel_vm_map(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    800017a0:	4699                	li	a3,6
    800017a2:	6641                	lui	a2,0x10
    800017a4:	020005b7          	lui	a1,0x2000
    800017a8:	02000537          	lui	a0,0x2000
    800017ac:	00000097          	auipc	ra,0x0
    800017b0:	f6c080e7          	jalr	-148(ra) # 80001718 <kernel_vm_map>
    kernel_vm_map(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800017b4:	4699                	li	a3,6
    800017b6:	00400637          	lui	a2,0x400
    800017ba:	0c0005b7          	lui	a1,0xc000
    800017be:	0c000537          	lui	a0,0xc000
    800017c2:	00000097          	auipc	ra,0x0
    800017c6:	f56080e7          	jalr	-170(ra) # 80001718 <kernel_vm_map>
    kernel_vm_map(KERNBASE, KERNBASE, (uint64) etext - KERNBASE, PTE_R | PTE_X);
    800017ca:	00004497          	auipc	s1,0x4
    800017ce:	83648493          	addi	s1,s1,-1994 # 80005000 <etext>
    800017d2:	46a9                	li	a3,10
    800017d4:	80004617          	auipc	a2,0x80004
    800017d8:	82c60613          	addi	a2,a2,-2004 # 5000 <_entry-0x7fffb000>
    800017dc:	4585                	li	a1,1
    800017de:	05fe                	slli	a1,a1,0x1f
    800017e0:	852e                	mv	a0,a1
    800017e2:	00000097          	auipc	ra,0x0
    800017e6:	f36080e7          	jalr	-202(ra) # 80001718 <kernel_vm_map>
    kernel_vm_map((uint64) etext, (uint64) etext, PHYSTOP - (uint64) etext, PTE_R | PTE_W);
    800017ea:	4699                	li	a3,6
    800017ec:	4645                	li	a2,17
    800017ee:	066e                	slli	a2,a2,0x1b
    800017f0:	8e05                	sub	a2,a2,s1
    800017f2:	85a6                	mv	a1,s1
    800017f4:	8526                	mv	a0,s1
    800017f6:	00000097          	auipc	ra,0x0
    800017fa:	f22080e7          	jalr	-222(ra) # 80001718 <kernel_vm_map>
    kernel_vm_map(TRAMPOLINE, (uint64) trampoline, PGSIZE, PTE_R | PTE_X);
    800017fe:	46a9                	li	a3,10
    80001800:	6605                	lui	a2,0x1
    80001802:	00002597          	auipc	a1,0x2
    80001806:	7fe58593          	addi	a1,a1,2046 # 80004000 <_trampoline>
    8000180a:	04000537          	lui	a0,0x4000
    8000180e:	157d                	addi	a0,a0,-1
    80001810:	0532                	slli	a0,a0,0xc
    80001812:	00000097          	auipc	ra,0x0
    80001816:	f06080e7          	jalr	-250(ra) # 80001718 <kernel_vm_map>
}
    8000181a:	60e2                	ld	ra,24(sp)
    8000181c:	6442                	ld	s0,16(sp)
    8000181e:	64a2                	ld	s1,8(sp)
    80001820:	6105                	addi	sp,sp,32
    80001822:	8082                	ret

0000000080001824 <user_vm_alloc>:
 * @return
 */
uint64 user_vm_alloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz) {
    char *mem;
    uint64 a;
    if (newsz < oldsz)
    80001824:	06b66763          	bltu	a2,a1,80001892 <user_vm_alloc+0x6e>
uint64 user_vm_alloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz) {
    80001828:	7179                	addi	sp,sp,-48
    8000182a:	f406                	sd	ra,40(sp)
    8000182c:	f022                	sd	s0,32(sp)
    8000182e:	ec26                	sd	s1,24(sp)
    80001830:	e84a                	sd	s2,16(sp)
    80001832:	e44e                	sd	s3,8(sp)
    80001834:	e052                	sd	s4,0(sp)
    80001836:	1800                	addi	s0,sp,48
    80001838:	8a2a                	mv	s4,a0
    8000183a:	89b2                	mv	s3,a2
        return oldsz;

    oldsz = PGROUNDUP(oldsz);
    8000183c:	6905                	lui	s2,0x1
    8000183e:	197d                	addi	s2,s2,-1
    80001840:	992e                	add	s2,s2,a1
    80001842:	77fd                	lui	a5,0xfffff
    80001844:	00f97933          	and	s2,s2,a5
    for (a = oldsz; a < newsz; a += PGSIZE) {
    80001848:	04c97763          	bgeu	s2,a2,80001896 <user_vm_alloc+0x72>
        mem = kalloc();
    8000184c:	00000097          	auipc	ra,0x0
    80001850:	cbe080e7          	jalr	-834(ra) # 8000150a <kalloc>
    80001854:	84aa                	mv	s1,a0
        if (mem == 0) {
    80001856:	c131                	beqz	a0,8000189a <user_vm_alloc+0x76>
//            uvmdealloc(pagetable, a, oldsz);
            // TODO 失败释放
            return 0;
        }
        memset(mem, 0, PGSIZE);
    80001858:	6605                	lui	a2,0x1
    8000185a:	4581                	li	a1,0
    8000185c:	fffff097          	auipc	ra,0xfffff
    80001860:	610080e7          	jalr	1552(ra) # 80000e6c <memset>
        if (mappages(pagetable, a, PGSIZE, (uint64) mem, PTE_W | PTE_X | PTE_R | PTE_U) != 0) {
    80001864:	4779                	li	a4,30
    80001866:	86a6                	mv	a3,s1
    80001868:	6605                	lui	a2,0x1
    8000186a:	85ca                	mv	a1,s2
    8000186c:	8552                	mv	a0,s4
    8000186e:	00000097          	auipc	ra,0x0
    80001872:	dca080e7          	jalr	-566(ra) # 80001638 <mappages>
    80001876:	e519                	bnez	a0,80001884 <user_vm_alloc+0x60>
    for (a = oldsz; a < newsz; a += PGSIZE) {
    80001878:	6785                	lui	a5,0x1
    8000187a:	993e                	add	s2,s2,a5
    8000187c:	fd3968e3          	bltu	s2,s3,8000184c <user_vm_alloc+0x28>
//            uvmdealloc(pagetable, a, oldsz);
            // TODO 失败释放
            return 0;
        }
    }
    return newsz;
    80001880:	854e                	mv	a0,s3
    80001882:	a829                	j	8000189c <user_vm_alloc+0x78>
            kfree(mem);
    80001884:	8526                	mv	a0,s1
    80001886:	00000097          	auipc	ra,0x0
    8000188a:	b86080e7          	jalr	-1146(ra) # 8000140c <kfree>
            return 0;
    8000188e:	4501                	li	a0,0
    80001890:	a031                	j	8000189c <user_vm_alloc+0x78>
        return oldsz;
    80001892:	852e                	mv	a0,a1
}
    80001894:	8082                	ret
    return newsz;
    80001896:	8532                	mv	a0,a2
    80001898:	a011                	j	8000189c <user_vm_alloc+0x78>
            return 0;
    8000189a:	4501                	li	a0,0
}
    8000189c:	70a2                	ld	ra,40(sp)
    8000189e:	7402                	ld	s0,32(sp)
    800018a0:	64e2                	ld	s1,24(sp)
    800018a2:	6942                	ld	s2,16(sp)
    800018a4:	69a2                	ld	s3,8(sp)
    800018a6:	6a02                	ld	s4,0(sp)
    800018a8:	6145                	addi	sp,sp,48
    800018aa:	8082                	ret

00000000800018ac <user_vm_create>:
/**
 * 创建空的用户页表
 * 失败返回0
 * @return
 */
pagetable_t user_vm_create() {
    800018ac:	1101                	addi	sp,sp,-32
    800018ae:	ec06                	sd	ra,24(sp)
    800018b0:	e822                	sd	s0,16(sp)
    800018b2:	e426                	sd	s1,8(sp)
    800018b4:	1000                	addi	s0,sp,32
    pagetable_t pagetable;
    pagetable = (pagetable_t) kalloc();
    800018b6:	00000097          	auipc	ra,0x0
    800018ba:	c54080e7          	jalr	-940(ra) # 8000150a <kalloc>
    800018be:	84aa                	mv	s1,a0
    if (pagetable == 0)
    800018c0:	c519                	beqz	a0,800018ce <user_vm_create+0x22>
        return 0;
    memset(pagetable, 0, PGSIZE);
    800018c2:	6605                	lui	a2,0x1
    800018c4:	4581                	li	a1,0
    800018c6:	fffff097          	auipc	ra,0xfffff
    800018ca:	5a6080e7          	jalr	1446(ra) # 80000e6c <memset>
    return pagetable;
}
    800018ce:	8526                	mv	a0,s1
    800018d0:	60e2                	ld	ra,24(sp)
    800018d2:	6442                	ld	s0,16(sp)
    800018d4:	64a2                	ld	s1,8(sp)
    800018d6:	6105                	addi	sp,sp,32
    800018d8:	8082                	ret

00000000800018da <user_vm_init>:
 * 将用户initcode加载进入pagetable，只在
 * 初始化第一个进程时才会调用该函数，sz必须
 * 小于PGSIZE
 */

void user_vm_init(pagetable_t pagetable, uchar *src, uint sz) {
    800018da:	7179                	addi	sp,sp,-48
    800018dc:	f406                	sd	ra,40(sp)
    800018de:	f022                	sd	s0,32(sp)
    800018e0:	ec26                	sd	s1,24(sp)
    800018e2:	e84a                	sd	s2,16(sp)
    800018e4:	e44e                	sd	s3,8(sp)
    800018e6:	e052                	sd	s4,0(sp)
    800018e8:	1800                	addi	s0,sp,48
    800018ea:	8a2a                	mv	s4,a0
    800018ec:	89ae                	mv	s3,a1
    800018ee:	8932                	mv	s2,a2
    char *mem;

    if (sz >= PGSIZE)
    800018f0:	6785                	lui	a5,0x1
    800018f2:	04f67563          	bgeu	a2,a5,8000193c <user_vm_init+0x62>
        panic("inituvm: more than a page");
    mem = kalloc();
    800018f6:	00000097          	auipc	ra,0x0
    800018fa:	c14080e7          	jalr	-1004(ra) # 8000150a <kalloc>
    800018fe:	84aa                	mv	s1,a0
    memset(mem, 0, PGSIZE);
    80001900:	6605                	lui	a2,0x1
    80001902:	4581                	li	a1,0
    80001904:	fffff097          	auipc	ra,0xfffff
    80001908:	568080e7          	jalr	1384(ra) # 80000e6c <memset>
    mappages(pagetable, 0, PGSIZE, (uint64) mem, PTE_W | PTE_R | PTE_X | PTE_U);
    8000190c:	4779                	li	a4,30
    8000190e:	86a6                	mv	a3,s1
    80001910:	6605                	lui	a2,0x1
    80001912:	4581                	li	a1,0
    80001914:	8552                	mv	a0,s4
    80001916:	00000097          	auipc	ra,0x0
    8000191a:	d22080e7          	jalr	-734(ra) # 80001638 <mappages>
    memmove(mem, src, sz);
    8000191e:	864a                	mv	a2,s2
    80001920:	85ce                	mv	a1,s3
    80001922:	8526                	mv	a0,s1
    80001924:	fffff097          	auipc	ra,0xfffff
    80001928:	56e080e7          	jalr	1390(ra) # 80000e92 <memmove>
}
    8000192c:	70a2                	ld	ra,40(sp)
    8000192e:	7402                	ld	s0,32(sp)
    80001930:	64e2                	ld	s1,24(sp)
    80001932:	6942                	ld	s2,16(sp)
    80001934:	69a2                	ld	s3,8(sp)
    80001936:	6a02                	ld	s4,0(sp)
    80001938:	6145                	addi	sp,sp,48
    8000193a:	8082                	ret
        panic("inituvm: more than a page");
    8000193c:	00004517          	auipc	a0,0x4
    80001940:	84c50513          	addi	a0,a0,-1972 # 80005188 <digits+0x40>
    80001944:	00000097          	auipc	ra,0x0
    80001948:	aac080e7          	jalr	-1364(ra) # 800013f0 <panic>
    8000194c:	b76d                	j	800018f6 <user_vm_init+0x1c>

000000008000194e <copyin>:
 * 从给定的pagetable中，以vsrc为起点向后copy len字节到内核中的dst处。
 * 成功返回0，失败返回-1。
 */
int copyin(pagetable_t pagetable, char *dst, uint64 vsrc, uint64 len) {
    uint64 n, va0, pa0;
    while (len > 0) {
    8000194e:	c6b5                	beqz	a3,800019ba <copyin+0x6c>
int copyin(pagetable_t pagetable, char *dst, uint64 vsrc, uint64 len) {
    80001950:	715d                	addi	sp,sp,-80
    80001952:	e486                	sd	ra,72(sp)
    80001954:	e0a2                	sd	s0,64(sp)
    80001956:	fc26                	sd	s1,56(sp)
    80001958:	f84a                	sd	s2,48(sp)
    8000195a:	f44e                	sd	s3,40(sp)
    8000195c:	f052                	sd	s4,32(sp)
    8000195e:	ec56                	sd	s5,24(sp)
    80001960:	e85a                	sd	s6,16(sp)
    80001962:	e45e                	sd	s7,8(sp)
    80001964:	e062                	sd	s8,0(sp)
    80001966:	0880                	addi	s0,sp,80
    80001968:	8b2a                	mv	s6,a0
    8000196a:	8aae                	mv	s5,a1
    8000196c:	8932                	mv	s2,a2
    8000196e:	89b6                	mv	s3,a3
        va0 = PGROUNDDOWN(vsrc);
    80001970:	7bfd                	lui	s7,0xfffff
        pa0 = walkaddr(pagetable, va0);
        if (pa0 == 0) {
            return -1;
        }
        n = PGSIZE - (vsrc - va0);
    80001972:	6c05                	lui	s8,0x1
    80001974:	a00d                	j	80001996 <copyin+0x48>
        if (n > len) {
            n = len;
        }
        memmove(dst, (void *) (pa0 + (vsrc - va0)), n);
    80001976:	954a                	add	a0,a0,s2
    80001978:	0004861b          	sext.w	a2,s1
    8000197c:	414505b3          	sub	a1,a0,s4
    80001980:	8556                	mv	a0,s5
    80001982:	fffff097          	auipc	ra,0xfffff
    80001986:	510080e7          	jalr	1296(ra) # 80000e92 <memmove>
        len -= n;
    8000198a:	409989b3          	sub	s3,s3,s1
        dst += n;
    8000198e:	9aa6                	add	s5,s5,s1
        vsrc += n;
    80001990:	9926                	add	s2,s2,s1
    while (len > 0) {
    80001992:	02098263          	beqz	s3,800019b6 <copyin+0x68>
        va0 = PGROUNDDOWN(vsrc);
    80001996:	01797a33          	and	s4,s2,s7
        pa0 = walkaddr(pagetable, va0);
    8000199a:	85d2                	mv	a1,s4
    8000199c:	855a                	mv	a0,s6
    8000199e:	00000097          	auipc	ra,0x0
    800019a2:	d38080e7          	jalr	-712(ra) # 800016d6 <walkaddr>
        if (pa0 == 0) {
    800019a6:	cd01                	beqz	a0,800019be <copyin+0x70>
        n = PGSIZE - (vsrc - va0);
    800019a8:	412a04b3          	sub	s1,s4,s2
    800019ac:	94e2                	add	s1,s1,s8
        if (n > len) {
    800019ae:	fc99f4e3          	bgeu	s3,s1,80001976 <copyin+0x28>
    800019b2:	84ce                	mv	s1,s3
    800019b4:	b7c9                	j	80001976 <copyin+0x28>
    }
    return 0;
    800019b6:	4501                	li	a0,0
    800019b8:	a021                	j	800019c0 <copyin+0x72>
    800019ba:	4501                	li	a0,0
}
    800019bc:	8082                	ret
            return -1;
    800019be:	557d                	li	a0,-1
}
    800019c0:	60a6                	ld	ra,72(sp)
    800019c2:	6406                	ld	s0,64(sp)
    800019c4:	74e2                	ld	s1,56(sp)
    800019c6:	7942                	ld	s2,48(sp)
    800019c8:	79a2                	ld	s3,40(sp)
    800019ca:	7a02                	ld	s4,32(sp)
    800019cc:	6ae2                	ld	s5,24(sp)
    800019ce:	6b42                	ld	s6,16(sp)
    800019d0:	6ba2                	ld	s7,8(sp)
    800019d2:	6c02                	ld	s8,0(sp)
    800019d4:	6161                	addi	sp,sp,80
    800019d6:	8082                	ret

00000000800019d8 <copyinstr>:
 */
int copyinstr(pagetable_t pagetable, char *dst, uint64 vsrc, int maxsz) {
    uint64 n, va0, pa0 = 0;
    int got_null = 0;

    while (got_null == 0 && maxsz > 0) {
    800019d8:	0ad05963          	blez	a3,80001a8a <copyinstr+0xb2>
int copyinstr(pagetable_t pagetable, char *dst, uint64 vsrc, int maxsz) {
    800019dc:	715d                	addi	sp,sp,-80
    800019de:	e486                	sd	ra,72(sp)
    800019e0:	e0a2                	sd	s0,64(sp)
    800019e2:	fc26                	sd	s1,56(sp)
    800019e4:	f84a                	sd	s2,48(sp)
    800019e6:	f44e                	sd	s3,40(sp)
    800019e8:	f052                	sd	s4,32(sp)
    800019ea:	ec56                	sd	s5,24(sp)
    800019ec:	e85a                	sd	s6,16(sp)
    800019ee:	e45e                	sd	s7,8(sp)
    800019f0:	0880                	addi	s0,sp,80
    800019f2:	8a2a                	mv	s4,a0
    800019f4:	84ae                	mv	s1,a1
    800019f6:	8bb2                	mv	s7,a2
    800019f8:	8b36                	mv	s6,a3
        va0 = PGROUNDDOWN(vsrc);
    800019fa:	7afd                	lui	s5,0xfffff
        pa0 = walkaddr(pagetable, va0);
        if (pa0 == 0) {
            return -1;
        }
        n = PGSIZE - (vsrc - va0);
    800019fc:	6985                	lui	s3,0x1
    800019fe:	a03d                	j	80001a2c <copyinstr+0x54>
        }
        char *p = (char *) (pa0 + (vsrc - va0));

        while (n > 0) {
            if (*p == 0) {
                *dst = 0;
    80001a00:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001a04:	4785                	li	a5,1
            dst++;
            p++;
        }
        vsrc = va0 + PGSIZE;
    }
    if (got_null) {
    80001a06:	0017b793          	seqz	a5,a5
    80001a0a:	40f00533          	neg	a0,a5
        return 0;
    }
    return -1;
}
    80001a0e:	60a6                	ld	ra,72(sp)
    80001a10:	6406                	ld	s0,64(sp)
    80001a12:	74e2                	ld	s1,56(sp)
    80001a14:	7942                	ld	s2,48(sp)
    80001a16:	79a2                	ld	s3,40(sp)
    80001a18:	7a02                	ld	s4,32(sp)
    80001a1a:	6ae2                	ld	s5,24(sp)
    80001a1c:	6b42                	ld	s6,16(sp)
    80001a1e:	6ba2                	ld	s7,8(sp)
    80001a20:	6161                	addi	sp,sp,80
    80001a22:	8082                	ret
        vsrc = va0 + PGSIZE;
    80001a24:	01390bb3          	add	s7,s2,s3
    while (got_null == 0 && maxsz > 0) {
    80001a28:	05605d63          	blez	s6,80001a82 <copyinstr+0xaa>
        va0 = PGROUNDDOWN(vsrc);
    80001a2c:	015bf933          	and	s2,s7,s5
        pa0 = walkaddr(pagetable, va0);
    80001a30:	85ca                	mv	a1,s2
    80001a32:	8552                	mv	a0,s4
    80001a34:	00000097          	auipc	ra,0x0
    80001a38:	ca2080e7          	jalr	-862(ra) # 800016d6 <walkaddr>
        if (pa0 == 0) {
    80001a3c:	c529                	beqz	a0,80001a86 <copyinstr+0xae>
        n = PGSIZE - (vsrc - va0);
    80001a3e:	417907b3          	sub	a5,s2,s7
    80001a42:	97ce                	add	a5,a5,s3
        if (n > maxsz) {
    80001a44:	885a                	mv	a6,s6
    80001a46:	0167f363          	bgeu	a5,s6,80001a4c <copyinstr+0x74>
    80001a4a:	883e                	mv	a6,a5
        char *p = (char *) (pa0 + (vsrc - va0));
    80001a4c:	955e                	add	a0,a0,s7
    80001a4e:	41250533          	sub	a0,a0,s2
        while (n > 0) {
    80001a52:	fc0809e3          	beqz	a6,80001a24 <copyinstr+0x4c>
    80001a56:	9826                	add	a6,a6,s1
    80001a58:	87a6                	mv	a5,s1
            if (*p == 0) {
    80001a5a:	40950633          	sub	a2,a0,s1
    80001a5e:	009b04bb          	addw	s1,s6,s1
    80001a62:	fff4859b          	addiw	a1,s1,-1
    80001a66:	00c78733          	add	a4,a5,a2
    80001a6a:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ff525d0>
    80001a6e:	db49                	beqz	a4,80001a00 <copyinstr+0x28>
                *dst = *p;
    80001a70:	00e78023          	sb	a4,0(a5)
            maxsz--;
    80001a74:	40f58b3b          	subw	s6,a1,a5
            dst++;
    80001a78:	0785                	addi	a5,a5,1
        while (n > 0) {
    80001a7a:	ff0796e3          	bne	a5,a6,80001a66 <copyinstr+0x8e>
            dst++;
    80001a7e:	84c2                	mv	s1,a6
    80001a80:	b755                	j	80001a24 <copyinstr+0x4c>
    80001a82:	4781                	li	a5,0
    80001a84:	b749                	j	80001a06 <copyinstr+0x2e>
            return -1;
    80001a86:	557d                	li	a0,-1
    80001a88:	b759                	j	80001a0e <copyinstr+0x36>
    int got_null = 0;
    80001a8a:	4781                	li	a5,0
    if (got_null) {
    80001a8c:	0017b793          	seqz	a5,a5
    80001a90:	40f00533          	neg	a0,a5
}
    80001a94:	8082                	ret

0000000080001a96 <copyout>:
 * @param len copy长度
 * @return 成功返回0，失败返回-1
 */
int copyout(pagetable_t pagetable, uint64 vdst, char *src, int len) {
    uint64 n, va0, pa0;
    while (len > 0) {
    80001a96:	06d05863          	blez	a3,80001b06 <copyout+0x70>
int copyout(pagetable_t pagetable, uint64 vdst, char *src, int len) {
    80001a9a:	715d                	addi	sp,sp,-80
    80001a9c:	e486                	sd	ra,72(sp)
    80001a9e:	e0a2                	sd	s0,64(sp)
    80001aa0:	fc26                	sd	s1,56(sp)
    80001aa2:	f84a                	sd	s2,48(sp)
    80001aa4:	f44e                	sd	s3,40(sp)
    80001aa6:	f052                	sd	s4,32(sp)
    80001aa8:	ec56                	sd	s5,24(sp)
    80001aaa:	e85a                	sd	s6,16(sp)
    80001aac:	e45e                	sd	s7,8(sp)
    80001aae:	e062                	sd	s8,0(sp)
    80001ab0:	0880                	addi	s0,sp,80
    80001ab2:	8b2a                	mv	s6,a0
    80001ab4:	89ae                	mv	s3,a1
    80001ab6:	8ab2                	mv	s5,a2
    80001ab8:	8936                	mv	s2,a3
        va0 = PGROUNDDOWN(vdst);
    80001aba:	7bfd                	lui	s7,0xfffff
        pa0 = walkaddr(pagetable, va0);
        if (pa0 == 0) {
            return -1;
        }
        n = PGSIZE - (vdst - va0);
    80001abc:	6c05                	lui	s8,0x1
    80001abe:	a00d                	j	80001ae0 <copyout+0x4a>
        if (n > len) {
            n = len;
        }
        memmove((void *) (pa0 + (vdst - va0)), src, n);
    80001ac0:	954e                	add	a0,a0,s3
    80001ac2:	0004861b          	sext.w	a2,s1
    80001ac6:	85d6                	mv	a1,s5
    80001ac8:	41450533          	sub	a0,a0,s4
    80001acc:	fffff097          	auipc	ra,0xfffff
    80001ad0:	3c6080e7          	jalr	966(ra) # 80000e92 <memmove>
        len -= n;
    80001ad4:	4099093b          	subw	s2,s2,s1
        vdst += n;
    80001ad8:	99a6                	add	s3,s3,s1
        src += n;
    80001ada:	9aa6                	add	s5,s5,s1
    while (len > 0) {
    80001adc:	03205363          	blez	s2,80001b02 <copyout+0x6c>
        va0 = PGROUNDDOWN(vdst);
    80001ae0:	0179fa33          	and	s4,s3,s7
        pa0 = walkaddr(pagetable, va0);
    80001ae4:	85d2                	mv	a1,s4
    80001ae6:	855a                	mv	a0,s6
    80001ae8:	00000097          	auipc	ra,0x0
    80001aec:	bee080e7          	jalr	-1042(ra) # 800016d6 <walkaddr>
        if (pa0 == 0) {
    80001af0:	cd09                	beqz	a0,80001b0a <copyout+0x74>
        n = PGSIZE - (vdst - va0);
    80001af2:	413a07b3          	sub	a5,s4,s3
    80001af6:	97e2                	add	a5,a5,s8
        if (n > len) {
    80001af8:	84ca                	mv	s1,s2
    80001afa:	fd27f3e3          	bgeu	a5,s2,80001ac0 <copyout+0x2a>
    80001afe:	84be                	mv	s1,a5
    80001b00:	b7c1                	j	80001ac0 <copyout+0x2a>
    }
    return 0;
    80001b02:	4501                	li	a0,0
    80001b04:	a021                	j	80001b0c <copyout+0x76>
    80001b06:	4501                	li	a0,0
}
    80001b08:	8082                	ret
            return -1;
    80001b0a:	557d                	li	a0,-1
}
    80001b0c:	60a6                	ld	ra,72(sp)
    80001b0e:	6406                	ld	s0,64(sp)
    80001b10:	74e2                	ld	s1,56(sp)
    80001b12:	7942                	ld	s2,48(sp)
    80001b14:	79a2                	ld	s3,40(sp)
    80001b16:	7a02                	ld	s4,32(sp)
    80001b18:	6ae2                	ld	s5,24(sp)
    80001b1a:	6b42                	ld	s6,16(sp)
    80001b1c:	6ba2                	ld	s7,8(sp)
    80001b1e:	6c02                	ld	s8,0(sp)
    80001b20:	6161                	addi	sp,sp,80
    80001b22:	8082                	ret

0000000080001b24 <user_vm_copy>:
int user_vm_copy(pagetable_t old, pagetable_t new, int sz) {
    pte_t *pte;
    uint64 pa;
    uint flags;
    char *mem;
    for (int i = 0; i < sz; i += PGSIZE) {
    80001b24:	10c05663          	blez	a2,80001c30 <user_vm_copy+0x10c>
int user_vm_copy(pagetable_t old, pagetable_t new, int sz) {
    80001b28:	7159                	addi	sp,sp,-112
    80001b2a:	f486                	sd	ra,104(sp)
    80001b2c:	f0a2                	sd	s0,96(sp)
    80001b2e:	eca6                	sd	s1,88(sp)
    80001b30:	e8ca                	sd	s2,80(sp)
    80001b32:	e4ce                	sd	s3,72(sp)
    80001b34:	e0d2                	sd	s4,64(sp)
    80001b36:	fc56                	sd	s5,56(sp)
    80001b38:	f85a                	sd	s6,48(sp)
    80001b3a:	f45e                	sd	s7,40(sp)
    80001b3c:	f062                	sd	s8,32(sp)
    80001b3e:	ec66                	sd	s9,24(sp)
    80001b40:	e86a                	sd	s10,16(sp)
    80001b42:	e46e                	sd	s11,8(sp)
    80001b44:	1880                	addi	s0,sp,112
    80001b46:	8a2a                	mv	s4,a0
    80001b48:	8aae                	mv	s5,a1
    80001b4a:	fff6099b          	addiw	s3,a2,-1
    80001b4e:	00c9d99b          	srliw	s3,s3,0xc
    80001b52:	0985                	addi	s3,s3,1
    80001b54:	09b2                	slli	s3,s3,0xc
    for (int i = 0; i < sz; i += PGSIZE) {
    80001b56:	4901                	li	s2,0
        if ((pte = walk(old, i, 0)) == 0) {
            panic("user_vm_copy: pte not present");
    80001b58:	00003c97          	auipc	s9,0x3
    80001b5c:	650c8c93          	addi	s9,s9,1616 # 800051a8 <digits+0x60>
        }
        if ((*pte & PTE_V) == 0) {
            panic("user_vm_copy: pte invalid");
    80001b60:	00003b17          	auipc	s6,0x3
    80001b64:	668b0b13          	addi	s6,s6,1640 # 800051c8 <digits+0x80>
        }
        pa = PTE2PA(*pte);
        flags = PTE_FLAGS(*pte);

        if ((mem = kalloc()) == 0) {
            panic("user_vm_copy: alloc mem fail");
    80001b68:	00003c17          	auipc	s8,0x3
    80001b6c:	680c0c13          	addi	s8,s8,1664 # 800051e8 <digits+0xa0>
        }
        memmove(mem, (void *) pa, PGSIZE);
        if (mappages(new, i, PGSIZE, (uint64) mem, flags) < 0) {
            kfree(mem);
            panic("user_vm_copy: mappages fail");
    80001b70:	00003b97          	auipc	s7,0x3
    80001b74:	698b8b93          	addi	s7,s7,1688 # 80005208 <digits+0xc0>
    80001b78:	a8b1                	j	80001bd4 <user_vm_copy+0xb0>
            panic("user_vm_copy: pte not present");
    80001b7a:	8566                	mv	a0,s9
    80001b7c:	00000097          	auipc	ra,0x0
    80001b80:	874080e7          	jalr	-1932(ra) # 800013f0 <panic>
    80001b84:	a08d                	j	80001be6 <user_vm_copy+0xc2>
            panic("user_vm_copy: pte invalid");
    80001b86:	855a                	mv	a0,s6
    80001b88:	00000097          	auipc	ra,0x0
    80001b8c:	868080e7          	jalr	-1944(ra) # 800013f0 <panic>
        pa = PTE2PA(*pte);
    80001b90:	6098                	ld	a4,0(s1)
    80001b92:	00a75d13          	srli	s10,a4,0xa
    80001b96:	0d32                	slli	s10,s10,0xc
        flags = PTE_FLAGS(*pte);
    80001b98:	3ff77d93          	andi	s11,a4,1023
        if ((mem = kalloc()) == 0) {
    80001b9c:	00000097          	auipc	ra,0x0
    80001ba0:	96e080e7          	jalr	-1682(ra) # 8000150a <kalloc>
    80001ba4:	84aa                	mv	s1,a0
    80001ba6:	c521                	beqz	a0,80001bee <user_vm_copy+0xca>
        memmove(mem, (void *) pa, PGSIZE);
    80001ba8:	6605                	lui	a2,0x1
    80001baa:	85ea                	mv	a1,s10
    80001bac:	8526                	mv	a0,s1
    80001bae:	fffff097          	auipc	ra,0xfffff
    80001bb2:	2e4080e7          	jalr	740(ra) # 80000e92 <memmove>
        if (mappages(new, i, PGSIZE, (uint64) mem, flags) < 0) {
    80001bb6:	876e                	mv	a4,s11
    80001bb8:	86a6                	mv	a3,s1
    80001bba:	6605                	lui	a2,0x1
    80001bbc:	85ca                	mv	a1,s2
    80001bbe:	8556                	mv	a0,s5
    80001bc0:	00000097          	auipc	ra,0x0
    80001bc4:	a78080e7          	jalr	-1416(ra) # 80001638 <mappages>
    80001bc8:	02054963          	bltz	a0,80001bfa <user_vm_copy+0xd6>
    for (int i = 0; i < sz; i += PGSIZE) {
    80001bcc:	6785                	lui	a5,0x1
    80001bce:	993e                	add	s2,s2,a5
    80001bd0:	05390063          	beq	s2,s3,80001c10 <user_vm_copy+0xec>
        if ((pte = walk(old, i, 0)) == 0) {
    80001bd4:	4601                	li	a2,0
    80001bd6:	85ca                	mv	a1,s2
    80001bd8:	8552                	mv	a0,s4
    80001bda:	00000097          	auipc	ra,0x0
    80001bde:	9b4080e7          	jalr	-1612(ra) # 8000158e <walk>
    80001be2:	84aa                	mv	s1,a0
    80001be4:	d959                	beqz	a0,80001b7a <user_vm_copy+0x56>
        if ((*pte & PTE_V) == 0) {
    80001be6:	609c                	ld	a5,0(s1)
    80001be8:	8b85                	andi	a5,a5,1
    80001bea:	f3dd                	bnez	a5,80001b90 <user_vm_copy+0x6c>
    80001bec:	bf69                	j	80001b86 <user_vm_copy+0x62>
            panic("user_vm_copy: alloc mem fail");
    80001bee:	8562                	mv	a0,s8
    80001bf0:	00000097          	auipc	ra,0x0
    80001bf4:	800080e7          	jalr	-2048(ra) # 800013f0 <panic>
    80001bf8:	bf45                	j	80001ba8 <user_vm_copy+0x84>
            kfree(mem);
    80001bfa:	8526                	mv	a0,s1
    80001bfc:	00000097          	auipc	ra,0x0
    80001c00:	810080e7          	jalr	-2032(ra) # 8000140c <kfree>
            panic("user_vm_copy: mappages fail");
    80001c04:	855e                	mv	a0,s7
    80001c06:	fffff097          	auipc	ra,0xfffff
    80001c0a:	7ea080e7          	jalr	2026(ra) # 800013f0 <panic>
    80001c0e:	bf7d                	j	80001bcc <user_vm_copy+0xa8>
        }
    }
    return 0;
}
    80001c10:	4501                	li	a0,0
    80001c12:	70a6                	ld	ra,104(sp)
    80001c14:	7406                	ld	s0,96(sp)
    80001c16:	64e6                	ld	s1,88(sp)
    80001c18:	6946                	ld	s2,80(sp)
    80001c1a:	69a6                	ld	s3,72(sp)
    80001c1c:	6a06                	ld	s4,64(sp)
    80001c1e:	7ae2                	ld	s5,56(sp)
    80001c20:	7b42                	ld	s6,48(sp)
    80001c22:	7ba2                	ld	s7,40(sp)
    80001c24:	7c02                	ld	s8,32(sp)
    80001c26:	6ce2                	ld	s9,24(sp)
    80001c28:	6d42                	ld	s10,16(sp)
    80001c2a:	6da2                	ld	s11,8(sp)
    80001c2c:	6165                	addi	sp,sp,112
    80001c2e:	8082                	ret
    80001c30:	4501                	li	a0,0
    80001c32:	8082                	ret

0000000080001c34 <vmprint>:

void vmprint(pagetable_t pagetable, int n) {
    80001c34:	711d                	addi	sp,sp,-96
    80001c36:	ec86                	sd	ra,88(sp)
    80001c38:	e8a2                	sd	s0,80(sp)
    80001c3a:	e4a6                	sd	s1,72(sp)
    80001c3c:	e0ca                	sd	s2,64(sp)
    80001c3e:	fc4e                	sd	s3,56(sp)
    80001c40:	f852                	sd	s4,48(sp)
    80001c42:	f456                	sd	s5,40(sp)
    80001c44:	f05a                	sd	s6,32(sp)
    80001c46:	ec5e                	sd	s7,24(sp)
    80001c48:	e862                	sd	s8,16(sp)
    80001c4a:	e466                	sd	s9,8(sp)
    80001c4c:	e06a                	sd	s10,0(sp)
    80001c4e:	1080                	addi	s0,sp,96
    80001c50:	892a                	mv	s2,a0
    80001c52:	8c2e                	mv	s8,a1
    if (n == 1) {
    80001c54:	4785                	li	a5,1
    80001c56:	02f58463          	beq	a1,a5,80001c7e <vmprint+0x4a>
        printf("page table %p\n", pagetable);
    }
    if (n >= 4) {
    80001c5a:	478d                	li	a5,3
    80001c5c:	08b7c163          	blt	a5,a1,80001cde <vmprint+0xaa>
        return;
    }
    for (int i = 0; i < 512; i++) {
    80001c60:	4481                	li	s1,0
        if (pte & PTE_V) {
            for (int j = 1; j <= n; j++) {
                printf(".. ");
            }
            uint64 child = PTE2PA(pte);
            printf("%d: pte %p pa %p\n", i, pte, child);
    80001c62:	00003c97          	auipc	s9,0x3
    80001c66:	5dec8c93          	addi	s9,s9,1502 # 80005240 <digits+0xf8>
            vmprint((pagetable_t) child, n + 1);
    80001c6a:	001c0a9b          	addiw	s5,s8,1
            for (int j = 1; j <= n; j++) {
    80001c6e:	4d05                	li	s10,1
                printf(".. ");
    80001c70:	00003b97          	auipc	s7,0x3
    80001c74:	5c8b8b93          	addi	s7,s7,1480 # 80005238 <digits+0xf0>
    for (int i = 0; i < 512; i++) {
    80001c78:	20000b13          	li	s6,512
    80001c7c:	a081                	j	80001cbc <vmprint+0x88>
        printf("page table %p\n", pagetable);
    80001c7e:	85aa                	mv	a1,a0
    80001c80:	00003517          	auipc	a0,0x3
    80001c84:	5a850513          	addi	a0,a0,1448 # 80005228 <digits+0xe0>
    80001c88:	fffff097          	auipc	ra,0xfffff
    80001c8c:	6a4080e7          	jalr	1700(ra) # 8000132c <printf>
    if (n >= 4) {
    80001c90:	bfc1                	j	80001c60 <vmprint+0x2c>
            uint64 child = PTE2PA(pte);
    80001c92:	00aa5993          	srli	s3,s4,0xa
    80001c96:	09b2                	slli	s3,s3,0xc
            printf("%d: pte %p pa %p\n", i, pte, child);
    80001c98:	86ce                	mv	a3,s3
    80001c9a:	8652                	mv	a2,s4
    80001c9c:	85a6                	mv	a1,s1
    80001c9e:	8566                	mv	a0,s9
    80001ca0:	fffff097          	auipc	ra,0xfffff
    80001ca4:	68c080e7          	jalr	1676(ra) # 8000132c <printf>
            vmprint((pagetable_t) child, n + 1);
    80001ca8:	85d6                	mv	a1,s5
    80001caa:	854e                	mv	a0,s3
    80001cac:	00000097          	auipc	ra,0x0
    80001cb0:	f88080e7          	jalr	-120(ra) # 80001c34 <vmprint>
    for (int i = 0; i < 512; i++) {
    80001cb4:	2485                	addiw	s1,s1,1
    80001cb6:	0921                	addi	s2,s2,8
    80001cb8:	03648363          	beq	s1,s6,80001cde <vmprint+0xaa>
        pte_t pte = pagetable[i];
    80001cbc:	00093a03          	ld	s4,0(s2) # 1000 <_entry-0x7ffff000>
        if (pte & PTE_V) {
    80001cc0:	001a7793          	andi	a5,s4,1
    80001cc4:	dbe5                	beqz	a5,80001cb4 <vmprint+0x80>
            for (int j = 1; j <= n; j++) {
    80001cc6:	fd8056e3          	blez	s8,80001c92 <vmprint+0x5e>
    80001cca:	89ea                	mv	s3,s10
                printf(".. ");
    80001ccc:	855e                	mv	a0,s7
    80001cce:	fffff097          	auipc	ra,0xfffff
    80001cd2:	65e080e7          	jalr	1630(ra) # 8000132c <printf>
            for (int j = 1; j <= n; j++) {
    80001cd6:	2985                	addiw	s3,s3,1
    80001cd8:	ff3a9ae3          	bne	s5,s3,80001ccc <vmprint+0x98>
    80001cdc:	bf5d                	j	80001c92 <vmprint+0x5e>
        }
    }
    80001cde:	60e6                	ld	ra,88(sp)
    80001ce0:	6446                	ld	s0,80(sp)
    80001ce2:	64a6                	ld	s1,72(sp)
    80001ce4:	6906                	ld	s2,64(sp)
    80001ce6:	79e2                	ld	s3,56(sp)
    80001ce8:	7a42                	ld	s4,48(sp)
    80001cea:	7aa2                	ld	s5,40(sp)
    80001cec:	7b02                	ld	s6,32(sp)
    80001cee:	6be2                	ld	s7,24(sp)
    80001cf0:	6c42                	ld	s8,16(sp)
    80001cf2:	6ca2                	ld	s9,8(sp)
    80001cf4:	6d02                	ld	s10,0(sp)
    80001cf6:	6125                	addi	sp,sp,96
    80001cf8:	8082                	ret

0000000080001cfa <free_desc>:
    return -1;
}

// mark a descriptor as free.
static void
free_desc(int i) {
    80001cfa:	1101                	addi	sp,sp,-32
    80001cfc:	ec06                	sd	ra,24(sp)
    80001cfe:	e822                	sd	s0,16(sp)
    80001d00:	e426                	sd	s1,8(sp)
    80001d02:	1000                	addi	s0,sp,32
    80001d04:	84aa                	mv	s1,a0
    if (i >= NUM)
    80001d06:	479d                	li	a5,7
    80001d08:	06a7ca63          	blt	a5,a0,80001d7c <free_desc+0x82>
        panic("free_desc 1");
    if (disk.free[i])
    80001d0c:	0008b797          	auipc	a5,0x8b
    80001d10:	2f478793          	addi	a5,a5,756 # 8008d000 <disk>
    80001d14:	00978733          	add	a4,a5,s1
    80001d18:	6789                	lui	a5,0x2
    80001d1a:	97ba                	add	a5,a5,a4
    80001d1c:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80001d20:	e7bd                	bnez	a5,80001d8e <free_desc+0x94>
        panic("free_desc 2");
    disk.desc[i].addr = 0;
    80001d22:	00449793          	slli	a5,s1,0x4
    80001d26:	0008d717          	auipc	a4,0x8d
    80001d2a:	2da70713          	addi	a4,a4,730 # 8008f000 <disk+0x2000>
    80001d2e:	6314                	ld	a3,0(a4)
    80001d30:	96be                	add	a3,a3,a5
    80001d32:	0006b023          	sd	zero,0(a3)
    disk.desc[i].len = 0;
    80001d36:	6314                	ld	a3,0(a4)
    80001d38:	96be                	add	a3,a3,a5
    80001d3a:	0006a423          	sw	zero,8(a3)
    disk.desc[i].flags = 0;
    80001d3e:	6314                	ld	a3,0(a4)
    80001d40:	96be                	add	a3,a3,a5
    80001d42:	00069623          	sh	zero,12(a3)
    disk.desc[i].next = 0;
    80001d46:	6318                	ld	a4,0(a4)
    80001d48:	97ba                	add	a5,a5,a4
    80001d4a:	00079723          	sh	zero,14(a5)
    disk.free[i] = 1;
    80001d4e:	0008b517          	auipc	a0,0x8b
    80001d52:	2b250513          	addi	a0,a0,690 # 8008d000 <disk>
    80001d56:	9526                	add	a0,a0,s1
    80001d58:	6489                	lui	s1,0x2
    80001d5a:	94aa                	add	s1,s1,a0
    80001d5c:	4785                	li	a5,1
    80001d5e:	00f48c23          	sb	a5,24(s1) # 2018 <_entry-0x7fffdfe8>
    wakeup(&disk.free[0]);
    80001d62:	0008d517          	auipc	a0,0x8d
    80001d66:	2b650513          	addi	a0,a0,694 # 8008f018 <disk+0x2018>
    80001d6a:	fffff097          	auipc	ra,0xfffff
    80001d6e:	d24080e7          	jalr	-732(ra) # 80000a8e <wakeup>
}
    80001d72:	60e2                	ld	ra,24(sp)
    80001d74:	6442                	ld	s0,16(sp)
    80001d76:	64a2                	ld	s1,8(sp)
    80001d78:	6105                	addi	sp,sp,32
    80001d7a:	8082                	ret
        panic("free_desc 1");
    80001d7c:	00003517          	auipc	a0,0x3
    80001d80:	4dc50513          	addi	a0,a0,1244 # 80005258 <digits+0x110>
    80001d84:	fffff097          	auipc	ra,0xfffff
    80001d88:	66c080e7          	jalr	1644(ra) # 800013f0 <panic>
    80001d8c:	b741                	j	80001d0c <free_desc+0x12>
        panic("free_desc 2");
    80001d8e:	00003517          	auipc	a0,0x3
    80001d92:	4da50513          	addi	a0,a0,1242 # 80005268 <digits+0x120>
    80001d96:	fffff097          	auipc	ra,0xfffff
    80001d9a:	65a080e7          	jalr	1626(ra) # 800013f0 <panic>
    80001d9e:	b751                	j	80001d22 <free_desc+0x28>

0000000080001da0 <virtio_disk_init>:
virtio_disk_init(void) {
    80001da0:	1101                	addi	sp,sp,-32
    80001da2:	ec06                	sd	ra,24(sp)
    80001da4:	e822                	sd	s0,16(sp)
    80001da6:	e426                	sd	s1,8(sp)
    80001da8:	1000                	addi	s0,sp,32
    spinlock_init(&disk.vdisk_lock, "virtio_disk");
    80001daa:	00003597          	auipc	a1,0x3
    80001dae:	4ce58593          	addi	a1,a1,1230 # 80005278 <digits+0x130>
    80001db2:	0008d517          	auipc	a0,0x8d
    80001db6:	37650513          	addi	a0,a0,886 # 8008f128 <disk+0x2128>
    80001dba:	00001097          	auipc	ra,0x1
    80001dbe:	680080e7          	jalr	1664(ra) # 8000343a <spinlock_init>
    if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80001dc2:	100017b7          	lui	a5,0x10001
    80001dc6:	4398                	lw	a4,0(a5)
    80001dc8:	2701                	sext.w	a4,a4
    80001dca:	747277b7          	lui	a5,0x74727
    80001dce:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80001dd2:	00f71963          	bne	a4,a5,80001de4 <virtio_disk_init+0x44>
        *R(VIRTIO_MMIO_VERSION) != 1 ||
    80001dd6:	100017b7          	lui	a5,0x10001
    80001dda:	43dc                	lw	a5,4(a5)
    80001ddc:	2781                	sext.w	a5,a5
    if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80001dde:	4705                	li	a4,1
    80001de0:	0ce78163          	beq	a5,a4,80001ea2 <virtio_disk_init+0x102>
        panic("could not find virtio disk");
    80001de4:	00003517          	auipc	a0,0x3
    80001de8:	4a450513          	addi	a0,a0,1188 # 80005288 <digits+0x140>
    80001dec:	fffff097          	auipc	ra,0xfffff
    80001df0:	604080e7          	jalr	1540(ra) # 800013f0 <panic>
    *R(VIRTIO_MMIO_STATUS) = status;
    80001df4:	100017b7          	lui	a5,0x10001
    80001df8:	4705                	li	a4,1
    80001dfa:	dbb8                	sw	a4,112(a5)
    *R(VIRTIO_MMIO_STATUS) = status;
    80001dfc:	470d                	li	a4,3
    80001dfe:	dbb8                	sw	a4,112(a5)
    uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80001e00:	4b94                	lw	a3,16(a5)
    features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80001e02:	c7ffe737          	lui	a4,0xc7ffe
    80001e06:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47f51d2f>
    80001e0a:	8f75                	and	a4,a4,a3
    *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80001e0c:	2701                	sext.w	a4,a4
    80001e0e:	d398                	sw	a4,32(a5)
    *R(VIRTIO_MMIO_STATUS) = status;
    80001e10:	472d                	li	a4,11
    80001e12:	dbb8                	sw	a4,112(a5)
    *R(VIRTIO_MMIO_STATUS) = status;
    80001e14:	473d                	li	a4,15
    80001e16:	dbb8                	sw	a4,112(a5)
    *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80001e18:	6705                	lui	a4,0x1
    80001e1a:	d798                	sw	a4,40(a5)
    *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80001e1c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
    uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80001e20:	5bdc                	lw	a5,52(a5)
    80001e22:	2781                	sext.w	a5,a5
    if (max == 0)
    80001e24:	c3cd                	beqz	a5,80001ec6 <virtio_disk_init+0x126>
    if (max < NUM)
    80001e26:	471d                	li	a4,7
    80001e28:	0af77763          	bgeu	a4,a5,80001ed6 <virtio_disk_init+0x136>
    *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80001e2c:	100014b7          	lui	s1,0x10001
    80001e30:	47a1                	li	a5,8
    80001e32:	dc9c                	sw	a5,56(s1)
    memset(disk.pages, 0, sizeof(disk.pages));
    80001e34:	6609                	lui	a2,0x2
    80001e36:	4581                	li	a1,0
    80001e38:	0008b517          	auipc	a0,0x8b
    80001e3c:	1c850513          	addi	a0,a0,456 # 8008d000 <disk>
    80001e40:	fffff097          	auipc	ra,0xfffff
    80001e44:	02c080e7          	jalr	44(ra) # 80000e6c <memset>
    *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64) disk.pages) >> PGSHIFT;
    80001e48:	0008b717          	auipc	a4,0x8b
    80001e4c:	1b870713          	addi	a4,a4,440 # 8008d000 <disk>
    80001e50:	00c75793          	srli	a5,a4,0xc
    80001e54:	2781                	sext.w	a5,a5
    80001e56:	c0bc                	sw	a5,64(s1)
    disk.desc = (struct virtq_desc *) disk.pages;
    80001e58:	0008d797          	auipc	a5,0x8d
    80001e5c:	1a878793          	addi	a5,a5,424 # 8008f000 <disk+0x2000>
    80001e60:	e398                	sd	a4,0(a5)
    disk.avail = (struct virtq_avail *) (disk.pages + NUM * sizeof(struct virtq_desc));
    80001e62:	0008b717          	auipc	a4,0x8b
    80001e66:	21e70713          	addi	a4,a4,542 # 8008d080 <disk+0x80>
    80001e6a:	e798                	sd	a4,8(a5)
    disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80001e6c:	0008c717          	auipc	a4,0x8c
    80001e70:	19470713          	addi	a4,a4,404 # 8008e000 <disk+0x1000>
    80001e74:	eb98                	sd	a4,16(a5)
        disk.free[i] = 1;
    80001e76:	4705                	li	a4,1
    80001e78:	00e78c23          	sb	a4,24(a5)
    80001e7c:	00e78ca3          	sb	a4,25(a5)
    80001e80:	00e78d23          	sb	a4,26(a5)
    80001e84:	00e78da3          	sb	a4,27(a5)
    80001e88:	00e78e23          	sb	a4,28(a5)
    80001e8c:	00e78ea3          	sb	a4,29(a5)
    80001e90:	00e78f23          	sb	a4,30(a5)
    80001e94:	00e78fa3          	sb	a4,31(a5)
}
    80001e98:	60e2                	ld	ra,24(sp)
    80001e9a:	6442                	ld	s0,16(sp)
    80001e9c:	64a2                	ld	s1,8(sp)
    80001e9e:	6105                	addi	sp,sp,32
    80001ea0:	8082                	ret
        *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80001ea2:	100017b7          	lui	a5,0x10001
    80001ea6:	479c                	lw	a5,8(a5)
    80001ea8:	2781                	sext.w	a5,a5
        *R(VIRTIO_MMIO_VERSION) != 1 ||
    80001eaa:	4709                	li	a4,2
    80001eac:	f2e79ce3          	bne	a5,a4,80001de4 <virtio_disk_init+0x44>
        *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    80001eb0:	100017b7          	lui	a5,0x10001
    80001eb4:	47d8                	lw	a4,12(a5)
    80001eb6:	2701                	sext.w	a4,a4
        *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80001eb8:	554d47b7          	lui	a5,0x554d4
    80001ebc:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80001ec0:	f2f712e3          	bne	a4,a5,80001de4 <virtio_disk_init+0x44>
    80001ec4:	bf05                	j	80001df4 <virtio_disk_init+0x54>
        panic("virtio disk has no queue 0");
    80001ec6:	00003517          	auipc	a0,0x3
    80001eca:	3e250513          	addi	a0,a0,994 # 800052a8 <digits+0x160>
    80001ece:	fffff097          	auipc	ra,0xfffff
    80001ed2:	522080e7          	jalr	1314(ra) # 800013f0 <panic>
        panic("virtio disk max queue too short");
    80001ed6:	00003517          	auipc	a0,0x3
    80001eda:	3f250513          	addi	a0,a0,1010 # 800052c8 <digits+0x180>
    80001ede:	fffff097          	auipc	ra,0xfffff
    80001ee2:	512080e7          	jalr	1298(ra) # 800013f0 <panic>
    80001ee6:	b799                	j	80001e2c <virtio_disk_init+0x8c>

0000000080001ee8 <virtio_disk_rw>:
    }
    return 0;
}

void
virtio_disk_rw(struct buf *b, int write) {
    80001ee8:	7159                	addi	sp,sp,-112
    80001eea:	f486                	sd	ra,104(sp)
    80001eec:	f0a2                	sd	s0,96(sp)
    80001eee:	eca6                	sd	s1,88(sp)
    80001ef0:	e8ca                	sd	s2,80(sp)
    80001ef2:	e4ce                	sd	s3,72(sp)
    80001ef4:	e0d2                	sd	s4,64(sp)
    80001ef6:	fc56                	sd	s5,56(sp)
    80001ef8:	f85a                	sd	s6,48(sp)
    80001efa:	f45e                	sd	s7,40(sp)
    80001efc:	f062                	sd	s8,32(sp)
    80001efe:	ec66                	sd	s9,24(sp)
    80001f00:	e86a                	sd	s10,16(sp)
    80001f02:	1880                	addi	s0,sp,112
    80001f04:	892a                	mv	s2,a0
    80001f06:	8d2e                	mv	s10,a1
    uint64 sector = b->blockno * (BSIZE / 512);
    80001f08:	00c52c83          	lw	s9,12(a0)
    80001f0c:	001c9c9b          	slliw	s9,s9,0x1
    80001f10:	1c82                	slli	s9,s9,0x20
    80001f12:	020cdc93          	srli	s9,s9,0x20
    spin_lock(&disk.vdisk_lock);
    80001f16:	0008d517          	auipc	a0,0x8d
    80001f1a:	21250513          	addi	a0,a0,530 # 8008f128 <disk+0x2128>
    80001f1e:	00001097          	auipc	ra,0x1
    80001f22:	5ac080e7          	jalr	1452(ra) # 800034ca <spin_lock>
    for (int i = 0; i < 3; i++) {
    80001f26:	4981                	li	s3,0
    for (int i = 0; i < NUM; i++) {
    80001f28:	4c21                	li	s8,8
            disk.free[i] = 0;
    80001f2a:	0008bb97          	auipc	s7,0x8b
    80001f2e:	0d6b8b93          	addi	s7,s7,214 # 8008d000 <disk>
    80001f32:	6b09                	lui	s6,0x2
    for (int i = 0; i < 3; i++) {
    80001f34:	4a8d                	li	s5,3
    for (int i = 0; i < NUM; i++) {
    80001f36:	8a4e                	mv	s4,s3
    80001f38:	a051                	j	80001fbc <virtio_disk_rw+0xd4>
            disk.free[i] = 0;
    80001f3a:	00fb86b3          	add	a3,s7,a5
    80001f3e:	96da                	add	a3,a3,s6
    80001f40:	00068c23          	sb	zero,24(a3)
        idx[i] = alloc_desc();
    80001f44:	c21c                	sw	a5,0(a2)
        if (idx[i] < 0) {
    80001f46:	0207c563          	bltz	a5,80001f70 <virtio_disk_rw+0x88>
    for (int i = 0; i < 3; i++) {
    80001f4a:	2485                	addiw	s1,s1,1
    80001f4c:	0711                	addi	a4,a4,4
    80001f4e:	25548063          	beq	s1,s5,8000218e <virtio_disk_rw+0x2a6>
        idx[i] = alloc_desc();
    80001f52:	863a                	mv	a2,a4
    for (int i = 0; i < NUM; i++) {
    80001f54:	0008d697          	auipc	a3,0x8d
    80001f58:	0c468693          	addi	a3,a3,196 # 8008f018 <disk+0x2018>
    80001f5c:	87d2                	mv	a5,s4
        if (disk.free[i]) {
    80001f5e:	0006c583          	lbu	a1,0(a3)
    80001f62:	fde1                	bnez	a1,80001f3a <virtio_disk_rw+0x52>
    for (int i = 0; i < NUM; i++) {
    80001f64:	2785                	addiw	a5,a5,1
    80001f66:	0685                	addi	a3,a3,1
    80001f68:	ff879be3          	bne	a5,s8,80001f5e <virtio_disk_rw+0x76>
        idx[i] = alloc_desc();
    80001f6c:	57fd                	li	a5,-1
    80001f6e:	c21c                	sw	a5,0(a2)
            for (int j = 0; j < i; j++)
    80001f70:	02905a63          	blez	s1,80001fa4 <virtio_disk_rw+0xbc>
                free_desc(idx[j]);
    80001f74:	f9042503          	lw	a0,-112(s0)
    80001f78:	00000097          	auipc	ra,0x0
    80001f7c:	d82080e7          	jalr	-638(ra) # 80001cfa <free_desc>
            for (int j = 0; j < i; j++)
    80001f80:	4785                	li	a5,1
    80001f82:	0297d163          	bge	a5,s1,80001fa4 <virtio_disk_rw+0xbc>
                free_desc(idx[j]);
    80001f86:	f9442503          	lw	a0,-108(s0)
    80001f8a:	00000097          	auipc	ra,0x0
    80001f8e:	d70080e7          	jalr	-656(ra) # 80001cfa <free_desc>
            for (int j = 0; j < i; j++)
    80001f92:	4789                	li	a5,2
    80001f94:	0097d863          	bge	a5,s1,80001fa4 <virtio_disk_rw+0xbc>
                free_desc(idx[j]);
    80001f98:	f9842503          	lw	a0,-104(s0)
    80001f9c:	00000097          	auipc	ra,0x0
    80001fa0:	d5e080e7          	jalr	-674(ra) # 80001cfa <free_desc>
    int idx[3];
    while (1) {
        if (alloc3_desc(idx) == 0) {
            break;
        }
        sleep(&disk.free[0], &disk.vdisk_lock);
    80001fa4:	0008d597          	auipc	a1,0x8d
    80001fa8:	18458593          	addi	a1,a1,388 # 8008f128 <disk+0x2128>
    80001fac:	0008d517          	auipc	a0,0x8d
    80001fb0:	06c50513          	addi	a0,a0,108 # 8008f018 <disk+0x2018>
    80001fb4:	fffff097          	auipc	ra,0xfffff
    80001fb8:	9be080e7          	jalr	-1602(ra) # 80000972 <sleep>
    for (int i = 0; i < 3; i++) {
    80001fbc:	f9040713          	addi	a4,s0,-112
    80001fc0:	84ce                	mv	s1,s3
    80001fc2:	bf41                	j	80001f52 <virtio_disk_rw+0x6a>
    // format the three descriptors.
    // qemu's virtio-blk.c reads them.
    struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

    if (write)
        buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80001fc4:	20058713          	addi	a4,a1,512
    80001fc8:	00471693          	slli	a3,a4,0x4
    80001fcc:	0008b717          	auipc	a4,0x8b
    80001fd0:	03470713          	addi	a4,a4,52 # 8008d000 <disk>
    80001fd4:	9736                	add	a4,a4,a3
    80001fd6:	4685                	li	a3,1
    80001fd8:	0ad72423          	sw	a3,168(a4)
    else
        buf0->type = VIRTIO_BLK_T_IN; // read the disk
    buf0->reserved = 0;
    80001fdc:	20058713          	addi	a4,a1,512
    80001fe0:	00471693          	slli	a3,a4,0x4
    80001fe4:	0008b717          	auipc	a4,0x8b
    80001fe8:	01c70713          	addi	a4,a4,28 # 8008d000 <disk>
    80001fec:	9736                	add	a4,a4,a3
    80001fee:	0a072623          	sw	zero,172(a4)
    buf0->sector = sector;
    80001ff2:	0b973823          	sd	s9,176(a4)

    disk.desc[idx[0]].addr = (uint64) buf0;
    80001ff6:	7679                	lui	a2,0xffffe
    80001ff8:	963e                	add	a2,a2,a5
    80001ffa:	0008d697          	auipc	a3,0x8d
    80001ffe:	00668693          	addi	a3,a3,6 # 8008f000 <disk+0x2000>
    80002002:	6298                	ld	a4,0(a3)
    80002004:	9732                	add	a4,a4,a2
    80002006:	e308                	sd	a0,0(a4)
    disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80002008:	6298                	ld	a4,0(a3)
    8000200a:	9732                	add	a4,a4,a2
    8000200c:	4541                	li	a0,16
    8000200e:	c708                	sw	a0,8(a4)
    disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80002010:	6298                	ld	a4,0(a3)
    80002012:	9732                	add	a4,a4,a2
    80002014:	4505                	li	a0,1
    80002016:	00a71623          	sh	a0,12(a4)
    disk.desc[idx[0]].next = idx[1];
    8000201a:	f9442703          	lw	a4,-108(s0)
    8000201e:	6288                	ld	a0,0(a3)
    80002020:	962a                	add	a2,a2,a0
    80002022:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ff515de>

    disk.desc[idx[1]].addr = (uint64) b->data;
    80002026:	0712                	slli	a4,a4,0x4
    80002028:	6290                	ld	a2,0(a3)
    8000202a:	963a                	add	a2,a2,a4
    8000202c:	04c90513          	addi	a0,s2,76
    80002030:	e208                	sd	a0,0(a2)
    disk.desc[idx[1]].len = BSIZE;
    80002032:	6294                	ld	a3,0(a3)
    80002034:	96ba                	add	a3,a3,a4
    80002036:	40000613          	li	a2,1024
    8000203a:	c690                	sw	a2,8(a3)
    if (write)
    8000203c:	140d0063          	beqz	s10,8000217c <virtio_disk_rw+0x294>
        disk.desc[idx[1]].flags = 0; // device reads b->data
    80002040:	0008d697          	auipc	a3,0x8d
    80002044:	fc06b683          	ld	a3,-64(a3) # 8008f000 <disk+0x2000>
    80002048:	96ba                	add	a3,a3,a4
    8000204a:	00069623          	sh	zero,12(a3)
    else
        disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000204e:	0008b817          	auipc	a6,0x8b
    80002052:	fb280813          	addi	a6,a6,-78 # 8008d000 <disk>
    80002056:	0008d517          	auipc	a0,0x8d
    8000205a:	faa50513          	addi	a0,a0,-86 # 8008f000 <disk+0x2000>
    8000205e:	6114                	ld	a3,0(a0)
    80002060:	96ba                	add	a3,a3,a4
    80002062:	00c6d603          	lhu	a2,12(a3)
    80002066:	00166613          	ori	a2,a2,1
    8000206a:	00c69623          	sh	a2,12(a3)
    disk.desc[idx[1]].next = idx[2];
    8000206e:	f9842683          	lw	a3,-104(s0)
    80002072:	6110                	ld	a2,0(a0)
    80002074:	9732                	add	a4,a4,a2
    80002076:	00d71723          	sh	a3,14(a4)

    disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000207a:	20058613          	addi	a2,a1,512
    8000207e:	0612                	slli	a2,a2,0x4
    80002080:	9642                	add	a2,a2,a6
    80002082:	577d                	li	a4,-1
    80002084:	02e60823          	sb	a4,48(a2)
    disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80002088:	00469713          	slli	a4,a3,0x4
    8000208c:	6114                	ld	a3,0(a0)
    8000208e:	96ba                	add	a3,a3,a4
    80002090:	03078793          	addi	a5,a5,48
    80002094:	97c2                	add	a5,a5,a6
    80002096:	e29c                	sd	a5,0(a3)
    disk.desc[idx[2]].len = 1;
    80002098:	611c                	ld	a5,0(a0)
    8000209a:	97ba                	add	a5,a5,a4
    8000209c:	4685                	li	a3,1
    8000209e:	c794                	sw	a3,8(a5)
    disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800020a0:	611c                	ld	a5,0(a0)
    800020a2:	97ba                	add	a5,a5,a4
    800020a4:	4809                	li	a6,2
    800020a6:	01079623          	sh	a6,12(a5)
    disk.desc[idx[2]].next = 0;
    800020aa:	611c                	ld	a5,0(a0)
    800020ac:	973e                	add	a4,a4,a5
    800020ae:	00071723          	sh	zero,14(a4)

    // record struct buf for virtio_disk_intr().
    b->disk = 1;
    800020b2:	00d92223          	sw	a3,4(s2)
    disk.info[idx[0]].b = b;
    800020b6:	03263423          	sd	s2,40(a2)

    // tell the device the first index in our chain of descriptors.
    disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800020ba:	6518                	ld	a4,8(a0)
    800020bc:	00275783          	lhu	a5,2(a4)
    800020c0:	8b9d                	andi	a5,a5,7
    800020c2:	0786                	slli	a5,a5,0x1
    800020c4:	97ba                	add	a5,a5,a4
    800020c6:	00b79223          	sh	a1,4(a5)

    __sync_synchronize();
    800020ca:	0ff0000f          	fence

    // tell the device another avail ring entry is available.
    disk.avail->idx += 1; // not % NUM ...
    800020ce:	6518                	ld	a4,8(a0)
    800020d0:	00275783          	lhu	a5,2(a4)
    800020d4:	2785                	addiw	a5,a5,1
    800020d6:	00f71123          	sh	a5,2(a4)

    __sync_synchronize();
    800020da:	0ff0000f          	fence

    *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800020de:	100017b7          	lui	a5,0x10001
    800020e2:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

    // Wait for virtio_disk_intr() to say request has finished.
    while (b->disk == 1) {
    800020e6:	00492703          	lw	a4,4(s2)
    800020ea:	4785                	li	a5,1
    800020ec:	02f71163          	bne	a4,a5,8000210e <virtio_disk_rw+0x226>
        sleep(b, &disk.vdisk_lock);
    800020f0:	0008d997          	auipc	s3,0x8d
    800020f4:	03898993          	addi	s3,s3,56 # 8008f128 <disk+0x2128>
    while (b->disk == 1) {
    800020f8:	4485                	li	s1,1
        sleep(b, &disk.vdisk_lock);
    800020fa:	85ce                	mv	a1,s3
    800020fc:	854a                	mv	a0,s2
    800020fe:	fffff097          	auipc	ra,0xfffff
    80002102:	874080e7          	jalr	-1932(ra) # 80000972 <sleep>
    while (b->disk == 1) {
    80002106:	00492783          	lw	a5,4(s2)
    8000210a:	fe9788e3          	beq	a5,s1,800020fa <virtio_disk_rw+0x212>
    }

    disk.info[idx[0]].b = 0;
    8000210e:	f9042903          	lw	s2,-112(s0)
    80002112:	20090793          	addi	a5,s2,512
    80002116:	00479713          	slli	a4,a5,0x4
    8000211a:	0008b797          	auipc	a5,0x8b
    8000211e:	ee678793          	addi	a5,a5,-282 # 8008d000 <disk>
    80002122:	97ba                	add	a5,a5,a4
    80002124:	0207b423          	sd	zero,40(a5)
        int flag = disk.desc[i].flags;
    80002128:	0008d997          	auipc	s3,0x8d
    8000212c:	ed898993          	addi	s3,s3,-296 # 8008f000 <disk+0x2000>
    80002130:	00491713          	slli	a4,s2,0x4
    80002134:	0009b783          	ld	a5,0(s3)
    80002138:	97ba                	add	a5,a5,a4
    8000213a:	00c7d483          	lhu	s1,12(a5)
        int nxt = disk.desc[i].next;
    8000213e:	854a                	mv	a0,s2
    80002140:	00e7d903          	lhu	s2,14(a5)
        free_desc(i);
    80002144:	00000097          	auipc	ra,0x0
    80002148:	bb6080e7          	jalr	-1098(ra) # 80001cfa <free_desc>
        if (flag & VRING_DESC_F_NEXT)
    8000214c:	8885                	andi	s1,s1,1
    8000214e:	f0ed                	bnez	s1,80002130 <virtio_disk_rw+0x248>
    free_chain(idx[0]);
    spin_unlock(&disk.vdisk_lock);
    80002150:	0008d517          	auipc	a0,0x8d
    80002154:	fd850513          	addi	a0,a0,-40 # 8008f128 <disk+0x2128>
    80002158:	00001097          	auipc	ra,0x1
    8000215c:	446080e7          	jalr	1094(ra) # 8000359e <spin_unlock>
}
    80002160:	70a6                	ld	ra,104(sp)
    80002162:	7406                	ld	s0,96(sp)
    80002164:	64e6                	ld	s1,88(sp)
    80002166:	6946                	ld	s2,80(sp)
    80002168:	69a6                	ld	s3,72(sp)
    8000216a:	6a06                	ld	s4,64(sp)
    8000216c:	7ae2                	ld	s5,56(sp)
    8000216e:	7b42                	ld	s6,48(sp)
    80002170:	7ba2                	ld	s7,40(sp)
    80002172:	7c02                	ld	s8,32(sp)
    80002174:	6ce2                	ld	s9,24(sp)
    80002176:	6d42                	ld	s10,16(sp)
    80002178:	6165                	addi	sp,sp,112
    8000217a:	8082                	ret
        disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000217c:	0008d697          	auipc	a3,0x8d
    80002180:	e846b683          	ld	a3,-380(a3) # 8008f000 <disk+0x2000>
    80002184:	96ba                	add	a3,a3,a4
    80002186:	4609                	li	a2,2
    80002188:	00c69623          	sh	a2,12(a3)
    8000218c:	b5c9                	j	8000204e <virtio_disk_rw+0x166>
    struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000218e:	f9042583          	lw	a1,-112(s0)
    80002192:	20058793          	addi	a5,a1,512
    80002196:	0792                	slli	a5,a5,0x4
    80002198:	0008b517          	auipc	a0,0x8b
    8000219c:	f1050513          	addi	a0,a0,-240 # 8008d0a8 <disk+0xa8>
    800021a0:	953e                	add	a0,a0,a5
    if (write)
    800021a2:	e20d11e3          	bnez	s10,80001fc4 <virtio_disk_rw+0xdc>
        buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800021a6:	20058713          	addi	a4,a1,512
    800021aa:	00471693          	slli	a3,a4,0x4
    800021ae:	0008b717          	auipc	a4,0x8b
    800021b2:	e5270713          	addi	a4,a4,-430 # 8008d000 <disk>
    800021b6:	9736                	add	a4,a4,a3
    800021b8:	0a072423          	sw	zero,168(a4)
    800021bc:	b505                	j	80001fdc <virtio_disk_rw+0xf4>

00000000800021be <virtio_disk_intr>:

void
virtio_disk_intr() {
    800021be:	7179                	addi	sp,sp,-48
    800021c0:	f406                	sd	ra,40(sp)
    800021c2:	f022                	sd	s0,32(sp)
    800021c4:	ec26                	sd	s1,24(sp)
    800021c6:	e84a                	sd	s2,16(sp)
    800021c8:	e44e                	sd	s3,8(sp)
    800021ca:	e052                	sd	s4,0(sp)
    800021cc:	1800                	addi	s0,sp,48
    spin_lock(&disk.vdisk_lock);
    800021ce:	0008d517          	auipc	a0,0x8d
    800021d2:	f5a50513          	addi	a0,a0,-166 # 8008f128 <disk+0x2128>
    800021d6:	00001097          	auipc	ra,0x1
    800021da:	2f4080e7          	jalr	756(ra) # 800034ca <spin_lock>
    // we've seen this interrupt, which the following line does.
    // this may race with the device writing new entries to
    // the "used" ring, in which case we may process the new
    // completion entries in this interrupt, and have nothing to do
    // in the next interrupt, which is harmless.
    *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800021de:	10001737          	lui	a4,0x10001
    800021e2:	533c                	lw	a5,96(a4)
    800021e4:	8b8d                	andi	a5,a5,3
    800021e6:	d37c                	sw	a5,100(a4)

    __sync_synchronize();
    800021e8:	0ff0000f          	fence

    // the device increments disk.used->idx when it
    // adds an entry to the used ring.
    while (disk.used_idx != disk.used->idx) {
    800021ec:	0008d797          	auipc	a5,0x8d
    800021f0:	e1478793          	addi	a5,a5,-492 # 8008f000 <disk+0x2000>
    800021f4:	6b94                	ld	a3,16(a5)
    800021f6:	0207d703          	lhu	a4,32(a5)
    800021fa:	0026d783          	lhu	a5,2(a3)
    800021fe:	06f70e63          	beq	a4,a5,8000227a <virtio_disk_intr+0xbc>
        __sync_synchronize();
        int id = disk.used->ring[disk.used_idx % NUM].id;
    80002202:	0008b997          	auipc	s3,0x8b
    80002206:	dfe98993          	addi	s3,s3,-514 # 8008d000 <disk>
    8000220a:	0008d917          	auipc	s2,0x8d
    8000220e:	df690913          	addi	s2,s2,-522 # 8008f000 <disk+0x2000>

        if (disk.info[id].status != 0)
            panic("virtio_disk_intr status");
    80002212:	00003a17          	auipc	s4,0x3
    80002216:	0d6a0a13          	addi	s4,s4,214 # 800052e8 <digits+0x1a0>
    8000221a:	a835                	j	80002256 <virtio_disk_intr+0x98>
    8000221c:	8552                	mv	a0,s4
    8000221e:	fffff097          	auipc	ra,0xfffff
    80002222:	1d2080e7          	jalr	466(ra) # 800013f0 <panic>

        struct buf *b = disk.info[id].b;
    80002226:	20048493          	addi	s1,s1,512 # 10001200 <_entry-0x6fffee00>
    8000222a:	0492                	slli	s1,s1,0x4
    8000222c:	94ce                	add	s1,s1,s3
    8000222e:	7488                	ld	a0,40(s1)
        b->disk = 0;   // disk is done with buf
    80002230:	00052223          	sw	zero,4(a0)
        wakeup(b);
    80002234:	fffff097          	auipc	ra,0xfffff
    80002238:	85a080e7          	jalr	-1958(ra) # 80000a8e <wakeup>

        disk.used_idx += 1;
    8000223c:	02095783          	lhu	a5,32(s2)
    80002240:	2785                	addiw	a5,a5,1
    80002242:	17c2                	slli	a5,a5,0x30
    80002244:	93c1                	srli	a5,a5,0x30
    80002246:	02f91023          	sh	a5,32(s2)
    while (disk.used_idx != disk.used->idx) {
    8000224a:	01093703          	ld	a4,16(s2)
    8000224e:	00275703          	lhu	a4,2(a4) # 10001002 <_entry-0x6fffeffe>
    80002252:	02f70463          	beq	a4,a5,8000227a <virtio_disk_intr+0xbc>
        __sync_synchronize();
    80002256:	0ff0000f          	fence
        int id = disk.used->ring[disk.used_idx % NUM].id;
    8000225a:	01093703          	ld	a4,16(s2)
    8000225e:	02095783          	lhu	a5,32(s2)
    80002262:	8b9d                	andi	a5,a5,7
    80002264:	078e                	slli	a5,a5,0x3
    80002266:	97ba                	add	a5,a5,a4
    80002268:	43c4                	lw	s1,4(a5)
        if (disk.info[id].status != 0)
    8000226a:	20048793          	addi	a5,s1,512
    8000226e:	0792                	slli	a5,a5,0x4
    80002270:	97ce                	add	a5,a5,s3
    80002272:	0307c783          	lbu	a5,48(a5)
    80002276:	dbc5                	beqz	a5,80002226 <virtio_disk_intr+0x68>
    80002278:	b755                	j	8000221c <virtio_disk_intr+0x5e>
    }
    spin_unlock(&disk.vdisk_lock);
    8000227a:	0008d517          	auipc	a0,0x8d
    8000227e:	eae50513          	addi	a0,a0,-338 # 8008f128 <disk+0x2128>
    80002282:	00001097          	auipc	ra,0x1
    80002286:	31c080e7          	jalr	796(ra) # 8000359e <spin_unlock>
}
    8000228a:	70a2                	ld	ra,40(sp)
    8000228c:	7402                	ld	s0,32(sp)
    8000228e:	64e2                	ld	s1,24(sp)
    80002290:	6942                	ld	s2,16(sp)
    80002292:	69a2                	ld	s3,8(sp)
    80002294:	6a02                	ld	s4,0(sp)
    80002296:	6145                	addi	sp,sp,48
    80002298:	8082                	ret

000000008000229a <fstest>:
#include "file.h"
#include "virtio.h"
#include "../defs.h"
#include "fstest.h"

void fstest() {
    8000229a:	715d                	addi	sp,sp,-80
    8000229c:	e486                	sd	ra,72(sp)
    8000229e:	e0a2                	sd	s0,64(sp)
    800022a0:	fc26                	sd	s1,56(sp)
    800022a2:	f84a                	sd	s2,48(sp)
    800022a4:	0880                	addi	s0,sp,80
    struct inode *inode;
    struct superblock sb;
    read_superblock(&sb);
    800022a6:	fc840513          	addi	a0,s0,-56
    800022aa:	00000097          	auipc	ra,0x0
    800022ae:	2f8080e7          	jalr	760(ra) # 800025a2 <read_superblock>
    inode = alloc_inode(T_FILE);
    800022b2:	4509                	li	a0,2
    800022b4:	00000097          	auipc	ra,0x0
    800022b8:	6ce080e7          	jalr	1742(ra) # 80002982 <alloc_inode>
    800022bc:	84aa                	mv	s1,a0
    printf("测试inode能否读写");
    800022be:	00003517          	auipc	a0,0x3
    800022c2:	04250513          	addi	a0,a0,66 # 80005300 <digits+0x1b8>
    800022c6:	fffff097          	auipc	ra,0xfffff
    800022ca:	066080e7          	jalr	102(ra) # 8000132c <printf>
    char *str = "hello world!!";
    write_inode(inode, (uint64) str, 0, strlen(str));
    800022ce:	00003917          	auipc	s2,0x3
    800022d2:	04a90913          	addi	s2,s2,74 # 80005318 <digits+0x1d0>
    800022d6:	854a                	mv	a0,s2
    800022d8:	fffff097          	auipc	ra,0xfffff
    800022dc:	c16080e7          	jalr	-1002(ra) # 80000eee <strlen>
    800022e0:	0005069b          	sext.w	a3,a0
    800022e4:	4601                	li	a2,0
    800022e6:	85ca                	mv	a1,s2
    800022e8:	8526                	mv	a0,s1
    800022ea:	00001097          	auipc	ra,0x1
    800022ee:	b3a080e7          	jalr	-1222(ra) # 80002e24 <write_inode>
    char s[20];
    read_inode(inode, (uint64) s, 0, 30);
    800022f2:	46f9                	li	a3,30
    800022f4:	4601                	li	a2,0
    800022f6:	fb040593          	addi	a1,s0,-80
    800022fa:	8526                	mv	a0,s1
    800022fc:	00001097          	auipc	ra,0x1
    80002300:	a5e080e7          	jalr	-1442(ra) # 80002d5a <read_inode>
    printf("%s\n", s);
    80002304:	fb040593          	addi	a1,s0,-80
    80002308:	00003517          	auipc	a0,0x3
    8000230c:	e1050513          	addi	a0,a0,-496 # 80005118 <etext+0x118>
    80002310:	fffff097          	auipc	ra,0xfffff
    80002314:	01c080e7          	jalr	28(ra) # 8000132c <printf>
}
    80002318:	60a6                	ld	ra,72(sp)
    8000231a:	6406                	ld	s0,64(sp)
    8000231c:	74e2                	ld	s1,56(sp)
    8000231e:	7942                	ld	s2,48(sp)
    80002320:	6161                	addi	sp,sp,80
    80002322:	8082                	ret

0000000080002324 <dirtest>:

// 输出根目录下的direntry
void dirtest() {
    80002324:	be010113          	addi	sp,sp,-1056
    80002328:	40113c23          	sd	ra,1048(sp)
    8000232c:	40813823          	sd	s0,1040(sp)
    80002330:	40913423          	sd	s1,1032(sp)
    80002334:	42010413          	addi	s0,sp,1056
    int off = 0;
    char str[1024];
    printf("aa\n");
    80002338:	00003517          	auipc	a0,0x3
    8000233c:	ff050513          	addi	a0,a0,-16 # 80005328 <digits+0x1e0>
    80002340:	fffff097          	auipc	ra,0xfffff
    80002344:	fec080e7          	jalr	-20(ra) # 8000132c <printf>
    struct inode *ip = namei("/readme.txt");
    80002348:	00003517          	auipc	a0,0x3
    8000234c:	fe850513          	addi	a0,a0,-24 # 80005330 <digits+0x1e8>
    80002350:	00001097          	auipc	ra,0x1
    80002354:	ed2080e7          	jalr	-302(ra) # 80003222 <namei>
    80002358:	84aa                	mv	s1,a0
    printf("bb\n");
    8000235a:	00003517          	auipc	a0,0x3
    8000235e:	fe650513          	addi	a0,a0,-26 # 80005340 <digits+0x1f8>
    80002362:	fffff097          	auipc	ra,0xfffff
    80002366:	fca080e7          	jalr	-54(ra) # 8000132c <printf>
    lock_inode(ip);
    8000236a:	8526                	mv	a0,s1
    8000236c:	00001097          	auipc	ra,0x1
    80002370:	8ba080e7          	jalr	-1862(ra) # 80002c26 <lock_inode>
    read_inode(ip, (uint64)str, off, 1024);
    80002374:	40000693          	li	a3,1024
    80002378:	4601                	li	a2,0
    8000237a:	be040593          	addi	a1,s0,-1056
    8000237e:	8526                	mv	a0,s1
    80002380:	00001097          	auipc	ra,0x1
    80002384:	9da080e7          	jalr	-1574(ra) # 80002d5a <read_inode>
    printf("%s\n",str);
    80002388:	be040593          	addi	a1,s0,-1056
    8000238c:	00003517          	auipc	a0,0x3
    80002390:	d8c50513          	addi	a0,a0,-628 # 80005118 <etext+0x118>
    80002394:	fffff097          	auipc	ra,0xfffff
    80002398:	f98080e7          	jalr	-104(ra) # 8000132c <printf>
    unlock_inode(ip);
    8000239c:	8526                	mv	a0,s1
    8000239e:	00001097          	auipc	ra,0x1
    800023a2:	94e080e7          	jalr	-1714(ra) # 80002cec <unlock_inode>
}
    800023a6:	41813083          	ld	ra,1048(sp)
    800023aa:	41013403          	ld	s0,1040(sp)
    800023ae:	40813483          	ld	s1,1032(sp)
    800023b2:	42010113          	addi	sp,sp,1056
    800023b6:	8082                	ret

00000000800023b8 <exec>:
#include "../defs.h"
#include "elf.h"

static int loadseg(pte_t *pagetable, uint64 addr, struct inode *ip, uint offset, uint sz);

int exec(char *path, char **argv) {
    800023b8:	716d                	addi	sp,sp,-272
    800023ba:	e606                	sd	ra,264(sp)
    800023bc:	e222                	sd	s0,256(sp)
    800023be:	fda6                	sd	s1,248(sp)
    800023c0:	f9ca                	sd	s2,240(sp)
    800023c2:	f5ce                	sd	s3,232(sp)
    800023c4:	f1d2                	sd	s4,224(sp)
    800023c6:	edd6                	sd	s5,216(sp)
    800023c8:	e9da                	sd	s6,208(sp)
    800023ca:	e5de                	sd	s7,200(sp)
    800023cc:	e1e2                	sd	s8,192(sp)
    800023ce:	fd66                	sd	s9,184(sp)
    800023d0:	f96a                	sd	s10,176(sp)
    800023d2:	f56e                	sd	s11,168(sp)
    800023d4:	0a00                	addi	s0,sp,272
    800023d6:	84aa                	mv	s1,a0
    uint64 sz = 0;
    struct elfhdr elf;
    struct inode *ip;
    struct proghdr ph;
    pagetable_t pagetable = 0;
    struct proc *p = myproc();
    800023d8:	ffffe097          	auipc	ra,0xffffe
    800023dc:	45e080e7          	jalr	1118(ra) # 80000836 <myproc>
    800023e0:	f0a43023          	sd	a0,-256(s0)


    if((pagetable = proc_pagetable(p))==0){
    800023e4:	ffffe097          	auipc	ra,0xffffe
    800023e8:	262080e7          	jalr	610(ra) # 80000646 <proc_pagetable>
    800023ec:	18050b63          	beqz	a0,80002582 <exec+0x1ca>
    800023f0:	8b2a                	mv	s6,a0
        return 0;
    }

    if ((ip = namei(path)) == 0) {
    800023f2:	8526                	mv	a0,s1
    800023f4:	00001097          	auipc	ra,0x1
    800023f8:	e2e080e7          	jalr	-466(ra) # 80003222 <namei>
    800023fc:	8a2a                	mv	s4,a0
    800023fe:	18050263          	beqz	a0,80002582 <exec+0x1ca>
        return 0;
    }
    lock_inode(ip);
    80002402:	00001097          	auipc	ra,0x1
    80002406:	824080e7          	jalr	-2012(ra) # 80002c26 <lock_inode>

    // 检查ELF头
    if (read_inode(ip, (uint64) &elf, 0, sizeof(elf)) != sizeof(elf))
    8000240a:	04000693          	li	a3,64
    8000240e:	4601                	li	a2,0
    80002410:	f5040593          	addi	a1,s0,-176
    80002414:	8552                	mv	a0,s4
    80002416:	00001097          	auipc	ra,0x1
    8000241a:	944080e7          	jalr	-1724(ra) # 80002d5a <read_inode>
    8000241e:	04000793          	li	a5,64
    80002422:	14f51863          	bne	a0,a5,80002572 <exec+0x1ba>
        goto bad;
    if (elf.magic != ELF_MAGIC)
    80002426:	f5042703          	lw	a4,-176(s0)
    8000242a:	464c47b7          	lui	a5,0x464c4
    8000242e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80002432:	14f71063          	bne	a4,a5,80002572 <exec+0x1ba>
        goto bad;

    // 加载程序到内存中
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80002436:	f7042983          	lw	s3,-144(s0)
    8000243a:	f8845783          	lhu	a5,-120(s0)
    8000243e:	c7fd                	beqz	a5,8000252c <exec+0x174>
    uint64 sz = 0;
    80002440:	f0043423          	sd	zero,-248(s0)
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80002444:	4c01                	li	s8,0
            goto bad;
        uint64 sz1;
        if ((sz1 = user_vm_alloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
            goto bad;
        sz = sz1;
        if (ph.vaddr % PGSIZE != 0)
    80002446:	6785                	lui	a5,0x1
    80002448:	17fd                	addi	a5,a5,-1
    8000244a:	eef43c23          	sd	a5,-264(s0)
    8000244e:	a0b5                	j	800024ba <exec+0x102>
        panic("loadseg: va must be page aligned");

    for (i = 0; i < sz; i += PGSIZE) {
        pa = walkaddr(pagetable, va + i);
        if (pa == 0)
            panic("loadseg: address should exist");
    80002450:	00003517          	auipc	a0,0x3
    80002454:	ef850513          	addi	a0,a0,-264 # 80005348 <digits+0x200>
    80002458:	fffff097          	auipc	ra,0xfffff
    8000245c:	f98080e7          	jalr	-104(ra) # 800013f0 <panic>
    80002460:	a081                	j	800024a0 <exec+0xe8>
        if (sz - i < PGSIZE)
            n = sz - i;
        else
            n = PGSIZE;
        if (read_inode(ip, (uint64) pa, offset + i, n) != n)
    80002462:	000b869b          	sext.w	a3,s7
    80002466:	009d863b          	addw	a2,s11,s1
    8000246a:	85ca                	mv	a1,s2
    8000246c:	8552                	mv	a0,s4
    8000246e:	00001097          	auipc	ra,0x1
    80002472:	8ec080e7          	jalr	-1812(ra) # 80002d5a <read_inode>
    80002476:	2501                	sext.w	a0,a0
    80002478:	0eab9d63          	bne	s7,a0,80002572 <exec+0x1ba>
    for (i = 0; i < sz; i += PGSIZE) {
    8000247c:	6785                	lui	a5,0x1
    8000247e:	9cbd                	addw	s1,s1,a5
    80002480:	77fd                	lui	a5,0xfffff
    80002482:	01578abb          	addw	s5,a5,s5
    80002486:	0394f363          	bgeu	s1,s9,800024ac <exec+0xf4>
        pa = walkaddr(pagetable, va + i);
    8000248a:	02049593          	slli	a1,s1,0x20
    8000248e:	9181                	srli	a1,a1,0x20
    80002490:	95ea                	add	a1,a1,s10
    80002492:	855a                	mv	a0,s6
    80002494:	fffff097          	auipc	ra,0xfffff
    80002498:	242080e7          	jalr	578(ra) # 800016d6 <walkaddr>
    8000249c:	892a                	mv	s2,a0
        if (pa == 0)
    8000249e:	d94d                	beqz	a0,80002450 <exec+0x98>
            n = PGSIZE;
    800024a0:	6b85                	lui	s7,0x1
        if (sz - i < PGSIZE)
    800024a2:	6785                	lui	a5,0x1
    800024a4:	fafaffe3          	bgeu	s5,a5,80002462 <exec+0xaa>
            n = sz - i;
    800024a8:	8bd6                	mv	s7,s5
    800024aa:	bf65                	j	80002462 <exec+0xaa>
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800024ac:	2c05                	addiw	s8,s8,1
    800024ae:	0389899b          	addiw	s3,s3,56
    800024b2:	f8845783          	lhu	a5,-120(s0)
    800024b6:	06fc5d63          	bge	s8,a5,80002530 <exec+0x178>
        if (read_inode(ip, (uint64) &ph, off, sizeof(ph)) != sizeof(ph))
    800024ba:	2981                	sext.w	s3,s3
    800024bc:	03800693          	li	a3,56
    800024c0:	864e                	mv	a2,s3
    800024c2:	f1840593          	addi	a1,s0,-232
    800024c6:	8552                	mv	a0,s4
    800024c8:	00001097          	auipc	ra,0x1
    800024cc:	892080e7          	jalr	-1902(ra) # 80002d5a <read_inode>
    800024d0:	03800793          	li	a5,56
    800024d4:	08f51f63          	bne	a0,a5,80002572 <exec+0x1ba>
        if (ph.type != ELF_PROG_LOAD)
    800024d8:	f1842703          	lw	a4,-232(s0)
    800024dc:	4785                	li	a5,1
    800024de:	fcf717e3          	bne	a4,a5,800024ac <exec+0xf4>
        if (ph.memsz < ph.filesz)
    800024e2:	f4043603          	ld	a2,-192(s0)
    800024e6:	f3843783          	ld	a5,-200(s0)
    800024ea:	08f66463          	bltu	a2,a5,80002572 <exec+0x1ba>
        if (ph.vaddr + ph.memsz < ph.vaddr)
    800024ee:	f2843783          	ld	a5,-216(s0)
    800024f2:	963e                	add	a2,a2,a5
    800024f4:	06f66f63          	bltu	a2,a5,80002572 <exec+0x1ba>
        if ((sz1 = user_vm_alloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800024f8:	f0843583          	ld	a1,-248(s0)
    800024fc:	855a                	mv	a0,s6
    800024fe:	fffff097          	auipc	ra,0xfffff
    80002502:	326080e7          	jalr	806(ra) # 80001824 <user_vm_alloc>
    80002506:	f0a43423          	sd	a0,-248(s0)
    8000250a:	c525                	beqz	a0,80002572 <exec+0x1ba>
        if (ph.vaddr % PGSIZE != 0)
    8000250c:	f2843d03          	ld	s10,-216(s0)
    80002510:	ef843783          	ld	a5,-264(s0)
    80002514:	00fd77b3          	and	a5,s10,a5
    80002518:	efa9                	bnez	a5,80002572 <exec+0x1ba>
        if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000251a:	f2042d83          	lw	s11,-224(s0)
    8000251e:	f3842c83          	lw	s9,-200(s0)
    for (i = 0; i < sz; i += PGSIZE) {
    80002522:	f80c85e3          	beqz	s9,800024ac <exec+0xf4>
    80002526:	8ae6                	mv	s5,s9
    80002528:	4481                	li	s1,0
    8000252a:	b785                	j	8000248a <exec+0xd2>
    uint64 sz = 0;
    8000252c:	f0043423          	sd	zero,-248(s0)
    unlock_and_putback(ip);
    80002530:	8552                	mv	a0,s4
    80002532:	00001097          	auipc	ra,0x1
    80002536:	800080e7          	jalr	-2048(ra) # 80002d32 <unlock_and_putback>
    sz = PGROUNDUP(sz);
    8000253a:	6605                	lui	a2,0x1
    8000253c:	fff60593          	addi	a1,a2,-1 # fff <_entry-0x7ffff001>
    80002540:	f0843783          	ld	a5,-248(s0)
    80002544:	95be                	add	a1,a1,a5
    80002546:	77fd                	lui	a5,0xfffff
    80002548:	8dfd                	and	a1,a1,a5
    if ((sz1 = user_vm_alloc(pagetable, sz, sz+PGSIZE)) == 0)
    8000254a:	962e                	add	a2,a2,a1
    8000254c:	855a                	mv	a0,s6
    8000254e:	fffff097          	auipc	ra,0xfffff
    80002552:	2d6080e7          	jalr	726(ra) # 80001824 <user_vm_alloc>
    80002556:	cd11                	beqz	a0,80002572 <exec+0x1ba>
    p->pagetable = pagetable;
    80002558:	f0043683          	ld	a3,-256(s0)
    8000255c:	0566b423          	sd	s6,72(a3)
    p->trapframe->epc = elf.entry;
    80002560:	62bc                	ld	a5,64(a3)
    80002562:	f6843703          	ld	a4,-152(s0)
    80002566:	ef98                	sd	a4,24(a5)
    p->trapframe->sp = sz;
    80002568:	62bc                	ld	a5,64(a3)
    8000256a:	fb88                	sd	a0,48(a5)
    p->sz = sz;
    8000256c:	0ea6a423          	sw	a0,232(a3)
    return 0;
    80002570:	a809                	j	80002582 <exec+0x1ca>
    panic("exec");
    80002572:	00003517          	auipc	a0,0x3
    80002576:	df650513          	addi	a0,a0,-522 # 80005368 <digits+0x220>
    8000257a:	fffff097          	auipc	ra,0xfffff
    8000257e:	e76080e7          	jalr	-394(ra) # 800013f0 <panic>
}
    80002582:	4501                	li	a0,0
    80002584:	60b2                	ld	ra,264(sp)
    80002586:	6412                	ld	s0,256(sp)
    80002588:	74ee                	ld	s1,248(sp)
    8000258a:	794e                	ld	s2,240(sp)
    8000258c:	79ae                	ld	s3,232(sp)
    8000258e:	7a0e                	ld	s4,224(sp)
    80002590:	6aee                	ld	s5,216(sp)
    80002592:	6b4e                	ld	s6,208(sp)
    80002594:	6bae                	ld	s7,200(sp)
    80002596:	6c0e                	ld	s8,192(sp)
    80002598:	7cea                	ld	s9,184(sp)
    8000259a:	7d4a                	ld	s10,176(sp)
    8000259c:	7daa                	ld	s11,168(sp)
    8000259e:	6151                	addi	sp,sp,272
    800025a0:	8082                	ret

00000000800025a2 <read_superblock>:

#define min(a, b) ((a) < (b) ? (a) : (b))
struct superblock sb;

// 读取超级块
void read_superblock(struct superblock *sb) {
    800025a2:	b9010113          	addi	sp,sp,-1136
    800025a6:	46113423          	sd	ra,1128(sp)
    800025aa:	46813023          	sd	s0,1120(sp)
    800025ae:	44913c23          	sd	s1,1112(sp)
    800025b2:	47010413          	addi	s0,sp,1136
    800025b6:	84aa                	mv	s1,a0
    struct buf b;
    b.blockno = 1;
    800025b8:	4785                	li	a5,1
    800025ba:	b8f42e23          	sw	a5,-1124(s0)
    virtio_disk_rw(&b, 0);
    800025be:	4581                	li	a1,0
    800025c0:	b9040513          	addi	a0,s0,-1136
    800025c4:	00000097          	auipc	ra,0x0
    800025c8:	924080e7          	jalr	-1756(ra) # 80001ee8 <virtio_disk_rw>
    memmove(sb, &b.data, sizeof(*sb));
    800025cc:	4661                	li	a2,24
    800025ce:	bdc40593          	addi	a1,s0,-1060
    800025d2:	8526                	mv	a0,s1
    800025d4:	fffff097          	auipc	ra,0xfffff
    800025d8:	8be080e7          	jalr	-1858(ra) # 80000e92 <memmove>
    return;
}
    800025dc:	46813083          	ld	ra,1128(sp)
    800025e0:	46013403          	ld	s0,1120(sp)
    800025e4:	45813483          	ld	s1,1112(sp)
    800025e8:	47010113          	addi	sp,sp,1136
    800025ec:	8082                	ret

00000000800025ee <init_fs>:

// 初始化文件系统
void init_fs() {
    800025ee:	1101                	addi	sp,sp,-32
    800025f0:	ec06                	sd	ra,24(sp)
    800025f2:	e822                	sd	s0,16(sp)
    800025f4:	e426                	sd	s1,8(sp)
    800025f6:	1000                	addi	s0,sp,32
    read_superblock(&sb);
    800025f8:	0008e497          	auipc	s1,0x8e
    800025fc:	a0848493          	addi	s1,s1,-1528 # 80090000 <sb>
    80002600:	8526                	mv	a0,s1
    80002602:	00000097          	auipc	ra,0x0
    80002606:	fa0080e7          	jalr	-96(ra) # 800025a2 <read_superblock>
    if (sb.magic != FSMAGIC) {
    8000260a:	4098                	lw	a4,0(s1)
    8000260c:	102037b7          	lui	a5,0x10203
    80002610:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002614:	00f71763          	bne	a4,a5,80002622 <init_fs+0x34>
        panic("fs init");
    }
}
    80002618:	60e2                	ld	ra,24(sp)
    8000261a:	6442                	ld	s0,16(sp)
    8000261c:	64a2                	ld	s1,8(sp)
    8000261e:	6105                	addi	sp,sp,32
    80002620:	8082                	ret
        panic("fs init");
    80002622:	00003517          	auipc	a0,0x3
    80002626:	d4e50513          	addi	a0,a0,-690 # 80005370 <digits+0x228>
    8000262a:	fffff097          	auipc	ra,0xfffff
    8000262e:	dc6080e7          	jalr	-570(ra) # 800013f0 <panic>
}
    80002632:	b7dd                	j	80002618 <init_fs+0x2a>

0000000080002634 <zero_block>:
//
// 数据块，下面的block通常指数据块
//

// 格式化磁盘块中的数据
void zero_block(int blockno) {
    80002634:	1101                	addi	sp,sp,-32
    80002636:	ec06                	sd	ra,24(sp)
    80002638:	e822                	sd	s0,16(sp)
    8000263a:	e426                	sd	s1,8(sp)
    8000263c:	1000                	addi	s0,sp,32
    8000263e:	85aa                	mv	a1,a0
    struct buf *bp;
    bp = buf_read(0, blockno);
    80002640:	4501                	li	a0,0
    80002642:	00001097          	auipc	ra,0x1
    80002646:	d58080e7          	jalr	-680(ra) # 8000339a <buf_read>
    8000264a:	84aa                	mv	s1,a0
    memset(bp->data, 0, BSIZE);
    8000264c:	40000613          	li	a2,1024
    80002650:	4581                	li	a1,0
    80002652:	04c50513          	addi	a0,a0,76
    80002656:	fffff097          	auipc	ra,0xfffff
    8000265a:	816080e7          	jalr	-2026(ra) # 80000e6c <memset>
    buf_write(bp);
    8000265e:	8526                	mv	a0,s1
    80002660:	00001097          	auipc	ra,0x1
    80002664:	d6e080e7          	jalr	-658(ra) # 800033ce <buf_write>
    relse_buf(bp);
    80002668:	8526                	mv	a0,s1
    8000266a:	00001097          	auipc	ra,0x1
    8000266e:	d7e080e7          	jalr	-642(ra) # 800033e8 <relse_buf>
}
    80002672:	60e2                	ld	ra,24(sp)
    80002674:	6442                	ld	s0,16(sp)
    80002676:	64a2                	ld	s1,8(sp)
    80002678:	6105                	addi	sp,sp,32
    8000267a:	8082                	ret

000000008000267c <alloc_disk_block>:

// 申请空闲的磁盘块, 且格式化为0，返回块号。
uint alloc_disk_block() {
    8000267c:	715d                	addi	sp,sp,-80
    8000267e:	e486                	sd	ra,72(sp)
    80002680:	e0a2                	sd	s0,64(sp)
    80002682:	fc26                	sd	s1,56(sp)
    80002684:	f84a                	sd	s2,48(sp)
    80002686:	f44e                	sd	s3,40(sp)
    80002688:	f052                	sd	s4,32(sp)
    8000268a:	ec56                	sd	s5,24(sp)
    8000268c:	e85a                	sd	s6,16(sp)
    8000268e:	e45e                	sd	s7,8(sp)
    80002690:	0880                	addi	s0,sp,80
    int b, bi, m;
    struct buf *bitmap;

    for (b = 0; b < sb.size; b += BPB) { // 遍历bitmap
    80002692:	0008e797          	auipc	a5,0x8e
    80002696:	9727a783          	lw	a5,-1678(a5) # 80090004 <sb+0x4>
    8000269a:	c3e9                	beqz	a5,8000275c <alloc_disk_block+0xe0>
    8000269c:	4a81                	li	s5,0
        bitmap = buf_read(0, BBLOCK(b, sb));
    8000269e:	0008eb17          	auipc	s6,0x8e
    800026a2:	962b0b13          	addi	s6,s6,-1694 # 80090000 <sb>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) { //遍历bitmap的每一位
            m = 1 << (bi % 8);
    800026a6:	4985                	li	s3,1
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) { //遍历bitmap的每一位
    800026a8:	6a09                	lui	s4,0x2
    for (b = 0; b < sb.size; b += BPB) { // 遍历bitmap
    800026aa:	6b89                	lui	s7,0x2
    800026ac:	a0b1                	j	800026f8 <alloc_disk_block+0x7c>
            if ((bitmap->data[bi / 8] & m) == 0) { // 判断块是否被使用
                bitmap->data[bi / 8] |= m; // 标记块被使用
    800026ae:	972a                	add	a4,a4,a0
    800026b0:	8fd5                	or	a5,a5,a3
    800026b2:	04f70623          	sb	a5,76(a4)
                relse_buf(bitmap);
    800026b6:	00001097          	auipc	ra,0x1
    800026ba:	d32080e7          	jalr	-718(ra) # 800033e8 <relse_buf>
                zero_block(b + bi);
    800026be:	854a                	mv	a0,s2
    800026c0:	00000097          	auipc	ra,0x0
    800026c4:	f74080e7          	jalr	-140(ra) # 80002634 <zero_block>
        }
        relse_buf(bitmap);
    }
    panic("balloc: out of blocks");
    return 0;
}
    800026c8:	8526                	mv	a0,s1
    800026ca:	60a6                	ld	ra,72(sp)
    800026cc:	6406                	ld	s0,64(sp)
    800026ce:	74e2                	ld	s1,56(sp)
    800026d0:	7942                	ld	s2,48(sp)
    800026d2:	79a2                	ld	s3,40(sp)
    800026d4:	7a02                	ld	s4,32(sp)
    800026d6:	6ae2                	ld	s5,24(sp)
    800026d8:	6b42                	ld	s6,16(sp)
    800026da:	6ba2                	ld	s7,8(sp)
    800026dc:	6161                	addi	sp,sp,80
    800026de:	8082                	ret
        relse_buf(bitmap);
    800026e0:	00001097          	auipc	ra,0x1
    800026e4:	d08080e7          	jalr	-760(ra) # 800033e8 <relse_buf>
    for (b = 0; b < sb.size; b += BPB) { // 遍历bitmap
    800026e8:	015b87bb          	addw	a5,s7,s5
    800026ec:	00078a9b          	sext.w	s5,a5
    800026f0:	004b2703          	lw	a4,4(s6)
    800026f4:	06eaf463          	bgeu	s5,a4,8000275c <alloc_disk_block+0xe0>
        bitmap = buf_read(0, BBLOCK(b, sb));
    800026f8:	41fad79b          	sraiw	a5,s5,0x1f
    800026fc:	0137d79b          	srliw	a5,a5,0x13
    80002700:	015787bb          	addw	a5,a5,s5
    80002704:	40d7d79b          	sraiw	a5,a5,0xd
    80002708:	014b2583          	lw	a1,20(s6)
    8000270c:	9dbd                	addw	a1,a1,a5
    8000270e:	4501                	li	a0,0
    80002710:	00001097          	auipc	ra,0x1
    80002714:	c8a080e7          	jalr	-886(ra) # 8000339a <buf_read>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) { //遍历bitmap的每一位
    80002718:	004b2803          	lw	a6,4(s6)
    8000271c:	000a849b          	sext.w	s1,s5
    80002720:	4601                	li	a2,0
    80002722:	0004891b          	sext.w	s2,s1
    80002726:	fb04fde3          	bgeu	s1,a6,800026e0 <alloc_disk_block+0x64>
            m = 1 << (bi % 8);
    8000272a:	41f6579b          	sraiw	a5,a2,0x1f
    8000272e:	01d7d69b          	srliw	a3,a5,0x1d
    80002732:	00c6873b          	addw	a4,a3,a2
    80002736:	00777793          	andi	a5,a4,7
    8000273a:	9f95                	subw	a5,a5,a3
    8000273c:	00f997bb          	sllw	a5,s3,a5
            if ((bitmap->data[bi / 8] & m) == 0) { // 判断块是否被使用
    80002740:	4037571b          	sraiw	a4,a4,0x3
    80002744:	00e506b3          	add	a3,a0,a4
    80002748:	04c6c683          	lbu	a3,76(a3)
    8000274c:	00d7f5b3          	and	a1,a5,a3
    80002750:	ddb9                	beqz	a1,800026ae <alloc_disk_block+0x32>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) { //遍历bitmap的每一位
    80002752:	2605                	addiw	a2,a2,1
    80002754:	2485                	addiw	s1,s1,1
    80002756:	fd4616e3          	bne	a2,s4,80002722 <alloc_disk_block+0xa6>
    8000275a:	b759                	j	800026e0 <alloc_disk_block+0x64>
    panic("balloc: out of blocks");
    8000275c:	00003517          	auipc	a0,0x3
    80002760:	c1c50513          	addi	a0,a0,-996 # 80005378 <digits+0x230>
    80002764:	fffff097          	auipc	ra,0xfffff
    80002768:	c8c080e7          	jalr	-884(ra) # 800013f0 <panic>
    return 0;
    8000276c:	4481                	li	s1,0
    8000276e:	bfa9                	j	800026c8 <alloc_disk_block+0x4c>

0000000080002770 <free_disk_block>:

// 释放磁盘块, 通过重置bitmap对应位。
void free_disk_block(int blockno) {
    80002770:	1101                	addi	sp,sp,-32
    80002772:	ec06                	sd	ra,24(sp)
    80002774:	e822                	sd	s0,16(sp)
    80002776:	e426                	sd	s1,8(sp)
    80002778:	e04a                	sd	s2,0(sp)
    8000277a:	1000                	addi	s0,sp,32
    struct buf *bitmap;
    int bi, m;
    bitmap = buf_read(0, BBLOCK(blockno, sb));
    8000277c:	41f5549b          	sraiw	s1,a0,0x1f
    80002780:	0134d91b          	srliw	s2,s1,0x13
    80002784:	00a904bb          	addw	s1,s2,a0
    80002788:	40d4d59b          	sraiw	a1,s1,0xd
    8000278c:	0008e797          	auipc	a5,0x8e
    80002790:	8887a783          	lw	a5,-1912(a5) # 80090014 <sb+0x14>
    80002794:	9dbd                	addw	a1,a1,a5
    80002796:	4501                	li	a0,0
    80002798:	00001097          	auipc	ra,0x1
    8000279c:	c02080e7          	jalr	-1022(ra) # 8000339a <buf_read>
    bi = blockno % BPB;
    800027a0:	14ce                	slli	s1,s1,0x33
    800027a2:	90cd                	srli	s1,s1,0x33
    800027a4:	412484bb          	subw	s1,s1,s2
    m = 1 << (bi % 8);
    bitmap->data[bi / 8] &= ~m;
    800027a8:	41f4d79b          	sraiw	a5,s1,0x1f
    800027ac:	01d7d79b          	srliw	a5,a5,0x1d
    800027b0:	9cbd                	addw	s1,s1,a5
    800027b2:	4034d71b          	sraiw	a4,s1,0x3
    800027b6:	972a                	add	a4,a4,a0
    m = 1 << (bi % 8);
    800027b8:	889d                	andi	s1,s1,7
    800027ba:	9c9d                	subw	s1,s1,a5
    bitmap->data[bi / 8] &= ~m;
    800027bc:	4785                	li	a5,1
    800027be:	009794bb          	sllw	s1,a5,s1
    800027c2:	fff4c493          	not	s1,s1
    800027c6:	04c74783          	lbu	a5,76(a4)
    800027ca:	8cfd                	and	s1,s1,a5
    800027cc:	04970623          	sb	s1,76(a4)
    relse_buf(bitmap);
    800027d0:	00001097          	auipc	ra,0x1
    800027d4:	c18080e7          	jalr	-1000(ra) # 800033e8 <relse_buf>
}
    800027d8:	60e2                	ld	ra,24(sp)
    800027da:	6442                	ld	s0,16(sp)
    800027dc:	64a2                	ld	s1,8(sp)
    800027de:	6902                	ld	s2,0(sp)
    800027e0:	6105                	addi	sp,sp,32
    800027e2:	8082                	ret

00000000800027e4 <init_inode_cache>:
    struct inode inode[NINODE];
} inode_cache;


// 初始化inode的缓存
void init_inode_cache() {
    800027e4:	7179                	addi	sp,sp,-48
    800027e6:	f406                	sd	ra,40(sp)
    800027e8:	f022                	sd	s0,32(sp)
    800027ea:	ec26                	sd	s1,24(sp)
    800027ec:	e84a                	sd	s2,16(sp)
    800027ee:	e44e                	sd	s3,8(sp)
    800027f0:	1800                	addi	s0,sp,48
    spinlock_init(&inode_cache.lock, "inode cache");
    800027f2:	00003597          	auipc	a1,0x3
    800027f6:	b9e58593          	addi	a1,a1,-1122 # 80005390 <digits+0x248>
    800027fa:	0008e517          	auipc	a0,0x8e
    800027fe:	81e50513          	addi	a0,a0,-2018 # 80090018 <inode_cache>
    80002802:	00001097          	auipc	ra,0x1
    80002806:	c38080e7          	jalr	-968(ra) # 8000343a <spinlock_init>
    for (int i = 0; i < NINODE; i++) {
    8000280a:	0008e497          	auipc	s1,0x8e
    8000280e:	83648493          	addi	s1,s1,-1994 # 80090040 <inode_cache+0x28>
    80002812:	0008f997          	auipc	s3,0x8f
    80002816:	2be98993          	addi	s3,s3,702 # 80091ad0 <cache_lock+0x10>
        sleeplock_init(&inode_cache.inode[i].lock, "inode");
    8000281a:	00003917          	auipc	s2,0x3
    8000281e:	b8690913          	addi	s2,s2,-1146 # 800053a0 <digits+0x258>
    80002822:	85ca                	mv	a1,s2
    80002824:	8526                	mv	a0,s1
    80002826:	00001097          	auipc	ra,0x1
    8000282a:	dd4080e7          	jalr	-556(ra) # 800035fa <sleeplock_init>
    for (int i = 0; i < NINODE; i++) {
    8000282e:	08848493          	addi	s1,s1,136
    80002832:	ff3498e3          	bne	s1,s3,80002822 <init_inode_cache+0x3e>
    }
}
    80002836:	70a2                	ld	ra,40(sp)
    80002838:	7402                	ld	s0,32(sp)
    8000283a:	64e2                	ld	s1,24(sp)
    8000283c:	6942                	ld	s2,16(sp)
    8000283e:	69a2                	ld	s3,8(sp)
    80002840:	6145                	addi	sp,sp,48
    80002842:	8082                	ret

0000000080002844 <update_inode>:

// 将内存中的inode写入到磁盘中,
// 每次改变磁盘上的ip->xxx字段都需要调用该函数，
// 因为inode cache是write-through。
// 调用者必须持有ip->lock.
void update_inode(struct inode *ip) {
    80002844:	1101                	addi	sp,sp,-32
    80002846:	ec06                	sd	ra,24(sp)
    80002848:	e822                	sd	s0,16(sp)
    8000284a:	e426                	sd	s1,8(sp)
    8000284c:	e04a                	sd	s2,0(sp)
    8000284e:	1000                	addi	s0,sp,32
    80002850:	84aa                	mv	s1,a0
    struct buf *bp;
    struct dinode *dip;

    bp = buf_read(ip->dev, IBLOCK(ip->inum, sb));
    80002852:	415c                	lw	a5,4(a0)
    80002854:	0047d79b          	srliw	a5,a5,0x4
    80002858:	0008d597          	auipc	a1,0x8d
    8000285c:	7b85a583          	lw	a1,1976(a1) # 80090010 <sb+0x10>
    80002860:	9dbd                	addw	a1,a1,a5
    80002862:	4108                	lw	a0,0(a0)
    80002864:	00001097          	auipc	ra,0x1
    80002868:	b36080e7          	jalr	-1226(ra) # 8000339a <buf_read>
    8000286c:	892a                	mv	s2,a0
    dip = (struct dinode *) bp->data + ip->inum % IPB;
    8000286e:	04c50793          	addi	a5,a0,76
    80002872:	40c8                	lw	a0,4(s1)
    80002874:	893d                	andi	a0,a0,15
    80002876:	051a                	slli	a0,a0,0x6
    80002878:	953e                	add	a0,a0,a5
    dip->type = ip->type;
    8000287a:	04449703          	lh	a4,68(s1)
    8000287e:	00e51023          	sh	a4,0(a0)
    dip->major = ip->major;
    80002882:	04649703          	lh	a4,70(s1)
    80002886:	00e51123          	sh	a4,2(a0)
    dip->minor = ip->minor;
    8000288a:	04849703          	lh	a4,72(s1)
    8000288e:	00e51223          	sh	a4,4(a0)
    dip->nlink = ip->nlink;
    80002892:	04a49703          	lh	a4,74(s1)
    80002896:	00e51323          	sh	a4,6(a0)
    dip->size = ip->size;
    8000289a:	44f8                	lw	a4,76(s1)
    8000289c:	c518                	sw	a4,8(a0)
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000289e:	03400613          	li	a2,52
    800028a2:	05048593          	addi	a1,s1,80
    800028a6:	0531                	addi	a0,a0,12
    800028a8:	ffffe097          	auipc	ra,0xffffe
    800028ac:	5ea080e7          	jalr	1514(ra) # 80000e92 <memmove>
    buf_write(bp);
    800028b0:	854a                	mv	a0,s2
    800028b2:	00001097          	auipc	ra,0x1
    800028b6:	b1c080e7          	jalr	-1252(ra) # 800033ce <buf_write>
    relse_buf(bp);
    800028ba:	854a                	mv	a0,s2
    800028bc:	00001097          	auipc	ra,0x1
    800028c0:	b2c080e7          	jalr	-1236(ra) # 800033e8 <relse_buf>
}
    800028c4:	60e2                	ld	ra,24(sp)
    800028c6:	6442                	ld	s0,16(sp)
    800028c8:	64a2                	ld	s1,8(sp)
    800028ca:	6902                	ld	s2,0(sp)
    800028cc:	6105                	addi	sp,sp,32
    800028ce:	8082                	ret

00000000800028d0 <get_inode>:

// 通过inum从缓冲池中获取一个inode
struct inode *get_inode(int inum) {
    800028d0:	7179                	addi	sp,sp,-48
    800028d2:	f406                	sd	ra,40(sp)
    800028d4:	f022                	sd	s0,32(sp)
    800028d6:	ec26                	sd	s1,24(sp)
    800028d8:	e84a                	sd	s2,16(sp)
    800028da:	e44e                	sd	s3,8(sp)
    800028dc:	1800                	addi	s0,sp,48
    800028de:	89aa                	mv	s3,a0
    struct inode *ip;
    struct inode *empty;
//    struct buf *bp;
//    struct dinode *dip;

    spin_lock(&inode_cache.lock);
    800028e0:	0008d517          	auipc	a0,0x8d
    800028e4:	73850513          	addi	a0,a0,1848 # 80090018 <inode_cache>
    800028e8:	00001097          	auipc	ra,0x1
    800028ec:	be2080e7          	jalr	-1054(ra) # 800034ca <spin_lock>
    empty = 0;
    800028f0:	4901                	li	s2,0
    for (ip = &inode_cache.inode[0]; ip < &inode_cache.inode[NINODE]; ip++) {
    800028f2:	0008d497          	auipc	s1,0x8d
    800028f6:	73e48493          	addi	s1,s1,1854 # 80090030 <inode_cache+0x18>
        if (ip->ref > 0 && ip->inum == inum) {
    800028fa:	0009861b          	sext.w	a2,s3
    for (ip = &inode_cache.inode[0]; ip < &inode_cache.inode[NINODE]; ip++) {
    800028fe:	0008f697          	auipc	a3,0x8f
    80002902:	1c268693          	addi	a3,a3,450 # 80091ac0 <cache_lock>
    80002906:	a039                	j	80002914 <get_inode+0x44>
            ip->ref++;
            spin_unlock(&inode_cache.lock);
            return ip;
        }
        if (empty == 0 && ip->ref == 0) { // 记住未使用缓冲项
    80002908:	02090e63          	beqz	s2,80002944 <get_inode+0x74>
    for (ip = &inode_cache.inode[0]; ip < &inode_cache.inode[NINODE]; ip++) {
    8000290c:	08848493          	addi	s1,s1,136
    80002910:	02d48d63          	beq	s1,a3,8000294a <get_inode+0x7a>
        if (ip->ref > 0 && ip->inum == inum) {
    80002914:	449c                	lw	a5,8(s1)
    80002916:	fef059e3          	blez	a5,80002908 <get_inode+0x38>
    8000291a:	40d8                	lw	a4,4(s1)
    8000291c:	fec716e3          	bne	a4,a2,80002908 <get_inode+0x38>
            ip->ref++;
    80002920:	2785                	addiw	a5,a5,1
    80002922:	c49c                	sw	a5,8(s1)
            spin_unlock(&inode_cache.lock);
    80002924:	0008d517          	auipc	a0,0x8d
    80002928:	6f450513          	addi	a0,a0,1780 # 80090018 <inode_cache>
    8000292c:	00001097          	auipc	ra,0x1
    80002930:	c72080e7          	jalr	-910(ra) # 8000359e <spin_unlock>
    ip->inum = inum;
    ip->ref = 1;
    ip->valid = 0;
    spin_unlock(&inode_cache.lock);
    return ip;
}
    80002934:	8526                	mv	a0,s1
    80002936:	70a2                	ld	ra,40(sp)
    80002938:	7402                	ld	s0,32(sp)
    8000293a:	64e2                	ld	s1,24(sp)
    8000293c:	6942                	ld	s2,16(sp)
    8000293e:	69a2                	ld	s3,8(sp)
    80002940:	6145                	addi	sp,sp,48
    80002942:	8082                	ret
        if (empty == 0 && ip->ref == 0) { // 记住未使用缓冲项
    80002944:	f7e1                	bnez	a5,8000290c <get_inode+0x3c>
    80002946:	8926                	mv	s2,s1
    80002948:	b7d1                	j	8000290c <get_inode+0x3c>
    if (empty == 0) {
    8000294a:	02090363          	beqz	s2,80002970 <get_inode+0xa0>
    ip->inum = inum;
    8000294e:	01392223          	sw	s3,4(s2)
    ip->ref = 1;
    80002952:	4785                	li	a5,1
    80002954:	00f92423          	sw	a5,8(s2)
    ip->valid = 0;
    80002958:	04092023          	sw	zero,64(s2)
    spin_unlock(&inode_cache.lock);
    8000295c:	0008d517          	auipc	a0,0x8d
    80002960:	6bc50513          	addi	a0,a0,1724 # 80090018 <inode_cache>
    80002964:	00001097          	auipc	ra,0x1
    80002968:	c3a080e7          	jalr	-966(ra) # 8000359e <spin_unlock>
    return ip;
    8000296c:	84ca                	mv	s1,s2
    8000296e:	b7d9                	j	80002934 <get_inode+0x64>
        panic("get_inode");
    80002970:	00003517          	auipc	a0,0x3
    80002974:	a3850513          	addi	a0,a0,-1480 # 800053a8 <digits+0x260>
    80002978:	fffff097          	auipc	ra,0xfffff
    8000297c:	a78080e7          	jalr	-1416(ra) # 800013f0 <panic>
    80002980:	b7f9                	j	8000294e <get_inode+0x7e>

0000000080002982 <alloc_inode>:
struct inode *alloc_inode(short type) {
    80002982:	7139                	addi	sp,sp,-64
    80002984:	fc06                	sd	ra,56(sp)
    80002986:	f822                	sd	s0,48(sp)
    80002988:	f426                	sd	s1,40(sp)
    8000298a:	f04a                	sd	s2,32(sp)
    8000298c:	ec4e                	sd	s3,24(sp)
    8000298e:	e852                	sd	s4,16(sp)
    80002990:	e456                	sd	s5,8(sp)
    80002992:	e05a                	sd	s6,0(sp)
    80002994:	0080                	addi	s0,sp,64
    for (inum = 1; inum < sb.ninodes; inum++) {
    80002996:	0008d717          	auipc	a4,0x8d
    8000299a:	67672703          	lw	a4,1654(a4) # 8009000c <sb+0xc>
    8000299e:	4785                	li	a5,1
    800029a0:	04e7f963          	bgeu	a5,a4,800029f2 <alloc_inode+0x70>
    800029a4:	8b2a                	mv	s6,a0
    800029a6:	4905                	li	s2,1
        bp = buf_read(0, IBLOCK(inum, sb));
    800029a8:	0008da97          	auipc	s5,0x8d
    800029ac:	658a8a93          	addi	s5,s5,1624 # 80090000 <sb>
    800029b0:	00090a1b          	sext.w	s4,s2
    800029b4:	00495593          	srli	a1,s2,0x4
    800029b8:	010aa783          	lw	a5,16(s5)
    800029bc:	9dbd                	addw	a1,a1,a5
    800029be:	4501                	li	a0,0
    800029c0:	00001097          	auipc	ra,0x1
    800029c4:	9da080e7          	jalr	-1574(ra) # 8000339a <buf_read>
    800029c8:	84aa                	mv	s1,a0
        dip = (struct dinode *) bp->data + inum % IPB;
    800029ca:	04c50993          	addi	s3,a0,76
    800029ce:	00fa7793          	andi	a5,s4,15
    800029d2:	079a                	slli	a5,a5,0x6
    800029d4:	99be                	add	s3,s3,a5
        if (dip->type == 0) { // a free inode
    800029d6:	00099783          	lh	a5,0(s3)
    800029da:	cf9d                	beqz	a5,80002a18 <alloc_inode+0x96>
        relse_buf(bp);
    800029dc:	00001097          	auipc	ra,0x1
    800029e0:	a0c080e7          	jalr	-1524(ra) # 800033e8 <relse_buf>
    for (inum = 1; inum < sb.ninodes; inum++) {
    800029e4:	0905                	addi	s2,s2,1
    800029e6:	00caa703          	lw	a4,12(s5)
    800029ea:	0009079b          	sext.w	a5,s2
    800029ee:	fce7e1e3          	bltu	a5,a4,800029b0 <alloc_inode+0x2e>
    panic("alloc_inode: no inodes");
    800029f2:	00003517          	auipc	a0,0x3
    800029f6:	9c650513          	addi	a0,a0,-1594 # 800053b8 <digits+0x270>
    800029fa:	fffff097          	auipc	ra,0xfffff
    800029fe:	9f6080e7          	jalr	-1546(ra) # 800013f0 <panic>
    return 0;
    80002a02:	4501                	li	a0,0
}
    80002a04:	70e2                	ld	ra,56(sp)
    80002a06:	7442                	ld	s0,48(sp)
    80002a08:	74a2                	ld	s1,40(sp)
    80002a0a:	7902                	ld	s2,32(sp)
    80002a0c:	69e2                	ld	s3,24(sp)
    80002a0e:	6a42                	ld	s4,16(sp)
    80002a10:	6aa2                	ld	s5,8(sp)
    80002a12:	6b02                	ld	s6,0(sp)
    80002a14:	6121                	addi	sp,sp,64
    80002a16:	8082                	ret
            memset(dip, 0, sizeof(*dip));
    80002a18:	04000613          	li	a2,64
    80002a1c:	4581                	li	a1,0
    80002a1e:	854e                	mv	a0,s3
    80002a20:	ffffe097          	auipc	ra,0xffffe
    80002a24:	44c080e7          	jalr	1100(ra) # 80000e6c <memset>
            dip->type = type;
    80002a28:	01699023          	sh	s6,0(s3)
            buf_write(bp); // 写回磁盘
    80002a2c:	8526                	mv	a0,s1
    80002a2e:	00001097          	auipc	ra,0x1
    80002a32:	9a0080e7          	jalr	-1632(ra) # 800033ce <buf_write>
            relse_buf(bp);
    80002a36:	8526                	mv	a0,s1
    80002a38:	00001097          	auipc	ra,0x1
    80002a3c:	9b0080e7          	jalr	-1616(ra) # 800033e8 <relse_buf>
            return get_inode(inum);
    80002a40:	8552                	mv	a0,s4
    80002a42:	00000097          	auipc	ra,0x0
    80002a46:	e8e080e7          	jalr	-370(ra) # 800028d0 <get_inode>
    80002a4a:	bf6d                	j	80002a04 <alloc_inode+0x82>

0000000080002a4c <bmap>:
    spin_unlock(&inode_cache.lock);
}

// 数据块包含直接块和间接块，这里只实现了直接块
// 获取inode的第bn个数据块对应的磁盘块号
uint bmap(struct inode *ip, uint bn) {
    80002a4c:	1101                	addi	sp,sp,-32
    80002a4e:	ec06                	sd	ra,24(sp)
    80002a50:	e822                	sd	s0,16(sp)
    80002a52:	e426                	sd	s1,8(sp)
    80002a54:	1000                	addi	s0,sp,32
    uint64 addr;
    if (bn < NDIRECT) {
    80002a56:	47ad                	li	a5,11
    80002a58:	02b7ea63          	bltu	a5,a1,80002a8c <bmap+0x40>
        if ((addr = ip->addrs[bn]) == 0)
    80002a5c:	1582                	slli	a1,a1,0x20
    80002a5e:	9181                	srli	a1,a1,0x20
    80002a60:	058a                	slli	a1,a1,0x2
    80002a62:	00b504b3          	add	s1,a0,a1
    80002a66:	0504e783          	lwu	a5,80(s1)
    80002a6a:	cb81                	beqz	a5,80002a7a <bmap+0x2e>
            ip->addrs[bn] = addr = alloc_disk_block();
        return addr;
    80002a6c:	0007851b          	sext.w	a0,a5
    }

    panic("bmap");
    return 0;
}
    80002a70:	60e2                	ld	ra,24(sp)
    80002a72:	6442                	ld	s0,16(sp)
    80002a74:	64a2                	ld	s1,8(sp)
    80002a76:	6105                	addi	sp,sp,32
    80002a78:	8082                	ret
            ip->addrs[bn] = addr = alloc_disk_block();
    80002a7a:	00000097          	auipc	ra,0x0
    80002a7e:	c02080e7          	jalr	-1022(ra) # 8000267c <alloc_disk_block>
    80002a82:	02051793          	slli	a5,a0,0x20
    80002a86:	9381                	srli	a5,a5,0x20
    80002a88:	c8a8                	sw	a0,80(s1)
    80002a8a:	b7cd                	j	80002a6c <bmap+0x20>
    panic("bmap");
    80002a8c:	00003517          	auipc	a0,0x3
    80002a90:	94450513          	addi	a0,a0,-1724 # 800053d0 <digits+0x288>
    80002a94:	fffff097          	auipc	ra,0xfffff
    80002a98:	95c080e7          	jalr	-1700(ra) # 800013f0 <panic>
    return 0;
    80002a9c:	4501                	li	a0,0
    80002a9e:	bfc9                	j	80002a70 <bmap+0x24>

0000000080002aa0 <trunc_inode>:

// Truncate inode(移除内容)
// 调用者必须持有ip->lock
void trunc_inode(struct inode *ip) {
    80002aa0:	7179                	addi	sp,sp,-48
    80002aa2:	f406                	sd	ra,40(sp)
    80002aa4:	f022                	sd	s0,32(sp)
    80002aa6:	ec26                	sd	s1,24(sp)
    80002aa8:	e84a                	sd	s2,16(sp)
    80002aaa:	e44e                	sd	s3,8(sp)
    80002aac:	e052                	sd	s4,0(sp)
    80002aae:	1800                	addi	s0,sp,48
    80002ab0:	89aa                	mv	s3,a0
    int i, j;
    struct buf *bp;
    uint *a;

    for (i = 0; i < NDIRECT; i++) {
    80002ab2:	05050493          	addi	s1,a0,80
    80002ab6:	08050913          	addi	s2,a0,128
    80002aba:	a021                	j	80002ac2 <trunc_inode+0x22>
    80002abc:	0491                	addi	s1,s1,4
    80002abe:	01248b63          	beq	s1,s2,80002ad4 <trunc_inode+0x34>
        if (ip->addrs[i]) {
    80002ac2:	4088                	lw	a0,0(s1)
    80002ac4:	dd65                	beqz	a0,80002abc <trunc_inode+0x1c>
            free_disk_block(ip->addrs[i]);
    80002ac6:	00000097          	auipc	ra,0x0
    80002aca:	caa080e7          	jalr	-854(ra) # 80002770 <free_disk_block>
            ip->addrs[i] = 0;
    80002ace:	0004a023          	sw	zero,0(s1)
    80002ad2:	b7ed                	j	80002abc <trunc_inode+0x1c>
        }
    }

    if (ip->addrs[NDIRECT]) {
    80002ad4:	0809a583          	lw	a1,128(s3)
    80002ad8:	e185                	bnez	a1,80002af8 <trunc_inode+0x58>
        relse_buf(bp);
        free_disk_block(ip->addrs[NDIRECT]);
        ip->addrs[NDIRECT] = 0;
    }

    ip->size = 0;
    80002ada:	0409a623          	sw	zero,76(s3)
    update_inode(ip);
    80002ade:	854e                	mv	a0,s3
    80002ae0:	00000097          	auipc	ra,0x0
    80002ae4:	d64080e7          	jalr	-668(ra) # 80002844 <update_inode>
}
    80002ae8:	70a2                	ld	ra,40(sp)
    80002aea:	7402                	ld	s0,32(sp)
    80002aec:	64e2                	ld	s1,24(sp)
    80002aee:	6942                	ld	s2,16(sp)
    80002af0:	69a2                	ld	s3,8(sp)
    80002af2:	6a02                	ld	s4,0(sp)
    80002af4:	6145                	addi	sp,sp,48
    80002af6:	8082                	ret
        bp = buf_read(ip->dev, ip->addrs[NDIRECT]);
    80002af8:	0009a503          	lw	a0,0(s3)
    80002afc:	00001097          	auipc	ra,0x1
    80002b00:	89e080e7          	jalr	-1890(ra) # 8000339a <buf_read>
    80002b04:	8a2a                	mv	s4,a0
        for (j = 0; j < NINDIRECT; j++) {
    80002b06:	04c50493          	addi	s1,a0,76
    80002b0a:	44c50913          	addi	s2,a0,1100
    80002b0e:	a801                	j	80002b1e <trunc_inode+0x7e>
                free_disk_block(a[j]);
    80002b10:	00000097          	auipc	ra,0x0
    80002b14:	c60080e7          	jalr	-928(ra) # 80002770 <free_disk_block>
        for (j = 0; j < NINDIRECT; j++) {
    80002b18:	0491                	addi	s1,s1,4
    80002b1a:	01248563          	beq	s1,s2,80002b24 <trunc_inode+0x84>
            if (a[j])
    80002b1e:	4088                	lw	a0,0(s1)
    80002b20:	dd65                	beqz	a0,80002b18 <trunc_inode+0x78>
    80002b22:	b7fd                	j	80002b10 <trunc_inode+0x70>
        relse_buf(bp);
    80002b24:	8552                	mv	a0,s4
    80002b26:	00001097          	auipc	ra,0x1
    80002b2a:	8c2080e7          	jalr	-1854(ra) # 800033e8 <relse_buf>
        free_disk_block(ip->addrs[NDIRECT]);
    80002b2e:	0809a503          	lw	a0,128(s3)
    80002b32:	00000097          	auipc	ra,0x0
    80002b36:	c3e080e7          	jalr	-962(ra) # 80002770 <free_disk_block>
        ip->addrs[NDIRECT] = 0;
    80002b3a:	0809a023          	sw	zero,128(s3)
    80002b3e:	bf71                	j	80002ada <trunc_inode+0x3a>

0000000080002b40 <putback_inode>:
void putback_inode(struct inode *ip) {
    80002b40:	1101                	addi	sp,sp,-32
    80002b42:	ec06                	sd	ra,24(sp)
    80002b44:	e822                	sd	s0,16(sp)
    80002b46:	e426                	sd	s1,8(sp)
    80002b48:	e04a                	sd	s2,0(sp)
    80002b4a:	1000                	addi	s0,sp,32
    80002b4c:	84aa                	mv	s1,a0
    spin_lock(&inode_cache.lock);
    80002b4e:	0008d517          	auipc	a0,0x8d
    80002b52:	4ca50513          	addi	a0,a0,1226 # 80090018 <inode_cache>
    80002b56:	00001097          	auipc	ra,0x1
    80002b5a:	974080e7          	jalr	-1676(ra) # 800034ca <spin_lock>
    if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    80002b5e:	4498                	lw	a4,8(s1)
    80002b60:	4785                	li	a5,1
    80002b62:	02f70363          	beq	a4,a5,80002b88 <putback_inode+0x48>
    ip->ref--;
    80002b66:	449c                	lw	a5,8(s1)
    80002b68:	37fd                	addiw	a5,a5,-1
    80002b6a:	c49c                	sw	a5,8(s1)
    spin_unlock(&inode_cache.lock);
    80002b6c:	0008d517          	auipc	a0,0x8d
    80002b70:	4ac50513          	addi	a0,a0,1196 # 80090018 <inode_cache>
    80002b74:	00001097          	auipc	ra,0x1
    80002b78:	a2a080e7          	jalr	-1494(ra) # 8000359e <spin_unlock>
}
    80002b7c:	60e2                	ld	ra,24(sp)
    80002b7e:	6442                	ld	s0,16(sp)
    80002b80:	64a2                	ld	s1,8(sp)
    80002b82:	6902                	ld	s2,0(sp)
    80002b84:	6105                	addi	sp,sp,32
    80002b86:	8082                	ret
    if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    80002b88:	40bc                	lw	a5,64(s1)
    80002b8a:	dff1                	beqz	a5,80002b66 <putback_inode+0x26>
    80002b8c:	04a49783          	lh	a5,74(s1)
    80002b90:	fbf9                	bnez	a5,80002b66 <putback_inode+0x26>
        sleep_lock(&ip->lock);
    80002b92:	01048913          	addi	s2,s1,16
    80002b96:	854a                	mv	a0,s2
    80002b98:	00001097          	auipc	ra,0x1
    80002b9c:	a9c080e7          	jalr	-1380(ra) # 80003634 <sleep_lock>
        spin_unlock(&inode_cache.lock);
    80002ba0:	0008d517          	auipc	a0,0x8d
    80002ba4:	47850513          	addi	a0,a0,1144 # 80090018 <inode_cache>
    80002ba8:	00001097          	auipc	ra,0x1
    80002bac:	9f6080e7          	jalr	-1546(ra) # 8000359e <spin_unlock>
        trunc_inode(ip);
    80002bb0:	8526                	mv	a0,s1
    80002bb2:	00000097          	auipc	ra,0x0
    80002bb6:	eee080e7          	jalr	-274(ra) # 80002aa0 <trunc_inode>
        ip->type = 0;
    80002bba:	04049223          	sh	zero,68(s1)
        update_inode(ip);
    80002bbe:	8526                	mv	a0,s1
    80002bc0:	00000097          	auipc	ra,0x0
    80002bc4:	c84080e7          	jalr	-892(ra) # 80002844 <update_inode>
        ip->valid = 0;
    80002bc8:	0404a023          	sw	zero,64(s1)
        sleep_unlock(&ip->lock);
    80002bcc:	854a                	mv	a0,s2
    80002bce:	00001097          	auipc	ra,0x1
    80002bd2:	abc080e7          	jalr	-1348(ra) # 8000368a <sleep_unlock>
        spin_lock(&inode_cache.lock);
    80002bd6:	0008d517          	auipc	a0,0x8d
    80002bda:	44250513          	addi	a0,a0,1090 # 80090018 <inode_cache>
    80002bde:	00001097          	auipc	ra,0x1
    80002be2:	8ec080e7          	jalr	-1812(ra) # 800034ca <spin_lock>
    80002be6:	b741                	j	80002b66 <putback_inode+0x26>

0000000080002be8 <dup_inode>:

// 递增ip->ref
struct inode *dup_inode(struct inode *ip) {
    80002be8:	1101                	addi	sp,sp,-32
    80002bea:	ec06                	sd	ra,24(sp)
    80002bec:	e822                	sd	s0,16(sp)
    80002bee:	e426                	sd	s1,8(sp)
    80002bf0:	1000                	addi	s0,sp,32
    80002bf2:	84aa                	mv	s1,a0
    spin_lock(&inode_cache.lock);
    80002bf4:	0008d517          	auipc	a0,0x8d
    80002bf8:	42450513          	addi	a0,a0,1060 # 80090018 <inode_cache>
    80002bfc:	00001097          	auipc	ra,0x1
    80002c00:	8ce080e7          	jalr	-1842(ra) # 800034ca <spin_lock>
    ip->ref++;
    80002c04:	449c                	lw	a5,8(s1)
    80002c06:	2785                	addiw	a5,a5,1
    80002c08:	c49c                	sw	a5,8(s1)
    spin_unlock(&inode_cache.lock);
    80002c0a:	0008d517          	auipc	a0,0x8d
    80002c0e:	40e50513          	addi	a0,a0,1038 # 80090018 <inode_cache>
    80002c12:	00001097          	auipc	ra,0x1
    80002c16:	98c080e7          	jalr	-1652(ra) # 8000359e <spin_unlock>
    return ip;
}
    80002c1a:	8526                	mv	a0,s1
    80002c1c:	60e2                	ld	ra,24(sp)
    80002c1e:	6442                	ld	s0,16(sp)
    80002c20:	64a2                	ld	s1,8(sp)
    80002c22:	6105                	addi	sp,sp,32
    80002c24:	8082                	ret

0000000080002c26 <lock_inode>:

// 锁定给定的inode
// 需要时读取从磁盘读数据
void lock_inode(struct inode *ip) {
    80002c26:	1101                	addi	sp,sp,-32
    80002c28:	ec06                	sd	ra,24(sp)
    80002c2a:	e822                	sd	s0,16(sp)
    80002c2c:	e426                	sd	s1,8(sp)
    80002c2e:	e04a                	sd	s2,0(sp)
    80002c30:	1000                	addi	s0,sp,32
    80002c32:	84aa                	mv	s1,a0
    struct buf *bp;
    struct dinode *dip;

    if (ip == 0 || ip->ref < 1)
    80002c34:	c501                	beqz	a0,80002c3c <lock_inode+0x16>
    80002c36:	451c                	lw	a5,8(a0)
    80002c38:	00f04a63          	bgtz	a5,80002c4c <lock_inode+0x26>
        panic("lock_inode");
    80002c3c:	00002517          	auipc	a0,0x2
    80002c40:	79c50513          	addi	a0,a0,1948 # 800053d8 <digits+0x290>
    80002c44:	ffffe097          	auipc	ra,0xffffe
    80002c48:	7ac080e7          	jalr	1964(ra) # 800013f0 <panic>

    sleep_lock(&ip->lock);
    80002c4c:	01048513          	addi	a0,s1,16
    80002c50:	00001097          	auipc	ra,0x1
    80002c54:	9e4080e7          	jalr	-1564(ra) # 80003634 <sleep_lock>

    if (ip->valid == 0) {
    80002c58:	40bc                	lw	a5,64(s1)
    80002c5a:	c799                	beqz	a5,80002c68 <lock_inode+0x42>
        relse_buf(bp);
        ip->valid = 1;
        if (ip->type == 0)
            panic("lock_inode: no type");
    }
}
    80002c5c:	60e2                	ld	ra,24(sp)
    80002c5e:	6442                	ld	s0,16(sp)
    80002c60:	64a2                	ld	s1,8(sp)
    80002c62:	6902                	ld	s2,0(sp)
    80002c64:	6105                	addi	sp,sp,32
    80002c66:	8082                	ret
        bp = buf_read(ip->dev, IBLOCK(ip->inum, sb));
    80002c68:	40dc                	lw	a5,4(s1)
    80002c6a:	0047d79b          	srliw	a5,a5,0x4
    80002c6e:	0008d597          	auipc	a1,0x8d
    80002c72:	3a25a583          	lw	a1,930(a1) # 80090010 <sb+0x10>
    80002c76:	9dbd                	addw	a1,a1,a5
    80002c78:	4088                	lw	a0,0(s1)
    80002c7a:	00000097          	auipc	ra,0x0
    80002c7e:	720080e7          	jalr	1824(ra) # 8000339a <buf_read>
    80002c82:	892a                	mv	s2,a0
        dip = (struct dinode *) bp->data + ip->inum % IPB;
    80002c84:	04c50593          	addi	a1,a0,76
    80002c88:	40dc                	lw	a5,4(s1)
    80002c8a:	8bbd                	andi	a5,a5,15
    80002c8c:	079a                	slli	a5,a5,0x6
    80002c8e:	95be                	add	a1,a1,a5
        ip->type = dip->type;
    80002c90:	00059783          	lh	a5,0(a1)
    80002c94:	04f49223          	sh	a5,68(s1)
        ip->major = dip->major;
    80002c98:	00259783          	lh	a5,2(a1)
    80002c9c:	04f49323          	sh	a5,70(s1)
        ip->minor = dip->minor;
    80002ca0:	00459783          	lh	a5,4(a1)
    80002ca4:	04f49423          	sh	a5,72(s1)
        ip->nlink = dip->nlink;
    80002ca8:	00659783          	lh	a5,6(a1)
    80002cac:	04f49523          	sh	a5,74(s1)
        ip->size = dip->size;
    80002cb0:	459c                	lw	a5,8(a1)
    80002cb2:	c4fc                	sw	a5,76(s1)
        memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002cb4:	03400613          	li	a2,52
    80002cb8:	05b1                	addi	a1,a1,12
    80002cba:	05048513          	addi	a0,s1,80
    80002cbe:	ffffe097          	auipc	ra,0xffffe
    80002cc2:	1d4080e7          	jalr	468(ra) # 80000e92 <memmove>
        relse_buf(bp);
    80002cc6:	854a                	mv	a0,s2
    80002cc8:	00000097          	auipc	ra,0x0
    80002ccc:	720080e7          	jalr	1824(ra) # 800033e8 <relse_buf>
        ip->valid = 1;
    80002cd0:	4785                	li	a5,1
    80002cd2:	c0bc                	sw	a5,64(s1)
        if (ip->type == 0)
    80002cd4:	04449783          	lh	a5,68(s1)
    80002cd8:	f3d1                	bnez	a5,80002c5c <lock_inode+0x36>
            panic("lock_inode: no type");
    80002cda:	00002517          	auipc	a0,0x2
    80002cde:	70e50513          	addi	a0,a0,1806 # 800053e8 <digits+0x2a0>
    80002ce2:	ffffe097          	auipc	ra,0xffffe
    80002ce6:	70e080e7          	jalr	1806(ra) # 800013f0 <panic>
}
    80002cea:	bf8d                	j	80002c5c <lock_inode+0x36>

0000000080002cec <unlock_inode>:

// 解锁inode.
void unlock_inode(struct inode *ip) {
    80002cec:	1101                	addi	sp,sp,-32
    80002cee:	ec06                	sd	ra,24(sp)
    80002cf0:	e822                	sd	s0,16(sp)
    80002cf2:	e426                	sd	s1,8(sp)
    80002cf4:	1000                	addi	s0,sp,32
    80002cf6:	84aa                	mv	s1,a0
    if (ip == 0 || !sleep_holding(&ip->lock) || ip->ref < 1)
    80002cf8:	c911                	beqz	a0,80002d0c <unlock_inode+0x20>
    80002cfa:	0541                	addi	a0,a0,16
    80002cfc:	00001097          	auipc	ra,0x1
    80002d00:	9d2080e7          	jalr	-1582(ra) # 800036ce <sleep_holding>
    80002d04:	c501                	beqz	a0,80002d0c <unlock_inode+0x20>
    80002d06:	449c                	lw	a5,8(s1)
    80002d08:	00f04a63          	bgtz	a5,80002d1c <unlock_inode+0x30>
        panic("unlock_inode");
    80002d0c:	00002517          	auipc	a0,0x2
    80002d10:	6f450513          	addi	a0,a0,1780 # 80005400 <digits+0x2b8>
    80002d14:	ffffe097          	auipc	ra,0xffffe
    80002d18:	6dc080e7          	jalr	1756(ra) # 800013f0 <panic>
    sleep_unlock(&ip->lock);
    80002d1c:	01048513          	addi	a0,s1,16
    80002d20:	00001097          	auipc	ra,0x1
    80002d24:	96a080e7          	jalr	-1686(ra) # 8000368a <sleep_unlock>
}
    80002d28:	60e2                	ld	ra,24(sp)
    80002d2a:	6442                	ld	s0,16(sp)
    80002d2c:	64a2                	ld	s1,8(sp)
    80002d2e:	6105                	addi	sp,sp,32
    80002d30:	8082                	ret

0000000080002d32 <unlock_and_putback>:

void unlock_and_putback(struct inode *ip) {
    80002d32:	1101                	addi	sp,sp,-32
    80002d34:	ec06                	sd	ra,24(sp)
    80002d36:	e822                	sd	s0,16(sp)
    80002d38:	e426                	sd	s1,8(sp)
    80002d3a:	1000                	addi	s0,sp,32
    80002d3c:	84aa                	mv	s1,a0
    unlock_inode(ip);
    80002d3e:	00000097          	auipc	ra,0x0
    80002d42:	fae080e7          	jalr	-82(ra) # 80002cec <unlock_inode>
    putback_inode(ip);
    80002d46:	8526                	mv	a0,s1
    80002d48:	00000097          	auipc	ra,0x0
    80002d4c:	df8080e7          	jalr	-520(ra) # 80002b40 <putback_inode>
}
    80002d50:	60e2                	ld	ra,24(sp)
    80002d52:	6442                	ld	s0,16(sp)
    80002d54:	64a2                	ld	s1,8(sp)
    80002d56:	6105                	addi	sp,sp,32
    80002d58:	8082                	ret

0000000080002d5a <read_inode>:

// 从inode中读取数据
int read_inode(struct inode *ip, uint64 dst, uint off, int n) {
    80002d5a:	711d                	addi	sp,sp,-96
    80002d5c:	ec86                	sd	ra,88(sp)
    80002d5e:	e8a2                	sd	s0,80(sp)
    80002d60:	e4a6                	sd	s1,72(sp)
    80002d62:	e0ca                	sd	s2,64(sp)
    80002d64:	fc4e                	sd	s3,56(sp)
    80002d66:	f852                	sd	s4,48(sp)
    80002d68:	f456                	sd	s5,40(sp)
    80002d6a:	f05a                	sd	s6,32(sp)
    80002d6c:	ec5e                	sd	s7,24(sp)
    80002d6e:	e862                	sd	s8,16(sp)
    80002d70:	e466                	sd	s9,8(sp)
    80002d72:	1080                	addi	s0,sp,96
    int total = 0, m = 0;
    struct buf *bp;
    if (off > ip->size || off + n < off) {
    80002d74:	457c                	lw	a5,76(a0)
        return 0;
    80002d76:	4981                	li	s3,0
    if (off > ip->size || off + n < off) {
    80002d78:	02c7e463          	bltu	a5,a2,80002da0 <read_inode+0x46>
    80002d7c:	8baa                	mv	s7,a0
    80002d7e:	8aae                	mv	s5,a1
    80002d80:	84b2                	mv	s1,a2
    80002d82:	8b36                	mv	s6,a3
    80002d84:	00c6873b          	addw	a4,a3,a2
        return 0;
    80002d88:	4981                	li	s3,0
    if (off > ip->size || off + n < off) {
    80002d8a:	00c76b63          	bltu	a4,a2,80002da0 <read_inode+0x46>
    }
    if (off + n > ip->size) {
    80002d8e:	00e7f463          	bgeu	a5,a4,80002d96 <read_inode+0x3c>
        n = ip->size - off;
    80002d92:	40c78b3b          	subw	s6,a5,a2
    }

    for (; total < n; total += m, off += m, dst += m) {
    80002d96:	4981                	li	s3,0
        bp = buf_read(0, bmap(ip, off / BSIZE));
        m = min(BSIZE - off % BSIZE, n - total);
    80002d98:	40000c13          	li	s8,1024
    for (; total < n; total += m, off += m, dst += m) {
    80002d9c:	05604763          	bgtz	s6,80002dea <read_inode+0x90>
        memmove((uint64 *) (dst), bp->data + (off % BSIZE), m);
        relse_buf(bp);
    }
    return total;
}
    80002da0:	854e                	mv	a0,s3
    80002da2:	60e6                	ld	ra,88(sp)
    80002da4:	6446                	ld	s0,80(sp)
    80002da6:	64a6                	ld	s1,72(sp)
    80002da8:	6906                	ld	s2,64(sp)
    80002daa:	79e2                	ld	s3,56(sp)
    80002dac:	7a42                	ld	s4,48(sp)
    80002dae:	7aa2                	ld	s5,40(sp)
    80002db0:	7b02                	ld	s6,32(sp)
    80002db2:	6be2                	ld	s7,24(sp)
    80002db4:	6c42                	ld	s8,16(sp)
    80002db6:	6ca2                	ld	s9,8(sp)
    80002db8:	6125                	addi	sp,sp,96
    80002dba:	8082                	ret
        m = min(BSIZE - off % BSIZE, n - total);
    80002dbc:	000a0c9b          	sext.w	s9,s4
        memmove((uint64 *) (dst), bp->data + (off % BSIZE), m);
    80002dc0:	04c90593          	addi	a1,s2,76
    80002dc4:	8666                	mv	a2,s9
    80002dc6:	95ba                	add	a1,a1,a4
    80002dc8:	8556                	mv	a0,s5
    80002dca:	ffffe097          	auipc	ra,0xffffe
    80002dce:	0c8080e7          	jalr	200(ra) # 80000e92 <memmove>
        relse_buf(bp);
    80002dd2:	854a                	mv	a0,s2
    80002dd4:	00000097          	auipc	ra,0x0
    80002dd8:	614080e7          	jalr	1556(ra) # 800033e8 <relse_buf>
    for (; total < n; total += m, off += m, dst += m) {
    80002ddc:	013a09bb          	addw	s3,s4,s3
    80002de0:	009a04bb          	addw	s1,s4,s1
    80002de4:	9ae6                	add	s5,s5,s9
    80002de6:	fb69dde3          	bge	s3,s6,80002da0 <read_inode+0x46>
        bp = buf_read(0, bmap(ip, off / BSIZE));
    80002dea:	00a4d59b          	srliw	a1,s1,0xa
    80002dee:	855e                	mv	a0,s7
    80002df0:	00000097          	auipc	ra,0x0
    80002df4:	c5c080e7          	jalr	-932(ra) # 80002a4c <bmap>
    80002df8:	0005059b          	sext.w	a1,a0
    80002dfc:	4501                	li	a0,0
    80002dfe:	00000097          	auipc	ra,0x0
    80002e02:	59c080e7          	jalr	1436(ra) # 8000339a <buf_read>
    80002e06:	892a                	mv	s2,a0
        m = min(BSIZE - off % BSIZE, n - total);
    80002e08:	3ff4f713          	andi	a4,s1,1023
    80002e0c:	413b07bb          	subw	a5,s6,s3
    80002e10:	40ec06bb          	subw	a3,s8,a4
    80002e14:	8a3e                	mv	s4,a5
    80002e16:	2781                	sext.w	a5,a5
    80002e18:	0006861b          	sext.w	a2,a3
    80002e1c:	faf670e3          	bgeu	a2,a5,80002dbc <read_inode+0x62>
    80002e20:	8a36                	mv	s4,a3
    80002e22:	bf69                	j	80002dbc <read_inode+0x62>

0000000080002e24 <write_inode>:

// 将数据写入inode
int write_inode(struct inode *ip, uint64 src, uint64 off, int n) {
    80002e24:	711d                	addi	sp,sp,-96
    80002e26:	ec86                	sd	ra,88(sp)
    80002e28:	e8a2                	sd	s0,80(sp)
    80002e2a:	e4a6                	sd	s1,72(sp)
    80002e2c:	e0ca                	sd	s2,64(sp)
    80002e2e:	fc4e                	sd	s3,56(sp)
    80002e30:	f852                	sd	s4,48(sp)
    80002e32:	f456                	sd	s5,40(sp)
    80002e34:	f05a                	sd	s6,32(sp)
    80002e36:	ec5e                	sd	s7,24(sp)
    80002e38:	e862                	sd	s8,16(sp)
    80002e3a:	e466                	sd	s9,8(sp)
    80002e3c:	1080                	addi	s0,sp,96
    uint total, m;
    struct buf *bp;

    if (off > ip->size || off + n < off)
    80002e3e:	04c56783          	lwu	a5,76(a0)
    80002e42:	0cc7e763          	bltu	a5,a2,80002f10 <write_inode+0xec>
    80002e46:	8baa                	mv	s7,a0
    80002e48:	8aae                	mv	s5,a1
    80002e4a:	89b2                	mv	s3,a2
    80002e4c:	8cb6                	mv	s9,a3
    80002e4e:	00c687b3          	add	a5,a3,a2
    80002e52:	0cc7e163          	bltu	a5,a2,80002f14 <write_inode+0xf0>
        return -1;
    if (off + n > MAXFILE * BSIZE)
    80002e56:	00043737          	lui	a4,0x43
    80002e5a:	0af76f63          	bltu	a4,a5,80002f18 <write_inode+0xf4>
        return -1;
    for (total = 0; total < n; total += m, off += m, src += m) {
    80002e5e:	00068b1b          	sext.w	s6,a3
    80002e62:	0a0b0d63          	beqz	s6,80002f1c <write_inode+0xf8>
    80002e66:	4a01                	li	s4,0
        bp = buf_read(0, bmap(ip, off / BSIZE));
        m = min(BSIZE - off % BSIZE, n - total);
    80002e68:	40000c13          	li	s8,1024
    80002e6c:	a81d                	j	80002ea2 <write_inode+0x7e>
        memmove(bp->data + (off % BSIZE), (uint64 *) (src), m);
    80002e6e:	04c90513          	addi	a0,s2,76
    80002e72:	0004861b          	sext.w	a2,s1
    80002e76:	85d6                	mv	a1,s5
    80002e78:	953e                	add	a0,a0,a5
    80002e7a:	ffffe097          	auipc	ra,0xffffe
    80002e7e:	018080e7          	jalr	24(ra) # 80000e92 <memmove>
        buf_write(bp);
    80002e82:	854a                	mv	a0,s2
    80002e84:	00000097          	auipc	ra,0x0
    80002e88:	54a080e7          	jalr	1354(ra) # 800033ce <buf_write>
        relse_buf(bp);
    80002e8c:	854a                	mv	a0,s2
    80002e8e:	00000097          	auipc	ra,0x0
    80002e92:	55a080e7          	jalr	1370(ra) # 800033e8 <relse_buf>
    for (total = 0; total < n; total += m, off += m, src += m) {
    80002e96:	01448a3b          	addw	s4,s1,s4
    80002e9a:	99a6                	add	s3,s3,s1
    80002e9c:	9aa6                	add	s5,s5,s1
    80002e9e:	036a7e63          	bgeu	s4,s6,80002eda <write_inode+0xb6>
        bp = buf_read(0, bmap(ip, off / BSIZE));
    80002ea2:	00a9d593          	srli	a1,s3,0xa
    80002ea6:	2581                	sext.w	a1,a1
    80002ea8:	855e                	mv	a0,s7
    80002eaa:	00000097          	auipc	ra,0x0
    80002eae:	ba2080e7          	jalr	-1118(ra) # 80002a4c <bmap>
    80002eb2:	0005059b          	sext.w	a1,a0
    80002eb6:	4501                	li	a0,0
    80002eb8:	00000097          	auipc	ra,0x0
    80002ebc:	4e2080e7          	jalr	1250(ra) # 8000339a <buf_read>
    80002ec0:	892a                	mv	s2,a0
        m = min(BSIZE - off % BSIZE, n - total);
    80002ec2:	3ff9f793          	andi	a5,s3,1023
    80002ec6:	414b04bb          	subw	s1,s6,s4
    80002eca:	40fc0733          	sub	a4,s8,a5
    80002ece:	1482                	slli	s1,s1,0x20
    80002ed0:	9081                	srli	s1,s1,0x20
    80002ed2:	f8977ee3          	bgeu	a4,s1,80002e6e <write_inode+0x4a>
    80002ed6:	84ba                	mv	s1,a4
    80002ed8:	bf59                	j	80002e6e <write_inode+0x4a>
    }
    if (n > 0) {
    80002eda:	01905d63          	blez	s9,80002ef4 <write_inode+0xd0>
        if (off > ip->size)
    80002ede:	04cbe783          	lwu	a5,76(s7) # 204c <_entry-0x7fffdfb4>
    80002ee2:	0137f463          	bgeu	a5,s3,80002eea <write_inode+0xc6>
            ip->size = off;
    80002ee6:	053ba623          	sw	s3,76(s7)
        // 将内存中的inode写入磁盘，即使没有写入数据，也需要更新，因为循环中可能
        //调用了bmap()或者在ip->addrs[]里面添加了数据块
        update_inode(ip);
    80002eea:	855e                	mv	a0,s7
    80002eec:	00000097          	auipc	ra,0x0
    80002ef0:	958080e7          	jalr	-1704(ra) # 80002844 <update_inode>
    }
    return n;
}
    80002ef4:	8566                	mv	a0,s9
    80002ef6:	60e6                	ld	ra,88(sp)
    80002ef8:	6446                	ld	s0,80(sp)
    80002efa:	64a6                	ld	s1,72(sp)
    80002efc:	6906                	ld	s2,64(sp)
    80002efe:	79e2                	ld	s3,56(sp)
    80002f00:	7a42                	ld	s4,48(sp)
    80002f02:	7aa2                	ld	s5,40(sp)
    80002f04:	7b02                	ld	s6,32(sp)
    80002f06:	6be2                	ld	s7,24(sp)
    80002f08:	6c42                	ld	s8,16(sp)
    80002f0a:	6ca2                	ld	s9,8(sp)
    80002f0c:	6125                	addi	sp,sp,96
    80002f0e:	8082                	ret
        return -1;
    80002f10:	5cfd                	li	s9,-1
    80002f12:	b7cd                	j	80002ef4 <write_inode+0xd0>
    80002f14:	5cfd                	li	s9,-1
    80002f16:	bff9                	j	80002ef4 <write_inode+0xd0>
        return -1;
    80002f18:	5cfd                	li	s9,-1
    80002f1a:	bfe9                	j	80002ef4 <write_inode+0xd0>
    return n;
    80002f1c:	4c81                	li	s9,0
    80002f1e:	bfd9                	j	80002ef4 <write_inode+0xd0>

0000000080002f20 <namecmp>:
// 目录层
//
// 第一个inode为根目录，该目录在mkfs/makefs下创建
//

int namecmp(const char *s, const char *t) {
    80002f20:	1141                	addi	sp,sp,-16
    80002f22:	e406                	sd	ra,8(sp)
    80002f24:	e022                	sd	s0,0(sp)
    80002f26:	0800                	addi	s0,sp,16
    return strncmp(s, t, DIRSIZ);
    80002f28:	4639                	li	a2,14
    80002f2a:	ffffe097          	auipc	ra,0xffffe
    80002f2e:	0a6080e7          	jalr	166(ra) # 80000fd0 <strncmp>
}
    80002f32:	60a2                	ld	ra,8(sp)
    80002f34:	6402                	ld	s0,0(sp)
    80002f36:	0141                	addi	sp,sp,16
    80002f38:	8082                	ret

0000000080002f3a <dirlookup>:
//
//  dirlookup 在一个目录中搜索一个带有给定名称的条目。如果找到
// 了，它返回一个指向相应 inode 的指针，解锁该 inode，并将*poff
// 设置为目录中条目的字节偏移量，以便调用者编辑它。
//
struct inode *dirlookup(struct inode *dp, char *name, uint *poff) {
    80002f3a:	715d                	addi	sp,sp,-80
    80002f3c:	e486                	sd	ra,72(sp)
    80002f3e:	e0a2                	sd	s0,64(sp)
    80002f40:	fc26                	sd	s1,56(sp)
    80002f42:	f84a                	sd	s2,48(sp)
    80002f44:	f44e                	sd	s3,40(sp)
    80002f46:	f052                	sd	s4,32(sp)
    80002f48:	ec56                	sd	s5,24(sp)
    80002f4a:	0880                	addi	s0,sp,80
    80002f4c:	892a                	mv	s2,a0
    80002f4e:	89ae                	mv	s3,a1
    80002f50:	8ab2                	mv	s5,a2
    uint off, inum;
    struct direntry de;

    if (dp->type != T_DIR)
    80002f52:	04451703          	lh	a4,68(a0)
    80002f56:	4785                	li	a5,1
    80002f58:	00f71b63          	bne	a4,a5,80002f6e <dirlookup+0x34>
        panic("dirlookup not DIR");

    for (off = 0; off < dp->size; off += sizeof(de)) {
    80002f5c:	04c92783          	lw	a5,76(s2)
    80002f60:	c7d9                	beqz	a5,80002fee <dirlookup+0xb4>
    80002f62:	4481                	li	s1,0
        if (read_inode(dp, (uint64) &de, off, sizeof(de)) != sizeof(de))
            panic("dirlookup read");
    80002f64:	00002a17          	auipc	s4,0x2
    80002f68:	4c4a0a13          	addi	s4,s4,1220 # 80005428 <digits+0x2e0>
    80002f6c:	a02d                	j	80002f96 <dirlookup+0x5c>
        panic("dirlookup not DIR");
    80002f6e:	00002517          	auipc	a0,0x2
    80002f72:	4a250513          	addi	a0,a0,1186 # 80005410 <digits+0x2c8>
    80002f76:	ffffe097          	auipc	ra,0xffffe
    80002f7a:	47a080e7          	jalr	1146(ra) # 800013f0 <panic>
    80002f7e:	bff9                	j	80002f5c <dirlookup+0x22>
            panic("dirlookup read");
    80002f80:	8552                	mv	a0,s4
    80002f82:	ffffe097          	auipc	ra,0xffffe
    80002f86:	46e080e7          	jalr	1134(ra) # 800013f0 <panic>
    80002f8a:	a015                	j	80002fae <dirlookup+0x74>
    for (off = 0; off < dp->size; off += sizeof(de)) {
    80002f8c:	24c1                	addiw	s1,s1,16
    80002f8e:	04c92783          	lw	a5,76(s2)
    80002f92:	04f4f463          	bgeu	s1,a5,80002fda <dirlookup+0xa0>
        if (read_inode(dp, (uint64) &de, off, sizeof(de)) != sizeof(de))
    80002f96:	46c1                	li	a3,16
    80002f98:	8626                	mv	a2,s1
    80002f9a:	fb040593          	addi	a1,s0,-80
    80002f9e:	854a                	mv	a0,s2
    80002fa0:	00000097          	auipc	ra,0x0
    80002fa4:	dba080e7          	jalr	-582(ra) # 80002d5a <read_inode>
    80002fa8:	47c1                	li	a5,16
    80002faa:	fcf51be3          	bne	a0,a5,80002f80 <dirlookup+0x46>
        if (de.inum == 0)
    80002fae:	fb045783          	lhu	a5,-80(s0)
    80002fb2:	dfe9                	beqz	a5,80002f8c <dirlookup+0x52>
            continue;
        if (namecmp(name, de.name) == 0) {
    80002fb4:	fb240593          	addi	a1,s0,-78
    80002fb8:	854e                	mv	a0,s3
    80002fba:	00000097          	auipc	ra,0x0
    80002fbe:	f66080e7          	jalr	-154(ra) # 80002f20 <namecmp>
    80002fc2:	f569                	bnez	a0,80002f8c <dirlookup+0x52>
            // 该目录包含该该名称
            if (poff)
    80002fc4:	000a8463          	beqz	s5,80002fcc <dirlookup+0x92>
                *poff = off;
    80002fc8:	009aa023          	sw	s1,0(s5)
            inum = de.inum;
            return get_inode(inum);
    80002fcc:	fb045503          	lhu	a0,-80(s0)
    80002fd0:	00000097          	auipc	ra,0x0
    80002fd4:	900080e7          	jalr	-1792(ra) # 800028d0 <get_inode>
    80002fd8:	a011                	j	80002fdc <dirlookup+0xa2>
        }
    }

    return 0;
    80002fda:	4501                	li	a0,0
}
    80002fdc:	60a6                	ld	ra,72(sp)
    80002fde:	6406                	ld	s0,64(sp)
    80002fe0:	74e2                	ld	s1,56(sp)
    80002fe2:	7942                	ld	s2,48(sp)
    80002fe4:	79a2                	ld	s3,40(sp)
    80002fe6:	7a02                	ld	s4,32(sp)
    80002fe8:	6ae2                	ld	s5,24(sp)
    80002fea:	6161                	addi	sp,sp,80
    80002fec:	8082                	ret
    return 0;
    80002fee:	4501                	li	a0,0
    80002ff0:	b7f5                	j	80002fdc <dirlookup+0xa2>

0000000080002ff2 <namex>:

// 根据path返回一个inode
// 该函数供nameiparent和namei使用
// 如果parent!=0返回父目录的inode并且复制最后一个元素到name中，
// name必须拥有足够的空间来存储DIRSIZE字节的字符串。
static struct inode *namex(char *path, int nameiparent, char *name) {
    80002ff2:	711d                	addi	sp,sp,-96
    80002ff4:	ec86                	sd	ra,88(sp)
    80002ff6:	e8a2                	sd	s0,80(sp)
    80002ff8:	e4a6                	sd	s1,72(sp)
    80002ffa:	e0ca                	sd	s2,64(sp)
    80002ffc:	fc4e                	sd	s3,56(sp)
    80002ffe:	f852                	sd	s4,48(sp)
    80003000:	f456                	sd	s5,40(sp)
    80003002:	f05a                	sd	s6,32(sp)
    80003004:	ec5e                	sd	s7,24(sp)
    80003006:	e862                	sd	s8,16(sp)
    80003008:	e466                	sd	s9,8(sp)
    8000300a:	1080                	addi	s0,sp,96
    8000300c:	84aa                	mv	s1,a0
    8000300e:	8b2e                	mv	s6,a1
    80003010:	8ab2                	mv	s5,a2
    struct inode *ip, *next;
    struct proc *p = myproc();
    80003012:	ffffe097          	auipc	ra,0xffffe
    80003016:	824080e7          	jalr	-2012(ra) # 80000836 <myproc>
    if (*path == '/')
    8000301a:	0004c703          	lbu	a4,0(s1)
    8000301e:	02f00793          	li	a5,47
    80003022:	00f70f63          	beq	a4,a5,80003040 <namex+0x4e>
        ip = get_inode(ROOTINO);
    else
        ip = get_inode(p->current_dir->inum); // TODO 修改：从进程的当前path
    80003026:	693c                	ld	a5,80(a0)
    80003028:	43c8                	lw	a0,4(a5)
    8000302a:	00000097          	auipc	ra,0x0
    8000302e:	8a6080e7          	jalr	-1882(ra) # 800028d0 <get_inode>
    80003032:	89aa                	mv	s3,a0
    while (*path == '/')
    80003034:	02f00913          	li	s2,47
    len = path - s;
    80003038:	4b81                	li	s7,0
    if (len >= DIRSIZ)
    8000303a:	4cb5                	li	s9,13

    while ((path = skipelem(path, name)) != 0) {
        lock_inode(ip);
        if (ip->type != T_DIR) {
    8000303c:	4c05                	li	s8,1
    8000303e:	a84d                	j	800030f0 <namex+0xfe>
        ip = get_inode(ROOTINO);
    80003040:	4501                	li	a0,0
    80003042:	00000097          	auipc	ra,0x0
    80003046:	88e080e7          	jalr	-1906(ra) # 800028d0 <get_inode>
    8000304a:	89aa                	mv	s3,a0
    8000304c:	b7e5                	j	80003034 <namex+0x42>
            unlock_and_putback(ip);
    8000304e:	854e                	mv	a0,s3
    80003050:	00000097          	auipc	ra,0x0
    80003054:	ce2080e7          	jalr	-798(ra) # 80002d32 <unlock_and_putback>
            return 0;
    80003058:	4981                	li	s3,0
    if (nameiparent) {
        putback_inode(ip);
        return 0;
    }
    return ip;
}
    8000305a:	854e                	mv	a0,s3
    8000305c:	60e6                	ld	ra,88(sp)
    8000305e:	6446                	ld	s0,80(sp)
    80003060:	64a6                	ld	s1,72(sp)
    80003062:	6906                	ld	s2,64(sp)
    80003064:	79e2                	ld	s3,56(sp)
    80003066:	7a42                	ld	s4,48(sp)
    80003068:	7aa2                	ld	s5,40(sp)
    8000306a:	7b02                	ld	s6,32(sp)
    8000306c:	6be2                	ld	s7,24(sp)
    8000306e:	6c42                	ld	s8,16(sp)
    80003070:	6ca2                	ld	s9,8(sp)
    80003072:	6125                	addi	sp,sp,96
    80003074:	8082                	ret
            unlock_inode(ip);
    80003076:	854e                	mv	a0,s3
    80003078:	00000097          	auipc	ra,0x0
    8000307c:	c74080e7          	jalr	-908(ra) # 80002cec <unlock_inode>
            return ip;
    80003080:	bfe9                	j	8000305a <namex+0x68>
            unlock_and_putback(ip);
    80003082:	854e                	mv	a0,s3
    80003084:	00000097          	auipc	ra,0x0
    80003088:	cae080e7          	jalr	-850(ra) # 80002d32 <unlock_and_putback>
            return 0;
    8000308c:	89d2                	mv	s3,s4
    8000308e:	b7f1                	j	8000305a <namex+0x68>
    len = path - s;
    80003090:	40b48a3b          	subw	s4,s1,a1
    if (len >= DIRSIZ)
    80003094:	094cd363          	bge	s9,s4,8000311a <namex+0x128>
        memmove(name, s, DIRSIZ);
    80003098:	4639                	li	a2,14
    8000309a:	8556                	mv	a0,s5
    8000309c:	ffffe097          	auipc	ra,0xffffe
    800030a0:	df6080e7          	jalr	-522(ra) # 80000e92 <memmove>
    while (*path == '/')
    800030a4:	0004c783          	lbu	a5,0(s1)
    800030a8:	01279763          	bne	a5,s2,800030b6 <namex+0xc4>
        path++;
    800030ac:	0485                	addi	s1,s1,1
    while (*path == '/')
    800030ae:	0004c783          	lbu	a5,0(s1)
    800030b2:	ff278de3          	beq	a5,s2,800030ac <namex+0xba>
        lock_inode(ip);
    800030b6:	854e                	mv	a0,s3
    800030b8:	00000097          	auipc	ra,0x0
    800030bc:	b6e080e7          	jalr	-1170(ra) # 80002c26 <lock_inode>
        if (ip->type != T_DIR) {
    800030c0:	04499783          	lh	a5,68(s3)
    800030c4:	f98795e3          	bne	a5,s8,8000304e <namex+0x5c>
        if (nameiparent && *path == '\0') {
    800030c8:	000b0563          	beqz	s6,800030d2 <namex+0xe0>
    800030cc:	0004c783          	lbu	a5,0(s1)
    800030d0:	d3dd                	beqz	a5,80003076 <namex+0x84>
        if ((next = dirlookup(ip, name, 0)) == 0) {
    800030d2:	865e                	mv	a2,s7
    800030d4:	85d6                	mv	a1,s5
    800030d6:	854e                	mv	a0,s3
    800030d8:	00000097          	auipc	ra,0x0
    800030dc:	e62080e7          	jalr	-414(ra) # 80002f3a <dirlookup>
    800030e0:	8a2a                	mv	s4,a0
    800030e2:	d145                	beqz	a0,80003082 <namex+0x90>
        unlock_and_putback(ip);
    800030e4:	854e                	mv	a0,s3
    800030e6:	00000097          	auipc	ra,0x0
    800030ea:	c4c080e7          	jalr	-948(ra) # 80002d32 <unlock_and_putback>
        ip = next;
    800030ee:	89d2                	mv	s3,s4
    while (*path == '/')
    800030f0:	0004c783          	lbu	a5,0(s1)
    800030f4:	05279663          	bne	a5,s2,80003140 <namex+0x14e>
        path++;
    800030f8:	0485                	addi	s1,s1,1
    while (*path == '/')
    800030fa:	0004c783          	lbu	a5,0(s1)
    800030fe:	ff278de3          	beq	a5,s2,800030f8 <namex+0x106>
    if (*path == 0)
    80003102:	c795                	beqz	a5,8000312e <namex+0x13c>
        path++;
    80003104:	85a6                	mv	a1,s1
    len = path - s;
    80003106:	8a5e                	mv	s4,s7
    while (*path != '/' && *path != 0)
    80003108:	01278963          	beq	a5,s2,8000311a <namex+0x128>
    8000310c:	d3d1                	beqz	a5,80003090 <namex+0x9e>
        path++;
    8000310e:	0485                	addi	s1,s1,1
    while (*path != '/' && *path != 0)
    80003110:	0004c783          	lbu	a5,0(s1)
    80003114:	ff279ce3          	bne	a5,s2,8000310c <namex+0x11a>
    80003118:	bfa5                	j	80003090 <namex+0x9e>
        memmove(name, s, len);
    8000311a:	8652                	mv	a2,s4
    8000311c:	8556                	mv	a0,s5
    8000311e:	ffffe097          	auipc	ra,0xffffe
    80003122:	d74080e7          	jalr	-652(ra) # 80000e92 <memmove>
        name[len] = 0;
    80003126:	9a56                	add	s4,s4,s5
    80003128:	000a0023          	sb	zero,0(s4)
    8000312c:	bfa5                	j	800030a4 <namex+0xb2>
    if (nameiparent) {
    8000312e:	f20b06e3          	beqz	s6,8000305a <namex+0x68>
        putback_inode(ip);
    80003132:	854e                	mv	a0,s3
    80003134:	00000097          	auipc	ra,0x0
    80003138:	a0c080e7          	jalr	-1524(ra) # 80002b40 <putback_inode>
        return 0;
    8000313c:	4981                	li	s3,0
    8000313e:	bf31                	j	8000305a <namex+0x68>
    if (*path == 0)
    80003140:	d7fd                	beqz	a5,8000312e <namex+0x13c>
    while (*path != '/' && *path != 0)
    80003142:	0004c783          	lbu	a5,0(s1)
    80003146:	85a6                	mv	a1,s1
    80003148:	b7d1                	j	8000310c <namex+0x11a>

000000008000314a <dirlink>:
int dirlink(struct inode *dp, char *name, uint inum) {
    8000314a:	715d                	addi	sp,sp,-80
    8000314c:	e486                	sd	ra,72(sp)
    8000314e:	e0a2                	sd	s0,64(sp)
    80003150:	fc26                	sd	s1,56(sp)
    80003152:	f84a                	sd	s2,48(sp)
    80003154:	f44e                	sd	s3,40(sp)
    80003156:	f052                	sd	s4,32(sp)
    80003158:	ec56                	sd	s5,24(sp)
    8000315a:	e85a                	sd	s6,16(sp)
    8000315c:	0880                	addi	s0,sp,80
    8000315e:	89aa                	mv	s3,a0
    80003160:	8b2e                	mv	s6,a1
    80003162:	8ab2                	mv	s5,a2
    if ((ip = dirlookup(dp, name, 0)) != 0) {
    80003164:	4601                	li	a2,0
    80003166:	00000097          	auipc	ra,0x0
    8000316a:	dd4080e7          	jalr	-556(ra) # 80002f3a <dirlookup>
    8000316e:	ed21                	bnez	a0,800031c6 <dirlink+0x7c>
    for (off = 0; off < dp->size; off += sizeof(de)) {
    80003170:	04c9a783          	lw	a5,76(s3)
    80003174:	4481                	li	s1,0
    80003176:	4901                	li	s2,0
            panic("dirlink read");
    80003178:	00002a17          	auipc	s4,0x2
    8000317c:	2c0a0a13          	addi	s4,s4,704 # 80005438 <digits+0x2f0>
    for (off = 0; off < dp->size; off += sizeof(de)) {
    80003180:	ebb5                	bnez	a5,800031f4 <dirlink+0xaa>
    strncpy(de.name, name, DIRSIZ);
    80003182:	4639                	li	a2,14
    80003184:	85da                	mv	a1,s6
    80003186:	fb240513          	addi	a0,s0,-78
    8000318a:	ffffe097          	auipc	ra,0xffffe
    8000318e:	ddc080e7          	jalr	-548(ra) # 80000f66 <strncpy>
    de.inum = inum;
    80003192:	fb541823          	sh	s5,-80(s0)
    if (write_inode(dp, (uint64) &de, off, sizeof(de)) != sizeof(de))
    80003196:	46c1                	li	a3,16
    80003198:	8626                	mv	a2,s1
    8000319a:	fb040593          	addi	a1,s0,-80
    8000319e:	854e                	mv	a0,s3
    800031a0:	00000097          	auipc	ra,0x0
    800031a4:	c84080e7          	jalr	-892(ra) # 80002e24 <write_inode>
    800031a8:	872a                	mv	a4,a0
    800031aa:	47c1                	li	a5,16
    return 0;
    800031ac:	4501                	li	a0,0
    if (write_inode(dp, (uint64) &de, off, sizeof(de)) != sizeof(de))
    800031ae:	06f71063          	bne	a4,a5,8000320e <dirlink+0xc4>
}
    800031b2:	60a6                	ld	ra,72(sp)
    800031b4:	6406                	ld	s0,64(sp)
    800031b6:	74e2                	ld	s1,56(sp)
    800031b8:	7942                	ld	s2,48(sp)
    800031ba:	79a2                	ld	s3,40(sp)
    800031bc:	7a02                	ld	s4,32(sp)
    800031be:	6ae2                	ld	s5,24(sp)
    800031c0:	6b42                	ld	s6,16(sp)
    800031c2:	6161                	addi	sp,sp,80
    800031c4:	8082                	ret
        putback_inode(ip);
    800031c6:	00000097          	auipc	ra,0x0
    800031ca:	97a080e7          	jalr	-1670(ra) # 80002b40 <putback_inode>
        return -1;
    800031ce:	557d                	li	a0,-1
    800031d0:	b7cd                	j	800031b2 <dirlink+0x68>
            panic("dirlink read");
    800031d2:	8552                	mv	a0,s4
    800031d4:	ffffe097          	auipc	ra,0xffffe
    800031d8:	21c080e7          	jalr	540(ra) # 800013f0 <panic>
        if (de.inum == 0)
    800031dc:	fb045783          	lhu	a5,-80(s0)
    800031e0:	d3cd                	beqz	a5,80003182 <dirlink+0x38>
    for (off = 0; off < dp->size; off += sizeof(de)) {
    800031e2:	0109079b          	addiw	a5,s2,16
    800031e6:	0007891b          	sext.w	s2,a5
    800031ea:	84ca                	mv	s1,s2
    800031ec:	04c9a783          	lw	a5,76(s3)
    800031f0:	f8f979e3          	bgeu	s2,a5,80003182 <dirlink+0x38>
        if (read_inode(dp, (uint64) &de, off, sizeof(de)) != sizeof(de))
    800031f4:	46c1                	li	a3,16
    800031f6:	864a                	mv	a2,s2
    800031f8:	fb040593          	addi	a1,s0,-80
    800031fc:	854e                	mv	a0,s3
    800031fe:	00000097          	auipc	ra,0x0
    80003202:	b5c080e7          	jalr	-1188(ra) # 80002d5a <read_inode>
    80003206:	47c1                	li	a5,16
    80003208:	fcf50ae3          	beq	a0,a5,800031dc <dirlink+0x92>
    8000320c:	b7d9                	j	800031d2 <dirlink+0x88>
        panic("dirlink");
    8000320e:	00002517          	auipc	a0,0x2
    80003212:	23a50513          	addi	a0,a0,570 # 80005448 <digits+0x300>
    80003216:	ffffe097          	auipc	ra,0xffffe
    8000321a:	1da080e7          	jalr	474(ra) # 800013f0 <panic>
    return 0;
    8000321e:	4501                	li	a0,0
    80003220:	bf49                	j	800031b2 <dirlink+0x68>

0000000080003222 <namei>:

struct inode *namei(char *path) {
    80003222:	1101                	addi	sp,sp,-32
    80003224:	ec06                	sd	ra,24(sp)
    80003226:	e822                	sd	s0,16(sp)
    80003228:	1000                	addi	s0,sp,32
    char name[DIRSIZ];
    return namex(path, 0, name);
    8000322a:	fe040613          	addi	a2,s0,-32
    8000322e:	4581                	li	a1,0
    80003230:	00000097          	auipc	ra,0x0
    80003234:	dc2080e7          	jalr	-574(ra) # 80002ff2 <namex>
}
    80003238:	60e2                	ld	ra,24(sp)
    8000323a:	6442                	ld	s0,16(sp)
    8000323c:	6105                	addi	sp,sp,32
    8000323e:	8082                	ret

0000000080003240 <nameiparent>:

struct inode *nameiparent(char *path, char *name) {
    80003240:	1141                	addi	sp,sp,-16
    80003242:	e406                	sd	ra,8(sp)
    80003244:	e022                	sd	s0,0(sp)
    80003246:	0800                	addi	s0,sp,16
    80003248:	862e                	mv	a2,a1
    return namex(path, 1, name);
    8000324a:	4585                	li	a1,1
    8000324c:	00000097          	auipc	ra,0x0
    80003250:	da6080e7          	jalr	-602(ra) # 80002ff2 <namex>
    80003254:	60a2                	ld	ra,8(sp)
    80003256:	6402                	ld	s0,0(sp)
    80003258:	0141                	addi	sp,sp,16
    8000325a:	8082                	ret

000000008000325c <init_buf>:
#define BUFFER_NUM 100

struct buf buf_cache[BUFFER_NUM];
struct spinlock cache_lock;

void init_buf() {
    8000325c:	7179                	addi	sp,sp,-48
    8000325e:	f406                	sd	ra,40(sp)
    80003260:	f022                	sd	s0,32(sp)
    80003262:	ec26                	sd	s1,24(sp)
    80003264:	e84a                	sd	s2,16(sp)
    80003266:	e44e                	sd	s3,8(sp)
    80003268:	1800                	addi	s0,sp,48
    spinlock_init(&cache_lock, "cache lock");
    8000326a:	00002597          	auipc	a1,0x2
    8000326e:	1e658593          	addi	a1,a1,486 # 80005450 <digits+0x308>
    80003272:	0008f517          	auipc	a0,0x8f
    80003276:	84e50513          	addi	a0,a0,-1970 # 80091ac0 <cache_lock>
    8000327a:	00000097          	auipc	ra,0x0
    8000327e:	1c0080e7          	jalr	448(ra) # 8000343a <spinlock_init>
    80003282:	06400493          	li	s1,100
    for (int i = 0; i < BUFFER_NUM; i++) {
        sleeplock_init(&buf_cache->lock, "buf");
    80003286:	00002997          	auipc	s3,0x2
    8000328a:	1da98993          	addi	s3,s3,474 # 80005460 <digits+0x318>
    8000328e:	0008f917          	auipc	s2,0x8f
    80003292:	86290913          	addi	s2,s2,-1950 # 80091af0 <buf_cache+0x18>
    80003296:	85ce                	mv	a1,s3
    80003298:	854a                	mv	a0,s2
    8000329a:	00000097          	auipc	ra,0x0
    8000329e:	360080e7          	jalr	864(ra) # 800035fa <sleeplock_init>
    for (int i = 0; i < BUFFER_NUM; i++) {
    800032a2:	34fd                	addiw	s1,s1,-1
    800032a4:	f8ed                	bnez	s1,80003296 <init_buf+0x3a>
    }
}
    800032a6:	70a2                	ld	ra,40(sp)
    800032a8:	7402                	ld	s0,32(sp)
    800032aa:	64e2                	ld	s1,24(sp)
    800032ac:	6942                	ld	s2,16(sp)
    800032ae:	69a2                	ld	s3,8(sp)
    800032b0:	6145                	addi	sp,sp,48
    800032b2:	8082                	ret

00000000800032b4 <alloc_buf>:
extern uint64 ticks;


// 申请使用一个缓冲区，该缓冲区会被锁定
// 先进先出算法
struct buf *alloc_buf(int dev, int blockno) {
    800032b4:	7179                	addi	sp,sp,-48
    800032b6:	f406                	sd	ra,40(sp)
    800032b8:	f022                	sd	s0,32(sp)
    800032ba:	ec26                	sd	s1,24(sp)
    800032bc:	e84a                	sd	s2,16(sp)
    800032be:	e44e                	sd	s3,8(sp)
    800032c0:	e052                	sd	s4,0(sp)
    800032c2:	1800                	addi	s0,sp,48
    800032c4:	8a2a                	mv	s4,a0
    800032c6:	892e                	mv	s2,a1
    struct buf *b;
    struct buf *earliest = 0;
    spin_lock(&cache_lock);
    800032c8:	0008e517          	auipc	a0,0x8e
    800032cc:	7f850513          	addi	a0,a0,2040 # 80091ac0 <cache_lock>
    800032d0:	00000097          	auipc	ra,0x0
    800032d4:	1fa080e7          	jalr	506(ra) # 800034ca <spin_lock>
    struct buf *earliest = 0;
    800032d8:	4981                	li	s3,0
    for (b = buf_cache; b < buf_cache + BUFFER_NUM; b++) {
    800032da:	0008e497          	auipc	s1,0x8e
    800032de:	7fe48493          	addi	s1,s1,2046 # 80091ad8 <buf_cache>
        if (b->refcnt == 0 &&
            (earliest == 0 || b->last_use_tick < earliest->last_use_tick)) {
            earliest = b;
        }
        if (b->blockno == blockno) {
    800032e2:	2901                	sext.w	s2,s2
    for (b = buf_cache; b < buf_cache + BUFFER_NUM; b++) {
    800032e4:	000a9717          	auipc	a4,0xa9
    800032e8:	73470713          	addi	a4,a4,1844 # 800aca18 <ticks_lock>
    800032ec:	a809                	j	800032fe <alloc_buf+0x4a>
    800032ee:	89a6                	mv	s3,s1
        if (b->blockno == blockno) {
    800032f0:	44dc                	lw	a5,12(s1)
    800032f2:	03278163          	beq	a5,s2,80003314 <alloc_buf+0x60>
    for (b = buf_cache; b < buf_cache + BUFFER_NUM; b++) {
    800032f6:	45048493          	addi	s1,s1,1104
    800032fa:	04e48c63          	beq	s1,a4,80003352 <alloc_buf+0x9e>
        if (b->refcnt == 0 &&
    800032fe:	44bc                	lw	a5,72(s1)
    80003300:	fbe5                	bnez	a5,800032f0 <alloc_buf+0x3c>
    80003302:	fe0986e3          	beqz	s3,800032ee <alloc_buf+0x3a>
            (earliest == 0 || b->last_use_tick < earliest->last_use_tick)) {
    80003306:	6894                	ld	a3,16(s1)
    80003308:	0109b783          	ld	a5,16(s3)
    8000330c:	fef6f2e3          	bgeu	a3,a5,800032f0 <alloc_buf+0x3c>
    80003310:	89a6                	mv	s3,s1
    80003312:	bff9                	j	800032f0 <alloc_buf+0x3c>
            spin_unlock(&cache_lock);
    80003314:	0008e517          	auipc	a0,0x8e
    80003318:	7ac50513          	addi	a0,a0,1964 # 80091ac0 <cache_lock>
    8000331c:	00000097          	auipc	ra,0x0
    80003320:	282080e7          	jalr	642(ra) # 8000359e <spin_unlock>
            b->refcnt++;
    80003324:	44bc                	lw	a5,72(s1)
    80003326:	2785                	addiw	a5,a5,1
    80003328:	c4bc                	sw	a5,72(s1)
            b->last_use_tick = ticks;
    8000332a:	00003797          	auipc	a5,0x3
    8000332e:	ce67b783          	ld	a5,-794(a5) # 80006010 <ticks>
    80003332:	e89c                	sd	a5,16(s1)
            sleep_lock(&b->lock);
    80003334:	01848513          	addi	a0,s1,24
    80003338:	00000097          	auipc	ra,0x0
    8000333c:	2fc080e7          	jalr	764(ra) # 80003634 <sleep_lock>
    b->refcnt = 1;
    b->blockno = blockno;
    b->dev = dev;
    b->last_use_tick = ticks;
    return b;
}
    80003340:	8526                	mv	a0,s1
    80003342:	70a2                	ld	ra,40(sp)
    80003344:	7402                	ld	s0,32(sp)
    80003346:	64e2                	ld	s1,24(sp)
    80003348:	6942                	ld	s2,16(sp)
    8000334a:	69a2                	ld	s3,8(sp)
    8000334c:	6a02                	ld	s4,0(sp)
    8000334e:	6145                	addi	sp,sp,48
    80003350:	8082                	ret
    spin_unlock(&cache_lock);
    80003352:	0008e517          	auipc	a0,0x8e
    80003356:	76e50513          	addi	a0,a0,1902 # 80091ac0 <cache_lock>
    8000335a:	00000097          	auipc	ra,0x0
    8000335e:	244080e7          	jalr	580(ra) # 8000359e <spin_unlock>
    if (earliest == 0) {
    80003362:	02098363          	beqz	s3,80003388 <alloc_buf+0xd4>
    b->valid = 0;
    80003366:	0009a023          	sw	zero,0(s3)
    b->refcnt = 1;
    8000336a:	4785                	li	a5,1
    8000336c:	04f9a423          	sw	a5,72(s3)
    b->blockno = blockno;
    80003370:	0129a623          	sw	s2,12(s3)
    b->dev = dev;
    80003374:	0149a423          	sw	s4,8(s3)
    b->last_use_tick = ticks;
    80003378:	00003797          	auipc	a5,0x3
    8000337c:	c987b783          	ld	a5,-872(a5) # 80006010 <ticks>
    80003380:	00f9b823          	sd	a5,16(s3)
    return b;
    80003384:	84ce                	mv	s1,s3
    80003386:	bf6d                	j	80003340 <alloc_buf+0x8c>
        panic("alloc buf");
    80003388:	00002517          	auipc	a0,0x2
    8000338c:	0e050513          	addi	a0,a0,224 # 80005468 <digits+0x320>
    80003390:	ffffe097          	auipc	ra,0xffffe
    80003394:	060080e7          	jalr	96(ra) # 800013f0 <panic>
    80003398:	b7f9                	j	80003366 <alloc_buf+0xb2>

000000008000339a <buf_read>:
    buf_write(b);
    sleep_unlock(&b->lock);
}

// 读取给定块的内容，返回一个包含该内容的buf
struct buf *buf_read(int dev, int blockno) {
    8000339a:	1101                	addi	sp,sp,-32
    8000339c:	ec06                	sd	ra,24(sp)
    8000339e:	e822                	sd	s0,16(sp)
    800033a0:	e426                	sd	s1,8(sp)
    800033a2:	1000                	addi	s0,sp,32
    struct buf *b = alloc_buf(dev, blockno);
    800033a4:	00000097          	auipc	ra,0x0
    800033a8:	f10080e7          	jalr	-240(ra) # 800032b4 <alloc_buf>
    800033ac:	84aa                	mv	s1,a0
    if (!b->valid) {
    800033ae:	411c                	lw	a5,0(a0)
    800033b0:	cb89                	beqz	a5,800033c2 <buf_read+0x28>
        virtio_disk_rw(b, 0);
    }
    b->valid = 1;
    800033b2:	4785                	li	a5,1
    800033b4:	c09c                	sw	a5,0(s1)
    return b;
}
    800033b6:	8526                	mv	a0,s1
    800033b8:	60e2                	ld	ra,24(sp)
    800033ba:	6442                	ld	s0,16(sp)
    800033bc:	64a2                	ld	s1,8(sp)
    800033be:	6105                	addi	sp,sp,32
    800033c0:	8082                	ret
        virtio_disk_rw(b, 0);
    800033c2:	4581                	li	a1,0
    800033c4:	fffff097          	auipc	ra,0xfffff
    800033c8:	b24080e7          	jalr	-1244(ra) # 80001ee8 <virtio_disk_rw>
    800033cc:	b7dd                	j	800033b2 <buf_read+0x18>

00000000800033ce <buf_write>:

// 将缓冲区写入磁盘
void buf_write(struct buf *b) {
    800033ce:	1141                	addi	sp,sp,-16
    800033d0:	e406                	sd	ra,8(sp)
    800033d2:	e022                	sd	s0,0(sp)
    800033d4:	0800                	addi	s0,sp,16
    virtio_disk_rw(b, 1);
    800033d6:	4585                	li	a1,1
    800033d8:	fffff097          	auipc	ra,0xfffff
    800033dc:	b10080e7          	jalr	-1264(ra) # 80001ee8 <virtio_disk_rw>
}
    800033e0:	60a2                	ld	ra,8(sp)
    800033e2:	6402                	ld	s0,0(sp)
    800033e4:	0141                	addi	sp,sp,16
    800033e6:	8082                	ret

00000000800033e8 <relse_buf>:
void relse_buf(struct buf *b) {
    800033e8:	1101                	addi	sp,sp,-32
    800033ea:	ec06                	sd	ra,24(sp)
    800033ec:	e822                	sd	s0,16(sp)
    800033ee:	e426                	sd	s1,8(sp)
    800033f0:	e04a                	sd	s2,0(sp)
    800033f2:	1000                	addi	s0,sp,32
    800033f4:	84aa                	mv	s1,a0
    spin_lock(&cache_lock);
    800033f6:	0008e917          	auipc	s2,0x8e
    800033fa:	6ca90913          	addi	s2,s2,1738 # 80091ac0 <cache_lock>
    800033fe:	854a                	mv	a0,s2
    80003400:	00000097          	auipc	ra,0x0
    80003404:	0ca080e7          	jalr	202(ra) # 800034ca <spin_lock>
    b->refcnt--;
    80003408:	44bc                	lw	a5,72(s1)
    8000340a:	37fd                	addiw	a5,a5,-1
    8000340c:	c4bc                	sw	a5,72(s1)
    spin_unlock(&cache_lock);
    8000340e:	854a                	mv	a0,s2
    80003410:	00000097          	auipc	ra,0x0
    80003414:	18e080e7          	jalr	398(ra) # 8000359e <spin_unlock>
    buf_write(b);
    80003418:	8526                	mv	a0,s1
    8000341a:	00000097          	auipc	ra,0x0
    8000341e:	fb4080e7          	jalr	-76(ra) # 800033ce <buf_write>
    sleep_unlock(&b->lock);
    80003422:	01848513          	addi	a0,s1,24
    80003426:	00000097          	auipc	ra,0x0
    8000342a:	264080e7          	jalr	612(ra) # 8000368a <sleep_unlock>
}
    8000342e:	60e2                	ld	ra,24(sp)
    80003430:	6442                	ld	s0,16(sp)
    80003432:	64a2                	ld	s1,8(sp)
    80003434:	6902                	ld	s2,0(sp)
    80003436:	6105                	addi	sp,sp,32
    80003438:	8082                	ret

000000008000343a <spinlock_init>:
#include "lock.h"
#include "../riscv.h"
#include "../process.h"
#include "../defs.h"

void spinlock_init(struct spinlock *lk, char *name) {
    8000343a:	1141                	addi	sp,sp,-16
    8000343c:	e422                	sd	s0,8(sp)
    8000343e:	0800                	addi	s0,sp,16
    lk->cpu = 0;
    80003440:	00053423          	sd	zero,8(a0)
    lk->name = name;
    80003444:	e90c                	sd	a1,16(a0)
    lk->locked = 0;
    80003446:	00052023          	sw	zero,0(a0)
}
    8000344a:	6422                	ld	s0,8(sp)
    8000344c:	0141                	addi	sp,sp,16
    8000344e:	8082                	ret

0000000080003450 <spin_holding>:

// 检查当前cpu是否持有这个锁
// 需要关中断
int spin_holding(struct spinlock *lk) {
    int r;
    r = (lk->locked && lk->cpu == mycpu());
    80003450:	411c                	lw	a5,0(a0)
    80003452:	e399                	bnez	a5,80003458 <spin_holding+0x8>
    80003454:	4501                	li	a0,0
    return r;
}
    80003456:	8082                	ret
int spin_holding(struct spinlock *lk) {
    80003458:	1101                	addi	sp,sp,-32
    8000345a:	ec06                	sd	ra,24(sp)
    8000345c:	e822                	sd	s0,16(sp)
    8000345e:	e426                	sd	s1,8(sp)
    80003460:	1000                	addi	s0,sp,32
    r = (lk->locked && lk->cpu == mycpu());
    80003462:	6504                	ld	s1,8(a0)
    80003464:	ffffd097          	auipc	ra,0xffffd
    80003468:	3b6080e7          	jalr	950(ra) # 8000081a <mycpu>
    8000346c:	40a48533          	sub	a0,s1,a0
    80003470:	00153513          	seqz	a0,a0
}
    80003474:	60e2                	ld	ra,24(sp)
    80003476:	6442                	ld	s0,16(sp)
    80003478:	64a2                	ld	s1,8(sp)
    8000347a:	6105                	addi	sp,sp,32
    8000347c:	8082                	ret

000000008000347e <push_off>:

// push_off/pop_off 和 intr_off/intr_on 差不多，只是使得
// 开关中断可以嵌套使用。
void push_off(void) {
    8000347e:	1101                	addi	sp,sp,-32
    80003480:	ec06                	sd	ra,24(sp)
    80003482:	e822                	sd	s0,16(sp)
    80003484:	e426                	sd	s1,8(sp)
    80003486:	1000                	addi	s0,sp,32

static inline uint64
r_sstatus()
{
  uint64 x;
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003488:	100024f3          	csrr	s1,sstatus
    8000348c:	100027f3          	csrr	a5,sstatus

// disable device interrupts
static inline void
intr_off()
{
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80003490:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003492:	10079073          	csrw	sstatus,a5
    int old = intr_get();
    intr_off();
    if (mycpu()->noff == 0)
    80003496:	ffffd097          	auipc	ra,0xffffd
    8000349a:	384080e7          	jalr	900(ra) # 8000081a <mycpu>
    8000349e:	5d3c                	lw	a5,120(a0)
    800034a0:	cf89                	beqz	a5,800034ba <push_off+0x3c>
        mycpu()->intr_enable = old;
    mycpu()->noff += 1;
    800034a2:	ffffd097          	auipc	ra,0xffffd
    800034a6:	378080e7          	jalr	888(ra) # 8000081a <mycpu>
    800034aa:	5d3c                	lw	a5,120(a0)
    800034ac:	2785                	addiw	a5,a5,1
    800034ae:	dd3c                	sw	a5,120(a0)
}
    800034b0:	60e2                	ld	ra,24(sp)
    800034b2:	6442                	ld	s0,16(sp)
    800034b4:	64a2                	ld	s1,8(sp)
    800034b6:	6105                	addi	sp,sp,32
    800034b8:	8082                	ret
        mycpu()->intr_enable = old;
    800034ba:	ffffd097          	auipc	ra,0xffffd
    800034be:	360080e7          	jalr	864(ra) # 8000081a <mycpu>
// are device interrupts enabled?
static inline int
intr_get()
{
  uint64 x = r_sstatus();
  return (x & SSTATUS_SIE) != 0;
    800034c2:	8085                	srli	s1,s1,0x1
    800034c4:	8885                	andi	s1,s1,1
    800034c6:	dd64                	sw	s1,124(a0)
    800034c8:	bfe9                	j	800034a2 <push_off+0x24>

00000000800034ca <spin_lock>:
void spin_lock(struct spinlock *lk) {
    800034ca:	1101                	addi	sp,sp,-32
    800034cc:	ec06                	sd	ra,24(sp)
    800034ce:	e822                	sd	s0,16(sp)
    800034d0:	e426                	sd	s1,8(sp)
    800034d2:	1000                	addi	s0,sp,32
    800034d4:	84aa                	mv	s1,a0
    push_off(); // 禁用中断以避免死锁。
    800034d6:	00000097          	auipc	ra,0x0
    800034da:	fa8080e7          	jalr	-88(ra) # 8000347e <push_off>
    if (spin_holding(lk)){
    800034de:	8526                	mv	a0,s1
    800034e0:	00000097          	auipc	ra,0x0
    800034e4:	f70080e7          	jalr	-144(ra) # 80003450 <spin_holding>
    800034e8:	e11d                	bnez	a0,8000350e <spin_lock+0x44>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0);
    800034ea:	4705                	li	a4,1
    800034ec:	87ba                	mv	a5,a4
    800034ee:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800034f2:	2781                	sext.w	a5,a5
    800034f4:	ffe5                	bnez	a5,800034ec <spin_lock+0x22>
    __sync_synchronize();
    800034f6:	0ff0000f          	fence
    lk->cpu = mycpu();
    800034fa:	ffffd097          	auipc	ra,0xffffd
    800034fe:	320080e7          	jalr	800(ra) # 8000081a <mycpu>
    80003502:	e488                	sd	a0,8(s1)
}
    80003504:	60e2                	ld	ra,24(sp)
    80003506:	6442                	ld	s0,16(sp)
    80003508:	64a2                	ld	s1,8(sp)
    8000350a:	6105                	addi	sp,sp,32
    8000350c:	8082                	ret
        printf("lock=%s",lk->name);
    8000350e:	688c                	ld	a1,16(s1)
    80003510:	00002517          	auipc	a0,0x2
    80003514:	f6850513          	addi	a0,a0,-152 # 80005478 <digits+0x330>
    80003518:	ffffe097          	auipc	ra,0xffffe
    8000351c:	e14080e7          	jalr	-492(ra) # 8000132c <printf>
        panic("re-acquire");
    80003520:	00002517          	auipc	a0,0x2
    80003524:	f6050513          	addi	a0,a0,-160 # 80005480 <digits+0x338>
    80003528:	ffffe097          	auipc	ra,0xffffe
    8000352c:	ec8080e7          	jalr	-312(ra) # 800013f0 <panic>
    80003530:	bf6d                	j	800034ea <spin_lock+0x20>

0000000080003532 <pop_off>:

void pop_off(void) {
    80003532:	1101                	addi	sp,sp,-32
    80003534:	ec06                	sd	ra,24(sp)
    80003536:	e822                	sd	s0,16(sp)
    80003538:	e426                	sd	s1,8(sp)
    8000353a:	1000                	addi	s0,sp,32
    struct cpu *c = mycpu();
    8000353c:	ffffd097          	auipc	ra,0xffffd
    80003540:	2de080e7          	jalr	734(ra) # 8000081a <mycpu>
    80003544:	84aa                	mv	s1,a0
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003546:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000354a:	8b89                	andi	a5,a5,2
    if (intr_get())
    8000354c:	e79d                	bnez	a5,8000357a <pop_off+0x48>
        panic("pop_off - interruptible");
    if (c->noff < 1)
    8000354e:	5cbc                	lw	a5,120(s1)
    80003550:	02f05e63          	blez	a5,8000358c <pop_off+0x5a>
        panic("pop_off");
    c->noff -= 1;
    80003554:	5cbc                	lw	a5,120(s1)
    80003556:	37fd                	addiw	a5,a5,-1
    80003558:	0007871b          	sext.w	a4,a5
    8000355c:	dcbc                	sw	a5,120(s1)
    if (c->noff == 0 && c->intr_enable)
    8000355e:	eb09                	bnez	a4,80003570 <pop_off+0x3e>
    80003560:	5cfc                	lw	a5,124(s1)
    80003562:	c799                	beqz	a5,80003570 <pop_off+0x3e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003564:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80003568:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000356c:	10079073          	csrw	sstatus,a5
        intr_on();
}
    80003570:	60e2                	ld	ra,24(sp)
    80003572:	6442                	ld	s0,16(sp)
    80003574:	64a2                	ld	s1,8(sp)
    80003576:	6105                	addi	sp,sp,32
    80003578:	8082                	ret
        panic("pop_off - interruptible");
    8000357a:	00002517          	auipc	a0,0x2
    8000357e:	f1650513          	addi	a0,a0,-234 # 80005490 <digits+0x348>
    80003582:	ffffe097          	auipc	ra,0xffffe
    80003586:	e6e080e7          	jalr	-402(ra) # 800013f0 <panic>
    8000358a:	b7d1                	j	8000354e <pop_off+0x1c>
        panic("pop_off");
    8000358c:	00002517          	auipc	a0,0x2
    80003590:	f1c50513          	addi	a0,a0,-228 # 800054a8 <digits+0x360>
    80003594:	ffffe097          	auipc	ra,0xffffe
    80003598:	e5c080e7          	jalr	-420(ra) # 800013f0 <panic>
    8000359c:	bf65                	j	80003554 <pop_off+0x22>

000000008000359e <spin_unlock>:
void spin_unlock(struct spinlock *lk) {
    8000359e:	1101                	addi	sp,sp,-32
    800035a0:	ec06                	sd	ra,24(sp)
    800035a2:	e822                	sd	s0,16(sp)
    800035a4:	e426                	sd	s1,8(sp)
    800035a6:	1000                	addi	s0,sp,32
    800035a8:	84aa                	mv	s1,a0
    if (!spin_holding(lk)){
    800035aa:	00000097          	auipc	ra,0x0
    800035ae:	ea6080e7          	jalr	-346(ra) # 80003450 <spin_holding>
    800035b2:	c115                	beqz	a0,800035d6 <spin_unlock+0x38>
    lk->cpu = 0;
    800035b4:	0004b423          	sd	zero,8(s1)
    __sync_synchronize();
    800035b8:	0ff0000f          	fence
    __sync_lock_release(&lk->locked);
    800035bc:	0f50000f          	fence	iorw,ow
    800035c0:	0804a02f          	amoswap.w	zero,zero,(s1)
    pop_off();
    800035c4:	00000097          	auipc	ra,0x0
    800035c8:	f6e080e7          	jalr	-146(ra) # 80003532 <pop_off>
}
    800035cc:	60e2                	ld	ra,24(sp)
    800035ce:	6442                	ld	s0,16(sp)
    800035d0:	64a2                	ld	s1,8(sp)
    800035d2:	6105                	addi	sp,sp,32
    800035d4:	8082                	ret
        printf("%s\n", lk->name);
    800035d6:	688c                	ld	a1,16(s1)
    800035d8:	00002517          	auipc	a0,0x2
    800035dc:	b4050513          	addi	a0,a0,-1216 # 80005118 <etext+0x118>
    800035e0:	ffffe097          	auipc	ra,0xffffe
    800035e4:	d4c080e7          	jalr	-692(ra) # 8000132c <printf>
        panic("release");
    800035e8:	00002517          	auipc	a0,0x2
    800035ec:	ec850513          	addi	a0,a0,-312 # 800054b0 <digits+0x368>
    800035f0:	ffffe097          	auipc	ra,0xffffe
    800035f4:	e00080e7          	jalr	-512(ra) # 800013f0 <panic>
    800035f8:	bf75                	j	800035b4 <spin_unlock+0x16>

00000000800035fa <sleeplock_init>:
#include "lock.h"
#include "../process.h"
#include "../defs.h"

void sleeplock_init(struct sleeplock* lk, char* name)
{
    800035fa:	1101                	addi	sp,sp,-32
    800035fc:	ec06                	sd	ra,24(sp)
    800035fe:	e822                	sd	s0,16(sp)
    80003600:	e426                	sd	s1,8(sp)
    80003602:	e04a                	sd	s2,0(sp)
    80003604:	1000                	addi	s0,sp,32
    80003606:	84aa                	mv	s1,a0
    80003608:	892e                	mv	s2,a1
  spinlock_init(&lk->lk, "sleep lock");
    8000360a:	00002597          	auipc	a1,0x2
    8000360e:	eae58593          	addi	a1,a1,-338 # 800054b8 <digits+0x370>
    80003612:	0521                	addi	a0,a0,8
    80003614:	00000097          	auipc	ra,0x0
    80003618:	e26080e7          	jalr	-474(ra) # 8000343a <spinlock_init>
  lk->name = name;
    8000361c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003620:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003624:	0204a423          	sw	zero,40(s1)
}
    80003628:	60e2                	ld	ra,24(sp)
    8000362a:	6442                	ld	s0,16(sp)
    8000362c:	64a2                	ld	s1,8(sp)
    8000362e:	6902                	ld	s2,0(sp)
    80003630:	6105                	addi	sp,sp,32
    80003632:	8082                	ret

0000000080003634 <sleep_lock>:

void sleep_lock(struct sleeplock* lk)
{
    80003634:	1101                	addi	sp,sp,-32
    80003636:	ec06                	sd	ra,24(sp)
    80003638:	e822                	sd	s0,16(sp)
    8000363a:	e426                	sd	s1,8(sp)
    8000363c:	e04a                	sd	s2,0(sp)
    8000363e:	1000                	addi	s0,sp,32
    80003640:	84aa                	mv	s1,a0
  spin_lock(&lk->lk);
    80003642:	00850913          	addi	s2,a0,8
    80003646:	854a                	mv	a0,s2
    80003648:	00000097          	auipc	ra,0x0
    8000364c:	e82080e7          	jalr	-382(ra) # 800034ca <spin_lock>
  while (lk->locked) {
    80003650:	409c                	lw	a5,0(s1)
    80003652:	cb89                	beqz	a5,80003664 <sleep_lock+0x30>
    sleep(lk, &lk->lk);
    80003654:	85ca                	mv	a1,s2
    80003656:	8526                	mv	a0,s1
    80003658:	ffffd097          	auipc	ra,0xffffd
    8000365c:	31a080e7          	jalr	794(ra) # 80000972 <sleep>
  while (lk->locked) {
    80003660:	409c                	lw	a5,0(s1)
    80003662:	fbed                	bnez	a5,80003654 <sleep_lock+0x20>
  }
  lk->locked = 1;
    80003664:	4785                	li	a5,1
    80003666:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003668:	ffffd097          	auipc	ra,0xffffd
    8000366c:	1ce080e7          	jalr	462(ra) # 80000836 <myproc>
    80003670:	5d1c                	lw	a5,56(a0)
    80003672:	d49c                	sw	a5,40(s1)
  spin_unlock(&lk->lk);
    80003674:	854a                	mv	a0,s2
    80003676:	00000097          	auipc	ra,0x0
    8000367a:	f28080e7          	jalr	-216(ra) # 8000359e <spin_unlock>
}
    8000367e:	60e2                	ld	ra,24(sp)
    80003680:	6442                	ld	s0,16(sp)
    80003682:	64a2                	ld	s1,8(sp)
    80003684:	6902                	ld	s2,0(sp)
    80003686:	6105                	addi	sp,sp,32
    80003688:	8082                	ret

000000008000368a <sleep_unlock>:

void sleep_unlock(struct sleeplock* lk)
{
    8000368a:	1101                	addi	sp,sp,-32
    8000368c:	ec06                	sd	ra,24(sp)
    8000368e:	e822                	sd	s0,16(sp)
    80003690:	e426                	sd	s1,8(sp)
    80003692:	e04a                	sd	s2,0(sp)
    80003694:	1000                	addi	s0,sp,32
    80003696:	84aa                	mv	s1,a0
  spin_lock(&lk->lk);
    80003698:	00850913          	addi	s2,a0,8
    8000369c:	854a                	mv	a0,s2
    8000369e:	00000097          	auipc	ra,0x0
    800036a2:	e2c080e7          	jalr	-468(ra) # 800034ca <spin_lock>
  lk->locked = 0;
    800036a6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800036aa:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800036ae:	8526                	mv	a0,s1
    800036b0:	ffffd097          	auipc	ra,0xffffd
    800036b4:	3de080e7          	jalr	990(ra) # 80000a8e <wakeup>
  spin_unlock(&lk->lk);
    800036b8:	854a                	mv	a0,s2
    800036ba:	00000097          	auipc	ra,0x0
    800036be:	ee4080e7          	jalr	-284(ra) # 8000359e <spin_unlock>
}
    800036c2:	60e2                	ld	ra,24(sp)
    800036c4:	6442                	ld	s0,16(sp)
    800036c6:	64a2                	ld	s1,8(sp)
    800036c8:	6902                	ld	s2,0(sp)
    800036ca:	6105                	addi	sp,sp,32
    800036cc:	8082                	ret

00000000800036ce <sleep_holding>:

int sleep_holding(struct sleeplock* lk)
{
    800036ce:	7179                	addi	sp,sp,-48
    800036d0:	f406                	sd	ra,40(sp)
    800036d2:	f022                	sd	s0,32(sp)
    800036d4:	ec26                	sd	s1,24(sp)
    800036d6:	e84a                	sd	s2,16(sp)
    800036d8:	e44e                	sd	s3,8(sp)
    800036da:	1800                	addi	s0,sp,48
    800036dc:	84aa                	mv	s1,a0
  int r;
  spin_lock(&lk->lk);
    800036de:	00850913          	addi	s2,a0,8
    800036e2:	854a                	mv	a0,s2
    800036e4:	00000097          	auipc	ra,0x0
    800036e8:	de6080e7          	jalr	-538(ra) # 800034ca <spin_lock>
  r = lk->locked && (lk->pid == myproc()->pid);
    800036ec:	409c                	lw	a5,0(s1)
    800036ee:	ef99                	bnez	a5,8000370c <sleep_holding+0x3e>
    800036f0:	4481                	li	s1,0
  spin_unlock(&lk->lk);
    800036f2:	854a                	mv	a0,s2
    800036f4:	00000097          	auipc	ra,0x0
    800036f8:	eaa080e7          	jalr	-342(ra) # 8000359e <spin_unlock>
  return r;
}
    800036fc:	8526                	mv	a0,s1
    800036fe:	70a2                	ld	ra,40(sp)
    80003700:	7402                	ld	s0,32(sp)
    80003702:	64e2                	ld	s1,24(sp)
    80003704:	6942                	ld	s2,16(sp)
    80003706:	69a2                	ld	s3,8(sp)
    80003708:	6145                	addi	sp,sp,48
    8000370a:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000370c:	0284a983          	lw	s3,40(s1)
    80003710:	ffffd097          	auipc	ra,0xffffd
    80003714:	126080e7          	jalr	294(ra) # 80000836 <myproc>
    80003718:	5d04                	lw	s1,56(a0)
    8000371a:	413484b3          	sub	s1,s1,s3
    8000371e:	0014b493          	seqz	s1,s1
    80003722:	bfc1                	j	800036f2 <sleep_holding+0x24>

0000000080003724 <trapinit>:

extern char trampoline[], uservec[], userret[];


// 配置中断处理程序
void trapinit(void) {
    80003724:	1141                	addi	sp,sp,-16
    80003726:	e422                	sd	s0,8(sp)
    80003728:	0800                	addi	s0,sp,16
// Supervisor Trap-Vector Base Address
// low two bits are mode.
static inline void 
w_stvec(uint64 x)
{
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000372a:	ffffd797          	auipc	a5,0xffffd
    8000372e:	da678793          	addi	a5,a5,-602 # 800004d0 <kernelvec>
    80003732:	10579073          	csrw	stvec,a5
    w_stvec((uint64) kernelvec);
}
    80003736:	6422                	ld	s0,8(sp)
    80003738:	0141                	addi	sp,sp,16
    8000373a:	8082                	ret

000000008000373c <usertrapret>:
    }

    usertrapret();
}

void usertrapret() {
    8000373c:	1141                	addi	sp,sp,-16
    8000373e:	e406                	sd	ra,8(sp)
    80003740:	e022                	sd	s0,0(sp)
    80003742:	0800                	addi	s0,sp,16
    struct proc *p = myproc();
    80003744:	ffffd097          	auipc	ra,0xffffd
    80003748:	0f2080e7          	jalr	242(ra) # 80000836 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000374c:	100027f3          	csrr	a5,sstatus

// disable device interrupts
static inline void
intr_off()
{
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80003750:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003752:	10079073          	csrw	sstatus,a5
    // 现在将trap处理程序从kerneltrap()切换为usertrap(), 因此需要
    // 禁用中断直到我们返回用户空间。
    intr_off();

    // 现在返回用户空间，设置中断处理函数为trampoline.S的uservec()
    w_stvec(TRAMPOLINE + (uservec - trampoline));
    80003756:	00001617          	auipc	a2,0x1
    8000375a:	8aa60613          	addi	a2,a2,-1878 # 80004000 <_trampoline>
    8000375e:	00001697          	auipc	a3,0x1
    80003762:	8a268693          	addi	a3,a3,-1886 # 80004000 <_trampoline>
    80003766:	8e91                	sub	a3,a3,a2
    80003768:	040007b7          	lui	a5,0x4000
    8000376c:	17fd                	addi	a5,a5,-1
    8000376e:	07b2                	slli	a5,a5,0xc
    80003770:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80003772:	10569073          	csrw	stvec,a3

    // 设置trapframe, 以便下次的trap能够正常运行
    p->trapframe->kernel_satp = r_satp();         // 内核页表
    80003776:	6138                	ld	a4,64(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80003778:	180026f3          	csrr	a3,satp
    8000377c:	e314                	sd	a3,0(a4)
    p->trapframe->kernel_sp = p->kstack + PGSIZE; // 进程的内核栈
    8000377e:	6138                	ld	a4,64(a0)
    80003780:	7134                	ld	a3,96(a0)
    80003782:	6585                	lui	a1,0x1
    80003784:	96ae                	add	a3,a3,a1
    80003786:	e714                	sd	a3,8(a4)
    p->trapframe->kernel_trap = (uint64) usertrap;
    80003788:	6138                	ld	a4,64(a0)
    8000378a:	00000697          	auipc	a3,0x0
    8000378e:	13e68693          	addi	a3,a3,318 # 800038c8 <usertrap>
    80003792:	eb14                	sd	a3,16(a4)
    p->trapframe->kernel_hartid = r_tp();         // cpu id
    80003794:	6138                	ld	a4,64(a0)
// this core's hartid (core number), the index into cpus[].
static inline uint64
r_tp()
{
  uint64 x;
  asm volatile("mv %0, tp" : "=r" (x) );
    80003796:	8692                	mv	a3,tp
    80003798:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000379a:	100026f3          	csrr	a3,sstatus

    // 设置trampoline.S中的sret返回用户空间所需要的寄存器

    // 设置S Previous Privilege(SPP)为User
    unsigned long x = r_sstatus();
    x &= ~SSTATUS_SPP; // 为用户模式清除SPP
    8000379e:	eff6f693          	andi	a3,a3,-257
    x |= SSTATUS_SPIE; // 允许用户模式下的中断
    800037a2:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800037a6:	10069073          	csrw	sstatus,a3
    w_sstatus(x);

    // 设置S的Exception Program Counter(epc)为保存的pc
    w_sepc(p->trapframe->epc);
    800037aa:	6138                	ld	a4,64(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800037ac:	6f18                	ld	a4,24(a4)
    800037ae:	14171073          	csrw	sepc,a4

    // 将用户页表转换为satp寄存器需要的格式
    uint64 satp = MAKE_SATP(p->pagetable);
    800037b2:	652c                	ld	a1,72(a0)
    800037b4:	81b1                	srli	a1,a1,0xc

    // 跳转到虚拟内存顶端的trampoline.S, 它会切换页表为用户页表, 恢复用户
    // 寄存器, 并通过sret切换到用户模式。

    uint64 fn = TRAMPOLINE + (userret - trampoline);
    800037b6:	00001717          	auipc	a4,0x1
    800037ba:	8da70713          	addi	a4,a4,-1830 # 80004090 <userret>
    800037be:	8f11                	sub	a4,a4,a2
    800037c0:	97ba                	add	a5,a5,a4
    ((void (*)(uint64, uint64)) fn)(TRAPFRAME, satp);
    800037c2:	577d                	li	a4,-1
    800037c4:	177e                	slli	a4,a4,0x3f
    800037c6:	8dd9                	or	a1,a1,a4
    800037c8:	02000537          	lui	a0,0x2000
    800037cc:	157d                	addi	a0,a0,-1
    800037ce:	0536                	slli	a0,a0,0xd
    800037d0:	9782                	jalr	a5
}
    800037d2:	60a2                	ld	ra,8(sp)
    800037d4:	6402                	ld	s0,0(sp)
    800037d6:	0141                	addi	sp,sp,16
    800037d8:	8082                	ret

00000000800037da <clockintr>:
    w_sepc(sepc);
    w_sstatus(sstatus);
}

// 定时器中断处理程序
void clockintr() {
    800037da:	1101                	addi	sp,sp,-32
    800037dc:	ec06                	sd	ra,24(sp)
    800037de:	e822                	sd	s0,16(sp)
    800037e0:	e426                	sd	s1,8(sp)
    800037e2:	e04a                	sd	s2,0(sp)
    800037e4:	1000                	addi	s0,sp,32
    spin_lock(&ticks_lock);
    800037e6:	000a9917          	auipc	s2,0xa9
    800037ea:	23290913          	addi	s2,s2,562 # 800aca18 <ticks_lock>
    800037ee:	854a                	mv	a0,s2
    800037f0:	00000097          	auipc	ra,0x0
    800037f4:	cda080e7          	jalr	-806(ra) # 800034ca <spin_lock>
    ticks++;
    800037f8:	00003497          	auipc	s1,0x3
    800037fc:	81848493          	addi	s1,s1,-2024 # 80006010 <ticks>
    80003800:	609c                	ld	a5,0(s1)
    80003802:	0785                	addi	a5,a5,1
    80003804:	e09c                	sd	a5,0(s1)
    spin_unlock(&ticks_lock);
    80003806:	854a                	mv	a0,s2
    80003808:	00000097          	auipc	ra,0x0
    8000380c:	d96080e7          	jalr	-618(ra) # 8000359e <spin_unlock>
    wakeup(&ticks);
    80003810:	8526                	mv	a0,s1
    80003812:	ffffd097          	auipc	ra,0xffffd
    80003816:	27c080e7          	jalr	636(ra) # 80000a8e <wakeup>
}
    8000381a:	60e2                	ld	ra,24(sp)
    8000381c:	6442                	ld	s0,16(sp)
    8000381e:	64a2                	ld	s1,8(sp)
    80003820:	6902                	ld	s2,0(sp)
    80003822:	6105                	addi	sp,sp,32
    80003824:	8082                	ret

0000000080003826 <device_intr>:
// 设备中断处理程序
// 用于判断中断是否为外部和软件中断，并处理它
// 2: 时钟中断
// 1: 其他设备中断
// 0: 无法识别的中断
int device_intr() {
    80003826:	1101                	addi	sp,sp,-32
    80003828:	ec06                	sd	ra,24(sp)
    8000382a:	e822                	sd	s0,16(sp)
    8000382c:	e426                	sd	s1,8(sp)
    8000382e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003830:	14202773          	csrr	a4,scause
    uint64 scause = r_scause();

    if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80003834:	00074d63          	bltz	a4,8000384e <device_intr+0x28>
        // 告诉PLIC该设备现在被允许再次抛出中断
        if (irq)
            plic_complete(irq);

        return 1;
    } else if (scause == 0x8000000000000001L) {
    80003838:	57fd                	li	a5,-1
    8000383a:	17fe                	slli	a5,a5,0x3f
    8000383c:	0785                	addi	a5,a5,1
        }
        // 告知以收到软件中断，通过清除sip的SSIP位
        w_sip(r_sip() & ~2);
        return 2;
    } else {
        return 0;
    8000383e:	4501                	li	a0,0
    } else if (scause == 0x8000000000000001L) {
    80003840:	06f70363          	beq	a4,a5,800038a6 <device_intr+0x80>
    }
}
    80003844:	60e2                	ld	ra,24(sp)
    80003846:	6442                	ld	s0,16(sp)
    80003848:	64a2                	ld	s1,8(sp)
    8000384a:	6105                	addi	sp,sp,32
    8000384c:	8082                	ret
    if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    8000384e:	0ff77793          	andi	a5,a4,255
    80003852:	46a5                	li	a3,9
    80003854:	fed792e3          	bne	a5,a3,80003838 <device_intr+0x12>
        int irq = plic_claim();
    80003858:	ffffd097          	auipc	ra,0xffffd
    8000385c:	c20080e7          	jalr	-992(ra) # 80000478 <plic_claim>
    80003860:	84aa                	mv	s1,a0
        if (irq == UART0_IRQ) {
    80003862:	47a9                	li	a5,10
    80003864:	02f50763          	beq	a0,a5,80003892 <device_intr+0x6c>
        } else if (irq == VIRTIO0_IRQ) {
    80003868:	4785                	li	a5,1
    8000386a:	02f50963          	beq	a0,a5,8000389c <device_intr+0x76>
        return 1;
    8000386e:	4505                	li	a0,1
        } else if (irq) {
    80003870:	d8f1                	beqz	s1,80003844 <device_intr+0x1e>
            printf("unexpected interrupt irq=%d\n", irq);
    80003872:	85a6                	mv	a1,s1
    80003874:	00002517          	auipc	a0,0x2
    80003878:	c5450513          	addi	a0,a0,-940 # 800054c8 <digits+0x380>
    8000387c:	ffffe097          	auipc	ra,0xffffe
    80003880:	ab0080e7          	jalr	-1360(ra) # 8000132c <printf>
            plic_complete(irq);
    80003884:	8526                	mv	a0,s1
    80003886:	ffffd097          	auipc	ra,0xffffd
    8000388a:	c16080e7          	jalr	-1002(ra) # 8000049c <plic_complete>
        return 1;
    8000388e:	4505                	li	a0,1
    80003890:	bf55                	j	80003844 <device_intr+0x1e>
            uart_intr();
    80003892:	ffffd097          	auipc	ra,0xffffd
    80003896:	98a080e7          	jalr	-1654(ra) # 8000021c <uart_intr>
    8000389a:	b7ed                	j	80003884 <device_intr+0x5e>
            virtio_disk_intr();
    8000389c:	fffff097          	auipc	ra,0xfffff
    800038a0:	922080e7          	jalr	-1758(ra) # 800021be <virtio_disk_intr>
    800038a4:	b7c5                	j	80003884 <device_intr+0x5e>
        if (cpuid() == 0) {
    800038a6:	ffffd097          	auipc	ra,0xffffd
    800038aa:	f64080e7          	jalr	-156(ra) # 8000080a <cpuid>
    800038ae:	c901                	beqz	a0,800038be <device_intr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    800038b0:	144027f3          	csrr	a5,sip
        w_sip(r_sip() & ~2);
    800038b4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    800038b6:	14479073          	csrw	sip,a5
        return 2;
    800038ba:	4509                	li	a0,2
    800038bc:	b761                	j	80003844 <device_intr+0x1e>
            clockintr();
    800038be:	00000097          	auipc	ra,0x0
    800038c2:	f1c080e7          	jalr	-228(ra) # 800037da <clockintr>
    800038c6:	b7ed                	j	800038b0 <device_intr+0x8a>

00000000800038c8 <usertrap>:
void usertrap(void) {
    800038c8:	1101                	addi	sp,sp,-32
    800038ca:	ec06                	sd	ra,24(sp)
    800038cc:	e822                	sd	s0,16(sp)
    800038ce:	e426                	sd	s1,8(sp)
    800038d0:	e04a                	sd	s2,0(sp)
    800038d2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800038d4:	100027f3          	csrr	a5,sstatus
    if ((r_sstatus() & SSTATUS_SPP) != 0)
    800038d8:	1007f793          	andi	a5,a5,256
    800038dc:	e3ad                	bnez	a5,8000393e <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800038de:	ffffd797          	auipc	a5,0xffffd
    800038e2:	bf278793          	addi	a5,a5,-1038 # 800004d0 <kernelvec>
    800038e6:	10579073          	csrw	stvec,a5
    struct proc *p = myproc();
    800038ea:	ffffd097          	auipc	ra,0xffffd
    800038ee:	f4c080e7          	jalr	-180(ra) # 80000836 <myproc>
    800038f2:	84aa                	mv	s1,a0
    p->trapframe->epc = r_sepc();
    800038f4:	613c                	ld	a5,64(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800038f6:	14102773          	csrr	a4,sepc
    800038fa:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800038fc:	14202773          	csrr	a4,scause
    if (r_scause() == 8) {
    80003900:	47a1                	li	a5,8
    80003902:	04f71d63          	bne	a4,a5,8000395c <usertrap+0x94>
        if (p->killed)
    80003906:	591c                	lw	a5,48(a0)
    80003908:	e7a1                	bnez	a5,80003950 <usertrap+0x88>
        p->trapframe->epc += 4;
    8000390a:	60b8                	ld	a4,64(s1)
    8000390c:	6f1c                	ld	a5,24(a4)
    8000390e:	0791                	addi	a5,a5,4
    80003910:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003912:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80003916:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000391a:	10079073          	csrw	sstatus,a5
        syscall();
    8000391e:	00000097          	auipc	ra,0x0
    80003922:	2c2080e7          	jalr	706(ra) # 80003be0 <syscall>
    if (p->killed)
    80003926:	589c                	lw	a5,48(s1)
    80003928:	e3cd                	bnez	a5,800039ca <usertrap+0x102>
    usertrapret();
    8000392a:	00000097          	auipc	ra,0x0
    8000392e:	e12080e7          	jalr	-494(ra) # 8000373c <usertrapret>
}
    80003932:	60e2                	ld	ra,24(sp)
    80003934:	6442                	ld	s0,16(sp)
    80003936:	64a2                	ld	s1,8(sp)
    80003938:	6902                	ld	s2,0(sp)
    8000393a:	6105                	addi	sp,sp,32
    8000393c:	8082                	ret
        panic("usertrap: not from user mode");
    8000393e:	00002517          	auipc	a0,0x2
    80003942:	baa50513          	addi	a0,a0,-1110 # 800054e8 <digits+0x3a0>
    80003946:	ffffe097          	auipc	ra,0xffffe
    8000394a:	aaa080e7          	jalr	-1366(ra) # 800013f0 <panic>
    8000394e:	bf41                	j	800038de <usertrap+0x16>
            exit(-1);
    80003950:	557d                	li	a0,-1
    80003952:	ffffd097          	auipc	ra,0xffffd
    80003956:	3f0080e7          	jalr	1008(ra) # 80000d42 <exit>
    8000395a:	bf45                	j	8000390a <usertrap+0x42>
    } else if ((which_dev = device_intr()) != 0) {
    8000395c:	00000097          	auipc	ra,0x0
    80003960:	eca080e7          	jalr	-310(ra) # 80003826 <device_intr>
    80003964:	892a                	mv	s2,a0
    80003966:	c501                	beqz	a0,8000396e <usertrap+0xa6>
    if (p->killed)
    80003968:	589c                	lw	a5,48(s1)
    8000396a:	c3a1                	beqz	a5,800039aa <usertrap+0xe2>
    8000396c:	a815                	j	800039a0 <usertrap+0xd8>
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000396e:	142025f3          	csrr	a1,scause
        printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80003972:	5c90                	lw	a2,56(s1)
    80003974:	00002517          	auipc	a0,0x2
    80003978:	b9450513          	addi	a0,a0,-1132 # 80005508 <digits+0x3c0>
    8000397c:	ffffe097          	auipc	ra,0xffffe
    80003980:	9b0080e7          	jalr	-1616(ra) # 8000132c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003984:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80003988:	14302673          	csrr	a2,stval
        printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000398c:	00002517          	auipc	a0,0x2
    80003990:	bac50513          	addi	a0,a0,-1108 # 80005538 <digits+0x3f0>
    80003994:	ffffe097          	auipc	ra,0xffffe
    80003998:	998080e7          	jalr	-1640(ra) # 8000132c <printf>
        p->killed = 1;
    8000399c:	4785                	li	a5,1
    8000399e:	d89c                	sw	a5,48(s1)
        exit(-1);
    800039a0:	557d                	li	a0,-1
    800039a2:	ffffd097          	auipc	ra,0xffffd
    800039a6:	3a0080e7          	jalr	928(ra) # 80000d42 <exit>
    if (which_dev == 2) {
    800039aa:	4789                	li	a5,2
    800039ac:	f6f91fe3          	bne	s2,a5,8000392a <usertrap+0x62>
        panic("timer\n");
    800039b0:	00002517          	auipc	a0,0x2
    800039b4:	ba850513          	addi	a0,a0,-1112 # 80005558 <digits+0x410>
    800039b8:	ffffe097          	auipc	ra,0xffffe
    800039bc:	a38080e7          	jalr	-1480(ra) # 800013f0 <panic>
        yield();
    800039c0:	ffffd097          	auipc	ra,0xffffd
    800039c4:	466080e7          	jalr	1126(ra) # 80000e26 <yield>
    800039c8:	b78d                	j	8000392a <usertrap+0x62>
    int which_dev = 0;
    800039ca:	4901                	li	s2,0
    800039cc:	bfd1                	j	800039a0 <usertrap+0xd8>

00000000800039ce <kerneltrap>:
void kerneltrap() {
    800039ce:	7179                	addi	sp,sp,-48
    800039d0:	f406                	sd	ra,40(sp)
    800039d2:	f022                	sd	s0,32(sp)
    800039d4:	ec26                	sd	s1,24(sp)
    800039d6:	e84a                	sd	s2,16(sp)
    800039d8:	e44e                	sd	s3,8(sp)
    800039da:	e052                	sd	s4,0(sp)
    800039dc:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    800039de:	ffffd097          	auipc	ra,0xffffd
    800039e2:	e58080e7          	jalr	-424(ra) # 80000836 <myproc>
    800039e6:	84aa                	mv	s1,a0
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800039e8:	141029f3          	csrr	s3,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800039ec:	10002973          	csrr	s2,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800039f0:	14202a73          	csrr	s4,scause
    if ((sstatus & SSTATUS_SPP) == 0)
    800039f4:	10097793          	andi	a5,s2,256
    800039f8:	c79d                	beqz	a5,80003a26 <kerneltrap+0x58>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800039fa:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800039fe:	8b89                	andi	a5,a5,2
    if (intr_get() != 0)
    80003a00:	ef85                	bnez	a5,80003a38 <kerneltrap+0x6a>
    which_dev = device_intr();
    80003a02:	00000097          	auipc	ra,0x0
    80003a06:	e24080e7          	jalr	-476(ra) # 80003826 <device_intr>
    if (which_dev == 0) { // 未知来源
    80003a0a:	c121                	beqz	a0,80003a4a <kerneltrap+0x7c>
    if (which_dev == 2 && p != 0 && p->state == RUNNING) { // 时钟中断
    80003a0c:	4789                	li	a5,2
    80003a0e:	08f51863          	bne	a0,a5,80003a9e <kerneltrap+0xd0>
    80003a12:	c4d1                	beqz	s1,80003a9e <kerneltrap+0xd0>
    80003a14:	4c98                	lw	a4,24(s1)
    80003a16:	478d                	li	a5,3
    80003a18:	08f71363          	bne	a4,a5,80003a9e <kerneltrap+0xd0>
        yield();
    80003a1c:	ffffd097          	auipc	ra,0xffffd
    80003a20:	40a080e7          	jalr	1034(ra) # 80000e26 <yield>
    80003a24:	a8ad                	j	80003a9e <kerneltrap+0xd0>
        panic("kerneltrap: not from supervisor mode");
    80003a26:	00002517          	auipc	a0,0x2
    80003a2a:	b3a50513          	addi	a0,a0,-1222 # 80005560 <digits+0x418>
    80003a2e:	ffffe097          	auipc	ra,0xffffe
    80003a32:	9c2080e7          	jalr	-1598(ra) # 800013f0 <panic>
    80003a36:	b7d1                	j	800039fa <kerneltrap+0x2c>
        panic("kerneltrap: interrupts enabled");
    80003a38:	00002517          	auipc	a0,0x2
    80003a3c:	b5050513          	addi	a0,a0,-1200 # 80005588 <digits+0x440>
    80003a40:	ffffe097          	auipc	ra,0xffffe
    80003a44:	9b0080e7          	jalr	-1616(ra) # 800013f0 <panic>
    80003a48:	bf6d                	j	80003a02 <kerneltrap+0x34>
        printf("scause %p\n", scause);
    80003a4a:	85d2                	mv	a1,s4
    80003a4c:	00002517          	auipc	a0,0x2
    80003a50:	b5c50513          	addi	a0,a0,-1188 # 800055a8 <digits+0x460>
    80003a54:	ffffe097          	auipc	ra,0xffffe
    80003a58:	8d8080e7          	jalr	-1832(ra) # 8000132c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003a5c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80003a60:	14302673          	csrr	a2,stval
        printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003a64:	00002517          	auipc	a0,0x2
    80003a68:	b5450513          	addi	a0,a0,-1196 # 800055b8 <digits+0x470>
    80003a6c:	ffffe097          	auipc	ra,0xffffe
    80003a70:	8c0080e7          	jalr	-1856(ra) # 8000132c <printf>
        printf("process id = %d",myproc()->pid);
    80003a74:	ffffd097          	auipc	ra,0xffffd
    80003a78:	dc2080e7          	jalr	-574(ra) # 80000836 <myproc>
    80003a7c:	5d0c                	lw	a1,56(a0)
    80003a7e:	00002517          	auipc	a0,0x2
    80003a82:	b5250513          	addi	a0,a0,-1198 # 800055d0 <digits+0x488>
    80003a86:	ffffe097          	auipc	ra,0xffffe
    80003a8a:	8a6080e7          	jalr	-1882(ra) # 8000132c <printf>
        panic("kerneltrap");
    80003a8e:	00002517          	auipc	a0,0x2
    80003a92:	b5250513          	addi	a0,a0,-1198 # 800055e0 <digits+0x498>
    80003a96:	ffffe097          	auipc	ra,0xffffe
    80003a9a:	95a080e7          	jalr	-1702(ra) # 800013f0 <panic>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80003a9e:	14199073          	csrw	sepc,s3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003aa2:	10091073          	csrw	sstatus,s2
}
    80003aa6:	70a2                	ld	ra,40(sp)
    80003aa8:	7402                	ld	s0,32(sp)
    80003aaa:	64e2                	ld	s1,24(sp)
    80003aac:	6942                	ld	s2,16(sp)
    80003aae:	69a2                	ld	s3,8(sp)
    80003ab0:	6a02                	ld	s4,0(sp)
    80003ab2:	6145                	addi	sp,sp,48
    80003ab4:	8082                	ret

0000000080003ab6 <argraw>:
#include "../process.h"
#include "../defs.h"
#include "syscall.h"


uint64 argraw(int n) {
    80003ab6:	1101                	addi	sp,sp,-32
    80003ab8:	ec06                	sd	ra,24(sp)
    80003aba:	e822                	sd	s0,16(sp)
    80003abc:	e426                	sd	s1,8(sp)
    80003abe:	1000                	addi	s0,sp,32
    80003ac0:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80003ac2:	ffffd097          	auipc	ra,0xffffd
    80003ac6:	d74080e7          	jalr	-652(ra) # 80000836 <myproc>
    switch (n) {
    80003aca:	4795                	li	a5,5
    80003acc:	0497e163          	bltu	a5,s1,80003b0e <argraw+0x58>
    80003ad0:	048a                	slli	s1,s1,0x2
    80003ad2:	00002717          	auipc	a4,0x2
    80003ad6:	b5670713          	addi	a4,a4,-1194 # 80005628 <digits+0x4e0>
    80003ada:	94ba                	add	s1,s1,a4
    80003adc:	409c                	lw	a5,0(s1)
    80003ade:	97ba                	add	a5,a5,a4
    80003ae0:	8782                	jr	a5
        case 0:
            return p->trapframe->a0;
    80003ae2:	613c                	ld	a5,64(a0)
    80003ae4:	7ba8                	ld	a0,112(a5)
        case 5:
            return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    80003ae6:	60e2                	ld	ra,24(sp)
    80003ae8:	6442                	ld	s0,16(sp)
    80003aea:	64a2                	ld	s1,8(sp)
    80003aec:	6105                	addi	sp,sp,32
    80003aee:	8082                	ret
            return p->trapframe->a1;
    80003af0:	613c                	ld	a5,64(a0)
    80003af2:	7fa8                	ld	a0,120(a5)
    80003af4:	bfcd                	j	80003ae6 <argraw+0x30>
            return p->trapframe->a2;
    80003af6:	613c                	ld	a5,64(a0)
    80003af8:	63c8                	ld	a0,128(a5)
    80003afa:	b7f5                	j	80003ae6 <argraw+0x30>
            return p->trapframe->a3;
    80003afc:	613c                	ld	a5,64(a0)
    80003afe:	67c8                	ld	a0,136(a5)
    80003b00:	b7dd                	j	80003ae6 <argraw+0x30>
            return p->trapframe->a4;
    80003b02:	613c                	ld	a5,64(a0)
    80003b04:	6bc8                	ld	a0,144(a5)
    80003b06:	b7c5                	j	80003ae6 <argraw+0x30>
            return p->trapframe->a5;
    80003b08:	613c                	ld	a5,64(a0)
    80003b0a:	6fc8                	ld	a0,152(a5)
    80003b0c:	bfe9                	j	80003ae6 <argraw+0x30>
    panic("argraw");
    80003b0e:	00002517          	auipc	a0,0x2
    80003b12:	ae250513          	addi	a0,a0,-1310 # 800055f0 <digits+0x4a8>
    80003b16:	ffffe097          	auipc	ra,0xffffe
    80003b1a:	8da080e7          	jalr	-1830(ra) # 800013f0 <panic>
    return -1;
    80003b1e:	557d                	li	a0,-1
    80003b20:	b7d9                	j	80003ae6 <argraw+0x30>

0000000080003b22 <argint>:

/**
 * 获取第n个int类型参数
 */
int argint(int n, int *addr) {
    80003b22:	1101                	addi	sp,sp,-32
    80003b24:	ec06                	sd	ra,24(sp)
    80003b26:	e822                	sd	s0,16(sp)
    80003b28:	e426                	sd	s1,8(sp)
    80003b2a:	1000                	addi	s0,sp,32
    80003b2c:	84ae                	mv	s1,a1
    *addr = argraw(n);
    80003b2e:	00000097          	auipc	ra,0x0
    80003b32:	f88080e7          	jalr	-120(ra) # 80003ab6 <argraw>
    80003b36:	c088                	sw	a0,0(s1)
    return 0;
}
    80003b38:	4501                	li	a0,0
    80003b3a:	60e2                	ld	ra,24(sp)
    80003b3c:	6442                	ld	s0,16(sp)
    80003b3e:	64a2                	ld	s1,8(sp)
    80003b40:	6105                	addi	sp,sp,32
    80003b42:	8082                	ret

0000000080003b44 <argaddr>:
 *
 * @param n 参数的偏移量
 * @param ip 结果地址
 * @return
 */
int argaddr(int n, uint64 *addr) {
    80003b44:	1101                	addi	sp,sp,-32
    80003b46:	ec06                	sd	ra,24(sp)
    80003b48:	e822                	sd	s0,16(sp)
    80003b4a:	e426                	sd	s1,8(sp)
    80003b4c:	1000                	addi	s0,sp,32
    80003b4e:	84ae                	mv	s1,a1
    *addr = argraw(n);
    80003b50:	00000097          	auipc	ra,0x0
    80003b54:	f66080e7          	jalr	-154(ra) # 80003ab6 <argraw>
    80003b58:	e088                	sd	a0,0(s1)
    return 0;
}
    80003b5a:	4501                	li	a0,0
    80003b5c:	60e2                	ld	ra,24(sp)
    80003b5e:	6442                	ld	s0,16(sp)
    80003b60:	64a2                	ld	s1,8(sp)
    80003b62:	6105                	addi	sp,sp,32
    80003b64:	8082                	ret

0000000080003b66 <fetchstr>:
/**
 * 从当前进程的addr位置取出0结束的字符串。
 * 返回字符串的长度, 不包括0, 失败返回-1
 * @return
 */
int fetchstr(uint64 addr, char *buf, int max) {
    80003b66:	7179                	addi	sp,sp,-48
    80003b68:	f406                	sd	ra,40(sp)
    80003b6a:	f022                	sd	s0,32(sp)
    80003b6c:	ec26                	sd	s1,24(sp)
    80003b6e:	e84a                	sd	s2,16(sp)
    80003b70:	e44e                	sd	s3,8(sp)
    80003b72:	1800                	addi	s0,sp,48
    80003b74:	892a                	mv	s2,a0
    80003b76:	84ae                	mv	s1,a1
    80003b78:	89b2                	mv	s3,a2
    struct proc *p = myproc();
    80003b7a:	ffffd097          	auipc	ra,0xffffd
    80003b7e:	cbc080e7          	jalr	-836(ra) # 80000836 <myproc>
    int err = copyinstr(p->pagetable, buf, addr, max);
    80003b82:	86ce                	mv	a3,s3
    80003b84:	864a                	mv	a2,s2
    80003b86:	85a6                	mv	a1,s1
    80003b88:	6528                	ld	a0,72(a0)
    80003b8a:	ffffe097          	auipc	ra,0xffffe
    80003b8e:	e4e080e7          	jalr	-434(ra) # 800019d8 <copyinstr>
    if (err < 0)
    80003b92:	00054863          	bltz	a0,80003ba2 <fetchstr+0x3c>
        return err;
    return strlen(buf);
    80003b96:	8526                	mv	a0,s1
    80003b98:	ffffd097          	auipc	ra,0xffffd
    80003b9c:	356080e7          	jalr	854(ra) # 80000eee <strlen>
    80003ba0:	2501                	sext.w	a0,a0
}
    80003ba2:	70a2                	ld	ra,40(sp)
    80003ba4:	7402                	ld	s0,32(sp)
    80003ba6:	64e2                	ld	s1,24(sp)
    80003ba8:	6942                	ld	s2,16(sp)
    80003baa:	69a2                	ld	s3,8(sp)
    80003bac:	6145                	addi	sp,sp,48
    80003bae:	8082                	ret

0000000080003bb0 <argstr>:
/**
 * 获取第n个系统调用参数作为0结束的字符串
 *  复制到buf中, 最多复制max
 */

int argstr(int n, char *buf, int max) {
    80003bb0:	1101                	addi	sp,sp,-32
    80003bb2:	ec06                	sd	ra,24(sp)
    80003bb4:	e822                	sd	s0,16(sp)
    80003bb6:	e426                	sd	s1,8(sp)
    80003bb8:	e04a                	sd	s2,0(sp)
    80003bba:	1000                	addi	s0,sp,32
    80003bbc:	84ae                	mv	s1,a1
    80003bbe:	8932                	mv	s2,a2
    *addr = argraw(n);
    80003bc0:	00000097          	auipc	ra,0x0
    80003bc4:	ef6080e7          	jalr	-266(ra) # 80003ab6 <argraw>
    uint64 addr;
    if (argaddr(n, &addr) < 0)
        return -1;
    return fetchstr(addr, buf, max);
    80003bc8:	864a                	mv	a2,s2
    80003bca:	85a6                	mv	a1,s1
    80003bcc:	00000097          	auipc	ra,0x0
    80003bd0:	f9a080e7          	jalr	-102(ra) # 80003b66 <fetchstr>
}
    80003bd4:	60e2                	ld	ra,24(sp)
    80003bd6:	6442                	ld	s0,16(sp)
    80003bd8:	64a2                	ld	s1,8(sp)
    80003bda:	6902                	ld	s2,0(sp)
    80003bdc:	6105                	addi	sp,sp,32
    80003bde:	8082                	ret

0000000080003be0 <syscall>:
        [SYS_fork] sys_fork,
};

#define NELEM(x) (sizeof(x)/sizeof((x)[0]))

void syscall(void) {
    80003be0:	1101                	addi	sp,sp,-32
    80003be2:	ec06                	sd	ra,24(sp)
    80003be4:	e822                	sd	s0,16(sp)
    80003be6:	e426                	sd	s1,8(sp)
    80003be8:	e04a                	sd	s2,0(sp)
    80003bea:	1000                	addi	s0,sp,32
    int num;
    struct proc *p = myproc();
    80003bec:	ffffd097          	auipc	ra,0xffffd
    80003bf0:	c4a080e7          	jalr	-950(ra) # 80000836 <myproc>
    80003bf4:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    80003bf6:	04053903          	ld	s2,64(a0)
    80003bfa:	0a893783          	ld	a5,168(s2)
    80003bfe:	0007869b          	sext.w	a3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80003c02:	37fd                	addiw	a5,a5,-1
    80003c04:	4711                	li	a4,4
    80003c06:	00f76f63          	bltu	a4,a5,80003c24 <syscall+0x44>
    80003c0a:	00369713          	slli	a4,a3,0x3
    80003c0e:	00002797          	auipc	a5,0x2
    80003c12:	a3278793          	addi	a5,a5,-1486 # 80005640 <syscalls>
    80003c16:	97ba                	add	a5,a5,a4
    80003c18:	639c                	ld	a5,0(a5)
    80003c1a:	c789                	beqz	a5,80003c24 <syscall+0x44>
        p->trapframe->a0 = syscalls[num]();
    80003c1c:	9782                	jalr	a5
    80003c1e:	06a93823          	sd	a0,112(s2)
    80003c22:	a03d                	j	80003c50 <syscall+0x70>
    } else {
        printf("%d %s: unknown sys call %d\n",
    80003c24:	0d848613          	addi	a2,s1,216
    80003c28:	5c8c                	lw	a1,56(s1)
    80003c2a:	00002517          	auipc	a0,0x2
    80003c2e:	9ce50513          	addi	a0,a0,-1586 # 800055f8 <digits+0x4b0>
    80003c32:	ffffd097          	auipc	ra,0xffffd
    80003c36:	6fa080e7          	jalr	1786(ra) # 8000132c <printf>
               p->pid, p->name, num);
        p->trapframe->a0 = -1;
    80003c3a:	60bc                	ld	a5,64(s1)
    80003c3c:	577d                	li	a4,-1
    80003c3e:	fbb8                	sd	a4,112(a5)
        panic("syscall error");
    80003c40:	00002517          	auipc	a0,0x2
    80003c44:	9d850513          	addi	a0,a0,-1576 # 80005618 <digits+0x4d0>
    80003c48:	ffffd097          	auipc	ra,0xffffd
    80003c4c:	7a8080e7          	jalr	1960(ra) # 800013f0 <panic>
    }
    80003c50:	60e2                	ld	ra,24(sp)
    80003c52:	6442                	ld	s0,16(sp)
    80003c54:	64a2                	ld	s1,8(sp)
    80003c56:	6902                	ld	s2,0(sp)
    80003c58:	6105                	addi	sp,sp,32
    80003c5a:	8082                	ret

0000000080003c5c <sys_putchar>:
#include "../memlayout.h"
#include "../lock/lock.h"
#include "../process.h"
#include "../defs.h"

uint64 sys_putchar(void) {
    80003c5c:	1141                	addi	sp,sp,-16
    80003c5e:	e406                	sd	ra,8(sp)
    80003c60:	e022                	sd	s0,0(sp)
    80003c62:	0800                	addi	s0,sp,16
    putc(0, argraw(0));
    80003c64:	4501                	li	a0,0
    80003c66:	00000097          	auipc	ra,0x0
    80003c6a:	e50080e7          	jalr	-432(ra) # 80003ab6 <argraw>
    80003c6e:	0ff57593          	andi	a1,a0,255
    80003c72:	4501                	li	a0,0
    80003c74:	ffffc097          	auipc	ra,0xffffc
    80003c78:	5d8080e7          	jalr	1496(ra) # 8000024c <putc>
    return 0;
}
    80003c7c:	4501                	li	a0,0
    80003c7e:	60a2                	ld	ra,8(sp)
    80003c80:	6402                	ld	s0,0(sp)
    80003c82:	0141                	addi	sp,sp,16
    80003c84:	8082                	ret

0000000080003c86 <sys_exec>:

uint64 sys_exec(void) {
    80003c86:	7175                	addi	sp,sp,-144
    80003c88:	e506                	sd	ra,136(sp)
    80003c8a:	e122                	sd	s0,128(sp)
    80003c8c:	0900                	addi	s0,sp,144
    char path[MAXPATH];
    if (argstr(0, path, MAXPATH) < 0) {
    80003c8e:	08000613          	li	a2,128
    80003c92:	f7040593          	addi	a1,s0,-144
    80003c96:	4501                	li	a0,0
    80003c98:	00000097          	auipc	ra,0x0
    80003c9c:	f18080e7          	jalr	-232(ra) # 80003bb0 <argstr>
    80003ca0:	87aa                	mv	a5,a0
        return -1;
    80003ca2:	557d                	li	a0,-1
    if (argstr(0, path, MAXPATH) < 0) {
    80003ca4:	0007c963          	bltz	a5,80003cb6 <sys_exec+0x30>
    }
    return exec(path, 0);
    80003ca8:	4581                	li	a1,0
    80003caa:	f7040513          	addi	a0,s0,-144
    80003cae:	ffffe097          	auipc	ra,0xffffe
    80003cb2:	70a080e7          	jalr	1802(ra) # 800023b8 <exec>
}
    80003cb6:	60aa                	ld	ra,136(sp)
    80003cb8:	640a                	ld	s0,128(sp)
    80003cba:	6149                	addi	sp,sp,144
    80003cbc:	8082                	ret

0000000080003cbe <sys_read>:

uint64 sys_read(void) {
    80003cbe:	7175                	addi	sp,sp,-144
    80003cc0:	e506                	sd	ra,136(sp)
    80003cc2:	e122                	sd	s0,128(sp)
    80003cc4:	fca6                	sd	s1,120(sp)
    80003cc6:	f8ca                	sd	s2,112(sp)
    80003cc8:	0900                	addi	s0,sp,144
    uint64 va = 0;
    80003cca:	fc043c23          	sd	zero,-40(s0)
    char buf[100];
    if (argaddr(0, &va) < 0) {
    80003cce:	fd840593          	addi	a1,s0,-40
    80003cd2:	4501                	li	a0,0
    80003cd4:	00000097          	auipc	ra,0x0
    80003cd8:	e70080e7          	jalr	-400(ra) # 80003b44 <argaddr>
    80003cdc:	87aa                	mv	a5,a0
        return -1;
    80003cde:	557d                	li	a0,-1
    if (argaddr(0, &va) < 0) {
    80003ce0:	0607c163          	bltz	a5,80003d42 <sys_read+0x84>
    }
//    read_line(buf);
    buf[0] = 'a';
    80003ce4:	06100793          	li	a5,97
    80003ce8:	f6f40823          	sb	a5,-144(s0)
    buf[1] = 0;
    80003cec:	f60408a3          	sb	zero,-143(s0)
    printf("buf=%s", buf);
    80003cf0:	f7040593          	addi	a1,s0,-144
    80003cf4:	00002517          	auipc	a0,0x2
    80003cf8:	97c50513          	addi	a0,a0,-1668 # 80005670 <syscalls+0x30>
    80003cfc:	ffffd097          	auipc	ra,0xffffd
    80003d00:	630080e7          	jalr	1584(ra) # 8000132c <printf>
    copyout(myproc()->pagetable, va, buf, strlen(buf));
    80003d04:	ffffd097          	auipc	ra,0xffffd
    80003d08:	b32080e7          	jalr	-1230(ra) # 80000836 <myproc>
    80003d0c:	6524                	ld	s1,72(a0)
    80003d0e:	fd843903          	ld	s2,-40(s0)
    80003d12:	f7040513          	addi	a0,s0,-144
    80003d16:	ffffd097          	auipc	ra,0xffffd
    80003d1a:	1d8080e7          	jalr	472(ra) # 80000eee <strlen>
    80003d1e:	0005069b          	sext.w	a3,a0
    80003d22:	f7040613          	addi	a2,s0,-144
    80003d26:	85ca                	mv	a1,s2
    80003d28:	8526                	mv	a0,s1
    80003d2a:	ffffe097          	auipc	ra,0xffffe
    80003d2e:	d6c080e7          	jalr	-660(ra) # 80001a96 <copyout>
    return strlen(buf);
    80003d32:	f7040513          	addi	a0,s0,-144
    80003d36:	ffffd097          	auipc	ra,0xffffd
    80003d3a:	1b8080e7          	jalr	440(ra) # 80000eee <strlen>
    80003d3e:	1502                	slli	a0,a0,0x20
    80003d40:	9101                	srli	a0,a0,0x20
}
    80003d42:	60aa                	ld	ra,136(sp)
    80003d44:	640a                	ld	s0,128(sp)
    80003d46:	74e6                	ld	s1,120(sp)
    80003d48:	7946                	ld	s2,112(sp)
    80003d4a:	6149                	addi	sp,sp,144
    80003d4c:	8082                	ret

0000000080003d4e <sys_exit>:

//
// 进程相关的系统调用
//

uint64 sys_exit(void) {
    80003d4e:	1101                	addi	sp,sp,-32
    80003d50:	ec06                	sd	ra,24(sp)
    80003d52:	e822                	sd	s0,16(sp)
    80003d54:	1000                	addi	s0,sp,32
    int status = 0;
    80003d56:	fe042623          	sw	zero,-20(s0)
    if (argint(0, &status) < 0) {
    80003d5a:	fec40593          	addi	a1,s0,-20
    80003d5e:	4501                	li	a0,0
    80003d60:	00000097          	auipc	ra,0x0
    80003d64:	dc2080e7          	jalr	-574(ra) # 80003b22 <argint>
        return -1;
    80003d68:	57fd                	li	a5,-1
    if (argint(0, &status) < 0) {
    80003d6a:	00054963          	bltz	a0,80003d7c <sys_exit+0x2e>
    }
    exit(status);
    80003d6e:	fec42503          	lw	a0,-20(s0)
    80003d72:	ffffd097          	auipc	ra,0xffffd
    80003d76:	fd0080e7          	jalr	-48(ra) # 80000d42 <exit>
    return 0;
    80003d7a:	4781                	li	a5,0
}
    80003d7c:	853e                	mv	a0,a5
    80003d7e:	60e2                	ld	ra,24(sp)
    80003d80:	6442                	ld	s0,16(sp)
    80003d82:	6105                	addi	sp,sp,32
    80003d84:	8082                	ret

0000000080003d86 <sys_fork>:

uint64 sys_fork(void) {
    80003d86:	1141                	addi	sp,sp,-16
    80003d88:	e406                	sd	ra,8(sp)
    80003d8a:	e022                	sd	s0,0(sp)
    80003d8c:	0800                	addi	s0,sp,16
    return fork();
    80003d8e:	ffffd097          	auipc	ra,0xffffd
    80003d92:	e12080e7          	jalr	-494(ra) # 80000ba0 <fork>
}
    80003d96:	60a2                	ld	ra,8(sp)
    80003d98:	6402                	ld	s0,0(sp)
    80003d9a:	0141                	addi	sp,sp,16
    80003d9c:	8082                	ret
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
