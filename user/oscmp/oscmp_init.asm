
_oscmp_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_success>:
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	842a                	mv	s0,a0
   a:	00001517          	auipc	a0,0x1
   e:	98e50513          	addi	a0,a0,-1650 # 998 <malloc+0x118>
  12:	00000097          	auipc	ra,0x0
  16:	7c8080e7          	jalr	1992(ra) # 7da <printf>
  1a:	600c                	ld	a1,0(s0)
  1c:	cd99                	beqz	a1,3a <print_success+0x3a>
  1e:	0421                	addi	s0,s0,8
  20:	00001497          	auipc	s1,0x1
  24:	99048493          	addi	s1,s1,-1648 # 9b0 <malloc+0x130>
  28:	8526                	mv	a0,s1
  2a:	00000097          	auipc	ra,0x0
  2e:	7b0080e7          	jalr	1968(ra) # 7da <printf>
  32:	0421                	addi	s0,s0,8
  34:	ff843583          	ld	a1,-8(s0)
  38:	f9e5                	bnez	a1,28 <print_success+0x28>
  3a:	00001517          	auipc	a0,0x1
  3e:	97e50513          	addi	a0,a0,-1666 # 9b8 <malloc+0x138>
  42:	00000097          	auipc	ra,0x0
  46:	798080e7          	jalr	1944(ra) # 7da <printf>
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
  64:	1ae080e7          	jalr	430(ra) # 20e <fork>
  68:	ed09                	bnez	a0,82 <test+0x2e>
  6a:	4601                	li	a2,0
  6c:	85a2                	mv	a1,s0
  6e:	8526                	mv	a0,s1
  70:	00000097          	auipc	ra,0x0
  74:	2c6080e7          	jalr	710(ra) # 336 <execve>
  78:	70a2                	ld	ra,40(sp)
  7a:	7402                	ld	s0,32(sp)
  7c:	64e2                	ld	s1,24(sp)
  7e:	6145                	addi	sp,sp,48
  80:	8082                	ret
  82:	0068                	addi	a0,sp,12
  84:	00000097          	auipc	ra,0x0
  88:	192080e7          	jalr	402(ra) # 216 <wait>
  8c:	47b2                	lw	a5,12(sp)
  8e:	fe07c5e3          	bltz	a5,78 <test+0x24>
  92:	8522                	mv	a0,s0
  94:	00000097          	auipc	ra,0x0
  98:	f6c080e7          	jalr	-148(ra) # 0 <print_success>
  9c:	bff1                	j	78 <test+0x24>

