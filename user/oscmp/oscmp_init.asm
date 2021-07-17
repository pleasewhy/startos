
_oscmp_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_success>:
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	842a                	mv	s0,a0
   a:	00001517          	auipc	a0,0x1
   e:	a7650513          	addi	a0,a0,-1418 # a80 <malloc+0x11a>
  12:	00001097          	auipc	ra,0x1
  16:	8ae080e7          	jalr	-1874(ra) # 8c0 <printf>
  1a:	600c                	ld	a1,0(s0)
  1c:	cd99                	beqz	a1,3a <print_success+0x3a>
  1e:	0421                	addi	s0,s0,8
  20:	00001497          	auipc	s1,0x1
  24:	a7848493          	addi	s1,s1,-1416 # a98 <malloc+0x132>
  28:	8526                	mv	a0,s1
  2a:	00001097          	auipc	ra,0x1
  2e:	896080e7          	jalr	-1898(ra) # 8c0 <printf>
  32:	0421                	addi	s0,s0,8
  34:	ff843583          	ld	a1,-8(s0)
  38:	f9e5                	bnez	a1,28 <print_success+0x28>
  3a:	00001517          	auipc	a0,0x1
  3e:	a6650513          	addi	a0,a0,-1434 # aa0 <malloc+0x13a>
  42:	00001097          	auipc	ra,0x1
  46:	87e080e7          	jalr	-1922(ra) # 8c0 <printf>
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
  64:	294080e7          	jalr	660(ra) # 2f4 <fork>
  68:	ed09                	bnez	a0,82 <test+0x2e>
  6a:	4601                	li	a2,0
  6c:	85a2                	mv	a1,s0
  6e:	8526                	mv	a0,s1
  70:	00000097          	auipc	ra,0x0
  74:	3ac080e7          	jalr	940(ra) # 41c <execve>
  78:	70a2                	ld	ra,40(sp)
  7a:	7402                	ld	s0,32(sp)
  7c:	64e2                	ld	s1,24(sp)
  7e:	6145                	addi	sp,sp,48
  80:	8082                	ret
  82:	0068                	addi	a0,sp,12
  84:	00000097          	auipc	ra,0x0
  88:	278080e7          	jalr	632(ra) # 2fc <wait>
  8c:	47b2                	lw	a5,12(sp)
  8e:	fe07c5e3          	bltz	a5,78 <test+0x24>
  92:	8522                	mv	a0,s0
  94:	00000097          	auipc	ra,0x0
  98:	f6c080e7          	jalr	-148(ra) # 0 <print_success>
  9c:	bff1                	j	78 <test+0x24>

