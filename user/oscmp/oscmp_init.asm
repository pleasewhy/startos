
_oscmp_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_success>:
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	842a                	mv	s0,a0
   a:	00001517          	auipc	a0,0x1
   e:	9e650513          	addi	a0,a0,-1562 # 9f0 <malloc+0x116>
  12:	00001097          	auipc	ra,0x1
  16:	822080e7          	jalr	-2014(ra) # 834 <printf>
  1a:	600c                	ld	a1,0(s0)
  1c:	cd99                	beqz	a1,3a <print_success+0x3a>
  1e:	0421                	addi	s0,s0,8
  20:	00001497          	auipc	s1,0x1
  24:	9e848493          	addi	s1,s1,-1560 # a08 <malloc+0x12e>
  28:	8526                	mv	a0,s1
  2a:	00001097          	auipc	ra,0x1
  2e:	80a080e7          	jalr	-2038(ra) # 834 <printf>
  32:	0421                	addi	s0,s0,8
  34:	ff843583          	ld	a1,-8(s0)
  38:	f9e5                	bnez	a1,28 <print_success+0x28>
  3a:	00001517          	auipc	a0,0x1
  3e:	9d650513          	addi	a0,a0,-1578 # a10 <malloc+0x136>
  42:	00000097          	auipc	ra,0x0
  46:	7f2080e7          	jalr	2034(ra) # 834 <printf>
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
  64:	208080e7          	jalr	520(ra) # 268 <fork>
  68:	ed09                	bnez	a0,82 <test+0x2e>
  6a:	4601                	li	a2,0
  6c:	85a2                	mv	a1,s0
  6e:	8526                	mv	a0,s1
  70:	00000097          	auipc	ra,0x0
  74:	320080e7          	jalr	800(ra) # 390 <execve>
  78:	70a2                	ld	ra,40(sp)
  7a:	7402                	ld	s0,32(sp)
  7c:	64e2                	ld	s1,24(sp)
  7e:	6145                	addi	sp,sp,48
  80:	8082                	ret
  82:	0068                	addi	a0,sp,12
  84:	00000097          	auipc	ra,0x0
  88:	1ec080e7          	jalr	492(ra) # 270 <wait>
  8c:	47b2                	lw	a5,12(sp)
  8e:	fe07c5e3          	bltz	a5,78 <test+0x24>
  92:	8522                	mv	a0,s0
  94:	00000097          	auipc	ra,0x0
  98:	f6c080e7          	jalr	-148(ra) # 0 <print_success>
  9c:	bff1                	j	78 <test+0x24>

