
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
   8:	118000ef          	jal	120 <hello>
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
  22:	106000ef          	jal	128 <exit>

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

0000000000000120 <hello>:
# generated by usys.pl - do not edit
#include "include/syscall.h"
.global hello
hello:
 li a7, SYS_hello
 120:	4885                	li	a7,1
 ecall
 122:	00000073          	ecall
 ret
 126:	8082                	ret

0000000000000128 <exit>:
.global exit
exit:
 li a7, SYS_exit
 128:	4889                	li	a7,2
 ecall
 12a:	00000073          	ecall
 ret
 12e:	8082                	ret

0000000000000130 <fork>:
.global fork
fork:
 li a7, SYS_fork
 130:	4891                	li	a7,4
 ecall
 132:	00000073          	ecall
 ret
 136:	8082                	ret

0000000000000138 <wait>:
.global wait
wait:
 li a7, SYS_wait
 138:	488d                	li	a7,3
 ecall
 13a:	00000073          	ecall
 ret
 13e:	8082                	ret

0000000000000140 <exec>:
.global exec
exec:
 li a7, SYS_exec
 140:	4895                	li	a7,5
 ecall
 142:	00000073          	ecall
 ret
 146:	8082                	ret

0000000000000148 <dup>:
.global dup
dup:
 li a7, SYS_dup
 148:	489d                	li	a7,7
 ecall
 14a:	00000073          	ecall
 ret
 14e:	8082                	ret

0000000000000150 <open>:
.global open
open:
 li a7, SYS_open
 150:	4899                	li	a7,6
 ecall
 152:	00000073          	ecall
 ret
 156:	8082                	ret

0000000000000158 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 158:	48a1                	li	a7,8
 ecall
 15a:	00000073          	ecall
 ret
 15e:	8082                	ret

0000000000000160 <write>:
.global write
write:
 li a7, SYS_write
 160:	48a5                	li	a7,9
 ecall
 162:	00000073          	ecall
 ret
 166:	8082                	ret

0000000000000168 <read>:
.global read
read:
 li a7, SYS_read
 168:	48a9                	li	a7,10
 ecall
 16a:	00000073          	ecall
 ret
 16e:	8082                	ret

0000000000000170 <close>:
.global close
close:
 li a7, SYS_close
 170:	48ad                	li	a7,11
 ecall
 172:	00000073          	ecall
 ret
 176:	8082                	ret

0000000000000178 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 178:	48b1                	li	a7,12
 ecall
 17a:	00000073          	ecall
 ret
 17e:	8082                	ret

0000000000000180 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 180:	48b5                	li	a7,13
 ecall
 182:	00000073          	ecall
 ret
 186:	8082                	ret

0000000000000188 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 188:	48b9                	li	a7,14
 ecall
 18a:	00000073          	ecall
 ret
 18e:	8082                	ret

0000000000000190 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 190:	1101                	add	sp,sp,-32
 192:	ec06                	sd	ra,24(sp)
 194:	e822                	sd	s0,16(sp)
 196:	1000                	add	s0,sp,32
 198:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 19c:	4605                	li	a2,1
 19e:	fef40593          	add	a1,s0,-17
 1a2:	fbfff0ef          	jal	160 <write>
}
 1a6:	60e2                	ld	ra,24(sp)
 1a8:	6442                	ld	s0,16(sp)
 1aa:	6105                	add	sp,sp,32
 1ac:	8082                	ret

