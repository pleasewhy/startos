
_oscmp_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_success>:
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	842e                	mv	s0,a1
       a:	85aa                	mv	a1,a0
       c:	00001517          	auipc	a0,0x1
      10:	14c50513          	addi	a0,a0,332 # 1158 <malloc+0x1ca>
      14:	00001097          	auipc	ra,0x1
      18:	ed4080e7          	jalr	-300(ra) # ee8 <printf>
      1c:	600c                	ld	a1,0(s0)
      1e:	cd99                	beqz	a1,3c <print_success+0x3c>
      20:	0421                	addi	s0,s0,8
      22:	00001497          	auipc	s1,0x1
      26:	14648493          	addi	s1,s1,326 # 1168 <malloc+0x1da>
      2a:	8526                	mv	a0,s1
      2c:	00001097          	auipc	ra,0x1
      30:	ebc080e7          	jalr	-324(ra) # ee8 <printf>
      34:	0421                	addi	s0,s0,8
      36:	ff843583          	ld	a1,-8(s0)
      3a:	f9e5                	bnez	a1,2a <print_success+0x2a>
      3c:	00001517          	auipc	a0,0x1
      40:	13450513          	addi	a0,a0,308 # 1170 <malloc+0x1e2>
      44:	00001097          	auipc	ra,0x1
      48:	ea4080e7          	jalr	-348(ra) # ee8 <printf>
      4c:	60e2                	ld	ra,24(sp)
      4e:	6442                	ld	s0,16(sp)
      50:	64a2                	ld	s1,8(sp)
      52:	6105                	addi	sp,sp,32
      54:	8082                	ret

0000000000000056 <print_fail>:
      56:	1101                	addi	sp,sp,-32
      58:	ec06                	sd	ra,24(sp)
      5a:	e822                	sd	s0,16(sp)
      5c:	e426                	sd	s1,8(sp)
      5e:	842e                	mv	s0,a1
      60:	85aa                	mv	a1,a0
      62:	00001517          	auipc	a0,0x1
      66:	0f650513          	addi	a0,a0,246 # 1158 <malloc+0x1ca>
      6a:	00001097          	auipc	ra,0x1
      6e:	e7e080e7          	jalr	-386(ra) # ee8 <printf>
      72:	600c                	ld	a1,0(s0)
      74:	cd99                	beqz	a1,92 <print_fail+0x3c>
      76:	0421                	addi	s0,s0,8
      78:	00001497          	auipc	s1,0x1
      7c:	0f048493          	addi	s1,s1,240 # 1168 <malloc+0x1da>
      80:	8526                	mv	a0,s1
      82:	00001097          	auipc	ra,0x1
      86:	e66080e7          	jalr	-410(ra) # ee8 <printf>
      8a:	0421                	addi	s0,s0,8
      8c:	ff843583          	ld	a1,-8(s0)
      90:	f9e5                	bnez	a1,80 <print_fail+0x2a>
      92:	00001517          	auipc	a0,0x1
      96:	0ee50513          	addi	a0,a0,238 # 1180 <malloc+0x1f2>
      9a:	00001097          	auipc	ra,0x1
      9e:	e4e080e7          	jalr	-434(ra) # ee8 <printf>
      a2:	60e2                	ld	ra,24(sp)
      a4:	6442                	ld	s0,16(sp)
      a6:	64a2                	ld	s1,8(sp)
      a8:	6105                	addi	sp,sp,32
      aa:	8082                	ret

00000000000000ac <test>:
      ac:	7179                	addi	sp,sp,-48
      ae:	f406                	sd	ra,40(sp)
      b0:	f022                	sd	s0,32(sp)
      b2:	ec26                	sd	s1,24(sp)
      b4:	842a                	mv	s0,a0
      b6:	84ae                	mv	s1,a1
      b8:	00001097          	auipc	ra,0x1
      bc:	864080e7          	jalr	-1948(ra) # 91c <fork>
      c0:	ed09                	bnez	a0,da <test+0x2e>
      c2:	4601                	li	a2,0
      c4:	85a6                	mv	a1,s1
      c6:	8522                	mv	a0,s0
      c8:	00001097          	auipc	ra,0x1
      cc:	97c080e7          	jalr	-1668(ra) # a44 <execve>
      d0:	70a2                	ld	ra,40(sp)
      d2:	7402                	ld	s0,32(sp)
      d4:	64e2                	ld	s1,24(sp)
      d6:	6145                	addi	sp,sp,48
      d8:	8082                	ret
      da:	0068                	addi	a0,sp,12
      dc:	00001097          	auipc	ra,0x1
      e0:	848080e7          	jalr	-1976(ra) # 924 <wait>
      e4:	47b2                	lw	a5,12(sp)
      e6:	0007c963          	bltz	a5,f8 <test+0x4c>
      ea:	85a6                	mv	a1,s1
      ec:	8522                	mv	a0,s0
      ee:	00000097          	auipc	ra,0x0
      f2:	f12080e7          	jalr	-238(ra) # 0 <print_success>
      f6:	bfe9                	j	d0 <test+0x24>
      f8:	85a6                	mv	a1,s1
      fa:	8522                	mv	a0,s0
      fc:	00000097          	auipc	ra,0x0
     100:	f5a080e7          	jalr	-166(ra) # 56 <print_fail>
     104:	b7f1                	j	d0 <test+0x24>

