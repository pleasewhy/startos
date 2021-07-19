
_oscmp_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_success>:
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	842a                	mv	s0,a0
   a:	00001517          	auipc	a0,0x1
   e:	d7650513          	addi	a0,a0,-650 # d80 <malloc+0x164>
  12:	00001097          	auipc	ra,0x1
  16:	b64080e7          	jalr	-1180(ra) # b76 <printf>
  1a:	600c                	ld	a1,0(s0)
  1c:	cd99                	beqz	a1,3a <print_success+0x3a>
  1e:	0421                	addi	s0,s0,8
  20:	00001497          	auipc	s1,0x1
  24:	d7848493          	addi	s1,s1,-648 # d98 <malloc+0x17c>
  28:	8526                	mv	a0,s1
  2a:	00001097          	auipc	ra,0x1
  2e:	b4c080e7          	jalr	-1204(ra) # b76 <printf>
  32:	0421                	addi	s0,s0,8
  34:	ff843583          	ld	a1,-8(s0)
  38:	f9e5                	bnez	a1,28 <print_success+0x28>
  3a:	00001517          	auipc	a0,0x1
  3e:	d6650513          	addi	a0,a0,-666 # da0 <malloc+0x184>
  42:	00001097          	auipc	ra,0x1
  46:	b34080e7          	jalr	-1228(ra) # b76 <printf>
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
  64:	54a080e7          	jalr	1354(ra) # 5aa <fork>
  68:	ed09                	bnez	a0,82 <test+0x2e>
  6a:	4601                	li	a2,0
  6c:	85a2                	mv	a1,s0
  6e:	8526                	mv	a0,s1
  70:	00000097          	auipc	ra,0x0
  74:	662080e7          	jalr	1634(ra) # 6d2 <execve>
  78:	70a2                	ld	ra,40(sp)
  7a:	7402                	ld	s0,32(sp)
  7c:	64e2                	ld	s1,24(sp)
  7e:	6145                	addi	sp,sp,48
  80:	8082                	ret
  82:	0068                	addi	a0,sp,12
  84:	00000097          	auipc	ra,0x0
  88:	52e080e7          	jalr	1326(ra) # 5b2 <wait>
  8c:	47b2                	lw	a5,12(sp)
  8e:	fe07c5e3          	bltz	a5,78 <test+0x24>
  92:	8522                	mv	a0,s0
  94:	00000097          	auipc	ra,0x0
  98:	f6c080e7          	jalr	-148(ra) # 0 <print_success>
  9c:	bff1                	j	78 <test+0x24>