000000000000009e <main>:
  9e:	7151                	addi	sp,sp,-240
  a0:	f586                	sd	ra,232(sp)
  a2:	4589                	li	a1,2
  a4:	00001517          	auipc	a0,0x1
  a8:	92450513          	addi	a0,a0,-1756 # 9c8 <malloc+0x148>
  ac:	00000097          	auipc	ra,0x0
  b0:	172080e7          	jalr	370(ra) # 21e <open>
  b4:	4501                	li	a0,0
  b6:	00000097          	auipc	ra,0x0
  ba:	180080e7          	jalr	384(ra) # 236 <dup>
  be:	4501                	li	a0,0
  c0:	00000097          	auipc	ra,0x0
  c4:	176080e7          	jalr	374(ra) # 236 <dup>
  c8:	00001797          	auipc	a5,0x1
  cc:	90878793          	addi	a5,a5,-1784 # 9d0 <malloc+0x150>
  d0:	e5be                	sd	a5,200(sp)
  d2:	00001797          	auipc	a5,0x1
  d6:	90678793          	addi	a5,a5,-1786 # 9d8 <malloc+0x158>
  da:	e9be                	sd	a5,208(sp)
  dc:	ed82                	sd	zero,216(sp)
  de:	00001797          	auipc	a5,0x1
  e2:	96278793          	addi	a5,a5,-1694 # a40 <malloc+0x1c0>
  e6:	638c                	ld	a1,0(a5)
  e8:	6790                	ld	a2,8(a5)
  ea:	6b94                	ld	a3,16(a5)
  ec:	6f98                	ld	a4,24(a5)
  ee:	f52e                	sd	a1,168(sp)
  f0:	f932                	sd	a2,176(sp)
  f2:	fd36                	sd	a3,184(sp)
  f4:	e1ba                	sd	a4,192(sp)
  f6:	738c                	ld	a1,32(a5)
  f8:	7790                	ld	a2,40(a5)
  fa:	7b94                	ld	a3,48(a5)
  fc:	7f98                	ld	a4,56(a5)
  fe:	e52e                	sd	a1,136(sp)
 100:	e932                	sd	a2,144(sp)
 102:	ed36                	sd	a3,152(sp)
 104:	f13a                	sd	a4,160(sp)
 106:	00001717          	auipc	a4,0x1
 10a:	8f270713          	addi	a4,a4,-1806 # 9f8 <malloc+0x178>
 10e:	f8ba                	sd	a4,112(sp)
 110:	00001717          	auipc	a4,0x1
 114:	8f870713          	addi	a4,a4,-1800 # a08 <malloc+0x188>
 118:	fcba                	sd	a4,120(sp)
 11a:	e102                	sd	zero,128(sp)
 11c:	00001697          	auipc	a3,0x1
 120:	8fc68693          	addi	a3,a3,-1796 # a18 <malloc+0x198>
 124:	f0b6                	sd	a3,96(sp)
 126:	f482                	sd	zero,104(sp)
 128:	00001697          	auipc	a3,0x1
 12c:	8f868693          	addi	a3,a3,-1800 # a20 <malloc+0x1a0>
 130:	e8b6                	sd	a3,80(sp)
 132:	ec82                	sd	zero,88(sp)
 134:	00001697          	auipc	a3,0x1
 138:	8f468693          	addi	a3,a3,-1804 # a28 <malloc+0x1a8>
 13c:	e0b6                	sd	a3,64(sp)
 13e:	e482                	sd	zero,72(sp)
 140:	00001697          	auipc	a3,0x1
 144:	8f068693          	addi	a3,a3,-1808 # a30 <malloc+0x1b0>
 148:	f436                	sd	a3,40(sp)
 14a:	f83a                	sd	a4,48(sp)
 14c:	fc02                	sd	zero,56(sp)
 14e:	63ac                	ld	a1,64(a5)
 150:	67b0                	ld	a2,72(a5)
 152:	6bb4                	ld	a3,80(a5)
 154:	6fb8                	ld	a4,88(a5)
 156:	73bc                	ld	a5,96(a5)
 158:	e02e                	sd	a1,0(sp)
 15a:	e432                	sd	a2,8(sp)
 15c:	e836                	sd	a3,16(sp)
 15e:	ec3a                	sd	a4,24(sp)
 160:	f03e                	sd	a5,32(sp)
 162:	01ac                	addi	a1,sp,200
 164:	00001517          	auipc	a0,0x1
 168:	8d450513          	addi	a0,a0,-1836 # a38 <malloc+0x1b8>
 16c:	00000097          	auipc	ra,0x0
 170:	ee8080e7          	jalr	-280(ra) # 54 <test>
 174:	112c                	addi	a1,sp,168
 176:	00001517          	auipc	a0,0x1
 17a:	8c250513          	addi	a0,a0,-1854 # a38 <malloc+0x1b8>
 17e:	00000097          	auipc	ra,0x0
 182:	ed6080e7          	jalr	-298(ra) # 54 <test>
 186:	012c                	addi	a1,sp,136
 188:	00001517          	auipc	a0,0x1
 18c:	8b050513          	addi	a0,a0,-1872 # a38 <malloc+0x1b8>
 190:	00000097          	auipc	ra,0x0
 194:	ec4080e7          	jalr	-316(ra) # 54 <test>
 198:	188c                	addi	a1,sp,112
 19a:	00001517          	auipc	a0,0x1
 19e:	89e50513          	addi	a0,a0,-1890 # a38 <malloc+0x1b8>
 1a2:	00000097          	auipc	ra,0x0
 1a6:	eb2080e7          	jalr	-334(ra) # 54 <test>
 1aa:	108c                	addi	a1,sp,96
 1ac:	00001517          	auipc	a0,0x1
 1b0:	88c50513          	addi	a0,a0,-1908 # a38 <malloc+0x1b8>
 1b4:	00000097          	auipc	ra,0x0
 1b8:	ea0080e7          	jalr	-352(ra) # 54 <test>
 1bc:	088c                	addi	a1,sp,80
 1be:	00001517          	auipc	a0,0x1
 1c2:	87a50513          	addi	a0,a0,-1926 # a38 <malloc+0x1b8>
 1c6:	00000097          	auipc	ra,0x0
 1ca:	e8e080e7          	jalr	-370(ra) # 54 <test>
 1ce:	008c                	addi	a1,sp,64
 1d0:	00001517          	auipc	a0,0x1
 1d4:	86850513          	addi	a0,a0,-1944 # a38 <malloc+0x1b8>
 1d8:	00000097          	auipc	ra,0x0
 1dc:	e7c080e7          	jalr	-388(ra) # 54 <test>
 1e0:	102c                	addi	a1,sp,40
 1e2:	00001517          	auipc	a0,0x1
 1e6:	85650513          	addi	a0,a0,-1962 # a38 <malloc+0x1b8>
 1ea:	00000097          	auipc	ra,0x0
 1ee:	e6a080e7          	jalr	-406(ra) # 54 <test>
 1f2:	858a                	mv	a1,sp
 1f4:	00001517          	auipc	a0,0x1
 1f8:	84450513          	addi	a0,a0,-1980 # a38 <malloc+0x1b8>
 1fc:	00000097          	auipc	ra,0x0
 200:	e58080e7          	jalr	-424(ra) # 54 <test>
 204:	00000097          	auipc	ra,0x0
 208:	150080e7          	jalr	336(ra) # 354 <kernel_panic>
 20c:	a001                	j	20c <main+0x16e>

000000000000020e <fork>:
 20e:	4885                	li	a7,1
 210:	00000073          	ecall
 214:	8082                	ret

0000000000000216 <wait>:
 216:	488d                	li	a7,3
 218:	00000073          	ecall
 21c:	8082                	ret

000000000000021e <open>:
 21e:	4889                	li	a7,2
 220:	00000073          	ecall
 224:	8082                	ret

0000000000000226 <sbrk>:
 226:	4891                	li	a7,4
 228:	00000073          	ecall
 22c:	8082                	ret

000000000000022e <getcwd>:
 22e:	48c5                	li	a7,17
 230:	00000073          	ecall
 234:	8082                	ret

0000000000000236 <dup>:
 236:	48dd                	li	a7,23
 238:	00000073          	ecall
 23c:	8082                	ret

000000000000023e <dup3>:
 23e:	48e1                	li	a7,24
 240:	00000073          	ecall
 244:	8082                	ret

0000000000000246 <mkdirat>:
 246:	02200893          	li	a7,34
 24a:	00000073          	ecall
 24e:	8082                	ret

0000000000000250 <unlinkat>:
 250:	02300893          	li	a7,35
 254:	00000073          	ecall
 258:	8082                	ret

000000000000025a <linkat>:
 25a:	02500893          	li	a7,37
 25e:	00000073          	ecall
 262:	8082                	ret

0000000000000264 <umount2>:
 264:	02700893          	li	a7,39
 268:	00000073          	ecall
 26c:	8082                	ret

000000000000026e <mount>:
 26e:	02800893          	li	a7,40
 272:	00000073          	ecall
 276:	8082                	ret

0000000000000278 <chdir>:
 278:	03100893          	li	a7,49
 27c:	00000073          	ecall
 280:	8082                	ret

