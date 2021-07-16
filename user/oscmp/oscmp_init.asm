
_oscmp_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_success>:
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	842a                	mv	s0,a0
   a:	00001517          	auipc	a0,0x1
   e:	86e50513          	addi	a0,a0,-1938 # 878 <malloc+0xf6>
  12:	00000097          	auipc	ra,0x0
  16:	6ca080e7          	jalr	1738(ra) # 6dc <printf>
  1a:	600c                	ld	a1,0(s0)
  1c:	cd99                	beqz	a1,3a <print_success+0x3a>
  1e:	0421                	addi	s0,s0,8
  20:	00001497          	auipc	s1,0x1
  24:	87048493          	addi	s1,s1,-1936 # 890 <malloc+0x10e>
  28:	8526                	mv	a0,s1
  2a:	00000097          	auipc	ra,0x0
  2e:	6b2080e7          	jalr	1714(ra) # 6dc <printf>
  32:	0421                	addi	s0,s0,8
  34:	ff843583          	ld	a1,-8(s0)
  38:	f9e5                	bnez	a1,28 <print_success+0x28>
  3a:	00001517          	auipc	a0,0x1
  3e:	85e50513          	addi	a0,a0,-1954 # 898 <malloc+0x116>
  42:	00000097          	auipc	ra,0x0
  46:	69a080e7          	jalr	1690(ra) # 6dc <printf>
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
  64:	0ba080e7          	jalr	186(ra) # 11a <fork>
  68:	ed09                	bnez	a0,82 <test+0x2e>
  6a:	4601                	li	a2,0
  6c:	85a2                	mv	a1,s0
  6e:	8526                	mv	a0,s1
  70:	00000097          	auipc	ra,0x0
  74:	1d2080e7          	jalr	466(ra) # 242 <execve>
  78:	70a2                	ld	ra,40(sp)
  7a:	7402                	ld	s0,32(sp)
  7c:	64e2                	ld	s1,24(sp)
  7e:	6145                	addi	sp,sp,48
  80:	8082                	ret
  82:	0068                	addi	a0,sp,12
  84:	00000097          	auipc	ra,0x0
  88:	09e080e7          	jalr	158(ra) # 122 <wait>
  8c:	47b2                	lw	a5,12(sp)
  8e:	fe07c5e3          	bltz	a5,78 <test+0x24>
  92:	8522                	mv	a0,s0
  94:	00000097          	auipc	ra,0x0
  98:	f6c080e7          	jalr	-148(ra) # 0 <print_success>
  9c:	bff1                	j	78 <test+0x24>

000000000000009e <main>:
  9e:	7139                	addi	sp,sp,-64
  a0:	fc06                	sd	ra,56(sp)
  a2:	4589                	li	a1,2
  a4:	00001517          	auipc	a0,0x1
  a8:	80450513          	addi	a0,a0,-2044 # 8a8 <malloc+0x126>
  ac:	00000097          	auipc	ra,0x0
  b0:	07e080e7          	jalr	126(ra) # 12a <open>
  b4:	4501                	li	a0,0
  b6:	00000097          	auipc	ra,0x0
  ba:	08c080e7          	jalr	140(ra) # 142 <dup>
  be:	4501                	li	a0,0
  c0:	00000097          	auipc	ra,0x0
  c4:	082080e7          	jalr	130(ra) # 142 <dup>
  c8:	00000797          	auipc	a5,0x0
  cc:	7e878793          	addi	a5,a5,2024 # 8b0 <malloc+0x12e>
  d0:	ec3e                	sd	a5,24(sp)
  d2:	00000797          	auipc	a5,0x0
  d6:	7e678793          	addi	a5,a5,2022 # 8b8 <malloc+0x136>
  da:	f03e                	sd	a5,32(sp)
  dc:	f402                	sd	zero,40(sp)
  de:	00000797          	auipc	a5,0x0
  e2:	7fa78793          	addi	a5,a5,2042 # 8d8 <malloc+0x156>
  e6:	e03e                	sd	a5,0(sp)
  e8:	00001797          	auipc	a5,0x1
  ec:	80078793          	addi	a5,a5,-2048 # 8e8 <malloc+0x166>
  f0:	e43e                	sd	a5,8(sp)
  f2:	e802                	sd	zero,16(sp)
  f4:	082c                	addi	a1,sp,24
  f6:	00001517          	auipc	a0,0x1
  fa:	80250513          	addi	a0,a0,-2046 # 8f8 <malloc+0x176>
  fe:	00000097          	auipc	ra,0x0
 102:	f56080e7          	jalr	-170(ra) # 54 <test>
 106:	858a                	mv	a1,sp
 108:	00000517          	auipc	a0,0x0
 10c:	7f050513          	addi	a0,a0,2032 # 8f8 <malloc+0x176>
 110:	00000097          	auipc	ra,0x0
 114:	f44080e7          	jalr	-188(ra) # 54 <test>
 118:	a001                	j	118 <main+0x7a>

000000000000011a <fork>:
 11a:	4885                	li	a7,1
 11c:	00000073          	ecall
 120:	8082                	ret

0000000000000122 <wait>:
 122:	488d                	li	a7,3
 124:	00000073          	ecall
 128:	8082                	ret