000000000000009e <main>:
  9e:	ce010113          	addi	sp,sp,-800
  a2:	30113c23          	sd	ra,792(sp)
  a6:	30813823          	sd	s0,784(sp)
  aa:	4589                	li	a1,2
  ac:	00001517          	auipc	a0,0x1
  b0:	d0450513          	addi	a0,a0,-764 # db0 <malloc+0x194>
  b4:	00000097          	auipc	ra,0x0
  b8:	506080e7          	jalr	1286(ra) # 5ba <open>
  bc:	4501                	li	a0,0
  be:	00000097          	auipc	ra,0x0
  c2:	514080e7          	jalr	1300(ra) # 5d2 <dup>
  c6:	4501                	li	a0,0
  c8:	00000097          	auipc	ra,0x0
  cc:	50a080e7          	jalr	1290(ra) # 5d2 <dup>
  d0:	00001717          	auipc	a4,0x1
  d4:	ce870713          	addi	a4,a4,-792 # db8 <malloc+0x19c>
  d8:	2ee13c23          	sd	a4,760(sp)
  dc:	00001797          	auipc	a5,0x1
  e0:	ce478793          	addi	a5,a5,-796 # dc0 <malloc+0x1a4>
  e4:	30f13023          	sd	a5,768(sp)
  e8:	30013423          	sd	zero,776(sp)
  ec:	00001797          	auipc	a5,0x1
  f0:	e1478793          	addi	a5,a5,-492 # f00 <malloc+0x2e4>
  f4:	6388                	ld	a0,0(a5)
  f6:	678c                	ld	a1,8(a5)
  f8:	6b90                	ld	a2,16(a5)
  fa:	6f94                	ld	a3,24(a5)
  fc:	2ca13c23          	sd	a0,728(sp)
 100:	2eb13023          	sd	a1,736(sp)
 104:	2ec13423          	sd	a2,744(sp)
 108:	2ed13823          	sd	a3,752(sp)
 10c:	7388                	ld	a0,32(a5)
 10e:	778c                	ld	a1,40(a5)
 110:	7b90                	ld	a2,48(a5)
 112:	7f94                	ld	a3,56(a5)
 114:	2aa13c23          	sd	a0,696(sp)
 118:	2cb13023          	sd	a1,704(sp)
 11c:	2cc13423          	sd	a2,712(sp)
 120:	2cd13823          	sd	a3,720(sp)
 124:	00001697          	auipc	a3,0x1
 128:	cbc68693          	addi	a3,a3,-836 # de0 <malloc+0x1c4>
 12c:	2ad13023          	sd	a3,672(sp)
 130:	00001697          	auipc	a3,0x1
 134:	cc068693          	addi	a3,a3,-832 # df0 <malloc+0x1d4>
 138:	2ad13423          	sd	a3,680(sp)
 13c:	2a013823          	sd	zero,688(sp)
 140:	00001617          	auipc	a2,0x1
 144:	cc060613          	addi	a2,a2,-832 # e00 <malloc+0x1e4>
 148:	28c13823          	sd	a2,656(sp)
 14c:	28013c23          	sd	zero,664(sp)
 150:	00001617          	auipc	a2,0x1
 154:	cb860613          	addi	a2,a2,-840 # e08 <malloc+0x1ec>
 158:	28c13023          	sd	a2,640(sp)
 15c:	28013423          	sd	zero,648(sp)
 160:	00001617          	auipc	a2,0x1
 164:	cb060613          	addi	a2,a2,-848 # e10 <malloc+0x1f4>
 168:	26c13823          	sd	a2,624(sp)
 16c:	26013c23          	sd	zero,632(sp)
 170:	00001617          	auipc	a2,0x1
 174:	ca860613          	addi	a2,a2,-856 # e18 <malloc+0x1fc>
 178:	24c13c23          	sd	a2,600(sp)
 17c:	26d13023          	sd	a3,608(sp)
 180:	26013423          	sd	zero,616(sp)
 184:	0407b803          	ld	a6,64(a5)
 188:	67a8                	ld	a0,72(a5)
 18a:	6bac                	ld	a1,80(a5)
 18c:	6fb0                	ld	a2,88(a5)
 18e:	73b4                	ld	a3,96(a5)
 190:	23013823          	sd	a6,560(sp)
 194:	22a13c23          	sd	a0,568(sp)
 198:	24b13023          	sd	a1,576(sp)
 19c:	24c13423          	sd	a2,584(sp)
 1a0:	24d13823          	sd	a3,592(sp)
 1a4:	00001697          	auipc	a3,0x1
 1a8:	c7c68693          	addi	a3,a3,-900 # e20 <malloc+0x204>
 1ac:	22d13023          	sd	a3,544(sp)
 1b0:	22013423          	sd	zero,552(sp)
 1b4:	00001697          	auipc	a3,0x1
 1b8:	c7468693          	addi	a3,a3,-908 # e28 <malloc+0x20c>
 1bc:	20d13823          	sd	a3,528(sp)
 1c0:	20013c23          	sd	zero,536(sp)
 1c4:	00001697          	auipc	a3,0x1
 1c8:	c6c68693          	addi	a3,a3,-916 # e30 <malloc+0x214>
 1cc:	ffb6                	sd	a3,504(sp)
 1ce:	00001697          	auipc	a3,0x1
 1d2:	c6a68693          	addi	a3,a3,-918 # e38 <malloc+0x21c>
 1d6:	20d13023          	sd	a3,512(sp)
 1da:	20013423          	sd	zero,520(sp)
 1de:	00001617          	auipc	a2,0x1
 1e2:	c6260613          	addi	a2,a2,-926 # e40 <malloc+0x224>
 1e6:	f7b2                	sd	a2,488(sp)
 1e8:	fb82                	sd	zero,496(sp)
 1ea:	00001617          	auipc	a2,0x1
 1ee:	c5e60613          	addi	a2,a2,-930 # e48 <malloc+0x22c>
 1f2:	efb2                	sd	a2,472(sp)
 1f4:	f382                	sd	zero,480(sp)
 1f6:	00001617          	auipc	a2,0x1
 1fa:	c5a60613          	addi	a2,a2,-934 # e50 <malloc+0x234>
 1fe:	e7b2                	sd	a2,456(sp)
 200:	eb82                	sd	zero,464(sp)
 202:	00001617          	auipc	a2,0x1
 206:	c5660613          	addi	a2,a2,-938 # e58 <malloc+0x23c>
 20a:	ff32                	sd	a2,440(sp)
 20c:	e382                	sd	zero,448(sp)
 20e:	00001617          	auipc	a2,0x1
 212:	c5260613          	addi	a2,a2,-942 # e60 <malloc+0x244>
 216:	f332                	sd	a2,416(sp)
 218:	00001617          	auipc	a2,0x1
 21c:	c5060613          	addi	a2,a2,-944 # e68 <malloc+0x24c>
 220:	f732                	sd	a2,424(sp)
 222:	fb02                	sd	zero,432(sp)
 224:	eb36                	sd	a3,400(sp)
 226:	ef02                	sd	zero,408(sp)
 228:	00001697          	auipc	a3,0x1
 22c:	c4868693          	addi	a3,a3,-952 # e70 <malloc+0x254>
 230:	e336                	sd	a3,384(sp)
 232:	e702                	sd	zero,392(sp)
 234:	f6ba                	sd	a4,360(sp)
 236:	00001717          	auipc	a4,0x1
 23a:	c4270713          	addi	a4,a4,-958 # e78 <malloc+0x25c>
 23e:	faba                	sd	a4,368(sp)
 240:	fe82                	sd	zero,376(sp)
 242:	00001717          	auipc	a4,0x1
 246:	c5670713          	addi	a4,a4,-938 # e98 <malloc+0x27c>
 24a:	eaba                	sd	a4,336(sp)
 24c:	00001417          	auipc	s0,0x1
 250:	afc40413          	addi	s0,s0,-1284 # d48 <malloc+0x12c>
 254:	eea2                	sd	s0,344(sp)
 256:	f282                	sd	zero,352(sp)
 258:	00001717          	auipc	a4,0x1
 25c:	c4870713          	addi	a4,a4,-952 # ea0 <malloc+0x284>
 260:	fe3a                	sd	a4,312(sp)
 262:	e2a2                	sd	s0,320(sp)
 264:	e682                	sd	zero,328(sp)
 266:	77a8                	ld	a0,104(a5)
 268:	7bac                	ld	a1,112(a5)
 26a:	7fb0                	ld	a2,120(a5)
 26c:	63d4                	ld	a3,128(a5)
 26e:	67d8                	ld	a4,136(a5)
 270:	ea2a                	sd	a0,272(sp)
 272:	ee2e                	sd	a1,280(sp)
 274:	f232                	sd	a2,288(sp)
 276:	f636                	sd	a3,296(sp)
 278:	fa3a                	sd	a4,304(sp)
 27a:	00001717          	auipc	a4,0x1
 27e:	c2e70713          	addi	a4,a4,-978 # ea8 <malloc+0x28c>
 282:	fdba                	sd	a4,248(sp)
 284:	e222                	sd	s0,256(sp)
 286:	e602                	sd	zero,264(sp)
 288:	00001717          	auipc	a4,0x1
 28c:	c2870713          	addi	a4,a4,-984 # eb0 <malloc+0x294>
 290:	f1ba                	sd	a4,224(sp)
 292:	f5a2                	sd	s0,232(sp)
 294:	f982                	sd	zero,240(sp)
 296:	00001717          	auipc	a4,0x1
 29a:	c2270713          	addi	a4,a4,-990 # eb8 <malloc+0x29c>
 29e:	e5ba                	sd	a4,200(sp)
 2a0:	e9a2                	sd	s0,208(sp)
 2a2:	ed82                	sd	zero,216(sp)
 2a4:	6bcc                	ld	a1,144(a5)
 2a6:	6fd0                	ld	a2,152(a5)
 2a8:	73d4                	ld	a3,160(a5)
 2aa:	77d8                	ld	a4,168(a5)
 2ac:	f52e                	sd	a1,168(sp)
 2ae:	f932                	sd	a2,176(sp)
 2b0:	fd36                	sd	a3,184(sp)
 2b2:	e1ba                	sd	a4,192(sp)
 2b4:	00001717          	auipc	a4,0x1
 2b8:	c0c70713          	addi	a4,a4,-1012 # ec0 <malloc+0x2a4>
 2bc:	e93a                	sd	a4,144(sp)
 2be:	ed22                	sd	s0,152(sp)
 2c0:	f102                	sd	zero,160(sp)
 2c2:	00001717          	auipc	a4,0x1
 2c6:	c0670713          	addi	a4,a4,-1018 # ec8 <malloc+0x2ac>
 2ca:	fcba                	sd	a4,120(sp)
 2cc:	e122                	sd	s0,128(sp)
 2ce:	e502                	sd	zero,136(sp)
 2d0:	00001717          	auipc	a4,0x1
 2d4:	c0070713          	addi	a4,a4,-1024 # ed0 <malloc+0x2b4>
 2d8:	f0ba                	sd	a4,96(sp)
 2da:	f4a2                	sd	s0,104(sp)
 2dc:	f882                	sd	zero,112(sp)
 2de:	00001717          	auipc	a4,0x1
 2e2:	bfa70713          	addi	a4,a4,-1030 # ed8 <malloc+0x2bc>
 2e6:	e4ba                	sd	a4,72(sp)
 2e8:	e8a2                	sd	s0,80(sp)
 2ea:	ec82                	sd	zero,88(sp)
 2ec:	7bcc                	ld	a1,176(a5)
 2ee:	7fd0                	ld	a2,184(a5)
 2f0:	63f4                	ld	a3,192(a5)
 2f2:	67f8                	ld	a4,200(a5)
 2f4:	6bfc                	ld	a5,208(a5)
 2f6:	f02e                	sd	a1,32(sp)
 2f8:	f432                	sd	a2,40(sp)
 2fa:	f836                	sd	a3,48(sp)
 2fc:	fc3a                	sd	a4,56(sp)
 2fe:	e0be                	sd	a5,64(sp)
 300:	00001797          	auipc	a5,0x1
 304:	be078793          	addi	a5,a5,-1056 # ee0 <malloc+0x2c4>
 308:	e43e                	sd	a5,8(sp)
 30a:	e822                	sd	s0,16(sp)
 30c:	ec02                	sd	zero,24(sp)
 30e:	1dac                	addi	a1,sp,760
 310:	00001517          	auipc	a0,0x1
 314:	bd850513          	addi	a0,a0,-1064 # ee8 <malloc+0x2cc>
 318:	00000097          	auipc	ra,0x0
 31c:	d3c080e7          	jalr	-708(ra) # 54 <test>
 320:	0dac                	addi	a1,sp,728
 322:	00001517          	auipc	a0,0x1
 326:	bc650513          	addi	a0,a0,-1082 # ee8 <malloc+0x2cc>
 32a:	00000097          	auipc	ra,0x0
 32e:	d2a080e7          	jalr	-726(ra) # 54 <test>
 332:	1d2c                	addi	a1,sp,696
 334:	00001517          	auipc	a0,0x1
 338:	bb450513          	addi	a0,a0,-1100 # ee8 <malloc+0x2cc>
 33c:	00000097          	auipc	ra,0x0
 340:	d18080e7          	jalr	-744(ra) # 54 <test>
 344:	150c                	addi	a1,sp,672
 346:	00001517          	auipc	a0,0x1
 34a:	ba250513          	addi	a0,a0,-1118 # ee8 <malloc+0x2cc>
 34e:	00000097          	auipc	ra,0x0
 352:	d06080e7          	jalr	-762(ra) # 54 <test>
 356:	0d0c                	addi	a1,sp,656
 358:	00001517          	auipc	a0,0x1
 35c:	b9050513          	addi	a0,a0,-1136 # ee8 <malloc+0x2cc>
 360:	00000097          	auipc	ra,0x0
 364:	cf4080e7          	jalr	-780(ra) # 54 <test>
 368:	050c                	addi	a1,sp,640
 36a:	00001517          	auipc	a0,0x1
 36e:	b7e50513          	addi	a0,a0,-1154 # ee8 <malloc+0x2cc>
 372:	00000097          	auipc	ra,0x0
 376:	ce2080e7          	jalr	-798(ra) # 54 <test>
 37a:	1c8c                	addi	a1,sp,624
 37c:	00001517          	auipc	a0,0x1
 380:	b6c50513          	addi	a0,a0,-1172 # ee8 <malloc+0x2cc>
 384:	00000097          	auipc	ra,0x0
 388:	cd0080e7          	jalr	-816(ra) # 54 <test>
 38c:	0cac                	addi	a1,sp,600
 38e:	00001517          	auipc	a0,0x1
 392:	b5a50513          	addi	a0,a0,-1190 # ee8 <malloc+0x2cc>
 396:	00000097          	auipc	ra,0x0
 39a:	cbe080e7          	jalr	-834(ra) # 54 <test>
 39e:	1c0c                	addi	a1,sp,560
 3a0:	00001517          	auipc	a0,0x1
 3a4:	b4850513          	addi	a0,a0,-1208 # ee8 <malloc+0x2cc>
 3a8:	00000097          	auipc	ra,0x0
 3ac:	cac080e7          	jalr	-852(ra) # 54 <test>
 3b0:	140c                	addi	a1,sp,544
 3b2:	00001517          	auipc	a0,0x1
 3b6:	b3650513          	addi	a0,a0,-1226 # ee8 <malloc+0x2cc>
 3ba:	00000097          	auipc	ra,0x0
 3be:	c9a080e7          	jalr	-870(ra) # 54 <test>
 3c2:	0c0c                	addi	a1,sp,528
 3c4:	00001517          	auipc	a0,0x1
 3c8:	b2450513          	addi	a0,a0,-1244 # ee8 <malloc+0x2cc>
 3cc:	00000097          	auipc	ra,0x0
 3d0:	c88080e7          	jalr	-888(ra) # 54 <test>
 3d4:	1bac                	addi	a1,sp,504
 3d6:	00001517          	auipc	a0,0x1
 3da:	b1250513          	addi	a0,a0,-1262 # ee8 <malloc+0x2cc>
 3de:	00000097          	auipc	ra,0x0
 3e2:	c76080e7          	jalr	-906(ra) # 54 <test>
 3e6:	13ac                	addi	a1,sp,488
 3e8:	00001517          	auipc	a0,0x1
 3ec:	b0050513          	addi	a0,a0,-1280 # ee8 <malloc+0x2cc>
 3f0:	00000097          	auipc	ra,0x0
 3f4:	c64080e7          	jalr	-924(ra) # 54 <test>
 3f8:	0bac                	addi	a1,sp,472
 3fa:	00001517          	auipc	a0,0x1
 3fe:	aee50513          	addi	a0,a0,-1298 # ee8 <malloc+0x2cc>
 402:	00000097          	auipc	ra,0x0
 406:	c52080e7          	jalr	-942(ra) # 54 <test>
 40a:	03ac                	addi	a1,sp,456
 40c:	00001517          	auipc	a0,0x1
 410:	adc50513          	addi	a0,a0,-1316 # ee8 <malloc+0x2cc>
 414:	00000097          	auipc	ra,0x0
 418:	c40080e7          	jalr	-960(ra) # 54 <test>
 41c:	130c                	addi	a1,sp,416
 41e:	00001517          	auipc	a0,0x1
 422:	aca50513          	addi	a0,a0,-1334 # ee8 <malloc+0x2cc>
 426:	00000097          	auipc	ra,0x0
 42a:	c2e080e7          	jalr	-978(ra) # 54 <test>
 42e:	0b0c                	addi	a1,sp,400
 430:	00001517          	auipc	a0,0x1
 434:	ab850513          	addi	a0,a0,-1352 # ee8 <malloc+0x2cc>
 438:	00000097          	auipc	ra,0x0
 43c:	c1c080e7          	jalr	-996(ra) # 54 <test>
 440:	030c                	addi	a1,sp,384
 442:	00001517          	auipc	a0,0x1
 446:	aa650513          	addi	a0,a0,-1370 # ee8 <malloc+0x2cc>
 44a:	00000097          	auipc	ra,0x0
 44e:	c0a080e7          	jalr	-1014(ra) # 54 <test>
 452:	1b2c                	addi	a1,sp,440
 454:	00001517          	auipc	a0,0x1
 458:	a9450513          	addi	a0,a0,-1388 # ee8 <malloc+0x2cc>
 45c:	00000097          	auipc	ra,0x0
 460:	bf8080e7          	jalr	-1032(ra) # 54 <test>
 464:	12ac                	addi	a1,sp,360
 466:	00001517          	auipc	a0,0x1
 46a:	a8250513          	addi	a0,a0,-1406 # ee8 <malloc+0x2cc>
 46e:	00000097          	auipc	ra,0x0
 472:	be6080e7          	jalr	-1050(ra) # 54 <test>
 476:	0a8c                	addi	a1,sp,336
 478:	00001517          	auipc	a0,0x1
 47c:	a7050513          	addi	a0,a0,-1424 # ee8 <malloc+0x2cc>
 480:	00000097          	auipc	ra,0x0
 484:	bd4080e7          	jalr	-1068(ra) # 54 <test>
 488:	4589                	li	a1,2
 48a:	8522                	mv	a0,s0
 48c:	00000097          	auipc	ra,0x0
 490:	12e080e7          	jalr	302(ra) # 5ba <open>
 494:	842a                	mv	s0,a0
 496:	10054063          	bltz	a0,596 <main+0x4f8>
 49a:	4635                	li	a2,13
 49c:	00001597          	auipc	a1,0x1
 4a0:	a5458593          	addi	a1,a1,-1452 # ef0 <malloc+0x2d4>
 4a4:	8522                	mv	a0,s0
 4a6:	00000097          	auipc	ra,0x0
 4aa:	1aa080e7          	jalr	426(ra) # 650 <write>
 4ae:	0e054963          	bltz	a0,5a0 <main+0x502>
 4b2:	8522                	mv	a0,s0
 4b4:	00000097          	auipc	ra,0x0
 4b8:	174080e7          	jalr	372(ra) # 628 <close>
 4bc:	1a2c                	addi	a1,sp,312
 4be:	00001517          	auipc	a0,0x1
 4c2:	a2a50513          	addi	a0,a0,-1494 # ee8 <malloc+0x2cc>
 4c6:	00000097          	auipc	ra,0x0
 4ca:	b8e080e7          	jalr	-1138(ra) # 54 <test>
 4ce:	0a0c                	addi	a1,sp,272
 4d0:	00001517          	auipc	a0,0x1
 4d4:	a1850513          	addi	a0,a0,-1512 # ee8 <malloc+0x2cc>
 4d8:	00000097          	auipc	ra,0x0
 4dc:	b7c080e7          	jalr	-1156(ra) # 54 <test>
 4e0:	19ac                	addi	a1,sp,248
 4e2:	00001517          	auipc	a0,0x1
 4e6:	a0650513          	addi	a0,a0,-1530 # ee8 <malloc+0x2cc>
 4ea:	00000097          	auipc	ra,0x0
 4ee:	b6a080e7          	jalr	-1174(ra) # 54 <test>
 4f2:	118c                	addi	a1,sp,224
 4f4:	00001517          	auipc	a0,0x1
 4f8:	9f450513          	addi	a0,a0,-1548 # ee8 <malloc+0x2cc>
 4fc:	00000097          	auipc	ra,0x0
 500:	b58080e7          	jalr	-1192(ra) # 54 <test>
 504:	01ac                	addi	a1,sp,200
 506:	00001517          	auipc	a0,0x1
 50a:	9e250513          	addi	a0,a0,-1566 # ee8 <malloc+0x2cc>
 50e:	00000097          	auipc	ra,0x0
 512:	b46080e7          	jalr	-1210(ra) # 54 <test>
 516:	112c                	addi	a1,sp,168
 518:	00001517          	auipc	a0,0x1
 51c:	9d050513          	addi	a0,a0,-1584 # ee8 <malloc+0x2cc>
 520:	00000097          	auipc	ra,0x0
 524:	b34080e7          	jalr	-1228(ra) # 54 <test>
 528:	090c                	addi	a1,sp,144
 52a:	00001517          	auipc	a0,0x1
 52e:	9be50513          	addi	a0,a0,-1602 # ee8 <malloc+0x2cc>
 532:	00000097          	auipc	ra,0x0
 536:	b22080e7          	jalr	-1246(ra) # 54 <test>
 53a:	18ac                	addi	a1,sp,120
 53c:	00001517          	auipc	a0,0x1
 540:	9ac50513          	addi	a0,a0,-1620 # ee8 <malloc+0x2cc>
 544:	00000097          	auipc	ra,0x0
 548:	b10080e7          	jalr	-1264(ra) # 54 <test>
 54c:	108c                	addi	a1,sp,96
 54e:	00001517          	auipc	a0,0x1
 552:	99a50513          	addi	a0,a0,-1638 # ee8 <malloc+0x2cc>
 556:	00000097          	auipc	ra,0x0
 55a:	afe080e7          	jalr	-1282(ra) # 54 <test>
 55e:	00ac                	addi	a1,sp,72
 560:	00001517          	auipc	a0,0x1
 564:	98850513          	addi	a0,a0,-1656 # ee8 <malloc+0x2cc>
 568:	00000097          	auipc	ra,0x0
 56c:	aec080e7          	jalr	-1300(ra) # 54 <test>
 570:	100c                	addi	a1,sp,32
 572:	00001517          	auipc	a0,0x1
 576:	97650513          	addi	a0,a0,-1674 # ee8 <malloc+0x2cc>
 57a:	00000097          	auipc	ra,0x0
 57e:	ada080e7          	jalr	-1318(ra) # 54 <test>
 582:	002c                	addi	a1,sp,8
 584:	00001517          	auipc	a0,0x1
 588:	96450513          	addi	a0,a0,-1692 # ee8 <malloc+0x2cc>
 58c:	00000097          	auipc	ra,0x0
 590:	ac8080e7          	jalr	-1336(ra) # 54 <test>
 594:	a001                	j	594 <main+0x4f6>
 596:	00000097          	auipc	ra,0x0
 59a:	15a080e7          	jalr	346(ra) # 6f0 <kernel_panic>
 59e:	bdf5                	j	49a <main+0x3fc>
 5a0:	00000097          	auipc	ra,0x0
 5a4:	150080e7          	jalr	336(ra) # 6f0 <kernel_panic>
 5a8:	b729                	j	4b2 <main+0x414>

