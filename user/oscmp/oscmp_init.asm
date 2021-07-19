
_oscmp_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_success>:
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	842a                	mv	s0,a0
   a:	00001517          	auipc	a0,0x1
   e:	c1650513          	addi	a0,a0,-1002 # c20 <malloc+0x13a>
  12:	00001097          	auipc	ra,0x1
  16:	a2e080e7          	jalr	-1490(ra) # a40 <printf>
  1a:	600c                	ld	a1,0(s0)
  1c:	cd99                	beqz	a1,3a <print_success+0x3a>
  1e:	0421                	addi	s0,s0,8
  20:	00001497          	auipc	s1,0x1
  24:	c1848493          	addi	s1,s1,-1000 # c38 <malloc+0x152>
  28:	8526                	mv	a0,s1
  2a:	00001097          	auipc	ra,0x1
  2e:	a16080e7          	jalr	-1514(ra) # a40 <printf>
  32:	0421                	addi	s0,s0,8
  34:	ff843583          	ld	a1,-8(s0)
  38:	f9e5                	bnez	a1,28 <print_success+0x28>
  3a:	00001517          	auipc	a0,0x1
  3e:	c0650513          	addi	a0,a0,-1018 # c40 <malloc+0x15a>
  42:	00001097          	auipc	ra,0x1
  46:	9fe080e7          	jalr	-1538(ra) # a40 <printf>
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
  64:	414080e7          	jalr	1044(ra) # 474 <fork>
  68:	ed09                	bnez	a0,82 <test+0x2e>
  6a:	4601                	li	a2,0
  6c:	85a2                	mv	a1,s0
  6e:	8526                	mv	a0,s1
  70:	00000097          	auipc	ra,0x0
  74:	52c080e7          	jalr	1324(ra) # 59c <execve>
  78:	70a2                	ld	ra,40(sp)
  7a:	7402                	ld	s0,32(sp)
  7c:	64e2                	ld	s1,24(sp)
  7e:	6145                	addi	sp,sp,48
  80:	8082                	ret
  82:	0068                	addi	a0,sp,12
  84:	00000097          	auipc	ra,0x0
  88:	3f8080e7          	jalr	1016(ra) # 47c <wait>
  8c:	47b2                	lw	a5,12(sp)
  8e:	fe07c5e3          	bltz	a5,78 <test+0x24>
  92:	8522                	mv	a0,s0
  94:	00000097          	auipc	ra,0x0
  98:	f6c080e7          	jalr	-148(ra) # 0 <print_success>
  9c:	bff1                	j	78 <test+0x24>