000000000000012a <open>:
 12a:	4889                	li	a7,2
 12c:	00000073          	ecall
 130:	8082                	ret

0000000000000132 <sbrk>:
 132:	4891                	li	a7,4
 134:	00000073          	ecall
 138:	8082                	ret

000000000000013a <getcwd>:
 13a:	48c5                	li	a7,17
 13c:	00000073          	ecall
 140:	8082                	ret

0000000000000142 <dup>:
 142:	48dd                	li	a7,23
 144:	00000073          	ecall
 148:	8082                	ret

000000000000014a <dup3>:
 14a:	48e1                	li	a7,24
 14c:	00000073          	ecall
 150:	8082                	ret

0000000000000152 <mkdirat>:
 152:	02200893          	li	a7,34
 156:	00000073          	ecall
 15a:	8082                	ret

000000000000015c <unlinkat>:
 15c:	02300893          	li	a7,35
 160:	00000073          	ecall
 164:	8082                	ret

0000000000000166 <linkat>:
 166:	02500893          	li	a7,37
 16a:	00000073          	ecall
 16e:	8082                	ret

0000000000000170 <umount2>:
 170:	02700893          	li	a7,39
 174:	00000073          	ecall
 178:	8082                	ret

000000000000017a <mount>:
 17a:	02800893          	li	a7,40
 17e:	00000073          	ecall
 182:	8082                	ret

0000000000000184 <chdir>:
 184:	03100893          	li	a7,49
 188:	00000073          	ecall
 18c:	8082                	ret

000000000000018e <openat>:
 18e:	03800893          	li	a7,56
 192:	00000073          	ecall
 196:	8082                	ret

0000000000000198 <close>:
 198:	03900893          	li	a7,57
 19c:	00000073          	ecall
 1a0:	8082                	ret

00000000000001a2 <pipe2>:
 1a2:	03b00893          	li	a7,59
 1a6:	00000073          	ecall
 1aa:	8082                	ret

00000000000001ac <getdents64>:
 1ac:	03d00893          	li	a7,61
 1b0:	00000073          	ecall
 1b4:	8082                	ret

00000000000001b6 <read>:
 1b6:	03f00893          	li	a7,63
 1ba:	00000073          	ecall
 1be:	8082                	ret

00000000000001c0 <write>:
 1c0:	04000893          	li	a7,64
 1c4:	00000073          	ecall
 1c8:	8082                	ret

00000000000001ca <fstat>:
 1ca:	05000893          	li	a7,80
 1ce:	00000073          	ecall
 1d2:	8082                	ret

00000000000001d4 <exit>:
 1d4:	05d00893          	li	a7,93
 1d8:	00000073          	ecall
 1dc:	8082                	ret

00000000000001de <nanosleep>:
 1de:	06500893          	li	a7,101
 1e2:	00000073          	ecall
 1e6:	8082                	ret

00000000000001e8 <sched_yield>:
 1e8:	07c00893          	li	a7,124
 1ec:	00000073          	ecall
 1f0:	8082                	ret

00000000000001f2 <times>:
 1f2:	09900893          	li	a7,153
 1f6:	00000073          	ecall
 1fa:	8082                	ret

00000000000001fc <uname>:
 1fc:	0a000893          	li	a7,160
 200:	00000073          	ecall
 204:	8082                	ret

0000000000000206 <gettimeofday>:
 206:	0a900893          	li	a7,169
 20a:	00000073          	ecall
 20e:	8082                	ret

0000000000000210 <brk>:
 210:	0d600893          	li	a7,214
 214:	00000073          	ecall
 218:	8082                	ret

000000000000021a <munmap>:
 21a:	0d700893          	li	a7,215
 21e:	00000073          	ecall
 222:	8082                	ret

0000000000000224 <getpid>:
 224:	0ac00893          	li	a7,172
 228:	00000073          	ecall
 22c:	8082                	ret

000000000000022e <getppid>:
 22e:	0ad00893          	li	a7,173
 232:	00000073          	ecall
 236:	8082                	ret

0000000000000238 <clone>:
 238:	0dc00893          	li	a7,220
 23c:	00000073          	ecall
 240:	8082                	ret

0000000000000242 <execve>:
 242:	0dd00893          	li	a7,221
 246:	00000073          	ecall
 24a:	8082                	ret

000000000000024c <mmap>:
 24c:	0de00893          	li	a7,222
 250:	00000073          	ecall
 254:	8082                	ret

0000000000000256 <wait4>:
 256:	10400893          	li	a7,260
 25a:	00000073          	ecall
 25e:	8082                	ret

0000000000000260 <strcpy>:
 260:	87aa                	mv	a5,a0
 262:	0585                	addi	a1,a1,1
 264:	0785                	addi	a5,a5,1
 266:	fff5c703          	lbu	a4,-1(a1)
 26a:	fee78fa3          	sb	a4,-1(a5)
 26e:	fb75                	bnez	a4,262 <strcpy+0x2>
 270:	8082                	ret