000000000000009e <main>:
  9e:	712d                	addi	sp,sp,-288
  a0:	ee06                	sd	ra,280(sp)
  a2:	4589                	li	a1,2
  a4:	00001517          	auipc	a0,0x1
  a8:	97c50513          	addi	a0,a0,-1668 # a20 <malloc+0x146>
  ac:	00000097          	auipc	ra,0x0
  b0:	1cc080e7          	jalr	460(ra) # 278 <open>
  b4:	4501                	li	a0,0
  b6:	00000097          	auipc	ra,0x0
  ba:	1da080e7          	jalr	474(ra) # 290 <dup>
  be:	4501                	li	a0,0
  c0:	00000097          	auipc	ra,0x0
  c4:	1d0080e7          	jalr	464(ra) # 290 <dup>
  c8:	00001797          	auipc	a5,0x1
  cc:	96078793          	addi	a5,a5,-1696 # a28 <malloc+0x14e>
  d0:	fdbe                	sd	a5,248(sp)
  d2:	00001797          	auipc	a5,0x1
  d6:	95e78793          	addi	a5,a5,-1698 # a30 <malloc+0x156>
  da:	e23e                	sd	a5,256(sp)
  dc:	e602                	sd	zero,264(sp)
  de:	00001797          	auipc	a5,0x1
  e2:	9d278793          	addi	a5,a5,-1582 # ab0 <malloc+0x1d6>
  e6:	638c                	ld	a1,0(a5)
  e8:	6790                	ld	a2,8(a5)
  ea:	6b94                	ld	a3,16(a5)
  ec:	6f98                	ld	a4,24(a5)
  ee:	edae                	sd	a1,216(sp)
  f0:	f1b2                	sd	a2,224(sp)
  f2:	f5b6                	sd	a3,232(sp)
  f4:	f9ba                	sd	a4,240(sp)
  f6:	738c                	ld	a1,32(a5)
  f8:	7790                	ld	a2,40(a5)
  fa:	7b94                	ld	a3,48(a5)
  fc:	7f98                	ld	a4,56(a5)
  fe:	fd2e                	sd	a1,184(sp)
 100:	e1b2                	sd	a2,192(sp)
 102:	e5b6                	sd	a3,200(sp)
 104:	e9ba                	sd	a4,208(sp)
 106:	00001717          	auipc	a4,0x1
 10a:	94a70713          	addi	a4,a4,-1718 # a50 <malloc+0x176>
 10e:	f13a                	sd	a4,160(sp)
 110:	00001717          	auipc	a4,0x1
 114:	95070713          	addi	a4,a4,-1712 # a60 <malloc+0x186>
 118:	f53a                	sd	a4,168(sp)
 11a:	f902                	sd	zero,176(sp)
 11c:	00001697          	auipc	a3,0x1
 120:	95468693          	addi	a3,a3,-1708 # a70 <malloc+0x196>
 124:	e936                	sd	a3,144(sp)
 126:	ed02                	sd	zero,152(sp)
 128:	00001697          	auipc	a3,0x1
 12c:	95068693          	addi	a3,a3,-1712 # a78 <malloc+0x19e>
 130:	e136                	sd	a3,128(sp)
 132:	e502                	sd	zero,136(sp)
 134:	00001697          	auipc	a3,0x1
 138:	94c68693          	addi	a3,a3,-1716 # a80 <malloc+0x1a6>
 13c:	f8b6                	sd	a3,112(sp)
 13e:	fc82                	sd	zero,120(sp)
 140:	00001697          	auipc	a3,0x1
 144:	94868693          	addi	a3,a3,-1720 # a88 <malloc+0x1ae>
 148:	ecb6                	sd	a3,88(sp)
 14a:	f0ba                	sd	a4,96(sp)
 14c:	f482                	sd	zero,104(sp)
 14e:	63ac                	ld	a1,64(a5)
 150:	67b0                	ld	a2,72(a5)
 152:	6bb4                	ld	a3,80(a5)
 154:	6fb8                	ld	a4,88(a5)
 156:	73bc                	ld	a5,96(a5)
 158:	f82e                	sd	a1,48(sp)
 15a:	fc32                	sd	a2,56(sp)
 15c:	e0b6                	sd	a3,64(sp)
 15e:	e4ba                	sd	a4,72(sp)
 160:	e8be                	sd	a5,80(sp)
 162:	00001797          	auipc	a5,0x1
 166:	92e78793          	addi	a5,a5,-1746 # a90 <malloc+0x1b6>
 16a:	f03e                	sd	a5,32(sp)
 16c:	f402                	sd	zero,40(sp)
 16e:	00001797          	auipc	a5,0x1
 172:	92a78793          	addi	a5,a5,-1750 # a98 <malloc+0x1be>
 176:	e83e                	sd	a5,16(sp)
 178:	ec02                	sd	zero,24(sp)
 17a:	00001797          	auipc	a5,0x1
 17e:	92678793          	addi	a5,a5,-1754 # aa0 <malloc+0x1c6>
 182:	e03e                	sd	a5,0(sp)
 184:	e402                	sd	zero,8(sp)
 186:	19ac                	addi	a1,sp,248
 188:	00001517          	auipc	a0,0x1
 18c:	92050513          	addi	a0,a0,-1760 # aa8 <malloc+0x1ce>
 190:	00000097          	auipc	ra,0x0
 194:	ec4080e7          	jalr	-316(ra) # 54 <test>
 198:	09ac                	addi	a1,sp,216
 19a:	00001517          	auipc	a0,0x1
 19e:	90e50513          	addi	a0,a0,-1778 # aa8 <malloc+0x1ce>
 1a2:	00000097          	auipc	ra,0x0
 1a6:	eb2080e7          	jalr	-334(ra) # 54 <test>
 1aa:	192c                	addi	a1,sp,184
 1ac:	00001517          	auipc	a0,0x1
 1b0:	8fc50513          	addi	a0,a0,-1796 # aa8 <malloc+0x1ce>
 1b4:	00000097          	auipc	ra,0x0
 1b8:	ea0080e7          	jalr	-352(ra) # 54 <test>
 1bc:	110c                	addi	a1,sp,160
 1be:	00001517          	auipc	a0,0x1
 1c2:	8ea50513          	addi	a0,a0,-1814 # aa8 <malloc+0x1ce>
 1c6:	00000097          	auipc	ra,0x0
 1ca:	e8e080e7          	jalr	-370(ra) # 54 <test>
 1ce:	090c                	addi	a1,sp,144
 1d0:	00001517          	auipc	a0,0x1
 1d4:	8d850513          	addi	a0,a0,-1832 # aa8 <malloc+0x1ce>
 1d8:	00000097          	auipc	ra,0x0
 1dc:	e7c080e7          	jalr	-388(ra) # 54 <test>
 1e0:	010c                	addi	a1,sp,128
 1e2:	00001517          	auipc	a0,0x1
 1e6:	8c650513          	addi	a0,a0,-1850 # aa8 <malloc+0x1ce>
 1ea:	00000097          	auipc	ra,0x0
 1ee:	e6a080e7          	jalr	-406(ra) # 54 <test>
 1f2:	188c                	addi	a1,sp,112
 1f4:	00001517          	auipc	a0,0x1
 1f8:	8b450513          	addi	a0,a0,-1868 # aa8 <malloc+0x1ce>
 1fc:	00000097          	auipc	ra,0x0
 200:	e58080e7          	jalr	-424(ra) # 54 <test>
 204:	08ac                	addi	a1,sp,88
 206:	00001517          	auipc	a0,0x1
 20a:	8a250513          	addi	a0,a0,-1886 # aa8 <malloc+0x1ce>
 20e:	00000097          	auipc	ra,0x0
 212:	e46080e7          	jalr	-442(ra) # 54 <test>
 216:	180c                	addi	a1,sp,48
 218:	00001517          	auipc	a0,0x1
 21c:	89050513          	addi	a0,a0,-1904 # aa8 <malloc+0x1ce>
 220:	00000097          	auipc	ra,0x0
 224:	e34080e7          	jalr	-460(ra) # 54 <test>
 228:	100c                	addi	a1,sp,32
 22a:	00001517          	auipc	a0,0x1
 22e:	87e50513          	addi	a0,a0,-1922 # aa8 <malloc+0x1ce>
 232:	00000097          	auipc	ra,0x0
 236:	e22080e7          	jalr	-478(ra) # 54 <test>
 23a:	080c                	addi	a1,sp,16
 23c:	00001517          	auipc	a0,0x1
 240:	86c50513          	addi	a0,a0,-1940 # aa8 <malloc+0x1ce>
 244:	00000097          	auipc	ra,0x0
 248:	e10080e7          	jalr	-496(ra) # 54 <test>
 24c:	858a                	mv	a1,sp
 24e:	00001517          	auipc	a0,0x1
 252:	85a50513          	addi	a0,a0,-1958 # aa8 <malloc+0x1ce>
 256:	00000097          	auipc	ra,0x0
 25a:	dfe080e7          	jalr	-514(ra) # 54 <test>
 25e:	00000097          	auipc	ra,0x0
 262:	150080e7          	jalr	336(ra) # 3ae <kernel_panic>
 266:	a001                	j	266 <main+0x1c8>

0000000000000268 <fork>:
 268:	4885                	li	a7,1
 26a:	00000073          	ecall
 26e:	8082                	ret

0000000000000270 <wait>:
 270:	488d                	li	a7,3
 272:	00000073          	ecall
 276:	8082                	ret

0000000000000278 <open>:
 278:	4889                	li	a7,2
 27a:	00000073          	ecall
 27e:	8082                	ret