000000000000009e <main>:
  9e:	da010113          	addi	sp,sp,-608
  a2:	24113c23          	sd	ra,600(sp)
  a6:	24813823          	sd	s0,592(sp)
  aa:	4589                	li	a1,2
  ac:	00001517          	auipc	a0,0x1
  b0:	ba450513          	addi	a0,a0,-1116 # c50 <malloc+0x16a>
  b4:	00000097          	auipc	ra,0x0
  b8:	3d0080e7          	jalr	976(ra) # 484 <open>
  bc:	4501                	li	a0,0
  be:	00000097          	auipc	ra,0x0
  c2:	3de080e7          	jalr	990(ra) # 49c <dup>
  c6:	4501                	li	a0,0
  c8:	00000097          	auipc	ra,0x0
  cc:	3d4080e7          	jalr	980(ra) # 49c <dup>
  d0:	00001717          	auipc	a4,0x1
  d4:	b8870713          	addi	a4,a4,-1144 # c58 <malloc+0x172>
  d8:	22e13c23          	sd	a4,568(sp)
  dc:	00001797          	auipc	a5,0x1
  e0:	b8478793          	addi	a5,a5,-1148 # c60 <malloc+0x17a>
  e4:	24f13023          	sd	a5,576(sp)
  e8:	24013423          	sd	zero,584(sp)
  ec:	00001797          	auipc	a5,0x1
  f0:	c8c78793          	addi	a5,a5,-884 # d78 <malloc+0x292>
  f4:	6388                	ld	a0,0(a5)
  f6:	678c                	ld	a1,8(a5)
  f8:	6b90                	ld	a2,16(a5)
  fa:	6f94                	ld	a3,24(a5)
  fc:	20a13c23          	sd	a0,536(sp)
 100:	22b13023          	sd	a1,544(sp)
 104:	22c13423          	sd	a2,552(sp)
 108:	22d13823          	sd	a3,560(sp)
 10c:	7388                	ld	a0,32(a5)
 10e:	778c                	ld	a1,40(a5)
 110:	7b90                	ld	a2,48(a5)
 112:	7f94                	ld	a3,56(a5)
 114:	ffaa                	sd	a0,504(sp)
 116:	20b13023          	sd	a1,512(sp)
 11a:	20c13423          	sd	a2,520(sp)
 11e:	20d13823          	sd	a3,528(sp)
 122:	00001697          	auipc	a3,0x1
 126:	b5e68693          	addi	a3,a3,-1186 # c80 <malloc+0x19a>
 12a:	f3b6                	sd	a3,480(sp)
 12c:	00001697          	auipc	a3,0x1
 130:	b6468693          	addi	a3,a3,-1180 # c90 <malloc+0x1aa>
 134:	f7b6                	sd	a3,488(sp)
 136:	fb82                	sd	zero,496(sp)
 138:	00001617          	auipc	a2,0x1
 13c:	b6860613          	addi	a2,a2,-1176 # ca0 <malloc+0x1ba>
 140:	ebb2                	sd	a2,464(sp)
 142:	ef82                	sd	zero,472(sp)
 144:	00001617          	auipc	a2,0x1
 148:	b6460613          	addi	a2,a2,-1180 # ca8 <malloc+0x1c2>
 14c:	e3b2                	sd	a2,448(sp)
 14e:	e782                	sd	zero,456(sp)
 150:	00001617          	auipc	a2,0x1
 154:	b6060613          	addi	a2,a2,-1184 # cb0 <malloc+0x1ca>
 158:	fb32                	sd	a2,432(sp)
 15a:	ff02                	sd	zero,440(sp)
 15c:	00001617          	auipc	a2,0x1
 160:	b5c60613          	addi	a2,a2,-1188 # cb8 <malloc+0x1d2>
 164:	ef32                	sd	a2,408(sp)
 166:	f336                	sd	a3,416(sp)
 168:	f702                	sd	zero,424(sp)
 16a:	0407b803          	ld	a6,64(a5)
 16e:	67a8                	ld	a0,72(a5)
 170:	6bac                	ld	a1,80(a5)
 172:	6fb0                	ld	a2,88(a5)
 174:	73b4                	ld	a3,96(a5)
 176:	fac2                	sd	a6,368(sp)
 178:	feaa                	sd	a0,376(sp)
 17a:	e32e                	sd	a1,384(sp)
 17c:	e732                	sd	a2,392(sp)
 17e:	eb36                	sd	a3,400(sp)
 180:	00001697          	auipc	a3,0x1
 184:	b4068693          	addi	a3,a3,-1216 # cc0 <malloc+0x1da>
 188:	f2b6                	sd	a3,352(sp)
 18a:	f682                	sd	zero,360(sp)
 18c:	00001697          	auipc	a3,0x1
 190:	b3c68693          	addi	a3,a3,-1220 # cc8 <malloc+0x1e2>
 194:	eab6                	sd	a3,336(sp)
 196:	ee82                	sd	zero,344(sp)
 198:	00001697          	auipc	a3,0x1
 19c:	b3868693          	addi	a3,a3,-1224 # cd0 <malloc+0x1ea>
 1a0:	fe36                	sd	a3,312(sp)
 1a2:	00001697          	auipc	a3,0x1
 1a6:	b3668693          	addi	a3,a3,-1226 # cd8 <malloc+0x1f2>
 1aa:	e2b6                	sd	a3,320(sp)
 1ac:	e682                	sd	zero,328(sp)
 1ae:	00001617          	auipc	a2,0x1
 1b2:	b3260613          	addi	a2,a2,-1230 # ce0 <malloc+0x1fa>
 1b6:	f632                	sd	a2,296(sp)
 1b8:	fa02                	sd	zero,304(sp)
 1ba:	00001617          	auipc	a2,0x1
 1be:	b2e60613          	addi	a2,a2,-1234 # ce8 <malloc+0x202>
 1c2:	ee32                	sd	a2,280(sp)
 1c4:	f202                	sd	zero,288(sp)
 1c6:	00001617          	auipc	a2,0x1
 1ca:	b2a60613          	addi	a2,a2,-1238 # cf0 <malloc+0x20a>
 1ce:	e632                	sd	a2,264(sp)
 1d0:	ea02                	sd	zero,272(sp)
 1d2:	00001617          	auipc	a2,0x1
 1d6:	b2660613          	addi	a2,a2,-1242 # cf8 <malloc+0x212>
 1da:	fdb2                	sd	a2,248(sp)
 1dc:	e202                	sd	zero,256(sp)
 1de:	00001617          	auipc	a2,0x1
 1e2:	b2260613          	addi	a2,a2,-1246 # d00 <malloc+0x21a>
 1e6:	f1b2                	sd	a2,224(sp)
 1e8:	00001617          	auipc	a2,0x1
 1ec:	b2060613          	addi	a2,a2,-1248 # d08 <malloc+0x222>
 1f0:	f5b2                	sd	a2,232(sp)
 1f2:	f982                	sd	zero,240(sp)
 1f4:	e9b6                	sd	a3,208(sp)
 1f6:	ed82                	sd	zero,216(sp)
 1f8:	00001697          	auipc	a3,0x1
 1fc:	b1868693          	addi	a3,a3,-1256 # d10 <malloc+0x22a>
 200:	e1b6                	sd	a3,192(sp)
 202:	e582                	sd	zero,200(sp)
 204:	f53a                	sd	a4,168(sp)
 206:	00001717          	auipc	a4,0x1
 20a:	b1270713          	addi	a4,a4,-1262 # d18 <malloc+0x232>
 20e:	f93a                	sd	a4,176(sp)
 210:	fd02                	sd	zero,184(sp)
 212:	00001717          	auipc	a4,0x1
 216:	b2670713          	addi	a4,a4,-1242 # d38 <malloc+0x252>
 21a:	e93a                	sd	a4,144(sp)
 21c:	00001417          	auipc	s0,0x1
 220:	9f440413          	addi	s0,s0,-1548 # c10 <malloc+0x12a>
 224:	ed22                	sd	s0,152(sp)
 226:	f102                	sd	zero,160(sp)
 228:	00001717          	auipc	a4,0x1
 22c:	b1870713          	addi	a4,a4,-1256 # d40 <malloc+0x25a>
 230:	fcba                	sd	a4,120(sp)
 232:	e122                	sd	s0,128(sp)
 234:	e502                	sd	zero,136(sp)
 236:	77ac                	ld	a1,104(a5)
 238:	7bb0                	ld	a2,112(a5)
 23a:	7fb4                	ld	a3,120(a5)
 23c:	63d8                	ld	a4,128(a5)
 23e:	67dc                	ld	a5,136(a5)
 240:	e8ae                	sd	a1,80(sp)
 242:	ecb2                	sd	a2,88(sp)
 244:	f0b6                	sd	a3,96(sp)
 246:	f4ba                	sd	a4,104(sp)
 248:	f8be                	sd	a5,112(sp)
 24a:	00001797          	auipc	a5,0x1
 24e:	afe78793          	addi	a5,a5,-1282 # d48 <malloc+0x262>
 252:	fc3e                	sd	a5,56(sp)
 254:	e0a2                	sd	s0,64(sp)
 256:	e482                	sd	zero,72(sp)
 258:	00001797          	auipc	a5,0x1
 25c:	af878793          	addi	a5,a5,-1288 # d50 <malloc+0x26a>
 260:	f03e                	sd	a5,32(sp)
 262:	f422                	sd	s0,40(sp)
 264:	f802                	sd	zero,48(sp)
 266:	00001797          	auipc	a5,0x1
 26a:	af278793          	addi	a5,a5,-1294 # d58 <malloc+0x272>
 26e:	e43e                	sd	a5,8(sp)
 270:	e822                	sd	s0,16(sp)
 272:	ec02                	sd	zero,24(sp)
 274:	1c2c                	addi	a1,sp,568
 276:	00001517          	auipc	a0,0x1
 27a:	aea50513          	addi	a0,a0,-1302 # d60 <malloc+0x27a>
 27e:	00000097          	auipc	ra,0x0
 282:	dd6080e7          	jalr	-554(ra) # 54 <test>
 286:	0c2c                	addi	a1,sp,536
 288:	00001517          	auipc	a0,0x1
 28c:	ad850513          	addi	a0,a0,-1320 # d60 <malloc+0x27a>
 290:	00000097          	auipc	ra,0x0
 294:	dc4080e7          	jalr	-572(ra) # 54 <test>
 298:	1bac                	addi	a1,sp,504
 29a:	00001517          	auipc	a0,0x1
 29e:	ac650513          	addi	a0,a0,-1338 # d60 <malloc+0x27a>
 2a2:	00000097          	auipc	ra,0x0
 2a6:	db2080e7          	jalr	-590(ra) # 54 <test>
 2aa:	138c                	addi	a1,sp,480
 2ac:	00001517          	auipc	a0,0x1
 2b0:	ab450513          	addi	a0,a0,-1356 # d60 <malloc+0x27a>
 2b4:	00000097          	auipc	ra,0x0
 2b8:	da0080e7          	jalr	-608(ra) # 54 <test>
 2bc:	0b8c                	addi	a1,sp,464
 2be:	00001517          	auipc	a0,0x1
 2c2:	aa250513          	addi	a0,a0,-1374 # d60 <malloc+0x27a>
 2c6:	00000097          	auipc	ra,0x0
 2ca:	d8e080e7          	jalr	-626(ra) # 54 <test>
 2ce:	038c                	addi	a1,sp,448
 2d0:	00001517          	auipc	a0,0x1
 2d4:	a9050513          	addi	a0,a0,-1392 # d60 <malloc+0x27a>
 2d8:	00000097          	auipc	ra,0x0
 2dc:	d7c080e7          	jalr	-644(ra) # 54 <test>
 2e0:	1b0c                	addi	a1,sp,432
 2e2:	00001517          	auipc	a0,0x1
 2e6:	a7e50513          	addi	a0,a0,-1410 # d60 <malloc+0x27a>
 2ea:	00000097          	auipc	ra,0x0
 2ee:	d6a080e7          	jalr	-662(ra) # 54 <test>
 2f2:	0b2c                	addi	a1,sp,408
 2f4:	00001517          	auipc	a0,0x1
 2f8:	a6c50513          	addi	a0,a0,-1428 # d60 <malloc+0x27a>
 2fc:	00000097          	auipc	ra,0x0
 300:	d58080e7          	jalr	-680(ra) # 54 <test>
 304:	1a8c                	addi	a1,sp,368
 306:	00001517          	auipc	a0,0x1
 30a:	a5a50513          	addi	a0,a0,-1446 # d60 <malloc+0x27a>
 30e:	00000097          	auipc	ra,0x0
 312:	d46080e7          	jalr	-698(ra) # 54 <test>
 316:	128c                	addi	a1,sp,352
 318:	00001517          	auipc	a0,0x1
 31c:	a4850513          	addi	a0,a0,-1464 # d60 <malloc+0x27a>
 320:	00000097          	auipc	ra,0x0
 324:	d34080e7          	jalr	-716(ra) # 54 <test>
 328:	0a8c                	addi	a1,sp,336
 32a:	00001517          	auipc	a0,0x1
 32e:	a3650513          	addi	a0,a0,-1482 # d60 <malloc+0x27a>
 332:	00000097          	auipc	ra,0x0
 336:	d22080e7          	jalr	-734(ra) # 54 <test>
 33a:	1a2c                	addi	a1,sp,312
 33c:	00001517          	auipc	a0,0x1
 340:	a2450513          	addi	a0,a0,-1500 # d60 <malloc+0x27a>
 344:	00000097          	auipc	ra,0x0
 348:	d10080e7          	jalr	-752(ra) # 54 <test>
 34c:	122c                	addi	a1,sp,296
 34e:	00001517          	auipc	a0,0x1
 352:	a1250513          	addi	a0,a0,-1518 # d60 <malloc+0x27a>
 356:	00000097          	auipc	ra,0x0
 35a:	cfe080e7          	jalr	-770(ra) # 54 <test>
 35e:	0a2c                	addi	a1,sp,280
 360:	00001517          	auipc	a0,0x1
 364:	a0050513          	addi	a0,a0,-1536 # d60 <malloc+0x27a>
 368:	00000097          	auipc	ra,0x0
 36c:	cec080e7          	jalr	-788(ra) # 54 <test>
 370:	022c                	addi	a1,sp,264
 372:	00001517          	auipc	a0,0x1
 376:	9ee50513          	addi	a0,a0,-1554 # d60 <malloc+0x27a>
 37a:	00000097          	auipc	ra,0x0
 37e:	cda080e7          	jalr	-806(ra) # 54 <test>
 382:	118c                	addi	a1,sp,224
 384:	00001517          	auipc	a0,0x1
 388:	9dc50513          	addi	a0,a0,-1572 # d60 <malloc+0x27a>
 38c:	00000097          	auipc	ra,0x0
 390:	cc8080e7          	jalr	-824(ra) # 54 <test>
 394:	098c                	addi	a1,sp,208
 396:	00001517          	auipc	a0,0x1
 39a:	9ca50513          	addi	a0,a0,-1590 # d60 <malloc+0x27a>
 39e:	00000097          	auipc	ra,0x0
 3a2:	cb6080e7          	jalr	-842(ra) # 54 <test>
 3a6:	018c                	addi	a1,sp,192
 3a8:	00001517          	auipc	a0,0x1
 3ac:	9b850513          	addi	a0,a0,-1608 # d60 <malloc+0x27a>
 3b0:	00000097          	auipc	ra,0x0
 3b4:	ca4080e7          	jalr	-860(ra) # 54 <test>
 3b8:	19ac                	addi	a1,sp,248
 3ba:	00001517          	auipc	a0,0x1
 3be:	9a650513          	addi	a0,a0,-1626 # d60 <malloc+0x27a>
 3c2:	00000097          	auipc	ra,0x0
 3c6:	c92080e7          	jalr	-878(ra) # 54 <test>
 3ca:	112c                	addi	a1,sp,168
 3cc:	00001517          	auipc	a0,0x1
 3d0:	99450513          	addi	a0,a0,-1644 # d60 <malloc+0x27a>
 3d4:	00000097          	auipc	ra,0x0
 3d8:	c80080e7          	jalr	-896(ra) # 54 <test>
 3dc:	090c                	addi	a1,sp,144
 3de:	00001517          	auipc	a0,0x1
 3e2:	98250513          	addi	a0,a0,-1662 # d60 <malloc+0x27a>
 3e6:	00000097          	auipc	ra,0x0
 3ea:	c6e080e7          	jalr	-914(ra) # 54 <test>
 3ee:	4589                	li	a1,2
 3f0:	8522                	mv	a0,s0
 3f2:	00000097          	auipc	ra,0x0
 3f6:	092080e7          	jalr	146(ra) # 484 <open>
 3fa:	842a                	mv	s0,a0
 3fc:	4635                	li	a2,13
 3fe:	00001597          	auipc	a1,0x1
 402:	96a58593          	addi	a1,a1,-1686 # d68 <malloc+0x282>
 406:	00000097          	auipc	ra,0x0
 40a:	114080e7          	jalr	276(ra) # 51a <write>
 40e:	8522                	mv	a0,s0
 410:	00000097          	auipc	ra,0x0
 414:	0e2080e7          	jalr	226(ra) # 4f2 <close>
 418:	18ac                	addi	a1,sp,120
 41a:	00001517          	auipc	a0,0x1
 41e:	94650513          	addi	a0,a0,-1722 # d60 <malloc+0x27a>
 422:	00000097          	auipc	ra,0x0
 426:	c32080e7          	jalr	-974(ra) # 54 <test>
 42a:	088c                	addi	a1,sp,80
 42c:	00001517          	auipc	a0,0x1
 430:	93450513          	addi	a0,a0,-1740 # d60 <malloc+0x27a>
 434:	00000097          	auipc	ra,0x0
 438:	c20080e7          	jalr	-992(ra) # 54 <test>
 43c:	182c                	addi	a1,sp,56
 43e:	00001517          	auipc	a0,0x1
 442:	92250513          	addi	a0,a0,-1758 # d60 <malloc+0x27a>
 446:	00000097          	auipc	ra,0x0
 44a:	c0e080e7          	jalr	-1010(ra) # 54 <test>
 44e:	100c                	addi	a1,sp,32
 450:	00001517          	auipc	a0,0x1
 454:	91050513          	addi	a0,a0,-1776 # d60 <malloc+0x27a>
 458:	00000097          	auipc	ra,0x0
 45c:	bfc080e7          	jalr	-1028(ra) # 54 <test>
 460:	002c                	addi	a1,sp,8
 462:	00001517          	auipc	a0,0x1
 466:	8fe50513          	addi	a0,a0,-1794 # d60 <malloc+0x27a>
 46a:	00000097          	auipc	ra,0x0
 46e:	bea080e7          	jalr	-1046(ra) # 54 <test>
 472:	a001                	j	472 <main+0x3d4>

