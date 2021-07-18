
_oscmp_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_success>:
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	842a                	mv	s0,a0
   a:	00001517          	auipc	a0,0x1
   e:	8a650513          	addi	a0,a0,-1882 # 8b0 <malloc+0x11c>
  12:	00000097          	auipc	ra,0x0
  16:	6dc080e7          	jalr	1756(ra) # 6ee <printf>
  1a:	600c                	ld	a1,0(s0)
  1c:	cd99                	beqz	a1,3a <print_success+0x3a>
  1e:	0421                	addi	s0,s0,8
  20:	00001497          	auipc	s1,0x1
  24:	8a848493          	addi	s1,s1,-1880 # 8c8 <malloc+0x134>
  28:	8526                	mv	a0,s1
  2a:	00000097          	auipc	ra,0x0
  2e:	6c4080e7          	jalr	1732(ra) # 6ee <printf>
  32:	0421                	addi	s0,s0,8
  34:	ff843583          	ld	a1,-8(s0)
  38:	f9e5                	bnez	a1,28 <print_success+0x28>
  3a:	00001517          	auipc	a0,0x1
  3e:	89650513          	addi	a0,a0,-1898 # 8d0 <malloc+0x13c>
  42:	00000097          	auipc	ra,0x0
  46:	6ac080e7          	jalr	1708(ra) # 6ee <printf>
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
  64:	0c2080e7          	jalr	194(ra) # 122 <fork>
  68:	ed09                	bnez	a0,82 <test+0x2e>
  6a:	4601                	li	a2,0
  6c:	85a2                	mv	a1,s0
  6e:	8526                	mv	a0,s1
  70:	00000097          	auipc	ra,0x0
  74:	1da080e7          	jalr	474(ra) # 24a <execve>
  78:	70a2                	ld	ra,40(sp)
  7a:	7402                	ld	s0,32(sp)
  7c:	64e2                	ld	s1,24(sp)
  7e:	6145                	addi	sp,sp,48
  80:	8082                	ret
  82:	0068                	addi	a0,sp,12
  84:	00000097          	auipc	ra,0x0
  88:	0a6080e7          	jalr	166(ra) # 12a <wait>
  8c:	47b2                	lw	a5,12(sp)
  8e:	fe07c5e3          	bltz	a5,78 <test+0x24>
  92:	8522                	mv	a0,s0
  94:	00000097          	auipc	ra,0x0
  98:	f6c080e7          	jalr	-148(ra) # 0 <print_success>
  9c:	bff1                	j	78 <test+0x24>

000000000000009e <main>:
  9e:	7179                	addi	sp,sp,-48
  a0:	f406                	sd	ra,40(sp)
  a2:	4589                	li	a1,2
  a4:	00001517          	auipc	a0,0x1
  a8:	83c50513          	addi	a0,a0,-1988 # 8e0 <malloc+0x14c>
  ac:	00000097          	auipc	ra,0x0
  b0:	086080e7          	jalr	134(ra) # 132 <open>
  b4:	4501                	li	a0,0
  b6:	00000097          	auipc	ra,0x0
  ba:	094080e7          	jalr	148(ra) # 14a <dup>
  be:	4501                	li	a0,0
  c0:	00000097          	auipc	ra,0x0
  c4:	08a080e7          	jalr	138(ra) # 14a <dup>
  c8:	00000797          	auipc	a5,0x0
  cc:	7c878793          	addi	a5,a5,1992 # 890 <malloc+0xfc>
  d0:	e43e                	sd	a5,8(sp)
  d2:	00001797          	auipc	a5,0x1
  d6:	81678793          	addi	a5,a5,-2026 # 8e8 <malloc+0x154>
  da:	e83e                	sd	a5,16(sp)
  dc:	ec02                	sd	zero,24(sp)
  de:	00000097          	auipc	ra,0x0
  e2:	044080e7          	jalr	68(ra) # 122 <fork>
  e6:	e905                	bnez	a0,116 <main+0x78>
  e8:	00001517          	auipc	a0,0x1
  ec:	81850513          	addi	a0,a0,-2024 # 900 <malloc+0x16c>
  f0:	00000097          	auipc	ra,0x0
  f4:	5fe080e7          	jalr	1534(ra) # 6ee <printf>
  f8:	4601                	li	a2,0
  fa:	002c                	addi	a1,sp,8
  fc:	00001517          	auipc	a0,0x1
 100:	81450513          	addi	a0,a0,-2028 # 910 <malloc+0x17c>
 104:	00000097          	auipc	ra,0x0
 108:	146080e7          	jalr	326(ra) # 24a <execve>
 10c:	00000097          	auipc	ra,0x0
 110:	15c080e7          	jalr	348(ra) # 268 <kernel_panic>
 114:	a001                	j	114 <main+0x76>
 116:	0048                	addi	a0,sp,4
 118:	00000097          	auipc	ra,0x0
 11c:	012080e7          	jalr	18(ra) # 12a <wait>
 120:	b7f5                	j	10c <main+0x6e>

0000000000000122 <fork>:
 122:	4885                	li	a7,1
 124:	00000073          	ecall
 128:	8082                	ret

000000000000012a <wait>:
 12a:	488d                	li	a7,3
 12c:	00000073          	ecall
 130:	8082                	ret

