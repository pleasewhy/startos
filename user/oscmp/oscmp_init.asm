
_oscmp_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_success>:
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	842a                	mv	s0,a0
   a:	00001517          	auipc	a0,0x1
   e:	efe50513          	addi	a0,a0,-258 # f08 <malloc+0x1c6>
  12:	00001097          	auipc	ra,0x1
  16:	c8a080e7          	jalr	-886(ra) # c9c <printf>
  1a:	600c                	ld	a1,0(s0)
  1c:	cd99                	beqz	a1,3a <print_success+0x3a>
  1e:	0421                	addi	s0,s0,8
  20:	00001497          	auipc	s1,0x1
  24:	f0048493          	addi	s1,s1,-256 # f20 <malloc+0x1de>
  28:	8526                	mv	a0,s1
  2a:	00001097          	auipc	ra,0x1
  2e:	c72080e7          	jalr	-910(ra) # c9c <printf>
  32:	0421                	addi	s0,s0,8
  34:	ff843583          	ld	a1,-8(s0)
  38:	f9e5                	bnez	a1,28 <print_success+0x28>
  3a:	00001517          	auipc	a0,0x1
  3e:	eee50513          	addi	a0,a0,-274 # f28 <malloc+0x1e6>
  42:	00001097          	auipc	ra,0x1
  46:	c5a080e7          	jalr	-934(ra) # c9c <printf>
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
  64:	670080e7          	jalr	1648(ra) # 6d0 <fork>
  68:	ed09                	bnez	a0,82 <test+0x2e>
  6a:	4601                	li	a2,0
  6c:	85a2                	mv	a1,s0
  6e:	8526                	mv	a0,s1
  70:	00000097          	auipc	ra,0x0
  74:	788080e7          	jalr	1928(ra) # 7f8 <execve>
  78:	70a2                	ld	ra,40(sp)
  7a:	7402                	ld	s0,32(sp)
  7c:	64e2                	ld	s1,24(sp)
  7e:	6145                	addi	sp,sp,48
  80:	8082                	ret
  82:	0068                	addi	a0,sp,12
  84:	00000097          	auipc	ra,0x0
  88:	654080e7          	jalr	1620(ra) # 6d8 <wait>
  8c:	47b2                	lw	a5,12(sp)
  8e:	fe07c5e3          	bltz	a5,78 <test+0x24>
  92:	8522                	mv	a0,s0
  94:	00000097          	auipc	ra,0x0
  98:	f6c080e7          	jalr	-148(ra) # 0 <print_success>
  9c:	bff1                	j	78 <test+0x24>