0000000000000474 <fork>:
 474:	4885                	li	a7,1
 476:	00000073          	ecall
 47a:	8082                	ret

000000000000047c <wait>:
 47c:	488d                	li	a7,3
 47e:	00000073          	ecall
 482:	8082                	ret

0000000000000484 <open>:
 484:	4889                	li	a7,2
 486:	00000073          	ecall
 48a:	8082                	ret

000000000000048c <sbrk>:
 48c:	4891                	li	a7,4
 48e:	00000073          	ecall
 492:	8082                	ret

0000000000000494 <getcwd>:
 494:	48c5                	li	a7,17
 496:	00000073          	ecall
 49a:	8082                	ret

000000000000049c <dup>:
 49c:	48dd                	li	a7,23
 49e:	00000073          	ecall
 4a2:	8082                	ret

00000000000004a4 <dup3>:
 4a4:	48e1                	li	a7,24
 4a6:	00000073          	ecall
 4aa:	8082                	ret

00000000000004ac <mkdirat>:
 4ac:	02200893          	li	a7,34
 4b0:	00000073          	ecall
 4b4:	8082                	ret

00000000000004b6 <unlinkat>:
 4b6:	02300893          	li	a7,35
 4ba:	00000073          	ecall
 4be:	8082                	ret

00000000000004c0 <linkat>:
 4c0:	02500893          	li	a7,37
 4c4:	00000073          	ecall
 4c8:	8082                	ret

