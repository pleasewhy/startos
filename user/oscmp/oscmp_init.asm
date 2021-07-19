
_oscmp_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_success>:
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	842a                	mv	s0,a0
   a:	00001517          	auipc	a0,0x1
   e:	abe50513          	addi	a0,a0,-1346 # ac8 <malloc+0x118>
  12:	00001097          	auipc	ra,0x1
  16:	8f8080e7          	jalr	-1800(ra) # 90a <printf>
  1a:	600c                	ld	a1,0(s0)
  1c:	cd99                	beqz	a1,3a <print_success+0x3a>
  1e:	0421                	addi	s0,s0,8
  20:	00001497          	auipc	s1,0x1
  24:	ac048493          	addi	s1,s1,-1344 # ae0 <malloc+0x130>
  28:	8526                	mv	a0,s1
  2a:	00001097          	auipc	ra,0x1
  2e:	8e0080e7          	jalr	-1824(ra) # 90a <printf>
  32:	0421                	addi	s0,s0,8
  34:	ff843583          	ld	a1,-8(s0)
  38:	f9e5                	bnez	a1,28 <print_success+0x28>
  3a:	00001517          	auipc	a0,0x1
  3e:	aae50513          	addi	a0,a0,-1362 # ae8 <malloc+0x138>
  42:	00001097          	auipc	ra,0x1
  46:	8c8080e7          	jalr	-1848(ra) # 90a <printf>
  4a:	60e2                	ld	ra,24(sp)
  4c:	6442                	ld	s0,16(sp)
  4e:	64a2                	ld	s1,8(sp)
  50:	6105                	addi	sp,sp,32
  52:	8082                	ret

0000000000000054 <test>:
  54:	7179                	addi	sp,sp,-48
  56:	f406                	sd	ra,40(sp)
  58:	f022                	sd	s0,32(sp)
  5a:	ec26                	sd	s1,24(sp)
  5c:	84aa                	mv	s1,a0
  5e:	842e                	mv	s0,a1
  60:	00000097          	auipc	ra,0x0
  64:	2de080e7          	jalr	734(ra) # 33e <fork>
  68:	ed09                	bnez	a0,82 <test+0x2e>
  6a:	4601                	li	a2,0
  6c:	85a2                	mv	a1,s0
  6e:	8526                	mv	a0,s1
  70:	00000097          	auipc	ra,0x0
  74:	3f6080e7          	jalr	1014(ra) # 466 <execve>
  78:	70a2                	ld	ra,40(sp)
  7a:	7402                	ld	s0,32(sp)
  7c:	64e2                	ld	s1,24(sp)
  7e:	6145                	addi	sp,sp,48
  80:	8082                	ret
  82:	0068                	addi	a0,sp,12
  84:	00000097          	auipc	ra,0x0
  88:	2c2080e7          	jalr	706(ra) # 346 <wait>
  8c:	47b2                	lw	a5,12(sp)
  8e:	fe07c5e3          	bltz	a5,78 <test+0x24>
  92:	8522                	mv	a0,s0
  94:	00000097          	auipc	ra,0x0
  98:	f6c080e7          	jalr	-148(ra) # 0 <print_success>
  9c:	bff1                	j	78 <test+0x24>

