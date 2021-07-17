
_oscmp_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_success>:
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	842a                	mv	s0,a0
   a:	00001517          	auipc	a0,0x1
   e:	8ae50513          	addi	a0,a0,-1874 # 8b8 <malloc+0xfa>
  12:	00000097          	auipc	ra,0x0
  16:	706080e7          	jalr	1798(ra) # 718 <printf>
  1a:	600c                	ld	a1,0(s0)
  1c:	cd99                	beqz	a1,3a <print_success+0x3a>
  1e:	0421                	addi	s0,s0,8
  20:	00001497          	auipc	s1,0x1
  24:	8b048493          	addi	s1,s1,-1872 # 8d0 <malloc+0x112>
  28:	8526                	mv	a0,s1
  2a:	00000097          	auipc	ra,0x0
  2e:	6ee080e7          	jalr	1774(ra) # 718 <printf>
  32:	0421                	addi	s0,s0,8
  34:	ff843583          	ld	a1,-8(s0)
  38:	f9e5                	bnez	a1,28 <print_success+0x28>
  3a:	00001517          	auipc	a0,0x1
  3e:	89e50513          	addi	a0,a0,-1890 # 8d8 <malloc+0x11a>
  42:	00000097          	auipc	ra,0x0
  46:	6d6080e7          	jalr	1750(ra) # 718 <printf>
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
  64:	0f6080e7          	jalr	246(ra) # 156 <fork>
  68:	ed09                	bnez	a0,82 <test+0x2e>
  6a:	4601                	li	a2,0
  6c:	85a2                	mv	a1,s0
  6e:	8526                	mv	a0,s1
  70:	00000097          	auipc	ra,0x0
  74:	20e080e7          	jalr	526(ra) # 27e <execve>
  78:	70a2                	ld	ra,40(sp)
  7a:	7402                	ld	s0,32(sp)
  7c:	64e2                	ld	s1,24(sp)
  7e:	6145                	addi	sp,sp,48
  80:	8082                	ret
  82:	0068                	addi	a0,sp,12
  84:	00000097          	auipc	ra,0x0
  88:	0da080e7          	jalr	218(ra) # 15e <wait>
  8c:	47b2                	lw	a5,12(sp)
  8e:	fe07c5e3          	bltz	a5,78 <test+0x24>
  92:	8522                	mv	a0,s0
  94:	00000097          	auipc	ra,0x0
  98:	f6c080e7          	jalr	-148(ra) # 0 <print_success>
  9c:	bff1                	j	78 <test+0x24>

000000000000009e <main>:
  9e:	711d                	addi	sp,sp,-96
  a0:	ec86                	sd	ra,88(sp)
  a2:	4589                	li	a1,2
  a4:	00001517          	auipc	a0,0x1
  a8:	84450513          	addi	a0,a0,-1980 # 8e8 <malloc+0x12a>
  ac:	00000097          	auipc	ra,0x0
  b0:	0ba080e7          	jalr	186(ra) # 166 <open>
  b4:	4501                	li	a0,0
  b6:	00000097          	auipc	ra,0x0
  ba:	0c8080e7          	jalr	200(ra) # 17e <dup>
  be:	4501                	li	a0,0
  c0:	00000097          	auipc	ra,0x0
  c4:	0be080e7          	jalr	190(ra) # 17e <dup>
  c8:	00001797          	auipc	a5,0x1
  cc:	82878793          	addi	a5,a5,-2008 # 8f0 <malloc+0x132>
  d0:	fc3e                	sd	a5,56(sp)
  d2:	00001797          	auipc	a5,0x1
  d6:	82678793          	addi	a5,a5,-2010 # 8f8 <malloc+0x13a>
  da:	e0be                	sd	a5,64(sp)
  dc:	e482                	sd	zero,72(sp)
  de:	00001797          	auipc	a5,0x1
  e2:	83a78793          	addi	a5,a5,-1990 # 918 <malloc+0x15a>
  e6:	f03e                	sd	a5,32(sp)
  e8:	00001797          	auipc	a5,0x1
  ec:	84078793          	addi	a5,a5,-1984 # 928 <malloc+0x16a>
  f0:	f43e                	sd	a5,40(sp)
  f2:	f802                	sd	zero,48(sp)
  f4:	00001797          	auipc	a5,0x1
  f8:	84478793          	addi	a5,a5,-1980 # 938 <malloc+0x17a>
  fc:	e83e                	sd	a5,16(sp)
  fe:	ec02                	sd	zero,24(sp)
 100:	00001797          	auipc	a5,0x1
 104:	84078793          	addi	a5,a5,-1984 # 940 <malloc+0x182>
 108:	e03e                	sd	a5,0(sp)
 10a:	e402                	sd	zero,8(sp)
 10c:	182c                	addi	a1,sp,56
 10e:	00001517          	auipc	a0,0x1
 112:	83a50513          	addi	a0,a0,-1990 # 948 <malloc+0x18a>
 116:	00000097          	auipc	ra,0x0
 11a:	f3e080e7          	jalr	-194(ra) # 54 <test>
 11e:	100c                	addi	a1,sp,32
 120:	00001517          	auipc	a0,0x1
 124:	82850513          	addi	a0,a0,-2008 # 948 <malloc+0x18a>
 128:	00000097          	auipc	ra,0x0
 12c:	f2c080e7          	jalr	-212(ra) # 54 <test>
 130:	080c                	addi	a1,sp,16
 132:	00001517          	auipc	a0,0x1
 136:	81650513          	addi	a0,a0,-2026 # 948 <malloc+0x18a>
 13a:	00000097          	auipc	ra,0x0
 13e:	f1a080e7          	jalr	-230(ra) # 54 <test>
 142:	858a                	mv	a1,sp
 144:	00001517          	auipc	a0,0x1
 148:	80450513          	addi	a0,a0,-2044 # 948 <malloc+0x18a>
 14c:	00000097          	auipc	ra,0x0
 150:	f08080e7          	jalr	-248(ra) # 54 <test>
 154:	a001                	j	154 <main+0xb6>

