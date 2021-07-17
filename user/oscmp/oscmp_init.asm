
_oscmp_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_success>:
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	842a                	mv	s0,a0
   a:	00001517          	auipc	a0,0x1
   e:	ab650513          	addi	a0,a0,-1354 # ac0 <malloc+0x11c>
  12:	00001097          	auipc	ra,0x1
  16:	8ec080e7          	jalr	-1812(ra) # 8fe <printf>
  1a:	600c                	ld	a1,0(s0)
  1c:	cd99                	beqz	a1,3a <print_success+0x3a>
  1e:	0421                	addi	s0,s0,8
  20:	00001497          	auipc	s1,0x1
  24:	ab848493          	addi	s1,s1,-1352 # ad8 <malloc+0x134>
  28:	8526                	mv	a0,s1
  2a:	00001097          	auipc	ra,0x1
  2e:	8d4080e7          	jalr	-1836(ra) # 8fe <printf>
  32:	0421                	addi	s0,s0,8
  34:	ff843583          	ld	a1,-8(s0)
  38:	f9e5                	bnez	a1,28 <print_success+0x28>
  3a:	00001517          	auipc	a0,0x1
  3e:	aa650513          	addi	a0,a0,-1370 # ae0 <malloc+0x13c>
  42:	00001097          	auipc	ra,0x1
  46:	8bc080e7          	jalr	-1860(ra) # 8fe <printf>
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
  64:	2d2080e7          	jalr	722(ra) # 332 <fork>
  68:	ed09                	bnez	a0,82 <test+0x2e>
  6a:	4601                	li	a2,0
  6c:	85a2                	mv	a1,s0
  6e:	8526                	mv	a0,s1
  70:	00000097          	auipc	ra,0x0
  74:	3ea080e7          	jalr	1002(ra) # 45a <execve>
  78:	70a2                	ld	ra,40(sp)
  7a:	7402                	ld	s0,32(sp)
  7c:	64e2                	ld	s1,24(sp)
  7e:	6145                	addi	sp,sp,48
  80:	8082                	ret
  82:	0068                	addi	a0,sp,12
  84:	00000097          	auipc	ra,0x0
  88:	2b6080e7          	jalr	694(ra) # 33a <wait>
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
  a8:	a4c50513          	addi	a0,a0,-1460 # af0 <malloc+0x14c>
  ac:	00000097          	auipc	ra,0x0
  b0:	296080e7          	jalr	662(ra) # 342 <open>
  b4:	4501                	li	a0,0
  b6:	00000097          	auipc	ra,0x0
  ba:	2a4080e7          	jalr	676(ra) # 35a <dup>
  be:	4501                	li	a0,0
  c0:	00000097          	auipc	ra,0x0
  c4:	29a080e7          	jalr	666(ra) # 35a <dup>
  c8:	00001797          	auipc	a5,0x1
  cc:	a3078793          	addi	a5,a5,-1488 # af8 <malloc+0x154>
  d0:	febe                	sd	a5,376(sp)
  d2:	00001797          	auipc	a5,0x1
  d6:	a2e78793          	addi	a5,a5,-1490 # b00 <malloc+0x15c>
  da:	e33e                	sd	a5,384(sp)
  dc:	e702                	sd	zero,392(sp)
  de:	00001797          	auipc	a5,0x1
  e2:	ada78793          	addi	a5,a5,-1318 # bb8 <malloc+0x214>
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
 10a:	a1a70713          	addi	a4,a4,-1510 # b20 <malloc+0x17c>
 10e:	f23a                	sd	a4,288(sp)
 110:	00001717          	auipc	a4,0x1
 114:	a2070713          	addi	a4,a4,-1504 # b30 <malloc+0x18c>
 118:	f63a                	sd	a4,296(sp)
 11a:	fa02                	sd	zero,304(sp)
 11c:	00001697          	auipc	a3,0x1
 120:	a2468693          	addi	a3,a3,-1500 # b40 <malloc+0x19c>
 124:	ea36                	sd	a3,272(sp)
 126:	ee02                	sd	zero,280(sp)
 128:	00001697          	auipc	a3,0x1
 12c:	a2068693          	addi	a3,a3,-1504 # b48 <malloc+0x1a4>
 130:	e236                	sd	a3,256(sp)
 132:	e602                	sd	zero,264(sp)
 134:	00001697          	auipc	a3,0x1
 138:	a1c68693          	addi	a3,a3,-1508 # b50 <malloc+0x1ac>
 13c:	f9b6                	sd	a3,240(sp)
 13e:	fd82                	sd	zero,248(sp)
 140:	00001697          	auipc	a3,0x1
 144:	a1868693          	addi	a3,a3,-1512 # b58 <malloc+0x1b4>
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
 166:	9fe78793          	addi	a5,a5,-1538 # b60 <malloc+0x1bc>
 16a:	f13e                	sd	a5,160(sp)
 16c:	f502                	sd	zero,168(sp)
 16e:	00001797          	auipc	a5,0x1
 172:	9fa78793          	addi	a5,a5,-1542 # b68 <malloc+0x1c4>
 176:	e93e                	sd	a5,144(sp)
 178:	ed02                	sd	zero,152(sp)
 17a:	00001797          	auipc	a5,0x1
 17e:	9f678793          	addi	a5,a5,-1546 # b70 <malloc+0x1cc>
 182:	fcbe                	sd	a5,120(sp)
 184:	00001797          	auipc	a5,0x1
 188:	9f478793          	addi	a5,a5,-1548 # b78 <malloc+0x1d4>
 18c:	e13e                	sd	a5,128(sp)
 18e:	e502                	sd	zero,136(sp)
 190:	00001717          	auipc	a4,0x1
 194:	9f070713          	addi	a4,a4,-1552 # b80 <malloc+0x1dc>
 198:	f4ba                	sd	a4,104(sp)
 19a:	f882                	sd	zero,112(sp)
 19c:	00001717          	auipc	a4,0x1
 1a0:	9ec70713          	addi	a4,a4,-1556 # b88 <malloc+0x1e4>
 1a4:	ecba                	sd	a4,88(sp)
 1a6:	f082                	sd	zero,96(sp)
 1a8:	00001717          	auipc	a4,0x1
 1ac:	9e870713          	addi	a4,a4,-1560 # b90 <malloc+0x1ec>
 1b0:	e4ba                	sd	a4,72(sp)
 1b2:	e882                	sd	zero,80(sp)
 1b4:	00001717          	auipc	a4,0x1
 1b8:	9e470713          	addi	a4,a4,-1564 # b98 <malloc+0x1f4>
 1bc:	f83a                	sd	a4,48(sp)
 1be:	00001717          	auipc	a4,0x1
 1c2:	9e270713          	addi	a4,a4,-1566 # ba0 <malloc+0x1fc>
 1c6:	fc3a                	sd	a4,56(sp)
 1c8:	e082                	sd	zero,64(sp)
 1ca:	f03e                	sd	a5,32(sp)
 1cc:	f402                	sd	zero,40(sp)
 1ce:	00001797          	auipc	a5,0x1
 1d2:	9da78793          	addi	a5,a5,-1574 # ba8 <malloc+0x204>
 1d6:	e43e                	sd	a5,8(sp)
 1d8:	00001797          	auipc	a5,0x1
 1dc:	8d878793          	addi	a5,a5,-1832 # ab0 <malloc+0x10c>
 1e0:	e83e                	sd	a5,16(sp)
 1e2:	ec02                	sd	zero,24(sp)
 1e4:	1aac                	addi	a1,sp,376
 1e6:	00001517          	auipc	a0,0x1
 1ea:	9ca50513          	addi	a0,a0,-1590 # bb0 <malloc+0x20c>
 1ee:	00000097          	auipc	ra,0x0
 1f2:	e66080e7          	jalr	-410(ra) # 54 <test>
 1f6:	0aac                	addi	a1,sp,344
 1f8:	00001517          	auipc	a0,0x1
 1fc:	9b850513          	addi	a0,a0,-1608 # bb0 <malloc+0x20c>
 200:	00000097          	auipc	ra,0x0
 204:	e54080e7          	jalr	-428(ra) # 54 <test>
 208:	1a2c                	addi	a1,sp,312
 20a:	00001517          	auipc	a0,0x1
 20e:	9a650513          	addi	a0,a0,-1626 # bb0 <malloc+0x20c>
 212:	00000097          	auipc	ra,0x0
 216:	e42080e7          	jalr	-446(ra) # 54 <test>
 21a:	120c                	addi	a1,sp,288
 21c:	00001517          	auipc	a0,0x1
 220:	99450513          	addi	a0,a0,-1644 # bb0 <malloc+0x20c>
 224:	00000097          	auipc	ra,0x0
 228:	e30080e7          	jalr	-464(ra) # 54 <test>
 22c:	0a0c                	addi	a1,sp,272
 22e:	00001517          	auipc	a0,0x1
 232:	98250513          	addi	a0,a0,-1662 # bb0 <malloc+0x20c>
 236:	00000097          	auipc	ra,0x0
 23a:	e1e080e7          	jalr	-482(ra) # 54 <test>
 23e:	020c                	addi	a1,sp,256
 240:	00001517          	auipc	a0,0x1
 244:	97050513          	addi	a0,a0,-1680 # bb0 <malloc+0x20c>
 248:	00000097          	auipc	ra,0x0
 24c:	e0c080e7          	jalr	-500(ra) # 54 <test>
 250:	198c                	addi	a1,sp,240
 252:	00001517          	auipc	a0,0x1
 256:	95e50513          	addi	a0,a0,-1698 # bb0 <malloc+0x20c>
 25a:	00000097          	auipc	ra,0x0
 25e:	dfa080e7          	jalr	-518(ra) # 54 <test>
 262:	09ac                	addi	a1,sp,216
 264:	00001517          	auipc	a0,0x1
 268:	94c50513          	addi	a0,a0,-1716 # bb0 <malloc+0x20c>
 26c:	00000097          	auipc	ra,0x0
 270:	de8080e7          	jalr	-536(ra) # 54 <test>
 274:	190c                	addi	a1,sp,176
 276:	00001517          	auipc	a0,0x1
 27a:	93a50513          	addi	a0,a0,-1734 # bb0 <malloc+0x20c>
 27e:	00000097          	auipc	ra,0x0
 282:	dd6080e7          	jalr	-554(ra) # 54 <test>
 286:	110c                	addi	a1,sp,160
 288:	00001517          	auipc	a0,0x1
 28c:	92850513          	addi	a0,a0,-1752 # bb0 <malloc+0x20c>
 290:	00000097          	auipc	ra,0x0
 294:	dc4080e7          	jalr	-572(ra) # 54 <test>
 298:	090c                	addi	a1,sp,144
 29a:	00001517          	auipc	a0,0x1
 29e:	91650513          	addi	a0,a0,-1770 # bb0 <malloc+0x20c>
 2a2:	00000097          	auipc	ra,0x0
 2a6:	db2080e7          	jalr	-590(ra) # 54 <test>
 2aa:	18ac                	addi	a1,sp,120
 2ac:	00001517          	auipc	a0,0x1
 2b0:	90450513          	addi	a0,a0,-1788 # bb0 <malloc+0x20c>
 2b4:	00000097          	auipc	ra,0x0
 2b8:	da0080e7          	jalr	-608(ra) # 54 <test>
 2bc:	10ac                	addi	a1,sp,104
 2be:	00001517          	auipc	a0,0x1
 2c2:	8f250513          	addi	a0,a0,-1806 # bb0 <malloc+0x20c>
 2c6:	00000097          	auipc	ra,0x0
 2ca:	d8e080e7          	jalr	-626(ra) # 54 <test>
 2ce:	08ac                	addi	a1,sp,88
 2d0:	00001517          	auipc	a0,0x1
 2d4:	8e050513          	addi	a0,a0,-1824 # bb0 <malloc+0x20c>
 2d8:	00000097          	auipc	ra,0x0
 2dc:	d7c080e7          	jalr	-644(ra) # 54 <test>
 2e0:	00ac                	addi	a1,sp,72
 2e2:	00001517          	auipc	a0,0x1
 2e6:	8ce50513          	addi	a0,a0,-1842 # bb0 <malloc+0x20c>
 2ea:	00000097          	auipc	ra,0x0
 2ee:	d6a080e7          	jalr	-662(ra) # 54 <test>
 2f2:	180c                	addi	a1,sp,48
 2f4:	00001517          	auipc	a0,0x1
 2f8:	8bc50513          	addi	a0,a0,-1860 # bb0 <malloc+0x20c>
 2fc:	00000097          	auipc	ra,0x0
 300:	d58080e7          	jalr	-680(ra) # 54 <test>
 304:	100c                	addi	a1,sp,32
 306:	00001517          	auipc	a0,0x1
 30a:	8aa50513          	addi	a0,a0,-1878 # bb0 <malloc+0x20c>
 30e:	00000097          	auipc	ra,0x0
 312:	d46080e7          	jalr	-698(ra) # 54 <test>
 316:	002c                	addi	a1,sp,8
 318:	00001517          	auipc	a0,0x1
 31c:	89850513          	addi	a0,a0,-1896 # bb0 <malloc+0x20c>
 320:	00000097          	auipc	ra,0x0
 324:	d34080e7          	jalr	-716(ra) # 54 <test>
 328:	00000097          	auipc	ra,0x0
 32c:	150080e7          	jalr	336(ra) # 478 <kernel_panic>
 330:	a001                	j	330 <main+0x292>