00000000000005aa <fork>:
 5aa:	4885                	li	a7,1
 5ac:	00000073          	ecall
 5b0:	8082                	ret

00000000000005b2 <wait>:
 5b2:	488d                	li	a7,3
 5b4:	00000073          	ecall
 5b8:	8082                	ret

00000000000005ba <open>:
 5ba:	4889                	li	a7,2
 5bc:	00000073          	ecall
 5c0:	8082                	ret

00000000000005c2 <sbrk>:
 5c2:	4891                	li	a7,4
 5c4:	00000073          	ecall
 5c8:	8082                	ret

00000000000005ca <getcwd>:
 5ca:	48c5                	li	a7,17
 5cc:	00000073          	ecall
 5d0:	8082                	ret

00000000000005d2 <dup>:
 5d2:	48dd                	li	a7,23
 5d4:	00000073          	ecall
 5d8:	8082                	ret

00000000000005da <dup3>:
 5da:	48e1                	li	a7,24
 5dc:	00000073          	ecall
 5e0:	8082                	ret

00000000000005e2 <mkdirat>:
 5e2:	02200893          	li	a7,34
 5e6:	00000073          	ecall
 5ea:	8082                	ret

00000000000005ec <unlinkat>:
 5ec:	02300893          	li	a7,35
 5f0:	00000073          	ecall
 5f4:	8082                	ret