000000000000009e <main>:
  9e:	7149                	addi	sp,sp,-368
  a0:	f686                	sd	ra,360(sp)
  a2:	4589                	li	a1,2
  a4:	00001517          	auipc	a0,0x1
  a8:	a0c50513          	addi	a0,a0,-1524 # ab0 <malloc+0x14a>
  ac:	00000097          	auipc	ra,0x0
  b0:	258080e7          	jalr	600(ra) # 304 <open>
  b4:	4501                	li	a0,0
  b6:	00000097          	auipc	ra,0x0
  ba:	266080e7          	jalr	614(ra) # 31c <dup>
  be:	4501                	li	a0,0
  c0:	00000097          	auipc	ra,0x0
  c4:	25c080e7          	jalr	604(ra) # 31c <dup>
  c8:	00001797          	auipc	a5,0x1
  cc:	9f078793          	addi	a5,a5,-1552 # ab8 <malloc+0x152>
  d0:	e6be                	sd	a5,328(sp)
  d2:	00001797          	auipc	a5,0x1
  d6:	9ee78793          	addi	a5,a5,-1554 # ac0 <malloc+0x15a>
  da:	eabe                	sd	a5,336(sp)
  dc:	ee82                	sd	zero,344(sp)
  de:	00001797          	auipc	a5,0x1
  e2:	a9278793          	addi	a5,a5,-1390 # b70 <malloc+0x20a>
  e6:	638c                	ld	a1,0(a5)
  e8:	6790                	ld	a2,8(a5)
  ea:	6b94                	ld	a3,16(a5)
  ec:	6f98                	ld	a4,24(a5)
  ee:	f62e                	sd	a1,296(sp)
  f0:	fa32                	sd	a2,304(sp)
  f2:	fe36                	sd	a3,312(sp)
  f4:	e2ba                	sd	a4,320(sp)
  f6:	738c                	ld	a1,32(a5)
  f8:	7790                	ld	a2,40(a5)
  fa:	7b94                	ld	a3,48(a5)
  fc:	7f98                	ld	a4,56(a5)
  fe:	e62e                	sd	a1,264(sp)
 100:	ea32                	sd	a2,272(sp)
 102:	ee36                	sd	a3,280(sp)
 104:	f23a                	sd	a4,288(sp)
 106:	00001717          	auipc	a4,0x1
 10a:	9da70713          	addi	a4,a4,-1574 # ae0 <malloc+0x17a>
 10e:	f9ba                	sd	a4,240(sp)
 110:	00001717          	auipc	a4,0x1
 114:	9e070713          	addi	a4,a4,-1568 # af0 <malloc+0x18a>
 118:	fdba                	sd	a4,248(sp)
 11a:	e202                	sd	zero,256(sp)
 11c:	00001697          	auipc	a3,0x1
 120:	9e468693          	addi	a3,a3,-1564 # b00 <malloc+0x19a>
 124:	f1b6                	sd	a3,224(sp)
 126:	f582                	sd	zero,232(sp)
 128:	00001697          	auipc	a3,0x1
 12c:	9e068693          	addi	a3,a3,-1568 # b08 <malloc+0x1a2>
 130:	e9b6                	sd	a3,208(sp)
 132:	ed82                	sd	zero,216(sp)
 134:	00001697          	auipc	a3,0x1
 138:	9dc68693          	addi	a3,a3,-1572 # b10 <malloc+0x1aa>
 13c:	e1b6                	sd	a3,192(sp)
 13e:	e582                	sd	zero,200(sp)
 140:	00001697          	auipc	a3,0x1
 144:	9d868693          	addi	a3,a3,-1576 # b18 <malloc+0x1b2>
 148:	f536                	sd	a3,168(sp)
 14a:	f93a                	sd	a4,176(sp)
 14c:	fd02                	sd	zero,184(sp)
 14e:	63ac                	ld	a1,64(a5)
 150:	67b0                	ld	a2,72(a5)
 152:	6bb4                	ld	a3,80(a5)
 154:	6fb8                	ld	a4,88(a5)
 156:	73bc                	ld	a5,96(a5)
 158:	e12e                	sd	a1,128(sp)
 15a:	e532                	sd	a2,136(sp)
 15c:	e936                	sd	a3,144(sp)
 15e:	ed3a                	sd	a4,152(sp)
 160:	f13e                	sd	a5,160(sp)
 162:	00001797          	auipc	a5,0x1
 166:	9be78793          	addi	a5,a5,-1602 # b20 <malloc+0x1ba>
 16a:	f8be                	sd	a5,112(sp)
 16c:	fc82                	sd	zero,120(sp)
 16e:	00001797          	auipc	a5,0x1
 172:	9ba78793          	addi	a5,a5,-1606 # b28 <malloc+0x1c2>
 176:	f0be                	sd	a5,96(sp)
 178:	f482                	sd	zero,104(sp)
 17a:	00001797          	auipc	a5,0x1
 17e:	9b678793          	addi	a5,a5,-1610 # b30 <malloc+0x1ca>
 182:	e4be                	sd	a5,72(sp)
 184:	00001797          	auipc	a5,0x1
 188:	9b478793          	addi	a5,a5,-1612 # b38 <malloc+0x1d2>
 18c:	e8be                	sd	a5,80(sp)
 18e:	ec82                	sd	zero,88(sp)
 190:	00001797          	auipc	a5,0x1
 194:	9b078793          	addi	a5,a5,-1616 # b40 <malloc+0x1da>
 198:	fc3e                	sd	a5,56(sp)
 19a:	e082                	sd	zero,64(sp)
 19c:	00001797          	auipc	a5,0x1
 1a0:	9ac78793          	addi	a5,a5,-1620 # b48 <malloc+0x1e2>
 1a4:	f43e                	sd	a5,40(sp)
 1a6:	f802                	sd	zero,48(sp)
 1a8:	00001797          	auipc	a5,0x1
 1ac:	9a878793          	addi	a5,a5,-1624 # b50 <malloc+0x1ea>
 1b0:	ec3e                	sd	a5,24(sp)
 1b2:	f002                	sd	zero,32(sp)
 1b4:	00001797          	auipc	a5,0x1
 1b8:	9a478793          	addi	a5,a5,-1628 # b58 <malloc+0x1f2>
 1bc:	e03e                	sd	a5,0(sp)
 1be:	00001797          	auipc	a5,0x1
 1c2:	9a278793          	addi	a5,a5,-1630 # b60 <malloc+0x1fa>
 1c6:	e43e                	sd	a5,8(sp)
 1c8:	e802                	sd	zero,16(sp)
 1ca:	02ac                	addi	a1,sp,328
 1cc:	00001517          	auipc	a0,0x1
 1d0:	99c50513          	addi	a0,a0,-1636 # b68 <malloc+0x202>
 1d4:	00000097          	auipc	ra,0x0
 1d8:	e80080e7          	jalr	-384(ra) # 54 <test>
 1dc:	122c                	addi	a1,sp,296
 1de:	00001517          	auipc	a0,0x1
 1e2:	98a50513          	addi	a0,a0,-1654 # b68 <malloc+0x202>
 1e6:	00000097          	auipc	ra,0x0
 1ea:	e6e080e7          	jalr	-402(ra) # 54 <test>
 1ee:	022c                	addi	a1,sp,264
 1f0:	00001517          	auipc	a0,0x1
 1f4:	97850513          	addi	a0,a0,-1672 # b68 <malloc+0x202>
 1f8:	00000097          	auipc	ra,0x0
 1fc:	e5c080e7          	jalr	-420(ra) # 54 <test>
 200:	198c                	addi	a1,sp,240
 202:	00001517          	auipc	a0,0x1
 206:	96650513          	addi	a0,a0,-1690 # b68 <malloc+0x202>
 20a:	00000097          	auipc	ra,0x0
 20e:	e4a080e7          	jalr	-438(ra) # 54 <test>
 212:	118c                	addi	a1,sp,224
 214:	00001517          	auipc	a0,0x1
 218:	95450513          	addi	a0,a0,-1708 # b68 <malloc+0x202>
 21c:	00000097          	auipc	ra,0x0
 220:	e38080e7          	jalr	-456(ra) # 54 <test>
 224:	098c                	addi	a1,sp,208
 226:	00001517          	auipc	a0,0x1
 22a:	94250513          	addi	a0,a0,-1726 # b68 <malloc+0x202>
 22e:	00000097          	auipc	ra,0x0
 232:	e26080e7          	jalr	-474(ra) # 54 <test>
 236:	018c                	addi	a1,sp,192
 238:	00001517          	auipc	a0,0x1
 23c:	93050513          	addi	a0,a0,-1744 # b68 <malloc+0x202>
 240:	00000097          	auipc	ra,0x0
 244:	e14080e7          	jalr	-492(ra) # 54 <test>
 248:	112c                	addi	a1,sp,168
 24a:	00001517          	auipc	a0,0x1
 24e:	91e50513          	addi	a0,a0,-1762 # b68 <malloc+0x202>
 252:	00000097          	auipc	ra,0x0
 256:	e02080e7          	jalr	-510(ra) # 54 <test>
 25a:	010c                	addi	a1,sp,128
 25c:	00001517          	auipc	a0,0x1
 260:	90c50513          	addi	a0,a0,-1780 # b68 <malloc+0x202>
 264:	00000097          	auipc	ra,0x0
 268:	df0080e7          	jalr	-528(ra) # 54 <test>
 26c:	188c                	addi	a1,sp,112
 26e:	00001517          	auipc	a0,0x1
 272:	8fa50513          	addi	a0,a0,-1798 # b68 <malloc+0x202>
 276:	00000097          	auipc	ra,0x0
 27a:	dde080e7          	jalr	-546(ra) # 54 <test>
 27e:	108c                	addi	a1,sp,96
 280:	00001517          	auipc	a0,0x1
 284:	8e850513          	addi	a0,a0,-1816 # b68 <malloc+0x202>
 288:	00000097          	auipc	ra,0x0
 28c:	dcc080e7          	jalr	-564(ra) # 54 <test>
 290:	00ac                	addi	a1,sp,72
 292:	00001517          	auipc	a0,0x1
 296:	8d650513          	addi	a0,a0,-1834 # b68 <malloc+0x202>
 29a:	00000097          	auipc	ra,0x0
 29e:	dba080e7          	jalr	-582(ra) # 54 <test>
 2a2:	182c                	addi	a1,sp,56
 2a4:	00001517          	auipc	a0,0x1
 2a8:	8c450513          	addi	a0,a0,-1852 # b68 <malloc+0x202>
 2ac:	00000097          	auipc	ra,0x0
 2b0:	da8080e7          	jalr	-600(ra) # 54 <test>
 2b4:	102c                	addi	a1,sp,40
 2b6:	00001517          	auipc	a0,0x1
 2ba:	8b250513          	addi	a0,a0,-1870 # b68 <malloc+0x202>
 2be:	00000097          	auipc	ra,0x0
 2c2:	d96080e7          	jalr	-618(ra) # 54 <test>
 2c6:	082c                	addi	a1,sp,24
 2c8:	00001517          	auipc	a0,0x1
 2cc:	8a050513          	addi	a0,a0,-1888 # b68 <malloc+0x202>
 2d0:	00000097          	auipc	ra,0x0
 2d4:	d84080e7          	jalr	-636(ra) # 54 <test>
 2d8:	858a                	mv	a1,sp
 2da:	00001517          	auipc	a0,0x1
 2de:	88e50513          	addi	a0,a0,-1906 # b68 <malloc+0x202>
 2e2:	00000097          	auipc	ra,0x0
 2e6:	d72080e7          	jalr	-654(ra) # 54 <test>
 2ea:	00000097          	auipc	ra,0x0
 2ee:	150080e7          	jalr	336(ra) # 43a <kernel_panic>
 2f2:	a001                	j	2f2 <main+0x254>