0000000000000332 <fork>:
 332:	4885                	li	a7,1
 334:	00000073          	ecall
 338:	8082                	ret

000000000000033a <wait>:
 33a:	488d                	li	a7,3
 33c:	00000073          	ecall
 340:	8082                	ret

0000000000000342 <open>:
 342:	4889                	li	a7,2
 344:	00000073          	ecall
 348:	8082                	ret

000000000000034a <sbrk>:
 34a:	4891                	li	a7,4
 34c:	00000073          	ecall
 350:	8082                	ret

0000000000000352 <getcwd>:
 352:	48c5                	li	a7,17
 354:	00000073          	ecall
 358:	8082                	ret

000000000000035a <dup>:
 35a:	48dd                	li	a7,23
 35c:	00000073          	ecall
 360:	8082                	ret

0000000000000362 <dup3>:
 362:	48e1                	li	a7,24
 364:	00000073          	ecall
 368:	8082                	ret

000000000000036a <mkdirat>:
 36a:	02200893          	li	a7,34
 36e:	00000073          	ecall
 372:	8082                	ret

0000000000000374 <unlinkat>:
 374:	02300893          	li	a7,35
 378:	00000073          	ecall
 37c:	8082                	ret

000000000000037e <linkat>:
 37e:	02500893          	li	a7,37
 382:	00000073          	ecall
 386:	8082                	ret

