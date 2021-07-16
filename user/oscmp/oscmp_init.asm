
_oscmp_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_success>:
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	842a                	mv	s0,a0
   a:	00001517          	auipc	a0,0x1
   e:	8be50513          	addi	a0,a0,-1858 # 8c8 <malloc+0xf8>
  12:	00000097          	auipc	ra,0x0
  16:	718080e7          	jalr	1816(ra) # 72a <printf>
  1a:	600c                	ld	a1,0(s0)
  1c:	cd99                	beqz	a1,3a <print_success+0x3a>
  1e:	0421                	addi	s0,s0,8
  20:	00001497          	auipc	s1,0x1
  24:	8c048493          	addi	s1,s1,-1856 # 8e0 <malloc+0x110>
  28:	8526                	mv	a0,s1
  2a:	00000097          	auipc	ra,0x0
  2e:	700080e7          	jalr	1792(ra) # 72a <printf>
  32:	0421                	addi	s0,s0,8
  34:	ff843583          	ld	a1,-8(s0)
  38:	f9e5                	bnez	a1,28 <print_success+0x28>
  3a:	00001517          	auipc	a0,0x1
  3e:	8ae50513          	addi	a0,a0,-1874 # 8e8 <malloc+0x118>
  42:	00000097          	auipc	ra,0x0
  46:	6e8080e7          	jalr	1768(ra) # 72a <printf>
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
  64:	108080e7          	jalr	264(ra) # 168 <fork>
  68:	ed09                	bnez	a0,82 <test+0x2e>
  6a:	4601                	li	a2,0
  6c:	85a2                	mv	a1,s0
  6e:	8526                	mv	a0,s1
  70:	00000097          	auipc	ra,0x0
  74:	220080e7          	jalr	544(ra) # 290 <execve>
  78:	70a2                	ld	ra,40(sp)
  7a:	7402                	ld	s0,32(sp)
  7c:	64e2                	ld	s1,24(sp)
  7e:	6145                	addi	sp,sp,48
  80:	8082                	ret
  82:	0068                	addi	a0,sp,12
  84:	00000097          	auipc	ra,0x0
  88:	0ec080e7          	jalr	236(ra) # 170 <wait>
  8c:	47b2                	lw	a5,12(sp)
  8e:	fe07c5e3          	bltz	a5,78 <test+0x24>
  92:	8522                	mv	a0,s0
  94:	00000097          	auipc	ra,0x0
  98:	f6c080e7          	jalr	-148(ra) # 0 <print_success>
  9c:	bff1                	j	78 <test+0x24>

000000000000009e <main>:
  9e:	7119                	addi	sp,sp,-128
  a0:	fc86                	sd	ra,120(sp)
  a2:	4589                	li	a1,2
  a4:	00001517          	auipc	a0,0x1
  a8:	85450513          	addi	a0,a0,-1964 # 8f8 <malloc+0x128>
  ac:	00000097          	auipc	ra,0x0
  b0:	0cc080e7          	jalr	204(ra) # 178 <open>
  b4:	4501                	li	a0,0
  b6:	00000097          	auipc	ra,0x0
  ba:	0da080e7          	jalr	218(ra) # 190 <dup>
  be:	4501                	li	a0,0
  c0:	00000097          	auipc	ra,0x0
  c4:	0d0080e7          	jalr	208(ra) # 190 <dup>
  c8:	00001797          	auipc	a5,0x1
  cc:	83878793          	addi	a5,a5,-1992 # 900 <malloc+0x130>
  d0:	ecbe                	sd	a5,88(sp)
  d2:	00001797          	auipc	a5,0x1
  d6:	83678793          	addi	a5,a5,-1994 # 908 <malloc+0x138>
  da:	f0be                	sd	a5,96(sp)
  dc:	f482                	sd	zero,104(sp)
  de:	00001797          	auipc	a5,0x1
  e2:	84a78793          	addi	a5,a5,-1974 # 928 <malloc+0x158>
  e6:	e0be                	sd	a5,64(sp)
  e8:	00001797          	auipc	a5,0x1
  ec:	85078793          	addi	a5,a5,-1968 # 938 <malloc+0x168>
  f0:	e4be                	sd	a5,72(sp)
  f2:	e882                	sd	zero,80(sp)
  f4:	00001717          	auipc	a4,0x1
  f8:	85470713          	addi	a4,a4,-1964 # 948 <malloc+0x178>
  fc:	f43a                	sd	a4,40(sp)
  fe:	f83e                	sd	a5,48(sp)
 100:	fc02                	sd	zero,56(sp)
 102:	00001797          	auipc	a5,0x1
 106:	85678793          	addi	a5,a5,-1962 # 958 <malloc+0x188>
 10a:	638c                	ld	a1,0(a5)
 10c:	6790                	ld	a2,8(a5)
 10e:	6b94                	ld	a3,16(a5)
 110:	6f98                	ld	a4,24(a5)
 112:	739c                	ld	a5,32(a5)
 114:	e02e                	sd	a1,0(sp)
 116:	e432                	sd	a2,8(sp)
 118:	e836                	sd	a3,16(sp)
 11a:	ec3a                	sd	a4,24(sp)
 11c:	f03e                	sd	a5,32(sp)
 11e:	08ac                	addi	a1,sp,88
 120:	00001517          	auipc	a0,0x1
 124:	83050513          	addi	a0,a0,-2000 # 950 <malloc+0x180>
 128:	00000097          	auipc	ra,0x0
 12c:	f2c080e7          	jalr	-212(ra) # 54 <test>
 130:	008c                	addi	a1,sp,64
 132:	00001517          	auipc	a0,0x1
 136:	81e50513          	addi	a0,a0,-2018 # 950 <malloc+0x180>
 13a:	00000097          	auipc	ra,0x0
 13e:	f1a080e7          	jalr	-230(ra) # 54 <test>
 142:	102c                	addi	a1,sp,40
 144:	00001517          	auipc	a0,0x1
 148:	80c50513          	addi	a0,a0,-2036 # 950 <malloc+0x180>
 14c:	00000097          	auipc	ra,0x0
 150:	f08080e7          	jalr	-248(ra) # 54 <test>
 154:	858a                	mv	a1,sp
 156:	00000517          	auipc	a0,0x0
 15a:	7fa50513          	addi	a0,a0,2042 # 950 <malloc+0x180>
 15e:	00000097          	auipc	ra,0x0
 162:	ef6080e7          	jalr	-266(ra) # 54 <test>
 166:	a001                	j	166 <main+0xc8>