0000000000000282 <openat>:
 282:	03800893          	li	a7,56
 286:	00000073          	ecall
 28a:	8082                	ret

000000000000028c <close>:
 28c:	03900893          	li	a7,57
 290:	00000073          	ecall
 294:	8082                	ret

0000000000000296 <pipe2>:
 296:	03b00893          	li	a7,59
 29a:	00000073          	ecall
 29e:	8082                	ret

00000000000002a0 <getdents64>:
 2a0:	03d00893          	li	a7,61
 2a4:	00000073          	ecall
 2a8:	8082                	ret

00000000000002aa <read>:
 2aa:	03f00893          	li	a7,63
 2ae:	00000073          	ecall
 2b2:	8082                	ret

00000000000002b4 <write>:
 2b4:	04000893          	li	a7,64
 2b8:	00000073          	ecall
 2bc:	8082                	ret

00000000000002be <fstat>:
 2be:	05000893          	li	a7,80
 2c2:	00000073          	ecall
 2c6:	8082                	ret

00000000000002c8 <exit>:
 2c8:	05d00893          	li	a7,93
 2cc:	00000073          	ecall
 2d0:	8082                	ret

00000000000002d2 <nanosleep>:
 2d2:	06500893          	li	a7,101
 2d6:	00000073          	ecall
 2da:	8082                	ret

00000000000002dc <sched_yield>:
 2dc:	07c00893          	li	a7,124
 2e0:	00000073          	ecall
 2e4:	8082                	ret

00000000000002e6 <times>:
 2e6:	09900893          	li	a7,153
 2ea:	00000073          	ecall
 2ee:	8082                	ret

00000000000002f0 <uname>:
 2f0:	0a000893          	li	a7,160
 2f4:	00000073          	ecall
 2f8:	8082                	ret

00000000000002fa <gettimeofday>:
 2fa:	0a900893          	li	a7,169
 2fe:	00000073          	ecall
 302:	8082                	ret

0000000000000304 <brk>:
 304:	0d600893          	li	a7,214
 308:	00000073          	ecall
 30c:	8082                	ret

000000000000030e <munmap>:
 30e:	0d700893          	li	a7,215
 312:	00000073          	ecall
 316:	8082                	ret

0000000000000318 <getpid>:
 318:	0ac00893          	li	a7,172
 31c:	00000073          	ecall
 320:	8082                	ret

0000000000000322 <getppid>:
 322:	0ad00893          	li	a7,173
 326:	00000073          	ecall
 32a:	8082                	ret

000000000000032c <clone>:
 32c:	0dc00893          	li	a7,220
 330:	00000073          	ecall
 334:	8082                	ret

0000000000000336 <execve>:
 336:	0dd00893          	li	a7,221
 33a:	00000073          	ecall
 33e:	8082                	ret

0000000000000340 <mmap>:
 340:	0de00893          	li	a7,222
 344:	00000073          	ecall
 348:	8082                	ret

000000000000034a <wait4>:
 34a:	10400893          	li	a7,260
 34e:	00000073          	ecall
 352:	8082                	ret

0000000000000354 <kernel_panic>:
 354:	18f00893          	li	a7,399
 358:	00000073          	ecall
 35c:	8082                	ret

000000000000035e <strcpy>:
 35e:	87aa                	mv	a5,a0
 360:	0585                	addi	a1,a1,1
 362:	0785                	addi	a5,a5,1
 364:	fff5c703          	lbu	a4,-1(a1)
 368:	fee78fa3          	sb	a4,-1(a5)
 36c:	fb75                	bnez	a4,360 <strcpy+0x2>
 36e:	8082                	ret

0000000000000370 <strcmp>:
 370:	00054783          	lbu	a5,0(a0)
 374:	cb91                	beqz	a5,388 <strcmp+0x18>
 376:	0005c703          	lbu	a4,0(a1)
 37a:	00f71763          	bne	a4,a5,388 <strcmp+0x18>
 37e:	0505                	addi	a0,a0,1
 380:	0585                	addi	a1,a1,1
 382:	00054783          	lbu	a5,0(a0)
 386:	fbe5                	bnez	a5,376 <strcmp+0x6>
 388:	0005c503          	lbu	a0,0(a1)
 38c:	40a7853b          	subw	a0,a5,a0
 390:	8082                	ret

0000000000000392 <strlen>:
 392:	00054783          	lbu	a5,0(a0)
 396:	cf81                	beqz	a5,3ae <strlen+0x1c>
 398:	0505                	addi	a0,a0,1
 39a:	87aa                	mv	a5,a0
 39c:	4685                	li	a3,1
 39e:	9e89                	subw	a3,a3,a0
 3a0:	00f6853b          	addw	a0,a3,a5
 3a4:	0785                	addi	a5,a5,1
 3a6:	fff7c703          	lbu	a4,-1(a5)
 3aa:	fb7d                	bnez	a4,3a0 <strlen+0xe>
 3ac:	8082                	ret
 3ae:	4501                	li	a0,0
 3b0:	8082                	ret

00000000000003b2 <memset>:
 3b2:	ce09                	beqz	a2,3cc <memset+0x1a>
 3b4:	87aa                	mv	a5,a0
 3b6:	fff6071b          	addiw	a4,a2,-1
 3ba:	1702                	slli	a4,a4,0x20
 3bc:	9301                	srli	a4,a4,0x20
 3be:	0705                	addi	a4,a4,1
 3c0:	972a                	add	a4,a4,a0
 3c2:	00b78023          	sb	a1,0(a5)
 3c6:	0785                	addi	a5,a5,1
 3c8:	fee79de3          	bne	a5,a4,3c2 <memset+0x10>
 3cc:	8082                	ret