0000000000000388 <umount2>:
 388:	02700893          	li	a7,39
 38c:	00000073          	ecall
 390:	8082                	ret

0000000000000392 <mount>:
 392:	02800893          	li	a7,40
 396:	00000073          	ecall
 39a:	8082                	ret

000000000000039c <chdir>:
 39c:	03100893          	li	a7,49
 3a0:	00000073          	ecall
 3a4:	8082                	ret

00000000000003a6 <openat>:
 3a6:	03800893          	li	a7,56
 3aa:	00000073          	ecall
 3ae:	8082                	ret

00000000000003b0 <close>:
 3b0:	03900893          	li	a7,57
 3b4:	00000073          	ecall
 3b8:	8082                	ret

00000000000003ba <pipe2>:
 3ba:	03b00893          	li	a7,59
 3be:	00000073          	ecall
 3c2:	8082                	ret

00000000000003c4 <getdents64>:
 3c4:	03d00893          	li	a7,61
 3c8:	00000073          	ecall
 3cc:	8082                	ret

00000000000003ce <read>:
 3ce:	03f00893          	li	a7,63
 3d2:	00000073          	ecall
 3d6:	8082                	ret

00000000000003d8 <write>:
 3d8:	04000893          	li	a7,64
 3dc:	00000073          	ecall
 3e0:	8082                	ret

00000000000003e2 <fstat>:
 3e2:	05000893          	li	a7,80
 3e6:	00000073          	ecall
 3ea:	8082                	ret

00000000000003ec <exit>:
 3ec:	05d00893          	li	a7,93
 3f0:	00000073          	ecall
 3f4:	8082                	ret

00000000000003f6 <nanosleep>:
 3f6:	06500893          	li	a7,101
 3fa:	00000073          	ecall
 3fe:	8082                	ret

0000000000000400 <sched_yield>:
 400:	07c00893          	li	a7,124
 404:	00000073          	ecall
 408:	8082                	ret

000000000000040a <times>:
 40a:	09900893          	li	a7,153
 40e:	00000073          	ecall
 412:	8082                	ret

0000000000000414 <uname>:
 414:	0a000893          	li	a7,160
 418:	00000073          	ecall
 41c:	8082                	ret

000000000000041e <gettimeofday>:
 41e:	0a900893          	li	a7,169
 422:	00000073          	ecall
 426:	8082                	ret

0000000000000428 <brk>:
 428:	0d600893          	li	a7,214
 42c:	00000073          	ecall
 430:	8082                	ret

0000000000000432 <munmap>:
 432:	0d700893          	li	a7,215
 436:	00000073          	ecall
 43a:	8082                	ret

000000000000043c <getpid>:
 43c:	0ac00893          	li	a7,172
 440:	00000073          	ecall
 444:	8082                	ret

0000000000000446 <getppid>:
 446:	0ad00893          	li	a7,173
 44a:	00000073          	ecall
 44e:	8082                	ret

0000000000000450 <clone>:
 450:	0dc00893          	li	a7,220
 454:	00000073          	ecall
 458:	8082                	ret

000000000000045a <execve>:
 45a:	0dd00893          	li	a7,221
 45e:	00000073          	ecall
 462:	8082                	ret

0000000000000464 <mmap>:
 464:	0de00893          	li	a7,222
 468:	00000073          	ecall
 46c:	8082                	ret

000000000000046e <wait4>:
 46e:	10400893          	li	a7,260
 472:	00000073          	ecall
 476:	8082                	ret

0000000000000478 <kernel_panic>:
 478:	18f00893          	li	a7,399
 47c:	00000073          	ecall
 480:	8082                	ret

0000000000000482 <strcpy>:
 482:	87aa                	mv	a5,a0
 484:	0585                	addi	a1,a1,1
 486:	0785                	addi	a5,a5,1
 488:	fff5c703          	lbu	a4,-1(a1)
 48c:	fee78fa3          	sb	a4,-1(a5)
 490:	fb75                	bnez	a4,484 <strcpy+0x2>
 492:	8082                	ret

