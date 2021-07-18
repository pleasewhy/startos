
_oscmp_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_success>:
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	842a                	mv	s0,a0
   a:	00001517          	auipc	a0,0x1
   e:	b1650513          	addi	a0,a0,-1258 # b20 <malloc+0x118>
  12:	00001097          	auipc	ra,0x1
  16:	950080e7          	jalr	-1712(ra) # 962 <printf>
  1a:	600c                	ld	a1,0(s0)
  1c:	cd99                	beqz	a1,3a <print_success+0x3a>
  1e:	0421                	addi	s0,s0,8
  20:	00001497          	auipc	s1,0x1
  24:	b1848493          	addi	s1,s1,-1256 # b38 <malloc+0x130>
  28:	8526                	mv	a0,s1
  2a:	00001097          	auipc	ra,0x1
  2e:	938080e7          	jalr	-1736(ra) # 962 <printf>
  32:	0421                	addi	s0,s0,8
  34:	ff843583          	ld	a1,-8(s0)
  38:	f9e5                	bnez	a1,28 <print_success+0x28>
  3a:	00001517          	auipc	a0,0x1
  3e:	b0650513          	addi	a0,a0,-1274 # b40 <malloc+0x138>
  42:	00001097          	auipc	ra,0x1
  46:	920080e7          	jalr	-1760(ra) # 962 <printf>
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
  64:	336080e7          	jalr	822(ra) # 396 <fork>
  68:	ed09                	bnez	a0,82 <test+0x2e>
  6a:	4601                	li	a2,0
  6c:	85a2                	mv	a1,s0
  6e:	8526                	mv	a0,s1
  70:	00000097          	auipc	ra,0x0
  74:	44e080e7          	jalr	1102(ra) # 4be <execve>
  78:	70a2                	ld	ra,40(sp)
  7a:	7402                	ld	s0,32(sp)
  7c:	64e2                	ld	s1,24(sp)
  7e:	6145                	addi	sp,sp,48
  80:	8082                	ret
  82:	0068                	addi	a0,sp,12
  84:	00000097          	auipc	ra,0x0
  88:	31a080e7          	jalr	794(ra) # 39e <wait>
  8c:	47b2                	lw	a5,12(sp)
  8e:	fe07c5e3          	bltz	a5,78 <test+0x24>
  92:	8522                	mv	a0,s0
  94:	00000097          	auipc	ra,0x0
  98:	f6c080e7          	jalr	-148(ra) # 0 <print_success>
  9c:	bff1                	j	78 <test+0x24>

