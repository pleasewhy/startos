
.section .init
.global _init
.type _init, @function
_init:
  addi	sp,sp,-96
  sd	ra,88(sp)
  sd	s0,80(sp)
  sd	s1,72(sp)
  sd	s2,64(sp)
  sd	s3,56(sp)
  sd	s4,48(sp)
  sd	s5,40(sp)
  sd	s6,32(sp)
  sd	s7,24(sp)
  sd	s8,16(sp)
  sd	s9,8(sp)
  addi	s0,sp,96

/* gcc will nicely put the contents of crtbegin.o's .init section here. */

.section .fini
.global _fini
.type _fini, @function
_fini:
  addi	sp,sp,-96
  sd	ra,88(sp)
  sd	s0,80(sp)
  sd	s1,72(sp)
  sd	s2,64(sp)
  sd	s3,56(sp)
  sd	s4,48(sp)
  sd	s5,40(sp)
  sd	s6,32(sp)
  sd	s7,24(sp)
  sd	s8,16(sp)
  sd	s9,8(sp)
  addi	s0,sp,96

/* gcc will nicely put the contents of crtbegin.o's .fini section here. */
