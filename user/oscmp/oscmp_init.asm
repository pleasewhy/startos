
_oscmp_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_success>:
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	842a                	mv	s0,a0
   a:	00001517          	auipc	a0,0x1
   e:	c3650513          	addi	a0,a0,-970 # c40 <malloc+0x13c>
  12:	00001097          	auipc	ra,0x1
  16:	a4c080e7          	jalr	-1460(ra) # a5e <printf>
  1a:	600c                	ld	a1,0(s0)
  1c:	cd99                	beqz	a1,3a <print_success+0x3a>
  1e:	0421                	addi	s0,s0,8
  20:	00001497          	auipc	s1,0x1
  24:	c3848493          	addi	s1,s1,-968 # c58 <malloc+0x154>
  28:	8526                	mv	a0,s1
  2a:	00001097          	auipc	ra,0x1
  2e:	a34080e7          	jalr	-1484(ra) # a5e <printf>
  32:	0421                	addi	s0,s0,8
  34:	ff843583          	ld	a1,-8(s0)
  38:	f9e5                	bnez	a1,28 <print_success+0x28>
  3a:	00001517          	auipc	a0,0x1
  3e:	c2650513          	addi	a0,a0,-986 # c60 <malloc+0x15c>
  42:	00001097          	auipc	ra,0x1
  46:	a1c080e7          	jalr	-1508(ra) # a5e <printf>
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
  64:	432080e7          	jalr	1074(ra) # 492 <fork>
  68:	ed09                	bnez	a0,82 <test+0x2e>
  6a:	4601                	li	a2,0
  6c:	85a2                	mv	a1,s0
  6e:	8526                	mv	a0,s1
  70:	00000097          	auipc	ra,0x0
  74:	54a080e7          	jalr	1354(ra) # 5ba <execve>
  78:	70a2                	ld	ra,40(sp)
  7a:	7402                	ld	s0,32(sp)
  7c:	64e2                	ld	s1,24(sp)
  7e:	6145                	addi	sp,sp,48
  80:	8082                	ret
  82:	0068                	addi	a0,sp,12
  84:	00000097          	auipc	ra,0x0
  88:	416080e7          	jalr	1046(ra) # 49a <wait>
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
  b0:	bc450513          	addi	a0,a0,-1084 # c70 <malloc+0x16c>
  b4:	00000097          	auipc	ra,0x0
  b8:	3ee080e7          	jalr	1006(ra) # 4a2 <open>
  bc:	4501                	li	a0,0
  be:	00000097          	auipc	ra,0x0
  c2:	3fc080e7          	jalr	1020(ra) # 4ba <dup>
  c6:	4501                	li	a0,0
  c8:	00000097          	auipc	ra,0x0
  cc:	3f2080e7          	jalr	1010(ra) # 4ba <dup>
  d0:	00001717          	auipc	a4,0x1
  d4:	ba870713          	addi	a4,a4,-1112 # c78 <malloc+0x174>
  d8:	22e13c23          	sd	a4,568(sp)
  dc:	00001797          	auipc	a5,0x1
  e0:	ba478793          	addi	a5,a5,-1116 # c80 <malloc+0x17c>
  e4:	24f13023          	sd	a5,576(sp)
  e8:	24013423          	sd	zero,584(sp)
  ec:	00001797          	auipc	a5,0x1
  f0:	cac78793          	addi	a5,a5,-852 # d98 <malloc+0x294>
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
 126:	b7e68693          	addi	a3,a3,-1154 # ca0 <malloc+0x19c>
 12a:	f3b6                	sd	a3,480(sp)
 12c:	00001697          	auipc	a3,0x1
 130:	b8468693          	addi	a3,a3,-1148 # cb0 <malloc+0x1ac>
 134:	f7b6                	sd	a3,488(sp)
 136:	fb82                	sd	zero,496(sp)
 138:	00001617          	auipc	a2,0x1
 13c:	b8860613          	addi	a2,a2,-1144 # cc0 <malloc+0x1bc>
 140:	ebb2                	sd	a2,464(sp)
 142:	ef82                	sd	zero,472(sp)
 144:	00001617          	auipc	a2,0x1
 148:	b8460613          	addi	a2,a2,-1148 # cc8 <malloc+0x1c4>
 14c:	e3b2                	sd	a2,448(sp)
 14e:	e782                	sd	zero,456(sp)
 150:	00001617          	auipc	a2,0x1
 154:	b8060613          	addi	a2,a2,-1152 # cd0 <malloc+0x1cc>
 158:	fb32                	sd	a2,432(sp)
 15a:	ff02                	sd	zero,440(sp)
 15c:	00001617          	auipc	a2,0x1
 160:	b7c60613          	addi	a2,a2,-1156 # cd8 <malloc+0x1d4>
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
 184:	b6068693          	addi	a3,a3,-1184 # ce0 <malloc+0x1dc>
 188:	f2b6                	sd	a3,352(sp)
 18a:	f682                	sd	zero,360(sp)
 18c:	00001697          	auipc	a3,0x1
 190:	b5c68693          	addi	a3,a3,-1188 # ce8 <malloc+0x1e4>
 194:	eab6                	sd	a3,336(sp)
 196:	ee82                	sd	zero,344(sp)
 198:	00001697          	auipc	a3,0x1
 19c:	b5868693          	addi	a3,a3,-1192 # cf0 <malloc+0x1ec>
 1a0:	fe36                	sd	a3,312(sp)
 1a2:	00001697          	auipc	a3,0x1
 1a6:	b5668693          	addi	a3,a3,-1194 # cf8 <malloc+0x1f4>
 1aa:	e2b6                	sd	a3,320(sp)
 1ac:	e682                	sd	zero,328(sp)
 1ae:	00001617          	auipc	a2,0x1
 1b2:	b5260613          	addi	a2,a2,-1198 # d00 <malloc+0x1fc>
 1b6:	f632                	sd	a2,296(sp)
 1b8:	fa02                	sd	zero,304(sp)
 1ba:	00001617          	auipc	a2,0x1
 1be:	b4e60613          	addi	a2,a2,-1202 # d08 <malloc+0x204>
 1c2:	ee32                	sd	a2,280(sp)
 1c4:	f202                	sd	zero,288(sp)
 1c6:	00001617          	auipc	a2,0x1
 1ca:	b4a60613          	addi	a2,a2,-1206 # d10 <malloc+0x20c>
 1ce:	e632                	sd	a2,264(sp)
 1d0:	ea02                	sd	zero,272(sp)
 1d2:	00001617          	auipc	a2,0x1
 1d6:	b4660613          	addi	a2,a2,-1210 # d18 <malloc+0x214>
 1da:	fdb2                	sd	a2,248(sp)
 1dc:	e202                	sd	zero,256(sp)
 1de:	00001617          	auipc	a2,0x1
 1e2:	b4260613          	addi	a2,a2,-1214 # d20 <malloc+0x21c>
 1e6:	f1b2                	sd	a2,224(sp)
 1e8:	00001617          	auipc	a2,0x1
 1ec:	b4060613          	addi	a2,a2,-1216 # d28 <malloc+0x224>
 1f0:	f5b2                	sd	a2,232(sp)
 1f2:	f982                	sd	zero,240(sp)
 1f4:	e9b6                	sd	a3,208(sp)
 1f6:	ed82                	sd	zero,216(sp)
 1f8:	00001697          	auipc	a3,0x1
 1fc:	b3868693          	addi	a3,a3,-1224 # d30 <malloc+0x22c>
 200:	e1b6                	sd	a3,192(sp)
 202:	e582                	sd	zero,200(sp)
 204:	f53a                	sd	a4,168(sp)
 206:	00001717          	auipc	a4,0x1
 20a:	b3270713          	addi	a4,a4,-1230 # d38 <malloc+0x234>
 20e:	f93a                	sd	a4,176(sp)
 210:	fd02                	sd	zero,184(sp)
 212:	00001717          	auipc	a4,0x1
 216:	b4670713          	addi	a4,a4,-1210 # d58 <malloc+0x254>
 21a:	e93a                	sd	a4,144(sp)
 21c:	00001417          	auipc	s0,0x1
 220:	a1440413          	addi	s0,s0,-1516 # c30 <malloc+0x12c>
 224:	ed22                	sd	s0,152(sp)
 226:	f102                	sd	zero,160(sp)
 228:	00001717          	auipc	a4,0x1
 22c:	b3870713          	addi	a4,a4,-1224 # d60 <malloc+0x25c>
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
 24e:	b1e78793          	addi	a5,a5,-1250 # d68 <malloc+0x264>
 252:	fc3e                	sd	a5,56(sp)
 254:	e0a2                	sd	s0,64(sp)
 256:	e482                	sd	zero,72(sp)
 258:	00001797          	auipc	a5,0x1
 25c:	b1878793          	addi	a5,a5,-1256 # d70 <malloc+0x26c>
 260:	f03e                	sd	a5,32(sp)
 262:	f422                	sd	s0,40(sp)
 264:	f802                	sd	zero,48(sp)
 266:	00001797          	auipc	a5,0x1
 26a:	b1278793          	addi	a5,a5,-1262 # d78 <malloc+0x274>
 26e:	e43e                	sd	a5,8(sp)
 270:	e822                	sd	s0,16(sp)
 272:	ec02                	sd	zero,24(sp)
 274:	1c2c                	addi	a1,sp,568
 276:	00001517          	auipc	a0,0x1
 27a:	b0a50513          	addi	a0,a0,-1270 # d80 <malloc+0x27c>
 27e:	00000097          	auipc	ra,0x0
 282:	dd6080e7          	jalr	-554(ra) # 54 <test>
 286:	0c2c                	addi	a1,sp,536
 288:	00001517          	auipc	a0,0x1
 28c:	af850513          	addi	a0,a0,-1288 # d80 <malloc+0x27c>
 290:	00000097          	auipc	ra,0x0
 294:	dc4080e7          	jalr	-572(ra) # 54 <test>
 298:	1bac                	addi	a1,sp,504
 29a:	00001517          	auipc	a0,0x1
 29e:	ae650513          	addi	a0,a0,-1306 # d80 <malloc+0x27c>
 2a2:	00000097          	auipc	ra,0x0
 2a6:	db2080e7          	jalr	-590(ra) # 54 <test>
 2aa:	138c                	addi	a1,sp,480
 2ac:	00001517          	auipc	a0,0x1
 2b0:	ad450513          	addi	a0,a0,-1324 # d80 <malloc+0x27c>
 2b4:	00000097          	auipc	ra,0x0
 2b8:	da0080e7          	jalr	-608(ra) # 54 <test>
 2bc:	0b8c                	addi	a1,sp,464
 2be:	00001517          	auipc	a0,0x1
 2c2:	ac250513          	addi	a0,a0,-1342 # d80 <malloc+0x27c>
 2c6:	00000097          	auipc	ra,0x0
 2ca:	d8e080e7          	jalr	-626(ra) # 54 <test>
 2ce:	038c                	addi	a1,sp,448
 2d0:	00001517          	auipc	a0,0x1
 2d4:	ab050513          	addi	a0,a0,-1360 # d80 <malloc+0x27c>
 2d8:	00000097          	auipc	ra,0x0
 2dc:	d7c080e7          	jalr	-644(ra) # 54 <test>
 2e0:	1b0c                	addi	a1,sp,432
 2e2:	00001517          	auipc	a0,0x1
 2e6:	a9e50513          	addi	a0,a0,-1378 # d80 <malloc+0x27c>
 2ea:	00000097          	auipc	ra,0x0
 2ee:	d6a080e7          	jalr	-662(ra) # 54 <test>
 2f2:	0b2c                	addi	a1,sp,408
 2f4:	00001517          	auipc	a0,0x1
 2f8:	a8c50513          	addi	a0,a0,-1396 # d80 <malloc+0x27c>
 2fc:	00000097          	auipc	ra,0x0
 300:	d58080e7          	jalr	-680(ra) # 54 <test>
 304:	1a8c                	addi	a1,sp,368
 306:	00001517          	auipc	a0,0x1
 30a:	a7a50513          	addi	a0,a0,-1414 # d80 <malloc+0x27c>
 30e:	00000097          	auipc	ra,0x0
 312:	d46080e7          	jalr	-698(ra) # 54 <test>
 316:	128c                	addi	a1,sp,352
 318:	00001517          	auipc	a0,0x1
 31c:	a6850513          	addi	a0,a0,-1432 # d80 <malloc+0x27c>
 320:	00000097          	auipc	ra,0x0
 324:	d34080e7          	jalr	-716(ra) # 54 <test>
 328:	0a8c                	addi	a1,sp,336
 32a:	00001517          	auipc	a0,0x1
 32e:	a5650513          	addi	a0,a0,-1450 # d80 <malloc+0x27c>
 332:	00000097          	auipc	ra,0x0
 336:	d22080e7          	jalr	-734(ra) # 54 <test>
 33a:	1a2c                	addi	a1,sp,312
 33c:	00001517          	auipc	a0,0x1
 340:	a4450513          	addi	a0,a0,-1468 # d80 <malloc+0x27c>
 344:	00000097          	auipc	ra,0x0
 348:	d10080e7          	jalr	-752(ra) # 54 <test>
 34c:	122c                	addi	a1,sp,296
 34e:	00001517          	auipc	a0,0x1
 352:	a3250513          	addi	a0,a0,-1486 # d80 <malloc+0x27c>
 356:	00000097          	auipc	ra,0x0
 35a:	cfe080e7          	jalr	-770(ra) # 54 <test>
 35e:	0a2c                	addi	a1,sp,280
 360:	00001517          	auipc	a0,0x1
 364:	a2050513          	addi	a0,a0,-1504 # d80 <malloc+0x27c>
 368:	00000097          	auipc	ra,0x0
 36c:	cec080e7          	jalr	-788(ra) # 54 <test>
 370:	022c                	addi	a1,sp,264
 372:	00001517          	auipc	a0,0x1
 376:	a0e50513          	addi	a0,a0,-1522 # d80 <malloc+0x27c>
 37a:	00000097          	auipc	ra,0x0
 37e:	cda080e7          	jalr	-806(ra) # 54 <test>
 382:	118c                	addi	a1,sp,224
 384:	00001517          	auipc	a0,0x1
 388:	9fc50513          	addi	a0,a0,-1540 # d80 <malloc+0x27c>
 38c:	00000097          	auipc	ra,0x0
 390:	cc8080e7          	jalr	-824(ra) # 54 <test>
 394:	098c                	addi	a1,sp,208
 396:	00001517          	auipc	a0,0x1
 39a:	9ea50513          	addi	a0,a0,-1558 # d80 <malloc+0x27c>
 39e:	00000097          	auipc	ra,0x0
 3a2:	cb6080e7          	jalr	-842(ra) # 54 <test>
 3a6:	018c                	addi	a1,sp,192
 3a8:	00001517          	auipc	a0,0x1
 3ac:	9d850513          	addi	a0,a0,-1576 # d80 <malloc+0x27c>
 3b0:	00000097          	auipc	ra,0x0
 3b4:	ca4080e7          	jalr	-860(ra) # 54 <test>
 3b8:	19ac                	addi	a1,sp,248
 3ba:	00001517          	auipc	a0,0x1
 3be:	9c650513          	addi	a0,a0,-1594 # d80 <malloc+0x27c>
 3c2:	00000097          	auipc	ra,0x0
 3c6:	c92080e7          	jalr	-878(ra) # 54 <test>
 3ca:	112c                	addi	a1,sp,168
 3cc:	00001517          	auipc	a0,0x1
 3d0:	9b450513          	addi	a0,a0,-1612 # d80 <malloc+0x27c>
 3d4:	00000097          	auipc	ra,0x0
 3d8:	c80080e7          	jalr	-896(ra) # 54 <test>
 3dc:	090c                	addi	a1,sp,144
 3de:	00001517          	auipc	a0,0x1
 3e2:	9a250513          	addi	a0,a0,-1630 # d80 <malloc+0x27c>
 3e6:	00000097          	auipc	ra,0x0
 3ea:	c6e080e7          	jalr	-914(ra) # 54 <test>
 3ee:	4589                	li	a1,2
 3f0:	8522                	mv	a0,s0
 3f2:	00000097          	auipc	ra,0x0
 3f6:	0b0080e7          	jalr	176(ra) # 4a2 <open>
 3fa:	842a                	mv	s0,a0
 3fc:	08054163          	bltz	a0,47e <main+0x3e0>
 400:	4635                	li	a2,13
 402:	00001597          	auipc	a1,0x1
 406:	98658593          	addi	a1,a1,-1658 # d88 <malloc+0x284>
 40a:	8522                	mv	a0,s0
 40c:	00000097          	auipc	ra,0x0
 410:	12c080e7          	jalr	300(ra) # 538 <write>
 414:	06054a63          	bltz	a0,488 <main+0x3ea>
 418:	8522                	mv	a0,s0
 41a:	00000097          	auipc	ra,0x0
 41e:	0f6080e7          	jalr	246(ra) # 510 <close>
 422:	18ac                	addi	a1,sp,120
 424:	00001517          	auipc	a0,0x1
 428:	95c50513          	addi	a0,a0,-1700 # d80 <malloc+0x27c>
 42c:	00000097          	auipc	ra,0x0
 430:	c28080e7          	jalr	-984(ra) # 54 <test>
 434:	088c                	addi	a1,sp,80
 436:	00001517          	auipc	a0,0x1
 43a:	94a50513          	addi	a0,a0,-1718 # d80 <malloc+0x27c>
 43e:	00000097          	auipc	ra,0x0
 442:	c16080e7          	jalr	-1002(ra) # 54 <test>
 446:	182c                	addi	a1,sp,56
 448:	00001517          	auipc	a0,0x1
 44c:	93850513          	addi	a0,a0,-1736 # d80 <malloc+0x27c>
 450:	00000097          	auipc	ra,0x0
 454:	c04080e7          	jalr	-1020(ra) # 54 <test>
 458:	100c                	addi	a1,sp,32
 45a:	00001517          	auipc	a0,0x1
 45e:	92650513          	addi	a0,a0,-1754 # d80 <malloc+0x27c>
 462:	00000097          	auipc	ra,0x0
 466:	bf2080e7          	jalr	-1038(ra) # 54 <test>
 46a:	002c                	addi	a1,sp,8
 46c:	00001517          	auipc	a0,0x1
 470:	91450513          	addi	a0,a0,-1772 # d80 <malloc+0x27c>
 474:	00000097          	auipc	ra,0x0
 478:	be0080e7          	jalr	-1056(ra) # 54 <test>
 47c:	a001                	j	47c <main+0x3de>
 47e:	00000097          	auipc	ra,0x0
 482:	15a080e7          	jalr	346(ra) # 5d8 <kernel_panic>
 486:	bfad                	j	400 <main+0x362>
 488:	00000097          	auipc	ra,0x0
 48c:	150080e7          	jalr	336(ra) # 5d8 <kernel_panic>
 490:	b761                	j	418 <main+0x37a>