00000000000004ca <umount2>:
 4ca:	02700893          	li	a7,39
 4ce:	00000073          	ecall
 4d2:	8082                	ret

00000000000004d4 <mount>:
 4d4:	02800893          	li	a7,40
 4d8:	00000073          	ecall
 4dc:	8082                	ret

00000000000004de <chdir>:
 4de:	03100893          	li	a7,49
 4e2:	00000073          	ecall
 4e6:	8082                	ret

00000000000004e8 <openat>:
 4e8:	03800893          	li	a7,56
 4ec:	00000073          	ecall
 4f0:	8082                	ret

00000000000004f2 <close>:
 4f2:	03900893          	li	a7,57
 4f6:	00000073          	ecall
 4fa:	8082                	ret

00000000000004fc <pipe2>:
 4fc:	03b00893          	li	a7,59
 500:	00000073          	ecall
 504:	8082                	ret

0000000000000506 <getdents64>:
 506:	03d00893          	li	a7,61
 50a:	00000073          	ecall
 50e:	8082                	ret

0000000000000510 <read>:
 510:	03f00893          	li	a7,63
 514:	00000073          	ecall
 518:	8082                	ret

000000000000051a <write>:
 51a:	04000893          	li	a7,64
 51e:	00000073          	ecall
 522:	8082                	ret

0000000000000524 <fstat>:
 524:	05000893          	li	a7,80
 528:	00000073          	ecall
 52c:	8082                	ret

000000000000052e <exit>:
 52e:	05d00893          	li	a7,93
 532:	00000073          	ecall
 536:	8082                	ret

0000000000000538 <nanosleep>:
 538:	06500893          	li	a7,101
 53c:	00000073          	ecall
 540:	8082                	ret

0000000000000542 <sched_yield>:
 542:	07c00893          	li	a7,124
 546:	00000073          	ecall
 54a:	8082                	ret

000000000000054c <times>:
 54c:	09900893          	li	a7,153
 550:	00000073          	ecall
 554:	8082                	ret

0000000000000556 <uname>:
 556:	0a000893          	li	a7,160
 55a:	00000073          	ecall
 55e:	8082                	ret

0000000000000560 <gettimeofday>:
 560:	0a900893          	li	a7,169
 564:	00000073          	ecall
 568:	8082                	ret

000000000000056a <brk>:
 56a:	0d600893          	li	a7,214
 56e:	00000073          	ecall
 572:	8082                	ret

0000000000000574 <munmap>:
 574:	0d700893          	li	a7,215
 578:	00000073          	ecall
 57c:	8082                	ret

000000000000057e <getpid>:
 57e:	0ac00893          	li	a7,172
 582:	00000073          	ecall
 586:	8082                	ret

0000000000000588 <getppid>:
 588:	0ad00893          	li	a7,173
 58c:	00000073          	ecall
 590:	8082                	ret

0000000000000592 <clone>:
 592:	0dc00893          	li	a7,220
 596:	00000073          	ecall
 59a:	8082                	ret

000000000000059c <execve>:
 59c:	0dd00893          	li	a7,221
 5a0:	00000073          	ecall
 5a4:	8082                	ret

00000000000005a6 <mmap>:
 5a6:	0de00893          	li	a7,222
 5aa:	00000073          	ecall
 5ae:	8082                	ret

00000000000005b0 <wait4>:
 5b0:	10400893          	li	a7,260
 5b4:	00000073          	ecall
 5b8:	8082                	ret

00000000000005ba <kernel_panic>:
 5ba:	18f00893          	li	a7,399
 5be:	00000073          	ecall
 5c2:	8082                	ret

00000000000005c4 <strcpy>:
 5c4:	87aa                	mv	a5,a0
 5c6:	0585                	addi	a1,a1,1
 5c8:	0785                	addi	a5,a5,1
 5ca:	fff5c703          	lbu	a4,-1(a1)
 5ce:	fee78fa3          	sb	a4,-1(a5)
 5d2:	fb75                	bnez	a4,5c6 <strcpy+0x2>
 5d4:	8082                	ret

00000000000005d6 <strcmp>:
 5d6:	00054783          	lbu	a5,0(a0)
 5da:	cb91                	beqz	a5,5ee <strcmp+0x18>
 5dc:	0005c703          	lbu	a4,0(a1)
 5e0:	00f71763          	bne	a4,a5,5ee <strcmp+0x18>
 5e4:	0505                	addi	a0,a0,1
 5e6:	0585                	addi	a1,a1,1
 5e8:	00054783          	lbu	a5,0(a0)
 5ec:	fbe5                	bnez	a5,5dc <strcmp+0x6>
 5ee:	0005c503          	lbu	a0,0(a1)
 5f2:	40a7853b          	subw	a0,a5,a0
 5f6:	8082                	ret

00000000000005f8 <strlen>:
 5f8:	00054783          	lbu	a5,0(a0)
 5fc:	cf81                	beqz	a5,614 <strlen+0x1c>
 5fe:	0505                	addi	a0,a0,1
 600:	87aa                	mv	a5,a0
 602:	4685                	li	a3,1
 604:	9e89                	subw	a3,a3,a0
 606:	00f6853b          	addw	a0,a3,a5
 60a:	0785                	addi	a5,a5,1
 60c:	fff7c703          	lbu	a4,-1(a5)
 610:	fb7d                	bnez	a4,606 <strlen+0xe>
 612:	8082                	ret
 614:	4501                	li	a0,0
 616:	8082                	ret

0000000000000618 <memset>:
 618:	ce09                	beqz	a2,632 <memset+0x1a>
 61a:	87aa                	mv	a5,a0
 61c:	fff6071b          	addiw	a4,a2,-1
 620:	1702                	slli	a4,a4,0x20
 622:	9301                	srli	a4,a4,0x20
 624:	0705                	addi	a4,a4,1
 626:	972a                	add	a4,a4,a0
 628:	00b78023          	sb	a1,0(a5)
 62c:	0785                	addi	a5,a5,1
 62e:	fee79de3          	bne	a5,a4,628 <memset+0x10>
 632:	8082                	ret

0000000000000634 <strchr>:
 634:	00054783          	lbu	a5,0(a0)
 638:	cb89                	beqz	a5,64a <strchr+0x16>
 63a:	00f58963          	beq	a1,a5,64c <strchr+0x18>
 63e:	0505                	addi	a0,a0,1
 640:	00054783          	lbu	a5,0(a0)
 644:	fbfd                	bnez	a5,63a <strchr+0x6>
 646:	4501                	li	a0,0
 648:	8082                	ret
 64a:	4501                	li	a0,0
 64c:	8082                	ret