000000000000009e <main>:
  9e:	7125                	addi	sp,sp,-416
  a0:	ef06                	sd	ra,408(sp)
  a2:	4589                	li	a1,2
  a4:	00001517          	auipc	a0,0x1
  a8:	a5450513          	addi	a0,a0,-1452 # af8 <malloc+0x148>
  ac:	00000097          	auipc	ra,0x0
  b0:	2a2080e7          	jalr	674(ra) # 34e <open>
  b4:	4501                	li	a0,0
  b6:	00000097          	auipc	ra,0x0
  ba:	2b0080e7          	jalr	688(ra) # 366 <dup>
  be:	4501                	li	a0,0
  c0:	00000097          	auipc	ra,0x0
  c4:	2a6080e7          	jalr	678(ra) # 366 <dup>
  c8:	00001797          	auipc	a5,0x1
  cc:	a3878793          	addi	a5,a5,-1480 # b00 <malloc+0x150>
  d0:	febe                	sd	a5,376(sp)
  d2:	00001797          	auipc	a5,0x1
  d6:	a3678793          	addi	a5,a5,-1482 # b08 <malloc+0x158>
  da:	e33e                	sd	a5,384(sp)
  dc:	e702                	sd	zero,392(sp)
  de:	00001797          	auipc	a5,0x1
  e2:	aea78793          	addi	a5,a5,-1302 # bc8 <malloc+0x218>
  e6:	638c                	ld	a1,0(a5)
  e8:	6790                	ld	a2,8(a5)
  ea:	6b94                	ld	a3,16(a5)
  ec:	6f98                	ld	a4,24(a5)
  ee:	eeae                	sd	a1,344(sp)
  f0:	f2b2                	sd	a2,352(sp)
  f2:	f6b6                	sd	a3,360(sp)
  f4:	faba                	sd	a4,368(sp)
  f6:	738c                	ld	a1,32(a5)
  f8:	7790                	ld	a2,40(a5)
  fa:	7b94                	ld	a3,48(a5)
  fc:	7f98                	ld	a4,56(a5)
  fe:	fe2e                	sd	a1,312(sp)
 100:	e2b2                	sd	a2,320(sp)
 102:	e6b6                	sd	a3,328(sp)
 104:	eaba                	sd	a4,336(sp)
 106:	00001717          	auipc	a4,0x1
 10a:	a2270713          	addi	a4,a4,-1502 # b28 <malloc+0x178>
 10e:	f23a                	sd	a4,288(sp)
 110:	00001717          	auipc	a4,0x1
 114:	a2870713          	addi	a4,a4,-1496 # b38 <malloc+0x188>
 118:	f63a                	sd	a4,296(sp)
 11a:	fa02                	sd	zero,304(sp)
 11c:	00001697          	auipc	a3,0x1
 120:	a2c68693          	addi	a3,a3,-1492 # b48 <malloc+0x198>
 124:	ea36                	sd	a3,272(sp)
 126:	ee02                	sd	zero,280(sp)
 128:	00001697          	auipc	a3,0x1
 12c:	a2868693          	addi	a3,a3,-1496 # b50 <malloc+0x1a0>
 130:	e236                	sd	a3,256(sp)
 132:	e602                	sd	zero,264(sp)
 134:	00001697          	auipc	a3,0x1
 138:	a2468693          	addi	a3,a3,-1500 # b58 <malloc+0x1a8>
 13c:	f9b6                	sd	a3,240(sp)
 13e:	fd82                	sd	zero,248(sp)
 140:	00001697          	auipc	a3,0x1
 144:	a2068693          	addi	a3,a3,-1504 # b60 <malloc+0x1b0>
 148:	edb6                	sd	a3,216(sp)
 14a:	f1ba                	sd	a4,224(sp)
 14c:	f582                	sd	zero,232(sp)
 14e:	63ac                	ld	a1,64(a5)
 150:	67b0                	ld	a2,72(a5)
 152:	6bb4                	ld	a3,80(a5)
 154:	6fb8                	ld	a4,88(a5)
 156:	73bc                	ld	a5,96(a5)
 158:	f92e                	sd	a1,176(sp)
 15a:	fd32                	sd	a2,184(sp)
 15c:	e1b6                	sd	a3,192(sp)
 15e:	e5ba                	sd	a4,200(sp)
 160:	e9be                	sd	a5,208(sp)
 162:	00001797          	auipc	a5,0x1
 166:	a0678793          	addi	a5,a5,-1530 # b68 <malloc+0x1b8>
 16a:	f13e                	sd	a5,160(sp)
 16c:	f502                	sd	zero,168(sp)
 16e:	00001797          	auipc	a5,0x1
 172:	a0278793          	addi	a5,a5,-1534 # b70 <malloc+0x1c0>
 176:	e93e                	sd	a5,144(sp)
 178:	ed02                	sd	zero,152(sp)
 17a:	00001797          	auipc	a5,0x1
 17e:	9fe78793          	addi	a5,a5,-1538 # b78 <malloc+0x1c8>
 182:	fcbe                	sd	a5,120(sp)
 184:	00001797          	auipc	a5,0x1
 188:	9fc78793          	addi	a5,a5,-1540 # b80 <malloc+0x1d0>
 18c:	e13e                	sd	a5,128(sp)
 18e:	e502                	sd	zero,136(sp)
 190:	00001717          	auipc	a4,0x1
 194:	9f870713          	addi	a4,a4,-1544 # b88 <malloc+0x1d8>
 198:	f4ba                	sd	a4,104(sp)
 19a:	f882                	sd	zero,112(sp)
 19c:	00001717          	auipc	a4,0x1
 1a0:	9f470713          	addi	a4,a4,-1548 # b90 <malloc+0x1e0>
 1a4:	ecba                	sd	a4,88(sp)
 1a6:	f082                	sd	zero,96(sp)
 1a8:	00001717          	auipc	a4,0x1
 1ac:	9f070713          	addi	a4,a4,-1552 # b98 <malloc+0x1e8>
 1b0:	e4ba                	sd	a4,72(sp)
 1b2:	e882                	sd	zero,80(sp)
 1b4:	00001717          	auipc	a4,0x1
 1b8:	9ec70713          	addi	a4,a4,-1556 # ba0 <malloc+0x1f0>
 1bc:	fc3a                	sd	a4,56(sp)
 1be:	e082                	sd	zero,64(sp)
 1c0:	00001717          	auipc	a4,0x1
 1c4:	9e870713          	addi	a4,a4,-1560 # ba8 <malloc+0x1f8>
 1c8:	f03a                	sd	a4,32(sp)
 1ca:	00001717          	auipc	a4,0x1
 1ce:	9e670713          	addi	a4,a4,-1562 # bb0 <malloc+0x200>
 1d2:	f43a                	sd	a4,40(sp)
 1d4:	f802                	sd	zero,48(sp)
 1d6:	e83e                	sd	a5,16(sp)
 1d8:	ec02                	sd	zero,24(sp)
 1da:	00001797          	auipc	a5,0x1
 1de:	9de78793          	addi	a5,a5,-1570 # bb8 <malloc+0x208>
 1e2:	e03e                	sd	a5,0(sp)
 1e4:	e402                	sd	zero,8(sp)
 1e6:	1aac                	addi	a1,sp,376
 1e8:	00001517          	auipc	a0,0x1
 1ec:	9d850513          	addi	a0,a0,-1576 # bc0 <malloc+0x210>
 1f0:	00000097          	auipc	ra,0x0
 1f4:	e64080e7          	jalr	-412(ra) # 54 <test>
 1f8:	0aac                	addi	a1,sp,344
 1fa:	00001517          	auipc	a0,0x1
 1fe:	9c650513          	addi	a0,a0,-1594 # bc0 <malloc+0x210>
 202:	00000097          	auipc	ra,0x0
 206:	e52080e7          	jalr	-430(ra) # 54 <test>
 20a:	1a2c                	addi	a1,sp,312
 20c:	00001517          	auipc	a0,0x1
 210:	9b450513          	addi	a0,a0,-1612 # bc0 <malloc+0x210>
 214:	00000097          	auipc	ra,0x0
 218:	e40080e7          	jalr	-448(ra) # 54 <test>
 21c:	120c                	addi	a1,sp,288
 21e:	00001517          	auipc	a0,0x1
 222:	9a250513          	addi	a0,a0,-1630 # bc0 <malloc+0x210>
 226:	00000097          	auipc	ra,0x0
 22a:	e2e080e7          	jalr	-466(ra) # 54 <test>
 22e:	0a0c                	addi	a1,sp,272
 230:	00001517          	auipc	a0,0x1
 234:	99050513          	addi	a0,a0,-1648 # bc0 <malloc+0x210>
 238:	00000097          	auipc	ra,0x0
 23c:	e1c080e7          	jalr	-484(ra) # 54 <test>
 240:	020c                	addi	a1,sp,256
 242:	00001517          	auipc	a0,0x1
 246:	97e50513          	addi	a0,a0,-1666 # bc0 <malloc+0x210>
 24a:	00000097          	auipc	ra,0x0
 24e:	e0a080e7          	jalr	-502(ra) # 54 <test>
 252:	198c                	addi	a1,sp,240
 254:	00001517          	auipc	a0,0x1
 258:	96c50513          	addi	a0,a0,-1684 # bc0 <malloc+0x210>
 25c:	00000097          	auipc	ra,0x0
 260:	df8080e7          	jalr	-520(ra) # 54 <test>
 264:	09ac                	addi	a1,sp,216
 266:	00001517          	auipc	a0,0x1
 26a:	95a50513          	addi	a0,a0,-1702 # bc0 <malloc+0x210>
 26e:	00000097          	auipc	ra,0x0
 272:	de6080e7          	jalr	-538(ra) # 54 <test>
 276:	190c                	addi	a1,sp,176
 278:	00001517          	auipc	a0,0x1
 27c:	94850513          	addi	a0,a0,-1720 # bc0 <malloc+0x210>
 280:	00000097          	auipc	ra,0x0
 284:	dd4080e7          	jalr	-556(ra) # 54 <test>
 288:	110c                	addi	a1,sp,160
 28a:	00001517          	auipc	a0,0x1
 28e:	93650513          	addi	a0,a0,-1738 # bc0 <malloc+0x210>
 292:	00000097          	auipc	ra,0x0
 296:	dc2080e7          	jalr	-574(ra) # 54 <test>
 29a:	090c                	addi	a1,sp,144
 29c:	00001517          	auipc	a0,0x1
 2a0:	92450513          	addi	a0,a0,-1756 # bc0 <malloc+0x210>
 2a4:	00000097          	auipc	ra,0x0
 2a8:	db0080e7          	jalr	-592(ra) # 54 <test>
 2ac:	18ac                	addi	a1,sp,120
 2ae:	00001517          	auipc	a0,0x1
 2b2:	91250513          	addi	a0,a0,-1774 # bc0 <malloc+0x210>
 2b6:	00000097          	auipc	ra,0x0
 2ba:	d9e080e7          	jalr	-610(ra) # 54 <test>
 2be:	10ac                	addi	a1,sp,104
 2c0:	00001517          	auipc	a0,0x1
 2c4:	90050513          	addi	a0,a0,-1792 # bc0 <malloc+0x210>
 2c8:	00000097          	auipc	ra,0x0
 2cc:	d8c080e7          	jalr	-628(ra) # 54 <test>
 2d0:	08ac                	addi	a1,sp,88
 2d2:	00001517          	auipc	a0,0x1
 2d6:	8ee50513          	addi	a0,a0,-1810 # bc0 <malloc+0x210>
 2da:	00000097          	auipc	ra,0x0
 2de:	d7a080e7          	jalr	-646(ra) # 54 <test>
 2e2:	00ac                	addi	a1,sp,72
 2e4:	00001517          	auipc	a0,0x1
 2e8:	8dc50513          	addi	a0,a0,-1828 # bc0 <malloc+0x210>
 2ec:	00000097          	auipc	ra,0x0
 2f0:	d68080e7          	jalr	-664(ra) # 54 <test>
 2f4:	100c                	addi	a1,sp,32
 2f6:	00001517          	auipc	a0,0x1
 2fa:	8ca50513          	addi	a0,a0,-1846 # bc0 <malloc+0x210>
 2fe:	00000097          	auipc	ra,0x0
 302:	d56080e7          	jalr	-682(ra) # 54 <test>
 306:	080c                	addi	a1,sp,16
 308:	00001517          	auipc	a0,0x1
 30c:	8b850513          	addi	a0,a0,-1864 # bc0 <malloc+0x210>
 310:	00000097          	auipc	ra,0x0
 314:	d44080e7          	jalr	-700(ra) # 54 <test>
 318:	858a                	mv	a1,sp
 31a:	00001517          	auipc	a0,0x1
 31e:	8a650513          	addi	a0,a0,-1882 # bc0 <malloc+0x210>
 322:	00000097          	auipc	ra,0x0
 326:	d32080e7          	jalr	-718(ra) # 54 <test>
 32a:	182c                	addi	a1,sp,56
 32c:	00001517          	auipc	a0,0x1
 330:	89450513          	addi	a0,a0,-1900 # bc0 <malloc+0x210>
 334:	00000097          	auipc	ra,0x0
 338:	d20080e7          	jalr	-736(ra) # 54 <test>
 33c:	a001                	j	33c <main+0x29e>