00000000000003ce <strchr>:
 3ce:	00054783          	lbu	a5,0(a0)
 3d2:	cb89                	beqz	a5,3e4 <strchr+0x16>
 3d4:	00f58963          	beq	a1,a5,3e6 <strchr+0x18>
 3d8:	0505                	addi	a0,a0,1
 3da:	00054783          	lbu	a5,0(a0)
 3de:	fbfd                	bnez	a5,3d4 <strchr+0x6>
 3e0:	4501                	li	a0,0
 3e2:	8082                	ret
 3e4:	4501                	li	a0,0
 3e6:	8082                	ret

00000000000003e8 <gets>:
 3e8:	715d                	addi	sp,sp,-80
 3ea:	e486                	sd	ra,72(sp)
 3ec:	e0a2                	sd	s0,64(sp)
 3ee:	fc26                	sd	s1,56(sp)
 3f0:	f84a                	sd	s2,48(sp)
 3f2:	f44e                	sd	s3,40(sp)
 3f4:	f052                	sd	s4,32(sp)
 3f6:	ec56                	sd	s5,24(sp)
 3f8:	e85a                	sd	s6,16(sp)
 3fa:	8b2a                	mv	s6,a0
 3fc:	89ae                	mv	s3,a1
 3fe:	84aa                	mv	s1,a0
 400:	4401                	li	s0,0
 402:	4a29                	li	s4,10
 404:	4ab5                	li	s5,13
 406:	8922                	mv	s2,s0
 408:	2405                	addiw	s0,s0,1
 40a:	03345863          	bge	s0,s3,43a <gets+0x52>
 40e:	4605                	li	a2,1
 410:	00f10593          	addi	a1,sp,15
 414:	4501                	li	a0,0
 416:	00000097          	auipc	ra,0x0
 41a:	e94080e7          	jalr	-364(ra) # 2aa <read>
 41e:	00a05e63          	blez	a0,43a <gets+0x52>
 422:	00f14783          	lbu	a5,15(sp)
 426:	00f48023          	sb	a5,0(s1)
 42a:	01478763          	beq	a5,s4,438 <gets+0x50>
 42e:	0485                	addi	s1,s1,1
 430:	fd579be3          	bne	a5,s5,406 <gets+0x1e>
 434:	8922                	mv	s2,s0
 436:	a011                	j	43a <gets+0x52>
 438:	8922                	mv	s2,s0
 43a:	995a                	add	s2,s2,s6
 43c:	00090023          	sb	zero,0(s2)
 440:	855a                	mv	a0,s6
 442:	60a6                	ld	ra,72(sp)
 444:	6406                	ld	s0,64(sp)
 446:	74e2                	ld	s1,56(sp)
 448:	7942                	ld	s2,48(sp)
 44a:	79a2                	ld	s3,40(sp)
 44c:	7a02                	ld	s4,32(sp)
 44e:	6ae2                	ld	s5,24(sp)
 450:	6b42                	ld	s6,16(sp)
 452:	6161                	addi	sp,sp,80
 454:	8082                	ret

0000000000000456 <atoi>:
 456:	86aa                	mv	a3,a0
 458:	00054603          	lbu	a2,0(a0)
 45c:	fd06079b          	addiw	a5,a2,-48
 460:	0ff7f793          	andi	a5,a5,255
 464:	4725                	li	a4,9
 466:	02f76663          	bltu	a4,a5,492 <atoi+0x3c>
 46a:	4501                	li	a0,0
 46c:	45a5                	li	a1,9
 46e:	0685                	addi	a3,a3,1
 470:	0025179b          	slliw	a5,a0,0x2
 474:	9fa9                	addw	a5,a5,a0
 476:	0017979b          	slliw	a5,a5,0x1
 47a:	9fb1                	addw	a5,a5,a2
 47c:	fd07851b          	addiw	a0,a5,-48
 480:	0006c603          	lbu	a2,0(a3)
 484:	fd06071b          	addiw	a4,a2,-48
 488:	0ff77713          	andi	a4,a4,255
 48c:	fee5f1e3          	bgeu	a1,a4,46e <atoi+0x18>
 490:	8082                	ret
 492:	4501                	li	a0,0
 494:	8082                	ret

0000000000000496 <memmove>:
 496:	02b57463          	bgeu	a0,a1,4be <memmove+0x28>
 49a:	04c05663          	blez	a2,4e6 <memmove+0x50>
 49e:	fff6079b          	addiw	a5,a2,-1
 4a2:	1782                	slli	a5,a5,0x20
 4a4:	9381                	srli	a5,a5,0x20
 4a6:	0785                	addi	a5,a5,1
 4a8:	97aa                	add	a5,a5,a0
 4aa:	872a                	mv	a4,a0
 4ac:	0585                	addi	a1,a1,1
 4ae:	0705                	addi	a4,a4,1
 4b0:	fff5c683          	lbu	a3,-1(a1)
 4b4:	fed70fa3          	sb	a3,-1(a4)
 4b8:	fee79ae3          	bne	a5,a4,4ac <memmove+0x16>
 4bc:	8082                	ret
 4be:	00c50733          	add	a4,a0,a2
 4c2:	95b2                	add	a1,a1,a2
 4c4:	02c05163          	blez	a2,4e6 <memmove+0x50>
 4c8:	fff6079b          	addiw	a5,a2,-1
 4cc:	1782                	slli	a5,a5,0x20
 4ce:	9381                	srli	a5,a5,0x20
 4d0:	fff7c793          	not	a5,a5
 4d4:	97ba                	add	a5,a5,a4
 4d6:	15fd                	addi	a1,a1,-1
 4d8:	177d                	addi	a4,a4,-1
 4da:	0005c683          	lbu	a3,0(a1)
 4de:	00d70023          	sb	a3,0(a4)
 4e2:	fee79ae3          	bne	a5,a4,4d6 <memmove+0x40>
 4e6:	8082                	ret

