
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
      10:	11450513          	addi	a0,a0,276 # 1120 <malloc+0x1c8>
      14:	00001097          	auipc	ra,0x1
      18:	e9e080e7          	jalr	-354(ra) # eb2 <printf>
      1c:	600c                	ld	a1,0(s0)
      1e:	cd99                	beqz	a1,3c <print_success+0x3c>
      20:	0421                	addi	s0,s0,8
      22:	00001497          	auipc	s1,0x1
      26:	10e48493          	addi	s1,s1,270 # 1130 <malloc+0x1d8>
      2a:	8526                	mv	a0,s1
      2c:	00001097          	auipc	ra,0x1
      30:	e86080e7          	jalr	-378(ra) # eb2 <printf>
      34:	0421                	addi	s0,s0,8
      36:	ff843583          	ld	a1,-8(s0)
      3a:	f9e5                	bnez	a1,2a <print_success+0x2a>
      3c:	00001517          	auipc	a0,0x1
      40:	0fc50513          	addi	a0,a0,252 # 1138 <malloc+0x1e0>
      44:	00001097          	auipc	ra,0x1
      48:	e6e080e7          	jalr	-402(ra) # eb2 <printf>
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
      66:	0be50513          	addi	a0,a0,190 # 1120 <malloc+0x1c8>
      6a:	00001097          	auipc	ra,0x1
      6e:	e48080e7          	jalr	-440(ra) # eb2 <printf>
      72:	600c                	ld	a1,0(s0)
      74:	cd99                	beqz	a1,92 <print_fail+0x3c>
      76:	0421                	addi	s0,s0,8
      78:	00001497          	auipc	s1,0x1
      7c:	0b848493          	addi	s1,s1,184 # 1130 <malloc+0x1d8>
      80:	8526                	mv	a0,s1
      82:	00001097          	auipc	ra,0x1
      86:	e30080e7          	jalr	-464(ra) # eb2 <printf>
      8a:	0421                	addi	s0,s0,8
      8c:	ff843583          	ld	a1,-8(s0)
      90:	f9e5                	bnez	a1,80 <print_fail+0x2a>
      92:	00001517          	auipc	a0,0x1
      96:	0b650513          	addi	a0,a0,182 # 1148 <malloc+0x1f0>
      9a:	00001097          	auipc	ra,0x1
      9e:	e18080e7          	jalr	-488(ra) # eb2 <printf>
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
      bc:	82e080e7          	jalr	-2002(ra) # 8e6 <fork>
      c0:	ed09                	bnez	a0,da <test+0x2e>
      c2:	4601                	li	a2,0
      c4:	85a6                	mv	a1,s1
      c6:	8522                	mv	a0,s0
      c8:	00001097          	auipc	ra,0x1
      cc:	946080e7          	jalr	-1722(ra) # a0e <execve>
      d0:	70a2                	ld	ra,40(sp)
      d2:	7402                	ld	s0,32(sp)
      d4:	64e2                	ld	s1,24(sp)
      d6:	6145                	addi	sp,sp,48
      d8:	8082                	ret
      da:	0068                	addi	a0,sp,12
      dc:	00001097          	auipc	ra,0x1
      e0:	812080e7          	jalr	-2030(ra) # 8ee <wait>
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
     106:	b8010113          	addi	sp,sp,-1152
     10a:	46113c23          	sd	ra,1144(sp)
     10e:	46813823          	sd	s0,1136(sp)
     112:	4589                	li	a1,2
     114:	00001517          	auipc	a0,0x1
     118:	03c50513          	addi	a0,a0,60 # 1150 <malloc+0x1f8>
     11c:	00000097          	auipc	ra,0x0
     120:	7da080e7          	jalr	2010(ra) # 8f6 <open>
     124:	4501                	li	a0,0
     126:	00000097          	auipc	ra,0x0
     12a:	7e8080e7          	jalr	2024(ra) # 90e <dup>
     12e:	4501                	li	a0,0
     130:	00000097          	auipc	ra,0x0
     134:	7de080e7          	jalr	2014(ra) # 90e <dup>
     138:	00001717          	auipc	a4,0x1
     13c:	02070713          	addi	a4,a4,32 # 1158 <malloc+0x200>
     140:	44e13c23          	sd	a4,1112(sp)
     144:	00001797          	auipc	a5,0x1
     148:	01c78793          	addi	a5,a5,28 # 1160 <malloc+0x208>
     14c:	46f13023          	sd	a5,1120(sp)
     150:	46013423          	sd	zero,1128(sp)
     154:	00001797          	auipc	a5,0x1
     158:	ee478793          	addi	a5,a5,-284 # 1038 <malloc+0xe0>
     15c:	42f13c23          	sd	a5,1080(sp)
     160:	00001697          	auipc	a3,0x1
     164:	ee068693          	addi	a3,a3,-288 # 1040 <malloc+0xe8>
     168:	44d13023          	sd	a3,1088(sp)
     16c:	00001797          	auipc	a5,0x1
     170:	edc78793          	addi	a5,a5,-292 # 1048 <malloc+0xf0>
     174:	44f13423          	sd	a5,1096(sp)
     178:	44013823          	sd	zero,1104(sp)
     17c:	00001617          	auipc	a2,0x1
     180:	ed460613          	addi	a2,a2,-300 # 1050 <malloc+0xf8>
     184:	40c13c23          	sd	a2,1048(sp)
     188:	42d13023          	sd	a3,1056(sp)
     18c:	42f13423          	sd	a5,1064(sp)
     190:	42013823          	sd	zero,1072(sp)
     194:	00001797          	auipc	a5,0x1
     198:	fec78793          	addi	a5,a5,-20 # 1180 <malloc+0x228>
     19c:	40f13023          	sd	a5,1024(sp)
     1a0:	00001797          	auipc	a5,0x1
     1a4:	ff078793          	addi	a5,a5,-16 # 1190 <malloc+0x238>
     1a8:	40f13423          	sd	a5,1032(sp)
     1ac:	40013823          	sd	zero,1040(sp)
     1b0:	00001697          	auipc	a3,0x1
     1b4:	ff068693          	addi	a3,a3,-16 # 11a0 <malloc+0x248>
     1b8:	3ed13823          	sd	a3,1008(sp)
     1bc:	3e013c23          	sd	zero,1016(sp)
     1c0:	00001697          	auipc	a3,0x1
     1c4:	fe868693          	addi	a3,a3,-24 # 11a8 <malloc+0x250>
     1c8:	3ed13023          	sd	a3,992(sp)
     1cc:	3e013423          	sd	zero,1000(sp)
     1d0:	00001697          	auipc	a3,0x1
     1d4:	fe068693          	addi	a3,a3,-32 # 11b0 <malloc+0x258>
     1d8:	3cd13823          	sd	a3,976(sp)
     1dc:	3c013c23          	sd	zero,984(sp)
     1e0:	00001697          	auipc	a3,0x1
     1e4:	fd868693          	addi	a3,a3,-40 # 11b8 <malloc+0x260>
     1e8:	3cd13023          	sd	a3,960(sp)
     1ec:	3c013423          	sd	zero,968(sp)
     1f0:	00001697          	auipc	a3,0x1
     1f4:	fd068693          	addi	a3,a3,-48 # 11c0 <malloc+0x268>
     1f8:	3ad13423          	sd	a3,936(sp)
     1fc:	3af13823          	sd	a5,944(sp)
     200:	3a013c23          	sd	zero,952(sp)
     204:	00001797          	auipc	a5,0x1
     208:	fc478793          	addi	a5,a5,-60 # 11c8 <malloc+0x270>
     20c:	38f13c23          	sd	a5,920(sp)
     210:	3a013023          	sd	zero,928(sp)
     214:	00001797          	auipc	a5,0x1
     218:	15c78793          	addi	a5,a5,348 # 1370 <malloc+0x418>
     21c:	0007b803          	ld	a6,0(a5)
     220:	6788                	ld	a0,8(a5)
     222:	6b8c                	ld	a1,16(a5)
     224:	6f90                	ld	a2,24(a5)
     226:	7394                	ld	a3,32(a5)
     228:	37013823          	sd	a6,880(sp)
     22c:	36a13c23          	sd	a0,888(sp)
     230:	38b13023          	sd	a1,896(sp)
     234:	38c13423          	sd	a2,904(sp)
     238:	38d13823          	sd	a3,912(sp)
     23c:	00001697          	auipc	a3,0x1
     240:	f9468693          	addi	a3,a3,-108 # 11d0 <malloc+0x278>
     244:	36d13023          	sd	a3,864(sp)
     248:	36013423          	sd	zero,872(sp)
     24c:	00001697          	auipc	a3,0x1
     250:	f8c68693          	addi	a3,a3,-116 # 11d8 <malloc+0x280>
     254:	34d13823          	sd	a3,848(sp)
     258:	34013c23          	sd	zero,856(sp)
     25c:	00001697          	auipc	a3,0x1
     260:	f8468693          	addi	a3,a3,-124 # 11e0 <malloc+0x288>
     264:	32d13c23          	sd	a3,824(sp)
     268:	00001697          	auipc	a3,0x1
     26c:	f8068693          	addi	a3,a3,-128 # 11e8 <malloc+0x290>
     270:	34d13023          	sd	a3,832(sp)
     274:	34013423          	sd	zero,840(sp)
     278:	00001617          	auipc	a2,0x1
     27c:	f7860613          	addi	a2,a2,-136 # 11f0 <malloc+0x298>
     280:	32c13423          	sd	a2,808(sp)
     284:	32013823          	sd	zero,816(sp)
     288:	00001617          	auipc	a2,0x1
     28c:	f7060613          	addi	a2,a2,-144 # 11f8 <malloc+0x2a0>
     290:	30c13c23          	sd	a2,792(sp)
     294:	32013023          	sd	zero,800(sp)
     298:	00001617          	auipc	a2,0x1
     29c:	f6860613          	addi	a2,a2,-152 # 1200 <malloc+0x2a8>
     2a0:	30c13023          	sd	a2,768(sp)
     2a4:	00001617          	auipc	a2,0x1
     2a8:	f6460613          	addi	a2,a2,-156 # 1208 <malloc+0x2b0>
     2ac:	30c13423          	sd	a2,776(sp)
     2b0:	30013823          	sd	zero,784(sp)
     2b4:	00001617          	auipc	a2,0x1
     2b8:	f5c60613          	addi	a2,a2,-164 # 1210 <malloc+0x2b8>
     2bc:	2ec13823          	sd	a2,752(sp)
     2c0:	2e013c23          	sd	zero,760(sp)
     2c4:	00001617          	auipc	a2,0x1
     2c8:	f5460613          	addi	a2,a2,-172 # 1218 <malloc+0x2c0>
     2cc:	2ec13023          	sd	a2,736(sp)
     2d0:	2e013423          	sd	zero,744(sp)
     2d4:	00001617          	auipc	a2,0x1
     2d8:	f4c60613          	addi	a2,a2,-180 # 1220 <malloc+0x2c8>
     2dc:	2cc13823          	sd	a2,720(sp)
     2e0:	2c013c23          	sd	zero,728(sp)
     2e4:	00001617          	auipc	a2,0x1
     2e8:	f4460613          	addi	a2,a2,-188 # 1228 <malloc+0x2d0>
     2ec:	2ac13c23          	sd	a2,696(sp)
     2f0:	00001617          	auipc	a2,0x1
     2f4:	f4060613          	addi	a2,a2,-192 # 1230 <malloc+0x2d8>
     2f8:	2cc13023          	sd	a2,704(sp)
     2fc:	2c013423          	sd	zero,712(sp)
     300:	2ad13423          	sd	a3,680(sp)
     304:	2a013823          	sd	zero,688(sp)
     308:	00001697          	auipc	a3,0x1
     30c:	f3068693          	addi	a3,a3,-208 # 1238 <malloc+0x2e0>
     310:	28d13c23          	sd	a3,664(sp)
     314:	2a013023          	sd	zero,672(sp)
     318:	28e13023          	sd	a4,640(sp)
     31c:	00001717          	auipc	a4,0x1
     320:	f2470713          	addi	a4,a4,-220 # 1240 <malloc+0x2e8>
     324:	28e13423          	sd	a4,648(sp)
     328:	28013823          	sd	zero,656(sp)
     32c:	00001717          	auipc	a4,0x1
     330:	f3470713          	addi	a4,a4,-204 # 1260 <malloc+0x308>
     334:	26e13423          	sd	a4,616(sp)
     338:	00001417          	auipc	s0,0x1
     33c:	d4840413          	addi	s0,s0,-696 # 1080 <malloc+0x128>
     340:	26813823          	sd	s0,624(sp)
     344:	26013c23          	sd	zero,632(sp)
     348:	00001717          	auipc	a4,0x1
     34c:	f2070713          	addi	a4,a4,-224 # 1268 <malloc+0x310>
     350:	24e13823          	sd	a4,592(sp)
     354:	24813c23          	sd	s0,600(sp)
     358:	26013023          	sd	zero,608(sp)
     35c:	7788                	ld	a0,40(a5)
     35e:	7b8c                	ld	a1,48(a5)
     360:	7f90                	ld	a2,56(a5)
     362:	63b4                	ld	a3,64(a5)
     364:	67b8                	ld	a4,72(a5)
     366:	22a13423          	sd	a0,552(sp)
     36a:	22b13823          	sd	a1,560(sp)
     36e:	22c13c23          	sd	a2,568(sp)
     372:	24d13023          	sd	a3,576(sp)
     376:	24e13423          	sd	a4,584(sp)
     37a:	00001717          	auipc	a4,0x1
     37e:	ef670713          	addi	a4,a4,-266 # 1270 <malloc+0x318>
     382:	20e13823          	sd	a4,528(sp)
     386:	20813c23          	sd	s0,536(sp)
     38a:	22013023          	sd	zero,544(sp)
     38e:	00001717          	auipc	a4,0x1
     392:	eea70713          	addi	a4,a4,-278 # 1278 <malloc+0x320>
     396:	ffba                	sd	a4,504(sp)
     398:	20813023          	sd	s0,512(sp)
     39c:	20013423          	sd	zero,520(sp)
     3a0:	00001717          	auipc	a4,0x1
     3a4:	ee070713          	addi	a4,a4,-288 # 1280 <malloc+0x328>
     3a8:	f3ba                	sd	a4,480(sp)
     3aa:	f7a2                	sd	s0,488(sp)
     3ac:	fb82                	sd	zero,496(sp)
     3ae:	00001717          	auipc	a4,0x1
     3b2:	ce270713          	addi	a4,a4,-798 # 1090 <malloc+0x138>
     3b6:	e3ba                	sd	a4,448(sp)
     3b8:	00001717          	auipc	a4,0x1
     3bc:	ce070713          	addi	a4,a4,-800 # 1098 <malloc+0x140>
     3c0:	e7ba                	sd	a4,456(sp)
     3c2:	eba2                	sd	s0,464(sp)
     3c4:	ef82                	sd	zero,472(sp)
     3c6:	00001717          	auipc	a4,0x1
     3ca:	ec270713          	addi	a4,a4,-318 # 1288 <malloc+0x330>
     3ce:	f73a                	sd	a4,424(sp)
     3d0:	fb22                	sd	s0,432(sp)
     3d2:	ff02                	sd	zero,440(sp)
     3d4:	00001717          	auipc	a4,0x1
     3d8:	ebc70713          	addi	a4,a4,-324 # 1290 <malloc+0x338>
     3dc:	eb3a                	sd	a4,400(sp)
     3de:	ef22                	sd	s0,408(sp)
     3e0:	f302                	sd	zero,416(sp)
     3e2:	00001717          	auipc	a4,0x1
     3e6:	eb670713          	addi	a4,a4,-330 # 1298 <malloc+0x340>
     3ea:	feba                	sd	a4,376(sp)
     3ec:	e322                	sd	s0,384(sp)
     3ee:	e702                	sd	zero,392(sp)
     3f0:	00001717          	auipc	a4,0x1
     3f4:	eb070713          	addi	a4,a4,-336 # 12a0 <malloc+0x348>
     3f8:	f2ba                	sd	a4,352(sp)
     3fa:	f6a2                	sd	s0,360(sp)
     3fc:	fa82                	sd	zero,368(sp)
     3fe:	6bac                	ld	a1,80(a5)
     400:	6fb0                	ld	a2,88(a5)
     402:	73b4                	ld	a3,96(a5)
     404:	77b8                	ld	a4,104(a5)
     406:	7bbc                	ld	a5,112(a5)
     408:	fe2e                	sd	a1,312(sp)
     40a:	e2b2                	sd	a2,320(sp)
     40c:	e6b6                	sd	a3,328(sp)
     40e:	eaba                	sd	a4,336(sp)
     410:	eebe                	sd	a5,344(sp)
     412:	00001797          	auipc	a5,0x1
     416:	e9678793          	addi	a5,a5,-362 # 12a8 <malloc+0x350>
     41a:	f23e                	sd	a5,288(sp)
     41c:	f622                	sd	s0,296(sp)
     41e:	fa02                	sd	zero,304(sp)
     420:	00001797          	auipc	a5,0x1
     424:	e9078793          	addi	a5,a5,-368 # 12b0 <malloc+0x358>
     428:	e63e                	sd	a5,264(sp)
     42a:	ea22                	sd	s0,272(sp)
     42c:	ee02                	sd	zero,280(sp)
     42e:	00001797          	auipc	a5,0x1
     432:	e8a78793          	addi	a5,a5,-374 # 12b8 <malloc+0x360>
     436:	f9be                	sd	a5,240(sp)
     438:	00001797          	auipc	a5,0x1
     43c:	c8878793          	addi	a5,a5,-888 # 10c0 <malloc+0x168>
     440:	fdbe                	sd	a5,248(sp)
     442:	e202                	sd	zero,256(sp)
     444:	00001797          	auipc	a5,0x1
     448:	e7c78793          	addi	a5,a5,-388 # 12c0 <malloc+0x368>
     44c:	edbe                	sd	a5,216(sp)
     44e:	00001797          	auipc	a5,0x1
     452:	c8278793          	addi	a5,a5,-894 # 10d0 <malloc+0x178>
     456:	f1be                	sd	a5,224(sp)
     458:	f582                	sd	zero,232(sp)
     45a:	00001797          	auipc	a5,0x1
     45e:	c7e78793          	addi	a5,a5,-898 # 10d8 <malloc+0x180>
     462:	fd3e                	sd	a5,184(sp)
     464:	00001797          	auipc	a5,0x1
     468:	c7c78793          	addi	a5,a5,-900 # 10e0 <malloc+0x188>
     46c:	e1be                	sd	a5,192(sp)
     46e:	00001797          	auipc	a5,0x1
     472:	c7a78793          	addi	a5,a5,-902 # 10e8 <malloc+0x190>
     476:	e5be                	sd	a5,200(sp)
     478:	e982                	sd	zero,208(sp)
     47a:	00001717          	auipc	a4,0x1
     47e:	c7e70713          	addi	a4,a4,-898 # 10f8 <malloc+0x1a0>
     482:	ed3a                	sd	a4,152(sp)
     484:	f13e                	sd	a5,160(sp)
     486:	00001797          	auipc	a5,0x1
     48a:	c7a78793          	addi	a5,a5,-902 # 1100 <malloc+0x1a8>
     48e:	f53e                	sd	a5,168(sp)
     490:	f902                	sd	zero,176(sp)
     492:	00001797          	auipc	a5,0x1
     496:	e3678793          	addi	a5,a5,-458 # 12c8 <malloc+0x370>
     49a:	e53e                	sd	a5,136(sp)
     49c:	e902                	sd	zero,144(sp)
     49e:	00001797          	auipc	a5,0x1
     4a2:	e3a78793          	addi	a5,a5,-454 # 12d8 <malloc+0x380>
     4a6:	fcbe                	sd	a5,120(sp)
     4a8:	e102                	sd	zero,128(sp)
     4aa:	00001797          	auipc	a5,0x1
     4ae:	e3e78793          	addi	a5,a5,-450 # 12e8 <malloc+0x390>
     4b2:	f4be                	sd	a5,104(sp)
     4b4:	f882                	sd	zero,112(sp)
     4b6:	00001797          	auipc	a5,0x1
     4ba:	e4278793          	addi	a5,a5,-446 # 12f8 <malloc+0x3a0>
     4be:	ecbe                	sd	a5,88(sp)
     4c0:	f082                	sd	zero,96(sp)
     4c2:	00001797          	auipc	a5,0x1
     4c6:	e4678793          	addi	a5,a5,-442 # 1308 <malloc+0x3b0>
     4ca:	e4be                	sd	a5,72(sp)
     4cc:	e882                	sd	zero,80(sp)
     4ce:	00001797          	auipc	a5,0x1
     4d2:	e4a78793          	addi	a5,a5,-438 # 1318 <malloc+0x3c0>
     4d6:	fc3e                	sd	a5,56(sp)
     4d8:	e082                	sd	zero,64(sp)
     4da:	00001797          	auipc	a5,0x1
     4de:	e4e78793          	addi	a5,a5,-434 # 1328 <malloc+0x3d0>
     4e2:	f43e                	sd	a5,40(sp)
     4e4:	f802                	sd	zero,48(sp)
     4e6:	00001797          	auipc	a5,0x1
     4ea:	e5278793          	addi	a5,a5,-430 # 1338 <malloc+0x3e0>
     4ee:	ec3e                	sd	a5,24(sp)
     4f0:	f002                	sd	zero,32(sp)
     4f2:	00001797          	auipc	a5,0x1
     4f6:	e5678793          	addi	a5,a5,-426 # 1348 <malloc+0x3f0>
     4fa:	e43e                	sd	a5,8(sp)
     4fc:	e802                	sd	zero,16(sp)
     4fe:	45810593          	addi	a1,sp,1112
     502:	00001517          	auipc	a0,0x1
     506:	e5650513          	addi	a0,a0,-426 # 1358 <malloc+0x400>
     50a:	00000097          	auipc	ra,0x0
     50e:	ba2080e7          	jalr	-1118(ra) # ac <test>
     512:	43810593          	addi	a1,sp,1080
     516:	00001517          	auipc	a0,0x1
     51a:	e4250513          	addi	a0,a0,-446 # 1358 <malloc+0x400>
     51e:	00000097          	auipc	ra,0x0
     522:	b8e080e7          	jalr	-1138(ra) # ac <test>
     526:	41810593          	addi	a1,sp,1048
     52a:	00001517          	auipc	a0,0x1
     52e:	e2e50513          	addi	a0,a0,-466 # 1358 <malloc+0x400>
     532:	00000097          	auipc	ra,0x0
     536:	b7a080e7          	jalr	-1158(ra) # ac <test>
     53a:	40010593          	addi	a1,sp,1024
     53e:	00001517          	auipc	a0,0x1
     542:	e1a50513          	addi	a0,a0,-486 # 1358 <malloc+0x400>
     546:	00000097          	auipc	ra,0x0
     54a:	b66080e7          	jalr	-1178(ra) # ac <test>
     54e:	1f8c                	addi	a1,sp,1008
     550:	00001517          	auipc	a0,0x1
     554:	e0850513          	addi	a0,a0,-504 # 1358 <malloc+0x400>
     558:	00000097          	auipc	ra,0x0
     55c:	b54080e7          	jalr	-1196(ra) # ac <test>
     560:	178c                	addi	a1,sp,992
     562:	00001517          	auipc	a0,0x1
     566:	df650513          	addi	a0,a0,-522 # 1358 <malloc+0x400>
     56a:	00000097          	auipc	ra,0x0
     56e:	b42080e7          	jalr	-1214(ra) # ac <test>
     572:	0f8c                	addi	a1,sp,976
     574:	00001517          	auipc	a0,0x1
     578:	de450513          	addi	a0,a0,-540 # 1358 <malloc+0x400>
     57c:	00000097          	auipc	ra,0x0
     580:	b30080e7          	jalr	-1232(ra) # ac <test>
     584:	078c                	addi	a1,sp,960
     586:	00001517          	auipc	a0,0x1
     58a:	dd250513          	addi	a0,a0,-558 # 1358 <malloc+0x400>
     58e:	00000097          	auipc	ra,0x0
     592:	b1e080e7          	jalr	-1250(ra) # ac <test>
     596:	172c                	addi	a1,sp,936
     598:	00001517          	auipc	a0,0x1
     59c:	dc050513          	addi	a0,a0,-576 # 1358 <malloc+0x400>
     5a0:	00000097          	auipc	ra,0x0
     5a4:	b0c080e7          	jalr	-1268(ra) # ac <test>
     5a8:	0f2c                	addi	a1,sp,920
     5aa:	00001517          	auipc	a0,0x1
     5ae:	dae50513          	addi	a0,a0,-594 # 1358 <malloc+0x400>
     5b2:	00000097          	auipc	ra,0x0
     5b6:	afa080e7          	jalr	-1286(ra) # ac <test>
     5ba:	1e8c                	addi	a1,sp,880
     5bc:	00001517          	auipc	a0,0x1
     5c0:	d9c50513          	addi	a0,a0,-612 # 1358 <malloc+0x400>
     5c4:	00000097          	auipc	ra,0x0
     5c8:	ae8080e7          	jalr	-1304(ra) # ac <test>
     5cc:	168c                	addi	a1,sp,864
     5ce:	00001517          	auipc	a0,0x1
     5d2:	d8a50513          	addi	a0,a0,-630 # 1358 <malloc+0x400>
     5d6:	00000097          	auipc	ra,0x0
     5da:	ad6080e7          	jalr	-1322(ra) # ac <test>
     5de:	0e8c                	addi	a1,sp,848
     5e0:	00001517          	auipc	a0,0x1
     5e4:	d7850513          	addi	a0,a0,-648 # 1358 <malloc+0x400>
     5e8:	00000097          	auipc	ra,0x0
     5ec:	ac4080e7          	jalr	-1340(ra) # ac <test>
     5f0:	1e2c                	addi	a1,sp,824
     5f2:	00001517          	auipc	a0,0x1
     5f6:	d6650513          	addi	a0,a0,-666 # 1358 <malloc+0x400>
     5fa:	00000097          	auipc	ra,0x0
     5fe:	ab2080e7          	jalr	-1358(ra) # ac <test>
     602:	162c                	addi	a1,sp,808
     604:	00001517          	auipc	a0,0x1
     608:	d5450513          	addi	a0,a0,-684 # 1358 <malloc+0x400>
     60c:	00000097          	auipc	ra,0x0
     610:	aa0080e7          	jalr	-1376(ra) # ac <test>
     614:	0e2c                	addi	a1,sp,792
     616:	00001517          	auipc	a0,0x1
     61a:	d4250513          	addi	a0,a0,-702 # 1358 <malloc+0x400>
     61e:	00000097          	auipc	ra,0x0
     622:	a8e080e7          	jalr	-1394(ra) # ac <test>
     626:	060c                	addi	a1,sp,768
     628:	00001517          	auipc	a0,0x1
     62c:	d3050513          	addi	a0,a0,-720 # 1358 <malloc+0x400>
     630:	00000097          	auipc	ra,0x0
     634:	a7c080e7          	jalr	-1412(ra) # ac <test>
     638:	1d8c                	addi	a1,sp,752
     63a:	00001517          	auipc	a0,0x1
     63e:	d1e50513          	addi	a0,a0,-738 # 1358 <malloc+0x400>
     642:	00000097          	auipc	ra,0x0
     646:	a6a080e7          	jalr	-1430(ra) # ac <test>
     64a:	0d8c                	addi	a1,sp,720
     64c:	00001517          	auipc	a0,0x1
     650:	d0c50513          	addi	a0,a0,-756 # 1358 <malloc+0x400>
     654:	00000097          	auipc	ra,0x0
     658:	a58080e7          	jalr	-1448(ra) # ac <test>
     65c:	1d2c                	addi	a1,sp,696
     65e:	00001517          	auipc	a0,0x1
     662:	cfa50513          	addi	a0,a0,-774 # 1358 <malloc+0x400>
     666:	00000097          	auipc	ra,0x0
     66a:	a46080e7          	jalr	-1466(ra) # ac <test>
     66e:	152c                	addi	a1,sp,680
     670:	00001517          	auipc	a0,0x1
     674:	ce850513          	addi	a0,a0,-792 # 1358 <malloc+0x400>
     678:	00000097          	auipc	ra,0x0
     67c:	a34080e7          	jalr	-1484(ra) # ac <test>
     680:	0d2c                	addi	a1,sp,664
     682:	00001517          	auipc	a0,0x1
     686:	cd650513          	addi	a0,a0,-810 # 1358 <malloc+0x400>
     68a:	00000097          	auipc	ra,0x0
     68e:	a22080e7          	jalr	-1502(ra) # ac <test>
     692:	158c                	addi	a1,sp,736
     694:	00001517          	auipc	a0,0x1
     698:	cc450513          	addi	a0,a0,-828 # 1358 <malloc+0x400>
     69c:	00000097          	auipc	ra,0x0
     6a0:	a10080e7          	jalr	-1520(ra) # ac <test>
     6a4:	050c                	addi	a1,sp,640
     6a6:	00001517          	auipc	a0,0x1
     6aa:	cb250513          	addi	a0,a0,-846 # 1358 <malloc+0x400>
     6ae:	00000097          	auipc	ra,0x0
     6b2:	9fe080e7          	jalr	-1538(ra) # ac <test>
     6b6:	14ac                	addi	a1,sp,616
     6b8:	00001517          	auipc	a0,0x1
     6bc:	ca050513          	addi	a0,a0,-864 # 1358 <malloc+0x400>
     6c0:	00000097          	auipc	ra,0x0
     6c4:	9ec080e7          	jalr	-1556(ra) # ac <test>
     6c8:	4589                	li	a1,2
     6ca:	8522                	mv	a0,s0
     6cc:	00000097          	auipc	ra,0x0
     6d0:	22a080e7          	jalr	554(ra) # 8f6 <open>
     6d4:	842a                	mv	s0,a0
     6d6:	1e054e63          	bltz	a0,8d2 <main+0x7cc>
     6da:	4635                	li	a2,13
     6dc:	00001597          	auipc	a1,0x1
     6e0:	c8458593          	addi	a1,a1,-892 # 1360 <malloc+0x408>
     6e4:	8522                	mv	a0,s0
     6e6:	00000097          	auipc	ra,0x0
     6ea:	2a6080e7          	jalr	678(ra) # 98c <write>
     6ee:	1e054763          	bltz	a0,8dc <main+0x7d6>
     6f2:	8522                	mv	a0,s0
     6f4:	00000097          	auipc	ra,0x0
     6f8:	270080e7          	jalr	624(ra) # 964 <close>
     6fc:	0c8c                	addi	a1,sp,592
     6fe:	00001517          	auipc	a0,0x1
     702:	c5a50513          	addi	a0,a0,-934 # 1358 <malloc+0x400>
     706:	00000097          	auipc	ra,0x0
     70a:	9a6080e7          	jalr	-1626(ra) # ac <test>
     70e:	142c                	addi	a1,sp,552
     710:	00001517          	auipc	a0,0x1
     714:	c4850513          	addi	a0,a0,-952 # 1358 <malloc+0x400>
     718:	00000097          	auipc	ra,0x0
     71c:	994080e7          	jalr	-1644(ra) # ac <test>
     720:	0c0c                	addi	a1,sp,528
     722:	00001517          	auipc	a0,0x1
     726:	c3650513          	addi	a0,a0,-970 # 1358 <malloc+0x400>
     72a:	00000097          	auipc	ra,0x0
     72e:	982080e7          	jalr	-1662(ra) # ac <test>
     732:	1bac                	addi	a1,sp,504
     734:	00001517          	auipc	a0,0x1
     738:	c2450513          	addi	a0,a0,-988 # 1358 <malloc+0x400>
     73c:	00000097          	auipc	ra,0x0
     740:	970080e7          	jalr	-1680(ra) # ac <test>
     744:	138c                	addi	a1,sp,480
     746:	00001517          	auipc	a0,0x1
     74a:	c1250513          	addi	a0,a0,-1006 # 1358 <malloc+0x400>
     74e:	00000097          	auipc	ra,0x0
     752:	95e080e7          	jalr	-1698(ra) # ac <test>
     756:	038c                	addi	a1,sp,448
     758:	00001517          	auipc	a0,0x1
     75c:	c0050513          	addi	a0,a0,-1024 # 1358 <malloc+0x400>
     760:	00000097          	auipc	ra,0x0
     764:	94c080e7          	jalr	-1716(ra) # ac <test>
     768:	132c                	addi	a1,sp,424
     76a:	00001517          	auipc	a0,0x1
     76e:	bee50513          	addi	a0,a0,-1042 # 1358 <malloc+0x400>
     772:	00000097          	auipc	ra,0x0
     776:	93a080e7          	jalr	-1734(ra) # ac <test>
     77a:	0b0c                	addi	a1,sp,400
     77c:	00001517          	auipc	a0,0x1
     780:	bdc50513          	addi	a0,a0,-1060 # 1358 <malloc+0x400>
     784:	00000097          	auipc	ra,0x0
     788:	928080e7          	jalr	-1752(ra) # ac <test>
     78c:	1aac                	addi	a1,sp,376
     78e:	00001517          	auipc	a0,0x1
     792:	bca50513          	addi	a0,a0,-1078 # 1358 <malloc+0x400>
     796:	00000097          	auipc	ra,0x0
     79a:	916080e7          	jalr	-1770(ra) # ac <test>
     79e:	128c                	addi	a1,sp,352
     7a0:	00001517          	auipc	a0,0x1
     7a4:	bb850513          	addi	a0,a0,-1096 # 1358 <malloc+0x400>
     7a8:	00000097          	auipc	ra,0x0
     7ac:	904080e7          	jalr	-1788(ra) # ac <test>
     7b0:	1a2c                	addi	a1,sp,312
     7b2:	00001517          	auipc	a0,0x1
     7b6:	ba650513          	addi	a0,a0,-1114 # 1358 <malloc+0x400>
     7ba:	00000097          	auipc	ra,0x0
     7be:	8f2080e7          	jalr	-1806(ra) # ac <test>
     7c2:	120c                	addi	a1,sp,288
     7c4:	00001517          	auipc	a0,0x1
     7c8:	b9450513          	addi	a0,a0,-1132 # 1358 <malloc+0x400>
     7cc:	00000097          	auipc	ra,0x0
     7d0:	8e0080e7          	jalr	-1824(ra) # ac <test>
     7d4:	022c                	addi	a1,sp,264
     7d6:	00001517          	auipc	a0,0x1
     7da:	b8250513          	addi	a0,a0,-1150 # 1358 <malloc+0x400>
     7de:	00000097          	auipc	ra,0x0
     7e2:	8ce080e7          	jalr	-1842(ra) # ac <test>
     7e6:	198c                	addi	a1,sp,240
     7e8:	00001517          	auipc	a0,0x1
     7ec:	b7050513          	addi	a0,a0,-1168 # 1358 <malloc+0x400>
     7f0:	00000097          	auipc	ra,0x0
     7f4:	8bc080e7          	jalr	-1860(ra) # ac <test>
     7f8:	09ac                	addi	a1,sp,216
     7fa:	00001517          	auipc	a0,0x1
     7fe:	b5e50513          	addi	a0,a0,-1186 # 1358 <malloc+0x400>
     802:	00000097          	auipc	ra,0x0
     806:	8aa080e7          	jalr	-1878(ra) # ac <test>
     80a:	192c                	addi	a1,sp,184
     80c:	00001517          	auipc	a0,0x1
     810:	b4c50513          	addi	a0,a0,-1204 # 1358 <malloc+0x400>
     814:	00000097          	auipc	ra,0x0
     818:	898080e7          	jalr	-1896(ra) # ac <test>
     81c:	092c                	addi	a1,sp,152
     81e:	00001517          	auipc	a0,0x1
     822:	b3a50513          	addi	a0,a0,-1222 # 1358 <malloc+0x400>
     826:	00000097          	auipc	ra,0x0
     82a:	886080e7          	jalr	-1914(ra) # ac <test>
     82e:	012c                	addi	a1,sp,136
     830:	00001517          	auipc	a0,0x1
     834:	ac050513          	addi	a0,a0,-1344 # 12f0 <malloc+0x398>
     838:	00000097          	auipc	ra,0x0
     83c:	874080e7          	jalr	-1932(ra) # ac <test>
     840:	18ac                	addi	a1,sp,120
     842:	00001517          	auipc	a0,0x1
     846:	aae50513          	addi	a0,a0,-1362 # 12f0 <malloc+0x398>
     84a:	00000097          	auipc	ra,0x0
     84e:	862080e7          	jalr	-1950(ra) # ac <test>
     852:	10ac                	addi	a1,sp,104
     854:	00001517          	auipc	a0,0x1
     858:	a9c50513          	addi	a0,a0,-1380 # 12f0 <malloc+0x398>
     85c:	00000097          	auipc	ra,0x0
     860:	850080e7          	jalr	-1968(ra) # ac <test>
     864:	08ac                	addi	a1,sp,88
     866:	00001517          	auipc	a0,0x1
     86a:	a8a50513          	addi	a0,a0,-1398 # 12f0 <malloc+0x398>
     86e:	00000097          	auipc	ra,0x0
     872:	83e080e7          	jalr	-1986(ra) # ac <test>
     876:	00ac                	addi	a1,sp,72
     878:	00001517          	auipc	a0,0x1
     87c:	a7850513          	addi	a0,a0,-1416 # 12f0 <malloc+0x398>
     880:	00000097          	auipc	ra,0x0
     884:	82c080e7          	jalr	-2004(ra) # ac <test>
     888:	182c                	addi	a1,sp,56
     88a:	00001517          	auipc	a0,0x1
     88e:	a6650513          	addi	a0,a0,-1434 # 12f0 <malloc+0x398>
     892:	00000097          	auipc	ra,0x0
     896:	81a080e7          	jalr	-2022(ra) # ac <test>
     89a:	102c                	addi	a1,sp,40
     89c:	00001517          	auipc	a0,0x1
     8a0:	a5450513          	addi	a0,a0,-1452 # 12f0 <malloc+0x398>
     8a4:	00000097          	auipc	ra,0x0
     8a8:	808080e7          	jalr	-2040(ra) # ac <test>
     8ac:	082c                	addi	a1,sp,24
     8ae:	00001517          	auipc	a0,0x1
     8b2:	a4250513          	addi	a0,a0,-1470 # 12f0 <malloc+0x398>
     8b6:	fffff097          	auipc	ra,0xfffff
     8ba:	7f6080e7          	jalr	2038(ra) # ac <test>
     8be:	002c                	addi	a1,sp,8
     8c0:	00001517          	auipc	a0,0x1
     8c4:	a3050513          	addi	a0,a0,-1488 # 12f0 <malloc+0x398>
     8c8:	fffff097          	auipc	ra,0xfffff
     8cc:	7e4080e7          	jalr	2020(ra) # ac <test>
     8d0:	a001                	j	8d0 <main+0x7ca>
     8d2:	00000097          	auipc	ra,0x0
     8d6:	15a080e7          	jalr	346(ra) # a2c <kernel_panic>
     8da:	b501                	j	6da <main+0x5d4>
     8dc:	00000097          	auipc	ra,0x0
     8e0:	150080e7          	jalr	336(ra) # a2c <kernel_panic>
     8e4:	b539                	j	6f2 <main+0x5ec>