00000000000002f4 <fork>:
 2f4:	4885                	li	a7,1
 2f6:	00000073          	ecall
 2fa:	8082                	ret

00000000000002fc <wait>:
 2fc:	488d                	li	a7,3
 2fe:	00000073          	ecall
 302:	8082                	ret

0000000000000304 <open>:
 304:	4889                	li	a7,2
 306:	00000073          	ecall
 30a:	8082                	ret

000000000000030c <sbrk>:
 30c:	4891                	li	a7,4
 30e:	00000073          	ecall
 312:	8082                	ret

0000000000000314 <getcwd>:
 314:	48c5                	li	a7,17
 316:	00000073          	ecall
 31a:	8082                	ret

000000000000031c <dup>:
 31c:	48dd                	li	a7,23
 31e:	00000073          	ecall
 322:	8082                	ret

0000000000000324 <dup3>:
 324:	48e1                	li	a7,24
 326:	00000073          	ecall
 32a:	8082                	ret

000000000000032c <mkdirat>:
 32c:	02200893          	li	a7,34
 330:	00000073          	ecall
 334:	8082                	ret

0000000000000336 <unlinkat>:
 336:	02300893          	li	a7,35
 33a:	00000073          	ecall
 33e:	8082                	ret

0000000000000340 <linkat>:
 340:	02500893          	li	a7,37
 344:	00000073          	ecall
 348:	8082                	ret

000000000000034a <umount2>:
 34a:	02700893          	li	a7,39
 34e:	00000073          	ecall
 352:	8082                	ret

0000000000000354 <mount>:
 354:	02800893          	li	a7,40
 358:	00000073          	ecall
 35c:	8082                	ret

000000000000035e <chdir>:
 35e:	03100893          	li	a7,49
 362:	00000073          	ecall
 366:	8082                	ret

0000000000000368 <openat>:
 368:	03800893          	li	a7,56
 36c:	00000073          	ecall
 370:	8082                	ret

0000000000000372 <close>:
 372:	03900893          	li	a7,57
 376:	00000073          	ecall
 37a:	8082                	ret

000000000000037c <pipe2>:
 37c:	03b00893          	li	a7,59
 380:	00000073          	ecall
 384:	8082                	ret

0000000000000386 <getdents64>:
 386:	03d00893          	li	a7,61
 38a:	00000073          	ecall
 38e:	8082                	ret

0000000000000390 <read>:
 390:	03f00893          	li	a7,63
 394:	00000073          	ecall
 398:	8082                	ret

000000000000039a <write>:
 39a:	04000893          	li	a7,64
 39e:	00000073          	ecall
 3a2:	8082                	ret

00000000000003a4 <fstat>:
 3a4:	05000893          	li	a7,80
 3a8:	00000073          	ecall
 3ac:	8082                	ret

00000000000003ae <exit>:
 3ae:	05d00893          	li	a7,93
 3b2:	00000073          	ecall
 3b6:	8082                	ret

00000000000003b8 <nanosleep>:
 3b8:	06500893          	li	a7,101
 3bc:	00000073          	ecall
 3c0:	8082                	ret

00000000000003c2 <sched_yield>:
 3c2:	07c00893          	li	a7,124
 3c6:	00000073          	ecall
 3ca:	8082                	ret

00000000000003cc <times>:
 3cc:	09900893          	li	a7,153
 3d0:	00000073          	ecall
 3d4:	8082                	ret

00000000000003d6 <uname>:
 3d6:	0a000893          	li	a7,160
 3da:	00000073          	ecall
 3de:	8082                	ret

00000000000003e0 <gettimeofday>:
 3e0:	0a900893          	li	a7,169
 3e4:	00000073          	ecall
 3e8:	8082                	ret

00000000000003ea <brk>:
 3ea:	0d600893          	li	a7,214
 3ee:	00000073          	ecall
 3f2:	8082                	ret

00000000000003f4 <munmap>:
 3f4:	0d700893          	li	a7,215
 3f8:	00000073          	ecall
 3fc:	8082                	ret

00000000000003fe <getpid>:
 3fe:	0ac00893          	li	a7,172
 402:	00000073          	ecall
 406:	8082                	ret

0000000000000408 <getppid>:
 408:	0ad00893          	li	a7,173
 40c:	00000073          	ecall
 410:	8082                	ret

0000000000000412 <clone>:
 412:	0dc00893          	li	a7,220
 416:	00000073          	ecall
 41a:	8082                	ret

000000000000041c <execve>:
 41c:	0dd00893          	li	a7,221
 420:	00000073          	ecall
 424:	8082                	ret

0000000000000426 <mmap>:
 426:	0de00893          	li	a7,222
 42a:	00000073          	ecall
 42e:	8082                	ret

0000000000000430 <wait4>:
 430:	10400893          	li	a7,260
 434:	00000073          	ecall
 438:	8082                	ret