0000000000000156 <fork>:
 156:	4885                	li	a7,1
 158:	00000073          	ecall
 15c:	8082                	ret

000000000000015e <wait>:
 15e:	488d                	li	a7,3
 160:	00000073          	ecall
 164:	8082                	ret

0000000000000166 <open>:
 166:	4889                	li	a7,2
 168:	00000073          	ecall
 16c:	8082                	ret

000000000000016e <sbrk>:
 16e:	4891                	li	a7,4
 170:	00000073          	ecall
 174:	8082                	ret

0000000000000176 <getcwd>:
 176:	48c5                	li	a7,17
 178:	00000073          	ecall
 17c:	8082                	ret

000000000000017e <dup>:
 17e:	48dd                	li	a7,23
 180:	00000073          	ecall
 184:	8082                	ret

0000000000000186 <dup3>:
 186:	48e1                	li	a7,24
 188:	00000073          	ecall
 18c:	8082                	ret

000000000000018e <mkdirat>:
 18e:	02200893          	li	a7,34
 192:	00000073          	ecall
 196:	8082                	ret

0000000000000198 <unlinkat>:
 198:	02300893          	li	a7,35
 19c:	00000073          	ecall
 1a0:	8082                	ret

00000000000001a2 <linkat>:
 1a2:	02500893          	li	a7,37
 1a6:	00000073          	ecall
 1aa:	8082                	ret

00000000000001ac <umount2>:
 1ac:	02700893          	li	a7,39
 1b0:	00000073          	ecall
 1b4:	8082                	ret

00000000000001b6 <mount>:
 1b6:	02800893          	li	a7,40
 1ba:	00000073          	ecall
 1be:	8082                	ret

00000000000001c0 <chdir>:
 1c0:	03100893          	li	a7,49
 1c4:	00000073          	ecall
 1c8:	8082                	ret

00000000000001ca <openat>:
 1ca:	03800893          	li	a7,56
 1ce:	00000073          	ecall
 1d2:	8082                	ret

00000000000001d4 <close>:
 1d4:	03900893          	li	a7,57
 1d8:	00000073          	ecall
 1dc:	8082                	ret

00000000000001de <pipe2>:
 1de:	03b00893          	li	a7,59
 1e2:	00000073          	ecall
 1e6:	8082                	ret

00000000000001e8 <getdents64>:
 1e8:	03d00893          	li	a7,61
 1ec:	00000073          	ecall
 1f0:	8082                	ret

00000000000001f2 <read>:
 1f2:	03f00893          	li	a7,63
 1f6:	00000073          	ecall
 1fa:	8082                	ret

00000000000001fc <write>:
 1fc:	04000893          	li	a7,64
 200:	00000073          	ecall
 204:	8082                	ret

0000000000000206 <fstat>:
 206:	05000893          	li	a7,80
 20a:	00000073          	ecall
 20e:	8082                	ret

0000000000000210 <exit>:
 210:	05d00893          	li	a7,93
 214:	00000073          	ecall
 218:	8082                	ret

000000000000021a <nanosleep>:
 21a:	06500893          	li	a7,101
 21e:	00000073          	ecall
 222:	8082                	ret

0000000000000224 <sched_yield>:
 224:	07c00893          	li	a7,124
 228:	00000073          	ecall
 22c:	8082                	ret

000000000000022e <times>:
 22e:	09900893          	li	a7,153
 232:	00000073          	ecall
 236:	8082                	ret

0000000000000238 <uname>:
 238:	0a000893          	li	a7,160
 23c:	00000073          	ecall
 240:	8082                	ret

0000000000000242 <gettimeofday>:
 242:	0a900893          	li	a7,169
 246:	00000073          	ecall
 24a:	8082                	ret

000000000000024c <brk>:
 24c:	0d600893          	li	a7,214
 250:	00000073          	ecall
 254:	8082                	ret

0000000000000256 <munmap>:
 256:	0d700893          	li	a7,215
 25a:	00000073          	ecall
 25e:	8082                	ret

0000000000000260 <getpid>:
 260:	0ac00893          	li	a7,172
 264:	00000073          	ecall
 268:	8082                	ret

000000000000026a <getppid>:
 26a:	0ad00893          	li	a7,173
 26e:	00000073          	ecall
 272:	8082                	ret

0000000000000274 <clone>:
 274:	0dc00893          	li	a7,220
 278:	00000073          	ecall
 27c:	8082                	ret

000000000000027e <execve>:
 27e:	0dd00893          	li	a7,221
 282:	00000073          	ecall
 286:	8082                	ret

0000000000000288 <mmap>:
 288:	0de00893          	li	a7,222
 28c:	00000073          	ecall
 290:	8082                	ret

