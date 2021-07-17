
_oscmp_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_success>:
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	842a                	mv	s0,a0
   a:	00001517          	auipc	a0,0x1
   e:	a2e50513          	addi	a0,a0,-1490 # a38 <malloc+0x118>
  12:	00001097          	auipc	ra,0x1
  16:	868080e7          	jalr	-1944(ra) # 87a <printf>
  1a:	600c                	ld	a1,0(s0)
  1c:	cd99                	beqz	a1,3a <print_success+0x3a>
  1e:	0421                	addi	s0,s0,8
  20:	00001497          	auipc	s1,0x1
  24:	a3048493          	addi	s1,s1,-1488 # a50 <malloc+0x130>
  28:	8526                	mv	a0,s1
  2a:	00001097          	auipc	ra,0x1
  2e:	850080e7          	jalr	-1968(ra) # 87a <printf>
  32:	0421                	addi	s0,s0,8
  34:	ff843583          	ld	a1,-8(s0)
  38:	f9e5                	bnez	a1,28 <print_success+0x28>
  3a:	00001517          	auipc	a0,0x1
  3e:	a1e50513          	addi	a0,a0,-1506 # a58 <malloc+0x138>
  42:	00001097          	auipc	ra,0x1
  46:	838080e7          	jalr	-1992(ra) # 87a <printf>
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
  64:	24e080e7          	jalr	590(ra) # 2ae <fork>
  68:	ed09                	bnez	a0,82 <test+0x2e>
  6a:	4601                	li	a2,0
  6c:	85a2                	mv	a1,s0
  6e:	8526                	mv	a0,s1
  70:	00000097          	auipc	ra,0x0
  74:	366080e7          	jalr	870(ra) # 3d6 <execve>
  78:	70a2                	ld	ra,40(sp)
  7a:	7402                	ld	s0,32(sp)
  7c:	64e2                	ld	s1,24(sp)
  7e:	6145                	addi	sp,sp,48
  80:	8082                	ret
  82:	0068                	addi	a0,sp,12
  84:	00000097          	auipc	ra,0x0
  88:	232080e7          	jalr	562(ra) # 2b6 <wait>
  8c:	47b2                	lw	a5,12(sp)
  8e:	fe07c5e3          	bltz	a5,78 <test+0x24>
  92:	8522                	mv	a0,s0
  94:	00000097          	auipc	ra,0x0
  98:	f6c080e7          	jalr	-148(ra) # 0 <print_success>
  9c:	bff1                	j	78 <test+0x24>

