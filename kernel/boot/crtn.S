
.section .init
	/* gcc will nicely put the contents of crtend.o's .init section here. */
	  ld	ra,88(sp)
    ld	s0,80(sp)
    ld	s1,72(sp)
    ld	s2,64(sp)
    ld	s3,56(sp)
    ld	s4,48(sp)
    ld	s5,40(sp)
    ld	s6,32(sp)
    ld	s7,24(sp)
    ld	s8,16(sp)
    ld	s9,8(sp)
    addi	sp,sp,96
    ret

.section .fini
	/* gcc will nicely put the contents of crtend.o's .fini section here. */
	  ld	ra,88(sp)
    ld	s0,80(sp)
    ld	s1,72(sp)
    ld	s2,64(sp)
    ld	s3,56(sp)
    ld	s4,48(sp)
    ld	s5,40(sp)
    ld	s6,32(sp)
    ld	s7,24(sp)
    ld	s8,16(sp)
    ld	s9,8(sp)
    addi	sp,sp,96
    ret