000000000000064e <gets>:
 64e:	715d                	addi	sp,sp,-80
 650:	e486                	sd	ra,72(sp)
 652:	e0a2                	sd	s0,64(sp)
 654:	fc26                	sd	s1,56(sp)
 656:	f84a                	sd	s2,48(sp)
 658:	f44e                	sd	s3,40(sp)
 65a:	f052                	sd	s4,32(sp)
 65c:	ec56                	sd	s5,24(sp)
 65e:	e85a                	sd	s6,16(sp)
 660:	8b2a                	mv	s6,a0
 662:	89ae                	mv	s3,a1
 664:	84aa                	mv	s1,a0
 666:	4401                	li	s0,0
 668:	4a29                	li	s4,10
 66a:	4ab5                	li	s5,13
 66c:	8922                	mv	s2,s0
 66e:	2405                	addiw	s0,s0,1
 670:	03345863          	bge	s0,s3,6a0 <gets+0x52>
 674:	4605                	li	a2,1
 676:	00f10593          	addi	a1,sp,15
 67a:	4501                	li	a0,0
 67c:	00000097          	auipc	ra,0x0
 680:	e94080e7          	jalr	-364(ra) # 510 <read>
 684:	00a05e63          	blez	a0,6a0 <gets+0x52>
 688:	00f14783          	lbu	a5,15(sp)
 68c:	00f48023          	sb	a5,0(s1)
 690:	01478763          	beq	a5,s4,69e <gets+0x50>
 694:	0485                	addi	s1,s1,1
 696:	fd579be3          	bne	a5,s5,66c <gets+0x1e>
 69a:	8922                	mv	s2,s0
 69c:	a011                	j	6a0 <gets+0x52>
 69e:	8922                	mv	s2,s0
 6a0:	995a                	add	s2,s2,s6
 6a2:	00090023          	sb	zero,0(s2)
 6a6:	855a                	mv	a0,s6
 6a8:	60a6                	ld	ra,72(sp)
 6aa:	6406                	ld	s0,64(sp)
 6ac:	74e2                	ld	s1,56(sp)
 6ae:	7942                	ld	s2,48(sp)
 6b0:	79a2                	ld	s3,40(sp)
 6b2:	7a02                	ld	s4,32(sp)
 6b4:	6ae2                	ld	s5,24(sp)
 6b6:	6b42                	ld	s6,16(sp)
 6b8:	6161                	addi	sp,sp,80
 6ba:	8082                	ret

00000000000006bc <atoi>:
 6bc:	86aa                	mv	a3,a0
 6be:	00054603          	lbu	a2,0(a0)
 6c2:	fd06079b          	addiw	a5,a2,-48
 6c6:	0ff7f793          	andi	a5,a5,255
 6ca:	4725                	li	a4,9
 6cc:	02f76663          	bltu	a4,a5,6f8 <atoi+0x3c>
 6d0:	4501                	li	a0,0
 6d2:	45a5                	li	a1,9
 6d4:	0685                	addi	a3,a3,1
 6d6:	0025179b          	slliw	a5,a0,0x2
 6da:	9fa9                	addw	a5,a5,a0
 6dc:	0017979b          	slliw	a5,a5,0x1
 6e0:	9fb1                	addw	a5,a5,a2
 6e2:	fd07851b          	addiw	a0,a5,-48
 6e6:	0006c603          	lbu	a2,0(a3)
 6ea:	fd06071b          	addiw	a4,a2,-48
 6ee:	0ff77713          	andi	a4,a4,255
 6f2:	fee5f1e3          	bgeu	a1,a4,6d4 <atoi+0x18>
 6f6:	8082                	ret
 6f8:	4501                	li	a0,0
 6fa:	8082                	ret

00000000000006fc <memmove>:
 6fc:	02b57463          	bgeu	a0,a1,724 <memmove+0x28>
 700:	04c05663          	blez	a2,74c <memmove+0x50>
 704:	fff6079b          	addiw	a5,a2,-1
 708:	1782                	slli	a5,a5,0x20
 70a:	9381                	srli	a5,a5,0x20
 70c:	0785                	addi	a5,a5,1
 70e:	97aa                	add	a5,a5,a0
 710:	872a                	mv	a4,a0
 712:	0585                	addi	a1,a1,1
 714:	0705                	addi	a4,a4,1
 716:	fff5c683          	lbu	a3,-1(a1)
 71a:	fed70fa3          	sb	a3,-1(a4)
 71e:	fee79ae3          	bne	a5,a4,712 <memmove+0x16>
 722:	8082                	ret
 724:	00c50733          	add	a4,a0,a2
 728:	95b2                	add	a1,a1,a2
 72a:	02c05163          	blez	a2,74c <memmove+0x50>
 72e:	fff6079b          	addiw	a5,a2,-1
 732:	1782                	slli	a5,a5,0x20
 734:	9381                	srli	a5,a5,0x20
 736:	fff7c793          	not	a5,a5
 73a:	97ba                	add	a5,a5,a4
 73c:	15fd                	addi	a1,a1,-1
 73e:	177d                	addi	a4,a4,-1
 740:	0005c683          	lbu	a3,0(a1)
 744:	00d70023          	sb	a3,0(a4)
 748:	fee79ae3          	bne	a5,a4,73c <memmove+0x40>
 74c:	8082                	ret

000000000000074e <memcmp>:
 74e:	fff6069b          	addiw	a3,a2,-1
 752:	c605                	beqz	a2,77a <memcmp+0x2c>
 754:	1682                	slli	a3,a3,0x20
 756:	9281                	srli	a3,a3,0x20
 758:	0685                	addi	a3,a3,1
 75a:	96aa                	add	a3,a3,a0
 75c:	00054783          	lbu	a5,0(a0)
 760:	0005c703          	lbu	a4,0(a1)
 764:	00e79863          	bne	a5,a4,774 <memcmp+0x26>
 768:	0505                	addi	a0,a0,1
 76a:	0585                	addi	a1,a1,1
 76c:	fed518e3          	bne	a0,a3,75c <memcmp+0xe>
 770:	4501                	li	a0,0
 772:	8082                	ret
 774:	40e7853b          	subw	a0,a5,a4
 778:	8082                	ret
 77a:	4501                	li	a0,0
 77c:	8082                	ret

000000000000077e <memcpy>:
 77e:	1141                	addi	sp,sp,-16
 780:	e406                	sd	ra,8(sp)
 782:	00000097          	auipc	ra,0x0
 786:	f7a080e7          	jalr	-134(ra) # 6fc <memmove>
 78a:	60a2                	ld	ra,8(sp)
 78c:	0141                	addi	sp,sp,16
 78e:	8082                	ret

0000000000000790 <putc>:
 790:	1101                	addi	sp,sp,-32
 792:	ec06                	sd	ra,24(sp)
 794:	00b107a3          	sb	a1,15(sp)
 798:	4605                	li	a2,1
 79a:	00f10593          	addi	a1,sp,15
 79e:	00000097          	auipc	ra,0x0
 7a2:	d7c080e7          	jalr	-644(ra) # 51a <write>
 7a6:	60e2                	ld	ra,24(sp)
 7a8:	6105                	addi	sp,sp,32
 7aa:	8082                	ret