00000000000005f6 <linkat>:
 5f6:	02500893          	li	a7,37
 5fa:	00000073          	ecall
 5fe:	8082                	ret

0000000000000600 <umount2>:
 600:	02700893          	li	a7,39
 604:	00000073          	ecall
 608:	8082                	ret

000000000000060a <mount>:
 60a:	02800893          	li	a7,40
 60e:	00000073          	ecall
 612:	8082                	ret

0000000000000614 <chdir>:
 614:	03100893          	li	a7,49
 618:	00000073          	ecall
 61c:	8082                	ret

000000000000061e <openat>:
 61e:	03800893          	li	a7,56
 622:	00000073          	ecall
 626:	8082                	ret

0000000000000628 <close>:
 628:	03900893          	li	a7,57
 62c:	00000073          	ecall
 630:	8082                	ret

0000000000000632 <pipe2>:
 632:	03b00893          	li	a7,59
 636:	00000073          	ecall
 63a:	8082                	ret

000000000000063c <getdents64>:
 63c:	03d00893          	li	a7,61
 640:	00000073          	ecall
 644:	8082                	ret

0000000000000646 <read>:
 646:	03f00893          	li	a7,63
 64a:	00000073          	ecall
 64e:	8082                	ret

0000000000000650 <write>:
 650:	04000893          	li	a7,64
 654:	00000073          	ecall
 658:	8082                	ret

000000000000065a <fstat>:
 65a:	05000893          	li	a7,80
 65e:	00000073          	ecall
 662:	8082                	ret

0000000000000664 <exit>:
 664:	05d00893          	li	a7,93
 668:	00000073          	ecall
 66c:	8082                	ret

000000000000066e <nanosleep>:
 66e:	06500893          	li	a7,101
 672:	00000073          	ecall
 676:	8082                	ret

0000000000000678 <sched_yield>:
 678:	07c00893          	li	a7,124
 67c:	00000073          	ecall
 680:	8082                	ret

0000000000000682 <times>:
 682:	09900893          	li	a7,153
 686:	00000073          	ecall
 68a:	8082                	ret

000000000000068c <uname>:
 68c:	0a000893          	li	a7,160
 690:	00000073          	ecall
 694:	8082                	ret

0000000000000696 <gettimeofday>:
 696:	0a900893          	li	a7,169
 69a:	00000073          	ecall
 69e:	8082                	ret

00000000000006a0 <brk>:
 6a0:	0d600893          	li	a7,214
 6a4:	00000073          	ecall
 6a8:	8082                	ret

00000000000006aa <munmap>:
 6aa:	0d700893          	li	a7,215
 6ae:	00000073          	ecall
 6b2:	8082                	ret

00000000000006b4 <getpid>:
 6b4:	0ac00893          	li	a7,172
 6b8:	00000073          	ecall
 6bc:	8082                	ret

00000000000006be <getppid>:
 6be:	0ad00893          	li	a7,173
 6c2:	00000073          	ecall
 6c6:	8082                	ret

00000000000006c8 <clone>:
 6c8:	0dc00893          	li	a7,220
 6cc:	00000073          	ecall
 6d0:	8082                	ret

00000000000006d2 <execve>:
 6d2:	0dd00893          	li	a7,221
 6d6:	00000073          	ecall
 6da:	8082                	ret

00000000000006dc <mmap>:
 6dc:	0de00893          	li	a7,222
 6e0:	00000073          	ecall
 6e4:	8082                	ret

00000000000006e6 <wait4>:
 6e6:	10400893          	li	a7,260
 6ea:	00000073          	ecall
 6ee:	8082                	ret

00000000000006f0 <kernel_panic>:
 6f0:	18f00893          	li	a7,399
 6f4:	00000073          	ecall
 6f8:	8082                	ret