0000000000000132 <open>:
 132:	4889                	li	a7,2
 134:	00000073          	ecall
 138:	8082                	ret

000000000000013a <sbrk>:
 13a:	4891                	li	a7,4
 13c:	00000073          	ecall
 140:	8082                	ret

0000000000000142 <getcwd>:
 142:	48c5                	li	a7,17
 144:	00000073          	ecall
 148:	8082                	ret

000000000000014a <dup>:
 14a:	48dd                	li	a7,23
 14c:	00000073          	ecall
 150:	8082                	ret

0000000000000152 <dup3>:
 152:	48e1                	li	a7,24
 154:	00000073          	ecall
 158:	8082                	ret

000000000000015a <mkdirat>:
 15a:	02200893          	li	a7,34
 15e:	00000073          	ecall
 162:	8082                	ret

0000000000000164 <unlinkat>:
 164:	02300893          	li	a7,35
 168:	00000073          	ecall
 16c:	8082                	ret

000000000000016e <linkat>:
 16e:	02500893          	li	a7,37
 172:	00000073          	ecall
 176:	8082                	ret

0000000000000178 <umount2>:
 178:	02700893          	li	a7,39
 17c:	00000073          	ecall
 180:	8082                	ret

0000000000000182 <mount>:
 182:	02800893          	li	a7,40
 186:	00000073          	ecall
 18a:	8082                	ret

000000000000018c <chdir>:
 18c:	03100893          	li	a7,49
 190:	00000073          	ecall
 194:	8082                	ret

0000000000000196 <openat>:
 196:	03800893          	li	a7,56
 19a:	00000073          	ecall
 19e:	8082                	ret

00000000000001a0 <close>:
 1a0:	03900893          	li	a7,57
 1a4:	00000073          	ecall
 1a8:	8082                	ret

00000000000001aa <pipe2>:
 1aa:	03b00893          	li	a7,59
 1ae:	00000073          	ecall
 1b2:	8082                	ret

00000000000001b4 <getdents64>:
 1b4:	03d00893          	li	a7,61
 1b8:	00000073          	ecall
 1bc:	8082                	ret

00000000000001be <read>:
 1be:	03f00893          	li	a7,63
 1c2:	00000073          	ecall
 1c6:	8082                	ret

00000000000001c8 <write>:
 1c8:	04000893          	li	a7,64
 1cc:	00000073          	ecall
 1d0:	8082                	ret

00000000000001d2 <fstat>:
 1d2:	05000893          	li	a7,80
 1d6:	00000073          	ecall
 1da:	8082                	ret

00000000000001dc <exit>:
 1dc:	05d00893          	li	a7,93
 1e0:	00000073          	ecall
 1e4:	8082                	ret

00000000000001e6 <nanosleep>:
 1e6:	06500893          	li	a7,101
 1ea:	00000073          	ecall
 1ee:	8082                	ret

00000000000001f0 <sched_yield>:
 1f0:	07c00893          	li	a7,124
 1f4:	00000073          	ecall
 1f8:	8082                	ret

00000000000001fa <times>:
 1fa:	09900893          	li	a7,153
 1fe:	00000073          	ecall
 202:	8082                	ret

0000000000000204 <uname>:
 204:	0a000893          	li	a7,160
 208:	00000073          	ecall
 20c:	8082                	ret

000000000000020e <gettimeofday>:
 20e:	0a900893          	li	a7,169
 212:	00000073          	ecall
 216:	8082                	ret

0000000000000218 <brk>:
 218:	0d600893          	li	a7,214
 21c:	00000073          	ecall
 220:	8082                	ret

0000000000000222 <munmap>:
 222:	0d700893          	li	a7,215
 226:	00000073          	ecall
 22a:	8082                	ret

000000000000022c <getpid>:
 22c:	0ac00893          	li	a7,172
 230:	00000073          	ecall
 234:	8082                	ret

0000000000000236 <getppid>:
 236:	0ad00893          	li	a7,173
 23a:	00000073          	ecall
 23e:	8082                	ret

0000000000000240 <clone>:
 240:	0dc00893          	li	a7,220
 244:	00000073          	ecall
 248:	8082                	ret

000000000000024a <execve>:
 24a:	0dd00893          	li	a7,221
 24e:	00000073          	ecall
 252:	8082                	ret

0000000000000254 <mmap>:
 254:	0de00893          	li	a7,222
 258:	00000073          	ecall
 25c:	8082                	ret

000000000000025e <wait4>:
 25e:	10400893          	li	a7,260
 262:	00000073          	ecall
 266:	8082                	ret

0000000000000268 <kernel_panic>:
 268:	18f00893          	li	a7,399
 26c:	00000073          	ecall
 270:	8082                	ret

0000000000000272 <strcpy>:
 272:	87aa                	mv	a5,a0
 274:	0585                	addi	a1,a1,1
 276:	0785                	addi	a5,a5,1
 278:	fff5c703          	lbu	a4,-1(a1)
 27c:	fee78fa3          	sb	a4,-1(a5)
 280:	fb75                	bnez	a4,274 <strcpy+0x2>
 282:	8082                	ret