000000000000009e <main>:
  9e:	c5010113          	addi	sp,sp,-944
  a2:	3a113423          	sd	ra,936(sp)
  a6:	3a813023          	sd	s0,928(sp)
  aa:	4589                	li	a1,2
  ac:	00001517          	auipc	a0,0x1
  b0:	e8c50513          	addi	a0,a0,-372 # f38 <malloc+0x1f6>
  b4:	00000097          	auipc	ra,0x0
  b8:	62c080e7          	jalr	1580(ra) # 6e0 <open>
  bc:	4501                	li	a0,0
  be:	00000097          	auipc	ra,0x0
  c2:	63a080e7          	jalr	1594(ra) # 6f8 <dup>
  c6:	4501                	li	a0,0
  c8:	00000097          	auipc	ra,0x0
  cc:	630080e7          	jalr	1584(ra) # 6f8 <dup>
  d0:	00001717          	auipc	a4,0x1
  d4:	e7070713          	addi	a4,a4,-400 # f40 <malloc+0x1fe>
  d8:	38e13423          	sd	a4,904(sp)
  dc:	00001797          	auipc	a5,0x1
  e0:	e6c78793          	addi	a5,a5,-404 # f48 <malloc+0x206>
  e4:	38f13823          	sd	a5,912(sp)
  e8:	38013c23          	sd	zero,920(sp)
  ec:	00001797          	auipc	a5,0x1
  f0:	d3478793          	addi	a5,a5,-716 # e20 <malloc+0xde>
  f4:	36f13423          	sd	a5,872(sp)
  f8:	00001697          	auipc	a3,0x1
  fc:	d3068693          	addi	a3,a3,-720 # e28 <malloc+0xe6>
 100:	36d13823          	sd	a3,880(sp)
 104:	00001797          	auipc	a5,0x1
 108:	d2c78793          	addi	a5,a5,-724 # e30 <malloc+0xee>
 10c:	36f13c23          	sd	a5,888(sp)
 110:	38013023          	sd	zero,896(sp)
 114:	00001617          	auipc	a2,0x1
 118:	d2460613          	addi	a2,a2,-732 # e38 <malloc+0xf6>
 11c:	34c13423          	sd	a2,840(sp)
 120:	34d13823          	sd	a3,848(sp)
 124:	34f13c23          	sd	a5,856(sp)
 128:	36013023          	sd	zero,864(sp)
 12c:	00001797          	auipc	a5,0x1
 130:	e3c78793          	addi	a5,a5,-452 # f68 <malloc+0x226>
 134:	32f13823          	sd	a5,816(sp)
 138:	00001797          	auipc	a5,0x1
 13c:	e4078793          	addi	a5,a5,-448 # f78 <malloc+0x236>
 140:	32f13c23          	sd	a5,824(sp)
 144:	34013023          	sd	zero,832(sp)
 148:	00001697          	auipc	a3,0x1
 14c:	e4068693          	addi	a3,a3,-448 # f88 <malloc+0x246>
 150:	32d13023          	sd	a3,800(sp)
 154:	32013423          	sd	zero,808(sp)
 158:	00001697          	auipc	a3,0x1
 15c:	e3868693          	addi	a3,a3,-456 # f90 <malloc+0x24e>
 160:	30d13823          	sd	a3,784(sp)
 164:	30013c23          	sd	zero,792(sp)
 168:	00001697          	auipc	a3,0x1
 16c:	e3068693          	addi	a3,a3,-464 # f98 <malloc+0x256>
 170:	30d13023          	sd	a3,768(sp)
 174:	30013423          	sd	zero,776(sp)
 178:	00001697          	auipc	a3,0x1
 17c:	e2868693          	addi	a3,a3,-472 # fa0 <malloc+0x25e>
 180:	2ed13423          	sd	a3,744(sp)
 184:	2ef13823          	sd	a5,752(sp)
 188:	2e013c23          	sd	zero,760(sp)
 18c:	00001797          	auipc	a5,0x1
 190:	f1c78793          	addi	a5,a5,-228 # 10a8 <malloc+0x366>
 194:	0007b803          	ld	a6,0(a5)
 198:	6788                	ld	a0,8(a5)
 19a:	6b8c                	ld	a1,16(a5)
 19c:	6f90                	ld	a2,24(a5)
 19e:	7394                	ld	a3,32(a5)
 1a0:	2d013023          	sd	a6,704(sp)
 1a4:	2ca13423          	sd	a0,712(sp)
 1a8:	2cb13823          	sd	a1,720(sp)
 1ac:	2cc13c23          	sd	a2,728(sp)
 1b0:	2ed13023          	sd	a3,736(sp)
 1b4:	00001697          	auipc	a3,0x1
 1b8:	df468693          	addi	a3,a3,-524 # fa8 <malloc+0x266>
 1bc:	2ad13823          	sd	a3,688(sp)
 1c0:	2a013c23          	sd	zero,696(sp)
 1c4:	00001697          	auipc	a3,0x1
 1c8:	dec68693          	addi	a3,a3,-532 # fb0 <malloc+0x26e>
 1cc:	2ad13023          	sd	a3,672(sp)
 1d0:	2a013423          	sd	zero,680(sp)
 1d4:	00001697          	auipc	a3,0x1
 1d8:	de468693          	addi	a3,a3,-540 # fb8 <malloc+0x276>
 1dc:	28d13423          	sd	a3,648(sp)
 1e0:	00001697          	auipc	a3,0x1
 1e4:	de068693          	addi	a3,a3,-544 # fc0 <malloc+0x27e>
 1e8:	28d13823          	sd	a3,656(sp)
 1ec:	28013c23          	sd	zero,664(sp)
 1f0:	00001617          	auipc	a2,0x1
 1f4:	dd860613          	addi	a2,a2,-552 # fc8 <malloc+0x286>
 1f8:	26c13c23          	sd	a2,632(sp)
 1fc:	28013023          	sd	zero,640(sp)
 200:	00001617          	auipc	a2,0x1
 204:	dd060613          	addi	a2,a2,-560 # fd0 <malloc+0x28e>
 208:	26c13423          	sd	a2,616(sp)
 20c:	26013823          	sd	zero,624(sp)
 210:	00001617          	auipc	a2,0x1
 214:	dc860613          	addi	a2,a2,-568 # fd8 <malloc+0x296>
 218:	24c13c23          	sd	a2,600(sp)
 21c:	26013023          	sd	zero,608(sp)
 220:	00001617          	auipc	a2,0x1
 224:	dc060613          	addi	a2,a2,-576 # fe0 <malloc+0x29e>
 228:	24c13423          	sd	a2,584(sp)
 22c:	24013823          	sd	zero,592(sp)
 230:	00001617          	auipc	a2,0x1
 234:	db860613          	addi	a2,a2,-584 # fe8 <malloc+0x2a6>
 238:	22c13c23          	sd	a2,568(sp)
 23c:	24013023          	sd	zero,576(sp)
 240:	00001617          	auipc	a2,0x1
 244:	db060613          	addi	a2,a2,-592 # ff0 <malloc+0x2ae>
 248:	22c13023          	sd	a2,544(sp)
 24c:	00001617          	auipc	a2,0x1
 250:	dac60613          	addi	a2,a2,-596 # ff8 <malloc+0x2b6>
 254:	22c13423          	sd	a2,552(sp)
 258:	22013823          	sd	zero,560(sp)
 25c:	20d13823          	sd	a3,528(sp)
 260:	20013c23          	sd	zero,536(sp)
 264:	00001697          	auipc	a3,0x1
 268:	d9c68693          	addi	a3,a3,-612 # 1000 <malloc+0x2be>
 26c:	20d13023          	sd	a3,512(sp)
 270:	20013423          	sd	zero,520(sp)
 274:	f7ba                	sd	a4,488(sp)
 276:	00001717          	auipc	a4,0x1
 27a:	d9270713          	addi	a4,a4,-622 # 1008 <malloc+0x2c6>
 27e:	fbba                	sd	a4,496(sp)
 280:	ff82                	sd	zero,504(sp)
 282:	00001717          	auipc	a4,0x1
 286:	da670713          	addi	a4,a4,-602 # 1028 <malloc+0x2e6>
 28a:	ebba                	sd	a4,464(sp)
 28c:	00001417          	auipc	s0,0x1
 290:	bdc40413          	addi	s0,s0,-1060 # e68 <malloc+0x126>
 294:	efa2                	sd	s0,472(sp)
 296:	f382                	sd	zero,480(sp)
 298:	00001717          	auipc	a4,0x1
 29c:	d9870713          	addi	a4,a4,-616 # 1030 <malloc+0x2ee>
 2a0:	ff3a                	sd	a4,440(sp)
 2a2:	e3a2                	sd	s0,448(sp)
 2a4:	e782                	sd	zero,456(sp)
 2a6:	7788                	ld	a0,40(a5)
 2a8:	7b8c                	ld	a1,48(a5)
 2aa:	7f90                	ld	a2,56(a5)
 2ac:	63b4                	ld	a3,64(a5)
 2ae:	67b8                	ld	a4,72(a5)
 2b0:	eb2a                	sd	a0,400(sp)
 2b2:	ef2e                	sd	a1,408(sp)
 2b4:	f332                	sd	a2,416(sp)
 2b6:	f736                	sd	a3,424(sp)
 2b8:	fb3a                	sd	a4,432(sp)
 2ba:	00001717          	auipc	a4,0x1
 2be:	d7e70713          	addi	a4,a4,-642 # 1038 <malloc+0x2f6>
 2c2:	feba                	sd	a4,376(sp)
 2c4:	e322                	sd	s0,384(sp)
 2c6:	e702                	sd	zero,392(sp)
 2c8:	00001717          	auipc	a4,0x1
 2cc:	d7870713          	addi	a4,a4,-648 # 1040 <malloc+0x2fe>
 2d0:	f2ba                	sd	a4,352(sp)
 2d2:	f6a2                	sd	s0,360(sp)
 2d4:	fa82                	sd	zero,368(sp)
 2d6:	00001717          	auipc	a4,0x1
 2da:	d7270713          	addi	a4,a4,-654 # 1048 <malloc+0x306>
 2de:	e6ba                	sd	a4,328(sp)
 2e0:	eaa2                	sd	s0,336(sp)
 2e2:	ee82                	sd	zero,344(sp)
 2e4:	00001717          	auipc	a4,0x1
 2e8:	b9470713          	addi	a4,a4,-1132 # e78 <malloc+0x136>
 2ec:	f63a                	sd	a4,296(sp)
 2ee:	00001717          	auipc	a4,0x1
 2f2:	b9270713          	addi	a4,a4,-1134 # e80 <malloc+0x13e>
 2f6:	fa3a                	sd	a4,304(sp)
 2f8:	fe22                	sd	s0,312(sp)
 2fa:	e282                	sd	zero,320(sp)
 2fc:	00001717          	auipc	a4,0x1
 300:	d5470713          	addi	a4,a4,-684 # 1050 <malloc+0x30e>
 304:	ea3a                	sd	a4,272(sp)
 306:	ee22                	sd	s0,280(sp)
 308:	f202                	sd	zero,288(sp)
 30a:	00001717          	auipc	a4,0x1
 30e:	d4e70713          	addi	a4,a4,-690 # 1058 <malloc+0x316>
 312:	fdba                	sd	a4,248(sp)
 314:	e222                	sd	s0,256(sp)
 316:	e602                	sd	zero,264(sp)
 318:	00001717          	auipc	a4,0x1
 31c:	d4870713          	addi	a4,a4,-696 # 1060 <malloc+0x31e>
 320:	f1ba                	sd	a4,224(sp)
 322:	f5a2                	sd	s0,232(sp)
 324:	f982                	sd	zero,240(sp)
 326:	00001717          	auipc	a4,0x1
 32a:	d4270713          	addi	a4,a4,-702 # 1068 <malloc+0x326>
 32e:	e5ba                	sd	a4,200(sp)
 330:	e9a2                	sd	s0,208(sp)
 332:	ed82                	sd	zero,216(sp)
 334:	6bac                	ld	a1,80(a5)
 336:	6fb0                	ld	a2,88(a5)
 338:	73b4                	ld	a3,96(a5)
 33a:	77b8                	ld	a4,104(a5)
 33c:	7bbc                	ld	a5,112(a5)
 33e:	f12e                	sd	a1,160(sp)
 340:	f532                	sd	a2,168(sp)
 342:	f936                	sd	a3,176(sp)
 344:	fd3a                	sd	a4,184(sp)
 346:	e1be                	sd	a5,192(sp)
 348:	00001797          	auipc	a5,0x1
 34c:	d2878793          	addi	a5,a5,-728 # 1070 <malloc+0x32e>
 350:	e53e                	sd	a5,136(sp)
 352:	e922                	sd	s0,144(sp)
 354:	ed02                	sd	zero,152(sp)
 356:	00001797          	auipc	a5,0x1
 35a:	d2278793          	addi	a5,a5,-734 # 1078 <malloc+0x336>
 35e:	f8be                	sd	a5,112(sp)
 360:	fca2                	sd	s0,120(sp)
 362:	e102                	sd	zero,128(sp)
 364:	00001797          	auipc	a5,0x1
 368:	d1c78793          	addi	a5,a5,-740 # 1080 <malloc+0x33e>
 36c:	ecbe                	sd	a5,88(sp)
 36e:	00001797          	auipc	a5,0x1
 372:	b3a78793          	addi	a5,a5,-1222 # ea8 <malloc+0x166>
 376:	f0be                	sd	a5,96(sp)
 378:	f482                	sd	zero,104(sp)
 37a:	00001797          	auipc	a5,0x1
 37e:	d0e78793          	addi	a5,a5,-754 # 1088 <malloc+0x346>
 382:	e0be                	sd	a5,64(sp)
 384:	00001797          	auipc	a5,0x1
 388:	b3478793          	addi	a5,a5,-1228 # eb8 <malloc+0x176>
 38c:	e4be                	sd	a5,72(sp)
 38e:	e882                	sd	zero,80(sp)
 390:	00001797          	auipc	a5,0x1
 394:	b3078793          	addi	a5,a5,-1232 # ec0 <malloc+0x17e>
 398:	f03e                	sd	a5,32(sp)
 39a:	00001797          	auipc	a5,0x1
 39e:	b2e78793          	addi	a5,a5,-1234 # ec8 <malloc+0x186>
 3a2:	f43e                	sd	a5,40(sp)
 3a4:	00001797          	auipc	a5,0x1
 3a8:	b2c78793          	addi	a5,a5,-1236 # ed0 <malloc+0x18e>
 3ac:	f83e                	sd	a5,48(sp)
 3ae:	fc02                	sd	zero,56(sp)
 3b0:	00001717          	auipc	a4,0x1
 3b4:	b4870713          	addi	a4,a4,-1208 # ef8 <malloc+0x1b6>
 3b8:	e03a                	sd	a4,0(sp)
 3ba:	00001717          	auipc	a4,0x1
 3be:	b4670713          	addi	a4,a4,-1210 # f00 <malloc+0x1be>
 3c2:	e43a                	sd	a4,8(sp)
 3c4:	e83e                	sd	a5,16(sp)
 3c6:	ec02                	sd	zero,24(sp)
 3c8:	072c                	addi	a1,sp,904
 3ca:	00001517          	auipc	a0,0x1
 3ce:	cc650513          	addi	a0,a0,-826 # 1090 <malloc+0x34e>
 3d2:	00000097          	auipc	ra,0x0
 3d6:	c82080e7          	jalr	-894(ra) # 54 <test>
 3da:	16ac                	addi	a1,sp,872
 3dc:	00001517          	auipc	a0,0x1
 3e0:	cb450513          	addi	a0,a0,-844 # 1090 <malloc+0x34e>
 3e4:	00000097          	auipc	ra,0x0
 3e8:	c70080e7          	jalr	-912(ra) # 54 <test>
 3ec:	06ac                	addi	a1,sp,840
 3ee:	00001517          	auipc	a0,0x1
 3f2:	ca250513          	addi	a0,a0,-862 # 1090 <malloc+0x34e>
 3f6:	00000097          	auipc	ra,0x0
 3fa:	c5e080e7          	jalr	-930(ra) # 54 <test>
 3fe:	1e0c                	addi	a1,sp,816
 400:	00001517          	auipc	a0,0x1
 404:	c9050513          	addi	a0,a0,-880 # 1090 <malloc+0x34e>
 408:	00000097          	auipc	ra,0x0
 40c:	c4c080e7          	jalr	-948(ra) # 54 <test>
 410:	160c                	addi	a1,sp,800
 412:	00001517          	auipc	a0,0x1
 416:	c7e50513          	addi	a0,a0,-898 # 1090 <malloc+0x34e>
 41a:	00000097          	auipc	ra,0x0
 41e:	c3a080e7          	jalr	-966(ra) # 54 <test>
 422:	0e0c                	addi	a1,sp,784
 424:	00001517          	auipc	a0,0x1
 428:	c6c50513          	addi	a0,a0,-916 # 1090 <malloc+0x34e>
 42c:	00000097          	auipc	ra,0x0
 430:	c28080e7          	jalr	-984(ra) # 54 <test>
 434:	060c                	addi	a1,sp,768
 436:	00001517          	auipc	a0,0x1
 43a:	c5a50513          	addi	a0,a0,-934 # 1090 <malloc+0x34e>
 43e:	00000097          	auipc	ra,0x0
 442:	c16080e7          	jalr	-1002(ra) # 54 <test>
 446:	15ac                	addi	a1,sp,744
 448:	00001517          	auipc	a0,0x1
 44c:	c4850513          	addi	a0,a0,-952 # 1090 <malloc+0x34e>
 450:	00000097          	auipc	ra,0x0
 454:	c04080e7          	jalr	-1020(ra) # 54 <test>
 458:	058c                	addi	a1,sp,704
 45a:	00001517          	auipc	a0,0x1
 45e:	c3650513          	addi	a0,a0,-970 # 1090 <malloc+0x34e>
 462:	00000097          	auipc	ra,0x0
 466:	bf2080e7          	jalr	-1038(ra) # 54 <test>
 46a:	1d0c                	addi	a1,sp,688
 46c:	00001517          	auipc	a0,0x1
 470:	c2450513          	addi	a0,a0,-988 # 1090 <malloc+0x34e>
 474:	00000097          	auipc	ra,0x0
 478:	be0080e7          	jalr	-1056(ra) # 54 <test>
 47c:	150c                	addi	a1,sp,672
 47e:	00001517          	auipc	a0,0x1
 482:	c1250513          	addi	a0,a0,-1006 # 1090 <malloc+0x34e>
 486:	00000097          	auipc	ra,0x0
 48a:	bce080e7          	jalr	-1074(ra) # 54 <test>
 48e:	052c                	addi	a1,sp,648
 490:	00001517          	auipc	a0,0x1
 494:	c0050513          	addi	a0,a0,-1024 # 1090 <malloc+0x34e>
 498:	00000097          	auipc	ra,0x0
 49c:	bbc080e7          	jalr	-1092(ra) # 54 <test>
 4a0:	1cac                	addi	a1,sp,632
 4a2:	00001517          	auipc	a0,0x1
 4a6:	bee50513          	addi	a0,a0,-1042 # 1090 <malloc+0x34e>
 4aa:	00000097          	auipc	ra,0x0
 4ae:	baa080e7          	jalr	-1110(ra) # 54 <test>
 4b2:	14ac                	addi	a1,sp,616
 4b4:	00001517          	auipc	a0,0x1
 4b8:	bdc50513          	addi	a0,a0,-1060 # 1090 <malloc+0x34e>
 4bc:	00000097          	auipc	ra,0x0
 4c0:	b98080e7          	jalr	-1128(ra) # 54 <test>
 4c4:	0cac                	addi	a1,sp,600
 4c6:	00001517          	auipc	a0,0x1
 4ca:	bca50513          	addi	a0,a0,-1078 # 1090 <malloc+0x34e>
 4ce:	00000097          	auipc	ra,0x0
 4d2:	b86080e7          	jalr	-1146(ra) # 54 <test>
 4d6:	04ac                	addi	a1,sp,584
 4d8:	00001517          	auipc	a0,0x1
 4dc:	bb850513          	addi	a0,a0,-1096 # 1090 <malloc+0x34e>
 4e0:	00000097          	auipc	ra,0x0
 4e4:	b74080e7          	jalr	-1164(ra) # 54 <test>
 4e8:	140c                	addi	a1,sp,544
 4ea:	00001517          	auipc	a0,0x1
 4ee:	ba650513          	addi	a0,a0,-1114 # 1090 <malloc+0x34e>
 4f2:	00000097          	auipc	ra,0x0
 4f6:	b62080e7          	jalr	-1182(ra) # 54 <test>
 4fa:	0c0c                	addi	a1,sp,528
 4fc:	00001517          	auipc	a0,0x1
 500:	b9450513          	addi	a0,a0,-1132 # 1090 <malloc+0x34e>
 504:	00000097          	auipc	ra,0x0
 508:	b50080e7          	jalr	-1200(ra) # 54 <test>
 50c:	040c                	addi	a1,sp,512
 50e:	00001517          	auipc	a0,0x1
 512:	b8250513          	addi	a0,a0,-1150 # 1090 <malloc+0x34e>
 516:	00000097          	auipc	ra,0x0
 51a:	b3e080e7          	jalr	-1218(ra) # 54 <test>
 51e:	1c2c                	addi	a1,sp,568
 520:	00001517          	auipc	a0,0x1
 524:	b7050513          	addi	a0,a0,-1168 # 1090 <malloc+0x34e>
 528:	00000097          	auipc	ra,0x0
 52c:	b2c080e7          	jalr	-1236(ra) # 54 <test>
 530:	13ac                	addi	a1,sp,488
 532:	00001517          	auipc	a0,0x1
 536:	b5e50513          	addi	a0,a0,-1186 # 1090 <malloc+0x34e>
 53a:	00000097          	auipc	ra,0x0
 53e:	b1a080e7          	jalr	-1254(ra) # 54 <test>
 542:	0b8c                	addi	a1,sp,464
 544:	00001517          	auipc	a0,0x1
 548:	b4c50513          	addi	a0,a0,-1204 # 1090 <malloc+0x34e>
 54c:	00000097          	auipc	ra,0x0
 550:	b08080e7          	jalr	-1272(ra) # 54 <test>
 554:	4589                	li	a1,2
 556:	8522                	mv	a0,s0
 558:	00000097          	auipc	ra,0x0
 55c:	188080e7          	jalr	392(ra) # 6e0 <open>
 560:	842a                	mv	s0,a0
 562:	14054d63          	bltz	a0,6bc <main+0x61e>
 566:	4635                	li	a2,13
 568:	00001597          	auipc	a1,0x1
 56c:	b3058593          	addi	a1,a1,-1232 # 1098 <malloc+0x356>
 570:	8522                	mv	a0,s0
 572:	00000097          	auipc	ra,0x0
 576:	204080e7          	jalr	516(ra) # 776 <write>
 57a:	14054663          	bltz	a0,6c6 <main+0x628>
 57e:	8522                	mv	a0,s0
 580:	00000097          	auipc	ra,0x0
 584:	1ce080e7          	jalr	462(ra) # 74e <close>
 588:	1b2c                	addi	a1,sp,440
 58a:	00001517          	auipc	a0,0x1
 58e:	b0650513          	addi	a0,a0,-1274 # 1090 <malloc+0x34e>
 592:	00000097          	auipc	ra,0x0
 596:	ac2080e7          	jalr	-1342(ra) # 54 <test>
 59a:	0b0c                	addi	a1,sp,400
 59c:	00001517          	auipc	a0,0x1
 5a0:	af450513          	addi	a0,a0,-1292 # 1090 <malloc+0x34e>
 5a4:	00000097          	auipc	ra,0x0
 5a8:	ab0080e7          	jalr	-1360(ra) # 54 <test>
 5ac:	1aac                	addi	a1,sp,376
 5ae:	00001517          	auipc	a0,0x1
 5b2:	ae250513          	addi	a0,a0,-1310 # 1090 <malloc+0x34e>
 5b6:	00000097          	auipc	ra,0x0
 5ba:	a9e080e7          	jalr	-1378(ra) # 54 <test>
 5be:	128c                	addi	a1,sp,352
 5c0:	00001517          	auipc	a0,0x1
 5c4:	ad050513          	addi	a0,a0,-1328 # 1090 <malloc+0x34e>
 5c8:	00000097          	auipc	ra,0x0
 5cc:	a8c080e7          	jalr	-1396(ra) # 54 <test>
 5d0:	02ac                	addi	a1,sp,328
 5d2:	00001517          	auipc	a0,0x1
 5d6:	abe50513          	addi	a0,a0,-1346 # 1090 <malloc+0x34e>
 5da:	00000097          	auipc	ra,0x0
 5de:	a7a080e7          	jalr	-1414(ra) # 54 <test>
 5e2:	122c                	addi	a1,sp,296
 5e4:	00001517          	auipc	a0,0x1
 5e8:	aac50513          	addi	a0,a0,-1364 # 1090 <malloc+0x34e>
 5ec:	00000097          	auipc	ra,0x0
 5f0:	a68080e7          	jalr	-1432(ra) # 54 <test>
 5f4:	0a0c                	addi	a1,sp,272
 5f6:	00001517          	auipc	a0,0x1
 5fa:	a9a50513          	addi	a0,a0,-1382 # 1090 <malloc+0x34e>
 5fe:	00000097          	auipc	ra,0x0
 602:	a56080e7          	jalr	-1450(ra) # 54 <test>
 606:	19ac                	addi	a1,sp,248
 608:	00001517          	auipc	a0,0x1
 60c:	a8850513          	addi	a0,a0,-1400 # 1090 <malloc+0x34e>
 610:	00000097          	auipc	ra,0x0
 614:	a44080e7          	jalr	-1468(ra) # 54 <test>
 618:	118c                	addi	a1,sp,224
 61a:	00001517          	auipc	a0,0x1
 61e:	a7650513          	addi	a0,a0,-1418 # 1090 <malloc+0x34e>
 622:	00000097          	auipc	ra,0x0
 626:	a32080e7          	jalr	-1486(ra) # 54 <test>
 62a:	01ac                	addi	a1,sp,200
 62c:	00001517          	auipc	a0,0x1
 630:	a6450513          	addi	a0,a0,-1436 # 1090 <malloc+0x34e>
 634:	00000097          	auipc	ra,0x0
 638:	a20080e7          	jalr	-1504(ra) # 54 <test>
 63c:	110c                	addi	a1,sp,160
 63e:	00001517          	auipc	a0,0x1
 642:	a5250513          	addi	a0,a0,-1454 # 1090 <malloc+0x34e>
 646:	00000097          	auipc	ra,0x0
 64a:	a0e080e7          	jalr	-1522(ra) # 54 <test>
 64e:	012c                	addi	a1,sp,136
 650:	00001517          	auipc	a0,0x1
 654:	a4050513          	addi	a0,a0,-1472 # 1090 <malloc+0x34e>
 658:	00000097          	auipc	ra,0x0
 65c:	9fc080e7          	jalr	-1540(ra) # 54 <test>
 660:	188c                	addi	a1,sp,112
 662:	00001517          	auipc	a0,0x1
 666:	a2e50513          	addi	a0,a0,-1490 # 1090 <malloc+0x34e>
 66a:	00000097          	auipc	ra,0x0
 66e:	9ea080e7          	jalr	-1558(ra) # 54 <test>
 672:	08ac                	addi	a1,sp,88
 674:	00001517          	auipc	a0,0x1
 678:	a1c50513          	addi	a0,a0,-1508 # 1090 <malloc+0x34e>
 67c:	00000097          	auipc	ra,0x0
 680:	9d8080e7          	jalr	-1576(ra) # 54 <test>
 684:	008c                	addi	a1,sp,64
 686:	00001517          	auipc	a0,0x1
 68a:	a0a50513          	addi	a0,a0,-1526 # 1090 <malloc+0x34e>
 68e:	00000097          	auipc	ra,0x0
 692:	9c6080e7          	jalr	-1594(ra) # 54 <test>
 696:	100c                	addi	a1,sp,32
 698:	00001517          	auipc	a0,0x1
 69c:	9f850513          	addi	a0,a0,-1544 # 1090 <malloc+0x34e>
 6a0:	00000097          	auipc	ra,0x0
 6a4:	9b4080e7          	jalr	-1612(ra) # 54 <test>
 6a8:	858a                	mv	a1,sp
 6aa:	00001517          	auipc	a0,0x1
 6ae:	9e650513          	addi	a0,a0,-1562 # 1090 <malloc+0x34e>
 6b2:	00000097          	auipc	ra,0x0
 6b6:	9a2080e7          	jalr	-1630(ra) # 54 <test>
 6ba:	a001                	j	6ba <main+0x61c>
 6bc:	00000097          	auipc	ra,0x0
 6c0:	15a080e7          	jalr	346(ra) # 816 <kernel_panic>
 6c4:	b54d                	j	566 <main+0x4c8>
 6c6:	00000097          	auipc	ra,0x0
 6ca:	150080e7          	jalr	336(ra) # 816 <kernel_panic>
 6ce:	bd45                	j	57e <main+0x4e0>