0000000000000272 <strcmp>:
 272:	00054783          	lbu	a5,0(a0)
 276:	cb91                	beqz	a5,28a <strcmp+0x18>
 278:	0005c703          	lbu	a4,0(a1)
 27c:	00f71763          	bne	a4,a5,28a <strcmp+0x18>
 280:	0505                	addi	a0,a0,1
 282:	0585                	addi	a1,a1,1
 284:	00054783          	lbu	a5,0(a0)
 288:	fbe5                	bnez	a5,278 <strcmp+0x6>
 28a:	0005c503          	lbu	a0,0(a1)
 28e:	40a7853b          	subw	a0,a5,a0
 292:	8082                	ret

0000000000000294 <strlen>:
 294:	00054783          	lbu	a5,0(a0)
 298:	cf81                	beqz	a5,2b0 <strlen+0x1c>
 29a:	0505                	addi	a0,a0,1
 29c:	87aa                	mv	a5,a0
 29e:	4685                	li	a3,1
 2a0:	9e89                	subw	a3,a3,a0
 2a2:	00f6853b          	addw	a0,a3,a5
 2a6:	0785                	addi	a5,a5,1
 2a8:	fff7c703          	lbu	a4,-1(a5)
 2ac:	fb7d                	bnez	a4,2a2 <strlen+0xe>
 2ae:	8082                	ret
 2b0:	4501                	li	a0,0
 2b2:	8082                	ret

00000000000002b4 <memset>:
 2b4:	ce09                	beqz	a2,2ce <memset+0x1a>
 2b6:	87aa                	mv	a5,a0
 2b8:	fff6071b          	addiw	a4,a2,-1
 2bc:	1702                	slli	a4,a4,0x20
 2be:	9301                	srli	a4,a4,0x20
 2c0:	0705                	addi	a4,a4,1
 2c2:	972a                	add	a4,a4,a0
 2c4:	00b78023          	sb	a1,0(a5)
 2c8:	0785                	addi	a5,a5,1
 2ca:	fee79de3          	bne	a5,a4,2c4 <memset+0x10>
 2ce:	8082                	ret

00000000000002d0 <strchr>:
 2d0:	00054783          	lbu	a5,0(a0)
 2d4:	cb89                	beqz	a5,2e6 <strchr+0x16>
 2d6:	00f58963          	beq	a1,a5,2e8 <strchr+0x18>
 2da:	0505                	addi	a0,a0,1
 2dc:	00054783          	lbu	a5,0(a0)
 2e0:	fbfd                	bnez	a5,2d6 <strchr+0x6>
 2e2:	4501                	li	a0,0
 2e4:	8082                	ret
 2e6:	4501                	li	a0,0
 2e8:	8082                	ret

00000000000002ea <gets>:
 2ea:	715d                	addi	sp,sp,-80
 2ec:	e486                	sd	ra,72(sp)
 2ee:	e0a2                	sd	s0,64(sp)
 2f0:	fc26                	sd	s1,56(sp)
 2f2:	f84a                	sd	s2,48(sp)
 2f4:	f44e                	sd	s3,40(sp)
 2f6:	f052                	sd	s4,32(sp)
 2f8:	ec56                	sd	s5,24(sp)
 2fa:	e85a                	sd	s6,16(sp)
 2fc:	8b2a                	mv	s6,a0
 2fe:	89ae                	mv	s3,a1
 300:	84aa                	mv	s1,a0
 302:	4401                	li	s0,0
 304:	4a29                	li	s4,10
 306:	4ab5                	li	s5,13
 308:	8922                	mv	s2,s0
 30a:	2405                	addiw	s0,s0,1
 30c:	03345863          	bge	s0,s3,33c <gets+0x52>
 310:	4605                	li	a2,1
 312:	00f10593          	addi	a1,sp,15
 316:	4501                	li	a0,0
 318:	00000097          	auipc	ra,0x0
 31c:	e9e080e7          	jalr	-354(ra) # 1b6 <read>
 320:	00a05e63          	blez	a0,33c <gets+0x52>
 324:	00f14783          	lbu	a5,15(sp)
 328:	00f48023          	sb	a5,0(s1)
 32c:	01478763          	beq	a5,s4,33a <gets+0x50>
 330:	0485                	addi	s1,s1,1
 332:	fd579be3          	bne	a5,s5,308 <gets+0x1e>
 336:	8922                	mv	s2,s0
 338:	a011                	j	33c <gets+0x52>
 33a:	8922                	mv	s2,s0
 33c:	995a                	add	s2,s2,s6
 33e:	00090023          	sb	zero,0(s2)
 342:	855a                	mv	a0,s6
 344:	60a6                	ld	ra,72(sp)
 346:	6406                	ld	s0,64(sp)
 348:	74e2                	ld	s1,56(sp)
 34a:	7942                	ld	s2,48(sp)
 34c:	79a2                	ld	s3,40(sp)
 34e:	7a02                	ld	s4,32(sp)
 350:	6ae2                	ld	s5,24(sp)
 352:	6b42                	ld	s6,16(sp)
 354:	6161                	addi	sp,sp,80
 356:	8082                	ret