00000000000008e6 <fork>:
     8e6:	4885                	li	a7,1
     8e8:	00000073          	ecall
     8ec:	8082                	ret

00000000000008ee <wait>:
     8ee:	488d                	li	a7,3
     8f0:	00000073          	ecall
     8f4:	8082                	ret

00000000000008f6 <open>:
     8f6:	4889                	li	a7,2
     8f8:	00000073          	ecall
     8fc:	8082                	ret

00000000000008fe <sbrk>:
     8fe:	4891                	li	a7,4
     900:	00000073          	ecall
     904:	8082                	ret

0000000000000906 <getcwd>:
     906:	48c5                	li	a7,17
     908:	00000073          	ecall
     90c:	8082                	ret

000000000000090e <dup>:
     90e:	48dd                	li	a7,23
     910:	00000073          	ecall
     914:	8082                	ret

0000000000000916 <dup3>:
     916:	48e1                	li	a7,24
     918:	00000073          	ecall
     91c:	8082                	ret

000000000000091e <mkdirat>:
     91e:	02200893          	li	a7,34
     922:	00000073          	ecall
     926:	8082                	ret

0000000000000928 <unlinkat>:
     928:	02300893          	li	a7,35
     92c:	00000073          	ecall
     930:	8082                	ret

0000000000000932 <linkat>:
     932:	02500893          	li	a7,37
     936:	00000073          	ecall
     93a:	8082                	ret

