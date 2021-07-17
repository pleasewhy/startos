
_oscmp_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_success>:
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	842a                	mv	s0,a0
   a:	00001517          	auipc	a0,0x1
   e:	96e50513          	addi	a0,a0,-1682 # 978 <malloc+0x116>
  12:	00000097          	auipc	ra,0x0
  16:	7aa080e7          	jalr	1962(ra) # 7bc <printf>
  1a:	600c                	ld	a1,0(s0)
  1c:	cd99                	beqz	a1,3a <print_success+0x3a>
  1e:	0421                	addi	s0,s0,8
  20:	00001497          	auipc	s1,0x1
  24:	97048493          	addi	s1,s1,-1680 # 990 <malloc+0x12e>
  28:	8526                	mv	a0,s1
  2a:	00000097          	auipc	ra,0x0
  2e:	792080e7          	jalr	1938(ra) # 7bc <printf>
  32:	0421                	addi	s0,s0,8
  34:	ff843583          	ld	a1,-8(s0)
  38:	f9e5                	bnez	a1,28 <print_success+0x28>
  3a:	00001517          	auipc	a0,0x1
  3e:	95e50513          	addi	a0,a0,-1698 # 998 <malloc+0x136>
  42:	00000097          	auipc	ra,0x0
  46:	77a080e7          	jalr	1914(ra) # 7bc <printf>
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
  64:	190080e7          	jalr	400(ra) # 1f0 <fork>
  68:	ed09                	bnez	a0,82 <test+0x2e>
  6a:	4601                	li	a2,0
  6c:	85a2                	mv	a1,s0
  6e:	8526                	mv	a0,s1
  70:	00000097          	auipc	ra,0x0
  74:	2a8080e7          	jalr	680(ra) # 318 <execve>
  78:	70a2                	ld	ra,40(sp)
  7a:	7402                	ld	s0,32(sp)
  7c:	64e2                	ld	s1,24(sp)
  7e:	6145                	addi	sp,sp,48
  80:	8082                	ret
  82:	0068                	addi	a0,sp,12
  84:	00000097          	auipc	ra,0x0
  88:	174080e7          	jalr	372(ra) # 1f8 <wait>
  8c:	47b2                	lw	a5,12(sp)
  8e:	fe07c5e3          	bltz	a5,78 <test+0x24>
  92:	8522                	mv	a0,s0
  94:	00000097          	auipc	ra,0x0
  98:	f6c080e7          	jalr	-148(ra) # 0 <print_success>
  9c:	bff1                	j	78 <test+0x24>

