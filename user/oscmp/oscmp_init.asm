
_oscmp_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_success>:
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	842a                	mv	s0,a0
   a:	00001517          	auipc	a0,0x1
   e:	8fe50513          	addi	a0,a0,-1794 # 908 <malloc+0xfc>
  12:	00000097          	auipc	ra,0x0
  16:	754080e7          	jalr	1876(ra) # 766 <printf>
  1a:	600c                	ld	a1,0(s0)
  1c:	cd99                	beqz	a1,3a <print_success+0x3a>
  1e:	0421                	addi	s0,s0,8
  20:	00001497          	auipc	s1,0x1
  24:	90048493          	addi	s1,s1,-1792 # 920 <malloc+0x114>
  28:	8526                	mv	a0,s1
  2a:	00000097          	auipc	ra,0x0
  2e:	73c080e7          	jalr	1852(ra) # 766 <printf>
  32:	0421                	addi	s0,s0,8
  34:	ff843583          	ld	a1,-8(s0)
  38:	f9e5                	bnez	a1,28 <print_success+0x28>
  3a:	00001517          	auipc	a0,0x1
  3e:	8ee50513          	addi	a0,a0,-1810 # 928 <malloc+0x11c>
  42:	00000097          	auipc	ra,0x0
  46:	724080e7          	jalr	1828(ra) # 766 <printf>
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
  64:	144080e7          	jalr	324(ra) # 1a4 <fork>
  68:	ed09                	bnez	a0,82 <test+0x2e>
  6a:	4601                	li	a2,0
  6c:	85a2                	mv	a1,s0
  6e:	8526                	mv	a0,s1
  70:	00000097          	auipc	ra,0x0
  74:	25c080e7          	jalr	604(ra) # 2cc <execve>
  78:	70a2                	ld	ra,40(sp)
  7a:	7402                	ld	s0,32(sp)
  7c:	64e2                	ld	s1,24(sp)
  7e:	6145                	addi	sp,sp,48
  80:	8082                	ret
  82:	0068                	addi	a0,sp,12
  84:	00000097          	auipc	ra,0x0
  88:	128080e7          	jalr	296(ra) # 1ac <wait>
  8c:	47b2                	lw	a5,12(sp)
  8e:	fe07c5e3          	bltz	a5,78 <test+0x24>
  92:	8522                	mv	a0,s0
  94:	00000097          	auipc	ra,0x0
  98:	f6c080e7          	jalr	-148(ra) # 0 <print_success>
  9c:	bff1                	j	78 <test+0x24>

000000000000009e <main>:
  9e:	7135                	addi	sp,sp,-160
  a0:	ed06                	sd	ra,152(sp)
  a2:	4589                	li	a1,2
  a4:	00001517          	auipc	a0,0x1
  a8:	89450513          	addi	a0,a0,-1900 # 938 <malloc+0x12c>
  ac:	00000097          	auipc	ra,0x0
  b0:	108080e7          	jalr	264(ra) # 1b4 <open>
  b4:	4501                	li	a0,0
  b6:	00000097          	auipc	ra,0x0
  ba:	116080e7          	jalr	278(ra) # 1cc <dup>
  be:	4501                	li	a0,0
  c0:	00000097          	auipc	ra,0x0
  c4:	10c080e7          	jalr	268(ra) # 1cc <dup>
  c8:	00001797          	auipc	a5,0x1
  cc:	87878793          	addi	a5,a5,-1928 # 940 <malloc+0x134>
  d0:	fcbe                	sd	a5,120(sp)
  d2:	00001797          	auipc	a5,0x1
  d6:	87678793          	addi	a5,a5,-1930 # 948 <malloc+0x13c>
  da:	e13e                	sd	a5,128(sp)
  dc:	e502                	sd	zero,136(sp)
  de:	00001797          	auipc	a5,0x1
  e2:	88a78793          	addi	a5,a5,-1910 # 968 <malloc+0x15c>
  e6:	f0be                	sd	a5,96(sp)
  e8:	00001797          	auipc	a5,0x1
  ec:	89078793          	addi	a5,a5,-1904 # 978 <malloc+0x16c>
  f0:	f4be                	sd	a5,104(sp)
  f2:	f882                	sd	zero,112(sp)
  f4:	00001717          	auipc	a4,0x1
  f8:	89470713          	addi	a4,a4,-1900 # 988 <malloc+0x17c>
  fc:	e8ba                	sd	a4,80(sp)
  fe:	ec82                	sd	zero,88(sp)
 100:	00001717          	auipc	a4,0x1
 104:	89070713          	addi	a4,a4,-1904 # 990 <malloc+0x184>
 108:	e0ba                	sd	a4,64(sp)
 10a:	e482                	sd	zero,72(sp)
 10c:	00001717          	auipc	a4,0x1
 110:	88c70713          	addi	a4,a4,-1908 # 998 <malloc+0x18c>
 114:	f43a                	sd	a4,40(sp)
 116:	f83e                	sd	a5,48(sp)
 118:	fc02                	sd	zero,56(sp)
 11a:	00001797          	auipc	a5,0x1
 11e:	88e78793          	addi	a5,a5,-1906 # 9a8 <malloc+0x19c>
 122:	638c                	ld	a1,0(a5)
 124:	6790                	ld	a2,8(a5)
 126:	6b94                	ld	a3,16(a5)
 128:	6f98                	ld	a4,24(a5)
 12a:	739c                	ld	a5,32(a5)
 12c:	e02e                	sd	a1,0(sp)
 12e:	e432                	sd	a2,8(sp)
 130:	e836                	sd	a3,16(sp)
 132:	ec3a                	sd	a4,24(sp)
 134:	f03e                	sd	a5,32(sp)
 136:	18ac                	addi	a1,sp,120
 138:	00001517          	auipc	a0,0x1
 13c:	86850513          	addi	a0,a0,-1944 # 9a0 <malloc+0x194>
 140:	00000097          	auipc	ra,0x0
 144:	f14080e7          	jalr	-236(ra) # 54 <test>
 148:	108c                	addi	a1,sp,96
 14a:	00001517          	auipc	a0,0x1
 14e:	85650513          	addi	a0,a0,-1962 # 9a0 <malloc+0x194>
 152:	00000097          	auipc	ra,0x0
 156:	f02080e7          	jalr	-254(ra) # 54 <test>
 15a:	088c                	addi	a1,sp,80
 15c:	00001517          	auipc	a0,0x1
 160:	84450513          	addi	a0,a0,-1980 # 9a0 <malloc+0x194>
 164:	00000097          	auipc	ra,0x0
 168:	ef0080e7          	jalr	-272(ra) # 54 <test>
 16c:	008c                	addi	a1,sp,64
 16e:	00001517          	auipc	a0,0x1
 172:	83250513          	addi	a0,a0,-1998 # 9a0 <malloc+0x194>
 176:	00000097          	auipc	ra,0x0
 17a:	ede080e7          	jalr	-290(ra) # 54 <test>
 17e:	102c                	addi	a1,sp,40
 180:	00001517          	auipc	a0,0x1
 184:	82050513          	addi	a0,a0,-2016 # 9a0 <malloc+0x194>
 188:	00000097          	auipc	ra,0x0
 18c:	ecc080e7          	jalr	-308(ra) # 54 <test>
 190:	858a                	mv	a1,sp
 192:	00001517          	auipc	a0,0x1
 196:	80e50513          	addi	a0,a0,-2034 # 9a0 <malloc+0x194>
 19a:	00000097          	auipc	ra,0x0
 19e:	eba080e7          	jalr	-326(ra) # 54 <test>
 1a2:	a001                	j	1a2 <main+0x104>