0000000000000106 <main>:
     106:	b6010113          	addi	sp,sp,-1184
     10a:	48113c23          	sd	ra,1176(sp)
     10e:	48813823          	sd	s0,1168(sp)
     112:	4589                	li	a1,2
     114:	00001517          	auipc	a0,0x1
     118:	07450513          	addi	a0,a0,116 # 1188 <malloc+0x1fa>
     11c:	00001097          	auipc	ra,0x1
     120:	810080e7          	jalr	-2032(ra) # 92c <open>
     124:	4501                	li	a0,0
     126:	00001097          	auipc	ra,0x1
     12a:	81e080e7          	jalr	-2018(ra) # 944 <dup>
     12e:	4501                	li	a0,0
     130:	00001097          	auipc	ra,0x1
     134:	814080e7          	jalr	-2028(ra) # 944 <dup>
     138:	00001717          	auipc	a4,0x1
     13c:	05870713          	addi	a4,a4,88 # 1190 <malloc+0x202>
     140:	46e13c23          	sd	a4,1144(sp)
     144:	00001797          	auipc	a5,0x1
     148:	05478793          	addi	a5,a5,84 # 1198 <malloc+0x20a>
     14c:	48f13023          	sd	a5,1152(sp)
     150:	48013423          	sd	zero,1160(sp)
     154:	00001797          	auipc	a5,0x1
     158:	f1c78793          	addi	a5,a5,-228 # 1070 <malloc+0xe2>
     15c:	44f13c23          	sd	a5,1112(sp)
     160:	00001697          	auipc	a3,0x1
     164:	f1868693          	addi	a3,a3,-232 # 1078 <malloc+0xea>
     168:	46d13023          	sd	a3,1120(sp)
     16c:	00001797          	auipc	a5,0x1
     170:	f1478793          	addi	a5,a5,-236 # 1080 <malloc+0xf2>
     174:	46f13423          	sd	a5,1128(sp)
     178:	46013823          	sd	zero,1136(sp)
     17c:	00001617          	auipc	a2,0x1
     180:	f0c60613          	addi	a2,a2,-244 # 1088 <malloc+0xfa>
     184:	42c13c23          	sd	a2,1080(sp)
     188:	44d13023          	sd	a3,1088(sp)
     18c:	44f13423          	sd	a5,1096(sp)
     190:	44013823          	sd	zero,1104(sp)
     194:	00001797          	auipc	a5,0x1
     198:	02478793          	addi	a5,a5,36 # 11b8 <malloc+0x22a>
     19c:	42f13023          	sd	a5,1056(sp)
     1a0:	00001797          	auipc	a5,0x1
     1a4:	02878793          	addi	a5,a5,40 # 11c8 <malloc+0x23a>
     1a8:	42f13423          	sd	a5,1064(sp)
     1ac:	42013823          	sd	zero,1072(sp)
     1b0:	00001697          	auipc	a3,0x1
     1b4:	02868693          	addi	a3,a3,40 # 11d8 <malloc+0x24a>
     1b8:	40d13823          	sd	a3,1040(sp)
     1bc:	40013c23          	sd	zero,1048(sp)
     1c0:	00001697          	auipc	a3,0x1
     1c4:	02068693          	addi	a3,a3,32 # 11e0 <malloc+0x252>
     1c8:	40d13023          	sd	a3,1024(sp)
     1cc:	40013423          	sd	zero,1032(sp)
     1d0:	00001697          	auipc	a3,0x1
     1d4:	01868693          	addi	a3,a3,24 # 11e8 <malloc+0x25a>
     1d8:	3ed13823          	sd	a3,1008(sp)
     1dc:	3e013c23          	sd	zero,1016(sp)
     1e0:	00001697          	auipc	a3,0x1
     1e4:	01068693          	addi	a3,a3,16 # 11f0 <malloc+0x262>
     1e8:	3ed13023          	sd	a3,992(sp)
     1ec:	3e013423          	sd	zero,1000(sp)
     1f0:	00001697          	auipc	a3,0x1
     1f4:	00868693          	addi	a3,a3,8 # 11f8 <malloc+0x26a>
     1f8:	3cd13423          	sd	a3,968(sp)
     1fc:	3cf13823          	sd	a5,976(sp)
     200:	3c013c23          	sd	zero,984(sp)
     204:	00001797          	auipc	a5,0x1
     208:	ffc78793          	addi	a5,a5,-4 # 1200 <malloc+0x272>
     20c:	3af13c23          	sd	a5,952(sp)
     210:	3c013023          	sd	zero,960(sp)
     214:	00001797          	auipc	a5,0x1
     218:	19478793          	addi	a5,a5,404 # 13a8 <malloc+0x41a>
     21c:	0007b803          	ld	a6,0(a5)
     220:	6788                	ld	a0,8(a5)
     222:	6b8c                	ld	a1,16(a5)
     224:	6f90                	ld	a2,24(a5)
     226:	7394                	ld	a3,32(a5)
     228:	39013823          	sd	a6,912(sp)
     22c:	38a13c23          	sd	a0,920(sp)
     230:	3ab13023          	sd	a1,928(sp)
     234:	3ac13423          	sd	a2,936(sp)
     238:	3ad13823          	sd	a3,944(sp)
     23c:	00001697          	auipc	a3,0x1
     240:	fcc68693          	addi	a3,a3,-52 # 1208 <malloc+0x27a>
     244:	38d13023          	sd	a3,896(sp)
     248:	38013423          	sd	zero,904(sp)
     24c:	00001697          	auipc	a3,0x1
     250:	fc468693          	addi	a3,a3,-60 # 1210 <malloc+0x282>
     254:	36d13823          	sd	a3,880(sp)
     258:	36013c23          	sd	zero,888(sp)
     25c:	00001697          	auipc	a3,0x1
     260:	fbc68693          	addi	a3,a3,-68 # 1218 <malloc+0x28a>
     264:	34d13c23          	sd	a3,856(sp)
     268:	00001697          	auipc	a3,0x1
     26c:	fb868693          	addi	a3,a3,-72 # 1220 <malloc+0x292>
     270:	36d13023          	sd	a3,864(sp)
     274:	36013423          	sd	zero,872(sp)
     278:	00001617          	auipc	a2,0x1
     27c:	fb060613          	addi	a2,a2,-80 # 1228 <malloc+0x29a>
     280:	34c13423          	sd	a2,840(sp)
     284:	34013823          	sd	zero,848(sp)
     288:	00001617          	auipc	a2,0x1
     28c:	fa860613          	addi	a2,a2,-88 # 1230 <malloc+0x2a2>
     290:	32c13c23          	sd	a2,824(sp)
     294:	34013023          	sd	zero,832(sp)
     298:	00001617          	auipc	a2,0x1
     29c:	fa060613          	addi	a2,a2,-96 # 1238 <malloc+0x2aa>
     2a0:	32c13023          	sd	a2,800(sp)
     2a4:	00001617          	auipc	a2,0x1
     2a8:	f9c60613          	addi	a2,a2,-100 # 1240 <malloc+0x2b2>
     2ac:	32c13423          	sd	a2,808(sp)
     2b0:	32013823          	sd	zero,816(sp)
     2b4:	00001617          	auipc	a2,0x1
     2b8:	f9460613          	addi	a2,a2,-108 # 1248 <malloc+0x2ba>
     2bc:	30c13823          	sd	a2,784(sp)
     2c0:	30013c23          	sd	zero,792(sp)
     2c4:	00001617          	auipc	a2,0x1
     2c8:	f8c60613          	addi	a2,a2,-116 # 1250 <malloc+0x2c2>
     2cc:	30c13023          	sd	a2,768(sp)
     2d0:	30013423          	sd	zero,776(sp)
     2d4:	00001617          	auipc	a2,0x1
     2d8:	f8460613          	addi	a2,a2,-124 # 1258 <malloc+0x2ca>
     2dc:	2ec13823          	sd	a2,752(sp)
     2e0:	2e013c23          	sd	zero,760(sp)
     2e4:	00001617          	auipc	a2,0x1
     2e8:	f7c60613          	addi	a2,a2,-132 # 1260 <malloc+0x2d2>
     2ec:	2cc13c23          	sd	a2,728(sp)
     2f0:	00001617          	auipc	a2,0x1
     2f4:	f7860613          	addi	a2,a2,-136 # 1268 <malloc+0x2da>
     2f8:	2ec13023          	sd	a2,736(sp)
     2fc:	2e013423          	sd	zero,744(sp)
     300:	2cd13423          	sd	a3,712(sp)
     304:	2c013823          	sd	zero,720(sp)
     308:	00001697          	auipc	a3,0x1
     30c:	f6868693          	addi	a3,a3,-152 # 1270 <malloc+0x2e2>
     310:	2ad13c23          	sd	a3,696(sp)
     314:	2c013023          	sd	zero,704(sp)
     318:	2ae13023          	sd	a4,672(sp)
     31c:	00001717          	auipc	a4,0x1
     320:	f5c70713          	addi	a4,a4,-164 # 1278 <malloc+0x2ea>
     324:	2ae13423          	sd	a4,680(sp)
     328:	2a013823          	sd	zero,688(sp)
     32c:	00001717          	auipc	a4,0x1
     330:	f6c70713          	addi	a4,a4,-148 # 1298 <malloc+0x30a>
     334:	28e13423          	sd	a4,648(sp)
     338:	00001417          	auipc	s0,0x1
     33c:	d8040413          	addi	s0,s0,-640 # 10b8 <malloc+0x12a>
     340:	28813823          	sd	s0,656(sp)
     344:	28013c23          	sd	zero,664(sp)
     348:	00001717          	auipc	a4,0x1
     34c:	f5870713          	addi	a4,a4,-168 # 12a0 <malloc+0x312>
     350:	26e13823          	sd	a4,624(sp)
     354:	26813c23          	sd	s0,632(sp)
     358:	28013023          	sd	zero,640(sp)
     35c:	7788                	ld	a0,40(a5)
     35e:	7b8c                	ld	a1,48(a5)
     360:	7f90                	ld	a2,56(a5)
     362:	63b4                	ld	a3,64(a5)
     364:	67b8                	ld	a4,72(a5)
     366:	24a13423          	sd	a0,584(sp)
     36a:	24b13823          	sd	a1,592(sp)
     36e:	24c13c23          	sd	a2,600(sp)
     372:	26d13023          	sd	a3,608(sp)
     376:	26e13423          	sd	a4,616(sp)
     37a:	00001717          	auipc	a4,0x1
     37e:	f2e70713          	addi	a4,a4,-210 # 12a8 <malloc+0x31a>
     382:	22e13823          	sd	a4,560(sp)
     386:	22813c23          	sd	s0,568(sp)
     38a:	24013023          	sd	zero,576(sp)
     38e:	00001717          	auipc	a4,0x1
     392:	f2270713          	addi	a4,a4,-222 # 12b0 <malloc+0x322>
     396:	20e13c23          	sd	a4,536(sp)
     39a:	22813023          	sd	s0,544(sp)
     39e:	22013423          	sd	zero,552(sp)
     3a2:	00001717          	auipc	a4,0x1
     3a6:	f1670713          	addi	a4,a4,-234 # 12b8 <malloc+0x32a>
     3aa:	20e13023          	sd	a4,512(sp)
     3ae:	20813423          	sd	s0,520(sp)
     3b2:	20013823          	sd	zero,528(sp)
     3b6:	00001717          	auipc	a4,0x1
     3ba:	d1270713          	addi	a4,a4,-750 # 10c8 <malloc+0x13a>
     3be:	f3ba                	sd	a4,480(sp)
     3c0:	00001717          	auipc	a4,0x1
     3c4:	d1070713          	addi	a4,a4,-752 # 10d0 <malloc+0x142>
     3c8:	f7ba                	sd	a4,488(sp)
     3ca:	fba2                	sd	s0,496(sp)
     3cc:	ff82                	sd	zero,504(sp)
     3ce:	00001717          	auipc	a4,0x1
     3d2:	ef270713          	addi	a4,a4,-270 # 12c0 <malloc+0x332>
     3d6:	e7ba                	sd	a4,456(sp)
     3d8:	eba2                	sd	s0,464(sp)
     3da:	ef82                	sd	zero,472(sp)
     3dc:	00001717          	auipc	a4,0x1
     3e0:	eec70713          	addi	a4,a4,-276 # 12c8 <malloc+0x33a>
     3e4:	fb3a                	sd	a4,432(sp)
     3e6:	ff22                	sd	s0,440(sp)
     3e8:	e382                	sd	zero,448(sp)
     3ea:	00001717          	auipc	a4,0x1
     3ee:	ee670713          	addi	a4,a4,-282 # 12d0 <malloc+0x342>
     3f2:	ef3a                	sd	a4,408(sp)
     3f4:	f322                	sd	s0,416(sp)
     3f6:	f702                	sd	zero,424(sp)
     3f8:	00001717          	auipc	a4,0x1
     3fc:	ee070713          	addi	a4,a4,-288 # 12d8 <malloc+0x34a>
     400:	e33a                	sd	a4,384(sp)
     402:	e722                	sd	s0,392(sp)
     404:	eb02                	sd	zero,400(sp)
     406:	6bac                	ld	a1,80(a5)
     408:	6fb0                	ld	a2,88(a5)
     40a:	73b4                	ld	a3,96(a5)
     40c:	77b8                	ld	a4,104(a5)
     40e:	7bbc                	ld	a5,112(a5)
     410:	eeae                	sd	a1,344(sp)
     412:	f2b2                	sd	a2,352(sp)
     414:	f6b6                	sd	a3,360(sp)
     416:	faba                	sd	a4,368(sp)
     418:	febe                	sd	a5,376(sp)
     41a:	00001797          	auipc	a5,0x1
     41e:	ec678793          	addi	a5,a5,-314 # 12e0 <malloc+0x352>
     422:	e2be                	sd	a5,320(sp)
     424:	e6a2                	sd	s0,328(sp)
     426:	ea82                	sd	zero,336(sp)
     428:	00001797          	auipc	a5,0x1
     42c:	ec078793          	addi	a5,a5,-320 # 12e8 <malloc+0x35a>
     430:	f63e                	sd	a5,296(sp)
     432:	fa22                	sd	s0,304(sp)
     434:	fe02                	sd	zero,312(sp)
     436:	00001797          	auipc	a5,0x1
     43a:	eba78793          	addi	a5,a5,-326 # 12f0 <malloc+0x362>
     43e:	ea3e                	sd	a5,272(sp)
     440:	00001797          	auipc	a5,0x1
     444:	cb878793          	addi	a5,a5,-840 # 10f8 <malloc+0x16a>
     448:	ee3e                	sd	a5,280(sp)
     44a:	f202                	sd	zero,288(sp)
     44c:	00001797          	auipc	a5,0x1
     450:	eac78793          	addi	a5,a5,-340 # 12f8 <malloc+0x36a>
     454:	fdbe                	sd	a5,248(sp)
     456:	00001797          	auipc	a5,0x1
     45a:	cb278793          	addi	a5,a5,-846 # 1108 <malloc+0x17a>
     45e:	e23e                	sd	a5,256(sp)
     460:	e602                	sd	zero,264(sp)
     462:	00001797          	auipc	a5,0x1
     466:	cae78793          	addi	a5,a5,-850 # 1110 <malloc+0x182>
     46a:	edbe                	sd	a5,216(sp)
     46c:	00001797          	auipc	a5,0x1
     470:	cac78793          	addi	a5,a5,-852 # 1118 <malloc+0x18a>
     474:	f1be                	sd	a5,224(sp)
     476:	00001797          	auipc	a5,0x1
     47a:	caa78793          	addi	a5,a5,-854 # 1120 <malloc+0x192>
     47e:	f5be                	sd	a5,232(sp)
     480:	f982                	sd	zero,240(sp)
     482:	00001717          	auipc	a4,0x1
     486:	cae70713          	addi	a4,a4,-850 # 1130 <malloc+0x1a2>
     48a:	fd3a                	sd	a4,184(sp)
     48c:	e1be                	sd	a5,192(sp)
     48e:	00001717          	auipc	a4,0x1
     492:	caa70713          	addi	a4,a4,-854 # 1138 <malloc+0x1aa>
     496:	e5ba                	sd	a4,200(sp)
     498:	e982                	sd	zero,208(sp)
     49a:	00001717          	auipc	a4,0x1
     49e:	cae70713          	addi	a4,a4,-850 # 1148 <malloc+0x1ba>
     4a2:	ed3a                	sd	a4,152(sp)
     4a4:	00001717          	auipc	a4,0x1
     4a8:	cac70713          	addi	a4,a4,-852 # 1150 <malloc+0x1c2>
     4ac:	f13a                	sd	a4,160(sp)
     4ae:	f53e                	sd	a5,168(sp)
     4b0:	f902                	sd	zero,176(sp)
     4b2:	00001797          	auipc	a5,0x1
     4b6:	e4e78793          	addi	a5,a5,-434 # 1300 <malloc+0x372>
     4ba:	e53e                	sd	a5,136(sp)
     4bc:	e902                	sd	zero,144(sp)
     4be:	00001797          	auipc	a5,0x1
     4c2:	e5278793          	addi	a5,a5,-430 # 1310 <malloc+0x382>
     4c6:	fcbe                	sd	a5,120(sp)
     4c8:	e102                	sd	zero,128(sp)
     4ca:	00001797          	auipc	a5,0x1
     4ce:	e5678793          	addi	a5,a5,-426 # 1320 <malloc+0x392>
     4d2:	f4be                	sd	a5,104(sp)
     4d4:	f882                	sd	zero,112(sp)
     4d6:	00001797          	auipc	a5,0x1
     4da:	e5a78793          	addi	a5,a5,-422 # 1330 <malloc+0x3a2>
     4de:	ecbe                	sd	a5,88(sp)
     4e0:	f082                	sd	zero,96(sp)
     4e2:	00001797          	auipc	a5,0x1
     4e6:	e5e78793          	addi	a5,a5,-418 # 1340 <malloc+0x3b2>
     4ea:	e4be                	sd	a5,72(sp)
     4ec:	e882                	sd	zero,80(sp)
     4ee:	00001797          	auipc	a5,0x1
     4f2:	e6278793          	addi	a5,a5,-414 # 1350 <malloc+0x3c2>
     4f6:	fc3e                	sd	a5,56(sp)
     4f8:	e082                	sd	zero,64(sp)
     4fa:	00001797          	auipc	a5,0x1
     4fe:	e6678793          	addi	a5,a5,-410 # 1360 <malloc+0x3d2>
     502:	f43e                	sd	a5,40(sp)
     504:	f802                	sd	zero,48(sp)
     506:	00001797          	auipc	a5,0x1
     50a:	e6a78793          	addi	a5,a5,-406 # 1370 <malloc+0x3e2>
     50e:	ec3e                	sd	a5,24(sp)
     510:	f002                	sd	zero,32(sp)
     512:	00001797          	auipc	a5,0x1
     516:	e6e78793          	addi	a5,a5,-402 # 1380 <malloc+0x3f2>
     51a:	e43e                	sd	a5,8(sp)
     51c:	e802                	sd	zero,16(sp)
     51e:	47810593          	addi	a1,sp,1144
     522:	00001517          	auipc	a0,0x1
     526:	e6e50513          	addi	a0,a0,-402 # 1390 <malloc+0x402>
     52a:	00000097          	auipc	ra,0x0
     52e:	b82080e7          	jalr	-1150(ra) # ac <test>
     532:	45810593          	addi	a1,sp,1112
     536:	00001517          	auipc	a0,0x1
     53a:	e5a50513          	addi	a0,a0,-422 # 1390 <malloc+0x402>
     53e:	00000097          	auipc	ra,0x0
     542:	b6e080e7          	jalr	-1170(ra) # ac <test>
     546:	43810593          	addi	a1,sp,1080
     54a:	00001517          	auipc	a0,0x1
     54e:	e4650513          	addi	a0,a0,-442 # 1390 <malloc+0x402>
     552:	00000097          	auipc	ra,0x0
     556:	b5a080e7          	jalr	-1190(ra) # ac <test>
     55a:	42010593          	addi	a1,sp,1056
     55e:	00001517          	auipc	a0,0x1
     562:	e3250513          	addi	a0,a0,-462 # 1390 <malloc+0x402>
     566:	00000097          	auipc	ra,0x0
     56a:	b46080e7          	jalr	-1210(ra) # ac <test>
     56e:	41010593          	addi	a1,sp,1040
     572:	00001517          	auipc	a0,0x1
     576:	e1e50513          	addi	a0,a0,-482 # 1390 <malloc+0x402>
     57a:	00000097          	auipc	ra,0x0
     57e:	b32080e7          	jalr	-1230(ra) # ac <test>
     582:	40010593          	addi	a1,sp,1024
     586:	00001517          	auipc	a0,0x1
     58a:	e0a50513          	addi	a0,a0,-502 # 1390 <malloc+0x402>
     58e:	00000097          	auipc	ra,0x0
     592:	b1e080e7          	jalr	-1250(ra) # ac <test>
     596:	1f8c                	addi	a1,sp,1008
     598:	00001517          	auipc	a0,0x1
     59c:	df850513          	addi	a0,a0,-520 # 1390 <malloc+0x402>
     5a0:	00000097          	auipc	ra,0x0
     5a4:	b0c080e7          	jalr	-1268(ra) # ac <test>
     5a8:	178c                	addi	a1,sp,992
     5aa:	00001517          	auipc	a0,0x1
     5ae:	de650513          	addi	a0,a0,-538 # 1390 <malloc+0x402>
     5b2:	00000097          	auipc	ra,0x0
     5b6:	afa080e7          	jalr	-1286(ra) # ac <test>
     5ba:	07ac                	addi	a1,sp,968
     5bc:	00001517          	auipc	a0,0x1
     5c0:	dd450513          	addi	a0,a0,-556 # 1390 <malloc+0x402>
     5c4:	00000097          	auipc	ra,0x0
     5c8:	ae8080e7          	jalr	-1304(ra) # ac <test>
     5cc:	1f2c                	addi	a1,sp,952
     5ce:	00001517          	auipc	a0,0x1
     5d2:	dc250513          	addi	a0,a0,-574 # 1390 <malloc+0x402>
     5d6:	00000097          	auipc	ra,0x0
     5da:	ad6080e7          	jalr	-1322(ra) # ac <test>
     5de:	0f0c                	addi	a1,sp,912
     5e0:	00001517          	auipc	a0,0x1
     5e4:	db050513          	addi	a0,a0,-592 # 1390 <malloc+0x402>
     5e8:	00000097          	auipc	ra,0x0
     5ec:	ac4080e7          	jalr	-1340(ra) # ac <test>
     5f0:	070c                	addi	a1,sp,896
     5f2:	00001517          	auipc	a0,0x1
     5f6:	d9e50513          	addi	a0,a0,-610 # 1390 <malloc+0x402>
     5fa:	00000097          	auipc	ra,0x0
     5fe:	ab2080e7          	jalr	-1358(ra) # ac <test>
     602:	1e8c                	addi	a1,sp,880
     604:	00001517          	auipc	a0,0x1
     608:	d8c50513          	addi	a0,a0,-628 # 1390 <malloc+0x402>
     60c:	00000097          	auipc	ra,0x0
     610:	aa0080e7          	jalr	-1376(ra) # ac <test>
     614:	0eac                	addi	a1,sp,856
     616:	00001517          	auipc	a0,0x1
     61a:	d7a50513          	addi	a0,a0,-646 # 1390 <malloc+0x402>
     61e:	00000097          	auipc	ra,0x0
     622:	a8e080e7          	jalr	-1394(ra) # ac <test>
     626:	06ac                	addi	a1,sp,840
     628:	00001517          	auipc	a0,0x1
     62c:	d6850513          	addi	a0,a0,-664 # 1390 <malloc+0x402>
     630:	00000097          	auipc	ra,0x0
     634:	a7c080e7          	jalr	-1412(ra) # ac <test>
     638:	1e2c                	addi	a1,sp,824
     63a:	00001517          	auipc	a0,0x1
     63e:	d5650513          	addi	a0,a0,-682 # 1390 <malloc+0x402>
     642:	00000097          	auipc	ra,0x0
     646:	a6a080e7          	jalr	-1430(ra) # ac <test>
     64a:	160c                	addi	a1,sp,800
     64c:	00001517          	auipc	a0,0x1
     650:	d4450513          	addi	a0,a0,-700 # 1390 <malloc+0x402>
     654:	00000097          	auipc	ra,0x0
     658:	a58080e7          	jalr	-1448(ra) # ac <test>
     65c:	0e0c                	addi	a1,sp,784
     65e:	00001517          	auipc	a0,0x1
     662:	d3250513          	addi	a0,a0,-718 # 1390 <malloc+0x402>
     666:	00000097          	auipc	ra,0x0
     66a:	a46080e7          	jalr	-1466(ra) # ac <test>
     66e:	1d8c                	addi	a1,sp,752
     670:	00001517          	auipc	a0,0x1
     674:	d2050513          	addi	a0,a0,-736 # 1390 <malloc+0x402>
     678:	00000097          	auipc	ra,0x0
     67c:	a34080e7          	jalr	-1484(ra) # ac <test>
     680:	0dac                	addi	a1,sp,728
     682:	00001517          	auipc	a0,0x1
     686:	d0e50513          	addi	a0,a0,-754 # 1390 <malloc+0x402>
     68a:	00000097          	auipc	ra,0x0
     68e:	a22080e7          	jalr	-1502(ra) # ac <test>
     692:	05ac                	addi	a1,sp,712
     694:	00001517          	auipc	a0,0x1
     698:	cfc50513          	addi	a0,a0,-772 # 1390 <malloc+0x402>
     69c:	00000097          	auipc	ra,0x0
     6a0:	a10080e7          	jalr	-1520(ra) # ac <test>
     6a4:	1d2c                	addi	a1,sp,696
     6a6:	00001517          	auipc	a0,0x1
     6aa:	cea50513          	addi	a0,a0,-790 # 1390 <malloc+0x402>
     6ae:	00000097          	auipc	ra,0x0
     6b2:	9fe080e7          	jalr	-1538(ra) # ac <test>
     6b6:	060c                	addi	a1,sp,768
     6b8:	00001517          	auipc	a0,0x1
     6bc:	cd850513          	addi	a0,a0,-808 # 1390 <malloc+0x402>
     6c0:	00000097          	auipc	ra,0x0
     6c4:	9ec080e7          	jalr	-1556(ra) # ac <test>
     6c8:	150c                	addi	a1,sp,672
     6ca:	00001517          	auipc	a0,0x1
     6ce:	cc650513          	addi	a0,a0,-826 # 1390 <malloc+0x402>
     6d2:	00000097          	auipc	ra,0x0
     6d6:	9da080e7          	jalr	-1574(ra) # ac <test>
     6da:	052c                	addi	a1,sp,648
     6dc:	00001517          	auipc	a0,0x1
     6e0:	cb450513          	addi	a0,a0,-844 # 1390 <malloc+0x402>
     6e4:	00000097          	auipc	ra,0x0
     6e8:	9c8080e7          	jalr	-1592(ra) # ac <test>
     6ec:	4589                	li	a1,2
     6ee:	8522                	mv	a0,s0
     6f0:	00000097          	auipc	ra,0x0
     6f4:	23c080e7          	jalr	572(ra) # 92c <open>
     6f8:	842a                	mv	s0,a0
     6fa:	20054763          	bltz	a0,908 <main+0x802>
     6fe:	4635                	li	a2,13
     700:	00001597          	auipc	a1,0x1
     704:	c9858593          	addi	a1,a1,-872 # 1398 <malloc+0x40a>
     708:	8522                	mv	a0,s0
     70a:	00000097          	auipc	ra,0x0
     70e:	2b8080e7          	jalr	696(ra) # 9c2 <write>
     712:	20054063          	bltz	a0,912 <main+0x80c>
     716:	8522                	mv	a0,s0
     718:	00000097          	auipc	ra,0x0
     71c:	282080e7          	jalr	642(ra) # 99a <close>
     720:	1c8c                	addi	a1,sp,624
     722:	00001517          	auipc	a0,0x1
     726:	c6e50513          	addi	a0,a0,-914 # 1390 <malloc+0x402>
     72a:	00000097          	auipc	ra,0x0
     72e:	982080e7          	jalr	-1662(ra) # ac <test>
     732:	04ac                	addi	a1,sp,584
     734:	00001517          	auipc	a0,0x1
     738:	c5c50513          	addi	a0,a0,-932 # 1390 <malloc+0x402>
     73c:	00000097          	auipc	ra,0x0
     740:	970080e7          	jalr	-1680(ra) # ac <test>
     744:	1c0c                	addi	a1,sp,560
     746:	00001517          	auipc	a0,0x1
     74a:	c4a50513          	addi	a0,a0,-950 # 1390 <malloc+0x402>
     74e:	00000097          	auipc	ra,0x0
     752:	95e080e7          	jalr	-1698(ra) # ac <test>
     756:	0c2c                	addi	a1,sp,536
     758:	00001517          	auipc	a0,0x1
     75c:	c3850513          	addi	a0,a0,-968 # 1390 <malloc+0x402>
     760:	00000097          	auipc	ra,0x0
     764:	94c080e7          	jalr	-1716(ra) # ac <test>
     768:	040c                	addi	a1,sp,512
     76a:	00001517          	auipc	a0,0x1
     76e:	c2650513          	addi	a0,a0,-986 # 1390 <malloc+0x402>
     772:	00000097          	auipc	ra,0x0
     776:	93a080e7          	jalr	-1734(ra) # ac <test>
     77a:	138c                	addi	a1,sp,480
     77c:	00001517          	auipc	a0,0x1
     780:	c1450513          	addi	a0,a0,-1004 # 1390 <malloc+0x402>
     784:	00000097          	auipc	ra,0x0
     788:	928080e7          	jalr	-1752(ra) # ac <test>
     78c:	03ac                	addi	a1,sp,456
     78e:	00001517          	auipc	a0,0x1
     792:	c0250513          	addi	a0,a0,-1022 # 1390 <malloc+0x402>
     796:	00000097          	auipc	ra,0x0
     79a:	916080e7          	jalr	-1770(ra) # ac <test>
     79e:	1b0c                	addi	a1,sp,432
     7a0:	00001517          	auipc	a0,0x1
     7a4:	bf050513          	addi	a0,a0,-1040 # 1390 <malloc+0x402>
     7a8:	00000097          	auipc	ra,0x0
     7ac:	904080e7          	jalr	-1788(ra) # ac <test>
     7b0:	0b2c                	addi	a1,sp,408
     7b2:	00001517          	auipc	a0,0x1
     7b6:	bde50513          	addi	a0,a0,-1058 # 1390 <malloc+0x402>
     7ba:	00000097          	auipc	ra,0x0
     7be:	8f2080e7          	jalr	-1806(ra) # ac <test>
     7c2:	030c                	addi	a1,sp,384
     7c4:	00001517          	auipc	a0,0x1
     7c8:	bcc50513          	addi	a0,a0,-1076 # 1390 <malloc+0x402>
     7cc:	00000097          	auipc	ra,0x0
     7d0:	8e0080e7          	jalr	-1824(ra) # ac <test>
     7d4:	0aac                	addi	a1,sp,344
     7d6:	00001517          	auipc	a0,0x1
     7da:	bba50513          	addi	a0,a0,-1094 # 1390 <malloc+0x402>
     7de:	00000097          	auipc	ra,0x0
     7e2:	8ce080e7          	jalr	-1842(ra) # ac <test>
     7e6:	028c                	addi	a1,sp,320
     7e8:	00001517          	auipc	a0,0x1
     7ec:	ba850513          	addi	a0,a0,-1112 # 1390 <malloc+0x402>
     7f0:	00000097          	auipc	ra,0x0
     7f4:	8bc080e7          	jalr	-1860(ra) # ac <test>
     7f8:	122c                	addi	a1,sp,296
     7fa:	00001517          	auipc	a0,0x1
     7fe:	b9650513          	addi	a0,a0,-1130 # 1390 <malloc+0x402>
     802:	00000097          	auipc	ra,0x0
     806:	8aa080e7          	jalr	-1878(ra) # ac <test>
     80a:	0a0c                	addi	a1,sp,272
     80c:	00001517          	auipc	a0,0x1
     810:	b8450513          	addi	a0,a0,-1148 # 1390 <malloc+0x402>
     814:	00000097          	auipc	ra,0x0
     818:	898080e7          	jalr	-1896(ra) # ac <test>
     81c:	19ac                	addi	a1,sp,248
     81e:	00001517          	auipc	a0,0x1
     822:	b7250513          	addi	a0,a0,-1166 # 1390 <malloc+0x402>
     826:	00000097          	auipc	ra,0x0
     82a:	886080e7          	jalr	-1914(ra) # ac <test>
     82e:	09ac                	addi	a1,sp,216
     830:	00001517          	auipc	a0,0x1
     834:	b6050513          	addi	a0,a0,-1184 # 1390 <malloc+0x402>
     838:	00000097          	auipc	ra,0x0
     83c:	874080e7          	jalr	-1932(ra) # ac <test>
     840:	192c                	addi	a1,sp,184
     842:	00001517          	auipc	a0,0x1
     846:	b4e50513          	addi	a0,a0,-1202 # 1390 <malloc+0x402>
     84a:	00000097          	auipc	ra,0x0
     84e:	862080e7          	jalr	-1950(ra) # ac <test>
     852:	092c                	addi	a1,sp,152
     854:	00001517          	auipc	a0,0x1
     858:	b3c50513          	addi	a0,a0,-1220 # 1390 <malloc+0x402>
     85c:	00000097          	auipc	ra,0x0
     860:	850080e7          	jalr	-1968(ra) # ac <test>
     864:	012c                	addi	a1,sp,136
     866:	00001517          	auipc	a0,0x1
     86a:	ac250513          	addi	a0,a0,-1342 # 1328 <malloc+0x39a>
     86e:	00000097          	auipc	ra,0x0
     872:	83e080e7          	jalr	-1986(ra) # ac <test>
     876:	18ac                	addi	a1,sp,120
     878:	00001517          	auipc	a0,0x1
     87c:	ab050513          	addi	a0,a0,-1360 # 1328 <malloc+0x39a>
     880:	00000097          	auipc	ra,0x0
     884:	82c080e7          	jalr	-2004(ra) # ac <test>
     888:	10ac                	addi	a1,sp,104
     88a:	00001517          	auipc	a0,0x1
     88e:	a9e50513          	addi	a0,a0,-1378 # 1328 <malloc+0x39a>
     892:	00000097          	auipc	ra,0x0
     896:	81a080e7          	jalr	-2022(ra) # ac <test>
     89a:	08ac                	addi	a1,sp,88
     89c:	00001517          	auipc	a0,0x1
     8a0:	a8c50513          	addi	a0,a0,-1396 # 1328 <malloc+0x39a>
     8a4:	00000097          	auipc	ra,0x0
     8a8:	808080e7          	jalr	-2040(ra) # ac <test>
     8ac:	00ac                	addi	a1,sp,72
     8ae:	00001517          	auipc	a0,0x1
     8b2:	a7a50513          	addi	a0,a0,-1414 # 1328 <malloc+0x39a>
     8b6:	fffff097          	auipc	ra,0xfffff
     8ba:	7f6080e7          	jalr	2038(ra) # ac <test>
     8be:	182c                	addi	a1,sp,56
     8c0:	00001517          	auipc	a0,0x1
     8c4:	a6850513          	addi	a0,a0,-1432 # 1328 <malloc+0x39a>
     8c8:	fffff097          	auipc	ra,0xfffff
     8cc:	7e4080e7          	jalr	2020(ra) # ac <test>
     8d0:	102c                	addi	a1,sp,40
     8d2:	00001517          	auipc	a0,0x1
     8d6:	a5650513          	addi	a0,a0,-1450 # 1328 <malloc+0x39a>
     8da:	fffff097          	auipc	ra,0xfffff
     8de:	7d2080e7          	jalr	2002(ra) # ac <test>
     8e2:	082c                	addi	a1,sp,24
     8e4:	00001517          	auipc	a0,0x1
     8e8:	a4450513          	addi	a0,a0,-1468 # 1328 <malloc+0x39a>
     8ec:	fffff097          	auipc	ra,0xfffff
     8f0:	7c0080e7          	jalr	1984(ra) # ac <test>
     8f4:	002c                	addi	a1,sp,8
     8f6:	00001517          	auipc	a0,0x1
     8fa:	a3250513          	addi	a0,a0,-1486 # 1328 <malloc+0x39a>
     8fe:	fffff097          	auipc	ra,0xfffff
     902:	7ae080e7          	jalr	1966(ra) # ac <test>
     906:	a001                	j	906 <main+0x800>
     908:	00000097          	auipc	ra,0x0
     90c:	15a080e7          	jalr	346(ra) # a62 <kernel_panic>
     910:	b3fd                	j	6fe <main+0x5f8>
     912:	00000097          	auipc	ra,0x0
     916:	150080e7          	jalr	336(ra) # a62 <kernel_panic>
     91a:	bbf5                	j	716 <main+0x610>