0000000000000492 <fork>:
 492:	4885                	li	a7,1
 494:	00000073          	ecall
 498:	8082                	ret

000000000000049a <wait>:
 49a:	488d                	li	a7,3
 49c:	00000073          	ecall
 4a0:	8082                	ret

00000000000004a2 <open>:
 4a2:	4889                	li	a7,2
 4a4:	00000073          	ecall
 4a8:	8082                	ret

00000000000004aa <sbrk>:
 4aa:	4891                	li	a7,4
 4ac:	00000073          	ecall
 4b0:	8082                	ret

00000000000004b2 <getcwd>:
 4b2:	48c5                	li	a7,17
 4b4:	00000073          	ecall
 4b8:	8082                	ret

00000000000004ba <dup>:
 4ba:	48dd                	li	a7,23
 4bc:	00000073          	ecall
 4c0:	8082                	ret

00000000000004c2 <dup3>:
 4c2:	48e1                	li	a7,24
 4c4:	00000073          	ecall
 4c8:	8082                	ret

00000000000004ca <mkdirat>:
 4ca:	02200893          	li	a7,34
 4ce:	00000073          	ecall
 4d2:	8082                	ret

00000000000004d4 <unlinkat>:
 4d4:	02300893          	li	a7,35
 4d8:	00000073          	ecall
 4dc:	8082                	ret