0000000000000292 <wait4>:
 292:	10400893          	li	a7,260
 296:	00000073          	ecall
 29a:	8082                	ret

000000000000029c <strcpy>:
 29c:	87aa                	mv	a5,a0
 29e:	0585                	addi	a1,a1,1
 2a0:	0785                	addi	a5,a5,1
 2a2:	fff5c703          	lbu	a4,-1(a1)
 2a6:	fee78fa3          	sb	a4,-1(a5)
 2aa:	fb75                	bnez	a4,29e <strcpy+0x2>
 2ac:	8082                	ret

00000000000002ae <strcmp>:
 2ae:	00054783          	lbu	a5,0(a0)
 2b2:	cb91                	beqz	a5,2c6 <strcmp+0x18>
 2b4:	0005c703          	lbu	a4,0(a1)
 2b8:	00f71763          	bne	a4,a5,2c6 <strcmp+0x18>
 2bc:	0505                	addi	a0,a0,1
 2be:	0585                	addi	a1,a1,1
 2c0:	00054783          	lbu	a5,0(a0)
 2c4:	fbe5                	bnez	a5,2b4 <strcmp+0x6>
 2c6:	0005c503          	lbu	a0,0(a1)
 2ca:	40a7853b          	subw	a0,a5,a0
 2ce:	8082                	ret

00000000000002d0 <strlen>:
 2d0:	00054783          	lbu	a5,0(a0)
 2d4:	cf81                	beqz	a5,2ec <strlen+0x1c>
 2d6:	0505                	addi	a0,a0,1
 2d8:	87aa                	mv	a5,a0
 2da:	4685                	li	a3,1
 2dc:	9e89                	subw	a3,a3,a0
 2de:	00f6853b          	addw	a0,a3,a5
 2e2:	0785                	addi	a5,a5,1
 2e4:	fff7c703          	lbu	a4,-1(a5)
 2e8:	fb7d                	bnez	a4,2de <strlen+0xe>
 2ea:	8082                	ret
 2ec:	4501                	li	a0,0
 2ee:	8082                	ret

00000000000002f0 <memset>:
 2f0:	ce09                	beqz	a2,30a <memset+0x1a>
 2f2:	87aa                	mv	a5,a0
 2f4:	fff6071b          	addiw	a4,a2,-1
 2f8:	1702                	slli	a4,a4,0x20
 2fa:	9301                	srli	a4,a4,0x20
 2fc:	0705                	addi	a4,a4,1
 2fe:	972a                	add	a4,a4,a0
 300:	00b78023          	sb	a1,0(a5)
 304:	0785                	addi	a5,a5,1
 306:	fee79de3          	bne	a5,a4,300 <memset+0x10>
 30a:	8082                	ret

000000000000030c <strchr>:
 30c:	00054783          	lbu	a5,0(a0)
 310:	cb89                	beqz	a5,322 <strchr+0x16>
 312:	00f58963          	beq	a1,a5,324 <strchr+0x18>
 316:	0505                	addi	a0,a0,1
 318:	00054783          	lbu	a5,0(a0)
 31c:	fbfd                	bnez	a5,312 <strchr+0x6>
 31e:	4501                	li	a0,0
 320:	8082                	ret
 322:	4501                	li	a0,0
 324:	8082                	ret

0000000000000326 <gets>:
 326:	715d                	addi	sp,sp,-80
 328:	e486                	sd	ra,72(sp)
 32a:	e0a2                	sd	s0,64(sp)
 32c:	fc26                	sd	s1,56(sp)
 32e:	f84a                	sd	s2,48(sp)
 330:	f44e                	sd	s3,40(sp)
 332:	f052                	sd	s4,32(sp)
 334:	ec56                	sd	s5,24(sp)
 336:	e85a                	sd	s6,16(sp)
 338:	8b2a                	mv	s6,a0
 33a:	89ae                	mv	s3,a1
 33c:	84aa                	mv	s1,a0
 33e:	4401                	li	s0,0
 340:	4a29                	li	s4,10
 342:	4ab5                	li	s5,13
 344:	8922                	mv	s2,s0
 346:	2405                	addiw	s0,s0,1
 348:	03345863          	bge	s0,s3,378 <gets+0x52>
 34c:	4605                	li	a2,1
 34e:	00f10593          	addi	a1,sp,15
 352:	4501                	li	a0,0
 354:	00000097          	auipc	ra,0x0
 358:	e9e080e7          	jalr	-354(ra) # 1f2 <read>
 35c:	00a05e63          	blez	a0,378 <gets+0x52>
 360:	00f14783          	lbu	a5,15(sp)
 364:	00f48023          	sb	a5,0(s1)
 368:	01478763          	beq	a5,s4,376 <gets+0x50>
 36c:	0485                	addi	s1,s1,1
 36e:	fd579be3          	bne	a5,s5,344 <gets+0x1e>
 372:	8922                	mv	s2,s0
 374:	a011                	j	378 <gets+0x52>
 376:	8922                	mv	s2,s0
 378:	995a                	add	s2,s2,s6
 37a:	00090023          	sb	zero,0(s2)
 37e:	855a                	mv	a0,s6
 380:	60a6                	ld	ra,72(sp)
 382:	6406                	ld	s0,64(sp)
 384:	74e2                	ld	s1,56(sp)
 386:	7942                	ld	s2,48(sp)
 388:	79a2                	ld	s3,40(sp)
 38a:	7a02                	ld	s4,32(sp)
 38c:	6ae2                	ld	s5,24(sp)
 38e:	6b42                	ld	s6,16(sp)
 390:	6161                	addi	sp,sp,80
 392:	8082                	ret

