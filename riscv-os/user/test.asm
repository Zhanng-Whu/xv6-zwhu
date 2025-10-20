
user/_test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "include/types.h"
#include "include/user.h"
int main(int argc, char *argv[]){
   0:	1141                	add	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	add	s0,sp,16
    hello();
   8:	160000ef          	jal	168 <hello>
    return 0;
   c:	4501                	li	a0,0
   e:	60a2                	ld	ra,8(sp)
  10:	6402                	ld	s0,0(sp)
  12:	0141                	add	sp,sp,16
  14:	8082                	ret

0000000000000016 <start>:
#include "include/user.h"


void
start(int argc, char **argv)
{
  16:	1141                	add	sp,sp,-16
  18:	e406                	sd	ra,8(sp)
  1a:	e022                	sd	s0,0(sp)
  1c:	0800                	add	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  1e:	fe3ff0ef          	jal	0 <main>


  exit(r);
  22:	14e000ef          	jal	170 <exit>

0000000000000026 <itoa>:
{
  char temp[16];
  int i = 0;
  int j = 0;

  if (n == 0) {
  26:	cd25                	beqz	a0,9e <itoa+0x78>
{
  28:	1101                	add	sp,sp,-32
  2a:	ec22                	sd	s0,24(sp)
  2c:	1000                	add	s0,sp,32
    buf[1] = '\0';
    return;
  }
  
  // Generate digits in reverse order
  while (n > 0) {
  2e:	fe040693          	add	a3,s0,-32
  int i = 0;
  32:	4701                	li	a4,0
    temp[i++] = (n % 10) + '0';
  34:	4829                	li	a6,10
  while (n > 0) {
  36:	48a5                	li	a7,9
    n /= 10;
  }
  temp[i] = '\0';

  // Reverse the string to get the correct order
  for (j = 0; j < i; j++) {
  38:	4601                	li	a2,0
  while (n > 0) {
  3a:	04a05c63          	blez	a0,92 <itoa+0x6c>
    temp[i++] = (n % 10) + '0';
  3e:	863a                	mv	a2,a4
  40:	2705                	addw	a4,a4,1
  42:	030567bb          	remw	a5,a0,a6
  46:	0307879b          	addw	a5,a5,48
  4a:	00f68023          	sb	a5,0(a3)
    n /= 10;
  4e:	87aa                	mv	a5,a0
  50:	0305453b          	divw	a0,a0,a6
  while (n > 0) {
  54:	0685                	add	a3,a3,1
  56:	fef8c4e3          	blt	a7,a5,3e <itoa+0x18>
  temp[i] = '\0';
  5a:	ff070793          	add	a5,a4,-16
  5e:	97a2                	add	a5,a5,s0
  60:	fe078823          	sb	zero,-16(a5)
  for (j = 0; j < i; j++) {
  64:	04e05463          	blez	a4,ac <itoa+0x86>
  68:	fe040793          	add	a5,s0,-32
  6c:	00c786b3          	add	a3,a5,a2
  70:	87ae                	mv	a5,a1
    buf[j] = temp[i - 1 - j];
  72:	0006c703          	lbu	a4,0(a3)
  76:	00e78023          	sb	a4,0(a5)
  for (j = 0; j < i; j++) {
  7a:	16fd                	add	a3,a3,-1
  7c:	0785                	add	a5,a5,1
  7e:	40b7873b          	subw	a4,a5,a1
  82:	377d                	addw	a4,a4,-1
  84:	fec747e3          	blt	a4,a2,72 <itoa+0x4c>
  88:	fff64793          	not	a5,a2
  8c:	97fd                	sra	a5,a5,0x3f
  8e:	8e7d                	and	a2,a2,a5
  90:	2605                	addw	a2,a2,1
  }
  buf[j] = '\0';
  92:	95b2                	add	a1,a1,a2
  94:	00058023          	sb	zero,0(a1)
}
  98:	6462                	ld	s0,24(sp)
  9a:	6105                	add	sp,sp,32
  9c:	8082                	ret
    buf[0] = '0';
  9e:	03000793          	li	a5,48
  a2:	00f58023          	sb	a5,0(a1)
    buf[1] = '\0';
  a6:	000580a3          	sb	zero,1(a1)
    return;
  aa:	8082                	ret
  for (j = 0; j < i; j++) {
  ac:	4601                	li	a2,0
  ae:	b7d5                	j	92 <itoa+0x6c>

00000000000000b0 <strcpy>:

void strcpy(char *dst, const char *src) {
  b0:	1141                	add	sp,sp,-16
  b2:	e422                	sd	s0,8(sp)
  b4:	0800                	add	s0,sp,16
    while ((*dst++ = *src++) != '\0');
  b6:	0585                	add	a1,a1,1
  b8:	0505                	add	a0,a0,1
  ba:	fff5c783          	lbu	a5,-1(a1)
  be:	fef50fa3          	sb	a5,-1(a0)
  c2:	fbf5                	bnez	a5,b6 <strcpy+0x6>
} 
  c4:	6422                	ld	s0,8(sp)
  c6:	0141                	add	sp,sp,16
  c8:	8082                	ret

00000000000000ca <strlen>:

uint
strlen(const char *s){
  ca:	1141                	add	sp,sp,-16
  cc:	e422                	sd	s0,8(sp)
  ce:	0800                	add	s0,sp,16
  int n;
  for(n = 0; s[n]; n++);
  d0:	00054783          	lbu	a5,0(a0)
  d4:	cf91                	beqz	a5,f0 <strlen+0x26>
  d6:	0505                	add	a0,a0,1
  d8:	87aa                	mv	a5,a0
  da:	86be                	mv	a3,a5
  dc:	0785                	add	a5,a5,1
  de:	fff7c703          	lbu	a4,-1(a5)
  e2:	ff65                	bnez	a4,da <strlen+0x10>
  e4:	40a6853b          	subw	a0,a3,a0
  e8:	2505                	addw	a0,a0,1
  return n;
}
  ea:	6422                	ld	s0,8(sp)
  ec:	0141                	add	sp,sp,16
  ee:	8082                	ret
  for(n = 0; s[n]; n++);
  f0:	4501                	li	a0,0
  f2:	bfe5                	j	ea <strlen+0x20>

00000000000000f4 <strcmp>:

uint
strcmp(const char *p, const char *q)
{
  f4:	1141                	add	sp,sp,-16
  f6:	e422                	sd	s0,8(sp)
  f8:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  fa:	00054783          	lbu	a5,0(a0)
  fe:	cb91                	beqz	a5,112 <strcmp+0x1e>
 100:	0005c703          	lbu	a4,0(a1)
 104:	00f71763          	bne	a4,a5,112 <strcmp+0x1e>
    p++, q++;
 108:	0505                	add	a0,a0,1
 10a:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 10c:	00054783          	lbu	a5,0(a0)
 110:	fbe5                	bnez	a5,100 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 112:	0005c503          	lbu	a0,0(a1)
}
 116:	40a7853b          	subw	a0,a5,a0
 11a:	6422                	ld	s0,8(sp)
 11c:	0141                	add	sp,sp,16
 11e:	8082                	ret

0000000000000120 <atoi>:
int
atoi(const char *s)
{
 120:	1141                	add	sp,sp,-16
 122:	e422                	sd	s0,8(sp)
 124:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 126:	00054683          	lbu	a3,0(a0)
 12a:	fd06879b          	addw	a5,a3,-48
 12e:	0ff7f793          	zext.b	a5,a5
 132:	4625                	li	a2,9
 134:	02f66863          	bltu	a2,a5,164 <atoi+0x44>
 138:	872a                	mv	a4,a0
  n = 0;
 13a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 13c:	0705                	add	a4,a4,1
 13e:	0025179b          	sllw	a5,a0,0x2
 142:	9fa9                	addw	a5,a5,a0
 144:	0017979b          	sllw	a5,a5,0x1
 148:	9fb5                	addw	a5,a5,a3
 14a:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 14e:	00074683          	lbu	a3,0(a4)
 152:	fd06879b          	addw	a5,a3,-48
 156:	0ff7f793          	zext.b	a5,a5
 15a:	fef671e3          	bgeu	a2,a5,13c <atoi+0x1c>
  return n;
 15e:	6422                	ld	s0,8(sp)
 160:	0141                	add	sp,sp,16
 162:	8082                	ret
  n = 0;
 164:	4501                	li	a0,0
 166:	bfe5                	j	15e <atoi+0x3e>

0000000000000168 <hello>:
# generated by usys.pl - do not edit
#include "include/syscall.h"
.global hello
hello:
 li a7, SYS_hello
 168:	4885                	li	a7,1
 ecall
 16a:	00000073          	ecall
 ret
 16e:	8082                	ret

0000000000000170 <exit>:
.global exit
exit:
 li a7, SYS_exit
 170:	4889                	li	a7,2
 ecall
 172:	00000073          	ecall
 ret
 176:	8082                	ret

0000000000000178 <fork>:
.global fork
fork:
 li a7, SYS_fork
 178:	4891                	li	a7,4
 ecall
 17a:	00000073          	ecall
 ret
 17e:	8082                	ret

0000000000000180 <wait>:
.global wait
wait:
 li a7, SYS_wait
 180:	488d                	li	a7,3
 ecall
 182:	00000073          	ecall
 ret
 186:	8082                	ret

0000000000000188 <exec>:
.global exec
exec:
 li a7, SYS_exec
 188:	4895                	li	a7,5
 ecall
 18a:	00000073          	ecall
 ret
 18e:	8082                	ret

0000000000000190 <dup>:
.global dup
dup:
 li a7, SYS_dup
 190:	489d                	li	a7,7
 ecall
 192:	00000073          	ecall
 ret
 196:	8082                	ret

0000000000000198 <open>:
.global open
open:
 li a7, SYS_open
 198:	4899                	li	a7,6
 ecall
 19a:	00000073          	ecall
 ret
 19e:	8082                	ret

00000000000001a0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 1a0:	48a1                	li	a7,8
 ecall
 1a2:	00000073          	ecall
 ret
 1a6:	8082                	ret

00000000000001a8 <write>:
.global write
write:
 li a7, SYS_write
 1a8:	48a5                	li	a7,9
 ecall
 1aa:	00000073          	ecall
 ret
 1ae:	8082                	ret

00000000000001b0 <read>:
.global read
read:
 li a7, SYS_read
 1b0:	48a9                	li	a7,10
 ecall
 1b2:	00000073          	ecall
 ret
 1b6:	8082                	ret

00000000000001b8 <close>:
.global close
close:
 li a7, SYS_close
 1b8:	48ad                	li	a7,11
 ecall
 1ba:	00000073          	ecall
 ret
 1be:	8082                	ret

00000000000001c0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 1c0:	48b1                	li	a7,12
 ecall
 1c2:	00000073          	ecall
 ret
 1c6:	8082                	ret

00000000000001c8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 1c8:	48b5                	li	a7,13
 ecall
 1ca:	00000073          	ecall
 ret
 1ce:	8082                	ret

00000000000001d0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 1d0:	48b9                	li	a7,14
 ecall
 1d2:	00000073          	ecall
 ret
 1d6:	8082                	ret

00000000000001d8 <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
 1d8:	48bd                	li	a7,15
 ecall
 1da:	00000073          	ecall
 ret
 1de:	8082                	ret

00000000000001e0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 1e0:	1101                	add	sp,sp,-32
 1e2:	ec06                	sd	ra,24(sp)
 1e4:	e822                	sd	s0,16(sp)
 1e6:	1000                	add	s0,sp,32
 1e8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 1ec:	4605                	li	a2,1
 1ee:	fef40593          	add	a1,s0,-17
 1f2:	fb7ff0ef          	jal	1a8 <write>
}
 1f6:	60e2                	ld	ra,24(sp)
 1f8:	6442                	ld	s0,16(sp)
 1fa:	6105                	add	sp,sp,32
 1fc:	8082                	ret

00000000000001fe <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 1fe:	715d                	add	sp,sp,-80
 200:	e486                	sd	ra,72(sp)
 202:	e0a2                	sd	s0,64(sp)
 204:	fc26                	sd	s1,56(sp)
 206:	f84a                	sd	s2,48(sp)
 208:	f44e                	sd	s3,40(sp)
 20a:	0880                	add	s0,sp,80
 20c:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 20e:	c299                	beqz	a3,214 <printint+0x16>
 210:	0605cf63          	bltz	a1,28e <printint+0x90>
  neg = 0;
 214:	4881                	li	a7,0
 216:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 21a:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 21c:	5a800513          	li	a0,1448
 220:	883e                	mv	a6,a5
 222:	2785                	addw	a5,a5,1
 224:	02c5f733          	remu	a4,a1,a2
 228:	972a                	add	a4,a4,a0
 22a:	00074703          	lbu	a4,0(a4)
 22e:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 232:	872e                	mv	a4,a1
 234:	02c5d5b3          	divu	a1,a1,a2
 238:	0685                	add	a3,a3,1
 23a:	fec773e3          	bgeu	a4,a2,220 <printint+0x22>
  if(neg)
 23e:	00088b63          	beqz	a7,254 <printint+0x56>
    buf[i++] = '-';
 242:	fd078793          	add	a5,a5,-48
 246:	97a2                	add	a5,a5,s0
 248:	02d00713          	li	a4,45
 24c:	fee78423          	sb	a4,-24(a5)
 250:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 254:	02f05663          	blez	a5,280 <printint+0x82>
 258:	fb840713          	add	a4,s0,-72
 25c:	00f704b3          	add	s1,a4,a5
 260:	fff70993          	add	s3,a4,-1
 264:	99be                	add	s3,s3,a5
 266:	37fd                	addw	a5,a5,-1
 268:	1782                	sll	a5,a5,0x20
 26a:	9381                	srl	a5,a5,0x20
 26c:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 270:	fff4c583          	lbu	a1,-1(s1)
 274:	854a                	mv	a0,s2
 276:	f6bff0ef          	jal	1e0 <putc>
  while(--i >= 0)
 27a:	14fd                	add	s1,s1,-1
 27c:	ff349ae3          	bne	s1,s3,270 <printint+0x72>
}
 280:	60a6                	ld	ra,72(sp)
 282:	6406                	ld	s0,64(sp)
 284:	74e2                	ld	s1,56(sp)
 286:	7942                	ld	s2,48(sp)
 288:	79a2                	ld	s3,40(sp)
 28a:	6161                	add	sp,sp,80
 28c:	8082                	ret
    x = -xx;
 28e:	40b005b3          	neg	a1,a1
    neg = 1;
 292:	4885                	li	a7,1
    x = -xx;
 294:	b749                	j	216 <printint+0x18>

0000000000000296 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 296:	711d                	add	sp,sp,-96
 298:	ec86                	sd	ra,88(sp)
 29a:	e8a2                	sd	s0,80(sp)
 29c:	e4a6                	sd	s1,72(sp)
 29e:	e0ca                	sd	s2,64(sp)
 2a0:	fc4e                	sd	s3,56(sp)
 2a2:	f852                	sd	s4,48(sp)
 2a4:	f456                	sd	s5,40(sp)
 2a6:	f05a                	sd	s6,32(sp)
 2a8:	ec5e                	sd	s7,24(sp)
 2aa:	e862                	sd	s8,16(sp)
 2ac:	e466                	sd	s9,8(sp)
 2ae:	e06a                	sd	s10,0(sp)
 2b0:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 2b2:	0005c903          	lbu	s2,0(a1)
 2b6:	26090363          	beqz	s2,51c <vprintf+0x286>
 2ba:	8b2a                	mv	s6,a0
 2bc:	8a2e                	mv	s4,a1
 2be:	8bb2                	mv	s7,a2
  state = 0;
 2c0:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 2c2:	4481                	li	s1,0
 2c4:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 2c6:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 2ca:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 2ce:	06c00c93          	li	s9,108
 2d2:	a005                	j	2f2 <vprintf+0x5c>
        putc(fd, c0);
 2d4:	85ca                	mv	a1,s2
 2d6:	855a                	mv	a0,s6
 2d8:	f09ff0ef          	jal	1e0 <putc>
 2dc:	a019                	j	2e2 <vprintf+0x4c>
    } else if(state == '%'){
 2de:	03598263          	beq	s3,s5,302 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 2e2:	2485                	addw	s1,s1,1
 2e4:	8726                	mv	a4,s1
 2e6:	009a07b3          	add	a5,s4,s1
 2ea:	0007c903          	lbu	s2,0(a5)
 2ee:	22090763          	beqz	s2,51c <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 2f2:	0009079b          	sext.w	a5,s2
    if(state == 0){
 2f6:	fe0994e3          	bnez	s3,2de <vprintf+0x48>
      if(c0 == '%'){
 2fa:	fd579de3          	bne	a5,s5,2d4 <vprintf+0x3e>
        state = '%';
 2fe:	89be                	mv	s3,a5
 300:	b7cd                	j	2e2 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 302:	cbc9                	beqz	a5,394 <vprintf+0xfe>
 304:	00ea06b3          	add	a3,s4,a4
 308:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 30c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 30e:	c681                	beqz	a3,316 <vprintf+0x80>
 310:	9752                	add	a4,a4,s4
 312:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 316:	05878363          	beq	a5,s8,35c <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 31a:	05978d63          	beq	a5,s9,374 <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 31e:	07500713          	li	a4,117
 322:	0ee78763          	beq	a5,a4,410 <vprintf+0x17a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 326:	07800713          	li	a4,120
 32a:	12e78963          	beq	a5,a4,45c <vprintf+0x1c6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 32e:	07000713          	li	a4,112
 332:	14e78e63          	beq	a5,a4,48e <vprintf+0x1f8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 336:	06300713          	li	a4,99
 33a:	18e78a63          	beq	a5,a4,4ce <vprintf+0x238>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 33e:	07300713          	li	a4,115
 342:	1ae78063          	beq	a5,a4,4e2 <vprintf+0x24c>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 346:	02500713          	li	a4,37
 34a:	04e79563          	bne	a5,a4,394 <vprintf+0xfe>
        putc(fd, '%');
 34e:	02500593          	li	a1,37
 352:	855a                	mv	a0,s6
 354:	e8dff0ef          	jal	1e0 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 358:	4981                	li	s3,0
 35a:	b761                	j	2e2 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 35c:	008b8913          	add	s2,s7,8
 360:	4685                	li	a3,1
 362:	4629                	li	a2,10
 364:	000ba583          	lw	a1,0(s7)
 368:	855a                	mv	a0,s6
 36a:	e95ff0ef          	jal	1fe <printint>
 36e:	8bca                	mv	s7,s2
      state = 0;
 370:	4981                	li	s3,0
 372:	bf85                	j	2e2 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 374:	06400793          	li	a5,100
 378:	02f68963          	beq	a3,a5,3aa <vprintf+0x114>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 37c:	06c00793          	li	a5,108
 380:	04f68263          	beq	a3,a5,3c4 <vprintf+0x12e>
      } else if(c0 == 'l' && c1 == 'u'){
 384:	07500793          	li	a5,117
 388:	0af68063          	beq	a3,a5,428 <vprintf+0x192>
      } else if(c0 == 'l' && c1 == 'x'){
 38c:	07800793          	li	a5,120
 390:	0ef68263          	beq	a3,a5,474 <vprintf+0x1de>
        putc(fd, '%');
 394:	02500593          	li	a1,37
 398:	855a                	mv	a0,s6
 39a:	e47ff0ef          	jal	1e0 <putc>
        putc(fd, c0);
 39e:	85ca                	mv	a1,s2
 3a0:	855a                	mv	a0,s6
 3a2:	e3fff0ef          	jal	1e0 <putc>
      state = 0;
 3a6:	4981                	li	s3,0
 3a8:	bf2d                	j	2e2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 3aa:	008b8913          	add	s2,s7,8
 3ae:	4685                	li	a3,1
 3b0:	4629                	li	a2,10
 3b2:	000bb583          	ld	a1,0(s7)
 3b6:	855a                	mv	a0,s6
 3b8:	e47ff0ef          	jal	1fe <printint>
        i += 1;
 3bc:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 3be:	8bca                	mv	s7,s2
      state = 0;
 3c0:	4981                	li	s3,0
        i += 1;
 3c2:	b705                	j	2e2 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 3c4:	06400793          	li	a5,100
 3c8:	02f60763          	beq	a2,a5,3f6 <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 3cc:	07500793          	li	a5,117
 3d0:	06f60963          	beq	a2,a5,442 <vprintf+0x1ac>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 3d4:	07800793          	li	a5,120
 3d8:	faf61ee3          	bne	a2,a5,394 <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 3dc:	008b8913          	add	s2,s7,8
 3e0:	4681                	li	a3,0
 3e2:	4641                	li	a2,16
 3e4:	000bb583          	ld	a1,0(s7)
 3e8:	855a                	mv	a0,s6
 3ea:	e15ff0ef          	jal	1fe <printint>
        i += 2;
 3ee:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 3f0:	8bca                	mv	s7,s2
      state = 0;
 3f2:	4981                	li	s3,0
        i += 2;
 3f4:	b5fd                	j	2e2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 3f6:	008b8913          	add	s2,s7,8
 3fa:	4685                	li	a3,1
 3fc:	4629                	li	a2,10
 3fe:	000bb583          	ld	a1,0(s7)
 402:	855a                	mv	a0,s6
 404:	dfbff0ef          	jal	1fe <printint>
        i += 2;
 408:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 40a:	8bca                	mv	s7,s2
      state = 0;
 40c:	4981                	li	s3,0
        i += 2;
 40e:	bdd1                	j	2e2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 10, 0);
 410:	008b8913          	add	s2,s7,8
 414:	4681                	li	a3,0
 416:	4629                	li	a2,10
 418:	000be583          	lwu	a1,0(s7)
 41c:	855a                	mv	a0,s6
 41e:	de1ff0ef          	jal	1fe <printint>
 422:	8bca                	mv	s7,s2
      state = 0;
 424:	4981                	li	s3,0
 426:	bd75                	j	2e2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 428:	008b8913          	add	s2,s7,8
 42c:	4681                	li	a3,0
 42e:	4629                	li	a2,10
 430:	000bb583          	ld	a1,0(s7)
 434:	855a                	mv	a0,s6
 436:	dc9ff0ef          	jal	1fe <printint>
        i += 1;
 43a:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 43c:	8bca                	mv	s7,s2
      state = 0;
 43e:	4981                	li	s3,0
        i += 1;
 440:	b54d                	j	2e2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 442:	008b8913          	add	s2,s7,8
 446:	4681                	li	a3,0
 448:	4629                	li	a2,10
 44a:	000bb583          	ld	a1,0(s7)
 44e:	855a                	mv	a0,s6
 450:	dafff0ef          	jal	1fe <printint>
        i += 2;
 454:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 456:	8bca                	mv	s7,s2
      state = 0;
 458:	4981                	li	s3,0
        i += 2;
 45a:	b561                	j	2e2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 16, 0);
 45c:	008b8913          	add	s2,s7,8
 460:	4681                	li	a3,0
 462:	4641                	li	a2,16
 464:	000be583          	lwu	a1,0(s7)
 468:	855a                	mv	a0,s6
 46a:	d95ff0ef          	jal	1fe <printint>
 46e:	8bca                	mv	s7,s2
      state = 0;
 470:	4981                	li	s3,0
 472:	bd85                	j	2e2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 474:	008b8913          	add	s2,s7,8
 478:	4681                	li	a3,0
 47a:	4641                	li	a2,16
 47c:	000bb583          	ld	a1,0(s7)
 480:	855a                	mv	a0,s6
 482:	d7dff0ef          	jal	1fe <printint>
        i += 1;
 486:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 488:	8bca                	mv	s7,s2
      state = 0;
 48a:	4981                	li	s3,0
        i += 1;
 48c:	bd99                	j	2e2 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 48e:	008b8d13          	add	s10,s7,8
 492:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 496:	03000593          	li	a1,48
 49a:	855a                	mv	a0,s6
 49c:	d45ff0ef          	jal	1e0 <putc>
  putc(fd, 'x');
 4a0:	07800593          	li	a1,120
 4a4:	855a                	mv	a0,s6
 4a6:	d3bff0ef          	jal	1e0 <putc>
 4aa:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4ac:	5a800b93          	li	s7,1448
 4b0:	03c9d793          	srl	a5,s3,0x3c
 4b4:	97de                	add	a5,a5,s7
 4b6:	0007c583          	lbu	a1,0(a5)
 4ba:	855a                	mv	a0,s6
 4bc:	d25ff0ef          	jal	1e0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 4c0:	0992                	sll	s3,s3,0x4
 4c2:	397d                	addw	s2,s2,-1
 4c4:	fe0916e3          	bnez	s2,4b0 <vprintf+0x21a>
        printptr(fd, va_arg(ap, uint64));
 4c8:	8bea                	mv	s7,s10
      state = 0;
 4ca:	4981                	li	s3,0
 4cc:	bd19                	j	2e2 <vprintf+0x4c>
        putc(fd, va_arg(ap, uint32));
 4ce:	008b8913          	add	s2,s7,8
 4d2:	000bc583          	lbu	a1,0(s7)
 4d6:	855a                	mv	a0,s6
 4d8:	d09ff0ef          	jal	1e0 <putc>
 4dc:	8bca                	mv	s7,s2
      state = 0;
 4de:	4981                	li	s3,0
 4e0:	b509                	j	2e2 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 4e2:	008b8993          	add	s3,s7,8
 4e6:	000bb903          	ld	s2,0(s7)
 4ea:	00090f63          	beqz	s2,508 <vprintf+0x272>
        for(; *s; s++)
 4ee:	00094583          	lbu	a1,0(s2)
 4f2:	c195                	beqz	a1,516 <vprintf+0x280>
          putc(fd, *s);
 4f4:	855a                	mv	a0,s6
 4f6:	cebff0ef          	jal	1e0 <putc>
        for(; *s; s++)
 4fa:	0905                	add	s2,s2,1
 4fc:	00094583          	lbu	a1,0(s2)
 500:	f9f5                	bnez	a1,4f4 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 502:	8bce                	mv	s7,s3
      state = 0;
 504:	4981                	li	s3,0
 506:	bbf1                	j	2e2 <vprintf+0x4c>
          s = "(null)";
 508:	00000917          	auipc	s2,0x0
 50c:	09890913          	add	s2,s2,152 # 5a0 <printf+0x3e>
        for(; *s; s++)
 510:	02800593          	li	a1,40
 514:	b7c5                	j	4f4 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 516:	8bce                	mv	s7,s3
      state = 0;
 518:	4981                	li	s3,0
 51a:	b3e1                	j	2e2 <vprintf+0x4c>
    }
  }
}
 51c:	60e6                	ld	ra,88(sp)
 51e:	6446                	ld	s0,80(sp)
 520:	64a6                	ld	s1,72(sp)
 522:	6906                	ld	s2,64(sp)
 524:	79e2                	ld	s3,56(sp)
 526:	7a42                	ld	s4,48(sp)
 528:	7aa2                	ld	s5,40(sp)
 52a:	7b02                	ld	s6,32(sp)
 52c:	6be2                	ld	s7,24(sp)
 52e:	6c42                	ld	s8,16(sp)
 530:	6ca2                	ld	s9,8(sp)
 532:	6d02                	ld	s10,0(sp)
 534:	6125                	add	sp,sp,96
 536:	8082                	ret

0000000000000538 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 538:	715d                	add	sp,sp,-80
 53a:	ec06                	sd	ra,24(sp)
 53c:	e822                	sd	s0,16(sp)
 53e:	1000                	add	s0,sp,32
 540:	e010                	sd	a2,0(s0)
 542:	e414                	sd	a3,8(s0)
 544:	e818                	sd	a4,16(s0)
 546:	ec1c                	sd	a5,24(s0)
 548:	03043023          	sd	a6,32(s0)
 54c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 550:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 554:	8622                	mv	a2,s0
 556:	d41ff0ef          	jal	296 <vprintf>
}
 55a:	60e2                	ld	ra,24(sp)
 55c:	6442                	ld	s0,16(sp)
 55e:	6161                	add	sp,sp,80
 560:	8082                	ret

0000000000000562 <printf>:

void
printf(const char *fmt, ...)
{
 562:	711d                	add	sp,sp,-96
 564:	ec06                	sd	ra,24(sp)
 566:	e822                	sd	s0,16(sp)
 568:	1000                	add	s0,sp,32
 56a:	e40c                	sd	a1,8(s0)
 56c:	e810                	sd	a2,16(s0)
 56e:	ec14                	sd	a3,24(s0)
 570:	f018                	sd	a4,32(s0)
 572:	f41c                	sd	a5,40(s0)
 574:	03043823          	sd	a6,48(s0)
 578:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 57c:	00840613          	add	a2,s0,8
 580:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 584:	85aa                	mv	a1,a0
 586:	4505                	li	a0,1
 588:	d0fff0ef          	jal	296 <vprintf>
 58c:	60e2                	ld	ra,24(sp)
 58e:	6442                	ld	s0,16(sp)
 590:	6125                	add	sp,sp,96
 592:	8082                	ret