00000000000006fa <strcpy>:
 6fa:	87aa                	mv	a5,a0
 6fc:	0585                	addi	a1,a1,1
 6fe:	0785                	addi	a5,a5,1
 700:	fff5c703          	lbu	a4,-1(a1)
 704:	fee78fa3          	sb	a4,-1(a5)
 708:	fb75                	bnez	a4,6fc <strcpy+0x2>
 70a:	8082                	ret

000000000000070c <strcmp>:
 70c:	00054783          	lbu	a5,0(a0)
 710:	cb91                	beqz	a5,724 <strcmp+0x18>
 712:	0005c703          	lbu	a4,0(a1)
 716:	00f71763          	bne	a4,a5,724 <strcmp+0x18>
 71a:	0505                	addi	a0,a0,1
 71c:	0585                	addi	a1,a1,1
 71e:	00054783          	lbu	a5,0(a0)
 722:	fbe5                	bnez	a5,712 <strcmp+0x6>
 724:	0005c503          	lbu	a0,0(a1)
 728:	40a7853b          	subw	a0,a5,a0
 72c:	8082                	ret

000000000000072e <strlen>:
 72e:	00054783          	lbu	a5,0(a0)
 732:	cf81                	beqz	a5,74a <strlen+0x1c>
 734:	0505                	addi	a0,a0,1
 736:	87aa                	mv	a5,a0
 738:	4685                	li	a3,1
 73a:	9e89                	subw	a3,a3,a0
 73c:	00f6853b          	addw	a0,a3,a5
 740:	0785                	addi	a5,a5,1
 742:	fff7c703          	lbu	a4,-1(a5)
 746:	fb7d                	bnez	a4,73c <strlen+0xe>
 748:	8082                	ret
 74a:	4501                	li	a0,0
 74c:	8082                	ret

000000000000074e <memset>:
 74e:	ce09                	beqz	a2,768 <memset+0x1a>
 750:	87aa                	mv	a5,a0
 752:	fff6071b          	addiw	a4,a2,-1
 756:	1702                	slli	a4,a4,0x20
 758:	9301                	srli	a4,a4,0x20
 75a:	0705                	addi	a4,a4,1
 75c:	972a                	add	a4,a4,a0
 75e:	00b78023          	sb	a1,0(a5)
 762:	0785                	addi	a5,a5,1
 764:	fee79de3          	bne	a5,a4,75e <memset+0x10>
 768:	8082                	ret

000000000000076a <strchr>:
 76a:	00054783          	lbu	a5,0(a0)
 76e:	cb89                	beqz	a5,780 <strchr+0x16>
 770:	00f58963          	beq	a1,a5,782 <strchr+0x18>
 774:	0505                	addi	a0,a0,1
 776:	00054783          	lbu	a5,0(a0)
 77a:	fbfd                	bnez	a5,770 <strchr+0x6>
 77c:	4501                	li	a0,0
 77e:	8082                	ret
 780:	4501                	li	a0,0
 782:	8082                	ret

0000000000000784 <gets>:
 784:	715d                	addi	sp,sp,-80
 786:	e486                	sd	ra,72(sp)
 788:	e0a2                	sd	s0,64(sp)
 78a:	fc26                	sd	s1,56(sp)
 78c:	f84a                	sd	s2,48(sp)
 78e:	f44e                	sd	s3,40(sp)
 790:	f052                	sd	s4,32(sp)
 792:	ec56                	sd	s5,24(sp)
 794:	e85a                	sd	s6,16(sp)
 796:	8b2a                	mv	s6,a0
 798:	89ae                	mv	s3,a1
 79a:	84aa                	mv	s1,a0
 79c:	4401                	li	s0,0
 79e:	4a29                	li	s4,10
 7a0:	4ab5                	li	s5,13
 7a2:	8922                	mv	s2,s0
 7a4:	2405                	addiw	s0,s0,1
 7a6:	03345863          	bge	s0,s3,7d6 <gets+0x52>
 7aa:	4605                	li	a2,1
 7ac:	00f10593          	addi	a1,sp,15
 7b0:	4501                	li	a0,0
 7b2:	00000097          	auipc	ra,0x0
 7b6:	e94080e7          	jalr	-364(ra) # 646 <read>
 7ba:	00a05e63          	blez	a0,7d6 <gets+0x52>
 7be:	00f14783          	lbu	a5,15(sp)
 7c2:	00f48023          	sb	a5,0(s1)
 7c6:	01478763          	beq	a5,s4,7d4 <gets+0x50>
 7ca:	0485                	addi	s1,s1,1
 7cc:	fd579be3          	bne	a5,s5,7a2 <gets+0x1e>
 7d0:	8922                	mv	s2,s0
 7d2:	a011                	j	7d6 <gets+0x52>
 7d4:	8922                	mv	s2,s0
 7d6:	995a                	add	s2,s2,s6
 7d8:	00090023          	sb	zero,0(s2)
 7dc:	855a                	mv	a0,s6
 7de:	60a6                	ld	ra,72(sp)
 7e0:	6406                	ld	s0,64(sp)
 7e2:	74e2                	ld	s1,56(sp)
 7e4:	7942                	ld	s2,48(sp)
 7e6:	79a2                	ld	s3,40(sp)
 7e8:	7a02                	ld	s4,32(sp)
 7ea:	6ae2                	ld	s5,24(sp)
 7ec:	6b42                	ld	s6,16(sp)
 7ee:	6161                	addi	sp,sp,80
 7f0:	8082                	ret

00000000000007f2 <atoi>:
 7f2:	86aa                	mv	a3,a0
 7f4:	00054603          	lbu	a2,0(a0)
 7f8:	fd06079b          	addiw	a5,a2,-48
 7fc:	0ff7f793          	andi	a5,a5,255
 800:	4725                	li	a4,9
 802:	02f76663          	bltu	a4,a5,82e <atoi+0x3c>
 806:	4501                	li	a0,0
 808:	45a5                	li	a1,9
 80a:	0685                	addi	a3,a3,1
 80c:	0025179b          	slliw	a5,a0,0x2
 810:	9fa9                	addw	a5,a5,a0
 812:	0017979b          	slliw	a5,a5,0x1
 816:	9fb1                	addw	a5,a5,a2
 818:	fd07851b          	addiw	a0,a5,-48
 81c:	0006c603          	lbu	a2,0(a3)
 820:	fd06071b          	addiw	a4,a2,-48
 824:	0ff77713          	andi	a4,a4,255
 828:	fee5f1e3          	bgeu	a1,a4,80a <atoi+0x18>
 82c:	8082                	ret
 82e:	4501                	li	a0,0
 830:	8082                	ret

0000000000000832 <memmove>:
 832:	02b57463          	bgeu	a0,a1,85a <memmove+0x28>
 836:	04c05663          	blez	a2,882 <memmove+0x50>
 83a:	fff6079b          	addiw	a5,a2,-1
 83e:	1782                	slli	a5,a5,0x20
 840:	9381                	srli	a5,a5,0x20
 842:	0785                	addi	a5,a5,1
 844:	97aa                	add	a5,a5,a0
 846:	872a                	mv	a4,a0
 848:	0585                	addi	a1,a1,1
 84a:	0705                	addi	a4,a4,1
 84c:	fff5c683          	lbu	a3,-1(a1)
 850:	fed70fa3          	sb	a3,-1(a4)
 854:	fee79ae3          	bne	a5,a4,848 <memmove+0x16>
 858:	8082                	ret
 85a:	00c50733          	add	a4,a0,a2
 85e:	95b2                	add	a1,a1,a2
 860:	02c05163          	blez	a2,882 <memmove+0x50>
 864:	fff6079b          	addiw	a5,a2,-1
 868:	1782                	slli	a5,a5,0x20
 86a:	9381                	srli	a5,a5,0x20
 86c:	fff7c793          	not	a5,a5
 870:	97ba                	add	a5,a5,a4
 872:	15fd                	addi	a1,a1,-1
 874:	177d                	addi	a4,a4,-1
 876:	0005c683          	lbu	a3,0(a1)
 87a:	00d70023          	sb	a3,0(a4)
 87e:	fee79ae3          	bne	a5,a4,872 <memmove+0x40>
 882:	8082                	ret

