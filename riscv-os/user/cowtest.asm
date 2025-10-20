
user/_cowtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <func>:
#include "include/types.h"
#include "include/param.h"
#include "include/user.h"

int func(int a, int b){
   0:	1141                	add	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	add	s0,sp,16
    int c = a + b;
    return c;
}
   6:	9d2d                	addw	a0,a0,a1
   8:	6422                	ld	s0,8(sp)
   a:	0141                	add	sp,sp,16
   c:	8082                	ret

000000000000000e <test_cow>:

void test_cow(){
   e:	1101                	add	sp,sp,-32
  10:	ec06                	sd	ra,24(sp)
  12:	e822                	sd	s0,16(sp)
  14:	e426                	sd	s1,8(sp)
  16:	e04a                	sd	s2,0(sp)
  18:	1000                	add	s0,sp,32
    for(int i= 0; i < 40 ;i++){
  1a:	4481                	li	s1,0
  1c:	02800913          	li	s2,40
        int pid = fork();
  20:	1a8000ef          	jal	1c8 <fork>
        if(pid < 0){
  24:	00054763          	bltz	a0,32 <test_cow+0x24>
            printf("Fork失败 at %d\n", i);
            break;
        }else if(pid == 0){
  28:	cd15                	beqz	a0,64 <test_cow+0x56>
    for(int i= 0; i < 40 ;i++){
  2a:	2485                	addw	s1,s1,1
  2c:	ff249ae3          	bne	s1,s2,20 <test_cow+0x12>
  30:	a801                	j	40 <test_cow+0x32>
            printf("Fork失败 at %d\n", i);
  32:	85a6                	mv	a1,s1
  34:	00000517          	auipc	a0,0x0
  38:	5ac50513          	add	a0,a0,1452 # 5e0 <printf+0x36>
  3c:	56e000ef          	jal	5aa <printf>
            }
            exit(1);
        }
    }

    for(int i = 0; i < 40; i++){
  40:	02800493          	li	s1,40
        int wpid = wait(0);
        if(wpid < 0){
            printf("等待子进程失败\n");
            break;
        } else {
            printf("子进程 %d 已退出\n", wpid);
  44:	00000917          	auipc	s2,0x0
  48:	5cc90913          	add	s2,s2,1484 # 610 <printf+0x66>
        int wpid = wait(0);
  4c:	4501                	li	a0,0
  4e:	182000ef          	jal	1d0 <wait>
  52:	85aa                	mv	a1,a0
        if(wpid < 0){
  54:	02054063          	bltz	a0,74 <test_cow+0x66>
            printf("子进程 %d 已退出\n", wpid);
  58:	854a                	mv	a0,s2
  5a:	550000ef          	jal	5aa <printf>
    for(int i = 0; i < 40; i++){
  5e:	34fd                	addw	s1,s1,-1
  60:	f4f5                	bnez	s1,4c <test_cow+0x3e>
  62:	a839                	j	80 <test_cow+0x72>
  64:	6789                	lui	a5,0x2
  66:	71078793          	add	a5,a5,1808 # 2710 <digits+0x20c8>
            for(int i = 0; i < 10000; i++){
  6a:	37fd                	addw	a5,a5,-1
  6c:	fffd                	bnez	a5,6a <test_cow+0x5c>
            exit(1);
  6e:	4505                	li	a0,1
  70:	150000ef          	jal	1c0 <exit>
            printf("等待子进程失败\n");
  74:	00000517          	auipc	a0,0x0
  78:	58450513          	add	a0,a0,1412 # 5f8 <printf+0x4e>
  7c:	52e000ef          	jal	5aa <printf>
        }
    }

    printf("COW测试成功\n");
  80:	00000517          	auipc	a0,0x0
  84:	5a850513          	add	a0,a0,1448 # 628 <printf+0x7e>
  88:	522000ef          	jal	5aa <printf>
}
  8c:	60e2                	ld	ra,24(sp)
  8e:	6442                	ld	s0,16(sp)
  90:	64a2                	ld	s1,8(sp)
  92:	6902                	ld	s2,0(sp)
  94:	6105                	add	sp,sp,32
  96:	8082                	ret

0000000000000098 <main>:

int 
main(int argc, char const *argv[])
{
  98:	1141                	add	sp,sp,-16
  9a:	e406                	sd	ra,8(sp)
  9c:	e022                	sd	s0,0(sp)
  9e:	0800                	add	s0,sp,16
    test_cow();
  a0:	f6fff0ef          	jal	e <test_cow>
    return 0;
}
  a4:	4501                	li	a0,0
  a6:	60a2                	ld	ra,8(sp)
  a8:	6402                	ld	s0,0(sp)
  aa:	0141                	add	sp,sp,16
  ac:	8082                	ret

00000000000000ae <start>:
#include "include/user.h"


void
start(int argc, char **argv)
{
  ae:	1141                	add	sp,sp,-16
  b0:	e406                	sd	ra,8(sp)
  b2:	e022                	sd	s0,0(sp)
  b4:	0800                	add	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  b6:	fe3ff0ef          	jal	98 <main>


  exit(r);
  ba:	106000ef          	jal	1c0 <exit>

00000000000000be <itoa>:
{
  char temp[16];
  int i = 0;
  int j = 0;

  if (n == 0) {
  be:	cd25                	beqz	a0,136 <itoa+0x78>
{
  c0:	1101                	add	sp,sp,-32
  c2:	ec22                	sd	s0,24(sp)
  c4:	1000                	add	s0,sp,32
    buf[1] = '\0';
    return;
  }
  
  // Generate digits in reverse order
  while (n > 0) {
  c6:	fe040693          	add	a3,s0,-32
  int i = 0;
  ca:	4701                	li	a4,0
    temp[i++] = (n % 10) + '0';
  cc:	4829                	li	a6,10
  while (n > 0) {
  ce:	48a5                	li	a7,9
    n /= 10;
  }
  temp[i] = '\0';

  // Reverse the string to get the correct order
  for (j = 0; j < i; j++) {
  d0:	4601                	li	a2,0
  while (n > 0) {
  d2:	04a05c63          	blez	a0,12a <itoa+0x6c>
    temp[i++] = (n % 10) + '0';
  d6:	863a                	mv	a2,a4
  d8:	2705                	addw	a4,a4,1
  da:	030567bb          	remw	a5,a0,a6
  de:	0307879b          	addw	a5,a5,48
  e2:	00f68023          	sb	a5,0(a3)
    n /= 10;
  e6:	87aa                	mv	a5,a0
  e8:	0305453b          	divw	a0,a0,a6
  while (n > 0) {
  ec:	0685                	add	a3,a3,1
  ee:	fef8c4e3          	blt	a7,a5,d6 <itoa+0x18>
  temp[i] = '\0';
  f2:	ff070793          	add	a5,a4,-16
  f6:	97a2                	add	a5,a5,s0
  f8:	fe078823          	sb	zero,-16(a5)
  for (j = 0; j < i; j++) {
  fc:	04e05463          	blez	a4,144 <itoa+0x86>
 100:	fe040793          	add	a5,s0,-32
 104:	00c786b3          	add	a3,a5,a2
 108:	87ae                	mv	a5,a1
    buf[j] = temp[i - 1 - j];
 10a:	0006c703          	lbu	a4,0(a3)
 10e:	00e78023          	sb	a4,0(a5)
  for (j = 0; j < i; j++) {
 112:	16fd                	add	a3,a3,-1
 114:	0785                	add	a5,a5,1
 116:	40b7873b          	subw	a4,a5,a1
 11a:	377d                	addw	a4,a4,-1
 11c:	fec747e3          	blt	a4,a2,10a <itoa+0x4c>
 120:	fff64793          	not	a5,a2
 124:	97fd                	sra	a5,a5,0x3f
 126:	8e7d                	and	a2,a2,a5
 128:	2605                	addw	a2,a2,1
  }
  buf[j] = '\0';
 12a:	95b2                	add	a1,a1,a2
 12c:	00058023          	sb	zero,0(a1)
}
 130:	6462                	ld	s0,24(sp)
 132:	6105                	add	sp,sp,32
 134:	8082                	ret
    buf[0] = '0';
 136:	03000793          	li	a5,48
 13a:	00f58023          	sb	a5,0(a1)
    buf[1] = '\0';
 13e:	000580a3          	sb	zero,1(a1)
    return;
 142:	8082                	ret
  for (j = 0; j < i; j++) {
 144:	4601                	li	a2,0
 146:	b7d5                	j	12a <itoa+0x6c>

0000000000000148 <strcpy>:

void strcpy(char *dst, const char *src) {
 148:	1141                	add	sp,sp,-16
 14a:	e422                	sd	s0,8(sp)
 14c:	0800                	add	s0,sp,16
    while ((*dst++ = *src++) != '\0');
 14e:	0585                	add	a1,a1,1
 150:	0505                	add	a0,a0,1
 152:	fff5c783          	lbu	a5,-1(a1)
 156:	fef50fa3          	sb	a5,-1(a0)
 15a:	fbf5                	bnez	a5,14e <strcpy+0x6>
} 
 15c:	6422                	ld	s0,8(sp)
 15e:	0141                	add	sp,sp,16
 160:	8082                	ret

0000000000000162 <strlen>:

uint
strlen(const char *s){
 162:	1141                	add	sp,sp,-16
 164:	e422                	sd	s0,8(sp)
 166:	0800                	add	s0,sp,16
  int n;
  for(n = 0; s[n]; n++);
 168:	00054783          	lbu	a5,0(a0)
 16c:	cf91                	beqz	a5,188 <strlen+0x26>
 16e:	0505                	add	a0,a0,1
 170:	87aa                	mv	a5,a0
 172:	86be                	mv	a3,a5
 174:	0785                	add	a5,a5,1
 176:	fff7c703          	lbu	a4,-1(a5)
 17a:	ff65                	bnez	a4,172 <strlen+0x10>
 17c:	40a6853b          	subw	a0,a3,a0
 180:	2505                	addw	a0,a0,1
  return n;
}
 182:	6422                	ld	s0,8(sp)
 184:	0141                	add	sp,sp,16
 186:	8082                	ret
  for(n = 0; s[n]; n++);
 188:	4501                	li	a0,0
 18a:	bfe5                	j	182 <strlen+0x20>

000000000000018c <strcmp>:

uint
strcmp(const char *p, const char *q)
{
 18c:	1141                	add	sp,sp,-16
 18e:	e422                	sd	s0,8(sp)
 190:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 192:	00054783          	lbu	a5,0(a0)
 196:	cb91                	beqz	a5,1aa <strcmp+0x1e>
 198:	0005c703          	lbu	a4,0(a1)
 19c:	00f71763          	bne	a4,a5,1aa <strcmp+0x1e>
    p++, q++;
 1a0:	0505                	add	a0,a0,1
 1a2:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 1a4:	00054783          	lbu	a5,0(a0)
 1a8:	fbe5                	bnez	a5,198 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1aa:	0005c503          	lbu	a0,0(a1)
}
 1ae:	40a7853b          	subw	a0,a5,a0
 1b2:	6422                	ld	s0,8(sp)
 1b4:	0141                	add	sp,sp,16
 1b6:	8082                	ret

00000000000001b8 <hello>:
# generated by usys.pl - do not edit
#include "include/syscall.h"
.global hello
hello:
 li a7, SYS_hello
 1b8:	4885                	li	a7,1
 ecall
 1ba:	00000073          	ecall
 ret
 1be:	8082                	ret

00000000000001c0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 1c0:	4889                	li	a7,2
 ecall
 1c2:	00000073          	ecall
 ret
 1c6:	8082                	ret

00000000000001c8 <fork>:
.global fork
fork:
 li a7, SYS_fork
 1c8:	4891                	li	a7,4
 ecall
 1ca:	00000073          	ecall
 ret
 1ce:	8082                	ret

00000000000001d0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 1d0:	488d                	li	a7,3
 ecall
 1d2:	00000073          	ecall
 ret
 1d6:	8082                	ret

00000000000001d8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 1d8:	4895                	li	a7,5
 ecall
 1da:	00000073          	ecall
 ret
 1de:	8082                	ret

00000000000001e0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 1e0:	489d                	li	a7,7
 ecall
 1e2:	00000073          	ecall
 ret
 1e6:	8082                	ret

00000000000001e8 <open>:
.global open
open:
 li a7, SYS_open
 1e8:	4899                	li	a7,6
 ecall
 1ea:	00000073          	ecall
 ret
 1ee:	8082                	ret

00000000000001f0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 1f0:	48a1                	li	a7,8
 ecall
 1f2:	00000073          	ecall
 ret
 1f6:	8082                	ret

00000000000001f8 <write>:
.global write
write:
 li a7, SYS_write
 1f8:	48a5                	li	a7,9
 ecall
 1fa:	00000073          	ecall
 ret
 1fe:	8082                	ret

0000000000000200 <read>:
.global read
read:
 li a7, SYS_read
 200:	48a9                	li	a7,10
 ecall
 202:	00000073          	ecall
 ret
 206:	8082                	ret

0000000000000208 <close>:
.global close
close:
 li a7, SYS_close
 208:	48ad                	li	a7,11
 ecall
 20a:	00000073          	ecall
 ret
 20e:	8082                	ret

0000000000000210 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 210:	48b1                	li	a7,12
 ecall
 212:	00000073          	ecall
 ret
 216:	8082                	ret

0000000000000218 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 218:	48b5                	li	a7,13
 ecall
 21a:	00000073          	ecall
 ret
 21e:	8082                	ret

0000000000000220 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 220:	48b9                	li	a7,14
 ecall
 222:	00000073          	ecall
 ret
 226:	8082                	ret

0000000000000228 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 228:	1101                	add	sp,sp,-32
 22a:	ec06                	sd	ra,24(sp)
 22c:	e822                	sd	s0,16(sp)
 22e:	1000                	add	s0,sp,32
 230:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 234:	4605                	li	a2,1
 236:	fef40593          	add	a1,s0,-17
 23a:	fbfff0ef          	jal	1f8 <write>
}
 23e:	60e2                	ld	ra,24(sp)
 240:	6442                	ld	s0,16(sp)
 242:	6105                	add	sp,sp,32
 244:	8082                	ret

0000000000000246 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 246:	715d                	add	sp,sp,-80
 248:	e486                	sd	ra,72(sp)
 24a:	e0a2                	sd	s0,64(sp)
 24c:	fc26                	sd	s1,56(sp)
 24e:	f84a                	sd	s2,48(sp)
 250:	f44e                	sd	s3,40(sp)
 252:	0880                	add	s0,sp,80
 254:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 256:	c299                	beqz	a3,25c <printint+0x16>
 258:	0605cf63          	bltz	a1,2d6 <printint+0x90>
  neg = 0;
 25c:	4881                	li	a7,0
 25e:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 262:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 264:	64800513          	li	a0,1608
 268:	883e                	mv	a6,a5
 26a:	2785                	addw	a5,a5,1
 26c:	02c5f733          	remu	a4,a1,a2
 270:	972a                	add	a4,a4,a0
 272:	00074703          	lbu	a4,0(a4)
 276:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 27a:	872e                	mv	a4,a1
 27c:	02c5d5b3          	divu	a1,a1,a2
 280:	0685                	add	a3,a3,1
 282:	fec773e3          	bgeu	a4,a2,268 <printint+0x22>
  if(neg)
 286:	00088b63          	beqz	a7,29c <printint+0x56>
    buf[i++] = '-';
 28a:	fd078793          	add	a5,a5,-48
 28e:	97a2                	add	a5,a5,s0
 290:	02d00713          	li	a4,45
 294:	fee78423          	sb	a4,-24(a5)
 298:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 29c:	02f05663          	blez	a5,2c8 <printint+0x82>
 2a0:	fb840713          	add	a4,s0,-72
 2a4:	00f704b3          	add	s1,a4,a5
 2a8:	fff70993          	add	s3,a4,-1
 2ac:	99be                	add	s3,s3,a5
 2ae:	37fd                	addw	a5,a5,-1
 2b0:	1782                	sll	a5,a5,0x20
 2b2:	9381                	srl	a5,a5,0x20
 2b4:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 2b8:	fff4c583          	lbu	a1,-1(s1)
 2bc:	854a                	mv	a0,s2
 2be:	f6bff0ef          	jal	228 <putc>
  while(--i >= 0)
 2c2:	14fd                	add	s1,s1,-1
 2c4:	ff349ae3          	bne	s1,s3,2b8 <printint+0x72>
}
 2c8:	60a6                	ld	ra,72(sp)
 2ca:	6406                	ld	s0,64(sp)
 2cc:	74e2                	ld	s1,56(sp)
 2ce:	7942                	ld	s2,48(sp)
 2d0:	79a2                	ld	s3,40(sp)
 2d2:	6161                	add	sp,sp,80
 2d4:	8082                	ret
    x = -xx;
 2d6:	40b005b3          	neg	a1,a1
    neg = 1;
 2da:	4885                	li	a7,1
    x = -xx;
 2dc:	b749                	j	25e <printint+0x18>

00000000000002de <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 2de:	711d                	add	sp,sp,-96
 2e0:	ec86                	sd	ra,88(sp)
 2e2:	e8a2                	sd	s0,80(sp)
 2e4:	e4a6                	sd	s1,72(sp)
 2e6:	e0ca                	sd	s2,64(sp)
 2e8:	fc4e                	sd	s3,56(sp)
 2ea:	f852                	sd	s4,48(sp)
 2ec:	f456                	sd	s5,40(sp)
 2ee:	f05a                	sd	s6,32(sp)
 2f0:	ec5e                	sd	s7,24(sp)
 2f2:	e862                	sd	s8,16(sp)
 2f4:	e466                	sd	s9,8(sp)
 2f6:	e06a                	sd	s10,0(sp)
 2f8:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 2fa:	0005c903          	lbu	s2,0(a1)
 2fe:	26090363          	beqz	s2,564 <vprintf+0x286>
 302:	8b2a                	mv	s6,a0
 304:	8a2e                	mv	s4,a1
 306:	8bb2                	mv	s7,a2
  state = 0;
 308:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 30a:	4481                	li	s1,0
 30c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 30e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 312:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 316:	06c00c93          	li	s9,108
 31a:	a005                	j	33a <vprintf+0x5c>
        putc(fd, c0);
 31c:	85ca                	mv	a1,s2
 31e:	855a                	mv	a0,s6
 320:	f09ff0ef          	jal	228 <putc>
 324:	a019                	j	32a <vprintf+0x4c>
    } else if(state == '%'){
 326:	03598263          	beq	s3,s5,34a <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 32a:	2485                	addw	s1,s1,1
 32c:	8726                	mv	a4,s1
 32e:	009a07b3          	add	a5,s4,s1
 332:	0007c903          	lbu	s2,0(a5)
 336:	22090763          	beqz	s2,564 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 33a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 33e:	fe0994e3          	bnez	s3,326 <vprintf+0x48>
      if(c0 == '%'){
 342:	fd579de3          	bne	a5,s5,31c <vprintf+0x3e>
        state = '%';
 346:	89be                	mv	s3,a5
 348:	b7cd                	j	32a <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 34a:	cbc9                	beqz	a5,3dc <vprintf+0xfe>
 34c:	00ea06b3          	add	a3,s4,a4
 350:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 354:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 356:	c681                	beqz	a3,35e <vprintf+0x80>
 358:	9752                	add	a4,a4,s4
 35a:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 35e:	05878363          	beq	a5,s8,3a4 <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 362:	05978d63          	beq	a5,s9,3bc <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 366:	07500713          	li	a4,117
 36a:	0ee78763          	beq	a5,a4,458 <vprintf+0x17a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 36e:	07800713          	li	a4,120
 372:	12e78963          	beq	a5,a4,4a4 <vprintf+0x1c6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 376:	07000713          	li	a4,112
 37a:	14e78e63          	beq	a5,a4,4d6 <vprintf+0x1f8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 37e:	06300713          	li	a4,99
 382:	18e78a63          	beq	a5,a4,516 <vprintf+0x238>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 386:	07300713          	li	a4,115
 38a:	1ae78063          	beq	a5,a4,52a <vprintf+0x24c>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 38e:	02500713          	li	a4,37
 392:	04e79563          	bne	a5,a4,3dc <vprintf+0xfe>
        putc(fd, '%');
 396:	02500593          	li	a1,37
 39a:	855a                	mv	a0,s6
 39c:	e8dff0ef          	jal	228 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 3a0:	4981                	li	s3,0
 3a2:	b761                	j	32a <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 3a4:	008b8913          	add	s2,s7,8
 3a8:	4685                	li	a3,1
 3aa:	4629                	li	a2,10
 3ac:	000ba583          	lw	a1,0(s7)
 3b0:	855a                	mv	a0,s6
 3b2:	e95ff0ef          	jal	246 <printint>
 3b6:	8bca                	mv	s7,s2
      state = 0;
 3b8:	4981                	li	s3,0
 3ba:	bf85                	j	32a <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 3bc:	06400793          	li	a5,100
 3c0:	02f68963          	beq	a3,a5,3f2 <vprintf+0x114>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 3c4:	06c00793          	li	a5,108
 3c8:	04f68263          	beq	a3,a5,40c <vprintf+0x12e>
      } else if(c0 == 'l' && c1 == 'u'){
 3cc:	07500793          	li	a5,117
 3d0:	0af68063          	beq	a3,a5,470 <vprintf+0x192>
      } else if(c0 == 'l' && c1 == 'x'){
 3d4:	07800793          	li	a5,120
 3d8:	0ef68263          	beq	a3,a5,4bc <vprintf+0x1de>
        putc(fd, '%');
 3dc:	02500593          	li	a1,37
 3e0:	855a                	mv	a0,s6
 3e2:	e47ff0ef          	jal	228 <putc>
        putc(fd, c0);
 3e6:	85ca                	mv	a1,s2
 3e8:	855a                	mv	a0,s6
 3ea:	e3fff0ef          	jal	228 <putc>
      state = 0;
 3ee:	4981                	li	s3,0
 3f0:	bf2d                	j	32a <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 3f2:	008b8913          	add	s2,s7,8
 3f6:	4685                	li	a3,1
 3f8:	4629                	li	a2,10
 3fa:	000bb583          	ld	a1,0(s7)
 3fe:	855a                	mv	a0,s6
 400:	e47ff0ef          	jal	246 <printint>
        i += 1;
 404:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 406:	8bca                	mv	s7,s2
      state = 0;
 408:	4981                	li	s3,0
        i += 1;
 40a:	b705                	j	32a <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 40c:	06400793          	li	a5,100
 410:	02f60763          	beq	a2,a5,43e <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 414:	07500793          	li	a5,117
 418:	06f60963          	beq	a2,a5,48a <vprintf+0x1ac>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 41c:	07800793          	li	a5,120
 420:	faf61ee3          	bne	a2,a5,3dc <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 424:	008b8913          	add	s2,s7,8
 428:	4681                	li	a3,0
 42a:	4641                	li	a2,16
 42c:	000bb583          	ld	a1,0(s7)
 430:	855a                	mv	a0,s6
 432:	e15ff0ef          	jal	246 <printint>
        i += 2;
 436:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 438:	8bca                	mv	s7,s2
      state = 0;
 43a:	4981                	li	s3,0
        i += 2;
 43c:	b5fd                	j	32a <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 43e:	008b8913          	add	s2,s7,8
 442:	4685                	li	a3,1
 444:	4629                	li	a2,10
 446:	000bb583          	ld	a1,0(s7)
 44a:	855a                	mv	a0,s6
 44c:	dfbff0ef          	jal	246 <printint>
        i += 2;
 450:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 452:	8bca                	mv	s7,s2
      state = 0;
 454:	4981                	li	s3,0
        i += 2;
 456:	bdd1                	j	32a <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 10, 0);
 458:	008b8913          	add	s2,s7,8
 45c:	4681                	li	a3,0
 45e:	4629                	li	a2,10
 460:	000be583          	lwu	a1,0(s7)
 464:	855a                	mv	a0,s6
 466:	de1ff0ef          	jal	246 <printint>
 46a:	8bca                	mv	s7,s2
      state = 0;
 46c:	4981                	li	s3,0
 46e:	bd75                	j	32a <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 470:	008b8913          	add	s2,s7,8
 474:	4681                	li	a3,0
 476:	4629                	li	a2,10
 478:	000bb583          	ld	a1,0(s7)
 47c:	855a                	mv	a0,s6
 47e:	dc9ff0ef          	jal	246 <printint>
        i += 1;
 482:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 484:	8bca                	mv	s7,s2
      state = 0;
 486:	4981                	li	s3,0
        i += 1;
 488:	b54d                	j	32a <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 48a:	008b8913          	add	s2,s7,8
 48e:	4681                	li	a3,0
 490:	4629                	li	a2,10
 492:	000bb583          	ld	a1,0(s7)
 496:	855a                	mv	a0,s6
 498:	dafff0ef          	jal	246 <printint>
        i += 2;
 49c:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 49e:	8bca                	mv	s7,s2
      state = 0;
 4a0:	4981                	li	s3,0
        i += 2;
 4a2:	b561                	j	32a <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 16, 0);
 4a4:	008b8913          	add	s2,s7,8
 4a8:	4681                	li	a3,0
 4aa:	4641                	li	a2,16
 4ac:	000be583          	lwu	a1,0(s7)
 4b0:	855a                	mv	a0,s6
 4b2:	d95ff0ef          	jal	246 <printint>
 4b6:	8bca                	mv	s7,s2
      state = 0;
 4b8:	4981                	li	s3,0
 4ba:	bd85                	j	32a <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 4bc:	008b8913          	add	s2,s7,8
 4c0:	4681                	li	a3,0
 4c2:	4641                	li	a2,16
 4c4:	000bb583          	ld	a1,0(s7)
 4c8:	855a                	mv	a0,s6
 4ca:	d7dff0ef          	jal	246 <printint>
        i += 1;
 4ce:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 4d0:	8bca                	mv	s7,s2
      state = 0;
 4d2:	4981                	li	s3,0
        i += 1;
 4d4:	bd99                	j	32a <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 4d6:	008b8d13          	add	s10,s7,8
 4da:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 4de:	03000593          	li	a1,48
 4e2:	855a                	mv	a0,s6
 4e4:	d45ff0ef          	jal	228 <putc>
  putc(fd, 'x');
 4e8:	07800593          	li	a1,120
 4ec:	855a                	mv	a0,s6
 4ee:	d3bff0ef          	jal	228 <putc>
 4f2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4f4:	64800b93          	li	s7,1608
 4f8:	03c9d793          	srl	a5,s3,0x3c
 4fc:	97de                	add	a5,a5,s7
 4fe:	0007c583          	lbu	a1,0(a5)
 502:	855a                	mv	a0,s6
 504:	d25ff0ef          	jal	228 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 508:	0992                	sll	s3,s3,0x4
 50a:	397d                	addw	s2,s2,-1
 50c:	fe0916e3          	bnez	s2,4f8 <vprintf+0x21a>
        printptr(fd, va_arg(ap, uint64));
 510:	8bea                	mv	s7,s10
      state = 0;
 512:	4981                	li	s3,0
 514:	bd19                	j	32a <vprintf+0x4c>
        putc(fd, va_arg(ap, uint32));
 516:	008b8913          	add	s2,s7,8
 51a:	000bc583          	lbu	a1,0(s7)
 51e:	855a                	mv	a0,s6
 520:	d09ff0ef          	jal	228 <putc>
 524:	8bca                	mv	s7,s2
      state = 0;
 526:	4981                	li	s3,0
 528:	b509                	j	32a <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 52a:	008b8993          	add	s3,s7,8
 52e:	000bb903          	ld	s2,0(s7)
 532:	00090f63          	beqz	s2,550 <vprintf+0x272>
        for(; *s; s++)
 536:	00094583          	lbu	a1,0(s2)
 53a:	c195                	beqz	a1,55e <vprintf+0x280>
          putc(fd, *s);
 53c:	855a                	mv	a0,s6
 53e:	cebff0ef          	jal	228 <putc>
        for(; *s; s++)
 542:	0905                	add	s2,s2,1
 544:	00094583          	lbu	a1,0(s2)
 548:	f9f5                	bnez	a1,53c <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 54a:	8bce                	mv	s7,s3
      state = 0;
 54c:	4981                	li	s3,0
 54e:	bbf1                	j	32a <vprintf+0x4c>
          s = "(null)";
 550:	00000917          	auipc	s2,0x0
 554:	0f090913          	add	s2,s2,240 # 640 <printf+0x96>
        for(; *s; s++)
 558:	02800593          	li	a1,40
 55c:	b7c5                	j	53c <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 55e:	8bce                	mv	s7,s3
      state = 0;
 560:	4981                	li	s3,0
 562:	b3e1                	j	32a <vprintf+0x4c>
    }
  }
}
 564:	60e6                	ld	ra,88(sp)
 566:	6446                	ld	s0,80(sp)
 568:	64a6                	ld	s1,72(sp)
 56a:	6906                	ld	s2,64(sp)
 56c:	79e2                	ld	s3,56(sp)
 56e:	7a42                	ld	s4,48(sp)
 570:	7aa2                	ld	s5,40(sp)
 572:	7b02                	ld	s6,32(sp)
 574:	6be2                	ld	s7,24(sp)
 576:	6c42                	ld	s8,16(sp)
 578:	6ca2                	ld	s9,8(sp)
 57a:	6d02                	ld	s10,0(sp)
 57c:	6125                	add	sp,sp,96
 57e:	8082                	ret

0000000000000580 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 580:	715d                	add	sp,sp,-80
 582:	ec06                	sd	ra,24(sp)
 584:	e822                	sd	s0,16(sp)
 586:	1000                	add	s0,sp,32
 588:	e010                	sd	a2,0(s0)
 58a:	e414                	sd	a3,8(s0)
 58c:	e818                	sd	a4,16(s0)
 58e:	ec1c                	sd	a5,24(s0)
 590:	03043023          	sd	a6,32(s0)
 594:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 598:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 59c:	8622                	mv	a2,s0
 59e:	d41ff0ef          	jal	2de <vprintf>
}
 5a2:	60e2                	ld	ra,24(sp)
 5a4:	6442                	ld	s0,16(sp)
 5a6:	6161                	add	sp,sp,80
 5a8:	8082                	ret

00000000000005aa <printf>:

void
printf(const char *fmt, ...)
{
 5aa:	711d                	add	sp,sp,-96
 5ac:	ec06                	sd	ra,24(sp)
 5ae:	e822                	sd	s0,16(sp)
 5b0:	1000                	add	s0,sp,32
 5b2:	e40c                	sd	a1,8(s0)
 5b4:	e810                	sd	a2,16(s0)
 5b6:	ec14                	sd	a3,24(s0)
 5b8:	f018                	sd	a4,32(s0)
 5ba:	f41c                	sd	a5,40(s0)
 5bc:	03043823          	sd	a6,48(s0)
 5c0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 5c4:	00840613          	add	a2,s0,8
 5c8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 5cc:	85aa                	mv	a1,a0
 5ce:	4505                	li	a0,1
 5d0:	d0fff0ef          	jal	2de <vprintf>
 5d4:	60e2                	ld	ra,24(sp)
 5d6:	6442                	ld	s0,16(sp)
 5d8:	6125                	add	sp,sp,96
 5da:	8082                	ret