00000000000001a4 <fork>:
 1a4:	4885                	li	a7,1
 1a6:	00000073          	ecall
 1aa:	8082                	ret

00000000000001ac <wait>:
 1ac:	488d                	li	a7,3
 1ae:	00000073          	ecall
 1b2:	8082                	ret

00000000000001b4 <open>:
 1b4:	4889                	li	a7,2
 1b6:	00000073          	ecall
 1ba:	8082                	ret

00000000000001bc <sbrk>:
 1bc:	4891                	li	a7,4
 1be:	00000073          	ecall
 1c2:	8082                	ret

00000000000001c4 <getcwd>:
 1c4:	48c5                	li	a7,17
 1c6:	00000073          	ecall
 1ca:	8082                	ret

00000000000001cc <dup>:
 1cc:	48dd                	li	a7,23
 1ce:	00000073          	ecall
 1d2:	8082                	ret

00000000000001d4 <dup3>:
 1d4:	48e1                	li	a7,24
 1d6:	00000073          	ecall
 1da:	8082                	ret

00000000000001dc <mkdirat>:
 1dc:	02200893          	li	a7,34
 1e0:	00000073          	ecall
 1e4:	8082                	ret

00000000000001e6 <unlinkat>:
 1e6:	02300893          	li	a7,35
 1ea:	00000073          	ecall
 1ee:	8082                	ret

00000000000001f0 <linkat>:
 1f0:	02500893          	li	a7,37
 1f4:	00000073          	ecall
 1f8:	8082                	ret

00000000000001fa <umount2>:
 1fa:	02700893          	li	a7,39
 1fe:	00000073          	ecall
 202:	8082                	ret

0000000000000204 <mount>:
 204:	02800893          	li	a7,40
 208:	00000073          	ecall
 20c:	8082                	ret

000000000000020e <chdir>:
 20e:	03100893          	li	a7,49
 212:	00000073          	ecall
 216:	8082                	ret

0000000000000218 <openat>:
 218:	03800893          	li	a7,56
 21c:	00000073          	ecall
 220:	8082                	ret

0000000000000222 <close>:
 222:	03900893          	li	a7,57
 226:	00000073          	ecall
 22a:	8082                	ret

000000000000022c <pipe2>:
 22c:	03b00893          	li	a7,59
 230:	00000073          	ecall
 234:	8082                	ret

0000000000000236 <getdents64>:
 236:	03d00893          	li	a7,61
 23a:	00000073          	ecall
 23e:	8082                	ret

0000000000000240 <read>:
 240:	03f00893          	li	a7,63
 244:	00000073          	ecall
 248:	8082                	ret

000000000000024a <write>:
 24a:	04000893          	li	a7,64
 24e:	00000073          	ecall
 252:	8082                	ret

0000000000000254 <fstat>:
 254:	05000893          	li	a7,80
 258:	00000073          	ecall
 25c:	8082                	ret

000000000000025e <exit>:
 25e:	05d00893          	li	a7,93
 262:	00000073          	ecall
 266:	8082                	ret

0000000000000268 <nanosleep>:
 268:	06500893          	li	a7,101
 26c:	00000073          	ecall
 270:	8082                	ret

0000000000000272 <sched_yield>:
 272:	07c00893          	li	a7,124
 276:	00000073          	ecall
 27a:	8082                	ret

000000000000027c <times>:
 27c:	09900893          	li	a7,153
 280:	00000073          	ecall
 284:	8082                	ret

0000000000000286 <uname>:
 286:	0a000893          	li	a7,160
 28a:	00000073          	ecall
 28e:	8082                	ret