000000000000043a <kernel_panic>:
 43a:	18f00893          	li	a7,399
 43e:	00000073          	ecall
 442:	8082                	ret

0000000000000444 <strcpy>:
 444:	87aa                	mv	a5,a0
 446:	0585                	addi	a1,a1,1
 448:	0785                	addi	a5,a5,1
 44a:	fff5c703          	lbu	a4,-1(a1)
 44e:	fee78fa3          	sb	a4,-1(a5)
 452:	fb75                	bnez	a4,446 <strcpy+0x2>
 454:	8082                	ret

0000000000000456 <strcmp>:
 456:	00054783          	lbu	a5,0(a0)
 45a:	cb91                	beqz	a5,46e <strcmp+0x18>
 45c:	0005c703          	lbu	a4,0(a1)
 460:	00f71763          	bne	a4,a5,46e <strcmp+0x18>
 464:	0505                	addi	a0,a0,1
 466:	0585                	addi	a1,a1,1
 468:	00054783          	lbu	a5,0(a0)
 46c:	fbe5                	bnez	a5,45c <strcmp+0x6>
 46e:	0005c503          	lbu	a0,0(a1)
 472:	40a7853b          	subw	a0,a5,a0
 476:	8082                	ret

0000000000000478 <strlen>:
 478:	00054783          	lbu	a5,0(a0)
 47c:	cf81                	beqz	a5,494 <strlen+0x1c>
 47e:	0505                	addi	a0,a0,1
 480:	87aa                	mv	a5,a0
 482:	4685                	li	a3,1
 484:	9e89                	subw	a3,a3,a0
 486:	00f6853b          	addw	a0,a3,a5
 48a:	0785                	addi	a5,a5,1
 48c:	fff7c703          	lbu	a4,-1(a5)
 490:	fb7d                	bnez	a4,486 <strlen+0xe>
 492:	8082                	ret
 494:	4501                	li	a0,0
 496:	8082                	ret

0000000000000498 <memset>:
 498:	ce09                	beqz	a2,4b2 <memset+0x1a>
 49a:	87aa                	mv	a5,a0
 49c:	fff6071b          	addiw	a4,a2,-1
 4a0:	1702                	slli	a4,a4,0x20
 4a2:	9301                	srli	a4,a4,0x20
 4a4:	0705                	addi	a4,a4,1
 4a6:	972a                	add	a4,a4,a0
 4a8:	00b78023          	sb	a1,0(a5)
 4ac:	0785                	addi	a5,a5,1
 4ae:	fee79de3          	bne	a5,a4,4a8 <memset+0x10>
 4b2:	8082                	ret

00000000000004b4 <strchr>:
 4b4:	00054783          	lbu	a5,0(a0)
 4b8:	cb89                	beqz	a5,4ca <strchr+0x16>
 4ba:	00f58963          	beq	a1,a5,4cc <strchr+0x18>
 4be:	0505                	addi	a0,a0,1
 4c0:	00054783          	lbu	a5,0(a0)
 4c4:	fbfd                	bnez	a5,4ba <strchr+0x6>
 4c6:	4501                	li	a0,0
 4c8:	8082                	ret
 4ca:	4501                	li	a0,0
 4cc:	8082                	ret

00000000000004ce <gets>:
 4ce:	715d                	addi	sp,sp,-80
 4d0:	e486                	sd	ra,72(sp)
 4d2:	e0a2                	sd	s0,64(sp)
 4d4:	fc26                	sd	s1,56(sp)
 4d6:	f84a                	sd	s2,48(sp)
 4d8:	f44e                	sd	s3,40(sp)
 4da:	f052                	sd	s4,32(sp)
 4dc:	ec56                	sd	s5,24(sp)
 4de:	e85a                	sd	s6,16(sp)
 4e0:	8b2a                	mv	s6,a0
 4e2:	89ae                	mv	s3,a1
 4e4:	84aa                	mv	s1,a0
 4e6:	4401                	li	s0,0
 4e8:	4a29                	li	s4,10
 4ea:	4ab5                	li	s5,13
 4ec:	8922                	mv	s2,s0
 4ee:	2405                	addiw	s0,s0,1
 4f0:	03345863          	bge	s0,s3,520 <gets+0x52>
 4f4:	4605                	li	a2,1
 4f6:	00f10593          	addi	a1,sp,15
 4fa:	4501                	li	a0,0
 4fc:	00000097          	auipc	ra,0x0
 500:	e94080e7          	jalr	-364(ra) # 390 <read>
 504:	00a05e63          	blez	a0,520 <gets+0x52>
 508:	00f14783          	lbu	a5,15(sp)
 50c:	00f48023          	sb	a5,0(s1)
 510:	01478763          	beq	a5,s4,51e <gets+0x50>
 514:	0485                	addi	s1,s1,1
 516:	fd579be3          	bne	a5,s5,4ec <gets+0x1e>
 51a:	8922                	mv	s2,s0
 51c:	a011                	j	520 <gets+0x52>
 51e:	8922                	mv	s2,s0
 520:	995a                	add	s2,s2,s6
 522:	00090023          	sb	zero,0(s2)
 526:	855a                	mv	a0,s6
 528:	60a6                	ld	ra,72(sp)
 52a:	6406                	ld	s0,64(sp)
 52c:	74e2                	ld	s1,56(sp)
 52e:	7942                	ld	s2,48(sp)
 530:	79a2                	ld	s3,40(sp)
 532:	7a02                	ld	s4,32(sp)
 534:	6ae2                	ld	s5,24(sp)
 536:	6b42                	ld	s6,16(sp)
 538:	6161                	addi	sp,sp,80
 53a:	8082                	ret

000000000000053c <atoi>:
 53c:	86aa                	mv	a3,a0
 53e:	00054603          	lbu	a2,0(a0)
 542:	fd06079b          	addiw	a5,a2,-48
 546:	0ff7f793          	andi	a5,a5,255
 54a:	4725                	li	a4,9
 54c:	02f76663          	bltu	a4,a5,578 <atoi+0x3c>
 550:	4501                	li	a0,0
 552:	45a5                	li	a1,9
 554:	0685                	addi	a3,a3,1
 556:	0025179b          	slliw	a5,a0,0x2
 55a:	9fa9                	addw	a5,a5,a0
 55c:	0017979b          	slliw	a5,a5,0x1
 560:	9fb1                	addw	a5,a5,a2
 562:	fd07851b          	addiw	a0,a5,-48
 566:	0006c603          	lbu	a2,0(a3)
 56a:	fd06071b          	addiw	a4,a2,-48
 56e:	0ff77713          	andi	a4,a4,255
 572:	fee5f1e3          	bgeu	a1,a4,554 <atoi+0x18>
 576:	8082                	ret
 578:	4501                	li	a0,0
 57a:	8082                	ret