0000000000000284 <strcmp>:
 284:	00054783          	lbu	a5,0(a0)
 288:	cb91                	beqz	a5,29c <strcmp+0x18>
 28a:	0005c703          	lbu	a4,0(a1)
 28e:	00f71763          	bne	a4,a5,29c <strcmp+0x18>
 292:	0505                	addi	a0,a0,1
 294:	0585                	addi	a1,a1,1
 296:	00054783          	lbu	a5,0(a0)
 29a:	fbe5                	bnez	a5,28a <strcmp+0x6>
 29c:	0005c503          	lbu	a0,0(a1)
 2a0:	40a7853b          	subw	a0,a5,a0
 2a4:	8082                	ret

00000000000002a6 <strlen>:
 2a6:	00054783          	lbu	a5,0(a0)
 2aa:	cf81                	beqz	a5,2c2 <strlen+0x1c>
 2ac:	0505                	addi	a0,a0,1
 2ae:	87aa                	mv	a5,a0
 2b0:	4685                	li	a3,1
 2b2:	9e89                	subw	a3,a3,a0
 2b4:	00f6853b          	addw	a0,a3,a5
 2b8:	0785                	addi	a5,a5,1
 2ba:	fff7c703          	lbu	a4,-1(a5)
 2be:	fb7d                	bnez	a4,2b4 <strlen+0xe>
 2c0:	8082                	ret
 2c2:	4501                	li	a0,0
 2c4:	8082                	ret

00000000000002c6 <memset>:
 2c6:	ce09                	beqz	a2,2e0 <memset+0x1a>
 2c8:	87aa                	mv	a5,a0
 2ca:	fff6071b          	addiw	a4,a2,-1
 2ce:	1702                	slli	a4,a4,0x20
 2d0:	9301                	srli	a4,a4,0x20
 2d2:	0705                	addi	a4,a4,1
 2d4:	972a                	add	a4,a4,a0
 2d6:	00b78023          	sb	a1,0(a5)
 2da:	0785                	addi	a5,a5,1
 2dc:	fee79de3          	bne	a5,a4,2d6 <memset+0x10>
 2e0:	8082                	ret

00000000000002e2 <strchr>:
 2e2:	00054783          	lbu	a5,0(a0)
 2e6:	cb89                	beqz	a5,2f8 <strchr+0x16>
 2e8:	00f58963          	beq	a1,a5,2fa <strchr+0x18>
 2ec:	0505                	addi	a0,a0,1
 2ee:	00054783          	lbu	a5,0(a0)
 2f2:	fbfd                	bnez	a5,2e8 <strchr+0x6>
 2f4:	4501                	li	a0,0
 2f6:	8082                	ret
 2f8:	4501                	li	a0,0
 2fa:	8082                	ret

00000000000002fc <gets>:
 2fc:	715d                	addi	sp,sp,-80
 2fe:	e486                	sd	ra,72(sp)
 300:	e0a2                	sd	s0,64(sp)
 302:	fc26                	sd	s1,56(sp)
 304:	f84a                	sd	s2,48(sp)
 306:	f44e                	sd	s3,40(sp)
 308:	f052                	sd	s4,32(sp)
 30a:	ec56                	sd	s5,24(sp)
 30c:	e85a                	sd	s6,16(sp)
 30e:	8b2a                	mv	s6,a0
 310:	89ae                	mv	s3,a1
 312:	84aa                	mv	s1,a0
 314:	4401                	li	s0,0
 316:	4a29                	li	s4,10
 318:	4ab5                	li	s5,13
 31a:	8922                	mv	s2,s0
 31c:	2405                	addiw	s0,s0,1
 31e:	03345863          	bge	s0,s3,34e <gets+0x52>
 322:	4605                	li	a2,1
 324:	00f10593          	addi	a1,sp,15
 328:	4501                	li	a0,0
 32a:	00000097          	auipc	ra,0x0
 32e:	e94080e7          	jalr	-364(ra) # 1be <read>
 332:	00a05e63          	blez	a0,34e <gets+0x52>
 336:	00f14783          	lbu	a5,15(sp)
 33a:	00f48023          	sb	a5,0(s1)
 33e:	01478763          	beq	a5,s4,34c <gets+0x50>
 342:	0485                	addi	s1,s1,1
 344:	fd579be3          	bne	a5,s5,31a <gets+0x1e>
 348:	8922                	mv	s2,s0
 34a:	a011                	j	34e <gets+0x52>
 34c:	8922                	mv	s2,s0
 34e:	995a                	add	s2,s2,s6
 350:	00090023          	sb	zero,0(s2)
 354:	855a                	mv	a0,s6
 356:	60a6                	ld	ra,72(sp)
 358:	6406                	ld	s0,64(sp)
 35a:	74e2                	ld	s1,56(sp)
 35c:	7942                	ld	s2,48(sp)
 35e:	79a2                	ld	s3,40(sp)
 360:	7a02                	ld	s4,32(sp)
 362:	6ae2                	ld	s5,24(sp)
 364:	6b42                	ld	s6,16(sp)
 366:	6161                	addi	sp,sp,80
 368:	8082                	ret