0000000000000394 <atoi>:
 394:	86aa                	mv	a3,a0
 396:	00054603          	lbu	a2,0(a0)
 39a:	fd06079b          	addiw	a5,a2,-48
 39e:	0ff7f793          	andi	a5,a5,255
 3a2:	4725                	li	a4,9
 3a4:	02f76663          	bltu	a4,a5,3d0 <atoi+0x3c>
 3a8:	4501                	li	a0,0
 3aa:	45a5                	li	a1,9
 3ac:	0685                	addi	a3,a3,1
 3ae:	0025179b          	slliw	a5,a0,0x2
 3b2:	9fa9                	addw	a5,a5,a0
 3b4:	0017979b          	slliw	a5,a5,0x1
 3b8:	9fb1                	addw	a5,a5,a2
 3ba:	fd07851b          	addiw	a0,a5,-48
 3be:	0006c603          	lbu	a2,0(a3)
 3c2:	fd06071b          	addiw	a4,a2,-48
 3c6:	0ff77713          	andi	a4,a4,255
 3ca:	fee5f1e3          	bgeu	a1,a4,3ac <atoi+0x18>
 3ce:	8082                	ret
 3d0:	4501                	li	a0,0
 3d2:	8082                	ret

00000000000003d4 <memmove>:
 3d4:	02b57463          	bgeu	a0,a1,3fc <memmove+0x28>
 3d8:	04c05663          	blez	a2,424 <memmove+0x50>
 3dc:	fff6079b          	addiw	a5,a2,-1
 3e0:	1782                	slli	a5,a5,0x20
 3e2:	9381                	srli	a5,a5,0x20
 3e4:	0785                	addi	a5,a5,1
 3e6:	97aa                	add	a5,a5,a0
 3e8:	872a                	mv	a4,a0
 3ea:	0585                	addi	a1,a1,1
 3ec:	0705                	addi	a4,a4,1
 3ee:	fff5c683          	lbu	a3,-1(a1)
 3f2:	fed70fa3          	sb	a3,-1(a4)
 3f6:	fee79ae3          	bne	a5,a4,3ea <memmove+0x16>
 3fa:	8082                	ret
 3fc:	00c50733          	add	a4,a0,a2
 400:	95b2                	add	a1,a1,a2
 402:	02c05163          	blez	a2,424 <memmove+0x50>
 406:	fff6079b          	addiw	a5,a2,-1
 40a:	1782                	slli	a5,a5,0x20
 40c:	9381                	srli	a5,a5,0x20
 40e:	fff7c793          	not	a5,a5
 412:	97ba                	add	a5,a5,a4
 414:	15fd                	addi	a1,a1,-1
 416:	177d                	addi	a4,a4,-1
 418:	0005c683          	lbu	a3,0(a1)
 41c:	00d70023          	sb	a3,0(a4)
 420:	fee79ae3          	bne	a5,a4,414 <memmove+0x40>
 424:	8082                	ret

0000000000000426 <memcmp>:
 426:	fff6069b          	addiw	a3,a2,-1
 42a:	c605                	beqz	a2,452 <memcmp+0x2c>
 42c:	1682                	slli	a3,a3,0x20
 42e:	9281                	srli	a3,a3,0x20
 430:	0685                	addi	a3,a3,1
 432:	96aa                	add	a3,a3,a0
 434:	00054783          	lbu	a5,0(a0)
 438:	0005c703          	lbu	a4,0(a1)
 43c:	00e79863          	bne	a5,a4,44c <memcmp+0x26>
 440:	0505                	addi	a0,a0,1
 442:	0585                	addi	a1,a1,1
 444:	fed518e3          	bne	a0,a3,434 <memcmp+0xe>
 448:	4501                	li	a0,0
 44a:	8082                	ret
 44c:	40e7853b          	subw	a0,a5,a4
 450:	8082                	ret
 452:	4501                	li	a0,0
 454:	8082                	ret

0000000000000456 <memcpy>:
 456:	1141                	addi	sp,sp,-16
 458:	e406                	sd	ra,8(sp)
 45a:	00000097          	auipc	ra,0x0
 45e:	f7a080e7          	jalr	-134(ra) # 3d4 <memmove>
 462:	60a2                	ld	ra,8(sp)
 464:	0141                	addi	sp,sp,16
 466:	8082                	ret

0000000000000468 <putc>:
 468:	1101                	addi	sp,sp,-32
 46a:	ec06                	sd	ra,24(sp)
 46c:	00b107a3          	sb	a1,15(sp)
 470:	4605                	li	a2,1
 472:	00f10593          	addi	a1,sp,15
 476:	00000097          	auipc	ra,0x0
 47a:	d86080e7          	jalr	-634(ra) # 1fc <write>
 47e:	60e2                	ld	ra,24(sp)
 480:	6105                	addi	sp,sp,32
 482:	8082                	ret