0000000000000494 <strcmp>:
 494:	00054783          	lbu	a5,0(a0)
 498:	cb91                	beqz	a5,4ac <strcmp+0x18>
 49a:	0005c703          	lbu	a4,0(a1)
 49e:	00f71763          	bne	a4,a5,4ac <strcmp+0x18>
 4a2:	0505                	addi	a0,a0,1
 4a4:	0585                	addi	a1,a1,1
 4a6:	00054783          	lbu	a5,0(a0)
 4aa:	fbe5                	bnez	a5,49a <strcmp+0x6>
 4ac:	0005c503          	lbu	a0,0(a1)
 4b0:	40a7853b          	subw	a0,a5,a0
 4b4:	8082                	ret

00000000000004b6 <strlen>:
 4b6:	00054783          	lbu	a5,0(a0)
 4ba:	cf81                	beqz	a5,4d2 <strlen+0x1c>
 4bc:	0505                	addi	a0,a0,1
 4be:	87aa                	mv	a5,a0
 4c0:	4685                	li	a3,1
 4c2:	9e89                	subw	a3,a3,a0
 4c4:	00f6853b          	addw	a0,a3,a5
 4c8:	0785                	addi	a5,a5,1
 4ca:	fff7c703          	lbu	a4,-1(a5)
 4ce:	fb7d                	bnez	a4,4c4 <strlen+0xe>
 4d0:	8082                	ret
 4d2:	4501                	li	a0,0
 4d4:	8082                	ret

00000000000004d6 <memset>:
 4d6:	ce09                	beqz	a2,4f0 <memset+0x1a>
 4d8:	87aa                	mv	a5,a0
 4da:	fff6071b          	addiw	a4,a2,-1
 4de:	1702                	slli	a4,a4,0x20
 4e0:	9301                	srli	a4,a4,0x20
 4e2:	0705                	addi	a4,a4,1
 4e4:	972a                	add	a4,a4,a0
 4e6:	00b78023          	sb	a1,0(a5)
 4ea:	0785                	addi	a5,a5,1
 4ec:	fee79de3          	bne	a5,a4,4e6 <memset+0x10>
 4f0:	8082                	ret

00000000000004f2 <strchr>:
 4f2:	00054783          	lbu	a5,0(a0)
 4f6:	cb89                	beqz	a5,508 <strchr+0x16>
 4f8:	00f58963          	beq	a1,a5,50a <strchr+0x18>
 4fc:	0505                	addi	a0,a0,1
 4fe:	00054783          	lbu	a5,0(a0)
 502:	fbfd                	bnez	a5,4f8 <strchr+0x6>
 504:	4501                	li	a0,0
 506:	8082                	ret
 508:	4501                	li	a0,0
 50a:	8082                	ret

000000000000050c <gets>:
 50c:	715d                	addi	sp,sp,-80
 50e:	e486                	sd	ra,72(sp)
 510:	e0a2                	sd	s0,64(sp)
 512:	fc26                	sd	s1,56(sp)
 514:	f84a                	sd	s2,48(sp)
 516:	f44e                	sd	s3,40(sp)
 518:	f052                	sd	s4,32(sp)
 51a:	ec56                	sd	s5,24(sp)
 51c:	e85a                	sd	s6,16(sp)
 51e:	8b2a                	mv	s6,a0
 520:	89ae                	mv	s3,a1
 522:	84aa                	mv	s1,a0
 524:	4401                	li	s0,0
 526:	4a29                	li	s4,10
 528:	4ab5                	li	s5,13
 52a:	8922                	mv	s2,s0
 52c:	2405                	addiw	s0,s0,1
 52e:	03345863          	bge	s0,s3,55e <gets+0x52>
 532:	4605                	li	a2,1
 534:	00f10593          	addi	a1,sp,15
 538:	4501                	li	a0,0
 53a:	00000097          	auipc	ra,0x0
 53e:	e94080e7          	jalr	-364(ra) # 3ce <read>
 542:	00a05e63          	blez	a0,55e <gets+0x52>
 546:	00f14783          	lbu	a5,15(sp)
 54a:	00f48023          	sb	a5,0(s1)
 54e:	01478763          	beq	a5,s4,55c <gets+0x50>
 552:	0485                	addi	s1,s1,1
 554:	fd579be3          	bne	a5,s5,52a <gets+0x1e>
 558:	8922                	mv	s2,s0
 55a:	a011                	j	55e <gets+0x52>
 55c:	8922                	mv	s2,s0
 55e:	995a                	add	s2,s2,s6
 560:	00090023          	sb	zero,0(s2)
 564:	855a                	mv	a0,s6
 566:	60a6                	ld	ra,72(sp)
 568:	6406                	ld	s0,64(sp)
 56a:	74e2                	ld	s1,56(sp)
 56c:	7942                	ld	s2,48(sp)
 56e:	79a2                	ld	s3,40(sp)
 570:	7a02                	ld	s4,32(sp)
 572:	6ae2                	ld	s5,24(sp)
 574:	6b42                	ld	s6,16(sp)
 576:	6161                	addi	sp,sp,80
 578:	8082                	ret

000000000000057a <atoi>:
 57a:	86aa                	mv	a3,a0
 57c:	00054603          	lbu	a2,0(a0)
 580:	fd06079b          	addiw	a5,a2,-48
 584:	0ff7f793          	andi	a5,a5,255
 588:	4725                	li	a4,9
 58a:	02f76663          	bltu	a4,a5,5b6 <atoi+0x3c>
 58e:	4501                	li	a0,0
 590:	45a5                	li	a1,9
 592:	0685                	addi	a3,a3,1
 594:	0025179b          	slliw	a5,a0,0x2
 598:	9fa9                	addw	a5,a5,a0
 59a:	0017979b          	slliw	a5,a5,0x1
 59e:	9fb1                	addw	a5,a5,a2
 5a0:	fd07851b          	addiw	a0,a5,-48
 5a4:	0006c603          	lbu	a2,0(a3)
 5a8:	fd06071b          	addiw	a4,a2,-48
 5ac:	0ff77713          	andi	a4,a4,255
 5b0:	fee5f1e3          	bgeu	a1,a4,592 <atoi+0x18>
 5b4:	8082                	ret
 5b6:	4501                	li	a0,0
 5b8:	8082                	ret