000000000000009e <main>:
  9e:	7115                	addi	sp,sp,-224
  a0:	ed86                	sd	ra,216(sp)
  a2:	4589                	li	a1,2
  a4:	00001517          	auipc	a0,0x1
  a8:	90450513          	addi	a0,a0,-1788 # 9a8 <malloc+0x146>
  ac:	00000097          	auipc	ra,0x0
  b0:	154080e7          	jalr	340(ra) # 200 <open>
  b4:	4501                	li	a0,0
  b6:	00000097          	auipc	ra,0x0
  ba:	162080e7          	jalr	354(ra) # 218 <dup>
  be:	4501                	li	a0,0
  c0:	00000097          	auipc	ra,0x0
  c4:	158080e7          	jalr	344(ra) # 218 <dup>
  c8:	00001797          	auipc	a5,0x1
  cc:	8e878793          	addi	a5,a5,-1816 # 9b0 <malloc+0x14e>
  d0:	fd3e                	sd	a5,184(sp)
  d2:	00001797          	auipc	a5,0x1
  d6:	8e678793          	addi	a5,a5,-1818 # 9b8 <malloc+0x156>
  da:	e1be                	sd	a5,192(sp)
  dc:	e582                	sd	zero,200(sp)
  de:	00001797          	auipc	a5,0x1
  e2:	93a78793          	addi	a5,a5,-1734 # a18 <malloc+0x1b6>
  e6:	638c                	ld	a1,0(a5)
  e8:	6790                	ld	a2,8(a5)
  ea:	6b94                	ld	a3,16(a5)
  ec:	6f98                	ld	a4,24(a5)
  ee:	ed2e                	sd	a1,152(sp)
  f0:	f132                	sd	a2,160(sp)
  f2:	f536                	sd	a3,168(sp)
  f4:	f93a                	sd	a4,176(sp)
  f6:	738c                	ld	a1,32(a5)
  f8:	7790                	ld	a2,40(a5)
  fa:	7b94                	ld	a3,48(a5)
  fc:	7f98                	ld	a4,56(a5)
  fe:	fcae                	sd	a1,120(sp)
 100:	e132                	sd	a2,128(sp)
 102:	e536                	sd	a3,136(sp)
 104:	e93a                	sd	a4,144(sp)
 106:	00001717          	auipc	a4,0x1
 10a:	8d270713          	addi	a4,a4,-1838 # 9d8 <malloc+0x176>
 10e:	f0ba                	sd	a4,96(sp)
 110:	00001717          	auipc	a4,0x1
 114:	8d870713          	addi	a4,a4,-1832 # 9e8 <malloc+0x186>
 118:	f4ba                	sd	a4,104(sp)
 11a:	f882                	sd	zero,112(sp)
 11c:	00001697          	auipc	a3,0x1
 120:	8dc68693          	addi	a3,a3,-1828 # 9f8 <malloc+0x196>
 124:	e8b6                	sd	a3,80(sp)
 126:	ec82                	sd	zero,88(sp)
 128:	00001697          	auipc	a3,0x1
 12c:	8d868693          	addi	a3,a3,-1832 # a00 <malloc+0x19e>
 130:	e0b6                	sd	a3,64(sp)
 132:	e482                	sd	zero,72(sp)
 134:	00001697          	auipc	a3,0x1
 138:	8d468693          	addi	a3,a3,-1836 # a08 <malloc+0x1a6>
 13c:	f436                	sd	a3,40(sp)
 13e:	f83a                	sd	a4,48(sp)
 140:	fc02                	sd	zero,56(sp)
 142:	63ac                	ld	a1,64(a5)
 144:	67b0                	ld	a2,72(a5)
 146:	6bb4                	ld	a3,80(a5)
 148:	6fb8                	ld	a4,88(a5)
 14a:	73bc                	ld	a5,96(a5)
 14c:	e02e                	sd	a1,0(sp)
 14e:	e432                	sd	a2,8(sp)
 150:	e836                	sd	a3,16(sp)
 152:	ec3a                	sd	a4,24(sp)
 154:	f03e                	sd	a5,32(sp)
 156:	192c                	addi	a1,sp,184
 158:	00001517          	auipc	a0,0x1
 15c:	8b850513          	addi	a0,a0,-1864 # a10 <malloc+0x1ae>
 160:	00000097          	auipc	ra,0x0
 164:	ef4080e7          	jalr	-268(ra) # 54 <test>
 168:	092c                	addi	a1,sp,152
 16a:	00001517          	auipc	a0,0x1
 16e:	8a650513          	addi	a0,a0,-1882 # a10 <malloc+0x1ae>
 172:	00000097          	auipc	ra,0x0
 176:	ee2080e7          	jalr	-286(ra) # 54 <test>
 17a:	18ac                	addi	a1,sp,120
 17c:	00001517          	auipc	a0,0x1
 180:	89450513          	addi	a0,a0,-1900 # a10 <malloc+0x1ae>
 184:	00000097          	auipc	ra,0x0
 188:	ed0080e7          	jalr	-304(ra) # 54 <test>
 18c:	108c                	addi	a1,sp,96
 18e:	00001517          	auipc	a0,0x1
 192:	88250513          	addi	a0,a0,-1918 # a10 <malloc+0x1ae>
 196:	00000097          	auipc	ra,0x0
 19a:	ebe080e7          	jalr	-322(ra) # 54 <test>
 19e:	088c                	addi	a1,sp,80
 1a0:	00001517          	auipc	a0,0x1
 1a4:	87050513          	addi	a0,a0,-1936 # a10 <malloc+0x1ae>
 1a8:	00000097          	auipc	ra,0x0
 1ac:	eac080e7          	jalr	-340(ra) # 54 <test>
 1b0:	008c                	addi	a1,sp,64
 1b2:	00001517          	auipc	a0,0x1
 1b6:	85e50513          	addi	a0,a0,-1954 # a10 <malloc+0x1ae>
 1ba:	00000097          	auipc	ra,0x0
 1be:	e9a080e7          	jalr	-358(ra) # 54 <test>
 1c2:	102c                	addi	a1,sp,40
 1c4:	00001517          	auipc	a0,0x1
 1c8:	84c50513          	addi	a0,a0,-1972 # a10 <malloc+0x1ae>
 1cc:	00000097          	auipc	ra,0x0
 1d0:	e88080e7          	jalr	-376(ra) # 54 <test>
 1d4:	858a                	mv	a1,sp
 1d6:	00001517          	auipc	a0,0x1
 1da:	83a50513          	addi	a0,a0,-1990 # a10 <malloc+0x1ae>
 1de:	00000097          	auipc	ra,0x0
 1e2:	e76080e7          	jalr	-394(ra) # 54 <test>
 1e6:	00000097          	auipc	ra,0x0
 1ea:	150080e7          	jalr	336(ra) # 336 <kernel_panic>
 1ee:	a001                	j	1ee <main+0x150>

00000000000001f0 <fork>:
 1f0:	4885                	li	a7,1
 1f2:	00000073          	ecall
 1f6:	8082                	ret

00000000000001f8 <wait>:
 1f8:	488d                	li	a7,3
 1fa:	00000073          	ecall
 1fe:	8082                	ret

0000000000000200 <open>:
 200:	4889                	li	a7,2
 202:	00000073          	ecall
 206:	8082                	ret

0000000000000208 <sbrk>:
 208:	4891                	li	a7,4
 20a:	00000073          	ecall
 20e:	8082                	ret

0000000000000210 <getcwd>:
 210:	48c5                	li	a7,17
 212:	00000073          	ecall
 216:	8082                	ret

0000000000000218 <dup>:
 218:	48dd                	li	a7,23
 21a:	00000073          	ecall
 21e:	8082                	ret

0000000000000220 <dup3>:
 220:	48e1                	li	a7,24
 222:	00000073          	ecall
 226:	8082                	ret

0000000000000228 <mkdirat>:
 228:	02200893          	li	a7,34
 22c:	00000073          	ecall
 230:	8082                	ret

0000000000000232 <unlinkat>:
 232:	02300893          	li	a7,35
 236:	00000073          	ecall
 23a:	8082                	ret

000000000000023c <linkat>:
 23c:	02500893          	li	a7,37
 240:	00000073          	ecall
 244:	8082                	ret

0000000000000246 <umount2>:
 246:	02700893          	li	a7,39
 24a:	00000073          	ecall
 24e:	8082                	ret

0000000000000250 <mount>:
 250:	02800893          	li	a7,40
 254:	00000073          	ecall
 258:	8082                	ret

000000000000025a <chdir>:
 25a:	03100893          	li	a7,49
 25e:	00000073          	ecall
 262:	8082                	ret

0000000000000264 <openat>:
 264:	03800893          	li	a7,56
 268:	00000073          	ecall
 26c:	8082                	ret

000000000000026e <close>:
 26e:	03900893          	li	a7,57
 272:	00000073          	ecall
 276:	8082                	ret

0000000000000278 <pipe2>:
 278:	03b00893          	li	a7,59
 27c:	00000073          	ecall
 280:	8082                	ret