0000000000000884 <memcmp>:
 884:	fff6069b          	addiw	a3,a2,-1
 888:	c605                	beqz	a2,8b0 <memcmp+0x2c>
 88a:	1682                	slli	a3,a3,0x20
 88c:	9281                	srli	a3,a3,0x20
 88e:	0685                	addi	a3,a3,1
 890:	96aa                	add	a3,a3,a0
 892:	00054783          	lbu	a5,0(a0)
 896:	0005c703          	lbu	a4,0(a1)
 89a:	00e79863          	bne	a5,a4,8aa <memcmp+0x26>
 89e:	0505                	addi	a0,a0,1
 8a0:	0585                	addi	a1,a1,1
 8a2:	fed518e3          	bne	a0,a3,892 <memcmp+0xe>
 8a6:	4501                	li	a0,0
 8a8:	8082                	ret
 8aa:	40e7853b          	subw	a0,a5,a4
 8ae:	8082                	ret
 8b0:	4501                	li	a0,0
 8b2:	8082                	ret

00000000000008b4 <memcpy>:
 8b4:	1141                	addi	sp,sp,-16
 8b6:	e406                	sd	ra,8(sp)
 8b8:	00000097          	auipc	ra,0x0
 8bc:	f7a080e7          	jalr	-134(ra) # 832 <memmove>
 8c0:	60a2                	ld	ra,8(sp)
 8c2:	0141                	addi	sp,sp,16
 8c4:	8082                	ret

00000000000008c6 <putc>:
 8c6:	1101                	addi	sp,sp,-32
 8c8:	ec06                	sd	ra,24(sp)
 8ca:	00b107a3          	sb	a1,15(sp)
 8ce:	4605                	li	a2,1
 8d0:	00f10593          	addi	a1,sp,15
 8d4:	00000097          	auipc	ra,0x0
 8d8:	d7c080e7          	jalr	-644(ra) # 650 <write>
 8dc:	60e2                	ld	ra,24(sp)
 8de:	6105                	addi	sp,sp,32
 8e0:	8082                	ret

00000000000008e2 <printint>:
 8e2:	7179                	addi	sp,sp,-48
 8e4:	f406                	sd	ra,40(sp)
 8e6:	f022                	sd	s0,32(sp)
 8e8:	ec26                	sd	s1,24(sp)
 8ea:	e84a                	sd	s2,16(sp)
 8ec:	84aa                	mv	s1,a0
 8ee:	c299                	beqz	a3,8f4 <printint+0x12>
 8f0:	0805c363          	bltz	a1,976 <printint+0x94>
 8f4:	2581                	sext.w	a1,a1
 8f6:	4881                	li	a7,0
 8f8:	868a                	mv	a3,sp
 8fa:	4701                	li	a4,0
 8fc:	2601                	sext.w	a2,a2
 8fe:	00000517          	auipc	a0,0x0
 902:	6e250513          	addi	a0,a0,1762 # fe0 <digits>
 906:	883a                	mv	a6,a4
 908:	2705                	addiw	a4,a4,1
 90a:	02c5f7bb          	remuw	a5,a1,a2
 90e:	1782                	slli	a5,a5,0x20
 910:	9381                	srli	a5,a5,0x20
 912:	97aa                	add	a5,a5,a0
 914:	0007c783          	lbu	a5,0(a5)
 918:	00f68023          	sb	a5,0(a3)
 91c:	0005879b          	sext.w	a5,a1
 920:	02c5d5bb          	divuw	a1,a1,a2
 924:	0685                	addi	a3,a3,1
 926:	fec7f0e3          	bgeu	a5,a2,906 <printint+0x24>
 92a:	00088a63          	beqz	a7,93e <printint+0x5c>
 92e:	081c                	addi	a5,sp,16
 930:	973e                	add	a4,a4,a5
 932:	02d00793          	li	a5,45
 936:	fef70823          	sb	a5,-16(a4)
 93a:	0028071b          	addiw	a4,a6,2
 93e:	02e05663          	blez	a4,96a <printint+0x88>
 942:	00e10433          	add	s0,sp,a4
 946:	fff10913          	addi	s2,sp,-1
 94a:	993a                	add	s2,s2,a4
 94c:	377d                	addiw	a4,a4,-1
 94e:	1702                	slli	a4,a4,0x20
 950:	9301                	srli	a4,a4,0x20
 952:	40e90933          	sub	s2,s2,a4
 956:	fff44583          	lbu	a1,-1(s0)
 95a:	8526                	mv	a0,s1
 95c:	00000097          	auipc	ra,0x0
 960:	f6a080e7          	jalr	-150(ra) # 8c6 <putc>
 964:	147d                	addi	s0,s0,-1
 966:	ff2418e3          	bne	s0,s2,956 <printint+0x74>
 96a:	70a2                	ld	ra,40(sp)
 96c:	7402                	ld	s0,32(sp)
 96e:	64e2                	ld	s1,24(sp)
 970:	6942                	ld	s2,16(sp)
 972:	6145                	addi	sp,sp,48
 974:	8082                	ret
 976:	40b005bb          	negw	a1,a1
 97a:	4885                	li	a7,1
 97c:	bfb5                	j	8f8 <printint+0x16>