000000000000009e <main>:
  9e:	714d                	addi	sp,sp,-336
  a0:	e686                	sd	ra,328(sp)
  a2:	4589                	li	a1,2
  a4:	00001517          	auipc	a0,0x1
  a8:	9c450513          	addi	a0,a0,-1596 # a68 <malloc+0x148>
  ac:	00000097          	auipc	ra,0x0
  b0:	212080e7          	jalr	530(ra) # 2be <open>
  b4:	4501                	li	a0,0
  b6:	00000097          	auipc	ra,0x0
  ba:	220080e7          	jalr	544(ra) # 2d6 <dup>
  be:	4501                	li	a0,0
  c0:	00000097          	auipc	ra,0x0
  c4:	216080e7          	jalr	534(ra) # 2d6 <dup>
  c8:	00001797          	auipc	a5,0x1
  cc:	9a878793          	addi	a5,a5,-1624 # a70 <malloc+0x150>
  d0:	f63e                	sd	a5,296(sp)
  d2:	00001797          	auipc	a5,0x1
  d6:	9a678793          	addi	a5,a5,-1626 # a78 <malloc+0x158>
  da:	fa3e                	sd	a5,304(sp)
  dc:	fe02                	sd	zero,312(sp)
  de:	00001797          	auipc	a5,0x1
  e2:	a3278793          	addi	a5,a5,-1486 # b10 <malloc+0x1f0>
  e6:	638c                	ld	a1,0(a5)
  e8:	6790                	ld	a2,8(a5)
  ea:	6b94                	ld	a3,16(a5)
  ec:	6f98                	ld	a4,24(a5)
  ee:	e62e                	sd	a1,264(sp)
  f0:	ea32                	sd	a2,272(sp)
  f2:	ee36                	sd	a3,280(sp)
  f4:	f23a                	sd	a4,288(sp)
  f6:	738c                	ld	a1,32(a5)
  f8:	7790                	ld	a2,40(a5)
  fa:	7b94                	ld	a3,48(a5)
  fc:	7f98                	ld	a4,56(a5)
  fe:	f5ae                	sd	a1,232(sp)
 100:	f9b2                	sd	a2,240(sp)
 102:	fdb6                	sd	a3,248(sp)
 104:	e23a                	sd	a4,256(sp)
 106:	00001717          	auipc	a4,0x1
 10a:	99270713          	addi	a4,a4,-1646 # a98 <malloc+0x178>
 10e:	e9ba                	sd	a4,208(sp)
 110:	00001717          	auipc	a4,0x1
 114:	99870713          	addi	a4,a4,-1640 # aa8 <malloc+0x188>
 118:	edba                	sd	a4,216(sp)
 11a:	f182                	sd	zero,224(sp)
 11c:	00001697          	auipc	a3,0x1
 120:	99c68693          	addi	a3,a3,-1636 # ab8 <malloc+0x198>
 124:	e1b6                	sd	a3,192(sp)
 126:	e582                	sd	zero,200(sp)
 128:	00001697          	auipc	a3,0x1
 12c:	99868693          	addi	a3,a3,-1640 # ac0 <malloc+0x1a0>
 130:	f936                	sd	a3,176(sp)
 132:	fd02                	sd	zero,184(sp)
 134:	00001697          	auipc	a3,0x1
 138:	99468693          	addi	a3,a3,-1644 # ac8 <malloc+0x1a8>
 13c:	f136                	sd	a3,160(sp)
 13e:	f502                	sd	zero,168(sp)
 140:	00001697          	auipc	a3,0x1
 144:	99068693          	addi	a3,a3,-1648 # ad0 <malloc+0x1b0>
 148:	e536                	sd	a3,136(sp)
 14a:	e93a                	sd	a4,144(sp)
 14c:	ed02                	sd	zero,152(sp)
 14e:	63ac                	ld	a1,64(a5)
 150:	67b0                	ld	a2,72(a5)
 152:	6bb4                	ld	a3,80(a5)
 154:	6fb8                	ld	a4,88(a5)
 156:	73bc                	ld	a5,96(a5)
 158:	f0ae                	sd	a1,96(sp)
 15a:	f4b2                	sd	a2,104(sp)
 15c:	f8b6                	sd	a3,112(sp)
 15e:	fcba                	sd	a4,120(sp)
 160:	e13e                	sd	a5,128(sp)
 162:	00001797          	auipc	a5,0x1
 166:	97678793          	addi	a5,a5,-1674 # ad8 <malloc+0x1b8>
 16a:	e8be                	sd	a5,80(sp)
 16c:	ec82                	sd	zero,88(sp)
 16e:	00001797          	auipc	a5,0x1
 172:	97278793          	addi	a5,a5,-1678 # ae0 <malloc+0x1c0>
 176:	e0be                	sd	a5,64(sp)
 178:	e482                	sd	zero,72(sp)
 17a:	00001797          	auipc	a5,0x1
 17e:	96e78793          	addi	a5,a5,-1682 # ae8 <malloc+0x1c8>
 182:	f43e                	sd	a5,40(sp)
 184:	00001797          	auipc	a5,0x1
 188:	96c78793          	addi	a5,a5,-1684 # af0 <malloc+0x1d0>
 18c:	f83e                	sd	a5,48(sp)
 18e:	fc02                	sd	zero,56(sp)
 190:	00001797          	auipc	a5,0x1
 194:	96878793          	addi	a5,a5,-1688 # af8 <malloc+0x1d8>
 198:	ec3e                	sd	a5,24(sp)
 19a:	f002                	sd	zero,32(sp)
 19c:	00001797          	auipc	a5,0x1
 1a0:	96478793          	addi	a5,a5,-1692 # b00 <malloc+0x1e0>
 1a4:	e43e                	sd	a5,8(sp)
 1a6:	e802                	sd	zero,16(sp)
 1a8:	122c                	addi	a1,sp,296
 1aa:	00001517          	auipc	a0,0x1
 1ae:	95e50513          	addi	a0,a0,-1698 # b08 <malloc+0x1e8>
 1b2:	00000097          	auipc	ra,0x0
 1b6:	ea2080e7          	jalr	-350(ra) # 54 <test>
 1ba:	022c                	addi	a1,sp,264
 1bc:	00001517          	auipc	a0,0x1
 1c0:	94c50513          	addi	a0,a0,-1716 # b08 <malloc+0x1e8>
 1c4:	00000097          	auipc	ra,0x0
 1c8:	e90080e7          	jalr	-368(ra) # 54 <test>
 1cc:	11ac                	addi	a1,sp,232
 1ce:	00001517          	auipc	a0,0x1
 1d2:	93a50513          	addi	a0,a0,-1734 # b08 <malloc+0x1e8>
 1d6:	00000097          	auipc	ra,0x0
 1da:	e7e080e7          	jalr	-386(ra) # 54 <test>
 1de:	098c                	addi	a1,sp,208
 1e0:	00001517          	auipc	a0,0x1
 1e4:	92850513          	addi	a0,a0,-1752 # b08 <malloc+0x1e8>
 1e8:	00000097          	auipc	ra,0x0
 1ec:	e6c080e7          	jalr	-404(ra) # 54 <test>
 1f0:	018c                	addi	a1,sp,192
 1f2:	00001517          	auipc	a0,0x1
 1f6:	91650513          	addi	a0,a0,-1770 # b08 <malloc+0x1e8>
 1fa:	00000097          	auipc	ra,0x0
 1fe:	e5a080e7          	jalr	-422(ra) # 54 <test>
 202:	190c                	addi	a1,sp,176
 204:	00001517          	auipc	a0,0x1
 208:	90450513          	addi	a0,a0,-1788 # b08 <malloc+0x1e8>
 20c:	00000097          	auipc	ra,0x0
 210:	e48080e7          	jalr	-440(ra) # 54 <test>
 214:	110c                	addi	a1,sp,160
 216:	00001517          	auipc	a0,0x1
 21a:	8f250513          	addi	a0,a0,-1806 # b08 <malloc+0x1e8>
 21e:	00000097          	auipc	ra,0x0
 222:	e36080e7          	jalr	-458(ra) # 54 <test>
 226:	012c                	addi	a1,sp,136
 228:	00001517          	auipc	a0,0x1
 22c:	8e050513          	addi	a0,a0,-1824 # b08 <malloc+0x1e8>
 230:	00000097          	auipc	ra,0x0
 234:	e24080e7          	jalr	-476(ra) # 54 <test>
 238:	108c                	addi	a1,sp,96
 23a:	00001517          	auipc	a0,0x1
 23e:	8ce50513          	addi	a0,a0,-1842 # b08 <malloc+0x1e8>
 242:	00000097          	auipc	ra,0x0
 246:	e12080e7          	jalr	-494(ra) # 54 <test>
 24a:	088c                	addi	a1,sp,80
 24c:	00001517          	auipc	a0,0x1
 250:	8bc50513          	addi	a0,a0,-1860 # b08 <malloc+0x1e8>
 254:	00000097          	auipc	ra,0x0
 258:	e00080e7          	jalr	-512(ra) # 54 <test>
 25c:	008c                	addi	a1,sp,64
 25e:	00001517          	auipc	a0,0x1
 262:	8aa50513          	addi	a0,a0,-1878 # b08 <malloc+0x1e8>
 266:	00000097          	auipc	ra,0x0
 26a:	dee080e7          	jalr	-530(ra) # 54 <test>
 26e:	102c                	addi	a1,sp,40
 270:	00001517          	auipc	a0,0x1
 274:	89850513          	addi	a0,a0,-1896 # b08 <malloc+0x1e8>
 278:	00000097          	auipc	ra,0x0
 27c:	ddc080e7          	jalr	-548(ra) # 54 <test>
 280:	082c                	addi	a1,sp,24
 282:	00001517          	auipc	a0,0x1
 286:	88650513          	addi	a0,a0,-1914 # b08 <malloc+0x1e8>
 28a:	00000097          	auipc	ra,0x0
 28e:	dca080e7          	jalr	-566(ra) # 54 <test>
 292:	002c                	addi	a1,sp,8
 294:	00001517          	auipc	a0,0x1
 298:	87450513          	addi	a0,a0,-1932 # b08 <malloc+0x1e8>
 29c:	00000097          	auipc	ra,0x0
 2a0:	db8080e7          	jalr	-584(ra) # 54 <test>
 2a4:	00000097          	auipc	ra,0x0
 2a8:	150080e7          	jalr	336(ra) # 3f4 <kernel_panic>
 2ac:	a001                	j	2ac <main+0x20e>