000000000000033e <fork>:
 33e:	4885                	li	a7,1
 340:	00000073          	ecall
 344:	8082                	ret

0000000000000346 <wait>:
 346:	488d                	li	a7,3
 348:	00000073          	ecall
 34c:	8082                	ret

000000000000034e <open>:
 34e:	4889                	li	a7,2
 350:	00000073          	ecall
 354:	8082                	ret

0000000000000356 <sbrk>:
 356:	4891                	li	a7,4
 358:	00000073          	ecall
 35c:	8082                	ret

000000000000035e <getcwd>:
 35e:	48c5                	li	a7,17
 360:	00000073          	ecall
 364:	8082                	ret

0000000000000366 <dup>:
 366:	48dd                	li	a7,23
 368:	00000073          	ecall
 36c:	8082                	ret

000000000000036e <dup3>:
 36e:	48e1                	li	a7,24
 370:	00000073          	ecall
 374:	8082                	ret

0000000000000376 <mkdirat>:
 376:	02200893          	li	a7,34
 37a:	00000073          	ecall
 37e:	8082                	ret

0000000000000380 <unlinkat>:
 380:	02300893          	li	a7,35
 384:	00000073          	ecall
 388:	8082                	ret

000000000000038a <linkat>:
 38a:	02500893          	li	a7,37
 38e:	00000073          	ecall
 392:	8082                	ret

0000000000000394 <umount2>:
 394:	02700893          	li	a7,39
 398:	00000073          	ecall
 39c:	8082                	ret

000000000000039e <mount>:
 39e:	02800893          	li	a7,40
 3a2:	00000073          	ecall
 3a6:	8082                	ret

00000000000003a8 <chdir>:
 3a8:	03100893          	li	a7,49
 3ac:	00000073          	ecall
 3b0:	8082                	ret

00000000000003b2 <openat>:
 3b2:	03800893          	li	a7,56
 3b6:	00000073          	ecall
 3ba:	8082                	ret

00000000000003bc <close>:
 3bc:	03900893          	li	a7,57
 3c0:	00000073          	ecall
 3c4:	8082                	ret

00000000000003c6 <pipe2>:
 3c6:	03b00893          	li	a7,59
 3ca:	00000073          	ecall
 3ce:	8082                	ret

00000000000003d0 <getdents64>:
 3d0:	03d00893          	li	a7,61
 3d4:	00000073          	ecall
 3d8:	8082                	ret

00000000000003da <read>:
 3da:	03f00893          	li	a7,63
 3de:	00000073          	ecall
 3e2:	8082                	ret

00000000000003e4 <write>:
 3e4:	04000893          	li	a7,64
 3e8:	00000073          	ecall
 3ec:	8082                	ret

00000000000003ee <fstat>:
 3ee:	05000893          	li	a7,80
 3f2:	00000073          	ecall
 3f6:	8082                	ret

00000000000003f8 <exit>:
 3f8:	05d00893          	li	a7,93
 3fc:	00000073          	ecall
 400:	8082                	ret

0000000000000402 <nanosleep>:
 402:	06500893          	li	a7,101
 406:	00000073          	ecall
 40a:	8082                	ret

000000000000040c <sched_yield>:
 40c:	07c00893          	li	a7,124
 410:	00000073          	ecall
 414:	8082                	ret

0000000000000416 <times>:
 416:	09900893          	li	a7,153
 41a:	00000073          	ecall
 41e:	8082                	ret

0000000000000420 <uname>:
 420:	0a000893          	li	a7,160
 424:	00000073          	ecall
 428:	8082                	ret