000000000000093c <umount2>:
     93c:	02700893          	li	a7,39
     940:	00000073          	ecall
     944:	8082                	ret

0000000000000946 <mount>:
     946:	02800893          	li	a7,40
     94a:	00000073          	ecall
     94e:	8082                	ret

0000000000000950 <chdir>:
     950:	03100893          	li	a7,49
     954:	00000073          	ecall
     958:	8082                	ret

000000000000095a <openat>:
     95a:	03800893          	li	a7,56
     95e:	00000073          	ecall
     962:	8082                	ret

0000000000000964 <close>:
     964:	03900893          	li	a7,57
     968:	00000073          	ecall
     96c:	8082                	ret

000000000000096e <pipe2>:
     96e:	03b00893          	li	a7,59
     972:	00000073          	ecall
     976:	8082                	ret

0000000000000978 <getdents64>:
     978:	03d00893          	li	a7,61
     97c:	00000073          	ecall
     980:	8082                	ret

0000000000000982 <read>:
     982:	03f00893          	li	a7,63
     986:	00000073          	ecall
     98a:	8082                	ret

000000000000098c <write>:
     98c:	04000893          	li	a7,64
     990:	00000073          	ecall
     994:	8082                	ret

0000000000000996 <fstat>:
     996:	05000893          	li	a7,80
     99a:	00000073          	ecall
     99e:	8082                	ret