0000000000000358 <atoi>:
 358:	86aa                	mv	a3,a0
 35a:	00054603          	lbu	a2,0(a0)
 35e:	fd06079b          	addiw	a5,a2,-48
 362:	0ff7f793          	andi	a5,a5,255
 366:	4725                	li	a4,9
 368:	02f76663          	bltu	a4,a5,394 <atoi+0x3c>
 36c:	4501                	li	a0,0
 36e:	45a5                	li	a1,9
 370:	0685                	addi	a3,a3,1
 372:	0025179b          	slliw	a5,a0,0x2
 376:	9fa9                	addw	a5,a5,a0
 378:	0017979b          	slliw	a5,a5,0x1
 37c:	9fb1                	addw	a5,a5,a2
 37e:	fd07851b          	addiw	a0,a5,-48
 382:	0006c603          	lbu	a2,0(a3)
 386:	fd06071b          	addiw	a4,a2,-48
 38a:	0ff77713          	andi	a4,a4,255
 38e:	fee5f1e3          	bgeu	a1,a4,370 <atoi+0x18>
 392:	8082                	ret
 394:	4501                	li	a0,0
 396:	8082                	ret

0000000000000398 <memmove>:
 398:	02b57463          	bgeu	a0,a1,3c0 <memmove+0x28>
 39c:	04c05663          	blez	a2,3e8 <memmove+0x50>
 3a0:	fff6079b          	addiw	a5,a2,-1
 3a4:	1782                	slli	a5,a5,0x20
 3a6:	9381                	srli	a5,a5,0x20
 3a8:	0785                	addi	a5,a5,1
 3aa:	97aa                	add	a5,a5,a0
 3ac:	872a                	mv	a4,a0
 3ae:	0585                	addi	a1,a1,1
 3b0:	0705                	addi	a4,a4,1
 3b2:	fff5c683          	lbu	a3,-1(a1)
 3b6:	fed70fa3          	sb	a3,-1(a4)
 3ba:	fee79ae3          	bne	a5,a4,3ae <memmove+0x16>
 3be:	8082                	ret
 3c0:	00c50733          	add	a4,a0,a2
 3c4:	95b2                	add	a1,a1,a2
 3c6:	02c05163          	blez	a2,3e8 <memmove+0x50>
 3ca:	fff6079b          	addiw	a5,a2,-1
 3ce:	1782                	slli	a5,a5,0x20
 3d0:	9381                	srli	a5,a5,0x20
 3d2:	fff7c793          	not	a5,a5
 3d6:	97ba                	add	a5,a5,a4
 3d8:	15fd                	addi	a1,a1,-1
 3da:	177d                	addi	a4,a4,-1
 3dc:	0005c683          	lbu	a3,0(a1)
 3e0:	00d70023          	sb	a3,0(a4)
 3e4:	fee79ae3          	bne	a5,a4,3d8 <memmove+0x40>
 3e8:	8082                	ret

00000000000003ea <memcmp>:
 3ea:	fff6069b          	addiw	a3,a2,-1
 3ee:	c605                	beqz	a2,416 <memcmp+0x2c>
 3f0:	1682                	slli	a3,a3,0x20
 3f2:	9281                	srli	a3,a3,0x20
 3f4:	0685                	addi	a3,a3,1
 3f6:	96aa                	add	a3,a3,a0
 3f8:	00054783          	lbu	a5,0(a0)
 3fc:	0005c703          	lbu	a4,0(a1)
 400:	00e79863          	bne	a5,a4,410 <memcmp+0x26>
 404:	0505                	addi	a0,a0,1
 406:	0585                	addi	a1,a1,1
 408:	fed518e3          	bne	a0,a3,3f8 <memcmp+0xe>
 40c:	4501                	li	a0,0
 40e:	8082                	ret
 410:	40e7853b          	subw	a0,a5,a4
 414:	8082                	ret
 416:	4501                	li	a0,0
 418:	8082                	ret

000000000000041a <memcpy>:
 41a:	1141                	addi	sp,sp,-16
 41c:	e406                	sd	ra,8(sp)
 41e:	00000097          	auipc	ra,0x0
 422:	f7a080e7          	jalr	-134(ra) # 398 <memmove>
 426:	60a2                	ld	ra,8(sp)
 428:	0141                	addi	sp,sp,16
 42a:	8082                	ret

000000000000042c <putc>:
 42c:	1101                	addi	sp,sp,-32
 42e:	ec06                	sd	ra,24(sp)
 430:	00b107a3          	sb	a1,15(sp)
 434:	4605                	li	a2,1
 436:	00f10593          	addi	a1,sp,15
 43a:	00000097          	auipc	ra,0x0
 43e:	d86080e7          	jalr	-634(ra) # 1c0 <write>
 442:	60e2                	ld	ra,24(sp)
 444:	6105                	addi	sp,sp,32
 446:	8082                	ret