00000000000002ae <fork>:
 2ae:	4885                	li	a7,1
 2b0:	00000073          	ecall
 2b4:	8082                	ret

00000000000002b6 <wait>:
 2b6:	488d                	li	a7,3
 2b8:	00000073          	ecall
 2bc:	8082                	ret

00000000000002be <open>:
 2be:	4889                	li	a7,2
 2c0:	00000073          	ecall
 2c4:	8082                	ret

00000000000002c6 <sbrk>:
 2c6:	4891                	li	a7,4
 2c8:	00000073          	ecall
 2cc:	8082                	ret

00000000000002ce <getcwd>:
 2ce:	48c5                	li	a7,17
 2d0:	00000073          	ecall
 2d4:	8082                	ret

00000000000002d6 <dup>:
 2d6:	48dd                	li	a7,23
 2d8:	00000073          	ecall
 2dc:	8082                	ret

00000000000002de <dup3>:
 2de:	48e1                	li	a7,24
 2e0:	00000073          	ecall
 2e4:	8082                	ret

00000000000002e6 <mkdirat>:
 2e6:	02200893          	li	a7,34
 2ea:	00000073          	ecall
 2ee:	8082                	ret

00000000000002f0 <unlinkat>:
 2f0:	02300893          	li	a7,35
 2f4:	00000073          	ecall
 2f8:	8082                	ret

00000000000002fa <linkat>:
 2fa:	02500893          	li	a7,37
 2fe:	00000073          	ecall
 302:	8082                	ret

0000000000000304 <umount2>:
 304:	02700893          	li	a7,39
 308:	00000073          	ecall
 30c:	8082                	ret

000000000000030e <mount>:
 30e:	02800893          	li	a7,40
 312:	00000073          	ecall
 316:	8082                	ret

0000000000000318 <chdir>:
 318:	03100893          	li	a7,49
 31c:	00000073          	ecall
 320:	8082                	ret

0000000000000322 <openat>:
 322:	03800893          	li	a7,56
 326:	00000073          	ecall
 32a:	8082                	ret

000000000000032c <close>:
 32c:	03900893          	li	a7,57
 330:	00000073          	ecall
 334:	8082                	ret

0000000000000336 <pipe2>:
 336:	03b00893          	li	a7,59
 33a:	00000073          	ecall
 33e:	8082                	ret

0000000000000340 <getdents64>:
 340:	03d00893          	li	a7,61
 344:	00000073          	ecall
 348:	8082                	ret

000000000000034a <read>:
 34a:	03f00893          	li	a7,63
 34e:	00000073          	ecall
 352:	8082                	ret

0000000000000354 <write>:
 354:	04000893          	li	a7,64
 358:	00000073          	ecall
 35c:	8082                	ret

000000000000035e <fstat>:
 35e:	05000893          	li	a7,80
 362:	00000073          	ecall
 366:	8082                	ret

0000000000000368 <exit>:
 368:	05d00893          	li	a7,93
 36c:	00000073          	ecall
 370:	8082                	ret

0000000000000372 <nanosleep>:
 372:	06500893          	li	a7,101
 376:	00000073          	ecall
 37a:	8082                	ret

000000000000037c <sched_yield>:
 37c:	07c00893          	li	a7,124
 380:	00000073          	ecall
 384:	8082                	ret

0000000000000386 <times>:
 386:	09900893          	li	a7,153
 38a:	00000073          	ecall
 38e:	8082                	ret

0000000000000390 <uname>:
 390:	0a000893          	li	a7,160
 394:	00000073          	ecall
 398:	8082                	ret

000000000000039a <gettimeofday>:
 39a:	0a900893          	li	a7,169
 39e:	00000073          	ecall
 3a2:	8082                	ret

00000000000003a4 <brk>:
 3a4:	0d600893          	li	a7,214
 3a8:	00000073          	ecall
 3ac:	8082                	ret

00000000000003ae <munmap>:
 3ae:	0d700893          	li	a7,215
 3b2:	00000073          	ecall
 3b6:	8082                	ret

00000000000003b8 <getpid>:
 3b8:	0ac00893          	li	a7,172
 3bc:	00000073          	ecall
 3c0:	8082                	ret

00000000000003c2 <getppid>:
 3c2:	0ad00893          	li	a7,173
 3c6:	00000073          	ecall
 3ca:	8082                	ret

00000000000003cc <clone>:
 3cc:	0dc00893          	li	a7,220
 3d0:	00000073          	ecall
 3d4:	8082                	ret

00000000000003d6 <execve>:
 3d6:	0dd00893          	li	a7,221
 3da:	00000073          	ecall
 3de:	8082                	ret

00000000000003e0 <mmap>:
 3e0:	0de00893          	li	a7,222
 3e4:	00000073          	ecall
 3e8:	8082                	ret

00000000000003ea <wait4>:
 3ea:	10400893          	li	a7,260
 3ee:	00000073          	ecall
 3f2:	8082                	ret

00000000000003f4 <kernel_panic>:
 3f4:	18f00893          	li	a7,399
 3f8:	00000073          	ecall
 3fc:	8082                	ret

00000000000003fe <strcpy>:
 3fe:	87aa                	mv	a5,a0
 400:	0585                	addi	a1,a1,1
 402:	0785                	addi	a5,a5,1
 404:	fff5c703          	lbu	a4,-1(a1)
 408:	fee78fa3          	sb	a4,-1(a5)
 40c:	fb75                	bnez	a4,400 <strcpy+0x2>
 40e:	8082                	ret

