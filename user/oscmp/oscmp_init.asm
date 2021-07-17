
_oscmp_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_success>:
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	842a                	mv	s0,a0
   a:	00001517          	auipc	a0,0x1
   e:	89e50513          	addi	a0,a0,-1890 # 8a8 <malloc+0xf6>
  12:	00000097          	auipc	ra,0x0
  16:	6fa080e7          	jalr	1786(ra) # 70c <printf>
  1a:	600c                	ld	a1,0(s0)
  1c:	cd99                	beqz	a1,3a <print_success+0x3a>
  1e:	0421                	addi	s0,s0,8
  20:	00001497          	auipc	s1,0x1
  24:	8a048493          	addi	s1,s1,-1888 # 8c0 <malloc+0x10e>
  28:	8526                	mv	a0,s1
  2a:	00000097          	auipc	ra,0x0
  2e:	6e2080e7          	jalr	1762(ra) # 70c <printf>
  32:	0421                	addi	s0,s0,8
  34:	ff843583          	ld	a1,-8(s0)
  38:	f9e5                	bnez	a1,28 <print_success+0x28>
  3a:	00001517          	auipc	a0,0x1
  3e:	88e50513          	addi	a0,a0,-1906 # 8c8 <malloc+0x116>
  42:	00000097          	auipc	ra,0x0
  46:	6ca080e7          	jalr	1738(ra) # 70c <printf>
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
  64:	0e0080e7          	jalr	224(ra) # 140 <fork>
  68:	ed09                	bnez	a0,82 <test+0x2e>
  6a:	4601                	li	a2,0
  6c:	85a2                	mv	a1,s0
  6e:	8526                	mv	a0,s1
  70:	00000097          	auipc	ra,0x0
  74:	1f8080e7          	jalr	504(ra) # 268 <execve>
  78:	70a2                	ld	ra,40(sp)
  7a:	7402                	ld	s0,32(sp)
  7c:	64e2                	ld	s1,24(sp)
  7e:	6145                	addi	sp,sp,48
  80:	8082                	ret
  82:	0068                	addi	a0,sp,12
  84:	00000097          	auipc	ra,0x0
  88:	0c4080e7          	jalr	196(ra) # 148 <wait>
  8c:	47b2                	lw	a5,12(sp)
  8e:	fe07c5e3          	bltz	a5,78 <test+0x24>
  92:	8522                	mv	a0,s0
  94:	00000097          	auipc	ra,0x0
  98:	f6c080e7          	jalr	-148(ra) # 0 <print_success>
  9c:	bff1                	j	78 <test+0x24>

000000000000009e <main>:
  9e:	715d                	addi	sp,sp,-80
  a0:	e486                	sd	ra,72(sp)
  a2:	4589                	li	a1,2
  a4:	00001517          	auipc	a0,0x1
  a8:	83450513          	addi	a0,a0,-1996 # 8d8 <malloc+0x126>
  ac:	00000097          	auipc	ra,0x0
  b0:	0a4080e7          	jalr	164(ra) # 150 <open>
  b4:	4501                	li	a0,0
  b6:	00000097          	auipc	ra,0x0
  ba:	0b2080e7          	jalr	178(ra) # 168 <dup>
  be:	4501                	li	a0,0
  c0:	00000097          	auipc	ra,0x0
  c4:	0a8080e7          	jalr	168(ra) # 168 <dup>
  c8:	00001797          	auipc	a5,0x1
  cc:	81878793          	addi	a5,a5,-2024 # 8e0 <malloc+0x12e>
  d0:	f43e                	sd	a5,40(sp)
  d2:	00001797          	auipc	a5,0x1
  d6:	81678793          	addi	a5,a5,-2026 # 8e8 <malloc+0x136>
  da:	f83e                	sd	a5,48(sp)
  dc:	fc02                	sd	zero,56(sp)
  de:	00001797          	auipc	a5,0x1
  e2:	82a78793          	addi	a5,a5,-2006 # 908 <malloc+0x156>
  e6:	e83e                	sd	a5,16(sp)
  e8:	00001797          	auipc	a5,0x1
  ec:	83078793          	addi	a5,a5,-2000 # 918 <malloc+0x166>
  f0:	ec3e                	sd	a5,24(sp)
  f2:	f002                	sd	zero,32(sp)
  f4:	00001797          	auipc	a5,0x1
  f8:	83478793          	addi	a5,a5,-1996 # 928 <malloc+0x176>
  fc:	e03e                	sd	a5,0(sp)
  fe:	e402                	sd	zero,8(sp)
 100:	102c                	addi	a1,sp,40
 102:	00001517          	auipc	a0,0x1
 106:	82e50513          	addi	a0,a0,-2002 # 930 <malloc+0x17e>
 10a:	00000097          	auipc	ra,0x0
 10e:	f4a080e7          	jalr	-182(ra) # 54 <test>
 112:	080c                	addi	a1,sp,16
 114:	00001517          	auipc	a0,0x1
 118:	81c50513          	addi	a0,a0,-2020 # 930 <malloc+0x17e>
 11c:	00000097          	auipc	ra,0x0
 120:	f38080e7          	jalr	-200(ra) # 54 <test>
 124:	858a                	mv	a1,sp
 126:	00001517          	auipc	a0,0x1
 12a:	80a50513          	addi	a0,a0,-2038 # 930 <malloc+0x17e>
 12e:	00000097          	auipc	ra,0x0
 132:	f26080e7          	jalr	-218(ra) # 54 <test>
 136:	00000097          	auipc	ra,0x0
 13a:	150080e7          	jalr	336(ra) # 286 <kernel_panic>
 13e:	a001                	j	13e <main+0xa0>