0000000000000290 <gettimeofday>:
 290:	0a900893          	li	a7,169
 294:	00000073          	ecall
 298:	8082                	ret

000000000000029a <brk>:
 29a:	0d600893          	li	a7,214
 29e:	00000073          	ecall
 2a2:	8082                	ret

00000000000002a4 <munmap>:
 2a4:	0d700893          	li	a7,215
 2a8:	00000073          	ecall
 2ac:	8082                	ret

00000000000002ae <getpid>:
 2ae:	0ac00893          	li	a7,172
 2b2:	00000073          	ecall
 2b6:	8082                	ret

00000000000002b8 <getppid>:
 2b8:	0ad00893          	li	a7,173
 2bc:	00000073          	ecall
 2c0:	8082                	ret

00000000000002c2 <clone>:
 2c2:	0dc00893          	li	a7,220
 2c6:	00000073          	ecall
 2ca:	8082                	ret

00000000000002cc <execve>:
 2cc:	0dd00893          	li	a7,221
 2d0:	00000073          	ecall
 2d4:	8082                	ret

00000000000002d6 <mmap>:
 2d6:	0de00893          	li	a7,222
 2da:	00000073          	ecall
 2de:	8082                	ret

00000000000002e0 <wait4>:
 2e0:	10400893          	li	a7,260
 2e4:	00000073          	ecall
 2e8:	8082                	ret

00000000000002ea <strcpy>:
 2ea:	87aa                	mv	a5,a0
 2ec:	0585                	addi	a1,a1,1
 2ee:	0785                	addi	a5,a5,1
 2f0:	fff5c703          	lbu	a4,-1(a1)
 2f4:	fee78fa3          	sb	a4,-1(a5)
 2f8:	fb75                	bnez	a4,2ec <strcpy+0x2>
 2fa:	8082                	ret

00000000000002fc <strcmp>:
 2fc:	00054783          	lbu	a5,0(a0)
 300:	cb91                	beqz	a5,314 <strcmp+0x18>
 302:	0005c703          	lbu	a4,0(a1)
 306:	00f71763          	bne	a4,a5,314 <strcmp+0x18>
 30a:	0505                	addi	a0,a0,1
 30c:	0585                	addi	a1,a1,1
 30e:	00054783          	lbu	a5,0(a0)
 312:	fbe5                	bnez	a5,302 <strcmp+0x6>
 314:	0005c503          	lbu	a0,0(a1)
 318:	40a7853b          	subw	a0,a5,a0
 31c:	8082                	ret

000000000000031e <strlen>:
 31e:	00054783          	lbu	a5,0(a0)
 322:	cf81                	beqz	a5,33a <strlen+0x1c>
 324:	0505                	addi	a0,a0,1
 326:	87aa                	mv	a5,a0
 328:	4685                	li	a3,1
 32a:	9e89                	subw	a3,a3,a0
 32c:	00f6853b          	addw	a0,a3,a5
 330:	0785                	addi	a5,a5,1
 332:	fff7c703          	lbu	a4,-1(a5)
 336:	fb7d                	bnez	a4,32c <strlen+0xe>
 338:	8082                	ret
 33a:	4501                	li	a0,0
 33c:	8082                	ret

000000000000033e <memset>:
 33e:	ce09                	beqz	a2,358 <memset+0x1a>
 340:	87aa                	mv	a5,a0
 342:	fff6071b          	addiw	a4,a2,-1
 346:	1702                	slli	a4,a4,0x20
 348:	9301                	srli	a4,a4,0x20
 34a:	0705                	addi	a4,a4,1
 34c:	972a                	add	a4,a4,a0
 34e:	00b78023          	sb	a1,0(a5)
 352:	0785                	addi	a5,a5,1
 354:	fee79de3          	bne	a5,a4,34e <memset+0x10>
 358:	8082                	ret

000000000000035a <strchr>:
 35a:	00054783          	lbu	a5,0(a0)
 35e:	cb89                	beqz	a5,370 <strchr+0x16>
 360:	00f58963          	beq	a1,a5,372 <strchr+0x18>
 364:	0505                	addi	a0,a0,1
 366:	00054783          	lbu	a5,0(a0)
 36a:	fbfd                	bnez	a5,360 <strchr+0x6>
 36c:	4501                	li	a0,0
 36e:	8082                	ret
 370:	4501                	li	a0,0
 372:	8082                	ret

0000000000000374 <gets>:
 374:	715d                	addi	sp,sp,-80
 376:	e486                	sd	ra,72(sp)
 378:	e0a2                	sd	s0,64(sp)
 37a:	fc26                	sd	s1,56(sp)
 37c:	f84a                	sd	s2,48(sp)
 37e:	f44e                	sd	s3,40(sp)
 380:	f052                	sd	s4,32(sp)
 382:	ec56                	sd	s5,24(sp)
 384:	e85a                	sd	s6,16(sp)
 386:	8b2a                	mv	s6,a0
 388:	89ae                	mv	s3,a1
 38a:	84aa                	mv	s1,a0
 38c:	4401                	li	s0,0
 38e:	4a29                	li	s4,10
 390:	4ab5                	li	s5,13
 392:	8922                	mv	s2,s0
 394:	2405                	addiw	s0,s0,1
 396:	03345863          	bge	s0,s3,3c6 <gets+0x52>
 39a:	4605                	li	a2,1
 39c:	00f10593          	addi	a1,sp,15
 3a0:	4501                	li	a0,0
 3a2:	00000097          	auipc	ra,0x0
 3a6:	e9e080e7          	jalr	-354(ra) # 240 <read>
 3aa:	00a05e63          	blez	a0,3c6 <gets+0x52>
 3ae:	00f14783          	lbu	a5,15(sp)
 3b2:	00f48023          	sb	a5,0(s1)
 3b6:	01478763          	beq	a5,s4,3c4 <gets+0x50>
 3ba:	0485                	addi	s1,s1,1
 3bc:	fd579be3          	bne	a5,s5,392 <gets+0x1e>
 3c0:	8922                	mv	s2,s0
 3c2:	a011                	j	3c6 <gets+0x52>
 3c4:	8922                	mv	s2,s0
 3c6:	995a                	add	s2,s2,s6
 3c8:	00090023          	sb	zero,0(s2)
 3cc:	855a                	mv	a0,s6
 3ce:	60a6                	ld	ra,72(sp)
 3d0:	6406                	ld	s0,64(sp)
 3d2:	74e2                	ld	s1,56(sp)
 3d4:	7942                	ld	s2,48(sp)
 3d6:	79a2                	ld	s3,40(sp)
 3d8:	7a02                	ld	s4,32(sp)
 3da:	6ae2                	ld	s5,24(sp)
 3dc:	6b42                	ld	s6,16(sp)
 3de:	6161                	addi	sp,sp,80
 3e0:	8082                	ret