0000000000000410 <strcmp>:
 410:	00054783          	lbu	a5,0(a0)
 414:	cb91                	beqz	a5,428 <strcmp+0x18>
 416:	0005c703          	lbu	a4,0(a1)
 41a:	00f71763          	bne	a4,a5,428 <strcmp+0x18>
 41e:	0505                	addi	a0,a0,1
 420:	0585                	addi	a1,a1,1
 422:	00054783          	lbu	a5,0(a0)
 426:	fbe5                	bnez	a5,416 <strcmp+0x6>
 428:	0005c503          	lbu	a0,0(a1)
 42c:	40a7853b          	subw	a0,a5,a0
 430:	8082                	ret

0000000000000432 <strlen>:
 432:	00054783          	lbu	a5,0(a0)
 436:	cf81                	beqz	a5,44e <strlen+0x1c>
 438:	0505                	addi	a0,a0,1
 43a:	87aa                	mv	a5,a0
 43c:	4685                	li	a3,1
 43e:	9e89                	subw	a3,a3,a0
 440:	00f6853b          	addw	a0,a3,a5
 444:	0785                	addi	a5,a5,1
 446:	fff7c703          	lbu	a4,-1(a5)
 44a:	fb7d                	bnez	a4,440 <strlen+0xe>
 44c:	8082                	ret
 44e:	4501                	li	a0,0
 450:	8082                	ret

0000000000000452 <memset>:
 452:	ce09                	beqz	a2,46c <memset+0x1a>
 454:	87aa                	mv	a5,a0
 456:	fff6071b          	addiw	a4,a2,-1
 45a:	1702                	slli	a4,a4,0x20
 45c:	9301                	srli	a4,a4,0x20
 45e:	0705                	addi	a4,a4,1
 460:	972a                	add	a4,a4,a0
 462:	00b78023          	sb	a1,0(a5)
 466:	0785                	addi	a5,a5,1
 468:	fee79de3          	bne	a5,a4,462 <memset+0x10>
 46c:	8082                	ret

000000000000046e <strchr>:
 46e:	00054783          	lbu	a5,0(a0)
 472:	cb89                	beqz	a5,484 <strchr+0x16>
 474:	00f58963          	beq	a1,a5,486 <strchr+0x18>
 478:	0505                	addi	a0,a0,1
 47a:	00054783          	lbu	a5,0(a0)
 47e:	fbfd                	bnez	a5,474 <strchr+0x6>
 480:	4501                	li	a0,0
 482:	8082                	ret
 484:	4501                	li	a0,0
 486:	8082                	ret

0000000000000488 <gets>:
 488:	715d                	addi	sp,sp,-80
 48a:	e486                	sd	ra,72(sp)
 48c:	e0a2                	sd	s0,64(sp)
 48e:	fc26                	sd	s1,56(sp)
 490:	f84a                	sd	s2,48(sp)
 492:	f44e                	sd	s3,40(sp)
 494:	f052                	sd	s4,32(sp)
 496:	ec56                	sd	s5,24(sp)
 498:	e85a                	sd	s6,16(sp)
 49a:	8b2a                	mv	s6,a0
 49c:	89ae                	mv	s3,a1
 49e:	84aa                	mv	s1,a0
 4a0:	4401                	li	s0,0
 4a2:	4a29                	li	s4,10
 4a4:	4ab5                	li	s5,13
 4a6:	8922                	mv	s2,s0
 4a8:	2405                	addiw	s0,s0,1
 4aa:	03345863          	bge	s0,s3,4da <gets+0x52>
 4ae:	4605                	li	a2,1
 4b0:	00f10593          	addi	a1,sp,15
 4b4:	4501                	li	a0,0
 4b6:	00000097          	auipc	ra,0x0
 4ba:	e94080e7          	jalr	-364(ra) # 34a <read>
 4be:	00a05e63          	blez	a0,4da <gets+0x52>
 4c2:	00f14783          	lbu	a5,15(sp)
 4c6:	00f48023          	sb	a5,0(s1)
 4ca:	01478763          	beq	a5,s4,4d8 <gets+0x50>
 4ce:	0485                	addi	s1,s1,1
 4d0:	fd579be3          	bne	a5,s5,4a6 <gets+0x1e>
 4d4:	8922                	mv	s2,s0
 4d6:	a011                	j	4da <gets+0x52>
 4d8:	8922                	mv	s2,s0
 4da:	995a                	add	s2,s2,s6
 4dc:	00090023          	sb	zero,0(s2)
 4e0:	855a                	mv	a0,s6
 4e2:	60a6                	ld	ra,72(sp)
 4e4:	6406                	ld	s0,64(sp)
 4e6:	74e2                	ld	s1,56(sp)
 4e8:	7942                	ld	s2,48(sp)
 4ea:	79a2                	ld	s3,40(sp)
 4ec:	7a02                	ld	s4,32(sp)
 4ee:	6ae2                	ld	s5,24(sp)
 4f0:	6b42                	ld	s6,16(sp)
 4f2:	6161                	addi	sp,sp,80
 4f4:	8082                	ret

00000000000004f6 <atoi>:
 4f6:	86aa                	mv	a3,a0
 4f8:	00054603          	lbu	a2,0(a0)
 4fc:	fd06079b          	addiw	a5,a2,-48
 500:	0ff7f793          	andi	a5,a5,255
 504:	4725                	li	a4,9
 506:	02f76663          	bltu	a4,a5,532 <atoi+0x3c>
 50a:	4501                	li	a0,0
 50c:	45a5                	li	a1,9
 50e:	0685                	addi	a3,a3,1
 510:	0025179b          	slliw	a5,a0,0x2
 514:	9fa9                	addw	a5,a5,a0
 516:	0017979b          	slliw	a5,a5,0x1
 51a:	9fb1                	addw	a5,a5,a2
 51c:	fd07851b          	addiw	a0,a5,-48
 520:	0006c603          	lbu	a2,0(a3)
 524:	fd06071b          	addiw	a4,a2,-48
 528:	0ff77713          	andi	a4,a4,255
 52c:	fee5f1e3          	bgeu	a1,a4,50e <atoi+0x18>
 530:	8082                	ret
 532:	4501                	li	a0,0
 534:	8082                	ret