00000000000007ac <printint>:
 7ac:	7179                	addi	sp,sp,-48
 7ae:	f406                	sd	ra,40(sp)
 7b0:	f022                	sd	s0,32(sp)
 7b2:	ec26                	sd	s1,24(sp)
 7b4:	e84a                	sd	s2,16(sp)
 7b6:	84aa                	mv	s1,a0
 7b8:	c299                	beqz	a3,7be <printint+0x12>
 7ba:	0805c363          	bltz	a1,840 <printint+0x94>
 7be:	2581                	sext.w	a1,a1
 7c0:	4881                	li	a7,0
 7c2:	868a                	mv	a3,sp
 7c4:	4701                	li	a4,0
 7c6:	2601                	sext.w	a2,a2
 7c8:	00000517          	auipc	a0,0x0
 7cc:	64850513          	addi	a0,a0,1608 # e10 <digits>
 7d0:	883a                	mv	a6,a4
 7d2:	2705                	addiw	a4,a4,1
 7d4:	02c5f7bb          	remuw	a5,a1,a2
 7d8:	1782                	slli	a5,a5,0x20
 7da:	9381                	srli	a5,a5,0x20
 7dc:	97aa                	add	a5,a5,a0
 7de:	0007c783          	lbu	a5,0(a5)
 7e2:	00f68023          	sb	a5,0(a3)
 7e6:	0005879b          	sext.w	a5,a1
 7ea:	02c5d5bb          	divuw	a1,a1,a2
 7ee:	0685                	addi	a3,a3,1
 7f0:	fec7f0e3          	bgeu	a5,a2,7d0 <printint+0x24>
 7f4:	00088a63          	beqz	a7,808 <printint+0x5c>
 7f8:	081c                	addi	a5,sp,16
 7fa:	973e                	add	a4,a4,a5
 7fc:	02d00793          	li	a5,45
 800:	fef70823          	sb	a5,-16(a4)
 804:	0028071b          	addiw	a4,a6,2
 808:	02e05663          	blez	a4,834 <printint+0x88>
 80c:	00e10433          	add	s0,sp,a4
 810:	fff10913          	addi	s2,sp,-1
 814:	993a                	add	s2,s2,a4
 816:	377d                	addiw	a4,a4,-1
 818:	1702                	slli	a4,a4,0x20
 81a:	9301                	srli	a4,a4,0x20
 81c:	40e90933          	sub	s2,s2,a4
 820:	fff44583          	lbu	a1,-1(s0)
 824:	8526                	mv	a0,s1
 826:	00000097          	auipc	ra,0x0
 82a:	f6a080e7          	jalr	-150(ra) # 790 <putc>
 82e:	147d                	addi	s0,s0,-1
 830:	ff2418e3          	bne	s0,s2,820 <printint+0x74>
 834:	70a2                	ld	ra,40(sp)
 836:	7402                	ld	s0,32(sp)
 838:	64e2                	ld	s1,24(sp)
 83a:	6942                	ld	s2,16(sp)
 83c:	6145                	addi	sp,sp,48
 83e:	8082                	ret
 840:	40b005bb          	negw	a1,a1
 844:	4885                	li	a7,1
 846:	bfb5                	j	7c2 <printint+0x16>