0000000000000140 <fork>:
 140:	4885                	li	a7,1
 142:	00000073          	ecall
 146:	8082                	ret

0000000000000148 <wait>:
 148:	488d                	li	a7,3
 14a:	00000073          	ecall
 14e:	8082                	ret

0000000000000150 <open>:
 150:	4889                	li	a7,2
 152:	00000073          	ecall
 156:	8082                	ret

0000000000000158 <sbrk>:
 158:	4891                	li	a7,4
 15a:	00000073          	ecall
 15e:	8082                	ret

0000000000000160 <getcwd>:
 160:	48c5                	li	a7,17
 162:	00000073          	ecall
 166:	8082                	ret

0000000000000168 <dup>:
 168:	48dd                	li	a7,23
 16a:	00000073          	ecall
 16e:	8082                	ret

0000000000000170 <dup3>:
 170:	48e1                	li	a7,24
 172:	00000073          	ecall
 176:	8082                	ret

0000000000000178 <mkdirat>:
 178:	02200893          	li	a7,34
 17c:	00000073          	ecall
 180:	8082                	ret

0000000000000182 <unlinkat>:
 182:	02300893          	li	a7,35
 186:	00000073          	ecall
 18a:	8082                	ret

000000000000018c <linkat>:
 18c:	02500893          	li	a7,37
 190:	00000073          	ecall
 194:	8082                	ret

0000000000000196 <umount2>:
 196:	02700893          	li	a7,39
 19a:	00000073          	ecall
 19e:	8082                	ret

00000000000001a0 <mount>:
 1a0:	02800893          	li	a7,40
 1a4:	00000073          	ecall
 1a8:	8082                	ret

00000000000001aa <chdir>:
 1aa:	03100893          	li	a7,49
 1ae:	00000073          	ecall
 1b2:	8082                	ret

00000000000001b4 <openat>:
 1b4:	03800893          	li	a7,56
 1b8:	00000073          	ecall
 1bc:	8082                	ret

00000000000001be <close>:
 1be:	03900893          	li	a7,57
 1c2:	00000073          	ecall
 1c6:	8082                	ret

00000000000001c8 <pipe2>:
 1c8:	03b00893          	li	a7,59
 1cc:	00000073          	ecall
 1d0:	8082                	ret

00000000000001d2 <getdents64>:
 1d2:	03d00893          	li	a7,61
 1d6:	00000073          	ecall
 1da:	8082                	ret

00000000000001dc <read>:
 1dc:	03f00893          	li	a7,63
 1e0:	00000073          	ecall
 1e4:	8082                	ret

00000000000001e6 <write>:
 1e6:	04000893          	li	a7,64
 1ea:	00000073          	ecall
 1ee:	8082                	ret

00000000000001f0 <fstat>:
 1f0:	05000893          	li	a7,80
 1f4:	00000073          	ecall
 1f8:	8082                	ret

00000000000001fa <exit>:
 1fa:	05d00893          	li	a7,93
 1fe:	00000073          	ecall
 202:	8082                	ret

0000000000000204 <nanosleep>:
 204:	06500893          	li	a7,101
 208:	00000073          	ecall
 20c:	8082                	ret

000000000000020e <sched_yield>:
 20e:	07c00893          	li	a7,124
 212:	00000073          	ecall
 216:	8082                	ret

0000000000000218 <times>:
 218:	09900893          	li	a7,153
 21c:	00000073          	ecall
 220:	8082                	ret

0000000000000222 <uname>:
 222:	0a000893          	li	a7,160
 226:	00000073          	ecall
 22a:	8082                	ret

000000000000022c <gettimeofday>:
 22c:	0a900893          	li	a7,169
 230:	00000073          	ecall
 234:	8082                	ret

0000000000000236 <brk>:
 236:	0d600893          	li	a7,214
 23a:	00000073          	ecall
 23e:	8082                	ret

0000000000000240 <munmap>:
 240:	0d700893          	li	a7,215
 244:	00000073          	ecall
 248:	8082                	ret

000000000000024a <getpid>:
 24a:	0ac00893          	li	a7,172
 24e:	00000073          	ecall
 252:	8082                	ret

0000000000000254 <getppid>:
 254:	0ad00893          	li	a7,173
 258:	00000073          	ecall
 25c:	8082                	ret

000000000000025e <clone>:
 25e:	0dc00893          	li	a7,220
 262:	00000073          	ecall
 266:	8082                	ret

0000000000000268 <execve>:
 268:	0dd00893          	li	a7,221
 26c:	00000073          	ecall
 270:	8082                	ret

0000000000000272 <mmap>:
 272:	0de00893          	li	a7,222
 276:	00000073          	ecall
 27a:	8082                	ret

000000000000027c <wait4>:
 27c:	10400893          	li	a7,260
 280:	00000073          	ecall
 284:	8082                	ret

0000000000000286 <kernel_panic>:
 286:	18f00893          	li	a7,399
 28a:	00000073          	ecall
 28e:	8082                	ret