00000000000004de <linkat>:
 4de:	02500893          	li	a7,37
 4e2:	00000073          	ecall
 4e6:	8082                	ret

00000000000004e8 <umount2>:
 4e8:	02700893          	li	a7,39
 4ec:	00000073          	ecall
 4f0:	8082                	ret

00000000000004f2 <mount>:
 4f2:	02800893          	li	a7,40
 4f6:	00000073          	ecall
 4fa:	8082                	ret

00000000000004fc <chdir>:
 4fc:	03100893          	li	a7,49
 500:	00000073          	ecall
 504:	8082                	ret

0000000000000506 <openat>:
 506:	03800893          	li	a7,56
 50a:	00000073          	ecall
 50e:	8082                	ret

0000000000000510 <close>:
 510:	03900893          	li	a7,57
 514:	00000073          	ecall
 518:	8082                	ret

000000000000051a <pipe2>:
 51a:	03b00893          	li	a7,59
 51e:	00000073          	ecall
 522:	8082                	ret

0000000000000524 <getdents64>:
 524:	03d00893          	li	a7,61
 528:	00000073          	ecall
 52c:	8082                	ret

000000000000052e <read>:
 52e:	03f00893          	li	a7,63
 532:	00000073          	ecall
 536:	8082                	ret

0000000000000538 <write>:
 538:	04000893          	li	a7,64
 53c:	00000073          	ecall
 540:	8082                	ret