0000000000000282 <getdents64>:
 282:	03d00893          	li	a7,61
 286:	00000073          	ecall
 28a:	8082                	ret

000000000000028c <read>:
 28c:	03f00893          	li	a7,63
 290:	00000073          	ecall
 294:	8082                	ret

0000000000000296 <write>:
 296:	04000893          	li	a7,64
 29a:	00000073          	ecall
 29e:	8082                	ret

00000000000002a0 <fstat>:
 2a0:	05000893          	li	a7,80
 2a4:	00000073          	ecall
 2a8:	8082                	ret

00000000000002aa <exit>:
 2aa:	05d00893          	li	a7,93
 2ae:	00000073          	ecall
 2b2:	8082                	ret

00000000000002b4 <nanosleep>:
 2b4:	06500893          	li	a7,101
 2b8:	00000073          	ecall
 2bc:	8082                	ret

00000000000002be <sched_yield>:
 2be:	07c00893          	li	a7,124
 2c2:	00000073          	ecall
 2c6:	8082                	ret

00000000000002c8 <times>:
 2c8:	09900893          	li	a7,153
 2cc:	00000073          	ecall
 2d0:	8082                	ret

00000000000002d2 <uname>:
 2d2:	0a000893          	li	a7,160
 2d6:	00000073          	ecall
 2da:	8082                	ret

00000000000002dc <gettimeofday>:
 2dc:	0a900893          	li	a7,169
 2e0:	00000073          	ecall
 2e4:	8082                	ret

00000000000002e6 <brk>:
 2e6:	0d600893          	li	a7,214
 2ea:	00000073          	ecall
 2ee:	8082                	ret

00000000000002f0 <munmap>:
 2f0:	0d700893          	li	a7,215
 2f4:	00000073          	ecall
 2f8:	8082                	ret

00000000000002fa <getpid>:
 2fa:	0ac00893          	li	a7,172
 2fe:	00000073          	ecall
 302:	8082                	ret

0000000000000304 <getppid>:
 304:	0ad00893          	li	a7,173
 308:	00000073          	ecall
 30c:	8082                	ret

000000000000030e <clone>:
 30e:	0dc00893          	li	a7,220
 312:	00000073          	ecall
 316:	8082                	ret

0000000000000318 <execve>:
 318:	0dd00893          	li	a7,221
 31c:	00000073          	ecall
 320:	8082                	ret

0000000000000322 <mmap>:
 322:	0de00893          	li	a7,222
 326:	00000073          	ecall
 32a:	8082                	ret

000000000000032c <wait4>:
 32c:	10400893          	li	a7,260
 330:	00000073          	ecall
 334:	8082                	ret

0000000000000336 <kernel_panic>:
 336:	18f00893          	li	a7,399
 33a:	00000073          	ecall
 33e:	8082                	ret

0000000000000340 <strcpy>:
 340:	87aa                	mv	a5,a0
 342:	0585                	addi	a1,a1,1
 344:	0785                	addi	a5,a5,1
 346:	fff5c703          	lbu	a4,-1(a1)
 34a:	fee78fa3          	sb	a4,-1(a5)
 34e:	fb75                	bnez	a4,342 <strcpy+0x2>
 350:	8082                	ret

0000000000000352 <strcmp>:
 352:	00054783          	lbu	a5,0(a0)
 356:	cb91                	beqz	a5,36a <strcmp+0x18>
 358:	0005c703          	lbu	a4,0(a1)
 35c:	00f71763          	bne	a4,a5,36a <strcmp+0x18>
 360:	0505                	addi	a0,a0,1
 362:	0585                	addi	a1,a1,1
 364:	00054783          	lbu	a5,0(a0)
 368:	fbe5                	bnez	a5,358 <strcmp+0x6>
 36a:	0005c503          	lbu	a0,0(a1)
 36e:	40a7853b          	subw	a0,a5,a0
 372:	8082                	ret

0000000000000374 <strlen>:
 374:	00054783          	lbu	a5,0(a0)
 378:	cf81                	beqz	a5,390 <strlen+0x1c>
 37a:	0505                	addi	a0,a0,1
 37c:	87aa                	mv	a5,a0
 37e:	4685                	li	a3,1
 380:	9e89                	subw	a3,a3,a0
 382:	00f6853b          	addw	a0,a3,a5
 386:	0785                	addi	a5,a5,1
 388:	fff7c703          	lbu	a4,-1(a5)
 38c:	fb7d                	bnez	a4,382 <strlen+0xe>
 38e:	8082                	ret
 390:	4501                	li	a0,0
 392:	8082                	ret

0000000000000394 <memset>:
 394:	ce09                	beqz	a2,3ae <memset+0x1a>
 396:	87aa                	mv	a5,a0
 398:	fff6071b          	addiw	a4,a2,-1
 39c:	1702                	slli	a4,a4,0x20
 39e:	9301                	srli	a4,a4,0x20
 3a0:	0705                	addi	a4,a4,1
 3a2:	972a                	add	a4,a4,a0
 3a4:	00b78023          	sb	a1,0(a5)
 3a8:	0785                	addi	a5,a5,1
 3aa:	fee79de3          	bne	a5,a4,3a4 <memset+0x10>
 3ae:	8082                	ret

00000000000003b0 <strchr>:
 3b0:	00054783          	lbu	a5,0(a0)
 3b4:	cb89                	beqz	a5,3c6 <strchr+0x16>
 3b6:	00f58963          	beq	a1,a5,3c8 <strchr+0x18>
 3ba:	0505                	addi	a0,a0,1
 3bc:	00054783          	lbu	a5,0(a0)
 3c0:	fbfd                	bnez	a5,3b6 <strchr+0x6>
 3c2:	4501                	li	a0,0
 3c4:	8082                	ret
 3c6:	4501                	li	a0,0
 3c8:	8082                	ret

