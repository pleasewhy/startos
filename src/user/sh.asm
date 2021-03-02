
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <showHistory>:

struct cmd {
    char *argv[MAXARG];
};

void showHistory() {
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	e05a                	sd	s6,0(sp)
  12:	0080                	addi	s0,sp,64
    int startP = h.currentP;
    for (int k = MAX_HISTORY_NUM, i = (MAX_HISTORY_NUM + startP) % MAX_HISTORY_NUM; k > 0; i++, k--) {
  14:	00001497          	auipc	s1,0x1
  18:	bb44a483          	lw	s1,-1100(s1) # bc8 <h+0x140>
  1c:	2495                	addiw	s1,s1,5
  1e:	4795                	li	a5,5
  20:	02f4e4bb          	remw	s1,s1,a5
  24:	4915                	li	s2,5
        if (i >= MAX_HISTORY_NUM)
            i = i % MAX_HISTORY_NUM;
        if (h.cmdlist[i][0] == '\0')
  26:	00001997          	auipc	s3,0x1
  2a:	a6298993          	addi	s3,s3,-1438 # a88 <h>
            continue;
        else {
            printf("#%d\t%s\n", k, h.cmdlist[i]);
  2e:	00001b17          	auipc	s6,0x1
  32:	87ab0b13          	addi	s6,s6,-1926 # 8a8 <max+0x1a>
        if (i >= MAX_HISTORY_NUM)
  36:	4a11                	li	s4,4
            i = i % MAX_HISTORY_NUM;
  38:	4a95                	li	s5,5
  3a:	a821                	j	52 <showHistory+0x52>
    for (int k = MAX_HISTORY_NUM, i = (MAX_HISTORY_NUM + startP) % MAX_HISTORY_NUM; k > 0; i++, k--) {
  3c:	0014879b          	addiw	a5,s1,1
  40:	0007849b          	sext.w	s1,a5
  44:	397d                	addiw	s2,s2,-1
  46:	02090763          	beqz	s2,74 <showHistory+0x74>
        if (i >= MAX_HISTORY_NUM)
  4a:	009a5463          	bge	s4,s1,52 <showHistory+0x52>
            i = i % MAX_HISTORY_NUM;
  4e:	0357e4bb          	remw	s1,a5,s5
  52:	0009059b          	sext.w	a1,s2
        if (h.cmdlist[i][0] == '\0')
  56:	00649793          	slli	a5,s1,0x6
  5a:	97ce                	add	a5,a5,s3
  5c:	0007c783          	lbu	a5,0(a5)
  60:	dff1                	beqz	a5,3c <showHistory+0x3c>
            printf("#%d\t%s\n", k, h.cmdlist[i]);
  62:	00649613          	slli	a2,s1,0x6
  66:	964e                	add	a2,a2,s3
  68:	855a                	mv	a0,s6
  6a:	00000097          	auipc	ra,0x0
  6e:	5b2080e7          	jalr	1458(ra) # 61c <printf>
  72:	b7e9                	j	3c <showHistory+0x3c>
        }
    }
}
  74:	70e2                	ld	ra,56(sp)
  76:	7442                	ld	s0,48(sp)
  78:	74a2                	ld	s1,40(sp)
  7a:	7902                	ld	s2,32(sp)
  7c:	69e2                	ld	s3,24(sp)
  7e:	6a42                	ld	s4,16(sp)
  80:	6aa2                	ld	s5,8(sp)
  82:	6b02                	ld	s6,0(sp)
  84:	6121                	addi	sp,sp,64
  86:	8082                	ret

0000000000000088 <get_cmd>:

void get_cmd(struct cmd *cmd) {
  88:	7135                	addi	sp,sp,-160
  8a:	ed06                	sd	ra,152(sp)
  8c:	e922                	sd	s0,144(sp)
  8e:	e526                	sd	s1,136(sp)
  90:	e14a                	sd	s2,128(sp)
  92:	fcce                	sd	s3,120(sp)
  94:	f8d2                	sd	s4,112(sp)
  96:	f4d6                	sd	s5,104(sp)
  98:	f0da                	sd	s6,96(sp)
  9a:	ecde                	sd	s7,88(sp)
  9c:	e8e2                	sd	s8,80(sp)
  9e:	e4e6                	sd	s9,72(sp)
  a0:	e0ea                	sd	s10,64(sp)
  a2:	1100                	addi	s0,sp,160
  a4:	8aaa                	mv	s5,a0
    int start;
    int argc = 0;
    char buf[MAX_BUFFER_SIZE];
    memset(buf, 0, sizeof(buf));
  a6:	04000613          	li	a2,64
  aa:	4581                	li	a1,0
  ac:	f6040513          	addi	a0,s0,-160
  b0:	00000097          	auipc	ra,0x0
  b4:	6f2080e7          	jalr	1778(ra) # 7a2 <memset>

    while (read(0, buf, sizeof(buf)) <= 0);
  b8:	04000613          	li	a2,64
  bc:	f6040593          	addi	a1,s0,-160
  c0:	4501                	li	a0,0
  c2:	00000097          	auipc	ra,0x0
  c6:	228080e7          	jalr	552(ra) # 2ea <read>
  ca:	fea057e3          	blez	a0,b8 <get_cmd+0x30>
  ce:	f6040913          	addi	s2,s0,-160
    start = 0;
    int i;
    for (i = 0; i < strlen(buf); ++i) {
  d2:	4481                	li	s1,0
    int argc = 0;
  d4:	4981                	li	s3,0
    start = 0;
  d6:	4a01                	li	s4,0
        if (buf[i] == ' ' || buf[i] == '\n') {
  d8:	02000b13          	li	s6,32
            strncpy(arg_mem[argc],buf + start,  i - start);
  dc:	00001c17          	auipc	s8,0x1
  e0:	af4c0c13          	addi	s8,s8,-1292 # bd0 <arg_mem>
        if (buf[i] == ' ' || buf[i] == '\n') {
  e4:	4ba9                	li	s7,10
  e6:	a80d                	j	118 <get_cmd+0x90>
            strncpy(arg_mem[argc],buf + start,  i - start);
  e8:	00699d13          	slli	s10,s3,0x6
  ec:	9d62                	add	s10,s10,s8
  ee:	4144863b          	subw	a2,s1,s4
  f2:	f6040793          	addi	a5,s0,-160
  f6:	014785b3          	add	a1,a5,s4
  fa:	856a                	mv	a0,s10
  fc:	00000097          	auipc	ra,0x0
 100:	556080e7          	jalr	1366(ra) # 652 <strncpy>
            cmd->argv[argc] = arg_mem[argc];
 104:	00399793          	slli	a5,s3,0x3
 108:	97d6                	add	a5,a5,s5
 10a:	01a7b023          	sd	s10,0(a5)
            start = i + 1;
 10e:	001c8a1b          	addiw	s4,s9,1
            argc++;
 112:	2985                	addiw	s3,s3,1
    for (i = 0; i < strlen(buf); ++i) {
 114:	2485                	addiw	s1,s1,1
 116:	0905                	addi	s2,s2,1
 118:	f6040513          	addi	a0,s0,-160
 11c:	00000097          	auipc	ra,0x0
 120:	5bc080e7          	jalr	1468(ra) # 6d8 <strlen>
 124:	2501                	sext.w	a0,a0
 126:	00048c9b          	sext.w	s9,s1
 12a:	00acf963          	bgeu	s9,a0,13c <get_cmd+0xb4>
        if (buf[i] == ' ' || buf[i] == '\n') {
 12e:	00094783          	lbu	a5,0(s2)
 132:	fb678be3          	beq	a5,s6,e8 <get_cmd+0x60>
 136:	fd779fe3          	bne	a5,s7,114 <get_cmd+0x8c>
 13a:	b77d                	j	e8 <get_cmd+0x60>
        }
    }
    cmd->argv[argc] = 0;
 13c:	098e                	slli	s3,s3,0x3
 13e:	99d6                	add	s3,s3,s5
 140:	0009b023          	sd	zero,0(s3)
}
 144:	60ea                	ld	ra,152(sp)
 146:	644a                	ld	s0,144(sp)
 148:	64aa                	ld	s1,136(sp)
 14a:	690a                	ld	s2,128(sp)
 14c:	79e6                	ld	s3,120(sp)
 14e:	7a46                	ld	s4,112(sp)
 150:	7aa6                	ld	s5,104(sp)
 152:	7b06                	ld	s6,96(sp)
 154:	6be6                	ld	s7,88(sp)
 156:	6c46                	ld	s8,80(sp)
 158:	6ca6                	ld	s9,72(sp)
 15a:	6d06                	ld	s10,64(sp)
 15c:	610d                	addi	sp,sp,160
 15e:	8082                	ret

0000000000000160 <run_cmd>:

void run_cmd(struct cmd *cmd) {
 160:	1101                	addi	sp,sp,-32
 162:	ec06                	sd	ra,24(sp)
 164:	e822                	sd	s0,16(sp)
 166:	e426                	sd	s1,8(sp)
 168:	1000                	addi	s0,sp,32
 16a:	84aa                	mv	s1,a0
    if (strcmp(cmd->argv[0], "!!") == 0)
 16c:	00000597          	auipc	a1,0x0
 170:	74458593          	addi	a1,a1,1860 # 8b0 <max+0x22>
 174:	6108                	ld	a0,0(a0)
 176:	00000097          	auipc	ra,0x0
 17a:	536080e7          	jalr	1334(ra) # 6ac <strcmp>
 17e:	e911                	bnez	a0,192 <run_cmd+0x32>
        showHistory();
 180:	00000097          	auipc	ra,0x0
 184:	e80080e7          	jalr	-384(ra) # 0 <showHistory>
        }
        if (h.currentP >= MAX_HISTORY_NUM)
            h.currentP = h.currentP % MAX_HISTORY_NUM;
//        strcpy(h.cmdlist[h.currentP++], buf);
    }
}
 188:	60e2                	ld	ra,24(sp)
 18a:	6442                	ld	s0,16(sp)
 18c:	64a2                	ld	s1,8(sp)
 18e:	6105                	addi	sp,sp,32
 190:	8082                	ret
        int pid = fork();
 192:	00000097          	auipc	ra,0x0
 196:	168080e7          	jalr	360(ra) # 2fa <fork>
        if (pid == 0) {
 19a:	e515                	bnez	a0,1c6 <run_cmd+0x66>
            exec(cmd->argv[0], cmd->argv);
 19c:	85a6                	mv	a1,s1
 19e:	6088                	ld	a0,0(s1)
 1a0:	00000097          	auipc	ra,0x0
 1a4:	142080e7          	jalr	322(ra) # 2e2 <exec>
        if (h.currentP >= MAX_HISTORY_NUM)
 1a8:	00001797          	auipc	a5,0x1
 1ac:	a207a783          	lw	a5,-1504(a5) # bc8 <h+0x140>
 1b0:	4711                	li	a4,4
 1b2:	fcf75be3          	bge	a4,a5,188 <run_cmd+0x28>
            h.currentP = h.currentP % MAX_HISTORY_NUM;
 1b6:	4715                	li	a4,5
 1b8:	02e7e7bb          	remw	a5,a5,a4
 1bc:	00001717          	auipc	a4,0x1
 1c0:	a0f72623          	sw	a5,-1524(a4) # bc8 <h+0x140>
}
 1c4:	b7d1                	j	188 <run_cmd+0x28>
            wait(0);
 1c6:	4501                	li	a0,0
 1c8:	00000097          	auipc	ra,0x0
 1cc:	142080e7          	jalr	322(ra) # 30a <wait>
 1d0:	bfe1                	j	1a8 <run_cmd+0x48>

00000000000001d2 <help>:

void help() {
 1d2:	1141                	addi	sp,sp,-16
 1d4:	e406                	sd	ra,8(sp)
 1d6:	e022                	sd	s0,0(sp)
 1d8:	0800                	addi	s0,sp,16
    printf("All available commmands:\n");
 1da:	00000517          	auipc	a0,0x0
 1de:	6de50513          	addi	a0,a0,1758 # 8b8 <max+0x2a>
 1e2:	00000097          	auipc	ra,0x0
 1e6:	43a080e7          	jalr	1082(ra) # 61c <printf>
    printf("help\tshow this helping message\n");
 1ea:	00000517          	auipc	a0,0x0
 1ee:	6ee50513          	addi	a0,a0,1774 # 8d8 <max+0x4a>
 1f2:	00000097          	auipc	ra,0x0
 1f6:	42a080e7          	jalr	1066(ra) # 61c <printf>
    printf("hello\tprint test hello world message\n");
 1fa:	00000517          	auipc	a0,0x0
 1fe:	6fe50513          	addi	a0,a0,1790 # 8f8 <max+0x6a>
 202:	00000097          	auipc	ra,0x0
 206:	41a080e7          	jalr	1050(ra) # 61c <printf>
    printf("history\tshow recent commands you input\n");
 20a:	00000517          	auipc	a0,0x0
 20e:	71650513          	addi	a0,a0,1814 # 920 <max+0x92>
 212:	00000097          	auipc	ra,0x0
 216:	40a080e7          	jalr	1034(ra) # 61c <printf>
    printf("usertests\texec test function\n");
 21a:	00000517          	auipc	a0,0x0
 21e:	72e50513          	addi	a0,a0,1838 # 948 <max+0xba>
 222:	00000097          	auipc	ra,0x0
 226:	3fa080e7          	jalr	1018(ra) # 61c <printf>
    printf("cowsay\tcowsay\n");
 22a:	00000517          	auipc	a0,0x0
 22e:	73e50513          	addi	a0,a0,1854 # 968 <max+0xda>
 232:	00000097          	auipc	ra,0x0
 236:	3ea080e7          	jalr	1002(ra) # 61c <printf>
    printf("mew\tmew mew\n");
 23a:	00000517          	auipc	a0,0x0
 23e:	73e50513          	addi	a0,a0,1854 # 978 <max+0xea>
 242:	00000097          	auipc	ra,0x0
 246:	3da080e7          	jalr	986(ra) # 61c <printf>
    exit(0);
 24a:	4501                	li	a0,0
 24c:	00000097          	auipc	ra,0x0
 250:	0b6080e7          	jalr	182(ra) # 302 <exit>
}
 254:	60a2                	ld	ra,8(sp)
 256:	6402                	ld	s0,0(sp)
 258:	0141                	addi	sp,sp,16
 25a:	8082                	ret

000000000000025c <main>:

int main() {
 25c:	712d                	addi	sp,sp,-288
 25e:	ee06                	sd	ra,280(sp)
 260:	ea22                	sd	s0,272(sp)
 262:	e626                	sd	s1,264(sp)
 264:	1200                	addi	s0,sp,288
    printf("\n==========================Start OS=========================\n");
 266:	00000517          	auipc	a0,0x0
 26a:	72250513          	addi	a0,a0,1826 # 988 <max+0xfa>
 26e:	00000097          	auipc	ra,0x0
 272:	3ae080e7          	jalr	942(ra) # 61c <printf>
    printf("Welcome to startOS! Use following commands to get started.\n");
 276:	00000517          	auipc	a0,0x0
 27a:	75250513          	addi	a0,a0,1874 # 9c8 <max+0x13a>
 27e:	00000097          	auipc	ra,0x0
 282:	39e080e7          	jalr	926(ra) # 61c <printf>
    printf("  * hello - print test hello world message\n");
 286:	00000517          	auipc	a0,0x0
 28a:	78250513          	addi	a0,a0,1922 # a08 <max+0x17a>
 28e:	00000097          	auipc	ra,0x0
 292:	38e080e7          	jalr	910(ra) # 61c <printf>
    printf("  * help - list all available commands\n");
 296:	00000517          	auipc	a0,0x0
 29a:	7a250513          	addi	a0,a0,1954 # a38 <max+0x1aa>
 29e:	00000097          	auipc	ra,0x0
 2a2:	37e080e7          	jalr	894(ra) # 61c <printf>
    struct cmd cmd;
    h.currentP = 0; //当前指令即将写入的位置
 2a6:	00001797          	auipc	a5,0x1
 2aa:	9207a123          	sw	zero,-1758(a5) # bc8 <h+0x140>

    while (1) {
        printf("osh>> ");
 2ae:	00000497          	auipc	s1,0x0
 2b2:	7b248493          	addi	s1,s1,1970 # a60 <max+0x1d2>
 2b6:	8526                	mv	a0,s1
 2b8:	00000097          	auipc	ra,0x0
 2bc:	364080e7          	jalr	868(ra) # 61c <printf>
        get_cmd(&cmd);
 2c0:	ee040513          	addi	a0,s0,-288
 2c4:	00000097          	auipc	ra,0x0
 2c8:	dc4080e7          	jalr	-572(ra) # 88 <get_cmd>
        run_cmd(&cmd);
 2cc:	ee040513          	addi	a0,s0,-288
 2d0:	00000097          	auipc	ra,0x0
 2d4:	e90080e7          	jalr	-368(ra) # 160 <run_cmd>
    while (1) {
 2d8:	bff9                	j	2b6 <main+0x5a>

00000000000002da <putchar>:
# generated by usys.pl - do not edit
#include "kernel/trap/syscall.h"
.global putchar
putchar:
 li a7, SYS_putchar
 2da:	4885                	li	a7,1
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2e2:	4889                	li	a7,2
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <read>:
.global read
read:
 li a7, SYS_read
 2ea:	4899                	li	a7,6
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <write>:
.global write
write:
 li a7, SYS_write
 2f2:	489d                	li	a7,7
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <fork>:
.global fork
fork:
 li a7, SYS_fork
 2fa:	4891                	li	a7,4
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <exit>:
.global exit
exit:
 li a7, SYS_exit
 302:	488d                	li	a7,3
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <wait>:
.global wait
wait:
 li a7, SYS_wait
 30a:	4895                	li	a7,5
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <open>:
.global open
open:
 li a7, SYS_open
 312:	48a1                	li	a7,8
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 31a:	48a9                	li	a7,10
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 322:	48a5                	li	a7,9
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 32a:	48ad                	li	a7,11
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <dup>:
.global dup
dup:
 li a7, SYS_dup
 332:	48b1                	li	a7,12
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 33a:	48b5                	li	a7,13
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <putc>:
#include <stdarg.h>

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c) {
 342:	1101                	addi	sp,sp,-32
 344:	ec06                	sd	ra,24(sp)
 346:	e822                	sd	s0,16(sp)
 348:	1000                	addi	s0,sp,32
 34a:	feb407a3          	sb	a1,-17(s0)
    write(0, &c, 1);
 34e:	4605                	li	a2,1
 350:	fef40593          	addi	a1,s0,-17
 354:	4501                	li	a0,0
 356:	00000097          	auipc	ra,0x0
 35a:	f9c080e7          	jalr	-100(ra) # 2f2 <write>
}
 35e:	60e2                	ld	ra,24(sp)
 360:	6442                	ld	s0,16(sp)
 362:	6105                	addi	sp,sp,32
 364:	8082                	ret

0000000000000366 <printint>:

static void
printint(int fd, int xx, int base, int sgn) {
 366:	7139                	addi	sp,sp,-64
 368:	fc06                	sd	ra,56(sp)
 36a:	f822                	sd	s0,48(sp)
 36c:	f426                	sd	s1,40(sp)
 36e:	f04a                	sd	s2,32(sp)
 370:	ec4e                	sd	s3,24(sp)
 372:	0080                	addi	s0,sp,64
 374:	84aa                	mv	s1,a0
    char buf[16];
    int i, neg;
    uint x;

    neg = 0;
    if (sgn && xx < 0) {
 376:	c299                	beqz	a3,37c <printint+0x16>
 378:	0805c863          	bltz	a1,408 <printint+0xa2>
        neg = 1;
        x = -xx;
    } else {
        x = xx;
 37c:	2581                	sext.w	a1,a1
    neg = 0;
 37e:	4881                	li	a7,0
 380:	fc040693          	addi	a3,s0,-64
    }

    i = 0;
 384:	4701                	li	a4,0
    do {
        buf[i++] = digits[x % base];
 386:	2601                	sext.w	a2,a2
 388:	00000517          	auipc	a0,0x0
 38c:	6e850513          	addi	a0,a0,1768 # a70 <digits>
 390:	883a                	mv	a6,a4
 392:	2705                	addiw	a4,a4,1
 394:	02c5f7bb          	remuw	a5,a1,a2
 398:	1782                	slli	a5,a5,0x20
 39a:	9381                	srli	a5,a5,0x20
 39c:	97aa                	add	a5,a5,a0
 39e:	0007c783          	lbu	a5,0(a5)
 3a2:	00f68023          	sb	a5,0(a3)
    } while ((x /= base) != 0);
 3a6:	0005879b          	sext.w	a5,a1
 3aa:	02c5d5bb          	divuw	a1,a1,a2
 3ae:	0685                	addi	a3,a3,1
 3b0:	fec7f0e3          	bgeu	a5,a2,390 <printint+0x2a>
    if (neg)
 3b4:	00088b63          	beqz	a7,3ca <printint+0x64>
        buf[i++] = '-';
 3b8:	fd040793          	addi	a5,s0,-48
 3bc:	973e                	add	a4,a4,a5
 3be:	02d00793          	li	a5,45
 3c2:	fef70823          	sb	a5,-16(a4)
 3c6:	0028071b          	addiw	a4,a6,2

    while (--i >= 0)
 3ca:	02e05863          	blez	a4,3fa <printint+0x94>
 3ce:	fc040793          	addi	a5,s0,-64
 3d2:	00e78933          	add	s2,a5,a4
 3d6:	fff78993          	addi	s3,a5,-1
 3da:	99ba                	add	s3,s3,a4
 3dc:	377d                	addiw	a4,a4,-1
 3de:	1702                	slli	a4,a4,0x20
 3e0:	9301                	srli	a4,a4,0x20
 3e2:	40e989b3          	sub	s3,s3,a4
        putc(fd, buf[i]);
 3e6:	fff94583          	lbu	a1,-1(s2)
 3ea:	8526                	mv	a0,s1
 3ec:	00000097          	auipc	ra,0x0
 3f0:	f56080e7          	jalr	-170(ra) # 342 <putc>
    while (--i >= 0)
 3f4:	197d                	addi	s2,s2,-1
 3f6:	ff3918e3          	bne	s2,s3,3e6 <printint+0x80>
}
 3fa:	70e2                	ld	ra,56(sp)
 3fc:	7442                	ld	s0,48(sp)
 3fe:	74a2                	ld	s1,40(sp)
 400:	7902                	ld	s2,32(sp)
 402:	69e2                	ld	s3,24(sp)
 404:	6121                	addi	sp,sp,64
 406:	8082                	ret
        x = -xx;
 408:	40b005bb          	negw	a1,a1
        neg = 1;
 40c:	4885                	li	a7,1
        x = -xx;
 40e:	bf8d                	j	380 <printint+0x1a>

0000000000000410 <vprintf>:
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap) {
 410:	7119                	addi	sp,sp,-128
 412:	fc86                	sd	ra,120(sp)
 414:	f8a2                	sd	s0,112(sp)
 416:	f4a6                	sd	s1,104(sp)
 418:	f0ca                	sd	s2,96(sp)
 41a:	ecce                	sd	s3,88(sp)
 41c:	e8d2                	sd	s4,80(sp)
 41e:	e4d6                	sd	s5,72(sp)
 420:	e0da                	sd	s6,64(sp)
 422:	fc5e                	sd	s7,56(sp)
 424:	f862                	sd	s8,48(sp)
 426:	f466                	sd	s9,40(sp)
 428:	f06a                	sd	s10,32(sp)
 42a:	ec6e                	sd	s11,24(sp)
 42c:	0100                	addi	s0,sp,128
    char *s;
    int c, i, state;

    state = 0;
    for (i = 0; fmt[i]; i++) {
 42e:	0005c903          	lbu	s2,0(a1)
 432:	18090f63          	beqz	s2,5d0 <vprintf+0x1c0>
 436:	8aaa                	mv	s5,a0
 438:	8b32                	mv	s6,a2
 43a:	00158493          	addi	s1,a1,1
    state = 0;
 43e:	4981                	li	s3,0
            if (c == '%') {
                state = '%';
            } else {
                putc(fd, c);
            }
        } else if (state == '%') {
 440:	02500a13          	li	s4,37
            if (c == 'd') {
 444:	06400c13          	li	s8,100
                printint(fd, va_arg(ap, int), 10, 1);
            } else if (c == 'l') {
 448:	06c00c93          	li	s9,108
                printint(fd, va_arg(ap, uint64), 10, 0);
            } else if (c == 'x') {
 44c:	07800d13          	li	s10,120
                printint(fd, va_arg(ap, int), 16, 0);
            } else if (c == 'p') {
 450:	07000d93          	li	s11,112
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 454:	00000b97          	auipc	s7,0x0
 458:	61cb8b93          	addi	s7,s7,1564 # a70 <digits>
 45c:	a839                	j	47a <vprintf+0x6a>
                putc(fd, c);
 45e:	85ca                	mv	a1,s2
 460:	8556                	mv	a0,s5
 462:	00000097          	auipc	ra,0x0
 466:	ee0080e7          	jalr	-288(ra) # 342 <putc>
 46a:	a019                	j	470 <vprintf+0x60>
        } else if (state == '%') {
 46c:	01498f63          	beq	s3,s4,48a <vprintf+0x7a>
    for (i = 0; fmt[i]; i++) {
 470:	0485                	addi	s1,s1,1
 472:	fff4c903          	lbu	s2,-1(s1)
 476:	14090d63          	beqz	s2,5d0 <vprintf+0x1c0>
        c = fmt[i] & 0xff;
 47a:	0009079b          	sext.w	a5,s2
        if (state == 0) {
 47e:	fe0997e3          	bnez	s3,46c <vprintf+0x5c>
            if (c == '%') {
 482:	fd479ee3          	bne	a5,s4,45e <vprintf+0x4e>
                state = '%';
 486:	89be                	mv	s3,a5
 488:	b7e5                	j	470 <vprintf+0x60>
            if (c == 'd') {
 48a:	05878063          	beq	a5,s8,4ca <vprintf+0xba>
            } else if (c == 'l') {
 48e:	05978c63          	beq	a5,s9,4e6 <vprintf+0xd6>
            } else if (c == 'x') {
 492:	07a78863          	beq	a5,s10,502 <vprintf+0xf2>
            } else if (c == 'p') {
 496:	09b78463          	beq	a5,s11,51e <vprintf+0x10e>
                printptr(fd, va_arg(ap, uint64));
            } else if (c == 's') {
 49a:	07300713          	li	a4,115
 49e:	0ce78663          	beq	a5,a4,56a <vprintf+0x15a>
                    s = "(null)";
                while (*s != 0) {
                    putc(fd, *s);
                    s++;
                }
            } else if (c == 'c') {
 4a2:	06300713          	li	a4,99
 4a6:	0ee78e63          	beq	a5,a4,5a2 <vprintf+0x192>
                putc(fd, va_arg(ap, uint));
            } else if (c == '%') {
 4aa:	11478863          	beq	a5,s4,5ba <vprintf+0x1aa>
                putc(fd, c);
            } else {
                // Unknown % sequence.  Print it to draw attention.
                putc(fd, '%');
 4ae:	85d2                	mv	a1,s4
 4b0:	8556                	mv	a0,s5
 4b2:	00000097          	auipc	ra,0x0
 4b6:	e90080e7          	jalr	-368(ra) # 342 <putc>
                putc(fd, c);
 4ba:	85ca                	mv	a1,s2
 4bc:	8556                	mv	a0,s5
 4be:	00000097          	auipc	ra,0x0
 4c2:	e84080e7          	jalr	-380(ra) # 342 <putc>
            }
            state = 0;
 4c6:	4981                	li	s3,0
 4c8:	b765                	j	470 <vprintf+0x60>
                printint(fd, va_arg(ap, int), 10, 1);
 4ca:	008b0913          	addi	s2,s6,8
 4ce:	4685                	li	a3,1
 4d0:	4629                	li	a2,10
 4d2:	000b2583          	lw	a1,0(s6)
 4d6:	8556                	mv	a0,s5
 4d8:	00000097          	auipc	ra,0x0
 4dc:	e8e080e7          	jalr	-370(ra) # 366 <printint>
 4e0:	8b4a                	mv	s6,s2
            state = 0;
 4e2:	4981                	li	s3,0
 4e4:	b771                	j	470 <vprintf+0x60>
                printint(fd, va_arg(ap, uint64), 10, 0);
 4e6:	008b0913          	addi	s2,s6,8
 4ea:	4681                	li	a3,0
 4ec:	4629                	li	a2,10
 4ee:	000b2583          	lw	a1,0(s6)
 4f2:	8556                	mv	a0,s5
 4f4:	00000097          	auipc	ra,0x0
 4f8:	e72080e7          	jalr	-398(ra) # 366 <printint>
 4fc:	8b4a                	mv	s6,s2
            state = 0;
 4fe:	4981                	li	s3,0
 500:	bf85                	j	470 <vprintf+0x60>
                printint(fd, va_arg(ap, int), 16, 0);
 502:	008b0913          	addi	s2,s6,8
 506:	4681                	li	a3,0
 508:	4641                	li	a2,16
 50a:	000b2583          	lw	a1,0(s6)
 50e:	8556                	mv	a0,s5
 510:	00000097          	auipc	ra,0x0
 514:	e56080e7          	jalr	-426(ra) # 366 <printint>
 518:	8b4a                	mv	s6,s2
            state = 0;
 51a:	4981                	li	s3,0
 51c:	bf91                	j	470 <vprintf+0x60>
                printptr(fd, va_arg(ap, uint64));
 51e:	008b0793          	addi	a5,s6,8
 522:	f8f43423          	sd	a5,-120(s0)
 526:	000b3983          	ld	s3,0(s6)
    putc(fd, '0');
 52a:	03000593          	li	a1,48
 52e:	8556                	mv	a0,s5
 530:	00000097          	auipc	ra,0x0
 534:	e12080e7          	jalr	-494(ra) # 342 <putc>
    putc(fd, 'x');
 538:	85ea                	mv	a1,s10
 53a:	8556                	mv	a0,s5
 53c:	00000097          	auipc	ra,0x0
 540:	e06080e7          	jalr	-506(ra) # 342 <putc>
 544:	4941                	li	s2,16
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 546:	03c9d793          	srli	a5,s3,0x3c
 54a:	97de                	add	a5,a5,s7
 54c:	0007c583          	lbu	a1,0(a5)
 550:	8556                	mv	a0,s5
 552:	00000097          	auipc	ra,0x0
 556:	df0080e7          	jalr	-528(ra) # 342 <putc>
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 55a:	0992                	slli	s3,s3,0x4
 55c:	397d                	addiw	s2,s2,-1
 55e:	fe0914e3          	bnez	s2,546 <vprintf+0x136>
                printptr(fd, va_arg(ap, uint64));
 562:	f8843b03          	ld	s6,-120(s0)
            state = 0;
 566:	4981                	li	s3,0
 568:	b721                	j	470 <vprintf+0x60>
                s = va_arg(ap, char*);
 56a:	008b0993          	addi	s3,s6,8
 56e:	000b3903          	ld	s2,0(s6)
                if (s == 0)
 572:	02090163          	beqz	s2,594 <vprintf+0x184>
                while (*s != 0) {
 576:	00094583          	lbu	a1,0(s2)
 57a:	c9a1                	beqz	a1,5ca <vprintf+0x1ba>
                    putc(fd, *s);
 57c:	8556                	mv	a0,s5
 57e:	00000097          	auipc	ra,0x0
 582:	dc4080e7          	jalr	-572(ra) # 342 <putc>
                    s++;
 586:	0905                	addi	s2,s2,1
                while (*s != 0) {
 588:	00094583          	lbu	a1,0(s2)
 58c:	f9e5                	bnez	a1,57c <vprintf+0x16c>
                s = va_arg(ap, char*);
 58e:	8b4e                	mv	s6,s3
            state = 0;
 590:	4981                	li	s3,0
 592:	bdf9                	j	470 <vprintf+0x60>
                    s = "(null)";
 594:	00000917          	auipc	s2,0x0
 598:	4d490913          	addi	s2,s2,1236 # a68 <max+0x1da>
                while (*s != 0) {
 59c:	02800593          	li	a1,40
 5a0:	bff1                	j	57c <vprintf+0x16c>
                putc(fd, va_arg(ap, uint));
 5a2:	008b0913          	addi	s2,s6,8
 5a6:	000b4583          	lbu	a1,0(s6)
 5aa:	8556                	mv	a0,s5
 5ac:	00000097          	auipc	ra,0x0
 5b0:	d96080e7          	jalr	-618(ra) # 342 <putc>
 5b4:	8b4a                	mv	s6,s2
            state = 0;
 5b6:	4981                	li	s3,0
 5b8:	bd65                	j	470 <vprintf+0x60>
                putc(fd, c);
 5ba:	85d2                	mv	a1,s4
 5bc:	8556                	mv	a0,s5
 5be:	00000097          	auipc	ra,0x0
 5c2:	d84080e7          	jalr	-636(ra) # 342 <putc>
            state = 0;
 5c6:	4981                	li	s3,0
 5c8:	b565                	j	470 <vprintf+0x60>
                s = va_arg(ap, char*);
 5ca:	8b4e                	mv	s6,s3
            state = 0;
 5cc:	4981                	li	s3,0
 5ce:	b54d                	j	470 <vprintf+0x60>
        }
    }
}
 5d0:	70e6                	ld	ra,120(sp)
 5d2:	7446                	ld	s0,112(sp)
 5d4:	74a6                	ld	s1,104(sp)
 5d6:	7906                	ld	s2,96(sp)
 5d8:	69e6                	ld	s3,88(sp)
 5da:	6a46                	ld	s4,80(sp)
 5dc:	6aa6                	ld	s5,72(sp)
 5de:	6b06                	ld	s6,64(sp)
 5e0:	7be2                	ld	s7,56(sp)
 5e2:	7c42                	ld	s8,48(sp)
 5e4:	7ca2                	ld	s9,40(sp)
 5e6:	7d02                	ld	s10,32(sp)
 5e8:	6de2                	ld	s11,24(sp)
 5ea:	6109                	addi	sp,sp,128
 5ec:	8082                	ret

00000000000005ee <fprintf>:

void
fprintf(int fd, const char *fmt, ...) {
 5ee:	715d                	addi	sp,sp,-80
 5f0:	ec06                	sd	ra,24(sp)
 5f2:	e822                	sd	s0,16(sp)
 5f4:	1000                	addi	s0,sp,32
 5f6:	e010                	sd	a2,0(s0)
 5f8:	e414                	sd	a3,8(s0)
 5fa:	e818                	sd	a4,16(s0)
 5fc:	ec1c                	sd	a5,24(s0)
 5fe:	03043023          	sd	a6,32(s0)
 602:	03143423          	sd	a7,40(s0)
    va_list ap;

    va_start(ap, fmt);
 606:	fe843423          	sd	s0,-24(s0)
    vprintf(fd, fmt, ap);
 60a:	8622                	mv	a2,s0
 60c:	00000097          	auipc	ra,0x0
 610:	e04080e7          	jalr	-508(ra) # 410 <vprintf>
}
 614:	60e2                	ld	ra,24(sp)
 616:	6442                	ld	s0,16(sp)
 618:	6161                	addi	sp,sp,80
 61a:	8082                	ret

000000000000061c <printf>:

void
printf(const char *fmt, ...) {
 61c:	711d                	addi	sp,sp,-96
 61e:	ec06                	sd	ra,24(sp)
 620:	e822                	sd	s0,16(sp)
 622:	1000                	addi	s0,sp,32
 624:	e40c                	sd	a1,8(s0)
 626:	e810                	sd	a2,16(s0)
 628:	ec14                	sd	a3,24(s0)
 62a:	f018                	sd	a4,32(s0)
 62c:	f41c                	sd	a5,40(s0)
 62e:	03043823          	sd	a6,48(s0)
 632:	03143c23          	sd	a7,56(s0)
    va_list ap;

    va_start(ap, fmt);
 636:	00840613          	addi	a2,s0,8
 63a:	fec43423          	sd	a2,-24(s0)
    vprintf(1, fmt, ap);
 63e:	85aa                	mv	a1,a0
 640:	4505                	li	a0,1
 642:	00000097          	auipc	ra,0x0
 646:	dce080e7          	jalr	-562(ra) # 410 <vprintf>
}
 64a:	60e2                	ld	ra,24(sp)
 64c:	6442                	ld	s0,16(sp)
 64e:	6125                	addi	sp,sp,96
 650:	8082                	ret

0000000000000652 <strncpy>:
#include "../kernel/types.h"
#include "../kernel/fs/fcntl.h"
#include "user.h"
//string utils
char * strncpy(char *s, const char *t, int n) {
 652:	1141                	addi	sp,sp,-16
 654:	e422                	sd	s0,8(sp)
 656:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while (n-- > 0 && (*s++ = *t++) != 0);
 658:	872a                	mv	a4,a0
 65a:	8832                	mv	a6,a2
 65c:	367d                	addiw	a2,a2,-1
 65e:	01005963          	blez	a6,670 <strncpy+0x1e>
 662:	0705                	addi	a4,a4,1
 664:	0005c783          	lbu	a5,0(a1)
 668:	fef70fa3          	sb	a5,-1(a4)
 66c:	0585                	addi	a1,a1,1
 66e:	f7f5                	bnez	a5,65a <strncpy+0x8>
    while (n-- > 0)
 670:	00c05d63          	blez	a2,68a <strncpy+0x38>
 674:	86ba                	mv	a3,a4
        *s++ = 0;
 676:	0685                	addi	a3,a3,1
 678:	fe068fa3          	sb	zero,-1(a3)
    while (n-- > 0)
 67c:	fff6c793          	not	a5,a3
 680:	9fb9                	addw	a5,a5,a4
 682:	010787bb          	addw	a5,a5,a6
 686:	fef048e3          	bgtz	a5,676 <strncpy+0x24>
    return os;
}
 68a:	6422                	ld	s0,8(sp)
 68c:	0141                	addi	sp,sp,16
 68e:	8082                	ret

0000000000000690 <strcpy>:

char* strcpy(char* s, const char* t)
{
 690:	1141                	addi	sp,sp,-16
 692:	e422                	sd	s0,8(sp)
 694:	0800                	addi	s0,sp,16
    char* os;
    os = s;
    while ((*s++ = *t++) != 0)
 696:	87aa                	mv	a5,a0
 698:	0585                	addi	a1,a1,1
 69a:	0785                	addi	a5,a5,1
 69c:	fff5c703          	lbu	a4,-1(a1)
 6a0:	fee78fa3          	sb	a4,-1(a5)
 6a4:	fb75                	bnez	a4,698 <strcpy+0x8>
        ;
    return os;
}
 6a6:	6422                	ld	s0,8(sp)
 6a8:	0141                	addi	sp,sp,16
 6aa:	8082                	ret

00000000000006ac <strcmp>:

int strcmp(const char* p, const char* q)
{
 6ac:	1141                	addi	sp,sp,-16
 6ae:	e422                	sd	s0,8(sp)
 6b0:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 6b2:	00054783          	lbu	a5,0(a0)
 6b6:	cb91                	beqz	a5,6ca <strcmp+0x1e>
 6b8:	0005c703          	lbu	a4,0(a1)
 6bc:	00f71763          	bne	a4,a5,6ca <strcmp+0x1e>
        p++, q++;
 6c0:	0505                	addi	a0,a0,1
 6c2:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 6c4:	00054783          	lbu	a5,0(a0)
 6c8:	fbe5                	bnez	a5,6b8 <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
 6ca:	0005c503          	lbu	a0,0(a1)
}
 6ce:	40a7853b          	subw	a0,a5,a0
 6d2:	6422                	ld	s0,8(sp)
 6d4:	0141                	addi	sp,sp,16
 6d6:	8082                	ret

00000000000006d8 <strlen>:

uint strlen(const char *s) {
 6d8:	1141                	addi	sp,sp,-16
 6da:	e422                	sd	s0,8(sp)
 6dc:	0800                	addi	s0,sp,16
    int n;
    for (n = 0; s[n]; n++);
 6de:	00054783          	lbu	a5,0(a0)
 6e2:	cf91                	beqz	a5,6fe <strlen+0x26>
 6e4:	0505                	addi	a0,a0,1
 6e6:	87aa                	mv	a5,a0
 6e8:	4685                	li	a3,1
 6ea:	9e89                	subw	a3,a3,a0
 6ec:	00f6853b          	addw	a0,a3,a5
 6f0:	0785                	addi	a5,a5,1
 6f2:	fff7c703          	lbu	a4,-1(a5)
 6f6:	fb7d                	bnez	a4,6ec <strlen+0x14>
    return n;
}
 6f8:	6422                	ld	s0,8(sp)
 6fa:	0141                	addi	sp,sp,16
 6fc:	8082                	ret
    for (n = 0; s[n]; n++);
 6fe:	4501                	li	a0,0
 700:	bfe5                	j	6f8 <strlen+0x20>

0000000000000702 <strchr>:

char* strchr(const char* s, char c)
{
 702:	1141                	addi	sp,sp,-16
 704:	e422                	sd	s0,8(sp)
 706:	0800                	addi	s0,sp,16
    for (; *s; s++)
 708:	00054783          	lbu	a5,0(a0)
 70c:	cb99                	beqz	a5,722 <strchr+0x20>
        if (*s == c)
 70e:	00f58763          	beq	a1,a5,71c <strchr+0x1a>
    for (; *s; s++)
 712:	0505                	addi	a0,a0,1
 714:	00054783          	lbu	a5,0(a0)
 718:	fbfd                	bnez	a5,70e <strchr+0xc>
            return (char*)s;
    return 0;
 71a:	4501                	li	a0,0
}
 71c:	6422                	ld	s0,8(sp)
 71e:	0141                	addi	sp,sp,16
 720:	8082                	ret
    return 0;
 722:	4501                	li	a0,0
 724:	bfe5                	j	71c <strchr+0x1a>

0000000000000726 <stat>:
//     return buf;
// }

int
stat(const char *s, struct stat *st)
{
 726:	1101                	addi	sp,sp,-32
 728:	ec06                	sd	ra,24(sp)
 72a:	e822                	sd	s0,16(sp)
 72c:	e426                	sd	s1,8(sp)
 72e:	1000                	addi	s0,sp,32
 730:	84ae                	mv	s1,a1
    int fd;
    int r;

    fd = open(s, O_RDONLY);
 732:	4581                	li	a1,0
 734:	00000097          	auipc	ra,0x0
 738:	bde080e7          	jalr	-1058(ra) # 312 <open>
    if(fd < 0)
 73c:	00054c63          	bltz	a0,754 <stat+0x2e>
        return -1;
    r = fstat(fd, st);
 740:	85a6                	mv	a1,s1
 742:	00000097          	auipc	ra,0x0
 746:	bf8080e7          	jalr	-1032(ra) # 33a <fstat>
//    close(fd);
    return r;
}
 74a:	60e2                	ld	ra,24(sp)
 74c:	6442                	ld	s0,16(sp)
 74e:	64a2                	ld	s1,8(sp)
 750:	6105                	addi	sp,sp,32
 752:	8082                	ret
        return -1;
 754:	557d                	li	a0,-1
 756:	bfd5                	j	74a <stat+0x24>

0000000000000758 <atoi>:

int atoi(const char* s)
{
 758:	1141                	addi	sp,sp,-16
 75a:	e422                	sd	s0,8(sp)
 75c:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 75e:	00054603          	lbu	a2,0(a0)
 762:	fd06079b          	addiw	a5,a2,-48
 766:	0ff7f793          	andi	a5,a5,255
 76a:	4725                	li	a4,9
 76c:	02f76963          	bltu	a4,a5,79e <atoi+0x46>
 770:	86aa                	mv	a3,a0
    n = 0;
 772:	4501                	li	a0,0
    while ('0' <= *s && *s <= '9')
 774:	45a5                	li	a1,9
        n = n * 10 + *s++ - '0';
 776:	0685                	addi	a3,a3,1
 778:	0025179b          	slliw	a5,a0,0x2
 77c:	9fa9                	addw	a5,a5,a0
 77e:	0017979b          	slliw	a5,a5,0x1
 782:	9fb1                	addw	a5,a5,a2
 784:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 788:	0006c603          	lbu	a2,0(a3)
 78c:	fd06071b          	addiw	a4,a2,-48
 790:	0ff77713          	andi	a4,a4,255
 794:	fee5f1e3          	bgeu	a1,a4,776 <atoi+0x1e>
    return n;
}
 798:	6422                	ld	s0,8(sp)
 79a:	0141                	addi	sp,sp,16
 79c:	8082                	ret
    n = 0;
 79e:	4501                	li	a0,0
 7a0:	bfe5                	j	798 <atoi+0x40>

00000000000007a2 <memset>:

//memory utils
 void* memset(void* dst, int c, uint n)
 {
 7a2:	1141                	addi	sp,sp,-16
 7a4:	e422                	sd	s0,8(sp)
 7a6:	0800                	addi	s0,sp,16
     char* cdst = (char*)dst;
     int i;
     for (i = 0; i < n; i++) {
 7a8:	ce09                	beqz	a2,7c2 <memset+0x20>
 7aa:	87aa                	mv	a5,a0
 7ac:	fff6071b          	addiw	a4,a2,-1
 7b0:	1702                	slli	a4,a4,0x20
 7b2:	9301                	srli	a4,a4,0x20
 7b4:	0705                	addi	a4,a4,1
 7b6:	972a                	add	a4,a4,a0
         cdst[i] = c;
 7b8:	00b78023          	sb	a1,0(a5)
     for (i = 0; i < n; i++) {
 7bc:	0785                	addi	a5,a5,1
 7be:	fee79de3          	bne	a5,a4,7b8 <memset+0x16>
     }
     return dst;
 }
 7c2:	6422                	ld	s0,8(sp)
 7c4:	0141                	addi	sp,sp,16
 7c6:	8082                	ret

00000000000007c8 <memmove>:

 void* memmove(void* vdst, const void* vsrc, int n)
 {
 7c8:	1141                	addi	sp,sp,-16
 7ca:	e422                	sd	s0,8(sp)
 7cc:	0800                	addi	s0,sp,16
     char* dst;
     const char* src;

     dst = vdst;
     src = vsrc;
     if (src > dst) {
 7ce:	02b57663          	bgeu	a0,a1,7fa <memmove+0x32>
         while (n-- > 0)
 7d2:	02c05163          	blez	a2,7f4 <memmove+0x2c>
 7d6:	fff6079b          	addiw	a5,a2,-1
 7da:	1782                	slli	a5,a5,0x20
 7dc:	9381                	srli	a5,a5,0x20
 7de:	0785                	addi	a5,a5,1
 7e0:	97aa                	add	a5,a5,a0
     dst = vdst;
 7e2:	872a                	mv	a4,a0
             *dst++ = *src++;
 7e4:	0585                	addi	a1,a1,1
 7e6:	0705                	addi	a4,a4,1
 7e8:	fff5c683          	lbu	a3,-1(a1)
 7ec:	fed70fa3          	sb	a3,-1(a4)
         while (n-- > 0)
 7f0:	fee79ae3          	bne	a5,a4,7e4 <memmove+0x1c>
         src += n;
         while (n-- > 0)
             *--dst = *--src;
     }
     return vdst;
 }
 7f4:	6422                	ld	s0,8(sp)
 7f6:	0141                	addi	sp,sp,16
 7f8:	8082                	ret
         dst += n;
 7fa:	00c50733          	add	a4,a0,a2
         src += n;
 7fe:	95b2                	add	a1,a1,a2
         while (n-- > 0)
 800:	fec05ae3          	blez	a2,7f4 <memmove+0x2c>
 804:	fff6079b          	addiw	a5,a2,-1
 808:	1782                	slli	a5,a5,0x20
 80a:	9381                	srli	a5,a5,0x20
 80c:	fff7c793          	not	a5,a5
 810:	97ba                	add	a5,a5,a4
             *--dst = *--src;
 812:	15fd                	addi	a1,a1,-1
 814:	177d                	addi	a4,a4,-1
 816:	0005c683          	lbu	a3,0(a1)
 81a:	00d70023          	sb	a3,0(a4)
         while (n-- > 0)
 81e:	fee79ae3          	bne	a5,a4,812 <memmove+0x4a>
 822:	bfc9                	j	7f4 <memmove+0x2c>

0000000000000824 <memcmp>:

int memcmp(const void* s1, const void* s2, uint n)
{
 824:	1141                	addi	sp,sp,-16
 826:	e422                	sd	s0,8(sp)
 828:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0) {
 82a:	ca05                	beqz	a2,85a <memcmp+0x36>
 82c:	fff6069b          	addiw	a3,a2,-1
 830:	1682                	slli	a3,a3,0x20
 832:	9281                	srli	a3,a3,0x20
 834:	0685                	addi	a3,a3,1
 836:	96aa                	add	a3,a3,a0
        if (*p1 != *p2) {
 838:	00054783          	lbu	a5,0(a0)
 83c:	0005c703          	lbu	a4,0(a1)
 840:	00e79863          	bne	a5,a4,850 <memcmp+0x2c>
            return *p1 - *p2;
        }
        p1++;
 844:	0505                	addi	a0,a0,1
        p2++;
 846:	0585                	addi	a1,a1,1
    while (n-- > 0) {
 848:	fed518e3          	bne	a0,a3,838 <memcmp+0x14>
    }
    return 0;
 84c:	4501                	li	a0,0
 84e:	a019                	j	854 <memcmp+0x30>
            return *p1 - *p2;
 850:	40e7853b          	subw	a0,a5,a4
}
 854:	6422                	ld	s0,8(sp)
 856:	0141                	addi	sp,sp,16
 858:	8082                	ret
    return 0;
 85a:	4501                	li	a0,0
 85c:	bfe5                	j	854 <memcmp+0x30>

000000000000085e <memcpy>:

void* memcpy(void* dst, const void* src, uint n)
{
 85e:	1141                	addi	sp,sp,-16
 860:	e406                	sd	ra,8(sp)
 862:	e022                	sd	s0,0(sp)
 864:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 866:	00000097          	auipc	ra,0x0
 86a:	f62080e7          	jalr	-158(ra) # 7c8 <memmove>
}
 86e:	60a2                	ld	ra,8(sp)
 870:	6402                	ld	s0,0(sp)
 872:	0141                	addi	sp,sp,16
 874:	8082                	ret

0000000000000876 <min>:

//math utils
int min(int a, int b)
{
 876:	1141                	addi	sp,sp,-16
 878:	e422                	sd	s0,8(sp)
 87a:	0800                	addi	s0,sp,16
    return a < b ? a : b;
 87c:	87ae                	mv	a5,a1
 87e:	00b55363          	bge	a0,a1,884 <min+0xe>
 882:	87aa                	mv	a5,a0
}
 884:	0007851b          	sext.w	a0,a5
 888:	6422                	ld	s0,8(sp)
 88a:	0141                	addi	sp,sp,16
 88c:	8082                	ret

000000000000088e <max>:
int max(int a, int b)
{
 88e:	1141                	addi	sp,sp,-16
 890:	e422                	sd	s0,8(sp)
 892:	0800                	addi	s0,sp,16
    return a > b ? a : b;
 894:	87ae                	mv	a5,a1
 896:	00a5d363          	bge	a1,a0,89c <max+0xe>
 89a:	87aa                	mv	a5,a0
}
 89c:	0007851b          	sext.w	a0,a5
 8a0:	6422                	ld	s0,8(sp)
 8a2:	0141                	addi	sp,sp,16
 8a4:	8082                	ret