0000000000000542 <fstat>:
 542:	05000893          	li	a7,80
 546:	00000073          	ecall
 54a:	8082                	ret

000000000000054c <exit>:
 54c:	05d00893          	li	a7,93
 550:	00000073          	ecall
 554:	8082                	ret

0000000000000556 <nanosleep>:
 556:	06500893          	li	a7,101
 55a:	00000073          	ecall
 55e:	8082                	ret

0000000000000560 <sched_yield>:
 560:	07c00893          	li	a7,124
 564:	00000073          	ecall
 568:	8082                	ret

000000000000056a <times>:
 56a:	09900893          	li	a7,153
 56e:	00000073          	ecall
 572:	8082                	ret

0000000000000574 <uname>:
 574:	0a000893          	li	a7,160
 578:	00000073          	ecall
 57c:	8082                	ret

000000000000057e <gettimeofday>:
 57e:	0a900893          	li	a7,169
 582:	00000073          	ecall
 586:	8082                	ret

0000000000000588 <brk>:
 588:	0d600893          	li	a7,214
 58c:	00000073          	ecall
 590:	8082                	ret

0000000000000592 <munmap>:
 592:	0d700893          	li	a7,215
 596:	00000073          	ecall
 59a:	8082                	ret

000000000000059c <getpid>:
 59c:	0ac00893          	li	a7,172
 5a0:	00000073          	ecall
 5a4:	8082                	ret

00000000000005a6 <getppid>:
 5a6:	0ad00893          	li	a7,173
 5aa:	00000073          	ecall
 5ae:	8082                	ret

00000000000005b0 <clone>:
 5b0:	0dc00893          	li	a7,220
 5b4:	00000073          	ecall
 5b8:	8082                	ret

00000000000005ba <execve>:
 5ba:	0dd00893          	li	a7,221
 5be:	00000073          	ecall
 5c2:	8082                	ret

00000000000005c4 <mmap>:
 5c4:	0de00893          	li	a7,222
 5c8:	00000073          	ecall
 5cc:	8082                	ret

00000000000005ce <wait4>:
 5ce:	10400893          	li	a7,260
 5d2:	00000073          	ecall
 5d6:	8082                	ret

00000000000005d8 <kernel_panic>:
 5d8:	18f00893          	li	a7,399
 5dc:	00000073          	ecall
 5e0:	8082                	ret

00000000000005e2 <strcpy>:
 5e2:	87aa                	mv	a5,a0
 5e4:	0585                	addi	a1,a1,1
 5e6:	0785                	addi	a5,a5,1
 5e8:	fff5c703          	lbu	a4,-1(a1)
 5ec:	fee78fa3          	sb	a4,-1(a5)
 5f0:	fb75                	bnez	a4,5e4 <strcpy+0x2>
 5f2:	8082                	ret

00000000000005f4 <strcmp>:
 5f4:	00054783          	lbu	a5,0(a0)
 5f8:	cb91                	beqz	a5,60c <strcmp+0x18>
 5fa:	0005c703          	lbu	a4,0(a1)
 5fe:	00f71763          	bne	a4,a5,60c <strcmp+0x18>
 602:	0505                	addi	a0,a0,1
 604:	0585                	addi	a1,a1,1
 606:	00054783          	lbu	a5,0(a0)
 60a:	fbe5                	bnez	a5,5fa <strcmp+0x6>
 60c:	0005c503          	lbu	a0,0(a1)
 610:	40a7853b          	subw	a0,a5,a0
 614:	8082                	ret

0000000000000616 <strlen>:
 616:	00054783          	lbu	a5,0(a0)
 61a:	cf81                	beqz	a5,632 <strlen+0x1c>
 61c:	0505                	addi	a0,a0,1
 61e:	87aa                	mv	a5,a0
 620:	4685                	li	a3,1
 622:	9e89                	subw	a3,a3,a0
 624:	00f6853b          	addw	a0,a3,a5
 628:	0785                	addi	a5,a5,1
 62a:	fff7c703          	lbu	a4,-1(a5)
 62e:	fb7d                	bnez	a4,624 <strlen+0xe>
 630:	8082                	ret
 632:	4501                	li	a0,0
 634:	8082                	ret

0000000000000636 <memset>:
 636:	ce09                	beqz	a2,650 <memset+0x1a>
 638:	87aa                	mv	a5,a0
 63a:	fff6071b          	addiw	a4,a2,-1
 63e:	1702                	slli	a4,a4,0x20
 640:	9301                	srli	a4,a4,0x20
 642:	0705                	addi	a4,a4,1
 644:	972a                	add	a4,a4,a0
 646:	00b78023          	sb	a1,0(a5)
 64a:	0785                	addi	a5,a5,1
 64c:	fee79de3          	bne	a5,a4,646 <memset+0x10>
 650:	8082                	ret

0000000000000652 <strchr>:
 652:	00054783          	lbu	a5,0(a0)
 656:	cb89                	beqz	a5,668 <strchr+0x16>
 658:	00f58963          	beq	a1,a5,66a <strchr+0x18>
 65c:	0505                	addi	a0,a0,1
 65e:	00054783          	lbu	a5,0(a0)
 662:	fbfd                	bnez	a5,658 <strchr+0x6>
 664:	4501                	li	a0,0
 666:	8082                	ret
 668:	4501                	li	a0,0
 66a:	8082                	ret