00000000000001ae <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 1ae:	715d                	add	sp,sp,-80
 1b0:	e486                	sd	ra,72(sp)
 1b2:	e0a2                	sd	s0,64(sp)
 1b4:	fc26                	sd	s1,56(sp)
 1b6:	f84a                	sd	s2,48(sp)
 1b8:	f44e                	sd	s3,40(sp)
 1ba:	0880                	add	s0,sp,80
 1bc:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 1be:	c299                	beqz	a3,1c4 <printint+0x16>
 1c0:	0605cf63          	bltz	a1,23e <printint+0x90>
  neg = 0;
 1c4:	4881                	li	a7,0
 1c6:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 1ca:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 1cc:	55800513          	li	a0,1368
 1d0:	883e                	mv	a6,a5
 1d2:	2785                	addw	a5,a5,1
 1d4:	02c5f733          	remu	a4,a1,a2
 1d8:	972a                	add	a4,a4,a0
 1da:	00074703          	lbu	a4,0(a4)
 1de:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 1e2:	872e                	mv	a4,a1
 1e4:	02c5d5b3          	divu	a1,a1,a2
 1e8:	0685                	add	a3,a3,1
 1ea:	fec773e3          	bgeu	a4,a2,1d0 <printint+0x22>
  if(neg)
 1ee:	00088b63          	beqz	a7,204 <printint+0x56>
    buf[i++] = '-';
 1f2:	fd078793          	add	a5,a5,-48
 1f6:	97a2                	add	a5,a5,s0
 1f8:	02d00713          	li	a4,45
 1fc:	fee78423          	sb	a4,-24(a5)
 200:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 204:	02f05663          	blez	a5,230 <printint+0x82>
 208:	fb840713          	add	a4,s0,-72
 20c:	00f704b3          	add	s1,a4,a5
 210:	fff70993          	add	s3,a4,-1
 214:	99be                	add	s3,s3,a5
 216:	37fd                	addw	a5,a5,-1
 218:	1782                	sll	a5,a5,0x20
 21a:	9381                	srl	a5,a5,0x20
 21c:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 220:	fff4c583          	lbu	a1,-1(s1)
 224:	854a                	mv	a0,s2
 226:	f6bff0ef          	jal	190 <putc>
  while(--i >= 0)
 22a:	14fd                	add	s1,s1,-1
 22c:	ff349ae3          	bne	s1,s3,220 <printint+0x72>
}
 230:	60a6                	ld	ra,72(sp)
 232:	6406                	ld	s0,64(sp)
 234:	74e2                	ld	s1,56(sp)
 236:	7942                	ld	s2,48(sp)
 238:	79a2                	ld	s3,40(sp)
 23a:	6161                	add	sp,sp,80
 23c:	8082                	ret
    x = -xx;
 23e:	40b005b3          	neg	a1,a1
    neg = 1;
 242:	4885                	li	a7,1
    x = -xx;
 244:	b749                	j	1c6 <printint+0x18>