000000000000091c <fork>:
     91c:	4885                	li	a7,1
     91e:	00000073          	ecall
     922:	8082                	ret

0000000000000924 <wait>:
     924:	488d                	li	a7,3
     926:	00000073          	ecall
     92a:	8082                	ret

000000000000092c <open>:
     92c:	4889                	li	a7,2
     92e:	00000073          	ecall
     932:	8082                	ret

0000000000000934 <sbrk>:
     934:	4891                	li	a7,4
     936:	00000073          	ecall
     93a:	8082                	ret

000000000000093c <getcwd>:
     93c:	48c5                	li	a7,17
     93e:	00000073          	ecall
     942:	8082                	ret

0000000000000944 <dup>:
     944:	48dd                	li	a7,23
     946:	00000073          	ecall
     94a:	8082                	ret

000000000000094c <dup3>:
     94c:	48e1                	li	a7,24
     94e:	00000073          	ecall
     952:	8082                	ret

0000000000000954 <mkdirat>:
     954:	02200893          	li	a7,34
     958:	00000073          	ecall
     95c:	8082                	ret

000000000000095e <unlinkat>:
     95e:	02300893          	li	a7,35
     962:	00000073          	ecall
     966:	8082                	ret

0000000000000968 <linkat>:
     968:	02500893          	li	a7,37
     96c:	00000073          	ecall
     970:	8082                	ret