00000000000006d0 <fork>:
 6d0:	4885                	li	a7,1
 6d2:	00000073          	ecall
 6d6:	8082                	ret

00000000000006d8 <wait>:
 6d8:	488d                	li	a7,3
 6da:	00000073          	ecall
 6de:	8082                	ret

00000000000006e0 <open>:
 6e0:	4889                	li	a7,2
 6e2:	00000073          	ecall
 6e6:	8082                	ret

00000000000006e8 <sbrk>:
 6e8:	4891                	li	a7,4
 6ea:	00000073          	ecall
 6ee:	8082                	ret

00000000000006f0 <getcwd>:
 6f0:	48c5                	li	a7,17
 6f2:	00000073          	ecall
 6f6:	8082                	ret

00000000000006f8 <dup>:
 6f8:	48dd                	li	a7,23
 6fa:	00000073          	ecall
 6fe:	8082                	ret

0000000000000700 <dup3>:
 700:	48e1                	li	a7,24
 702:	00000073          	ecall
 706:	8082                	ret

0000000000000708 <mkdirat>:
 708:	02200893          	li	a7,34
 70c:	00000073          	ecall
 710:	8082                	ret

0000000000000712 <unlinkat>:
 712:	02300893          	li	a7,35
 716:	00000073          	ecall
 71a:	8082                	ret