000000000000009e <main>:
  9e:	7121                	addi	sp,sp,-448
  a0:	ff06                	sd	ra,440(sp)
  a2:	4589                	li	a1,2
  a4:	00001517          	auipc	a0,0x1
  a8:	aac50513          	addi	a0,a0,-1364 # b50 <malloc+0x148>
  ac:	00000097          	auipc	ra,0x0
  b0:	2fa080e7          	jalr	762(ra) # 3a6 <open>
  b4:	4501                	li	a0,0
  b6:	00000097          	auipc	ra,0x0
  ba:	308080e7          	jalr	776(ra) # 3be <dup>
  be:	4501                	li	a0,0
  c0:	00000097          	auipc	ra,0x0
  c4:	2fe080e7          	jalr	766(ra) # 3be <dup>
  c8:	00001797          	auipc	a5,0x1
  cc:	a9078793          	addi	a5,a5,-1392 # b58 <malloc+0x150>
  d0:	ef3e                	sd	a5,408(sp)
  d2:	00001797          	auipc	a5,0x1
  d6:	a8e78793          	addi	a5,a5,-1394 # b60 <malloc+0x158>
  da:	f33e                	sd	a5,416(sp)
  dc:	f702                	sd	zero,424(sp)
  de:	00001797          	auipc	a5,0x1
  e2:	b6a78793          	addi	a5,a5,-1174 # c48 <malloc+0x240>
  e6:	638c                	ld	a1,0(a5)
  e8:	6790                	ld	a2,8(a5)
  ea:	6b94                	ld	a3,16(a5)
  ec:	6f98                	ld	a4,24(a5)
  ee:	feae                	sd	a1,376(sp)
  f0:	e332                	sd	a2,384(sp)
  f2:	e736                	sd	a3,392(sp)
  f4:	eb3a                	sd	a4,400(sp)
  f6:	738c                	ld	a1,32(a5)
  f8:	7790                	ld	a2,40(a5)
  fa:	7b94                	ld	a3,48(a5)
  fc:	7f98                	ld	a4,56(a5)
  fe:	eeae                	sd	a1,344(sp)
 100:	f2b2                	sd	a2,352(sp)
 102:	f6b6                	sd	a3,360(sp)
 104:	faba                	sd	a4,368(sp)
 106:	00001717          	auipc	a4,0x1
 10a:	a7a70713          	addi	a4,a4,-1414 # b80 <malloc+0x178>
 10e:	e2ba                	sd	a4,320(sp)
 110:	00001717          	auipc	a4,0x1
 114:	a8070713          	addi	a4,a4,-1408 # b90 <malloc+0x188>
 118:	e6ba                	sd	a4,328(sp)
 11a:	ea82                	sd	zero,336(sp)
 11c:	00001697          	auipc	a3,0x1
 120:	a8468693          	addi	a3,a3,-1404 # ba0 <malloc+0x198>
 124:	fa36                	sd	a3,304(sp)
 126:	fe02                	sd	zero,312(sp)
 128:	00001697          	auipc	a3,0x1
 12c:	a8068693          	addi	a3,a3,-1408 # ba8 <malloc+0x1a0>
 130:	f236                	sd	a3,288(sp)
 132:	f602                	sd	zero,296(sp)
 134:	00001697          	auipc	a3,0x1
 138:	a7c68693          	addi	a3,a3,-1412 # bb0 <malloc+0x1a8>
 13c:	ea36                	sd	a3,272(sp)
 13e:	ee02                	sd	zero,280(sp)
 140:	00001697          	auipc	a3,0x1
 144:	a7868693          	addi	a3,a3,-1416 # bb8 <malloc+0x1b0>
 148:	fdb6                	sd	a3,248(sp)
 14a:	e23a                	sd	a4,256(sp)
 14c:	e602                	sd	zero,264(sp)
 14e:	63ac                	ld	a1,64(a5)
 150:	67b0                	ld	a2,72(a5)
 152:	6bb4                	ld	a3,80(a5)
 154:	6fb8                	ld	a4,88(a5)
 156:	73bc                	ld	a5,96(a5)
 158:	e9ae                	sd	a1,208(sp)
 15a:	edb2                	sd	a2,216(sp)
 15c:	f1b6                	sd	a3,224(sp)
 15e:	f5ba                	sd	a4,232(sp)
 160:	f9be                	sd	a5,240(sp)
 162:	00001797          	auipc	a5,0x1
 166:	a5e78793          	addi	a5,a5,-1442 # bc0 <malloc+0x1b8>
 16a:	e1be                	sd	a5,192(sp)
 16c:	e582                	sd	zero,200(sp)
 16e:	00001797          	auipc	a5,0x1
 172:	a5a78793          	addi	a5,a5,-1446 # bc8 <malloc+0x1c0>
 176:	f93e                	sd	a5,176(sp)
 178:	fd02                	sd	zero,184(sp)
 17a:	00001797          	auipc	a5,0x1
 17e:	a5678793          	addi	a5,a5,-1450 # bd0 <malloc+0x1c8>
 182:	ed3e                	sd	a5,152(sp)
 184:	00001797          	auipc	a5,0x1
 188:	a5478793          	addi	a5,a5,-1452 # bd8 <malloc+0x1d0>
 18c:	f13e                	sd	a5,160(sp)
 18e:	f502                	sd	zero,168(sp)
 190:	00001717          	auipc	a4,0x1
 194:	a5070713          	addi	a4,a4,-1456 # be0 <malloc+0x1d8>
 198:	e53a                	sd	a4,136(sp)
 19a:	e902                	sd	zero,144(sp)
 19c:	00001717          	auipc	a4,0x1
 1a0:	a4c70713          	addi	a4,a4,-1460 # be8 <malloc+0x1e0>
 1a4:	fcba                	sd	a4,120(sp)
 1a6:	e102                	sd	zero,128(sp)
 1a8:	00001717          	auipc	a4,0x1
 1ac:	a4870713          	addi	a4,a4,-1464 # bf0 <malloc+0x1e8>
 1b0:	f4ba                	sd	a4,104(sp)
 1b2:	f882                	sd	zero,112(sp)
 1b4:	00001717          	auipc	a4,0x1
 1b8:	a4470713          	addi	a4,a4,-1468 # bf8 <malloc+0x1f0>
 1bc:	ecba                	sd	a4,88(sp)
 1be:	f082                	sd	zero,96(sp)
 1c0:	00001717          	auipc	a4,0x1
 1c4:	a4070713          	addi	a4,a4,-1472 # c00 <malloc+0x1f8>
 1c8:	e0ba                	sd	a4,64(sp)
 1ca:	00001717          	auipc	a4,0x1
 1ce:	a3e70713          	addi	a4,a4,-1474 # c08 <malloc+0x200>
 1d2:	e4ba                	sd	a4,72(sp)
 1d4:	e882                	sd	zero,80(sp)
 1d6:	f83e                	sd	a5,48(sp)
 1d8:	fc02                	sd	zero,56(sp)
 1da:	00001797          	auipc	a5,0x1
 1de:	a3678793          	addi	a5,a5,-1482 # c10 <malloc+0x208>
 1e2:	f03e                	sd	a5,32(sp)
 1e4:	f402                	sd	zero,40(sp)
 1e6:	0b2c                	addi	a1,sp,408
 1e8:	00001517          	auipc	a0,0x1
 1ec:	a3050513          	addi	a0,a0,-1488 # c18 <malloc+0x210>
 1f0:	00000097          	auipc	ra,0x0
 1f4:	e64080e7          	jalr	-412(ra) # 54 <test>
 1f8:	1aac                	addi	a1,sp,376
 1fa:	00001517          	auipc	a0,0x1
 1fe:	a1e50513          	addi	a0,a0,-1506 # c18 <malloc+0x210>
 202:	00000097          	auipc	ra,0x0
 206:	e52080e7          	jalr	-430(ra) # 54 <test>
 20a:	0aac                	addi	a1,sp,344
 20c:	00001517          	auipc	a0,0x1
 210:	a0c50513          	addi	a0,a0,-1524 # c18 <malloc+0x210>
 214:	00000097          	auipc	ra,0x0
 218:	e40080e7          	jalr	-448(ra) # 54 <test>
 21c:	028c                	addi	a1,sp,320
 21e:	00001517          	auipc	a0,0x1
 222:	9fa50513          	addi	a0,a0,-1542 # c18 <malloc+0x210>
 226:	00000097          	auipc	ra,0x0
 22a:	e2e080e7          	jalr	-466(ra) # 54 <test>
 22e:	1a0c                	addi	a1,sp,304
 230:	00001517          	auipc	a0,0x1
 234:	9e850513          	addi	a0,a0,-1560 # c18 <malloc+0x210>
 238:	00000097          	auipc	ra,0x0
 23c:	e1c080e7          	jalr	-484(ra) # 54 <test>
 240:	120c                	addi	a1,sp,288
 242:	00001517          	auipc	a0,0x1
 246:	9d650513          	addi	a0,a0,-1578 # c18 <malloc+0x210>
 24a:	00000097          	auipc	ra,0x0
 24e:	e0a080e7          	jalr	-502(ra) # 54 <test>
 252:	0a0c                	addi	a1,sp,272
 254:	00001517          	auipc	a0,0x1
 258:	9c450513          	addi	a0,a0,-1596 # c18 <malloc+0x210>
 25c:	00000097          	auipc	ra,0x0
 260:	df8080e7          	jalr	-520(ra) # 54 <test>
 264:	19ac                	addi	a1,sp,248
 266:	00001517          	auipc	a0,0x1
 26a:	9b250513          	addi	a0,a0,-1614 # c18 <malloc+0x210>
 26e:	00000097          	auipc	ra,0x0
 272:	de6080e7          	jalr	-538(ra) # 54 <test>
 276:	098c                	addi	a1,sp,208
 278:	00001517          	auipc	a0,0x1
 27c:	9a050513          	addi	a0,a0,-1632 # c18 <malloc+0x210>
 280:	00000097          	auipc	ra,0x0
 284:	dd4080e7          	jalr	-556(ra) # 54 <test>
 288:	018c                	addi	a1,sp,192
 28a:	00001517          	auipc	a0,0x1
 28e:	98e50513          	addi	a0,a0,-1650 # c18 <malloc+0x210>
 292:	00000097          	auipc	ra,0x0
 296:	dc2080e7          	jalr	-574(ra) # 54 <test>
 29a:	190c                	addi	a1,sp,176
 29c:	00001517          	auipc	a0,0x1
 2a0:	97c50513          	addi	a0,a0,-1668 # c18 <malloc+0x210>
 2a4:	00000097          	auipc	ra,0x0
 2a8:	db0080e7          	jalr	-592(ra) # 54 <test>
 2ac:	092c                	addi	a1,sp,152
 2ae:	00001517          	auipc	a0,0x1
 2b2:	96a50513          	addi	a0,a0,-1686 # c18 <malloc+0x210>
 2b6:	00000097          	auipc	ra,0x0
 2ba:	d9e080e7          	jalr	-610(ra) # 54 <test>
 2be:	012c                	addi	a1,sp,136
 2c0:	00001517          	auipc	a0,0x1
 2c4:	95850513          	addi	a0,a0,-1704 # c18 <malloc+0x210>
 2c8:	00000097          	auipc	ra,0x0
 2cc:	d8c080e7          	jalr	-628(ra) # 54 <test>
 2d0:	18ac                	addi	a1,sp,120
 2d2:	00001517          	auipc	a0,0x1
 2d6:	94650513          	addi	a0,a0,-1722 # c18 <malloc+0x210>
 2da:	00000097          	auipc	ra,0x0
 2de:	d7a080e7          	jalr	-646(ra) # 54 <test>
 2e2:	10ac                	addi	a1,sp,104
 2e4:	00001517          	auipc	a0,0x1
 2e8:	93450513          	addi	a0,a0,-1740 # c18 <malloc+0x210>
 2ec:	00000097          	auipc	ra,0x0
 2f0:	d68080e7          	jalr	-664(ra) # 54 <test>
 2f4:	008c                	addi	a1,sp,64
 2f6:	00001517          	auipc	a0,0x1
 2fa:	92250513          	addi	a0,a0,-1758 # c18 <malloc+0x210>
 2fe:	00000097          	auipc	ra,0x0
 302:	d56080e7          	jalr	-682(ra) # 54 <test>
 306:	180c                	addi	a1,sp,48
 308:	00001517          	auipc	a0,0x1
 30c:	91050513          	addi	a0,a0,-1776 # c18 <malloc+0x210>
 310:	00000097          	auipc	ra,0x0
 314:	d44080e7          	jalr	-700(ra) # 54 <test>
 318:	100c                	addi	a1,sp,32
 31a:	00001517          	auipc	a0,0x1
 31e:	8fe50513          	addi	a0,a0,-1794 # c18 <malloc+0x210>
 322:	00000097          	auipc	ra,0x0
 326:	d32080e7          	jalr	-718(ra) # 54 <test>
 32a:	08ac                	addi	a1,sp,88
 32c:	00001517          	auipc	a0,0x1
 330:	8ec50513          	addi	a0,a0,-1812 # c18 <malloc+0x210>
 334:	00000097          	auipc	ra,0x0
 338:	d20080e7          	jalr	-736(ra) # 54 <test>
 33c:	00000797          	auipc	a5,0x0
 340:	7c478793          	addi	a5,a5,1988 # b00 <malloc+0xf8>
 344:	e43e                	sd	a5,8(sp)
 346:	00001797          	auipc	a5,0x1
 34a:	8da78793          	addi	a5,a5,-1830 # c20 <malloc+0x218>
 34e:	e83e                	sd	a5,16(sp)
 350:	ec02                	sd	zero,24(sp)
 352:	00000097          	auipc	ra,0x0
 356:	044080e7          	jalr	68(ra) # 396 <fork>
 35a:	e905                	bnez	a0,38a <main+0x2ec>
 35c:	00001517          	auipc	a0,0x1
 360:	8dc50513          	addi	a0,a0,-1828 # c38 <malloc+0x230>
 364:	00000097          	auipc	ra,0x0
 368:	5fe080e7          	jalr	1534(ra) # 962 <printf>
 36c:	4601                	li	a2,0
 36e:	002c                	addi	a1,sp,8
 370:	00001517          	auipc	a0,0x1
 374:	8a850513          	addi	a0,a0,-1880 # c18 <malloc+0x210>
 378:	00000097          	auipc	ra,0x0
 37c:	146080e7          	jalr	326(ra) # 4be <execve>
 380:	00000097          	auipc	ra,0x0
 384:	15c080e7          	jalr	348(ra) # 4dc <kernel_panic>
 388:	a001                	j	388 <main+0x2ea>
 38a:	0048                	addi	a0,sp,4
 38c:	00000097          	auipc	ra,0x0
 390:	012080e7          	jalr	18(ra) # 39e <wait>
 394:	b7f5                	j	380 <main+0x2e2>