0000000000000168 <fork>:
 168:	4885                	li	a7,1
 16a:	00000073          	ecall
 16e:	8082                	ret

0000000000000170 <wait>:
 170:	488d                	li	a7,3
 172:	00000073          	ecall
 176:	8082                	ret

0000000000000178 <open>:
 178:	4889                	li	a7,2
 17a:	00000073          	ecall
 17e:	8082                	ret

0000000000000180 <sbrk>:
 180:	4891                	li	a7,4
 182:	00000073          	ecall
 186:	8082                	ret

0000000000000188 <getcwd>:
 188:	48c5                	li	a7,17
 18a:	00000073          	ecall
 18e:	8082                	ret

0000000000000190 <dup>:
 190:	48dd                	li	a7,23
 192:	00000073          	ecall
 196:	8082                	ret

0000000000000198 <dup3>:
 198:	48e1                	li	a7,24
 19a:	00000073          	ecall
 19e:	8082                	ret

00000000000001a0 <mkdirat>:
 1a0:	02200893          	li	a7,34
 1a4:	00000073          	ecall
 1a8:	8082                	ret

00000000000001aa <unlinkat>:
 1aa:	02300893          	li	a7,35
 1ae:	00000073          	ecall
 1b2:	8082                	ret

00000000000001b4 <linkat>:
 1b4:	02500893          	li	a7,37
 1b8:	00000073          	ecall
 1bc:	8082                	ret

00000000000001be <umount2>:
 1be:	02700893          	li	a7,39
 1c2:	00000073          	ecall
 1c6:	8082                	ret

00000000000001c8 <mount>:
 1c8:	02800893          	li	a7,40
 1cc:	00000073          	ecall
 1d0:	8082                	ret

00000000000001d2 <chdir>:
 1d2:	03100893          	li	a7,49
 1d6:	00000073          	ecall
 1da:	8082                	ret

00000000000001dc <openat>:
 1dc:	03800893          	li	a7,56
 1e0:	00000073          	ecall
 1e4:	8082                	ret

00000000000001e6 <close>:
 1e6:	03900893          	li	a7,57
 1ea:	00000073          	ecall
 1ee:	8082                	ret

00000000000001f0 <pipe2>:
 1f0:	03b00893          	li	a7,59
 1f4:	00000073          	ecall
 1f8:	8082                	ret

00000000000001fa <getdents64>:
 1fa:	03d00893          	li	a7,61
 1fe:	00000073          	ecall
 202:	8082                	ret

0000000000000204 <read>:
 204:	03f00893          	li	a7,63
 208:	00000073          	ecall
 20c:	8082                	ret

000000000000020e <write>:
 20e:	04000893          	li	a7,64
 212:	00000073          	ecall
 216:	8082                	ret

0000000000000218 <fstat>:
 218:	05000893          	li	a7,80
 21c:	00000073          	ecall
 220:	8082                	ret

0000000000000222 <exit>:
 222:	05d00893          	li	a7,93
 226:	00000073          	ecall
 22a:	8082                	ret

000000000000022c <nanosleep>:
 22c:	06500893          	li	a7,101
 230:	00000073          	ecall
 234:	8082                	ret

0000000000000236 <sched_yield>:
 236:	07c00893          	li	a7,124
 23a:	00000073          	ecall
 23e:	8082                	ret

0000000000000240 <times>:
 240:	09900893          	li	a7,153
 244:	00000073          	ecall
 248:	8082                	ret

000000000000024a <uname>:
 24a:	0a000893          	li	a7,160
 24e:	00000073          	ecall
 252:	8082                	ret

0000000000000254 <gettimeofday>:
 254:	0a900893          	li	a7,169
 258:	00000073          	ecall
 25c:	8082                	ret

000000000000025e <brk>:
 25e:	0d600893          	li	a7,214
 262:	00000073          	ecall
 266:	8082                	ret

0000000000000268 <munmap>:
 268:	0d700893          	li	a7,215
 26c:	00000073          	ecall
 270:	8082                	ret

0000000000000272 <getpid>:
 272:	0ac00893          	li	a7,172
 276:	00000073          	ecall
 27a:	8082                	ret

000000000000027c <getppid>:
 27c:	0ad00893          	li	a7,173
 280:	00000073          	ecall
 284:	8082                	ret

0000000000000286 <clone>:
 286:	0dc00893          	li	a7,220
 28a:	00000073          	ecall
 28e:	8082                	ret