0000000000000972 <umount2>:
     972:	02700893          	li	a7,39
     976:	00000073          	ecall
     97a:	8082                	ret

000000000000097c <mount>:
     97c:	02800893          	li	a7,40
     980:	00000073          	ecall
     984:	8082                	ret

0000000000000986 <chdir>:
     986:	03100893          	li	a7,49
     98a:	00000073          	ecall
     98e:	8082                	ret

0000000000000990 <openat>:
     990:	03800893          	li	a7,56
     994:	00000073          	ecall
     998:	8082                	ret

000000000000099a <close>:
     99a:	03900893          	li	a7,57
     99e:	00000073          	ecall
     9a2:	8082                	ret

00000000000009a4 <pipe2>:
     9a4:	03b00893          	li	a7,59
     9a8:	00000073          	ecall
     9ac:	8082                	ret

00000000000009ae <getdents64>:
     9ae:	03d00893          	li	a7,61
     9b2:	00000073          	ecall
     9b6:	8082                	ret

00000000000009b8 <read>:
     9b8:	03f00893          	li	a7,63
     9bc:	00000073          	ecall
     9c0:	8082                	ret

00000000000009c2 <write>:
     9c2:	04000893          	li	a7,64
     9c6:	00000073          	ecall
     9ca:	8082                	ret