00000000000003e2 <atoi>:
 3e2:	86aa                	mv	a3,a0
 3e4:	00054603          	lbu	a2,0(a0)
 3e8:	fd06079b          	addiw	a5,a2,-48
 3ec:	0ff7f793          	andi	a5,a5,255
 3f0:	4725                	li	a4,9
 3f2:	02f76663          	bltu	a4,a5,41e <atoi+0x3c>
 3f6:	4501                	li	a0,0
 3f8:	45a5                	li	a1,9
 3fa:	0685                	addi	a3,a3,1
 3fc:	0025179b          	slliw	a5,a0,0x2
 400:	9fa9                	addw	a5,a5,a0
 402:	0017979b          	slliw	a5,a5,0x1
 406:	9fb1                	addw	a5,a5,a2
 408:	fd07851b          	addiw	a0,a5,-48
 40c:	0006c603          	lbu	a2,0(a3)
 410:	fd06071b          	addiw	a4,a2,-48
 414:	0ff77713          	andi	a4,a4,255
 418:	fee5f1e3          	bgeu	a1,a4,3fa <atoi+0x18>
 41c:	8082                	ret
 41e:	4501                	li	a0,0
 420:	8082                	ret

0000000000000422 <memmove>:
 422:	02b57463          	bgeu	a0,a1,44a <memmove+0x28>
 426:	04c05663          	blez	a2,472 <memmove+0x50>
 42a:	fff6079b          	addiw	a5,a2,-1
 42e:	1782                	slli	a5,a5,0x20
 430:	9381                	srli	a5,a5,0x20
 432:	0785                	addi	a5,a5,1
 434:	97aa                	add	a5,a5,a0
 436:	872a                	mv	a4,a0
 438:	0585                	addi	a1,a1,1
 43a:	0705                	addi	a4,a4,1
 43c:	fff5c683          	lbu	a3,-1(a1)
 440:	fed70fa3          	sb	a3,-1(a4)
 444:	fee79ae3          	bne	a5,a4,438 <memmove+0x16>
 448:	8082                	ret
 44a:	00c50733          	add	a4,a0,a2
 44e:	95b2                	add	a1,a1,a2
 450:	02c05163          	blez	a2,472 <memmove+0x50>
 454:	fff6079b          	addiw	a5,a2,-1
 458:	1782                	slli	a5,a5,0x20
 45a:	9381                	srli	a5,a5,0x20
 45c:	fff7c793          	not	a5,a5
 460:	97ba                	add	a5,a5,a4
 462:	15fd                	addi	a1,a1,-1
 464:	177d                	addi	a4,a4,-1
 466:	0005c683          	lbu	a3,0(a1)
 46a:	00d70023          	sb	a3,0(a4)
 46e:	fee79ae3          	bne	a5,a4,462 <memmove+0x40>
 472:	8082                	ret

0000000000000474 <memcmp>:
 474:	fff6069b          	addiw	a3,a2,-1
 478:	c605                	beqz	a2,4a0 <memcmp+0x2c>
 47a:	1682                	slli	a3,a3,0x20
 47c:	9281                	srli	a3,a3,0x20
 47e:	0685                	addi	a3,a3,1
 480:	96aa                	add	a3,a3,a0
 482:	00054783          	lbu	a5,0(a0)
 486:	0005c703          	lbu	a4,0(a1)
 48a:	00e79863          	bne	a5,a4,49a <memcmp+0x26>
 48e:	0505                	addi	a0,a0,1
 490:	0585                	addi	a1,a1,1
 492:	fed518e3          	bne	a0,a3,482 <memcmp+0xe>
 496:	4501                	li	a0,0
 498:	8082                	ret
 49a:	40e7853b          	subw	a0,a5,a4
 49e:	8082                	ret
 4a0:	4501                	li	a0,0
 4a2:	8082                	ret

00000000000004a4 <memcpy>:
 4a4:	1141                	addi	sp,sp,-16
 4a6:	e406                	sd	ra,8(sp)
 4a8:	00000097          	auipc	ra,0x0
 4ac:	f7a080e7          	jalr	-134(ra) # 422 <memmove>
 4b0:	60a2                	ld	ra,8(sp)
 4b2:	0141                	addi	sp,sp,16
 4b4:	8082                	ret