00000000000009a0 <exit>:
     9a0:	05d00893          	li	a7,93
     9a4:	00000073          	ecall
     9a8:	8082                	ret

00000000000009aa <nanosleep>:
     9aa:	06500893          	li	a7,101
     9ae:	00000073          	ecall
     9b2:	8082                	ret

00000000000009b4 <sched_yield>:
     9b4:	07c00893          	li	a7,124
     9b8:	00000073          	ecall
     9bc:	8082                	ret

00000000000009be <times>:
     9be:	09900893          	li	a7,153
     9c2:	00000073          	ecall
     9c6:	8082                	ret

00000000000009c8 <uname>:
     9c8:	0a000893          	li	a7,160
     9cc:	00000073          	ecall
     9d0:	8082                	ret

00000000000009d2 <gettimeofday>:
     9d2:	0a900893          	li	a7,169
     9d6:	00000073          	ecall
     9da:	8082                	ret

00000000000009dc <brk>:
     9dc:	0d600893          	li	a7,214
     9e0:	00000073          	ecall
     9e4:	8082                	ret

00000000000009e6 <munmap>:
     9e6:	0d700893          	li	a7,215
     9ea:	00000073          	ecall
     9ee:	8082                	ret

00000000000009f0 <getpid>:
     9f0:	0ac00893          	li	a7,172
     9f4:	00000073          	ecall
     9f8:	8082                	ret