0000000000000280 <sbrk>:
 280:	4891                	li	a7,4
 282:	00000073          	ecall
 286:	8082                	ret

0000000000000288 <getcwd>:
 288:	48c5                	li	a7,17
 28a:	00000073          	ecall
 28e:	8082                	ret

0000000000000290 <dup>:
 290:	48dd                	li	a7,23
 292:	00000073          	ecall
 296:	8082                	ret

0000000000000298 <dup3>:
 298:	48e1                	li	a7,24
 29a:	00000073          	ecall
 29e:	8082                	ret

00000000000002a0 <mkdirat>:
 2a0:	02200893          	li	a7,34
 2a4:	00000073          	ecall
 2a8:	8082                	ret

00000000000002aa <unlinkat>:
 2aa:	02300893          	li	a7,35
 2ae:	00000073          	ecall
 2b2:	8082                	ret

00000000000002b4 <linkat>:
 2b4:	02500893          	li	a7,37
 2b8:	00000073          	ecall
 2bc:	8082                	ret

00000000000002be <umount2>:
 2be:	02700893          	li	a7,39
 2c2:	00000073          	ecall
 2c6:	8082                	ret

00000000000002c8 <mount>:
 2c8:	02800893          	li	a7,40
 2cc:	00000073          	ecall
 2d0:	8082                	ret

00000000000002d2 <chdir>:
 2d2:	03100893          	li	a7,49
 2d6:	00000073          	ecall
 2da:	8082                	ret

00000000000002dc <openat>:
 2dc:	03800893          	li	a7,56
 2e0:	00000073          	ecall
 2e4:	8082                	ret

00000000000002e6 <close>:
 2e6:	03900893          	li	a7,57
 2ea:	00000073          	ecall
 2ee:	8082                	ret

00000000000002f0 <pipe2>:
 2f0:	03b00893          	li	a7,59
 2f4:	00000073          	ecall
 2f8:	8082                	ret

00000000000002fa <getdents64>:
 2fa:	03d00893          	li	a7,61
 2fe:	00000073          	ecall
 302:	8082                	ret

0000000000000304 <read>:
 304:	03f00893          	li	a7,63
 308:	00000073          	ecall
 30c:	8082                	ret

000000000000030e <write>:
 30e:	04000893          	li	a7,64
 312:	00000073          	ecall
 316:	8082                	ret

0000000000000318 <fstat>:
 318:	05000893          	li	a7,80
 31c:	00000073          	ecall
 320:	8082                	ret

0000000000000322 <exit>:
 322:	05d00893          	li	a7,93
 326:	00000073          	ecall
 32a:	8082                	ret

000000000000032c <nanosleep>:
 32c:	06500893          	li	a7,101
 330:	00000073          	ecall
 334:	8082                	ret

0000000000000336 <sched_yield>:
 336:	07c00893          	li	a7,124
 33a:	00000073          	ecall
 33e:	8082                	ret

0000000000000340 <times>:
 340:	09900893          	li	a7,153
 344:	00000073          	ecall
 348:	8082                	ret

000000000000034a <uname>:
 34a:	0a000893          	li	a7,160
 34e:	00000073          	ecall
 352:	8082                	ret

0000000000000354 <gettimeofday>:
 354:	0a900893          	li	a7,169
 358:	00000073          	ecall
 35c:	8082                	ret

000000000000035e <brk>:
 35e:	0d600893          	li	a7,214
 362:	00000073          	ecall
 366:	8082                	ret

0000000000000368 <munmap>:
 368:	0d700893          	li	a7,215
 36c:	00000073          	ecall
 370:	8082                	ret

0000000000000372 <getpid>:
 372:	0ac00893          	li	a7,172
 376:	00000073          	ecall
 37a:	8082                	ret

000000000000037c <getppid>:
 37c:	0ad00893          	li	a7,173
 380:	00000073          	ecall
 384:	8082                	ret

0000000000000386 <clone>:
 386:	0dc00893          	li	a7,220
 38a:	00000073          	ecall
 38e:	8082                	ret

0000000000000390 <execve>:
 390:	0dd00893          	li	a7,221
 394:	00000073          	ecall
 398:	8082                	ret

000000000000039a <mmap>:
 39a:	0de00893          	li	a7,222
 39e:	00000073          	ecall
 3a2:	8082                	ret

00000000000003a4 <wait4>:
 3a4:	10400893          	li	a7,260
 3a8:	00000073          	ecall
 3ac:	8082                	ret

00000000000003ae <kernel_panic>:
 3ae:	18f00893          	li	a7,399
 3b2:	00000073          	ecall
 3b6:	8082                	ret

00000000000003b8 <strcpy>:
 3b8:	87aa                	mv	a5,a0
 3ba:	0585                	addi	a1,a1,1
 3bc:	0785                	addi	a5,a5,1
 3be:	fff5c703          	lbu	a4,-1(a1)
 3c2:	fee78fa3          	sb	a4,-1(a5)
 3c6:	fb75                	bnez	a4,3ba <strcpy+0x2>
 3c8:	8082                	ret

00000000000003ca <strcmp>:
 3ca:	00054783          	lbu	a5,0(a0)
 3ce:	cb91                	beqz	a5,3e2 <strcmp+0x18>
 3d0:	0005c703          	lbu	a4,0(a1)
 3d4:	00f71763          	bne	a4,a5,3e2 <strcmp+0x18>
 3d8:	0505                	addi	a0,a0,1
 3da:	0585                	addi	a1,a1,1
 3dc:	00054783          	lbu	a5,0(a0)
 3e0:	fbe5                	bnez	a5,3d0 <strcmp+0x6>
 3e2:	0005c503          	lbu	a0,0(a1)
 3e6:	40a7853b          	subw	a0,a5,a0
 3ea:	8082                	ret

00000000000003ec <strlen>:
 3ec:	00054783          	lbu	a5,0(a0)
 3f0:	cf81                	beqz	a5,408 <strlen+0x1c>
 3f2:	0505                	addi	a0,a0,1
 3f4:	87aa                	mv	a5,a0
 3f6:	4685                	li	a3,1
 3f8:	9e89                	subw	a3,a3,a0
 3fa:	00f6853b          	addw	a0,a3,a5
 3fe:	0785                	addi	a5,a5,1
 400:	fff7c703          	lbu	a4,-1(a5)
 404:	fb7d                	bnez	a4,3fa <strlen+0xe>
 406:	8082                	ret
 408:	4501                	li	a0,0
 40a:	8082                	ret