0000000000000290 <strcpy>:
 290:	87aa                	mv	a5,a0
 292:	0585                	addi	a1,a1,1
 294:	0785                	addi	a5,a5,1
 296:	fff5c703          	lbu	a4,-1(a1)
 29a:	fee78fa3          	sb	a4,-1(a5)
 29e:	fb75                	bnez	a4,292 <strcpy+0x2>
 2a0:	8082                	ret

00000000000002a2 <strcmp>:
 2a2:	00054783          	lbu	a5,0(a0)
 2a6:	cb91                	beqz	a5,2ba <strcmp+0x18>
 2a8:	0005c703          	lbu	a4,0(a1)
 2ac:	00f71763          	bne	a4,a5,2ba <strcmp+0x18>
 2b0:	0505                	addi	a0,a0,1
 2b2:	0585                	addi	a1,a1,1
 2b4:	00054783          	lbu	a5,0(a0)
 2b8:	fbe5                	bnez	a5,2a8 <strcmp+0x6>
 2ba:	0005c503          	lbu	a0,0(a1)
 2be:	40a7853b          	subw	a0,a5,a0
 2c2:	8082                	ret

00000000000002c4 <strlen>:
 2c4:	00054783          	lbu	a5,0(a0)
 2c8:	cf81                	beqz	a5,2e0 <strlen+0x1c>
 2ca:	0505                	addi	a0,a0,1
 2cc:	87aa                	mv	a5,a0
 2ce:	4685                	li	a3,1
 2d0:	9e89                	subw	a3,a3,a0
 2d2:	00f6853b          	addw	a0,a3,a5
 2d6:	0785                	addi	a5,a5,1
 2d8:	fff7c703          	lbu	a4,-1(a5)
 2dc:	fb7d                	bnez	a4,2d2 <strlen+0xe>
 2de:	8082                	ret
 2e0:	4501                	li	a0,0
 2e2:	8082                	ret

00000000000002e4 <memset>:
 2e4:	ce09                	beqz	a2,2fe <memset+0x1a>
 2e6:	87aa                	mv	a5,a0
 2e8:	fff6071b          	addiw	a4,a2,-1
 2ec:	1702                	slli	a4,a4,0x20
 2ee:	9301                	srli	a4,a4,0x20
 2f0:	0705                	addi	a4,a4,1
 2f2:	972a                	add	a4,a4,a0
 2f4:	00b78023          	sb	a1,0(a5)
 2f8:	0785                	addi	a5,a5,1
 2fa:	fee79de3          	bne	a5,a4,2f4 <memset+0x10>
 2fe:	8082                	ret

0000000000000300 <strchr>:
 300:	00054783          	lbu	a5,0(a0)
 304:	cb89                	beqz	a5,316 <strchr+0x16>
 306:	00f58963          	beq	a1,a5,318 <strchr+0x18>
 30a:	0505                	addi	a0,a0,1
 30c:	00054783          	lbu	a5,0(a0)
 310:	fbfd                	bnez	a5,306 <strchr+0x6>
 312:	4501                	li	a0,0
 314:	8082                	ret
 316:	4501                	li	a0,0
 318:	8082                	ret

000000000000031a <gets>:
 31a:	715d                	addi	sp,sp,-80
 31c:	e486                	sd	ra,72(sp)
 31e:	e0a2                	sd	s0,64(sp)
 320:	fc26                	sd	s1,56(sp)
 322:	f84a                	sd	s2,48(sp)
 324:	f44e                	sd	s3,40(sp)
 326:	f052                	sd	s4,32(sp)
 328:	ec56                	sd	s5,24(sp)
 32a:	e85a                	sd	s6,16(sp)
 32c:	8b2a                	mv	s6,a0
 32e:	89ae                	mv	s3,a1
 330:	84aa                	mv	s1,a0
 332:	4401                	li	s0,0
 334:	4a29                	li	s4,10
 336:	4ab5                	li	s5,13
 338:	8922                	mv	s2,s0
 33a:	2405                	addiw	s0,s0,1
 33c:	03345863          	bge	s0,s3,36c <gets+0x52>
 340:	4605                	li	a2,1
 342:	00f10593          	addi	a1,sp,15
 346:	4501                	li	a0,0
 348:	00000097          	auipc	ra,0x0
 34c:	e94080e7          	jalr	-364(ra) # 1dc <read>
 350:	00a05e63          	blez	a0,36c <gets+0x52>
 354:	00f14783          	lbu	a5,15(sp)
 358:	00f48023          	sb	a5,0(s1)
 35c:	01478763          	beq	a5,s4,36a <gets+0x50>
 360:	0485                	addi	s1,s1,1
 362:	fd579be3          	bne	a5,s5,338 <gets+0x1e>
 366:	8922                	mv	s2,s0
 368:	a011                	j	36c <gets+0x52>
 36a:	8922                	mv	s2,s0
 36c:	995a                	add	s2,s2,s6
 36e:	00090023          	sb	zero,0(s2)
 372:	855a                	mv	a0,s6
 374:	60a6                	ld	ra,72(sp)
 376:	6406                	ld	s0,64(sp)
 378:	74e2                	ld	s1,56(sp)
 37a:	7942                	ld	s2,48(sp)
 37c:	79a2                	ld	s3,40(sp)
 37e:	7a02                	ld	s4,32(sp)
 380:	6ae2                	ld	s5,24(sp)
 382:	6b42                	ld	s6,16(sp)
 384:	6161                	addi	sp,sp,80
 386:	8082                	ret