0000000000000246 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 246:	711d                	add	sp,sp,-96
 248:	ec86                	sd	ra,88(sp)
 24a:	e8a2                	sd	s0,80(sp)
 24c:	e4a6                	sd	s1,72(sp)
 24e:	e0ca                	sd	s2,64(sp)
 250:	fc4e                	sd	s3,56(sp)
 252:	f852                	sd	s4,48(sp)
 254:	f456                	sd	s5,40(sp)
 256:	f05a                	sd	s6,32(sp)
 258:	ec5e                	sd	s7,24(sp)
 25a:	e862                	sd	s8,16(sp)
 25c:	e466                	sd	s9,8(sp)
 25e:	e06a                	sd	s10,0(sp)
 260:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 262:	0005c903          	lbu	s2,0(a1)
 266:	26090363          	beqz	s2,4cc <vprintf+0x286>
 26a:	8b2a                	mv	s6,a0
 26c:	8a2e                	mv	s4,a1
 26e:	8bb2                	mv	s7,a2
  state = 0;
 270:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 272:	4481                	li	s1,0
 274:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 276:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 27a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 27e:	06c00c93          	li	s9,108
 282:	a005                	j	2a2 <vprintf+0x5c>
        putc(fd, c0);
 284:	85ca                	mv	a1,s2
 286:	855a                	mv	a0,s6
 288:	f09ff0ef          	jal	190 <putc>
 28c:	a019                	j	292 <vprintf+0x4c>
    } else if(state == '%'){
 28e:	03598263          	beq	s3,s5,2b2 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 292:	2485                	addw	s1,s1,1
 294:	8726                	mv	a4,s1
 296:	009a07b3          	add	a5,s4,s1
 29a:	0007c903          	lbu	s2,0(a5)
 29e:	22090763          	beqz	s2,4cc <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 2a2:	0009079b          	sext.w	a5,s2
    if(state == 0){
 2a6:	fe0994e3          	bnez	s3,28e <vprintf+0x48>
      if(c0 == '%'){
 2aa:	fd579de3          	bne	a5,s5,284 <vprintf+0x3e>
        state = '%';
 2ae:	89be                	mv	s3,a5
 2b0:	b7cd                	j	292 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 2b2:	cbc9                	beqz	a5,344 <vprintf+0xfe>
 2b4:	00ea06b3          	add	a3,s4,a4
 2b8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 2bc:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 2be:	c681                	beqz	a3,2c6 <vprintf+0x80>
 2c0:	9752                	add	a4,a4,s4
 2c2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 2c6:	05878363          	beq	a5,s8,30c <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 2ca:	05978d63          	beq	a5,s9,324 <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 2ce:	07500713          	li	a4,117
 2d2:	0ee78763          	beq	a5,a4,3c0 <vprintf+0x17a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 2d6:	07800713          	li	a4,120
 2da:	12e78963          	beq	a5,a4,40c <vprintf+0x1c6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 2de:	07000713          	li	a4,112
 2e2:	14e78e63          	beq	a5,a4,43e <vprintf+0x1f8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 2e6:	06300713          	li	a4,99
 2ea:	18e78a63          	beq	a5,a4,47e <vprintf+0x238>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 2ee:	07300713          	li	a4,115
 2f2:	1ae78063          	beq	a5,a4,492 <vprintf+0x24c>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 2f6:	02500713          	li	a4,37
 2fa:	04e79563          	bne	a5,a4,344 <vprintf+0xfe>
        putc(fd, '%');
 2fe:	02500593          	li	a1,37
 302:	855a                	mv	a0,s6
 304:	e8dff0ef          	jal	190 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 308:	4981                	li	s3,0
 30a:	b761                	j	292 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 30c:	008b8913          	add	s2,s7,8
 310:	4685                	li	a3,1
 312:	4629                	li	a2,10
 314:	000ba583          	lw	a1,0(s7)
 318:	855a                	mv	a0,s6
 31a:	e95ff0ef          	jal	1ae <printint>
 31e:	8bca                	mv	s7,s2
      state = 0;
 320:	4981                	li	s3,0
 322:	bf85                	j	292 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 324:	06400793          	li	a5,100
 328:	02f68963          	beq	a3,a5,35a <vprintf+0x114>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 32c:	06c00793          	li	a5,108
 330:	04f68263          	beq	a3,a5,374 <vprintf+0x12e>
      } else if(c0 == 'l' && c1 == 'u'){
 334:	07500793          	li	a5,117
 338:	0af68063          	beq	a3,a5,3d8 <vprintf+0x192>
      } else if(c0 == 'l' && c1 == 'x'){
 33c:	07800793          	li	a5,120
 340:	0ef68263          	beq	a3,a5,424 <vprintf+0x1de>
        putc(fd, '%');
 344:	02500593          	li	a1,37
 348:	855a                	mv	a0,s6
 34a:	e47ff0ef          	jal	190 <putc>
        putc(fd, c0);
 34e:	85ca                	mv	a1,s2
 350:	855a                	mv	a0,s6
 352:	e3fff0ef          	jal	190 <putc>
      state = 0;
 356:	4981                	li	s3,0
 358:	bf2d                	j	292 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 35a:	008b8913          	add	s2,s7,8
 35e:	4685                	li	a3,1
 360:	4629                	li	a2,10
 362:	000bb583          	ld	a1,0(s7)
 366:	855a                	mv	a0,s6
 368:	e47ff0ef          	jal	1ae <printint>
        i += 1;
 36c:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 36e:	8bca                	mv	s7,s2
      state = 0;
 370:	4981                	li	s3,0
        i += 1;
 372:	b705                	j	292 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 374:	06400793          	li	a5,100
 378:	02f60763          	beq	a2,a5,3a6 <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 37c:	07500793          	li	a5,117
 380:	06f60963          	beq	a2,a5,3f2 <vprintf+0x1ac>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 384:	07800793          	li	a5,120
 388:	faf61ee3          	bne	a2,a5,344 <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 38c:	008b8913          	add	s2,s7,8
 390:	4681                	li	a3,0
 392:	4641                	li	a2,16
 394:	000bb583          	ld	a1,0(s7)
 398:	855a                	mv	a0,s6
 39a:	e15ff0ef          	jal	1ae <printint>
        i += 2;
 39e:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 3a0:	8bca                	mv	s7,s2
      state = 0;
 3a2:	4981                	li	s3,0
        i += 2;
 3a4:	b5fd                	j	292 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 3a6:	008b8913          	add	s2,s7,8
 3aa:	4685                	li	a3,1
 3ac:	4629                	li	a2,10
 3ae:	000bb583          	ld	a1,0(s7)
 3b2:	855a                	mv	a0,s6
 3b4:	dfbff0ef          	jal	1ae <printint>
        i += 2;
 3b8:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 3ba:	8bca                	mv	s7,s2
      state = 0;
 3bc:	4981                	li	s3,0
        i += 2;
 3be:	bdd1                	j	292 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 10, 0);
 3c0:	008b8913          	add	s2,s7,8
 3c4:	4681                	li	a3,0
 3c6:	4629                	li	a2,10
 3c8:	000be583          	lwu	a1,0(s7)
 3cc:	855a                	mv	a0,s6
 3ce:	de1ff0ef          	jal	1ae <printint>
 3d2:	8bca                	mv	s7,s2
      state = 0;
 3d4:	4981                	li	s3,0
 3d6:	bd75                	j	292 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 3d8:	008b8913          	add	s2,s7,8
 3dc:	4681                	li	a3,0
 3de:	4629                	li	a2,10
 3e0:	000bb583          	ld	a1,0(s7)
 3e4:	855a                	mv	a0,s6
 3e6:	dc9ff0ef          	jal	1ae <printint>
        i += 1;
 3ea:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 3ec:	8bca                	mv	s7,s2
      state = 0;
 3ee:	4981                	li	s3,0
        i += 1;
 3f0:	b54d                	j	292 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 3f2:	008b8913          	add	s2,s7,8
 3f6:	4681                	li	a3,0
 3f8:	4629                	li	a2,10
 3fa:	000bb583          	ld	a1,0(s7)
 3fe:	855a                	mv	a0,s6
 400:	dafff0ef          	jal	1ae <printint>
        i += 2;
 404:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 406:	8bca                	mv	s7,s2
      state = 0;
 408:	4981                	li	s3,0
        i += 2;
 40a:	b561                	j	292 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 16, 0);
 40c:	008b8913          	add	s2,s7,8
 410:	4681                	li	a3,0
 412:	4641                	li	a2,16
 414:	000be583          	lwu	a1,0(s7)
 418:	855a                	mv	a0,s6
 41a:	d95ff0ef          	jal	1ae <printint>
 41e:	8bca                	mv	s7,s2
      state = 0;
 420:	4981                	li	s3,0
 422:	bd85                	j	292 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 424:	008b8913          	add	s2,s7,8
 428:	4681                	li	a3,0
 42a:	4641                	li	a2,16
 42c:	000bb583          	ld	a1,0(s7)
 430:	855a                	mv	a0,s6
 432:	d7dff0ef          	jal	1ae <printint>
        i += 1;
 436:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 438:	8bca                	mv	s7,s2
      state = 0;
 43a:	4981                	li	s3,0
        i += 1;
 43c:	bd99                	j	292 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 43e:	008b8d13          	add	s10,s7,8
 442:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 446:	03000593          	li	a1,48
 44a:	855a                	mv	a0,s6
 44c:	d45ff0ef          	jal	190 <putc>
  putc(fd, 'x');
 450:	07800593          	li	a1,120
 454:	855a                	mv	a0,s6
 456:	d3bff0ef          	jal	190 <putc>
 45a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 45c:	55800b93          	li	s7,1368
 460:	03c9d793          	srl	a5,s3,0x3c
 464:	97de                	add	a5,a5,s7
 466:	0007c583          	lbu	a1,0(a5)
 46a:	855a                	mv	a0,s6
 46c:	d25ff0ef          	jal	190 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 470:	0992                	sll	s3,s3,0x4
 472:	397d                	addw	s2,s2,-1
 474:	fe0916e3          	bnez	s2,460 <vprintf+0x21a>
        printptr(fd, va_arg(ap, uint64));
 478:	8bea                	mv	s7,s10
      state = 0;
 47a:	4981                	li	s3,0
 47c:	bd19                	j	292 <vprintf+0x4c>
        putc(fd, va_arg(ap, uint32));
 47e:	008b8913          	add	s2,s7,8
 482:	000bc583          	lbu	a1,0(s7)
 486:	855a                	mv	a0,s6
 488:	d09ff0ef          	jal	190 <putc>
 48c:	8bca                	mv	s7,s2
      state = 0;
 48e:	4981                	li	s3,0
 490:	b509                	j	292 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 492:	008b8993          	add	s3,s7,8
 496:	000bb903          	ld	s2,0(s7)
 49a:	00090f63          	beqz	s2,4b8 <vprintf+0x272>
        for(; *s; s++)
 49e:	00094583          	lbu	a1,0(s2)
 4a2:	c195                	beqz	a1,4c6 <vprintf+0x280>
          putc(fd, *s);
 4a4:	855a                	mv	a0,s6
 4a6:	cebff0ef          	jal	190 <putc>
        for(; *s; s++)
 4aa:	0905                	add	s2,s2,1
 4ac:	00094583          	lbu	a1,0(s2)
 4b0:	f9f5                	bnez	a1,4a4 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 4b2:	8bce                	mv	s7,s3
      state = 0;
 4b4:	4981                	li	s3,0
 4b6:	bbf1                	j	292 <vprintf+0x4c>
          s = "(null)";
 4b8:	00000917          	auipc	s2,0x0
 4bc:	09890913          	add	s2,s2,152 # 550 <printf+0x3e>
        for(; *s; s++)
 4c0:	02800593          	li	a1,40
 4c4:	b7c5                	j	4a4 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 4c6:	8bce                	mv	s7,s3
      state = 0;
 4c8:	4981                	li	s3,0
 4ca:	b3e1                	j	292 <vprintf+0x4c>
    }
  }
}
 4cc:	60e6                	ld	ra,88(sp)
 4ce:	6446                	ld	s0,80(sp)
 4d0:	64a6                	ld	s1,72(sp)
 4d2:	6906                	ld	s2,64(sp)
 4d4:	79e2                	ld	s3,56(sp)
 4d6:	7a42                	ld	s4,48(sp)
 4d8:	7aa2                	ld	s5,40(sp)
 4da:	7b02                	ld	s6,32(sp)
 4dc:	6be2                	ld	s7,24(sp)
 4de:	6c42                	ld	s8,16(sp)
 4e0:	6ca2                	ld	s9,8(sp)
 4e2:	6d02                	ld	s10,0(sp)
 4e4:	6125                	add	sp,sp,96
 4e6:	8082                	ret