00000000000009cc <fstat>:
     9cc:	05000893          	li	a7,80
     9d0:	00000073          	ecall
     9d4:	8082                	ret

00000000000009d6 <exit>:
     9d6:	05d00893          	li	a7,93
     9da:	00000073          	ecall
     9de:	8082                	ret

00000000000009e0 <nanosleep>:
     9e0:	06500893          	li	a7,101
     9e4:	00000073          	ecall
     9e8:	8082                	ret

00000000000009ea <sched_yield>:
     9ea:	07c00893          	li	a7,124
     9ee:	00000073          	ecall
     9f2:	8082                	ret

00000000000009f4 <times>:
     9f4:	09900893          	li	a7,153
     9f8:	00000073          	ecall
     9fc:	8082                	ret

00000000000009fe <uname>:
     9fe:	0a000893          	li	a7,160
     a02:	00000073          	ecall
     a06:	8082                	ret

0000000000000a08 <gettimeofday>:
     a08:	0a900893          	li	a7,169
     a0c:	00000073          	ecall
     a10:	8082                	ret

0000000000000a12 <brk>:
     a12:	0d600893          	li	a7,214
     a16:	00000073          	ecall
     a1a:	8082                	ret

0000000000000a1c <munmap>:
     a1c:	0d700893          	li	a7,215
     a20:	00000073          	ecall
     a24:	8082                	ret

0000000000000a26 <getpid>:
     a26:	0ac00893          	li	a7,172
     a2a:	00000073          	ecall
     a2e:	8082                	ret

0000000000000a30 <getppid>:
     a30:	0ad00893          	li	a7,173
     a34:	00000073          	ecall
     a38:	8082                	ret

0000000000000a3a <clone>:
     a3a:	0dc00893          	li	a7,220
     a3e:	00000073          	ecall
     a42:	8082                	ret

0000000000000a44 <execve>:
     a44:	0dd00893          	li	a7,221
     a48:	00000073          	ecall
     a4c:	8082                	ret

0000000000000a4e <mmap>:
     a4e:	0de00893          	li	a7,222
     a52:	00000073          	ecall
     a56:	8082                	ret

0000000000000a58 <wait4>:
     a58:	10400893          	li	a7,260
     a5c:	00000073          	ecall
     a60:	8082                	ret

0000000000000a62 <kernel_panic>:
     a62:	18f00893          	li	a7,399
     a66:	00000073          	ecall
     a6a:	8082                	ret

0000000000000a6c <strcpy>:
     a6c:	87aa                	mv	a5,a0
     a6e:	0585                	addi	a1,a1,1
     a70:	0785                	addi	a5,a5,1
     a72:	fff5c703          	lbu	a4,-1(a1)
     a76:	fee78fa3          	sb	a4,-1(a5)
     a7a:	fb75                	bnez	a4,a6e <strcpy+0x2>
     a7c:	8082                	ret

0000000000000a7e <strcmp>:
     a7e:	00054783          	lbu	a5,0(a0)
     a82:	cb91                	beqz	a5,a96 <strcmp+0x18>
     a84:	0005c703          	lbu	a4,0(a1)
     a88:	00f71763          	bne	a4,a5,a96 <strcmp+0x18>
     a8c:	0505                	addi	a0,a0,1
     a8e:	0585                	addi	a1,a1,1
     a90:	00054783          	lbu	a5,0(a0)
     a94:	fbe5                	bnez	a5,a84 <strcmp+0x6>
     a96:	0005c503          	lbu	a0,0(a1)
     a9a:	40a7853b          	subw	a0,a5,a0
     a9e:	8082                	ret

0000000000000aa0 <strlen>:
     aa0:	00054783          	lbu	a5,0(a0)
     aa4:	cf81                	beqz	a5,abc <strlen+0x1c>
     aa6:	0505                	addi	a0,a0,1
     aa8:	87aa                	mv	a5,a0
     aaa:	4685                	li	a3,1
     aac:	9e89                	subw	a3,a3,a0
     aae:	00f6853b          	addw	a0,a3,a5
     ab2:	0785                	addi	a5,a5,1
     ab4:	fff7c703          	lbu	a4,-1(a5)
     ab8:	fb7d                	bnez	a4,aae <strlen+0xe>
     aba:	8082                	ret
     abc:	4501                	li	a0,0
     abe:	8082                	ret

0000000000000ac0 <memset>:
     ac0:	ce09                	beqz	a2,ada <memset+0x1a>
     ac2:	87aa                	mv	a5,a0
     ac4:	fff6071b          	addiw	a4,a2,-1
     ac8:	1702                	slli	a4,a4,0x20
     aca:	9301                	srli	a4,a4,0x20
     acc:	0705                	addi	a4,a4,1
     ace:	972a                	add	a4,a4,a0
     ad0:	00b78023          	sb	a1,0(a5)
     ad4:	0785                	addi	a5,a5,1
     ad6:	fee79de3          	bne	a5,a4,ad0 <memset+0x10>
     ada:	8082                	ret