0000000000000396 <fork>:
 396:	4885                	li	a7,1
 398:	00000073          	ecall
 39c:	8082                	ret

000000000000039e <wait>:
 39e:	488d                	li	a7,3
 3a0:	00000073          	ecall
 3a4:	8082                	ret

00000000000003a6 <open>:
 3a6:	4889                	li	a7,2
 3a8:	00000073          	ecall
 3ac:	8082                	ret

00000000000003ae <sbrk>:
 3ae:	4891                	li	a7,4
 3b0:	00000073          	ecall
 3b4:	8082                	ret

00000000000003b6 <getcwd>:
 3b6:	48c5                	li	a7,17
 3b8:	00000073          	ecall
 3bc:	8082                	ret

00000000000003be <dup>:
 3be:	48dd                	li	a7,23
 3c0:	00000073          	ecall
 3c4:	8082                	ret

00000000000003c6 <dup3>:
 3c6:	48e1                	li	a7,24
 3c8:	00000073          	ecall
 3cc:	8082                	ret

00000000000003ce <mkdirat>:
 3ce:	02200893          	li	a7,34
 3d2:	00000073          	ecall
 3d6:	8082                	ret

00000000000003d8 <unlinkat>:
 3d8:	02300893          	li	a7,35
 3dc:	00000073          	ecall
 3e0:	8082                	ret

00000000000003e2 <linkat>:
 3e2:	02500893          	li	a7,37
 3e6:	00000073          	ecall
 3ea:	8082                	ret

00000000000003ec <umount2>:
 3ec:	02700893          	li	a7,39
 3f0:	00000073          	ecall
 3f4:	8082                	ret

00000000000003f6 <mount>:
 3f6:	02800893          	li	a7,40
 3fa:	00000073          	ecall
 3fe:	8082                	ret

0000000000000400 <chdir>:
 400:	03100893          	li	a7,49
 404:	00000073          	ecall
 408:	8082                	ret

000000000000040a <openat>:
 40a:	03800893          	li	a7,56
 40e:	00000073          	ecall
 412:	8082                	ret

0000000000000414 <close>:
 414:	03900893          	li	a7,57
 418:	00000073          	ecall
 41c:	8082                	ret

000000000000041e <pipe2>:
 41e:	03b00893          	li	a7,59
 422:	00000073          	ecall
 426:	8082                	ret

0000000000000428 <getdents64>:
 428:	03d00893          	li	a7,61
 42c:	00000073          	ecall
 430:	8082                	ret

0000000000000432 <read>:
 432:	03f00893          	li	a7,63
 436:	00000073          	ecall
 43a:	8082                	ret

000000000000043c <write>:
 43c:	04000893          	li	a7,64
 440:	00000073          	ecall
 444:	8082                	ret

0000000000000446 <fstat>:
 446:	05000893          	li	a7,80
 44a:	00000073          	ecall
 44e:	8082                	ret

0000000000000450 <exit>:
 450:	05d00893          	li	a7,93
 454:	00000073          	ecall
 458:	8082                	ret