00000000000009fa <getppid>:
     9fa:	0ad00893          	li	a7,173
     9fe:	00000073          	ecall
     a02:	8082                	ret

0000000000000a04 <clone>:
     a04:	0dc00893          	li	a7,220
     a08:	00000073          	ecall
     a0c:	8082                	ret

0000000000000a0e <execve>:
     a0e:	0dd00893          	li	a7,221
     a12:	00000073          	ecall
     a16:	8082                	ret

0000000000000a18 <mmap>:
     a18:	0de00893          	li	a7,222
     a1c:	00000073          	ecall
     a20:	8082                	ret

0000000000000a22 <wait4>:
     a22:	10400893          	li	a7,260
     a26:	00000073          	ecall
     a2a:	8082                	ret

0000000000000a2c <kernel_panic>:
     a2c:	18f00893          	li	a7,399
     a30:	00000073          	ecall
     a34:	8082                	ret

0000000000000a36 <strcpy>:
     a36:	87aa                	mv	a5,a0
     a38:	0585                	addi	a1,a1,1
     a3a:	0785                	addi	a5,a5,1
     a3c:	fff5c703          	lbu	a4,-1(a1)
     a40:	fee78fa3          	sb	a4,-1(a5)
     a44:	fb75                	bnez	a4,a38 <strcpy+0x2>
     a46:	8082                	ret

0000000000000a48 <strcmp>:
     a48:	00054783          	lbu	a5,0(a0)
     a4c:	cb91                	beqz	a5,a60 <strcmp+0x18>
     a4e:	0005c703          	lbu	a4,0(a1)
     a52:	00f71763          	bne	a4,a5,a60 <strcmp+0x18>
     a56:	0505                	addi	a0,a0,1
     a58:	0585                	addi	a1,a1,1
     a5a:	00054783          	lbu	a5,0(a0)
     a5e:	fbe5                	bnez	a5,a4e <strcmp+0x6>
     a60:	0005c503          	lbu	a0,0(a1)
     a64:	40a7853b          	subw	a0,a5,a0
     a68:	8082                	ret

0000000000000a6a <strlen>:
     a6a:	00054783          	lbu	a5,0(a0)
     a6e:	cf81                	beqz	a5,a86 <strlen+0x1c>
     a70:	0505                	addi	a0,a0,1
     a72:	87aa                	mv	a5,a0
     a74:	4685                	li	a3,1
     a76:	9e89                	subw	a3,a3,a0
     a78:	00f6853b          	addw	a0,a3,a5
     a7c:	0785                	addi	a5,a5,1
     a7e:	fff7c703          	lbu	a4,-1(a5)
     a82:	fb7d                	bnez	a4,a78 <strlen+0xe>
     a84:	8082                	ret
     a86:	4501                	li	a0,0
     a88:	8082                	ret

0000000000000a8a <memset>:
     a8a:	ce09                	beqz	a2,aa4 <memset+0x1a>
     a8c:	87aa                	mv	a5,a0
     a8e:	fff6071b          	addiw	a4,a2,-1
     a92:	1702                	slli	a4,a4,0x20
     a94:	9301                	srli	a4,a4,0x20
     a96:	0705                	addi	a4,a4,1
     a98:	972a                	add	a4,a4,a0
     a9a:	00b78023          	sb	a1,0(a5)
     a9e:	0785                	addi	a5,a5,1
     aa0:	fee79de3          	bne	a5,a4,a9a <memset+0x10>
     aa4:	8082                	ret

0000000000000aa6 <strchr>:
     aa6:	00054783          	lbu	a5,0(a0)
     aaa:	cb89                	beqz	a5,abc <strchr+0x16>
     aac:	00f58963          	beq	a1,a5,abe <strchr+0x18>
     ab0:	0505                	addi	a0,a0,1
     ab2:	00054783          	lbu	a5,0(a0)
     ab6:	fbfd                	bnez	a5,aac <strchr+0x6>
     ab8:	4501                	li	a0,0
     aba:	8082                	ret
     abc:	4501                	li	a0,0
     abe:	8082                	ret