0000000000000adc <strchr>:
     adc:	00054783          	lbu	a5,0(a0)
     ae0:	cb89                	beqz	a5,af2 <strchr+0x16>
     ae2:	00f58963          	beq	a1,a5,af4 <strchr+0x18>
     ae6:	0505                	addi	a0,a0,1
     ae8:	00054783          	lbu	a5,0(a0)
     aec:	fbfd                	bnez	a5,ae2 <strchr+0x6>
     aee:	4501                	li	a0,0
     af0:	8082                	ret
     af2:	4501                	li	a0,0
     af4:	8082                	ret

0000000000000af6 <gets>:
     af6:	715d                	addi	sp,sp,-80
     af8:	e486                	sd	ra,72(sp)
     afa:	e0a2                	sd	s0,64(sp)
     afc:	fc26                	sd	s1,56(sp)
     afe:	f84a                	sd	s2,48(sp)
     b00:	f44e                	sd	s3,40(sp)
     b02:	f052                	sd	s4,32(sp)
     b04:	ec56                	sd	s5,24(sp)
     b06:	e85a                	sd	s6,16(sp)
     b08:	8b2a                	mv	s6,a0
     b0a:	89ae                	mv	s3,a1
     b0c:	84aa                	mv	s1,a0
     b0e:	4401                	li	s0,0
     b10:	4a29                	li	s4,10
     b12:	4ab5                	li	s5,13
     b14:	8922                	mv	s2,s0
     b16:	2405                	addiw	s0,s0,1
     b18:	03345863          	bge	s0,s3,b48 <gets+0x52>
     b1c:	4605                	li	a2,1
     b1e:	00f10593          	addi	a1,sp,15
     b22:	4501                	li	a0,0
     b24:	00000097          	auipc	ra,0x0
     b28:	e94080e7          	jalr	-364(ra) # 9b8 <read>
     b2c:	00a05e63          	blez	a0,b48 <gets+0x52>
     b30:	00f14783          	lbu	a5,15(sp)
     b34:	00f48023          	sb	a5,0(s1)
     b38:	01478763          	beq	a5,s4,b46 <gets+0x50>
     b3c:	0485                	addi	s1,s1,1
     b3e:	fd579be3          	bne	a5,s5,b14 <gets+0x1e>
     b42:	8922                	mv	s2,s0
     b44:	a011                	j	b48 <gets+0x52>
     b46:	8922                	mv	s2,s0
     b48:	995a                	add	s2,s2,s6
     b4a:	00090023          	sb	zero,0(s2)
     b4e:	855a                	mv	a0,s6
     b50:	60a6                	ld	ra,72(sp)
     b52:	6406                	ld	s0,64(sp)
     b54:	74e2                	ld	s1,56(sp)
     b56:	7942                	ld	s2,48(sp)
     b58:	79a2                	ld	s3,40(sp)
     b5a:	7a02                	ld	s4,32(sp)
     b5c:	6ae2                	ld	s5,24(sp)
     b5e:	6b42                	ld	s6,16(sp)
     b60:	6161                	addi	sp,sp,80
     b62:	8082                	ret

0000000000000b64 <atoi>:
     b64:	86aa                	mv	a3,a0
     b66:	00054603          	lbu	a2,0(a0)
     b6a:	fd06079b          	addiw	a5,a2,-48
     b6e:	0ff7f793          	andi	a5,a5,255
     b72:	4725                	li	a4,9
     b74:	02f76663          	bltu	a4,a5,ba0 <atoi+0x3c>
     b78:	4501                	li	a0,0
     b7a:	45a5                	li	a1,9
     b7c:	0685                	addi	a3,a3,1
     b7e:	0025179b          	slliw	a5,a0,0x2
     b82:	9fa9                	addw	a5,a5,a0
     b84:	0017979b          	slliw	a5,a5,0x1
     b88:	9fb1                	addw	a5,a5,a2
     b8a:	fd07851b          	addiw	a0,a5,-48
     b8e:	0006c603          	lbu	a2,0(a3)
     b92:	fd06071b          	addiw	a4,a2,-48
     b96:	0ff77713          	andi	a4,a4,255
     b9a:	fee5f1e3          	bgeu	a1,a4,b7c <atoi+0x18>
     b9e:	8082                	ret
     ba0:	4501                	li	a0,0
     ba2:	8082                	ret

0000000000000ba4 <memmove>:
     ba4:	02b57463          	bgeu	a0,a1,bcc <memmove+0x28>
     ba8:	04c05663          	blez	a2,bf4 <memmove+0x50>
     bac:	fff6079b          	addiw	a5,a2,-1
     bb0:	1782                	slli	a5,a5,0x20
     bb2:	9381                	srli	a5,a5,0x20
     bb4:	0785                	addi	a5,a5,1
     bb6:	97aa                	add	a5,a5,a0
     bb8:	872a                	mv	a4,a0
     bba:	0585                	addi	a1,a1,1
     bbc:	0705                	addi	a4,a4,1
     bbe:	fff5c683          	lbu	a3,-1(a1)
     bc2:	fed70fa3          	sb	a3,-1(a4)
     bc6:	fee79ae3          	bne	a5,a4,bba <memmove+0x16>
     bca:	8082                	ret
     bcc:	00c50733          	add	a4,a0,a2
     bd0:	95b2                	add	a1,a1,a2
     bd2:	02c05163          	blez	a2,bf4 <memmove+0x50>
     bd6:	fff6079b          	addiw	a5,a2,-1
     bda:	1782                	slli	a5,a5,0x20
     bdc:	9381                	srli	a5,a5,0x20
     bde:	fff7c793          	not	a5,a5
     be2:	97ba                	add	a5,a5,a4
     be4:	15fd                	addi	a1,a1,-1
     be6:	177d                	addi	a4,a4,-1
     be8:	0005c683          	lbu	a3,0(a1)
     bec:	00d70023          	sb	a3,0(a4)
     bf0:	fee79ae3          	bne	a5,a4,be4 <memmove+0x40>
     bf4:	8082                	ret

0000000000000bf6 <memcmp>:
     bf6:	fff6069b          	addiw	a3,a2,-1
     bfa:	c605                	beqz	a2,c22 <memcmp+0x2c>
     bfc:	1682                	slli	a3,a3,0x20
     bfe:	9281                	srli	a3,a3,0x20
     c00:	0685                	addi	a3,a3,1
     c02:	96aa                	add	a3,a3,a0
     c04:	00054783          	lbu	a5,0(a0)
     c08:	0005c703          	lbu	a4,0(a1)
     c0c:	00e79863          	bne	a5,a4,c1c <memcmp+0x26>
     c10:	0505                	addi	a0,a0,1
     c12:	0585                	addi	a1,a1,1
     c14:	fed518e3          	bne	a0,a3,c04 <memcmp+0xe>
     c18:	4501                	li	a0,0
     c1a:	8082                	ret
     c1c:	40e7853b          	subw	a0,a5,a4
     c20:	8082                	ret
     c22:	4501                	li	a0,0
     c24:	8082                	ret

0000000000000c26 <memcpy>:
     c26:	1141                	addi	sp,sp,-16
     c28:	e406                	sd	ra,8(sp)
     c2a:	00000097          	auipc	ra,0x0
     c2e:	f7a080e7          	jalr	-134(ra) # ba4 <memmove>
     c32:	60a2                	ld	ra,8(sp)
     c34:	0141                	addi	sp,sp,16
     c36:	8082                	ret

0000000000000c38 <putc>:
     c38:	1101                	addi	sp,sp,-32
     c3a:	ec06                	sd	ra,24(sp)
     c3c:	00b107a3          	sb	a1,15(sp)
     c40:	4605                	li	a2,1
     c42:	00f10593          	addi	a1,sp,15
     c46:	00000097          	auipc	ra,0x0
     c4a:	d7c080e7          	jalr	-644(ra) # 9c2 <write>
     c4e:	60e2                	ld	ra,24(sp)
     c50:	6105                	addi	sp,sp,32
     c52:	8082                	ret

0000000000000c54 <printint>:
     c54:	7179                	addi	sp,sp,-48
     c56:	f406                	sd	ra,40(sp)
     c58:	f022                	sd	s0,32(sp)
     c5a:	ec26                	sd	s1,24(sp)
     c5c:	e84a                	sd	s2,16(sp)
     c5e:	84aa                	mv	s1,a0
     c60:	c299                	beqz	a3,c66 <printint+0x12>
     c62:	0805c363          	bltz	a1,ce8 <printint+0x94>
     c66:	2581                	sext.w	a1,a1
     c68:	4881                	li	a7,0
     c6a:	868a                	mv	a3,sp
     c6c:	4701                	li	a4,0
     c6e:	2601                	sext.w	a2,a2
     c70:	00000517          	auipc	a0,0x0
     c74:	7b850513          	addi	a0,a0,1976 # 1428 <digits>
     c78:	883a                	mv	a6,a4
     c7a:	2705                	addiw	a4,a4,1
     c7c:	02c5f7bb          	remuw	a5,a1,a2
     c80:	1782                	slli	a5,a5,0x20
     c82:	9381                	srli	a5,a5,0x20
     c84:	97aa                	add	a5,a5,a0
     c86:	0007c783          	lbu	a5,0(a5)
     c8a:	00f68023          	sb	a5,0(a3)
     c8e:	0005879b          	sext.w	a5,a1
     c92:	02c5d5bb          	divuw	a1,a1,a2
     c96:	0685                	addi	a3,a3,1
     c98:	fec7f0e3          	bgeu	a5,a2,c78 <printint+0x24>
     c9c:	00088a63          	beqz	a7,cb0 <printint+0x5c>
     ca0:	081c                	addi	a5,sp,16
     ca2:	973e                	add	a4,a4,a5
     ca4:	02d00793          	li	a5,45
     ca8:	fef70823          	sb	a5,-16(a4)
     cac:	0028071b          	addiw	a4,a6,2
     cb0:	02e05663          	blez	a4,cdc <printint+0x88>
     cb4:	00e10433          	add	s0,sp,a4
     cb8:	fff10913          	addi	s2,sp,-1
     cbc:	993a                	add	s2,s2,a4
     cbe:	377d                	addiw	a4,a4,-1
     cc0:	1702                	slli	a4,a4,0x20
     cc2:	9301                	srli	a4,a4,0x20
     cc4:	40e90933          	sub	s2,s2,a4
     cc8:	fff44583          	lbu	a1,-1(s0)
     ccc:	8526                	mv	a0,s1
     cce:	00000097          	auipc	ra,0x0
     cd2:	f6a080e7          	jalr	-150(ra) # c38 <putc>
     cd6:	147d                	addi	s0,s0,-1
     cd8:	ff2418e3          	bne	s0,s2,cc8 <printint+0x74>
     cdc:	70a2                	ld	ra,40(sp)
     cde:	7402                	ld	s0,32(sp)
     ce0:	64e2                	ld	s1,24(sp)
     ce2:	6942                	ld	s2,16(sp)
     ce4:	6145                	addi	sp,sp,48
     ce6:	8082                	ret
     ce8:	40b005bb          	negw	a1,a1
     cec:	4885                	li	a7,1
     cee:	bfb5                	j	c6a <printint+0x16>