00000000000004b6 <putc>:
 4b6:	1101                	addi	sp,sp,-32
 4b8:	ec06                	sd	ra,24(sp)
 4ba:	00b107a3          	sb	a1,15(sp)
 4be:	4605                	li	a2,1
 4c0:	00f10593          	addi	a1,sp,15
 4c4:	00000097          	auipc	ra,0x0
 4c8:	d86080e7          	jalr	-634(ra) # 24a <write>
 4cc:	60e2                	ld	ra,24(sp)
 4ce:	6105                	addi	sp,sp,32
 4d0:	8082                	ret

00000000000004d2 <printint>:
 4d2:	7179                	addi	sp,sp,-48
 4d4:	f406                	sd	ra,40(sp)
 4d6:	f022                	sd	s0,32(sp)
 4d8:	ec26                	sd	s1,24(sp)
 4da:	e84a                	sd	s2,16(sp)
 4dc:	84aa                	mv	s1,a0
 4de:	c299                	beqz	a3,4e4 <printint+0x12>
 4e0:	0805c363          	bltz	a1,566 <printint+0x94>
 4e4:	2581                	sext.w	a1,a1
 4e6:	4881                	li	a7,0
 4e8:	868a                	mv	a3,sp
 4ea:	4701                	li	a4,0
 4ec:	2601                	sext.w	a2,a2
 4ee:	00000517          	auipc	a0,0x0
 4f2:	4ea50513          	addi	a0,a0,1258 # 9d8 <digits>
 4f6:	883a                	mv	a6,a4
 4f8:	2705                	addiw	a4,a4,1
 4fa:	02c5f7bb          	remuw	a5,a1,a2
 4fe:	1782                	slli	a5,a5,0x20
 500:	9381                	srli	a5,a5,0x20
 502:	97aa                	add	a5,a5,a0
 504:	0007c783          	lbu	a5,0(a5)
 508:	00f68023          	sb	a5,0(a3)
 50c:	0005879b          	sext.w	a5,a1
 510:	02c5d5bb          	divuw	a1,a1,a2
 514:	0685                	addi	a3,a3,1
 516:	fec7f0e3          	bgeu	a5,a2,4f6 <printint+0x24>
 51a:	00088a63          	beqz	a7,52e <printint+0x5c>
 51e:	081c                	addi	a5,sp,16
 520:	973e                	add	a4,a4,a5
 522:	02d00793          	li	a5,45
 526:	fef70823          	sb	a5,-16(a4)
 52a:	0028071b          	addiw	a4,a6,2
 52e:	02e05663          	blez	a4,55a <printint+0x88>
 532:	00e10433          	add	s0,sp,a4
 536:	fff10913          	addi	s2,sp,-1
 53a:	993a                	add	s2,s2,a4
 53c:	377d                	addiw	a4,a4,-1
 53e:	1702                	slli	a4,a4,0x20
 540:	9301                	srli	a4,a4,0x20
 542:	40e90933          	sub	s2,s2,a4
 546:	fff44583          	lbu	a1,-1(s0)
 54a:	8526                	mv	a0,s1
 54c:	00000097          	auipc	ra,0x0
 550:	f6a080e7          	jalr	-150(ra) # 4b6 <putc>
 554:	147d                	addi	s0,s0,-1
 556:	ff2418e3          	bne	s0,s2,546 <printint+0x74>
 55a:	70a2                	ld	ra,40(sp)
 55c:	7402                	ld	s0,32(sp)
 55e:	64e2                	ld	s1,24(sp)
 560:	6942                	ld	s2,16(sp)
 562:	6145                	addi	sp,sp,48
 564:	8082                	ret
 566:	40b005bb          	negw	a1,a1
 56a:	4885                	li	a7,1
 56c:	bfb5                	j	4e8 <printint+0x16>