0000000000000290 <execve>:
 290:	0dd00893          	li	a7,221
 294:	00000073          	ecall
 298:	8082                	ret

000000000000029a <mmap>:
 29a:	0de00893          	li	a7,222
 29e:	00000073          	ecall
 2a2:	8082                	ret

00000000000002a4 <wait4>:
 2a4:	10400893          	li	a7,260
 2a8:	00000073          	ecall
 2ac:	8082                	ret

00000000000002ae <strcpy>:
 2ae:	87aa                	mv	a5,a0
 2b0:	0585                	addi	a1,a1,1
 2b2:	0785                	addi	a5,a5,1
 2b4:	fff5c703          	lbu	a4,-1(a1)
 2b8:	fee78fa3          	sb	a4,-1(a5)
 2bc:	fb75                	bnez	a4,2b0 <strcpy+0x2>
 2be:	8082                	ret

00000000000002c0 <strcmp>:
 2c0:	00054783          	lbu	a5,0(a0)
 2c4:	cb91                	beqz	a5,2d8 <strcmp+0x18>
 2c6:	0005c703          	lbu	a4,0(a1)
 2ca:	00f71763          	bne	a4,a5,2d8 <strcmp+0x18>
 2ce:	0505                	addi	a0,a0,1
 2d0:	0585                	addi	a1,a1,1
 2d2:	00054783          	lbu	a5,0(a0)
 2d6:	fbe5                	bnez	a5,2c6 <strcmp+0x6>
 2d8:	0005c503          	lbu	a0,0(a1)
 2dc:	40a7853b          	subw	a0,a5,a0
 2e0:	8082                	ret

00000000000002e2 <strlen>:
 2e2:	00054783          	lbu	a5,0(a0)
 2e6:	cf81                	beqz	a5,2fe <strlen+0x1c>
 2e8:	0505                	addi	a0,a0,1
 2ea:	87aa                	mv	a5,a0
 2ec:	4685                	li	a3,1
 2ee:	9e89                	subw	a3,a3,a0
 2f0:	00f6853b          	addw	a0,a3,a5
 2f4:	0785                	addi	a5,a5,1
 2f6:	fff7c703          	lbu	a4,-1(a5)
 2fa:	fb7d                	bnez	a4,2f0 <strlen+0xe>
 2fc:	8082                	ret
 2fe:	4501                	li	a0,0
 300:	8082                	ret

0000000000000302 <memset>:
 302:	ce09                	beqz	a2,31c <memset+0x1a>
 304:	87aa                	mv	a5,a0
 306:	fff6071b          	addiw	a4,a2,-1
 30a:	1702                	slli	a4,a4,0x20
 30c:	9301                	srli	a4,a4,0x20
 30e:	0705                	addi	a4,a4,1
 310:	972a                	add	a4,a4,a0
 312:	00b78023          	sb	a1,0(a5)
 316:	0785                	addi	a5,a5,1
 318:	fee79de3          	bne	a5,a4,312 <memset+0x10>
 31c:	8082                	ret

000000000000031e <strchr>:
 31e:	00054783          	lbu	a5,0(a0)
 322:	cb89                	beqz	a5,334 <strchr+0x16>
 324:	00f58963          	beq	a1,a5,336 <strchr+0x18>
 328:	0505                	addi	a0,a0,1
 32a:	00054783          	lbu	a5,0(a0)
 32e:	fbfd                	bnez	a5,324 <strchr+0x6>
 330:	4501                	li	a0,0
 332:	8082                	ret
 334:	4501                	li	a0,0
 336:	8082                	ret

0000000000000338 <gets>:
 338:	715d                	addi	sp,sp,-80
 33a:	e486                	sd	ra,72(sp)
 33c:	e0a2                	sd	s0,64(sp)
 33e:	fc26                	sd	s1,56(sp)
 340:	f84a                	sd	s2,48(sp)
 342:	f44e                	sd	s3,40(sp)
 344:	f052                	sd	s4,32(sp)
 346:	ec56                	sd	s5,24(sp)
 348:	e85a                	sd	s6,16(sp)
 34a:	8b2a                	mv	s6,a0
 34c:	89ae                	mv	s3,a1
 34e:	84aa                	mv	s1,a0
 350:	4401                	li	s0,0
 352:	4a29                	li	s4,10
 354:	4ab5                	li	s5,13
 356:	8922                	mv	s2,s0
 358:	2405                	addiw	s0,s0,1
 35a:	03345863          	bge	s0,s3,38a <gets+0x52>
 35e:	4605                	li	a2,1
 360:	00f10593          	addi	a1,sp,15
 364:	4501                	li	a0,0
 366:	00000097          	auipc	ra,0x0
 36a:	e9e080e7          	jalr	-354(ra) # 204 <read>
 36e:	00a05e63          	blez	a0,38a <gets+0x52>
 372:	00f14783          	lbu	a5,15(sp)
 376:	00f48023          	sb	a5,0(s1)
 37a:	01478763          	beq	a5,s4,388 <gets+0x50>
 37e:	0485                	addi	s1,s1,1
 380:	fd579be3          	bne	a5,s5,356 <gets+0x1e>
 384:	8922                	mv	s2,s0
 386:	a011                	j	38a <gets+0x52>
 388:	8922                	mv	s2,s0
 38a:	995a                	add	s2,s2,s6
 38c:	00090023          	sb	zero,0(s2)
 390:	855a                	mv	a0,s6
 392:	60a6                	ld	ra,72(sp)
 394:	6406                	ld	s0,64(sp)
 396:	74e2                	ld	s1,56(sp)
 398:	7942                	ld	s2,48(sp)
 39a:	79a2                	ld	s3,40(sp)
 39c:	7a02                	ld	s4,32(sp)
 39e:	6ae2                	ld	s5,24(sp)
 3a0:	6b42                	ld	s6,16(sp)
 3a2:	6161                	addi	sp,sp,80
 3a4:	8082                	ret