0000000000000484 <printint>:
 484:	7179                	addi	sp,sp,-48
 486:	f406                	sd	ra,40(sp)
 488:	f022                	sd	s0,32(sp)
 48a:	ec26                	sd	s1,24(sp)
 48c:	e84a                	sd	s2,16(sp)
 48e:	84aa                	mv	s1,a0
 490:	c299                	beqz	a3,496 <printint+0x12>
 492:	0805c363          	bltz	a1,518 <printint+0x94>
 496:	2581                	sext.w	a1,a1
 498:	4881                	li	a7,0
 49a:	868a                	mv	a3,sp
 49c:	4701                	li	a4,0
 49e:	2601                	sext.w	a2,a2
 4a0:	00000517          	auipc	a0,0x0
 4a4:	4b850513          	addi	a0,a0,1208 # 958 <digits>
 4a8:	883a                	mv	a6,a4
 4aa:	2705                	addiw	a4,a4,1
 4ac:	02c5f7bb          	remuw	a5,a1,a2
 4b0:	1782                	slli	a5,a5,0x20
 4b2:	9381                	srli	a5,a5,0x20
 4b4:	97aa                	add	a5,a5,a0
 4b6:	0007c783          	lbu	a5,0(a5)
 4ba:	00f68023          	sb	a5,0(a3)
 4be:	0005879b          	sext.w	a5,a1
 4c2:	02c5d5bb          	divuw	a1,a1,a2
 4c6:	0685                	addi	a3,a3,1
 4c8:	fec7f0e3          	bgeu	a5,a2,4a8 <printint+0x24>
 4cc:	00088a63          	beqz	a7,4e0 <printint+0x5c>
 4d0:	081c                	addi	a5,sp,16
 4d2:	973e                	add	a4,a4,a5
 4d4:	02d00793          	li	a5,45
 4d8:	fef70823          	sb	a5,-16(a4)
 4dc:	0028071b          	addiw	a4,a6,2
 4e0:	02e05663          	blez	a4,50c <printint+0x88>
 4e4:	00e10433          	add	s0,sp,a4
 4e8:	fff10913          	addi	s2,sp,-1
 4ec:	993a                	add	s2,s2,a4
 4ee:	377d                	addiw	a4,a4,-1
 4f0:	1702                	slli	a4,a4,0x20
 4f2:	9301                	srli	a4,a4,0x20
 4f4:	40e90933          	sub	s2,s2,a4
 4f8:	fff44583          	lbu	a1,-1(s0)
 4fc:	8526                	mv	a0,s1
 4fe:	00000097          	auipc	ra,0x0
 502:	f6a080e7          	jalr	-150(ra) # 468 <putc>
 506:	147d                	addi	s0,s0,-1
 508:	ff2418e3          	bne	s0,s2,4f8 <printint+0x74>
 50c:	70a2                	ld	ra,40(sp)
 50e:	7402                	ld	s0,32(sp)
 510:	64e2                	ld	s1,24(sp)
 512:	6942                	ld	s2,16(sp)
 514:	6145                	addi	sp,sp,48
 516:	8082                	ret
 518:	40b005bb          	negw	a1,a1
 51c:	4885                	li	a7,1
 51e:	bfb5                	j	49a <printint+0x16>