000000000000042a <gettimeofday>:
 42a:	0a900893          	li	a7,169
 42e:	00000073          	ecall
 432:	8082                	ret

0000000000000434 <brk>:
 434:	0d600893          	li	a7,214
 438:	00000073          	ecall
 43c:	8082                	ret

000000000000043e <munmap>:
 43e:	0d700893          	li	a7,215
 442:	00000073          	ecall
 446:	8082                	ret

0000000000000448 <getpid>:
 448:	0ac00893          	li	a7,172
 44c:	00000073          	ecall
 450:	8082                	ret

0000000000000452 <getppid>:
 452:	0ad00893          	li	a7,173
 456:	00000073          	ecall
 45a:	8082                	ret

000000000000045c <clone>:
 45c:	0dc00893          	li	a7,220
 460:	00000073          	ecall
 464:	8082                	ret

0000000000000466 <execve>:
 466:	0dd00893          	li	a7,221
 46a:	00000073          	ecall
 46e:	8082                	ret

0000000000000470 <mmap>:
 470:	0de00893          	li	a7,222
 474:	00000073          	ecall
 478:	8082                	ret

000000000000047a <wait4>:
 47a:	10400893          	li	a7,260
 47e:	00000073          	ecall
 482:	8082                	ret

0000000000000484 <kernel_panic>:
 484:	18f00893          	li	a7,399
 488:	00000073          	ecall
 48c:	8082                	ret

000000000000048e <strcpy>:
 48e:	87aa                	mv	a5,a0
 490:	0585                	addi	a1,a1,1
 492:	0785                	addi	a5,a5,1
 494:	fff5c703          	lbu	a4,-1(a1)
 498:	fee78fa3          	sb	a4,-1(a5)
 49c:	fb75                	bnez	a4,490 <strcpy+0x2>
 49e:	8082                	ret

00000000000004a0 <strcmp>:
 4a0:	00054783          	lbu	a5,0(a0)
 4a4:	cb91                	beqz	a5,4b8 <strcmp+0x18>
 4a6:	0005c703          	lbu	a4,0(a1)
 4aa:	00f71763          	bne	a4,a5,4b8 <strcmp+0x18>
 4ae:	0505                	addi	a0,a0,1
 4b0:	0585                	addi	a1,a1,1
 4b2:	00054783          	lbu	a5,0(a0)
 4b6:	fbe5                	bnez	a5,4a6 <strcmp+0x6>
 4b8:	0005c503          	lbu	a0,0(a1)
 4bc:	40a7853b          	subw	a0,a5,a0
 4c0:	8082                	ret

00000000000004c2 <strlen>:
 4c2:	00054783          	lbu	a5,0(a0)
 4c6:	cf81                	beqz	a5,4de <strlen+0x1c>
 4c8:	0505                	addi	a0,a0,1
 4ca:	87aa                	mv	a5,a0
 4cc:	4685                	li	a3,1
 4ce:	9e89                	subw	a3,a3,a0
 4d0:	00f6853b          	addw	a0,a3,a5
 4d4:	0785                	addi	a5,a5,1
 4d6:	fff7c703          	lbu	a4,-1(a5)
 4da:	fb7d                	bnez	a4,4d0 <strlen+0xe>
 4dc:	8082                	ret
 4de:	4501                	li	a0,0
 4e0:	8082                	ret

00000000000004e2 <memset>:
 4e2:	ce09                	beqz	a2,4fc <memset+0x1a>
 4e4:	87aa                	mv	a5,a0
 4e6:	fff6071b          	addiw	a4,a2,-1
 4ea:	1702                	slli	a4,a4,0x20
 4ec:	9301                	srli	a4,a4,0x20
 4ee:	0705                	addi	a4,a4,1
 4f0:	972a                	add	a4,a4,a0
 4f2:	00b78023          	sb	a1,0(a5)
 4f6:	0785                	addi	a5,a5,1
 4f8:	fee79de3          	bne	a5,a4,4f2 <memset+0x10>
 4fc:	8082                	ret

00000000000004fe <strchr>:
 4fe:	00054783          	lbu	a5,0(a0)
 502:	cb89                	beqz	a5,514 <strchr+0x16>
 504:	00f58963          	beq	a1,a5,516 <strchr+0x18>
 508:	0505                	addi	a0,a0,1
 50a:	00054783          	lbu	a5,0(a0)
 50e:	fbfd                	bnez	a5,504 <strchr+0x6>
 510:	4501                	li	a0,0
 512:	8082                	ret
 514:	4501                	li	a0,0
 516:	8082                	ret

0000000000000518 <gets>:
 518:	715d                	addi	sp,sp,-80
 51a:	e486                	sd	ra,72(sp)
 51c:	e0a2                	sd	s0,64(sp)
 51e:	fc26                	sd	s1,56(sp)
 520:	f84a                	sd	s2,48(sp)
 522:	f44e                	sd	s3,40(sp)
 524:	f052                	sd	s4,32(sp)
 526:	ec56                	sd	s5,24(sp)
 528:	e85a                	sd	s6,16(sp)
 52a:	8b2a                	mv	s6,a0
 52c:	89ae                	mv	s3,a1
 52e:	84aa                	mv	s1,a0
 530:	4401                	li	s0,0
 532:	4a29                	li	s4,10
 534:	4ab5                	li	s5,13
 536:	8922                	mv	s2,s0
 538:	2405                	addiw	s0,s0,1
 53a:	03345863          	bge	s0,s3,56a <gets+0x52>
 53e:	4605                	li	a2,1
 540:	00f10593          	addi	a1,sp,15
 544:	4501                	li	a0,0
 546:	00000097          	auipc	ra,0x0
 54a:	e94080e7          	jalr	-364(ra) # 3da <read>
 54e:	00a05e63          	blez	a0,56a <gets+0x52>
 552:	00f14783          	lbu	a5,15(sp)
 556:	00f48023          	sb	a5,0(s1)
 55a:	01478763          	beq	a5,s4,568 <gets+0x50>
 55e:	0485                	addi	s1,s1,1
 560:	fd579be3          	bne	a5,s5,536 <gets+0x1e>
 564:	8922                	mv	s2,s0
 566:	a011                	j	56a <gets+0x52>
 568:	8922                	mv	s2,s0
 56a:	995a                	add	s2,s2,s6
 56c:	00090023          	sb	zero,0(s2)
 570:	855a                	mv	a0,s6
 572:	60a6                	ld	ra,72(sp)
 574:	6406                	ld	s0,64(sp)
 576:	74e2                	ld	s1,56(sp)
 578:	7942                	ld	s2,48(sp)
 57a:	79a2                	ld	s3,40(sp)
 57c:	7a02                	ld	s4,32(sp)
 57e:	6ae2                	ld	s5,24(sp)
 580:	6b42                	ld	s6,16(sp)
 582:	6161                	addi	sp,sp,80
 584:	8082                	ret