000000000000056e <vprintf>:
 56e:	7119                	addi	sp,sp,-128
 570:	fc86                	sd	ra,120(sp)
 572:	f8a2                	sd	s0,112(sp)
 574:	f4a6                	sd	s1,104(sp)
 576:	f0ca                	sd	s2,96(sp)
 578:	ecce                	sd	s3,88(sp)
 57a:	e8d2                	sd	s4,80(sp)
 57c:	e4d6                	sd	s5,72(sp)
 57e:	e0da                	sd	s6,64(sp)
 580:	fc5e                	sd	s7,56(sp)
 582:	f862                	sd	s8,48(sp)
 584:	f466                	sd	s9,40(sp)
 586:	f06a                	sd	s10,32(sp)
 588:	ec6e                	sd	s11,24(sp)
 58a:	0005c483          	lbu	s1,0(a1)
 58e:	18048c63          	beqz	s1,726 <vprintf+0x1b8>
 592:	8a2a                	mv	s4,a0
 594:	8ab2                	mv	s5,a2
 596:	00158413          	addi	s0,a1,1
 59a:	4901                	li	s2,0
 59c:	02500993          	li	s3,37
 5a0:	06400b93          	li	s7,100
 5a4:	06c00c13          	li	s8,108
 5a8:	07800c93          	li	s9,120
 5ac:	07000d13          	li	s10,112
 5b0:	07300d93          	li	s11,115
 5b4:	00000b17          	auipc	s6,0x0
 5b8:	424b0b13          	addi	s6,s6,1060 # 9d8 <digits>
 5bc:	a839                	j	5da <vprintf+0x6c>
 5be:	85a6                	mv	a1,s1
 5c0:	8552                	mv	a0,s4
 5c2:	00000097          	auipc	ra,0x0
 5c6:	ef4080e7          	jalr	-268(ra) # 4b6 <putc>
 5ca:	a019                	j	5d0 <vprintf+0x62>
 5cc:	01390f63          	beq	s2,s3,5ea <vprintf+0x7c>
 5d0:	0405                	addi	s0,s0,1
 5d2:	fff44483          	lbu	s1,-1(s0)
 5d6:	14048863          	beqz	s1,726 <vprintf+0x1b8>
 5da:	0004879b          	sext.w	a5,s1
 5de:	fe0917e3          	bnez	s2,5cc <vprintf+0x5e>
 5e2:	fd379ee3          	bne	a5,s3,5be <vprintf+0x50>
 5e6:	893e                	mv	s2,a5
 5e8:	b7e5                	j	5d0 <vprintf+0x62>
 5ea:	03778e63          	beq	a5,s7,626 <vprintf+0xb8>
 5ee:	05878a63          	beq	a5,s8,642 <vprintf+0xd4>
 5f2:	07978663          	beq	a5,s9,65e <vprintf+0xf0>
 5f6:	09a78263          	beq	a5,s10,67a <vprintf+0x10c>
 5fa:	0db78363          	beq	a5,s11,6c0 <vprintf+0x152>
 5fe:	06300713          	li	a4,99
 602:	0ee78b63          	beq	a5,a4,6f8 <vprintf+0x18a>
 606:	11378563          	beq	a5,s3,710 <vprintf+0x1a2>
 60a:	85ce                	mv	a1,s3
 60c:	8552                	mv	a0,s4
 60e:	00000097          	auipc	ra,0x0
 612:	ea8080e7          	jalr	-344(ra) # 4b6 <putc>
 616:	85a6                	mv	a1,s1
 618:	8552                	mv	a0,s4
 61a:	00000097          	auipc	ra,0x0
 61e:	e9c080e7          	jalr	-356(ra) # 4b6 <putc>
 622:	4901                	li	s2,0
 624:	b775                	j	5d0 <vprintf+0x62>
 626:	008a8493          	addi	s1,s5,8
 62a:	4685                	li	a3,1
 62c:	4629                	li	a2,10
 62e:	000aa583          	lw	a1,0(s5)
 632:	8552                	mv	a0,s4
 634:	00000097          	auipc	ra,0x0
 638:	e9e080e7          	jalr	-354(ra) # 4d2 <printint>
 63c:	8aa6                	mv	s5,s1
 63e:	4901                	li	s2,0
 640:	bf41                	j	5d0 <vprintf+0x62>
 642:	008a8493          	addi	s1,s5,8
 646:	4681                	li	a3,0
 648:	4629                	li	a2,10
 64a:	000aa583          	lw	a1,0(s5)
 64e:	8552                	mv	a0,s4
 650:	00000097          	auipc	ra,0x0
 654:	e82080e7          	jalr	-382(ra) # 4d2 <printint>
 658:	8aa6                	mv	s5,s1
 65a:	4901                	li	s2,0
 65c:	bf95                	j	5d0 <vprintf+0x62>
 65e:	008a8493          	addi	s1,s5,8
 662:	4681                	li	a3,0
 664:	4641                	li	a2,16
 666:	000aa583          	lw	a1,0(s5)
 66a:	8552                	mv	a0,s4
 66c:	00000097          	auipc	ra,0x0
 670:	e66080e7          	jalr	-410(ra) # 4d2 <printint>
 674:	8aa6                	mv	s5,s1
 676:	4901                	li	s2,0
 678:	bfa1                	j	5d0 <vprintf+0x62>
 67a:	008a8793          	addi	a5,s5,8
 67e:	e43e                	sd	a5,8(sp)
 680:	000ab903          	ld	s2,0(s5)
 684:	03000593          	li	a1,48
 688:	8552                	mv	a0,s4
 68a:	00000097          	auipc	ra,0x0
 68e:	e2c080e7          	jalr	-468(ra) # 4b6 <putc>
 692:	85e6                	mv	a1,s9
 694:	8552                	mv	a0,s4
 696:	00000097          	auipc	ra,0x0
 69a:	e20080e7          	jalr	-480(ra) # 4b6 <putc>
 69e:	44c1                	li	s1,16
 6a0:	03c95793          	srli	a5,s2,0x3c
 6a4:	97da                	add	a5,a5,s6
 6a6:	0007c583          	lbu	a1,0(a5)
 6aa:	8552                	mv	a0,s4
 6ac:	00000097          	auipc	ra,0x0
 6b0:	e0a080e7          	jalr	-502(ra) # 4b6 <putc>
 6b4:	0912                	slli	s2,s2,0x4
 6b6:	34fd                	addiw	s1,s1,-1
 6b8:	f4e5                	bnez	s1,6a0 <vprintf+0x132>
 6ba:	6aa2                	ld	s5,8(sp)
 6bc:	4901                	li	s2,0
 6be:	bf09                	j	5d0 <vprintf+0x62>
 6c0:	008a8493          	addi	s1,s5,8
 6c4:	000ab903          	ld	s2,0(s5)
 6c8:	02090163          	beqz	s2,6ea <vprintf+0x17c>
 6cc:	00094583          	lbu	a1,0(s2)
 6d0:	c9a1                	beqz	a1,720 <vprintf+0x1b2>
 6d2:	8552                	mv	a0,s4
 6d4:	00000097          	auipc	ra,0x0
 6d8:	de2080e7          	jalr	-542(ra) # 4b6 <putc>
 6dc:	0905                	addi	s2,s2,1
 6de:	00094583          	lbu	a1,0(s2)
 6e2:	f9e5                	bnez	a1,6d2 <vprintf+0x164>
 6e4:	8aa6                	mv	s5,s1
 6e6:	4901                	li	s2,0
 6e8:	b5e5                	j	5d0 <vprintf+0x62>
 6ea:	00000917          	auipc	s2,0x0
 6ee:	2e690913          	addi	s2,s2,742 # 9d0 <malloc+0x1c4>
 6f2:	02800593          	li	a1,40
 6f6:	bff1                	j	6d2 <vprintf+0x164>
 6f8:	008a8493          	addi	s1,s5,8
 6fc:	000ac583          	lbu	a1,0(s5)
 700:	8552                	mv	a0,s4
 702:	00000097          	auipc	ra,0x0
 706:	db4080e7          	jalr	-588(ra) # 4b6 <putc>
 70a:	8aa6                	mv	s5,s1
 70c:	4901                	li	s2,0
 70e:	b5c9                	j	5d0 <vprintf+0x62>
 710:	85ce                	mv	a1,s3
 712:	8552                	mv	a0,s4
 714:	00000097          	auipc	ra,0x0
 718:	da2080e7          	jalr	-606(ra) # 4b6 <putc>
 71c:	4901                	li	s2,0
 71e:	bd4d                	j	5d0 <vprintf+0x62>
 720:	8aa6                	mv	s5,s1
 722:	4901                	li	s2,0
 724:	b575                	j	5d0 <vprintf+0x62>
 726:	70e6                	ld	ra,120(sp)
 728:	7446                	ld	s0,112(sp)
 72a:	74a6                	ld	s1,104(sp)
 72c:	7906                	ld	s2,96(sp)
 72e:	69e6                	ld	s3,88(sp)
 730:	6a46                	ld	s4,80(sp)
 732:	6aa6                	ld	s5,72(sp)
 734:	6b06                	ld	s6,64(sp)
 736:	7be2                	ld	s7,56(sp)
 738:	7c42                	ld	s8,48(sp)
 73a:	7ca2                	ld	s9,40(sp)
 73c:	7d02                	ld	s10,32(sp)
 73e:	6de2                	ld	s11,24(sp)
 740:	6109                	addi	sp,sp,128
 742:	8082                	ret

