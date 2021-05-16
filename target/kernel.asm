
../target/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <_entry>:
    80200000:	00150293          	addi	t0,a0,1
    80200004:	02ba                	slli	t0,t0,0xe
    80200006:	0000c117          	auipc	sp,0xc
    8020000a:	ffa10113          	addi	sp,sp,-6 # 8020c000 <boot_stack>
    8020000e:	9116                	add	sp,sp,t0
    80200010:	0f2000ef          	jal	ra,80200102 <main>

0000000080200014 <loop>:
    80200014:	a001                	j	80200014 <loop>

0000000080200016 <_Z10print_logov>:

static inline void inithartid(unsigned long hartid) { asm volatile("mv tp, %0" : : "r"(hartid & 0x1)); }

volatile static int started = 0;

void print_logo() {
    80200016:	1141                	addi	sp,sp,-16
    80200018:	e406                	sd	ra,8(sp)
    8020001a:	e022                	sd	s0,0(sp)
    8020001c:	0800                	addi	s0,sp,16
  printf("\n");
    8020001e:	0000a517          	auipc	a0,0xa
    80200022:	08250513          	addi	a0,a0,130 # 8020a0a0 <rodata_start+0xa0>
    80200026:	00001097          	auipc	ra,0x1
    8020002a:	82e080e7          	jalr	-2002(ra) # 80200854 <_Z6printfPKcz>
  printf("  _____   _                 _      ____     _____\n");
    8020002e:	0000a517          	auipc	a0,0xa
    80200032:	fd250513          	addi	a0,a0,-46 # 8020a000 <rodata_start>
    80200036:	00001097          	auipc	ra,0x1
    8020003a:	81e080e7          	jalr	-2018(ra) # 80200854 <_Z6printfPKcz>
  printf(" / ____| | |               | |    / __ \\   / ____|\n");
    8020003e:	0000a517          	auipc	a0,0xa
    80200042:	ffa50513          	addi	a0,a0,-6 # 8020a038 <rodata_start+0x38>
    80200046:	00001097          	auipc	ra,0x1
    8020004a:	80e080e7          	jalr	-2034(ra) # 80200854 <_Z6printfPKcz>
  printf("| (___   | |_   __ _  _ __ | |_  | |  | | | (___\n");
    8020004e:	0000a517          	auipc	a0,0xa
    80200052:	02250513          	addi	a0,a0,34 # 8020a070 <rodata_start+0x70>
    80200056:	00000097          	auipc	ra,0x0
    8020005a:	7fe080e7          	jalr	2046(ra) # 80200854 <_Z6printfPKcz>
  printf(" \\___  \\ | __| / _` || '__|| __| | |  | |  \\___ \\\n");
    8020005e:	0000a517          	auipc	a0,0xa
    80200062:	04a50513          	addi	a0,a0,74 # 8020a0a8 <rodata_start+0xa8>
    80200066:	00000097          	auipc	ra,0x0
    8020006a:	7ee080e7          	jalr	2030(ra) # 80200854 <_Z6printfPKcz>
  printf(" ____) | | |_ | (_| || |   | |_  | |__| |  ____) |\n");
    8020006e:	0000a517          	auipc	a0,0xa
    80200072:	07250513          	addi	a0,a0,114 # 8020a0e0 <rodata_start+0xe0>
    80200076:	00000097          	auipc	ra,0x0
    8020007a:	7de080e7          	jalr	2014(ra) # 80200854 <_Z6printfPKcz>
  printf("|_____/  \\__|  \\____||_|   \\___|  \\_____/ |_____/\n");
    8020007e:	0000a517          	auipc	a0,0xa
    80200082:	09a50513          	addi	a0,a0,154 # 8020a118 <rodata_start+0x118>
    80200086:	00000097          	auipc	ra,0x0
    8020008a:	7ce080e7          	jalr	1998(ra) # 80200854 <_Z6printfPKcz>
  printf("\n");
    8020008e:	0000a517          	auipc	a0,0xa
    80200092:	01250513          	addi	a0,a0,18 # 8020a0a0 <rodata_start+0xa0>
    80200096:	00000097          	auipc	ra,0x0
    8020009a:	7be080e7          	jalr	1982(ra) # 80200854 <_Z6printfPKcz>
}
    8020009e:	60a2                	ld	ra,8(sp)
    802000a0:	6402                	ld	s0,0(sp)
    802000a2:	0141                	addi	sp,sp,16
    802000a4:	8082                	ret

00000000802000a6 <__cxa_pure_virtual>:
extern "C" void _init();
extern "C" void __cxa_pure_virtual() { LOG_DEBUG("error"); }
    802000a6:	1141                	addi	sp,sp,-16
    802000a8:	e406                	sd	ra,8(sp)
    802000aa:	e022                	sd	s0,0(sp)
    802000ac:	0800                	addi	s0,sp,16
      type = "TRACE";
      break;
    default:
      type = "UNKWN";
  }
  printf("%s [%s:%d:%s] - ", type, file, line, func);
    802000ae:	0000a717          	auipc	a4,0xa
    802000b2:	0a270713          	addi	a4,a4,162 # 8020a150 <rodata_start+0x150>
    802000b6:	02c00693          	li	a3,44
    802000ba:	0000a617          	auipc	a2,0xa
    802000be:	0ae60613          	addi	a2,a2,174 # 8020a168 <rodata_start+0x168>
    802000c2:	0000a597          	auipc	a1,0xa
    802000c6:	0b658593          	addi	a1,a1,182 # 8020a178 <rodata_start+0x178>
    802000ca:	0000a517          	auipc	a0,0xa
    802000ce:	0b650513          	addi	a0,a0,182 # 8020a180 <rodata_start+0x180>
    802000d2:	00000097          	auipc	ra,0x0
    802000d6:	782080e7          	jalr	1922(ra) # 80200854 <_Z6printfPKcz>
    802000da:	0000a517          	auipc	a0,0xa
    802000de:	61650513          	addi	a0,a0,1558 # 8020a6f0 <_ZL6digits+0x3e8>
    802000e2:	00000097          	auipc	ra,0x0
    802000e6:	772080e7          	jalr	1906(ra) # 80200854 <_Z6printfPKcz>
    802000ea:	0000a517          	auipc	a0,0xa
    802000ee:	fb650513          	addi	a0,a0,-74 # 8020a0a0 <rodata_start+0xa0>
    802000f2:	00000097          	auipc	ra,0x0
    802000f6:	762080e7          	jalr	1890(ra) # 80200854 <_Z6printfPKcz>
    802000fa:	60a2                	ld	ra,8(sp)
    802000fc:	6402                	ld	s0,0(sp)
    802000fe:	0141                	addi	sp,sp,16
    80200100:	8082                	ret

0000000080200102 <main>:

extern "C" void main(unsigned long hartid, unsigned long dtb_pa) {
    80200102:	1101                	addi	sp,sp,-32
    80200104:	ec06                	sd	ra,24(sp)
    80200106:	e822                	sd	s0,16(sp)
    80200108:	1000                	addi	s0,sp,32
static inline void inithartid(unsigned long hartid) { asm volatile("mv tp, %0" : : "r"(hartid & 0x1)); }
    8020010a:	00157713          	andi	a4,a0,1
    8020010e:	823a                	mv	tp,a4
  inithartid(hartid);  // 将hartid保存在tp寄存器中
  if (hartid == 0) {
    80200110:	c121                	beqz	a0,80200150 <main+0x4e>

static inline uint64_t
r_sstatus()
{
  uint64_t x;
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80200112:	100027f3          	csrr	a5,sstatus

// disable device interrupts
static inline void
intr_off()
{
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80200116:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80200118:	10079073          	csrw	sstatus,a5
    __sync_synchronize();
    started = 1;
  } else {
    intr_off();
    // hart 1
    while (started == 0)
    8020011c:	00023717          	auipc	a4,0x23
    80200120:	82470713          	addi	a4,a4,-2012 # 80222940 <_ZL7started>
    80200124:	431c                	lw	a5,0(a4)
    80200126:	2781                	sext.w	a5,a5
    80200128:	dff5                	beqz	a5,80200124 <main+0x22>
      ;
    __sync_synchronize();
    8020012a:	0ff0000f          	fence
    initHartVm();     //  启用分页
    8020012e:	00007097          	auipc	ra,0x7
    80200132:	c04080e7          	jalr	-1020(ra) # 80206d32 <_Z10initHartVmv>
    trapinithart();   // 初始化trap
    80200136:	00001097          	auipc	ra,0x1
    8020013a:	e66080e7          	jalr	-410(ra) # 80200f9c <_Z12trapinithartv>
    plic.initHart();  // ask PLIC for device interrupts
    8020013e:	00023517          	auipc	a0,0x23
    80200142:	80a50513          	addi	a0,a0,-2038 # 80222948 <plic>
    80200146:	00001097          	auipc	ra,0x1
    8020014a:	488080e7          	jalr	1160(ra) # 802015ce <_ZN4Plic8initHartEv>
    // printf("hart %d finish init\n", r_tp());
    while(1){};
    8020014e:	a001                	j	8020014e <main+0x4c>
    console.init();  // 初始化控制台
    80200150:	00014517          	auipc	a0,0x14
    80200154:	eb050513          	addi	a0,a0,-336 # 80214000 <console>
    80200158:	00007097          	auipc	ra,0x7
    8020015c:	8dc080e7          	jalr	-1828(ra) # 80206a34 <_ZN7Console4initEv>
    printfinit();
    80200160:	00001097          	auipc	ra,0x1
    80200164:	9a8080e7          	jalr	-1624(ra) # 80200b08 <_Z10printfinitv>
    print_logo();
    80200168:	00000097          	auipc	ra,0x0
    8020016c:	eae080e7          	jalr	-338(ra) # 80200016 <_Z10print_logov>
    memAllocator.init();  // 初始化内存
    80200170:	00014517          	auipc	a0,0x14
    80200174:	f3050513          	addi	a0,a0,-208 # 802140a0 <memAllocator>
    80200178:	00007097          	auipc	ra,0x7
    8020017c:	4de080e7          	jalr	1246(ra) # 80207656 <_ZN12MemAllocator4initEv>
    initKernelVm();       // 初始化内核虚拟内存
    80200180:	00007097          	auipc	ra,0x7
    80200184:	da8080e7          	jalr	-600(ra) # 80206f28 <_Z12initKernelVmv>
    initHartVm();         // 启用分页
    80200188:	00007097          	auipc	ra,0x7
    8020018c:	baa080e7          	jalr	-1110(ra) # 80206d32 <_Z10initHartVmv>
    timer.init();
    80200190:	00014517          	auipc	a0,0x14
    80200194:	f3050513          	addi	a0,a0,-208 # 802140c0 <timer>
    80200198:	00001097          	auipc	ra,0x1
    8020019c:	5b6080e7          	jalr	1462(ra) # 8020174e <_ZN5Timer4initEv>
    trapinithart();  // 初始化trap
    802001a0:	00001097          	auipc	ra,0x1
    802001a4:	dfc080e7          	jalr	-516(ra) # 80200f9c <_Z12trapinithartv>
    syscall_init();  // 初始化系统调用
    802001a8:	00002097          	auipc	ra,0x2
    802001ac:	692080e7          	jalr	1682(ra) # 8020283a <_Z12syscall_initv>
    plic.init();     // 初始化plic
    802001b0:	00022517          	auipc	a0,0x22
    802001b4:	79850513          	addi	a0,a0,1944 # 80222948 <plic>
    802001b8:	00001097          	auipc	ra,0x1
    802001bc:	3fe080e7          	jalr	1022(ra) # 802015b6 <_ZN4Plic4initEv>
    plic.initHart();
    802001c0:	00022517          	auipc	a0,0x22
    802001c4:	78850513          	addi	a0,a0,1928 # 80222948 <plic>
    802001c8:	00001097          	auipc	ra,0x1
    802001cc:	406080e7          	jalr	1030(ra) # 802015ce <_ZN4Plic8initHartEv>
    disk_init();
    802001d0:	00006097          	auipc	ra,0x6
    802001d4:	b30080e7          	jalr	-1232(ra) # 80205d00 <_Z9disk_initv>
    bufferLayer.init();
    802001d8:	00014517          	auipc	a0,0x14
    802001dc:	f1050513          	addi	a0,a0,-240 # 802140e8 <bufferLayer>
    802001e0:	00003097          	auipc	ra,0x3
    802001e4:	314080e7          	jalr	788(ra) # 802034f4 <_ZN11BufferLayer4initEv>
    initTaskTable();
    802001e8:	00001097          	auipc	ra,0x1
    802001ec:	5da080e7          	jalr	1498(ra) # 802017c2 <_Z13initTaskTablev>
    initFirstTask();
    802001f0:	00001097          	auipc	ra,0x1
    802001f4:	79c080e7          	jalr	1948(ra) # 8020198c <_Z13initFirstTaskv>
      unsigned long mask = 1 << i;
    802001f8:	4789                	li	a5,2
    802001fa:	fef43423          	sd	a5,-24(s0)
	SBI_CALL_0(SBI_CLEAR_IPI);
}

static inline void sbi_send_ipi(const unsigned long *hart_mask)
{
	SBI_CALL_1(SBI_SEND_IPI, hart_mask);
    802001fe:	fe840513          	addi	a0,s0,-24
    80200202:	4581                	li	a1,0
    80200204:	4601                	li	a2,0
    80200206:	4681                	li	a3,0
    80200208:	4891                	li	a7,4
    8020020a:	00000073          	ecall
    __sync_synchronize();
    8020020e:	0ff0000f          	fence
    started = 1;
    80200212:	4785                	li	a5,1
    80200214:	00022717          	auipc	a4,0x22
    80200218:	72f72623          	sw	a5,1836(a4) # 80222940 <_ZL7started>
// this core's hartid (core number), the index into cpus[].
static inline uint64_t
r_tp()
{
  uint64_t x;
  asm volatile("mv %0, tp" : "=r" (x) );
    8020021c:	8592                	mv	a1,tp
  }
  printf("hart %d finish init\n", r_tp());
    8020021e:	0000a517          	auipc	a0,0xa
    80200222:	f7a50513          	addi	a0,a0,-134 # 8020a198 <rodata_start+0x198>
    80200226:	00000097          	auipc	ra,0x0
    8020022a:	62e080e7          	jalr	1582(ra) # 80200854 <_Z6printfPKcz>
  
  scheduler();
    8020022e:	00002097          	auipc	ra,0x2
    80200232:	b2c080e7          	jalr	-1236(ra) # 80201d5a <_Z9schedulerv>
}
    80200236:	60e2                	ld	ra,24(sp)
    80200238:	6442                	ld	s0,16(sp)
    8020023a:	6105                	addi	sp,sp,32
    8020023c:	8082                	ret

000000008020023e <_GLOBAL__sub_I_console>:
    8020023e:	1101                	addi	sp,sp,-32
    80200240:	ec06                	sd	ra,24(sp)
    80200242:	e822                	sd	s0,16(sp)
    80200244:	e426                	sd	s1,8(sp)
    80200246:	e04a                	sd	s2,0(sp)
    80200248:	1000                	addi	s0,sp,32
Console console;
    8020024a:	00014517          	auipc	a0,0x14
    8020024e:	db650513          	addi	a0,a0,-586 # 80214000 <console>
    80200252:	00007097          	auipc	ra,0x7
    80200256:	814080e7          	jalr	-2028(ra) # 80206a66 <_ZN7ConsoleC1Ev>
Timer timer(1000000);
    8020025a:	000f45b7          	lui	a1,0xf4
    8020025e:	24058593          	addi	a1,a1,576 # f4240 <_entry-0x8010bdc0>
    80200262:	00014517          	auipc	a0,0x14
    80200266:	e5e50513          	addi	a0,a0,-418 # 802140c0 <timer>
    8020026a:	00001097          	auipc	ra,0x1
    8020026e:	494080e7          	jalr	1172(ra) # 802016fe <_ZN5TimerC1Ej>

struct Node {
  struct Node *next;
};

class MemAllocator {
    80200272:	00014517          	auipc	a0,0x14
    80200276:	e2e50513          	addi	a0,a0,-466 # 802140a0 <memAllocator>
    8020027a:	00001097          	auipc	ra,0x1
    8020027e:	b4a080e7          	jalr	-1206(ra) # 80200dc4 <_ZN8SpinLockC1Ev>
  SleepLock sleeplock;
  uint_t refcnt;
  uchar_t data[BSIZE];
};

class BufferLayer {
    80200282:	00014497          	auipc	s1,0x14
    80200286:	e8648493          	addi	s1,s1,-378 # 80214108 <bufferLayer+0x20>
    8020028a:	00022917          	auipc	s2,0x22
    8020028e:	5be90913          	addi	s2,s2,1470 # 80222848 <cpus+0x8>
#define SLEEP_LOCK_HPP
#include "os/SpinLock.hpp"
#include "types.hpp"
#include "StartOS.hpp"

class SleepLock {
    80200292:	8526                	mv	a0,s1
    80200294:	00001097          	auipc	ra,0x1
    80200298:	b30080e7          	jalr	-1232(ra) # 80200dc4 <_ZN8SpinLockC1Ev>
    8020029c:	25048493          	addi	s1,s1,592
    802002a0:	ff2499e3          	bne	s1,s2,80200292 <_GLOBAL__sub_I_console+0x54>
    802002a4:	00022517          	auipc	a0,0x22
    802002a8:	58450513          	addi	a0,a0,1412 # 80222828 <bufferLayer+0xe740>
    802002ac:	00001097          	auipc	ra,0x1
    802002b0:	b18080e7          	jalr	-1256(ra) # 80200dc4 <_ZN8SpinLockC1Ev>
}
    802002b4:	60e2                	ld	ra,24(sp)
    802002b6:	6442                	ld	s0,16(sp)
    802002b8:	64a2                	ld	s1,8(sp)
    802002ba:	6902                	ld	s2,0(sp)
    802002bc:	6105                	addi	sp,sp,32
    802002be:	8082                	ret

00000000802002c0 <_Znwm>:
#include "memory/MemAllocator.hpp"
#include "common/logger.h"

extern MemAllocator memAllocator;

void* operator new(uint64_t size){
    802002c0:	1101                	addi	sp,sp,-32
    802002c2:	ec06                	sd	ra,24(sp)
    802002c4:	e822                	sd	s0,16(sp)
    802002c6:	1000                	addi	s0,sp,32
    802002c8:	fea43423          	sd	a0,-24(s0)
    return memAllocator.alloc();
    802002cc:	00014517          	auipc	a0,0x14
    802002d0:	dd450513          	addi	a0,a0,-556 # 802140a0 <memAllocator>
    802002d4:	00007097          	auipc	ra,0x7
    802002d8:	266080e7          	jalr	614(ra) # 8020753a <_ZN12MemAllocator5allocEv>
    802002dc:	87aa                	mv	a5,a0
}
    802002de:	853e                	mv	a0,a5
    802002e0:	60e2                	ld	ra,24(sp)
    802002e2:	6442                	ld	s0,16(sp)
    802002e4:	6105                	addi	sp,sp,32
    802002e6:	8082                	ret

00000000802002e8 <_ZdlPv>:

void operator delete(void* p){
    802002e8:	7179                	addi	sp,sp,-48
    802002ea:	f406                	sd	ra,40(sp)
    802002ec:	f022                	sd	s0,32(sp)
    802002ee:	1800                	addi	s0,sp,48
    802002f0:	fca43c23          	sd	a0,-40(s0)
    LOG_ERROR("not support delete");
    802002f4:	0000a797          	auipc	a5,0xa
    802002f8:	f0478793          	addi	a5,a5,-252 # 8020a1f8 <rodata_start+0x1f8>
    802002fc:	fef43423          	sd	a5,-24(s0)
    80200300:	0000a797          	auipc	a5,0xa
    80200304:	ef878793          	addi	a5,a5,-264 # 8020a1f8 <rodata_start+0x1f8>
    80200308:	1f400693          	li	a3,500
    8020030c:	0000a617          	auipc	a2,0xa
    80200310:	efc60613          	addi	a2,a2,-260 # 8020a208 <rodata_start+0x208>
    80200314:	45cd                	li	a1,19
    80200316:	853e                	mv	a0,a5
    80200318:	00000097          	auipc	ra,0x0
    8020031c:	2be080e7          	jalr	702(ra) # 802005d6 <_Z15OutputLogHeaderPKciS0_i>
    80200320:	0000a517          	auipc	a0,0xa
    80200324:	ef850513          	addi	a0,a0,-264 # 8020a218 <rodata_start+0x218>
    80200328:	00000097          	auipc	ra,0x0
    8020032c:	52c080e7          	jalr	1324(ra) # 80200854 <_Z6printfPKcz>
    80200330:	0000a517          	auipc	a0,0xa
    80200334:	f0050513          	addi	a0,a0,-256 # 8020a230 <rodata_start+0x230>
    80200338:	00000097          	auipc	ra,0x0
    8020033c:	51c080e7          	jalr	1308(ra) # 80200854 <_Z6printfPKcz>
}
    80200340:	0001                	nop
    80200342:	70a2                	ld	ra,40(sp)
    80200344:	7402                	ld	s0,32(sp)
    80200346:	6145                	addi	sp,sp,48
    80200348:	8082                	ret

000000008020034a <_Znam>:

void* operator new[](uint64_t size){
    8020034a:	7179                	addi	sp,sp,-48
    8020034c:	f406                	sd	ra,40(sp)
    8020034e:	f022                	sd	s0,32(sp)
    80200350:	1800                	addi	s0,sp,48
    80200352:	fca43c23          	sd	a0,-40(s0)
    LOG_ERROR("not support new[]");
    80200356:	0000a797          	auipc	a5,0xa
    8020035a:	ea278793          	addi	a5,a5,-350 # 8020a1f8 <rodata_start+0x1f8>
    8020035e:	fef43423          	sd	a5,-24(s0)
    80200362:	0000a797          	auipc	a5,0xa
    80200366:	e9678793          	addi	a5,a5,-362 # 8020a1f8 <rodata_start+0x1f8>
    8020036a:	1f400693          	li	a3,500
    8020036e:	0000a617          	auipc	a2,0xa
    80200372:	eca60613          	addi	a2,a2,-310 # 8020a238 <rodata_start+0x238>
    80200376:	45dd                	li	a1,23
    80200378:	853e                	mv	a0,a5
    8020037a:	00000097          	auipc	ra,0x0
    8020037e:	25c080e7          	jalr	604(ra) # 802005d6 <_Z15OutputLogHeaderPKciS0_i>
    80200382:	0000a517          	auipc	a0,0xa
    80200386:	ec650513          	addi	a0,a0,-314 # 8020a248 <rodata_start+0x248>
    8020038a:	00000097          	auipc	ra,0x0
    8020038e:	4ca080e7          	jalr	1226(ra) # 80200854 <_Z6printfPKcz>
    80200392:	0000a517          	auipc	a0,0xa
    80200396:	e9e50513          	addi	a0,a0,-354 # 8020a230 <rodata_start+0x230>
    8020039a:	00000097          	auipc	ra,0x0
    8020039e:	4ba080e7          	jalr	1210(ra) # 80200854 <_Z6printfPKcz>

    return NULL;
    802003a2:	4781                	li	a5,0
}
    802003a4:	853e                	mv	a0,a5
    802003a6:	70a2                	ld	ra,40(sp)
    802003a8:	7402                	ld	s0,32(sp)
    802003aa:	6145                	addi	sp,sp,48
    802003ac:	8082                	ret

00000000802003ae <_ZdaPv>:

void operator delete[](void* p){
    802003ae:	7179                	addi	sp,sp,-48
    802003b0:	f406                	sd	ra,40(sp)
    802003b2:	f022                	sd	s0,32(sp)
    802003b4:	1800                	addi	s0,sp,48
    802003b6:	fca43c23          	sd	a0,-40(s0)
    LOG_ERROR("not support delete[]");
    802003ba:	0000a797          	auipc	a5,0xa
    802003be:	e3e78793          	addi	a5,a5,-450 # 8020a1f8 <rodata_start+0x1f8>
    802003c2:	fef43423          	sd	a5,-24(s0)
    802003c6:	0000a797          	auipc	a5,0xa
    802003ca:	e3278793          	addi	a5,a5,-462 # 8020a1f8 <rodata_start+0x1f8>
    802003ce:	1f400693          	li	a3,500
    802003d2:	0000a617          	auipc	a2,0xa
    802003d6:	e8e60613          	addi	a2,a2,-370 # 8020a260 <rodata_start+0x260>
    802003da:	45f5                	li	a1,29
    802003dc:	853e                	mv	a0,a5
    802003de:	00000097          	auipc	ra,0x0
    802003e2:	1f8080e7          	jalr	504(ra) # 802005d6 <_Z15OutputLogHeaderPKciS0_i>
    802003e6:	0000a517          	auipc	a0,0xa
    802003ea:	e9250513          	addi	a0,a0,-366 # 8020a278 <rodata_start+0x278>
    802003ee:	00000097          	auipc	ra,0x0
    802003f2:	466080e7          	jalr	1126(ra) # 80200854 <_Z6printfPKcz>
    802003f6:	0000a517          	auipc	a0,0xa
    802003fa:	e3a50513          	addi	a0,a0,-454 # 8020a230 <rodata_start+0x230>
    802003fe:	00000097          	auipc	ra,0x0
    80200402:	456080e7          	jalr	1110(ra) # 80200854 <_Z6printfPKcz>

}
    80200406:	0001                	nop
    80200408:	70a2                	ld	ra,40(sp)
    8020040a:	7402                	ld	s0,32(sp)
    8020040c:	6145                	addi	sp,sp,48
    8020040e:	8082                	ret

0000000080200410 <__cxa_atexit>:
extern "C" {

atexit_func_entry_t __atexit_funcs[ATEXIT_MAX_FUNCS];
uarch_t __atexit_func_count = 0;

int __cxa_atexit(void (*f)(void *), void *objptr, void *dso){
    80200410:	7179                	addi	sp,sp,-48
    80200412:	f422                	sd	s0,40(sp)
    80200414:	1800                	addi	s0,sp,48
    80200416:	fea43423          	sd	a0,-24(s0)
    8020041a:	feb43023          	sd	a1,-32(s0)
    8020041e:	fcc43c23          	sd	a2,-40(s0)
    if (__atexit_func_count >= ATEXIT_MAX_FUNCS) {
    80200422:	00023797          	auipc	a5,0x23
    80200426:	82e78793          	addi	a5,a5,-2002 # 80222c50 <__atexit_func_count>
    8020042a:	439c                	lw	a5,0(a5)
    8020042c:	873e                	mv	a4,a5
    8020042e:	47fd                	li	a5,31
    80200430:	00e7d463          	bge	a5,a4,80200438 <__cxa_atexit+0x28>
        return -1;
    80200434:	57fd                	li	a5,-1
    80200436:	a051                	j	802004ba <__cxa_atexit+0xaa>
    }

    __atexit_funcs[__atexit_func_count].destructor_func = f;
    80200438:	00023797          	auipc	a5,0x23
    8020043c:	81878793          	addi	a5,a5,-2024 # 80222c50 <__atexit_func_count>
    80200440:	4398                	lw	a4,0(a5)
    80200442:	00022697          	auipc	a3,0x22
    80200446:	50e68693          	addi	a3,a3,1294 # 80222950 <__atexit_funcs>
    8020044a:	87ba                	mv	a5,a4
    8020044c:	0786                	slli	a5,a5,0x1
    8020044e:	97ba                	add	a5,a5,a4
    80200450:	078e                	slli	a5,a5,0x3
    80200452:	97b6                	add	a5,a5,a3
    80200454:	fe843703          	ld	a4,-24(s0)
    80200458:	e398                	sd	a4,0(a5)
    __atexit_funcs[__atexit_func_count].obj_ptr = objptr;
    8020045a:	00022797          	auipc	a5,0x22
    8020045e:	7f678793          	addi	a5,a5,2038 # 80222c50 <__atexit_func_count>
    80200462:	4398                	lw	a4,0(a5)
    80200464:	00022697          	auipc	a3,0x22
    80200468:	4ec68693          	addi	a3,a3,1260 # 80222950 <__atexit_funcs>
    8020046c:	87ba                	mv	a5,a4
    8020046e:	0786                	slli	a5,a5,0x1
    80200470:	97ba                	add	a5,a5,a4
    80200472:	078e                	slli	a5,a5,0x3
    80200474:	97b6                	add	a5,a5,a3
    80200476:	fe043703          	ld	a4,-32(s0)
    8020047a:	e798                	sd	a4,8(a5)
    __atexit_funcs[__atexit_func_count].dso_handle = dso;
    8020047c:	00022797          	auipc	a5,0x22
    80200480:	7d478793          	addi	a5,a5,2004 # 80222c50 <__atexit_func_count>
    80200484:	4398                	lw	a4,0(a5)
    80200486:	00022697          	auipc	a3,0x22
    8020048a:	4ca68693          	addi	a3,a3,1226 # 80222950 <__atexit_funcs>
    8020048e:	87ba                	mv	a5,a4
    80200490:	0786                	slli	a5,a5,0x1
    80200492:	97ba                	add	a5,a5,a4
    80200494:	078e                	slli	a5,a5,0x3
    80200496:	97b6                	add	a5,a5,a3
    80200498:	fd843703          	ld	a4,-40(s0)
    8020049c:	eb98                	sd	a4,16(a5)
    __atexit_func_count++;
    8020049e:	00022797          	auipc	a5,0x22
    802004a2:	7b278793          	addi	a5,a5,1970 # 80222c50 <__atexit_func_count>
    802004a6:	439c                	lw	a5,0(a5)
    802004a8:	2785                	addiw	a5,a5,1
    802004aa:	0007871b          	sext.w	a4,a5
    802004ae:	00022797          	auipc	a5,0x22
    802004b2:	7a278793          	addi	a5,a5,1954 # 80222c50 <__atexit_func_count>
    802004b6:	c398                	sw	a4,0(a5)

    return 0; /*I would prefer if functions returned 1 on success, but the ABI says...*/
    802004b8:	4781                	li	a5,0
}
    802004ba:	853e                	mv	a0,a5
    802004bc:	7422                	ld	s0,40(sp)
    802004be:	6145                	addi	sp,sp,48
    802004c0:	8082                	ret

00000000802004c2 <__cxa_finalize>:

void __cxa_finalize(void *f){
    802004c2:	7179                	addi	sp,sp,-48
    802004c4:	f406                	sd	ra,40(sp)
    802004c6:	f022                	sd	s0,32(sp)
    802004c8:	1800                	addi	s0,sp,48
    802004ca:	fca43c23          	sd	a0,-40(s0)
    uarch_t i = __atexit_func_count;
    802004ce:	00022797          	auipc	a5,0x22
    802004d2:	78278793          	addi	a5,a5,1922 # 80222c50 <__atexit_func_count>
    802004d6:	439c                	lw	a5,0(a5)
    802004d8:	fef42623          	sw	a5,-20(s0)
    if (!f){
    802004dc:	fd843783          	ld	a5,-40(s0)
    802004e0:	e7a5                	bnez	a5,80200548 <__cxa_finalize+0x86>
        while (i--){
    802004e2:	fec42783          	lw	a5,-20(s0)
    802004e6:	fff7871b          	addiw	a4,a5,-1
    802004ea:	fee42623          	sw	a4,-20(s0)
    802004ee:	00f037b3          	snez	a5,a5
    802004f2:	0ff7f793          	andi	a5,a5,255
    802004f6:	cbf9                	beqz	a5,802005cc <__cxa_finalize+0x10a>
            if (__atexit_funcs[i].destructor_func){
    802004f8:	00022697          	auipc	a3,0x22
    802004fc:	45868693          	addi	a3,a3,1112 # 80222950 <__atexit_funcs>
    80200500:	fec42703          	lw	a4,-20(s0)
    80200504:	87ba                	mv	a5,a4
    80200506:	0786                	slli	a5,a5,0x1
    80200508:	97ba                	add	a5,a5,a4
    8020050a:	078e                	slli	a5,a5,0x3
    8020050c:	97b6                	add	a5,a5,a3
    8020050e:	639c                	ld	a5,0(a5)
    80200510:	dbe9                	beqz	a5,802004e2 <__cxa_finalize+0x20>
                (*__atexit_funcs[i].destructor_func)(__atexit_funcs[i].obj_ptr);
    80200512:	00022697          	auipc	a3,0x22
    80200516:	43e68693          	addi	a3,a3,1086 # 80222950 <__atexit_funcs>
    8020051a:	fec42703          	lw	a4,-20(s0)
    8020051e:	87ba                	mv	a5,a4
    80200520:	0786                	slli	a5,a5,0x1
    80200522:	97ba                	add	a5,a5,a4
    80200524:	078e                	slli	a5,a5,0x3
    80200526:	97b6                	add	a5,a5,a3
    80200528:	6390                	ld	a2,0(a5)
    8020052a:	00022697          	auipc	a3,0x22
    8020052e:	42668693          	addi	a3,a3,1062 # 80222950 <__atexit_funcs>
    80200532:	fec42703          	lw	a4,-20(s0)
    80200536:	87ba                	mv	a5,a4
    80200538:	0786                	slli	a5,a5,0x1
    8020053a:	97ba                	add	a5,a5,a4
    8020053c:	078e                	slli	a5,a5,0x3
    8020053e:	97b6                	add	a5,a5,a3
    80200540:	679c                	ld	a5,8(a5)
    80200542:	853e                	mv	a0,a5
    80200544:	9602                	jalr	a2
        while (i--){
    80200546:	bf71                	j	802004e2 <__cxa_finalize+0x20>
            }
        }
        return;
    }

    for ( ; i >= 0; --i){
    80200548:	fec42783          	lw	a5,-20(s0)
    8020054c:	2781                	sext.w	a5,a5
    8020054e:	0807c063          	bltz	a5,802005ce <__cxa_finalize+0x10c>
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wpedantic"
        if (__atexit_funcs[i].destructor_func == f){
    80200552:	00022697          	auipc	a3,0x22
    80200556:	3fe68693          	addi	a3,a3,1022 # 80222950 <__atexit_funcs>
    8020055a:	fec42703          	lw	a4,-20(s0)
    8020055e:	87ba                	mv	a5,a4
    80200560:	0786                	slli	a5,a5,0x1
    80200562:	97ba                	add	a5,a5,a4
    80200564:	078e                	slli	a5,a5,0x3
    80200566:	97b6                	add	a5,a5,a3
    80200568:	639c                	ld	a5,0(a5)
    8020056a:	fd843703          	ld	a4,-40(s0)
    8020056e:	04f71963          	bne	a4,a5,802005c0 <__cxa_finalize+0xfe>
            (*__atexit_funcs[i].destructor_func)(__atexit_funcs[i].obj_ptr);
    80200572:	00022697          	auipc	a3,0x22
    80200576:	3de68693          	addi	a3,a3,990 # 80222950 <__atexit_funcs>
    8020057a:	fec42703          	lw	a4,-20(s0)
    8020057e:	87ba                	mv	a5,a4
    80200580:	0786                	slli	a5,a5,0x1
    80200582:	97ba                	add	a5,a5,a4
    80200584:	078e                	slli	a5,a5,0x3
    80200586:	97b6                	add	a5,a5,a3
    80200588:	6390                	ld	a2,0(a5)
    8020058a:	00022697          	auipc	a3,0x22
    8020058e:	3c668693          	addi	a3,a3,966 # 80222950 <__atexit_funcs>
    80200592:	fec42703          	lw	a4,-20(s0)
    80200596:	87ba                	mv	a5,a4
    80200598:	0786                	slli	a5,a5,0x1
    8020059a:	97ba                	add	a5,a5,a4
    8020059c:	078e                	slli	a5,a5,0x3
    8020059e:	97b6                	add	a5,a5,a3
    802005a0:	679c                	ld	a5,8(a5)
    802005a2:	853e                	mv	a0,a5
    802005a4:	9602                	jalr	a2
            __atexit_funcs[i].destructor_func = 0;
    802005a6:	00022697          	auipc	a3,0x22
    802005aa:	3aa68693          	addi	a3,a3,938 # 80222950 <__atexit_funcs>
    802005ae:	fec42703          	lw	a4,-20(s0)
    802005b2:	87ba                	mv	a5,a4
    802005b4:	0786                	slli	a5,a5,0x1
    802005b6:	97ba                	add	a5,a5,a4
    802005b8:	078e                	slli	a5,a5,0x3
    802005ba:	97b6                	add	a5,a5,a3
    802005bc:	0007b023          	sd	zero,0(a5)
    for ( ; i >= 0; --i){
    802005c0:	fec42783          	lw	a5,-20(s0)
    802005c4:	37fd                	addiw	a5,a5,-1
    802005c6:	fef42623          	sw	a5,-20(s0)
    802005ca:	bfbd                	j	80200548 <__cxa_finalize+0x86>
        return;
    802005cc:	0001                	nop
        }
#pragma GCC diagnostic pop
    }
}
    802005ce:	70a2                	ld	ra,40(sp)
    802005d0:	7402                	ld	s0,32(sp)
    802005d2:	6145                	addi	sp,sp,48
    802005d4:	8082                	ret

00000000802005d6 <_Z15OutputLogHeaderPKciS0_i>:

    802005d6:	7139                	addi	sp,sp,-64
    802005d8:	fc06                	sd	ra,56(sp)
    802005da:	f822                	sd	s0,48(sp)
    802005dc:	0080                	addi	s0,sp,64
    802005de:	fca43c23          	sd	a0,-40(s0)
    802005e2:	87ae                	mv	a5,a1
    802005e4:	fcc43423          	sd	a2,-56(s0)
    802005e8:	8736                	mv	a4,a3
    802005ea:	fcf42a23          	sw	a5,-44(s0)
    802005ee:	87ba                	mv	a5,a4
    802005f0:	fcf42823          	sw	a5,-48(s0)
  const char *type;
    802005f4:	fd042783          	lw	a5,-48(s0)
    802005f8:	0007871b          	sext.w	a4,a5
    802005fc:	1f400793          	li	a5,500
    80200600:	06f70b63          	beq	a4,a5,80200676 <_Z15OutputLogHeaderPKciS0_i+0xa0>
    80200604:	fd042783          	lw	a5,-48(s0)
    80200608:	0007871b          	sext.w	a4,a5
    8020060c:	1f400793          	li	a5,500
    80200610:	0ae7c663          	blt	a5,a4,802006bc <_Z15OutputLogHeaderPKciS0_i+0xe6>
    80200614:	fd042783          	lw	a5,-48(s0)
    80200618:	0007871b          	sext.w	a4,a5
    8020061c:	19000793          	li	a5,400
    80200620:	06f70263          	beq	a4,a5,80200684 <_Z15OutputLogHeaderPKciS0_i+0xae>
    80200624:	fd042783          	lw	a5,-48(s0)
    80200628:	0007871b          	sext.w	a4,a5
    8020062c:	19000793          	li	a5,400
    80200630:	08e7c663          	blt	a5,a4,802006bc <_Z15OutputLogHeaderPKciS0_i+0xe6>
    80200634:	fd042783          	lw	a5,-48(s0)
    80200638:	0007871b          	sext.w	a4,a5
    8020063c:	12c00793          	li	a5,300
    80200640:	04f70963          	beq	a4,a5,80200692 <_Z15OutputLogHeaderPKciS0_i+0xbc>
    80200644:	fd042783          	lw	a5,-48(s0)
    80200648:	0007871b          	sext.w	a4,a5
    8020064c:	12c00793          	li	a5,300
    80200650:	06e7c663          	blt	a5,a4,802006bc <_Z15OutputLogHeaderPKciS0_i+0xe6>
    80200654:	fd042783          	lw	a5,-48(s0)
    80200658:	0007871b          	sext.w	a4,a5
    8020065c:	06400793          	li	a5,100
    80200660:	04f70763          	beq	a4,a5,802006ae <_Z15OutputLogHeaderPKciS0_i+0xd8>
    80200664:	fd042783          	lw	a5,-48(s0)
    80200668:	0007871b          	sext.w	a4,a5
    8020066c:	0c800793          	li	a5,200
    80200670:	02f70863          	beq	a4,a5,802006a0 <_Z15OutputLogHeaderPKciS0_i+0xca>
    80200674:	a0a1                	j	802006bc <_Z15OutputLogHeaderPKciS0_i+0xe6>
    case LOG_LEVEL_ERROR:
    80200676:	0000a797          	auipc	a5,0xa
    8020067a:	b3a78793          	addi	a5,a5,-1222 # 8020a1b0 <rodata_start+0x1b0>
    8020067e:	fef43423          	sd	a5,-24(s0)
      type = "ERROR";
    80200682:	a099                	j	802006c8 <_Z15OutputLogHeaderPKciS0_i+0xf2>
    case LOG_LEVEL_WARN:
    80200684:	0000a797          	auipc	a5,0xa
    80200688:	b3478793          	addi	a5,a5,-1228 # 8020a1b8 <rodata_start+0x1b8>
    8020068c:	fef43423          	sd	a5,-24(s0)
      type = "WARN ";
    80200690:	a825                	j	802006c8 <_Z15OutputLogHeaderPKciS0_i+0xf2>
    case LOG_LEVEL_INFO:
    80200692:	0000a797          	auipc	a5,0xa
    80200696:	b2e78793          	addi	a5,a5,-1234 # 8020a1c0 <rodata_start+0x1c0>
    8020069a:	fef43423          	sd	a5,-24(s0)
      type = "INFO ";
    8020069e:	a02d                	j	802006c8 <_Z15OutputLogHeaderPKciS0_i+0xf2>
    case LOG_LEVEL_DEBUG:
    802006a0:	0000a797          	auipc	a5,0xa
    802006a4:	b2878793          	addi	a5,a5,-1240 # 8020a1c8 <rodata_start+0x1c8>
    802006a8:	fef43423          	sd	a5,-24(s0)
      type = "DEBUG";
    802006ac:	a831                	j	802006c8 <_Z15OutputLogHeaderPKciS0_i+0xf2>
    case LOG_LEVEL_TRACE:
    802006ae:	0000a797          	auipc	a5,0xa
    802006b2:	b2278793          	addi	a5,a5,-1246 # 8020a1d0 <rodata_start+0x1d0>
    802006b6:	fef43423          	sd	a5,-24(s0)
      type = "TRACE";
    802006ba:	a039                	j	802006c8 <_Z15OutputLogHeaderPKciS0_i+0xf2>
    default:
    802006bc:	0000a797          	auipc	a5,0xa
    802006c0:	b1c78793          	addi	a5,a5,-1252 # 8020a1d8 <rodata_start+0x1d8>
    802006c4:	fef43423          	sd	a5,-24(s0)
  }
    802006c8:	fd442783          	lw	a5,-44(s0)
    802006cc:	fc843703          	ld	a4,-56(s0)
    802006d0:	86be                	mv	a3,a5
    802006d2:	fd843603          	ld	a2,-40(s0)
    802006d6:	fe843583          	ld	a1,-24(s0)
    802006da:	0000a517          	auipc	a0,0xa
    802006de:	b0650513          	addi	a0,a0,-1274 # 8020a1e0 <rodata_start+0x1e0>
    802006e2:	00000097          	auipc	ra,0x0
    802006e6:	172080e7          	jalr	370(ra) # 80200854 <_Z6printfPKcz>
  printf("%s [%s:%d:%s] - ", type, file, line, func);
    802006ea:	0001                	nop
    802006ec:	70e2                	ld	ra,56(sp)
    802006ee:	7442                	ld	s0,48(sp)
    802006f0:	6121                	addi	sp,sp,64
    802006f2:	8082                	ret

00000000802006f4 <_ZL8printintiii>:
  bool locking;
} pr;

static char digits[] = "0123456789abcdef";

static void printint(int xx, int base, int sign) {
    802006f4:	7139                	addi	sp,sp,-64
    802006f6:	fc06                	sd	ra,56(sp)
    802006f8:	f822                	sd	s0,48(sp)
    802006fa:	f426                	sd	s1,40(sp)
    802006fc:	f04a                	sd	s2,32(sp)
    802006fe:	ec4e                	sd	s3,24(sp)
    80200700:	0080                	addi	s0,sp,64
  char buf[16];
  int i;
  uint_t x;

  if (sign && (sign = xx < 0))
    80200702:	c219                	beqz	a2,80200708 <_ZL8printintiii+0x14>
    80200704:	08054c63          	bltz	a0,8020079c <_ZL8printintiii+0xa8>
    x = -xx;
  else
    x = xx;
    80200708:	2501                	sext.w	a0,a0
    8020070a:	4881                	li	a7,0
    8020070c:	fc040693          	addi	a3,s0,-64

  i = 0;
    80200710:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80200712:	2581                	sext.w	a1,a1
    80200714:	0000a617          	auipc	a2,0xa
    80200718:	bf460613          	addi	a2,a2,-1036 # 8020a308 <_ZL6digits>
    8020071c:	883a                	mv	a6,a4
    8020071e:	2705                	addiw	a4,a4,1
    80200720:	02b577bb          	remuw	a5,a0,a1
    80200724:	1782                	slli	a5,a5,0x20
    80200726:	9381                	srli	a5,a5,0x20
    80200728:	97b2                	add	a5,a5,a2
    8020072a:	0007c783          	lbu	a5,0(a5)
    8020072e:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    80200732:	0005079b          	sext.w	a5,a0
    80200736:	02b5553b          	divuw	a0,a0,a1
    8020073a:	0685                	addi	a3,a3,1
    8020073c:	feb7f0e3          	bgeu	a5,a1,8020071c <_ZL8printintiii+0x28>

  if (sign) buf[i++] = '-';
    80200740:	00088b63          	beqz	a7,80200756 <_ZL8printintiii+0x62>
    80200744:	fd040793          	addi	a5,s0,-48
    80200748:	973e                	add	a4,a4,a5
    8020074a:	02d00793          	li	a5,45
    8020074e:	fef70823          	sb	a5,-16(a4)
    80200752:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) console.putc(buf[i]);
    80200756:	02e05c63          	blez	a4,8020078e <_ZL8printintiii+0x9a>
    8020075a:	fc040793          	addi	a5,s0,-64
    8020075e:	00e784b3          	add	s1,a5,a4
    80200762:	fff78913          	addi	s2,a5,-1
    80200766:	993a                	add	s2,s2,a4
    80200768:	377d                	addiw	a4,a4,-1
    8020076a:	1702                	slli	a4,a4,0x20
    8020076c:	9301                	srli	a4,a4,0x20
    8020076e:	40e90933          	sub	s2,s2,a4
    80200772:	00014997          	auipc	s3,0x14
    80200776:	88e98993          	addi	s3,s3,-1906 # 80214000 <console>
    8020077a:	fff4c583          	lbu	a1,-1(s1)
    8020077e:	854e                	mv	a0,s3
    80200780:	00006097          	auipc	ra,0x6
    80200784:	302080e7          	jalr	770(ra) # 80206a82 <_ZN7Console4putcEi>
    80200788:	14fd                	addi	s1,s1,-1
    8020078a:	ff2498e3          	bne	s1,s2,8020077a <_ZL8printintiii+0x86>
}
    8020078e:	70e2                	ld	ra,56(sp)
    80200790:	7442                	ld	s0,48(sp)
    80200792:	74a2                	ld	s1,40(sp)
    80200794:	7902                	ld	s2,32(sp)
    80200796:	69e2                	ld	s3,24(sp)
    80200798:	6121                	addi	sp,sp,64
    8020079a:	8082                	ret
    x = -xx;
    8020079c:	40a0053b          	negw	a0,a0
  if (sign && (sign = xx < 0))
    802007a0:	4885                	li	a7,1
    802007a2:	b7ad                	j	8020070c <_ZL8printintiii+0x18>

00000000802007a4 <_Z8printstrPKc>:
  console.putc('x');
  for (i = 0; i < (sizeof(uint64_t) * 2); i++, x <<= 4) console.putc(digits[x >> (sizeof(uint64_t) * 8 - 4)]);
}

void printstr(const char *s) {
  for (int i = 0; s[i] != 0; i++) {
    802007a4:	00054583          	lbu	a1,0(a0)
    802007a8:	cd85                	beqz	a1,802007e0 <_Z8printstrPKc+0x3c>
void printstr(const char *s) {
    802007aa:	1101                	addi	sp,sp,-32
    802007ac:	ec06                	sd	ra,24(sp)
    802007ae:	e822                	sd	s0,16(sp)
    802007b0:	e426                	sd	s1,8(sp)
    802007b2:	e04a                	sd	s2,0(sp)
    802007b4:	1000                	addi	s0,sp,32
    802007b6:	00150493          	addi	s1,a0,1
    console.putc(s[i]);
    802007ba:	00014917          	auipc	s2,0x14
    802007be:	84690913          	addi	s2,s2,-1978 # 80214000 <console>
    802007c2:	854a                	mv	a0,s2
    802007c4:	00006097          	auipc	ra,0x6
    802007c8:	2be080e7          	jalr	702(ra) # 80206a82 <_ZN7Console4putcEi>
  for (int i = 0; s[i] != 0; i++) {
    802007cc:	0485                	addi	s1,s1,1
    802007ce:	fff4c583          	lbu	a1,-1(s1)
    802007d2:	f9e5                	bnez	a1,802007c2 <_Z8printstrPKc+0x1e>
  }
}
    802007d4:	60e2                	ld	ra,24(sp)
    802007d6:	6442                	ld	s0,16(sp)
    802007d8:	64a2                	ld	s1,8(sp)
    802007da:	6902                	ld	s2,0(sp)
    802007dc:	6105                	addi	sp,sp,32
    802007de:	8082                	ret
    802007e0:	8082                	ret

00000000802007e2 <_Z5panicPKc>:
  contextdump(&cpu->context);
  // if (cpu->task != reinterpret_cast<Task *>( -1)) trapframedump(cpu->task->trapframe);
}

extern int inkerneltrap;
void panic(const char *s) {
    802007e2:	1101                	addi	sp,sp,-32
    802007e4:	ec06                	sd	ra,24(sp)
    802007e6:	e822                	sd	s0,16(sp)
    802007e8:	e426                	sd	s1,8(sp)
    802007ea:	e04a                	sd	s2,0(sp)
    802007ec:	1000                	addi	s0,sp,32
    802007ee:	84aa                	mv	s1,a0
  pr.locking = false;
    802007f0:	00022797          	auipc	a5,0x22
    802007f4:	48078023          	sb	zero,1152(a5) # 80222c70 <_ZL2pr+0x18>
  // backtrace();
  printf("error cpuid=%d task=%p\n", Cpu::cpuid(), Cpu::mycpu()->task);
    802007f8:	00000097          	auipc	ra,0x0
    802007fc:	760080e7          	jalr	1888(ra) # 80200f58 <_ZN3Cpu5cpuidEv>
    80200800:	892a                	mv	s2,a0
    80200802:	00000097          	auipc	ra,0x0
    80200806:	766080e7          	jalr	1894(ra) # 80200f68 <_ZN3Cpu5mycpuEv>
    8020080a:	6110                	ld	a2,0(a0)
    8020080c:	85ca                	mv	a1,s2
    8020080e:	0000a517          	auipc	a0,0xa
    80200812:	a8250513          	addi	a0,a0,-1406 # 8020a290 <rodata_start+0x290>
    80200816:	00000097          	auipc	ra,0x0
    8020081a:	03e080e7          	jalr	62(ra) # 80200854 <_Z6printfPKcz>
  // cpudump(0);
  // cpudump(1);
  printf("panic: ");
    8020081e:	0000a517          	auipc	a0,0xa
    80200822:	a8a50513          	addi	a0,a0,-1398 # 8020a2a8 <rodata_start+0x2a8>
    80200826:	00000097          	auipc	ra,0x0
    8020082a:	02e080e7          	jalr	46(ra) # 80200854 <_Z6printfPKcz>
  printf(s);
    8020082e:	8526                	mv	a0,s1
    80200830:	00000097          	auipc	ra,0x0
    80200834:	024080e7          	jalr	36(ra) # 80200854 <_Z6printfPKcz>
  printf("\n");
    80200838:	0000a517          	auipc	a0,0xa
    8020083c:	86850513          	addi	a0,a0,-1944 # 8020a0a0 <rodata_start+0xa0>
    80200840:	00000097          	auipc	ra,0x0
    80200844:	014080e7          	jalr	20(ra) # 80200854 <_Z6printfPKcz>
  panicked = 1;  // freeze uart output from other CPUs
    80200848:	4785                	li	a5,1
    8020084a:	00022717          	auipc	a4,0x22
    8020084e:	42f72723          	sw	a5,1070(a4) # 80222c78 <panicked>
  for (;;)
    80200852:	a001                	j	80200852 <_Z5panicPKc+0x70>

0000000080200854 <_Z6printfPKcz>:
void printf(const char *fmt, ...) {
    80200854:	7131                	addi	sp,sp,-192
    80200856:	fc86                	sd	ra,120(sp)
    80200858:	f8a2                	sd	s0,112(sp)
    8020085a:	f4a6                	sd	s1,104(sp)
    8020085c:	f0ca                	sd	s2,96(sp)
    8020085e:	ecce                	sd	s3,88(sp)
    80200860:	e8d2                	sd	s4,80(sp)
    80200862:	e4d6                	sd	s5,72(sp)
    80200864:	e0da                	sd	s6,64(sp)
    80200866:	fc5e                	sd	s7,56(sp)
    80200868:	f862                	sd	s8,48(sp)
    8020086a:	f466                	sd	s9,40(sp)
    8020086c:	f06a                	sd	s10,32(sp)
    8020086e:	ec6e                	sd	s11,24(sp)
    80200870:	0100                	addi	s0,sp,128
    80200872:	8aaa                	mv	s5,a0
    80200874:	e40c                	sd	a1,8(s0)
    80200876:	e810                	sd	a2,16(s0)
    80200878:	ec14                	sd	a3,24(s0)
    8020087a:	f018                	sd	a4,32(s0)
    8020087c:	f41c                	sd	a5,40(s0)
    8020087e:	03043823          	sd	a6,48(s0)
    80200882:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80200886:	00022d97          	auipc	s11,0x22
    8020088a:	3eadcd83          	lbu	s11,1002(s11) # 80222c70 <_ZL2pr+0x18>
  if (locking) pr.lock.lock();
    8020088e:	020d9e63          	bnez	s11,802008ca <_Z6printfPKcz+0x76>
  if (fmt == 0) panic("null fmt");
    80200892:	040a8563          	beqz	s5,802008dc <_Z6printfPKcz+0x88>
  va_start(ap, fmt);
    80200896:	00840793          	addi	a5,s0,8
    8020089a:	f8f43423          	sd	a5,-120(s0)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    8020089e:	000ac583          	lbu	a1,0(s5)
    802008a2:	16058e63          	beqz	a1,80200a1e <_Z6printfPKcz+0x1ca>
    802008a6:	4481                	li	s1,0
    if (c != '%') {
    802008a8:	02500b13          	li	s6,37
    switch (c) {
    802008ac:	07000b93          	li	s7,112
  console.putc('0');
    802008b0:	00013a17          	auipc	s4,0x13
    802008b4:	750a0a13          	addi	s4,s4,1872 # 80214000 <console>
  for (i = 0; i < (sizeof(uint64_t) * 2); i++, x <<= 4) console.putc(digits[x >> (sizeof(uint64_t) * 8 - 4)]);
    802008b8:	0000ac17          	auipc	s8,0xa
    802008bc:	a50c0c13          	addi	s8,s8,-1456 # 8020a308 <_ZL6digits>
    switch (c) {
    802008c0:	07300d13          	li	s10,115
    802008c4:	06400c93          	li	s9,100
    802008c8:	a835                	j	80200904 <_Z6printfPKcz+0xb0>
  if (locking) pr.lock.lock();
    802008ca:	00022517          	auipc	a0,0x22
    802008ce:	38e50513          	addi	a0,a0,910 # 80222c58 <_ZL2pr>
    802008d2:	00000097          	auipc	ra,0x0
    802008d6:	57a080e7          	jalr	1402(ra) # 80200e4c <_ZN8SpinLock4lockEv>
    802008da:	bf65                	j	80200892 <_Z6printfPKcz+0x3e>
  if (fmt == 0) panic("null fmt");
    802008dc:	0000a517          	auipc	a0,0xa
    802008e0:	9dc50513          	addi	a0,a0,-1572 # 8020a2b8 <rodata_start+0x2b8>
    802008e4:	00000097          	auipc	ra,0x0
    802008e8:	efe080e7          	jalr	-258(ra) # 802007e2 <_Z5panicPKc>
      console.putc(c);
    802008ec:	8552                	mv	a0,s4
    802008ee:	00006097          	auipc	ra,0x6
    802008f2:	194080e7          	jalr	404(ra) # 80206a82 <_ZN7Console4putcEi>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    802008f6:	2485                	addiw	s1,s1,1
    802008f8:	009a87b3          	add	a5,s5,s1
    802008fc:	0007c583          	lbu	a1,0(a5)
    80200900:	10058f63          	beqz	a1,80200a1e <_Z6printfPKcz+0x1ca>
    if (c != '%') {
    80200904:	ff6594e3          	bne	a1,s6,802008ec <_Z6printfPKcz+0x98>
    c = fmt[++i] & 0xff;
    80200908:	2485                	addiw	s1,s1,1
    8020090a:	009a87b3          	add	a5,s5,s1
    8020090e:	0007c783          	lbu	a5,0(a5)
    80200912:	0007891b          	sext.w	s2,a5
    if (c == 0) break;
    80200916:	10078463          	beqz	a5,80200a1e <_Z6printfPKcz+0x1ca>
    switch (c) {
    8020091a:	05778a63          	beq	a5,s7,8020096e <_Z6printfPKcz+0x11a>
    8020091e:	02fbf663          	bgeu	s7,a5,8020094a <_Z6printfPKcz+0xf6>
    80200922:	09a78c63          	beq	a5,s10,802009ba <_Z6printfPKcz+0x166>
    80200926:	07800713          	li	a4,120
    8020092a:	0ce79d63          	bne	a5,a4,80200a04 <_Z6printfPKcz+0x1b0>
        printint(va_arg(ap, int), 16, 1);
    8020092e:	f8843783          	ld	a5,-120(s0)
    80200932:	00878713          	addi	a4,a5,8
    80200936:	f8e43423          	sd	a4,-120(s0)
    8020093a:	4605                	li	a2,1
    8020093c:	45c1                	li	a1,16
    8020093e:	4388                	lw	a0,0(a5)
    80200940:	00000097          	auipc	ra,0x0
    80200944:	db4080e7          	jalr	-588(ra) # 802006f4 <_ZL8printintiii>
        break;
    80200948:	b77d                	j	802008f6 <_Z6printfPKcz+0xa2>
    switch (c) {
    8020094a:	0b678663          	beq	a5,s6,802009f6 <_Z6printfPKcz+0x1a2>
    8020094e:	0b979b63          	bne	a5,s9,80200a04 <_Z6printfPKcz+0x1b0>
        printint(va_arg(ap, int), 10, 1);
    80200952:	f8843783          	ld	a5,-120(s0)
    80200956:	00878713          	addi	a4,a5,8
    8020095a:	f8e43423          	sd	a4,-120(s0)
    8020095e:	4605                	li	a2,1
    80200960:	45a9                	li	a1,10
    80200962:	4388                	lw	a0,0(a5)
    80200964:	00000097          	auipc	ra,0x0
    80200968:	d90080e7          	jalr	-624(ra) # 802006f4 <_ZL8printintiii>
        break;
    8020096c:	b769                	j	802008f6 <_Z6printfPKcz+0xa2>
        printptr(va_arg(ap, uint64_t));
    8020096e:	f8843783          	ld	a5,-120(s0)
    80200972:	00878713          	addi	a4,a5,8
    80200976:	f8e43423          	sd	a4,-120(s0)
    8020097a:	0007b983          	ld	s3,0(a5)
  console.putc('0');
    8020097e:	03000593          	li	a1,48
    80200982:	8552                	mv	a0,s4
    80200984:	00006097          	auipc	ra,0x6
    80200988:	0fe080e7          	jalr	254(ra) # 80206a82 <_ZN7Console4putcEi>
  console.putc('x');
    8020098c:	07800593          	li	a1,120
    80200990:	8552                	mv	a0,s4
    80200992:	00006097          	auipc	ra,0x6
    80200996:	0f0080e7          	jalr	240(ra) # 80206a82 <_ZN7Console4putcEi>
    8020099a:	4941                	li	s2,16
  for (i = 0; i < (sizeof(uint64_t) * 2); i++, x <<= 4) console.putc(digits[x >> (sizeof(uint64_t) * 8 - 4)]);
    8020099c:	03c9d793          	srli	a5,s3,0x3c
    802009a0:	97e2                	add	a5,a5,s8
    802009a2:	0007c583          	lbu	a1,0(a5)
    802009a6:	8552                	mv	a0,s4
    802009a8:	00006097          	auipc	ra,0x6
    802009ac:	0da080e7          	jalr	218(ra) # 80206a82 <_ZN7Console4putcEi>
    802009b0:	0992                	slli	s3,s3,0x4
    802009b2:	197d                	addi	s2,s2,-1
    802009b4:	fe0914e3          	bnez	s2,8020099c <_Z6printfPKcz+0x148>
    802009b8:	bf3d                	j	802008f6 <_Z6printfPKcz+0xa2>
        if ((s = va_arg(ap, char *)) == 0) s = "(null)";
    802009ba:	f8843783          	ld	a5,-120(s0)
    802009be:	00878713          	addi	a4,a5,8
    802009c2:	f8e43423          	sd	a4,-120(s0)
    802009c6:	0007b903          	ld	s2,0(a5)
    802009ca:	00090f63          	beqz	s2,802009e8 <_Z6printfPKcz+0x194>
        for (; *s; s++) console.putc(*s);
    802009ce:	00094583          	lbu	a1,0(s2)
    802009d2:	d195                	beqz	a1,802008f6 <_Z6printfPKcz+0xa2>
    802009d4:	8552                	mv	a0,s4
    802009d6:	00006097          	auipc	ra,0x6
    802009da:	0ac080e7          	jalr	172(ra) # 80206a82 <_ZN7Console4putcEi>
    802009de:	0905                	addi	s2,s2,1
    802009e0:	00094583          	lbu	a1,0(s2)
    802009e4:	f9e5                	bnez	a1,802009d4 <_Z6printfPKcz+0x180>
    802009e6:	bf01                	j	802008f6 <_Z6printfPKcz+0xa2>
        if ((s = va_arg(ap, char *)) == 0) s = "(null)";
    802009e8:	0000a917          	auipc	s2,0xa
    802009ec:	8c890913          	addi	s2,s2,-1848 # 8020a2b0 <rodata_start+0x2b0>
        for (; *s; s++) console.putc(*s);
    802009f0:	02800593          	li	a1,40
    802009f4:	b7c5                	j	802009d4 <_Z6printfPKcz+0x180>
        console.putc('%');
    802009f6:	85da                	mv	a1,s6
    802009f8:	8552                	mv	a0,s4
    802009fa:	00006097          	auipc	ra,0x6
    802009fe:	088080e7          	jalr	136(ra) # 80206a82 <_ZN7Console4putcEi>
        break;
    80200a02:	bdd5                	j	802008f6 <_Z6printfPKcz+0xa2>
        console.putc('%');
    80200a04:	85da                	mv	a1,s6
    80200a06:	8552                	mv	a0,s4
    80200a08:	00006097          	auipc	ra,0x6
    80200a0c:	07a080e7          	jalr	122(ra) # 80206a82 <_ZN7Console4putcEi>
        console.putc(c);
    80200a10:	85ca                	mv	a1,s2
    80200a12:	8552                	mv	a0,s4
    80200a14:	00006097          	auipc	ra,0x6
    80200a18:	06e080e7          	jalr	110(ra) # 80206a82 <_ZN7Console4putcEi>
        break;
    80200a1c:	bde9                	j	802008f6 <_Z6printfPKcz+0xa2>
  if (locking) pr.lock.unlock();
    80200a1e:	020d9163          	bnez	s11,80200a40 <_Z6printfPKcz+0x1ec>
}
    80200a22:	70e6                	ld	ra,120(sp)
    80200a24:	7446                	ld	s0,112(sp)
    80200a26:	74a6                	ld	s1,104(sp)
    80200a28:	7906                	ld	s2,96(sp)
    80200a2a:	69e6                	ld	s3,88(sp)
    80200a2c:	6a46                	ld	s4,80(sp)
    80200a2e:	6aa6                	ld	s5,72(sp)
    80200a30:	6b06                	ld	s6,64(sp)
    80200a32:	7be2                	ld	s7,56(sp)
    80200a34:	7c42                	ld	s8,48(sp)
    80200a36:	7ca2                	ld	s9,40(sp)
    80200a38:	7d02                	ld	s10,32(sp)
    80200a3a:	6de2                	ld	s11,24(sp)
    80200a3c:	6129                	addi	sp,sp,192
    80200a3e:	8082                	ret
  if (locking) pr.lock.unlock();
    80200a40:	00022517          	auipc	a0,0x22
    80200a44:	21850513          	addi	a0,a0,536 # 80222c58 <_ZL2pr>
    80200a48:	00000097          	auipc	ra,0x0
    80200a4c:	480080e7          	jalr	1152(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
}
    80200a50:	bfc9                	j	80200a22 <_Z6printfPKcz+0x1ce>

0000000080200a52 <_Z9backtracev>:
void backtrace() {
    80200a52:	7179                	addi	sp,sp,-48
    80200a54:	f406                	sd	ra,40(sp)
    80200a56:	f022                	sd	s0,32(sp)
    80200a58:	ec26                	sd	s1,24(sp)
    80200a5a:	e84a                	sd	s2,16(sp)
    80200a5c:	e44e                	sd	s3,8(sp)
    80200a5e:	e052                	sd	s4,0(sp)
    80200a60:	1800                	addi	s0,sp,48

static inline uint64_t
r_fp()
{
    uint64_t x;
    asm volatile("mv %0, s0" : "=r" (x) );
    80200a62:	84a2                	mv	s1,s0
  uint64_t stack_top = PGROUNDUP(s0);
    80200a64:	6905                	lui	s2,0x1
    80200a66:	197d                	addi	s2,s2,-1
    80200a68:	9926                	add	s2,s2,s1
    80200a6a:	79fd                	lui	s3,0xfffff
    80200a6c:	01397933          	and	s2,s2,s3
  uint64_t stack_bottom = PGROUNDDOWN(s0);
    80200a70:	0134f9b3          	and	s3,s1,s3
  printf("backtrace:\n");
    80200a74:	0000a517          	auipc	a0,0xa
    80200a78:	85450513          	addi	a0,a0,-1964 # 8020a2c8 <rodata_start+0x2c8>
    80200a7c:	00000097          	auipc	ra,0x0
    80200a80:	dd8080e7          	jalr	-552(ra) # 80200854 <_Z6printfPKcz>
  while (fp != stack_top && fp != stack_bottom) {
    80200a84:	02990563          	beq	s2,s1,80200aae <_Z9backtracev+0x5c>
    80200a88:	02998363          	beq	s3,s1,80200aae <_Z9backtracev+0x5c>
    printf("%p\n", *(uint64_t *)(fp - 8));
    80200a8c:	0000aa17          	auipc	s4,0xa
    80200a90:	85ca0a13          	addi	s4,s4,-1956 # 8020a2e8 <rodata_start+0x2e8>
    80200a94:	ff84b583          	ld	a1,-8(s1)
    80200a98:	8552                	mv	a0,s4
    80200a9a:	00000097          	auipc	ra,0x0
    80200a9e:	dba080e7          	jalr	-582(ra) # 80200854 <_Z6printfPKcz>
    fp = *(uint64_t *)(fp - 16);
    80200aa2:	ff04b483          	ld	s1,-16(s1)
  while (fp != stack_top && fp != stack_bottom) {
    80200aa6:	00990463          	beq	s2,s1,80200aae <_Z9backtracev+0x5c>
    80200aaa:	fe9995e3          	bne	s3,s1,80200a94 <_Z9backtracev+0x42>
}
    80200aae:	70a2                	ld	ra,40(sp)
    80200ab0:	7402                	ld	s0,32(sp)
    80200ab2:	64e2                	ld	s1,24(sp)
    80200ab4:	6942                	ld	s2,16(sp)
    80200ab6:	69a2                	ld	s3,8(sp)
    80200ab8:	6a02                	ld	s4,0(sp)
    80200aba:	6145                	addi	sp,sp,48
    80200abc:	8082                	ret

0000000080200abe <_Z7cpudumpi>:
void cpudump(int cpuid) {
    80200abe:	1101                	addi	sp,sp,-32
    80200ac0:	ec06                	sd	ra,24(sp)
    80200ac2:	e822                	sd	s0,16(sp)
    80200ac4:	e426                	sd	s1,8(sp)
    80200ac6:	1000                	addi	s0,sp,32
    80200ac8:	85aa                	mv	a1,a0
  Cpu *cpu = cpus + cpuid;
    80200aca:	00751493          	slli	s1,a0,0x7
    80200ace:	00022797          	auipc	a5,0x22
    80200ad2:	d7278793          	addi	a5,a5,-654 # 80222840 <cpus>
    80200ad6:	94be                	add	s1,s1,a5
  printf("cpu id=%d, task=%p\n", cpuid, cpu->task);
    80200ad8:	6090                	ld	a2,0(s1)
    80200ada:	00009517          	auipc	a0,0x9
    80200ade:	7fe50513          	addi	a0,a0,2046 # 8020a2d8 <rodata_start+0x2d8>
    80200ae2:	00000097          	auipc	ra,0x0
    80200ae6:	d72080e7          	jalr	-654(ra) # 80200854 <_Z6printfPKcz>
static void contextdump(struct context *ctx) { printf("ra=%p sp=%p\n", ctx->ra, ctx->sp); }
    80200aea:	6890                	ld	a2,16(s1)
    80200aec:	648c                	ld	a1,8(s1)
    80200aee:	0000a517          	auipc	a0,0xa
    80200af2:	80250513          	addi	a0,a0,-2046 # 8020a2f0 <rodata_start+0x2f0>
    80200af6:	00000097          	auipc	ra,0x0
    80200afa:	d5e080e7          	jalr	-674(ra) # 80200854 <_Z6printfPKcz>
}
    80200afe:	60e2                	ld	ra,24(sp)
    80200b00:	6442                	ld	s0,16(sp)
    80200b02:	64a2                	ld	s1,8(sp)
    80200b04:	6105                	addi	sp,sp,32
    80200b06:	8082                	ret

0000000080200b08 <_Z10printfinitv>:
    ;
}

void printfinit(void) {
    80200b08:	1101                	addi	sp,sp,-32
    80200b0a:	ec06                	sd	ra,24(sp)
    80200b0c:	e822                	sd	s0,16(sp)
    80200b0e:	e426                	sd	s1,8(sp)
    80200b10:	1000                	addi	s0,sp,32
  pr.lock.init("pr");
    80200b12:	00022497          	auipc	s1,0x22
    80200b16:	14648493          	addi	s1,s1,326 # 80222c58 <_ZL2pr>
    80200b1a:	00009597          	auipc	a1,0x9
    80200b1e:	7e658593          	addi	a1,a1,2022 # 8020a300 <rodata_start+0x300>
    80200b22:	8526                	mv	a0,s1
    80200b24:	00000097          	auipc	ra,0x0
    80200b28:	2d2080e7          	jalr	722(ra) # 80200df6 <_ZN8SpinLock4initEPKc>
  pr.locking = true;
    80200b2c:	4785                	li	a5,1
    80200b2e:	00f48c23          	sb	a5,24(s1)
}
    80200b32:	60e2                	ld	ra,24(sp)
    80200b34:	6442                	ld	s0,16(sp)
    80200b36:	64a2                	ld	s1,8(sp)
    80200b38:	6105                	addi	sp,sp,32
    80200b3a:	8082                	ret

0000000080200b3c <_GLOBAL__sub_I_panicked>:
    80200b3c:	1141                	addi	sp,sp,-16
    80200b3e:	e406                	sd	ra,8(sp)
    80200b40:	e022                	sd	s0,0(sp)
    80200b42:	0800                	addi	s0,sp,16
static struct {
    80200b44:	00022517          	auipc	a0,0x22
    80200b48:	11450513          	addi	a0,a0,276 # 80222c58 <_ZL2pr>
    80200b4c:	00000097          	auipc	ra,0x0
    80200b50:	278080e7          	jalr	632(ra) # 80200dc4 <_ZN8SpinLockC1Ev>
}
    80200b54:	60a2                	ld	ra,8(sp)
    80200b56:	6402                	ld	s0,0(sp)
    80200b58:	0141                	addi	sp,sp,16
    80200b5a:	8082                	ret

0000000080200b5c <_Z6memsetPvij>:
#include "types.hpp"
#include "StartOS.hpp"

void *memset(void *dst, int c, uint_t n) {
    80200b5c:	1141                	addi	sp,sp,-16
    80200b5e:	e422                	sd	s0,8(sp)
    80200b60:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  size_t i;
  for (i = 0; i < n; i++) {
    80200b62:	1602                	slli	a2,a2,0x20
    80200b64:	9201                	srli	a2,a2,0x20
    80200b66:	ca01                	beqz	a2,80200b76 <_Z6memsetPvij+0x1a>
    80200b68:	87aa                	mv	a5,a0
    80200b6a:	962a                	add	a2,a2,a0
    cdst[i] = c;
    80200b6c:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
    80200b70:	0785                	addi	a5,a5,1
    80200b72:	fec79de3          	bne	a5,a2,80200b6c <_Z6memsetPvij+0x10>
  }
  return dst;
}
    80200b76:	6422                	ld	s0,8(sp)
    80200b78:	0141                	addi	sp,sp,16
    80200b7a:	8082                	ret

0000000080200b7c <_Z6memcmpPKvS0_j>:

int memcmp(const void *v1, const void *v2, uint_t n) {
    80200b7c:	1141                	addi	sp,sp,-16
    80200b7e:	e422                	sd	s0,8(sp)
    80200b80:	0800                	addi	s0,sp,16
  const uchar_t *s1, *s2;

  s1 = static_cast<const uchar_t *>(v1);
  s2 = static_cast<const uchar_t *>(v2);
  while (n-- > 0) {
    80200b82:	ca05                	beqz	a2,80200bb2 <_Z6memcmpPKvS0_j+0x36>
    80200b84:	fff6069b          	addiw	a3,a2,-1
    80200b88:	1682                	slli	a3,a3,0x20
    80200b8a:	9281                	srli	a3,a3,0x20
    80200b8c:	0685                	addi	a3,a3,1
    80200b8e:	96aa                	add	a3,a3,a0
    if (*s1 != *s2) return *s1 - *s2;
    80200b90:	00054783          	lbu	a5,0(a0)
    80200b94:	0005c703          	lbu	a4,0(a1)
    80200b98:	00e79863          	bne	a5,a4,80200ba8 <_Z6memcmpPKvS0_j+0x2c>
    s1++, s2++;
    80200b9c:	0505                	addi	a0,a0,1
    80200b9e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    80200ba0:	fed518e3          	bne	a0,a3,80200b90 <_Z6memcmpPKvS0_j+0x14>
  }

  return 0;
    80200ba4:	4501                	li	a0,0
    80200ba6:	a019                	j	80200bac <_Z6memcmpPKvS0_j+0x30>
    if (*s1 != *s2) return *s1 - *s2;
    80200ba8:	40e7853b          	subw	a0,a5,a4
}
    80200bac:	6422                	ld	s0,8(sp)
    80200bae:	0141                	addi	sp,sp,16
    80200bb0:	8082                	ret
  return 0;
    80200bb2:	4501                	li	a0,0
    80200bb4:	bfe5                	j	80200bac <_Z6memcmpPKvS0_j+0x30>

0000000080200bb6 <_Z7memmovePvPKvj>:

void *memmove(void *dst, const void *src, uint_t n) {
    80200bb6:	1141                	addi	sp,sp,-16
    80200bb8:	e422                	sd	s0,8(sp)
    80200bba:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = static_cast<const char *>(src);
  d = static_cast<char *>(dst);
  if (s < d && s + n > d) {
    80200bbc:	02a5e563          	bltu	a1,a0,80200be6 <_Z7memmovePvPKvj+0x30>
    s += n;
    d += n;
    while (n-- > 0) *--d = *--s;
  } else
    while (n-- > 0) *d++ = *s++;
    80200bc0:	fff6069b          	addiw	a3,a2,-1
    80200bc4:	ce11                	beqz	a2,80200be0 <_Z7memmovePvPKvj+0x2a>
    80200bc6:	1682                	slli	a3,a3,0x20
    80200bc8:	9281                	srli	a3,a3,0x20
    80200bca:	0685                	addi	a3,a3,1
    80200bcc:	96ae                	add	a3,a3,a1
    80200bce:	87aa                	mv	a5,a0
    80200bd0:	0585                	addi	a1,a1,1
    80200bd2:	0785                	addi	a5,a5,1
    80200bd4:	fff5c703          	lbu	a4,-1(a1)
    80200bd8:	fee78fa3          	sb	a4,-1(a5)
    80200bdc:	feb69ae3          	bne	a3,a1,80200bd0 <_Z7memmovePvPKvj+0x1a>

  return dst;
}
    80200be0:	6422                	ld	s0,8(sp)
    80200be2:	0141                	addi	sp,sp,16
    80200be4:	8082                	ret
  if (s < d && s + n > d) {
    80200be6:	02061713          	slli	a4,a2,0x20
    80200bea:	9301                	srli	a4,a4,0x20
    80200bec:	00e587b3          	add	a5,a1,a4
    80200bf0:	fcf578e3          	bgeu	a0,a5,80200bc0 <_Z7memmovePvPKvj+0xa>
    d += n;
    80200bf4:	972a                	add	a4,a4,a0
    while (n-- > 0) *--d = *--s;
    80200bf6:	fff6069b          	addiw	a3,a2,-1
    80200bfa:	d27d                	beqz	a2,80200be0 <_Z7memmovePvPKvj+0x2a>
    80200bfc:	02069613          	slli	a2,a3,0x20
    80200c00:	9201                	srli	a2,a2,0x20
    80200c02:	fff64613          	not	a2,a2
    80200c06:	963e                	add	a2,a2,a5
    80200c08:	17fd                	addi	a5,a5,-1
    80200c0a:	177d                	addi	a4,a4,-1
    80200c0c:	0007c683          	lbu	a3,0(a5)
    80200c10:	00d70023          	sb	a3,0(a4)
    80200c14:	fec79ae3          	bne	a5,a2,80200c08 <_Z7memmovePvPKvj+0x52>
    80200c18:	b7e1                	j	80200be0 <_Z7memmovePvPKvj+0x2a>

0000000080200c1a <_Z6memcpyPvPKvj>:

// memcpy exists to placate GCC.  Use memmove.
void *memcpy(void *dst, const void *src, uint_t n) { return memmove(dst, src, n); }
    80200c1a:	1141                	addi	sp,sp,-16
    80200c1c:	e406                	sd	ra,8(sp)
    80200c1e:	e022                	sd	s0,0(sp)
    80200c20:	0800                	addi	s0,sp,16
    80200c22:	00000097          	auipc	ra,0x0
    80200c26:	f94080e7          	jalr	-108(ra) # 80200bb6 <_Z7memmovePvPKvj>
    80200c2a:	60a2                	ld	ra,8(sp)
    80200c2c:	6402                	ld	s0,0(sp)
    80200c2e:	0141                	addi	sp,sp,16
    80200c30:	8082                	ret

0000000080200c32 <_Z7strncmpPKcS0_j>:

int strncmp(const char *p, const char *q, uint_t n) {
    80200c32:	1141                	addi	sp,sp,-16
    80200c34:	e422                	sd	s0,8(sp)
    80200c36:	0800                	addi	s0,sp,16
  while (n > 0 && *p && *p == *q) n--, p++, q++;
    80200c38:	c61d                	beqz	a2,80200c66 <_Z7strncmpPKcS0_j+0x34>
    80200c3a:	00054783          	lbu	a5,0(a0)
    80200c3e:	cb99                	beqz	a5,80200c54 <_Z7strncmpPKcS0_j+0x22>
    80200c40:	0005c703          	lbu	a4,0(a1)
    80200c44:	00f71863          	bne	a4,a5,80200c54 <_Z7strncmpPKcS0_j+0x22>
    80200c48:	367d                	addiw	a2,a2,-1
    80200c4a:	0505                	addi	a0,a0,1
    80200c4c:	0585                	addi	a1,a1,1
    80200c4e:	f675                	bnez	a2,80200c3a <_Z7strncmpPKcS0_j+0x8>
  if (n == 0) return 0;
    80200c50:	4501                	li	a0,0
    80200c52:	a039                	j	80200c60 <_Z7strncmpPKcS0_j+0x2e>
    80200c54:	ca19                	beqz	a2,80200c6a <_Z7strncmpPKcS0_j+0x38>
  return (uchar_t)*p - (uchar_t)*q;
    80200c56:	00054503          	lbu	a0,0(a0)
    80200c5a:	0005c783          	lbu	a5,0(a1)
    80200c5e:	9d1d                	subw	a0,a0,a5
}
    80200c60:	6422                	ld	s0,8(sp)
    80200c62:	0141                	addi	sp,sp,16
    80200c64:	8082                	ret
  if (n == 0) return 0;
    80200c66:	4501                	li	a0,0
    80200c68:	bfe5                	j	80200c60 <_Z7strncmpPKcS0_j+0x2e>
    80200c6a:	4501                	li	a0,0
    80200c6c:	bfd5                	j	80200c60 <_Z7strncmpPKcS0_j+0x2e>

0000000080200c6e <_Z11strncasecmpPKcS0_m>:
  return c;
}


int strncasecmp(const char *s1, const char *s2, size_t n)
{
    80200c6e:	1141                	addi	sp,sp,-16
    80200c70:	e422                	sd	s0,8(sp)
    80200c72:	0800                	addi	s0,sp,16
  const unsigned char *p1 = (const unsigned char *)s1;
  const unsigned char *p2 = (const unsigned char *)s2;
  int result;

  if (p1 == p2 || n == 0)
    80200c74:	04b50e63          	beq	a0,a1,80200cd0 <_Z11strncasecmpPKcS0_m+0x62>
    80200c78:	882a                	mv	a6,a0
    return 0;
    80200c7a:	4501                	li	a0,0
  if (p1 == p2 || n == 0)
    80200c7c:	ca39                	beqz	a2,80200cd2 <_Z11strncasecmpPKcS0_m+0x64>
    80200c7e:	00c58333          	add	t1,a1,a2
  if (c >= 'A' && c <= 'Z')
    80200c82:	48e5                	li	a7,25
    80200c84:	a831                	j	80200ca0 <_Z11strncasecmpPKcS0_m+0x32>
    return c + 32;
    80200c86:	0206879b          	addiw	a5,a3,32
    80200c8a:	0ff7f793          	andi	a5,a5,255
    80200c8e:	a015                	j	80200cb2 <_Z11strncasecmpPKcS0_m+0x44>

  while ((result = toLowCase(*p1) - toLowCase(*p2++)) == 0)
    80200c90:	40e7853b          	subw	a0,a5,a4
    80200c94:	02e79f63          	bne	a5,a4,80200cd2 <_Z11strncasecmpPKcS0_m+0x64>
    if (*p1++ == '\0' || --n == 0)
    80200c98:	0805                	addi	a6,a6,1
    80200c9a:	ce85                	beqz	a3,80200cd2 <_Z11strncasecmpPKcS0_m+0x64>
    80200c9c:	02b30b63          	beq	t1,a1,80200cd2 <_Z11strncasecmpPKcS0_m+0x64>
  while ((result = toLowCase(*p1) - toLowCase(*p2++)) == 0)
    80200ca0:	00084683          	lbu	a3,0(a6)
  if (c >= 'A' && c <= 'Z')
    80200ca4:	fbf6871b          	addiw	a4,a3,-65
    80200ca8:	0ff77713          	andi	a4,a4,255
  return c;
    80200cac:	87b6                	mv	a5,a3
  if (c >= 'A' && c <= 'Z')
    80200cae:	fce8fce3          	bgeu	a7,a4,80200c86 <_Z11strncasecmpPKcS0_m+0x18>
  while ((result = toLowCase(*p1) - toLowCase(*p2++)) == 0)
    80200cb2:	2781                	sext.w	a5,a5
    80200cb4:	0585                	addi	a1,a1,1
    80200cb6:	fff5c703          	lbu	a4,-1(a1)
  if (c >= 'A' && c <= 'Z')
    80200cba:	fbf7061b          	addiw	a2,a4,-65
    80200cbe:	0ff67613          	andi	a2,a2,255
    80200cc2:	fcc8e7e3          	bltu	a7,a2,80200c90 <_Z11strncasecmpPKcS0_m+0x22>
    return c + 32;
    80200cc6:	0207071b          	addiw	a4,a4,32
    80200cca:	0ff77713          	andi	a4,a4,255
    80200cce:	b7c9                	j	80200c90 <_Z11strncasecmpPKcS0_m+0x22>
    return 0;
    80200cd0:	4501                	li	a0,0
      break;
  return result;
}
    80200cd2:	6422                	ld	s0,8(sp)
    80200cd4:	0141                	addi	sp,sp,16
    80200cd6:	8082                	ret

0000000080200cd8 <_Z7strncpyPcPKci>:

char *strncpy(char *s, const char *t, int n) {
    80200cd8:	1141                	addi	sp,sp,-16
    80200cda:	e422                	sd	s0,8(sp)
    80200cdc:	0800                	addi	s0,sp,16
    80200cde:	872a                	mv	a4,a0
    80200ce0:	a801                	j	80200cf0 <_Z7strncpyPcPKci+0x18>
  char *os;

  os = s;
  while (n-- > 0 && (*s++ = *t++) != 0)
    80200ce2:	0705                	addi	a4,a4,1
    80200ce4:	0005c783          	lbu	a5,0(a1)
    80200ce8:	fef70fa3          	sb	a5,-1(a4)
    80200cec:	0585                	addi	a1,a1,1
    80200cee:	c789                	beqz	a5,80200cf8 <_Z7strncpyPcPKci+0x20>
    80200cf0:	8832                	mv	a6,a2
    80200cf2:	367d                	addiw	a2,a2,-1
    80200cf4:	ff0047e3          	bgtz	a6,80200ce2 <_Z7strncpyPcPKci+0xa>
    ;
  while (n-- > 0) *s++ = 0;
    80200cf8:	00c05d63          	blez	a2,80200d12 <_Z7strncpyPcPKci+0x3a>
    80200cfc:	86ba                	mv	a3,a4
    80200cfe:	0685                	addi	a3,a3,1
    80200d00:	fe068fa3          	sb	zero,-1(a3)
    80200d04:	fff6c793          	not	a5,a3
    80200d08:	9fb9                	addw	a5,a5,a4
    80200d0a:	010787bb          	addw	a5,a5,a6
    80200d0e:	fef048e3          	bgtz	a5,80200cfe <_Z7strncpyPcPKci+0x26>
  return os;
}
    80200d12:	6422                	ld	s0,8(sp)
    80200d14:	0141                	addi	sp,sp,16
    80200d16:	8082                	ret

0000000080200d18 <_Z10safestrcpyPcPKci>:

// Like strncpy but guaranteed to NUL-terminate.
char *safestrcpy(char *s, const char *t, int n) {
    80200d18:	1141                	addi	sp,sp,-16
    80200d1a:	e422                	sd	s0,8(sp)
    80200d1c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if (n <= 0) return os;
    80200d1e:	02c05463          	blez	a2,80200d46 <_Z10safestrcpyPcPKci+0x2e>
    80200d22:	fff6069b          	addiw	a3,a2,-1
    80200d26:	1682                	slli	a3,a3,0x20
    80200d28:	9281                	srli	a3,a3,0x20
    80200d2a:	96ae                	add	a3,a3,a1
    80200d2c:	87aa                	mv	a5,a0
    80200d2e:	a801                	j	80200d3e <_Z10safestrcpyPcPKci+0x26>
  while (--n > 0 && (*s++ = *t++) != 0)
    80200d30:	0585                	addi	a1,a1,1
    80200d32:	0785                	addi	a5,a5,1
    80200d34:	fff5c703          	lbu	a4,-1(a1)
    80200d38:	fee78fa3          	sb	a4,-1(a5)
    80200d3c:	c319                	beqz	a4,80200d42 <_Z10safestrcpyPcPKci+0x2a>
    80200d3e:	fed599e3          	bne	a1,a3,80200d30 <_Z10safestrcpyPcPKci+0x18>
    ;
  *s = 0;
    80200d42:	00078023          	sb	zero,0(a5)
  return os;
}
    80200d46:	6422                	ld	s0,8(sp)
    80200d48:	0141                	addi	sp,sp,16
    80200d4a:	8082                	ret

0000000080200d4c <_Z6strlenPKc>:

int strlen(const char *s) {
    80200d4c:	1141                	addi	sp,sp,-16
    80200d4e:	e422                	sd	s0,8(sp)
    80200d50:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
    80200d52:	00054783          	lbu	a5,0(a0)
    80200d56:	cf91                	beqz	a5,80200d72 <_Z6strlenPKc+0x26>
    80200d58:	0505                	addi	a0,a0,1
    80200d5a:	87aa                	mv	a5,a0
    80200d5c:	4685                	li	a3,1
    80200d5e:	9e89                	subw	a3,a3,a0
    80200d60:	00f6853b          	addw	a0,a3,a5
    80200d64:	0785                	addi	a5,a5,1
    80200d66:	fff7c703          	lbu	a4,-1(a5)
    80200d6a:	fb7d                	bnez	a4,80200d60 <_Z6strlenPKc+0x14>
    ;
  return n;
}
    80200d6c:	6422                	ld	s0,8(sp)
    80200d6e:	0141                	addi	sp,sp,16
    80200d70:	8082                	ret
  for (n = 0; s[n]; n++)
    80200d72:	4501                	li	a0,0
    80200d74:	bfe5                	j	80200d6c <_Z6strlenPKc+0x20>

0000000080200d76 <_Z6strchrPKcc>:

char *strchr(const char *s, char c) {
    80200d76:	1141                	addi	sp,sp,-16
    80200d78:	e422                	sd	s0,8(sp)
    80200d7a:	0800                	addi	s0,sp,16
  for (; *s; s++)
    80200d7c:	00054783          	lbu	a5,0(a0)
    80200d80:	cb99                	beqz	a5,80200d96 <_Z6strchrPKcc+0x20>
    if (*s == c) return (char *)s;
    80200d82:	00f58763          	beq	a1,a5,80200d90 <_Z6strchrPKcc+0x1a>
  for (; *s; s++)
    80200d86:	0505                	addi	a0,a0,1
    80200d88:	00054783          	lbu	a5,0(a0)
    80200d8c:	fbfd                	bnez	a5,80200d82 <_Z6strchrPKcc+0xc>
  return 0;
    80200d8e:	4501                	li	a0,0
}
    80200d90:	6422                	ld	s0,8(sp)
    80200d92:	0141                	addi	sp,sp,16
    80200d94:	8082                	ret
  return 0;
    80200d96:	4501                	li	a0,0
    80200d98:	bfe5                	j	80200d90 <_Z6strchrPKcc+0x1a>

0000000080200d9a <_Z7strrchrPKcc>:

char *strrchr(const char *s, char c) {
    80200d9a:	1141                	addi	sp,sp,-16
    80200d9c:	e422                	sd	s0,8(sp)
    80200d9e:	0800                	addi	s0,sp,16
  char *ans = 0;
  for (; *s; s++)
    80200da0:	00054703          	lbu	a4,0(a0)
    80200da4:	cf01                	beqz	a4,80200dbc <_Z7strrchrPKcc+0x22>
    80200da6:	87aa                	mv	a5,a0
  char *ans = 0;
    80200da8:	4501                	li	a0,0
    80200daa:	a029                	j	80200db4 <_Z7strrchrPKcc+0x1a>
  for (; *s; s++)
    80200dac:	0785                	addi	a5,a5,1
    80200dae:	0007c703          	lbu	a4,0(a5)
    80200db2:	c711                	beqz	a4,80200dbe <_Z7strrchrPKcc+0x24>
    if (*s == c) ans = (char *)s;
    80200db4:	fee59ce3          	bne	a1,a4,80200dac <_Z7strrchrPKcc+0x12>
    80200db8:	853e                	mv	a0,a5
    80200dba:	bfcd                	j	80200dac <_Z7strrchrPKcc+0x12>
  char *ans = 0;
    80200dbc:	4501                	li	a0,0
  return ans;
    80200dbe:	6422                	ld	s0,8(sp)
    80200dc0:	0141                	addi	sp,sp,16
    80200dc2:	8082                	ret

0000000080200dc4 <_ZN8SpinLockC1Ev>:
// #include "os/SpinLock.hpp"
#include "common/printk.hpp"
#include "os/Cpu.hpp"
// #include "os/SpinLock.hpp"
#include "os/Intr.hpp"
SpinLock::SpinLock() {}
    80200dc4:	1141                	addi	sp,sp,-16
    80200dc6:	e422                	sd	s0,8(sp)
    80200dc8:	0800                	addi	s0,sp,16
    80200dca:	6422                	ld	s0,8(sp)
    80200dcc:	0141                	addi	sp,sp,16
    80200dce:	8082                	ret

0000000080200dd0 <_ZN8SpinLockC1EPKc>:
SpinLock::SpinLock(const char *name) {
    80200dd0:	1101                	addi	sp,sp,-32
    80200dd2:	ec06                	sd	ra,24(sp)
    80200dd4:	e822                	sd	s0,16(sp)
    80200dd6:	e426                	sd	s1,8(sp)
    80200dd8:	1000                	addi	s0,sp,32
    80200dda:	84aa                	mv	s1,a0
  this->name = name;
    80200ddc:	e50c                	sd	a1,8(a0)
  locked = false;
    80200dde:	00050023          	sb	zero,0(a0)
  this->cpuid = Cpu::cpuid();
    80200de2:	00000097          	auipc	ra,0x0
    80200de6:	176080e7          	jalr	374(ra) # 80200f58 <_ZN3Cpu5cpuidEv>
    80200dea:	c888                	sw	a0,16(s1)
}
    80200dec:	60e2                	ld	ra,24(sp)
    80200dee:	6442                	ld	s0,16(sp)
    80200df0:	64a2                	ld	s1,8(sp)
    80200df2:	6105                	addi	sp,sp,32
    80200df4:	8082                	ret

0000000080200df6 <_ZN8SpinLock4initEPKc>:

void SpinLock::init(const char *name) {
    80200df6:	1101                	addi	sp,sp,-32
    80200df8:	ec06                	sd	ra,24(sp)
    80200dfa:	e822                	sd	s0,16(sp)
    80200dfc:	e426                	sd	s1,8(sp)
    80200dfe:	1000                	addi	s0,sp,32
    80200e00:	84aa                	mv	s1,a0
  this->name = name;
    80200e02:	e50c                	sd	a1,8(a0)
  locked = false;
    80200e04:	00050023          	sb	zero,0(a0)
  this->cpuid = Cpu::cpuid();
    80200e08:	00000097          	auipc	ra,0x0
    80200e0c:	150080e7          	jalr	336(ra) # 80200f58 <_ZN3Cpu5cpuidEv>
    80200e10:	c888                	sw	a0,16(s1)
}
    80200e12:	60e2                	ld	ra,24(sp)
    80200e14:	6442                	ld	s0,16(sp)
    80200e16:	64a2                	ld	s1,8(sp)
    80200e18:	6105                	addi	sp,sp,32
    80200e1a:	8082                	ret

0000000080200e1c <_ZN8SpinLock7holdingEv>:
  __sync_lock_release(&locked);

  Intr::pop_off();
}

bool SpinLock::holding() {
    80200e1c:	87aa                	mv	a5,a0
  int r;
  r = (this->locked && this->cpuid == Cpu::cpuid());
    80200e1e:	00054503          	lbu	a0,0(a0)
    80200e22:	e111                	bnez	a0,80200e26 <_ZN8SpinLock7holdingEv+0xa>
  return r;
}
    80200e24:	8082                	ret
bool SpinLock::holding() {
    80200e26:	1101                	addi	sp,sp,-32
    80200e28:	ec06                	sd	ra,24(sp)
    80200e2a:	e822                	sd	s0,16(sp)
    80200e2c:	e426                	sd	s1,8(sp)
    80200e2e:	1000                	addi	s0,sp,32
  r = (this->locked && this->cpuid == Cpu::cpuid());
    80200e30:	4b84                	lw	s1,16(a5)
    80200e32:	00000097          	auipc	ra,0x0
    80200e36:	126080e7          	jalr	294(ra) # 80200f58 <_ZN3Cpu5cpuidEv>
    80200e3a:	40a48533          	sub	a0,s1,a0
    80200e3e:	00153513          	seqz	a0,a0
}
    80200e42:	60e2                	ld	ra,24(sp)
    80200e44:	6442                	ld	s0,16(sp)
    80200e46:	64a2                	ld	s1,8(sp)
    80200e48:	6105                	addi	sp,sp,32
    80200e4a:	8082                	ret

0000000080200e4c <_ZN8SpinLock4lockEv>:
void SpinLock::lock() {
    80200e4c:	1101                	addi	sp,sp,-32
    80200e4e:	ec06                	sd	ra,24(sp)
    80200e50:	e822                	sd	s0,16(sp)
    80200e52:	e426                	sd	s1,8(sp)
    80200e54:	1000                	addi	s0,sp,32
    80200e56:	84aa                	mv	s1,a0
  Intr::push_off();  // 禁用中断以避免死锁。
    80200e58:	00002097          	auipc	ra,0x2
    80200e5c:	5e0080e7          	jalr	1504(ra) # 80203438 <_ZN4Intr8push_offEv>
  if (holding()) {
    80200e60:	8526                	mv	a0,s1
    80200e62:	00000097          	auipc	ra,0x0
    80200e66:	fba080e7          	jalr	-70(ra) # 80200e1c <_ZN8SpinLock7holdingEv>
    80200e6a:	ed0d                	bnez	a0,80200ea4 <_ZN8SpinLock4lockEv+0x58>
  while (__sync_lock_test_and_set(&(this->locked), 1) != 0)
    80200e6c:	ffc4f713          	andi	a4,s1,-4
    80200e70:	0034f693          	andi	a3,s1,3
    80200e74:	0036969b          	slliw	a3,a3,0x3
    80200e78:	4605                	li	a2,1
    80200e7a:	00d6163b          	sllw	a2,a2,a3
    80200e7e:	44c727af          	amoor.w.aq	a5,a2,(a4)
    80200e82:	00d7d7bb          	srlw	a5,a5,a3
    80200e86:	0ff7f793          	andi	a5,a5,255
    80200e8a:	fbf5                	bnez	a5,80200e7e <_ZN8SpinLock4lockEv+0x32>
  __sync_synchronize();
    80200e8c:	0ff0000f          	fence
  cpuid = Cpu::cpuid();
    80200e90:	00000097          	auipc	ra,0x0
    80200e94:	0c8080e7          	jalr	200(ra) # 80200f58 <_ZN3Cpu5cpuidEv>
    80200e98:	c888                	sw	a0,16(s1)
}
    80200e9a:	60e2                	ld	ra,24(sp)
    80200e9c:	6442                	ld	s0,16(sp)
    80200e9e:	64a2                	ld	s1,8(sp)
    80200ea0:	6105                	addi	sp,sp,32
    80200ea2:	8082                	ret
    printf("%s ", this->name);
    80200ea4:	648c                	ld	a1,8(s1)
    80200ea6:	00009517          	auipc	a0,0x9
    80200eaa:	47a50513          	addi	a0,a0,1146 # 8020a320 <_ZL6digits+0x18>
    80200eae:	00000097          	auipc	ra,0x0
    80200eb2:	9a6080e7          	jalr	-1626(ra) # 80200854 <_Z6printfPKcz>
    panic("re-acquire");
    80200eb6:	00009517          	auipc	a0,0x9
    80200eba:	47250513          	addi	a0,a0,1138 # 8020a328 <_ZL6digits+0x20>
    80200ebe:	00000097          	auipc	ra,0x0
    80200ec2:	924080e7          	jalr	-1756(ra) # 802007e2 <_Z5panicPKc>
    80200ec6:	b75d                	j	80200e6c <_ZN8SpinLock4lockEv+0x20>

0000000080200ec8 <_ZN8SpinLock6unlockEv>:
void SpinLock::unlock() {
    80200ec8:	1101                	addi	sp,sp,-32
    80200eca:	ec06                	sd	ra,24(sp)
    80200ecc:	e822                	sd	s0,16(sp)
    80200ece:	e426                	sd	s1,8(sp)
    80200ed0:	1000                	addi	s0,sp,32
    80200ed2:	84aa                	mv	s1,a0
  if (!holding()) {
    80200ed4:	00000097          	auipc	ra,0x0
    80200ed8:	f48080e7          	jalr	-184(ra) # 80200e1c <_ZN8SpinLock7holdingEv>
    80200edc:	c115                	beqz	a0,80200f00 <_ZN8SpinLock6unlockEv+0x38>
  this->cpuid = -1;
    80200ede:	57fd                	li	a5,-1
    80200ee0:	c89c                	sw	a5,16(s1)
  __sync_synchronize();
    80200ee2:	0ff0000f          	fence
  __sync_lock_release(&locked);
    80200ee6:	0ff0000f          	fence
    80200eea:	00048023          	sb	zero,0(s1)
  Intr::pop_off();
    80200eee:	00002097          	auipc	ra,0x2
    80200ef2:	598080e7          	jalr	1432(ra) # 80203486 <_ZN4Intr7pop_offEv>
}
    80200ef6:	60e2                	ld	ra,24(sp)
    80200ef8:	6442                	ld	s0,16(sp)
    80200efa:	64a2                	ld	s1,8(sp)
    80200efc:	6105                	addi	sp,sp,32
    80200efe:	8082                	ret
    printf("%s ",this->name);
    80200f00:	648c                	ld	a1,8(s1)
    80200f02:	00009517          	auipc	a0,0x9
    80200f06:	41e50513          	addi	a0,a0,1054 # 8020a320 <_ZL6digits+0x18>
    80200f0a:	00000097          	auipc	ra,0x0
    80200f0e:	94a080e7          	jalr	-1718(ra) # 80200854 <_Z6printfPKcz>
    panic("unlock");
    80200f12:	00009517          	auipc	a0,0x9
    80200f16:	42650513          	addi	a0,a0,1062 # 8020a338 <_ZL6digits+0x30>
    80200f1a:	00000097          	auipc	ra,0x0
    80200f1e:	8c8080e7          	jalr	-1848(ra) # 802007e2 <_Z5panicPKc>
    80200f22:	bf75                	j	80200ede <_ZN8SpinLock6unlockEv+0x16>

0000000080200f24 <_ZN3Cpu4initEv>:
#include "common/string.hpp"
#include "common/printk.hpp"

extern "C" Cpu cpus[];  // cpu数组，定义在boot/main.c

void Cpu::init() {
    80200f24:	1101                	addi	sp,sp,-32
    80200f26:	ec06                	sd	ra,24(sp)
    80200f28:	e822                	sd	s0,16(sp)
    80200f2a:	e426                	sd	s1,8(sp)
    80200f2c:	1000                	addi	s0,sp,32
    80200f2e:	84aa                	mv	s1,a0
  memset(cpus, 0, sizeof(Cpu) * NCPU);
    80200f30:	10000613          	li	a2,256
    80200f34:	4581                	li	a1,0
    80200f36:	00022517          	auipc	a0,0x22
    80200f3a:	90a50513          	addi	a0,a0,-1782 # 80222840 <cpus>
    80200f3e:	00000097          	auipc	ra,0x0
    80200f42:	c1e080e7          	jalr	-994(ra) # 80200b5c <_Z6memsetPvij>
  this->intr_enable = false;
    80200f46:	06048e23          	sb	zero,124(s1)
  this->noff = 0;
    80200f4a:	0604ac23          	sw	zero,120(s1)
}
    80200f4e:	60e2                	ld	ra,24(sp)
    80200f50:	6442                	ld	s0,16(sp)
    80200f52:	64a2                	ld	s1,8(sp)
    80200f54:	6105                	addi	sp,sp,32
    80200f56:	8082                	ret

0000000080200f58 <_ZN3Cpu5cpuidEv>:

int Cpu::cpuid() {
    80200f58:	1141                	addi	sp,sp,-16
    80200f5a:	e422                	sd	s0,8(sp)
    80200f5c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80200f5e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80200f60:	2501                	sext.w	a0,a0
    80200f62:	6422                	ld	s0,8(sp)
    80200f64:	0141                	addi	sp,sp,16
    80200f66:	8082                	ret

0000000080200f68 <_ZN3Cpu5mycpuEv>:

Cpu *Cpu::mycpu() {
    80200f68:	1141                	addi	sp,sp,-16
    80200f6a:	e422                	sd	s0,8(sp)
    80200f6c:	0800                	addi	s0,sp,16
    80200f6e:	8792                	mv	a5,tp
  int id = cpuid();
  Cpu *c = &cpus[id];
    80200f70:	2781                	sext.w	a5,a5
    80200f72:	079e                	slli	a5,a5,0x7
  return c;
    80200f74:	00022517          	auipc	a0,0x22
    80200f78:	8cc50513          	addi	a0,a0,-1844 # 80222840 <cpus>
    80200f7c:	953e                	add	a0,a0,a5
    80200f7e:	6422                	ld	s0,8(sp)
    80200f80:	0141                	addi	sp,sp,16
    80200f82:	8082                	ret

0000000080200f84 <_Z8trapinitv>:
extern Timer timer;

extern "C" char trampoline[], uservec[], userret[];

// 配置中断处理程序
void trapinit(void) { w_stvec((uint64_t)kernelvec); }
    80200f84:	1141                	addi	sp,sp,-16
    80200f86:	e422                	sd	s0,8(sp)
    80200f88:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80200f8a:	00000797          	auipc	a5,0x0
    80200f8e:	6e678793          	addi	a5,a5,1766 # 80201670 <kernelvec>
    80200f92:	10579073          	csrw	stvec,a5
    80200f96:	6422                	ld	s0,8(sp)
    80200f98:	0141                	addi	sp,sp,16
    80200f9a:	8082                	ret

0000000080200f9c <_Z12trapinithartv>:

void trapinithart(void) {
    80200f9c:	1141                	addi	sp,sp,-16
    80200f9e:	e406                	sd	ra,8(sp)
    80200fa0:	e022                	sd	s0,0(sp)
    80200fa2:	0800                	addi	s0,sp,16
    80200fa4:	00000797          	auipc	a5,0x0
    80200fa8:	6cc78793          	addi	a5,a5,1740 # 80201670 <kernelvec>
    80200fac:	10579073          	csrw	stvec,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80200fb0:	100027f3          	csrr	a5,sstatus
  w_stvec((uint64_t)kernelvec);
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80200fb4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80200fb8:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80200fbc:	104027f3          	csrr	a5,sie
  // enable supervisor-mode timer interrupts.
  w_sie(r_sie() | SIE_SEIE | SIE_SSIE | SIE_STIE);
    80200fc0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80200fc4:	10479073          	csrw	sie,a5
  timer.setTimeout();
    80200fc8:	00013517          	auipc	a0,0x13
    80200fcc:	0f850513          	addi	a0,a0,248 # 802140c0 <timer>
    80200fd0:	00000097          	auipc	ra,0x0
    80200fd4:	758080e7          	jalr	1880(ra) # 80201728 <_ZN5Timer10setTimeoutEv>
}
    80200fd8:	60a2                	ld	ra,8(sp)
    80200fda:	6402                	ld	s0,0(sp)
    80200fdc:	0141                	addi	sp,sp,16
    80200fde:	8082                	ret

0000000080200fe0 <_Z11usertrapretv>:
  }

  usertrapret();
}

void usertrapret() {
    80200fe0:	1141                	addi	sp,sp,-16
    80200fe2:	e406                	sd	ra,8(sp)
    80200fe4:	e022                	sd	s0,0(sp)
    80200fe6:	0800                	addi	s0,sp,16
  Task *task = myTask();
    80200fe8:	00001097          	auipc	ra,0x1
    80200fec:	a24080e7          	jalr	-1500(ra) # 80201a0c <_Z6myTaskv>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80200ff0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80200ff4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80200ff6:	10079073          	csrw	sstatus,a5
  // 现在将trap处理程序从kerneltrap()切换为usertrap(), 因此需要
  // 禁用中断直到我们返回用户空间。
  intr_off();

  // 现在返回用户空间，设置中断处理函数为trampoline.S的uservec()
  w_stvec(TRAMPOLINE + ((uint64_t)uservec - (uint64_t)trampoline));
    80200ffa:	00007697          	auipc	a3,0x7
    80200ffe:	00668693          	addi	a3,a3,6 # 80208000 <trampoline>
    80201002:	040007b7          	lui	a5,0x4000
    80201006:	17fd                	addi	a5,a5,-1
    80201008:	07b2                	slli	a5,a5,0xc
    8020100a:	00007717          	auipc	a4,0x7
    8020100e:	ff670713          	addi	a4,a4,-10 # 80208000 <trampoline>
    80201012:	973e                	add	a4,a4,a5
    80201014:	8f15                	sub	a4,a4,a3
  asm volatile("csrw stvec, %0" : : "r" (x));
    80201016:	10571073          	csrw	stvec,a4

  // 设置trapframe, 以便下次的trap能够正常运行
  task->trapframe->kernel_satp = r_satp();             // 内核页表
    8020101a:	6138                	ld	a4,64(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8020101c:	18002673          	csrr	a2,satp
    80201020:	e310                	sd	a2,0(a4)
  task->trapframe->kernel_sp = task->kstack + PGSIZE;  // 进程的内核栈
    80201022:	6130                	ld	a2,64(a0)
    80201024:	6d78                	ld	a4,216(a0)
    80201026:	6585                	lui	a1,0x1
    80201028:	972e                	add	a4,a4,a1
    8020102a:	e618                	sd	a4,8(a2)
  task->trapframe->kernel_trap = (uint64_t)usertrap;
    8020102c:	6138                	ld	a4,64(a0)
    8020102e:	00000617          	auipc	a2,0x0
    80201032:	11a60613          	addi	a2,a2,282 # 80201148 <_Z8usertrapv>
    80201036:	eb10                	sd	a2,16(a4)
  task->trapframe->kernel_hartid = r_tp();  // cpu id
    80201038:	6138                	ld	a4,64(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8020103a:	8612                	mv	a2,tp
    8020103c:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8020103e:	10002773          	csrr	a4,sstatus

  // 设置trampoline.S中的sret返回用户空间所需要的寄存器

  // 设置S Previous Privilege(SPP)为User
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP;  // 为用户模式清除SPP
    80201042:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE;  // 允许用户模式下的中断
    80201046:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8020104a:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // 设置S的Exception Program Counter(epc)为保存的pc
  w_sepc(task->trapframe->epc);
    8020104e:	6138                	ld	a4,64(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80201050:	6f18                	ld	a4,24(a4)
    80201052:	14171073          	csrw	sepc,a4

  // 将用户页表转换为satp寄存器需要的格式
  uint64_t satp = MAKE_SATP(task->pagetable);
    80201056:	652c                	ld	a1,72(a0)
    80201058:	81b1                	srli	a1,a1,0xc

  // 跳转到虚拟内存顶端的trampoline.S, 它会切换页表为用户页表, 恢复用户
  // 寄存器, 并通过sret切换到用户模式。

  uint64_t fn = TRAMPOLINE + ((uint64_t)userret - (uint64_t)trampoline);
    8020105a:	00007717          	auipc	a4,0x7
    8020105e:	03670713          	addi	a4,a4,54 # 80208090 <userret>
    80201062:	97ba                	add	a5,a5,a4
    80201064:	8f95                	sub	a5,a5,a3
  ((void (*)(uint64_t, uint64_t))fn)(TRAPFRAME, satp);
    80201066:	577d                	li	a4,-1
    80201068:	177e                	slli	a4,a4,0x3f
    8020106a:	8dd9                	or	a1,a1,a4
    8020106c:	02000537          	lui	a0,0x2000
    80201070:	157d                	addi	a0,a0,-1
    80201072:	0536                	slli	a0,a0,0xd
    80201074:	9782                	jalr	a5
}
    80201076:	60a2                	ld	ra,8(sp)
    80201078:	6402                	ld	s0,0(sp)
    8020107a:	0141                	addi	sp,sp,16
    8020107c:	8082                	ret

000000008020107e <_Z11device_intrv>:
// 设备中断处理程序
// 用于判断中断是否为外部和软件中断，并处理它
// 2: 时钟中断
// 1: 其他设备中断
// 0: 无法识别的中断
int device_intr() {
    8020107e:	1101                	addi	sp,sp,-32
    80201080:	ec06                	sd	ra,24(sp)
    80201082:	e822                	sd	s0,16(sp)
    80201084:	e426                	sd	s1,8(sp)
    80201086:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80201088:	14202773          	csrr	a4,scause
  uint64_t scause = r_scause();
#ifdef QEMU
  // handle external interrupt
  if ((0x8000000000000000L & scause) && 9 == (scause & 0xff))
    8020108c:	00074d63          	bltz	a4,802010a6 <_Z11device_intrv+0x28>
    w_sip(r_sip() & ~2);  // clear pending bit
    sbi_set_mie();
#endif

    return 1;
  } else if (0x8000000000000005L == scause) {
    80201090:	57fd                	li	a5,-1
    80201092:	17fe                	slli	a5,a5,0x3f
    80201094:	0795                	addi	a5,a5,5
    timer.handleIntr();
    return 2;
  } else {
    return 0;
    80201096:	4501                	li	a0,0
  } else if (0x8000000000000005L == scause) {
    80201098:	08f70e63          	beq	a4,a5,80201134 <_Z11device_intrv+0xb6>
  }
}
    8020109c:	60e2                	ld	ra,24(sp)
    8020109e:	6442                	ld	s0,16(sp)
    802010a0:	64a2                	ld	s1,8(sp)
    802010a2:	6105                	addi	sp,sp,32
    802010a4:	8082                	ret
  if ((0x8000000000000000L & scause) && 9 == (scause & 0xff))
    802010a6:	0ff77793          	andi	a5,a4,255
    802010aa:	46a5                	li	a3,9
    802010ac:	fed792e3          	bne	a5,a3,80201090 <_Z11device_intrv+0x12>
    int irq = plic.claim();
    802010b0:	00022517          	auipc	a0,0x22
    802010b4:	89850513          	addi	a0,a0,-1896 # 80222948 <plic>
    802010b8:	00000097          	auipc	ra,0x0
    802010bc:	558080e7          	jalr	1368(ra) # 80201610 <_ZN4Plic5claimEv>
    802010c0:	84aa                	mv	s1,a0
    if (UART_IRQ == irq) {
    802010c2:	47a9                	li	a5,10
    802010c4:	02f50163          	beq	a0,a5,802010e6 <_Z11device_intrv+0x68>
    } else if (DISK_IRQ == irq) {
    802010c8:	4785                	li	a5,1
    802010ca:	06f50063          	beq	a0,a5,8020112a <_Z11device_intrv+0xac>
    return 1;
    802010ce:	4505                	li	a0,1
    } else if (irq) {
    802010d0:	d4f1                	beqz	s1,8020109c <_Z11device_intrv+0x1e>
      printf("unexpected interrupt irq = %d\n", irq);
    802010d2:	85a6                	mv	a1,s1
    802010d4:	00009517          	auipc	a0,0x9
    802010d8:	26c50513          	addi	a0,a0,620 # 8020a340 <_ZL6digits+0x38>
    802010dc:	fffff097          	auipc	ra,0xfffff
    802010e0:	778080e7          	jalr	1912(ra) # 80200854 <_Z6printfPKcz>
    802010e4:	a829                	j	802010fe <_Z11device_intrv+0x80>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
    802010e6:	4501                	li	a0,0
    802010e8:	4581                	li	a1,0
    802010ea:	4601                	li	a2,0
    802010ec:	4681                	li	a3,0
    802010ee:	4889                	li	a7,2
    802010f0:	00000073          	ecall
      if (-1 != c) {
    802010f4:	0005071b          	sext.w	a4,a0
    802010f8:	57fd                	li	a5,-1
    802010fa:	00f71d63          	bne	a4,a5,80201114 <_Z11device_intrv+0x96>
      plic.complete(irq);
    802010fe:	85a6                	mv	a1,s1
    80201100:	00022517          	auipc	a0,0x22
    80201104:	84850513          	addi	a0,a0,-1976 # 80222948 <plic>
    80201108:	00000097          	auipc	ra,0x0
    8020110c:	532080e7          	jalr	1330(ra) # 8020163a <_ZN4Plic8completeEi>
    return 1;
    80201110:	4505                	li	a0,1
    80201112:	b769                	j	8020109c <_Z11device_intrv+0x1e>
        console.console_intr(c);
    80201114:	0ff57593          	andi	a1,a0,255
    80201118:	00013517          	auipc	a0,0x13
    8020111c:	ee850513          	addi	a0,a0,-280 # 80214000 <console>
    80201120:	00006097          	auipc	ra,0x6
    80201124:	b40080e7          	jalr	-1216(ra) # 80206c60 <_ZN7Console12console_intrEc>
    80201128:	bfd9                	j	802010fe <_Z11device_intrv+0x80>
      disk_intr();
    8020112a:	00005097          	auipc	ra,0x5
    8020112e:	c1e080e7          	jalr	-994(ra) # 80205d48 <_Z9disk_intrv>
    80201132:	b7f1                	j	802010fe <_Z11device_intrv+0x80>
    timer.handleIntr();
    80201134:	00013517          	auipc	a0,0x13
    80201138:	f8c50513          	addi	a0,a0,-116 # 802140c0 <timer>
    8020113c:	00000097          	auipc	ra,0x0
    80201140:	644080e7          	jalr	1604(ra) # 80201780 <_ZN5Timer10handleIntrEv>
    return 2;
    80201144:	4509                	li	a0,2
    80201146:	bf99                	j	8020109c <_Z11device_intrv+0x1e>

0000000080201148 <_Z8usertrapv>:
void usertrap(void) {
    80201148:	1101                	addi	sp,sp,-32
    8020114a:	ec06                	sd	ra,24(sp)
    8020114c:	e822                	sd	s0,16(sp)
    8020114e:	e426                	sd	s1,8(sp)
    80201150:	e04a                	sd	s2,0(sp)
    80201152:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80201154:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0) panic("usertrap: not from user mode");
    80201158:	1007f793          	andi	a5,a5,256
    8020115c:	e3ad                	bnez	a5,802011be <_Z8usertrapv+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    8020115e:	00000797          	auipc	a5,0x0
    80201162:	51278793          	addi	a5,a5,1298 # 80201670 <kernelvec>
    80201166:	10579073          	csrw	stvec,a5
  Task *task = myTask();
    8020116a:	00001097          	auipc	ra,0x1
    8020116e:	8a2080e7          	jalr	-1886(ra) # 80201a0c <_Z6myTaskv>
    80201172:	84aa                	mv	s1,a0
  task->trapframe->epc = r_sepc();
    80201174:	613c                	ld	a5,64(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80201176:	14102773          	csrr	a4,sepc
    8020117a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    8020117c:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    80201180:	47a1                	li	a5,8
    80201182:	0af71363          	bne	a4,a5,80201228 <_Z8usertrapv+0xe0>
    if (task->killed) {
    80201186:	591c                	lw	a5,48(a0)
    80201188:	e7a1                	bnez	a5,802011d0 <_Z8usertrapv+0x88>
    task->trapframe->epc += 4;
    8020118a:	60b8                	ld	a4,64(s1)
    8020118c:	6f1c                	ld	a5,24(a4)
    8020118e:	0791                	addi	a5,a5,4
    80201190:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80201192:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80201196:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8020119a:	10079073          	csrw	sstatus,a5
    syscall();
    8020119e:	00001097          	auipc	ra,0x1
    802011a2:	768080e7          	jalr	1896(ra) # 80202906 <_Z7syscallv>
  if (task->killed) exit(-1);
    802011a6:	589c                	lw	a5,48(s1)
    802011a8:	eff9                	bnez	a5,80201286 <_Z8usertrapv+0x13e>
  usertrapret();
    802011aa:	00000097          	auipc	ra,0x0
    802011ae:	e36080e7          	jalr	-458(ra) # 80200fe0 <_Z11usertrapretv>
}
    802011b2:	60e2                	ld	ra,24(sp)
    802011b4:	6442                	ld	s0,16(sp)
    802011b6:	64a2                	ld	s1,8(sp)
    802011b8:	6902                	ld	s2,0(sp)
    802011ba:	6105                	addi	sp,sp,32
    802011bc:	8082                	ret
  if ((r_sstatus() & SSTATUS_SPP) != 0) panic("usertrap: not from user mode");
    802011be:	00009517          	auipc	a0,0x9
    802011c2:	1a250513          	addi	a0,a0,418 # 8020a360 <_ZL6digits+0x58>
    802011c6:	fffff097          	auipc	ra,0xfffff
    802011ca:	61c080e7          	jalr	1564(ra) # 802007e2 <_Z5panicPKc>
    802011ce:	bf41                	j	8020115e <_Z8usertrapv+0x16>
    802011d0:	00009717          	auipc	a4,0x9
    802011d4:	1b070713          	addi	a4,a4,432 # 8020a380 <_ZL6digits+0x78>
    802011d8:	03f00693          	li	a3,63
    802011dc:	00009617          	auipc	a2,0x9
    802011e0:	1b460613          	addi	a2,a2,436 # 8020a390 <_ZL6digits+0x88>
    802011e4:	00009597          	auipc	a1,0x9
    802011e8:	f9458593          	addi	a1,a1,-108 # 8020a178 <rodata_start+0x178>
    802011ec:	00009517          	auipc	a0,0x9
    802011f0:	f9450513          	addi	a0,a0,-108 # 8020a180 <rodata_start+0x180>
    802011f4:	fffff097          	auipc	ra,0xfffff
    802011f8:	660080e7          	jalr	1632(ra) # 80200854 <_Z6printfPKcz>
      LOG_DEBUG("usertrap killed");
    802011fc:	00009517          	auipc	a0,0x9
    80201200:	1a450513          	addi	a0,a0,420 # 8020a3a0 <_ZL6digits+0x98>
    80201204:	fffff097          	auipc	ra,0xfffff
    80201208:	650080e7          	jalr	1616(ra) # 80200854 <_Z6printfPKcz>
    8020120c:	00009517          	auipc	a0,0x9
    80201210:	e9450513          	addi	a0,a0,-364 # 8020a0a0 <rodata_start+0xa0>
    80201214:	fffff097          	auipc	ra,0xfffff
    80201218:	640080e7          	jalr	1600(ra) # 80200854 <_Z6printfPKcz>
      exit(-1);
    8020121c:	557d                	li	a0,-1
    8020121e:	00001097          	auipc	ra,0x1
    80201222:	ffa080e7          	jalr	-6(ra) # 80202218 <_Z4exiti>
    80201226:	b795                	j	8020118a <_Z8usertrapv+0x42>
  } else if ((which_dev = device_intr()) != 0) {
    80201228:	00000097          	auipc	ra,0x0
    8020122c:	e56080e7          	jalr	-426(ra) # 8020107e <_Z11device_intrv>
    80201230:	892a                	mv	s2,a0
    80201232:	c501                	beqz	a0,8020123a <_Z8usertrapv+0xf2>
  if (task->killed) exit(-1);
    80201234:	589c                	lw	a5,48(s1)
    80201236:	c3a1                	beqz	a5,80201276 <_Z8usertrapv+0x12e>
    80201238:	a815                	j	8020126c <_Z8usertrapv+0x124>
  asm volatile("csrr %0, scause" : "=r" (x) );
    8020123a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), task->pid);
    8020123e:	5c90                	lw	a2,56(s1)
    80201240:	00009517          	auipc	a0,0x9
    80201244:	17050513          	addi	a0,a0,368 # 8020a3b0 <_ZL6digits+0xa8>
    80201248:	fffff097          	auipc	ra,0xfffff
    8020124c:	60c080e7          	jalr	1548(ra) # 80200854 <_Z6printfPKcz>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80201250:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80201254:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80201258:	00009517          	auipc	a0,0x9
    8020125c:	18850513          	addi	a0,a0,392 # 8020a3e0 <_ZL6digits+0xd8>
    80201260:	fffff097          	auipc	ra,0xfffff
    80201264:	5f4080e7          	jalr	1524(ra) # 80200854 <_Z6printfPKcz>
    task->killed = 1;
    80201268:	4785                	li	a5,1
    8020126a:	d89c                	sw	a5,48(s1)
  if (task->killed) exit(-1);
    8020126c:	557d                	li	a0,-1
    8020126e:	00001097          	auipc	ra,0x1
    80201272:	faa080e7          	jalr	-86(ra) # 80202218 <_Z4exiti>
  if (which_dev == 2) {
    80201276:	4789                	li	a5,2
    80201278:	f2f919e3          	bne	s2,a5,802011aa <_Z8usertrapv+0x62>
    yield();
    8020127c:	00001097          	auipc	ra,0x1
    80201280:	0f6080e7          	jalr	246(ra) # 80202372 <_Z5yieldv>
    80201284:	b71d                	j	802011aa <_Z8usertrapv+0x62>
  int which_dev = 0;
    80201286:	4901                	li	s2,0
    80201288:	b7d5                	j	8020126c <_Z8usertrapv+0x124>

000000008020128a <kerneltrap>:
extern "C" void kerneltrap() {
    8020128a:	7179                	addi	sp,sp,-48
    8020128c:	f406                	sd	ra,40(sp)
    8020128e:	f022                	sd	s0,32(sp)
    80201290:	ec26                	sd	s1,24(sp)
    80201292:	e84a                	sd	s2,16(sp)
    80201294:	e44e                	sd	s3,8(sp)
    80201296:	e052                	sd	s4,0(sp)
    80201298:	1800                	addi	s0,sp,48
  Task *task = myTask();
    8020129a:	00000097          	auipc	ra,0x0
    8020129e:	772080e7          	jalr	1906(ra) # 80201a0c <_Z6myTaskv>
    802012a2:	84aa                	mv	s1,a0
  asm volatile("csrr %0, sepc" : "=r" (x) );
    802012a4:	141029f3          	csrr	s3,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    802012a8:	10002973          	csrr	s2,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    802012ac:	14202a73          	csrr	s4,scause
  if ((sstatus & SSTATUS_SPP) == 0) panic("kerneltrap: not from supervisor mode");
    802012b0:	10097793          	andi	a5,s2,256
    802012b4:	c79d                	beqz	a5,802012e2 <kerneltrap+0x58>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    802012b6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    802012ba:	8b89                	andi	a5,a5,2
  if (intr_get() != 0) panic("kerneltrap: interrupts enabled");
    802012bc:	ef85                	bnez	a5,802012f4 <kerneltrap+0x6a>
  which_dev = device_intr();
    802012be:	00000097          	auipc	ra,0x0
    802012c2:	dc0080e7          	jalr	-576(ra) # 8020107e <_Z11device_intrv>
  if (which_dev == 0) {  // 未知来源
    802012c6:	c121                	beqz	a0,80201306 <kerneltrap+0x7c>
  if (which_dev == 2 && task != 0 && task->state == RUNNING) {  // 时钟中断
    802012c8:	4789                	li	a5,2
    802012ca:	06f51b63          	bne	a0,a5,80201340 <kerneltrap+0xb6>
    802012ce:	c8ad                	beqz	s1,80201340 <kerneltrap+0xb6>
    802012d0:	4c98                	lw	a4,24(s1)
    802012d2:	478d                	li	a5,3
    802012d4:	06f71663          	bne	a4,a5,80201340 <kerneltrap+0xb6>
    yield();
    802012d8:	00001097          	auipc	ra,0x1
    802012dc:	09a080e7          	jalr	154(ra) # 80202372 <_Z5yieldv>
    802012e0:	a085                	j	80201340 <kerneltrap+0xb6>
  if ((sstatus & SSTATUS_SPP) == 0) panic("kerneltrap: not from supervisor mode");
    802012e2:	00009517          	auipc	a0,0x9
    802012e6:	11e50513          	addi	a0,a0,286 # 8020a400 <_ZL6digits+0xf8>
    802012ea:	fffff097          	auipc	ra,0xfffff
    802012ee:	4f8080e7          	jalr	1272(ra) # 802007e2 <_Z5panicPKc>
    802012f2:	b7d1                	j	802012b6 <kerneltrap+0x2c>
  if (intr_get() != 0) panic("kerneltrap: interrupts enabled");
    802012f4:	00009517          	auipc	a0,0x9
    802012f8:	13450513          	addi	a0,a0,308 # 8020a428 <_ZL6digits+0x120>
    802012fc:	fffff097          	auipc	ra,0xfffff
    80201300:	4e6080e7          	jalr	1254(ra) # 802007e2 <_Z5panicPKc>
    80201304:	bf6d                	j	802012be <kerneltrap+0x34>
    printf("scause %p\n", scause);
    80201306:	85d2                	mv	a1,s4
    80201308:	00009517          	auipc	a0,0x9
    8020130c:	14050513          	addi	a0,a0,320 # 8020a448 <_ZL6digits+0x140>
    80201310:	fffff097          	auipc	ra,0xfffff
    80201314:	544080e7          	jalr	1348(ra) # 80200854 <_Z6printfPKcz>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80201318:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8020131c:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80201320:	00009517          	auipc	a0,0x9
    80201324:	13850513          	addi	a0,a0,312 # 8020a458 <_ZL6digits+0x150>
    80201328:	fffff097          	auipc	ra,0xfffff
    8020132c:	52c080e7          	jalr	1324(ra) # 80200854 <_Z6printfPKcz>
    panic("kerneltrap");
    80201330:	00009517          	auipc	a0,0x9
    80201334:	14050513          	addi	a0,a0,320 # 8020a470 <_ZL6digits+0x168>
    80201338:	fffff097          	auipc	ra,0xfffff
    8020133c:	4aa080e7          	jalr	1194(ra) # 802007e2 <_Z5panicPKc>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80201340:	14199073          	csrw	sepc,s3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80201344:	10091073          	csrw	sstatus,s2
}
    80201348:	70a2                	ld	ra,40(sp)
    8020134a:	7402                	ld	s0,32(sp)
    8020134c:	64e2                	ld	s1,24(sp)
    8020134e:	6942                	ld	s2,16(sp)
    80201350:	69a2                	ld	s3,8(sp)
    80201352:	6a02                	ld	s4,0(sp)
    80201354:	6145                	addi	sp,sp,48
    80201356:	8082                	ret

0000000080201358 <_Z13trapframedumpP9trapframe>:
void trapframedump(struct trapframe *tf) {
    80201358:	1101                	addi	sp,sp,-32
    8020135a:	ec06                	sd	ra,24(sp)
    8020135c:	e822                	sd	s0,16(sp)
    8020135e:	e426                	sd	s1,8(sp)
    80201360:	1000                	addi	s0,sp,32
    80201362:	84aa                	mv	s1,a0
  printf("a0: %p\t", tf->a0);
    80201364:	792c                	ld	a1,112(a0)
    80201366:	00009517          	auipc	a0,0x9
    8020136a:	11a50513          	addi	a0,a0,282 # 8020a480 <_ZL6digits+0x178>
    8020136e:	fffff097          	auipc	ra,0xfffff
    80201372:	4e6080e7          	jalr	1254(ra) # 80200854 <_Z6printfPKcz>
  printf("a1: %p\t", tf->a1);
    80201376:	7cac                	ld	a1,120(s1)
    80201378:	00009517          	auipc	a0,0x9
    8020137c:	11050513          	addi	a0,a0,272 # 8020a488 <_ZL6digits+0x180>
    80201380:	fffff097          	auipc	ra,0xfffff
    80201384:	4d4080e7          	jalr	1236(ra) # 80200854 <_Z6printfPKcz>
  printf("a2: %p\t", tf->a2);
    80201388:	60cc                	ld	a1,128(s1)
    8020138a:	00009517          	auipc	a0,0x9
    8020138e:	10650513          	addi	a0,a0,262 # 8020a490 <_ZL6digits+0x188>
    80201392:	fffff097          	auipc	ra,0xfffff
    80201396:	4c2080e7          	jalr	1218(ra) # 80200854 <_Z6printfPKcz>
  printf("a3: %p\n", tf->a3);
    8020139a:	64cc                	ld	a1,136(s1)
    8020139c:	00009517          	auipc	a0,0x9
    802013a0:	0fc50513          	addi	a0,a0,252 # 8020a498 <_ZL6digits+0x190>
    802013a4:	fffff097          	auipc	ra,0xfffff
    802013a8:	4b0080e7          	jalr	1200(ra) # 80200854 <_Z6printfPKcz>
  printf("a4: %p\t", tf->a4);
    802013ac:	68cc                	ld	a1,144(s1)
    802013ae:	00009517          	auipc	a0,0x9
    802013b2:	0f250513          	addi	a0,a0,242 # 8020a4a0 <_ZL6digits+0x198>
    802013b6:	fffff097          	auipc	ra,0xfffff
    802013ba:	49e080e7          	jalr	1182(ra) # 80200854 <_Z6printfPKcz>
  printf("a5: %p\t", tf->a5);
    802013be:	6ccc                	ld	a1,152(s1)
    802013c0:	00009517          	auipc	a0,0x9
    802013c4:	0e850513          	addi	a0,a0,232 # 8020a4a8 <_ZL6digits+0x1a0>
    802013c8:	fffff097          	auipc	ra,0xfffff
    802013cc:	48c080e7          	jalr	1164(ra) # 80200854 <_Z6printfPKcz>
  printf("a6: %p\t", tf->a6);
    802013d0:	70cc                	ld	a1,160(s1)
    802013d2:	00009517          	auipc	a0,0x9
    802013d6:	0de50513          	addi	a0,a0,222 # 8020a4b0 <_ZL6digits+0x1a8>
    802013da:	fffff097          	auipc	ra,0xfffff
    802013de:	47a080e7          	jalr	1146(ra) # 80200854 <_Z6printfPKcz>
  printf("a7: %p\n", tf->a7);
    802013e2:	74cc                	ld	a1,168(s1)
    802013e4:	00009517          	auipc	a0,0x9
    802013e8:	0d450513          	addi	a0,a0,212 # 8020a4b8 <_ZL6digits+0x1b0>
    802013ec:	fffff097          	auipc	ra,0xfffff
    802013f0:	468080e7          	jalr	1128(ra) # 80200854 <_Z6printfPKcz>
  printf("t0: %p\t", tf->t0);
    802013f4:	64ac                	ld	a1,72(s1)
    802013f6:	00009517          	auipc	a0,0x9
    802013fa:	0ca50513          	addi	a0,a0,202 # 8020a4c0 <_ZL6digits+0x1b8>
    802013fe:	fffff097          	auipc	ra,0xfffff
    80201402:	456080e7          	jalr	1110(ra) # 80200854 <_Z6printfPKcz>
  printf("t1: %p\t", tf->t1);
    80201406:	68ac                	ld	a1,80(s1)
    80201408:	00009517          	auipc	a0,0x9
    8020140c:	0c050513          	addi	a0,a0,192 # 8020a4c8 <_ZL6digits+0x1c0>
    80201410:	fffff097          	auipc	ra,0xfffff
    80201414:	444080e7          	jalr	1092(ra) # 80200854 <_Z6printfPKcz>
  printf("t2: %p\t", tf->t2);
    80201418:	6cac                	ld	a1,88(s1)
    8020141a:	00009517          	auipc	a0,0x9
    8020141e:	0b650513          	addi	a0,a0,182 # 8020a4d0 <_ZL6digits+0x1c8>
    80201422:	fffff097          	auipc	ra,0xfffff
    80201426:	432080e7          	jalr	1074(ra) # 80200854 <_Z6printfPKcz>
  printf("t3: %p\n", tf->t3);
    8020142a:	1004b583          	ld	a1,256(s1)
    8020142e:	00009517          	auipc	a0,0x9
    80201432:	0aa50513          	addi	a0,a0,170 # 8020a4d8 <_ZL6digits+0x1d0>
    80201436:	fffff097          	auipc	ra,0xfffff
    8020143a:	41e080e7          	jalr	1054(ra) # 80200854 <_Z6printfPKcz>
  printf("t4: %p\t", tf->t4);
    8020143e:	1084b583          	ld	a1,264(s1)
    80201442:	00009517          	auipc	a0,0x9
    80201446:	09e50513          	addi	a0,a0,158 # 8020a4e0 <_ZL6digits+0x1d8>
    8020144a:	fffff097          	auipc	ra,0xfffff
    8020144e:	40a080e7          	jalr	1034(ra) # 80200854 <_Z6printfPKcz>
  printf("t5: %p\t", tf->t5);
    80201452:	1104b583          	ld	a1,272(s1)
    80201456:	00009517          	auipc	a0,0x9
    8020145a:	09250513          	addi	a0,a0,146 # 8020a4e8 <_ZL6digits+0x1e0>
    8020145e:	fffff097          	auipc	ra,0xfffff
    80201462:	3f6080e7          	jalr	1014(ra) # 80200854 <_Z6printfPKcz>
  printf("t6: %p\t", tf->t6);
    80201466:	1184b583          	ld	a1,280(s1)
    8020146a:	00009517          	auipc	a0,0x9
    8020146e:	08650513          	addi	a0,a0,134 # 8020a4f0 <_ZL6digits+0x1e8>
    80201472:	fffff097          	auipc	ra,0xfffff
    80201476:	3e2080e7          	jalr	994(ra) # 80200854 <_Z6printfPKcz>
  printf("s0: %p\n", tf->s0);
    8020147a:	70ac                	ld	a1,96(s1)
    8020147c:	00009517          	auipc	a0,0x9
    80201480:	07c50513          	addi	a0,a0,124 # 8020a4f8 <_ZL6digits+0x1f0>
    80201484:	fffff097          	auipc	ra,0xfffff
    80201488:	3d0080e7          	jalr	976(ra) # 80200854 <_Z6printfPKcz>
  printf("s1: %p\t", tf->s1);
    8020148c:	74ac                	ld	a1,104(s1)
    8020148e:	00009517          	auipc	a0,0x9
    80201492:	07250513          	addi	a0,a0,114 # 8020a500 <_ZL6digits+0x1f8>
    80201496:	fffff097          	auipc	ra,0xfffff
    8020149a:	3be080e7          	jalr	958(ra) # 80200854 <_Z6printfPKcz>
  printf("s2: %p\t", tf->s2);
    8020149e:	78cc                	ld	a1,176(s1)
    802014a0:	00009517          	auipc	a0,0x9
    802014a4:	06850513          	addi	a0,a0,104 # 8020a508 <_ZL6digits+0x200>
    802014a8:	fffff097          	auipc	ra,0xfffff
    802014ac:	3ac080e7          	jalr	940(ra) # 80200854 <_Z6printfPKcz>
  printf("s3: %p\t", tf->s3);
    802014b0:	7ccc                	ld	a1,184(s1)
    802014b2:	00009517          	auipc	a0,0x9
    802014b6:	05e50513          	addi	a0,a0,94 # 8020a510 <_ZL6digits+0x208>
    802014ba:	fffff097          	auipc	ra,0xfffff
    802014be:	39a080e7          	jalr	922(ra) # 80200854 <_Z6printfPKcz>
  printf("s4: %p\n", tf->s4);
    802014c2:	60ec                	ld	a1,192(s1)
    802014c4:	00009517          	auipc	a0,0x9
    802014c8:	05450513          	addi	a0,a0,84 # 8020a518 <_ZL6digits+0x210>
    802014cc:	fffff097          	auipc	ra,0xfffff
    802014d0:	388080e7          	jalr	904(ra) # 80200854 <_Z6printfPKcz>
  printf("s5: %p\t", tf->s5);
    802014d4:	64ec                	ld	a1,200(s1)
    802014d6:	00009517          	auipc	a0,0x9
    802014da:	04a50513          	addi	a0,a0,74 # 8020a520 <_ZL6digits+0x218>
    802014de:	fffff097          	auipc	ra,0xfffff
    802014e2:	376080e7          	jalr	886(ra) # 80200854 <_Z6printfPKcz>
  printf("s6: %p\t", tf->s6);
    802014e6:	68ec                	ld	a1,208(s1)
    802014e8:	00009517          	auipc	a0,0x9
    802014ec:	04050513          	addi	a0,a0,64 # 8020a528 <_ZL6digits+0x220>
    802014f0:	fffff097          	auipc	ra,0xfffff
    802014f4:	364080e7          	jalr	868(ra) # 80200854 <_Z6printfPKcz>
  printf("s7: %p\t", tf->s7);
    802014f8:	6cec                	ld	a1,216(s1)
    802014fa:	00009517          	auipc	a0,0x9
    802014fe:	03650513          	addi	a0,a0,54 # 8020a530 <_ZL6digits+0x228>
    80201502:	fffff097          	auipc	ra,0xfffff
    80201506:	352080e7          	jalr	850(ra) # 80200854 <_Z6printfPKcz>
  printf("s8: %p\n", tf->s8);
    8020150a:	70ec                	ld	a1,224(s1)
    8020150c:	00009517          	auipc	a0,0x9
    80201510:	02c50513          	addi	a0,a0,44 # 8020a538 <_ZL6digits+0x230>
    80201514:	fffff097          	auipc	ra,0xfffff
    80201518:	340080e7          	jalr	832(ra) # 80200854 <_Z6printfPKcz>
  printf("s9: %p\t", tf->s9);
    8020151c:	74ec                	ld	a1,232(s1)
    8020151e:	00009517          	auipc	a0,0x9
    80201522:	02250513          	addi	a0,a0,34 # 8020a540 <_ZL6digits+0x238>
    80201526:	fffff097          	auipc	ra,0xfffff
    8020152a:	32e080e7          	jalr	814(ra) # 80200854 <_Z6printfPKcz>
  printf("s10: %p\t", tf->s10);
    8020152e:	78ec                	ld	a1,240(s1)
    80201530:	00009517          	auipc	a0,0x9
    80201534:	01850513          	addi	a0,a0,24 # 8020a548 <_ZL6digits+0x240>
    80201538:	fffff097          	auipc	ra,0xfffff
    8020153c:	31c080e7          	jalr	796(ra) # 80200854 <_Z6printfPKcz>
  printf("s11: %p\t", tf->s11);
    80201540:	7cec                	ld	a1,248(s1)
    80201542:	00009517          	auipc	a0,0x9
    80201546:	01650513          	addi	a0,a0,22 # 8020a558 <_ZL6digits+0x250>
    8020154a:	fffff097          	auipc	ra,0xfffff
    8020154e:	30a080e7          	jalr	778(ra) # 80200854 <_Z6printfPKcz>
  printf("ra: %p\n", tf->ra);
    80201552:	748c                	ld	a1,40(s1)
    80201554:	00009517          	auipc	a0,0x9
    80201558:	01450513          	addi	a0,a0,20 # 8020a568 <_ZL6digits+0x260>
    8020155c:	fffff097          	auipc	ra,0xfffff
    80201560:	2f8080e7          	jalr	760(ra) # 80200854 <_Z6printfPKcz>
  printf("sp: %p\t", tf->sp);
    80201564:	788c                	ld	a1,48(s1)
    80201566:	00009517          	auipc	a0,0x9
    8020156a:	00a50513          	addi	a0,a0,10 # 8020a570 <_ZL6digits+0x268>
    8020156e:	fffff097          	auipc	ra,0xfffff
    80201572:	2e6080e7          	jalr	742(ra) # 80200854 <_Z6printfPKcz>
  printf("gp: %p\t", tf->gp);
    80201576:	7c8c                	ld	a1,56(s1)
    80201578:	00009517          	auipc	a0,0x9
    8020157c:	00050513          	mv	a0,a0
    80201580:	fffff097          	auipc	ra,0xfffff
    80201584:	2d4080e7          	jalr	724(ra) # 80200854 <_Z6printfPKcz>
  printf("tp: %p\t", tf->tp);
    80201588:	60ac                	ld	a1,64(s1)
    8020158a:	00009517          	auipc	a0,0x9
    8020158e:	ff650513          	addi	a0,a0,-10 # 8020a580 <_ZL6digits+0x278>
    80201592:	fffff097          	auipc	ra,0xfffff
    80201596:	2c2080e7          	jalr	706(ra) # 80200854 <_Z6printfPKcz>
  printf("epc: %p\n", tf->epc);
    8020159a:	6c8c                	ld	a1,24(s1)
    8020159c:	00009517          	auipc	a0,0x9
    802015a0:	fec50513          	addi	a0,a0,-20 # 8020a588 <_ZL6digits+0x280>
    802015a4:	fffff097          	auipc	ra,0xfffff
    802015a8:	2b0080e7          	jalr	688(ra) # 80200854 <_Z6printfPKcz>
}
    802015ac:	60e2                	ld	ra,24(sp)
    802015ae:	6442                	ld	s0,16(sp)
    802015b0:	64a2                	ld	s1,8(sp)
    802015b2:	6105                	addi	sp,sp,32
    802015b4:	8082                	ret

00000000802015b6 <_ZN4Plic4initEv>:
#include "memlayout.hpp"
#include "os/Cpu.hpp"
#include "types.hpp"
#include "StartOS.hpp"

void Plic::init() {
    802015b6:	1141                	addi	sp,sp,-16
    802015b8:	e422                	sd	s0,8(sp)
    802015ba:	0800                	addi	s0,sp,16
  // 设置IRQ的属性为非零，即启用plic
  *(uint32_t *)(PLIC_V + UART_IRQ * 4) = 1;
    802015bc:	00fc37b7          	lui	a5,0xfc3
    802015c0:	07ba                	slli	a5,a5,0xe
    802015c2:	4705                	li	a4,1
    802015c4:	d798                	sw	a4,40(a5)
  *(uint32_t *)(PLIC_V + DISK_IRQ * 4) = 1;
    802015c6:	c3d8                	sw	a4,4(a5)
}
    802015c8:	6422                	ld	s0,8(sp)
    802015ca:	0141                	addi	sp,sp,16
    802015cc:	8082                	ret

00000000802015ce <_ZN4Plic8initHartEv>:

void Plic::initHart(void) {
    802015ce:	1141                	addi	sp,sp,-16
    802015d0:	e406                	sd	ra,8(sp)
    802015d2:	e022                	sd	s0,0(sp)
    802015d4:	0800                	addi	s0,sp,16
  int hart = Cpu::cpuid();
    802015d6:	00000097          	auipc	ra,0x0
    802015da:	982080e7          	jalr	-1662(ra) # 80200f58 <_ZN3Cpu5cpuidEv>
#ifdef QEMU
  // 为当前hart的S模式设置uart的enable
  *(uint32_t *)PLIC_SENABLE(hart) = (1 << UART_IRQ) | (1 << DISK_IRQ);
    802015de:	0085171b          	slliw	a4,a0,0x8
    802015e2:	01f867b7          	lui	a5,0x1f86
    802015e6:	0785                	addi	a5,a5,1
    802015e8:	07b6                	slli	a5,a5,0xd
    802015ea:	97ba                	add	a5,a5,a4
    802015ec:	40200713          	li	a4,1026
    802015f0:	08e7a023          	sw	a4,128(a5) # 1f86080 <_entry-0x7e279f80>
  // 将当前hart的S模式优先级阈值设置为0
  *(uint32_t *)PLIC_SPRIORITY(hart) = 0;
    802015f4:	00d5179b          	slliw	a5,a0,0xd
    802015f8:	03f0c537          	lui	a0,0x3f0c
    802015fc:	20150513          	addi	a0,a0,513 # 3f0c201 <_entry-0x7c2f3dff>
    80201600:	0532                	slli	a0,a0,0xc
    80201602:	953e                	add	a0,a0,a5
    80201604:	00052023          	sw	zero,0(a0)
  uint32_t *hart_m_enable = (uint32_t *)PLIC_MENABLE(hart);
  *(hart_m_enable) = readd(hart_m_enable) | (1 << DISK_IRQ);
  uint32_t *hart0_m_int_enable_hi = hart_m_enable + 1;
  *(hart0_m_int_enable_hi) = readd(hart0_m_int_enable_hi) | (1 << (UART_IRQ % 32));
#endif
}
    80201608:	60a2                	ld	ra,8(sp)
    8020160a:	6402                	ld	s0,0(sp)
    8020160c:	0141                	addi	sp,sp,16
    8020160e:	8082                	ret

0000000080201610 <_ZN4Plic5claimEv>:

// 向PLIC询问中断
int Plic::claim(void) {
    80201610:	1141                	addi	sp,sp,-16
    80201612:	e406                	sd	ra,8(sp)
    80201614:	e022                	sd	s0,0(sp)
    80201616:	0800                	addi	s0,sp,16
  int hart = Cpu::cpuid();
    80201618:	00000097          	auipc	ra,0x0
    8020161c:	940080e7          	jalr	-1728(ra) # 80200f58 <_ZN3Cpu5cpuidEv>
  int irq;
#ifndef QEMU
  irq = *(uint32_t *)PLIC_MCLAIM(hart);
#else
  irq = *(uint32_t *)PLIC_SCLAIM(hart);
    80201620:	00d5179b          	slliw	a5,a0,0xd
    80201624:	03f0c537          	lui	a0,0x3f0c
    80201628:	20150513          	addi	a0,a0,513 # 3f0c201 <_entry-0x7c2f3dff>
    8020162c:	0532                	slli	a0,a0,0xc
    8020162e:	953e                	add	a0,a0,a5
#endif
  return irq;
}
    80201630:	4148                	lw	a0,4(a0)
    80201632:	60a2                	ld	ra,8(sp)
    80201634:	6402                	ld	s0,0(sp)
    80201636:	0141                	addi	sp,sp,16
    80201638:	8082                	ret

000000008020163a <_ZN4Plic8completeEi>:

// 告知PLIC已经处理了当前IRQ
void Plic::complete(int irq) {
    8020163a:	1101                	addi	sp,sp,-32
    8020163c:	ec06                	sd	ra,24(sp)
    8020163e:	e822                	sd	s0,16(sp)
    80201640:	e426                	sd	s1,8(sp)
    80201642:	1000                	addi	s0,sp,32
    80201644:	84ae                	mv	s1,a1
  int hart = Cpu::cpuid();
    80201646:	00000097          	auipc	ra,0x0
    8020164a:	912080e7          	jalr	-1774(ra) # 80200f58 <_ZN3Cpu5cpuidEv>
#ifndef QEMU
  *(uint32_t *)PLIC_MCLAIM(hart) = irq;
#else
  *(uint32_t *)PLIC_SCLAIM(hart) = irq;
    8020164e:	00d5179b          	slliw	a5,a0,0xd
    80201652:	03f0c537          	lui	a0,0x3f0c
    80201656:	20150513          	addi	a0,a0,513 # 3f0c201 <_entry-0x7c2f3dff>
    8020165a:	0532                	slli	a0,a0,0xc
    8020165c:	953e                	add	a0,a0,a5
    8020165e:	c144                	sw	s1,4(a0)
#endif
    80201660:	60e2                	ld	ra,24(sp)
    80201662:	6442                	ld	s0,16(sp)
    80201664:	64a2                	ld	s1,8(sp)
    80201666:	6105                	addi	sp,sp,32
    80201668:	8082                	ret
    8020166a:	0000                	unimp
    8020166c:	0000                	unimp
	...

0000000080201670 <kernelvec>:
    80201670:	7111                	addi	sp,sp,-256
    80201672:	e006                	sd	ra,0(sp)
    80201674:	e40a                	sd	sp,8(sp)
    80201676:	e80e                	sd	gp,16(sp)
    80201678:	ec12                	sd	tp,24(sp)
    8020167a:	f016                	sd	t0,32(sp)
    8020167c:	f41a                	sd	t1,40(sp)
    8020167e:	f81e                	sd	t2,48(sp)
    80201680:	fc22                	sd	s0,56(sp)
    80201682:	e0a6                	sd	s1,64(sp)
    80201684:	e4aa                	sd	a0,72(sp)
    80201686:	e8ae                	sd	a1,80(sp)
    80201688:	ecb2                	sd	a2,88(sp)
    8020168a:	f0b6                	sd	a3,96(sp)
    8020168c:	f4ba                	sd	a4,104(sp)
    8020168e:	f8be                	sd	a5,112(sp)
    80201690:	fcc2                	sd	a6,120(sp)
    80201692:	e146                	sd	a7,128(sp)
    80201694:	e54a                	sd	s2,136(sp)
    80201696:	e94e                	sd	s3,144(sp)
    80201698:	ed52                	sd	s4,152(sp)
    8020169a:	f156                	sd	s5,160(sp)
    8020169c:	f55a                	sd	s6,168(sp)
    8020169e:	f95e                	sd	s7,176(sp)
    802016a0:	fd62                	sd	s8,184(sp)
    802016a2:	e1e6                	sd	s9,192(sp)
    802016a4:	e5ea                	sd	s10,200(sp)
    802016a6:	e9ee                	sd	s11,208(sp)
    802016a8:	edf2                	sd	t3,216(sp)
    802016aa:	f1f6                	sd	t4,224(sp)
    802016ac:	f5fa                	sd	t5,232(sp)
    802016ae:	f9fe                	sd	t6,240(sp)
    802016b0:	bdbff0ef          	jal	ra,8020128a <kerneltrap>
    802016b4:	6082                	ld	ra,0(sp)
    802016b6:	6122                	ld	sp,8(sp)
    802016b8:	61c2                	ld	gp,16(sp)
    802016ba:	6262                	ld	tp,24(sp)
    802016bc:	7282                	ld	t0,32(sp)
    802016be:	7322                	ld	t1,40(sp)
    802016c0:	73c2                	ld	t2,48(sp)
    802016c2:	7462                	ld	s0,56(sp)
    802016c4:	6486                	ld	s1,64(sp)
    802016c6:	6526                	ld	a0,72(sp)
    802016c8:	65c6                	ld	a1,80(sp)
    802016ca:	6666                	ld	a2,88(sp)
    802016cc:	7686                	ld	a3,96(sp)
    802016ce:	7726                	ld	a4,104(sp)
    802016d0:	77c6                	ld	a5,112(sp)
    802016d2:	7866                	ld	a6,120(sp)
    802016d4:	688a                	ld	a7,128(sp)
    802016d6:	692a                	ld	s2,136(sp)
    802016d8:	69ca                	ld	s3,144(sp)
    802016da:	6a6a                	ld	s4,152(sp)
    802016dc:	7a8a                	ld	s5,160(sp)
    802016de:	7b2a                	ld	s6,168(sp)
    802016e0:	7bca                	ld	s7,176(sp)
    802016e2:	7c6a                	ld	s8,184(sp)
    802016e4:	6c8e                	ld	s9,192(sp)
    802016e6:	6d2e                	ld	s10,200(sp)
    802016e8:	6dce                	ld	s11,208(sp)
    802016ea:	6e6e                	ld	t3,216(sp)
    802016ec:	7e8e                	ld	t4,224(sp)
    802016ee:	7f2e                	ld	t5,232(sp)
    802016f0:	7fce                	ld	t6,240(sp)
    802016f2:	6111                	addi	sp,sp,256
    802016f4:	10200073          	sret
    802016f8:	0000                	unimp
    802016fa:	0000                	unimp
	...

00000000802016fe <_ZN5TimerC1Ej>:
#include "types.hpp"
#include "StartOS.hpp"

// extern "C" void timervec();

Timer::Timer(uint32_t interval) : interval(interval) {
    802016fe:	1101                	addi	sp,sp,-32
    80201700:	ec06                	sd	ra,24(sp)
    80201702:	e822                	sd	s0,16(sp)
    80201704:	e426                	sd	s1,8(sp)
    80201706:	e04a                	sd	s2,0(sp)
    80201708:	1000                	addi	s0,sp,32
    8020170a:	84aa                	mv	s1,a0
    8020170c:	892e                	mv	s2,a1
    8020170e:	0521                	addi	a0,a0,8
    80201710:	fffff097          	auipc	ra,0xfffff
    80201714:	6b4080e7          	jalr	1716(ra) # 80200dc4 <_ZN8SpinLockC1Ev>
    80201718:	0324a023          	sw	s2,32(s1)
}
    8020171c:	60e2                	ld	ra,24(sp)
    8020171e:	6442                	ld	s0,16(sp)
    80201720:	64a2                	ld	s1,8(sp)
    80201722:	6902                	ld	s2,0(sp)
    80201724:	6105                	addi	sp,sp,32
    80201726:	8082                	ret

0000000080201728 <_ZN5Timer10setTimeoutEv>:
void Timer::init() {
  spinLock.init("timer");
  setTimeout();
}

void Timer::setTimeout() {
    80201728:	1141                	addi	sp,sp,-16
    8020172a:	e422                	sd	s0,8(sp)
    8020172c:	0800                	addi	s0,sp,16
  asm volatile("rdtime %0" : "=r" (x) );
    8020172e:	c0102573          	rdtime	a0
  int t = r_time() + INTERVAL;
  sbi_set_timer(t);
    80201732:	000f47b7          	lui	a5,0xf4
    80201736:	2407879b          	addiw	a5,a5,576
    8020173a:	9d3d                	addw	a0,a0,a5
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
    8020173c:	4581                	li	a1,0
    8020173e:	4601                	li	a2,0
    80201740:	4681                	li	a3,0
    80201742:	4881                	li	a7,0
    80201744:	00000073          	ecall
}
    80201748:	6422                	ld	s0,8(sp)
    8020174a:	0141                	addi	sp,sp,16
    8020174c:	8082                	ret

000000008020174e <_ZN5Timer4initEv>:
void Timer::init() {
    8020174e:	1101                	addi	sp,sp,-32
    80201750:	ec06                	sd	ra,24(sp)
    80201752:	e822                	sd	s0,16(sp)
    80201754:	e426                	sd	s1,8(sp)
    80201756:	1000                	addi	s0,sp,32
    80201758:	84aa                	mv	s1,a0
  spinLock.init("timer");
    8020175a:	00009597          	auipc	a1,0x9
    8020175e:	e3e58593          	addi	a1,a1,-450 # 8020a598 <_ZL6digits+0x290>
    80201762:	0521                	addi	a0,a0,8
    80201764:	fffff097          	auipc	ra,0xfffff
    80201768:	692080e7          	jalr	1682(ra) # 80200df6 <_ZN8SpinLock4initEPKc>
  setTimeout();
    8020176c:	8526                	mv	a0,s1
    8020176e:	00000097          	auipc	ra,0x0
    80201772:	fba080e7          	jalr	-70(ra) # 80201728 <_ZN5Timer10setTimeoutEv>
}
    80201776:	60e2                	ld	ra,24(sp)
    80201778:	6442                	ld	s0,16(sp)
    8020177a:	64a2                	ld	s1,8(sp)
    8020177c:	6105                	addi	sp,sp,32
    8020177e:	8082                	ret

0000000080201780 <_ZN5Timer10handleIntrEv>:

void Timer::handleIntr() {
    80201780:	1101                	addi	sp,sp,-32
    80201782:	ec06                	sd	ra,24(sp)
    80201784:	e822                	sd	s0,16(sp)
    80201786:	e426                	sd	s1,8(sp)
    80201788:	e04a                	sd	s2,0(sp)
    8020178a:	1000                	addi	s0,sp,32
    8020178c:	84aa                	mv	s1,a0
  this->spinLock.lock();
    8020178e:	00850913          	addi	s2,a0,8
    80201792:	854a                	mv	a0,s2
    80201794:	fffff097          	auipc	ra,0xfffff
    80201798:	6b8080e7          	jalr	1720(ra) # 80200e4c <_ZN8SpinLock4lockEv>
  this->ticks++;
    8020179c:	409c                	lw	a5,0(s1)
    8020179e:	2785                	addiw	a5,a5,1
    802017a0:	c09c                	sw	a5,0(s1)
  this->spinLock.unlock();
    802017a2:	854a                	mv	a0,s2
    802017a4:	fffff097          	auipc	ra,0xfffff
    802017a8:	724080e7          	jalr	1828(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
  setTimeout();
    802017ac:	8526                	mv	a0,s1
    802017ae:	00000097          	auipc	ra,0x0
    802017b2:	f7a080e7          	jalr	-134(ra) # 80201728 <_ZN5Timer10setTimeoutEv>
    802017b6:	60e2                	ld	ra,24(sp)
    802017b8:	6442                	ld	s0,16(sp)
    802017ba:	64a2                	ld	s1,8(sp)
    802017bc:	6902                	ld	s2,0(sp)
    802017be:	6105                	addi	sp,sp,32
    802017c0:	8082                	ret

00000000802017c2 <_Z13initTaskTablev>:
extern char trampoline[];  // trampoline.S

alignas(4096) char stack[PGSIZE * 2 * (NTASK + 1)];

// 初始化任务表
void initTaskTable() {
    802017c2:	7139                	addi	sp,sp,-64
    802017c4:	fc06                	sd	ra,56(sp)
    802017c6:	f822                	sd	s0,48(sp)
    802017c8:	f426                	sd	s1,40(sp)
    802017ca:	f04a                	sd	s2,32(sp)
    802017cc:	ec4e                	sd	s3,24(sp)
    802017ce:	e852                	sd	s4,16(sp)
    802017d0:	e456                	sd	s5,8(sp)
    802017d2:	e05a                	sd	s6,0(sp)
    802017d4:	0080                	addi	s0,sp,64
  Task *task;
  for (int i = 0; i < NTASK; i++) {
    802017d6:	00088497          	auipc	s1,0x88
    802017da:	82a48493          	addi	s1,s1,-2006 # 80289000 <taskTable>
    802017de:	00022997          	auipc	s3,0x22
    802017e2:	82298993          	addi	s3,s3,-2014 # 80223000 <stack>
    802017e6:	4901                	li	s2,0
    task = &taskTable[i];
    task->lock.init("task");
    802017e8:	00009b17          	auipc	s6,0x9
    802017ec:	db8b0b13          	addi	s6,s6,-584 # 8020a5a0 <_ZL6digits+0x298>
    802017f0:	6a85                	lui	s5,0x1
  for (int i = 0; i < NTASK; i++) {
    802017f2:	03200a13          	li	s4,50
    task->lock.init("task");
    802017f6:	85da                	mv	a1,s6
    802017f8:	8526                	mv	a0,s1
    802017fa:	fffff097          	auipc	ra,0xfffff
    802017fe:	5fc080e7          	jalr	1532(ra) # 80200df6 <_ZN8SpinLock4initEPKc>
    task->pid = i;
    80201802:	0324ac23          	sw	s2,56(s1)
    // task->kstack = (uint64_t) kalloc();
    task->kstack = (uint64_t)(stack + PGSIZE * i);
    80201806:	0d34bc23          	sd	s3,216(s1)
    task->trapframe = 0;
    8020180a:	0404b023          	sd	zero,64(s1)
    task->state = UNUSED;
    8020180e:	0004ac23          	sw	zero,24(s1)
    task->killed = 0;
    80201812:	0204a823          	sw	zero,48(s1)
    task->xstate = 0;
    80201816:	0204aa23          	sw	zero,52(s1)
    task->sz = 0;
    8020181a:	1604a023          	sw	zero,352(s1)
    memset(task->currentDir, 0, MAXPATH);
    8020181e:	04000613          	li	a2,64
    80201822:	4581                	li	a1,0
    80201824:	09048513          	addi	a0,s1,144
    80201828:	fffff097          	auipc	ra,0xfffff
    8020182c:	334080e7          	jalr	820(ra) # 80200b5c <_Z6memsetPvij>
    memset(task->openFiles, 0, sizeof(struct file *) * NOFILE);
    80201830:	04000613          	li	a2,64
    80201834:	4581                	li	a1,0
    80201836:	05048513          	addi	a0,s1,80
    8020183a:	fffff097          	auipc	ra,0xfffff
    8020183e:	322080e7          	jalr	802(ra) # 80200b5c <_Z6memsetPvij>
  for (int i = 0; i < NTASK; i++) {
    80201842:	2905                	addiw	s2,s2,1
    80201844:	16848493          	addi	s1,s1,360
    80201848:	99d6                	add	s3,s3,s5
    8020184a:	fb4916e3          	bne	s2,s4,802017f6 <_Z13initTaskTablev+0x34>
  }
}
    8020184e:	70e2                	ld	ra,56(sp)
    80201850:	7442                	ld	s0,48(sp)
    80201852:	74a2                	ld	s1,40(sp)
    80201854:	7902                	ld	s2,32(sp)
    80201856:	69e2                	ld	s3,24(sp)
    80201858:	6a42                	ld	s4,16(sp)
    8020185a:	6aa2                	ld	s5,8(sp)
    8020185c:	6b02                	ld	s6,0(sp)
    8020185e:	6121                	addi	sp,sp,64
    80201860:	8082                	ret

0000000080201862 <_Z13taskPagetableP4Task>:
 * 创建一个进程可以使用的pagetable, 只映射了trampoline页,
 * 用于进入和离开内核空间
 *
 * @return
 */
pagetable_t taskPagetable(Task *task) {
    80201862:	1101                	addi	sp,sp,-32
    80201864:	ec06                	sd	ra,24(sp)
    80201866:	e822                	sd	s0,16(sp)
    80201868:	e426                	sd	s1,8(sp)
    8020186a:	e04a                	sd	s2,0(sp)
    8020186c:	1000                	addi	s0,sp,32
    8020186e:	892a                	mv	s2,a0
  pagetable_t pagetable;

  // 创建一个空的页表
  pagetable = userCreate();
    80201870:	00006097          	auipc	ra,0x6
    80201874:	83c080e7          	jalr	-1988(ra) # 802070ac <_Z10userCreatev>
    80201878:	84aa                	mv	s1,a0
  if (pagetable == 0) return 0;
    8020187a:	c131                	beqz	a0,802018be <_Z13taskPagetableP4Task+0x5c>

  // 映射trampoline代码(用于系统调用)到虚拟地址的顶端
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64_t)trampoline, PTE_R | PTE_X) < 0) {
    8020187c:	4729                	li	a4,10
    8020187e:	00006697          	auipc	a3,0x6
    80201882:	78268693          	addi	a3,a3,1922 # 80208000 <trampoline>
    80201886:	6605                	lui	a2,0x1
    80201888:	040005b7          	lui	a1,0x4000
    8020188c:	15fd                	addi	a1,a1,-1
    8020188e:	05b2                	slli	a1,a1,0xc
    80201890:	00005097          	auipc	ra,0x5
    80201894:	57e080e7          	jalr	1406(ra) # 80206e0e <_Z8mappagesPmmmmi>
    80201898:	02054a63          	bltz	a0,802018cc <_Z13taskPagetableP4Task+0x6a>
    // TODO 失败释放内存
    return 0;
  }
  // 将进程的trapframe映射到TRAPFRAME, TRAMPOLINE的低位一页
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64_t)(task->trapframe), PTE_R | PTE_W) < 0) {
    8020189c:	4719                	li	a4,6
    8020189e:	04093683          	ld	a3,64(s2) # 1040 <_entry-0x801fefc0>
    802018a2:	6605                	lui	a2,0x1
    802018a4:	020005b7          	lui	a1,0x2000
    802018a8:	15fd                	addi	a1,a1,-1
    802018aa:	05b6                	slli	a1,a1,0xd
    802018ac:	8526                	mv	a0,s1
    802018ae:	00005097          	auipc	ra,0x5
    802018b2:	560080e7          	jalr	1376(ra) # 80206e0e <_Z8mappagesPmmmmi>
    //        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    //        uvmfree(pagetable, 0);
    return 0;
    802018b6:	fff54513          	not	a0,a0
    802018ba:	957d                	srai	a0,a0,0x3f
    802018bc:	8ce9                	and	s1,s1,a0
  }
  return pagetable;
}
    802018be:	8526                	mv	a0,s1
    802018c0:	60e2                	ld	ra,24(sp)
    802018c2:	6442                	ld	s0,16(sp)
    802018c4:	64a2                	ld	s1,8(sp)
    802018c6:	6902                	ld	s2,0(sp)
    802018c8:	6105                	addi	sp,sp,32
    802018ca:	8082                	ret
    return 0;
    802018cc:	4481                	li	s1,0
    802018ce:	bfc5                	j	802018be <_Z13taskPagetableP4Task+0x5c>

00000000802018d0 <_Z9allocTaskv>:
Task *allocTask() {
    802018d0:	1101                	addi	sp,sp,-32
    802018d2:	ec06                	sd	ra,24(sp)
    802018d4:	e822                	sd	s0,16(sp)
    802018d6:	e426                	sd	s1,8(sp)
    802018d8:	e04a                	sd	s2,0(sp)
    802018da:	1000                	addi	s0,sp,32
  for (task = taskTable; task < &taskTable[NTASK]; task++) {
    802018dc:	00087497          	auipc	s1,0x87
    802018e0:	72448493          	addi	s1,s1,1828 # 80289000 <taskTable>
    802018e4:	0008c917          	auipc	s2,0x8c
    802018e8:	d6c90913          	addi	s2,s2,-660 # 8028d650 <initTask>
    task->lock.lock();
    802018ec:	8526                	mv	a0,s1
    802018ee:	fffff097          	auipc	ra,0xfffff
    802018f2:	55e080e7          	jalr	1374(ra) # 80200e4c <_ZN8SpinLock4lockEv>
    if (task->state == UNUSED) {
    802018f6:	4c9c                	lw	a5,24(s1)
    802018f8:	cf81                	beqz	a5,80201910 <_Z9allocTaskv+0x40>
      task->lock.unlock();
    802018fa:	8526                	mv	a0,s1
    802018fc:	fffff097          	auipc	ra,0xfffff
    80201900:	5cc080e7          	jalr	1484(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
  for (task = taskTable; task < &taskTable[NTASK]; task++) {
    80201904:	16848493          	addi	s1,s1,360
    80201908:	ff2492e3          	bne	s1,s2,802018ec <_Z9allocTaskv+0x1c>
  return 0;
    8020190c:	4481                	li	s1,0
    8020190e:	a08d                	j	80201970 <_Z9allocTaskv+0xa0>
  if ((task->trapframe = (struct trapframe *)memAllocator.alloc()) == 0) {
    80201910:	00012517          	auipc	a0,0x12
    80201914:	79050513          	addi	a0,a0,1936 # 802140a0 <memAllocator>
    80201918:	00006097          	auipc	ra,0x6
    8020191c:	c22080e7          	jalr	-990(ra) # 8020753a <_ZN12MemAllocator5allocEv>
    80201920:	892a                	mv	s2,a0
    80201922:	e0a8                	sd	a0,64(s1)
    80201924:	cd29                	beqz	a0,8020197e <_Z9allocTaskv+0xae>
  task->pagetable = taskPagetable(task);
    80201926:	8526                	mv	a0,s1
    80201928:	00000097          	auipc	ra,0x0
    8020192c:	f3a080e7          	jalr	-198(ra) # 80201862 <_Z13taskPagetableP4Task>
    80201930:	e4a8                	sd	a0,72(s1)
  memset(&task->context, 0, sizeof(task->context));
    80201932:	07000613          	li	a2,112
    80201936:	4581                	li	a1,0
    80201938:	0e048513          	addi	a0,s1,224
    8020193c:	fffff097          	auipc	ra,0xfffff
    80201940:	220080e7          	jalr	544(ra) # 80200b5c <_Z6memsetPvij>
  memset(task->trapframe, 0, sizeof(*task->trapframe));
    80201944:	12000613          	li	a2,288
    80201948:	4581                	li	a1,0
    8020194a:	60a8                	ld	a0,64(s1)
    8020194c:	fffff097          	auipc	ra,0xfffff
    80201950:	210080e7          	jalr	528(ra) # 80200b5c <_Z6memsetPvij>
  task->context.sp = task->kstack + PGSIZE;
    80201954:	6cfc                	ld	a5,216(s1)
    80201956:	6705                	lui	a4,0x1
    80201958:	97ba                	add	a5,a5,a4
    8020195a:	f4fc                	sd	a5,232(s1)
  task->context.ra = (uint64_t)forkret;
    8020195c:	00000797          	auipc	a5,0x0
    80201960:	0e078793          	addi	a5,a5,224 # 80201a3c <_Z7forkretv>
    80201964:	f0fc                	sd	a5,224(s1)
  task->lock.unlock();
    80201966:	8526                	mv	a0,s1
    80201968:	fffff097          	auipc	ra,0xfffff
    8020196c:	560080e7          	jalr	1376(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
}
    80201970:	8526                	mv	a0,s1
    80201972:	60e2                	ld	ra,24(sp)
    80201974:	6442                	ld	s0,16(sp)
    80201976:	64a2                	ld	s1,8(sp)
    80201978:	6902                	ld	s2,0(sp)
    8020197a:	6105                	addi	sp,sp,32
    8020197c:	8082                	ret
    task->lock.unlock();
    8020197e:	8526                	mv	a0,s1
    80201980:	fffff097          	auipc	ra,0xfffff
    80201984:	548080e7          	jalr	1352(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
    return 0;
    80201988:	84ca                	mv	s1,s2
    8020198a:	b7dd                	j	80201970 <_Z9allocTaskv+0xa0>

000000008020198c <_Z13initFirstTaskv>:
void initFirstTask() {
    8020198c:	1101                	addi	sp,sp,-32
    8020198e:	ec06                	sd	ra,24(sp)
    80201990:	e822                	sd	s0,16(sp)
    80201992:	e426                	sd	s1,8(sp)
    80201994:	1000                	addi	s0,sp,32
  Task *task = allocTask();
    80201996:	00000097          	auipc	ra,0x0
    8020199a:	f3a080e7          	jalr	-198(ra) # 802018d0 <_Z9allocTaskv>
    8020199e:	84aa                	mv	s1,a0
  user_vm_init(task->pagetable, initcode, sizeof(initcode));
    802019a0:	03400613          	li	a2,52
    802019a4:	00009597          	auipc	a1,0x9
    802019a8:	65c58593          	addi	a1,a1,1628 # 8020b000 <initcode>
    802019ac:	6528                	ld	a0,72(a0)
    802019ae:	00005097          	auipc	ra,0x5
    802019b2:	734080e7          	jalr	1844(ra) # 802070e2 <_Z12user_vm_initPmPhj>
  task->sz = PGSIZE;
    802019b6:	6785                	lui	a5,0x1
    802019b8:	16f4a023          	sw	a5,352(s1)
  task->trapframe->epc = 0;
    802019bc:	60bc                	ld	a5,64(s1)
    802019be:	0007bc23          	sd	zero,24(a5) # 1018 <_entry-0x801fefe8>
  task->trapframe->sp = PGSIZE;
    802019c2:	60bc                	ld	a5,64(s1)
    802019c4:	6705                	lui	a4,0x1
    802019c6:	fb98                	sd	a4,48(a5)
  memmove(task->name, "initcode", sizeof(task->name));
    802019c8:	4641                	li	a2,16
    802019ca:	00009597          	auipc	a1,0x9
    802019ce:	bde58593          	addi	a1,a1,-1058 # 8020a5a8 <_ZL6digits+0x2a0>
    802019d2:	15048513          	addi	a0,s1,336
    802019d6:	fffff097          	auipc	ra,0xfffff
    802019da:	1e0080e7          	jalr	480(ra) # 80200bb6 <_Z7memmovePvPKvj>
  task->currentDir[0] = '/';
    802019de:	02f00793          	li	a5,47
    802019e2:	08f48823          	sb	a5,144(s1)
  task->state = RUNNABLE;
    802019e6:	4789                	li	a5,2
    802019e8:	cc9c                	sw	a5,24(s1)
  initTask = task;
    802019ea:	0008c797          	auipc	a5,0x8c
    802019ee:	c697b323          	sd	s1,-922(a5) # 8028d650 <initTask>
  printf("over");
    802019f2:	00009517          	auipc	a0,0x9
    802019f6:	bc650513          	addi	a0,a0,-1082 # 8020a5b8 <_ZL6digits+0x2b0>
    802019fa:	fffff097          	auipc	ra,0xfffff
    802019fe:	e5a080e7          	jalr	-422(ra) # 80200854 <_Z6printfPKcz>
}
    80201a02:	60e2                	ld	ra,24(sp)
    80201a04:	6442                	ld	s0,16(sp)
    80201a06:	64a2                	ld	s1,8(sp)
    80201a08:	6105                	addi	sp,sp,32
    80201a0a:	8082                	ret

0000000080201a0c <_Z6myTaskv>:
    }
  }
}

// 获取当前进程
Task *myTask() {
    80201a0c:	1101                	addi	sp,sp,-32
    80201a0e:	ec06                	sd	ra,24(sp)
    80201a10:	e822                	sd	s0,16(sp)
    80201a12:	e426                	sd	s1,8(sp)
    80201a14:	1000                	addi	s0,sp,32
  Intr::push_off();
    80201a16:	00002097          	auipc	ra,0x2
    80201a1a:	a22080e7          	jalr	-1502(ra) # 80203438 <_ZN4Intr8push_offEv>
  Task *task = Cpu::mycpu()->task;
    80201a1e:	fffff097          	auipc	ra,0xfffff
    80201a22:	54a080e7          	jalr	1354(ra) # 80200f68 <_ZN3Cpu5mycpuEv>
    80201a26:	6104                	ld	s1,0(a0)
  Intr::pop_off();
    80201a28:	00002097          	auipc	ra,0x2
    80201a2c:	a5e080e7          	jalr	-1442(ra) # 80203486 <_ZN4Intr7pop_offEv>
  return task;
}
    80201a30:	8526                	mv	a0,s1
    80201a32:	60e2                	ld	ra,24(sp)
    80201a34:	6442                	ld	s0,16(sp)
    80201a36:	64a2                	ld	s1,8(sp)
    80201a38:	6105                	addi	sp,sp,32
    80201a3a:	8082                	ret

0000000080201a3c <_Z7forkretv>:
void forkret(void) {
    80201a3c:	7175                	addi	sp,sp,-144
    80201a3e:	e506                	sd	ra,136(sp)
    80201a40:	e122                	sd	s0,128(sp)
    80201a42:	fca6                	sd	s1,120(sp)
    80201a44:	0900                	addi	s0,sp,144
  myTask()->lock.unlock();
    80201a46:	00000097          	auipc	ra,0x0
    80201a4a:	fc6080e7          	jalr	-58(ra) # 80201a0c <_Z6myTaskv>
    80201a4e:	fffff097          	auipc	ra,0xfffff
    80201a52:	47a080e7          	jalr	1146(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
  if (first) {
    80201a56:	00009797          	auipc	a5,0x9
    80201a5a:	61a7a783          	lw	a5,1562(a5) # 8020b070 <_ZZ7forkretvE5first>
    80201a5e:	cbd9                	beqz	a5,80201af4 <_Z7forkretv+0xb8>
    first = 0;
    80201a60:	00009797          	auipc	a5,0x9
    80201a64:	6007a823          	sw	zero,1552(a5) # 8020b070 <_ZZ7forkretvE5first>
    vfs::init();
    80201a68:	00005097          	auipc	ra,0x5
    80201a6c:	c24080e7          	jalr	-988(ra) # 8020668c <_ZN3vfs4initEv>
    memset(buf, 0, 100);
    80201a70:	06400613          	li	a2,100
    80201a74:	4581                	li	a1,0
    80201a76:	f7840513          	addi	a0,s0,-136
    80201a7a:	fffff097          	auipc	ra,0xfffff
    80201a7e:	0e2080e7          	jalr	226(ra) # 80200b5c <_Z6memsetPvij>
    int fd = vfs::open("/bin", O_RDONLY);
    80201a82:	4581                	li	a1,0
    80201a84:	00009517          	auipc	a0,0x9
    80201a88:	b3c50513          	addi	a0,a0,-1220 # 8020a5c0 <_ZL6digits+0x2b8>
    80201a8c:	00004097          	auipc	ra,0x4
    80201a90:	59e080e7          	jalr	1438(ra) # 8020602a <_ZN3vfs4openEPKcm>
    vfs::ls(fd, buf, false);
    80201a94:	4601                	li	a2,0
    80201a96:	f7840593          	addi	a1,s0,-136
    80201a9a:	00005097          	auipc	ra,0x5
    80201a9e:	a9c080e7          	jalr	-1380(ra) # 80206536 <_ZN3vfs2lsEiPcb>
    80201aa2:	00009717          	auipc	a4,0x9
    80201aa6:	b2670713          	addi	a4,a4,-1242 # 8020a5c8 <_ZL6digits+0x2c0>
    80201aaa:	07200693          	li	a3,114
    80201aae:	00009617          	auipc	a2,0x9
    80201ab2:	b2260613          	addi	a2,a2,-1246 # 8020a5d0 <_ZL6digits+0x2c8>
    80201ab6:	00008597          	auipc	a1,0x8
    80201aba:	6c258593          	addi	a1,a1,1730 # 8020a178 <rodata_start+0x178>
    80201abe:	00008517          	auipc	a0,0x8
    80201ac2:	6c250513          	addi	a0,a0,1730 # 8020a180 <rodata_start+0x180>
    80201ac6:	fffff097          	auipc	ra,0xfffff
    80201aca:	d8e080e7          	jalr	-626(ra) # 80200854 <_Z6printfPKcz>
    LOG_DEBUG("name=%s",dt->d_name);
    80201ace:	f8b40593          	addi	a1,s0,-117
    80201ad2:	00009517          	auipc	a0,0x9
    80201ad6:	b1650513          	addi	a0,a0,-1258 # 8020a5e8 <_ZL6digits+0x2e0>
    80201ada:	fffff097          	auipc	ra,0xfffff
    80201ade:	d7a080e7          	jalr	-646(ra) # 80200854 <_Z6printfPKcz>
    80201ae2:	00008517          	auipc	a0,0x8
    80201ae6:	5be50513          	addi	a0,a0,1470 # 8020a0a0 <rodata_start+0xa0>
    80201aea:	fffff097          	auipc	ra,0xfffff
    80201aee:	d6a080e7          	jalr	-662(ra) # 80200854 <_Z6printfPKcz>
    while(1);
    80201af2:	a001                	j	80201af2 <_Z7forkretv+0xb6>
    80201af4:	00009717          	auipc	a4,0x9
    80201af8:	ad470713          	addi	a4,a4,-1324 # 8020a5c8 <_ZL6digits+0x2c0>
    80201afc:	08300693          	li	a3,131
    80201b00:	00009617          	auipc	a2,0x9
    80201b04:	ad060613          	addi	a2,a2,-1328 # 8020a5d0 <_ZL6digits+0x2c8>
    80201b08:	00008597          	auipc	a1,0x8
    80201b0c:	67058593          	addi	a1,a1,1648 # 8020a178 <rodata_start+0x178>
    80201b10:	00008517          	auipc	a0,0x8
    80201b14:	67050513          	addi	a0,a0,1648 # 8020a180 <rodata_start+0x180>
    80201b18:	fffff097          	auipc	ra,0xfffff
    80201b1c:	d3c080e7          	jalr	-708(ra) # 80200854 <_Z6printfPKcz>
  LOG_DEBUG("cpuid=%d task=%p", Cpu::cpuid(), Cpu::mycpu()->task);
    80201b20:	fffff097          	auipc	ra,0xfffff
    80201b24:	438080e7          	jalr	1080(ra) # 80200f58 <_ZN3Cpu5cpuidEv>
    80201b28:	84aa                	mv	s1,a0
    80201b2a:	fffff097          	auipc	ra,0xfffff
    80201b2e:	43e080e7          	jalr	1086(ra) # 80200f68 <_ZN3Cpu5mycpuEv>
    80201b32:	6110                	ld	a2,0(a0)
    80201b34:	85a6                	mv	a1,s1
    80201b36:	00009517          	auipc	a0,0x9
    80201b3a:	aba50513          	addi	a0,a0,-1350 # 8020a5f0 <_ZL6digits+0x2e8>
    80201b3e:	fffff097          	auipc	ra,0xfffff
    80201b42:	d16080e7          	jalr	-746(ra) # 80200854 <_Z6printfPKcz>
    80201b46:	00008517          	auipc	a0,0x8
    80201b4a:	55a50513          	addi	a0,a0,1370 # 8020a0a0 <rodata_start+0xa0>
    80201b4e:	fffff097          	auipc	ra,0xfffff
    80201b52:	d06080e7          	jalr	-762(ra) # 80200854 <_Z6printfPKcz>
  usertrapret();
    80201b56:	fffff097          	auipc	ra,0xfffff
    80201b5a:	48a080e7          	jalr	1162(ra) # 80200fe0 <_Z11usertrapretv>
}
    80201b5e:	60aa                	ld	ra,136(sp)
    80201b60:	640a                	ld	s0,128(sp)
    80201b62:	74e6                	ld	s1,120(sp)
    80201b64:	6149                	addi	sp,sp,144
    80201b66:	8082                	ret

0000000080201b68 <_Z12prepareSchedv>:
    task->lock.unlock();
    lock->lock();
  }
}

void prepareSched() {
    80201b68:	1101                	addi	sp,sp,-32
    80201b6a:	ec06                	sd	ra,24(sp)
    80201b6c:	e822                	sd	s0,16(sp)
    80201b6e:	e426                	sd	s1,8(sp)
    80201b70:	e04a                	sd	s2,0(sp)
    80201b72:	1000                	addi	s0,sp,32
  int intr_enable;
  Task *task = myTask();
    80201b74:	00000097          	auipc	ra,0x0
    80201b78:	e98080e7          	jalr	-360(ra) # 80201a0c <_Z6myTaskv>
    80201b7c:	84aa                	mv	s1,a0

  if (!task->lock.holding()) panic("sched p->lock");
    80201b7e:	fffff097          	auipc	ra,0xfffff
    80201b82:	29e080e7          	jalr	670(ra) # 80200e1c <_ZN8SpinLock7holdingEv>
    80201b86:	cd39                	beqz	a0,80201be4 <_Z12prepareSchedv+0x7c>
  if (Cpu::mycpu()->noff != 1) panic("sched locks");
    80201b88:	fffff097          	auipc	ra,0xfffff
    80201b8c:	3e0080e7          	jalr	992(ra) # 80200f68 <_ZN3Cpu5mycpuEv>
    80201b90:	5d38                	lw	a4,120(a0)
    80201b92:	4785                	li	a5,1
    80201b94:	06f71163          	bne	a4,a5,80201bf6 <_Z12prepareSchedv+0x8e>
  if (task->state == RUNNING) panic("sched running");
    80201b98:	4c98                	lw	a4,24(s1)
    80201b9a:	478d                	li	a5,3
    80201b9c:	06f70663          	beq	a4,a5,80201c08 <_Z12prepareSchedv+0xa0>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80201ba0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80201ba4:	8b89                	andi	a5,a5,2
  if (intr_get()) panic("sched interruptible");
    80201ba6:	ebb5                	bnez	a5,80201c1a <_Z12prepareSchedv+0xb2>

  intr_enable = Cpu::mycpu()->intr_enable;
    80201ba8:	fffff097          	auipc	ra,0xfffff
    80201bac:	3c0080e7          	jalr	960(ra) # 80200f68 <_ZN3Cpu5mycpuEv>
    80201bb0:	07c54903          	lbu	s2,124(a0)
  // LOG_INFO("enter switch cpuid=%d task=%p gp=%d", Cpu::cpuid(), Cpu::mycpu()->task, r_gp());
  pswitch(&task->context, &Cpu::mycpu()->context);
    80201bb4:	fffff097          	auipc	ra,0xfffff
    80201bb8:	3b4080e7          	jalr	948(ra) # 80200f68 <_ZN3Cpu5mycpuEv>
    80201bbc:	00850593          	addi	a1,a0,8
    80201bc0:	0e048513          	addi	a0,s1,224
    80201bc4:	00001097          	auipc	ra,0x1
    80201bc8:	a90080e7          	jalr	-1392(ra) # 80202654 <pswitch>
  // LOG_INFO("leave switch cpuid=%d task=%p gp=%d", Cpu::cpuid(), Cpu::mycpu()->task, r_gp());
  // LOG_DEBUG("epc=%p", myTask()->trapframe->epc);
  Cpu::mycpu()->intr_enable = intr_enable;
    80201bcc:	fffff097          	auipc	ra,0xfffff
    80201bd0:	39c080e7          	jalr	924(ra) # 80200f68 <_ZN3Cpu5mycpuEv>
    80201bd4:	07250e23          	sb	s2,124(a0)
}
    80201bd8:	60e2                	ld	ra,24(sp)
    80201bda:	6442                	ld	s0,16(sp)
    80201bdc:	64a2                	ld	s1,8(sp)
    80201bde:	6902                	ld	s2,0(sp)
    80201be0:	6105                	addi	sp,sp,32
    80201be2:	8082                	ret
  if (!task->lock.holding()) panic("sched p->lock");
    80201be4:	00009517          	auipc	a0,0x9
    80201be8:	a2450513          	addi	a0,a0,-1500 # 8020a608 <_ZL6digits+0x300>
    80201bec:	fffff097          	auipc	ra,0xfffff
    80201bf0:	bf6080e7          	jalr	-1034(ra) # 802007e2 <_Z5panicPKc>
    80201bf4:	bf51                	j	80201b88 <_Z12prepareSchedv+0x20>
  if (Cpu::mycpu()->noff != 1) panic("sched locks");
    80201bf6:	00009517          	auipc	a0,0x9
    80201bfa:	a2250513          	addi	a0,a0,-1502 # 8020a618 <_ZL6digits+0x310>
    80201bfe:	fffff097          	auipc	ra,0xfffff
    80201c02:	be4080e7          	jalr	-1052(ra) # 802007e2 <_Z5panicPKc>
    80201c06:	bf49                	j	80201b98 <_Z12prepareSchedv+0x30>
  if (task->state == RUNNING) panic("sched running");
    80201c08:	00009517          	auipc	a0,0x9
    80201c0c:	a2050513          	addi	a0,a0,-1504 # 8020a628 <_ZL6digits+0x320>
    80201c10:	fffff097          	auipc	ra,0xfffff
    80201c14:	bd2080e7          	jalr	-1070(ra) # 802007e2 <_Z5panicPKc>
    80201c18:	b761                	j	80201ba0 <_Z12prepareSchedv+0x38>
  if (intr_get()) panic("sched interruptible");
    80201c1a:	00009517          	auipc	a0,0x9
    80201c1e:	a1e50513          	addi	a0,a0,-1506 # 8020a638 <_ZL6digits+0x330>
    80201c22:	fffff097          	auipc	ra,0xfffff
    80201c26:	bc0080e7          	jalr	-1088(ra) # 802007e2 <_Z5panicPKc>
    80201c2a:	bfbd                	j	80201ba8 <_Z12prepareSchedv+0x40>

0000000080201c2c <_Z5sleepPvP8SpinLock>:
void sleep(void *chan, SpinLock *lock) {
    80201c2c:	7179                	addi	sp,sp,-48
    80201c2e:	f406                	sd	ra,40(sp)
    80201c30:	f022                	sd	s0,32(sp)
    80201c32:	ec26                	sd	s1,24(sp)
    80201c34:	e84a                	sd	s2,16(sp)
    80201c36:	e44e                	sd	s3,8(sp)
    80201c38:	1800                	addi	s0,sp,48
    80201c3a:	89aa                	mv	s3,a0
    80201c3c:	892e                	mv	s2,a1
  Task *task = myTask();
    80201c3e:	00000097          	auipc	ra,0x0
    80201c42:	dce080e7          	jalr	-562(ra) # 80201a0c <_Z6myTaskv>
    80201c46:	84aa                	mv	s1,a0
  if (lock != &task->lock) {  // DOC: sleeplock0
    80201c48:	05250663          	beq	a0,s2,80201c94 <_Z5sleepPvP8SpinLock+0x68>
    task->lock.lock();        // DOC: sleeplock1
    80201c4c:	fffff097          	auipc	ra,0xfffff
    80201c50:	200080e7          	jalr	512(ra) # 80200e4c <_ZN8SpinLock4lockEv>
    lock->unlock();
    80201c54:	854a                	mv	a0,s2
    80201c56:	fffff097          	auipc	ra,0xfffff
    80201c5a:	272080e7          	jalr	626(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
  task->chan = chan;
    80201c5e:	0334b423          	sd	s3,40(s1)
  task->state = SLEEPING;
    80201c62:	4785                	li	a5,1
    80201c64:	cc9c                	sw	a5,24(s1)
  prepareSched();
    80201c66:	00000097          	auipc	ra,0x0
    80201c6a:	f02080e7          	jalr	-254(ra) # 80201b68 <_Z12prepareSchedv>
  task->chan = 0;
    80201c6e:	0204b423          	sd	zero,40(s1)
    task->lock.unlock();
    80201c72:	8526                	mv	a0,s1
    80201c74:	fffff097          	auipc	ra,0xfffff
    80201c78:	254080e7          	jalr	596(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
    lock->lock();
    80201c7c:	854a                	mv	a0,s2
    80201c7e:	fffff097          	auipc	ra,0xfffff
    80201c82:	1ce080e7          	jalr	462(ra) # 80200e4c <_ZN8SpinLock4lockEv>
}
    80201c86:	70a2                	ld	ra,40(sp)
    80201c88:	7402                	ld	s0,32(sp)
    80201c8a:	64e2                	ld	s1,24(sp)
    80201c8c:	6942                	ld	s2,16(sp)
    80201c8e:	69a2                	ld	s3,8(sp)
    80201c90:	6145                	addi	sp,sp,48
    80201c92:	8082                	ret
  task->chan = chan;
    80201c94:	03353423          	sd	s3,40(a0)
  task->state = SLEEPING;
    80201c98:	4785                	li	a5,1
    80201c9a:	cd1c                	sw	a5,24(a0)
  prepareSched();
    80201c9c:	00000097          	auipc	ra,0x0
    80201ca0:	ecc080e7          	jalr	-308(ra) # 80201b68 <_Z12prepareSchedv>
  task->chan = 0;
    80201ca4:	0204b423          	sd	zero,40(s1)
  if (lock != &task->lock) {
    80201ca8:	bff9                	j	80201c86 <_Z5sleepPvP8SpinLock+0x5a>

0000000080201caa <_Z9sleepTimem>:

// 睡眠一定时间
void sleepTime(uint64_t sleep_ticks) {
    80201caa:	7179                	addi	sp,sp,-48
    80201cac:	f406                	sd	ra,40(sp)
    80201cae:	f022                	sd	s0,32(sp)
    80201cb0:	ec26                	sd	s1,24(sp)
    80201cb2:	e84a                	sd	s2,16(sp)
    80201cb4:	e44e                	sd	s3,8(sp)
    80201cb6:	e052                	sd	s4,0(sp)
    80201cb8:	1800                	addi	s0,sp,48
    80201cba:	892a                	mv	s2,a0
  uint64_t now = timer.ticks;
    80201cbc:	00012497          	auipc	s1,0x12
    80201cc0:	40448493          	addi	s1,s1,1028 # 802140c0 <timer>
    80201cc4:	0004a983          	lw	s3,0(s1)
  timer.spinLock.lock();
    80201cc8:	00012517          	auipc	a0,0x12
    80201ccc:	40050513          	addi	a0,a0,1024 # 802140c8 <timer+0x8>
    80201cd0:	fffff097          	auipc	ra,0xfffff
    80201cd4:	17c080e7          	jalr	380(ra) # 80200e4c <_ZN8SpinLock4lockEv>
  for (; timer.ticks - now < sleep_ticks;) {
    80201cd8:	409c                	lw	a5,0(s1)
    80201cda:	413787b3          	sub	a5,a5,s3
    80201cde:	0327f163          	bgeu	a5,s2,80201d00 <_Z9sleepTimem+0x56>
    sleep(&timer.ticks, &timer.spinLock);
    80201ce2:	00012a17          	auipc	s4,0x12
    80201ce6:	3e6a0a13          	addi	s4,s4,998 # 802140c8 <timer+0x8>
    80201cea:	85d2                	mv	a1,s4
    80201cec:	8526                	mv	a0,s1
    80201cee:	00000097          	auipc	ra,0x0
    80201cf2:	f3e080e7          	jalr	-194(ra) # 80201c2c <_Z5sleepPvP8SpinLock>
  for (; timer.ticks - now < sleep_ticks;) {
    80201cf6:	409c                	lw	a5,0(s1)
    80201cf8:	413787b3          	sub	a5,a5,s3
    80201cfc:	ff27e7e3          	bltu	a5,s2,80201cea <_Z9sleepTimem+0x40>
  }
  timer.spinLock.unlock();
    80201d00:	00012517          	auipc	a0,0x12
    80201d04:	3c850513          	addi	a0,a0,968 # 802140c8 <timer+0x8>
    80201d08:	fffff097          	auipc	ra,0xfffff
    80201d0c:	1c0080e7          	jalr	448(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
}
    80201d10:	70a2                	ld	ra,40(sp)
    80201d12:	7402                	ld	s0,32(sp)
    80201d14:	64e2                	ld	s1,24(sp)
    80201d16:	6942                	ld	s2,16(sp)
    80201d18:	69a2                	ld	s3,8(sp)
    80201d1a:	6a02                	ld	s4,0(sp)
    80201d1c:	6145                	addi	sp,sp,48
    80201d1e:	8082                	ret

0000000080201d20 <_Z6wakeupPv>:

// 唤醒指定chan上的进程
void wakeup(void *chan) {
    80201d20:	1141                	addi	sp,sp,-16
    80201d22:	e422                	sd	s0,8(sp)
    80201d24:	0800                	addi	s0,sp,16
  Task *task;
  for (task = taskTable; task < &taskTable[NTASK]; task++) {
    80201d26:	00087797          	auipc	a5,0x87
    80201d2a:	2da78793          	addi	a5,a5,730 # 80289000 <taskTable>
    // task->lock.lock();
    if (task->state == SLEEPING && task->chan == chan) {
    80201d2e:	4605                	li	a2,1
      task->state = RUNNABLE;
    80201d30:	4589                	li	a1,2
  for (task = taskTable; task < &taskTable[NTASK]; task++) {
    80201d32:	0008c697          	auipc	a3,0x8c
    80201d36:	91e68693          	addi	a3,a3,-1762 # 8028d650 <initTask>
    80201d3a:	a031                	j	80201d46 <_Z6wakeupPv+0x26>
      task->state = RUNNABLE;
    80201d3c:	cf8c                	sw	a1,24(a5)
  for (task = taskTable; task < &taskTable[NTASK]; task++) {
    80201d3e:	16878793          	addi	a5,a5,360
    80201d42:	00d78963          	beq	a5,a3,80201d54 <_Z6wakeupPv+0x34>
    if (task->state == SLEEPING && task->chan == chan) {
    80201d46:	4f98                	lw	a4,24(a5)
    80201d48:	fec71be3          	bne	a4,a2,80201d3e <_Z6wakeupPv+0x1e>
    80201d4c:	7798                	ld	a4,40(a5)
    80201d4e:	fea718e3          	bne	a4,a0,80201d3e <_Z6wakeupPv+0x1e>
    80201d52:	b7ed                	j	80201d3c <_Z6wakeupPv+0x1c>
    }
    // task->lock.unlock();
  }
}
    80201d54:	6422                	ld	s0,8(sp)
    80201d56:	0141                	addi	sp,sp,16
    80201d58:	8082                	ret

0000000080201d5a <_Z9schedulerv>:
void scheduler() {
    80201d5a:	7159                	addi	sp,sp,-112
    80201d5c:	f486                	sd	ra,104(sp)
    80201d5e:	f0a2                	sd	s0,96(sp)
    80201d60:	eca6                	sd	s1,88(sp)
    80201d62:	e8ca                	sd	s2,80(sp)
    80201d64:	e4ce                	sd	s3,72(sp)
    80201d66:	e0d2                	sd	s4,64(sp)
    80201d68:	fc56                	sd	s5,56(sp)
    80201d6a:	f85a                	sd	s6,48(sp)
    80201d6c:	f45e                	sd	s7,40(sp)
    80201d6e:	f062                	sd	s8,32(sp)
    80201d70:	ec66                	sd	s9,24(sp)
    80201d72:	e86a                	sd	s10,16(sp)
    80201d74:	e46e                	sd	s11,8(sp)
    80201d76:	1880                	addi	s0,sp,112
  Cpu *c = Cpu::mycpu();
    80201d78:	fffff097          	auipc	ra,0xfffff
    80201d7c:	1f0080e7          	jalr	496(ra) # 80200f68 <_ZN3Cpu5mycpuEv>
    80201d80:	8baa                	mv	s7,a0
  c->task = 0;
    80201d82:	00053023          	sd	zero,0(a0)
    80201d86:	0008c997          	auipc	s3,0x8c
    80201d8a:	8ca98993          	addi	s3,s3,-1846 # 8028d650 <initTask>
        wakeup(initTask);
    80201d8e:	0008cd17          	auipc	s10,0x8c
    80201d92:	8c2d0d13          	addi	s10,s10,-1854 # 8028d650 <initTask>
      if (task->state == RUNNABLE) {
    80201d96:	4a89                	li	s5,2
    alive = 0;
    80201d98:	4d81                	li	s11,0
        pswitch(&c->context, &task->context);
    80201d9a:	00850c93          	addi	s9,a0,8
    80201d9e:	a08d                	j	80201e00 <_Z9schedulerv+0xa6>
      task->lock.unlock();
    80201da0:	854a                	mv	a0,s2
    80201da2:	fffff097          	auipc	ra,0xfffff
    80201da6:	126080e7          	jalr	294(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
    for (int i = 0; i < NTASK; i++) {
    80201daa:	16848493          	addi	s1,s1,360
    80201dae:	03348f63          	beq	s1,s3,80201dec <_Z9schedulerv+0x92>
      task = &taskTable[i];
    80201db2:	8926                	mv	s2,s1
      task->lock.lock();
    80201db4:	8526                	mv	a0,s1
    80201db6:	fffff097          	auipc	ra,0xfffff
    80201dba:	096080e7          	jalr	150(ra) # 80200e4c <_ZN8SpinLock4lockEv>
      if (task->state != UNUSED && task->state != ZOMBIE) {
    80201dbe:	4c9c                	lw	a5,24(s1)
    80201dc0:	d3e5                	beqz	a5,80201da0 <_Z9schedulerv+0x46>
    80201dc2:	05678d63          	beq	a5,s6,80201e1c <_Z9schedulerv+0xc2>
        alive++;
    80201dc6:	2a05                	addiw	s4,s4,1
      if (task->state == RUNNABLE) {
    80201dc8:	01892783          	lw	a5,24(s2)
    80201dcc:	fd579ae3          	bne	a5,s5,80201da0 <_Z9schedulerv+0x46>
        task->state = RUNNING;
    80201dd0:	01892c23          	sw	s8,24(s2)
        c->task = task;
    80201dd4:	012bb023          	sd	s2,0(s7)
        pswitch(&c->context, &task->context);
    80201dd8:	0e048593          	addi	a1,s1,224
    80201ddc:	8566                	mv	a0,s9
    80201dde:	00001097          	auipc	ra,0x1
    80201de2:	876080e7          	jalr	-1930(ra) # 80202654 <pswitch>
        c->task = 0;
    80201de6:	000bb023          	sd	zero,0(s7)
    80201dea:	bf5d                	j	80201da0 <_Z9schedulerv+0x46>
    if (alive <= 2) {
    80201dec:	014aca63          	blt	s5,s4,80201e00 <_Z9schedulerv+0xa6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80201df0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80201df4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80201df8:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80201dfc:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80201e00:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80201e04:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80201e08:	10079073          	csrw	sstatus,a5
    for (int i = 0; i < NTASK; i++) {
    80201e0c:	00087497          	auipc	s1,0x87
    80201e10:	1f448493          	addi	s1,s1,500 # 80289000 <taskTable>
    alive = 0;
    80201e14:	8a6e                	mv	s4,s11
      if (task->state != UNUSED && task->state != ZOMBIE) {
    80201e16:	4b11                	li	s6,4
        task->state = RUNNING;
    80201e18:	4c0d                	li	s8,3
    80201e1a:	bf61                	j	80201db2 <_Z9schedulerv+0x58>
        wakeup(initTask);
    80201e1c:	000d3503          	ld	a0,0(s10)
    80201e20:	00000097          	auipc	ra,0x0
    80201e24:	f00080e7          	jalr	-256(ra) # 80201d20 <_Z6wakeupPv>
    80201e28:	b745                	j	80201dc8 <_Z9schedulerv+0x6e>

0000000080201e2a <_Z4forkv>:

int fork() {
    80201e2a:	7179                	addi	sp,sp,-48
    80201e2c:	f406                	sd	ra,40(sp)
    80201e2e:	f022                	sd	s0,32(sp)
    80201e30:	ec26                	sd	s1,24(sp)
    80201e32:	e84a                	sd	s2,16(sp)
    80201e34:	e44e                	sd	s3,8(sp)
    80201e36:	e052                	sd	s4,0(sp)
    80201e38:	1800                	addi	s0,sp,48
  Task *child;
  Task *task = myTask();
    80201e3a:	00000097          	auipc	ra,0x0
    80201e3e:	bd2080e7          	jalr	-1070(ra) # 80201a0c <_Z6myTaskv>
    80201e42:	892a                	mv	s2,a0
  // 分配一个新的进程
  if ((child = allocTask()) == 0) {
    80201e44:	00000097          	auipc	ra,0x0
    80201e48:	a8c080e7          	jalr	-1396(ra) # 802018d0 <_Z9allocTaskv>
    80201e4c:	c961                	beqz	a0,80201f1c <_Z4forkv+0xf2>
    80201e4e:	89aa                	mv	s3,a0
    return -1;
  }

  // 将父进程的内存复制到子进程中
  if (user_vm_copy(task->pagetable, child->pagetable, task->sz) < 0) {
    80201e50:	16092603          	lw	a2,352(s2)
    80201e54:	652c                	ld	a1,72(a0)
    80201e56:	04893503          	ld	a0,72(s2)
    80201e5a:	00005097          	auipc	ra,0x5
    80201e5e:	4fe080e7          	jalr	1278(ra) # 80207358 <_Z12user_vm_copyPmS_i>
    80201e62:	0a054f63          	bltz	a0,80201f20 <_Z4forkv+0xf6>
    return -1;
  }
  child->sz = task->sz;
    80201e66:	16092783          	lw	a5,352(s2)
    80201e6a:	16f9a023          	sw	a5,352(s3)
  child->parent = task;
    80201e6e:	0329b023          	sd	s2,32(s3)

  // 复制父进程的用户空间的寄存器
  *(child->trapframe) = *(task->trapframe);
    80201e72:	04093683          	ld	a3,64(s2)
    80201e76:	87b6                	mv	a5,a3
    80201e78:	0409b703          	ld	a4,64(s3)
    80201e7c:	12068693          	addi	a3,a3,288
    80201e80:	0007b803          	ld	a6,0(a5)
    80201e84:	6788                	ld	a0,8(a5)
    80201e86:	6b8c                	ld	a1,16(a5)
    80201e88:	6f90                	ld	a2,24(a5)
    80201e8a:	01073023          	sd	a6,0(a4)
    80201e8e:	e708                	sd	a0,8(a4)
    80201e90:	eb0c                	sd	a1,16(a4)
    80201e92:	ef10                	sd	a2,24(a4)
    80201e94:	02078793          	addi	a5,a5,32
    80201e98:	02070713          	addi	a4,a4,32
    80201e9c:	fed792e3          	bne	a5,a3,80201e80 <_Z4forkv+0x56>
  // memmove(child->trapframe, task->trapframe, sizeof(struct trapframe));
  // 设置子进程fork的返回值为0
  child->trapframe->a0 = 0;
    80201ea0:	0409b783          	ld	a5,64(s3)
    80201ea4:	0607b823          	sd	zero,112(a5)
    80201ea8:	05000493          	li	s1,80

  for (int i = 0; i < NOFILE; i++) {
    80201eac:	09000a13          	li	s4,144
    80201eb0:	a819                	j	80201ec6 <_Z4forkv+0x9c>
    if (task->openFiles[i] != 0) {
      child->openFiles[i] = vfs::dup(task->openFiles[i]);
    80201eb2:	00005097          	auipc	ra,0x5
    80201eb6:	8dc080e7          	jalr	-1828(ra) # 8020678e <_ZN3vfs3dupEP4file>
    80201eba:	009987b3          	add	a5,s3,s1
    80201ebe:	e388                	sd	a0,0(a5)
  for (int i = 0; i < NOFILE; i++) {
    80201ec0:	04a1                	addi	s1,s1,8
    80201ec2:	01448763          	beq	s1,s4,80201ed0 <_Z4forkv+0xa6>
    if (task->openFiles[i] != 0) {
    80201ec6:	009907b3          	add	a5,s2,s1
    80201eca:	6388                	ld	a0,0(a5)
    80201ecc:	f17d                	bnez	a0,80201eb2 <_Z4forkv+0x88>
    80201ece:	bfcd                	j	80201ec0 <_Z4forkv+0x96>
    }
  }
  safestrcpy(child->currentDir, task->currentDir, strlen(task->currentDir) + 1);
    80201ed0:	09090493          	addi	s1,s2,144
    80201ed4:	8526                	mv	a0,s1
    80201ed6:	fffff097          	auipc	ra,0xfffff
    80201eda:	e76080e7          	jalr	-394(ra) # 80200d4c <_Z6strlenPKc>
    80201ede:	0015061b          	addiw	a2,a0,1
    80201ee2:	85a6                	mv	a1,s1
    80201ee4:	09098513          	addi	a0,s3,144
    80201ee8:	fffff097          	auipc	ra,0xfffff
    80201eec:	e30080e7          	jalr	-464(ra) # 80200d18 <_Z10safestrcpyPcPKci>

  safestrcpy(child->name, task->name, sizeof(task->name) + 1);
    80201ef0:	4645                	li	a2,17
    80201ef2:	15090593          	addi	a1,s2,336
    80201ef6:	15098513          	addi	a0,s3,336
    80201efa:	fffff097          	auipc	ra,0xfffff
    80201efe:	e1e080e7          	jalr	-482(ra) # 80200d18 <_Z10safestrcpyPcPKci>

  child->state = RUNNABLE;
    80201f02:	4789                	li	a5,2
    80201f04:	00f9ac23          	sw	a5,24(s3)
  return child->pid;
    80201f08:	0389a503          	lw	a0,56(s3)
}
    80201f0c:	70a2                	ld	ra,40(sp)
    80201f0e:	7402                	ld	s0,32(sp)
    80201f10:	64e2                	ld	s1,24(sp)
    80201f12:	6942                	ld	s2,16(sp)
    80201f14:	69a2                	ld	s3,8(sp)
    80201f16:	6a02                	ld	s4,0(sp)
    80201f18:	6145                	addi	sp,sp,48
    80201f1a:	8082                	ret
    return -1;
    80201f1c:	557d                	li	a0,-1
    80201f1e:	b7fd                	j	80201f0c <_Z4forkv+0xe2>
    return -1;
    80201f20:	557d                	li	a0,-1
    80201f22:	b7ed                	j	80201f0c <_Z4forkv+0xe2>

0000000080201f24 <_Z4waitm>:
/**
 * 等待子进程退出, 返回其子进程id
 * 没有子进程返回-1， 将退出状态复
 * 制到status中。
 */
int wait(uint64_t vaddr) {
    80201f24:	715d                	addi	sp,sp,-80
    80201f26:	e486                	sd	ra,72(sp)
    80201f28:	e0a2                	sd	s0,64(sp)
    80201f2a:	fc26                	sd	s1,56(sp)
    80201f2c:	f84a                	sd	s2,48(sp)
    80201f2e:	f44e                	sd	s3,40(sp)
    80201f30:	f052                	sd	s4,32(sp)
    80201f32:	ec56                	sd	s5,24(sp)
    80201f34:	e85a                	sd	s6,16(sp)
    80201f36:	e45e                	sd	s7,8(sp)
    80201f38:	0880                	addi	s0,sp,80
    80201f3a:	8b2a                	mv	s6,a0
  Task *child;  // 子进程
  Task *task;
  int pid;
  bool havechild;
  task = myTask();
    80201f3c:	00000097          	auipc	ra,0x0
    80201f40:	ad0080e7          	jalr	-1328(ra) # 80201a0c <_Z6myTaskv>
    80201f44:	892a                	mv	s2,a0
  task->lock.lock();
    80201f46:	fffff097          	auipc	ra,0xfffff
    80201f4a:	f06080e7          	jalr	-250(ra) # 80200e4c <_ZN8SpinLock4lockEv>
  for (;;) {
    havechild = 0;
    80201f4e:	4b81                	li	s7,0
    for (child = taskTable; child < &taskTable[NTASK]; child++) {
      if (child->parent == task) {
        child->lock.lock();
        havechild = true;
        if (child->state == ZOMBIE) {
    80201f50:	4a11                	li	s4,4
    for (child = taskTable; child < &taskTable[NTASK]; child++) {
    80201f52:	0008b997          	auipc	s3,0x8b
    80201f56:	6fe98993          	addi	s3,s3,1790 # 8028d650 <initTask>
        havechild = true;
    80201f5a:	4a85                	li	s5,1
    havechild = 0;
    80201f5c:	875e                	mv	a4,s7
    for (child = taskTable; child < &taskTable[NTASK]; child++) {
    80201f5e:	00087497          	auipc	s1,0x87
    80201f62:	0a248493          	addi	s1,s1,162 # 80289000 <taskTable>
    80201f66:	a0c5                	j	80202046 <_Z4waitm+0x122>
          pid = child->pid;
    80201f68:	0384a983          	lw	s3,56(s1)
          if (vaddr != 0 && copyout(task->pagetable, vaddr, (char *)&child->xstate, sizeof(child->xstate)) < 0) {
    80201f6c:	000b0e63          	beqz	s6,80201f88 <_Z4waitm+0x64>
    80201f70:	4691                	li	a3,4
    80201f72:	03448613          	addi	a2,s1,52
    80201f76:	85da                	mv	a1,s6
    80201f78:	04893503          	ld	a0,72(s2)
    80201f7c:	00005097          	auipc	ra,0x5
    80201f80:	344080e7          	jalr	836(ra) # 802072c0 <_Z7copyoutPmmPci>
    80201f84:	0a054163          	bltz	a0,80202026 <_Z4waitm+0x102>
    80201f88:	00008717          	auipc	a4,0x8
    80201f8c:	6c870713          	addi	a4,a4,1736 # 8020a650 <_ZL6digits+0x348>
    80201f90:	17d00693          	li	a3,381
    80201f94:	00008617          	auipc	a2,0x8
    80201f98:	63c60613          	addi	a2,a2,1596 # 8020a5d0 <_ZL6digits+0x2c8>
    80201f9c:	00008597          	auipc	a1,0x8
    80201fa0:	1dc58593          	addi	a1,a1,476 # 8020a178 <rodata_start+0x178>
    80201fa4:	00008517          	auipc	a0,0x8
    80201fa8:	1dc50513          	addi	a0,a0,476 # 8020a180 <rodata_start+0x180>
    80201fac:	fffff097          	auipc	ra,0xfffff
    80201fb0:	8a8080e7          	jalr	-1880(ra) # 80200854 <_Z6printfPKcz>
            child->lock.unlock();
            task->lock.unlock();
            return -1;
          }
          LOG_DEBUG("child pid=%d xstate=%d", child->pid, child->xstate);
    80201fb4:	58d0                	lw	a2,52(s1)
    80201fb6:	5c8c                	lw	a1,56(s1)
    80201fb8:	00008517          	auipc	a0,0x8
    80201fbc:	6a050513          	addi	a0,a0,1696 # 8020a658 <_ZL6digits+0x350>
    80201fc0:	fffff097          	auipc	ra,0xfffff
    80201fc4:	894080e7          	jalr	-1900(ra) # 80200854 <_Z6printfPKcz>
    80201fc8:	00008517          	auipc	a0,0x8
    80201fcc:	0d850513          	addi	a0,a0,216 # 8020a0a0 <rodata_start+0xa0>
    80201fd0:	fffff097          	auipc	ra,0xfffff
    80201fd4:	884080e7          	jalr	-1916(ra) # 80200854 <_Z6printfPKcz>
  if (task->trapframe) memAllocator.free(task->trapframe);
    80201fd8:	60ac                	ld	a1,64(s1)
    80201fda:	c989                	beqz	a1,80201fec <_Z4waitm+0xc8>
    80201fdc:	00012517          	auipc	a0,0x12
    80201fe0:	0c450513          	addi	a0,a0,196 # 802140a0 <memAllocator>
    80201fe4:	00005097          	auipc	ra,0x5
    80201fe8:	5ac080e7          	jalr	1452(ra) # 80207590 <_ZN12MemAllocator4freeEPv>
  task->trapframe = 0;
    80201fec:	0404b023          	sd	zero,64(s1)
  task->pagetable = 0;
    80201ff0:	0404b423          	sd	zero,72(s1)
  task->sz = 0;
    80201ff4:	1604a023          	sw	zero,352(s1)
  task->name[0] = 0;
    80201ff8:	14048823          	sb	zero,336(s1)
  task->chan = 0;
    80201ffc:	0204b423          	sd	zero,40(s1)
  task->killed = 0;
    80202000:	0204a823          	sw	zero,48(s1)
  task->xstate = 0;
    80202004:	0204aa23          	sw	zero,52(s1)
  task->state = UNUSED;
    80202008:	0004ac23          	sw	zero,24(s1)
  task->parent = 0;
    8020200c:	0204b023          	sd	zero,32(s1)
          freeTask(child);
          child->lock.unlock();
    80202010:	8526                	mv	a0,s1
    80202012:	fffff097          	auipc	ra,0xfffff
    80202016:	eb6080e7          	jalr	-330(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
          task->lock.unlock();
    8020201a:	854a                	mv	a0,s2
    8020201c:	fffff097          	auipc	ra,0xfffff
    80202020:	eac080e7          	jalr	-340(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
          return pid;
    80202024:	a0a9                	j	8020206e <_Z4waitm+0x14a>
            child->lock.unlock();
    80202026:	8526                	mv	a0,s1
    80202028:	fffff097          	auipc	ra,0xfffff
    8020202c:	ea0080e7          	jalr	-352(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
            task->lock.unlock();
    80202030:	854a                	mv	a0,s2
    80202032:	fffff097          	auipc	ra,0xfffff
    80202036:	e96080e7          	jalr	-362(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
            return -1;
    8020203a:	59fd                	li	s3,-1
    8020203c:	a80d                	j	8020206e <_Z4waitm+0x14a>
    for (child = taskTable; child < &taskTable[NTASK]; child++) {
    8020203e:	16848493          	addi	s1,s1,360
    80202042:	03348463          	beq	s1,s3,8020206a <_Z4waitm+0x146>
      if (child->parent == task) {
    80202046:	709c                	ld	a5,32(s1)
    80202048:	ff279be3          	bne	a5,s2,8020203e <_Z4waitm+0x11a>
        child->lock.lock();
    8020204c:	8526                	mv	a0,s1
    8020204e:	fffff097          	auipc	ra,0xfffff
    80202052:	dfe080e7          	jalr	-514(ra) # 80200e4c <_ZN8SpinLock4lockEv>
        if (child->state == ZOMBIE) {
    80202056:	4c9c                	lw	a5,24(s1)
    80202058:	f14788e3          	beq	a5,s4,80201f68 <_Z4waitm+0x44>
        }
        child->lock.unlock();
    8020205c:	8526                	mv	a0,s1
    8020205e:	fffff097          	auipc	ra,0xfffff
    80202062:	e6a080e7          	jalr	-406(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
        havechild = true;
    80202066:	8756                	mv	a4,s5
    80202068:	bfd9                	j	8020203e <_Z4waitm+0x11a>
      }
    }
    if (!havechild) {
    8020206a:	ef11                	bnez	a4,80202086 <_Z4waitm+0x162>
      return -1;
    8020206c:	59fd                	li	s3,-1
    }
    sleep(task, &myTask()->lock);  // 等待子进程唤醒
  }
}
    8020206e:	854e                	mv	a0,s3
    80202070:	60a6                	ld	ra,72(sp)
    80202072:	6406                	ld	s0,64(sp)
    80202074:	74e2                	ld	s1,56(sp)
    80202076:	7942                	ld	s2,48(sp)
    80202078:	79a2                	ld	s3,40(sp)
    8020207a:	7a02                	ld	s4,32(sp)
    8020207c:	6ae2                	ld	s5,24(sp)
    8020207e:	6b42                	ld	s6,16(sp)
    80202080:	6ba2                	ld	s7,8(sp)
    80202082:	6161                	addi	sp,sp,80
    80202084:	8082                	ret
    sleep(task, &myTask()->lock);  // 等待子进程唤醒
    80202086:	00000097          	auipc	ra,0x0
    8020208a:	986080e7          	jalr	-1658(ra) # 80201a0c <_Z6myTaskv>
    8020208e:	85aa                	mv	a1,a0
    80202090:	854a                	mv	a0,s2
    80202092:	00000097          	auipc	ra,0x0
    80202096:	b9a080e7          	jalr	-1126(ra) # 80201c2c <_Z5sleepPvP8SpinLock>
  }
    8020209a:	b5c9                	j	80201f5c <_Z4waitm+0x38>

000000008020209c <_Z5wait4im>:
 * @param pid 子进程id
 * @param vaddr status地址
 * @return int
 */
int wait4(int pid, uint64_t vaddr) {
  if (pid >= NTASK) {
    8020209c:	03100793          	li	a5,49
    802020a0:	16a7ca63          	blt	a5,a0,80202214 <_Z5wait4im+0x178>
int wait4(int pid, uint64_t vaddr) {
    802020a4:	715d                	addi	sp,sp,-80
    802020a6:	e486                	sd	ra,72(sp)
    802020a8:	e0a2                	sd	s0,64(sp)
    802020aa:	fc26                	sd	s1,56(sp)
    802020ac:	f84a                	sd	s2,48(sp)
    802020ae:	f44e                	sd	s3,40(sp)
    802020b0:	f052                	sd	s4,32(sp)
    802020b2:	ec56                	sd	s5,24(sp)
    802020b4:	e85a                	sd	s6,16(sp)
    802020b6:	e45e                	sd	s7,8(sp)
    802020b8:	0880                	addi	s0,sp,80
    802020ba:	8a2a                	mv	s4,a0
    802020bc:	8b2e                	mv	s6,a1
    return -1;
  }

  Task *task = myTask();
    802020be:	00000097          	auipc	ra,0x0
    802020c2:	94e080e7          	jalr	-1714(ra) # 80201a0c <_Z6myTaskv>
    802020c6:	892a                	mv	s2,a0
  Task *child = &taskTable[pid];
    802020c8:	16800b93          	li	s7,360
    802020cc:	037a0bb3          	mul	s7,s4,s7
    802020d0:	00087497          	auipc	s1,0x87
    802020d4:	f3048493          	addi	s1,s1,-208 # 80289000 <taskTable>
    802020d8:	94de                	add	s1,s1,s7
  child->lock.lock();
    802020da:	8526                	mv	a0,s1
    802020dc:	fffff097          	auipc	ra,0xfffff
    802020e0:	d70080e7          	jalr	-656(ra) # 80200e4c <_ZN8SpinLock4lockEv>
  if (child->parent != task) {
    802020e4:	709c                	ld	a5,32(s1)
    802020e6:	05279f63          	bne	a5,s2,80202144 <_Z5wait4im+0xa8>
    child->lock.unlock();
    return -1;
  }
  child->lock.unlock();
    802020ea:	8526                	mv	a0,s1
    802020ec:	fffff097          	auipc	ra,0xfffff
    802020f0:	ddc080e7          	jalr	-548(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
  task->lock.lock();
    802020f4:	854a                	mv	a0,s2
    802020f6:	fffff097          	auipc	ra,0xfffff
    802020fa:	d56080e7          	jalr	-682(ra) # 80200e4c <_ZN8SpinLock4lockEv>
  while (true) {
    child->lock.lock();
    if (child->state == ZOMBIE) {
    802020fe:	16800993          	li	s3,360
    80202102:	033a07b3          	mul	a5,s4,s3
    80202106:	00087997          	auipc	s3,0x87
    8020210a:	efa98993          	addi	s3,s3,-262 # 80289000 <taskTable>
    8020210e:	99be                	add	s3,s3,a5
    80202110:	4a91                	li	s5,4
    child->lock.lock();
    80202112:	8526                	mv	a0,s1
    80202114:	fffff097          	auipc	ra,0xfffff
    80202118:	d38080e7          	jalr	-712(ra) # 80200e4c <_ZN8SpinLock4lockEv>
    if (child->state == ZOMBIE) {
    8020211c:	0189a783          	lw	a5,24(s3)
    80202120:	03578963          	beq	a5,s5,80202152 <_Z5wait4im+0xb6>
      freeTask(child);
      child->lock.unlock();
      task->lock.unlock();
      return pid;
    }
    child->lock.unlock();
    80202124:	8526                	mv	a0,s1
    80202126:	fffff097          	auipc	ra,0xfffff
    8020212a:	da2080e7          	jalr	-606(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
    sleep(task, &myTask()->lock);  // 等待子进程唤醒
    8020212e:	00000097          	auipc	ra,0x0
    80202132:	8de080e7          	jalr	-1826(ra) # 80201a0c <_Z6myTaskv>
    80202136:	85aa                	mv	a1,a0
    80202138:	854a                	mv	a0,s2
    8020213a:	00000097          	auipc	ra,0x0
    8020213e:	af2080e7          	jalr	-1294(ra) # 80201c2c <_Z5sleepPvP8SpinLock>
    child->lock.lock();
    80202142:	bfc1                	j	80202112 <_Z5wait4im+0x76>
    child->lock.unlock();
    80202144:	8526                	mv	a0,s1
    80202146:	fffff097          	auipc	ra,0xfffff
    8020214a:	d82080e7          	jalr	-638(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
    return -1;
    8020214e:	557d                	li	a0,-1
    80202150:	a859                	j	802021e6 <_Z5wait4im+0x14a>
      if (vaddr != 0 && copyout(task->pagetable, vaddr, (char *)&child->xstate, sizeof(child->xstate)) < 0) {
    80202152:	020b0163          	beqz	s6,80202174 <_Z5wait4im+0xd8>
    80202156:	4691                	li	a3,4
    80202158:	00087617          	auipc	a2,0x87
    8020215c:	edc60613          	addi	a2,a2,-292 # 80289034 <taskTable+0x34>
    80202160:	965e                	add	a2,a2,s7
    80202162:	85da                	mv	a1,s6
    80202164:	04893503          	ld	a0,72(s2)
    80202168:	00005097          	auipc	ra,0x5
    8020216c:	158080e7          	jalr	344(ra) # 802072c0 <_Z7copyoutPmmPci>
    80202170:	08054663          	bltz	a0,802021fc <_Z5wait4im+0x160>
  if (task->trapframe) memAllocator.free(task->trapframe);
    80202174:	16800793          	li	a5,360
    80202178:	02fa0733          	mul	a4,s4,a5
    8020217c:	00087797          	auipc	a5,0x87
    80202180:	e8478793          	addi	a5,a5,-380 # 80289000 <taskTable>
    80202184:	97ba                	add	a5,a5,a4
    80202186:	63ac                	ld	a1,64(a5)
    80202188:	c989                	beqz	a1,8020219a <_Z5wait4im+0xfe>
    8020218a:	00012517          	auipc	a0,0x12
    8020218e:	f1650513          	addi	a0,a0,-234 # 802140a0 <memAllocator>
    80202192:	00005097          	auipc	ra,0x5
    80202196:	3fe080e7          	jalr	1022(ra) # 80207590 <_ZN12MemAllocator4freeEPv>
  task->trapframe = 0;
    8020219a:	16800793          	li	a5,360
    8020219e:	02fa0733          	mul	a4,s4,a5
    802021a2:	00087797          	auipc	a5,0x87
    802021a6:	e5e78793          	addi	a5,a5,-418 # 80289000 <taskTable>
    802021aa:	97ba                	add	a5,a5,a4
    802021ac:	0407b023          	sd	zero,64(a5)
  task->pagetable = 0;
    802021b0:	0407b423          	sd	zero,72(a5)
  task->sz = 0;
    802021b4:	1607a023          	sw	zero,352(a5)
  task->name[0] = 0;
    802021b8:	14078823          	sb	zero,336(a5)
  task->chan = 0;
    802021bc:	0207b423          	sd	zero,40(a5)
  task->killed = 0;
    802021c0:	0207a823          	sw	zero,48(a5)
  task->xstate = 0;
    802021c4:	0207aa23          	sw	zero,52(a5)
  task->state = UNUSED;
    802021c8:	0007ac23          	sw	zero,24(a5)
  task->parent = 0;
    802021cc:	0207b023          	sd	zero,32(a5)
      child->lock.unlock();
    802021d0:	8526                	mv	a0,s1
    802021d2:	fffff097          	auipc	ra,0xfffff
    802021d6:	cf6080e7          	jalr	-778(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
      task->lock.unlock();
    802021da:	854a                	mv	a0,s2
    802021dc:	fffff097          	auipc	ra,0xfffff
    802021e0:	cec080e7          	jalr	-788(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
      return pid;
    802021e4:	8552                	mv	a0,s4
  }
}
    802021e6:	60a6                	ld	ra,72(sp)
    802021e8:	6406                	ld	s0,64(sp)
    802021ea:	74e2                	ld	s1,56(sp)
    802021ec:	7942                	ld	s2,48(sp)
    802021ee:	79a2                	ld	s3,40(sp)
    802021f0:	7a02                	ld	s4,32(sp)
    802021f2:	6ae2                	ld	s5,24(sp)
    802021f4:	6b42                	ld	s6,16(sp)
    802021f6:	6ba2                	ld	s7,8(sp)
    802021f8:	6161                	addi	sp,sp,80
    802021fa:	8082                	ret
        child->lock.unlock();
    802021fc:	8526                	mv	a0,s1
    802021fe:	fffff097          	auipc	ra,0xfffff
    80202202:	cca080e7          	jalr	-822(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
        task->lock.unlock();
    80202206:	854a                	mv	a0,s2
    80202208:	fffff097          	auipc	ra,0xfffff
    8020220c:	cc0080e7          	jalr	-832(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
        return -1;
    80202210:	557d                	li	a0,-1
    80202212:	bfd1                	j	802021e6 <_Z5wait4im+0x14a>
    return -1;
    80202214:	557d                	li	a0,-1
}
    80202216:	8082                	ret

0000000080202218 <_Z4exiti>:
// 让父进程来设置其state为UNUSED
// 若父进程已经exit, 则会由init进
// 程来完成父进程在exit时，会将其
// 子进程的parent设置为init进程
//
void exit(int status) {
    80202218:	7179                	addi	sp,sp,-48
    8020221a:	f406                	sd	ra,40(sp)
    8020221c:	f022                	sd	s0,32(sp)
    8020221e:	ec26                	sd	s1,24(sp)
    80202220:	e84a                	sd	s2,16(sp)
    80202222:	e44e                	sd	s3,8(sp)
    80202224:	1800                	addi	s0,sp,48
    80202226:	892a                	mv	s2,a0
  Task *task, *child;
  task = myTask();
    80202228:	fffff097          	auipc	ra,0xfffff
    8020222c:	7e4080e7          	jalr	2020(ra) # 80201a0c <_Z6myTaskv>
    80202230:	84aa                	mv	s1,a0
  task->state = ZOMBIE;
    80202232:	4791                	li	a5,4
    80202234:	cd1c                	sw	a5,24(a0)
  task->xstate = status;
    80202236:	03252a23          	sw	s2,52(a0)
    8020223a:	00008717          	auipc	a4,0x8
    8020223e:	43670713          	addi	a4,a4,1078 # 8020a670 <_ZL6digits+0x368>
    80202242:	1c200693          	li	a3,450
    80202246:	00008617          	auipc	a2,0x8
    8020224a:	38a60613          	addi	a2,a2,906 # 8020a5d0 <_ZL6digits+0x2c8>
    8020224e:	00008597          	auipc	a1,0x8
    80202252:	f2a58593          	addi	a1,a1,-214 # 8020a178 <rodata_start+0x178>
    80202256:	00008517          	auipc	a0,0x8
    8020225a:	f2a50513          	addi	a0,a0,-214 # 8020a180 <rodata_start+0x180>
    8020225e:	ffffe097          	auipc	ra,0xffffe
    80202262:	5f6080e7          	jalr	1526(ra) # 80200854 <_Z6printfPKcz>
  LOG_DEBUG("pid=%d xstate=%d", task->pid, task->xstate);
    80202266:	58d0                	lw	a2,52(s1)
    80202268:	5c8c                	lw	a1,56(s1)
    8020226a:	00008517          	auipc	a0,0x8
    8020226e:	40e50513          	addi	a0,a0,1038 # 8020a678 <_ZL6digits+0x370>
    80202272:	ffffe097          	auipc	ra,0xffffe
    80202276:	5e2080e7          	jalr	1506(ra) # 80200854 <_Z6printfPKcz>
    8020227a:	00008517          	auipc	a0,0x8
    8020227e:	e2650513          	addi	a0,a0,-474 # 8020a0a0 <rodata_start+0xa0>
    80202282:	ffffe097          	auipc	ra,0xffffe
    80202286:	5d2080e7          	jalr	1490(ra) # 80200854 <_Z6printfPKcz>
  // 关闭打开的文件
  for (int fd = 0; fd < NOFILE; fd++) {
    8020228a:	05048913          	addi	s2,s1,80
    8020228e:	09048993          	addi	s3,s1,144
    80202292:	a021                	j	8020229a <_Z4exiti+0x82>
    80202294:	0921                	addi	s2,s2,8
    80202296:	01390c63          	beq	s2,s3,802022ae <_Z4exiti+0x96>
    if (task->openFiles[fd] != NULL) {
    8020229a:	00093503          	ld	a0,0(s2)
    8020229e:	d97d                	beqz	a0,80202294 <_Z4exiti+0x7c>
      vfs::close(task->openFiles[fd]);
    802022a0:	00004097          	auipc	ra,0x4
    802022a4:	122080e7          	jalr	290(ra) # 802063c2 <_ZN3vfs5closeEP4file>
      task->openFiles[fd] = 0;
    802022a8:	00093023          	sd	zero,0(s2)
    802022ac:	b7e5                	j	80202294 <_Z4exiti+0x7c>
    }
  }

  // 归还当前目录inode
  // putback_inode(task->current_dir);
  memset(task->currentDir, 0, MAXPATH);
    802022ae:	04000613          	li	a2,64
    802022b2:	4581                	li	a1,0
    802022b4:	09048513          	addi	a0,s1,144
    802022b8:	fffff097          	auipc	ra,0xfffff
    802022bc:	8a4080e7          	jalr	-1884(ra) # 80200b5c <_Z6memsetPvij>
  // 将子进程托付给init进程
  for (child = taskTable; child < &taskTable[NTASK]; child++) {
    if (child->parent == task) {
      child->parent = initTask;
    802022c0:	0008b617          	auipc	a2,0x8b
    802022c4:	39063603          	ld	a2,912(a2) # 8028d650 <initTask>
  for (child = taskTable; child < &taskTable[NTASK]; child++) {
    802022c8:	00087797          	auipc	a5,0x87
    802022cc:	d3878793          	addi	a5,a5,-712 # 80289000 <taskTable>
    802022d0:	0008b697          	auipc	a3,0x8b
    802022d4:	38068693          	addi	a3,a3,896 # 8028d650 <initTask>
    802022d8:	a031                	j	802022e4 <_Z4exiti+0xcc>
      child->parent = initTask;
    802022da:	f390                	sd	a2,32(a5)
  for (child = taskTable; child < &taskTable[NTASK]; child++) {
    802022dc:	16878793          	addi	a5,a5,360
    802022e0:	00d78663          	beq	a5,a3,802022ec <_Z4exiti+0xd4>
    if (child->parent == task) {
    802022e4:	7398                	ld	a4,32(a5)
    802022e6:	fe971be3          	bne	a4,s1,802022dc <_Z4exiti+0xc4>
    802022ea:	bfc5                	j	802022da <_Z4exiti+0xc2>
    }
  }

  wakeup(task->parent);
    802022ec:	7088                	ld	a0,32(s1)
    802022ee:	00000097          	auipc	ra,0x0
    802022f2:	a32080e7          	jalr	-1486(ra) # 80201d20 <_Z6wakeupPv>
  task->lock.lock();
    802022f6:	8526                	mv	a0,s1
    802022f8:	fffff097          	auipc	ra,0xfffff
    802022fc:	b54080e7          	jalr	-1196(ra) # 80200e4c <_ZN8SpinLock4lockEv>
    80202300:	00008717          	auipc	a4,0x8
    80202304:	37070713          	addi	a4,a4,880 # 8020a670 <_ZL6digits+0x368>
    80202308:	1d700693          	li	a3,471
    8020230c:	00008617          	auipc	a2,0x8
    80202310:	2c460613          	addi	a2,a2,708 # 8020a5d0 <_ZL6digits+0x2c8>
    80202314:	00008597          	auipc	a1,0x8
    80202318:	e6458593          	addi	a1,a1,-412 # 8020a178 <rodata_start+0x178>
    8020231c:	00008517          	auipc	a0,0x8
    80202320:	e6450513          	addi	a0,a0,-412 # 8020a180 <rodata_start+0x180>
    80202324:	ffffe097          	auipc	ra,0xffffe
    80202328:	530080e7          	jalr	1328(ra) # 80200854 <_Z6printfPKcz>
  LOG_DEBUG("exited\n");
    8020232c:	00008517          	auipc	a0,0x8
    80202330:	36450513          	addi	a0,a0,868 # 8020a690 <_ZL6digits+0x388>
    80202334:	ffffe097          	auipc	ra,0xffffe
    80202338:	520080e7          	jalr	1312(ra) # 80200854 <_Z6printfPKcz>
    8020233c:	00008517          	auipc	a0,0x8
    80202340:	d6450513          	addi	a0,a0,-668 # 8020a0a0 <rodata_start+0xa0>
    80202344:	ffffe097          	auipc	ra,0xffffe
    80202348:	510080e7          	jalr	1296(ra) # 80200854 <_Z6printfPKcz>
  prepareSched();
    8020234c:	00000097          	auipc	ra,0x0
    80202350:	81c080e7          	jalr	-2020(ra) # 80201b68 <_Z12prepareSchedv>
  panic("exit");
    80202354:	00008517          	auipc	a0,0x8
    80202358:	31c50513          	addi	a0,a0,796 # 8020a670 <_ZL6digits+0x368>
    8020235c:	ffffe097          	auipc	ra,0xffffe
    80202360:	486080e7          	jalr	1158(ra) # 802007e2 <_Z5panicPKc>
}
    80202364:	70a2                	ld	ra,40(sp)
    80202366:	7402                	ld	s0,32(sp)
    80202368:	64e2                	ld	s1,24(sp)
    8020236a:	6942                	ld	s2,16(sp)
    8020236c:	69a2                	ld	s3,8(sp)
    8020236e:	6145                	addi	sp,sp,48
    80202370:	8082                	ret

0000000080202372 <_Z5yieldv>:
// }

//
// 让出cpu
//
void yield() {
    80202372:	1101                	addi	sp,sp,-32
    80202374:	ec06                	sd	ra,24(sp)
    80202376:	e822                	sd	s0,16(sp)
    80202378:	e426                	sd	s1,8(sp)
    8020237a:	1000                	addi	s0,sp,32
  Task *task = myTask();
    8020237c:	fffff097          	auipc	ra,0xfffff
    80202380:	690080e7          	jalr	1680(ra) # 80201a0c <_Z6myTaskv>
    80202384:	84aa                	mv	s1,a0
  task->lock.lock();
    80202386:	fffff097          	auipc	ra,0xfffff
    8020238a:	ac6080e7          	jalr	-1338(ra) # 80200e4c <_ZN8SpinLock4lockEv>
  task->state = RUNNABLE;
    8020238e:	4789                	li	a5,2
    80202390:	cc9c                	sw	a5,24(s1)
  prepareSched();
    80202392:	fffff097          	auipc	ra,0xfffff
    80202396:	7d6080e7          	jalr	2006(ra) # 80201b68 <_Z12prepareSchedv>
  task->lock.unlock();
    8020239a:	8526                	mv	a0,s1
    8020239c:	fffff097          	auipc	ra,0xfffff
    802023a0:	b2c080e7          	jalr	-1236(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
}
    802023a4:	60e2                	ld	ra,24(sp)
    802023a6:	6442                	ld	s0,16(sp)
    802023a8:	64a2                	ld	s1,8(sp)
    802023aa:	6105                	addi	sp,sp,32
    802023ac:	8082                	ret

00000000802023ae <_Z14either_copyoutbmPvi>:
 *  根据user_dst将源数据复制内核地址或用户地址
 *  @param user_dst dst是否为用户空间地址
 *  @param copy的长度
 * @return 成功返回0，失败返回-1
 */
int either_copyout(bool user_dst, uint64_t dst, void *src, int len) {
    802023ae:	7179                	addi	sp,sp,-48
    802023b0:	f406                	sd	ra,40(sp)
    802023b2:	f022                	sd	s0,32(sp)
    802023b4:	ec26                	sd	s1,24(sp)
    802023b6:	e84a                	sd	s2,16(sp)
    802023b8:	e44e                	sd	s3,8(sp)
    802023ba:	e052                	sd	s4,0(sp)
    802023bc:	1800                	addi	s0,sp,48
    802023be:	8a2a                	mv	s4,a0
    802023c0:	84ae                	mv	s1,a1
    802023c2:	8932                	mv	s2,a2
    802023c4:	89b6                	mv	s3,a3
  Task *task = myTask();
    802023c6:	fffff097          	auipc	ra,0xfffff
    802023ca:	646080e7          	jalr	1606(ra) # 80201a0c <_Z6myTaskv>
  if (user_dst) {
    802023ce:	020a0263          	beqz	s4,802023f2 <_Z14either_copyoutbmPvi+0x44>
    return copyout(task->pagetable, dst, static_cast<char *>(src), len);
    802023d2:	86ce                	mv	a3,s3
    802023d4:	864a                	mv	a2,s2
    802023d6:	85a6                	mv	a1,s1
    802023d8:	6528                	ld	a0,72(a0)
    802023da:	00005097          	auipc	ra,0x5
    802023de:	ee6080e7          	jalr	-282(ra) # 802072c0 <_Z7copyoutPmmPci>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    802023e2:	70a2                	ld	ra,40(sp)
    802023e4:	7402                	ld	s0,32(sp)
    802023e6:	64e2                	ld	s1,24(sp)
    802023e8:	6942                	ld	s2,16(sp)
    802023ea:	69a2                	ld	s3,8(sp)
    802023ec:	6a02                	ld	s4,0(sp)
    802023ee:	6145                	addi	sp,sp,48
    802023f0:	8082                	ret
    memmove((char *)dst, src, len);
    802023f2:	864e                	mv	a2,s3
    802023f4:	85ca                	mv	a1,s2
    802023f6:	8526                	mv	a0,s1
    802023f8:	ffffe097          	auipc	ra,0xffffe
    802023fc:	7be080e7          	jalr	1982(ra) # 80200bb6 <_Z7memmovePvPKvj>
    return 0;
    80202400:	4501                	li	a0,0
    80202402:	b7c5                	j	802023e2 <_Z14either_copyoutbmPvi+0x34>

0000000080202404 <_Z13either_copyinbPvmm>:
 *  根据user_dst将数据从内核地址或用户地址copy到dst中
 *  @param user_src dst是否为用户空间地址
 *  @param len copy的长度
 * @return 成功返回0，失败返回-1
 */
int either_copyin(bool user_src, void *dst, uint64_t src, uint64_t len) {
    80202404:	7179                	addi	sp,sp,-48
    80202406:	f406                	sd	ra,40(sp)
    80202408:	f022                	sd	s0,32(sp)
    8020240a:	ec26                	sd	s1,24(sp)
    8020240c:	e84a                	sd	s2,16(sp)
    8020240e:	e44e                	sd	s3,8(sp)
    80202410:	e052                	sd	s4,0(sp)
    80202412:	1800                	addi	s0,sp,48
    80202414:	8a2a                	mv	s4,a0
    80202416:	84ae                	mv	s1,a1
    80202418:	8932                	mv	s2,a2
    8020241a:	89b6                	mv	s3,a3
  Task *task = myTask();
    8020241c:	fffff097          	auipc	ra,0xfffff
    80202420:	5f0080e7          	jalr	1520(ra) # 80201a0c <_Z6myTaskv>
  if (user_src) {
    80202424:	020a0263          	beqz	s4,80202448 <_Z13either_copyinbPvmm+0x44>
    return copyin(task->pagetable, static_cast<char *>(dst), src, len);
    80202428:	86ce                	mv	a3,s3
    8020242a:	864a                	mv	a2,s2
    8020242c:	85a6                	mv	a1,s1
    8020242e:	6528                	ld	a0,72(a0)
    80202430:	00005097          	auipc	ra,0x5
    80202434:	d2e080e7          	jalr	-722(ra) # 8020715e <_Z6copyinPmPcmm>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80202438:	70a2                	ld	ra,40(sp)
    8020243a:	7402                	ld	s0,32(sp)
    8020243c:	64e2                	ld	s1,24(sp)
    8020243e:	6942                	ld	s2,16(sp)
    80202440:	69a2                	ld	s3,8(sp)
    80202442:	6a02                	ld	s4,0(sp)
    80202444:	6145                	addi	sp,sp,48
    80202446:	8082                	ret
    memmove(dst, (char *)src, len);
    80202448:	0009861b          	sext.w	a2,s3
    8020244c:	85ca                	mv	a1,s2
    8020244e:	8526                	mv	a0,s1
    80202450:	ffffe097          	auipc	ra,0xffffe
    80202454:	766080e7          	jalr	1894(ra) # 80200bb6 <_Z7memmovePvPKvj>
    return 0;
    80202458:	4501                	li	a0,0
    8020245a:	bff9                	j	80202438 <_Z13either_copyinbPvmm+0x34>

000000008020245c <_Z18registerFileHandleP4filei>:
 * @brief 将fp添加到进程的打开文件列表中
 *
 * @param fp 需要添加的文件指针
 * @return 成功返回文件描述符，失败返回-1
 */
int registerFileHandle(struct file *fp, int fd) {
    8020245c:	7179                	addi	sp,sp,-48
    8020245e:	f406                	sd	ra,40(sp)
    80202460:	f022                	sd	s0,32(sp)
    80202462:	ec26                	sd	s1,24(sp)
    80202464:	e84a                	sd	s2,16(sp)
    80202466:	e44e                	sd	s3,8(sp)
    80202468:	e052                	sd	s4,0(sp)
    8020246a:	1800                	addi	s0,sp,48
  if (fd > NFILE) {
    8020246c:	06400793          	li	a5,100
    80202470:	08b7c363          	blt	a5,a1,802024f6 <_Z18registerFileHandleP4filei+0x9a>
    80202474:	8a2a                	mv	s4,a0
    80202476:	892e                	mv	s2,a1
    return -1;
  }
  Task *task = myTask();
    80202478:	fffff097          	auipc	ra,0xfffff
    8020247c:	594080e7          	jalr	1428(ra) # 80201a0c <_Z6myTaskv>
    80202480:	89aa                	mv	s3,a0
  task->lock.lock();
    80202482:	fffff097          	auipc	ra,0xfffff
    80202486:	9ca080e7          	jalr	-1590(ra) # 80200e4c <_ZN8SpinLock4lockEv>
  if (fd < 0) {
    8020248a:	02094763          	bltz	s2,802024b8 <_Z18registerFileHandleP4filei+0x5c>
        return i;
      }
    }
    panic("register file handle");
  }
  if (task->openFiles[fd] != NULL) {
    8020248e:	00a90793          	addi	a5,s2,10
    80202492:	078e                	slli	a5,a5,0x3
    80202494:	97ce                	add	a5,a5,s3
    80202496:	639c                	ld	a5,0(a5)
    80202498:	c3ad                	beqz	a5,802024fa <_Z18registerFileHandleP4filei+0x9e>
    task->lock.unlock();
    8020249a:	854e                	mv	a0,s3
    8020249c:	fffff097          	auipc	ra,0xfffff
    802024a0:	a2c080e7          	jalr	-1492(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
    return fd;
    802024a4:	84ca                	mv	s1,s2
  }
  return -1;
}
    802024a6:	8526                	mv	a0,s1
    802024a8:	70a2                	ld	ra,40(sp)
    802024aa:	7402                	ld	s0,32(sp)
    802024ac:	64e2                	ld	s1,24(sp)
    802024ae:	6942                	ld	s2,16(sp)
    802024b0:	69a2                	ld	s3,8(sp)
    802024b2:	6a02                	ld	s4,0(sp)
    802024b4:	6145                	addi	sp,sp,48
    802024b6:	8082                	ret
    802024b8:	05098793          	addi	a5,s3,80
    for (int i = 0; i < NOFILE; i++) {
    802024bc:	4481                	li	s1,0
    802024be:	46a1                	li	a3,8
      if (task->openFiles[i] == NULL) {
    802024c0:	6398                	ld	a4,0(a5)
    802024c2:	cf11                	beqz	a4,802024de <_Z18registerFileHandleP4filei+0x82>
    for (int i = 0; i < NOFILE; i++) {
    802024c4:	2485                	addiw	s1,s1,1
    802024c6:	07a1                	addi	a5,a5,8
    802024c8:	fed49ce3          	bne	s1,a3,802024c0 <_Z18registerFileHandleP4filei+0x64>
    panic("register file handle");
    802024cc:	00008517          	auipc	a0,0x8
    802024d0:	1cc50513          	addi	a0,a0,460 # 8020a698 <_ZL6digits+0x390>
    802024d4:	ffffe097          	auipc	ra,0xffffe
    802024d8:	30e080e7          	jalr	782(ra) # 802007e2 <_Z5panicPKc>
    802024dc:	bf4d                	j	8020248e <_Z18registerFileHandleP4filei+0x32>
        task->openFiles[i] = fp;
    802024de:	00a48793          	addi	a5,s1,10
    802024e2:	078e                	slli	a5,a5,0x3
    802024e4:	97ce                	add	a5,a5,s3
    802024e6:	0147b023          	sd	s4,0(a5)
        task->lock.unlock();
    802024ea:	854e                	mv	a0,s3
    802024ec:	fffff097          	auipc	ra,0xfffff
    802024f0:	9dc080e7          	jalr	-1572(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
        return i;
    802024f4:	bf4d                	j	802024a6 <_Z18registerFileHandleP4filei+0x4a>
    return -1;
    802024f6:	54fd                	li	s1,-1
    802024f8:	b77d                	j	802024a6 <_Z18registerFileHandleP4filei+0x4a>
  return -1;
    802024fa:	54fd                	li	s1,-1
    802024fc:	b76d                	j	802024a6 <_Z18registerFileHandleP4filei+0x4a>

00000000802024fe <_Z11getFileByfdi>:
 * @brief 获取fd对应的file
 *
 * @param fd 文件描述符
 * @return struct file* 对应的文件描述符
 */
struct file *getFileByfd(int fd) {
    802024fe:	1101                	addi	sp,sp,-32
    80202500:	ec06                	sd	ra,24(sp)
    80202502:	e822                	sd	s0,16(sp)
    80202504:	e426                	sd	s1,8(sp)
    80202506:	e04a                	sd	s2,0(sp)
    80202508:	1000                	addi	s0,sp,32
    8020250a:	84aa                	mv	s1,a0
  Task *task = myTask();
    8020250c:	fffff097          	auipc	ra,0xfffff
    80202510:	500080e7          	jalr	1280(ra) # 80201a0c <_Z6myTaskv>
    80202514:	892a                	mv	s2,a0
  task->lock.lock();
    80202516:	fffff097          	auipc	ra,0xfffff
    8020251a:	936080e7          	jalr	-1738(ra) # 80200e4c <_ZN8SpinLock4lockEv>
  struct file *fp = myTask()->openFiles[fd];
    8020251e:	fffff097          	auipc	ra,0xfffff
    80202522:	4ee080e7          	jalr	1262(ra) # 80201a0c <_Z6myTaskv>
    80202526:	04a9                	addi	s1,s1,10
    80202528:	048e                	slli	s1,s1,0x3
    8020252a:	94aa                	add	s1,s1,a0
    8020252c:	6084                	ld	s1,0(s1)
  task->lock.unlock();
    8020252e:	854a                	mv	a0,s2
    80202530:	fffff097          	auipc	ra,0xfffff
    80202534:	998080e7          	jalr	-1640(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
  return fp;
    80202538:	8526                	mv	a0,s1
    8020253a:	60e2                	ld	ra,24(sp)
    8020253c:	6442                	ld	s0,16(sp)
    8020253e:	64a2                	ld	s1,8(sp)
    80202540:	6902                	ld	s2,0(sp)
    80202542:	6105                	addi	sp,sp,32
    80202544:	8082                	ret

0000000080202546 <_GLOBAL__sub_I_taskTable>:
    80202546:	1101                	addi	sp,sp,-32
    80202548:	ec06                	sd	ra,24(sp)
    8020254a:	e822                	sd	s0,16(sp)
    8020254c:	e426                	sd	s1,8(sp)
    8020254e:	e04a                	sd	s2,0(sp)
    80202550:	1000                	addi	s0,sp,32
Task taskTable[NTASK];
    80202552:	00087497          	auipc	s1,0x87
    80202556:	aae48493          	addi	s1,s1,-1362 # 80289000 <taskTable>
    8020255a:	0008b917          	auipc	s2,0x8b
    8020255e:	0f690913          	addi	s2,s2,246 # 8028d650 <initTask>

// extern struct cpu cpus[NCPU];
enum procstate { UNUSED, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };

// 进程
class Task {
    80202562:	8526                	mv	a0,s1
    80202564:	fffff097          	auipc	ra,0xfffff
    80202568:	860080e7          	jalr	-1952(ra) # 80200dc4 <_ZN8SpinLockC1Ev>
    8020256c:	16848493          	addi	s1,s1,360
    80202570:	ff2499e3          	bne	s1,s2,80202562 <_GLOBAL__sub_I_taskTable+0x1c>
    80202574:	60e2                	ld	ra,24(sp)
    80202576:	6442                	ld	s0,16(sp)
    80202578:	64a2                	ld	s1,8(sp)
    8020257a:	6902                	ld	s2,0(sp)
    8020257c:	6105                	addi	sp,sp,32
    8020257e:	8082                	ret

0000000080202580 <_ZN9SleepLock4initEPKc>:
#include "os/SleepLock.hpp"
#include "os/TaskScheduler.hpp"
#include "os/Process.hpp"

void SleepLock::init(const char *name) {
    80202580:	1101                	addi	sp,sp,-32
    80202582:	ec06                	sd	ra,24(sp)
    80202584:	e822                	sd	s0,16(sp)
    80202586:	e426                	sd	s1,8(sp)
    80202588:	e04a                	sd	s2,0(sp)
    8020258a:	1000                	addi	s0,sp,32
    8020258c:	84aa                	mv	s1,a0
    8020258e:	892e                	mv	s2,a1
  this->spinlock.init("sleep lock");
    80202590:	00008597          	auipc	a1,0x8
    80202594:	12058593          	addi	a1,a1,288 # 8020a6b0 <_ZL6digits+0x3a8>
    80202598:	0521                	addi	a0,a0,8
    8020259a:	fffff097          	auipc	ra,0xfffff
    8020259e:	85c080e7          	jalr	-1956(ra) # 80200df6 <_ZN8SpinLock4initEPKc>
  this->name = name;
    802025a2:	0324b023          	sd	s2,32(s1)
  this->locked = 0;
    802025a6:	0004a023          	sw	zero,0(s1)
  this->pid = 0;
    802025aa:	0204a423          	sw	zero,40(s1)
}
    802025ae:	60e2                	ld	ra,24(sp)
    802025b0:	6442                	ld	s0,16(sp)
    802025b2:	64a2                	ld	s1,8(sp)
    802025b4:	6902                	ld	s2,0(sp)
    802025b6:	6105                	addi	sp,sp,32
    802025b8:	8082                	ret

00000000802025ba <_ZN9SleepLock4lockEv>:

void SleepLock::lock() {
    802025ba:	1101                	addi	sp,sp,-32
    802025bc:	ec06                	sd	ra,24(sp)
    802025be:	e822                	sd	s0,16(sp)
    802025c0:	e426                	sd	s1,8(sp)
    802025c2:	e04a                	sd	s2,0(sp)
    802025c4:	1000                	addi	s0,sp,32
    802025c6:	84aa                	mv	s1,a0
  this->spinlock.lock();
    802025c8:	00850913          	addi	s2,a0,8
    802025cc:	854a                	mv	a0,s2
    802025ce:	fffff097          	auipc	ra,0xfffff
    802025d2:	87e080e7          	jalr	-1922(ra) # 80200e4c <_ZN8SpinLock4lockEv>
  while (this->locked) {
    802025d6:	409c                	lw	a5,0(s1)
    802025d8:	cb89                	beqz	a5,802025ea <_ZN9SleepLock4lockEv+0x30>
    sleep(this, &this->spinlock);
    802025da:	85ca                	mv	a1,s2
    802025dc:	8526                	mv	a0,s1
    802025de:	fffff097          	auipc	ra,0xfffff
    802025e2:	64e080e7          	jalr	1614(ra) # 80201c2c <_Z5sleepPvP8SpinLock>
  while (this->locked) {
    802025e6:	409c                	lw	a5,0(s1)
    802025e8:	fbed                	bnez	a5,802025da <_ZN9SleepLock4lockEv+0x20>
  }
  this->locked = 1;
    802025ea:	4785                	li	a5,1
    802025ec:	c09c                	sw	a5,0(s1)
  this->pid = myTask()->pid;
    802025ee:	fffff097          	auipc	ra,0xfffff
    802025f2:	41e080e7          	jalr	1054(ra) # 80201a0c <_Z6myTaskv>
    802025f6:	5d1c                	lw	a5,56(a0)
    802025f8:	d49c                	sw	a5,40(s1)
  this->spinlock.unlock();
    802025fa:	854a                	mv	a0,s2
    802025fc:	fffff097          	auipc	ra,0xfffff
    80202600:	8cc080e7          	jalr	-1844(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
}
    80202604:	60e2                	ld	ra,24(sp)
    80202606:	6442                	ld	s0,16(sp)
    80202608:	64a2                	ld	s1,8(sp)
    8020260a:	6902                	ld	s2,0(sp)
    8020260c:	6105                	addi	sp,sp,32
    8020260e:	8082                	ret

0000000080202610 <_ZN9SleepLock6unlockEv>:

void SleepLock::unlock(){
    80202610:	1101                	addi	sp,sp,-32
    80202612:	ec06                	sd	ra,24(sp)
    80202614:	e822                	sd	s0,16(sp)
    80202616:	e426                	sd	s1,8(sp)
    80202618:	e04a                	sd	s2,0(sp)
    8020261a:	1000                	addi	s0,sp,32
    8020261c:	84aa                	mv	s1,a0
  this->spinlock.lock();
    8020261e:	00850913          	addi	s2,a0,8
    80202622:	854a                	mv	a0,s2
    80202624:	fffff097          	auipc	ra,0xfffff
    80202628:	828080e7          	jalr	-2008(ra) # 80200e4c <_ZN8SpinLock4lockEv>
  this->locked = 0;
    8020262c:	0004a023          	sw	zero,0(s1)
  this->pid = 0;
    80202630:	0204a423          	sw	zero,40(s1)
  wakeup(this);
    80202634:	8526                	mv	a0,s1
    80202636:	fffff097          	auipc	ra,0xfffff
    8020263a:	6ea080e7          	jalr	1770(ra) # 80201d20 <_Z6wakeupPv>
  this->spinlock.unlock();
    8020263e:	854a                	mv	a0,s2
    80202640:	fffff097          	auipc	ra,0xfffff
    80202644:	888080e7          	jalr	-1912(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
    80202648:	60e2                	ld	ra,24(sp)
    8020264a:	6442                	ld	s0,16(sp)
    8020264c:	64a2                	ld	s1,8(sp)
    8020264e:	6902                	ld	s2,0(sp)
    80202650:	6105                	addi	sp,sp,32
    80202652:	8082                	ret

0000000080202654 <pswitch>:
    80202654:	00153023          	sd	ra,0(a0)
    80202658:	00253423          	sd	sp,8(a0)
    8020265c:	e900                	sd	s0,16(a0)
    8020265e:	ed04                	sd	s1,24(a0)
    80202660:	03253023          	sd	s2,32(a0)
    80202664:	03353423          	sd	s3,40(a0)
    80202668:	03453823          	sd	s4,48(a0)
    8020266c:	03553c23          	sd	s5,56(a0)
    80202670:	05653023          	sd	s6,64(a0)
    80202674:	05753423          	sd	s7,72(a0)
    80202678:	05853823          	sd	s8,80(a0)
    8020267c:	05953c23          	sd	s9,88(a0)
    80202680:	07a53023          	sd	s10,96(a0)
    80202684:	07b53423          	sd	s11,104(a0)
    80202688:	0005b083          	ld	ra,0(a1)
    8020268c:	0085b103          	ld	sp,8(a1)
    80202690:	6980                	ld	s0,16(a1)
    80202692:	6d84                	ld	s1,24(a1)
    80202694:	0205b903          	ld	s2,32(a1)
    80202698:	0285b983          	ld	s3,40(a1)
    8020269c:	0305ba03          	ld	s4,48(a1)
    802026a0:	0385ba83          	ld	s5,56(a1)
    802026a4:	0405bb03          	ld	s6,64(a1)
    802026a8:	0485bb83          	ld	s7,72(a1)
    802026ac:	0505bc03          	ld	s8,80(a1)
    802026b0:	0585bc83          	ld	s9,88(a1)
    802026b4:	0605bd03          	ld	s10,96(a1)
    802026b8:	0685bd83          	ld	s11,104(a1)
    802026bc:	8082                	ret

00000000802026be <_Z6argrawi>:
#include "os/TaskScheduler.hpp"
#include "param.hpp"
#include "riscv.hpp"
#include "types.hpp"

uint64_t argraw(int n) {
    802026be:	1101                	addi	sp,sp,-32
    802026c0:	ec06                	sd	ra,24(sp)
    802026c2:	e822                	sd	s0,16(sp)
    802026c4:	e426                	sd	s1,8(sp)
    802026c6:	1000                	addi	s0,sp,32
    802026c8:	84aa                	mv	s1,a0
  Task *task = myTask();
    802026ca:	fffff097          	auipc	ra,0xfffff
    802026ce:	342080e7          	jalr	834(ra) # 80201a0c <_Z6myTaskv>
  switch (n) {
    802026d2:	4795                	li	a5,5
    802026d4:	0497e163          	bltu	a5,s1,80202716 <_Z6argrawi+0x58>
    802026d8:	048a                	slli	s1,s1,0x2
    802026da:	00008717          	auipc	a4,0x8
    802026de:	01e70713          	addi	a4,a4,30 # 8020a6f8 <_ZL6digits+0x3f0>
    802026e2:	94ba                	add	s1,s1,a4
    802026e4:	409c                	lw	a5,0(s1)
    802026e6:	97ba                	add	a5,a5,a4
    802026e8:	8782                	jr	a5
    case 0:
      return task->trapframe->a0;
    802026ea:	613c                	ld	a5,64(a0)
    802026ec:	7ba8                	ld	a0,112(a5)
    case 5:
      return task->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    802026ee:	60e2                	ld	ra,24(sp)
    802026f0:	6442                	ld	s0,16(sp)
    802026f2:	64a2                	ld	s1,8(sp)
    802026f4:	6105                	addi	sp,sp,32
    802026f6:	8082                	ret
      return task->trapframe->a1;
    802026f8:	613c                	ld	a5,64(a0)
    802026fa:	7fa8                	ld	a0,120(a5)
    802026fc:	bfcd                	j	802026ee <_Z6argrawi+0x30>
      return task->trapframe->a2;
    802026fe:	613c                	ld	a5,64(a0)
    80202700:	63c8                	ld	a0,128(a5)
    80202702:	b7f5                	j	802026ee <_Z6argrawi+0x30>
      return task->trapframe->a3;
    80202704:	613c                	ld	a5,64(a0)
    80202706:	67c8                	ld	a0,136(a5)
    80202708:	b7dd                	j	802026ee <_Z6argrawi+0x30>
      return task->trapframe->a4;
    8020270a:	613c                	ld	a5,64(a0)
    8020270c:	6bc8                	ld	a0,144(a5)
    8020270e:	b7c5                	j	802026ee <_Z6argrawi+0x30>
      return task->trapframe->a5;
    80202710:	613c                	ld	a5,64(a0)
    80202712:	6fc8                	ld	a0,152(a5)
    80202714:	bfe9                	j	802026ee <_Z6argrawi+0x30>
  panic("argraw");
    80202716:	00008517          	auipc	a0,0x8
    8020271a:	faa50513          	addi	a0,a0,-86 # 8020a6c0 <_ZL6digits+0x3b8>
    8020271e:	ffffe097          	auipc	ra,0xffffe
    80202722:	0c4080e7          	jalr	196(ra) # 802007e2 <_Z5panicPKc>
  return -1;
    80202726:	557d                	li	a0,-1
    80202728:	b7d9                	j	802026ee <_Z6argrawi+0x30>

000000008020272a <_Z9fetchaddrmPm>:

// 获取当前进程addr处的一个uint64_t值
int fetchaddr(uint64_t addr, uint64_t *ip) {
    8020272a:	1101                	addi	sp,sp,-32
    8020272c:	ec06                	sd	ra,24(sp)
    8020272e:	e822                	sd	s0,16(sp)
    80202730:	e426                	sd	s1,8(sp)
    80202732:	e04a                	sd	s2,0(sp)
    80202734:	1000                	addi	s0,sp,32
    80202736:	84aa                	mv	s1,a0
    80202738:	892e                	mv	s2,a1
  Task *task = myTask();
    8020273a:	fffff097          	auipc	ra,0xfffff
    8020273e:	2d2080e7          	jalr	722(ra) # 80201a0c <_Z6myTaskv>
  if (addr >= static_cast<uint64_t>(task->sz) || addr + sizeof(uint64_t) > static_cast<uint64_t>(task->sz)) return -1;
    80202742:	16052783          	lw	a5,352(a0)
    80202746:	02f4f863          	bgeu	s1,a5,80202776 <_Z9fetchaddrmPm+0x4c>
    8020274a:	00848713          	addi	a4,s1,8
    8020274e:	02e7e663          	bltu	a5,a4,8020277a <_Z9fetchaddrmPm+0x50>
  if (copyin(task->pagetable, (char *)ip, addr, sizeof(*ip)) != 0) return -1;
    80202752:	46a1                	li	a3,8
    80202754:	8626                	mv	a2,s1
    80202756:	85ca                	mv	a1,s2
    80202758:	6528                	ld	a0,72(a0)
    8020275a:	00005097          	auipc	ra,0x5
    8020275e:	a04080e7          	jalr	-1532(ra) # 8020715e <_Z6copyinPmPcmm>
    80202762:	00a03533          	snez	a0,a0
    80202766:	40a00533          	neg	a0,a0
  return 0;
}
    8020276a:	60e2                	ld	ra,24(sp)
    8020276c:	6442                	ld	s0,16(sp)
    8020276e:	64a2                	ld	s1,8(sp)
    80202770:	6902                	ld	s2,0(sp)
    80202772:	6105                	addi	sp,sp,32
    80202774:	8082                	ret
  if (addr >= static_cast<uint64_t>(task->sz) || addr + sizeof(uint64_t) > static_cast<uint64_t>(task->sz)) return -1;
    80202776:	557d                	li	a0,-1
    80202778:	bfcd                	j	8020276a <_Z9fetchaddrmPm+0x40>
    8020277a:	557d                	li	a0,-1
    8020277c:	b7fd                	j	8020276a <_Z9fetchaddrmPm+0x40>

000000008020277e <_Z6argintiPi>:

/**
 * 获取第n个int类型参数
 */
int argint(int n, int *addr) {
    8020277e:	1101                	addi	sp,sp,-32
    80202780:	ec06                	sd	ra,24(sp)
    80202782:	e822                	sd	s0,16(sp)
    80202784:	e426                	sd	s1,8(sp)
    80202786:	1000                	addi	s0,sp,32
    80202788:	84ae                	mv	s1,a1
  *addr = argraw(n);
    8020278a:	00000097          	auipc	ra,0x0
    8020278e:	f34080e7          	jalr	-204(ra) # 802026be <_Z6argrawi>
    80202792:	c088                	sw	a0,0(s1)
  return 0;
}
    80202794:	4501                	li	a0,0
    80202796:	60e2                	ld	ra,24(sp)
    80202798:	6442                	ld	s0,16(sp)
    8020279a:	64a2                	ld	s1,8(sp)
    8020279c:	6105                	addi	sp,sp,32
    8020279e:	8082                	ret

00000000802027a0 <_Z7argaddriPm>:
 *
 * @param n 参数的偏移量
 * @param ip 结果地址
 * @return
 */
int argaddr(int n, uint64_t *addr) {
    802027a0:	1101                	addi	sp,sp,-32
    802027a2:	ec06                	sd	ra,24(sp)
    802027a4:	e822                	sd	s0,16(sp)
    802027a6:	e426                	sd	s1,8(sp)
    802027a8:	1000                	addi	s0,sp,32
    802027aa:	84ae                	mv	s1,a1
  *addr = argraw(n);
    802027ac:	00000097          	auipc	ra,0x0
    802027b0:	f12080e7          	jalr	-238(ra) # 802026be <_Z6argrawi>
    802027b4:	e088                	sd	a0,0(s1)
  return 0;
}
    802027b6:	4501                	li	a0,0
    802027b8:	60e2                	ld	ra,24(sp)
    802027ba:	6442                	ld	s0,16(sp)
    802027bc:	64a2                	ld	s1,8(sp)
    802027be:	6105                	addi	sp,sp,32
    802027c0:	8082                	ret

00000000802027c2 <_Z8fetchstrmPci>:
/**
 * 从当前进程的addr位置取出0结束的字符串。
 * 返回字符串的长度, 不包括0, 失败返回-1
 * @return
 */
int fetchstr(uint64_t addr, char *buf, int max) {
    802027c2:	7179                	addi	sp,sp,-48
    802027c4:	f406                	sd	ra,40(sp)
    802027c6:	f022                	sd	s0,32(sp)
    802027c8:	ec26                	sd	s1,24(sp)
    802027ca:	e84a                	sd	s2,16(sp)
    802027cc:	e44e                	sd	s3,8(sp)
    802027ce:	1800                	addi	s0,sp,48
    802027d0:	892a                	mv	s2,a0
    802027d2:	84ae                	mv	s1,a1
    802027d4:	89b2                	mv	s3,a2
  Task *task = myTask();
    802027d6:	fffff097          	auipc	ra,0xfffff
    802027da:	236080e7          	jalr	566(ra) # 80201a0c <_Z6myTaskv>
  int err = copyinstr(task->pagetable, buf, addr, max);
    802027de:	86ce                	mv	a3,s3
    802027e0:	864a                	mv	a2,s2
    802027e2:	85a6                	mv	a1,s1
    802027e4:	6528                	ld	a0,72(a0)
    802027e6:	00005097          	auipc	ra,0x5
    802027ea:	a02080e7          	jalr	-1534(ra) # 802071e8 <_Z9copyinstrPmPcmi>
  if (err < 0) return err;
    802027ee:	00054763          	bltz	a0,802027fc <_Z8fetchstrmPci+0x3a>
  return strlen(buf);
    802027f2:	8526                	mv	a0,s1
    802027f4:	ffffe097          	auipc	ra,0xffffe
    802027f8:	558080e7          	jalr	1368(ra) # 80200d4c <_Z6strlenPKc>
}
    802027fc:	70a2                	ld	ra,40(sp)
    802027fe:	7402                	ld	s0,32(sp)
    80202800:	64e2                	ld	s1,24(sp)
    80202802:	6942                	ld	s2,16(sp)
    80202804:	69a2                	ld	s3,8(sp)
    80202806:	6145                	addi	sp,sp,48
    80202808:	8082                	ret

000000008020280a <_Z6argstriPci>:

/**
 * 获取第n个系统调用参数作为0结束的字符串
 *  复制到buf中, 最多复制max
 */
int argstr(int n, char *buf, int max) {
    8020280a:	1101                	addi	sp,sp,-32
    8020280c:	ec06                	sd	ra,24(sp)
    8020280e:	e822                	sd	s0,16(sp)
    80202810:	e426                	sd	s1,8(sp)
    80202812:	e04a                	sd	s2,0(sp)
    80202814:	1000                	addi	s0,sp,32
    80202816:	84ae                	mv	s1,a1
    80202818:	8932                	mv	s2,a2
  *addr = argraw(n);
    8020281a:	00000097          	auipc	ra,0x0
    8020281e:	ea4080e7          	jalr	-348(ra) # 802026be <_Z6argrawi>
  uint64_t addr;
  if (argaddr(n, &addr) < 0) return -1;
  return fetchstr(addr, buf, max);
    80202822:	864a                	mv	a2,s2
    80202824:	85a6                	mv	a1,s1
    80202826:	00000097          	auipc	ra,0x0
    8020282a:	f9c080e7          	jalr	-100(ra) # 802027c2 <_Z8fetchstrmPci>
}
    8020282e:	60e2                	ld	ra,24(sp)
    80202830:	6442                	ld	s0,16(sp)
    80202832:	64a2                	ld	s1,8(sp)
    80202834:	6902                	ld	s2,0(sp)
    80202836:	6105                	addi	sp,sp,32
    80202838:	8082                	ret

000000008020283a <_Z12syscall_initv>:

static uint64_t (*syscalls[400])(void);

// #define NELEM(x) (sizeof(x) / sizeof((x)[0]))

void syscall_init() {
    8020283a:	1141                	addi	sp,sp,-16
    8020283c:	e422                	sd	s0,8(sp)
    8020283e:	0800                	addi	s0,sp,16
  syscalls[SYS_execve] = sys_exec;
    80202840:	0008b797          	auipc	a5,0x8b
    80202844:	e1878793          	addi	a5,a5,-488 # 8028d658 <_ZL8syscalls>
    80202848:	00000717          	auipc	a4,0x0
    8020284c:	18870713          	addi	a4,a4,392 # 802029d0 <_Z8sys_execv>
    80202850:	6ee7b423          	sd	a4,1768(a5)
  syscalls[SYS_open] = sys_open;
    80202854:	00000717          	auipc	a4,0x0
    80202858:	49470713          	addi	a4,a4,1172 # 80202ce8 <_Z8sys_openv>
    8020285c:	eb98                	sd	a4,16(a5)
  syscalls[SYS_write] = sys_write;
    8020285e:	00000717          	auipc	a4,0x0
    80202862:	62e70713          	addi	a4,a4,1582 # 80202e8c <_Z9sys_writev>
    80202866:	20e7b023          	sd	a4,512(a5)
  syscalls[SYS_read] = sys_read;
    8020286a:	00000717          	auipc	a4,0x0
    8020286e:	68a70713          	addi	a4,a4,1674 # 80202ef4 <_Z8sys_readv>
    80202872:	1ee7bc23          	sd	a4,504(a5)
  syscalls[SYS_dup] = sys_dup;
    80202876:	00000717          	auipc	a4,0x0
    8020287a:	6e670713          	addi	a4,a4,1766 # 80202f5c <_Z7sys_dupv>
    8020287e:	ffd8                	sd	a4,184(a5)
  syscalls[SYS_dup3] = sys_dup3;
    80202880:	00000717          	auipc	a4,0x0
    80202884:	78470713          	addi	a4,a4,1924 # 80203004 <_Z8sys_dup3v>
    80202888:	e3f8                	sd	a4,192(a5)
  syscalls[SYS_getcwd] = sys_getcwd;
    8020288a:	00000717          	auipc	a4,0x0
    8020288e:	39270713          	addi	a4,a4,914 # 80202c1c <_Z10sys_getcwdv>
    80202892:	e7d8                	sd	a4,136(a5)
  syscalls[SYS_getpid] = sys_getpid;
    80202894:	00000717          	auipc	a4,0x0
    80202898:	35270713          	addi	a4,a4,850 # 80202be6 <_Z10sys_getpidv>
    8020289c:	56e7b023          	sd	a4,1376(a5)
  syscalls[SYS_getppid] = sys_getppid;
    802028a0:	00000717          	auipc	a4,0x0
    802028a4:	36070713          	addi	a4,a4,864 # 80202c00 <_Z11sys_getppidv>
    802028a8:	56e7b423          	sd	a4,1384(a5)
  syscalls[SYS_fork] = sys_fork;
    802028ac:	00000717          	auipc	a4,0x0
    802028b0:	10c70713          	addi	a4,a4,268 # 802029b8 <_Z8sys_forkv>
    802028b4:	e798                	sd	a4,8(a5)
  syscalls[SYS_exit] = sys_exit;
    802028b6:	00000717          	auipc	a4,0x0
    802028ba:	0ce70713          	addi	a4,a4,206 # 80202984 <_Z8sys_exitv>
    802028be:	2ee7b423          	sd	a4,744(a5)
  syscalls[SYS_wait] = sys_wait;
    802028c2:	00000717          	auipc	a4,0x0
    802028c6:	24470713          	addi	a4,a4,580 # 80202b06 <_Z8sys_waitv>
    802028ca:	ef98                	sd	a4,24(a5)
  syscalls[SYS_wait4] = sys_wait4;
    802028cc:	00000717          	auipc	a4,0x0
    802028d0:	26c70713          	addi	a4,a4,620 # 80202b38 <_Z9sys_wait4v>
    802028d4:	0008b697          	auipc	a3,0x8b
    802028d8:	5ae6b223          	sd	a4,1444(a3) # 8028de78 <_ZL8syscalls+0x820>
  syscalls[SYS_chdir] = sys_chdir;
    802028dc:	00000717          	auipc	a4,0x0
    802028e0:	7ee70713          	addi	a4,a4,2030 # 802030ca <_Z9sys_chdirv>
    802028e4:	18e7b423          	sd	a4,392(a5)
  syscalls[SYS_close] = sys_close;
    802028e8:	00000717          	auipc	a4,0x0
    802028ec:	49870713          	addi	a4,a4,1176 # 80202d80 <_Z9sys_closev>
    802028f0:	1ce7b423          	sd	a4,456(a5)
  syscalls[SYS_mkdirat] = sys_mkdirat;
    802028f4:	00000717          	auipc	a4,0x0
    802028f8:	78670713          	addi	a4,a4,1926 # 8020307a <_Z11sys_mkdiratv>
    802028fc:	10e7b823          	sd	a4,272(a5)
}
    80202900:	6422                	ld	s0,8(sp)
    80202902:	0141                	addi	sp,sp,16
    80202904:	8082                	ret

0000000080202906 <_Z7syscallv>:

void syscall(void) {
    80202906:	1101                	addi	sp,sp,-32
    80202908:	ec06                	sd	ra,24(sp)
    8020290a:	e822                	sd	s0,16(sp)
    8020290c:	e426                	sd	s1,8(sp)
    8020290e:	e04a                	sd	s2,0(sp)
    80202910:	1000                	addi	s0,sp,32
  int num;
  Task *task = myTask();
    80202912:	fffff097          	auipc	ra,0xfffff
    80202916:	0fa080e7          	jalr	250(ra) # 80201a0c <_Z6myTaskv>
    8020291a:	84aa                	mv	s1,a0
  num = task->trapframe->a7;
    8020291c:	04053903          	ld	s2,64(a0)
    80202920:	0a893783          	ld	a5,168(s2)
    80202924:	0007869b          	sext.w	a3,a5
  if (num > 0 && static_cast<uint64_t>(num) < NELEM(syscalls) && syscalls[num]) {
    80202928:	37fd                	addiw	a5,a5,-1
    8020292a:	18e00713          	li	a4,398
    8020292e:	00f76f63          	bltu	a4,a5,8020294c <_Z7syscallv+0x46>
    80202932:	00369713          	slli	a4,a3,0x3
    80202936:	0008b797          	auipc	a5,0x8b
    8020293a:	d2278793          	addi	a5,a5,-734 # 8028d658 <_ZL8syscalls>
    8020293e:	97ba                	add	a5,a5,a4
    80202940:	639c                	ld	a5,0(a5)
    80202942:	c789                	beqz	a5,8020294c <_Z7syscallv+0x46>
    task->trapframe->a0 = syscalls[num]();
    80202944:	9782                	jalr	a5
    80202946:	06a93823          	sd	a0,112(s2)
    8020294a:	a03d                	j	80202978 <_Z7syscallv+0x72>
  } else {
    printf("%d %s: unknown sys call %d\n", task->pid, task->name, num);
    8020294c:	15048613          	addi	a2,s1,336
    80202950:	5c8c                	lw	a1,56(s1)
    80202952:	00008517          	auipc	a0,0x8
    80202956:	d7650513          	addi	a0,a0,-650 # 8020a6c8 <_ZL6digits+0x3c0>
    8020295a:	ffffe097          	auipc	ra,0xffffe
    8020295e:	efa080e7          	jalr	-262(ra) # 80200854 <_Z6printfPKcz>
    task->trapframe->a0 = -1;
    80202962:	60bc                	ld	a5,64(s1)
    80202964:	577d                	li	a4,-1
    80202966:	fbb8                	sd	a4,112(a5)
    panic("syscall error");
    80202968:	00008517          	auipc	a0,0x8
    8020296c:	d8050513          	addi	a0,a0,-640 # 8020a6e8 <_ZL6digits+0x3e0>
    80202970:	ffffe097          	auipc	ra,0xffffe
    80202974:	e72080e7          	jalr	-398(ra) # 802007e2 <_Z5panicPKc>
  }
}
    80202978:	60e2                	ld	ra,24(sp)
    8020297a:	6442                	ld	s0,16(sp)
    8020297c:	64a2                	ld	s1,8(sp)
    8020297e:	6902                	ld	s2,0(sp)
    80202980:	6105                	addi	sp,sp,32
    80202982:	8082                	ret

0000000080202984 <_Z8sys_exitv>:
#include "riscv.hpp"
#include "types.hpp"

extern MemAllocator memAllocator;

uint64_t sys_exit(void) {
    80202984:	1101                	addi	sp,sp,-32
    80202986:	ec06                	sd	ra,24(sp)
    80202988:	e822                	sd	s0,16(sp)
    8020298a:	1000                	addi	s0,sp,32
  int n;
  if (argint(0, &n) < 0) return -1;
    8020298c:	fec40593          	addi	a1,s0,-20
    80202990:	4501                	li	a0,0
    80202992:	00000097          	auipc	ra,0x0
    80202996:	dec080e7          	jalr	-532(ra) # 8020277e <_Z6argintiPi>
    8020299a:	57fd                	li	a5,-1
    8020299c:	00054963          	bltz	a0,802029ae <_Z8sys_exitv+0x2a>
  exit(n);
    802029a0:	fec42503          	lw	a0,-20(s0)
    802029a4:	00000097          	auipc	ra,0x0
    802029a8:	874080e7          	jalr	-1932(ra) # 80202218 <_Z4exiti>
  return 0;  // not reached
    802029ac:	4781                	li	a5,0
}
    802029ae:	853e                	mv	a0,a5
    802029b0:	60e2                	ld	ra,24(sp)
    802029b2:	6442                	ld	s0,16(sp)
    802029b4:	6105                	addi	sp,sp,32
    802029b6:	8082                	ret

00000000802029b8 <_Z8sys_forkv>:

uint64_t sys_fork(void) { return fork(); }
    802029b8:	1141                	addi	sp,sp,-16
    802029ba:	e406                	sd	ra,8(sp)
    802029bc:	e022                	sd	s0,0(sp)
    802029be:	0800                	addi	s0,sp,16
    802029c0:	fffff097          	auipc	ra,0xfffff
    802029c4:	46a080e7          	jalr	1130(ra) # 80201e2a <_Z4forkv>
    802029c8:	60a2                	ld	ra,8(sp)
    802029ca:	6402                	ld	s0,0(sp)
    802029cc:	0141                	addi	sp,sp,16
    802029ce:	8082                	ret

00000000802029d0 <_Z8sys_execv>:

uint64_t sys_exec(void) {
    802029d0:	7165                	addi	sp,sp,-400
    802029d2:	e706                	sd	ra,392(sp)
    802029d4:	e322                	sd	s0,384(sp)
    802029d6:	fea6                	sd	s1,376(sp)
    802029d8:	faca                	sd	s2,368(sp)
    802029da:	f6ce                	sd	s3,360(sp)
    802029dc:	f2d2                	sd	s4,352(sp)
    802029de:	eed6                	sd	s5,344(sp)
    802029e0:	eada                	sd	s6,336(sp)
    802029e2:	0b00                	addi	s0,sp,400
  char path[MAXPATH], *argv[MAXARG];
  uint64_t uargv, uarg = 0;
    802029e4:	e6043823          	sd	zero,-400(s0)
  int ret = 0;
  if (argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0) return -1;
    802029e8:	04000613          	li	a2,64
    802029ec:	f8040593          	addi	a1,s0,-128
    802029f0:	4501                	li	a0,0
    802029f2:	00000097          	auipc	ra,0x0
    802029f6:	e18080e7          	jalr	-488(ra) # 8020280a <_Z6argstriPci>
    802029fa:	54fd                	li	s1,-1
    802029fc:	0e054a63          	bltz	a0,80202af0 <_Z8sys_execv+0x120>
    80202a00:	e7840593          	addi	a1,s0,-392
    80202a04:	4505                	li	a0,1
    80202a06:	00000097          	auipc	ra,0x0
    80202a0a:	d9a080e7          	jalr	-614(ra) # 802027a0 <_Z7argaddriPm>
    80202a0e:	0e054163          	bltz	a0,80202af0 <_Z8sys_execv+0x120>
  if (strlen(path) < 1) return -1;
    80202a12:	f8040513          	addi	a0,s0,-128
    80202a16:	ffffe097          	auipc	ra,0xffffe
    80202a1a:	336080e7          	jalr	822(ra) # 80200d4c <_Z6strlenPKc>
    80202a1e:	0ca05963          	blez	a0,80202af0 <_Z8sys_execv+0x120>
  memset(argv, 0, sizeof(argv));
    80202a22:	10000613          	li	a2,256
    80202a26:	4581                	li	a1,0
    80202a28:	e8040513          	addi	a0,s0,-384
    80202a2c:	ffffe097          	auipc	ra,0xffffe
    80202a30:	130080e7          	jalr	304(ra) # 80200b5c <_Z6memsetPvij>
  for (int i = 0;; i++) {
    if (i > MAXARG) goto bad;
    80202a34:	e8040913          	addi	s2,s0,-384
  memset(argv, 0, sizeof(argv));
    80202a38:	89ca                	mv	s3,s2
    80202a3a:	4481                	li	s1,0
    if (fetchaddr(uargv + sizeof(uint64_t) * i, &uarg) < 0) goto bad;
    if (uarg == 0) {
      argv[i] = 0;
      break;
    }
    argv[i] = reinterpret_cast<char *>(memAllocator.alloc());
    80202a3c:	00011a17          	auipc	s4,0x11
    80202a40:	664a0a13          	addi	s4,s4,1636 # 802140a0 <memAllocator>
    if (i > MAXARG) goto bad;
    80202a44:	02100a93          	li	s5,33
    80202a48:	00048b1b          	sext.w	s6,s1
    if (fetchaddr(uargv + sizeof(uint64_t) * i, &uarg) < 0) goto bad;
    80202a4c:	00349513          	slli	a0,s1,0x3
    80202a50:	e7040593          	addi	a1,s0,-400
    80202a54:	e7843783          	ld	a5,-392(s0)
    80202a58:	953e                	add	a0,a0,a5
    80202a5a:	00000097          	auipc	ra,0x0
    80202a5e:	cd0080e7          	jalr	-816(ra) # 8020272a <_Z9fetchaddrmPm>
    80202a62:	02054b63          	bltz	a0,80202a98 <_Z8sys_execv+0xc8>
    if (uarg == 0) {
    80202a66:	e7043783          	ld	a5,-400(s0)
    80202a6a:	cf85                	beqz	a5,80202aa2 <_Z8sys_execv+0xd2>
    argv[i] = reinterpret_cast<char *>(memAllocator.alloc());
    80202a6c:	8552                	mv	a0,s4
    80202a6e:	00005097          	auipc	ra,0x5
    80202a72:	acc080e7          	jalr	-1332(ra) # 8020753a <_ZN12MemAllocator5allocEv>
    80202a76:	85aa                	mv	a1,a0
    80202a78:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0) goto bad;
    80202a7c:	cd11                	beqz	a0,80202a98 <_Z8sys_execv+0xc8>
    if (fetchstr(uarg, argv[i], PGSIZE) < 0) goto bad;
    80202a7e:	6605                	lui	a2,0x1
    80202a80:	e7043503          	ld	a0,-400(s0)
    80202a84:	00000097          	auipc	ra,0x0
    80202a88:	d3e080e7          	jalr	-706(ra) # 802027c2 <_Z8fetchstrmPci>
    80202a8c:	00054663          	bltz	a0,80202a98 <_Z8sys_execv+0xc8>
    if (i > MAXARG) goto bad;
    80202a90:	0485                	addi	s1,s1,1
    80202a92:	09a1                	addi	s3,s3,8
    80202a94:	fb549ae3          	bne	s1,s5,80202a48 <_Z8sys_execv+0x78>
  LOG_TRACE("exec over");
  return ret;

bad:
  LOG_TRACE("exec bad");
  for (int i = 0; i <= MAXARG && argv[i] != 0; i++) memAllocator.free(argv[i]);
    80202a98:	00011497          	auipc	s1,0x11
    80202a9c:	60848493          	addi	s1,s1,1544 # 802140a0 <memAllocator>
    80202aa0:	a099                	j	80202ae6 <_Z8sys_execv+0x116>
      argv[i] = 0;
    80202aa2:	0b0e                	slli	s6,s6,0x3
    80202aa4:	fc040793          	addi	a5,s0,-64
    80202aa8:	9b3e                	add	s6,s6,a5
    80202aaa:	ec0b3023          	sd	zero,-320(s6)
  ret = exec(path, argv);
    80202aae:	e8040593          	addi	a1,s0,-384
    80202ab2:	f8040513          	addi	a0,s0,-128
    80202ab6:	00000097          	auipc	ra,0x0
    80202aba:	65c080e7          	jalr	1628(ra) # 80203112 <_Z4execPcPS_>
    80202abe:	84aa                	mv	s1,a0
  for (int i = 0; i <= MAXARG && argv[i] != 0; i++) memAllocator.free(argv[i]);
    80202ac0:	00011997          	auipc	s3,0x11
    80202ac4:	5e098993          	addi	s3,s3,1504 # 802140a0 <memAllocator>
    80202ac8:	0921                	addi	s2,s2,8
    80202aca:	ff893583          	ld	a1,-8(s2)
    80202ace:	c18d                	beqz	a1,80202af0 <_Z8sys_execv+0x120>
    80202ad0:	854e                	mv	a0,s3
    80202ad2:	00005097          	auipc	ra,0x5
    80202ad6:	abe080e7          	jalr	-1346(ra) # 80207590 <_ZN12MemAllocator4freeEPv>
    80202ada:	b7fd                	j	80202ac8 <_Z8sys_execv+0xf8>
  for (int i = 0; i <= MAXARG && argv[i] != 0; i++) memAllocator.free(argv[i]);
    80202adc:	8526                	mv	a0,s1
    80202ade:	00005097          	auipc	ra,0x5
    80202ae2:	ab2080e7          	jalr	-1358(ra) # 80207590 <_ZN12MemAllocator4freeEPv>
    80202ae6:	0921                	addi	s2,s2,8
    80202ae8:	ff893583          	ld	a1,-8(s2)
    80202aec:	f9e5                	bnez	a1,80202adc <_Z8sys_execv+0x10c>
  return -1;
    80202aee:	54fd                	li	s1,-1
}
    80202af0:	8526                	mv	a0,s1
    80202af2:	60ba                	ld	ra,392(sp)
    80202af4:	641a                	ld	s0,384(sp)
    80202af6:	74f6                	ld	s1,376(sp)
    80202af8:	7956                	ld	s2,368(sp)
    80202afa:	79b6                	ld	s3,360(sp)
    80202afc:	7a16                	ld	s4,352(sp)
    80202afe:	6af6                	ld	s5,344(sp)
    80202b00:	6b56                	ld	s6,336(sp)
    80202b02:	6159                	addi	sp,sp,400
    80202b04:	8082                	ret

0000000080202b06 <_Z8sys_waitv>:

uint64_t sys_wait(void) {
    80202b06:	1101                	addi	sp,sp,-32
    80202b08:	ec06                	sd	ra,24(sp)
    80202b0a:	e822                	sd	s0,16(sp)
    80202b0c:	1000                	addi	s0,sp,32
  uint64_t vaddr;
  if (argaddr(0, &vaddr) < 0) {
    80202b0e:	fe840593          	addi	a1,s0,-24
    80202b12:	4501                	li	a0,0
    80202b14:	00000097          	auipc	ra,0x0
    80202b18:	c8c080e7          	jalr	-884(ra) # 802027a0 <_Z7argaddriPm>
    80202b1c:	87aa                	mv	a5,a0
    return -1;
    80202b1e:	557d                	li	a0,-1
  if (argaddr(0, &vaddr) < 0) {
    80202b20:	0007c863          	bltz	a5,80202b30 <_Z8sys_waitv+0x2a>
  }
  return wait(vaddr);
    80202b24:	fe843503          	ld	a0,-24(s0)
    80202b28:	fffff097          	auipc	ra,0xfffff
    80202b2c:	3fc080e7          	jalr	1020(ra) # 80201f24 <_Z4waitm>
}
    80202b30:	60e2                	ld	ra,24(sp)
    80202b32:	6442                	ld	s0,16(sp)
    80202b34:	6105                	addi	sp,sp,32
    80202b36:	8082                	ret

0000000080202b38 <_Z9sys_wait4v>:

uint64_t sys_wait4(void) {
    80202b38:	1101                	addi	sp,sp,-32
    80202b3a:	ec06                	sd	ra,24(sp)
    80202b3c:	e822                	sd	s0,16(sp)
    80202b3e:	1000                	addi	s0,sp,32
  int pid;
  uint64_t uaddr;
  if (argint(0, &pid) < 0 || argaddr(1, &uaddr) < 0) {
    80202b40:	fec40593          	addi	a1,s0,-20
    80202b44:	4501                	li	a0,0
    80202b46:	00000097          	auipc	ra,0x0
    80202b4a:	c38080e7          	jalr	-968(ra) # 8020277e <_Z6argintiPi>
    return -1;
    80202b4e:	57fd                	li	a5,-1
  if (argint(0, &pid) < 0 || argaddr(1, &uaddr) < 0) {
    80202b50:	06054e63          	bltz	a0,80202bcc <_Z9sys_wait4v+0x94>
    80202b54:	fe040593          	addi	a1,s0,-32
    80202b58:	4505                	li	a0,1
    80202b5a:	00000097          	auipc	ra,0x0
    80202b5e:	c46080e7          	jalr	-954(ra) # 802027a0 <_Z7argaddriPm>
    return -1;
    80202b62:	57fd                	li	a5,-1
  if (argint(0, &pid) < 0 || argaddr(1, &uaddr) < 0) {
    80202b64:	06054463          	bltz	a0,80202bcc <_Z9sys_wait4v+0x94>
    80202b68:	00008717          	auipc	a4,0x8
    80202b6c:	ba870713          	addi	a4,a4,-1112 # 8020a710 <_ZL6digits+0x408>
    80202b70:	04300693          	li	a3,67
    80202b74:	00008617          	auipc	a2,0x8
    80202b78:	bac60613          	addi	a2,a2,-1108 # 8020a720 <_ZL6digits+0x418>
    80202b7c:	00007597          	auipc	a1,0x7
    80202b80:	5fc58593          	addi	a1,a1,1532 # 8020a178 <rodata_start+0x178>
    80202b84:	00007517          	auipc	a0,0x7
    80202b88:	5fc50513          	addi	a0,a0,1532 # 8020a180 <rodata_start+0x180>
    80202b8c:	ffffe097          	auipc	ra,0xffffe
    80202b90:	cc8080e7          	jalr	-824(ra) # 80200854 <_Z6printfPKcz>
  }
  LOG_DEBUG("wait4");
    80202b94:	00008517          	auipc	a0,0x8
    80202b98:	ba450513          	addi	a0,a0,-1116 # 8020a738 <_ZL6digits+0x430>
    80202b9c:	ffffe097          	auipc	ra,0xffffe
    80202ba0:	cb8080e7          	jalr	-840(ra) # 80200854 <_Z6printfPKcz>
    80202ba4:	00007517          	auipc	a0,0x7
    80202ba8:	4fc50513          	addi	a0,a0,1276 # 8020a0a0 <rodata_start+0xa0>
    80202bac:	ffffe097          	auipc	ra,0xffffe
    80202bb0:	ca8080e7          	jalr	-856(ra) # 80200854 <_Z6printfPKcz>
  if(pid == -1){
    80202bb4:	fec42503          	lw	a0,-20(s0)
    80202bb8:	57fd                	li	a5,-1
    80202bba:	00f50e63          	beq	a0,a5,80202bd6 <_Z9sys_wait4v+0x9e>
    return wait(uaddr);
  }
  return wait4(pid, uaddr);
    80202bbe:	fe043583          	ld	a1,-32(s0)
    80202bc2:	fffff097          	auipc	ra,0xfffff
    80202bc6:	4da080e7          	jalr	1242(ra) # 8020209c <_Z5wait4im>
    80202bca:	87aa                	mv	a5,a0
}
    80202bcc:	853e                	mv	a0,a5
    80202bce:	60e2                	ld	ra,24(sp)
    80202bd0:	6442                	ld	s0,16(sp)
    80202bd2:	6105                	addi	sp,sp,32
    80202bd4:	8082                	ret
    return wait(uaddr);
    80202bd6:	fe043503          	ld	a0,-32(s0)
    80202bda:	fffff097          	auipc	ra,0xfffff
    80202bde:	34a080e7          	jalr	842(ra) # 80201f24 <_Z4waitm>
    80202be2:	87aa                	mv	a5,a0
    80202be4:	b7e5                	j	80202bcc <_Z9sys_wait4v+0x94>

0000000080202be6 <_Z10sys_getpidv>:

uint64_t sys_getpid() { return myTask()->pid; }
    80202be6:	1141                	addi	sp,sp,-16
    80202be8:	e406                	sd	ra,8(sp)
    80202bea:	e022                	sd	s0,0(sp)
    80202bec:	0800                	addi	s0,sp,16
    80202bee:	fffff097          	auipc	ra,0xfffff
    80202bf2:	e1e080e7          	jalr	-482(ra) # 80201a0c <_Z6myTaskv>
    80202bf6:	5d08                	lw	a0,56(a0)
    80202bf8:	60a2                	ld	ra,8(sp)
    80202bfa:	6402                	ld	s0,0(sp)
    80202bfc:	0141                	addi	sp,sp,16
    80202bfe:	8082                	ret

0000000080202c00 <_Z11sys_getppidv>:
    80202c00:	1141                	addi	sp,sp,-16
    80202c02:	e406                	sd	ra,8(sp)
    80202c04:	e022                	sd	s0,0(sp)
    80202c06:	0800                	addi	s0,sp,16
    80202c08:	fffff097          	auipc	ra,0xfffff
    80202c0c:	e04080e7          	jalr	-508(ra) # 80201a0c <_Z6myTaskv>
    80202c10:	711c                	ld	a5,32(a0)
    80202c12:	5f88                	lw	a0,56(a5)
    80202c14:	60a2                	ld	ra,8(sp)
    80202c16:	6402                	ld	s0,0(sp)
    80202c18:	0141                	addi	sp,sp,16
    80202c1a:	8082                	ret

0000000080202c1c <_Z10sys_getcwdv>:
#include "os/TaskScheduler.hpp"
#include "param.hpp"
#include "riscv.hpp"
#include "types.hpp"

uint64_t sys_getcwd(void) {
    80202c1c:	7179                	addi	sp,sp,-48
    80202c1e:	f406                	sd	ra,40(sp)
    80202c20:	f022                	sd	s0,32(sp)
    80202c22:	ec26                	sd	s1,24(sp)
    80202c24:	e84a                	sd	s2,16(sp)
    80202c26:	1800                	addi	s0,sp,48
    80202c28:	00008717          	auipc	a4,0x8
    80202c2c:	b1870713          	addi	a4,a4,-1256 # 8020a740 <_ZL6digits+0x438>
    80202c30:	46c1                	li	a3,16
    80202c32:	00008617          	auipc	a2,0x8
    80202c36:	b1e60613          	addi	a2,a2,-1250 # 8020a750 <_ZL6digits+0x448>
    80202c3a:	00007597          	auipc	a1,0x7
    80202c3e:	53e58593          	addi	a1,a1,1342 # 8020a178 <rodata_start+0x178>
    80202c42:	00007517          	auipc	a0,0x7
    80202c46:	53e50513          	addi	a0,a0,1342 # 8020a180 <rodata_start+0x180>
    80202c4a:	ffffe097          	auipc	ra,0xffffe
    80202c4e:	c0a080e7          	jalr	-1014(ra) # 80200854 <_Z6printfPKcz>
  uint64_t userBuf;
  int n;
  LOG_DEBUG("cwd");
    80202c52:	00008517          	auipc	a0,0x8
    80202c56:	b1650513          	addi	a0,a0,-1258 # 8020a768 <_ZL6digits+0x460>
    80202c5a:	ffffe097          	auipc	ra,0xffffe
    80202c5e:	bfa080e7          	jalr	-1030(ra) # 80200854 <_Z6printfPKcz>
    80202c62:	00007517          	auipc	a0,0x7
    80202c66:	43e50513          	addi	a0,a0,1086 # 8020a0a0 <rodata_start+0xa0>
    80202c6a:	ffffe097          	auipc	ra,0xffffe
    80202c6e:	bea080e7          	jalr	-1046(ra) # 80200854 <_Z6printfPKcz>
  if (argaddr(0, &userBuf) < 0 || argint(1, &n) < 0) {
    80202c72:	fd840593          	addi	a1,s0,-40
    80202c76:	4501                	li	a0,0
    80202c78:	00000097          	auipc	ra,0x0
    80202c7c:	b28080e7          	jalr	-1240(ra) # 802027a0 <_Z7argaddriPm>
    return -1;
    80202c80:	57fd                	li	a5,-1
  if (argaddr(0, &userBuf) < 0 || argint(1, &n) < 0) {
    80202c82:	04054c63          	bltz	a0,80202cda <_Z10sys_getcwdv+0xbe>
    80202c86:	fd440593          	addi	a1,s0,-44
    80202c8a:	4505                	li	a0,1
    80202c8c:	00000097          	auipc	ra,0x0
    80202c90:	af2080e7          	jalr	-1294(ra) # 8020277e <_Z6argintiPi>
    return -1;
    80202c94:	57fd                	li	a5,-1
  if (argaddr(0, &userBuf) < 0 || argint(1, &n) < 0) {
    80202c96:	04054263          	bltz	a0,80202cda <_Z10sys_getcwdv+0xbe>
  }
  char *cwd = myTask()->currentDir;
    80202c9a:	fffff097          	auipc	ra,0xfffff
    80202c9e:	d72080e7          	jalr	-654(ra) # 80201a0c <_Z6myTaskv>
    80202ca2:	09050493          	addi	s1,a0,144
  if (strlen(cwd) > n) {
    80202ca6:	8526                	mv	a0,s1
    80202ca8:	ffffe097          	auipc	ra,0xffffe
    80202cac:	0a4080e7          	jalr	164(ra) # 80200d4c <_Z6strlenPKc>
    80202cb0:	fd442703          	lw	a4,-44(s0)
    return -1;
    80202cb4:	57fd                	li	a5,-1
  if (strlen(cwd) > n) {
    80202cb6:	02a74263          	blt	a4,a0,80202cda <_Z10sys_getcwdv+0xbe>
  }
  return either_copyout(true, userBuf, reinterpret_cast<void *>(cwd), strlen(cwd));
    80202cba:	fd843903          	ld	s2,-40(s0)
    80202cbe:	8526                	mv	a0,s1
    80202cc0:	ffffe097          	auipc	ra,0xffffe
    80202cc4:	08c080e7          	jalr	140(ra) # 80200d4c <_Z6strlenPKc>
    80202cc8:	86aa                	mv	a3,a0
    80202cca:	8626                	mv	a2,s1
    80202ccc:	85ca                	mv	a1,s2
    80202cce:	4505                	li	a0,1
    80202cd0:	fffff097          	auipc	ra,0xfffff
    80202cd4:	6de080e7          	jalr	1758(ra) # 802023ae <_Z14either_copyoutbmPvi>
    80202cd8:	87aa                	mv	a5,a0
}
    80202cda:	853e                	mv	a0,a5
    80202cdc:	70a2                	ld	ra,40(sp)
    80202cde:	7402                	ld	s0,32(sp)
    80202ce0:	64e2                	ld	s1,24(sp)
    80202ce2:	6942                	ld	s2,16(sp)
    80202ce4:	6145                	addi	sp,sp,48
    80202ce6:	8082                	ret

0000000080202ce8 <_Z8sys_openv>:

uint64_t sys_open(void) {
    80202ce8:	711d                	addi	sp,sp,-96
    80202cea:	ec86                	sd	ra,88(sp)
    80202cec:	e8a2                	sd	s0,80(sp)
    80202cee:	1080                	addi	s0,sp,96
    80202cf0:	00008717          	auipc	a4,0x8
    80202cf4:	a8070713          	addi	a4,a4,-1408 # 8020a770 <_ZL6digits+0x468>
    80202cf8:	46fd                	li	a3,31
    80202cfa:	00008617          	auipc	a2,0x8
    80202cfe:	a5660613          	addi	a2,a2,-1450 # 8020a750 <_ZL6digits+0x448>
    80202d02:	00007597          	auipc	a1,0x7
    80202d06:	47658593          	addi	a1,a1,1142 # 8020a178 <rodata_start+0x178>
    80202d0a:	00007517          	auipc	a0,0x7
    80202d0e:	47650513          	addi	a0,a0,1142 # 8020a180 <rodata_start+0x180>
    80202d12:	ffffe097          	auipc	ra,0xffffe
    80202d16:	b42080e7          	jalr	-1214(ra) # 80200854 <_Z6printfPKcz>
  char path[MAXPATH];
  int fd, mode;
  int n;
  LOG_DEBUG("sys_open");
    80202d1a:	00008517          	auipc	a0,0x8
    80202d1e:	a5650513          	addi	a0,a0,-1450 # 8020a770 <_ZL6digits+0x468>
    80202d22:	ffffe097          	auipc	ra,0xffffe
    80202d26:	b32080e7          	jalr	-1230(ra) # 80200854 <_Z6printfPKcz>
    80202d2a:	00007517          	auipc	a0,0x7
    80202d2e:	37650513          	addi	a0,a0,886 # 8020a0a0 <rodata_start+0xa0>
    80202d32:	ffffe097          	auipc	ra,0xffffe
    80202d36:	b22080e7          	jalr	-1246(ra) # 80200854 <_Z6printfPKcz>
  if ((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &mode)) {
    80202d3a:	04000613          	li	a2,64
    80202d3e:	fb040593          	addi	a1,s0,-80
    80202d42:	4501                	li	a0,0
    80202d44:	00000097          	auipc	ra,0x0
    80202d48:	ac6080e7          	jalr	-1338(ra) # 8020280a <_Z6argstriPci>
    return -1;
    80202d4c:	57fd                	li	a5,-1
  if ((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &mode)) {
    80202d4e:	02054463          	bltz	a0,80202d76 <_Z8sys_openv+0x8e>
    80202d52:	fac40593          	addi	a1,s0,-84
    80202d56:	4505                	li	a0,1
    80202d58:	00000097          	auipc	ra,0x0
    80202d5c:	a26080e7          	jalr	-1498(ra) # 8020277e <_Z6argintiPi>
    return -1;
    80202d60:	57fd                	li	a5,-1
  if ((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &mode)) {
    80202d62:	e911                	bnez	a0,80202d76 <_Z8sys_openv+0x8e>
  }

  fd = vfs::open(path, mode);
    80202d64:	fac42583          	lw	a1,-84(s0)
    80202d68:	fb040513          	addi	a0,s0,-80
    80202d6c:	00003097          	auipc	ra,0x3
    80202d70:	2be080e7          	jalr	702(ra) # 8020602a <_ZN3vfs4openEPKcm>
  return fd;
    80202d74:	87aa                	mv	a5,a0
}
    80202d76:	853e                	mv	a0,a5
    80202d78:	60e6                	ld	ra,88(sp)
    80202d7a:	6446                	ld	s0,80(sp)
    80202d7c:	6125                	addi	sp,sp,96
    80202d7e:	8082                	ret

0000000080202d80 <_Z9sys_closev>:

uint64_t sys_close(void) {
    80202d80:	7179                	addi	sp,sp,-48
    80202d82:	f406                	sd	ra,40(sp)
    80202d84:	f022                	sd	s0,32(sp)
    80202d86:	ec26                	sd	s1,24(sp)
    80202d88:	e84a                	sd	s2,16(sp)
    80202d8a:	1800                	addi	s0,sp,48
  int fd;
  if (argint(0, &fd) < 0) {
    80202d8c:	fdc40593          	addi	a1,s0,-36
    80202d90:	4501                	li	a0,0
    80202d92:	00000097          	auipc	ra,0x0
    80202d96:	9ec080e7          	jalr	-1556(ra) # 8020277e <_Z6argintiPi>
    return -1;
    80202d9a:	57fd                	li	a5,-1
  if (argint(0, &fd) < 0) {
    80202d9c:	0e054163          	bltz	a0,80202e7e <_Z9sys_closev+0xfe>
    80202da0:	00008717          	auipc	a4,0x8
    80202da4:	9e070713          	addi	a4,a4,-1568 # 8020a780 <_ZL6digits+0x478>
    80202da8:	02d00693          	li	a3,45
    80202dac:	00008617          	auipc	a2,0x8
    80202db0:	9a460613          	addi	a2,a2,-1628 # 8020a750 <_ZL6digits+0x448>
    80202db4:	00007597          	auipc	a1,0x7
    80202db8:	3c458593          	addi	a1,a1,964 # 8020a178 <rodata_start+0x178>
    80202dbc:	00007517          	auipc	a0,0x7
    80202dc0:	3c450513          	addi	a0,a0,964 # 8020a180 <rodata_start+0x180>
    80202dc4:	ffffe097          	auipc	ra,0xffffe
    80202dc8:	a90080e7          	jalr	-1392(ra) # 80200854 <_Z6printfPKcz>
  }
  LOG_DEBUG("sys_close");
    80202dcc:	00008517          	auipc	a0,0x8
    80202dd0:	9b450513          	addi	a0,a0,-1612 # 8020a780 <_ZL6digits+0x478>
    80202dd4:	ffffe097          	auipc	ra,0xffffe
    80202dd8:	a80080e7          	jalr	-1408(ra) # 80200854 <_Z6printfPKcz>
    80202ddc:	00007517          	auipc	a0,0x7
    80202de0:	2c450513          	addi	a0,a0,708 # 8020a0a0 <rodata_start+0xa0>
    80202de4:	ffffe097          	auipc	ra,0xffffe
    80202de8:	a70080e7          	jalr	-1424(ra) # 80200854 <_Z6printfPKcz>
  struct file *fp = getFileByfd(fd);
    80202dec:	fdc42503          	lw	a0,-36(s0)
    80202df0:	fffff097          	auipc	ra,0xfffff
    80202df4:	70e080e7          	jalr	1806(ra) # 802024fe <_Z11getFileByfdi>
    80202df8:	892a                	mv	s2,a0
  struct Task *task = myTask();
    80202dfa:	fffff097          	auipc	ra,0xfffff
    80202dfe:	c12080e7          	jalr	-1006(ra) # 80201a0c <_Z6myTaskv>
    80202e02:	84aa                	mv	s1,a0
  vfs::close(fp);
    80202e04:	854a                	mv	a0,s2
    80202e06:	00003097          	auipc	ra,0x3
    80202e0a:	5bc080e7          	jalr	1468(ra) # 802063c2 <_ZN3vfs5closeEP4file>
  task->lock.lock();
    80202e0e:	8526                	mv	a0,s1
    80202e10:	ffffe097          	auipc	ra,0xffffe
    80202e14:	03c080e7          	jalr	60(ra) # 80200e4c <_ZN8SpinLock4lockEv>
  task->openFiles[fd] = NULL;
    80202e18:	fdc42783          	lw	a5,-36(s0)
    80202e1c:	07a9                	addi	a5,a5,10
    80202e1e:	078e                	slli	a5,a5,0x3
    80202e20:	97a6                	add	a5,a5,s1
    80202e22:	0007b023          	sd	zero,0(a5)
  task->lock.unlock();
    80202e26:	8526                	mv	a0,s1
    80202e28:	ffffe097          	auipc	ra,0xffffe
    80202e2c:	0a0080e7          	jalr	160(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
    80202e30:	00008717          	auipc	a4,0x8
    80202e34:	95070713          	addi	a4,a4,-1712 # 8020a780 <_ZL6digits+0x478>
    80202e38:	03400693          	li	a3,52
    80202e3c:	00008617          	auipc	a2,0x8
    80202e40:	91460613          	addi	a2,a2,-1772 # 8020a750 <_ZL6digits+0x448>
    80202e44:	00007597          	auipc	a1,0x7
    80202e48:	33458593          	addi	a1,a1,820 # 8020a178 <rodata_start+0x178>
    80202e4c:	00007517          	auipc	a0,0x7
    80202e50:	33450513          	addi	a0,a0,820 # 8020a180 <rodata_start+0x180>
    80202e54:	ffffe097          	auipc	ra,0xffffe
    80202e58:	a00080e7          	jalr	-1536(ra) # 80200854 <_Z6printfPKcz>
  LOG_DEBUG("sys_close complete");
    80202e5c:	00008517          	auipc	a0,0x8
    80202e60:	93450513          	addi	a0,a0,-1740 # 8020a790 <_ZL6digits+0x488>
    80202e64:	ffffe097          	auipc	ra,0xffffe
    80202e68:	9f0080e7          	jalr	-1552(ra) # 80200854 <_Z6printfPKcz>
    80202e6c:	00007517          	auipc	a0,0x7
    80202e70:	23450513          	addi	a0,a0,564 # 8020a0a0 <rodata_start+0xa0>
    80202e74:	ffffe097          	auipc	ra,0xffffe
    80202e78:	9e0080e7          	jalr	-1568(ra) # 80200854 <_Z6printfPKcz>
  return 0;
    80202e7c:	4781                	li	a5,0
}
    80202e7e:	853e                	mv	a0,a5
    80202e80:	70a2                	ld	ra,40(sp)
    80202e82:	7402                	ld	s0,32(sp)
    80202e84:	64e2                	ld	s1,24(sp)
    80202e86:	6942                	ld	s2,16(sp)
    80202e88:	6145                	addi	sp,sp,48
    80202e8a:	8082                	ret

0000000080202e8c <_Z9sys_writev>:

uint64_t sys_write(void) {
    80202e8c:	1101                	addi	sp,sp,-32
    80202e8e:	ec06                	sd	ra,24(sp)
    80202e90:	e822                	sd	s0,16(sp)
    80202e92:	1000                	addi	s0,sp,32
  int fd, n;
  uint64_t uaddr;
  // LOG_DEBUG("sys_write");
  if (argint(0, &fd) < 0 || argint(2, &n) < 0 || argaddr(1, &uaddr) < 0) return -1;
    80202e94:	fec40593          	addi	a1,s0,-20
    80202e98:	4501                	li	a0,0
    80202e9a:	00000097          	auipc	ra,0x0
    80202e9e:	8e4080e7          	jalr	-1820(ra) # 8020277e <_Z6argintiPi>
    80202ea2:	57fd                	li	a5,-1
    80202ea4:	04054363          	bltz	a0,80202eea <_Z9sys_writev+0x5e>
    80202ea8:	fe840593          	addi	a1,s0,-24
    80202eac:	4509                	li	a0,2
    80202eae:	00000097          	auipc	ra,0x0
    80202eb2:	8d0080e7          	jalr	-1840(ra) # 8020277e <_Z6argintiPi>
    80202eb6:	57fd                	li	a5,-1
    80202eb8:	02054963          	bltz	a0,80202eea <_Z9sys_writev+0x5e>
    80202ebc:	fe040593          	addi	a1,s0,-32
    80202ec0:	4505                	li	a0,1
    80202ec2:	00000097          	auipc	ra,0x0
    80202ec6:	8de080e7          	jalr	-1826(ra) # 802027a0 <_Z7argaddriPm>
    80202eca:	57fd                	li	a5,-1
    80202ecc:	00054f63          	bltz	a0,80202eea <_Z9sys_writev+0x5e>

  return vfs::write(fd, true, reinterpret_cast<char *>(uaddr), n, 0);
    80202ed0:	4701                	li	a4,0
    80202ed2:	fe842683          	lw	a3,-24(s0)
    80202ed6:	fe043603          	ld	a2,-32(s0)
    80202eda:	4585                	li	a1,1
    80202edc:	fec42503          	lw	a0,-20(s0)
    80202ee0:	00003097          	auipc	ra,0x3
    80202ee4:	41e080e7          	jalr	1054(ra) # 802062fe <_ZN3vfs5writeEibPKcmm>
    80202ee8:	87aa                	mv	a5,a0
}
    80202eea:	853e                	mv	a0,a5
    80202eec:	60e2                	ld	ra,24(sp)
    80202eee:	6442                	ld	s0,16(sp)
    80202ef0:	6105                	addi	sp,sp,32
    80202ef2:	8082                	ret

0000000080202ef4 <_Z8sys_readv>:

uint64_t sys_read(void) {
    80202ef4:	1101                	addi	sp,sp,-32
    80202ef6:	ec06                	sd	ra,24(sp)
    80202ef8:	e822                	sd	s0,16(sp)
    80202efa:	1000                	addi	s0,sp,32
  int fd, n;
  uint64_t uaddr;
  // LOG_DEBUG("sys_read");
  if (argint(0, &fd) < 0 || argint(2, &n) < 0 || argaddr(1, &uaddr) < 0) return -1;
    80202efc:	fec40593          	addi	a1,s0,-20
    80202f00:	4501                	li	a0,0
    80202f02:	00000097          	auipc	ra,0x0
    80202f06:	87c080e7          	jalr	-1924(ra) # 8020277e <_Z6argintiPi>
    80202f0a:	57fd                	li	a5,-1
    80202f0c:	04054363          	bltz	a0,80202f52 <_Z8sys_readv+0x5e>
    80202f10:	fe840593          	addi	a1,s0,-24
    80202f14:	4509                	li	a0,2
    80202f16:	00000097          	auipc	ra,0x0
    80202f1a:	868080e7          	jalr	-1944(ra) # 8020277e <_Z6argintiPi>
    80202f1e:	57fd                	li	a5,-1
    80202f20:	02054963          	bltz	a0,80202f52 <_Z8sys_readv+0x5e>
    80202f24:	fe040593          	addi	a1,s0,-32
    80202f28:	4505                	li	a0,1
    80202f2a:	00000097          	auipc	ra,0x0
    80202f2e:	876080e7          	jalr	-1930(ra) # 802027a0 <_Z7argaddriPm>
    80202f32:	57fd                	li	a5,-1
    80202f34:	00054f63          	bltz	a0,80202f52 <_Z8sys_readv+0x5e>

  return vfs::read(fd, true, reinterpret_cast<char *>(uaddr), n, 0);
    80202f38:	4701                	li	a4,0
    80202f3a:	fe842683          	lw	a3,-24(s0)
    80202f3e:	fe043603          	ld	a2,-32(s0)
    80202f42:	4585                	li	a1,1
    80202f44:	fec42503          	lw	a0,-20(s0)
    80202f48:	00003097          	auipc	ra,0x3
    80202f4c:	2a8080e7          	jalr	680(ra) # 802061f0 <_ZN3vfs4readEibPcmm>
    80202f50:	87aa                	mv	a5,a0
}
    80202f52:	853e                	mv	a0,a5
    80202f54:	60e2                	ld	ra,24(sp)
    80202f56:	6442                	ld	s0,16(sp)
    80202f58:	6105                	addi	sp,sp,32
    80202f5a:	8082                	ret

0000000080202f5c <_Z7sys_dupv>:

uint64_t sys_dup(void) {
    80202f5c:	7179                	addi	sp,sp,-48
    80202f5e:	f406                	sd	ra,40(sp)
    80202f60:	f022                	sd	s0,32(sp)
    80202f62:	ec26                	sd	s1,24(sp)
    80202f64:	1800                	addi	s0,sp,48
  int fd;
  if (argint(0, &fd) < 0) {
    80202f66:	fdc40593          	addi	a1,s0,-36
    80202f6a:	4501                	li	a0,0
    80202f6c:	00000097          	auipc	ra,0x0
    80202f70:	812080e7          	jalr	-2030(ra) # 8020277e <_Z6argintiPi>
    80202f74:	87aa                	mv	a5,a0
    return -1;
    80202f76:	557d                	li	a0,-1
  if (argint(0, &fd) < 0) {
    80202f78:	0607cf63          	bltz	a5,80202ff6 <_Z7sys_dupv+0x9a>
  }
  struct file *fp = getFileByfd(fd);
    80202f7c:	fdc42503          	lw	a0,-36(s0)
    80202f80:	fffff097          	auipc	ra,0xfffff
    80202f84:	57e080e7          	jalr	1406(ra) # 802024fe <_Z11getFileByfdi>
    80202f88:	84aa                	mv	s1,a0
  if (fp == NULL) {
    80202f8a:	c93d                	beqz	a0,80203000 <_Z7sys_dupv+0xa4>
    80202f8c:	00008717          	auipc	a4,0x8
    80202f90:	81c70713          	addi	a4,a4,-2020 # 8020a7a8 <_ZL6digits+0x4a0>
    80202f94:	05300693          	li	a3,83
    80202f98:	00007617          	auipc	a2,0x7
    80202f9c:	7b860613          	addi	a2,a2,1976 # 8020a750 <_ZL6digits+0x448>
    80202fa0:	00007597          	auipc	a1,0x7
    80202fa4:	1d858593          	addi	a1,a1,472 # 8020a178 <rodata_start+0x178>
    80202fa8:	00007517          	auipc	a0,0x7
    80202fac:	1d850513          	addi	a0,a0,472 # 8020a180 <rodata_start+0x180>
    80202fb0:	ffffe097          	auipc	ra,0xffffe
    80202fb4:	8a4080e7          	jalr	-1884(ra) # 80200854 <_Z6printfPKcz>
    return -1;
  }
  LOG_DEBUG("dup fd=%d fp=%p fp->ref=%d\n", fd, fp, fp->ref);
    80202fb8:	48b4                	lw	a3,80(s1)
    80202fba:	8626                	mv	a2,s1
    80202fbc:	fdc42583          	lw	a1,-36(s0)
    80202fc0:	00007517          	auipc	a0,0x7
    80202fc4:	7f050513          	addi	a0,a0,2032 # 8020a7b0 <_ZL6digits+0x4a8>
    80202fc8:	ffffe097          	auipc	ra,0xffffe
    80202fcc:	88c080e7          	jalr	-1908(ra) # 80200854 <_Z6printfPKcz>
    80202fd0:	00007517          	auipc	a0,0x7
    80202fd4:	0d050513          	addi	a0,a0,208 # 8020a0a0 <rodata_start+0xa0>
    80202fd8:	ffffe097          	auipc	ra,0xffffe
    80202fdc:	87c080e7          	jalr	-1924(ra) # 80200854 <_Z6printfPKcz>
  vfs::dup(fp);
    80202fe0:	8526                	mv	a0,s1
    80202fe2:	00003097          	auipc	ra,0x3
    80202fe6:	7ac080e7          	jalr	1964(ra) # 8020678e <_ZN3vfs3dupEP4file>
  return registerFileHandle(fp);
    80202fea:	55fd                	li	a1,-1
    80202fec:	8526                	mv	a0,s1
    80202fee:	fffff097          	auipc	ra,0xfffff
    80202ff2:	46e080e7          	jalr	1134(ra) # 8020245c <_Z18registerFileHandleP4filei>
}
    80202ff6:	70a2                	ld	ra,40(sp)
    80202ff8:	7402                	ld	s0,32(sp)
    80202ffa:	64e2                	ld	s1,24(sp)
    80202ffc:	6145                	addi	sp,sp,48
    80202ffe:	8082                	ret
    return -1;
    80203000:	557d                	li	a0,-1
    80203002:	bfd5                	j	80202ff6 <_Z7sys_dupv+0x9a>

0000000080203004 <_Z8sys_dup3v>:

uint64_t sys_dup3(void) {
    80203004:	7179                	addi	sp,sp,-48
    80203006:	f406                	sd	ra,40(sp)
    80203008:	f022                	sd	s0,32(sp)
    8020300a:	ec26                	sd	s1,24(sp)
    8020300c:	e84a                	sd	s2,16(sp)
    8020300e:	1800                	addi	s0,sp,48
  int oldfd, newfd, ansfd;
  if (argint(0, &oldfd) < 0 || argint(0, &newfd) < 0) {
    80203010:	fdc40593          	addi	a1,s0,-36
    80203014:	4501                	li	a0,0
    80203016:	fffff097          	auipc	ra,0xfffff
    8020301a:	768080e7          	jalr	1896(ra) # 8020277e <_Z6argintiPi>
    return -1;
    8020301e:	54fd                	li	s1,-1
  if (argint(0, &oldfd) < 0 || argint(0, &newfd) < 0) {
    80203020:	04054063          	bltz	a0,80203060 <_Z8sys_dup3v+0x5c>
    80203024:	fd840593          	addi	a1,s0,-40
    80203028:	4501                	li	a0,0
    8020302a:	fffff097          	auipc	ra,0xfffff
    8020302e:	754080e7          	jalr	1876(ra) # 8020277e <_Z6argintiPi>
    80203032:	02054763          	bltz	a0,80203060 <_Z8sys_dup3v+0x5c>
  }
  struct file *fp = getFileByfd(oldfd);
    80203036:	fdc42503          	lw	a0,-36(s0)
    8020303a:	fffff097          	auipc	ra,0xfffff
    8020303e:	4c4080e7          	jalr	1220(ra) # 802024fe <_Z11getFileByfdi>
    80203042:	892a                	mv	s2,a0
  vfs::dup(fp);
    80203044:	00003097          	auipc	ra,0x3
    80203048:	74a080e7          	jalr	1866(ra) # 8020678e <_ZN3vfs3dupEP4file>
  ansfd = registerFileHandle(fp, newfd);
    8020304c:	fd842583          	lw	a1,-40(s0)
    80203050:	854a                	mv	a0,s2
    80203052:	fffff097          	auipc	ra,0xfffff
    80203056:	40a080e7          	jalr	1034(ra) # 8020245c <_Z18registerFileHandleP4filei>
    8020305a:	84aa                	mv	s1,a0
  if (ansfd < 0) {
    8020305c:	00054963          	bltz	a0,8020306e <_Z8sys_dup3v+0x6a>
    vfs::close(fp);
  }
  return ansfd;
}
    80203060:	8526                	mv	a0,s1
    80203062:	70a2                	ld	ra,40(sp)
    80203064:	7402                	ld	s0,32(sp)
    80203066:	64e2                	ld	s1,24(sp)
    80203068:	6942                	ld	s2,16(sp)
    8020306a:	6145                	addi	sp,sp,48
    8020306c:	8082                	ret
    vfs::close(fp);
    8020306e:	854a                	mv	a0,s2
    80203070:	00003097          	auipc	ra,0x3
    80203074:	352080e7          	jalr	850(ra) # 802063c2 <_ZN3vfs5closeEP4file>
  return ansfd;
    80203078:	b7e5                	j	80203060 <_Z8sys_dup3v+0x5c>

000000008020307a <_Z11sys_mkdiratv>:

uint64_t sys_mkdirat(void) {
    8020307a:	711d                	addi	sp,sp,-96
    8020307c:	ec86                	sd	ra,88(sp)
    8020307e:	e8a2                	sd	s0,80(sp)
    80203080:	1080                	addi	s0,sp,96
  int fd;
  char path[MAXPATH];
  if (argint(0, &fd) < 0 || argstr(1, path, MAXPATH) < 0) {
    80203082:	fec40593          	addi	a1,s0,-20
    80203086:	4501                	li	a0,0
    80203088:	fffff097          	auipc	ra,0xfffff
    8020308c:	6f6080e7          	jalr	1782(ra) # 8020277e <_Z6argintiPi>
    return -1;
    80203090:	57fd                	li	a5,-1
  if (argint(0, &fd) < 0 || argstr(1, path, MAXPATH) < 0) {
    80203092:	02054763          	bltz	a0,802030c0 <_Z11sys_mkdiratv+0x46>
    80203096:	04000613          	li	a2,64
    8020309a:	fa840593          	addi	a1,s0,-88
    8020309e:	4505                	li	a0,1
    802030a0:	fffff097          	auipc	ra,0xfffff
    802030a4:	76a080e7          	jalr	1898(ra) # 8020280a <_Z6argstriPci>
    return -1;
    802030a8:	57fd                	li	a5,-1
  if (argint(0, &fd) < 0 || argstr(1, path, MAXPATH) < 0) {
    802030aa:	00054b63          	bltz	a0,802030c0 <_Z11sys_mkdiratv+0x46>
  }
  vfs::mkdirat(fd, path);
    802030ae:	fa840593          	addi	a1,s0,-88
    802030b2:	fec42503          	lw	a0,-20(s0)
    802030b6:	00003097          	auipc	ra,0x3
    802030ba:	382080e7          	jalr	898(ra) # 80206438 <_ZN3vfs7mkdiratEiPKc>
  return 0;
    802030be:	4781                	li	a5,0
}
    802030c0:	853e                	mv	a0,a5
    802030c2:	60e6                	ld	ra,88(sp)
    802030c4:	6446                	ld	s0,80(sp)
    802030c6:	6125                	addi	sp,sp,96
    802030c8:	8082                	ret

00000000802030ca <_Z9sys_chdirv>:

uint64_t sys_chdir(void) {
    802030ca:	715d                	addi	sp,sp,-80
    802030cc:	e486                	sd	ra,72(sp)
    802030ce:	e0a2                	sd	s0,64(sp)
    802030d0:	0880                	addi	s0,sp,80
  char path[MAXPATH];

  memset(path, 0, MAXPATH);
    802030d2:	04000613          	li	a2,64
    802030d6:	4581                	li	a1,0
    802030d8:	fb040513          	addi	a0,s0,-80
    802030dc:	ffffe097          	auipc	ra,0xffffe
    802030e0:	a80080e7          	jalr	-1408(ra) # 80200b5c <_Z6memsetPvij>
  if (argstr(0, path, MAXPATH) < 0) {
    802030e4:	04000613          	li	a2,64
    802030e8:	fb040593          	addi	a1,s0,-80
    802030ec:	4501                	li	a0,0
    802030ee:	fffff097          	auipc	ra,0xfffff
    802030f2:	71c080e7          	jalr	1820(ra) # 8020280a <_Z6argstriPci>
    802030f6:	87aa                	mv	a5,a0
    return -1;
    802030f8:	557d                	li	a0,-1
  if (argstr(0, path, MAXPATH) < 0) {
    802030fa:	0007c863          	bltz	a5,8020310a <_Z9sys_chdirv+0x40>
  }
  return vfs::chdir(path);
    802030fe:	fb040513          	addi	a0,s0,-80
    80203102:	00003097          	auipc	ra,0x3
    80203106:	6f2080e7          	jalr	1778(ra) # 802067f4 <_ZN3vfs5chdirEPc>
    8020310a:	60a6                	ld	ra,72(sp)
    8020310c:	6406                	ld	s0,64(sp)
    8020310e:	6161                	addi	sp,sp,80
    80203110:	8082                	ret

0000000080203112 <_Z4execPcPS_>:
#include "common/logger.h"
#include "types.hpp"

static int loadseg(pte_t *pagetable, uint64_t addr, const char *path, uint_t offset, uint_t sz);

int exec(char *path, char **argv) {
    80203112:	df010113          	addi	sp,sp,-528
    80203116:	20113423          	sd	ra,520(sp)
    8020311a:	20813023          	sd	s0,512(sp)
    8020311e:	ffa6                	sd	s1,504(sp)
    80203120:	fbca                	sd	s2,496(sp)
    80203122:	f7ce                	sd	s3,488(sp)
    80203124:	f3d2                	sd	s4,480(sp)
    80203126:	efd6                	sd	s5,472(sp)
    80203128:	ebda                	sd	s6,464(sp)
    8020312a:	e7de                	sd	s7,456(sp)
    8020312c:	e3e2                	sd	s8,448(sp)
    8020312e:	ff66                	sd	s9,440(sp)
    80203130:	fb6a                	sd	s10,432(sp)
    80203132:	f76e                	sd	s11,424(sp)
    80203134:	0c00                	addi	s0,sp,528
    80203136:	8aaa                	mv	s5,a0
    80203138:	e0b43023          	sd	a1,-512(s0)
  uint64_t ustack[MAXARG + 1];  // 最后一项为0，用于标记结束
  struct elfhdr elf;
  // struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0;
  Task *task = myTask();
    8020313c:	fffff097          	auipc	ra,0xfffff
    80203140:	8d0080e7          	jalr	-1840(ra) # 80201a0c <_Z6myTaskv>
    80203144:	dea43823          	sd	a0,-528(s0)

  if ((pagetable = taskPagetable(task)) == 0) {
    80203148:	ffffe097          	auipc	ra,0xffffe
    8020314c:	71a080e7          	jalr	1818(ra) # 80201862 <_Z13taskPagetableP4Task>
    return 0;
    80203150:	4481                	li	s1,0
  if ((pagetable = taskPagetable(task)) == 0) {
    80203152:	c54d                	beqz	a0,802031fc <_Z4execPcPS_+0xea>
    80203154:	8b2a                	mv	s6,a0

  // lock_inode(ip);

  // 检查ELF头

  if (vfs::direct_read(path, reinterpret_cast<char *>(&elf), sizeof(elf), 0) != sizeof(elf)) {
    80203156:	4681                	li	a3,0
    80203158:	04000613          	li	a2,64
    8020315c:	e4840593          	addi	a1,s0,-440
    80203160:	8556                	mv	a0,s5
    80203162:	00003097          	auipc	ra,0x3
    80203166:	5d6080e7          	jalr	1494(ra) # 80206738 <_ZN3vfs11direct_readEPKcPcmm>
    8020316a:	04000793          	li	a5,64
    8020316e:	02f51863          	bne	a0,a5,8020319e <_Z4execPcPS_+0x8c>
    LOG_DEBUG("aaa");
    goto bad;
  }
  // if (read_inode(ip, 0, (uint64_t) &elf, 0, sizeof(elf)) != sizeof(elf))
  //     goto bad;
  if (elf.magic != ELF_MAGIC) goto bad;
    80203172:	e4842703          	lw	a4,-440(s0)
    80203176:	464c47b7          	lui	a5,0x464c4
    8020317a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39d3ba81>
    8020317e:	06f71663          	bne	a4,a5,802031ea <_Z4execPcPS_+0xd8>

  // 加载程序到内存中
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80203182:	e6842b83          	lw	s7,-408(s0)
    80203186:	e8045783          	lhu	a5,-384(s0)
    8020318a:	16078d63          	beqz	a5,80203304 <_Z4execPcPS_+0x1f2>
  uint64_t sz = 0, stackbase, sp;
    8020318e:	e0043423          	sd	zero,-504(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80203192:	4c01                	li	s8,0
    if (ph.memsz < ph.filesz) goto bad;
    if (ph.vaddr + ph.memsz < ph.vaddr) goto bad;
    uint64_t sz1;
    if ((sz1 = userAlloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0) goto bad;
    sz = sz1;
    if (ph.vaddr % PGSIZE != 0) goto bad;
    80203194:	6785                	lui	a5,0x1
    80203196:	17fd                	addi	a5,a5,-1
    80203198:	def43c23          	sd	a5,-520(s0)
    8020319c:	a8dd                	j	80203292 <_Z4execPcPS_+0x180>
    8020319e:	00007717          	auipc	a4,0x7
    802031a2:	63270713          	addi	a4,a4,1586 # 8020a7d0 <_ZL6digits+0x4c8>
    802031a6:	02500693          	li	a3,37
    802031aa:	00007617          	auipc	a2,0x7
    802031ae:	62e60613          	addi	a2,a2,1582 # 8020a7d8 <_ZL6digits+0x4d0>
    802031b2:	00007597          	auipc	a1,0x7
    802031b6:	fc658593          	addi	a1,a1,-58 # 8020a178 <rodata_start+0x178>
    802031ba:	00007517          	auipc	a0,0x7
    802031be:	fc650513          	addi	a0,a0,-58 # 8020a180 <rodata_start+0x180>
    802031c2:	ffffd097          	auipc	ra,0xffffd
    802031c6:	692080e7          	jalr	1682(ra) # 80200854 <_Z6printfPKcz>
    LOG_DEBUG("aaa");
    802031ca:	00007517          	auipc	a0,0x7
    802031ce:	61e50513          	addi	a0,a0,1566 # 8020a7e8 <_ZL6digits+0x4e0>
    802031d2:	ffffd097          	auipc	ra,0xffffd
    802031d6:	682080e7          	jalr	1666(ra) # 80200854 <_Z6printfPKcz>
    802031da:	00007517          	auipc	a0,0x7
    802031de:	ec650513          	addi	a0,a0,-314 # 8020a0a0 <rodata_start+0xa0>
    802031e2:	ffffd097          	auipc	ra,0xffffd
    802031e6:	672080e7          	jalr	1650(ra) # 80200854 <_Z6printfPKcz>
  task->trapframe->epc = elf.entry;
  task->trapframe->sp = sp;
  return argc;

bad:
  panic("exec");
    802031ea:	00007517          	auipc	a0,0x7
    802031ee:	5e650513          	addi	a0,a0,1510 # 8020a7d0 <_ZL6digits+0x4c8>
    802031f2:	ffffd097          	auipc	ra,0xffffd
    802031f6:	5f0080e7          	jalr	1520(ra) # 802007e2 <_Z5panicPKc>
  // TODO 处理失败情况
  return 0;
    802031fa:	4481                	li	s1,0
}
    802031fc:	8526                	mv	a0,s1
    802031fe:	20813083          	ld	ra,520(sp)
    80203202:	20013403          	ld	s0,512(sp)
    80203206:	74fe                	ld	s1,504(sp)
    80203208:	795e                	ld	s2,496(sp)
    8020320a:	79be                	ld	s3,488(sp)
    8020320c:	7a1e                	ld	s4,480(sp)
    8020320e:	6afe                	ld	s5,472(sp)
    80203210:	6b5e                	ld	s6,464(sp)
    80203212:	6bbe                	ld	s7,456(sp)
    80203214:	6c1e                	ld	s8,448(sp)
    80203216:	7cfa                	ld	s9,440(sp)
    80203218:	7d5a                	ld	s10,432(sp)
    8020321a:	7dba                	ld	s11,424(sp)
    8020321c:	21010113          	addi	sp,sp,528
    80203220:	8082                	ret

  if ((va % PGSIZE) != 0) panic("loadseg: va must be page aligned");

  for (i = 0; i < sz; i += PGSIZE) {
    pa = walkAddr(pagetable, va + i);
    if (pa == 0) panic("loadseg: address should exist");
    80203222:	00007517          	auipc	a0,0x7
    80203226:	5ce50513          	addi	a0,a0,1486 # 8020a7f0 <_ZL6digits+0x4e8>
    8020322a:	ffffd097          	auipc	ra,0xffffd
    8020322e:	5b8080e7          	jalr	1464(ra) # 802007e2 <_Z5panicPKc>
    80203232:	a099                	j	80203278 <_Z4execPcPS_+0x166>
    if (sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(vfs::direct_read(path, reinterpret_cast<char *>(pa), n, offset + i) != n)
    80203234:	1482                	slli	s1,s1,0x20
    80203236:	9081                	srli	s1,s1,0x20
    80203238:	012d86bb          	addw	a3,s11,s2
    8020323c:	1682                	slli	a3,a3,0x20
    8020323e:	9281                	srli	a3,a3,0x20
    80203240:	8626                	mv	a2,s1
    80203242:	85ce                	mv	a1,s3
    80203244:	8556                	mv	a0,s5
    80203246:	00003097          	auipc	ra,0x3
    8020324a:	4f2080e7          	jalr	1266(ra) # 80206738 <_ZN3vfs11direct_readEPKcPcmm>
    8020324e:	f8a49ee3          	bne	s1,a0,802031ea <_Z4execPcPS_+0xd8>
  for (i = 0; i < sz; i += PGSIZE) {
    80203252:	6785                	lui	a5,0x1
    80203254:	0127893b          	addw	s2,a5,s2
    80203258:	77fd                	lui	a5,0xfffff
    8020325a:	01478a3b          	addw	s4,a5,s4
    8020325e:	03997363          	bgeu	s2,s9,80203284 <_Z4execPcPS_+0x172>
    pa = walkAddr(pagetable, va + i);
    80203262:	02091593          	slli	a1,s2,0x20
    80203266:	9181                	srli	a1,a1,0x20
    80203268:	95ea                	add	a1,a1,s10
    8020326a:	855a                	mv	a0,s6
    8020326c:	00004097          	auipc	ra,0x4
    80203270:	c40080e7          	jalr	-960(ra) # 80206eac <_Z8walkAddrPmm>
    80203274:	89aa                	mv	s3,a0
    if (pa == 0) panic("loadseg: address should exist");
    80203276:	d555                	beqz	a0,80203222 <_Z4execPcPS_+0x110>
      n = PGSIZE;
    80203278:	6485                	lui	s1,0x1
    if (sz - i < PGSIZE)
    8020327a:	6785                	lui	a5,0x1
    8020327c:	fafa7ce3          	bgeu	s4,a5,80203234 <_Z4execPcPS_+0x122>
      n = sz - i;
    80203280:	84d2                	mv	s1,s4
    80203282:	bf4d                	j	80203234 <_Z4execPcPS_+0x122>
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80203284:	2c05                	addiw	s8,s8,1
    80203286:	038b8b9b          	addiw	s7,s7,56
    8020328a:	e8045783          	lhu	a5,-384(s0)
    8020328e:	06fc5d63          	bge	s8,a5,80203308 <_Z4execPcPS_+0x1f6>
    if (vfs::direct_read(path, reinterpret_cast<char *>(&ph), sizeof(ph), off) != sizeof(ph)) {
    80203292:	86de                	mv	a3,s7
    80203294:	03800613          	li	a2,56
    80203298:	e1040593          	addi	a1,s0,-496
    8020329c:	8556                	mv	a0,s5
    8020329e:	00003097          	auipc	ra,0x3
    802032a2:	49a080e7          	jalr	1178(ra) # 80206738 <_ZN3vfs11direct_readEPKcPcmm>
    802032a6:	03800793          	li	a5,56
    802032aa:	f4f510e3          	bne	a0,a5,802031ea <_Z4execPcPS_+0xd8>
    if (ph.type != ELF_PROG_LOAD) continue;
    802032ae:	e1042703          	lw	a4,-496(s0)
    802032b2:	4785                	li	a5,1
    802032b4:	fcf718e3          	bne	a4,a5,80203284 <_Z4execPcPS_+0x172>
    if (ph.memsz < ph.filesz) goto bad;
    802032b8:	e3843603          	ld	a2,-456(s0)
    802032bc:	e3043783          	ld	a5,-464(s0)
    802032c0:	f2f665e3          	bltu	a2,a5,802031ea <_Z4execPcPS_+0xd8>
    if (ph.vaddr + ph.memsz < ph.vaddr) goto bad;
    802032c4:	e2043783          	ld	a5,-480(s0)
    802032c8:	963e                	add	a2,a2,a5
    802032ca:	f2f660e3          	bltu	a2,a5,802031ea <_Z4execPcPS_+0xd8>
    if ((sz1 = userAlloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0) goto bad;
    802032ce:	e0843583          	ld	a1,-504(s0)
    802032d2:	855a                	mv	a0,s6
    802032d4:	00004097          	auipc	ra,0x4
    802032d8:	d3a080e7          	jalr	-710(ra) # 8020700e <_Z9userAllocPmmm>
    802032dc:	e0a43423          	sd	a0,-504(s0)
    802032e0:	d509                	beqz	a0,802031ea <_Z4execPcPS_+0xd8>
    if (ph.vaddr % PGSIZE != 0) goto bad;
    802032e2:	e2043d03          	ld	s10,-480(s0)
    802032e6:	df843783          	ld	a5,-520(s0)
    802032ea:	00fd77b3          	and	a5,s10,a5
    802032ee:	ee079ee3          	bnez	a5,802031ea <_Z4execPcPS_+0xd8>
    if (loadseg(pagetable, ph.vaddr, path, ph.off, ph.filesz) < 0) goto bad;
    802032f2:	e1842d83          	lw	s11,-488(s0)
    802032f6:	e3042c83          	lw	s9,-464(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    802032fa:	f80c85e3          	beqz	s9,80203284 <_Z4execPcPS_+0x172>
    802032fe:	8a66                	mv	s4,s9
    80203300:	4901                	li	s2,0
    80203302:	b785                	j	80203262 <_Z4execPcPS_+0x150>
  uint64_t sz = 0, stackbase, sp;
    80203304:	e0043423          	sd	zero,-504(s0)
  sz = PGROUNDUP(sz);
    80203308:	6605                	lui	a2,0x1
    8020330a:	fff60593          	addi	a1,a2,-1 # fff <_entry-0x801ff001>
    8020330e:	e0843783          	ld	a5,-504(s0)
    80203312:	95be                	add	a1,a1,a5
    80203314:	77fd                	lui	a5,0xfffff
    80203316:	8dfd                	and	a1,a1,a5
  if ((sz1 = userAlloc(pagetable, sz, sz + PGSIZE)) == 0) goto bad;
    80203318:	962e                	add	a2,a2,a1
    8020331a:	855a                	mv	a0,s6
    8020331c:	00004097          	auipc	ra,0x4
    80203320:	cf2080e7          	jalr	-782(ra) # 8020700e <_Z9userAllocPmmm>
    80203324:	8baa                	mv	s7,a0
    80203326:	ec0502e3          	beqz	a0,802031ea <_Z4execPcPS_+0xd8>
  stackbase = sz - PGSIZE;
    8020332a:	79fd                	lui	s3,0xfffff
    8020332c:	99aa                	add	s3,s3,a0
  for (argc = 0; argv[argc]; argc++) {
    8020332e:	e0043783          	ld	a5,-512(s0)
    80203332:	6388                	ld	a0,0(a5)
    80203334:	c52d                	beqz	a0,8020339e <_Z4execPcPS_+0x28c>
    80203336:	e8840913          	addi	s2,s0,-376
    8020333a:	f9040a13          	addi	s4,s0,-112
  sp = sz;
    8020333e:	8c5e                	mv	s8,s7
  for (argc = 0; argv[argc]; argc++) {
    80203340:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80203342:	ffffe097          	auipc	ra,0xffffe
    80203346:	a0a080e7          	jalr	-1526(ra) # 80200d4c <_Z6strlenPKc>
    8020334a:	0015059b          	addiw	a1,a0,1
    8020334e:	40bc05b3          	sub	a1,s8,a1
    sp -= sp % 16;
    80203352:	ff05fc13          	andi	s8,a1,-16
    if (sp < stackbase) {
    80203356:	e93c6ae3          	bltu	s8,s3,802031ea <_Z4execPcPS_+0xd8>
    if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0) goto bad;
    8020335a:	e0043d03          	ld	s10,-512(s0)
    8020335e:	000d3c83          	ld	s9,0(s10)
    80203362:	8566                	mv	a0,s9
    80203364:	ffffe097          	auipc	ra,0xffffe
    80203368:	9e8080e7          	jalr	-1560(ra) # 80200d4c <_Z6strlenPKc>
    8020336c:	0015069b          	addiw	a3,a0,1
    80203370:	8666                	mv	a2,s9
    80203372:	85e2                	mv	a1,s8
    80203374:	855a                	mv	a0,s6
    80203376:	00004097          	auipc	ra,0x4
    8020337a:	f4a080e7          	jalr	-182(ra) # 802072c0 <_Z7copyoutPmmPci>
    8020337e:	e60546e3          	bltz	a0,802031ea <_Z4execPcPS_+0xd8>
    ustack[argc] = sp;
    80203382:	01893023          	sd	s8,0(s2)
  for (argc = 0; argv[argc]; argc++) {
    80203386:	2485                	addiw	s1,s1,1
    80203388:	008d0793          	addi	a5,s10,8
    8020338c:	e0f43023          	sd	a5,-512(s0)
    80203390:	008d3503          	ld	a0,8(s10)
    80203394:	c519                	beqz	a0,802033a2 <_Z4execPcPS_+0x290>
    if (argc > MAXARG) goto bad;
    80203396:	0921                	addi	s2,s2,8
    80203398:	fb4915e3          	bne	s2,s4,80203342 <_Z4execPcPS_+0x230>
    8020339c:	b5b9                	j	802031ea <_Z4execPcPS_+0xd8>
  sp = sz;
    8020339e:	8c5e                	mv	s8,s7
  for (argc = 0; argv[argc]; argc++) {
    802033a0:	4481                	li	s1,0
  ustack[argc] = 0;
    802033a2:	00349793          	slli	a5,s1,0x3
    802033a6:	f9040713          	addi	a4,s0,-112
    802033aa:	97ba                	add	a5,a5,a4
    802033ac:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7fd66ef8>
  sp -= (argc + 1) * sizeof(uint64_t);
    802033b0:	0014859b          	addiw	a1,s1,1
    802033b4:	058e                	slli	a1,a1,0x3
    802033b6:	40bc05b3          	sub	a1,s8,a1
  sp -= sp % 16;
    802033ba:	ff05f913          	andi	s2,a1,-16
  if (sp < stackbase) {
    802033be:	e33966e3          	bltu	s2,s3,802031ea <_Z4execPcPS_+0xd8>
  if (copyout(pagetable, sp, (char *)ustack, (argc + 2) * sizeof(uint64_t)) < 0) goto bad;
    802033c2:	0024869b          	addiw	a3,s1,2
    802033c6:	0036969b          	slliw	a3,a3,0x3
    802033ca:	e8840613          	addi	a2,s0,-376
    802033ce:	85ca                	mv	a1,s2
    802033d0:	855a                	mv	a0,s6
    802033d2:	00004097          	auipc	ra,0x4
    802033d6:	eee080e7          	jalr	-274(ra) # 802072c0 <_Z7copyoutPmmPci>
    802033da:	e00548e3          	bltz	a0,802031ea <_Z4execPcPS_+0xd8>
  task->trapframe->a1 = sp;
    802033de:	df043783          	ld	a5,-528(s0)
    802033e2:	63bc                	ld	a5,64(a5)
    802033e4:	0727bc23          	sd	s2,120(a5)
  for (last = s = path; *s; s++)
    802033e8:	000ac703          	lbu	a4,0(s5) # 1000 <_entry-0x801ff000>
    802033ec:	cf11                	beqz	a4,80203408 <_Z4execPcPS_+0x2f6>
    802033ee:	001a8793          	addi	a5,s5,1
    if (*s == '/') last = s + 1;
    802033f2:	02f00693          	li	a3,47
    802033f6:	a029                	j	80203400 <_Z4execPcPS_+0x2ee>
  for (last = s = path; *s; s++)
    802033f8:	0785                	addi	a5,a5,1
    802033fa:	fff7c703          	lbu	a4,-1(a5)
    802033fe:	c709                	beqz	a4,80203408 <_Z4execPcPS_+0x2f6>
    if (*s == '/') last = s + 1;
    80203400:	fed71ce3          	bne	a4,a3,802033f8 <_Z4execPcPS_+0x2e6>
    80203404:	8abe                	mv	s5,a5
    80203406:	bfcd                	j	802033f8 <_Z4execPcPS_+0x2e6>
  safestrcpy(task->name, last, sizeof(task->name)+1);
    80203408:	4645                	li	a2,17
    8020340a:	85d6                	mv	a1,s5
    8020340c:	df043983          	ld	s3,-528(s0)
    80203410:	15098513          	addi	a0,s3,336 # fffffffffffff150 <end+0xffffffff7fd67150>
    80203414:	ffffe097          	auipc	ra,0xffffe
    80203418:	904080e7          	jalr	-1788(ra) # 80200d18 <_Z10safestrcpyPcPKci>
  task->pagetable = pagetable;
    8020341c:	0569b423          	sd	s6,72(s3)
  task->sz = sz;
    80203420:	1779a023          	sw	s7,352(s3)
  task->trapframe->epc = elf.entry;
    80203424:	0409b783          	ld	a5,64(s3)
    80203428:	e6043703          	ld	a4,-416(s0)
    8020342c:	ef98                	sd	a4,24(a5)
  task->trapframe->sp = sp;
    8020342e:	0409b783          	ld	a5,64(s3)
    80203432:	0327b823          	sd	s2,48(a5)
  return argc;
    80203436:	b3d9                	j	802031fc <_Z4execPcPS_+0xea>

0000000080203438 <_ZN4Intr8push_offEv>:

namespace Intr {

// push_off/pop_off 和 intr_off/intr_on 差不多，只是使得
// 开关中断可以嵌套使用。
void push_off(void) {
    80203438:	1101                	addi	sp,sp,-32
    8020343a:	ec06                	sd	ra,24(sp)
    8020343c:	e822                	sd	s0,16(sp)
    8020343e:	e426                	sd	s1,8(sp)
    80203440:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80203442:	100024f3          	csrr	s1,sstatus
    80203446:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8020344a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8020344c:	10079073          	csrw	sstatus,a5
  int old = intr_get();
  intr_off();
  if (Cpu::mycpu()->noff == 0) Cpu::mycpu()->intr_enable = old;
    80203450:	ffffe097          	auipc	ra,0xffffe
    80203454:	b18080e7          	jalr	-1256(ra) # 80200f68 <_ZN3Cpu5mycpuEv>
    80203458:	5d3c                	lw	a5,120(a0)
    8020345a:	cf89                	beqz	a5,80203474 <_ZN4Intr8push_offEv+0x3c>
  Cpu::mycpu()->noff += 1;
    8020345c:	ffffe097          	auipc	ra,0xffffe
    80203460:	b0c080e7          	jalr	-1268(ra) # 80200f68 <_ZN3Cpu5mycpuEv>
    80203464:	5d3c                	lw	a5,120(a0)
    80203466:	2785                	addiw	a5,a5,1
    80203468:	dd3c                	sw	a5,120(a0)
}
    8020346a:	60e2                	ld	ra,24(sp)
    8020346c:	6442                	ld	s0,16(sp)
    8020346e:	64a2                	ld	s1,8(sp)
    80203470:	6105                	addi	sp,sp,32
    80203472:	8082                	ret
  if (Cpu::mycpu()->noff == 0) Cpu::mycpu()->intr_enable = old;
    80203474:	ffffe097          	auipc	ra,0xffffe
    80203478:	af4080e7          	jalr	-1292(ra) # 80200f68 <_ZN3Cpu5mycpuEv>
  return (x & SSTATUS_SIE) != 0;
    8020347c:	8085                	srli	s1,s1,0x1
    8020347e:	8885                	andi	s1,s1,1
    80203480:	06950e23          	sb	s1,124(a0)
    80203484:	bfe1                	j	8020345c <_ZN4Intr8push_offEv+0x24>

0000000080203486 <_ZN4Intr7pop_offEv>:

void pop_off(void) {
    80203486:	1101                	addi	sp,sp,-32
    80203488:	ec06                	sd	ra,24(sp)
    8020348a:	e822                	sd	s0,16(sp)
    8020348c:	e426                	sd	s1,8(sp)
    8020348e:	1000                	addi	s0,sp,32
  Cpu *c = Cpu::mycpu();
    80203490:	ffffe097          	auipc	ra,0xffffe
    80203494:	ad8080e7          	jalr	-1320(ra) # 80200f68 <_ZN3Cpu5mycpuEv>
    80203498:	84aa                	mv	s1,a0
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8020349a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8020349e:	8b89                	andi	a5,a5,2
  if (intr_get()) panic("pop_off - interruptible");
    802034a0:	eb85                	bnez	a5,802034d0 <_ZN4Intr7pop_offEv+0x4a>
  if (c->noff < 1) {
    802034a2:	5cbc                	lw	a5,120(s1)
    802034a4:	02f05f63          	blez	a5,802034e2 <_ZN4Intr7pop_offEv+0x5c>
    panic("pop_off");
  }
  c->noff -= 1;
    802034a8:	5cbc                	lw	a5,120(s1)
    802034aa:	37fd                	addiw	a5,a5,-1
    802034ac:	0007871b          	sext.w	a4,a5
    802034b0:	dcbc                	sw	a5,120(s1)
  if (c->noff == 0 && c->intr_enable) intr_on();
    802034b2:	eb11                	bnez	a4,802034c6 <_ZN4Intr7pop_offEv+0x40>
    802034b4:	07c4c783          	lbu	a5,124(s1) # 107c <_entry-0x801fef84>
    802034b8:	c799                	beqz	a5,802034c6 <_ZN4Intr7pop_offEv+0x40>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    802034ba:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    802034be:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    802034c2:	10079073          	csrw	sstatus,a5
}
    802034c6:	60e2                	ld	ra,24(sp)
    802034c8:	6442                	ld	s0,16(sp)
    802034ca:	64a2                	ld	s1,8(sp)
    802034cc:	6105                	addi	sp,sp,32
    802034ce:	8082                	ret
  if (intr_get()) panic("pop_off - interruptible");
    802034d0:	00007517          	auipc	a0,0x7
    802034d4:	34050513          	addi	a0,a0,832 # 8020a810 <_ZL6digits+0x508>
    802034d8:	ffffd097          	auipc	ra,0xffffd
    802034dc:	30a080e7          	jalr	778(ra) # 802007e2 <_Z5panicPKc>
    802034e0:	b7c9                	j	802034a2 <_ZN4Intr7pop_offEv+0x1c>
    panic("pop_off");
    802034e2:	00007517          	auipc	a0,0x7
    802034e6:	34650513          	addi	a0,a0,838 # 8020a828 <_ZL6digits+0x520>
    802034ea:	ffffd097          	auipc	ra,0xffffd
    802034ee:	2f8080e7          	jalr	760(ra) # 802007e2 <_Z5panicPKc>
    802034f2:	bf5d                	j	802034a8 <_ZN4Intr7pop_offEv+0x22>

00000000802034f4 <_ZN11BufferLayer4initEv>:
#include "StartOS.hpp"

#define BUFFER_NUM 100
extern Timer timer;

void BufferLayer::init() {
    802034f4:	7179                	addi	sp,sp,-48
    802034f6:	f406                	sd	ra,40(sp)
    802034f8:	f022                	sd	s0,32(sp)
    802034fa:	ec26                	sd	s1,24(sp)
    802034fc:	e84a                	sd	s2,16(sp)
    802034fe:	e44e                	sd	s3,8(sp)
    80203500:	1800                	addi	s0,sp,48
    80203502:	892a                	mv	s2,a0
  this->spinlock.init("cache buffer");
    80203504:	00007597          	auipc	a1,0x7
    80203508:	32c58593          	addi	a1,a1,812 # 8020a830 <_ZL6digits+0x528>
    8020350c:	6539                	lui	a0,0xe
    8020350e:	74050513          	addi	a0,a0,1856 # e740 <_entry-0x801f18c0>
    80203512:	954a                	add	a0,a0,s2
    80203514:	ffffe097          	auipc	ra,0xffffe
    80203518:	8e2080e7          	jalr	-1822(ra) # 80200df6 <_ZN8SpinLock4initEPKc>
    8020351c:	06400493          	li	s1,100
  for (int i = 0; i < BUFFER_NUM; i++) {
    this->bufCache->sleeplock.init("buf");
    80203520:	0961                	addi	s2,s2,24
    80203522:	00007997          	auipc	s3,0x7
    80203526:	31e98993          	addi	s3,s3,798 # 8020a840 <_ZL6digits+0x538>
    8020352a:	85ce                	mv	a1,s3
    8020352c:	854a                	mv	a0,s2
    8020352e:	fffff097          	auipc	ra,0xfffff
    80203532:	052080e7          	jalr	82(ra) # 80202580 <_ZN9SleepLock4initEPKc>
  for (int i = 0; i < BUFFER_NUM; i++) {
    80203536:	34fd                	addiw	s1,s1,-1
    80203538:	f8ed                	bnez	s1,8020352a <_ZN11BufferLayer4initEv+0x36>
  }
}
    8020353a:	70a2                	ld	ra,40(sp)
    8020353c:	7402                	ld	s0,32(sp)
    8020353e:	64e2                	ld	s1,24(sp)
    80203540:	6942                	ld	s2,16(sp)
    80203542:	69a2                	ld	s3,8(sp)
    80203544:	6145                	addi	sp,sp,48
    80203546:	8082                	ret

0000000080203548 <_ZN11BufferLayer11allocBufferEii>:

// 申请使用一个缓冲区，该缓冲区会被锁定
// 先进先出算法
struct buf *BufferLayer::allocBuffer(int dev, int blockno) {
    80203548:	7139                	addi	sp,sp,-64
    8020354a:	fc06                	sd	ra,56(sp)
    8020354c:	f822                	sd	s0,48(sp)
    8020354e:	f426                	sd	s1,40(sp)
    80203550:	f04a                	sd	s2,32(sp)
    80203552:	ec4e                	sd	s3,24(sp)
    80203554:	e852                	sd	s4,16(sp)
    80203556:	e456                	sd	s5,8(sp)
    80203558:	0080                	addi	s0,sp,64
    8020355a:	84aa                	mv	s1,a0
    8020355c:	8aae                	mv	s5,a1
    8020355e:	89b2                	mv	s3,a2
  struct buf *b;
  struct buf *earliest = 0;
  this->spinlock.lock();
    80203560:	6a39                	lui	s4,0xe
    80203562:	740a0a13          	addi	s4,s4,1856 # e740 <_entry-0x801f18c0>
    80203566:	9a2a                	add	s4,s4,a0
    80203568:	8552                	mv	a0,s4
    8020356a:	ffffe097          	auipc	ra,0xffffe
    8020356e:	8e2080e7          	jalr	-1822(ra) # 80200e4c <_ZN8SpinLock4lockEv>
  for (b = this->bufCache; b < this->bufCache + BUFFER_NUM; b++) {
    80203572:	8752                	mv	a4,s4
  struct buf *earliest = 0;
    80203574:	4901                	li	s2,0
    80203576:	a809                	j	80203588 <_ZN11BufferLayer11allocBufferEii+0x40>
    80203578:	8926                	mv	s2,s1
    if (b->refcnt == 0 && (earliest == 0 || b->last_use_tick < earliest->last_use_tick)) {
      earliest = b;
    }
    if (b->blockno == blockno) {
    8020357a:	44dc                	lw	a5,12(s1)
    8020357c:	03378163          	beq	a5,s3,8020359e <_ZN11BufferLayer11allocBufferEii+0x56>
  for (b = this->bufCache; b < this->bufCache + BUFFER_NUM; b++) {
    80203580:	25048493          	addi	s1,s1,592
    80203584:	04e48a63          	beq	s1,a4,802035d8 <_ZN11BufferLayer11allocBufferEii+0x90>
    if (b->refcnt == 0 && (earliest == 0 || b->last_use_tick < earliest->last_use_tick)) {
    80203588:	44bc                	lw	a5,72(s1)
    8020358a:	fbe5                	bnez	a5,8020357a <_ZN11BufferLayer11allocBufferEii+0x32>
    8020358c:	fe0906e3          	beqz	s2,80203578 <_ZN11BufferLayer11allocBufferEii+0x30>
    80203590:	6894                	ld	a3,16(s1)
    80203592:	01093783          	ld	a5,16(s2)
    80203596:	fef6f2e3          	bgeu	a3,a5,8020357a <_ZN11BufferLayer11allocBufferEii+0x32>
    8020359a:	8926                	mv	s2,s1
    8020359c:	bff9                	j	8020357a <_ZN11BufferLayer11allocBufferEii+0x32>
      this->spinlock.unlock();
    8020359e:	8552                	mv	a0,s4
    802035a0:	ffffe097          	auipc	ra,0xffffe
    802035a4:	928080e7          	jalr	-1752(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
      b->refcnt++;
    802035a8:	44bc                	lw	a5,72(s1)
    802035aa:	2785                	addiw	a5,a5,1
    802035ac:	c4bc                	sw	a5,72(s1)
      b->last_use_tick = timer.ticks;
    802035ae:	00011797          	auipc	a5,0x11
    802035b2:	b127a783          	lw	a5,-1262(a5) # 802140c0 <timer>
    802035b6:	e89c                	sd	a5,16(s1)
      b->sleeplock.lock();
    802035b8:	01848513          	addi	a0,s1,24
    802035bc:	fffff097          	auipc	ra,0xfffff
    802035c0:	ffe080e7          	jalr	-2(ra) # 802025ba <_ZN9SleepLock4lockEv>
  b->blockno = blockno;
  b->dev = dev;
  b->last_use_tick = timer.ticks;
  b->sleeplock.lock();
  return b;
}
    802035c4:	8526                	mv	a0,s1
    802035c6:	70e2                	ld	ra,56(sp)
    802035c8:	7442                	ld	s0,48(sp)
    802035ca:	74a2                	ld	s1,40(sp)
    802035cc:	7902                	ld	s2,32(sp)
    802035ce:	69e2                	ld	s3,24(sp)
    802035d0:	6a42                	ld	s4,16(sp)
    802035d2:	6aa2                	ld	s5,8(sp)
    802035d4:	6121                	addi	sp,sp,64
    802035d6:	8082                	ret
  this->spinlock.unlock();
    802035d8:	8552                	mv	a0,s4
    802035da:	ffffe097          	auipc	ra,0xffffe
    802035de:	8ee080e7          	jalr	-1810(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
  if (earliest == 0) {
    802035e2:	02090963          	beqz	s2,80203614 <_ZN11BufferLayer11allocBufferEii+0xcc>
  b->valid = 0;
    802035e6:	00092023          	sw	zero,0(s2)
  b->refcnt = 1;
    802035ea:	4785                	li	a5,1
    802035ec:	04f92423          	sw	a5,72(s2)
  b->blockno = blockno;
    802035f0:	01392623          	sw	s3,12(s2)
  b->dev = dev;
    802035f4:	01592423          	sw	s5,8(s2)
  b->last_use_tick = timer.ticks;
    802035f8:	00011797          	auipc	a5,0x11
    802035fc:	ac87a783          	lw	a5,-1336(a5) # 802140c0 <timer>
    80203600:	00f93823          	sd	a5,16(s2)
  b->sleeplock.lock();
    80203604:	01890513          	addi	a0,s2,24
    80203608:	fffff097          	auipc	ra,0xfffff
    8020360c:	fb2080e7          	jalr	-78(ra) # 802025ba <_ZN9SleepLock4lockEv>
  return b;
    80203610:	84ca                	mv	s1,s2
    80203612:	bf4d                	j	802035c4 <_ZN11BufferLayer11allocBufferEii+0x7c>
    panic("alloc buf");
    80203614:	00007517          	auipc	a0,0x7
    80203618:	23450513          	addi	a0,a0,564 # 8020a848 <_ZL6digits+0x540>
    8020361c:	ffffd097          	auipc	ra,0xffffd
    80203620:	1c6080e7          	jalr	454(ra) # 802007e2 <_Z5panicPKc>
    80203624:	b7c9                	j	802035e6 <_ZN11BufferLayer11allocBufferEii+0x9e>

0000000080203626 <_ZN11BufferLayer10freeBufferEP3buf>:

// 释放缓冲区
void BufferLayer::freeBuffer(struct buf *b) {
    80203626:	1101                	addi	sp,sp,-32
    80203628:	ec06                	sd	ra,24(sp)
    8020362a:	e822                	sd	s0,16(sp)
    8020362c:	e426                	sd	s1,8(sp)
    8020362e:	e04a                	sd	s2,0(sp)
    80203630:	1000                	addi	s0,sp,32
    80203632:	84ae                	mv	s1,a1
  this->spinlock.lock();
    80203634:	6939                	lui	s2,0xe
    80203636:	74090913          	addi	s2,s2,1856 # e740 <_entry-0x801f18c0>
    8020363a:	992a                	add	s2,s2,a0
    8020363c:	854a                	mv	a0,s2
    8020363e:	ffffe097          	auipc	ra,0xffffe
    80203642:	80e080e7          	jalr	-2034(ra) # 80200e4c <_ZN8SpinLock4lockEv>
  b->refcnt--;
    80203646:	44bc                	lw	a5,72(s1)
    80203648:	37fd                	addiw	a5,a5,-1
    8020364a:	c4bc                	sw	a5,72(s1)
  this->spinlock.unlock();
    8020364c:	854a                	mv	a0,s2
    8020364e:	ffffe097          	auipc	ra,0xffffe
    80203652:	87a080e7          	jalr	-1926(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
  return b;
}

// 将缓冲区写入磁盘
void BufferLayer::write(struct buf *b){
	disk_write(b);
    80203656:	8526                	mv	a0,s1
    80203658:	00002097          	auipc	ra,0x2
    8020365c:	6d8080e7          	jalr	1752(ra) # 80205d30 <_Z10disk_writeP3buf>
	b->sleeplock.unlock();
    80203660:	01848513          	addi	a0,s1,24
    80203664:	fffff097          	auipc	ra,0xfffff
    80203668:	fac080e7          	jalr	-84(ra) # 80202610 <_ZN9SleepLock6unlockEv>
}
    8020366c:	60e2                	ld	ra,24(sp)
    8020366e:	6442                	ld	s0,16(sp)
    80203670:	64a2                	ld	s1,8(sp)
    80203672:	6902                	ld	s2,0(sp)
    80203674:	6105                	addi	sp,sp,32
    80203676:	8082                	ret

0000000080203678 <_ZN11BufferLayer4readEii>:
struct buf *BufferLayer::read(int dev, int blockno) {
    80203678:	1101                	addi	sp,sp,-32
    8020367a:	ec06                	sd	ra,24(sp)
    8020367c:	e822                	sd	s0,16(sp)
    8020367e:	e426                	sd	s1,8(sp)
    80203680:	1000                	addi	s0,sp,32
  struct buf *b = allocBuffer(dev, blockno);
    80203682:	00000097          	auipc	ra,0x0
    80203686:	ec6080e7          	jalr	-314(ra) # 80203548 <_ZN11BufferLayer11allocBufferEii>
    8020368a:	84aa                	mv	s1,a0
  if (!b->valid) {
    8020368c:	411c                	lw	a5,0(a0)
    8020368e:	cb89                	beqz	a5,802036a0 <_ZN11BufferLayer4readEii+0x28>
  b->valid = 1;
    80203690:	4785                	li	a5,1
    80203692:	c09c                	sw	a5,0(s1)
}
    80203694:	8526                	mv	a0,s1
    80203696:	60e2                	ld	ra,24(sp)
    80203698:	6442                	ld	s0,16(sp)
    8020369a:	64a2                	ld	s1,8(sp)
    8020369c:	6105                	addi	sp,sp,32
    8020369e:	8082                	ret
    disk_read(b);
    802036a0:	00002097          	auipc	ra,0x2
    802036a4:	678080e7          	jalr	1656(ra) # 80205d18 <_Z9disk_readP3buf>
    802036a8:	b7e5                	j	80203690 <_ZN11BufferLayer4readEii+0x18>

00000000802036aa <_ZN11BufferLayer5writeEP3buf>:
void BufferLayer::write(struct buf *b){
    802036aa:	1141                	addi	sp,sp,-16
    802036ac:	e406                	sd	ra,8(sp)
    802036ae:	e022                	sd	s0,0(sp)
    802036b0:	0800                	addi	s0,sp,16
	disk_write(b);
    802036b2:	852e                	mv	a0,a1
    802036b4:	00002097          	auipc	ra,0x2
    802036b8:	67c080e7          	jalr	1660(ra) # 80205d30 <_Z10disk_writeP3buf>
};
    802036bc:	60a2                	ld	ra,8(sp)
    802036be:	6402                	ld	s0,0(sp)
    802036c0:	0141                	addi	sp,sp,16
    802036c2:	8082                	ret

00000000802036c4 <_ZN15Fat32FileSystem5clearEPKcmmRm>:
  int x = tf_fwrite(buf, n, fp);
  tf_fclose(fp);
  return x;
}

size_t Fat32FileSystem::clear(const char *filepath, size_t count, size_t offset, size_t &written) { return 0; }
    802036c4:	1141                	addi	sp,sp,-16
    802036c6:	e422                	sd	s0,8(sp)
    802036c8:	0800                	addi	s0,sp,16
    802036ca:	4501                	li	a0,0
    802036cc:	6422                	ld	s0,8(sp)
    802036ce:	0141                	addi	sp,sp,16
    802036d0:	8082                	ret

00000000802036d2 <_ZN15Fat32FileSystem8truncateEPKcm>:

size_t Fat32FileSystem::truncate(const char *filepath, size_t size) { return 0; }
    802036d2:	1141                	addi	sp,sp,-16
    802036d4:	e422                	sd	s0,8(sp)
    802036d6:	0800                	addi	s0,sp,16
    802036d8:	4501                	li	a0,0
    802036da:	6422                	ld	s0,8(sp)
    802036dc:	0141                	addi	sp,sp,16
    802036de:	8082                	ret

00000000802036e0 <_Z7copysfnPcS_b>:
size_t Fat32FileSystem::rm(const char *filepath) {
  tf_remove((char *)filepath);
  return 0;
}

int copysfn(char *sfn, char *dst, bool user) {
    802036e0:	7139                	addi	sp,sp,-64
    802036e2:	fc06                	sd	ra,56(sp)
    802036e4:	f822                	sd	s0,48(sp)
    802036e6:	f426                	sd	s1,40(sp)
    802036e8:	f04a                	sd	s2,32(sp)
    802036ea:	ec4e                	sd	s3,24(sp)
    802036ec:	e852                	sd	s4,16(sp)
    802036ee:	e456                	sd	s5,8(sp)
    802036f0:	0080                	addi	s0,sp,64
    802036f2:	892a                	mv	s2,a0
    802036f4:	89ae                	mv	s3,a1
    802036f6:	8a32                	mv	s4,a2
  int n = 0, i = 0;
  for (i = 0; i < 8 && sfn[i] != 0x20; i++) {
    802036f8:	87aa                	mv	a5,a0
  int n = 0, i = 0;
    802036fa:	4481                	li	s1,0
  for (i = 0; i < 8 && sfn[i] != 0x20; i++) {
    802036fc:	02000693          	li	a3,32
    80203700:	4521                	li	a0,8
    80203702:	0007c703          	lbu	a4,0(a5)
    80203706:	12d70463          	beq	a4,a3,8020382e <_Z7copysfnPcS_b+0x14e>
    n++;
    8020370a:	2485                	addiw	s1,s1,1
  for (i = 0; i < 8 && sfn[i] != 0x20; i++) {
    8020370c:	0785                	addi	a5,a5,1
    8020370e:	fea49ae3          	bne	s1,a0,80203702 <_Z7copysfnPcS_b+0x22>
    80203712:	8aa6                	mv	s5,s1
    80203714:	00007717          	auipc	a4,0x7
    80203718:	14470713          	addi	a4,a4,324 # 8020a858 <_ZL6digits+0x550>
    8020371c:	05800693          	li	a3,88
    80203720:	00007617          	auipc	a2,0x7
    80203724:	14060613          	addi	a2,a2,320 # 8020a860 <_ZL6digits+0x558>
    80203728:	00007597          	auipc	a1,0x7
    8020372c:	a5058593          	addi	a1,a1,-1456 # 8020a178 <rodata_start+0x178>
    80203730:	00007517          	auipc	a0,0x7
    80203734:	a5050513          	addi	a0,a0,-1456 # 8020a180 <rodata_start+0x180>
    80203738:	ffffd097          	auipc	ra,0xffffd
    8020373c:	11c080e7          	jalr	284(ra) # 80200854 <_Z6printfPKcz>
  }
  LOG_DEBUG("name=%d", n);
    80203740:	85a6                	mv	a1,s1
    80203742:	00007517          	auipc	a0,0x7
    80203746:	13650513          	addi	a0,a0,310 # 8020a878 <_ZL6digits+0x570>
    8020374a:	ffffd097          	auipc	ra,0xffffd
    8020374e:	10a080e7          	jalr	266(ra) # 80200854 <_Z6printfPKcz>
    80203752:	00007517          	auipc	a0,0x7
    80203756:	94e50513          	addi	a0,a0,-1714 # 8020a0a0 <rodata_start+0xa0>
    8020375a:	ffffd097          	auipc	ra,0xffffd
    8020375e:	0fa080e7          	jalr	250(ra) # 80200854 <_Z6printfPKcz>
  either_copyout(user, reinterpret_cast<uint64_t>(dst), sfn, i);
    80203762:	86d6                	mv	a3,s5
    80203764:	864a                	mv	a2,s2
    80203766:	85ce                	mv	a1,s3
    80203768:	8552                	mv	a0,s4
    8020376a:	fffff097          	auipc	ra,0xfffff
    8020376e:	c44080e7          	jalr	-956(ra) # 802023ae <_Z14either_copyoutbmPvi>
  for (i = 8; i < 11 && sfn[i] != 0x20; i++) {
    80203772:	00890a93          	addi	s5,s2,8
    80203776:	00894703          	lbu	a4,8(s2)
    8020377a:	02000793          	li	a5,32
    8020377e:	08f70e63          	beq	a4,a5,8020381a <_Z7copysfnPcS_b+0x13a>
    80203782:	00994703          	lbu	a4,9(s2)
    80203786:	0af70663          	beq	a4,a5,80203832 <_Z7copysfnPcS_b+0x152>
    8020378a:	00a94903          	lbu	s2,10(s2)
    8020378e:	1901                	addi	s2,s2,-32
    80203790:	01203933          	snez	s2,s2
    80203794:	0929                	addi	s2,s2,10
  }
  if (i == 8) {
    return n;
  }
  either_copyout(user, reinterpret_cast<uint64_t>(dst + n), (void *)".", 1);
    80203796:	4685                	li	a3,1
    80203798:	00007617          	auipc	a2,0x7
    8020379c:	0e860613          	addi	a2,a2,232 # 8020a880 <_ZL6digits+0x578>
    802037a0:	009985b3          	add	a1,s3,s1
    802037a4:	8552                	mv	a0,s4
    802037a6:	fffff097          	auipc	ra,0xfffff
    802037aa:	c08080e7          	jalr	-1016(ra) # 802023ae <_Z14either_copyoutbmPvi>
  n += 1;
    802037ae:	2485                	addiw	s1,s1,1
    802037b0:	0004859b          	sext.w	a1,s1
  either_copyout(user, reinterpret_cast<uint64_t>(dst + n), sfn + 8, i - 8);
    802037b4:	ff89069b          	addiw	a3,s2,-8
    802037b8:	8656                	mv	a2,s5
    802037ba:	95ce                	add	a1,a1,s3
    802037bc:	8552                	mv	a0,s4
    802037be:	fffff097          	auipc	ra,0xfffff
    802037c2:	bf0080e7          	jalr	-1040(ra) # 802023ae <_Z14either_copyoutbmPvi>
    802037c6:	00007717          	auipc	a4,0x7
    802037ca:	09270713          	addi	a4,a4,146 # 8020a858 <_ZL6digits+0x550>
    802037ce:	06200693          	li	a3,98
    802037d2:	00007617          	auipc	a2,0x7
    802037d6:	08e60613          	addi	a2,a2,142 # 8020a860 <_ZL6digits+0x558>
    802037da:	00007597          	auipc	a1,0x7
    802037de:	99e58593          	addi	a1,a1,-1634 # 8020a178 <rodata_start+0x178>
    802037e2:	00007517          	auipc	a0,0x7
    802037e6:	99e50513          	addi	a0,a0,-1634 # 8020a180 <rodata_start+0x180>
    802037ea:	ffffd097          	auipc	ra,0xffffd
    802037ee:	06a080e7          	jalr	106(ra) # 80200854 <_Z6printfPKcz>
  LOG_DEBUG("cal sfn=%s", dst)
    802037f2:	85ce                	mv	a1,s3
    802037f4:	00007517          	auipc	a0,0x7
    802037f8:	09450513          	addi	a0,a0,148 # 8020a888 <_ZL6digits+0x580>
    802037fc:	ffffd097          	auipc	ra,0xffffd
    80203800:	058080e7          	jalr	88(ra) # 80200854 <_Z6printfPKcz>
    80203804:	00007517          	auipc	a0,0x7
    80203808:	89c50513          	addi	a0,a0,-1892 # 8020a0a0 <rodata_start+0xa0>
    8020380c:	ffffd097          	auipc	ra,0xffffd
    80203810:	048080e7          	jalr	72(ra) # 80200854 <_Z6printfPKcz>
  return n + i-8;
    80203814:	012484bb          	addw	s1,s1,s2
    80203818:	34e1                	addiw	s1,s1,-8
}
    8020381a:	8526                	mv	a0,s1
    8020381c:	70e2                	ld	ra,56(sp)
    8020381e:	7442                	ld	s0,48(sp)
    80203820:	74a2                	ld	s1,40(sp)
    80203822:	7902                	ld	s2,32(sp)
    80203824:	69e2                	ld	s3,24(sp)
    80203826:	6a42                	ld	s4,16(sp)
    80203828:	6aa2                	ld	s5,8(sp)
    8020382a:	6121                	addi	sp,sp,64
    8020382c:	8082                	ret
    8020382e:	8aa6                	mv	s5,s1
    80203830:	b5d5                	j	80203714 <_Z7copysfnPcS_b+0x34>
  for (i = 8; i < 11 && sfn[i] != 0x20; i++) {
    80203832:	4925                	li	s2,9
    80203834:	b78d                	j	80203796 <_Z7copysfnPcS_b+0xb6>

0000000080203836 <_Z11read_sectorPcj>:
//   tf_walk(tmp_name, fp) return 0;
// }

extern BufferLayer bufferLayer;
// USERLAND
int read_sector(char *data, uint32_t sector) {
    80203836:	1101                	addi	sp,sp,-32
    80203838:	ec06                	sd	ra,24(sp)
    8020383a:	e822                	sd	s0,16(sp)
    8020383c:	e426                	sd	s1,8(sp)
    8020383e:	e04a                	sd	s2,0(sp)
    80203840:	1000                	addi	s0,sp,32
    80203842:	892a                	mv	s2,a0
    80203844:	862e                	mv	a2,a1
  LOG_TRACE("begin read sector=%d", sector);
#ifdef K210
  sdcard_read_sector(reinterpret_cast<uint8_t *>(data), sector);
#else
  struct buf *b = bufferLayer.read(0, sector);
    80203846:	4581                	li	a1,0
    80203848:	00011517          	auipc	a0,0x11
    8020384c:	8a050513          	addi	a0,a0,-1888 # 802140e8 <bufferLayer>
    80203850:	00000097          	auipc	ra,0x0
    80203854:	e28080e7          	jalr	-472(ra) # 80203678 <_ZN11BufferLayer4readEii>
    80203858:	84aa                	mv	s1,a0
  memmove(data, b->data, BSIZE);
    8020385a:	20000613          	li	a2,512
    8020385e:	04c50593          	addi	a1,a0,76
    80203862:	854a                	mv	a0,s2
    80203864:	ffffd097          	auipc	ra,0xffffd
    80203868:	352080e7          	jalr	850(ra) # 80200bb6 <_Z7memmovePvPKvj>
  bufferLayer.freeBuffer(b);
    8020386c:	85a6                	mv	a1,s1
    8020386e:	00011517          	auipc	a0,0x11
    80203872:	87a50513          	addi	a0,a0,-1926 # 802140e8 <bufferLayer>
    80203876:	00000097          	auipc	ra,0x0
    8020387a:	db0080e7          	jalr	-592(ra) # 80203626 <_ZN11BufferLayer10freeBufferEP3buf>
#endif
  LOG_TRACE("end read sector=%d", sector);
  return 0;
}
    8020387e:	4501                	li	a0,0
    80203880:	60e2                	ld	ra,24(sp)
    80203882:	6442                	ld	s0,16(sp)
    80203884:	64a2                	ld	s1,8(sp)
    80203886:	6902                	ld	s2,0(sp)
    80203888:	6105                	addi	sp,sp,32
    8020388a:	8082                	ret

000000008020388c <_Z12write_sectorPcj>:

int write_sector(char *data, uint32_t sector) {
    8020388c:	1101                	addi	sp,sp,-32
    8020388e:	ec06                	sd	ra,24(sp)
    80203890:	e822                	sd	s0,16(sp)
    80203892:	e426                	sd	s1,8(sp)
    80203894:	e04a                	sd	s2,0(sp)
    80203896:	1000                	addi	s0,sp,32
    80203898:	892a                	mv	s2,a0
    8020389a:	862e                	mv	a2,a1
  LOG_TRACE("begin write sector=%d", sector);
#ifdef K210
  sdcard_write_sector(reinterpret_cast<uint8_t *>(data), sector);
#else
  struct buf *b = bufferLayer.allocBuffer(0, sector);
    8020389c:	4581                	li	a1,0
    8020389e:	00011517          	auipc	a0,0x11
    802038a2:	84a50513          	addi	a0,a0,-1974 # 802140e8 <bufferLayer>
    802038a6:	00000097          	auipc	ra,0x0
    802038aa:	ca2080e7          	jalr	-862(ra) # 80203548 <_ZN11BufferLayer11allocBufferEii>
    802038ae:	84aa                	mv	s1,a0
  memmove(b->data, data, BSIZE);
    802038b0:	20000613          	li	a2,512
    802038b4:	85ca                	mv	a1,s2
    802038b6:	04c50513          	addi	a0,a0,76
    802038ba:	ffffd097          	auipc	ra,0xffffd
    802038be:	2fc080e7          	jalr	764(ra) # 80200bb6 <_Z7memmovePvPKvj>
  bufferLayer.write(b);
    802038c2:	85a6                	mv	a1,s1
    802038c4:	00011517          	auipc	a0,0x11
    802038c8:	82450513          	addi	a0,a0,-2012 # 802140e8 <bufferLayer>
    802038cc:	00000097          	auipc	ra,0x0
    802038d0:	dde080e7          	jalr	-546(ra) # 802036aa <_ZN11BufferLayer5writeEP3buf>
  bufferLayer.freeBuffer(b);
    802038d4:	85a6                	mv	a1,s1
    802038d6:	00011517          	auipc	a0,0x11
    802038da:	81250513          	addi	a0,a0,-2030 # 802140e8 <bufferLayer>
    802038de:	00000097          	auipc	ra,0x0
    802038e2:	d48080e7          	jalr	-696(ra) # 80203626 <_ZN11BufferLayer10freeBufferEP3buf>
#endif
  LOG_TRACE("end write sector=%d", sector);
  return 0;
}
    802038e6:	4501                	li	a0,0
    802038e8:	60e2                	ld	ra,24(sp)
    802038ea:	6442                	ld	s0,16(sp)
    802038ec:	64a2                	ld	s1,8(sp)
    802038ee:	6902                	ld	s2,0(sp)
    802038f0:	6105                	addi	sp,sp,32
    802038f2:	8082                	ret

00000000802038f4 <_Z8tf_storev>:
 * SIDE EFFECTS
 *   512 bytes of tf_info.buffer are stored on disk in the sector specified by tf_info.currentSector
 * RETURN
 *   the error code given by the users write_sector() (should be zero for NO ERROR, nonzero otherwise)
 */
int tf_store() {
    802038f4:	1141                	addi	sp,sp,-16
    802038f6:	e406                	sd	ra,8(sp)
    802038f8:	e022                	sd	s0,0(sp)
    802038fa:	0800                	addi	s0,sp,16
  dbg_printf("\r\n[DEBUG-tf_store] Writing sector (%d) to disk.", tf_info.currentSector);
  tf_info.sectorFlags &= ~TF_FLAG_DIRTY;
    802038fc:	0008b797          	auipc	a5,0x8b
    80203900:	70478793          	addi	a5,a5,1796 # 8028f000 <tf_info>
    80203904:	0147c703          	lbu	a4,20(a5)
    80203908:	9b79                	andi	a4,a4,-2
    8020390a:	00e78a23          	sb	a4,20(a5)
  return write_sector(tf_info.buffer, tf_info.currentSector);
    8020390e:	4b8c                	lw	a1,16(a5)
    80203910:	0008b517          	auipc	a0,0x8b
    80203914:	70c50513          	addi	a0,a0,1804 # 8028f01c <tf_info+0x1c>
    80203918:	00000097          	auipc	ra,0x0
    8020391c:	f74080e7          	jalr	-140(ra) # 8020388c <_Z12write_sectorPcj>
}
    80203920:	60a2                	ld	ra,8(sp)
    80203922:	6402                	ld	s0,0(sp)
    80203924:	0141                	addi	sp,sp,16
    80203926:	8082                	ret

0000000080203928 <_Z8tf_fetchj>:
  if (sector == tf_info.currentSector) {
    80203928:	0008b797          	auipc	a5,0x8b
    8020392c:	6e87a783          	lw	a5,1768(a5) # 8028f010 <tf_info+0x10>
    80203930:	04a78d63          	beq	a5,a0,8020398a <_Z8tf_fetchj+0x62>
int tf_fetch(uint32_t sector) {
    80203934:	1101                	addi	sp,sp,-32
    80203936:	ec06                	sd	ra,24(sp)
    80203938:	e822                	sd	s0,16(sp)
    8020393a:	e426                	sd	s1,8(sp)
    8020393c:	e04a                	sd	s2,0(sp)
    8020393e:	1000                	addi	s0,sp,32
    80203940:	892a                	mv	s2,a0
  if (tf_info.sectorFlags & TF_FLAG_DIRTY) {
    80203942:	0008b797          	auipc	a5,0x8b
    80203946:	6d27c783          	lbu	a5,1746(a5) # 8028f014 <tf_info+0x14>
    8020394a:	8b85                	andi	a5,a5,1
  int rc = 0;
    8020394c:	4481                	li	s1,0
  if (tf_info.sectorFlags & TF_FLAG_DIRTY) {
    8020394e:	eb85                	bnez	a5,8020397e <_Z8tf_fetchj+0x56>
  rc |= read_sector(tf_info.buffer, sector);
    80203950:	85ca                	mv	a1,s2
    80203952:	0008b517          	auipc	a0,0x8b
    80203956:	6ca50513          	addi	a0,a0,1738 # 8028f01c <tf_info+0x1c>
    8020395a:	00000097          	auipc	ra,0x0
    8020395e:	edc080e7          	jalr	-292(ra) # 80203836 <_Z11read_sectorPcj>
    80203962:	8cc9                	or	s1,s1,a0
    80203964:	0004851b          	sext.w	a0,s1
  if (!rc) tf_info.currentSector = sector;
    80203968:	e509                	bnez	a0,80203972 <_Z8tf_fetchj+0x4a>
    8020396a:	0008b797          	auipc	a5,0x8b
    8020396e:	6b27a323          	sw	s2,1702(a5) # 8028f010 <tf_info+0x10>
}
    80203972:	60e2                	ld	ra,24(sp)
    80203974:	6442                	ld	s0,16(sp)
    80203976:	64a2                	ld	s1,8(sp)
    80203978:	6902                	ld	s2,0(sp)
    8020397a:	6105                	addi	sp,sp,32
    8020397c:	8082                	ret
    rc |= tf_store();
    8020397e:	00000097          	auipc	ra,0x0
    80203982:	f76080e7          	jalr	-138(ra) # 802038f4 <_Z8tf_storev>
    80203986:	84aa                	mv	s1,a0
    dbg_printf("\r\n[DEBUG-tf_fetch] Current sector (%d) dirty... storing to disk.", tf_info.currentSector);
    80203988:	b7e1                	j	80203950 <_Z8tf_fetchj+0x28>
    return 0;
    8020398a:	4501                	li	a0,0
}
    8020398c:	8082                	ret

000000008020398e <_Z16tf_get_fat_entryj>:
 * SIDE EFFECTS
 *   Retreives whatever sector happens to contain that FAT entry (if it's not already in memory)
 * RETURN
 *   The value of the fat entry for the specified cluster.
 */
uint32_t tf_get_fat_entry(uint32_t cluster) {
    8020398e:	1101                	addi	sp,sp,-32
    80203990:	ec06                	sd	ra,24(sp)
    80203992:	e822                	sd	s0,16(sp)
    80203994:	e426                	sd	s1,8(sp)
    80203996:	e04a                	sd	s2,0(sp)
    80203998:	1000                	addi	s0,sp,32
  tf_printf("\r\n        [DEBUG-tf_get_fat_entry] %x ", cluster);
  uint32_t offset = cluster * 4;
    8020399a:	0025149b          	slliw	s1,a0,0x2
  tf_fetch(tf_info.reservedSectors + (offset / 512));  // 512 is hardcoded bpb->bytesPerSector
    8020399e:	0008b917          	auipc	s2,0x8b
    802039a2:	66290913          	addi	s2,s2,1634 # 8028f000 <tf_info>
    802039a6:	00c95503          	lhu	a0,12(s2)
    802039aa:	0094d79b          	srliw	a5,s1,0x9
    802039ae:	9d3d                	addw	a0,a0,a5
    802039b0:	00000097          	auipc	ra,0x0
    802039b4:	f78080e7          	jalr	-136(ra) # 80203928 <_Z8tf_fetchj>
  tf_printf("\r\n        [DEBUG-tf_get_fat_entry] done");
  return *((uint32_t *)&(tf_info.buffer[offset % 512]));
    802039b8:	1fc4f493          	andi	s1,s1,508
    802039bc:	94ca                	add	s1,s1,s2
}
    802039be:	4cc8                	lw	a0,28(s1)
    802039c0:	60e2                	ld	ra,24(sp)
    802039c2:	6442                	ld	s0,16(sp)
    802039c4:	64a2                	ld	s1,8(sp)
    802039c6:	6902                	ld	s2,0(sp)
    802039c8:	6105                	addi	sp,sp,32
    802039ca:	8082                	ret

00000000802039cc <_Z16tf_set_fat_entryjj>:
 * RETURN
 *   0 for no error, or nonzero for error with fetch
 * TODO
 *   Does the sector modified here need to be flagged as dirty?
 */
int tf_set_fat_entry(uint32_t cluster, uint32_t value) {
    802039cc:	7179                	addi	sp,sp,-48
    802039ce:	f406                	sd	ra,40(sp)
    802039d0:	f022                	sd	s0,32(sp)
    802039d2:	ec26                	sd	s1,24(sp)
    802039d4:	e84a                	sd	s2,16(sp)
    802039d6:	e44e                	sd	s3,8(sp)
    802039d8:	1800                	addi	s0,sp,48
    802039da:	89ae                	mv	s3,a1
  uint32_t offset;
  int rc;
  tf_printf("\r\n        [DEBUG-tf_set_fat_entry] %x  %x ", cluster, value);
  offset = cluster * 4;                                     // FAT32
    802039dc:	0025149b          	slliw	s1,a0,0x2
  rc = tf_fetch(tf_info.reservedSectors + (offset / 512));  // 512 is hardcoded bpb->bytesPerSector
    802039e0:	0008b917          	auipc	s2,0x8b
    802039e4:	62090913          	addi	s2,s2,1568 # 8028f000 <tf_info>
    802039e8:	00c95503          	lhu	a0,12(s2)
    802039ec:	0094d79b          	srliw	a5,s1,0x9
    802039f0:	9d3d                	addw	a0,a0,a5
    802039f2:	00000097          	auipc	ra,0x0
    802039f6:	f36080e7          	jalr	-202(ra) # 80203928 <_Z8tf_fetchj>
  if (*((uint32_t *)&(tf_info.buffer[offset % 512])) != value) {
    802039fa:	1fc4f493          	andi	s1,s1,508
    802039fe:	04f1                	addi	s1,s1,28
    80203a00:	94ca                	add	s1,s1,s2
    80203a02:	409c                	lw	a5,0(s1)
    80203a04:	01378a63          	beq	a5,s3,80203a18 <_Z16tf_set_fat_entryjj+0x4c>
    tf_info.sectorFlags |= TF_FLAG_DIRTY;  // Mark this sector as dirty
    80203a08:	01494783          	lbu	a5,20(s2)
    80203a0c:	0017e793          	ori	a5,a5,1
    80203a10:	00f90a23          	sb	a5,20(s2)
    *((uint32_t *)&(tf_info.buffer[offset % 512])) = value;
    80203a14:	0134a023          	sw	s3,0(s1)
  }
  tf_printf("\r\n        [DEBUG-tf_set_fat_entry] done");
  return rc;
}
    80203a18:	70a2                	ld	ra,40(sp)
    80203a1a:	7402                	ld	s0,32(sp)
    80203a1c:	64e2                	ld	s1,24(sp)
    80203a1e:	6942                	ld	s2,16(sp)
    80203a20:	69a2                	ld	s3,8(sp)
    80203a22:	6145                	addi	sp,sp,48
    80203a24:	8082                	ret

0000000080203a26 <_Z15tf_first_sectorj>:
 * ARGS
 *   cluster - The cluster of interest
 * RETURN
 *   The first sector of the provided cluster
 */
uint32_t tf_first_sector(uint32_t cluster) {
    80203a26:	1141                	addi	sp,sp,-16
    80203a28:	e422                	sd	s0,8(sp)
    80203a2a:	0800                	addi	s0,sp,16
  return ((cluster - 2) * tf_info.sectorsPerCluster) + tf_info.firstDataSector;
    80203a2c:	3579                	addiw	a0,a0,-2
    80203a2e:	0008b797          	auipc	a5,0x8b
    80203a32:	5d278793          	addi	a5,a5,1490 # 8028f000 <tf_info>
    80203a36:	0017c703          	lbu	a4,1(a5)
    80203a3a:	02e5053b          	mulw	a0,a0,a4
    80203a3e:	43dc                	lw	a5,4(a5)
}
    80203a40:	9d3d                	addw	a0,a0,a5
    80203a42:	6422                	ld	s0,8(sp)
    80203a44:	0141                	addi	sp,sp,16
    80203a46:	8082                	ret

0000000080203a48 <_Z18tf_get_free_handlev>:
/*
 * Searches the list of system file handles for a free one, and returns it.
 * RETURN
 *   NULL if no system file handles are free, or the free handle if one is available.
 */
TFFile *tf_get_free_handle() {
    80203a48:	1141                	addi	sp,sp,-16
    80203a4a:	e422                	sd	s0,8(sp)
    80203a4c:	0800                	addi	s0,sp,16
  int i;
  TFFile *fp;
  for (i = 0; i < TF_FILE_HANDLES; i++) {
    80203a4e:	0008c797          	auipc	a5,0x8c
    80203a52:	5ca78793          	addi	a5,a5,1482 # 80290018 <tf_file_handles+0x18>
    80203a56:	4681                	li	a3,0
    80203a58:	4615                	li	a2,5
    fp = &tf_file_handles[i];
    if (fp->flags & TF_FLAG_OPEN) continue;
    80203a5a:	0007c703          	lbu	a4,0(a5)
    80203a5e:	8b09                	andi	a4,a4,2
    80203a60:	e30d                	bnez	a4,80203a82 <_Z18tf_get_free_handlev+0x3a>
    fp = &tf_file_handles[i];
    80203a62:	0008c717          	auipc	a4,0x8c
    80203a66:	59e70713          	addi	a4,a4,1438 # 80290000 <tf_file_handles>
    80203a6a:	00369793          	slli	a5,a3,0x3
    80203a6e:	00d78533          	add	a0,a5,a3
    80203a72:	0516                	slli	a0,a0,0x5
    80203a74:	953a                	add	a0,a0,a4
    // We get here if we find a free handle
    fp->flags = TF_FLAG_OPEN;
    80203a76:	4709                	li	a4,2
    80203a78:	00e50c23          	sb	a4,24(a0)
    return fp;
  }
  return NULL;
}
    80203a7c:	6422                	ld	s0,8(sp)
    80203a7e:	0141                	addi	sp,sp,16
    80203a80:	8082                	ret
  for (i = 0; i < TF_FILE_HANDLES; i++) {
    80203a82:	2685                	addiw	a3,a3,1
    80203a84:	12078793          	addi	a5,a5,288
    80203a88:	fcc699e3          	bne	a3,a2,80203a5a <_Z18tf_get_free_handlev+0x12>
  return NULL;
    80203a8c:	4501                	li	a0,0
    80203a8e:	b7fd                	j	80203a7c <_Z18tf_get_free_handlev+0x34>

0000000080203a90 <_Z17tf_release_handleP13struct_TFFILE>:

/*
 * Release a filesystem handle (mark as available)
 */
void tf_release_handle(TFFile *fp) { fp->flags &= ~TF_FLAG_OPEN; }
    80203a90:	1141                	addi	sp,sp,-16
    80203a92:	e422                	sd	s0,8(sp)
    80203a94:	0800                	addi	s0,sp,16
    80203a96:	01854783          	lbu	a5,24(a0)
    80203a9a:	9bf5                	andi	a5,a5,-3
    80203a9c:	00f50c23          	sb	a5,24(a0)
    80203aa0:	6422                	ld	s0,8(sp)
    80203aa2:	0141                	addi	sp,sp,16
    80203aa4:	8082                	ret

0000000080203aa6 <_Z5upperc>:

// Convert a character to uppercase
// TODO: Re-do how filename conversions are done.
char upper(char c) {
    80203aa6:	1141                	addi	sp,sp,-16
    80203aa8:	e422                	sd	s0,8(sp)
    80203aaa:	0800                	addi	s0,sp,16
  if (c >= 'a' && c <= 'z') {
    80203aac:	f9f5079b          	addiw	a5,a0,-97
    80203ab0:	0ff7f793          	andi	a5,a5,255
    80203ab4:	4765                	li	a4,25
    80203ab6:	00f76563          	bltu	a4,a5,80203ac0 <_Z5upperc+0x1a>
    return c + ('A' - 'a');
    80203aba:	3501                	addiw	a0,a0,-32
    80203abc:	0ff57513          	andi	a0,a0,255
  } else {
    return c;
  }
}
    80203ac0:	6422                	ld	s0,8(sp)
    80203ac2:	0141                	addi	sp,sp,16
    80203ac4:	8082                	ret

0000000080203ac6 <_Z19tf_shorten_filenamePcS_c>:
 * TODO: This should return something, an error code for conversion failure.
 * TODO: This should handle special chars etc.
 * TODO: Test for short filenames, (<7 characters)
 * TODO: Modify this to use the basis name generation algorithm described in the FAT32 whitepaper.
 */
int tf_shorten_filename(char *dest, char *src, char num) {
    80203ac6:	7119                	addi	sp,sp,-128
    80203ac8:	fc86                	sd	ra,120(sp)
    80203aca:	f8a2                	sd	s0,112(sp)
    80203acc:	f4a6                	sd	s1,104(sp)
    80203ace:	f0ca                	sd	s2,96(sp)
    80203ad0:	ecce                	sd	s3,88(sp)
    80203ad2:	e8d2                	sd	s4,80(sp)
    80203ad4:	e4d6                	sd	s5,72(sp)
    80203ad6:	e0da                	sd	s6,64(sp)
    80203ad8:	fc5e                	sd	s7,56(sp)
    80203ada:	f862                	sd	s8,48(sp)
    80203adc:	f466                	sd	s9,40(sp)
    80203ade:	f06a                	sd	s10,32(sp)
    80203ae0:	ec6e                	sd	s11,24(sp)
    80203ae2:	0100                	addi	s0,sp,128
    80203ae4:	8aaa                	mv	s5,a0
    80203ae6:	84ae                	mv	s1,a1
    80203ae8:	f8c43423          	sd	a2,-120(s0)
  char *orig_dest = dest;
  char *orig_src = src;
#endif
  // strip through and chop special chars

  tmp = strrchr(src, '.');
    80203aec:	02e00593          	li	a1,46
    80203af0:	8526                	mv	a0,s1
    80203af2:	ffffd097          	auipc	ra,0xffffd
    80203af6:	2a8080e7          	jalr	680(ra) # 80200d9a <_Z7strrchrPKcc>
    80203afa:	892a                	mv	s2,a0
  // copy the extension
  for (i = 0; i < 3; i++) {
    80203afc:	008a8b13          	addi	s6,s5,8
    80203b00:	00ba8c93          	addi	s9,s5,11
    while (tmp != 0 && *tmp != 0 &&
    80203b04:	06900993          	li	s3,105
           !(*tmp < 0x7f && *tmp > 20 && *tmp != 0x22 && *tmp != 0x2a && *tmp != 0x2e && *tmp != 0x2f && *tmp != 0x3a &&
    80203b08:	03b00a13          	li	s4,59
    80203b0c:	03c00c13          	li	s8,60
    80203b10:	00007b97          	auipc	s7,0x7
    80203b14:	390b8b93          	addi	s7,s7,912 # 8020aea0 <erodata>
             *tmp != 0x3c && *tmp != 0x3e && *tmp != 0x3f && *tmp != 0x5b && *tmp != 0x5c && *tmp != 0x5d &&
             *tmp != 0x7c))
      tmp++;
    if (tmp == 0 || *tmp == 0)
      *(dest + 8 + i) = ' ';
    80203b18:	02000d13          	li	s10,32
    80203b1c:	a899                	j	80203b72 <_Z19tf_shorten_filenamePcS_c+0xac>
      tmp++;
    80203b1e:	0905                	addi	s2,s2,1
    while (tmp != 0 && *tmp != 0 &&
    80203b20:	00094783          	lbu	a5,0(s2)
    80203b24:	c79d                	beqz	a5,80203b52 <_Z19tf_shorten_filenamePcS_c+0x8c>
           !(*tmp < 0x7f && *tmp > 20 && *tmp != 0x22 && *tmp != 0x2a && *tmp != 0x2e && *tmp != 0x2f && *tmp != 0x3a &&
    80203b26:	feb7871b          	addiw	a4,a5,-21
    while (tmp != 0 && *tmp != 0 &&
    80203b2a:	0ff77713          	andi	a4,a4,255
    80203b2e:	fee9e8e3          	bltu	s3,a4,80203b1e <_Z19tf_shorten_filenamePcS_c+0x58>
           !(*tmp < 0x7f && *tmp > 20 && *tmp != 0x22 && *tmp != 0x2a && *tmp != 0x2e && *tmp != 0x2f && *tmp != 0x3a &&
    80203b32:	fde7871b          	addiw	a4,a5,-34
    80203b36:	0ff77713          	andi	a4,a4,255
    80203b3a:	00ea6863          	bltu	s4,a4,80203b4a <_Z19tf_shorten_filenamePcS_c+0x84>
    80203b3e:	000bb683          	ld	a3,0(s7)
    80203b42:	00e6d733          	srl	a4,a3,a4
    80203b46:	8b05                	andi	a4,a4,1
    80203b48:	fb79                	bnez	a4,80203b1e <_Z19tf_shorten_filenamePcS_c+0x58>
    80203b4a:	0bf7f793          	andi	a5,a5,191
    80203b4e:	fd8788e3          	beq	a5,s8,80203b1e <_Z19tf_shorten_filenamePcS_c+0x58>
    if (tmp == 0 || *tmp == 0)
    80203b52:	00094503          	lbu	a0,0(s2)
    80203b56:	c909                	beqz	a0,80203b68 <_Z19tf_shorten_filenamePcS_c+0xa2>
    else
      *(dest + 8 + i) = upper(*(tmp++));
    80203b58:	0905                	addi	s2,s2,1
    80203b5a:	00000097          	auipc	ra,0x0
    80203b5e:	f4c080e7          	jalr	-180(ra) # 80203aa6 <_Z5upperc>
    80203b62:	00ab0023          	sb	a0,0(s6)
    80203b66:	a019                	j	80203b6c <_Z19tf_shorten_filenamePcS_c+0xa6>
      *(dest + 8 + i) = ' ';
    80203b68:	01ab0023          	sb	s10,0(s6)
  for (i = 0; i < 3; i++) {
    80203b6c:	0b05                	addi	s6,s6,1
    80203b6e:	019b0563          	beq	s6,s9,80203b78 <_Z19tf_shorten_filenamePcS_c+0xb2>
    while (tmp != 0 && *tmp != 0 &&
    80203b72:	fa0917e3          	bnez	s2,80203b20 <_Z19tf_shorten_filenamePcS_c+0x5a>
    80203b76:	bfcd                	j	80203b68 <_Z19tf_shorten_filenamePcS_c+0xa2>
  }

  // Copy the basename
  i = 0;
  tmp = strrchr(src, '.');
    80203b78:	02e00593          	li	a1,46
    80203b7c:	8526                	mv	a0,s1
    80203b7e:	ffffd097          	auipc	ra,0xffffd
    80203b82:	21c080e7          	jalr	540(ra) # 80200d9a <_Z7strrchrPKcc>
    80203b86:	8c2a                	mv	s8,a0
    80203b88:	4981                	li	s3,0
    if (src == tmp) {
      dest[i++] = ' ';
      continue;
    }

    if ((*dest == ' ')) {
    80203b8a:	02000d13          	li	s10,32
      lossy_flag = 1;
    } else {
      while (*src != 0 && !(*src < 0x7f && *src > 20 && *src != 0x22 && *src != 0x2a && *src != 0x2e && *src != 0x2f &&
    80203b8e:	06900913          	li	s2,105
    80203b92:	03b00a13          	li	s4,59
                            *src != 0x3a && *src != 0x3c && *src != 0x3e && *src != 0x3f && *src != 0x5b &&
    80203b96:	03c00b93          	li	s7,60
      while (*src != 0 && !(*src < 0x7f && *src > 20 && *src != 0x22 && *src != 0x2a && *src != 0x2e && *src != 0x2f &&
    80203b9a:	00007b17          	auipc	s6,0x7
    80203b9e:	306b0b13          	addi	s6,s6,774 # 8020aea0 <erodata>
                            *src != 0x5c && *src != 0x5d && *src != 0x7c))
        src++;
      if (*src == 0)
        dest[i] = ' ';
    80203ba2:	02000d93          	li	s11,32
    if (i == 8) break;
    80203ba6:	4ca1                	li	s9,8
    80203ba8:	a209                	j	80203caa <_Z19tf_shorten_filenamePcS_c+0x1e4>
      dest[i++] = ' ';
    80203baa:	0019879b          	addiw	a5,s3,1
    80203bae:	013a8733          	add	a4,s5,s3
    80203bb2:	01b70023          	sb	s11,0(a4)
      continue;
    80203bb6:	a0fd                	j	80203ca4 <_Z19tf_shorten_filenamePcS_c+0x1de>
        src++;
    80203bb8:	0485                	addi	s1,s1,1
      while (*src != 0 && !(*src < 0x7f && *src > 20 && *src != 0x22 && *src != 0x2a && *src != 0x2e && *src != 0x2f &&
    80203bba:	0004c503          	lbu	a0,0(s1)
    80203bbe:	cd69                	beqz	a0,80203c98 <_Z19tf_shorten_filenamePcS_c+0x1d2>
    80203bc0:	feb5079b          	addiw	a5,a0,-21
    80203bc4:	0ff7f793          	andi	a5,a5,255
    80203bc8:	fef968e3          	bltu	s2,a5,80203bb8 <_Z19tf_shorten_filenamePcS_c+0xf2>
    80203bcc:	fde5079b          	addiw	a5,a0,-34
    80203bd0:	0ff7f793          	andi	a5,a5,255
    80203bd4:	00fa6863          	bltu	s4,a5,80203be4 <_Z19tf_shorten_filenamePcS_c+0x11e>
    80203bd8:	000b3703          	ld	a4,0(s6)
    80203bdc:	00f757b3          	srl	a5,a4,a5
    80203be0:	8b85                	andi	a5,a5,1
    80203be2:	fbf9                	bnez	a5,80203bb8 <_Z19tf_shorten_filenamePcS_c+0xf2>
                            *src != 0x3a && *src != 0x3c && *src != 0x3e && *src != 0x3f && *src != 0x5b &&
    80203be4:	0bf57793          	andi	a5,a0,191
    80203be8:	fd7788e3          	beq	a5,s7,80203bb8 <_Z19tf_shorten_filenamePcS_c+0xf2>
      else if (*src == ',' || *src == '[' || *src == ']')
    80203bec:	02c00793          	li	a5,44
    80203bf0:	02f50163          	beq	a0,a5,80203c12 <_Z19tf_shorten_filenamePcS_c+0x14c>
    80203bf4:	fa55079b          	addiw	a5,a0,-91
    80203bf8:	0fd7f793          	andi	a5,a5,253
    80203bfc:	cb99                	beqz	a5,80203c12 <_Z19tf_shorten_filenamePcS_c+0x14c>
        dest[i] = '_';
      else
        dest[i] = upper(*(src++));
    80203bfe:	0485                	addi	s1,s1,1
    80203c00:	00000097          	auipc	ra,0x0
    80203c04:	ea6080e7          	jalr	-346(ra) # 80203aa6 <_Z5upperc>
    80203c08:	013a87b3          	add	a5,s5,s3
    80203c0c:	00a78023          	sb	a0,0(a5)
    80203c10:	a841                	j	80203ca0 <_Z19tf_shorten_filenamePcS_c+0x1da>
        dest[i] = '_';
    80203c12:	013a87b3          	add	a5,s5,s3
    80203c16:	05f00713          	li	a4,95
    80203c1a:	00e78023          	sb	a4,0(a5)
    80203c1e:	a049                	j	80203ca0 <_Z19tf_shorten_filenamePcS_c+0x1da>
    }
    i += 1;
  }
  // now that they are populated, do analysis.
  // if num>4, do 2 letters
  if (num > 4) {
    80203c20:	4791                	li	a5,4
    80203c22:	f8843703          	ld	a4,-120(s0)
    80203c26:	02e7f663          	bgeu	a5,a4,80203c52 <_Z19tf_shorten_filenamePcS_c+0x18c>
    // snprintf(dest+2, 6, "%.4X~", num);// TODO
    dest[7] = '1';
    80203c2a:	03100793          	li	a5,49
    80203c2e:	00fa83a3          	sb	a5,7(s5)
      *(dest++) = upper(*(src++));
      i+=1;
      }
  }*/
  return 0;
}
    80203c32:	4501                	li	a0,0
    80203c34:	70e6                	ld	ra,120(sp)
    80203c36:	7446                	ld	s0,112(sp)
    80203c38:	74a6                	ld	s1,104(sp)
    80203c3a:	7906                	ld	s2,96(sp)
    80203c3c:	69e6                	ld	s3,88(sp)
    80203c3e:	6a46                	ld	s4,80(sp)
    80203c40:	6aa6                	ld	s5,72(sp)
    80203c42:	6b06                	ld	s6,64(sp)
    80203c44:	7be2                	ld	s7,56(sp)
    80203c46:	7c42                	ld	s8,48(sp)
    80203c48:	7ca2                	ld	s9,40(sp)
    80203c4a:	7d02                	ld	s10,32(sp)
    80203c4c:	6de2                	ld	s11,24(sp)
    80203c4e:	6109                	addi	sp,sp,128
    80203c50:	8082                	ret
    tmp = strchr(dest, ' ');
    80203c52:	02000593          	li	a1,32
    80203c56:	8556                	mv	a0,s5
    80203c58:	ffffd097          	auipc	ra,0xffffd
    80203c5c:	11e080e7          	jalr	286(ra) # 80200d76 <_Z6strchrPKcc>
    if (tmp == 0 || tmp - dest > 6) {
    80203c60:	c511                	beqz	a0,80203c6c <_Z19tf_shorten_filenamePcS_c+0x1a6>
    80203c62:	415507b3          	sub	a5,a0,s5
    80203c66:	4719                	li	a4,6
    80203c68:	00f75d63          	bge	a4,a5,80203c82 <_Z19tf_shorten_filenamePcS_c+0x1bc>
      dest[6] = '~';
    80203c6c:	07e00793          	li	a5,126
    80203c70:	00fa8323          	sb	a5,6(s5)
      dest[7] = num + 0x30;
    80203c74:	f8843783          	ld	a5,-120(s0)
    80203c78:	0307879b          	addiw	a5,a5,48
    80203c7c:	00fa83a3          	sb	a5,7(s5)
    80203c80:	bf4d                	j	80203c32 <_Z19tf_shorten_filenamePcS_c+0x16c>
      *tmp++ = '~';
    80203c82:	07e00793          	li	a5,126
    80203c86:	00f50023          	sb	a5,0(a0)
      *tmp++ = num + 0x30;
    80203c8a:	f8843783          	ld	a5,-120(s0)
    80203c8e:	0307879b          	addiw	a5,a5,48
    80203c92:	00f500a3          	sb	a5,1(a0)
  return 0;
    80203c96:	bf71                	j	80203c32 <_Z19tf_shorten_filenamePcS_c+0x16c>
        dest[i] = ' ';
    80203c98:	013a87b3          	add	a5,s5,s3
    80203c9c:	01b78023          	sb	s11,0(a5)
    i += 1;
    80203ca0:	0019879b          	addiw	a5,s3,1
    if (i == 8) break;
    80203ca4:	0985                	addi	s3,s3,1
    80203ca6:	f7978de3          	beq	a5,s9,80203c20 <_Z19tf_shorten_filenamePcS_c+0x15a>
    if (src == tmp) {
    80203caa:	f09c00e3          	beq	s8,s1,80203baa <_Z19tf_shorten_filenamePcS_c+0xe4>
    if ((*dest == ' ')) {
    80203cae:	000ac783          	lbu	a5,0(s5)
    80203cb2:	ffa787e3          	beq	a5,s10,80203ca0 <_Z19tf_shorten_filenamePcS_c+0x1da>
      while (*src != 0 && !(*src < 0x7f && *src > 20 && *src != 0x22 && *src != 0x2a && *src != 0x2e && *src != 0x2f &&
    80203cb6:	0004c503          	lbu	a0,0(s1)
    80203cba:	f119                	bnez	a0,80203bc0 <_Z19tf_shorten_filenamePcS_c+0xfa>
    80203cbc:	bff1                	j	80203c98 <_Z19tf_shorten_filenamePcS_c+0x1d2>

0000000080203cbe <_Z19tf_create_lfn_entryPcP19struct_FatFileEntry>:
 *   NOT COMPUTE LFN SEQUENCE NUMBERS.  You have to do that on your own.  Also, because the function
 *   acts on partial filenames IT DOES NOT COMPUTE LFN CHECKSUMS.  You also have to do that on your own.
 * TODO
 *   Test and further improve on this function
 */
char *tf_create_lfn_entry(char *filename, FatFileEntry *entry) {
    80203cbe:	1141                	addi	sp,sp,-16
    80203cc0:	e422                	sd	s0,8(sp)
    80203cc2:	0800                	addi	s0,sp,16
    80203cc4:	882a                	mv	a6,a0
    80203cc6:	872a                	mv	a4,a0
  int i, done = 0;
    80203cc8:	4681                	li	a3,0
  tf_printf("\r\n--tf_create_lfn_entry: %s", filename);
  for (i = 0; i < 5; i++) {
    80203cca:	4781                	li	a5,0
    if (!done)
      entry->lfn.name1[i] = (unsigned short)*(filename);
    else
      entry->lfn.name1[i] = 0xffff;
    80203ccc:	58fd                	li	a7,-1
    if (*filename++ == '\x00') done = 1;
    80203cce:	4e05                	li	t3,1
  for (i = 0; i < 5; i++) {
    80203cd0:	4515                	li	a0,5
    80203cd2:	a03d                	j	80203d00 <_Z19tf_create_lfn_entryPcP19struct_FatFileEntry+0x42>
    80203cd4:	00580713          	addi	a4,a6,5
  }
  for (i = 0; i < 6; i++) {
    80203cd8:	4781                	li	a5,0
    if (!done)
      entry->lfn.name2[i] = (unsigned short)*(filename);
    else
      entry->lfn.name2[i] = 0xffff;
    80203cda:	58fd                	li	a7,-1
    if (*filename++ == '\x00') done = 1;
    80203cdc:	4e05                	li	t3,1
  for (i = 0; i < 6; i++) {
    80203cde:	4519                	li	a0,6
    80203ce0:	a075                	j	80203d8c <_Z19tf_create_lfn_entryPcP19struct_FatFileEntry+0xce>
      entry->lfn.name1[i] = 0xffff;
    80203ce2:	00179613          	slli	a2,a5,0x1
    80203ce6:	962e                	add	a2,a2,a1
    80203ce8:	011600a3          	sb	a7,1(a2)
    80203cec:	01160123          	sb	a7,2(a2)
    if (*filename++ == '\x00') done = 1;
    80203cf0:	0705                	addi	a4,a4,1
    80203cf2:	fff74603          	lbu	a2,-1(a4)
    80203cf6:	e211                	bnez	a2,80203cfa <_Z19tf_create_lfn_entryPcP19struct_FatFileEntry+0x3c>
    80203cf8:	86f2                	mv	a3,t3
  for (i = 0; i < 5; i++) {
    80203cfa:	2785                	addiw	a5,a5,1
    80203cfc:	fca78ce3          	beq	a5,a0,80203cd4 <_Z19tf_create_lfn_entryPcP19struct_FatFileEntry+0x16>
    if (!done)
    80203d00:	f2ed                	bnez	a3,80203ce2 <_Z19tf_create_lfn_entryPcP19struct_FatFileEntry+0x24>
      entry->lfn.name1[i] = (unsigned short)*(filename);
    80203d02:	00179613          	slli	a2,a5,0x1
    80203d06:	962e                	add	a2,a2,a1
    80203d08:	00074303          	lbu	t1,0(a4)
    80203d0c:	006600a3          	sb	t1,1(a2)
    80203d10:	00060123          	sb	zero,2(a2)
    80203d14:	bff1                	j	80203cf0 <_Z19tf_create_lfn_entryPcP19struct_FatFileEntry+0x32>
  }
  for (i = 0; i < 2; i++) {
    if (!done)
    80203d16:	caa9                	beqz	a3,80203d68 <_Z19tf_create_lfn_entryPcP19struct_FatFileEntry+0xaa>
      entry->lfn.name3[i] = (unsigned short)*(filename);
    else
      entry->lfn.name3[i] = 0xffff;
    80203d18:	57fd                	li	a5,-1
    80203d1a:	00f58e23          	sb	a5,28(a1)
    80203d1e:	00f58ea3          	sb	a5,29(a1)
    if (*filename++ == '\x00') done = 1;
    80203d22:	00b84783          	lbu	a5,11(a6)
    80203d26:	c3d9                	beqz	a5,80203dac <_Z19tf_create_lfn_entryPcP19struct_FatFileEntry+0xee>
    if (!done)
    80203d28:	e2d9                	bnez	a3,80203dae <_Z19tf_create_lfn_entryPcP19struct_FatFileEntry+0xf0>
      entry->lfn.name3[i] = (unsigned short)*(filename);
    80203d2a:	00c84783          	lbu	a5,12(a6)
    80203d2e:	00f58f23          	sb	a5,30(a1)
    80203d32:	00058fa3          	sb	zero,31(a1)
    if (*filename++ == '\x00') done = 1;
    80203d36:	00c84783          	lbu	a5,12(a6)
    80203d3a:	c3d1                	beqz	a5,80203dbe <_Z19tf_create_lfn_entryPcP19struct_FatFileEntry+0x100>
  for (i = 0; i < 2; i++) {
    80203d3c:	00d80513          	addi	a0,a6,13
  }

  entry->lfn.attributes = TF_ATTR_LONG_NAME;
    80203d40:	47bd                	li	a5,15
    80203d42:	00f585a3          	sb	a5,11(a1)
  entry->lfn.reserved = 0;
    80203d46:	00058623          	sb	zero,12(a1)
  entry->lfn.firstCluster = 0;
    80203d4a:	00058d23          	sb	zero,26(a1)
    80203d4e:	00058da3          	sb	zero,27(a1)
  if (done) return NULL;
    80203d52:	e6a5                	bnez	a3,80203dba <_Z19tf_create_lfn_entryPcP19struct_FatFileEntry+0xfc>
  if (*filename)
    80203d54:	00d84783          	lbu	a5,13(a6)
    return filename;
  else
    return NULL;
    80203d58:	00f037b3          	snez	a5,a5
    80203d5c:	40f007b3          	neg	a5,a5
    80203d60:	8d7d                	and	a0,a0,a5
}
    80203d62:	6422                	ld	s0,8(sp)
    80203d64:	0141                	addi	sp,sp,16
    80203d66:	8082                	ret
      entry->lfn.name3[i] = (unsigned short)*(filename);
    80203d68:	00b84783          	lbu	a5,11(a6)
    80203d6c:	00f58e23          	sb	a5,28(a1)
    80203d70:	00058ea3          	sb	zero,29(a1)
    80203d74:	b77d                	j	80203d22 <_Z19tf_create_lfn_entryPcP19struct_FatFileEntry+0x64>
      entry->lfn.name2[i] = 0xffff;
    80203d76:	00179613          	slli	a2,a5,0x1
    80203d7a:	962e                	add	a2,a2,a1
    80203d7c:	01160723          	sb	a7,14(a2)
    80203d80:	011607a3          	sb	a7,15(a2)
    80203d84:	a831                	j	80203da0 <_Z19tf_create_lfn_entryPcP19struct_FatFileEntry+0xe2>
  for (i = 0; i < 6; i++) {
    80203d86:	2785                	addiw	a5,a5,1
    80203d88:	f8a787e3          	beq	a5,a0,80203d16 <_Z19tf_create_lfn_entryPcP19struct_FatFileEntry+0x58>
    if (!done)
    80203d8c:	f6ed                	bnez	a3,80203d76 <_Z19tf_create_lfn_entryPcP19struct_FatFileEntry+0xb8>
      entry->lfn.name2[i] = (unsigned short)*(filename);
    80203d8e:	00179613          	slli	a2,a5,0x1
    80203d92:	962e                	add	a2,a2,a1
    80203d94:	00074303          	lbu	t1,0(a4)
    80203d98:	00660723          	sb	t1,14(a2)
    80203d9c:	000607a3          	sb	zero,15(a2)
    if (*filename++ == '\x00') done = 1;
    80203da0:	0705                	addi	a4,a4,1
    80203da2:	fff74603          	lbu	a2,-1(a4)
    80203da6:	f265                	bnez	a2,80203d86 <_Z19tf_create_lfn_entryPcP19struct_FatFileEntry+0xc8>
    80203da8:	86f2                	mv	a3,t3
    80203daa:	bff1                	j	80203d86 <_Z19tf_create_lfn_entryPcP19struct_FatFileEntry+0xc8>
    if (*filename++ == '\x00') done = 1;
    80203dac:	4685                	li	a3,1
      entry->lfn.name3[i] = 0xffff;
    80203dae:	57fd                	li	a5,-1
    80203db0:	00f58f23          	sb	a5,30(a1)
    80203db4:	00f58fa3          	sb	a5,31(a1)
    80203db8:	bfbd                	j	80203d36 <_Z19tf_create_lfn_entryPcP19struct_FatFileEntry+0x78>
  if (done) return NULL;
    80203dba:	4501                	li	a0,0
    80203dbc:	b75d                	j	80203d62 <_Z19tf_create_lfn_entryPcP19struct_FatFileEntry+0xa4>
  entry->lfn.attributes = TF_ATTR_LONG_NAME;
    80203dbe:	47bd                	li	a5,15
    80203dc0:	00f585a3          	sb	a5,11(a1)
  entry->lfn.reserved = 0;
    80203dc4:	00058623          	sb	zero,12(a1)
  entry->lfn.firstCluster = 0;
    80203dc8:	00058d23          	sb	zero,26(a1)
    80203dcc:	00058da3          	sb	zero,27(a1)
  if (done) return NULL;
    80203dd0:	4501                	li	a0,0
    80203dd2:	bf41                	j	80203d62 <_Z19tf_create_lfn_entryPcP19struct_FatFileEntry+0xa4>

0000000080203dd4 <_Z15tf_lfn_checksumPKc>:
// Taken from http://en.wikipedia.org/wiki/File_Allocation_Table
//
char tf_lfn_checksum(const char *pFcbName) {
    80203dd4:	1141                	addi	sp,sp,-16
    80203dd6:	e422                	sd	s0,8(sp)
    80203dd8:	0800                	addi	s0,sp,16
    80203dda:	872a                	mv	a4,a0
  int i;
  char sum = 0;

  for (i = 11; i; i--) sum = ((sum & 1) << 7) + (sum >> 1) + *pFcbName++;
    80203ddc:	00b50693          	addi	a3,a0,11
  char sum = 0;
    80203de0:	4501                	li	a0,0
  for (i = 11; i; i--) sum = ((sum & 1) << 7) + (sum >> 1) + *pFcbName++;
    80203de2:	0015579b          	srliw	a5,a0,0x1
    80203de6:	0075151b          	slliw	a0,a0,0x7
    80203dea:	8fc9                	or	a5,a5,a0
    80203dec:	0705                	addi	a4,a4,1
    80203dee:	fff74503          	lbu	a0,-1(a4)
    80203df2:	97aa                	add	a5,a5,a0
    80203df4:	0ff7f513          	andi	a0,a5,255
    80203df8:	fee695e3          	bne	a3,a4,80203de2 <_Z15tf_lfn_checksumPKc+0xe>
  return sum;
}
    80203dfc:	6422                	ld	s0,8(sp)
    80203dfe:	0141                	addi	sp,sp,16
    80203e00:	8082                	ret

0000000080203e02 <_Z20tf_free_clusterchainj>:

  fp->filename[n] = 0;
  return fp;
}

int tf_free_clusterchain(uint32_t cluster) {
    80203e02:	7179                	addi	sp,sp,-48
    80203e04:	f406                	sd	ra,40(sp)
    80203e06:	f022                	sd	s0,32(sp)
    80203e08:	ec26                	sd	s1,24(sp)
    80203e0a:	e84a                	sd	s2,16(sp)
    80203e0c:	e44e                	sd	s3,8(sp)
    80203e0e:	1800                	addi	s0,sp,48
    80203e10:	84aa                	mv	s1,a0
  uint32_t fat_entry;
  dbg_printf("\r\n[DEBUG-tf_free_clusterchain] Freeing clusterchain starting at cluster %d... ", cluster);
  fat_entry = tf_get_fat_entry(cluster);
    80203e12:	00000097          	auipc	ra,0x0
    80203e16:	b7c080e7          	jalr	-1156(ra) # 8020398e <_Z16tf_get_fat_entryj>
    80203e1a:	0005091b          	sext.w	s2,a0
  while (fat_entry < TF_MARK_EOC32) {
    if (fat_entry <= 2)  // catch-all to save root directory from corrupted stuff
    80203e1e:	3575                	addiw	a0,a0,-3
    80203e20:	100007b7          	lui	a5,0x10000
    80203e24:	17ed                	addi	a5,a5,-5
    80203e26:	02a7e563          	bltu	a5,a0,80203e50 <_Z20tf_free_clusterchainj+0x4e>
    80203e2a:	89be                	mv	s3,a5
    80203e2c:	a011                	j	80203e30 <_Z20tf_free_clusterchainj+0x2e>
          "0x0ffffff8)\r\n");
      break;
    }
    dbg_printf("\r\n[DEBUG-tf_free_clusterchain] Freeing cluster %d... ", fat_entry);
    tf_set_fat_entry(cluster, 0x00000000);
    fat_entry = tf_get_fat_entry(fat_entry);
    80203e2e:	8926                	mv	s2,s1
    tf_set_fat_entry(cluster, 0x00000000);
    80203e30:	4581                	li	a1,0
    80203e32:	8526                	mv	a0,s1
    80203e34:	00000097          	auipc	ra,0x0
    80203e38:	b98080e7          	jalr	-1128(ra) # 802039cc <_Z16tf_set_fat_entryjj>
    fat_entry = tf_get_fat_entry(fat_entry);
    80203e3c:	854a                	mv	a0,s2
    80203e3e:	00000097          	auipc	ra,0x0
    80203e42:	b50080e7          	jalr	-1200(ra) # 8020398e <_Z16tf_get_fat_entryj>
    80203e46:	0005049b          	sext.w	s1,a0
    if (fat_entry <= 2)  // catch-all to save root directory from corrupted stuff
    80203e4a:	3575                	addiw	a0,a0,-3
    80203e4c:	fea9f1e3          	bgeu	s3,a0,80203e2e <_Z20tf_free_clusterchainj+0x2c>
    cluster = fat_entry;
  }
  return 0;
}
    80203e50:	4501                	li	a0,0
    80203e52:	70a2                	ld	ra,40(sp)
    80203e54:	7402                	ld	s0,32(sp)
    80203e56:	64e2                	ld	s1,24(sp)
    80203e58:	6942                	ld	s2,16(sp)
    80203e5a:	69a2                	ld	s3,8(sp)
    80203e5c:	6145                	addi	sp,sp,48
    80203e5e:	8082                	ret

0000000080203e60 <_Z27tf_compare_filename_segmentP19struct_FatFileEntryPc>:
FatFileEntry (a 32-byte structure pulled off disk, all of these are back-to-back
in a typical Directory entry on the disk)

figures out formatted name, does comparison, and returns 0:failure, 1:match
*/
int tf_compare_filename_segment(FatFileEntry *entry, char *name) {  //, char last) {
    80203e60:	1101                	addi	sp,sp,-32
    80203e62:	ec06                	sd	ra,24(sp)
    80203e64:	e822                	sd	s0,16(sp)
    80203e66:	1000                	addi	s0,sp,32
    80203e68:	882e                	mv	a6,a1
  int i, j;
  char reformatted_file[16];
  char *entryname = entry->msdos.filename;
  tf_printf("\r\n        [DEBUG-tf_compare_filename_segment] -- '%s'", name);
  if (entry->msdos.attributes != TF_ATTR_LONG_NAME) {
    80203e6a:	00b54703          	lbu	a4,11(a0)
    80203e6e:	47bd                	li	a5,15
    80203e70:	06f70463          	beq	a4,a5,80203ed8 <_Z27tf_compare_filename_segmentP19struct_FatFileEntryPc+0x78>
    80203e74:	00850893          	addi	a7,a0,8
    80203e78:	87aa                	mv	a5,a0
    tf_printf(" 8.3 Segment: ");
    // Filename
    j = 0;
    80203e7a:	4681                	li	a3,0
    for (i = 0; i < 8; i++) {
      if (entryname[i] != ' ') {
    80203e7c:	02000593          	li	a1,32
    80203e80:	a811                	j	80203e94 <_Z27tf_compare_filename_segmentP19struct_FatFileEntryPc+0x34>
        reformatted_file[j++] = entryname[i];
    80203e82:	ff040613          	addi	a2,s0,-16
    80203e86:	9636                	add	a2,a2,a3
    80203e88:	fee60823          	sb	a4,-16(a2)
    80203e8c:	2685                	addiw	a3,a3,1
    for (i = 0; i < 8; i++) {
    80203e8e:	0785                	addi	a5,a5,1
    80203e90:	00f88763          	beq	a7,a5,80203e9e <_Z27tf_compare_filename_segmentP19struct_FatFileEntryPc+0x3e>
      if (entryname[i] != ' ') {
    80203e94:	0007c703          	lbu	a4,0(a5) # 10000000 <_entry-0x70200000>
    80203e98:	feb715e3          	bne	a4,a1,80203e82 <_Z27tf_compare_filename_segmentP19struct_FatFileEntryPc+0x22>
    80203e9c:	bfcd                	j	80203e8e <_Z27tf_compare_filename_segmentP19struct_FatFileEntryPc+0x2e>
      }
    }
    reformatted_file[j++] = '.';
    80203e9e:	0016871b          	addiw	a4,a3,1
    80203ea2:	ff040793          	addi	a5,s0,-16
    80203ea6:	96be                	add	a3,a3,a5
    80203ea8:	02e00793          	li	a5,46
    80203eac:	fef68823          	sb	a5,-16(a3)
    // Extension
    for (i = 8; i < 11; i++) {
    80203eb0:	00850793          	addi	a5,a0,8
    80203eb4:	052d                	addi	a0,a0,11
      if (entryname[i] != ' ') {
    80203eb6:	02000613          	li	a2,32
    80203eba:	a021                	j	80203ec2 <_Z27tf_compare_filename_segmentP19struct_FatFileEntryPc+0x62>
    for (i = 8; i < 11; i++) {
    80203ebc:	0785                	addi	a5,a5,1
    80203ebe:	06f50963          	beq	a0,a5,80203f30 <_Z27tf_compare_filename_segmentP19struct_FatFileEntryPc+0xd0>
      if (entryname[i] != ' ') {
    80203ec2:	0007c683          	lbu	a3,0(a5)
    80203ec6:	fec68be3          	beq	a3,a2,80203ebc <_Z27tf_compare_filename_segmentP19struct_FatFileEntryPc+0x5c>
        reformatted_file[j++] = entryname[i];
    80203eca:	ff040593          	addi	a1,s0,-16
    80203ece:	95ba                	add	a1,a1,a4
    80203ed0:	fed58823          	sb	a3,-16(a1)
    80203ed4:	2705                	addiw	a4,a4,1
    80203ed6:	b7dd                	j	80203ebc <_Z27tf_compare_filename_segmentP19struct_FatFileEntryPc+0x5c>
    }
  } else {
    tf_printf(" LFN Segment: ");
    j = 0;
    for (i = 0; i < 5; i++) {
      reformatted_file[j++] = (char)entry->lfn.name1[i];
    80203ed8:	00154783          	lbu	a5,1(a0)
    80203edc:	fef40023          	sb	a5,-32(s0)
    80203ee0:	00354783          	lbu	a5,3(a0)
    80203ee4:	fef400a3          	sb	a5,-31(s0)
    80203ee8:	00554783          	lbu	a5,5(a0)
    80203eec:	fef40123          	sb	a5,-30(s0)
    80203ef0:	00754783          	lbu	a5,7(a0)
    80203ef4:	fef401a3          	sb	a5,-29(s0)
    80203ef8:	00954783          	lbu	a5,9(a0)
    80203efc:	fef40223          	sb	a5,-28(s0)
    for (i = 0; i < 5; i++) {
    80203f00:	fe040693          	addi	a3,s0,-32
    }
    for (i = 0; i < 6; i++) {
    80203f04:	4781                	li	a5,0
    80203f06:	4619                	li	a2,6
      reformatted_file[j++] = (char)entry->lfn.name2[i];
    80203f08:	00179713          	slli	a4,a5,0x1
    80203f0c:	972a                	add	a4,a4,a0
    80203f0e:	00e74703          	lbu	a4,14(a4)
    80203f12:	00e682a3          	sb	a4,5(a3)
    for (i = 0; i < 6; i++) {
    80203f16:	2785                	addiw	a5,a5,1
    80203f18:	0685                	addi	a3,a3,1
    80203f1a:	fec797e3          	bne	a5,a2,80203f08 <_Z27tf_compare_filename_segmentP19struct_FatFileEntryPc+0xa8>
    }
    for (i = 0; i < 2; i++) {
      reformatted_file[j++] = (char)entry->lfn.name3[i];
    80203f1e:	01c54783          	lbu	a5,28(a0)
    80203f22:	fef405a3          	sb	a5,-21(s0)
    80203f26:	01e54783          	lbu	a5,30(a0)
    80203f2a:	fef40623          	sb	a5,-20(s0)
    80203f2e:	4735                	li	a4,13
    }
  }
  reformatted_file[j++] = '\x00';
    80203f30:	ff040793          	addi	a5,s0,-16
    80203f34:	973e                	add	a4,a4,a5
    80203f36:	fe070823          	sb	zero,-16(a4)
  i = 0;
  while ((name[i] != '/') && (name[i] != '\x00'))
    80203f3a:	00084783          	lbu	a5,0(a6)
    80203f3e:	02f00713          	li	a4,47
    80203f42:	04e78b63          	beq	a5,a4,80203f98 <_Z27tf_compare_filename_segmentP19struct_FatFileEntryPc+0x138>
    80203f46:	4601                	li	a2,0
    80203f48:	02f00593          	li	a1,47
    80203f4c:	0006071b          	sext.w	a4,a2
    80203f50:	86ba                	mv	a3,a4
    80203f52:	cb91                	beqz	a5,80203f66 <_Z27tf_compare_filename_segmentP19struct_FatFileEntryPc+0x106>
    i++;  // will this work for 8.3?  this should be calculated in the section with knowledge of lfn/8.3
    80203f54:	0017069b          	addiw	a3,a4,1
  while ((name[i] != '/') && (name[i] != '\x00'))
    80203f58:	0605                	addi	a2,a2,1
    80203f5a:	00c807b3          	add	a5,a6,a2
    80203f5e:	0007c783          	lbu	a5,0(a5)
    80203f62:	feb795e3          	bne	a5,a1,80203f4c <_Z27tf_compare_filename_segmentP19struct_FatFileEntryPc+0xec>

  // the role of 'i' changes here to become the return value.  perhaps this doesn't gain us enough in performance to
  // avoid using a real retval?
  /// PROBLEM: THIS FUNCTION assumes that if the length of the "name" is tested by the caller.
  ///   if the LFN pieces all match, but the "name" is longer... this will never fail.
  if (i > 13) {
    80203f66:	47b5                	li	a5,13
    80203f68:	00d7cd63          	blt	a5,a3,80203f82 <_Z27tf_compare_filename_segmentP19struct_FatFileEntryPc+0x122>
    } else {
      tf_printf("  - 1 (match)\r\n");
      i = 1;
    }
  } else {
    if (reformatted_file[i] != 0 || strncasecmp(name, reformatted_file, i)) {
    80203f6c:	ff040793          	addi	a5,s0,-16
    80203f70:	96be                	add	a3,a3,a5
    80203f72:	ff06c783          	lbu	a5,-16(a3)
      i = 0;
    80203f76:	4501                	li	a0,0
    if (reformatted_file[i] != 0 || strncasecmp(name, reformatted_file, i)) {
    80203f78:	c39d                	beqz	a5,80203f9e <_Z27tf_compare_filename_segmentP19struct_FatFileEntryPc+0x13e>
      i = 1;
      tf_printf("  - 1 (match)\r\n");
    }
  }
  return i;
}
    80203f7a:	60e2                	ld	ra,24(sp)
    80203f7c:	6442                	ld	s0,16(sp)
    80203f7e:	6105                	addi	sp,sp,32
    80203f80:	8082                	ret
    if (strncasecmp(name, reformatted_file, 13)) {
    80203f82:	4635                	li	a2,13
    80203f84:	fe040593          	addi	a1,s0,-32
    80203f88:	8542                	mv	a0,a6
    80203f8a:	ffffd097          	auipc	ra,0xffffd
    80203f8e:	ce4080e7          	jalr	-796(ra) # 80200c6e <_Z11strncasecmpPKcS0_m>
      i = 1;
    80203f92:	00153513          	seqz	a0,a0
    80203f96:	b7d5                	j	80203f7a <_Z27tf_compare_filename_segmentP19struct_FatFileEntryPc+0x11a>
  i = 0;
    80203f98:	4681                	li	a3,0
  while ((name[i] != '/') && (name[i] != '\x00'))
    80203f9a:	4601                	li	a2,0
    80203f9c:	bfc1                	j	80203f6c <_Z27tf_compare_filename_segmentP19struct_FatFileEntryPc+0x10c>
    if (reformatted_file[i] != 0 || strncasecmp(name, reformatted_file, i)) {
    80203f9e:	fe040593          	addi	a1,s0,-32
    80203fa2:	8542                	mv	a0,a6
    80203fa4:	ffffd097          	auipc	ra,0xffffd
    80203fa8:	cca080e7          	jalr	-822(ra) # 80200c6e <_Z11strncasecmpPKcS0_m>
      i = 1;
    80203fac:	00153513          	seqz	a0,a0
    80203fb0:	b7e9                	j	80203f7a <_Z27tf_compare_filename_segmentP19struct_FatFileEntryPc+0x11a>

0000000080203fb2 <_Z20tf_find_free_clusterv>:
}

// Walk the FAT from the very first data sector and find a cluster that's available
// Return the cluster index
// TODO: Rewrite this function so that you can start finding a free cluster at somewhere other than the beginning
uint32_t tf_find_free_cluster() {
    80203fb2:	7179                	addi	sp,sp,-48
    80203fb4:	f406                	sd	ra,40(sp)
    80203fb6:	f022                	sd	s0,32(sp)
    80203fb8:	ec26                	sd	s1,24(sp)
    80203fba:	e84a                	sd	s2,16(sp)
    80203fbc:	e44e                	sd	s3,8(sp)
    80203fbe:	1800                	addi	s0,sp,48
  uint32_t i, entry, totalClusters;

  dbg_printf("\r\n[DEBUG-tf_find_free_cluster] Searching for a free cluster... ");
  totalClusters = tf_info.totalSectors / tf_info.sectorsPerCluster;
    80203fc0:	0008b717          	auipc	a4,0x8b
    80203fc4:	04070713          	addi	a4,a4,64 # 8028f000 <tf_info>
    80203fc8:	471c                	lw	a5,8(a4)
    80203fca:	00174903          	lbu	s2,1(a4)
    80203fce:	0009071b          	sext.w	a4,s2
    80203fd2:	0327d93b          	divuw	s2,a5,s2
  for (i = 0; i < totalClusters; i++) {
    80203fd6:	02e7ea63          	bltu	a5,a4,8020400a <_Z20tf_find_free_clusterv+0x58>
    80203fda:	4481                	li	s1,0
    entry = tf_get_fat_entry(i);
    if ((entry & 0x0fffffff) == 0) break;
    80203fdc:	100009b7          	lui	s3,0x10000
    80203fe0:	19fd                	addi	s3,s3,-1
    entry = tf_get_fat_entry(i);
    80203fe2:	8526                	mv	a0,s1
    80203fe4:	00000097          	auipc	ra,0x0
    80203fe8:	9aa080e7          	jalr	-1622(ra) # 8020398e <_Z16tf_get_fat_entryj>
    80203fec:	2501                	sext.w	a0,a0
    if ((entry & 0x0fffffff) == 0) break;
    80203fee:	01357533          	and	a0,a0,s3
    80203ff2:	c501                	beqz	a0,80203ffa <_Z20tf_find_free_clusterv+0x48>
  for (i = 0; i < totalClusters; i++) {
    80203ff4:	2485                	addiw	s1,s1,1
    80203ff6:	ff24e6e3          	bltu	s1,s2,80203fe2 <_Z20tf_find_free_clusterv+0x30>
    tf_printf("cluster %x: %x", i, entry);
  }
  dbg_printf("\r\n[DEBUGtf_find_free_cluster] Returning Free cluster number: %d for allocation", i);
  return i;
}
    80203ffa:	8526                	mv	a0,s1
    80203ffc:	70a2                	ld	ra,40(sp)
    80203ffe:	7402                	ld	s0,32(sp)
    80204000:	64e2                	ld	s1,24(sp)
    80204002:	6942                	ld	s2,16(sp)
    80204004:	69a2                	ld	s3,8(sp)
    80204006:	6145                	addi	sp,sp,48
    80204008:	8082                	ret
  for (i = 0; i < totalClusters; i++) {
    8020400a:	4481                	li	s1,0
    8020400c:	b7fd                	j	80203ffa <_Z20tf_find_free_clusterv+0x48>

000000008020400e <_Z25tf_find_free_cluster_fromj>:

/* Optimize search for a free cluster */
uint32_t tf_find_free_cluster_from(uint32_t c) {
    8020400e:	7179                	addi	sp,sp,-48
    80204010:	f406                	sd	ra,40(sp)
    80204012:	f022                	sd	s0,32(sp)
    80204014:	ec26                	sd	s1,24(sp)
    80204016:	e84a                	sd	s2,16(sp)
    80204018:	e44e                	sd	s3,8(sp)
    8020401a:	1800                	addi	s0,sp,48
    8020401c:	84aa                	mv	s1,a0
  uint32_t i, entry, totalClusters;
  dbg_printf("\r\n[DEBUG-tf_find_free_cluster_from] Searching for a free cluster from %x... ", c);
  totalClusters = tf_info.totalSectors / tf_info.sectorsPerCluster;
    8020401e:	0008b797          	auipc	a5,0x8b
    80204022:	fe278793          	addi	a5,a5,-30 # 8028f000 <tf_info>
    80204026:	0017c703          	lbu	a4,1(a5)
    8020402a:	0087a903          	lw	s2,8(a5)
    8020402e:	02e9593b          	divuw	s2,s2,a4
  for (i = c; i < totalClusters; i++) {
    80204032:	03257963          	bgeu	a0,s2,80204064 <_Z25tf_find_free_cluster_fromj+0x56>
    entry = tf_get_fat_entry(i);
    if ((entry & 0x0fffffff) == 0) break;
    80204036:	100009b7          	lui	s3,0x10000
    8020403a:	19fd                	addi	s3,s3,-1
    entry = tf_get_fat_entry(i);
    8020403c:	8526                	mv	a0,s1
    8020403e:	00000097          	auipc	ra,0x0
    80204042:	950080e7          	jalr	-1712(ra) # 8020398e <_Z16tf_get_fat_entryj>
    80204046:	0005079b          	sext.w	a5,a0
    if ((entry & 0x0fffffff) == 0) break;
    8020404a:	0137f7b3          	and	a5,a5,s3
    8020404e:	cb91                	beqz	a5,80204062 <_Z25tf_find_free_cluster_fromj+0x54>
  for (i = c; i < totalClusters; i++) {
    80204050:	2485                	addiw	s1,s1,1
    80204052:	fe9915e3          	bne	s2,s1,8020403c <_Z25tf_find_free_cluster_fromj+0x2e>
    tf_printf("cluster %x: %x", i, entry);
  }
  /* We couldn't find anything here so search from the beginning */
  if (i == totalClusters) {
    dbg_printf("\r\n[DEBUG-tf_find_free_cluster_from] Couldn't find one from there... starting from beginning");
    return tf_find_free_cluster();
    80204056:	00000097          	auipc	ra,0x0
    8020405a:	f5c080e7          	jalr	-164(ra) # 80203fb2 <_Z20tf_find_free_clusterv>
    8020405e:	2501                	sext.w	a0,a0
    80204060:	a021                	j	80204068 <_Z25tf_find_free_cluster_fromj+0x5a>
    80204062:	8526                	mv	a0,s1
  if (i == totalClusters) {
    80204064:	fea909e3          	beq	s2,a0,80204056 <_Z25tf_find_free_cluster_fromj+0x48>
  }

  dbg_printf("\r\n[DEBUG-tf_find_free_cluster_from] Free cluster number: %d ", i);
  return i;
}
    80204068:	70a2                	ld	ra,40(sp)
    8020406a:	7402                	ld	s0,32(sp)
    8020406c:	64e2                	ld	s1,24(sp)
    8020406e:	6942                	ld	s2,16(sp)
    80204070:	69a2                	ld	s3,8(sp)
    80204072:	6145                	addi	sp,sp,48
    80204074:	8082                	ret

0000000080204076 <_Z15tf_unsafe_fseekP13struct_TFFILEil>:
int tf_unsafe_fseek(TFFile *fp, int32_t base, long offset) {
    80204076:	7139                	addi	sp,sp,-64
    80204078:	fc06                	sd	ra,56(sp)
    8020407a:	f822                	sd	s0,48(sp)
    8020407c:	f426                	sd	s1,40(sp)
    8020407e:	f04a                	sd	s2,32(sp)
    80204080:	ec4e                	sd	s3,24(sp)
    80204082:	e852                	sd	s4,16(sp)
    80204084:	e456                	sd	s5,8(sp)
    80204086:	e05a                	sd	s6,0(sp)
    80204088:	0080                	addi	s0,sp,64
    8020408a:	84aa                	mv	s1,a0
  long pos = base + offset;
    8020408c:	00c58a33          	add	s4,a1,a2
  uint32_t mark = tf_info.type ? TF_MARK_EOC32 : TF_MARK_EOC16;
    80204090:	0008b797          	auipc	a5,0x8b
    80204094:	f707c783          	lbu	a5,-144(a5) # 8028f000 <tf_info>
    80204098:	e3b1                	bnez	a5,802040dc <_Z15tf_unsafe_fseekP13struct_TFFILEil+0x66>
    8020409a:	69c1                	lui	s3,0x10
    8020409c:	19e1                	addi	s3,s3,-8
  if (pos > fp->size) {
    8020409e:	4cdc                	lw	a5,28(s1)
    802040a0:	02079713          	slli	a4,a5,0x20
    802040a4:	9301                	srli	a4,a4,0x20
    return TF_ERR_INVALID_SEEK;
    802040a6:	4505                	li	a0,1
  if (pos > fp->size) {
    802040a8:	09474e63          	blt	a4,s4,80204144 <_Z15tf_unsafe_fseekP13struct_TFFILEil+0xce>
  if (pos == fp->size) {
    802040ac:	03470c63          	beq	a4,s4,802040e4 <_Z15tf_unsafe_fseekP13struct_TFFILEil+0x6e>
  cluster_idx = pos / (tf_info.sectorsPerCluster * 512);  // The cluster we want in the file
    802040b0:	0008b917          	auipc	s2,0x8b
    802040b4:	f5194903          	lbu	s2,-175(s2) # 8028f001 <tf_info+0x1>
    802040b8:	0099191b          	slliw	s2,s2,0x9
    802040bc:	032a4933          	div	s2,s4,s2
    802040c0:	2901                	sext.w	s2,s2
  if (cluster_idx != fp->currentClusterIdx) {
    802040c2:	449c                	lw	a5,8(s1)
    802040c4:	07278363          	beq	a5,s2,8020412a <_Z15tf_unsafe_fseekP13struct_TFFILEil+0xb4>
    if (cluster_idx > fp->currentClusterIdx) {
    802040c8:	0327f763          	bgeu	a5,s2,802040f6 <_Z15tf_unsafe_fseekP13struct_TFFILEil+0x80>
    fp->currentClusterIdx = temp;
    802040cc:	0124a423          	sw	s2,8(s1)
      cluster_idx -= fp->currentClusterIdx;
    802040d0:	40f9093b          	subw	s2,s2,a5
      if ((temp & 0x0fffffff) != mark)
    802040d4:	10000ab7          	lui	s5,0x10000
    802040d8:	1afd                	addi	s5,s5,-1
    802040da:	a03d                	j	80204108 <_Z15tf_unsafe_fseekP13struct_TFFILEil+0x92>
  uint32_t mark = tf_info.type ? TF_MARK_EOC32 : TF_MARK_EOC16;
    802040dc:	100009b7          	lui	s3,0x10000
    802040e0:	19fd                	addi	s3,s3,-1
    802040e2:	bf75                	j	8020409e <_Z15tf_unsafe_fseekP13struct_TFFILEil+0x28>
    fp->size += 1;
    802040e4:	2785                	addiw	a5,a5,1
    802040e6:	ccdc                	sw	a5,28(s1)
    fp->flags |= TF_FLAG_SIZECHANGED;
    802040e8:	0184c783          	lbu	a5,24(s1)
    802040ec:	0047e793          	ori	a5,a5,4
    802040f0:	00f48c23          	sb	a5,24(s1)
    802040f4:	bf75                	j	802040b0 <_Z15tf_unsafe_fseekP13struct_TFFILEil+0x3a>
      fp->currentCluster = fp->startCluster;
    802040f6:	40dc                	lw	a5,4(s1)
    802040f8:	c4dc                	sw	a5,12(s1)
    fp->currentClusterIdx = temp;
    802040fa:	0124a423          	sw	s2,8(s1)
    while (cluster_idx > 0) {
    802040fe:	fc091be3          	bnez	s2,802040d4 <_Z15tf_unsafe_fseekP13struct_TFFILEil+0x5e>
    80204102:	a025                	j	8020412a <_Z15tf_unsafe_fseekP13struct_TFFILEil+0xb4>
    80204104:	02090363          	beqz	s2,8020412a <_Z15tf_unsafe_fseekP13struct_TFFILEil+0xb4>
      temp = tf_get_fat_entry(fp->currentCluster);  // next, next, next
    80204108:	44c8                	lw	a0,12(s1)
    8020410a:	00000097          	auipc	ra,0x0
    8020410e:	884080e7          	jalr	-1916(ra) # 8020398e <_Z16tf_get_fat_entryj>
    80204112:	2501                	sext.w	a0,a0
      if ((temp & 0x0fffffff) != mark)
    80204114:	015577b3          	and	a5,a0,s5
    80204118:	05378063          	beq	a5,s3,80204158 <_Z15tf_unsafe_fseekP13struct_TFFILEil+0xe2>
        fp->currentCluster = temp;
    8020411c:	c4c8                	sw	a0,12(s1)
      cluster_idx--;
    8020411e:	397d                	addiw	s2,s2,-1
      if (fp->currentCluster >= mark) {
    80204120:	44dc                	lw	a5,12(s1)
    80204122:	ff37e1e3          	bltu	a5,s3,80204104 <_Z15tf_unsafe_fseekP13struct_TFFILEil+0x8e>
        if (cluster_idx > 0) {
    80204126:	04091f63          	bnez	s2,80204184 <_Z15tf_unsafe_fseekP13struct_TFFILEil+0x10e>
  fp->currentByte = pos % (tf_info.sectorsPerCluster * 512);  // The offset into the cluster
    8020412a:	0008b797          	auipc	a5,0x8b
    8020412e:	ed77c783          	lbu	a5,-297(a5) # 8028f001 <tf_info+0x1>
    80204132:	0097979b          	slliw	a5,a5,0x9
    80204136:	02fa67b3          	rem	a5,s4,a5
    8020413a:	00f49923          	sh	a5,18(s1)
  fp->pos = pos;
    8020413e:	0144aa23          	sw	s4,20(s1)
  return 0;
    80204142:	4501                	li	a0,0
}
    80204144:	70e2                	ld	ra,56(sp)
    80204146:	7442                	ld	s0,48(sp)
    80204148:	74a2                	ld	s1,40(sp)
    8020414a:	7902                	ld	s2,32(sp)
    8020414c:	69e2                	ld	s3,24(sp)
    8020414e:	6a42                	ld	s4,16(sp)
    80204150:	6aa2                	ld	s5,8(sp)
    80204152:	6b02                	ld	s6,0(sp)
    80204154:	6121                	addi	sp,sp,64
    80204156:	8082                	ret
        temp = tf_find_free_cluster_from(fp->currentCluster);
    80204158:	44c8                	lw	a0,12(s1)
    8020415a:	00000097          	auipc	ra,0x0
    8020415e:	eb4080e7          	jalr	-332(ra) # 8020400e <_Z25tf_find_free_cluster_fromj>
    80204162:	00050b1b          	sext.w	s6,a0
        tf_set_fat_entry(fp->currentCluster, temp);  // Allocates new space
    80204166:	85da                	mv	a1,s6
    80204168:	44c8                	lw	a0,12(s1)
    8020416a:	00000097          	auipc	ra,0x0
    8020416e:	862080e7          	jalr	-1950(ra) # 802039cc <_Z16tf_set_fat_entryjj>
        tf_set_fat_entry(temp, mark);                // Marks the new cluster as the last one
    80204172:	85ce                	mv	a1,s3
    80204174:	855a                	mv	a0,s6
    80204176:	00000097          	auipc	ra,0x0
    8020417a:	856080e7          	jalr	-1962(ra) # 802039cc <_Z16tf_set_fat_entryjj>
        fp->currentCluster = temp;
    8020417e:	0164a623          	sw	s6,12(s1)
    80204182:	bf71                	j	8020411e <_Z15tf_unsafe_fseekP13struct_TFFILEil+0xa8>
          return TF_ERR_INVALID_SEEK;
    80204184:	4505                	li	a0,1
    80204186:	bf7d                	j	80204144 <_Z15tf_unsafe_fseekP13struct_TFFILEil+0xce>

0000000080204188 <_Z8tf_fseekP13struct_TFFILEml>:
  if (pos >= fp->size) {
    80204188:	01c56703          	lwu	a4,28(a0)
  long pos = base + offset;
    8020418c:	00b607b3          	add	a5,a2,a1
  if (pos >= fp->size) {
    80204190:	00e7c463          	blt	a5,a4,80204198 <_Z8tf_fseekP13struct_TFFILEml+0x10>
    return TF_ERR_INVALID_SEEK;
    80204194:	4505                	li	a0,1
}
    80204196:	8082                	ret
int tf_fseek(TFFile *fp, size_t base, long offset) {
    80204198:	1141                	addi	sp,sp,-16
    8020419a:	e406                	sd	ra,8(sp)
    8020419c:	e022                	sd	s0,0(sp)
    8020419e:	0800                	addi	s0,sp,16
  return tf_unsafe_fseek(fp, base, offset);
    802041a0:	2581                	sext.w	a1,a1
    802041a2:	00000097          	auipc	ra,0x0
    802041a6:	ed4080e7          	jalr	-300(ra) # 80204076 <_Z15tf_unsafe_fseekP13struct_TFFILEil>
}
    802041aa:	60a2                	ld	ra,8(sp)
    802041ac:	6402                	ld	s0,0(sp)
    802041ae:	0141                	addi	sp,sp,16
    802041b0:	8082                	ret

00000000802041b2 <_Z8tf_freadPciP13struct_TFFILEb>:
int tf_fread(char *dest, int size, TFFile *fp, bool user) {
    802041b2:	711d                	addi	sp,sp,-96
    802041b4:	ec86                	sd	ra,88(sp)
    802041b6:	e8a2                	sd	s0,80(sp)
    802041b8:	e4a6                	sd	s1,72(sp)
    802041ba:	e0ca                	sd	s2,64(sp)
    802041bc:	fc4e                	sd	s3,56(sp)
    802041be:	f852                	sd	s4,48(sp)
    802041c0:	f456                	sd	s5,40(sp)
    802041c2:	f05a                	sd	s6,32(sp)
    802041c4:	ec5e                	sd	s7,24(sp)
    802041c6:	e862                	sd	s8,16(sp)
    802041c8:	e466                	sd	s9,8(sp)
    802041ca:	1080                	addi	s0,sp,96
  while (size > 0) {
    802041cc:	0eb05663          	blez	a1,802042b8 <_Z8tf_freadPciP13struct_TFFILEb+0x106>
    802041d0:	89aa                	mv	s3,a0
    802041d2:	892e                	mv	s2,a1
    802041d4:	84b2                	mv	s1,a2
    802041d6:	8ab6                	mv	s5,a3
  int n = 0;  // count that have been read
    802041d8:	4a01                	li	s4,0
    size_t x = BSIZE - (fp->currentByte % 512);
    802041da:	20000b93          	li	s7,512
    either_copyout(user, reinterpret_cast<uint64_t>(dest), &tf_info.buffer[fp->currentByte % 512], x);
    802041de:	0008bb17          	auipc	s6,0x8b
    802041e2:	e22b0b13          	addi	s6,s6,-478 # 8028f000 <tf_info>
    802041e6:	a829                	j	80204200 <_Z8tf_freadPciP13struct_TFFILEb+0x4e>
      if (tf_fseek(fp, 0, fp->pos + x)) {
    802041e8:	0144e603          	lwu	a2,20(s1)
    802041ec:	9666                	add	a2,a2,s9
    802041ee:	4581                	li	a1,0
    802041f0:	8526                	mv	a0,s1
    802041f2:	00000097          	auipc	ra,0x0
    802041f6:	f96080e7          	jalr	-106(ra) # 80204188 <_Z8tf_fseekP13struct_TFFILEml>
    802041fa:	e14d                	bnez	a0,8020429c <_Z8tf_freadPciP13struct_TFFILEb+0xea>
  while (size > 0) {
    802041fc:	0b205063          	blez	s2,8020429c <_Z8tf_freadPciP13struct_TFFILEb+0xea>
    sector = tf_first_sector(fp->currentCluster) + (fp->currentByte / 512);
    80204200:	44c8                	lw	a0,12(s1)
    80204202:	00000097          	auipc	ra,0x0
    80204206:	824080e7          	jalr	-2012(ra) # 80203a26 <_Z15tf_first_sectorj>
    8020420a:	01249703          	lh	a4,18(s1)
    8020420e:	41f7579b          	sraiw	a5,a4,0x1f
    80204212:	0177d79b          	srliw	a5,a5,0x17
    80204216:	9fb9                	addw	a5,a5,a4
    80204218:	4097d79b          	sraiw	a5,a5,0x9
    tf_fetch(sector);  // wtfo?  i know this is cached, but why!?
    8020421c:	9d3d                	addw	a0,a0,a5
    8020421e:	fffff097          	auipc	ra,0xfffff
    80204222:	70a080e7          	jalr	1802(ra) # 80203928 <_Z8tf_fetchj>
    size_t x = BSIZE - (fp->currentByte % 512);
    80204226:	01249703          	lh	a4,18(s1)
    8020422a:	41f7579b          	sraiw	a5,a4,0x1f
    8020422e:	0177d69b          	srliw	a3,a5,0x17
    80204232:	00d707bb          	addw	a5,a4,a3
    80204236:	1ff7f793          	andi	a5,a5,511
    8020423a:	9f95                	subw	a5,a5,a3
    8020423c:	0107961b          	slliw	a2,a5,0x10
    80204240:	4106561b          	sraiw	a2,a2,0x10
    80204244:	40fb87bb          	subw	a5,s7,a5
    if (x > fp->size - fp->pos) {
    80204248:	4cd8                	lw	a4,28(s1)
    8020424a:	48d4                	lw	a3,20(s1)
    8020424c:	9f15                	subw	a4,a4,a3
    8020424e:	1702                	slli	a4,a4,0x20
    80204250:	9301                	srli	a4,a4,0x20
    80204252:	00e7f363          	bgeu	a5,a4,80204258 <_Z8tf_freadPciP13struct_TFFILEb+0xa6>
    80204256:	873e                	mv	a4,a5
    if (x > (size_t)size) {
    80204258:	8cca                	mv	s9,s2
    8020425a:	01277363          	bgeu	a4,s2,80204260 <_Z8tf_freadPciP13struct_TFFILEb+0xae>
    8020425e:	8cba                	mv	s9,a4
    either_copyout(user, reinterpret_cast<uint64_t>(dest), &tf_info.buffer[fp->currentByte % 512], x);
    80204260:	000c8c1b          	sext.w	s8,s9
    80204264:	0671                	addi	a2,a2,28
    80204266:	86e2                	mv	a3,s8
    80204268:	965a                	add	a2,a2,s6
    8020426a:	85ce                	mv	a1,s3
    8020426c:	8556                	mv	a0,s5
    8020426e:	ffffe097          	auipc	ra,0xffffe
    80204272:	140080e7          	jalr	320(ra) # 802023ae <_Z14either_copyoutbmPvi>
    dest += x;
    80204276:	99e6                	add	s3,s3,s9
    size -= x;
    80204278:	4189093b          	subw	s2,s2,s8
    n += x;
    8020427c:	018a0a3b          	addw	s4,s4,s8
    if (fp->attributes & TF_ATTR_DIRECTORY) {
    80204280:	0194c783          	lbu	a5,25(s1)
    80204284:	8bc1                	andi	a5,a5,16
    80204286:	d3ad                	beqz	a5,802041e8 <_Z8tf_freadPciP13struct_TFFILEb+0x36>
      if (tf_fseek(fp, 0, fp->pos + x)) {
    80204288:	0144e603          	lwu	a2,20(s1)
    8020428c:	9666                	add	a2,a2,s9
    8020428e:	4581                	li	a1,0
    80204290:	8526                	mv	a0,s1
    80204292:	00000097          	auipc	ra,0x0
    80204296:	ef6080e7          	jalr	-266(ra) # 80204188 <_Z8tf_fseekP13struct_TFFILEml>
    8020429a:	d12d                	beqz	a0,802041fc <_Z8tf_freadPciP13struct_TFFILEb+0x4a>
}
    8020429c:	8552                	mv	a0,s4
    8020429e:	60e6                	ld	ra,88(sp)
    802042a0:	6446                	ld	s0,80(sp)
    802042a2:	64a6                	ld	s1,72(sp)
    802042a4:	6906                	ld	s2,64(sp)
    802042a6:	79e2                	ld	s3,56(sp)
    802042a8:	7a42                	ld	s4,48(sp)
    802042aa:	7aa2                	ld	s5,40(sp)
    802042ac:	7b02                	ld	s6,32(sp)
    802042ae:	6be2                	ld	s7,24(sp)
    802042b0:	6c42                	ld	s8,16(sp)
    802042b2:	6ca2                	ld	s9,8(sp)
    802042b4:	6125                	addi	sp,sp,96
    802042b6:	8082                	ret
  int n = 0;  // count that have been read
    802042b8:	4a01                	li	s4,0
    802042ba:	b7cd                	j	8020429c <_Z8tf_freadPciP13struct_TFFILEb+0xea>

00000000802042bc <_Z19tf_compare_filenameP13struct_TFFILEPc>:
int tf_compare_filename(TFFile *fp, char *name) {
    802042bc:	711d                	addi	sp,sp,-96
    802042be:	ec86                	sd	ra,88(sp)
    802042c0:	e8a2                	sd	s0,80(sp)
    802042c2:	e4a6                	sd	s1,72(sp)
    802042c4:	e0ca                	sd	s2,64(sp)
    802042c6:	fc4e                	sd	s3,56(sp)
    802042c8:	f852                	sd	s4,48(sp)
    802042ca:	f456                	sd	s5,40(sp)
    802042cc:	1080                	addi	s0,sp,96
    802042ce:	84aa                	mv	s1,a0
    802042d0:	89ae                	mv	s3,a1
  tf_fread((char *)&entry, sizeof(FatFileEntry), fp);
    802042d2:	4681                	li	a3,0
    802042d4:	862a                	mv	a2,a0
    802042d6:	02000593          	li	a1,32
    802042da:	fa040513          	addi	a0,s0,-96
    802042de:	00000097          	auipc	ra,0x0
    802042e2:	ed4080e7          	jalr	-300(ra) # 802041b2 <_Z8tf_freadPciP13struct_TFFILEb>
  if (entry.msdos.filename[0] == 0x00) return -1;
    802042e6:	fa044783          	lbu	a5,-96(s0)
    802042ea:	597d                	li	s2,-1
    802042ec:	cf89                	beqz	a5,80204306 <_Z19tf_compare_filenameP13struct_TFFILEPc+0x4a>
  if (entry.msdos.attributes != TF_ATTR_LONG_NAME) {
    802042ee:	fab44683          	lbu	a3,-85(s0)
    802042f2:	473d                	li	a4,15
    802042f4:	02e69363          	bne	a3,a4,8020431a <_Z19tf_compare_filenameP13struct_TFFILEPc+0x5e>
  } else if ((entry.lfn.sequence_number & 0xc0) == 0x40) {
    802042f8:	0c07f713          	andi	a4,a5,192
    802042fc:	04000693          	li	a3,64
  return -1;
    80204300:	597d                	li	s2,-1
  } else if ((entry.lfn.sequence_number & 0xc0) == 0x40) {
    80204302:	04d70263          	beq	a4,a3,80204346 <_Z19tf_compare_filenameP13struct_TFFILEPc+0x8a>
}
    80204306:	854a                	mv	a0,s2
    80204308:	60e6                	ld	ra,88(sp)
    8020430a:	6446                	ld	s0,80(sp)
    8020430c:	64a6                	ld	s1,72(sp)
    8020430e:	6906                	ld	s2,64(sp)
    80204310:	79e2                	ld	s3,56(sp)
    80204312:	7a42                	ld	s4,48(sp)
    80204314:	7aa2                	ld	s5,40(sp)
    80204316:	6125                	addi	sp,sp,96
    80204318:	8082                	ret
    if (1 == tf_compare_filename_segment(&entry, name)) {  //, true)) {
    8020431a:	85ce                	mv	a1,s3
    8020431c:	fa040513          	addi	a0,s0,-96
    80204320:	00000097          	auipc	ra,0x0
    80204324:	b40080e7          	jalr	-1216(ra) # 80203e60 <_Z27tf_compare_filename_segmentP19struct_FatFileEntryPc>
    80204328:	892a                	mv	s2,a0
    8020432a:	4785                	li	a5,1
    8020432c:	00f50463          	beq	a0,a5,80204334 <_Z19tf_compare_filenameP13struct_TFFILEPc+0x78>
      return 0;
    80204330:	4901                	li	s2,0
    80204332:	bfd1                	j	80204306 <_Z19tf_compare_filenameP13struct_TFFILEPc+0x4a>
      tf_fseek(fp, -sizeof(FatFileEntry), fp->pos);
    80204334:	0144e603          	lwu	a2,20(s1)
    80204338:	5581                	li	a1,-32
    8020433a:	8526                	mv	a0,s1
    8020433c:	00000097          	auipc	ra,0x0
    80204340:	e4c080e7          	jalr	-436(ra) # 80204188 <_Z8tf_fseekP13struct_TFFILEml>
      return 1;
    80204344:	b7c9                	j	80204306 <_Z19tf_compare_filenameP13struct_TFFILEPc+0x4a>
    lfn_entries = entry.lfn.sequence_number & ~0x40;
    80204346:	0bf7fa13          	andi	s4,a5,191
    tf_fseek(fp, (int32_t)sizeof(FatFileEntry) * (lfn_entries - 1), fp->pos);
    8020434a:	fffa059b          	addiw	a1,s4,-1
    8020434e:	0055959b          	slliw	a1,a1,0x5
    80204352:	0144e603          	lwu	a2,20(s1)
    80204356:	1582                	slli	a1,a1,0x20
    80204358:	9181                	srli	a1,a1,0x20
    8020435a:	8526                	mv	a0,s1
    8020435c:	00000097          	auipc	ra,0x0
    80204360:	e2c080e7          	jalr	-468(ra) # 80204188 <_Z8tf_fseekP13struct_TFFILEml>
    namelen = strlen(name);
    80204364:	854e                	mv	a0,s3
    80204366:	ffffd097          	auipc	ra,0xffffd
    8020436a:	9e6080e7          	jalr	-1562(ra) # 80200d4c <_Z6strlenPKc>
    if (((namelen + 12) / LFN_ENTRY_CAPACITY) != lfn_entries) {
    8020436e:	2531                	addiw	a0,a0,12
    80204370:	47b5                	li	a5,13
    80204372:	02f5553b          	divuw	a0,a0,a5
      return 0;
    80204376:	4901                	li	s2,0
    if (((namelen + 12) / LFN_ENTRY_CAPACITY) != lfn_entries) {
    80204378:	f94517e3          	bne	a0,s4,80204306 <_Z19tf_compare_filenameP13struct_TFFILEPc+0x4a>
    for (i = 0; i < lfn_entries; i++) {
    8020437c:	040a0a63          	beqz	s4,802043d0 <_Z19tf_compare_filenameP13struct_TFFILEPc+0x114>
    80204380:	4a81                	li	s5,0
      tf_fseek(fp, -sizeof(FatFileEntry), fp->pos);
    80204382:	0144e603          	lwu	a2,20(s1)
    80204386:	5581                	li	a1,-32
    80204388:	8526                	mv	a0,s1
    8020438a:	00000097          	auipc	ra,0x0
    8020438e:	dfe080e7          	jalr	-514(ra) # 80204188 <_Z8tf_fseekP13struct_TFFILEml>
      tf_fread((char *)&entry, sizeof(FatFileEntry), fp);
    80204392:	4681                	li	a3,0
    80204394:	8626                	mv	a2,s1
    80204396:	02000593          	li	a1,32
    8020439a:	fa040513          	addi	a0,s0,-96
    8020439e:	00000097          	auipc	ra,0x0
    802043a2:	e14080e7          	jalr	-492(ra) # 802041b2 <_Z8tf_freadPciP13struct_TFFILEb>
      if (!tf_compare_filename_segment(&entry, compare_name)) {  //, (i==lfn_entries-1))) {
    802043a6:	85ce                	mv	a1,s3
    802043a8:	fa040513          	addi	a0,s0,-96
    802043ac:	00000097          	auipc	ra,0x0
    802043b0:	ab4080e7          	jalr	-1356(ra) # 80203e60 <_Z27tf_compare_filename_segmentP19struct_FatFileEntryPc>
    802043b4:	892a                	mv	s2,a0
    802043b6:	c905                	beqz	a0,802043e6 <_Z19tf_compare_filenameP13struct_TFFILEPc+0x12a>
      tf_fseek(fp, -sizeof(FatFileEntry), fp->pos);
    802043b8:	0144e603          	lwu	a2,20(s1)
    802043bc:	5581                	li	a1,-32
    802043be:	8526                	mv	a0,s1
    802043c0:	00000097          	auipc	ra,0x0
    802043c4:	dc8080e7          	jalr	-568(ra) # 80204188 <_Z8tf_fseekP13struct_TFFILEml>
      compare_name += 13;
    802043c8:	09b5                	addi	s3,s3,13
    for (i = 0; i < lfn_entries; i++) {
    802043ca:	2a85                	addiw	s5,s5,1
    802043cc:	fb5a1be3          	bne	s4,s5,80204382 <_Z19tf_compare_filenameP13struct_TFFILEPc+0xc6>
    tf_fseek(fp, (int32_t)sizeof(FatFileEntry) * lfn_entries, fp->pos);
    802043d0:	0144e603          	lwu	a2,20(s1)
    802043d4:	005a1593          	slli	a1,s4,0x5
    802043d8:	8526                	mv	a0,s1
    802043da:	00000097          	auipc	ra,0x0
    802043de:	dae080e7          	jalr	-594(ra) # 80204188 <_Z8tf_fseekP13struct_TFFILEml>
    return 1;
    802043e2:	4905                	li	s2,1
    802043e4:	b70d                	j	80204306 <_Z19tf_compare_filenameP13struct_TFFILEPc+0x4a>
        tf_fseek(fp, (int32_t)((i)) * sizeof(FatFileEntry), fp->pos);
    802043e6:	0144e603          	lwu	a2,20(s1)
    802043ea:	005a9593          	slli	a1,s5,0x5
    802043ee:	8526                	mv	a0,s1
    802043f0:	00000097          	auipc	ra,0x0
    802043f4:	d98080e7          	jalr	-616(ra) # 80204188 <_Z8tf_fseekP13struct_TFFILEml>
        return 0;
    802043f8:	b739                	j	80204306 <_Z19tf_compare_filenameP13struct_TFFILEPc+0x4a>

00000000802043fa <_Z12tf_find_fileP13struct_TFFILEPc>:
int tf_find_file(TFFile *current_directory, char *name) {
    802043fa:	7179                	addi	sp,sp,-48
    802043fc:	f406                	sd	ra,40(sp)
    802043fe:	f022                	sd	s0,32(sp)
    80204400:	ec26                	sd	s1,24(sp)
    80204402:	e84a                	sd	s2,16(sp)
    80204404:	e44e                	sd	s3,8(sp)
    80204406:	1800                	addi	s0,sp,48
    80204408:	892a                	mv	s2,a0
    8020440a:	84ae                	mv	s1,a1
  tf_fseek(current_directory, 0, 0);
    8020440c:	4601                	li	a2,0
    8020440e:	4581                	li	a1,0
    80204410:	00000097          	auipc	ra,0x0
    80204414:	d78080e7          	jalr	-648(ra) # 80204188 <_Z8tf_fseekP13struct_TFFILEml>
    else if (rc == 1)  // found!
    80204418:	4985                	li	s3,1
    rc = tf_compare_filename(current_directory, name);
    8020441a:	85a6                	mv	a1,s1
    8020441c:	854a                	mv	a0,s2
    8020441e:	00000097          	auipc	ra,0x0
    80204422:	e9e080e7          	jalr	-354(ra) # 802042bc <_Z19tf_compare_filenameP13struct_TFFILEPc>
    if (rc < 0)
    80204426:	00054663          	bltz	a0,80204432 <_Z12tf_find_fileP13struct_TFFILEPc+0x38>
    else if (rc == 1)  // found!
    8020442a:	ff3518e3          	bne	a0,s3,8020441a <_Z12tf_find_fileP13struct_TFFILEPc+0x20>
      return 0;
    8020442e:	4501                	li	a0,0
    80204430:	a011                	j	80204434 <_Z12tf_find_fileP13struct_TFFILEPc+0x3a>
  return -1;
    80204432:	557d                	li	a0,-1
}
    80204434:	70a2                	ld	ra,40(sp)
    80204436:	7402                	ld	s0,32(sp)
    80204438:	64e2                	ld	s1,24(sp)
    8020443a:	6942                	ld	s2,16(sp)
    8020443c:	69a2                	ld	s3,8(sp)
    8020443e:	6145                	addi	sp,sp,48
    80204440:	8082                	ret

0000000080204442 <_Z7tf_walkPcP13struct_TFFILE>:
char *tf_walk(char *filename, TFFile *fp) {
    80204442:	7139                	addi	sp,sp,-64
    80204444:	fc06                	sd	ra,56(sp)
    80204446:	f822                	sd	s0,48(sp)
    80204448:	f426                	sd	s1,40(sp)
    8020444a:	f04a                	sd	s2,32(sp)
    8020444c:	0080                	addi	s0,sp,64
    8020444e:	84aa                	mv	s1,a0
    80204450:	892e                	mv	s2,a1
  if (*filename == '/') {
    80204452:	00054703          	lbu	a4,0(a0)
    80204456:	02f00793          	li	a5,47
    8020445a:	0af70563          	beq	a4,a5,80204504 <_Z7tf_walkPcP13struct_TFFILE+0xc2>
  if (*filename != '\x00') {
    8020445e:	0004c783          	lbu	a5,0(s1)
  return NULL;
    80204462:	4501                	li	a0,0
  if (*filename != '\x00') {
    80204464:	cbd1                	beqz	a5,802044f8 <_Z7tf_walkPcP13struct_TFFILE+0xb6>
    if (tf_find_file(fp, filename)) {
    80204466:	85a6                	mv	a1,s1
    80204468:	854a                	mv	a0,s2
    8020446a:	00000097          	auipc	ra,0x0
    8020446e:	f90080e7          	jalr	-112(ra) # 802043fa <_Z12tf_find_fileP13struct_TFFILEPc>
    80204472:	e145                	bnez	a0,80204512 <_Z7tf_walkPcP13struct_TFFILE+0xd0>
    tf_fread((char *)&entry, sizeof(FatFileEntry), fp);
    80204474:	4681                	li	a3,0
    80204476:	864a                	mv	a2,s2
    80204478:	02000593          	li	a1,32
    8020447c:	fc040513          	addi	a0,s0,-64
    80204480:	00000097          	auipc	ra,0x0
    80204484:	d32080e7          	jalr	-718(ra) # 802041b2 <_Z8tf_freadPciP13struct_TFFILEb>
    while ((*filename != '/') && (*filename != '\x00')) filename += 1;
    80204488:	0004c783          	lbu	a5,0(s1)
    8020448c:	02f00713          	li	a4,47
    80204490:	00e78863          	beq	a5,a4,802044a0 <_Z7tf_walkPcP13struct_TFFILE+0x5e>
    80204494:	c799                	beqz	a5,802044a2 <_Z7tf_walkPcP13struct_TFFILE+0x60>
    80204496:	0485                	addi	s1,s1,1
    80204498:	0004c783          	lbu	a5,0(s1)
    8020449c:	fee79ce3          	bne	a5,a4,80204494 <_Z7tf_walkPcP13struct_TFFILE+0x52>
    if (*filename == '/') filename += 1;
    802044a0:	0485                	addi	s1,s1,1
    fp->parentStartCluster = fp->startCluster;
    802044a2:	00492783          	lw	a5,4(s2)
    802044a6:	00f92023          	sw	a5,0(s2)
    fp->startCluster = ((uint32_t)(entry.msdos.eaIndex & 0xffff) << 16) | (entry.msdos.firstCluster & 0xffff);
    802044aa:	fd445783          	lhu	a5,-44(s0)
    802044ae:	0107979b          	slliw	a5,a5,0x10
    802044b2:	fda45703          	lhu	a4,-38(s0)
    802044b6:	8fd9                	or	a5,a5,a4
    802044b8:	2781                	sext.w	a5,a5
    802044ba:	00f92223          	sw	a5,4(s2)
    fp->attributes = entry.msdos.attributes;
    802044be:	fcb44703          	lbu	a4,-53(s0)
    802044c2:	00e90ca3          	sb	a4,25(s2)
    fp->currentCluster = fp->startCluster;
    802044c6:	00f92623          	sw	a5,12(s2)
    fp->currentClusterIdx = 0;
    802044ca:	00092423          	sw	zero,8(s2)
    fp->currentSector = 0;
    802044ce:	00091823          	sh	zero,16(s2)
    fp->currentByte = 0;
    802044d2:	00091923          	sh	zero,18(s2)
    fp->pos = 0;
    802044d6:	00092a23          	sw	zero,20(s2)
    fp->flags = TF_FLAG_OPEN;
    802044da:	4789                	li	a5,2
    802044dc:	00f90c23          	sb	a5,24(s2)
    fp->size = (entry.msdos.attributes & TF_ATTR_DIRECTORY) ? 0xffffffff : entry.msdos.fileSize;
    802044e0:	8b41                	andi	a4,a4,16
    802044e2:	57fd                	li	a5,-1
    802044e4:	e319                	bnez	a4,802044ea <_Z7tf_walkPcP13struct_TFFILE+0xa8>
    802044e6:	fdc42783          	lw	a5,-36(s0)
    802044ea:	00f92e23          	sw	a5,28(s2)
    if (*filename == '\x00') return NULL;
    802044ee:	0004c783          	lbu	a5,0(s1)
    802044f2:	4501                	li	a0,0
    802044f4:	c391                	beqz	a5,802044f8 <_Z7tf_walkPcP13struct_TFFILE+0xb6>
    return filename;
    802044f6:	8526                	mv	a0,s1
}
    802044f8:	70e2                	ld	ra,56(sp)
    802044fa:	7442                	ld	s0,48(sp)
    802044fc:	74a2                	ld	s1,40(sp)
    802044fe:	7902                	ld	s2,32(sp)
    80204500:	6121                	addi	sp,sp,64
    80204502:	8082                	ret
    filename++;
    80204504:	00150713          	addi	a4,a0,1
    if (*filename == '\x00') return NULL;
    80204508:	00154783          	lbu	a5,1(a0)
    8020450c:	cb81                	beqz	a5,8020451c <_Z7tf_walkPcP13struct_TFFILE+0xda>
    filename++;
    8020450e:	84ba                	mv	s1,a4
    80204510:	b7b9                	j	8020445e <_Z7tf_walkPcP13struct_TFFILE+0x1c>
      fp->flags = 0xff;
    80204512:	57fd                	li	a5,-1
    80204514:	00f90c23          	sb	a5,24(s2)
      return NULL;
    80204518:	4501                	li	a0,0
    8020451a:	bff9                	j	802044f8 <_Z7tf_walkPcP13struct_TFFILE+0xb6>
    if (*filename == '\x00') return NULL;
    8020451c:	4501                	li	a0,0
    8020451e:	bfe9                	j	802044f8 <_Z7tf_walkPcP13struct_TFFILE+0xb6>

0000000080204520 <_Z13tf_choose_sfnPcS_P13struct_TFFILE>:
void tf_choose_sfn(char *dest, char *src, TFFile *fp) {
    80204520:	7109                	addi	sp,sp,-384
    80204522:	fe86                	sd	ra,376(sp)
    80204524:	faa2                	sd	s0,368(sp)
    80204526:	f6a6                	sd	s1,360(sp)
    80204528:	f2ca                	sd	s2,352(sp)
    8020452a:	eece                	sd	s3,344(sp)
    8020452c:	ead2                	sd	s4,336(sp)
    8020452e:	e6d6                	sd	s5,328(sp)
    80204530:	e2da                	sd	s6,320(sp)
    80204532:	fe5e                	sd	s7,312(sp)
    80204534:	fa62                	sd	s8,304(sp)
    80204536:	f666                	sd	s9,296(sp)
    80204538:	f26a                	sd	s10,288(sp)
    8020453a:	0300                	addi	s0,sp,384
    8020453c:	84aa                	mv	s1,a0
    8020453e:	892e                	mv	s2,a1
    80204540:	85b2                	mv	a1,a2
  memcpy(&xfile, fp, sizeof(TFFile));
    80204542:	12000613          	li	a2,288
    80204546:	e8040513          	addi	a0,s0,-384
    8020454a:	ffffc097          	auipc	ra,0xffffc
    8020454e:	6d0080e7          	jalr	1744(ra) # 80200c1a <_Z6memcpyPvPKvj>
  int results, num = 1;
    80204552:	4a05                	li	s4,1
    switch (results) {
    80204554:	5afd                	li	s5,-1
        memcpy(temp, dest, 8);
    80204556:	0008cb97          	auipc	s7,0x8c
    8020455a:	aaab8b93          	addi	s7,s7,-1366 # 80290000 <tf_file_handles>
    8020455e:	0008cb17          	auipc	s6,0x8c
    80204562:	042b0b13          	addi	s6,s6,66 # 802905a0 <temp>
        memcpy(temp + 9, dest + 8, 3);
    80204566:	00848d13          	addi	s10,s1,8
    8020456a:	0008cc97          	auipc	s9,0x8c
    8020456e:	03fc8c93          	addi	s9,s9,63 # 802905a9 <temp+0x9>
        temp[8] = '.';
    80204572:	02e00c13          	li	s8,46
    results = tf_shorten_filename(dest, src, num);
    80204576:	0ffa7993          	andi	s3,s4,255
    8020457a:	864e                	mv	a2,s3
    8020457c:	85ca                	mv	a1,s2
    8020457e:	8526                	mv	a0,s1
    80204580:	fffff097          	auipc	ra,0xfffff
    80204584:	546080e7          	jalr	1350(ra) # 80203ac6 <_Z19tf_shorten_filenamePcS_c>
    switch (results) {
    80204588:	05550063          	beq	a0,s5,802045c8 <_Z13tf_choose_sfnPcS_P13struct_TFFILE+0xa8>
    8020458c:	f57d                	bnez	a0,8020457a <_Z13tf_choose_sfnPcS_P13struct_TFFILE+0x5a>
        memcpy(temp, dest, 8);
    8020458e:	4621                	li	a2,8
    80204590:	85a6                	mv	a1,s1
    80204592:	855a                	mv	a0,s6
    80204594:	ffffc097          	auipc	ra,0xffffc
    80204598:	686080e7          	jalr	1670(ra) # 80200c1a <_Z6memcpyPvPKvj>
        memcpy(temp + 9, dest + 8, 3);
    8020459c:	460d                	li	a2,3
    8020459e:	85ea                	mv	a1,s10
    802045a0:	8566                	mv	a0,s9
    802045a2:	ffffc097          	auipc	ra,0xffffc
    802045a6:	678080e7          	jalr	1656(ra) # 80200c1a <_Z6memcpyPvPKvj>
        temp[8] = '.';
    802045aa:	5b8b8423          	sb	s8,1448(s7)
        temp[12] = 0;
    802045ae:	5a0b8623          	sb	zero,1452(s7)
        if (0 > tf_find_file(&xfile, temp)) {
    802045b2:	85da                	mv	a1,s6
    802045b4:	e8040513          	addi	a0,s0,-384
    802045b8:	00000097          	auipc	ra,0x0
    802045bc:	e42080e7          	jalr	-446(ra) # 802043fa <_Z12tf_find_fileP13struct_TFFILEPc>
    802045c0:	00054463          	bltz	a0,802045c8 <_Z13tf_choose_sfnPcS_P13struct_TFFILE+0xa8>
        num++;
    802045c4:	2a05                	addiw	s4,s4,1
        break;
    802045c6:	bf45                	j	80204576 <_Z13tf_choose_sfnPcS_P13struct_TFFILE+0x56>
}
    802045c8:	70f6                	ld	ra,376(sp)
    802045ca:	7456                	ld	s0,368(sp)
    802045cc:	74b6                	ld	s1,360(sp)
    802045ce:	7916                	ld	s2,352(sp)
    802045d0:	69f6                	ld	s3,344(sp)
    802045d2:	6a56                	ld	s4,336(sp)
    802045d4:	6ab6                	ld	s5,328(sp)
    802045d6:	6b16                	ld	s6,320(sp)
    802045d8:	7bf2                	ld	s7,312(sp)
    802045da:	7c52                	ld	s8,304(sp)
    802045dc:	7cb2                	ld	s9,296(sp)
    802045de:	7d12                	ld	s10,288(sp)
    802045e0:	6119                	addi	sp,sp,384
    802045e2:	8082                	ret

00000000802045e4 <_Z9tf_fnopenPKcS0_i>:
TFFile *tf_fnopen(const char *filename, const char *mode, int n) {
    802045e4:	7169                	addi	sp,sp,-304
    802045e6:	f606                	sd	ra,296(sp)
    802045e8:	f222                	sd	s0,288(sp)
    802045ea:	ee26                	sd	s1,280(sp)
    802045ec:	ea4a                	sd	s2,272(sp)
    802045ee:	e64e                	sd	s3,264(sp)
    802045f0:	e252                	sd	s4,256(sp)
    802045f2:	1a00                	addi	s0,sp,304
    802045f4:	892a                	mv	s2,a0
    802045f6:	8a2e                	mv	s4,a1
    802045f8:	89b2                	mv	s3,a2
  TFFile *fp = tf_get_free_handle();
    802045fa:	fffff097          	auipc	ra,0xfffff
    802045fe:	44e080e7          	jalr	1102(ra) # 80203a48 <_Z18tf_get_free_handlev>
  if (fp == NULL) return (TFFile *)-1;
    80204602:	54fd                	li	s1,-1
    80204604:	10050763          	beqz	a0,80204712 <_Z9tf_fnopenPKcS0_i+0x12e>
    80204608:	84aa                	mv	s1,a0
  strncpy(myfile, filename, n);
    8020460a:	864e                	mv	a2,s3
    8020460c:	85ca                	mv	a1,s2
    8020460e:	ed040513          	addi	a0,s0,-304
    80204612:	ffffc097          	auipc	ra,0xffffc
    80204616:	6c6080e7          	jalr	1734(ra) # 80200cd8 <_Z7strncpyPcPKci>
  myfile[n] = 0;
    8020461a:	fd040793          	addi	a5,s0,-48
    8020461e:	97ce                	add	a5,a5,s3
    80204620:	f0078023          	sb	zero,-256(a5)
  fp->currentCluster = 2;  // FIXME: this is likely supposed to be the first cluster of the Root directory...
    80204624:	4789                	li	a5,2
    80204626:	c4dc                	sw	a5,12(s1)
  fp->startCluster = 2;
    80204628:	c0dc                	sw	a5,4(s1)
  fp->parentStartCluster = 0xffffffff;
    8020462a:	577d                	li	a4,-1
    8020462c:	c098                	sw	a4,0(s1)
  fp->currentClusterIdx = 0;
    8020462e:	0004a423          	sw	zero,8(s1)
  fp->currentSector = 0;
    80204632:	00049823          	sh	zero,16(s1)
  fp->currentByte = 0;
    80204636:	00049923          	sh	zero,18(s1)
  fp->attributes = TF_ATTR_DIRECTORY;
    8020463a:	47c1                	li	a5,16
    8020463c:	00f48ca3          	sb	a5,25(s1)
  fp->pos = 0;
    80204640:	0004aa23          	sw	zero,20(s1)
  fp->flags |= TF_FLAG_ROOT;
    80204644:	0184c783          	lbu	a5,24(s1)
    80204648:	0087e793          	ori	a5,a5,8
    8020464c:	00f48c23          	sb	a5,24(s1)
  fp->size = 0xffffffff;
    80204650:	ccd8                	sw	a4,28(s1)
  fp->mode = TF_MODE_READ | TF_MODE_WRITE | TF_MODE_OVERWRITE;
    80204652:	47ad                	li	a5,11
    80204654:	00f48d23          	sb	a5,26(s1)
  char *temp_filename = myfile;
    80204658:	ed040513          	addi	a0,s0,-304
    if (fp->flags == 0xff) {
    8020465c:	0ff00913          	li	s2,255
    temp_filename = tf_walk(temp_filename, fp);
    80204660:	85a6                	mv	a1,s1
    80204662:	00000097          	auipc	ra,0x0
    80204666:	de0080e7          	jalr	-544(ra) # 80204442 <_Z7tf_walkPcP13struct_TFFILE>
    if (fp->flags == 0xff) {
    8020466a:	0184c783          	lbu	a5,24(s1)
    8020466e:	0b278b63          	beq	a5,s2,80204724 <_Z9tf_fnopenPKcS0_i+0x140>
  while (temp_filename != NULL) {
    80204672:	f57d                	bnez	a0,80204660 <_Z9tf_fnopenPKcS0_i+0x7c>
  if (strchr(mode, 'r')) {
    80204674:	07200593          	li	a1,114
    80204678:	8552                	mv	a0,s4
    8020467a:	ffffc097          	auipc	ra,0xffffc
    8020467e:	6fc080e7          	jalr	1788(ra) # 80200d76 <_Z6strchrPKcc>
    80204682:	c519                	beqz	a0,80204690 <_Z9tf_fnopenPKcS0_i+0xac>
    fp->mode |= TF_MODE_READ;
    80204684:	01a4c783          	lbu	a5,26(s1)
    80204688:	0017e793          	ori	a5,a5,1
    8020468c:	00f48d23          	sb	a5,26(s1)
  if (strchr(mode, 'a')) {
    80204690:	06100593          	li	a1,97
    80204694:	8552                	mv	a0,s4
    80204696:	ffffc097          	auipc	ra,0xffffc
    8020469a:	6e0080e7          	jalr	1760(ra) # 80200d76 <_Z6strchrPKcc>
    8020469e:	cd11                	beqz	a0,802046ba <_Z9tf_fnopenPKcS0_i+0xd6>
    tf_unsafe_fseek(fp, fp->size, 0);
    802046a0:	4601                	li	a2,0
    802046a2:	4ccc                	lw	a1,28(s1)
    802046a4:	8526                	mv	a0,s1
    802046a6:	00000097          	auipc	ra,0x0
    802046aa:	9d0080e7          	jalr	-1584(ra) # 80204076 <_Z15tf_unsafe_fseekP13struct_TFFILEil>
    fp->mode |= TF_MODE_WRITE | TF_MODE_OVERWRITE;
    802046ae:	01a4c783          	lbu	a5,26(s1)
    802046b2:	00a7e793          	ori	a5,a5,10
    802046b6:	00f48d23          	sb	a5,26(s1)
  if (strchr(mode, '+')) fp->mode |= TF_MODE_OVERWRITE | TF_MODE_WRITE;
    802046ba:	02b00593          	li	a1,43
    802046be:	8552                	mv	a0,s4
    802046c0:	ffffc097          	auipc	ra,0xffffc
    802046c4:	6b6080e7          	jalr	1718(ra) # 80200d76 <_Z6strchrPKcc>
    802046c8:	c519                	beqz	a0,802046d6 <_Z9tf_fnopenPKcS0_i+0xf2>
    802046ca:	01a4c783          	lbu	a5,26(s1)
    802046ce:	00a7e793          	ori	a5,a5,10
    802046d2:	00f48d23          	sb	a5,26(s1)
  if (strchr(mode, 'w')) {
    802046d6:	07700593          	li	a1,119
    802046da:	8552                	mv	a0,s4
    802046dc:	ffffc097          	auipc	ra,0xffffc
    802046e0:	69a080e7          	jalr	1690(ra) # 80200d76 <_Z6strchrPKcc>
    802046e4:	c919                	beqz	a0,802046fa <_Z9tf_fnopenPKcS0_i+0x116>
    if (!(fp->attributes & TF_ATTR_DIRECTORY)) {
    802046e6:	0194c783          	lbu	a5,25(s1)
    802046ea:	8bc1                	andi	a5,a5,16
    802046ec:	c3a9                	beqz	a5,8020472e <_Z9tf_fnopenPKcS0_i+0x14a>
    fp->mode |= TF_MODE_WRITE;
    802046ee:	01a4c783          	lbu	a5,26(s1)
    802046f2:	0027e793          	ori	a5,a5,2
    802046f6:	00f48d23          	sb	a5,26(s1)
  strncpy(fp->filename, myfile, n);
    802046fa:	864e                	mv	a2,s3
    802046fc:	ed040593          	addi	a1,s0,-304
    80204700:	02048513          	addi	a0,s1,32
    80204704:	ffffc097          	auipc	ra,0xffffc
    80204708:	5d4080e7          	jalr	1492(ra) # 80200cd8 <_Z7strncpyPcPKci>
  fp->filename[n] = 0;
    8020470c:	99a6                	add	s3,s3,s1
    8020470e:	02098023          	sb	zero,32(s3) # 10000020 <_entry-0x701fffe0>
}
    80204712:	8526                	mv	a0,s1
    80204714:	70b2                	ld	ra,296(sp)
    80204716:	7412                	ld	s0,288(sp)
    80204718:	64f2                	ld	s1,280(sp)
    8020471a:	6952                	ld	s2,272(sp)
    8020471c:	69b2                	ld	s3,264(sp)
    8020471e:	6a12                	ld	s4,256(sp)
    80204720:	6155                	addi	sp,sp,304
    80204722:	8082                	ret
void tf_release_handle(TFFile *fp) { fp->flags &= ~TF_FLAG_OPEN; }
    80204724:	57f5                	li	a5,-3
    80204726:	00f48c23          	sb	a5,24(s1)
      return NULL;
    8020472a:	4481                	li	s1,0
void tf_release_handle(TFFile *fp) { fp->flags &= ~TF_FLAG_OPEN; }
    8020472c:	b7dd                	j	80204712 <_Z9tf_fnopenPKcS0_i+0x12e>
      fp->size = 0;
    8020472e:	0004ae23          	sw	zero,28(s1)
      tf_unsafe_fseek(fp, 0, 0);
    80204732:	4601                	li	a2,0
    80204734:	4581                	li	a1,0
    80204736:	8526                	mv	a0,s1
    80204738:	00000097          	auipc	ra,0x0
    8020473c:	93e080e7          	jalr	-1730(ra) # 80204076 <_Z15tf_unsafe_fseekP13struct_TFFILEil>
      if ((cluster = tf_get_fat_entry(fp->startCluster)) != TF_MARK_EOC32) {
    80204740:	40c8                	lw	a0,4(s1)
    80204742:	fffff097          	auipc	ra,0xfffff
    80204746:	24c080e7          	jalr	588(ra) # 8020398e <_Z16tf_get_fat_entryj>
    8020474a:	2501                	sext.w	a0,a0
    8020474c:	100007b7          	lui	a5,0x10000
    80204750:	17fd                	addi	a5,a5,-1
    80204752:	f8f50ee3          	beq	a0,a5,802046ee <_Z9tf_fnopenPKcS0_i+0x10a>
        tf_free_clusterchain(cluster);
    80204756:	fffff097          	auipc	ra,0xfffff
    8020475a:	6ac080e7          	jalr	1708(ra) # 80203e02 <_Z20tf_free_clusterchainj>
        tf_set_fat_entry(fp->startCluster, TF_MARK_EOC32);
    8020475e:	100005b7          	lui	a1,0x10000
    80204762:	15fd                	addi	a1,a1,-1
    80204764:	40c8                	lw	a0,4(s1)
    80204766:	fffff097          	auipc	ra,0xfffff
    8020476a:	266080e7          	jalr	614(ra) # 802039cc <_Z16tf_set_fat_entryjj>
    8020476e:	b741                	j	802046ee <_Z9tf_fnopenPKcS0_i+0x10a>

0000000080204770 <_Z9tf_fwritePKciP13struct_TFFILE>:
int tf_fwrite(const char *src, int sz, TFFile *fp) {
    80204770:	715d                	addi	sp,sp,-80
    80204772:	e486                	sd	ra,72(sp)
    80204774:	e0a2                	sd	s0,64(sp)
    80204776:	fc26                	sd	s1,56(sp)
    80204778:	f84a                	sd	s2,48(sp)
    8020477a:	f44e                	sd	s3,40(sp)
    8020477c:	f052                	sd	s4,32(sp)
    8020477e:	ec56                	sd	s5,24(sp)
    80204780:	e85a                	sd	s6,16(sp)
    80204782:	e45e                	sd	s7,8(sp)
    80204784:	e062                	sd	s8,0(sp)
    80204786:	0880                	addi	s0,sp,80
  fp->flags |= TF_FLAG_DIRTY;
    80204788:	01864783          	lbu	a5,24(a2)
    8020478c:	0017e793          	ori	a5,a5,1
    80204790:	00f60c23          	sb	a5,24(a2)
  while (sz > 0) {  // really suboptimal for performance.  optimize.
    80204794:	0cb05e63          	blez	a1,80204870 <_Z9tf_fwritePKciP13struct_TFFILE+0x100>
    80204798:	89aa                	mv	s3,a0
    8020479a:	892e                	mv	s2,a1
    8020479c:	84b2                	mv	s1,a2
  int n = 0;  // count that have been read
    8020479e:	4a81                	li	s5,0
    size_t x = BSIZE - (fp->currentByte % 512);
    802047a0:	20000b13          	li	s6,512
    memcpy(&tf_info.buffer[tracking], src, x);
    802047a4:	0008ba17          	auipc	s4,0x8b
    802047a8:	85ca0a13          	addi	s4,s4,-1956 # 8028f000 <tf_info>
    802047ac:	a839                	j	802047ca <_Z9tf_fwritePKciP13struct_TFFILE+0x5a>
    if (tf_unsafe_fseek(fp, 0, fp->pos + x)) {
    802047ae:	4581                	li	a1,0
    802047b0:	8526                	mv	a0,s1
    802047b2:	00000097          	auipc	ra,0x0
    802047b6:	8c4080e7          	jalr	-1852(ra) # 80204076 <_Z15tf_unsafe_fseekP13struct_TFFILEil>
    802047ba:	ed4d                	bnez	a0,80204874 <_Z9tf_fwritePKciP13struct_TFFILE+0x104>
    src += x;
    802047bc:	99de                	add	s3,s3,s7
    n += x;
    802047be:	018a8abb          	addw	s5,s5,s8
    sz -= x;
    802047c2:	4189093b          	subw	s2,s2,s8
  while (sz > 0) {  // really suboptimal for performance.  optimize.
    802047c6:	0b205863          	blez	s2,80204876 <_Z9tf_fwritePKciP13struct_TFFILE+0x106>
    sector = tf_first_sector(fp->currentCluster) + (fp->currentByte / 512);
    802047ca:	44c8                	lw	a0,12(s1)
    802047cc:	fffff097          	auipc	ra,0xfffff
    802047d0:	25a080e7          	jalr	602(ra) # 80203a26 <_Z15tf_first_sectorj>
    802047d4:	01249703          	lh	a4,18(s1)
    802047d8:	41f7579b          	sraiw	a5,a4,0x1f
    802047dc:	0177d79b          	srliw	a5,a5,0x17
    802047e0:	9fb9                	addw	a5,a5,a4
    802047e2:	4097d79b          	sraiw	a5,a5,0x9
    tf_fetch(sector);
    802047e6:	9d3d                	addw	a0,a0,a5
    802047e8:	fffff097          	auipc	ra,0xfffff
    802047ec:	140080e7          	jalr	320(ra) # 80203928 <_Z8tf_fetchj>
    tracking = fp->currentByte % 512;
    802047f0:	01249703          	lh	a4,18(s1)
    802047f4:	41f7579b          	sraiw	a5,a4,0x1f
    802047f8:	0177d69b          	srliw	a3,a5,0x17
    802047fc:	00d707bb          	addw	a5,a4,a3
    80204800:	1ff7f793          	andi	a5,a5,511
    80204804:	9f95                	subw	a5,a5,a3
    80204806:	0107951b          	slliw	a0,a5,0x10
    8020480a:	4105551b          	sraiw	a0,a0,0x10
    size_t x = BSIZE - (fp->currentByte % 512);
    8020480e:	40fb07bb          	subw	a5,s6,a5
    if (x > fp->size - fp->pos) {
    80204812:	4cd8                	lw	a4,28(s1)
    80204814:	48d4                	lw	a3,20(s1)
    80204816:	9f15                	subw	a4,a4,a3
    80204818:	1702                	slli	a4,a4,0x20
    8020481a:	9301                	srli	a4,a4,0x20
    8020481c:	00e7f363          	bgeu	a5,a4,80204822 <_Z9tf_fwritePKciP13struct_TFFILE+0xb2>
    80204820:	873e                	mv	a4,a5
    if (x > (size_t)sz) {
    80204822:	8bca                	mv	s7,s2
    80204824:	01277363          	bgeu	a4,s2,8020482a <_Z9tf_fwritePKciP13struct_TFFILE+0xba>
    80204828:	8bba                	mv	s7,a4
    memcpy(&tf_info.buffer[tracking], src, x);
    8020482a:	000b8c1b          	sext.w	s8,s7
    8020482e:	0571                	addi	a0,a0,28
    80204830:	8662                	mv	a2,s8
    80204832:	85ce                	mv	a1,s3
    80204834:	9552                	add	a0,a0,s4
    80204836:	ffffc097          	auipc	ra,0xffffc
    8020483a:	3e4080e7          	jalr	996(ra) # 80200c1a <_Z6memcpyPvPKvj>
    tf_info.sectorFlags |= TF_FLAG_DIRTY;  // Mark this sector as dirty
    8020483e:	014a4783          	lbu	a5,20(s4)
    80204842:	0017e793          	ori	a5,a5,1
    80204846:	00fa0a23          	sb	a5,20(s4)
    if (fp->pos + x > fp->size) {
    8020484a:	48dc                	lw	a5,20(s1)
    8020484c:	02079613          	slli	a2,a5,0x20
    80204850:	9201                	srli	a2,a2,0x20
    80204852:	965e                	add	a2,a2,s7
    80204854:	01c4e703          	lwu	a4,28(s1)
    80204858:	f4c77be3          	bgeu	a4,a2,802047ae <_Z9tf_fwritePKciP13struct_TFFILE+0x3e>
      fp->flags |= TF_FLAG_SIZECHANGED;
    8020485c:	0184c703          	lbu	a4,24(s1)
    80204860:	00476713          	ori	a4,a4,4
    80204864:	00e48c23          	sb	a4,24(s1)
      fp->size = x + fp->pos;
    80204868:	00fc07bb          	addw	a5,s8,a5
    8020486c:	ccdc                	sw	a5,28(s1)
    8020486e:	b781                	j	802047ae <_Z9tf_fwritePKciP13struct_TFFILE+0x3e>
  int n = 0;  // count that have been read
    80204870:	4a81                	li	s5,0
    80204872:	a011                	j	80204876 <_Z9tf_fwritePKciP13struct_TFFILE+0x106>
      return -1;
    80204874:	5afd                	li	s5,-1
}
    80204876:	8556                	mv	a0,s5
    80204878:	60a6                	ld	ra,72(sp)
    8020487a:	6406                	ld	s0,64(sp)
    8020487c:	74e2                	ld	s1,56(sp)
    8020487e:	7942                	ld	s2,48(sp)
    80204880:	79a2                	ld	s3,40(sp)
    80204882:	7a02                	ld	s4,32(sp)
    80204884:	6ae2                	ld	s5,24(sp)
    80204886:	6b42                	ld	s6,16(sp)
    80204888:	6ba2                	ld	s7,8(sp)
    8020488a:	6c02                	ld	s8,0(sp)
    8020488c:	6161                	addi	sp,sp,80
    8020488e:	8082                	ret

0000000080204890 <_Z18tf_place_lfn_chainP13struct_TFFILEPcS1_>:
int tf_place_lfn_chain(TFFile *fp, char *filename, char *sfn) {
    80204890:	711d                	addi	sp,sp,-96
    80204892:	ec86                	sd	ra,88(sp)
    80204894:	e8a2                	sd	s0,80(sp)
    80204896:	e4a6                	sd	s1,72(sp)
    80204898:	e0ca                	sd	s2,64(sp)
    8020489a:	fc4e                	sd	s3,56(sp)
    8020489c:	f852                	sd	s4,48(sp)
    8020489e:	f456                	sd	s5,40(sp)
    802048a0:	1080                	addi	s0,sp,96
    802048a2:	8a2a                	mv	s4,a0
    802048a4:	892e                	mv	s2,a1
    802048a6:	8ab2                	mv	s5,a2
  int entries = 1;
    802048a8:	4985                	li	s3,1
  while ((strptr = tf_create_lfn_entry(strptr, &entry)) != 0) {
    802048aa:	fa040593          	addi	a1,s0,-96
    802048ae:	854a                	mv	a0,s2
    802048b0:	fffff097          	auipc	ra,0xfffff
    802048b4:	40e080e7          	jalr	1038(ra) # 80203cbe <_Z19tf_create_lfn_entryPcP19struct_FatFileEntry>
    802048b8:	c501                	beqz	a0,802048c0 <_Z18tf_place_lfn_chainP13struct_TFFILEPcS1_+0x30>
    entries += 1;
    802048ba:	2985                	addiw	s3,s3,1
  while ((strptr = tf_create_lfn_entry(strptr, &entry)) != 0) {
    802048bc:	892a                	mv	s2,a0
    802048be:	b7f5                	j	802048aa <_Z18tf_place_lfn_chainP13struct_TFFILEPcS1_+0x1a>
  seq = entries | 0x40;
    802048c0:	0409e493          	ori	s1,s3,64
    802048c4:	0ff4f493          	andi	s1,s1,255
  for (i = 0; i < entries; i++) {
    802048c8:	07305063          	blez	s3,80204928 <_Z18tf_place_lfn_chainP13struct_TFFILEPcS1_+0x98>
    802048cc:	39fd                	addiw	s3,s3,-1
    802048ce:	1982                	slli	s3,s3,0x20
    802048d0:	0209d993          	srli	s3,s3,0x20
    802048d4:	0985                	addi	s3,s3,1
    802048d6:	00299793          	slli	a5,s3,0x2
    802048da:	40f987b3          	sub	a5,s3,a5
    802048de:	078a                	slli	a5,a5,0x2
    802048e0:	413789b3          	sub	s3,a5,s3
    802048e4:	99ca                	add	s3,s3,s2
    tf_create_lfn_entry(last_strptr, &entry);
    802048e6:	fa040593          	addi	a1,s0,-96
    802048ea:	854a                	mv	a0,s2
    802048ec:	fffff097          	auipc	ra,0xfffff
    802048f0:	3d2080e7          	jalr	978(ra) # 80203cbe <_Z19tf_create_lfn_entryPcP19struct_FatFileEntry>
    entry.lfn.sequence_number = seq;
    802048f4:	fa940023          	sb	s1,-96(s0)
    entry.lfn.checksum = tf_lfn_checksum(sfn);
    802048f8:	8556                	mv	a0,s5
    802048fa:	fffff097          	auipc	ra,0xfffff
    802048fe:	4da080e7          	jalr	1242(ra) # 80203dd4 <_Z15tf_lfn_checksumPKc>
    80204902:	faa406a3          	sb	a0,-83(s0)
    tf_fwrite((char *)&entry, sizeof(FatFileEntry), fp);
    80204906:	8652                	mv	a2,s4
    80204908:	02000593          	li	a1,32
    8020490c:	fa040513          	addi	a0,s0,-96
    80204910:	00000097          	auipc	ra,0x0
    80204914:	e60080e7          	jalr	-416(ra) # 80204770 <_Z9tf_fwritePKciP13struct_TFFILE>
    seq = ((seq & ~0x40) - 1);
    80204918:	0bf4f493          	andi	s1,s1,191
    8020491c:	34fd                	addiw	s1,s1,-1
    8020491e:	0ff4f493          	andi	s1,s1,255
    last_strptr -= 13;
    80204922:	194d                	addi	s2,s2,-13
  for (i = 0; i < entries; i++) {
    80204924:	fd3911e3          	bne	s2,s3,802048e6 <_Z18tf_place_lfn_chainP13struct_TFFILEPcS1_+0x56>
}
    80204928:	4501                	li	a0,0
    8020492a:	60e6                	ld	ra,88(sp)
    8020492c:	6446                	ld	s0,80(sp)
    8020492e:	64a6                	ld	s1,72(sp)
    80204930:	6906                	ld	s2,64(sp)
    80204932:	79e2                	ld	s3,56(sp)
    80204934:	7a42                	ld	s4,48(sp)
    80204936:	7aa2                	ld	s5,40(sp)
    80204938:	6125                	addi	sp,sp,96
    8020493a:	8082                	ret

000000008020493c <_Z8tf_fputsPcP13struct_TFFILE>:
int tf_fputs(char *src, TFFile *fp) { return tf_fwrite(src, strlen(src), fp); }
    8020493c:	1101                	addi	sp,sp,-32
    8020493e:	ec06                	sd	ra,24(sp)
    80204940:	e822                	sd	s0,16(sp)
    80204942:	e426                	sd	s1,8(sp)
    80204944:	e04a                	sd	s2,0(sp)
    80204946:	1000                	addi	s0,sp,32
    80204948:	84aa                	mv	s1,a0
    8020494a:	892e                	mv	s2,a1
    8020494c:	ffffc097          	auipc	ra,0xffffc
    80204950:	400080e7          	jalr	1024(ra) # 80200d4c <_Z6strlenPKc>
    80204954:	85aa                	mv	a1,a0
    80204956:	864a                	mv	a2,s2
    80204958:	8526                	mv	a0,s1
    8020495a:	00000097          	auipc	ra,0x0
    8020495e:	e16080e7          	jalr	-490(ra) # 80204770 <_Z9tf_fwritePKciP13struct_TFFILE>
    80204962:	60e2                	ld	ra,24(sp)
    80204964:	6442                	ld	s0,16(sp)
    80204966:	64a2                	ld	s1,8(sp)
    80204968:	6902                	ld	s2,0(sp)
    8020496a:	6105                	addi	sp,sp,32
    8020496c:	8082                	ret

000000008020496e <_Z9tf_fflushP13struct_TFFILE>:
int tf_fflush(TFFile *fp) {
    8020496e:	715d                	addi	sp,sp,-80
    80204970:	e486                	sd	ra,72(sp)
    80204972:	e0a2                	sd	s0,64(sp)
    80204974:	fc26                	sd	s1,56(sp)
    80204976:	f84a                	sd	s2,48(sp)
    80204978:	f44e                	sd	s3,40(sp)
    8020497a:	f052                	sd	s4,32(sp)
    8020497c:	0880                	addi	s0,sp,80
  if (!(fp->flags & TF_FLAG_DIRTY)) return 0;
    8020497e:	01854783          	lbu	a5,24(a0)
    80204982:	8b85                	andi	a5,a5,1
    80204984:	4901                	li	s2,0
    80204986:	cb9d                	beqz	a5,802049bc <_Z9tf_fflushP13struct_TFFILE+0x4e>
    80204988:	84aa                	mv	s1,a0
  if (tf_info.sectorFlags & TF_FLAG_DIRTY) {
    8020498a:	0008a797          	auipc	a5,0x8a
    8020498e:	68a7c783          	lbu	a5,1674(a5) # 8028f014 <tf_info+0x14>
    80204992:	8b85                	andi	a5,a5,1
  int rc = 0;
    80204994:	4901                	li	s2,0
  if (tf_info.sectorFlags & TF_FLAG_DIRTY) {
    80204996:	ef85                	bnez	a5,802049ce <_Z9tf_fflushP13struct_TFFILE+0x60>
  if (fp->flags & TF_FLAG_SIZECHANGED) {
    80204998:	0184c783          	lbu	a5,24(s1)
    8020499c:	8b91                	andi	a5,a5,4
    8020499e:	cb91                	beqz	a5,802049b2 <_Z9tf_fflushP13struct_TFFILE+0x44>
    if (fp->attributes & 0x10) {
    802049a0:	0194c783          	lbu	a5,25(s1)
    802049a4:	8bc1                	andi	a5,a5,16
    802049a6:	cb95                	beqz	a5,802049da <_Z9tf_fflushP13struct_TFFILE+0x6c>
    fp->flags &= ~TF_FLAG_SIZECHANGED;
    802049a8:	0184c783          	lbu	a5,24(s1)
    802049ac:	9bed                	andi	a5,a5,-5
    802049ae:	00f48c23          	sb	a5,24(s1)
  fp->flags &= ~TF_FLAG_DIRTY;
    802049b2:	0184c783          	lbu	a5,24(s1)
    802049b6:	9bf9                	andi	a5,a5,-2
    802049b8:	00f48c23          	sb	a5,24(s1)
}
    802049bc:	854a                	mv	a0,s2
    802049be:	60a6                	ld	ra,72(sp)
    802049c0:	6406                	ld	s0,64(sp)
    802049c2:	74e2                	ld	s1,56(sp)
    802049c4:	7942                	ld	s2,48(sp)
    802049c6:	79a2                	ld	s3,40(sp)
    802049c8:	7a02                	ld	s4,32(sp)
    802049ca:	6161                	addi	sp,sp,80
    802049cc:	8082                	ret
    rc = tf_store();
    802049ce:	fffff097          	auipc	ra,0xfffff
    802049d2:	f26080e7          	jalr	-218(ra) # 802038f4 <_Z8tf_storev>
    802049d6:	892a                	mv	s2,a0
    802049d8:	b7c1                	j	80204998 <_Z9tf_fflushP13struct_TFFILE+0x2a>
      dir = tf_parent(fp->filename, "r+", false);
    802049da:	02048a13          	addi	s4,s1,32
    802049de:	4601                	li	a2,0
    802049e0:	00006597          	auipc	a1,0x6
    802049e4:	eb858593          	addi	a1,a1,-328 # 8020a898 <_ZL6digits+0x590>
    802049e8:	8552                	mv	a0,s4
    802049ea:	00000097          	auipc	ra,0x0
    802049ee:	2ce080e7          	jalr	718(ra) # 80204cb8 <_Z9tf_parentPKcS0_i>
    802049f2:	89aa                	mv	s3,a0
      if (dir == (void *)-1) {
    802049f4:	57fd                	li	a5,-1
    802049f6:	06f50563          	beq	a0,a5,80204a60 <_Z9tf_fflushP13struct_TFFILE+0xf2>
      filename = (char *)strrchr((char const *)fp->filename, '/');
    802049fa:	02f00593          	li	a1,47
    802049fe:	8552                	mv	a0,s4
    80204a00:	ffffc097          	auipc	ra,0xffffc
    80204a04:	39a080e7          	jalr	922(ra) # 80200d9a <_Z7strrchrPKcc>
      tf_find_file(dir, filename + 1);
    80204a08:	00150593          	addi	a1,a0,1
    80204a0c:	854e                	mv	a0,s3
    80204a0e:	00000097          	auipc	ra,0x0
    80204a12:	9ec080e7          	jalr	-1556(ra) # 802043fa <_Z12tf_find_fileP13struct_TFFILEPc>
      tf_fread((char *)&entry, sizeof(FatFileEntry), dir);
    80204a16:	4681                	li	a3,0
    80204a18:	864e                	mv	a2,s3
    80204a1a:	02000593          	li	a1,32
    80204a1e:	fb040513          	addi	a0,s0,-80
    80204a22:	fffff097          	auipc	ra,0xfffff
    80204a26:	790080e7          	jalr	1936(ra) # 802041b2 <_Z8tf_freadPciP13struct_TFFILEb>
      tf_fseek(dir, -sizeof(FatFileEntry), dir->pos);
    80204a2a:	0149e603          	lwu	a2,20(s3)
    80204a2e:	5581                	li	a1,-32
    80204a30:	854e                	mv	a0,s3
    80204a32:	fffff097          	auipc	ra,0xfffff
    80204a36:	756080e7          	jalr	1878(ra) # 80204188 <_Z8tf_fseekP13struct_TFFILEml>
      entry.msdos.fileSize = fp->size - 1;
    80204a3a:	4cdc                	lw	a5,28(s1)
    80204a3c:	37fd                	addiw	a5,a5,-1
    80204a3e:	fcf42623          	sw	a5,-52(s0)
      tf_fwrite((char *)&entry, sizeof(FatFileEntry), dir);  // Write fatfile entry back to disk
    80204a42:	864e                	mv	a2,s3
    80204a44:	02000593          	li	a1,32
    80204a48:	fb040513          	addi	a0,s0,-80
    80204a4c:	00000097          	auipc	ra,0x0
    80204a50:	d24080e7          	jalr	-732(ra) # 80204770 <_Z9tf_fwritePKciP13struct_TFFILE>
      tf_fclose(dir);
    80204a54:	854e                	mv	a0,s3
    80204a56:	00000097          	auipc	ra,0x0
    80204a5a:	00e080e7          	jalr	14(ra) # 80204a64 <_Z9tf_fcloseP13struct_TFFILE>
    80204a5e:	b7a9                	j	802049a8 <_Z9tf_fflushP13struct_TFFILE+0x3a>
        return -1;
    80204a60:	597d                	li	s2,-1
    80204a62:	bfa9                	j	802049bc <_Z9tf_fflushP13struct_TFFILE+0x4e>

0000000080204a64 <_Z9tf_fcloseP13struct_TFFILE>:
int tf_fclose(TFFile *fp) {
    80204a64:	1101                	addi	sp,sp,-32
    80204a66:	ec06                	sd	ra,24(sp)
    80204a68:	e822                	sd	s0,16(sp)
    80204a6a:	e426                	sd	s1,8(sp)
    80204a6c:	1000                	addi	s0,sp,32
    80204a6e:	84aa                	mv	s1,a0
  rc = tf_fflush(fp);
    80204a70:	00000097          	auipc	ra,0x0
    80204a74:	efe080e7          	jalr	-258(ra) # 8020496e <_Z9tf_fflushP13struct_TFFILE>
  fp->flags &= ~TF_FLAG_OPEN;  // Mark the file as available for the system to use
    80204a78:	0184c783          	lbu	a5,24(s1)
    80204a7c:	9bf5                	andi	a5,a5,-3
    80204a7e:	00f48c23          	sb	a5,24(s1)
}
    80204a82:	60e2                	ld	ra,24(sp)
    80204a84:	6442                	ld	s0,16(sp)
    80204a86:	64a2                	ld	s1,8(sp)
    80204a88:	6105                	addi	sp,sp,32
    80204a8a:	8082                	ret

0000000080204a8c <_Z8tf_mkdirPKci>:
int tf_mkdir(const char *filename, int mkParents) {
    80204a8c:	7149                	addi	sp,sp,-368
    80204a8e:	f686                	sd	ra,360(sp)
    80204a90:	f2a2                	sd	s0,352(sp)
    80204a92:	eea6                	sd	s1,344(sp)
    80204a94:	eaca                	sd	s2,336(sp)
    80204a96:	e6ce                	sd	s3,328(sp)
    80204a98:	1a80                	addi	s0,sp,368
    80204a9a:	89aa                	mv	s3,a0
    80204a9c:	892e                	mv	s2,a1
  strncpy(orig_fn, filename, TF_MAX_PATH - 1);
    80204a9e:	0ff00613          	li	a2,255
    80204aa2:	85aa                	mv	a1,a0
    80204aa4:	ed040513          	addi	a0,s0,-304
    80204aa8:	ffffc097          	auipc	ra,0xffffc
    80204aac:	230080e7          	jalr	560(ra) # 80200cd8 <_Z7strncpyPcPKci>
  orig_fn[TF_MAX_PATH - 1] = 0;
    80204ab0:	fc0407a3          	sb	zero,-49(s0)
  memset(&blank, 0, sizeof(FatFileEntry));
    80204ab4:	02000613          	li	a2,32
    80204ab8:	4581                	li	a1,0
    80204aba:	e9040513          	addi	a0,s0,-368
    80204abe:	ffffc097          	auipc	ra,0xffffc
    80204ac2:	09e080e7          	jalr	158(ra) # 80200b5c <_Z6memsetPvij>
  fp = tf_fopen(filename, "r");
    80204ac6:	00006597          	auipc	a1,0x6
    80204aca:	dda58593          	addi	a1,a1,-550 # 8020a8a0 <_ZL6digits+0x598>
    80204ace:	854e                	mv	a0,s3
    80204ad0:	00000097          	auipc	ra,0x0
    80204ad4:	3e8080e7          	jalr	1000(ra) # 80204eb8 <_Z8tf_fopenPKcS0_>
  if (fp)  // if not NULL, the filename already exists.
    80204ad8:	c505                	beqz	a0,80204b00 <_Z8tf_mkdirPKci+0x74>
    80204ada:	84aa                	mv	s1,a0
    tf_fclose(fp);
    80204adc:	00000097          	auipc	ra,0x0
    80204ae0:	f88080e7          	jalr	-120(ra) # 80204a64 <_Z9tf_fcloseP13struct_TFFILE>
void tf_release_handle(TFFile *fp) { fp->flags &= ~TF_FLAG_OPEN; }
    80204ae4:	0184c783          	lbu	a5,24(s1)
    80204ae8:	9bf5                	andi	a5,a5,-3
    80204aea:	00f48c23          	sb	a5,24(s1)
      return 0;
    80204aee:	00193513          	seqz	a0,s2
}
    80204af2:	70b6                	ld	ra,360(sp)
    80204af4:	7416                	ld	s0,352(sp)
    80204af6:	64f6                	ld	s1,344(sp)
    80204af8:	6956                	ld	s2,336(sp)
    80204afa:	69b6                	ld	s3,328(sp)
    80204afc:	6175                	addi	sp,sp,368
    80204afe:	8082                	ret
  fp = tf_parent(filename, "r+", mkParents);
    80204b00:	864a                	mv	a2,s2
    80204b02:	00006597          	auipc	a1,0x6
    80204b06:	d9658593          	addi	a1,a1,-618 # 8020a898 <_ZL6digits+0x590>
    80204b0a:	854e                	mv	a0,s3
    80204b0c:	00000097          	auipc	ra,0x0
    80204b10:	1ac080e7          	jalr	428(ra) # 80204cb8 <_Z9tf_parentPKcS0_i>
    80204b14:	84aa                	mv	s1,a0
  if (!fp) {
    80204b16:	18050163          	beqz	a0,80204c98 <_Z8tf_mkdirPKci+0x20c>
    tf_fread((char *)&entry, sizeof(FatFileEntry), fp);
    80204b1a:	4681                	li	a3,0
    80204b1c:	8626                	mv	a2,s1
    80204b1e:	02000593          	li	a1,32
    80204b22:	eb040513          	addi	a0,s0,-336
    80204b26:	fffff097          	auipc	ra,0xfffff
    80204b2a:	68c080e7          	jalr	1676(ra) # 802041b2 <_Z8tf_freadPciP13struct_TFFILEb>
  } while (entry.msdos.filename[0] != '\x00');
    80204b2e:	eb044783          	lbu	a5,-336(s0)
    80204b32:	f7e5                	bnez	a5,80204b1a <_Z8tf_mkdirPKci+0x8e>
  tf_fseek(fp, -sizeof(FatFileEntry), fp->pos);
    80204b34:	0144e603          	lwu	a2,20(s1)
    80204b38:	5581                	li	a1,-32
    80204b3a:	8526                	mv	a0,s1
    80204b3c:	fffff097          	auipc	ra,0xfffff
    80204b40:	64c080e7          	jalr	1612(ra) # 80204188 <_Z8tf_fseekP13struct_TFFILEml>
  cluster = tf_find_free_cluster();
    80204b44:	fffff097          	auipc	ra,0xfffff
    80204b48:	46e080e7          	jalr	1134(ra) # 80203fb2 <_Z20tf_find_free_clusterv>
    80204b4c:	0005091b          	sext.w	s2,a0
  tf_set_fat_entry(cluster, TF_MARK_EOC32);  // Marks the new cluster as the last one (but no longer free)
    80204b50:	100005b7          	lui	a1,0x10000
    80204b54:	15fd                	addi	a1,a1,-1
    80204b56:	854a                	mv	a0,s2
    80204b58:	fffff097          	auipc	ra,0xfffff
    80204b5c:	e74080e7          	jalr	-396(ra) # 802039cc <_Z16tf_set_fat_entryjj>
  entry.msdos.attributes = TF_ATTR_DIRECTORY;
    80204b60:	47c1                	li	a5,16
    80204b62:	eaf40da3          	sb	a5,-325(s0)
  entry.msdos.creationTimeMs = 0x25;
    80204b66:	02500793          	li	a5,37
    80204b6a:	eaf40ea3          	sb	a5,-323(s0)
  entry.msdos.creationTime = 0x7e3c;
    80204b6e:	7761                	lui	a4,0xffff8
    80204b70:	e3c74713          	xori	a4,a4,-452
    80204b74:	eae41f23          	sh	a4,-322(s0)
  entry.msdos.creationDate = 0x4262;
    80204b78:	6791                	lui	a5,0x4
    80204b7a:	2627879b          	addiw	a5,a5,610
    80204b7e:	ecf41023          	sh	a5,-320(s0)
  entry.msdos.lastAccessTime = 0x4262;
    80204b82:	ecf41123          	sh	a5,-318(s0)
  entry.msdos.eaIndex = (cluster >> 16) & 0xffff;
    80204b86:	0109569b          	srliw	a3,s2,0x10
    80204b8a:	ecd41223          	sh	a3,-316(s0)
  entry.msdos.modifiedTime = 0x7e3c;
    80204b8e:	ece41323          	sh	a4,-314(s0)
  entry.msdos.modifiedDate = 0x4262;
    80204b92:	ecf41423          	sh	a5,-312(s0)
  entry.msdos.firstCluster = cluster & 0xffff;
    80204b96:	ed241523          	sh	s2,-310(s0)
  entry.msdos.fileSize = 0;
    80204b9a:	ec042623          	sw	zero,-308(s0)
  temp = strrchr(filename, '/') + 1;
    80204b9e:	02f00593          	li	a1,47
    80204ba2:	854e                	mv	a0,s3
    80204ba4:	ffffc097          	auipc	ra,0xffffc
    80204ba8:	1f6080e7          	jalr	502(ra) # 80200d9a <_Z7strrchrPKcc>
    80204bac:	00150913          	addi	s2,a0,1
  tf_choose_sfn(entry.msdos.filename, temp, fp);
    80204bb0:	8626                	mv	a2,s1
    80204bb2:	85ca                	mv	a1,s2
    80204bb4:	eb040513          	addi	a0,s0,-336
    80204bb8:	00000097          	auipc	ra,0x0
    80204bbc:	968080e7          	jalr	-1688(ra) # 80204520 <_Z13tf_choose_sfnPcS_P13struct_TFFILE>
  tf_place_lfn_chain(fp, temp, entry.msdos.filename);
    80204bc0:	eb040613          	addi	a2,s0,-336
    80204bc4:	85ca                	mv	a1,s2
    80204bc6:	8526                	mv	a0,s1
    80204bc8:	00000097          	auipc	ra,0x0
    80204bcc:	cc8080e7          	jalr	-824(ra) # 80204890 <_Z18tf_place_lfn_chainP13struct_TFFILEPcS1_>
  tf_fwrite((char *)&entry, sizeof(FatFileEntry), fp);
    80204bd0:	8626                	mv	a2,s1
    80204bd2:	02000593          	li	a1,32
    80204bd6:	eb040513          	addi	a0,s0,-336
    80204bda:	00000097          	auipc	ra,0x0
    80204bde:	b96080e7          	jalr	-1130(ra) # 80204770 <_Z9tf_fwritePKciP13struct_TFFILE>
  tf_fwrite((char *)&blank, sizeof(FatFileEntry), fp);
    80204be2:	8626                	mv	a2,s1
    80204be4:	02000593          	li	a1,32
    80204be8:	e9040513          	addi	a0,s0,-368
    80204bec:	00000097          	auipc	ra,0x0
    80204bf0:	b84080e7          	jalr	-1148(ra) # 80204770 <_Z9tf_fwritePKciP13struct_TFFILE>
  tf_fclose(fp);
    80204bf4:	8526                	mv	a0,s1
    80204bf6:	00000097          	auipc	ra,0x0
    80204bfa:	e6e080e7          	jalr	-402(ra) # 80204a64 <_Z9tf_fcloseP13struct_TFFILE>
void tf_release_handle(TFFile *fp) { fp->flags &= ~TF_FLAG_OPEN; }
    80204bfe:	0184c783          	lbu	a5,24(s1)
    80204c02:	9bf5                	andi	a5,a5,-3
    80204c04:	00f48c23          	sb	a5,24(s1)
  fp = tf_fopen(orig_fn, "w");
    80204c08:	00006597          	auipc	a1,0x6
    80204c0c:	ca058593          	addi	a1,a1,-864 # 8020a8a8 <_ZL6digits+0x5a0>
    80204c10:	ed040513          	addi	a0,s0,-304
    80204c14:	00000097          	auipc	ra,0x0
    80204c18:	2a4080e7          	jalr	676(ra) # 80204eb8 <_Z8tf_fopenPKcS0_>
    80204c1c:	84aa                	mv	s1,a0
  memcpy(entry.msdos.filename, ".          ", 11);
    80204c1e:	462d                	li	a2,11
    80204c20:	00006597          	auipc	a1,0x6
    80204c24:	c9058593          	addi	a1,a1,-880 # 8020a8b0 <_ZL6digits+0x5a8>
    80204c28:	eb040513          	addi	a0,s0,-336
    80204c2c:	ffffc097          	auipc	ra,0xffffc
    80204c30:	fee080e7          	jalr	-18(ra) # 80200c1a <_Z6memcpyPvPKvj>
  tf_fwrite((char *)&entry, sizeof(FatFileEntry), fp);
    80204c34:	8626                	mv	a2,s1
    80204c36:	02000593          	li	a1,32
    80204c3a:	eb040513          	addi	a0,s0,-336
    80204c3e:	00000097          	auipc	ra,0x0
    80204c42:	b32080e7          	jalr	-1230(ra) # 80204770 <_Z9tf_fwritePKciP13struct_TFFILE>
  memcpy(entry.msdos.filename, "..         ", 11);
    80204c46:	462d                	li	a2,11
    80204c48:	00006597          	auipc	a1,0x6
    80204c4c:	c7858593          	addi	a1,a1,-904 # 8020a8c0 <_ZL6digits+0x5b8>
    80204c50:	eb040513          	addi	a0,s0,-336
    80204c54:	ffffc097          	auipc	ra,0xffffc
    80204c58:	fc6080e7          	jalr	-58(ra) # 80200c1a <_Z6memcpyPvPKvj>
  tf_fwrite((char *)&entry, sizeof(FatFileEntry), fp);
    80204c5c:	8626                	mv	a2,s1
    80204c5e:	02000593          	li	a1,32
    80204c62:	eb040513          	addi	a0,s0,-336
    80204c66:	00000097          	auipc	ra,0x0
    80204c6a:	b0a080e7          	jalr	-1270(ra) # 80204770 <_Z9tf_fwritePKciP13struct_TFFILE>
  tf_fwrite((char *)&blank, sizeof(FatFileEntry), fp);
    80204c6e:	8626                	mv	a2,s1
    80204c70:	02000593          	li	a1,32
    80204c74:	e9040513          	addi	a0,s0,-368
    80204c78:	00000097          	auipc	ra,0x0
    80204c7c:	af8080e7          	jalr	-1288(ra) # 80204770 <_Z9tf_fwritePKciP13struct_TFFILE>
  tf_fclose(fp);
    80204c80:	8526                	mv	a0,s1
    80204c82:	00000097          	auipc	ra,0x0
    80204c86:	de2080e7          	jalr	-542(ra) # 80204a64 <_Z9tf_fcloseP13struct_TFFILE>
void tf_release_handle(TFFile *fp) { fp->flags &= ~TF_FLAG_OPEN; }
    80204c8a:	0184c783          	lbu	a5,24(s1)
    80204c8e:	9bf5                	andi	a5,a5,-3
    80204c90:	00f48c23          	sb	a5,24(s1)
  return 0;
    80204c94:	4501                	li	a0,0
void tf_release_handle(TFFile *fp) { fp->flags &= ~TF_FLAG_OPEN; }
    80204c96:	bdb1                	j	80204af2 <_Z8tf_mkdirPKci+0x66>
    return 1;
    80204c98:	4505                	li	a0,1
    80204c9a:	bda1                	j	80204af2 <_Z8tf_mkdirPKci+0x66>

0000000080204c9c <_ZN15Fat32FileSystem5mkdirEPKc>:
int Fat32FileSystem::mkdir(const char *filepath) { return tf_mkdir(filepath, 0); }
    80204c9c:	1141                	addi	sp,sp,-16
    80204c9e:	e406                	sd	ra,8(sp)
    80204ca0:	e022                	sd	s0,0(sp)
    80204ca2:	0800                	addi	s0,sp,16
    80204ca4:	852e                	mv	a0,a1
    80204ca6:	4581                	li	a1,0
    80204ca8:	00000097          	auipc	ra,0x0
    80204cac:	de4080e7          	jalr	-540(ra) # 80204a8c <_Z8tf_mkdirPKci>
    80204cb0:	60a2                	ld	ra,8(sp)
    80204cb2:	6402                	ld	s0,0(sp)
    80204cb4:	0141                	addi	sp,sp,16
    80204cb6:	8082                	ret

0000000080204cb8 <_Z9tf_parentPKcS0_i>:
TFFile *tf_parent(const char *filename, const char *mode, int mkParents) {
    80204cb8:	714d                	addi	sp,sp,-336
    80204cba:	e686                	sd	ra,328(sp)
    80204cbc:	e2a2                	sd	s0,320(sp)
    80204cbe:	fe26                	sd	s1,312(sp)
    80204cc0:	fa4a                	sd	s2,304(sp)
    80204cc2:	f64e                	sd	s3,296(sp)
    80204cc4:	f252                	sd	s4,288(sp)
    80204cc6:	ee56                	sd	s5,280(sp)
    80204cc8:	0a80                	addi	s0,sp,336
    80204cca:	84aa                	mv	s1,a0
    80204ccc:	8a2e                	mv	s4,a1
    80204cce:	89b2                	mv	s3,a2
  f2 = (char *)strrchr((char const *)filename, '/');
    80204cd0:	02f00593          	li	a1,47
    80204cd4:	ffffc097          	auipc	ra,0xffffc
    80204cd8:	0c6080e7          	jalr	198(ra) # 80200d9a <_Z7strrchrPKcc>
  retval = tf_fnopen(filename, "rw", (int)(f2 - filename));
    80204cdc:	40950933          	sub	s2,a0,s1
    80204ce0:	00090a9b          	sext.w	s5,s2
    80204ce4:	8656                	mv	a2,s5
    80204ce6:	00006597          	auipc	a1,0x6
    80204cea:	bea58593          	addi	a1,a1,-1046 # 8020a8d0 <_ZL6digits+0x5c8>
    80204cee:	8526                	mv	a0,s1
    80204cf0:	00000097          	auipc	ra,0x0
    80204cf4:	8f4080e7          	jalr	-1804(ra) # 802045e4 <_Z9tf_fnopenPKcS0_i>
  if (retval == NULL && mkParents) {  // warning: recursion could fry some resources on smaller procs
    80204cf8:	c911                	beqz	a0,80204d0c <_Z9tf_parentPKcS0_i+0x54>
}
    80204cfa:	60b6                	ld	ra,328(sp)
    80204cfc:	6416                	ld	s0,320(sp)
    80204cfe:	74f2                	ld	s1,312(sp)
    80204d00:	7952                	ld	s2,304(sp)
    80204d02:	79b2                	ld	s3,296(sp)
    80204d04:	7a12                	ld	s4,288(sp)
    80204d06:	6af2                	ld	s5,280(sp)
    80204d08:	6171                	addi	sp,sp,336
    80204d0a:	8082                	ret
  if (retval == NULL && mkParents) {  // warning: recursion could fry some resources on smaller procs
    80204d0c:	fe0987e3          	beqz	s3,80204cfa <_Z9tf_parentPKcS0_i+0x42>
    if (f2 - filename > 260) {
    80204d10:	10400793          	li	a5,260
    80204d14:	ff27c3e3          	blt	a5,s2,80204cfa <_Z9tf_parentPKcS0_i+0x42>
    strncpy(tmpbuf, filename, f2 - filename);
    80204d18:	8656                	mv	a2,s5
    80204d1a:	85a6                	mv	a1,s1
    80204d1c:	eb840513          	addi	a0,s0,-328
    80204d20:	ffffc097          	auipc	ra,0xffffc
    80204d24:	fb8080e7          	jalr	-72(ra) # 80200cd8 <_Z7strncpyPcPKci>
    tmpbuf[f2 - filename] = 0;
    80204d28:	fc040793          	addi	a5,s0,-64
    80204d2c:	993e                	add	s2,s2,a5
    80204d2e:	ee090c23          	sb	zero,-264(s2)
    tf_mkdir(tmpbuf, mkParents);
    80204d32:	85ce                	mv	a1,s3
    80204d34:	eb840513          	addi	a0,s0,-328
    80204d38:	00000097          	auipc	ra,0x0
    80204d3c:	d54080e7          	jalr	-684(ra) # 80204a8c <_Z8tf_mkdirPKci>
    retval = tf_parent(filename, mode, mkParents);
    80204d40:	864e                	mv	a2,s3
    80204d42:	85d2                	mv	a1,s4
    80204d44:	8526                	mv	a0,s1
    80204d46:	00000097          	auipc	ra,0x0
    80204d4a:	f72080e7          	jalr	-142(ra) # 80204cb8 <_Z9tf_parentPKcS0_i>
    80204d4e:	b775                	j	80204cfa <_Z9tf_parentPKcS0_i+0x42>

0000000080204d50 <_Z9tf_createPKc>:
int tf_create(const char *filename) {
    80204d50:	715d                	addi	sp,sp,-80
    80204d52:	e486                	sd	ra,72(sp)
    80204d54:	e0a2                	sd	s0,64(sp)
    80204d56:	fc26                	sd	s1,56(sp)
    80204d58:	f84a                	sd	s2,48(sp)
    80204d5a:	f44e                	sd	s3,40(sp)
    80204d5c:	0880                	addi	s0,sp,80
    80204d5e:	892a                	mv	s2,a0
  TFFile *fp = tf_parent(filename, "r", false);
    80204d60:	4601                	li	a2,0
    80204d62:	00006597          	auipc	a1,0x6
    80204d66:	b3e58593          	addi	a1,a1,-1218 # 8020a8a0 <_ZL6digits+0x598>
    80204d6a:	00000097          	auipc	ra,0x0
    80204d6e:	f4e080e7          	jalr	-178(ra) # 80204cb8 <_Z9tf_parentPKcS0_i>
  if (!fp) return 1;
    80204d72:	12050363          	beqz	a0,80204e98 <_Z9tf_createPKc+0x148>
  tf_fclose(fp);
    80204d76:	00000097          	auipc	ra,0x0
    80204d7a:	cee080e7          	jalr	-786(ra) # 80204a64 <_Z9tf_fcloseP13struct_TFFILE>
  fp = tf_parent(filename, "r+", false);
    80204d7e:	4601                	li	a2,0
    80204d80:	00006597          	auipc	a1,0x6
    80204d84:	b1858593          	addi	a1,a1,-1256 # 8020a898 <_ZL6digits+0x590>
    80204d88:	854a                	mv	a0,s2
    80204d8a:	00000097          	auipc	ra,0x0
    80204d8e:	f2e080e7          	jalr	-210(ra) # 80204cb8 <_Z9tf_parentPKcS0_i>
    80204d92:	84aa                	mv	s1,a0
    tf_fread((char *)&entry, sizeof(FatFileEntry), fp);
    80204d94:	4681                	li	a3,0
    80204d96:	8626                	mv	a2,s1
    80204d98:	02000593          	li	a1,32
    80204d9c:	fb040513          	addi	a0,s0,-80
    80204da0:	fffff097          	auipc	ra,0xfffff
    80204da4:	412080e7          	jalr	1042(ra) # 802041b2 <_Z8tf_freadPciP13struct_TFFILEb>
  } while (entry.msdos.filename[0] != '\x00');
    80204da8:	fb044783          	lbu	a5,-80(s0)
    80204dac:	f7e5                	bnez	a5,80204d94 <_Z9tf_createPKc+0x44>
  tf_fseek(fp, -sizeof(FatFileEntry), fp->pos);
    80204dae:	0144e603          	lwu	a2,20(s1)
    80204db2:	5581                	li	a1,-32
    80204db4:	8526                	mv	a0,s1
    80204db6:	fffff097          	auipc	ra,0xfffff
    80204dba:	3d2080e7          	jalr	978(ra) # 80204188 <_Z8tf_fseekP13struct_TFFILEml>
  cluster = tf_find_free_cluster();
    80204dbe:	fffff097          	auipc	ra,0xfffff
    80204dc2:	1f4080e7          	jalr	500(ra) # 80203fb2 <_Z20tf_find_free_clusterv>
    80204dc6:	0005099b          	sext.w	s3,a0
  tf_set_fat_entry(cluster, TF_MARK_EOC32);  // Marks the new cluster as the last one (but no longer free)
    80204dca:	100005b7          	lui	a1,0x10000
    80204dce:	15fd                	addi	a1,a1,-1
    80204dd0:	854e                	mv	a0,s3
    80204dd2:	fffff097          	auipc	ra,0xfffff
    80204dd6:	bfa080e7          	jalr	-1030(ra) # 802039cc <_Z16tf_set_fat_entryjj>
  entry.msdos.attributes = 0;
    80204dda:	fa040da3          	sb	zero,-69(s0)
  entry.msdos.creationTimeMs = 0x25;
    80204dde:	02500793          	li	a5,37
    80204de2:	faf40ea3          	sb	a5,-67(s0)
  entry.msdos.creationTime = 0x7e3c;
    80204de6:	7761                	lui	a4,0xffff8
    80204de8:	e3c74713          	xori	a4,a4,-452
    80204dec:	fae41f23          	sh	a4,-66(s0)
  entry.msdos.creationDate = 0x4262;
    80204df0:	6791                	lui	a5,0x4
    80204df2:	2627879b          	addiw	a5,a5,610
    80204df6:	fcf41023          	sh	a5,-64(s0)
  entry.msdos.lastAccessTime = 0x4262;
    80204dfa:	fcf41123          	sh	a5,-62(s0)
  entry.msdos.eaIndex = (cluster >> 16) & 0xffff;
    80204dfe:	0109d69b          	srliw	a3,s3,0x10
    80204e02:	fcd41223          	sh	a3,-60(s0)
  entry.msdos.modifiedTime = 0x7e3c;
    80204e06:	fce41323          	sh	a4,-58(s0)
  entry.msdos.modifiedDate = 0x4262;
    80204e0a:	fcf41423          	sh	a5,-56(s0)
  entry.msdos.firstCluster = cluster & 0xffff;
    80204e0e:	fd341523          	sh	s3,-54(s0)
  entry.msdos.fileSize = 0;
    80204e12:	fc042623          	sw	zero,-52(s0)
  temp = strrchr(filename, '/') + 1;
    80204e16:	02f00593          	li	a1,47
    80204e1a:	854a                	mv	a0,s2
    80204e1c:	ffffc097          	auipc	ra,0xffffc
    80204e20:	f7e080e7          	jalr	-130(ra) # 80200d9a <_Z7strrchrPKcc>
    80204e24:	00150913          	addi	s2,a0,1
  tf_choose_sfn(entry.msdos.filename, temp, fp);
    80204e28:	8626                	mv	a2,s1
    80204e2a:	85ca                	mv	a1,s2
    80204e2c:	fb040513          	addi	a0,s0,-80
    80204e30:	fffff097          	auipc	ra,0xfffff
    80204e34:	6f0080e7          	jalr	1776(ra) # 80204520 <_Z13tf_choose_sfnPcS_P13struct_TFFILE>
  tf_place_lfn_chain(fp, temp, entry.msdos.filename);
    80204e38:	fb040613          	addi	a2,s0,-80
    80204e3c:	85ca                	mv	a1,s2
    80204e3e:	8526                	mv	a0,s1
    80204e40:	00000097          	auipc	ra,0x0
    80204e44:	a50080e7          	jalr	-1456(ra) # 80204890 <_Z18tf_place_lfn_chainP13struct_TFFILEPcS1_>
  tf_fwrite((char *)&entry, sizeof(FatFileEntry), fp);
    80204e48:	8626                	mv	a2,s1
    80204e4a:	02000593          	li	a1,32
    80204e4e:	fb040513          	addi	a0,s0,-80
    80204e52:	00000097          	auipc	ra,0x0
    80204e56:	91e080e7          	jalr	-1762(ra) # 80204770 <_Z9tf_fwritePKciP13struct_TFFILE>
  memset(&entry, 0, sizeof(FatFileEntry));
    80204e5a:	02000613          	li	a2,32
    80204e5e:	4581                	li	a1,0
    80204e60:	fb040513          	addi	a0,s0,-80
    80204e64:	ffffc097          	auipc	ra,0xffffc
    80204e68:	cf8080e7          	jalr	-776(ra) # 80200b5c <_Z6memsetPvij>
  tf_fwrite((char *)&entry, sizeof(FatFileEntry), fp);
    80204e6c:	8626                	mv	a2,s1
    80204e6e:	02000593          	li	a1,32
    80204e72:	fb040513          	addi	a0,s0,-80
    80204e76:	00000097          	auipc	ra,0x0
    80204e7a:	8fa080e7          	jalr	-1798(ra) # 80204770 <_Z9tf_fwritePKciP13struct_TFFILE>
  tf_fclose(fp);
    80204e7e:	8526                	mv	a0,s1
    80204e80:	00000097          	auipc	ra,0x0
    80204e84:	be4080e7          	jalr	-1052(ra) # 80204a64 <_Z9tf_fcloseP13struct_TFFILE>
  return 0;
    80204e88:	4501                	li	a0,0
}
    80204e8a:	60a6                	ld	ra,72(sp)
    80204e8c:	6406                	ld	s0,64(sp)
    80204e8e:	74e2                	ld	s1,56(sp)
    80204e90:	7942                	ld	s2,48(sp)
    80204e92:	79a2                	ld	s3,40(sp)
    80204e94:	6161                	addi	sp,sp,80
    80204e96:	8082                	ret
  if (!fp) return 1;
    80204e98:	4505                	li	a0,1
    80204e9a:	bfc5                	j	80204e8a <_Z9tf_createPKc+0x13a>

0000000080204e9c <_ZN15Fat32FileSystem5touchEPKc>:
size_t Fat32FileSystem::touch(const char *filepath) {
    80204e9c:	1141                	addi	sp,sp,-16
    80204e9e:	e406                	sd	ra,8(sp)
    80204ea0:	e022                	sd	s0,0(sp)
    80204ea2:	0800                	addi	s0,sp,16
  tf_create((char *)filepath);
    80204ea4:	852e                	mv	a0,a1
    80204ea6:	00000097          	auipc	ra,0x0
    80204eaa:	eaa080e7          	jalr	-342(ra) # 80204d50 <_Z9tf_createPKc>
}
    80204eae:	4501                	li	a0,0
    80204eb0:	60a2                	ld	ra,8(sp)
    80204eb2:	6402                	ld	s0,0(sp)
    80204eb4:	0141                	addi	sp,sp,16
    80204eb6:	8082                	ret

0000000080204eb8 <_Z8tf_fopenPKcS0_>:
TFFile *tf_fopen(const char *filename, const char *mode) {
    80204eb8:	1101                	addi	sp,sp,-32
    80204eba:	ec06                	sd	ra,24(sp)
    80204ebc:	e822                	sd	s0,16(sp)
    80204ebe:	e426                	sd	s1,8(sp)
    80204ec0:	e04a                	sd	s2,0(sp)
    80204ec2:	1000                	addi	s0,sp,32
    80204ec4:	84aa                	mv	s1,a0
    80204ec6:	892e                	mv	s2,a1
  fp = tf_fnopen(filename, mode, strlen(filename));
    80204ec8:	ffffc097          	auipc	ra,0xffffc
    80204ecc:	e84080e7          	jalr	-380(ra) # 80200d4c <_Z6strlenPKc>
    80204ed0:	862a                	mv	a2,a0
    80204ed2:	85ca                	mv	a1,s2
    80204ed4:	8526                	mv	a0,s1
    80204ed6:	fffff097          	auipc	ra,0xfffff
    80204eda:	70e080e7          	jalr	1806(ra) # 802045e4 <_Z9tf_fnopenPKcS0_i>
  if (fp == NULL) {
    80204ede:	c519                	beqz	a0,80204eec <_Z8tf_fopenPKcS0_+0x34>
}
    80204ee0:	60e2                	ld	ra,24(sp)
    80204ee2:	6442                	ld	s0,16(sp)
    80204ee4:	64a2                	ld	s1,8(sp)
    80204ee6:	6902                	ld	s2,0(sp)
    80204ee8:	6105                	addi	sp,sp,32
    80204eea:	8082                	ret
    if (strchr(mode, '+') || strchr(mode, 'w') || strchr(mode, 'a')) {
    80204eec:	02b00593          	li	a1,43
    80204ef0:	854a                	mv	a0,s2
    80204ef2:	ffffc097          	auipc	ra,0xffffc
    80204ef6:	e84080e7          	jalr	-380(ra) # 80200d76 <_Z6strchrPKcc>
    80204efa:	c11d                	beqz	a0,80204f20 <_Z8tf_fopenPKcS0_+0x68>
      tf_create(filename);
    80204efc:	8526                	mv	a0,s1
    80204efe:	00000097          	auipc	ra,0x0
    80204f02:	e52080e7          	jalr	-430(ra) # 80204d50 <_Z9tf_createPKc>
    return tf_fnopen(filename, mode, strlen(filename));
    80204f06:	8526                	mv	a0,s1
    80204f08:	ffffc097          	auipc	ra,0xffffc
    80204f0c:	e44080e7          	jalr	-444(ra) # 80200d4c <_Z6strlenPKc>
    80204f10:	862a                	mv	a2,a0
    80204f12:	85ca                	mv	a1,s2
    80204f14:	8526                	mv	a0,s1
    80204f16:	fffff097          	auipc	ra,0xfffff
    80204f1a:	6ce080e7          	jalr	1742(ra) # 802045e4 <_Z9tf_fnopenPKcS0_i>
    80204f1e:	b7c9                	j	80204ee0 <_Z8tf_fopenPKcS0_+0x28>
    if (strchr(mode, '+') || strchr(mode, 'w') || strchr(mode, 'a')) {
    80204f20:	07700593          	li	a1,119
    80204f24:	854a                	mv	a0,s2
    80204f26:	ffffc097          	auipc	ra,0xffffc
    80204f2a:	e50080e7          	jalr	-432(ra) # 80200d76 <_Z6strchrPKcc>
    80204f2e:	f579                	bnez	a0,80204efc <_Z8tf_fopenPKcS0_+0x44>
    80204f30:	06100593          	li	a1,97
    80204f34:	854a                	mv	a0,s2
    80204f36:	ffffc097          	auipc	ra,0xffffc
    80204f3a:	e40080e7          	jalr	-448(ra) # 80200d76 <_Z6strchrPKcc>
    80204f3e:	fd5d                	bnez	a0,80204efc <_Z8tf_fopenPKcS0_+0x44>
    80204f40:	b7d9                	j	80204f06 <_Z8tf_fopenPKcS0_+0x4e>

0000000080204f42 <_ZN15Fat32FileSystem2lsEPKcPcb>:
int Fat32FileSystem::ls(const char *filepath, char *contents, bool user) {
    80204f42:	7119                	addi	sp,sp,-128
    80204f44:	fc86                	sd	ra,120(sp)
    80204f46:	f8a2                	sd	s0,112(sp)
    80204f48:	f4a6                	sd	s1,104(sp)
    80204f4a:	f0ca                	sd	s2,96(sp)
    80204f4c:	ecce                	sd	s3,88(sp)
    80204f4e:	e8d2                	sd	s4,80(sp)
    80204f50:	e4d6                	sd	s5,72(sp)
    80204f52:	e0da                	sd	s6,64(sp)
    80204f54:	0100                	addi	s0,sp,128
    80204f56:	84ae                	mv	s1,a1
    80204f58:	89b2                	mv	s3,a2
    80204f5a:	8a36                	mv	s4,a3
    80204f5c:	00006717          	auipc	a4,0x6
    80204f60:	97c70713          	addi	a4,a4,-1668 # 8020a8d8 <_ZL6digits+0x5d0>
    80204f64:	06700693          	li	a3,103
    80204f68:	00006617          	auipc	a2,0x6
    80204f6c:	8f860613          	addi	a2,a2,-1800 # 8020a860 <_ZL6digits+0x558>
    80204f70:	00005597          	auipc	a1,0x5
    80204f74:	20858593          	addi	a1,a1,520 # 8020a178 <rodata_start+0x178>
    80204f78:	00005517          	auipc	a0,0x5
    80204f7c:	20850513          	addi	a0,a0,520 # 8020a180 <rodata_start+0x180>
    80204f80:	ffffc097          	auipc	ra,0xffffc
    80204f84:	8d4080e7          	jalr	-1836(ra) # 80200854 <_Z6printfPKcz>
  LOG_DEBUG("fat32 ls");
    80204f88:	00006517          	auipc	a0,0x6
    80204f8c:	95850513          	addi	a0,a0,-1704 # 8020a8e0 <_ZL6digits+0x5d8>
    80204f90:	ffffc097          	auipc	ra,0xffffc
    80204f94:	8c4080e7          	jalr	-1852(ra) # 80200854 <_Z6printfPKcz>
    80204f98:	00005517          	auipc	a0,0x5
    80204f9c:	10850513          	addi	a0,a0,264 # 8020a0a0 <rodata_start+0xa0>
    80204fa0:	ffffc097          	auipc	ra,0xffffc
    80204fa4:	8b4080e7          	jalr	-1868(ra) # 80200854 <_Z6printfPKcz>
  TFFile *fp = tf_fopen(filepath, "r");
    80204fa8:	00006597          	auipc	a1,0x6
    80204fac:	8f858593          	addi	a1,a1,-1800 # 8020a8a0 <_ZL6digits+0x598>
    80204fb0:	8526                	mv	a0,s1
    80204fb2:	00000097          	auipc	ra,0x0
    80204fb6:	f06080e7          	jalr	-250(ra) # 80204eb8 <_Z8tf_fopenPKcS0_>
  if (fp == NULL || (fp->attributes & TF_ATTR_DIRECTORY) == 0) {
    80204fba:	c951                	beqz	a0,8020504e <_ZN15Fat32FileSystem2lsEPKcPcb+0x10c>
    80204fbc:	84aa                	mv	s1,a0
    80204fbe:	01954783          	lbu	a5,25(a0)
    80204fc2:	8bc1                	andi	a5,a5,16
    80204fc4:	c7c9                	beqz	a5,8020504e <_ZN15Fat32FileSystem2lsEPKcPcb+0x10c>
    if (entry.msdos.attributes != TF_ATTR_LONG_NAME) {
    80204fc6:	493d                	li	s2,15
        dt.d_type = DT_FIFO;
    80204fc8:	4b05                	li	s6,1
        dt.d_type = DT_DIR;
    80204fca:	4a91                	li	s5,4
  while (tf_fread((char *)&entry, sizeof(FatFileEntry), fp) == sizeof(FatFileEntry)) {
    80204fcc:	4681                	li	a3,0
    80204fce:	8626                	mv	a2,s1
    80204fd0:	02000593          	li	a1,32
    80204fd4:	fa040513          	addi	a0,s0,-96
    80204fd8:	fffff097          	auipc	ra,0xfffff
    80204fdc:	1da080e7          	jalr	474(ra) # 802041b2 <_Z8tf_freadPciP13struct_TFFILEb>
    80204fe0:	02000793          	li	a5,32
    80204fe4:	06f51563          	bne	a0,a5,8020504e <_ZN15Fat32FileSystem2lsEPKcPcb+0x10c>
    if (entry.msdos.filename[0] == 0x00) { // 结束
    80204fe8:	fa044783          	lbu	a5,-96(s0)
    80204fec:	c3ad                	beqz	a5,8020504e <_ZN15Fat32FileSystem2lsEPKcPcb+0x10c>
    if (entry.msdos.attributes != TF_ATTR_LONG_NAME) {
    80204fee:	fab44783          	lbu	a5,-85(s0)
    80204ff2:	fd278de3          	beq	a5,s2,80204fcc <_ZN15Fat32FileSystem2lsEPKcPcb+0x8a>
      dt.d_ino = entry.msdos.firstCluster;
    80204ff6:	fba45783          	lhu	a5,-70(s0)
    80204ffa:	f8f43423          	sd	a5,-120(s0)
      if (fp->attributes & TF_ATTR_DIRECTORY) {
    80204ffe:	0194c783          	lbu	a5,25(s1)
    80205002:	8bc1                	andi	a5,a5,16
    80205004:	c3b1                	beqz	a5,80205048 <_ZN15Fat32FileSystem2lsEPKcPcb+0x106>
        dt.d_type = DT_DIR;
    80205006:	f9540d23          	sb	s5,-102(s0)
      int n = copysfn(entry.msdos.filename, dirent->d_name, user);
    8020500a:	8652                	mv	a2,s4
    8020500c:	01398593          	addi	a1,s3,19
    80205010:	fa040513          	addi	a0,s0,-96
    80205014:	ffffe097          	auipc	ra,0xffffe
    80205018:	6cc080e7          	jalr	1740(ra) # 802036e0 <_Z7copysfnPcS_b>
      dt.d_reclen = DIENT_BASE_LEN + n;  // n为短文件目录项的文件名长度
    8020501c:	0135079b          	addiw	a5,a0,19
    80205020:	17c2                	slli	a5,a5,0x30
    80205022:	93c1                	srli	a5,a5,0x30
    80205024:	f8f41c23          	sh	a5,-104(s0)
      dt.d_off = reinterpret_cast<uint64_t>(contents) + dt.d_reclen;
    80205028:	97ce                	add	a5,a5,s3
    8020502a:	f8f43823          	sd	a5,-112(s0)
      either_copyout(user, (uint64_t)contents, (void *)&dt, DIENT_BASE_LEN);
    8020502e:	46cd                	li	a3,19
    80205030:	f8840613          	addi	a2,s0,-120
    80205034:	85ce                	mv	a1,s3
    80205036:	8552                	mv	a0,s4
    80205038:	ffffd097          	auipc	ra,0xffffd
    8020503c:	376080e7          	jalr	886(ra) # 802023ae <_Z14either_copyoutbmPvi>
      contents += dt.d_reclen;
    80205040:	f9845783          	lhu	a5,-104(s0)
    80205044:	99be                	add	s3,s3,a5
      cnt++;
    80205046:	b759                	j	80204fcc <_ZN15Fat32FileSystem2lsEPKcPcb+0x8a>
        dt.d_type = DT_FIFO;
    80205048:	f9640d23          	sb	s6,-102(s0)
    8020504c:	bf7d                	j	8020500a <_ZN15Fat32FileSystem2lsEPKcPcb+0xc8>
}
    8020504e:	557d                	li	a0,-1
    80205050:	70e6                	ld	ra,120(sp)
    80205052:	7446                	ld	s0,112(sp)
    80205054:	74a6                	ld	s1,104(sp)
    80205056:	7906                	ld	s2,96(sp)
    80205058:	69e6                	ld	s3,88(sp)
    8020505a:	6a46                	ld	s4,80(sp)
    8020505c:	6aa6                	ld	s5,72(sp)
    8020505e:	6b06                	ld	s6,64(sp)
    80205060:	6109                	addi	sp,sp,128
    80205062:	8082                	ret

0000000080205064 <_Z10tf_listdirPcP19struct_FatFileEntryPP13struct_TFFILE>:
int tf_listdir(char *filename, FatFileEntry *entry, TFFile **fp) {
    80205064:	7139                	addi	sp,sp,-64
    80205066:	fc06                	sd	ra,56(sp)
    80205068:	f822                	sd	s0,48(sp)
    8020506a:	f426                	sd	s1,40(sp)
    8020506c:	f04a                	sd	s2,32(sp)
    8020506e:	ec4e                	sd	s3,24(sp)
    80205070:	e852                	sd	s4,16(sp)
    80205072:	e456                	sd	s5,8(sp)
    80205074:	0080                	addi	s0,sp,64
    80205076:	892e                	mv	s2,a1
    80205078:	84b2                	mv	s1,a2
  if (*fp == NULL) *fp = tf_parent(filename, "r", false);
    8020507a:	621c                	ld	a5,0(a2)
    8020507c:	c3a1                	beqz	a5,802050bc <_Z10tf_listdirPcP19struct_FatFileEntryPP13struct_TFFILE+0x58>
    switch (((char *)entry)[0]) {
    8020507e:	4995                	li	s3,5
    80205080:	02e00a93          	li	s5,46
    80205084:	0e500a13          	li	s4,229
    tf_fread((char *)entry, sizeof(FatFileEntry), *fp);
    80205088:	4681                	li	a3,0
    8020508a:	6090                	ld	a2,0(s1)
    8020508c:	02000593          	li	a1,32
    80205090:	854a                	mv	a0,s2
    80205092:	fffff097          	auipc	ra,0xfffff
    80205096:	120080e7          	jalr	288(ra) # 802041b2 <_Z8tf_freadPciP13struct_TFFILEb>
    switch (((char *)entry)[0]) {
    8020509a:	00094783          	lbu	a5,0(s2)
    8020509e:	ff3785e3          	beq	a5,s3,80205088 <_Z10tf_listdirPcP19struct_FatFileEntryPP13struct_TFFILE+0x24>
    802050a2:	02f9eb63          	bltu	s3,a5,802050d8 <_Z10tf_listdirPcP19struct_FatFileEntryPP13struct_TFFILE+0x74>
    802050a6:	4505                	li	a0,1
    802050a8:	ef8d                	bnez	a5,802050e2 <_Z10tf_listdirPcP19struct_FatFileEntryPP13struct_TFFILE+0x7e>
        tf_fclose(*fp);
    802050aa:	6088                	ld	a0,0(s1)
    802050ac:	00000097          	auipc	ra,0x0
    802050b0:	9b8080e7          	jalr	-1608(ra) # 80204a64 <_Z9tf_fcloseP13struct_TFFILE>
        *fp = NULL;
    802050b4:	0004b023          	sd	zero,0(s1)
        return 0;
    802050b8:	4501                	li	a0,0
    802050ba:	a025                	j	802050e2 <_Z10tf_listdirPcP19struct_FatFileEntryPP13struct_TFFILE+0x7e>
  if (*fp == NULL) *fp = tf_parent(filename, "r", false);
    802050bc:	4601                	li	a2,0
    802050be:	00005597          	auipc	a1,0x5
    802050c2:	7e258593          	addi	a1,a1,2018 # 8020a8a0 <_ZL6digits+0x598>
    802050c6:	00000097          	auipc	ra,0x0
    802050ca:	bf2080e7          	jalr	-1038(ra) # 80204cb8 <_Z9tf_parentPKcS0_i>
    802050ce:	87aa                	mv	a5,a0
    802050d0:	e088                	sd	a0,0(s1)
  if (!*fp) return 1;
    802050d2:	4505                	li	a0,1
    802050d4:	c799                	beqz	a5,802050e2 <_Z10tf_listdirPcP19struct_FatFileEntryPP13struct_TFFILE+0x7e>
    802050d6:	b765                	j	8020507e <_Z10tf_listdirPcP19struct_FatFileEntryPP13struct_TFFILE+0x1a>
    switch (((char *)entry)[0]) {
    802050d8:	fb5788e3          	beq	a5,s5,80205088 <_Z10tf_listdirPcP19struct_FatFileEntryPP13struct_TFFILE+0x24>
    802050dc:	fb4786e3          	beq	a5,s4,80205088 <_Z10tf_listdirPcP19struct_FatFileEntryPP13struct_TFFILE+0x24>
    802050e0:	4505                	li	a0,1
}
    802050e2:	70e2                	ld	ra,56(sp)
    802050e4:	7442                	ld	s0,48(sp)
    802050e6:	74a2                	ld	s1,40(sp)
    802050e8:	7902                	ld	s2,32(sp)
    802050ea:	69e2                	ld	s3,24(sp)
    802050ec:	6a42                	ld	s4,16(sp)
    802050ee:	6aa2                	ld	s5,8(sp)
    802050f0:	6121                	addi	sp,sp,64
    802050f2:	8082                	ret

00000000802050f4 <_ZN15Fat32FileSystem4openEPKcmP4file>:
int Fat32FileSystem::open(const char *filePath, uint64_t flags, struct file *fp) {
    802050f4:	1101                	addi	sp,sp,-32
    802050f6:	ec06                	sd	ra,24(sp)
    802050f8:	e822                	sd	s0,16(sp)
    802050fa:	e426                	sd	s1,8(sp)
    802050fc:	1000                	addi	s0,sp,32
    802050fe:	852e                	mv	a0,a1
    80205100:	84b6                	mv	s1,a3
  if (flags & O_CREATE) {
    80205102:	20067613          	andi	a2,a2,512
    80205106:	c221                	beqz	a2,80205146 <_ZN15Fat32FileSystem4openEPKcmP4file+0x52>
    tf = tf_fopen(filePath, "w");
    80205108:	00005597          	auipc	a1,0x5
    8020510c:	7a058593          	addi	a1,a1,1952 # 8020a8a8 <_ZL6digits+0x5a0>
    80205110:	00000097          	auipc	ra,0x0
    80205114:	da8080e7          	jalr	-600(ra) # 80204eb8 <_Z8tf_fopenPKcS0_>
  if (tf == NULL) {
    80205118:	c139                	beqz	a0,8020515e <_ZN15Fat32FileSystem4openEPKcmP4file+0x6a>
  fp->size = tf->size;
    8020511a:	01c56783          	lwu	a5,28(a0)
    8020511e:	e4bc                	sd	a5,72(s1)
  fp->type = fp->FD_ENTRY;
    80205120:	4789                	li	a5,2
    80205122:	ccbc                	sw	a5,88(s1)
  if (tf->attributes & TF_ATTR_DIRECTORY) {
    80205124:	01954783          	lbu	a5,25(a0)
    80205128:	8bc1                	andi	a5,a5,16
    8020512a:	c79d                	beqz	a5,80205158 <_ZN15Fat32FileSystem4openEPKcmP4file+0x64>
    fp->directory = true;
    8020512c:	4785                	li	a5,1
    8020512e:	04f48023          	sb	a5,64(s1)
  tf_fclose(tf);
    80205132:	00000097          	auipc	ra,0x0
    80205136:	932080e7          	jalr	-1742(ra) # 80204a64 <_Z9tf_fcloseP13struct_TFFILE>
  return 0;
    8020513a:	4501                	li	a0,0
}
    8020513c:	60e2                	ld	ra,24(sp)
    8020513e:	6442                	ld	s0,16(sp)
    80205140:	64a2                	ld	s1,8(sp)
    80205142:	6105                	addi	sp,sp,32
    80205144:	8082                	ret
    tf = tf_fopen(filePath, "r");
    80205146:	00005597          	auipc	a1,0x5
    8020514a:	75a58593          	addi	a1,a1,1882 # 8020a8a0 <_ZL6digits+0x598>
    8020514e:	00000097          	auipc	ra,0x0
    80205152:	d6a080e7          	jalr	-662(ra) # 80204eb8 <_Z8tf_fopenPKcS0_>
    80205156:	b7c9                	j	80205118 <_ZN15Fat32FileSystem4openEPKcmP4file+0x24>
    fp->directory = false;
    80205158:	04048023          	sb	zero,64(s1)
    8020515c:	bfd9                	j	80205132 <_ZN15Fat32FileSystem4openEPKcmP4file+0x3e>
    return -1;
    8020515e:	557d                	li	a0,-1
    80205160:	bff1                	j	8020513c <_ZN15Fat32FileSystem4openEPKcmP4file+0x48>

0000000080205162 <_ZN15Fat32FileSystem4readEPKcbPcii>:
size_t Fat32FileSystem::read(const char *path, bool user, char *buf, int offset, int n) {
    80205162:	7139                	addi	sp,sp,-64
    80205164:	fc06                	sd	ra,56(sp)
    80205166:	f822                	sd	s0,48(sp)
    80205168:	f426                	sd	s1,40(sp)
    8020516a:	f04a                	sd	s2,32(sp)
    8020516c:	ec4e                	sd	s3,24(sp)
    8020516e:	e852                	sd	s4,16(sp)
    80205170:	e456                	sd	s5,8(sp)
    80205172:	0080                	addi	s0,sp,64
    80205174:	852e                	mv	a0,a1
    80205176:	8a32                	mv	s4,a2
    80205178:	8936                	mv	s2,a3
    8020517a:	8aba                	mv	s5,a4
    8020517c:	89be                	mv	s3,a5
  TFFile *fp = tf_fopen(path, "r");
    8020517e:	00005597          	auipc	a1,0x5
    80205182:	72258593          	addi	a1,a1,1826 # 8020a8a0 <_ZL6digits+0x598>
    80205186:	00000097          	auipc	ra,0x0
    8020518a:	d32080e7          	jalr	-718(ra) # 80204eb8 <_Z8tf_fopenPKcS0_>
    8020518e:	84aa                	mv	s1,a0
  tf_fseek(fp, 0, offset);
    80205190:	8656                	mv	a2,s5
    80205192:	4581                	li	a1,0
    80205194:	fffff097          	auipc	ra,0xfffff
    80205198:	ff4080e7          	jalr	-12(ra) # 80204188 <_Z8tf_fseekP13struct_TFFILEml>
    8020519c:	00005717          	auipc	a4,0x5
    802051a0:	75470713          	addi	a4,a4,1876 # 8020a8f0 <_ZL6digits+0x5e8>
    802051a4:	02c00693          	li	a3,44
    802051a8:	00005617          	auipc	a2,0x5
    802051ac:	6b860613          	addi	a2,a2,1720 # 8020a860 <_ZL6digits+0x558>
    802051b0:	00005597          	auipc	a1,0x5
    802051b4:	fc858593          	addi	a1,a1,-56 # 8020a178 <rodata_start+0x178>
    802051b8:	00005517          	auipc	a0,0x5
    802051bc:	fc850513          	addi	a0,a0,-56 # 8020a180 <rodata_start+0x180>
    802051c0:	ffffb097          	auipc	ra,0xffffb
    802051c4:	694080e7          	jalr	1684(ra) # 80200854 <_Z6printfPKcz>
  LOG_DEBUG("read");
    802051c8:	00005517          	auipc	a0,0x5
    802051cc:	72850513          	addi	a0,a0,1832 # 8020a8f0 <_ZL6digits+0x5e8>
    802051d0:	ffffb097          	auipc	ra,0xffffb
    802051d4:	684080e7          	jalr	1668(ra) # 80200854 <_Z6printfPKcz>
    802051d8:	00005517          	auipc	a0,0x5
    802051dc:	ec850513          	addi	a0,a0,-312 # 8020a0a0 <rodata_start+0xa0>
    802051e0:	ffffb097          	auipc	ra,0xffffb
    802051e4:	674080e7          	jalr	1652(ra) # 80200854 <_Z6printfPKcz>
  int x = tf_fread(buf, n, fp, user);
    802051e8:	86d2                	mv	a3,s4
    802051ea:	8626                	mv	a2,s1
    802051ec:	85ce                	mv	a1,s3
    802051ee:	854a                	mv	a0,s2
    802051f0:	fffff097          	auipc	ra,0xfffff
    802051f4:	fc2080e7          	jalr	-62(ra) # 802041b2 <_Z8tf_freadPciP13struct_TFFILEb>
    802051f8:	892a                	mv	s2,a0
  tf_fclose(fp);
    802051fa:	8526                	mv	a0,s1
    802051fc:	00000097          	auipc	ra,0x0
    80205200:	868080e7          	jalr	-1944(ra) # 80204a64 <_Z9tf_fcloseP13struct_TFFILE>
}
    80205204:	854a                	mv	a0,s2
    80205206:	70e2                	ld	ra,56(sp)
    80205208:	7442                	ld	s0,48(sp)
    8020520a:	74a2                	ld	s1,40(sp)
    8020520c:	7902                	ld	s2,32(sp)
    8020520e:	69e2                	ld	s3,24(sp)
    80205210:	6a42                	ld	s4,16(sp)
    80205212:	6aa2                	ld	s5,8(sp)
    80205214:	6121                	addi	sp,sp,64
    80205216:	8082                	ret

0000000080205218 <_ZN15Fat32FileSystem8get_fileEPKcP4file>:
int Fat32FileSystem::get_file(const char *filepath, struct file *fp) {
    80205218:	1101                	addi	sp,sp,-32
    8020521a:	ec06                	sd	ra,24(sp)
    8020521c:	e822                	sd	s0,16(sp)
    8020521e:	e426                	sd	s1,8(sp)
    80205220:	1000                	addi	s0,sp,32
    80205222:	852e                	mv	a0,a1
    80205224:	84b2                	mv	s1,a2
  TFFile *tf = tf_fopen(filepath, "r");
    80205226:	00005597          	auipc	a1,0x5
    8020522a:	67a58593          	addi	a1,a1,1658 # 8020a8a0 <_ZL6digits+0x598>
    8020522e:	00000097          	auipc	ra,0x0
    80205232:	c8a080e7          	jalr	-886(ra) # 80204eb8 <_Z8tf_fopenPKcS0_>
  if (tf == NULL) {
    80205236:	c105                	beqz	a0,80205256 <_ZN15Fat32FileSystem8get_fileEPKcP4file+0x3e>
  fp->size = tf->size;
    80205238:	01c56783          	lwu	a5,28(a0)
    8020523c:	e4bc                	sd	a5,72(s1)
  fp->type = fp->FD_ENTRY;
    8020523e:	4789                	li	a5,2
    80205240:	ccbc                	sw	a5,88(s1)
  tf_fclose(tf);
    80205242:	00000097          	auipc	ra,0x0
    80205246:	822080e7          	jalr	-2014(ra) # 80204a64 <_Z9tf_fcloseP13struct_TFFILE>
  return NULL;
    8020524a:	4501                	li	a0,0
}
    8020524c:	60e2                	ld	ra,24(sp)
    8020524e:	6442                	ld	s0,16(sp)
    80205250:	64a2                	ld	s1,8(sp)
    80205252:	6105                	addi	sp,sp,32
    80205254:	8082                	ret
    return -1;
    80205256:	557d                	li	a0,-1
    80205258:	bfd5                	j	8020524c <_ZN15Fat32FileSystem8get_fileEPKcP4file+0x34>

000000008020525a <_Z7tf_initv>:
int tf_init() {
    8020525a:	7139                	addi	sp,sp,-64
    8020525c:	fc06                	sd	ra,56(sp)
    8020525e:	f822                	sd	s0,48(sp)
    80205260:	f426                	sd	s1,40(sp)
    80205262:	f04a                	sd	s2,32(sp)
    80205264:	0080                	addi	s0,sp,64
  tf_info.currentSector = -1;
    80205266:	0008a497          	auipc	s1,0x8a
    8020526a:	d9a48493          	addi	s1,s1,-614 # 8028f000 <tf_info>
    8020526e:	57fd                	li	a5,-1
    80205270:	c89c                	sw	a5,16(s1)
  tf_info.sectorFlags = 0;
    80205272:	00048a23          	sb	zero,20(s1)
  tf_fetch(0);
    80205276:	4501                	li	a0,0
    80205278:	ffffe097          	auipc	ra,0xffffe
    8020527c:	6b0080e7          	jalr	1712(ra) # 80203928 <_Z8tf_fetchj>
  if (!(bpb->BS_JumpBoot[0] == 0xEB && bpb->BS_JumpBoot[2] == 0x90) && !(bpb->BS_JumpBoot[0] == 0xE9)) {
    80205280:	01c4c783          	lbu	a5,28(s1)
    80205284:	0eb00713          	li	a4,235
    80205288:	16e78663          	beq	a5,a4,802053f4 <_Z7tf_initv+0x19a>
    8020528c:	0e900713          	li	a4,233
    80205290:	16e79a63          	bne	a5,a4,80205404 <_Z7tf_initv+0x1aa>
  if (bpb->BytesPerSector != 512) {
    80205294:	0008a717          	auipc	a4,0x8a
    80205298:	d6c70713          	addi	a4,a4,-660 # 8028f000 <tf_info>
    8020529c:	02774683          	lbu	a3,39(a4)
    802052a0:	02874783          	lbu	a5,40(a4)
    802052a4:	07a2                	slli	a5,a5,0x8
    802052a6:	8fd5                	or	a5,a5,a3
    802052a8:	20000713          	li	a4,512
    return TF_ERR_BAD_FS_TYPE;
    802052ac:	4509                	li	a0,2
  if (bpb->BytesPerSector != 512) {
    802052ae:	12e79d63          	bne	a5,a4,802053e8 <_Z7tf_initv+0x18e>
  if (bpb->ReservedSectorCount == 0) {
    802052b2:	0008a597          	auipc	a1,0x8a
    802052b6:	d785d583          	lhu	a1,-648(a1) # 8028f02a <tf_info+0x2a>
    802052ba:	12058763          	beqz	a1,802053e8 <_Z7tf_initv+0x18e>
  if ((bpb->Media != 0xF0) && ((bpb->Media < 0xF8) || (bpb->Media > 0xFF))) {
    802052be:	0008a797          	auipc	a5,0x8a
    802052c2:	d737c783          	lbu	a5,-653(a5) # 8028f031 <tf_info+0x31>
    802052c6:	0f000713          	li	a4,240
    802052ca:	00e78663          	beq	a5,a4,802052d6 <_Z7tf_initv+0x7c>
    802052ce:	0f700713          	li	a4,247
    802052d2:	10f77b63          	bgeu	a4,a5,802053e8 <_Z7tf_initv+0x18e>
  fat_size = (bpb->FATSize16 != 0) ? bpb->FATSize16 : bpb->FSTypeSpecificData.fat32.FATSize;
    802052d6:	0008a717          	auipc	a4,0x8a
    802052da:	d5c75703          	lhu	a4,-676(a4) # 8028f032 <tf_info+0x32>
    802052de:	0007051b          	sext.w	a0,a4
    802052e2:	e709                	bnez	a4,802052ec <_Z7tf_initv+0x92>
    802052e4:	0008a517          	auipc	a0,0x8a
    802052e8:	d5c52503          	lw	a0,-676(a0) # 8028f040 <tf_info+0x40>
  root_dir_sectors = ((bpb->RootEntryCount * 32) + (bpb->BytesPerSector - 1)) /
    802052ec:	0008a697          	auipc	a3,0x8a
    802052f0:	d1468693          	addi	a3,a3,-748 # 8028f000 <tf_info>
    802052f4:	769c                	ld	a5,40(a3)
    802052f6:	0287d713          	srli	a4,a5,0x28
    802052fa:	0107171b          	slliw	a4,a4,0x10
    802052fe:	0107571b          	srliw	a4,a4,0x10
    80205302:	0057171b          	slliw	a4,a4,0x5
    80205306:	1ff7071b          	addiw	a4,a4,511
    8020530a:	4097571b          	sraiw	a4,a4,0x9
  tf_info.totalSectors = (bpb->TotalSectors16 != 0) ? bpb->TotalSectors16 : bpb->TotalSectors32;
    8020530e:	0387d613          	srli	a2,a5,0x38
    80205312:	0306c783          	lbu	a5,48(a3)
    80205316:	07a2                	slli	a5,a5,0x8
    80205318:	8fd1                	or	a5,a5,a2
    8020531a:	12078d63          	beqz	a5,80205454 <_Z7tf_initv+0x1fa>
    8020531e:	2781                	sext.w	a5,a5
    80205320:	0008a617          	auipc	a2,0x8a
    80205324:	ce060613          	addi	a2,a2,-800 # 8028f000 <tf_info>
    80205328:	c61c                	sw	a5,8(a2)
  data_sectors = tf_info.totalSectors - (bpb->ReservedSectorCount + (bpb->NumFATs * fat_size) + root_dir_sectors);
    8020532a:	02c64683          	lbu	a3,44(a2)
    8020532e:	02a686bb          	mulw	a3,a3,a0
    80205332:	9f2d                	addw	a4,a4,a1
    80205334:	9f35                	addw	a4,a4,a3
  tf_info.sectorsPerCluster = bpb->SectorsPerCluster;
    80205336:	02964683          	lbu	a3,41(a2)
    8020533a:	00d600a3          	sb	a3,1(a2)
  tf_info.reservedSectors = bpb->ReservedSectorCount;
    8020533e:	00b61623          	sh	a1,12(a2)
  tf_info.firstDataSector = bpb->ReservedSectorCount + (bpb->NumFATs * fat_size) + root_dir_sectors;
    80205342:	c258                	sw	a4,4(a2)
  data_sectors = tf_info.totalSectors - (bpb->ReservedSectorCount + (bpb->NumFATs * fat_size) + root_dir_sectors);
    80205344:	9f99                	subw	a5,a5,a4
  if (cluster_count < 65525) {
    80205346:	02d7d7bb          	divuw	a5,a5,a3
    8020534a:	6741                	lui	a4,0x10
    8020534c:	1751                	addi	a4,a4,-12
    return TF_ERR_BAD_FS_TYPE;
    8020534e:	4509                	li	a0,2
  if (cluster_count < 65525) {
    80205350:	08f77c63          	bgeu	a4,a5,802053e8 <_Z7tf_initv+0x18e>
    tf_info.type = TF_TYPE_FAT32;
    80205354:	4705                	li	a4,1
    80205356:	00e60023          	sb	a4,0(a2)
  tf_info.rootDirectorySize = 0xffffffff;
    8020535a:	577d                	li	a4,-1
    8020535c:	ce18                	sw	a4,24(a2)
  fp = tf_fopen("/", "r");
    8020535e:	00005597          	auipc	a1,0x5
    80205362:	54258593          	addi	a1,a1,1346 # 8020a8a0 <_ZL6digits+0x598>
    80205366:	00005517          	auipc	a0,0x5
    8020536a:	5da50513          	addi	a0,a0,1498 # 8020a940 <_ZL6digits+0x638>
    8020536e:	00000097          	auipc	ra,0x0
    80205372:	b4a080e7          	jalr	-1206(ra) # 80204eb8 <_Z8tf_fopenPKcS0_>
    80205376:	892a                	mv	s2,a0
  temp = 0;
    80205378:	4481                	li	s1,0
    temp += sizeof(FatFileEntry);
    8020537a:	0204849b          	addiw	s1,s1,32
    tf_fread((char *)&e, sizeof(FatFileEntry), fp);
    8020537e:	4681                	li	a3,0
    80205380:	864a                	mv	a2,s2
    80205382:	02000593          	li	a1,32
    80205386:	fc040513          	addi	a0,s0,-64
    8020538a:	fffff097          	auipc	ra,0xfffff
    8020538e:	e28080e7          	jalr	-472(ra) # 802041b2 <_Z8tf_freadPciP13struct_TFFILEb>
  } while (e.msdos.filename[0] != '\x00');
    80205392:	fc044783          	lbu	a5,-64(s0)
    80205396:	f3f5                	bnez	a5,8020537a <_Z7tf_initv+0x120>
  tf_fclose(fp);
    80205398:	854a                	mv	a0,s2
    8020539a:	fffff097          	auipc	ra,0xfffff
    8020539e:	6ca080e7          	jalr	1738(ra) # 80204a64 <_Z9tf_fcloseP13struct_TFFILE>
  tf_info.rootDirectorySize = temp;
    802053a2:	0008a797          	auipc	a5,0x8a
    802053a6:	c697ab23          	sw	s1,-906(a5) # 8028f018 <tf_info+0x18>
  printf("\r\n[DEBUG-tf_init] Size of root directory: %d bytes", tf_info.rootDirectorySize);
    802053aa:	85a6                	mv	a1,s1
    802053ac:	00005517          	auipc	a0,0x5
    802053b0:	59c50513          	addi	a0,a0,1436 # 8020a948 <_ZL6digits+0x640>
    802053b4:	ffffb097          	auipc	ra,0xffffb
    802053b8:	4a0080e7          	jalr	1184(ra) # 80200854 <_Z6printfPKcz>
  memset(tf_file_handles, 0, sizeof(TFFile) * TF_FILE_HANDLES);
    802053bc:	5a000613          	li	a2,1440
    802053c0:	4581                	li	a1,0
    802053c2:	0008b517          	auipc	a0,0x8b
    802053c6:	c3e50513          	addi	a0,a0,-962 # 80290000 <tf_file_handles>
    802053ca:	ffffb097          	auipc	ra,0xffffb
    802053ce:	792080e7          	jalr	1938(ra) # 80200b5c <_Z6memsetPvij>
  tf_fclose(fp);
    802053d2:	854a                	mv	a0,s2
    802053d4:	fffff097          	auipc	ra,0xfffff
    802053d8:	690080e7          	jalr	1680(ra) # 80204a64 <_Z9tf_fcloseP13struct_TFFILE>
void tf_release_handle(TFFile *fp) { fp->flags &= ~TF_FLAG_OPEN; }
    802053dc:	01894783          	lbu	a5,24(s2)
    802053e0:	9bf5                	andi	a5,a5,-3
    802053e2:	00f90c23          	sb	a5,24(s2)
  return 0;
    802053e6:	4501                	li	a0,0
}
    802053e8:	70e2                	ld	ra,56(sp)
    802053ea:	7442                	ld	s0,48(sp)
    802053ec:	74a2                	ld	s1,40(sp)
    802053ee:	7902                	ld	s2,32(sp)
    802053f0:	6121                	addi	sp,sp,64
    802053f2:	8082                	ret
  if (!(bpb->BS_JumpBoot[0] == 0xEB && bpb->BS_JumpBoot[2] == 0x90) && !(bpb->BS_JumpBoot[0] == 0xE9)) {
    802053f4:	0008a717          	auipc	a4,0x8a
    802053f8:	c2a74703          	lbu	a4,-982(a4) # 8028f01e <tf_info+0x1e>
    802053fc:	09000793          	li	a5,144
    80205400:	e8f70ae3          	beq	a4,a5,80205294 <_Z7tf_initv+0x3a>
    80205404:	00005717          	auipc	a4,0x5
    80205408:	4f470713          	addi	a4,a4,1268 # 8020a8f8 <_ZL6digits+0x5f0>
    8020540c:	15c00693          	li	a3,348
    80205410:	00005617          	auipc	a2,0x5
    80205414:	45060613          	addi	a2,a2,1104 # 8020a860 <_ZL6digits+0x558>
    80205418:	00005597          	auipc	a1,0x5
    8020541c:	d6058593          	addi	a1,a1,-672 # 8020a178 <rodata_start+0x178>
    80205420:	00005517          	auipc	a0,0x5
    80205424:	d6050513          	addi	a0,a0,-672 # 8020a180 <rodata_start+0x180>
    80205428:	ffffb097          	auipc	ra,0xffffb
    8020542c:	42c080e7          	jalr	1068(ra) # 80200854 <_Z6printfPKcz>
    LOG_DEBUG("  tf_init FAILED: stupid jmp instruction isn't exactly right...");
    80205430:	00005517          	auipc	a0,0x5
    80205434:	4d050513          	addi	a0,a0,1232 # 8020a900 <_ZL6digits+0x5f8>
    80205438:	ffffb097          	auipc	ra,0xffffb
    8020543c:	41c080e7          	jalr	1052(ra) # 80200854 <_Z6printfPKcz>
    80205440:	00005517          	auipc	a0,0x5
    80205444:	c6050513          	addi	a0,a0,-928 # 8020a0a0 <rodata_start+0xa0>
    80205448:	ffffb097          	auipc	ra,0xffffb
    8020544c:	40c080e7          	jalr	1036(ra) # 80200854 <_Z6printfPKcz>
    return TF_ERR_BAD_FS_TYPE;
    80205450:	4509                	li	a0,2
    80205452:	bf59                	j	802053e8 <_Z7tf_initv+0x18e>
  tf_info.totalSectors = (bpb->TotalSectors16 != 0) ? bpb->TotalSectors16 : bpb->TotalSectors32;
    80205454:	0008a797          	auipc	a5,0x8a
    80205458:	be87a783          	lw	a5,-1048(a5) # 8028f03c <tf_info+0x3c>
    8020545c:	b5d1                	j	80205320 <_Z7tf_initv+0xc6>

000000008020545e <_ZN15Fat32FileSystem4initEv>:
void Fat32FileSystem::init() {
    8020545e:	1141                	addi	sp,sp,-16
    80205460:	e406                	sd	ra,8(sp)
    80205462:	e022                	sd	s0,0(sp)
    80205464:	0800                	addi	s0,sp,16
    80205466:	00005717          	auipc	a4,0x5
    8020546a:	51a70713          	addi	a4,a4,1306 # 8020a980 <_ZL6digits+0x678>
    8020546e:	46b9                	li	a3,14
    80205470:	00005617          	auipc	a2,0x5
    80205474:	3f060613          	addi	a2,a2,1008 # 8020a860 <_ZL6digits+0x558>
    80205478:	00005597          	auipc	a1,0x5
    8020547c:	d0058593          	addi	a1,a1,-768 # 8020a178 <rodata_start+0x178>
    80205480:	00005517          	auipc	a0,0x5
    80205484:	d0050513          	addi	a0,a0,-768 # 8020a180 <rodata_start+0x180>
    80205488:	ffffb097          	auipc	ra,0xffffb
    8020548c:	3cc080e7          	jalr	972(ra) # 80200854 <_Z6printfPKcz>
  LOG_DEBUG("fat32 init");
    80205490:	00005517          	auipc	a0,0x5
    80205494:	4f850513          	addi	a0,a0,1272 # 8020a988 <_ZL6digits+0x680>
    80205498:	ffffb097          	auipc	ra,0xffffb
    8020549c:	3bc080e7          	jalr	956(ra) # 80200854 <_Z6printfPKcz>
    802054a0:	00005517          	auipc	a0,0x5
    802054a4:	c0050513          	addi	a0,a0,-1024 # 8020a0a0 <rodata_start+0xa0>
    802054a8:	ffffb097          	auipc	ra,0xffffb
    802054ac:	3ac080e7          	jalr	940(ra) # 80200854 <_Z6printfPKcz>
  tf_init();
    802054b0:	00000097          	auipc	ra,0x0
    802054b4:	daa080e7          	jalr	-598(ra) # 8020525a <_Z7tf_initv>
}
    802054b8:	60a2                	ld	ra,8(sp)
    802054ba:	6402                	ld	s0,0(sp)
    802054bc:	0141                	addi	sp,sp,16
    802054be:	8082                	ret

00000000802054c0 <_ZN15Fat32FileSystem5writeEPKcbS1_ii>:
size_t Fat32FileSystem::write(const char *path, bool user, const char *buf, int offset, int n) {
    802054c0:	7179                	addi	sp,sp,-48
    802054c2:	f406                	sd	ra,40(sp)
    802054c4:	f022                	sd	s0,32(sp)
    802054c6:	ec26                	sd	s1,24(sp)
    802054c8:	e84a                	sd	s2,16(sp)
    802054ca:	e44e                	sd	s3,8(sp)
    802054cc:	e052                	sd	s4,0(sp)
    802054ce:	1800                	addi	s0,sp,48
    802054d0:	852e                	mv	a0,a1
    802054d2:	8936                	mv	s2,a3
    802054d4:	8a3a                	mv	s4,a4
    802054d6:	89be                	mv	s3,a5
  TFFile *fp = tf_fopen(path, "+");
    802054d8:	00005597          	auipc	a1,0x5
    802054dc:	4c058593          	addi	a1,a1,1216 # 8020a998 <_ZL6digits+0x690>
    802054e0:	00000097          	auipc	ra,0x0
    802054e4:	9d8080e7          	jalr	-1576(ra) # 80204eb8 <_Z8tf_fopenPKcS0_>
    802054e8:	84aa                	mv	s1,a0
  tf_fseek(fp, 0, offset);
    802054ea:	8652                	mv	a2,s4
    802054ec:	4581                	li	a1,0
    802054ee:	fffff097          	auipc	ra,0xfffff
    802054f2:	c9a080e7          	jalr	-870(ra) # 80204188 <_Z8tf_fseekP13struct_TFFILEml>
  int x = tf_fwrite(buf, n, fp);
    802054f6:	8626                	mv	a2,s1
    802054f8:	85ce                	mv	a1,s3
    802054fa:	854a                	mv	a0,s2
    802054fc:	fffff097          	auipc	ra,0xfffff
    80205500:	274080e7          	jalr	628(ra) # 80204770 <_Z9tf_fwritePKciP13struct_TFFILE>
    80205504:	892a                	mv	s2,a0
  tf_fclose(fp);
    80205506:	8526                	mv	a0,s1
    80205508:	fffff097          	auipc	ra,0xfffff
    8020550c:	55c080e7          	jalr	1372(ra) # 80204a64 <_Z9tf_fcloseP13struct_TFFILE>
}
    80205510:	854a                	mv	a0,s2
    80205512:	70a2                	ld	ra,40(sp)
    80205514:	7402                	ld	s0,32(sp)
    80205516:	64e2                	ld	s1,24(sp)
    80205518:	6942                	ld	s2,16(sp)
    8020551a:	69a2                	ld	s3,8(sp)
    8020551c:	6a02                	ld	s4,0(sp)
    8020551e:	6145                	addi	sp,sp,48
    80205520:	8082                	ret

0000000080205522 <_Z9tf_removePc>:
int tf_remove(char *filename) {
    80205522:	715d                	addi	sp,sp,-80
    80205524:	e486                	sd	ra,72(sp)
    80205526:	e0a2                	sd	s0,64(sp)
    80205528:	fc26                	sd	s1,56(sp)
    8020552a:	f84a                	sd	s2,48(sp)
    8020552c:	f44e                	sd	s3,40(sp)
    8020552e:	0880                	addi	s0,sp,80
    80205530:	892a                	mv	s2,a0
  fp = tf_fopen(filename, "r");
    80205532:	00005597          	auipc	a1,0x5
    80205536:	36e58593          	addi	a1,a1,878 # 8020a8a0 <_ZL6digits+0x598>
    8020553a:	00000097          	auipc	ra,0x0
    8020553e:	97e080e7          	jalr	-1666(ra) # 80204eb8 <_Z8tf_fopenPKcS0_>
  if (fp == NULL) return -1;        // return an error if we're removing a file that doesn't exist
    80205542:	c569                	beqz	a0,8020560c <_Z9tf_removePc+0xea>
  startCluster = fp->startCluster;  // Remember first cluster of the file so we can remove the clusterchain
    80205544:	00452983          	lw	s3,4(a0)
  tf_fclose(fp);
    80205548:	fffff097          	auipc	ra,0xfffff
    8020554c:	51c080e7          	jalr	1308(ra) # 80204a64 <_Z9tf_fcloseP13struct_TFFILE>
  fp = tf_parent(filename, "r+", false);
    80205550:	4601                	li	a2,0
    80205552:	00005597          	auipc	a1,0x5
    80205556:	34658593          	addi	a1,a1,838 # 8020a898 <_ZL6digits+0x590>
    8020555a:	854a                	mv	a0,s2
    8020555c:	fffff097          	auipc	ra,0xfffff
    80205560:	75c080e7          	jalr	1884(ra) # 80204cb8 <_Z9tf_parentPKcS0_i>
    80205564:	84aa                	mv	s1,a0
  rc = tf_find_file(fp, (strrchr((char *)filename, '/') + 1));
    80205566:	02f00593          	li	a1,47
    8020556a:	854a                	mv	a0,s2
    8020556c:	ffffc097          	auipc	ra,0xffffc
    80205570:	82e080e7          	jalr	-2002(ra) # 80200d9a <_Z7strrchrPKcc>
    80205574:	00150593          	addi	a1,a0,1
    80205578:	8526                	mv	a0,s1
    8020557a:	fffff097          	auipc	ra,0xfffff
    8020557e:	e80080e7          	jalr	-384(ra) # 802043fa <_Z12tf_find_fileP13struct_TFFILEPc>
  if (!rc) {
    80205582:	e13d                	bnez	a0,802055e8 <_Z9tf_removePc+0xc6>
      rc = tf_fseek(fp, sizeof(FatFileEntry), fp->pos);
    80205584:	0144e603          	lwu	a2,20(s1)
    80205588:	02000593          	li	a1,32
    8020558c:	8526                	mv	a0,s1
    8020558e:	fffff097          	auipc	ra,0xfffff
    80205592:	bfa080e7          	jalr	-1030(ra) # 80204188 <_Z8tf_fseekP13struct_TFFILEml>
      if (rc) break;
    80205596:	e121                	bnez	a0,802055d6 <_Z9tf_removePc+0xb4>
      tf_fread((char *)&entry, sizeof(FatFileEntry), fp);  // Read one entry ahead
    80205598:	4681                	li	a3,0
    8020559a:	8626                	mv	a2,s1
    8020559c:	02000593          	li	a1,32
    802055a0:	fb040513          	addi	a0,s0,-80
    802055a4:	fffff097          	auipc	ra,0xfffff
    802055a8:	c0e080e7          	jalr	-1010(ra) # 802041b2 <_Z8tf_freadPciP13struct_TFFILEb>
      tf_fseek(fp, -((int32_t)2 * sizeof(FatFileEntry)), fp->pos);
    802055ac:	0144e603          	lwu	a2,20(s1)
    802055b0:	fc000593          	li	a1,-64
    802055b4:	8526                	mv	a0,s1
    802055b6:	fffff097          	auipc	ra,0xfffff
    802055ba:	bd2080e7          	jalr	-1070(ra) # 80204188 <_Z8tf_fseekP13struct_TFFILEml>
      tf_fwrite((char *)&entry, sizeof(FatFileEntry), fp);
    802055be:	8626                	mv	a2,s1
    802055c0:	02000593          	li	a1,32
    802055c4:	fb040513          	addi	a0,s0,-80
    802055c8:	fffff097          	auipc	ra,0xfffff
    802055cc:	1a8080e7          	jalr	424(ra) # 80204770 <_Z9tf_fwritePKciP13struct_TFFILE>
      if (entry.msdos.filename[0] == 0) break;
    802055d0:	fb044783          	lbu	a5,-80(s0)
    802055d4:	fbc5                	bnez	a5,80205584 <_Z9tf_removePc+0x62>
    fp->size -= sizeof(FatFileEntry);
    802055d6:	4cdc                	lw	a5,28(s1)
    802055d8:	3781                	addiw	a5,a5,-32
    802055da:	ccdc                	sw	a5,28(s1)
    fp->flags |= TF_FLAG_SIZECHANGED;
    802055dc:	0184c783          	lbu	a5,24(s1)
    802055e0:	0047e793          	ori	a5,a5,4
    802055e4:	00f48c23          	sb	a5,24(s1)
  tf_fclose(fp);
    802055e8:	8526                	mv	a0,s1
    802055ea:	fffff097          	auipc	ra,0xfffff
    802055ee:	47a080e7          	jalr	1146(ra) # 80204a64 <_Z9tf_fcloseP13struct_TFFILE>
  tf_free_clusterchain(startCluster);  // Free the data associated with the file
    802055f2:	854e                	mv	a0,s3
    802055f4:	fffff097          	auipc	ra,0xfffff
    802055f8:	80e080e7          	jalr	-2034(ra) # 80203e02 <_Z20tf_free_clusterchainj>
  return 0;
    802055fc:	4501                	li	a0,0
}
    802055fe:	60a6                	ld	ra,72(sp)
    80205600:	6406                	ld	s0,64(sp)
    80205602:	74e2                	ld	s1,56(sp)
    80205604:	7942                	ld	s2,48(sp)
    80205606:	79a2                	ld	s3,40(sp)
    80205608:	6161                	addi	sp,sp,80
    8020560a:	8082                	ret
  if (fp == NULL) return -1;        // return an error if we're removing a file that doesn't exist
    8020560c:	557d                	li	a0,-1
    8020560e:	bfc5                	j	802055fe <_Z9tf_removePc+0xdc>

0000000080205610 <_ZN15Fat32FileSystem2rmEPKc>:
size_t Fat32FileSystem::rm(const char *filepath) {
    80205610:	1141                	addi	sp,sp,-16
    80205612:	e406                	sd	ra,8(sp)
    80205614:	e022                	sd	s0,0(sp)
    80205616:	0800                	addi	s0,sp,16
  tf_remove((char *)filepath);
    80205618:	852e                	mv	a0,a1
    8020561a:	00000097          	auipc	ra,0x0
    8020561e:	f08080e7          	jalr	-248(ra) # 80205522 <_Z9tf_removePc>
}
    80205622:	4501                	li	a0,0
    80205624:	60a2                	ld	ra,8(sp)
    80205626:	6402                	ld	s0,0(sp)
    80205628:	0141                	addi	sp,sp,16
    8020562a:	8082                	ret

000000008020562c <_Z18tf_initializeMediaj>:
/* Initialize the FileSystem metadata on the media (yes, the "FORMAT" command
    that Windows doesn't allow for large volumes */
uint32_t tf_initializeMedia(
    uint32_t totalSectors)  // this should take in some lun number to make this all good...   but we'll do that when we
                            // get read/write_sector lun-aware. also, hardcoded sector configuration
{
    8020562c:	b7010113          	addi	sp,sp,-1168
    80205630:	48113423          	sd	ra,1160(sp)
    80205634:	48813023          	sd	s0,1152(sp)
    80205638:	46913c23          	sd	s1,1144(sp)
    8020563c:	47213823          	sd	s2,1136(sp)
    80205640:	47313423          	sd	s3,1128(sp)
    80205644:	47413023          	sd	s4,1120(sp)
    80205648:	49010413          	addi	s0,sp,1168
    8020564c:	84aa                	mv	s1,a0
  BPB_struct bpb;  // = (BPB_struct*)sectorBuf0;
  // uint32_t scl, val, ssa, fat;
  uint32_t scl, ssa, fat;

  dbg_printf("\r\n build sector 0:");
  memset(sectorBuf0, 0x00, 0x200);
    8020564e:	20000613          	li	a2,512
    80205652:	4581                	li	a1,0
    80205654:	dd040513          	addi	a0,s0,-560
    80205658:	ffffb097          	auipc	ra,0xffffb
    8020565c:	504080e7          	jalr	1284(ra) # 80200b5c <_Z6memsetPvij>
  memset(&bpb, 0, sizeof(bpb));
    80205660:	05a00613          	li	a2,90
    80205664:	4581                	li	a1,0
    80205666:	b7040513          	addi	a0,s0,-1168
    8020566a:	ffffb097          	auipc	ra,0xffffb
    8020566e:	4f2080e7          	jalr	1266(ra) # 80200b5c <_Z6memsetPvij>

  // jump instruction
  bpb.BS_JumpBoot[0] = 0xEB;
    80205672:	57ad                	li	a5,-21
    80205674:	b6f40823          	sb	a5,-1168(s0)
  bpb.BS_JumpBoot[1] = 0x58;
    80205678:	05800793          	li	a5,88
    8020567c:	b6f408a3          	sb	a5,-1167(s0)
  bpb.BS_JumpBoot[2] = 0x90;
    80205680:	f9000793          	li	a5,-112
    80205684:	b6f40923          	sb	a5,-1166(s0)

  // OEM name
  memcpy(bpb.BS_OEMName, " mkdosfs", 8);
    80205688:	4621                	li	a2,8
    8020568a:	00005597          	auipc	a1,0x5
    8020568e:	31658593          	addi	a1,a1,790 # 8020a9a0 <_ZL6digits+0x698>
    80205692:	b7340513          	addi	a0,s0,-1165
    80205696:	ffffb097          	auipc	ra,0xffffb
    8020569a:	584080e7          	jalr	1412(ra) # 80200c1a <_Z6memcpyPvPKvj>

  // BPB
  bpb.BytesPerSector = 0x200;  // hard coded, must be a define somewhere
    8020569e:	b6040da3          	sb	zero,-1157(s0)
    802056a2:	4789                	li	a5,2
    802056a4:	b6f40e23          	sb	a5,-1156(s0)
  bpb.SectorsPerCluster = 32;  // this may change based on drive size
    802056a8:	02000793          	li	a5,32
    802056ac:	b6f40ea3          	sb	a5,-1155(s0)
  bpb.ReservedSectorCount = 32;
    802056b0:	02000793          	li	a5,32
    802056b4:	b6f41f23          	sh	a5,-1154(s0)
  bpb.NumFATs = 2;
    802056b8:	4709                	li	a4,2
    802056ba:	b8e40023          	sb	a4,-1152(s0)
  // bpb.RootEntryCount = 0;
  // bpb.TotalSectors16 = 0;
  bpb.Media = 0xf8;
    802056be:	5761                	li	a4,-8
    802056c0:	b8e402a3          	sb	a4,-1147(s0)
  // bpb.FATSize16 = 0;
  bpb.SectorsPerTrack = 32;  // unknown here
    802056c4:	b8f41423          	sh	a5,-1144(s0)
  bpb.NumberOfHeads = 64;    // ?
    802056c8:	04000793          	li	a5,64
    802056cc:	b8f41523          	sh	a5,-1142(s0)
  // bpb.HiddenSectors = 0;
  bpb.TotalSectors32 = totalSectors;
    802056d0:	b8942823          	sw	s1,-1136(s0)
  // BPB-FAT32 Extension
  bpb.FSTypeSpecificData.fat32.FATSize = totalSectors / 4095;
    802056d4:	6505                	lui	a0,0x1
    802056d6:	357d                	addiw	a0,a0,-1
    802056d8:	02a4d4bb          	divuw	s1,s1,a0
    802056dc:	b8942a23          	sw	s1,-1132(s0)
  // bpb.FSTypeSpecificData.fat32.ExtFlags = 0;
  // bpb.FSTypeSpecificData.fat32.FSVersion = 0;
  bpb.FSTypeSpecificData.fat32.RootCluster = 2;
    802056e0:	4789                	li	a5,2
    802056e2:	b8f42e23          	sw	a5,-1124(s0)
  bpb.FSTypeSpecificData.fat32.FSInfo = 1;
    802056e6:	4785                	li	a5,1
    802056e8:	baf41023          	sh	a5,-1120(s0)
  bpb.FSTypeSpecificData.fat32.BkBootSec = 6;
    802056ec:	4799                	li	a5,6
    802056ee:	baf41123          	sh	a5,-1118(s0)
  // memset( bpb.FSTypeSpecificData.fat32.Reserved, 0x00, 12 );
  // bpb.FSTypeSpecificData.fat32.BS_DriveNumber = 0;
  // bpb.FSTypeSpecificData.fat32.BS_Reserved1 = 0;
  bpb.FSTypeSpecificData.fat32.BS_BootSig = 0x29;
    802056f2:	02900793          	li	a5,41
    802056f6:	baf40923          	sb	a5,-1102(s0)
  bpb.FSTypeSpecificData.fat32.BS_VolumeID =
    802056fa:	fc100793          	li	a5,-63
    802056fe:	baf409a3          	sb	a5,-1101(s0)
    80205702:	fdd00793          	li	a5,-35
    80205706:	baf40a23          	sb	a5,-1100(s0)
    8020570a:	05800793          	li	a5,88
    8020570e:	baf40aa3          	sb	a5,-1099(s0)
    80205712:	57cd                	li	a5,-13
    80205714:	baf40b23          	sb	a5,-1098(s0)
      0xf358ddc1;  // hardcoded volume id.  this is weird.  should be generated each time.
  memset(bpb.FSTypeSpecificData.fat32.BS_VolumeLabel, 0x20, 11);
    80205718:	462d                	li	a2,11
    8020571a:	02000593          	li	a1,32
    8020571e:	bb740513          	addi	a0,s0,-1097
    80205722:	ffffb097          	auipc	ra,0xffffb
    80205726:	43a080e7          	jalr	1082(ra) # 80200b5c <_Z6memsetPvij>
  memcpy(bpb.FSTypeSpecificData.fat32.BS_FileSystemType, "FAT32   ", 8);
    8020572a:	4621                	li	a2,8
    8020572c:	00005597          	auipc	a1,0x5
    80205730:	28458593          	addi	a1,a1,644 # 8020a9b0 <_ZL6digits+0x6a8>
    80205734:	bc240513          	addi	a0,s0,-1086
    80205738:	ffffb097          	auipc	ra,0xffffb
    8020573c:	4e2080e7          	jalr	1250(ra) # 80200c1a <_Z6memcpyPvPKvj>
  memcpy(sectorBuf0, &bpb, sizeof(bpb));
    80205740:	05a00613          	li	a2,90
    80205744:	b7040593          	addi	a1,s0,-1168
    80205748:	dd040513          	addi	a0,s0,-560
    8020574c:	ffffb097          	auipc	ra,0xffffb
    80205750:	4ce080e7          	jalr	1230(ra) # 80200c1a <_Z6memcpyPvPKvj>

  memcpy(
    80205754:	08100613          	li	a2,129
    80205758:	00005597          	auipc	a1,0x5
    8020575c:	2d858593          	addi	a1,a1,728 # 8020aa30 <_ZTV15Fat32FileSystem+0x68>
    80205760:	e2a40513          	addi	a0,s0,-470
    80205764:	ffffb097          	auipc	ra,0xffffb
    80205768:	4b6080e7          	jalr	1206(ra) # 80200c1a <_Z6memcpyPvPKvj>
      sectorBuf0 + 0x5a,
      "\x0e\x1f\xbe\x77\x7c\xac\x22\xc0\x74\x0b\x56\xb4\x0e\xbb\x07\x00\xcd\x10\x5e\xeb\xf0\x32\xe4\xcd\x17\xcd\x19\xeb"
      "\xfeThis is not a bootable disk.  Please insert a bootable floppy and\r\npress any key to try again ... \r\n",
      129);

  fat = (bpb.ReservedSectorCount);
    8020576c:	b7e45983          	lhu	s3,-1154(s0)
  // dbg_printf("\n\rFATSize=%u\n\rNumFATs=%u\n\rfat=%u\n\r",bpb.FSTypeSpecificData.fat32.FATSize,bpb.NumFATs,fat);

  // ending signatures
  sectorBuf0[0x1fe] = 0x55;
    80205770:	05500793          	li	a5,85
    80205774:	fcf40723          	sb	a5,-50(s0)
  sectorBuf0[0x1ff] = 0xAA;
    80205778:	faa00793          	li	a5,-86
    8020577c:	fcf407a3          	sb	a5,-49(s0)
  write_sector(sectorBuf0, 0);
    80205780:	4581                	li	a1,0
    80205782:	dd040513          	addi	a0,s0,-560
    80205786:	ffffe097          	auipc	ra,0xffffe
    8020578a:	106080e7          	jalr	262(ra) # 8020388c <_Z12write_sectorPcj>

  // set up key sectors...
  // dbg_printf("\n\rFATSize=%u\n\rNumFATs=%u\n\fat=%u\n\r",bpb.FSTypeSpecificData.fat32.FATSize,bpb.NumFATs,fat);

  ssa = (bpb.NumFATs * bpb.FSTypeSpecificData.fat32.FATSize) + fat;
    8020578e:	b8044903          	lbu	s2,-1152(s0)
    80205792:	b9442783          	lw	a5,-1132(s0)
    80205796:	02f9093b          	mulw	s2,s2,a5
    8020579a:	013909bb          	addw	s3,s2,s3
    8020579e:	00098a1b          	sext.w	s4,s3

  // dbg_printf("\n\r ssa = %u\n\r",ssa);
  dbg_printf("\r\n build sector 1:");
  // FSInfo sector
  memset(sectorBuf, 0x00, 0x200);
    802057a2:	20000613          	li	a2,512
    802057a6:	4581                	li	a1,0
    802057a8:	bd040513          	addi	a0,s0,-1072
    802057ac:	ffffb097          	auipc	ra,0xffffb
    802057b0:	3b0080e7          	jalr	944(ra) # 80200b5c <_Z6memsetPvij>
  *((uint32_t *)sectorBuf) = 0x41615252;
    802057b4:	416157b7          	lui	a5,0x41615
    802057b8:	2527879b          	addiw	a5,a5,594
    802057bc:	bcf42823          	sw	a5,-1072(s0)
  *((uint32_t *)(sectorBuf + 0x1e4)) = 0x61417272;
    802057c0:	614177b7          	lui	a5,0x61417
    802057c4:	2727879b          	addiw	a5,a5,626
    802057c8:	daf42a23          	sw	a5,-588(s0)
  *((uint32_t *)(sectorBuf + 0x1e8)) = 0xffffffff;  // last known number of free data clusters on volume
    802057cc:	57fd                	li	a5,-1
    802057ce:	daf42c23          	sw	a5,-584(s0)
  *((uint32_t *)(sectorBuf + 0x1ec)) = 0xffffffff;  // number of most recently known to be allocated cluster
    802057d2:	daf42e23          	sw	a5,-580(s0)
  *((uint32_t *)(sectorBuf + 0x1f0)) = 0;           // reserved
    802057d6:	dc042023          	sw	zero,-576(s0)
  *((uint32_t *)(sectorBuf + 0x1f4)) = 0;           // reserved
    802057da:	dc042223          	sw	zero,-572(s0)
  *((uint32_t *)(sectorBuf + 0x1f8)) = 0;           // reserved
    802057de:	dc042423          	sw	zero,-568(s0)
  *((uint32_t *)(sectorBuf + 0x1fc)) = 0xaa550000;
    802057e2:	aa5507b7          	lui	a5,0xaa550
    802057e6:	dcf42623          	sw	a5,-564(s0)
  write_sector(sectorBuf, 1);
    802057ea:	4585                	li	a1,1
    802057ec:	bd040513          	addi	a0,s0,-1072
    802057f0:	ffffe097          	auipc	ra,0xffffe
    802057f4:	09c080e7          	jalr	156(ra) # 8020388c <_Z12write_sectorPcj>
  fat = (bpb.ReservedSectorCount);
    802057f8:	b7e45483          	lhu	s1,-1154(s0)

  dbg_printf("\r\n     clear rest of Cluster");
  memset(sectorBuf, 0x00, 0x200);
    802057fc:	20000613          	li	a2,512
    80205800:	4581                	li	a1,0
    80205802:	bd040513          	addi	a0,s0,-1072
    80205806:	ffffb097          	auipc	ra,0xffffb
    8020580a:	356080e7          	jalr	854(ra) # 80200b5c <_Z6memsetPvij>
  for (scl = 2; scl < bpb.SectorsPerCluster; scl++) {
    8020580e:	b7d44703          	lbu	a4,-1155(s0)
    80205812:	4789                	li	a5,2
    80205814:	02e7f863          	bgeu	a5,a4,80205844 <_Z18tf_initializeMediaj+0x218>
    80205818:	4909                	li	s2,2
    memset(sectorBuf, 0x00, 0x200);
    8020581a:	20000613          	li	a2,512
    8020581e:	4581                	li	a1,0
    80205820:	bd040513          	addi	a0,s0,-1072
    80205824:	ffffb097          	auipc	ra,0xffffb
    80205828:	338080e7          	jalr	824(ra) # 80200b5c <_Z6memsetPvij>
    write_sector(sectorBuf, scl);
    8020582c:	85ca                	mv	a1,s2
    8020582e:	bd040513          	addi	a0,s0,-1072
    80205832:	ffffe097          	auipc	ra,0xffffe
    80205836:	05a080e7          	jalr	90(ra) # 8020388c <_Z12write_sectorPcj>
  for (scl = 2; scl < bpb.SectorsPerCluster; scl++) {
    8020583a:	2905                	addiw	s2,s2,1
    8020583c:	b7d44783          	lbu	a5,-1155(s0)
    80205840:	fcf96de3          	bltu	s2,a5,8020581a <_Z18tf_initializeMediaj+0x1ee>
  }
  // write backup copy of metadata
  write_sector(sectorBuf0, 6);
    80205844:	4599                	li	a1,6
    80205846:	dd040513          	addi	a0,s0,-560
    8020584a:	ffffe097          	auipc	ra,0xffffe
    8020584e:	042080e7          	jalr	66(ra) # 8020388c <_Z12write_sectorPcj>
  dbg_printf("\r\n initialize DATA section starting in Section 2:");
  // make Root Directory

  // whack ROOT directory file: SSA = RSC + FN x SF + ceil((32 x RDE)/SS)  and LSN = SSA + (CN-2) x SC
  // this clears the first cluster of the root directory
  memset(sectorBuf, 0x00, 0x200);  // 0x00000000 is the unallocated marker
    80205852:	20000613          	li	a2,512
    80205856:	4581                	li	a1,0
    80205858:	bd040513          	addi	a0,s0,-1072
    8020585c:	ffffb097          	auipc	ra,0xffffb
    80205860:	300080e7          	jalr	768(ra) # 80200b5c <_Z6memsetPvij>
  for (scl = ssa + bpb.SectorsPerCluster; scl >= ssa; scl--) {
    80205864:	b7d44903          	lbu	s2,-1155(s0)
    80205868:	0139093b          	addw	s2,s2,s3
    8020586c:	01496c63          	bltu	s2,s4,80205884 <_Z18tf_initializeMediaj+0x258>
    dbg_printf("wiping sector %x  ", scl);
    write_sector(sectorBuf, scl);
    80205870:	85ca                	mv	a1,s2
    80205872:	bd040513          	addi	a0,s0,-1072
    80205876:	ffffe097          	auipc	ra,0xffffe
    8020587a:	016080e7          	jalr	22(ra) # 8020388c <_Z12write_sectorPcj>
  for (scl = ssa + bpb.SectorsPerCluster; scl >= ssa; scl--) {
    8020587e:	397d                	addiw	s2,s2,-1
    80205880:	ff4978e3          	bgeu	s2,s4,80205870 <_Z18tf_initializeMediaj+0x244>
      write_sector( sectorBuf, scl+(bpb->TotalSectors32 / 2048) );
  }*/

  dbg_printf("\r\n    // initialize FAT in Section 1 (first two dwords are special, the rest are 0");
  dbg_printf("\r\n    // write all 00's to all (%d) FAT sectors", ssa - fat);
  memset(sectorBuf, 0x00, 0x200);  // 0x00000000 is the unallocated marker
    80205884:	20000613          	li	a2,512
    80205888:	4581                	li	a1,0
    8020588a:	bd040513          	addi	a0,s0,-1072
    8020588e:	ffffb097          	auipc	ra,0xffffb
    80205892:	2ce080e7          	jalr	718(ra) # 80200b5c <_Z6memsetPvij>
  for (scl = fat; scl < ssa / 2; scl++) {
    80205896:	0019d99b          	srliw	s3,s3,0x1
    8020589a:	0334f463          	bgeu	s1,s3,802058c2 <_Z18tf_initializeMediaj+0x296>
    write_sector(sectorBuf, scl);
    8020589e:	85a6                	mv	a1,s1
    802058a0:	bd040513          	addi	a0,s0,-1072
    802058a4:	ffffe097          	auipc	ra,0xffffe
    802058a8:	fe8080e7          	jalr	-24(ra) # 8020388c <_Z12write_sectorPcj>
    write_sector(sectorBuf, scl + (ssa / 2));
    802058ac:	009985bb          	addw	a1,s3,s1
    802058b0:	bd040513          	addi	a0,s0,-1072
    802058b4:	ffffe097          	auipc	ra,0xffffe
    802058b8:	fd8080e7          	jalr	-40(ra) # 8020388c <_Z12write_sectorPcj>
  for (scl = fat; scl < ssa / 2; scl++) {
    802058bc:	2485                	addiw	s1,s1,1
    802058be:	ff3490e3          	bne	s1,s3,8020589e <_Z18tf_initializeMediaj+0x272>
  }

  // SSA = RSC + FN x SF + ceil((32 x RDE)/SS)  and LSN = SSA + (CN-2) x SC

  dbg_printf("\r\n    // now set up first sector and write");
  *((uint32_t *)(sectorBuf + 0x000)) = 0x0ffffff8;  // special - EOF marker
    802058c2:	100007b7          	lui	a5,0x10000
    802058c6:	ff87871b          	addiw	a4,a5,-8
    802058ca:	bce42823          	sw	a4,-1072(s0)
  *((uint32_t *)(sectorBuf + 0x004)) = 0x0fffffff;  // special and clean
    802058ce:	37fd                	addiw	a5,a5,-1
    802058d0:	bcf42a23          	sw	a5,-1068(s0)
  *((uint32_t *)(sectorBuf + 0x008)) = 0x0ffffff8;  // root directory (one cluster)
    802058d4:	bce42c23          	sw	a4,-1064(s0)
  write_sector(sectorBuf, bpb.SectorsPerCluster);
    802058d8:	b7d44583          	lbu	a1,-1155(s0)
    802058dc:	bd040513          	addi	a0,s0,-1072
    802058e0:	ffffe097          	auipc	ra,0xffffe
    802058e4:	fac080e7          	jalr	-84(ra) # 8020388c <_Z12write_sectorPcj>

  dbg_printf(" initialization complete\r\n");
  return 0;
}
    802058e8:	4501                	li	a0,0
    802058ea:	48813083          	ld	ra,1160(sp)
    802058ee:	48013403          	ld	s0,1152(sp)
    802058f2:	47813483          	ld	s1,1144(sp)
    802058f6:	47013903          	ld	s2,1136(sp)
    802058fa:	46813983          	ld	s3,1128(sp)
    802058fe:	46013a03          	ld	s4,1120(sp)
    80205902:	49010113          	addi	sp,sp,1168
    80205906:	8082                	ret

0000000080205908 <_Z25tf_initializeMediaNoBlockji>:

uint32_t tf_initializeMediaNoBlock(uint32_t totalSectors, int start) {
    80205908:	b7010113          	addi	sp,sp,-1168
    8020590c:	48113423          	sd	ra,1160(sp)
    80205910:	48813023          	sd	s0,1152(sp)
    80205914:	46913c23          	sd	s1,1144(sp)
    80205918:	47213823          	sd	s2,1136(sp)
    8020591c:	47313423          	sd	s3,1128(sp)
    80205920:	49010413          	addi	s0,sp,1168
  BPB_struct bpb;  // = (BPB_struct*)sectorBuf0;
  // uint32_t fat, val;
  uint32_t fat;
  static uint32_t scl, ssa, sectors_per_cluster;

  if (start) {
    80205924:	e5e9                	bnez	a1,802059ee <_Z25tf_initializeMediaNoBlockji+0xe6>
    dbg_printf("\r\n    // initialize FAT in Section 1 (first two dwords are special, the rest are 0");
    dbg_printf("\r\n    // write all 00's to all (%d) FAT sectors", ssa - fat);
    scl = fat;
    return true;
  } else {
    uint32_t stop = scl + 100;
    80205926:	0008b717          	auipc	a4,0x8b
    8020592a:	c9272703          	lw	a4,-878(a4) # 802905b8 <_ZZ25tf_initializeMediaNoBlockjiE3scl>
    8020592e:	0647071b          	addiw	a4,a4,100
    if (stop >= (ssa / 2)) stop = ssa / 2;
    80205932:	0008b797          	auipc	a5,0x8b
    80205936:	c827a783          	lw	a5,-894(a5) # 802905b4 <_ZZ25tf_initializeMediaNoBlockjiE3ssa>
    8020593a:	0017d79b          	srliw	a5,a5,0x1
    8020593e:	893e                	mv	s2,a5
    80205940:	2781                	sext.w	a5,a5
    80205942:	0007069b          	sext.w	a3,a4
    80205946:	00f6f363          	bgeu	a3,a5,8020594c <_Z25tf_initializeMediaNoBlockji+0x44>
    8020594a:	893a                	mv	s2,a4
    8020594c:	2901                	sext.w	s2,s2
    memset(sectorBuf, 0x00, 0x200);  // 0x00000000 is the unallocated marker
    8020594e:	20000613          	li	a2,512
    80205952:	4581                	li	a1,0
    80205954:	bd040513          	addi	a0,s0,-1072
    80205958:	ffffb097          	auipc	ra,0xffffb
    8020595c:	204080e7          	jalr	516(ra) # 80200b5c <_Z6memsetPvij>
    dbg_printf("~", scl, stop);
    for (; scl < stop; scl++) {
    80205960:	0008b597          	auipc	a1,0x8b
    80205964:	c585a583          	lw	a1,-936(a1) # 802905b8 <_ZZ25tf_initializeMediaNoBlockjiE3scl>
    80205968:	0525f363          	bgeu	a1,s2,802059ae <_Z25tf_initializeMediaNoBlockji+0xa6>
      write_sector(sectorBuf, scl);
      write_sector(sectorBuf, scl + (ssa / 2));
    8020596c:	0008b997          	auipc	s3,0x8b
    80205970:	c4898993          	addi	s3,s3,-952 # 802905b4 <_ZZ25tf_initializeMediaNoBlockjiE3ssa>
    80205974:	0008b497          	auipc	s1,0x8b
    80205978:	c4448493          	addi	s1,s1,-956 # 802905b8 <_ZZ25tf_initializeMediaNoBlockjiE3scl>
      write_sector(sectorBuf, scl);
    8020597c:	bd040513          	addi	a0,s0,-1072
    80205980:	ffffe097          	auipc	ra,0xffffe
    80205984:	f0c080e7          	jalr	-244(ra) # 8020388c <_Z12write_sectorPcj>
      write_sector(sectorBuf, scl + (ssa / 2));
    80205988:	0009a783          	lw	a5,0(s3)
    8020598c:	0017d79b          	srliw	a5,a5,0x1
    80205990:	408c                	lw	a1,0(s1)
    80205992:	9dbd                	addw	a1,a1,a5
    80205994:	bd040513          	addi	a0,s0,-1072
    80205998:	ffffe097          	auipc	ra,0xffffe
    8020599c:	ef4080e7          	jalr	-268(ra) # 8020388c <_Z12write_sectorPcj>
    for (; scl < stop; scl++) {
    802059a0:	409c                	lw	a5,0(s1)
    802059a2:	2785                	addiw	a5,a5,1
    802059a4:	0007859b          	sext.w	a1,a5
    802059a8:	c09c                	sw	a5,0(s1)
    802059aa:	fd25e9e3          	bltu	a1,s2,8020597c <_Z25tf_initializeMediaNoBlockji+0x74>
    }
    if (scl < ssa / 2) return false;
    802059ae:	0008b797          	auipc	a5,0x8b
    802059b2:	c067a783          	lw	a5,-1018(a5) # 802905b4 <_ZZ25tf_initializeMediaNoBlockjiE3ssa>
    802059b6:	0017d79b          	srliw	a5,a5,0x1
    802059ba:	4501                	li	a0,0
    802059bc:	2cf5e563          	bltu	a1,a5,80205c86 <_Z25tf_initializeMediaNoBlockji+0x37e>

    // SSA = RSC + FN x SF + ceil((32 x RDE)/SS)  and LSN = SSA + (CN-2) x SC

    dbg_printf("\r\n    // now set up first sector and write");
    *((uint32_t *)(sectorBuf + 0x000)) = 0x0ffffff8;  // special - EOF marker
    802059c0:	100007b7          	lui	a5,0x10000
    802059c4:	ff87871b          	addiw	a4,a5,-8
    802059c8:	bce42823          	sw	a4,-1072(s0)
    *((uint32_t *)(sectorBuf + 0x004)) = 0x0fffffff;  // special and clean
    802059cc:	37fd                	addiw	a5,a5,-1
    802059ce:	bcf42a23          	sw	a5,-1068(s0)
    *((uint32_t *)(sectorBuf + 0x008)) = 0x0ffffff8;  // root directory (one cluster)
    802059d2:	bce42c23          	sw	a4,-1064(s0)
    write_sector(sectorBuf, sectors_per_cluster);
    802059d6:	0008b597          	auipc	a1,0x8b
    802059da:	bda5a583          	lw	a1,-1062(a1) # 802905b0 <_ZZ25tf_initializeMediaNoBlockjiE19sectors_per_cluster>
    802059de:	bd040513          	addi	a0,s0,-1072
    802059e2:	ffffe097          	auipc	ra,0xffffe
    802059e6:	eaa080e7          	jalr	-342(ra) # 8020388c <_Z12write_sectorPcj>

    dbg_printf(" initialization complete\r\n");
  }
  return true;
    802059ea:	4505                	li	a0,1
    802059ec:	ac69                	j	80205c86 <_Z25tf_initializeMediaNoBlockji+0x37e>
    802059ee:	84aa                	mv	s1,a0
    memset(sectorBuf0, 0x00, 0x200);
    802059f0:	20000613          	li	a2,512
    802059f4:	4581                	li	a1,0
    802059f6:	dd040513          	addi	a0,s0,-560
    802059fa:	ffffb097          	auipc	ra,0xffffb
    802059fe:	162080e7          	jalr	354(ra) # 80200b5c <_Z6memsetPvij>
    memset(&bpb, 0, sizeof(bpb));
    80205a02:	05a00613          	li	a2,90
    80205a06:	4581                	li	a1,0
    80205a08:	b7040513          	addi	a0,s0,-1168
    80205a0c:	ffffb097          	auipc	ra,0xffffb
    80205a10:	150080e7          	jalr	336(ra) # 80200b5c <_Z6memsetPvij>
    bpb.BS_JumpBoot[0] = 0xEB;
    80205a14:	57ad                	li	a5,-21
    80205a16:	b6f40823          	sb	a5,-1168(s0)
    bpb.BS_JumpBoot[1] = 0x58;
    80205a1a:	05800793          	li	a5,88
    80205a1e:	b6f408a3          	sb	a5,-1167(s0)
    bpb.BS_JumpBoot[2] = 0x90;
    80205a22:	f9000793          	li	a5,-112
    80205a26:	b6f40923          	sb	a5,-1166(s0)
    memcpy(bpb.BS_OEMName, " mkdosfs", 8);
    80205a2a:	4621                	li	a2,8
    80205a2c:	00005597          	auipc	a1,0x5
    80205a30:	f7458593          	addi	a1,a1,-140 # 8020a9a0 <_ZL6digits+0x698>
    80205a34:	b7340513          	addi	a0,s0,-1165
    80205a38:	ffffb097          	auipc	ra,0xffffb
    80205a3c:	1e2080e7          	jalr	482(ra) # 80200c1a <_Z6memcpyPvPKvj>
    bpb.BytesPerSector = 0x200;  // hard coded, must be a define somewhere
    80205a40:	b6040da3          	sb	zero,-1157(s0)
    80205a44:	4789                	li	a5,2
    80205a46:	b6f40e23          	sb	a5,-1156(s0)
    bpb.SectorsPerCluster = 32;  // this may change based on drive size
    80205a4a:	02000793          	li	a5,32
    80205a4e:	b6f40ea3          	sb	a5,-1155(s0)
    sectors_per_cluster = 32;
    80205a52:	0008b997          	auipc	s3,0x8b
    80205a56:	b5e98993          	addi	s3,s3,-1186 # 802905b0 <_ZZ25tf_initializeMediaNoBlockjiE19sectors_per_cluster>
    80205a5a:	02000793          	li	a5,32
    80205a5e:	00f9a023          	sw	a5,0(s3)
    bpb.ReservedSectorCount = 32;
    80205a62:	b6f41f23          	sh	a5,-1154(s0)
    bpb.NumFATs = 2;
    80205a66:	4789                	li	a5,2
    80205a68:	b8f40023          	sb	a5,-1152(s0)
    bpb.Media = 0xf8;
    80205a6c:	57e1                	li	a5,-8
    80205a6e:	b8f402a3          	sb	a5,-1147(s0)
    bpb.SectorsPerTrack = 32;  // unknown here
    80205a72:	02000793          	li	a5,32
    80205a76:	b8f41423          	sh	a5,-1144(s0)
    bpb.NumberOfHeads = 64;    // ?
    80205a7a:	04000793          	li	a5,64
    80205a7e:	b8f41523          	sh	a5,-1142(s0)
    bpb.TotalSectors32 = totalSectors;
    80205a82:	b8942823          	sw	s1,-1136(s0)
    bpb.FSTypeSpecificData.fat32.FATSize = totalSectors / 4095;
    80205a86:	6785                	lui	a5,0x1
    80205a88:	37fd                	addiw	a5,a5,-1
    80205a8a:	02f4d7bb          	divuw	a5,s1,a5
    80205a8e:	b8f42a23          	sw	a5,-1132(s0)
    bpb.FSTypeSpecificData.fat32.RootCluster = 2;
    80205a92:	4489                	li	s1,2
    80205a94:	b8942e23          	sw	s1,-1124(s0)
    bpb.FSTypeSpecificData.fat32.FSInfo = 1;
    80205a98:	4785                	li	a5,1
    80205a9a:	baf41023          	sh	a5,-1120(s0)
    bpb.FSTypeSpecificData.fat32.BkBootSec = 6;
    80205a9e:	4799                	li	a5,6
    80205aa0:	baf41123          	sh	a5,-1118(s0)
    bpb.FSTypeSpecificData.fat32.BS_BootSig = 0x29;
    80205aa4:	02900793          	li	a5,41
    80205aa8:	baf40923          	sb	a5,-1102(s0)
    bpb.FSTypeSpecificData.fat32.BS_VolumeID =
    80205aac:	fc100793          	li	a5,-63
    80205ab0:	baf409a3          	sb	a5,-1101(s0)
    80205ab4:	fdd00793          	li	a5,-35
    80205ab8:	baf40a23          	sb	a5,-1100(s0)
    80205abc:	05800793          	li	a5,88
    80205ac0:	baf40aa3          	sb	a5,-1099(s0)
    80205ac4:	57cd                	li	a5,-13
    80205ac6:	baf40b23          	sb	a5,-1098(s0)
    memset(bpb.FSTypeSpecificData.fat32.BS_VolumeLabel, 0x20, 11);
    80205aca:	462d                	li	a2,11
    80205acc:	02000593          	li	a1,32
    80205ad0:	bb740513          	addi	a0,s0,-1097
    80205ad4:	ffffb097          	auipc	ra,0xffffb
    80205ad8:	088080e7          	jalr	136(ra) # 80200b5c <_Z6memsetPvij>
    memcpy(bpb.FSTypeSpecificData.fat32.BS_FileSystemType, "FAT32   ", 8);
    80205adc:	4621                	li	a2,8
    80205ade:	00005597          	auipc	a1,0x5
    80205ae2:	ed258593          	addi	a1,a1,-302 # 8020a9b0 <_ZL6digits+0x6a8>
    80205ae6:	bc240513          	addi	a0,s0,-1086
    80205aea:	ffffb097          	auipc	ra,0xffffb
    80205aee:	130080e7          	jalr	304(ra) # 80200c1a <_Z6memcpyPvPKvj>
    memcpy(sectorBuf0, &bpb, sizeof(bpb));
    80205af2:	05a00613          	li	a2,90
    80205af6:	b7040593          	addi	a1,s0,-1168
    80205afa:	dd040513          	addi	a0,s0,-560
    80205afe:	ffffb097          	auipc	ra,0xffffb
    80205b02:	11c080e7          	jalr	284(ra) # 80200c1a <_Z6memcpyPvPKvj>
    memcpy(sectorBuf0 + 0x5a,
    80205b06:	08100613          	li	a2,129
    80205b0a:	00005597          	auipc	a1,0x5
    80205b0e:	f2658593          	addi	a1,a1,-218 # 8020aa30 <_ZTV15Fat32FileSystem+0x68>
    80205b12:	e2a40513          	addi	a0,s0,-470
    80205b16:	ffffb097          	auipc	ra,0xffffb
    80205b1a:	104080e7          	jalr	260(ra) # 80200c1a <_Z6memcpyPvPKvj>
    fat = (bpb.ReservedSectorCount);
    80205b1e:	b7e45903          	lhu	s2,-1154(s0)
    sectorBuf0[0x1fe] = 0x55;
    80205b22:	05500793          	li	a5,85
    80205b26:	fcf40723          	sb	a5,-50(s0)
    sectorBuf0[0x1ff] = 0xAA;
    80205b2a:	faa00793          	li	a5,-86
    80205b2e:	fcf407a3          	sb	a5,-49(s0)
    write_sector(sectorBuf0, 0);
    80205b32:	4581                	li	a1,0
    80205b34:	dd040513          	addi	a0,s0,-560
    80205b38:	ffffe097          	auipc	ra,0xffffe
    80205b3c:	d54080e7          	jalr	-684(ra) # 8020388c <_Z12write_sectorPcj>
    ssa = (bpb.NumFATs * bpb.FSTypeSpecificData.fat32.FATSize) + fat;
    80205b40:	b8044783          	lbu	a5,-1152(s0)
    80205b44:	b9442703          	lw	a4,-1132(s0)
    80205b48:	02e787bb          	mulw	a5,a5,a4
    80205b4c:	012787bb          	addw	a5,a5,s2
    80205b50:	0008b717          	auipc	a4,0x8b
    80205b54:	a6f72223          	sw	a5,-1436(a4) # 802905b4 <_ZZ25tf_initializeMediaNoBlockjiE3ssa>
    memset(sectorBuf, 0x00, 0x200);
    80205b58:	20000613          	li	a2,512
    80205b5c:	4581                	li	a1,0
    80205b5e:	bd040513          	addi	a0,s0,-1072
    80205b62:	ffffb097          	auipc	ra,0xffffb
    80205b66:	ffa080e7          	jalr	-6(ra) # 80200b5c <_Z6memsetPvij>
    *((uint32_t *)sectorBuf) = 0x41615252;
    80205b6a:	416157b7          	lui	a5,0x41615
    80205b6e:	2527879b          	addiw	a5,a5,594
    80205b72:	bcf42823          	sw	a5,-1072(s0)
    *((uint32_t *)(sectorBuf + 0x1e4)) = 0x61417272;
    80205b76:	614177b7          	lui	a5,0x61417
    80205b7a:	2727879b          	addiw	a5,a5,626
    80205b7e:	daf42a23          	sw	a5,-588(s0)
    *((uint32_t *)(sectorBuf + 0x1e8)) = 0xffffffff;  // last known number of free data clusters on volume
    80205b82:	57fd                	li	a5,-1
    80205b84:	daf42c23          	sw	a5,-584(s0)
    *((uint32_t *)(sectorBuf + 0x1ec)) = 0xffffffff;  // number of most recently known to be allocated cluster
    80205b88:	daf42e23          	sw	a5,-580(s0)
    *((uint32_t *)(sectorBuf + 0x1f0)) = 0;           // reserved
    80205b8c:	dc042023          	sw	zero,-576(s0)
    *((uint32_t *)(sectorBuf + 0x1f4)) = 0;           // reserved
    80205b90:	dc042223          	sw	zero,-572(s0)
    *((uint32_t *)(sectorBuf + 0x1f8)) = 0;           // reserved
    80205b94:	dc042423          	sw	zero,-568(s0)
    *((uint32_t *)(sectorBuf + 0x1fc)) = 0xaa550000;
    80205b98:	aa5507b7          	lui	a5,0xaa550
    80205b9c:	dcf42623          	sw	a5,-564(s0)
    write_sector(sectorBuf, 1);
    80205ba0:	4585                	li	a1,1
    80205ba2:	bd040513          	addi	a0,s0,-1072
    80205ba6:	ffffe097          	auipc	ra,0xffffe
    80205baa:	ce6080e7          	jalr	-794(ra) # 8020388c <_Z12write_sectorPcj>
    fat = (bpb.ReservedSectorCount);
    80205bae:	b7e45903          	lhu	s2,-1154(s0)
    memset(sectorBuf, 0x00, 0x200);
    80205bb2:	20000613          	li	a2,512
    80205bb6:	4581                	li	a1,0
    80205bb8:	bd040513          	addi	a0,s0,-1072
    80205bbc:	ffffb097          	auipc	ra,0xffffb
    80205bc0:	fa0080e7          	jalr	-96(ra) # 80200b5c <_Z6memsetPvij>
    for (scl = 2; scl < sectors_per_cluster; scl++) {
    80205bc4:	0008b797          	auipc	a5,0x8b
    80205bc8:	9e97aa23          	sw	s1,-1548(a5) # 802905b8 <_ZZ25tf_initializeMediaNoBlockjiE3scl>
    80205bcc:	0009a703          	lw	a4,0(s3)
    80205bd0:	4789                	li	a5,2
    80205bd2:	02e7ff63          	bgeu	a5,a4,80205c10 <_Z25tf_initializeMediaNoBlockji+0x308>
      write_sector(sectorBuf, scl);
    80205bd6:	0008b497          	auipc	s1,0x8b
    80205bda:	9e248493          	addi	s1,s1,-1566 # 802905b8 <_ZZ25tf_initializeMediaNoBlockjiE3scl>
      memset(sectorBuf, 0x00, 0x200);
    80205bde:	20000613          	li	a2,512
    80205be2:	4581                	li	a1,0
    80205be4:	bd040513          	addi	a0,s0,-1072
    80205be8:	ffffb097          	auipc	ra,0xffffb
    80205bec:	f74080e7          	jalr	-140(ra) # 80200b5c <_Z6memsetPvij>
      write_sector(sectorBuf, scl);
    80205bf0:	408c                	lw	a1,0(s1)
    80205bf2:	bd040513          	addi	a0,s0,-1072
    80205bf6:	ffffe097          	auipc	ra,0xffffe
    80205bfa:	c96080e7          	jalr	-874(ra) # 8020388c <_Z12write_sectorPcj>
    for (scl = 2; scl < sectors_per_cluster; scl++) {
    80205bfe:	409c                	lw	a5,0(s1)
    80205c00:	2785                	addiw	a5,a5,1
    80205c02:	0007871b          	sext.w	a4,a5
    80205c06:	c09c                	sw	a5,0(s1)
    80205c08:	0009a783          	lw	a5,0(s3)
    80205c0c:	fcf769e3          	bltu	a4,a5,80205bde <_Z25tf_initializeMediaNoBlockji+0x2d6>
    write_sector(sectorBuf0, 6);
    80205c10:	4599                	li	a1,6
    80205c12:	dd040513          	addi	a0,s0,-560
    80205c16:	ffffe097          	auipc	ra,0xffffe
    80205c1a:	c76080e7          	jalr	-906(ra) # 8020388c <_Z12write_sectorPcj>
    memset(sectorBuf, 0x00, 0x200);  // 0x00000000 is the unallocated marker
    80205c1e:	20000613          	li	a2,512
    80205c22:	4581                	li	a1,0
    80205c24:	bd040513          	addi	a0,s0,-1072
    80205c28:	ffffb097          	auipc	ra,0xffffb
    80205c2c:	f34080e7          	jalr	-204(ra) # 80200b5c <_Z6memsetPvij>
    for (scl = ssa + bpb.SectorsPerCluster; scl >= ssa; scl--) {
    80205c30:	0008b717          	auipc	a4,0x8b
    80205c34:	98472703          	lw	a4,-1660(a4) # 802905b4 <_ZZ25tf_initializeMediaNoBlockjiE3ssa>
    80205c38:	b7d44783          	lbu	a5,-1155(s0)
    80205c3c:	9fb9                	addw	a5,a5,a4
    80205c3e:	0007859b          	sext.w	a1,a5
    80205c42:	0008b697          	auipc	a3,0x8b
    80205c46:	96f6ab23          	sw	a5,-1674(a3) # 802905b8 <_ZZ25tf_initializeMediaNoBlockjiE3scl>
    80205c4a:	02e5e963          	bltu	a1,a4,80205c7c <_Z25tf_initializeMediaNoBlockji+0x374>
    80205c4e:	0008b497          	auipc	s1,0x8b
    80205c52:	96a48493          	addi	s1,s1,-1686 # 802905b8 <_ZZ25tf_initializeMediaNoBlockjiE3scl>
    80205c56:	0008b997          	auipc	s3,0x8b
    80205c5a:	95e98993          	addi	s3,s3,-1698 # 802905b4 <_ZZ25tf_initializeMediaNoBlockjiE3ssa>
      write_sector(sectorBuf, scl);
    80205c5e:	bd040513          	addi	a0,s0,-1072
    80205c62:	ffffe097          	auipc	ra,0xffffe
    80205c66:	c2a080e7          	jalr	-982(ra) # 8020388c <_Z12write_sectorPcj>
    for (scl = ssa + bpb.SectorsPerCluster; scl >= ssa; scl--) {
    80205c6a:	409c                	lw	a5,0(s1)
    80205c6c:	37fd                	addiw	a5,a5,-1
    80205c6e:	0007859b          	sext.w	a1,a5
    80205c72:	c09c                	sw	a5,0(s1)
    80205c74:	0009a783          	lw	a5,0(s3)
    80205c78:	fef5f3e3          	bgeu	a1,a5,80205c5e <_Z25tf_initializeMediaNoBlockji+0x356>
    scl = fat;
    80205c7c:	0008b797          	auipc	a5,0x8b
    80205c80:	9327ae23          	sw	s2,-1732(a5) # 802905b8 <_ZZ25tf_initializeMediaNoBlockjiE3scl>
    return true;
    80205c84:	4505                	li	a0,1
}
    80205c86:	48813083          	ld	ra,1160(sp)
    80205c8a:	48013403          	ld	s0,1152(sp)
    80205c8e:	47813483          	ld	s1,1144(sp)
    80205c92:	47013903          	ld	s2,1136(sp)
    80205c96:	46813983          	ld	s3,1128(sp)
    80205c9a:	49010113          	addi	sp,sp,1168
    80205c9e:	8082                	ret

0000000080205ca0 <_Z21tf_print_open_handlesv>:
void tf_print_open_handles(void) {
    80205ca0:	1141                	addi	sp,sp,-16
    80205ca2:	e422                	sd	s0,8(sp)
    80205ca4:	0800                	addi	s0,sp,16
    if (fp->flags & TF_FLAG_OPEN)
      dbg_printf(" %2x", i);
    else
      dbg_printf("   ");
  }
}
    80205ca6:	6422                	ld	s0,8(sp)
    80205ca8:	0141                	addi	sp,sp,16
    80205caa:	8082                	ret

0000000080205cac <_Z19tf_get_open_handlesv>:
/*! tf_get_open_handles()
    returns a bitfield where the handles are open (1) or free (0)
    assumes there are <64 handles
*/
uint64_t tf_get_open_handles(void) {
    80205cac:	1141                	addi	sp,sp,-16
    80205cae:	e422                	sd	s0,8(sp)
    80205cb0:	0800                	addi	s0,sp,16
  int i;
  TFFile *fp;
  uint64_t retval = 0;

  dbg_printf("\r\n-=-=- Open File Handles : ");
  for (i = 0; i < min(TF_FILE_HANDLES, 64); i++) {
    80205cb2:	a001                	j	80205cb2 <_Z19tf_get_open_handlesv+0x6>

0000000080205cb4 <_Z8printHexPcj>:
  }
  return retval;
}

void printHex(char *st, uint32_t length) {
  while (length--) printf("%.2x", *st++);
    80205cb4:	c5a9                	beqz	a1,80205cfe <_Z8printHexPcj+0x4a>
void printHex(char *st, uint32_t length) {
    80205cb6:	7179                	addi	sp,sp,-48
    80205cb8:	f406                	sd	ra,40(sp)
    80205cba:	f022                	sd	s0,32(sp)
    80205cbc:	ec26                	sd	s1,24(sp)
    80205cbe:	e84a                	sd	s2,16(sp)
    80205cc0:	e44e                	sd	s3,8(sp)
    80205cc2:	1800                	addi	s0,sp,48
    80205cc4:	84aa                	mv	s1,a0
    80205cc6:	fff5891b          	addiw	s2,a1,-1
    80205cca:	1902                	slli	s2,s2,0x20
    80205ccc:	02095913          	srli	s2,s2,0x20
    80205cd0:	0905                	addi	s2,s2,1
    80205cd2:	992a                	add	s2,s2,a0
  while (length--) printf("%.2x", *st++);
    80205cd4:	00005997          	auipc	s3,0x5
    80205cd8:	cec98993          	addi	s3,s3,-788 # 8020a9c0 <_ZL6digits+0x6b8>
    80205cdc:	0485                	addi	s1,s1,1
    80205cde:	fff4c583          	lbu	a1,-1(s1)
    80205ce2:	854e                	mv	a0,s3
    80205ce4:	ffffb097          	auipc	ra,0xffffb
    80205ce8:	b70080e7          	jalr	-1168(ra) # 80200854 <_Z6printfPKcz>
    80205cec:	fe9918e3          	bne	s2,s1,80205cdc <_Z8printHexPcj+0x28>
}
    80205cf0:	70a2                	ld	ra,40(sp)
    80205cf2:	7402                	ld	s0,32(sp)
    80205cf4:	64e2                	ld	s1,24(sp)
    80205cf6:	6942                	ld	s2,16(sp)
    80205cf8:	69a2                	ld	s3,8(sp)
    80205cfa:	6145                	addi	sp,sp,48
    80205cfc:	8082                	ret
    80205cfe:	8082                	ret

0000000080205d00 <_Z9disk_initv>:
#include "fs/disk/SdCard.hpp"
#include "driver/dmac.hpp"
#endif


void disk_init(void) {
    80205d00:	1141                	addi	sp,sp,-16
    80205d02:	e406                	sd	ra,8(sp)
    80205d04:	e022                	sd	s0,0(sp)
    80205d06:	0800                	addi	s0,sp,16
#ifdef QEMU
  virtio_init();
    80205d08:	00002097          	auipc	ra,0x2
    80205d0c:	98c080e7          	jalr	-1652(ra) # 80207694 <_Z11virtio_initv>
#else
  sdcard_init();
#endif
}
    80205d10:	60a2                	ld	ra,8(sp)
    80205d12:	6402                	ld	s0,0(sp)
    80205d14:	0141                	addi	sp,sp,16
    80205d16:	8082                	ret

0000000080205d18 <_Z9disk_readP3buf>:

void disk_read(struct buf *b) {
    80205d18:	1141                	addi	sp,sp,-16
    80205d1a:	e406                	sd	ra,8(sp)
    80205d1c:	e022                	sd	s0,0(sp)
    80205d1e:	0800                	addi	s0,sp,16
#ifdef QEMU
  virtio_read(b);
    80205d20:	00002097          	auipc	ra,0x2
    80205d24:	fe6080e7          	jalr	-26(ra) # 80207d06 <_Z11virtio_readP3buf>
#else
sdcard_read_sector(b->data, b->blockno);
#endif
}
    80205d28:	60a2                	ld	ra,8(sp)
    80205d2a:	6402                	ld	s0,0(sp)
    80205d2c:	0141                	addi	sp,sp,16
    80205d2e:	8082                	ret

0000000080205d30 <_Z10disk_writeP3buf>:

void disk_write(struct buf *b) {
    80205d30:	1141                	addi	sp,sp,-16
    80205d32:	e406                	sd	ra,8(sp)
    80205d34:	e022                	sd	s0,0(sp)
    80205d36:	0800                	addi	s0,sp,16
#ifdef QEMU
  virtio_write(b);
    80205d38:	00002097          	auipc	ra,0x2
    80205d3c:	fe8080e7          	jalr	-24(ra) # 80207d20 <_Z12virtio_writeP3buf>
#else
  sdcard_write_sector(b->data, b->blockno);
#endif
}
    80205d40:	60a2                	ld	ra,8(sp)
    80205d42:	6402                	ld	s0,0(sp)
    80205d44:	0141                	addi	sp,sp,16
    80205d46:	8082                	ret

0000000080205d48 <_Z9disk_intrv>:

void disk_intr(void) {
    80205d48:	1141                	addi	sp,sp,-16
    80205d4a:	e406                	sd	ra,8(sp)
    80205d4c:	e022                	sd	s0,0(sp)
    80205d4e:	0800                	addi	s0,sp,16
#ifdef QEMU
  virtio_disk_intr();
    80205d50:	00002097          	auipc	ra,0x2
    80205d54:	ea4080e7          	jalr	-348(ra) # 80207bf4 <_Z16virtio_disk_intrv>
#else
  dmac_intr(DMAC_CHANNEL0);
#endif
}
    80205d58:	60a2                	ld	ra,8(sp)
    80205d5a:	6402                	ld	s0,0(sp)
    80205d5c:	0141                	addi	sp,sp,16
    80205d5e:	8082                	ret

0000000080205d60 <_ZN3vfs16createFileSystemENS_14FileSystemTypeEPKcS2_>:

struct file fileTable[NFILE];
SpinLock fileTableLock;
FileSystem *mountedFS[NFILESYSTEM];

FileSystem *createFileSystem(FileSystemType type, const char *mountPoint, const char *dev) {
    80205d60:	7179                	addi	sp,sp,-48
    80205d62:	f406                	sd	ra,40(sp)
    80205d64:	f022                	sd	s0,32(sp)
    80205d66:	ec26                	sd	s1,24(sp)
    80205d68:	e84a                	sd	s2,16(sp)
    80205d6a:	e44e                	sd	s3,8(sp)
    80205d6c:	1800                	addi	s0,sp,48
    80205d6e:	89ae                	mv	s3,a1
    80205d70:	8932                	mv	s2,a2
  switch (type) {
    80205d72:	4785                	li	a5,1
    80205d74:	04f50f63          	beq	a0,a5,80205dd2 <_ZN3vfs16createFileSystemENS_14FileSystemTypeEPKcS2_+0x72>
    80205d78:	478d                	li	a5,3
    80205d7a:	0af51663          	bne	a0,a5,80205e26 <_ZN3vfs16createFileSystemENS_14FileSystemTypeEPKcS2_+0xc6>
    case FileSystemType::DEVFS:
      return new DeviceFileSystem(mountPoint, dev);
    80205d7e:	08800513          	li	a0,136
    80205d82:	ffffa097          	auipc	ra,0xffffa
    80205d86:	53e080e7          	jalr	1342(ra) # 802002c0 <_Znwm>
    80205d8a:	84aa                	mv	s1,a0
    80205d8c:	c555                	beqz	a0,80205e38 <_ZN3vfs16createFileSystemENS_14FileSystemTypeEPKcS2_+0xd8>

  /**
   * @brief
   *
   */
  DeviceFileSystem(const char *mountPoint, const char *dev) {
    80205d8e:	00005797          	auipc	a5,0x5
    80205d92:	ed278793          	addi	a5,a5,-302 # 8020ac60 <_ZTV16DeviceFileSystem+0x10>
    80205d96:	e11c                	sd	a5,0(a0)
    safestrcpy(this->mountPoint, mountPoint, strlen(mountPoint)+1);
    80205d98:	854e                	mv	a0,s3
    80205d9a:	ffffb097          	auipc	ra,0xffffb
    80205d9e:	fb2080e7          	jalr	-78(ra) # 80200d4c <_Z6strlenPKc>
    80205da2:	0015061b          	addiw	a2,a0,1
    80205da6:	85ce                	mv	a1,s3
    80205da8:	00848513          	addi	a0,s1,8
    80205dac:	ffffb097          	auipc	ra,0xffffb
    80205db0:	f6c080e7          	jalr	-148(ra) # 80200d18 <_Z10safestrcpyPcPKci>
    safestrcpy(this->dev, dev, strlen(dev)+1);
    80205db4:	854a                	mv	a0,s2
    80205db6:	ffffb097          	auipc	ra,0xffffb
    80205dba:	f96080e7          	jalr	-106(ra) # 80200d4c <_Z6strlenPKc>
    80205dbe:	0015061b          	addiw	a2,a0,1
    80205dc2:	85ca                	mv	a1,s2
    80205dc4:	04848513          	addi	a0,s1,72
    80205dc8:	ffffb097          	auipc	ra,0xffffb
    80205dcc:	f50080e7          	jalr	-176(ra) # 80200d18 <_Z10safestrcpyPcPKci>
  };
    80205dd0:	a0a5                	j	80205e38 <_ZN3vfs16createFileSystemENS_14FileSystemTypeEPKcS2_+0xd8>
    case FileSystemType::FAT32:
      return new Fat32FileSystem(mountPoint, dev);
    80205dd2:	08800513          	li	a0,136
    80205dd6:	ffffa097          	auipc	ra,0xffffa
    80205dda:	4ea080e7          	jalr	1258(ra) # 802002c0 <_Znwm>
    80205dde:	84aa                	mv	s1,a0
    80205de0:	cd21                	beqz	a0,80205e38 <_ZN3vfs16createFileSystemENS_14FileSystemTypeEPKcS2_+0xd8>

  /**
   * @brief 带参构造函数
   *
   */
  Fat32FileSystem(const char *mountPoint, const char *dev) {
    80205de2:	00005797          	auipc	a5,0x5
    80205de6:	bf678793          	addi	a5,a5,-1034 # 8020a9d8 <_ZTV15Fat32FileSystem+0x10>
    80205dea:	e11c                	sd	a5,0(a0)
    safestrcpy(this->mountPoint, mountPoint, strlen(mountPoint) + 1);
    80205dec:	854e                	mv	a0,s3
    80205dee:	ffffb097          	auipc	ra,0xffffb
    80205df2:	f5e080e7          	jalr	-162(ra) # 80200d4c <_Z6strlenPKc>
    80205df6:	0015061b          	addiw	a2,a0,1
    80205dfa:	85ce                	mv	a1,s3
    80205dfc:	00848513          	addi	a0,s1,8
    80205e00:	ffffb097          	auipc	ra,0xffffb
    80205e04:	f18080e7          	jalr	-232(ra) # 80200d18 <_Z10safestrcpyPcPKci>
    safestrcpy(this->dev, dev, strlen(dev) + 1);
    80205e08:	854a                	mv	a0,s2
    80205e0a:	ffffb097          	auipc	ra,0xffffb
    80205e0e:	f42080e7          	jalr	-190(ra) # 80200d4c <_Z6strlenPKc>
    80205e12:	0015061b          	addiw	a2,a0,1
    80205e16:	85ca                	mv	a1,s2
    80205e18:	04848513          	addi	a0,s1,72
    80205e1c:	ffffb097          	auipc	ra,0xffffb
    80205e20:	efc080e7          	jalr	-260(ra) # 80200d18 <_Z10safestrcpyPcPKci>
  };
    80205e24:	a811                	j	80205e38 <_ZN3vfs16createFileSystemENS_14FileSystemTypeEPKcS2_+0xd8>
    default:
      panic("create file system");
    80205e26:	00005517          	auipc	a0,0x5
    80205e2a:	c9250513          	addi	a0,a0,-878 # 8020aab8 <_ZTV15Fat32FileSystem+0xf0>
    80205e2e:	ffffb097          	auipc	ra,0xffffb
    80205e32:	9b4080e7          	jalr	-1612(ra) # 802007e2 <_Z5panicPKc>
      break;
  }
  return nullptr;
    80205e36:	4481                	li	s1,0
}
    80205e38:	8526                	mv	a0,s1
    80205e3a:	70a2                	ld	ra,40(sp)
    80205e3c:	7402                	ld	s0,32(sp)
    80205e3e:	64e2                	ld	s1,24(sp)
    80205e40:	6942                	ld	s2,16(sp)
    80205e42:	69a2                	ld	s3,8(sp)
    80205e44:	6145                	addi	sp,sp,48
    80205e46:	8082                	ret

0000000080205e48 <_ZN3vfs15allocFileHandleEv>:

struct file *allocFileHandle() {
    80205e48:	1101                	addi	sp,sp,-32
    80205e4a:	ec06                	sd	ra,24(sp)
    80205e4c:	e822                	sd	s0,16(sp)
    80205e4e:	e426                	sd	s1,8(sp)
    80205e50:	1000                	addi	s0,sp,32
  fileTableLock.lock();
    80205e52:	0008a517          	auipc	a0,0x8a
    80205e56:	76e50513          	addi	a0,a0,1902 # 802905c0 <_ZN3vfs13fileTableLockE>
    80205e5a:	ffffb097          	auipc	ra,0xffffb
    80205e5e:	ff2080e7          	jalr	-14(ra) # 80200e4c <_ZN8SpinLock4lockEv>
  struct file *fp;
  for (fp = fileTable; fp < fileTable + NFILE; fp++) {
    80205e62:	0008a497          	auipc	s1,0x8a
    80205e66:	79e48493          	addi	s1,s1,1950 # 80290600 <_ZN3vfs9fileTableE>
    80205e6a:	0008d717          	auipc	a4,0x8d
    80205e6e:	35670713          	addi	a4,a4,854 # 802931c0 <kernel_pagetable>
    if (fp->type == fp->FD_NONE) {
    80205e72:	4cbc                	lw	a5,88(s1)
    80205e74:	cf99                	beqz	a5,80205e92 <_ZN3vfs15allocFileHandleEv+0x4a>
  for (fp = fileTable; fp < fileTable + NFILE; fp++) {
    80205e76:	07048493          	addi	s1,s1,112
    80205e7a:	fee49ce3          	bne	s1,a4,80205e72 <_ZN3vfs15allocFileHandleEv+0x2a>
      fileTableLock.unlock();
      return fp;
    }
  }
  panic("alloc file");
    80205e7e:	00005517          	auipc	a0,0x5
    80205e82:	c5250513          	addi	a0,a0,-942 # 8020aad0 <_ZTV15Fat32FileSystem+0x108>
    80205e86:	ffffb097          	auipc	ra,0xffffb
    80205e8a:	95c080e7          	jalr	-1700(ra) # 802007e2 <_Z5panicPKc>
  return NULL;
    80205e8e:	4481                	li	s1,0
    80205e90:	a809                	j	80205ea2 <_ZN3vfs15allocFileHandleEv+0x5a>
      fileTableLock.unlock();
    80205e92:	0008a517          	auipc	a0,0x8a
    80205e96:	72e50513          	addi	a0,a0,1838 # 802905c0 <_ZN3vfs13fileTableLockE>
    80205e9a:	ffffb097          	auipc	ra,0xffffb
    80205e9e:	02e080e7          	jalr	46(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
}
    80205ea2:	8526                	mv	a0,s1
    80205ea4:	60e2                	ld	ra,24(sp)
    80205ea6:	6442                	ld	s0,16(sp)
    80205ea8:	64a2                	ld	s1,8(sp)
    80205eaa:	6105                	addi	sp,sp,32
    80205eac:	8082                	ret

0000000080205eae <_ZN3vfs14freeFileHandleEP4file>:

void freeFileHandle(struct file *f) { memset(f, 0, sizeof(struct file)); }
    80205eae:	1141                	addi	sp,sp,-16
    80205eb0:	e406                	sd	ra,8(sp)
    80205eb2:	e022                	sd	s0,0(sp)
    80205eb4:	0800                	addi	s0,sp,16
    80205eb6:	07000613          	li	a2,112
    80205eba:	4581                	li	a1,0
    80205ebc:	ffffb097          	auipc	ra,0xffffb
    80205ec0:	ca0080e7          	jalr	-864(ra) # 80200b5c <_Z6memsetPvij>
    80205ec4:	60a2                	ld	ra,8(sp)
    80205ec6:	6402                	ld	s0,0(sp)
    80205ec8:	0141                	addi	sp,sp,16
    80205eca:	8082                	ret

0000000080205ecc <_ZN3vfs5getFsEPKc>:
 * @brief 找到filepath所属的文件系统
 *
 * @param filepath
 * @return FileSystem*
 */
FileSystem *getFs(const char *filepath) {
    80205ecc:	715d                	addi	sp,sp,-80
    80205ece:	e486                	sd	ra,72(sp)
    80205ed0:	e0a2                	sd	s0,64(sp)
    80205ed2:	fc26                	sd	s1,56(sp)
    80205ed4:	f84a                	sd	s2,48(sp)
    80205ed6:	f44e                	sd	s3,40(sp)
    80205ed8:	f052                	sd	s4,32(sp)
    80205eda:	ec56                	sd	s5,24(sp)
    80205edc:	e85a                	sd	s6,16(sp)
    80205ede:	e45e                	sd	s7,8(sp)
    80205ee0:	0880                	addi	s0,sp,80
    80205ee2:	84aa                	mv	s1,a0
  int bestMatch = 0;
  int bestLength = 0;
  // 找出最适配的文件系统
  for (size_t i = 0; i < NFILESYSTEM; ++i) {
    80205ee4:	0008a917          	auipc	s2,0x8a
    80205ee8:	6f490913          	addi	s2,s2,1780 # 802905d8 <_ZN3vfs9mountedFSE>
    80205eec:	8aaa                	mv	s5,a0
    80205eee:	00550993          	addi	s3,a0,5
  int bestLength = 0;
    80205ef2:	4b81                	li	s7,0
  int bestMatch = 0;
    80205ef4:	4b01                	li	s6,0
    80205ef6:	a839                	j	80205f14 <_ZN3vfs5getFsEPKc+0x48>
        break;
      }
    }

    if (match && strlen(mp->mountPoint) > bestLength) {
      bestLength = strlen(mp->mountPoint);
    80205ef8:	000a3503          	ld	a0,0(s4)
    80205efc:	0521                	addi	a0,a0,8
    80205efe:	ffffb097          	auipc	ra,0xffffb
    80205f02:	e4e080e7          	jalr	-434(ra) # 80200d4c <_Z6strlenPKc>
    80205f06:	8baa                	mv	s7,a0
      bestMatch = i;
    80205f08:	41548b3b          	subw	s6,s1,s5
  for (size_t i = 0; i < NFILESYSTEM; ++i) {
    80205f0c:	0921                	addi	s2,s2,8
    80205f0e:	0485                	addi	s1,s1,1
    80205f10:	05348063          	beq	s1,s3,80205f50 <_ZN3vfs5getFsEPKc+0x84>
    if (mountedFS[i] == NULL) continue;
    80205f14:	8a4a                	mv	s4,s2
    80205f16:	00093503          	ld	a0,0(s2)
    80205f1a:	d96d                	beqz	a0,80205f0c <_ZN3vfs5getFsEPKc+0x40>
    for (size_t j = 0; mp->mountPoint[j] != 0 && filepath[i] != 0; ++j) {
    80205f1c:	00854783          	lbu	a5,8(a0)
    80205f20:	c385                	beqz	a5,80205f40 <_ZN3vfs5getFsEPKc+0x74>
    80205f22:	0004c583          	lbu	a1,0(s1)
    80205f26:	00950693          	addi	a3,a0,9
    80205f2a:	8756                	mv	a4,s5
    80205f2c:	c991                	beqz	a1,80205f40 <_ZN3vfs5getFsEPKc+0x74>
      if (mp->mountPoint[j] != filepath[j]) {
    80205f2e:	00074603          	lbu	a2,0(a4)
    80205f32:	fcf61de3          	bne	a2,a5,80205f0c <_ZN3vfs5getFsEPKc+0x40>
    for (size_t j = 0; mp->mountPoint[j] != 0 && filepath[i] != 0; ++j) {
    80205f36:	0006c783          	lbu	a5,0(a3)
    80205f3a:	0685                	addi	a3,a3,1
    80205f3c:	0705                	addi	a4,a4,1
    80205f3e:	f7fd                	bnez	a5,80205f2c <_ZN3vfs5getFsEPKc+0x60>
    if (match && strlen(mp->mountPoint) > bestLength) {
    80205f40:	0521                	addi	a0,a0,8
    80205f42:	ffffb097          	auipc	ra,0xffffb
    80205f46:	e0a080e7          	jalr	-502(ra) # 80200d4c <_Z6strlenPKc>
    80205f4a:	fcabd1e3          	bge	s7,a0,80205f0c <_ZN3vfs5getFsEPKc+0x40>
    80205f4e:	b76d                	j	80205ef8 <_ZN3vfs5getFsEPKc+0x2c>
    }
  }
  return mountedFS[bestMatch];
    80205f50:	0b0e                	slli	s6,s6,0x3
    80205f52:	0008a797          	auipc	a5,0x8a
    80205f56:	66e78793          	addi	a5,a5,1646 # 802905c0 <_ZN3vfs13fileTableLockE>
    80205f5a:	9b3e                	add	s6,s6,a5
    80205f5c:	018b3503          	ld	a0,24(s6)
}
    80205f60:	60a6                	ld	ra,72(sp)
    80205f62:	6406                	ld	s0,64(sp)
    80205f64:	74e2                	ld	s1,56(sp)
    80205f66:	7942                	ld	s2,48(sp)
    80205f68:	79a2                	ld	s3,40(sp)
    80205f6a:	7a02                	ld	s4,32(sp)
    80205f6c:	6ae2                	ld	s5,24(sp)
    80205f6e:	6b42                	ld	s6,16(sp)
    80205f70:	6ba2                	ld	s7,8(sp)
    80205f72:	6161                	addi	sp,sp,80
    80205f74:	8082                	ret

0000000080205f76 <_ZN3vfs15getAbsolutePathEPcS0_>:

/**
 * @brief 计算oldpath的绝对路径
 */
void getAbsolutePath(char *oldpath, char *newPath) {
    80205f76:	7179                	addi	sp,sp,-48
    80205f78:	f406                	sd	ra,40(sp)
    80205f7a:	f022                	sd	s0,32(sp)
    80205f7c:	ec26                	sd	s1,24(sp)
    80205f7e:	e84a                	sd	s2,16(sp)
    80205f80:	e44e                	sd	s3,8(sp)
    80205f82:	1800                	addi	s0,sp,48
    80205f84:	892a                	mv	s2,a0
    80205f86:	89ae                	mv	s3,a1
  const char *curdir = myTask()->currentDir;
    80205f88:	ffffc097          	auipc	ra,0xffffc
    80205f8c:	a84080e7          	jalr	-1404(ra) # 80201a0c <_Z6myTaskv>

  if (oldpath[0] == '/') {
    80205f90:	00094703          	lbu	a4,0(s2)
    80205f94:	02f00793          	li	a5,47
    80205f98:	06f70b63          	beq	a4,a5,8020600e <_ZN3vfs15getAbsolutePathEPcS0_+0x98>
  const char *curdir = myTask()->currentDir;
    80205f9c:	09050493          	addi	s1,a0,144
    memcpy(newPath, oldpath, strlen(oldpath));
  } else {
    myTask()->lock.lock();
    80205fa0:	ffffc097          	auipc	ra,0xffffc
    80205fa4:	a6c080e7          	jalr	-1428(ra) # 80201a0c <_Z6myTaskv>
    80205fa8:	ffffb097          	auipc	ra,0xffffb
    80205fac:	ea4080e7          	jalr	-348(ra) # 80200e4c <_ZN8SpinLock4lockEv>
    memcpy(newPath, curdir, strlen(curdir));
    80205fb0:	8526                	mv	a0,s1
    80205fb2:	ffffb097          	auipc	ra,0xffffb
    80205fb6:	d9a080e7          	jalr	-614(ra) # 80200d4c <_Z6strlenPKc>
    80205fba:	0005061b          	sext.w	a2,a0
    80205fbe:	85a6                	mv	a1,s1
    80205fc0:	854e                	mv	a0,s3
    80205fc2:	ffffb097          	auipc	ra,0xffffb
    80205fc6:	c58080e7          	jalr	-936(ra) # 80200c1a <_Z6memcpyPvPKvj>
    memcpy(newPath + strlen(curdir), oldpath, strlen(oldpath));
    80205fca:	8526                	mv	a0,s1
    80205fcc:	ffffb097          	auipc	ra,0xffffb
    80205fd0:	d80080e7          	jalr	-640(ra) # 80200d4c <_Z6strlenPKc>
    80205fd4:	99aa                	add	s3,s3,a0
    80205fd6:	854a                	mv	a0,s2
    80205fd8:	ffffb097          	auipc	ra,0xffffb
    80205fdc:	d74080e7          	jalr	-652(ra) # 80200d4c <_Z6strlenPKc>
    80205fe0:	0005061b          	sext.w	a2,a0
    80205fe4:	85ca                	mv	a1,s2
    80205fe6:	854e                	mv	a0,s3
    80205fe8:	ffffb097          	auipc	ra,0xffffb
    80205fec:	c32080e7          	jalr	-974(ra) # 80200c1a <_Z6memcpyPvPKvj>
    myTask()->lock.unlock();
    80205ff0:	ffffc097          	auipc	ra,0xffffc
    80205ff4:	a1c080e7          	jalr	-1508(ra) # 80201a0c <_Z6myTaskv>
    80205ff8:	ffffb097          	auipc	ra,0xffffb
    80205ffc:	ed0080e7          	jalr	-304(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
  }
}
    80206000:	70a2                	ld	ra,40(sp)
    80206002:	7402                	ld	s0,32(sp)
    80206004:	64e2                	ld	s1,24(sp)
    80206006:	6942                	ld	s2,16(sp)
    80206008:	69a2                	ld	s3,8(sp)
    8020600a:	6145                	addi	sp,sp,48
    8020600c:	8082                	ret
    memcpy(newPath, oldpath, strlen(oldpath));
    8020600e:	854a                	mv	a0,s2
    80206010:	ffffb097          	auipc	ra,0xffffb
    80206014:	d3c080e7          	jalr	-708(ra) # 80200d4c <_Z6strlenPKc>
    80206018:	0005061b          	sext.w	a2,a0
    8020601c:	85ca                	mv	a1,s2
    8020601e:	854e                	mv	a0,s3
    80206020:	ffffb097          	auipc	ra,0xffffb
    80206024:	bfa080e7          	jalr	-1030(ra) # 80200c1a <_Z6memcpyPvPKvj>
    80206028:	bfe1                	j	80206000 <_ZN3vfs15getAbsolutePathEPcS0_+0x8a>

000000008020602a <_ZN3vfs4openEPKcm>:

  mount(FileSystemType::DEVFS, "/dev", "");
  mount(FileSystemType::FAT32, "/", "/dev/hda1");
}

int open(const char *filename, size_t flags) {
    8020602a:	7159                	addi	sp,sp,-112
    8020602c:	f486                	sd	ra,104(sp)
    8020602e:	f0a2                	sd	s0,96(sp)
    80206030:	eca6                	sd	s1,88(sp)
    80206032:	e8ca                	sd	s2,80(sp)
    80206034:	e4ce                	sd	s3,72(sp)
    80206036:	1880                	addi	s0,sp,112
    80206038:	84aa                	mv	s1,a0
    8020603a:	892e                	mv	s2,a1
  char path[MAXPATH];
  memset(path, 0, MAXPATH);
    8020603c:	04000613          	li	a2,64
    80206040:	4581                	li	a1,0
    80206042:	f9040513          	addi	a0,s0,-112
    80206046:	ffffb097          	auipc	ra,0xffffb
    8020604a:	b16080e7          	jalr	-1258(ra) # 80200b5c <_Z6memsetPvij>
    8020604e:	00005717          	auipc	a4,0x5
    80206052:	a9270713          	addi	a4,a4,-1390 # 8020aae0 <_ZTV15Fat32FileSystem+0x118>
    80206056:	07b00693          	li	a3,123
    8020605a:	00005617          	auipc	a2,0x5
    8020605e:	a8e60613          	addi	a2,a2,-1394 # 8020aae8 <_ZTV15Fat32FileSystem+0x120>
    80206062:	00004597          	auipc	a1,0x4
    80206066:	11658593          	addi	a1,a1,278 # 8020a178 <rodata_start+0x178>
    8020606a:	00004517          	auipc	a0,0x4
    8020606e:	11650513          	addi	a0,a0,278 # 8020a180 <rodata_start+0x180>
    80206072:	ffffa097          	auipc	ra,0xffffa
    80206076:	7e2080e7          	jalr	2018(ra) # 80200854 <_Z6printfPKcz>
  LOG_DEBUG("cwd=%s filename=%s\n", myTask()->currentDir, filename);
    8020607a:	ffffc097          	auipc	ra,0xffffc
    8020607e:	992080e7          	jalr	-1646(ra) # 80201a0c <_Z6myTaskv>
    80206082:	8626                	mv	a2,s1
    80206084:	09050593          	addi	a1,a0,144
    80206088:	00005517          	auipc	a0,0x5
    8020608c:	a7050513          	addi	a0,a0,-1424 # 8020aaf8 <_ZTV15Fat32FileSystem+0x130>
    80206090:	ffffa097          	auipc	ra,0xffffa
    80206094:	7c4080e7          	jalr	1988(ra) # 80200854 <_Z6printfPKcz>
    80206098:	00004517          	auipc	a0,0x4
    8020609c:	00850513          	addi	a0,a0,8 # 8020a0a0 <rodata_start+0xa0>
    802060a0:	ffffa097          	auipc	ra,0xffffa
    802060a4:	7b4080e7          	jalr	1972(ra) # 80200854 <_Z6printfPKcz>
  getAbsolutePath((char *)filename, path);
    802060a8:	f9040593          	addi	a1,s0,-112
    802060ac:	8526                	mv	a0,s1
    802060ae:	00000097          	auipc	ra,0x0
    802060b2:	ec8080e7          	jalr	-312(ra) # 80205f76 <_ZN3vfs15getAbsolutePathEPcS0_>

  auto fs = getFs(path);
    802060b6:	f9040513          	addi	a0,s0,-112
    802060ba:	00000097          	auipc	ra,0x0
    802060be:	e12080e7          	jalr	-494(ra) # 80205ecc <_ZN3vfs5getFsEPKc>
    802060c2:	89aa                	mv	s3,a0
    802060c4:	00005717          	auipc	a4,0x5
    802060c8:	a1c70713          	addi	a4,a4,-1508 # 8020aae0 <_ZTV15Fat32FileSystem+0x118>
    802060cc:	07f00693          	li	a3,127
    802060d0:	00005617          	auipc	a2,0x5
    802060d4:	a1860613          	addi	a2,a2,-1512 # 8020aae8 <_ZTV15Fat32FileSystem+0x120>
    802060d8:	00004597          	auipc	a1,0x4
    802060dc:	0a058593          	addi	a1,a1,160 # 8020a178 <rodata_start+0x178>
    802060e0:	00004517          	auipc	a0,0x4
    802060e4:	0a050513          	addi	a0,a0,160 # 8020a180 <rodata_start+0x180>
    802060e8:	ffffa097          	auipc	ra,0xffffa
    802060ec:	76c080e7          	jalr	1900(ra) # 80200854 <_Z6printfPKcz>
  LOG_DEBUG("open path=%s, fs mount point=%s", path, fs->mountPoint);
    802060f0:	00898613          	addi	a2,s3,8
    802060f4:	f9040593          	addi	a1,s0,-112
    802060f8:	00005517          	auipc	a0,0x5
    802060fc:	a1850513          	addi	a0,a0,-1512 # 8020ab10 <_ZTV15Fat32FileSystem+0x148>
    80206100:	ffffa097          	auipc	ra,0xffffa
    80206104:	754080e7          	jalr	1876(ra) # 80200854 <_Z6printfPKcz>
    80206108:	00004517          	auipc	a0,0x4
    8020610c:	f9850513          	addi	a0,a0,-104 # 8020a0a0 <rodata_start+0xa0>
    80206110:	ffffa097          	auipc	ra,0xffffa
    80206114:	744080e7          	jalr	1860(ra) # 80200854 <_Z6printfPKcz>
  struct file *fp = allocFileHandle();
    80206118:	00000097          	auipc	ra,0x0
    8020611c:	d30080e7          	jalr	-720(ra) # 80205e48 <_ZN3vfs15allocFileHandleEv>
    80206120:	84aa                	mv	s1,a0
  if (fs->open(path, flags, fp) == -1) {
    80206122:	0009b783          	ld	a5,0(s3)
    80206126:	679c                	ld	a5,8(a5)
    80206128:	86aa                	mv	a3,a0
    8020612a:	864a                	mv	a2,s2
    8020612c:	f9040593          	addi	a1,s0,-112
    80206130:	854e                	mv	a0,s3
    80206132:	9782                	jalr	a5
    80206134:	57fd                	li	a5,-1
    80206136:	0af50663          	beq	a0,a5,802061e2 <_ZN3vfs4openEPKcm+0x1b8>
    freeFileHandle(fp);
    return -1;
  }

  safestrcpy(fp->filepath, path, strlen(path) + 1);
    8020613a:	f9040513          	addi	a0,s0,-112
    8020613e:	ffffb097          	auipc	ra,0xffffb
    80206142:	c0e080e7          	jalr	-1010(ra) # 80200d4c <_Z6strlenPKc>
    80206146:	0015061b          	addiw	a2,a0,1
    8020614a:	f9040593          	addi	a1,s0,-112
    8020614e:	8526                	mv	a0,s1
    80206150:	ffffb097          	auipc	ra,0xffffb
    80206154:	bc8080e7          	jalr	-1080(ra) # 80200d18 <_Z10safestrcpyPcPKci>
  fp->readable = !(flags & O_WRONLY);
    80206158:	00194793          	xori	a5,s2,1
    8020615c:	8b85                	andi	a5,a5,1
    8020615e:	04f48a23          	sb	a5,84(s1)
  fp->writable = (flags & O_WRONLY) || (flags & O_RDWR);
    80206162:	00397913          	andi	s2,s2,3
    80206166:	01203933          	snez	s2,s2
    8020616a:	05248aa3          	sb	s2,85(s1)
  fp->ref++;
    8020616e:	48bc                	lw	a5,80(s1)
    80206170:	2785                	addiw	a5,a5,1
    80206172:	c8bc                	sw	a5,80(s1)
  int fd = registerFileHandle(fp);
    80206174:	55fd                	li	a1,-1
    80206176:	8526                	mv	a0,s1
    80206178:	ffffc097          	auipc	ra,0xffffc
    8020617c:	2e4080e7          	jalr	740(ra) # 8020245c <_Z18registerFileHandleP4filei>
    80206180:	89aa                	mv	s3,a0
    80206182:	00005717          	auipc	a4,0x5
    80206186:	95e70713          	addi	a4,a4,-1698 # 8020aae0 <_ZTV15Fat32FileSystem+0x118>
    8020618a:	08b00693          	li	a3,139
    8020618e:	00005617          	auipc	a2,0x5
    80206192:	95a60613          	addi	a2,a2,-1702 # 8020aae8 <_ZTV15Fat32FileSystem+0x120>
    80206196:	00004597          	auipc	a1,0x4
    8020619a:	fe258593          	addi	a1,a1,-30 # 8020a178 <rodata_start+0x178>
    8020619e:	00004517          	auipc	a0,0x4
    802061a2:	fe250513          	addi	a0,a0,-30 # 8020a180 <rodata_start+0x180>
    802061a6:	ffffa097          	auipc	ra,0xffffa
    802061aa:	6ae080e7          	jalr	1710(ra) # 80200854 <_Z6printfPKcz>
  LOG_DEBUG("fd=%d fp=%p fp->ref=%d", fd, fp);
    802061ae:	8626                	mv	a2,s1
    802061b0:	85ce                	mv	a1,s3
    802061b2:	00005517          	auipc	a0,0x5
    802061b6:	97e50513          	addi	a0,a0,-1666 # 8020ab30 <_ZTV15Fat32FileSystem+0x168>
    802061ba:	ffffa097          	auipc	ra,0xffffa
    802061be:	69a080e7          	jalr	1690(ra) # 80200854 <_Z6printfPKcz>
    802061c2:	00004517          	auipc	a0,0x4
    802061c6:	ede50513          	addi	a0,a0,-290 # 8020a0a0 <rodata_start+0xa0>
    802061ca:	ffffa097          	auipc	ra,0xffffa
    802061ce:	68a080e7          	jalr	1674(ra) # 80200854 <_Z6printfPKcz>
  return fd;
}
    802061d2:	854e                	mv	a0,s3
    802061d4:	70a6                	ld	ra,104(sp)
    802061d6:	7406                	ld	s0,96(sp)
    802061d8:	64e6                	ld	s1,88(sp)
    802061da:	6946                	ld	s2,80(sp)
    802061dc:	69a6                	ld	s3,72(sp)
    802061de:	6165                	addi	sp,sp,112
    802061e0:	8082                	ret
    802061e2:	89aa                	mv	s3,a0
    freeFileHandle(fp);
    802061e4:	8526                	mv	a0,s1
    802061e6:	00000097          	auipc	ra,0x0
    802061ea:	cc8080e7          	jalr	-824(ra) # 80205eae <_ZN3vfs14freeFileHandleEP4file>
    return -1;
    802061ee:	b7d5                	j	802061d2 <_ZN3vfs4openEPKcm+0x1a8>

00000000802061f0 <_ZN3vfs4readEibPcmm>:

size_t read(int fd, bool user, char *dst, size_t n, size_t offset) {
    802061f0:	7139                	addi	sp,sp,-64
    802061f2:	fc06                	sd	ra,56(sp)
    802061f4:	f822                	sd	s0,48(sp)
    802061f6:	f426                	sd	s1,40(sp)
    802061f8:	f04a                	sd	s2,32(sp)
    802061fa:	ec4e                	sd	s3,24(sp)
    802061fc:	e852                	sd	s4,16(sp)
    802061fe:	e456                	sd	s5,8(sp)
    80206200:	0080                	addi	s0,sp,64
    80206202:	8a2e                	mv	s4,a1
    80206204:	89b2                	mv	s3,a2
    80206206:	8936                	mv	s2,a3
  int r = 0;
  struct file *f = getFileByfd(fd);
    80206208:	ffffc097          	auipc	ra,0xffffc
    8020620c:	2f6080e7          	jalr	758(ra) # 802024fe <_Z11getFileByfdi>
  if (f == NULL || !f->readable) {
    80206210:	c56d                	beqz	a0,802062fa <_ZN3vfs4readEibPcmm+0x10a>
    80206212:	84aa                	mv	s1,a0
    80206214:	05454783          	lbu	a5,84(a0)
    return -1;
    80206218:	557d                	li	a0,-1
  if (f == NULL || !f->readable) {
    8020621a:	cbd9                	beqz	a5,802062b0 <_ZN3vfs4readEibPcmm+0xc0>
  }
  auto fs = getFs(f->filepath);
    8020621c:	8526                	mv	a0,s1
    8020621e:	00000097          	auipc	ra,0x0
    80206222:	cae080e7          	jalr	-850(ra) # 80205ecc <_ZN3vfs5getFsEPKc>
    80206226:	8aaa                	mv	s5,a0
    80206228:	00004717          	auipc	a4,0x4
    8020622c:	6c870713          	addi	a4,a4,1736 # 8020a8f0 <_ZL6digits+0x5e8>
    80206230:	09a00693          	li	a3,154
    80206234:	00005617          	auipc	a2,0x5
    80206238:	8b460613          	addi	a2,a2,-1868 # 8020aae8 <_ZTV15Fat32FileSystem+0x120>
    8020623c:	00004597          	auipc	a1,0x4
    80206240:	f3c58593          	addi	a1,a1,-196 # 8020a178 <rodata_start+0x178>
    80206244:	00004517          	auipc	a0,0x4
    80206248:	f3c50513          	addi	a0,a0,-196 # 8020a180 <rodata_start+0x180>
    8020624c:	ffffa097          	auipc	ra,0xffffa
    80206250:	608080e7          	jalr	1544(ra) # 80200854 <_Z6printfPKcz>

  // if () strncpy(path, dir, strlen(dir));
  // strncpy(path + strlen(dir), f->file_name, strlen(f->file_name));

  LOG_DEBUG("read filename=%s", f->filepath);
    80206254:	85a6                	mv	a1,s1
    80206256:	00005517          	auipc	a0,0x5
    8020625a:	8f250513          	addi	a0,a0,-1806 # 8020ab48 <_ZTV15Fat32FileSystem+0x180>
    8020625e:	ffffa097          	auipc	ra,0xffffa
    80206262:	5f6080e7          	jalr	1526(ra) # 80200854 <_Z6printfPKcz>
    80206266:	00004517          	auipc	a0,0x4
    8020626a:	e3a50513          	addi	a0,a0,-454 # 8020a0a0 <rodata_start+0xa0>
    8020626e:	ffffa097          	auipc	ra,0xffffa
    80206272:	5e6080e7          	jalr	1510(ra) # 80200854 <_Z6printfPKcz>

  switch (f->type) {
    80206276:	4cbc                	lw	a5,88(s1)
    80206278:	4709                	li	a4,2
    8020627a:	06e78263          	beq	a5,a4,802062de <_ZN3vfs4readEibPcmm+0xee>
    8020627e:	470d                	li	a4,3
    80206280:	04e78163          	beq	a5,a4,802062c2 <_ZN3vfs4readEibPcmm+0xd2>
    80206284:	4705                	li	a4,1
    80206286:	00e78c63          	beq	a5,a4,8020629e <_ZN3vfs4readEibPcmm+0xae>
      break;
    case f->FD_ENTRY:
      r = fs->read(f->filepath, user, dst, f->position, n);
      break;
    default:
      panic("vfs::read");
    8020628a:	00005517          	auipc	a0,0x5
    8020628e:	8d650513          	addi	a0,a0,-1834 # 8020ab60 <_ZTV15Fat32FileSystem+0x198>
    80206292:	ffffa097          	auipc	ra,0xffffa
    80206296:	550080e7          	jalr	1360(ra) # 802007e2 <_Z5panicPKc>
  int r = 0;
    8020629a:	4501                	li	a0,0
  }
  return r;
    8020629c:	a811                	j	802062b0 <_ZN3vfs4readEibPcmm+0xc0>
      panic("vfs::read");
    8020629e:	00005517          	auipc	a0,0x5
    802062a2:	8c250513          	addi	a0,a0,-1854 # 8020ab60 <_ZTV15Fat32FileSystem+0x198>
    802062a6:	ffffa097          	auipc	ra,0xffffa
    802062aa:	53c080e7          	jalr	1340(ra) # 802007e2 <_Z5panicPKc>
  int r = 0;
    802062ae:	4501                	li	a0,0
}
    802062b0:	70e2                	ld	ra,56(sp)
    802062b2:	7442                	ld	s0,48(sp)
    802062b4:	74a2                	ld	s1,40(sp)
    802062b6:	7902                	ld	s2,32(sp)
    802062b8:	69e2                	ld	s3,24(sp)
    802062ba:	6a42                	ld	s4,16(sp)
    802062bc:	6aa2                	ld	s5,8(sp)
    802062be:	6121                	addi	sp,sp,64
    802062c0:	8082                	ret
      r = fs->read(f->filepath, user, dst, 0, n);
    802062c2:	000ab783          	ld	a5,0(s5) # 10000000 <_entry-0x70200000>
    802062c6:	0107b803          	ld	a6,16(a5)
    802062ca:	0009079b          	sext.w	a5,s2
    802062ce:	4701                	li	a4,0
    802062d0:	86ce                	mv	a3,s3
    802062d2:	8652                	mv	a2,s4
    802062d4:	85a6                	mv	a1,s1
    802062d6:	8556                	mv	a0,s5
    802062d8:	9802                	jalr	a6
    802062da:	2501                	sext.w	a0,a0
      break;
    802062dc:	bfd1                	j	802062b0 <_ZN3vfs4readEibPcmm+0xc0>
      r = fs->read(f->filepath, user, dst, f->position, n);
    802062de:	000ab783          	ld	a5,0(s5)
    802062e2:	0107b803          	ld	a6,16(a5)
    802062e6:	0009079b          	sext.w	a5,s2
    802062ea:	54b8                	lw	a4,104(s1)
    802062ec:	86ce                	mv	a3,s3
    802062ee:	8652                	mv	a2,s4
    802062f0:	85a6                	mv	a1,s1
    802062f2:	8556                	mv	a0,s5
    802062f4:	9802                	jalr	a6
    802062f6:	2501                	sext.w	a0,a0
      break;
    802062f8:	bf65                	j	802062b0 <_ZN3vfs4readEibPcmm+0xc0>
    return -1;
    802062fa:	557d                	li	a0,-1
    802062fc:	bf55                	j	802062b0 <_ZN3vfs4readEibPcmm+0xc0>

00000000802062fe <_ZN3vfs5writeEibPKcmm>:

size_t write(int fd, bool user, const char *buffer, size_t count, size_t offset) {
    802062fe:	7179                	addi	sp,sp,-48
    80206300:	f406                	sd	ra,40(sp)
    80206302:	f022                	sd	s0,32(sp)
    80206304:	ec26                	sd	s1,24(sp)
    80206306:	e84a                	sd	s2,16(sp)
    80206308:	e44e                	sd	s3,8(sp)
    8020630a:	e052                	sd	s4,0(sp)
    8020630c:	1800                	addi	s0,sp,48
    8020630e:	8a2e                	mv	s4,a1
    80206310:	89b2                	mv	s3,a2
    80206312:	8936                	mv	s2,a3
  int r = 0;
  struct file *f = getFileByfd(fd);
    80206314:	ffffc097          	auipc	ra,0xffffc
    80206318:	1ea080e7          	jalr	490(ra) # 802024fe <_Z11getFileByfdi>

  if (f == NULL || !f->readable) {
    8020631c:	c14d                	beqz	a0,802063be <_ZN3vfs5writeEibPKcmm+0xc0>
    8020631e:	84aa                	mv	s1,a0
    80206320:	05454783          	lbu	a5,84(a0)
    return -1;
    80206324:	557d                	li	a0,-1
  if (f == NULL || !f->readable) {
    80206326:	cba1                	beqz	a5,80206376 <_ZN3vfs5writeEibPKcmm+0x78>
  }

  auto fs = getFs(f->filepath);
    80206328:	8526                	mv	a0,s1
    8020632a:	00000097          	auipc	ra,0x0
    8020632e:	ba2080e7          	jalr	-1118(ra) # 80205ecc <_ZN3vfs5getFsEPKc>
    80206332:	882a                	mv	a6,a0

  if (f == NULL || !f->writable) {
    80206334:	0554c783          	lbu	a5,85(s1)
    return -1;
    80206338:	557d                	li	a0,-1
  if (f == NULL || !f->writable) {
    8020633a:	cf95                	beqz	a5,80206376 <_ZN3vfs5writeEibPKcmm+0x78>
  }

  LOG_TRACE("write filename=%s", f->filepath);

  switch (f->type) {
    8020633c:	4cbc                	lw	a5,88(s1)
    8020633e:	4709                	li	a4,2
    80206340:	06e78163          	beq	a5,a4,802063a2 <_ZN3vfs5writeEibPKcmm+0xa4>
    80206344:	470d                	li	a4,3
    80206346:	04e78063          	beq	a5,a4,80206386 <_ZN3vfs5writeEibPKcmm+0x88>
    8020634a:	4705                	li	a4,1
    8020634c:	00e78c63          	beq	a5,a4,80206364 <_ZN3vfs5writeEibPKcmm+0x66>
    case f->FD_ENTRY:
      // fat32->read(f->filepath, user, dst, f->position, 0);
      fs->write(f->filepath, user, buffer, 0, count);
      break;
    default:
      panic("vfs::write");
    80206350:	00005517          	auipc	a0,0x5
    80206354:	82050513          	addi	a0,a0,-2016 # 8020ab70 <_ZTV15Fat32FileSystem+0x1a8>
    80206358:	ffffa097          	auipc	ra,0xffffa
    8020635c:	48a080e7          	jalr	1162(ra) # 802007e2 <_Z5panicPKc>
      return 0;
    80206360:	4501                	li	a0,0
    80206362:	a811                	j	80206376 <_ZN3vfs5writeEibPKcmm+0x78>
      panic("vfs::write");
    80206364:	00005517          	auipc	a0,0x5
    80206368:	80c50513          	addi	a0,a0,-2036 # 8020ab70 <_ZTV15Fat32FileSystem+0x1a8>
    8020636c:	ffffa097          	auipc	ra,0xffffa
    80206370:	476080e7          	jalr	1142(ra) # 802007e2 <_Z5panicPKc>
  int r = 0;
    80206374:	4501                	li	a0,0
  }
  return r;
}
    80206376:	70a2                	ld	ra,40(sp)
    80206378:	7402                	ld	s0,32(sp)
    8020637a:	64e2                	ld	s1,24(sp)
    8020637c:	6942                	ld	s2,16(sp)
    8020637e:	69a2                	ld	s3,8(sp)
    80206380:	6a02                	ld	s4,0(sp)
    80206382:	6145                	addi	sp,sp,48
    80206384:	8082                	ret
      r = fs->write(f->filepath, user, buffer, 0, count);
    80206386:	00083783          	ld	a5,0(a6)
    8020638a:	0187b883          	ld	a7,24(a5)
    8020638e:	0009079b          	sext.w	a5,s2
    80206392:	4701                	li	a4,0
    80206394:	86ce                	mv	a3,s3
    80206396:	8652                	mv	a2,s4
    80206398:	85a6                	mv	a1,s1
    8020639a:	8542                	mv	a0,a6
    8020639c:	9882                	jalr	a7
    8020639e:	2501                	sext.w	a0,a0
      break;
    802063a0:	bfd9                	j	80206376 <_ZN3vfs5writeEibPKcmm+0x78>
      fs->write(f->filepath, user, buffer, 0, count);
    802063a2:	00083783          	ld	a5,0(a6)
    802063a6:	0187b883          	ld	a7,24(a5)
    802063aa:	0009079b          	sext.w	a5,s2
    802063ae:	4701                	li	a4,0
    802063b0:	86ce                	mv	a3,s3
    802063b2:	8652                	mv	a2,s4
    802063b4:	85a6                	mv	a1,s1
    802063b6:	8542                	mv	a0,a6
    802063b8:	9882                	jalr	a7
  int r = 0;
    802063ba:	4501                	li	a0,0
      break;
    802063bc:	bf6d                	j	80206376 <_ZN3vfs5writeEibPKcmm+0x78>
    return -1;
    802063be:	557d                	li	a0,-1
    802063c0:	bf5d                	j	80206376 <_ZN3vfs5writeEibPKcmm+0x78>

00000000802063c2 <_ZN3vfs5closeEP4file>:

// 递减ref，当ref = 0时关闭
void close(struct file *fp) {
    802063c2:	1101                	addi	sp,sp,-32
    802063c4:	ec06                	sd	ra,24(sp)
    802063c6:	e822                	sd	s0,16(sp)
    802063c8:	e426                	sd	s1,8(sp)
    802063ca:	1000                	addi	s0,sp,32
    802063cc:	84aa                	mv	s1,a0
  struct file ff;
  fileTableLock.lock();
    802063ce:	0008a517          	auipc	a0,0x8a
    802063d2:	1f250513          	addi	a0,a0,498 # 802905c0 <_ZN3vfs13fileTableLockE>
    802063d6:	ffffb097          	auipc	ra,0xffffb
    802063da:	a76080e7          	jalr	-1418(ra) # 80200e4c <_ZN8SpinLock4lockEv>
  if (fp->ref < 1) {
    802063de:	48bc                	lw	a5,80(s1)
    802063e0:	02f05a63          	blez	a5,80206414 <_ZN3vfs5closeEP4file+0x52>
    panic("vfs::close");
  }
  if (--fp->ref > 0) {
    802063e4:	48bc                	lw	a5,80(s1)
    802063e6:	37fd                	addiw	a5,a5,-1
    802063e8:	0007871b          	sext.w	a4,a5
    802063ec:	c8bc                	sw	a5,80(s1)
    802063ee:	02e04c63          	bgtz	a4,80206426 <_ZN3vfs5closeEP4file+0x64>
    fileTableLock.unlock();
    return;
  }
  ff = *fp;
  fp->type = fp->FD_NONE;
    802063f2:	0404ac23          	sw	zero,88(s1)
  fp->ref = 0;
    802063f6:	0404a823          	sw	zero,80(s1)
  fileTableLock.unlock();
    802063fa:	0008a517          	auipc	a0,0x8a
    802063fe:	1c650513          	addi	a0,a0,454 # 802905c0 <_ZN3vfs13fileTableLockE>
    80206402:	ffffb097          	auipc	ra,0xffffb
    80206406:	ac6080e7          	jalr	-1338(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>

  if (ff.type == ff.FD_PIPE) {
  } else if (ff.type == ff.FD_ENTRY) {
  } else if (ff.type == ff.FD_DEVICE) {
  }
};
    8020640a:	60e2                	ld	ra,24(sp)
    8020640c:	6442                	ld	s0,16(sp)
    8020640e:	64a2                	ld	s1,8(sp)
    80206410:	6105                	addi	sp,sp,32
    80206412:	8082                	ret
    panic("vfs::close");
    80206414:	00004517          	auipc	a0,0x4
    80206418:	76c50513          	addi	a0,a0,1900 # 8020ab80 <_ZTV15Fat32FileSystem+0x1b8>
    8020641c:	ffffa097          	auipc	ra,0xffffa
    80206420:	3c6080e7          	jalr	966(ra) # 802007e2 <_Z5panicPKc>
    80206424:	b7c1                	j	802063e4 <_ZN3vfs5closeEP4file+0x22>
    fileTableLock.unlock();
    80206426:	0008a517          	auipc	a0,0x8a
    8020642a:	19a50513          	addi	a0,a0,410 # 802905c0 <_ZN3vfs13fileTableLockE>
    8020642e:	ffffb097          	auipc	ra,0xffffb
    80206432:	a9a080e7          	jalr	-1382(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
    return;
    80206436:	bfd1                	j	8020640a <_ZN3vfs5closeEP4file+0x48>

0000000080206438 <_ZN3vfs7mkdiratEiPKc>:

int mkdirat(int dirfd, const char *filepath) {
    80206438:	711d                	addi	sp,sp,-96
    8020643a:	ec86                	sd	ra,88(sp)
    8020643c:	e8a2                	sd	s0,80(sp)
    8020643e:	e4a6                	sd	s1,72(sp)
    80206440:	e0ca                	sd	s2,64(sp)
    80206442:	1080                	addi	s0,sp,96
    80206444:	892a                	mv	s2,a0
    80206446:	84ae                	mv	s1,a1
  char path[MAXPATH];
  memset(path, 0, MAXPATH);
    80206448:	04000613          	li	a2,64
    8020644c:	4581                	li	a1,0
    8020644e:	fa040513          	addi	a0,s0,-96
    80206452:	ffffa097          	auipc	ra,0xffffa
    80206456:	70a080e7          	jalr	1802(ra) # 80200b5c <_Z6memsetPvij>
  struct file *fp;
  if (dirfd == AT_FDCWD) {
    8020645a:	f9c00793          	li	a5,-100
    8020645e:	08f90263          	beq	s2,a5,802064e2 <_ZN3vfs7mkdiratEiPKc+0xaa>
    getAbsolutePath((char *)filepath, path);
  } else {
    if (filepath[0] == '/') {
    80206462:	0004c703          	lbu	a4,0(s1)
    80206466:	02f00793          	li	a5,47
    8020646a:	08f70463          	beq	a4,a5,802064f2 <_ZN3vfs7mkdiratEiPKc+0xba>
      memcpy(path, filepath, strlen(filepath));
    } else {
      fp = getFileByfd(dirfd);
    8020646e:	854a                	mv	a0,s2
    80206470:	ffffc097          	auipc	ra,0xffffc
    80206474:	08e080e7          	jalr	142(ra) # 802024fe <_Z11getFileByfdi>
    80206478:	892a                	mv	s2,a0
      memcpy(path, fp->filepath, strlen(fp->filepath));
    8020647a:	ffffb097          	auipc	ra,0xffffb
    8020647e:	8d2080e7          	jalr	-1838(ra) # 80200d4c <_Z6strlenPKc>
    80206482:	0005061b          	sext.w	a2,a0
    80206486:	85ca                	mv	a1,s2
    80206488:	fa040513          	addi	a0,s0,-96
    8020648c:	ffffa097          	auipc	ra,0xffffa
    80206490:	78e080e7          	jalr	1934(ra) # 80200c1a <_Z6memcpyPvPKvj>
      memcpy(path + strlen(fp->filepath), filepath, strlen(filepath));
    80206494:	854a                	mv	a0,s2
    80206496:	ffffb097          	auipc	ra,0xffffb
    8020649a:	8b6080e7          	jalr	-1866(ra) # 80200d4c <_Z6strlenPKc>
    8020649e:	892a                	mv	s2,a0
    802064a0:	8526                	mv	a0,s1
    802064a2:	ffffb097          	auipc	ra,0xffffb
    802064a6:	8aa080e7          	jalr	-1878(ra) # 80200d4c <_Z6strlenPKc>
    802064aa:	0005061b          	sext.w	a2,a0
    802064ae:	85a6                	mv	a1,s1
    802064b0:	fa040793          	addi	a5,s0,-96
    802064b4:	01278533          	add	a0,a5,s2
    802064b8:	ffffa097          	auipc	ra,0xffffa
    802064bc:	762080e7          	jalr	1890(ra) # 80200c1a <_Z6memcpyPvPKvj>
    }
  }
  printf("mkdir=%s\n", path);
    802064c0:	fa040593          	addi	a1,s0,-96
    802064c4:	00004517          	auipc	a0,0x4
    802064c8:	6cc50513          	addi	a0,a0,1740 # 8020ab90 <_ZTV15Fat32FileSystem+0x1c8>
    802064cc:	ffffa097          	auipc	ra,0xffffa
    802064d0:	388080e7          	jalr	904(ra) # 80200854 <_Z6printfPKcz>
  // auto fs = getFs(path);
  // return fs->mkdir(path);
  return 0;
};
    802064d4:	4501                	li	a0,0
    802064d6:	60e6                	ld	ra,88(sp)
    802064d8:	6446                	ld	s0,80(sp)
    802064da:	64a6                	ld	s1,72(sp)
    802064dc:	6906                	ld	s2,64(sp)
    802064de:	6125                	addi	sp,sp,96
    802064e0:	8082                	ret
    getAbsolutePath((char *)filepath, path);
    802064e2:	fa040593          	addi	a1,s0,-96
    802064e6:	8526                	mv	a0,s1
    802064e8:	00000097          	auipc	ra,0x0
    802064ec:	a8e080e7          	jalr	-1394(ra) # 80205f76 <_ZN3vfs15getAbsolutePathEPcS0_>
    802064f0:	bfc1                	j	802064c0 <_ZN3vfs7mkdiratEiPKc+0x88>
      memcpy(path, filepath, strlen(filepath));
    802064f2:	8526                	mv	a0,s1
    802064f4:	ffffb097          	auipc	ra,0xffffb
    802064f8:	858080e7          	jalr	-1960(ra) # 80200d4c <_Z6strlenPKc>
    802064fc:	0005061b          	sext.w	a2,a0
    80206500:	85a6                	mv	a1,s1
    80206502:	fa040513          	addi	a0,s0,-96
    80206506:	ffffa097          	auipc	ra,0xffffa
    8020650a:	714080e7          	jalr	1812(ra) # 80200c1a <_Z6memcpyPvPKvj>
    8020650e:	bf4d                	j	802064c0 <_ZN3vfs7mkdiratEiPKc+0x88>

0000000080206510 <_ZN3vfs2rmEPKc>:

void rm(const char *file){};
    80206510:	1141                	addi	sp,sp,-16
    80206512:	e422                	sd	s0,8(sp)
    80206514:	0800                	addi	s0,sp,16
    80206516:	6422                	ld	s0,8(sp)
    80206518:	0141                	addi	sp,sp,16
    8020651a:	8082                	ret

000000008020651c <_ZN3vfs5clearEimm>:

size_t clear(int fd, size_t count, size_t offset) { return 0; }
    8020651c:	1141                	addi	sp,sp,-16
    8020651e:	e422                	sd	s0,8(sp)
    80206520:	0800                	addi	s0,sp,16
    80206522:	4501                	li	a0,0
    80206524:	6422                	ld	s0,8(sp)
    80206526:	0141                	addi	sp,sp,16
    80206528:	8082                	ret

000000008020652a <_ZN3vfs8truncateEim>:

void truncate(int fd, size_t size) {}
    8020652a:	1141                	addi	sp,sp,-16
    8020652c:	e422                	sd	s0,8(sp)
    8020652e:	0800                	addi	s0,sp,16
    80206530:	6422                	ld	s0,8(sp)
    80206532:	0141                	addi	sp,sp,16
    80206534:	8082                	ret

0000000080206536 <_ZN3vfs2lsEiPcb>:

size_t ls(int fd, char *buffer, bool user=false) {
    80206536:	7179                	addi	sp,sp,-48
    80206538:	f406                	sd	ra,40(sp)
    8020653a:	f022                	sd	s0,32(sp)
    8020653c:	ec26                	sd	s1,24(sp)
    8020653e:	e84a                	sd	s2,16(sp)
    80206540:	e44e                	sd	s3,8(sp)
    80206542:	e052                	sd	s4,0(sp)
    80206544:	1800                	addi	s0,sp,48
    80206546:	892e                	mv	s2,a1
    80206548:	89b2                	mv	s3,a2
  struct file *fp = getFileByfd(fd);
    8020654a:	ffffc097          	auipc	ra,0xffffc
    8020654e:	fb4080e7          	jalr	-76(ra) # 802024fe <_Z11getFileByfdi>
  if (fp == NULL || !fp->directory) {
    80206552:	c141                	beqz	a0,802065d2 <_ZN3vfs2lsEiPcb+0x9c>
    80206554:	84aa                	mv	s1,a0
    80206556:	04054783          	lbu	a5,64(a0)
    8020655a:	cfa5                	beqz	a5,802065d2 <_ZN3vfs2lsEiPcb+0x9c>
    LOG_DEBUG("not directory");
    return -1;
  }
  auto fs = getFs(fp->filepath);
    8020655c:	00000097          	auipc	ra,0x0
    80206560:	970080e7          	jalr	-1680(ra) # 80205ecc <_ZN3vfs5getFsEPKc>
    80206564:	8a2a                	mv	s4,a0
    80206566:	00004717          	auipc	a4,0x4
    8020656a:	37270713          	addi	a4,a4,882 # 8020a8d8 <_ZL6digits+0x5d0>
    8020656e:	10a00693          	li	a3,266
    80206572:	00004617          	auipc	a2,0x4
    80206576:	57660613          	addi	a2,a2,1398 # 8020aae8 <_ZTV15Fat32FileSystem+0x120>
    8020657a:	00004597          	auipc	a1,0x4
    8020657e:	bfe58593          	addi	a1,a1,-1026 # 8020a178 <rodata_start+0x178>
    80206582:	00004517          	auipc	a0,0x4
    80206586:	bfe50513          	addi	a0,a0,-1026 # 8020a180 <rodata_start+0x180>
    8020658a:	ffffa097          	auipc	ra,0xffffa
    8020658e:	2ca080e7          	jalr	714(ra) # 80200854 <_Z6printfPKcz>
  LOG_DEBUG("ls");
    80206592:	00004517          	auipc	a0,0x4
    80206596:	34650513          	addi	a0,a0,838 # 8020a8d8 <_ZL6digits+0x5d0>
    8020659a:	ffffa097          	auipc	ra,0xffffa
    8020659e:	2ba080e7          	jalr	698(ra) # 80200854 <_Z6printfPKcz>
    802065a2:	00004517          	auipc	a0,0x4
    802065a6:	afe50513          	addi	a0,a0,-1282 # 8020a0a0 <rodata_start+0xa0>
    802065aa:	ffffa097          	auipc	ra,0xffffa
    802065ae:	2aa080e7          	jalr	682(ra) # 80200854 <_Z6printfPKcz>
  return fs->ls(fp->filepath, buffer, user);
    802065b2:	000a3783          	ld	a5,0(s4)
    802065b6:	7f9c                	ld	a5,56(a5)
    802065b8:	86ce                	mv	a3,s3
    802065ba:	864a                	mv	a2,s2
    802065bc:	85a6                	mv	a1,s1
    802065be:	8552                	mv	a0,s4
    802065c0:	9782                	jalr	a5
}
    802065c2:	70a2                	ld	ra,40(sp)
    802065c4:	7402                	ld	s0,32(sp)
    802065c6:	64e2                	ld	s1,24(sp)
    802065c8:	6942                	ld	s2,16(sp)
    802065ca:	69a2                	ld	s3,8(sp)
    802065cc:	6a02                	ld	s4,0(sp)
    802065ce:	6145                	addi	sp,sp,48
    802065d0:	8082                	ret
    802065d2:	00004717          	auipc	a4,0x4
    802065d6:	30670713          	addi	a4,a4,774 # 8020a8d8 <_ZL6digits+0x5d0>
    802065da:	10600693          	li	a3,262
    802065de:	00004617          	auipc	a2,0x4
    802065e2:	50a60613          	addi	a2,a2,1290 # 8020aae8 <_ZTV15Fat32FileSystem+0x120>
    802065e6:	00004597          	auipc	a1,0x4
    802065ea:	b9258593          	addi	a1,a1,-1134 # 8020a178 <rodata_start+0x178>
    802065ee:	00004517          	auipc	a0,0x4
    802065f2:	b9250513          	addi	a0,a0,-1134 # 8020a180 <rodata_start+0x180>
    802065f6:	ffffa097          	auipc	ra,0xffffa
    802065fa:	25e080e7          	jalr	606(ra) # 80200854 <_Z6printfPKcz>
    LOG_DEBUG("not directory");
    802065fe:	00004517          	auipc	a0,0x4
    80206602:	5a250513          	addi	a0,a0,1442 # 8020aba0 <_ZTV15Fat32FileSystem+0x1d8>
    80206606:	ffffa097          	auipc	ra,0xffffa
    8020660a:	24e080e7          	jalr	590(ra) # 80200854 <_Z6printfPKcz>
    8020660e:	00004517          	auipc	a0,0x4
    80206612:	a9250513          	addi	a0,a0,-1390 # 8020a0a0 <rodata_start+0xa0>
    80206616:	ffffa097          	auipc	ra,0xffffa
    8020661a:	23e080e7          	jalr	574(ra) # 80200854 <_Z6printfPKcz>
    return -1;
    8020661e:	557d                	li	a0,-1
    80206620:	b74d                	j	802065c2 <_ZN3vfs2lsEiPcb+0x8c>

0000000080206622 <_ZN3vfs6mountsEPcm>:

size_t mounts(char *buffer, size_t size) { return 0; }
    80206622:	1141                	addi	sp,sp,-16
    80206624:	e422                	sd	s0,8(sp)
    80206626:	0800                	addi	s0,sp,16
    80206628:	4501                	li	a0,0
    8020662a:	6422                	ld	s0,8(sp)
    8020662c:	0141                	addi	sp,sp,16
    8020662e:	8082                	ret

0000000080206630 <_ZN3vfs5mountENS_14FileSystemTypeEPKcS2_>:

void mount(FileSystemType type, const char *mountPoint, const char *device) {
    80206630:	1101                	addi	sp,sp,-32
    80206632:	ec06                	sd	ra,24(sp)
    80206634:	e822                	sd	s0,16(sp)
    80206636:	e426                	sd	s1,8(sp)
    80206638:	1000                	addi	s0,sp,32
  auto fs = createFileSystem(type, mountPoint, device);
    8020663a:	fffff097          	auipc	ra,0xfffff
    8020663e:	726080e7          	jalr	1830(ra) # 80205d60 <_ZN3vfs16createFileSystemENS_14FileSystemTypeEPKcS2_>
    80206642:	84aa                	mv	s1,a0
  fs->init();
    80206644:	611c                	ld	a5,0(a0)
    80206646:	639c                	ld	a5,0(a5)
    80206648:	9782                	jalr	a5
  for (int i = 0; i < NFILESYSTEM; i++) {
    8020664a:	0008a717          	auipc	a4,0x8a
    8020664e:	f8e70713          	addi	a4,a4,-114 # 802905d8 <_ZN3vfs9mountedFSE>
    80206652:	4781                	li	a5,0
    80206654:	4615                	li	a2,5
    if (mountedFS[i] == NULL) {
    80206656:	6314                	ld	a3,0(a4)
    80206658:	c295                	beqz	a3,8020667c <_ZN3vfs5mountENS_14FileSystemTypeEPKcS2_+0x4c>
  for (int i = 0; i < NFILESYSTEM; i++) {
    8020665a:	2785                	addiw	a5,a5,1
    8020665c:	0721                	addi	a4,a4,8
    8020665e:	fec79ce3          	bne	a5,a2,80206656 <_ZN3vfs5mountENS_14FileSystemTypeEPKcS2_+0x26>
      mountedFS[i] = fs;
      return;
    }
  }
  panic("mount file system");
    80206662:	00004517          	auipc	a0,0x4
    80206666:	54e50513          	addi	a0,a0,1358 # 8020abb0 <_ZTV15Fat32FileSystem+0x1e8>
    8020666a:	ffffa097          	auipc	ra,0xffffa
    8020666e:	178080e7          	jalr	376(ra) # 802007e2 <_Z5panicPKc>
}
    80206672:	60e2                	ld	ra,24(sp)
    80206674:	6442                	ld	s0,16(sp)
    80206676:	64a2                	ld	s1,8(sp)
    80206678:	6105                	addi	sp,sp,32
    8020667a:	8082                	ret
      mountedFS[i] = fs;
    8020667c:	078e                	slli	a5,a5,0x3
    8020667e:	0008a717          	auipc	a4,0x8a
    80206682:	f4270713          	addi	a4,a4,-190 # 802905c0 <_ZN3vfs13fileTableLockE>
    80206686:	97ba                	add	a5,a5,a4
    80206688:	ef84                	sd	s1,24(a5)
      return;
    8020668a:	b7e5                	j	80206672 <_ZN3vfs5mountENS_14FileSystemTypeEPKcS2_+0x42>

000000008020668c <_ZN3vfs4initEv>:
void init() {
    8020668c:	1141                	addi	sp,sp,-16
    8020668e:	e406                	sd	ra,8(sp)
    80206690:	e022                	sd	s0,0(sp)
    80206692:	0800                	addi	s0,sp,16
    mountedFS[i] = NULL;
    80206694:	0008a797          	auipc	a5,0x8a
    80206698:	f2c78793          	addi	a5,a5,-212 # 802905c0 <_ZN3vfs13fileTableLockE>
    8020669c:	0007bc23          	sd	zero,24(a5)
    802066a0:	0207b023          	sd	zero,32(a5)
    802066a4:	0207b423          	sd	zero,40(a5)
    802066a8:	0207b823          	sd	zero,48(a5)
    802066ac:	0207bc23          	sd	zero,56(a5)
  memset(fileTable, 0, sizeof(struct file) * NFILE);
    802066b0:	660d                	lui	a2,0x3
    802066b2:	bc060613          	addi	a2,a2,-1088 # 2bc0 <_entry-0x801fd440>
    802066b6:	4581                	li	a1,0
    802066b8:	0008a517          	auipc	a0,0x8a
    802066bc:	f4850513          	addi	a0,a0,-184 # 80290600 <_ZN3vfs9fileTableE>
    802066c0:	ffffa097          	auipc	ra,0xffffa
    802066c4:	49c080e7          	jalr	1180(ra) # 80200b5c <_Z6memsetPvij>
  for (fp = fileTable; fp < fileTable + NFILE; fp++) {
    802066c8:	0008a797          	auipc	a5,0x8a
    802066cc:	f3878793          	addi	a5,a5,-200 # 80290600 <_ZN3vfs9fileTableE>
    802066d0:	0008d717          	auipc	a4,0x8d
    802066d4:	af070713          	addi	a4,a4,-1296 # 802931c0 <kernel_pagetable>
    fp->type = fp->FD_NONE;
    802066d8:	0407ac23          	sw	zero,88(a5)
  for (fp = fileTable; fp < fileTable + NFILE; fp++) {
    802066dc:	07078793          	addi	a5,a5,112
    802066e0:	fee79ce3          	bne	a5,a4,802066d8 <_ZN3vfs4initEv+0x4c>
  fileTableLock.init("fileTable");
    802066e4:	00004597          	auipc	a1,0x4
    802066e8:	4e458593          	addi	a1,a1,1252 # 8020abc8 <_ZTV15Fat32FileSystem+0x200>
    802066ec:	0008a517          	auipc	a0,0x8a
    802066f0:	ed450513          	addi	a0,a0,-300 # 802905c0 <_ZN3vfs13fileTableLockE>
    802066f4:	ffffa097          	auipc	ra,0xffffa
    802066f8:	702080e7          	jalr	1794(ra) # 80200df6 <_ZN8SpinLock4initEPKc>
  mount(FileSystemType::DEVFS, "/dev", "");
    802066fc:	00004617          	auipc	a2,0x4
    80206700:	e5460613          	addi	a2,a2,-428 # 8020a550 <_ZL6digits+0x248>
    80206704:	00004597          	auipc	a1,0x4
    80206708:	4d458593          	addi	a1,a1,1236 # 8020abd8 <_ZTV15Fat32FileSystem+0x210>
    8020670c:	450d                	li	a0,3
    8020670e:	00000097          	auipc	ra,0x0
    80206712:	f22080e7          	jalr	-222(ra) # 80206630 <_ZN3vfs5mountENS_14FileSystemTypeEPKcS2_>
  mount(FileSystemType::FAT32, "/", "/dev/hda1");
    80206716:	00004617          	auipc	a2,0x4
    8020671a:	4ca60613          	addi	a2,a2,1226 # 8020abe0 <_ZTV15Fat32FileSystem+0x218>
    8020671e:	00004597          	auipc	a1,0x4
    80206722:	22258593          	addi	a1,a1,546 # 8020a940 <_ZL6digits+0x638>
    80206726:	4505                	li	a0,1
    80206728:	00000097          	auipc	ra,0x0
    8020672c:	f08080e7          	jalr	-248(ra) # 80206630 <_ZN3vfs5mountENS_14FileSystemTypeEPKcS2_>
}
    80206730:	60a2                	ld	ra,8(sp)
    80206732:	6402                	ld	s0,0(sp)
    80206734:	0141                	addi	sp,sp,16
    80206736:	8082                	ret

0000000080206738 <_ZN3vfs11direct_readEPKcPcmm>:

size_t direct_read(const char *file, char *buffer, size_t count, size_t offset) {
    80206738:	7179                	addi	sp,sp,-48
    8020673a:	f406                	sd	ra,40(sp)
    8020673c:	f022                	sd	s0,32(sp)
    8020673e:	ec26                	sd	s1,24(sp)
    80206740:	e84a                	sd	s2,16(sp)
    80206742:	e44e                	sd	s3,8(sp)
    80206744:	e052                	sd	s4,0(sp)
    80206746:	1800                	addi	s0,sp,48
    80206748:	84aa                	mv	s1,a0
    8020674a:	892e                	mv	s2,a1
    8020674c:	8a32                	mv	s4,a2
    8020674e:	89b6                	mv	s3,a3
  auto fs = getFs(file);
    80206750:	fffff097          	auipc	ra,0xfffff
    80206754:	77c080e7          	jalr	1916(ra) # 80205ecc <_ZN3vfs5getFsEPKc>
  LOG_TRACE("fs mount point=%s", fs->mountPoint);
  int r = fs->read(file, false, buffer, offset, count);
    80206758:	611c                	ld	a5,0(a0)
    8020675a:	0107b803          	ld	a6,16(a5)
    8020675e:	000a079b          	sext.w	a5,s4
    80206762:	0009871b          	sext.w	a4,s3
    80206766:	86ca                	mv	a3,s2
    80206768:	4601                	li	a2,0
    8020676a:	85a6                	mv	a1,s1
    8020676c:	9802                	jalr	a6
  LOG_TRACE("bytes of read=%d", r);
  return r;
}
    8020676e:	2501                	sext.w	a0,a0
    80206770:	70a2                	ld	ra,40(sp)
    80206772:	7402                	ld	s0,32(sp)
    80206774:	64e2                	ld	s1,24(sp)
    80206776:	6942                	ld	s2,16(sp)
    80206778:	69a2                	ld	s3,8(sp)
    8020677a:	6a02                	ld	s4,0(sp)
    8020677c:	6145                	addi	sp,sp,48
    8020677e:	8082                	ret

0000000080206780 <_ZN3vfs12direct_writeEPKcS1_mm>:
size_t direct_write(const char *file, const char *buffer, size_t count, size_t offset) { return 0; }
    80206780:	1141                	addi	sp,sp,-16
    80206782:	e422                	sd	s0,8(sp)
    80206784:	0800                	addi	s0,sp,16
    80206786:	4501                	li	a0,0
    80206788:	6422                	ld	s0,8(sp)
    8020678a:	0141                	addi	sp,sp,16
    8020678c:	8082                	ret

000000008020678e <_ZN3vfs3dupEP4file>:

struct file *dup(struct file *fp) {
    8020678e:	1101                	addi	sp,sp,-32
    80206790:	ec06                	sd	ra,24(sp)
    80206792:	e822                	sd	s0,16(sp)
    80206794:	e426                	sd	s1,8(sp)
    80206796:	1000                	addi	s0,sp,32
    80206798:	84aa                	mv	s1,a0
  fileTableLock.lock();
    8020679a:	0008a517          	auipc	a0,0x8a
    8020679e:	e2650513          	addi	a0,a0,-474 # 802905c0 <_ZN3vfs13fileTableLockE>
    802067a2:	ffffa097          	auipc	ra,0xffffa
    802067a6:	6aa080e7          	jalr	1706(ra) # 80200e4c <_ZN8SpinLock4lockEv>
  if (fp->ref < 1) {
    802067aa:	48bc                	lw	a5,80(s1)
    802067ac:	02f05363          	blez	a5,802067d2 <_ZN3vfs3dupEP4file+0x44>
    panic("vfs::dup");
    panic("vfs::dup");
  }
  fp->ref++;
    802067b0:	48bc                	lw	a5,80(s1)
    802067b2:	2785                	addiw	a5,a5,1
    802067b4:	c8bc                	sw	a5,80(s1)
  fileTableLock.unlock();
    802067b6:	0008a517          	auipc	a0,0x8a
    802067ba:	e0a50513          	addi	a0,a0,-502 # 802905c0 <_ZN3vfs13fileTableLockE>
    802067be:	ffffa097          	auipc	ra,0xffffa
    802067c2:	70a080e7          	jalr	1802(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
  return fp;
}
    802067c6:	8526                	mv	a0,s1
    802067c8:	60e2                	ld	ra,24(sp)
    802067ca:	6442                	ld	s0,16(sp)
    802067cc:	64a2                	ld	s1,8(sp)
    802067ce:	6105                	addi	sp,sp,32
    802067d0:	8082                	ret
    panic("vfs::dup");
    802067d2:	00004517          	auipc	a0,0x4
    802067d6:	41e50513          	addi	a0,a0,1054 # 8020abf0 <_ZTV15Fat32FileSystem+0x228>
    802067da:	ffffa097          	auipc	ra,0xffffa
    802067de:	008080e7          	jalr	8(ra) # 802007e2 <_Z5panicPKc>
    panic("vfs::dup");
    802067e2:	00004517          	auipc	a0,0x4
    802067e6:	40e50513          	addi	a0,a0,1038 # 8020abf0 <_ZTV15Fat32FileSystem+0x228>
    802067ea:	ffffa097          	auipc	ra,0xffffa
    802067ee:	ff8080e7          	jalr	-8(ra) # 802007e2 <_Z5panicPKc>
    802067f2:	bf7d                	j	802067b0 <_ZN3vfs3dupEP4file+0x22>

00000000802067f4 <_ZN3vfs5chdirEPc>:

int chdir(char *filepath) {
    802067f4:	7159                	addi	sp,sp,-112
    802067f6:	f486                	sd	ra,104(sp)
    802067f8:	f0a2                	sd	s0,96(sp)
    802067fa:	eca6                	sd	s1,88(sp)
    802067fc:	e8ca                	sd	s2,80(sp)
    802067fe:	e4ce                	sd	s3,72(sp)
    80206800:	1880                	addi	s0,sp,112
    80206802:	89aa                	mv	s3,a0
  char path[MAXPATH];
  Task *task = myTask();
    80206804:	ffffb097          	auipc	ra,0xffffb
    80206808:	208080e7          	jalr	520(ra) # 80201a0c <_Z6myTaskv>
    8020680c:	892a                	mv	s2,a0

  memset(path, 0, MAXPATH);
    8020680e:	04000613          	li	a2,64
    80206812:	4581                	li	a1,0
    80206814:	f9040513          	addi	a0,s0,-112
    80206818:	ffffa097          	auipc	ra,0xffffa
    8020681c:	344080e7          	jalr	836(ra) # 80200b5c <_Z6memsetPvij>
  struct file *fp = allocFileHandle();
    80206820:	fffff097          	auipc	ra,0xfffff
    80206824:	628080e7          	jalr	1576(ra) # 80205e48 <_ZN3vfs15allocFileHandleEv>
    80206828:	84aa                	mv	s1,a0
  getAbsolutePath((char *)filepath, path);
    8020682a:	f9040593          	addi	a1,s0,-112
    8020682e:	854e                	mv	a0,s3
    80206830:	fffff097          	auipc	ra,0xfffff
    80206834:	746080e7          	jalr	1862(ra) # 80205f76 <_ZN3vfs15getAbsolutePathEPcS0_>
  auto fs = getFs(path);
    80206838:	f9040513          	addi	a0,s0,-112
    8020683c:	fffff097          	auipc	ra,0xfffff
    80206840:	690080e7          	jalr	1680(ra) # 80205ecc <_ZN3vfs5getFsEPKc>

  if (fs->open(path, O_RDONLY, fp) < 0) {
    80206844:	611c                	ld	a5,0(a0)
    80206846:	679c                	ld	a5,8(a5)
    80206848:	86a6                	mv	a3,s1
    8020684a:	4601                	li	a2,0
    8020684c:	f9040593          	addi	a1,s0,-112
    80206850:	9782                	jalr	a5
    80206852:	0a054263          	bltz	a0,802068f6 <_ZN3vfs5chdirEPc+0x102>
    return -1;
  }

  if (!fp->directory) {
    80206856:	0404c783          	lbu	a5,64(s1)
    8020685a:	c7d9                	beqz	a5,802068e8 <_ZN3vfs5chdirEPc+0xf4>
    freeFileHandle(fp);
    return -1;
  }
  int n = strlen(path);
    8020685c:	f9040513          	addi	a0,s0,-112
    80206860:	ffffa097          	auipc	ra,0xffffa
    80206864:	4ec080e7          	jalr	1260(ra) # 80200d4c <_Z6strlenPKc>
  if (path[n - 1] != '/') {
    80206868:	fff5071b          	addiw	a4,a0,-1
    8020686c:	fd040693          	addi	a3,s0,-48
    80206870:	9736                	add	a4,a4,a3
    80206872:	fc074683          	lbu	a3,-64(a4)
    80206876:	02f00713          	li	a4,47
    8020687a:	02e68063          	beq	a3,a4,8020689a <_ZN3vfs5chdirEPc+0xa6>
    path[n] = '/';
    8020687e:	fd040713          	addi	a4,s0,-48
    80206882:	972a                	add	a4,a4,a0
    80206884:	02f00693          	li	a3,47
    80206888:	fcd70023          	sb	a3,-64(a4)
    path[n + 1] = 0;
    8020688c:	0015079b          	addiw	a5,a0,1
    80206890:	fd040713          	addi	a4,s0,-48
    80206894:	97ba                	add	a5,a5,a4
    80206896:	fc078023          	sb	zero,-64(a5)
  }
  task->lock.lock();
    8020689a:	854a                	mv	a0,s2
    8020689c:	ffffa097          	auipc	ra,0xffffa
    802068a0:	5b0080e7          	jalr	1456(ra) # 80200e4c <_ZN8SpinLock4lockEv>
  safestrcpy(task->currentDir, path, strlen(path) + 1);
    802068a4:	f9040513          	addi	a0,s0,-112
    802068a8:	ffffa097          	auipc	ra,0xffffa
    802068ac:	4a4080e7          	jalr	1188(ra) # 80200d4c <_Z6strlenPKc>
    802068b0:	0015061b          	addiw	a2,a0,1
    802068b4:	f9040593          	addi	a1,s0,-112
    802068b8:	09090513          	addi	a0,s2,144
    802068bc:	ffffa097          	auipc	ra,0xffffa
    802068c0:	45c080e7          	jalr	1116(ra) # 80200d18 <_Z10safestrcpyPcPKci>
  task->lock.unlock();
    802068c4:	854a                	mv	a0,s2
    802068c6:	ffffa097          	auipc	ra,0xffffa
    802068ca:	602080e7          	jalr	1538(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
  freeFileHandle(fp);
    802068ce:	8526                	mv	a0,s1
    802068d0:	fffff097          	auipc	ra,0xfffff
    802068d4:	5de080e7          	jalr	1502(ra) # 80205eae <_ZN3vfs14freeFileHandleEP4file>
  return 0;
    802068d8:	4501                	li	a0,0
}
    802068da:	70a6                	ld	ra,104(sp)
    802068dc:	7406                	ld	s0,96(sp)
    802068de:	64e6                	ld	s1,88(sp)
    802068e0:	6946                	ld	s2,80(sp)
    802068e2:	69a6                	ld	s3,72(sp)
    802068e4:	6165                	addi	sp,sp,112
    802068e6:	8082                	ret
    freeFileHandle(fp);
    802068e8:	8526                	mv	a0,s1
    802068ea:	fffff097          	auipc	ra,0xfffff
    802068ee:	5c4080e7          	jalr	1476(ra) # 80205eae <_ZN3vfs14freeFileHandleEP4file>
    return -1;
    802068f2:	557d                	li	a0,-1
    802068f4:	b7dd                	j	802068da <_ZN3vfs5chdirEPc+0xe6>
    return -1;
    802068f6:	557d                	li	a0,-1
    802068f8:	b7cd                	j	802068da <_ZN3vfs5chdirEPc+0xe6>

00000000802068fa <_GLOBAL__sub_I__ZN3vfs9fileTableE>:

    802068fa:	1141                	addi	sp,sp,-16
    802068fc:	e406                	sd	ra,8(sp)
    802068fe:	e022                	sd	s0,0(sp)
    80206900:	0800                	addi	s0,sp,16
SpinLock fileTableLock;
    80206902:	0008a517          	auipc	a0,0x8a
    80206906:	cbe50513          	addi	a0,a0,-834 # 802905c0 <_ZN3vfs13fileTableLockE>
    8020690a:	ffffa097          	auipc	ra,0xffffa
    8020690e:	4ba080e7          	jalr	1210(ra) # 80200dc4 <_ZN8SpinLockC1Ev>
    80206912:	60a2                	ld	ra,8(sp)
    80206914:	6402                	ld	s0,0(sp)
    80206916:	0141                	addi	sp,sp,16
    80206918:	8082                	ret

000000008020691a <_ZN16DeviceFileSystem4initEv>:

#include "fs/devfs/DeviceFileSystem.hpp"
#include "device/Console.hpp"

extern Console console;
void DeviceFileSystem::init() {}
    8020691a:	1141                	addi	sp,sp,-16
    8020691c:	e422                	sd	s0,8(sp)
    8020691e:	0800                	addi	s0,sp,16
    80206920:	6422                	ld	s0,8(sp)
    80206922:	0141                	addi	sp,sp,16
    80206924:	8082                	ret

0000000080206926 <_ZN16DeviceFileSystem4openEPKcmP4file>:

int DeviceFileSystem::open(const char *filePath, uint64_t flags, struct file *fp) {
    80206926:	1141                	addi	sp,sp,-16
    80206928:	e422                	sd	s0,8(sp)
    8020692a:	0800                	addi	s0,sp,16
  fp->type = fp->FD_DEVICE;
    8020692c:	478d                	li	a5,3
    8020692e:	cebc                	sw	a5,88(a3)
  fp->directory = false;
    80206930:	04068023          	sb	zero,64(a3)
  return 0;
}
    80206934:	4501                	li	a0,0
    80206936:	6422                	ld	s0,8(sp)
    80206938:	0141                	addi	sp,sp,16
    8020693a:	8082                	ret

000000008020693c <_ZN16DeviceFileSystem5clearEPKcmmRm>:
size_t DeviceFileSystem::write(const char *path, bool user, const char *buf, int offset, int n) {
  // LOG_DEBUG("dev write %d",user);
  return console.write(reinterpret_cast<uint64_t>(buf), user, n);
}

size_t DeviceFileSystem::clear(const char *filepath, size_t count, size_t offset, size_t &written) { return 0; }
    8020693c:	1141                	addi	sp,sp,-16
    8020693e:	e422                	sd	s0,8(sp)
    80206940:	0800                	addi	s0,sp,16
    80206942:	4501                	li	a0,0
    80206944:	6422                	ld	s0,8(sp)
    80206946:	0141                	addi	sp,sp,16
    80206948:	8082                	ret

000000008020694a <_ZN16DeviceFileSystem8truncateEPKcm>:

size_t DeviceFileSystem::truncate(const char *filepath, size_t size) { return 0; }
    8020694a:	1141                	addi	sp,sp,-16
    8020694c:	e422                	sd	s0,8(sp)
    8020694e:	0800                	addi	s0,sp,16
    80206950:	4501                	li	a0,0
    80206952:	6422                	ld	s0,8(sp)
    80206954:	0141                	addi	sp,sp,16
    80206956:	8082                	ret

0000000080206958 <_ZN16DeviceFileSystem8get_fileEPKcP4file>:

int DeviceFileSystem::get_file(const char *filepath, struct file *fp) { return 0; }
    80206958:	1141                	addi	sp,sp,-16
    8020695a:	e422                	sd	s0,8(sp)
    8020695c:	0800                	addi	s0,sp,16
    8020695e:	4501                	li	a0,0
    80206960:	6422                	ld	s0,8(sp)
    80206962:	0141                	addi	sp,sp,16
    80206964:	8082                	ret

0000000080206966 <_ZN16DeviceFileSystem5touchEPKc>:

size_t DeviceFileSystem::touch(const char *filepath) { return 0; }
    80206966:	1141                	addi	sp,sp,-16
    80206968:	e422                	sd	s0,8(sp)
    8020696a:	0800                	addi	s0,sp,16
    8020696c:	4501                	li	a0,0
    8020696e:	6422                	ld	s0,8(sp)
    80206970:	0141                	addi	sp,sp,16
    80206972:	8082                	ret

0000000080206974 <_ZN16DeviceFileSystem2rmEPKc>:

size_t DeviceFileSystem::rm(const char *filepath) { return 0; }
    80206974:	1141                	addi	sp,sp,-16
    80206976:	e422                	sd	s0,8(sp)
    80206978:	0800                	addi	s0,sp,16
    8020697a:	4501                	li	a0,0
    8020697c:	6422                	ld	s0,8(sp)
    8020697e:	0141                	addi	sp,sp,16
    80206980:	8082                	ret

0000000080206982 <_ZN16DeviceFileSystem2lsEPKcPcb>:

    80206982:	1141                	addi	sp,sp,-16
    80206984:	e422                	sd	s0,8(sp)
    80206986:	0800                	addi	s0,sp,16
    80206988:	4501                	li	a0,0
    8020698a:	6422                	ld	s0,8(sp)
    8020698c:	0141                	addi	sp,sp,16
    8020698e:	8082                	ret

0000000080206990 <_ZN16DeviceFileSystem5mkdirEPKc>:
int DeviceFileSystem::mkdir(const char *filepath) {
    80206990:	1141                	addi	sp,sp,-16
    80206992:	e406                	sd	ra,8(sp)
    80206994:	e022                	sd	s0,0(sp)
    80206996:	0800                	addi	s0,sp,16
    80206998:	00004717          	auipc	a4,0x4
    8020699c:	26870713          	addi	a4,a4,616 # 8020ac00 <_ZTV15Fat32FileSystem+0x238>
    802069a0:	46bd                	li	a3,15
    802069a2:	00004617          	auipc	a2,0x4
    802069a6:	26660613          	addi	a2,a2,614 # 8020ac08 <_ZTV15Fat32FileSystem+0x240>
    802069aa:	00004597          	auipc	a1,0x4
    802069ae:	27e58593          	addi	a1,a1,638 # 8020ac28 <_ZTV15Fat32FileSystem+0x260>
    802069b2:	00003517          	auipc	a0,0x3
    802069b6:	7ce50513          	addi	a0,a0,1998 # 8020a180 <rodata_start+0x180>
    802069ba:	ffffa097          	auipc	ra,0xffffa
    802069be:	e9a080e7          	jalr	-358(ra) # 80200854 <_Z6printfPKcz>
  LOG_WARN("dev fs not support mkdir");
    802069c2:	00004517          	auipc	a0,0x4
    802069c6:	26e50513          	addi	a0,a0,622 # 8020ac30 <_ZTV15Fat32FileSystem+0x268>
    802069ca:	ffffa097          	auipc	ra,0xffffa
    802069ce:	e8a080e7          	jalr	-374(ra) # 80200854 <_Z6printfPKcz>
    802069d2:	00003517          	auipc	a0,0x3
    802069d6:	6ce50513          	addi	a0,a0,1742 # 8020a0a0 <rodata_start+0xa0>
    802069da:	ffffa097          	auipc	ra,0xffffa
    802069de:	e7a080e7          	jalr	-390(ra) # 80200854 <_Z6printfPKcz>
}
    802069e2:	557d                	li	a0,-1
    802069e4:	60a2                	ld	ra,8(sp)
    802069e6:	6402                	ld	s0,0(sp)
    802069e8:	0141                	addi	sp,sp,16
    802069ea:	8082                	ret

00000000802069ec <_ZN16DeviceFileSystem4readEPKcbPcii>:
size_t DeviceFileSystem::read(const char *path, bool user, char *buf, int offset, int n) {
    802069ec:	1141                	addi	sp,sp,-16
    802069ee:	e406                	sd	ra,8(sp)
    802069f0:	e022                	sd	s0,0(sp)
    802069f2:	0800                	addi	s0,sp,16
    802069f4:	85b6                	mv	a1,a3
  return console.read(reinterpret_cast<uint64_t>(buf), user, n);
    802069f6:	86be                	mv	a3,a5
    802069f8:	0000d517          	auipc	a0,0xd
    802069fc:	60850513          	addi	a0,a0,1544 # 80214000 <console>
    80206a00:	00000097          	auipc	ra,0x0
    80206a04:	0c2080e7          	jalr	194(ra) # 80206ac2 <_ZN7Console4readEmbi>
}
    80206a08:	60a2                	ld	ra,8(sp)
    80206a0a:	6402                	ld	s0,0(sp)
    80206a0c:	0141                	addi	sp,sp,16
    80206a0e:	8082                	ret

0000000080206a10 <_ZN16DeviceFileSystem5writeEPKcbS1_ii>:
size_t DeviceFileSystem::write(const char *path, bool user, const char *buf, int offset, int n) {
    80206a10:	1141                	addi	sp,sp,-16
    80206a12:	e406                	sd	ra,8(sp)
    80206a14:	e022                	sd	s0,0(sp)
    80206a16:	0800                	addi	s0,sp,16
    80206a18:	85b6                	mv	a1,a3
  return console.write(reinterpret_cast<uint64_t>(buf), user, n);
    80206a1a:	86be                	mv	a3,a5
    80206a1c:	0000d517          	auipc	a0,0xd
    80206a20:	5e450513          	addi	a0,a0,1508 # 80214000 <console>
    80206a24:	00000097          	auipc	ra,0x0
    80206a28:	1ba080e7          	jalr	442(ra) # 80206bde <_ZN7Console5writeEmbi>
}
    80206a2c:	60a2                	ld	ra,8(sp)
    80206a2e:	6402                	ld	s0,0(sp)
    80206a30:	0141                	addi	sp,sp,16
    80206a32:	8082                	ret

0000000080206a34 <_ZN7Console4initEv>:
#define BACKSPACE (0x100)
#define CTRL(x) (x - '@')

extern Console console;

void Console::init() {
    80206a34:	1101                	addi	sp,sp,-32
    80206a36:	ec06                	sd	ra,24(sp)
    80206a38:	e822                	sd	s0,16(sp)
    80206a3a:	e426                	sd	s1,8(sp)
    80206a3c:	1000                	addi	s0,sp,32
    80206a3e:	84aa                	mv	s1,a0
  this->spinLock.init("console");
    80206a40:	00004597          	auipc	a1,0x4
    80206a44:	27858593          	addi	a1,a1,632 # 8020acb8 <_ZTV16DeviceFileSystem+0x68>
    80206a48:	08850513          	addi	a0,a0,136
    80206a4c:	ffffa097          	auipc	ra,0xffffa
    80206a50:	3aa080e7          	jalr	938(ra) # 80200df6 <_ZN8SpinLock4initEPKc>
  this->read_index = 0;
    80206a54:	0804a023          	sw	zero,128(s1)
  this->write_index = 0;
    80206a58:	0804a223          	sw	zero,132(s1)
}
    80206a5c:	60e2                	ld	ra,24(sp)
    80206a5e:	6442                	ld	s0,16(sp)
    80206a60:	64a2                	ld	s1,8(sp)
    80206a62:	6105                	addi	sp,sp,32
    80206a64:	8082                	ret

0000000080206a66 <_ZN7ConsoleC1Ev>:

Console::Console() {}
    80206a66:	1141                	addi	sp,sp,-16
    80206a68:	e406                	sd	ra,8(sp)
    80206a6a:	e022                	sd	s0,0(sp)
    80206a6c:	0800                	addi	s0,sp,16
    80206a6e:	08850513          	addi	a0,a0,136
    80206a72:	ffffa097          	auipc	ra,0xffffa
    80206a76:	352080e7          	jalr	850(ra) # 80200dc4 <_ZN8SpinLockC1Ev>
    80206a7a:	60a2                	ld	ra,8(sp)
    80206a7c:	6402                	ld	s0,0(sp)
    80206a7e:	0141                	addi	sp,sp,16
    80206a80:	8082                	ret

0000000080206a82 <_ZN7Console4putcEi>:
void Console::putc(int c) {
    80206a82:	1141                	addi	sp,sp,-16
    80206a84:	e422                	sd	s0,8(sp)
    80206a86:	0800                	addi	s0,sp,16
  if (c == BACKSPACE) {
    80206a88:	10000793          	li	a5,256
    80206a8c:	00f58c63          	beq	a1,a5,80206aa4 <_ZN7Console4putcEi+0x22>
    80206a90:	852e                	mv	a0,a1
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
    80206a92:	4581                	li	a1,0
    80206a94:	4601                	li	a2,0
    80206a96:	4681                	li	a3,0
    80206a98:	4885                	li	a7,1
    80206a9a:	00000073          	ecall
    sbi_console_putchar(' ');
    sbi_console_putchar('\b');
  } else {
    sbi_console_putchar(c);
  }
}
    80206a9e:	6422                	ld	s0,8(sp)
    80206aa0:	0141                	addi	sp,sp,16
    80206aa2:	8082                	ret
    80206aa4:	4521                	li	a0,8
    80206aa6:	4581                	li	a1,0
    80206aa8:	4601                	li	a2,0
    80206aaa:	4681                	li	a3,0
    80206aac:	4885                	li	a7,1
    80206aae:	00000073          	ecall
    80206ab2:	02000513          	li	a0,32
    80206ab6:	00000073          	ecall
    80206aba:	4521                	li	a0,8
    80206abc:	00000073          	ecall
}
    80206ac0:	bff9                	j	80206a9e <_ZN7Console4putcEi+0x1c>

0000000080206ac2 <_ZN7Console4readEmbi>:

int Console::read(uint64_t dst, bool user, int n) {
    80206ac2:	711d                	addi	sp,sp,-96
    80206ac4:	ec86                	sd	ra,88(sp)
    80206ac6:	e8a2                	sd	s0,80(sp)
    80206ac8:	e4a6                	sd	s1,72(sp)
    80206aca:	e0ca                	sd	s2,64(sp)
    80206acc:	fc4e                	sd	s3,56(sp)
    80206ace:	f852                	sd	s4,48(sp)
    80206ad0:	f456                	sd	s5,40(sp)
    80206ad2:	f05a                	sd	s6,32(sp)
    80206ad4:	ec5e                	sd	s7,24(sp)
    80206ad6:	e862                	sd	s8,16(sp)
    80206ad8:	1080                	addi	s0,sp,96
    80206ada:	84aa                	mv	s1,a0
    80206adc:	8a2e                	mv	s4,a1
    80206ade:	8b32                	mv	s6,a2
    80206ae0:	8c36                	mv	s8,a3
  char c;
  int expect = n;
  this->spinLock.lock();
    80206ae2:	08850913          	addi	s2,a0,136
    80206ae6:	854a                	mv	a0,s2
    80206ae8:	ffffa097          	auipc	ra,0xffffa
    80206aec:	364080e7          	jalr	868(ra) # 80200e4c <_ZN8SpinLock4lockEv>
    80206af0:	8ae2                	mv	s5,s8
  while (n > 0) {
    while (this->read_index == this->write_index) {
      sleep(&this->read_index, &this->spinLock);
    80206af2:	08048993          	addi	s3,s1,128
    c = this->buf[this->read_index++ % INPUT_BUF];
    if (either_copyout(user, dst, &c, 1) < 0) break;
    dst++;
    n--;
    // 当输入一整行时，需要返回
    if (c == '\n') {
    80206af6:	4ba9                	li	s7,10
    80206af8:	a099                	j	80206b3e <_ZN7Console4readEmbi+0x7c>
    c = this->buf[this->read_index++ % INPUT_BUF];
    80206afa:	0017871b          	addiw	a4,a5,1
    80206afe:	08e4a023          	sw	a4,128(s1)
    80206b02:	41f7d71b          	sraiw	a4,a5,0x1f
    80206b06:	0197571b          	srliw	a4,a4,0x19
    80206b0a:	9fb9                	addw	a5,a5,a4
    80206b0c:	07f7f793          	andi	a5,a5,127
    80206b10:	9f99                	subw	a5,a5,a4
    80206b12:	97a6                	add	a5,a5,s1
    80206b14:	0007c783          	lbu	a5,0(a5)
    80206b18:	faf407a3          	sb	a5,-81(s0)
    if (either_copyout(user, dst, &c, 1) < 0) break;
    80206b1c:	4685                	li	a3,1
    80206b1e:	faf40613          	addi	a2,s0,-81
    80206b22:	85d2                	mv	a1,s4
    80206b24:	855a                	mv	a0,s6
    80206b26:	ffffc097          	auipc	ra,0xffffc
    80206b2a:	888080e7          	jalr	-1912(ra) # 802023ae <_Z14either_copyoutbmPvi>
    80206b2e:	02054d63          	bltz	a0,80206b68 <_ZN7Console4readEmbi+0xa6>
    dst++;
    80206b32:	0a05                	addi	s4,s4,1
    n--;
    80206b34:	3afd                	addiw	s5,s5,-1
    if (c == '\n') {
    80206b36:	faf44783          	lbu	a5,-81(s0)
    80206b3a:	03778763          	beq	a5,s7,80206b68 <_ZN7Console4readEmbi+0xa6>
  while (n > 0) {
    80206b3e:	03505563          	blez	s5,80206b68 <_ZN7Console4readEmbi+0xa6>
    while (this->read_index == this->write_index) {
    80206b42:	0804a783          	lw	a5,128(s1)
    80206b46:	0844a703          	lw	a4,132(s1)
    80206b4a:	faf718e3          	bne	a4,a5,80206afa <_ZN7Console4readEmbi+0x38>
      sleep(&this->read_index, &this->spinLock);
    80206b4e:	85ca                	mv	a1,s2
    80206b50:	854e                	mv	a0,s3
    80206b52:	ffffb097          	auipc	ra,0xffffb
    80206b56:	0da080e7          	jalr	218(ra) # 80201c2c <_Z5sleepPvP8SpinLock>
    while (this->read_index == this->write_index) {
    80206b5a:	0804a783          	lw	a5,128(s1)
    80206b5e:	0844a703          	lw	a4,132(s1)
    80206b62:	fef706e3          	beq	a4,a5,80206b4e <_ZN7Console4readEmbi+0x8c>
    80206b66:	bf51                	j	80206afa <_ZN7Console4readEmbi+0x38>
      break;
    }
  }
  this->spinLock.unlock();
    80206b68:	854a                	mv	a0,s2
    80206b6a:	ffffa097          	auipc	ra,0xffffa
    80206b6e:	35e080e7          	jalr	862(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
    80206b72:	00004717          	auipc	a4,0x4
    80206b76:	d7e70713          	addi	a4,a4,-642 # 8020a8f0 <_ZL6digits+0x5e8>
    80206b7a:	03100693          	li	a3,49
    80206b7e:	00004617          	auipc	a2,0x4
    80206b82:	14260613          	addi	a2,a2,322 # 8020acc0 <_ZTV16DeviceFileSystem+0x70>
    80206b86:	00003597          	auipc	a1,0x3
    80206b8a:	5f258593          	addi	a1,a1,1522 # 8020a178 <rodata_start+0x178>
    80206b8e:	00003517          	auipc	a0,0x3
    80206b92:	5f250513          	addi	a0,a0,1522 # 8020a180 <rodata_start+0x180>
    80206b96:	ffffa097          	auipc	ra,0xffffa
    80206b9a:	cbe080e7          	jalr	-834(ra) # 80200854 <_Z6printfPKcz>
  LOG_DEBUG("console read=%d", expect - n);
    80206b9e:	415c0abb          	subw	s5,s8,s5
    80206ba2:	85d6                	mv	a1,s5
    80206ba4:	00004517          	auipc	a0,0x4
    80206ba8:	13450513          	addi	a0,a0,308 # 8020acd8 <_ZTV16DeviceFileSystem+0x88>
    80206bac:	ffffa097          	auipc	ra,0xffffa
    80206bb0:	ca8080e7          	jalr	-856(ra) # 80200854 <_Z6printfPKcz>
    80206bb4:	00003517          	auipc	a0,0x3
    80206bb8:	4ec50513          	addi	a0,a0,1260 # 8020a0a0 <rodata_start+0xa0>
    80206bbc:	ffffa097          	auipc	ra,0xffffa
    80206bc0:	c98080e7          	jalr	-872(ra) # 80200854 <_Z6printfPKcz>
  return expect - n;
}
    80206bc4:	8556                	mv	a0,s5
    80206bc6:	60e6                	ld	ra,88(sp)
    80206bc8:	6446                	ld	s0,80(sp)
    80206bca:	64a6                	ld	s1,72(sp)
    80206bcc:	6906                	ld	s2,64(sp)
    80206bce:	79e2                	ld	s3,56(sp)
    80206bd0:	7a42                	ld	s4,48(sp)
    80206bd2:	7aa2                	ld	s5,40(sp)
    80206bd4:	7b02                	ld	s6,32(sp)
    80206bd6:	6be2                	ld	s7,24(sp)
    80206bd8:	6c42                	ld	s8,16(sp)
    80206bda:	6125                	addi	sp,sp,96
    80206bdc:	8082                	ret

0000000080206bde <_ZN7Console5writeEmbi>:

int Console::write(uint64_t src, bool user, int n) {
    80206bde:	715d                	addi	sp,sp,-80
    80206be0:	e486                	sd	ra,72(sp)
    80206be2:	e0a2                	sd	s0,64(sp)
    80206be4:	fc26                	sd	s1,56(sp)
    80206be6:	f84a                	sd	s2,48(sp)
    80206be8:	f44e                	sd	s3,40(sp)
    80206bea:	f052                	sd	s4,32(sp)
    80206bec:	ec56                	sd	s5,24(sp)
    80206bee:	e85a                	sd	s6,16(sp)
    80206bf0:	0880                	addi	s0,sp,80
    80206bf2:	84ae                	mv	s1,a1
    80206bf4:	8a32                	mv	s4,a2
    80206bf6:	89b6                	mv	s3,a3
  int i;

  this->spinLock.lock();
    80206bf8:	08850b13          	addi	s6,a0,136
    80206bfc:	855a                	mv	a0,s6
    80206bfe:	ffffa097          	auipc	ra,0xffffa
    80206c02:	24e080e7          	jalr	590(ra) # 80200e4c <_ZN8SpinLock4lockEv>
  for (i = 0; i < n; i++) {
    80206c06:	05305b63          	blez	s3,80206c5c <_ZN7Console5writeEmbi+0x7e>
    80206c0a:	4901                	li	s2,0
    char c;
    if (either_copyin(user, &c, src + i, 1) == -1) break;
    80206c0c:	5afd                	li	s5,-1
    80206c0e:	4685                	li	a3,1
    80206c10:	8626                	mv	a2,s1
    80206c12:	fbf40593          	addi	a1,s0,-65
    80206c16:	8552                	mv	a0,s4
    80206c18:	ffffb097          	auipc	ra,0xffffb
    80206c1c:	7ec080e7          	jalr	2028(ra) # 80202404 <_Z13either_copyinbPvmm>
    80206c20:	01550e63          	beq	a0,s5,80206c3c <_ZN7Console5writeEmbi+0x5e>
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
    80206c24:	fbf44503          	lbu	a0,-65(s0)
    80206c28:	4581                	li	a1,0
    80206c2a:	4601                	li	a2,0
    80206c2c:	4681                	li	a3,0
    80206c2e:	4885                	li	a7,1
    80206c30:	00000073          	ecall
  for (i = 0; i < n; i++) {
    80206c34:	2905                	addiw	s2,s2,1
    80206c36:	0485                	addi	s1,s1,1
    80206c38:	fd299be3          	bne	s3,s2,80206c0e <_ZN7Console5writeEmbi+0x30>
    sbi_console_putchar(c);
  }
  this->spinLock.unlock();
    80206c3c:	855a                	mv	a0,s6
    80206c3e:	ffffa097          	auipc	ra,0xffffa
    80206c42:	28a080e7          	jalr	650(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>

  return i;
}
    80206c46:	854a                	mv	a0,s2
    80206c48:	60a6                	ld	ra,72(sp)
    80206c4a:	6406                	ld	s0,64(sp)
    80206c4c:	74e2                	ld	s1,56(sp)
    80206c4e:	7942                	ld	s2,48(sp)
    80206c50:	79a2                	ld	s3,40(sp)
    80206c52:	7a02                	ld	s4,32(sp)
    80206c54:	6ae2                	ld	s5,24(sp)
    80206c56:	6b42                	ld	s6,16(sp)
    80206c58:	6161                	addi	sp,sp,80
    80206c5a:	8082                	ret
  for (i = 0; i < n; i++) {
    80206c5c:	4901                	li	s2,0
    80206c5e:	bff9                	j	80206c3c <_ZN7Console5writeEmbi+0x5e>

0000000080206c60 <_ZN7Console12console_intrEc>:

void Console::console_intr(char c) {
  switch (c) {
    80206c60:	47c1                	li	a5,16
    80206c62:	0cf58763          	beq	a1,a5,80206d30 <_ZN7Console12console_intrEc+0xd0>
void Console::console_intr(char c) {
    80206c66:	1101                	addi	sp,sp,-32
    80206c68:	ec06                	sd	ra,24(sp)
    80206c6a:	e822                	sd	s0,16(sp)
    80206c6c:	e426                	sd	s1,8(sp)
    80206c6e:	e04a                	sd	s2,0(sp)
    80206c70:	1000                	addi	s0,sp,32
    80206c72:	892a                	mv	s2,a0
    80206c74:	84ae                	mv	s1,a1
  switch (c) {
    80206c76:	07f00793          	li	a5,127
    80206c7a:	04f58663          	beq	a1,a5,80206cc6 <_ZN7Console12console_intrEc+0x66>
    80206c7e:	47a1                	li	a5,8
    80206c80:	04f58363          	beq	a1,a5,80206cc6 <_ZN7Console12console_intrEc+0x66>
//    linux:    '\n'
//    windows:  '\r\n'
#ifdef K210
      if (c == '\r') break;
#else
      c = (c == '\r') ? '\n' : c;
    80206c84:	47b5                	li	a5,13
    80206c86:	06f58763          	beq	a1,a5,80206cf4 <_ZN7Console12console_intrEc+0x94>
#endif
      this->putc(c);
    80206c8a:	00000097          	auipc	ra,0x0
    80206c8e:	df8080e7          	jalr	-520(ra) # 80206a82 <_ZN7Console4putcEi>
      // 保存输入字符
      this->buf[this->write_index++ % INPUT_BUF] = c;
    80206c92:	08492783          	lw	a5,132(s2)
    80206c96:	0017871b          	addiw	a4,a5,1
    80206c9a:	08e92223          	sw	a4,132(s2)
    80206c9e:	41f7d71b          	sraiw	a4,a5,0x1f
    80206ca2:	0197571b          	srliw	a4,a4,0x19
    80206ca6:	9fb9                	addw	a5,a5,a4
    80206ca8:	07f7f793          	andi	a5,a5,127
    80206cac:	9f99                	subw	a5,a5,a4
    80206cae:	97ca                	add	a5,a5,s2
    80206cb0:	00978023          	sb	s1,0(a5)
      if (c == '\n') {
    80206cb4:	47a9                	li	a5,10
    80206cb6:	06f48663          	beq	s1,a5,80206d22 <_ZN7Console12console_intrEc+0xc2>
        wakeup(&this->read_index);
      }
      break;
  }
    80206cba:	60e2                	ld	ra,24(sp)
    80206cbc:	6442                	ld	s0,16(sp)
    80206cbe:	64a2                	ld	s1,8(sp)
    80206cc0:	6902                	ld	s2,0(sp)
    80206cc2:	6105                	addi	sp,sp,32
    80206cc4:	8082                	ret
      if (this->read_index != this->write_index) {
    80206cc6:	08492783          	lw	a5,132(s2)
    80206cca:	08092703          	lw	a4,128(s2)
    80206cce:	fef706e3          	beq	a4,a5,80206cba <_ZN7Console12console_intrEc+0x5a>
        this->write_index--;
    80206cd2:	37fd                	addiw	a5,a5,-1
    80206cd4:	08f92223          	sw	a5,132(s2)
        this->putc(BACKSPACE);
    80206cd8:	10000593          	li	a1,256
    80206cdc:	854a                	mv	a0,s2
    80206cde:	00000097          	auipc	ra,0x0
    80206ce2:	da4080e7          	jalr	-604(ra) # 80206a82 <_ZN7Console4putcEi>
        this->putc('\a');
    80206ce6:	459d                	li	a1,7
    80206ce8:	854a                	mv	a0,s2
    80206cea:	00000097          	auipc	ra,0x0
    80206cee:	d98080e7          	jalr	-616(ra) # 80206a82 <_ZN7Console4putcEi>
    80206cf2:	b7e1                	j	80206cba <_ZN7Console12console_intrEc+0x5a>
      this->putc(c);
    80206cf4:	45a9                	li	a1,10
    80206cf6:	00000097          	auipc	ra,0x0
    80206cfa:	d8c080e7          	jalr	-628(ra) # 80206a82 <_ZN7Console4putcEi>
      this->buf[this->write_index++ % INPUT_BUF] = c;
    80206cfe:	08492783          	lw	a5,132(s2)
    80206d02:	0017871b          	addiw	a4,a5,1
    80206d06:	08e92223          	sw	a4,132(s2)
    80206d0a:	41f7d71b          	sraiw	a4,a5,0x1f
    80206d0e:	0197571b          	srliw	a4,a4,0x19
    80206d12:	9fb9                	addw	a5,a5,a4
    80206d14:	07f7f793          	andi	a5,a5,127
    80206d18:	9f99                	subw	a5,a5,a4
    80206d1a:	97ca                	add	a5,a5,s2
    80206d1c:	4729                	li	a4,10
    80206d1e:	00e78023          	sb	a4,0(a5)
        wakeup(&this->read_index);
    80206d22:	08090513          	addi	a0,s2,128
    80206d26:	ffffb097          	auipc	ra,0xffffb
    80206d2a:	ffa080e7          	jalr	-6(ra) # 80201d20 <_Z6wakeupPv>
    80206d2e:	b771                	j	80206cba <_ZN7Console12console_intrEc+0x5a>
    80206d30:	8082                	ret

0000000080206d32 <_Z10initHartVmv>:
  kernel_vm_map(SYSCTL_V, SYSCTL, 0x1000, PTE_R | PTE_W);

#endif
}

void initHartVm() {
    80206d32:	1141                	addi	sp,sp,-16
    80206d34:	e422                	sd	s0,8(sp)
    80206d36:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80206d38:	0008c797          	auipc	a5,0x8c
    80206d3c:	4887b783          	ld	a5,1160(a5) # 802931c0 <kernel_pagetable>
    80206d40:	83b1                	srli	a5,a5,0xc
    80206d42:	577d                	li	a4,-1
    80206d44:	177e                	slli	a4,a4,0x3f
    80206d46:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80206d48:	18079073          	csrw	satp,a5
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  // asm volatile("sfence.vma zero, zero");
  asm volatile("sfence.vma");
    80206d4c:	12000073          	sfence.vma
  sfence_vma();
}
    80206d50:	6422                	ld	s0,8(sp)
    80206d52:	0141                	addi	sp,sp,16
    80206d54:	8082                	ret

0000000080206d56 <_Z4walkPmmi>:

pte_t *walk(pagetable_t pagetable, uint64_t va, int alloc) {
    80206d56:	715d                	addi	sp,sp,-80
    80206d58:	e486                	sd	ra,72(sp)
    80206d5a:	e0a2                	sd	s0,64(sp)
    80206d5c:	fc26                	sd	s1,56(sp)
    80206d5e:	f84a                	sd	s2,48(sp)
    80206d60:	f44e                	sd	s3,40(sp)
    80206d62:	f052                	sd	s4,32(sp)
    80206d64:	ec56                	sd	s5,24(sp)
    80206d66:	e85a                	sd	s6,16(sp)
    80206d68:	e45e                	sd	s7,8(sp)
    80206d6a:	0880                	addi	s0,sp,80
    80206d6c:	84aa                	mv	s1,a0
    80206d6e:	89ae                	mv	s3,a1
    80206d70:	8ab2                	mv	s5,a2
  if (va >= MAXVA) panic("walk");
    80206d72:	57fd                	li	a5,-1
    80206d74:	83e9                	srli	a5,a5,0x1a
    80206d76:	00b7e963          	bltu	a5,a1,80206d88 <_Z4walkPmmi+0x32>
pte_t *walk(pagetable_t pagetable, uint64_t va, int alloc) {
    80206d7a:	4a79                	li	s4,30
  for (int level = 2; level > 0; level--) {
    pte_t *pte = &pagetable[PX(level, va)];
    if (*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if (!alloc || (pagetable = (pte_t *)memAllocator.alloc()) == NULL) return NULL;
    80206d7c:	0000db97          	auipc	s7,0xd
    80206d80:	324b8b93          	addi	s7,s7,804 # 802140a0 <memAllocator>
  for (int level = 2; level > 0; level--) {
    80206d84:	4b31                	li	s6,12
    80206d86:	a099                	j	80206dcc <_Z4walkPmmi+0x76>
  if (va >= MAXVA) panic("walk");
    80206d88:	00004517          	auipc	a0,0x4
    80206d8c:	f6050513          	addi	a0,a0,-160 # 8020ace8 <_ZTV16DeviceFileSystem+0x98>
    80206d90:	ffffa097          	auipc	ra,0xffffa
    80206d94:	a52080e7          	jalr	-1454(ra) # 802007e2 <_Z5panicPKc>
    80206d98:	b7cd                	j	80206d7a <_Z4walkPmmi+0x24>
      if (!alloc || (pagetable = (pte_t *)memAllocator.alloc()) == NULL) return NULL;
    80206d9a:	060a8863          	beqz	s5,80206e0a <_Z4walkPmmi+0xb4>
    80206d9e:	855e                	mv	a0,s7
    80206da0:	00000097          	auipc	ra,0x0
    80206da4:	79a080e7          	jalr	1946(ra) # 8020753a <_ZN12MemAllocator5allocEv>
    80206da8:	84aa                	mv	s1,a0
    80206daa:	c529                	beqz	a0,80206df4 <_Z4walkPmmi+0x9e>
      memset(pagetable, 0, PGSIZE);
    80206dac:	6605                	lui	a2,0x1
    80206dae:	4581                	li	a1,0
    80206db0:	ffffa097          	auipc	ra,0xffffa
    80206db4:	dac080e7          	jalr	-596(ra) # 80200b5c <_Z6memsetPvij>
      *pte = PA2PTE(pagetable) | PTE_V;
    80206db8:	00c4d793          	srli	a5,s1,0xc
    80206dbc:	07aa                	slli	a5,a5,0xa
    80206dbe:	0017e793          	ori	a5,a5,1
    80206dc2:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--) {
    80206dc6:	3a5d                	addiw	s4,s4,-9
    80206dc8:	036a0063          	beq	s4,s6,80206de8 <_Z4walkPmmi+0x92>
    pte_t *pte = &pagetable[PX(level, va)];
    80206dcc:	0149d933          	srl	s2,s3,s4
    80206dd0:	1ff97913          	andi	s2,s2,511
    80206dd4:	090e                	slli	s2,s2,0x3
    80206dd6:	9926                	add	s2,s2,s1
    if (*pte & PTE_V) {
    80206dd8:	00093483          	ld	s1,0(s2)
    80206ddc:	0014f793          	andi	a5,s1,1
    80206de0:	dfcd                	beqz	a5,80206d9a <_Z4walkPmmi+0x44>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80206de2:	80a9                	srli	s1,s1,0xa
    80206de4:	04b2                	slli	s1,s1,0xc
    80206de6:	b7c5                	j	80206dc6 <_Z4walkPmmi+0x70>
    }
  }
  return &pagetable[PX(0, va)];
    80206de8:	00c9d513          	srli	a0,s3,0xc
    80206dec:	1ff57513          	andi	a0,a0,511
    80206df0:	050e                	slli	a0,a0,0x3
    80206df2:	9526                	add	a0,a0,s1
}
    80206df4:	60a6                	ld	ra,72(sp)
    80206df6:	6406                	ld	s0,64(sp)
    80206df8:	74e2                	ld	s1,56(sp)
    80206dfa:	7942                	ld	s2,48(sp)
    80206dfc:	79a2                	ld	s3,40(sp)
    80206dfe:	7a02                	ld	s4,32(sp)
    80206e00:	6ae2                	ld	s5,24(sp)
    80206e02:	6b42                	ld	s6,16(sp)
    80206e04:	6ba2                	ld	s7,8(sp)
    80206e06:	6161                	addi	sp,sp,80
    80206e08:	8082                	ret
      if (!alloc || (pagetable = (pte_t *)memAllocator.alloc()) == NULL) return NULL;
    80206e0a:	4501                	li	a0,0
    80206e0c:	b7e5                	j	80206df4 <_Z4walkPmmi+0x9e>

0000000080206e0e <_Z8mappagesPmmmmi>:

int mappages(pagetable_t pagetable, uint64_t va, uint64_t size, uint64_t pa, int perm) {
    80206e0e:	711d                	addi	sp,sp,-96
    80206e10:	ec86                	sd	ra,88(sp)
    80206e12:	e8a2                	sd	s0,80(sp)
    80206e14:	e4a6                	sd	s1,72(sp)
    80206e16:	e0ca                	sd	s2,64(sp)
    80206e18:	fc4e                	sd	s3,56(sp)
    80206e1a:	f852                	sd	s4,48(sp)
    80206e1c:	f456                	sd	s5,40(sp)
    80206e1e:	f05a                	sd	s6,32(sp)
    80206e20:	ec5e                	sd	s7,24(sp)
    80206e22:	e862                	sd	s8,16(sp)
    80206e24:	e466                	sd	s9,8(sp)
    80206e26:	1080                	addi	s0,sp,96
    80206e28:	8b2a                	mv	s6,a0
    80206e2a:	8bba                	mv	s7,a4
  uint64_t a, last;
  pte_t *pte;

  a = PGROUNDDOWN(va);
    80206e2c:	777d                	lui	a4,0xfffff
    80206e2e:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80206e32:	167d                	addi	a2,a2,-1
    80206e34:	00b60a33          	add	s4,a2,a1
    80206e38:	00ea7a33          	and	s4,s4,a4
  a = PGROUNDDOWN(va);
    80206e3c:	89be                	mv	s3,a5
    80206e3e:	40f68ab3          	sub	s5,a3,a5
  for (;;) {
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    if (*pte & PTE_V) panic("remap");
    80206e42:	00004c97          	auipc	s9,0x4
    80206e46:	eaec8c93          	addi	s9,s9,-338 # 8020acf0 <_ZTV16DeviceFileSystem+0xa0>
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last) {
      break;
    }
    a += PGSIZE;
    80206e4a:	6c05                	lui	s8,0x1
    80206e4c:	a00d                	j	80206e6e <_Z8mappagesPmmmmi+0x60>
    if (*pte & PTE_V) panic("remap");
    80206e4e:	8566                	mv	a0,s9
    80206e50:	ffffa097          	auipc	ra,0xffffa
    80206e54:	992080e7          	jalr	-1646(ra) # 802007e2 <_Z5panicPKc>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80206e58:	80b1                	srli	s1,s1,0xc
    80206e5a:	04aa                	slli	s1,s1,0xa
    80206e5c:	0174e4b3          	or	s1,s1,s7
    80206e60:	0014e493          	ori	s1,s1,1
    80206e64:	00993023          	sd	s1,0(s2)
    if (a == last) {
    80206e68:	05498063          	beq	s3,s4,80206ea8 <_Z8mappagesPmmmmi+0x9a>
    a += PGSIZE;
    80206e6c:	99e2                	add	s3,s3,s8
  for (;;) {
    80206e6e:	013a84b3          	add	s1,s5,s3
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    80206e72:	4605                	li	a2,1
    80206e74:	85ce                	mv	a1,s3
    80206e76:	855a                	mv	a0,s6
    80206e78:	00000097          	auipc	ra,0x0
    80206e7c:	ede080e7          	jalr	-290(ra) # 80206d56 <_Z4walkPmmi>
    80206e80:	892a                	mv	s2,a0
    80206e82:	c509                	beqz	a0,80206e8c <_Z8mappagesPmmmmi+0x7e>
    if (*pte & PTE_V) panic("remap");
    80206e84:	611c                	ld	a5,0(a0)
    80206e86:	8b85                	andi	a5,a5,1
    80206e88:	dbe1                	beqz	a5,80206e58 <_Z8mappagesPmmmmi+0x4a>
    80206e8a:	b7d1                	j	80206e4e <_Z8mappagesPmmmmi+0x40>
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    80206e8c:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80206e8e:	60e6                	ld	ra,88(sp)
    80206e90:	6446                	ld	s0,80(sp)
    80206e92:	64a6                	ld	s1,72(sp)
    80206e94:	6906                	ld	s2,64(sp)
    80206e96:	79e2                	ld	s3,56(sp)
    80206e98:	7a42                	ld	s4,48(sp)
    80206e9a:	7aa2                	ld	s5,40(sp)
    80206e9c:	7b02                	ld	s6,32(sp)
    80206e9e:	6be2                	ld	s7,24(sp)
    80206ea0:	6c42                	ld	s8,16(sp)
    80206ea2:	6ca2                	ld	s9,8(sp)
    80206ea4:	6125                	addi	sp,sp,96
    80206ea6:	8082                	ret
  return 0;
    80206ea8:	4501                	li	a0,0
    80206eaa:	b7d5                	j	80206e8e <_Z8mappagesPmmmmi+0x80>

0000000080206eac <_Z8walkAddrPmm>:

uint64_t walkAddr(pagetable_t pagetable, uint64_t va) {
  pte_t *pte;
  uint64_t pa;

  if (va >= MAXVA) return 0;
    80206eac:	57fd                	li	a5,-1
    80206eae:	83e9                	srli	a5,a5,0x1a
    80206eb0:	00b7f463          	bgeu	a5,a1,80206eb8 <_Z8walkAddrPmm+0xc>
    80206eb4:	4501                	li	a0,0
  if ((*pte & PTE_V) == 0) return 0;
  // TODO 用户空间时修改
  if ((*pte & PTE_U) == 0) return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80206eb6:	8082                	ret
uint64_t walkAddr(pagetable_t pagetable, uint64_t va) {
    80206eb8:	1141                	addi	sp,sp,-16
    80206eba:	e406                	sd	ra,8(sp)
    80206ebc:	e022                	sd	s0,0(sp)
    80206ebe:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80206ec0:	4601                	li	a2,0
    80206ec2:	00000097          	auipc	ra,0x0
    80206ec6:	e94080e7          	jalr	-364(ra) # 80206d56 <_Z4walkPmmi>
  if (pte == 0) return 0;
    80206eca:	c105                	beqz	a0,80206eea <_Z8walkAddrPmm+0x3e>
  if ((*pte & PTE_V) == 0) return 0;
    80206ecc:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0) return 0;
    80206ece:	0117f693          	andi	a3,a5,17
    80206ed2:	4745                	li	a4,17
    80206ed4:	4501                	li	a0,0
    80206ed6:	00e68663          	beq	a3,a4,80206ee2 <_Z8walkAddrPmm+0x36>
}
    80206eda:	60a2                	ld	ra,8(sp)
    80206edc:	6402                	ld	s0,0(sp)
    80206ede:	0141                	addi	sp,sp,16
    80206ee0:	8082                	ret
  pa = PTE2PA(*pte);
    80206ee2:	00a7d513          	srli	a0,a5,0xa
    80206ee6:	0532                	slli	a0,a0,0xc
  return pa;
    80206ee8:	bfcd                	j	80206eda <_Z8walkAddrPmm+0x2e>
  if (pte == 0) return 0;
    80206eea:	4501                	li	a0,0
    80206eec:	b7fd                	j	80206eda <_Z8walkAddrPmm+0x2e>

0000000080206eee <_Z13kernel_vm_mapmmmi>:

void kernel_vm_map(uint64_t va, uint64_t pa, uint64_t sz, int perm) {
    80206eee:	1141                	addi	sp,sp,-16
    80206ef0:	e406                	sd	ra,8(sp)
    80206ef2:	e022                	sd	s0,0(sp)
    80206ef4:	0800                	addi	s0,sp,16
    80206ef6:	8736                	mv	a4,a3
  if (mappages(kernel_pagetable, va, sz, pa, perm) != 0) panic("kvmmap");
    80206ef8:	86ae                	mv	a3,a1
    80206efa:	85aa                	mv	a1,a0
    80206efc:	0008c517          	auipc	a0,0x8c
    80206f00:	2c453503          	ld	a0,708(a0) # 802931c0 <kernel_pagetable>
    80206f04:	00000097          	auipc	ra,0x0
    80206f08:	f0a080e7          	jalr	-246(ra) # 80206e0e <_Z8mappagesPmmmmi>
    80206f0c:	e509                	bnez	a0,80206f16 <_Z13kernel_vm_mapmmmi+0x28>
}
    80206f0e:	60a2                	ld	ra,8(sp)
    80206f10:	6402                	ld	s0,0(sp)
    80206f12:	0141                	addi	sp,sp,16
    80206f14:	8082                	ret
  if (mappages(kernel_pagetable, va, sz, pa, perm) != 0) panic("kvmmap");
    80206f16:	00004517          	auipc	a0,0x4
    80206f1a:	de250513          	addi	a0,a0,-542 # 8020acf8 <_ZTV16DeviceFileSystem+0xa8>
    80206f1e:	ffffa097          	auipc	ra,0xffffa
    80206f22:	8c4080e7          	jalr	-1852(ra) # 802007e2 <_Z5panicPKc>
}
    80206f26:	b7e5                	j	80206f0e <_Z13kernel_vm_mapmmmi+0x20>

0000000080206f28 <_Z12initKernelVmv>:
void initKernelVm() {
    80206f28:	1101                	addi	sp,sp,-32
    80206f2a:	ec06                	sd	ra,24(sp)
    80206f2c:	e822                	sd	s0,16(sp)
    80206f2e:	e426                	sd	s1,8(sp)
    80206f30:	1000                	addi	s0,sp,32
  kernel_pagetable = (pagetable_t)memAllocator.alloc();
    80206f32:	0000d517          	auipc	a0,0xd
    80206f36:	16e50513          	addi	a0,a0,366 # 802140a0 <memAllocator>
    80206f3a:	00000097          	auipc	ra,0x0
    80206f3e:	600080e7          	jalr	1536(ra) # 8020753a <_ZN12MemAllocator5allocEv>
    80206f42:	0008c797          	auipc	a5,0x8c
    80206f46:	26a7bf23          	sd	a0,638(a5) # 802931c0 <kernel_pagetable>
  memset(kernel_pagetable, 0, PGSIZE);
    80206f4a:	6605                	lui	a2,0x1
    80206f4c:	4581                	li	a1,0
    80206f4e:	ffffa097          	auipc	ra,0xffffa
    80206f52:	c0e080e7          	jalr	-1010(ra) # 80200b5c <_Z6memsetPvij>
  kernel_vm_map(UART_V, UART, PGSIZE, PTE_R | PTE_W);
    80206f56:	4699                	li	a3,6
    80206f58:	6605                	lui	a2,0x1
    80206f5a:	100005b7          	lui	a1,0x10000
    80206f5e:	3f100513          	li	a0,1009
    80206f62:	0572                	slli	a0,a0,0x1c
    80206f64:	00000097          	auipc	ra,0x0
    80206f68:	f8a080e7          	jalr	-118(ra) # 80206eee <_Z13kernel_vm_mapmmmi>
  kernel_vm_map(VIRTIO0_V, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80206f6c:	4699                	li	a3,6
    80206f6e:	6605                	lui	a2,0x1
    80206f70:	100015b7          	lui	a1,0x10001
    80206f74:	03f10537          	lui	a0,0x3f10
    80206f78:	0505                	addi	a0,a0,1
    80206f7a:	0532                	slli	a0,a0,0xc
    80206f7c:	00000097          	auipc	ra,0x0
    80206f80:	f72080e7          	jalr	-142(ra) # 80206eee <_Z13kernel_vm_mapmmmi>
  kernel_vm_map(PLIC_V, PLIC, 0x4000, PTE_R | PTE_W);
    80206f84:	4699                	li	a3,6
    80206f86:	6611                	lui	a2,0x4
    80206f88:	0c0005b7          	lui	a1,0xc000
    80206f8c:	00fc3537          	lui	a0,0xfc3
    80206f90:	053a                	slli	a0,a0,0xe
    80206f92:	00000097          	auipc	ra,0x0
    80206f96:	f5c080e7          	jalr	-164(ra) # 80206eee <_Z13kernel_vm_mapmmmi>
  kernel_vm_map(PLIC_V + 0x200000, PLIC + 0x200000, 0x4000, PTE_R | PTE_W);
    80206f9a:	4699                	li	a3,6
    80206f9c:	6611                	lui	a2,0x4
    80206f9e:	0c2005b7          	lui	a1,0xc200
    80206fa2:	1f861537          	lui	a0,0x1f861
    80206fa6:	0526                	slli	a0,a0,0x9
    80206fa8:	00000097          	auipc	ra,0x0
    80206fac:	f46080e7          	jalr	-186(ra) # 80206eee <_Z13kernel_vm_mapmmmi>
  kernel_vm_map(KERNBASE, KERNBASE, (uint64_t)etext - KERNBASE, PTE_R | PTE_X);
    80206fb0:	00002497          	auipc	s1,0x2
    80206fb4:	05048493          	addi	s1,s1,80 # 80209000 <etext>
    80206fb8:	46a9                	li	a3,10
    80206fba:	bff00613          	li	a2,-1025
    80206fbe:	0656                	slli	a2,a2,0x15
    80206fc0:	9626                	add	a2,a2,s1
    80206fc2:	40100593          	li	a1,1025
    80206fc6:	05d6                	slli	a1,a1,0x15
    80206fc8:	852e                	mv	a0,a1
    80206fca:	00000097          	auipc	ra,0x0
    80206fce:	f24080e7          	jalr	-220(ra) # 80206eee <_Z13kernel_vm_mapmmmi>
  kernel_vm_map((uint64_t)etext, (uint64_t)etext, PHYSTOP - (uint64_t)etext, PTE_R | PTE_W);
    80206fd2:	4699                	li	a3,6
    80206fd4:	40300613          	li	a2,1027
    80206fd8:	0656                	slli	a2,a2,0x15
    80206fda:	8e05                	sub	a2,a2,s1
    80206fdc:	85a6                	mv	a1,s1
    80206fde:	8526                	mv	a0,s1
    80206fe0:	00000097          	auipc	ra,0x0
    80206fe4:	f0e080e7          	jalr	-242(ra) # 80206eee <_Z13kernel_vm_mapmmmi>
  kernel_vm_map(TRAMPOLINE, (uint64_t)trampoline, PGSIZE, PTE_R | PTE_X);
    80206fe8:	46a9                	li	a3,10
    80206fea:	6605                	lui	a2,0x1
    80206fec:	00001597          	auipc	a1,0x1
    80206ff0:	01458593          	addi	a1,a1,20 # 80208000 <trampoline>
    80206ff4:	04000537          	lui	a0,0x4000
    80206ff8:	157d                	addi	a0,a0,-1
    80206ffa:	0532                	slli	a0,a0,0xc
    80206ffc:	00000097          	auipc	ra,0x0
    80207000:	ef2080e7          	jalr	-270(ra) # 80206eee <_Z13kernel_vm_mapmmmi>
}
    80207004:	60e2                	ld	ra,24(sp)
    80207006:	6442                	ld	s0,16(sp)
    80207008:	64a2                	ld	s1,8(sp)
    8020700a:	6105                	addi	sp,sp,32
    8020700c:	8082                	ret

000000008020700e <_Z9userAllocPmmm>:

uint64_t userAlloc(pagetable_t pagetable, uint64_t oldsz, uint64_t newsz) {
  char *mem;
  uint64_t a;
  if (newsz < oldsz) return oldsz;
    8020700e:	08b66163          	bltu	a2,a1,80207090 <_Z9userAllocPmmm+0x82>
uint64_t userAlloc(pagetable_t pagetable, uint64_t oldsz, uint64_t newsz) {
    80207012:	7139                	addi	sp,sp,-64
    80207014:	fc06                	sd	ra,56(sp)
    80207016:	f822                	sd	s0,48(sp)
    80207018:	f426                	sd	s1,40(sp)
    8020701a:	f04a                	sd	s2,32(sp)
    8020701c:	ec4e                	sd	s3,24(sp)
    8020701e:	e852                	sd	s4,16(sp)
    80207020:	e456                	sd	s5,8(sp)
    80207022:	0080                	addi	s0,sp,64
    80207024:	8a2a                	mv	s4,a0
    80207026:	89b2                	mv	s3,a2

  oldsz = PGROUNDUP(oldsz);
    80207028:	6905                	lui	s2,0x1
    8020702a:	197d                	addi	s2,s2,-1
    8020702c:	992e                	add	s2,s2,a1
    8020702e:	77fd                	lui	a5,0xfffff
    80207030:	00f97933          	and	s2,s2,a5
  for (a = oldsz; a < newsz; a += PGSIZE) {
    80207034:	06c97063          	bgeu	s2,a2,80207094 <_Z9userAllocPmmm+0x86>
    mem = static_cast<char *>(memAllocator.alloc());
    80207038:	0000da97          	auipc	s5,0xd
    8020703c:	068a8a93          	addi	s5,s5,104 # 802140a0 <memAllocator>
    80207040:	8556                	mv	a0,s5
    80207042:	00000097          	auipc	ra,0x0
    80207046:	4f8080e7          	jalr	1272(ra) # 8020753a <_ZN12MemAllocator5allocEv>
    8020704a:	84aa                	mv	s1,a0
    if (mem == 0) {
    8020704c:	c531                	beqz	a0,80207098 <_Z9userAllocPmmm+0x8a>
      //            uvmdealloc(pagetable, a, oldsz);
      // TODO 失败释放
      return 0;
    }
    memset(mem, 0, PGSIZE);
    8020704e:	6605                	lui	a2,0x1
    80207050:	4581                	li	a1,0
    80207052:	ffffa097          	auipc	ra,0xffffa
    80207056:	b0a080e7          	jalr	-1270(ra) # 80200b5c <_Z6memsetPvij>
    if (mappages(pagetable, a, PGSIZE, (uint64_t)mem, PTE_W | PTE_X | PTE_R | PTE_U) != 0) {
    8020705a:	4779                	li	a4,30
    8020705c:	86a6                	mv	a3,s1
    8020705e:	6605                	lui	a2,0x1
    80207060:	85ca                	mv	a1,s2
    80207062:	8552                	mv	a0,s4
    80207064:	00000097          	auipc	ra,0x0
    80207068:	daa080e7          	jalr	-598(ra) # 80206e0e <_Z8mappagesPmmmmi>
    8020706c:	e519                	bnez	a0,8020707a <_Z9userAllocPmmm+0x6c>
  for (a = oldsz; a < newsz; a += PGSIZE) {
    8020706e:	6785                	lui	a5,0x1
    80207070:	993e                	add	s2,s2,a5
    80207072:	fd3967e3          	bltu	s2,s3,80207040 <_Z9userAllocPmmm+0x32>
      //            uvmdealloc(pagetable, a, oldsz);
      // TODO 失败释放
      return 0;
    }
  }
  return newsz;
    80207076:	854e                	mv	a0,s3
    80207078:	a00d                	j	8020709a <_Z9userAllocPmmm+0x8c>
      memAllocator.free(mem);
    8020707a:	85a6                	mv	a1,s1
    8020707c:	0000d517          	auipc	a0,0xd
    80207080:	02450513          	addi	a0,a0,36 # 802140a0 <memAllocator>
    80207084:	00000097          	auipc	ra,0x0
    80207088:	50c080e7          	jalr	1292(ra) # 80207590 <_ZN12MemAllocator4freeEPv>
      return 0;
    8020708c:	4501                	li	a0,0
    8020708e:	a031                	j	8020709a <_Z9userAllocPmmm+0x8c>
  if (newsz < oldsz) return oldsz;
    80207090:	852e                	mv	a0,a1
}
    80207092:	8082                	ret
  return newsz;
    80207094:	8532                	mv	a0,a2
    80207096:	a011                	j	8020709a <_Z9userAllocPmmm+0x8c>
      return 0;
    80207098:	4501                	li	a0,0
}
    8020709a:	70e2                	ld	ra,56(sp)
    8020709c:	7442                	ld	s0,48(sp)
    8020709e:	74a2                	ld	s1,40(sp)
    802070a0:	7902                	ld	s2,32(sp)
    802070a2:	69e2                	ld	s3,24(sp)
    802070a4:	6a42                	ld	s4,16(sp)
    802070a6:	6aa2                	ld	s5,8(sp)
    802070a8:	6121                	addi	sp,sp,64
    802070aa:	8082                	ret

00000000802070ac <_Z10userCreatev>:

pagetable_t userCreate() {
    802070ac:	1101                	addi	sp,sp,-32
    802070ae:	ec06                	sd	ra,24(sp)
    802070b0:	e822                	sd	s0,16(sp)
    802070b2:	e426                	sd	s1,8(sp)
    802070b4:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)memAllocator.alloc();
    802070b6:	0000d517          	auipc	a0,0xd
    802070ba:	fea50513          	addi	a0,a0,-22 # 802140a0 <memAllocator>
    802070be:	00000097          	auipc	ra,0x0
    802070c2:	47c080e7          	jalr	1148(ra) # 8020753a <_ZN12MemAllocator5allocEv>
    802070c6:	84aa                	mv	s1,a0
  if (pagetable == 0) return 0;
    802070c8:	c519                	beqz	a0,802070d6 <_Z10userCreatev+0x2a>
  memset(pagetable, 0, PGSIZE);
    802070ca:	6605                	lui	a2,0x1
    802070cc:	4581                	li	a1,0
    802070ce:	ffffa097          	auipc	ra,0xffffa
    802070d2:	a8e080e7          	jalr	-1394(ra) # 80200b5c <_Z6memsetPvij>
  return pagetable;
}
    802070d6:	8526                	mv	a0,s1
    802070d8:	60e2                	ld	ra,24(sp)
    802070da:	6442                	ld	s0,16(sp)
    802070dc:	64a2                	ld	s1,8(sp)
    802070de:	6105                	addi	sp,sp,32
    802070e0:	8082                	ret

00000000802070e2 <_Z12user_vm_initPmPhj>:

void user_vm_init(pagetable_t pagetable, uchar_t *src, uint_t sz) {
    802070e2:	7179                	addi	sp,sp,-48
    802070e4:	f406                	sd	ra,40(sp)
    802070e6:	f022                	sd	s0,32(sp)
    802070e8:	ec26                	sd	s1,24(sp)
    802070ea:	e84a                	sd	s2,16(sp)
    802070ec:	e44e                	sd	s3,8(sp)
    802070ee:	e052                	sd	s4,0(sp)
    802070f0:	1800                	addi	s0,sp,48
    802070f2:	8a2a                	mv	s4,a0
    802070f4:	89ae                	mv	s3,a1
    802070f6:	8932                	mv	s2,a2
  char *mem;

  if (sz >= PGSIZE) panic("inituvm: more than a page");
    802070f8:	6785                	lui	a5,0x1
    802070fa:	04f67963          	bgeu	a2,a5,8020714c <_Z12user_vm_initPmPhj+0x6a>
  mem = static_cast<char *>(memAllocator.alloc());
    802070fe:	0000d517          	auipc	a0,0xd
    80207102:	fa250513          	addi	a0,a0,-94 # 802140a0 <memAllocator>
    80207106:	00000097          	auipc	ra,0x0
    8020710a:	434080e7          	jalr	1076(ra) # 8020753a <_ZN12MemAllocator5allocEv>
    8020710e:	84aa                	mv	s1,a0
  memset(mem, 0, PGSIZE);
    80207110:	6605                	lui	a2,0x1
    80207112:	4581                	li	a1,0
    80207114:	ffffa097          	auipc	ra,0xffffa
    80207118:	a48080e7          	jalr	-1464(ra) # 80200b5c <_Z6memsetPvij>
  mappages(pagetable, 0, PGSIZE, (uint64_t)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    8020711c:	4779                	li	a4,30
    8020711e:	86a6                	mv	a3,s1
    80207120:	6605                	lui	a2,0x1
    80207122:	4581                	li	a1,0
    80207124:	8552                	mv	a0,s4
    80207126:	00000097          	auipc	ra,0x0
    8020712a:	ce8080e7          	jalr	-792(ra) # 80206e0e <_Z8mappagesPmmmmi>
  memmove(mem, src, sz);
    8020712e:	864a                	mv	a2,s2
    80207130:	85ce                	mv	a1,s3
    80207132:	8526                	mv	a0,s1
    80207134:	ffffa097          	auipc	ra,0xffffa
    80207138:	a82080e7          	jalr	-1406(ra) # 80200bb6 <_Z7memmovePvPKvj>
}
    8020713c:	70a2                	ld	ra,40(sp)
    8020713e:	7402                	ld	s0,32(sp)
    80207140:	64e2                	ld	s1,24(sp)
    80207142:	6942                	ld	s2,16(sp)
    80207144:	69a2                	ld	s3,8(sp)
    80207146:	6a02                	ld	s4,0(sp)
    80207148:	6145                	addi	sp,sp,48
    8020714a:	8082                	ret
  if (sz >= PGSIZE) panic("inituvm: more than a page");
    8020714c:	00004517          	auipc	a0,0x4
    80207150:	bb450513          	addi	a0,a0,-1100 # 8020ad00 <_ZTV16DeviceFileSystem+0xb0>
    80207154:	ffff9097          	auipc	ra,0xffff9
    80207158:	68e080e7          	jalr	1678(ra) # 802007e2 <_Z5panicPKc>
    8020715c:	b74d                	j	802070fe <_Z12user_vm_initPmPhj+0x1c>

000000008020715e <_Z6copyinPmPcmm>:

int copyin(pagetable_t pagetable, char *dst, uint64_t vsrc, uint64_t len) {
  uint64_t n, va0, pa0;
  while (len > 0) {
    8020715e:	c6b5                	beqz	a3,802071ca <_Z6copyinPmPcmm+0x6c>
int copyin(pagetable_t pagetable, char *dst, uint64_t vsrc, uint64_t len) {
    80207160:	715d                	addi	sp,sp,-80
    80207162:	e486                	sd	ra,72(sp)
    80207164:	e0a2                	sd	s0,64(sp)
    80207166:	fc26                	sd	s1,56(sp)
    80207168:	f84a                	sd	s2,48(sp)
    8020716a:	f44e                	sd	s3,40(sp)
    8020716c:	f052                	sd	s4,32(sp)
    8020716e:	ec56                	sd	s5,24(sp)
    80207170:	e85a                	sd	s6,16(sp)
    80207172:	e45e                	sd	s7,8(sp)
    80207174:	e062                	sd	s8,0(sp)
    80207176:	0880                	addi	s0,sp,80
    80207178:	8b2a                	mv	s6,a0
    8020717a:	8aae                	mv	s5,a1
    8020717c:	8932                	mv	s2,a2
    8020717e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(vsrc);
    80207180:	7bfd                	lui	s7,0xfffff
    pa0 = walkAddr(pagetable, va0);
    if (pa0 == 0) {
      return -1;
    }
    n = PGSIZE - (vsrc - va0);
    80207182:	6c05                	lui	s8,0x1
    80207184:	a00d                	j	802071a6 <_Z6copyinPmPcmm+0x48>
    if (n > len) {
      n = len;
    }
    memmove(dst, (void *)(pa0 + (vsrc - va0)), n);
    80207186:	954a                	add	a0,a0,s2
    80207188:	0004861b          	sext.w	a2,s1
    8020718c:	414505b3          	sub	a1,a0,s4
    80207190:	8556                	mv	a0,s5
    80207192:	ffffa097          	auipc	ra,0xffffa
    80207196:	a24080e7          	jalr	-1500(ra) # 80200bb6 <_Z7memmovePvPKvj>
    len -= n;
    8020719a:	409989b3          	sub	s3,s3,s1
    dst += n;
    8020719e:	9aa6                	add	s5,s5,s1
    vsrc += n;
    802071a0:	9926                	add	s2,s2,s1
  while (len > 0) {
    802071a2:	02098263          	beqz	s3,802071c6 <_Z6copyinPmPcmm+0x68>
    va0 = PGROUNDDOWN(vsrc);
    802071a6:	01797a33          	and	s4,s2,s7
    pa0 = walkAddr(pagetable, va0);
    802071aa:	85d2                	mv	a1,s4
    802071ac:	855a                	mv	a0,s6
    802071ae:	00000097          	auipc	ra,0x0
    802071b2:	cfe080e7          	jalr	-770(ra) # 80206eac <_Z8walkAddrPmm>
    if (pa0 == 0) {
    802071b6:	cd01                	beqz	a0,802071ce <_Z6copyinPmPcmm+0x70>
    n = PGSIZE - (vsrc - va0);
    802071b8:	412a04b3          	sub	s1,s4,s2
    802071bc:	94e2                	add	s1,s1,s8
    if (n > len) {
    802071be:	fc99f4e3          	bgeu	s3,s1,80207186 <_Z6copyinPmPcmm+0x28>
    802071c2:	84ce                	mv	s1,s3
    802071c4:	b7c9                	j	80207186 <_Z6copyinPmPcmm+0x28>
  }
  return 0;
    802071c6:	4501                	li	a0,0
    802071c8:	a021                	j	802071d0 <_Z6copyinPmPcmm+0x72>
    802071ca:	4501                	li	a0,0
}
    802071cc:	8082                	ret
      return -1;
    802071ce:	557d                	li	a0,-1
}
    802071d0:	60a6                	ld	ra,72(sp)
    802071d2:	6406                	ld	s0,64(sp)
    802071d4:	74e2                	ld	s1,56(sp)
    802071d6:	7942                	ld	s2,48(sp)
    802071d8:	79a2                	ld	s3,40(sp)
    802071da:	7a02                	ld	s4,32(sp)
    802071dc:	6ae2                	ld	s5,24(sp)
    802071de:	6b42                	ld	s6,16(sp)
    802071e0:	6ba2                	ld	s7,8(sp)
    802071e2:	6c02                	ld	s8,0(sp)
    802071e4:	6161                	addi	sp,sp,80
    802071e6:	8082                	ret

00000000802071e8 <_Z9copyinstrPmPcmi>:

int copyinstr(pagetable_t pagetable, char *dst, uint64_t vsrc, int maxsz) {
  uint64_t va0, pa0 = 0;
  int got_null = 0, n;

  while (got_null == 0 && maxsz > 0) {
    802071e8:	0cd05663          	blez	a3,802072b4 <_Z9copyinstrPmPcmi+0xcc>
int copyinstr(pagetable_t pagetable, char *dst, uint64_t vsrc, int maxsz) {
    802071ec:	715d                	addi	sp,sp,-80
    802071ee:	e486                	sd	ra,72(sp)
    802071f0:	e0a2                	sd	s0,64(sp)
    802071f2:	fc26                	sd	s1,56(sp)
    802071f4:	f84a                	sd	s2,48(sp)
    802071f6:	f44e                	sd	s3,40(sp)
    802071f8:	f052                	sd	s4,32(sp)
    802071fa:	ec56                	sd	s5,24(sp)
    802071fc:	e85a                	sd	s6,16(sp)
    802071fe:	e45e                	sd	s7,8(sp)
    80207200:	e062                	sd	s8,0(sp)
    80207202:	0880                	addi	s0,sp,80
    80207204:	89aa                	mv	s3,a0
    80207206:	84ae                	mv	s1,a1
    80207208:	8c32                	mv	s8,a2
    8020720a:	8bb6                	mv	s7,a3
    va0 = PGROUNDDOWN(vsrc);
    8020720c:	7a7d                	lui	s4,0xfffff
    pa0 = walkAddr(pagetable, va0);
    if (pa0 == 0) {
      return -1;
    }
    n = PGSIZE - (vsrc - va0);
    8020720e:	6a85                	lui	s5,0x1
      n--;
      maxsz--;
      dst++;
      p++;
    }
    vsrc = va0 + PGSIZE;
    80207210:	6b05                	lui	s6,0x1
    80207212:	a805                	j	80207242 <_Z9copyinstrPmPcmi+0x5a>
        *dst = 0;
    80207214:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x801ff000>
    80207218:	4785                	li	a5,1
  }
  if (got_null) {
    8020721a:	0017b793          	seqz	a5,a5
    8020721e:	40f00533          	neg	a0,a5
    return 0;
  }
  return -1;
}
    80207222:	60a6                	ld	ra,72(sp)
    80207224:	6406                	ld	s0,64(sp)
    80207226:	74e2                	ld	s1,56(sp)
    80207228:	7942                	ld	s2,48(sp)
    8020722a:	79a2                	ld	s3,40(sp)
    8020722c:	7a02                	ld	s4,32(sp)
    8020722e:	6ae2                	ld	s5,24(sp)
    80207230:	6b42                	ld	s6,16(sp)
    80207232:	6ba2                	ld	s7,8(sp)
    80207234:	6c02                	ld	s8,0(sp)
    80207236:	6161                	addi	sp,sp,80
    80207238:	8082                	ret
    vsrc = va0 + PGSIZE;
    8020723a:	01690c33          	add	s8,s2,s6
  while (got_null == 0 && maxsz > 0) {
    8020723e:	07705763          	blez	s7,802072ac <_Z9copyinstrPmPcmi+0xc4>
    va0 = PGROUNDDOWN(vsrc);
    80207242:	014c7933          	and	s2,s8,s4
    pa0 = walkAddr(pagetable, va0);
    80207246:	85ca                	mv	a1,s2
    80207248:	854e                	mv	a0,s3
    8020724a:	00000097          	auipc	ra,0x0
    8020724e:	c62080e7          	jalr	-926(ra) # 80206eac <_Z8walkAddrPmm>
    if (pa0 == 0) {
    80207252:	cd39                	beqz	a0,802072b0 <_Z9copyinstrPmPcmi+0xc8>
    n = PGSIZE - (vsrc - va0);
    80207254:	4189073b          	subw	a4,s2,s8
    80207258:	0157073b          	addw	a4,a4,s5
    if (n > maxsz) {
    8020725c:	87ba                	mv	a5,a4
    8020725e:	2701                	sext.w	a4,a4
    80207260:	00ebd363          	bge	s7,a4,80207266 <_Z9copyinstrPmPcmi+0x7e>
    80207264:	87de                	mv	a5,s7
    80207266:	0007871b          	sext.w	a4,a5
    char *p = (char *)(pa0 + (vsrc - va0));
    8020726a:	9562                	add	a0,a0,s8
    8020726c:	41250533          	sub	a0,a0,s2
    while (n > 0) {
    80207270:	fce055e3          	blez	a4,8020723a <_Z9copyinstrPmPcmi+0x52>
    80207274:	fff7881b          	addiw	a6,a5,-1
    80207278:	1802                	slli	a6,a6,0x20
    8020727a:	02085813          	srli	a6,a6,0x20
    8020727e:	0805                	addi	a6,a6,1
    80207280:	9826                	add	a6,a6,s1
    80207282:	87a6                	mv	a5,s1
      if (*p == 0) {
    80207284:	40950633          	sub	a2,a0,s1
    80207288:	009b84bb          	addw	s1,s7,s1
    8020728c:	fff4859b          	addiw	a1,s1,-1
    80207290:	00c78733          	add	a4,a5,a2
    80207294:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7fd67000>
    80207298:	df35                	beqz	a4,80207214 <_Z9copyinstrPmPcmi+0x2c>
        *dst = *p;
    8020729a:	00e78023          	sb	a4,0(a5)
      maxsz--;
    8020729e:	40f58bbb          	subw	s7,a1,a5
      dst++;
    802072a2:	0785                	addi	a5,a5,1
    while (n > 0) {
    802072a4:	ff0796e3          	bne	a5,a6,80207290 <_Z9copyinstrPmPcmi+0xa8>
      dst++;
    802072a8:	84c2                	mv	s1,a6
    802072aa:	bf41                	j	8020723a <_Z9copyinstrPmPcmi+0x52>
    802072ac:	4781                	li	a5,0
    802072ae:	b7b5                	j	8020721a <_Z9copyinstrPmPcmi+0x32>
      return -1;
    802072b0:	557d                	li	a0,-1
    802072b2:	bf85                	j	80207222 <_Z9copyinstrPmPcmi+0x3a>
  int got_null = 0, n;
    802072b4:	4781                	li	a5,0
  if (got_null) {
    802072b6:	0017b793          	seqz	a5,a5
    802072ba:	40f00533          	neg	a0,a5
}
    802072be:	8082                	ret

00000000802072c0 <_Z7copyoutPmmPci>:

int copyout(pagetable_t pagetable, uint64_t vdst, char *src, int len) {
  uint64_t va0, pa0;
  int n;
  while (len > 0) {
    802072c0:	06d05c63          	blez	a3,80207338 <_Z7copyoutPmmPci+0x78>
int copyout(pagetable_t pagetable, uint64_t vdst, char *src, int len) {
    802072c4:	711d                	addi	sp,sp,-96
    802072c6:	ec86                	sd	ra,88(sp)
    802072c8:	e8a2                	sd	s0,80(sp)
    802072ca:	e4a6                	sd	s1,72(sp)
    802072cc:	e0ca                	sd	s2,64(sp)
    802072ce:	fc4e                	sd	s3,56(sp)
    802072d0:	f852                	sd	s4,48(sp)
    802072d2:	f456                	sd	s5,40(sp)
    802072d4:	f05a                	sd	s6,32(sp)
    802072d6:	ec5e                	sd	s7,24(sp)
    802072d8:	e862                	sd	s8,16(sp)
    802072da:	e466                	sd	s9,8(sp)
    802072dc:	1080                	addi	s0,sp,96
    802072de:	8aaa                	mv	s5,a0
    802072e0:	84ae                	mv	s1,a1
    802072e2:	8a32                	mv	s4,a2
    802072e4:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(vdst);
    802072e6:	7b7d                	lui	s6,0xfffff
    pa0 = walkAddr(pagetable, va0);
    if (pa0 == 0) {
      return -1;
    }
    n = PGSIZE - (vdst - va0);
    802072e8:	6b85                	lui	s7,0x1
    802072ea:	a015                	j	8020730e <_Z7copyoutPmmPci+0x4e>
    802072ec:	000c0c9b          	sext.w	s9,s8
    if (n > len) {
      n = len;
    }
    memmove((void *)(pa0 + (vdst - va0)), src, n);
    802072f0:	9526                	add	a0,a0,s1
    802072f2:	8666                	mv	a2,s9
    802072f4:	85d2                	mv	a1,s4
    802072f6:	41350533          	sub	a0,a0,s3
    802072fa:	ffffa097          	auipc	ra,0xffffa
    802072fe:	8bc080e7          	jalr	-1860(ra) # 80200bb6 <_Z7memmovePvPKvj>
    len -= n;
    80207302:	4189093b          	subw	s2,s2,s8
    vdst += n;
    80207306:	94e6                	add	s1,s1,s9
    src += n;
    80207308:	9a66                	add	s4,s4,s9
  while (len > 0) {
    8020730a:	03205563          	blez	s2,80207334 <_Z7copyoutPmmPci+0x74>
    va0 = PGROUNDDOWN(vdst);
    8020730e:	0164f9b3          	and	s3,s1,s6
    pa0 = walkAddr(pagetable, va0);
    80207312:	85ce                	mv	a1,s3
    80207314:	8556                	mv	a0,s5
    80207316:	00000097          	auipc	ra,0x0
    8020731a:	b96080e7          	jalr	-1130(ra) # 80206eac <_Z8walkAddrPmm>
    if (pa0 == 0) {
    8020731e:	cd19                	beqz	a0,8020733c <_Z7copyoutPmmPci+0x7c>
    n = PGSIZE - (vdst - va0);
    80207320:	409987bb          	subw	a5,s3,s1
    80207324:	017787bb          	addw	a5,a5,s7
    if (n > len) {
    80207328:	8c3e                	mv	s8,a5
    8020732a:	2781                	sext.w	a5,a5
    8020732c:	fcf950e3          	bge	s2,a5,802072ec <_Z7copyoutPmmPci+0x2c>
    80207330:	8c4a                	mv	s8,s2
    80207332:	bf6d                	j	802072ec <_Z7copyoutPmmPci+0x2c>
  }
  return 0;
    80207334:	4501                	li	a0,0
    80207336:	a021                	j	8020733e <_Z7copyoutPmmPci+0x7e>
    80207338:	4501                	li	a0,0
}
    8020733a:	8082                	ret
      return -1;
    8020733c:	557d                	li	a0,-1
}
    8020733e:	60e6                	ld	ra,88(sp)
    80207340:	6446                	ld	s0,80(sp)
    80207342:	64a6                	ld	s1,72(sp)
    80207344:	6906                	ld	s2,64(sp)
    80207346:	79e2                	ld	s3,56(sp)
    80207348:	7a42                	ld	s4,48(sp)
    8020734a:	7aa2                	ld	s5,40(sp)
    8020734c:	7b02                	ld	s6,32(sp)
    8020734e:	6be2                	ld	s7,24(sp)
    80207350:	6c42                	ld	s8,16(sp)
    80207352:	6ca2                	ld	s9,8(sp)
    80207354:	6125                	addi	sp,sp,96
    80207356:	8082                	ret

0000000080207358 <_Z12user_vm_copyPmS_i>:
int user_vm_copy(pagetable_t oldPg, pagetable_t newPg, int sz) {
  pte_t *pte;
  uint64_t pa;
  uint_t flags;
  char *mem;
  for (int i = 0; i < sz; i += PGSIZE) {
    80207358:	10c05c63          	blez	a2,80207470 <_Z12user_vm_copyPmS_i+0x118>
int user_vm_copy(pagetable_t oldPg, pagetable_t newPg, int sz) {
    8020735c:	7159                	addi	sp,sp,-112
    8020735e:	f486                	sd	ra,104(sp)
    80207360:	f0a2                	sd	s0,96(sp)
    80207362:	eca6                	sd	s1,88(sp)
    80207364:	e8ca                	sd	s2,80(sp)
    80207366:	e4ce                	sd	s3,72(sp)
    80207368:	e0d2                	sd	s4,64(sp)
    8020736a:	fc56                	sd	s5,56(sp)
    8020736c:	f85a                	sd	s6,48(sp)
    8020736e:	f45e                	sd	s7,40(sp)
    80207370:	f062                	sd	s8,32(sp)
    80207372:	ec66                	sd	s9,24(sp)
    80207374:	e86a                	sd	s10,16(sp)
    80207376:	e46e                	sd	s11,8(sp)
    80207378:	1880                	addi	s0,sp,112
    8020737a:	8b2a                	mv	s6,a0
    8020737c:	8bae                	mv	s7,a1
    8020737e:	fff60a9b          	addiw	s5,a2,-1
    80207382:	00cada9b          	srliw	s5,s5,0xc
    80207386:	0a85                	addi	s5,s5,1
    80207388:	0ab2                	slli	s5,s5,0xc
  for (int i = 0; i < sz; i += PGSIZE) {
    8020738a:	4901                	li	s2,0
    if ((pte = walk(oldPg, i, 0)) == 0) {
      panic("user_vm_copy: pte not present");
    8020738c:	00004d97          	auipc	s11,0x4
    80207390:	994d8d93          	addi	s11,s11,-1644 # 8020ad20 <_ZTV16DeviceFileSystem+0xd0>
    }
    if ((*pte & PTE_V) == 0) {
      panic("user_vm_copy: pte invalid");
    80207394:	00004c97          	auipc	s9,0x4
    80207398:	9acc8c93          	addi	s9,s9,-1620 # 8020ad40 <_ZTV16DeviceFileSystem+0xf0>
    }
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);

    if ((mem = static_cast<char *>(memAllocator.alloc())) == 0) {
    8020739c:	0000dc17          	auipc	s8,0xd
    802073a0:	d04c0c13          	addi	s8,s8,-764 # 802140a0 <memAllocator>
      panic("user_vm_copy: alloc mem fail");
    }
    memmove(mem, (void *)pa, PGSIZE);
    if (mappages(newPg, i, PGSIZE, (uint64_t)mem, flags) < 0) {
      memAllocator.free(mem);
      panic("user_vm_copy: mappages fail");
    802073a4:	00004d17          	auipc	s10,0x4
    802073a8:	9dcd0d13          	addi	s10,s10,-1572 # 8020ad80 <_ZTV16DeviceFileSystem+0x130>
    802073ac:	a085                	j	8020740c <_Z12user_vm_copyPmS_i+0xb4>
      panic("user_vm_copy: pte not present");
    802073ae:	856e                	mv	a0,s11
    802073b0:	ffff9097          	auipc	ra,0xffff9
    802073b4:	432080e7          	jalr	1074(ra) # 802007e2 <_Z5panicPKc>
    802073b8:	a09d                	j	8020741e <_Z12user_vm_copyPmS_i+0xc6>
      panic("user_vm_copy: pte invalid");
    802073ba:	8566                	mv	a0,s9
    802073bc:	ffff9097          	auipc	ra,0xffff9
    802073c0:	426080e7          	jalr	1062(ra) # 802007e2 <_Z5panicPKc>
    pa = PTE2PA(*pte);
    802073c4:	0004b983          	ld	s3,0(s1)
    802073c8:	00a9da13          	srli	s4,s3,0xa
    802073cc:	0a32                	slli	s4,s4,0xc
    flags = PTE_FLAGS(*pte);
    802073ce:	3ff9f993          	andi	s3,s3,1023
    if ((mem = static_cast<char *>(memAllocator.alloc())) == 0) {
    802073d2:	8562                	mv	a0,s8
    802073d4:	00000097          	auipc	ra,0x0
    802073d8:	166080e7          	jalr	358(ra) # 8020753a <_ZN12MemAllocator5allocEv>
    802073dc:	84aa                	mv	s1,a0
    802073de:	c521                	beqz	a0,80207426 <_Z12user_vm_copyPmS_i+0xce>
    memmove(mem, (void *)pa, PGSIZE);
    802073e0:	6605                	lui	a2,0x1
    802073e2:	85d2                	mv	a1,s4
    802073e4:	8526                	mv	a0,s1
    802073e6:	ffff9097          	auipc	ra,0xffff9
    802073ea:	7d0080e7          	jalr	2000(ra) # 80200bb6 <_Z7memmovePvPKvj>
    if (mappages(newPg, i, PGSIZE, (uint64_t)mem, flags) < 0) {
    802073ee:	874e                	mv	a4,s3
    802073f0:	86a6                	mv	a3,s1
    802073f2:	6605                	lui	a2,0x1
    802073f4:	85ca                	mv	a1,s2
    802073f6:	855e                	mv	a0,s7
    802073f8:	00000097          	auipc	ra,0x0
    802073fc:	a16080e7          	jalr	-1514(ra) # 80206e0e <_Z8mappagesPmmmmi>
    80207400:	02054c63          	bltz	a0,80207438 <_Z12user_vm_copyPmS_i+0xe0>
  for (int i = 0; i < sz; i += PGSIZE) {
    80207404:	6785                	lui	a5,0x1
    80207406:	993e                	add	s2,s2,a5
    80207408:	05590463          	beq	s2,s5,80207450 <_Z12user_vm_copyPmS_i+0xf8>
    if ((pte = walk(oldPg, i, 0)) == 0) {
    8020740c:	4601                	li	a2,0
    8020740e:	85ca                	mv	a1,s2
    80207410:	855a                	mv	a0,s6
    80207412:	00000097          	auipc	ra,0x0
    80207416:	944080e7          	jalr	-1724(ra) # 80206d56 <_Z4walkPmmi>
    8020741a:	84aa                	mv	s1,a0
    8020741c:	d949                	beqz	a0,802073ae <_Z12user_vm_copyPmS_i+0x56>
    if ((*pte & PTE_V) == 0) {
    8020741e:	609c                	ld	a5,0(s1)
    80207420:	8b85                	andi	a5,a5,1
    80207422:	f3cd                	bnez	a5,802073c4 <_Z12user_vm_copyPmS_i+0x6c>
    80207424:	bf59                	j	802073ba <_Z12user_vm_copyPmS_i+0x62>
      panic("user_vm_copy: alloc mem fail");
    80207426:	00004517          	auipc	a0,0x4
    8020742a:	93a50513          	addi	a0,a0,-1734 # 8020ad60 <_ZTV16DeviceFileSystem+0x110>
    8020742e:	ffff9097          	auipc	ra,0xffff9
    80207432:	3b4080e7          	jalr	948(ra) # 802007e2 <_Z5panicPKc>
    80207436:	b76d                	j	802073e0 <_Z12user_vm_copyPmS_i+0x88>
      memAllocator.free(mem);
    80207438:	85a6                	mv	a1,s1
    8020743a:	8562                	mv	a0,s8
    8020743c:	00000097          	auipc	ra,0x0
    80207440:	154080e7          	jalr	340(ra) # 80207590 <_ZN12MemAllocator4freeEPv>
      panic("user_vm_copy: mappages fail");
    80207444:	856a                	mv	a0,s10
    80207446:	ffff9097          	auipc	ra,0xffff9
    8020744a:	39c080e7          	jalr	924(ra) # 802007e2 <_Z5panicPKc>
    8020744e:	bf5d                	j	80207404 <_Z12user_vm_copyPmS_i+0xac>
    }
  }
  return 0;
}
    80207450:	4501                	li	a0,0
    80207452:	70a6                	ld	ra,104(sp)
    80207454:	7406                	ld	s0,96(sp)
    80207456:	64e6                	ld	s1,88(sp)
    80207458:	6946                	ld	s2,80(sp)
    8020745a:	69a6                	ld	s3,72(sp)
    8020745c:	6a06                	ld	s4,64(sp)
    8020745e:	7ae2                	ld	s5,56(sp)
    80207460:	7b42                	ld	s6,48(sp)
    80207462:	7ba2                	ld	s7,40(sp)
    80207464:	7c02                	ld	s8,32(sp)
    80207466:	6ce2                	ld	s9,24(sp)
    80207468:	6d42                	ld	s10,16(sp)
    8020746a:	6da2                	ld	s11,8(sp)
    8020746c:	6165                	addi	sp,sp,112
    8020746e:	8082                	ret
    80207470:	4501                	li	a0,0
    80207472:	8082                	ret

0000000080207474 <_Z7vmprintPmi>:

void vmprint(pagetable_t pagetable, int n) {
    80207474:	711d                	addi	sp,sp,-96
    80207476:	ec86                	sd	ra,88(sp)
    80207478:	e8a2                	sd	s0,80(sp)
    8020747a:	e4a6                	sd	s1,72(sp)
    8020747c:	e0ca                	sd	s2,64(sp)
    8020747e:	fc4e                	sd	s3,56(sp)
    80207480:	f852                	sd	s4,48(sp)
    80207482:	f456                	sd	s5,40(sp)
    80207484:	f05a                	sd	s6,32(sp)
    80207486:	ec5e                	sd	s7,24(sp)
    80207488:	e862                	sd	s8,16(sp)
    8020748a:	e466                	sd	s9,8(sp)
    8020748c:	e06a                	sd	s10,0(sp)
    8020748e:	1080                	addi	s0,sp,96
    80207490:	892a                	mv	s2,a0
    80207492:	8c2e                	mv	s8,a1
  if (n == 1) {
    80207494:	4785                	li	a5,1
    80207496:	02f58463          	beq	a1,a5,802074be <_Z7vmprintPmi+0x4a>
    printf("page table %p\n", pagetable);
  }
  if (n >= 4) {
    8020749a:	478d                	li	a5,3
    8020749c:	08b7c163          	blt	a5,a1,8020751e <_Z7vmprintPmi+0xaa>
    return;
  }
  for (int i = 0; i < 512; i++) {
    802074a0:	4481                	li	s1,0
    if (pte & PTE_V) {
      for (int j = 1; j <= n; j++) {
        printf(".. ");
      }
      uint64_t child = PTE2PA(pte);
      printf("%d: pte %p pa %p\n", i, pte, child);
    802074a2:	00004c97          	auipc	s9,0x4
    802074a6:	916c8c93          	addi	s9,s9,-1770 # 8020adb8 <_ZTV16DeviceFileSystem+0x168>
      vmprint((pagetable_t)child, n + 1);
    802074aa:	001c0a9b          	addiw	s5,s8,1
      for (int j = 1; j <= n; j++) {
    802074ae:	4d05                	li	s10,1
        printf(".. ");
    802074b0:	00004b97          	auipc	s7,0x4
    802074b4:	900b8b93          	addi	s7,s7,-1792 # 8020adb0 <_ZTV16DeviceFileSystem+0x160>
  for (int i = 0; i < 512; i++) {
    802074b8:	20000b13          	li	s6,512
    802074bc:	a081                	j	802074fc <_Z7vmprintPmi+0x88>
    printf("page table %p\n", pagetable);
    802074be:	85aa                	mv	a1,a0
    802074c0:	00004517          	auipc	a0,0x4
    802074c4:	8e050513          	addi	a0,a0,-1824 # 8020ada0 <_ZTV16DeviceFileSystem+0x150>
    802074c8:	ffff9097          	auipc	ra,0xffff9
    802074cc:	38c080e7          	jalr	908(ra) # 80200854 <_Z6printfPKcz>
  if (n >= 4) {
    802074d0:	bfc1                	j	802074a0 <_Z7vmprintPmi+0x2c>
      uint64_t child = PTE2PA(pte);
    802074d2:	00aa5993          	srli	s3,s4,0xa
    802074d6:	09b2                	slli	s3,s3,0xc
      printf("%d: pte %p pa %p\n", i, pte, child);
    802074d8:	86ce                	mv	a3,s3
    802074da:	8652                	mv	a2,s4
    802074dc:	85a6                	mv	a1,s1
    802074de:	8566                	mv	a0,s9
    802074e0:	ffff9097          	auipc	ra,0xffff9
    802074e4:	374080e7          	jalr	884(ra) # 80200854 <_Z6printfPKcz>
      vmprint((pagetable_t)child, n + 1);
    802074e8:	85d6                	mv	a1,s5
    802074ea:	854e                	mv	a0,s3
    802074ec:	00000097          	auipc	ra,0x0
    802074f0:	f88080e7          	jalr	-120(ra) # 80207474 <_Z7vmprintPmi>
  for (int i = 0; i < 512; i++) {
    802074f4:	2485                	addiw	s1,s1,1
    802074f6:	0921                	addi	s2,s2,8
    802074f8:	03648363          	beq	s1,s6,8020751e <_Z7vmprintPmi+0xaa>
    pte_t pte = pagetable[i];
    802074fc:	00093a03          	ld	s4,0(s2) # 1000 <_entry-0x801ff000>
    if (pte & PTE_V) {
    80207500:	001a7793          	andi	a5,s4,1
    80207504:	dbe5                	beqz	a5,802074f4 <_Z7vmprintPmi+0x80>
      for (int j = 1; j <= n; j++) {
    80207506:	fd8056e3          	blez	s8,802074d2 <_Z7vmprintPmi+0x5e>
    8020750a:	89ea                	mv	s3,s10
        printf(".. ");
    8020750c:	855e                	mv	a0,s7
    8020750e:	ffff9097          	auipc	ra,0xffff9
    80207512:	346080e7          	jalr	838(ra) # 80200854 <_Z6printfPKcz>
      for (int j = 1; j <= n; j++) {
    80207516:	2985                	addiw	s3,s3,1
    80207518:	ff3a9ae3          	bne	s5,s3,8020750c <_Z7vmprintPmi+0x98>
    8020751c:	bf5d                	j	802074d2 <_Z7vmprintPmi+0x5e>
    }
  }
    8020751e:	60e6                	ld	ra,88(sp)
    80207520:	6446                	ld	s0,80(sp)
    80207522:	64a6                	ld	s1,72(sp)
    80207524:	6906                	ld	s2,64(sp)
    80207526:	79e2                	ld	s3,56(sp)
    80207528:	7a42                	ld	s4,48(sp)
    8020752a:	7aa2                	ld	s5,40(sp)
    8020752c:	7b02                	ld	s6,32(sp)
    8020752e:	6be2                	ld	s7,24(sp)
    80207530:	6c42                	ld	s8,16(sp)
    80207532:	6ca2                	ld	s9,8(sp)
    80207534:	6d02                	ld	s10,0(sp)
    80207536:	6125                	addi	sp,sp,96
    80207538:	8082                	ret

000000008020753a <_ZN12MemAllocator5allocEv>:
  char *p;
  p = (char *)PGROUNDUP((uint64_t)paStart);
  for (; p + PGSIZE <= (char *)paEnd; p += PGSIZE) free(p);
}

void *MemAllocator::alloc() {
    8020753a:	1101                	addi	sp,sp,-32
    8020753c:	ec06                	sd	ra,24(sp)
    8020753e:	e822                	sd	s0,16(sp)
    80207540:	e426                	sd	s1,8(sp)
    80207542:	e04a                	sd	s2,0(sp)
    80207544:	1000                	addi	s0,sp,32
    80207546:	84aa                	mv	s1,a0
  struct Node *r;

  this->spinLock.lock();
    80207548:	ffffa097          	auipc	ra,0xffffa
    8020754c:	904080e7          	jalr	-1788(ra) # 80200e4c <_ZN8SpinLock4lockEv>
  r = this->freeList;
    80207550:	0184b903          	ld	s2,24(s1)
  if (r) this->freeList = r->next;
    80207554:	02090863          	beqz	s2,80207584 <_ZN12MemAllocator5allocEv+0x4a>
    80207558:	00093783          	ld	a5,0(s2)
    8020755c:	ec9c                	sd	a5,24(s1)
  this->spinLock.unlock();
    8020755e:	8526                	mv	a0,s1
    80207560:	ffffa097          	auipc	ra,0xffffa
    80207564:	968080e7          	jalr	-1688(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>

  if (r) memset((char *)r, 5, PGSIZE);  // fill with junk
    80207568:	6605                	lui	a2,0x1
    8020756a:	4595                	li	a1,5
    8020756c:	854a                	mv	a0,s2
    8020756e:	ffff9097          	auipc	ra,0xffff9
    80207572:	5ee080e7          	jalr	1518(ra) # 80200b5c <_Z6memsetPvij>
  return (void *)r;
}
    80207576:	854a                	mv	a0,s2
    80207578:	60e2                	ld	ra,24(sp)
    8020757a:	6442                	ld	s0,16(sp)
    8020757c:	64a2                	ld	s1,8(sp)
    8020757e:	6902                	ld	s2,0(sp)
    80207580:	6105                	addi	sp,sp,32
    80207582:	8082                	ret
  this->spinLock.unlock();
    80207584:	8526                	mv	a0,s1
    80207586:	ffffa097          	auipc	ra,0xffffa
    8020758a:	942080e7          	jalr	-1726(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
  if (r) memset((char *)r, 5, PGSIZE);  // fill with junk
    8020758e:	b7e5                	j	80207576 <_ZN12MemAllocator5allocEv+0x3c>

0000000080207590 <_ZN12MemAllocator4freeEPv>:

void MemAllocator::free(void *pa) {
    80207590:	1101                	addi	sp,sp,-32
    80207592:	ec06                	sd	ra,24(sp)
    80207594:	e822                	sd	s0,16(sp)
    80207596:	e426                	sd	s1,8(sp)
    80207598:	e04a                	sd	s2,0(sp)
    8020759a:	1000                	addi	s0,sp,32
    8020759c:	892a                	mv	s2,a0
    8020759e:	84ae                	mv	s1,a1
  struct Node *r;
  if (((uint64_t)pa % PGSIZE) != 0 || (char *)pa < end || (uint64_t)pa >= PHYSTOP) panic("kfree");
    802075a0:	03459793          	slli	a5,a1,0x34
    802075a4:	ef81                	bnez	a5,802075bc <_ZN12MemAllocator4freeEPv+0x2c>
    802075a6:	00091797          	auipc	a5,0x91
    802075aa:	a5a78793          	addi	a5,a5,-1446 # 80298000 <end>
    802075ae:	00f5e763          	bltu	a1,a5,802075bc <_ZN12MemAllocator4freeEPv+0x2c>
    802075b2:	40300793          	li	a5,1027
    802075b6:	07d6                	slli	a5,a5,0x15
    802075b8:	00f5ea63          	bltu	a1,a5,802075cc <_ZN12MemAllocator4freeEPv+0x3c>
    802075bc:	00004517          	auipc	a0,0x4
    802075c0:	81450513          	addi	a0,a0,-2028 # 8020add0 <_ZTV16DeviceFileSystem+0x180>
    802075c4:	ffff9097          	auipc	ra,0xffff9
    802075c8:	21e080e7          	jalr	542(ra) # 802007e2 <_Z5panicPKc>

  // 填充无效值
  memset(pa, 1, PGSIZE);
    802075cc:	6605                	lui	a2,0x1
    802075ce:	4585                	li	a1,1
    802075d0:	8526                	mv	a0,s1
    802075d2:	ffff9097          	auipc	ra,0xffff9
    802075d6:	58a080e7          	jalr	1418(ra) # 80200b5c <_Z6memsetPvij>

  r = static_cast<struct Node *>(pa);
  spinLock.lock();
    802075da:	854a                	mv	a0,s2
    802075dc:	ffffa097          	auipc	ra,0xffffa
    802075e0:	870080e7          	jalr	-1936(ra) # 80200e4c <_ZN8SpinLock4lockEv>
  r->next = this->freeList;
    802075e4:	01893783          	ld	a5,24(s2)
    802075e8:	e09c                	sd	a5,0(s1)
  this->freeList = r;
    802075ea:	00993c23          	sd	s1,24(s2)
  spinLock.unlock();
    802075ee:	854a                	mv	a0,s2
    802075f0:	ffffa097          	auipc	ra,0xffffa
    802075f4:	8d8080e7          	jalr	-1832(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
    802075f8:	60e2                	ld	ra,24(sp)
    802075fa:	6442                	ld	s0,16(sp)
    802075fc:	64a2                	ld	s1,8(sp)
    802075fe:	6902                	ld	s2,0(sp)
    80207600:	6105                	addi	sp,sp,32
    80207602:	8082                	ret

0000000080207604 <_ZN12MemAllocator9freeRangeEPvS0_>:
void MemAllocator::freeRange(void *paStart, void *paEnd) {
    80207604:	7139                	addi	sp,sp,-64
    80207606:	fc06                	sd	ra,56(sp)
    80207608:	f822                	sd	s0,48(sp)
    8020760a:	f426                	sd	s1,40(sp)
    8020760c:	f04a                	sd	s2,32(sp)
    8020760e:	ec4e                	sd	s3,24(sp)
    80207610:	e852                	sd	s4,16(sp)
    80207612:	e456                	sd	s5,8(sp)
    80207614:	0080                	addi	s0,sp,64
  p = (char *)PGROUNDUP((uint64_t)paStart);
    80207616:	6785                	lui	a5,0x1
    80207618:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x801ff001>
    8020761c:	94ae                	add	s1,s1,a1
    8020761e:	75fd                	lui	a1,0xfffff
    80207620:	8ced                	and	s1,s1,a1
  for (; p + PGSIZE <= (char *)paEnd; p += PGSIZE) free(p);
    80207622:	94be                	add	s1,s1,a5
    80207624:	02966063          	bltu	a2,s1,80207644 <_ZN12MemAllocator9freeRangeEPvS0_+0x40>
    80207628:	89aa                	mv	s3,a0
    8020762a:	8932                	mv	s2,a2
    8020762c:	7afd                	lui	s5,0xfffff
    8020762e:	6a05                	lui	s4,0x1
    80207630:	015485b3          	add	a1,s1,s5
    80207634:	854e                	mv	a0,s3
    80207636:	00000097          	auipc	ra,0x0
    8020763a:	f5a080e7          	jalr	-166(ra) # 80207590 <_ZN12MemAllocator4freeEPv>
    8020763e:	94d2                	add	s1,s1,s4
    80207640:	fe9978e3          	bgeu	s2,s1,80207630 <_ZN12MemAllocator9freeRangeEPvS0_+0x2c>
}
    80207644:	70e2                	ld	ra,56(sp)
    80207646:	7442                	ld	s0,48(sp)
    80207648:	74a2                	ld	s1,40(sp)
    8020764a:	7902                	ld	s2,32(sp)
    8020764c:	69e2                	ld	s3,24(sp)
    8020764e:	6a42                	ld	s4,16(sp)
    80207650:	6aa2                	ld	s5,8(sp)
    80207652:	6121                	addi	sp,sp,64
    80207654:	8082                	ret

0000000080207656 <_ZN12MemAllocator4initEv>:
void MemAllocator::init() {
    80207656:	1101                	addi	sp,sp,-32
    80207658:	ec06                	sd	ra,24(sp)
    8020765a:	e822                	sd	s0,16(sp)
    8020765c:	e426                	sd	s1,8(sp)
    8020765e:	1000                	addi	s0,sp,32
    80207660:	84aa                	mv	s1,a0
  this->spinLock.init("memAlloc");
    80207662:	00003597          	auipc	a1,0x3
    80207666:	77658593          	addi	a1,a1,1910 # 8020add8 <_ZTV16DeviceFileSystem+0x188>
    8020766a:	ffff9097          	auipc	ra,0xffff9
    8020766e:	78c080e7          	jalr	1932(ra) # 80200df6 <_ZN8SpinLock4initEPKc>
  freeRange(end, (void *)PHYSTOP);
    80207672:	40300613          	li	a2,1027
    80207676:	0656                	slli	a2,a2,0x15
    80207678:	00091597          	auipc	a1,0x91
    8020767c:	98858593          	addi	a1,a1,-1656 # 80298000 <end>
    80207680:	8526                	mv	a0,s1
    80207682:	00000097          	auipc	ra,0x0
    80207686:	f82080e7          	jalr	-126(ra) # 80207604 <_ZN12MemAllocator9freeRangeEPvS0_>
}
    8020768a:	60e2                	ld	ra,24(sp)
    8020768c:	6442                	ld	s0,16(sp)
    8020768e:	64a2                	ld	s1,8(sp)
    80207690:	6105                	addi	sp,sp,32
    80207692:	8082                	ret

0000000080207694 <_Z11virtio_initv>:
int alloc_desc();
void free_desc(int i);
void free_chain(int i);
int alloc3_desc(int *idx);

void virtio_init() {
    80207694:	1141                	addi	sp,sp,-16
    80207696:	e406                	sd	ra,8(sp)
    80207698:	e022                	sd	s0,0(sp)
    8020769a:	0800                	addi	s0,sp,16
  uint32_t status = 0;

  virtioDisk.vdiskLock.init("virtio_disk");
    8020769c:	00003597          	auipc	a1,0x3
    802076a0:	74c58593          	addi	a1,a1,1868 # 8020ade8 <_ZTV16DeviceFileSystem+0x198>
    802076a4:	0008f517          	auipc	a0,0x8f
    802076a8:	a8450513          	addi	a0,a0,-1404 # 80296128 <virtioDisk+0x2128>
    802076ac:	ffff9097          	auipc	ra,0xffff9
    802076b0:	74a080e7          	jalr	1866(ra) # 80200df6 <_ZN8SpinLock4initEPKc>

  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 || *R(VIRTIO_MMIO_VERSION) != 1 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    802076b4:	03f107b7          	lui	a5,0x3f10
    802076b8:	0785                	addi	a5,a5,1
    802076ba:	07b2                	slli	a5,a5,0xc
    802076bc:	4398                	lw	a4,0(a5)
    802076be:	2701                	sext.w	a4,a4
    802076c0:	747277b7          	lui	a5,0x74727
    802076c4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xbad968a>
    802076c8:	00f71b63          	bne	a4,a5,802076de <_Z11virtio_initv+0x4a>
    802076cc:	00003797          	auipc	a5,0x3
    802076d0:	7dc7b783          	ld	a5,2012(a5) # 8020aea8 <erodata+0x8>
    802076d4:	439c                	lw	a5,0(a5)
    802076d6:	2781                	sext.w	a5,a5
    802076d8:	4705                	li	a4,1
    802076da:	0ee78c63          	beq	a5,a4,802077d2 <_Z11virtio_initv+0x13e>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    panic("could not find virtio disk");
    802076de:	00003517          	auipc	a0,0x3
    802076e2:	71a50513          	addi	a0,a0,1818 # 8020adf8 <_ZTV16DeviceFileSystem+0x1a8>
    802076e6:	ffff9097          	auipc	ra,0xffff9
    802076ea:	0fc080e7          	jalr	252(ra) # 802007e2 <_Z5panicPKc>
  }

  status |= VIRTIO_CONFIG_S_ACKNOWLEDGE;
  *R(VIRTIO_MMIO_STATUS) = status;
    802076ee:	00003717          	auipc	a4,0x3
    802076f2:	7d273703          	ld	a4,2002(a4) # 8020aec0 <erodata+0x20>
    802076f6:	4785                	li	a5,1
    802076f8:	c31c                	sw	a5,0(a4)

  status |= VIRTIO_CONFIG_S_DRIVER;
  *R(VIRTIO_MMIO_STATUS) = status;
    802076fa:	478d                	li	a5,3
    802076fc:	c31c                	sw	a5,0(a4)

  // negotiate features
  uint64_t features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    802076fe:	00003797          	auipc	a5,0x3
    80207702:	7ca7b783          	ld	a5,1994(a5) # 8020aec8 <erodata+0x28>
    80207706:	4394                	lw	a3,0(a5)
  features &= ~(1 << VIRTIO_BLK_F_SCSI);
  features &= ~(1 << VIRTIO_BLK_F_CONFIG_WCE);
  features &= ~(1 << VIRTIO_BLK_F_MQ);
  features &= ~(1 << VIRTIO_F_ANY_LAYOUT);
  features &= ~(1 << VIRTIO_RING_F_EVENT_IDX);
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80207708:	c7ffe7b7          	lui	a5,0xc7ffe
    8020770c:	75f78793          	addi	a5,a5,1887 # ffffffffc7ffe75f <end+0xffffffff47d6675f>
    80207710:	8ff5                	and	a5,a5,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80207712:	2781                	sext.w	a5,a5
    80207714:	00003697          	auipc	a3,0x3
    80207718:	7bc6b683          	ld	a3,1980(a3) # 8020aed0 <erodata+0x30>
    8020771c:	c29c                	sw	a5,0(a3)

  // tell device that feature negotiation is complete.
  status |= VIRTIO_CONFIG_S_FEATURES_OK;
  *R(VIRTIO_MMIO_STATUS) = status;
    8020771e:	47ad                	li	a5,11
    80207720:	c31c                	sw	a5,0(a4)

  // tell device we're completely ready.
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
  *R(VIRTIO_MMIO_STATUS) = status;
    80207722:	47bd                	li	a5,15
    80207724:	c31c                	sw	a5,0(a4)

  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80207726:	00003797          	auipc	a5,0x3
    8020772a:	7b27b783          	ld	a5,1970(a5) # 8020aed8 <erodata+0x38>
    8020772e:	6705                	lui	a4,0x1
    80207730:	c398                	sw	a4,0(a5)

  // initialize queue 0.
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80207732:	00003797          	auipc	a5,0x3
    80207736:	7ae7b783          	ld	a5,1966(a5) # 8020aee0 <erodata+0x40>
    8020773a:	0007a023          	sw	zero,0(a5)
  uint32_t max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8020773e:	00003797          	auipc	a5,0x3
    80207742:	7aa7b783          	ld	a5,1962(a5) # 8020aee8 <erodata+0x48>
    80207746:	439c                	lw	a5,0(a5)
    80207748:	2781                	sext.w	a5,a5
  if (max == 0) panic("virtio disk has no queue 0");
    8020774a:	cbd5                	beqz	a5,802077fe <_Z11virtio_initv+0x16a>
  if (max < NUM) panic("virtio disk max queue too short");
    8020774c:	471d                	li	a4,7
    8020774e:	0cf77063          	bgeu	a4,a5,8020780e <_Z11virtio_initv+0x17a>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80207752:	00003797          	auipc	a5,0x3
    80207756:	79e7b783          	ld	a5,1950(a5) # 8020aef0 <erodata+0x50>
    8020775a:	4721                	li	a4,8
    8020775c:	c398                	sw	a4,0(a5)
  memset(virtioDisk.pages, 0, sizeof(virtioDisk.pages));
    8020775e:	6609                	lui	a2,0x2
    80207760:	4581                	li	a1,0
    80207762:	0008d517          	auipc	a0,0x8d
    80207766:	89e50513          	addi	a0,a0,-1890 # 80294000 <virtioDisk>
    8020776a:	ffff9097          	auipc	ra,0xffff9
    8020776e:	3f2080e7          	jalr	1010(ra) # 80200b5c <_Z6memsetPvij>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64_t)virtioDisk.pages) >> PGSHIFT;
    80207772:	0008d717          	auipc	a4,0x8d
    80207776:	88e70713          	addi	a4,a4,-1906 # 80294000 <virtioDisk>
    8020777a:	00c75793          	srli	a5,a4,0xc
    8020777e:	2781                	sext.w	a5,a5
    80207780:	00003697          	auipc	a3,0x3
    80207784:	7786b683          	ld	a3,1912(a3) # 8020aef8 <erodata+0x58>
    80207788:	c29c                	sw	a5,0(a3)

  // desc = pages -- num * virtq_desc
  // avail = pages + 0x40 -- 2 * uint16_t, then num * uint16_t
  // used = pages + 4096 -- 2 * uint16_t, then num * vRingUsedElem

  virtioDisk.desc = (struct virtq_desc *)virtioDisk.pages;
    8020778a:	0008f797          	auipc	a5,0x8f
    8020778e:	87678793          	addi	a5,a5,-1930 # 80296000 <virtioDisk+0x2000>
    80207792:	e398                	sd	a4,0(a5)
  virtioDisk.avail = (struct virtq_avail *)(virtioDisk.pages + NUM * sizeof(struct virtq_desc));
    80207794:	0008d717          	auipc	a4,0x8d
    80207798:	8ec70713          	addi	a4,a4,-1812 # 80294080 <virtioDisk+0x80>
    8020779c:	e798                	sd	a4,8(a5)
  virtioDisk.used = (struct virtq_used *)(virtioDisk.pages + PGSIZE);
    8020779e:	0008e717          	auipc	a4,0x8e
    802077a2:	86270713          	addi	a4,a4,-1950 # 80295000 <virtioDisk+0x1000>
    802077a6:	eb98                	sd	a4,16(a5)

  // all NUM descriptors start out unused.
  for (int i = 0; i < NUM; i++) virtioDisk.free[i] = 1;
    802077a8:	4705                	li	a4,1
    802077aa:	00e78c23          	sb	a4,24(a5)
    802077ae:	00e78ca3          	sb	a4,25(a5)
    802077b2:	00e78d23          	sb	a4,26(a5)
    802077b6:	00e78da3          	sb	a4,27(a5)
    802077ba:	00e78e23          	sb	a4,28(a5)
    802077be:	00e78ea3          	sb	a4,29(a5)
    802077c2:	00e78f23          	sb	a4,30(a5)
    802077c6:	00e78fa3          	sb	a4,31(a5)

  // plic.c and trap.c arrange for interrupts from VIRTIO0_IRQ.
}
    802077ca:	60a2                	ld	ra,8(sp)
    802077cc:	6402                	ld	s0,0(sp)
    802077ce:	0141                	addi	sp,sp,16
    802077d0:	8082                	ret
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 || *R(VIRTIO_MMIO_VERSION) != 1 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    802077d2:	00003797          	auipc	a5,0x3
    802077d6:	6de7b783          	ld	a5,1758(a5) # 8020aeb0 <erodata+0x10>
    802077da:	439c                	lw	a5,0(a5)
    802077dc:	2781                	sext.w	a5,a5
    802077de:	4709                	li	a4,2
    802077e0:	eee79fe3          	bne	a5,a4,802076de <_Z11virtio_initv+0x4a>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    802077e4:	00003797          	auipc	a5,0x3
    802077e8:	6d47b783          	ld	a5,1748(a5) # 8020aeb8 <erodata+0x18>
    802077ec:	4398                	lw	a4,0(a5)
    802077ee:	2701                	sext.w	a4,a4
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 || *R(VIRTIO_MMIO_VERSION) != 1 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    802077f0:	554d47b7          	lui	a5,0x554d4
    802077f4:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ad2baaf>
    802077f8:	eef713e3          	bne	a4,a5,802076de <_Z11virtio_initv+0x4a>
    802077fc:	bdcd                	j	802076ee <_Z11virtio_initv+0x5a>
  if (max == 0) panic("virtio disk has no queue 0");
    802077fe:	00003517          	auipc	a0,0x3
    80207802:	61a50513          	addi	a0,a0,1562 # 8020ae18 <_ZTV16DeviceFileSystem+0x1c8>
    80207806:	ffff9097          	auipc	ra,0xffff9
    8020780a:	fdc080e7          	jalr	-36(ra) # 802007e2 <_Z5panicPKc>
  if (max < NUM) panic("virtio disk max queue too short");
    8020780e:	00003517          	auipc	a0,0x3
    80207812:	62a50513          	addi	a0,a0,1578 # 8020ae38 <_ZTV16DeviceFileSystem+0x1e8>
    80207816:	ffff9097          	auipc	ra,0xffff9
    8020781a:	fcc080e7          	jalr	-52(ra) # 802007e2 <_Z5panicPKc>
    8020781e:	bf15                	j	80207752 <_Z11virtio_initv+0xbe>

0000000080207820 <_Z10alloc_descv>:

// find a free descriptor, mark it non-free, return its index.
int alloc_desc() {
    80207820:	1141                	addi	sp,sp,-16
    80207822:	e422                	sd	s0,8(sp)
    80207824:	0800                	addi	s0,sp,16
  for (int i = 0; i < NUM; i++) {
    80207826:	0008e797          	auipc	a5,0x8e
    8020782a:	7f278793          	addi	a5,a5,2034 # 80296018 <virtioDisk+0x2018>
    8020782e:	4501                	li	a0,0
    80207830:	46a1                	li	a3,8
    if (virtioDisk.free[i]) {
    80207832:	0007c703          	lbu	a4,0(a5)
    80207836:	eb09                	bnez	a4,80207848 <_Z10alloc_descv+0x28>
  for (int i = 0; i < NUM; i++) {
    80207838:	2505                	addiw	a0,a0,1
    8020783a:	0785                	addi	a5,a5,1
    8020783c:	fed51be3          	bne	a0,a3,80207832 <_Z10alloc_descv+0x12>
      virtioDisk.free[i] = 0;
      return i;
    }
  }
  return -1;
    80207840:	557d                	li	a0,-1
}
    80207842:	6422                	ld	s0,8(sp)
    80207844:	0141                	addi	sp,sp,16
    80207846:	8082                	ret
      virtioDisk.free[i] = 0;
    80207848:	0008c797          	auipc	a5,0x8c
    8020784c:	7b878793          	addi	a5,a5,1976 # 80294000 <virtioDisk>
    80207850:	00a78733          	add	a4,a5,a0
    80207854:	6789                	lui	a5,0x2
    80207856:	97ba                	add	a5,a5,a4
    80207858:	00078c23          	sb	zero,24(a5) # 2018 <_entry-0x801fdfe8>
      return i;
    8020785c:	b7dd                	j	80207842 <_Z10alloc_descv+0x22>

000000008020785e <_Z9free_desci>:

// mark a descriptor as free.
void free_desc(int i) {
    8020785e:	1101                	addi	sp,sp,-32
    80207860:	ec06                	sd	ra,24(sp)
    80207862:	e822                	sd	s0,16(sp)
    80207864:	e426                	sd	s1,8(sp)
    80207866:	1000                	addi	s0,sp,32
    80207868:	84aa                	mv	s1,a0
  if (i >= NUM) panic("free_desc 1");
    8020786a:	479d                	li	a5,7
    8020786c:	06a7ca63          	blt	a5,a0,802078e0 <_Z9free_desci+0x82>
  if (virtioDisk.free[i]) panic("free_desc 2");
    80207870:	0008c797          	auipc	a5,0x8c
    80207874:	79078793          	addi	a5,a5,1936 # 80294000 <virtioDisk>
    80207878:	00978733          	add	a4,a5,s1
    8020787c:	6789                	lui	a5,0x2
    8020787e:	97ba                	add	a5,a5,a4
    80207880:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x801fdfe8>
    80207884:	e7bd                	bnez	a5,802078f2 <_Z9free_desci+0x94>
  virtioDisk.desc[i].addr = 0;
    80207886:	00449793          	slli	a5,s1,0x4
    8020788a:	0008e717          	auipc	a4,0x8e
    8020788e:	77670713          	addi	a4,a4,1910 # 80296000 <virtioDisk+0x2000>
    80207892:	6314                	ld	a3,0(a4)
    80207894:	96be                	add	a3,a3,a5
    80207896:	0006b023          	sd	zero,0(a3)
  virtioDisk.desc[i].len = 0;
    8020789a:	6314                	ld	a3,0(a4)
    8020789c:	96be                	add	a3,a3,a5
    8020789e:	0006a423          	sw	zero,8(a3)
  virtioDisk.desc[i].flags = 0;
    802078a2:	6314                	ld	a3,0(a4)
    802078a4:	96be                	add	a3,a3,a5
    802078a6:	00069623          	sh	zero,12(a3)
  virtioDisk.desc[i].next = 0;
    802078aa:	6318                	ld	a4,0(a4)
    802078ac:	97ba                	add	a5,a5,a4
    802078ae:	00079723          	sh	zero,14(a5)
  virtioDisk.free[i] = 1;
    802078b2:	0008c517          	auipc	a0,0x8c
    802078b6:	74e50513          	addi	a0,a0,1870 # 80294000 <virtioDisk>
    802078ba:	9526                	add	a0,a0,s1
    802078bc:	6489                	lui	s1,0x2
    802078be:	94aa                	add	s1,s1,a0
    802078c0:	4785                	li	a5,1
    802078c2:	00f48c23          	sb	a5,24(s1) # 2018 <_entry-0x801fdfe8>
  wakeup(&virtioDisk.free[0]);
    802078c6:	0008e517          	auipc	a0,0x8e
    802078ca:	75250513          	addi	a0,a0,1874 # 80296018 <virtioDisk+0x2018>
    802078ce:	ffffa097          	auipc	ra,0xffffa
    802078d2:	452080e7          	jalr	1106(ra) # 80201d20 <_Z6wakeupPv>
}
    802078d6:	60e2                	ld	ra,24(sp)
    802078d8:	6442                	ld	s0,16(sp)
    802078da:	64a2                	ld	s1,8(sp)
    802078dc:	6105                	addi	sp,sp,32
    802078de:	8082                	ret
  if (i >= NUM) panic("free_desc 1");
    802078e0:	00003517          	auipc	a0,0x3
    802078e4:	57850513          	addi	a0,a0,1400 # 8020ae58 <_ZTV16DeviceFileSystem+0x208>
    802078e8:	ffff9097          	auipc	ra,0xffff9
    802078ec:	efa080e7          	jalr	-262(ra) # 802007e2 <_Z5panicPKc>
    802078f0:	b741                	j	80207870 <_Z9free_desci+0x12>
  if (virtioDisk.free[i]) panic("free_desc 2");
    802078f2:	00003517          	auipc	a0,0x3
    802078f6:	57650513          	addi	a0,a0,1398 # 8020ae68 <_ZTV16DeviceFileSystem+0x218>
    802078fa:	ffff9097          	auipc	ra,0xffff9
    802078fe:	ee8080e7          	jalr	-280(ra) # 802007e2 <_Z5panicPKc>
    80207902:	b751                	j	80207886 <_Z9free_desci+0x28>

0000000080207904 <_Z10free_chaini>:

// free a chain of descriptors.
void free_chain(int i) {
    80207904:	7179                	addi	sp,sp,-48
    80207906:	f406                	sd	ra,40(sp)
    80207908:	f022                	sd	s0,32(sp)
    8020790a:	ec26                	sd	s1,24(sp)
    8020790c:	e84a                	sd	s2,16(sp)
    8020790e:	e44e                	sd	s3,8(sp)
    80207910:	1800                	addi	s0,sp,48
    80207912:	892a                	mv	s2,a0
  while (1) {
    int flag = virtioDisk.desc[i].flags;
    80207914:	0008e997          	auipc	s3,0x8e
    80207918:	6ec98993          	addi	s3,s3,1772 # 80296000 <virtioDisk+0x2000>
    8020791c:	00491713          	slli	a4,s2,0x4
    80207920:	0009b783          	ld	a5,0(s3)
    80207924:	97ba                	add	a5,a5,a4
    80207926:	00c7d483          	lhu	s1,12(a5)
    int nxt = virtioDisk.desc[i].next;
    8020792a:	854a                	mv	a0,s2
    8020792c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80207930:	00000097          	auipc	ra,0x0
    80207934:	f2e080e7          	jalr	-210(ra) # 8020785e <_Z9free_desci>
    if (flag & VRING_DESC_F_NEXT)
    80207938:	8885                	andi	s1,s1,1
    8020793a:	f0ed                	bnez	s1,8020791c <_Z10free_chaini+0x18>
      i = nxt;
    else
      break;
  }
}
    8020793c:	70a2                	ld	ra,40(sp)
    8020793e:	7402                	ld	s0,32(sp)
    80207940:	64e2                	ld	s1,24(sp)
    80207942:	6942                	ld	s2,16(sp)
    80207944:	69a2                	ld	s3,8(sp)
    80207946:	6145                	addi	sp,sp,48
    80207948:	8082                	ret

000000008020794a <_Z11alloc3_descPi>:

// allocate three descriptors (they need not be contiguous).
// disk transfers always use three descriptors.
int alloc3_desc(int *idx) {
    8020794a:	7179                	addi	sp,sp,-48
    8020794c:	f406                	sd	ra,40(sp)
    8020794e:	f022                	sd	s0,32(sp)
    80207950:	ec26                	sd	s1,24(sp)
    80207952:	e84a                	sd	s2,16(sp)
    80207954:	e44e                	sd	s3,8(sp)
    80207956:	e052                	sd	s4,0(sp)
    80207958:	1800                	addi	s0,sp,48
    8020795a:	89aa                	mv	s3,a0
    8020795c:	892a                	mv	s2,a0
  for (int i = 0; i < 3; i++) {
    8020795e:	4481                	li	s1,0
    80207960:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80207962:	00000097          	auipc	ra,0x0
    80207966:	ebe080e7          	jalr	-322(ra) # 80207820 <_Z10alloc_descv>
    8020796a:	00a92023          	sw	a0,0(s2)
    if (idx[i] < 0) {
    8020796e:	00054f63          	bltz	a0,8020798c <_Z11alloc3_descPi+0x42>
  for (int i = 0; i < 3; i++) {
    80207972:	2485                	addiw	s1,s1,1
    80207974:	0911                	addi	s2,s2,4
    80207976:	ff4496e3          	bne	s1,s4,80207962 <_Z11alloc3_descPi+0x18>
      for (int j = 0; j < i; j++) free_desc(idx[j]);
      return -1;
    }
  }
  return 0;
    8020797a:	4501                	li	a0,0
}
    8020797c:	70a2                	ld	ra,40(sp)
    8020797e:	7402                	ld	s0,32(sp)
    80207980:	64e2                	ld	s1,24(sp)
    80207982:	6942                	ld	s2,16(sp)
    80207984:	69a2                	ld	s3,8(sp)
    80207986:	6a02                	ld	s4,0(sp)
    80207988:	6145                	addi	sp,sp,48
    8020798a:	8082                	ret
      return -1;
    8020798c:	557d                	li	a0,-1
      for (int j = 0; j < i; j++) free_desc(idx[j]);
    8020798e:	fe9057e3          	blez	s1,8020797c <_Z11alloc3_descPi+0x32>
    80207992:	4901                	li	s2,0
    80207994:	0009a503          	lw	a0,0(s3)
    80207998:	00000097          	auipc	ra,0x0
    8020799c:	ec6080e7          	jalr	-314(ra) # 8020785e <_Z9free_desci>
    802079a0:	2905                	addiw	s2,s2,1
    802079a2:	0991                	addi	s3,s3,4
    802079a4:	fe9918e3          	bne	s2,s1,80207994 <_Z11alloc3_descPi+0x4a>
      return -1;
    802079a8:	557d                	li	a0,-1
    802079aa:	bfc9                	j	8020797c <_Z11alloc3_descPi+0x32>

00000000802079ac <_Z14virtio_disk_rwP3bufi>:

struct virtio_blk_req *buf0;
void virtio_disk_rw(struct buf *b, int write) {
    802079ac:	715d                	addi	sp,sp,-80
    802079ae:	e486                	sd	ra,72(sp)
    802079b0:	e0a2                	sd	s0,64(sp)
    802079b2:	fc26                	sd	s1,56(sp)
    802079b4:	f84a                	sd	s2,48(sp)
    802079b6:	f44e                	sd	s3,40(sp)
    802079b8:	f052                	sd	s4,32(sp)
    802079ba:	ec56                	sd	s5,24(sp)
    802079bc:	0880                	addi	s0,sp,80
    802079be:	84aa                	mv	s1,a0
    802079c0:	8a2e                	mv	s4,a1
  uint64_t sector = b->blockno;
    802079c2:	00c52a83          	lw	s5,12(a0)
  virtioDisk.vdiskLock.lock();
    802079c6:	0008e517          	auipc	a0,0x8e
    802079ca:	76250513          	addi	a0,a0,1890 # 80296128 <virtioDisk+0x2128>
    802079ce:	ffff9097          	auipc	ra,0xffff9
    802079d2:	47e080e7          	jalr	1150(ra) # 80200e4c <_ZN8SpinLock4lockEv>
  int idx[3];
  while (1) {
    if (alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&virtioDisk.free[0], &virtioDisk.vdiskLock);
    802079d6:	0008e997          	auipc	s3,0x8e
    802079da:	75298993          	addi	s3,s3,1874 # 80296128 <virtioDisk+0x2128>
    802079de:	0008e917          	auipc	s2,0x8e
    802079e2:	63a90913          	addi	s2,s2,1594 # 80296018 <virtioDisk+0x2018>
    if (alloc3_desc(idx) == 0) {
    802079e6:	fb040513          	addi	a0,s0,-80
    802079ea:	00000097          	auipc	ra,0x0
    802079ee:	f60080e7          	jalr	-160(ra) # 8020794a <_Z11alloc3_descPi>
    802079f2:	c901                	beqz	a0,80207a02 <_Z14virtio_disk_rwP3bufi+0x56>
    sleep(&virtioDisk.free[0], &virtioDisk.vdiskLock);
    802079f4:	85ce                	mv	a1,s3
    802079f6:	854a                	mv	a0,s2
    802079f8:	ffffa097          	auipc	ra,0xffffa
    802079fc:	234080e7          	jalr	564(ra) # 80201c2c <_Z5sleepPvP8SpinLock>
    if (alloc3_desc(idx) == 0) {
    80207a00:	b7dd                	j	802079e6 <_Z14virtio_disk_rwP3bufi+0x3a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.
  buf0 = &virtioDisk.ops[idx[0]];
    80207a02:	fb042783          	lw	a5,-80(s0)
    80207a06:	20078693          	addi	a3,a5,512
    80207a0a:	0692                	slli	a3,a3,0x4
    80207a0c:	0008c717          	auipc	a4,0x8c
    80207a10:	69c70713          	addi	a4,a4,1692 # 802940a8 <virtioDisk+0xa8>
    80207a14:	9736                	add	a4,a4,a3
    80207a16:	0008f617          	auipc	a2,0x8f
    80207a1a:	5ee63523          	sd	a4,1514(a2) # 80297000 <buf0>

  if (write)
    80207a1e:	1a0a0663          	beqz	s4,80207bca <_Z14virtio_disk_rwP3bufi+0x21e>
    buf0->type = VIRTIO_BLK_T_OUT;  // write the disk
    80207a22:	0008c617          	auipc	a2,0x8c
    80207a26:	5de60613          	addi	a2,a2,1502 # 80294000 <virtioDisk>
    80207a2a:	9636                	add	a2,a2,a3
    80207a2c:	4585                	li	a1,1
    80207a2e:	0ab62423          	sw	a1,168(a2)
  else
    buf0->type = VIRTIO_BLK_T_IN;  // read the disk
  buf0->reserved = 0;
    80207a32:	20078793          	addi	a5,a5,512
    80207a36:	0792                	slli	a5,a5,0x4
    80207a38:	0008c617          	auipc	a2,0x8c
    80207a3c:	5c860613          	addi	a2,a2,1480 # 80294000 <virtioDisk>
    80207a40:	97b2                	add	a5,a5,a2
    80207a42:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    80207a46:	0b57b823          	sd	s5,176(a5)

  virtioDisk.desc[idx[0]].addr = (uint64_t)buf0;
    80207a4a:	0008e797          	auipc	a5,0x8e
    80207a4e:	5b678793          	addi	a5,a5,1462 # 80296000 <virtioDisk+0x2000>
    80207a52:	6390                	ld	a2,0(a5)
    80207a54:	9636                	add	a2,a2,a3
    80207a56:	76f9                	lui	a3,0xffffe
    80207a58:	96b2                	add	a3,a3,a2
    80207a5a:	e298                	sd	a4,0(a3)
  virtioDisk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80207a5c:	fb042703          	lw	a4,-80(s0)
    80207a60:	0712                	slli	a4,a4,0x4
    80207a62:	6394                	ld	a3,0(a5)
    80207a64:	96ba                	add	a3,a3,a4
    80207a66:	4641                	li	a2,16
    80207a68:	c690                	sw	a2,8(a3)
  virtioDisk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80207a6a:	6394                	ld	a3,0(a5)
    80207a6c:	96ba                	add	a3,a3,a4
    80207a6e:	4605                	li	a2,1
    80207a70:	00c69623          	sh	a2,12(a3) # ffffffffffffe00c <end+0xffffffff7fd6600c>
  virtioDisk.desc[idx[0]].next = idx[1];
    80207a74:	fb442683          	lw	a3,-76(s0)
    80207a78:	6390                	ld	a2,0(a5)
    80207a7a:	9732                	add	a4,a4,a2
    80207a7c:	00d71723          	sh	a3,14(a4)

  virtioDisk.desc[idx[1]].addr = (uint64_t)b->data;
    80207a80:	6398                	ld	a4,0(a5)
    80207a82:	0692                	slli	a3,a3,0x4
    80207a84:	96ba                	add	a3,a3,a4
    80207a86:	04c48713          	addi	a4,s1,76
    80207a8a:	e298                	sd	a4,0(a3)
  virtioDisk.desc[idx[1]].len = BSIZE;
    80207a8c:	fb442703          	lw	a4,-76(s0)
    80207a90:	0712                	slli	a4,a4,0x4
    80207a92:	639c                	ld	a5,0(a5)
    80207a94:	97ba                	add	a5,a5,a4
    80207a96:	20000693          	li	a3,512
    80207a9a:	c794                	sw	a3,8(a5)
  if (write)
    80207a9c:	140a0363          	beqz	s4,80207be2 <_Z14virtio_disk_rwP3bufi+0x236>
    virtioDisk.desc[idx[1]].flags = 0;  // device reads b->data
    80207aa0:	0008e797          	auipc	a5,0x8e
    80207aa4:	5607b783          	ld	a5,1376(a5) # 80296000 <virtioDisk+0x2000>
    80207aa8:	97ba                	add	a5,a5,a4
    80207aaa:	00079623          	sh	zero,12(a5)
  else
    virtioDisk.desc[idx[1]].flags = VRING_DESC_F_WRITE;  // device writes b->data
  virtioDisk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80207aae:	0008c697          	auipc	a3,0x8c
    80207ab2:	55268693          	addi	a3,a3,1362 # 80294000 <virtioDisk>
    80207ab6:	0008e797          	auipc	a5,0x8e
    80207aba:	54a78793          	addi	a5,a5,1354 # 80296000 <virtioDisk+0x2000>
    80207abe:	6390                	ld	a2,0(a5)
    80207ac0:	963a                	add	a2,a2,a4
    80207ac2:	00c65583          	lhu	a1,12(a2)
    80207ac6:	0015e593          	ori	a1,a1,1
    80207aca:	00b61623          	sh	a1,12(a2)
  virtioDisk.desc[idx[1]].next = idx[2];
    80207ace:	fb842583          	lw	a1,-72(s0)
    80207ad2:	6390                	ld	a2,0(a5)
    80207ad4:	9732                	add	a4,a4,a2
    80207ad6:	00b71723          	sh	a1,14(a4)

  virtioDisk.info[idx[0]].status = 0xff;  // device writes 0 on success
    80207ada:	fb042703          	lw	a4,-80(s0)
    80207ade:	20070613          	addi	a2,a4,512
    80207ae2:	0612                	slli	a2,a2,0x4
    80207ae4:	9636                	add	a2,a2,a3
    80207ae6:	557d                	li	a0,-1
    80207ae8:	02a60823          	sb	a0,48(a2)
  virtioDisk.desc[idx[2]].addr = (uint64_t) & virtioDisk.info[idx[0]].status;
    80207aec:	6390                	ld	a2,0(a5)
    80207aee:	0592                	slli	a1,a1,0x4
    80207af0:	95b2                	add	a1,a1,a2
    80207af2:	20370713          	addi	a4,a4,515
    80207af6:	0712                	slli	a4,a4,0x4
    80207af8:	9736                	add	a4,a4,a3
    80207afa:	e198                	sd	a4,0(a1)
  virtioDisk.desc[idx[2]].len = 1;
    80207afc:	fb842603          	lw	a2,-72(s0)
    80207b00:	6398                	ld	a4,0(a5)
    80207b02:	0612                	slli	a2,a2,0x4
    80207b04:	9732                	add	a4,a4,a2
    80207b06:	4585                	li	a1,1
    80207b08:	c70c                	sw	a1,8(a4)
  virtioDisk.desc[idx[2]].flags = VRING_DESC_F_WRITE;  // device writes the status
    80207b0a:	fb842703          	lw	a4,-72(s0)
    80207b0e:	0712                	slli	a4,a4,0x4
    80207b10:	6390                	ld	a2,0(a5)
    80207b12:	963a                	add	a2,a2,a4
    80207b14:	4509                	li	a0,2
    80207b16:	00a61623          	sh	a0,12(a2)
  virtioDisk.desc[idx[2]].next = 0;
    80207b1a:	6390                	ld	a2,0(a5)
    80207b1c:	9732                	add	a4,a4,a2
    80207b1e:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80207b22:	c0cc                	sw	a1,4(s1)
  virtioDisk.info[idx[0]].b = b;
    80207b24:	fb042603          	lw	a2,-80(s0)
    80207b28:	20060713          	addi	a4,a2,512
    80207b2c:	0712                	slli	a4,a4,0x4
    80207b2e:	96ba                	add	a3,a3,a4
    80207b30:	f684                	sd	s1,40(a3)

  // tell the device the first index in our chain of descriptors.
  virtioDisk.avail->ring[virtioDisk.avail->idx % NUM] = idx[0];
    80207b32:	6794                	ld	a3,8(a5)
    80207b34:	0026d703          	lhu	a4,2(a3)
    80207b38:	8b1d                	andi	a4,a4,7
    80207b3a:	0706                	slli	a4,a4,0x1
    80207b3c:	9736                	add	a4,a4,a3
    80207b3e:	00c71223          	sh	a2,4(a4)

  __sync_synchronize();
    80207b42:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  virtioDisk.avail->idx += 1;  // not % NUM ...
    80207b46:	6798                	ld	a4,8(a5)
    80207b48:	00275783          	lhu	a5,2(a4)
    80207b4c:	2785                	addiw	a5,a5,1
    80207b4e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80207b52:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0;  // value is queue number
    80207b56:	00003797          	auipc	a5,0x3
    80207b5a:	3aa7b783          	ld	a5,938(a5) # 8020af00 <erodata+0x60>
    80207b5e:	0007a023          	sw	zero,0(a5)

  // Wait for virtio_disk_intr() to say request has finished.
  while (b->disk == 1) {
    80207b62:	40d8                	lw	a4,4(s1)
    80207b64:	4785                	li	a5,1
    80207b66:	02f71063          	bne	a4,a5,80207b86 <_Z14virtio_disk_rwP3bufi+0x1da>
    sleep(b, &virtioDisk.vdiskLock);
    80207b6a:	0008e997          	auipc	s3,0x8e
    80207b6e:	5be98993          	addi	s3,s3,1470 # 80296128 <virtioDisk+0x2128>
  while (b->disk == 1) {
    80207b72:	4905                	li	s2,1
    sleep(b, &virtioDisk.vdiskLock);
    80207b74:	85ce                	mv	a1,s3
    80207b76:	8526                	mv	a0,s1
    80207b78:	ffffa097          	auipc	ra,0xffffa
    80207b7c:	0b4080e7          	jalr	180(ra) # 80201c2c <_Z5sleepPvP8SpinLock>
  while (b->disk == 1) {
    80207b80:	40dc                	lw	a5,4(s1)
    80207b82:	ff2789e3          	beq	a5,s2,80207b74 <_Z14virtio_disk_rwP3bufi+0x1c8>
  }

  virtioDisk.info[idx[0]].b = 0;
    80207b86:	fb042503          	lw	a0,-80(s0)
    80207b8a:	20050793          	addi	a5,a0,512
    80207b8e:	00479713          	slli	a4,a5,0x4
    80207b92:	0008c797          	auipc	a5,0x8c
    80207b96:	46e78793          	addi	a5,a5,1134 # 80294000 <virtioDisk>
    80207b9a:	97ba                	add	a5,a5,a4
    80207b9c:	0207b423          	sd	zero,40(a5)
  free_chain(idx[0]);
    80207ba0:	00000097          	auipc	ra,0x0
    80207ba4:	d64080e7          	jalr	-668(ra) # 80207904 <_Z10free_chaini>
  virtioDisk.vdiskLock.unlock();
    80207ba8:	0008e517          	auipc	a0,0x8e
    80207bac:	58050513          	addi	a0,a0,1408 # 80296128 <virtioDisk+0x2128>
    80207bb0:	ffff9097          	auipc	ra,0xffff9
    80207bb4:	318080e7          	jalr	792(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
}
    80207bb8:	60a6                	ld	ra,72(sp)
    80207bba:	6406                	ld	s0,64(sp)
    80207bbc:	74e2                	ld	s1,56(sp)
    80207bbe:	7942                	ld	s2,48(sp)
    80207bc0:	79a2                	ld	s3,40(sp)
    80207bc2:	7a02                	ld	s4,32(sp)
    80207bc4:	6ae2                	ld	s5,24(sp)
    80207bc6:	6161                	addi	sp,sp,80
    80207bc8:	8082                	ret
    buf0->type = VIRTIO_BLK_T_IN;  // read the disk
    80207bca:	20078613          	addi	a2,a5,512
    80207bce:	00461593          	slli	a1,a2,0x4
    80207bd2:	0008c617          	auipc	a2,0x8c
    80207bd6:	42e60613          	addi	a2,a2,1070 # 80294000 <virtioDisk>
    80207bda:	962e                	add	a2,a2,a1
    80207bdc:	0a062423          	sw	zero,168(a2)
    80207be0:	bd89                	j	80207a32 <_Z14virtio_disk_rwP3bufi+0x86>
    virtioDisk.desc[idx[1]].flags = VRING_DESC_F_WRITE;  // device writes b->data
    80207be2:	0008e797          	auipc	a5,0x8e
    80207be6:	41e7b783          	ld	a5,1054(a5) # 80296000 <virtioDisk+0x2000>
    80207bea:	97ba                	add	a5,a5,a4
    80207bec:	4689                	li	a3,2
    80207bee:	00d79623          	sh	a3,12(a5)
    80207bf2:	bd75                	j	80207aae <_Z14virtio_disk_rwP3bufi+0x102>

0000000080207bf4 <_Z16virtio_disk_intrv>:

void virtio_disk_intr() {
    80207bf4:	7139                	addi	sp,sp,-64
    80207bf6:	fc06                	sd	ra,56(sp)
    80207bf8:	f822                	sd	s0,48(sp)
    80207bfa:	f426                	sd	s1,40(sp)
    80207bfc:	f04a                	sd	s2,32(sp)
    80207bfe:	ec4e                	sd	s3,24(sp)
    80207c00:	e852                	sd	s4,16(sp)
    80207c02:	e456                	sd	s5,8(sp)
    80207c04:	e05a                	sd	s6,0(sp)
    80207c06:	0080                	addi	s0,sp,64
  virtioDisk.vdiskLock.lock();
    80207c08:	0008e517          	auipc	a0,0x8e
    80207c0c:	52050513          	addi	a0,a0,1312 # 80296128 <virtioDisk+0x2128>
    80207c10:	ffff9097          	auipc	ra,0xffff9
    80207c14:	23c080e7          	jalr	572(ra) # 80200e4c <_ZN8SpinLock4lockEv>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80207c18:	00003797          	auipc	a5,0x3
    80207c1c:	2f07b783          	ld	a5,752(a5) # 8020af08 <erodata+0x68>
    80207c20:	439c                	lw	a5,0(a5)
    80207c22:	8b8d                	andi	a5,a5,3
    80207c24:	00003717          	auipc	a4,0x3
    80207c28:	2ec73703          	ld	a4,748(a4) # 8020af10 <erodata+0x70>
    80207c2c:	c31c                	sw	a5,0(a4)

  __sync_synchronize();
    80207c2e:	0ff0000f          	fence

  // the device increments virtioDisk.used->idx when it
  // adds an entry to the used ring.
  while (virtioDisk.used_idx != virtioDisk.used->idx) {
    80207c32:	0008e797          	auipc	a5,0x8e
    80207c36:	3ce78793          	addi	a5,a5,974 # 80296000 <virtioDisk+0x2000>
    80207c3a:	6b94                	ld	a3,16(a5)
    80207c3c:	0207d703          	lhu	a4,32(a5)
    80207c40:	0026d783          	lhu	a5,2(a3)
    80207c44:	08f70f63          	beq	a4,a5,80207ce2 <_Z16virtio_disk_intrv+0xee>
    __sync_synchronize();
    int id = virtioDisk.used->ring[virtioDisk.used_idx % NUM].id;
    80207c48:	0008c997          	auipc	s3,0x8c
    80207c4c:	3b898993          	addi	s3,s3,952 # 80294000 <virtioDisk>
    80207c50:	0008e917          	auipc	s2,0x8e
    80207c54:	3b090913          	addi	s2,s2,944 # 80296000 <virtioDisk+0x2000>

    if (virtioDisk.info[id].status != 0) {
      // printf("%d",di)
      printf("intr:%d %d\n", buf0->sector, buf0->type);
    80207c58:	0008fb17          	auipc	s6,0x8f
    80207c5c:	3a8b0b13          	addi	s6,s6,936 # 80297000 <buf0>
    80207c60:	00003a97          	auipc	s5,0x3
    80207c64:	218a8a93          	addi	s5,s5,536 # 8020ae78 <_ZTV16DeviceFileSystem+0x228>
      panic("virtio_disk_intr status");
    80207c68:	00003a17          	auipc	s4,0x3
    80207c6c:	220a0a13          	addi	s4,s4,544 # 8020ae88 <_ZTV16DeviceFileSystem+0x238>
    80207c70:	a0b9                	j	80207cbe <_Z16virtio_disk_intrv+0xca>
      printf("intr:%d %d\n", buf0->sector, buf0->type);
    80207c72:	000b3783          	ld	a5,0(s6)
    80207c76:	4390                	lw	a2,0(a5)
    80207c78:	678c                	ld	a1,8(a5)
    80207c7a:	8556                	mv	a0,s5
    80207c7c:	ffff9097          	auipc	ra,0xffff9
    80207c80:	bd8080e7          	jalr	-1064(ra) # 80200854 <_Z6printfPKcz>
      panic("virtio_disk_intr status");
    80207c84:	8552                	mv	a0,s4
    80207c86:	ffff9097          	auipc	ra,0xffff9
    80207c8a:	b5c080e7          	jalr	-1188(ra) # 802007e2 <_Z5panicPKc>
    }

    struct buf *b = virtioDisk.info[id].b;
    80207c8e:	20048493          	addi	s1,s1,512
    80207c92:	0492                	slli	s1,s1,0x4
    80207c94:	94ce                	add	s1,s1,s3
    80207c96:	7488                	ld	a0,40(s1)
    b->disk = 0;  // disk is done with buf
    80207c98:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80207c9c:	ffffa097          	auipc	ra,0xffffa
    80207ca0:	084080e7          	jalr	132(ra) # 80201d20 <_Z6wakeupPv>

    virtioDisk.used_idx += 1;
    80207ca4:	02095783          	lhu	a5,32(s2)
    80207ca8:	2785                	addiw	a5,a5,1
    80207caa:	17c2                	slli	a5,a5,0x30
    80207cac:	93c1                	srli	a5,a5,0x30
    80207cae:	02f91023          	sh	a5,32(s2)
  while (virtioDisk.used_idx != virtioDisk.used->idx) {
    80207cb2:	01093703          	ld	a4,16(s2)
    80207cb6:	00275703          	lhu	a4,2(a4)
    80207cba:	02f70463          	beq	a4,a5,80207ce2 <_Z16virtio_disk_intrv+0xee>
    __sync_synchronize();
    80207cbe:	0ff0000f          	fence
    int id = virtioDisk.used->ring[virtioDisk.used_idx % NUM].id;
    80207cc2:	01093703          	ld	a4,16(s2)
    80207cc6:	02095783          	lhu	a5,32(s2)
    80207cca:	8b9d                	andi	a5,a5,7
    80207ccc:	078e                	slli	a5,a5,0x3
    80207cce:	97ba                	add	a5,a5,a4
    80207cd0:	43c4                	lw	s1,4(a5)
    if (virtioDisk.info[id].status != 0) {
    80207cd2:	20048793          	addi	a5,s1,512
    80207cd6:	0792                	slli	a5,a5,0x4
    80207cd8:	97ce                	add	a5,a5,s3
    80207cda:	0307c783          	lbu	a5,48(a5)
    80207cde:	dbc5                	beqz	a5,80207c8e <_Z16virtio_disk_intrv+0x9a>
    80207ce0:	bf49                	j	80207c72 <_Z16virtio_disk_intrv+0x7e>
  }
  virtioDisk.vdiskLock.unlock();
    80207ce2:	0008e517          	auipc	a0,0x8e
    80207ce6:	44650513          	addi	a0,a0,1094 # 80296128 <virtioDisk+0x2128>
    80207cea:	ffff9097          	auipc	ra,0xffff9
    80207cee:	1de080e7          	jalr	478(ra) # 80200ec8 <_ZN8SpinLock6unlockEv>
}
    80207cf2:	70e2                	ld	ra,56(sp)
    80207cf4:	7442                	ld	s0,48(sp)
    80207cf6:	74a2                	ld	s1,40(sp)
    80207cf8:	7902                	ld	s2,32(sp)
    80207cfa:	69e2                	ld	s3,24(sp)
    80207cfc:	6a42                	ld	s4,16(sp)
    80207cfe:	6aa2                	ld	s5,8(sp)
    80207d00:	6b02                	ld	s6,0(sp)
    80207d02:	6121                	addi	sp,sp,64
    80207d04:	8082                	ret

0000000080207d06 <_Z11virtio_readP3buf>:

void virtio_read(struct buf *b) { virtio_disk_rw(b, 0); }
    80207d06:	1141                	addi	sp,sp,-16
    80207d08:	e406                	sd	ra,8(sp)
    80207d0a:	e022                	sd	s0,0(sp)
    80207d0c:	0800                	addi	s0,sp,16
    80207d0e:	4581                	li	a1,0
    80207d10:	00000097          	auipc	ra,0x0
    80207d14:	c9c080e7          	jalr	-868(ra) # 802079ac <_Z14virtio_disk_rwP3bufi>
    80207d18:	60a2                	ld	ra,8(sp)
    80207d1a:	6402                	ld	s0,0(sp)
    80207d1c:	0141                	addi	sp,sp,16
    80207d1e:	8082                	ret

0000000080207d20 <_Z12virtio_writeP3buf>:
    80207d20:	1141                	addi	sp,sp,-16
    80207d22:	e406                	sd	ra,8(sp)
    80207d24:	e022                	sd	s0,0(sp)
    80207d26:	0800                	addi	s0,sp,16
    80207d28:	4585                	li	a1,1
    80207d2a:	00000097          	auipc	ra,0x0
    80207d2e:	c82080e7          	jalr	-894(ra) # 802079ac <_Z14virtio_disk_rwP3bufi>
    80207d32:	60a2                	ld	ra,8(sp)
    80207d34:	6402                	ld	s0,0(sp)
    80207d36:	0141                	addi	sp,sp,16
    80207d38:	8082                	ret

0000000080207d3a <_GLOBAL__sub_I_virtioDisk>:
    80207d3a:	1141                	addi	sp,sp,-16
    80207d3c:	e406                	sd	ra,8(sp)
    80207d3e:	e022                	sd	s0,0(sp)
    80207d40:	0800                	addi	s0,sp,16
struct alignas(4096) VirtioDisk {
    80207d42:	0008e517          	auipc	a0,0x8e
    80207d46:	3e650513          	addi	a0,a0,998 # 80296128 <virtioDisk+0x2128>
    80207d4a:	ffff9097          	auipc	ra,0xffff9
    80207d4e:	07a080e7          	jalr	122(ra) # 80200dc4 <_ZN8SpinLockC1Ev>
    80207d52:	60a2                	ld	ra,8(sp)
    80207d54:	6402                	ld	s0,0(sp)
    80207d56:	0141                	addi	sp,sp,16
    80207d58:	8082                	ret

0000000080207d5a <deregister_tm_clones>:
    80207d5a:	00003517          	auipc	a0,0x3
    80207d5e:	32e50513          	addi	a0,a0,814 # 8020b088 <__TMC_END__>
    80207d62:	00003797          	auipc	a5,0x3
    80207d66:	32678793          	addi	a5,a5,806 # 8020b088 <__TMC_END__>
    80207d6a:	00a78763          	beq	a5,a0,80207d78 <deregister_tm_clones+0x1e>
    80207d6e:	00000313          	li	t1,0
    80207d72:	00030363          	beqz	t1,80207d78 <deregister_tm_clones+0x1e>
    80207d76:	8302                	jr	t1
    80207d78:	8082                	ret

0000000080207d7a <register_tm_clones>:
    80207d7a:	00003517          	auipc	a0,0x3
    80207d7e:	30e50513          	addi	a0,a0,782 # 8020b088 <__TMC_END__>
    80207d82:	00003597          	auipc	a1,0x3
    80207d86:	30658593          	addi	a1,a1,774 # 8020b088 <__TMC_END__>
    80207d8a:	8d89                	sub	a1,a1,a0
    80207d8c:	858d                	srai	a1,a1,0x3
    80207d8e:	4789                	li	a5,2
    80207d90:	02f5c5b3          	div	a1,a1,a5
    80207d94:	c591                	beqz	a1,80207da0 <register_tm_clones+0x26>
    80207d96:	00000313          	li	t1,0
    80207d9a:	00030363          	beqz	t1,80207da0 <register_tm_clones+0x26>
    80207d9e:	8302                	jr	t1
    80207da0:	8082                	ret

0000000080207da2 <__do_global_dtors_aux>:
    80207da2:	0008f797          	auipc	a5,0x8f
    80207da6:	26678793          	addi	a5,a5,614 # 80297008 <completed.3369>
    80207daa:	0007c703          	lbu	a4,0(a5)
    80207dae:	eb0d                	bnez	a4,80207de0 <__do_global_dtors_aux+0x3e>
    80207db0:	1141                	addi	sp,sp,-16
    80207db2:	e022                	sd	s0,0(sp)
    80207db4:	e406                	sd	ra,8(sp)
    80207db6:	843e                	mv	s0,a5
    80207db8:	fa3ff0ef          	jal	ra,80207d5a <deregister_tm_clones>
    80207dbc:	00000793          	li	a5,0
    80207dc0:	cb89                	beqz	a5,80207dd2 <__do_global_dtors_aux+0x30>
    80207dc2:	00003517          	auipc	a0,0x3
    80207dc6:	2be50513          	addi	a0,a0,702 # 8020b080 <__FRAME_END__>
    80207dca:	00000097          	auipc	ra,0x0
    80207dce:	000000e7          	jalr	zero # 0 <_entry-0x80200000>
    80207dd2:	4785                	li	a5,1
    80207dd4:	60a2                	ld	ra,8(sp)
    80207dd6:	00f40023          	sb	a5,0(s0)
    80207dda:	6402                	ld	s0,0(sp)
    80207ddc:	0141                	addi	sp,sp,16
    80207dde:	8082                	ret
    80207de0:	8082                	ret

0000000080207de2 <frame_dummy>:
    80207de2:	00000793          	li	a5,0
    80207de6:	c38d                	beqz	a5,80207e08 <frame_dummy+0x26>
    80207de8:	1141                	addi	sp,sp,-16
    80207dea:	0008f597          	auipc	a1,0x8f
    80207dee:	22658593          	addi	a1,a1,550 # 80297010 <object.3374>
    80207df2:	00003517          	auipc	a0,0x3
    80207df6:	28e50513          	addi	a0,a0,654 # 8020b080 <__FRAME_END__>
    80207dfa:	e406                	sd	ra,8(sp)
    80207dfc:	00000097          	auipc	ra,0x0
    80207e00:	000000e7          	jalr	zero # 0 <_entry-0x80200000>
    80207e04:	60a2                	ld	ra,8(sp)
    80207e06:	0141                	addi	sp,sp,16
    80207e08:	bf8d                	j	80207d7a <register_tm_clones>
	...

0000000080208000 <trampoline>:
    80208000:	14051573          	csrrw	a0,sscratch,a0
    80208004:	02153423          	sd	ra,40(a0)
    80208008:	02253823          	sd	sp,48(a0)
    8020800c:	02353c23          	sd	gp,56(a0)
    80208010:	04453023          	sd	tp,64(a0)
    80208014:	04553423          	sd	t0,72(a0)
    80208018:	04653823          	sd	t1,80(a0)
    8020801c:	04753c23          	sd	t2,88(a0)
    80208020:	f120                	sd	s0,96(a0)
    80208022:	f524                	sd	s1,104(a0)
    80208024:	fd2c                	sd	a1,120(a0)
    80208026:	e150                	sd	a2,128(a0)
    80208028:	e554                	sd	a3,136(a0)
    8020802a:	e958                	sd	a4,144(a0)
    8020802c:	ed5c                	sd	a5,152(a0)
    8020802e:	0b053023          	sd	a6,160(a0)
    80208032:	0b153423          	sd	a7,168(a0)
    80208036:	0b253823          	sd	s2,176(a0)
    8020803a:	0b353c23          	sd	s3,184(a0)
    8020803e:	0d453023          	sd	s4,192(a0)
    80208042:	0d553423          	sd	s5,200(a0)
    80208046:	0d653823          	sd	s6,208(a0)
    8020804a:	0d753c23          	sd	s7,216(a0)
    8020804e:	0f853023          	sd	s8,224(a0)
    80208052:	0f953423          	sd	s9,232(a0)
    80208056:	0fa53823          	sd	s10,240(a0)
    8020805a:	0fb53c23          	sd	s11,248(a0)
    8020805e:	11c53023          	sd	t3,256(a0)
    80208062:	11d53423          	sd	t4,264(a0)
    80208066:	11e53823          	sd	t5,272(a0)
    8020806a:	11f53c23          	sd	t6,280(a0)
    8020806e:	140022f3          	csrr	t0,sscratch
    80208072:	06553823          	sd	t0,112(a0)
    80208076:	00853103          	ld	sp,8(a0)
    8020807a:	02053203          	ld	tp,32(a0)
    8020807e:	01053283          	ld	t0,16(a0)
    80208082:	00053303          	ld	t1,0(a0)
    80208086:	18031073          	csrw	satp,t1
    8020808a:	12000073          	sfence.vma
    8020808e:	8282                	jr	t0

0000000080208090 <userret>:
    80208090:	18059073          	csrw	satp,a1
    80208094:	12000073          	sfence.vma
    80208098:	07053283          	ld	t0,112(a0)
    8020809c:	14029073          	csrw	sscratch,t0
    802080a0:	02853083          	ld	ra,40(a0)
    802080a4:	03053103          	ld	sp,48(a0)
    802080a8:	03853183          	ld	gp,56(a0)
    802080ac:	04053203          	ld	tp,64(a0)
    802080b0:	04853283          	ld	t0,72(a0)
    802080b4:	05053303          	ld	t1,80(a0)
    802080b8:	05853383          	ld	t2,88(a0)
    802080bc:	7120                	ld	s0,96(a0)
    802080be:	7524                	ld	s1,104(a0)
    802080c0:	7d2c                	ld	a1,120(a0)
    802080c2:	6150                	ld	a2,128(a0)
    802080c4:	6554                	ld	a3,136(a0)
    802080c6:	6958                	ld	a4,144(a0)
    802080c8:	6d5c                	ld	a5,152(a0)
    802080ca:	0a053803          	ld	a6,160(a0)
    802080ce:	0a853883          	ld	a7,168(a0)
    802080d2:	0b053903          	ld	s2,176(a0)
    802080d6:	0b853983          	ld	s3,184(a0)
    802080da:	0c053a03          	ld	s4,192(a0)
    802080de:	0c853a83          	ld	s5,200(a0)
    802080e2:	0d053b03          	ld	s6,208(a0)
    802080e6:	0d853b83          	ld	s7,216(a0)
    802080ea:	0e053c03          	ld	s8,224(a0)
    802080ee:	0e853c83          	ld	s9,232(a0)
    802080f2:	0f053d03          	ld	s10,240(a0)
    802080f6:	0f853d83          	ld	s11,248(a0)
    802080fa:	10053e03          	ld	t3,256(a0)
    802080fe:	10853e83          	ld	t4,264(a0)
    80208102:	11053f03          	ld	t5,272(a0)
    80208106:	11853f83          	ld	t6,280(a0)
    8020810a:	14051573          	csrrw	a0,sscratch,a0
    8020810e:	10200073          	sret
	...

Disassembly of section .init:

0000000080209000 <_init>:
    80209000:	711d                	addi	sp,sp,-96
    80209002:	ec86                	sd	ra,88(sp)
    80209004:	e8a2                	sd	s0,80(sp)
    80209006:	e4a6                	sd	s1,72(sp)
    80209008:	e0ca                	sd	s2,64(sp)
    8020900a:	fc4e                	sd	s3,56(sp)
    8020900c:	f852                	sd	s4,48(sp)
    8020900e:	f456                	sd	s5,40(sp)
    80209010:	f05a                	sd	s6,32(sp)
    80209012:	ec5e                	sd	s7,24(sp)
    80209014:	e862                	sd	s8,16(sp)
    80209016:	e466                	sd	s9,8(sp)
    80209018:	1080                	addi	s0,sp,96
    8020901a:	60e6                	ld	ra,88(sp)
    8020901c:	6446                	ld	s0,80(sp)
    8020901e:	64a6                	ld	s1,72(sp)
    80209020:	6906                	ld	s2,64(sp)
    80209022:	79e2                	ld	s3,56(sp)
    80209024:	7a42                	ld	s4,48(sp)
    80209026:	7aa2                	ld	s5,40(sp)
    80209028:	7b02                	ld	s6,32(sp)
    8020902a:	6be2                	ld	s7,24(sp)
    8020902c:	6c42                	ld	s8,16(sp)
    8020902e:	6ca2                	ld	s9,8(sp)
    80209030:	6125                	addi	sp,sp,96
    80209032:	8082                	ret

Disassembly of section .fini:

0000000080209034 <_fini>:
    80209034:	711d                	addi	sp,sp,-96
    80209036:	ec86                	sd	ra,88(sp)
    80209038:	e8a2                	sd	s0,80(sp)
    8020903a:	e4a6                	sd	s1,72(sp)
    8020903c:	e0ca                	sd	s2,64(sp)
    8020903e:	fc4e                	sd	s3,56(sp)
    80209040:	f852                	sd	s4,48(sp)
    80209042:	f456                	sd	s5,40(sp)
    80209044:	f05a                	sd	s6,32(sp)
    80209046:	ec5e                	sd	s7,24(sp)
    80209048:	e862                	sd	s8,16(sp)
    8020904a:	e466                	sd	s9,8(sp)
    8020904c:	1080                	addi	s0,sp,96
    8020904e:	60e6                	ld	ra,88(sp)
    80209050:	6446                	ld	s0,80(sp)
    80209052:	64a6                	ld	s1,72(sp)
    80209054:	6906                	ld	s2,64(sp)
    80209056:	79e2                	ld	s3,56(sp)
    80209058:	7a42                	ld	s4,48(sp)
    8020905a:	7aa2                	ld	s5,40(sp)
    8020905c:	7b02                	ld	s6,32(sp)
    8020905e:	6be2                	ld	s7,24(sp)
    80209060:	6c42                	ld	s8,16(sp)
    80209062:	6ca2                	ld	s9,8(sp)
    80209064:	6125                	addi	sp,sp,96
    80209066:	8082                	ret