0000000000000586 <atoi>:
 586:	86aa                	mv	a3,a0
 588:	00054603          	lbu	a2,0(a0)
 58c:	fd06079b          	addiw	a5,a2,-48
 590:	0ff7f793          	andi	a5,a5,255
 594:	4725                	li	a4,9
 596:	02f76663          	bltu	a4,a5,5c2 <atoi+0x3c>
 59a:	4501                	li	a0,0
 59c:	45a5                	li	a1,9
 59e:	0685                	addi	a3,a3,1
 5a0:	0025179b          	slliw	a5,a0,0x2
 5a4:	9fa9                	addw	a5,a5,a0
 5a6:	0017979b          	slliw	a5,a5,0x1
 5aa:	9fb1                	addw	a5,a5,a2
 5ac:	fd07851b          	addiw	a0,a5,-48
 5b0:	0006c603          	lbu	a2,0(a3)
 5b4:	fd06071b          	addiw	a4,a2,-48
 5b8:	0ff77713          	andi	a4,a4,255
 5bc:	fee5f1e3          	bgeu	a1,a4,59e <atoi+0x18>
 5c0:	8082                	ret
 5c2:	4501                	li	a0,0
 5c4:	8082                	ret

00000000000005c6 <memmove>:
 5c6:	02b57463          	bgeu	a0,a1,5ee <memmove+0x28>
 5ca:	04c05663          	blez	a2,616 <memmove+0x50>
 5ce:	fff6079b          	addiw	a5,a2,-1
 5d2:	1782                	slli	a5,a5,0x20
 5d4:	9381                	srli	a5,a5,0x20
 5d6:	0785                	addi	a5,a5,1
 5d8:	97aa                	add	a5,a5,a0
 5da:	872a                	mv	a4,a0
 5dc:	0585                	addi	a1,a1,1
 5de:	0705                	addi	a4,a4,1
 5e0:	fff5c683          	lbu	a3,-1(a1)
 5e4:	fed70fa3          	sb	a3,-1(a4)
 5e8:	fee79ae3          	bne	a5,a4,5dc <memmove+0x16>
 5ec:	8082                	ret
 5ee:	00c50733          	add	a4,a0,a2
 5f2:	95b2                	add	a1,a1,a2
 5f4:	02c05163          	blez	a2,616 <memmove+0x50>
 5f8:	fff6079b          	addiw	a5,a2,-1
 5fc:	1782                	slli	a5,a5,0x20
 5fe:	9381                	srli	a5,a5,0x20
 600:	fff7c793          	not	a5,a5
 604:	97ba                	add	a5,a5,a4
 606:	15fd                	addi	a1,a1,-1
 608:	177d                	addi	a4,a4,-1
 60a:	0005c683          	lbu	a3,0(a1)
 60e:	00d70023          	sb	a3,0(a4)
 612:	fee79ae3          	bne	a5,a4,606 <memmove+0x40>
 616:	8082                	ret

0000000000000618 <memcmp>:
 618:	fff6069b          	addiw	a3,a2,-1
 61c:	c605                	beqz	a2,644 <memcmp+0x2c>
 61e:	1682                	slli	a3,a3,0x20
 620:	9281                	srli	a3,a3,0x20
 622:	0685                	addi	a3,a3,1
 624:	96aa                	add	a3,a3,a0
 626:	00054783          	lbu	a5,0(a0)
 62a:	0005c703          	lbu	a4,0(a1)
 62e:	00e79863          	bne	a5,a4,63e <memcmp+0x26>
 632:	0505                	addi	a0,a0,1
 634:	0585                	addi	a1,a1,1
 636:	fed518e3          	bne	a0,a3,626 <memcmp+0xe>
 63a:	4501                	li	a0,0
 63c:	8082                	ret
 63e:	40e7853b          	subw	a0,a5,a4
 642:	8082                	ret
 644:	4501                	li	a0,0
 646:	8082                	ret

0000000000000648 <memcpy>:
 648:	1141                	addi	sp,sp,-16
 64a:	e406                	sd	ra,8(sp)
 64c:	00000097          	auipc	ra,0x0
 650:	f7a080e7          	jalr	-134(ra) # 5c6 <memmove>
 654:	60a2                	ld	ra,8(sp)
 656:	0141                	addi	sp,sp,16
 658:	8082                	ret

000000000000065a <putc>:
 65a:	1101                	addi	sp,sp,-32
 65c:	ec06                	sd	ra,24(sp)
 65e:	00b107a3          	sb	a1,15(sp)
 662:	4605                	li	a2,1
 664:	00f10593          	addi	a1,sp,15
 668:	00000097          	auipc	ra,0x0
 66c:	d7c080e7          	jalr	-644(ra) # 3e4 <write>
 670:	60e2                	ld	ra,24(sp)
 672:	6105                	addi	sp,sp,32
 674:	8082                	ret

0000000000000676 <printint>:
 676:	7179                	addi	sp,sp,-48
 678:	f406                	sd	ra,40(sp)
 67a:	f022                	sd	s0,32(sp)
 67c:	ec26                	sd	s1,24(sp)
 67e:	e84a                	sd	s2,16(sp)
 680:	84aa                	mv	s1,a0
 682:	c299                	beqz	a3,688 <printint+0x12>
 684:	0805c363          	bltz	a1,70a <printint+0x94>
 688:	2581                	sext.w	a1,a1
 68a:	4881                	li	a7,0
 68c:	868a                	mv	a3,sp
 68e:	4701                	li	a4,0
 690:	2601                	sext.w	a2,a2
 692:	00000517          	auipc	a0,0x0
 696:	5a650513          	addi	a0,a0,1446 # c38 <digits>
 69a:	883a                	mv	a6,a4
 69c:	2705                	addiw	a4,a4,1
 69e:	02c5f7bb          	remuw	a5,a1,a2
 6a2:	1782                	slli	a5,a5,0x20
 6a4:	9381                	srli	a5,a5,0x20
 6a6:	97aa                	add	a5,a5,a0
 6a8:	0007c783          	lbu	a5,0(a5)
 6ac:	00f68023          	sb	a5,0(a3)
 6b0:	0005879b          	sext.w	a5,a1
 6b4:	02c5d5bb          	divuw	a1,a1,a2
 6b8:	0685                	addi	a3,a3,1
 6ba:	fec7f0e3          	bgeu	a5,a2,69a <printint+0x24>
 6be:	00088a63          	beqz	a7,6d2 <printint+0x5c>
 6c2:	081c                	addi	a5,sp,16
 6c4:	973e                	add	a4,a4,a5
 6c6:	02d00793          	li	a5,45
 6ca:	fef70823          	sb	a5,-16(a4)
 6ce:	0028071b          	addiw	a4,a6,2
 6d2:	02e05663          	blez	a4,6fe <printint+0x88>
 6d6:	00e10433          	add	s0,sp,a4
 6da:	fff10913          	addi	s2,sp,-1
 6de:	993a                	add	s2,s2,a4
 6e0:	377d                	addiw	a4,a4,-1
 6e2:	1702                	slli	a4,a4,0x20
 6e4:	9301                	srli	a4,a4,0x20
 6e6:	40e90933          	sub	s2,s2,a4
 6ea:	fff44583          	lbu	a1,-1(s0)
 6ee:	8526                	mv	a0,s1
 6f0:	00000097          	auipc	ra,0x0
 6f4:	f6a080e7          	jalr	-150(ra) # 65a <putc>
 6f8:	147d                	addi	s0,s0,-1
 6fa:	ff2418e3          	bne	s0,s2,6ea <printint+0x74>
 6fe:	70a2                	ld	ra,40(sp)
 700:	7402                	ld	s0,32(sp)
 702:	64e2                	ld	s1,24(sp)
 704:	6942                	ld	s2,16(sp)
 706:	6145                	addi	sp,sp,48
 708:	8082                	ret
 70a:	40b005bb          	negw	a1,a1
 70e:	4885                	li	a7,1
 710:	bfb5                	j	68c <printint+0x16>

