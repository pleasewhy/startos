
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "../kernel/fs/fcntl.h"
#include "../kernel/fs/fs.h"
#include "user.h"

char *
fmtname(char *path) {
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
    static char buf[DIRSIZ + 1];
    char *p;

    // Find first character after last slash.
    for (p = path + strlen(path); p >= path && *p != '/'; p--);
  10:	00000097          	auipc	ra,0x0
  14:	6c6080e7          	jalr	1734(ra) # 6d6 <strlen>
  18:	02051793          	slli	a5,a0,0x20
  1c:	9381                	srli	a5,a5,0x20
  1e:	97a6                	add	a5,a5,s1
  20:	02f00693          	li	a3,47
  24:	0097e963          	bltu	a5,s1,36 <fmtname+0x36>
  28:	0007c703          	lbu	a4,0(a5)
  2c:	00d70563          	beq	a4,a3,36 <fmtname+0x36>
  30:	17fd                	addi	a5,a5,-1
  32:	fe97fbe3          	bgeu	a5,s1,28 <fmtname+0x28>
    p++;
  36:	00178493          	addi	s1,a5,1

    // Return blank-padded name.
    if (strlen(p) >= DIRSIZ)
  3a:	8526                	mv	a0,s1
  3c:	00000097          	auipc	ra,0x0
  40:	69a080e7          	jalr	1690(ra) # 6d6 <strlen>
  44:	2501                	sext.w	a0,a0
  46:	47b5                	li	a5,13
  48:	00a7fa63          	bgeu	a5,a0,5c <fmtname+0x5c>
        return p;
    memmove(buf, p, strlen(p));
    memset(buf + strlen(p), ' ', DIRSIZ - strlen(p));
    return buf;
}
  4c:	8526                	mv	a0,s1
  4e:	70a2                	ld	ra,40(sp)
  50:	7402                	ld	s0,32(sp)
  52:	64e2                	ld	s1,24(sp)
  54:	6942                	ld	s2,16(sp)
  56:	69a2                	ld	s3,8(sp)
  58:	6145                	addi	sp,sp,48
  5a:	8082                	ret
    memmove(buf, p, strlen(p));
  5c:	8526                	mv	a0,s1
  5e:	00000097          	auipc	ra,0x0
  62:	678080e7          	jalr	1656(ra) # 6d6 <strlen>
  66:	00001997          	auipc	s3,0x1
  6a:	8fa98993          	addi	s3,s3,-1798 # 960 <buf.1083>
  6e:	0005061b          	sext.w	a2,a0
  72:	85a6                	mv	a1,s1
  74:	854e                	mv	a0,s3
  76:	00000097          	auipc	ra,0x0
  7a:	750080e7          	jalr	1872(ra) # 7c6 <memmove>
    memset(buf + strlen(p), ' ', DIRSIZ - strlen(p));
  7e:	8526                	mv	a0,s1
  80:	00000097          	auipc	ra,0x0
  84:	656080e7          	jalr	1622(ra) # 6d6 <strlen>
  88:	0005091b          	sext.w	s2,a0
  8c:	8526                	mv	a0,s1
  8e:	00000097          	auipc	ra,0x0
  92:	648080e7          	jalr	1608(ra) # 6d6 <strlen>
  96:	1902                	slli	s2,s2,0x20
  98:	02095913          	srli	s2,s2,0x20
  9c:	4639                	li	a2,14
  9e:	9e09                	subw	a2,a2,a0
  a0:	02000593          	li	a1,32
  a4:	01298533          	add	a0,s3,s2
  a8:	00000097          	auipc	ra,0x0
  ac:	6f8080e7          	jalr	1784(ra) # 7a0 <memset>
    return buf;
  b0:	84ce                	mv	s1,s3
  b2:	bf69                	j	4c <fmtname+0x4c>

00000000000000b4 <filetype>:

char *
filetype(int type) {
  b4:	1141                	addi	sp,sp,-16
  b6:	e422                	sd	s0,8(sp)
  b8:	0800                	addi	s0,sp,16
    if (type == T_FILE) {
  ba:	4709                	li	a4,2
  bc:	02e50163          	beq	a0,a4,de <filetype+0x2a>
  c0:	87aa                	mv	a5,a0
        return "File";
    } else if (type == T_DIR) {
  c2:	4705                	li	a4,1
        return "Dir ";
  c4:	00000517          	auipc	a0,0x0
  c8:	7ec50513          	addi	a0,a0,2028 # 8b0 <max+0x24>
    } else if (type == T_DIR) {
  cc:	00e78663          	beq	a5,a4,d8 <filetype+0x24>
    } else {
        return "Dev ";
  d0:	00000517          	auipc	a0,0x0
  d4:	7e850513          	addi	a0,a0,2024 # 8b8 <max+0x2c>
    }
}
  d8:	6422                	ld	s0,8(sp)
  da:	0141                	addi	sp,sp,16
  dc:	8082                	ret
        return "File";
  de:	00000517          	auipc	a0,0x0
  e2:	7ca50513          	addi	a0,a0,1994 # 8a8 <max+0x1c>
  e6:	bfcd                	j	d8 <filetype+0x24>

00000000000000e8 <ls>:


void ls(char *path) {
  e8:	d9010113          	addi	sp,sp,-624
  ec:	26113423          	sd	ra,616(sp)
  f0:	26813023          	sd	s0,608(sp)
  f4:	24913c23          	sd	s1,600(sp)
  f8:	25213823          	sd	s2,592(sp)
  fc:	25313423          	sd	s3,584(sp)
 100:	25413023          	sd	s4,576(sp)
 104:	23513c23          	sd	s5,568(sp)
 108:	23613823          	sd	s6,560(sp)
 10c:	1c80                	addi	s0,sp,624
 10e:	892a                	mv	s2,a0
    char prefix[512];
    char *p;
    struct direntry entry;


    if ((fd = open(path, O_RDONLY)) < 0) {
 110:	4581                	li	a1,0
 112:	00000097          	auipc	ra,0x0
 116:	1fe080e7          	jalr	510(ra) # 310 <open>
 11a:	04054f63          	bltz	a0,178 <ls+0x90>
 11e:	84aa                	mv	s1,a0
        printf("ls: can't open %s\n", path);
        return;
    }

    if (fstat(fd, &st) < 0) {
 120:	fa840593          	addi	a1,s0,-88
 124:	00000097          	auipc	ra,0x0
 128:	214080e7          	jalr	532(ra) # 338 <fstat>
 12c:	08054263          	bltz	a0,1b0 <ls+0xc8>
        printf("ls: cant't stat %s\n", path);
        return;
    }
    switch (st.type) {
 130:	fb041783          	lh	a5,-80(s0)
 134:	0007869b          	sext.w	a3,a5
 138:	4705                	li	a4,1
 13a:	08e68563          	beq	a3,a4,1c4 <ls+0xdc>
 13e:	4709                	li	a4,2
 140:	04e69563          	bne	a3,a4,18a <ls+0xa2>
        case T_FILE:
            printf("%s %d %l\n", fmtname(prefix), filetype(st.type), st.size);
 144:	da840513          	addi	a0,s0,-600
 148:	00000097          	auipc	ra,0x0
 14c:	eb8080e7          	jalr	-328(ra) # 0 <fmtname>
 150:	84aa                	mv	s1,a0
 152:	fb041503          	lh	a0,-80(s0)
 156:	00000097          	auipc	ra,0x0
 15a:	f5e080e7          	jalr	-162(ra) # b4 <filetype>
 15e:	862a                	mv	a2,a0
 160:	fb843683          	ld	a3,-72(s0)
 164:	85a6                	mv	a1,s1
 166:	00000517          	auipc	a0,0x0
 16a:	78a50513          	addi	a0,a0,1930 # 8f0 <max+0x64>
 16e:	00000097          	auipc	ra,0x0
 172:	4ac080e7          	jalr	1196(ra) # 61a <printf>
            break;
 176:	a811                	j	18a <ls+0xa2>
        printf("ls: can't open %s\n", path);
 178:	85ca                	mv	a1,s2
 17a:	00000517          	auipc	a0,0x0
 17e:	74650513          	addi	a0,a0,1862 # 8c0 <max+0x34>
 182:	00000097          	auipc	ra,0x0
 186:	498080e7          	jalr	1176(ra) # 61a <printf>
                }
                printf("%s %s %l\n", fmtname(prefix), filetype(st.type), st.size);
            }
            break;
    }
}
 18a:	26813083          	ld	ra,616(sp)
 18e:	26013403          	ld	s0,608(sp)
 192:	25813483          	ld	s1,600(sp)
 196:	25013903          	ld	s2,592(sp)
 19a:	24813983          	ld	s3,584(sp)
 19e:	24013a03          	ld	s4,576(sp)
 1a2:	23813a83          	ld	s5,568(sp)
 1a6:	23013b03          	ld	s6,560(sp)
 1aa:	27010113          	addi	sp,sp,624
 1ae:	8082                	ret
        printf("ls: cant't stat %s\n", path);
 1b0:	85ca                	mv	a1,s2
 1b2:	00000517          	auipc	a0,0x0
 1b6:	72650513          	addi	a0,a0,1830 # 8d8 <max+0x4c>
 1ba:	00000097          	auipc	ra,0x0
 1be:	460080e7          	jalr	1120(ra) # 61a <printf>
        return;
 1c2:	b7e1                	j	18a <ls+0xa2>
            strcpy(prefix, path);
 1c4:	85ca                	mv	a1,s2
 1c6:	da840513          	addi	a0,s0,-600
 1ca:	00000097          	auipc	ra,0x0
 1ce:	4c4080e7          	jalr	1220(ra) # 68e <strcpy>
            p = prefix + strlen(prefix);
 1d2:	da840513          	addi	a0,s0,-600
 1d6:	00000097          	auipc	ra,0x0
 1da:	500080e7          	jalr	1280(ra) # 6d6 <strlen>
 1de:	02051993          	slli	s3,a0,0x20
 1e2:	0209d993          	srli	s3,s3,0x20
 1e6:	da840793          	addi	a5,s0,-600
 1ea:	99be                	add	s3,s3,a5
            *p++ = '/';
 1ec:	00198a13          	addi	s4,s3,1
 1f0:	02f00793          	li	a5,47
 1f4:	00f98023          	sb	a5,0(s3)
                printf("%s %s %l\n", fmtname(prefix), filetype(st.type), st.size);
 1f8:	00000a97          	auipc	s5,0x0
 1fc:	718a8a93          	addi	s5,s5,1816 # 910 <max+0x84>
                    printf("can't stat %s\n", prefix);
 200:	00000b17          	auipc	s6,0x0
 204:	700b0b13          	addi	s6,s6,1792 # 900 <max+0x74>
            while (read(fd, &entry, sizeof(entry)) == sizeof(entry)) {
 208:	a03d                	j	236 <ls+0x14e>
                printf("%s %s %l\n", fmtname(prefix), filetype(st.type), st.size);
 20a:	da840513          	addi	a0,s0,-600
 20e:	00000097          	auipc	ra,0x0
 212:	df2080e7          	jalr	-526(ra) # 0 <fmtname>
 216:	892a                	mv	s2,a0
 218:	fb041503          	lh	a0,-80(s0)
 21c:	00000097          	auipc	ra,0x0
 220:	e98080e7          	jalr	-360(ra) # b4 <filetype>
 224:	862a                	mv	a2,a0
 226:	fb843683          	ld	a3,-72(s0)
 22a:	85ca                	mv	a1,s2
 22c:	8556                	mv	a0,s5
 22e:	00000097          	auipc	ra,0x0
 232:	3ec080e7          	jalr	1004(ra) # 61a <printf>
            while (read(fd, &entry, sizeof(entry)) == sizeof(entry)) {
 236:	4641                	li	a2,16
 238:	d9840593          	addi	a1,s0,-616
 23c:	8526                	mv	a0,s1
 23e:	00000097          	auipc	ra,0x0
 242:	0aa080e7          	jalr	170(ra) # 2e8 <read>
 246:	47c1                	li	a5,16
 248:	f4f511e3          	bne	a0,a5,18a <ls+0xa2>
                memmove(p, entry.name, DIRSIZ);
 24c:	4639                	li	a2,14
 24e:	d9a40593          	addi	a1,s0,-614
 252:	8552                	mv	a0,s4
 254:	00000097          	auipc	ra,0x0
 258:	572080e7          	jalr	1394(ra) # 7c6 <memmove>
                p[DIRSIZ] = 0;
 25c:	000987a3          	sb	zero,15(s3)
                if (stat(prefix, &st) < 0) {
 260:	fa840593          	addi	a1,s0,-88
 264:	da840513          	addi	a0,s0,-600
 268:	00000097          	auipc	ra,0x0
 26c:	4bc080e7          	jalr	1212(ra) # 724 <stat>
 270:	f8055de3          	bgez	a0,20a <ls+0x122>
                    printf("can't stat %s\n", prefix);
 274:	da840593          	addi	a1,s0,-600
 278:	855a                	mv	a0,s6
 27a:	00000097          	auipc	ra,0x0
 27e:	3a0080e7          	jalr	928(ra) # 61a <printf>
                    continue;
 282:	bf55                	j	236 <ls+0x14e>

0000000000000284 <main>:

void main(int argc, char *argv[]) {
 284:	1141                	addi	sp,sp,-16
 286:	e406                	sd	ra,8(sp)
 288:	e022                	sd	s0,0(sp)
 28a:	0800                	addi	s0,sp,16
    if (argc < 2)
 28c:	4785                	li	a5,1
 28e:	02a7d663          	bge	a5,a0,2ba <main+0x36>
        ls(".");
    else if (argc > 2)
 292:	4789                	li	a5,2
 294:	02a7dc63          	bge	a5,a0,2cc <main+0x48>
        printf("too many argument\n");
 298:	00000517          	auipc	a0,0x0
 29c:	69050513          	addi	a0,a0,1680 # 928 <max+0x9c>
 2a0:	00000097          	auipc	ra,0x0
 2a4:	37a080e7          	jalr	890(ra) # 61a <printf>
    else
        ls(argv[1]);

    exit(0);
 2a8:	4501                	li	a0,0
 2aa:	00000097          	auipc	ra,0x0
 2ae:	056080e7          	jalr	86(ra) # 300 <exit>
}
 2b2:	60a2                	ld	ra,8(sp)
 2b4:	6402                	ld	s0,0(sp)
 2b6:	0141                	addi	sp,sp,16
 2b8:	8082                	ret
        ls(".");
 2ba:	00000517          	auipc	a0,0x0
 2be:	66650513          	addi	a0,a0,1638 # 920 <max+0x94>
 2c2:	00000097          	auipc	ra,0x0
 2c6:	e26080e7          	jalr	-474(ra) # e8 <ls>
 2ca:	bff9                	j	2a8 <main+0x24>
        ls(argv[1]);
 2cc:	6588                	ld	a0,8(a1)
 2ce:	00000097          	auipc	ra,0x0
 2d2:	e1a080e7          	jalr	-486(ra) # e8 <ls>
 2d6:	bfc9                	j	2a8 <main+0x24>

00000000000002d8 <putchar>:
# generated by usys.pl - do not edit
#include "kernel/trap/syscall.h"
.global putchar
putchar:
 li a7, SYS_putchar
 2d8:	4885                	li	a7,1
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2e0:	4889                	li	a7,2
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <read>:
.global read
read:
 li a7, SYS_read
 2e8:	4899                	li	a7,6
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <write>:
.global write
write:
 li a7, SYS_write
 2f0:	489d                	li	a7,7
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <fork>:
.global fork
fork:
 li a7, SYS_fork
 2f8:	4891                	li	a7,4
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <exit>:
.global exit
exit:
 li a7, SYS_exit
 300:	488d                	li	a7,3
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <wait>:
.global wait
wait:
 li a7, SYS_wait
 308:	4895                	li	a7,5
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <open>:
.global open
open:
 li a7, SYS_open
 310:	48a1                	li	a7,8
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 318:	48a9                	li	a7,10
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 320:	48a5                	li	a7,9
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 328:	48ad                	li	a7,11
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <dup>:
.global dup
dup:
 li a7, SYS_dup
 330:	48b1                	li	a7,12
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 338:	48b5                	li	a7,13
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <putc>:
#include <stdarg.h>

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c) {
 340:	1101                	addi	sp,sp,-32
 342:	ec06                	sd	ra,24(sp)
 344:	e822                	sd	s0,16(sp)
 346:	1000                	addi	s0,sp,32
 348:	feb407a3          	sb	a1,-17(s0)
    write(0, &c, 1);
 34c:	4605                	li	a2,1
 34e:	fef40593          	addi	a1,s0,-17
 352:	4501                	li	a0,0
 354:	00000097          	auipc	ra,0x0
 358:	f9c080e7          	jalr	-100(ra) # 2f0 <write>
}
 35c:	60e2                	ld	ra,24(sp)
 35e:	6442                	ld	s0,16(sp)
 360:	6105                	addi	sp,sp,32
 362:	8082                	ret

0000000000000364 <printint>:

static void
printint(int fd, int xx, int base, int sgn) {
 364:	7139                	addi	sp,sp,-64
 366:	fc06                	sd	ra,56(sp)
 368:	f822                	sd	s0,48(sp)
 36a:	f426                	sd	s1,40(sp)
 36c:	f04a                	sd	s2,32(sp)
 36e:	ec4e                	sd	s3,24(sp)
 370:	0080                	addi	s0,sp,64
 372:	84aa                	mv	s1,a0
    char buf[16];
    int i, neg;
    uint x;

    neg = 0;
    if (sgn && xx < 0) {
 374:	c299                	beqz	a3,37a <printint+0x16>
 376:	0805c863          	bltz	a1,406 <printint+0xa2>
        neg = 1;
        x = -xx;
    } else {
        x = xx;
 37a:	2581                	sext.w	a1,a1
    neg = 0;
 37c:	4881                	li	a7,0
 37e:	fc040693          	addi	a3,s0,-64
    }

    i = 0;
 382:	4701                	li	a4,0
    do {
        buf[i++] = digits[x % base];
 384:	2601                	sext.w	a2,a2
 386:	00000517          	auipc	a0,0x0
 38a:	5c250513          	addi	a0,a0,1474 # 948 <digits>
 38e:	883a                	mv	a6,a4
 390:	2705                	addiw	a4,a4,1
 392:	02c5f7bb          	remuw	a5,a1,a2
 396:	1782                	slli	a5,a5,0x20
 398:	9381                	srli	a5,a5,0x20
 39a:	97aa                	add	a5,a5,a0
 39c:	0007c783          	lbu	a5,0(a5)
 3a0:	00f68023          	sb	a5,0(a3)
    } while ((x /= base) != 0);
 3a4:	0005879b          	sext.w	a5,a1
 3a8:	02c5d5bb          	divuw	a1,a1,a2
 3ac:	0685                	addi	a3,a3,1
 3ae:	fec7f0e3          	bgeu	a5,a2,38e <printint+0x2a>
    if (neg)
 3b2:	00088b63          	beqz	a7,3c8 <printint+0x64>
        buf[i++] = '-';
 3b6:	fd040793          	addi	a5,s0,-48
 3ba:	973e                	add	a4,a4,a5
 3bc:	02d00793          	li	a5,45
 3c0:	fef70823          	sb	a5,-16(a4)
 3c4:	0028071b          	addiw	a4,a6,2

    while (--i >= 0)
 3c8:	02e05863          	blez	a4,3f8 <printint+0x94>
 3cc:	fc040793          	addi	a5,s0,-64
 3d0:	00e78933          	add	s2,a5,a4
 3d4:	fff78993          	addi	s3,a5,-1
 3d8:	99ba                	add	s3,s3,a4
 3da:	377d                	addiw	a4,a4,-1
 3dc:	1702                	slli	a4,a4,0x20
 3de:	9301                	srli	a4,a4,0x20
 3e0:	40e989b3          	sub	s3,s3,a4
        putc(fd, buf[i]);
 3e4:	fff94583          	lbu	a1,-1(s2)
 3e8:	8526                	mv	a0,s1
 3ea:	00000097          	auipc	ra,0x0
 3ee:	f56080e7          	jalr	-170(ra) # 340 <putc>
    while (--i >= 0)
 3f2:	197d                	addi	s2,s2,-1
 3f4:	ff3918e3          	bne	s2,s3,3e4 <printint+0x80>
}
 3f8:	70e2                	ld	ra,56(sp)
 3fa:	7442                	ld	s0,48(sp)
 3fc:	74a2                	ld	s1,40(sp)
 3fe:	7902                	ld	s2,32(sp)
 400:	69e2                	ld	s3,24(sp)
 402:	6121                	addi	sp,sp,64
 404:	8082                	ret
        x = -xx;
 406:	40b005bb          	negw	a1,a1
        neg = 1;
 40a:	4885                	li	a7,1
        x = -xx;
 40c:	bf8d                	j	37e <printint+0x1a>

000000000000040e <vprintf>:
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap) {
 40e:	7119                	addi	sp,sp,-128
 410:	fc86                	sd	ra,120(sp)
 412:	f8a2                	sd	s0,112(sp)
 414:	f4a6                	sd	s1,104(sp)
 416:	f0ca                	sd	s2,96(sp)
 418:	ecce                	sd	s3,88(sp)
 41a:	e8d2                	sd	s4,80(sp)
 41c:	e4d6                	sd	s5,72(sp)
 41e:	e0da                	sd	s6,64(sp)
 420:	fc5e                	sd	s7,56(sp)
 422:	f862                	sd	s8,48(sp)
 424:	f466                	sd	s9,40(sp)
 426:	f06a                	sd	s10,32(sp)
 428:	ec6e                	sd	s11,24(sp)
 42a:	0100                	addi	s0,sp,128
    char *s;
    int c, i, state;

    state = 0;
    for (i = 0; fmt[i]; i++) {
 42c:	0005c903          	lbu	s2,0(a1)
 430:	18090f63          	beqz	s2,5ce <vprintf+0x1c0>
 434:	8aaa                	mv	s5,a0
 436:	8b32                	mv	s6,a2
 438:	00158493          	addi	s1,a1,1
    state = 0;
 43c:	4981                	li	s3,0
            if (c == '%') {
                state = '%';
            } else {
                putc(fd, c);
            }
        } else if (state == '%') {
 43e:	02500a13          	li	s4,37
            if (c == 'd') {
 442:	06400c13          	li	s8,100
                printint(fd, va_arg(ap, int), 10, 1);
            } else if (c == 'l') {
 446:	06c00c93          	li	s9,108
                printint(fd, va_arg(ap, uint64), 10, 0);
            } else if (c == 'x') {
 44a:	07800d13          	li	s10,120
                printint(fd, va_arg(ap, int), 16, 0);
            } else if (c == 'p') {
 44e:	07000d93          	li	s11,112
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 452:	00000b97          	auipc	s7,0x0
 456:	4f6b8b93          	addi	s7,s7,1270 # 948 <digits>
 45a:	a839                	j	478 <vprintf+0x6a>
                putc(fd, c);
 45c:	85ca                	mv	a1,s2
 45e:	8556                	mv	a0,s5
 460:	00000097          	auipc	ra,0x0
 464:	ee0080e7          	jalr	-288(ra) # 340 <putc>
 468:	a019                	j	46e <vprintf+0x60>
        } else if (state == '%') {
 46a:	01498f63          	beq	s3,s4,488 <vprintf+0x7a>
    for (i = 0; fmt[i]; i++) {
 46e:	0485                	addi	s1,s1,1
 470:	fff4c903          	lbu	s2,-1(s1)
 474:	14090d63          	beqz	s2,5ce <vprintf+0x1c0>
        c = fmt[i] & 0xff;
 478:	0009079b          	sext.w	a5,s2
        if (state == 0) {
 47c:	fe0997e3          	bnez	s3,46a <vprintf+0x5c>
            if (c == '%') {
 480:	fd479ee3          	bne	a5,s4,45c <vprintf+0x4e>
                state = '%';
 484:	89be                	mv	s3,a5
 486:	b7e5                	j	46e <vprintf+0x60>
            if (c == 'd') {
 488:	05878063          	beq	a5,s8,4c8 <vprintf+0xba>
            } else if (c == 'l') {
 48c:	05978c63          	beq	a5,s9,4e4 <vprintf+0xd6>
            } else if (c == 'x') {
 490:	07a78863          	beq	a5,s10,500 <vprintf+0xf2>
            } else if (c == 'p') {
 494:	09b78463          	beq	a5,s11,51c <vprintf+0x10e>
                printptr(fd, va_arg(ap, uint64));
            } else if (c == 's') {
 498:	07300713          	li	a4,115
 49c:	0ce78663          	beq	a5,a4,568 <vprintf+0x15a>
                    s = "(null)";
                while (*s != 0) {
                    putc(fd, *s);
                    s++;
                }
            } else if (c == 'c') {
 4a0:	06300713          	li	a4,99
 4a4:	0ee78e63          	beq	a5,a4,5a0 <vprintf+0x192>
                putc(fd, va_arg(ap, uint));
            } else if (c == '%') {
 4a8:	11478863          	beq	a5,s4,5b8 <vprintf+0x1aa>
                putc(fd, c);
            } else {
                // Unknown % sequence.  Print it to draw attention.
                putc(fd, '%');
 4ac:	85d2                	mv	a1,s4
 4ae:	8556                	mv	a0,s5
 4b0:	00000097          	auipc	ra,0x0
 4b4:	e90080e7          	jalr	-368(ra) # 340 <putc>
                putc(fd, c);
 4b8:	85ca                	mv	a1,s2
 4ba:	8556                	mv	a0,s5
 4bc:	00000097          	auipc	ra,0x0
 4c0:	e84080e7          	jalr	-380(ra) # 340 <putc>
            }
            state = 0;
 4c4:	4981                	li	s3,0
 4c6:	b765                	j	46e <vprintf+0x60>
                printint(fd, va_arg(ap, int), 10, 1);
 4c8:	008b0913          	addi	s2,s6,8
 4cc:	4685                	li	a3,1
 4ce:	4629                	li	a2,10
 4d0:	000b2583          	lw	a1,0(s6)
 4d4:	8556                	mv	a0,s5
 4d6:	00000097          	auipc	ra,0x0
 4da:	e8e080e7          	jalr	-370(ra) # 364 <printint>
 4de:	8b4a                	mv	s6,s2
            state = 0;
 4e0:	4981                	li	s3,0
 4e2:	b771                	j	46e <vprintf+0x60>
                printint(fd, va_arg(ap, uint64), 10, 0);
 4e4:	008b0913          	addi	s2,s6,8
 4e8:	4681                	li	a3,0
 4ea:	4629                	li	a2,10
 4ec:	000b2583          	lw	a1,0(s6)
 4f0:	8556                	mv	a0,s5
 4f2:	00000097          	auipc	ra,0x0
 4f6:	e72080e7          	jalr	-398(ra) # 364 <printint>
 4fa:	8b4a                	mv	s6,s2
            state = 0;
 4fc:	4981                	li	s3,0
 4fe:	bf85                	j	46e <vprintf+0x60>
                printint(fd, va_arg(ap, int), 16, 0);
 500:	008b0913          	addi	s2,s6,8
 504:	4681                	li	a3,0
 506:	4641                	li	a2,16
 508:	000b2583          	lw	a1,0(s6)
 50c:	8556                	mv	a0,s5
 50e:	00000097          	auipc	ra,0x0
 512:	e56080e7          	jalr	-426(ra) # 364 <printint>
 516:	8b4a                	mv	s6,s2
            state = 0;
 518:	4981                	li	s3,0
 51a:	bf91                	j	46e <vprintf+0x60>
                printptr(fd, va_arg(ap, uint64));
 51c:	008b0793          	addi	a5,s6,8
 520:	f8f43423          	sd	a5,-120(s0)
 524:	000b3983          	ld	s3,0(s6)
    putc(fd, '0');
 528:	03000593          	li	a1,48
 52c:	8556                	mv	a0,s5
 52e:	00000097          	auipc	ra,0x0
 532:	e12080e7          	jalr	-494(ra) # 340 <putc>
    putc(fd, 'x');
 536:	85ea                	mv	a1,s10
 538:	8556                	mv	a0,s5
 53a:	00000097          	auipc	ra,0x0
 53e:	e06080e7          	jalr	-506(ra) # 340 <putc>
 542:	4941                	li	s2,16
        putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 544:	03c9d793          	srli	a5,s3,0x3c
 548:	97de                	add	a5,a5,s7
 54a:	0007c583          	lbu	a1,0(a5)
 54e:	8556                	mv	a0,s5
 550:	00000097          	auipc	ra,0x0
 554:	df0080e7          	jalr	-528(ra) # 340 <putc>
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 558:	0992                	slli	s3,s3,0x4
 55a:	397d                	addiw	s2,s2,-1
 55c:	fe0914e3          	bnez	s2,544 <vprintf+0x136>
                printptr(fd, va_arg(ap, uint64));
 560:	f8843b03          	ld	s6,-120(s0)
            state = 0;
 564:	4981                	li	s3,0
 566:	b721                	j	46e <vprintf+0x60>
                s = va_arg(ap, char*);
 568:	008b0993          	addi	s3,s6,8
 56c:	000b3903          	ld	s2,0(s6)
                if (s == 0)
 570:	02090163          	beqz	s2,592 <vprintf+0x184>
                while (*s != 0) {
 574:	00094583          	lbu	a1,0(s2)
 578:	c9a1                	beqz	a1,5c8 <vprintf+0x1ba>
                    putc(fd, *s);
 57a:	8556                	mv	a0,s5
 57c:	00000097          	auipc	ra,0x0
 580:	dc4080e7          	jalr	-572(ra) # 340 <putc>
                    s++;
 584:	0905                	addi	s2,s2,1
                while (*s != 0) {
 586:	00094583          	lbu	a1,0(s2)
 58a:	f9e5                	bnez	a1,57a <vprintf+0x16c>
                s = va_arg(ap, char*);
 58c:	8b4e                	mv	s6,s3
            state = 0;
 58e:	4981                	li	s3,0
 590:	bdf9                	j	46e <vprintf+0x60>
                    s = "(null)";
 592:	00000917          	auipc	s2,0x0
 596:	3ae90913          	addi	s2,s2,942 # 940 <max+0xb4>
                while (*s != 0) {
 59a:	02800593          	li	a1,40
 59e:	bff1                	j	57a <vprintf+0x16c>
                putc(fd, va_arg(ap, uint));
 5a0:	008b0913          	addi	s2,s6,8
 5a4:	000b4583          	lbu	a1,0(s6)
 5a8:	8556                	mv	a0,s5
 5aa:	00000097          	auipc	ra,0x0
 5ae:	d96080e7          	jalr	-618(ra) # 340 <putc>
 5b2:	8b4a                	mv	s6,s2
            state = 0;
 5b4:	4981                	li	s3,0
 5b6:	bd65                	j	46e <vprintf+0x60>
                putc(fd, c);
 5b8:	85d2                	mv	a1,s4
 5ba:	8556                	mv	a0,s5
 5bc:	00000097          	auipc	ra,0x0
 5c0:	d84080e7          	jalr	-636(ra) # 340 <putc>
            state = 0;
 5c4:	4981                	li	s3,0
 5c6:	b565                	j	46e <vprintf+0x60>
                s = va_arg(ap, char*);
 5c8:	8b4e                	mv	s6,s3
            state = 0;
 5ca:	4981                	li	s3,0
 5cc:	b54d                	j	46e <vprintf+0x60>
        }
    }
}
 5ce:	70e6                	ld	ra,120(sp)
 5d0:	7446                	ld	s0,112(sp)
 5d2:	74a6                	ld	s1,104(sp)
 5d4:	7906                	ld	s2,96(sp)
 5d6:	69e6                	ld	s3,88(sp)
 5d8:	6a46                	ld	s4,80(sp)
 5da:	6aa6                	ld	s5,72(sp)
 5dc:	6b06                	ld	s6,64(sp)
 5de:	7be2                	ld	s7,56(sp)
 5e0:	7c42                	ld	s8,48(sp)
 5e2:	7ca2                	ld	s9,40(sp)
 5e4:	7d02                	ld	s10,32(sp)
 5e6:	6de2                	ld	s11,24(sp)
 5e8:	6109                	addi	sp,sp,128
 5ea:	8082                	ret

00000000000005ec <fprintf>:

void
fprintf(int fd, const char *fmt, ...) {
 5ec:	715d                	addi	sp,sp,-80
 5ee:	ec06                	sd	ra,24(sp)
 5f0:	e822                	sd	s0,16(sp)
 5f2:	1000                	addi	s0,sp,32
 5f4:	e010                	sd	a2,0(s0)
 5f6:	e414                	sd	a3,8(s0)
 5f8:	e818                	sd	a4,16(s0)
 5fa:	ec1c                	sd	a5,24(s0)
 5fc:	03043023          	sd	a6,32(s0)
 600:	03143423          	sd	a7,40(s0)
    va_list ap;

    va_start(ap, fmt);
 604:	fe843423          	sd	s0,-24(s0)
    vprintf(fd, fmt, ap);
 608:	8622                	mv	a2,s0
 60a:	00000097          	auipc	ra,0x0
 60e:	e04080e7          	jalr	-508(ra) # 40e <vprintf>
}
 612:	60e2                	ld	ra,24(sp)
 614:	6442                	ld	s0,16(sp)
 616:	6161                	addi	sp,sp,80
 618:	8082                	ret

000000000000061a <printf>:

void
printf(const char *fmt, ...) {
 61a:	711d                	addi	sp,sp,-96
 61c:	ec06                	sd	ra,24(sp)
 61e:	e822                	sd	s0,16(sp)
 620:	1000                	addi	s0,sp,32
 622:	e40c                	sd	a1,8(s0)
 624:	e810                	sd	a2,16(s0)
 626:	ec14                	sd	a3,24(s0)
 628:	f018                	sd	a4,32(s0)
 62a:	f41c                	sd	a5,40(s0)
 62c:	03043823          	sd	a6,48(s0)
 630:	03143c23          	sd	a7,56(s0)
    va_list ap;

    va_start(ap, fmt);
 634:	00840613          	addi	a2,s0,8
 638:	fec43423          	sd	a2,-24(s0)
    vprintf(1, fmt, ap);
 63c:	85aa                	mv	a1,a0
 63e:	4505                	li	a0,1
 640:	00000097          	auipc	ra,0x0
 644:	dce080e7          	jalr	-562(ra) # 40e <vprintf>
}
 648:	60e2                	ld	ra,24(sp)
 64a:	6442                	ld	s0,16(sp)
 64c:	6125                	addi	sp,sp,96
 64e:	8082                	ret

0000000000000650 <strncpy>:
#include "../kernel/types.h"
#include "../kernel/fs/fcntl.h"
#include "user.h"
//string utils
char * strncpy(char *s, const char *t, int n) {
 650:	1141                	addi	sp,sp,-16
 652:	e422                	sd	s0,8(sp)
 654:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while (n-- > 0 && (*s++ = *t++) != 0);
 656:	872a                	mv	a4,a0
 658:	8832                	mv	a6,a2
 65a:	367d                	addiw	a2,a2,-1
 65c:	01005963          	blez	a6,66e <strncpy+0x1e>
 660:	0705                	addi	a4,a4,1
 662:	0005c783          	lbu	a5,0(a1)
 666:	fef70fa3          	sb	a5,-1(a4)
 66a:	0585                	addi	a1,a1,1
 66c:	f7f5                	bnez	a5,658 <strncpy+0x8>
    while (n-- > 0)
 66e:	00c05d63          	blez	a2,688 <strncpy+0x38>
 672:	86ba                	mv	a3,a4
        *s++ = 0;
 674:	0685                	addi	a3,a3,1
 676:	fe068fa3          	sb	zero,-1(a3)
    while (n-- > 0)
 67a:	fff6c793          	not	a5,a3
 67e:	9fb9                	addw	a5,a5,a4
 680:	010787bb          	addw	a5,a5,a6
 684:	fef048e3          	bgtz	a5,674 <strncpy+0x24>
    return os;
}
 688:	6422                	ld	s0,8(sp)
 68a:	0141                	addi	sp,sp,16
 68c:	8082                	ret

000000000000068e <strcpy>:

char* strcpy(char* s, const char* t)
{
 68e:	1141                	addi	sp,sp,-16
 690:	e422                	sd	s0,8(sp)
 692:	0800                	addi	s0,sp,16
    char* os;
    os = s;
    while ((*s++ = *t++) != 0)
 694:	87aa                	mv	a5,a0
 696:	0585                	addi	a1,a1,1
 698:	0785                	addi	a5,a5,1
 69a:	fff5c703          	lbu	a4,-1(a1)
 69e:	fee78fa3          	sb	a4,-1(a5)
 6a2:	fb75                	bnez	a4,696 <strcpy+0x8>
        ;
    return os;
}
 6a4:	6422                	ld	s0,8(sp)
 6a6:	0141                	addi	sp,sp,16
 6a8:	8082                	ret

00000000000006aa <strcmp>:

int strcmp(const char* p, const char* q)
{
 6aa:	1141                	addi	sp,sp,-16
 6ac:	e422                	sd	s0,8(sp)
 6ae:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 6b0:	00054783          	lbu	a5,0(a0)
 6b4:	cb91                	beqz	a5,6c8 <strcmp+0x1e>
 6b6:	0005c703          	lbu	a4,0(a1)
 6ba:	00f71763          	bne	a4,a5,6c8 <strcmp+0x1e>
        p++, q++;
 6be:	0505                	addi	a0,a0,1
 6c0:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 6c2:	00054783          	lbu	a5,0(a0)
 6c6:	fbe5                	bnez	a5,6b6 <strcmp+0xc>
    return (uchar)*p - (uchar)*q;
 6c8:	0005c503          	lbu	a0,0(a1)
}
 6cc:	40a7853b          	subw	a0,a5,a0
 6d0:	6422                	ld	s0,8(sp)
 6d2:	0141                	addi	sp,sp,16
 6d4:	8082                	ret

00000000000006d6 <strlen>:

uint strlen(const char *s) {
 6d6:	1141                	addi	sp,sp,-16
 6d8:	e422                	sd	s0,8(sp)
 6da:	0800                	addi	s0,sp,16
    int n;
    for (n = 0; s[n]; n++);
 6dc:	00054783          	lbu	a5,0(a0)
 6e0:	cf91                	beqz	a5,6fc <strlen+0x26>
 6e2:	0505                	addi	a0,a0,1
 6e4:	87aa                	mv	a5,a0
 6e6:	4685                	li	a3,1
 6e8:	9e89                	subw	a3,a3,a0
 6ea:	00f6853b          	addw	a0,a3,a5
 6ee:	0785                	addi	a5,a5,1
 6f0:	fff7c703          	lbu	a4,-1(a5)
 6f4:	fb7d                	bnez	a4,6ea <strlen+0x14>
    return n;
}
 6f6:	6422                	ld	s0,8(sp)
 6f8:	0141                	addi	sp,sp,16
 6fa:	8082                	ret
    for (n = 0; s[n]; n++);
 6fc:	4501                	li	a0,0
 6fe:	bfe5                	j	6f6 <strlen+0x20>

0000000000000700 <strchr>:

char* strchr(const char* s, char c)
{
 700:	1141                	addi	sp,sp,-16
 702:	e422                	sd	s0,8(sp)
 704:	0800                	addi	s0,sp,16
    for (; *s; s++)
 706:	00054783          	lbu	a5,0(a0)
 70a:	cb99                	beqz	a5,720 <strchr+0x20>
        if (*s == c)
 70c:	00f58763          	beq	a1,a5,71a <strchr+0x1a>
    for (; *s; s++)
 710:	0505                	addi	a0,a0,1
 712:	00054783          	lbu	a5,0(a0)
 716:	fbfd                	bnez	a5,70c <strchr+0xc>
            return (char*)s;
    return 0;
 718:	4501                	li	a0,0
}
 71a:	6422                	ld	s0,8(sp)
 71c:	0141                	addi	sp,sp,16
 71e:	8082                	ret
    return 0;
 720:	4501                	li	a0,0
 722:	bfe5                	j	71a <strchr+0x1a>

0000000000000724 <stat>:
//     return buf;
// }

int
stat(const char *s, struct stat *st)
{
 724:	1101                	addi	sp,sp,-32
 726:	ec06                	sd	ra,24(sp)
 728:	e822                	sd	s0,16(sp)
 72a:	e426                	sd	s1,8(sp)
 72c:	1000                	addi	s0,sp,32
 72e:	84ae                	mv	s1,a1
    int fd;
    int r;

    fd = open(s, O_RDONLY);
 730:	4581                	li	a1,0
 732:	00000097          	auipc	ra,0x0
 736:	bde080e7          	jalr	-1058(ra) # 310 <open>
    if(fd < 0)
 73a:	00054c63          	bltz	a0,752 <stat+0x2e>
        return -1;
    r = fstat(fd, st);
 73e:	85a6                	mv	a1,s1
 740:	00000097          	auipc	ra,0x0
 744:	bf8080e7          	jalr	-1032(ra) # 338 <fstat>
//    close(fd);
    return r;
}
 748:	60e2                	ld	ra,24(sp)
 74a:	6442                	ld	s0,16(sp)
 74c:	64a2                	ld	s1,8(sp)
 74e:	6105                	addi	sp,sp,32
 750:	8082                	ret
        return -1;
 752:	557d                	li	a0,-1
 754:	bfd5                	j	748 <stat+0x24>

0000000000000756 <atoi>:

int atoi(const char* s)
{
 756:	1141                	addi	sp,sp,-16
 758:	e422                	sd	s0,8(sp)
 75a:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 75c:	00054603          	lbu	a2,0(a0)
 760:	fd06079b          	addiw	a5,a2,-48
 764:	0ff7f793          	andi	a5,a5,255
 768:	4725                	li	a4,9
 76a:	02f76963          	bltu	a4,a5,79c <atoi+0x46>
 76e:	86aa                	mv	a3,a0
    n = 0;
 770:	4501                	li	a0,0
    while ('0' <= *s && *s <= '9')
 772:	45a5                	li	a1,9
        n = n * 10 + *s++ - '0';
 774:	0685                	addi	a3,a3,1
 776:	0025179b          	slliw	a5,a0,0x2
 77a:	9fa9                	addw	a5,a5,a0
 77c:	0017979b          	slliw	a5,a5,0x1
 780:	9fb1                	addw	a5,a5,a2
 782:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 786:	0006c603          	lbu	a2,0(a3)
 78a:	fd06071b          	addiw	a4,a2,-48
 78e:	0ff77713          	andi	a4,a4,255
 792:	fee5f1e3          	bgeu	a1,a4,774 <atoi+0x1e>
    return n;
}
 796:	6422                	ld	s0,8(sp)
 798:	0141                	addi	sp,sp,16
 79a:	8082                	ret
    n = 0;
 79c:	4501                	li	a0,0
 79e:	bfe5                	j	796 <atoi+0x40>

00000000000007a0 <memset>:

//memory utils
 void* memset(void* dst, int c, uint n)
 {
 7a0:	1141                	addi	sp,sp,-16
 7a2:	e422                	sd	s0,8(sp)
 7a4:	0800                	addi	s0,sp,16
     char* cdst = (char*)dst;
     int i;
     for (i = 0; i < n; i++) {
 7a6:	ce09                	beqz	a2,7c0 <memset+0x20>
 7a8:	87aa                	mv	a5,a0
 7aa:	fff6071b          	addiw	a4,a2,-1
 7ae:	1702                	slli	a4,a4,0x20
 7b0:	9301                	srli	a4,a4,0x20
 7b2:	0705                	addi	a4,a4,1
 7b4:	972a                	add	a4,a4,a0
         cdst[i] = c;
 7b6:	00b78023          	sb	a1,0(a5)
     for (i = 0; i < n; i++) {
 7ba:	0785                	addi	a5,a5,1
 7bc:	fee79de3          	bne	a5,a4,7b6 <memset+0x16>
     }
     return dst;
 }
 7c0:	6422                	ld	s0,8(sp)
 7c2:	0141                	addi	sp,sp,16
 7c4:	8082                	ret

00000000000007c6 <memmove>:

 void* memmove(void* vdst, const void* vsrc, int n)
 {
 7c6:	1141                	addi	sp,sp,-16
 7c8:	e422                	sd	s0,8(sp)
 7ca:	0800                	addi	s0,sp,16
     char* dst;
     const char* src;

     dst = vdst;
     src = vsrc;
     if (src > dst) {
 7cc:	02b57663          	bgeu	a0,a1,7f8 <memmove+0x32>
         while (n-- > 0)
 7d0:	02c05163          	blez	a2,7f2 <memmove+0x2c>
 7d4:	fff6079b          	addiw	a5,a2,-1
 7d8:	1782                	slli	a5,a5,0x20
 7da:	9381                	srli	a5,a5,0x20
 7dc:	0785                	addi	a5,a5,1
 7de:	97aa                	add	a5,a5,a0
     dst = vdst;
 7e0:	872a                	mv	a4,a0
             *dst++ = *src++;
 7e2:	0585                	addi	a1,a1,1
 7e4:	0705                	addi	a4,a4,1
 7e6:	fff5c683          	lbu	a3,-1(a1)
 7ea:	fed70fa3          	sb	a3,-1(a4)
         while (n-- > 0)
 7ee:	fee79ae3          	bne	a5,a4,7e2 <memmove+0x1c>
         src += n;
         while (n-- > 0)
             *--dst = *--src;
     }
     return vdst;
 }
 7f2:	6422                	ld	s0,8(sp)
 7f4:	0141                	addi	sp,sp,16
 7f6:	8082                	ret
         dst += n;
 7f8:	00c50733          	add	a4,a0,a2
         src += n;
 7fc:	95b2                	add	a1,a1,a2
         while (n-- > 0)
 7fe:	fec05ae3          	blez	a2,7f2 <memmove+0x2c>
 802:	fff6079b          	addiw	a5,a2,-1
 806:	1782                	slli	a5,a5,0x20
 808:	9381                	srli	a5,a5,0x20
 80a:	fff7c793          	not	a5,a5
 80e:	97ba                	add	a5,a5,a4
             *--dst = *--src;
 810:	15fd                	addi	a1,a1,-1
 812:	177d                	addi	a4,a4,-1
 814:	0005c683          	lbu	a3,0(a1)
 818:	00d70023          	sb	a3,0(a4)
         while (n-- > 0)
 81c:	fee79ae3          	bne	a5,a4,810 <memmove+0x4a>
 820:	bfc9                	j	7f2 <memmove+0x2c>

0000000000000822 <memcmp>:

int memcmp(const void* s1, const void* s2, uint n)
{
 822:	1141                	addi	sp,sp,-16
 824:	e422                	sd	s0,8(sp)
 826:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0) {
 828:	ca05                	beqz	a2,858 <memcmp+0x36>
 82a:	fff6069b          	addiw	a3,a2,-1
 82e:	1682                	slli	a3,a3,0x20
 830:	9281                	srli	a3,a3,0x20
 832:	0685                	addi	a3,a3,1
 834:	96aa                	add	a3,a3,a0
        if (*p1 != *p2) {
 836:	00054783          	lbu	a5,0(a0)
 83a:	0005c703          	lbu	a4,0(a1)
 83e:	00e79863          	bne	a5,a4,84e <memcmp+0x2c>
            return *p1 - *p2;
        }
        p1++;
 842:	0505                	addi	a0,a0,1
        p2++;
 844:	0585                	addi	a1,a1,1
    while (n-- > 0) {
 846:	fed518e3          	bne	a0,a3,836 <memcmp+0x14>
    }
    return 0;
 84a:	4501                	li	a0,0
 84c:	a019                	j	852 <memcmp+0x30>
            return *p1 - *p2;
 84e:	40e7853b          	subw	a0,a5,a4
}
 852:	6422                	ld	s0,8(sp)
 854:	0141                	addi	sp,sp,16
 856:	8082                	ret
    return 0;
 858:	4501                	li	a0,0
 85a:	bfe5                	j	852 <memcmp+0x30>

000000000000085c <memcpy>:

void* memcpy(void* dst, const void* src, uint n)
{
 85c:	1141                	addi	sp,sp,-16
 85e:	e406                	sd	ra,8(sp)
 860:	e022                	sd	s0,0(sp)
 862:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 864:	00000097          	auipc	ra,0x0
 868:	f62080e7          	jalr	-158(ra) # 7c6 <memmove>
}
 86c:	60a2                	ld	ra,8(sp)
 86e:	6402                	ld	s0,0(sp)
 870:	0141                	addi	sp,sp,16
 872:	8082                	ret

0000000000000874 <min>:

//math utils
int min(int a, int b)
{
 874:	1141                	addi	sp,sp,-16
 876:	e422                	sd	s0,8(sp)
 878:	0800                	addi	s0,sp,16
    return a < b ? a : b;
 87a:	87ae                	mv	a5,a1
 87c:	00b55363          	bge	a0,a1,882 <min+0xe>
 880:	87aa                	mv	a5,a0
}
 882:	0007851b          	sext.w	a0,a5
 886:	6422                	ld	s0,8(sp)
 888:	0141                	addi	sp,sp,16
 88a:	8082                	ret

000000000000088c <max>:
int max(int a, int b)
{
 88c:	1141                	addi	sp,sp,-16
 88e:	e422                	sd	s0,8(sp)
 890:	0800                	addi	s0,sp,16
    return a > b ? a : b;
 892:	87ae                	mv	a5,a1
 894:	00a5d363          	bge	a1,a0,89a <max+0xe>
 898:	87aa                	mv	a5,a0
}
 89a:	0007851b          	sext.w	a0,a5
 89e:	6422                	ld	s0,8(sp)
 8a0:	0141                	addi	sp,sp,16
 8a2:	8082                	ret