000000000000097e <vprintf>:
 97e:	7119                	addi	sp,sp,-128
 980:	fc86                	sd	ra,120(sp)
 982:	f8a2                	sd	s0,112(sp)
 984:	f4a6                	sd	s1,104(sp)
 986:	f0ca                	sd	s2,96(sp)
 988:	ecce                	sd	s3,88(sp)
 98a:	e8d2                	sd	s4,80(sp)
 98c:	e4d6                	sd	s5,72(sp)
 98e:	e0da                	sd	s6,64(sp)
 990:	fc5e                	sd	s7,56(sp)
 992:	f862                	sd	s8,48(sp)
 994:	f466                	sd	s9,40(sp)
 996:	f06a                	sd	s10,32(sp)
 998:	ec6e                	sd	s11,24(sp)
 99a:	0005c483          	lbu	s1,0(a1)
 99e:	18048c63          	beqz	s1,b36 <vprintf+0x1b8>
 9a2:	8a2a                	mv	s4,a0
 9a4:	8ab2                	mv	s5,a2
 9a6:	00158413          	addi	s0,a1,1
 9aa:	4901                	li	s2,0
 9ac:	02500993          	li	s3,37
 9b0:	06400b93          	li	s7,100
 9b4:	06c00c13          	li	s8,108
 9b8:	07800c93          	li	s9,120
 9bc:	07000d13          	li	s10,112
 9c0:	07300d93          	li	s11,115
 9c4:	00000b17          	auipc	s6,0x0
 9c8:	61cb0b13          	addi	s6,s6,1564 # fe0 <digits>
 9cc:	a839                	j	9ea <vprintf+0x6c>
 9ce:	85a6                	mv	a1,s1
 9d0:	8552                	mv	a0,s4
 9d2:	00000097          	auipc	ra,0x0
 9d6:	ef4080e7          	jalr	-268(ra) # 8c6 <putc>
 9da:	a019                	j	9e0 <vprintf+0x62>
 9dc:	01390f63          	beq	s2,s3,9fa <vprintf+0x7c>
 9e0:	0405                	addi	s0,s0,1
 9e2:	fff44483          	lbu	s1,-1(s0)
 9e6:	14048863          	beqz	s1,b36 <vprintf+0x1b8>
 9ea:	0004879b          	sext.w	a5,s1
 9ee:	fe0917e3          	bnez	s2,9dc <vprintf+0x5e>
 9f2:	fd379ee3          	bne	a5,s3,9ce <vprintf+0x50>
 9f6:	893e                	mv	s2,a5
 9f8:	b7e5                	j	9e0 <vprintf+0x62>
 9fa:	03778e63          	beq	a5,s7,a36 <vprintf+0xb8>
 9fe:	05878a63          	beq	a5,s8,a52 <vprintf+0xd4>
 a02:	07978663          	beq	a5,s9,a6e <vprintf+0xf0>
 a06:	09a78263          	beq	a5,s10,a8a <vprintf+0x10c>
 a0a:	0db78363          	beq	a5,s11,ad0 <vprintf+0x152>
 a0e:	06300713          	li	a4,99
 a12:	0ee78b63          	beq	a5,a4,b08 <vprintf+0x18a>
 a16:	11378563          	beq	a5,s3,b20 <vprintf+0x1a2>
 a1a:	85ce                	mv	a1,s3
 a1c:	8552                	mv	a0,s4
 a1e:	00000097          	auipc	ra,0x0
 a22:	ea8080e7          	jalr	-344(ra) # 8c6 <putc>
 a26:	85a6                	mv	a1,s1
 a28:	8552                	mv	a0,s4
 a2a:	00000097          	auipc	ra,0x0
 a2e:	e9c080e7          	jalr	-356(ra) # 8c6 <putc>
 a32:	4901                	li	s2,0
 a34:	b775                	j	9e0 <vprintf+0x62>
 a36:	008a8493          	addi	s1,s5,8
 a3a:	4685                	li	a3,1
 a3c:	4629                	li	a2,10
 a3e:	000aa583          	lw	a1,0(s5)
 a42:	8552                	mv	a0,s4
 a44:	00000097          	auipc	ra,0x0
 a48:	e9e080e7          	jalr	-354(ra) # 8e2 <printint>
 a4c:	8aa6                	mv	s5,s1
 a4e:	4901                	li	s2,0
 a50:	bf41                	j	9e0 <vprintf+0x62>
 a52:	008a8493          	addi	s1,s5,8
 a56:	4681                	li	a3,0
 a58:	4629                	li	a2,10
 a5a:	000aa583          	lw	a1,0(s5)
 a5e:	8552                	mv	a0,s4
 a60:	00000097          	auipc	ra,0x0
 a64:	e82080e7          	jalr	-382(ra) # 8e2 <printint>
 a68:	8aa6                	mv	s5,s1
 a6a:	4901                	li	s2,0
 a6c:	bf95                	j	9e0 <vprintf+0x62>
 a6e:	008a8493          	addi	s1,s5,8
 a72:	4681                	li	a3,0
 a74:	4641                	li	a2,16
 a76:	000aa583          	lw	a1,0(s5)
 a7a:	8552                	mv	a0,s4
 a7c:	00000097          	auipc	ra,0x0
 a80:	e66080e7          	jalr	-410(ra) # 8e2 <printint>
 a84:	8aa6                	mv	s5,s1
 a86:	4901                	li	s2,0
 a88:	bfa1                	j	9e0 <vprintf+0x62>
 a8a:	008a8793          	addi	a5,s5,8
 a8e:	e43e                	sd	a5,8(sp)
 a90:	000ab903          	ld	s2,0(s5)
 a94:	03000593          	li	a1,48
 a98:	8552                	mv	a0,s4
 a9a:	00000097          	auipc	ra,0x0
 a9e:	e2c080e7          	jalr	-468(ra) # 8c6 <putc>
 aa2:	85e6                	mv	a1,s9
 aa4:	8552                	mv	a0,s4
 aa6:	00000097          	auipc	ra,0x0
 aaa:	e20080e7          	jalr	-480(ra) # 8c6 <putc>
 aae:	44c1                	li	s1,16
 ab0:	03c95793          	srli	a5,s2,0x3c
 ab4:	97da                	add	a5,a5,s6
 ab6:	0007c583          	lbu	a1,0(a5)
 aba:	8552                	mv	a0,s4
 abc:	00000097          	auipc	ra,0x0
 ac0:	e0a080e7          	jalr	-502(ra) # 8c6 <putc>
 ac4:	0912                	slli	s2,s2,0x4
 ac6:	34fd                	addiw	s1,s1,-1
 ac8:	f4e5                	bnez	s1,ab0 <vprintf+0x132>
 aca:	6aa2                	ld	s5,8(sp)
 acc:	4901                	li	s2,0
 ace:	bf09                	j	9e0 <vprintf+0x62>
 ad0:	008a8493          	addi	s1,s5,8
 ad4:	000ab903          	ld	s2,0(s5)
 ad8:	02090163          	beqz	s2,afa <vprintf+0x17c>
 adc:	00094583          	lbu	a1,0(s2)
 ae0:	c9a1                	beqz	a1,b30 <vprintf+0x1b2>
 ae2:	8552                	mv	a0,s4
 ae4:	00000097          	auipc	ra,0x0
 ae8:	de2080e7          	jalr	-542(ra) # 8c6 <putc>
 aec:	0905                	addi	s2,s2,1
 aee:	00094583          	lbu	a1,0(s2)
 af2:	f9e5                	bnez	a1,ae2 <vprintf+0x164>
 af4:	8aa6                	mv	s5,s1
 af6:	4901                	li	s2,0
 af8:	b5e5                	j	9e0 <vprintf+0x62>
 afa:	00000917          	auipc	s2,0x0
 afe:	4de90913          	addi	s2,s2,1246 # fd8 <malloc+0x3bc>
 b02:	02800593          	li	a1,40
 b06:	bff1                	j	ae2 <vprintf+0x164>
 b08:	008a8493          	addi	s1,s5,8
 b0c:	000ac583          	lbu	a1,0(s5)
 b10:	8552                	mv	a0,s4
 b12:	00000097          	auipc	ra,0x0
 b16:	db4080e7          	jalr	-588(ra) # 8c6 <putc>
 b1a:	8aa6                	mv	s5,s1
 b1c:	4901                	li	s2,0
 b1e:	b5c9                	j	9e0 <vprintf+0x62>
 b20:	85ce                	mv	a1,s3
 b22:	8552                	mv	a0,s4
 b24:	00000097          	auipc	ra,0x0
 b28:	da2080e7          	jalr	-606(ra) # 8c6 <putc>
 b2c:	4901                	li	s2,0
 b2e:	bd4d                	j	9e0 <vprintf+0x62>
 b30:	8aa6                	mv	s5,s1
 b32:	4901                	li	s2,0
 b34:	b575                	j	9e0 <vprintf+0x62>
 b36:	70e6                	ld	ra,120(sp)
 b38:	7446                	ld	s0,112(sp)
 b3a:	74a6                	ld	s1,104(sp)
 b3c:	7906                	ld	s2,96(sp)
 b3e:	69e6                	ld	s3,88(sp)
 b40:	6a46                	ld	s4,80(sp)
 b42:	6aa6                	ld	s5,72(sp)
 b44:	6b06                	ld	s6,64(sp)
 b46:	7be2                	ld	s7,56(sp)
 b48:	7c42                	ld	s8,48(sp)
 b4a:	7ca2                	ld	s9,40(sp)
 b4c:	7d02                	ld	s10,32(sp)
 b4e:	6de2                	ld	s11,24(sp)
 b50:	6109                	addi	sp,sp,128
 b52:	8082                	ret

0000000000000b54 <fprintf>:
 b54:	715d                	addi	sp,sp,-80
 b56:	ec06                	sd	ra,24(sp)
 b58:	f032                	sd	a2,32(sp)
 b5a:	f436                	sd	a3,40(sp)
 b5c:	f83a                	sd	a4,48(sp)
 b5e:	fc3e                	sd	a5,56(sp)
 b60:	e0c2                	sd	a6,64(sp)
 b62:	e4c6                	sd	a7,72(sp)
 b64:	1010                	addi	a2,sp,32
 b66:	e432                	sd	a2,8(sp)
 b68:	00000097          	auipc	ra,0x0
 b6c:	e16080e7          	jalr	-490(ra) # 97e <vprintf>
 b70:	60e2                	ld	ra,24(sp)
 b72:	6161                	addi	sp,sp,80
 b74:	8082                	ret