0000000000000536 <memmove>:
 536:	02b57463          	bgeu	a0,a1,55e <memmove+0x28>
 53a:	04c05663          	blez	a2,586 <memmove+0x50>
 53e:	fff6079b          	addiw	a5,a2,-1
 542:	1782                	slli	a5,a5,0x20
 544:	9381                	srli	a5,a5,0x20
 546:	0785                	addi	a5,a5,1
 548:	97aa                	add	a5,a5,a0
 54a:	872a                	mv	a4,a0
 54c:	0585                	addi	a1,a1,1
 54e:	0705                	addi	a4,a4,1
 550:	fff5c683          	lbu	a3,-1(a1)
 554:	fed70fa3          	sb	a3,-1(a4)
 558:	fee79ae3          	bne	a5,a4,54c <memmove+0x16>
 55c:	8082                	ret
 55e:	00c50733          	add	a4,a0,a2
 562:	95b2                	add	a1,a1,a2
 564:	02c05163          	blez	a2,586 <memmove+0x50>
 568:	fff6079b          	addiw	a5,a2,-1
 56c:	1782                	slli	a5,a5,0x20
 56e:	9381                	srli	a5,a5,0x20
 570:	fff7c793          	not	a5,a5
 574:	97ba                	add	a5,a5,a4
 576:	15fd                	addi	a1,a1,-1
 578:	177d                	addi	a4,a4,-1
 57a:	0005c683          	lbu	a3,0(a1)
 57e:	00d70023          	sb	a3,0(a4)
 582:	fee79ae3          	bne	a5,a4,576 <memmove+0x40>
 586:	8082                	ret

0000000000000588 <memcmp>:
 588:	fff6069b          	addiw	a3,a2,-1
 58c:	c605                	beqz	a2,5b4 <memcmp+0x2c>
 58e:	1682                	slli	a3,a3,0x20
 590:	9281                	srli	a3,a3,0x20
 592:	0685                	addi	a3,a3,1
 594:	96aa                	add	a3,a3,a0
 596:	00054783          	lbu	a5,0(a0)
 59a:	0005c703          	lbu	a4,0(a1)
 59e:	00e79863          	bne	a5,a4,5ae <memcmp+0x26>
 5a2:	0505                	addi	a0,a0,1
 5a4:	0585                	addi	a1,a1,1
 5a6:	fed518e3          	bne	a0,a3,596 <memcmp+0xe>
 5aa:	4501                	li	a0,0
 5ac:	8082                	ret
 5ae:	40e7853b          	subw	a0,a5,a4
 5b2:	8082                	ret
 5b4:	4501                	li	a0,0
 5b6:	8082                	ret

00000000000005b8 <memcpy>:
 5b8:	1141                	addi	sp,sp,-16
 5ba:	e406                	sd	ra,8(sp)
 5bc:	00000097          	auipc	ra,0x0
 5c0:	f7a080e7          	jalr	-134(ra) # 536 <memmove>
 5c4:	60a2                	ld	ra,8(sp)
 5c6:	0141                	addi	sp,sp,16
 5c8:	8082                	ret

00000000000005ca <putc>:
 5ca:	1101                	addi	sp,sp,-32
 5cc:	ec06                	sd	ra,24(sp)
 5ce:	00b107a3          	sb	a1,15(sp)
 5d2:	4605                	li	a2,1
 5d4:	00f10593          	addi	a1,sp,15
 5d8:	00000097          	auipc	ra,0x0
 5dc:	d7c080e7          	jalr	-644(ra) # 354 <write>
 5e0:	60e2                	ld	ra,24(sp)
 5e2:	6105                	addi	sp,sp,32
 5e4:	8082                	ret

00000000000005e6 <printint>:
 5e6:	7179                	addi	sp,sp,-48
 5e8:	f406                	sd	ra,40(sp)
 5ea:	f022                	sd	s0,32(sp)
 5ec:	ec26                	sd	s1,24(sp)
 5ee:	e84a                	sd	s2,16(sp)
 5f0:	84aa                	mv	s1,a0
 5f2:	c299                	beqz	a3,5f8 <printint+0x12>
 5f4:	0805c363          	bltz	a1,67a <printint+0x94>
 5f8:	2581                	sext.w	a1,a1
 5fa:	4881                	li	a7,0
 5fc:	868a                	mv	a3,sp
 5fe:	4701                	li	a4,0
 600:	2601                	sext.w	a2,a2
 602:	00000517          	auipc	a0,0x0
 606:	57e50513          	addi	a0,a0,1406 # b80 <digits>
 60a:	883a                	mv	a6,a4
 60c:	2705                	addiw	a4,a4,1
 60e:	02c5f7bb          	remuw	a5,a1,a2
 612:	1782                	slli	a5,a5,0x20
 614:	9381                	srli	a5,a5,0x20
 616:	97aa                	add	a5,a5,a0
 618:	0007c783          	lbu	a5,0(a5)
 61c:	00f68023          	sb	a5,0(a3)
 620:	0005879b          	sext.w	a5,a1
 624:	02c5d5bb          	divuw	a1,a1,a2
 628:	0685                	addi	a3,a3,1
 62a:	fec7f0e3          	bgeu	a5,a2,60a <printint+0x24>
 62e:	00088a63          	beqz	a7,642 <printint+0x5c>
 632:	081c                	addi	a5,sp,16
 634:	973e                	add	a4,a4,a5
 636:	02d00793          	li	a5,45
 63a:	fef70823          	sb	a5,-16(a4)
 63e:	0028071b          	addiw	a4,a6,2
 642:	02e05663          	blez	a4,66e <printint+0x88>
 646:	00e10433          	add	s0,sp,a4
 64a:	fff10913          	addi	s2,sp,-1
 64e:	993a                	add	s2,s2,a4
 650:	377d                	addiw	a4,a4,-1
 652:	1702                	slli	a4,a4,0x20
 654:	9301                	srli	a4,a4,0x20
 656:	40e90933          	sub	s2,s2,a4
 65a:	fff44583          	lbu	a1,-1(s0)
 65e:	8526                	mv	a0,s1
 660:	00000097          	auipc	ra,0x0
 664:	f6a080e7          	jalr	-150(ra) # 5ca <putc>
 668:	147d                	addi	s0,s0,-1
 66a:	ff2418e3          	bne	s0,s2,65a <printint+0x74>
 66e:	70a2                	ld	ra,40(sp)
 670:	7402                	ld	s0,32(sp)
 672:	64e2                	ld	s1,24(sp)
 674:	6942                	ld	s2,16(sp)
 676:	6145                	addi	sp,sp,48
 678:	8082                	ret
 67a:	40b005bb          	negw	a1,a1
 67e:	4885                	li	a7,1
 680:	bfb5                	j	5fc <printint+0x16>