000000000000071c <linkat>:
 71c:	02500893          	li	a7,37
 720:	00000073          	ecall
 724:	8082                	ret

0000000000000726 <umount2>:
 726:	02700893          	li	a7,39
 72a:	00000073          	ecall
 72e:	8082                	ret

0000000000000730 <mount>:
 730:	02800893          	li	a7,40
 734:	00000073          	ecall
 738:	8082                	ret

000000000000073a <chdir>:
 73a:	03100893          	li	a7,49
 73e:	00000073          	ecall
 742:	8082                	ret

0000000000000744 <openat>:
 744:	03800893          	li	a7,56
 748:	00000073          	ecall
 74c:	8082                	ret

000000000000074e <close>:
 74e:	03900893          	li	a7,57
 752:	00000073          	ecall
 756:	8082                	ret

0000000000000758 <pipe2>:
 758:	03b00893          	li	a7,59
 75c:	00000073          	ecall
 760:	8082                	ret

0000000000000762 <getdents64>:
 762:	03d00893          	li	a7,61
 766:	00000073          	ecall
 76a:	8082                	ret

000000000000076c <read>:
 76c:	03f00893          	li	a7,63
 770:	00000073          	ecall
 774:	8082                	ret

0000000000000776 <write>:
 776:	04000893          	li	a7,64
 77a:	00000073          	ecall
 77e:	8082                	ret