0000000000000744 <fprintf>:
 744:	715d                	addi	sp,sp,-80
 746:	ec06                	sd	ra,24(sp)
 748:	f032                	sd	a2,32(sp)
 74a:	f436                	sd	a3,40(sp)
 74c:	f83a                	sd	a4,48(sp)
 74e:	fc3e                	sd	a5,56(sp)
 750:	e0c2                	sd	a6,64(sp)
 752:	e4c6                	sd	a7,72(sp)
 754:	1010                	addi	a2,sp,32
 756:	e432                	sd	a2,8(sp)
 758:	00000097          	auipc	ra,0x0
 75c:	e16080e7          	jalr	-490(ra) # 56e <vprintf>
 760:	60e2                	ld	ra,24(sp)
 762:	6161                	addi	sp,sp,80
 764:	8082                	ret

0000000000000766 <printf>:
 766:	711d                	addi	sp,sp,-96
 768:	ec06                	sd	ra,24(sp)
 76a:	f42e                	sd	a1,40(sp)
 76c:	f832                	sd	a2,48(sp)
 76e:	fc36                	sd	a3,56(sp)
 770:	e0ba                	sd	a4,64(sp)
 772:	e4be                	sd	a5,72(sp)
 774:	e8c2                	sd	a6,80(sp)
 776:	ecc6                	sd	a7,88(sp)
 778:	1030                	addi	a2,sp,40
 77a:	e432                	sd	a2,8(sp)
 77c:	85aa                	mv	a1,a0
 77e:	4505                	li	a0,1
 780:	00000097          	auipc	ra,0x0
 784:	dee080e7          	jalr	-530(ra) # 56e <vprintf>
 788:	60e2                	ld	ra,24(sp)
 78a:	6125                	addi	sp,sp,96
 78c:	8082                	ret

000000000000078e <free>:
 78e:	ff050693          	addi	a3,a0,-16
 792:	00000797          	auipc	a5,0x0
 796:	25e7b783          	ld	a5,606(a5) # 9f0 <freep>
 79a:	a805                	j	7ca <free+0x3c>
 79c:	4618                	lw	a4,8(a2)
 79e:	9db9                	addw	a1,a1,a4
 7a0:	feb52c23          	sw	a1,-8(a0)
 7a4:	6398                	ld	a4,0(a5)
 7a6:	6318                	ld	a4,0(a4)
 7a8:	fee53823          	sd	a4,-16(a0)
 7ac:	a091                	j	7f0 <free+0x62>
 7ae:	ff852703          	lw	a4,-8(a0)
 7b2:	9e39                	addw	a2,a2,a4
 7b4:	c790                	sw	a2,8(a5)
 7b6:	ff053703          	ld	a4,-16(a0)
 7ba:	e398                	sd	a4,0(a5)
 7bc:	a099                	j	802 <free+0x74>
 7be:	6398                	ld	a4,0(a5)
 7c0:	00e7e463          	bltu	a5,a4,7c8 <free+0x3a>
 7c4:	00e6ea63          	bltu	a3,a4,7d8 <free+0x4a>
 7c8:	87ba                	mv	a5,a4
 7ca:	fed7fae3          	bgeu	a5,a3,7be <free+0x30>
 7ce:	6398                	ld	a4,0(a5)
 7d0:	00e6e463          	bltu	a3,a4,7d8 <free+0x4a>
 7d4:	fee7eae3          	bltu	a5,a4,7c8 <free+0x3a>
 7d8:	ff852583          	lw	a1,-8(a0)
 7dc:	6390                	ld	a2,0(a5)
 7de:	02059713          	slli	a4,a1,0x20
 7e2:	9301                	srli	a4,a4,0x20
 7e4:	0712                	slli	a4,a4,0x4
 7e6:	9736                	add	a4,a4,a3
 7e8:	fae60ae3          	beq	a2,a4,79c <free+0xe>
 7ec:	fec53823          	sd	a2,-16(a0)
 7f0:	4790                	lw	a2,8(a5)
 7f2:	02061713          	slli	a4,a2,0x20
 7f6:	9301                	srli	a4,a4,0x20
 7f8:	0712                	slli	a4,a4,0x4
 7fa:	973e                	add	a4,a4,a5
 7fc:	fae689e3          	beq	a3,a4,7ae <free+0x20>
 800:	e394                	sd	a3,0(a5)
 802:	00000717          	auipc	a4,0x0
 806:	1ef73723          	sd	a5,494(a4) # 9f0 <freep>
 80a:	8082                	ret