0000000000000388 <atoi>:
 388:	86aa                	mv	a3,a0
 38a:	00054603          	lbu	a2,0(a0)
 38e:	fd06079b          	addiw	a5,a2,-48
 392:	0ff7f793          	andi	a5,a5,255
 396:	4725                	li	a4,9
 398:	02f76663          	bltu	a4,a5,3c4 <atoi+0x3c>
 39c:	4501                	li	a0,0
 39e:	45a5                	li	a1,9
 3a0:	0685                	addi	a3,a3,1
 3a2:	0025179b          	slliw	a5,a0,0x2
 3a6:	9fa9                	addw	a5,a5,a0
 3a8:	0017979b          	slliw	a5,a5,0x1
 3ac:	9fb1                	addw	a5,a5,a2
 3ae:	fd07851b          	addiw	a0,a5,-48
 3b2:	0006c603          	lbu	a2,0(a3)
 3b6:	fd06071b          	addiw	a4,a2,-48
 3ba:	0ff77713          	andi	a4,a4,255
 3be:	fee5f1e3          	bgeu	a1,a4,3a0 <atoi+0x18>
 3c2:	8082                	ret
 3c4:	4501                	li	a0,0
 3c6:	8082                	ret

00000000000003c8 <memmove>:
 3c8:	02b57463          	bgeu	a0,a1,3f0 <memmove+0x28>
 3cc:	04c05663          	blez	a2,418 <memmove+0x50>
 3d0:	fff6079b          	addiw	a5,a2,-1
 3d4:	1782                	slli	a5,a5,0x20
 3d6:	9381                	srli	a5,a5,0x20
 3d8:	0785                	addi	a5,a5,1
 3da:	97aa                	add	a5,a5,a0
 3dc:	872a                	mv	a4,a0
 3de:	0585                	addi	a1,a1,1
 3e0:	0705                	addi	a4,a4,1
 3e2:	fff5c683          	lbu	a3,-1(a1)
 3e6:	fed70fa3          	sb	a3,-1(a4)
 3ea:	fee79ae3          	bne	a5,a4,3de <memmove+0x16>
 3ee:	8082                	ret
 3f0:	00c50733          	add	a4,a0,a2
 3f4:	95b2                	add	a1,a1,a2
 3f6:	02c05163          	blez	a2,418 <memmove+0x50>
 3fa:	fff6079b          	addiw	a5,a2,-1
 3fe:	1782                	slli	a5,a5,0x20
 400:	9381                	srli	a5,a5,0x20
 402:	fff7c793          	not	a5,a5
 406:	97ba                	add	a5,a5,a4
 408:	15fd                	addi	a1,a1,-1
 40a:	177d                	addi	a4,a4,-1
 40c:	0005c683          	lbu	a3,0(a1)
 410:	00d70023          	sb	a3,0(a4)
 414:	fee79ae3          	bne	a5,a4,408 <memmove+0x40>
 418:	8082                	ret

000000000000041a <memcmp>:
 41a:	fff6069b          	addiw	a3,a2,-1
 41e:	c605                	beqz	a2,446 <memcmp+0x2c>
 420:	1682                	slli	a3,a3,0x20
 422:	9281                	srli	a3,a3,0x20
 424:	0685                	addi	a3,a3,1
 426:	96aa                	add	a3,a3,a0
 428:	00054783          	lbu	a5,0(a0)
 42c:	0005c703          	lbu	a4,0(a1)
 430:	00e79863          	bne	a5,a4,440 <memcmp+0x26>
 434:	0505                	addi	a0,a0,1
 436:	0585                	addi	a1,a1,1
 438:	fed518e3          	bne	a0,a3,428 <memcmp+0xe>
 43c:	4501                	li	a0,0
 43e:	8082                	ret
 440:	40e7853b          	subw	a0,a5,a4
 444:	8082                	ret
 446:	4501                	li	a0,0
 448:	8082                	ret

000000000000044a <memcpy>:
 44a:	1141                	addi	sp,sp,-16
 44c:	e406                	sd	ra,8(sp)
 44e:	00000097          	auipc	ra,0x0
 452:	f7a080e7          	jalr	-134(ra) # 3c8 <memmove>
 456:	60a2                	ld	ra,8(sp)
 458:	0141                	addi	sp,sp,16
 45a:	8082                	ret

000000000000045c <putc>:
 45c:	1101                	addi	sp,sp,-32
 45e:	ec06                	sd	ra,24(sp)
 460:	00b107a3          	sb	a1,15(sp)
 464:	4605                	li	a2,1
 466:	00f10593          	addi	a1,sp,15
 46a:	00000097          	auipc	ra,0x0
 46e:	d7c080e7          	jalr	-644(ra) # 1e6 <write>
 472:	60e2                	ld	ra,24(sp)
 474:	6105                	addi	sp,sp,32
 476:	8082                	ret