000000000000057c <memmove>:
 57c:	02b57463          	bgeu	a0,a1,5a4 <memmove+0x28>
 580:	04c05663          	blez	a2,5cc <memmove+0x50>
 584:	fff6079b          	addiw	a5,a2,-1
 588:	1782                	slli	a5,a5,0x20
 58a:	9381                	srli	a5,a5,0x20
 58c:	0785                	addi	a5,a5,1
 58e:	97aa                	add	a5,a5,a0
 590:	872a                	mv	a4,a0
 592:	0585                	addi	a1,a1,1
 594:	0705                	addi	a4,a4,1
 596:	fff5c683          	lbu	a3,-1(a1)
 59a:	fed70fa3          	sb	a3,-1(a4)
 59e:	fee79ae3          	bne	a5,a4,592 <memmove+0x16>
 5a2:	8082                	ret
 5a4:	00c50733          	add	a4,a0,a2
 5a8:	95b2                	add	a1,a1,a2
 5aa:	02c05163          	blez	a2,5cc <memmove+0x50>
 5ae:	fff6079b          	addiw	a5,a2,-1
 5b2:	1782                	slli	a5,a5,0x20
 5b4:	9381                	srli	a5,a5,0x20
 5b6:	fff7c793          	not	a5,a5
 5ba:	97ba                	add	a5,a5,a4
 5bc:	15fd                	addi	a1,a1,-1
 5be:	177d                	addi	a4,a4,-1
 5c0:	0005c683          	lbu	a3,0(a1)
 5c4:	00d70023          	sb	a3,0(a4)
 5c8:	fee79ae3          	bne	a5,a4,5bc <memmove+0x40>
 5cc:	8082                	ret

00000000000005ce <memcmp>:
 5ce:	fff6069b          	addiw	a3,a2,-1
 5d2:	c605                	beqz	a2,5fa <memcmp+0x2c>
 5d4:	1682                	slli	a3,a3,0x20
 5d6:	9281                	srli	a3,a3,0x20
 5d8:	0685                	addi	a3,a3,1
 5da:	96aa                	add	a3,a3,a0
 5dc:	00054783          	lbu	a5,0(a0)
 5e0:	0005c703          	lbu	a4,0(a1)
 5e4:	00e79863          	bne	a5,a4,5f4 <memcmp+0x26>
 5e8:	0505                	addi	a0,a0,1
 5ea:	0585                	addi	a1,a1,1
 5ec:	fed518e3          	bne	a0,a3,5dc <memcmp+0xe>
 5f0:	4501                	li	a0,0
 5f2:	8082                	ret
 5f4:	40e7853b          	subw	a0,a5,a4
 5f8:	8082                	ret
 5fa:	4501                	li	a0,0
 5fc:	8082                	ret

00000000000005fe <memcpy>:
 5fe:	1141                	addi	sp,sp,-16
 600:	e406                	sd	ra,8(sp)
 602:	00000097          	auipc	ra,0x0
 606:	f7a080e7          	jalr	-134(ra) # 57c <memmove>
 60a:	60a2                	ld	ra,8(sp)
 60c:	0141                	addi	sp,sp,16
 60e:	8082                	ret

0000000000000610 <putc>:
 610:	1101                	addi	sp,sp,-32
 612:	ec06                	sd	ra,24(sp)
 614:	00b107a3          	sb	a1,15(sp)
 618:	4605                	li	a2,1
 61a:	00f10593          	addi	a1,sp,15
 61e:	00000097          	auipc	ra,0x0
 622:	d7c080e7          	jalr	-644(ra) # 39a <write>
 626:	60e2                	ld	ra,24(sp)
 628:	6105                	addi	sp,sp,32
 62a:	8082                	ret

000000000000062c <printint>:
 62c:	7179                	addi	sp,sp,-48
 62e:	f406                	sd	ra,40(sp)
 630:	f022                	sd	s0,32(sp)
 632:	ec26                	sd	s1,24(sp)
 634:	e84a                	sd	s2,16(sp)
 636:	84aa                	mv	s1,a0
 638:	c299                	beqz	a3,63e <printint+0x12>
 63a:	0805c363          	bltz	a1,6c0 <printint+0x94>
 63e:	2581                	sext.w	a1,a1
 640:	4881                	li	a7,0
 642:	868a                	mv	a3,sp
 644:	4701                	li	a4,0
 646:	2601                	sext.w	a2,a2
 648:	00000517          	auipc	a0,0x0
 64c:	59850513          	addi	a0,a0,1432 # be0 <digits>
 650:	883a                	mv	a6,a4
 652:	2705                	addiw	a4,a4,1
 654:	02c5f7bb          	remuw	a5,a1,a2
 658:	1782                	slli	a5,a5,0x20
 65a:	9381                	srli	a5,a5,0x20
 65c:	97aa                	add	a5,a5,a0
 65e:	0007c783          	lbu	a5,0(a5)
 662:	00f68023          	sb	a5,0(a3)
 666:	0005879b          	sext.w	a5,a1
 66a:	02c5d5bb          	divuw	a1,a1,a2
 66e:	0685                	addi	a3,a3,1
 670:	fec7f0e3          	bgeu	a5,a2,650 <printint+0x24>
 674:	00088a63          	beqz	a7,688 <printint+0x5c>
 678:	081c                	addi	a5,sp,16
 67a:	973e                	add	a4,a4,a5
 67c:	02d00793          	li	a5,45
 680:	fef70823          	sb	a5,-16(a4)
 684:	0028071b          	addiw	a4,a6,2
 688:	02e05663          	blez	a4,6b4 <printint+0x88>
 68c:	00e10433          	add	s0,sp,a4
 690:	fff10913          	addi	s2,sp,-1
 694:	993a                	add	s2,s2,a4
 696:	377d                	addiw	a4,a4,-1
 698:	1702                	slli	a4,a4,0x20
 69a:	9301                	srli	a4,a4,0x20
 69c:	40e90933          	sub	s2,s2,a4
 6a0:	fff44583          	lbu	a1,-1(s0)
 6a4:	8526                	mv	a0,s1
 6a6:	00000097          	auipc	ra,0x0
 6aa:	f6a080e7          	jalr	-150(ra) # 610 <putc>
 6ae:	147d                	addi	s0,s0,-1
 6b0:	ff2418e3          	bne	s0,s2,6a0 <printint+0x74>
 6b4:	70a2                	ld	ra,40(sp)
 6b6:	7402                	ld	s0,32(sp)
 6b8:	64e2                	ld	s1,24(sp)
 6ba:	6942                	ld	s2,16(sp)
 6bc:	6145                	addi	sp,sp,48
 6be:	8082                	ret
 6c0:	40b005bb          	negw	a1,a1
 6c4:	4885                	li	a7,1
 6c6:	bfb5                	j	642 <printint+0x16>