0000000000000682 <vprintf>:
 682:	7119                	addi	sp,sp,-128
 684:	fc86                	sd	ra,120(sp)
 686:	f8a2                	sd	s0,112(sp)
 688:	f4a6                	sd	s1,104(sp)
 68a:	f0ca                	sd	s2,96(sp)
 68c:	ecce                	sd	s3,88(sp)
 68e:	e8d2                	sd	s4,80(sp)
 690:	e4d6                	sd	s5,72(sp)
 692:	e0da                	sd	s6,64(sp)
 694:	fc5e                	sd	s7,56(sp)
 696:	f862                	sd	s8,48(sp)
 698:	f466                	sd	s9,40(sp)
 69a:	f06a                	sd	s10,32(sp)
 69c:	ec6e                	sd	s11,24(sp)
 69e:	0005c483          	lbu	s1,0(a1)
 6a2:	18048c63          	beqz	s1,83a <vprintf+0x1b8>
 6a6:	8a2a                	mv	s4,a0
 6a8:	8ab2                	mv	s5,a2
 6aa:	00158413          	addi	s0,a1,1
 6ae:	4901                	li	s2,0
 6b0:	02500993          	li	s3,37
 6b4:	06400b93          	li	s7,100
 6b8:	06c00c13          	li	s8,108
 6bc:	07800c93          	li	s9,120
 6c0:	07000d13          	li	s10,112
 6c4:	07300d93          	li	s11,115
 6c8:	00000b17          	auipc	s6,0x0
 6cc:	4b8b0b13          	addi	s6,s6,1208 # b80 <digits>
 6d0:	a839                	j	6ee <vprintf+0x6c>
 6d2:	85a6                	mv	a1,s1
 6d4:	8552                	mv	a0,s4
 6d6:	00000097          	auipc	ra,0x0
 6da:	ef4080e7          	jalr	-268(ra) # 5ca <putc>
 6de:	a019                	j	6e4 <vprintf+0x62>
 6e0:	01390f63          	beq	s2,s3,6fe <vprintf+0x7c>
 6e4:	0405                	addi	s0,s0,1
 6e6:	fff44483          	lbu	s1,-1(s0)
 6ea:	14048863          	beqz	s1,83a <vprintf+0x1b8>
 6ee:	0004879b          	sext.w	a5,s1
 6f2:	fe0917e3          	bnez	s2,6e0 <vprintf+0x5e>
 6f6:	fd379ee3          	bne	a5,s3,6d2 <vprintf+0x50>
 6fa:	893e                	mv	s2,a5
 6fc:	b7e5                	j	6e4 <vprintf+0x62>
 6fe:	03778e63          	beq	a5,s7,73a <vprintf+0xb8>
 702:	05878a63          	beq	a5,s8,756 <vprintf+0xd4>
 706:	07978663          	beq	a5,s9,772 <vprintf+0xf0>
 70a:	09a78263          	beq	a5,s10,78e <vprintf+0x10c>
 70e:	0db78363          	beq	a5,s11,7d4 <vprintf+0x152>
 712:	06300713          	li	a4,99
 716:	0ee78b63          	beq	a5,a4,80c <vprintf+0x18a>
 71a:	11378563          	beq	a5,s3,824 <vprintf+0x1a2>
 71e:	85ce                	mv	a1,s3
 720:	8552                	mv	a0,s4
 722:	00000097          	auipc	ra,0x0
 726:	ea8080e7          	jalr	-344(ra) # 5ca <putc>
 72a:	85a6                	mv	a1,s1
 72c:	8552                	mv	a0,s4
 72e:	00000097          	auipc	ra,0x0
 732:	e9c080e7          	jalr	-356(ra) # 5ca <putc>
 736:	4901                	li	s2,0
 738:	b775                	j	6e4 <vprintf+0x62>
 73a:	008a8493          	addi	s1,s5,8
 73e:	4685                	li	a3,1
 740:	4629                	li	a2,10
 742:	000aa583          	lw	a1,0(s5)
 746:	8552                	mv	a0,s4
 748:	00000097          	auipc	ra,0x0
 74c:	e9e080e7          	jalr	-354(ra) # 5e6 <printint>
 750:	8aa6                	mv	s5,s1
 752:	4901                	li	s2,0
 754:	bf41                	j	6e4 <vprintf+0x62>
 756:	008a8493          	addi	s1,s5,8
 75a:	4681                	li	a3,0
 75c:	4629                	li	a2,10
 75e:	000aa583          	lw	a1,0(s5)
 762:	8552                	mv	a0,s4
 764:	00000097          	auipc	ra,0x0
 768:	e82080e7          	jalr	-382(ra) # 5e6 <printint>
 76c:	8aa6                	mv	s5,s1
 76e:	4901                	li	s2,0
 770:	bf95                	j	6e4 <vprintf+0x62>
 772:	008a8493          	addi	s1,s5,8
 776:	4681                	li	a3,0
 778:	4641                	li	a2,16
 77a:	000aa583          	lw	a1,0(s5)
 77e:	8552                	mv	a0,s4
 780:	00000097          	auipc	ra,0x0
 784:	e66080e7          	jalr	-410(ra) # 5e6 <printint>
 788:	8aa6                	mv	s5,s1
 78a:	4901                	li	s2,0
 78c:	bfa1                	j	6e4 <vprintf+0x62>
 78e:	008a8793          	addi	a5,s5,8
 792:	e43e                	sd	a5,8(sp)
 794:	000ab903          	ld	s2,0(s5)
 798:	03000593          	li	a1,48
 79c:	8552                	mv	a0,s4
 79e:	00000097          	auipc	ra,0x0
 7a2:	e2c080e7          	jalr	-468(ra) # 5ca <putc>
 7a6:	85e6                	mv	a1,s9
 7a8:	8552                	mv	a0,s4
 7aa:	00000097          	auipc	ra,0x0
 7ae:	e20080e7          	jalr	-480(ra) # 5ca <putc>
 7b2:	44c1                	li	s1,16
 7b4:	03c95793          	srli	a5,s2,0x3c
 7b8:	97da                	add	a5,a5,s6
 7ba:	0007c583          	lbu	a1,0(a5)
 7be:	8552                	mv	a0,s4
 7c0:	00000097          	auipc	ra,0x0
 7c4:	e0a080e7          	jalr	-502(ra) # 5ca <putc>
 7c8:	0912                	slli	s2,s2,0x4
 7ca:	34fd                	addiw	s1,s1,-1
 7cc:	f4e5                	bnez	s1,7b4 <vprintf+0x132>
 7ce:	6aa2                	ld	s5,8(sp)
 7d0:	4901                	li	s2,0
 7d2:	bf09                	j	6e4 <vprintf+0x62>
 7d4:	008a8493          	addi	s1,s5,8
 7d8:	000ab903          	ld	s2,0(s5)
 7dc:	02090163          	beqz	s2,7fe <vprintf+0x17c>
 7e0:	00094583          	lbu	a1,0(s2)
 7e4:	c9a1                	beqz	a1,834 <vprintf+0x1b2>
 7e6:	8552                	mv	a0,s4
 7e8:	00000097          	auipc	ra,0x0
 7ec:	de2080e7          	jalr	-542(ra) # 5ca <putc>
 7f0:	0905                	addi	s2,s2,1
 7f2:	00094583          	lbu	a1,0(s2)
 7f6:	f9e5                	bnez	a1,7e6 <vprintf+0x164>
 7f8:	8aa6                	mv	s5,s1
 7fa:	4901                	li	s2,0
 7fc:	b5e5                	j	6e4 <vprintf+0x62>
 7fe:	00000917          	auipc	s2,0x0
 802:	37a90913          	addi	s2,s2,890 # b78 <malloc+0x258>
 806:	02800593          	li	a1,40
 80a:	bff1                	j	7e6 <vprintf+0x164>
 80c:	008a8493          	addi	s1,s5,8
 810:	000ac583          	lbu	a1,0(s5)
 814:	8552                	mv	a0,s4
 816:	00000097          	auipc	ra,0x0
 81a:	db4080e7          	jalr	-588(ra) # 5ca <putc>
 81e:	8aa6                	mv	s5,s1
 820:	4901                	li	s2,0
 822:	b5c9                	j	6e4 <vprintf+0x62>
 824:	85ce                	mv	a1,s3
 826:	8552                	mv	a0,s4
 828:	00000097          	auipc	ra,0x0
 82c:	da2080e7          	jalr	-606(ra) # 5ca <putc>
 830:	4901                	li	s2,0
 832:	bd4d                	j	6e4 <vprintf+0x62>
 834:	8aa6                	mv	s5,s1
 836:	4901                	li	s2,0
 838:	b575                	j	6e4 <vprintf+0x62>
 83a:	70e6                	ld	ra,120(sp)
 83c:	7446                	ld	s0,112(sp)
 83e:	74a6                	ld	s1,104(sp)
 840:	7906                	ld	s2,96(sp)
 842:	69e6                	ld	s3,88(sp)
 844:	6a46                	ld	s4,80(sp)
 846:	6aa6                	ld	s5,72(sp)
 848:	6b06                	ld	s6,64(sp)
 84a:	7be2                	ld	s7,56(sp)
 84c:	7c42                	ld	s8,48(sp)
 84e:	7ca2                	ld	s9,40(sp)
 850:	7d02                	ld	s10,32(sp)
 852:	6de2                	ld	s11,24(sp)
 854:	6109                	addi	sp,sp,128
 856:	8082                	ret