0000000000000478 <printint>:
 478:	7179                	addi	sp,sp,-48
 47a:	f406                	sd	ra,40(sp)
 47c:	f022                	sd	s0,32(sp)
 47e:	ec26                	sd	s1,24(sp)
 480:	e84a                	sd	s2,16(sp)
 482:	84aa                	mv	s1,a0
 484:	c299                	beqz	a3,48a <printint+0x12>
 486:	0805c363          	bltz	a1,50c <printint+0x94>
 48a:	2581                	sext.w	a1,a1
 48c:	4881                	li	a7,0
 48e:	868a                	mv	a3,sp
 490:	4701                	li	a4,0
 492:	2601                	sext.w	a2,a2
 494:	00000517          	auipc	a0,0x0
 498:	4ac50513          	addi	a0,a0,1196 # 940 <digits>
 49c:	883a                	mv	a6,a4
 49e:	2705                	addiw	a4,a4,1
 4a0:	02c5f7bb          	remuw	a5,a1,a2
 4a4:	1782                	slli	a5,a5,0x20
 4a6:	9381                	srli	a5,a5,0x20
 4a8:	97aa                	add	a5,a5,a0
 4aa:	0007c783          	lbu	a5,0(a5)
 4ae:	00f68023          	sb	a5,0(a3)
 4b2:	0005879b          	sext.w	a5,a1
 4b6:	02c5d5bb          	divuw	a1,a1,a2
 4ba:	0685                	addi	a3,a3,1
 4bc:	fec7f0e3          	bgeu	a5,a2,49c <printint+0x24>
 4c0:	00088a63          	beqz	a7,4d4 <printint+0x5c>
 4c4:	081c                	addi	a5,sp,16
 4c6:	973e                	add	a4,a4,a5
 4c8:	02d00793          	li	a5,45
 4cc:	fef70823          	sb	a5,-16(a4)
 4d0:	0028071b          	addiw	a4,a6,2
 4d4:	02e05663          	blez	a4,500 <printint+0x88>
 4d8:	00e10433          	add	s0,sp,a4
 4dc:	fff10913          	addi	s2,sp,-1
 4e0:	993a                	add	s2,s2,a4
 4e2:	377d                	addiw	a4,a4,-1
 4e4:	1702                	slli	a4,a4,0x20
 4e6:	9301                	srli	a4,a4,0x20
 4e8:	40e90933          	sub	s2,s2,a4
 4ec:	fff44583          	lbu	a1,-1(s0)
 4f0:	8526                	mv	a0,s1
 4f2:	00000097          	auipc	ra,0x0
 4f6:	f6a080e7          	jalr	-150(ra) # 45c <putc>
 4fa:	147d                	addi	s0,s0,-1
 4fc:	ff2418e3          	bne	s0,s2,4ec <printint+0x74>
 500:	70a2                	ld	ra,40(sp)
 502:	7402                	ld	s0,32(sp)
 504:	64e2                	ld	s1,24(sp)
 506:	6942                	ld	s2,16(sp)
 508:	6145                	addi	sp,sp,48
 50a:	8082                	ret
 50c:	40b005bb          	negw	a1,a1
 510:	4885                	li	a7,1
 512:	bfb5                	j	48e <printint+0x16>