000000000000040c <memset>:
 40c:	ce09                	beqz	a2,426 <memset+0x1a>
 40e:	87aa                	mv	a5,a0
 410:	fff6071b          	addiw	a4,a2,-1
 414:	1702                	slli	a4,a4,0x20
 416:	9301                	srli	a4,a4,0x20
 418:	0705                	addi	a4,a4,1
 41a:	972a                	add	a4,a4,a0
 41c:	00b78023          	sb	a1,0(a5)
 420:	0785                	addi	a5,a5,1
 422:	fee79de3          	bne	a5,a4,41c <memset+0x10>
 426:	8082                	ret

0000000000000428 <strchr>:
 428:	00054783          	lbu	a5,0(a0)
 42c:	cb89                	beqz	a5,43e <strchr+0x16>
 42e:	00f58963          	beq	a1,a5,440 <strchr+0x18>
 432:	0505                	addi	a0,a0,1
 434:	00054783          	lbu	a5,0(a0)
 438:	fbfd                	bnez	a5,42e <strchr+0x6>
 43a:	4501                	li	a0,0
 43c:	8082                	ret
 43e:	4501                	li	a0,0
 440:	8082                	ret

0000000000000442 <gets>:
 442:	715d                	addi	sp,sp,-80
 444:	e486                	sd	ra,72(sp)
 446:	e0a2                	sd	s0,64(sp)
 448:	fc26                	sd	s1,56(sp)
 44a:	f84a                	sd	s2,48(sp)
 44c:	f44e                	sd	s3,40(sp)
 44e:	f052                	sd	s4,32(sp)
 450:	ec56                	sd	s5,24(sp)
 452:	e85a                	sd	s6,16(sp)
 454:	8b2a                	mv	s6,a0
 456:	89ae                	mv	s3,a1
 458:	84aa                	mv	s1,a0
 45a:	4401                	li	s0,0
 45c:	4a29                	li	s4,10
 45e:	4ab5                	li	s5,13
 460:	8922                	mv	s2,s0
 462:	2405                	addiw	s0,s0,1
 464:	03345863          	bge	s0,s3,494 <gets+0x52>
 468:	4605                	li	a2,1
 46a:	00f10593          	addi	a1,sp,15
 46e:	4501                	li	a0,0
 470:	00000097          	auipc	ra,0x0
 474:	e94080e7          	jalr	-364(ra) # 304 <read>
 478:	00a05e63          	blez	a0,494 <gets+0x52>
 47c:	00f14783          	lbu	a5,15(sp)
 480:	00f48023          	sb	a5,0(s1)
 484:	01478763          	beq	a5,s4,492 <gets+0x50>
 488:	0485                	addi	s1,s1,1
 48a:	fd579be3          	bne	a5,s5,460 <gets+0x1e>
 48e:	8922                	mv	s2,s0
 490:	a011                	j	494 <gets+0x52>
 492:	8922                	mv	s2,s0
 494:	995a                	add	s2,s2,s6
 496:	00090023          	sb	zero,0(s2)
 49a:	855a                	mv	a0,s6
 49c:	60a6                	ld	ra,72(sp)
 49e:	6406                	ld	s0,64(sp)
 4a0:	74e2                	ld	s1,56(sp)
 4a2:	7942                	ld	s2,48(sp)
 4a4:	79a2                	ld	s3,40(sp)
 4a6:	7a02                	ld	s4,32(sp)
 4a8:	6ae2                	ld	s5,24(sp)
 4aa:	6b42                	ld	s6,16(sp)
 4ac:	6161                	addi	sp,sp,80
 4ae:	8082                	ret

00000000000004b0 <atoi>:
 4b0:	86aa                	mv	a3,a0
 4b2:	00054603          	lbu	a2,0(a0)
 4b6:	fd06079b          	addiw	a5,a2,-48
 4ba:	0ff7f793          	andi	a5,a5,255
 4be:	4725                	li	a4,9
 4c0:	02f76663          	bltu	a4,a5,4ec <atoi+0x3c>
 4c4:	4501                	li	a0,0
 4c6:	45a5                	li	a1,9
 4c8:	0685                	addi	a3,a3,1
 4ca:	0025179b          	slliw	a5,a0,0x2
 4ce:	9fa9                	addw	a5,a5,a0
 4d0:	0017979b          	slliw	a5,a5,0x1
 4d4:	9fb1                	addw	a5,a5,a2
 4d6:	fd07851b          	addiw	a0,a5,-48
 4da:	0006c603          	lbu	a2,0(a3)
 4de:	fd06071b          	addiw	a4,a2,-48
 4e2:	0ff77713          	andi	a4,a4,255
 4e6:	fee5f1e3          	bgeu	a1,a4,4c8 <atoi+0x18>
 4ea:	8082                	ret
 4ec:	4501                	li	a0,0
 4ee:	8082                	ret

00000000000004f0 <memmove>:
 4f0:	02b57463          	bgeu	a0,a1,518 <memmove+0x28>
 4f4:	04c05663          	blez	a2,540 <memmove+0x50>
 4f8:	fff6079b          	addiw	a5,a2,-1
 4fc:	1782                	slli	a5,a5,0x20
 4fe:	9381                	srli	a5,a5,0x20
 500:	0785                	addi	a5,a5,1
 502:	97aa                	add	a5,a5,a0
 504:	872a                	mv	a4,a0
 506:	0585                	addi	a1,a1,1
 508:	0705                	addi	a4,a4,1
 50a:	fff5c683          	lbu	a3,-1(a1)
 50e:	fed70fa3          	sb	a3,-1(a4)
 512:	fee79ae3          	bne	a5,a4,506 <memmove+0x16>
 516:	8082                	ret
 518:	00c50733          	add	a4,a0,a2
 51c:	95b2                	add	a1,a1,a2
 51e:	02c05163          	blez	a2,540 <memmove+0x50>
 522:	fff6079b          	addiw	a5,a2,-1
 526:	1782                	slli	a5,a5,0x20
 528:	9381                	srli	a5,a5,0x20
 52a:	fff7c793          	not	a5,a5
 52e:	97ba                	add	a5,a5,a4
 530:	15fd                	addi	a1,a1,-1
 532:	177d                	addi	a4,a4,-1
 534:	0005c683          	lbu	a3,0(a1)
 538:	00d70023          	sb	a3,0(a4)
 53c:	fee79ae3          	bne	a5,a4,530 <memmove+0x40>
 540:	8082                	ret