0000000000000712 <vprintf>:
 712:	7119                	addi	sp,sp,-128
 714:	fc86                	sd	ra,120(sp)
 716:	f8a2                	sd	s0,112(sp)
 718:	f4a6                	sd	s1,104(sp)
 71a:	f0ca                	sd	s2,96(sp)
 71c:	ecce                	sd	s3,88(sp)
 71e:	e8d2                	sd	s4,80(sp)
 720:	e4d6                	sd	s5,72(sp)
 722:	e0da                	sd	s6,64(sp)
 724:	fc5e                	sd	s7,56(sp)
 726:	f862                	sd	s8,48(sp)
 728:	f466                	sd	s9,40(sp)
 72a:	f06a                	sd	s10,32(sp)
 72c:	ec6e                	sd	s11,24(sp)
 72e:	0005c483          	lbu	s1,0(a1)
 732:	18048c63          	beqz	s1,8ca <vprintf+0x1b8>
 736:	8a2a                	mv	s4,a0
 738:	8ab2                	mv	s5,a2
 73a:	00158413          	addi	s0,a1,1
 73e:	4901                	li	s2,0
 740:	02500993          	li	s3,37
 744:	06400b93          	li	s7,100
 748:	06c00c13          	li	s8,108
 74c:	07800c93          	li	s9,120
 750:	07000d13          	li	s10,112
 754:	07300d93          	li	s11,115
 758:	00000b17          	auipc	s6,0x0
 75c:	4e0b0b13          	addi	s6,s6,1248 # c38 <digits>
 760:	a839                	j	77e <vprintf+0x6c>
 762:	85a6                	mv	a1,s1
 764:	8552                	mv	a0,s4
 766:	00000097          	auipc	ra,0x0
 76a:	ef4080e7          	jalr	-268(ra) # 65a <putc>
 76e:	a019                	j	774 <vprintf+0x62>
 770:	01390f63          	beq	s2,s3,78e <vprintf+0x7c>
 774:	0405                	addi	s0,s0,1
 776:	fff44483          	lbu	s1,-1(s0)
 77a:	14048863          	beqz	s1,8ca <vprintf+0x1b8>
 77e:	0004879b          	sext.w	a5,s1
 782:	fe0917e3          	bnez	s2,770 <vprintf+0x5e>
 786:	fd379ee3          	bne	a5,s3,762 <vprintf+0x50>
 78a:	893e                	mv	s2,a5
 78c:	b7e5                	j	774 <vprintf+0x62>
 78e:	03778e63          	beq	a5,s7,7ca <vprintf+0xb8>
 792:	05878a63          	beq	a5,s8,7e6 <vprintf+0xd4>
 796:	07978663          	beq	a5,s9,802 <vprintf+0xf0>
 79a:	09a78263          	beq	a5,s10,81e <vprintf+0x10c>
 79e:	0db78363          	beq	a5,s11,864 <vprintf+0x152>
 7a2:	06300713          	li	a4,99
 7a6:	0ee78b63          	beq	a5,a4,89c <vprintf+0x18a>
 7aa:	11378563          	beq	a5,s3,8b4 <vprintf+0x1a2>
 7ae:	85ce                	mv	a1,s3
 7b0:	8552                	mv	a0,s4
 7b2:	00000097          	auipc	ra,0x0
 7b6:	ea8080e7          	jalr	-344(ra) # 65a <putc>
 7ba:	85a6                	mv	a1,s1
 7bc:	8552                	mv	a0,s4
 7be:	00000097          	auipc	ra,0x0
 7c2:	e9c080e7          	jalr	-356(ra) # 65a <putc>
 7c6:	4901                	li	s2,0
 7c8:	b775                	j	774 <vprintf+0x62>
 7ca:	008a8493          	addi	s1,s5,8
 7ce:	4685                	li	a3,1
 7d0:	4629                	li	a2,10
 7d2:	000aa583          	lw	a1,0(s5)
 7d6:	8552                	mv	a0,s4
 7d8:	00000097          	auipc	ra,0x0
 7dc:	e9e080e7          	jalr	-354(ra) # 676 <printint>
 7e0:	8aa6                	mv	s5,s1
 7e2:	4901                	li	s2,0
 7e4:	bf41                	j	774 <vprintf+0x62>
 7e6:	008a8493          	addi	s1,s5,8
 7ea:	4681                	li	a3,0
 7ec:	4629                	li	a2,10
 7ee:	000aa583          	lw	a1,0(s5)
 7f2:	8552                	mv	a0,s4
 7f4:	00000097          	auipc	ra,0x0
 7f8:	e82080e7          	jalr	-382(ra) # 676 <printint>
 7fc:	8aa6                	mv	s5,s1
 7fe:	4901                	li	s2,0
 800:	bf95                	j	774 <vprintf+0x62>
 802:	008a8493          	addi	s1,s5,8
 806:	4681                	li	a3,0
 808:	4641                	li	a2,16
 80a:	000aa583          	lw	a1,0(s5)
 80e:	8552                	mv	a0,s4
 810:	00000097          	auipc	ra,0x0
 814:	e66080e7          	jalr	-410(ra) # 676 <printint>
 818:	8aa6                	mv	s5,s1
 81a:	4901                	li	s2,0
 81c:	bfa1                	j	774 <vprintf+0x62>
 81e:	008a8793          	addi	a5,s5,8
 822:	e43e                	sd	a5,8(sp)
 824:	000ab903          	ld	s2,0(s5)
 828:	03000593          	li	a1,48
 82c:	8552                	mv	a0,s4
 82e:	00000097          	auipc	ra,0x0
 832:	e2c080e7          	jalr	-468(ra) # 65a <putc>
 836:	85e6                	mv	a1,s9
 838:	8552                	mv	a0,s4
 83a:	00000097          	auipc	ra,0x0
 83e:	e20080e7          	jalr	-480(ra) # 65a <putc>
 842:	44c1                	li	s1,16
 844:	03c95793          	srli	a5,s2,0x3c
 848:	97da                	add	a5,a5,s6
 84a:	0007c583          	lbu	a1,0(a5)
 84e:	8552                	mv	a0,s4
 850:	00000097          	auipc	ra,0x0
 854:	e0a080e7          	jalr	-502(ra) # 65a <putc>
 858:	0912                	slli	s2,s2,0x4
 85a:	34fd                	addiw	s1,s1,-1
 85c:	f4e5                	bnez	s1,844 <vprintf+0x132>
 85e:	6aa2                	ld	s5,8(sp)
 860:	4901                	li	s2,0
 862:	bf09                	j	774 <vprintf+0x62>
 864:	008a8493          	addi	s1,s5,8
 868:	000ab903          	ld	s2,0(s5)
 86c:	02090163          	beqz	s2,88e <vprintf+0x17c>
 870:	00094583          	lbu	a1,0(s2)
 874:	c9a1                	beqz	a1,8c4 <vprintf+0x1b2>
 876:	8552                	mv	a0,s4
 878:	00000097          	auipc	ra,0x0
 87c:	de2080e7          	jalr	-542(ra) # 65a <putc>
 880:	0905                	addi	s2,s2,1
 882:	00094583          	lbu	a1,0(s2)
 886:	f9e5                	bnez	a1,876 <vprintf+0x164>
 888:	8aa6                	mv	s5,s1
 88a:	4901                	li	s2,0
 88c:	b5e5                	j	774 <vprintf+0x62>
 88e:	00000917          	auipc	s2,0x0
 892:	3a290913          	addi	s2,s2,930 # c30 <malloc+0x280>
 896:	02800593          	li	a1,40
 89a:	bff1                	j	876 <vprintf+0x164>
 89c:	008a8493          	addi	s1,s5,8
 8a0:	000ac583          	lbu	a1,0(s5)
 8a4:	8552                	mv	a0,s4
 8a6:	00000097          	auipc	ra,0x0
 8aa:	db4080e7          	jalr	-588(ra) # 65a <putc>
 8ae:	8aa6                	mv	s5,s1
 8b0:	4901                	li	s2,0
 8b2:	b5c9                	j	774 <vprintf+0x62>
 8b4:	85ce                	mv	a1,s3
 8b6:	8552                	mv	a0,s4
 8b8:	00000097          	auipc	ra,0x0
 8bc:	da2080e7          	jalr	-606(ra) # 65a <putc>
 8c0:	4901                	li	s2,0
 8c2:	bd4d                	j	774 <vprintf+0x62>
 8c4:	8aa6                	mv	s5,s1
 8c6:	4901                	li	s2,0
 8c8:	b575                	j	774 <vprintf+0x62>
 8ca:	70e6                	ld	ra,120(sp)
 8cc:	7446                	ld	s0,112(sp)
 8ce:	74a6                	ld	s1,104(sp)
 8d0:	7906                	ld	s2,96(sp)
 8d2:	69e6                	ld	s3,88(sp)
 8d4:	6a46                	ld	s4,80(sp)
 8d6:	6aa6                	ld	s5,72(sp)
 8d8:	6b06                	ld	s6,64(sp)
 8da:	7be2                	ld	s7,56(sp)
 8dc:	7c42                	ld	s8,48(sp)
 8de:	7ca2                	ld	s9,40(sp)
 8e0:	7d02                	ld	s10,32(sp)
 8e2:	6de2                	ld	s11,24(sp)
 8e4:	6109                	addi	sp,sp,128
 8e6:	8082                	ret