00000000000003a6 <atoi>:
 3a6:	86aa                	mv	a3,a0
 3a8:	00054603          	lbu	a2,0(a0)
 3ac:	fd06079b          	addiw	a5,a2,-48
 3b0:	0ff7f793          	andi	a5,a5,255
 3b4:	4725                	li	a4,9
 3b6:	02f76663          	bltu	a4,a5,3e2 <atoi+0x3c>
 3ba:	4501                	li	a0,0
 3bc:	45a5                	li	a1,9
 3be:	0685                	addi	a3,a3,1
 3c0:	0025179b          	slliw	a5,a0,0x2
 3c4:	9fa9                	addw	a5,a5,a0
 3c6:	0017979b          	slliw	a5,a5,0x1
 3ca:	9fb1                	addw	a5,a5,a2
 3cc:	fd07851b          	addiw	a0,a5,-48
 3d0:	0006c603          	lbu	a2,0(a3)
 3d4:	fd06071b          	addiw	a4,a2,-48
 3d8:	0ff77713          	andi	a4,a4,255
 3dc:	fee5f1e3          	bgeu	a1,a4,3be <atoi+0x18>
 3e0:	8082                	ret
 3e2:	4501                	li	a0,0
 3e4:	8082                	ret

00000000000003e6 <memmove>:
 3e6:	02b57463          	bgeu	a0,a1,40e <memmove+0x28>
 3ea:	04c05663          	blez	a2,436 <memmove+0x50>
 3ee:	fff6079b          	addiw	a5,a2,-1
 3f2:	1782                	slli	a5,a5,0x20
 3f4:	9381                	srli	a5,a5,0x20
 3f6:	0785                	addi	a5,a5,1
 3f8:	97aa                	add	a5,a5,a0
 3fa:	872a                	mv	a4,a0
 3fc:	0585                	addi	a1,a1,1
 3fe:	0705                	addi	a4,a4,1
 400:	fff5c683          	lbu	a3,-1(a1)
 404:	fed70fa3          	sb	a3,-1(a4)
 408:	fee79ae3          	bne	a5,a4,3fc <memmove+0x16>
 40c:	8082                	ret
 40e:	00c50733          	add	a4,a0,a2
 412:	95b2                	add	a1,a1,a2
 414:	02c05163          	blez	a2,436 <memmove+0x50>
 418:	fff6079b          	addiw	a5,a2,-1
 41c:	1782                	slli	a5,a5,0x20
 41e:	9381                	srli	a5,a5,0x20
 420:	fff7c793          	not	a5,a5
 424:	97ba                	add	a5,a5,a4
 426:	15fd                	addi	a1,a1,-1
 428:	177d                	addi	a4,a4,-1
 42a:	0005c683          	lbu	a3,0(a1)
 42e:	00d70023          	sb	a3,0(a4)
 432:	fee79ae3          	bne	a5,a4,426 <memmove+0x40>
 436:	8082                	ret

0000000000000438 <memcmp>:
 438:	fff6069b          	addiw	a3,a2,-1
 43c:	c605                	beqz	a2,464 <memcmp+0x2c>
 43e:	1682                	slli	a3,a3,0x20
 440:	9281                	srli	a3,a3,0x20
 442:	0685                	addi	a3,a3,1
 444:	96aa                	add	a3,a3,a0
 446:	00054783          	lbu	a5,0(a0)
 44a:	0005c703          	lbu	a4,0(a1)
 44e:	00e79863          	bne	a5,a4,45e <memcmp+0x26>
 452:	0505                	addi	a0,a0,1
 454:	0585                	addi	a1,a1,1
 456:	fed518e3          	bne	a0,a3,446 <memcmp+0xe>
 45a:	4501                	li	a0,0
 45c:	8082                	ret
 45e:	40e7853b          	subw	a0,a5,a4
 462:	8082                	ret
 464:	4501                	li	a0,0
 466:	8082                	ret

0000000000000468 <memcpy>:
 468:	1141                	addi	sp,sp,-16
 46a:	e406                	sd	ra,8(sp)
 46c:	00000097          	auipc	ra,0x0
 470:	f7a080e7          	jalr	-134(ra) # 3e6 <memmove>
 474:	60a2                	ld	ra,8(sp)
 476:	0141                	addi	sp,sp,16
 478:	8082                	ret

000000000000047a <putc>:
 47a:	1101                	addi	sp,sp,-32
 47c:	ec06                	sd	ra,24(sp)
 47e:	00b107a3          	sb	a1,15(sp)
 482:	4605                	li	a2,1
 484:	00f10593          	addi	a1,sp,15
 488:	00000097          	auipc	ra,0x0
 48c:	d86080e7          	jalr	-634(ra) # 20e <write>
 490:	60e2                	ld	ra,24(sp)
 492:	6105                	addi	sp,sp,32
 494:	8082                	ret

