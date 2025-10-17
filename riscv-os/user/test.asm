
user/_test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <func>:
int func(int a){
   0:	1141                	add	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	add	s0,sp,16
    return a;
}
   6:	6422                	ld	s0,8(sp)
   8:	0141                	add	sp,sp,16
   a:	8082                	ret

000000000000000c <main>:
int main(){
   c:	1141                	add	sp,sp,-16
   e:	e422                	sd	s0,8(sp)
  10:	0800                	add	s0,sp,16
    int a = 1;
    func(a);
    return 0;
  12:	4501                	li	a0,0
  14:	6422                	ld	s0,8(sp)
  16:	0141                	add	sp,sp,16
  18:	8082                	ret

000000000000001a <start>:
#include "include/user.h"


void
start(int argc, char **argv)
{
  1a:	1141                	add	sp,sp,-16
  1c:	e406                	sd	ra,8(sp)
  1e:	e022                	sd	s0,0(sp)
  20:	0800                	add	s0,sp,16
  extern int main(int argc, char **argv);
    main(argc, argv);
  22:	febff0ef          	jal	c <main>

  for(;;);
  26:	a001                	j	26 <start+0xc>
