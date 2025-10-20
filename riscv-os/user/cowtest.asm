
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
  20:	1f0000ef          	jal	210 <fork>
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
  38:	5fc50513          	add	a0,a0,1532 # 630 <printf+0x36>
  3c:	5be000ef          	jal	5fa <printf>
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
  48:	61c90913          	add	s2,s2,1564 # 660 <printf+0x66>
        int wpid = wait(0);
  4c:	4501                	li	a0,0
  4e:	1ca000ef          	jal	218 <wait>
  52:	85aa                	mv	a1,a0
        if(wpid < 0){
  54:	02054063          	bltz	a0,74 <test_cow+0x66>
            printf("子进程 %d 已退出\n", wpid);
  58:	854a                	mv	a0,s2
  5a:	5a0000ef          	jal	5fa <printf>
    for(int i = 0; i < 40; i++){
  5e:	34fd                	addw	s1,s1,-1
  60:	f4f5                	bnez	s1,4c <test_cow+0x3e>
  62:	a839                	j	80 <test_cow+0x72>
  64:	6789                	lui	a5,0x2
  66:	71078793          	add	a5,a5,1808 # 2710 <digits+0x2078>
            for(int i = 0; i < 10000; i++){
  6a:	37fd                	addw	a5,a5,-1
  6c:	fffd                	bnez	a5,6a <test_cow+0x5c>
            exit(1);
  6e:	4505                	li	a0,1
  70:	198000ef          	jal	208 <exit>
            printf("等待子进程失败\n");
  74:	00000517          	auipc	a0,0x0
  78:	5d450513          	add	a0,a0,1492 # 648 <printf+0x4e>
  7c:	57e000ef          	jal	5fa <printf>
        }
    }

    printf("COW测试成功\n");
  80:	00000517          	auipc	a0,0x0
  84:	5f850513          	add	a0,a0,1528 # 678 <printf+0x7e>
  88:	572000ef          	jal	5fa <printf>
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
  ba:	14e000ef          	jal	208 <exit>

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

00000000000001b8 <atoi>:


int
atoi(const char *s)
{
 1b8:	1141                	add	sp,sp,-16
 1ba:	e422                	sd	s0,8(sp)
 1bc:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1be:	00054683          	lbu	a3,0(a0)
 1c2:	fd06879b          	addw	a5,a3,-48
 1c6:	0ff7f793          	zext.b	a5,a5
 1ca:	4625                	li	a2,9
 1cc:	02f66863          	bltu	a2,a5,1fc <atoi+0x44>
 1d0:	872a                	mv	a4,a0
  n = 0;
 1d2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1d4:	0705                	add	a4,a4,1
 1d6:	0025179b          	sllw	a5,a0,0x2
 1da:	9fa9                	addw	a5,a5,a0
 1dc:	0017979b          	sllw	a5,a5,0x1
 1e0:	9fb5                	addw	a5,a5,a3
 1e2:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1e6:	00074683          	lbu	a3,0(a4)
 1ea:	fd06879b          	addw	a5,a3,-48
 1ee:	0ff7f793          	zext.b	a5,a5
 1f2:	fef671e3          	bgeu	a2,a5,1d4 <atoi+0x1c>
  return n;
 1f6:	6422                	ld	s0,8(sp)
 1f8:	0141                	add	sp,sp,16
 1fa:	8082                	ret
  n = 0;
 1fc:	4501                	li	a0,0
 1fe:	bfe5                	j	1f6 <atoi+0x3e>

0000000000000200 <hello>:
# generated by usys.pl - do not edit
#include "include/syscall.h"
.global hello
hello:
 li a7, SYS_hello
 200:	4885                	li	a7,1
 ecall
 202:	00000073          	ecall
 ret
 206:	8082                	ret

0000000000000208 <exit>:
.global exit
exit:
 li a7, SYS_exit
 208:	4889                	li	a7,2
 ecall
 20a:	00000073          	ecall
 ret
 20e:	8082                	ret

0000000000000210 <fork>:
.global fork
fork:
 li a7, SYS_fork
 210:	4891                	li	a7,4
 ecall
 212:	00000073          	ecall
 ret
 216:	8082                	ret

0000000000000218 <wait>:
.global wait
wait:
 li a7, SYS_wait
 218:	488d                	li	a7,3
 ecall
 21a:	00000073          	ecall
 ret
 21e:	8082                	ret

0000000000000220 <exec>:
.global exec
exec:
 li a7, SYS_exec
 220:	4895                	li	a7,5
 ecall
 222:	00000073          	ecall
 ret
 226:	8082                	ret

0000000000000228 <dup>:
.global dup
dup:
 li a7, SYS_dup
 228:	489d                	li	a7,7
 ecall
 22a:	00000073          	ecall
 ret
 22e:	8082                	ret

0000000000000230 <open>:
.global open
open:
 li a7, SYS_open
 230:	4899                	li	a7,6
 ecall
 232:	00000073          	ecall
 ret
 236:	8082                	ret

0000000000000238 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 238:	48a1                	li	a7,8
 ecall
 23a:	00000073          	ecall
 ret
 23e:	8082                	ret

0000000000000240 <write>:
.global write
write:
 li a7, SYS_write
 240:	48a5                	li	a7,9
 ecall
 242:	00000073          	ecall
 ret
 246:	8082                	ret

0000000000000248 <read>:
.global read
read:
 li a7, SYS_read
 248:	48a9                	li	a7,10
 ecall
 24a:	00000073          	ecall
 ret
 24e:	8082                	ret

0000000000000250 <close>:
.global close
close:
 li a7, SYS_close
 250:	48ad                	li	a7,11
 ecall
 252:	00000073          	ecall
 ret
 256:	8082                	ret

0000000000000258 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 258:	48b1                	li	a7,12
 ecall
 25a:	00000073          	ecall
 ret
 25e:	8082                	ret

0000000000000260 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 260:	48b5                	li	a7,13
 ecall
 262:	00000073          	ecall
 ret
 266:	8082                	ret

0000000000000268 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 268:	48b9                	li	a7,14
 ecall
 26a:	00000073          	ecall
 ret
 26e:	8082                	ret

0000000000000270 <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
 270:	48bd                	li	a7,15
 ecall
 272:	00000073          	ecall
 ret
 276:	8082                	ret

0000000000000278 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 278:	1101                	add	sp,sp,-32
 27a:	ec06                	sd	ra,24(sp)
 27c:	e822                	sd	s0,16(sp)
 27e:	1000                	add	s0,sp,32
 280:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 284:	4605                	li	a2,1
 286:	fef40593          	add	a1,s0,-17
 28a:	fb7ff0ef          	jal	240 <write>
}
 28e:	60e2                	ld	ra,24(sp)
 290:	6442                	ld	s0,16(sp)
 292:	6105                	add	sp,sp,32
 294:	8082                	ret

0000000000000296 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 296:	715d                	add	sp,sp,-80
 298:	e486                	sd	ra,72(sp)
 29a:	e0a2                	sd	s0,64(sp)
 29c:	fc26                	sd	s1,56(sp)
 29e:	f84a                	sd	s2,48(sp)
 2a0:	f44e                	sd	s3,40(sp)
 2a2:	0880                	add	s0,sp,80
 2a4:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 2a6:	c299                	beqz	a3,2ac <printint+0x16>
 2a8:	0605cf63          	bltz	a1,326 <printint+0x90>
  neg = 0;
 2ac:	4881                	li	a7,0
 2ae:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 2b2:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 2b4:	69800513          	li	a0,1688
 2b8:	883e                	mv	a6,a5
 2ba:	2785                	addw	a5,a5,1
 2bc:	02c5f733          	remu	a4,a1,a2
 2c0:	972a                	add	a4,a4,a0
 2c2:	00074703          	lbu	a4,0(a4)
 2c6:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 2ca:	872e                	mv	a4,a1
 2cc:	02c5d5b3          	divu	a1,a1,a2
 2d0:	0685                	add	a3,a3,1
 2d2:	fec773e3          	bgeu	a4,a2,2b8 <printint+0x22>
  if(neg)
 2d6:	00088b63          	beqz	a7,2ec <printint+0x56>
    buf[i++] = '-';
 2da:	fd078793          	add	a5,a5,-48
 2de:	97a2                	add	a5,a5,s0
 2e0:	02d00713          	li	a4,45
 2e4:	fee78423          	sb	a4,-24(a5)
 2e8:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 2ec:	02f05663          	blez	a5,318 <printint+0x82>
 2f0:	fb840713          	add	a4,s0,-72
 2f4:	00f704b3          	add	s1,a4,a5
 2f8:	fff70993          	add	s3,a4,-1
 2fc:	99be                	add	s3,s3,a5
 2fe:	37fd                	addw	a5,a5,-1
 300:	1782                	sll	a5,a5,0x20
 302:	9381                	srl	a5,a5,0x20
 304:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 308:	fff4c583          	lbu	a1,-1(s1)
 30c:	854a                	mv	a0,s2
 30e:	f6bff0ef          	jal	278 <putc>
  while(--i >= 0)
 312:	14fd                	add	s1,s1,-1
 314:	ff349ae3          	bne	s1,s3,308 <printint+0x72>
}
 318:	60a6                	ld	ra,72(sp)
 31a:	6406                	ld	s0,64(sp)
 31c:	74e2                	ld	s1,56(sp)
 31e:	7942                	ld	s2,48(sp)
 320:	79a2                	ld	s3,40(sp)
 322:	6161                	add	sp,sp,80
 324:	8082                	ret
    x = -xx;
 326:	40b005b3          	neg	a1,a1
    neg = 1;
 32a:	4885                	li	a7,1
    x = -xx;
 32c:	b749                	j	2ae <printint+0x18>