0000000000000ac0 <gets>:
     ac0:	715d                	addi	sp,sp,-80
     ac2:	e486                	sd	ra,72(sp)
     ac4:	e0a2                	sd	s0,64(sp)
     ac6:	fc26                	sd	s1,56(sp)
     ac8:	f84a                	sd	s2,48(sp)
     aca:	f44e                	sd	s3,40(sp)
     acc:	f052                	sd	s4,32(sp)
     ace:	ec56                	sd	s5,24(sp)
     ad0:	e85a                	sd	s6,16(sp)
     ad2:	8b2a                	mv	s6,a0
     ad4:	89ae                	mv	s3,a1
     ad6:	84aa                	mv	s1,a0
     ad8:	4401                	li	s0,0
     ada:	4a29                	li	s4,10
     adc:	4ab5                	li	s5,13
     ade:	8922                	mv	s2,s0
     ae0:	2405                	addiw	s0,s0,1
     ae2:	03345863          	bge	s0,s3,b12 <gets+0x52>
     ae6:	4605                	li	a2,1
     ae8:	00f10593          	addi	a1,sp,15
     aec:	4501                	li	a0,0
     aee:	00000097          	auipc	ra,0x0
     af2:	e94080e7          	jalr	-364(ra) # 982 <read>
     af6:	00a05e63          	blez	a0,b12 <gets+0x52>
     afa:	00f14783          	lbu	a5,15(sp)
     afe:	00f48023          	sb	a5,0(s1)
     b02:	01478763          	beq	a5,s4,b10 <gets+0x50>
     b06:	0485                	addi	s1,s1,1
     b08:	fd579be3          	bne	a5,s5,ade <gets+0x1e>
     b0c:	8922                	mv	s2,s0
     b0e:	a011                	j	b12 <gets+0x52>
     b10:	8922                	mv	s2,s0
     b12:	995a                	add	s2,s2,s6
     b14:	00090023          	sb	zero,0(s2)
     b18:	855a                	mv	a0,s6
     b1a:	60a6                	ld	ra,72(sp)
     b1c:	6406                	ld	s0,64(sp)
     b1e:	74e2                	ld	s1,56(sp)
     b20:	7942                	ld	s2,48(sp)
     b22:	79a2                	ld	s3,40(sp)
     b24:	7a02                	ld	s4,32(sp)
     b26:	6ae2                	ld	s5,24(sp)
     b28:	6b42                	ld	s6,16(sp)
     b2a:	6161                	addi	sp,sp,80
     b2c:	8082                	ret

0000000000000b2e <atoi>:
     b2e:	86aa                	mv	a3,a0
     b30:	00054603          	lbu	a2,0(a0)
     b34:	fd06079b          	addiw	a5,a2,-48
     b38:	0ff7f793          	andi	a5,a5,255
     b3c:	4725                	li	a4,9
     b3e:	02f76663          	bltu	a4,a5,b6a <atoi+0x3c>
     b42:	4501                	li	a0,0
     b44:	45a5                	li	a1,9
     b46:	0685                	addi	a3,a3,1
     b48:	0025179b          	slliw	a5,a0,0x2
     b4c:	9fa9                	addw	a5,a5,a0
     b4e:	0017979b          	slliw	a5,a5,0x1
     b52:	9fb1                	addw	a5,a5,a2
     b54:	fd07851b          	addiw	a0,a5,-48
     b58:	0006c603          	lbu	a2,0(a3)
     b5c:	fd06071b          	addiw	a4,a2,-48
     b60:	0ff77713          	andi	a4,a4,255
     b64:	fee5f1e3          	bgeu	a1,a4,b46 <atoi+0x18>
     b68:	8082                	ret
     b6a:	4501                	li	a0,0
     b6c:	8082                	ret

0000000000000b6e <memmove>:
     b6e:	02b57463          	bgeu	a0,a1,b96 <memmove+0x28>
     b72:	04c05663          	blez	a2,bbe <memmove+0x50>
     b76:	fff6079b          	addiw	a5,a2,-1
     b7a:	1782                	slli	a5,a5,0x20
     b7c:	9381                	srli	a5,a5,0x20
     b7e:	0785                	addi	a5,a5,1
     b80:	97aa                	add	a5,a5,a0
     b82:	872a                	mv	a4,a0
     b84:	0585                	addi	a1,a1,1
     b86:	0705                	addi	a4,a4,1
     b88:	fff5c683          	lbu	a3,-1(a1)
     b8c:	fed70fa3          	sb	a3,-1(a4)
     b90:	fee79ae3          	bne	a5,a4,b84 <memmove+0x16>
     b94:	8082                	ret
     b96:	00c50733          	add	a4,a0,a2
     b9a:	95b2                	add	a1,a1,a2
     b9c:	02c05163          	blez	a2,bbe <memmove+0x50>
     ba0:	fff6079b          	addiw	a5,a2,-1
     ba4:	1782                	slli	a5,a5,0x20
     ba6:	9381                	srli	a5,a5,0x20
     ba8:	fff7c793          	not	a5,a5
     bac:	97ba                	add	a5,a5,a4
     bae:	15fd                	addi	a1,a1,-1
     bb0:	177d                	addi	a4,a4,-1
     bb2:	0005c683          	lbu	a3,0(a1)
     bb6:	00d70023          	sb	a3,0(a4)
     bba:	fee79ae3          	bne	a5,a4,bae <memmove+0x40>
     bbe:	8082                	ret

0000000000000bc0 <memcmp>:
     bc0:	fff6069b          	addiw	a3,a2,-1
     bc4:	c605                	beqz	a2,bec <memcmp+0x2c>
     bc6:	1682                	slli	a3,a3,0x20
     bc8:	9281                	srli	a3,a3,0x20
     bca:	0685                	addi	a3,a3,1
     bcc:	96aa                	add	a3,a3,a0
     bce:	00054783          	lbu	a5,0(a0)
     bd2:	0005c703          	lbu	a4,0(a1)
     bd6:	00e79863          	bne	a5,a4,be6 <memcmp+0x26>
     bda:	0505                	addi	a0,a0,1
     bdc:	0585                	addi	a1,a1,1
     bde:	fed518e3          	bne	a0,a3,bce <memcmp+0xe>
     be2:	4501                	li	a0,0
     be4:	8082                	ret
     be6:	40e7853b          	subw	a0,a5,a4
     bea:	8082                	ret
     bec:	4501                	li	a0,0
     bee:	8082                	ret

0000000000000bf0 <memcpy>:
     bf0:	1141                	addi	sp,sp,-16
     bf2:	e406                	sd	ra,8(sp)
     bf4:	00000097          	auipc	ra,0x0
     bf8:	f7a080e7          	jalr	-134(ra) # b6e <memmove>
     bfc:	60a2                	ld	ra,8(sp)
     bfe:	0141                	addi	sp,sp,16
     c00:	8082                	ret

0000000000000c02 <putc>:
     c02:	1101                	addi	sp,sp,-32
     c04:	ec06                	sd	ra,24(sp)
     c06:	00b107a3          	sb	a1,15(sp)
     c0a:	4605                	li	a2,1
     c0c:	00f10593          	addi	a1,sp,15
     c10:	00000097          	auipc	ra,0x0
     c14:	d7c080e7          	jalr	-644(ra) # 98c <write>
     c18:	60e2                	ld	ra,24(sp)
     c1a:	6105                	addi	sp,sp,32
     c1c:	8082                	ret

0000000000000c1e <printint>:
     c1e:	7179                	addi	sp,sp,-48
     c20:	f406                	sd	ra,40(sp)
     c22:	f022                	sd	s0,32(sp)
     c24:	ec26                	sd	s1,24(sp)
     c26:	e84a                	sd	s2,16(sp)
     c28:	84aa                	mv	s1,a0
     c2a:	c299                	beqz	a3,c30 <printint+0x12>
     c2c:	0805c363          	bltz	a1,cb2 <printint+0x94>
     c30:	2581                	sext.w	a1,a1
     c32:	4881                	li	a7,0
     c34:	868a                	mv	a3,sp
     c36:	4701                	li	a4,0
     c38:	2601                	sext.w	a2,a2
     c3a:	00000517          	auipc	a0,0x0
     c3e:	7b650513          	addi	a0,a0,1974 # 13f0 <digits>
     c42:	883a                	mv	a6,a4
     c44:	2705                	addiw	a4,a4,1
     c46:	02c5f7bb          	remuw	a5,a1,a2
     c4a:	1782                	slli	a5,a5,0x20
     c4c:	9381                	srli	a5,a5,0x20
     c4e:	97aa                	add	a5,a5,a0
     c50:	0007c783          	lbu	a5,0(a5)
     c54:	00f68023          	sb	a5,0(a3)
     c58:	0005879b          	sext.w	a5,a1
     c5c:	02c5d5bb          	divuw	a1,a1,a2
     c60:	0685                	addi	a3,a3,1
     c62:	fec7f0e3          	bgeu	a5,a2,c42 <printint+0x24>
     c66:	00088a63          	beqz	a7,c7a <printint+0x5c>
     c6a:	081c                	addi	a5,sp,16
     c6c:	973e                	add	a4,a4,a5
     c6e:	02d00793          	li	a5,45
     c72:	fef70823          	sb	a5,-16(a4)
     c76:	0028071b          	addiw	a4,a6,2
     c7a:	02e05663          	blez	a4,ca6 <printint+0x88>
     c7e:	00e10433          	add	s0,sp,a4
     c82:	fff10913          	addi	s2,sp,-1
     c86:	993a                	add	s2,s2,a4
     c88:	377d                	addiw	a4,a4,-1
     c8a:	1702                	slli	a4,a4,0x20
     c8c:	9301                	srli	a4,a4,0x20
     c8e:	40e90933          	sub	s2,s2,a4
     c92:	fff44583          	lbu	a1,-1(s0)
     c96:	8526                	mv	a0,s1
     c98:	00000097          	auipc	ra,0x0
     c9c:	f6a080e7          	jalr	-150(ra) # c02 <putc>
     ca0:	147d                	addi	s0,s0,-1
     ca2:	ff2418e3          	bne	s0,s2,c92 <printint+0x74>
     ca6:	70a2                	ld	ra,40(sp)
     ca8:	7402                	ld	s0,32(sp)
     caa:	64e2                	ld	s1,24(sp)
     cac:	6942                	ld	s2,16(sp)
     cae:	6145                	addi	sp,sp,48
     cb0:	8082                	ret
     cb2:	40b005bb          	negw	a1,a1
     cb6:	4885                	li	a7,1
     cb8:	bfb5                	j	c34 <printint+0x16>