000000000000045a <nanosleep>:
 45a:	06500893          	li	a7,101
 45e:	00000073          	ecall
 462:	8082                	ret

0000000000000464 <sched_yield>:
 464:	07c00893          	li	a7,124
 468:	00000073          	ecall
 46c:	8082                	ret

000000000000046e <times>:
 46e:	09900893          	li	a7,153
 472:	00000073          	ecall
 476:	8082                	ret

0000000000000478 <uname>:
 478:	0a000893          	li	a7,160
 47c:	00000073          	ecall
 480:	8082                	ret

0000000000000482 <gettimeofday>:
 482:	0a900893          	li	a7,169
 486:	00000073          	ecall
 48a:	8082                	ret

000000000000048c <brk>:
 48c:	0d600893          	li	a7,214
 490:	00000073          	ecall
 494:	8082                	ret

0000000000000496 <munmap>:
 496:	0d700893          	li	a7,215
 49a:	00000073          	ecall
 49e:	8082                	ret

00000000000004a0 <getpid>:
 4a0:	0ac00893          	li	a7,172
 4a4:	00000073          	ecall
 4a8:	8082                	ret

00000000000004aa <getppid>:
 4aa:	0ad00893          	li	a7,173
 4ae:	00000073          	ecall
 4b2:	8082                	ret

00000000000004b4 <clone>:
 4b4:	0dc00893          	li	a7,220
 4b8:	00000073          	ecall
 4bc:	8082                	ret

00000000000004be <execve>:
 4be:	0dd00893          	li	a7,221
 4c2:	00000073          	ecall
 4c6:	8082                	ret

00000000000004c8 <mmap>:
 4c8:	0de00893          	li	a7,222
 4cc:	00000073          	ecall
 4d0:	8082                	ret

00000000000004d2 <wait4>:
 4d2:	10400893          	li	a7,260
 4d6:	00000073          	ecall
 4da:	8082                	ret

00000000000004dc <kernel_panic>:
 4dc:	18f00893          	li	a7,399
 4e0:	00000073          	ecall
 4e4:	8082                	ret

00000000000004e6 <strcpy>:
 4e6:	87aa                	mv	a5,a0
 4e8:	0585                	addi	a1,a1,1
 4ea:	0785                	addi	a5,a5,1
 4ec:	fff5c703          	lbu	a4,-1(a1)
 4f0:	fee78fa3          	sb	a4,-1(a5)
 4f4:	fb75                	bnez	a4,4e8 <strcpy+0x2>
 4f6:	8082                	ret

00000000000004f8 <strcmp>:
 4f8:	00054783          	lbu	a5,0(a0)
 4fc:	cb91                	beqz	a5,510 <strcmp+0x18>
 4fe:	0005c703          	lbu	a4,0(a1)
 502:	00f71763          	bne	a4,a5,510 <strcmp+0x18>
 506:	0505                	addi	a0,a0,1
 508:	0585                	addi	a1,a1,1
 50a:	00054783          	lbu	a5,0(a0)
 50e:	fbe5                	bnez	a5,4fe <strcmp+0x6>
 510:	0005c503          	lbu	a0,0(a1)
 514:	40a7853b          	subw	a0,a5,a0
 518:	8082                	ret

000000000000051a <strlen>:
 51a:	00054783          	lbu	a5,0(a0)
 51e:	cf81                	beqz	a5,536 <strlen+0x1c>
 520:	0505                	addi	a0,a0,1
 522:	87aa                	mv	a5,a0
 524:	4685                	li	a3,1
 526:	9e89                	subw	a3,a3,a0
 528:	00f6853b          	addw	a0,a3,a5
 52c:	0785                	addi	a5,a5,1
 52e:	fff7c703          	lbu	a4,-1(a5)
 532:	fb7d                	bnez	a4,528 <strlen+0xe>
 534:	8082                	ret
 536:	4501                	li	a0,0
 538:	8082                	ret

000000000000053a <memset>:
 53a:	ce09                	beqz	a2,554 <memset+0x1a>
 53c:	87aa                	mv	a5,a0
 53e:	fff6071b          	addiw	a4,a2,-1
 542:	1702                	slli	a4,a4,0x20
 544:	9301                	srli	a4,a4,0x20
 546:	0705                	addi	a4,a4,1
 548:	972a                	add	a4,a4,a0
 54a:	00b78023          	sb	a1,0(a5)
 54e:	0785                	addi	a5,a5,1
 550:	fee79de3          	bne	a5,a4,54a <memset+0x10>
 554:	8082                	ret

0000000000000556 <strchr>:
 556:	00054783          	lbu	a5,0(a0)
 55a:	cb89                	beqz	a5,56c <strchr+0x16>
 55c:	00f58963          	beq	a1,a5,56e <strchr+0x18>
 560:	0505                	addi	a0,a0,1
 562:	00054783          	lbu	a5,0(a0)
 566:	fbfd                	bnez	a5,55c <strchr+0x6>
 568:	4501                	li	a0,0
 56a:	8082                	ret
 56c:	4501                	li	a0,0
 56e:	8082                	ret

0000000000000570 <gets>:
 570:	715d                	addi	sp,sp,-80
 572:	e486                	sd	ra,72(sp)
 574:	e0a2                	sd	s0,64(sp)
 576:	fc26                	sd	s1,56(sp)
 578:	f84a                	sd	s2,48(sp)
 57a:	f44e                	sd	s3,40(sp)
 57c:	f052                	sd	s4,32(sp)
 57e:	ec56                	sd	s5,24(sp)
 580:	e85a                	sd	s6,16(sp)
 582:	8b2a                	mv	s6,a0
 584:	89ae                	mv	s3,a1
 586:	84aa                	mv	s1,a0
 588:	4401                	li	s0,0
 58a:	4a29                	li	s4,10
 58c:	4ab5                	li	s5,13
 58e:	8922                	mv	s2,s0
 590:	2405                	addiw	s0,s0,1
 592:	03345863          	bge	s0,s3,5c2 <gets+0x52>
 596:	4605                	li	a2,1
 598:	00f10593          	addi	a1,sp,15
 59c:	4501                	li	a0,0
 59e:	00000097          	auipc	ra,0x0
 5a2:	e94080e7          	jalr	-364(ra) # 432 <read>
 5a6:	00a05e63          	blez	a0,5c2 <gets+0x52>
 5aa:	00f14783          	lbu	a5,15(sp)
 5ae:	00f48023          	sb	a5,0(s1)
 5b2:	01478763          	beq	a5,s4,5c0 <gets+0x50>
 5b6:	0485                	addi	s1,s1,1
 5b8:	fd579be3          	bne	a5,s5,58e <gets+0x1e>
 5bc:	8922                	mv	s2,s0
 5be:	a011                	j	5c2 <gets+0x52>
 5c0:	8922                	mv	s2,s0
 5c2:	995a                	add	s2,s2,s6
 5c4:	00090023          	sb	zero,0(s2)
 5c8:	855a                	mv	a0,s6
 5ca:	60a6                	ld	ra,72(sp)
 5cc:	6406                	ld	s0,64(sp)
 5ce:	74e2                	ld	s1,56(sp)
 5d0:	7942                	ld	s2,48(sp)
 5d2:	79a2                	ld	s3,40(sp)
 5d4:	7a02                	ld	s4,32(sp)
 5d6:	6ae2                	ld	s5,24(sp)
 5d8:	6b42                	ld	s6,16(sp)
 5da:	6161                	addi	sp,sp,80
 5dc:	8082                	ret