00000000000004e8 <memcmp>:
 4e8:	fff6069b          	addiw	a3,a2,-1
 4ec:	c605                	beqz	a2,514 <memcmp+0x2c>
 4ee:	1682                	slli	a3,a3,0x20
 4f0:	9281                	srli	a3,a3,0x20
 4f2:	0685                	addi	a3,a3,1
 4f4:	96aa                	add	a3,a3,a0
 4f6:	00054783          	lbu	a5,0(a0)
 4fa:	0005c703          	lbu	a4,0(a1)
 4fe:	00e79863          	bne	a5,a4,50e <memcmp+0x26>
 502:	0505                	addi	a0,a0,1
 504:	0585                	addi	a1,a1,1
 506:	fed518e3          	bne	a0,a3,4f6 <memcmp+0xe>
 50a:	4501                	li	a0,0
 50c:	8082                	ret
 50e:	40e7853b          	subw	a0,a5,a4
 512:	8082                	ret
 514:	4501                	li	a0,0
 516:	8082                	ret

0000000000000518 <memcpy>:
 518:	1141                	addi	sp,sp,-16
 51a:	e406                	sd	ra,8(sp)
 51c:	00000097          	auipc	ra,0x0
 520:	f7a080e7          	jalr	-134(ra) # 496 <memmove>
 524:	60a2                	ld	ra,8(sp)
 526:	0141                	addi	sp,sp,16
 528:	8082                	ret

000000000000052a <putc>:
 52a:	1101                	addi	sp,sp,-32
 52c:	ec06                	sd	ra,24(sp)
 52e:	00b107a3          	sb	a1,15(sp)
 532:	4605                	li	a2,1
 534:	00f10593          	addi	a1,sp,15
 538:	00000097          	auipc	ra,0x0
 53c:	d7c080e7          	jalr	-644(ra) # 2b4 <write>
 540:	60e2                	ld	ra,24(sp)
 542:	6105                	addi	sp,sp,32
 544:	8082                	ret

0000000000000546 <printint>:
 546:	7179                	addi	sp,sp,-48
 548:	f406                	sd	ra,40(sp)
 54a:	f022                	sd	s0,32(sp)
 54c:	ec26                	sd	s1,24(sp)
 54e:	e84a                	sd	s2,16(sp)
 550:	84aa                	mv	s1,a0
 552:	c299                	beqz	a3,558 <printint+0x12>
 554:	0805c363          	bltz	a1,5da <printint+0x94>
 558:	2581                	sext.w	a1,a1
 55a:	4881                	li	a7,0
 55c:	868a                	mv	a3,sp
 55e:	4701                	li	a4,0
 560:	2601                	sext.w	a2,a2
 562:	00000517          	auipc	a0,0x0
 566:	54e50513          	addi	a0,a0,1358 # ab0 <digits>
 56a:	883a                	mv	a6,a4
 56c:	2705                	addiw	a4,a4,1
 56e:	02c5f7bb          	remuw	a5,a1,a2
 572:	1782                	slli	a5,a5,0x20
 574:	9381                	srli	a5,a5,0x20
 576:	97aa                	add	a5,a5,a0
 578:	0007c783          	lbu	a5,0(a5)
 57c:	00f68023          	sb	a5,0(a3)
 580:	0005879b          	sext.w	a5,a1
 584:	02c5d5bb          	divuw	a1,a1,a2
 588:	0685                	addi	a3,a3,1
 58a:	fec7f0e3          	bgeu	a5,a2,56a <printint+0x24>
 58e:	00088a63          	beqz	a7,5a2 <printint+0x5c>
 592:	081c                	addi	a5,sp,16
 594:	973e                	add	a4,a4,a5
 596:	02d00793          	li	a5,45
 59a:	fef70823          	sb	a5,-16(a4)
 59e:	0028071b          	addiw	a4,a6,2
 5a2:	02e05663          	blez	a4,5ce <printint+0x88>
 5a6:	00e10433          	add	s0,sp,a4
 5aa:	fff10913          	addi	s2,sp,-1
 5ae:	993a                	add	s2,s2,a4
 5b0:	377d                	addiw	a4,a4,-1
 5b2:	1702                	slli	a4,a4,0x20
 5b4:	9301                	srli	a4,a4,0x20
 5b6:	40e90933          	sub	s2,s2,a4
 5ba:	fff44583          	lbu	a1,-1(s0)
 5be:	8526                	mv	a0,s1
 5c0:	00000097          	auipc	ra,0x0
 5c4:	f6a080e7          	jalr	-150(ra) # 52a <putc>
 5c8:	147d                	addi	s0,s0,-1
 5ca:	ff2418e3          	bne	s0,s2,5ba <printint+0x74>
 5ce:	70a2                	ld	ra,40(sp)
 5d0:	7402                	ld	s0,32(sp)
 5d2:	64e2                	ld	s1,24(sp)
 5d4:	6942                	ld	s2,16(sp)
 5d6:	6145                	addi	sp,sp,48
 5d8:	8082                	ret
 5da:	40b005bb          	negw	a1,a1
 5de:	4885                	li	a7,1
 5e0:	bfb5                	j	55c <printint+0x16>