0000000000000cf0 <vprintf>:
     cf0:	7119                	addi	sp,sp,-128
     cf2:	fc86                	sd	ra,120(sp)
     cf4:	f8a2                	sd	s0,112(sp)
     cf6:	f4a6                	sd	s1,104(sp)
     cf8:	f0ca                	sd	s2,96(sp)
     cfa:	ecce                	sd	s3,88(sp)
     cfc:	e8d2                	sd	s4,80(sp)
     cfe:	e4d6                	sd	s5,72(sp)
     d00:	e0da                	sd	s6,64(sp)
     d02:	fc5e                	sd	s7,56(sp)
     d04:	f862                	sd	s8,48(sp)
     d06:	f466                	sd	s9,40(sp)
     d08:	f06a                	sd	s10,32(sp)
     d0a:	ec6e                	sd	s11,24(sp)
     d0c:	0005c483          	lbu	s1,0(a1)
     d10:	18048c63          	beqz	s1,ea8 <vprintf+0x1b8>
     d14:	8a2a                	mv	s4,a0
     d16:	8ab2                	mv	s5,a2
     d18:	00158413          	addi	s0,a1,1
     d1c:	4901                	li	s2,0
     d1e:	02500993          	li	s3,37
     d22:	06400b93          	li	s7,100
     d26:	06c00c13          	li	s8,108
     d2a:	07800c93          	li	s9,120
     d2e:	07000d13          	li	s10,112
     d32:	07300d93          	li	s11,115
     d36:	00000b17          	auipc	s6,0x0
     d3a:	6f2b0b13          	addi	s6,s6,1778 # 1428 <digits>
     d3e:	a839                	j	d5c <vprintf+0x6c>
     d40:	85a6                	mv	a1,s1
     d42:	8552                	mv	a0,s4
     d44:	00000097          	auipc	ra,0x0
     d48:	ef4080e7          	jalr	-268(ra) # c38 <putc>
     d4c:	a019                	j	d52 <vprintf+0x62>
     d4e:	01390f63          	beq	s2,s3,d6c <vprintf+0x7c>
     d52:	0405                	addi	s0,s0,1
     d54:	fff44483          	lbu	s1,-1(s0)
     d58:	14048863          	beqz	s1,ea8 <vprintf+0x1b8>
     d5c:	0004879b          	sext.w	a5,s1
     d60:	fe0917e3          	bnez	s2,d4e <vprintf+0x5e>
     d64:	fd379ee3          	bne	a5,s3,d40 <vprintf+0x50>
     d68:	893e                	mv	s2,a5
     d6a:	b7e5                	j	d52 <vprintf+0x62>
     d6c:	03778e63          	beq	a5,s7,da8 <vprintf+0xb8>
     d70:	05878a63          	beq	a5,s8,dc4 <vprintf+0xd4>
     d74:	07978663          	beq	a5,s9,de0 <vprintf+0xf0>
     d78:	09a78263          	beq	a5,s10,dfc <vprintf+0x10c>
     d7c:	0db78363          	beq	a5,s11,e42 <vprintf+0x152>
     d80:	06300713          	li	a4,99
     d84:	0ee78b63          	beq	a5,a4,e7a <vprintf+0x18a>
     d88:	11378563          	beq	a5,s3,e92 <vprintf+0x1a2>
     d8c:	85ce                	mv	a1,s3
     d8e:	8552                	mv	a0,s4
     d90:	00000097          	auipc	ra,0x0
     d94:	ea8080e7          	jalr	-344(ra) # c38 <putc>
     d98:	85a6                	mv	a1,s1
     d9a:	8552                	mv	a0,s4
     d9c:	00000097          	auipc	ra,0x0
     da0:	e9c080e7          	jalr	-356(ra) # c38 <putc>
     da4:	4901                	li	s2,0
     da6:	b775                	j	d52 <vprintf+0x62>
     da8:	008a8493          	addi	s1,s5,8
     dac:	4685                	li	a3,1
     dae:	4629                	li	a2,10
     db0:	000aa583          	lw	a1,0(s5)
     db4:	8552                	mv	a0,s4
     db6:	00000097          	auipc	ra,0x0
     dba:	e9e080e7          	jalr	-354(ra) # c54 <printint>
     dbe:	8aa6                	mv	s5,s1
     dc0:	4901                	li	s2,0
     dc2:	bf41                	j	d52 <vprintf+0x62>
     dc4:	008a8493          	addi	s1,s5,8
     dc8:	4681                	li	a3,0
     dca:	4629                	li	a2,10
     dcc:	000aa583          	lw	a1,0(s5)
     dd0:	8552                	mv	a0,s4
     dd2:	00000097          	auipc	ra,0x0
     dd6:	e82080e7          	jalr	-382(ra) # c54 <printint>
     dda:	8aa6                	mv	s5,s1
     ddc:	4901                	li	s2,0
     dde:	bf95                	j	d52 <vprintf+0x62>
     de0:	008a8493          	addi	s1,s5,8
     de4:	4681                	li	a3,0
     de6:	4641                	li	a2,16
     de8:	000aa583          	lw	a1,0(s5)
     dec:	8552                	mv	a0,s4
     dee:	00000097          	auipc	ra,0x0
     df2:	e66080e7          	jalr	-410(ra) # c54 <printint>
     df6:	8aa6                	mv	s5,s1
     df8:	4901                	li	s2,0
     dfa:	bfa1                	j	d52 <vprintf+0x62>
     dfc:	008a8793          	addi	a5,s5,8
     e00:	e43e                	sd	a5,8(sp)
     e02:	000ab903          	ld	s2,0(s5)
     e06:	03000593          	li	a1,48
     e0a:	8552                	mv	a0,s4
     e0c:	00000097          	auipc	ra,0x0
     e10:	e2c080e7          	jalr	-468(ra) # c38 <putc>
     e14:	85e6                	mv	a1,s9
     e16:	8552                	mv	a0,s4
     e18:	00000097          	auipc	ra,0x0
     e1c:	e20080e7          	jalr	-480(ra) # c38 <putc>
     e20:	44c1                	li	s1,16
     e22:	03c95793          	srli	a5,s2,0x3c
     e26:	97da                	add	a5,a5,s6
     e28:	0007c583          	lbu	a1,0(a5)
     e2c:	8552                	mv	a0,s4
     e2e:	00000097          	auipc	ra,0x0
     e32:	e0a080e7          	jalr	-502(ra) # c38 <putc>
     e36:	0912                	slli	s2,s2,0x4
     e38:	34fd                	addiw	s1,s1,-1
     e3a:	f4e5                	bnez	s1,e22 <vprintf+0x132>
     e3c:	6aa2                	ld	s5,8(sp)
     e3e:	4901                	li	s2,0
     e40:	bf09                	j	d52 <vprintf+0x62>
     e42:	008a8493          	addi	s1,s5,8
     e46:	000ab903          	ld	s2,0(s5)
     e4a:	02090163          	beqz	s2,e6c <vprintf+0x17c>
     e4e:	00094583          	lbu	a1,0(s2)
     e52:	c9a1                	beqz	a1,ea2 <vprintf+0x1b2>
     e54:	8552                	mv	a0,s4
     e56:	00000097          	auipc	ra,0x0
     e5a:	de2080e7          	jalr	-542(ra) # c38 <putc>
     e5e:	0905                	addi	s2,s2,1
     e60:	00094583          	lbu	a1,0(s2)
     e64:	f9e5                	bnez	a1,e54 <vprintf+0x164>
     e66:	8aa6                	mv	s5,s1
     e68:	4901                	li	s2,0
     e6a:	b5e5                	j	d52 <vprintf+0x62>
     e6c:	00000917          	auipc	s2,0x0
     e70:	5b490913          	addi	s2,s2,1460 # 1420 <malloc+0x492>
     e74:	02800593          	li	a1,40
     e78:	bff1                	j	e54 <vprintf+0x164>
     e7a:	008a8493          	addi	s1,s5,8
     e7e:	000ac583          	lbu	a1,0(s5)
     e82:	8552                	mv	a0,s4
     e84:	00000097          	auipc	ra,0x0
     e88:	db4080e7          	jalr	-588(ra) # c38 <putc>
     e8c:	8aa6                	mv	s5,s1
     e8e:	4901                	li	s2,0
     e90:	b5c9                	j	d52 <vprintf+0x62>
     e92:	85ce                	mv	a1,s3
     e94:	8552                	mv	a0,s4
     e96:	00000097          	auipc	ra,0x0
     e9a:	da2080e7          	jalr	-606(ra) # c38 <putc>
     e9e:	4901                	li	s2,0
     ea0:	bd4d                	j	d52 <vprintf+0x62>
     ea2:	8aa6                	mv	s5,s1
     ea4:	4901                	li	s2,0
     ea6:	b575                	j	d52 <vprintf+0x62>
     ea8:	70e6                	ld	ra,120(sp)
     eaa:	7446                	ld	s0,112(sp)
     eac:	74a6                	ld	s1,104(sp)
     eae:	7906                	ld	s2,96(sp)
     eb0:	69e6                	ld	s3,88(sp)
     eb2:	6a46                	ld	s4,80(sp)
     eb4:	6aa6                	ld	s5,72(sp)
     eb6:	6b06                	ld	s6,64(sp)
     eb8:	7be2                	ld	s7,56(sp)
     eba:	7c42                	ld	s8,48(sp)
     ebc:	7ca2                	ld	s9,40(sp)
     ebe:	7d02                	ld	s10,32(sp)
     ec0:	6de2                	ld	s11,24(sp)
     ec2:	6109                	addi	sp,sp,128
     ec4:	8082                	ret