0000000000000448 <printint>:
 448:	7179                	addi	sp,sp,-48
 44a:	f406                	sd	ra,40(sp)
 44c:	f022                	sd	s0,32(sp)
 44e:	ec26                	sd	s1,24(sp)
 450:	e84a                	sd	s2,16(sp)
 452:	84aa                	mv	s1,a0
 454:	c299                	beqz	a3,45a <printint+0x12>
 456:	0805c363          	bltz	a1,4dc <printint+0x94>
 45a:	2581                	sext.w	a1,a1
 45c:	4881                	li	a7,0
 45e:	868a                	mv	a3,sp
 460:	4701                	li	a4,0
 462:	2601                	sext.w	a2,a2
 464:	00000517          	auipc	a0,0x0
 468:	4a450513          	addi	a0,a0,1188 # 908 <digits>
 46c:	883a                	mv	a6,a4
 46e:	2705                	addiw	a4,a4,1
 470:	02c5f7bb          	remuw	a5,a1,a2
 474:	1782                	slli	a5,a5,0x20
 476:	9381                	srli	a5,a5,0x20
 478:	97aa                	add	a5,a5,a0
 47a:	0007c783          	lbu	a5,0(a5)
 47e:	00f68023          	sb	a5,0(a3)
 482:	0005879b          	sext.w	a5,a1
 486:	02c5d5bb          	divuw	a1,a1,a2
 48a:	0685                	addi	a3,a3,1
 48c:	fec7f0e3          	bgeu	a5,a2,46c <printint+0x24>
 490:	00088a63          	beqz	a7,4a4 <printint+0x5c>
 494:	081c                	addi	a5,sp,16
 496:	973e                	add	a4,a4,a5
 498:	02d00793          	li	a5,45
 49c:	fef70823          	sb	a5,-16(a4)
 4a0:	0028071b          	addiw	a4,a6,2
 4a4:	02e05663          	blez	a4,4d0 <printint+0x88>
 4a8:	00e10433          	add	s0,sp,a4
 4ac:	fff10913          	addi	s2,sp,-1
 4b0:	993a                	add	s2,s2,a4
 4b2:	377d                	addiw	a4,a4,-1
 4b4:	1702                	slli	a4,a4,0x20
 4b6:	9301                	srli	a4,a4,0x20
 4b8:	40e90933          	sub	s2,s2,a4
 4bc:	fff44583          	lbu	a1,-1(s0)
 4c0:	8526                	mv	a0,s1
 4c2:	00000097          	auipc	ra,0x0
 4c6:	f6a080e7          	jalr	-150(ra) # 42c <putc>
 4ca:	147d                	addi	s0,s0,-1
 4cc:	ff2418e3          	bne	s0,s2,4bc <printint+0x74>
 4d0:	70a2                	ld	ra,40(sp)
 4d2:	7402                	ld	s0,32(sp)
 4d4:	64e2                	ld	s1,24(sp)
 4d6:	6942                	ld	s2,16(sp)
 4d8:	6145                	addi	sp,sp,48
 4da:	8082                	ret
 4dc:	40b005bb          	negw	a1,a1
 4e0:	4885                	li	a7,1
 4e2:	bfb5                	j	45e <printint+0x16>