00000000000005de <atoi>:
 5de:	86aa                	mv	a3,a0
 5e0:	00054603          	lbu	a2,0(a0)
 5e4:	fd06079b          	addiw	a5,a2,-48
 5e8:	0ff7f793          	andi	a5,a5,255
 5ec:	4725                	li	a4,9
 5ee:	02f76663          	bltu	a4,a5,61a <atoi+0x3c>
 5f2:	4501                	li	a0,0
 5f4:	45a5                	li	a1,9
 5f6:	0685                	addi	a3,a3,1
 5f8:	0025179b          	slliw	a5,a0,0x2
 5fc:	9fa9                	addw	a5,a5,a0
 5fe:	0017979b          	slliw	a5,a5,0x1
 602:	9fb1                	addw	a5,a5,a2
 604:	fd07851b          	addiw	a0,a5,-48
 608:	0006c603          	lbu	a2,0(a3)
 60c:	fd06071b          	addiw	a4,a2,-48
 610:	0ff77713          	andi	a4,a4,255
 614:	fee5f1e3          	bgeu	a1,a4,5f6 <atoi+0x18>
 618:	8082                	ret
 61a:	4501                	li	a0,0
 61c:	8082                	ret

000000000000061e <memmove>:
 61e:	02b57463          	bgeu	a0,a1,646 <memmove+0x28>
 622:	04c05663          	blez	a2,66e <memmove+0x50>
 626:	fff6079b          	addiw	a5,a2,-1
 62a:	1782                	slli	a5,a5,0x20
 62c:	9381                	srli	a5,a5,0x20
 62e:	0785                	addi	a5,a5,1
 630:	97aa                	add	a5,a5,a0
 632:	872a                	mv	a4,a0
 634:	0585                	addi	a1,a1,1
 636:	0705                	addi	a4,a4,1
 638:	fff5c683          	lbu	a3,-1(a1)
 63c:	fed70fa3          	sb	a3,-1(a4)
 640:	fee79ae3          	bne	a5,a4,634 <memmove+0x16>
 644:	8082                	ret
 646:	00c50733          	add	a4,a0,a2
 64a:	95b2                	add	a1,a1,a2
 64c:	02c05163          	blez	a2,66e <memmove+0x50>
 650:	fff6079b          	addiw	a5,a2,-1
 654:	1782                	slli	a5,a5,0x20
 656:	9381                	srli	a5,a5,0x20
 658:	fff7c793          	not	a5,a5
 65c:	97ba                	add	a5,a5,a4
 65e:	15fd                	addi	a1,a1,-1
 660:	177d                	addi	a4,a4,-1
 662:	0005c683          	lbu	a3,0(a1)
 666:	00d70023          	sb	a3,0(a4)
 66a:	fee79ae3          	bne	a5,a4,65e <memmove+0x40>
 66e:	8082                	ret

0000000000000670 <memcmp>:
 670:	fff6069b          	addiw	a3,a2,-1
 674:	c605                	beqz	a2,69c <memcmp+0x2c>
 676:	1682                	slli	a3,a3,0x20
 678:	9281                	srli	a3,a3,0x20
 67a:	0685                	addi	a3,a3,1
 67c:	96aa                	add	a3,a3,a0
 67e:	00054783          	lbu	a5,0(a0)
 682:	0005c703          	lbu	a4,0(a1)
 686:	00e79863          	bne	a5,a4,696 <memcmp+0x26>
 68a:	0505                	addi	a0,a0,1
 68c:	0585                	addi	a1,a1,1
 68e:	fed518e3          	bne	a0,a3,67e <memcmp+0xe>
 692:	4501                	li	a0,0
 694:	8082                	ret
 696:	40e7853b          	subw	a0,a5,a4
 69a:	8082                	ret
 69c:	4501                	li	a0,0
 69e:	8082                	ret

00000000000006a0 <memcpy>:
 6a0:	1141                	addi	sp,sp,-16
 6a2:	e406                	sd	ra,8(sp)
 6a4:	00000097          	auipc	ra,0x0
 6a8:	f7a080e7          	jalr	-134(ra) # 61e <memmove>
 6ac:	60a2                	ld	ra,8(sp)
 6ae:	0141                	addi	sp,sp,16
 6b0:	8082                	ret

00000000000006b2 <putc>:
 6b2:	1101                	addi	sp,sp,-32
 6b4:	ec06                	sd	ra,24(sp)
 6b6:	00b107a3          	sb	a1,15(sp)
 6ba:	4605                	li	a2,1
 6bc:	00f10593          	addi	a1,sp,15
 6c0:	00000097          	auipc	ra,0x0
 6c4:	d7c080e7          	jalr	-644(ra) # 43c <write>
 6c8:	60e2                	ld	ra,24(sp)
 6ca:	6105                	addi	sp,sp,32
 6cc:	8082                	ret