000000000000066c <gets>:
 66c:	715d                	addi	sp,sp,-80
 66e:	e486                	sd	ra,72(sp)
 670:	e0a2                	sd	s0,64(sp)
 672:	fc26                	sd	s1,56(sp)
 674:	f84a                	sd	s2,48(sp)
 676:	f44e                	sd	s3,40(sp)
 678:	f052                	sd	s4,32(sp)
 67a:	ec56                	sd	s5,24(sp)
 67c:	e85a                	sd	s6,16(sp)
 67e:	8b2a                	mv	s6,a0
 680:	89ae                	mv	s3,a1
 682:	84aa                	mv	s1,a0
 684:	4401                	li	s0,0
 686:	4a29                	li	s4,10
 688:	4ab5                	li	s5,13
 68a:	8922                	mv	s2,s0
 68c:	2405                	addiw	s0,s0,1
 68e:	03345863          	bge	s0,s3,6be <gets+0x52>
 692:	4605                	li	a2,1
 694:	00f10593          	addi	a1,sp,15
 698:	4501                	li	a0,0
 69a:	00000097          	auipc	ra,0x0
 69e:	e94080e7          	jalr	-364(ra) # 52e <read>
 6a2:	00a05e63          	blez	a0,6be <gets+0x52>
 6a6:	00f14783          	lbu	a5,15(sp)
 6aa:	00f48023          	sb	a5,0(s1)
 6ae:	01478763          	beq	a5,s4,6bc <gets+0x50>
 6b2:	0485                	addi	s1,s1,1
 6b4:	fd579be3          	bne	a5,s5,68a <gets+0x1e>
 6b8:	8922                	mv	s2,s0
 6ba:	a011                	j	6be <gets+0x52>
 6bc:	8922                	mv	s2,s0
 6be:	995a                	add	s2,s2,s6
 6c0:	00090023          	sb	zero,0(s2)
 6c4:	855a                	mv	a0,s6
 6c6:	60a6                	ld	ra,72(sp)
 6c8:	6406                	ld	s0,64(sp)
 6ca:	74e2                	ld	s1,56(sp)
 6cc:	7942                	ld	s2,48(sp)
 6ce:	79a2                	ld	s3,40(sp)
 6d0:	7a02                	ld	s4,32(sp)
 6d2:	6ae2                	ld	s5,24(sp)
 6d4:	6b42                	ld	s6,16(sp)
 6d6:	6161                	addi	sp,sp,80
 6d8:	8082                	ret

00000000000006da <atoi>:
 6da:	86aa                	mv	a3,a0
 6dc:	00054603          	lbu	a2,0(a0)
 6e0:	fd06079b          	addiw	a5,a2,-48
 6e4:	0ff7f793          	andi	a5,a5,255
 6e8:	4725                	li	a4,9
 6ea:	02f76663          	bltu	a4,a5,716 <atoi+0x3c>
 6ee:	4501                	li	a0,0
 6f0:	45a5                	li	a1,9
 6f2:	0685                	addi	a3,a3,1
 6f4:	0025179b          	slliw	a5,a0,0x2
 6f8:	9fa9                	addw	a5,a5,a0
 6fa:	0017979b          	slliw	a5,a5,0x1
 6fe:	9fb1                	addw	a5,a5,a2
 700:	fd07851b          	addiw	a0,a5,-48
 704:	0006c603          	lbu	a2,0(a3)
 708:	fd06071b          	addiw	a4,a2,-48
 70c:	0ff77713          	andi	a4,a4,255
 710:	fee5f1e3          	bgeu	a1,a4,6f2 <atoi+0x18>
 714:	8082                	ret
 716:	4501                	li	a0,0
 718:	8082                	ret

000000000000071a <memmove>:
 71a:	02b57463          	bgeu	a0,a1,742 <memmove+0x28>
 71e:	04c05663          	blez	a2,76a <memmove+0x50>
 722:	fff6079b          	addiw	a5,a2,-1
 726:	1782                	slli	a5,a5,0x20
 728:	9381                	srli	a5,a5,0x20
 72a:	0785                	addi	a5,a5,1
 72c:	97aa                	add	a5,a5,a0
 72e:	872a                	mv	a4,a0
 730:	0585                	addi	a1,a1,1
 732:	0705                	addi	a4,a4,1
 734:	fff5c683          	lbu	a3,-1(a1)
 738:	fed70fa3          	sb	a3,-1(a4)
 73c:	fee79ae3          	bne	a5,a4,730 <memmove+0x16>
 740:	8082                	ret
 742:	00c50733          	add	a4,a0,a2
 746:	95b2                	add	a1,a1,a2
 748:	02c05163          	blez	a2,76a <memmove+0x50>
 74c:	fff6079b          	addiw	a5,a2,-1
 750:	1782                	slli	a5,a5,0x20
 752:	9381                	srli	a5,a5,0x20
 754:	fff7c793          	not	a5,a5
 758:	97ba                	add	a5,a5,a4
 75a:	15fd                	addi	a1,a1,-1
 75c:	177d                	addi	a4,a4,-1
 75e:	0005c683          	lbu	a3,0(a1)
 762:	00d70023          	sb	a3,0(a4)
 766:	fee79ae3          	bne	a5,a4,75a <memmove+0x40>
 76a:	8082                	ret

000000000000076c <memcmp>:
 76c:	fff6069b          	addiw	a3,a2,-1
 770:	c605                	beqz	a2,798 <memcmp+0x2c>
 772:	1682                	slli	a3,a3,0x20
 774:	9281                	srli	a3,a3,0x20
 776:	0685                	addi	a3,a3,1
 778:	96aa                	add	a3,a3,a0
 77a:	00054783          	lbu	a5,0(a0)
 77e:	0005c703          	lbu	a4,0(a1)
 782:	00e79863          	bne	a5,a4,792 <memcmp+0x26>
 786:	0505                	addi	a0,a0,1
 788:	0585                	addi	a1,a1,1
 78a:	fed518e3          	bne	a0,a3,77a <memcmp+0xe>
 78e:	4501                	li	a0,0
 790:	8082                	ret
 792:	40e7853b          	subw	a0,a5,a4
 796:	8082                	ret
 798:	4501                	li	a0,0
 79a:	8082                	ret

000000000000079c <memcpy>:
 79c:	1141                	addi	sp,sp,-16
 79e:	e406                	sd	ra,8(sp)
 7a0:	00000097          	auipc	ra,0x0
 7a4:	f7a080e7          	jalr	-134(ra) # 71a <memmove>
 7a8:	60a2                	ld	ra,8(sp)
 7aa:	0141                	addi	sp,sp,16
 7ac:	8082                	ret

00000000000007ae <putc>:
 7ae:	1101                	addi	sp,sp,-32
 7b0:	ec06                	sd	ra,24(sp)
 7b2:	00b107a3          	sb	a1,15(sp)
 7b6:	4605                	li	a2,1
 7b8:	00f10593          	addi	a1,sp,15
 7bc:	00000097          	auipc	ra,0x0
 7c0:	d7c080e7          	jalr	-644(ra) # 538 <write>
 7c4:	60e2                	ld	ra,24(sp)
 7c6:	6105                	addi	sp,sp,32
 7c8:	8082                	ret