00000000000006c8 <vprintf>:
 6c8:	7119                	addi	sp,sp,-128
 6ca:	fc86                	sd	ra,120(sp)
 6cc:	f8a2                	sd	s0,112(sp)
 6ce:	f4a6                	sd	s1,104(sp)
 6d0:	f0ca                	sd	s2,96(sp)
 6d2:	ecce                	sd	s3,88(sp)
 6d4:	e8d2                	sd	s4,80(sp)
 6d6:	e4d6                	sd	s5,72(sp)
 6d8:	e0da                	sd	s6,64(sp)
 6da:	fc5e                	sd	s7,56(sp)
 6dc:	f862                	sd	s8,48(sp)
 6de:	f466                	sd	s9,40(sp)
 6e0:	f06a                	sd	s10,32(sp)
 6e2:	ec6e                	sd	s11,24(sp)
 6e4:	0005c483          	lbu	s1,0(a1)
 6e8:	18048c63          	beqz	s1,880 <vprintf+0x1b8>
 6ec:	8a2a                	mv	s4,a0
 6ee:	8ab2                	mv	s5,a2
 6f0:	00158413          	addi	s0,a1,1
 6f4:	4901                	li	s2,0
 6f6:	02500993          	li	s3,37
 6fa:	06400b93          	li	s7,100
 6fe:	06c00c13          	li	s8,108
 702:	07800c93          	li	s9,120
 706:	07000d13          	li	s10,112
 70a:	07300d93          	li	s11,115
 70e:	00000b17          	auipc	s6,0x0
 712:	4d2b0b13          	addi	s6,s6,1234 # be0 <digits>
 716:	a839                	j	734 <vprintf+0x6c>
 718:	85a6                	mv	a1,s1
 71a:	8552                	mv	a0,s4
 71c:	00000097          	auipc	ra,0x0
 720:	ef4080e7          	jalr	-268(ra) # 610 <putc>
 724:	a019                	j	72a <vprintf+0x62>
 726:	01390f63          	beq	s2,s3,744 <vprintf+0x7c>
 72a:	0405                	addi	s0,s0,1
 72c:	fff44483          	lbu	s1,-1(s0)
 730:	14048863          	beqz	s1,880 <vprintf+0x1b8>
 734:	0004879b          	sext.w	a5,s1
 738:	fe0917e3          	bnez	s2,726 <vprintf+0x5e>
 73c:	fd379ee3          	bne	a5,s3,718 <vprintf+0x50>
 740:	893e                	mv	s2,a5
 742:	b7e5                	j	72a <vprintf+0x62>
 744:	03778e63          	beq	a5,s7,780 <vprintf+0xb8>
 748:	05878a63          	beq	a5,s8,79c <vprintf+0xd4>
 74c:	07978663          	beq	a5,s9,7b8 <vprintf+0xf0>
 750:	09a78263          	beq	a5,s10,7d4 <vprintf+0x10c>
 754:	0db78363          	beq	a5,s11,81a <vprintf+0x152>
 758:	06300713          	li	a4,99
 75c:	0ee78b63          	beq	a5,a4,852 <vprintf+0x18a>
 760:	11378563          	beq	a5,s3,86a <vprintf+0x1a2>
 764:	85ce                	mv	a1,s3
 766:	8552                	mv	a0,s4
 768:	00000097          	auipc	ra,0x0
 76c:	ea8080e7          	jalr	-344(ra) # 610 <putc>
 770:	85a6                	mv	a1,s1
 772:	8552                	mv	a0,s4
 774:	00000097          	auipc	ra,0x0
 778:	e9c080e7          	jalr	-356(ra) # 610 <putc>
 77c:	4901                	li	s2,0
 77e:	b775                	j	72a <vprintf+0x62>
 780:	008a8493          	addi	s1,s5,8
 784:	4685                	li	a3,1
 786:	4629                	li	a2,10
 788:	000aa583          	lw	a1,0(s5)
 78c:	8552                	mv	a0,s4
 78e:	00000097          	auipc	ra,0x0
 792:	e9e080e7          	jalr	-354(ra) # 62c <printint>
 796:	8aa6                	mv	s5,s1
 798:	4901                	li	s2,0
 79a:	bf41                	j	72a <vprintf+0x62>
 79c:	008a8493          	addi	s1,s5,8
 7a0:	4681                	li	a3,0
 7a2:	4629                	li	a2,10
 7a4:	000aa583          	lw	a1,0(s5)
 7a8:	8552                	mv	a0,s4
 7aa:	00000097          	auipc	ra,0x0
 7ae:	e82080e7          	jalr	-382(ra) # 62c <printint>
 7b2:	8aa6                	mv	s5,s1
 7b4:	4901                	li	s2,0
 7b6:	bf95                	j	72a <vprintf+0x62>
 7b8:	008a8493          	addi	s1,s5,8
 7bc:	4681                	li	a3,0
 7be:	4641                	li	a2,16
 7c0:	000aa583          	lw	a1,0(s5)
 7c4:	8552                	mv	a0,s4
 7c6:	00000097          	auipc	ra,0x0
 7ca:	e66080e7          	jalr	-410(ra) # 62c <printint>
 7ce:	8aa6                	mv	s5,s1
 7d0:	4901                	li	s2,0
 7d2:	bfa1                	j	72a <vprintf+0x62>
 7d4:	008a8793          	addi	a5,s5,8
 7d8:	e43e                	sd	a5,8(sp)
 7da:	000ab903          	ld	s2,0(s5)
 7de:	03000593          	li	a1,48
 7e2:	8552                	mv	a0,s4
 7e4:	00000097          	auipc	ra,0x0
 7e8:	e2c080e7          	jalr	-468(ra) # 610 <putc>
 7ec:	85e6                	mv	a1,s9
 7ee:	8552                	mv	a0,s4
 7f0:	00000097          	auipc	ra,0x0
 7f4:	e20080e7          	jalr	-480(ra) # 610 <putc>
 7f8:	44c1                	li	s1,16
 7fa:	03c95793          	srli	a5,s2,0x3c
 7fe:	97da                	add	a5,a5,s6
 800:	0007c583          	lbu	a1,0(a5)
 804:	8552                	mv	a0,s4
 806:	00000097          	auipc	ra,0x0
 80a:	e0a080e7          	jalr	-502(ra) # 610 <putc>
 80e:	0912                	slli	s2,s2,0x4
 810:	34fd                	addiw	s1,s1,-1
 812:	f4e5                	bnez	s1,7fa <vprintf+0x132>
 814:	6aa2                	ld	s5,8(sp)
 816:	4901                	li	s2,0
 818:	bf09                	j	72a <vprintf+0x62>
 81a:	008a8493          	addi	s1,s5,8
 81e:	000ab903          	ld	s2,0(s5)
 822:	02090163          	beqz	s2,844 <vprintf+0x17c>
 826:	00094583          	lbu	a1,0(s2)
 82a:	c9a1                	beqz	a1,87a <vprintf+0x1b2>
 82c:	8552                	mv	a0,s4
 82e:	00000097          	auipc	ra,0x0
 832:	de2080e7          	jalr	-542(ra) # 610 <putc>
 836:	0905                	addi	s2,s2,1
 838:	00094583          	lbu	a1,0(s2)
 83c:	f9e5                	bnez	a1,82c <vprintf+0x164>
 83e:	8aa6                	mv	s5,s1
 840:	4901                	li	s2,0
 842:	b5e5                	j	72a <vprintf+0x62>
 844:	00000917          	auipc	s2,0x0
 848:	39490913          	addi	s2,s2,916 # bd8 <malloc+0x272>
 84c:	02800593          	li	a1,40
 850:	bff1                	j	82c <vprintf+0x164>
 852:	008a8493          	addi	s1,s5,8
 856:	000ac583          	lbu	a1,0(s5)
 85a:	8552                	mv	a0,s4
 85c:	00000097          	auipc	ra,0x0
 860:	db4080e7          	jalr	-588(ra) # 610 <putc>
 864:	8aa6                	mv	s5,s1
 866:	4901                	li	s2,0
 868:	b5c9                	j	72a <vprintf+0x62>
 86a:	85ce                	mv	a1,s3
 86c:	8552                	mv	a0,s4
 86e:	00000097          	auipc	ra,0x0
 872:	da2080e7          	jalr	-606(ra) # 610 <putc>
 876:	4901                	li	s2,0
 878:	bd4d                	j	72a <vprintf+0x62>
 87a:	8aa6                	mv	s5,s1
 87c:	4901                	li	s2,0
 87e:	b575                	j	72a <vprintf+0x62>
 880:	70e6                	ld	ra,120(sp)
 882:	7446                	ld	s0,112(sp)
 884:	74a6                	ld	s1,104(sp)
 886:	7906                	ld	s2,96(sp)
 888:	69e6                	ld	s3,88(sp)
 88a:	6a46                	ld	s4,80(sp)
 88c:	6aa6                	ld	s5,72(sp)
 88e:	6b06                	ld	s6,64(sp)
 890:	7be2                	ld	s7,56(sp)
 892:	7c42                	ld	s8,48(sp)
 894:	7ca2                	ld	s9,40(sp)
 896:	7d02                	ld	s10,32(sp)
 898:	6de2                	ld	s11,24(sp)
 89a:	6109                	addi	sp,sp,128
 89c:	8082                	ret