00000000000005ba <memmove>:
 5ba:	02b57463          	bgeu	a0,a1,5e2 <memmove+0x28>
 5be:	04c05663          	blez	a2,60a <memmove+0x50>
 5c2:	fff6079b          	addiw	a5,a2,-1
 5c6:	1782                	slli	a5,a5,0x20
 5c8:	9381                	srli	a5,a5,0x20
 5ca:	0785                	addi	a5,a5,1
 5cc:	97aa                	add	a5,a5,a0
 5ce:	872a                	mv	a4,a0
 5d0:	0585                	addi	a1,a1,1
 5d2:	0705                	addi	a4,a4,1
 5d4:	fff5c683          	lbu	a3,-1(a1)
 5d8:	fed70fa3          	sb	a3,-1(a4)
 5dc:	fee79ae3          	bne	a5,a4,5d0 <memmove+0x16>
 5e0:	8082                	ret
 5e2:	00c50733          	add	a4,a0,a2
 5e6:	95b2                	add	a1,a1,a2
 5e8:	02c05163          	blez	a2,60a <memmove+0x50>
 5ec:	fff6079b          	addiw	a5,a2,-1
 5f0:	1782                	slli	a5,a5,0x20
 5f2:	9381                	srli	a5,a5,0x20
 5f4:	fff7c793          	not	a5,a5
 5f8:	97ba                	add	a5,a5,a4
 5fa:	15fd                	addi	a1,a1,-1
 5fc:	177d                	addi	a4,a4,-1
 5fe:	0005c683          	lbu	a3,0(a1)
 602:	00d70023          	sb	a3,0(a4)
 606:	fee79ae3          	bne	a5,a4,5fa <memmove+0x40>
 60a:	8082                	ret

000000000000060c <memcmp>:
 60c:	fff6069b          	addiw	a3,a2,-1
 610:	c605                	beqz	a2,638 <memcmp+0x2c>
 612:	1682                	slli	a3,a3,0x20
 614:	9281                	srli	a3,a3,0x20
 616:	0685                	addi	a3,a3,1
 618:	96aa                	add	a3,a3,a0
 61a:	00054783          	lbu	a5,0(a0)
 61e:	0005c703          	lbu	a4,0(a1)
 622:	00e79863          	bne	a5,a4,632 <memcmp+0x26>
 626:	0505                	addi	a0,a0,1
 628:	0585                	addi	a1,a1,1
 62a:	fed518e3          	bne	a0,a3,61a <memcmp+0xe>
 62e:	4501                	li	a0,0
 630:	8082                	ret
 632:	40e7853b          	subw	a0,a5,a4
 636:	8082                	ret
 638:	4501                	li	a0,0
 63a:	8082                	ret

000000000000063c <memcpy>:
 63c:	1141                	addi	sp,sp,-16
 63e:	e406                	sd	ra,8(sp)
 640:	00000097          	auipc	ra,0x0
 644:	f7a080e7          	jalr	-134(ra) # 5ba <memmove>
 648:	60a2                	ld	ra,8(sp)
 64a:	0141                	addi	sp,sp,16
 64c:	8082                	ret

000000000000064e <putc>:
 64e:	1101                	addi	sp,sp,-32
 650:	ec06                	sd	ra,24(sp)
 652:	00b107a3          	sb	a1,15(sp)
 656:	4605                	li	a2,1
 658:	00f10593          	addi	a1,sp,15
 65c:	00000097          	auipc	ra,0x0
 660:	d7c080e7          	jalr	-644(ra) # 3d8 <write>
 664:	60e2                	ld	ra,24(sp)
 666:	6105                	addi	sp,sp,32
 668:	8082                	ret

000000000000066a <printint>:
 66a:	7179                	addi	sp,sp,-48
 66c:	f406                	sd	ra,40(sp)
 66e:	f022                	sd	s0,32(sp)
 670:	ec26                	sd	s1,24(sp)
 672:	e84a                	sd	s2,16(sp)
 674:	84aa                	mv	s1,a0
 676:	c299                	beqz	a3,67c <printint+0x12>
 678:	0805c363          	bltz	a1,6fe <printint+0x94>
 67c:	2581                	sext.w	a1,a1
 67e:	4881                	li	a7,0
 680:	868a                	mv	a3,sp
 682:	4701                	li	a4,0
 684:	2601                	sext.w	a2,a2
 686:	00000517          	auipc	a0,0x0
 68a:	5a250513          	addi	a0,a0,1442 # c28 <digits>
 68e:	883a                	mv	a6,a4
 690:	2705                	addiw	a4,a4,1
 692:	02c5f7bb          	remuw	a5,a1,a2
 696:	1782                	slli	a5,a5,0x20
 698:	9381                	srli	a5,a5,0x20
 69a:	97aa                	add	a5,a5,a0
 69c:	0007c783          	lbu	a5,0(a5)
 6a0:	00f68023          	sb	a5,0(a3)
 6a4:	0005879b          	sext.w	a5,a1
 6a8:	02c5d5bb          	divuw	a1,a1,a2
 6ac:	0685                	addi	a3,a3,1
 6ae:	fec7f0e3          	bgeu	a5,a2,68e <printint+0x24>
 6b2:	00088a63          	beqz	a7,6c6 <printint+0x5c>
 6b6:	081c                	addi	a5,sp,16
 6b8:	973e                	add	a4,a4,a5
 6ba:	02d00793          	li	a5,45
 6be:	fef70823          	sb	a5,-16(a4)
 6c2:	0028071b          	addiw	a4,a6,2
 6c6:	02e05663          	blez	a4,6f2 <printint+0x88>
 6ca:	00e10433          	add	s0,sp,a4
 6ce:	fff10913          	addi	s2,sp,-1
 6d2:	993a                	add	s2,s2,a4
 6d4:	377d                	addiw	a4,a4,-1
 6d6:	1702                	slli	a4,a4,0x20
 6d8:	9301                	srli	a4,a4,0x20
 6da:	40e90933          	sub	s2,s2,a4
 6de:	fff44583          	lbu	a1,-1(s0)
 6e2:	8526                	mv	a0,s1
 6e4:	00000097          	auipc	ra,0x0
 6e8:	f6a080e7          	jalr	-150(ra) # 64e <putc>
 6ec:	147d                	addi	s0,s0,-1
 6ee:	ff2418e3          	bne	s0,s2,6de <printint+0x74>
 6f2:	70a2                	ld	ra,40(sp)
 6f4:	7402                	ld	s0,32(sp)
 6f6:	64e2                	ld	s1,24(sp)
 6f8:	6942                	ld	s2,16(sp)
 6fa:	6145                	addi	sp,sp,48
 6fc:	8082                	ret
 6fe:	40b005bb          	negw	a1,a1
 702:	4885                	li	a7,1
 704:	bfb5                	j	680 <printint+0x16>