0000000000000ec6 <fprintf>:
     ec6:	715d                	addi	sp,sp,-80
     ec8:	ec06                	sd	ra,24(sp)
     eca:	f032                	sd	a2,32(sp)
     ecc:	f436                	sd	a3,40(sp)
     ece:	f83a                	sd	a4,48(sp)
     ed0:	fc3e                	sd	a5,56(sp)
     ed2:	e0c2                	sd	a6,64(sp)
     ed4:	e4c6                	sd	a7,72(sp)
     ed6:	1010                	addi	a2,sp,32
     ed8:	e432                	sd	a2,8(sp)
     eda:	00000097          	auipc	ra,0x0
     ede:	e16080e7          	jalr	-490(ra) # cf0 <vprintf>
     ee2:	60e2                	ld	ra,24(sp)
     ee4:	6161                	addi	sp,sp,80
     ee6:	8082                	ret

0000000000000ee8 <printf>:
     ee8:	711d                	addi	sp,sp,-96
     eea:	ec06                	sd	ra,24(sp)
     eec:	f42e                	sd	a1,40(sp)
     eee:	f832                	sd	a2,48(sp)
     ef0:	fc36                	sd	a3,56(sp)
     ef2:	e0ba                	sd	a4,64(sp)
     ef4:	e4be                	sd	a5,72(sp)
     ef6:	e8c2                	sd	a6,80(sp)
     ef8:	ecc6                	sd	a7,88(sp)
     efa:	1030                	addi	a2,sp,40
     efc:	e432                	sd	a2,8(sp)
     efe:	85aa                	mv	a1,a0
     f00:	4505                	li	a0,1
     f02:	00000097          	auipc	ra,0x0
     f06:	dee080e7          	jalr	-530(ra) # cf0 <vprintf>
     f0a:	60e2                	ld	ra,24(sp)
     f0c:	6125                	addi	sp,sp,96
     f0e:	8082                	ret

0000000000000f10 <free>:
     f10:	ff050693          	addi	a3,a0,-16
     f14:	00000797          	auipc	a5,0x0
     f18:	52c7b783          	ld	a5,1324(a5) # 1440 <freep>
     f1c:	a805                	j	f4c <free+0x3c>
     f1e:	4618                	lw	a4,8(a2)
     f20:	9db9                	addw	a1,a1,a4
     f22:	feb52c23          	sw	a1,-8(a0)
     f26:	6398                	ld	a4,0(a5)
     f28:	6318                	ld	a4,0(a4)
     f2a:	fee53823          	sd	a4,-16(a0)
     f2e:	a091                	j	f72 <free+0x62>
     f30:	ff852703          	lw	a4,-8(a0)
     f34:	9e39                	addw	a2,a2,a4
     f36:	c790                	sw	a2,8(a5)
     f38:	ff053703          	ld	a4,-16(a0)
     f3c:	e398                	sd	a4,0(a5)
     f3e:	a099                	j	f84 <free+0x74>
     f40:	6398                	ld	a4,0(a5)
     f42:	00e7e463          	bltu	a5,a4,f4a <free+0x3a>
     f46:	00e6ea63          	bltu	a3,a4,f5a <free+0x4a>
     f4a:	87ba                	mv	a5,a4
     f4c:	fed7fae3          	bgeu	a5,a3,f40 <free+0x30>
     f50:	6398                	ld	a4,0(a5)
     f52:	00e6e463          	bltu	a3,a4,f5a <free+0x4a>
     f56:	fee7eae3          	bltu	a5,a4,f4a <free+0x3a>
     f5a:	ff852583          	lw	a1,-8(a0)
     f5e:	6390                	ld	a2,0(a5)
     f60:	02059713          	slli	a4,a1,0x20
     f64:	9301                	srli	a4,a4,0x20
     f66:	0712                	slli	a4,a4,0x4
     f68:	9736                	add	a4,a4,a3
     f6a:	fae60ae3          	beq	a2,a4,f1e <free+0xe>
     f6e:	fec53823          	sd	a2,-16(a0)
     f72:	4790                	lw	a2,8(a5)
     f74:	02061713          	slli	a4,a2,0x20
     f78:	9301                	srli	a4,a4,0x20
     f7a:	0712                	slli	a4,a4,0x4
     f7c:	973e                	add	a4,a4,a5
     f7e:	fae689e3          	beq	a3,a4,f30 <free+0x20>
     f82:	e394                	sd	a3,0(a5)
     f84:	00000717          	auipc	a4,0x0
     f88:	4af73e23          	sd	a5,1212(a4) # 1440 <freep>
     f8c:	8082                	ret

0000000000000f8e <malloc>:
     f8e:	7139                	addi	sp,sp,-64
     f90:	fc06                	sd	ra,56(sp)
     f92:	f822                	sd	s0,48(sp)
     f94:	f426                	sd	s1,40(sp)
     f96:	f04a                	sd	s2,32(sp)
     f98:	ec4e                	sd	s3,24(sp)
     f9a:	e852                	sd	s4,16(sp)
     f9c:	e456                	sd	s5,8(sp)
     f9e:	02051413          	slli	s0,a0,0x20
     fa2:	9001                	srli	s0,s0,0x20
     fa4:	043d                	addi	s0,s0,15
     fa6:	8011                	srli	s0,s0,0x4
     fa8:	0014091b          	addiw	s2,s0,1
     fac:	0405                	addi	s0,s0,1
     fae:	00000517          	auipc	a0,0x0
     fb2:	49253503          	ld	a0,1170(a0) # 1440 <freep>
     fb6:	c905                	beqz	a0,fe6 <malloc+0x58>
     fb8:	611c                	ld	a5,0(a0)
     fba:	4798                	lw	a4,8(a5)
     fbc:	04877163          	bgeu	a4,s0,ffe <malloc+0x70>
     fc0:	89ca                	mv	s3,s2
     fc2:	0009071b          	sext.w	a4,s2
     fc6:	6685                	lui	a3,0x1
     fc8:	00d77363          	bgeu	a4,a3,fce <malloc+0x40>
     fcc:	6985                	lui	s3,0x1
     fce:	00098a1b          	sext.w	s4,s3
     fd2:	1982                	slli	s3,s3,0x20
     fd4:	0209d993          	srli	s3,s3,0x20
     fd8:	0992                	slli	s3,s3,0x4
     fda:	00000497          	auipc	s1,0x0
     fde:	46648493          	addi	s1,s1,1126 # 1440 <freep>
     fe2:	5afd                	li	s5,-1
     fe4:	a0bd                	j	1052 <malloc+0xc4>
     fe6:	00000797          	auipc	a5,0x0
     fea:	46278793          	addi	a5,a5,1122 # 1448 <base>
     fee:	00000717          	auipc	a4,0x0
     ff2:	44f73923          	sd	a5,1106(a4) # 1440 <freep>
     ff6:	e39c                	sd	a5,0(a5)
     ff8:	0007a423          	sw	zero,8(a5)
     ffc:	b7d1                	j	fc0 <malloc+0x32>
     ffe:	02e40a63          	beq	s0,a4,1032 <malloc+0xa4>
    1002:	4127073b          	subw	a4,a4,s2
    1006:	c798                	sw	a4,8(a5)
    1008:	1702                	slli	a4,a4,0x20
    100a:	9301                	srli	a4,a4,0x20
    100c:	0712                	slli	a4,a4,0x4
    100e:	97ba                	add	a5,a5,a4
    1010:	0127a423          	sw	s2,8(a5)
    1014:	00000717          	auipc	a4,0x0
    1018:	42a73623          	sd	a0,1068(a4) # 1440 <freep>
    101c:	01078513          	addi	a0,a5,16
    1020:	70e2                	ld	ra,56(sp)
    1022:	7442                	ld	s0,48(sp)
    1024:	74a2                	ld	s1,40(sp)
    1026:	7902                	ld	s2,32(sp)
    1028:	69e2                	ld	s3,24(sp)
    102a:	6a42                	ld	s4,16(sp)
    102c:	6aa2                	ld	s5,8(sp)
    102e:	6121                	addi	sp,sp,64
    1030:	8082                	ret
    1032:	6398                	ld	a4,0(a5)
    1034:	e118                	sd	a4,0(a0)
    1036:	bff9                	j	1014 <malloc+0x86>
    1038:	01452423          	sw	s4,8(a0)
    103c:	0541                	addi	a0,a0,16
    103e:	00000097          	auipc	ra,0x0
    1042:	ed2080e7          	jalr	-302(ra) # f10 <free>
    1046:	6088                	ld	a0,0(s1)
    1048:	dd61                	beqz	a0,1020 <malloc+0x92>
    104a:	611c                	ld	a5,0(a0)
    104c:	4798                	lw	a4,8(a5)
    104e:	fa8778e3          	bgeu	a4,s0,ffe <malloc+0x70>
    1052:	6098                	ld	a4,0(s1)
    1054:	853e                	mv	a0,a5
    1056:	fef71ae3          	bne	a4,a5,104a <malloc+0xbc>
    105a:	854e                	mv	a0,s3
    105c:	00000097          	auipc	ra,0x0
    1060:	8d8080e7          	jalr	-1832(ra) # 934 <sbrk>
    1064:	fd551ae3          	bne	a0,s5,1038 <malloc+0xaa>
    1068:	4501                	li	a0,0
    106a:	bf5d                	j	1020 <malloc+0x92>