0000000000000542 <memcmp>:
 542:	fff6069b          	addiw	a3,a2,-1
 546:	c605                	beqz	a2,56e <memcmp+0x2c>
 548:	1682                	slli	a3,a3,0x20
 54a:	9281                	srli	a3,a3,0x20
 54c:	0685                	addi	a3,a3,1
 54e:	96aa                	add	a3,a3,a0
 550:	00054783          	lbu	a5,0(a0)
 554:	0005c703          	lbu	a4,0(a1)
 558:	00e79863          	bne	a5,a4,568 <memcmp+0x26>
 55c:	0505                	addi	a0,a0,1
 55e:	0585                	addi	a1,a1,1
 560:	fed518e3          	bne	a0,a3,550 <memcmp+0xe>
 564:	4501                	li	a0,0
 566:	8082                	ret
 568:	40e7853b          	subw	a0,a5,a4
 56c:	8082                	ret
 56e:	4501                	li	a0,0
 570:	8082                	ret

0000000000000572 <memcpy>:
 572:	1141                	addi	sp,sp,-16
 574:	e406                	sd	ra,8(sp)
 576:	00000097          	auipc	ra,0x0
 57a:	f7a080e7          	jalr	-134(ra) # 4f0 <memmove>
 57e:	60a2                	ld	ra,8(sp)
 580:	0141                	addi	sp,sp,16
 582:	8082                	ret

0000000000000584 <putc>:
 584:	1101                	addi	sp,sp,-32
 586:	ec06                	sd	ra,24(sp)
 588:	00b107a3          	sb	a1,15(sp)
 58c:	4605                	li	a2,1
 58e:	00f10593          	addi	a1,sp,15
 592:	00000097          	auipc	ra,0x0
 596:	d7c080e7          	jalr	-644(ra) # 30e <write>
 59a:	60e2                	ld	ra,24(sp)
 59c:	6105                	addi	sp,sp,32
 59e:	8082                	ret

00000000000005a0 <printint>:
 5a0:	7179                	addi	sp,sp,-48
 5a2:	f406                	sd	ra,40(sp)
 5a4:	f022                	sd	s0,32(sp)
 5a6:	ec26                	sd	s1,24(sp)
 5a8:	e84a                	sd	s2,16(sp)
 5aa:	84aa                	mv	s1,a0
 5ac:	c299                	beqz	a3,5b2 <printint+0x12>
 5ae:	0805c363          	bltz	a1,634 <printint+0x94>
 5b2:	2581                	sext.w	a1,a1
 5b4:	4881                	li	a7,0
 5b6:	868a                	mv	a3,sp
 5b8:	4701                	li	a4,0
 5ba:	2601                	sext.w	a2,a2
 5bc:	00000517          	auipc	a0,0x0
 5c0:	56450513          	addi	a0,a0,1380 # b20 <digits>
 5c4:	883a                	mv	a6,a4
 5c6:	2705                	addiw	a4,a4,1
 5c8:	02c5f7bb          	remuw	a5,a1,a2
 5cc:	1782                	slli	a5,a5,0x20
 5ce:	9381                	srli	a5,a5,0x20
 5d0:	97aa                	add	a5,a5,a0
 5d2:	0007c783          	lbu	a5,0(a5)
 5d6:	00f68023          	sb	a5,0(a3)
 5da:	0005879b          	sext.w	a5,a1
 5de:	02c5d5bb          	divuw	a1,a1,a2
 5e2:	0685                	addi	a3,a3,1
 5e4:	fec7f0e3          	bgeu	a5,a2,5c4 <printint+0x24>
 5e8:	00088a63          	beqz	a7,5fc <printint+0x5c>
 5ec:	081c                	addi	a5,sp,16
 5ee:	973e                	add	a4,a4,a5
 5f0:	02d00793          	li	a5,45
 5f4:	fef70823          	sb	a5,-16(a4)
 5f8:	0028071b          	addiw	a4,a6,2
 5fc:	02e05663          	blez	a4,628 <printint+0x88>
 600:	00e10433          	add	s0,sp,a4
 604:	fff10913          	addi	s2,sp,-1
 608:	993a                	add	s2,s2,a4
 60a:	377d                	addiw	a4,a4,-1
 60c:	1702                	slli	a4,a4,0x20
 60e:	9301                	srli	a4,a4,0x20
 610:	40e90933          	sub	s2,s2,a4
 614:	fff44583          	lbu	a1,-1(s0)
 618:	8526                	mv	a0,s1
 61a:	00000097          	auipc	ra,0x0
 61e:	f6a080e7          	jalr	-150(ra) # 584 <putc>
 622:	147d                	addi	s0,s0,-1
 624:	ff2418e3          	bne	s0,s2,614 <printint+0x74>
 628:	70a2                	ld	ra,40(sp)
 62a:	7402                	ld	s0,32(sp)
 62c:	64e2                	ld	s1,24(sp)
 62e:	6942                	ld	s2,16(sp)
 630:	6145                	addi	sp,sp,48
 632:	8082                	ret
 634:	40b005bb          	negw	a1,a1
 638:	4885                	li	a7,1
 63a:	bfb5                	j	5b6 <printint+0x16>