000000000000036a <atoi>:
 36a:	86aa                	mv	a3,a0
 36c:	00054603          	lbu	a2,0(a0)
 370:	fd06079b          	addiw	a5,a2,-48
 374:	0ff7f793          	andi	a5,a5,255
 378:	4725                	li	a4,9
 37a:	02f76663          	bltu	a4,a5,3a6 <atoi+0x3c>
 37e:	4501                	li	a0,0
 380:	45a5                	li	a1,9
 382:	0685                	addi	a3,a3,1
 384:	0025179b          	slliw	a5,a0,0x2
 388:	9fa9                	addw	a5,a5,a0
 38a:	0017979b          	slliw	a5,a5,0x1
 38e:	9fb1                	addw	a5,a5,a2
 390:	fd07851b          	addiw	a0,a5,-48
 394:	0006c603          	lbu	a2,0(a3)
 398:	fd06071b          	addiw	a4,a2,-48
 39c:	0ff77713          	andi	a4,a4,255
 3a0:	fee5f1e3          	bgeu	a1,a4,382 <atoi+0x18>
 3a4:	8082                	ret
 3a6:	4501                	li	a0,0
 3a8:	8082                	ret

00000000000003aa <memmove>:
 3aa:	02b57463          	bgeu	a0,a1,3d2 <memmove+0x28>
 3ae:	04c05663          	blez	a2,3fa <memmove+0x50>
 3b2:	fff6079b          	addiw	a5,a2,-1
 3b6:	1782                	slli	a5,a5,0x20
 3b8:	9381                	srli	a5,a5,0x20
 3ba:	0785                	addi	a5,a5,1
 3bc:	97aa                	add	a5,a5,a0
 3be:	872a                	mv	a4,a0
 3c0:	0585                	addi	a1,a1,1
 3c2:	0705                	addi	a4,a4,1
 3c4:	fff5c683          	lbu	a3,-1(a1)
 3c8:	fed70fa3          	sb	a3,-1(a4)
 3cc:	fee79ae3          	bne	a5,a4,3c0 <memmove+0x16>
 3d0:	8082                	ret
 3d2:	00c50733          	add	a4,a0,a2
 3d6:	95b2                	add	a1,a1,a2
 3d8:	02c05163          	blez	a2,3fa <memmove+0x50>
 3dc:	fff6079b          	addiw	a5,a2,-1
 3e0:	1782                	slli	a5,a5,0x20
 3e2:	9381                	srli	a5,a5,0x20
 3e4:	fff7c793          	not	a5,a5
 3e8:	97ba                	add	a5,a5,a4
 3ea:	15fd                	addi	a1,a1,-1
 3ec:	177d                	addi	a4,a4,-1
 3ee:	0005c683          	lbu	a3,0(a1)
 3f2:	00d70023          	sb	a3,0(a4)
 3f6:	fee79ae3          	bne	a5,a4,3ea <memmove+0x40>
 3fa:	8082                	ret

00000000000003fc <memcmp>:
 3fc:	fff6069b          	addiw	a3,a2,-1
 400:	c605                	beqz	a2,428 <memcmp+0x2c>
 402:	1682                	slli	a3,a3,0x20
 404:	9281                	srli	a3,a3,0x20
 406:	0685                	addi	a3,a3,1
 408:	96aa                	add	a3,a3,a0
 40a:	00054783          	lbu	a5,0(a0)
 40e:	0005c703          	lbu	a4,0(a1)
 412:	00e79863          	bne	a5,a4,422 <memcmp+0x26>
 416:	0505                	addi	a0,a0,1
 418:	0585                	addi	a1,a1,1
 41a:	fed518e3          	bne	a0,a3,40a <memcmp+0xe>
 41e:	4501                	li	a0,0
 420:	8082                	ret
 422:	40e7853b          	subw	a0,a5,a4
 426:	8082                	ret
 428:	4501                	li	a0,0
 42a:	8082                	ret

000000000000042c <memcpy>:
 42c:	1141                	addi	sp,sp,-16
 42e:	e406                	sd	ra,8(sp)
 430:	00000097          	auipc	ra,0x0
 434:	f7a080e7          	jalr	-134(ra) # 3aa <memmove>
 438:	60a2                	ld	ra,8(sp)
 43a:	0141                	addi	sp,sp,16
 43c:	8082                	ret

000000000000043e <putc>:
 43e:	1101                	addi	sp,sp,-32
 440:	ec06                	sd	ra,24(sp)
 442:	00b107a3          	sb	a1,15(sp)
 446:	4605                	li	a2,1
 448:	00f10593          	addi	a1,sp,15
 44c:	00000097          	auipc	ra,0x0
 450:	d7c080e7          	jalr	-644(ra) # 1c8 <write>
 454:	60e2                	ld	ra,24(sp)
 456:	6105                	addi	sp,sp,32
 458:	8082                	ret