00000000000006ce <printint>:
 6ce:	7179                	addi	sp,sp,-48
 6d0:	f406                	sd	ra,40(sp)
 6d2:	f022                	sd	s0,32(sp)
 6d4:	ec26                	sd	s1,24(sp)
 6d6:	e84a                	sd	s2,16(sp)
 6d8:	84aa                	mv	s1,a0
 6da:	c299                	beqz	a3,6e0 <printint+0x12>
 6dc:	0805c363          	bltz	a1,762 <printint+0x94>
 6e0:	2581                	sext.w	a1,a1
 6e2:	4881                	li	a7,0
 6e4:	868a                	mv	a3,sp
 6e6:	4701                	li	a4,0
 6e8:	2601                	sext.w	a2,a2
 6ea:	00000517          	auipc	a0,0x0
 6ee:	5ce50513          	addi	a0,a0,1486 # cb8 <digits>
 6f2:	883a                	mv	a6,a4
 6f4:	2705                	addiw	a4,a4,1
 6f6:	02c5f7bb          	remuw	a5,a1,a2
 6fa:	1782                	slli	a5,a5,0x20
 6fc:	9381                	srli	a5,a5,0x20
 6fe:	97aa                	add	a5,a5,a0
 700:	0007c783          	lbu	a5,0(a5)
 704:	00f68023          	sb	a5,0(a3)
 708:	0005879b          	sext.w	a5,a1
 70c:	02c5d5bb          	divuw	a1,a1,a2
 710:	0685                	addi	a3,a3,1
 712:	fec7f0e3          	bgeu	a5,a2,6f2 <printint+0x24>
 716:	00088a63          	beqz	a7,72a <printint+0x5c>
 71a:	081c                	addi	a5,sp,16
 71c:	973e                	add	a4,a4,a5
 71e:	02d00793          	li	a5,45
 722:	fef70823          	sb	a5,-16(a4)
 726:	0028071b          	addiw	a4,a6,2
 72a:	02e05663          	blez	a4,756 <printint+0x88>
 72e:	00e10433          	add	s0,sp,a4
 732:	fff10913          	addi	s2,sp,-1
 736:	993a                	add	s2,s2,a4
 738:	377d                	addiw	a4,a4,-1
 73a:	1702                	slli	a4,a4,0x20
 73c:	9301                	srli	a4,a4,0x20
 73e:	40e90933          	sub	s2,s2,a4
 742:	fff44583          	lbu	a1,-1(s0)
 746:	8526                	mv	a0,s1
 748:	00000097          	auipc	ra,0x0
 74c:	f6a080e7          	jalr	-150(ra) # 6b2 <putc>
 750:	147d                	addi	s0,s0,-1
 752:	ff2418e3          	bne	s0,s2,742 <printint+0x74>
 756:	70a2                	ld	ra,40(sp)
 758:	7402                	ld	s0,32(sp)
 75a:	64e2                	ld	s1,24(sp)
 75c:	6942                	ld	s2,16(sp)
 75e:	6145                	addi	sp,sp,48
 760:	8082                	ret
 762:	40b005bb          	negw	a1,a1
 766:	4885                	li	a7,1
 768:	bfb5                	j	6e4 <printint+0x16>

000000000000076a <vprintf>:
 76a:	7119                	addi	sp,sp,-128
 76c:	fc86                	sd	ra,120(sp)
 76e:	f8a2                	sd	s0,112(sp)
 770:	f4a6                	sd	s1,104(sp)
 772:	f0ca                	sd	s2,96(sp)
 774:	ecce                	sd	s3,88(sp)
 776:	e8d2                	sd	s4,80(sp)
 778:	e4d6                	sd	s5,72(sp)
 77a:	e0da                	sd	s6,64(sp)
 77c:	fc5e                	sd	s7,56(sp)
 77e:	f862                	sd	s8,48(sp)
 780:	f466                	sd	s9,40(sp)
 782:	f06a                	sd	s10,32(sp)
 784:	ec6e                	sd	s11,24(sp)
 786:	0005c483          	lbu	s1,0(a1)
 78a:	18048c63          	beqz	s1,922 <vprintf+0x1b8>
 78e:	8a2a                	mv	s4,a0
 790:	8ab2                	mv	s5,a2
 792:	00158413          	addi	s0,a1,1
 796:	4901                	li	s2,0
 798:	02500993          	li	s3,37
 79c:	06400b93          	li	s7,100
 7a0:	06c00c13          	li	s8,108
 7a4:	07800c93          	li	s9,120
 7a8:	07000d13          	li	s10,112
 7ac:	07300d93          	li	s11,115
 7b0:	00000b17          	auipc	s6,0x0
 7b4:	508b0b13          	addi	s6,s6,1288 # cb8 <digits>
 7b8:	a839                	j	7d6 <vprintf+0x6c>
 7ba:	85a6                	mv	a1,s1
 7bc:	8552                	mv	a0,s4
 7be:	00000097          	auipc	ra,0x0
 7c2:	ef4080e7          	jalr	-268(ra) # 6b2 <putc>
 7c6:	a019                	j	7cc <vprintf+0x62>
 7c8:	01390f63          	beq	s2,s3,7e6 <vprintf+0x7c>
 7cc:	0405                	addi	s0,s0,1
 7ce:	fff44483          	lbu	s1,-1(s0)
 7d2:	14048863          	beqz	s1,922 <vprintf+0x1b8>
 7d6:	0004879b          	sext.w	a5,s1
 7da:	fe0917e3          	bnez	s2,7c8 <vprintf+0x5e>
 7de:	fd379ee3          	bne	a5,s3,7ba <vprintf+0x50>
 7e2:	893e                	mv	s2,a5
 7e4:	b7e5                	j	7cc <vprintf+0x62>
 7e6:	03778e63          	beq	a5,s7,822 <vprintf+0xb8>
 7ea:	05878a63          	beq	a5,s8,83e <vprintf+0xd4>
 7ee:	07978663          	beq	a5,s9,85a <vprintf+0xf0>
 7f2:	09a78263          	beq	a5,s10,876 <vprintf+0x10c>
 7f6:	0db78363          	beq	a5,s11,8bc <vprintf+0x152>
 7fa:	06300713          	li	a4,99
 7fe:	0ee78b63          	beq	a5,a4,8f4 <vprintf+0x18a>
 802:	11378563          	beq	a5,s3,90c <vprintf+0x1a2>
 806:	85ce                	mv	a1,s3
 808:	8552                	mv	a0,s4
 80a:	00000097          	auipc	ra,0x0
 80e:	ea8080e7          	jalr	-344(ra) # 6b2 <putc>
 812:	85a6                	mv	a1,s1
 814:	8552                	mv	a0,s4
 816:	00000097          	auipc	ra,0x0
 81a:	e9c080e7          	jalr	-356(ra) # 6b2 <putc>
 81e:	4901                	li	s2,0
 820:	b775                	j	7cc <vprintf+0x62>
 822:	008a8493          	addi	s1,s5,8
 826:	4685                	li	a3,1
 828:	4629                	li	a2,10
 82a:	000aa583          	lw	a1,0(s5)
 82e:	8552                	mv	a0,s4
 830:	00000097          	auipc	ra,0x0
 834:	e9e080e7          	jalr	-354(ra) # 6ce <printint>
 838:	8aa6                	mv	s5,s1
 83a:	4901                	li	s2,0
 83c:	bf41                	j	7cc <vprintf+0x62>
 83e:	008a8493          	addi	s1,s5,8
 842:	4681                	li	a3,0
 844:	4629                	li	a2,10
 846:	000aa583          	lw	a1,0(s5)
 84a:	8552                	mv	a0,s4
 84c:	00000097          	auipc	ra,0x0
 850:	e82080e7          	jalr	-382(ra) # 6ce <printint>
 854:	8aa6                	mv	s5,s1
 856:	4901                	li	s2,0
 858:	bf95                	j	7cc <vprintf+0x62>
 85a:	008a8493          	addi	s1,s5,8
 85e:	4681                	li	a3,0
 860:	4641                	li	a2,16
 862:	000aa583          	lw	a1,0(s5)
 866:	8552                	mv	a0,s4
 868:	00000097          	auipc	ra,0x0
 86c:	e66080e7          	jalr	-410(ra) # 6ce <printint>
 870:	8aa6                	mv	s5,s1
 872:	4901                	li	s2,0
 874:	bfa1                	j	7cc <vprintf+0x62>
 876:	008a8793          	addi	a5,s5,8
 87a:	e43e                	sd	a5,8(sp)
 87c:	000ab903          	ld	s2,0(s5)
 880:	03000593          	li	a1,48
 884:	8552                	mv	a0,s4
 886:	00000097          	auipc	ra,0x0
 88a:	e2c080e7          	jalr	-468(ra) # 6b2 <putc>
 88e:	85e6                	mv	a1,s9
 890:	8552                	mv	a0,s4
 892:	00000097          	auipc	ra,0x0
 896:	e20080e7          	jalr	-480(ra) # 6b2 <putc>
 89a:	44c1                	li	s1,16
 89c:	03c95793          	srli	a5,s2,0x3c
 8a0:	97da                	add	a5,a5,s6
 8a2:	0007c583          	lbu	a1,0(a5)
 8a6:	8552                	mv	a0,s4
 8a8:	00000097          	auipc	ra,0x0
 8ac:	e0a080e7          	jalr	-502(ra) # 6b2 <putc>
 8b0:	0912                	slli	s2,s2,0x4
 8b2:	34fd                	addiw	s1,s1,-1
 8b4:	f4e5                	bnez	s1,89c <vprintf+0x132>
 8b6:	6aa2                	ld	s5,8(sp)
 8b8:	4901                	li	s2,0
 8ba:	bf09                	j	7cc <vprintf+0x62>
 8bc:	008a8493          	addi	s1,s5,8
 8c0:	000ab903          	ld	s2,0(s5)
 8c4:	02090163          	beqz	s2,8e6 <vprintf+0x17c>
 8c8:	00094583          	lbu	a1,0(s2)
 8cc:	c9a1                	beqz	a1,91c <vprintf+0x1b2>
 8ce:	8552                	mv	a0,s4
 8d0:	00000097          	auipc	ra,0x0
 8d4:	de2080e7          	jalr	-542(ra) # 6b2 <putc>
 8d8:	0905                	addi	s2,s2,1
 8da:	00094583          	lbu	a1,0(s2)
 8de:	f9e5                	bnez	a1,8ce <vprintf+0x164>
 8e0:	8aa6                	mv	s5,s1
 8e2:	4901                	li	s2,0
 8e4:	b5e5                	j	7cc <vprintf+0x62>
 8e6:	00000917          	auipc	s2,0x0
 8ea:	3ca90913          	addi	s2,s2,970 # cb0 <malloc+0x2a8>
 8ee:	02800593          	li	a1,40
 8f2:	bff1                	j	8ce <vprintf+0x164>
 8f4:	008a8493          	addi	s1,s5,8
 8f8:	000ac583          	lbu	a1,0(s5)
 8fc:	8552                	mv	a0,s4
 8fe:	00000097          	auipc	ra,0x0
 902:	db4080e7          	jalr	-588(ra) # 6b2 <putc>
 906:	8aa6                	mv	s5,s1
 908:	4901                	li	s2,0
 90a:	b5c9                	j	7cc <vprintf+0x62>
 90c:	85ce                	mv	a1,s3
 90e:	8552                	mv	a0,s4
 910:	00000097          	auipc	ra,0x0
 914:	da2080e7          	jalr	-606(ra) # 6b2 <putc>
 918:	4901                	li	s2,0
 91a:	bd4d                	j	7cc <vprintf+0x62>
 91c:	8aa6                	mv	s5,s1
 91e:	4901                	li	s2,0
 920:	b575                	j	7cc <vprintf+0x62>
 922:	70e6                	ld	ra,120(sp)
 924:	7446                	ld	s0,112(sp)
 926:	74a6                	ld	s1,104(sp)
 928:	7906                	ld	s2,96(sp)
 92a:	69e6                	ld	s3,88(sp)
 92c:	6a46                	ld	s4,80(sp)
 92e:	6aa6                	ld	s5,72(sp)
 930:	6b06                	ld	s6,64(sp)
 932:	7be2                	ld	s7,56(sp)
 934:	7c42                	ld	s8,48(sp)
 936:	7ca2                	ld	s9,40(sp)
 938:	7d02                	ld	s10,32(sp)
 93a:	6de2                	ld	s11,24(sp)
 93c:	6109                	addi	sp,sp,128
 93e:	8082                	ret