0000000000000cba <vprintf>:
     cba:	7119                	addi	sp,sp,-128
     cbc:	fc86                	sd	ra,120(sp)
     cbe:	f8a2                	sd	s0,112(sp)
     cc0:	f4a6                	sd	s1,104(sp)
     cc2:	f0ca                	sd	s2,96(sp)
     cc4:	ecce                	sd	s3,88(sp)
     cc6:	e8d2                	sd	s4,80(sp)
     cc8:	e4d6                	sd	s5,72(sp)
     cca:	e0da                	sd	s6,64(sp)
     ccc:	fc5e                	sd	s7,56(sp)
     cce:	f862                	sd	s8,48(sp)
     cd0:	f466                	sd	s9,40(sp)
     cd2:	f06a                	sd	s10,32(sp)
     cd4:	ec6e                	sd	s11,24(sp)
     cd6:	0005c483          	lbu	s1,0(a1)
     cda:	18048c63          	beqz	s1,e72 <vprintf+0x1b8>
     cde:	8a2a                	mv	s4,a0
     ce0:	8ab2                	mv	s5,a2
     ce2:	00158413          	addi	s0,a1,1
     ce6:	4901                	li	s2,0
     ce8:	02500993          	li	s3,37
     cec:	06400b93          	li	s7,100
     cf0:	06c00c13          	li	s8,108
     cf4:	07800c93          	li	s9,120
     cf8:	07000d13          	li	s10,112
     cfc:	07300d93          	li	s11,115
     d00:	00000b17          	auipc	s6,0x0
     d04:	6f0b0b13          	addi	s6,s6,1776 # 13f0 <digits>
     d08:	a839                	j	d26 <vprintf+0x6c>
     d0a:	85a6                	mv	a1,s1
     d0c:	8552                	mv	a0,s4
     d0e:	00000097          	auipc	ra,0x0
     d12:	ef4080e7          	jalr	-268(ra) # c02 <putc>
     d16:	a019                	j	d1c <vprintf+0x62>
     d18:	01390f63          	beq	s2,s3,d36 <vprintf+0x7c>
     d1c:	0405                	addi	s0,s0,1
     d1e:	fff44483          	lbu	s1,-1(s0)
     d22:	14048863          	beqz	s1,e72 <vprintf+0x1b8>
     d26:	0004879b          	sext.w	a5,s1
     d2a:	fe0917e3          	bnez	s2,d18 <vprintf+0x5e>
     d2e:	fd379ee3          	bne	a5,s3,d0a <vprintf+0x50>
     d32:	893e                	mv	s2,a5
     d34:	b7e5                	j	d1c <vprintf+0x62>
     d36:	03778e63          	beq	a5,s7,d72 <vprintf+0xb8>
     d3a:	05878a63          	beq	a5,s8,d8e <vprintf+0xd4>
     d3e:	07978663          	beq	a5,s9,daa <vprintf+0xf0>
     d42:	09a78263          	beq	a5,s10,dc6 <vprintf+0x10c>
     d46:	0db78363          	beq	a5,s11,e0c <vprintf+0x152>
     d4a:	06300713          	li	a4,99
     d4e:	0ee78b63          	beq	a5,a4,e44 <vprintf+0x18a>
     d52:	11378563          	beq	a5,s3,e5c <vprintf+0x1a2>
     d56:	85ce                	mv	a1,s3
     d58:	8552                	mv	a0,s4
     d5a:	00000097          	auipc	ra,0x0
     d5e:	ea8080e7          	jalr	-344(ra) # c02 <putc>
     d62:	85a6                	mv	a1,s1
     d64:	8552                	mv	a0,s4
     d66:	00000097          	auipc	ra,0x0
     d6a:	e9c080e7          	jalr	-356(ra) # c02 <putc>
     d6e:	4901                	li	s2,0
     d70:	b775                	j	d1c <vprintf+0x62>
     d72:	008a8493          	addi	s1,s5,8
     d76:	4685                	li	a3,1
     d78:	4629                	li	a2,10
     d7a:	000aa583          	lw	a1,0(s5)
     d7e:	8552                	mv	a0,s4
     d80:	00000097          	auipc	ra,0x0
     d84:	e9e080e7          	jalr	-354(ra) # c1e <printint>
     d88:	8aa6                	mv	s5,s1
     d8a:	4901                	li	s2,0
     d8c:	bf41                	j	d1c <vprintf+0x62>
     d8e:	008a8493          	addi	s1,s5,8
     d92:	4681                	li	a3,0
     d94:	4629                	li	a2,10
     d96:	000aa583          	lw	a1,0(s5)
     d9a:	8552                	mv	a0,s4
     d9c:	00000097          	auipc	ra,0x0
     da0:	e82080e7          	jalr	-382(ra) # c1e <printint>
     da4:	8aa6                	mv	s5,s1
     da6:	4901                	li	s2,0
     da8:	bf95                	j	d1c <vprintf+0x62>
     daa:	008a8493          	addi	s1,s5,8
     dae:	4681                	li	a3,0
     db0:	4641                	li	a2,16
     db2:	000aa583          	lw	a1,0(s5)
     db6:	8552                	mv	a0,s4
     db8:	00000097          	auipc	ra,0x0
     dbc:	e66080e7          	jalr	-410(ra) # c1e <printint>
     dc0:	8aa6                	mv	s5,s1
     dc2:	4901                	li	s2,0
     dc4:	bfa1                	j	d1c <vprintf+0x62>
     dc6:	008a8793          	addi	a5,s5,8
     dca:	e43e                	sd	a5,8(sp)
     dcc:	000ab903          	ld	s2,0(s5)
     dd0:	03000593          	li	a1,48
     dd4:	8552                	mv	a0,s4
     dd6:	00000097          	auipc	ra,0x0
     dda:	e2c080e7          	jalr	-468(ra) # c02 <putc>
     dde:	85e6                	mv	a1,s9
     de0:	8552                	mv	a0,s4
     de2:	00000097          	auipc	ra,0x0
     de6:	e20080e7          	jalr	-480(ra) # c02 <putc>
     dea:	44c1                	li	s1,16
     dec:	03c95793          	srli	a5,s2,0x3c
     df0:	97da                	add	a5,a5,s6
     df2:	0007c583          	lbu	a1,0(a5)
     df6:	8552                	mv	a0,s4
     df8:	00000097          	auipc	ra,0x0
     dfc:	e0a080e7          	jalr	-502(ra) # c02 <putc>
     e00:	0912                	slli	s2,s2,0x4
     e02:	34fd                	addiw	s1,s1,-1
     e04:	f4e5                	bnez	s1,dec <vprintf+0x132>
     e06:	6aa2                	ld	s5,8(sp)
     e08:	4901                	li	s2,0
     e0a:	bf09                	j	d1c <vprintf+0x62>
     e0c:	008a8493          	addi	s1,s5,8
     e10:	000ab903          	ld	s2,0(s5)
     e14:	02090163          	beqz	s2,e36 <vprintf+0x17c>
     e18:	00094583          	lbu	a1,0(s2)
     e1c:	c9a1                	beqz	a1,e6c <vprintf+0x1b2>
     e1e:	8552                	mv	a0,s4
     e20:	00000097          	auipc	ra,0x0
     e24:	de2080e7          	jalr	-542(ra) # c02 <putc>
     e28:	0905                	addi	s2,s2,1
     e2a:	00094583          	lbu	a1,0(s2)
     e2e:	f9e5                	bnez	a1,e1e <vprintf+0x164>
     e30:	8aa6                	mv	s5,s1
     e32:	4901                	li	s2,0
     e34:	b5e5                	j	d1c <vprintf+0x62>
     e36:	00000917          	auipc	s2,0x0
     e3a:	5b290913          	addi	s2,s2,1458 # 13e8 <malloc+0x490>
     e3e:	02800593          	li	a1,40
     e42:	bff1                	j	e1e <vprintf+0x164>
     e44:	008a8493          	addi	s1,s5,8
     e48:	000ac583          	lbu	a1,0(s5)
     e4c:	8552                	mv	a0,s4
     e4e:	00000097          	auipc	ra,0x0
     e52:	db4080e7          	jalr	-588(ra) # c02 <putc>
     e56:	8aa6                	mv	s5,s1
     e58:	4901                	li	s2,0
     e5a:	b5c9                	j	d1c <vprintf+0x62>
     e5c:	85ce                	mv	a1,s3
     e5e:	8552                	mv	a0,s4
     e60:	00000097          	auipc	ra,0x0
     e64:	da2080e7          	jalr	-606(ra) # c02 <putc>
     e68:	4901                	li	s2,0
     e6a:	bd4d                	j	d1c <vprintf+0x62>
     e6c:	8aa6                	mv	s5,s1
     e6e:	4901                	li	s2,0
     e70:	b575                	j	d1c <vprintf+0x62>
     e72:	70e6                	ld	ra,120(sp)
     e74:	7446                	ld	s0,112(sp)
     e76:	74a6                	ld	s1,104(sp)
     e78:	7906                	ld	s2,96(sp)
     e7a:	69e6                	ld	s3,88(sp)
     e7c:	6a46                	ld	s4,80(sp)
     e7e:	6aa6                	ld	s5,72(sp)
     e80:	6b06                	ld	s6,64(sp)
     e82:	7be2                	ld	s7,56(sp)
     e84:	7c42                	ld	s8,48(sp)
     e86:	7ca2                	ld	s9,40(sp)
     e88:	7d02                	ld	s10,32(sp)
     e8a:	6de2                	ld	s11,24(sp)
     e8c:	6109                	addi	sp,sp,128
     e8e:	8082                	ret

