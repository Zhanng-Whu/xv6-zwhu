
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