0000000000000780 <fstat>:
 780:	05000893          	li	a7,80
 784:	00000073          	ecall
 788:	8082                	ret

000000000000078a <exit>:
 78a:	05d00893          	li	a7,93
 78e:	00000073          	ecall
 792:	8082                	ret

0000000000000794 <nanosleep>:
 794:	06500893          	li	a7,101
 798:	00000073          	ecall
 79c:	8082                	ret

000000000000079e <sched_yield>:
 79e:	07c00893          	li	a7,124
 7a2:	00000073          	ecall
 7a6:	8082                	ret

00000000000007a8 <times>:
 7a8:	09900893          	li	a7,153
 7ac:	00000073          	ecall
 7b0:	8082                	ret

00000000000007b2 <uname>:
 7b2:	0a000893          	li	a7,160
 7b6:	00000073          	ecall
 7ba:	8082                	ret

00000000000007bc <gettimeofday>:
 7bc:	0a900893          	li	a7,169
 7c0:	00000073          	ecall
 7c4:	8082                	ret

00000000000007c6 <brk>:
 7c6:	0d600893          	li	a7,214
 7ca:	00000073          	ecall
 7ce:	8082                	ret

00000000000007d0 <munmap>:
 7d0:	0d700893          	li	a7,215
 7d4:	00000073          	ecall
 7d8:	8082                	ret

00000000000007da <getpid>:
 7da:	0ac00893          	li	a7,172
 7de:	00000073          	ecall
 7e2:	8082                	ret

00000000000007e4 <getppid>:
 7e4:	0ad00893          	li	a7,173
 7e8:	00000073          	ecall
 7ec:	8082                	ret

00000000000007ee <clone>:
 7ee:	0dc00893          	li	a7,220
 7f2:	00000073          	ecall
 7f6:	8082                	ret

00000000000007f8 <execve>:
 7f8:	0dd00893          	li	a7,221
 7fc:	00000073          	ecall
 800:	8082                	ret

0000000000000802 <mmap>:
 802:	0de00893          	li	a7,222
 806:	00000073          	ecall
 80a:	8082                	ret

000000000000080c <wait4>:
 80c:	10400893          	li	a7,260
 810:	00000073          	ecall
 814:	8082                	ret

0000000000000816 <kernel_panic>:
 816:	18f00893          	li	a7,399
 81a:	00000073          	ecall
 81e:	8082                	ret

0000000000000820 <strcpy>:
 820:	87aa                	mv	a5,a0
 822:	0585                	addi	a1,a1,1
 824:	0785                	addi	a5,a5,1
 826:	fff5c703          	lbu	a4,-1(a1)
 82a:	fee78fa3          	sb	a4,-1(a5)
 82e:	fb75                	bnez	a4,822 <strcpy+0x2>
 830:	8082                	ret

0000000000000832 <strcmp>:
 832:	00054783          	lbu	a5,0(a0)
 836:	cb91                	beqz	a5,84a <strcmp+0x18>
 838:	0005c703          	lbu	a4,0(a1)
 83c:	00f71763          	bne	a4,a5,84a <strcmp+0x18>
 840:	0505                	addi	a0,a0,1
 842:	0585                	addi	a1,a1,1
 844:	00054783          	lbu	a5,0(a0)
 848:	fbe5                	bnez	a5,838 <strcmp+0x6>
 84a:	0005c503          	lbu	a0,0(a1)
 84e:	40a7853b          	subw	a0,a5,a0
 852:	8082                	ret

0000000000000854 <strlen>:
 854:	00054783          	lbu	a5,0(a0)
 858:	cf81                	beqz	a5,870 <strlen+0x1c>
 85a:	0505                	addi	a0,a0,1
 85c:	87aa                	mv	a5,a0
 85e:	4685                	li	a3,1
 860:	9e89                	subw	a3,a3,a0
 862:	00f6853b          	addw	a0,a3,a5
 866:	0785                	addi	a5,a5,1
 868:	fff7c703          	lbu	a4,-1(a5)
 86c:	fb7d                	bnez	a4,862 <strlen+0xe>
 86e:	8082                	ret
 870:	4501                	li	a0,0
 872:	8082                	ret

0000000000000874 <memset>:
 874:	ce09                	beqz	a2,88e <memset+0x1a>
 876:	87aa                	mv	a5,a0
 878:	fff6071b          	addiw	a4,a2,-1
 87c:	1702                	slli	a4,a4,0x20
 87e:	9301                	srli	a4,a4,0x20
 880:	0705                	addi	a4,a4,1
 882:	972a                	add	a4,a4,a0
 884:	00b78023          	sb	a1,0(a5)
 888:	0785                	addi	a5,a5,1
 88a:	fee79de3          	bne	a5,a4,884 <memset+0x10>
 88e:	8082                	ret

0000000000000890 <strchr>:
 890:	00054783          	lbu	a5,0(a0)
 894:	cb89                	beqz	a5,8a6 <strchr+0x16>
 896:	00f58963          	beq	a1,a5,8a8 <strchr+0x18>
 89a:	0505                	addi	a0,a0,1
 89c:	00054783          	lbu	a5,0(a0)
 8a0:	fbfd                	bnez	a5,896 <strchr+0x6>
 8a2:	4501                	li	a0,0
 8a4:	8082                	ret
 8a6:	4501                	li	a0,0
 8a8:	8082                	ret

00000000000008aa <gets>:
 8aa:	715d                	addi	sp,sp,-80
 8ac:	e486                	sd	ra,72(sp)
 8ae:	e0a2                	sd	s0,64(sp)
 8b0:	fc26                	sd	s1,56(sp)
 8b2:	f84a                	sd	s2,48(sp)
 8b4:	f44e                	sd	s3,40(sp)
 8b6:	f052                	sd	s4,32(sp)
 8b8:	ec56                	sd	s5,24(sp)
 8ba:	e85a                	sd	s6,16(sp)
 8bc:	8b2a                	mv	s6,a0
 8be:	89ae                	mv	s3,a1
 8c0:	84aa                	mv	s1,a0
 8c2:	4401                	li	s0,0
 8c4:	4a29                	li	s4,10
 8c6:	4ab5                	li	s5,13
 8c8:	8922                	mv	s2,s0
 8ca:	2405                	addiw	s0,s0,1
 8cc:	03345863          	bge	s0,s3,8fc <gets+0x52>
 8d0:	4605                	li	a2,1
 8d2:	00f10593          	addi	a1,sp,15
 8d6:	4501                	li	a0,0
 8d8:	00000097          	auipc	ra,0x0
 8dc:	e94080e7          	jalr	-364(ra) # 76c <read>
 8e0:	00a05e63          	blez	a0,8fc <gets+0x52>
 8e4:	00f14783          	lbu	a5,15(sp)
 8e8:	00f48023          	sb	a5,0(s1)
 8ec:	01478763          	beq	a5,s4,8fa <gets+0x50>
 8f0:	0485                	addi	s1,s1,1
 8f2:	fd579be3          	bne	a5,s5,8c8 <gets+0x1e>
 8f6:	8922                	mv	s2,s0
 8f8:	a011                	j	8fc <gets+0x52>
 8fa:	8922                	mv	s2,s0
 8fc:	995a                	add	s2,s2,s6
 8fe:	00090023          	sb	zero,0(s2)
 902:	855a                	mv	a0,s6
 904:	60a6                	ld	ra,72(sp)
 906:	6406                	ld	s0,64(sp)
 908:	74e2                	ld	s1,56(sp)
 90a:	7942                	ld	s2,48(sp)
 90c:	79a2                	ld	s3,40(sp)
 90e:	7a02                	ld	s4,32(sp)
 910:	6ae2                	ld	s5,24(sp)
 912:	6b42                	ld	s6,16(sp)
 914:	6161                	addi	sp,sp,80
 916:	8082                	ret

0000000000000918 <atoi>:
 918:	86aa                	mv	a3,a0
 91a:	00054603          	lbu	a2,0(a0)
 91e:	fd06079b          	addiw	a5,a2,-48
 922:	0ff7f793          	andi	a5,a5,255
 926:	4725                	li	a4,9
 928:	02f76663          	bltu	a4,a5,954 <atoi+0x3c>
 92c:	4501                	li	a0,0
 92e:	45a5                	li	a1,9
 930:	0685                	addi	a3,a3,1
 932:	0025179b          	slliw	a5,a0,0x2
 936:	9fa9                	addw	a5,a5,a0
 938:	0017979b          	slliw	a5,a5,0x1
 93c:	9fb1                	addw	a5,a5,a2
 93e:	fd07851b          	addiw	a0,a5,-48
 942:	0006c603          	lbu	a2,0(a3)
 946:	fd06071b          	addiw	a4,a2,-48
 94a:	0ff77713          	andi	a4,a4,255
 94e:	fee5f1e3          	bgeu	a1,a4,930 <atoi+0x18>
 952:	8082                	ret
 954:	4501                	li	a0,0
 956:	8082                	ret