0000000000000514 <vprintf>:
 514:	7119                	addi	sp,sp,-128
 516:	fc86                	sd	ra,120(sp)
 518:	f8a2                	sd	s0,112(sp)
 51a:	f4a6                	sd	s1,104(sp)
 51c:	f0ca                	sd	s2,96(sp)
 51e:	ecce                	sd	s3,88(sp)
 520:	e8d2                	sd	s4,80(sp)
 522:	e4d6                	sd	s5,72(sp)
 524:	e0da                	sd	s6,64(sp)
 526:	fc5e                	sd	s7,56(sp)
 528:	f862                	sd	s8,48(sp)
 52a:	f466                	sd	s9,40(sp)
 52c:	f06a                	sd	s10,32(sp)
 52e:	ec6e                	sd	s11,24(sp)
 530:	0005c483          	lbu	s1,0(a1)
 534:	18048c63          	beqz	s1,6cc <vprintf+0x1b8>
 538:	8a2a                	mv	s4,a0
 53a:	8ab2                	mv	s5,a2
 53c:	00158413          	addi	s0,a1,1
 540:	4901                	li	s2,0
 542:	02500993          	li	s3,37
 546:	06400b93          	li	s7,100
 54a:	06c00c13          	li	s8,108
 54e:	07800c93          	li	s9,120
 552:	07000d13          	li	s10,112
 556:	07300d93          	li	s11,115
 55a:	00000b17          	auipc	s6,0x0
 55e:	3e6b0b13          	addi	s6,s6,998 # 940 <digits>
 562:	a839                	j	580 <vprintf+0x6c>
 564:	85a6                	mv	a1,s1
 566:	8552                	mv	a0,s4
 568:	00000097          	auipc	ra,0x0
 56c:	ef4080e7          	jalr	-268(ra) # 45c <putc>
 570:	a019                	j	576 <vprintf+0x62>
 572:	01390f63          	beq	s2,s3,590 <vprintf+0x7c>
 576:	0405                	addi	s0,s0,1
 578:	fff44483          	lbu	s1,-1(s0)
 57c:	14048863          	beqz	s1,6cc <vprintf+0x1b8>
 580:	0004879b          	sext.w	a5,s1
 584:	fe0917e3          	bnez	s2,572 <vprintf+0x5e>
 588:	fd379ee3          	bne	a5,s3,564 <vprintf+0x50>
 58c:	893e                	mv	s2,a5
 58e:	b7e5                	j	576 <vprintf+0x62>
 590:	03778e63          	beq	a5,s7,5cc <vprintf+0xb8>
 594:	05878a63          	beq	a5,s8,5e8 <vprintf+0xd4>
 598:	07978663          	beq	a5,s9,604 <vprintf+0xf0>
 59c:	09a78263          	beq	a5,s10,620 <vprintf+0x10c>
 5a0:	0db78363          	beq	a5,s11,666 <vprintf+0x152>
 5a4:	06300713          	li	a4,99
 5a8:	0ee78b63          	beq	a5,a4,69e <vprintf+0x18a>
 5ac:	11378563          	beq	a5,s3,6b6 <vprintf+0x1a2>
 5b0:	85ce                	mv	a1,s3
 5b2:	8552                	mv	a0,s4
 5b4:	00000097          	auipc	ra,0x0
 5b8:	ea8080e7          	jalr	-344(ra) # 45c <putc>
 5bc:	85a6                	mv	a1,s1
 5be:	8552                	mv	a0,s4
 5c0:	00000097          	auipc	ra,0x0
 5c4:	e9c080e7          	jalr	-356(ra) # 45c <putc>
 5c8:	4901                	li	s2,0
 5ca:	b775                	j	576 <vprintf+0x62>
 5cc:	008a8493          	addi	s1,s5,8
 5d0:	4685                	li	a3,1
 5d2:	4629                	li	a2,10
 5d4:	000aa583          	lw	a1,0(s5)
 5d8:	8552                	mv	a0,s4
 5da:	00000097          	auipc	ra,0x0
 5de:	e9e080e7          	jalr	-354(ra) # 478 <printint>
 5e2:	8aa6                	mv	s5,s1
 5e4:	4901                	li	s2,0
 5e6:	bf41                	j	576 <vprintf+0x62>
 5e8:	008a8493          	addi	s1,s5,8
 5ec:	4681                	li	a3,0
 5ee:	4629                	li	a2,10
 5f0:	000aa583          	lw	a1,0(s5)
 5f4:	8552                	mv	a0,s4
 5f6:	00000097          	auipc	ra,0x0
 5fa:	e82080e7          	jalr	-382(ra) # 478 <printint>
 5fe:	8aa6                	mv	s5,s1
 600:	4901                	li	s2,0
 602:	bf95                	j	576 <vprintf+0x62>
 604:	008a8493          	addi	s1,s5,8
 608:	4681                	li	a3,0
 60a:	4641                	li	a2,16
 60c:	000aa583          	lw	a1,0(s5)
 610:	8552                	mv	a0,s4
 612:	00000097          	auipc	ra,0x0
 616:	e66080e7          	jalr	-410(ra) # 478 <printint>
 61a:	8aa6                	mv	s5,s1
 61c:	4901                	li	s2,0
 61e:	bfa1                	j	576 <vprintf+0x62>
 620:	008a8793          	addi	a5,s5,8
 624:	e43e                	sd	a5,8(sp)
 626:	000ab903          	ld	s2,0(s5)
 62a:	03000593          	li	a1,48
 62e:	8552                	mv	a0,s4
 630:	00000097          	auipc	ra,0x0
 634:	e2c080e7          	jalr	-468(ra) # 45c <putc>
 638:	85e6                	mv	a1,s9
 63a:	8552                	mv	a0,s4
 63c:	00000097          	auipc	ra,0x0
 640:	e20080e7          	jalr	-480(ra) # 45c <putc>
 644:	44c1                	li	s1,16
 646:	03c95793          	srli	a5,s2,0x3c
 64a:	97da                	add	a5,a5,s6
 64c:	0007c583          	lbu	a1,0(a5)
 650:	8552                	mv	a0,s4
 652:	00000097          	auipc	ra,0x0
 656:	e0a080e7          	jalr	-502(ra) # 45c <putc>
 65a:	0912                	slli	s2,s2,0x4
 65c:	34fd                	addiw	s1,s1,-1
 65e:	f4e5                	bnez	s1,646 <vprintf+0x132>
 660:	6aa2                	ld	s5,8(sp)
 662:	4901                	li	s2,0
 664:	bf09                	j	576 <vprintf+0x62>
 666:	008a8493          	addi	s1,s5,8
 66a:	000ab903          	ld	s2,0(s5)
 66e:	02090163          	beqz	s2,690 <vprintf+0x17c>
 672:	00094583          	lbu	a1,0(s2)
 676:	c9a1                	beqz	a1,6c6 <vprintf+0x1b2>
 678:	8552                	mv	a0,s4
 67a:	00000097          	auipc	ra,0x0
 67e:	de2080e7          	jalr	-542(ra) # 45c <putc>
 682:	0905                	addi	s2,s2,1
 684:	00094583          	lbu	a1,0(s2)
 688:	f9e5                	bnez	a1,678 <vprintf+0x164>
 68a:	8aa6                	mv	s5,s1
 68c:	4901                	li	s2,0
 68e:	b5e5                	j	576 <vprintf+0x62>
 690:	00000917          	auipc	s2,0x0
 694:	2a890913          	addi	s2,s2,680 # 938 <malloc+0x186>
 698:	02800593          	li	a1,40
 69c:	bff1                	j	678 <vprintf+0x164>
 69e:	008a8493          	addi	s1,s5,8
 6a2:	000ac583          	lbu	a1,0(s5)
 6a6:	8552                	mv	a0,s4
 6a8:	00000097          	auipc	ra,0x0
 6ac:	db4080e7          	jalr	-588(ra) # 45c <putc>
 6b0:	8aa6                	mv	s5,s1
 6b2:	4901                	li	s2,0
 6b4:	b5c9                	j	576 <vprintf+0x62>
 6b6:	85ce                	mv	a1,s3
 6b8:	8552                	mv	a0,s4
 6ba:	00000097          	auipc	ra,0x0
 6be:	da2080e7          	jalr	-606(ra) # 45c <putc>
 6c2:	4901                	li	s2,0
 6c4:	bd4d                	j	576 <vprintf+0x62>
 6c6:	8aa6                	mv	s5,s1
 6c8:	4901                	li	s2,0
 6ca:	b575                	j	576 <vprintf+0x62>
 6cc:	70e6                	ld	ra,120(sp)
 6ce:	7446                	ld	s0,112(sp)
 6d0:	74a6                	ld	s1,104(sp)
 6d2:	7906                	ld	s2,96(sp)
 6d4:	69e6                	ld	s3,88(sp)
 6d6:	6a46                	ld	s4,80(sp)
 6d8:	6aa6                	ld	s5,72(sp)
 6da:	6b06                	ld	s6,64(sp)
 6dc:	7be2                	ld	s7,56(sp)
 6de:	7c42                	ld	s8,48(sp)
 6e0:	7ca2                	ld	s9,40(sp)
 6e2:	7d02                	ld	s10,32(sp)
 6e4:	6de2                	ld	s11,24(sp)
 6e6:	6109                	addi	sp,sp,128
 6e8:	8082                	ret