00000000000008e8 <fprintf>:
 8e8:	715d                	addi	sp,sp,-80
 8ea:	ec06                	sd	ra,24(sp)
 8ec:	f032                	sd	a2,32(sp)
 8ee:	f436                	sd	a3,40(sp)
 8f0:	f83a                	sd	a4,48(sp)
 8f2:	fc3e                	sd	a5,56(sp)
 8f4:	e0c2                	sd	a6,64(sp)
 8f6:	e4c6                	sd	a7,72(sp)
 8f8:	1010                	addi	a2,sp,32
 8fa:	e432                	sd	a2,8(sp)
 8fc:	00000097          	auipc	ra,0x0
 900:	e16080e7          	jalr	-490(ra) # 712 <vprintf>
 904:	60e2                	ld	ra,24(sp)
 906:	6161                	addi	sp,sp,80
 908:	8082                	ret

000000000000090a <printf>:
 90a:	711d                	addi	sp,sp,-96
 90c:	ec06                	sd	ra,24(sp)
 90e:	f42e                	sd	a1,40(sp)
 910:	f832                	sd	a2,48(sp)
 912:	fc36                	sd	a3,56(sp)
 914:	e0ba                	sd	a4,64(sp)
 916:	e4be                	sd	a5,72(sp)
 918:	e8c2                	sd	a6,80(sp)
 91a:	ecc6                	sd	a7,88(sp)
 91c:	1030                	addi	a2,sp,40
 91e:	e432                	sd	a2,8(sp)
 920:	85aa                	mv	a1,a0
 922:	4505                	li	a0,1
 924:	00000097          	auipc	ra,0x0
 928:	dee080e7          	jalr	-530(ra) # 712 <vprintf>
 92c:	60e2                	ld	ra,24(sp)
 92e:	6125                	addi	sp,sp,96
 930:	8082                	ret