00000000000003ca <gets>:
 3ca:	715d                	addi	sp,sp,-80
 3cc:	e486                	sd	ra,72(sp)
 3ce:	e0a2                	sd	s0,64(sp)
 3d0:	fc26                	sd	s1,56(sp)
 3d2:	f84a                	sd	s2,48(sp)
 3d4:	f44e                	sd	s3,40(sp)
 3d6:	f052                	sd	s4,32(sp)
 3d8:	ec56                	sd	s5,24(sp)
 3da:	e85a                	sd	s6,16(sp)
 3dc:	8b2a                	mv	s6,a0
 3de:	89ae                	mv	s3,a1
 3e0:	84aa                	mv	s1,a0
 3e2:	4401                	li	s0,0
 3e4:	4a29                	li	s4,10
 3e6:	4ab5                	li	s5,13
 3e8:	8922                	mv	s2,s0
 3ea:	2405                	addiw	s0,s0,1
 3ec:	03345863          	bge	s0,s3,41c <gets+0x52>
 3f0:	4605                	li	a2,1
 3f2:	00f10593          	addi	a1,sp,15
 3f6:	4501                	li	a0,0
 3f8:	00000097          	auipc	ra,0x0
 3fc:	e94080e7          	jalr	-364(ra) # 28c <read>
 400:	00a05e63          	blez	a0,41c <gets+0x52>
 404:	00f14783          	lbu	a5,15(sp)
 408:	00f48023          	sb	a5,0(s1)
 40c:	01478763          	beq	a5,s4,41a <gets+0x50>
 410:	0485                	addi	s1,s1,1
 412:	fd579be3          	bne	a5,s5,3e8 <gets+0x1e>
 416:	8922                	mv	s2,s0
 418:	a011                	j	41c <gets+0x52>
 41a:	8922                	mv	s2,s0
 41c:	995a                	add	s2,s2,s6
 41e:	00090023          	sb	zero,0(s2)
 422:	855a                	mv	a0,s6
 424:	60a6                	ld	ra,72(sp)
 426:	6406                	ld	s0,64(sp)
 428:	74e2                	ld	s1,56(sp)
 42a:	7942                	ld	s2,48(sp)
 42c:	79a2                	ld	s3,40(sp)
 42e:	7a02                	ld	s4,32(sp)
 430:	6ae2                	ld	s5,24(sp)
 432:	6b42                	ld	s6,16(sp)
 434:	6161                	addi	sp,sp,80
 436:	8082                	ret

0000000000000438 <atoi>:
 438:	86aa                	mv	a3,a0
 43a:	00054603          	lbu	a2,0(a0)
 43e:	fd06079b          	addiw	a5,a2,-48
 442:	0ff7f793          	andi	a5,a5,255
 446:	4725                	li	a4,9
 448:	02f76663          	bltu	a4,a5,474 <atoi+0x3c>
 44c:	4501                	li	a0,0
 44e:	45a5                	li	a1,9
 450:	0685                	addi	a3,a3,1
 452:	0025179b          	slliw	a5,a0,0x2
 456:	9fa9                	addw	a5,a5,a0
 458:	0017979b          	slliw	a5,a5,0x1
 45c:	9fb1                	addw	a5,a5,a2
 45e:	fd07851b          	addiw	a0,a5,-48
 462:	0006c603          	lbu	a2,0(a3)
 466:	fd06071b          	addiw	a4,a2,-48
 46a:	0ff77713          	andi	a4,a4,255
 46e:	fee5f1e3          	bgeu	a1,a4,450 <atoi+0x18>
 472:	8082                	ret
 474:	4501                	li	a0,0
 476:	8082                	ret

0000000000000478 <memmove>:
 478:	02b57463          	bgeu	a0,a1,4a0 <memmove+0x28>
 47c:	04c05663          	blez	a2,4c8 <memmove+0x50>
 480:	fff6079b          	addiw	a5,a2,-1
 484:	1782                	slli	a5,a5,0x20
 486:	9381                	srli	a5,a5,0x20
 488:	0785                	addi	a5,a5,1
 48a:	97aa                	add	a5,a5,a0
 48c:	872a                	mv	a4,a0
 48e:	0585                	addi	a1,a1,1
 490:	0705                	addi	a4,a4,1
 492:	fff5c683          	lbu	a3,-1(a1)
 496:	fed70fa3          	sb	a3,-1(a4)
 49a:	fee79ae3          	bne	a5,a4,48e <memmove+0x16>
 49e:	8082                	ret
 4a0:	00c50733          	add	a4,a0,a2
 4a4:	95b2                	add	a1,a1,a2
 4a6:	02c05163          	blez	a2,4c8 <memmove+0x50>
 4aa:	fff6079b          	addiw	a5,a2,-1
 4ae:	1782                	slli	a5,a5,0x20
 4b0:	9381                	srli	a5,a5,0x20
 4b2:	fff7c793          	not	a5,a5
 4b6:	97ba                	add	a5,a5,a4
 4b8:	15fd                	addi	a1,a1,-1
 4ba:	177d                	addi	a4,a4,-1
 4bc:	0005c683          	lbu	a3,0(a1)
 4c0:	00d70023          	sb	a3,0(a4)
 4c4:	fee79ae3          	bne	a5,a4,4b8 <memmove+0x40>
 4c8:	8082                	ret

00000000000004ca <memcmp>:
 4ca:	fff6069b          	addiw	a3,a2,-1
 4ce:	c605                	beqz	a2,4f6 <memcmp+0x2c>
 4d0:	1682                	slli	a3,a3,0x20
 4d2:	9281                	srli	a3,a3,0x20
 4d4:	0685                	addi	a3,a3,1
 4d6:	96aa                	add	a3,a3,a0
 4d8:	00054783          	lbu	a5,0(a0)
 4dc:	0005c703          	lbu	a4,0(a1)
 4e0:	00e79863          	bne	a5,a4,4f0 <memcmp+0x26>
 4e4:	0505                	addi	a0,a0,1
 4e6:	0585                	addi	a1,a1,1
 4e8:	fed518e3          	bne	a0,a3,4d8 <memcmp+0xe>
 4ec:	4501                	li	a0,0
 4ee:	8082                	ret
 4f0:	40e7853b          	subw	a0,a5,a4
 4f4:	8082                	ret
 4f6:	4501                	li	a0,0
 4f8:	8082                	ret