00000000000007ca <printint>:
 7ca:	7179                	addi	sp,sp,-48
 7cc:	f406                	sd	ra,40(sp)
 7ce:	f022                	sd	s0,32(sp)
 7d0:	ec26                	sd	s1,24(sp)
 7d2:	e84a                	sd	s2,16(sp)
 7d4:	84aa                	mv	s1,a0
 7d6:	c299                	beqz	a3,7dc <printint+0x12>
 7d8:	0805c363          	bltz	a1,85e <printint+0x94>
 7dc:	2581                	sext.w	a1,a1
 7de:	4881                	li	a7,0
 7e0:	868a                	mv	a3,sp
 7e2:	4701                	li	a4,0
 7e4:	2601                	sext.w	a2,a2
 7e6:	00000517          	auipc	a0,0x0
 7ea:	64a50513          	addi	a0,a0,1610 # e30 <digits>
 7ee:	883a                	mv	a6,a4
 7f0:	2705                	addiw	a4,a4,1
 7f2:	02c5f7bb          	remuw	a5,a1,a2
 7f6:	1782                	slli	a5,a5,0x20
 7f8:	9381                	srli	a5,a5,0x20
 7fa:	97aa                	add	a5,a5,a0
 7fc:	0007c783          	lbu	a5,0(a5)
 800:	00f68023          	sb	a5,0(a3)
 804:	0005879b          	sext.w	a5,a1
 808:	02c5d5bb          	divuw	a1,a1,a2
 80c:	0685                	addi	a3,a3,1
 80e:	fec7f0e3          	bgeu	a5,a2,7ee <printint+0x24>
 812:	00088a63          	beqz	a7,826 <printint+0x5c>
 816:	081c                	addi	a5,sp,16
 818:	973e                	add	a4,a4,a5
 81a:	02d00793          	li	a5,45
 81e:	fef70823          	sb	a5,-16(a4)
 822:	0028071b          	addiw	a4,a6,2
 826:	02e05663          	blez	a4,852 <printint+0x88>
 82a:	00e10433          	add	s0,sp,a4
 82e:	fff10913          	addi	s2,sp,-1
 832:	993a                	add	s2,s2,a4
 834:	377d                	addiw	a4,a4,-1
 836:	1702                	slli	a4,a4,0x20
 838:	9301                	srli	a4,a4,0x20
 83a:	40e90933          	sub	s2,s2,a4
 83e:	fff44583          	lbu	a1,-1(s0)
 842:	8526                	mv	a0,s1
 844:	00000097          	auipc	ra,0x0
 848:	f6a080e7          	jalr	-150(ra) # 7ae <putc>
 84c:	147d                	addi	s0,s0,-1
 84e:	ff2418e3          	bne	s0,s2,83e <printint+0x74>
 852:	70a2                	ld	ra,40(sp)
 854:	7402                	ld	s0,32(sp)
 856:	64e2                	ld	s1,24(sp)
 858:	6942                	ld	s2,16(sp)
 85a:	6145                	addi	sp,sp,48
 85c:	8082                	ret
 85e:	40b005bb          	negw	a1,a1
 862:	4885                	li	a7,1
 864:	bfb5                	j	7e0 <printint+0x16>

0000000000000866 <vprintf>:
 866:	7119                	addi	sp,sp,-128
 868:	fc86                	sd	ra,120(sp)
 86a:	f8a2                	sd	s0,112(sp)
 86c:	f4a6                	sd	s1,104(sp)
 86e:	f0ca                	sd	s2,96(sp)
 870:	ecce                	sd	s3,88(sp)
 872:	e8d2                	sd	s4,80(sp)
 874:	e4d6                	sd	s5,72(sp)
 876:	e0da                	sd	s6,64(sp)
 878:	fc5e                	sd	s7,56(sp)
 87a:	f862                	sd	s8,48(sp)
 87c:	f466                	sd	s9,40(sp)
 87e:	f06a                	sd	s10,32(sp)
 880:	ec6e                	sd	s11,24(sp)
 882:	0005c483          	lbu	s1,0(a1)
 886:	18048c63          	beqz	s1,a1e <vprintf+0x1b8>
 88a:	8a2a                	mv	s4,a0
 88c:	8ab2                	mv	s5,a2
 88e:	00158413          	addi	s0,a1,1
 892:	4901                	li	s2,0
 894:	02500993          	li	s3,37
 898:	06400b93          	li	s7,100
 89c:	06c00c13          	li	s8,108
 8a0:	07800c93          	li	s9,120
 8a4:	07000d13          	li	s10,112
 8a8:	07300d93          	li	s11,115
 8ac:	00000b17          	auipc	s6,0x0
 8b0:	584b0b13          	addi	s6,s6,1412 # e30 <digits>
 8b4:	a839                	j	8d2 <vprintf+0x6c>
 8b6:	85a6                	mv	a1,s1
 8b8:	8552                	mv	a0,s4
 8ba:	00000097          	auipc	ra,0x0
 8be:	ef4080e7          	jalr	-268(ra) # 7ae <putc>
 8c2:	a019                	j	8c8 <vprintf+0x62>
 8c4:	01390f63          	beq	s2,s3,8e2 <vprintf+0x7c>
 8c8:	0405                	addi	s0,s0,1
 8ca:	fff44483          	lbu	s1,-1(s0)
 8ce:	14048863          	beqz	s1,a1e <vprintf+0x1b8>
 8d2:	0004879b          	sext.w	a5,s1
 8d6:	fe0917e3          	bnez	s2,8c4 <vprintf+0x5e>
 8da:	fd379ee3          	bne	a5,s3,8b6 <vprintf+0x50>
 8de:	893e                	mv	s2,a5
 8e0:	b7e5                	j	8c8 <vprintf+0x62>
 8e2:	03778e63          	beq	a5,s7,91e <vprintf+0xb8>
 8e6:	05878a63          	beq	a5,s8,93a <vprintf+0xd4>
 8ea:	07978663          	beq	a5,s9,956 <vprintf+0xf0>
 8ee:	09a78263          	beq	a5,s10,972 <vprintf+0x10c>
 8f2:	0db78363          	beq	a5,s11,9b8 <vprintf+0x152>
 8f6:	06300713          	li	a4,99
 8fa:	0ee78b63          	beq	a5,a4,9f0 <vprintf+0x18a>
 8fe:	11378563          	beq	a5,s3,a08 <vprintf+0x1a2>
 902:	85ce                	mv	a1,s3
 904:	8552                	mv	a0,s4
 906:	00000097          	auipc	ra,0x0
 90a:	ea8080e7          	jalr	-344(ra) # 7ae <putc>
 90e:	85a6                	mv	a1,s1
 910:	8552                	mv	a0,s4
 912:	00000097          	auipc	ra,0x0
 916:	e9c080e7          	jalr	-356(ra) # 7ae <putc>
 91a:	4901                	li	s2,0
 91c:	b775                	j	8c8 <vprintf+0x62>
 91e:	008a8493          	addi	s1,s5,8
 922:	4685                	li	a3,1
 924:	4629                	li	a2,10
 926:	000aa583          	lw	a1,0(s5)
 92a:	8552                	mv	a0,s4
 92c:	00000097          	auipc	ra,0x0
 930:	e9e080e7          	jalr	-354(ra) # 7ca <printint>
 934:	8aa6                	mv	s5,s1
 936:	4901                	li	s2,0
 938:	bf41                	j	8c8 <vprintf+0x62>
 93a:	008a8493          	addi	s1,s5,8
 93e:	4681                	li	a3,0
 940:	4629                	li	a2,10
 942:	000aa583          	lw	a1,0(s5)
 946:	8552                	mv	a0,s4
 948:	00000097          	auipc	ra,0x0
 94c:	e82080e7          	jalr	-382(ra) # 7ca <printint>
 950:	8aa6                	mv	s5,s1
 952:	4901                	li	s2,0
 954:	bf95                	j	8c8 <vprintf+0x62>
 956:	008a8493          	addi	s1,s5,8
 95a:	4681                	li	a3,0
 95c:	4641                	li	a2,16
 95e:	000aa583          	lw	a1,0(s5)
 962:	8552                	mv	a0,s4
 964:	00000097          	auipc	ra,0x0
 968:	e66080e7          	jalr	-410(ra) # 7ca <printint>
 96c:	8aa6                	mv	s5,s1
 96e:	4901                	li	s2,0
 970:	bfa1                	j	8c8 <vprintf+0x62>
 972:	008a8793          	addi	a5,s5,8
 976:	e43e                	sd	a5,8(sp)
 978:	000ab903          	ld	s2,0(s5)
 97c:	03000593          	li	a1,48
 980:	8552                	mv	a0,s4
 982:	00000097          	auipc	ra,0x0
 986:	e2c080e7          	jalr	-468(ra) # 7ae <putc>
 98a:	85e6                	mv	a1,s9
 98c:	8552                	mv	a0,s4
 98e:	00000097          	auipc	ra,0x0
 992:	e20080e7          	jalr	-480(ra) # 7ae <putc>
 996:	44c1                	li	s1,16
 998:	03c95793          	srli	a5,s2,0x3c
 99c:	97da                	add	a5,a5,s6
 99e:	0007c583          	lbu	a1,0(a5)
 9a2:	8552                	mv	a0,s4
 9a4:	00000097          	auipc	ra,0x0
 9a8:	e0a080e7          	jalr	-502(ra) # 7ae <putc>
 9ac:	0912                	slli	s2,s2,0x4
 9ae:	34fd                	addiw	s1,s1,-1
 9b0:	f4e5                	bnez	s1,998 <vprintf+0x132>
 9b2:	6aa2                	ld	s5,8(sp)
 9b4:	4901                	li	s2,0
 9b6:	bf09                	j	8c8 <vprintf+0x62>
 9b8:	008a8493          	addi	s1,s5,8
 9bc:	000ab903          	ld	s2,0(s5)
 9c0:	02090163          	beqz	s2,9e2 <vprintf+0x17c>
 9c4:	00094583          	lbu	a1,0(s2)
 9c8:	c9a1                	beqz	a1,a18 <vprintf+0x1b2>
 9ca:	8552                	mv	a0,s4
 9cc:	00000097          	auipc	ra,0x0
 9d0:	de2080e7          	jalr	-542(ra) # 7ae <putc>
 9d4:	0905                	addi	s2,s2,1
 9d6:	00094583          	lbu	a1,0(s2)
 9da:	f9e5                	bnez	a1,9ca <vprintf+0x164>
 9dc:	8aa6                	mv	s5,s1
 9de:	4901                	li	s2,0
 9e0:	b5e5                	j	8c8 <vprintf+0x62>
 9e2:	00000917          	auipc	s2,0x0
 9e6:	44690913          	addi	s2,s2,1094 # e28 <malloc+0x324>
 9ea:	02800593          	li	a1,40
 9ee:	bff1                	j	9ca <vprintf+0x164>
 9f0:	008a8493          	addi	s1,s5,8
 9f4:	000ac583          	lbu	a1,0(s5)
 9f8:	8552                	mv	a0,s4
 9fa:	00000097          	auipc	ra,0x0
 9fe:	db4080e7          	jalr	-588(ra) # 7ae <putc>
 a02:	8aa6                	mv	s5,s1
 a04:	4901                	li	s2,0
 a06:	b5c9                	j	8c8 <vprintf+0x62>
 a08:	85ce                	mv	a1,s3
 a0a:	8552                	mv	a0,s4
 a0c:	00000097          	auipc	ra,0x0
 a10:	da2080e7          	jalr	-606(ra) # 7ae <putc>
 a14:	4901                	li	s2,0
 a16:	bd4d                	j	8c8 <vprintf+0x62>
 a18:	8aa6                	mv	s5,s1
 a1a:	4901                	li	s2,0
 a1c:	b575                	j	8c8 <vprintf+0x62>
 a1e:	70e6                	ld	ra,120(sp)
 a20:	7446                	ld	s0,112(sp)
 a22:	74a6                	ld	s1,104(sp)
 a24:	7906                	ld	s2,96(sp)
 a26:	69e6                	ld	s3,88(sp)
 a28:	6a46                	ld	s4,80(sp)
 a2a:	6aa6                	ld	s5,72(sp)
 a2c:	6b06                	ld	s6,64(sp)
 a2e:	7be2                	ld	s7,56(sp)
 a30:	7c42                	ld	s8,48(sp)
 a32:	7ca2                	ld	s9,40(sp)
 a34:	7d02                	ld	s10,32(sp)
 a36:	6de2                	ld	s11,24(sp)
 a38:	6109                	addi	sp,sp,128
 a3a:	8082                	ret