0000000000000706 <vprintf>:
 706:	7119                	addi	sp,sp,-128
 708:	fc86                	sd	ra,120(sp)
 70a:	f8a2                	sd	s0,112(sp)
 70c:	f4a6                	sd	s1,104(sp)
 70e:	f0ca                	sd	s2,96(sp)
 710:	ecce                	sd	s3,88(sp)
 712:	e8d2                	sd	s4,80(sp)
 714:	e4d6                	sd	s5,72(sp)
 716:	e0da                	sd	s6,64(sp)
 718:	fc5e                	sd	s7,56(sp)
 71a:	f862                	sd	s8,48(sp)
 71c:	f466                	sd	s9,40(sp)
 71e:	f06a                	sd	s10,32(sp)
 720:	ec6e                	sd	s11,24(sp)
 722:	0005c483          	lbu	s1,0(a1)
 726:	18048c63          	beqz	s1,8be <vprintf+0x1b8>
 72a:	8a2a                	mv	s4,a0
 72c:	8ab2                	mv	s5,a2
 72e:	00158413          	addi	s0,a1,1
 732:	4901                	li	s2,0
 734:	02500993          	li	s3,37
 738:	06400b93          	li	s7,100
 73c:	06c00c13          	li	s8,108
 740:	07800c93          	li	s9,120
 744:	07000d13          	li	s10,112
 748:	07300d93          	li	s11,115
 74c:	00000b17          	auipc	s6,0x0
 750:	4dcb0b13          	addi	s6,s6,1244 # c28 <digits>
 754:	a839                	j	772 <vprintf+0x6c>
 756:	85a6                	mv	a1,s1
 758:	8552                	mv	a0,s4
 75a:	00000097          	auipc	ra,0x0
 75e:	ef4080e7          	jalr	-268(ra) # 64e <putc>
 762:	a019                	j	768 <vprintf+0x62>
 764:	01390f63          	beq	s2,s3,782 <vprintf+0x7c>
 768:	0405                	addi	s0,s0,1
 76a:	fff44483          	lbu	s1,-1(s0)
 76e:	14048863          	beqz	s1,8be <vprintf+0x1b8>
 772:	0004879b          	sext.w	a5,s1
 776:	fe0917e3          	bnez	s2,764 <vprintf+0x5e>
 77a:	fd379ee3          	bne	a5,s3,756 <vprintf+0x50>
 77e:	893e                	mv	s2,a5
 780:	b7e5                	j	768 <vprintf+0x62>
 782:	03778e63          	beq	a5,s7,7be <vprintf+0xb8>
 786:	05878a63          	beq	a5,s8,7da <vprintf+0xd4>
 78a:	07978663          	beq	a5,s9,7f6 <vprintf+0xf0>
 78e:	09a78263          	beq	a5,s10,812 <vprintf+0x10c>
 792:	0db78363          	beq	a5,s11,858 <vprintf+0x152>
 796:	06300713          	li	a4,99
 79a:	0ee78b63          	beq	a5,a4,890 <vprintf+0x18a>
 79e:	11378563          	beq	a5,s3,8a8 <vprintf+0x1a2>
 7a2:	85ce                	mv	a1,s3
 7a4:	8552                	mv	a0,s4
 7a6:	00000097          	auipc	ra,0x0
 7aa:	ea8080e7          	jalr	-344(ra) # 64e <putc>
 7ae:	85a6                	mv	a1,s1
 7b0:	8552                	mv	a0,s4
 7b2:	00000097          	auipc	ra,0x0
 7b6:	e9c080e7          	jalr	-356(ra) # 64e <putc>
 7ba:	4901                	li	s2,0
 7bc:	b775                	j	768 <vprintf+0x62>
 7be:	008a8493          	addi	s1,s5,8
 7c2:	4685                	li	a3,1
 7c4:	4629                	li	a2,10
 7c6:	000aa583          	lw	a1,0(s5)
 7ca:	8552                	mv	a0,s4
 7cc:	00000097          	auipc	ra,0x0
 7d0:	e9e080e7          	jalr	-354(ra) # 66a <printint>
 7d4:	8aa6                	mv	s5,s1
 7d6:	4901                	li	s2,0
 7d8:	bf41                	j	768 <vprintf+0x62>
 7da:	008a8493          	addi	s1,s5,8
 7de:	4681                	li	a3,0
 7e0:	4629                	li	a2,10
 7e2:	000aa583          	lw	a1,0(s5)
 7e6:	8552                	mv	a0,s4
 7e8:	00000097          	auipc	ra,0x0
 7ec:	e82080e7          	jalr	-382(ra) # 66a <printint>
 7f0:	8aa6                	mv	s5,s1
 7f2:	4901                	li	s2,0
 7f4:	bf95                	j	768 <vprintf+0x62>
 7f6:	008a8493          	addi	s1,s5,8
 7fa:	4681                	li	a3,0
 7fc:	4641                	li	a2,16
 7fe:	000aa583          	lw	a1,0(s5)
 802:	8552                	mv	a0,s4
 804:	00000097          	auipc	ra,0x0
 808:	e66080e7          	jalr	-410(ra) # 66a <printint>
 80c:	8aa6                	mv	s5,s1
 80e:	4901                	li	s2,0
 810:	bfa1                	j	768 <vprintf+0x62>
 812:	008a8793          	addi	a5,s5,8
 816:	e43e                	sd	a5,8(sp)
 818:	000ab903          	ld	s2,0(s5)
 81c:	03000593          	li	a1,48
 820:	8552                	mv	a0,s4
 822:	00000097          	auipc	ra,0x0
 826:	e2c080e7          	jalr	-468(ra) # 64e <putc>
 82a:	85e6                	mv	a1,s9
 82c:	8552                	mv	a0,s4
 82e:	00000097          	auipc	ra,0x0
 832:	e20080e7          	jalr	-480(ra) # 64e <putc>
 836:	44c1                	li	s1,16
 838:	03c95793          	srli	a5,s2,0x3c
 83c:	97da                	add	a5,a5,s6
 83e:	0007c583          	lbu	a1,0(a5)
 842:	8552                	mv	a0,s4
 844:	00000097          	auipc	ra,0x0
 848:	e0a080e7          	jalr	-502(ra) # 64e <putc>
 84c:	0912                	slli	s2,s2,0x4
 84e:	34fd                	addiw	s1,s1,-1
 850:	f4e5                	bnez	s1,838 <vprintf+0x132>
 852:	6aa2                	ld	s5,8(sp)
 854:	4901                	li	s2,0
 856:	bf09                	j	768 <vprintf+0x62>
 858:	008a8493          	addi	s1,s5,8
 85c:	000ab903          	ld	s2,0(s5)
 860:	02090163          	beqz	s2,882 <vprintf+0x17c>
 864:	00094583          	lbu	a1,0(s2)
 868:	c9a1                	beqz	a1,8b8 <vprintf+0x1b2>
 86a:	8552                	mv	a0,s4
 86c:	00000097          	auipc	ra,0x0
 870:	de2080e7          	jalr	-542(ra) # 64e <putc>
 874:	0905                	addi	s2,s2,1
 876:	00094583          	lbu	a1,0(s2)
 87a:	f9e5                	bnez	a1,86a <vprintf+0x164>
 87c:	8aa6                	mv	s5,s1
 87e:	4901                	li	s2,0
 880:	b5e5                	j	768 <vprintf+0x62>
 882:	00000917          	auipc	s2,0x0
 886:	39e90913          	addi	s2,s2,926 # c20 <malloc+0x27c>
 88a:	02800593          	li	a1,40
 88e:	bff1                	j	86a <vprintf+0x164>
 890:	008a8493          	addi	s1,s5,8
 894:	000ac583          	lbu	a1,0(s5)
 898:	8552                	mv	a0,s4
 89a:	00000097          	auipc	ra,0x0
 89e:	db4080e7          	jalr	-588(ra) # 64e <putc>
 8a2:	8aa6                	mv	s5,s1
 8a4:	4901                	li	s2,0
 8a6:	b5c9                	j	768 <vprintf+0x62>
 8a8:	85ce                	mv	a1,s3
 8aa:	8552                	mv	a0,s4
 8ac:	00000097          	auipc	ra,0x0
 8b0:	da2080e7          	jalr	-606(ra) # 64e <putc>
 8b4:	4901                	li	s2,0
 8b6:	bd4d                	j	768 <vprintf+0x62>
 8b8:	8aa6                	mv	s5,s1
 8ba:	4901                	li	s2,0
 8bc:	b575                	j	768 <vprintf+0x62>
 8be:	70e6                	ld	ra,120(sp)
 8c0:	7446                	ld	s0,112(sp)
 8c2:	74a6                	ld	s1,104(sp)
 8c4:	7906                	ld	s2,96(sp)
 8c6:	69e6                	ld	s3,88(sp)
 8c8:	6a46                	ld	s4,80(sp)
 8ca:	6aa6                	ld	s5,72(sp)
 8cc:	6b06                	ld	s6,64(sp)
 8ce:	7be2                	ld	s7,56(sp)
 8d0:	7c42                	ld	s8,48(sp)
 8d2:	7ca2                	ld	s9,40(sp)
 8d4:	7d02                	ld	s10,32(sp)
 8d6:	6de2                	ld	s11,24(sp)
 8d8:	6109                	addi	sp,sp,128
 8da:	8082                	ret