00000000000004fa <memcpy>:
 4fa:	1141                	addi	sp,sp,-16
 4fc:	e406                	sd	ra,8(sp)
 4fe:	00000097          	auipc	ra,0x0
 502:	f7a080e7          	jalr	-134(ra) # 478 <memmove>
 506:	60a2                	ld	ra,8(sp)
 508:	0141                	addi	sp,sp,16
 50a:	8082                	ret

000000000000050c <putc>:
 50c:	1101                	addi	sp,sp,-32
 50e:	ec06                	sd	ra,24(sp)
 510:	00b107a3          	sb	a1,15(sp)
 514:	4605                	li	a2,1
 516:	00f10593          	addi	a1,sp,15
 51a:	00000097          	auipc	ra,0x0
 51e:	d7c080e7          	jalr	-644(ra) # 296 <write>
 522:	60e2                	ld	ra,24(sp)
 524:	6105                	addi	sp,sp,32
 526:	8082                	ret

0000000000000528 <printint>:
 528:	7179                	addi	sp,sp,-48
 52a:	f406                	sd	ra,40(sp)
 52c:	f022                	sd	s0,32(sp)
 52e:	ec26                	sd	s1,24(sp)
 530:	e84a                	sd	s2,16(sp)
 532:	84aa                	mv	s1,a0
 534:	c299                	beqz	a3,53a <printint+0x12>
 536:	0805c363          	bltz	a1,5bc <printint+0x94>
 53a:	2581                	sext.w	a1,a1
 53c:	4881                	li	a7,0
 53e:	868a                	mv	a3,sp
 540:	4701                	li	a4,0
 542:	2601                	sext.w	a2,a2
 544:	00000517          	auipc	a0,0x0
 548:	54450513          	addi	a0,a0,1348 # a88 <digits>
 54c:	883a                	mv	a6,a4
 54e:	2705                	addiw	a4,a4,1
 550:	02c5f7bb          	remuw	a5,a1,a2
 554:	1782                	slli	a5,a5,0x20
 556:	9381                	srli	a5,a5,0x20
 558:	97aa                	add	a5,a5,a0
 55a:	0007c783          	lbu	a5,0(a5)
 55e:	00f68023          	sb	a5,0(a3)
 562:	0005879b          	sext.w	a5,a1
 566:	02c5d5bb          	divuw	a1,a1,a2
 56a:	0685                	addi	a3,a3,1
 56c:	fec7f0e3          	bgeu	a5,a2,54c <printint+0x24>
 570:	00088a63          	beqz	a7,584 <printint+0x5c>
 574:	081c                	addi	a5,sp,16
 576:	973e                	add	a4,a4,a5
 578:	02d00793          	li	a5,45
 57c:	fef70823          	sb	a5,-16(a4)
 580:	0028071b          	addiw	a4,a6,2
 584:	02e05663          	blez	a4,5b0 <printint+0x88>
 588:	00e10433          	add	s0,sp,a4
 58c:	fff10913          	addi	s2,sp,-1
 590:	993a                	add	s2,s2,a4
 592:	377d                	addiw	a4,a4,-1
 594:	1702                	slli	a4,a4,0x20
 596:	9301                	srli	a4,a4,0x20
 598:	40e90933          	sub	s2,s2,a4
 59c:	fff44583          	lbu	a1,-1(s0)
 5a0:	8526                	mv	a0,s1
 5a2:	00000097          	auipc	ra,0x0
 5a6:	f6a080e7          	jalr	-150(ra) # 50c <putc>
 5aa:	147d                	addi	s0,s0,-1
 5ac:	ff2418e3          	bne	s0,s2,59c <printint+0x74>
 5b0:	70a2                	ld	ra,40(sp)
 5b2:	7402                	ld	s0,32(sp)
 5b4:	64e2                	ld	s1,24(sp)
 5b6:	6942                	ld	s2,16(sp)
 5b8:	6145                	addi	sp,sp,48
 5ba:	8082                	ret
 5bc:	40b005bb          	negw	a1,a1
 5c0:	4885                	li	a7,1
 5c2:	bfb5                	j	53e <printint+0x16>