0000000000000496 <printint>:
 496:	7179                	addi	sp,sp,-48
 498:	f406                	sd	ra,40(sp)
 49a:	f022                	sd	s0,32(sp)
 49c:	ec26                	sd	s1,24(sp)
 49e:	e84a                	sd	s2,16(sp)
 4a0:	84aa                	mv	s1,a0
 4a2:	c299                	beqz	a3,4a8 <printint+0x12>
 4a4:	0805c363          	bltz	a1,52a <printint+0x94>
 4a8:	2581                	sext.w	a1,a1
 4aa:	4881                	li	a7,0
 4ac:	868a                	mv	a3,sp
 4ae:	4701                	li	a4,0
 4b0:	2601                	sext.w	a2,a2
 4b2:	00000517          	auipc	a0,0x0
 4b6:	4d650513          	addi	a0,a0,1238 # 988 <digits>
 4ba:	883a                	mv	a6,a4
 4bc:	2705                	addiw	a4,a4,1
 4be:	02c5f7bb          	remuw	a5,a1,a2
 4c2:	1782                	slli	a5,a5,0x20
 4c4:	9381                	srli	a5,a5,0x20
 4c6:	97aa                	add	a5,a5,a0
 4c8:	0007c783          	lbu	a5,0(a5)
 4cc:	00f68023          	sb	a5,0(a3)
 4d0:	0005879b          	sext.w	a5,a1
 4d4:	02c5d5bb          	divuw	a1,a1,a2
 4d8:	0685                	addi	a3,a3,1
 4da:	fec7f0e3          	bgeu	a5,a2,4ba <printint+0x24>
 4de:	00088a63          	beqz	a7,4f2 <printint+0x5c>
 4e2:	081c                	addi	a5,sp,16
 4e4:	973e                	add	a4,a4,a5
 4e6:	02d00793          	li	a5,45
 4ea:	fef70823          	sb	a5,-16(a4)
 4ee:	0028071b          	addiw	a4,a6,2
 4f2:	02e05663          	blez	a4,51e <printint+0x88>
 4f6:	00e10433          	add	s0,sp,a4
 4fa:	fff10913          	addi	s2,sp,-1
 4fe:	993a                	add	s2,s2,a4
 500:	377d                	addiw	a4,a4,-1
 502:	1702                	slli	a4,a4,0x20
 504:	9301                	srli	a4,a4,0x20
 506:	40e90933          	sub	s2,s2,a4
 50a:	fff44583          	lbu	a1,-1(s0)
 50e:	8526                	mv	a0,s1
 510:	00000097          	auipc	ra,0x0
 514:	f6a080e7          	jalr	-150(ra) # 47a <putc>
 518:	147d                	addi	s0,s0,-1
 51a:	ff2418e3          	bne	s0,s2,50a <printint+0x74>
 51e:	70a2                	ld	ra,40(sp)
 520:	7402                	ld	s0,32(sp)
 522:	64e2                	ld	s1,24(sp)
 524:	6942                	ld	s2,16(sp)
 526:	6145                	addi	sp,sp,48
 528:	8082                	ret
 52a:	40b005bb          	negw	a1,a1
 52e:	4885                	li	a7,1
 530:	bfb5                	j	4ac <printint+0x16>