0000000000000858 <fprintf>:
 858:	715d                	addi	sp,sp,-80
 85a:	ec06                	sd	ra,24(sp)
 85c:	f032                	sd	a2,32(sp)
 85e:	f436                	sd	a3,40(sp)
 860:	f83a                	sd	a4,48(sp)
 862:	fc3e                	sd	a5,56(sp)
 864:	e0c2                	sd	a6,64(sp)
 866:	e4c6                	sd	a7,72(sp)
 868:	1010                	addi	a2,sp,32
 86a:	e432                	sd	a2,8(sp)
 86c:	00000097          	auipc	ra,0x0
 870:	e16080e7          	jalr	-490(ra) # 682 <vprintf>
 874:	60e2                	ld	ra,24(sp)
 876:	6161                	addi	sp,sp,80
 878:	8082                	ret

000000000000087a <printf>:
 87a:	711d                	addi	sp,sp,-96
 87c:	ec06                	sd	ra,24(sp)
 87e:	f42e                	sd	a1,40(sp)
 880:	f832                	sd	a2,48(sp)
 882:	fc36                	sd	a3,56(sp)
 884:	e0ba                	sd	a4,64(sp)
 886:	e4be                	sd	a5,72(sp)
 888:	e8c2                	sd	a6,80(sp)
 88a:	ecc6                	sd	a7,88(sp)
 88c:	1030                	addi	a2,sp,40
 88e:	e432                	sd	a2,8(sp)
 890:	85aa                	mv	a1,a0
 892:	4505                	li	a0,1
 894:	00000097          	auipc	ra,0x0
 898:	dee080e7          	jalr	-530(ra) # 682 <vprintf>
 89c:	60e2                	ld	ra,24(sp)
 89e:	6125                	addi	sp,sp,96
 8a0:	8082                	ret