00000000000005e2 <vprintf>:
 5e2:	7119                	addi	sp,sp,-128
 5e4:	fc86                	sd	ra,120(sp)
 5e6:	f8a2                	sd	s0,112(sp)
 5e8:	f4a6                	sd	s1,104(sp)
 5ea:	f0ca                	sd	s2,96(sp)
 5ec:	ecce                	sd	s3,88(sp)
 5ee:	e8d2                	sd	s4,80(sp)
 5f0:	e4d6                	sd	s5,72(sp)
 5f2:	e0da                	sd	s6,64(sp)
 5f4:	fc5e                	sd	s7,56(sp)
 5f6:	f862                	sd	s8,48(sp)
 5f8:	f466                	sd	s9,40(sp)
 5fa:	f06a                	sd	s10,32(sp)
 5fc:	ec6e                	sd	s11,24(sp)
 5fe:	0005c483          	lbu	s1,0(a1)
 602:	18048c63          	beqz	s1,79a <vprintf+0x1b8>
 606:	8a2a                	mv	s4,a0
 608:	8ab2                	mv	s5,a2
 60a:	00158413          	addi	s0,a1,1
 60e:	4901                	li	s2,0
 610:	02500993          	li	s3,37
 614:	06400b93          	li	s7,100
 618:	06c00c13          	li	s8,108
 61c:	07800c93          	li	s9,120
 620:	07000d13          	li	s10,112
 624:	07300d93          	li	s11,115
 628:	00000b17          	auipc	s6,0x0
 62c:	488b0b13          	addi	s6,s6,1160 # ab0 <digits>
 630:	a839                	j	64e <vprintf+0x6c>
 632:	85a6                	mv	a1,s1
 634:	8552                	mv	a0,s4
 636:	00000097          	auipc	ra,0x0
 63a:	ef4080e7          	jalr	-268(ra) # 52a <putc>
 63e:	a019                	j	644 <vprintf+0x62>
 640:	01390f63          	beq	s2,s3,65e <vprintf+0x7c>
 644:	0405                	addi	s0,s0,1
 646:	fff44483          	lbu	s1,-1(s0)
 64a:	14048863          	beqz	s1,79a <vprintf+0x1b8>
 64e:	0004879b          	sext.w	a5,s1
 652:	fe0917e3          	bnez	s2,640 <vprintf+0x5e>
 656:	fd379ee3          	bne	a5,s3,632 <vprintf+0x50>
 65a:	893e                	mv	s2,a5
 65c:	b7e5                	j	644 <vprintf+0x62>
 65e:	03778e63          	beq	a5,s7,69a <vprintf+0xb8>
 662:	05878a63          	beq	a5,s8,6b6 <vprintf+0xd4>
 666:	07978663          	beq	a5,s9,6d2 <vprintf+0xf0>
 66a:	09a78263          	beq	a5,s10,6ee <vprintf+0x10c>
 66e:	0db78363          	beq	a5,s11,734 <vprintf+0x152>
 672:	06300713          	li	a4,99
 676:	0ee78b63          	beq	a5,a4,76c <vprintf+0x18a>
 67a:	11378563          	beq	a5,s3,784 <vprintf+0x1a2>
 67e:	85ce                	mv	a1,s3
 680:	8552                	mv	a0,s4
 682:	00000097          	auipc	ra,0x0
 686:	ea8080e7          	jalr	-344(ra) # 52a <putc>
 68a:	85a6                	mv	a1,s1
 68c:	8552                	mv	a0,s4
 68e:	00000097          	auipc	ra,0x0
 692:	e9c080e7          	jalr	-356(ra) # 52a <putc>
 696:	4901                	li	s2,0
 698:	b775                	j	644 <vprintf+0x62>
 69a:	008a8493          	addi	s1,s5,8
 69e:	4685                	li	a3,1
 6a0:	4629                	li	a2,10
 6a2:	000aa583          	lw	a1,0(s5)
 6a6:	8552                	mv	a0,s4
 6a8:	00000097          	auipc	ra,0x0
 6ac:	e9e080e7          	jalr	-354(ra) # 546 <printint>
 6b0:	8aa6                	mv	s5,s1
 6b2:	4901                	li	s2,0
 6b4:	bf41                	j	644 <vprintf+0x62>
 6b6:	008a8493          	addi	s1,s5,8
 6ba:	4681                	li	a3,0
 6bc:	4629                	li	a2,10
 6be:	000aa583          	lw	a1,0(s5)
 6c2:	8552                	mv	a0,s4
 6c4:	00000097          	auipc	ra,0x0
 6c8:	e82080e7          	jalr	-382(ra) # 546 <printint>
 6cc:	8aa6                	mv	s5,s1
 6ce:	4901                	li	s2,0
 6d0:	bf95                	j	644 <vprintf+0x62>
 6d2:	008a8493          	addi	s1,s5,8
 6d6:	4681                	li	a3,0
 6d8:	4641                	li	a2,16
 6da:	000aa583          	lw	a1,0(s5)
 6de:	8552                	mv	a0,s4
 6e0:	00000097          	auipc	ra,0x0
 6e4:	e66080e7          	jalr	-410(ra) # 546 <printint>
 6e8:	8aa6                	mv	s5,s1
 6ea:	4901                	li	s2,0
 6ec:	bfa1                	j	644 <vprintf+0x62>
 6ee:	008a8793          	addi	a5,s5,8
 6f2:	e43e                	sd	a5,8(sp)
 6f4:	000ab903          	ld	s2,0(s5)
 6f8:	03000593          	li	a1,48
 6fc:	8552                	mv	a0,s4
 6fe:	00000097          	auipc	ra,0x0
 702:	e2c080e7          	jalr	-468(ra) # 52a <putc>
 706:	85e6                	mv	a1,s9
 708:	8552                	mv	a0,s4
 70a:	00000097          	auipc	ra,0x0
 70e:	e20080e7          	jalr	-480(ra) # 52a <putc>
 712:	44c1                	li	s1,16
 714:	03c95793          	srli	a5,s2,0x3c
 718:	97da                	add	a5,a5,s6
 71a:	0007c583          	lbu	a1,0(a5)
 71e:	8552                	mv	a0,s4
 720:	00000097          	auipc	ra,0x0
 724:	e0a080e7          	jalr	-502(ra) # 52a <putc>
 728:	0912                	slli	s2,s2,0x4
 72a:	34fd                	addiw	s1,s1,-1
 72c:	f4e5                	bnez	s1,714 <vprintf+0x132>
 72e:	6aa2                	ld	s5,8(sp)
 730:	4901                	li	s2,0
 732:	bf09                	j	644 <vprintf+0x62>
 734:	008a8493          	addi	s1,s5,8
 738:	000ab903          	ld	s2,0(s5)
 73c:	02090163          	beqz	s2,75e <vprintf+0x17c>
 740:	00094583          	lbu	a1,0(s2)
 744:	c9a1                	beqz	a1,794 <vprintf+0x1b2>
 746:	8552                	mv	a0,s4
 748:	00000097          	auipc	ra,0x0
 74c:	de2080e7          	jalr	-542(ra) # 52a <putc>
 750:	0905                	addi	s2,s2,1
 752:	00094583          	lbu	a1,0(s2)
 756:	f9e5                	bnez	a1,746 <vprintf+0x164>
 758:	8aa6                	mv	s5,s1
 75a:	4901                	li	s2,0
 75c:	b5e5                	j	644 <vprintf+0x62>
 75e:	00000917          	auipc	s2,0x0
 762:	34a90913          	addi	s2,s2,842 # aa8 <malloc+0x228>
 766:	02800593          	li	a1,40
 76a:	bff1                	j	746 <vprintf+0x164>
 76c:	008a8493          	addi	s1,s5,8
 770:	000ac583          	lbu	a1,0(s5)
 774:	8552                	mv	a0,s4
 776:	00000097          	auipc	ra,0x0
 77a:	db4080e7          	jalr	-588(ra) # 52a <putc>
 77e:	8aa6                	mv	s5,s1
 780:	4901                	li	s2,0
 782:	b5c9                	j	644 <vprintf+0x62>
 784:	85ce                	mv	a1,s3
 786:	8552                	mv	a0,s4
 788:	00000097          	auipc	ra,0x0
 78c:	da2080e7          	jalr	-606(ra) # 52a <putc>
 790:	4901                	li	s2,0
 792:	bd4d                	j	644 <vprintf+0x62>
 794:	8aa6                	mv	s5,s1
 796:	4901                	li	s2,0
 798:	b575                	j	644 <vprintf+0x62>
 79a:	70e6                	ld	ra,120(sp)
 79c:	7446                	ld	s0,112(sp)
 79e:	74a6                	ld	s1,104(sp)
 7a0:	7906                	ld	s2,96(sp)
 7a2:	69e6                	ld	s3,88(sp)
 7a4:	6a46                	ld	s4,80(sp)
 7a6:	6aa6                	ld	s5,72(sp)
 7a8:	6b06                	ld	s6,64(sp)
 7aa:	7be2                	ld	s7,56(sp)
 7ac:	7c42                	ld	s8,48(sp)
 7ae:	7ca2                	ld	s9,40(sp)
 7b0:	7d02                	ld	s10,32(sp)
 7b2:	6de2                	ld	s11,24(sp)
 7b4:	6109                	addi	sp,sp,128
 7b6:	8082                	ret