0000000000000848 <vprintf>:
 848:	7119                	addi	sp,sp,-128
 84a:	fc86                	sd	ra,120(sp)
 84c:	f8a2                	sd	s0,112(sp)
 84e:	f4a6                	sd	s1,104(sp)
 850:	f0ca                	sd	s2,96(sp)
 852:	ecce                	sd	s3,88(sp)
 854:	e8d2                	sd	s4,80(sp)
 856:	e4d6                	sd	s5,72(sp)
 858:	e0da                	sd	s6,64(sp)
 85a:	fc5e                	sd	s7,56(sp)
 85c:	f862                	sd	s8,48(sp)
 85e:	f466                	sd	s9,40(sp)
 860:	f06a                	sd	s10,32(sp)
 862:	ec6e                	sd	s11,24(sp)
 864:	0005c483          	lbu	s1,0(a1)
 868:	18048c63          	beqz	s1,a00 <vprintf+0x1b8>
 86c:	8a2a                	mv	s4,a0
 86e:	8ab2                	mv	s5,a2
 870:	00158413          	addi	s0,a1,1
 874:	4901                	li	s2,0
 876:	02500993          	li	s3,37
 87a:	06400b93          	li	s7,100
 87e:	06c00c13          	li	s8,108
 882:	07800c93          	li	s9,120
 886:	07000d13          	li	s10,112
 88a:	07300d93          	li	s11,115
 88e:	00000b17          	auipc	s6,0x0
 892:	582b0b13          	addi	s6,s6,1410 # e10 <digits>
 896:	a839                	j	8b4 <vprintf+0x6c>
 898:	85a6                	mv	a1,s1
 89a:	8552                	mv	a0,s4
 89c:	00000097          	auipc	ra,0x0
 8a0:	ef4080e7          	jalr	-268(ra) # 790 <putc>
 8a4:	a019                	j	8aa <vprintf+0x62>
 8a6:	01390f63          	beq	s2,s3,8c4 <vprintf+0x7c>
 8aa:	0405                	addi	s0,s0,1
 8ac:	fff44483          	lbu	s1,-1(s0)
 8b0:	14048863          	beqz	s1,a00 <vprintf+0x1b8>
 8b4:	0004879b          	sext.w	a5,s1
 8b8:	fe0917e3          	bnez	s2,8a6 <vprintf+0x5e>
 8bc:	fd379ee3          	bne	a5,s3,898 <vprintf+0x50>
 8c0:	893e                	mv	s2,a5
 8c2:	b7e5                	j	8aa <vprintf+0x62>
 8c4:	03778e63          	beq	a5,s7,900 <vprintf+0xb8>
 8c8:	05878a63          	beq	a5,s8,91c <vprintf+0xd4>
 8cc:	07978663          	beq	a5,s9,938 <vprintf+0xf0>
 8d0:	09a78263          	beq	a5,s10,954 <vprintf+0x10c>
 8d4:	0db78363          	beq	a5,s11,99a <vprintf+0x152>
 8d8:	06300713          	li	a4,99
 8dc:	0ee78b63          	beq	a5,a4,9d2 <vprintf+0x18a>
 8e0:	11378563          	beq	a5,s3,9ea <vprintf+0x1a2>
 8e4:	85ce                	mv	a1,s3
 8e6:	8552                	mv	a0,s4
 8e8:	00000097          	auipc	ra,0x0
 8ec:	ea8080e7          	jalr	-344(ra) # 790 <putc>
 8f0:	85a6                	mv	a1,s1
 8f2:	8552                	mv	a0,s4
 8f4:	00000097          	auipc	ra,0x0
 8f8:	e9c080e7          	jalr	-356(ra) # 790 <putc>
 8fc:	4901                	li	s2,0
 8fe:	b775                	j	8aa <vprintf+0x62>
 900:	008a8493          	addi	s1,s5,8
 904:	4685                	li	a3,1
 906:	4629                	li	a2,10
 908:	000aa583          	lw	a1,0(s5)
 90c:	8552                	mv	a0,s4
 90e:	00000097          	auipc	ra,0x0
 912:	e9e080e7          	jalr	-354(ra) # 7ac <printint>
 916:	8aa6                	mv	s5,s1
 918:	4901                	li	s2,0
 91a:	bf41                	j	8aa <vprintf+0x62>
 91c:	008a8493          	addi	s1,s5,8
 920:	4681                	li	a3,0
 922:	4629                	li	a2,10
 924:	000aa583          	lw	a1,0(s5)
 928:	8552                	mv	a0,s4
 92a:	00000097          	auipc	ra,0x0
 92e:	e82080e7          	jalr	-382(ra) # 7ac <printint>
 932:	8aa6                	mv	s5,s1
 934:	4901                	li	s2,0
 936:	bf95                	j	8aa <vprintf+0x62>
 938:	008a8493          	addi	s1,s5,8
 93c:	4681                	li	a3,0
 93e:	4641                	li	a2,16
 940:	000aa583          	lw	a1,0(s5)
 944:	8552                	mv	a0,s4
 946:	00000097          	auipc	ra,0x0
 94a:	e66080e7          	jalr	-410(ra) # 7ac <printint>
 94e:	8aa6                	mv	s5,s1
 950:	4901                	li	s2,0
 952:	bfa1                	j	8aa <vprintf+0x62>
 954:	008a8793          	addi	a5,s5,8
 958:	e43e                	sd	a5,8(sp)
 95a:	000ab903          	ld	s2,0(s5)
 95e:	03000593          	li	a1,48
 962:	8552                	mv	a0,s4
 964:	00000097          	auipc	ra,0x0
 968:	e2c080e7          	jalr	-468(ra) # 790 <putc>
 96c:	85e6                	mv	a1,s9
 96e:	8552                	mv	a0,s4
 970:	00000097          	auipc	ra,0x0
 974:	e20080e7          	jalr	-480(ra) # 790 <putc>
 978:	44c1                	li	s1,16
 97a:	03c95793          	srli	a5,s2,0x3c
 97e:	97da                	add	a5,a5,s6
 980:	0007c583          	lbu	a1,0(a5)
 984:	8552                	mv	a0,s4
 986:	00000097          	auipc	ra,0x0
 98a:	e0a080e7          	jalr	-502(ra) # 790 <putc>
 98e:	0912                	slli	s2,s2,0x4
 990:	34fd                	addiw	s1,s1,-1
 992:	f4e5                	bnez	s1,97a <vprintf+0x132>
 994:	6aa2                	ld	s5,8(sp)
 996:	4901                	li	s2,0
 998:	bf09                	j	8aa <vprintf+0x62>
 99a:	008a8493          	addi	s1,s5,8
 99e:	000ab903          	ld	s2,0(s5)
 9a2:	02090163          	beqz	s2,9c4 <vprintf+0x17c>
 9a6:	00094583          	lbu	a1,0(s2)
 9aa:	c9a1                	beqz	a1,9fa <vprintf+0x1b2>
 9ac:	8552                	mv	a0,s4
 9ae:	00000097          	auipc	ra,0x0
 9b2:	de2080e7          	jalr	-542(ra) # 790 <putc>
 9b6:	0905                	addi	s2,s2,1
 9b8:	00094583          	lbu	a1,0(s2)
 9bc:	f9e5                	bnez	a1,9ac <vprintf+0x164>
 9be:	8aa6                	mv	s5,s1
 9c0:	4901                	li	s2,0
 9c2:	b5e5                	j	8aa <vprintf+0x62>
 9c4:	00000917          	auipc	s2,0x0
 9c8:	44490913          	addi	s2,s2,1092 # e08 <malloc+0x322>
 9cc:	02800593          	li	a1,40
 9d0:	bff1                	j	9ac <vprintf+0x164>
 9d2:	008a8493          	addi	s1,s5,8
 9d6:	000ac583          	lbu	a1,0(s5)
 9da:	8552                	mv	a0,s4
 9dc:	00000097          	auipc	ra,0x0
 9e0:	db4080e7          	jalr	-588(ra) # 790 <putc>
 9e4:	8aa6                	mv	s5,s1
 9e6:	4901                	li	s2,0
 9e8:	b5c9                	j	8aa <vprintf+0x62>
 9ea:	85ce                	mv	a1,s3
 9ec:	8552                	mv	a0,s4
 9ee:	00000097          	auipc	ra,0x0
 9f2:	da2080e7          	jalr	-606(ra) # 790 <putc>
 9f6:	4901                	li	s2,0
 9f8:	bd4d                	j	8aa <vprintf+0x62>
 9fa:	8aa6                	mv	s5,s1
 9fc:	4901                	li	s2,0
 9fe:	b575                	j	8aa <vprintf+0x62>
 a00:	70e6                	ld	ra,120(sp)
 a02:	7446                	ld	s0,112(sp)
 a04:	74a6                	ld	s1,104(sp)
 a06:	7906                	ld	s2,96(sp)
 a08:	69e6                	ld	s3,88(sp)
 a0a:	6a46                	ld	s4,80(sp)
 a0c:	6aa6                	ld	s5,72(sp)
 a0e:	6b06                	ld	s6,64(sp)
 a10:	7be2                	ld	s7,56(sp)
 a12:	7c42                	ld	s8,48(sp)
 a14:	7ca2                	ld	s9,40(sp)
 a16:	7d02                	ld	s10,32(sp)
 a18:	6de2                	ld	s11,24(sp)
 a1a:	6109                	addi	sp,sp,128
 a1c:	8082                	ret

0000000000000a1e <fprintf>:
 a1e:	715d                	addi	sp,sp,-80
 a20:	ec06                	sd	ra,24(sp)
 a22:	f032                	sd	a2,32(sp)
 a24:	f436                	sd	a3,40(sp)
 a26:	f83a                	sd	a4,48(sp)
 a28:	fc3e                	sd	a5,56(sp)
 a2a:	e0c2                	sd	a6,64(sp)
 a2c:	e4c6                	sd	a7,72(sp)
 a2e:	1010                	addi	a2,sp,32
 a30:	e432                	sd	a2,8(sp)
 a32:	00000097          	auipc	ra,0x0
 a36:	e16080e7          	jalr	-490(ra) # 848 <vprintf>
 a3a:	60e2                	ld	ra,24(sp)
 a3c:	6161                	addi	sp,sp,80
 a3e:	8082                	ret

0000000000000a40 <printf>:
 a40:	711d                	addi	sp,sp,-96
 a42:	ec06                	sd	ra,24(sp)
 a44:	f42e                	sd	a1,40(sp)
 a46:	f832                	sd	a2,48(sp)
 a48:	fc36                	sd	a3,56(sp)
 a4a:	e0ba                	sd	a4,64(sp)
 a4c:	e4be                	sd	a5,72(sp)
 a4e:	e8c2                	sd	a6,80(sp)
 a50:	ecc6                	sd	a7,88(sp)
 a52:	1030                	addi	a2,sp,40
 a54:	e432                	sd	a2,8(sp)
 a56:	85aa                	mv	a1,a0
 a58:	4505                	li	a0,1
 a5a:	00000097          	auipc	ra,0x0
 a5e:	dee080e7          	jalr	-530(ra) # 848 <vprintf>
 a62:	60e2                	ld	ra,24(sp)
 a64:	6125                	addi	sp,sp,96
 a66:	8082                	ret