0000000000000a3c <fprintf>:
 a3c:	715d                	addi	sp,sp,-80
 a3e:	ec06                	sd	ra,24(sp)
 a40:	f032                	sd	a2,32(sp)
 a42:	f436                	sd	a3,40(sp)
 a44:	f83a                	sd	a4,48(sp)
 a46:	fc3e                	sd	a5,56(sp)
 a48:	e0c2                	sd	a6,64(sp)
 a4a:	e4c6                	sd	a7,72(sp)
 a4c:	1010                	addi	a2,sp,32
 a4e:	e432                	sd	a2,8(sp)
 a50:	00000097          	auipc	ra,0x0
 a54:	e16080e7          	jalr	-490(ra) # 866 <vprintf>
 a58:	60e2                	ld	ra,24(sp)
 a5a:	6161                	addi	sp,sp,80
 a5c:	8082                	ret

0000000000000a5e <printf>:
 a5e:	711d                	addi	sp,sp,-96
 a60:	ec06                	sd	ra,24(sp)
 a62:	f42e                	sd	a1,40(sp)
 a64:	f832                	sd	a2,48(sp)
 a66:	fc36                	sd	a3,56(sp)
 a68:	e0ba                	sd	a4,64(sp)
 a6a:	e4be                	sd	a5,72(sp)
 a6c:	e8c2                	sd	a6,80(sp)
 a6e:	ecc6                	sd	a7,88(sp)
 a70:	1030                	addi	a2,sp,40
 a72:	e432                	sd	a2,8(sp)
 a74:	85aa                	mv	a1,a0
 a76:	4505                	li	a0,1
 a78:	00000097          	auipc	ra,0x0
 a7c:	dee080e7          	jalr	-530(ra) # 866 <vprintf>
 a80:	60e2                	ld	ra,24(sp)
 a82:	6125                	addi	sp,sp,96
 a84:	8082                	ret