00000000000005c4 <vprintf>:
 5c4:	7119                	addi	sp,sp,-128
 5c6:	fc86                	sd	ra,120(sp)
 5c8:	f8a2                	sd	s0,112(sp)
 5ca:	f4a6                	sd	s1,104(sp)
 5cc:	f0ca                	sd	s2,96(sp)
 5ce:	ecce                	sd	s3,88(sp)
 5d0:	e8d2                	sd	s4,80(sp)
 5d2:	e4d6                	sd	s5,72(sp)
 5d4:	e0da                	sd	s6,64(sp)
 5d6:	fc5e                	sd	s7,56(sp)
 5d8:	f862                	sd	s8,48(sp)
 5da:	f466                	sd	s9,40(sp)
 5dc:	f06a                	sd	s10,32(sp)
 5de:	ec6e                	sd	s11,24(sp)
 5e0:	0005c483          	lbu	s1,0(a1)
 5e4:	18048c63          	beqz	s1,77c <vprintf+0x1b8>
 5e8:	8a2a                	mv	s4,a0
 5ea:	8ab2                	mv	s5,a2
 5ec:	00158413          	addi	s0,a1,1
 5f0:	4901                	li	s2,0
 5f2:	02500993          	li	s3,37
 5f6:	06400b93          	li	s7,100
 5fa:	06c00c13          	li	s8,108
 5fe:	07800c93          	li	s9,120
 602:	07000d13          	li	s10,112
 606:	07300d93          	li	s11,115
 60a:	00000b17          	auipc	s6,0x0
 60e:	47eb0b13          	addi	s6,s6,1150 # a88 <digits>
 612:	a839                	j	630 <vprintf+0x6c>
 614:	85a6                	mv	a1,s1
 616:	8552                	mv	a0,s4
 618:	00000097          	auipc	ra,0x0
 61c:	ef4080e7          	jalr	-268(ra) # 50c <putc>
 620:	a019                	j	626 <vprintf+0x62>
 622:	01390f63          	beq	s2,s3,640 <vprintf+0x7c>
 626:	0405                	addi	s0,s0,1
 628:	fff44483          	lbu	s1,-1(s0)
 62c:	14048863          	beqz	s1,77c <vprintf+0x1b8>
 630:	0004879b          	sext.w	a5,s1
 634:	fe0917e3          	bnez	s2,622 <vprintf+0x5e>
 638:	fd379ee3          	bne	a5,s3,614 <vprintf+0x50>
 63c:	893e                	mv	s2,a5
 63e:	b7e5                	j	626 <vprintf+0x62>
 640:	03778e63          	beq	a5,s7,67c <vprintf+0xb8>
 644:	05878a63          	beq	a5,s8,698 <vprintf+0xd4>
 648:	07978663          	beq	a5,s9,6b4 <vprintf+0xf0>
 64c:	09a78263          	beq	a5,s10,6d0 <vprintf+0x10c>
 650:	0db78363          	beq	a5,s11,716 <vprintf+0x152>
 654:	06300713          	li	a4,99
 658:	0ee78b63          	beq	a5,a4,74e <vprintf+0x18a>
 65c:	11378563          	beq	a5,s3,766 <vprintf+0x1a2>
 660:	85ce                	mv	a1,s3
 662:	8552                	mv	a0,s4
 664:	00000097          	auipc	ra,0x0
 668:	ea8080e7          	jalr	-344(ra) # 50c <putc>
 66c:	85a6                	mv	a1,s1
 66e:	8552                	mv	a0,s4
 670:	00000097          	auipc	ra,0x0
 674:	e9c080e7          	jalr	-356(ra) # 50c <putc>
 678:	4901                	li	s2,0
 67a:	b775                	j	626 <vprintf+0x62>
 67c:	008a8493          	addi	s1,s5,8
 680:	4685                	li	a3,1
 682:	4629                	li	a2,10
 684:	000aa583          	lw	a1,0(s5)
 688:	8552                	mv	a0,s4
 68a:	00000097          	auipc	ra,0x0
 68e:	e9e080e7          	jalr	-354(ra) # 528 <printint>
 692:	8aa6                	mv	s5,s1
 694:	4901                	li	s2,0
 696:	bf41                	j	626 <vprintf+0x62>
 698:	008a8493          	addi	s1,s5,8
 69c:	4681                	li	a3,0
 69e:	4629                	li	a2,10
 6a0:	000aa583          	lw	a1,0(s5)
 6a4:	8552                	mv	a0,s4
 6a6:	00000097          	auipc	ra,0x0
 6aa:	e82080e7          	jalr	-382(ra) # 528 <printint>
 6ae:	8aa6                	mv	s5,s1
 6b0:	4901                	li	s2,0
 6b2:	bf95                	j	626 <vprintf+0x62>
 6b4:	008a8493          	addi	s1,s5,8
 6b8:	4681                	li	a3,0
 6ba:	4641                	li	a2,16
 6bc:	000aa583          	lw	a1,0(s5)
 6c0:	8552                	mv	a0,s4
 6c2:	00000097          	auipc	ra,0x0
 6c6:	e66080e7          	jalr	-410(ra) # 528 <printint>
 6ca:	8aa6                	mv	s5,s1
 6cc:	4901                	li	s2,0
 6ce:	bfa1                	j	626 <vprintf+0x62>
 6d0:	008a8793          	addi	a5,s5,8
 6d4:	e43e                	sd	a5,8(sp)
 6d6:	000ab903          	ld	s2,0(s5)
 6da:	03000593          	li	a1,48
 6de:	8552                	mv	a0,s4
 6e0:	00000097          	auipc	ra,0x0
 6e4:	e2c080e7          	jalr	-468(ra) # 50c <putc>
 6e8:	85e6                	mv	a1,s9
 6ea:	8552                	mv	a0,s4
 6ec:	00000097          	auipc	ra,0x0
 6f0:	e20080e7          	jalr	-480(ra) # 50c <putc>
 6f4:	44c1                	li	s1,16
 6f6:	03c95793          	srli	a5,s2,0x3c
 6fa:	97da                	add	a5,a5,s6
 6fc:	0007c583          	lbu	a1,0(a5)
 700:	8552                	mv	a0,s4
 702:	00000097          	auipc	ra,0x0
 706:	e0a080e7          	jalr	-502(ra) # 50c <putc>
 70a:	0912                	slli	s2,s2,0x4
 70c:	34fd                	addiw	s1,s1,-1
 70e:	f4e5                	bnez	s1,6f6 <vprintf+0x132>
 710:	6aa2                	ld	s5,8(sp)
 712:	4901                	li	s2,0
 714:	bf09                	j	626 <vprintf+0x62>
 716:	008a8493          	addi	s1,s5,8
 71a:	000ab903          	ld	s2,0(s5)
 71e:	02090163          	beqz	s2,740 <vprintf+0x17c>
 722:	00094583          	lbu	a1,0(s2)
 726:	c9a1                	beqz	a1,776 <vprintf+0x1b2>
 728:	8552                	mv	a0,s4
 72a:	00000097          	auipc	ra,0x0
 72e:	de2080e7          	jalr	-542(ra) # 50c <putc>
 732:	0905                	addi	s2,s2,1
 734:	00094583          	lbu	a1,0(s2)
 738:	f9e5                	bnez	a1,728 <vprintf+0x164>
 73a:	8aa6                	mv	s5,s1
 73c:	4901                	li	s2,0
 73e:	b5e5                	j	626 <vprintf+0x62>
 740:	00000917          	auipc	s2,0x0
 744:	34090913          	addi	s2,s2,832 # a80 <malloc+0x21e>
 748:	02800593          	li	a1,40
 74c:	bff1                	j	728 <vprintf+0x164>
 74e:	008a8493          	addi	s1,s5,8
 752:	000ac583          	lbu	a1,0(s5)
 756:	8552                	mv	a0,s4
 758:	00000097          	auipc	ra,0x0
 75c:	db4080e7          	jalr	-588(ra) # 50c <putc>
 760:	8aa6                	mv	s5,s1
 762:	4901                	li	s2,0
 764:	b5c9                	j	626 <vprintf+0x62>
 766:	85ce                	mv	a1,s3
 768:	8552                	mv	a0,s4
 76a:	00000097          	auipc	ra,0x0
 76e:	da2080e7          	jalr	-606(ra) # 50c <putc>
 772:	4901                	li	s2,0
 774:	bd4d                	j	626 <vprintf+0x62>
 776:	8aa6                	mv	s5,s1
 778:	4901                	li	s2,0
 77a:	b575                	j	626 <vprintf+0x62>
 77c:	70e6                	ld	ra,120(sp)
 77e:	7446                	ld	s0,112(sp)
 780:	74a6                	ld	s1,104(sp)
 782:	7906                	ld	s2,96(sp)
 784:	69e6                	ld	s3,88(sp)
 786:	6a46                	ld	s4,80(sp)
 788:	6aa6                	ld	s5,72(sp)
 78a:	6b06                	ld	s6,64(sp)
 78c:	7be2                	ld	s7,56(sp)
 78e:	7c42                	ld	s8,48(sp)
 790:	7ca2                	ld	s9,40(sp)
 792:	7d02                	ld	s10,32(sp)
 794:	6de2                	ld	s11,24(sp)
 796:	6109                	addi	sp,sp,128
 798:	8082                	ret