0000000000000520 <vprintf>:
 520:	7119                	addi	sp,sp,-128
 522:	fc86                	sd	ra,120(sp)
 524:	f8a2                	sd	s0,112(sp)
 526:	f4a6                	sd	s1,104(sp)
 528:	f0ca                	sd	s2,96(sp)
 52a:	ecce                	sd	s3,88(sp)
 52c:	e8d2                	sd	s4,80(sp)
 52e:	e4d6                	sd	s5,72(sp)
 530:	e0da                	sd	s6,64(sp)
 532:	fc5e                	sd	s7,56(sp)
 534:	f862                	sd	s8,48(sp)
 536:	f466                	sd	s9,40(sp)
 538:	f06a                	sd	s10,32(sp)
 53a:	ec6e                	sd	s11,24(sp)
 53c:	0005c483          	lbu	s1,0(a1)
 540:	18048c63          	beqz	s1,6d8 <vprintf+0x1b8>
 544:	8a2a                	mv	s4,a0
 546:	8ab2                	mv	s5,a2
 548:	00158413          	addi	s0,a1,1
 54c:	4901                	li	s2,0
 54e:	02500993          	li	s3,37
 552:	06400b93          	li	s7,100
 556:	06c00c13          	li	s8,108
 55a:	07800c93          	li	s9,120
 55e:	07000d13          	li	s10,112
 562:	07300d93          	li	s11,115
 566:	00000b17          	auipc	s6,0x0
 56a:	3f2b0b13          	addi	s6,s6,1010 # 958 <digits>
 56e:	a839                	j	58c <vprintf+0x6c>
 570:	85a6                	mv	a1,s1
 572:	8552                	mv	a0,s4
 574:	00000097          	auipc	ra,0x0
 578:	ef4080e7          	jalr	-268(ra) # 468 <putc>
 57c:	a019                	j	582 <vprintf+0x62>
 57e:	01390f63          	beq	s2,s3,59c <vprintf+0x7c>
 582:	0405                	addi	s0,s0,1
 584:	fff44483          	lbu	s1,-1(s0)
 588:	14048863          	beqz	s1,6d8 <vprintf+0x1b8>
 58c:	0004879b          	sext.w	a5,s1
 590:	fe0917e3          	bnez	s2,57e <vprintf+0x5e>
 594:	fd379ee3          	bne	a5,s3,570 <vprintf+0x50>
 598:	893e                	mv	s2,a5
 59a:	b7e5                	j	582 <vprintf+0x62>
 59c:	03778e63          	beq	a5,s7,5d8 <vprintf+0xb8>
 5a0:	05878a63          	beq	a5,s8,5f4 <vprintf+0xd4>
 5a4:	07978663          	beq	a5,s9,610 <vprintf+0xf0>
 5a8:	09a78263          	beq	a5,s10,62c <vprintf+0x10c>
 5ac:	0db78363          	beq	a5,s11,672 <vprintf+0x152>
 5b0:	06300713          	li	a4,99
 5b4:	0ee78b63          	beq	a5,a4,6aa <vprintf+0x18a>
 5b8:	11378563          	beq	a5,s3,6c2 <vprintf+0x1a2>
 5bc:	85ce                	mv	a1,s3
 5be:	8552                	mv	a0,s4
 5c0:	00000097          	auipc	ra,0x0
 5c4:	ea8080e7          	jalr	-344(ra) # 468 <putc>
 5c8:	85a6                	mv	a1,s1
 5ca:	8552                	mv	a0,s4
 5cc:	00000097          	auipc	ra,0x0
 5d0:	e9c080e7          	jalr	-356(ra) # 468 <putc>
 5d4:	4901                	li	s2,0
 5d6:	b775                	j	582 <vprintf+0x62>
 5d8:	008a8493          	addi	s1,s5,8
 5dc:	4685                	li	a3,1
 5de:	4629                	li	a2,10
 5e0:	000aa583          	lw	a1,0(s5)
 5e4:	8552                	mv	a0,s4
 5e6:	00000097          	auipc	ra,0x0
 5ea:	e9e080e7          	jalr	-354(ra) # 484 <printint>
 5ee:	8aa6                	mv	s5,s1
 5f0:	4901                	li	s2,0
 5f2:	bf41                	j	582 <vprintf+0x62>
 5f4:	008a8493          	addi	s1,s5,8
 5f8:	4681                	li	a3,0
 5fa:	4629                	li	a2,10
 5fc:	000aa583          	lw	a1,0(s5)
 600:	8552                	mv	a0,s4
 602:	00000097          	auipc	ra,0x0
 606:	e82080e7          	jalr	-382(ra) # 484 <printint>
 60a:	8aa6                	mv	s5,s1
 60c:	4901                	li	s2,0
 60e:	bf95                	j	582 <vprintf+0x62>
 610:	008a8493          	addi	s1,s5,8
 614:	4681                	li	a3,0
 616:	4641                	li	a2,16
 618:	000aa583          	lw	a1,0(s5)
 61c:	8552                	mv	a0,s4
 61e:	00000097          	auipc	ra,0x0
 622:	e66080e7          	jalr	-410(ra) # 484 <printint>
 626:	8aa6                	mv	s5,s1
 628:	4901                	li	s2,0
 62a:	bfa1                	j	582 <vprintf+0x62>
 62c:	008a8793          	addi	a5,s5,8
 630:	e43e                	sd	a5,8(sp)
 632:	000ab903          	ld	s2,0(s5)
 636:	03000593          	li	a1,48
 63a:	8552                	mv	a0,s4
 63c:	00000097          	auipc	ra,0x0
 640:	e2c080e7          	jalr	-468(ra) # 468 <putc>
 644:	85e6                	mv	a1,s9
 646:	8552                	mv	a0,s4
 648:	00000097          	auipc	ra,0x0
 64c:	e20080e7          	jalr	-480(ra) # 468 <putc>
 650:	44c1                	li	s1,16
 652:	03c95793          	srli	a5,s2,0x3c
 656:	97da                	add	a5,a5,s6
 658:	0007c583          	lbu	a1,0(a5)
 65c:	8552                	mv	a0,s4
 65e:	00000097          	auipc	ra,0x0
 662:	e0a080e7          	jalr	-502(ra) # 468 <putc>
 666:	0912                	slli	s2,s2,0x4
 668:	34fd                	addiw	s1,s1,-1
 66a:	f4e5                	bnez	s1,652 <vprintf+0x132>
 66c:	6aa2                	ld	s5,8(sp)
 66e:	4901                	li	s2,0
 670:	bf09                	j	582 <vprintf+0x62>
 672:	008a8493          	addi	s1,s5,8
 676:	000ab903          	ld	s2,0(s5)
 67a:	02090163          	beqz	s2,69c <vprintf+0x17c>
 67e:	00094583          	lbu	a1,0(s2)
 682:	c9a1                	beqz	a1,6d2 <vprintf+0x1b2>
 684:	8552                	mv	a0,s4
 686:	00000097          	auipc	ra,0x0
 68a:	de2080e7          	jalr	-542(ra) # 468 <putc>
 68e:	0905                	addi	s2,s2,1
 690:	00094583          	lbu	a1,0(s2)
 694:	f9e5                	bnez	a1,684 <vprintf+0x164>
 696:	8aa6                	mv	s5,s1
 698:	4901                	li	s2,0
 69a:	b5e5                	j	582 <vprintf+0x62>
 69c:	00000917          	auipc	s2,0x0
 6a0:	2b490913          	addi	s2,s2,692 # 950 <malloc+0x192>
 6a4:	02800593          	li	a1,40
 6a8:	bff1                	j	684 <vprintf+0x164>
 6aa:	008a8493          	addi	s1,s5,8
 6ae:	000ac583          	lbu	a1,0(s5)
 6b2:	8552                	mv	a0,s4
 6b4:	00000097          	auipc	ra,0x0
 6b8:	db4080e7          	jalr	-588(ra) # 468 <putc>
 6bc:	8aa6                	mv	s5,s1
 6be:	4901                	li	s2,0
 6c0:	b5c9                	j	582 <vprintf+0x62>
 6c2:	85ce                	mv	a1,s3
 6c4:	8552                	mv	a0,s4
 6c6:	00000097          	auipc	ra,0x0
 6ca:	da2080e7          	jalr	-606(ra) # 468 <putc>
 6ce:	4901                	li	s2,0
 6d0:	bd4d                	j	582 <vprintf+0x62>
 6d2:	8aa6                	mv	s5,s1
 6d4:	4901                	li	s2,0
 6d6:	b575                	j	582 <vprintf+0x62>
 6d8:	70e6                	ld	ra,120(sp)
 6da:	7446                	ld	s0,112(sp)
 6dc:	74a6                	ld	s1,104(sp)
 6de:	7906                	ld	s2,96(sp)
 6e0:	69e6                	ld	s3,88(sp)
 6e2:	6a46                	ld	s4,80(sp)
 6e4:	6aa6                	ld	s5,72(sp)
 6e6:	6b06                	ld	s6,64(sp)
 6e8:	7be2                	ld	s7,56(sp)
 6ea:	7c42                	ld	s8,48(sp)
 6ec:	7ca2                	ld	s9,40(sp)
 6ee:	7d02                	ld	s10,32(sp)
 6f0:	6de2                	ld	s11,24(sp)
 6f2:	6109                	addi	sp,sp,128
 6f4:	8082                	ret