00000000000006ea <fprintf>:
 6ea:	715d                	addi	sp,sp,-80
 6ec:	ec06                	sd	ra,24(sp)
 6ee:	f032                	sd	a2,32(sp)
 6f0:	f436                	sd	a3,40(sp)
 6f2:	f83a                	sd	a4,48(sp)
 6f4:	fc3e                	sd	a5,56(sp)
 6f6:	e0c2                	sd	a6,64(sp)
 6f8:	e4c6                	sd	a7,72(sp)
 6fa:	1010                	addi	a2,sp,32
 6fc:	e432                	sd	a2,8(sp)
 6fe:	00000097          	auipc	ra,0x0
 702:	e16080e7          	jalr	-490(ra) # 514 <vprintf>
 706:	60e2                	ld	ra,24(sp)
 708:	6161                	addi	sp,sp,80
 70a:	8082                	ret

000000000000070c <printf>:
 70c:	711d                	addi	sp,sp,-96
 70e:	ec06                	sd	ra,24(sp)
 710:	f42e                	sd	a1,40(sp)
 712:	f832                	sd	a2,48(sp)
 714:	fc36                	sd	a3,56(sp)
 716:	e0ba                	sd	a4,64(sp)
 718:	e4be                	sd	a5,72(sp)
 71a:	e8c2                	sd	a6,80(sp)
 71c:	ecc6                	sd	a7,88(sp)
 71e:	1030                	addi	a2,sp,40
 720:	e432                	sd	a2,8(sp)
 722:	85aa                	mv	a1,a0
 724:	4505                	li	a0,1
 726:	00000097          	auipc	ra,0x0
 72a:	dee080e7          	jalr	-530(ra) # 514 <vprintf>
 72e:	60e2                	ld	ra,24(sp)
 730:	6125                	addi	sp,sp,96
 732:	8082                	ret

0000000000000734 <free>:
 734:	ff050693          	addi	a3,a0,-16
 738:	00000797          	auipc	a5,0x0
 73c:	2207b783          	ld	a5,544(a5) # 958 <freep>
 740:	a805                	j	770 <free+0x3c>
 742:	4618                	lw	a4,8(a2)
 744:	9db9                	addw	a1,a1,a4
 746:	feb52c23          	sw	a1,-8(a0)
 74a:	6398                	ld	a4,0(a5)
 74c:	6318                	ld	a4,0(a4)
 74e:	fee53823          	sd	a4,-16(a0)
 752:	a091                	j	796 <free+0x62>
 754:	ff852703          	lw	a4,-8(a0)
 758:	9e39                	addw	a2,a2,a4
 75a:	c790                	sw	a2,8(a5)
 75c:	ff053703          	ld	a4,-16(a0)
 760:	e398                	sd	a4,0(a5)
 762:	a099                	j	7a8 <free+0x74>
 764:	6398                	ld	a4,0(a5)
 766:	00e7e463          	bltu	a5,a4,76e <free+0x3a>
 76a:	00e6ea63          	bltu	a3,a4,77e <free+0x4a>
 76e:	87ba                	mv	a5,a4
 770:	fed7fae3          	bgeu	a5,a3,764 <free+0x30>
 774:	6398                	ld	a4,0(a5)
 776:	00e6e463          	bltu	a3,a4,77e <free+0x4a>
 77a:	fee7eae3          	bltu	a5,a4,76e <free+0x3a>
 77e:	ff852583          	lw	a1,-8(a0)
 782:	6390                	ld	a2,0(a5)
 784:	02059713          	slli	a4,a1,0x20
 788:	9301                	srli	a4,a4,0x20
 78a:	0712                	slli	a4,a4,0x4
 78c:	9736                	add	a4,a4,a3
 78e:	fae60ae3          	beq	a2,a4,742 <free+0xe>
 792:	fec53823          	sd	a2,-16(a0)
 796:	4790                	lw	a2,8(a5)
 798:	02061713          	slli	a4,a2,0x20
 79c:	9301                	srli	a4,a4,0x20
 79e:	0712                	slli	a4,a4,0x4
 7a0:	973e                	add	a4,a4,a5
 7a2:	fae689e3          	beq	a3,a4,754 <free+0x20>
 7a6:	e394                	sd	a3,0(a5)
 7a8:	00000717          	auipc	a4,0x0
 7ac:	1af73823          	sd	a5,432(a4) # 958 <freep>
 7b0:	8082                	ret