0000000000000532 <vprintf>:
 532:	7119                	addi	sp,sp,-128
 534:	fc86                	sd	ra,120(sp)
 536:	f8a2                	sd	s0,112(sp)
 538:	f4a6                	sd	s1,104(sp)
 53a:	f0ca                	sd	s2,96(sp)
 53c:	ecce                	sd	s3,88(sp)
 53e:	e8d2                	sd	s4,80(sp)
 540:	e4d6                	sd	s5,72(sp)
 542:	e0da                	sd	s6,64(sp)
 544:	fc5e                	sd	s7,56(sp)
 546:	f862                	sd	s8,48(sp)
 548:	f466                	sd	s9,40(sp)
 54a:	f06a                	sd	s10,32(sp)
 54c:	ec6e                	sd	s11,24(sp)
 54e:	0005c483          	lbu	s1,0(a1)
 552:	18048c63          	beqz	s1,6ea <vprintf+0x1b8>
 556:	8a2a                	mv	s4,a0
 558:	8ab2                	mv	s5,a2
 55a:	00158413          	addi	s0,a1,1
 55e:	4901                	li	s2,0
 560:	02500993          	li	s3,37
 564:	06400b93          	li	s7,100
 568:	06c00c13          	li	s8,108
 56c:	07800c93          	li	s9,120
 570:	07000d13          	li	s10,112
 574:	07300d93          	li	s11,115
 578:	00000b17          	auipc	s6,0x0
 57c:	410b0b13          	addi	s6,s6,1040 # 988 <digits>
 580:	a839                	j	59e <vprintf+0x6c>
 582:	85a6                	mv	a1,s1
 584:	8552                	mv	a0,s4
 586:	00000097          	auipc	ra,0x0
 58a:	ef4080e7          	jalr	-268(ra) # 47a <putc>
 58e:	a019                	j	594 <vprintf+0x62>
 590:	01390f63          	beq	s2,s3,5ae <vprintf+0x7c>
 594:	0405                	addi	s0,s0,1
 596:	fff44483          	lbu	s1,-1(s0)
 59a:	14048863          	beqz	s1,6ea <vprintf+0x1b8>
 59e:	0004879b          	sext.w	a5,s1
 5a2:	fe0917e3          	bnez	s2,590 <vprintf+0x5e>
 5a6:	fd379ee3          	bne	a5,s3,582 <vprintf+0x50>
 5aa:	893e                	mv	s2,a5
 5ac:	b7e5                	j	594 <vprintf+0x62>
 5ae:	03778e63          	beq	a5,s7,5ea <vprintf+0xb8>
 5b2:	05878a63          	beq	a5,s8,606 <vprintf+0xd4>
 5b6:	07978663          	beq	a5,s9,622 <vprintf+0xf0>
 5ba:	09a78263          	beq	a5,s10,63e <vprintf+0x10c>
 5be:	0db78363          	beq	a5,s11,684 <vprintf+0x152>
 5c2:	06300713          	li	a4,99
 5c6:	0ee78b63          	beq	a5,a4,6bc <vprintf+0x18a>
 5ca:	11378563          	beq	a5,s3,6d4 <vprintf+0x1a2>
 5ce:	85ce                	mv	a1,s3
 5d0:	8552                	mv	a0,s4
 5d2:	00000097          	auipc	ra,0x0
 5d6:	ea8080e7          	jalr	-344(ra) # 47a <putc>
 5da:	85a6                	mv	a1,s1
 5dc:	8552                	mv	a0,s4
 5de:	00000097          	auipc	ra,0x0
 5e2:	e9c080e7          	jalr	-356(ra) # 47a <putc>
 5e6:	4901                	li	s2,0
 5e8:	b775                	j	594 <vprintf+0x62>
 5ea:	008a8493          	addi	s1,s5,8
 5ee:	4685                	li	a3,1
 5f0:	4629                	li	a2,10
 5f2:	000aa583          	lw	a1,0(s5)
 5f6:	8552                	mv	a0,s4
 5f8:	00000097          	auipc	ra,0x0
 5fc:	e9e080e7          	jalr	-354(ra) # 496 <printint>
 600:	8aa6                	mv	s5,s1
 602:	4901                	li	s2,0
 604:	bf41                	j	594 <vprintf+0x62>
 606:	008a8493          	addi	s1,s5,8
 60a:	4681                	li	a3,0
 60c:	4629                	li	a2,10
 60e:	000aa583          	lw	a1,0(s5)
 612:	8552                	mv	a0,s4
 614:	00000097          	auipc	ra,0x0
 618:	e82080e7          	jalr	-382(ra) # 496 <printint>
 61c:	8aa6                	mv	s5,s1
 61e:	4901                	li	s2,0
 620:	bf95                	j	594 <vprintf+0x62>
 622:	008a8493          	addi	s1,s5,8
 626:	4681                	li	a3,0
 628:	4641                	li	a2,16
 62a:	000aa583          	lw	a1,0(s5)
 62e:	8552                	mv	a0,s4
 630:	00000097          	auipc	ra,0x0
 634:	e66080e7          	jalr	-410(ra) # 496 <printint>
 638:	8aa6                	mv	s5,s1
 63a:	4901                	li	s2,0
 63c:	bfa1                	j	594 <vprintf+0x62>
 63e:	008a8793          	addi	a5,s5,8
 642:	e43e                	sd	a5,8(sp)
 644:	000ab903          	ld	s2,0(s5)
 648:	03000593          	li	a1,48
 64c:	8552                	mv	a0,s4
 64e:	00000097          	auipc	ra,0x0
 652:	e2c080e7          	jalr	-468(ra) # 47a <putc>
 656:	85e6                	mv	a1,s9
 658:	8552                	mv	a0,s4
 65a:	00000097          	auipc	ra,0x0
 65e:	e20080e7          	jalr	-480(ra) # 47a <putc>
 662:	44c1                	li	s1,16
 664:	03c95793          	srli	a5,s2,0x3c
 668:	97da                	add	a5,a5,s6
 66a:	0007c583          	lbu	a1,0(a5)
 66e:	8552                	mv	a0,s4
 670:	00000097          	auipc	ra,0x0
 674:	e0a080e7          	jalr	-502(ra) # 47a <putc>
 678:	0912                	slli	s2,s2,0x4
 67a:	34fd                	addiw	s1,s1,-1
 67c:	f4e5                	bnez	s1,664 <vprintf+0x132>
 67e:	6aa2                	ld	s5,8(sp)
 680:	4901                	li	s2,0
 682:	bf09                	j	594 <vprintf+0x62>
 684:	008a8493          	addi	s1,s5,8
 688:	000ab903          	ld	s2,0(s5)
 68c:	02090163          	beqz	s2,6ae <vprintf+0x17c>
 690:	00094583          	lbu	a1,0(s2)
 694:	c9a1                	beqz	a1,6e4 <vprintf+0x1b2>
 696:	8552                	mv	a0,s4
 698:	00000097          	auipc	ra,0x0
 69c:	de2080e7          	jalr	-542(ra) # 47a <putc>
 6a0:	0905                	addi	s2,s2,1
 6a2:	00094583          	lbu	a1,0(s2)
 6a6:	f9e5                	bnez	a1,696 <vprintf+0x164>
 6a8:	8aa6                	mv	s5,s1
 6aa:	4901                	li	s2,0
 6ac:	b5e5                	j	594 <vprintf+0x62>
 6ae:	00000917          	auipc	s2,0x0
 6b2:	2d290913          	addi	s2,s2,722 # 980 <malloc+0x1b0>
 6b6:	02800593          	li	a1,40
 6ba:	bff1                	j	696 <vprintf+0x164>
 6bc:	008a8493          	addi	s1,s5,8
 6c0:	000ac583          	lbu	a1,0(s5)
 6c4:	8552                	mv	a0,s4
 6c6:	00000097          	auipc	ra,0x0
 6ca:	db4080e7          	jalr	-588(ra) # 47a <putc>
 6ce:	8aa6                	mv	s5,s1
 6d0:	4901                	li	s2,0
 6d2:	b5c9                	j	594 <vprintf+0x62>
 6d4:	85ce                	mv	a1,s3
 6d6:	8552                	mv	a0,s4
 6d8:	00000097          	auipc	ra,0x0
 6dc:	da2080e7          	jalr	-606(ra) # 47a <putc>
 6e0:	4901                	li	s2,0
 6e2:	bd4d                	j	594 <vprintf+0x62>
 6e4:	8aa6                	mv	s5,s1
 6e6:	4901                	li	s2,0
 6e8:	b575                	j	594 <vprintf+0x62>
 6ea:	70e6                	ld	ra,120(sp)
 6ec:	7446                	ld	s0,112(sp)
 6ee:	74a6                	ld	s1,104(sp)
 6f0:	7906                	ld	s2,96(sp)
 6f2:	69e6                	ld	s3,88(sp)
 6f4:	6a46                	ld	s4,80(sp)
 6f6:	6aa6                	ld	s5,72(sp)
 6f8:	6b06                	ld	s6,64(sp)
 6fa:	7be2                	ld	s7,56(sp)
 6fc:	7c42                	ld	s8,48(sp)
 6fe:	7ca2                	ld	s9,40(sp)
 700:	7d02                	ld	s10,32(sp)
 702:	6de2                	ld	s11,24(sp)
 704:	6109                	addi	sp,sp,128
 706:	8082                	ret