00000000000008a2 <free>:
 8a2:	ff050693          	addi	a3,a0,-16
 8a6:	00000797          	auipc	a5,0x0
 8aa:	2f27b783          	ld	a5,754(a5) # b98 <freep>
 8ae:	a805                	j	8de <free+0x3c>
 8b0:	4618                	lw	a4,8(a2)
 8b2:	9db9                	addw	a1,a1,a4
 8b4:	feb52c23          	sw	a1,-8(a0)
 8b8:	6398                	ld	a4,0(a5)
 8ba:	6318                	ld	a4,0(a4)
 8bc:	fee53823          	sd	a4,-16(a0)
 8c0:	a091                	j	904 <free+0x62>
 8c2:	ff852703          	lw	a4,-8(a0)
 8c6:	9e39                	addw	a2,a2,a4
 8c8:	c790                	sw	a2,8(a5)
 8ca:	ff053703          	ld	a4,-16(a0)
 8ce:	e398                	sd	a4,0(a5)
 8d0:	a099                	j	916 <free+0x74>
 8d2:	6398                	ld	a4,0(a5)
 8d4:	00e7e463          	bltu	a5,a4,8dc <free+0x3a>
 8d8:	00e6ea63          	bltu	a3,a4,8ec <free+0x4a>
 8dc:	87ba                	mv	a5,a4
 8de:	fed7fae3          	bgeu	a5,a3,8d2 <free+0x30>
 8e2:	6398                	ld	a4,0(a5)
 8e4:	00e6e463          	bltu	a3,a4,8ec <free+0x4a>
 8e8:	fee7eae3          	bltu	a5,a4,8dc <free+0x3a>
 8ec:	ff852583          	lw	a1,-8(a0)
 8f0:	6390                	ld	a2,0(a5)
 8f2:	02059713          	slli	a4,a1,0x20
 8f6:	9301                	srli	a4,a4,0x20
 8f8:	0712                	slli	a4,a4,0x4
 8fa:	9736                	add	a4,a4,a3
 8fc:	fae60ae3          	beq	a2,a4,8b0 <free+0xe>
 900:	fec53823          	sd	a2,-16(a0)
 904:	4790                	lw	a2,8(a5)
 906:	02061713          	slli	a4,a2,0x20
 90a:	9301                	srli	a4,a4,0x20
 90c:	0712                	slli	a4,a4,0x4
 90e:	973e                	add	a4,a4,a5
 910:	fae689e3          	beq	a3,a4,8c2 <free+0x20>
 914:	e394                	sd	a3,0(a5)
 916:	00000717          	auipc	a4,0x0
 91a:	28f73123          	sd	a5,642(a4) # b98 <freep>
 91e:	8082                	ret

0000000000000920 <malloc>:
 920:	7139                	addi	sp,sp,-64
 922:	fc06                	sd	ra,56(sp)
 924:	f822                	sd	s0,48(sp)
 926:	f426                	sd	s1,40(sp)
 928:	f04a                	sd	s2,32(sp)
 92a:	ec4e                	sd	s3,24(sp)
 92c:	e852                	sd	s4,16(sp)
 92e:	e456                	sd	s5,8(sp)
 930:	02051413          	slli	s0,a0,0x20
 934:	9001                	srli	s0,s0,0x20
 936:	043d                	addi	s0,s0,15
 938:	8011                	srli	s0,s0,0x4
 93a:	0014091b          	addiw	s2,s0,1
 93e:	0405                	addi	s0,s0,1
 940:	00000517          	auipc	a0,0x0
 944:	25853503          	ld	a0,600(a0) # b98 <freep>
 948:	c905                	beqz	a0,978 <malloc+0x58>
 94a:	611c                	ld	a5,0(a0)
 94c:	4798                	lw	a4,8(a5)
 94e:	04877163          	bgeu	a4,s0,990 <malloc+0x70>
 952:	89ca                	mv	s3,s2
 954:	0009071b          	sext.w	a4,s2
 958:	6685                	lui	a3,0x1
 95a:	00d77363          	bgeu	a4,a3,960 <malloc+0x40>
 95e:	6985                	lui	s3,0x1
 960:	00098a1b          	sext.w	s4,s3
 964:	1982                	slli	s3,s3,0x20
 966:	0209d993          	srli	s3,s3,0x20
 96a:	0992                	slli	s3,s3,0x4
 96c:	00000497          	auipc	s1,0x0
 970:	22c48493          	addi	s1,s1,556 # b98 <freep>
 974:	5afd                	li	s5,-1
 976:	a0bd                	j	9e4 <malloc+0xc4>
 978:	00000797          	auipc	a5,0x0
 97c:	22878793          	addi	a5,a5,552 # ba0 <base>
 980:	00000717          	auipc	a4,0x0
 984:	20f73c23          	sd	a5,536(a4) # b98 <freep>
 988:	e39c                	sd	a5,0(a5)
 98a:	0007a423          	sw	zero,8(a5)
 98e:	b7d1                	j	952 <malloc+0x32>
 990:	02e40a63          	beq	s0,a4,9c4 <malloc+0xa4>
 994:	4127073b          	subw	a4,a4,s2
 998:	c798                	sw	a4,8(a5)
 99a:	1702                	slli	a4,a4,0x20
 99c:	9301                	srli	a4,a4,0x20
 99e:	0712                	slli	a4,a4,0x4
 9a0:	97ba                	add	a5,a5,a4
 9a2:	0127a423          	sw	s2,8(a5)
 9a6:	00000717          	auipc	a4,0x0
 9aa:	1ea73923          	sd	a0,498(a4) # b98 <freep>
 9ae:	01078513          	addi	a0,a5,16
 9b2:	70e2                	ld	ra,56(sp)
 9b4:	7442                	ld	s0,48(sp)
 9b6:	74a2                	ld	s1,40(sp)
 9b8:	7902                	ld	s2,32(sp)
 9ba:	69e2                	ld	s3,24(sp)
 9bc:	6a42                	ld	s4,16(sp)
 9be:	6aa2                	ld	s5,8(sp)
 9c0:	6121                	addi	sp,sp,64
 9c2:	8082                	ret
 9c4:	6398                	ld	a4,0(a5)
 9c6:	e118                	sd	a4,0(a0)
 9c8:	bff9                	j	9a6 <malloc+0x86>
 9ca:	01452423          	sw	s4,8(a0)
 9ce:	0541                	addi	a0,a0,16
 9d0:	00000097          	auipc	ra,0x0
 9d4:	ed2080e7          	jalr	-302(ra) # 8a2 <free>
 9d8:	6088                	ld	a0,0(s1)
 9da:	dd61                	beqz	a0,9b2 <malloc+0x92>
 9dc:	611c                	ld	a5,0(a0)
 9de:	4798                	lw	a4,8(a5)
 9e0:	fa8778e3          	bgeu	a4,s0,990 <malloc+0x70>
 9e4:	6098                	ld	a4,0(s1)
 9e6:	853e                	mv	a0,a5
 9e8:	fef71ae3          	bne	a4,a5,9dc <malloc+0xbc>
 9ec:	854e                	mv	a0,s3
 9ee:	00000097          	auipc	ra,0x0
 9f2:	8d8080e7          	jalr	-1832(ra) # 2c6 <sbrk>
 9f6:	fd551ae3          	bne	a0,s5,9ca <malloc+0xaa>
 9fa:	4501                	li	a0,0
 9fc:	bf5d                	j	9b2 <malloc+0x92>