0000000000000a68 <free>:
 a68:	ff050693          	addi	a3,a0,-16
 a6c:	00000797          	auipc	a5,0x0
 a70:	3bc7b783          	ld	a5,956(a5) # e28 <freep>
 a74:	a805                	j	aa4 <free+0x3c>
 a76:	4618                	lw	a4,8(a2)
 a78:	9db9                	addw	a1,a1,a4
 a7a:	feb52c23          	sw	a1,-8(a0)
 a7e:	6398                	ld	a4,0(a5)
 a80:	6318                	ld	a4,0(a4)
 a82:	fee53823          	sd	a4,-16(a0)
 a86:	a091                	j	aca <free+0x62>
 a88:	ff852703          	lw	a4,-8(a0)
 a8c:	9e39                	addw	a2,a2,a4
 a8e:	c790                	sw	a2,8(a5)
 a90:	ff053703          	ld	a4,-16(a0)
 a94:	e398                	sd	a4,0(a5)
 a96:	a099                	j	adc <free+0x74>
 a98:	6398                	ld	a4,0(a5)
 a9a:	00e7e463          	bltu	a5,a4,aa2 <free+0x3a>
 a9e:	00e6ea63          	bltu	a3,a4,ab2 <free+0x4a>
 aa2:	87ba                	mv	a5,a4
 aa4:	fed7fae3          	bgeu	a5,a3,a98 <free+0x30>
 aa8:	6398                	ld	a4,0(a5)
 aaa:	00e6e463          	bltu	a3,a4,ab2 <free+0x4a>
 aae:	fee7eae3          	bltu	a5,a4,aa2 <free+0x3a>
 ab2:	ff852583          	lw	a1,-8(a0)
 ab6:	6390                	ld	a2,0(a5)
 ab8:	02059713          	slli	a4,a1,0x20
 abc:	9301                	srli	a4,a4,0x20
 abe:	0712                	slli	a4,a4,0x4
 ac0:	9736                	add	a4,a4,a3
 ac2:	fae60ae3          	beq	a2,a4,a76 <free+0xe>
 ac6:	fec53823          	sd	a2,-16(a0)
 aca:	4790                	lw	a2,8(a5)
 acc:	02061713          	slli	a4,a2,0x20
 ad0:	9301                	srli	a4,a4,0x20
 ad2:	0712                	slli	a4,a4,0x4
 ad4:	973e                	add	a4,a4,a5
 ad6:	fae689e3          	beq	a3,a4,a88 <free+0x20>
 ada:	e394                	sd	a3,0(a5)
 adc:	00000717          	auipc	a4,0x0
 ae0:	34f73623          	sd	a5,844(a4) # e28 <freep>
 ae4:	8082                	ret

0000000000000ae6 <malloc>:
 ae6:	7139                	addi	sp,sp,-64
 ae8:	fc06                	sd	ra,56(sp)
 aea:	f822                	sd	s0,48(sp)
 aec:	f426                	sd	s1,40(sp)
 aee:	f04a                	sd	s2,32(sp)
 af0:	ec4e                	sd	s3,24(sp)
 af2:	e852                	sd	s4,16(sp)
 af4:	e456                	sd	s5,8(sp)
 af6:	02051413          	slli	s0,a0,0x20
 afa:	9001                	srli	s0,s0,0x20
 afc:	043d                	addi	s0,s0,15
 afe:	8011                	srli	s0,s0,0x4
 b00:	0014091b          	addiw	s2,s0,1
 b04:	0405                	addi	s0,s0,1
 b06:	00000517          	auipc	a0,0x0
 b0a:	32253503          	ld	a0,802(a0) # e28 <freep>
 b0e:	c905                	beqz	a0,b3e <malloc+0x58>
 b10:	611c                	ld	a5,0(a0)
 b12:	4798                	lw	a4,8(a5)
 b14:	04877163          	bgeu	a4,s0,b56 <malloc+0x70>
 b18:	89ca                	mv	s3,s2
 b1a:	0009071b          	sext.w	a4,s2
 b1e:	6685                	lui	a3,0x1
 b20:	00d77363          	bgeu	a4,a3,b26 <malloc+0x40>
 b24:	6985                	lui	s3,0x1
 b26:	00098a1b          	sext.w	s4,s3
 b2a:	1982                	slli	s3,s3,0x20
 b2c:	0209d993          	srli	s3,s3,0x20
 b30:	0992                	slli	s3,s3,0x4
 b32:	00000497          	auipc	s1,0x0
 b36:	2f648493          	addi	s1,s1,758 # e28 <freep>
 b3a:	5afd                	li	s5,-1
 b3c:	a0bd                	j	baa <malloc+0xc4>
 b3e:	00000797          	auipc	a5,0x0
 b42:	2f278793          	addi	a5,a5,754 # e30 <base>
 b46:	00000717          	auipc	a4,0x0
 b4a:	2ef73123          	sd	a5,738(a4) # e28 <freep>
 b4e:	e39c                	sd	a5,0(a5)
 b50:	0007a423          	sw	zero,8(a5)
 b54:	b7d1                	j	b18 <malloc+0x32>
 b56:	02e40a63          	beq	s0,a4,b8a <malloc+0xa4>
 b5a:	4127073b          	subw	a4,a4,s2
 b5e:	c798                	sw	a4,8(a5)
 b60:	1702                	slli	a4,a4,0x20
 b62:	9301                	srli	a4,a4,0x20
 b64:	0712                	slli	a4,a4,0x4
 b66:	97ba                	add	a5,a5,a4
 b68:	0127a423          	sw	s2,8(a5)
 b6c:	00000717          	auipc	a4,0x0
 b70:	2aa73e23          	sd	a0,700(a4) # e28 <freep>
 b74:	01078513          	addi	a0,a5,16
 b78:	70e2                	ld	ra,56(sp)
 b7a:	7442                	ld	s0,48(sp)
 b7c:	74a2                	ld	s1,40(sp)
 b7e:	7902                	ld	s2,32(sp)
 b80:	69e2                	ld	s3,24(sp)
 b82:	6a42                	ld	s4,16(sp)
 b84:	6aa2                	ld	s5,8(sp)
 b86:	6121                	addi	sp,sp,64
 b88:	8082                	ret
 b8a:	6398                	ld	a4,0(a5)
 b8c:	e118                	sd	a4,0(a0)
 b8e:	bff9                	j	b6c <malloc+0x86>
 b90:	01452423          	sw	s4,8(a0)
 b94:	0541                	addi	a0,a0,16
 b96:	00000097          	auipc	ra,0x0
 b9a:	ed2080e7          	jalr	-302(ra) # a68 <free>
 b9e:	6088                	ld	a0,0(s1)
 ba0:	dd61                	beqz	a0,b78 <malloc+0x92>
 ba2:	611c                	ld	a5,0(a0)
 ba4:	4798                	lw	a4,8(a5)
 ba6:	fa8778e3          	bgeu	a4,s0,b56 <malloc+0x70>
 baa:	6098                	ld	a4,0(s1)
 bac:	853e                	mv	a0,a5
 bae:	fef71ae3          	bne	a4,a5,ba2 <malloc+0xbc>
 bb2:	854e                	mv	a0,s3
 bb4:	00000097          	auipc	ra,0x0
 bb8:	8d8080e7          	jalr	-1832(ra) # 48c <sbrk>
 bbc:	fd551ae3          	bne	a0,s5,b90 <malloc+0xaa>
 bc0:	4501                	li	a0,0
 bc2:	bf5d                	j	b78 <malloc+0x92>