00000000000004e8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 4e8:	715d                	add	sp,sp,-80
 4ea:	ec06                	sd	ra,24(sp)
 4ec:	e822                	sd	s0,16(sp)
 4ee:	1000                	add	s0,sp,32
 4f0:	e010                	sd	a2,0(s0)
 4f2:	e414                	sd	a3,8(s0)
 4f4:	e818                	sd	a4,16(s0)
 4f6:	ec1c                	sd	a5,24(s0)
 4f8:	03043023          	sd	a6,32(s0)
 4fc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 500:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 504:	8622                	mv	a2,s0
 506:	d41ff0ef          	jal	246 <vprintf>
}
 50a:	60e2                	ld	ra,24(sp)
 50c:	6442                	ld	s0,16(sp)
 50e:	6161                	add	sp,sp,80
 510:	8082                	ret

0000000000000512 <printf>:

void
printf(const char *fmt, ...)
{
 512:	711d                	add	sp,sp,-96
 514:	ec06                	sd	ra,24(sp)
 516:	e822                	sd	s0,16(sp)
 518:	1000                	add	s0,sp,32
 51a:	e40c                	sd	a1,8(s0)
 51c:	e810                	sd	a2,16(s0)
 51e:	ec14                	sd	a3,24(s0)
 520:	f018                	sd	a4,32(s0)
 522:	f41c                	sd	a5,40(s0)
 524:	03043823          	sd	a6,48(s0)
 528:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 52c:	00840613          	add	a2,s0,8
 530:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 534:	85aa                	mv	a1,a0
 536:	4505                	li	a0,1
 538:	d0fff0ef          	jal	246 <vprintf>
 53c:	60e2                	ld	ra,24(sp)
 53e:	6442                	ld	s0,16(sp)
 540:	6125                	add	sp,sp,96
 542:	8082                	ret