000000000000032e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 32e:	711d                	add	sp,sp,-96
 330:	ec86                	sd	ra,88(sp)
 332:	e8a2                	sd	s0,80(sp)
 334:	e4a6                	sd	s1,72(sp)
 336:	e0ca                	sd	s2,64(sp)
 338:	fc4e                	sd	s3,56(sp)
 33a:	f852                	sd	s4,48(sp)
 33c:	f456                	sd	s5,40(sp)
 33e:	f05a                	sd	s6,32(sp)
 340:	ec5e                	sd	s7,24(sp)
 342:	e862                	sd	s8,16(sp)
 344:	e466                	sd	s9,8(sp)
 346:	e06a                	sd	s10,0(sp)
 348:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 34a:	0005c903          	lbu	s2,0(a1)
 34e:	26090363          	beqz	s2,5b4 <vprintf+0x286>
 352:	8b2a                	mv	s6,a0
 354:	8a2e                	mv	s4,a1
 356:	8bb2                	mv	s7,a2
  state = 0;
 358:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 35a:	4481                	li	s1,0
 35c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 35e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 362:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 366:	06c00c93          	li	s9,108
 36a:	a005                	j	38a <vprintf+0x5c>
        putc(fd, c0);
 36c:	85ca                	mv	a1,s2
 36e:	855a                	mv	a0,s6
 370:	f09ff0ef          	jal	278 <putc>
 374:	a019                	j	37a <vprintf+0x4c>
    } else if(state == '%'){
 376:	03598263          	beq	s3,s5,39a <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 37a:	2485                	addw	s1,s1,1
 37c:	8726                	mv	a4,s1
 37e:	009a07b3          	add	a5,s4,s1
 382:	0007c903          	lbu	s2,0(a5)
 386:	22090763          	beqz	s2,5b4 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 38a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 38e:	fe0994e3          	bnez	s3,376 <vprintf+0x48>
      if(c0 == '%'){
 392:	fd579de3          	bne	a5,s5,36c <vprintf+0x3e>
        state = '%';
 396:	89be                	mv	s3,a5
 398:	b7cd                	j	37a <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 39a:	cbc9                	beqz	a5,42c <vprintf+0xfe>
 39c:	00ea06b3          	add	a3,s4,a4
 3a0:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 3a4:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 3a6:	c681                	beqz	a3,3ae <vprintf+0x80>
 3a8:	9752                	add	a4,a4,s4
 3aa:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 3ae:	05878363          	beq	a5,s8,3f4 <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 3b2:	05978d63          	beq	a5,s9,40c <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 3b6:	07500713          	li	a4,117
 3ba:	0ee78763          	beq	a5,a4,4a8 <vprintf+0x17a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 3be:	07800713          	li	a4,120
 3c2:	12e78963          	beq	a5,a4,4f4 <vprintf+0x1c6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 3c6:	07000713          	li	a4,112
 3ca:	14e78e63          	beq	a5,a4,526 <vprintf+0x1f8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 3ce:	06300713          	li	a4,99
 3d2:	18e78a63          	beq	a5,a4,566 <vprintf+0x238>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 3d6:	07300713          	li	a4,115
 3da:	1ae78063          	beq	a5,a4,57a <vprintf+0x24c>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 3de:	02500713          	li	a4,37
 3e2:	04e79563          	bne	a5,a4,42c <vprintf+0xfe>
        putc(fd, '%');
 3e6:	02500593          	li	a1,37
 3ea:	855a                	mv	a0,s6
 3ec:	e8dff0ef          	jal	278 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 3f0:	4981                	li	s3,0
 3f2:	b761                	j	37a <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 3f4:	008b8913          	add	s2,s7,8
 3f8:	4685                	li	a3,1
 3fa:	4629                	li	a2,10
 3fc:	000ba583          	lw	a1,0(s7)
 400:	855a                	mv	a0,s6
 402:	e95ff0ef          	jal	296 <printint>
 406:	8bca                	mv	s7,s2
      state = 0;
 408:	4981                	li	s3,0
 40a:	bf85                	j	37a <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 40c:	06400793          	li	a5,100
 410:	02f68963          	beq	a3,a5,442 <vprintf+0x114>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 414:	06c00793          	li	a5,108
 418:	04f68263          	beq	a3,a5,45c <vprintf+0x12e>
      } else if(c0 == 'l' && c1 == 'u'){
 41c:	07500793          	li	a5,117
 420:	0af68063          	beq	a3,a5,4c0 <vprintf+0x192>
      } else if(c0 == 'l' && c1 == 'x'){
 424:	07800793          	li	a5,120
 428:	0ef68263          	beq	a3,a5,50c <vprintf+0x1de>
        putc(fd, '%');
 42c:	02500593          	li	a1,37
 430:	855a                	mv	a0,s6
 432:	e47ff0ef          	jal	278 <putc>
        putc(fd, c0);
 436:	85ca                	mv	a1,s2
 438:	855a                	mv	a0,s6
 43a:	e3fff0ef          	jal	278 <putc>
      state = 0;
 43e:	4981                	li	s3,0
 440:	bf2d                	j	37a <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 442:	008b8913          	add	s2,s7,8
 446:	4685                	li	a3,1
 448:	4629                	li	a2,10
 44a:	000bb583          	ld	a1,0(s7)
 44e:	855a                	mv	a0,s6
 450:	e47ff0ef          	jal	296 <printint>
        i += 1;
 454:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 456:	8bca                	mv	s7,s2
      state = 0;
 458:	4981                	li	s3,0
        i += 1;
 45a:	b705                	j	37a <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 45c:	06400793          	li	a5,100
 460:	02f60763          	beq	a2,a5,48e <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 464:	07500793          	li	a5,117
 468:	06f60963          	beq	a2,a5,4da <vprintf+0x1ac>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 46c:	07800793          	li	a5,120
 470:	faf61ee3          	bne	a2,a5,42c <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 474:	008b8913          	add	s2,s7,8
 478:	4681                	li	a3,0
 47a:	4641                	li	a2,16
 47c:	000bb583          	ld	a1,0(s7)
 480:	855a                	mv	a0,s6
 482:	e15ff0ef          	jal	296 <printint>
        i += 2;
 486:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 488:	8bca                	mv	s7,s2
      state = 0;
 48a:	4981                	li	s3,0
        i += 2;
 48c:	b5fd                	j	37a <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 48e:	008b8913          	add	s2,s7,8
 492:	4685                	li	a3,1
 494:	4629                	li	a2,10
 496:	000bb583          	ld	a1,0(s7)
 49a:	855a                	mv	a0,s6
 49c:	dfbff0ef          	jal	296 <printint>
        i += 2;
 4a0:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 4a2:	8bca                	mv	s7,s2
      state = 0;
 4a4:	4981                	li	s3,0
        i += 2;
 4a6:	bdd1                	j	37a <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 10, 0);
 4a8:	008b8913          	add	s2,s7,8
 4ac:	4681                	li	a3,0
 4ae:	4629                	li	a2,10
 4b0:	000be583          	lwu	a1,0(s7)
 4b4:	855a                	mv	a0,s6
 4b6:	de1ff0ef          	jal	296 <printint>
 4ba:	8bca                	mv	s7,s2
      state = 0;
 4bc:	4981                	li	s3,0
 4be:	bd75                	j	37a <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4c0:	008b8913          	add	s2,s7,8
 4c4:	4681                	li	a3,0
 4c6:	4629                	li	a2,10
 4c8:	000bb583          	ld	a1,0(s7)
 4cc:	855a                	mv	a0,s6
 4ce:	dc9ff0ef          	jal	296 <printint>
        i += 1;
 4d2:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 4d4:	8bca                	mv	s7,s2
      state = 0;
 4d6:	4981                	li	s3,0
        i += 1;
 4d8:	b54d                	j	37a <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4da:	008b8913          	add	s2,s7,8
 4de:	4681                	li	a3,0
 4e0:	4629                	li	a2,10
 4e2:	000bb583          	ld	a1,0(s7)
 4e6:	855a                	mv	a0,s6
 4e8:	dafff0ef          	jal	296 <printint>
        i += 2;
 4ec:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 4ee:	8bca                	mv	s7,s2
      state = 0;
 4f0:	4981                	li	s3,0
        i += 2;
 4f2:	b561                	j	37a <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 16, 0);
 4f4:	008b8913          	add	s2,s7,8
 4f8:	4681                	li	a3,0
 4fa:	4641                	li	a2,16
 4fc:	000be583          	lwu	a1,0(s7)
 500:	855a                	mv	a0,s6
 502:	d95ff0ef          	jal	296 <printint>
 506:	8bca                	mv	s7,s2
      state = 0;
 508:	4981                	li	s3,0
 50a:	bd85                	j	37a <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 50c:	008b8913          	add	s2,s7,8
 510:	4681                	li	a3,0
 512:	4641                	li	a2,16
 514:	000bb583          	ld	a1,0(s7)
 518:	855a                	mv	a0,s6
 51a:	d7dff0ef          	jal	296 <printint>
        i += 1;
 51e:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 520:	8bca                	mv	s7,s2
      state = 0;
 522:	4981                	li	s3,0
        i += 1;
 524:	bd99                	j	37a <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 526:	008b8d13          	add	s10,s7,8
 52a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 52e:	03000593          	li	a1,48
 532:	855a                	mv	a0,s6
 534:	d45ff0ef          	jal	278 <putc>
  putc(fd, 'x');
 538:	07800593          	li	a1,120
 53c:	855a                	mv	a0,s6
 53e:	d3bff0ef          	jal	278 <putc>
 542:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 544:	69800b93          	li	s7,1688
 548:	03c9d793          	srl	a5,s3,0x3c
 54c:	97de                	add	a5,a5,s7
 54e:	0007c583          	lbu	a1,0(a5)
 552:	855a                	mv	a0,s6
 554:	d25ff0ef          	jal	278 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 558:	0992                	sll	s3,s3,0x4
 55a:	397d                	addw	s2,s2,-1
 55c:	fe0916e3          	bnez	s2,548 <vprintf+0x21a>
        printptr(fd, va_arg(ap, uint64));
 560:	8bea                	mv	s7,s10
      state = 0;
 562:	4981                	li	s3,0
 564:	bd19                	j	37a <vprintf+0x4c>
        putc(fd, va_arg(ap, uint32));
 566:	008b8913          	add	s2,s7,8
 56a:	000bc583          	lbu	a1,0(s7)
 56e:	855a                	mv	a0,s6
 570:	d09ff0ef          	jal	278 <putc>
 574:	8bca                	mv	s7,s2
      state = 0;
 576:	4981                	li	s3,0
 578:	b509                	j	37a <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 57a:	008b8993          	add	s3,s7,8
 57e:	000bb903          	ld	s2,0(s7)
 582:	00090f63          	beqz	s2,5a0 <vprintf+0x272>
        for(; *s; s++)
 586:	00094583          	lbu	a1,0(s2)
 58a:	c195                	beqz	a1,5ae <vprintf+0x280>
          putc(fd, *s);
 58c:	855a                	mv	a0,s6
 58e:	cebff0ef          	jal	278 <putc>
        for(; *s; s++)
 592:	0905                	add	s2,s2,1
 594:	00094583          	lbu	a1,0(s2)
 598:	f9f5                	bnez	a1,58c <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 59a:	8bce                	mv	s7,s3
      state = 0;
 59c:	4981                	li	s3,0
 59e:	bbf1                	j	37a <vprintf+0x4c>
          s = "(null)";
 5a0:	00000917          	auipc	s2,0x0
 5a4:	0f090913          	add	s2,s2,240 # 690 <printf+0x96>
        for(; *s; s++)
 5a8:	02800593          	li	a1,40
 5ac:	b7c5                	j	58c <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 5ae:	8bce                	mv	s7,s3
      state = 0;
 5b0:	4981                	li	s3,0
 5b2:	b3e1                	j	37a <vprintf+0x4c>
    }
  }
}
 5b4:	60e6                	ld	ra,88(sp)
 5b6:	6446                	ld	s0,80(sp)
 5b8:	64a6                	ld	s1,72(sp)
 5ba:	6906                	ld	s2,64(sp)
 5bc:	79e2                	ld	s3,56(sp)
 5be:	7a42                	ld	s4,48(sp)
 5c0:	7aa2                	ld	s5,40(sp)
 5c2:	7b02                	ld	s6,32(sp)
 5c4:	6be2                	ld	s7,24(sp)
 5c6:	6c42                	ld	s8,16(sp)
 5c8:	6ca2                	ld	s9,8(sp)
 5ca:	6d02                	ld	s10,0(sp)
 5cc:	6125                	add	sp,sp,96
 5ce:	8082                	ret

