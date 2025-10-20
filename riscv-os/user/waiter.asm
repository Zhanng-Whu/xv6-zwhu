
user/_waiter:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <foreverwait>:
#include "include/file.h"
#include "include/fcntl.h"


// 用于处理孤儿进程
void foreverwait(){
   0:	1141                	add	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	add	s0,sp,16
    for(;;){
        int wpid = wait((int *)0);
   8:	4501                	li	a0,0
   a:	1b2000ef          	jal	1bc <wait>
        if(wpid < 0){
   e:	fe055de3          	bgez	a0,8 <foreverwait+0x8>
            exit(1);
  12:	4505                	li	a0,1
  14:	198000ef          	jal	1ac <exit>

0000000000000018 <fdinit>:
        }
    }
}

void fdinit(){
  18:	1141                	add	sp,sp,-16
  1a:	e406                	sd	ra,8(sp)
  1c:	e022                	sd	s0,0(sp)
  1e:	0800                	add	s0,sp,16
    
    if(open("console", O_RDWR) < 0){
  20:	4589                	li	a1,2
  22:	00000517          	auipc	a0,0x0
  26:	5ae50513          	add	a0,a0,1454 # 5d0 <printf+0x3a>
  2a:	1aa000ef          	jal	1d4 <open>
  2e:	00054c63          	bltz	a0,46 <fdinit+0x2e>
        // 如果没有console设备 那么创建一个
        mknod("console", CONSOLE, 0);
        open("console", O_RDWR);
    }
    dup(0); // stdout
  32:	4501                	li	a0,0
  34:	198000ef          	jal	1cc <dup>
    dup(0); // stderr
  38:	4501                	li	a0,0
  3a:	192000ef          	jal	1cc <dup>
}
  3e:	60a2                	ld	ra,8(sp)
  40:	6402                	ld	s0,0(sp)
  42:	0141                	add	sp,sp,16
  44:	8082                	ret
        mknod("console", CONSOLE, 0);
  46:	4601                	li	a2,0
  48:	4585                	li	a1,1
  4a:	00000517          	auipc	a0,0x0
  4e:	58650513          	add	a0,a0,1414 # 5d0 <printf+0x3a>
  52:	18a000ef          	jal	1dc <mknod>
        open("console", O_RDWR);
  56:	4589                	li	a1,2
  58:	00000517          	auipc	a0,0x0
  5c:	57850513          	add	a0,a0,1400 # 5d0 <printf+0x3a>
  60:	174000ef          	jal	1d4 <open>
  64:	b7f9                	j	32 <fdinit+0x1a>

0000000000000066 <main>:



int main(){
  66:	1101                	add	sp,sp,-32
  68:	ec06                	sd	ra,24(sp)
  6a:	e822                	sd	s0,16(sp)
  6c:	1000                	add	s0,sp,32

    fdinit();
  6e:	fabff0ef          	jal	18 <fdinit>


    int pid = fork();
  72:	142000ef          	jal	1b4 <fork>
    if(pid == 0){
  76:	e105                	bnez	a0,96 <main+0x30>
        exec("filetest", (char *[]){"filetest", 0});
  78:	00000517          	auipc	a0,0x0
  7c:	56050513          	add	a0,a0,1376 # 5d8 <printf+0x42>
  80:	fea43023          	sd	a0,-32(s0)
  84:	fe043423          	sd	zero,-24(s0)
  88:	fe040593          	add	a1,s0,-32
  8c:	138000ef          	jal	1c4 <exec>
        exit(1);
  90:	4505                	li	a0,1
  92:	11a000ef          	jal	1ac <exit>
    }

    foreverwait();
  96:	f6bff0ef          	jal	0 <foreverwait>

000000000000009a <start>:
#include "include/user.h"


void
start(int argc, char **argv)
{
  9a:	1141                	add	sp,sp,-16
  9c:	e406                	sd	ra,8(sp)
  9e:	e022                	sd	s0,0(sp)
  a0:	0800                	add	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  a2:	fc5ff0ef          	jal	66 <main>


  exit(r);
  a6:	106000ef          	jal	1ac <exit>

00000000000000aa <itoa>:
{
  char temp[16];
  int i = 0;
  int j = 0;

  if (n == 0) {
  aa:	cd25                	beqz	a0,122 <itoa+0x78>
{
  ac:	1101                	add	sp,sp,-32
  ae:	ec22                	sd	s0,24(sp)
  b0:	1000                	add	s0,sp,32
    buf[1] = '\0';
    return;
  }
  
  // Generate digits in reverse order
  while (n > 0) {
  b2:	fe040693          	add	a3,s0,-32
  int i = 0;
  b6:	4701                	li	a4,0
    temp[i++] = (n % 10) + '0';
  b8:	4829                	li	a6,10
  while (n > 0) {
  ba:	48a5                	li	a7,9
    n /= 10;
  }
  temp[i] = '\0';

  // Reverse the string to get the correct order
  for (j = 0; j < i; j++) {
  bc:	4601                	li	a2,0
  while (n > 0) {
  be:	04a05c63          	blez	a0,116 <itoa+0x6c>
    temp[i++] = (n % 10) + '0';
  c2:	863a                	mv	a2,a4
  c4:	2705                	addw	a4,a4,1
  c6:	030567bb          	remw	a5,a0,a6
  ca:	0307879b          	addw	a5,a5,48
  ce:	00f68023          	sb	a5,0(a3)
    n /= 10;
  d2:	87aa                	mv	a5,a0
  d4:	0305453b          	divw	a0,a0,a6
  while (n > 0) {
  d8:	0685                	add	a3,a3,1
  da:	fef8c4e3          	blt	a7,a5,c2 <itoa+0x18>
  temp[i] = '\0';
  de:	ff070793          	add	a5,a4,-16
  e2:	97a2                	add	a5,a5,s0
  e4:	fe078823          	sb	zero,-16(a5)
  for (j = 0; j < i; j++) {
  e8:	04e05463          	blez	a4,130 <itoa+0x86>
  ec:	fe040793          	add	a5,s0,-32
  f0:	00c786b3          	add	a3,a5,a2
  f4:	87ae                	mv	a5,a1
    buf[j] = temp[i - 1 - j];
  f6:	0006c703          	lbu	a4,0(a3)
  fa:	00e78023          	sb	a4,0(a5)
  for (j = 0; j < i; j++) {
  fe:	16fd                	add	a3,a3,-1
 100:	0785                	add	a5,a5,1
 102:	40b7873b          	subw	a4,a5,a1
 106:	377d                	addw	a4,a4,-1
 108:	fec747e3          	blt	a4,a2,f6 <itoa+0x4c>
 10c:	fff64793          	not	a5,a2
 110:	97fd                	sra	a5,a5,0x3f
 112:	8e7d                	and	a2,a2,a5
 114:	2605                	addw	a2,a2,1
  }
  buf[j] = '\0';
 116:	95b2                	add	a1,a1,a2
 118:	00058023          	sb	zero,0(a1)
}
 11c:	6462                	ld	s0,24(sp)
 11e:	6105                	add	sp,sp,32
 120:	8082                	ret
    buf[0] = '0';
 122:	03000793          	li	a5,48
 126:	00f58023          	sb	a5,0(a1)
    buf[1] = '\0';
 12a:	000580a3          	sb	zero,1(a1)
    return;
 12e:	8082                	ret
  for (j = 0; j < i; j++) {
 130:	4601                	li	a2,0
 132:	b7d5                	j	116 <itoa+0x6c>

0000000000000134 <strcpy>:

void strcpy(char *dst, const char *src) {
 134:	1141                	add	sp,sp,-16
 136:	e422                	sd	s0,8(sp)
 138:	0800                	add	s0,sp,16
    while ((*dst++ = *src++) != '\0');
 13a:	0585                	add	a1,a1,1
 13c:	0505                	add	a0,a0,1
 13e:	fff5c783          	lbu	a5,-1(a1)
 142:	fef50fa3          	sb	a5,-1(a0)
 146:	fbf5                	bnez	a5,13a <strcpy+0x6>
} 
 148:	6422                	ld	s0,8(sp)
 14a:	0141                	add	sp,sp,16
 14c:	8082                	ret

000000000000014e <strlen>:

uint
strlen(const char *s){
 14e:	1141                	add	sp,sp,-16
 150:	e422                	sd	s0,8(sp)
 152:	0800                	add	s0,sp,16
  int n;
  for(n = 0; s[n]; n++);
 154:	00054783          	lbu	a5,0(a0)
 158:	cf91                	beqz	a5,174 <strlen+0x26>
 15a:	0505                	add	a0,a0,1
 15c:	87aa                	mv	a5,a0
 15e:	86be                	mv	a3,a5
 160:	0785                	add	a5,a5,1
 162:	fff7c703          	lbu	a4,-1(a5)
 166:	ff65                	bnez	a4,15e <strlen+0x10>
 168:	40a6853b          	subw	a0,a3,a0
 16c:	2505                	addw	a0,a0,1
  return n;
}
 16e:	6422                	ld	s0,8(sp)
 170:	0141                	add	sp,sp,16
 172:	8082                	ret
  for(n = 0; s[n]; n++);
 174:	4501                	li	a0,0
 176:	bfe5                	j	16e <strlen+0x20>

0000000000000178 <strcmp>:

uint
strcmp(const char *p, const char *q)
{
 178:	1141                	add	sp,sp,-16
 17a:	e422                	sd	s0,8(sp)
 17c:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 17e:	00054783          	lbu	a5,0(a0)
 182:	cb91                	beqz	a5,196 <strcmp+0x1e>
 184:	0005c703          	lbu	a4,0(a1)
 188:	00f71763          	bne	a4,a5,196 <strcmp+0x1e>
    p++, q++;
 18c:	0505                	add	a0,a0,1
 18e:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 190:	00054783          	lbu	a5,0(a0)
 194:	fbe5                	bnez	a5,184 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 196:	0005c503          	lbu	a0,0(a1)
}
 19a:	40a7853b          	subw	a0,a5,a0
 19e:	6422                	ld	s0,8(sp)
 1a0:	0141                	add	sp,sp,16
 1a2:	8082                	ret

00000000000001a4 <hello>:
# generated by usys.pl - do not edit
#include "include/syscall.h"
.global hello
hello:
 li a7, SYS_hello
 1a4:	4885                	li	a7,1
 ecall
 1a6:	00000073          	ecall
 ret
 1aa:	8082                	ret

00000000000001ac <exit>:
.global exit
exit:
 li a7, SYS_exit
 1ac:	4889                	li	a7,2
 ecall
 1ae:	00000073          	ecall
 ret
 1b2:	8082                	ret

00000000000001b4 <fork>:
.global fork
fork:
 li a7, SYS_fork
 1b4:	4891                	li	a7,4
 ecall
 1b6:	00000073          	ecall
 ret
 1ba:	8082                	ret

00000000000001bc <wait>:
.global wait
wait:
 li a7, SYS_wait
 1bc:	488d                	li	a7,3
 ecall
 1be:	00000073          	ecall
 ret
 1c2:	8082                	ret

00000000000001c4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 1c4:	4895                	li	a7,5
 ecall
 1c6:	00000073          	ecall
 ret
 1ca:	8082                	ret

00000000000001cc <dup>:
.global dup
dup:
 li a7, SYS_dup
 1cc:	489d                	li	a7,7
 ecall
 1ce:	00000073          	ecall
 ret
 1d2:	8082                	ret

00000000000001d4 <open>:
.global open
open:
 li a7, SYS_open
 1d4:	4899                	li	a7,6
 ecall
 1d6:	00000073          	ecall
 ret
 1da:	8082                	ret

00000000000001dc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 1dc:	48a1                	li	a7,8
 ecall
 1de:	00000073          	ecall
 ret
 1e2:	8082                	ret

00000000000001e4 <write>:
.global write
write:
 li a7, SYS_write
 1e4:	48a5                	li	a7,9
 ecall
 1e6:	00000073          	ecall
 ret
 1ea:	8082                	ret

00000000000001ec <read>:
.global read
read:
 li a7, SYS_read
 1ec:	48a9                	li	a7,10
 ecall
 1ee:	00000073          	ecall
 ret
 1f2:	8082                	ret

00000000000001f4 <close>:
.global close
close:
 li a7, SYS_close
 1f4:	48ad                	li	a7,11
 ecall
 1f6:	00000073          	ecall
 ret
 1fa:	8082                	ret

00000000000001fc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 1fc:	48b1                	li	a7,12
 ecall
 1fe:	00000073          	ecall
 ret
 202:	8082                	ret

0000000000000204 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 204:	48b5                	li	a7,13
 ecall
 206:	00000073          	ecall
 ret
 20a:	8082                	ret

000000000000020c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 20c:	48b9                	li	a7,14
 ecall
 20e:	00000073          	ecall
 ret
 212:	8082                	ret

0000000000000214 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 214:	1101                	add	sp,sp,-32
 216:	ec06                	sd	ra,24(sp)
 218:	e822                	sd	s0,16(sp)
 21a:	1000                	add	s0,sp,32
 21c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 220:	4605                	li	a2,1
 222:	fef40593          	add	a1,s0,-17
 226:	fbfff0ef          	jal	1e4 <write>
}
 22a:	60e2                	ld	ra,24(sp)
 22c:	6442                	ld	s0,16(sp)
 22e:	6105                	add	sp,sp,32
 230:	8082                	ret

0000000000000232 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 232:	715d                	add	sp,sp,-80
 234:	e486                	sd	ra,72(sp)
 236:	e0a2                	sd	s0,64(sp)
 238:	fc26                	sd	s1,56(sp)
 23a:	f84a                	sd	s2,48(sp)
 23c:	f44e                	sd	s3,40(sp)
 23e:	0880                	add	s0,sp,80
 240:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 242:	c299                	beqz	a3,248 <printint+0x16>
 244:	0605cf63          	bltz	a1,2c2 <printint+0x90>
  neg = 0;
 248:	4881                	li	a7,0
 24a:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 24e:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 250:	5f000513          	li	a0,1520
 254:	883e                	mv	a6,a5
 256:	2785                	addw	a5,a5,1
 258:	02c5f733          	remu	a4,a1,a2
 25c:	972a                	add	a4,a4,a0
 25e:	00074703          	lbu	a4,0(a4)
 262:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 266:	872e                	mv	a4,a1
 268:	02c5d5b3          	divu	a1,a1,a2
 26c:	0685                	add	a3,a3,1
 26e:	fec773e3          	bgeu	a4,a2,254 <printint+0x22>
  if(neg)
 272:	00088b63          	beqz	a7,288 <printint+0x56>
    buf[i++] = '-';
 276:	fd078793          	add	a5,a5,-48
 27a:	97a2                	add	a5,a5,s0
 27c:	02d00713          	li	a4,45
 280:	fee78423          	sb	a4,-24(a5)
 284:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 288:	02f05663          	blez	a5,2b4 <printint+0x82>
 28c:	fb840713          	add	a4,s0,-72
 290:	00f704b3          	add	s1,a4,a5
 294:	fff70993          	add	s3,a4,-1
 298:	99be                	add	s3,s3,a5
 29a:	37fd                	addw	a5,a5,-1
 29c:	1782                	sll	a5,a5,0x20
 29e:	9381                	srl	a5,a5,0x20
 2a0:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 2a4:	fff4c583          	lbu	a1,-1(s1)
 2a8:	854a                	mv	a0,s2
 2aa:	f6bff0ef          	jal	214 <putc>
  while(--i >= 0)
 2ae:	14fd                	add	s1,s1,-1
 2b0:	ff349ae3          	bne	s1,s3,2a4 <printint+0x72>
}
 2b4:	60a6                	ld	ra,72(sp)
 2b6:	6406                	ld	s0,64(sp)
 2b8:	74e2                	ld	s1,56(sp)
 2ba:	7942                	ld	s2,48(sp)
 2bc:	79a2                	ld	s3,40(sp)
 2be:	6161                	add	sp,sp,80
 2c0:	8082                	ret
    x = -xx;
 2c2:	40b005b3          	neg	a1,a1
    neg = 1;
 2c6:	4885                	li	a7,1
    x = -xx;
 2c8:	b749                	j	24a <printint+0x18>

00000000000002ca <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 2ca:	711d                	add	sp,sp,-96
 2cc:	ec86                	sd	ra,88(sp)
 2ce:	e8a2                	sd	s0,80(sp)
 2d0:	e4a6                	sd	s1,72(sp)
 2d2:	e0ca                	sd	s2,64(sp)
 2d4:	fc4e                	sd	s3,56(sp)
 2d6:	f852                	sd	s4,48(sp)
 2d8:	f456                	sd	s5,40(sp)
 2da:	f05a                	sd	s6,32(sp)
 2dc:	ec5e                	sd	s7,24(sp)
 2de:	e862                	sd	s8,16(sp)
 2e0:	e466                	sd	s9,8(sp)
 2e2:	e06a                	sd	s10,0(sp)
 2e4:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 2e6:	0005c903          	lbu	s2,0(a1)
 2ea:	26090363          	beqz	s2,550 <vprintf+0x286>
 2ee:	8b2a                	mv	s6,a0
 2f0:	8a2e                	mv	s4,a1
 2f2:	8bb2                	mv	s7,a2
  state = 0;
 2f4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 2f6:	4481                	li	s1,0
 2f8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 2fa:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 2fe:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 302:	06c00c93          	li	s9,108
 306:	a005                	j	326 <vprintf+0x5c>
        putc(fd, c0);
 308:	85ca                	mv	a1,s2
 30a:	855a                	mv	a0,s6
 30c:	f09ff0ef          	jal	214 <putc>
 310:	a019                	j	316 <vprintf+0x4c>
    } else if(state == '%'){
 312:	03598263          	beq	s3,s5,336 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 316:	2485                	addw	s1,s1,1
 318:	8726                	mv	a4,s1
 31a:	009a07b3          	add	a5,s4,s1
 31e:	0007c903          	lbu	s2,0(a5)
 322:	22090763          	beqz	s2,550 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 326:	0009079b          	sext.w	a5,s2
    if(state == 0){
 32a:	fe0994e3          	bnez	s3,312 <vprintf+0x48>
      if(c0 == '%'){
 32e:	fd579de3          	bne	a5,s5,308 <vprintf+0x3e>
        state = '%';
 332:	89be                	mv	s3,a5
 334:	b7cd                	j	316 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 336:	cbc9                	beqz	a5,3c8 <vprintf+0xfe>
 338:	00ea06b3          	add	a3,s4,a4
 33c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 340:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 342:	c681                	beqz	a3,34a <vprintf+0x80>
 344:	9752                	add	a4,a4,s4
 346:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 34a:	05878363          	beq	a5,s8,390 <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 34e:	05978d63          	beq	a5,s9,3a8 <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 352:	07500713          	li	a4,117
 356:	0ee78763          	beq	a5,a4,444 <vprintf+0x17a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 35a:	07800713          	li	a4,120
 35e:	12e78963          	beq	a5,a4,490 <vprintf+0x1c6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 362:	07000713          	li	a4,112
 366:	14e78e63          	beq	a5,a4,4c2 <vprintf+0x1f8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 36a:	06300713          	li	a4,99
 36e:	18e78a63          	beq	a5,a4,502 <vprintf+0x238>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 372:	07300713          	li	a4,115
 376:	1ae78063          	beq	a5,a4,516 <vprintf+0x24c>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 37a:	02500713          	li	a4,37
 37e:	04e79563          	bne	a5,a4,3c8 <vprintf+0xfe>
        putc(fd, '%');
 382:	02500593          	li	a1,37
 386:	855a                	mv	a0,s6
 388:	e8dff0ef          	jal	214 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 38c:	4981                	li	s3,0
 38e:	b761                	j	316 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 390:	008b8913          	add	s2,s7,8
 394:	4685                	li	a3,1
 396:	4629                	li	a2,10
 398:	000ba583          	lw	a1,0(s7)
 39c:	855a                	mv	a0,s6
 39e:	e95ff0ef          	jal	232 <printint>
 3a2:	8bca                	mv	s7,s2
      state = 0;
 3a4:	4981                	li	s3,0
 3a6:	bf85                	j	316 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 3a8:	06400793          	li	a5,100
 3ac:	02f68963          	beq	a3,a5,3de <vprintf+0x114>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 3b0:	06c00793          	li	a5,108
 3b4:	04f68263          	beq	a3,a5,3f8 <vprintf+0x12e>
      } else if(c0 == 'l' && c1 == 'u'){
 3b8:	07500793          	li	a5,117
 3bc:	0af68063          	beq	a3,a5,45c <vprintf+0x192>
      } else if(c0 == 'l' && c1 == 'x'){
 3c0:	07800793          	li	a5,120
 3c4:	0ef68263          	beq	a3,a5,4a8 <vprintf+0x1de>
        putc(fd, '%');
 3c8:	02500593          	li	a1,37
 3cc:	855a                	mv	a0,s6
 3ce:	e47ff0ef          	jal	214 <putc>
        putc(fd, c0);
 3d2:	85ca                	mv	a1,s2
 3d4:	855a                	mv	a0,s6
 3d6:	e3fff0ef          	jal	214 <putc>
      state = 0;
 3da:	4981                	li	s3,0
 3dc:	bf2d                	j	316 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 3de:	008b8913          	add	s2,s7,8
 3e2:	4685                	li	a3,1
 3e4:	4629                	li	a2,10
 3e6:	000bb583          	ld	a1,0(s7)
 3ea:	855a                	mv	a0,s6
 3ec:	e47ff0ef          	jal	232 <printint>
        i += 1;
 3f0:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 3f2:	8bca                	mv	s7,s2
      state = 0;
 3f4:	4981                	li	s3,0
        i += 1;
 3f6:	b705                	j	316 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 3f8:	06400793          	li	a5,100
 3fc:	02f60763          	beq	a2,a5,42a <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 400:	07500793          	li	a5,117
 404:	06f60963          	beq	a2,a5,476 <vprintf+0x1ac>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 408:	07800793          	li	a5,120
 40c:	faf61ee3          	bne	a2,a5,3c8 <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 410:	008b8913          	add	s2,s7,8
 414:	4681                	li	a3,0
 416:	4641                	li	a2,16
 418:	000bb583          	ld	a1,0(s7)
 41c:	855a                	mv	a0,s6
 41e:	e15ff0ef          	jal	232 <printint>
        i += 2;
 422:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 424:	8bca                	mv	s7,s2
      state = 0;
 426:	4981                	li	s3,0
        i += 2;
 428:	b5fd                	j	316 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 42a:	008b8913          	add	s2,s7,8
 42e:	4685                	li	a3,1
 430:	4629                	li	a2,10
 432:	000bb583          	ld	a1,0(s7)
 436:	855a                	mv	a0,s6
 438:	dfbff0ef          	jal	232 <printint>
        i += 2;
 43c:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 43e:	8bca                	mv	s7,s2
      state = 0;
 440:	4981                	li	s3,0
        i += 2;
 442:	bdd1                	j	316 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 10, 0);
 444:	008b8913          	add	s2,s7,8
 448:	4681                	li	a3,0
 44a:	4629                	li	a2,10
 44c:	000be583          	lwu	a1,0(s7)
 450:	855a                	mv	a0,s6
 452:	de1ff0ef          	jal	232 <printint>
 456:	8bca                	mv	s7,s2
      state = 0;
 458:	4981                	li	s3,0
 45a:	bd75                	j	316 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 45c:	008b8913          	add	s2,s7,8
 460:	4681                	li	a3,0
 462:	4629                	li	a2,10
 464:	000bb583          	ld	a1,0(s7)
 468:	855a                	mv	a0,s6
 46a:	dc9ff0ef          	jal	232 <printint>
        i += 1;
 46e:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 470:	8bca                	mv	s7,s2
      state = 0;
 472:	4981                	li	s3,0
        i += 1;
 474:	b54d                	j	316 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 476:	008b8913          	add	s2,s7,8
 47a:	4681                	li	a3,0
 47c:	4629                	li	a2,10
 47e:	000bb583          	ld	a1,0(s7)
 482:	855a                	mv	a0,s6
 484:	dafff0ef          	jal	232 <printint>
        i += 2;
 488:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 48a:	8bca                	mv	s7,s2
      state = 0;
 48c:	4981                	li	s3,0
        i += 2;
 48e:	b561                	j	316 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 16, 0);
 490:	008b8913          	add	s2,s7,8
 494:	4681                	li	a3,0
 496:	4641                	li	a2,16
 498:	000be583          	lwu	a1,0(s7)
 49c:	855a                	mv	a0,s6
 49e:	d95ff0ef          	jal	232 <printint>
 4a2:	8bca                	mv	s7,s2
      state = 0;
 4a4:	4981                	li	s3,0
 4a6:	bd85                	j	316 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 4a8:	008b8913          	add	s2,s7,8
 4ac:	4681                	li	a3,0
 4ae:	4641                	li	a2,16
 4b0:	000bb583          	ld	a1,0(s7)
 4b4:	855a                	mv	a0,s6
 4b6:	d7dff0ef          	jal	232 <printint>
        i += 1;
 4ba:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 4bc:	8bca                	mv	s7,s2
      state = 0;
 4be:	4981                	li	s3,0
        i += 1;
 4c0:	bd99                	j	316 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 4c2:	008b8d13          	add	s10,s7,8
 4c6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 4ca:	03000593          	li	a1,48
 4ce:	855a                	mv	a0,s6
 4d0:	d45ff0ef          	jal	214 <putc>
  putc(fd, 'x');
 4d4:	07800593          	li	a1,120
 4d8:	855a                	mv	a0,s6
 4da:	d3bff0ef          	jal	214 <putc>
 4de:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4e0:	5f000b93          	li	s7,1520
 4e4:	03c9d793          	srl	a5,s3,0x3c
 4e8:	97de                	add	a5,a5,s7
 4ea:	0007c583          	lbu	a1,0(a5)
 4ee:	855a                	mv	a0,s6
 4f0:	d25ff0ef          	jal	214 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 4f4:	0992                	sll	s3,s3,0x4
 4f6:	397d                	addw	s2,s2,-1
 4f8:	fe0916e3          	bnez	s2,4e4 <vprintf+0x21a>
        printptr(fd, va_arg(ap, uint64));
 4fc:	8bea                	mv	s7,s10
      state = 0;
 4fe:	4981                	li	s3,0
 500:	bd19                	j	316 <vprintf+0x4c>
        putc(fd, va_arg(ap, uint32));
 502:	008b8913          	add	s2,s7,8
 506:	000bc583          	lbu	a1,0(s7)
 50a:	855a                	mv	a0,s6
 50c:	d09ff0ef          	jal	214 <putc>
 510:	8bca                	mv	s7,s2
      state = 0;
 512:	4981                	li	s3,0
 514:	b509                	j	316 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 516:	008b8993          	add	s3,s7,8
 51a:	000bb903          	ld	s2,0(s7)
 51e:	00090f63          	beqz	s2,53c <vprintf+0x272>
        for(; *s; s++)
 522:	00094583          	lbu	a1,0(s2)
 526:	c195                	beqz	a1,54a <vprintf+0x280>
          putc(fd, *s);
 528:	855a                	mv	a0,s6
 52a:	cebff0ef          	jal	214 <putc>
        for(; *s; s++)
 52e:	0905                	add	s2,s2,1
 530:	00094583          	lbu	a1,0(s2)
 534:	f9f5                	bnez	a1,528 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 536:	8bce                	mv	s7,s3
      state = 0;
 538:	4981                	li	s3,0
 53a:	bbf1                	j	316 <vprintf+0x4c>
          s = "(null)";
 53c:	00000917          	auipc	s2,0x0
 540:	0ac90913          	add	s2,s2,172 # 5e8 <printf+0x52>
        for(; *s; s++)
 544:	02800593          	li	a1,40
 548:	b7c5                	j	528 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 54a:	8bce                	mv	s7,s3
      state = 0;
 54c:	4981                	li	s3,0
 54e:	b3e1                	j	316 <vprintf+0x4c>
    }
  }
}
 550:	60e6                	ld	ra,88(sp)
 552:	6446                	ld	s0,80(sp)
 554:	64a6                	ld	s1,72(sp)
 556:	6906                	ld	s2,64(sp)
 558:	79e2                	ld	s3,56(sp)
 55a:	7a42                	ld	s4,48(sp)
 55c:	7aa2                	ld	s5,40(sp)
 55e:	7b02                	ld	s6,32(sp)
 560:	6be2                	ld	s7,24(sp)
 562:	6c42                	ld	s8,16(sp)
 564:	6ca2                	ld	s9,8(sp)
 566:	6d02                	ld	s10,0(sp)
 568:	6125                	add	sp,sp,96
 56a:	8082                	ret

000000000000056c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 56c:	715d                	add	sp,sp,-80
 56e:	ec06                	sd	ra,24(sp)
 570:	e822                	sd	s0,16(sp)
 572:	1000                	add	s0,sp,32
 574:	e010                	sd	a2,0(s0)
 576:	e414                	sd	a3,8(s0)
 578:	e818                	sd	a4,16(s0)
 57a:	ec1c                	sd	a5,24(s0)
 57c:	03043023          	sd	a6,32(s0)
 580:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 584:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 588:	8622                	mv	a2,s0
 58a:	d41ff0ef          	jal	2ca <vprintf>
}
 58e:	60e2                	ld	ra,24(sp)
 590:	6442                	ld	s0,16(sp)
 592:	6161                	add	sp,sp,80
 594:	8082                	ret

0000000000000596 <printf>:

void
printf(const char *fmt, ...)
{
 596:	711d                	add	sp,sp,-96
 598:	ec06                	sd	ra,24(sp)
 59a:	e822                	sd	s0,16(sp)
 59c:	1000                	add	s0,sp,32
 59e:	e40c                	sd	a1,8(s0)
 5a0:	e810                	sd	a2,16(s0)
 5a2:	ec14                	sd	a3,24(s0)
 5a4:	f018                	sd	a4,32(s0)
 5a6:	f41c                	sd	a5,40(s0)
 5a8:	03043823          	sd	a6,48(s0)
 5ac:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 5b0:	00840613          	add	a2,s0,8
 5b4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 5b8:	85aa                	mv	a1,a0
 5ba:	4505                	li	a0,1
 5bc:	d0fff0ef          	jal	2ca <vprintf>
 5c0:	60e2                	ld	ra,24(sp)
 5c2:	6442                	ld	s0,16(sp)
 5c4:	6125                	add	sp,sp,96
 5c6:	8082                	ret