000000000000063c <vprintf>:
 63c:	7119                	addi	sp,sp,-128
 63e:	fc86                	sd	ra,120(sp)
 640:	f8a2                	sd	s0,112(sp)
 642:	f4a6                	sd	s1,104(sp)
 644:	f0ca                	sd	s2,96(sp)
 646:	ecce                	sd	s3,88(sp)
 648:	e8d2                	sd	s4,80(sp)
 64a:	e4d6                	sd	s5,72(sp)
 64c:	e0da                	sd	s6,64(sp)
 64e:	fc5e                	sd	s7,56(sp)
 650:	f862                	sd	s8,48(sp)
 652:	f466                	sd	s9,40(sp)
 654:	f06a                	sd	s10,32(sp)
 656:	ec6e                	sd	s11,24(sp)
 658:	0005c483          	lbu	s1,0(a1)
 65c:	18048c63          	beqz	s1,7f4 <vprintf+0x1b8>
 660:	8a2a                	mv	s4,a0
 662:	8ab2                	mv	s5,a2
 664:	00158413          	addi	s0,a1,1
 668:	4901                	li	s2,0
 66a:	02500993          	li	s3,37
 66e:	06400b93          	li	s7,100
 672:	06c00c13          	li	s8,108
 676:	07800c93          	li	s9,120
 67a:	07000d13          	li	s10,112
 67e:	07300d93          	li	s11,115
 682:	00000b17          	auipc	s6,0x0
 686:	49eb0b13          	addi	s6,s6,1182 # b20 <digits>
 68a:	a839                	j	6a8 <vprintf+0x6c>
 68c:	85a6                	mv	a1,s1
 68e:	8552                	mv	a0,s4
 690:	00000097          	auipc	ra,0x0
 694:	ef4080e7          	jalr	-268(ra) # 584 <putc>
 698:	a019                	j	69e <vprintf+0x62>
 69a:	01390f63          	beq	s2,s3,6b8 <vprintf+0x7c>
 69e:	0405                	addi	s0,s0,1
 6a0:	fff44483          	lbu	s1,-1(s0)
 6a4:	14048863          	beqz	s1,7f4 <vprintf+0x1b8>
 6a8:	0004879b          	sext.w	a5,s1
 6ac:	fe0917e3          	bnez	s2,69a <vprintf+0x5e>
 6b0:	fd379ee3          	bne	a5,s3,68c <vprintf+0x50>
 6b4:	893e                	mv	s2,a5
 6b6:	b7e5                	j	69e <vprintf+0x62>
 6b8:	03778e63          	beq	a5,s7,6f4 <vprintf+0xb8>
 6bc:	05878a63          	beq	a5,s8,710 <vprintf+0xd4>
 6c0:	07978663          	beq	a5,s9,72c <vprintf+0xf0>
 6c4:	09a78263          	beq	a5,s10,748 <vprintf+0x10c>
 6c8:	0db78363          	beq	a5,s11,78e <vprintf+0x152>
 6cc:	06300713          	li	a4,99
 6d0:	0ee78b63          	beq	a5,a4,7c6 <vprintf+0x18a>
 6d4:	11378563          	beq	a5,s3,7de <vprintf+0x1a2>
 6d8:	85ce                	mv	a1,s3
 6da:	8552                	mv	a0,s4
 6dc:	00000097          	auipc	ra,0x0
 6e0:	ea8080e7          	jalr	-344(ra) # 584 <putc>
 6e4:	85a6                	mv	a1,s1
 6e6:	8552                	mv	a0,s4
 6e8:	00000097          	auipc	ra,0x0
 6ec:	e9c080e7          	jalr	-356(ra) # 584 <putc>
 6f0:	4901                	li	s2,0
 6f2:	b775                	j	69e <vprintf+0x62>
 6f4:	008a8493          	addi	s1,s5,8
 6f8:	4685                	li	a3,1
 6fa:	4629                	li	a2,10
 6fc:	000aa583          	lw	a1,0(s5)
 700:	8552                	mv	a0,s4
 702:	00000097          	auipc	ra,0x0
 706:	e9e080e7          	jalr	-354(ra) # 5a0 <printint>
 70a:	8aa6                	mv	s5,s1
 70c:	4901                	li	s2,0
 70e:	bf41                	j	69e <vprintf+0x62>
 710:	008a8493          	addi	s1,s5,8
 714:	4681                	li	a3,0
 716:	4629                	li	a2,10
 718:	000aa583          	lw	a1,0(s5)
 71c:	8552                	mv	a0,s4
 71e:	00000097          	auipc	ra,0x0
 722:	e82080e7          	jalr	-382(ra) # 5a0 <printint>
 726:	8aa6                	mv	s5,s1
 728:	4901                	li	s2,0
 72a:	bf95                	j	69e <vprintf+0x62>
 72c:	008a8493          	addi	s1,s5,8
 730:	4681                	li	a3,0
 732:	4641                	li	a2,16
 734:	000aa583          	lw	a1,0(s5)
 738:	8552                	mv	a0,s4
 73a:	00000097          	auipc	ra,0x0
 73e:	e66080e7          	jalr	-410(ra) # 5a0 <printint>
 742:	8aa6                	mv	s5,s1
 744:	4901                	li	s2,0
 746:	bfa1                	j	69e <vprintf+0x62>
 748:	008a8793          	addi	a5,s5,8
 74c:	e43e                	sd	a5,8(sp)
 74e:	000ab903          	ld	s2,0(s5)
 752:	03000593          	li	a1,48
 756:	8552                	mv	a0,s4
 758:	00000097          	auipc	ra,0x0
 75c:	e2c080e7          	jalr	-468(ra) # 584 <putc>
 760:	85e6                	mv	a1,s9
 762:	8552                	mv	a0,s4
 764:	00000097          	auipc	ra,0x0
 768:	e20080e7          	jalr	-480(ra) # 584 <putc>
 76c:	44c1                	li	s1,16
 76e:	03c95793          	srli	a5,s2,0x3c
 772:	97da                	add	a5,a5,s6
 774:	0007c583          	lbu	a1,0(a5)
 778:	8552                	mv	a0,s4
 77a:	00000097          	auipc	ra,0x0
 77e:	e0a080e7          	jalr	-502(ra) # 584 <putc>
 782:	0912                	slli	s2,s2,0x4
 784:	34fd                	addiw	s1,s1,-1
 786:	f4e5                	bnez	s1,76e <vprintf+0x132>
 788:	6aa2                	ld	s5,8(sp)
 78a:	4901                	li	s2,0
 78c:	bf09                	j	69e <vprintf+0x62>
 78e:	008a8493          	addi	s1,s5,8
 792:	000ab903          	ld	s2,0(s5)
 796:	02090163          	beqz	s2,7b8 <vprintf+0x17c>
 79a:	00094583          	lbu	a1,0(s2)
 79e:	c9a1                	beqz	a1,7ee <vprintf+0x1b2>
 7a0:	8552                	mv	a0,s4
 7a2:	00000097          	auipc	ra,0x0
 7a6:	de2080e7          	jalr	-542(ra) # 584 <putc>
 7aa:	0905                	addi	s2,s2,1
 7ac:	00094583          	lbu	a1,0(s2)
 7b0:	f9e5                	bnez	a1,7a0 <vprintf+0x164>
 7b2:	8aa6                	mv	s5,s1
 7b4:	4901                	li	s2,0
 7b6:	b5e5                	j	69e <vprintf+0x62>
 7b8:	00000917          	auipc	s2,0x0
 7bc:	36090913          	addi	s2,s2,864 # b18 <malloc+0x23e>
 7c0:	02800593          	li	a1,40
 7c4:	bff1                	j	7a0 <vprintf+0x164>
 7c6:	008a8493          	addi	s1,s5,8
 7ca:	000ac583          	lbu	a1,0(s5)
 7ce:	8552                	mv	a0,s4
 7d0:	00000097          	auipc	ra,0x0
 7d4:	db4080e7          	jalr	-588(ra) # 584 <putc>
 7d8:	8aa6                	mv	s5,s1
 7da:	4901                	li	s2,0
 7dc:	b5c9                	j	69e <vprintf+0x62>
 7de:	85ce                	mv	a1,s3
 7e0:	8552                	mv	a0,s4
 7e2:	00000097          	auipc	ra,0x0
 7e6:	da2080e7          	jalr	-606(ra) # 584 <putc>
 7ea:	4901                	li	s2,0
 7ec:	bd4d                	j	69e <vprintf+0x62>
 7ee:	8aa6                	mv	s5,s1
 7f0:	4901                	li	s2,0
 7f2:	b575                	j	69e <vprintf+0x62>
 7f4:	70e6                	ld	ra,120(sp)
 7f6:	7446                	ld	s0,112(sp)
 7f8:	74a6                	ld	s1,104(sp)
 7fa:	7906                	ld	s2,96(sp)
 7fc:	69e6                	ld	s3,88(sp)
 7fe:	6a46                	ld	s4,80(sp)
 800:	6aa6                	ld	s5,72(sp)
 802:	6b06                	ld	s6,64(sp)
 804:	7be2                	ld	s7,56(sp)
 806:	7c42                	ld	s8,48(sp)
 808:	7ca2                	ld	s9,40(sp)
 80a:	7d02                	ld	s10,32(sp)
 80c:	6de2                	ld	s11,24(sp)
 80e:	6109                	addi	sp,sp,128
 810:	8082                	ret