0000000000000708 <fprintf>:
 708:	715d                	addi	sp,sp,-80
 70a:	ec06                	sd	ra,24(sp)
 70c:	f032                	sd	a2,32(sp)
 70e:	f436                	sd	a3,40(sp)
 710:	f83a                	sd	a4,48(sp)
 712:	fc3e                	sd	a5,56(sp)
 714:	e0c2                	sd	a6,64(sp)
 716:	e4c6                	sd	a7,72(sp)
 718:	1010                	addi	a2,sp,32
 71a:	e432                	sd	a2,8(sp)
 71c:	00000097          	auipc	ra,0x0
 720:	e16080e7          	jalr	-490(ra) # 532 <vprintf>
 724:	60e2                	ld	ra,24(sp)
 726:	6161                	addi	sp,sp,80
 728:	8082                	ret

000000000000072a <printf>:
 72a:	711d                	addi	sp,sp,-96
 72c:	ec06                	sd	ra,24(sp)
 72e:	f42e                	sd	a1,40(sp)
 730:	f832                	sd	a2,48(sp)
 732:	fc36                	sd	a3,56(sp)
 734:	e0ba                	sd	a4,64(sp)
 736:	e4be                	sd	a5,72(sp)
 738:	e8c2                	sd	a6,80(sp)
 73a:	ecc6                	sd	a7,88(sp)
 73c:	1030                	addi	a2,sp,40
 73e:	e432                	sd	a2,8(sp)
 740:	85aa                	mv	a1,a0
 742:	4505                	li	a0,1
 744:	00000097          	auipc	ra,0x0
 748:	dee080e7          	jalr	-530(ra) # 532 <vprintf>
 74c:	60e2                	ld	ra,24(sp)
 74e:	6125                	addi	sp,sp,96
 750:	8082                	ret

0000000000000752 <free>:
 752:	ff050693          	addi	a3,a0,-16
 756:	00000797          	auipc	a5,0x0
 75a:	24a7b783          	ld	a5,586(a5) # 9a0 <freep>
 75e:	a805                	j	78e <free+0x3c>
 760:	4618                	lw	a4,8(a2)
 762:	9db9                	addw	a1,a1,a4
 764:	feb52c23          	sw	a1,-8(a0)
 768:	6398                	ld	a4,0(a5)
 76a:	6318                	ld	a4,0(a4)
 76c:	fee53823          	sd	a4,-16(a0)
 770:	a091                	j	7b4 <free+0x62>
 772:	ff852703          	lw	a4,-8(a0)
 776:	9e39                	addw	a2,a2,a4
 778:	c790                	sw	a2,8(a5)
 77a:	ff053703          	ld	a4,-16(a0)
 77e:	e398                	sd	a4,0(a5)
 780:	a099                	j	7c6 <free+0x74>
 782:	6398                	ld	a4,0(a5)
 784:	00e7e463          	bltu	a5,a4,78c <free+0x3a>
 788:	00e6ea63          	bltu	a3,a4,79c <free+0x4a>
 78c:	87ba                	mv	a5,a4
 78e:	fed7fae3          	bgeu	a5,a3,782 <free+0x30>
 792:	6398                	ld	a4,0(a5)
 794:	00e6e463          	bltu	a3,a4,79c <free+0x4a>
 798:	fee7eae3          	bltu	a5,a4,78c <free+0x3a>
 79c:	ff852583          	lw	a1,-8(a0)
 7a0:	6390                	ld	a2,0(a5)
 7a2:	02059713          	slli	a4,a1,0x20
 7a6:	9301                	srli	a4,a4,0x20
 7a8:	0712                	slli	a4,a4,0x4
 7aa:	9736                	add	a4,a4,a3
 7ac:	fae60ae3          	beq	a2,a4,760 <free+0xe>
 7b0:	fec53823          	sd	a2,-16(a0)
 7b4:	4790                	lw	a2,8(a5)
 7b6:	02061713          	slli	a4,a2,0x20
 7ba:	9301                	srli	a4,a4,0x20
 7bc:	0712                	slli	a4,a4,0x4
 7be:	973e                	add	a4,a4,a5
 7c0:	fae689e3          	beq	a3,a4,772 <free+0x20>
 7c4:	e394                	sd	a3,0(a5)
 7c6:	00000717          	auipc	a4,0x0
 7ca:	1cf73d23          	sd	a5,474(a4) # 9a0 <freep>
 7ce:	8082                	ret