0000000000000932 <free>:
 932:	ff050693          	addi	a3,a0,-16
 936:	00000797          	auipc	a5,0x0
 93a:	31a7b783          	ld	a5,794(a5) # c50 <freep>
 93e:	a805                	j	96e <free+0x3c>
 940:	4618                	lw	a4,8(a2)
 942:	9db9                	addw	a1,a1,a4
 944:	feb52c23          	sw	a1,-8(a0)
 948:	6398                	ld	a4,0(a5)
 94a:	6318                	ld	a4,0(a4)
 94c:	fee53823          	sd	a4,-16(a0)
 950:	a091                	j	994 <free+0x62>
 952:	ff852703          	lw	a4,-8(a0)
 956:	9e39                	addw	a2,a2,a4
 958:	c790                	sw	a2,8(a5)
 95a:	ff053703          	ld	a4,-16(a0)
 95e:	e398                	sd	a4,0(a5)
 960:	a099                	j	9a6 <free+0x74>
 962:	6398                	ld	a4,0(a5)
 964:	00e7e463          	bltu	a5,a4,96c <free+0x3a>
 968:	00e6ea63          	bltu	a3,a4,97c <free+0x4a>
 96c:	87ba                	mv	a5,a4
 96e:	fed7fae3          	bgeu	a5,a3,962 <free+0x30>
 972:	6398                	ld	a4,0(a5)
 974:	00e6e463          	bltu	a3,a4,97c <free+0x4a>
 978:	fee7eae3          	bltu	a5,a4,96c <free+0x3a>
 97c:	ff852583          	lw	a1,-8(a0)
 980:	6390                	ld	a2,0(a5)
 982:	02059713          	slli	a4,a1,0x20
 986:	9301                	srli	a4,a4,0x20
 988:	0712                	slli	a4,a4,0x4
 98a:	9736                	add	a4,a4,a3
 98c:	fae60ae3          	beq	a2,a4,940 <free+0xe>
 990:	fec53823          	sd	a2,-16(a0)
 994:	4790                	lw	a2,8(a5)
 996:	02061713          	slli	a4,a2,0x20
 99a:	9301                	srli	a4,a4,0x20
 99c:	0712                	slli	a4,a4,0x4
 99e:	973e                	add	a4,a4,a5
 9a0:	fae689e3          	beq	a3,a4,952 <free+0x20>
 9a4:	e394                	sd	a3,0(a5)
 9a6:	00000717          	auipc	a4,0x0
 9aa:	2af73523          	sd	a5,682(a4) # c50 <freep>
 9ae:	8082                	ret

00000000000009b0 <malloc>:
 9b0:	7139                	addi	sp,sp,-64
 9b2:	fc06                	sd	ra,56(sp)
 9b4:	f822                	sd	s0,48(sp)
 9b6:	f426                	sd	s1,40(sp)
 9b8:	f04a                	sd	s2,32(sp)
 9ba:	ec4e                	sd	s3,24(sp)
 9bc:	e852                	sd	s4,16(sp)
 9be:	e456                	sd	s5,8(sp)
 9c0:	02051413          	slli	s0,a0,0x20
 9c4:	9001                	srli	s0,s0,0x20
 9c6:	043d                	addi	s0,s0,15
 9c8:	8011                	srli	s0,s0,0x4
 9ca:	0014091b          	addiw	s2,s0,1
 9ce:	0405                	addi	s0,s0,1
 9d0:	00000517          	auipc	a0,0x0
 9d4:	28053503          	ld	a0,640(a0) # c50 <freep>
 9d8:	c905                	beqz	a0,a08 <malloc+0x58>
 9da:	611c                	ld	a5,0(a0)
 9dc:	4798                	lw	a4,8(a5)
 9de:	04877163          	bgeu	a4,s0,a20 <malloc+0x70>
 9e2:	89ca                	mv	s3,s2
 9e4:	0009071b          	sext.w	a4,s2
 9e8:	6685                	lui	a3,0x1
 9ea:	00d77363          	bgeu	a4,a3,9f0 <malloc+0x40>
 9ee:	6985                	lui	s3,0x1
 9f0:	00098a1b          	sext.w	s4,s3
 9f4:	1982                	slli	s3,s3,0x20
 9f6:	0209d993          	srli	s3,s3,0x20
 9fa:	0992                	slli	s3,s3,0x4
 9fc:	00000497          	auipc	s1,0x0
 a00:	25448493          	addi	s1,s1,596 # c50 <freep>
 a04:	5afd                	li	s5,-1
 a06:	a0bd                	j	a74 <malloc+0xc4>
 a08:	00000797          	auipc	a5,0x0
 a0c:	25078793          	addi	a5,a5,592 # c58 <base>
 a10:	00000717          	auipc	a4,0x0
 a14:	24f73023          	sd	a5,576(a4) # c50 <freep>
 a18:	e39c                	sd	a5,0(a5)
 a1a:	0007a423          	sw	zero,8(a5)
 a1e:	b7d1                	j	9e2 <malloc+0x32>
 a20:	02e40a63          	beq	s0,a4,a54 <malloc+0xa4>
 a24:	4127073b          	subw	a4,a4,s2
 a28:	c798                	sw	a4,8(a5)
 a2a:	1702                	slli	a4,a4,0x20
 a2c:	9301                	srli	a4,a4,0x20
 a2e:	0712                	slli	a4,a4,0x4
 a30:	97ba                	add	a5,a5,a4
 a32:	0127a423          	sw	s2,8(a5)
 a36:	00000717          	auipc	a4,0x0
 a3a:	20a73d23          	sd	a0,538(a4) # c50 <freep>
 a3e:	01078513          	addi	a0,a5,16
 a42:	70e2                	ld	ra,56(sp)
 a44:	7442                	ld	s0,48(sp)
 a46:	74a2                	ld	s1,40(sp)
 a48:	7902                	ld	s2,32(sp)
 a4a:	69e2                	ld	s3,24(sp)
 a4c:	6a42                	ld	s4,16(sp)
 a4e:	6aa2                	ld	s5,8(sp)
 a50:	6121                	addi	sp,sp,64
 a52:	8082                	ret
 a54:	6398                	ld	a4,0(a5)
 a56:	e118                	sd	a4,0(a0)
 a58:	bff9                	j	a36 <malloc+0x86>
 a5a:	01452423          	sw	s4,8(a0)
 a5e:	0541                	addi	a0,a0,16
 a60:	00000097          	auipc	ra,0x0
 a64:	ed2080e7          	jalr	-302(ra) # 932 <free>
 a68:	6088                	ld	a0,0(s1)
 a6a:	dd61                	beqz	a0,a42 <malloc+0x92>
 a6c:	611c                	ld	a5,0(a0)
 a6e:	4798                	lw	a4,8(a5)
 a70:	fa8778e3          	bgeu	a4,s0,a20 <malloc+0x70>
 a74:	6098                	ld	a4,0(s1)
 a76:	853e                	mv	a0,a5
 a78:	fef71ae3          	bne	a4,a5,a6c <malloc+0xbc>
 a7c:	854e                	mv	a0,s3
 a7e:	00000097          	auipc	ra,0x0
 a82:	8d8080e7          	jalr	-1832(ra) # 356 <sbrk>
 a86:	fd551ae3          	bne	a0,s5,a5a <malloc+0xaa>
 a8a:	4501                	li	a0,0
 a8c:	bf5d                	j	a42 <malloc+0x92>