000000000000079a <fprintf>:
 79a:	715d                	addi	sp,sp,-80
 79c:	ec06                	sd	ra,24(sp)
 79e:	f032                	sd	a2,32(sp)
 7a0:	f436                	sd	a3,40(sp)
 7a2:	f83a                	sd	a4,48(sp)
 7a4:	fc3e                	sd	a5,56(sp)
 7a6:	e0c2                	sd	a6,64(sp)
 7a8:	e4c6                	sd	a7,72(sp)
 7aa:	1010                	addi	a2,sp,32
 7ac:	e432                	sd	a2,8(sp)
 7ae:	00000097          	auipc	ra,0x0
 7b2:	e16080e7          	jalr	-490(ra) # 5c4 <vprintf>
 7b6:	60e2                	ld	ra,24(sp)
 7b8:	6161                	addi	sp,sp,80
 7ba:	8082                	ret

00000000000007bc <printf>:
 7bc:	711d                	addi	sp,sp,-96
 7be:	ec06                	sd	ra,24(sp)
 7c0:	f42e                	sd	a1,40(sp)
 7c2:	f832                	sd	a2,48(sp)
 7c4:	fc36                	sd	a3,56(sp)
 7c6:	e0ba                	sd	a4,64(sp)
 7c8:	e4be                	sd	a5,72(sp)
 7ca:	e8c2                	sd	a6,80(sp)
 7cc:	ecc6                	sd	a7,88(sp)
 7ce:	1030                	addi	a2,sp,40
 7d0:	e432                	sd	a2,8(sp)
 7d2:	85aa                	mv	a1,a0
 7d4:	4505                	li	a0,1
 7d6:	00000097          	auipc	ra,0x0
 7da:	dee080e7          	jalr	-530(ra) # 5c4 <vprintf>
 7de:	60e2                	ld	ra,24(sp)
 7e0:	6125                	addi	sp,sp,96
 7e2:	8082                	ret

00000000000007e4 <free>:
 7e4:	ff050693          	addi	a3,a0,-16
 7e8:	00000797          	auipc	a5,0x0
 7ec:	2b87b783          	ld	a5,696(a5) # aa0 <freep>
 7f0:	a805                	j	820 <free+0x3c>
 7f2:	4618                	lw	a4,8(a2)
 7f4:	9db9                	addw	a1,a1,a4
 7f6:	feb52c23          	sw	a1,-8(a0)
 7fa:	6398                	ld	a4,0(a5)
 7fc:	6318                	ld	a4,0(a4)
 7fe:	fee53823          	sd	a4,-16(a0)
 802:	a091                	j	846 <free+0x62>
 804:	ff852703          	lw	a4,-8(a0)
 808:	9e39                	addw	a2,a2,a4
 80a:	c790                	sw	a2,8(a5)
 80c:	ff053703          	ld	a4,-16(a0)
 810:	e398                	sd	a4,0(a5)
 812:	a099                	j	858 <free+0x74>
 814:	6398                	ld	a4,0(a5)
 816:	00e7e463          	bltu	a5,a4,81e <free+0x3a>
 81a:	00e6ea63          	bltu	a3,a4,82e <free+0x4a>
 81e:	87ba                	mv	a5,a4
 820:	fed7fae3          	bgeu	a5,a3,814 <free+0x30>
 824:	6398                	ld	a4,0(a5)
 826:	00e6e463          	bltu	a3,a4,82e <free+0x4a>
 82a:	fee7eae3          	bltu	a5,a4,81e <free+0x3a>
 82e:	ff852583          	lw	a1,-8(a0)
 832:	6390                	ld	a2,0(a5)
 834:	02059713          	slli	a4,a1,0x20
 838:	9301                	srli	a4,a4,0x20
 83a:	0712                	slli	a4,a4,0x4
 83c:	9736                	add	a4,a4,a3
 83e:	fae60ae3          	beq	a2,a4,7f2 <free+0xe>
 842:	fec53823          	sd	a2,-16(a0)
 846:	4790                	lw	a2,8(a5)
 848:	02061713          	slli	a4,a2,0x20
 84c:	9301                	srli	a4,a4,0x20
 84e:	0712                	slli	a4,a4,0x4
 850:	973e                	add	a4,a4,a5
 852:	fae689e3          	beq	a3,a4,804 <free+0x20>
 856:	e394                	sd	a3,0(a5)
 858:	00000717          	auipc	a4,0x0
 85c:	24f73423          	sd	a5,584(a4) # aa0 <freep>
 860:	8082                	ret

