
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00007117          	auipc	sp,0x7
    80000004:	12010113          	addi	sp,sp,288 # 80007120 <stack0>
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
    8000004a:	00007717          	auipc	a4,0x7
    8000004e:	fd670713          	addi	a4,a4,-42 # 80007020 <mscratch0>
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
    80000060:	68478793          	addi	a5,a5,1668 # 800006e0 <timervec>
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
    80000094:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ff4d417>
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
#include "lock/lock.h"
#include "process.h"
#include "defs.h"

void main() {
    800000ec:	1141                	addi	sp,sp,-16
    800000ee:	e406                	sd	ra,8(sp)
    800000f0:	e022                	sd	s0,0(sp)
    800000f2:	0800                	addi	s0,sp,16
    console_init();         // 初始化控制台
    800000f4:	00000097          	auipc	ra,0x0
    800000f8:	46a080e7          	jalr	1130(ra) # 8000055e <console_init>
    printf("\n");
    800000fc:	00006517          	auipc	a0,0x6
    80000100:	fc450513          	addi	a0,a0,-60 # 800060c0 <etext+0xc0>
    80000104:	00001097          	auipc	ra,0x1
    80000108:	4ae080e7          	jalr	1198(ra) # 800015b2 <printf>
    printf("xv6 kernel is booting\n");
    8000010c:	00006517          	auipc	a0,0x6
    80000110:	ef450513          	addi	a0,a0,-268 # 80006000 <etext>
    80000114:	00001097          	auipc	ra,0x1
    80000118:	49e080e7          	jalr	1182(ra) # 800015b2 <printf>
    printf("\n");
    8000011c:	00006517          	auipc	a0,0x6
    80000120:	fa450513          	addi	a0,a0,-92 # 800060c0 <etext+0xc0>
    80000124:	00001097          	auipc	ra,0x1
    80000128:	48e080e7          	jalr	1166(ra) # 800015b2 <printf>
    trapinit();             // 初始化trap
    8000012c:	00004097          	auipc	ra,0x4
    80000130:	cac080e7          	jalr	-852(ra) # 80003dd8 <trapinit>
    plicinit();             // 初始化plic
    80000134:	00000097          	auipc	ra,0x0
    80000138:	476080e7          	jalr	1142(ra) # 800005aa <plicinit>
    plicinithart();
    8000013c:	00000097          	auipc	ra,0x0
    80000140:	484080e7          	jalr	1156(ra) # 800005c0 <plicinithart>
    kernel_mem_init();      // 初始化内存
    80000144:	00001097          	auipc	ra,0x1
    80000148:	610080e7          	jalr	1552(ra) # 80001754 <kernel_mem_init>
    kernel_vm_init();       // 初始化内核虚拟内存
    8000014c:	00002097          	auipc	ra,0x2
    80000150:	88c080e7          	jalr	-1908(ra) # 800019d8 <kernel_vm_init>
    vm_hart_init();         // 启用分页
    80000154:	00001097          	auipc	ra,0x1
    80000158:	69c080e7          	jalr	1692(ra) # 800017f0 <vm_hart_init>
    virtio_disk_init();     // 初始化磁盘
    8000015c:	00002097          	auipc	ra,0x2
    80000160:	eca080e7          	jalr	-310(ra) # 80002026 <virtio_disk_init>
    init_inode_cache();     // 初始化inode cache
    80000164:	00003097          	auipc	ra,0x3
    80000168:	c3e080e7          	jalr	-962(ra) # 80002da2 <init_inode_cache>
    init_buf();             // 初始化磁盘块缓冲
    8000016c:	00003097          	auipc	ra,0x3
    80000170:	7a4080e7          	jalr	1956(ra) # 80003910 <init_buf>
    init_process_table();   // 初始化进程表
    80000174:	00000097          	auipc	ra,0x0
    80000178:	5e2080e7          	jalr	1506(ra) # 80000756 <init_process_table>
    init_first_process();   // 初始化第一个进程
    8000017c:	00000097          	auipc	ra,0x0
    80000180:	76c080e7          	jalr	1900(ra) # 800008e8 <init_first_process>
    scheduler();
    80000184:	00001097          	auipc	ra,0x1
    80000188:	a64080e7          	jalr	-1436(ra) # 80000be8 <scheduler>
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
    8000023c:	24c080e7          	jalr	588(ra) # 80000484 <console_intr>
  {
    80000240:	b7e5                	j	80000228 <uart_intr+0xc>
  }
}
    80000242:	60e2                	ld	ra,24(sp)
    80000244:	6442                	ld	s0,16(sp)
    80000246:	64a2                	ld	s1,8(sp)
    80000248:	6105                	addi	sp,sp,32
    8000024a:	8082                	ret

000000008000024c <console_write>:
}

/**
 * 向控制台写入数据
 */
int console_write(int user_src, uint64 src, int n) {
    8000024c:	7139                	addi	sp,sp,-64
    8000024e:	fc06                	sd	ra,56(sp)
    80000250:	f822                	sd	s0,48(sp)
    80000252:	f426                	sd	s1,40(sp)
    80000254:	f04a                	sd	s2,32(sp)
    80000256:	ec4e                	sd	s3,24(sp)
    80000258:	e852                	sd	s4,16(sp)
    8000025a:	0080                	addi	s0,sp,64
    int i;
    for (i = 0; i < n; i++) {
    8000025c:	04c05463          	blez	a2,800002a4 <console_write+0x58>
    80000260:	8a2a                	mv	s4,a0
    80000262:	84ae                	mv	s1,a1
    80000264:	89b2                	mv	s3,a2
    80000266:	4901                	li	s2,0
        char c;
        if (either_copyin(&c, user_src, src + i, 1) < 0) {
    80000268:	4685                	li	a3,1
    8000026a:	8626                	mv	a2,s1
    8000026c:	85d2                	mv	a1,s4
    8000026e:	fcf40513          	addi	a0,s0,-49
    80000272:	00001097          	auipc	ra,0x1
    80000276:	e38080e7          	jalr	-456(ra) # 800010aa <either_copyin>
    8000027a:	00054c63          	bltz	a0,80000292 <console_write+0x46>
            break;
        }
        uartputc_sync(c);
    8000027e:	fcf44503          	lbu	a0,-49(s0)
    80000282:	00000097          	auipc	ra,0x0
    80000286:	f48080e7          	jalr	-184(ra) # 800001ca <uartputc_sync>
    for (i = 0; i < n; i++) {
    8000028a:	2905                	addiw	s2,s2,1
    8000028c:	0485                	addi	s1,s1,1
    8000028e:	fd299de3          	bne	s3,s2,80000268 <console_write+0x1c>
    }
    return i;
}
    80000292:	854a                	mv	a0,s2
    80000294:	70e2                	ld	ra,56(sp)
    80000296:	7442                	ld	s0,48(sp)
    80000298:	74a2                	ld	s1,40(sp)
    8000029a:	7902                	ld	s2,32(sp)
    8000029c:	69e2                	ld	s3,24(sp)
    8000029e:	6a42                	ld	s4,16(sp)
    800002a0:	6121                	addi	sp,sp,64
    800002a2:	8082                	ret
    for (i = 0; i < n; i++) {
    800002a4:	4901                	li	s2,0
    800002a6:	b7f5                	j	80000292 <console_write+0x46>

00000000800002a8 <console_read>:

/**
 * 从控制台读取数据，每次读取一行或者n个字节
 */
int console_read(int user_dst, uint64 dst, int n) {
    800002a8:	711d                	addi	sp,sp,-96
    800002aa:	ec86                	sd	ra,88(sp)
    800002ac:	e8a2                	sd	s0,80(sp)
    800002ae:	e4a6                	sd	s1,72(sp)
    800002b0:	e0ca                	sd	s2,64(sp)
    800002b2:	fc4e                	sd	s3,56(sp)
    800002b4:	f852                	sd	s4,48(sp)
    800002b6:	f456                	sd	s5,40(sp)
    800002b8:	f05a                	sd	s6,32(sp)
    800002ba:	ec5e                	sd	s7,24(sp)
    800002bc:	e862                	sd	s8,16(sp)
    800002be:	1080                	addi	s0,sp,96
    800002c0:	8aaa                	mv	s5,a0
    800002c2:	89ae                	mv	s3,a1
    800002c4:	8c32                	mv	s8,a2
    char c;
    int expect = n;
    spin_lock(&consloe.lock);
    800002c6:	00008517          	auipc	a0,0x8
    800002ca:	e5a50513          	addi	a0,a0,-422 # 80008120 <consloe>
    800002ce:	00004097          	auipc	ra,0x4
    800002d2:	8b0080e7          	jalr	-1872(ra) # 80003b7e <spin_lock>
    while (n > 0) {
    800002d6:	8a62                	mv	s4,s8
        while (consloe.read_index == consloe.write_index) {
    800002d8:	00008497          	auipc	s1,0x8
    800002dc:	e4848493          	addi	s1,s1,-440 # 80008120 <consloe>
            sleep(&consloe.read_index, &consloe.lock);
    800002e0:	00008917          	auipc	s2,0x8
    800002e4:	f2090913          	addi	s2,s2,-224 # 80008200 <consloe+0xe0>
        }
        c = consloe.buf[consloe.read_index++ % INPUT_BUF];
    800002e8:	0c800b13          	li	s6,200
        if (either_copyout(user_dst, dst, &c, 1) < 0)
            break;
        dst++;
        n--;
        // 当输入一整行时，需要返回
        if (c == '\n') {
    800002ec:	4ba9                	li	s7,10
    while (n > 0) {
    800002ee:	a889                	j	80000340 <console_read+0x98>
            sleep(&consloe.read_index, &consloe.lock);
    800002f0:	85a6                	mv	a1,s1
    800002f2:	854a                	mv	a0,s2
    800002f4:	00000097          	auipc	ra,0x0
    800002f8:	7be080e7          	jalr	1982(ra) # 80000ab2 <sleep>
        while (consloe.read_index == consloe.write_index) {
    800002fc:	0e04a783          	lw	a5,224(s1)
    80000300:	0e44a703          	lw	a4,228(s1)
    80000304:	fef706e3          	beq	a4,a5,800002f0 <console_read+0x48>
        c = consloe.buf[consloe.read_index++ % INPUT_BUF];
    80000308:	0017871b          	addiw	a4,a5,1
    8000030c:	0ee4a023          	sw	a4,224(s1)
    80000310:	0367e7bb          	remw	a5,a5,s6
    80000314:	97a6                	add	a5,a5,s1
    80000316:	0187c783          	lbu	a5,24(a5)
    8000031a:	faf407a3          	sb	a5,-81(s0)
        if (either_copyout(user_dst, dst, &c, 1) < 0)
    8000031e:	4685                	li	a3,1
    80000320:	faf40613          	addi	a2,s0,-81
    80000324:	85ce                	mv	a1,s3
    80000326:	8556                	mv	a0,s5
    80000328:	00001097          	auipc	ra,0x1
    8000032c:	d3a080e7          	jalr	-710(ra) # 80001062 <either_copyout>
    80000330:	02054163          	bltz	a0,80000352 <console_read+0xaa>
        dst++;
    80000334:	0985                	addi	s3,s3,1
        n--;
    80000336:	3a7d                	addiw	s4,s4,-1
        if (c == '\n') {
    80000338:	faf44783          	lbu	a5,-81(s0)
    8000033c:	01778b63          	beq	a5,s7,80000352 <console_read+0xaa>
    while (n > 0) {
    80000340:	01405963          	blez	s4,80000352 <console_read+0xaa>
        while (consloe.read_index == consloe.write_index) {
    80000344:	0e04a783          	lw	a5,224(s1)
    80000348:	0e44a703          	lw	a4,228(s1)
    8000034c:	faf702e3          	beq	a4,a5,800002f0 <console_read+0x48>
    80000350:	bf65                	j	80000308 <console_read+0x60>
            break;
        }
    }
    spin_unlock(&consloe.lock);
    80000352:	00008517          	auipc	a0,0x8
    80000356:	dce50513          	addi	a0,a0,-562 # 80008120 <consloe>
    8000035a:	00004097          	auipc	ra,0x4
    8000035e:	8f8080e7          	jalr	-1800(ra) # 80003c52 <spin_unlock>
    return expect - n;
}
    80000362:	414c053b          	subw	a0,s8,s4
    80000366:	60e6                	ld	ra,88(sp)
    80000368:	6446                	ld	s0,80(sp)
    8000036a:	64a6                	ld	s1,72(sp)
    8000036c:	6906                	ld	s2,64(sp)
    8000036e:	79e2                	ld	s3,56(sp)
    80000370:	7a42                	ld	s4,48(sp)
    80000372:	7aa2                	ld	s5,40(sp)
    80000374:	7b02                	ld	s6,32(sp)
    80000376:	6be2                	ld	s7,24(sp)
    80000378:	6c42                	ld	s8,16(sp)
    8000037a:	6125                	addi	sp,sp,96
    8000037c:	8082                	ret

000000008000037e <putc>:
void putc(int fs, char ch) {
    8000037e:	1141                	addi	sp,sp,-16
    80000380:	e406                	sd	ra,8(sp)
    80000382:	e022                	sd	s0,0(sp)
    80000384:	0800                	addi	s0,sp,16
    uartputc_sync(ch);
    80000386:	852e                	mv	a0,a1
    80000388:	00000097          	auipc	ra,0x0
    8000038c:	e42080e7          	jalr	-446(ra) # 800001ca <uartputc_sync>
}
    80000390:	60a2                	ld	ra,8(sp)
    80000392:	6402                	ld	s0,0(sp)
    80000394:	0141                	addi	sp,sp,16
    80000396:	8082                	ret

0000000080000398 <read_line>:

int read_line(char *s) {
    80000398:	1101                	addi	sp,sp,-32
    8000039a:	ec06                	sd	ra,24(sp)
    8000039c:	e822                	sd	s0,16(sp)
    8000039e:	e426                	sd	s1,8(sp)
    800003a0:	e04a                	sd	s2,0(sp)
    800003a2:	1000                	addi	s0,sp,32
    800003a4:	892a                	mv	s2,a0
    int cnt = 0;
    spin_lock(&consloe.lock);
    800003a6:	00008497          	auipc	s1,0x8
    800003aa:	d7a48493          	addi	s1,s1,-646 # 80008120 <consloe>
    800003ae:	8526                	mv	a0,s1
    800003b0:	00003097          	auipc	ra,0x3
    800003b4:	7ce080e7          	jalr	1998(ra) # 80003b7e <spin_lock>
    sleep(&consloe.read_index, &consloe.lock);
    800003b8:	85a6                	mv	a1,s1
    800003ba:	00008517          	auipc	a0,0x8
    800003be:	e4650513          	addi	a0,a0,-442 # 80008200 <consloe+0xe0>
    800003c2:	00000097          	auipc	ra,0x0
    800003c6:	6f0080e7          	jalr	1776(ra) # 80000ab2 <sleep>
    for (int i = consloe.read_index; i < consloe.write_index; i++) {
    800003ca:	0e04a783          	lw	a5,224(s1)
    800003ce:	0e44a703          	lw	a4,228(s1)
    800003d2:	02e7d963          	bge	a5,a4,80000404 <read_line+0x6c>
    800003d6:	864a                	mv	a2,s2
    int cnt = 0;
    800003d8:	4681                	li	a3,0
        s[cnt++] = consloe.buf[i % INPUT_BUF];
    800003da:	85a6                	mv	a1,s1
    800003dc:	0c800813          	li	a6,200
        if (consloe.buf[i % INPUT_BUF] == '\n') {
    800003e0:	4529                	li	a0,10
        s[cnt++] = consloe.buf[i % INPUT_BUF];
    800003e2:	84b6                	mv	s1,a3
    800003e4:	2685                	addiw	a3,a3,1
    800003e6:	0307e73b          	remw	a4,a5,a6
    800003ea:	972e                	add	a4,a4,a1
    800003ec:	01874703          	lbu	a4,24(a4)
    800003f0:	00e60023          	sb	a4,0(a2)
        if (consloe.buf[i % INPUT_BUF] == '\n') {
    800003f4:	02a70863          	beq	a4,a0,80000424 <read_line+0x8c>
    for (int i = consloe.read_index; i < consloe.write_index; i++) {
    800003f8:	2785                	addiw	a5,a5,1
    800003fa:	0605                	addi	a2,a2,1
    800003fc:	0e45a703          	lw	a4,228(a1)
    80000400:	fee7c1e3          	blt	a5,a4,800003e2 <read_line+0x4a>
            s[cnt - 1] = 0;
            spin_unlock(&consloe.lock);
            return cnt - 1;
        }
    }
    spin_unlock(&consloe.lock);
    80000404:	00008517          	auipc	a0,0x8
    80000408:	d1c50513          	addi	a0,a0,-740 # 80008120 <consloe>
    8000040c:	00004097          	auipc	ra,0x4
    80000410:	846080e7          	jalr	-1978(ra) # 80003c52 <spin_unlock>
    return -1;
    80000414:	54fd                	li	s1,-1
}
    80000416:	8526                	mv	a0,s1
    80000418:	60e2                	ld	ra,24(sp)
    8000041a:	6442                	ld	s0,16(sp)
    8000041c:	64a2                	ld	s1,8(sp)
    8000041e:	6902                	ld	s2,0(sp)
    80000420:	6105                	addi	sp,sp,32
    80000422:	8082                	ret
            consloe.read_index = i + 1;
    80000424:	00008517          	auipc	a0,0x8
    80000428:	cfc50513          	addi	a0,a0,-772 # 80008120 <consloe>
    8000042c:	2785                	addiw	a5,a5,1
    8000042e:	0ef52023          	sw	a5,224(a0)
            s[cnt - 1] = 0;
    80000432:	96ca                	add	a3,a3,s2
    80000434:	fe068fa3          	sb	zero,-1(a3)
            spin_unlock(&consloe.lock);
    80000438:	00004097          	auipc	ra,0x4
    8000043c:	81a080e7          	jalr	-2022(ra) # 80003c52 <spin_unlock>
            return cnt - 1;
    80000440:	bfd9                	j	80000416 <read_line+0x7e>

0000000080000442 <console_putc>:

void console_putc(int c) {
    80000442:	1141                	addi	sp,sp,-16
    80000444:	e406                	sd	ra,8(sp)
    80000446:	e022                	sd	s0,0(sp)
    80000448:	0800                	addi	s0,sp,16
    if (c == BACKSPACE) {
    8000044a:	10000793          	li	a5,256
    8000044e:	00f50a63          	beq	a0,a5,80000462 <console_putc+0x20>
        // if the user typed backspace, overwrite with a space.
        uartputc_sync('\b');
        uartputc_sync(' ');
        uartputc_sync('\b');
    } else {
        uartputc_sync(c);
    80000452:	00000097          	auipc	ra,0x0
    80000456:	d78080e7          	jalr	-648(ra) # 800001ca <uartputc_sync>
    }
}
    8000045a:	60a2                	ld	ra,8(sp)
    8000045c:	6402                	ld	s0,0(sp)
    8000045e:	0141                	addi	sp,sp,16
    80000460:	8082                	ret
        uartputc_sync('\b');
    80000462:	4521                	li	a0,8
    80000464:	00000097          	auipc	ra,0x0
    80000468:	d66080e7          	jalr	-666(ra) # 800001ca <uartputc_sync>
        uartputc_sync(' ');
    8000046c:	02000513          	li	a0,32
    80000470:	00000097          	auipc	ra,0x0
    80000474:	d5a080e7          	jalr	-678(ra) # 800001ca <uartputc_sync>
        uartputc_sync('\b');
    80000478:	4521                	li	a0,8
    8000047a:	00000097          	auipc	ra,0x0
    8000047e:	d50080e7          	jalr	-688(ra) # 800001ca <uartputc_sync>
    80000482:	bfe1                	j	8000045a <console_putc+0x18>

0000000080000484 <console_intr>:

void console_intr(char c) {
    80000484:	1101                	addi	sp,sp,-32
    80000486:	ec06                	sd	ra,24(sp)
    80000488:	e822                	sd	s0,16(sp)
    8000048a:	e426                	sd	s1,8(sp)
    8000048c:	1000                	addi	s0,sp,32
    switch (c) {
    8000048e:	47c1                	li	a5,16
    80000490:	04f50263          	beq	a0,a5,800004d4 <console_intr+0x50>
    80000494:	84aa                	mv	s1,a0
    80000496:	07f00793          	li	a5,127
    8000049a:	04f51663          	bne	a0,a5,800004e6 <console_intr+0x62>

        case '\x7f': // 退格
            if (consloe.read_index != consloe.write_index) {
    8000049e:	00008717          	auipc	a4,0x8
    800004a2:	c8270713          	addi	a4,a4,-894 # 80008120 <consloe>
    800004a6:	0e472783          	lw	a5,228(a4)
    800004aa:	0e072703          	lw	a4,224(a4)
    800004ae:	02f70763          	beq	a4,a5,800004dc <console_intr+0x58>
                consloe.write_index--;
    800004b2:	37fd                	addiw	a5,a5,-1
    800004b4:	00008717          	auipc	a4,0x8
    800004b8:	d4f72823          	sw	a5,-688(a4) # 80008204 <consloe+0xe4>
                console_putc(BACKSPACE);
    800004bc:	10000513          	li	a0,256
    800004c0:	00000097          	auipc	ra,0x0
    800004c4:	f82080e7          	jalr	-126(ra) # 80000442 <console_putc>
                console_putc('\a');
    800004c8:	451d                	li	a0,7
    800004ca:	00000097          	auipc	ra,0x0
    800004ce:	f78080e7          	jalr	-136(ra) # 80000442 <console_putc>
    800004d2:	a029                	j	800004dc <console_intr+0x58>
            }
            break;
        case CTRL('P'):
            print_proc();
    800004d4:	00001097          	auipc	ra,0x1
    800004d8:	ae8080e7          	jalr	-1304(ra) # 80000fbc <print_proc>
            if (c == '\n') {
                wakeup(&consloe.read_index);
            }
            break;
    }
}
    800004dc:	60e2                	ld	ra,24(sp)
    800004de:	6442                	ld	s0,16(sp)
    800004e0:	64a2                	ld	s1,8(sp)
    800004e2:	6105                	addi	sp,sp,32
    800004e4:	8082                	ret
            c = (c == '\r') ? '\n' : c;
    800004e6:	47b5                	li	a5,13
    800004e8:	02f50b63          	beq	a0,a5,8000051e <console_intr+0x9a>
            console_putc(c);
    800004ec:	00000097          	auipc	ra,0x0
    800004f0:	f56080e7          	jalr	-170(ra) # 80000442 <console_putc>
            consloe.buf[consloe.write_index++ % INPUT_BUF] = c;
    800004f4:	00008797          	auipc	a5,0x8
    800004f8:	c2c78793          	addi	a5,a5,-980 # 80008120 <consloe>
    800004fc:	0e47a703          	lw	a4,228(a5)
    80000500:	0017069b          	addiw	a3,a4,1
    80000504:	0ed7a223          	sw	a3,228(a5)
    80000508:	0c800693          	li	a3,200
    8000050c:	02d7673b          	remw	a4,a4,a3
    80000510:	97ba                	add	a5,a5,a4
    80000512:	00978c23          	sb	s1,24(a5)
            if (c == '\n') {
    80000516:	47a9                	li	a5,10
    80000518:	fcf492e3          	bne	s1,a5,800004dc <console_intr+0x58>
    8000051c:	a805                	j	8000054c <console_intr+0xc8>
            console_putc(c);
    8000051e:	4529                	li	a0,10
    80000520:	00000097          	auipc	ra,0x0
    80000524:	f22080e7          	jalr	-222(ra) # 80000442 <console_putc>
            consloe.buf[consloe.write_index++ % INPUT_BUF] = c;
    80000528:	00008797          	auipc	a5,0x8
    8000052c:	bf878793          	addi	a5,a5,-1032 # 80008120 <consloe>
    80000530:	0e47a703          	lw	a4,228(a5)
    80000534:	0017069b          	addiw	a3,a4,1
    80000538:	0ed7a223          	sw	a3,228(a5)
    8000053c:	0c800693          	li	a3,200
    80000540:	02d7673b          	remw	a4,a4,a3
    80000544:	97ba                	add	a5,a5,a4
    80000546:	4729                	li	a4,10
    80000548:	00e78c23          	sb	a4,24(a5)
                wakeup(&consloe.read_index);
    8000054c:	00008517          	auipc	a0,0x8
    80000550:	cb450513          	addi	a0,a0,-844 # 80008200 <consloe+0xe0>
    80000554:	00000097          	auipc	ra,0x0
    80000558:	65a080e7          	jalr	1626(ra) # 80000bae <wakeup>
}
    8000055c:	b741                	j	800004dc <console_intr+0x58>

000000008000055e <console_init>:

void console_init() {
    8000055e:	1141                	addi	sp,sp,-16
    80000560:	e406                	sd	ra,8(sp)
    80000562:	e022                	sd	s0,0(sp)
    80000564:	0800                	addi	s0,sp,16
    spinlock_init(&consloe.lock, "console");
    80000566:	00006597          	auipc	a1,0x6
    8000056a:	ab258593          	addi	a1,a1,-1358 # 80006018 <etext+0x18>
    8000056e:	00008517          	auipc	a0,0x8
    80000572:	bb250513          	addi	a0,a0,-1102 # 80008120 <consloe>
    80000576:	00003097          	auipc	ra,0x3
    8000057a:	578080e7          	jalr	1400(ra) # 80003aee <spinlock_init>
    uart_init();
    8000057e:	00000097          	auipc	ra,0x0
    80000582:	c16080e7          	jalr	-1002(ra) # 80000194 <uart_init>

    dev_rw[CONSOLE].read = console_read;
    80000586:	00093797          	auipc	a5,0x93
    8000058a:	a7a78793          	addi	a5,a5,-1414 # 80093000 <dev_rw>
    8000058e:	00000717          	auipc	a4,0x0
    80000592:	d1a70713          	addi	a4,a4,-742 # 800002a8 <console_read>
    80000596:	eb98                	sd	a4,16(a5)
    dev_rw[CONSOLE].write = console_write;
    80000598:	00000717          	auipc	a4,0x0
    8000059c:	cb470713          	addi	a4,a4,-844 # 8000024c <console_write>
    800005a0:	ef98                	sd	a4,24(a5)
}
    800005a2:	60a2                	ld	ra,8(sp)
    800005a4:	6402                	ld	s0,0(sp)
    800005a6:	0141                	addi	sp,sp,16
    800005a8:	8082                	ret

00000000800005aa <plicinit>:
//


void
plicinit(void)
{
    800005aa:	1141                	addi	sp,sp,-16
    800005ac:	e422                	sd	s0,8(sp)
    800005ae:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  // 设置IRQ的属性为非零
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800005b0:	0c0007b7          	lui	a5,0xc000
    800005b4:	4705                	li	a4,1
    800005b6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800005b8:	c3d8                	sw	a4,4(a5)
}
    800005ba:	6422                	ld	s0,8(sp)
    800005bc:	0141                	addi	sp,sp,16
    800005be:	8082                	ret

00000000800005c0 <plicinithart>:

void
plicinithart(void)
{
    800005c0:	1141                	addi	sp,sp,-16
    800005c2:	e406                	sd	ra,8(sp)
    800005c4:	e022                	sd	s0,0(sp)
    800005c6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800005c8:	00000097          	auipc	ra,0x0
    800005cc:	3bc080e7          	jalr	956(ra) # 80000984 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800005d0:	0085171b          	slliw	a4,a0,0x8
    800005d4:	0c0027b7          	lui	a5,0xc002
    800005d8:	97ba                	add	a5,a5,a4
    800005da:	40200713          	li	a4,1026
    800005de:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800005e2:	00d5151b          	slliw	a0,a0,0xd
    800005e6:	0c2017b7          	lui	a5,0xc201
    800005ea:	953e                	add	a0,a0,a5
    800005ec:	00052023          	sw	zero,0(a0)
}
    800005f0:	60a2                	ld	ra,8(sp)
    800005f2:	6402                	ld	s0,0(sp)
    800005f4:	0141                	addi	sp,sp,16
    800005f6:	8082                	ret

00000000800005f8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800005f8:	1141                	addi	sp,sp,-16
    800005fa:	e406                	sd	ra,8(sp)
    800005fc:	e022                	sd	s0,0(sp)
    800005fe:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80000600:	00000097          	auipc	ra,0x0
    80000604:	384080e7          	jalr	900(ra) # 80000984 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80000608:	00d5179b          	slliw	a5,a0,0xd
    8000060c:	0c201537          	lui	a0,0xc201
    80000610:	953e                	add	a0,a0,a5
  return irq;
}
    80000612:	4148                	lw	a0,4(a0)
    80000614:	60a2                	ld	ra,8(sp)
    80000616:	6402                	ld	s0,0(sp)
    80000618:	0141                	addi	sp,sp,16
    8000061a:	8082                	ret

000000008000061c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000061c:	1101                	addi	sp,sp,-32
    8000061e:	ec06                	sd	ra,24(sp)
    80000620:	e822                	sd	s0,16(sp)
    80000622:	e426                	sd	s1,8(sp)
    80000624:	1000                	addi	s0,sp,32
    80000626:	84aa                	mv	s1,a0
  int hart = cpuid();
    80000628:	00000097          	auipc	ra,0x0
    8000062c:	35c080e7          	jalr	860(ra) # 80000984 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80000630:	00d5151b          	slliw	a0,a0,0xd
    80000634:	0c2017b7          	lui	a5,0xc201
    80000638:	97aa                	add	a5,a5,a0
    8000063a:	c3c4                	sw	s1,4(a5)
}
    8000063c:	60e2                	ld	ra,24(sp)
    8000063e:	6442                	ld	s0,16(sp)
    80000640:	64a2                	ld	s1,8(sp)
    80000642:	6105                	addi	sp,sp,32
    80000644:	8082                	ret
	...

0000000080000650 <kernelvec>:
    80000650:	7111                	addi	sp,sp,-256
    80000652:	e006                	sd	ra,0(sp)
    80000654:	e40a                	sd	sp,8(sp)
    80000656:	e80e                	sd	gp,16(sp)
    80000658:	ec12                	sd	tp,24(sp)
    8000065a:	f016                	sd	t0,32(sp)
    8000065c:	f41a                	sd	t1,40(sp)
    8000065e:	f81e                	sd	t2,48(sp)
    80000660:	fc22                	sd	s0,56(sp)
    80000662:	e0a6                	sd	s1,64(sp)
    80000664:	e4aa                	sd	a0,72(sp)
    80000666:	e8ae                	sd	a1,80(sp)
    80000668:	ecb2                	sd	a2,88(sp)
    8000066a:	f0b6                	sd	a3,96(sp)
    8000066c:	f4ba                	sd	a4,104(sp)
    8000066e:	f8be                	sd	a5,112(sp)
    80000670:	fcc2                	sd	a6,120(sp)
    80000672:	e146                	sd	a7,128(sp)
    80000674:	e54a                	sd	s2,136(sp)
    80000676:	e94e                	sd	s3,144(sp)
    80000678:	ed52                	sd	s4,152(sp)
    8000067a:	f156                	sd	s5,160(sp)
    8000067c:	f55a                	sd	s6,168(sp)
    8000067e:	f95e                	sd	s7,176(sp)
    80000680:	fd62                	sd	s8,184(sp)
    80000682:	e1e6                	sd	s9,192(sp)
    80000684:	e5ea                	sd	s10,200(sp)
    80000686:	e9ee                	sd	s11,208(sp)
    80000688:	edf2                	sd	t3,216(sp)
    8000068a:	f1f6                	sd	t4,224(sp)
    8000068c:	f5fa                	sd	t5,232(sp)
    8000068e:	f9fe                	sd	t6,240(sp)
    80000690:	1e3030ef          	jal	ra,80004072 <kerneltrap>
    80000694:	6082                	ld	ra,0(sp)
    80000696:	6122                	ld	sp,8(sp)
    80000698:	61c2                	ld	gp,16(sp)
    8000069a:	6262                	ld	tp,24(sp)
    8000069c:	7282                	ld	t0,32(sp)
    8000069e:	7322                	ld	t1,40(sp)
    800006a0:	73c2                	ld	t2,48(sp)
    800006a2:	7462                	ld	s0,56(sp)
    800006a4:	6486                	ld	s1,64(sp)
    800006a6:	6526                	ld	a0,72(sp)
    800006a8:	65c6                	ld	a1,80(sp)
    800006aa:	6666                	ld	a2,88(sp)
    800006ac:	7686                	ld	a3,96(sp)
    800006ae:	7726                	ld	a4,104(sp)
    800006b0:	77c6                	ld	a5,112(sp)
    800006b2:	7866                	ld	a6,120(sp)
    800006b4:	688a                	ld	a7,128(sp)
    800006b6:	692a                	ld	s2,136(sp)
    800006b8:	69ca                	ld	s3,144(sp)
    800006ba:	6a6a                	ld	s4,152(sp)
    800006bc:	7a8a                	ld	s5,160(sp)
    800006be:	7b2a                	ld	s6,168(sp)
    800006c0:	7bca                	ld	s7,176(sp)
    800006c2:	7c6a                	ld	s8,184(sp)
    800006c4:	6c8e                	ld	s9,192(sp)
    800006c6:	6d2e                	ld	s10,200(sp)
    800006c8:	6dce                	ld	s11,208(sp)
    800006ca:	6e6e                	ld	t3,216(sp)
    800006cc:	7e8e                	ld	t4,224(sp)
    800006ce:	7f2e                	ld	t5,232(sp)
    800006d0:	7fce                	ld	t6,240(sp)
    800006d2:	6111                	addi	sp,sp,256
    800006d4:	10200073          	sret
    800006d8:	00000013          	nop
    800006dc:	00000013          	nop

00000000800006e0 <timervec>:
    800006e0:	34051573          	csrrw	a0,mscratch,a0
    800006e4:	e10c                	sd	a1,0(a0)
    800006e6:	e510                	sd	a2,8(a0)
    800006e8:	e914                	sd	a3,16(a0)
    800006ea:	710c                	ld	a1,32(a0)
    800006ec:	7510                	ld	a2,40(a0)
    800006ee:	6194                	ld	a3,0(a1)
    800006f0:	96b2                	add	a3,a3,a2
    800006f2:	e194                	sd	a3,0(a1)
    800006f4:	4589                	li	a1,2
    800006f6:	14459073          	csrw	sip,a1
    800006fa:	6914                	ld	a3,16(a0)
    800006fc:	6510                	ld	a2,8(a0)
    800006fe:	610c                	ld	a1,0(a0)
    80000700:	34051573          	csrrw	a0,mscratch,a0
    80000704:	30200073          	mret

0000000080000708 <forkret>:
    initproc = p;
    printf("over");
}

// fork的子进程的会从此处开始执行
void forkret(void) {
    80000708:	1141                	addi	sp,sp,-16
    8000070a:	e406                	sd	ra,8(sp)
    8000070c:	e022                	sd	s0,0(sp)
    8000070e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000710:	8792                	mv	a5,tp
    return c;
}

// 获取当前进程
struct proc *myproc() {
    return mycpu()->proc;
    80000712:	2781                	sext.w	a5,a5
    80000714:	079e                	slli	a5,a5,0x7
    80000716:	00008717          	auipc	a4,0x8
    8000071a:	af270713          	addi	a4,a4,-1294 # 80008208 <cpus>
    8000071e:	97ba                	add	a5,a5,a4
    spin_unlock(&myproc()->proc_lock);
    80000720:	6388                	ld	a0,0(a5)
    80000722:	00003097          	auipc	ra,0x3
    80000726:	530080e7          	jalr	1328(ra) # 80003c52 <spin_unlock>
    if (first) {
    8000072a:	00006797          	auipc	a5,0x6
    8000072e:	f667a783          	lw	a5,-154(a5) # 80006690 <first.1514>
    80000732:	eb89                	bnez	a5,80000744 <forkret+0x3c>
    usertrapret();
    80000734:	00003097          	auipc	ra,0x3
    80000738:	6bc080e7          	jalr	1724(ra) # 80003df0 <usertrapret>
}
    8000073c:	60a2                	ld	ra,8(sp)
    8000073e:	6402                	ld	s0,0(sp)
    80000740:	0141                	addi	sp,sp,16
    80000742:	8082                	ret
        first = 0;
    80000744:	00006797          	auipc	a5,0x6
    80000748:	f407a623          	sw	zero,-180(a5) # 80006690 <first.1514>
        init_fs();
    8000074c:	00002097          	auipc	ra,0x2
    80000750:	460080e7          	jalr	1120(ra) # 80002bac <init_fs>
    80000754:	b7c5                	j	80000734 <forkret+0x2c>

0000000080000756 <init_process_table>:
void init_process_table() {
    80000756:	7139                	addi	sp,sp,-64
    80000758:	fc06                	sd	ra,56(sp)
    8000075a:	f822                	sd	s0,48(sp)
    8000075c:	f426                	sd	s1,40(sp)
    8000075e:	f04a                	sd	s2,32(sp)
    80000760:	ec4e                	sd	s3,24(sp)
    80000762:	e852                	sd	s4,16(sp)
    80000764:	e456                	sd	s5,8(sp)
    80000766:	e05a                	sd	s6,0(sp)
    80000768:	0080                	addi	s0,sp,64
    for (int i = 0; i < NPROC; i++) {
    8000076a:	0008a497          	auipc	s1,0x8a
    8000076e:	b1e48493          	addi	s1,s1,-1250 # 8008a288 <proc_table>
    80000772:	00008997          	auipc	s3,0x8
    80000776:	b1698993          	addi	s3,s3,-1258 # 80008288 <stack>
    8000077a:	4901                	li	s2,0
        spinlock_init(&p->proc_lock, "proc");
    8000077c:	00006b17          	auipc	s6,0x6
    80000780:	8a4b0b13          	addi	s6,s6,-1884 # 80006020 <etext+0x20>
    80000784:	6a85                	lui	s5,0x1
    for (int i = 0; i < NPROC; i++) {
    80000786:	04000a13          	li	s4,64
        spinlock_init(&p->proc_lock, "proc");
    8000078a:	85da                	mv	a1,s6
    8000078c:	8526                	mv	a0,s1
    8000078e:	00003097          	auipc	ra,0x3
    80000792:	360080e7          	jalr	864(ra) # 80003aee <spinlock_init>
        p->pid = i;
    80000796:	0324ac23          	sw	s2,56(s1)
        p->kstack = (uint64) (stack + PGSIZE * i);
    8000079a:	0f34b023          	sd	s3,224(s1)
        p->trapframe = 0;
    8000079e:	0404b023          	sd	zero,64(s1)
        p->state = UNUSED;
    800007a2:	0004ac23          	sw	zero,24(s1)
    for (int i = 0; i < NPROC; i++) {
    800007a6:	2905                	addiw	s2,s2,1
    800007a8:	17048493          	addi	s1,s1,368
    800007ac:	99d6                	add	s3,s3,s5
    800007ae:	fd491ee3          	bne	s2,s4,8000078a <init_process_table+0x34>
}
    800007b2:	70e2                	ld	ra,56(sp)
    800007b4:	7442                	ld	s0,48(sp)
    800007b6:	74a2                	ld	s1,40(sp)
    800007b8:	7902                	ld	s2,32(sp)
    800007ba:	69e2                	ld	s3,24(sp)
    800007bc:	6a42                	ld	s4,16(sp)
    800007be:	6aa2                	ld	s5,8(sp)
    800007c0:	6b02                	ld	s6,0(sp)
    800007c2:	6121                	addi	sp,sp,64
    800007c4:	8082                	ret

00000000800007c6 <proc_pagetable>:
pagetable_t proc_pagetable(struct proc *p) {
    800007c6:	1101                	addi	sp,sp,-32
    800007c8:	ec06                	sd	ra,24(sp)
    800007ca:	e822                	sd	s0,16(sp)
    800007cc:	e426                	sd	s1,8(sp)
    800007ce:	e04a                	sd	s2,0(sp)
    800007d0:	1000                	addi	s0,sp,32
    800007d2:	892a                	mv	s2,a0
    pagetable = user_vm_create();
    800007d4:	00001097          	auipc	ra,0x1
    800007d8:	35e080e7          	jalr	862(ra) # 80001b32 <user_vm_create>
    800007dc:	84aa                	mv	s1,a0
    if (pagetable == 0)
    800007de:	c131                	beqz	a0,80000822 <proc_pagetable+0x5c>
    if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    800007e0:	4729                	li	a4,10
    800007e2:	00005697          	auipc	a3,0x5
    800007e6:	81e68693          	addi	a3,a3,-2018 # 80005000 <_trampoline>
    800007ea:	6605                	lui	a2,0x1
    800007ec:	040005b7          	lui	a1,0x4000
    800007f0:	15fd                	addi	a1,a1,-1
    800007f2:	05b2                	slli	a1,a1,0xc
    800007f4:	00001097          	auipc	ra,0x1
    800007f8:	0ca080e7          	jalr	202(ra) # 800018be <mappages>
    800007fc:	02054a63          	bltz	a0,80000830 <proc_pagetable+0x6a>
    if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80000800:	4719                	li	a4,6
    80000802:	04093683          	ld	a3,64(s2)
    80000806:	6605                	lui	a2,0x1
    80000808:	020005b7          	lui	a1,0x2000
    8000080c:	15fd                	addi	a1,a1,-1
    8000080e:	05b6                	slli	a1,a1,0xd
    80000810:	8526                	mv	a0,s1
    80000812:	00001097          	auipc	ra,0x1
    80000816:	0ac080e7          	jalr	172(ra) # 800018be <mappages>
        return 0;
    8000081a:	fff54513          	not	a0,a0
    8000081e:	957d                	srai	a0,a0,0x3f
    80000820:	8ce9                	and	s1,s1,a0
}
    80000822:	8526                	mv	a0,s1
    80000824:	60e2                	ld	ra,24(sp)
    80000826:	6442                	ld	s0,16(sp)
    80000828:	64a2                	ld	s1,8(sp)
    8000082a:	6902                	ld	s2,0(sp)
    8000082c:	6105                	addi	sp,sp,32
    8000082e:	8082                	ret
        return 0;
    80000830:	4481                	li	s1,0
    80000832:	bfc5                	j	80000822 <proc_pagetable+0x5c>

0000000080000834 <alloc_proc>:
struct proc *alloc_proc() {
    80000834:	1101                	addi	sp,sp,-32
    80000836:	ec06                	sd	ra,24(sp)
    80000838:	e822                	sd	s0,16(sp)
    8000083a:	e426                	sd	s1,8(sp)
    8000083c:	e04a                	sd	s2,0(sp)
    8000083e:	1000                	addi	s0,sp,32
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80000840:	0008a497          	auipc	s1,0x8a
    80000844:	a4848493          	addi	s1,s1,-1464 # 8008a288 <proc_table>
    80000848:	0008f917          	auipc	s2,0x8f
    8000084c:	64090913          	addi	s2,s2,1600 # 8008fe88 <kmem>
        spin_lock(&p->proc_lock);
    80000850:	8526                	mv	a0,s1
    80000852:	00003097          	auipc	ra,0x3
    80000856:	32c080e7          	jalr	812(ra) # 80003b7e <spin_lock>
        if (p->state == UNUSED) {
    8000085a:	4c9c                	lw	a5,24(s1)
    8000085c:	cf81                	beqz	a5,80000874 <alloc_proc+0x40>
            spin_unlock(&p->proc_lock);
    8000085e:	8526                	mv	a0,s1
    80000860:	00003097          	auipc	ra,0x3
    80000864:	3f2080e7          	jalr	1010(ra) # 80003c52 <spin_unlock>
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80000868:	17048493          	addi	s1,s1,368
    8000086c:	ff2492e3          	bne	s1,s2,80000850 <alloc_proc+0x1c>
    return 0;
    80000870:	4481                	li	s1,0
    80000872:	a8a9                	j	800008cc <alloc_proc+0x98>
    if ((p->trapframe = (struct trapframe *) kalloc()) == 0) {
    80000874:	00001097          	auipc	ra,0x1
    80000878:	f1c080e7          	jalr	-228(ra) # 80001790 <kalloc>
    8000087c:	892a                	mv	s2,a0
    8000087e:	e0a8                	sd	a0,64(s1)
    80000880:	cd29                	beqz	a0,800008da <alloc_proc+0xa6>
    p->pagetable = proc_pagetable(p);
    80000882:	8526                	mv	a0,s1
    80000884:	00000097          	auipc	ra,0x0
    80000888:	f42080e7          	jalr	-190(ra) # 800007c6 <proc_pagetable>
    8000088c:	e4a8                	sd	a0,72(s1)
    memset(&p->context, 0, sizeof(p->context));
    8000088e:	07000613          	li	a2,112
    80000892:	4581                	li	a1,0
    80000894:	0e848513          	addi	a0,s1,232
    80000898:	00001097          	auipc	ra,0x1
    8000089c:	85a080e7          	jalr	-1958(ra) # 800010f2 <memset>
    memset(p->trapframe, 0, sizeof(*p->trapframe));
    800008a0:	12000613          	li	a2,288
    800008a4:	4581                	li	a1,0
    800008a6:	60a8                	ld	a0,64(s1)
    800008a8:	00001097          	auipc	ra,0x1
    800008ac:	84a080e7          	jalr	-1974(ra) # 800010f2 <memset>
    p->context.sp = p->kstack + PGSIZE;
    800008b0:	70fc                	ld	a5,224(s1)
    800008b2:	6705                	lui	a4,0x1
    800008b4:	97ba                	add	a5,a5,a4
    800008b6:	f8fc                	sd	a5,240(s1)
    p->context.ra = (uint64) forkret;
    800008b8:	00000797          	auipc	a5,0x0
    800008bc:	e5078793          	addi	a5,a5,-432 # 80000708 <forkret>
    800008c0:	f4fc                	sd	a5,232(s1)
    spin_unlock(&p->proc_lock);
    800008c2:	8526                	mv	a0,s1
    800008c4:	00003097          	auipc	ra,0x3
    800008c8:	38e080e7          	jalr	910(ra) # 80003c52 <spin_unlock>
}
    800008cc:	8526                	mv	a0,s1
    800008ce:	60e2                	ld	ra,24(sp)
    800008d0:	6442                	ld	s0,16(sp)
    800008d2:	64a2                	ld	s1,8(sp)
    800008d4:	6902                	ld	s2,0(sp)
    800008d6:	6105                	addi	sp,sp,32
    800008d8:	8082                	ret
        spin_unlock(&p->proc_lock);
    800008da:	8526                	mv	a0,s1
    800008dc:	00003097          	auipc	ra,0x3
    800008e0:	376080e7          	jalr	886(ra) # 80003c52 <spin_unlock>
        return 0;
    800008e4:	84ca                	mv	s1,s2
    800008e6:	b7dd                	j	800008cc <alloc_proc+0x98>

00000000800008e8 <init_first_process>:
void init_first_process() {
    800008e8:	1101                	addi	sp,sp,-32
    800008ea:	ec06                	sd	ra,24(sp)
    800008ec:	e822                	sd	s0,16(sp)
    800008ee:	e426                	sd	s1,8(sp)
    800008f0:	1000                	addi	s0,sp,32
    struct proc *p = alloc_proc();
    800008f2:	00000097          	auipc	ra,0x0
    800008f6:	f42080e7          	jalr	-190(ra) # 80000834 <alloc_proc>
    800008fa:	84aa                	mv	s1,a0
    user_vm_init(p->pagetable, initcode, sizeof(initcode));
    800008fc:	03400613          	li	a2,52
    80000900:	00006597          	auipc	a1,0x6
    80000904:	da058593          	addi	a1,a1,-608 # 800066a0 <initcode>
    80000908:	6528                	ld	a0,72(a0)
    8000090a:	00001097          	auipc	ra,0x1
    8000090e:	256080e7          	jalr	598(ra) # 80001b60 <user_vm_init>
    p->sz = PGSIZE;
    80000912:	6785                	lui	a5,0x1
    80000914:	16f4a423          	sw	a5,360(s1)
    p->trapframe->epc = 0;
    80000918:	60bc                	ld	a5,64(s1)
    8000091a:	0007bc23          	sd	zero,24(a5) # 1018 <_entry-0x7fffefe8>
    p->trapframe->sp = PGSIZE;
    8000091e:	60bc                	ld	a5,64(s1)
    80000920:	6705                	lui	a4,0x1
    80000922:	fb98                	sd	a4,48(a5)
    memmove(p->name, "initcode", sizeof(p->name));
    80000924:	4641                	li	a2,16
    80000926:	00005597          	auipc	a1,0x5
    8000092a:	70258593          	addi	a1,a1,1794 # 80006028 <etext+0x28>
    8000092e:	15848513          	addi	a0,s1,344
    80000932:	00000097          	auipc	ra,0x0
    80000936:	7e6080e7          	jalr	2022(ra) # 80001118 <memmove>
    p->current_dir = namei("/");
    8000093a:	00005517          	auipc	a0,0x5
    8000093e:	6fe50513          	addi	a0,a0,1790 # 80006038 <etext+0x38>
    80000942:	00003097          	auipc	ra,0x3
    80000946:	f94080e7          	jalr	-108(ra) # 800038d6 <namei>
    8000094a:	e8a8                	sd	a0,80(s1)
    for (int i = 0; i < NOFILE; i++)
    8000094c:	05848793          	addi	a5,s1,88
    80000950:	0d848713          	addi	a4,s1,216
        p->open_file[i] = 0;
    80000954:	0007b023          	sd	zero,0(a5)
    for (int i = 0; i < NOFILE; i++)
    80000958:	07a1                	addi	a5,a5,8
    8000095a:	fee79de3          	bne	a5,a4,80000954 <init_first_process+0x6c>
    p->state = RUNNABLE;
    8000095e:	4789                	li	a5,2
    80000960:	cc9c                	sw	a5,24(s1)
    initproc = p;
    80000962:	00006797          	auipc	a5,0x6
    80000966:	6897bf23          	sd	s1,1694(a5) # 80007000 <initproc>
    printf("over");
    8000096a:	00005517          	auipc	a0,0x5
    8000096e:	6d650513          	addi	a0,a0,1750 # 80006040 <etext+0x40>
    80000972:	00001097          	auipc	ra,0x1
    80000976:	c40080e7          	jalr	-960(ra) # 800015b2 <printf>
}
    8000097a:	60e2                	ld	ra,24(sp)
    8000097c:	6442                	ld	s0,16(sp)
    8000097e:	64a2                	ld	s1,8(sp)
    80000980:	6105                	addi	sp,sp,32
    80000982:	8082                	ret

0000000080000984 <cpuid>:
int cpuid() {
    80000984:	1141                	addi	sp,sp,-16
    80000986:	e422                	sd	s0,8(sp)
    80000988:	0800                	addi	s0,sp,16
    8000098a:	8512                	mv	a0,tp
}
    8000098c:	2501                	sext.w	a0,a0
    8000098e:	6422                	ld	s0,8(sp)
    80000990:	0141                	addi	sp,sp,16
    80000992:	8082                	ret

0000000080000994 <mycpu>:
struct cpu *mycpu(void) {
    80000994:	1141                	addi	sp,sp,-16
    80000996:	e422                	sd	s0,8(sp)
    80000998:	0800                	addi	s0,sp,16
    8000099a:	8792                	mv	a5,tp
    struct cpu *c = &cpus[id];
    8000099c:	2781                	sext.w	a5,a5
    8000099e:	079e                	slli	a5,a5,0x7
}
    800009a0:	00008517          	auipc	a0,0x8
    800009a4:	86850513          	addi	a0,a0,-1944 # 80008208 <cpus>
    800009a8:	953e                	add	a0,a0,a5
    800009aa:	6422                	ld	s0,8(sp)
    800009ac:	0141                	addi	sp,sp,16
    800009ae:	8082                	ret

00000000800009b0 <myproc>:
struct proc *myproc() {
    800009b0:	1141                	addi	sp,sp,-16
    800009b2:	e422                	sd	s0,8(sp)
    800009b4:	0800                	addi	s0,sp,16
    800009b6:	8792                	mv	a5,tp
    return mycpu()->proc;
    800009b8:	2781                	sext.w	a5,a5
    800009ba:	079e                	slli	a5,a5,0x7
    800009bc:	00008717          	auipc	a4,0x8
    800009c0:	84c70713          	addi	a4,a4,-1972 # 80008208 <cpus>
    800009c4:	97ba                	add	a5,a5,a4
}
    800009c6:	6388                	ld	a0,0(a5)
    800009c8:	6422                	ld	s0,8(sp)
    800009ca:	0141                	addi	sp,sp,16
    800009cc:	8082                	ret

00000000800009ce <before_sched>:
        spin_unlock(&p->proc_lock);
        spin_lock(lock);
    }
}

void before_sched() {
    800009ce:	7179                	addi	sp,sp,-48
    800009d0:	f406                	sd	ra,40(sp)
    800009d2:	f022                	sd	s0,32(sp)
    800009d4:	ec26                	sd	s1,24(sp)
    800009d6:	e84a                	sd	s2,16(sp)
    800009d8:	e44e                	sd	s3,8(sp)
    800009da:	1800                	addi	s0,sp,48
    800009dc:	8792                	mv	a5,tp
    return mycpu()->proc;
    800009de:	2781                	sext.w	a5,a5
    800009e0:	079e                	slli	a5,a5,0x7
    800009e2:	00008717          	auipc	a4,0x8
    800009e6:	82670713          	addi	a4,a4,-2010 # 80008208 <cpus>
    800009ea:	97ba                	add	a5,a5,a4
    800009ec:	0007b903          	ld	s2,0(a5)
    int intr_enable;
    struct proc *p = myproc();

    if (!spin_holding(&p->proc_lock))
    800009f0:	854a                	mv	a0,s2
    800009f2:	00003097          	auipc	ra,0x3
    800009f6:	112080e7          	jalr	274(ra) # 80003b04 <spin_holding>
    800009fa:	c925                	beqz	a0,80000a6a <before_sched+0x9c>
    800009fc:	8792                	mv	a5,tp
        panic("sched p->lock");
    if (mycpu()->noff != 1)
    800009fe:	2781                	sext.w	a5,a5
    80000a00:	079e                	slli	a5,a5,0x7
    80000a02:	00008717          	auipc	a4,0x8
    80000a06:	80670713          	addi	a4,a4,-2042 # 80008208 <cpus>
    80000a0a:	97ba                	add	a5,a5,a4
    80000a0c:	5fb8                	lw	a4,120(a5)
    80000a0e:	4785                	li	a5,1
    80000a10:	06f71663          	bne	a4,a5,80000a7c <before_sched+0xae>
        panic("sched locks");
    if (p->state == RUNNING)
    80000a14:	01892703          	lw	a4,24(s2)
    80000a18:	478d                	li	a5,3
    80000a1a:	06f70a63          	beq	a4,a5,80000a8e <before_sched+0xc0>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000a1e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000a22:	8b89                	andi	a5,a5,2
        panic("sched running");
    if (intr_get())
    80000a24:	efb5                	bnez	a5,80000aa0 <before_sched+0xd2>
  asm volatile("mv %0, tp" : "=r" (x) );
    80000a26:	8792                	mv	a5,tp
        panic("sched interruptible");

    intr_enable = mycpu()->intr_enable;
    80000a28:	00007497          	auipc	s1,0x7
    80000a2c:	7e048493          	addi	s1,s1,2016 # 80008208 <cpus>
    80000a30:	2781                	sext.w	a5,a5
    80000a32:	079e                	slli	a5,a5,0x7
    80000a34:	97a6                	add	a5,a5,s1
    80000a36:	07c7a983          	lw	s3,124(a5)
    80000a3a:	8592                	mv	a1,tp
    pswitch(&p->context, &mycpu()->context);
    80000a3c:	2581                	sext.w	a1,a1
    80000a3e:	059e                	slli	a1,a1,0x7
    80000a40:	05a1                	addi	a1,a1,8
    80000a42:	95a6                	add	a1,a1,s1
    80000a44:	0e890513          	addi	a0,s2,232
    80000a48:	00001097          	auipc	ra,0x1
    80000a4c:	84a080e7          	jalr	-1974(ra) # 80001292 <pswitch>
    80000a50:	8792                	mv	a5,tp
    mycpu()->intr_enable = intr_enable;
    80000a52:	2781                	sext.w	a5,a5
    80000a54:	079e                	slli	a5,a5,0x7
    80000a56:	94be                	add	s1,s1,a5
    80000a58:	0734ae23          	sw	s3,124(s1)
}
    80000a5c:	70a2                	ld	ra,40(sp)
    80000a5e:	7402                	ld	s0,32(sp)
    80000a60:	64e2                	ld	s1,24(sp)
    80000a62:	6942                	ld	s2,16(sp)
    80000a64:	69a2                	ld	s3,8(sp)
    80000a66:	6145                	addi	sp,sp,48
    80000a68:	8082                	ret
        panic("sched p->lock");
    80000a6a:	00005517          	auipc	a0,0x5
    80000a6e:	5de50513          	addi	a0,a0,1502 # 80006048 <etext+0x48>
    80000a72:	00001097          	auipc	ra,0x1
    80000a76:	c04080e7          	jalr	-1020(ra) # 80001676 <panic>
    80000a7a:	b749                	j	800009fc <before_sched+0x2e>
        panic("sched locks");
    80000a7c:	00005517          	auipc	a0,0x5
    80000a80:	5dc50513          	addi	a0,a0,1500 # 80006058 <etext+0x58>
    80000a84:	00001097          	auipc	ra,0x1
    80000a88:	bf2080e7          	jalr	-1038(ra) # 80001676 <panic>
    80000a8c:	b761                	j	80000a14 <before_sched+0x46>
        panic("sched running");
    80000a8e:	00005517          	auipc	a0,0x5
    80000a92:	5da50513          	addi	a0,a0,1498 # 80006068 <etext+0x68>
    80000a96:	00001097          	auipc	ra,0x1
    80000a9a:	be0080e7          	jalr	-1056(ra) # 80001676 <panic>
    80000a9e:	b741                	j	80000a1e <before_sched+0x50>
        panic("sched interruptible");
    80000aa0:	00005517          	auipc	a0,0x5
    80000aa4:	5d850513          	addi	a0,a0,1496 # 80006078 <etext+0x78>
    80000aa8:	00001097          	auipc	ra,0x1
    80000aac:	bce080e7          	jalr	-1074(ra) # 80001676 <panic>
    80000ab0:	bf9d                	j	80000a26 <before_sched+0x58>

0000000080000ab2 <sleep>:
void sleep(void *chan, struct spinlock *lock) {
    80000ab2:	7179                	addi	sp,sp,-48
    80000ab4:	f406                	sd	ra,40(sp)
    80000ab6:	f022                	sd	s0,32(sp)
    80000ab8:	ec26                	sd	s1,24(sp)
    80000aba:	e84a                	sd	s2,16(sp)
    80000abc:	e44e                	sd	s3,8(sp)
    80000abe:	1800                	addi	s0,sp,48
    80000ac0:	89aa                	mv	s3,a0
    80000ac2:	8792                	mv	a5,tp
    return mycpu()->proc;
    80000ac4:	2781                	sext.w	a5,a5
    80000ac6:	079e                	slli	a5,a5,0x7
    80000ac8:	00007717          	auipc	a4,0x7
    80000acc:	74070713          	addi	a4,a4,1856 # 80008208 <cpus>
    80000ad0:	97ba                	add	a5,a5,a4
    80000ad2:	6384                	ld	s1,0(a5)
    if (lock != &p->proc_lock) {  //DOC: sleeplock0
    80000ad4:	04b48863          	beq	s1,a1,80000b24 <sleep+0x72>
    80000ad8:	892e                	mv	s2,a1
        spin_lock(&p->proc_lock);  //DOC: sleeplock1
    80000ada:	8526                	mv	a0,s1
    80000adc:	00003097          	auipc	ra,0x3
    80000ae0:	0a2080e7          	jalr	162(ra) # 80003b7e <spin_lock>
        spin_unlock(lock);
    80000ae4:	854a                	mv	a0,s2
    80000ae6:	00003097          	auipc	ra,0x3
    80000aea:	16c080e7          	jalr	364(ra) # 80003c52 <spin_unlock>
    p->chan = chan;
    80000aee:	0334b423          	sd	s3,40(s1)
    p->state = SLEEPING;
    80000af2:	4785                	li	a5,1
    80000af4:	cc9c                	sw	a5,24(s1)
    before_sched();
    80000af6:	00000097          	auipc	ra,0x0
    80000afa:	ed8080e7          	jalr	-296(ra) # 800009ce <before_sched>
    p->chan = 0;
    80000afe:	0204b423          	sd	zero,40(s1)
        spin_unlock(&p->proc_lock);
    80000b02:	8526                	mv	a0,s1
    80000b04:	00003097          	auipc	ra,0x3
    80000b08:	14e080e7          	jalr	334(ra) # 80003c52 <spin_unlock>
        spin_lock(lock);
    80000b0c:	854a                	mv	a0,s2
    80000b0e:	00003097          	auipc	ra,0x3
    80000b12:	070080e7          	jalr	112(ra) # 80003b7e <spin_lock>
}
    80000b16:	70a2                	ld	ra,40(sp)
    80000b18:	7402                	ld	s0,32(sp)
    80000b1a:	64e2                	ld	s1,24(sp)
    80000b1c:	6942                	ld	s2,16(sp)
    80000b1e:	69a2                	ld	s3,8(sp)
    80000b20:	6145                	addi	sp,sp,48
    80000b22:	8082                	ret
    p->chan = chan;
    80000b24:	f488                	sd	a0,40(s1)
    p->state = SLEEPING;
    80000b26:	4785                	li	a5,1
    80000b28:	cc9c                	sw	a5,24(s1)
    before_sched();
    80000b2a:	00000097          	auipc	ra,0x0
    80000b2e:	ea4080e7          	jalr	-348(ra) # 800009ce <before_sched>
    p->chan = 0;
    80000b32:	0204b423          	sd	zero,40(s1)
    if (lock != &p->proc_lock) {
    80000b36:	b7c5                	j	80000b16 <sleep+0x64>

0000000080000b38 <sleep_time>:

// 睡眠一定时间
void sleep_time(uint64 sleep_ticks) {
    80000b38:	7179                	addi	sp,sp,-48
    80000b3a:	f406                	sd	ra,40(sp)
    80000b3c:	f022                	sd	s0,32(sp)
    80000b3e:	ec26                	sd	s1,24(sp)
    80000b40:	e84a                	sd	s2,16(sp)
    80000b42:	e44e                	sd	s3,8(sp)
    80000b44:	e052                	sd	s4,0(sp)
    80000b46:	1800                	addi	s0,sp,48
    80000b48:	892a                	mv	s2,a0
    uint64 now = ticks;
    80000b4a:	00006497          	auipc	s1,0x6
    80000b4e:	4c648493          	addi	s1,s1,1222 # 80007010 <ticks>
    80000b52:	0004b983          	ld	s3,0(s1)
    spin_lock(&ticks_lock);
    80000b56:	000b1517          	auipc	a0,0xb1
    80000b5a:	87a50513          	addi	a0,a0,-1926 # 800b13d0 <ticks_lock>
    80000b5e:	00003097          	auipc	ra,0x3
    80000b62:	020080e7          	jalr	32(ra) # 80003b7e <spin_lock>
    for (; ticks - now < sleep_ticks;) {
    80000b66:	609c                	ld	a5,0(s1)
    80000b68:	413787b3          	sub	a5,a5,s3
    80000b6c:	0327f163          	bgeu	a5,s2,80000b8e <sleep_time+0x56>
        sleep(&ticks, &ticks_lock);
    80000b70:	000b1a17          	auipc	s4,0xb1
    80000b74:	860a0a13          	addi	s4,s4,-1952 # 800b13d0 <ticks_lock>
    80000b78:	85d2                	mv	a1,s4
    80000b7a:	8526                	mv	a0,s1
    80000b7c:	00000097          	auipc	ra,0x0
    80000b80:	f36080e7          	jalr	-202(ra) # 80000ab2 <sleep>
    for (; ticks - now < sleep_ticks;) {
    80000b84:	609c                	ld	a5,0(s1)
    80000b86:	413787b3          	sub	a5,a5,s3
    80000b8a:	ff27e7e3          	bltu	a5,s2,80000b78 <sleep_time+0x40>
    }
    spin_unlock(&ticks_lock);
    80000b8e:	000b1517          	auipc	a0,0xb1
    80000b92:	84250513          	addi	a0,a0,-1982 # 800b13d0 <ticks_lock>
    80000b96:	00003097          	auipc	ra,0x3
    80000b9a:	0bc080e7          	jalr	188(ra) # 80003c52 <spin_unlock>
}
    80000b9e:	70a2                	ld	ra,40(sp)
    80000ba0:	7402                	ld	s0,32(sp)
    80000ba2:	64e2                	ld	s1,24(sp)
    80000ba4:	6942                	ld	s2,16(sp)
    80000ba6:	69a2                	ld	s3,8(sp)
    80000ba8:	6a02                	ld	s4,0(sp)
    80000baa:	6145                	addi	sp,sp,48
    80000bac:	8082                	ret

0000000080000bae <wakeup>:

// 唤醒指定chan上的进程
void wakeup(void *chan) {
    80000bae:	1141                	addi	sp,sp,-16
    80000bb0:	e422                	sd	s0,8(sp)
    80000bb2:	0800                	addi	s0,sp,16
    struct proc *p;
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80000bb4:	00089797          	auipc	a5,0x89
    80000bb8:	6d478793          	addi	a5,a5,1748 # 8008a288 <proc_table>
        if (p->state == SLEEPING && p->chan == chan) {
    80000bbc:	4605                	li	a2,1
            p->state = RUNNABLE;
    80000bbe:	4589                	li	a1,2
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80000bc0:	0008f697          	auipc	a3,0x8f
    80000bc4:	2c868693          	addi	a3,a3,712 # 8008fe88 <kmem>
    80000bc8:	a031                	j	80000bd4 <wakeup+0x26>
            p->state = RUNNABLE;
    80000bca:	cf8c                	sw	a1,24(a5)
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80000bcc:	17078793          	addi	a5,a5,368
    80000bd0:	00d78963          	beq	a5,a3,80000be2 <wakeup+0x34>
        if (p->state == SLEEPING && p->chan == chan) {
    80000bd4:	4f98                	lw	a4,24(a5)
    80000bd6:	fec71be3          	bne	a4,a2,80000bcc <wakeup+0x1e>
    80000bda:	7798                	ld	a4,40(a5)
    80000bdc:	fea718e3          	bne	a4,a0,80000bcc <wakeup+0x1e>
    80000be0:	b7ed                	j	80000bca <wakeup+0x1c>
        }
    }
}
    80000be2:	6422                	ld	s0,8(sp)
    80000be4:	0141                	addi	sp,sp,16
    80000be6:	8082                	ret

0000000080000be8 <scheduler>:
void scheduler() {
    80000be8:	711d                	addi	sp,sp,-96
    80000bea:	ec86                	sd	ra,88(sp)
    80000bec:	e8a2                	sd	s0,80(sp)
    80000bee:	e4a6                	sd	s1,72(sp)
    80000bf0:	e0ca                	sd	s2,64(sp)
    80000bf2:	fc4e                	sd	s3,56(sp)
    80000bf4:	f852                	sd	s4,48(sp)
    80000bf6:	f456                	sd	s5,40(sp)
    80000bf8:	f05a                	sd	s6,32(sp)
    80000bfa:	ec5e                	sd	s7,24(sp)
    80000bfc:	e862                	sd	s8,16(sp)
    80000bfe:	e466                	sd	s9,8(sp)
    80000c00:	e06a                	sd	s10,0(sp)
    80000c02:	1080                	addi	s0,sp,96
    80000c04:	8792                	mv	a5,tp
    int id = r_tp();
    80000c06:	2781                	sext.w	a5,a5
                pswitch(&c->context, &p->context);
    80000c08:	00779c93          	slli	s9,a5,0x7
    80000c0c:	00007717          	auipc	a4,0x7
    80000c10:	60470713          	addi	a4,a4,1540 # 80008210 <cpus+0x8>
    80000c14:	9cba                	add	s9,s9,a4
                wakeup(initproc);
    80000c16:	00006d17          	auipc	s10,0x6
    80000c1a:	3ead0d13          	addi	s10,s10,1002 # 80007000 <initproc>
            if (p->state == RUNNABLE) {
    80000c1e:	4a89                	li	s5,2
                c->proc = p;
    80000c20:	079e                	slli	a5,a5,0x7
    80000c22:	00007b97          	auipc	s7,0x7
    80000c26:	5e6b8b93          	addi	s7,s7,1510 # 80008208 <cpus>
    80000c2a:	9bbe                	add	s7,s7,a5
    80000c2c:	a08d                	j	80000c8e <scheduler+0xa6>
            spin_unlock(&p->proc_lock);
    80000c2e:	854a                	mv	a0,s2
    80000c30:	00003097          	auipc	ra,0x3
    80000c34:	022080e7          	jalr	34(ra) # 80003c52 <spin_unlock>
        for (int i = 0; i < NPROC; i++) {
    80000c38:	17048493          	addi	s1,s1,368
    80000c3c:	03348f63          	beq	s1,s3,80000c7a <scheduler+0x92>
            p = &proc_table[i];
    80000c40:	8926                	mv	s2,s1
            spin_lock(&p->proc_lock);
    80000c42:	8526                	mv	a0,s1
    80000c44:	00003097          	auipc	ra,0x3
    80000c48:	f3a080e7          	jalr	-198(ra) # 80003b7e <spin_lock>
            if (p->state != UNUSED && p->state != ZOMBIE) {
    80000c4c:	4c9c                	lw	a5,24(s1)
    80000c4e:	d3e5                	beqz	a5,80000c2e <scheduler+0x46>
    80000c50:	07678163          	beq	a5,s6,80000cb2 <scheduler+0xca>
                alive_p++;
    80000c54:	2a05                	addiw	s4,s4,1
            if (p->state == RUNNABLE) {
    80000c56:	01892783          	lw	a5,24(s2)
    80000c5a:	fd579ae3          	bne	a5,s5,80000c2e <scheduler+0x46>
                p->state = RUNNING;
    80000c5e:	01892c23          	sw	s8,24(s2)
                c->proc = p;
    80000c62:	012bb023          	sd	s2,0(s7)
                pswitch(&c->context, &p->context);
    80000c66:	0e848593          	addi	a1,s1,232
    80000c6a:	8566                	mv	a0,s9
    80000c6c:	00000097          	auipc	ra,0x0
    80000c70:	626080e7          	jalr	1574(ra) # 80001292 <pswitch>
                c->proc = 0;
    80000c74:	000bb023          	sd	zero,0(s7)
    80000c78:	bf5d                	j	80000c2e <scheduler+0x46>
        if (alive_p <= 2) {
    80000c7a:	014aca63          	blt	s5,s4,80000c8e <scheduler+0xa6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c7e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c82:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c86:	10079073          	csrw	sstatus,a5
            asm volatile("wfi");
    80000c8a:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c8e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c92:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c96:	10079073          	csrw	sstatus,a5
        for (int i = 0; i < NPROC; i++) {
    80000c9a:	00089497          	auipc	s1,0x89
    80000c9e:	5ee48493          	addi	s1,s1,1518 # 8008a288 <proc_table>
    80000ca2:	0008f997          	auipc	s3,0x8f
    80000ca6:	1e698993          	addi	s3,s3,486 # 8008fe88 <kmem>
        alive_p = 0;
    80000caa:	4a01                	li	s4,0
            if (p->state != UNUSED && p->state != ZOMBIE) {
    80000cac:	4b11                	li	s6,4
                p->state = RUNNING;
    80000cae:	4c0d                	li	s8,3
    80000cb0:	bf41                	j	80000c40 <scheduler+0x58>
                wakeup(initproc);
    80000cb2:	000d3503          	ld	a0,0(s10)
    80000cb6:	00000097          	auipc	ra,0x0
    80000cba:	ef8080e7          	jalr	-264(ra) # 80000bae <wakeup>
    80000cbe:	bf61                	j	80000c56 <scheduler+0x6e>

0000000080000cc0 <fork>:

int fork() {
    80000cc0:	7179                	addi	sp,sp,-48
    80000cc2:	f406                	sd	ra,40(sp)
    80000cc4:	f022                	sd	s0,32(sp)
    80000cc6:	ec26                	sd	s1,24(sp)
    80000cc8:	e84a                	sd	s2,16(sp)
    80000cca:	e44e                	sd	s3,8(sp)
    80000ccc:	e052                	sd	s4,0(sp)
    80000cce:	1800                	addi	s0,sp,48
  asm volatile("mv %0, tp" : "=r" (x) );
    80000cd0:	8792                	mv	a5,tp
    return mycpu()->proc;
    80000cd2:	2781                	sext.w	a5,a5
    80000cd4:	079e                	slli	a5,a5,0x7
    80000cd6:	00007717          	auipc	a4,0x7
    80000cda:	53270713          	addi	a4,a4,1330 # 80008208 <cpus>
    80000cde:	97ba                	add	a5,a5,a4
    80000ce0:	0007b903          	ld	s2,0(a5)
    struct proc *child;
    struct proc *p = myproc();
    int i;
    // 分配一个新的进程
    if ((child = alloc_proc()) == 0) {
    80000ce4:	00000097          	auipc	ra,0x0
    80000ce8:	b50080e7          	jalr	-1200(ra) # 80000834 <alloc_proc>
    80000cec:	c13d                	beqz	a0,80000d52 <fork+0x92>
    80000cee:	89aa                	mv	s3,a0
        printf("\n\n\nuser\n\n\n");
        return -1;
    }

    // 将父进程的内存复制到子进程中
    if (user_vm_copy(p->pagetable, child->pagetable, p->sz) < 0) {
    80000cf0:	16892603          	lw	a2,360(s2)
    80000cf4:	652c                	ld	a1,72(a0)
    80000cf6:	04893503          	ld	a0,72(s2)
    80000cfa:	00001097          	auipc	ra,0x1
    80000cfe:	0b0080e7          	jalr	176(ra) # 80001daa <user_vm_copy>
    80000d02:	0a054f63          	bltz	a0,80000dc0 <fork+0x100>
        return -1;
    }
    child->sz = p->sz;
    80000d06:	16892783          	lw	a5,360(s2)
    80000d0a:	16f9a423          	sw	a5,360(s3)
    child->parent = p;
    80000d0e:	0329b023          	sd	s2,32(s3)

    // 复制父进程的用户空间的寄存器
    *(child->trapframe) = *(p->trapframe);
    80000d12:	04093683          	ld	a3,64(s2)
    80000d16:	87b6                	mv	a5,a3
    80000d18:	0409b703          	ld	a4,64(s3)
    80000d1c:	12068693          	addi	a3,a3,288
    80000d20:	0007b803          	ld	a6,0(a5)
    80000d24:	6788                	ld	a0,8(a5)
    80000d26:	6b8c                	ld	a1,16(a5)
    80000d28:	6f90                	ld	a2,24(a5)
    80000d2a:	01073023          	sd	a6,0(a4)
    80000d2e:	e708                	sd	a0,8(a4)
    80000d30:	eb0c                	sd	a1,16(a4)
    80000d32:	ef10                	sd	a2,24(a4)
    80000d34:	02078793          	addi	a5,a5,32
    80000d38:	02070713          	addi	a4,a4,32
    80000d3c:	fed792e3          	bne	a5,a3,80000d20 <fork+0x60>

    // 设置子进程fork的返回值为0
    child->trapframe->a0 = 0;
    80000d40:	0409b783          	ld	a5,64(s3)
    80000d44:	0607b823          	sd	zero,112(a5)
    80000d48:	05800493          	li	s1,88

    //
    for (i = 0; i < NOFILE; i++) {
    80000d4c:	0d800a13          	li	s4,216
    80000d50:	a02d                	j	80000d7a <fork+0xba>
        printf("\n\n\nuser\n\n\n");
    80000d52:	00005517          	auipc	a0,0x5
    80000d56:	33e50513          	addi	a0,a0,830 # 80006090 <etext+0x90>
    80000d5a:	00001097          	auipc	ra,0x1
    80000d5e:	858080e7          	jalr	-1960(ra) # 800015b2 <printf>
        return -1;
    80000d62:	557d                	li	a0,-1
    80000d64:	a0b1                	j	80000db0 <fork+0xf0>
        if (p->open_file[i] != 0) {
            child->open_file[i] = file_dup(p->open_file[i]);
    80000d66:	00002097          	auipc	ra,0x2
    80000d6a:	b5e080e7          	jalr	-1186(ra) # 800028c4 <file_dup>
    80000d6e:	009987b3          	add	a5,s3,s1
    80000d72:	e388                	sd	a0,0(a5)
    for (i = 0; i < NOFILE; i++) {
    80000d74:	04a1                	addi	s1,s1,8
    80000d76:	01448763          	beq	s1,s4,80000d84 <fork+0xc4>
        if (p->open_file[i] != 0) {
    80000d7a:	009907b3          	add	a5,s2,s1
    80000d7e:	6388                	ld	a0,0(a5)
    80000d80:	f17d                	bnez	a0,80000d66 <fork+0xa6>
    80000d82:	bfcd                	j	80000d74 <fork+0xb4>
        }
    }
    child->current_dir = dup_inode(p->current_dir);
    80000d84:	05093503          	ld	a0,80(s2)
    80000d88:	00002097          	auipc	ra,0x2
    80000d8c:	494080e7          	jalr	1172(ra) # 8000321c <dup_inode>
    80000d90:	04a9b823          	sd	a0,80(s3)

    safestrcpy(child->name, p->name, sizeof(p->name));
    80000d94:	4641                	li	a2,16
    80000d96:	15890593          	addi	a1,s2,344
    80000d9a:	15898513          	addi	a0,s3,344
    80000d9e:	00000097          	auipc	ra,0x0
    80000da2:	41c080e7          	jalr	1052(ra) # 800011ba <safestrcpy>

    child->state = RUNNABLE;
    80000da6:	4789                	li	a5,2
    80000da8:	00f9ac23          	sw	a5,24(s3)
    return child->pid;
    80000dac:	0389a503          	lw	a0,56(s3)
}
    80000db0:	70a2                	ld	ra,40(sp)
    80000db2:	7402                	ld	s0,32(sp)
    80000db4:	64e2                	ld	s1,24(sp)
    80000db6:	6942                	ld	s2,16(sp)
    80000db8:	69a2                	ld	s3,8(sp)
    80000dba:	6a02                	ld	s4,0(sp)
    80000dbc:	6145                	addi	sp,sp,48
    80000dbe:	8082                	ret
        return -1;
    80000dc0:	557d                	li	a0,-1
    80000dc2:	b7fd                	j	80000db0 <fork+0xf0>

0000000080000dc4 <wait>:
//
// 等待子进程退出, 返回其子进程id
// 没有子进程返回-1， 将退出状态复
// 制到status中。
//
int wait(uint64 vaddr) {
    80000dc4:	715d                	addi	sp,sp,-80
    80000dc6:	e486                	sd	ra,72(sp)
    80000dc8:	e0a2                	sd	s0,64(sp)
    80000dca:	fc26                	sd	s1,56(sp)
    80000dcc:	f84a                	sd	s2,48(sp)
    80000dce:	f44e                	sd	s3,40(sp)
    80000dd0:	f052                	sd	s4,32(sp)
    80000dd2:	ec56                	sd	s5,24(sp)
    80000dd4:	e85a                	sd	s6,16(sp)
    80000dd6:	e45e                	sd	s7,8(sp)
    80000dd8:	e062                	sd	s8,0(sp)
    80000dda:	0880                	addi	s0,sp,80
    80000ddc:	8b2a                	mv	s6,a0
    80000dde:	8792                	mv	a5,tp
    return mycpu()->proc;
    80000de0:	2781                	sext.w	a5,a5
    80000de2:	079e                	slli	a5,a5,0x7
    80000de4:	00007717          	auipc	a4,0x7
    80000de8:	42470713          	addi	a4,a4,1060 # 80008208 <cpus>
    80000dec:	97ba                	add	a5,a5,a4
    80000dee:	0007b903          	ld	s2,0(a5)
    struct proc *cp; // 子进程
    struct proc *p;
    int havechild, pid;
    p = myproc();
    spin_lock(&p->proc_lock);
    80000df2:	854a                	mv	a0,s2
    80000df4:	00003097          	auipc	ra,0x3
    80000df8:	d8a080e7          	jalr	-630(ra) # 80003b7e <spin_lock>
    for (;;) {
        havechild = 0;
    80000dfc:	4b81                	li	s7,0
        for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
            if (cp->parent == p) {
                spin_lock(&cp->proc_lock);
                havechild = 1;
                if (cp->state == ZOMBIE) {
    80000dfe:	4a11                	li	s4,4
        for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    80000e00:	0008f997          	auipc	s3,0x8f
    80000e04:	08898993          	addi	s3,s3,136 # 8008fe88 <kmem>
                havechild = 1;
    80000e08:	4a85                	li	s5,1
    return mycpu()->proc;
    80000e0a:	00007c17          	auipc	s8,0x7
    80000e0e:	3fec0c13          	addi	s8,s8,1022 # 80008208 <cpus>
        havechild = 0;
    80000e12:	875e                	mv	a4,s7
        for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    80000e14:	00089497          	auipc	s1,0x89
    80000e18:	47448493          	addi	s1,s1,1140 # 8008a288 <proc_table>
    80000e1c:	a059                	j	80000ea2 <wait+0xde>
                    pid = cp->pid;
    80000e1e:	0384a983          	lw	s3,56(s1)
                    if (vaddr != 0 && copyout(cp->pagetable, vaddr, (char *) &cp->xstate,
    80000e22:	000b0d63          	beqz	s6,80000e3c <wait+0x78>
    80000e26:	4691                	li	a3,4
    80000e28:	03448613          	addi	a2,s1,52
    80000e2c:	85da                	mv	a1,s6
    80000e2e:	64a8                	ld	a0,72(s1)
    80000e30:	00001097          	auipc	ra,0x1
    80000e34:	eec080e7          	jalr	-276(ra) # 80001d1c <copyout>
    80000e38:	04054563          	bltz	a0,80000e82 <wait+0xbe>
    if(p->trapframe)
    80000e3c:	60a8                	ld	a0,64(s1)
    80000e3e:	c509                	beqz	a0,80000e48 <wait+0x84>
        kfree(p->trapframe);
    80000e40:	00001097          	auipc	ra,0x1
    80000e44:	852080e7          	jalr	-1966(ra) # 80001692 <kfree>
    p->trapframe = 0;
    80000e48:	0404b023          	sd	zero,64(s1)
    p->pagetable = 0;
    80000e4c:	0404b423          	sd	zero,72(s1)
    p->sz = 0;
    80000e50:	1604a423          	sw	zero,360(s1)
    p->name[0] = 0;
    80000e54:	14048c23          	sb	zero,344(s1)
    p->chan = 0;
    80000e58:	0204b423          	sd	zero,40(s1)
    p->killed = 0;
    80000e5c:	0204a823          	sw	zero,48(s1)
    p->xstate = 0;
    80000e60:	0204aa23          	sw	zero,52(s1)
    p->state = UNUSED;
    80000e64:	0004ac23          	sw	zero,24(s1)
    p->parent = 0;
    80000e68:	0204b023          	sd	zero,32(s1)
                        spin_unlock(&cp->proc_lock);
                        spin_unlock(&p->proc_lock);
                        return -1;
                    }
                    proc_free(cp);
                    spin_unlock(&cp->proc_lock);
    80000e6c:	8526                	mv	a0,s1
    80000e6e:	00003097          	auipc	ra,0x3
    80000e72:	de4080e7          	jalr	-540(ra) # 80003c52 <spin_unlock>
                    spin_unlock(&p->proc_lock);
    80000e76:	854a                	mv	a0,s2
    80000e78:	00003097          	auipc	ra,0x3
    80000e7c:	dda080e7          	jalr	-550(ra) # 80003c52 <spin_unlock>
                    return pid;
    80000e80:	a0a9                	j	80000eca <wait+0x106>
                        spin_unlock(&cp->proc_lock);
    80000e82:	8526                	mv	a0,s1
    80000e84:	00003097          	auipc	ra,0x3
    80000e88:	dce080e7          	jalr	-562(ra) # 80003c52 <spin_unlock>
                        spin_unlock(&p->proc_lock);
    80000e8c:	854a                	mv	a0,s2
    80000e8e:	00003097          	auipc	ra,0x3
    80000e92:	dc4080e7          	jalr	-572(ra) # 80003c52 <spin_unlock>
                        return -1;
    80000e96:	59fd                	li	s3,-1
    80000e98:	a80d                	j	80000eca <wait+0x106>
        for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    80000e9a:	17048493          	addi	s1,s1,368
    80000e9e:	03348463          	beq	s1,s3,80000ec6 <wait+0x102>
            if (cp->parent == p) {
    80000ea2:	709c                	ld	a5,32(s1)
    80000ea4:	ff279be3          	bne	a5,s2,80000e9a <wait+0xd6>
                spin_lock(&cp->proc_lock);
    80000ea8:	8526                	mv	a0,s1
    80000eaa:	00003097          	auipc	ra,0x3
    80000eae:	cd4080e7          	jalr	-812(ra) # 80003b7e <spin_lock>
                if (cp->state == ZOMBIE) {
    80000eb2:	4c9c                	lw	a5,24(s1)
    80000eb4:	f74785e3          	beq	a5,s4,80000e1e <wait+0x5a>
                }
                spin_unlock(&cp->proc_lock);
    80000eb8:	8526                	mv	a0,s1
    80000eba:	00003097          	auipc	ra,0x3
    80000ebe:	d98080e7          	jalr	-616(ra) # 80003c52 <spin_unlock>
                havechild = 1;
    80000ec2:	8756                	mv	a4,s5
    80000ec4:	bfd9                	j	80000e9a <wait+0xd6>
            }
        }
        if (!havechild) {
    80000ec6:	ef19                	bnez	a4,80000ee4 <wait+0x120>
            return -1;
    80000ec8:	59fd                	li	s3,-1
        }
        sleep(p, &myproc()->proc_lock); // 等待子进程唤醒
    }
}
    80000eca:	854e                	mv	a0,s3
    80000ecc:	60a6                	ld	ra,72(sp)
    80000ece:	6406                	ld	s0,64(sp)
    80000ed0:	74e2                	ld	s1,56(sp)
    80000ed2:	7942                	ld	s2,48(sp)
    80000ed4:	79a2                	ld	s3,40(sp)
    80000ed6:	7a02                	ld	s4,32(sp)
    80000ed8:	6ae2                	ld	s5,24(sp)
    80000eda:	6b42                	ld	s6,16(sp)
    80000edc:	6ba2                	ld	s7,8(sp)
    80000ede:	6c02                	ld	s8,0(sp)
    80000ee0:	6161                	addi	sp,sp,80
    80000ee2:	8082                	ret
    80000ee4:	8792                	mv	a5,tp
    return mycpu()->proc;
    80000ee6:	2781                	sext.w	a5,a5
    80000ee8:	079e                	slli	a5,a5,0x7
    80000eea:	97e2                	add	a5,a5,s8
        sleep(p, &myproc()->proc_lock); // 等待子进程唤醒
    80000eec:	638c                	ld	a1,0(a5)
    80000eee:	854a                	mv	a0,s2
    80000ef0:	00000097          	auipc	ra,0x0
    80000ef4:	bc2080e7          	jalr	-1086(ra) # 80000ab2 <sleep>
        havechild = 0;
    80000ef8:	bf29                	j	80000e12 <wait+0x4e>

0000000080000efa <exit>:
// 让父进程来设置其state为UNUSED
// 若父进程已经exit, 则会由init进
// 程来完成父进程在exit时，会将其
// 子进程的parent设置为init进程
//
void exit(int status) {
    80000efa:	7179                	addi	sp,sp,-48
    80000efc:	f406                	sd	ra,40(sp)
    80000efe:	f022                	sd	s0,32(sp)
    80000f00:	ec26                	sd	s1,24(sp)
    80000f02:	e84a                	sd	s2,16(sp)
    80000f04:	e44e                	sd	s3,8(sp)
    80000f06:	1800                	addi	s0,sp,48
    80000f08:	8792                	mv	a5,tp
    return mycpu()->proc;
    80000f0a:	2781                	sext.w	a5,a5
    80000f0c:	079e                	slli	a5,a5,0x7
    80000f0e:	00007717          	auipc	a4,0x7
    80000f12:	2fa70713          	addi	a4,a4,762 # 80008208 <cpus>
    80000f16:	97ba                	add	a5,a5,a4
    80000f18:	0007b903          	ld	s2,0(a5)
    struct proc *p, *cp;
    p = myproc();
    p->state = ZOMBIE;
    80000f1c:	4791                	li	a5,4
    80000f1e:	00f92c23          	sw	a5,24(s2)
    p->xstate = status;
    80000f22:	02a92a23          	sw	a0,52(s2)

    // 关闭打开的文件
    for (int fd = 0; fd < NOFILE; fd++) {
    80000f26:	05890493          	addi	s1,s2,88
    80000f2a:	0d890993          	addi	s3,s2,216
    80000f2e:	a021                	j	80000f36 <exit+0x3c>
    80000f30:	04a1                	addi	s1,s1,8
    80000f32:	01348b63          	beq	s1,s3,80000f48 <exit+0x4e>
        if (p->open_file[fd]) {
    80000f36:	6088                	ld	a0,0(s1)
    80000f38:	dd65                	beqz	a0,80000f30 <exit+0x36>
            file_close(p->open_file[fd]);
    80000f3a:	00002097          	auipc	ra,0x2
    80000f3e:	9e0080e7          	jalr	-1568(ra) # 8000291a <file_close>
            p->open_file[fd] = 0;
    80000f42:	0004b023          	sd	zero,0(s1)
    80000f46:	b7ed                	j	80000f30 <exit+0x36>
        }
    }

    // 归还当前目录inode
    putback_inode(p->current_dir);
    80000f48:	05093503          	ld	a0,80(s2)
    80000f4c:	00002097          	auipc	ra,0x2
    80000f50:	228080e7          	jalr	552(ra) # 80003174 <putback_inode>

    for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
        if (cp->parent == p) {
            cp->parent = initproc;
    80000f54:	00006617          	auipc	a2,0x6
    80000f58:	0ac63603          	ld	a2,172(a2) # 80007000 <initproc>
    for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    80000f5c:	00089797          	auipc	a5,0x89
    80000f60:	32c78793          	addi	a5,a5,812 # 8008a288 <proc_table>
    80000f64:	0008f697          	auipc	a3,0x8f
    80000f68:	f2468693          	addi	a3,a3,-220 # 8008fe88 <kmem>
    80000f6c:	a031                	j	80000f78 <exit+0x7e>
            cp->parent = initproc;
    80000f6e:	f390                	sd	a2,32(a5)
    for (cp = proc_table; cp < &proc_table[NPROC]; cp++) {
    80000f70:	17078793          	addi	a5,a5,368
    80000f74:	00d78663          	beq	a5,a3,80000f80 <exit+0x86>
        if (cp->parent == p) {
    80000f78:	7398                	ld	a4,32(a5)
    80000f7a:	ff271be3          	bne	a4,s2,80000f70 <exit+0x76>
    80000f7e:	bfc5                	j	80000f6e <exit+0x74>
        }
    }
    wakeup(p->parent);
    80000f80:	02093503          	ld	a0,32(s2)
    80000f84:	00000097          	auipc	ra,0x0
    80000f88:	c2a080e7          	jalr	-982(ra) # 80000bae <wakeup>
    spin_lock(&p->proc_lock);
    80000f8c:	854a                	mv	a0,s2
    80000f8e:	00003097          	auipc	ra,0x3
    80000f92:	bf0080e7          	jalr	-1040(ra) # 80003b7e <spin_lock>
    before_sched();
    80000f96:	00000097          	auipc	ra,0x0
    80000f9a:	a38080e7          	jalr	-1480(ra) # 800009ce <before_sched>
    panic("exit");
    80000f9e:	00005517          	auipc	a0,0x5
    80000fa2:	10250513          	addi	a0,a0,258 # 800060a0 <etext+0xa0>
    80000fa6:	00000097          	auipc	ra,0x0
    80000faa:	6d0080e7          	jalr	1744(ra) # 80001676 <panic>
}
    80000fae:	70a2                	ld	ra,40(sp)
    80000fb0:	7402                	ld	s0,32(sp)
    80000fb2:	64e2                	ld	s1,24(sp)
    80000fb4:	6942                	ld	s2,16(sp)
    80000fb6:	69a2                	ld	s3,8(sp)
    80000fb8:	6145                	addi	sp,sp,48
    80000fba:	8082                	ret

0000000080000fbc <print_proc>:

void print_proc() {
    80000fbc:	7179                	addi	sp,sp,-48
    80000fbe:	f406                	sd	ra,40(sp)
    80000fc0:	f022                	sd	s0,32(sp)
    80000fc2:	ec26                	sd	s1,24(sp)
    80000fc4:	e84a                	sd	s2,16(sp)
    80000fc6:	e44e                	sd	s3,8(sp)
    80000fc8:	1800                	addi	s0,sp,48
    struct proc *p;
    printf(" \npid\tstate\n");
    80000fca:	00005517          	auipc	a0,0x5
    80000fce:	0de50513          	addi	a0,a0,222 # 800060a8 <etext+0xa8>
    80000fd2:	00000097          	auipc	ra,0x0
    80000fd6:	5e0080e7          	jalr	1504(ra) # 800015b2 <printf>
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80000fda:	00089497          	auipc	s1,0x89
    80000fde:	2ae48493          	addi	s1,s1,686 # 8008a288 <proc_table>
        if (p->state == UNUSED)
            continue;
        printf(" %d\t  %d\n", p->pid, p->state);
    80000fe2:	00005997          	auipc	s3,0x5
    80000fe6:	0d698993          	addi	s3,s3,214 # 800060b8 <etext+0xb8>
    for (p = proc_table; p < &proc_table[NPROC]; p++) {
    80000fea:	0008f917          	auipc	s2,0x8f
    80000fee:	e9e90913          	addi	s2,s2,-354 # 8008fe88 <kmem>
    80000ff2:	a029                	j	80000ffc <print_proc+0x40>
    80000ff4:	17048493          	addi	s1,s1,368
    80000ff8:	01248b63          	beq	s1,s2,8000100e <print_proc+0x52>
        if (p->state == UNUSED)
    80000ffc:	4c90                	lw	a2,24(s1)
    80000ffe:	da7d                	beqz	a2,80000ff4 <print_proc+0x38>
        printf(" %d\t  %d\n", p->pid, p->state);
    80001000:	5c8c                	lw	a1,56(s1)
    80001002:	854e                	mv	a0,s3
    80001004:	00000097          	auipc	ra,0x0
    80001008:	5ae080e7          	jalr	1454(ra) # 800015b2 <printf>
    8000100c:	b7e5                	j	80000ff4 <print_proc+0x38>
    }
}
    8000100e:	70a2                	ld	ra,40(sp)
    80001010:	7402                	ld	s0,32(sp)
    80001012:	64e2                	ld	s1,24(sp)
    80001014:	6942                	ld	s2,16(sp)
    80001016:	69a2                	ld	s3,8(sp)
    80001018:	6145                	addi	sp,sp,48
    8000101a:	8082                	ret

000000008000101c <yield>:

//
// 让出cpu
//
void yield() {
    8000101c:	1101                	addi	sp,sp,-32
    8000101e:	ec06                	sd	ra,24(sp)
    80001020:	e822                	sd	s0,16(sp)
    80001022:	e426                	sd	s1,8(sp)
    80001024:	1000                	addi	s0,sp,32
    80001026:	8792                	mv	a5,tp
    return mycpu()->proc;
    80001028:	2781                	sext.w	a5,a5
    8000102a:	079e                	slli	a5,a5,0x7
    8000102c:	00007717          	auipc	a4,0x7
    80001030:	1dc70713          	addi	a4,a4,476 # 80008208 <cpus>
    80001034:	97ba                	add	a5,a5,a4
    80001036:	6384                	ld	s1,0(a5)
    struct proc *p = myproc();
    spin_lock(&p->proc_lock);
    80001038:	8526                	mv	a0,s1
    8000103a:	00003097          	auipc	ra,0x3
    8000103e:	b44080e7          	jalr	-1212(ra) # 80003b7e <spin_lock>
    p->state = RUNNABLE;
    80001042:	4789                	li	a5,2
    80001044:	cc9c                	sw	a5,24(s1)
    before_sched();
    80001046:	00000097          	auipc	ra,0x0
    8000104a:	988080e7          	jalr	-1656(ra) # 800009ce <before_sched>
    spin_unlock(&p->proc_lock);
    8000104e:	8526                	mv	a0,s1
    80001050:	00003097          	auipc	ra,0x3
    80001054:	c02080e7          	jalr	-1022(ra) # 80003c52 <spin_unlock>
}
    80001058:	60e2                	ld	ra,24(sp)
    8000105a:	6442                	ld	s0,16(sp)
    8000105c:	64a2                	ld	s1,8(sp)
    8000105e:	6105                	addi	sp,sp,32
    80001060:	8082                	ret

0000000080001062 <either_copyout>:
 *  根据user_dst将源数据复制内核地址或用户地址
 *  @param user_dst dst是否为用户空间地址
 *  @param copy的长度
 * @return 成功返回0，失败返回-1
 */
int either_copyout(int user_dst, uint64 dst, void *src, int len) {
    80001062:	1101                	addi	sp,sp,-32
    80001064:	ec06                	sd	ra,24(sp)
    80001066:	e822                	sd	s0,16(sp)
    80001068:	e426                	sd	s1,8(sp)
    8000106a:	1000                	addi	s0,sp,32
    8000106c:	84aa                	mv	s1,a0
    8000106e:	852e                	mv	a0,a1
    80001070:	85b2                	mv	a1,a2
    80001072:	8792                	mv	a5,tp
    struct proc *p = myproc();
    if (user_dst) {
    80001074:	c485                	beqz	s1,8000109c <either_copyout+0x3a>
    return mycpu()->proc;
    80001076:	2781                	sext.w	a5,a5
    80001078:	079e                	slli	a5,a5,0x7
    8000107a:	00007717          	auipc	a4,0x7
    8000107e:	18e70713          	addi	a4,a4,398 # 80008208 <cpus>
    80001082:	97ba                	add	a5,a5,a4
        return copyout(p->pagetable, dst, src, len);
    80001084:	639c                	ld	a5,0(a5)
    80001086:	85aa                	mv	a1,a0
    80001088:	67a8                	ld	a0,72(a5)
    8000108a:	00001097          	auipc	ra,0x1
    8000108e:	c92080e7          	jalr	-878(ra) # 80001d1c <copyout>
    } else {
        memmove((char *) dst, src, len);
        return 0;
    }
}
    80001092:	60e2                	ld	ra,24(sp)
    80001094:	6442                	ld	s0,16(sp)
    80001096:	64a2                	ld	s1,8(sp)
    80001098:	6105                	addi	sp,sp,32
    8000109a:	8082                	ret
        memmove((char *) dst, src, len);
    8000109c:	8636                	mv	a2,a3
    8000109e:	00000097          	auipc	ra,0x0
    800010a2:	07a080e7          	jalr	122(ra) # 80001118 <memmove>
        return 0;
    800010a6:	8526                	mv	a0,s1
    800010a8:	b7ed                	j	80001092 <either_copyout+0x30>

00000000800010aa <either_copyin>:
 *  根据user_dst将数据从内核地址或用户地址copy到dst中
 *  @param user_src dst是否为用户空间地址
 *  @param copy的长度
 * @return 成功返回0，失败返回-1
 */
int either_copyin(void *dst, int user_src, uint64 src, uint64 len) {
    800010aa:	1101                	addi	sp,sp,-32
    800010ac:	ec06                	sd	ra,24(sp)
    800010ae:	e822                	sd	s0,16(sp)
    800010b0:	e426                	sd	s1,8(sp)
    800010b2:	1000                	addi	s0,sp,32
    800010b4:	84ae                	mv	s1,a1
    800010b6:	85b2                	mv	a1,a2
    800010b8:	8792                	mv	a5,tp
    struct proc *p = myproc();
    if (user_src) {
    800010ba:	c485                	beqz	s1,800010e2 <either_copyin+0x38>
    return mycpu()->proc;
    800010bc:	2781                	sext.w	a5,a5
    800010be:	079e                	slli	a5,a5,0x7
    800010c0:	00007717          	auipc	a4,0x7
    800010c4:	14870713          	addi	a4,a4,328 # 80008208 <cpus>
    800010c8:	97ba                	add	a5,a5,a4
        return copyin(p->pagetable, dst, src, len);
    800010ca:	639c                	ld	a5,0(a5)
    800010cc:	85aa                	mv	a1,a0
    800010ce:	67a8                	ld	a0,72(a5)
    800010d0:	00001097          	auipc	ra,0x1
    800010d4:	b04080e7          	jalr	-1276(ra) # 80001bd4 <copyin>
    } else {
        memmove(dst, (char *) src, len);
        return 0;
    }
}
    800010d8:	60e2                	ld	ra,24(sp)
    800010da:	6442                	ld	s0,16(sp)
    800010dc:	64a2                	ld	s1,8(sp)
    800010de:	6105                	addi	sp,sp,32
    800010e0:	8082                	ret
        memmove(dst, (char *) src, len);
    800010e2:	0006861b          	sext.w	a2,a3
    800010e6:	00000097          	auipc	ra,0x0
    800010ea:	032080e7          	jalr	50(ra) # 80001118 <memmove>
        return 0;
    800010ee:	8526                	mv	a0,s1
    800010f0:	b7e5                	j	800010d8 <either_copyin+0x2e>

00000000800010f2 <memset>:
#include "types.h"

void *memset(void *dst, int c, uint n) {
    800010f2:	1141                	addi	sp,sp,-16
    800010f4:	e422                	sd	s0,8(sp)
    800010f6:	0800                	addi	s0,sp,16
    char *cdst = (char *) dst;
    int i;
    for (i = 0; i < n; i++) {
    800010f8:	ce09                	beqz	a2,80001112 <memset+0x20>
    800010fa:	87aa                	mv	a5,a0
    800010fc:	fff6071b          	addiw	a4,a2,-1
    80001100:	1702                	slli	a4,a4,0x20
    80001102:	9301                	srli	a4,a4,0x20
    80001104:	0705                	addi	a4,a4,1
    80001106:	972a                	add	a4,a4,a0
        cdst[i] = c;
    80001108:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++) {
    8000110c:	0785                	addi	a5,a5,1
    8000110e:	fee79de3          	bne	a5,a4,80001108 <memset+0x16>
    }
    return dst;
}
    80001112:	6422                	ld	s0,8(sp)
    80001114:	0141                	addi	sp,sp,16
    80001116:	8082                	ret

0000000080001118 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
    80001118:	1141                	addi	sp,sp,-16
    8000111a:	e422                	sd	s0,8(sp)
    8000111c:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst) {
    8000111e:	02b57663          	bgeu	a0,a1,8000114a <memmove+0x32>
        while (n-- > 0)
    80001122:	02c05163          	blez	a2,80001144 <memmove+0x2c>
    80001126:	fff6079b          	addiw	a5,a2,-1
    8000112a:	1782                	slli	a5,a5,0x20
    8000112c:	9381                	srli	a5,a5,0x20
    8000112e:	0785                	addi	a5,a5,1
    80001130:	97aa                	add	a5,a5,a0
    dst = vdst;
    80001132:	872a                	mv	a4,a0
            *dst++ = *src++;
    80001134:	0585                	addi	a1,a1,1
    80001136:	0705                	addi	a4,a4,1
    80001138:	fff5c683          	lbu	a3,-1(a1)
    8000113c:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
    80001140:	fee79ae3          	bne	a5,a4,80001134 <memmove+0x1c>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
    80001144:	6422                	ld	s0,8(sp)
    80001146:	0141                	addi	sp,sp,16
    80001148:	8082                	ret
        dst += n;
    8000114a:	00c50733          	add	a4,a0,a2
        src += n;
    8000114e:	95b2                	add	a1,a1,a2
        while (n-- > 0)
    80001150:	fec05ae3          	blez	a2,80001144 <memmove+0x2c>
    80001154:	fff6079b          	addiw	a5,a2,-1
    80001158:	1782                	slli	a5,a5,0x20
    8000115a:	9381                	srli	a5,a5,0x20
    8000115c:	fff7c793          	not	a5,a5
    80001160:	97ba                	add	a5,a5,a4
            *--dst = *--src;
    80001162:	15fd                	addi	a1,a1,-1
    80001164:	177d                	addi	a4,a4,-1
    80001166:	0005c683          	lbu	a3,0(a1)
    8000116a:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
    8000116e:	fee79ae3          	bne	a5,a4,80001162 <memmove+0x4a>
    80001172:	bfc9                	j	80001144 <memmove+0x2c>

0000000080001174 <strlen>:

uint strlen(const char *s) {
    80001174:	1141                	addi	sp,sp,-16
    80001176:	e422                	sd	s0,8(sp)
    80001178:	0800                	addi	s0,sp,16
    int n;
    for (n = 0; s[n]; n++);
    8000117a:	00054783          	lbu	a5,0(a0)
    8000117e:	cf91                	beqz	a5,8000119a <strlen+0x26>
    80001180:	0505                	addi	a0,a0,1
    80001182:	87aa                	mv	a5,a0
    80001184:	4685                	li	a3,1
    80001186:	9e89                	subw	a3,a3,a0
    80001188:	00f6853b          	addw	a0,a3,a5
    8000118c:	0785                	addi	a5,a5,1
    8000118e:	fff7c703          	lbu	a4,-1(a5)
    80001192:	fb7d                	bnez	a4,80001188 <strlen+0x14>
    return n;
}
    80001194:	6422                	ld	s0,8(sp)
    80001196:	0141                	addi	sp,sp,16
    80001198:	8082                	ret
    for (n = 0; s[n]; n++);
    8000119a:	4501                	li	a0,0
    8000119c:	bfe5                	j	80001194 <strlen+0x20>

000000008000119e <strcpy>:

char* strcpy(char* s, const char* t)
{
    8000119e:	1141                	addi	sp,sp,-16
    800011a0:	e422                	sd	s0,8(sp)
    800011a2:	0800                	addi	s0,sp,16
    char* os;
    os = s;
    while ((*s++ = *t++) != 0)
    800011a4:	87aa                	mv	a5,a0
    800011a6:	0585                	addi	a1,a1,1
    800011a8:	0785                	addi	a5,a5,1
    800011aa:	fff5c703          	lbu	a4,-1(a1)
    800011ae:	fee78fa3          	sb	a4,-1(a5)
    800011b2:	fb75                	bnez	a4,800011a6 <strcpy+0x8>
        ;
    return os;
}
    800011b4:	6422                	ld	s0,8(sp)
    800011b6:	0141                	addi	sp,sp,16
    800011b8:	8082                	ret

00000000800011ba <safestrcpy>:
// 和strncpy类似, 该函数会保证字符串以0结束。
char* safestrcpy(char *s, const char *t, int n)
{
    800011ba:	1141                	addi	sp,sp,-16
    800011bc:	e422                	sd	s0,8(sp)
    800011be:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    if(n <= 0)
    800011c0:	02c05363          	blez	a2,800011e6 <safestrcpy+0x2c>
    800011c4:	fff6069b          	addiw	a3,a2,-1
    800011c8:	1682                	slli	a3,a3,0x20
    800011ca:	9281                	srli	a3,a3,0x20
    800011cc:	96ae                	add	a3,a3,a1
    800011ce:	87aa                	mv	a5,a0
        return os;
    while(--n > 0 && (*s++ = *t++) != 0)
    800011d0:	00d58963          	beq	a1,a3,800011e2 <safestrcpy+0x28>
    800011d4:	0585                	addi	a1,a1,1
    800011d6:	0785                	addi	a5,a5,1
    800011d8:	fff5c703          	lbu	a4,-1(a1)
    800011dc:	fee78fa3          	sb	a4,-1(a5)
    800011e0:	fb65                	bnez	a4,800011d0 <safestrcpy+0x16>
        ;
    *s = 0;
    800011e2:	00078023          	sb	zero,0(a5)
    return os;
}
    800011e6:	6422                	ld	s0,8(sp)
    800011e8:	0141                	addi	sp,sp,16
    800011ea:	8082                	ret

00000000800011ec <strncpy>:
char * strncpy(char *s, const char *t, int n) {
    800011ec:	1141                	addi	sp,sp,-16
    800011ee:	e422                	sd	s0,8(sp)
    800011f0:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while (n-- > 0 && (*s++ = *t++) != 0);
    800011f2:	872a                	mv	a4,a0
    800011f4:	8832                	mv	a6,a2
    800011f6:	367d                	addiw	a2,a2,-1
    800011f8:	01005963          	blez	a6,8000120a <strncpy+0x1e>
    800011fc:	0705                	addi	a4,a4,1
    800011fe:	0005c783          	lbu	a5,0(a1)
    80001202:	fef70fa3          	sb	a5,-1(a4)
    80001206:	0585                	addi	a1,a1,1
    80001208:	f7f5                	bnez	a5,800011f4 <strncpy+0x8>
    while (n-- > 0)
    8000120a:	00c05d63          	blez	a2,80001224 <strncpy+0x38>
    8000120e:	86ba                	mv	a3,a4
        *s++ = 0;
    80001210:	0685                	addi	a3,a3,1
    80001212:	fe068fa3          	sb	zero,-1(a3)
    while (n-- > 0)
    80001216:	fff6c793          	not	a5,a3
    8000121a:	9fb9                	addw	a5,a5,a4
    8000121c:	010787bb          	addw	a5,a5,a6
    80001220:	fef048e3          	bgtz	a5,80001210 <strncpy+0x24>
    return os;
}
    80001224:	6422                	ld	s0,8(sp)
    80001226:	0141                	addi	sp,sp,16
    80001228:	8082                	ret

000000008000122a <strcmp>:

int strcmp(const char* p, const char* q)
{
    8000122a:	1141                	addi	sp,sp,-16
    8000122c:	e422                	sd	s0,8(sp)
    8000122e:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
    80001230:	00054783          	lbu	a5,0(a0)
    80001234:	cb91                	beqz	a5,80001248 <strcmp+0x1e>
    80001236:	0005c703          	lbu	a4,0(a1)
    8000123a:	00f71763          	bne	a4,a5,80001248 <strcmp+0x1e>
        p++, q++;
    8000123e:	0505                	addi	a0,a0,1
    80001240:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
    80001242:	00054783          	lbu	a5,0(a0)
    80001246:	fbe5                	bnez	a5,80001236 <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
    80001248:	0005c503          	lbu	a0,0(a1)
}
    8000124c:	40a7853b          	subw	a0,a5,a0
    80001250:	6422                	ld	s0,8(sp)
    80001252:	0141                	addi	sp,sp,16
    80001254:	8082                	ret

0000000080001256 <strncmp>:

int strncmp(const char *p, const char *q, uint n)
{
    80001256:	1141                	addi	sp,sp,-16
    80001258:	e422                	sd	s0,8(sp)
    8000125a:	0800                	addi	s0,sp,16
    while(n > 0 && *p && *p == *q)
    8000125c:	ce11                	beqz	a2,80001278 <strncmp+0x22>
    8000125e:	00054783          	lbu	a5,0(a0)
    80001262:	cf89                	beqz	a5,8000127c <strncmp+0x26>
    80001264:	0005c703          	lbu	a4,0(a1)
    80001268:	00f71a63          	bne	a4,a5,8000127c <strncmp+0x26>
        n--, p++, q++;
    8000126c:	367d                	addiw	a2,a2,-1
    8000126e:	0505                	addi	a0,a0,1
    80001270:	0585                	addi	a1,a1,1
    while(n > 0 && *p && *p == *q)
    80001272:	f675                	bnez	a2,8000125e <strncmp+0x8>
    if(n == 0)
        return 0;
    80001274:	4501                	li	a0,0
    80001276:	a809                	j	80001288 <strncmp+0x32>
    80001278:	4501                	li	a0,0
    8000127a:	a039                	j	80001288 <strncmp+0x32>
    if(n == 0)
    8000127c:	ca09                	beqz	a2,8000128e <strncmp+0x38>
    return (uchar)*p - (uchar)*q;
    8000127e:	00054503          	lbu	a0,0(a0)
    80001282:	0005c783          	lbu	a5,0(a1)
    80001286:	9d1d                	subw	a0,a0,a5
}
    80001288:	6422                	ld	s0,8(sp)
    8000128a:	0141                	addi	sp,sp,16
    8000128c:	8082                	ret
        return 0;
    8000128e:	4501                	li	a0,0
    80001290:	bfe5                	j	80001288 <strncmp+0x32>

0000000080001292 <pswitch>:
    80001292:	00153023          	sd	ra,0(a0)
    80001296:	00253423          	sd	sp,8(a0)
    8000129a:	e900                	sd	s0,16(a0)
    8000129c:	ed04                	sd	s1,24(a0)
    8000129e:	03253023          	sd	s2,32(a0)
    800012a2:	03353423          	sd	s3,40(a0)
    800012a6:	03453823          	sd	s4,48(a0)
    800012aa:	03553c23          	sd	s5,56(a0)
    800012ae:	05653023          	sd	s6,64(a0)
    800012b2:	05753423          	sd	s7,72(a0)
    800012b6:	05853823          	sd	s8,80(a0)
    800012ba:	05953c23          	sd	s9,88(a0)
    800012be:	07a53023          	sd	s10,96(a0)
    800012c2:	07b53423          	sd	s11,104(a0)
    800012c6:	0005b083          	ld	ra,0(a1)
    800012ca:	0085b103          	ld	sp,8(a1)
    800012ce:	6980                	ld	s0,16(a1)
    800012d0:	6d84                	ld	s1,24(a1)
    800012d2:	0205b903          	ld	s2,32(a1)
    800012d6:	0285b983          	ld	s3,40(a1)
    800012da:	0305ba03          	ld	s4,48(a1)
    800012de:	0385ba83          	ld	s5,56(a1)
    800012e2:	0405bb03          	ld	s6,64(a1)
    800012e6:	0485bb83          	ld	s7,72(a1)
    800012ea:	0505bc03          	ld	s8,80(a1)
    800012ee:	0585bc83          	ld	s9,88(a1)
    800012f2:	0605bd03          	ld	s10,96(a1)
    800012f6:	0685bd83          	ld	s11,104(a1)
    800012fa:	8082                	ret

00000000800012fc <printint>:

static char digits[] = "0123456789ABCDEF";

static void
printint(int fd, int xx, int base, int sgn)
{
    800012fc:	7139                	addi	sp,sp,-64
    800012fe:	fc06                	sd	ra,56(sp)
    80001300:	f822                	sd	s0,48(sp)
    80001302:	f426                	sd	s1,40(sp)
    80001304:	f04a                	sd	s2,32(sp)
    80001306:	ec4e                	sd	s3,24(sp)
    80001308:	0080                	addi	s0,sp,64
    8000130a:	84aa                	mv	s1,a0
    char buf[16];
    int i, neg;
    uint x;

    neg = 0;
    if (sgn && xx < 0) {
    8000130c:	c299                	beqz	a3,80001312 <printint+0x16>
    8000130e:	0805c863          	bltz	a1,8000139e <printint+0xa2>
        neg = 1;
        x = -xx;
    } else {
        x = xx;
    80001312:	2581                	sext.w	a1,a1
    neg = 0;
    80001314:	4881                	li	a7,0
    80001316:	fc040693          	addi	a3,s0,-64
    }

    i = 0;
    8000131a:	4701                	li	a4,0
    do {
        buf[i++] = digits[x % base];
    8000131c:	2601                	sext.w	a2,a2
    8000131e:	00005517          	auipc	a0,0x5
    80001322:	de250513          	addi	a0,a0,-542 # 80006100 <digits>
    80001326:	883a                	mv	a6,a4
    80001328:	2705                	addiw	a4,a4,1
    8000132a:	02c5f7bb          	remuw	a5,a1,a2
    8000132e:	1782                	slli	a5,a5,0x20
    80001330:	9381                	srli	a5,a5,0x20
    80001332:	97aa                	add	a5,a5,a0
    80001334:	0007c783          	lbu	a5,0(a5)
    80001338:	00f68023          	sb	a5,0(a3)
    } while ((x /= base) != 0);
    8000133c:	0005879b          	sext.w	a5,a1
    80001340:	02c5d5bb          	divuw	a1,a1,a2
    80001344:	0685                	addi	a3,a3,1
    80001346:	fec7f0e3          	bgeu	a5,a2,80001326 <printint+0x2a>
    if (neg)
    8000134a:	00088b63          	beqz	a7,80001360 <printint+0x64>
        buf[i++] = '-';
    8000134e:	fd040793          	addi	a5,s0,-48
    80001352:	973e                	add	a4,a4,a5
    80001354:	02d00793          	li	a5,45
    80001358:	fef70823          	sb	a5,-16(a4)
    8000135c:	0028071b          	addiw	a4,a6,2

    while (--i >= 0)
    80001360:	02e05863          	blez	a4,80001390 <printint+0x94>
    80001364:	fc040793          	addi	a5,s0,-64
    80001368:	00e78933          	add	s2,a5,a4
    8000136c:	fff78993          	addi	s3,a5,-1
    80001370:	99ba                	add	s3,s3,a4
    80001372:	377d                	addiw	a4,a4,-1
    80001374:	1702                	slli	a4,a4,0x20
    80001376:	9301                	srli	a4,a4,0x20
    80001378:	40e989b3          	sub	s3,s3,a4
        putc(fd, buf[i]);
    8000137c:	fff94583          	lbu	a1,-1(s2)
    80001380:	8526                	mv	a0,s1
    80001382:	fffff097          	auipc	ra,0xfffff
    80001386:	ffc080e7          	jalr	-4(ra) # 8000037e <putc>
    while (--i >= 0)
    8000138a:	197d                	addi	s2,s2,-1
    8000138c:	ff3918e3          	bne	s2,s3,8000137c <printint+0x80>
}
    80001390:	70e2                	ld	ra,56(sp)
    80001392:	7442                	ld	s0,48(sp)
    80001394:	74a2                	ld	s1,40(sp)
    80001396:	7902                	ld	s2,32(sp)
    80001398:	69e2                	ld	s3,24(sp)
    8000139a:	6121                	addi	sp,sp,64
    8000139c:	8082                	ret
        x = -xx;
    8000139e:	40b005bb          	negw	a1,a1
        neg = 1;
    800013a2:	4885                	li	a7,1
        x = -xx;
    800013a4:	bf8d                	j	80001316 <printint+0x1a>

00000000800013a6 <vprintf>:
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char* fmt, va_list ap)
{
    800013a6:	7119                	addi	sp,sp,-128
    800013a8:	fc86                	sd	ra,120(sp)
    800013aa:	f8a2                	sd	s0,112(sp)
    800013ac:	f4a6                	sd	s1,104(sp)
    800013ae:	f0ca                	sd	s2,96(sp)
    800013b0:	ecce                	sd	s3,88(sp)
    800013b2:	e8d2                	sd	s4,80(sp)
    800013b4:	e4d6                	sd	s5,72(sp)
    800013b6:	e0da                	sd	s6,64(sp)
    800013b8:	fc5e                	sd	s7,56(sp)
    800013ba:	f862                	sd	s8,48(sp)
    800013bc:	f466                	sd	s9,40(sp)
    800013be:	f06a                	sd	s10,32(sp)
    800013c0:	ec6e                	sd	s11,24(sp)
    800013c2:	0100                	addi	s0,sp,128
    char* s;
    int c, i, state;

    state = 0;
    for (i = 0; fmt[i]; i++) {
    800013c4:	0005c903          	lbu	s2,0(a1)
    800013c8:	18090f63          	beqz	s2,80001566 <vprintf+0x1c0>
    800013cc:	8aaa                	mv	s5,a0
    800013ce:	8b32                	mv	s6,a2
    800013d0:	00158493          	addi	s1,a1,1
    state = 0;
    800013d4:	4981                	li	s3,0
            if (c == '%') {
                state = '%';
            } else {
                putc(fd, c);
            }
        } else if (state == '%') {
    800013d6:	02500a13          	li	s4,37
            if (c == 'd') {
    800013da:	06400c13          	li	s8,100
                printint(fd, va_arg(ap, int), 10, 1);
            } else if (c == 'l') {
    800013de:	06c00c93          	li	s9,108
                printint(fd, va_arg(ap, uint64), 10, 0);
            } else if (c == 'x') {
    800013e2:	07800d13          	li	s10,120
                printint(fd, va_arg(ap, int), 16, 0);
            } else if (c == 'p') {
    800013e6:	07000d93          	li	s11,112
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    800013ea:	00005b97          	auipc	s7,0x5
    800013ee:	d16b8b93          	addi	s7,s7,-746 # 80006100 <digits>
    800013f2:	a839                	j	80001410 <vprintf+0x6a>
                putc(fd, c);
    800013f4:	85ca                	mv	a1,s2
    800013f6:	8556                	mv	a0,s5
    800013f8:	fffff097          	auipc	ra,0xfffff
    800013fc:	f86080e7          	jalr	-122(ra) # 8000037e <putc>
    80001400:	a019                	j	80001406 <vprintf+0x60>
        } else if (state == '%') {
    80001402:	01498f63          	beq	s3,s4,80001420 <vprintf+0x7a>
    for (i = 0; fmt[i]; i++) {
    80001406:	0485                	addi	s1,s1,1
    80001408:	fff4c903          	lbu	s2,-1(s1)
    8000140c:	14090d63          	beqz	s2,80001566 <vprintf+0x1c0>
        c = fmt[i] & 0xff;
    80001410:	0009079b          	sext.w	a5,s2
        if (state == 0) {
    80001414:	fe0997e3          	bnez	s3,80001402 <vprintf+0x5c>
            if (c == '%') {
    80001418:	fd479ee3          	bne	a5,s4,800013f4 <vprintf+0x4e>
                state = '%';
    8000141c:	89be                	mv	s3,a5
    8000141e:	b7e5                	j	80001406 <vprintf+0x60>
            if (c == 'd') {
    80001420:	05878063          	beq	a5,s8,80001460 <vprintf+0xba>
            } else if (c == 'l') {
    80001424:	05978c63          	beq	a5,s9,8000147c <vprintf+0xd6>
            } else if (c == 'x') {
    80001428:	07a78863          	beq	a5,s10,80001498 <vprintf+0xf2>
            } else if (c == 'p') {
    8000142c:	09b78463          	beq	a5,s11,800014b4 <vprintf+0x10e>
                printptr(fd, va_arg(ap, uint64));
            } else if (c == 's') {
    80001430:	07300713          	li	a4,115
    80001434:	0ce78663          	beq	a5,a4,80001500 <vprintf+0x15a>
                    s = "(null)";
                while (*s != 0) {
                    putc(fd, *s);
                    s++;
                }
            } else if (c == 'c') {
    80001438:	06300713          	li	a4,99
    8000143c:	0ee78e63          	beq	a5,a4,80001538 <vprintf+0x192>
                putc(fd, va_arg(ap, uint));
            } else if (c == '%') {
    80001440:	11478863          	beq	a5,s4,80001550 <vprintf+0x1aa>
                putc(fd, c);
            } else {
                // Unknown % sequence.  Print it to draw attention.
                putc(fd, '%');
    80001444:	85d2                	mv	a1,s4
    80001446:	8556                	mv	a0,s5
    80001448:	fffff097          	auipc	ra,0xfffff
    8000144c:	f36080e7          	jalr	-202(ra) # 8000037e <putc>
                putc(fd, c);
    80001450:	85ca                	mv	a1,s2
    80001452:	8556                	mv	a0,s5
    80001454:	fffff097          	auipc	ra,0xfffff
    80001458:	f2a080e7          	jalr	-214(ra) # 8000037e <putc>
            }
            state = 0;
    8000145c:	4981                	li	s3,0
    8000145e:	b765                	j	80001406 <vprintf+0x60>
                printint(fd, va_arg(ap, int), 10, 1);
    80001460:	008b0913          	addi	s2,s6,8
    80001464:	4685                	li	a3,1
    80001466:	4629                	li	a2,10
    80001468:	000b2583          	lw	a1,0(s6)
    8000146c:	8556                	mv	a0,s5
    8000146e:	00000097          	auipc	ra,0x0
    80001472:	e8e080e7          	jalr	-370(ra) # 800012fc <printint>
    80001476:	8b4a                	mv	s6,s2
            state = 0;
    80001478:	4981                	li	s3,0
    8000147a:	b771                	j	80001406 <vprintf+0x60>
                printint(fd, va_arg(ap, uint64), 10, 0);
    8000147c:	008b0913          	addi	s2,s6,8
    80001480:	4681                	li	a3,0
    80001482:	4629                	li	a2,10
    80001484:	000b2583          	lw	a1,0(s6)
    80001488:	8556                	mv	a0,s5
    8000148a:	00000097          	auipc	ra,0x0
    8000148e:	e72080e7          	jalr	-398(ra) # 800012fc <printint>
    80001492:	8b4a                	mv	s6,s2
            state = 0;
    80001494:	4981                	li	s3,0
    80001496:	bf85                	j	80001406 <vprintf+0x60>
                printint(fd, va_arg(ap, int), 16, 0);
    80001498:	008b0913          	addi	s2,s6,8
    8000149c:	4681                	li	a3,0
    8000149e:	4641                	li	a2,16
    800014a0:	000b2583          	lw	a1,0(s6)
    800014a4:	8556                	mv	a0,s5
    800014a6:	00000097          	auipc	ra,0x0
    800014aa:	e56080e7          	jalr	-426(ra) # 800012fc <printint>
    800014ae:	8b4a                	mv	s6,s2
            state = 0;
    800014b0:	4981                	li	s3,0
    800014b2:	bf91                	j	80001406 <vprintf+0x60>
                printptr(fd, va_arg(ap, uint64));
    800014b4:	008b0793          	addi	a5,s6,8
    800014b8:	f8f43423          	sd	a5,-120(s0)
    800014bc:	000b3983          	ld	s3,0(s6)
    putc(fd, '0');
    800014c0:	03000593          	li	a1,48
    800014c4:	8556                	mv	a0,s5
    800014c6:	fffff097          	auipc	ra,0xfffff
    800014ca:	eb8080e7          	jalr	-328(ra) # 8000037e <putc>
    putc(fd, 'x');
    800014ce:	85ea                	mv	a1,s10
    800014d0:	8556                	mv	a0,s5
    800014d2:	fffff097          	auipc	ra,0xfffff
    800014d6:	eac080e7          	jalr	-340(ra) # 8000037e <putc>
    800014da:	4941                	li	s2,16
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    800014dc:	03c9d793          	srli	a5,s3,0x3c
    800014e0:	97de                	add	a5,a5,s7
    800014e2:	0007c583          	lbu	a1,0(a5)
    800014e6:	8556                	mv	a0,s5
    800014e8:	fffff097          	auipc	ra,0xfffff
    800014ec:	e96080e7          	jalr	-362(ra) # 8000037e <putc>
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800014f0:	0992                	slli	s3,s3,0x4
    800014f2:	397d                	addiw	s2,s2,-1
    800014f4:	fe0914e3          	bnez	s2,800014dc <vprintf+0x136>
                printptr(fd, va_arg(ap, uint64));
    800014f8:	f8843b03          	ld	s6,-120(s0)
            state = 0;
    800014fc:	4981                	li	s3,0
    800014fe:	b721                	j	80001406 <vprintf+0x60>
                s = va_arg(ap, char*);
    80001500:	008b0993          	addi	s3,s6,8
    80001504:	000b3903          	ld	s2,0(s6)
                if (s == 0)
    80001508:	02090163          	beqz	s2,8000152a <vprintf+0x184>
                while (*s != 0) {
    8000150c:	00094583          	lbu	a1,0(s2)
    80001510:	c9a1                	beqz	a1,80001560 <vprintf+0x1ba>
                    putc(fd, *s);
    80001512:	8556                	mv	a0,s5
    80001514:	fffff097          	auipc	ra,0xfffff
    80001518:	e6a080e7          	jalr	-406(ra) # 8000037e <putc>
                    s++;
    8000151c:	0905                	addi	s2,s2,1
                while (*s != 0) {
    8000151e:	00094583          	lbu	a1,0(s2)
    80001522:	f9e5                	bnez	a1,80001512 <vprintf+0x16c>
                s = va_arg(ap, char*);
    80001524:	8b4e                	mv	s6,s3
            state = 0;
    80001526:	4981                	li	s3,0
    80001528:	bdf9                	j	80001406 <vprintf+0x60>
                    s = "(null)";
    8000152a:	00005917          	auipc	s2,0x5
    8000152e:	b9e90913          	addi	s2,s2,-1122 # 800060c8 <etext+0xc8>
                while (*s != 0) {
    80001532:	02800593          	li	a1,40
    80001536:	bff1                	j	80001512 <vprintf+0x16c>
                putc(fd, va_arg(ap, uint));
    80001538:	008b0913          	addi	s2,s6,8
    8000153c:	000b4583          	lbu	a1,0(s6)
    80001540:	8556                	mv	a0,s5
    80001542:	fffff097          	auipc	ra,0xfffff
    80001546:	e3c080e7          	jalr	-452(ra) # 8000037e <putc>
    8000154a:	8b4a                	mv	s6,s2
            state = 0;
    8000154c:	4981                	li	s3,0
    8000154e:	bd65                	j	80001406 <vprintf+0x60>
                putc(fd, c);
    80001550:	85d2                	mv	a1,s4
    80001552:	8556                	mv	a0,s5
    80001554:	fffff097          	auipc	ra,0xfffff
    80001558:	e2a080e7          	jalr	-470(ra) # 8000037e <putc>
            state = 0;
    8000155c:	4981                	li	s3,0
    8000155e:	b565                	j	80001406 <vprintf+0x60>
                s = va_arg(ap, char*);
    80001560:	8b4e                	mv	s6,s3
            state = 0;
    80001562:	4981                	li	s3,0
    80001564:	b54d                	j	80001406 <vprintf+0x60>
        }
    }
}
    80001566:	70e6                	ld	ra,120(sp)
    80001568:	7446                	ld	s0,112(sp)
    8000156a:	74a6                	ld	s1,104(sp)
    8000156c:	7906                	ld	s2,96(sp)
    8000156e:	69e6                	ld	s3,88(sp)
    80001570:	6a46                	ld	s4,80(sp)
    80001572:	6aa6                	ld	s5,72(sp)
    80001574:	6b06                	ld	s6,64(sp)
    80001576:	7be2                	ld	s7,56(sp)
    80001578:	7c42                	ld	s8,48(sp)
    8000157a:	7ca2                	ld	s9,40(sp)
    8000157c:	7d02                	ld	s10,32(sp)
    8000157e:	6de2                	ld	s11,24(sp)
    80001580:	6109                	addi	sp,sp,128
    80001582:	8082                	ret

0000000080001584 <fprintf>:

void fprintf(int fd, const char* fmt, ...)
{
    80001584:	715d                	addi	sp,sp,-80
    80001586:	ec06                	sd	ra,24(sp)
    80001588:	e822                	sd	s0,16(sp)
    8000158a:	1000                	addi	s0,sp,32
    8000158c:	e010                	sd	a2,0(s0)
    8000158e:	e414                	sd	a3,8(s0)
    80001590:	e818                	sd	a4,16(s0)
    80001592:	ec1c                	sd	a5,24(s0)
    80001594:	03043023          	sd	a6,32(s0)
    80001598:	03143423          	sd	a7,40(s0)
    va_list ap;

    va_start(ap, fmt);
    8000159c:	fe843423          	sd	s0,-24(s0)
    vprintf(fd, fmt, ap);
    800015a0:	8622                	mv	a2,s0
    800015a2:	00000097          	auipc	ra,0x0
    800015a6:	e04080e7          	jalr	-508(ra) # 800013a6 <vprintf>
}
    800015aa:	60e2                	ld	ra,24(sp)
    800015ac:	6442                	ld	s0,16(sp)
    800015ae:	6161                	addi	sp,sp,80
    800015b0:	8082                	ret

00000000800015b2 <printf>:

void printf(const char* fmt, ...)
{
    800015b2:	711d                	addi	sp,sp,-96
    800015b4:	ec06                	sd	ra,24(sp)
    800015b6:	e822                	sd	s0,16(sp)
    800015b8:	1000                	addi	s0,sp,32
    800015ba:	e40c                	sd	a1,8(s0)
    800015bc:	e810                	sd	a2,16(s0)
    800015be:	ec14                	sd	a3,24(s0)
    800015c0:	f018                	sd	a4,32(s0)
    800015c2:	f41c                	sd	a5,40(s0)
    800015c4:	03043823          	sd	a6,48(s0)
    800015c8:	03143c23          	sd	a7,56(s0)
    va_list ap;

    va_start(ap, fmt);
    800015cc:	00840613          	addi	a2,s0,8
    800015d0:	fec43423          	sd	a2,-24(s0)
    vprintf(1, fmt, ap);
    800015d4:	85aa                	mv	a1,a0
    800015d6:	4505                	li	a0,1
    800015d8:	00000097          	auipc	ra,0x0
    800015dc:	dce080e7          	jalr	-562(ra) # 800013a6 <vprintf>
}
    800015e0:	60e2                	ld	ra,24(sp)
    800015e2:	6442                	ld	s0,16(sp)
    800015e4:	6125                	addi	sp,sp,96
    800015e6:	8082                	ret

00000000800015e8 <puts>:

void puts(const char* str)
{
    800015e8:	1141                	addi	sp,sp,-16
    800015ea:	e406                	sd	ra,8(sp)
    800015ec:	e022                	sd	s0,0(sp)
    800015ee:	0800                	addi	s0,sp,16
    800015f0:	85aa                	mv	a1,a0
    printf("%s\n", str);
    800015f2:	00005517          	auipc	a0,0x5
    800015f6:	ade50513          	addi	a0,a0,-1314 # 800060d0 <etext+0xd0>
    800015fa:	00000097          	auipc	ra,0x0
    800015fe:	fb8080e7          	jalr	-72(ra) # 800015b2 <printf>
}
    80001602:	60a2                	ld	ra,8(sp)
    80001604:	6402                	ld	s0,0(sp)
    80001606:	0141                	addi	sp,sp,16
    80001608:	8082                	ret

000000008000160a <backtrace>:

void backtrace()
{
    8000160a:	7179                	addi	sp,sp,-48
    8000160c:	f406                	sd	ra,40(sp)
    8000160e:	f022                	sd	s0,32(sp)
    80001610:	ec26                	sd	s1,24(sp)
    80001612:	e84a                	sd	s2,16(sp)
    80001614:	e44e                	sd	s3,8(sp)
    80001616:	e052                	sd	s4,0(sp)
    80001618:	1800                	addi	s0,sp,48
    asm volatile("mv %0, s0" : "=r" (x) );
    8000161a:	84a2                	mv	s1,s0
    uint64 s0 = r_fp();
    uint64 stack_top = PGROUNDUP(s0);
    8000161c:	6905                	lui	s2,0x1
    8000161e:	197d                	addi	s2,s2,-1
    80001620:	9926                	add	s2,s2,s1
    80001622:	79fd                	lui	s3,0xfffff
    80001624:	01397933          	and	s2,s2,s3
    uint64 stack_bottom = PGROUNDDOWN(s0);
    80001628:	0134f9b3          	and	s3,s1,s3
    uint64 fp = s0;

    printf("backtrace:\n");
    8000162c:	00005517          	auipc	a0,0x5
    80001630:	aac50513          	addi	a0,a0,-1364 # 800060d8 <etext+0xd8>
    80001634:	00000097          	auipc	ra,0x0
    80001638:	f7e080e7          	jalr	-130(ra) # 800015b2 <printf>
    while (fp != stack_top && fp != stack_bottom)
    8000163c:	02990563          	beq	s2,s1,80001666 <backtrace+0x5c>
    80001640:	02998363          	beq	s3,s1,80001666 <backtrace+0x5c>
    {
        printf("%p\n", *(uint64*)(fp - 8));
    80001644:	00005a17          	auipc	s4,0x5
    80001648:	aa4a0a13          	addi	s4,s4,-1372 # 800060e8 <etext+0xe8>
    8000164c:	ff84b583          	ld	a1,-8(s1)
    80001650:	8552                	mv	a0,s4
    80001652:	00000097          	auipc	ra,0x0
    80001656:	f60080e7          	jalr	-160(ra) # 800015b2 <printf>
        fp = *(uint64*)(fp - 16);
    8000165a:	ff04b483          	ld	s1,-16(s1)
    while (fp != stack_top && fp != stack_bottom)
    8000165e:	00990463          	beq	s2,s1,80001666 <backtrace+0x5c>
    80001662:	fe9995e3          	bne	s3,s1,8000164c <backtrace+0x42>
    }
}
    80001666:	70a2                	ld	ra,40(sp)
    80001668:	7402                	ld	s0,32(sp)
    8000166a:	64e2                	ld	s1,24(sp)
    8000166c:	6942                	ld	s2,16(sp)
    8000166e:	69a2                	ld	s3,8(sp)
    80001670:	6a02                	ld	s4,0(sp)
    80001672:	6145                	addi	sp,sp,48
    80001674:	8082                	ret

0000000080001676 <panic>:

void panic(char* s)
{
    80001676:	1141                	addi	sp,sp,-16
    80001678:	e406                	sd	ra,8(sp)
    8000167a:	e022                	sd	s0,0(sp)
    8000167c:	0800                	addi	s0,sp,16
    8000167e:	85aa                	mv	a1,a0
    printf("panic:%s", s);
    80001680:	00005517          	auipc	a0,0x5
    80001684:	a7050513          	addi	a0,a0,-1424 # 800060f0 <etext+0xf0>
    80001688:	00000097          	auipc	ra,0x0
    8000168c:	f2a080e7          	jalr	-214(ra) # 800015b2 <printf>
//    backtrace();
    for (;;) {
    80001690:	a001                	j	80001690 <panic+0x1a>

0000000080001692 <kfree>:
}


// 释放一页pa指向的物理空间
void kfree(void *pa)
{
    80001692:	1101                	addi	sp,sp,-32
    80001694:	ec06                	sd	ra,24(sp)
    80001696:	e822                	sd	s0,16(sp)
    80001698:	e426                	sd	s1,8(sp)
    8000169a:	e04a                	sd	s2,0(sp)
    8000169c:	1000                	addi	s0,sp,32
    8000169e:	84aa                	mv	s1,a0
    struct node *r;

    if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800016a0:	03451793          	slli	a5,a0,0x34
    800016a4:	eb99                	bnez	a5,800016ba <kfree+0x28>
    800016a6:	000b0797          	auipc	a5,0xb0
    800016aa:	d4278793          	addi	a5,a5,-702 # 800b13e8 <end>
    800016ae:	00f56663          	bltu	a0,a5,800016ba <kfree+0x28>
    800016b2:	47c5                	li	a5,17
    800016b4:	07ee                	slli	a5,a5,0x1b
    800016b6:	00f56a63          	bltu	a0,a5,800016ca <kfree+0x38>
        panic("kfree");
    800016ba:	00005517          	auipc	a0,0x5
    800016be:	a5e50513          	addi	a0,a0,-1442 # 80006118 <digits+0x18>
    800016c2:	00000097          	auipc	ra,0x0
    800016c6:	fb4080e7          	jalr	-76(ra) # 80001676 <panic>

    // 填充无效值
    memset(pa, 1, PGSIZE);
    800016ca:	6605                	lui	a2,0x1
    800016cc:	4585                	li	a1,1
    800016ce:	8526                	mv	a0,s1
    800016d0:	00000097          	auipc	ra,0x0
    800016d4:	a22080e7          	jalr	-1502(ra) # 800010f2 <memset>

    r = (struct node*)pa;

    spin_lock(&kmem.lock);
    800016d8:	0008e917          	auipc	s2,0x8e
    800016dc:	7b090913          	addi	s2,s2,1968 # 8008fe88 <kmem>
    800016e0:	854a                	mv	a0,s2
    800016e2:	00002097          	auipc	ra,0x2
    800016e6:	49c080e7          	jalr	1180(ra) # 80003b7e <spin_lock>
    r->next = kmem.freelist;
    800016ea:	01893783          	ld	a5,24(s2)
    800016ee:	e09c                	sd	a5,0(s1)
    kmem.freelist = r;
    800016f0:	00993c23          	sd	s1,24(s2)
    spin_unlock(&kmem.lock);
    800016f4:	854a                	mv	a0,s2
    800016f6:	00002097          	auipc	ra,0x2
    800016fa:	55c080e7          	jalr	1372(ra) # 80003c52 <spin_unlock>
}
    800016fe:	60e2                	ld	ra,24(sp)
    80001700:	6442                	ld	s0,16(sp)
    80001702:	64a2                	ld	s1,8(sp)
    80001704:	6902                	ld	s2,0(sp)
    80001706:	6105                	addi	sp,sp,32
    80001708:	8082                	ret

000000008000170a <free_range>:
{
    8000170a:	7179                	addi	sp,sp,-48
    8000170c:	f406                	sd	ra,40(sp)
    8000170e:	f022                	sd	s0,32(sp)
    80001710:	ec26                	sd	s1,24(sp)
    80001712:	e84a                	sd	s2,16(sp)
    80001714:	e44e                	sd	s3,8(sp)
    80001716:	e052                	sd	s4,0(sp)
    80001718:	1800                	addi	s0,sp,48
    p = (char*)PGROUNDUP((uint64)pa_start);
    8000171a:	6785                	lui	a5,0x1
    8000171c:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80001720:	94aa                	add	s1,s1,a0
    80001722:	757d                	lui	a0,0xfffff
    80001724:	8ce9                	and	s1,s1,a0
    for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80001726:	94be                	add	s1,s1,a5
    80001728:	0095ee63          	bltu	a1,s1,80001744 <free_range+0x3a>
    8000172c:	892e                	mv	s2,a1
        kfree(p);
    8000172e:	7a7d                	lui	s4,0xfffff
    for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80001730:	6985                	lui	s3,0x1
        kfree(p);
    80001732:	01448533          	add	a0,s1,s4
    80001736:	00000097          	auipc	ra,0x0
    8000173a:	f5c080e7          	jalr	-164(ra) # 80001692 <kfree>
    for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000173e:	94ce                	add	s1,s1,s3
    80001740:	fe9979e3          	bgeu	s2,s1,80001732 <free_range+0x28>
}
    80001744:	70a2                	ld	ra,40(sp)
    80001746:	7402                	ld	s0,32(sp)
    80001748:	64e2                	ld	s1,24(sp)
    8000174a:	6942                	ld	s2,16(sp)
    8000174c:	69a2                	ld	s3,8(sp)
    8000174e:	6a02                	ld	s4,0(sp)
    80001750:	6145                	addi	sp,sp,48
    80001752:	8082                	ret

0000000080001754 <kernel_mem_init>:
{
    80001754:	1141                	addi	sp,sp,-16
    80001756:	e406                	sd	ra,8(sp)
    80001758:	e022                	sd	s0,0(sp)
    8000175a:	0800                	addi	s0,sp,16
    spinlock_init(&kmem.lock, "kmem");
    8000175c:	00005597          	auipc	a1,0x5
    80001760:	9c458593          	addi	a1,a1,-1596 # 80006120 <digits+0x20>
    80001764:	0008e517          	auipc	a0,0x8e
    80001768:	72450513          	addi	a0,a0,1828 # 8008fe88 <kmem>
    8000176c:	00002097          	auipc	ra,0x2
    80001770:	382080e7          	jalr	898(ra) # 80003aee <spinlock_init>
    free_range(end, (void*)PHYSTOP);
    80001774:	45c5                	li	a1,17
    80001776:	05ee                	slli	a1,a1,0x1b
    80001778:	000b0517          	auipc	a0,0xb0
    8000177c:	c7050513          	addi	a0,a0,-912 # 800b13e8 <end>
    80001780:	00000097          	auipc	ra,0x0
    80001784:	f8a080e7          	jalr	-118(ra) # 8000170a <free_range>
}
    80001788:	60a2                	ld	ra,8(sp)
    8000178a:	6402                	ld	s0,0(sp)
    8000178c:	0141                	addi	sp,sp,16
    8000178e:	8082                	ret

0000000080001790 <kalloc>:

// 分配一个4096字节的物理页，返回内核能够使用的指针, 如果
// 内存耗尽会返回0。
void * kalloc(void)
{
    80001790:	1101                	addi	sp,sp,-32
    80001792:	ec06                	sd	ra,24(sp)
    80001794:	e822                	sd	s0,16(sp)
    80001796:	e426                	sd	s1,8(sp)
    80001798:	1000                	addi	s0,sp,32
    struct node *r;

    spin_lock(&kmem.lock);
    8000179a:	0008e497          	auipc	s1,0x8e
    8000179e:	6ee48493          	addi	s1,s1,1774 # 8008fe88 <kmem>
    800017a2:	8526                	mv	a0,s1
    800017a4:	00002097          	auipc	ra,0x2
    800017a8:	3da080e7          	jalr	986(ra) # 80003b7e <spin_lock>
    r = kmem.freelist;
    800017ac:	6c84                	ld	s1,24(s1)
    if(r)
    800017ae:	c885                	beqz	s1,800017de <kalloc+0x4e>
        kmem.freelist = r->next;
    800017b0:	609c                	ld	a5,0(s1)
    800017b2:	0008e517          	auipc	a0,0x8e
    800017b6:	6d650513          	addi	a0,a0,1750 # 8008fe88 <kmem>
    800017ba:	ed1c                	sd	a5,24(a0)
    spin_unlock(&kmem.lock);
    800017bc:	00002097          	auipc	ra,0x2
    800017c0:	496080e7          	jalr	1174(ra) # 80003c52 <spin_unlock>

    if(r)
        memset((char*)r, 5, PGSIZE); // fill with junk
    800017c4:	6605                	lui	a2,0x1
    800017c6:	4595                	li	a1,5
    800017c8:	8526                	mv	a0,s1
    800017ca:	00000097          	auipc	ra,0x0
    800017ce:	928080e7          	jalr	-1752(ra) # 800010f2 <memset>
    return (void*)r;
}
    800017d2:	8526                	mv	a0,s1
    800017d4:	60e2                	ld	ra,24(sp)
    800017d6:	6442                	ld	s0,16(sp)
    800017d8:	64a2                	ld	s1,8(sp)
    800017da:	6105                	addi	sp,sp,32
    800017dc:	8082                	ret
    spin_unlock(&kmem.lock);
    800017de:	0008e517          	auipc	a0,0x8e
    800017e2:	6aa50513          	addi	a0,a0,1706 # 8008fe88 <kmem>
    800017e6:	00002097          	auipc	ra,0x2
    800017ea:	46c080e7          	jalr	1132(ra) # 80003c52 <spin_unlock>
    if(r)
    800017ee:	b7d5                	j	800017d2 <kalloc+0x42>

00000000800017f0 <vm_hart_init>:
}

/**
 * 切换页表寄存器为内核页表并启用分页
 */
void vm_hart_init() {
    800017f0:	1141                	addi	sp,sp,-16
    800017f2:	e422                	sd	s0,8(sp)
    800017f4:	0800                	addi	s0,sp,16
    w_satp(MAKE_SATP(kernel_pagetable));
    800017f6:	00006797          	auipc	a5,0x6
    800017fa:	8127b783          	ld	a5,-2030(a5) # 80007008 <kernel_pagetable>
    800017fe:	83b1                	srli	a5,a5,0xc
    80001800:	577d                	li	a4,-1
    80001802:	177e                	slli	a4,a4,0x3f
    80001804:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80001806:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000180a:	12000073          	sfence.vma
    sfence_vma();
}
    8000180e:	6422                	ld	s0,8(sp)
    80001810:	0141                	addi	sp,sp,16
    80001812:	8082                	ret

0000000080001814 <walk>:
 * @param pagetable 页表
 * @param va 需要查找PTE的va
 * @param alloc 是否创建缺失的页表
 * @return
 */
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc) {
    80001814:	7139                	addi	sp,sp,-64
    80001816:	fc06                	sd	ra,56(sp)
    80001818:	f822                	sd	s0,48(sp)
    8000181a:	f426                	sd	s1,40(sp)
    8000181c:	f04a                	sd	s2,32(sp)
    8000181e:	ec4e                	sd	s3,24(sp)
    80001820:	e852                	sd	s4,16(sp)
    80001822:	e456                	sd	s5,8(sp)
    80001824:	e05a                	sd	s6,0(sp)
    80001826:	0080                	addi	s0,sp,64
    80001828:	84aa                	mv	s1,a0
    8000182a:	89ae                	mv	s3,a1
    8000182c:	8ab2                	mv	s5,a2
    if (va >= MAXVA)
    8000182e:	57fd                	li	a5,-1
    80001830:	83e9                	srli	a5,a5,0x1a
    80001832:	00b7e563          	bltu	a5,a1,8000183c <walk+0x28>
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc) {
    80001836:	4a79                	li	s4,30
        panic("walk");
    for (int level = 2; level > 0; level--) {
    80001838:	4b31                	li	s6,12
    8000183a:	a091                	j	8000187e <walk+0x6a>
        panic("walk");
    8000183c:	00005517          	auipc	a0,0x5
    80001840:	8ec50513          	addi	a0,a0,-1812 # 80006128 <digits+0x28>
    80001844:	00000097          	auipc	ra,0x0
    80001848:	e32080e7          	jalr	-462(ra) # 80001676 <panic>
    8000184c:	b7ed                	j	80001836 <walk+0x22>
        pte_t *pte = &pagetable[PX(level, va)];
        if (*pte & PTE_V) {
            pagetable = (pagetable_t) PTE2PA(*pte);
        } else {
            if (!alloc || (pagetable = (pte_t *) kalloc()) == 0)
    8000184e:	060a8663          	beqz	s5,800018ba <walk+0xa6>
    80001852:	00000097          	auipc	ra,0x0
    80001856:	f3e080e7          	jalr	-194(ra) # 80001790 <kalloc>
    8000185a:	84aa                	mv	s1,a0
    8000185c:	c529                	beqz	a0,800018a6 <walk+0x92>
                return 0;
            memset(pagetable, 0, PGSIZE);
    8000185e:	6605                	lui	a2,0x1
    80001860:	4581                	li	a1,0
    80001862:	00000097          	auipc	ra,0x0
    80001866:	890080e7          	jalr	-1904(ra) # 800010f2 <memset>
            *pte = PA2PTE(pagetable) | PTE_V;
    8000186a:	00c4d793          	srli	a5,s1,0xc
    8000186e:	07aa                	slli	a5,a5,0xa
    80001870:	0017e793          	ori	a5,a5,1
    80001874:	00f93023          	sd	a5,0(s2)
    for (int level = 2; level > 0; level--) {
    80001878:	3a5d                	addiw	s4,s4,-9
    8000187a:	036a0063          	beq	s4,s6,8000189a <walk+0x86>
        pte_t *pte = &pagetable[PX(level, va)];
    8000187e:	0149d933          	srl	s2,s3,s4
    80001882:	1ff97913          	andi	s2,s2,511
    80001886:	090e                	slli	s2,s2,0x3
    80001888:	9926                	add	s2,s2,s1
        if (*pte & PTE_V) {
    8000188a:	00093483          	ld	s1,0(s2)
    8000188e:	0014f793          	andi	a5,s1,1
    80001892:	dfd5                	beqz	a5,8000184e <walk+0x3a>
            pagetable = (pagetable_t) PTE2PA(*pte);
    80001894:	80a9                	srli	s1,s1,0xa
    80001896:	04b2                	slli	s1,s1,0xc
    80001898:	b7c5                	j	80001878 <walk+0x64>
        }
    }
    return &pagetable[PX(0, va)];
    8000189a:	00c9d513          	srli	a0,s3,0xc
    8000189e:	1ff57513          	andi	a0,a0,511
    800018a2:	050e                	slli	a0,a0,0x3
    800018a4:	9526                	add	a0,a0,s1
}
    800018a6:	70e2                	ld	ra,56(sp)
    800018a8:	7442                	ld	s0,48(sp)
    800018aa:	74a2                	ld	s1,40(sp)
    800018ac:	7902                	ld	s2,32(sp)
    800018ae:	69e2                	ld	s3,24(sp)
    800018b0:	6a42                	ld	s4,16(sp)
    800018b2:	6aa2                	ld	s5,8(sp)
    800018b4:	6b02                	ld	s6,0(sp)
    800018b6:	6121                	addi	sp,sp,64
    800018b8:	8082                	ret
                return 0;
    800018ba:	4501                	li	a0,0
    800018bc:	b7ed                	j	800018a6 <walk+0x92>

00000000800018be <mappages>:
 * @param va 虚拟地址起始地址
 * @param sz 要映射地址的大小
 * @param pa 物理地址的起始地址
 * @param perm PTE的权限
*/
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm) {
    800018be:	711d                	addi	sp,sp,-96
    800018c0:	ec86                	sd	ra,88(sp)
    800018c2:	e8a2                	sd	s0,80(sp)
    800018c4:	e4a6                	sd	s1,72(sp)
    800018c6:	e0ca                	sd	s2,64(sp)
    800018c8:	fc4e                	sd	s3,56(sp)
    800018ca:	f852                	sd	s4,48(sp)
    800018cc:	f456                	sd	s5,40(sp)
    800018ce:	f05a                	sd	s6,32(sp)
    800018d0:	ec5e                	sd	s7,24(sp)
    800018d2:	e862                	sd	s8,16(sp)
    800018d4:	e466                	sd	s9,8(sp)
    800018d6:	1080                	addi	s0,sp,96
    800018d8:	8b2a                	mv	s6,a0
    800018da:	8bba                	mv	s7,a4
    uint64 a, last;
    pte_t *pte;

    a = PGROUNDDOWN(va);
    800018dc:	777d                	lui	a4,0xfffff
    800018de:	00e5f7b3          	and	a5,a1,a4
    last = PGROUNDDOWN(va + size - 1);
    800018e2:	167d                	addi	a2,a2,-1
    800018e4:	00b60a33          	add	s4,a2,a1
    800018e8:	00ea7a33          	and	s4,s4,a4
    a = PGROUNDDOWN(va);
    800018ec:	89be                	mv	s3,a5
    800018ee:	40f68ab3          	sub	s5,a3,a5
    for (;;) {
        if ((pte = walk(pagetable, a, 1)) == 0)
            return -1;
        if (*pte & PTE_V)
            panic("remap");
    800018f2:	00005c97          	auipc	s9,0x5
    800018f6:	83ec8c93          	addi	s9,s9,-1986 # 80006130 <digits+0x30>
        *pte = PA2PTE(pa) | perm | PTE_V;
        if (a == last) {
            break;
        }
        a += PGSIZE;
    800018fa:	6c05                	lui	s8,0x1
    800018fc:	a00d                	j	8000191e <mappages+0x60>
            panic("remap");
    800018fe:	8566                	mv	a0,s9
    80001900:	00000097          	auipc	ra,0x0
    80001904:	d76080e7          	jalr	-650(ra) # 80001676 <panic>
        *pte = PA2PTE(pa) | perm | PTE_V;
    80001908:	80b1                	srli	s1,s1,0xc
    8000190a:	04aa                	slli	s1,s1,0xa
    8000190c:	0174e4b3          	or	s1,s1,s7
    80001910:	0014e493          	ori	s1,s1,1
    80001914:	00993023          	sd	s1,0(s2)
        if (a == last) {
    80001918:	05498063          	beq	s3,s4,80001958 <mappages+0x9a>
        a += PGSIZE;
    8000191c:	99e2                	add	s3,s3,s8
    for (;;) {
    8000191e:	013a84b3          	add	s1,s5,s3
        if ((pte = walk(pagetable, a, 1)) == 0)
    80001922:	4605                	li	a2,1
    80001924:	85ce                	mv	a1,s3
    80001926:	855a                	mv	a0,s6
    80001928:	00000097          	auipc	ra,0x0
    8000192c:	eec080e7          	jalr	-276(ra) # 80001814 <walk>
    80001930:	892a                	mv	s2,a0
    80001932:	c509                	beqz	a0,8000193c <mappages+0x7e>
        if (*pte & PTE_V)
    80001934:	611c                	ld	a5,0(a0)
    80001936:	8b85                	andi	a5,a5,1
    80001938:	dbe1                	beqz	a5,80001908 <mappages+0x4a>
    8000193a:	b7d1                	j	800018fe <mappages+0x40>
            return -1;
    8000193c:	557d                	li	a0,-1
        pa += PGSIZE;
    }
    return 0;
}
    8000193e:	60e6                	ld	ra,88(sp)
    80001940:	6446                	ld	s0,80(sp)
    80001942:	64a6                	ld	s1,72(sp)
    80001944:	6906                	ld	s2,64(sp)
    80001946:	79e2                	ld	s3,56(sp)
    80001948:	7a42                	ld	s4,48(sp)
    8000194a:	7aa2                	ld	s5,40(sp)
    8000194c:	7b02                	ld	s6,32(sp)
    8000194e:	6be2                	ld	s7,24(sp)
    80001950:	6c42                	ld	s8,16(sp)
    80001952:	6ca2                	ld	s9,8(sp)
    80001954:	6125                	addi	sp,sp,96
    80001956:	8082                	ret
    return 0;
    80001958:	4501                	li	a0,0
    8000195a:	b7d5                	j	8000193e <mappages+0x80>

000000008000195c <walkaddr>:
 */
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
    pte_t *pte;
    uint64 pa;

    if (va >= MAXVA)
    8000195c:	57fd                	li	a5,-1
    8000195e:	83e9                	srli	a5,a5,0x1a
    80001960:	00b7f463          	bgeu	a5,a1,80001968 <walkaddr+0xc>
        return 0;
    80001964:	4501                	li	a0,0
    // TODO 用户空间时修改
    if ((*pte & PTE_U) == 0)
        return 0;
    pa = PTE2PA(*pte);
    return pa;
}
    80001966:	8082                	ret
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
    80001968:	1141                	addi	sp,sp,-16
    8000196a:	e406                	sd	ra,8(sp)
    8000196c:	e022                	sd	s0,0(sp)
    8000196e:	0800                	addi	s0,sp,16
    pte = walk(pagetable, va, 0);
    80001970:	4601                	li	a2,0
    80001972:	00000097          	auipc	ra,0x0
    80001976:	ea2080e7          	jalr	-350(ra) # 80001814 <walk>
    if (pte == 0)
    8000197a:	c105                	beqz	a0,8000199a <walkaddr+0x3e>
    if ((*pte & PTE_V) == 0)
    8000197c:	611c                	ld	a5,0(a0)
    if ((*pte & PTE_U) == 0)
    8000197e:	0117f693          	andi	a3,a5,17
    80001982:	4745                	li	a4,17
        return 0;
    80001984:	4501                	li	a0,0
    if ((*pte & PTE_U) == 0)
    80001986:	00e68663          	beq	a3,a4,80001992 <walkaddr+0x36>
}
    8000198a:	60a2                	ld	ra,8(sp)
    8000198c:	6402                	ld	s0,0(sp)
    8000198e:	0141                	addi	sp,sp,16
    80001990:	8082                	ret
    pa = PTE2PA(*pte);
    80001992:	00a7d513          	srli	a0,a5,0xa
    80001996:	0532                	slli	a0,a0,0xc
    return pa;
    80001998:	bfcd                	j	8000198a <walkaddr+0x2e>
        return 0;
    8000199a:	4501                	li	a0,0
    8000199c:	b7fd                	j	8000198a <walkaddr+0x2e>

000000008000199e <kernel_vm_map>:
 * 添加虚拟地址和物理地址的映射到内核页表，只会在
 * 启动的过程中使用，在调用该函数时还没有flush TLB
 * 也没有启用分页。
 *
 */
void kernel_vm_map(uint64 va, uint64 pa, uint64 sz, int perm) {
    8000199e:	1141                	addi	sp,sp,-16
    800019a0:	e406                	sd	ra,8(sp)
    800019a2:	e022                	sd	s0,0(sp)
    800019a4:	0800                	addi	s0,sp,16
    800019a6:	8736                	mv	a4,a3
    if (mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    800019a8:	86ae                	mv	a3,a1
    800019aa:	85aa                	mv	a1,a0
    800019ac:	00005517          	auipc	a0,0x5
    800019b0:	65c53503          	ld	a0,1628(a0) # 80007008 <kernel_pagetable>
    800019b4:	00000097          	auipc	ra,0x0
    800019b8:	f0a080e7          	jalr	-246(ra) # 800018be <mappages>
    800019bc:	e509                	bnez	a0,800019c6 <kernel_vm_map+0x28>
        panic("kvmmap");
}
    800019be:	60a2                	ld	ra,8(sp)
    800019c0:	6402                	ld	s0,0(sp)
    800019c2:	0141                	addi	sp,sp,16
    800019c4:	8082                	ret
        panic("kvmmap");
    800019c6:	00004517          	auipc	a0,0x4
    800019ca:	77250513          	addi	a0,a0,1906 # 80006138 <digits+0x38>
    800019ce:	00000097          	auipc	ra,0x0
    800019d2:	ca8080e7          	jalr	-856(ra) # 80001676 <panic>
}
    800019d6:	b7e5                	j	800019be <kernel_vm_map+0x20>

00000000800019d8 <kernel_vm_init>:
void kernel_vm_init() {
    800019d8:	1101                	addi	sp,sp,-32
    800019da:	ec06                	sd	ra,24(sp)
    800019dc:	e822                	sd	s0,16(sp)
    800019de:	e426                	sd	s1,8(sp)
    800019e0:	1000                	addi	s0,sp,32
    kernel_pagetable = (pagetable_t) kalloc();
    800019e2:	00000097          	auipc	ra,0x0
    800019e6:	dae080e7          	jalr	-594(ra) # 80001790 <kalloc>
    800019ea:	00005797          	auipc	a5,0x5
    800019ee:	60a7bf23          	sd	a0,1566(a5) # 80007008 <kernel_pagetable>
    memset(kernel_pagetable, 0, PGSIZE);
    800019f2:	6605                	lui	a2,0x1
    800019f4:	4581                	li	a1,0
    800019f6:	fffff097          	auipc	ra,0xfffff
    800019fa:	6fc080e7          	jalr	1788(ra) # 800010f2 <memset>
    kernel_vm_map(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800019fe:	4699                	li	a3,6
    80001a00:	6605                	lui	a2,0x1
    80001a02:	100005b7          	lui	a1,0x10000
    80001a06:	10000537          	lui	a0,0x10000
    80001a0a:	00000097          	auipc	ra,0x0
    80001a0e:	f94080e7          	jalr	-108(ra) # 8000199e <kernel_vm_map>
    kernel_vm_map(VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001a12:	4699                	li	a3,6
    80001a14:	6605                	lui	a2,0x1
    80001a16:	100015b7          	lui	a1,0x10001
    80001a1a:	10001537          	lui	a0,0x10001
    80001a1e:	00000097          	auipc	ra,0x0
    80001a22:	f80080e7          	jalr	-128(ra) # 8000199e <kernel_vm_map>
    kernel_vm_map(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    80001a26:	4699                	li	a3,6
    80001a28:	6641                	lui	a2,0x10
    80001a2a:	020005b7          	lui	a1,0x2000
    80001a2e:	02000537          	lui	a0,0x2000
    80001a32:	00000097          	auipc	ra,0x0
    80001a36:	f6c080e7          	jalr	-148(ra) # 8000199e <kernel_vm_map>
    kernel_vm_map(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001a3a:	4699                	li	a3,6
    80001a3c:	00400637          	lui	a2,0x400
    80001a40:	0c0005b7          	lui	a1,0xc000
    80001a44:	0c000537          	lui	a0,0xc000
    80001a48:	00000097          	auipc	ra,0x0
    80001a4c:	f56080e7          	jalr	-170(ra) # 8000199e <kernel_vm_map>
    kernel_vm_map(KERNBASE, KERNBASE, (uint64) etext - KERNBASE, PTE_R | PTE_X);
    80001a50:	00004497          	auipc	s1,0x4
    80001a54:	5b048493          	addi	s1,s1,1456 # 80006000 <etext>
    80001a58:	46a9                	li	a3,10
    80001a5a:	80004617          	auipc	a2,0x80004
    80001a5e:	5a660613          	addi	a2,a2,1446 # 6000 <_entry-0x7fffa000>
    80001a62:	4585                	li	a1,1
    80001a64:	05fe                	slli	a1,a1,0x1f
    80001a66:	852e                	mv	a0,a1
    80001a68:	00000097          	auipc	ra,0x0
    80001a6c:	f36080e7          	jalr	-202(ra) # 8000199e <kernel_vm_map>
    kernel_vm_map((uint64) etext, (uint64) etext, PHYSTOP - (uint64) etext, PTE_R | PTE_W);
    80001a70:	4699                	li	a3,6
    80001a72:	4645                	li	a2,17
    80001a74:	066e                	slli	a2,a2,0x1b
    80001a76:	8e05                	sub	a2,a2,s1
    80001a78:	85a6                	mv	a1,s1
    80001a7a:	8526                	mv	a0,s1
    80001a7c:	00000097          	auipc	ra,0x0
    80001a80:	f22080e7          	jalr	-222(ra) # 8000199e <kernel_vm_map>
    kernel_vm_map(TRAMPOLINE, (uint64) trampoline, PGSIZE, PTE_R | PTE_X);
    80001a84:	46a9                	li	a3,10
    80001a86:	6605                	lui	a2,0x1
    80001a88:	00003597          	auipc	a1,0x3
    80001a8c:	57858593          	addi	a1,a1,1400 # 80005000 <_trampoline>
    80001a90:	04000537          	lui	a0,0x4000
    80001a94:	157d                	addi	a0,a0,-1
    80001a96:	0532                	slli	a0,a0,0xc
    80001a98:	00000097          	auipc	ra,0x0
    80001a9c:	f06080e7          	jalr	-250(ra) # 8000199e <kernel_vm_map>
}
    80001aa0:	60e2                	ld	ra,24(sp)
    80001aa2:	6442                	ld	s0,16(sp)
    80001aa4:	64a2                	ld	s1,8(sp)
    80001aa6:	6105                	addi	sp,sp,32
    80001aa8:	8082                	ret

0000000080001aaa <user_vm_alloc>:
 * @return
 */
uint64 user_vm_alloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz) {
    char *mem;
    uint64 a;
    if (newsz < oldsz)
    80001aaa:	06b66763          	bltu	a2,a1,80001b18 <user_vm_alloc+0x6e>
uint64 user_vm_alloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz) {
    80001aae:	7179                	addi	sp,sp,-48
    80001ab0:	f406                	sd	ra,40(sp)
    80001ab2:	f022                	sd	s0,32(sp)
    80001ab4:	ec26                	sd	s1,24(sp)
    80001ab6:	e84a                	sd	s2,16(sp)
    80001ab8:	e44e                	sd	s3,8(sp)
    80001aba:	e052                	sd	s4,0(sp)
    80001abc:	1800                	addi	s0,sp,48
    80001abe:	8a2a                	mv	s4,a0
    80001ac0:	89b2                	mv	s3,a2
        return oldsz;

    oldsz = PGROUNDUP(oldsz);
    80001ac2:	6905                	lui	s2,0x1
    80001ac4:	197d                	addi	s2,s2,-1
    80001ac6:	992e                	add	s2,s2,a1
    80001ac8:	77fd                	lui	a5,0xfffff
    80001aca:	00f97933          	and	s2,s2,a5
    for (a = oldsz; a < newsz; a += PGSIZE) {
    80001ace:	04c97763          	bgeu	s2,a2,80001b1c <user_vm_alloc+0x72>
        mem = kalloc();
    80001ad2:	00000097          	auipc	ra,0x0
    80001ad6:	cbe080e7          	jalr	-834(ra) # 80001790 <kalloc>
    80001ada:	84aa                	mv	s1,a0
        if (mem == 0) {
    80001adc:	c131                	beqz	a0,80001b20 <user_vm_alloc+0x76>
//            uvmdealloc(pagetable, a, oldsz);
            // TODO 失败释放
            return 0;
        }
        memset(mem, 0, PGSIZE);
    80001ade:	6605                	lui	a2,0x1
    80001ae0:	4581                	li	a1,0
    80001ae2:	fffff097          	auipc	ra,0xfffff
    80001ae6:	610080e7          	jalr	1552(ra) # 800010f2 <memset>
        if (mappages(pagetable, a, PGSIZE, (uint64) mem, PTE_W | PTE_X | PTE_R | PTE_U) != 0) {
    80001aea:	4779                	li	a4,30
    80001aec:	86a6                	mv	a3,s1
    80001aee:	6605                	lui	a2,0x1
    80001af0:	85ca                	mv	a1,s2
    80001af2:	8552                	mv	a0,s4
    80001af4:	00000097          	auipc	ra,0x0
    80001af8:	dca080e7          	jalr	-566(ra) # 800018be <mappages>
    80001afc:	e519                	bnez	a0,80001b0a <user_vm_alloc+0x60>
    for (a = oldsz; a < newsz; a += PGSIZE) {
    80001afe:	6785                	lui	a5,0x1
    80001b00:	993e                	add	s2,s2,a5
    80001b02:	fd3968e3          	bltu	s2,s3,80001ad2 <user_vm_alloc+0x28>
//            uvmdealloc(pagetable, a, oldsz);
            // TODO 失败释放
            return 0;
        }
    }
    return newsz;
    80001b06:	854e                	mv	a0,s3
    80001b08:	a829                	j	80001b22 <user_vm_alloc+0x78>
            kfree(mem);
    80001b0a:	8526                	mv	a0,s1
    80001b0c:	00000097          	auipc	ra,0x0
    80001b10:	b86080e7          	jalr	-1146(ra) # 80001692 <kfree>
            return 0;
    80001b14:	4501                	li	a0,0
    80001b16:	a031                	j	80001b22 <user_vm_alloc+0x78>
        return oldsz;
    80001b18:	852e                	mv	a0,a1
}
    80001b1a:	8082                	ret
    return newsz;
    80001b1c:	8532                	mv	a0,a2
    80001b1e:	a011                	j	80001b22 <user_vm_alloc+0x78>
            return 0;
    80001b20:	4501                	li	a0,0
}
    80001b22:	70a2                	ld	ra,40(sp)
    80001b24:	7402                	ld	s0,32(sp)
    80001b26:	64e2                	ld	s1,24(sp)
    80001b28:	6942                	ld	s2,16(sp)
    80001b2a:	69a2                	ld	s3,8(sp)
    80001b2c:	6a02                	ld	s4,0(sp)
    80001b2e:	6145                	addi	sp,sp,48
    80001b30:	8082                	ret

0000000080001b32 <user_vm_create>:
/**
 * 创建空的用户页表
 * 失败返回0
 * @return
 */
pagetable_t user_vm_create() {
    80001b32:	1101                	addi	sp,sp,-32
    80001b34:	ec06                	sd	ra,24(sp)
    80001b36:	e822                	sd	s0,16(sp)
    80001b38:	e426                	sd	s1,8(sp)
    80001b3a:	1000                	addi	s0,sp,32
    pagetable_t pagetable;
    pagetable = (pagetable_t) kalloc();
    80001b3c:	00000097          	auipc	ra,0x0
    80001b40:	c54080e7          	jalr	-940(ra) # 80001790 <kalloc>
    80001b44:	84aa                	mv	s1,a0
    if (pagetable == 0)
    80001b46:	c519                	beqz	a0,80001b54 <user_vm_create+0x22>
        return 0;
    memset(pagetable, 0, PGSIZE);
    80001b48:	6605                	lui	a2,0x1
    80001b4a:	4581                	li	a1,0
    80001b4c:	fffff097          	auipc	ra,0xfffff
    80001b50:	5a6080e7          	jalr	1446(ra) # 800010f2 <memset>
    return pagetable;
}
    80001b54:	8526                	mv	a0,s1
    80001b56:	60e2                	ld	ra,24(sp)
    80001b58:	6442                	ld	s0,16(sp)
    80001b5a:	64a2                	ld	s1,8(sp)
    80001b5c:	6105                	addi	sp,sp,32
    80001b5e:	8082                	ret

0000000080001b60 <user_vm_init>:
 * 将用户initcode加载进入pagetable，只在
 * 初始化第一个进程时才会调用该函数，sz必须
 * 小于PGSIZE
 */

void user_vm_init(pagetable_t pagetable, uchar *src, uint sz) {
    80001b60:	7179                	addi	sp,sp,-48
    80001b62:	f406                	sd	ra,40(sp)
    80001b64:	f022                	sd	s0,32(sp)
    80001b66:	ec26                	sd	s1,24(sp)
    80001b68:	e84a                	sd	s2,16(sp)
    80001b6a:	e44e                	sd	s3,8(sp)
    80001b6c:	e052                	sd	s4,0(sp)
    80001b6e:	1800                	addi	s0,sp,48
    80001b70:	8a2a                	mv	s4,a0
    80001b72:	89ae                	mv	s3,a1
    80001b74:	8932                	mv	s2,a2
    char *mem;

    if (sz >= PGSIZE)
    80001b76:	6785                	lui	a5,0x1
    80001b78:	04f67563          	bgeu	a2,a5,80001bc2 <user_vm_init+0x62>
        panic("inituvm: more than a page");
    mem = kalloc();
    80001b7c:	00000097          	auipc	ra,0x0
    80001b80:	c14080e7          	jalr	-1004(ra) # 80001790 <kalloc>
    80001b84:	84aa                	mv	s1,a0
    memset(mem, 0, PGSIZE);
    80001b86:	6605                	lui	a2,0x1
    80001b88:	4581                	li	a1,0
    80001b8a:	fffff097          	auipc	ra,0xfffff
    80001b8e:	568080e7          	jalr	1384(ra) # 800010f2 <memset>
    mappages(pagetable, 0, PGSIZE, (uint64) mem, PTE_W | PTE_R | PTE_X | PTE_U);
    80001b92:	4779                	li	a4,30
    80001b94:	86a6                	mv	a3,s1
    80001b96:	6605                	lui	a2,0x1
    80001b98:	4581                	li	a1,0
    80001b9a:	8552                	mv	a0,s4
    80001b9c:	00000097          	auipc	ra,0x0
    80001ba0:	d22080e7          	jalr	-734(ra) # 800018be <mappages>
    memmove(mem, src, sz);
    80001ba4:	864a                	mv	a2,s2
    80001ba6:	85ce                	mv	a1,s3
    80001ba8:	8526                	mv	a0,s1
    80001baa:	fffff097          	auipc	ra,0xfffff
    80001bae:	56e080e7          	jalr	1390(ra) # 80001118 <memmove>
}
    80001bb2:	70a2                	ld	ra,40(sp)
    80001bb4:	7402                	ld	s0,32(sp)
    80001bb6:	64e2                	ld	s1,24(sp)
    80001bb8:	6942                	ld	s2,16(sp)
    80001bba:	69a2                	ld	s3,8(sp)
    80001bbc:	6a02                	ld	s4,0(sp)
    80001bbe:	6145                	addi	sp,sp,48
    80001bc0:	8082                	ret
        panic("inituvm: more than a page");
    80001bc2:	00004517          	auipc	a0,0x4
    80001bc6:	57e50513          	addi	a0,a0,1406 # 80006140 <digits+0x40>
    80001bca:	00000097          	auipc	ra,0x0
    80001bce:	aac080e7          	jalr	-1364(ra) # 80001676 <panic>
    80001bd2:	b76d                	j	80001b7c <user_vm_init+0x1c>

0000000080001bd4 <copyin>:
 * 从给定的pagetable中，以vsrc为起点向后copy len字节到内核中的dst处。
 * 成功返回0，失败返回-1。
 */
int copyin(pagetable_t pagetable, char *dst, uint64 vsrc, uint64 len) {
    uint64 n, va0, pa0;
    while (len > 0) {
    80001bd4:	c6b5                	beqz	a3,80001c40 <copyin+0x6c>
int copyin(pagetable_t pagetable, char *dst, uint64 vsrc, uint64 len) {
    80001bd6:	715d                	addi	sp,sp,-80
    80001bd8:	e486                	sd	ra,72(sp)
    80001bda:	e0a2                	sd	s0,64(sp)
    80001bdc:	fc26                	sd	s1,56(sp)
    80001bde:	f84a                	sd	s2,48(sp)
    80001be0:	f44e                	sd	s3,40(sp)
    80001be2:	f052                	sd	s4,32(sp)
    80001be4:	ec56                	sd	s5,24(sp)
    80001be6:	e85a                	sd	s6,16(sp)
    80001be8:	e45e                	sd	s7,8(sp)
    80001bea:	e062                	sd	s8,0(sp)
    80001bec:	0880                	addi	s0,sp,80
    80001bee:	8b2a                	mv	s6,a0
    80001bf0:	8aae                	mv	s5,a1
    80001bf2:	8932                	mv	s2,a2
    80001bf4:	89b6                	mv	s3,a3
        va0 = PGROUNDDOWN(vsrc);
    80001bf6:	7bfd                	lui	s7,0xfffff
        pa0 = walkaddr(pagetable, va0);
        if (pa0 == 0) {
            return -1;
        }
        n = PGSIZE - (vsrc - va0);
    80001bf8:	6c05                	lui	s8,0x1
    80001bfa:	a00d                	j	80001c1c <copyin+0x48>
        if (n > len) {
            n = len;
        }
        memmove(dst, (void *) (pa0 + (vsrc - va0)), n);
    80001bfc:	954a                	add	a0,a0,s2
    80001bfe:	0004861b          	sext.w	a2,s1
    80001c02:	414505b3          	sub	a1,a0,s4
    80001c06:	8556                	mv	a0,s5
    80001c08:	fffff097          	auipc	ra,0xfffff
    80001c0c:	510080e7          	jalr	1296(ra) # 80001118 <memmove>
        len -= n;
    80001c10:	409989b3          	sub	s3,s3,s1
        dst += n;
    80001c14:	9aa6                	add	s5,s5,s1
        vsrc += n;
    80001c16:	9926                	add	s2,s2,s1
    while (len > 0) {
    80001c18:	02098263          	beqz	s3,80001c3c <copyin+0x68>
        va0 = PGROUNDDOWN(vsrc);
    80001c1c:	01797a33          	and	s4,s2,s7
        pa0 = walkaddr(pagetable, va0);
    80001c20:	85d2                	mv	a1,s4
    80001c22:	855a                	mv	a0,s6
    80001c24:	00000097          	auipc	ra,0x0
    80001c28:	d38080e7          	jalr	-712(ra) # 8000195c <walkaddr>
        if (pa0 == 0) {
    80001c2c:	cd01                	beqz	a0,80001c44 <copyin+0x70>
        n = PGSIZE - (vsrc - va0);
    80001c2e:	412a04b3          	sub	s1,s4,s2
    80001c32:	94e2                	add	s1,s1,s8
        if (n > len) {
    80001c34:	fc99f4e3          	bgeu	s3,s1,80001bfc <copyin+0x28>
    80001c38:	84ce                	mv	s1,s3
    80001c3a:	b7c9                	j	80001bfc <copyin+0x28>
    }
    return 0;
    80001c3c:	4501                	li	a0,0
    80001c3e:	a021                	j	80001c46 <copyin+0x72>
    80001c40:	4501                	li	a0,0
}
    80001c42:	8082                	ret
            return -1;
    80001c44:	557d                	li	a0,-1
}
    80001c46:	60a6                	ld	ra,72(sp)
    80001c48:	6406                	ld	s0,64(sp)
    80001c4a:	74e2                	ld	s1,56(sp)
    80001c4c:	7942                	ld	s2,48(sp)
    80001c4e:	79a2                	ld	s3,40(sp)
    80001c50:	7a02                	ld	s4,32(sp)
    80001c52:	6ae2                	ld	s5,24(sp)
    80001c54:	6b42                	ld	s6,16(sp)
    80001c56:	6ba2                	ld	s7,8(sp)
    80001c58:	6c02                	ld	s8,0(sp)
    80001c5a:	6161                	addi	sp,sp,80
    80001c5c:	8082                	ret

0000000080001c5e <copyinstr>:
 */
int copyinstr(pagetable_t pagetable, char *dst, uint64 vsrc, int maxsz) {
    uint64 n, va0, pa0 = 0;
    int got_null = 0;

    while (got_null == 0 && maxsz > 0) {
    80001c5e:	0ad05963          	blez	a3,80001d10 <copyinstr+0xb2>
int copyinstr(pagetable_t pagetable, char *dst, uint64 vsrc, int maxsz) {
    80001c62:	715d                	addi	sp,sp,-80
    80001c64:	e486                	sd	ra,72(sp)
    80001c66:	e0a2                	sd	s0,64(sp)
    80001c68:	fc26                	sd	s1,56(sp)
    80001c6a:	f84a                	sd	s2,48(sp)
    80001c6c:	f44e                	sd	s3,40(sp)
    80001c6e:	f052                	sd	s4,32(sp)
    80001c70:	ec56                	sd	s5,24(sp)
    80001c72:	e85a                	sd	s6,16(sp)
    80001c74:	e45e                	sd	s7,8(sp)
    80001c76:	0880                	addi	s0,sp,80
    80001c78:	8a2a                	mv	s4,a0
    80001c7a:	84ae                	mv	s1,a1
    80001c7c:	8bb2                	mv	s7,a2
    80001c7e:	8b36                	mv	s6,a3
        va0 = PGROUNDDOWN(vsrc);
    80001c80:	7afd                	lui	s5,0xfffff
        pa0 = walkaddr(pagetable, va0);
        if (pa0 == 0) {
            return -1;
        }
        n = PGSIZE - (vsrc - va0);
    80001c82:	6985                	lui	s3,0x1
    80001c84:	a03d                	j	80001cb2 <copyinstr+0x54>
        }
        char *p = (char *) (pa0 + (vsrc - va0));

        while (n > 0) {
            if (*p == 0) {
                *dst = 0;
    80001c86:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001c8a:	4785                	li	a5,1
            dst++;
            p++;
        }
        vsrc = va0 + PGSIZE;
    }
    if (got_null) {
    80001c8c:	0017b793          	seqz	a5,a5
    80001c90:	40f00533          	neg	a0,a5
        return 0;
    }
    return -1;
}
    80001c94:	60a6                	ld	ra,72(sp)
    80001c96:	6406                	ld	s0,64(sp)
    80001c98:	74e2                	ld	s1,56(sp)
    80001c9a:	7942                	ld	s2,48(sp)
    80001c9c:	79a2                	ld	s3,40(sp)
    80001c9e:	7a02                	ld	s4,32(sp)
    80001ca0:	6ae2                	ld	s5,24(sp)
    80001ca2:	6b42                	ld	s6,16(sp)
    80001ca4:	6ba2                	ld	s7,8(sp)
    80001ca6:	6161                	addi	sp,sp,80
    80001ca8:	8082                	ret
        vsrc = va0 + PGSIZE;
    80001caa:	01390bb3          	add	s7,s2,s3
    while (got_null == 0 && maxsz > 0) {
    80001cae:	05605d63          	blez	s6,80001d08 <copyinstr+0xaa>
        va0 = PGROUNDDOWN(vsrc);
    80001cb2:	015bf933          	and	s2,s7,s5
        pa0 = walkaddr(pagetable, va0);
    80001cb6:	85ca                	mv	a1,s2
    80001cb8:	8552                	mv	a0,s4
    80001cba:	00000097          	auipc	ra,0x0
    80001cbe:	ca2080e7          	jalr	-862(ra) # 8000195c <walkaddr>
        if (pa0 == 0) {
    80001cc2:	c529                	beqz	a0,80001d0c <copyinstr+0xae>
        n = PGSIZE - (vsrc - va0);
    80001cc4:	417907b3          	sub	a5,s2,s7
    80001cc8:	97ce                	add	a5,a5,s3
        if (n > maxsz) {
    80001cca:	885a                	mv	a6,s6
    80001ccc:	0167f363          	bgeu	a5,s6,80001cd2 <copyinstr+0x74>
    80001cd0:	883e                	mv	a6,a5
        char *p = (char *) (pa0 + (vsrc - va0));
    80001cd2:	955e                	add	a0,a0,s7
    80001cd4:	41250533          	sub	a0,a0,s2
        while (n > 0) {
    80001cd8:	fc0809e3          	beqz	a6,80001caa <copyinstr+0x4c>
    80001cdc:	9826                	add	a6,a6,s1
    80001cde:	87a6                	mv	a5,s1
            if (*p == 0) {
    80001ce0:	40950633          	sub	a2,a0,s1
    80001ce4:	009b04bb          	addw	s1,s6,s1
    80001ce8:	fff4859b          	addiw	a1,s1,-1
    80001cec:	00c78733          	add	a4,a5,a2
    80001cf0:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ff4dc18>
    80001cf4:	db49                	beqz	a4,80001c86 <copyinstr+0x28>
                *dst = *p;
    80001cf6:	00e78023          	sb	a4,0(a5)
            maxsz--;
    80001cfa:	40f58b3b          	subw	s6,a1,a5
            dst++;
    80001cfe:	0785                	addi	a5,a5,1
        while (n > 0) {
    80001d00:	ff0796e3          	bne	a5,a6,80001cec <copyinstr+0x8e>
            dst++;
    80001d04:	84c2                	mv	s1,a6
    80001d06:	b755                	j	80001caa <copyinstr+0x4c>
    80001d08:	4781                	li	a5,0
    80001d0a:	b749                	j	80001c8c <copyinstr+0x2e>
            return -1;
    80001d0c:	557d                	li	a0,-1
    80001d0e:	b759                	j	80001c94 <copyinstr+0x36>
    int got_null = 0;
    80001d10:	4781                	li	a5,0
    if (got_null) {
    80001d12:	0017b793          	seqz	a5,a5
    80001d16:	40f00533          	neg	a0,a5
}
    80001d1a:	8082                	ret

0000000080001d1c <copyout>:
 * @param len copy长度
 * @return 成功返回0，失败返回-1
 */
int copyout(pagetable_t pagetable, uint64 vdst, char *src, int len) {
    uint64 n, va0, pa0;
    while (len > 0) {
    80001d1c:	06d05863          	blez	a3,80001d8c <copyout+0x70>
int copyout(pagetable_t pagetable, uint64 vdst, char *src, int len) {
    80001d20:	715d                	addi	sp,sp,-80
    80001d22:	e486                	sd	ra,72(sp)
    80001d24:	e0a2                	sd	s0,64(sp)
    80001d26:	fc26                	sd	s1,56(sp)
    80001d28:	f84a                	sd	s2,48(sp)
    80001d2a:	f44e                	sd	s3,40(sp)
    80001d2c:	f052                	sd	s4,32(sp)
    80001d2e:	ec56                	sd	s5,24(sp)
    80001d30:	e85a                	sd	s6,16(sp)
    80001d32:	e45e                	sd	s7,8(sp)
    80001d34:	e062                	sd	s8,0(sp)
    80001d36:	0880                	addi	s0,sp,80
    80001d38:	8b2a                	mv	s6,a0
    80001d3a:	89ae                	mv	s3,a1
    80001d3c:	8ab2                	mv	s5,a2
    80001d3e:	8936                	mv	s2,a3
        va0 = PGROUNDDOWN(vdst);
    80001d40:	7bfd                	lui	s7,0xfffff
        pa0 = walkaddr(pagetable, va0);
        if (pa0 == 0) {
            return -1;
        }
        n = PGSIZE - (vdst - va0);
    80001d42:	6c05                	lui	s8,0x1
    80001d44:	a00d                	j	80001d66 <copyout+0x4a>
        if (n > len) {
            n = len;
        }
        memmove((void *) (pa0 + (vdst - va0)), src, n);
    80001d46:	954e                	add	a0,a0,s3
    80001d48:	0004861b          	sext.w	a2,s1
    80001d4c:	85d6                	mv	a1,s5
    80001d4e:	41450533          	sub	a0,a0,s4
    80001d52:	fffff097          	auipc	ra,0xfffff
    80001d56:	3c6080e7          	jalr	966(ra) # 80001118 <memmove>
        len -= n;
    80001d5a:	4099093b          	subw	s2,s2,s1
        vdst += n;
    80001d5e:	99a6                	add	s3,s3,s1
        src += n;
    80001d60:	9aa6                	add	s5,s5,s1
    while (len > 0) {
    80001d62:	03205363          	blez	s2,80001d88 <copyout+0x6c>
        va0 = PGROUNDDOWN(vdst);
    80001d66:	0179fa33          	and	s4,s3,s7
        pa0 = walkaddr(pagetable, va0);
    80001d6a:	85d2                	mv	a1,s4
    80001d6c:	855a                	mv	a0,s6
    80001d6e:	00000097          	auipc	ra,0x0
    80001d72:	bee080e7          	jalr	-1042(ra) # 8000195c <walkaddr>
        if (pa0 == 0) {
    80001d76:	cd09                	beqz	a0,80001d90 <copyout+0x74>
        n = PGSIZE - (vdst - va0);
    80001d78:	413a07b3          	sub	a5,s4,s3
    80001d7c:	97e2                	add	a5,a5,s8
        if (n > len) {
    80001d7e:	84ca                	mv	s1,s2
    80001d80:	fd27f3e3          	bgeu	a5,s2,80001d46 <copyout+0x2a>
    80001d84:	84be                	mv	s1,a5
    80001d86:	b7c1                	j	80001d46 <copyout+0x2a>
    }
    return 0;
    80001d88:	4501                	li	a0,0
    80001d8a:	a021                	j	80001d92 <copyout+0x76>
    80001d8c:	4501                	li	a0,0
}
    80001d8e:	8082                	ret
            return -1;
    80001d90:	557d                	li	a0,-1
}
    80001d92:	60a6                	ld	ra,72(sp)
    80001d94:	6406                	ld	s0,64(sp)
    80001d96:	74e2                	ld	s1,56(sp)
    80001d98:	7942                	ld	s2,48(sp)
    80001d9a:	79a2                	ld	s3,40(sp)
    80001d9c:	7a02                	ld	s4,32(sp)
    80001d9e:	6ae2                	ld	s5,24(sp)
    80001da0:	6b42                	ld	s6,16(sp)
    80001da2:	6ba2                	ld	s7,8(sp)
    80001da4:	6c02                	ld	s8,0(sp)
    80001da6:	6161                	addi	sp,sp,80
    80001da8:	8082                	ret

0000000080001daa <user_vm_copy>:
int user_vm_copy(pagetable_t old, pagetable_t new, int sz) {
    pte_t *pte;
    uint64 pa;
    uint flags;
    char *mem;
    for (int i = 0; i < sz; i += PGSIZE) {
    80001daa:	10c05663          	blez	a2,80001eb6 <user_vm_copy+0x10c>
int user_vm_copy(pagetable_t old, pagetable_t new, int sz) {
    80001dae:	7159                	addi	sp,sp,-112
    80001db0:	f486                	sd	ra,104(sp)
    80001db2:	f0a2                	sd	s0,96(sp)
    80001db4:	eca6                	sd	s1,88(sp)
    80001db6:	e8ca                	sd	s2,80(sp)
    80001db8:	e4ce                	sd	s3,72(sp)
    80001dba:	e0d2                	sd	s4,64(sp)
    80001dbc:	fc56                	sd	s5,56(sp)
    80001dbe:	f85a                	sd	s6,48(sp)
    80001dc0:	f45e                	sd	s7,40(sp)
    80001dc2:	f062                	sd	s8,32(sp)
    80001dc4:	ec66                	sd	s9,24(sp)
    80001dc6:	e86a                	sd	s10,16(sp)
    80001dc8:	e46e                	sd	s11,8(sp)
    80001dca:	1880                	addi	s0,sp,112
    80001dcc:	8a2a                	mv	s4,a0
    80001dce:	8aae                	mv	s5,a1
    80001dd0:	fff6099b          	addiw	s3,a2,-1
    80001dd4:	00c9d99b          	srliw	s3,s3,0xc
    80001dd8:	0985                	addi	s3,s3,1
    80001dda:	09b2                	slli	s3,s3,0xc
    for (int i = 0; i < sz; i += PGSIZE) {
    80001ddc:	4901                	li	s2,0
        if ((pte = walk(old, i, 0)) == 0) {
            panic("user_vm_copy: pte not present");
    80001dde:	00004c97          	auipc	s9,0x4
    80001de2:	382c8c93          	addi	s9,s9,898 # 80006160 <digits+0x60>
        }
        if ((*pte & PTE_V) == 0) {
            panic("user_vm_copy: pte invalid");
    80001de6:	00004b17          	auipc	s6,0x4
    80001dea:	39ab0b13          	addi	s6,s6,922 # 80006180 <digits+0x80>
        }
        pa = PTE2PA(*pte);
        flags = PTE_FLAGS(*pte);

        if ((mem = kalloc()) == 0) {
            panic("user_vm_copy: alloc mem fail");
    80001dee:	00004c17          	auipc	s8,0x4
    80001df2:	3b2c0c13          	addi	s8,s8,946 # 800061a0 <digits+0xa0>
        }
        memmove(mem, (void *) pa, PGSIZE);
        if (mappages(new, i, PGSIZE, (uint64) mem, flags) < 0) {
            kfree(mem);
            panic("user_vm_copy: mappages fail");
    80001df6:	00004b97          	auipc	s7,0x4
    80001dfa:	3cab8b93          	addi	s7,s7,970 # 800061c0 <digits+0xc0>
    80001dfe:	a8b1                	j	80001e5a <user_vm_copy+0xb0>
            panic("user_vm_copy: pte not present");
    80001e00:	8566                	mv	a0,s9
    80001e02:	00000097          	auipc	ra,0x0
    80001e06:	874080e7          	jalr	-1932(ra) # 80001676 <panic>
    80001e0a:	a08d                	j	80001e6c <user_vm_copy+0xc2>
            panic("user_vm_copy: pte invalid");
    80001e0c:	855a                	mv	a0,s6
    80001e0e:	00000097          	auipc	ra,0x0
    80001e12:	868080e7          	jalr	-1944(ra) # 80001676 <panic>
        pa = PTE2PA(*pte);
    80001e16:	6098                	ld	a4,0(s1)
    80001e18:	00a75d13          	srli	s10,a4,0xa
    80001e1c:	0d32                	slli	s10,s10,0xc
        flags = PTE_FLAGS(*pte);
    80001e1e:	3ff77d93          	andi	s11,a4,1023
        if ((mem = kalloc()) == 0) {
    80001e22:	00000097          	auipc	ra,0x0
    80001e26:	96e080e7          	jalr	-1682(ra) # 80001790 <kalloc>
    80001e2a:	84aa                	mv	s1,a0
    80001e2c:	c521                	beqz	a0,80001e74 <user_vm_copy+0xca>
        memmove(mem, (void *) pa, PGSIZE);
    80001e2e:	6605                	lui	a2,0x1
    80001e30:	85ea                	mv	a1,s10
    80001e32:	8526                	mv	a0,s1
    80001e34:	fffff097          	auipc	ra,0xfffff
    80001e38:	2e4080e7          	jalr	740(ra) # 80001118 <memmove>
        if (mappages(new, i, PGSIZE, (uint64) mem, flags) < 0) {
    80001e3c:	876e                	mv	a4,s11
    80001e3e:	86a6                	mv	a3,s1
    80001e40:	6605                	lui	a2,0x1
    80001e42:	85ca                	mv	a1,s2
    80001e44:	8556                	mv	a0,s5
    80001e46:	00000097          	auipc	ra,0x0
    80001e4a:	a78080e7          	jalr	-1416(ra) # 800018be <mappages>
    80001e4e:	02054963          	bltz	a0,80001e80 <user_vm_copy+0xd6>
    for (int i = 0; i < sz; i += PGSIZE) {
    80001e52:	6785                	lui	a5,0x1
    80001e54:	993e                	add	s2,s2,a5
    80001e56:	05390063          	beq	s2,s3,80001e96 <user_vm_copy+0xec>
        if ((pte = walk(old, i, 0)) == 0) {
    80001e5a:	4601                	li	a2,0
    80001e5c:	85ca                	mv	a1,s2
    80001e5e:	8552                	mv	a0,s4
    80001e60:	00000097          	auipc	ra,0x0
    80001e64:	9b4080e7          	jalr	-1612(ra) # 80001814 <walk>
    80001e68:	84aa                	mv	s1,a0
    80001e6a:	d959                	beqz	a0,80001e00 <user_vm_copy+0x56>
        if ((*pte & PTE_V) == 0) {
    80001e6c:	609c                	ld	a5,0(s1)
    80001e6e:	8b85                	andi	a5,a5,1
    80001e70:	f3dd                	bnez	a5,80001e16 <user_vm_copy+0x6c>
    80001e72:	bf69                	j	80001e0c <user_vm_copy+0x62>
            panic("user_vm_copy: alloc mem fail");
    80001e74:	8562                	mv	a0,s8
    80001e76:	00000097          	auipc	ra,0x0
    80001e7a:	800080e7          	jalr	-2048(ra) # 80001676 <panic>
    80001e7e:	bf45                	j	80001e2e <user_vm_copy+0x84>
            kfree(mem);
    80001e80:	8526                	mv	a0,s1
    80001e82:	00000097          	auipc	ra,0x0
    80001e86:	810080e7          	jalr	-2032(ra) # 80001692 <kfree>
            panic("user_vm_copy: mappages fail");
    80001e8a:	855e                	mv	a0,s7
    80001e8c:	fffff097          	auipc	ra,0xfffff
    80001e90:	7ea080e7          	jalr	2026(ra) # 80001676 <panic>
    80001e94:	bf7d                	j	80001e52 <user_vm_copy+0xa8>
        }
    }
    return 0;
}
    80001e96:	4501                	li	a0,0
    80001e98:	70a6                	ld	ra,104(sp)
    80001e9a:	7406                	ld	s0,96(sp)
    80001e9c:	64e6                	ld	s1,88(sp)
    80001e9e:	6946                	ld	s2,80(sp)
    80001ea0:	69a6                	ld	s3,72(sp)
    80001ea2:	6a06                	ld	s4,64(sp)
    80001ea4:	7ae2                	ld	s5,56(sp)
    80001ea6:	7b42                	ld	s6,48(sp)
    80001ea8:	7ba2                	ld	s7,40(sp)
    80001eaa:	7c02                	ld	s8,32(sp)
    80001eac:	6ce2                	ld	s9,24(sp)
    80001eae:	6d42                	ld	s10,16(sp)
    80001eb0:	6da2                	ld	s11,8(sp)
    80001eb2:	6165                	addi	sp,sp,112
    80001eb4:	8082                	ret
    80001eb6:	4501                	li	a0,0
    80001eb8:	8082                	ret

0000000080001eba <vmprint>:

void vmprint(pagetable_t pagetable, int n) {
    80001eba:	711d                	addi	sp,sp,-96
    80001ebc:	ec86                	sd	ra,88(sp)
    80001ebe:	e8a2                	sd	s0,80(sp)
    80001ec0:	e4a6                	sd	s1,72(sp)
    80001ec2:	e0ca                	sd	s2,64(sp)
    80001ec4:	fc4e                	sd	s3,56(sp)
    80001ec6:	f852                	sd	s4,48(sp)
    80001ec8:	f456                	sd	s5,40(sp)
    80001eca:	f05a                	sd	s6,32(sp)
    80001ecc:	ec5e                	sd	s7,24(sp)
    80001ece:	e862                	sd	s8,16(sp)
    80001ed0:	e466                	sd	s9,8(sp)
    80001ed2:	e06a                	sd	s10,0(sp)
    80001ed4:	1080                	addi	s0,sp,96
    80001ed6:	892a                	mv	s2,a0
    80001ed8:	8c2e                	mv	s8,a1
    if (n == 1) {
    80001eda:	4785                	li	a5,1
    80001edc:	02f58463          	beq	a1,a5,80001f04 <vmprint+0x4a>
        printf("page table %p\n", pagetable);
    }
    if (n >= 4) {
    80001ee0:	478d                	li	a5,3
    80001ee2:	08b7c163          	blt	a5,a1,80001f64 <vmprint+0xaa>
        return;
    }
    for (int i = 0; i < 512; i++) {
    80001ee6:	4481                	li	s1,0
        if (pte & PTE_V) {
            for (int j = 1; j <= n; j++) {
                printf(".. ");
            }
            uint64 child = PTE2PA(pte);
            printf("%d: pte %p pa %p\n", i, pte, child);
    80001ee8:	00004c97          	auipc	s9,0x4
    80001eec:	310c8c93          	addi	s9,s9,784 # 800061f8 <digits+0xf8>
            vmprint((pagetable_t) child, n + 1);
    80001ef0:	001c0a9b          	addiw	s5,s8,1
            for (int j = 1; j <= n; j++) {
    80001ef4:	4d05                	li	s10,1
                printf(".. ");
    80001ef6:	00004b97          	auipc	s7,0x4
    80001efa:	2fab8b93          	addi	s7,s7,762 # 800061f0 <digits+0xf0>
    for (int i = 0; i < 512; i++) {
    80001efe:	20000b13          	li	s6,512
    80001f02:	a081                	j	80001f42 <vmprint+0x88>
        printf("page table %p\n", pagetable);
    80001f04:	85aa                	mv	a1,a0
    80001f06:	00004517          	auipc	a0,0x4
    80001f0a:	2da50513          	addi	a0,a0,730 # 800061e0 <digits+0xe0>
    80001f0e:	fffff097          	auipc	ra,0xfffff
    80001f12:	6a4080e7          	jalr	1700(ra) # 800015b2 <printf>
    if (n >= 4) {
    80001f16:	bfc1                	j	80001ee6 <vmprint+0x2c>
            uint64 child = PTE2PA(pte);
    80001f18:	00aa5993          	srli	s3,s4,0xa
    80001f1c:	09b2                	slli	s3,s3,0xc
            printf("%d: pte %p pa %p\n", i, pte, child);
    80001f1e:	86ce                	mv	a3,s3
    80001f20:	8652                	mv	a2,s4
    80001f22:	85a6                	mv	a1,s1
    80001f24:	8566                	mv	a0,s9
    80001f26:	fffff097          	auipc	ra,0xfffff
    80001f2a:	68c080e7          	jalr	1676(ra) # 800015b2 <printf>
            vmprint((pagetable_t) child, n + 1);
    80001f2e:	85d6                	mv	a1,s5
    80001f30:	854e                	mv	a0,s3
    80001f32:	00000097          	auipc	ra,0x0
    80001f36:	f88080e7          	jalr	-120(ra) # 80001eba <vmprint>
    for (int i = 0; i < 512; i++) {
    80001f3a:	2485                	addiw	s1,s1,1
    80001f3c:	0921                	addi	s2,s2,8
    80001f3e:	03648363          	beq	s1,s6,80001f64 <vmprint+0xaa>
        pte_t pte = pagetable[i];
    80001f42:	00093a03          	ld	s4,0(s2) # 1000 <_entry-0x7ffff000>
        if (pte & PTE_V) {
    80001f46:	001a7793          	andi	a5,s4,1
    80001f4a:	dbe5                	beqz	a5,80001f3a <vmprint+0x80>
            for (int j = 1; j <= n; j++) {
    80001f4c:	fd8056e3          	blez	s8,80001f18 <vmprint+0x5e>
    80001f50:	89ea                	mv	s3,s10
                printf(".. ");
    80001f52:	855e                	mv	a0,s7
    80001f54:	fffff097          	auipc	ra,0xfffff
    80001f58:	65e080e7          	jalr	1630(ra) # 800015b2 <printf>
            for (int j = 1; j <= n; j++) {
    80001f5c:	2985                	addiw	s3,s3,1
    80001f5e:	ff3a9ae3          	bne	s5,s3,80001f52 <vmprint+0x98>
    80001f62:	bf5d                	j	80001f18 <vmprint+0x5e>
        }
    }
    80001f64:	60e6                	ld	ra,88(sp)
    80001f66:	6446                	ld	s0,80(sp)
    80001f68:	64a6                	ld	s1,72(sp)
    80001f6a:	6906                	ld	s2,64(sp)
    80001f6c:	79e2                	ld	s3,56(sp)
    80001f6e:	7a42                	ld	s4,48(sp)
    80001f70:	7aa2                	ld	s5,40(sp)
    80001f72:	7b02                	ld	s6,32(sp)
    80001f74:	6be2                	ld	s7,24(sp)
    80001f76:	6c42                	ld	s8,16(sp)
    80001f78:	6ca2                	ld	s9,8(sp)
    80001f7a:	6d02                	ld	s10,0(sp)
    80001f7c:	6125                	addi	sp,sp,96
    80001f7e:	8082                	ret

0000000080001f80 <free_desc>:
    return -1;
}

// mark a descriptor as free.
static void
free_desc(int i) {
    80001f80:	1101                	addi	sp,sp,-32
    80001f82:	ec06                	sd	ra,24(sp)
    80001f84:	e822                	sd	s0,16(sp)
    80001f86:	e426                	sd	s1,8(sp)
    80001f88:	1000                	addi	s0,sp,32
    80001f8a:	84aa                	mv	s1,a0
    if (i >= NUM)
    80001f8c:	479d                	li	a5,7
    80001f8e:	06a7ca63          	blt	a5,a0,80002002 <free_desc+0x82>
        panic("free_desc 1");
    if (disk.free[i])
    80001f92:	0008e797          	auipc	a5,0x8e
    80001f96:	06e78793          	addi	a5,a5,110 # 80090000 <disk>
    80001f9a:	00978733          	add	a4,a5,s1
    80001f9e:	6789                	lui	a5,0x2
    80001fa0:	97ba                	add	a5,a5,a4
    80001fa2:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80001fa6:	e7bd                	bnez	a5,80002014 <free_desc+0x94>
        panic("free_desc 2");
    disk.desc[i].addr = 0;
    80001fa8:	00449793          	slli	a5,s1,0x4
    80001fac:	00090717          	auipc	a4,0x90
    80001fb0:	05470713          	addi	a4,a4,84 # 80092000 <disk+0x2000>
    80001fb4:	6314                	ld	a3,0(a4)
    80001fb6:	96be                	add	a3,a3,a5
    80001fb8:	0006b023          	sd	zero,0(a3)
    disk.desc[i].len = 0;
    80001fbc:	6314                	ld	a3,0(a4)
    80001fbe:	96be                	add	a3,a3,a5
    80001fc0:	0006a423          	sw	zero,8(a3)
    disk.desc[i].flags = 0;
    80001fc4:	6314                	ld	a3,0(a4)
    80001fc6:	96be                	add	a3,a3,a5
    80001fc8:	00069623          	sh	zero,12(a3)
    disk.desc[i].next = 0;
    80001fcc:	6318                	ld	a4,0(a4)
    80001fce:	97ba                	add	a5,a5,a4
    80001fd0:	00079723          	sh	zero,14(a5)
    disk.free[i] = 1;
    80001fd4:	0008e517          	auipc	a0,0x8e
    80001fd8:	02c50513          	addi	a0,a0,44 # 80090000 <disk>
    80001fdc:	9526                	add	a0,a0,s1
    80001fde:	6489                	lui	s1,0x2
    80001fe0:	94aa                	add	s1,s1,a0
    80001fe2:	4785                	li	a5,1
    80001fe4:	00f48c23          	sb	a5,24(s1) # 2018 <_entry-0x7fffdfe8>
    wakeup(&disk.free[0]);
    80001fe8:	00090517          	auipc	a0,0x90
    80001fec:	03050513          	addi	a0,a0,48 # 80092018 <disk+0x2018>
    80001ff0:	fffff097          	auipc	ra,0xfffff
    80001ff4:	bbe080e7          	jalr	-1090(ra) # 80000bae <wakeup>
}
    80001ff8:	60e2                	ld	ra,24(sp)
    80001ffa:	6442                	ld	s0,16(sp)
    80001ffc:	64a2                	ld	s1,8(sp)
    80001ffe:	6105                	addi	sp,sp,32
    80002000:	8082                	ret
        panic("free_desc 1");
    80002002:	00004517          	auipc	a0,0x4
    80002006:	20e50513          	addi	a0,a0,526 # 80006210 <digits+0x110>
    8000200a:	fffff097          	auipc	ra,0xfffff
    8000200e:	66c080e7          	jalr	1644(ra) # 80001676 <panic>
    80002012:	b741                	j	80001f92 <free_desc+0x12>
        panic("free_desc 2");
    80002014:	00004517          	auipc	a0,0x4
    80002018:	20c50513          	addi	a0,a0,524 # 80006220 <digits+0x120>
    8000201c:	fffff097          	auipc	ra,0xfffff
    80002020:	65a080e7          	jalr	1626(ra) # 80001676 <panic>
    80002024:	b751                	j	80001fa8 <free_desc+0x28>

0000000080002026 <virtio_disk_init>:
virtio_disk_init(void) {
    80002026:	1101                	addi	sp,sp,-32
    80002028:	ec06                	sd	ra,24(sp)
    8000202a:	e822                	sd	s0,16(sp)
    8000202c:	e426                	sd	s1,8(sp)
    8000202e:	1000                	addi	s0,sp,32
    spinlock_init(&disk.vdisk_lock, "virtio_disk");
    80002030:	00004597          	auipc	a1,0x4
    80002034:	20058593          	addi	a1,a1,512 # 80006230 <digits+0x130>
    80002038:	00090517          	auipc	a0,0x90
    8000203c:	0f050513          	addi	a0,a0,240 # 80092128 <disk+0x2128>
    80002040:	00002097          	auipc	ra,0x2
    80002044:	aae080e7          	jalr	-1362(ra) # 80003aee <spinlock_init>
    if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80002048:	100017b7          	lui	a5,0x10001
    8000204c:	4398                	lw	a4,0(a5)
    8000204e:	2701                	sext.w	a4,a4
    80002050:	747277b7          	lui	a5,0x74727
    80002054:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80002058:	00f71963          	bne	a4,a5,8000206a <virtio_disk_init+0x44>
        *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000205c:	100017b7          	lui	a5,0x10001
    80002060:	43dc                	lw	a5,4(a5)
    80002062:	2781                	sext.w	a5,a5
    if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80002064:	4705                	li	a4,1
    80002066:	0ce78163          	beq	a5,a4,80002128 <virtio_disk_init+0x102>
        panic("could not find virtio disk");
    8000206a:	00004517          	auipc	a0,0x4
    8000206e:	1d650513          	addi	a0,a0,470 # 80006240 <digits+0x140>
    80002072:	fffff097          	auipc	ra,0xfffff
    80002076:	604080e7          	jalr	1540(ra) # 80001676 <panic>
    *R(VIRTIO_MMIO_STATUS) = status;
    8000207a:	100017b7          	lui	a5,0x10001
    8000207e:	4705                	li	a4,1
    80002080:	dbb8                	sw	a4,112(a5)
    *R(VIRTIO_MMIO_STATUS) = status;
    80002082:	470d                	li	a4,3
    80002084:	dbb8                	sw	a4,112(a5)
    uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80002086:	4b94                	lw	a3,16(a5)
    features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80002088:	c7ffe737          	lui	a4,0xc7ffe
    8000208c:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47f4d377>
    80002090:	8f75                	and	a4,a4,a3
    *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80002092:	2701                	sext.w	a4,a4
    80002094:	d398                	sw	a4,32(a5)
    *R(VIRTIO_MMIO_STATUS) = status;
    80002096:	472d                	li	a4,11
    80002098:	dbb8                	sw	a4,112(a5)
    *R(VIRTIO_MMIO_STATUS) = status;
    8000209a:	473d                	li	a4,15
    8000209c:	dbb8                	sw	a4,112(a5)
    *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000209e:	6705                	lui	a4,0x1
    800020a0:	d798                	sw	a4,40(a5)
    *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800020a2:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
    uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800020a6:	5bdc                	lw	a5,52(a5)
    800020a8:	2781                	sext.w	a5,a5
    if (max == 0)
    800020aa:	c3cd                	beqz	a5,8000214c <virtio_disk_init+0x126>
    if (max < NUM)
    800020ac:	471d                	li	a4,7
    800020ae:	0af77763          	bgeu	a4,a5,8000215c <virtio_disk_init+0x136>
    *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800020b2:	100014b7          	lui	s1,0x10001
    800020b6:	47a1                	li	a5,8
    800020b8:	dc9c                	sw	a5,56(s1)
    memset(disk.pages, 0, sizeof(disk.pages));
    800020ba:	6609                	lui	a2,0x2
    800020bc:	4581                	li	a1,0
    800020be:	0008e517          	auipc	a0,0x8e
    800020c2:	f4250513          	addi	a0,a0,-190 # 80090000 <disk>
    800020c6:	fffff097          	auipc	ra,0xfffff
    800020ca:	02c080e7          	jalr	44(ra) # 800010f2 <memset>
    *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64) disk.pages) >> PGSHIFT;
    800020ce:	0008e717          	auipc	a4,0x8e
    800020d2:	f3270713          	addi	a4,a4,-206 # 80090000 <disk>
    800020d6:	00c75793          	srli	a5,a4,0xc
    800020da:	2781                	sext.w	a5,a5
    800020dc:	c0bc                	sw	a5,64(s1)
    disk.desc = (struct virtq_desc *) disk.pages;
    800020de:	00090797          	auipc	a5,0x90
    800020e2:	f2278793          	addi	a5,a5,-222 # 80092000 <disk+0x2000>
    800020e6:	e398                	sd	a4,0(a5)
    disk.avail = (struct virtq_avail *) (disk.pages + NUM * sizeof(struct virtq_desc));
    800020e8:	0008e717          	auipc	a4,0x8e
    800020ec:	f9870713          	addi	a4,a4,-104 # 80090080 <disk+0x80>
    800020f0:	e798                	sd	a4,8(a5)
    disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800020f2:	0008f717          	auipc	a4,0x8f
    800020f6:	f0e70713          	addi	a4,a4,-242 # 80091000 <disk+0x1000>
    800020fa:	eb98                	sd	a4,16(a5)
        disk.free[i] = 1;
    800020fc:	4705                	li	a4,1
    800020fe:	00e78c23          	sb	a4,24(a5)
    80002102:	00e78ca3          	sb	a4,25(a5)
    80002106:	00e78d23          	sb	a4,26(a5)
    8000210a:	00e78da3          	sb	a4,27(a5)
    8000210e:	00e78e23          	sb	a4,28(a5)
    80002112:	00e78ea3          	sb	a4,29(a5)
    80002116:	00e78f23          	sb	a4,30(a5)
    8000211a:	00e78fa3          	sb	a4,31(a5)
}
    8000211e:	60e2                	ld	ra,24(sp)
    80002120:	6442                	ld	s0,16(sp)
    80002122:	64a2                	ld	s1,8(sp)
    80002124:	6105                	addi	sp,sp,32
    80002126:	8082                	ret
        *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80002128:	100017b7          	lui	a5,0x10001
    8000212c:	479c                	lw	a5,8(a5)
    8000212e:	2781                	sext.w	a5,a5
        *R(VIRTIO_MMIO_VERSION) != 1 ||
    80002130:	4709                	li	a4,2
    80002132:	f2e79ce3          	bne	a5,a4,8000206a <virtio_disk_init+0x44>
        *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    80002136:	100017b7          	lui	a5,0x10001
    8000213a:	47d8                	lw	a4,12(a5)
    8000213c:	2701                	sext.w	a4,a4
        *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000213e:	554d47b7          	lui	a5,0x554d4
    80002142:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80002146:	f2f712e3          	bne	a4,a5,8000206a <virtio_disk_init+0x44>
    8000214a:	bf05                	j	8000207a <virtio_disk_init+0x54>
        panic("virtio disk has no queue 0");
    8000214c:	00004517          	auipc	a0,0x4
    80002150:	11450513          	addi	a0,a0,276 # 80006260 <digits+0x160>
    80002154:	fffff097          	auipc	ra,0xfffff
    80002158:	522080e7          	jalr	1314(ra) # 80001676 <panic>
        panic("virtio disk max queue too short");
    8000215c:	00004517          	auipc	a0,0x4
    80002160:	12450513          	addi	a0,a0,292 # 80006280 <digits+0x180>
    80002164:	fffff097          	auipc	ra,0xfffff
    80002168:	512080e7          	jalr	1298(ra) # 80001676 <panic>
    8000216c:	b799                	j	800020b2 <virtio_disk_init+0x8c>

000000008000216e <virtio_disk_rw>:
    }
    return 0;
}

void
virtio_disk_rw(struct buf *b, int write) {
    8000216e:	7159                	addi	sp,sp,-112
    80002170:	f486                	sd	ra,104(sp)
    80002172:	f0a2                	sd	s0,96(sp)
    80002174:	eca6                	sd	s1,88(sp)
    80002176:	e8ca                	sd	s2,80(sp)
    80002178:	e4ce                	sd	s3,72(sp)
    8000217a:	e0d2                	sd	s4,64(sp)
    8000217c:	fc56                	sd	s5,56(sp)
    8000217e:	f85a                	sd	s6,48(sp)
    80002180:	f45e                	sd	s7,40(sp)
    80002182:	f062                	sd	s8,32(sp)
    80002184:	ec66                	sd	s9,24(sp)
    80002186:	e86a                	sd	s10,16(sp)
    80002188:	1880                	addi	s0,sp,112
    8000218a:	892a                	mv	s2,a0
    8000218c:	8d2e                	mv	s10,a1
    uint64 sector = b->blockno * (BSIZE / 512);
    8000218e:	00c52c83          	lw	s9,12(a0)
    80002192:	001c9c9b          	slliw	s9,s9,0x1
    80002196:	1c82                	slli	s9,s9,0x20
    80002198:	020cdc93          	srli	s9,s9,0x20
    spin_lock(&disk.vdisk_lock);
    8000219c:	00090517          	auipc	a0,0x90
    800021a0:	f8c50513          	addi	a0,a0,-116 # 80092128 <disk+0x2128>
    800021a4:	00002097          	auipc	ra,0x2
    800021a8:	9da080e7          	jalr	-1574(ra) # 80003b7e <spin_lock>
    for (int i = 0; i < 3; i++) {
    800021ac:	4981                	li	s3,0
    for (int i = 0; i < NUM; i++) {
    800021ae:	4c21                	li	s8,8
            disk.free[i] = 0;
    800021b0:	0008eb97          	auipc	s7,0x8e
    800021b4:	e50b8b93          	addi	s7,s7,-432 # 80090000 <disk>
    800021b8:	6b09                	lui	s6,0x2
    for (int i = 0; i < 3; i++) {
    800021ba:	4a8d                	li	s5,3
    for (int i = 0; i < NUM; i++) {
    800021bc:	8a4e                	mv	s4,s3
    800021be:	a051                	j	80002242 <virtio_disk_rw+0xd4>
            disk.free[i] = 0;
    800021c0:	00fb86b3          	add	a3,s7,a5
    800021c4:	96da                	add	a3,a3,s6
    800021c6:	00068c23          	sb	zero,24(a3)
        idx[i] = alloc_desc();
    800021ca:	c21c                	sw	a5,0(a2)
        if (idx[i] < 0) {
    800021cc:	0207c563          	bltz	a5,800021f6 <virtio_disk_rw+0x88>
    for (int i = 0; i < 3; i++) {
    800021d0:	2485                	addiw	s1,s1,1
    800021d2:	0711                	addi	a4,a4,4
    800021d4:	25548063          	beq	s1,s5,80002414 <virtio_disk_rw+0x2a6>
        idx[i] = alloc_desc();
    800021d8:	863a                	mv	a2,a4
    for (int i = 0; i < NUM; i++) {
    800021da:	00090697          	auipc	a3,0x90
    800021de:	e3e68693          	addi	a3,a3,-450 # 80092018 <disk+0x2018>
    800021e2:	87d2                	mv	a5,s4
        if (disk.free[i]) {
    800021e4:	0006c583          	lbu	a1,0(a3)
    800021e8:	fde1                	bnez	a1,800021c0 <virtio_disk_rw+0x52>
    for (int i = 0; i < NUM; i++) {
    800021ea:	2785                	addiw	a5,a5,1
    800021ec:	0685                	addi	a3,a3,1
    800021ee:	ff879be3          	bne	a5,s8,800021e4 <virtio_disk_rw+0x76>
        idx[i] = alloc_desc();
    800021f2:	57fd                	li	a5,-1
    800021f4:	c21c                	sw	a5,0(a2)
            for (int j = 0; j < i; j++)
    800021f6:	02905a63          	blez	s1,8000222a <virtio_disk_rw+0xbc>
                free_desc(idx[j]);
    800021fa:	f9042503          	lw	a0,-112(s0)
    800021fe:	00000097          	auipc	ra,0x0
    80002202:	d82080e7          	jalr	-638(ra) # 80001f80 <free_desc>
            for (int j = 0; j < i; j++)
    80002206:	4785                	li	a5,1
    80002208:	0297d163          	bge	a5,s1,8000222a <virtio_disk_rw+0xbc>
                free_desc(idx[j]);
    8000220c:	f9442503          	lw	a0,-108(s0)
    80002210:	00000097          	auipc	ra,0x0
    80002214:	d70080e7          	jalr	-656(ra) # 80001f80 <free_desc>
            for (int j = 0; j < i; j++)
    80002218:	4789                	li	a5,2
    8000221a:	0097d863          	bge	a5,s1,8000222a <virtio_disk_rw+0xbc>
                free_desc(idx[j]);
    8000221e:	f9842503          	lw	a0,-104(s0)
    80002222:	00000097          	auipc	ra,0x0
    80002226:	d5e080e7          	jalr	-674(ra) # 80001f80 <free_desc>
    int idx[3];
    while (1) {
        if (alloc3_desc(idx) == 0) {
            break;
        }
        sleep(&disk.free[0], &disk.vdisk_lock);
    8000222a:	00090597          	auipc	a1,0x90
    8000222e:	efe58593          	addi	a1,a1,-258 # 80092128 <disk+0x2128>
    80002232:	00090517          	auipc	a0,0x90
    80002236:	de650513          	addi	a0,a0,-538 # 80092018 <disk+0x2018>
    8000223a:	fffff097          	auipc	ra,0xfffff
    8000223e:	878080e7          	jalr	-1928(ra) # 80000ab2 <sleep>
    for (int i = 0; i < 3; i++) {
    80002242:	f9040713          	addi	a4,s0,-112
    80002246:	84ce                	mv	s1,s3
    80002248:	bf41                	j	800021d8 <virtio_disk_rw+0x6a>
    // format the three descriptors.
    // qemu's virtio-blk.c reads them.
    struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

    if (write)
        buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    8000224a:	20058713          	addi	a4,a1,512
    8000224e:	00471693          	slli	a3,a4,0x4
    80002252:	0008e717          	auipc	a4,0x8e
    80002256:	dae70713          	addi	a4,a4,-594 # 80090000 <disk>
    8000225a:	9736                	add	a4,a4,a3
    8000225c:	4685                	li	a3,1
    8000225e:	0ad72423          	sw	a3,168(a4)
    else
        buf0->type = VIRTIO_BLK_T_IN; // read the disk
    buf0->reserved = 0;
    80002262:	20058713          	addi	a4,a1,512
    80002266:	00471693          	slli	a3,a4,0x4
    8000226a:	0008e717          	auipc	a4,0x8e
    8000226e:	d9670713          	addi	a4,a4,-618 # 80090000 <disk>
    80002272:	9736                	add	a4,a4,a3
    80002274:	0a072623          	sw	zero,172(a4)
    buf0->sector = sector;
    80002278:	0b973823          	sd	s9,176(a4)

    disk.desc[idx[0]].addr = (uint64) buf0;
    8000227c:	7679                	lui	a2,0xffffe
    8000227e:	963e                	add	a2,a2,a5
    80002280:	00090697          	auipc	a3,0x90
    80002284:	d8068693          	addi	a3,a3,-640 # 80092000 <disk+0x2000>
    80002288:	6298                	ld	a4,0(a3)
    8000228a:	9732                	add	a4,a4,a2
    8000228c:	e308                	sd	a0,0(a4)
    disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000228e:	6298                	ld	a4,0(a3)
    80002290:	9732                	add	a4,a4,a2
    80002292:	4541                	li	a0,16
    80002294:	c708                	sw	a0,8(a4)
    disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80002296:	6298                	ld	a4,0(a3)
    80002298:	9732                	add	a4,a4,a2
    8000229a:	4505                	li	a0,1
    8000229c:	00a71623          	sh	a0,12(a4)
    disk.desc[idx[0]].next = idx[1];
    800022a0:	f9442703          	lw	a4,-108(s0)
    800022a4:	6288                	ld	a0,0(a3)
    800022a6:	962a                	add	a2,a2,a0
    800022a8:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ff4cc26>

    disk.desc[idx[1]].addr = (uint64) b->data;
    800022ac:	0712                	slli	a4,a4,0x4
    800022ae:	6290                	ld	a2,0(a3)
    800022b0:	963a                	add	a2,a2,a4
    800022b2:	04c90513          	addi	a0,s2,76
    800022b6:	e208                	sd	a0,0(a2)
    disk.desc[idx[1]].len = BSIZE;
    800022b8:	6294                	ld	a3,0(a3)
    800022ba:	96ba                	add	a3,a3,a4
    800022bc:	40000613          	li	a2,1024
    800022c0:	c690                	sw	a2,8(a3)
    if (write)
    800022c2:	140d0063          	beqz	s10,80002402 <virtio_disk_rw+0x294>
        disk.desc[idx[1]].flags = 0; // device reads b->data
    800022c6:	00090697          	auipc	a3,0x90
    800022ca:	d3a6b683          	ld	a3,-710(a3) # 80092000 <disk+0x2000>
    800022ce:	96ba                	add	a3,a3,a4
    800022d0:	00069623          	sh	zero,12(a3)
    else
        disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800022d4:	0008e817          	auipc	a6,0x8e
    800022d8:	d2c80813          	addi	a6,a6,-724 # 80090000 <disk>
    800022dc:	00090517          	auipc	a0,0x90
    800022e0:	d2450513          	addi	a0,a0,-732 # 80092000 <disk+0x2000>
    800022e4:	6114                	ld	a3,0(a0)
    800022e6:	96ba                	add	a3,a3,a4
    800022e8:	00c6d603          	lhu	a2,12(a3)
    800022ec:	00166613          	ori	a2,a2,1
    800022f0:	00c69623          	sh	a2,12(a3)
    disk.desc[idx[1]].next = idx[2];
    800022f4:	f9842683          	lw	a3,-104(s0)
    800022f8:	6110                	ld	a2,0(a0)
    800022fa:	9732                	add	a4,a4,a2
    800022fc:	00d71723          	sh	a3,14(a4)

    disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80002300:	20058613          	addi	a2,a1,512
    80002304:	0612                	slli	a2,a2,0x4
    80002306:	9642                	add	a2,a2,a6
    80002308:	577d                	li	a4,-1
    8000230a:	02e60823          	sb	a4,48(a2)
    disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000230e:	00469713          	slli	a4,a3,0x4
    80002312:	6114                	ld	a3,0(a0)
    80002314:	96ba                	add	a3,a3,a4
    80002316:	03078793          	addi	a5,a5,48
    8000231a:	97c2                	add	a5,a5,a6
    8000231c:	e29c                	sd	a5,0(a3)
    disk.desc[idx[2]].len = 1;
    8000231e:	611c                	ld	a5,0(a0)
    80002320:	97ba                	add	a5,a5,a4
    80002322:	4685                	li	a3,1
    80002324:	c794                	sw	a3,8(a5)
    disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80002326:	611c                	ld	a5,0(a0)
    80002328:	97ba                	add	a5,a5,a4
    8000232a:	4809                	li	a6,2
    8000232c:	01079623          	sh	a6,12(a5)
    disk.desc[idx[2]].next = 0;
    80002330:	611c                	ld	a5,0(a0)
    80002332:	973e                	add	a4,a4,a5
    80002334:	00071723          	sh	zero,14(a4)

    // record struct buf for virtio_disk_intr().
    b->disk = 1;
    80002338:	00d92223          	sw	a3,4(s2)
    disk.info[idx[0]].b = b;
    8000233c:	03263423          	sd	s2,40(a2)

    // tell the device the first index in our chain of descriptors.
    disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80002340:	6518                	ld	a4,8(a0)
    80002342:	00275783          	lhu	a5,2(a4)
    80002346:	8b9d                	andi	a5,a5,7
    80002348:	0786                	slli	a5,a5,0x1
    8000234a:	97ba                	add	a5,a5,a4
    8000234c:	00b79223          	sh	a1,4(a5)

    __sync_synchronize();
    80002350:	0ff0000f          	fence

    // tell the device another avail ring entry is available.
    disk.avail->idx += 1; // not % NUM ...
    80002354:	6518                	ld	a4,8(a0)
    80002356:	00275783          	lhu	a5,2(a4)
    8000235a:	2785                	addiw	a5,a5,1
    8000235c:	00f71123          	sh	a5,2(a4)

    __sync_synchronize();
    80002360:	0ff0000f          	fence

    *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80002364:	100017b7          	lui	a5,0x10001
    80002368:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

    // Wait for virtio_disk_intr() to say request has finished.
    while (b->disk == 1) {
    8000236c:	00492703          	lw	a4,4(s2)
    80002370:	4785                	li	a5,1
    80002372:	02f71163          	bne	a4,a5,80002394 <virtio_disk_rw+0x226>
        sleep(b, &disk.vdisk_lock);
    80002376:	00090997          	auipc	s3,0x90
    8000237a:	db298993          	addi	s3,s3,-590 # 80092128 <disk+0x2128>
    while (b->disk == 1) {
    8000237e:	4485                	li	s1,1
        sleep(b, &disk.vdisk_lock);
    80002380:	85ce                	mv	a1,s3
    80002382:	854a                	mv	a0,s2
    80002384:	ffffe097          	auipc	ra,0xffffe
    80002388:	72e080e7          	jalr	1838(ra) # 80000ab2 <sleep>
    while (b->disk == 1) {
    8000238c:	00492783          	lw	a5,4(s2)
    80002390:	fe9788e3          	beq	a5,s1,80002380 <virtio_disk_rw+0x212>
    }

    disk.info[idx[0]].b = 0;
    80002394:	f9042903          	lw	s2,-112(s0)
    80002398:	20090793          	addi	a5,s2,512
    8000239c:	00479713          	slli	a4,a5,0x4
    800023a0:	0008e797          	auipc	a5,0x8e
    800023a4:	c6078793          	addi	a5,a5,-928 # 80090000 <disk>
    800023a8:	97ba                	add	a5,a5,a4
    800023aa:	0207b423          	sd	zero,40(a5)
        int flag = disk.desc[i].flags;
    800023ae:	00090997          	auipc	s3,0x90
    800023b2:	c5298993          	addi	s3,s3,-942 # 80092000 <disk+0x2000>
    800023b6:	00491713          	slli	a4,s2,0x4
    800023ba:	0009b783          	ld	a5,0(s3)
    800023be:	97ba                	add	a5,a5,a4
    800023c0:	00c7d483          	lhu	s1,12(a5)
        int nxt = disk.desc[i].next;
    800023c4:	854a                	mv	a0,s2
    800023c6:	00e7d903          	lhu	s2,14(a5)
        free_desc(i);
    800023ca:	00000097          	auipc	ra,0x0
    800023ce:	bb6080e7          	jalr	-1098(ra) # 80001f80 <free_desc>
        if (flag & VRING_DESC_F_NEXT)
    800023d2:	8885                	andi	s1,s1,1
    800023d4:	f0ed                	bnez	s1,800023b6 <virtio_disk_rw+0x248>
    free_chain(idx[0]);
    spin_unlock(&disk.vdisk_lock);
    800023d6:	00090517          	auipc	a0,0x90
    800023da:	d5250513          	addi	a0,a0,-686 # 80092128 <disk+0x2128>
    800023de:	00002097          	auipc	ra,0x2
    800023e2:	874080e7          	jalr	-1932(ra) # 80003c52 <spin_unlock>
}
    800023e6:	70a6                	ld	ra,104(sp)
    800023e8:	7406                	ld	s0,96(sp)
    800023ea:	64e6                	ld	s1,88(sp)
    800023ec:	6946                	ld	s2,80(sp)
    800023ee:	69a6                	ld	s3,72(sp)
    800023f0:	6a06                	ld	s4,64(sp)
    800023f2:	7ae2                	ld	s5,56(sp)
    800023f4:	7b42                	ld	s6,48(sp)
    800023f6:	7ba2                	ld	s7,40(sp)
    800023f8:	7c02                	ld	s8,32(sp)
    800023fa:	6ce2                	ld	s9,24(sp)
    800023fc:	6d42                	ld	s10,16(sp)
    800023fe:	6165                	addi	sp,sp,112
    80002400:	8082                	ret
        disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80002402:	00090697          	auipc	a3,0x90
    80002406:	bfe6b683          	ld	a3,-1026(a3) # 80092000 <disk+0x2000>
    8000240a:	96ba                	add	a3,a3,a4
    8000240c:	4609                	li	a2,2
    8000240e:	00c69623          	sh	a2,12(a3)
    80002412:	b5c9                	j	800022d4 <virtio_disk_rw+0x166>
    struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80002414:	f9042583          	lw	a1,-112(s0)
    80002418:	20058793          	addi	a5,a1,512
    8000241c:	0792                	slli	a5,a5,0x4
    8000241e:	0008e517          	auipc	a0,0x8e
    80002422:	c8a50513          	addi	a0,a0,-886 # 800900a8 <disk+0xa8>
    80002426:	953e                	add	a0,a0,a5
    if (write)
    80002428:	e20d11e3          	bnez	s10,8000224a <virtio_disk_rw+0xdc>
        buf0->type = VIRTIO_BLK_T_IN; // read the disk
    8000242c:	20058713          	addi	a4,a1,512
    80002430:	00471693          	slli	a3,a4,0x4
    80002434:	0008e717          	auipc	a4,0x8e
    80002438:	bcc70713          	addi	a4,a4,-1076 # 80090000 <disk>
    8000243c:	9736                	add	a4,a4,a3
    8000243e:	0a072423          	sw	zero,168(a4)
    80002442:	b505                	j	80002262 <virtio_disk_rw+0xf4>

0000000080002444 <virtio_disk_intr>:

void
virtio_disk_intr() {
    80002444:	7179                	addi	sp,sp,-48
    80002446:	f406                	sd	ra,40(sp)
    80002448:	f022                	sd	s0,32(sp)
    8000244a:	ec26                	sd	s1,24(sp)
    8000244c:	e84a                	sd	s2,16(sp)
    8000244e:	e44e                	sd	s3,8(sp)
    80002450:	e052                	sd	s4,0(sp)
    80002452:	1800                	addi	s0,sp,48
    spin_lock(&disk.vdisk_lock);
    80002454:	00090517          	auipc	a0,0x90
    80002458:	cd450513          	addi	a0,a0,-812 # 80092128 <disk+0x2128>
    8000245c:	00001097          	auipc	ra,0x1
    80002460:	722080e7          	jalr	1826(ra) # 80003b7e <spin_lock>
    // we've seen this interrupt, which the following line does.
    // this may race with the device writing new entries to
    // the "used" ring, in which case we may process the new
    // completion entries in this interrupt, and have nothing to do
    // in the next interrupt, which is harmless.
    *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80002464:	10001737          	lui	a4,0x10001
    80002468:	533c                	lw	a5,96(a4)
    8000246a:	8b8d                	andi	a5,a5,3
    8000246c:	d37c                	sw	a5,100(a4)

    __sync_synchronize();
    8000246e:	0ff0000f          	fence

    // the device increments disk.used->idx when it
    // adds an entry to the used ring.
    while (disk.used_idx != disk.used->idx) {
    80002472:	00090797          	auipc	a5,0x90
    80002476:	b8e78793          	addi	a5,a5,-1138 # 80092000 <disk+0x2000>
    8000247a:	6b94                	ld	a3,16(a5)
    8000247c:	0207d703          	lhu	a4,32(a5)
    80002480:	0026d783          	lhu	a5,2(a3)
    80002484:	06f70e63          	beq	a4,a5,80002500 <virtio_disk_intr+0xbc>
        __sync_synchronize();
        int id = disk.used->ring[disk.used_idx % NUM].id;
    80002488:	0008e997          	auipc	s3,0x8e
    8000248c:	b7898993          	addi	s3,s3,-1160 # 80090000 <disk>
    80002490:	00090917          	auipc	s2,0x90
    80002494:	b7090913          	addi	s2,s2,-1168 # 80092000 <disk+0x2000>

        if (disk.info[id].status != 0)
            panic("virtio_disk_intr status");
    80002498:	00004a17          	auipc	s4,0x4
    8000249c:	e08a0a13          	addi	s4,s4,-504 # 800062a0 <digits+0x1a0>
    800024a0:	a835                	j	800024dc <virtio_disk_intr+0x98>
    800024a2:	8552                	mv	a0,s4
    800024a4:	fffff097          	auipc	ra,0xfffff
    800024a8:	1d2080e7          	jalr	466(ra) # 80001676 <panic>

        struct buf *b = disk.info[id].b;
    800024ac:	20048493          	addi	s1,s1,512 # 10001200 <_entry-0x6fffee00>
    800024b0:	0492                	slli	s1,s1,0x4
    800024b2:	94ce                	add	s1,s1,s3
    800024b4:	7488                	ld	a0,40(s1)
        b->disk = 0;   // disk is done with buf
    800024b6:	00052223          	sw	zero,4(a0)
        wakeup(b);
    800024ba:	ffffe097          	auipc	ra,0xffffe
    800024be:	6f4080e7          	jalr	1780(ra) # 80000bae <wakeup>

        disk.used_idx += 1;
    800024c2:	02095783          	lhu	a5,32(s2)
    800024c6:	2785                	addiw	a5,a5,1
    800024c8:	17c2                	slli	a5,a5,0x30
    800024ca:	93c1                	srli	a5,a5,0x30
    800024cc:	02f91023          	sh	a5,32(s2)
    while (disk.used_idx != disk.used->idx) {
    800024d0:	01093703          	ld	a4,16(s2)
    800024d4:	00275703          	lhu	a4,2(a4) # 10001002 <_entry-0x6fffeffe>
    800024d8:	02f70463          	beq	a4,a5,80002500 <virtio_disk_intr+0xbc>
        __sync_synchronize();
    800024dc:	0ff0000f          	fence
        int id = disk.used->ring[disk.used_idx % NUM].id;
    800024e0:	01093703          	ld	a4,16(s2)
    800024e4:	02095783          	lhu	a5,32(s2)
    800024e8:	8b9d                	andi	a5,a5,7
    800024ea:	078e                	slli	a5,a5,0x3
    800024ec:	97ba                	add	a5,a5,a4
    800024ee:	43c4                	lw	s1,4(a5)
        if (disk.info[id].status != 0)
    800024f0:	20048793          	addi	a5,s1,512
    800024f4:	0792                	slli	a5,a5,0x4
    800024f6:	97ce                	add	a5,a5,s3
    800024f8:	0307c783          	lbu	a5,48(a5)
    800024fc:	dbc5                	beqz	a5,800024ac <virtio_disk_intr+0x68>
    800024fe:	b755                	j	800024a2 <virtio_disk_intr+0x5e>
    }
    spin_unlock(&disk.vdisk_lock);
    80002500:	00090517          	auipc	a0,0x90
    80002504:	c2850513          	addi	a0,a0,-984 # 80092128 <disk+0x2128>
    80002508:	00001097          	auipc	ra,0x1
    8000250c:	74a080e7          	jalr	1866(ra) # 80003c52 <spin_unlock>
}
    80002510:	70a2                	ld	ra,40(sp)
    80002512:	7402                	ld	s0,32(sp)
    80002514:	64e2                	ld	s1,24(sp)
    80002516:	6942                	ld	s2,16(sp)
    80002518:	69a2                	ld	s3,8(sp)
    8000251a:	6a02                	ld	s4,0(sp)
    8000251c:	6145                	addi	sp,sp,48
    8000251e:	8082                	ret

0000000080002520 <exec>:
#include "../defs.h"
#include "elf.h"

static int loadseg(pte_t *pagetable, uint64 addr, struct inode *ip, uint offset, uint sz);

int exec(char *path, char **argv) {
    80002520:	de010113          	addi	sp,sp,-544
    80002524:	20113c23          	sd	ra,536(sp)
    80002528:	20813823          	sd	s0,528(sp)
    8000252c:	20913423          	sd	s1,520(sp)
    80002530:	21213023          	sd	s2,512(sp)
    80002534:	ffce                	sd	s3,504(sp)
    80002536:	fbd2                	sd	s4,496(sp)
    80002538:	f7d6                	sd	s5,488(sp)
    8000253a:	f3da                	sd	s6,480(sp)
    8000253c:	efde                	sd	s7,472(sp)
    8000253e:	ebe2                	sd	s8,464(sp)
    80002540:	e7e6                	sd	s9,456(sp)
    80002542:	e3ea                	sd	s10,448(sp)
    80002544:	ff6e                	sd	s11,440(sp)
    80002546:	1400                	addi	s0,sp,544
    80002548:	84aa                	mv	s1,a0
    8000254a:	dea43c23          	sd	a0,-520(s0)
    8000254e:	e0b43023          	sd	a1,-512(s0)
    uint64 ustack[MAXARG + 1]; // 最后一项为0，用于标记结束
    struct elfhdr elf;
    struct inode *ip;
    struct proghdr ph;
    pagetable_t pagetable = 0;
    struct proc *p = myproc();
    80002552:	ffffe097          	auipc	ra,0xffffe
    80002556:	45e080e7          	jalr	1118(ra) # 800009b0 <myproc>
    8000255a:	dea43823          	sd	a0,-528(s0)


    if ((pagetable = proc_pagetable(p)) == 0) {
    8000255e:	ffffe097          	auipc	ra,0xffffe
    80002562:	268080e7          	jalr	616(ra) # 800007c6 <proc_pagetable>
    80002566:	2c050463          	beqz	a0,8000282e <exec+0x30e>
    8000256a:	8aaa                	mv	s5,a0
        return 0;
    }

    if ((ip = namei(path)) == 0) {
    8000256c:	8526                	mv	a0,s1
    8000256e:	00001097          	auipc	ra,0x1
    80002572:	368080e7          	jalr	872(ra) # 800038d6 <namei>
    80002576:	8a2a                	mv	s4,a0
        return 0;
    80002578:	4481                	li	s1,0
    if ((ip = namei(path)) == 0) {
    8000257a:	1e050563          	beqz	a0,80002764 <exec+0x244>
    }
    lock_inode(ip);
    8000257e:	00001097          	auipc	ra,0x1
    80002582:	cdc080e7          	jalr	-804(ra) # 8000325a <lock_inode>

    // 检查ELF头
    if (read_inode(ip, 0, (uint64) &elf, 0, sizeof(elf)) != sizeof(elf))
    80002586:	04000713          	li	a4,64
    8000258a:	4681                	li	a3,0
    8000258c:	e4840613          	addi	a2,s0,-440
    80002590:	4581                	li	a1,0
    80002592:	8552                	mv	a0,s4
    80002594:	00001097          	auipc	ra,0x1
    80002598:	e20080e7          	jalr	-480(ra) # 800033b4 <read_inode>
    8000259c:	04000793          	li	a5,64
    800025a0:	1af51963          	bne	a0,a5,80002752 <exec+0x232>
        goto bad;
    if (elf.magic != ELF_MAGIC)
    800025a4:	e4842703          	lw	a4,-440(s0)
    800025a8:	464c47b7          	lui	a5,0x464c4
    800025ac:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800025b0:	1af71163          	bne	a4,a5,80002752 <exec+0x232>
        goto bad;

    // 加载程序到内存中
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800025b4:	e6842983          	lw	s3,-408(s0)
    800025b8:	e8045783          	lhu	a5,-384(s0)
    800025bc:	cbed                	beqz	a5,800026ae <exec+0x18e>
    uint64 sz = 0, stackbase, sp;
    800025be:	e0043423          	sd	zero,-504(s0)
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800025c2:	4c01                	li	s8,0
            goto bad;
        uint64 sz1;
        if ((sz1 = user_vm_alloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
            goto bad;
        sz = sz1;
        if (ph.vaddr % PGSIZE != 0)
    800025c4:	6785                	lui	a5,0x1
    800025c6:	17fd                	addi	a5,a5,-1
    800025c8:	def43423          	sd	a5,-536(s0)
    800025cc:	a0bd                	j	8000263a <exec+0x11a>
        panic("loadseg: va must be page aligned");

    for (i = 0; i < sz; i += PGSIZE) {
        pa = walkaddr(pagetable, va + i);
        if (pa == 0)
            panic("loadseg: address should exist");
    800025ce:	00004517          	auipc	a0,0x4
    800025d2:	cea50513          	addi	a0,a0,-790 # 800062b8 <digits+0x1b8>
    800025d6:	fffff097          	auipc	ra,0xfffff
    800025da:	0a0080e7          	jalr	160(ra) # 80001676 <panic>
    800025de:	a089                	j	80002620 <exec+0x100>
        if (sz - i < PGSIZE)
            n = sz - i;
        else
            n = PGSIZE;
        if (read_inode(ip, 0, (uint64) pa, offset + i, n) != n)
    800025e0:	000b871b          	sext.w	a4,s7
    800025e4:	009d86bb          	addw	a3,s11,s1
    800025e8:	864a                	mv	a2,s2
    800025ea:	4581                	li	a1,0
    800025ec:	8552                	mv	a0,s4
    800025ee:	00001097          	auipc	ra,0x1
    800025f2:	dc6080e7          	jalr	-570(ra) # 800033b4 <read_inode>
    800025f6:	2501                	sext.w	a0,a0
    800025f8:	14ab9d63          	bne	s7,a0,80002752 <exec+0x232>
    for (i = 0; i < sz; i += PGSIZE) {
    800025fc:	6785                	lui	a5,0x1
    800025fe:	9cbd                	addw	s1,s1,a5
    80002600:	77fd                	lui	a5,0xfffff
    80002602:	01678b3b          	addw	s6,a5,s6
    80002606:	0394f363          	bgeu	s1,s9,8000262c <exec+0x10c>
        pa = walkaddr(pagetable, va + i);
    8000260a:	02049593          	slli	a1,s1,0x20
    8000260e:	9181                	srli	a1,a1,0x20
    80002610:	95ea                	add	a1,a1,s10
    80002612:	8556                	mv	a0,s5
    80002614:	fffff097          	auipc	ra,0xfffff
    80002618:	348080e7          	jalr	840(ra) # 8000195c <walkaddr>
    8000261c:	892a                	mv	s2,a0
        if (pa == 0)
    8000261e:	d945                	beqz	a0,800025ce <exec+0xae>
            n = PGSIZE;
    80002620:	6b85                	lui	s7,0x1
        if (sz - i < PGSIZE)
    80002622:	6785                	lui	a5,0x1
    80002624:	fafb7ee3          	bgeu	s6,a5,800025e0 <exec+0xc0>
            n = sz - i;
    80002628:	8bda                	mv	s7,s6
    8000262a:	bf5d                	j	800025e0 <exec+0xc0>
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    8000262c:	2c05                	addiw	s8,s8,1
    8000262e:	0389899b          	addiw	s3,s3,56
    80002632:	e8045783          	lhu	a5,-384(s0)
    80002636:	06fc5e63          	bge	s8,a5,800026b2 <exec+0x192>
        if (read_inode(ip, 0, (uint64) &ph, off, sizeof(ph)) != sizeof(ph))
    8000263a:	2981                	sext.w	s3,s3
    8000263c:	03800713          	li	a4,56
    80002640:	86ce                	mv	a3,s3
    80002642:	e1040613          	addi	a2,s0,-496
    80002646:	4581                	li	a1,0
    80002648:	8552                	mv	a0,s4
    8000264a:	00001097          	auipc	ra,0x1
    8000264e:	d6a080e7          	jalr	-662(ra) # 800033b4 <read_inode>
    80002652:	03800793          	li	a5,56
    80002656:	0ef51e63          	bne	a0,a5,80002752 <exec+0x232>
        if (ph.type != ELF_PROG_LOAD)
    8000265a:	e1042703          	lw	a4,-496(s0)
    8000265e:	4785                	li	a5,1
    80002660:	fcf716e3          	bne	a4,a5,8000262c <exec+0x10c>
        if (ph.memsz < ph.filesz)
    80002664:	e3843603          	ld	a2,-456(s0)
    80002668:	e3043783          	ld	a5,-464(s0)
    8000266c:	0ef66363          	bltu	a2,a5,80002752 <exec+0x232>
        if (ph.vaddr + ph.memsz < ph.vaddr)
    80002670:	e2043783          	ld	a5,-480(s0)
    80002674:	963e                	add	a2,a2,a5
    80002676:	0cf66e63          	bltu	a2,a5,80002752 <exec+0x232>
        if ((sz1 = user_vm_alloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000267a:	e0843583          	ld	a1,-504(s0)
    8000267e:	8556                	mv	a0,s5
    80002680:	fffff097          	auipc	ra,0xfffff
    80002684:	42a080e7          	jalr	1066(ra) # 80001aaa <user_vm_alloc>
    80002688:	e0a43423          	sd	a0,-504(s0)
    8000268c:	c179                	beqz	a0,80002752 <exec+0x232>
        if (ph.vaddr % PGSIZE != 0)
    8000268e:	e2043d03          	ld	s10,-480(s0)
    80002692:	de843783          	ld	a5,-536(s0)
    80002696:	00fd77b3          	and	a5,s10,a5
    8000269a:	efc5                	bnez	a5,80002752 <exec+0x232>
        if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000269c:	e1842d83          	lw	s11,-488(s0)
    800026a0:	e3042c83          	lw	s9,-464(s0)
    for (i = 0; i < sz; i += PGSIZE) {
    800026a4:	f80c84e3          	beqz	s9,8000262c <exec+0x10c>
    800026a8:	8b66                	mv	s6,s9
    800026aa:	4481                	li	s1,0
    800026ac:	bfb9                	j	8000260a <exec+0xea>
    uint64 sz = 0, stackbase, sp;
    800026ae:	e0043423          	sd	zero,-504(s0)
    unlock_and_putback(ip);
    800026b2:	8552                	mv	a0,s4
    800026b4:	00001097          	auipc	ra,0x1
    800026b8:	cb2080e7          	jalr	-846(ra) # 80003366 <unlock_and_putback>
    sz = PGROUNDUP(sz);
    800026bc:	6605                	lui	a2,0x1
    800026be:	fff60593          	addi	a1,a2,-1 # fff <_entry-0x7ffff001>
    800026c2:	e0843783          	ld	a5,-504(s0)
    800026c6:	95be                	add	a1,a1,a5
    800026c8:	77fd                	lui	a5,0xfffff
    800026ca:	8dfd                	and	a1,a1,a5
    if ((sz1 = user_vm_alloc(pagetable, sz, sz + PGSIZE)) == 0)
    800026cc:	962e                	add	a2,a2,a1
    800026ce:	8556                	mv	a0,s5
    800026d0:	fffff097          	auipc	ra,0xfffff
    800026d4:	3da080e7          	jalr	986(ra) # 80001aaa <user_vm_alloc>
    800026d8:	8b2a                	mv	s6,a0
    800026da:	cd25                	beqz	a0,80002752 <exec+0x232>
    stackbase = sz - PGSIZE;
    800026dc:	79fd                	lui	s3,0xfffff
    800026de:	99aa                	add	s3,s3,a0
    for (argc = 0; argv[argc]; argc++) {
    800026e0:	e0043783          	ld	a5,-512(s0)
    800026e4:	6388                	ld	a0,0(a5)
    800026e6:	c545                	beqz	a0,8000278e <exec+0x26e>
    800026e8:	e8840913          	addi	s2,s0,-376
    800026ec:	f9040a13          	addi	s4,s0,-112
    sp = sz;
    800026f0:	8bda                	mv	s7,s6
    for (argc = 0; argv[argc]; argc++) {
    800026f2:	4481                	li	s1,0
        sp -= strlen(argv[argc]) + 1;
    800026f4:	fffff097          	auipc	ra,0xfffff
    800026f8:	a80080e7          	jalr	-1408(ra) # 80001174 <strlen>
    800026fc:	0015059b          	addiw	a1,a0,1
    80002700:	1582                	slli	a1,a1,0x20
    80002702:	9181                	srli	a1,a1,0x20
    80002704:	40bb85b3          	sub	a1,s7,a1
        sp -= sp % 16;
    80002708:	ff05fb93          	andi	s7,a1,-16
        if (sp < stackbase){
    8000270c:	053be363          	bltu	s7,s3,80002752 <exec+0x232>
        if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80002710:	e0043c83          	ld	s9,-512(s0)
    80002714:	000cbc03          	ld	s8,0(s9)
    80002718:	8562                	mv	a0,s8
    8000271a:	fffff097          	auipc	ra,0xfffff
    8000271e:	a5a080e7          	jalr	-1446(ra) # 80001174 <strlen>
    80002722:	0015069b          	addiw	a3,a0,1
    80002726:	8662                	mv	a2,s8
    80002728:	85de                	mv	a1,s7
    8000272a:	8556                	mv	a0,s5
    8000272c:	fffff097          	auipc	ra,0xfffff
    80002730:	5f0080e7          	jalr	1520(ra) # 80001d1c <copyout>
    80002734:	00054f63          	bltz	a0,80002752 <exec+0x232>
        ustack[argc] = sp;
    80002738:	01793023          	sd	s7,0(s2)
    for (argc = 0; argv[argc]; argc++) {
    8000273c:	2485                	addiw	s1,s1,1
    8000273e:	008c8793          	addi	a5,s9,8
    80002742:	e0f43023          	sd	a5,-512(s0)
    80002746:	008cb503          	ld	a0,8(s9)
    8000274a:	c521                	beqz	a0,80002792 <exec+0x272>
        if (argc > MAXARG)
    8000274c:	0921                	addi	s2,s2,8
    8000274e:	fb4913e3          	bne	s2,s4,800026f4 <exec+0x1d4>
    panic("exec");
    80002752:	00004517          	auipc	a0,0x4
    80002756:	b8650513          	addi	a0,a0,-1146 # 800062d8 <digits+0x1d8>
    8000275a:	fffff097          	auipc	ra,0xfffff
    8000275e:	f1c080e7          	jalr	-228(ra) # 80001676 <panic>
    return 0;
    80002762:	4481                	li	s1,0
}
    80002764:	8526                	mv	a0,s1
    80002766:	21813083          	ld	ra,536(sp)
    8000276a:	21013403          	ld	s0,528(sp)
    8000276e:	20813483          	ld	s1,520(sp)
    80002772:	20013903          	ld	s2,512(sp)
    80002776:	79fe                	ld	s3,504(sp)
    80002778:	7a5e                	ld	s4,496(sp)
    8000277a:	7abe                	ld	s5,488(sp)
    8000277c:	7b1e                	ld	s6,480(sp)
    8000277e:	6bfe                	ld	s7,472(sp)
    80002780:	6c5e                	ld	s8,464(sp)
    80002782:	6cbe                	ld	s9,456(sp)
    80002784:	6d1e                	ld	s10,448(sp)
    80002786:	7dfa                	ld	s11,440(sp)
    80002788:	22010113          	addi	sp,sp,544
    8000278c:	8082                	ret
    sp = sz;
    8000278e:	8bda                	mv	s7,s6
    for (argc = 0; argv[argc]; argc++) {
    80002790:	4481                	li	s1,0
    ustack[argc] = 0;
    80002792:	00349793          	slli	a5,s1,0x3
    80002796:	f9040713          	addi	a4,s0,-112
    8000279a:	97ba                	add	a5,a5,a4
    8000279c:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ff4db10>
    sp -= (argc + 1) * sizeof(uint64);
    800027a0:	0014859b          	addiw	a1,s1,1
    800027a4:	058e                	slli	a1,a1,0x3
    800027a6:	40bb85b3          	sub	a1,s7,a1
    sp -= sp % 16;
    800027aa:	ff05f913          	andi	s2,a1,-16
    if (sp < stackbase){
    800027ae:	fb3962e3          	bltu	s2,s3,80002752 <exec+0x232>
    if (copyout(pagetable, sp, (char *) ustack, (argc + 2) * sizeof(uint64)) < 0)
    800027b2:	0024869b          	addiw	a3,s1,2
    800027b6:	0036969b          	slliw	a3,a3,0x3
    800027ba:	e8840613          	addi	a2,s0,-376
    800027be:	85ca                	mv	a1,s2
    800027c0:	8556                	mv	a0,s5
    800027c2:	fffff097          	auipc	ra,0xfffff
    800027c6:	55a080e7          	jalr	1370(ra) # 80001d1c <copyout>
    800027ca:	f80544e3          	bltz	a0,80002752 <exec+0x232>
    p->trapframe->a1 = sp;
    800027ce:	df043783          	ld	a5,-528(s0)
    800027d2:	63bc                	ld	a5,64(a5)
    800027d4:	0727bc23          	sd	s2,120(a5)
    for (last = s = path; *s; s++)
    800027d8:	df843783          	ld	a5,-520(s0)
    800027dc:	0007c703          	lbu	a4,0(a5)
    800027e0:	cf11                	beqz	a4,800027fc <exec+0x2dc>
    800027e2:	0785                	addi	a5,a5,1
        if (*s == '/')
    800027e4:	02f00693          	li	a3,47
    800027e8:	a029                	j	800027f2 <exec+0x2d2>
    for (last = s = path; *s; s++)
    800027ea:	0785                	addi	a5,a5,1
    800027ec:	fff7c703          	lbu	a4,-1(a5)
    800027f0:	c711                	beqz	a4,800027fc <exec+0x2dc>
        if (*s == '/')
    800027f2:	fed71ce3          	bne	a4,a3,800027ea <exec+0x2ca>
            last = s + 1;
    800027f6:	def43c23          	sd	a5,-520(s0)
    800027fa:	bfc5                	j	800027ea <exec+0x2ca>
    safestrcpy(p->name, last, sizeof(p->name));
    800027fc:	4641                	li	a2,16
    800027fe:	df843583          	ld	a1,-520(s0)
    80002802:	df043983          	ld	s3,-528(s0)
    80002806:	15898513          	addi	a0,s3,344 # fffffffffffff158 <end+0xffffffff7ff4dd70>
    8000280a:	fffff097          	auipc	ra,0xfffff
    8000280e:	9b0080e7          	jalr	-1616(ra) # 800011ba <safestrcpy>
    p->pagetable = pagetable;
    80002812:	0559b423          	sd	s5,72(s3)
    p->sz = sz;
    80002816:	1769a423          	sw	s6,360(s3)
    p->trapframe->epc = elf.entry;
    8000281a:	0409b783          	ld	a5,64(s3)
    8000281e:	e6043703          	ld	a4,-416(s0)
    80002822:	ef98                	sd	a4,24(a5)
    p->trapframe->sp = sp;
    80002824:	0409b783          	ld	a5,64(s3)
    80002828:	0327b823          	sd	s2,48(a5)
    return argc;
    8000282c:	bf25                	j	80002764 <exec+0x244>
        return 0;
    8000282e:	4481                	li	s1,0
    80002830:	bf15                	j	80002764 <exec+0x244>

0000000080002832 <fileinit>:
struct {
    struct spinlock lock;
    struct file file[NFILE];
} file_table;

void fileinit(void) {
    80002832:	1141                	addi	sp,sp,-16
    80002834:	e406                	sd	ra,8(sp)
    80002836:	e022                	sd	s0,0(sp)
    80002838:	0800                	addi	s0,sp,16
    spinlock_init(&file_table.lock, "file table");
    8000283a:	00004597          	auipc	a1,0x4
    8000283e:	aa658593          	addi	a1,a1,-1370 # 800062e0 <digits+0x1e0>
    80002842:	00091517          	auipc	a0,0x91
    80002846:	85e50513          	addi	a0,a0,-1954 # 800930a0 <file_table>
    8000284a:	00001097          	auipc	ra,0x1
    8000284e:	2a4080e7          	jalr	676(ra) # 80003aee <spinlock_init>
}
    80002852:	60a2                	ld	ra,8(sp)
    80002854:	6402                	ld	s0,0(sp)
    80002856:	0141                	addi	sp,sp,16
    80002858:	8082                	ret

000000008000285a <file_alloc>:

// 申请使用一个文件结构体
struct file *file_alloc(void) {
    8000285a:	1101                	addi	sp,sp,-32
    8000285c:	ec06                	sd	ra,24(sp)
    8000285e:	e822                	sd	s0,16(sp)
    80002860:	e426                	sd	s1,8(sp)
    80002862:	1000                	addi	s0,sp,32
    struct file *f;
    spin_lock(&file_table.lock);
    80002864:	00091517          	auipc	a0,0x91
    80002868:	83c50513          	addi	a0,a0,-1988 # 800930a0 <file_table>
    8000286c:	00001097          	auipc	ra,0x1
    80002870:	312080e7          	jalr	786(ra) # 80003b7e <spin_lock>
    for (f = file_table.file; f < file_table.file + NFILE; ++f) {
    80002874:	00091497          	auipc	s1,0x91
    80002878:	84448493          	addi	s1,s1,-1980 # 800930b8 <file_table+0x18>
    8000287c:	00092717          	auipc	a4,0x92
    80002880:	13c70713          	addi	a4,a4,316 # 800949b8 <sb>
        if (f->ref == 0) {
    80002884:	40dc                	lw	a5,4(s1)
    80002886:	cf99                	beqz	a5,800028a4 <file_alloc+0x4a>
    for (f = file_table.file; f < file_table.file + NFILE; ++f) {
    80002888:	02048493          	addi	s1,s1,32
    8000288c:	fee49ce3          	bne	s1,a4,80002884 <file_alloc+0x2a>
            f->ref = 1;
            spin_unlock(&file_table.lock);
            return f;
        }
    }
    spin_unlock(&file_table.lock);
    80002890:	00091517          	auipc	a0,0x91
    80002894:	81050513          	addi	a0,a0,-2032 # 800930a0 <file_table>
    80002898:	00001097          	auipc	ra,0x1
    8000289c:	3ba080e7          	jalr	954(ra) # 80003c52 <spin_unlock>
    return 0;
    800028a0:	4481                	li	s1,0
    800028a2:	a819                	j	800028b8 <file_alloc+0x5e>
            f->ref = 1;
    800028a4:	4785                	li	a5,1
    800028a6:	c0dc                	sw	a5,4(s1)
            spin_unlock(&file_table.lock);
    800028a8:	00090517          	auipc	a0,0x90
    800028ac:	7f850513          	addi	a0,a0,2040 # 800930a0 <file_table>
    800028b0:	00001097          	auipc	ra,0x1
    800028b4:	3a2080e7          	jalr	930(ra) # 80003c52 <spin_unlock>
}
    800028b8:	8526                	mv	a0,s1
    800028ba:	60e2                	ld	ra,24(sp)
    800028bc:	6442                	ld	s0,16(sp)
    800028be:	64a2                	ld	s1,8(sp)
    800028c0:	6105                	addi	sp,sp,32
    800028c2:	8082                	ret

00000000800028c4 <file_dup>:

// 递增文件f的的引用数量
struct file *file_dup(struct file *f) {
    800028c4:	1101                	addi	sp,sp,-32
    800028c6:	ec06                	sd	ra,24(sp)
    800028c8:	e822                	sd	s0,16(sp)
    800028ca:	e426                	sd	s1,8(sp)
    800028cc:	1000                	addi	s0,sp,32
    800028ce:	84aa                	mv	s1,a0
    spin_lock(&file_table.lock);
    800028d0:	00090517          	auipc	a0,0x90
    800028d4:	7d050513          	addi	a0,a0,2000 # 800930a0 <file_table>
    800028d8:	00001097          	auipc	ra,0x1
    800028dc:	2a6080e7          	jalr	678(ra) # 80003b7e <spin_lock>
    if (f->ref < 1) {
    800028e0:	40dc                	lw	a5,4(s1)
    800028e2:	02f05363          	blez	a5,80002908 <file_dup+0x44>
        panic("file dup");
    }
    f->ref++;
    800028e6:	40dc                	lw	a5,4(s1)
    800028e8:	2785                	addiw	a5,a5,1
    800028ea:	c0dc                	sw	a5,4(s1)
    spin_unlock(&file_table.lock);
    800028ec:	00090517          	auipc	a0,0x90
    800028f0:	7b450513          	addi	a0,a0,1972 # 800930a0 <file_table>
    800028f4:	00001097          	auipc	ra,0x1
    800028f8:	35e080e7          	jalr	862(ra) # 80003c52 <spin_unlock>
    return f;
}
    800028fc:	8526                	mv	a0,s1
    800028fe:	60e2                	ld	ra,24(sp)
    80002900:	6442                	ld	s0,16(sp)
    80002902:	64a2                	ld	s1,8(sp)
    80002904:	6105                	addi	sp,sp,32
    80002906:	8082                	ret
        panic("file dup");
    80002908:	00004517          	auipc	a0,0x4
    8000290c:	9e850513          	addi	a0,a0,-1560 # 800062f0 <digits+0x1f0>
    80002910:	fffff097          	auipc	ra,0xfffff
    80002914:	d66080e7          	jalr	-666(ra) # 80001676 <panic>
    80002918:	b7f9                	j	800028e6 <file_dup+0x22>

000000008000291a <file_close>:

// 关闭文件(递减文件f的引用数量,为0时关闭文件)。
void file_close(struct file *f) {
    8000291a:	7179                	addi	sp,sp,-48
    8000291c:	f406                	sd	ra,40(sp)
    8000291e:	f022                	sd	s0,32(sp)
    80002920:	ec26                	sd	s1,24(sp)
    80002922:	e84a                	sd	s2,16(sp)
    80002924:	e44e                	sd	s3,8(sp)
    80002926:	1800                	addi	s0,sp,48
    80002928:	84aa                	mv	s1,a0
    struct file ff;
    spin_lock(&file_table.lock);
    8000292a:	00090517          	auipc	a0,0x90
    8000292e:	77650513          	addi	a0,a0,1910 # 800930a0 <file_table>
    80002932:	00001097          	auipc	ra,0x1
    80002936:	24c080e7          	jalr	588(ra) # 80003b7e <spin_lock>
    if (f->ref < 1)
    8000293a:	40dc                	lw	a5,4(s1)
    8000293c:	04f05463          	blez	a5,80002984 <file_close+0x6a>
        panic("file close");
    if (--f->ref > 0) {
    80002940:	40dc                	lw	a5,4(s1)
    80002942:	37fd                	addiw	a5,a5,-1
    80002944:	0007871b          	sext.w	a4,a5
    80002948:	c0dc                	sw	a5,4(s1)
    8000294a:	04e04663          	bgtz	a4,80002996 <file_close+0x7c>
        spin_unlock(&file_table.lock);
        return;
    }
    ff = *f;
    8000294e:	0004a903          	lw	s2,0(s1)
    80002952:	0104b983          	ld	s3,16(s1)
    f->type = FD_NONE;
    80002956:	0004a023          	sw	zero,0(s1)
    f->ref = 0;
    8000295a:	0004a223          	sw	zero,4(s1)
    spin_unlock(&file_table.lock);
    8000295e:	00090517          	auipc	a0,0x90
    80002962:	74250513          	addi	a0,a0,1858 # 800930a0 <file_table>
    80002966:	00001097          	auipc	ra,0x1
    8000296a:	2ec080e7          	jalr	748(ra) # 80003c52 <spin_unlock>

    if (ff.type == FD_INODE || ff.type == FD_DEVICE) {
    8000296e:	3979                	addiw	s2,s2,-2
    80002970:	4785                	li	a5,1
    80002972:	0327fb63          	bgeu	a5,s2,800029a8 <file_close+0x8e>
        putback_inode(ff.ip);
    }
}
    80002976:	70a2                	ld	ra,40(sp)
    80002978:	7402                	ld	s0,32(sp)
    8000297a:	64e2                	ld	s1,24(sp)
    8000297c:	6942                	ld	s2,16(sp)
    8000297e:	69a2                	ld	s3,8(sp)
    80002980:	6145                	addi	sp,sp,48
    80002982:	8082                	ret
        panic("file close");
    80002984:	00004517          	auipc	a0,0x4
    80002988:	97c50513          	addi	a0,a0,-1668 # 80006300 <digits+0x200>
    8000298c:	fffff097          	auipc	ra,0xfffff
    80002990:	cea080e7          	jalr	-790(ra) # 80001676 <panic>
    80002994:	b775                	j	80002940 <file_close+0x26>
        spin_unlock(&file_table.lock);
    80002996:	00090517          	auipc	a0,0x90
    8000299a:	70a50513          	addi	a0,a0,1802 # 800930a0 <file_table>
    8000299e:	00001097          	auipc	ra,0x1
    800029a2:	2b4080e7          	jalr	692(ra) # 80003c52 <spin_unlock>
        return;
    800029a6:	bfc1                	j	80002976 <file_close+0x5c>
        putback_inode(ff.ip);
    800029a8:	854e                	mv	a0,s3
    800029aa:	00000097          	auipc	ra,0x0
    800029ae:	7ca080e7          	jalr	1994(ra) # 80003174 <putback_inode>
    800029b2:	b7d1                	j	80002976 <file_close+0x5c>

00000000800029b4 <file_stat>:
/**
 * 获取文件f的元数据
 * @param addr 用户空间地址，应该指向一个stat结构体
 * @return
 */
int file_stat(struct file *f, uint64 addr) {
    800029b4:	715d                	addi	sp,sp,-80
    800029b6:	e486                	sd	ra,72(sp)
    800029b8:	e0a2                	sd	s0,64(sp)
    800029ba:	fc26                	sd	s1,56(sp)
    800029bc:	f84a                	sd	s2,48(sp)
    800029be:	f44e                	sd	s3,40(sp)
    800029c0:	0880                	addi	s0,sp,80
    800029c2:	84aa                	mv	s1,a0
    800029c4:	89ae                	mv	s3,a1
    struct proc *p = myproc();
    800029c6:	ffffe097          	auipc	ra,0xffffe
    800029ca:	fea080e7          	jalr	-22(ra) # 800009b0 <myproc>
    struct stat st;
    if (f->type == FD_INODE || f->type == FD_DEVICE) {
    800029ce:	409c                	lw	a5,0(s1)
    800029d0:	37f9                	addiw	a5,a5,-2
    800029d2:	4705                	li	a4,1
    800029d4:	04f76763          	bltu	a4,a5,80002a22 <file_stat+0x6e>
    800029d8:	892a                	mv	s2,a0
        lock_inode(f->ip);
    800029da:	6888                	ld	a0,16(s1)
    800029dc:	00001097          	auipc	ra,0x1
    800029e0:	87e080e7          	jalr	-1922(ra) # 8000325a <lock_inode>
        stat_inode(f->ip, &st);
    800029e4:	fb840593          	addi	a1,s0,-72
    800029e8:	6888                	ld	a0,16(s1)
    800029ea:	00001097          	auipc	ra,0x1
    800029ee:	9a4080e7          	jalr	-1628(ra) # 8000338e <stat_inode>
        unlock_inode(f->ip);
    800029f2:	6888                	ld	a0,16(s1)
    800029f4:	00001097          	auipc	ra,0x1
    800029f8:	92c080e7          	jalr	-1748(ra) # 80003320 <unlock_inode>
        if (copyout(p->pagetable, addr, (char *) &st, sizeof(st)) < 0) {
    800029fc:	46e1                	li	a3,24
    800029fe:	fb840613          	addi	a2,s0,-72
    80002a02:	85ce                	mv	a1,s3
    80002a04:	04893503          	ld	a0,72(s2)
    80002a08:	fffff097          	auipc	ra,0xfffff
    80002a0c:	314080e7          	jalr	788(ra) # 80001d1c <copyout>
    80002a10:	41f5551b          	sraiw	a0,a0,0x1f
            return -1;
        }
        return 0;
    }
    return -1;
}
    80002a14:	60a6                	ld	ra,72(sp)
    80002a16:	6406                	ld	s0,64(sp)
    80002a18:	74e2                	ld	s1,56(sp)
    80002a1a:	7942                	ld	s2,48(sp)
    80002a1c:	79a2                	ld	s3,40(sp)
    80002a1e:	6161                	addi	sp,sp,80
    80002a20:	8082                	ret
    return -1;
    80002a22:	557d                	li	a0,-1
    80002a24:	bfc5                	j	80002a14 <file_stat+0x60>

0000000080002a26 <file_read>:
 * 读取文件数据
 *
 * @param addr 用户空间虚拟地址
 * @param n 读取字节数
 */
int file_read(struct file *f, uint64 addr, int n) {
    80002a26:	7179                	addi	sp,sp,-48
    80002a28:	f406                	sd	ra,40(sp)
    80002a2a:	f022                	sd	s0,32(sp)
    80002a2c:	ec26                	sd	s1,24(sp)
    80002a2e:	e84a                	sd	s2,16(sp)
    80002a30:	e44e                	sd	s3,8(sp)
    80002a32:	e052                	sd	s4,0(sp)
    80002a34:	1800                	addi	s0,sp,48

    int len = 0;

    if (f->readable == 0) {
    80002a36:	00854783          	lbu	a5,8(a0)
    80002a3a:	c3d9                	beqz	a5,80002ac0 <file_read+0x9a>
    80002a3c:	84aa                	mv	s1,a0
    80002a3e:	89ae                	mv	s3,a1
    80002a40:	8a32                	mv	s4,a2
        return -1;
    }
    if (f->type == FD_DEVICE) {
    80002a42:	411c                	lw	a5,0(a0)
    80002a44:	470d                	li	a4,3
    80002a46:	00e78f63          	beq	a5,a4,80002a64 <file_read+0x3e>
        if (f->major < 0 || f->major > NDEV || !dev_rw[f->major].read) {
            return -1;
        }
        len = dev_rw[f->major].read(1, addr, n);
    } else if (f->type == FD_INODE) {
    80002a4a:	4709                	li	a4,2
    int len = 0;
    80002a4c:	4901                	li	s2,0
    } else if (f->type == FD_INODE) {
    80002a4e:	02e78f63          	beq	a5,a4,80002a8c <file_read+0x66>
        }
        unlock_inode(f->ip);
    }

    return len;
}
    80002a52:	854a                	mv	a0,s2
    80002a54:	70a2                	ld	ra,40(sp)
    80002a56:	7402                	ld	s0,32(sp)
    80002a58:	64e2                	ld	s1,24(sp)
    80002a5a:	6942                	ld	s2,16(sp)
    80002a5c:	69a2                	ld	s3,8(sp)
    80002a5e:	6a02                	ld	s4,0(sp)
    80002a60:	6145                	addi	sp,sp,48
    80002a62:	8082                	ret
        if (f->major < 0 || f->major > NDEV || !dev_rw[f->major].read) {
    80002a64:	01c51783          	lh	a5,28(a0)
    80002a68:	03079693          	slli	a3,a5,0x30
    80002a6c:	92c1                	srli	a3,a3,0x30
    80002a6e:	4729                	li	a4,10
    80002a70:	04d76a63          	bltu	a4,a3,80002ac4 <file_read+0x9e>
    80002a74:	0792                	slli	a5,a5,0x4
    80002a76:	00090717          	auipc	a4,0x90
    80002a7a:	58a70713          	addi	a4,a4,1418 # 80093000 <dev_rw>
    80002a7e:	97ba                	add	a5,a5,a4
    80002a80:	639c                	ld	a5,0(a5)
    80002a82:	c3b9                	beqz	a5,80002ac8 <file_read+0xa2>
        len = dev_rw[f->major].read(1, addr, n);
    80002a84:	4505                	li	a0,1
    80002a86:	9782                	jalr	a5
    80002a88:	892a                	mv	s2,a0
    80002a8a:	b7e1                	j	80002a52 <file_read+0x2c>
        lock_inode(f->ip);
    80002a8c:	6908                	ld	a0,16(a0)
    80002a8e:	00000097          	auipc	ra,0x0
    80002a92:	7cc080e7          	jalr	1996(ra) # 8000325a <lock_inode>
        if ((len = read_inode(f->ip, 1, addr, f->off, n)) > 0) {
    80002a96:	8752                	mv	a4,s4
    80002a98:	4c94                	lw	a3,24(s1)
    80002a9a:	864e                	mv	a2,s3
    80002a9c:	4585                	li	a1,1
    80002a9e:	6888                	ld	a0,16(s1)
    80002aa0:	00001097          	auipc	ra,0x1
    80002aa4:	914080e7          	jalr	-1772(ra) # 800033b4 <read_inode>
    80002aa8:	892a                	mv	s2,a0
    80002aaa:	00a05563          	blez	a0,80002ab4 <file_read+0x8e>
            f->off += len;
    80002aae:	4c9c                	lw	a5,24(s1)
    80002ab0:	9fa9                	addw	a5,a5,a0
    80002ab2:	cc9c                	sw	a5,24(s1)
        unlock_inode(f->ip);
    80002ab4:	6888                	ld	a0,16(s1)
    80002ab6:	00001097          	auipc	ra,0x1
    80002aba:	86a080e7          	jalr	-1942(ra) # 80003320 <unlock_inode>
    80002abe:	bf51                	j	80002a52 <file_read+0x2c>
        return -1;
    80002ac0:	597d                	li	s2,-1
    80002ac2:	bf41                	j	80002a52 <file_read+0x2c>
            return -1;
    80002ac4:	597d                	li	s2,-1
    80002ac6:	b771                	j	80002a52 <file_read+0x2c>
    80002ac8:	597d                	li	s2,-1
    80002aca:	b761                	j	80002a52 <file_read+0x2c>

0000000080002acc <file_write>:
 * 为inode文件，
 *
 * @param addr 用户空间虚拟地址
 * @param n 写入字节数
 */
int file_write(struct file *f, uint64 addr, int n) {
    80002acc:	7179                	addi	sp,sp,-48
    80002ace:	f406                	sd	ra,40(sp)
    80002ad0:	f022                	sd	s0,32(sp)
    80002ad2:	ec26                	sd	s1,24(sp)
    80002ad4:	e84a                	sd	s2,16(sp)
    80002ad6:	e44e                	sd	s3,8(sp)
    80002ad8:	e052                	sd	s4,0(sp)
    80002ada:	1800                	addi	s0,sp,48
    80002adc:	84aa                	mv	s1,a0
    80002ade:	8a2e                	mv	s4,a1
    80002ae0:	89b2                	mv	s3,a2
    int ret = 0;
    if (f->type == FD_DEVICE) {
    80002ae2:	411c                	lw	a5,0(a0)
    80002ae4:	470d                	li	a4,3
    80002ae6:	00e78f63          	beq	a5,a4,80002b04 <file_write+0x38>
        if (f->major < 0 || f->major >= NDEV || !dev_rw[f->major].write)
            return -1;
        ret = dev_rw[f->major].write(1, addr, n);
    } else if (f->type == FD_INODE) {
    80002aea:	4709                	li	a4,2
    int ret = 0;
    80002aec:	4901                	li	s2,0
    } else if (f->type == FD_INODE) {
    80002aee:	02e78f63          	beq	a5,a4,80002b2c <file_write+0x60>
        lock_inode(f->ip);
        ret = write_inode(f->ip, 1, addr, f->off, n);
        unlock_inode(f->ip);
    }
    return ret;
}
    80002af2:	854a                	mv	a0,s2
    80002af4:	70a2                	ld	ra,40(sp)
    80002af6:	7402                	ld	s0,32(sp)
    80002af8:	64e2                	ld	s1,24(sp)
    80002afa:	6942                	ld	s2,16(sp)
    80002afc:	69a2                	ld	s3,8(sp)
    80002afe:	6a02                	ld	s4,0(sp)
    80002b00:	6145                	addi	sp,sp,48
    80002b02:	8082                	ret
        if (f->major < 0 || f->major >= NDEV || !dev_rw[f->major].write)
    80002b04:	01c51783          	lh	a5,28(a0)
    80002b08:	03079693          	slli	a3,a5,0x30
    80002b0c:	92c1                	srli	a3,a3,0x30
    80002b0e:	4725                	li	a4,9
    80002b10:	04d76463          	bltu	a4,a3,80002b58 <file_write+0x8c>
    80002b14:	0792                	slli	a5,a5,0x4
    80002b16:	00090717          	auipc	a4,0x90
    80002b1a:	4ea70713          	addi	a4,a4,1258 # 80093000 <dev_rw>
    80002b1e:	97ba                	add	a5,a5,a4
    80002b20:	679c                	ld	a5,8(a5)
    80002b22:	cf8d                	beqz	a5,80002b5c <file_write+0x90>
        ret = dev_rw[f->major].write(1, addr, n);
    80002b24:	4505                	li	a0,1
    80002b26:	9782                	jalr	a5
    80002b28:	892a                	mv	s2,a0
    80002b2a:	b7e1                	j	80002af2 <file_write+0x26>
        lock_inode(f->ip);
    80002b2c:	6908                	ld	a0,16(a0)
    80002b2e:	00000097          	auipc	ra,0x0
    80002b32:	72c080e7          	jalr	1836(ra) # 8000325a <lock_inode>
        ret = write_inode(f->ip, 1, addr, f->off, n);
    80002b36:	874e                	mv	a4,s3
    80002b38:	0184e683          	lwu	a3,24(s1)
    80002b3c:	8652                	mv	a2,s4
    80002b3e:	4585                	li	a1,1
    80002b40:	6888                	ld	a0,16(s1)
    80002b42:	00001097          	auipc	ra,0x1
    80002b46:	960080e7          	jalr	-1696(ra) # 800034a2 <write_inode>
    80002b4a:	892a                	mv	s2,a0
        unlock_inode(f->ip);
    80002b4c:	6888                	ld	a0,16(s1)
    80002b4e:	00000097          	auipc	ra,0x0
    80002b52:	7d2080e7          	jalr	2002(ra) # 80003320 <unlock_inode>
    80002b56:	bf71                	j	80002af2 <file_write+0x26>
            return -1;
    80002b58:	597d                	li	s2,-1
    80002b5a:	bf61                	j	80002af2 <file_write+0x26>
    80002b5c:	597d                	li	s2,-1
    80002b5e:	bf51                	j	80002af2 <file_write+0x26>

0000000080002b60 <read_superblock>:

#define min(a, b) ((a) < (b) ? (a) : (b))
struct superblock sb;

// 读取超级块
void read_superblock(struct superblock *sb) {
    80002b60:	b9010113          	addi	sp,sp,-1136
    80002b64:	46113423          	sd	ra,1128(sp)
    80002b68:	46813023          	sd	s0,1120(sp)
    80002b6c:	44913c23          	sd	s1,1112(sp)
    80002b70:	47010413          	addi	s0,sp,1136
    80002b74:	84aa                	mv	s1,a0
    struct buf b;
    b.blockno = 1;
    80002b76:	4785                	li	a5,1
    80002b78:	b8f42e23          	sw	a5,-1124(s0)
    virtio_disk_rw(&b, 0);
    80002b7c:	4581                	li	a1,0
    80002b7e:	b9040513          	addi	a0,s0,-1136
    80002b82:	fffff097          	auipc	ra,0xfffff
    80002b86:	5ec080e7          	jalr	1516(ra) # 8000216e <virtio_disk_rw>
    memmove(sb, &b.data, sizeof(*sb));
    80002b8a:	4661                	li	a2,24
    80002b8c:	bdc40593          	addi	a1,s0,-1060
    80002b90:	8526                	mv	a0,s1
    80002b92:	ffffe097          	auipc	ra,0xffffe
    80002b96:	586080e7          	jalr	1414(ra) # 80001118 <memmove>
    return;
}
    80002b9a:	46813083          	ld	ra,1128(sp)
    80002b9e:	46013403          	ld	s0,1120(sp)
    80002ba2:	45813483          	ld	s1,1112(sp)
    80002ba6:	47010113          	addi	sp,sp,1136
    80002baa:	8082                	ret

0000000080002bac <init_fs>:

// 初始化文件系统
void init_fs() {
    80002bac:	1101                	addi	sp,sp,-32
    80002bae:	ec06                	sd	ra,24(sp)
    80002bb0:	e822                	sd	s0,16(sp)
    80002bb2:	e426                	sd	s1,8(sp)
    80002bb4:	1000                	addi	s0,sp,32
    read_superblock(&sb);
    80002bb6:	00092497          	auipc	s1,0x92
    80002bba:	e0248493          	addi	s1,s1,-510 # 800949b8 <sb>
    80002bbe:	8526                	mv	a0,s1
    80002bc0:	00000097          	auipc	ra,0x0
    80002bc4:	fa0080e7          	jalr	-96(ra) # 80002b60 <read_superblock>
    if (sb.magic != FSMAGIC) {
    80002bc8:	4098                	lw	a4,0(s1)
    80002bca:	102037b7          	lui	a5,0x10203
    80002bce:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002bd2:	00f71763          	bne	a4,a5,80002be0 <init_fs+0x34>
        panic("fs init");
    }
}
    80002bd6:	60e2                	ld	ra,24(sp)
    80002bd8:	6442                	ld	s0,16(sp)
    80002bda:	64a2                	ld	s1,8(sp)
    80002bdc:	6105                	addi	sp,sp,32
    80002bde:	8082                	ret
        panic("fs init");
    80002be0:	00003517          	auipc	a0,0x3
    80002be4:	73050513          	addi	a0,a0,1840 # 80006310 <digits+0x210>
    80002be8:	fffff097          	auipc	ra,0xfffff
    80002bec:	a8e080e7          	jalr	-1394(ra) # 80001676 <panic>
}
    80002bf0:	b7dd                	j	80002bd6 <init_fs+0x2a>

0000000080002bf2 <zero_block>:
//
// 数据块，下面的block通常指数据块
//

// 格式化磁盘块中的数据
void zero_block(int blockno) {
    80002bf2:	1101                	addi	sp,sp,-32
    80002bf4:	ec06                	sd	ra,24(sp)
    80002bf6:	e822                	sd	s0,16(sp)
    80002bf8:	e426                	sd	s1,8(sp)
    80002bfa:	1000                	addi	s0,sp,32
    80002bfc:	85aa                	mv	a1,a0
    struct buf *bp;
    bp = buf_read(0, blockno);
    80002bfe:	4501                	li	a0,0
    80002c00:	00001097          	auipc	ra,0x1
    80002c04:	e4e080e7          	jalr	-434(ra) # 80003a4e <buf_read>
    80002c08:	84aa                	mv	s1,a0
    memset(bp->data, 0, BSIZE);
    80002c0a:	40000613          	li	a2,1024
    80002c0e:	4581                	li	a1,0
    80002c10:	04c50513          	addi	a0,a0,76
    80002c14:	ffffe097          	auipc	ra,0xffffe
    80002c18:	4de080e7          	jalr	1246(ra) # 800010f2 <memset>
    buf_write(bp);
    80002c1c:	8526                	mv	a0,s1
    80002c1e:	00001097          	auipc	ra,0x1
    80002c22:	e64080e7          	jalr	-412(ra) # 80003a82 <buf_write>
    relse_buf(bp);
    80002c26:	8526                	mv	a0,s1
    80002c28:	00001097          	auipc	ra,0x1
    80002c2c:	e74080e7          	jalr	-396(ra) # 80003a9c <relse_buf>
}
    80002c30:	60e2                	ld	ra,24(sp)
    80002c32:	6442                	ld	s0,16(sp)
    80002c34:	64a2                	ld	s1,8(sp)
    80002c36:	6105                	addi	sp,sp,32
    80002c38:	8082                	ret

0000000080002c3a <alloc_disk_block>:

// 申请空闲的磁盘块, 且格式化为0，返回块号。
uint alloc_disk_block() {
    80002c3a:	715d                	addi	sp,sp,-80
    80002c3c:	e486                	sd	ra,72(sp)
    80002c3e:	e0a2                	sd	s0,64(sp)
    80002c40:	fc26                	sd	s1,56(sp)
    80002c42:	f84a                	sd	s2,48(sp)
    80002c44:	f44e                	sd	s3,40(sp)
    80002c46:	f052                	sd	s4,32(sp)
    80002c48:	ec56                	sd	s5,24(sp)
    80002c4a:	e85a                	sd	s6,16(sp)
    80002c4c:	e45e                	sd	s7,8(sp)
    80002c4e:	0880                	addi	s0,sp,80
    int b, bi, m;
    struct buf *bitmap;

    for (b = 0; b < sb.size; b += BPB) { // 遍历bitmap
    80002c50:	00092797          	auipc	a5,0x92
    80002c54:	d6c7a783          	lw	a5,-660(a5) # 800949bc <sb+0x4>
    80002c58:	c3e9                	beqz	a5,80002d1a <alloc_disk_block+0xe0>
    80002c5a:	4a81                	li	s5,0
        bitmap = buf_read(0, BBLOCK(b, sb));
    80002c5c:	00092b17          	auipc	s6,0x92
    80002c60:	d5cb0b13          	addi	s6,s6,-676 # 800949b8 <sb>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) { //遍历bitmap的每一位
            m = 1 << (bi % 8);
    80002c64:	4985                	li	s3,1
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) { //遍历bitmap的每一位
    80002c66:	6a09                	lui	s4,0x2
    for (b = 0; b < sb.size; b += BPB) { // 遍历bitmap
    80002c68:	6b89                	lui	s7,0x2
    80002c6a:	a0b1                	j	80002cb6 <alloc_disk_block+0x7c>
            if ((bitmap->data[bi / 8] & m) == 0) { // 判断块是否被使用
                bitmap->data[bi / 8] |= m; // 标记块被使用
    80002c6c:	972a                	add	a4,a4,a0
    80002c6e:	8fd5                	or	a5,a5,a3
    80002c70:	04f70623          	sb	a5,76(a4)
                relse_buf(bitmap);
    80002c74:	00001097          	auipc	ra,0x1
    80002c78:	e28080e7          	jalr	-472(ra) # 80003a9c <relse_buf>
                zero_block(b + bi);
    80002c7c:	854a                	mv	a0,s2
    80002c7e:	00000097          	auipc	ra,0x0
    80002c82:	f74080e7          	jalr	-140(ra) # 80002bf2 <zero_block>
        }
        relse_buf(bitmap);
    }
    panic("balloc: out of blocks");
    return 0;
}
    80002c86:	8526                	mv	a0,s1
    80002c88:	60a6                	ld	ra,72(sp)
    80002c8a:	6406                	ld	s0,64(sp)
    80002c8c:	74e2                	ld	s1,56(sp)
    80002c8e:	7942                	ld	s2,48(sp)
    80002c90:	79a2                	ld	s3,40(sp)
    80002c92:	7a02                	ld	s4,32(sp)
    80002c94:	6ae2                	ld	s5,24(sp)
    80002c96:	6b42                	ld	s6,16(sp)
    80002c98:	6ba2                	ld	s7,8(sp)
    80002c9a:	6161                	addi	sp,sp,80
    80002c9c:	8082                	ret
        relse_buf(bitmap);
    80002c9e:	00001097          	auipc	ra,0x1
    80002ca2:	dfe080e7          	jalr	-514(ra) # 80003a9c <relse_buf>
    for (b = 0; b < sb.size; b += BPB) { // 遍历bitmap
    80002ca6:	015b87bb          	addw	a5,s7,s5
    80002caa:	00078a9b          	sext.w	s5,a5
    80002cae:	004b2703          	lw	a4,4(s6)
    80002cb2:	06eaf463          	bgeu	s5,a4,80002d1a <alloc_disk_block+0xe0>
        bitmap = buf_read(0, BBLOCK(b, sb));
    80002cb6:	41fad79b          	sraiw	a5,s5,0x1f
    80002cba:	0137d79b          	srliw	a5,a5,0x13
    80002cbe:	015787bb          	addw	a5,a5,s5
    80002cc2:	40d7d79b          	sraiw	a5,a5,0xd
    80002cc6:	014b2583          	lw	a1,20(s6)
    80002cca:	9dbd                	addw	a1,a1,a5
    80002ccc:	4501                	li	a0,0
    80002cce:	00001097          	auipc	ra,0x1
    80002cd2:	d80080e7          	jalr	-640(ra) # 80003a4e <buf_read>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) { //遍历bitmap的每一位
    80002cd6:	004b2803          	lw	a6,4(s6)
    80002cda:	000a849b          	sext.w	s1,s5
    80002cde:	4601                	li	a2,0
    80002ce0:	0004891b          	sext.w	s2,s1
    80002ce4:	fb04fde3          	bgeu	s1,a6,80002c9e <alloc_disk_block+0x64>
            m = 1 << (bi % 8);
    80002ce8:	41f6579b          	sraiw	a5,a2,0x1f
    80002cec:	01d7d69b          	srliw	a3,a5,0x1d
    80002cf0:	00c6873b          	addw	a4,a3,a2
    80002cf4:	00777793          	andi	a5,a4,7
    80002cf8:	9f95                	subw	a5,a5,a3
    80002cfa:	00f997bb          	sllw	a5,s3,a5
            if ((bitmap->data[bi / 8] & m) == 0) { // 判断块是否被使用
    80002cfe:	4037571b          	sraiw	a4,a4,0x3
    80002d02:	00e506b3          	add	a3,a0,a4
    80002d06:	04c6c683          	lbu	a3,76(a3)
    80002d0a:	00d7f5b3          	and	a1,a5,a3
    80002d0e:	ddb9                	beqz	a1,80002c6c <alloc_disk_block+0x32>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) { //遍历bitmap的每一位
    80002d10:	2605                	addiw	a2,a2,1
    80002d12:	2485                	addiw	s1,s1,1
    80002d14:	fd4616e3          	bne	a2,s4,80002ce0 <alloc_disk_block+0xa6>
    80002d18:	b759                	j	80002c9e <alloc_disk_block+0x64>
    panic("balloc: out of blocks");
    80002d1a:	00003517          	auipc	a0,0x3
    80002d1e:	5fe50513          	addi	a0,a0,1534 # 80006318 <digits+0x218>
    80002d22:	fffff097          	auipc	ra,0xfffff
    80002d26:	954080e7          	jalr	-1708(ra) # 80001676 <panic>
    return 0;
    80002d2a:	4481                	li	s1,0
    80002d2c:	bfa9                	j	80002c86 <alloc_disk_block+0x4c>

0000000080002d2e <free_disk_block>:

// 释放磁盘块, 通过重置bitmap对应位。
void free_disk_block(int blockno) {
    80002d2e:	1101                	addi	sp,sp,-32
    80002d30:	ec06                	sd	ra,24(sp)
    80002d32:	e822                	sd	s0,16(sp)
    80002d34:	e426                	sd	s1,8(sp)
    80002d36:	e04a                	sd	s2,0(sp)
    80002d38:	1000                	addi	s0,sp,32
    struct buf *bitmap;
    int bi, m;
    bitmap = buf_read(0, BBLOCK(blockno, sb));
    80002d3a:	41f5549b          	sraiw	s1,a0,0x1f
    80002d3e:	0134d91b          	srliw	s2,s1,0x13
    80002d42:	00a904bb          	addw	s1,s2,a0
    80002d46:	40d4d59b          	sraiw	a1,s1,0xd
    80002d4a:	00092797          	auipc	a5,0x92
    80002d4e:	c827a783          	lw	a5,-894(a5) # 800949cc <sb+0x14>
    80002d52:	9dbd                	addw	a1,a1,a5
    80002d54:	4501                	li	a0,0
    80002d56:	00001097          	auipc	ra,0x1
    80002d5a:	cf8080e7          	jalr	-776(ra) # 80003a4e <buf_read>
    bi = blockno % BPB;
    80002d5e:	14ce                	slli	s1,s1,0x33
    80002d60:	90cd                	srli	s1,s1,0x33
    80002d62:	412484bb          	subw	s1,s1,s2
    m = 1 << (bi % 8);
    bitmap->data[bi / 8] &= ~m;
    80002d66:	41f4d79b          	sraiw	a5,s1,0x1f
    80002d6a:	01d7d79b          	srliw	a5,a5,0x1d
    80002d6e:	9cbd                	addw	s1,s1,a5
    80002d70:	4034d71b          	sraiw	a4,s1,0x3
    80002d74:	972a                	add	a4,a4,a0
    m = 1 << (bi % 8);
    80002d76:	889d                	andi	s1,s1,7
    80002d78:	9c9d                	subw	s1,s1,a5
    bitmap->data[bi / 8] &= ~m;
    80002d7a:	4785                	li	a5,1
    80002d7c:	009794bb          	sllw	s1,a5,s1
    80002d80:	fff4c493          	not	s1,s1
    80002d84:	04c74783          	lbu	a5,76(a4)
    80002d88:	8cfd                	and	s1,s1,a5
    80002d8a:	04970623          	sb	s1,76(a4)
    relse_buf(bitmap);
    80002d8e:	00001097          	auipc	ra,0x1
    80002d92:	d0e080e7          	jalr	-754(ra) # 80003a9c <relse_buf>
}
    80002d96:	60e2                	ld	ra,24(sp)
    80002d98:	6442                	ld	s0,16(sp)
    80002d9a:	64a2                	ld	s1,8(sp)
    80002d9c:	6902                	ld	s2,0(sp)
    80002d9e:	6105                	addi	sp,sp,32
    80002da0:	8082                	ret

0000000080002da2 <init_inode_cache>:
    struct inode inode[NINODE];
} inode_cache;


// 初始化inode的缓存
void init_inode_cache() {
    80002da2:	7179                	addi	sp,sp,-48
    80002da4:	f406                	sd	ra,40(sp)
    80002da6:	f022                	sd	s0,32(sp)
    80002da8:	ec26                	sd	s1,24(sp)
    80002daa:	e84a                	sd	s2,16(sp)
    80002dac:	e44e                	sd	s3,8(sp)
    80002dae:	1800                	addi	s0,sp,48
    spinlock_init(&inode_cache.lock, "inode cache");
    80002db0:	00003597          	auipc	a1,0x3
    80002db4:	58058593          	addi	a1,a1,1408 # 80006330 <digits+0x230>
    80002db8:	00092517          	auipc	a0,0x92
    80002dbc:	c1850513          	addi	a0,a0,-1000 # 800949d0 <inode_cache>
    80002dc0:	00001097          	auipc	ra,0x1
    80002dc4:	d2e080e7          	jalr	-722(ra) # 80003aee <spinlock_init>
    for (int i = 0; i < NINODE; i++) {
    80002dc8:	00092497          	auipc	s1,0x92
    80002dcc:	c3048493          	addi	s1,s1,-976 # 800949f8 <inode_cache+0x28>
    80002dd0:	00093997          	auipc	s3,0x93
    80002dd4:	6b898993          	addi	s3,s3,1720 # 80096488 <cache_lock+0x10>
        sleeplock_init(&inode_cache.inode[i].lock, "inode");
    80002dd8:	00003917          	auipc	s2,0x3
    80002ddc:	56890913          	addi	s2,s2,1384 # 80006340 <digits+0x240>
    80002de0:	85ca                	mv	a1,s2
    80002de2:	8526                	mv	a0,s1
    80002de4:	00001097          	auipc	ra,0x1
    80002de8:	eca080e7          	jalr	-310(ra) # 80003cae <sleeplock_init>
    for (int i = 0; i < NINODE; i++) {
    80002dec:	08848493          	addi	s1,s1,136
    80002df0:	ff3498e3          	bne	s1,s3,80002de0 <init_inode_cache+0x3e>
    }
}
    80002df4:	70a2                	ld	ra,40(sp)
    80002df6:	7402                	ld	s0,32(sp)
    80002df8:	64e2                	ld	s1,24(sp)
    80002dfa:	6942                	ld	s2,16(sp)
    80002dfc:	69a2                	ld	s3,8(sp)
    80002dfe:	6145                	addi	sp,sp,48
    80002e00:	8082                	ret

0000000080002e02 <update_inode>:

// 将内存中的inode写入到磁盘中,
// 每次改变磁盘上的ip->xxx字段都需要调用该函数，
// 因为inode cache是write-through。
// 调用者必须持有ip->lock.
void update_inode(struct inode *ip) {
    80002e02:	1101                	addi	sp,sp,-32
    80002e04:	ec06                	sd	ra,24(sp)
    80002e06:	e822                	sd	s0,16(sp)
    80002e08:	e426                	sd	s1,8(sp)
    80002e0a:	e04a                	sd	s2,0(sp)
    80002e0c:	1000                	addi	s0,sp,32
    80002e0e:	84aa                	mv	s1,a0
    struct buf *bp;
    struct dinode *dip;

    bp = buf_read(ip->dev, IBLOCK(ip->inum, sb));
    80002e10:	415c                	lw	a5,4(a0)
    80002e12:	0047d79b          	srliw	a5,a5,0x4
    80002e16:	00092597          	auipc	a1,0x92
    80002e1a:	bb25a583          	lw	a1,-1102(a1) # 800949c8 <sb+0x10>
    80002e1e:	9dbd                	addw	a1,a1,a5
    80002e20:	4108                	lw	a0,0(a0)
    80002e22:	00001097          	auipc	ra,0x1
    80002e26:	c2c080e7          	jalr	-980(ra) # 80003a4e <buf_read>
    80002e2a:	892a                	mv	s2,a0
    dip = (struct dinode *) bp->data + ip->inum % IPB;
    80002e2c:	04c50793          	addi	a5,a0,76
    80002e30:	40c8                	lw	a0,4(s1)
    80002e32:	893d                	andi	a0,a0,15
    80002e34:	051a                	slli	a0,a0,0x6
    80002e36:	953e                	add	a0,a0,a5
    dip->type = ip->type;
    80002e38:	04449703          	lh	a4,68(s1)
    80002e3c:	00e51023          	sh	a4,0(a0)
    dip->major = ip->major;
    80002e40:	04649703          	lh	a4,70(s1)
    80002e44:	00e51123          	sh	a4,2(a0)
    dip->minor = ip->minor;
    80002e48:	04849703          	lh	a4,72(s1)
    80002e4c:	00e51223          	sh	a4,4(a0)
    dip->nlink = ip->nlink;
    80002e50:	04a49703          	lh	a4,74(s1)
    80002e54:	00e51323          	sh	a4,6(a0)
    dip->size = ip->size;
    80002e58:	44f8                	lw	a4,76(s1)
    80002e5a:	c518                	sw	a4,8(a0)
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002e5c:	03400613          	li	a2,52
    80002e60:	05048593          	addi	a1,s1,80
    80002e64:	0531                	addi	a0,a0,12
    80002e66:	ffffe097          	auipc	ra,0xffffe
    80002e6a:	2b2080e7          	jalr	690(ra) # 80001118 <memmove>
    buf_write(bp);
    80002e6e:	854a                	mv	a0,s2
    80002e70:	00001097          	auipc	ra,0x1
    80002e74:	c12080e7          	jalr	-1006(ra) # 80003a82 <buf_write>
    relse_buf(bp);
    80002e78:	854a                	mv	a0,s2
    80002e7a:	00001097          	auipc	ra,0x1
    80002e7e:	c22080e7          	jalr	-990(ra) # 80003a9c <relse_buf>
}
    80002e82:	60e2                	ld	ra,24(sp)
    80002e84:	6442                	ld	s0,16(sp)
    80002e86:	64a2                	ld	s1,8(sp)
    80002e88:	6902                	ld	s2,0(sp)
    80002e8a:	6105                	addi	sp,sp,32
    80002e8c:	8082                	ret

0000000080002e8e <get_inode>:

// 通过inum从缓冲池中获取一个inode
struct inode *get_inode(int inum) {
    80002e8e:	7179                	addi	sp,sp,-48
    80002e90:	f406                	sd	ra,40(sp)
    80002e92:	f022                	sd	s0,32(sp)
    80002e94:	ec26                	sd	s1,24(sp)
    80002e96:	e84a                	sd	s2,16(sp)
    80002e98:	e44e                	sd	s3,8(sp)
    80002e9a:	1800                	addi	s0,sp,48
    80002e9c:	89aa                	mv	s3,a0
    struct inode *ip;
    struct inode *empty;
//    struct buf *bp;
//    struct dinode *dip;

    spin_lock(&inode_cache.lock);
    80002e9e:	00092517          	auipc	a0,0x92
    80002ea2:	b3250513          	addi	a0,a0,-1230 # 800949d0 <inode_cache>
    80002ea6:	00001097          	auipc	ra,0x1
    80002eaa:	cd8080e7          	jalr	-808(ra) # 80003b7e <spin_lock>
    empty = 0;
    80002eae:	4901                	li	s2,0
    for (ip = &inode_cache.inode[0]; ip < &inode_cache.inode[NINODE]; ip++) {
    80002eb0:	00092497          	auipc	s1,0x92
    80002eb4:	b3848493          	addi	s1,s1,-1224 # 800949e8 <inode_cache+0x18>
        if (ip->ref > 0 && ip->inum == inum) {
    80002eb8:	0009861b          	sext.w	a2,s3
    for (ip = &inode_cache.inode[0]; ip < &inode_cache.inode[NINODE]; ip++) {
    80002ebc:	00093697          	auipc	a3,0x93
    80002ec0:	5bc68693          	addi	a3,a3,1468 # 80096478 <cache_lock>
    80002ec4:	a039                	j	80002ed2 <get_inode+0x44>
            ip->ref++;
            spin_unlock(&inode_cache.lock);
            return ip;
        }
        if (empty == 0 && ip->ref == 0) { // 记住未使用缓冲项
    80002ec6:	02090e63          	beqz	s2,80002f02 <get_inode+0x74>
    for (ip = &inode_cache.inode[0]; ip < &inode_cache.inode[NINODE]; ip++) {
    80002eca:	08848493          	addi	s1,s1,136
    80002ece:	02d48d63          	beq	s1,a3,80002f08 <get_inode+0x7a>
        if (ip->ref > 0 && ip->inum == inum) {
    80002ed2:	449c                	lw	a5,8(s1)
    80002ed4:	fef059e3          	blez	a5,80002ec6 <get_inode+0x38>
    80002ed8:	40d8                	lw	a4,4(s1)
    80002eda:	fec716e3          	bne	a4,a2,80002ec6 <get_inode+0x38>
            ip->ref++;
    80002ede:	2785                	addiw	a5,a5,1
    80002ee0:	c49c                	sw	a5,8(s1)
            spin_unlock(&inode_cache.lock);
    80002ee2:	00092517          	auipc	a0,0x92
    80002ee6:	aee50513          	addi	a0,a0,-1298 # 800949d0 <inode_cache>
    80002eea:	00001097          	auipc	ra,0x1
    80002eee:	d68080e7          	jalr	-664(ra) # 80003c52 <spin_unlock>
    ip->inum = inum;
    ip->ref = 1;
    ip->valid = 0;
    spin_unlock(&inode_cache.lock);
    return ip;
}
    80002ef2:	8526                	mv	a0,s1
    80002ef4:	70a2                	ld	ra,40(sp)
    80002ef6:	7402                	ld	s0,32(sp)
    80002ef8:	64e2                	ld	s1,24(sp)
    80002efa:	6942                	ld	s2,16(sp)
    80002efc:	69a2                	ld	s3,8(sp)
    80002efe:	6145                	addi	sp,sp,48
    80002f00:	8082                	ret
        if (empty == 0 && ip->ref == 0) { // 记住未使用缓冲项
    80002f02:	f7e1                	bnez	a5,80002eca <get_inode+0x3c>
    80002f04:	8926                	mv	s2,s1
    80002f06:	b7d1                	j	80002eca <get_inode+0x3c>
    if (empty == 0) {
    80002f08:	02090363          	beqz	s2,80002f2e <get_inode+0xa0>
    ip->inum = inum;
    80002f0c:	01392223          	sw	s3,4(s2)
    ip->ref = 1;
    80002f10:	4785                	li	a5,1
    80002f12:	00f92423          	sw	a5,8(s2)
    ip->valid = 0;
    80002f16:	04092023          	sw	zero,64(s2)
    spin_unlock(&inode_cache.lock);
    80002f1a:	00092517          	auipc	a0,0x92
    80002f1e:	ab650513          	addi	a0,a0,-1354 # 800949d0 <inode_cache>
    80002f22:	00001097          	auipc	ra,0x1
    80002f26:	d30080e7          	jalr	-720(ra) # 80003c52 <spin_unlock>
    return ip;
    80002f2a:	84ca                	mv	s1,s2
    80002f2c:	b7d9                	j	80002ef2 <get_inode+0x64>
        panic("get_inode");
    80002f2e:	00003517          	auipc	a0,0x3
    80002f32:	41a50513          	addi	a0,a0,1050 # 80006348 <digits+0x248>
    80002f36:	ffffe097          	auipc	ra,0xffffe
    80002f3a:	740080e7          	jalr	1856(ra) # 80001676 <panic>
    80002f3e:	b7f9                	j	80002f0c <get_inode+0x7e>

0000000080002f40 <alloc_inode>:
struct inode *alloc_inode(short type) {
    80002f40:	7139                	addi	sp,sp,-64
    80002f42:	fc06                	sd	ra,56(sp)
    80002f44:	f822                	sd	s0,48(sp)
    80002f46:	f426                	sd	s1,40(sp)
    80002f48:	f04a                	sd	s2,32(sp)
    80002f4a:	ec4e                	sd	s3,24(sp)
    80002f4c:	e852                	sd	s4,16(sp)
    80002f4e:	e456                	sd	s5,8(sp)
    80002f50:	e05a                	sd	s6,0(sp)
    80002f52:	0080                	addi	s0,sp,64
    for (inum = 1; inum < sb.ninodes; inum++) {
    80002f54:	00092717          	auipc	a4,0x92
    80002f58:	a7072703          	lw	a4,-1424(a4) # 800949c4 <sb+0xc>
    80002f5c:	4785                	li	a5,1
    80002f5e:	04e7f963          	bgeu	a5,a4,80002fb0 <alloc_inode+0x70>
    80002f62:	8b2a                	mv	s6,a0
    80002f64:	4905                	li	s2,1
        bp = buf_read(0, IBLOCK(inum, sb));
    80002f66:	00092a97          	auipc	s5,0x92
    80002f6a:	a52a8a93          	addi	s5,s5,-1454 # 800949b8 <sb>
    80002f6e:	00090a1b          	sext.w	s4,s2
    80002f72:	00495593          	srli	a1,s2,0x4
    80002f76:	010aa783          	lw	a5,16(s5)
    80002f7a:	9dbd                	addw	a1,a1,a5
    80002f7c:	4501                	li	a0,0
    80002f7e:	00001097          	auipc	ra,0x1
    80002f82:	ad0080e7          	jalr	-1328(ra) # 80003a4e <buf_read>
    80002f86:	84aa                	mv	s1,a0
        dip = (struct dinode *) bp->data + inum % IPB;
    80002f88:	04c50993          	addi	s3,a0,76
    80002f8c:	00fa7793          	andi	a5,s4,15
    80002f90:	079a                	slli	a5,a5,0x6
    80002f92:	99be                	add	s3,s3,a5
        if (dip->type == 0) { // a free inode
    80002f94:	00099783          	lh	a5,0(s3)
    80002f98:	cf9d                	beqz	a5,80002fd6 <alloc_inode+0x96>
        relse_buf(bp);
    80002f9a:	00001097          	auipc	ra,0x1
    80002f9e:	b02080e7          	jalr	-1278(ra) # 80003a9c <relse_buf>
    for (inum = 1; inum < sb.ninodes; inum++) {
    80002fa2:	0905                	addi	s2,s2,1
    80002fa4:	00caa703          	lw	a4,12(s5)
    80002fa8:	0009079b          	sext.w	a5,s2
    80002fac:	fce7e1e3          	bltu	a5,a4,80002f6e <alloc_inode+0x2e>
    panic("alloc_inode: no inodes");
    80002fb0:	00003517          	auipc	a0,0x3
    80002fb4:	3a850513          	addi	a0,a0,936 # 80006358 <digits+0x258>
    80002fb8:	ffffe097          	auipc	ra,0xffffe
    80002fbc:	6be080e7          	jalr	1726(ra) # 80001676 <panic>
    return 0;
    80002fc0:	4501                	li	a0,0
}
    80002fc2:	70e2                	ld	ra,56(sp)
    80002fc4:	7442                	ld	s0,48(sp)
    80002fc6:	74a2                	ld	s1,40(sp)
    80002fc8:	7902                	ld	s2,32(sp)
    80002fca:	69e2                	ld	s3,24(sp)
    80002fcc:	6a42                	ld	s4,16(sp)
    80002fce:	6aa2                	ld	s5,8(sp)
    80002fd0:	6b02                	ld	s6,0(sp)
    80002fd2:	6121                	addi	sp,sp,64
    80002fd4:	8082                	ret
            memset(dip, 0, sizeof(*dip));
    80002fd6:	04000613          	li	a2,64
    80002fda:	4581                	li	a1,0
    80002fdc:	854e                	mv	a0,s3
    80002fde:	ffffe097          	auipc	ra,0xffffe
    80002fe2:	114080e7          	jalr	276(ra) # 800010f2 <memset>
            dip->type = type;
    80002fe6:	01699023          	sh	s6,0(s3)
            buf_write(bp); // 写回磁盘
    80002fea:	8526                	mv	a0,s1
    80002fec:	00001097          	auipc	ra,0x1
    80002ff0:	a96080e7          	jalr	-1386(ra) # 80003a82 <buf_write>
            relse_buf(bp);
    80002ff4:	8526                	mv	a0,s1
    80002ff6:	00001097          	auipc	ra,0x1
    80002ffa:	aa6080e7          	jalr	-1370(ra) # 80003a9c <relse_buf>
            return get_inode(inum);
    80002ffe:	8552                	mv	a0,s4
    80003000:	00000097          	auipc	ra,0x0
    80003004:	e8e080e7          	jalr	-370(ra) # 80002e8e <get_inode>
    80003008:	bf6d                	j	80002fc2 <alloc_inode+0x82>

000000008000300a <bmap>:
    spin_unlock(&inode_cache.lock);
}

// 数据块包含直接块和间接块，这里只实现了直接块
// 获取inode的第bn个数据块对应的磁盘块号
uint bmap(struct inode *ip, uint bn) {
    8000300a:	7179                	addi	sp,sp,-48
    8000300c:	f406                	sd	ra,40(sp)
    8000300e:	f022                	sd	s0,32(sp)
    80003010:	ec26                	sd	s1,24(sp)
    80003012:	e84a                	sd	s2,16(sp)
    80003014:	e44e                	sd	s3,8(sp)
    80003016:	1800                	addi	s0,sp,48
    80003018:	892a                	mv	s2,a0
    uint addr, *indirect;
    struct buf *bp;
    if (bn < NDIRECT) {
    8000301a:	47ad                	li	a5,11
    8000301c:	04b7fa63          	bgeu	a5,a1,80003070 <bmap+0x66>
        if ((addr = ip->addrs[bn]) == 0)
            ip->addrs[bn] = addr = alloc_disk_block();
        return addr;
    }
    bn -= NDIRECT;
    80003020:	ff45849b          	addiw	s1,a1,-12
    80003024:	0004871b          	sext.w	a4,s1

    // 间接块
    if (bn < NINDIRECT) {
    80003028:	0ff00793          	li	a5,255
    8000302c:	08e7ea63          	bltu	a5,a4,800030c0 <bmap+0xb6>
        // 获取indirect块，如果没有需要申请
        if ((addr = ip->addrs[NDIRECT]) == 0) {
    80003030:	08052583          	lw	a1,128(a0)
    80003034:	cdb9                	beqz	a1,80003092 <bmap+0x88>
            ip->addrs[NDIRECT] = addr = alloc_disk_block();
        }
        bp = buf_read(0, addr);
    80003036:	4501                	li	a0,0
    80003038:	00001097          	auipc	ra,0x1
    8000303c:	a16080e7          	jalr	-1514(ra) # 80003a4e <buf_read>
    80003040:	892a                	mv	s2,a0
        indirect = (uint *) (bp->data);
    80003042:	04c50993          	addi	s3,a0,76
        if ((addr = indirect[bn]) == 0) {
    80003046:	02049593          	slli	a1,s1,0x20
    8000304a:	9181                	srli	a1,a1,0x20
    8000304c:	058a                	slli	a1,a1,0x2
    8000304e:	99ae                	add	s3,s3,a1
    80003050:	0009a483          	lw	s1,0(s3)
    80003054:	c8a1                	beqz	s1,800030a4 <bmap+0x9a>
            addr = indirect[bn] = alloc_disk_block();
            buf_write(bp);
        }
        relse_buf(bp);
    80003056:	854a                	mv	a0,s2
    80003058:	00001097          	auipc	ra,0x1
    8000305c:	a44080e7          	jalr	-1468(ra) # 80003a9c <relse_buf>
        return addr;
    }

    panic("bmap");
    return 0;
}
    80003060:	8526                	mv	a0,s1
    80003062:	70a2                	ld	ra,40(sp)
    80003064:	7402                	ld	s0,32(sp)
    80003066:	64e2                	ld	s1,24(sp)
    80003068:	6942                	ld	s2,16(sp)
    8000306a:	69a2                	ld	s3,8(sp)
    8000306c:	6145                	addi	sp,sp,48
    8000306e:	8082                	ret
        if ((addr = ip->addrs[bn]) == 0)
    80003070:	1582                	slli	a1,a1,0x20
    80003072:	9181                	srli	a1,a1,0x20
    80003074:	058a                	slli	a1,a1,0x2
    80003076:	00b50933          	add	s2,a0,a1
    8000307a:	05092483          	lw	s1,80(s2)
    8000307e:	f0ed                	bnez	s1,80003060 <bmap+0x56>
            ip->addrs[bn] = addr = alloc_disk_block();
    80003080:	00000097          	auipc	ra,0x0
    80003084:	bba080e7          	jalr	-1094(ra) # 80002c3a <alloc_disk_block>
    80003088:	0005049b          	sext.w	s1,a0
    8000308c:	04992823          	sw	s1,80(s2)
    80003090:	bfc1                	j	80003060 <bmap+0x56>
            ip->addrs[NDIRECT] = addr = alloc_disk_block();
    80003092:	00000097          	auipc	ra,0x0
    80003096:	ba8080e7          	jalr	-1112(ra) # 80002c3a <alloc_disk_block>
    8000309a:	0005059b          	sext.w	a1,a0
    8000309e:	08b92023          	sw	a1,128(s2)
    800030a2:	bf51                	j	80003036 <bmap+0x2c>
            addr = indirect[bn] = alloc_disk_block();
    800030a4:	00000097          	auipc	ra,0x0
    800030a8:	b96080e7          	jalr	-1130(ra) # 80002c3a <alloc_disk_block>
    800030ac:	0005049b          	sext.w	s1,a0
    800030b0:	0099a023          	sw	s1,0(s3)
            buf_write(bp);
    800030b4:	854a                	mv	a0,s2
    800030b6:	00001097          	auipc	ra,0x1
    800030ba:	9cc080e7          	jalr	-1588(ra) # 80003a82 <buf_write>
    800030be:	bf61                	j	80003056 <bmap+0x4c>
    panic("bmap");
    800030c0:	00003517          	auipc	a0,0x3
    800030c4:	2b050513          	addi	a0,a0,688 # 80006370 <digits+0x270>
    800030c8:	ffffe097          	auipc	ra,0xffffe
    800030cc:	5ae080e7          	jalr	1454(ra) # 80001676 <panic>
    return 0;
    800030d0:	4481                	li	s1,0
    800030d2:	b779                	j	80003060 <bmap+0x56>

00000000800030d4 <trunc_inode>:

// Truncate inode(移除内容)
// 调用者必须持有ip->lock
void trunc_inode(struct inode *ip) {
    800030d4:	7179                	addi	sp,sp,-48
    800030d6:	f406                	sd	ra,40(sp)
    800030d8:	f022                	sd	s0,32(sp)
    800030da:	ec26                	sd	s1,24(sp)
    800030dc:	e84a                	sd	s2,16(sp)
    800030de:	e44e                	sd	s3,8(sp)
    800030e0:	e052                	sd	s4,0(sp)
    800030e2:	1800                	addi	s0,sp,48
    800030e4:	89aa                	mv	s3,a0
    int i, j;
    struct buf *bp;
    uint *a;

    for (i = 0; i < NDIRECT; i++) {
    800030e6:	05050493          	addi	s1,a0,80
    800030ea:	08050913          	addi	s2,a0,128
    800030ee:	a021                	j	800030f6 <trunc_inode+0x22>
    800030f0:	0491                	addi	s1,s1,4
    800030f2:	01248b63          	beq	s1,s2,80003108 <trunc_inode+0x34>
        if (ip->addrs[i]) {
    800030f6:	4088                	lw	a0,0(s1)
    800030f8:	dd65                	beqz	a0,800030f0 <trunc_inode+0x1c>
            free_disk_block(ip->addrs[i]);
    800030fa:	00000097          	auipc	ra,0x0
    800030fe:	c34080e7          	jalr	-972(ra) # 80002d2e <free_disk_block>
            ip->addrs[i] = 0;
    80003102:	0004a023          	sw	zero,0(s1)
    80003106:	b7ed                	j	800030f0 <trunc_inode+0x1c>
        }
    }

    if (ip->addrs[NDIRECT]) {
    80003108:	0809a583          	lw	a1,128(s3)
    8000310c:	e185                	bnez	a1,8000312c <trunc_inode+0x58>
        relse_buf(bp);
        free_disk_block(ip->addrs[NDIRECT]);
        ip->addrs[NDIRECT] = 0;
    }

    ip->size = 0;
    8000310e:	0409a623          	sw	zero,76(s3)
    update_inode(ip);
    80003112:	854e                	mv	a0,s3
    80003114:	00000097          	auipc	ra,0x0
    80003118:	cee080e7          	jalr	-786(ra) # 80002e02 <update_inode>
}
    8000311c:	70a2                	ld	ra,40(sp)
    8000311e:	7402                	ld	s0,32(sp)
    80003120:	64e2                	ld	s1,24(sp)
    80003122:	6942                	ld	s2,16(sp)
    80003124:	69a2                	ld	s3,8(sp)
    80003126:	6a02                	ld	s4,0(sp)
    80003128:	6145                	addi	sp,sp,48
    8000312a:	8082                	ret
        bp = buf_read(ip->dev, ip->addrs[NDIRECT]);
    8000312c:	0009a503          	lw	a0,0(s3)
    80003130:	00001097          	auipc	ra,0x1
    80003134:	91e080e7          	jalr	-1762(ra) # 80003a4e <buf_read>
    80003138:	8a2a                	mv	s4,a0
        for (j = 0; j < NINDIRECT; j++) {
    8000313a:	04c50493          	addi	s1,a0,76
    8000313e:	44c50913          	addi	s2,a0,1100
    80003142:	a801                	j	80003152 <trunc_inode+0x7e>
                free_disk_block(a[j]);
    80003144:	00000097          	auipc	ra,0x0
    80003148:	bea080e7          	jalr	-1046(ra) # 80002d2e <free_disk_block>
        for (j = 0; j < NINDIRECT; j++) {
    8000314c:	0491                	addi	s1,s1,4
    8000314e:	01248563          	beq	s1,s2,80003158 <trunc_inode+0x84>
            if (a[j])
    80003152:	4088                	lw	a0,0(s1)
    80003154:	dd65                	beqz	a0,8000314c <trunc_inode+0x78>
    80003156:	b7fd                	j	80003144 <trunc_inode+0x70>
        relse_buf(bp);
    80003158:	8552                	mv	a0,s4
    8000315a:	00001097          	auipc	ra,0x1
    8000315e:	942080e7          	jalr	-1726(ra) # 80003a9c <relse_buf>
        free_disk_block(ip->addrs[NDIRECT]);
    80003162:	0809a503          	lw	a0,128(s3)
    80003166:	00000097          	auipc	ra,0x0
    8000316a:	bc8080e7          	jalr	-1080(ra) # 80002d2e <free_disk_block>
        ip->addrs[NDIRECT] = 0;
    8000316e:	0809a023          	sw	zero,128(s3)
    80003172:	bf71                	j	8000310e <trunc_inode+0x3a>

0000000080003174 <putback_inode>:
void putback_inode(struct inode *ip) {
    80003174:	1101                	addi	sp,sp,-32
    80003176:	ec06                	sd	ra,24(sp)
    80003178:	e822                	sd	s0,16(sp)
    8000317a:	e426                	sd	s1,8(sp)
    8000317c:	e04a                	sd	s2,0(sp)
    8000317e:	1000                	addi	s0,sp,32
    80003180:	84aa                	mv	s1,a0
    spin_lock(&inode_cache.lock);
    80003182:	00092517          	auipc	a0,0x92
    80003186:	84e50513          	addi	a0,a0,-1970 # 800949d0 <inode_cache>
    8000318a:	00001097          	auipc	ra,0x1
    8000318e:	9f4080e7          	jalr	-1548(ra) # 80003b7e <spin_lock>
    if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    80003192:	4498                	lw	a4,8(s1)
    80003194:	4785                	li	a5,1
    80003196:	02f70363          	beq	a4,a5,800031bc <putback_inode+0x48>
    ip->ref--;
    8000319a:	449c                	lw	a5,8(s1)
    8000319c:	37fd                	addiw	a5,a5,-1
    8000319e:	c49c                	sw	a5,8(s1)
    spin_unlock(&inode_cache.lock);
    800031a0:	00092517          	auipc	a0,0x92
    800031a4:	83050513          	addi	a0,a0,-2000 # 800949d0 <inode_cache>
    800031a8:	00001097          	auipc	ra,0x1
    800031ac:	aaa080e7          	jalr	-1366(ra) # 80003c52 <spin_unlock>
}
    800031b0:	60e2                	ld	ra,24(sp)
    800031b2:	6442                	ld	s0,16(sp)
    800031b4:	64a2                	ld	s1,8(sp)
    800031b6:	6902                	ld	s2,0(sp)
    800031b8:	6105                	addi	sp,sp,32
    800031ba:	8082                	ret
    if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    800031bc:	40bc                	lw	a5,64(s1)
    800031be:	dff1                	beqz	a5,8000319a <putback_inode+0x26>
    800031c0:	04a49783          	lh	a5,74(s1)
    800031c4:	fbf9                	bnez	a5,8000319a <putback_inode+0x26>
        sleep_lock(&ip->lock);
    800031c6:	01048913          	addi	s2,s1,16
    800031ca:	854a                	mv	a0,s2
    800031cc:	00001097          	auipc	ra,0x1
    800031d0:	b1c080e7          	jalr	-1252(ra) # 80003ce8 <sleep_lock>
        spin_unlock(&inode_cache.lock);
    800031d4:	00091517          	auipc	a0,0x91
    800031d8:	7fc50513          	addi	a0,a0,2044 # 800949d0 <inode_cache>
    800031dc:	00001097          	auipc	ra,0x1
    800031e0:	a76080e7          	jalr	-1418(ra) # 80003c52 <spin_unlock>
        trunc_inode(ip);
    800031e4:	8526                	mv	a0,s1
    800031e6:	00000097          	auipc	ra,0x0
    800031ea:	eee080e7          	jalr	-274(ra) # 800030d4 <trunc_inode>
        ip->type = 0;
    800031ee:	04049223          	sh	zero,68(s1)
        update_inode(ip);
    800031f2:	8526                	mv	a0,s1
    800031f4:	00000097          	auipc	ra,0x0
    800031f8:	c0e080e7          	jalr	-1010(ra) # 80002e02 <update_inode>
        ip->valid = 0;
    800031fc:	0404a023          	sw	zero,64(s1)
        sleep_unlock(&ip->lock);
    80003200:	854a                	mv	a0,s2
    80003202:	00001097          	auipc	ra,0x1
    80003206:	b3c080e7          	jalr	-1220(ra) # 80003d3e <sleep_unlock>
        spin_lock(&inode_cache.lock);
    8000320a:	00091517          	auipc	a0,0x91
    8000320e:	7c650513          	addi	a0,a0,1990 # 800949d0 <inode_cache>
    80003212:	00001097          	auipc	ra,0x1
    80003216:	96c080e7          	jalr	-1684(ra) # 80003b7e <spin_lock>
    8000321a:	b741                	j	8000319a <putback_inode+0x26>

000000008000321c <dup_inode>:

// 递增ip->ref
struct inode *dup_inode(struct inode *ip) {
    8000321c:	1101                	addi	sp,sp,-32
    8000321e:	ec06                	sd	ra,24(sp)
    80003220:	e822                	sd	s0,16(sp)
    80003222:	e426                	sd	s1,8(sp)
    80003224:	1000                	addi	s0,sp,32
    80003226:	84aa                	mv	s1,a0
    spin_lock(&inode_cache.lock);
    80003228:	00091517          	auipc	a0,0x91
    8000322c:	7a850513          	addi	a0,a0,1960 # 800949d0 <inode_cache>
    80003230:	00001097          	auipc	ra,0x1
    80003234:	94e080e7          	jalr	-1714(ra) # 80003b7e <spin_lock>
    ip->ref++;
    80003238:	449c                	lw	a5,8(s1)
    8000323a:	2785                	addiw	a5,a5,1
    8000323c:	c49c                	sw	a5,8(s1)
    spin_unlock(&inode_cache.lock);
    8000323e:	00091517          	auipc	a0,0x91
    80003242:	79250513          	addi	a0,a0,1938 # 800949d0 <inode_cache>
    80003246:	00001097          	auipc	ra,0x1
    8000324a:	a0c080e7          	jalr	-1524(ra) # 80003c52 <spin_unlock>
    return ip;
}
    8000324e:	8526                	mv	a0,s1
    80003250:	60e2                	ld	ra,24(sp)
    80003252:	6442                	ld	s0,16(sp)
    80003254:	64a2                	ld	s1,8(sp)
    80003256:	6105                	addi	sp,sp,32
    80003258:	8082                	ret

000000008000325a <lock_inode>:

// 锁定给定的inode
// 需要时读取从磁盘读数据
void lock_inode(struct inode *ip) {
    8000325a:	1101                	addi	sp,sp,-32
    8000325c:	ec06                	sd	ra,24(sp)
    8000325e:	e822                	sd	s0,16(sp)
    80003260:	e426                	sd	s1,8(sp)
    80003262:	e04a                	sd	s2,0(sp)
    80003264:	1000                	addi	s0,sp,32
    80003266:	84aa                	mv	s1,a0
    struct buf *bp;
    struct dinode *dip;

    if (ip == 0 || ip->ref < 1)
    80003268:	c501                	beqz	a0,80003270 <lock_inode+0x16>
    8000326a:	451c                	lw	a5,8(a0)
    8000326c:	00f04a63          	bgtz	a5,80003280 <lock_inode+0x26>
        panic("lock_inode");
    80003270:	00003517          	auipc	a0,0x3
    80003274:	10850513          	addi	a0,a0,264 # 80006378 <digits+0x278>
    80003278:	ffffe097          	auipc	ra,0xffffe
    8000327c:	3fe080e7          	jalr	1022(ra) # 80001676 <panic>

    sleep_lock(&ip->lock);
    80003280:	01048513          	addi	a0,s1,16
    80003284:	00001097          	auipc	ra,0x1
    80003288:	a64080e7          	jalr	-1436(ra) # 80003ce8 <sleep_lock>
    if (ip->valid == 0) {
    8000328c:	40bc                	lw	a5,64(s1)
    8000328e:	c799                	beqz	a5,8000329c <lock_inode+0x42>
        relse_buf(bp);
        ip->valid = 1;
        if (ip->type == 0)
            panic("lock_inode: no type");
    }
}
    80003290:	60e2                	ld	ra,24(sp)
    80003292:	6442                	ld	s0,16(sp)
    80003294:	64a2                	ld	s1,8(sp)
    80003296:	6902                	ld	s2,0(sp)
    80003298:	6105                	addi	sp,sp,32
    8000329a:	8082                	ret
        bp = buf_read(ip->dev, IBLOCK(ip->inum, sb));
    8000329c:	40dc                	lw	a5,4(s1)
    8000329e:	0047d79b          	srliw	a5,a5,0x4
    800032a2:	00091597          	auipc	a1,0x91
    800032a6:	7265a583          	lw	a1,1830(a1) # 800949c8 <sb+0x10>
    800032aa:	9dbd                	addw	a1,a1,a5
    800032ac:	4088                	lw	a0,0(s1)
    800032ae:	00000097          	auipc	ra,0x0
    800032b2:	7a0080e7          	jalr	1952(ra) # 80003a4e <buf_read>
    800032b6:	892a                	mv	s2,a0
        dip = (struct dinode *) bp->data + ip->inum % IPB;
    800032b8:	04c50593          	addi	a1,a0,76
    800032bc:	40dc                	lw	a5,4(s1)
    800032be:	8bbd                	andi	a5,a5,15
    800032c0:	079a                	slli	a5,a5,0x6
    800032c2:	95be                	add	a1,a1,a5
        ip->type = dip->type;
    800032c4:	00059783          	lh	a5,0(a1)
    800032c8:	04f49223          	sh	a5,68(s1)
        ip->major = dip->major;
    800032cc:	00259783          	lh	a5,2(a1)
    800032d0:	04f49323          	sh	a5,70(s1)
        ip->minor = dip->minor;
    800032d4:	00459783          	lh	a5,4(a1)
    800032d8:	04f49423          	sh	a5,72(s1)
        ip->nlink = dip->nlink;
    800032dc:	00659783          	lh	a5,6(a1)
    800032e0:	04f49523          	sh	a5,74(s1)
        ip->size = dip->size;
    800032e4:	459c                	lw	a5,8(a1)
    800032e6:	c4fc                	sw	a5,76(s1)
        memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800032e8:	03400613          	li	a2,52
    800032ec:	05b1                	addi	a1,a1,12
    800032ee:	05048513          	addi	a0,s1,80
    800032f2:	ffffe097          	auipc	ra,0xffffe
    800032f6:	e26080e7          	jalr	-474(ra) # 80001118 <memmove>
        relse_buf(bp);
    800032fa:	854a                	mv	a0,s2
    800032fc:	00000097          	auipc	ra,0x0
    80003300:	7a0080e7          	jalr	1952(ra) # 80003a9c <relse_buf>
        ip->valid = 1;
    80003304:	4785                	li	a5,1
    80003306:	c0bc                	sw	a5,64(s1)
        if (ip->type == 0)
    80003308:	04449783          	lh	a5,68(s1)
    8000330c:	f3d1                	bnez	a5,80003290 <lock_inode+0x36>
            panic("lock_inode: no type");
    8000330e:	00003517          	auipc	a0,0x3
    80003312:	07a50513          	addi	a0,a0,122 # 80006388 <digits+0x288>
    80003316:	ffffe097          	auipc	ra,0xffffe
    8000331a:	360080e7          	jalr	864(ra) # 80001676 <panic>
}
    8000331e:	bf8d                	j	80003290 <lock_inode+0x36>

0000000080003320 <unlock_inode>:

// 解锁inode.
void unlock_inode(struct inode *ip) {
    80003320:	1101                	addi	sp,sp,-32
    80003322:	ec06                	sd	ra,24(sp)
    80003324:	e822                	sd	s0,16(sp)
    80003326:	e426                	sd	s1,8(sp)
    80003328:	1000                	addi	s0,sp,32
    8000332a:	84aa                	mv	s1,a0
    if (ip == 0 || !sleep_holding(&ip->lock) || ip->ref < 1)
    8000332c:	c911                	beqz	a0,80003340 <unlock_inode+0x20>
    8000332e:	0541                	addi	a0,a0,16
    80003330:	00001097          	auipc	ra,0x1
    80003334:	a52080e7          	jalr	-1454(ra) # 80003d82 <sleep_holding>
    80003338:	c501                	beqz	a0,80003340 <unlock_inode+0x20>
    8000333a:	449c                	lw	a5,8(s1)
    8000333c:	00f04a63          	bgtz	a5,80003350 <unlock_inode+0x30>
        panic("unlock_inode");
    80003340:	00003517          	auipc	a0,0x3
    80003344:	06050513          	addi	a0,a0,96 # 800063a0 <digits+0x2a0>
    80003348:	ffffe097          	auipc	ra,0xffffe
    8000334c:	32e080e7          	jalr	814(ra) # 80001676 <panic>
    sleep_unlock(&ip->lock);
    80003350:	01048513          	addi	a0,s1,16
    80003354:	00001097          	auipc	ra,0x1
    80003358:	9ea080e7          	jalr	-1558(ra) # 80003d3e <sleep_unlock>
}
    8000335c:	60e2                	ld	ra,24(sp)
    8000335e:	6442                	ld	s0,16(sp)
    80003360:	64a2                	ld	s1,8(sp)
    80003362:	6105                	addi	sp,sp,32
    80003364:	8082                	ret

0000000080003366 <unlock_and_putback>:

void unlock_and_putback(struct inode *ip) {
    80003366:	1101                	addi	sp,sp,-32
    80003368:	ec06                	sd	ra,24(sp)
    8000336a:	e822                	sd	s0,16(sp)
    8000336c:	e426                	sd	s1,8(sp)
    8000336e:	1000                	addi	s0,sp,32
    80003370:	84aa                	mv	s1,a0
    unlock_inode(ip);
    80003372:	00000097          	auipc	ra,0x0
    80003376:	fae080e7          	jalr	-82(ra) # 80003320 <unlock_inode>
    putback_inode(ip);
    8000337a:	8526                	mv	a0,s1
    8000337c:	00000097          	auipc	ra,0x0
    80003380:	df8080e7          	jalr	-520(ra) # 80003174 <putback_inode>
}
    80003384:	60e2                	ld	ra,24(sp)
    80003386:	6442                	ld	s0,16(sp)
    80003388:	64a2                	ld	s1,8(sp)
    8000338a:	6105                	addi	sp,sp,32
    8000338c:	8082                	ret

000000008000338e <stat_inode>:

/**
 * 获取inode的元数据
 */

void stat_inode(struct inode *ip, struct stat *stat) {
    8000338e:	1141                	addi	sp,sp,-16
    80003390:	e422                	sd	s0,8(sp)
    80003392:	0800                	addi	s0,sp,16
    stat->type = ip->type;
    80003394:	04451783          	lh	a5,68(a0)
    80003398:	00f59423          	sh	a5,8(a1)
    stat->nlink = ip->nlink;
    8000339c:	04a51783          	lh	a5,74(a0)
    800033a0:	00f59523          	sh	a5,10(a1)
    stat->size = ip->size;
    800033a4:	04c56783          	lwu	a5,76(a0)
    800033a8:	e99c                	sd	a5,16(a1)
    stat->dev = ip->dev;
    800033aa:	411c                	lw	a5,0(a0)
    800033ac:	c19c                	sw	a5,0(a1)
    stat->ino = stat->ino;
}
    800033ae:	6422                	ld	s0,8(sp)
    800033b0:	0141                	addi	sp,sp,16
    800033b2:	8082                	ret

00000000800033b4 <read_inode>:

// 从inode中读取数据
int read_inode(struct inode *ip, int user_dst, uint64 dst, uint off, int n) {
    800033b4:	7119                	addi	sp,sp,-128
    800033b6:	fc86                	sd	ra,120(sp)
    800033b8:	f8a2                	sd	s0,112(sp)
    800033ba:	f4a6                	sd	s1,104(sp)
    800033bc:	f0ca                	sd	s2,96(sp)
    800033be:	ecce                	sd	s3,88(sp)
    800033c0:	e8d2                	sd	s4,80(sp)
    800033c2:	e4d6                	sd	s5,72(sp)
    800033c4:	e0da                	sd	s6,64(sp)
    800033c6:	fc5e                	sd	s7,56(sp)
    800033c8:	f862                	sd	s8,48(sp)
    800033ca:	f466                	sd	s9,40(sp)
    800033cc:	f06a                	sd	s10,32(sp)
    800033ce:	ec6e                	sd	s11,24(sp)
    800033d0:	0100                	addi	s0,sp,128
    800033d2:	f8b43423          	sd	a1,-120(s0)
    int total = 0, m = 0;
    struct buf *bp;
    if (off > ip->size || off + n < off) {
    800033d6:	457c                	lw	a5,76(a0)
        return 0;
    800033d8:	4981                	li	s3,0
    if (off > ip->size || off + n < off) {
    800033da:	0ad7e463          	bltu	a5,a3,80003482 <read_inode+0xce>
    800033de:	8caa                	mv	s9,a0
    800033e0:	8b32                	mv	s6,a2
    800033e2:	84b6                	mv	s1,a3
    800033e4:	8bba                	mv	s7,a4
    800033e6:	9f35                	addw	a4,a4,a3
        return 0;
    800033e8:	4981                	li	s3,0
    if (off > ip->size || off + n < off) {
    800033ea:	08d76c63          	bltu	a4,a3,80003482 <read_inode+0xce>
    }
    if (off + n > ip->size) {
    800033ee:	00e7f463          	bgeu	a5,a4,800033f6 <read_inode+0x42>
        n = ip->size - off;
    800033f2:	40d78bbb          	subw	s7,a5,a3
    }

    for (; total < n; total += m, off += m, dst += m) {
    800033f6:	4981                	li	s3,0
        bp = buf_read(0, bmap(ip, off / BSIZE));
        m = min(BSIZE - off % BSIZE, n - total);
    800033f8:	40000d93          	li	s11,1024
        if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800033fc:	5d7d                	li	s10,-1
    for (; total < n; total += m, off += m, dst += m) {
    800033fe:	03704f63          	bgtz	s7,8000343c <read_inode+0x88>
    80003402:	a041                	j	80003482 <read_inode+0xce>
        m = min(BSIZE - off % BSIZE, n - total);
    80003404:	000a0c1b          	sext.w	s8,s4
        if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003408:	04c90613          	addi	a2,s2,76
    8000340c:	86e2                	mv	a3,s8
    8000340e:	963a                	add	a2,a2,a4
    80003410:	85da                	mv	a1,s6
    80003412:	f8843503          	ld	a0,-120(s0)
    80003416:	ffffe097          	auipc	ra,0xffffe
    8000341a:	c4c080e7          	jalr	-948(ra) # 80001062 <either_copyout>
    8000341e:	8aaa                	mv	s5,a0
    80003420:	05a50b63          	beq	a0,s10,80003476 <read_inode+0xc2>
            relse_buf(bp);
            total = -1;
            break;
        }
        relse_buf(bp);
    80003424:	854a                	mv	a0,s2
    80003426:	00000097          	auipc	ra,0x0
    8000342a:	676080e7          	jalr	1654(ra) # 80003a9c <relse_buf>
    for (; total < n; total += m, off += m, dst += m) {
    8000342e:	013a09bb          	addw	s3,s4,s3
    80003432:	009a04bb          	addw	s1,s4,s1
    80003436:	9b62                	add	s6,s6,s8
    80003438:	0579d563          	bge	s3,s7,80003482 <read_inode+0xce>
        bp = buf_read(0, bmap(ip, off / BSIZE));
    8000343c:	00a4d59b          	srliw	a1,s1,0xa
    80003440:	8566                	mv	a0,s9
    80003442:	00000097          	auipc	ra,0x0
    80003446:	bc8080e7          	jalr	-1080(ra) # 8000300a <bmap>
    8000344a:	0005059b          	sext.w	a1,a0
    8000344e:	4501                	li	a0,0
    80003450:	00000097          	auipc	ra,0x0
    80003454:	5fe080e7          	jalr	1534(ra) # 80003a4e <buf_read>
    80003458:	892a                	mv	s2,a0
        m = min(BSIZE - off % BSIZE, n - total);
    8000345a:	3ff4f713          	andi	a4,s1,1023
    8000345e:	413b87bb          	subw	a5,s7,s3
    80003462:	40ed86bb          	subw	a3,s11,a4
    80003466:	8a3e                	mv	s4,a5
    80003468:	2781                	sext.w	a5,a5
    8000346a:	0006861b          	sext.w	a2,a3
    8000346e:	f8f67be3          	bgeu	a2,a5,80003404 <read_inode+0x50>
    80003472:	8a36                	mv	s4,a3
    80003474:	bf41                	j	80003404 <read_inode+0x50>
            relse_buf(bp);
    80003476:	854a                	mv	a0,s2
    80003478:	00000097          	auipc	ra,0x0
    8000347c:	624080e7          	jalr	1572(ra) # 80003a9c <relse_buf>
            total = -1;
    80003480:	89d6                	mv	s3,s5
    }
    return total;
}
    80003482:	854e                	mv	a0,s3
    80003484:	70e6                	ld	ra,120(sp)
    80003486:	7446                	ld	s0,112(sp)
    80003488:	74a6                	ld	s1,104(sp)
    8000348a:	7906                	ld	s2,96(sp)
    8000348c:	69e6                	ld	s3,88(sp)
    8000348e:	6a46                	ld	s4,80(sp)
    80003490:	6aa6                	ld	s5,72(sp)
    80003492:	6b06                	ld	s6,64(sp)
    80003494:	7be2                	ld	s7,56(sp)
    80003496:	7c42                	ld	s8,48(sp)
    80003498:	7ca2                	ld	s9,40(sp)
    8000349a:	7d02                	ld	s10,32(sp)
    8000349c:	6de2                	ld	s11,24(sp)
    8000349e:	6109                	addi	sp,sp,128
    800034a0:	8082                	ret

00000000800034a2 <write_inode>:

// 将数据写入inode
int write_inode(struct inode *ip, int user_src, uint64 src, uint64 off, int n) {
    800034a2:	7119                	addi	sp,sp,-128
    800034a4:	fc86                	sd	ra,120(sp)
    800034a6:	f8a2                	sd	s0,112(sp)
    800034a8:	f4a6                	sd	s1,104(sp)
    800034aa:	f0ca                	sd	s2,96(sp)
    800034ac:	ecce                	sd	s3,88(sp)
    800034ae:	e8d2                	sd	s4,80(sp)
    800034b0:	e4d6                	sd	s5,72(sp)
    800034b2:	e0da                	sd	s6,64(sp)
    800034b4:	fc5e                	sd	s7,56(sp)
    800034b6:	f862                	sd	s8,48(sp)
    800034b8:	f466                	sd	s9,40(sp)
    800034ba:	f06a                	sd	s10,32(sp)
    800034bc:	ec6e                	sd	s11,24(sp)
    800034be:	0100                	addi	s0,sp,128
    800034c0:	89b6                	mv	s3,a3
    800034c2:	f8e43423          	sd	a4,-120(s0)
    uint total, m;
    struct buf *bp;

    if (off > ip->size || off + n < off)
    800034c6:	04c56783          	lwu	a5,76(a0)
    800034ca:	0ed7e663          	bltu	a5,a3,800035b6 <write_inode+0x114>
    800034ce:	8c2a                	mv	s8,a0
    800034d0:	8cae                	mv	s9,a1
    800034d2:	8ab2                	mv	s5,a2
    800034d4:	86ba                	mv	a3,a4
    800034d6:	013707b3          	add	a5,a4,s3
    800034da:	0f37e263          	bltu	a5,s3,800035be <write_inode+0x11c>
        return -1;
    if (off + n > MAXFILE * BSIZE)
    800034de:	00043737          	lui	a4,0x43
    800034e2:	0ef76263          	bltu	a4,a5,800035c6 <write_inode+0x124>
        return -1;
    for (total = 0; total < n; total += m, off += m, src += m) {
    800034e6:	00068b1b          	sext.w	s6,a3
    800034ea:	0e0b0263          	beqz	s6,800035ce <write_inode+0x12c>
    800034ee:	4a01                	li	s4,0
        bp = buf_read(0, bmap(ip, off / BSIZE));
        m = min(BSIZE - off % BSIZE, n - total);
    800034f0:	40000d93          	li	s11,1024
        if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800034f4:	5d7d                	li	s10,-1
    800034f6:	a83d                	j	80003534 <write_inode+0x92>
        m = min(BSIZE - off % BSIZE, n - total);
    800034f8:	00048b9b          	sext.w	s7,s1
        if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800034fc:	04c90513          	addi	a0,s2,76
    80003500:	86a6                	mv	a3,s1
    80003502:	8656                	mv	a2,s5
    80003504:	85e6                	mv	a1,s9
    80003506:	953e                	add	a0,a0,a5
    80003508:	ffffe097          	auipc	ra,0xffffe
    8000350c:	ba2080e7          	jalr	-1118(ra) # 800010aa <either_copyin>
    80003510:	05a50e63          	beq	a0,s10,8000356c <write_inode+0xca>
            relse_buf(bp);
            break;
        }
        buf_write(bp);
    80003514:	854a                	mv	a0,s2
    80003516:	00000097          	auipc	ra,0x0
    8000351a:	56c080e7          	jalr	1388(ra) # 80003a82 <buf_write>
        relse_buf(bp);
    8000351e:	854a                	mv	a0,s2
    80003520:	00000097          	auipc	ra,0x0
    80003524:	57c080e7          	jalr	1404(ra) # 80003a9c <relse_buf>
    for (total = 0; total < n; total += m, off += m, src += m) {
    80003528:	014b8a3b          	addw	s4,s7,s4
    8000352c:	99a6                	add	s3,s3,s1
    8000352e:	9aa6                	add	s5,s5,s1
    80003530:	056a7363          	bgeu	s4,s6,80003576 <write_inode+0xd4>
        bp = buf_read(0, bmap(ip, off / BSIZE));
    80003534:	00a9d593          	srli	a1,s3,0xa
    80003538:	2581                	sext.w	a1,a1
    8000353a:	8562                	mv	a0,s8
    8000353c:	00000097          	auipc	ra,0x0
    80003540:	ace080e7          	jalr	-1330(ra) # 8000300a <bmap>
    80003544:	0005059b          	sext.w	a1,a0
    80003548:	4501                	li	a0,0
    8000354a:	00000097          	auipc	ra,0x0
    8000354e:	504080e7          	jalr	1284(ra) # 80003a4e <buf_read>
    80003552:	892a                	mv	s2,a0
        m = min(BSIZE - off % BSIZE, n - total);
    80003554:	3ff9f793          	andi	a5,s3,1023
    80003558:	414b04bb          	subw	s1,s6,s4
    8000355c:	40fd8733          	sub	a4,s11,a5
    80003560:	1482                	slli	s1,s1,0x20
    80003562:	9081                	srli	s1,s1,0x20
    80003564:	f8977ae3          	bgeu	a4,s1,800034f8 <write_inode+0x56>
    80003568:	84ba                	mv	s1,a4
    8000356a:	b779                	j	800034f8 <write_inode+0x56>
            relse_buf(bp);
    8000356c:	854a                	mv	a0,s2
    8000356e:	00000097          	auipc	ra,0x0
    80003572:	52e080e7          	jalr	1326(ra) # 80003a9c <relse_buf>
    }
    if (n > 0) {
    80003576:	f8843783          	ld	a5,-120(s0)
    8000357a:	00f05d63          	blez	a5,80003594 <write_inode+0xf2>
        if (off > ip->size)
    8000357e:	04cc6783          	lwu	a5,76(s8)
    80003582:	0137f463          	bgeu	a5,s3,8000358a <write_inode+0xe8>
            ip->size = off;
    80003586:	053c2623          	sw	s3,76(s8)
        // 将内存中的inode写入磁盘，即使没有写入数据，也需要更新，因为循环中可能
        //调用了bmap()或者在ip->addrs[]里面添加了数据块
        update_inode(ip);
    8000358a:	8562                	mv	a0,s8
    8000358c:	00000097          	auipc	ra,0x0
    80003590:	876080e7          	jalr	-1930(ra) # 80002e02 <update_inode>
    }
    return n;
}
    80003594:	f8843503          	ld	a0,-120(s0)
    80003598:	70e6                	ld	ra,120(sp)
    8000359a:	7446                	ld	s0,112(sp)
    8000359c:	74a6                	ld	s1,104(sp)
    8000359e:	7906                	ld	s2,96(sp)
    800035a0:	69e6                	ld	s3,88(sp)
    800035a2:	6a46                	ld	s4,80(sp)
    800035a4:	6aa6                	ld	s5,72(sp)
    800035a6:	6b06                	ld	s6,64(sp)
    800035a8:	7be2                	ld	s7,56(sp)
    800035aa:	7c42                	ld	s8,48(sp)
    800035ac:	7ca2                	ld	s9,40(sp)
    800035ae:	7d02                	ld	s10,32(sp)
    800035b0:	6de2                	ld	s11,24(sp)
    800035b2:	6109                	addi	sp,sp,128
    800035b4:	8082                	ret
        return -1;
    800035b6:	57fd                	li	a5,-1
    800035b8:	f8f43423          	sd	a5,-120(s0)
    800035bc:	bfe1                	j	80003594 <write_inode+0xf2>
    800035be:	57fd                	li	a5,-1
    800035c0:	f8f43423          	sd	a5,-120(s0)
    800035c4:	bfc1                	j	80003594 <write_inode+0xf2>
        return -1;
    800035c6:	57fd                	li	a5,-1
    800035c8:	f8f43423          	sd	a5,-120(s0)
    800035cc:	b7e1                	j	80003594 <write_inode+0xf2>
    return n;
    800035ce:	f8043423          	sd	zero,-120(s0)
    800035d2:	b7c9                	j	80003594 <write_inode+0xf2>

00000000800035d4 <namecmp>:
// 目录层
//
// 第一个inode为根目录，该目录在mkfs/makefs下创建
//

int namecmp(const char *s, const char *t) {
    800035d4:	1141                	addi	sp,sp,-16
    800035d6:	e406                	sd	ra,8(sp)
    800035d8:	e022                	sd	s0,0(sp)
    800035da:	0800                	addi	s0,sp,16
    return strncmp(s, t, DIRSIZ);
    800035dc:	4639                	li	a2,14
    800035de:	ffffe097          	auipc	ra,0xffffe
    800035e2:	c78080e7          	jalr	-904(ra) # 80001256 <strncmp>
}
    800035e6:	60a2                	ld	ra,8(sp)
    800035e8:	6402                	ld	s0,0(sp)
    800035ea:	0141                	addi	sp,sp,16
    800035ec:	8082                	ret

00000000800035ee <dirlookup>:
//
//  dirlookup 在一个目录中搜索一个带有给定名称的条目。如果找到
// 了，它返回一个指向相应 inode 的指针，解锁该 inode，并将*poff
// 设置为目录中条目的字节偏移量，以便调用者编辑它。
//
struct inode *dirlookup(struct inode *dp, char *name, uint *poff) {
    800035ee:	715d                	addi	sp,sp,-80
    800035f0:	e486                	sd	ra,72(sp)
    800035f2:	e0a2                	sd	s0,64(sp)
    800035f4:	fc26                	sd	s1,56(sp)
    800035f6:	f84a                	sd	s2,48(sp)
    800035f8:	f44e                	sd	s3,40(sp)
    800035fa:	f052                	sd	s4,32(sp)
    800035fc:	ec56                	sd	s5,24(sp)
    800035fe:	0880                	addi	s0,sp,80
    80003600:	892a                	mv	s2,a0
    80003602:	89ae                	mv	s3,a1
    80003604:	8ab2                	mv	s5,a2
    uint off, inum;
    struct direntry de;

    if (dp->type != T_DIR)
    80003606:	04451703          	lh	a4,68(a0)
    8000360a:	4785                	li	a5,1
    8000360c:	00f71b63          	bne	a4,a5,80003622 <dirlookup+0x34>
        panic("dirlookup not DIR");

    for (off = 0; off < dp->size; off += sizeof(de)) {
    80003610:	04c92783          	lw	a5,76(s2)
    80003614:	c7c9                	beqz	a5,8000369e <dirlookup+0xb0>
    80003616:	4481                	li	s1,0
        if (read_inode(dp, 0, (uint64) &de, off, sizeof(de)) != sizeof(de))
            panic("dirlookup read");
    80003618:	00003a17          	auipc	s4,0x3
    8000361c:	db0a0a13          	addi	s4,s4,-592 # 800063c8 <digits+0x2c8>
    80003620:	a825                	j	80003658 <dirlookup+0x6a>
        panic("dirlookup not DIR");
    80003622:	00003517          	auipc	a0,0x3
    80003626:	d8e50513          	addi	a0,a0,-626 # 800063b0 <digits+0x2b0>
    8000362a:	ffffe097          	auipc	ra,0xffffe
    8000362e:	04c080e7          	jalr	76(ra) # 80001676 <panic>
    80003632:	bff9                	j	80003610 <dirlookup+0x22>
            panic("dirlookup read");
    80003634:	8552                	mv	a0,s4
    80003636:	ffffe097          	auipc	ra,0xffffe
    8000363a:	040080e7          	jalr	64(ra) # 80001676 <panic>
//        if (de.inum == 0) {
//            continue;
//        }
        if (namecmp(name, de.name) == 0) {
    8000363e:	fb240593          	addi	a1,s0,-78
    80003642:	854e                	mv	a0,s3
    80003644:	00000097          	auipc	ra,0x0
    80003648:	f90080e7          	jalr	-112(ra) # 800035d4 <namecmp>
    8000364c:	c505                	beqz	a0,80003674 <dirlookup+0x86>
    for (off = 0; off < dp->size; off += sizeof(de)) {
    8000364e:	24c1                	addiw	s1,s1,16
    80003650:	04c92783          	lw	a5,76(s2)
    80003654:	04f4f363          	bgeu	s1,a5,8000369a <dirlookup+0xac>
        if (read_inode(dp, 0, (uint64) &de, off, sizeof(de)) != sizeof(de))
    80003658:	4741                	li	a4,16
    8000365a:	86a6                	mv	a3,s1
    8000365c:	fb040613          	addi	a2,s0,-80
    80003660:	4581                	li	a1,0
    80003662:	854a                	mv	a0,s2
    80003664:	00000097          	auipc	ra,0x0
    80003668:	d50080e7          	jalr	-688(ra) # 800033b4 <read_inode>
    8000366c:	47c1                	li	a5,16
    8000366e:	fcf508e3          	beq	a0,a5,8000363e <dirlookup+0x50>
    80003672:	b7c9                	j	80003634 <dirlookup+0x46>
            // 该目录包含该该名称
            if (poff)
    80003674:	000a8463          	beqz	s5,8000367c <dirlookup+0x8e>
                *poff = off;
    80003678:	009aa023          	sw	s1,0(s5)
            inum = de.inum;
            return get_inode(inum);
    8000367c:	fb045503          	lhu	a0,-80(s0)
    80003680:	00000097          	auipc	ra,0x0
    80003684:	80e080e7          	jalr	-2034(ra) # 80002e8e <get_inode>
        }
    }

    return 0;
}
    80003688:	60a6                	ld	ra,72(sp)
    8000368a:	6406                	ld	s0,64(sp)
    8000368c:	74e2                	ld	s1,56(sp)
    8000368e:	7942                	ld	s2,48(sp)
    80003690:	79a2                	ld	s3,40(sp)
    80003692:	7a02                	ld	s4,32(sp)
    80003694:	6ae2                	ld	s5,24(sp)
    80003696:	6161                	addi	sp,sp,80
    80003698:	8082                	ret
    return 0;
    8000369a:	4501                	li	a0,0
    8000369c:	b7f5                	j	80003688 <dirlookup+0x9a>
    8000369e:	4501                	li	a0,0
    800036a0:	b7e5                	j	80003688 <dirlookup+0x9a>

00000000800036a2 <namex>:

// 根据path返回一个inode
// 该函数供nameiparent和namei使用
// 如果parent!=0返回父目录的inode并且复制最后一个元素到name中，
// name必须拥有足够的空间来存储DIRSIZE字节的字符串。
static struct inode *namex(char *path, int nameiparent, char *name) {
    800036a2:	711d                	addi	sp,sp,-96
    800036a4:	ec86                	sd	ra,88(sp)
    800036a6:	e8a2                	sd	s0,80(sp)
    800036a8:	e4a6                	sd	s1,72(sp)
    800036aa:	e0ca                	sd	s2,64(sp)
    800036ac:	fc4e                	sd	s3,56(sp)
    800036ae:	f852                	sd	s4,48(sp)
    800036b0:	f456                	sd	s5,40(sp)
    800036b2:	f05a                	sd	s6,32(sp)
    800036b4:	ec5e                	sd	s7,24(sp)
    800036b6:	e862                	sd	s8,16(sp)
    800036b8:	e466                	sd	s9,8(sp)
    800036ba:	1080                	addi	s0,sp,96
    800036bc:	84aa                	mv	s1,a0
    800036be:	8b2e                	mv	s6,a1
    800036c0:	8ab2                	mv	s5,a2
    struct inode *ip, *next;
    struct proc *p = myproc();
    800036c2:	ffffd097          	auipc	ra,0xffffd
    800036c6:	2ee080e7          	jalr	750(ra) # 800009b0 <myproc>
    if (*path == '/')
    800036ca:	0004c703          	lbu	a4,0(s1)
    800036ce:	02f00793          	li	a5,47
    800036d2:	00f70f63          	beq	a4,a5,800036f0 <namex+0x4e>
        ip = get_inode(ROOTINO);
    else
        ip = get_inode(p->current_dir->inum);
    800036d6:	693c                	ld	a5,80(a0)
    800036d8:	43c8                	lw	a0,4(a5)
    800036da:	fffff097          	auipc	ra,0xfffff
    800036de:	7b4080e7          	jalr	1972(ra) # 80002e8e <get_inode>
    800036e2:	89aa                	mv	s3,a0
    while (*path == '/')
    800036e4:	02f00913          	li	s2,47
    len = path - s;
    800036e8:	4b81                	li	s7,0
    if (len >= DIRSIZ)
    800036ea:	4cb5                	li	s9,13
    while ((path = skipelem(path, name)) != 0) {
        lock_inode(ip);
        if (ip->type != T_DIR) {
    800036ec:	4c05                	li	s8,1
    800036ee:	a84d                	j	800037a0 <namex+0xfe>
        ip = get_inode(ROOTINO);
    800036f0:	4505                	li	a0,1
    800036f2:	fffff097          	auipc	ra,0xfffff
    800036f6:	79c080e7          	jalr	1948(ra) # 80002e8e <get_inode>
    800036fa:	89aa                	mv	s3,a0
    800036fc:	b7e5                	j	800036e4 <namex+0x42>
            unlock_and_putback(ip);
    800036fe:	854e                	mv	a0,s3
    80003700:	00000097          	auipc	ra,0x0
    80003704:	c66080e7          	jalr	-922(ra) # 80003366 <unlock_and_putback>
            return 0;
    80003708:	4981                	li	s3,0
    if (nameiparent) {
        putback_inode(ip);
        return 0;
    }
    return ip;
}
    8000370a:	854e                	mv	a0,s3
    8000370c:	60e6                	ld	ra,88(sp)
    8000370e:	6446                	ld	s0,80(sp)
    80003710:	64a6                	ld	s1,72(sp)
    80003712:	6906                	ld	s2,64(sp)
    80003714:	79e2                	ld	s3,56(sp)
    80003716:	7a42                	ld	s4,48(sp)
    80003718:	7aa2                	ld	s5,40(sp)
    8000371a:	7b02                	ld	s6,32(sp)
    8000371c:	6be2                	ld	s7,24(sp)
    8000371e:	6c42                	ld	s8,16(sp)
    80003720:	6ca2                	ld	s9,8(sp)
    80003722:	6125                	addi	sp,sp,96
    80003724:	8082                	ret
            unlock_inode(ip);
    80003726:	854e                	mv	a0,s3
    80003728:	00000097          	auipc	ra,0x0
    8000372c:	bf8080e7          	jalr	-1032(ra) # 80003320 <unlock_inode>
            return ip;
    80003730:	bfe9                	j	8000370a <namex+0x68>
            unlock_and_putback(ip);
    80003732:	854e                	mv	a0,s3
    80003734:	00000097          	auipc	ra,0x0
    80003738:	c32080e7          	jalr	-974(ra) # 80003366 <unlock_and_putback>
            return 0;
    8000373c:	89d2                	mv	s3,s4
    8000373e:	b7f1                	j	8000370a <namex+0x68>
    len = path - s;
    80003740:	40b48a3b          	subw	s4,s1,a1
    if (len >= DIRSIZ)
    80003744:	094cd363          	bge	s9,s4,800037ca <namex+0x128>
        memmove(name, s, DIRSIZ);
    80003748:	4639                	li	a2,14
    8000374a:	8556                	mv	a0,s5
    8000374c:	ffffe097          	auipc	ra,0xffffe
    80003750:	9cc080e7          	jalr	-1588(ra) # 80001118 <memmove>
    while (*path == '/')
    80003754:	0004c783          	lbu	a5,0(s1)
    80003758:	01279763          	bne	a5,s2,80003766 <namex+0xc4>
        path++;
    8000375c:	0485                	addi	s1,s1,1
    while (*path == '/')
    8000375e:	0004c783          	lbu	a5,0(s1)
    80003762:	ff278de3          	beq	a5,s2,8000375c <namex+0xba>
        lock_inode(ip);
    80003766:	854e                	mv	a0,s3
    80003768:	00000097          	auipc	ra,0x0
    8000376c:	af2080e7          	jalr	-1294(ra) # 8000325a <lock_inode>
        if (ip->type != T_DIR) {
    80003770:	04499783          	lh	a5,68(s3)
    80003774:	f98795e3          	bne	a5,s8,800036fe <namex+0x5c>
        if (nameiparent && *path == '\0') {
    80003778:	000b0563          	beqz	s6,80003782 <namex+0xe0>
    8000377c:	0004c783          	lbu	a5,0(s1)
    80003780:	d3dd                	beqz	a5,80003726 <namex+0x84>
        if ((next = dirlookup(ip, name, 0)) == 0) {
    80003782:	865e                	mv	a2,s7
    80003784:	85d6                	mv	a1,s5
    80003786:	854e                	mv	a0,s3
    80003788:	00000097          	auipc	ra,0x0
    8000378c:	e66080e7          	jalr	-410(ra) # 800035ee <dirlookup>
    80003790:	8a2a                	mv	s4,a0
    80003792:	d145                	beqz	a0,80003732 <namex+0x90>
        unlock_and_putback(ip);
    80003794:	854e                	mv	a0,s3
    80003796:	00000097          	auipc	ra,0x0
    8000379a:	bd0080e7          	jalr	-1072(ra) # 80003366 <unlock_and_putback>
        ip = next;
    8000379e:	89d2                	mv	s3,s4
    while (*path == '/')
    800037a0:	0004c783          	lbu	a5,0(s1)
    800037a4:	05279663          	bne	a5,s2,800037f0 <namex+0x14e>
        path++;
    800037a8:	0485                	addi	s1,s1,1
    while (*path == '/')
    800037aa:	0004c783          	lbu	a5,0(s1)
    800037ae:	ff278de3          	beq	a5,s2,800037a8 <namex+0x106>
    if (*path == 0)
    800037b2:	c795                	beqz	a5,800037de <namex+0x13c>
        path++;
    800037b4:	85a6                	mv	a1,s1
    len = path - s;
    800037b6:	8a5e                	mv	s4,s7
    while (*path != '/' && *path != 0)
    800037b8:	01278963          	beq	a5,s2,800037ca <namex+0x128>
    800037bc:	d3d1                	beqz	a5,80003740 <namex+0x9e>
        path++;
    800037be:	0485                	addi	s1,s1,1
    while (*path != '/' && *path != 0)
    800037c0:	0004c783          	lbu	a5,0(s1)
    800037c4:	ff279ce3          	bne	a5,s2,800037bc <namex+0x11a>
    800037c8:	bfa5                	j	80003740 <namex+0x9e>
        memmove(name, s, len);
    800037ca:	8652                	mv	a2,s4
    800037cc:	8556                	mv	a0,s5
    800037ce:	ffffe097          	auipc	ra,0xffffe
    800037d2:	94a080e7          	jalr	-1718(ra) # 80001118 <memmove>
        name[len] = 0;
    800037d6:	9a56                	add	s4,s4,s5
    800037d8:	000a0023          	sb	zero,0(s4)
    800037dc:	bfa5                	j	80003754 <namex+0xb2>
    if (nameiparent) {
    800037de:	f20b06e3          	beqz	s6,8000370a <namex+0x68>
        putback_inode(ip);
    800037e2:	854e                	mv	a0,s3
    800037e4:	00000097          	auipc	ra,0x0
    800037e8:	990080e7          	jalr	-1648(ra) # 80003174 <putback_inode>
        return 0;
    800037ec:	4981                	li	s3,0
    800037ee:	bf31                	j	8000370a <namex+0x68>
    if (*path == 0)
    800037f0:	d7fd                	beqz	a5,800037de <namex+0x13c>
    while (*path != '/' && *path != 0)
    800037f2:	0004c783          	lbu	a5,0(s1)
    800037f6:	85a6                	mv	a1,s1
    800037f8:	b7d1                	j	800037bc <namex+0x11a>

00000000800037fa <dirlink>:
int dirlink(struct inode *dp, char *name, uint inum) {
    800037fa:	715d                	addi	sp,sp,-80
    800037fc:	e486                	sd	ra,72(sp)
    800037fe:	e0a2                	sd	s0,64(sp)
    80003800:	fc26                	sd	s1,56(sp)
    80003802:	f84a                	sd	s2,48(sp)
    80003804:	f44e                	sd	s3,40(sp)
    80003806:	f052                	sd	s4,32(sp)
    80003808:	ec56                	sd	s5,24(sp)
    8000380a:	e85a                	sd	s6,16(sp)
    8000380c:	0880                	addi	s0,sp,80
    8000380e:	89aa                	mv	s3,a0
    80003810:	8b2e                	mv	s6,a1
    80003812:	8ab2                	mv	s5,a2
    if ((ip = dirlookup(dp, name, 0)) != 0) {
    80003814:	4601                	li	a2,0
    80003816:	00000097          	auipc	ra,0x0
    8000381a:	dd8080e7          	jalr	-552(ra) # 800035ee <dirlookup>
    8000381e:	ed29                	bnez	a0,80003878 <dirlink+0x7e>
    for (off = 0; off < dp->size; off += sizeof(de)) {
    80003820:	04c9a783          	lw	a5,76(s3)
    80003824:	4481                	li	s1,0
    80003826:	4901                	li	s2,0
            panic("dirlink read");
    80003828:	00003a17          	auipc	s4,0x3
    8000382c:	bb0a0a13          	addi	s4,s4,-1104 # 800063d8 <digits+0x2d8>
    for (off = 0; off < dp->size; off += sizeof(de)) {
    80003830:	ebbd                	bnez	a5,800038a6 <dirlink+0xac>
    strncpy(de.name, name, DIRSIZ);
    80003832:	4639                	li	a2,14
    80003834:	85da                	mv	a1,s6
    80003836:	fb240513          	addi	a0,s0,-78
    8000383a:	ffffe097          	auipc	ra,0xffffe
    8000383e:	9b2080e7          	jalr	-1614(ra) # 800011ec <strncpy>
    de.inum = inum;
    80003842:	fb541823          	sh	s5,-80(s0)
    if (write_inode(dp, 0, (uint64) &de, off, sizeof(de)) != sizeof(de))
    80003846:	4741                	li	a4,16
    80003848:	86a6                	mv	a3,s1
    8000384a:	fb040613          	addi	a2,s0,-80
    8000384e:	4581                	li	a1,0
    80003850:	854e                	mv	a0,s3
    80003852:	00000097          	auipc	ra,0x0
    80003856:	c50080e7          	jalr	-944(ra) # 800034a2 <write_inode>
    8000385a:	872a                	mv	a4,a0
    8000385c:	47c1                	li	a5,16
    return 0;
    8000385e:	4501                	li	a0,0
    if (write_inode(dp, 0, (uint64) &de, off, sizeof(de)) != sizeof(de))
    80003860:	06f71163          	bne	a4,a5,800038c2 <dirlink+0xc8>
}
    80003864:	60a6                	ld	ra,72(sp)
    80003866:	6406                	ld	s0,64(sp)
    80003868:	74e2                	ld	s1,56(sp)
    8000386a:	7942                	ld	s2,48(sp)
    8000386c:	79a2                	ld	s3,40(sp)
    8000386e:	7a02                	ld	s4,32(sp)
    80003870:	6ae2                	ld	s5,24(sp)
    80003872:	6b42                	ld	s6,16(sp)
    80003874:	6161                	addi	sp,sp,80
    80003876:	8082                	ret
        putback_inode(ip);
    80003878:	00000097          	auipc	ra,0x0
    8000387c:	8fc080e7          	jalr	-1796(ra) # 80003174 <putback_inode>
        return -1;
    80003880:	557d                	li	a0,-1
    80003882:	b7cd                	j	80003864 <dirlink+0x6a>
            panic("dirlink read");
    80003884:	8552                	mv	a0,s4
    80003886:	ffffe097          	auipc	ra,0xffffe
    8000388a:	df0080e7          	jalr	-528(ra) # 80001676 <panic>
        if (de.inum == 0)
    8000388e:	fb045783          	lhu	a5,-80(s0)
    80003892:	d3c5                	beqz	a5,80003832 <dirlink+0x38>
    for (off = 0; off < dp->size; off += sizeof(de)) {
    80003894:	0109069b          	addiw	a3,s2,16
    80003898:	0006891b          	sext.w	s2,a3
    8000389c:	84ca                	mv	s1,s2
    8000389e:	04c9a783          	lw	a5,76(s3)
    800038a2:	f8f978e3          	bgeu	s2,a5,80003832 <dirlink+0x38>
        if (read_inode(dp, 0, (uint64) &de, off, sizeof(de)) != sizeof(de))
    800038a6:	4741                	li	a4,16
    800038a8:	86ca                	mv	a3,s2
    800038aa:	fb040613          	addi	a2,s0,-80
    800038ae:	4581                	li	a1,0
    800038b0:	854e                	mv	a0,s3
    800038b2:	00000097          	auipc	ra,0x0
    800038b6:	b02080e7          	jalr	-1278(ra) # 800033b4 <read_inode>
    800038ba:	47c1                	li	a5,16
    800038bc:	fcf509e3          	beq	a0,a5,8000388e <dirlink+0x94>
    800038c0:	b7d1                	j	80003884 <dirlink+0x8a>
        panic("dirlink");
    800038c2:	00003517          	auipc	a0,0x3
    800038c6:	dbe50513          	addi	a0,a0,-578 # 80006680 <syscalls+0xb0>
    800038ca:	ffffe097          	auipc	ra,0xffffe
    800038ce:	dac080e7          	jalr	-596(ra) # 80001676 <panic>
    return 0;
    800038d2:	4501                	li	a0,0
    800038d4:	bf41                	j	80003864 <dirlink+0x6a>

00000000800038d6 <namei>:

struct inode *namei(char *path) {
    800038d6:	1101                	addi	sp,sp,-32
    800038d8:	ec06                	sd	ra,24(sp)
    800038da:	e822                	sd	s0,16(sp)
    800038dc:	1000                	addi	s0,sp,32
    char name[DIRSIZ];
    return namex(path, 0, name);
    800038de:	fe040613          	addi	a2,s0,-32
    800038e2:	4581                	li	a1,0
    800038e4:	00000097          	auipc	ra,0x0
    800038e8:	dbe080e7          	jalr	-578(ra) # 800036a2 <namex>
}
    800038ec:	60e2                	ld	ra,24(sp)
    800038ee:	6442                	ld	s0,16(sp)
    800038f0:	6105                	addi	sp,sp,32
    800038f2:	8082                	ret

00000000800038f4 <nameiparent>:

struct inode *nameiparent(char *path, char *name) {
    800038f4:	1141                	addi	sp,sp,-16
    800038f6:	e406                	sd	ra,8(sp)
    800038f8:	e022                	sd	s0,0(sp)
    800038fa:	0800                	addi	s0,sp,16
    800038fc:	862e                	mv	a2,a1
    return namex(path, 1, name);
    800038fe:	4585                	li	a1,1
    80003900:	00000097          	auipc	ra,0x0
    80003904:	da2080e7          	jalr	-606(ra) # 800036a2 <namex>
    80003908:	60a2                	ld	ra,8(sp)
    8000390a:	6402                	ld	s0,0(sp)
    8000390c:	0141                	addi	sp,sp,16
    8000390e:	8082                	ret

0000000080003910 <init_buf>:
#define BUFFER_NUM 100

struct buf buf_cache[BUFFER_NUM];
struct spinlock cache_lock;

void init_buf() {
    80003910:	7179                	addi	sp,sp,-48
    80003912:	f406                	sd	ra,40(sp)
    80003914:	f022                	sd	s0,32(sp)
    80003916:	ec26                	sd	s1,24(sp)
    80003918:	e84a                	sd	s2,16(sp)
    8000391a:	e44e                	sd	s3,8(sp)
    8000391c:	1800                	addi	s0,sp,48
    spinlock_init(&cache_lock, "cache lock");
    8000391e:	00003597          	auipc	a1,0x3
    80003922:	aca58593          	addi	a1,a1,-1334 # 800063e8 <digits+0x2e8>
    80003926:	00093517          	auipc	a0,0x93
    8000392a:	b5250513          	addi	a0,a0,-1198 # 80096478 <cache_lock>
    8000392e:	00000097          	auipc	ra,0x0
    80003932:	1c0080e7          	jalr	448(ra) # 80003aee <spinlock_init>
    80003936:	06400493          	li	s1,100
    for (int i = 0; i < BUFFER_NUM; i++) {
        sleeplock_init(&buf_cache->lock, "buf");
    8000393a:	00003997          	auipc	s3,0x3
    8000393e:	abe98993          	addi	s3,s3,-1346 # 800063f8 <digits+0x2f8>
    80003942:	00093917          	auipc	s2,0x93
    80003946:	b6690913          	addi	s2,s2,-1178 # 800964a8 <buf_cache+0x18>
    8000394a:	85ce                	mv	a1,s3
    8000394c:	854a                	mv	a0,s2
    8000394e:	00000097          	auipc	ra,0x0
    80003952:	360080e7          	jalr	864(ra) # 80003cae <sleeplock_init>
    for (int i = 0; i < BUFFER_NUM; i++) {
    80003956:	34fd                	addiw	s1,s1,-1
    80003958:	f8ed                	bnez	s1,8000394a <init_buf+0x3a>
    }
}
    8000395a:	70a2                	ld	ra,40(sp)
    8000395c:	7402                	ld	s0,32(sp)
    8000395e:	64e2                	ld	s1,24(sp)
    80003960:	6942                	ld	s2,16(sp)
    80003962:	69a2                	ld	s3,8(sp)
    80003964:	6145                	addi	sp,sp,48
    80003966:	8082                	ret

0000000080003968 <alloc_buf>:
extern uint64 ticks;


// 申请使用一个缓冲区，该缓冲区会被锁定
// 先进先出算法
struct buf *alloc_buf(int dev, int blockno) {
    80003968:	7179                	addi	sp,sp,-48
    8000396a:	f406                	sd	ra,40(sp)
    8000396c:	f022                	sd	s0,32(sp)
    8000396e:	ec26                	sd	s1,24(sp)
    80003970:	e84a                	sd	s2,16(sp)
    80003972:	e44e                	sd	s3,8(sp)
    80003974:	e052                	sd	s4,0(sp)
    80003976:	1800                	addi	s0,sp,48
    80003978:	8a2a                	mv	s4,a0
    8000397a:	892e                	mv	s2,a1
    struct buf *b;
    struct buf *earliest = 0;
    spin_lock(&cache_lock);
    8000397c:	00093517          	auipc	a0,0x93
    80003980:	afc50513          	addi	a0,a0,-1284 # 80096478 <cache_lock>
    80003984:	00000097          	auipc	ra,0x0
    80003988:	1fa080e7          	jalr	506(ra) # 80003b7e <spin_lock>
    struct buf *earliest = 0;
    8000398c:	4981                	li	s3,0
    for (b = buf_cache; b < buf_cache + BUFFER_NUM; b++) {
    8000398e:	00093497          	auipc	s1,0x93
    80003992:	b0248493          	addi	s1,s1,-1278 # 80096490 <buf_cache>
        if (b->refcnt == 0 &&
            (earliest == 0 || b->last_use_tick < earliest->last_use_tick)) {
            earliest = b;
        }
        if (b->blockno == blockno) {
    80003996:	2901                	sext.w	s2,s2
    for (b = buf_cache; b < buf_cache + BUFFER_NUM; b++) {
    80003998:	000ae717          	auipc	a4,0xae
    8000399c:	a3870713          	addi	a4,a4,-1480 # 800b13d0 <ticks_lock>
    800039a0:	a809                	j	800039b2 <alloc_buf+0x4a>
    800039a2:	89a6                	mv	s3,s1
        if (b->blockno == blockno) {
    800039a4:	44dc                	lw	a5,12(s1)
    800039a6:	03278163          	beq	a5,s2,800039c8 <alloc_buf+0x60>
    for (b = buf_cache; b < buf_cache + BUFFER_NUM; b++) {
    800039aa:	45048493          	addi	s1,s1,1104
    800039ae:	04e48c63          	beq	s1,a4,80003a06 <alloc_buf+0x9e>
        if (b->refcnt == 0 &&
    800039b2:	44bc                	lw	a5,72(s1)
    800039b4:	fbe5                	bnez	a5,800039a4 <alloc_buf+0x3c>
    800039b6:	fe0986e3          	beqz	s3,800039a2 <alloc_buf+0x3a>
            (earliest == 0 || b->last_use_tick < earliest->last_use_tick)) {
    800039ba:	6894                	ld	a3,16(s1)
    800039bc:	0109b783          	ld	a5,16(s3)
    800039c0:	fef6f2e3          	bgeu	a3,a5,800039a4 <alloc_buf+0x3c>
    800039c4:	89a6                	mv	s3,s1
    800039c6:	bff9                	j	800039a4 <alloc_buf+0x3c>
            spin_unlock(&cache_lock);
    800039c8:	00093517          	auipc	a0,0x93
    800039cc:	ab050513          	addi	a0,a0,-1360 # 80096478 <cache_lock>
    800039d0:	00000097          	auipc	ra,0x0
    800039d4:	282080e7          	jalr	642(ra) # 80003c52 <spin_unlock>
            b->refcnt++;
    800039d8:	44bc                	lw	a5,72(s1)
    800039da:	2785                	addiw	a5,a5,1
    800039dc:	c4bc                	sw	a5,72(s1)
            b->last_use_tick = ticks;
    800039de:	00003797          	auipc	a5,0x3
    800039e2:	6327b783          	ld	a5,1586(a5) # 80007010 <ticks>
    800039e6:	e89c                	sd	a5,16(s1)
            sleep_lock(&b->lock);
    800039e8:	01848513          	addi	a0,s1,24
    800039ec:	00000097          	auipc	ra,0x0
    800039f0:	2fc080e7          	jalr	764(ra) # 80003ce8 <sleep_lock>
    b->refcnt = 1;
    b->blockno = blockno;
    b->dev = dev;
    b->last_use_tick = ticks;
    return b;
}
    800039f4:	8526                	mv	a0,s1
    800039f6:	70a2                	ld	ra,40(sp)
    800039f8:	7402                	ld	s0,32(sp)
    800039fa:	64e2                	ld	s1,24(sp)
    800039fc:	6942                	ld	s2,16(sp)
    800039fe:	69a2                	ld	s3,8(sp)
    80003a00:	6a02                	ld	s4,0(sp)
    80003a02:	6145                	addi	sp,sp,48
    80003a04:	8082                	ret
    spin_unlock(&cache_lock);
    80003a06:	00093517          	auipc	a0,0x93
    80003a0a:	a7250513          	addi	a0,a0,-1422 # 80096478 <cache_lock>
    80003a0e:	00000097          	auipc	ra,0x0
    80003a12:	244080e7          	jalr	580(ra) # 80003c52 <spin_unlock>
    if (earliest == 0) {
    80003a16:	02098363          	beqz	s3,80003a3c <alloc_buf+0xd4>
    b->valid = 0;
    80003a1a:	0009a023          	sw	zero,0(s3)
    b->refcnt = 1;
    80003a1e:	4785                	li	a5,1
    80003a20:	04f9a423          	sw	a5,72(s3)
    b->blockno = blockno;
    80003a24:	0129a623          	sw	s2,12(s3)
    b->dev = dev;
    80003a28:	0149a423          	sw	s4,8(s3)
    b->last_use_tick = ticks;
    80003a2c:	00003797          	auipc	a5,0x3
    80003a30:	5e47b783          	ld	a5,1508(a5) # 80007010 <ticks>
    80003a34:	00f9b823          	sd	a5,16(s3)
    return b;
    80003a38:	84ce                	mv	s1,s3
    80003a3a:	bf6d                	j	800039f4 <alloc_buf+0x8c>
        panic("alloc buf");
    80003a3c:	00003517          	auipc	a0,0x3
    80003a40:	9c450513          	addi	a0,a0,-1596 # 80006400 <digits+0x300>
    80003a44:	ffffe097          	auipc	ra,0xffffe
    80003a48:	c32080e7          	jalr	-974(ra) # 80001676 <panic>
    80003a4c:	b7f9                	j	80003a1a <alloc_buf+0xb2>

0000000080003a4e <buf_read>:
    buf_write(b);
    sleep_unlock(&b->lock);
}

// 读取给定块的内容，返回一个包含该内容的buf
struct buf *buf_read(int dev, int blockno) {
    80003a4e:	1101                	addi	sp,sp,-32
    80003a50:	ec06                	sd	ra,24(sp)
    80003a52:	e822                	sd	s0,16(sp)
    80003a54:	e426                	sd	s1,8(sp)
    80003a56:	1000                	addi	s0,sp,32
    struct buf *b = alloc_buf(dev, blockno);
    80003a58:	00000097          	auipc	ra,0x0
    80003a5c:	f10080e7          	jalr	-240(ra) # 80003968 <alloc_buf>
    80003a60:	84aa                	mv	s1,a0
    if (!b->valid) {
    80003a62:	411c                	lw	a5,0(a0)
    80003a64:	cb89                	beqz	a5,80003a76 <buf_read+0x28>
        virtio_disk_rw(b, 0);
    }
    b->valid = 1;
    80003a66:	4785                	li	a5,1
    80003a68:	c09c                	sw	a5,0(s1)
    return b;
}
    80003a6a:	8526                	mv	a0,s1
    80003a6c:	60e2                	ld	ra,24(sp)
    80003a6e:	6442                	ld	s0,16(sp)
    80003a70:	64a2                	ld	s1,8(sp)
    80003a72:	6105                	addi	sp,sp,32
    80003a74:	8082                	ret
        virtio_disk_rw(b, 0);
    80003a76:	4581                	li	a1,0
    80003a78:	ffffe097          	auipc	ra,0xffffe
    80003a7c:	6f6080e7          	jalr	1782(ra) # 8000216e <virtio_disk_rw>
    80003a80:	b7dd                	j	80003a66 <buf_read+0x18>

0000000080003a82 <buf_write>:

// 将缓冲区写入磁盘
void buf_write(struct buf *b) {
    80003a82:	1141                	addi	sp,sp,-16
    80003a84:	e406                	sd	ra,8(sp)
    80003a86:	e022                	sd	s0,0(sp)
    80003a88:	0800                	addi	s0,sp,16
    virtio_disk_rw(b, 1);
    80003a8a:	4585                	li	a1,1
    80003a8c:	ffffe097          	auipc	ra,0xffffe
    80003a90:	6e2080e7          	jalr	1762(ra) # 8000216e <virtio_disk_rw>
}
    80003a94:	60a2                	ld	ra,8(sp)
    80003a96:	6402                	ld	s0,0(sp)
    80003a98:	0141                	addi	sp,sp,16
    80003a9a:	8082                	ret

0000000080003a9c <relse_buf>:
void relse_buf(struct buf *b) {
    80003a9c:	1101                	addi	sp,sp,-32
    80003a9e:	ec06                	sd	ra,24(sp)
    80003aa0:	e822                	sd	s0,16(sp)
    80003aa2:	e426                	sd	s1,8(sp)
    80003aa4:	e04a                	sd	s2,0(sp)
    80003aa6:	1000                	addi	s0,sp,32
    80003aa8:	84aa                	mv	s1,a0
    spin_lock(&cache_lock);
    80003aaa:	00093917          	auipc	s2,0x93
    80003aae:	9ce90913          	addi	s2,s2,-1586 # 80096478 <cache_lock>
    80003ab2:	854a                	mv	a0,s2
    80003ab4:	00000097          	auipc	ra,0x0
    80003ab8:	0ca080e7          	jalr	202(ra) # 80003b7e <spin_lock>
    b->refcnt--;
    80003abc:	44bc                	lw	a5,72(s1)
    80003abe:	37fd                	addiw	a5,a5,-1
    80003ac0:	c4bc                	sw	a5,72(s1)
    spin_unlock(&cache_lock);
    80003ac2:	854a                	mv	a0,s2
    80003ac4:	00000097          	auipc	ra,0x0
    80003ac8:	18e080e7          	jalr	398(ra) # 80003c52 <spin_unlock>
    buf_write(b);
    80003acc:	8526                	mv	a0,s1
    80003ace:	00000097          	auipc	ra,0x0
    80003ad2:	fb4080e7          	jalr	-76(ra) # 80003a82 <buf_write>
    sleep_unlock(&b->lock);
    80003ad6:	01848513          	addi	a0,s1,24
    80003ada:	00000097          	auipc	ra,0x0
    80003ade:	264080e7          	jalr	612(ra) # 80003d3e <sleep_unlock>
}
    80003ae2:	60e2                	ld	ra,24(sp)
    80003ae4:	6442                	ld	s0,16(sp)
    80003ae6:	64a2                	ld	s1,8(sp)
    80003ae8:	6902                	ld	s2,0(sp)
    80003aea:	6105                	addi	sp,sp,32
    80003aec:	8082                	ret

0000000080003aee <spinlock_init>:
#include "lock.h"
#include "../riscv.h"
#include "../process.h"
#include "../defs.h"

void spinlock_init(struct spinlock *lk, char *name) {
    80003aee:	1141                	addi	sp,sp,-16
    80003af0:	e422                	sd	s0,8(sp)
    80003af2:	0800                	addi	s0,sp,16
    lk->cpu = 0;
    80003af4:	00053423          	sd	zero,8(a0)
    lk->name = name;
    80003af8:	e90c                	sd	a1,16(a0)
    lk->locked = 0;
    80003afa:	00052023          	sw	zero,0(a0)
}
    80003afe:	6422                	ld	s0,8(sp)
    80003b00:	0141                	addi	sp,sp,16
    80003b02:	8082                	ret

0000000080003b04 <spin_holding>:

// 检查当前cpu是否持有这个锁
// 需要关中断
int spin_holding(struct spinlock *lk) {
    int r;
    r = (lk->locked && lk->cpu == mycpu());
    80003b04:	411c                	lw	a5,0(a0)
    80003b06:	e399                	bnez	a5,80003b0c <spin_holding+0x8>
    80003b08:	4501                	li	a0,0
    return r;
}
    80003b0a:	8082                	ret
int spin_holding(struct spinlock *lk) {
    80003b0c:	1101                	addi	sp,sp,-32
    80003b0e:	ec06                	sd	ra,24(sp)
    80003b10:	e822                	sd	s0,16(sp)
    80003b12:	e426                	sd	s1,8(sp)
    80003b14:	1000                	addi	s0,sp,32
    r = (lk->locked && lk->cpu == mycpu());
    80003b16:	6504                	ld	s1,8(a0)
    80003b18:	ffffd097          	auipc	ra,0xffffd
    80003b1c:	e7c080e7          	jalr	-388(ra) # 80000994 <mycpu>
    80003b20:	40a48533          	sub	a0,s1,a0
    80003b24:	00153513          	seqz	a0,a0
}
    80003b28:	60e2                	ld	ra,24(sp)
    80003b2a:	6442                	ld	s0,16(sp)
    80003b2c:	64a2                	ld	s1,8(sp)
    80003b2e:	6105                	addi	sp,sp,32
    80003b30:	8082                	ret

0000000080003b32 <push_off>:

// push_off/pop_off 和 intr_off/intr_on 差不多，只是使得
// 开关中断可以嵌套使用。
void push_off(void) {
    80003b32:	1101                	addi	sp,sp,-32
    80003b34:	ec06                	sd	ra,24(sp)
    80003b36:	e822                	sd	s0,16(sp)
    80003b38:	e426                	sd	s1,8(sp)
    80003b3a:	1000                	addi	s0,sp,32

static inline uint64
r_sstatus()
{
  uint64 x;
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003b3c:	100024f3          	csrr	s1,sstatus
    80003b40:	100027f3          	csrr	a5,sstatus

// disable device interrupts
static inline void
intr_off()
{
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80003b44:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003b46:	10079073          	csrw	sstatus,a5
    int old = intr_get();
    intr_off();
    if (mycpu()->noff == 0)
    80003b4a:	ffffd097          	auipc	ra,0xffffd
    80003b4e:	e4a080e7          	jalr	-438(ra) # 80000994 <mycpu>
    80003b52:	5d3c                	lw	a5,120(a0)
    80003b54:	cf89                	beqz	a5,80003b6e <push_off+0x3c>
        mycpu()->intr_enable = old;
    mycpu()->noff += 1;
    80003b56:	ffffd097          	auipc	ra,0xffffd
    80003b5a:	e3e080e7          	jalr	-450(ra) # 80000994 <mycpu>
    80003b5e:	5d3c                	lw	a5,120(a0)
    80003b60:	2785                	addiw	a5,a5,1
    80003b62:	dd3c                	sw	a5,120(a0)
}
    80003b64:	60e2                	ld	ra,24(sp)
    80003b66:	6442                	ld	s0,16(sp)
    80003b68:	64a2                	ld	s1,8(sp)
    80003b6a:	6105                	addi	sp,sp,32
    80003b6c:	8082                	ret
        mycpu()->intr_enable = old;
    80003b6e:	ffffd097          	auipc	ra,0xffffd
    80003b72:	e26080e7          	jalr	-474(ra) # 80000994 <mycpu>
// are device interrupts enabled?
static inline int
intr_get()
{
  uint64 x = r_sstatus();
  return (x & SSTATUS_SIE) != 0;
    80003b76:	8085                	srli	s1,s1,0x1
    80003b78:	8885                	andi	s1,s1,1
    80003b7a:	dd64                	sw	s1,124(a0)
    80003b7c:	bfe9                	j	80003b56 <push_off+0x24>

0000000080003b7e <spin_lock>:
void spin_lock(struct spinlock *lk) {
    80003b7e:	1101                	addi	sp,sp,-32
    80003b80:	ec06                	sd	ra,24(sp)
    80003b82:	e822                	sd	s0,16(sp)
    80003b84:	e426                	sd	s1,8(sp)
    80003b86:	1000                	addi	s0,sp,32
    80003b88:	84aa                	mv	s1,a0
    push_off(); // 禁用中断以避免死锁。
    80003b8a:	00000097          	auipc	ra,0x0
    80003b8e:	fa8080e7          	jalr	-88(ra) # 80003b32 <push_off>
    if (spin_holding(lk)){
    80003b92:	8526                	mv	a0,s1
    80003b94:	00000097          	auipc	ra,0x0
    80003b98:	f70080e7          	jalr	-144(ra) # 80003b04 <spin_holding>
    80003b9c:	e11d                	bnez	a0,80003bc2 <spin_lock+0x44>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0);
    80003b9e:	4705                	li	a4,1
    80003ba0:	87ba                	mv	a5,a4
    80003ba2:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80003ba6:	2781                	sext.w	a5,a5
    80003ba8:	ffe5                	bnez	a5,80003ba0 <spin_lock+0x22>
    __sync_synchronize();
    80003baa:	0ff0000f          	fence
    lk->cpu = mycpu();
    80003bae:	ffffd097          	auipc	ra,0xffffd
    80003bb2:	de6080e7          	jalr	-538(ra) # 80000994 <mycpu>
    80003bb6:	e488                	sd	a0,8(s1)
}
    80003bb8:	60e2                	ld	ra,24(sp)
    80003bba:	6442                	ld	s0,16(sp)
    80003bbc:	64a2                	ld	s1,8(sp)
    80003bbe:	6105                	addi	sp,sp,32
    80003bc0:	8082                	ret
        printf("lock=%s",lk->name);
    80003bc2:	688c                	ld	a1,16(s1)
    80003bc4:	00003517          	auipc	a0,0x3
    80003bc8:	84c50513          	addi	a0,a0,-1972 # 80006410 <digits+0x310>
    80003bcc:	ffffe097          	auipc	ra,0xffffe
    80003bd0:	9e6080e7          	jalr	-1562(ra) # 800015b2 <printf>
        panic("re-acquire");
    80003bd4:	00003517          	auipc	a0,0x3
    80003bd8:	84450513          	addi	a0,a0,-1980 # 80006418 <digits+0x318>
    80003bdc:	ffffe097          	auipc	ra,0xffffe
    80003be0:	a9a080e7          	jalr	-1382(ra) # 80001676 <panic>
    80003be4:	bf6d                	j	80003b9e <spin_lock+0x20>

0000000080003be6 <pop_off>:

void pop_off(void) {
    80003be6:	1101                	addi	sp,sp,-32
    80003be8:	ec06                	sd	ra,24(sp)
    80003bea:	e822                	sd	s0,16(sp)
    80003bec:	e426                	sd	s1,8(sp)
    80003bee:	1000                	addi	s0,sp,32
    struct cpu *c = mycpu();
    80003bf0:	ffffd097          	auipc	ra,0xffffd
    80003bf4:	da4080e7          	jalr	-604(ra) # 80000994 <mycpu>
    80003bf8:	84aa                	mv	s1,a0
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003bfa:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80003bfe:	8b89                	andi	a5,a5,2
    if (intr_get())
    80003c00:	e79d                	bnez	a5,80003c2e <pop_off+0x48>
        panic("pop_off - interruptible");
    if (c->noff < 1)
    80003c02:	5cbc                	lw	a5,120(s1)
    80003c04:	02f05e63          	blez	a5,80003c40 <pop_off+0x5a>
        panic("pop_off");
    c->noff -= 1;
    80003c08:	5cbc                	lw	a5,120(s1)
    80003c0a:	37fd                	addiw	a5,a5,-1
    80003c0c:	0007871b          	sext.w	a4,a5
    80003c10:	dcbc                	sw	a5,120(s1)
    if (c->noff == 0 && c->intr_enable)
    80003c12:	eb09                	bnez	a4,80003c24 <pop_off+0x3e>
    80003c14:	5cfc                	lw	a5,124(s1)
    80003c16:	c799                	beqz	a5,80003c24 <pop_off+0x3e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003c18:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80003c1c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003c20:	10079073          	csrw	sstatus,a5
        intr_on();
}
    80003c24:	60e2                	ld	ra,24(sp)
    80003c26:	6442                	ld	s0,16(sp)
    80003c28:	64a2                	ld	s1,8(sp)
    80003c2a:	6105                	addi	sp,sp,32
    80003c2c:	8082                	ret
        panic("pop_off - interruptible");
    80003c2e:	00002517          	auipc	a0,0x2
    80003c32:	7fa50513          	addi	a0,a0,2042 # 80006428 <digits+0x328>
    80003c36:	ffffe097          	auipc	ra,0xffffe
    80003c3a:	a40080e7          	jalr	-1472(ra) # 80001676 <panic>
    80003c3e:	b7d1                	j	80003c02 <pop_off+0x1c>
        panic("pop_off");
    80003c40:	00003517          	auipc	a0,0x3
    80003c44:	80050513          	addi	a0,a0,-2048 # 80006440 <digits+0x340>
    80003c48:	ffffe097          	auipc	ra,0xffffe
    80003c4c:	a2e080e7          	jalr	-1490(ra) # 80001676 <panic>
    80003c50:	bf65                	j	80003c08 <pop_off+0x22>

0000000080003c52 <spin_unlock>:
void spin_unlock(struct spinlock *lk) {
    80003c52:	1101                	addi	sp,sp,-32
    80003c54:	ec06                	sd	ra,24(sp)
    80003c56:	e822                	sd	s0,16(sp)
    80003c58:	e426                	sd	s1,8(sp)
    80003c5a:	1000                	addi	s0,sp,32
    80003c5c:	84aa                	mv	s1,a0
    if (!spin_holding(lk)){
    80003c5e:	00000097          	auipc	ra,0x0
    80003c62:	ea6080e7          	jalr	-346(ra) # 80003b04 <spin_holding>
    80003c66:	c115                	beqz	a0,80003c8a <spin_unlock+0x38>
    lk->cpu = 0;
    80003c68:	0004b423          	sd	zero,8(s1)
    __sync_synchronize();
    80003c6c:	0ff0000f          	fence
    __sync_lock_release(&lk->locked);
    80003c70:	0f50000f          	fence	iorw,ow
    80003c74:	0804a02f          	amoswap.w	zero,zero,(s1)
    pop_off();
    80003c78:	00000097          	auipc	ra,0x0
    80003c7c:	f6e080e7          	jalr	-146(ra) # 80003be6 <pop_off>
}
    80003c80:	60e2                	ld	ra,24(sp)
    80003c82:	6442                	ld	s0,16(sp)
    80003c84:	64a2                	ld	s1,8(sp)
    80003c86:	6105                	addi	sp,sp,32
    80003c88:	8082                	ret
        printf("%s\n", lk->name);
    80003c8a:	688c                	ld	a1,16(s1)
    80003c8c:	00002517          	auipc	a0,0x2
    80003c90:	44450513          	addi	a0,a0,1092 # 800060d0 <etext+0xd0>
    80003c94:	ffffe097          	auipc	ra,0xffffe
    80003c98:	91e080e7          	jalr	-1762(ra) # 800015b2 <printf>
        panic("release");
    80003c9c:	00002517          	auipc	a0,0x2
    80003ca0:	7ac50513          	addi	a0,a0,1964 # 80006448 <digits+0x348>
    80003ca4:	ffffe097          	auipc	ra,0xffffe
    80003ca8:	9d2080e7          	jalr	-1582(ra) # 80001676 <panic>
    80003cac:	bf75                	j	80003c68 <spin_unlock+0x16>

0000000080003cae <sleeplock_init>:
#include "lock.h"
#include "../process.h"
#include "../defs.h"

void sleeplock_init(struct sleeplock* lk, char* name)
{
    80003cae:	1101                	addi	sp,sp,-32
    80003cb0:	ec06                	sd	ra,24(sp)
    80003cb2:	e822                	sd	s0,16(sp)
    80003cb4:	e426                	sd	s1,8(sp)
    80003cb6:	e04a                	sd	s2,0(sp)
    80003cb8:	1000                	addi	s0,sp,32
    80003cba:	84aa                	mv	s1,a0
    80003cbc:	892e                	mv	s2,a1
  spinlock_init(&lk->lk, "sleep lock");
    80003cbe:	00002597          	auipc	a1,0x2
    80003cc2:	79258593          	addi	a1,a1,1938 # 80006450 <digits+0x350>
    80003cc6:	0521                	addi	a0,a0,8
    80003cc8:	00000097          	auipc	ra,0x0
    80003ccc:	e26080e7          	jalr	-474(ra) # 80003aee <spinlock_init>
  lk->name = name;
    80003cd0:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003cd4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003cd8:	0204a423          	sw	zero,40(s1)
}
    80003cdc:	60e2                	ld	ra,24(sp)
    80003cde:	6442                	ld	s0,16(sp)
    80003ce0:	64a2                	ld	s1,8(sp)
    80003ce2:	6902                	ld	s2,0(sp)
    80003ce4:	6105                	addi	sp,sp,32
    80003ce6:	8082                	ret

0000000080003ce8 <sleep_lock>:

void sleep_lock(struct sleeplock* lk)
{
    80003ce8:	1101                	addi	sp,sp,-32
    80003cea:	ec06                	sd	ra,24(sp)
    80003cec:	e822                	sd	s0,16(sp)
    80003cee:	e426                	sd	s1,8(sp)
    80003cf0:	e04a                	sd	s2,0(sp)
    80003cf2:	1000                	addi	s0,sp,32
    80003cf4:	84aa                	mv	s1,a0
  spin_lock(&lk->lk);
    80003cf6:	00850913          	addi	s2,a0,8
    80003cfa:	854a                	mv	a0,s2
    80003cfc:	00000097          	auipc	ra,0x0
    80003d00:	e82080e7          	jalr	-382(ra) # 80003b7e <spin_lock>
  while (lk->locked) {
    80003d04:	409c                	lw	a5,0(s1)
    80003d06:	cb89                	beqz	a5,80003d18 <sleep_lock+0x30>
    sleep(lk, &lk->lk);
    80003d08:	85ca                	mv	a1,s2
    80003d0a:	8526                	mv	a0,s1
    80003d0c:	ffffd097          	auipc	ra,0xffffd
    80003d10:	da6080e7          	jalr	-602(ra) # 80000ab2 <sleep>
  while (lk->locked) {
    80003d14:	409c                	lw	a5,0(s1)
    80003d16:	fbed                	bnez	a5,80003d08 <sleep_lock+0x20>
  }
  lk->locked = 1;
    80003d18:	4785                	li	a5,1
    80003d1a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003d1c:	ffffd097          	auipc	ra,0xffffd
    80003d20:	c94080e7          	jalr	-876(ra) # 800009b0 <myproc>
    80003d24:	5d1c                	lw	a5,56(a0)
    80003d26:	d49c                	sw	a5,40(s1)
  spin_unlock(&lk->lk);
    80003d28:	854a                	mv	a0,s2
    80003d2a:	00000097          	auipc	ra,0x0
    80003d2e:	f28080e7          	jalr	-216(ra) # 80003c52 <spin_unlock>
}
    80003d32:	60e2                	ld	ra,24(sp)
    80003d34:	6442                	ld	s0,16(sp)
    80003d36:	64a2                	ld	s1,8(sp)
    80003d38:	6902                	ld	s2,0(sp)
    80003d3a:	6105                	addi	sp,sp,32
    80003d3c:	8082                	ret

0000000080003d3e <sleep_unlock>:

void sleep_unlock(struct sleeplock* lk)
{
    80003d3e:	1101                	addi	sp,sp,-32
    80003d40:	ec06                	sd	ra,24(sp)
    80003d42:	e822                	sd	s0,16(sp)
    80003d44:	e426                	sd	s1,8(sp)
    80003d46:	e04a                	sd	s2,0(sp)
    80003d48:	1000                	addi	s0,sp,32
    80003d4a:	84aa                	mv	s1,a0
  spin_lock(&lk->lk);
    80003d4c:	00850913          	addi	s2,a0,8
    80003d50:	854a                	mv	a0,s2
    80003d52:	00000097          	auipc	ra,0x0
    80003d56:	e2c080e7          	jalr	-468(ra) # 80003b7e <spin_lock>
  lk->locked = 0;
    80003d5a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003d5e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003d62:	8526                	mv	a0,s1
    80003d64:	ffffd097          	auipc	ra,0xffffd
    80003d68:	e4a080e7          	jalr	-438(ra) # 80000bae <wakeup>
  spin_unlock(&lk->lk);
    80003d6c:	854a                	mv	a0,s2
    80003d6e:	00000097          	auipc	ra,0x0
    80003d72:	ee4080e7          	jalr	-284(ra) # 80003c52 <spin_unlock>
}
    80003d76:	60e2                	ld	ra,24(sp)
    80003d78:	6442                	ld	s0,16(sp)
    80003d7a:	64a2                	ld	s1,8(sp)
    80003d7c:	6902                	ld	s2,0(sp)
    80003d7e:	6105                	addi	sp,sp,32
    80003d80:	8082                	ret

0000000080003d82 <sleep_holding>:

int sleep_holding(struct sleeplock* lk)
{
    80003d82:	7179                	addi	sp,sp,-48
    80003d84:	f406                	sd	ra,40(sp)
    80003d86:	f022                	sd	s0,32(sp)
    80003d88:	ec26                	sd	s1,24(sp)
    80003d8a:	e84a                	sd	s2,16(sp)
    80003d8c:	e44e                	sd	s3,8(sp)
    80003d8e:	1800                	addi	s0,sp,48
    80003d90:	84aa                	mv	s1,a0
  int r;
  spin_lock(&lk->lk);
    80003d92:	00850913          	addi	s2,a0,8
    80003d96:	854a                	mv	a0,s2
    80003d98:	00000097          	auipc	ra,0x0
    80003d9c:	de6080e7          	jalr	-538(ra) # 80003b7e <spin_lock>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003da0:	409c                	lw	a5,0(s1)
    80003da2:	ef99                	bnez	a5,80003dc0 <sleep_holding+0x3e>
    80003da4:	4481                	li	s1,0
  spin_unlock(&lk->lk);
    80003da6:	854a                	mv	a0,s2
    80003da8:	00000097          	auipc	ra,0x0
    80003dac:	eaa080e7          	jalr	-342(ra) # 80003c52 <spin_unlock>
  return r;
}
    80003db0:	8526                	mv	a0,s1
    80003db2:	70a2                	ld	ra,40(sp)
    80003db4:	7402                	ld	s0,32(sp)
    80003db6:	64e2                	ld	s1,24(sp)
    80003db8:	6942                	ld	s2,16(sp)
    80003dba:	69a2                	ld	s3,8(sp)
    80003dbc:	6145                	addi	sp,sp,48
    80003dbe:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003dc0:	0284a983          	lw	s3,40(s1)
    80003dc4:	ffffd097          	auipc	ra,0xffffd
    80003dc8:	bec080e7          	jalr	-1044(ra) # 800009b0 <myproc>
    80003dcc:	5d04                	lw	s1,56(a0)
    80003dce:	413484b3          	sub	s1,s1,s3
    80003dd2:	0014b493          	seqz	s1,s1
    80003dd6:	bfc1                	j	80003da6 <sleep_holding+0x24>

0000000080003dd8 <trapinit>:

extern char trampoline[], uservec[], userret[];


// 配置中断处理程序
void trapinit(void) {
    80003dd8:	1141                	addi	sp,sp,-16
    80003dda:	e422                	sd	s0,8(sp)
    80003ddc:	0800                	addi	s0,sp,16
// Supervisor Trap-Vector Base Address
// low two bits are mode.
static inline void 
w_stvec(uint64 x)
{
  asm volatile("csrw stvec, %0" : : "r" (x));
    80003dde:	ffffd797          	auipc	a5,0xffffd
    80003de2:	87278793          	addi	a5,a5,-1934 # 80000650 <kernelvec>
    80003de6:	10579073          	csrw	stvec,a5
    w_stvec((uint64) kernelvec);
}
    80003dea:	6422                	ld	s0,8(sp)
    80003dec:	0141                	addi	sp,sp,16
    80003dee:	8082                	ret

0000000080003df0 <usertrapret>:
    }

    usertrapret();
}

void usertrapret() {
    80003df0:	1141                	addi	sp,sp,-16
    80003df2:	e406                	sd	ra,8(sp)
    80003df4:	e022                	sd	s0,0(sp)
    80003df6:	0800                	addi	s0,sp,16
    struct proc *p = myproc();
    80003df8:	ffffd097          	auipc	ra,0xffffd
    80003dfc:	bb8080e7          	jalr	-1096(ra) # 800009b0 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003e00:	100027f3          	csrr	a5,sstatus

// disable device interrupts
static inline void
intr_off()
{
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80003e04:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003e06:	10079073          	csrw	sstatus,a5
    // 现在将trap处理程序从kerneltrap()切换为usertrap(), 因此需要
    // 禁用中断直到我们返回用户空间。
    intr_off();

    // 现在返回用户空间，设置中断处理函数为trampoline.S的uservec()
    w_stvec(TRAMPOLINE + (uservec - trampoline));
    80003e0a:	00001617          	auipc	a2,0x1
    80003e0e:	1f660613          	addi	a2,a2,502 # 80005000 <_trampoline>
    80003e12:	00001697          	auipc	a3,0x1
    80003e16:	1ee68693          	addi	a3,a3,494 # 80005000 <_trampoline>
    80003e1a:	8e91                	sub	a3,a3,a2
    80003e1c:	040007b7          	lui	a5,0x4000
    80003e20:	17fd                	addi	a5,a5,-1
    80003e22:	07b2                	slli	a5,a5,0xc
    80003e24:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80003e26:	10569073          	csrw	stvec,a3

    // 设置trapframe, 以便下次的trap能够正常运行
    p->trapframe->kernel_satp = r_satp();         // 内核页表
    80003e2a:	6138                	ld	a4,64(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80003e2c:	180026f3          	csrr	a3,satp
    80003e30:	e314                	sd	a3,0(a4)
    p->trapframe->kernel_sp = p->kstack + PGSIZE; // 进程的内核栈
    80003e32:	6138                	ld	a4,64(a0)
    80003e34:	7174                	ld	a3,224(a0)
    80003e36:	6585                	lui	a1,0x1
    80003e38:	96ae                	add	a3,a3,a1
    80003e3a:	e714                	sd	a3,8(a4)
    p->trapframe->kernel_trap = (uint64) usertrap;
    80003e3c:	6138                	ld	a4,64(a0)
    80003e3e:	00000697          	auipc	a3,0x0
    80003e42:	13e68693          	addi	a3,a3,318 # 80003f7c <usertrap>
    80003e46:	eb14                	sd	a3,16(a4)
    p->trapframe->kernel_hartid = r_tp();         // cpu id
    80003e48:	6138                	ld	a4,64(a0)
// this core's hartid (core number), the index into cpus[].
static inline uint64
r_tp()
{
  uint64 x;
  asm volatile("mv %0, tp" : "=r" (x) );
    80003e4a:	8692                	mv	a3,tp
    80003e4c:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003e4e:	100026f3          	csrr	a3,sstatus

    // 设置trampoline.S中的sret返回用户空间所需要的寄存器

    // 设置S Previous Privilege(SPP)为User
    unsigned long x = r_sstatus();
    x &= ~SSTATUS_SPP; // 为用户模式清除SPP
    80003e52:	eff6f693          	andi	a3,a3,-257
    x |= SSTATUS_SPIE; // 允许用户模式下的中断
    80003e56:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003e5a:	10069073          	csrw	sstatus,a3
    w_sstatus(x);

    // 设置S的Exception Program Counter(epc)为保存的pc
    w_sepc(p->trapframe->epc);
    80003e5e:	6138                	ld	a4,64(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80003e60:	6f18                	ld	a4,24(a4)
    80003e62:	14171073          	csrw	sepc,a4

    // 将用户页表转换为satp寄存器需要的格式
    uint64 satp = MAKE_SATP(p->pagetable);
    80003e66:	652c                	ld	a1,72(a0)
    80003e68:	81b1                	srli	a1,a1,0xc

    // 跳转到虚拟内存顶端的trampoline.S, 它会切换页表为用户页表, 恢复用户
    // 寄存器, 并通过sret切换到用户模式。

    uint64 fn = TRAMPOLINE + (userret - trampoline);
    80003e6a:	00001717          	auipc	a4,0x1
    80003e6e:	22670713          	addi	a4,a4,550 # 80005090 <userret>
    80003e72:	8f11                	sub	a4,a4,a2
    80003e74:	97ba                	add	a5,a5,a4
    ((void (*)(uint64, uint64)) fn)(TRAPFRAME, satp);
    80003e76:	577d                	li	a4,-1
    80003e78:	177e                	slli	a4,a4,0x3f
    80003e7a:	8dd9                	or	a1,a1,a4
    80003e7c:	02000537          	lui	a0,0x2000
    80003e80:	157d                	addi	a0,a0,-1
    80003e82:	0536                	slli	a0,a0,0xd
    80003e84:	9782                	jalr	a5
}
    80003e86:	60a2                	ld	ra,8(sp)
    80003e88:	6402                	ld	s0,0(sp)
    80003e8a:	0141                	addi	sp,sp,16
    80003e8c:	8082                	ret

0000000080003e8e <clockintr>:
    w_sepc(sepc);
    w_sstatus(sstatus);
}

// 定时器中断处理程序
void clockintr() {
    80003e8e:	1101                	addi	sp,sp,-32
    80003e90:	ec06                	sd	ra,24(sp)
    80003e92:	e822                	sd	s0,16(sp)
    80003e94:	e426                	sd	s1,8(sp)
    80003e96:	e04a                	sd	s2,0(sp)
    80003e98:	1000                	addi	s0,sp,32
    spin_lock(&ticks_lock);
    80003e9a:	000ad917          	auipc	s2,0xad
    80003e9e:	53690913          	addi	s2,s2,1334 # 800b13d0 <ticks_lock>
    80003ea2:	854a                	mv	a0,s2
    80003ea4:	00000097          	auipc	ra,0x0
    80003ea8:	cda080e7          	jalr	-806(ra) # 80003b7e <spin_lock>
    ticks++;
    80003eac:	00003497          	auipc	s1,0x3
    80003eb0:	16448493          	addi	s1,s1,356 # 80007010 <ticks>
    80003eb4:	609c                	ld	a5,0(s1)
    80003eb6:	0785                	addi	a5,a5,1
    80003eb8:	e09c                	sd	a5,0(s1)
    spin_unlock(&ticks_lock);
    80003eba:	854a                	mv	a0,s2
    80003ebc:	00000097          	auipc	ra,0x0
    80003ec0:	d96080e7          	jalr	-618(ra) # 80003c52 <spin_unlock>
    wakeup(&ticks);
    80003ec4:	8526                	mv	a0,s1
    80003ec6:	ffffd097          	auipc	ra,0xffffd
    80003eca:	ce8080e7          	jalr	-792(ra) # 80000bae <wakeup>
}
    80003ece:	60e2                	ld	ra,24(sp)
    80003ed0:	6442                	ld	s0,16(sp)
    80003ed2:	64a2                	ld	s1,8(sp)
    80003ed4:	6902                	ld	s2,0(sp)
    80003ed6:	6105                	addi	sp,sp,32
    80003ed8:	8082                	ret

0000000080003eda <device_intr>:
// 设备中断处理程序
// 用于判断中断是否为外部和软件中断，并处理它
// 2: 时钟中断
// 1: 其他设备中断
// 0: 无法识别的中断
int device_intr() {
    80003eda:	1101                	addi	sp,sp,-32
    80003edc:	ec06                	sd	ra,24(sp)
    80003ede:	e822                	sd	s0,16(sp)
    80003ee0:	e426                	sd	s1,8(sp)
    80003ee2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003ee4:	14202773          	csrr	a4,scause
    uint64 scause = r_scause();

    if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80003ee8:	00074d63          	bltz	a4,80003f02 <device_intr+0x28>
        // 告诉PLIC该设备现在被允许再次抛出中断
        if (irq)
            plic_complete(irq);

        return 1;
    } else if (scause == 0x8000000000000001L) {
    80003eec:	57fd                	li	a5,-1
    80003eee:	17fe                	slli	a5,a5,0x3f
    80003ef0:	0785                	addi	a5,a5,1
        }
        // 告知以收到软件中断，通过清除sip的SSIP位
        w_sip(r_sip() & ~2);
        return 2;
    } else {
        return 0;
    80003ef2:	4501                	li	a0,0
    } else if (scause == 0x8000000000000001L) {
    80003ef4:	06f70363          	beq	a4,a5,80003f5a <device_intr+0x80>
    }
}
    80003ef8:	60e2                	ld	ra,24(sp)
    80003efa:	6442                	ld	s0,16(sp)
    80003efc:	64a2                	ld	s1,8(sp)
    80003efe:	6105                	addi	sp,sp,32
    80003f00:	8082                	ret
    if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80003f02:	0ff77793          	andi	a5,a4,255
    80003f06:	46a5                	li	a3,9
    80003f08:	fed792e3          	bne	a5,a3,80003eec <device_intr+0x12>
        int irq = plic_claim();
    80003f0c:	ffffc097          	auipc	ra,0xffffc
    80003f10:	6ec080e7          	jalr	1772(ra) # 800005f8 <plic_claim>
    80003f14:	84aa                	mv	s1,a0
        if (irq == UART0_IRQ) {
    80003f16:	47a9                	li	a5,10
    80003f18:	02f50763          	beq	a0,a5,80003f46 <device_intr+0x6c>
        } else if (irq == VIRTIO0_IRQ) {
    80003f1c:	4785                	li	a5,1
    80003f1e:	02f50963          	beq	a0,a5,80003f50 <device_intr+0x76>
        return 1;
    80003f22:	4505                	li	a0,1
        } else if (irq) {
    80003f24:	d8f1                	beqz	s1,80003ef8 <device_intr+0x1e>
            printf("unexpected interrupt irq=%d\n", irq);
    80003f26:	85a6                	mv	a1,s1
    80003f28:	00002517          	auipc	a0,0x2
    80003f2c:	53850513          	addi	a0,a0,1336 # 80006460 <digits+0x360>
    80003f30:	ffffd097          	auipc	ra,0xffffd
    80003f34:	682080e7          	jalr	1666(ra) # 800015b2 <printf>
            plic_complete(irq);
    80003f38:	8526                	mv	a0,s1
    80003f3a:	ffffc097          	auipc	ra,0xffffc
    80003f3e:	6e2080e7          	jalr	1762(ra) # 8000061c <plic_complete>
        return 1;
    80003f42:	4505                	li	a0,1
    80003f44:	bf55                	j	80003ef8 <device_intr+0x1e>
            uart_intr();
    80003f46:	ffffc097          	auipc	ra,0xffffc
    80003f4a:	2d6080e7          	jalr	726(ra) # 8000021c <uart_intr>
    80003f4e:	b7ed                	j	80003f38 <device_intr+0x5e>
            virtio_disk_intr();
    80003f50:	ffffe097          	auipc	ra,0xffffe
    80003f54:	4f4080e7          	jalr	1268(ra) # 80002444 <virtio_disk_intr>
    80003f58:	b7c5                	j	80003f38 <device_intr+0x5e>
        if (cpuid() == 0) {
    80003f5a:	ffffd097          	auipc	ra,0xffffd
    80003f5e:	a2a080e7          	jalr	-1494(ra) # 80000984 <cpuid>
    80003f62:	c901                	beqz	a0,80003f72 <device_intr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80003f64:	144027f3          	csrr	a5,sip
        w_sip(r_sip() & ~2);
    80003f68:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80003f6a:	14479073          	csrw	sip,a5
        return 2;
    80003f6e:	4509                	li	a0,2
    80003f70:	b761                	j	80003ef8 <device_intr+0x1e>
            clockintr();
    80003f72:	00000097          	auipc	ra,0x0
    80003f76:	f1c080e7          	jalr	-228(ra) # 80003e8e <clockintr>
    80003f7a:	b7ed                	j	80003f64 <device_intr+0x8a>

0000000080003f7c <usertrap>:
void usertrap(void) {
    80003f7c:	1101                	addi	sp,sp,-32
    80003f7e:	ec06                	sd	ra,24(sp)
    80003f80:	e822                	sd	s0,16(sp)
    80003f82:	e426                	sd	s1,8(sp)
    80003f84:	e04a                	sd	s2,0(sp)
    80003f86:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003f88:	100027f3          	csrr	a5,sstatus
    if ((r_sstatus() & SSTATUS_SPP) != 0)
    80003f8c:	1007f793          	andi	a5,a5,256
    80003f90:	e3ad                	bnez	a5,80003ff2 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80003f92:	ffffc797          	auipc	a5,0xffffc
    80003f96:	6be78793          	addi	a5,a5,1726 # 80000650 <kernelvec>
    80003f9a:	10579073          	csrw	stvec,a5
    struct proc *p = myproc();
    80003f9e:	ffffd097          	auipc	ra,0xffffd
    80003fa2:	a12080e7          	jalr	-1518(ra) # 800009b0 <myproc>
    80003fa6:	84aa                	mv	s1,a0
    p->trapframe->epc = r_sepc();
    80003fa8:	613c                	ld	a5,64(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003faa:	14102773          	csrr	a4,sepc
    80003fae:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003fb0:	14202773          	csrr	a4,scause
    if (r_scause() == 8) {
    80003fb4:	47a1                	li	a5,8
    80003fb6:	04f71d63          	bne	a4,a5,80004010 <usertrap+0x94>
        if (p->killed)
    80003fba:	591c                	lw	a5,48(a0)
    80003fbc:	e7a1                	bnez	a5,80004004 <usertrap+0x88>
        p->trapframe->epc += 4;
    80003fbe:	60b8                	ld	a4,64(s1)
    80003fc0:	6f1c                	ld	a5,24(a4)
    80003fc2:	0791                	addi	a5,a5,4
    80003fc4:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003fc6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80003fca:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003fce:	10079073          	csrw	sstatus,a5
        syscall();
    80003fd2:	00000097          	auipc	ra,0x0
    80003fd6:	306080e7          	jalr	774(ra) # 800042d8 <syscall>
    if (p->killed)
    80003fda:	589c                	lw	a5,48(s1)
    80003fdc:	ebc9                	bnez	a5,8000406e <usertrap+0xf2>
    usertrapret();
    80003fde:	00000097          	auipc	ra,0x0
    80003fe2:	e12080e7          	jalr	-494(ra) # 80003df0 <usertrapret>
}
    80003fe6:	60e2                	ld	ra,24(sp)
    80003fe8:	6442                	ld	s0,16(sp)
    80003fea:	64a2                	ld	s1,8(sp)
    80003fec:	6902                	ld	s2,0(sp)
    80003fee:	6105                	addi	sp,sp,32
    80003ff0:	8082                	ret
        panic("usertrap: not from user mode");
    80003ff2:	00002517          	auipc	a0,0x2
    80003ff6:	48e50513          	addi	a0,a0,1166 # 80006480 <digits+0x380>
    80003ffa:	ffffd097          	auipc	ra,0xffffd
    80003ffe:	67c080e7          	jalr	1660(ra) # 80001676 <panic>
    80004002:	bf41                	j	80003f92 <usertrap+0x16>
            exit(-1);
    80004004:	557d                	li	a0,-1
    80004006:	ffffd097          	auipc	ra,0xffffd
    8000400a:	ef4080e7          	jalr	-268(ra) # 80000efa <exit>
    8000400e:	bf45                	j	80003fbe <usertrap+0x42>
    } else if ((which_dev = device_intr()) != 0) {
    80004010:	00000097          	auipc	ra,0x0
    80004014:	eca080e7          	jalr	-310(ra) # 80003eda <device_intr>
    80004018:	892a                	mv	s2,a0
    8000401a:	c501                	beqz	a0,80004022 <usertrap+0xa6>
    if (p->killed)
    8000401c:	589c                	lw	a5,48(s1)
    8000401e:	c3a1                	beqz	a5,8000405e <usertrap+0xe2>
    80004020:	a815                	j	80004054 <usertrap+0xd8>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80004022:	142025f3          	csrr	a1,scause
        printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80004026:	5c90                	lw	a2,56(s1)
    80004028:	00002517          	auipc	a0,0x2
    8000402c:	47850513          	addi	a0,a0,1144 # 800064a0 <digits+0x3a0>
    80004030:	ffffd097          	auipc	ra,0xffffd
    80004034:	582080e7          	jalr	1410(ra) # 800015b2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80004038:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000403c:	14302673          	csrr	a2,stval
        printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80004040:	00002517          	auipc	a0,0x2
    80004044:	49050513          	addi	a0,a0,1168 # 800064d0 <digits+0x3d0>
    80004048:	ffffd097          	auipc	ra,0xffffd
    8000404c:	56a080e7          	jalr	1386(ra) # 800015b2 <printf>
        p->killed = 1;
    80004050:	4785                	li	a5,1
    80004052:	d89c                	sw	a5,48(s1)
        exit(-1);
    80004054:	557d                	li	a0,-1
    80004056:	ffffd097          	auipc	ra,0xffffd
    8000405a:	ea4080e7          	jalr	-348(ra) # 80000efa <exit>
    if (which_dev == 2) {
    8000405e:	4789                	li	a5,2
    80004060:	f6f91fe3          	bne	s2,a5,80003fde <usertrap+0x62>
        yield();
    80004064:	ffffd097          	auipc	ra,0xffffd
    80004068:	fb8080e7          	jalr	-72(ra) # 8000101c <yield>
    8000406c:	bf8d                	j	80003fde <usertrap+0x62>
    int which_dev = 0;
    8000406e:	4901                	li	s2,0
    80004070:	b7d5                	j	80004054 <usertrap+0xd8>

0000000080004072 <kerneltrap>:
void kerneltrap() {
    80004072:	7179                	addi	sp,sp,-48
    80004074:	f406                	sd	ra,40(sp)
    80004076:	f022                	sd	s0,32(sp)
    80004078:	ec26                	sd	s1,24(sp)
    8000407a:	e84a                	sd	s2,16(sp)
    8000407c:	e44e                	sd	s3,8(sp)
    8000407e:	e052                	sd	s4,0(sp)
    80004080:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80004082:	ffffd097          	auipc	ra,0xffffd
    80004086:	92e080e7          	jalr	-1746(ra) # 800009b0 <myproc>
    8000408a:	84aa                	mv	s1,a0
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000408c:	141029f3          	csrr	s3,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80004090:	10002973          	csrr	s2,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80004094:	14202a73          	csrr	s4,scause
    if ((sstatus & SSTATUS_SPP) == 0)
    80004098:	10097793          	andi	a5,s2,256
    8000409c:	c79d                	beqz	a5,800040ca <kerneltrap+0x58>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000409e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800040a2:	8b89                	andi	a5,a5,2
    if (intr_get() != 0)
    800040a4:	ef85                	bnez	a5,800040dc <kerneltrap+0x6a>
    which_dev = device_intr();
    800040a6:	00000097          	auipc	ra,0x0
    800040aa:	e34080e7          	jalr	-460(ra) # 80003eda <device_intr>
    if (which_dev == 0) { // 未知来源
    800040ae:	c121                	beqz	a0,800040ee <kerneltrap+0x7c>
    if (which_dev == 2 && p != 0 && p->state == RUNNING) { // 时钟中断
    800040b0:	4789                	li	a5,2
    800040b2:	08f51863          	bne	a0,a5,80004142 <kerneltrap+0xd0>
    800040b6:	c4d1                	beqz	s1,80004142 <kerneltrap+0xd0>
    800040b8:	4c98                	lw	a4,24(s1)
    800040ba:	478d                	li	a5,3
    800040bc:	08f71363          	bne	a4,a5,80004142 <kerneltrap+0xd0>
        yield();
    800040c0:	ffffd097          	auipc	ra,0xffffd
    800040c4:	f5c080e7          	jalr	-164(ra) # 8000101c <yield>
    800040c8:	a8ad                	j	80004142 <kerneltrap+0xd0>
        panic("kerneltrap: not from supervisor mode");
    800040ca:	00002517          	auipc	a0,0x2
    800040ce:	42650513          	addi	a0,a0,1062 # 800064f0 <digits+0x3f0>
    800040d2:	ffffd097          	auipc	ra,0xffffd
    800040d6:	5a4080e7          	jalr	1444(ra) # 80001676 <panic>
    800040da:	b7d1                	j	8000409e <kerneltrap+0x2c>
        panic("kerneltrap: interrupts enabled");
    800040dc:	00002517          	auipc	a0,0x2
    800040e0:	43c50513          	addi	a0,a0,1084 # 80006518 <digits+0x418>
    800040e4:	ffffd097          	auipc	ra,0xffffd
    800040e8:	592080e7          	jalr	1426(ra) # 80001676 <panic>
    800040ec:	bf6d                	j	800040a6 <kerneltrap+0x34>
        printf("scause %p\n", scause);
    800040ee:	85d2                	mv	a1,s4
    800040f0:	00002517          	auipc	a0,0x2
    800040f4:	44850513          	addi	a0,a0,1096 # 80006538 <digits+0x438>
    800040f8:	ffffd097          	auipc	ra,0xffffd
    800040fc:	4ba080e7          	jalr	1210(ra) # 800015b2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80004100:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80004104:	14302673          	csrr	a2,stval
        printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80004108:	00002517          	auipc	a0,0x2
    8000410c:	44050513          	addi	a0,a0,1088 # 80006548 <digits+0x448>
    80004110:	ffffd097          	auipc	ra,0xffffd
    80004114:	4a2080e7          	jalr	1186(ra) # 800015b2 <printf>
        printf("process id = %d",myproc()->pid);
    80004118:	ffffd097          	auipc	ra,0xffffd
    8000411c:	898080e7          	jalr	-1896(ra) # 800009b0 <myproc>
    80004120:	5d0c                	lw	a1,56(a0)
    80004122:	00002517          	auipc	a0,0x2
    80004126:	43e50513          	addi	a0,a0,1086 # 80006560 <digits+0x460>
    8000412a:	ffffd097          	auipc	ra,0xffffd
    8000412e:	488080e7          	jalr	1160(ra) # 800015b2 <printf>
        panic("kerneltrap");
    80004132:	00002517          	auipc	a0,0x2
    80004136:	43e50513          	addi	a0,a0,1086 # 80006570 <digits+0x470>
    8000413a:	ffffd097          	auipc	ra,0xffffd
    8000413e:	53c080e7          	jalr	1340(ra) # 80001676 <panic>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80004142:	14199073          	csrw	sepc,s3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80004146:	10091073          	csrw	sstatus,s2
}
    8000414a:	70a2                	ld	ra,40(sp)
    8000414c:	7402                	ld	s0,32(sp)
    8000414e:	64e2                	ld	s1,24(sp)
    80004150:	6942                	ld	s2,16(sp)
    80004152:	69a2                	ld	s3,8(sp)
    80004154:	6a02                	ld	s4,0(sp)
    80004156:	6145                	addi	sp,sp,48
    80004158:	8082                	ret

000000008000415a <argraw>:
#include "../process.h"
#include "../defs.h"
#include "syscall.h"


uint64 argraw(int n) {
    8000415a:	1101                	addi	sp,sp,-32
    8000415c:	ec06                	sd	ra,24(sp)
    8000415e:	e822                	sd	s0,16(sp)
    80004160:	e426                	sd	s1,8(sp)
    80004162:	1000                	addi	s0,sp,32
    80004164:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80004166:	ffffd097          	auipc	ra,0xffffd
    8000416a:	84a080e7          	jalr	-1974(ra) # 800009b0 <myproc>
    switch (n) {
    8000416e:	4795                	li	a5,5
    80004170:	0497e163          	bltu	a5,s1,800041b2 <argraw+0x58>
    80004174:	048a                	slli	s1,s1,0x2
    80004176:	00002717          	auipc	a4,0x2
    8000417a:	44270713          	addi	a4,a4,1090 # 800065b8 <digits+0x4b8>
    8000417e:	94ba                	add	s1,s1,a4
    80004180:	409c                	lw	a5,0(s1)
    80004182:	97ba                	add	a5,a5,a4
    80004184:	8782                	jr	a5
        case 0:
            return p->trapframe->a0;
    80004186:	613c                	ld	a5,64(a0)
    80004188:	7ba8                	ld	a0,112(a5)
        case 5:
            return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    8000418a:	60e2                	ld	ra,24(sp)
    8000418c:	6442                	ld	s0,16(sp)
    8000418e:	64a2                	ld	s1,8(sp)
    80004190:	6105                	addi	sp,sp,32
    80004192:	8082                	ret
            return p->trapframe->a1;
    80004194:	613c                	ld	a5,64(a0)
    80004196:	7fa8                	ld	a0,120(a5)
    80004198:	bfcd                	j	8000418a <argraw+0x30>
            return p->trapframe->a2;
    8000419a:	613c                	ld	a5,64(a0)
    8000419c:	63c8                	ld	a0,128(a5)
    8000419e:	b7f5                	j	8000418a <argraw+0x30>
            return p->trapframe->a3;
    800041a0:	613c                	ld	a5,64(a0)
    800041a2:	67c8                	ld	a0,136(a5)
    800041a4:	b7dd                	j	8000418a <argraw+0x30>
            return p->trapframe->a4;
    800041a6:	613c                	ld	a5,64(a0)
    800041a8:	6bc8                	ld	a0,144(a5)
    800041aa:	b7c5                	j	8000418a <argraw+0x30>
            return p->trapframe->a5;
    800041ac:	613c                	ld	a5,64(a0)
    800041ae:	6fc8                	ld	a0,152(a5)
    800041b0:	bfe9                	j	8000418a <argraw+0x30>
    panic("argraw");
    800041b2:	00002517          	auipc	a0,0x2
    800041b6:	3ce50513          	addi	a0,a0,974 # 80006580 <digits+0x480>
    800041ba:	ffffd097          	auipc	ra,0xffffd
    800041be:	4bc080e7          	jalr	1212(ra) # 80001676 <panic>
    return -1;
    800041c2:	557d                	li	a0,-1
    800041c4:	b7d9                	j	8000418a <argraw+0x30>

00000000800041c6 <fetchaddr>:

// 获取当前进程addr处的一个uint64值
int fetchaddr(uint64 addr, uint64 *ip){
    800041c6:	1101                	addi	sp,sp,-32
    800041c8:	ec06                	sd	ra,24(sp)
    800041ca:	e822                	sd	s0,16(sp)
    800041cc:	e426                	sd	s1,8(sp)
    800041ce:	e04a                	sd	s2,0(sp)
    800041d0:	1000                	addi	s0,sp,32
    800041d2:	84aa                	mv	s1,a0
    800041d4:	892e                	mv	s2,a1
    struct proc *p = myproc();
    800041d6:	ffffc097          	auipc	ra,0xffffc
    800041da:	7da080e7          	jalr	2010(ra) # 800009b0 <myproc>
    if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    800041de:	16852783          	lw	a5,360(a0)
    800041e2:	02f4f863          	bgeu	s1,a5,80004212 <fetchaddr+0x4c>
    800041e6:	00848713          	addi	a4,s1,8
    800041ea:	02e7e663          	bltu	a5,a4,80004216 <fetchaddr+0x50>
        return -1;
    if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800041ee:	46a1                	li	a3,8
    800041f0:	8626                	mv	a2,s1
    800041f2:	85ca                	mv	a1,s2
    800041f4:	6528                	ld	a0,72(a0)
    800041f6:	ffffe097          	auipc	ra,0xffffe
    800041fa:	9de080e7          	jalr	-1570(ra) # 80001bd4 <copyin>
    800041fe:	00a03533          	snez	a0,a0
    80004202:	40a00533          	neg	a0,a0
        return -1;
    return 0;
}
    80004206:	60e2                	ld	ra,24(sp)
    80004208:	6442                	ld	s0,16(sp)
    8000420a:	64a2                	ld	s1,8(sp)
    8000420c:	6902                	ld	s2,0(sp)
    8000420e:	6105                	addi	sp,sp,32
    80004210:	8082                	ret
        return -1;
    80004212:	557d                	li	a0,-1
    80004214:	bfcd                	j	80004206 <fetchaddr+0x40>
    80004216:	557d                	li	a0,-1
    80004218:	b7fd                	j	80004206 <fetchaddr+0x40>

000000008000421a <argint>:

/**
 * 获取第n个int类型参数
 */
int argint(int n, int *addr) {
    8000421a:	1101                	addi	sp,sp,-32
    8000421c:	ec06                	sd	ra,24(sp)
    8000421e:	e822                	sd	s0,16(sp)
    80004220:	e426                	sd	s1,8(sp)
    80004222:	1000                	addi	s0,sp,32
    80004224:	84ae                	mv	s1,a1
    *addr = argraw(n);
    80004226:	00000097          	auipc	ra,0x0
    8000422a:	f34080e7          	jalr	-204(ra) # 8000415a <argraw>
    8000422e:	c088                	sw	a0,0(s1)
    return 0;
}
    80004230:	4501                	li	a0,0
    80004232:	60e2                	ld	ra,24(sp)
    80004234:	6442                	ld	s0,16(sp)
    80004236:	64a2                	ld	s1,8(sp)
    80004238:	6105                	addi	sp,sp,32
    8000423a:	8082                	ret

000000008000423c <argaddr>:
 *
 * @param n 参数的偏移量
 * @param ip 结果地址
 * @return
 */
int argaddr(int n, uint64 *addr) {
    8000423c:	1101                	addi	sp,sp,-32
    8000423e:	ec06                	sd	ra,24(sp)
    80004240:	e822                	sd	s0,16(sp)
    80004242:	e426                	sd	s1,8(sp)
    80004244:	1000                	addi	s0,sp,32
    80004246:	84ae                	mv	s1,a1
    *addr = argraw(n);
    80004248:	00000097          	auipc	ra,0x0
    8000424c:	f12080e7          	jalr	-238(ra) # 8000415a <argraw>
    80004250:	e088                	sd	a0,0(s1)
    return 0;
}
    80004252:	4501                	li	a0,0
    80004254:	60e2                	ld	ra,24(sp)
    80004256:	6442                	ld	s0,16(sp)
    80004258:	64a2                	ld	s1,8(sp)
    8000425a:	6105                	addi	sp,sp,32
    8000425c:	8082                	ret

000000008000425e <fetchstr>:
/**
 * 从当前进程的addr位置取出0结束的字符串。
 * 返回字符串的长度, 不包括0, 失败返回-1
 * @return
 */
int fetchstr(uint64 addr, char *buf, int max) {
    8000425e:	7179                	addi	sp,sp,-48
    80004260:	f406                	sd	ra,40(sp)
    80004262:	f022                	sd	s0,32(sp)
    80004264:	ec26                	sd	s1,24(sp)
    80004266:	e84a                	sd	s2,16(sp)
    80004268:	e44e                	sd	s3,8(sp)
    8000426a:	1800                	addi	s0,sp,48
    8000426c:	892a                	mv	s2,a0
    8000426e:	84ae                	mv	s1,a1
    80004270:	89b2                	mv	s3,a2
    struct proc *p = myproc();
    80004272:	ffffc097          	auipc	ra,0xffffc
    80004276:	73e080e7          	jalr	1854(ra) # 800009b0 <myproc>
    int err = copyinstr(p->pagetable, buf, addr, max);
    8000427a:	86ce                	mv	a3,s3
    8000427c:	864a                	mv	a2,s2
    8000427e:	85a6                	mv	a1,s1
    80004280:	6528                	ld	a0,72(a0)
    80004282:	ffffe097          	auipc	ra,0xffffe
    80004286:	9dc080e7          	jalr	-1572(ra) # 80001c5e <copyinstr>
    if (err < 0)
    8000428a:	00054863          	bltz	a0,8000429a <fetchstr+0x3c>
        return err;
    return strlen(buf);
    8000428e:	8526                	mv	a0,s1
    80004290:	ffffd097          	auipc	ra,0xffffd
    80004294:	ee4080e7          	jalr	-284(ra) # 80001174 <strlen>
    80004298:	2501                	sext.w	a0,a0
}
    8000429a:	70a2                	ld	ra,40(sp)
    8000429c:	7402                	ld	s0,32(sp)
    8000429e:	64e2                	ld	s1,24(sp)
    800042a0:	6942                	ld	s2,16(sp)
    800042a2:	69a2                	ld	s3,8(sp)
    800042a4:	6145                	addi	sp,sp,48
    800042a6:	8082                	ret

00000000800042a8 <argstr>:

/**
 * 获取第n个系统调用参数作为0结束的字符串
 *  复制到buf中, 最多复制max
 */
int argstr(int n, char *buf, int max) {
    800042a8:	1101                	addi	sp,sp,-32
    800042aa:	ec06                	sd	ra,24(sp)
    800042ac:	e822                	sd	s0,16(sp)
    800042ae:	e426                	sd	s1,8(sp)
    800042b0:	e04a                	sd	s2,0(sp)
    800042b2:	1000                	addi	s0,sp,32
    800042b4:	84ae                	mv	s1,a1
    800042b6:	8932                	mv	s2,a2
    *addr = argraw(n);
    800042b8:	00000097          	auipc	ra,0x0
    800042bc:	ea2080e7          	jalr	-350(ra) # 8000415a <argraw>
    uint64 addr;
    if (argaddr(n, &addr) < 0)
        return -1;
    return fetchstr(addr, buf, max);
    800042c0:	864a                	mv	a2,s2
    800042c2:	85a6                	mv	a1,s1
    800042c4:	00000097          	auipc	ra,0x0
    800042c8:	f9a080e7          	jalr	-102(ra) # 8000425e <fetchstr>
}
    800042cc:	60e2                	ld	ra,24(sp)
    800042ce:	6442                	ld	s0,16(sp)
    800042d0:	64a2                	ld	s1,8(sp)
    800042d2:	6902                	ld	s2,0(sp)
    800042d4:	6105                	addi	sp,sp,32
    800042d6:	8082                	ret

00000000800042d8 <syscall>:
        [SYS_fstat] sys_fstat,
};

#define NELEM(x) (sizeof(x)/sizeof((x)[0]))

void syscall(void) {
    800042d8:	1101                	addi	sp,sp,-32
    800042da:	ec06                	sd	ra,24(sp)
    800042dc:	e822                	sd	s0,16(sp)
    800042de:	e426                	sd	s1,8(sp)
    800042e0:	e04a                	sd	s2,0(sp)
    800042e2:	1000                	addi	s0,sp,32
    int num;
    struct proc *p = myproc();
    800042e4:	ffffc097          	auipc	ra,0xffffc
    800042e8:	6cc080e7          	jalr	1740(ra) # 800009b0 <myproc>
    800042ec:	84aa                	mv	s1,a0
    num = p->trapframe->a7;
    800042ee:	04053903          	ld	s2,64(a0)
    800042f2:	0a893783          	ld	a5,168(s2)
    800042f6:	0007869b          	sext.w	a3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800042fa:	37fd                	addiw	a5,a5,-1
    800042fc:	4731                	li	a4,12
    800042fe:	00f76f63          	bltu	a4,a5,8000431c <syscall+0x44>
    80004302:	00369713          	slli	a4,a3,0x3
    80004306:	00002797          	auipc	a5,0x2
    8000430a:	2ca78793          	addi	a5,a5,714 # 800065d0 <syscalls>
    8000430e:	97ba                	add	a5,a5,a4
    80004310:	639c                	ld	a5,0(a5)
    80004312:	c789                	beqz	a5,8000431c <syscall+0x44>
        p->trapframe->a0 = syscalls[num]();
    80004314:	9782                	jalr	a5
    80004316:	06a93823          	sd	a0,112(s2)
    8000431a:	a03d                	j	80004348 <syscall+0x70>
    } else {
        printf("%d %s: unknown sys call %d\n",
    8000431c:	15848613          	addi	a2,s1,344
    80004320:	5c8c                	lw	a1,56(s1)
    80004322:	00002517          	auipc	a0,0x2
    80004326:	26650513          	addi	a0,a0,614 # 80006588 <digits+0x488>
    8000432a:	ffffd097          	auipc	ra,0xffffd
    8000432e:	288080e7          	jalr	648(ra) # 800015b2 <printf>
               p->pid, p->name, num);
        p->trapframe->a0 = -1;
    80004332:	60bc                	ld	a5,64(s1)
    80004334:	577d                	li	a4,-1
    80004336:	fbb8                	sd	a4,112(a5)
        panic("syscall error");
    80004338:	00002517          	auipc	a0,0x2
    8000433c:	27050513          	addi	a0,a0,624 # 800065a8 <digits+0x4a8>
    80004340:	ffffd097          	auipc	ra,0xffffd
    80004344:	336080e7          	jalr	822(ra) # 80001676 <panic>
    }
    80004348:	60e2                	ld	ra,24(sp)
    8000434a:	6442                	ld	s0,16(sp)
    8000434c:	64a2                	ld	s1,8(sp)
    8000434e:	6902                	ld	s2,0(sp)
    80004350:	6105                	addi	sp,sp,32
    80004352:	8082                	ret

0000000080004354 <create>:
    putc(0, argraw(0));
    return 0;
}

static struct inode *
create(char *path, short type, short major, short minor) {
    80004354:	715d                	addi	sp,sp,-80
    80004356:	e486                	sd	ra,72(sp)
    80004358:	e0a2                	sd	s0,64(sp)
    8000435a:	fc26                	sd	s1,56(sp)
    8000435c:	f84a                	sd	s2,48(sp)
    8000435e:	f44e                	sd	s3,40(sp)
    80004360:	f052                	sd	s4,32(sp)
    80004362:	ec56                	sd	s5,24(sp)
    80004364:	0880                	addi	s0,sp,80
    80004366:	892e                	mv	s2,a1
    80004368:	8a32                	mv	s4,a2
    8000436a:	89b6                	mv	s3,a3
    struct inode *ip, *dp;
    char name[DIRSIZ];

    if ((dp = nameiparent(path, name)) == 0) {
    8000436c:	fb040593          	addi	a1,s0,-80
    80004370:	fffff097          	auipc	ra,0xfffff
    80004374:	584080e7          	jalr	1412(ra) # 800038f4 <nameiparent>
    80004378:	8aaa                	mv	s5,a0
    8000437a:	10050d63          	beqz	a0,80004494 <create+0x140>
        return 0;
    }
    lock_inode(dp);
    8000437e:	fffff097          	auipc	ra,0xfffff
    80004382:	edc080e7          	jalr	-292(ra) # 8000325a <lock_inode>

    // 查看该path是否存在，存在直接返回
    if ((ip = dirlookup(dp, name, 0)) != 0) {
    80004386:	4601                	li	a2,0
    80004388:	fb040593          	addi	a1,s0,-80
    8000438c:	8556                	mv	a0,s5
    8000438e:	fffff097          	auipc	ra,0xfffff
    80004392:	260080e7          	jalr	608(ra) # 800035ee <dirlookup>
    80004396:	84aa                	mv	s1,a0
    80004398:	c50d                	beqz	a0,800043c2 <create+0x6e>
        unlock_and_putback(dp);
    8000439a:	8556                	mv	a0,s5
    8000439c:	fffff097          	auipc	ra,0xfffff
    800043a0:	fca080e7          	jalr	-54(ra) # 80003366 <unlock_and_putback>
        lock_inode(ip);
    800043a4:	8526                	mv	a0,s1
    800043a6:	fffff097          	auipc	ra,0xfffff
    800043aa:	eb4080e7          	jalr	-332(ra) # 8000325a <lock_inode>
        panic("create: dirlink");
    }

    unlock_and_putback(dp);
    return ip;
}
    800043ae:	8526                	mv	a0,s1
    800043b0:	60a6                	ld	ra,72(sp)
    800043b2:	6406                	ld	s0,64(sp)
    800043b4:	74e2                	ld	s1,56(sp)
    800043b6:	7942                	ld	s2,48(sp)
    800043b8:	79a2                	ld	s3,40(sp)
    800043ba:	7a02                	ld	s4,32(sp)
    800043bc:	6ae2                	ld	s5,24(sp)
    800043be:	6161                	addi	sp,sp,80
    800043c0:	8082                	ret
    if ((ip = alloc_inode(type)) == 0) {
    800043c2:	854a                	mv	a0,s2
    800043c4:	fffff097          	auipc	ra,0xfffff
    800043c8:	b7c080e7          	jalr	-1156(ra) # 80002f40 <alloc_inode>
    800043cc:	84aa                	mv	s1,a0
    800043ce:	c531                	beqz	a0,8000441a <create+0xc6>
    lock_inode(ip);
    800043d0:	8526                	mv	a0,s1
    800043d2:	fffff097          	auipc	ra,0xfffff
    800043d6:	e88080e7          	jalr	-376(ra) # 8000325a <lock_inode>
    ip->major = major;
    800043da:	05449323          	sh	s4,70(s1)
    ip->minor = minor;
    800043de:	05349423          	sh	s3,72(s1)
    ip->nlink = 1;
    800043e2:	4785                	li	a5,1
    800043e4:	04f49523          	sh	a5,74(s1)
    update_inode(ip);
    800043e8:	8526                	mv	a0,s1
    800043ea:	fffff097          	auipc	ra,0xfffff
    800043ee:	a18080e7          	jalr	-1512(ra) # 80002e02 <update_inode>
    if (type == T_DIR) {
    800043f2:	0009059b          	sext.w	a1,s2
    800043f6:	4785                	li	a5,1
    800043f8:	02f58a63          	beq	a1,a5,8000442c <create+0xd8>
    if (dirlink(dp, name, ip->inum)) {
    800043fc:	40d0                	lw	a2,4(s1)
    800043fe:	fb040593          	addi	a1,s0,-80
    80004402:	8556                	mv	a0,s5
    80004404:	fffff097          	auipc	ra,0xfffff
    80004408:	3f6080e7          	jalr	1014(ra) # 800037fa <dirlink>
    8000440c:	e93d                	bnez	a0,80004482 <create+0x12e>
    unlock_and_putback(dp);
    8000440e:	8556                	mv	a0,s5
    80004410:	fffff097          	auipc	ra,0xfffff
    80004414:	f56080e7          	jalr	-170(ra) # 80003366 <unlock_and_putback>
    return ip;
    80004418:	bf59                	j	800043ae <create+0x5a>
        panic("alloc inode");
    8000441a:	00002517          	auipc	a0,0x2
    8000441e:	22650513          	addi	a0,a0,550 # 80006640 <syscalls+0x70>
    80004422:	ffffd097          	auipc	ra,0xffffd
    80004426:	254080e7          	jalr	596(ra) # 80001676 <panic>
    8000442a:	b75d                	j	800043d0 <create+0x7c>
        dp->nlink++; // .. 链接父目录
    8000442c:	04aad783          	lhu	a5,74(s5)
    80004430:	2785                	addiw	a5,a5,1
    80004432:	04fa9523          	sh	a5,74(s5)
        update_inode(dp);
    80004436:	8556                	mv	a0,s5
    80004438:	fffff097          	auipc	ra,0xfffff
    8000443c:	9ca080e7          	jalr	-1590(ra) # 80002e02 <update_inode>
        if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum)) {
    80004440:	40d0                	lw	a2,4(s1)
    80004442:	00002597          	auipc	a1,0x2
    80004446:	20e58593          	addi	a1,a1,526 # 80006650 <syscalls+0x80>
    8000444a:	8526                	mv	a0,s1
    8000444c:	fffff097          	auipc	ra,0xfffff
    80004450:	3ae080e7          	jalr	942(ra) # 800037fa <dirlink>
    80004454:	00054e63          	bltz	a0,80004470 <create+0x11c>
    80004458:	004aa603          	lw	a2,4(s5)
    8000445c:	00002597          	auipc	a1,0x2
    80004460:	1fc58593          	addi	a1,a1,508 # 80006658 <syscalls+0x88>
    80004464:	8526                	mv	a0,s1
    80004466:	fffff097          	auipc	ra,0xfffff
    8000446a:	394080e7          	jalr	916(ra) # 800037fa <dirlink>
    8000446e:	d559                	beqz	a0,800043fc <create+0xa8>
            panic("create .. , . dir entry");
    80004470:	00002517          	auipc	a0,0x2
    80004474:	1f050513          	addi	a0,a0,496 # 80006660 <syscalls+0x90>
    80004478:	ffffd097          	auipc	ra,0xffffd
    8000447c:	1fe080e7          	jalr	510(ra) # 80001676 <panic>
    80004480:	bfb5                	j	800043fc <create+0xa8>
        panic("create: dirlink");
    80004482:	00002517          	auipc	a0,0x2
    80004486:	1f650513          	addi	a0,a0,502 # 80006678 <syscalls+0xa8>
    8000448a:	ffffd097          	auipc	ra,0xffffd
    8000448e:	1ec080e7          	jalr	492(ra) # 80001676 <panic>
    80004492:	bfb5                	j	8000440e <create+0xba>
        return 0;
    80004494:	84aa                	mv	s1,a0
    80004496:	bf21                	j	800043ae <create+0x5a>

0000000080004498 <argfd>:
int argfd(int n, int *fdp, struct file **fp) {
    80004498:	7179                	addi	sp,sp,-48
    8000449a:	f406                	sd	ra,40(sp)
    8000449c:	f022                	sd	s0,32(sp)
    8000449e:	ec26                	sd	s1,24(sp)
    800044a0:	e84a                	sd	s2,16(sp)
    800044a2:	1800                	addi	s0,sp,48
    800044a4:	892e                	mv	s2,a1
    800044a6:	84b2                	mv	s1,a2
    if (argint(n, &fd) < 0) {
    800044a8:	fdc40593          	addi	a1,s0,-36
    800044ac:	00000097          	auipc	ra,0x0
    800044b0:	d6e080e7          	jalr	-658(ra) # 8000421a <argint>
    800044b4:	04054163          	bltz	a0,800044f6 <argfd+0x5e>
    if (fd < 0 || fd > NFILE || (f = myproc()->open_file[fd]) == 0) {
    800044b8:	fdc42703          	lw	a4,-36(s0)
    800044bc:	0c800793          	li	a5,200
    800044c0:	02e7ed63          	bltu	a5,a4,800044fa <argfd+0x62>
    800044c4:	ffffc097          	auipc	ra,0xffffc
    800044c8:	4ec080e7          	jalr	1260(ra) # 800009b0 <myproc>
    800044cc:	fdc42703          	lw	a4,-36(s0)
    800044d0:	00a70793          	addi	a5,a4,10
    800044d4:	078e                	slli	a5,a5,0x3
    800044d6:	953e                	add	a0,a0,a5
    800044d8:	651c                	ld	a5,8(a0)
    800044da:	c395                	beqz	a5,800044fe <argfd+0x66>
    if (fdp)
    800044dc:	00090463          	beqz	s2,800044e4 <argfd+0x4c>
        *fdp = fd;
    800044e0:	00e92023          	sw	a4,0(s2)
    return 0;
    800044e4:	4501                	li	a0,0
    if (fp)
    800044e6:	c091                	beqz	s1,800044ea <argfd+0x52>
        *fp = f;
    800044e8:	e09c                	sd	a5,0(s1)
}
    800044ea:	70a2                	ld	ra,40(sp)
    800044ec:	7402                	ld	s0,32(sp)
    800044ee:	64e2                	ld	s1,24(sp)
    800044f0:	6942                	ld	s2,16(sp)
    800044f2:	6145                	addi	sp,sp,48
    800044f4:	8082                	ret
        return -1;
    800044f6:	557d                	li	a0,-1
    800044f8:	bfcd                	j	800044ea <argfd+0x52>
        return -1;
    800044fa:	557d                	li	a0,-1
    800044fc:	b7fd                	j	800044ea <argfd+0x52>
    800044fe:	557d                	li	a0,-1
    80004500:	b7ed                	j	800044ea <argfd+0x52>

0000000080004502 <sys_putchar>:
uint64 sys_putchar(void) {
    80004502:	1141                	addi	sp,sp,-16
    80004504:	e406                	sd	ra,8(sp)
    80004506:	e022                	sd	s0,0(sp)
    80004508:	0800                	addi	s0,sp,16
    putc(0, argraw(0));
    8000450a:	4501                	li	a0,0
    8000450c:	00000097          	auipc	ra,0x0
    80004510:	c4e080e7          	jalr	-946(ra) # 8000415a <argraw>
    80004514:	0ff57593          	andi	a1,a0,255
    80004518:	4501                	li	a0,0
    8000451a:	ffffc097          	auipc	ra,0xffffc
    8000451e:	e64080e7          	jalr	-412(ra) # 8000037e <putc>
}
    80004522:	4501                	li	a0,0
    80004524:	60a2                	ld	ra,8(sp)
    80004526:	6402                	ld	s0,0(sp)
    80004528:	0141                	addi	sp,sp,16
    8000452a:	8082                	ret

000000008000452c <sys_open>:

uint64 sys_open(void) {
    8000452c:	7131                	addi	sp,sp,-192
    8000452e:	fd06                	sd	ra,184(sp)
    80004530:	f922                	sd	s0,176(sp)
    80004532:	f526                	sd	s1,168(sp)
    80004534:	f14a                	sd	s2,160(sp)
    80004536:	ed4e                	sd	s3,152(sp)
    80004538:	0180                	addi	s0,sp,192
    char path[MAXPATH];
    int fd, mode;
    struct file *f;
    struct inode *ip;
    int n;
    if ((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &mode)) {
    8000453a:	08000613          	li	a2,128
    8000453e:	f5040593          	addi	a1,s0,-176
    80004542:	4501                	li	a0,0
    80004544:	00000097          	auipc	ra,0x0
    80004548:	d64080e7          	jalr	-668(ra) # 800042a8 <argstr>
        return -1;
    8000454c:	57fd                	li	a5,-1
    if ((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &mode)) {
    8000454e:	14054d63          	bltz	a0,800046a8 <sys_open+0x17c>
    80004552:	f4c40593          	addi	a1,s0,-180
    80004556:	4505                	li	a0,1
    80004558:	00000097          	auipc	ra,0x0
    8000455c:	cc2080e7          	jalr	-830(ra) # 8000421a <argint>
    80004560:	84aa                	mv	s1,a0
        return -1;
    80004562:	57fd                	li	a5,-1
    if ((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &mode)) {
    80004564:	14051263          	bnez	a0,800046a8 <sys_open+0x17c>
    }

    if (mode & O_CREATE) {
    80004568:	f4c42783          	lw	a5,-180(s0)
    8000456c:	2007f793          	andi	a5,a5,512
    80004570:	c3c1                	beqz	a5,800045f0 <sys_open+0xc4>
        ip = create(path, T_FILE, 0, 0);
    80004572:	4681                	li	a3,0
    80004574:	4601                	li	a2,0
    80004576:	4589                	li	a1,2
    80004578:	f5040513          	addi	a0,s0,-176
    8000457c:	00000097          	auipc	ra,0x0
    80004580:	dd8080e7          	jalr	-552(ra) # 80004354 <create>
    80004584:	892a                	mv	s2,a0
        if (ip == 0) {
    80004586:	14050663          	beqz	a0,800046d2 <sys_open+0x1a6>
            unlock_and_putback(ip);
            return -1;
        }
    }
    // 目录权限限制为仅可读
    if (ip->type == T_DIR && (mode != O_RDONLY)) {
    8000458a:	04451783          	lh	a5,68(a0)
    8000458e:	0007869b          	sext.w	a3,a5
    80004592:	4705                	li	a4,1
    80004594:	08e68b63          	beq	a3,a4,8000462a <sys_open+0xfe>
        unlock_and_putback(ip);
        return -1;
    }

    if (ip->type == T_DEVICE && (ip->major < 0 || ip->minor > NDEV)) {
    80004598:	2781                	sext.w	a5,a5
    8000459a:	470d                	li	a4,3
    8000459c:	00e79b63          	bne	a5,a4,800045b2 <sys_open+0x86>
    800045a0:	04691783          	lh	a5,70(s2)
    800045a4:	0807cc63          	bltz	a5,8000463c <sys_open+0x110>
    800045a8:	04891703          	lh	a4,72(s2)
    800045ac:	47a9                	li	a5,10
    800045ae:	08e7c763          	blt	a5,a4,8000463c <sys_open+0x110>
        unlock_and_putback(ip);
        return -1;
    }

    if ((f = file_alloc()) == 0 || (fd = fdalloc(f)) < 0) {
    800045b2:	ffffe097          	auipc	ra,0xffffe
    800045b6:	2a8080e7          	jalr	680(ra) # 8000285a <file_alloc>
    800045ba:	89aa                	mv	s3,a0
    800045bc:	c11d                	beqz	a0,800045e2 <sys_open+0xb6>
    struct proc *p = myproc();
    800045be:	ffffc097          	auipc	ra,0xffffc
    800045c2:	3f2080e7          	jalr	1010(ra) # 800009b0 <myproc>
    for (fd = 0; fd < NOFILE; fd++) {
    800045c6:	05850793          	addi	a5,a0,88
    800045ca:	46c1                	li	a3,16
        if (p->open_file[fd] == 0) {
    800045cc:	6398                	ld	a4,0(a5)
    800045ce:	cf35                	beqz	a4,8000464a <sys_open+0x11e>
    for (fd = 0; fd < NOFILE; fd++) {
    800045d0:	2485                	addiw	s1,s1,1
    800045d2:	07a1                	addi	a5,a5,8
    800045d4:	fed49ce3          	bne	s1,a3,800045cc <sys_open+0xa0>
        if (f)
            file_close(f);
    800045d8:	854e                	mv	a0,s3
    800045da:	ffffe097          	auipc	ra,0xffffe
    800045de:	340080e7          	jalr	832(ra) # 8000291a <file_close>
        putback_inode(ip);
    800045e2:	854a                	mv	a0,s2
    800045e4:	fffff097          	auipc	ra,0xfffff
    800045e8:	b90080e7          	jalr	-1136(ra) # 80003174 <putback_inode>
        return -1;
    800045ec:	57fd                	li	a5,-1
    800045ee:	a86d                	j	800046a8 <sys_open+0x17c>
        if ((ip = namei(path)) == 0) {
    800045f0:	f5040513          	addi	a0,s0,-176
    800045f4:	fffff097          	auipc	ra,0xfffff
    800045f8:	2e2080e7          	jalr	738(ra) # 800038d6 <namei>
    800045fc:	892a                	mv	s2,a0
    800045fe:	cd61                	beqz	a0,800046d6 <sys_open+0x1aa>
        lock_inode(ip);
    80004600:	fffff097          	auipc	ra,0xfffff
    80004604:	c5a080e7          	jalr	-934(ra) # 8000325a <lock_inode>
        if (ip->type == T_DIR && mode != O_RDONLY) {
    80004608:	04491783          	lh	a5,68(s2)
    8000460c:	0007869b          	sext.w	a3,a5
    80004610:	4705                	li	a4,1
    80004612:	f8e693e3          	bne	a3,a4,80004598 <sys_open+0x6c>
    80004616:	f4c42783          	lw	a5,-180(s0)
    8000461a:	dfc1                	beqz	a5,800045b2 <sys_open+0x86>
            unlock_and_putback(ip);
    8000461c:	854a                	mv	a0,s2
    8000461e:	fffff097          	auipc	ra,0xfffff
    80004622:	d48080e7          	jalr	-696(ra) # 80003366 <unlock_and_putback>
            return -1;
    80004626:	57fd                	li	a5,-1
    80004628:	a041                	j	800046a8 <sys_open+0x17c>
    if (ip->type == T_DIR && (mode != O_RDONLY)) {
    8000462a:	f4c42783          	lw	a5,-180(s0)
    8000462e:	d3d1                	beqz	a5,800045b2 <sys_open+0x86>
        unlock_and_putback(ip);
    80004630:	fffff097          	auipc	ra,0xfffff
    80004634:	d36080e7          	jalr	-714(ra) # 80003366 <unlock_and_putback>
        return -1;
    80004638:	57fd                	li	a5,-1
    8000463a:	a0bd                	j	800046a8 <sys_open+0x17c>
        unlock_and_putback(ip);
    8000463c:	854a                	mv	a0,s2
    8000463e:	fffff097          	auipc	ra,0xfffff
    80004642:	d28080e7          	jalr	-728(ra) # 80003366 <unlock_and_putback>
        return -1;
    80004646:	57fd                	li	a5,-1
    80004648:	a085                	j	800046a8 <sys_open+0x17c>
            p->open_file[fd] = f;
    8000464a:	00a48793          	addi	a5,s1,10
    8000464e:	078e                	slli	a5,a5,0x3
    80004650:	953e                	add	a0,a0,a5
    80004652:	01353423          	sd	s3,8(a0)
    if ((f = file_alloc()) == 0 || (fd = fdalloc(f)) < 0) {
    80004656:	f804c1e3          	bltz	s1,800045d8 <sys_open+0xac>
    }
    if (ip->type == T_DEVICE) {
    8000465a:	04491703          	lh	a4,68(s2)
    8000465e:	478d                	li	a5,3
    80004660:	04f70c63          	beq	a4,a5,800046b8 <sys_open+0x18c>
        f->type = FD_DEVICE;
        f->major = ip->major;
    } else {
        f->type = FD_INODE;
    80004664:	4789                	li	a5,2
    80004666:	00f9a023          	sw	a5,0(s3)
        f->off = 0;
    8000466a:	0009ac23          	sw	zero,24(s3)
    }

    f->ip = ip;
    8000466e:	0129b823          	sd	s2,16(s3)
    f->readable = !(mode & O_WRONLY);
    80004672:	f4c42783          	lw	a5,-180(s0)
    80004676:	0017c713          	xori	a4,a5,1
    8000467a:	8b05                	andi	a4,a4,1
    8000467c:	00e98423          	sb	a4,8(s3)
    f->writable = (mode & O_WRONLY) || (mode & O_RDWR);
    80004680:	0037f713          	andi	a4,a5,3
    80004684:	00e03733          	snez	a4,a4
    80004688:	00e984a3          	sb	a4,9(s3)
    if ((mode & O_TRUNC) && ip->type == T_FILE) {
    8000468c:	4007f793          	andi	a5,a5,1024
    80004690:	c791                	beqz	a5,8000469c <sys_open+0x170>
    80004692:	04491703          	lh	a4,68(s2)
    80004696:	4789                	li	a5,2
    80004698:	02f70763          	beq	a4,a5,800046c6 <sys_open+0x19a>
        trunc_inode(ip);
    }
    unlock_inode(ip);
    8000469c:	854a                	mv	a0,s2
    8000469e:	fffff097          	auipc	ra,0xfffff
    800046a2:	c82080e7          	jalr	-894(ra) # 80003320 <unlock_inode>
    return fd;
    800046a6:	87a6                	mv	a5,s1
}
    800046a8:	853e                	mv	a0,a5
    800046aa:	70ea                	ld	ra,184(sp)
    800046ac:	744a                	ld	s0,176(sp)
    800046ae:	74aa                	ld	s1,168(sp)
    800046b0:	790a                	ld	s2,160(sp)
    800046b2:	69ea                	ld	s3,152(sp)
    800046b4:	6129                	addi	sp,sp,192
    800046b6:	8082                	ret
        f->type = FD_DEVICE;
    800046b8:	00f9a023          	sw	a5,0(s3)
        f->major = ip->major;
    800046bc:	04691783          	lh	a5,70(s2)
    800046c0:	00f99e23          	sh	a5,28(s3)
    800046c4:	b76d                	j	8000466e <sys_open+0x142>
        trunc_inode(ip);
    800046c6:	854a                	mv	a0,s2
    800046c8:	fffff097          	auipc	ra,0xfffff
    800046cc:	a0c080e7          	jalr	-1524(ra) # 800030d4 <trunc_inode>
    800046d0:	b7f1                	j	8000469c <sys_open+0x170>
            return -1;
    800046d2:	57fd                	li	a5,-1
    800046d4:	bfd1                	j	800046a8 <sys_open+0x17c>
            return -1;
    800046d6:	57fd                	li	a5,-1
    800046d8:	bfc1                	j	800046a8 <sys_open+0x17c>

00000000800046da <sys_mknod>:

uint64
sys_mknod() {
    800046da:	7135                	addi	sp,sp,-160
    800046dc:	ed06                	sd	ra,152(sp)
    800046de:	e922                	sd	s0,144(sp)
    800046e0:	1100                	addi	s0,sp,160
    struct inode *ip;
    char path[MAXPATH];
    printf("mknod\n");
    800046e2:	00002517          	auipc	a0,0x2
    800046e6:	fa650513          	addi	a0,a0,-90 # 80006688 <syscalls+0xb8>
    800046ea:	ffffd097          	auipc	ra,0xffffd
    800046ee:	ec8080e7          	jalr	-312(ra) # 800015b2 <printf>
    int major, minor;
    if (argstr(0, path, MAXPATH) < 0 ||
    800046f2:	08000613          	li	a2,128
    800046f6:	f7040593          	addi	a1,s0,-144
    800046fa:	4501                	li	a0,0
    800046fc:	00000097          	auipc	ra,0x0
    80004700:	bac080e7          	jalr	-1108(ra) # 800042a8 <argstr>
        argint(1, &major) ||
        argint(2, &minor) ||
        (ip = create(path, T_DEVICE, major, minor)) == 0) {
        return -1;
    80004704:	57fd                	li	a5,-1
    if (argstr(0, path, MAXPATH) < 0 ||
    80004706:	04054563          	bltz	a0,80004750 <sys_mknod+0x76>
        argint(1, &major) ||
    8000470a:	f6c40593          	addi	a1,s0,-148
    8000470e:	4505                	li	a0,1
    80004710:	00000097          	auipc	ra,0x0
    80004714:	b0a080e7          	jalr	-1270(ra) # 8000421a <argint>
        return -1;
    80004718:	57fd                	li	a5,-1
    if (argstr(0, path, MAXPATH) < 0 ||
    8000471a:	e91d                	bnez	a0,80004750 <sys_mknod+0x76>
        argint(2, &minor) ||
    8000471c:	f6840593          	addi	a1,s0,-152
    80004720:	4509                	li	a0,2
    80004722:	00000097          	auipc	ra,0x0
    80004726:	af8080e7          	jalr	-1288(ra) # 8000421a <argint>
        return -1;
    8000472a:	57fd                	li	a5,-1
        argint(1, &major) ||
    8000472c:	e115                	bnez	a0,80004750 <sys_mknod+0x76>
        (ip = create(path, T_DEVICE, major, minor)) == 0) {
    8000472e:	f6841683          	lh	a3,-152(s0)
    80004732:	f6c41603          	lh	a2,-148(s0)
    80004736:	458d                	li	a1,3
    80004738:	f7040513          	addi	a0,s0,-144
    8000473c:	00000097          	auipc	ra,0x0
    80004740:	c18080e7          	jalr	-1000(ra) # 80004354 <create>
        argint(2, &minor) ||
    80004744:	c919                	beqz	a0,8000475a <sys_mknod+0x80>
    }

    unlock_and_putback(ip);
    80004746:	fffff097          	auipc	ra,0xfffff
    8000474a:	c20080e7          	jalr	-992(ra) # 80003366 <unlock_and_putback>
    return 0;
    8000474e:	4781                	li	a5,0
}
    80004750:	853e                	mv	a0,a5
    80004752:	60ea                	ld	ra,152(sp)
    80004754:	644a                	ld	s0,144(sp)
    80004756:	610d                	addi	sp,sp,160
    80004758:	8082                	ret
        return -1;
    8000475a:	57fd                	li	a5,-1
    8000475c:	bfd5                	j	80004750 <sys_mknod+0x76>

000000008000475e <sys_mkdir>:

uint64 sys_mkdir() {
    8000475e:	7175                	addi	sp,sp,-144
    80004760:	e506                	sd	ra,136(sp)
    80004762:	e122                	sd	s0,128(sp)
    80004764:	0900                	addi	s0,sp,144
    char path[MAXPATH];
    struct inode *ip;
    if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    80004766:	08000613          	li	a2,128
    8000476a:	f7040593          	addi	a1,s0,-144
    8000476e:	4501                	li	a0,0
    80004770:	00000097          	auipc	ra,0x0
    80004774:	b38080e7          	jalr	-1224(ra) # 800042a8 <argstr>
        return -1;
    80004778:	57fd                	li	a5,-1
    if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    8000477a:	02054163          	bltz	a0,8000479c <sys_mkdir+0x3e>
    8000477e:	4681                	li	a3,0
    80004780:	4601                	li	a2,0
    80004782:	4585                	li	a1,1
    80004784:	f7040513          	addi	a0,s0,-144
    80004788:	00000097          	auipc	ra,0x0
    8000478c:	bcc080e7          	jalr	-1076(ra) # 80004354 <create>
    80004790:	c919                	beqz	a0,800047a6 <sys_mkdir+0x48>
    }
    unlock_and_putback(ip);
    80004792:	fffff097          	auipc	ra,0xfffff
    80004796:	bd4080e7          	jalr	-1068(ra) # 80003366 <unlock_and_putback>
    return 0;
    8000479a:	4781                	li	a5,0
}
    8000479c:	853e                	mv	a0,a5
    8000479e:	60aa                	ld	ra,136(sp)
    800047a0:	640a                	ld	s0,128(sp)
    800047a2:	6149                	addi	sp,sp,144
    800047a4:	8082                	ret
        return -1;
    800047a6:	57fd                	li	a5,-1
    800047a8:	bfd5                	j	8000479c <sys_mkdir+0x3e>

00000000800047aa <sys_chdir>:

uint64 sys_chdir() {
    800047aa:	7135                	addi	sp,sp,-160
    800047ac:	ed06                	sd	ra,152(sp)
    800047ae:	e922                	sd	s0,144(sp)
    800047b0:	e526                	sd	s1,136(sp)
    800047b2:	e14a                	sd	s2,128(sp)
    800047b4:	1100                	addi	s0,sp,160
    char path[MAXPATH];
    struct inode *ip;
    struct proc *p = myproc();
    800047b6:	ffffc097          	auipc	ra,0xffffc
    800047ba:	1fa080e7          	jalr	506(ra) # 800009b0 <myproc>
    800047be:	892a                	mv	s2,a0

    if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0)
    800047c0:	08000613          	li	a2,128
    800047c4:	f6040593          	addi	a1,s0,-160
    800047c8:	4501                	li	a0,0
    800047ca:	00000097          	auipc	ra,0x0
    800047ce:	ade080e7          	jalr	-1314(ra) # 800042a8 <argstr>
        return -1;
    800047d2:	57fd                	li	a5,-1
    if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0)
    800047d4:	04054163          	bltz	a0,80004816 <sys_chdir+0x6c>
    800047d8:	f6040513          	addi	a0,s0,-160
    800047dc:	fffff097          	auipc	ra,0xfffff
    800047e0:	0fa080e7          	jalr	250(ra) # 800038d6 <namei>
    800047e4:	84aa                	mv	s1,a0
    800047e6:	c531                	beqz	a0,80004832 <sys_chdir+0x88>
    lock_inode(ip);
    800047e8:	fffff097          	auipc	ra,0xfffff
    800047ec:	a72080e7          	jalr	-1422(ra) # 8000325a <lock_inode>

    if (ip->type != T_DIR) {
    800047f0:	04449703          	lh	a4,68(s1)
    800047f4:	4785                	li	a5,1
    800047f6:	02f71763          	bne	a4,a5,80004824 <sys_chdir+0x7a>
        unlock_and_putback(ip);
        return -1;
    }
    unlock_inode(ip);
    800047fa:	8526                	mv	a0,s1
    800047fc:	fffff097          	auipc	ra,0xfffff
    80004800:	b24080e7          	jalr	-1244(ra) # 80003320 <unlock_inode>
    putback_inode(p->current_dir);
    80004804:	05093503          	ld	a0,80(s2)
    80004808:	fffff097          	auipc	ra,0xfffff
    8000480c:	96c080e7          	jalr	-1684(ra) # 80003174 <putback_inode>
    p->current_dir = ip;
    80004810:	04993823          	sd	s1,80(s2)
    return 0;
    80004814:	4781                	li	a5,0
}
    80004816:	853e                	mv	a0,a5
    80004818:	60ea                	ld	ra,152(sp)
    8000481a:	644a                	ld	s0,144(sp)
    8000481c:	64aa                	ld	s1,136(sp)
    8000481e:	690a                	ld	s2,128(sp)
    80004820:	610d                	addi	sp,sp,160
    80004822:	8082                	ret
        unlock_and_putback(ip);
    80004824:	8526                	mv	a0,s1
    80004826:	fffff097          	auipc	ra,0xfffff
    8000482a:	b40080e7          	jalr	-1216(ra) # 80003366 <unlock_and_putback>
        return -1;
    8000482e:	57fd                	li	a5,-1
    80004830:	b7dd                	j	80004816 <sys_chdir+0x6c>
        return -1;
    80004832:	57fd                	li	a5,-1
    80004834:	b7cd                	j	80004816 <sys_chdir+0x6c>

0000000080004836 <sys_dup>:

uint64
sys_dup(void) {
    80004836:	7179                	addi	sp,sp,-48
    80004838:	f406                	sd	ra,40(sp)
    8000483a:	f022                	sd	s0,32(sp)
    8000483c:	ec26                	sd	s1,24(sp)
    8000483e:	e84a                	sd	s2,16(sp)
    80004840:	1800                	addi	s0,sp,48
    struct file *f;
    int fd;

    if (argfd(0, 0, &f) < 0)
    80004842:	fd840613          	addi	a2,s0,-40
    80004846:	4581                	li	a1,0
    80004848:	4501                	li	a0,0
    8000484a:	00000097          	auipc	ra,0x0
    8000484e:	c4e080e7          	jalr	-946(ra) # 80004498 <argfd>
        return -1;
    80004852:	54fd                	li	s1,-1
    if (argfd(0, 0, &f) < 0)
    80004854:	04054263          	bltz	a0,80004898 <sys_dup+0x62>
    if ((fd = fdalloc(f)) < 0)
    80004858:	fd843903          	ld	s2,-40(s0)
    struct proc *p = myproc();
    8000485c:	ffffc097          	auipc	ra,0xffffc
    80004860:	154080e7          	jalr	340(ra) # 800009b0 <myproc>
    for (fd = 0; fd < NOFILE; fd++) {
    80004864:	05850793          	addi	a5,a0,88
    80004868:	4481                	li	s1,0
    8000486a:	46c1                	li	a3,16
        if (p->open_file[fd] == 0) {
    8000486c:	6398                	ld	a4,0(a5)
    8000486e:	c719                	beqz	a4,8000487c <sys_dup+0x46>
    for (fd = 0; fd < NOFILE; fd++) {
    80004870:	2485                	addiw	s1,s1,1
    80004872:	07a1                	addi	a5,a5,8
    80004874:	fed49ce3          	bne	s1,a3,8000486c <sys_dup+0x36>
        return -1;
    80004878:	54fd                	li	s1,-1
    8000487a:	a839                	j	80004898 <sys_dup+0x62>
            p->open_file[fd] = f;
    8000487c:	00a48793          	addi	a5,s1,10
    80004880:	078e                	slli	a5,a5,0x3
    80004882:	953e                	add	a0,a0,a5
    80004884:	01253423          	sd	s2,8(a0)
    if ((fd = fdalloc(f)) < 0)
    80004888:	0004cf63          	bltz	s1,800048a6 <sys_dup+0x70>
    file_dup(f);
    8000488c:	fd843503          	ld	a0,-40(s0)
    80004890:	ffffe097          	auipc	ra,0xffffe
    80004894:	034080e7          	jalr	52(ra) # 800028c4 <file_dup>
    return fd;
}
    80004898:	8526                	mv	a0,s1
    8000489a:	70a2                	ld	ra,40(sp)
    8000489c:	7402                	ld	s0,32(sp)
    8000489e:	64e2                	ld	s1,24(sp)
    800048a0:	6942                	ld	s2,16(sp)
    800048a2:	6145                	addi	sp,sp,48
    800048a4:	8082                	ret
        return -1;
    800048a6:	54fd                	li	s1,-1
    800048a8:	bfc5                	j	80004898 <sys_dup+0x62>

00000000800048aa <sys_read>:

uint64 sys_read(void) {
    800048aa:	7179                	addi	sp,sp,-48
    800048ac:	f406                	sd	ra,40(sp)
    800048ae:	f022                	sd	s0,32(sp)
    800048b0:	1800                	addi	s0,sp,48
    struct file *f;
    int n;
    uint64 uaddr;

    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &uaddr) < 0)
    800048b2:	fe840613          	addi	a2,s0,-24
    800048b6:	4581                	li	a1,0
    800048b8:	4501                	li	a0,0
    800048ba:	00000097          	auipc	ra,0x0
    800048be:	bde080e7          	jalr	-1058(ra) # 80004498 <argfd>
        return -1;
    800048c2:	57fd                	li	a5,-1
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &uaddr) < 0)
    800048c4:	04054163          	bltz	a0,80004906 <sys_read+0x5c>
    800048c8:	fe440593          	addi	a1,s0,-28
    800048cc:	4509                	li	a0,2
    800048ce:	00000097          	auipc	ra,0x0
    800048d2:	94c080e7          	jalr	-1716(ra) # 8000421a <argint>
        return -1;
    800048d6:	57fd                	li	a5,-1
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &uaddr) < 0)
    800048d8:	02054763          	bltz	a0,80004906 <sys_read+0x5c>
    800048dc:	fd840593          	addi	a1,s0,-40
    800048e0:	4505                	li	a0,1
    800048e2:	00000097          	auipc	ra,0x0
    800048e6:	95a080e7          	jalr	-1702(ra) # 8000423c <argaddr>
        return -1;
    800048ea:	57fd                	li	a5,-1
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &uaddr) < 0)
    800048ec:	00054d63          	bltz	a0,80004906 <sys_read+0x5c>
    return file_read(f, uaddr, n);
    800048f0:	fe442603          	lw	a2,-28(s0)
    800048f4:	fd843583          	ld	a1,-40(s0)
    800048f8:	fe843503          	ld	a0,-24(s0)
    800048fc:	ffffe097          	auipc	ra,0xffffe
    80004900:	12a080e7          	jalr	298(ra) # 80002a26 <file_read>
    80004904:	87aa                	mv	a5,a0
}
    80004906:	853e                	mv	a0,a5
    80004908:	70a2                	ld	ra,40(sp)
    8000490a:	7402                	ld	s0,32(sp)
    8000490c:	6145                	addi	sp,sp,48
    8000490e:	8082                	ret

0000000080004910 <sys_write>:

uint64 sys_write(void) {
    80004910:	7179                	addi	sp,sp,-48
    80004912:	f406                	sd	ra,40(sp)
    80004914:	f022                	sd	s0,32(sp)
    80004916:	1800                	addi	s0,sp,48
    struct file *f;
    int n;
    uint64 uaddr;
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &uaddr) < 0)
    80004918:	fe840613          	addi	a2,s0,-24
    8000491c:	4581                	li	a1,0
    8000491e:	4501                	li	a0,0
    80004920:	00000097          	auipc	ra,0x0
    80004924:	b78080e7          	jalr	-1160(ra) # 80004498 <argfd>
        return -1;
    80004928:	57fd                	li	a5,-1
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &uaddr) < 0)
    8000492a:	04054163          	bltz	a0,8000496c <sys_write+0x5c>
    8000492e:	fe440593          	addi	a1,s0,-28
    80004932:	4509                	li	a0,2
    80004934:	00000097          	auipc	ra,0x0
    80004938:	8e6080e7          	jalr	-1818(ra) # 8000421a <argint>
        return -1;
    8000493c:	57fd                	li	a5,-1
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &uaddr) < 0)
    8000493e:	02054763          	bltz	a0,8000496c <sys_write+0x5c>
    80004942:	fd840593          	addi	a1,s0,-40
    80004946:	4505                	li	a0,1
    80004948:	00000097          	auipc	ra,0x0
    8000494c:	8f4080e7          	jalr	-1804(ra) # 8000423c <argaddr>
        return -1;
    80004950:	57fd                	li	a5,-1
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &uaddr) < 0)
    80004952:	00054d63          	bltz	a0,8000496c <sys_write+0x5c>

    return file_write(f, uaddr, n);
    80004956:	fe442603          	lw	a2,-28(s0)
    8000495a:	fd843583          	ld	a1,-40(s0)
    8000495e:	fe843503          	ld	a0,-24(s0)
    80004962:	ffffe097          	auipc	ra,0xffffe
    80004966:	16a080e7          	jalr	362(ra) # 80002acc <file_write>
    8000496a:	87aa                	mv	a5,a0
}
    8000496c:	853e                	mv	a0,a5
    8000496e:	70a2                	ld	ra,40(sp)
    80004970:	7402                	ld	s0,32(sp)
    80004972:	6145                	addi	sp,sp,48
    80004974:	8082                	ret

0000000080004976 <sys_close>:

uint64 sys_close(void) {
    80004976:	1101                	addi	sp,sp,-32
    80004978:	ec06                	sd	ra,24(sp)
    8000497a:	e822                	sd	s0,16(sp)
    8000497c:	1000                	addi	s0,sp,32
    int fd;
    struct file *f;

    if (argfd(0, &fd, &f) < 0)
    8000497e:	fe040613          	addi	a2,s0,-32
    80004982:	fec40593          	addi	a1,s0,-20
    80004986:	4501                	li	a0,0
    80004988:	00000097          	auipc	ra,0x0
    8000498c:	b10080e7          	jalr	-1264(ra) # 80004498 <argfd>
        return -1;
    80004990:	57fd                	li	a5,-1
    if (argfd(0, &fd, &f) < 0)
    80004992:	02054463          	bltz	a0,800049ba <sys_close+0x44>
    myproc()->open_file[fd] = 0;
    80004996:	ffffc097          	auipc	ra,0xffffc
    8000499a:	01a080e7          	jalr	26(ra) # 800009b0 <myproc>
    8000499e:	fec42783          	lw	a5,-20(s0)
    800049a2:	07a9                	addi	a5,a5,10
    800049a4:	078e                	slli	a5,a5,0x3
    800049a6:	97aa                	add	a5,a5,a0
    800049a8:	0007b423          	sd	zero,8(a5)
    file_close(f);
    800049ac:	fe043503          	ld	a0,-32(s0)
    800049b0:	ffffe097          	auipc	ra,0xffffe
    800049b4:	f6a080e7          	jalr	-150(ra) # 8000291a <file_close>
    return 0;
    800049b8:	4781                	li	a5,0
}
    800049ba:	853e                	mv	a0,a5
    800049bc:	60e2                	ld	ra,24(sp)
    800049be:	6442                	ld	s0,16(sp)
    800049c0:	6105                	addi	sp,sp,32
    800049c2:	8082                	ret

00000000800049c4 <sys_fstat>:

uint64 sys_fstat(void) {
    800049c4:	1101                	addi	sp,sp,-32
    800049c6:	ec06                	sd	ra,24(sp)
    800049c8:	e822                	sd	s0,16(sp)
    800049ca:	1000                	addi	s0,sp,32
    struct file *f;
    uint64 uaddr;
    if (argfd(0, 0, &f) < 0) {
    800049cc:	fe840613          	addi	a2,s0,-24
    800049d0:	4581                	li	a1,0
    800049d2:	4501                	li	a0,0
    800049d4:	00000097          	auipc	ra,0x0
    800049d8:	ac4080e7          	jalr	-1340(ra) # 80004498 <argfd>
        return -1;
    800049dc:	57fd                	li	a5,-1
    if (argfd(0, 0, &f) < 0) {
    800049de:	02054563          	bltz	a0,80004a08 <sys_fstat+0x44>
    }
    if (argaddr(1, &uaddr) < 0) {
    800049e2:	fe040593          	addi	a1,s0,-32
    800049e6:	4505                	li	a0,1
    800049e8:	00000097          	auipc	ra,0x0
    800049ec:	854080e7          	jalr	-1964(ra) # 8000423c <argaddr>
        return -1;
    800049f0:	57fd                	li	a5,-1
    if (argaddr(1, &uaddr) < 0) {
    800049f2:	00054b63          	bltz	a0,80004a08 <sys_fstat+0x44>
    }
    file_stat(f, uaddr);
    800049f6:	fe043583          	ld	a1,-32(s0)
    800049fa:	fe843503          	ld	a0,-24(s0)
    800049fe:	ffffe097          	auipc	ra,0xffffe
    80004a02:	fb6080e7          	jalr	-74(ra) # 800029b4 <file_stat>
    return 0;
    80004a06:	4781                	li	a5,0
}
    80004a08:	853e                	mv	a0,a5
    80004a0a:	60e2                	ld	ra,24(sp)
    80004a0c:	6442                	ld	s0,16(sp)
    80004a0e:	6105                	addi	sp,sp,32
    80004a10:	8082                	ret

0000000080004a12 <sys_exec>:

uint64 sys_exec(void) {
    80004a12:	7145                	addi	sp,sp,-464
    80004a14:	e786                	sd	ra,456(sp)
    80004a16:	e3a2                	sd	s0,448(sp)
    80004a18:	ff26                	sd	s1,440(sp)
    80004a1a:	fb4a                	sd	s2,432(sp)
    80004a1c:	f74e                	sd	s3,424(sp)
    80004a1e:	f352                	sd	s4,416(sp)
    80004a20:	ef56                	sd	s5,408(sp)
    80004a22:	0b80                	addi	s0,sp,464
    char path[MAXPATH], *argv[MAXARG];
    uint64 uargv, uarg=0;
    80004a24:	e2043823          	sd	zero,-464(s0)
    if (argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0)
    80004a28:	08000613          	li	a2,128
    80004a2c:	f4040593          	addi	a1,s0,-192
    80004a30:	4501                	li	a0,0
    80004a32:	00000097          	auipc	ra,0x0
    80004a36:	876080e7          	jalr	-1930(ra) # 800042a8 <argstr>
        return -1;
    80004a3a:	54fd                	li	s1,-1
    if (argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0)
    80004a3c:	0c054c63          	bltz	a0,80004b14 <sys_exec+0x102>
    80004a40:	e3840593          	addi	a1,s0,-456
    80004a44:	4505                	li	a0,1
    80004a46:	fffff097          	auipc	ra,0xfffff
    80004a4a:	7f6080e7          	jalr	2038(ra) # 8000423c <argaddr>
    80004a4e:	0c054363          	bltz	a0,80004b14 <sys_exec+0x102>
    if (strlen(path) < 1)
    80004a52:	f4040513          	addi	a0,s0,-192
    80004a56:	ffffc097          	auipc	ra,0xffffc
    80004a5a:	71e080e7          	jalr	1822(ra) # 80001174 <strlen>
    80004a5e:	2501                	sext.w	a0,a0
    80004a60:	c955                	beqz	a0,80004b14 <sys_exec+0x102>
        return -1;
    memset(argv, 0, sizeof(argv));
    80004a62:	10000613          	li	a2,256
    80004a66:	4581                	li	a1,0
    80004a68:	e4040513          	addi	a0,s0,-448
    80004a6c:	ffffc097          	auipc	ra,0xffffc
    80004a70:	686080e7          	jalr	1670(ra) # 800010f2 <memset>
    for (int i = 0;; i++) {
        if (i > MAXARG)
    80004a74:	e4040913          	addi	s2,s0,-448
    memset(argv, 0, sizeof(argv));
    80004a78:	89ca                	mv	s3,s2
    80004a7a:	4481                	li	s1,0
        if (i > MAXARG)
    80004a7c:	02100a13          	li	s4,33
    80004a80:	00048a9b          	sext.w	s5,s1
            goto bad;
        if (fetchaddr(uargv + sizeof(uint64) * i, &uarg) < 0)
    80004a84:	00349513          	slli	a0,s1,0x3
    80004a88:	e3040593          	addi	a1,s0,-464
    80004a8c:	e3843783          	ld	a5,-456(s0)
    80004a90:	953e                	add	a0,a0,a5
    80004a92:	fffff097          	auipc	ra,0xfffff
    80004a96:	734080e7          	jalr	1844(ra) # 800041c6 <fetchaddr>
    80004a9a:	06054863          	bltz	a0,80004b0a <sys_exec+0xf8>
            goto bad;
        if (uarg == 0) {
    80004a9e:	e3043783          	ld	a5,-464(s0)
    80004aa2:	c79d                	beqz	a5,80004ad0 <sys_exec+0xbe>
            argv[i] = 0;
            break;
        }
        argv[i] = kalloc();
    80004aa4:	ffffd097          	auipc	ra,0xffffd
    80004aa8:	cec080e7          	jalr	-788(ra) # 80001790 <kalloc>
    80004aac:	85aa                	mv	a1,a0
    80004aae:	00a9b023          	sd	a0,0(s3)
        if(argv[i] == 0)
    80004ab2:	cd21                	beqz	a0,80004b0a <sys_exec+0xf8>
            goto bad;
        if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004ab4:	6605                	lui	a2,0x1
    80004ab6:	e3043503          	ld	a0,-464(s0)
    80004aba:	fffff097          	auipc	ra,0xfffff
    80004abe:	7a4080e7          	jalr	1956(ra) # 8000425e <fetchstr>
    80004ac2:	04054463          	bltz	a0,80004b0a <sys_exec+0xf8>
        if (i > MAXARG)
    80004ac6:	0485                	addi	s1,s1,1
    80004ac8:	09a1                	addi	s3,s3,8
    80004aca:	fb449be3          	bne	s1,s4,80004a80 <sys_exec+0x6e>
    80004ace:	a835                	j	80004b0a <sys_exec+0xf8>
            argv[i] = 0;
    80004ad0:	0a8e                	slli	s5,s5,0x3
    80004ad2:	fc040793          	addi	a5,s0,-64
    80004ad6:	9abe                	add	s5,s5,a5
    80004ad8:	e80ab023          	sd	zero,-384(s5)
            goto bad;
    }
    int ret = exec(path,argv);
    80004adc:	e4040593          	addi	a1,s0,-448
    80004ae0:	f4040513          	addi	a0,s0,-192
    80004ae4:	ffffe097          	auipc	ra,0xffffe
    80004ae8:	a3c080e7          	jalr	-1476(ra) # 80002520 <exec>
    80004aec:	84aa                	mv	s1,a0
    for(int i = 0; i <= MAXARG && argv[i] != 0; i++)
    80004aee:	a029                	j	80004af8 <sys_exec+0xe6>
        kfree(argv[i]);
    80004af0:	ffffd097          	auipc	ra,0xffffd
    80004af4:	ba2080e7          	jalr	-1118(ra) # 80001692 <kfree>
    for(int i = 0; i <= MAXARG && argv[i] != 0; i++)
    80004af8:	0921                	addi	s2,s2,8
    80004afa:	ff893503          	ld	a0,-8(s2)
    80004afe:	f96d                	bnez	a0,80004af0 <sys_exec+0xde>
    80004b00:	a811                	j	80004b14 <sys_exec+0x102>
    return ret;

bad:
    for(int i = 0; i <= MAXARG && argv[i] != 0; i++)
        kfree(argv[i]);
    80004b02:	ffffd097          	auipc	ra,0xffffd
    80004b06:	b90080e7          	jalr	-1136(ra) # 80001692 <kfree>
    for(int i = 0; i <= MAXARG && argv[i] != 0; i++)
    80004b0a:	0921                	addi	s2,s2,8
    80004b0c:	ff893503          	ld	a0,-8(s2)
    80004b10:	f96d                	bnez	a0,80004b02 <sys_exec+0xf0>
    return -1;
    80004b12:	54fd                	li	s1,-1
}
    80004b14:	8526                	mv	a0,s1
    80004b16:	60be                	ld	ra,456(sp)
    80004b18:	641e                	ld	s0,448(sp)
    80004b1a:	74fa                	ld	s1,440(sp)
    80004b1c:	795a                	ld	s2,432(sp)
    80004b1e:	79ba                	ld	s3,424(sp)
    80004b20:	7a1a                	ld	s4,416(sp)
    80004b22:	6afa                	ld	s5,408(sp)
    80004b24:	6179                	addi	sp,sp,464
    80004b26:	8082                	ret

0000000080004b28 <sys_exit>:


//
// 进程相关的系统调用
//
uint64 sys_exit(void) {
    80004b28:	1101                	addi	sp,sp,-32
    80004b2a:	ec06                	sd	ra,24(sp)
    80004b2c:	e822                	sd	s0,16(sp)
    80004b2e:	1000                	addi	s0,sp,32
    int status = 0;
    80004b30:	fe042623          	sw	zero,-20(s0)
    if (argint(0, &status) < 0) {
    80004b34:	fec40593          	addi	a1,s0,-20
    80004b38:	4501                	li	a0,0
    80004b3a:	fffff097          	auipc	ra,0xfffff
    80004b3e:	6e0080e7          	jalr	1760(ra) # 8000421a <argint>
        return -1;
    80004b42:	57fd                	li	a5,-1
    if (argint(0, &status) < 0) {
    80004b44:	00054963          	bltz	a0,80004b56 <sys_exit+0x2e>
    }
    exit(status);
    80004b48:	fec42503          	lw	a0,-20(s0)
    80004b4c:	ffffc097          	auipc	ra,0xffffc
    80004b50:	3ae080e7          	jalr	942(ra) # 80000efa <exit>
    return 0;
    80004b54:	4781                	li	a5,0
}
    80004b56:	853e                	mv	a0,a5
    80004b58:	60e2                	ld	ra,24(sp)
    80004b5a:	6442                	ld	s0,16(sp)
    80004b5c:	6105                	addi	sp,sp,32
    80004b5e:	8082                	ret

0000000080004b60 <sys_fork>:

uint64 sys_fork(void) {
    80004b60:	1141                	addi	sp,sp,-16
    80004b62:	e406                	sd	ra,8(sp)
    80004b64:	e022                	sd	s0,0(sp)
    80004b66:	0800                	addi	s0,sp,16
    return fork();
    80004b68:	ffffc097          	auipc	ra,0xffffc
    80004b6c:	158080e7          	jalr	344(ra) # 80000cc0 <fork>
}
    80004b70:	60a2                	ld	ra,8(sp)
    80004b72:	6402                	ld	s0,0(sp)
    80004b74:	0141                	addi	sp,sp,16
    80004b76:	8082                	ret

0000000080004b78 <sys_wait>:

uint64 sys_wait(void) {
    80004b78:	1101                	addi	sp,sp,-32
    80004b7a:	ec06                	sd	ra,24(sp)
    80004b7c:	e822                	sd	s0,16(sp)
    80004b7e:	1000                	addi	s0,sp,32
    uint64 vaddr;
    argaddr(0, &vaddr);
    80004b80:	fe840593          	addi	a1,s0,-24
    80004b84:	4501                	li	a0,0
    80004b86:	fffff097          	auipc	ra,0xfffff
    80004b8a:	6b6080e7          	jalr	1718(ra) # 8000423c <argaddr>
    return wait(vaddr);
    80004b8e:	fe843503          	ld	a0,-24(s0)
    80004b92:	ffffc097          	auipc	ra,0xffffc
    80004b96:	232080e7          	jalr	562(ra) # 80000dc4 <wait>
    80004b9a:	60e2                	ld	ra,24(sp)
    80004b9c:	6442                	ld	s0,16(sp)
    80004b9e:	6105                	addi	sp,sp,32
    80004ba0:	8082                	ret
	...

0000000080005000 <_trampoline>:
    80005000:	14051573          	csrrw	a0,sscratch,a0
    80005004:	02153423          	sd	ra,40(a0)
    80005008:	02253823          	sd	sp,48(a0)
    8000500c:	02353c23          	sd	gp,56(a0)
    80005010:	04453023          	sd	tp,64(a0)
    80005014:	04553423          	sd	t0,72(a0)
    80005018:	04653823          	sd	t1,80(a0)
    8000501c:	04753c23          	sd	t2,88(a0)
    80005020:	f120                	sd	s0,96(a0)
    80005022:	f524                	sd	s1,104(a0)
    80005024:	fd2c                	sd	a1,120(a0)
    80005026:	e150                	sd	a2,128(a0)
    80005028:	e554                	sd	a3,136(a0)
    8000502a:	e958                	sd	a4,144(a0)
    8000502c:	ed5c                	sd	a5,152(a0)
    8000502e:	0b053023          	sd	a6,160(a0)
    80005032:	0b153423          	sd	a7,168(a0)
    80005036:	0b253823          	sd	s2,176(a0)
    8000503a:	0b353c23          	sd	s3,184(a0)
    8000503e:	0d453023          	sd	s4,192(a0)
    80005042:	0d553423          	sd	s5,200(a0)
    80005046:	0d653823          	sd	s6,208(a0)
    8000504a:	0d753c23          	sd	s7,216(a0)
    8000504e:	0f853023          	sd	s8,224(a0)
    80005052:	0f953423          	sd	s9,232(a0)
    80005056:	0fa53823          	sd	s10,240(a0)
    8000505a:	0fb53c23          	sd	s11,248(a0)
    8000505e:	11c53023          	sd	t3,256(a0)
    80005062:	11d53423          	sd	t4,264(a0)
    80005066:	11e53823          	sd	t5,272(a0)
    8000506a:	11f53c23          	sd	t6,280(a0)
    8000506e:	140022f3          	csrr	t0,sscratch
    80005072:	06553823          	sd	t0,112(a0)
    80005076:	00853103          	ld	sp,8(a0)
    8000507a:	02053203          	ld	tp,32(a0)
    8000507e:	01053283          	ld	t0,16(a0)
    80005082:	00053303          	ld	t1,0(a0)
    80005086:	18031073          	csrw	satp,t1
    8000508a:	12000073          	sfence.vma
    8000508e:	8282                	jr	t0

0000000080005090 <userret>:
    80005090:	18059073          	csrw	satp,a1
    80005094:	12000073          	sfence.vma
    80005098:	07053283          	ld	t0,112(a0)
    8000509c:	14029073          	csrw	sscratch,t0
    800050a0:	02853083          	ld	ra,40(a0)
    800050a4:	03053103          	ld	sp,48(a0)
    800050a8:	03853183          	ld	gp,56(a0)
    800050ac:	04053203          	ld	tp,64(a0)
    800050b0:	04853283          	ld	t0,72(a0)
    800050b4:	05053303          	ld	t1,80(a0)
    800050b8:	05853383          	ld	t2,88(a0)
    800050bc:	7120                	ld	s0,96(a0)
    800050be:	7524                	ld	s1,104(a0)
    800050c0:	7d2c                	ld	a1,120(a0)
    800050c2:	6150                	ld	a2,128(a0)
    800050c4:	6554                	ld	a3,136(a0)
    800050c6:	6958                	ld	a4,144(a0)
    800050c8:	6d5c                	ld	a5,152(a0)
    800050ca:	0a053803          	ld	a6,160(a0)
    800050ce:	0a853883          	ld	a7,168(a0)
    800050d2:	0b053903          	ld	s2,176(a0)
    800050d6:	0b853983          	ld	s3,184(a0)
    800050da:	0c053a03          	ld	s4,192(a0)
    800050de:	0c853a83          	ld	s5,200(a0)
    800050e2:	0d053b03          	ld	s6,208(a0)
    800050e6:	0d853b83          	ld	s7,216(a0)
    800050ea:	0e053c03          	ld	s8,224(a0)
    800050ee:	0e853c83          	ld	s9,232(a0)
    800050f2:	0f053d03          	ld	s10,240(a0)
    800050f6:	0f853d83          	ld	s11,248(a0)
    800050fa:	10053e03          	ld	t3,256(a0)
    800050fe:	10853e83          	ld	t4,264(a0)
    80005102:	11053f03          	ld	t5,272(a0)
    80005106:	11853f83          	ld	t6,280(a0)
    8000510a:	14051573          	csrrw	a0,sscratch,a0
    8000510e:	10200073          	sret
	...