00000000000006f6 <fprintf>:
 6f6:	715d                	addi	sp,sp,-80
 6f8:	ec06                	sd	ra,24(sp)
 6fa:	f032                	sd	a2,32(sp)
 6fc:	f436                	sd	a3,40(sp)
 6fe:	f83a                	sd	a4,48(sp)
 700:	fc3e                	sd	a5,56(sp)
 702:	e0c2                	sd	a6,64(sp)
 704:	e4c6                	sd	a7,72(sp)
 706:	1010                	addi	a2,sp,32
 708:	e432                	sd	a2,8(sp)
 70a:	00000097          	auipc	ra,0x0
 70e:	e16080e7          	jalr	-490(ra) # 520 <vprintf>
 712:	60e2                	ld	ra,24(sp)
 714:	6161                	addi	sp,sp,80
 716:	8082                	ret

0000000000000718 <printf>:
 718:	711d                	addi	sp,sp,-96
 71a:	ec06                	sd	ra,24(sp)
 71c:	f42e                	sd	a1,40(sp)
 71e:	f832                	sd	a2,48(sp)
 720:	fc36                	sd	a3,56(sp)
 722:	e0ba                	sd	a4,64(sp)
 724:	e4be                	sd	a5,72(sp)
 726:	e8c2                	sd	a6,80(sp)
 728:	ecc6                	sd	a7,88(sp)
 72a:	1030                	addi	a2,sp,40
 72c:	e432                	sd	a2,8(sp)
 72e:	85aa                	mv	a1,a0
 730:	4505                	li	a0,1
 732:	00000097          	auipc	ra,0x0
 736:	dee080e7          	jalr	-530(ra) # 520 <vprintf>
 73a:	60e2                	ld	ra,24(sp)
 73c:	6125                	addi	sp,sp,96
 73e:	8082                	ret

0000000000000740 <free>:
 740:	ff050693          	addi	a3,a0,-16
 744:	00000797          	auipc	a5,0x0
 748:	22c7b783          	ld	a5,556(a5) # 970 <freep>
 74c:	a805                	j	77c <free+0x3c>
 74e:	4618                	lw	a4,8(a2)
 750:	9db9                	addw	a1,a1,a4
 752:	feb52c23          	sw	a1,-8(a0)
 756:	6398                	ld	a4,0(a5)
 758:	6318                	ld	a4,0(a4)
 75a:	fee53823          	sd	a4,-16(a0)
 75e:	a091                	j	7a2 <free+0x62>
 760:	ff852703          	lw	a4,-8(a0)
 764:	9e39                	addw	a2,a2,a4
 766:	c790                	sw	a2,8(a5)
 768:	ff053703          	ld	a4,-16(a0)
 76c:	e398                	sd	a4,0(a5)
 76e:	a099                	j	7b4 <free+0x74>
 770:	6398                	ld	a4,0(a5)
 772:	00e7e463          	bltu	a5,a4,77a <free+0x3a>
 776:	00e6ea63          	bltu	a3,a4,78a <free+0x4a>
 77a:	87ba                	mv	a5,a4
 77c:	fed7fae3          	bgeu	a5,a3,770 <free+0x30>
 780:	6398                	ld	a4,0(a5)
 782:	00e6e463          	bltu	a3,a4,78a <free+0x4a>
 786:	fee7eae3          	bltu	a5,a4,77a <free+0x3a>
 78a:	ff852583          	lw	a1,-8(a0)
 78e:	6390                	ld	a2,0(a5)
 790:	02059713          	slli	a4,a1,0x20
 794:	9301                	srli	a4,a4,0x20
 796:	0712                	slli	a4,a4,0x4
 798:	9736                	add	a4,a4,a3
 79a:	fae60ae3          	beq	a2,a4,74e <free+0xe>
 79e:	fec53823          	sd	a2,-16(a0)
 7a2:	4790                	lw	a2,8(a5)
 7a4:	02061713          	slli	a4,a2,0x20
 7a8:	9301                	srli	a4,a4,0x20
 7aa:	0712                	slli	a4,a4,0x4
 7ac:	973e                	add	a4,a4,a5
 7ae:	fae689e3          	beq	a3,a4,760 <free+0x20>
 7b2:	e394                	sd	a3,0(a5)
 7b4:	00000717          	auipc	a4,0x0
 7b8:	1af73e23          	sd	a5,444(a4) # 970 <freep>
 7bc:	8082                	ret