00000000000004e4 <vprintf>:
 4e4:	7119                	addi	sp,sp,-128
 4e6:	fc86                	sd	ra,120(sp)
 4e8:	f8a2                	sd	s0,112(sp)
 4ea:	f4a6                	sd	s1,104(sp)
 4ec:	f0ca                	sd	s2,96(sp)
 4ee:	ecce                	sd	s3,88(sp)
 4f0:	e8d2                	sd	s4,80(sp)
 4f2:	e4d6                	sd	s5,72(sp)
 4f4:	e0da                	sd	s6,64(sp)
 4f6:	fc5e                	sd	s7,56(sp)
 4f8:	f862                	sd	s8,48(sp)
 4fa:	f466                	sd	s9,40(sp)
 4fc:	f06a                	sd	s10,32(sp)
 4fe:	ec6e                	sd	s11,24(sp)
 500:	0005c483          	lbu	s1,0(a1)
 504:	18048c63          	beqz	s1,69c <vprintf+0x1b8>
 508:	8a2a                	mv	s4,a0
 50a:	8ab2                	mv	s5,a2
 50c:	00158413          	addi	s0,a1,1
 510:	4901                	li	s2,0
 512:	02500993          	li	s3,37
 516:	06400b93          	li	s7,100
 51a:	06c00c13          	li	s8,108
 51e:	07800c93          	li	s9,120
 522:	07000d13          	li	s10,112
 526:	07300d93          	li	s11,115
 52a:	00000b17          	auipc	s6,0x0
 52e:	3deb0b13          	addi	s6,s6,990 # 908 <digits>
 532:	a839                	j	550 <vprintf+0x6c>
 534:	85a6                	mv	a1,s1
 536:	8552                	mv	a0,s4
 538:	00000097          	auipc	ra,0x0
 53c:	ef4080e7          	jalr	-268(ra) # 42c <putc>
 540:	a019                	j	546 <vprintf+0x62>
 542:	01390f63          	beq	s2,s3,560 <vprintf+0x7c>
 546:	0405                	addi	s0,s0,1
 548:	fff44483          	lbu	s1,-1(s0)
 54c:	14048863          	beqz	s1,69c <vprintf+0x1b8>
 550:	0004879b          	sext.w	a5,s1
 554:	fe0917e3          	bnez	s2,542 <vprintf+0x5e>
 558:	fd379ee3          	bne	a5,s3,534 <vprintf+0x50>
 55c:	893e                	mv	s2,a5
 55e:	b7e5                	j	546 <vprintf+0x62>
 560:	03778e63          	beq	a5,s7,59c <vprintf+0xb8>
 564:	05878a63          	beq	a5,s8,5b8 <vprintf+0xd4>
 568:	07978663          	beq	a5,s9,5d4 <vprintf+0xf0>
 56c:	09a78263          	beq	a5,s10,5f0 <vprintf+0x10c>
 570:	0db78363          	beq	a5,s11,636 <vprintf+0x152>
 574:	06300713          	li	a4,99
 578:	0ee78b63          	beq	a5,a4,66e <vprintf+0x18a>
 57c:	11378563          	beq	a5,s3,686 <vprintf+0x1a2>
 580:	85ce                	mv	a1,s3
 582:	8552                	mv	a0,s4
 584:	00000097          	auipc	ra,0x0
 588:	ea8080e7          	jalr	-344(ra) # 42c <putc>
 58c:	85a6                	mv	a1,s1
 58e:	8552                	mv	a0,s4
 590:	00000097          	auipc	ra,0x0
 594:	e9c080e7          	jalr	-356(ra) # 42c <putc>
 598:	4901                	li	s2,0
 59a:	b775                	j	546 <vprintf+0x62>
 59c:	008a8493          	addi	s1,s5,8
 5a0:	4685                	li	a3,1
 5a2:	4629                	li	a2,10
 5a4:	000aa583          	lw	a1,0(s5)
 5a8:	8552                	mv	a0,s4
 5aa:	00000097          	auipc	ra,0x0
 5ae:	e9e080e7          	jalr	-354(ra) # 448 <printint>
 5b2:	8aa6                	mv	s5,s1
 5b4:	4901                	li	s2,0
 5b6:	bf41                	j	546 <vprintf+0x62>
 5b8:	008a8493          	addi	s1,s5,8
 5bc:	4681                	li	a3,0
 5be:	4629                	li	a2,10
 5c0:	000aa583          	lw	a1,0(s5)
 5c4:	8552                	mv	a0,s4
 5c6:	00000097          	auipc	ra,0x0
 5ca:	e82080e7          	jalr	-382(ra) # 448 <printint>
 5ce:	8aa6                	mv	s5,s1
 5d0:	4901                	li	s2,0
 5d2:	bf95                	j	546 <vprintf+0x62>
 5d4:	008a8493          	addi	s1,s5,8
 5d8:	4681                	li	a3,0
 5da:	4641                	li	a2,16
 5dc:	000aa583          	lw	a1,0(s5)
 5e0:	8552                	mv	a0,s4
 5e2:	00000097          	auipc	ra,0x0
 5e6:	e66080e7          	jalr	-410(ra) # 448 <printint>
 5ea:	8aa6                	mv	s5,s1
 5ec:	4901                	li	s2,0
 5ee:	bfa1                	j	546 <vprintf+0x62>
 5f0:	008a8793          	addi	a5,s5,8
 5f4:	e43e                	sd	a5,8(sp)
 5f6:	000ab903          	ld	s2,0(s5)
 5fa:	03000593          	li	a1,48
 5fe:	8552                	mv	a0,s4
 600:	00000097          	auipc	ra,0x0
 604:	e2c080e7          	jalr	-468(ra) # 42c <putc>
 608:	85e6                	mv	a1,s9
 60a:	8552                	mv	a0,s4
 60c:	00000097          	auipc	ra,0x0
 610:	e20080e7          	jalr	-480(ra) # 42c <putc>
 614:	44c1                	li	s1,16
 616:	03c95793          	srli	a5,s2,0x3c
 61a:	97da                	add	a5,a5,s6
 61c:	0007c583          	lbu	a1,0(a5)
 620:	8552                	mv	a0,s4
 622:	00000097          	auipc	ra,0x0
 626:	e0a080e7          	jalr	-502(ra) # 42c <putc>
 62a:	0912                	slli	s2,s2,0x4
 62c:	34fd                	addiw	s1,s1,-1
 62e:	f4e5                	bnez	s1,616 <vprintf+0x132>
 630:	6aa2                	ld	s5,8(sp)
 632:	4901                	li	s2,0
 634:	bf09                	j	546 <vprintf+0x62>
 636:	008a8493          	addi	s1,s5,8
 63a:	000ab903          	ld	s2,0(s5)
 63e:	02090163          	beqz	s2,660 <vprintf+0x17c>
 642:	00094583          	lbu	a1,0(s2)
 646:	c9a1                	beqz	a1,696 <vprintf+0x1b2>
 648:	8552                	mv	a0,s4
 64a:	00000097          	auipc	ra,0x0
 64e:	de2080e7          	jalr	-542(ra) # 42c <putc>
 652:	0905                	addi	s2,s2,1
 654:	00094583          	lbu	a1,0(s2)
 658:	f9e5                	bnez	a1,648 <vprintf+0x164>
 65a:	8aa6                	mv	s5,s1
 65c:	4901                	li	s2,0
 65e:	b5e5                	j	546 <vprintf+0x62>
 660:	00000917          	auipc	s2,0x0
 664:	2a090913          	addi	s2,s2,672 # 900 <malloc+0x17e>
 668:	02800593          	li	a1,40
 66c:	bff1                	j	648 <vprintf+0x164>
 66e:	008a8493          	addi	s1,s5,8
 672:	000ac583          	lbu	a1,0(s5)
 676:	8552                	mv	a0,s4
 678:	00000097          	auipc	ra,0x0
 67c:	db4080e7          	jalr	-588(ra) # 42c <putc>
 680:	8aa6                	mv	s5,s1
 682:	4901                	li	s2,0
 684:	b5c9                	j	546 <vprintf+0x62>
 686:	85ce                	mv	a1,s3
 688:	8552                	mv	a0,s4
 68a:	00000097          	auipc	ra,0x0
 68e:	da2080e7          	jalr	-606(ra) # 42c <putc>
 692:	4901                	li	s2,0
 694:	bd4d                	j	546 <vprintf+0x62>
 696:	8aa6                	mv	s5,s1
 698:	4901                	li	s2,0
 69a:	b575                	j	546 <vprintf+0x62>
 69c:	70e6                	ld	ra,120(sp)
 69e:	7446                	ld	s0,112(sp)
 6a0:	74a6                	ld	s1,104(sp)
 6a2:	7906                	ld	s2,96(sp)
 6a4:	69e6                	ld	s3,88(sp)
 6a6:	6a46                	ld	s4,80(sp)
 6a8:	6aa6                	ld	s5,72(sp)
 6aa:	6b06                	ld	s6,64(sp)
 6ac:	7be2                	ld	s7,56(sp)
 6ae:	7c42                	ld	s8,48(sp)
 6b0:	7ca2                	ld	s9,40(sp)
 6b2:	7d02                	ld	s10,32(sp)
 6b4:	6de2                	ld	s11,24(sp)
 6b6:	6109                	addi	sp,sp,128
 6b8:	8082                	ret