00000000000007b2 <malloc>:
 7b2:	7139                	addi	sp,sp,-64
 7b4:	fc06                	sd	ra,56(sp)
 7b6:	f822                	sd	s0,48(sp)
 7b8:	f426                	sd	s1,40(sp)
 7ba:	f04a                	sd	s2,32(sp)
 7bc:	ec4e                	sd	s3,24(sp)
 7be:	e852                	sd	s4,16(sp)
 7c0:	e456                	sd	s5,8(sp)
 7c2:	02051413          	slli	s0,a0,0x20
 7c6:	9001                	srli	s0,s0,0x20
 7c8:	043d                	addi	s0,s0,15
 7ca:	8011                	srli	s0,s0,0x4
 7cc:	0014091b          	addiw	s2,s0,1
 7d0:	0405                	addi	s0,s0,1
 7d2:	00000517          	auipc	a0,0x0
 7d6:	18653503          	ld	a0,390(a0) # 958 <freep>
 7da:	c905                	beqz	a0,80a <malloc+0x58>
 7dc:	611c                	ld	a5,0(a0)
 7de:	4798                	lw	a4,8(a5)
 7e0:	04877163          	bgeu	a4,s0,822 <malloc+0x70>
 7e4:	89ca                	mv	s3,s2
 7e6:	0009071b          	sext.w	a4,s2
 7ea:	6685                	lui	a3,0x1
 7ec:	00d77363          	bgeu	a4,a3,7f2 <malloc+0x40>
 7f0:	6985                	lui	s3,0x1
 7f2:	00098a1b          	sext.w	s4,s3
 7f6:	1982                	slli	s3,s3,0x20
 7f8:	0209d993          	srli	s3,s3,0x20
 7fc:	0992                	slli	s3,s3,0x4
 7fe:	00000497          	auipc	s1,0x0
 802:	15a48493          	addi	s1,s1,346 # 958 <freep>
 806:	5afd                	li	s5,-1
 808:	a0bd                	j	876 <malloc+0xc4>
 80a:	00000797          	auipc	a5,0x0
 80e:	15678793          	addi	a5,a5,342 # 960 <base>
 812:	00000717          	auipc	a4,0x0
 816:	14f73323          	sd	a5,326(a4) # 958 <freep>
 81a:	e39c                	sd	a5,0(a5)
 81c:	0007a423          	sw	zero,8(a5)
 820:	b7d1                	j	7e4 <malloc+0x32>
 822:	02e40a63          	beq	s0,a4,856 <malloc+0xa4>
 826:	4127073b          	subw	a4,a4,s2
 82a:	c798                	sw	a4,8(a5)
 82c:	1702                	slli	a4,a4,0x20
 82e:	9301                	srli	a4,a4,0x20
 830:	0712                	slli	a4,a4,0x4
 832:	97ba                	add	a5,a5,a4
 834:	0127a423          	sw	s2,8(a5)
 838:	00000717          	auipc	a4,0x0
 83c:	12a73023          	sd	a0,288(a4) # 958 <freep>
 840:	01078513          	addi	a0,a5,16
 844:	70e2                	ld	ra,56(sp)
 846:	7442                	ld	s0,48(sp)
 848:	74a2                	ld	s1,40(sp)
 84a:	7902                	ld	s2,32(sp)
 84c:	69e2                	ld	s3,24(sp)
 84e:	6a42                	ld	s4,16(sp)
 850:	6aa2                	ld	s5,8(sp)
 852:	6121                	addi	sp,sp,64
 854:	8082                	ret
 856:	6398                	ld	a4,0(a5)
 858:	e118                	sd	a4,0(a0)
 85a:	bff9                	j	838 <malloc+0x86>
 85c:	01452423          	sw	s4,8(a0)
 860:	0541                	addi	a0,a0,16
 862:	00000097          	auipc	ra,0x0
 866:	ed2080e7          	jalr	-302(ra) # 734 <free>
 86a:	6088                	ld	a0,0(s1)
 86c:	dd61                	beqz	a0,844 <malloc+0x92>
 86e:	611c                	ld	a5,0(a0)
 870:	4798                	lw	a4,8(a5)
 872:	fa8778e3          	bgeu	a4,s0,822 <malloc+0x70>
 876:	6098                	ld	a4,0(s1)
 878:	853e                	mv	a0,a5
 87a:	fef71ae3          	bne	a4,a5,86e <malloc+0xbc>
 87e:	854e                	mv	a0,s3
 880:	00000097          	auipc	ra,0x0
 884:	8d8080e7          	jalr	-1832(ra) # 158 <sbrk>
 888:	fd551ae3          	bne	a0,s5,85c <malloc+0xaa>
 88c:	4501                	li	a0,0
 88e:	bf5d                	j	844 <malloc+0x92>