0000000000000940 <fprintf>:
 940:	715d                	addi	sp,sp,-80
 942:	ec06                	sd	ra,24(sp)
 944:	f032                	sd	a2,32(sp)
 946:	f436                	sd	a3,40(sp)
 948:	f83a                	sd	a4,48(sp)
 94a:	fc3e                	sd	a5,56(sp)
 94c:	e0c2                	sd	a6,64(sp)
 94e:	e4c6                	sd	a7,72(sp)
 950:	1010                	addi	a2,sp,32
 952:	e432                	sd	a2,8(sp)
 954:	00000097          	auipc	ra,0x0
 958:	e16080e7          	jalr	-490(ra) # 76a <vprintf>
 95c:	60e2                	ld	ra,24(sp)
 95e:	6161                	addi	sp,sp,80
 960:	8082                	ret

0000000000000962 <printf>:
 962:	711d                	addi	sp,sp,-96
 964:	ec06                	sd	ra,24(sp)
 966:	f42e                	sd	a1,40(sp)
 968:	f832                	sd	a2,48(sp)
 96a:	fc36                	sd	a3,56(sp)
 96c:	e0ba                	sd	a4,64(sp)
 96e:	e4be                	sd	a5,72(sp)
 970:	e8c2                	sd	a6,80(sp)
 972:	ecc6                	sd	a7,88(sp)
 974:	1030                	addi	a2,sp,40
 976:	e432                	sd	a2,8(sp)
 978:	85aa                	mv	a1,a0
 97a:	4505                	li	a0,1
 97c:	00000097          	auipc	ra,0x0
 980:	dee080e7          	jalr	-530(ra) # 76a <vprintf>
 984:	60e2                	ld	ra,24(sp)
 986:	6125                	addi	sp,sp,96
 988:	8082                	ret