000000000000045a <printint>:
 45a:	7179                	addi	sp,sp,-48
 45c:	f406                	sd	ra,40(sp)
 45e:	f022                	sd	s0,32(sp)
 460:	ec26                	sd	s1,24(sp)
 462:	e84a                	sd	s2,16(sp)
 464:	84aa                	mv	s1,a0
 466:	c299                	beqz	a3,46c <printint+0x12>
 468:	0805c363          	bltz	a1,4ee <printint+0x94>
 46c:	2581                	sext.w	a1,a1
 46e:	4881                	li	a7,0
 470:	868a                	mv	a3,sp
 472:	4701                	li	a4,0
 474:	2601                	sext.w	a2,a2
 476:	00000517          	auipc	a0,0x0
 47a:	4aa50513          	addi	a0,a0,1194 # 920 <digits>
 47e:	883a                	mv	a6,a4
 480:	2705                	addiw	a4,a4,1
 482:	02c5f7bb          	remuw	a5,a1,a2
 486:	1782                	slli	a5,a5,0x20
 488:	9381                	srli	a5,a5,0x20
 48a:	97aa                	add	a5,a5,a0
 48c:	0007c783          	lbu	a5,0(a5)
 490:	00f68023          	sb	a5,0(a3)
 494:	0005879b          	sext.w	a5,a1
 498:	02c5d5bb          	divuw	a1,a1,a2
 49c:	0685                	addi	a3,a3,1
 49e:	fec7f0e3          	bgeu	a5,a2,47e <printint+0x24>
 4a2:	00088a63          	beqz	a7,4b6 <printint+0x5c>
 4a6:	081c                	addi	a5,sp,16
 4a8:	973e                	add	a4,a4,a5
 4aa:	02d00793          	li	a5,45
 4ae:	fef70823          	sb	a5,-16(a4)
 4b2:	0028071b          	addiw	a4,a6,2
 4b6:	02e05663          	blez	a4,4e2 <printint+0x88>
 4ba:	00e10433          	add	s0,sp,a4
 4be:	fff10913          	addi	s2,sp,-1
 4c2:	993a                	add	s2,s2,a4
 4c4:	377d                	addiw	a4,a4,-1
 4c6:	1702                	slli	a4,a4,0x20
 4c8:	9301                	srli	a4,a4,0x20
 4ca:	40e90933          	sub	s2,s2,a4
 4ce:	fff44583          	lbu	a1,-1(s0)
 4d2:	8526                	mv	a0,s1
 4d4:	00000097          	auipc	ra,0x0
 4d8:	f6a080e7          	jalr	-150(ra) # 43e <putc>
 4dc:	147d                	addi	s0,s0,-1
 4de:	ff2418e3          	bne	s0,s2,4ce <printint+0x74>
 4e2:	70a2                	ld	ra,40(sp)
 4e4:	7402                	ld	s0,32(sp)
 4e6:	64e2                	ld	s1,24(sp)
 4e8:	6942                	ld	s2,16(sp)
 4ea:	6145                	addi	sp,sp,48
 4ec:	8082                	ret
 4ee:	40b005bb          	negw	a1,a1
 4f2:	4885                	li	a7,1
 4f4:	bfb5                	j	470 <printint+0x16>