000000000000089e <fprintf>:
 89e:	715d                	addi	sp,sp,-80
 8a0:	ec06                	sd	ra,24(sp)
 8a2:	f032                	sd	a2,32(sp)
 8a4:	f436                	sd	a3,40(sp)
 8a6:	f83a                	sd	a4,48(sp)
 8a8:	fc3e                	sd	a5,56(sp)
 8aa:	e0c2                	sd	a6,64(sp)
 8ac:	e4c6                	sd	a7,72(sp)
 8ae:	1010                	addi	a2,sp,32
 8b0:	e432                	sd	a2,8(sp)
 8b2:	00000097          	auipc	ra,0x0
 8b6:	e16080e7          	jalr	-490(ra) # 6c8 <vprintf>
 8ba:	60e2                	ld	ra,24(sp)
 8bc:	6161                	addi	sp,sp,80
 8be:	8082                	ret

00000000000008c0 <printf>:
 8c0:	711d                	addi	sp,sp,-96
 8c2:	ec06                	sd	ra,24(sp)
 8c4:	f42e                	sd	a1,40(sp)
 8c6:	f832                	sd	a2,48(sp)
 8c8:	fc36                	sd	a3,56(sp)
 8ca:	e0ba                	sd	a4,64(sp)
 8cc:	e4be                	sd	a5,72(sp)
 8ce:	e8c2                	sd	a6,80(sp)
 8d0:	ecc6                	sd	a7,88(sp)
 8d2:	1030                	addi	a2,sp,40
 8d4:	e432                	sd	a2,8(sp)
 8d6:	85aa                	mv	a1,a0
 8d8:	4505                	li	a0,1
 8da:	00000097          	auipc	ra,0x0
 8de:	dee080e7          	jalr	-530(ra) # 6c8 <vprintf>
 8e2:	60e2                	ld	ra,24(sp)
 8e4:	6125                	addi	sp,sp,96
 8e6:	8082                	ret