00000000000008dc <fprintf>:
 8dc:	715d                	addi	sp,sp,-80
 8de:	ec06                	sd	ra,24(sp)
 8e0:	f032                	sd	a2,32(sp)
 8e2:	f436                	sd	a3,40(sp)
 8e4:	f83a                	sd	a4,48(sp)
 8e6:	fc3e                	sd	a5,56(sp)
 8e8:	e0c2                	sd	a6,64(sp)
 8ea:	e4c6                	sd	a7,72(sp)
 8ec:	1010                	addi	a2,sp,32
 8ee:	e432                	sd	a2,8(sp)
 8f0:	00000097          	auipc	ra,0x0
 8f4:	e16080e7          	jalr	-490(ra) # 706 <vprintf>
 8f8:	60e2                	ld	ra,24(sp)
 8fa:	6161                	addi	sp,sp,80
 8fc:	8082                	ret

00000000000008fe <printf>:
 8fe:	711d                	addi	sp,sp,-96
 900:	ec06                	sd	ra,24(sp)
 902:	f42e                	sd	a1,40(sp)
 904:	f832                	sd	a2,48(sp)
 906:	fc36                	sd	a3,56(sp)
 908:	e0ba                	sd	a4,64(sp)
 90a:	e4be                	sd	a5,72(sp)
 90c:	e8c2                	sd	a6,80(sp)
 90e:	ecc6                	sd	a7,88(sp)
 910:	1030                	addi	a2,sp,40
 912:	e432                	sd	a2,8(sp)
 914:	85aa                	mv	a1,a0
 916:	4505                	li	a0,1
 918:	00000097          	auipc	ra,0x0
 91c:	dee080e7          	jalr	-530(ra) # 706 <vprintf>
 920:	60e2                	ld	ra,24(sp)
 922:	6125                	addi	sp,sp,96
 924:	8082                	ret