0000000000000812 <fprintf>:
 812:	715d                	addi	sp,sp,-80
 814:	ec06                	sd	ra,24(sp)
 816:	f032                	sd	a2,32(sp)
 818:	f436                	sd	a3,40(sp)
 81a:	f83a                	sd	a4,48(sp)
 81c:	fc3e                	sd	a5,56(sp)
 81e:	e0c2                	sd	a6,64(sp)
 820:	e4c6                	sd	a7,72(sp)
 822:	1010                	addi	a2,sp,32
 824:	e432                	sd	a2,8(sp)
 826:	00000097          	auipc	ra,0x0
 82a:	e16080e7          	jalr	-490(ra) # 63c <vprintf>
 82e:	60e2                	ld	ra,24(sp)
 830:	6161                	addi	sp,sp,80
 832:	8082                	ret

0000000000000834 <printf>:
 834:	711d                	addi	sp,sp,-96
 836:	ec06                	sd	ra,24(sp)
 838:	f42e                	sd	a1,40(sp)
 83a:	f832                	sd	a2,48(sp)
 83c:	fc36                	sd	a3,56(sp)
 83e:	e0ba                	sd	a4,64(sp)
 840:	e4be                	sd	a5,72(sp)
 842:	e8c2                	sd	a6,80(sp)
 844:	ecc6                	sd	a7,88(sp)
 846:	1030                	addi	a2,sp,40
 848:	e432                	sd	a2,8(sp)
 84a:	85aa                	mv	a1,a0
 84c:	4505                	li	a0,1
 84e:	00000097          	auipc	ra,0x0
 852:	dee080e7          	jalr	-530(ra) # 63c <vprintf>
 856:	60e2                	ld	ra,24(sp)
 858:	6125                	addi	sp,sp,96
 85a:	8082                	ret