0000000000000a86 <free>:
 a86:	ff050693          	addi	a3,a0,-16
 a8a:	00000797          	auipc	a5,0x0
 a8e:	3be7b783          	ld	a5,958(a5) # e48 <freep>
 a92:	a805                	j	ac2 <free+0x3c>
 a94:	4618                	lw	a4,8(a2)
 a96:	9db9                	addw	a1,a1,a4
 a98:	feb52c23          	sw	a1,-8(a0)
 a9c:	6398                	ld	a4,0(a5)
 a9e:	6318                	ld	a4,0(a4)
 aa0:	fee53823          	sd	a4,-16(a0)
 aa4:	a091                	j	ae8 <free+0x62>
 aa6:	ff852703          	lw	a4,-8(a0)
 aaa:	9e39                	addw	a2,a2,a4
 aac:	c790                	sw	a2,8(a5)
 aae:	ff053703          	ld	a4,-16(a0)
 ab2:	e398                	sd	a4,0(a5)
 ab4:	a099                	j	afa <free+0x74>
 ab6:	6398                	ld	a4,0(a5)
 ab8:	00e7e463          	bltu	a5,a4,ac0 <free+0x3a>
 abc:	00e6ea63          	bltu	a3,a4,ad0 <free+0x4a>
 ac0:	87ba                	mv	a5,a4
 ac2:	fed7fae3          	bgeu	a5,a3,ab6 <free+0x30>
 ac6:	6398                	ld	a4,0(a5)
 ac8:	00e6e463          	bltu	a3,a4,ad0 <free+0x4a>
 acc:	fee7eae3          	bltu	a5,a4,ac0 <free+0x3a>
 ad0:	ff852583          	lw	a1,-8(a0)
 ad4:	6390                	ld	a2,0(a5)
 ad6:	02059713          	slli	a4,a1,0x20
 ada:	9301                	srli	a4,a4,0x20
 adc:	0712                	slli	a4,a4,0x4
 ade:	9736                	add	a4,a4,a3
 ae0:	fae60ae3          	beq	a2,a4,a94 <free+0xe>
 ae4:	fec53823          	sd	a2,-16(a0)
 ae8:	4790                	lw	a2,8(a5)
 aea:	02061713          	slli	a4,a2,0x20
 aee:	9301                	srli	a4,a4,0x20
 af0:	0712                	slli	a4,a4,0x4
 af2:	973e                	add	a4,a4,a5
 af4:	fae689e3          	beq	a3,a4,aa6 <free+0x20>
 af8:	e394                	sd	a3,0(a5)
 afa:	00000717          	auipc	a4,0x0
 afe:	34f73723          	sd	a5,846(a4) # e48 <freep>
 b02:	8082                	ret

0000000000000b04 <malloc>:
 b04:	7139                	addi	sp,sp,-64
 b06:	fc06                	sd	ra,56(sp)
 b08:	f822                	sd	s0,48(sp)
 b0a:	f426                	sd	s1,40(sp)
 b0c:	f04a                	sd	s2,32(sp)
 b0e:	ec4e                	sd	s3,24(sp)
 b10:	e852                	sd	s4,16(sp)
 b12:	e456                	sd	s5,8(sp)
 b14:	02051413          	slli	s0,a0,0x20
 b18:	9001                	srli	s0,s0,0x20
 b1a:	043d                	addi	s0,s0,15
 b1c:	8011                	srli	s0,s0,0x4
 b1e:	0014091b          	addiw	s2,s0,1
 b22:	0405                	addi	s0,s0,1
 b24:	00000517          	auipc	a0,0x0
 b28:	32453503          	ld	a0,804(a0) # e48 <freep>
 b2c:	c905                	beqz	a0,b5c <malloc+0x58>
 b2e:	611c                	ld	a5,0(a0)
 b30:	4798                	lw	a4,8(a5)
 b32:	04877163          	bgeu	a4,s0,b74 <malloc+0x70>
 b36:	89ca                	mv	s3,s2
 b38:	0009071b          	sext.w	a4,s2
 b3c:	6685                	lui	a3,0x1
 b3e:	00d77363          	bgeu	a4,a3,b44 <malloc+0x40>
 b42:	6985                	lui	s3,0x1
 b44:	00098a1b          	sext.w	s4,s3
 b48:	1982                	slli	s3,s3,0x20
 b4a:	0209d993          	srli	s3,s3,0x20
 b4e:	0992                	slli	s3,s3,0x4
 b50:	00000497          	auipc	s1,0x0
 b54:	2f848493          	addi	s1,s1,760 # e48 <freep>
 b58:	5afd                	li	s5,-1
 b5a:	a0bd                	j	bc8 <malloc+0xc4>
 b5c:	00000797          	auipc	a5,0x0
 b60:	2f478793          	addi	a5,a5,756 # e50 <base>
 b64:	00000717          	auipc	a4,0x0
 b68:	2ef73223          	sd	a5,740(a4) # e48 <freep>
 b6c:	e39c                	sd	a5,0(a5)
 b6e:	0007a423          	sw	zero,8(a5)
 b72:	b7d1                	j	b36 <malloc+0x32>
 b74:	02e40a63          	beq	s0,a4,ba8 <malloc+0xa4>
 b78:	4127073b          	subw	a4,a4,s2
 b7c:	c798                	sw	a4,8(a5)
 b7e:	1702                	slli	a4,a4,0x20
 b80:	9301                	srli	a4,a4,0x20
 b82:	0712                	slli	a4,a4,0x4
 b84:	97ba                	add	a5,a5,a4
 b86:	0127a423          	sw	s2,8(a5)
 b8a:	00000717          	auipc	a4,0x0
 b8e:	2aa73f23          	sd	a0,702(a4) # e48 <freep>
 b92:	01078513          	addi	a0,a5,16
 b96:	70e2                	ld	ra,56(sp)
 b98:	7442                	ld	s0,48(sp)
 b9a:	74a2                	ld	s1,40(sp)
 b9c:	7902                	ld	s2,32(sp)
 b9e:	69e2                	ld	s3,24(sp)
 ba0:	6a42                	ld	s4,16(sp)
 ba2:	6aa2                	ld	s5,8(sp)
 ba4:	6121                	addi	sp,sp,64
 ba6:	8082                	ret
 ba8:	6398                	ld	a4,0(a5)
 baa:	e118                	sd	a4,0(a0)
 bac:	bff9                	j	b8a <malloc+0x86>
 bae:	01452423          	sw	s4,8(a0)
 bb2:	0541                	addi	a0,a0,16
 bb4:	00000097          	auipc	ra,0x0
 bb8:	ed2080e7          	jalr	-302(ra) # a86 <free>
 bbc:	6088                	ld	a0,0(s1)
 bbe:	dd61                	beqz	a0,b96 <malloc+0x92>
 bc0:	611c                	ld	a5,0(a0)
 bc2:	4798                	lw	a4,8(a5)
 bc4:	fa8778e3          	bgeu	a4,s0,b74 <malloc+0x70>
 bc8:	6098                	ld	a4,0(s1)
 bca:	853e                	mv	a0,a5
 bcc:	fef71ae3          	bne	a4,a5,bc0 <malloc+0xbc>
 bd0:	854e                	mv	a0,s3
 bd2:	00000097          	auipc	ra,0x0
 bd6:	8d8080e7          	jalr	-1832(ra) # 4aa <sbrk>
 bda:	fd551ae3          	bne	a0,s5,bae <malloc+0xaa>
 bde:	4501                	li	a0,0
 be0:	bf5d                	j	b96 <malloc+0x92>