00000000000006ba <fprintf>:
 6ba:	715d                	addi	sp,sp,-80
 6bc:	ec06                	sd	ra,24(sp)
 6be:	f032                	sd	a2,32(sp)
 6c0:	f436                	sd	a3,40(sp)
 6c2:	f83a                	sd	a4,48(sp)
 6c4:	fc3e                	sd	a5,56(sp)
 6c6:	e0c2                	sd	a6,64(sp)
 6c8:	e4c6                	sd	a7,72(sp)
 6ca:	1010                	addi	a2,sp,32
 6cc:	e432                	sd	a2,8(sp)
 6ce:	00000097          	auipc	ra,0x0
 6d2:	e16080e7          	jalr	-490(ra) # 4e4 <vprintf>
 6d6:	60e2                	ld	ra,24(sp)
 6d8:	6161                	addi	sp,sp,80
 6da:	8082                	ret

00000000000006dc <printf>:
 6dc:	711d                	addi	sp,sp,-96
 6de:	ec06                	sd	ra,24(sp)
 6e0:	f42e                	sd	a1,40(sp)
 6e2:	f832                	sd	a2,48(sp)
 6e4:	fc36                	sd	a3,56(sp)
 6e6:	e0ba                	sd	a4,64(sp)
 6e8:	e4be                	sd	a5,72(sp)
 6ea:	e8c2                	sd	a6,80(sp)
 6ec:	ecc6                	sd	a7,88(sp)
 6ee:	1030                	addi	a2,sp,40
 6f0:	e432                	sd	a2,8(sp)
 6f2:	85aa                	mv	a1,a0
 6f4:	4505                	li	a0,1
 6f6:	00000097          	auipc	ra,0x0
 6fa:	dee080e7          	jalr	-530(ra) # 4e4 <vprintf>
 6fe:	60e2                	ld	ra,24(sp)
 700:	6125                	addi	sp,sp,96
 702:	8082                	ret

0000000000000704 <free>:
 704:	ff050693          	addi	a3,a0,-16
 708:	00000797          	auipc	a5,0x0
 70c:	2187b783          	ld	a5,536(a5) # 920 <freep>
 710:	a805                	j	740 <free+0x3c>
 712:	4618                	lw	a4,8(a2)
 714:	9db9                	addw	a1,a1,a4
 716:	feb52c23          	sw	a1,-8(a0)
 71a:	6398                	ld	a4,0(a5)
 71c:	6318                	ld	a4,0(a4)
 71e:	fee53823          	sd	a4,-16(a0)
 722:	a091                	j	766 <free+0x62>
 724:	ff852703          	lw	a4,-8(a0)
 728:	9e39                	addw	a2,a2,a4
 72a:	c790                	sw	a2,8(a5)
 72c:	ff053703          	ld	a4,-16(a0)
 730:	e398                	sd	a4,0(a5)
 732:	a099                	j	778 <free+0x74>
 734:	6398                	ld	a4,0(a5)
 736:	00e7e463          	bltu	a5,a4,73e <free+0x3a>
 73a:	00e6ea63          	bltu	a3,a4,74e <free+0x4a>
 73e:	87ba                	mv	a5,a4
 740:	fed7fae3          	bgeu	a5,a3,734 <free+0x30>
 744:	6398                	ld	a4,0(a5)
 746:	00e6e463          	bltu	a3,a4,74e <free+0x4a>
 74a:	fee7eae3          	bltu	a5,a4,73e <free+0x3a>
 74e:	ff852583          	lw	a1,-8(a0)
 752:	6390                	ld	a2,0(a5)
 754:	02059713          	slli	a4,a1,0x20
 758:	9301                	srli	a4,a4,0x20
 75a:	0712                	slli	a4,a4,0x4
 75c:	9736                	add	a4,a4,a3
 75e:	fae60ae3          	beq	a2,a4,712 <free+0xe>
 762:	fec53823          	sd	a2,-16(a0)
 766:	4790                	lw	a2,8(a5)
 768:	02061713          	slli	a4,a2,0x20
 76c:	9301                	srli	a4,a4,0x20
 76e:	0712                	slli	a4,a4,0x4
 770:	973e                	add	a4,a4,a5
 772:	fae689e3          	beq	a3,a4,724 <free+0x20>
 776:	e394                	sd	a3,0(a5)
 778:	00000717          	auipc	a4,0x0
 77c:	1af73423          	sd	a5,424(a4) # 920 <freep>
 780:	8082                	ret