000000000000098a <free>:
 98a:	ff050693          	addi	a3,a0,-16
 98e:	00000797          	auipc	a5,0x0
 992:	3427b783          	ld	a5,834(a5) # cd0 <freep>
 996:	a805                	j	9c6 <free+0x3c>
 998:	4618                	lw	a4,8(a2)
 99a:	9db9                	addw	a1,a1,a4
 99c:	feb52c23          	sw	a1,-8(a0)
 9a0:	6398                	ld	a4,0(a5)
 9a2:	6318                	ld	a4,0(a4)
 9a4:	fee53823          	sd	a4,-16(a0)
 9a8:	a091                	j	9ec <free+0x62>
 9aa:	ff852703          	lw	a4,-8(a0)
 9ae:	9e39                	addw	a2,a2,a4
 9b0:	c790                	sw	a2,8(a5)
 9b2:	ff053703          	ld	a4,-16(a0)
 9b6:	e398                	sd	a4,0(a5)
 9b8:	a099                	j	9fe <free+0x74>
 9ba:	6398                	ld	a4,0(a5)
 9bc:	00e7e463          	bltu	a5,a4,9c4 <free+0x3a>
 9c0:	00e6ea63          	bltu	a3,a4,9d4 <free+0x4a>
 9c4:	87ba                	mv	a5,a4
 9c6:	fed7fae3          	bgeu	a5,a3,9ba <free+0x30>
 9ca:	6398                	ld	a4,0(a5)
 9cc:	00e6e463          	bltu	a3,a4,9d4 <free+0x4a>
 9d0:	fee7eae3          	bltu	a5,a4,9c4 <free+0x3a>
 9d4:	ff852583          	lw	a1,-8(a0)
 9d8:	6390                	ld	a2,0(a5)
 9da:	02059713          	slli	a4,a1,0x20
 9de:	9301                	srli	a4,a4,0x20
 9e0:	0712                	slli	a4,a4,0x4
 9e2:	9736                	add	a4,a4,a3
 9e4:	fae60ae3          	beq	a2,a4,998 <free+0xe>
 9e8:	fec53823          	sd	a2,-16(a0)
 9ec:	4790                	lw	a2,8(a5)
 9ee:	02061713          	slli	a4,a2,0x20
 9f2:	9301                	srli	a4,a4,0x20
 9f4:	0712                	slli	a4,a4,0x4
 9f6:	973e                	add	a4,a4,a5
 9f8:	fae689e3          	beq	a3,a4,9aa <free+0x20>
 9fc:	e394                	sd	a3,0(a5)
 9fe:	00000717          	auipc	a4,0x0
 a02:	2cf73923          	sd	a5,722(a4) # cd0 <freep>
 a06:	8082                	ret

0000000000000a08 <malloc>:
 a08:	7139                	addi	sp,sp,-64
 a0a:	fc06                	sd	ra,56(sp)
 a0c:	f822                	sd	s0,48(sp)
 a0e:	f426                	sd	s1,40(sp)
 a10:	f04a                	sd	s2,32(sp)
 a12:	ec4e                	sd	s3,24(sp)
 a14:	e852                	sd	s4,16(sp)
 a16:	e456                	sd	s5,8(sp)
 a18:	02051413          	slli	s0,a0,0x20
 a1c:	9001                	srli	s0,s0,0x20
 a1e:	043d                	addi	s0,s0,15
 a20:	8011                	srli	s0,s0,0x4
 a22:	0014091b          	addiw	s2,s0,1
 a26:	0405                	addi	s0,s0,1
 a28:	00000517          	auipc	a0,0x0
 a2c:	2a853503          	ld	a0,680(a0) # cd0 <freep>
 a30:	c905                	beqz	a0,a60 <malloc+0x58>
 a32:	611c                	ld	a5,0(a0)
 a34:	4798                	lw	a4,8(a5)
 a36:	04877163          	bgeu	a4,s0,a78 <malloc+0x70>
 a3a:	89ca                	mv	s3,s2
 a3c:	0009071b          	sext.w	a4,s2
 a40:	6685                	lui	a3,0x1
 a42:	00d77363          	bgeu	a4,a3,a48 <malloc+0x40>
 a46:	6985                	lui	s3,0x1
 a48:	00098a1b          	sext.w	s4,s3
 a4c:	1982                	slli	s3,s3,0x20
 a4e:	0209d993          	srli	s3,s3,0x20
 a52:	0992                	slli	s3,s3,0x4
 a54:	00000497          	auipc	s1,0x0
 a58:	27c48493          	addi	s1,s1,636 # cd0 <freep>
 a5c:	5afd                	li	s5,-1
 a5e:	a0bd                	j	acc <malloc+0xc4>
 a60:	00000797          	auipc	a5,0x0
 a64:	27878793          	addi	a5,a5,632 # cd8 <base>
 a68:	00000717          	auipc	a4,0x0
 a6c:	26f73423          	sd	a5,616(a4) # cd0 <freep>
 a70:	e39c                	sd	a5,0(a5)
 a72:	0007a423          	sw	zero,8(a5)
 a76:	b7d1                	j	a3a <malloc+0x32>
 a78:	02e40a63          	beq	s0,a4,aac <malloc+0xa4>
 a7c:	4127073b          	subw	a4,a4,s2
 a80:	c798                	sw	a4,8(a5)
 a82:	1702                	slli	a4,a4,0x20
 a84:	9301                	srli	a4,a4,0x20
 a86:	0712                	slli	a4,a4,0x4
 a88:	97ba                	add	a5,a5,a4
 a8a:	0127a423          	sw	s2,8(a5)
 a8e:	00000717          	auipc	a4,0x0
 a92:	24a73123          	sd	a0,578(a4) # cd0 <freep>
 a96:	01078513          	addi	a0,a5,16
 a9a:	70e2                	ld	ra,56(sp)
 a9c:	7442                	ld	s0,48(sp)
 a9e:	74a2                	ld	s1,40(sp)
 aa0:	7902                	ld	s2,32(sp)
 aa2:	69e2                	ld	s3,24(sp)
 aa4:	6a42                	ld	s4,16(sp)
 aa6:	6aa2                	ld	s5,8(sp)
 aa8:	6121                	addi	sp,sp,64
 aaa:	8082                	ret
 aac:	6398                	ld	a4,0(a5)
 aae:	e118                	sd	a4,0(a0)
 ab0:	bff9                	j	a8e <malloc+0x86>
 ab2:	01452423          	sw	s4,8(a0)
 ab6:	0541                	addi	a0,a0,16
 ab8:	00000097          	auipc	ra,0x0
 abc:	ed2080e7          	jalr	-302(ra) # 98a <free>
 ac0:	6088                	ld	a0,0(s1)
 ac2:	dd61                	beqz	a0,a9a <malloc+0x92>
 ac4:	611c                	ld	a5,0(a0)
 ac6:	4798                	lw	a4,8(a5)
 ac8:	fa8778e3          	bgeu	a4,s0,a78 <malloc+0x70>
 acc:	6098                	ld	a4,0(s1)
 ace:	853e                	mv	a0,a5
 ad0:	fef71ae3          	bne	a4,a5,ac4 <malloc+0xbc>
 ad4:	854e                	mv	a0,s3
 ad6:	00000097          	auipc	ra,0x0
 ada:	8d8080e7          	jalr	-1832(ra) # 3ae <sbrk>
 ade:	fd551ae3          	bne	a0,s5,ab2 <malloc+0xaa>
 ae2:	4501                	li	a0,0
 ae4:	bf5d                	j	a9a <malloc+0x92>