0000000000000958 <memmove>:
 958:	02b57463          	bgeu	a0,a1,980 <memmove+0x28>
 95c:	04c05663          	blez	a2,9a8 <memmove+0x50>
 960:	fff6079b          	addiw	a5,a2,-1
 964:	1782                	slli	a5,a5,0x20
 966:	9381                	srli	a5,a5,0x20
 968:	0785                	addi	a5,a5,1
 96a:	97aa                	add	a5,a5,a0
 96c:	872a                	mv	a4,a0
 96e:	0585                	addi	a1,a1,1
 970:	0705                	addi	a4,a4,1
 972:	fff5c683          	lbu	a3,-1(a1)
 976:	fed70fa3          	sb	a3,-1(a4)
 97a:	fee79ae3          	bne	a5,a4,96e <memmove+0x16>
 97e:	8082                	ret
 980:	00c50733          	add	a4,a0,a2
 984:	95b2                	add	a1,a1,a2
 986:	02c05163          	blez	a2,9a8 <memmove+0x50>
 98a:	fff6079b          	addiw	a5,a2,-1
 98e:	1782                	slli	a5,a5,0x20
 990:	9381                	srli	a5,a5,0x20
 992:	fff7c793          	not	a5,a5
 996:	97ba                	add	a5,a5,a4
 998:	15fd                	addi	a1,a1,-1
 99a:	177d                	addi	a4,a4,-1
 99c:	0005c683          	lbu	a3,0(a1)
 9a0:	00d70023          	sb	a3,0(a4)
 9a4:	fee79ae3          	bne	a5,a4,998 <memmove+0x40>
 9a8:	8082                	ret

00000000000009aa <memcmp>:
 9aa:	fff6069b          	addiw	a3,a2,-1
 9ae:	c605                	beqz	a2,9d6 <memcmp+0x2c>
 9b0:	1682                	slli	a3,a3,0x20
 9b2:	9281                	srli	a3,a3,0x20
 9b4:	0685                	addi	a3,a3,1
 9b6:	96aa                	add	a3,a3,a0
 9b8:	00054783          	lbu	a5,0(a0)
 9bc:	0005c703          	lbu	a4,0(a1)
 9c0:	00e79863          	bne	a5,a4,9d0 <memcmp+0x26>
 9c4:	0505                	addi	a0,a0,1
 9c6:	0585                	addi	a1,a1,1
 9c8:	fed518e3          	bne	a0,a3,9b8 <memcmp+0xe>
 9cc:	4501                	li	a0,0
 9ce:	8082                	ret
 9d0:	40e7853b          	subw	a0,a5,a4
 9d4:	8082                	ret
 9d6:	4501                	li	a0,0
 9d8:	8082                	ret

00000000000009da <memcpy>:
 9da:	1141                	addi	sp,sp,-16
 9dc:	e406                	sd	ra,8(sp)
 9de:	00000097          	auipc	ra,0x0
 9e2:	f7a080e7          	jalr	-134(ra) # 958 <memmove>
 9e6:	60a2                	ld	ra,8(sp)
 9e8:	0141                	addi	sp,sp,16
 9ea:	8082                	ret

00000000000009ec <putc>:
 9ec:	1101                	addi	sp,sp,-32
 9ee:	ec06                	sd	ra,24(sp)
 9f0:	00b107a3          	sb	a1,15(sp)
 9f4:	4605                	li	a2,1
 9f6:	00f10593          	addi	a1,sp,15
 9fa:	00000097          	auipc	ra,0x0
 9fe:	d7c080e7          	jalr	-644(ra) # 776 <write>
 a02:	60e2                	ld	ra,24(sp)
 a04:	6105                	addi	sp,sp,32
 a06:	8082                	ret

0000000000000a08 <printint>:
 a08:	7179                	addi	sp,sp,-48
 a0a:	f406                	sd	ra,40(sp)
 a0c:	f022                	sd	s0,32(sp)
 a0e:	ec26                	sd	s1,24(sp)
 a10:	e84a                	sd	s2,16(sp)
 a12:	84aa                	mv	s1,a0
 a14:	c299                	beqz	a3,a1a <printint+0x12>
 a16:	0805c363          	bltz	a1,a9c <printint+0x94>
 a1a:	2581                	sext.w	a1,a1
 a1c:	4881                	li	a7,0
 a1e:	868a                	mv	a3,sp
 a20:	4701                	li	a4,0
 a22:	2601                	sext.w	a2,a2
 a24:	00000517          	auipc	a0,0x0
 a28:	70450513          	addi	a0,a0,1796 # 1128 <digits>
 a2c:	883a                	mv	a6,a4
 a2e:	2705                	addiw	a4,a4,1
 a30:	02c5f7bb          	remuw	a5,a1,a2
 a34:	1782                	slli	a5,a5,0x20
 a36:	9381                	srli	a5,a5,0x20
 a38:	97aa                	add	a5,a5,a0
 a3a:	0007c783          	lbu	a5,0(a5)
 a3e:	00f68023          	sb	a5,0(a3)
 a42:	0005879b          	sext.w	a5,a1
 a46:	02c5d5bb          	divuw	a1,a1,a2
 a4a:	0685                	addi	a3,a3,1
 a4c:	fec7f0e3          	bgeu	a5,a2,a2c <printint+0x24>
 a50:	00088a63          	beqz	a7,a64 <printint+0x5c>
 a54:	081c                	addi	a5,sp,16
 a56:	973e                	add	a4,a4,a5
 a58:	02d00793          	li	a5,45
 a5c:	fef70823          	sb	a5,-16(a4)
 a60:	0028071b          	addiw	a4,a6,2
 a64:	02e05663          	blez	a4,a90 <printint+0x88>
 a68:	00e10433          	add	s0,sp,a4
 a6c:	fff10913          	addi	s2,sp,-1
 a70:	993a                	add	s2,s2,a4
 a72:	377d                	addiw	a4,a4,-1
 a74:	1702                	slli	a4,a4,0x20
 a76:	9301                	srli	a4,a4,0x20
 a78:	40e90933          	sub	s2,s2,a4
 a7c:	fff44583          	lbu	a1,-1(s0)
 a80:	8526                	mv	a0,s1
 a82:	00000097          	auipc	ra,0x0
 a86:	f6a080e7          	jalr	-150(ra) # 9ec <putc>
 a8a:	147d                	addi	s0,s0,-1
 a8c:	ff2418e3          	bne	s0,s2,a7c <printint+0x74>
 a90:	70a2                	ld	ra,40(sp)
 a92:	7402                	ld	s0,32(sp)
 a94:	64e2                	ld	s1,24(sp)
 a96:	6942                	ld	s2,16(sp)
 a98:	6145                	addi	sp,sp,48
 a9a:	8082                	ret
 a9c:	40b005bb          	negw	a1,a1
 aa0:	4885                	li	a7,1
 aa2:	bfb5                	j	a1e <printint+0x16>