00000000000004f6 <vprintf>:
 4f6:	7119                	addi	sp,sp,-128
 4f8:	fc86                	sd	ra,120(sp)
 4fa:	f8a2                	sd	s0,112(sp)
 4fc:	f4a6                	sd	s1,104(sp)
 4fe:	f0ca                	sd	s2,96(sp)
 500:	ecce                	sd	s3,88(sp)
 502:	e8d2                	sd	s4,80(sp)
 504:	e4d6                	sd	s5,72(sp)
 506:	e0da                	sd	s6,64(sp)
 508:	fc5e                	sd	s7,56(sp)
 50a:	f862                	sd	s8,48(sp)
 50c:	f466                	sd	s9,40(sp)
 50e:	f06a                	sd	s10,32(sp)
 510:	ec6e                	sd	s11,24(sp)
 512:	0005c483          	lbu	s1,0(a1)
 516:	18048c63          	beqz	s1,6ae <vprintf+0x1b8>
 51a:	8a2a                	mv	s4,a0
 51c:	8ab2                	mv	s5,a2
 51e:	00158413          	addi	s0,a1,1
 522:	4901                	li	s2,0
 524:	02500993          	li	s3,37
 528:	06400b93          	li	s7,100
 52c:	06c00c13          	li	s8,108
 530:	07800c93          	li	s9,120
 534:	07000d13          	li	s10,112
 538:	07300d93          	li	s11,115
 53c:	00000b17          	auipc	s6,0x0
 540:	3e4b0b13          	addi	s6,s6,996 # 920 <digits>
 544:	a839                	j	562 <vprintf+0x6c>
 546:	85a6                	mv	a1,s1
 548:	8552                	mv	a0,s4
 54a:	00000097          	auipc	ra,0x0
 54e:	ef4080e7          	jalr	-268(ra) # 43e <putc>
 552:	a019                	j	558 <vprintf+0x62>
 554:	01390f63          	beq	s2,s3,572 <vprintf+0x7c>
 558:	0405                	addi	s0,s0,1
 55a:	fff44483          	lbu	s1,-1(s0)
 55e:	14048863          	beqz	s1,6ae <vprintf+0x1b8>
 562:	0004879b          	sext.w	a5,s1
 566:	fe0917e3          	bnez	s2,554 <vprintf+0x5e>
 56a:	fd379ee3          	bne	a5,s3,546 <vprintf+0x50>
 56e:	893e                	mv	s2,a5
 570:	b7e5                	j	558 <vprintf+0x62>
 572:	03778e63          	beq	a5,s7,5ae <vprintf+0xb8>
 576:	05878a63          	beq	a5,s8,5ca <vprintf+0xd4>
 57a:	07978663          	beq	a5,s9,5e6 <vprintf+0xf0>
 57e:	09a78263          	beq	a5,s10,602 <vprintf+0x10c>
 582:	0db78363          	beq	a5,s11,648 <vprintf+0x152>
 586:	06300713          	li	a4,99
 58a:	0ee78b63          	beq	a5,a4,680 <vprintf+0x18a>
 58e:	11378563          	beq	a5,s3,698 <vprintf+0x1a2>
 592:	85ce                	mv	a1,s3
 594:	8552                	mv	a0,s4
 596:	00000097          	auipc	ra,0x0
 59a:	ea8080e7          	jalr	-344(ra) # 43e <putc>
 59e:	85a6                	mv	a1,s1
 5a0:	8552                	mv	a0,s4
 5a2:	00000097          	auipc	ra,0x0
 5a6:	e9c080e7          	jalr	-356(ra) # 43e <putc>
 5aa:	4901                	li	s2,0
 5ac:	b775                	j	558 <vprintf+0x62>
 5ae:	008a8493          	addi	s1,s5,8
 5b2:	4685                	li	a3,1
 5b4:	4629                	li	a2,10
 5b6:	000aa583          	lw	a1,0(s5)
 5ba:	8552                	mv	a0,s4
 5bc:	00000097          	auipc	ra,0x0
 5c0:	e9e080e7          	jalr	-354(ra) # 45a <printint>
 5c4:	8aa6                	mv	s5,s1
 5c6:	4901                	li	s2,0
 5c8:	bf41                	j	558 <vprintf+0x62>
 5ca:	008a8493          	addi	s1,s5,8
 5ce:	4681                	li	a3,0
 5d0:	4629                	li	a2,10
 5d2:	000aa583          	lw	a1,0(s5)
 5d6:	8552                	mv	a0,s4
 5d8:	00000097          	auipc	ra,0x0
 5dc:	e82080e7          	jalr	-382(ra) # 45a <printint>
 5e0:	8aa6                	mv	s5,s1
 5e2:	4901                	li	s2,0
 5e4:	bf95                	j	558 <vprintf+0x62>
 5e6:	008a8493          	addi	s1,s5,8
 5ea:	4681                	li	a3,0
 5ec:	4641                	li	a2,16
 5ee:	000aa583          	lw	a1,0(s5)
 5f2:	8552                	mv	a0,s4
 5f4:	00000097          	auipc	ra,0x0
 5f8:	e66080e7          	jalr	-410(ra) # 45a <printint>
 5fc:	8aa6                	mv	s5,s1
 5fe:	4901                	li	s2,0
 600:	bfa1                	j	558 <vprintf+0x62>
 602:	008a8793          	addi	a5,s5,8
 606:	e43e                	sd	a5,8(sp)
 608:	000ab903          	ld	s2,0(s5)
 60c:	03000593          	li	a1,48
 610:	8552                	mv	a0,s4
 612:	00000097          	auipc	ra,0x0
 616:	e2c080e7          	jalr	-468(ra) # 43e <putc>
 61a:	85e6                	mv	a1,s9
 61c:	8552                	mv	a0,s4
 61e:	00000097          	auipc	ra,0x0
 622:	e20080e7          	jalr	-480(ra) # 43e <putc>
 626:	44c1                	li	s1,16
 628:	03c95793          	srli	a5,s2,0x3c
 62c:	97da                	add	a5,a5,s6
 62e:	0007c583          	lbu	a1,0(a5)
 632:	8552                	mv	a0,s4
 634:	00000097          	auipc	ra,0x0
 638:	e0a080e7          	jalr	-502(ra) # 43e <putc>
 63c:	0912                	slli	s2,s2,0x4
 63e:	34fd                	addiw	s1,s1,-1
 640:	f4e5                	bnez	s1,628 <vprintf+0x132>
 642:	6aa2                	ld	s5,8(sp)
 644:	4901                	li	s2,0
 646:	bf09                	j	558 <vprintf+0x62>
 648:	008a8493          	addi	s1,s5,8
 64c:	000ab903          	ld	s2,0(s5)
 650:	02090163          	beqz	s2,672 <vprintf+0x17c>
 654:	00094583          	lbu	a1,0(s2)
 658:	c9a1                	beqz	a1,6a8 <vprintf+0x1b2>
 65a:	8552                	mv	a0,s4
 65c:	00000097          	auipc	ra,0x0
 660:	de2080e7          	jalr	-542(ra) # 43e <putc>
 664:	0905                	addi	s2,s2,1
 666:	00094583          	lbu	a1,0(s2)
 66a:	f9e5                	bnez	a1,65a <vprintf+0x164>
 66c:	8aa6                	mv	s5,s1
 66e:	4901                	li	s2,0
 670:	b5e5                	j	558 <vprintf+0x62>
 672:	00000917          	auipc	s2,0x0
 676:	2a690913          	addi	s2,s2,678 # 918 <malloc+0x184>
 67a:	02800593          	li	a1,40
 67e:	bff1                	j	65a <vprintf+0x164>
 680:	008a8493          	addi	s1,s5,8
 684:	000ac583          	lbu	a1,0(s5)
 688:	8552                	mv	a0,s4
 68a:	00000097          	auipc	ra,0x0
 68e:	db4080e7          	jalr	-588(ra) # 43e <putc>
 692:	8aa6                	mv	s5,s1
 694:	4901                	li	s2,0
 696:	b5c9                	j	558 <vprintf+0x62>
 698:	85ce                	mv	a1,s3
 69a:	8552                	mv	a0,s4
 69c:	00000097          	auipc	ra,0x0
 6a0:	da2080e7          	jalr	-606(ra) # 43e <putc>
 6a4:	4901                	li	s2,0
 6a6:	bd4d                	j	558 <vprintf+0x62>
 6a8:	8aa6                	mv	s5,s1
 6aa:	4901                	li	s2,0
 6ac:	b575                	j	558 <vprintf+0x62>
 6ae:	70e6                	ld	ra,120(sp)
 6b0:	7446                	ld	s0,112(sp)
 6b2:	74a6                	ld	s1,104(sp)
 6b4:	7906                	ld	s2,96(sp)
 6b6:	69e6                	ld	s3,88(sp)
 6b8:	6a46                	ld	s4,80(sp)
 6ba:	6aa6                	ld	s5,72(sp)
 6bc:	6b06                	ld	s6,64(sp)
 6be:	7be2                	ld	s7,56(sp)
 6c0:	7c42                	ld	s8,48(sp)
 6c2:	7ca2                	ld	s9,40(sp)
 6c4:	7d02                	ld	s10,32(sp)
 6c6:	6de2                	ld	s11,24(sp)
 6c8:	6109                	addi	sp,sp,128
 6ca:	8082                	ret