00000000000007b8 <fprintf>:
 7b8:	715d                	addi	sp,sp,-80
 7ba:	ec06                	sd	ra,24(sp)
 7bc:	f032                	sd	a2,32(sp)
 7be:	f436                	sd	a3,40(sp)
 7c0:	f83a                	sd	a4,48(sp)
 7c2:	fc3e                	sd	a5,56(sp)
 7c4:	e0c2                	sd	a6,64(sp)
 7c6:	e4c6                	sd	a7,72(sp)
 7c8:	1010                	addi	a2,sp,32
 7ca:	e432                	sd	a2,8(sp)
 7cc:	00000097          	auipc	ra,0x0
 7d0:	e16080e7          	jalr	-490(ra) # 5e2 <vprintf>
 7d4:	60e2                	ld	ra,24(sp)
 7d6:	6161                	addi	sp,sp,80
 7d8:	8082                	ret

00000000000007da <printf>:
 7da:	711d                	addi	sp,sp,-96
 7dc:	ec06                	sd	ra,24(sp)
 7de:	f42e                	sd	a1,40(sp)
 7e0:	f832                	sd	a2,48(sp)
 7e2:	fc36                	sd	a3,56(sp)
 7e4:	e0ba                	sd	a4,64(sp)
 7e6:	e4be                	sd	a5,72(sp)
 7e8:	e8c2                	sd	a6,80(sp)
 7ea:	ecc6                	sd	a7,88(sp)
 7ec:	1030                	addi	a2,sp,40
 7ee:	e432                	sd	a2,8(sp)
 7f0:	85aa                	mv	a1,a0
 7f2:	4505                	li	a0,1
 7f4:	00000097          	auipc	ra,0x0
 7f8:	dee080e7          	jalr	-530(ra) # 5e2 <vprintf>
 7fc:	60e2                	ld	ra,24(sp)
 7fe:	6125                	addi	sp,sp,96
 800:	8082                	ret

0000000000000802 <free>:
 802:	ff050693          	addi	a3,a0,-16
 806:	00000797          	auipc	a5,0x0
 80a:	2c27b783          	ld	a5,706(a5) # ac8 <freep>
 80e:	a805                	j	83e <free+0x3c>
 810:	4618                	lw	a4,8(a2)
 812:	9db9                	addw	a1,a1,a4
 814:	feb52c23          	sw	a1,-8(a0)
 818:	6398                	ld	a4,0(a5)
 81a:	6318                	ld	a4,0(a4)
 81c:	fee53823          	sd	a4,-16(a0)
 820:	a091                	j	864 <free+0x62>
 822:	ff852703          	lw	a4,-8(a0)
 826:	9e39                	addw	a2,a2,a4
 828:	c790                	sw	a2,8(a5)
 82a:	ff053703          	ld	a4,-16(a0)
 82e:	e398                	sd	a4,0(a5)
 830:	a099                	j	876 <free+0x74>
 832:	6398                	ld	a4,0(a5)
 834:	00e7e463          	bltu	a5,a4,83c <free+0x3a>
 838:	00e6ea63          	bltu	a3,a4,84c <free+0x4a>
 83c:	87ba                	mv	a5,a4
 83e:	fed7fae3          	bgeu	a5,a3,832 <free+0x30>
 842:	6398                	ld	a4,0(a5)
 844:	00e6e463          	bltu	a3,a4,84c <free+0x4a>
 848:	fee7eae3          	bltu	a5,a4,83c <free+0x3a>
 84c:	ff852583          	lw	a1,-8(a0)
 850:	6390                	ld	a2,0(a5)
 852:	02059713          	slli	a4,a1,0x20
 856:	9301                	srli	a4,a4,0x20
 858:	0712                	slli	a4,a4,0x4
 85a:	9736                	add	a4,a4,a3
 85c:	fae60ae3          	beq	a2,a4,810 <free+0xe>
 860:	fec53823          	sd	a2,-16(a0)
 864:	4790                	lw	a2,8(a5)
 866:	02061713          	slli	a4,a2,0x20
 86a:	9301                	srli	a4,a4,0x20
 86c:	0712                	slli	a4,a4,0x4
 86e:	973e                	add	a4,a4,a5
 870:	fae689e3          	beq	a3,a4,822 <free+0x20>
 874:	e394                	sd	a3,0(a5)
 876:	00000717          	auipc	a4,0x0
 87a:	24f73923          	sd	a5,594(a4) # ac8 <freep>
 87e:	8082                	ret