0000000000000862 <malloc>:
 862:	7139                	addi	sp,sp,-64
 864:	fc06                	sd	ra,56(sp)
 866:	f822                	sd	s0,48(sp)
 868:	f426                	sd	s1,40(sp)
 86a:	f04a                	sd	s2,32(sp)
 86c:	ec4e                	sd	s3,24(sp)
 86e:	e852                	sd	s4,16(sp)
 870:	e456                	sd	s5,8(sp)
 872:	02051413          	slli	s0,a0,0x20
 876:	9001                	srli	s0,s0,0x20
 878:	043d                	addi	s0,s0,15
 87a:	8011                	srli	s0,s0,0x4
 87c:	0014091b          	addiw	s2,s0,1
 880:	0405                	addi	s0,s0,1
 882:	00000517          	auipc	a0,0x0
 886:	21e53503          	ld	a0,542(a0) # aa0 <freep>
 88a:	c905                	beqz	a0,8ba <malloc+0x58>
 88c:	611c                	ld	a5,0(a0)
 88e:	4798                	lw	a4,8(a5)
 890:	04877163          	bgeu	a4,s0,8d2 <malloc+0x70>
 894:	89ca                	mv	s3,s2
 896:	0009071b          	sext.w	a4,s2
 89a:	6685                	lui	a3,0x1
 89c:	00d77363          	bgeu	a4,a3,8a2 <malloc+0x40>
 8a0:	6985                	lui	s3,0x1
 8a2:	00098a1b          	sext.w	s4,s3
 8a6:	1982                	slli	s3,s3,0x20
 8a8:	0209d993          	srli	s3,s3,0x20
 8ac:	0992                	slli	s3,s3,0x4
 8ae:	00000497          	auipc	s1,0x0
 8b2:	1f248493          	addi	s1,s1,498 # aa0 <freep>
 8b6:	5afd                	li	s5,-1
 8b8:	a0bd                	j	926 <malloc+0xc4>
 8ba:	00000797          	auipc	a5,0x0
 8be:	1ee78793          	addi	a5,a5,494 # aa8 <base>
 8c2:	00000717          	auipc	a4,0x0
 8c6:	1cf73f23          	sd	a5,478(a4) # aa0 <freep>
 8ca:	e39c                	sd	a5,0(a5)
 8cc:	0007a423          	sw	zero,8(a5)
 8d0:	b7d1                	j	894 <malloc+0x32>
 8d2:	02e40a63          	beq	s0,a4,906 <malloc+0xa4>
 8d6:	4127073b          	subw	a4,a4,s2
 8da:	c798                	sw	a4,8(a5)
 8dc:	1702                	slli	a4,a4,0x20
 8de:	9301                	srli	a4,a4,0x20
 8e0:	0712                	slli	a4,a4,0x4
 8e2:	97ba                	add	a5,a5,a4
 8e4:	0127a423          	sw	s2,8(a5)
 8e8:	00000717          	auipc	a4,0x0
 8ec:	1aa73c23          	sd	a0,440(a4) # aa0 <freep>
 8f0:	01078513          	addi	a0,a5,16
 8f4:	70e2                	ld	ra,56(sp)
 8f6:	7442                	ld	s0,48(sp)
 8f8:	74a2                	ld	s1,40(sp)
 8fa:	7902                	ld	s2,32(sp)
 8fc:	69e2                	ld	s3,24(sp)
 8fe:	6a42                	ld	s4,16(sp)
 900:	6aa2                	ld	s5,8(sp)
 902:	6121                	addi	sp,sp,64
 904:	8082                	ret
 906:	6398                	ld	a4,0(a5)
 908:	e118                	sd	a4,0(a0)
 90a:	bff9                	j	8e8 <malloc+0x86>
 90c:	01452423          	sw	s4,8(a0)
 910:	0541                	addi	a0,a0,16
 912:	00000097          	auipc	ra,0x0
 916:	ed2080e7          	jalr	-302(ra) # 7e4 <free>
 91a:	6088                	ld	a0,0(s1)
 91c:	dd61                	beqz	a0,8f4 <malloc+0x92>
 91e:	611c                	ld	a5,0(a0)
 920:	4798                	lw	a4,8(a5)
 922:	fa8778e3          	bgeu	a4,s0,8d2 <malloc+0x70>
 926:	6098                	ld	a4,0(s1)
 928:	853e                	mv	a0,a5
 92a:	fef71ae3          	bne	a4,a5,91e <malloc+0xbc>
 92e:	854e                	mv	a0,s3
 930:	00000097          	auipc	ra,0x0
 934:	8d8080e7          	jalr	-1832(ra) # 208 <sbrk>
 938:	fd551ae3          	bne	a0,s5,90c <malloc+0xaa>
 93c:	4501                	li	a0,0
 93e:	bf5d                	j	8f4 <malloc+0x92>