00000000000006cc <fprintf>:
 6cc:	715d                	addi	sp,sp,-80
 6ce:	ec06                	sd	ra,24(sp)
 6d0:	f032                	sd	a2,32(sp)
 6d2:	f436                	sd	a3,40(sp)
 6d4:	f83a                	sd	a4,48(sp)
 6d6:	fc3e                	sd	a5,56(sp)
 6d8:	e0c2                	sd	a6,64(sp)
 6da:	e4c6                	sd	a7,72(sp)
 6dc:	1010                	addi	a2,sp,32
 6de:	e432                	sd	a2,8(sp)
 6e0:	00000097          	auipc	ra,0x0
 6e4:	e16080e7          	jalr	-490(ra) # 4f6 <vprintf>
 6e8:	60e2                	ld	ra,24(sp)
 6ea:	6161                	addi	sp,sp,80
 6ec:	8082                	ret

00000000000006ee <printf>:
 6ee:	711d                	addi	sp,sp,-96
 6f0:	ec06                	sd	ra,24(sp)
 6f2:	f42e                	sd	a1,40(sp)
 6f4:	f832                	sd	a2,48(sp)
 6f6:	fc36                	sd	a3,56(sp)
 6f8:	e0ba                	sd	a4,64(sp)
 6fa:	e4be                	sd	a5,72(sp)
 6fc:	e8c2                	sd	a6,80(sp)
 6fe:	ecc6                	sd	a7,88(sp)
 700:	1030                	addi	a2,sp,40
 702:	e432                	sd	a2,8(sp)
 704:	85aa                	mv	a1,a0
 706:	4505                	li	a0,1
 708:	00000097          	auipc	ra,0x0
 70c:	dee080e7          	jalr	-530(ra) # 4f6 <vprintf>
 710:	60e2                	ld	ra,24(sp)
 712:	6125                	addi	sp,sp,96
 714:	8082                	ret

0000000000000716 <free>:
 716:	ff050693          	addi	a3,a0,-16
 71a:	00000797          	auipc	a5,0x0
 71e:	21e7b783          	ld	a5,542(a5) # 938 <freep>
 722:	a805                	j	752 <free+0x3c>
 724:	4618                	lw	a4,8(a2)
 726:	9db9                	addw	a1,a1,a4
 728:	feb52c23          	sw	a1,-8(a0)
 72c:	6398                	ld	a4,0(a5)
 72e:	6318                	ld	a4,0(a4)
 730:	fee53823          	sd	a4,-16(a0)
 734:	a091                	j	778 <free+0x62>
 736:	ff852703          	lw	a4,-8(a0)
 73a:	9e39                	addw	a2,a2,a4
 73c:	c790                	sw	a2,8(a5)
 73e:	ff053703          	ld	a4,-16(a0)
 742:	e398                	sd	a4,0(a5)
 744:	a099                	j	78a <free+0x74>
 746:	6398                	ld	a4,0(a5)
 748:	00e7e463          	bltu	a5,a4,750 <free+0x3a>
 74c:	00e6ea63          	bltu	a3,a4,760 <free+0x4a>
 750:	87ba                	mv	a5,a4
 752:	fed7fae3          	bgeu	a5,a3,746 <free+0x30>
 756:	6398                	ld	a4,0(a5)
 758:	00e6e463          	bltu	a3,a4,760 <free+0x4a>
 75c:	fee7eae3          	bltu	a5,a4,750 <free+0x3a>
 760:	ff852583          	lw	a1,-8(a0)
 764:	6390                	ld	a2,0(a5)
 766:	02059713          	slli	a4,a1,0x20
 76a:	9301                	srli	a4,a4,0x20
 76c:	0712                	slli	a4,a4,0x4
 76e:	9736                	add	a4,a4,a3
 770:	fae60ae3          	beq	a2,a4,724 <free+0xe>
 774:	fec53823          	sd	a2,-16(a0)
 778:	4790                	lw	a2,8(a5)
 77a:	02061713          	slli	a4,a2,0x20
 77e:	9301                	srli	a4,a4,0x20
 780:	0712                	slli	a4,a4,0x4
 782:	973e                	add	a4,a4,a5
 784:	fae689e3          	beq	a3,a4,736 <free+0x20>
 788:	e394                	sd	a3,0(a5)
 78a:	00000717          	auipc	a4,0x0
 78e:	1af73723          	sd	a5,430(a4) # 938 <freep>
 792:	8082                	ret