0000000000000aa4 <vprintf>:
 aa4:	7119                	addi	sp,sp,-128
 aa6:	fc86                	sd	ra,120(sp)
 aa8:	f8a2                	sd	s0,112(sp)
 aaa:	f4a6                	sd	s1,104(sp)
 aac:	f0ca                	sd	s2,96(sp)
 aae:	ecce                	sd	s3,88(sp)
 ab0:	e8d2                	sd	s4,80(sp)
 ab2:	e4d6                	sd	s5,72(sp)
 ab4:	e0da                	sd	s6,64(sp)
 ab6:	fc5e                	sd	s7,56(sp)
 ab8:	f862                	sd	s8,48(sp)
 aba:	f466                	sd	s9,40(sp)
 abc:	f06a                	sd	s10,32(sp)
 abe:	ec6e                	sd	s11,24(sp)
 ac0:	0005c483          	lbu	s1,0(a1)
 ac4:	18048c63          	beqz	s1,c5c <vprintf+0x1b8>
 ac8:	8a2a                	mv	s4,a0
 aca:	8ab2                	mv	s5,a2
 acc:	00158413          	addi	s0,a1,1
 ad0:	4901                	li	s2,0
 ad2:	02500993          	li	s3,37
 ad6:	06400b93          	li	s7,100
 ada:	06c00c13          	li	s8,108
 ade:	07800c93          	li	s9,120
 ae2:	07000d13          	li	s10,112
 ae6:	07300d93          	li	s11,115
 aea:	00000b17          	auipc	s6,0x0
 aee:	63eb0b13          	addi	s6,s6,1598 # 1128 <digits>
 af2:	a839                	j	b10 <vprintf+0x6c>
 af4:	85a6                	mv	a1,s1
 af6:	8552                	mv	a0,s4
 af8:	00000097          	auipc	ra,0x0
 afc:	ef4080e7          	jalr	-268(ra) # 9ec <putc>
 b00:	a019                	j	b06 <vprintf+0x62>
 b02:	01390f63          	beq	s2,s3,b20 <vprintf+0x7c>
 b06:	0405                	addi	s0,s0,1
 b08:	fff44483          	lbu	s1,-1(s0)
 b0c:	14048863          	beqz	s1,c5c <vprintf+0x1b8>
 b10:	0004879b          	sext.w	a5,s1
 b14:	fe0917e3          	bnez	s2,b02 <vprintf+0x5e>
 b18:	fd379ee3          	bne	a5,s3,af4 <vprintf+0x50>
 b1c:	893e                	mv	s2,a5
 b1e:	b7e5                	j	b06 <vprintf+0x62>
 b20:	03778e63          	beq	a5,s7,b5c <vprintf+0xb8>
 b24:	05878a63          	beq	a5,s8,b78 <vprintf+0xd4>
 b28:	07978663          	beq	a5,s9,b94 <vprintf+0xf0>
 b2c:	09a78263          	beq	a5,s10,bb0 <vprintf+0x10c>
 b30:	0db78363          	beq	a5,s11,bf6 <vprintf+0x152>
 b34:	06300713          	li	a4,99
 b38:	0ee78b63          	beq	a5,a4,c2e <vprintf+0x18a>
 b3c:	11378563          	beq	a5,s3,c46 <vprintf+0x1a2>
 b40:	85ce                	mv	a1,s3
 b42:	8552                	mv	a0,s4
 b44:	00000097          	auipc	ra,0x0
 b48:	ea8080e7          	jalr	-344(ra) # 9ec <putc>
 b4c:	85a6                	mv	a1,s1
 b4e:	8552                	mv	a0,s4
 b50:	00000097          	auipc	ra,0x0
 b54:	e9c080e7          	jalr	-356(ra) # 9ec <putc>
 b58:	4901                	li	s2,0
 b5a:	b775                	j	b06 <vprintf+0x62>
 b5c:	008a8493          	addi	s1,s5,8
 b60:	4685                	li	a3,1
 b62:	4629                	li	a2,10
 b64:	000aa583          	lw	a1,0(s5)
 b68:	8552                	mv	a0,s4
 b6a:	00000097          	auipc	ra,0x0
 b6e:	e9e080e7          	jalr	-354(ra) # a08 <printint>
 b72:	8aa6                	mv	s5,s1
 b74:	4901                	li	s2,0
 b76:	bf41                	j	b06 <vprintf+0x62>
 b78:	008a8493          	addi	s1,s5,8
 b7c:	4681                	li	a3,0
 b7e:	4629                	li	a2,10
 b80:	000aa583          	lw	a1,0(s5)
 b84:	8552                	mv	a0,s4
 b86:	00000097          	auipc	ra,0x0
 b8a:	e82080e7          	jalr	-382(ra) # a08 <printint>
 b8e:	8aa6                	mv	s5,s1
 b90:	4901                	li	s2,0
 b92:	bf95                	j	b06 <vprintf+0x62>
 b94:	008a8493          	addi	s1,s5,8
 b98:	4681                	li	a3,0
 b9a:	4641                	li	a2,16
 b9c:	000aa583          	lw	a1,0(s5)
 ba0:	8552                	mv	a0,s4
 ba2:	00000097          	auipc	ra,0x0
 ba6:	e66080e7          	jalr	-410(ra) # a08 <printint>
 baa:	8aa6                	mv	s5,s1
 bac:	4901                	li	s2,0
 bae:	bfa1                	j	b06 <vprintf+0x62>
 bb0:	008a8793          	addi	a5,s5,8
 bb4:	e43e                	sd	a5,8(sp)
 bb6:	000ab903          	ld	s2,0(s5)
 bba:	03000593          	li	a1,48
 bbe:	8552                	mv	a0,s4
 bc0:	00000097          	auipc	ra,0x0
 bc4:	e2c080e7          	jalr	-468(ra) # 9ec <putc>
 bc8:	85e6                	mv	a1,s9
 bca:	8552                	mv	a0,s4
 bcc:	00000097          	auipc	ra,0x0
 bd0:	e20080e7          	jalr	-480(ra) # 9ec <putc>
 bd4:	44c1                	li	s1,16
 bd6:	03c95793          	srli	a5,s2,0x3c
 bda:	97da                	add	a5,a5,s6
 bdc:	0007c583          	lbu	a1,0(a5)
 be0:	8552                	mv	a0,s4
 be2:	00000097          	auipc	ra,0x0
 be6:	e0a080e7          	jalr	-502(ra) # 9ec <putc>
 bea:	0912                	slli	s2,s2,0x4
 bec:	34fd                	addiw	s1,s1,-1
 bee:	f4e5                	bnez	s1,bd6 <vprintf+0x132>
 bf0:	6aa2                	ld	s5,8(sp)
 bf2:	4901                	li	s2,0
 bf4:	bf09                	j	b06 <vprintf+0x62>
 bf6:	008a8493          	addi	s1,s5,8
 bfa:	000ab903          	ld	s2,0(s5)
 bfe:	02090163          	beqz	s2,c20 <vprintf+0x17c>
 c02:	00094583          	lbu	a1,0(s2)
 c06:	c9a1                	beqz	a1,c56 <vprintf+0x1b2>
 c08:	8552                	mv	a0,s4
 c0a:	00000097          	auipc	ra,0x0
 c0e:	de2080e7          	jalr	-542(ra) # 9ec <putc>
 c12:	0905                	addi	s2,s2,1
 c14:	00094583          	lbu	a1,0(s2)
 c18:	f9e5                	bnez	a1,c08 <vprintf+0x164>
 c1a:	8aa6                	mv	s5,s1
 c1c:	4901                	li	s2,0
 c1e:	b5e5                	j	b06 <vprintf+0x62>
 c20:	00000917          	auipc	s2,0x0
 c24:	50090913          	addi	s2,s2,1280 # 1120 <malloc+0x3de>
 c28:	02800593          	li	a1,40
 c2c:	bff1                	j	c08 <vprintf+0x164>
 c2e:	008a8493          	addi	s1,s5,8
 c32:	000ac583          	lbu	a1,0(s5)
 c36:	8552                	mv	a0,s4
 c38:	00000097          	auipc	ra,0x0
 c3c:	db4080e7          	jalr	-588(ra) # 9ec <putc>
 c40:	8aa6                	mv	s5,s1
 c42:	4901                	li	s2,0
 c44:	b5c9                	j	b06 <vprintf+0x62>
 c46:	85ce                	mv	a1,s3
 c48:	8552                	mv	a0,s4
 c4a:	00000097          	auipc	ra,0x0
 c4e:	da2080e7          	jalr	-606(ra) # 9ec <putc>
 c52:	4901                	li	s2,0
 c54:	bd4d                	j	b06 <vprintf+0x62>
 c56:	8aa6                	mv	s5,s1
 c58:	4901                	li	s2,0
 c5a:	b575                	j	b06 <vprintf+0x62>
 c5c:	70e6                	ld	ra,120(sp)
 c5e:	7446                	ld	s0,112(sp)
 c60:	74a6                	ld	s1,104(sp)
 c62:	7906                	ld	s2,96(sp)
 c64:	69e6                	ld	s3,88(sp)
 c66:	6a46                	ld	s4,80(sp)
 c68:	6aa6                	ld	s5,72(sp)
 c6a:	6b06                	ld	s6,64(sp)
 c6c:	7be2                	ld	s7,56(sp)
 c6e:	7c42                	ld	s8,48(sp)
 c70:	7ca2                	ld	s9,40(sp)
 c72:	7d02                	ld	s10,32(sp)
 c74:	6de2                	ld	s11,24(sp)
 c76:	6109                	addi	sp,sp,128
 c78:	8082                	ret

0000000000000c7a <fprintf>:
 c7a:	715d                	addi	sp,sp,-80
 c7c:	ec06                	sd	ra,24(sp)
 c7e:	f032                	sd	a2,32(sp)
 c80:	f436                	sd	a3,40(sp)
 c82:	f83a                	sd	a4,48(sp)
 c84:	fc3e                	sd	a5,56(sp)
 c86:	e0c2                	sd	a6,64(sp)
 c88:	e4c6                	sd	a7,72(sp)
 c8a:	1010                	addi	a2,sp,32
 c8c:	e432                	sd	a2,8(sp)
 c8e:	00000097          	auipc	ra,0x0
 c92:	e16080e7          	jalr	-490(ra) # aa4 <vprintf>
 c96:	60e2                	ld	ra,24(sp)
 c98:	6161                	addi	sp,sp,80
 c9a:	8082                	ret