0000000000000e90 <fprintf>:
     e90:	715d                	addi	sp,sp,-80
     e92:	ec06                	sd	ra,24(sp)
     e94:	f032                	sd	a2,32(sp)
     e96:	f436                	sd	a3,40(sp)
     e98:	f83a                	sd	a4,48(sp)
     e9a:	fc3e                	sd	a5,56(sp)
     e9c:	e0c2                	sd	a6,64(sp)
     e9e:	e4c6                	sd	a7,72(sp)
     ea0:	1010                	addi	a2,sp,32
     ea2:	e432                	sd	a2,8(sp)
     ea4:	00000097          	auipc	ra,0x0
     ea8:	e16080e7          	jalr	-490(ra) # cba <vprintf>
     eac:	60e2                	ld	ra,24(sp)
     eae:	6161                	addi	sp,sp,80
     eb0:	8082                	ret

0000000000000eb2 <printf>:
     eb2:	711d                	addi	sp,sp,-96
     eb4:	ec06                	sd	ra,24(sp)
     eb6:	f42e                	sd	a1,40(sp)
     eb8:	f832                	sd	a2,48(sp)
     eba:	fc36                	sd	a3,56(sp)
     ebc:	e0ba                	sd	a4,64(sp)
     ebe:	e4be                	sd	a5,72(sp)
     ec0:	e8c2                	sd	a6,80(sp)
     ec2:	ecc6                	sd	a7,88(sp)
     ec4:	1030                	addi	a2,sp,40
     ec6:	e432                	sd	a2,8(sp)
     ec8:	85aa                	mv	a1,a0
     eca:	4505                	li	a0,1
     ecc:	00000097          	auipc	ra,0x0
     ed0:	dee080e7          	jalr	-530(ra) # cba <vprintf>
     ed4:	60e2                	ld	ra,24(sp)
     ed6:	6125                	addi	sp,sp,96
     ed8:	8082                	ret

0000000000000eda <free>:
     eda:	ff050693          	addi	a3,a0,-16
     ede:	00000797          	auipc	a5,0x0
     ee2:	52a7b783          	ld	a5,1322(a5) # 1408 <freep>
     ee6:	a805                	j	f16 <free+0x3c>
     ee8:	4618                	lw	a4,8(a2)
     eea:	9db9                	addw	a1,a1,a4
     eec:	feb52c23          	sw	a1,-8(a0)
     ef0:	6398                	ld	a4,0(a5)
     ef2:	6318                	ld	a4,0(a4)
     ef4:	fee53823          	sd	a4,-16(a0)
     ef8:	a091                	j	f3c <free+0x62>
     efa:	ff852703          	lw	a4,-8(a0)
     efe:	9e39                	addw	a2,a2,a4
     f00:	c790                	sw	a2,8(a5)
     f02:	ff053703          	ld	a4,-16(a0)
     f06:	e398                	sd	a4,0(a5)
     f08:	a099                	j	f4e <free+0x74>
     f0a:	6398                	ld	a4,0(a5)
     f0c:	00e7e463          	bltu	a5,a4,f14 <free+0x3a>
     f10:	00e6ea63          	bltu	a3,a4,f24 <free+0x4a>
     f14:	87ba                	mv	a5,a4
     f16:	fed7fae3          	bgeu	a5,a3,f0a <free+0x30>
     f1a:	6398                	ld	a4,0(a5)
     f1c:	00e6e463          	bltu	a3,a4,f24 <free+0x4a>
     f20:	fee7eae3          	bltu	a5,a4,f14 <free+0x3a>
     f24:	ff852583          	lw	a1,-8(a0)
     f28:	6390                	ld	a2,0(a5)
     f2a:	02059713          	slli	a4,a1,0x20
     f2e:	9301                	srli	a4,a4,0x20
     f30:	0712                	slli	a4,a4,0x4
     f32:	9736                	add	a4,a4,a3
     f34:	fae60ae3          	beq	a2,a4,ee8 <free+0xe>
     f38:	fec53823          	sd	a2,-16(a0)
     f3c:	4790                	lw	a2,8(a5)
     f3e:	02061713          	slli	a4,a2,0x20
     f42:	9301                	srli	a4,a4,0x20
     f44:	0712                	slli	a4,a4,0x4
     f46:	973e                	add	a4,a4,a5
     f48:	fae689e3          	beq	a3,a4,efa <free+0x20>
     f4c:	e394                	sd	a3,0(a5)
     f4e:	00000717          	auipc	a4,0x0
     f52:	4af73d23          	sd	a5,1210(a4) # 1408 <freep>
     f56:	8082                	ret

0000000000000f58 <malloc>:
     f58:	7139                	addi	sp,sp,-64
     f5a:	fc06                	sd	ra,56(sp)
     f5c:	f822                	sd	s0,48(sp)
     f5e:	f426                	sd	s1,40(sp)
     f60:	f04a                	sd	s2,32(sp)
     f62:	ec4e                	sd	s3,24(sp)
     f64:	e852                	sd	s4,16(sp)
     f66:	e456                	sd	s5,8(sp)
     f68:	02051413          	slli	s0,a0,0x20
     f6c:	9001                	srli	s0,s0,0x20
     f6e:	043d                	addi	s0,s0,15
     f70:	8011                	srli	s0,s0,0x4
     f72:	0014091b          	addiw	s2,s0,1
     f76:	0405                	addi	s0,s0,1
     f78:	00000517          	auipc	a0,0x0
     f7c:	49053503          	ld	a0,1168(a0) # 1408 <freep>
     f80:	c905                	beqz	a0,fb0 <malloc+0x58>
     f82:	611c                	ld	a5,0(a0)
     f84:	4798                	lw	a4,8(a5)
     f86:	04877163          	bgeu	a4,s0,fc8 <malloc+0x70>
     f8a:	89ca                	mv	s3,s2
     f8c:	0009071b          	sext.w	a4,s2
     f90:	6685                	lui	a3,0x1
     f92:	00d77363          	bgeu	a4,a3,f98 <malloc+0x40>
     f96:	6985                	lui	s3,0x1
     f98:	00098a1b          	sext.w	s4,s3
     f9c:	1982                	slli	s3,s3,0x20
     f9e:	0209d993          	srli	s3,s3,0x20
     fa2:	0992                	slli	s3,s3,0x4
     fa4:	00000497          	auipc	s1,0x0
     fa8:	46448493          	addi	s1,s1,1124 # 1408 <freep>
     fac:	5afd                	li	s5,-1
     fae:	a0bd                	j	101c <malloc+0xc4>
     fb0:	00000797          	auipc	a5,0x0
     fb4:	46078793          	addi	a5,a5,1120 # 1410 <base>
     fb8:	00000717          	auipc	a4,0x0
     fbc:	44f73823          	sd	a5,1104(a4) # 1408 <freep>
     fc0:	e39c                	sd	a5,0(a5)
     fc2:	0007a423          	sw	zero,8(a5)
     fc6:	b7d1                	j	f8a <malloc+0x32>
     fc8:	02e40a63          	beq	s0,a4,ffc <malloc+0xa4>
     fcc:	4127073b          	subw	a4,a4,s2
     fd0:	c798                	sw	a4,8(a5)
     fd2:	1702                	slli	a4,a4,0x20
     fd4:	9301                	srli	a4,a4,0x20
     fd6:	0712                	slli	a4,a4,0x4
     fd8:	97ba                	add	a5,a5,a4
     fda:	0127a423          	sw	s2,8(a5)
     fde:	00000717          	auipc	a4,0x0
     fe2:	42a73523          	sd	a0,1066(a4) # 1408 <freep>
     fe6:	01078513          	addi	a0,a5,16
     fea:	70e2                	ld	ra,56(sp)
     fec:	7442                	ld	s0,48(sp)
     fee:	74a2                	ld	s1,40(sp)
     ff0:	7902                	ld	s2,32(sp)
     ff2:	69e2                	ld	s3,24(sp)
     ff4:	6a42                	ld	s4,16(sp)
     ff6:	6aa2                	ld	s5,8(sp)
     ff8:	6121                	addi	sp,sp,64
     ffa:	8082                	ret
     ffc:	6398                	ld	a4,0(a5)
     ffe:	e118                	sd	a4,0(a0)
    1000:	bff9                	j	fde <malloc+0x86>
    1002:	01452423          	sw	s4,8(a0)
    1006:	0541                	addi	a0,a0,16
    1008:	00000097          	auipc	ra,0x0
    100c:	ed2080e7          	jalr	-302(ra) # eda <free>
    1010:	6088                	ld	a0,0(s1)
    1012:	dd61                	beqz	a0,fea <malloc+0x92>
    1014:	611c                	ld	a5,0(a0)
    1016:	4798                	lw	a4,8(a5)
    1018:	fa8778e3          	bgeu	a4,s0,fc8 <malloc+0x70>
    101c:	6098                	ld	a4,0(s1)
    101e:	853e                	mv	a0,a5
    1020:	fef71ae3          	bne	a4,a5,1014 <malloc+0xbc>
    1024:	854e                	mv	a0,s3
    1026:	00000097          	auipc	ra,0x0
    102a:	8d8080e7          	jalr	-1832(ra) # 8fe <sbrk>
    102e:	fd551ae3          	bne	a0,s5,1002 <malloc+0xaa>
    1032:	4501                	li	a0,0
    1034:	bf5d                	j	fea <malloc+0x92>