0000000000000794 <malloc>:
 794:	7139                	addi	sp,sp,-64
 796:	fc06                	sd	ra,56(sp)
 798:	f822                	sd	s0,48(sp)
 79a:	f426                	sd	s1,40(sp)
 79c:	f04a                	sd	s2,32(sp)
 79e:	ec4e                	sd	s3,24(sp)
 7a0:	e852                	sd	s4,16(sp)
 7a2:	e456                	sd	s5,8(sp)
 7a4:	02051413          	slli	s0,a0,0x20
 7a8:	9001                	srli	s0,s0,0x20
 7aa:	043d                	addi	s0,s0,15
 7ac:	8011                	srli	s0,s0,0x4
 7ae:	0014091b          	addiw	s2,s0,1
 7b2:	0405                	addi	s0,s0,1
 7b4:	00000517          	auipc	a0,0x0
 7b8:	18453503          	ld	a0,388(a0) # 938 <freep>
 7bc:	c905                	beqz	a0,7ec <malloc+0x58>
 7be:	611c                	ld	a5,0(a0)
 7c0:	4798                	lw	a4,8(a5)
 7c2:	04877163          	bgeu	a4,s0,804 <malloc+0x70>
 7c6:	89ca                	mv	s3,s2
 7c8:	0009071b          	sext.w	a4,s2
 7cc:	6685                	lui	a3,0x1
 7ce:	00d77363          	bgeu	a4,a3,7d4 <malloc+0x40>
 7d2:	6985                	lui	s3,0x1
 7d4:	00098a1b          	sext.w	s4,s3
 7d8:	1982                	slli	s3,s3,0x20
 7da:	0209d993          	srli	s3,s3,0x20
 7de:	0992                	slli	s3,s3,0x4
 7e0:	00000497          	auipc	s1,0x0
 7e4:	15848493          	addi	s1,s1,344 # 938 <freep>
 7e8:	5afd                	li	s5,-1
 7ea:	a0bd                	j	858 <malloc+0xc4>
 7ec:	00000797          	auipc	a5,0x0
 7f0:	15478793          	addi	a5,a5,340 # 940 <base>
 7f4:	00000717          	auipc	a4,0x0
 7f8:	14f73223          	sd	a5,324(a4) # 938 <freep>
 7fc:	e39c                	sd	a5,0(a5)
 7fe:	0007a423          	sw	zero,8(a5)
 802:	b7d1                	j	7c6 <malloc+0x32>
 804:	02e40a63          	beq	s0,a4,838 <malloc+0xa4>
 808:	4127073b          	subw	a4,a4,s2
 80c:	c798                	sw	a4,8(a5)
 80e:	1702                	slli	a4,a4,0x20
 810:	9301                	srli	a4,a4,0x20
 812:	0712                	slli	a4,a4,0x4
 814:	97ba                	add	a5,a5,a4
 816:	0127a423          	sw	s2,8(a5)
 81a:	00000717          	auipc	a4,0x0
 81e:	10a73f23          	sd	a0,286(a4) # 938 <freep>
 822:	01078513          	addi	a0,a5,16
 826:	70e2                	ld	ra,56(sp)
 828:	7442                	ld	s0,48(sp)
 82a:	74a2                	ld	s1,40(sp)
 82c:	7902                	ld	s2,32(sp)
 82e:	69e2                	ld	s3,24(sp)
 830:	6a42                	ld	s4,16(sp)
 832:	6aa2                	ld	s5,8(sp)
 834:	6121                	addi	sp,sp,64
 836:	8082                	ret
 838:	6398                	ld	a4,0(a5)
 83a:	e118                	sd	a4,0(a0)
 83c:	bff9                	j	81a <malloc+0x86>
 83e:	01452423          	sw	s4,8(a0)
 842:	0541                	addi	a0,a0,16
 844:	00000097          	auipc	ra,0x0
 848:	ed2080e7          	jalr	-302(ra) # 716 <free>
 84c:	6088                	ld	a0,0(s1)
 84e:	dd61                	beqz	a0,826 <malloc+0x92>
 850:	611c                	ld	a5,0(a0)
 852:	4798                	lw	a4,8(a5)
 854:	fa8778e3          	bgeu	a4,s0,804 <malloc+0x70>
 858:	6098                	ld	a4,0(s1)
 85a:	853e                	mv	a0,a5
 85c:	fef71ae3          	bne	a4,a5,850 <malloc+0xbc>
 860:	854e                	mv	a0,s3
 862:	00000097          	auipc	ra,0x0
 866:	8d8080e7          	jalr	-1832(ra) # 13a <sbrk>
 86a:	fd551ae3          	bne	a0,s5,83e <malloc+0xaa>
 86e:	4501                	li	a0,0
 870:	bf5d                	j	826 <malloc+0x92>