0000000000000b76 <printf>:
 b76:	711d                	addi	sp,sp,-96
 b78:	ec06                	sd	ra,24(sp)
 b7a:	f42e                	sd	a1,40(sp)
 b7c:	f832                	sd	a2,48(sp)
 b7e:	fc36                	sd	a3,56(sp)
 b80:	e0ba                	sd	a4,64(sp)
 b82:	e4be                	sd	a5,72(sp)
 b84:	e8c2                	sd	a6,80(sp)
 b86:	ecc6                	sd	a7,88(sp)
 b88:	1030                	addi	a2,sp,40
 b8a:	e432                	sd	a2,8(sp)
 b8c:	85aa                	mv	a1,a0
 b8e:	4505                	li	a0,1
 b90:	00000097          	auipc	ra,0x0
 b94:	dee080e7          	jalr	-530(ra) # 97e <vprintf>
 b98:	60e2                	ld	ra,24(sp)
 b9a:	6125                	addi	sp,sp,96
 b9c:	8082                	ret

0000000000000b9e <free>:
 b9e:	ff050693          	addi	a3,a0,-16
 ba2:	00000797          	auipc	a5,0x0
 ba6:	4567b783          	ld	a5,1110(a5) # ff8 <freep>
 baa:	a805                	j	bda <free+0x3c>
 bac:	4618                	lw	a4,8(a2)
 bae:	9db9                	addw	a1,a1,a4
 bb0:	feb52c23          	sw	a1,-8(a0)
 bb4:	6398                	ld	a4,0(a5)
 bb6:	6318                	ld	a4,0(a4)
 bb8:	fee53823          	sd	a4,-16(a0)
 bbc:	a091                	j	c00 <free+0x62>
 bbe:	ff852703          	lw	a4,-8(a0)
 bc2:	9e39                	addw	a2,a2,a4
 bc4:	c790                	sw	a2,8(a5)
 bc6:	ff053703          	ld	a4,-16(a0)
 bca:	e398                	sd	a4,0(a5)
 bcc:	a099                	j	c12 <free+0x74>
 bce:	6398                	ld	a4,0(a5)
 bd0:	00e7e463          	bltu	a5,a4,bd8 <free+0x3a>
 bd4:	00e6ea63          	bltu	a3,a4,be8 <free+0x4a>
 bd8:	87ba                	mv	a5,a4
 bda:	fed7fae3          	bgeu	a5,a3,bce <free+0x30>
 bde:	6398                	ld	a4,0(a5)
 be0:	00e6e463          	bltu	a3,a4,be8 <free+0x4a>
 be4:	fee7eae3          	bltu	a5,a4,bd8 <free+0x3a>
 be8:	ff852583          	lw	a1,-8(a0)
 bec:	6390                	ld	a2,0(a5)
 bee:	02059713          	slli	a4,a1,0x20
 bf2:	9301                	srli	a4,a4,0x20
 bf4:	0712                	slli	a4,a4,0x4
 bf6:	9736                	add	a4,a4,a3
 bf8:	fae60ae3          	beq	a2,a4,bac <free+0xe>
 bfc:	fec53823          	sd	a2,-16(a0)
 c00:	4790                	lw	a2,8(a5)
 c02:	02061713          	slli	a4,a2,0x20
 c06:	9301                	srli	a4,a4,0x20
 c08:	0712                	slli	a4,a4,0x4
 c0a:	973e                	add	a4,a4,a5
 c0c:	fae689e3          	beq	a3,a4,bbe <free+0x20>
 c10:	e394                	sd	a3,0(a5)
 c12:	00000717          	auipc	a4,0x0
 c16:	3ef73323          	sd	a5,998(a4) # ff8 <freep>
 c1a:	8082                	ret

0000000000000c1c <malloc>:
 c1c:	7139                	addi	sp,sp,-64
 c1e:	fc06                	sd	ra,56(sp)
 c20:	f822                	sd	s0,48(sp)
 c22:	f426                	sd	s1,40(sp)
 c24:	f04a                	sd	s2,32(sp)
 c26:	ec4e                	sd	s3,24(sp)
 c28:	e852                	sd	s4,16(sp)
 c2a:	e456                	sd	s5,8(sp)
 c2c:	02051413          	slli	s0,a0,0x20
 c30:	9001                	srli	s0,s0,0x20
 c32:	043d                	addi	s0,s0,15
 c34:	8011                	srli	s0,s0,0x4
 c36:	0014091b          	addiw	s2,s0,1
 c3a:	0405                	addi	s0,s0,1
 c3c:	00000517          	auipc	a0,0x0
 c40:	3bc53503          	ld	a0,956(a0) # ff8 <freep>
 c44:	c905                	beqz	a0,c74 <malloc+0x58>
 c46:	611c                	ld	a5,0(a0)
 c48:	4798                	lw	a4,8(a5)
 c4a:	04877163          	bgeu	a4,s0,c8c <malloc+0x70>
 c4e:	89ca                	mv	s3,s2
 c50:	0009071b          	sext.w	a4,s2
 c54:	6685                	lui	a3,0x1
 c56:	00d77363          	bgeu	a4,a3,c5c <malloc+0x40>
 c5a:	6985                	lui	s3,0x1
 c5c:	00098a1b          	sext.w	s4,s3
 c60:	1982                	slli	s3,s3,0x20
 c62:	0209d993          	srli	s3,s3,0x20
 c66:	0992                	slli	s3,s3,0x4
 c68:	00000497          	auipc	s1,0x0
 c6c:	39048493          	addi	s1,s1,912 # ff8 <freep>
 c70:	5afd                	li	s5,-1
 c72:	a0bd                	j	ce0 <malloc+0xc4>
 c74:	00000797          	auipc	a5,0x0
 c78:	38c78793          	addi	a5,a5,908 # 1000 <base>
 c7c:	00000717          	auipc	a4,0x0
 c80:	36f73e23          	sd	a5,892(a4) # ff8 <freep>
 c84:	e39c                	sd	a5,0(a5)
 c86:	0007a423          	sw	zero,8(a5)
 c8a:	b7d1                	j	c4e <malloc+0x32>
 c8c:	02e40a63          	beq	s0,a4,cc0 <malloc+0xa4>
 c90:	4127073b          	subw	a4,a4,s2
 c94:	c798                	sw	a4,8(a5)
 c96:	1702                	slli	a4,a4,0x20
 c98:	9301                	srli	a4,a4,0x20
 c9a:	0712                	slli	a4,a4,0x4
 c9c:	97ba                	add	a5,a5,a4
 c9e:	0127a423          	sw	s2,8(a5)
 ca2:	00000717          	auipc	a4,0x0
 ca6:	34a73b23          	sd	a0,854(a4) # ff8 <freep>
 caa:	01078513          	addi	a0,a5,16
 cae:	70e2                	ld	ra,56(sp)
 cb0:	7442                	ld	s0,48(sp)
 cb2:	74a2                	ld	s1,40(sp)
 cb4:	7902                	ld	s2,32(sp)
 cb6:	69e2                	ld	s3,24(sp)
 cb8:	6a42                	ld	s4,16(sp)
 cba:	6aa2                	ld	s5,8(sp)
 cbc:	6121                	addi	sp,sp,64
 cbe:	8082                	ret
 cc0:	6398                	ld	a4,0(a5)
 cc2:	e118                	sd	a4,0(a0)
 cc4:	bff9                	j	ca2 <malloc+0x86>
 cc6:	01452423          	sw	s4,8(a0)
 cca:	0541                	addi	a0,a0,16
 ccc:	00000097          	auipc	ra,0x0
 cd0:	ed2080e7          	jalr	-302(ra) # b9e <free>
 cd4:	6088                	ld	a0,0(s1)
 cd6:	dd61                	beqz	a0,cae <malloc+0x92>
 cd8:	611c                	ld	a5,0(a0)
 cda:	4798                	lw	a4,8(a5)
 cdc:	fa8778e3          	bgeu	a4,s0,c8c <malloc+0x70>
 ce0:	6098                	ld	a4,0(s1)
 ce2:	853e                	mv	a0,a5
 ce4:	fef71ae3          	bne	a4,a5,cd8 <malloc+0xbc>
 ce8:	854e                	mv	a0,s3
 cea:	00000097          	auipc	ra,0x0
 cee:	8d8080e7          	jalr	-1832(ra) # 5c2 <sbrk>
 cf2:	fd551ae3          	bne	a0,s5,cc6 <malloc+0xaa>
 cf6:	4501                	li	a0,0
 cf8:	bf5d                	j	cae <malloc+0x92>