00000000000008e8 <free>:
 8e8:	ff050693          	addi	a3,a0,-16
 8ec:	00000797          	auipc	a5,0x0
 8f0:	30c7b783          	ld	a5,780(a5) # bf8 <freep>
 8f4:	a805                	j	924 <free+0x3c>
 8f6:	4618                	lw	a4,8(a2)
 8f8:	9db9                	addw	a1,a1,a4
 8fa:	feb52c23          	sw	a1,-8(a0)
 8fe:	6398                	ld	a4,0(a5)
 900:	6318                	ld	a4,0(a4)
 902:	fee53823          	sd	a4,-16(a0)
 906:	a091                	j	94a <free+0x62>
 908:	ff852703          	lw	a4,-8(a0)
 90c:	9e39                	addw	a2,a2,a4
 90e:	c790                	sw	a2,8(a5)
 910:	ff053703          	ld	a4,-16(a0)
 914:	e398                	sd	a4,0(a5)
 916:	a099                	j	95c <free+0x74>
 918:	6398                	ld	a4,0(a5)
 91a:	00e7e463          	bltu	a5,a4,922 <free+0x3a>
 91e:	00e6ea63          	bltu	a3,a4,932 <free+0x4a>
 922:	87ba                	mv	a5,a4
 924:	fed7fae3          	bgeu	a5,a3,918 <free+0x30>
 928:	6398                	ld	a4,0(a5)
 92a:	00e6e463          	bltu	a3,a4,932 <free+0x4a>
 92e:	fee7eae3          	bltu	a5,a4,922 <free+0x3a>
 932:	ff852583          	lw	a1,-8(a0)
 936:	6390                	ld	a2,0(a5)
 938:	02059713          	slli	a4,a1,0x20
 93c:	9301                	srli	a4,a4,0x20
 93e:	0712                	slli	a4,a4,0x4
 940:	9736                	add	a4,a4,a3
 942:	fae60ae3          	beq	a2,a4,8f6 <free+0xe>
 946:	fec53823          	sd	a2,-16(a0)
 94a:	4790                	lw	a2,8(a5)
 94c:	02061713          	slli	a4,a2,0x20
 950:	9301                	srli	a4,a4,0x20
 952:	0712                	slli	a4,a4,0x4
 954:	973e                	add	a4,a4,a5
 956:	fae689e3          	beq	a3,a4,908 <free+0x20>
 95a:	e394                	sd	a3,0(a5)
 95c:	00000717          	auipc	a4,0x0
 960:	28f73e23          	sd	a5,668(a4) # bf8 <freep>
 964:	8082                	ret

0000000000000966 <malloc>:
 966:	7139                	addi	sp,sp,-64
 968:	fc06                	sd	ra,56(sp)
 96a:	f822                	sd	s0,48(sp)
 96c:	f426                	sd	s1,40(sp)
 96e:	f04a                	sd	s2,32(sp)
 970:	ec4e                	sd	s3,24(sp)
 972:	e852                	sd	s4,16(sp)
 974:	e456                	sd	s5,8(sp)
 976:	02051413          	slli	s0,a0,0x20
 97a:	9001                	srli	s0,s0,0x20
 97c:	043d                	addi	s0,s0,15
 97e:	8011                	srli	s0,s0,0x4
 980:	0014091b          	addiw	s2,s0,1
 984:	0405                	addi	s0,s0,1
 986:	00000517          	auipc	a0,0x0
 98a:	27253503          	ld	a0,626(a0) # bf8 <freep>
 98e:	c905                	beqz	a0,9be <malloc+0x58>
 990:	611c                	ld	a5,0(a0)
 992:	4798                	lw	a4,8(a5)
 994:	04877163          	bgeu	a4,s0,9d6 <malloc+0x70>
 998:	89ca                	mv	s3,s2
 99a:	0009071b          	sext.w	a4,s2
 99e:	6685                	lui	a3,0x1
 9a0:	00d77363          	bgeu	a4,a3,9a6 <malloc+0x40>
 9a4:	6985                	lui	s3,0x1
 9a6:	00098a1b          	sext.w	s4,s3
 9aa:	1982                	slli	s3,s3,0x20
 9ac:	0209d993          	srli	s3,s3,0x20
 9b0:	0992                	slli	s3,s3,0x4
 9b2:	00000497          	auipc	s1,0x0
 9b6:	24648493          	addi	s1,s1,582 # bf8 <freep>
 9ba:	5afd                	li	s5,-1
 9bc:	a0bd                	j	a2a <malloc+0xc4>
 9be:	00000797          	auipc	a5,0x0
 9c2:	24278793          	addi	a5,a5,578 # c00 <base>
 9c6:	00000717          	auipc	a4,0x0
 9ca:	22f73923          	sd	a5,562(a4) # bf8 <freep>
 9ce:	e39c                	sd	a5,0(a5)
 9d0:	0007a423          	sw	zero,8(a5)
 9d4:	b7d1                	j	998 <malloc+0x32>
 9d6:	02e40a63          	beq	s0,a4,a0a <malloc+0xa4>
 9da:	4127073b          	subw	a4,a4,s2
 9de:	c798                	sw	a4,8(a5)
 9e0:	1702                	slli	a4,a4,0x20
 9e2:	9301                	srli	a4,a4,0x20
 9e4:	0712                	slli	a4,a4,0x4
 9e6:	97ba                	add	a5,a5,a4
 9e8:	0127a423          	sw	s2,8(a5)
 9ec:	00000717          	auipc	a4,0x0
 9f0:	20a73623          	sd	a0,524(a4) # bf8 <freep>
 9f4:	01078513          	addi	a0,a5,16
 9f8:	70e2                	ld	ra,56(sp)
 9fa:	7442                	ld	s0,48(sp)
 9fc:	74a2                	ld	s1,40(sp)
 9fe:	7902                	ld	s2,32(sp)
 a00:	69e2                	ld	s3,24(sp)
 a02:	6a42                	ld	s4,16(sp)
 a04:	6aa2                	ld	s5,8(sp)
 a06:	6121                	addi	sp,sp,64
 a08:	8082                	ret
 a0a:	6398                	ld	a4,0(a5)
 a0c:	e118                	sd	a4,0(a0)
 a0e:	bff9                	j	9ec <malloc+0x86>
 a10:	01452423          	sw	s4,8(a0)
 a14:	0541                	addi	a0,a0,16
 a16:	00000097          	auipc	ra,0x0
 a1a:	ed2080e7          	jalr	-302(ra) # 8e8 <free>
 a1e:	6088                	ld	a0,0(s1)
 a20:	dd61                	beqz	a0,9f8 <malloc+0x92>
 a22:	611c                	ld	a5,0(a0)
 a24:	4798                	lw	a4,8(a5)
 a26:	fa8778e3          	bgeu	a4,s0,9d6 <malloc+0x70>
 a2a:	6098                	ld	a4,0(s1)
 a2c:	853e                	mv	a0,a5
 a2e:	fef71ae3          	bne	a4,a5,a22 <malloc+0xbc>
 a32:	854e                	mv	a0,s3
 a34:	00000097          	auipc	ra,0x0
 a38:	8d8080e7          	jalr	-1832(ra) # 30c <sbrk>
 a3c:	fd551ae3          	bne	a0,s5,a10 <malloc+0xaa>
 a40:	4501                	li	a0,0
 a42:	bf5d                	j	9f8 <malloc+0x92>