00000000000005d0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5d0:	715d                	add	sp,sp,-80
 5d2:	ec06                	sd	ra,24(sp)
 5d4:	e822                	sd	s0,16(sp)
 5d6:	1000                	add	s0,sp,32
 5d8:	e010                	sd	a2,0(s0)
 5da:	e414                	sd	a3,8(s0)
 5dc:	e818                	sd	a4,16(s0)
 5de:	ec1c                	sd	a5,24(s0)
 5e0:	03043023          	sd	a6,32(s0)
 5e4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 5e8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 5ec:	8622                	mv	a2,s0
 5ee:	d41ff0ef          	jal	32e <vprintf>
}
 5f2:	60e2                	ld	ra,24(sp)
 5f4:	6442                	ld	s0,16(sp)
 5f6:	6161                	add	sp,sp,80
 5f8:	8082                	ret

00000000000005fa <printf>:

void
printf(const char *fmt, ...)
{
 5fa:	711d                	add	sp,sp,-96
 5fc:	ec06                	sd	ra,24(sp)
 5fe:	e822                	sd	s0,16(sp)
 600:	1000                	add	s0,sp,32
 602:	e40c                	sd	a1,8(s0)
 604:	e810                	sd	a2,16(s0)
 606:	ec14                	sd	a3,24(s0)
 608:	f018                	sd	a4,32(s0)
 60a:	f41c                	sd	a5,40(s0)
 60c:	03043823          	sd	a6,48(s0)
 610:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 614:	00840613          	add	a2,s0,8
 618:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 61c:	85aa                	mv	a1,a0
 61e:	4505                	li	a0,1
 620:	d0fff0ef          	jal	32e <vprintf>
 624:	60e2                	ld	ra,24(sp)
 626:	6442                	ld	s0,16(sp)
 628:	6125                	add	sp,sp,96
 62a:	8082                	ret