000000000000080c <malloc>:
 80c:	7139                	addi	sp,sp,-64
 80e:	fc06                	sd	ra,56(sp)
 810:	f822                	sd	s0,48(sp)
 812:	f426                	sd	s1,40(sp)
 814:	f04a                	sd	s2,32(sp)
 816:	ec4e                	sd	s3,24(sp)
 818:	e852                	sd	s4,16(sp)
 81a:	e456                	sd	s5,8(sp)
 81c:	02051413          	slli	s0,a0,0x20
 820:	9001                	srli	s0,s0,0x20
 822:	043d                	addi	s0,s0,15
 824:	8011                	srli	s0,s0,0x4
 826:	0014091b          	addiw	s2,s0,1
 82a:	0405                	addi	s0,s0,1
 82c:	00000517          	auipc	a0,0x0
 830:	1c453503          	ld	a0,452(a0) # 9f0 <freep>
 834:	c905                	beqz	a0,864 <malloc+0x58>
 836:	611c                	ld	a5,0(a0)
 838:	4798                	lw	a4,8(a5)
 83a:	04877163          	bgeu	a4,s0,87c <malloc+0x70>
 83e:	89ca                	mv	s3,s2
 840:	0009071b          	sext.w	a4,s2
 844:	6685                	lui	a3,0x1
 846:	00d77363          	bgeu	a4,a3,84c <malloc+0x40>
 84a:	6985                	lui	s3,0x1
 84c:	00098a1b          	sext.w	s4,s3
 850:	1982                	slli	s3,s3,0x20
 852:	0209d993          	srli	s3,s3,0x20
 856:	0992                	slli	s3,s3,0x4
 858:	00000497          	auipc	s1,0x0
 85c:	19848493          	addi	s1,s1,408 # 9f0 <freep>
 860:	5afd                	li	s5,-1
 862:	a0bd                	j	8d0 <malloc+0xc4>
 864:	00000797          	auipc	a5,0x0
 868:	19478793          	addi	a5,a5,404 # 9f8 <base>
 86c:	00000717          	auipc	a4,0x0
 870:	18f73223          	sd	a5,388(a4) # 9f0 <freep>
 874:	e39c                	sd	a5,0(a5)
 876:	0007a423          	sw	zero,8(a5)
 87a:	b7d1                	j	83e <malloc+0x32>
 87c:	02e40a63          	beq	s0,a4,8b0 <malloc+0xa4>
 880:	4127073b          	subw	a4,a4,s2
 884:	c798                	sw	a4,8(a5)
 886:	1702                	slli	a4,a4,0x20
 888:	9301                	srli	a4,a4,0x20
 88a:	0712                	slli	a4,a4,0x4
 88c:	97ba                	add	a5,a5,a4
 88e:	0127a423          	sw	s2,8(a5)
 892:	00000717          	auipc	a4,0x0
 896:	14a73f23          	sd	a0,350(a4) # 9f0 <freep>
 89a:	01078513          	addi	a0,a5,16
 89e:	70e2                	ld	ra,56(sp)
 8a0:	7442                	ld	s0,48(sp)
 8a2:	74a2                	ld	s1,40(sp)
 8a4:	7902                	ld	s2,32(sp)
 8a6:	69e2                	ld	s3,24(sp)
 8a8:	6a42                	ld	s4,16(sp)
 8aa:	6aa2                	ld	s5,8(sp)
 8ac:	6121                	addi	sp,sp,64
 8ae:	8082                	ret
 8b0:	6398                	ld	a4,0(a5)
 8b2:	e118                	sd	a4,0(a0)
 8b4:	bff9                	j	892 <malloc+0x86>
 8b6:	01452423          	sw	s4,8(a0)
 8ba:	0541                	addi	a0,a0,16
 8bc:	00000097          	auipc	ra,0x0
 8c0:	ed2080e7          	jalr	-302(ra) # 78e <free>
 8c4:	6088                	ld	a0,0(s1)
 8c6:	dd61                	beqz	a0,89e <malloc+0x92>
 8c8:	611c                	ld	a5,0(a0)
 8ca:	4798                	lw	a4,8(a5)
 8cc:	fa8778e3          	bgeu	a4,s0,87c <malloc+0x70>
 8d0:	6098                	ld	a4,0(s1)
 8d2:	853e                	mv	a0,a5
 8d4:	fef71ae3          	bne	a4,a5,8c8 <malloc+0xbc>
 8d8:	854e                	mv	a0,s3
 8da:	00000097          	auipc	ra,0x0
 8de:	8e2080e7          	jalr	-1822(ra) # 1bc <sbrk>
 8e2:	fd551ae3          	bne	a0,s5,8b6 <malloc+0xaa>
 8e6:	4501                	li	a0,0
 8e8:	bf5d                	j	89e <malloc+0x92>