0000000000000926 <free>:
 926:	ff050693          	addi	a3,a0,-16
 92a:	00000797          	auipc	a5,0x0
 92e:	3167b783          	ld	a5,790(a5) # c40 <freep>
 932:	a805                	j	962 <free+0x3c>
 934:	4618                	lw	a4,8(a2)
 936:	9db9                	addw	a1,a1,a4
 938:	feb52c23          	sw	a1,-8(a0)
 93c:	6398                	ld	a4,0(a5)
 93e:	6318                	ld	a4,0(a4)
 940:	fee53823          	sd	a4,-16(a0)
 944:	a091                	j	988 <free+0x62>
 946:	ff852703          	lw	a4,-8(a0)
 94a:	9e39                	addw	a2,a2,a4
 94c:	c790                	sw	a2,8(a5)
 94e:	ff053703          	ld	a4,-16(a0)
 952:	e398                	sd	a4,0(a5)
 954:	a099                	j	99a <free+0x74>
 956:	6398                	ld	a4,0(a5)
 958:	00e7e463          	bltu	a5,a4,960 <free+0x3a>
 95c:	00e6ea63          	bltu	a3,a4,970 <free+0x4a>
 960:	87ba                	mv	a5,a4
 962:	fed7fae3          	bgeu	a5,a3,956 <free+0x30>
 966:	6398                	ld	a4,0(a5)
 968:	00e6e463          	bltu	a3,a4,970 <free+0x4a>
 96c:	fee7eae3          	bltu	a5,a4,960 <free+0x3a>
 970:	ff852583          	lw	a1,-8(a0)
 974:	6390                	ld	a2,0(a5)
 976:	02059713          	slli	a4,a1,0x20
 97a:	9301                	srli	a4,a4,0x20
 97c:	0712                	slli	a4,a4,0x4
 97e:	9736                	add	a4,a4,a3
 980:	fae60ae3          	beq	a2,a4,934 <free+0xe>
 984:	fec53823          	sd	a2,-16(a0)
 988:	4790                	lw	a2,8(a5)
 98a:	02061713          	slli	a4,a2,0x20
 98e:	9301                	srli	a4,a4,0x20
 990:	0712                	slli	a4,a4,0x4
 992:	973e                	add	a4,a4,a5
 994:	fae689e3          	beq	a3,a4,946 <free+0x20>
 998:	e394                	sd	a3,0(a5)
 99a:	00000717          	auipc	a4,0x0
 99e:	2af73323          	sd	a5,678(a4) # c40 <freep>
 9a2:	8082                	ret

00000000000009a4 <malloc>:
 9a4:	7139                	addi	sp,sp,-64
 9a6:	fc06                	sd	ra,56(sp)
 9a8:	f822                	sd	s0,48(sp)
 9aa:	f426                	sd	s1,40(sp)
 9ac:	f04a                	sd	s2,32(sp)
 9ae:	ec4e                	sd	s3,24(sp)
 9b0:	e852                	sd	s4,16(sp)
 9b2:	e456                	sd	s5,8(sp)
 9b4:	02051413          	slli	s0,a0,0x20
 9b8:	9001                	srli	s0,s0,0x20
 9ba:	043d                	addi	s0,s0,15
 9bc:	8011                	srli	s0,s0,0x4
 9be:	0014091b          	addiw	s2,s0,1
 9c2:	0405                	addi	s0,s0,1
 9c4:	00000517          	auipc	a0,0x0
 9c8:	27c53503          	ld	a0,636(a0) # c40 <freep>
 9cc:	c905                	beqz	a0,9fc <malloc+0x58>
 9ce:	611c                	ld	a5,0(a0)
 9d0:	4798                	lw	a4,8(a5)
 9d2:	04877163          	bgeu	a4,s0,a14 <malloc+0x70>
 9d6:	89ca                	mv	s3,s2
 9d8:	0009071b          	sext.w	a4,s2
 9dc:	6685                	lui	a3,0x1
 9de:	00d77363          	bgeu	a4,a3,9e4 <malloc+0x40>
 9e2:	6985                	lui	s3,0x1
 9e4:	00098a1b          	sext.w	s4,s3
 9e8:	1982                	slli	s3,s3,0x20
 9ea:	0209d993          	srli	s3,s3,0x20
 9ee:	0992                	slli	s3,s3,0x4
 9f0:	00000497          	auipc	s1,0x0
 9f4:	25048493          	addi	s1,s1,592 # c40 <freep>
 9f8:	5afd                	li	s5,-1
 9fa:	a0bd                	j	a68 <malloc+0xc4>
 9fc:	00000797          	auipc	a5,0x0
 a00:	24c78793          	addi	a5,a5,588 # c48 <base>
 a04:	00000717          	auipc	a4,0x0
 a08:	22f73e23          	sd	a5,572(a4) # c40 <freep>
 a0c:	e39c                	sd	a5,0(a5)
 a0e:	0007a423          	sw	zero,8(a5)
 a12:	b7d1                	j	9d6 <malloc+0x32>
 a14:	02e40a63          	beq	s0,a4,a48 <malloc+0xa4>
 a18:	4127073b          	subw	a4,a4,s2
 a1c:	c798                	sw	a4,8(a5)
 a1e:	1702                	slli	a4,a4,0x20
 a20:	9301                	srli	a4,a4,0x20
 a22:	0712                	slli	a4,a4,0x4
 a24:	97ba                	add	a5,a5,a4
 a26:	0127a423          	sw	s2,8(a5)
 a2a:	00000717          	auipc	a4,0x0
 a2e:	20a73b23          	sd	a0,534(a4) # c40 <freep>
 a32:	01078513          	addi	a0,a5,16
 a36:	70e2                	ld	ra,56(sp)
 a38:	7442                	ld	s0,48(sp)
 a3a:	74a2                	ld	s1,40(sp)
 a3c:	7902                	ld	s2,32(sp)
 a3e:	69e2                	ld	s3,24(sp)
 a40:	6a42                	ld	s4,16(sp)
 a42:	6aa2                	ld	s5,8(sp)
 a44:	6121                	addi	sp,sp,64
 a46:	8082                	ret
 a48:	6398                	ld	a4,0(a5)
 a4a:	e118                	sd	a4,0(a0)
 a4c:	bff9                	j	a2a <malloc+0x86>
 a4e:	01452423          	sw	s4,8(a0)
 a52:	0541                	addi	a0,a0,16
 a54:	00000097          	auipc	ra,0x0
 a58:	ed2080e7          	jalr	-302(ra) # 926 <free>
 a5c:	6088                	ld	a0,0(s1)
 a5e:	dd61                	beqz	a0,a36 <malloc+0x92>
 a60:	611c                	ld	a5,0(a0)
 a62:	4798                	lw	a4,8(a5)
 a64:	fa8778e3          	bgeu	a4,s0,a14 <malloc+0x70>
 a68:	6098                	ld	a4,0(s1)
 a6a:	853e                	mv	a0,a5
 a6c:	fef71ae3          	bne	a4,a5,a60 <malloc+0xbc>
 a70:	854e                	mv	a0,s3
 a72:	00000097          	auipc	ra,0x0
 a76:	8d8080e7          	jalr	-1832(ra) # 34a <sbrk>
 a7a:	fd551ae3          	bne	a0,s5,a4e <malloc+0xaa>
 a7e:	4501                	li	a0,0
 a80:	bf5d                	j	a36 <malloc+0x92>