00000000000007d0 <malloc>:
 7d0:	7139                	addi	sp,sp,-64
 7d2:	fc06                	sd	ra,56(sp)
 7d4:	f822                	sd	s0,48(sp)
 7d6:	f426                	sd	s1,40(sp)
 7d8:	f04a                	sd	s2,32(sp)
 7da:	ec4e                	sd	s3,24(sp)
 7dc:	e852                	sd	s4,16(sp)
 7de:	e456                	sd	s5,8(sp)
 7e0:	02051413          	slli	s0,a0,0x20
 7e4:	9001                	srli	s0,s0,0x20
 7e6:	043d                	addi	s0,s0,15
 7e8:	8011                	srli	s0,s0,0x4
 7ea:	0014091b          	addiw	s2,s0,1
 7ee:	0405                	addi	s0,s0,1
 7f0:	00000517          	auipc	a0,0x0
 7f4:	1b053503          	ld	a0,432(a0) # 9a0 <freep>
 7f8:	c905                	beqz	a0,828 <malloc+0x58>
 7fa:	611c                	ld	a5,0(a0)
 7fc:	4798                	lw	a4,8(a5)
 7fe:	04877163          	bgeu	a4,s0,840 <malloc+0x70>
 802:	89ca                	mv	s3,s2
 804:	0009071b          	sext.w	a4,s2
 808:	6685                	lui	a3,0x1
 80a:	00d77363          	bgeu	a4,a3,810 <malloc+0x40>
 80e:	6985                	lui	s3,0x1
 810:	00098a1b          	sext.w	s4,s3
 814:	1982                	slli	s3,s3,0x20
 816:	0209d993          	srli	s3,s3,0x20
 81a:	0992                	slli	s3,s3,0x4
 81c:	00000497          	auipc	s1,0x0
 820:	18448493          	addi	s1,s1,388 # 9a0 <freep>
 824:	5afd                	li	s5,-1
 826:	a0bd                	j	894 <malloc+0xc4>
 828:	00000797          	auipc	a5,0x0
 82c:	18078793          	addi	a5,a5,384 # 9a8 <base>
 830:	00000717          	auipc	a4,0x0
 834:	16f73823          	sd	a5,368(a4) # 9a0 <freep>
 838:	e39c                	sd	a5,0(a5)
 83a:	0007a423          	sw	zero,8(a5)
 83e:	b7d1                	j	802 <malloc+0x32>
 840:	02e40a63          	beq	s0,a4,874 <malloc+0xa4>
 844:	4127073b          	subw	a4,a4,s2
 848:	c798                	sw	a4,8(a5)
 84a:	1702                	slli	a4,a4,0x20
 84c:	9301                	srli	a4,a4,0x20
 84e:	0712                	slli	a4,a4,0x4
 850:	97ba                	add	a5,a5,a4
 852:	0127a423          	sw	s2,8(a5)
 856:	00000717          	auipc	a4,0x0
 85a:	14a73523          	sd	a0,330(a4) # 9a0 <freep>
 85e:	01078513          	addi	a0,a5,16
 862:	70e2                	ld	ra,56(sp)
 864:	7442                	ld	s0,48(sp)
 866:	74a2                	ld	s1,40(sp)
 868:	7902                	ld	s2,32(sp)
 86a:	69e2                	ld	s3,24(sp)
 86c:	6a42                	ld	s4,16(sp)
 86e:	6aa2                	ld	s5,8(sp)
 870:	6121                	addi	sp,sp,64
 872:	8082                	ret
 874:	6398                	ld	a4,0(a5)
 876:	e118                	sd	a4,0(a0)
 878:	bff9                	j	856 <malloc+0x86>
 87a:	01452423          	sw	s4,8(a0)
 87e:	0541                	addi	a0,a0,16
 880:	00000097          	auipc	ra,0x0
 884:	ed2080e7          	jalr	-302(ra) # 752 <free>
 888:	6088                	ld	a0,0(s1)
 88a:	dd61                	beqz	a0,862 <malloc+0x92>
 88c:	611c                	ld	a5,0(a0)
 88e:	4798                	lw	a4,8(a5)
 890:	fa8778e3          	bgeu	a4,s0,840 <malloc+0x70>
 894:	6098                	ld	a4,0(s1)
 896:	853e                	mv	a0,a5
 898:	fef71ae3          	bne	a4,a5,88c <malloc+0xbc>
 89c:	854e                	mv	a0,s3
 89e:	00000097          	auipc	ra,0x0
 8a2:	8e2080e7          	jalr	-1822(ra) # 180 <sbrk>
 8a6:	fd551ae3          	bne	a0,s5,87a <malloc+0xaa>
 8aa:	4501                	li	a0,0
 8ac:	bf5d                	j	862 <malloc+0x92>