0000000000000c9c <printf>:
 c9c:	711d                	addi	sp,sp,-96
 c9e:	ec06                	sd	ra,24(sp)
 ca0:	f42e                	sd	a1,40(sp)
 ca2:	f832                	sd	a2,48(sp)
 ca4:	fc36                	sd	a3,56(sp)
 ca6:	e0ba                	sd	a4,64(sp)
 ca8:	e4be                	sd	a5,72(sp)
 caa:	e8c2                	sd	a6,80(sp)
 cac:	ecc6                	sd	a7,88(sp)
 cae:	1030                	addi	a2,sp,40
 cb0:	e432                	sd	a2,8(sp)
 cb2:	85aa                	mv	a1,a0
 cb4:	4505                	li	a0,1
 cb6:	00000097          	auipc	ra,0x0
 cba:	dee080e7          	jalr	-530(ra) # aa4 <vprintf>
 cbe:	60e2                	ld	ra,24(sp)
 cc0:	6125                	addi	sp,sp,96
 cc2:	8082                	ret

0000000000000cc4 <free>:
 cc4:	ff050693          	addi	a3,a0,-16
 cc8:	00000797          	auipc	a5,0x0
 ccc:	4787b783          	ld	a5,1144(a5) # 1140 <freep>
 cd0:	a805                	j	d00 <free+0x3c>
 cd2:	4618                	lw	a4,8(a2)
 cd4:	9db9                	addw	a1,a1,a4
 cd6:	feb52c23          	sw	a1,-8(a0)
 cda:	6398                	ld	a4,0(a5)
 cdc:	6318                	ld	a4,0(a4)
 cde:	fee53823          	sd	a4,-16(a0)
 ce2:	a091                	j	d26 <free+0x62>
 ce4:	ff852703          	lw	a4,-8(a0)
 ce8:	9e39                	addw	a2,a2,a4
 cea:	c790                	sw	a2,8(a5)
 cec:	ff053703          	ld	a4,-16(a0)
 cf0:	e398                	sd	a4,0(a5)
 cf2:	a099                	j	d38 <free+0x74>
 cf4:	6398                	ld	a4,0(a5)
 cf6:	00e7e463          	bltu	a5,a4,cfe <free+0x3a>
 cfa:	00e6ea63          	bltu	a3,a4,d0e <free+0x4a>
 cfe:	87ba                	mv	a5,a4
 d00:	fed7fae3          	bgeu	a5,a3,cf4 <free+0x30>
 d04:	6398                	ld	a4,0(a5)
 d06:	00e6e463          	bltu	a3,a4,d0e <free+0x4a>
 d0a:	fee7eae3          	bltu	a5,a4,cfe <free+0x3a>
 d0e:	ff852583          	lw	a1,-8(a0)
 d12:	6390                	ld	a2,0(a5)
 d14:	02059713          	slli	a4,a1,0x20
 d18:	9301                	srli	a4,a4,0x20
 d1a:	0712                	slli	a4,a4,0x4
 d1c:	9736                	add	a4,a4,a3
 d1e:	fae60ae3          	beq	a2,a4,cd2 <free+0xe>
 d22:	fec53823          	sd	a2,-16(a0)
 d26:	4790                	lw	a2,8(a5)
 d28:	02061713          	slli	a4,a2,0x20
 d2c:	9301                	srli	a4,a4,0x20
 d2e:	0712                	slli	a4,a4,0x4
 d30:	973e                	add	a4,a4,a5
 d32:	fae689e3          	beq	a3,a4,ce4 <free+0x20>
 d36:	e394                	sd	a3,0(a5)
 d38:	00000717          	auipc	a4,0x0
 d3c:	40f73423          	sd	a5,1032(a4) # 1140 <freep>
 d40:	8082                	ret

0000000000000d42 <malloc>:
 d42:	7139                	addi	sp,sp,-64
 d44:	fc06                	sd	ra,56(sp)
 d46:	f822                	sd	s0,48(sp)
 d48:	f426                	sd	s1,40(sp)
 d4a:	f04a                	sd	s2,32(sp)
 d4c:	ec4e                	sd	s3,24(sp)
 d4e:	e852                	sd	s4,16(sp)
 d50:	e456                	sd	s5,8(sp)
 d52:	02051413          	slli	s0,a0,0x20
 d56:	9001                	srli	s0,s0,0x20
 d58:	043d                	addi	s0,s0,15
 d5a:	8011                	srli	s0,s0,0x4
 d5c:	0014091b          	addiw	s2,s0,1
 d60:	0405                	addi	s0,s0,1
 d62:	00000517          	auipc	a0,0x0
 d66:	3de53503          	ld	a0,990(a0) # 1140 <freep>
 d6a:	c905                	beqz	a0,d9a <malloc+0x58>
 d6c:	611c                	ld	a5,0(a0)
 d6e:	4798                	lw	a4,8(a5)
 d70:	04877163          	bgeu	a4,s0,db2 <malloc+0x70>
 d74:	89ca                	mv	s3,s2
 d76:	0009071b          	sext.w	a4,s2
 d7a:	6685                	lui	a3,0x1
 d7c:	00d77363          	bgeu	a4,a3,d82 <malloc+0x40>
 d80:	6985                	lui	s3,0x1
 d82:	00098a1b          	sext.w	s4,s3
 d86:	1982                	slli	s3,s3,0x20
 d88:	0209d993          	srli	s3,s3,0x20
 d8c:	0992                	slli	s3,s3,0x4
 d8e:	00000497          	auipc	s1,0x0
 d92:	3b248493          	addi	s1,s1,946 # 1140 <freep>
 d96:	5afd                	li	s5,-1
 d98:	a0bd                	j	e06 <malloc+0xc4>
 d9a:	00000797          	auipc	a5,0x0
 d9e:	3ae78793          	addi	a5,a5,942 # 1148 <base>
 da2:	00000717          	auipc	a4,0x0
 da6:	38f73f23          	sd	a5,926(a4) # 1140 <freep>
 daa:	e39c                	sd	a5,0(a5)
 dac:	0007a423          	sw	zero,8(a5)
 db0:	b7d1                	j	d74 <malloc+0x32>
 db2:	02e40a63          	beq	s0,a4,de6 <malloc+0xa4>
 db6:	4127073b          	subw	a4,a4,s2
 dba:	c798                	sw	a4,8(a5)
 dbc:	1702                	slli	a4,a4,0x20
 dbe:	9301                	srli	a4,a4,0x20
 dc0:	0712                	slli	a4,a4,0x4
 dc2:	97ba                	add	a5,a5,a4
 dc4:	0127a423          	sw	s2,8(a5)
 dc8:	00000717          	auipc	a4,0x0
 dcc:	36a73c23          	sd	a0,888(a4) # 1140 <freep>
 dd0:	01078513          	addi	a0,a5,16
 dd4:	70e2                	ld	ra,56(sp)
 dd6:	7442                	ld	s0,48(sp)
 dd8:	74a2                	ld	s1,40(sp)
 dda:	7902                	ld	s2,32(sp)
 ddc:	69e2                	ld	s3,24(sp)
 dde:	6a42                	ld	s4,16(sp)
 de0:	6aa2                	ld	s5,8(sp)
 de2:	6121                	addi	sp,sp,64
 de4:	8082                	ret
 de6:	6398                	ld	a4,0(a5)
 de8:	e118                	sd	a4,0(a0)
 dea:	bff9                	j	dc8 <malloc+0x86>
 dec:	01452423          	sw	s4,8(a0)
 df0:	0541                	addi	a0,a0,16
 df2:	00000097          	auipc	ra,0x0
 df6:	ed2080e7          	jalr	-302(ra) # cc4 <free>
 dfa:	6088                	ld	a0,0(s1)
 dfc:	dd61                	beqz	a0,dd4 <malloc+0x92>
 dfe:	611c                	ld	a5,0(a0)
 e00:	4798                	lw	a4,8(a5)
 e02:	fa8778e3          	bgeu	a4,s0,db2 <malloc+0x70>
 e06:	6098                	ld	a4,0(s1)
 e08:	853e                	mv	a0,a5
 e0a:	fef71ae3          	bne	a4,a5,dfe <malloc+0xbc>
 e0e:	854e                	mv	a0,s3
 e10:	00000097          	auipc	ra,0x0
 e14:	8d8080e7          	jalr	-1832(ra) # 6e8 <sbrk>
 e18:	fd551ae3          	bne	a0,s5,dec <malloc+0xaa>
 e1c:	4501                	li	a0,0
 e1e:	bf5d                	j	dd4 <malloc+0x92>