0000000000000782 <malloc>:
 782:	7139                	addi	sp,sp,-64
 784:	fc06                	sd	ra,56(sp)
 786:	f822                	sd	s0,48(sp)
 788:	f426                	sd	s1,40(sp)
 78a:	f04a                	sd	s2,32(sp)
 78c:	ec4e                	sd	s3,24(sp)
 78e:	e852                	sd	s4,16(sp)
 790:	e456                	sd	s5,8(sp)
 792:	02051413          	slli	s0,a0,0x20
 796:	9001                	srli	s0,s0,0x20
 798:	043d                	addi	s0,s0,15
 79a:	8011                	srli	s0,s0,0x4
 79c:	0014091b          	addiw	s2,s0,1
 7a0:	0405                	addi	s0,s0,1
 7a2:	00000517          	auipc	a0,0x0
 7a6:	17e53503          	ld	a0,382(a0) # 920 <freep>
 7aa:	c905                	beqz	a0,7da <malloc+0x58>
 7ac:	611c                	ld	a5,0(a0)
 7ae:	4798                	lw	a4,8(a5)
 7b0:	04877163          	bgeu	a4,s0,7f2 <malloc+0x70>
 7b4:	89ca                	mv	s3,s2
 7b6:	0009071b          	sext.w	a4,s2
 7ba:	6685                	lui	a3,0x1
 7bc:	00d77363          	bgeu	a4,a3,7c2 <malloc+0x40>
 7c0:	6985                	lui	s3,0x1
 7c2:	00098a1b          	sext.w	s4,s3
 7c6:	1982                	slli	s3,s3,0x20
 7c8:	0209d993          	srli	s3,s3,0x20
 7cc:	0992                	slli	s3,s3,0x4
 7ce:	00000497          	auipc	s1,0x0
 7d2:	15248493          	addi	s1,s1,338 # 920 <freep>
 7d6:	5afd                	li	s5,-1
 7d8:	a0bd                	j	846 <malloc+0xc4>
 7da:	00000797          	auipc	a5,0x0
 7de:	14e78793          	addi	a5,a5,334 # 928 <base>
 7e2:	00000717          	auipc	a4,0x0
 7e6:	12f73f23          	sd	a5,318(a4) # 920 <freep>
 7ea:	e39c                	sd	a5,0(a5)
 7ec:	0007a423          	sw	zero,8(a5)
 7f0:	b7d1                	j	7b4 <malloc+0x32>
 7f2:	02e40a63          	beq	s0,a4,826 <malloc+0xa4>
 7f6:	4127073b          	subw	a4,a4,s2
 7fa:	c798                	sw	a4,8(a5)
 7fc:	1702                	slli	a4,a4,0x20
 7fe:	9301                	srli	a4,a4,0x20
 800:	0712                	slli	a4,a4,0x4
 802:	97ba                	add	a5,a5,a4
 804:	0127a423          	sw	s2,8(a5)
 808:	00000717          	auipc	a4,0x0
 80c:	10a73c23          	sd	a0,280(a4) # 920 <freep>
 810:	01078513          	addi	a0,a5,16
 814:	70e2                	ld	ra,56(sp)
 816:	7442                	ld	s0,48(sp)
 818:	74a2                	ld	s1,40(sp)
 81a:	7902                	ld	s2,32(sp)
 81c:	69e2                	ld	s3,24(sp)
 81e:	6a42                	ld	s4,16(sp)
 820:	6aa2                	ld	s5,8(sp)
 822:	6121                	addi	sp,sp,64
 824:	8082                	ret
 826:	6398                	ld	a4,0(a5)
 828:	e118                	sd	a4,0(a0)
 82a:	bff9                	j	808 <malloc+0x86>
 82c:	01452423          	sw	s4,8(a0)
 830:	0541                	addi	a0,a0,16
 832:	00000097          	auipc	ra,0x0
 836:	ed2080e7          	jalr	-302(ra) # 704 <free>
 83a:	6088                	ld	a0,0(s1)
 83c:	dd61                	beqz	a0,814 <malloc+0x92>
 83e:	611c                	ld	a5,0(a0)
 840:	4798                	lw	a4,8(a5)
 842:	fa8778e3          	bgeu	a4,s0,7f2 <malloc+0x70>
 846:	6098                	ld	a4,0(s1)
 848:	853e                	mv	a0,a5
 84a:	fef71ae3          	bne	a4,a5,83e <malloc+0xbc>
 84e:	854e                	mv	a0,s3
 850:	00000097          	auipc	ra,0x0
 854:	8e2080e7          	jalr	-1822(ra) # 132 <sbrk>
 858:	fd551ae3          	bne	a0,s5,82c <malloc+0xaa>
 85c:	4501                	li	a0,0
 85e:	bf5d                	j	814 <malloc+0x92>