000000000000085c <free>:
 85c:	ff050693          	addi	a3,a0,-16
 860:	00000797          	auipc	a5,0x0
 864:	2d87b783          	ld	a5,728(a5) # b38 <freep>
 868:	a805                	j	898 <free+0x3c>
 86a:	4618                	lw	a4,8(a2)
 86c:	9db9                	addw	a1,a1,a4
 86e:	feb52c23          	sw	a1,-8(a0)
 872:	6398                	ld	a4,0(a5)
 874:	6318                	ld	a4,0(a4)
 876:	fee53823          	sd	a4,-16(a0)
 87a:	a091                	j	8be <free+0x62>
 87c:	ff852703          	lw	a4,-8(a0)
 880:	9e39                	addw	a2,a2,a4
 882:	c790                	sw	a2,8(a5)
 884:	ff053703          	ld	a4,-16(a0)
 888:	e398                	sd	a4,0(a5)
 88a:	a099                	j	8d0 <free+0x74>
 88c:	6398                	ld	a4,0(a5)
 88e:	00e7e463          	bltu	a5,a4,896 <free+0x3a>
 892:	00e6ea63          	bltu	a3,a4,8a6 <free+0x4a>
 896:	87ba                	mv	a5,a4
 898:	fed7fae3          	bgeu	a5,a3,88c <free+0x30>
 89c:	6398                	ld	a4,0(a5)
 89e:	00e6e463          	bltu	a3,a4,8a6 <free+0x4a>
 8a2:	fee7eae3          	bltu	a5,a4,896 <free+0x3a>
 8a6:	ff852583          	lw	a1,-8(a0)
 8aa:	6390                	ld	a2,0(a5)
 8ac:	02059713          	slli	a4,a1,0x20
 8b0:	9301                	srli	a4,a4,0x20
 8b2:	0712                	slli	a4,a4,0x4
 8b4:	9736                	add	a4,a4,a3
 8b6:	fae60ae3          	beq	a2,a4,86a <free+0xe>
 8ba:	fec53823          	sd	a2,-16(a0)
 8be:	4790                	lw	a2,8(a5)
 8c0:	02061713          	slli	a4,a2,0x20
 8c4:	9301                	srli	a4,a4,0x20
 8c6:	0712                	slli	a4,a4,0x4
 8c8:	973e                	add	a4,a4,a5
 8ca:	fae689e3          	beq	a3,a4,87c <free+0x20>
 8ce:	e394                	sd	a3,0(a5)
 8d0:	00000717          	auipc	a4,0x0
 8d4:	26f73423          	sd	a5,616(a4) # b38 <freep>
 8d8:	8082                	ret

00000000000008da <malloc>:
 8da:	7139                	addi	sp,sp,-64
 8dc:	fc06                	sd	ra,56(sp)
 8de:	f822                	sd	s0,48(sp)
 8e0:	f426                	sd	s1,40(sp)
 8e2:	f04a                	sd	s2,32(sp)
 8e4:	ec4e                	sd	s3,24(sp)
 8e6:	e852                	sd	s4,16(sp)
 8e8:	e456                	sd	s5,8(sp)
 8ea:	02051413          	slli	s0,a0,0x20
 8ee:	9001                	srli	s0,s0,0x20
 8f0:	043d                	addi	s0,s0,15
 8f2:	8011                	srli	s0,s0,0x4
 8f4:	0014091b          	addiw	s2,s0,1
 8f8:	0405                	addi	s0,s0,1
 8fa:	00000517          	auipc	a0,0x0
 8fe:	23e53503          	ld	a0,574(a0) # b38 <freep>
 902:	c905                	beqz	a0,932 <malloc+0x58>
 904:	611c                	ld	a5,0(a0)
 906:	4798                	lw	a4,8(a5)
 908:	04877163          	bgeu	a4,s0,94a <malloc+0x70>
 90c:	89ca                	mv	s3,s2
 90e:	0009071b          	sext.w	a4,s2
 912:	6685                	lui	a3,0x1
 914:	00d77363          	bgeu	a4,a3,91a <malloc+0x40>
 918:	6985                	lui	s3,0x1
 91a:	00098a1b          	sext.w	s4,s3
 91e:	1982                	slli	s3,s3,0x20
 920:	0209d993          	srli	s3,s3,0x20
 924:	0992                	slli	s3,s3,0x4
 926:	00000497          	auipc	s1,0x0
 92a:	21248493          	addi	s1,s1,530 # b38 <freep>
 92e:	5afd                	li	s5,-1
 930:	a0bd                	j	99e <malloc+0xc4>
 932:	00000797          	auipc	a5,0x0
 936:	20e78793          	addi	a5,a5,526 # b40 <base>
 93a:	00000717          	auipc	a4,0x0
 93e:	1ef73f23          	sd	a5,510(a4) # b38 <freep>
 942:	e39c                	sd	a5,0(a5)
 944:	0007a423          	sw	zero,8(a5)
 948:	b7d1                	j	90c <malloc+0x32>
 94a:	02e40a63          	beq	s0,a4,97e <malloc+0xa4>
 94e:	4127073b          	subw	a4,a4,s2
 952:	c798                	sw	a4,8(a5)
 954:	1702                	slli	a4,a4,0x20
 956:	9301                	srli	a4,a4,0x20
 958:	0712                	slli	a4,a4,0x4
 95a:	97ba                	add	a5,a5,a4
 95c:	0127a423          	sw	s2,8(a5)
 960:	00000717          	auipc	a4,0x0
 964:	1ca73c23          	sd	a0,472(a4) # b38 <freep>
 968:	01078513          	addi	a0,a5,16
 96c:	70e2                	ld	ra,56(sp)
 96e:	7442                	ld	s0,48(sp)
 970:	74a2                	ld	s1,40(sp)
 972:	7902                	ld	s2,32(sp)
 974:	69e2                	ld	s3,24(sp)
 976:	6a42                	ld	s4,16(sp)
 978:	6aa2                	ld	s5,8(sp)
 97a:	6121                	addi	sp,sp,64
 97c:	8082                	ret
 97e:	6398                	ld	a4,0(a5)
 980:	e118                	sd	a4,0(a0)
 982:	bff9                	j	960 <malloc+0x86>
 984:	01452423          	sw	s4,8(a0)
 988:	0541                	addi	a0,a0,16
 98a:	00000097          	auipc	ra,0x0
 98e:	ed2080e7          	jalr	-302(ra) # 85c <free>
 992:	6088                	ld	a0,0(s1)
 994:	dd61                	beqz	a0,96c <malloc+0x92>
 996:	611c                	ld	a5,0(a0)
 998:	4798                	lw	a4,8(a5)
 99a:	fa8778e3          	bgeu	a4,s0,94a <malloc+0x70>
 99e:	6098                	ld	a4,0(s1)
 9a0:	853e                	mv	a0,a5
 9a2:	fef71ae3          	bne	a4,a5,996 <malloc+0xbc>
 9a6:	854e                	mv	a0,s3
 9a8:	00000097          	auipc	ra,0x0
 9ac:	8d8080e7          	jalr	-1832(ra) # 280 <sbrk>
 9b0:	fd551ae3          	bne	a0,s5,984 <malloc+0xaa>
 9b4:	4501                	li	a0,0
 9b6:	bf5d                	j	96c <malloc+0x92>