00000000000007be <malloc>:
 7be:	7139                	addi	sp,sp,-64
 7c0:	fc06                	sd	ra,56(sp)
 7c2:	f822                	sd	s0,48(sp)
 7c4:	f426                	sd	s1,40(sp)
 7c6:	f04a                	sd	s2,32(sp)
 7c8:	ec4e                	sd	s3,24(sp)
 7ca:	e852                	sd	s4,16(sp)
 7cc:	e456                	sd	s5,8(sp)
 7ce:	02051413          	slli	s0,a0,0x20
 7d2:	9001                	srli	s0,s0,0x20
 7d4:	043d                	addi	s0,s0,15
 7d6:	8011                	srli	s0,s0,0x4
 7d8:	0014091b          	addiw	s2,s0,1
 7dc:	0405                	addi	s0,s0,1
 7de:	00000517          	auipc	a0,0x0
 7e2:	19253503          	ld	a0,402(a0) # 970 <freep>
 7e6:	c905                	beqz	a0,816 <malloc+0x58>
 7e8:	611c                	ld	a5,0(a0)
 7ea:	4798                	lw	a4,8(a5)
 7ec:	04877163          	bgeu	a4,s0,82e <malloc+0x70>
 7f0:	89ca                	mv	s3,s2
 7f2:	0009071b          	sext.w	a4,s2
 7f6:	6685                	lui	a3,0x1
 7f8:	00d77363          	bgeu	a4,a3,7fe <malloc+0x40>
 7fc:	6985                	lui	s3,0x1
 7fe:	00098a1b          	sext.w	s4,s3
 802:	1982                	slli	s3,s3,0x20
 804:	0209d993          	srli	s3,s3,0x20
 808:	0992                	slli	s3,s3,0x4
 80a:	00000497          	auipc	s1,0x0
 80e:	16648493          	addi	s1,s1,358 # 970 <freep>
 812:	5afd                	li	s5,-1
 814:	a0bd                	j	882 <malloc+0xc4>
 816:	00000797          	auipc	a5,0x0
 81a:	16278793          	addi	a5,a5,354 # 978 <base>
 81e:	00000717          	auipc	a4,0x0
 822:	14f73923          	sd	a5,338(a4) # 970 <freep>
 826:	e39c                	sd	a5,0(a5)
 828:	0007a423          	sw	zero,8(a5)
 82c:	b7d1                	j	7f0 <malloc+0x32>
 82e:	02e40a63          	beq	s0,a4,862 <malloc+0xa4>
 832:	4127073b          	subw	a4,a4,s2
 836:	c798                	sw	a4,8(a5)
 838:	1702                	slli	a4,a4,0x20
 83a:	9301                	srli	a4,a4,0x20
 83c:	0712                	slli	a4,a4,0x4
 83e:	97ba                	add	a5,a5,a4
 840:	0127a423          	sw	s2,8(a5)
 844:	00000717          	auipc	a4,0x0
 848:	12a73623          	sd	a0,300(a4) # 970 <freep>
 84c:	01078513          	addi	a0,a5,16
 850:	70e2                	ld	ra,56(sp)
 852:	7442                	ld	s0,48(sp)
 854:	74a2                	ld	s1,40(sp)
 856:	7902                	ld	s2,32(sp)
 858:	69e2                	ld	s3,24(sp)
 85a:	6a42                	ld	s4,16(sp)
 85c:	6aa2                	ld	s5,8(sp)
 85e:	6121                	addi	sp,sp,64
 860:	8082                	ret
 862:	6398                	ld	a4,0(a5)
 864:	e118                	sd	a4,0(a0)
 866:	bff9                	j	844 <malloc+0x86>
 868:	01452423          	sw	s4,8(a0)
 86c:	0541                	addi	a0,a0,16
 86e:	00000097          	auipc	ra,0x0
 872:	ed2080e7          	jalr	-302(ra) # 740 <free>
 876:	6088                	ld	a0,0(s1)
 878:	dd61                	beqz	a0,850 <malloc+0x92>
 87a:	611c                	ld	a5,0(a0)
 87c:	4798                	lw	a4,8(a5)
 87e:	fa8778e3          	bgeu	a4,s0,82e <malloc+0x70>
 882:	6098                	ld	a4,0(s1)
 884:	853e                	mv	a0,a5
 886:	fef71ae3          	bne	a4,a5,87a <malloc+0xbc>
 88a:	854e                	mv	a0,s3
 88c:	00000097          	auipc	ra,0x0
 890:	8e2080e7          	jalr	-1822(ra) # 16e <sbrk>
 894:	fd551ae3          	bne	a0,s5,868 <malloc+0xaa>
 898:	4501                	li	a0,0
 89a:	bf5d                	j	850 <malloc+0x92>