0000000000000880 <malloc>:
 880:	7139                	addi	sp,sp,-64
 882:	fc06                	sd	ra,56(sp)
 884:	f822                	sd	s0,48(sp)
 886:	f426                	sd	s1,40(sp)
 888:	f04a                	sd	s2,32(sp)
 88a:	ec4e                	sd	s3,24(sp)
 88c:	e852                	sd	s4,16(sp)
 88e:	e456                	sd	s5,8(sp)
 890:	02051413          	slli	s0,a0,0x20
 894:	9001                	srli	s0,s0,0x20
 896:	043d                	addi	s0,s0,15
 898:	8011                	srli	s0,s0,0x4
 89a:	0014091b          	addiw	s2,s0,1
 89e:	0405                	addi	s0,s0,1
 8a0:	00000517          	auipc	a0,0x0
 8a4:	22853503          	ld	a0,552(a0) # ac8 <freep>
 8a8:	c905                	beqz	a0,8d8 <malloc+0x58>
 8aa:	611c                	ld	a5,0(a0)
 8ac:	4798                	lw	a4,8(a5)
 8ae:	04877163          	bgeu	a4,s0,8f0 <malloc+0x70>
 8b2:	89ca                	mv	s3,s2
 8b4:	0009071b          	sext.w	a4,s2
 8b8:	6685                	lui	a3,0x1
 8ba:	00d77363          	bgeu	a4,a3,8c0 <malloc+0x40>
 8be:	6985                	lui	s3,0x1
 8c0:	00098a1b          	sext.w	s4,s3
 8c4:	1982                	slli	s3,s3,0x20
 8c6:	0209d993          	srli	s3,s3,0x20
 8ca:	0992                	slli	s3,s3,0x4
 8cc:	00000497          	auipc	s1,0x0
 8d0:	1fc48493          	addi	s1,s1,508 # ac8 <freep>
 8d4:	5afd                	li	s5,-1
 8d6:	a0bd                	j	944 <malloc+0xc4>
 8d8:	00000797          	auipc	a5,0x0
 8dc:	1f878793          	addi	a5,a5,504 # ad0 <base>
 8e0:	00000717          	auipc	a4,0x0
 8e4:	1ef73423          	sd	a5,488(a4) # ac8 <freep>
 8e8:	e39c                	sd	a5,0(a5)
 8ea:	0007a423          	sw	zero,8(a5)
 8ee:	b7d1                	j	8b2 <malloc+0x32>
 8f0:	02e40a63          	beq	s0,a4,924 <malloc+0xa4>
 8f4:	4127073b          	subw	a4,a4,s2
 8f8:	c798                	sw	a4,8(a5)
 8fa:	1702                	slli	a4,a4,0x20
 8fc:	9301                	srli	a4,a4,0x20
 8fe:	0712                	slli	a4,a4,0x4
 900:	97ba                	add	a5,a5,a4
 902:	0127a423          	sw	s2,8(a5)
 906:	00000717          	auipc	a4,0x0
 90a:	1ca73123          	sd	a0,450(a4) # ac8 <freep>
 90e:	01078513          	addi	a0,a5,16
 912:	70e2                	ld	ra,56(sp)
 914:	7442                	ld	s0,48(sp)
 916:	74a2                	ld	s1,40(sp)
 918:	7902                	ld	s2,32(sp)
 91a:	69e2                	ld	s3,24(sp)
 91c:	6a42                	ld	s4,16(sp)
 91e:	6aa2                	ld	s5,8(sp)
 920:	6121                	addi	sp,sp,64
 922:	8082                	ret
 924:	6398                	ld	a4,0(a5)
 926:	e118                	sd	a4,0(a0)
 928:	bff9                	j	906 <malloc+0x86>
 92a:	01452423          	sw	s4,8(a0)
 92e:	0541                	addi	a0,a0,16
 930:	00000097          	auipc	ra,0x0
 934:	ed2080e7          	jalr	-302(ra) # 802 <free>
 938:	6088                	ld	a0,0(s1)
 93a:	dd61                	beqz	a0,912 <malloc+0x92>
 93c:	611c                	ld	a5,0(a0)
 93e:	4798                	lw	a4,8(a5)
 940:	fa8778e3          	bgeu	a4,s0,8f0 <malloc+0x70>
 944:	6098                	ld	a4,0(s1)
 946:	853e                	mv	a0,a5
 948:	fef71ae3          	bne	a4,a5,93c <malloc+0xbc>
 94c:	854e                	mv	a0,s3
 94e:	00000097          	auipc	ra,0x0
 952:	8d8080e7          	jalr	-1832(ra) # 226 <sbrk>
 956:	fd551ae3          	bne	a0,s5,92a <malloc+0xaa>
 95a:	4501                	li	a0,0
 95c:	bf5d                	j	912 <malloc+0x92>
