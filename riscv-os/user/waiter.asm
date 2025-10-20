
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
   a:	206000ef          	jal	210 <wait>
        if(wpid < 0){
   e:	fe055de3          	bgez	a0,8 <foreverwait+0x8>
            exit(1);
  12:	4505                	li	a0,1
  14:	1ec000ef          	jal	200 <exit>

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
  26:	60e50513          	add	a0,a0,1550 # 630 <printf+0x3e>
  2a:	1fe000ef          	jal	228 <open>
  2e:	00054c63          	bltz	a0,46 <fdinit+0x2e>
        // 如果没有console设备 那么创建一个
        mknod("console", CONSOLE, 0);
        open("console", O_RDWR);
    }
    dup(0); // stdout
  32:	4501                	li	a0,0
  34:	1ec000ef          	jal	220 <dup>
    dup(0); // stderr
  38:	4501                	li	a0,0
  3a:	1e6000ef          	jal	220 <dup>
}
  3e:	60a2                	ld	ra,8(sp)
  40:	6402                	ld	s0,0(sp)
  42:	0141                	add	sp,sp,16
  44:	8082                	ret
        mknod("console", CONSOLE, 0);
  46:	4601                	li	a2,0
  48:	4585                	li	a1,1
  4a:	00000517          	auipc	a0,0x0
  4e:	5e650513          	add	a0,a0,1510 # 630 <printf+0x3e>
  52:	1de000ef          	jal	230 <mknod>
        open("console", O_RDWR);
  56:	4589                	li	a1,2
  58:	00000517          	auipc	a0,0x0
  5c:	5d850513          	add	a0,a0,1496 # 630 <printf+0x3e>
  60:	1c8000ef          	jal	228 <open>
  64:	b7f9                	j	32 <fdinit+0x1a>

0000000000000066 <main>:



int main(){
  66:	7179                	add	sp,sp,-48
  68:	f406                	sd	ra,40(sp)
  6a:	f022                	sd	s0,32(sp)
  6c:	1800                	add	s0,sp,48

    fdinit();
  6e:	fabff0ef          	jal	18 <fdinit>


    int pid = fork();
  72:	196000ef          	jal	208 <fork>
    if(pid == 0){
  76:	e515                	bnez	a0,a2 <main+0x3c>
        exec("prioritytest", (char *[]){"prioritytest", "8", 0});
  78:	00000517          	auipc	a0,0x0
  7c:	5c050513          	add	a0,a0,1472 # 638 <printf+0x46>
  80:	fca43c23          	sd	a0,-40(s0)
  84:	00000797          	auipc	a5,0x0
  88:	5c478793          	add	a5,a5,1476 # 648 <printf+0x56>
  8c:	fef43023          	sd	a5,-32(s0)
  90:	fe043423          	sd	zero,-24(s0)
  94:	fd840593          	add	a1,s0,-40
  98:	180000ef          	jal	218 <exec>
        exit(1);
  9c:	4505                	li	a0,1
  9e:	162000ef          	jal	200 <exit>
    }

    foreverwait();
  a2:	f5fff0ef          	jal	0 <foreverwait>

00000000000000a6 <start>:
#include "include/user.h"


void
start(int argc, char **argv)
{
  a6:	1141                	add	sp,sp,-16
  a8:	e406                	sd	ra,8(sp)
  aa:	e022                	sd	s0,0(sp)
  ac:	0800                	add	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  ae:	fb9ff0ef          	jal	66 <main>


  exit(r);
  b2:	14e000ef          	jal	200 <exit>

00000000000000b6 <itoa>:
{
  char temp[16];
  int i = 0;
  int j = 0;

  if (n == 0) {
  b6:	cd25                	beqz	a0,12e <itoa+0x78>
{
  b8:	1101                	add	sp,sp,-32
  ba:	ec22                	sd	s0,24(sp)
  bc:	1000                	add	s0,sp,32
    buf[1] = '\0';
    return;
  }
  
  // Generate digits in reverse order
  while (n > 0) {
  be:	fe040693          	add	a3,s0,-32
  int i = 0;
  c2:	4701                	li	a4,0
    temp[i++] = (n % 10) + '0';
  c4:	4829                	li	a6,10
  while (n > 0) {
  c6:	48a5                	li	a7,9
    n /= 10;
  }
  temp[i] = '\0';

  // Reverse the string to get the correct order
  for (j = 0; j < i; j++) {
  c8:	4601                	li	a2,0
  while (n > 0) {
  ca:	04a05c63          	blez	a0,122 <itoa+0x6c>
    temp[i++] = (n % 10) + '0';
  ce:	863a                	mv	a2,a4
  d0:	2705                	addw	a4,a4,1
  d2:	030567bb          	remw	a5,a0,a6
  d6:	0307879b          	addw	a5,a5,48
  da:	00f68023          	sb	a5,0(a3)
    n /= 10;
  de:	87aa                	mv	a5,a0
  e0:	0305453b          	divw	a0,a0,a6
  while (n > 0) {
  e4:	0685                	add	a3,a3,1
  e6:	fef8c4e3          	blt	a7,a5,ce <itoa+0x18>
  temp[i] = '\0';
  ea:	ff070793          	add	a5,a4,-16
  ee:	97a2                	add	a5,a5,s0
  f0:	fe078823          	sb	zero,-16(a5)
  for (j = 0; j < i; j++) {
  f4:	04e05463          	blez	a4,13c <itoa+0x86>
  f8:	fe040793          	add	a5,s0,-32
  fc:	00c786b3          	add	a3,a5,a2
 100:	87ae                	mv	a5,a1
    buf[j] = temp[i - 1 - j];
 102:	0006c703          	lbu	a4,0(a3)
 106:	00e78023          	sb	a4,0(a5)
  for (j = 0; j < i; j++) {
 10a:	16fd                	add	a3,a3,-1
 10c:	0785                	add	a5,a5,1
 10e:	40b7873b          	subw	a4,a5,a1
 112:	377d                	addw	a4,a4,-1
 114:	fec747e3          	blt	a4,a2,102 <itoa+0x4c>
 118:	fff64793          	not	a5,a2
 11c:	97fd                	sra	a5,a5,0x3f
 11e:	8e7d                	and	a2,a2,a5
 120:	2605                	addw	a2,a2,1
  }
  buf[j] = '\0';
 122:	95b2                	add	a1,a1,a2
 124:	00058023          	sb	zero,0(a1)
}
 128:	6462                	ld	s0,24(sp)
 12a:	6105                	add	sp,sp,32
 12c:	8082                	ret
    buf[0] = '0';
 12e:	03000793          	li	a5,48
 132:	00f58023          	sb	a5,0(a1)
    buf[1] = '\0';
 136:	000580a3          	sb	zero,1(a1)
    return;
 13a:	8082                	ret
  for (j = 0; j < i; j++) {
 13c:	4601                	li	a2,0
 13e:	b7d5                	j	122 <itoa+0x6c>

0000000000000140 <strcpy>:

void strcpy(char *dst, const char *src) {
 140:	1141                	add	sp,sp,-16
 142:	e422                	sd	s0,8(sp)
 144:	0800                	add	s0,sp,16
    while ((*dst++ = *src++) != '\0');
 146:	0585                	add	a1,a1,1
 148:	0505                	add	a0,a0,1
 14a:	fff5c783          	lbu	a5,-1(a1)
 14e:	fef50fa3          	sb	a5,-1(a0)
 152:	fbf5                	bnez	a5,146 <strcpy+0x6>
} 
 154:	6422                	ld	s0,8(sp)
 156:	0141                	add	sp,sp,16
 158:	8082                	ret

000000000000015a <strlen>:

uint
strlen(const char *s){
 15a:	1141                	add	sp,sp,-16
 15c:	e422                	sd	s0,8(sp)
 15e:	0800                	add	s0,sp,16
  int n;
  for(n = 0; s[n]; n++);
 160:	00054783          	lbu	a5,0(a0)
 164:	cf91                	beqz	a5,180 <strlen+0x26>
 166:	0505                	add	a0,a0,1
 168:	87aa                	mv	a5,a0
 16a:	86be                	mv	a3,a5
 16c:	0785                	add	a5,a5,1
 16e:	fff7c703          	lbu	a4,-1(a5)
 172:	ff65                	bnez	a4,16a <strlen+0x10>
 174:	40a6853b          	subw	a0,a3,a0
 178:	2505                	addw	a0,a0,1
  return n;
}
 17a:	6422                	ld	s0,8(sp)
 17c:	0141                	add	sp,sp,16
 17e:	8082                	ret
  for(n = 0; s[n]; n++);
 180:	4501                	li	a0,0
 182:	bfe5                	j	17a <strlen+0x20>

0000000000000184 <strcmp>:

uint
strcmp(const char *p, const char *q)
{
 184:	1141                	add	sp,sp,-16
 186:	e422                	sd	s0,8(sp)
 188:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 18a:	00054783          	lbu	a5,0(a0)
 18e:	cb91                	beqz	a5,1a2 <strcmp+0x1e>
 190:	0005c703          	lbu	a4,0(a1)
 194:	00f71763          	bne	a4,a5,1a2 <strcmp+0x1e>
    p++, q++;
 198:	0505                	add	a0,a0,1
 19a:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 19c:	00054783          	lbu	a5,0(a0)
 1a0:	fbe5                	bnez	a5,190 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1a2:	0005c503          	lbu	a0,0(a1)
}
 1a6:	40a7853b          	subw	a0,a5,a0
 1aa:	6422                	ld	s0,8(sp)
 1ac:	0141                	add	sp,sp,16
 1ae:	8082                	ret

00000000000001b0 <atoi>:
int
atoi(const char *s)
{
 1b0:	1141                	add	sp,sp,-16
 1b2:	e422                	sd	s0,8(sp)
 1b4:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1b6:	00054683          	lbu	a3,0(a0)
 1ba:	fd06879b          	addw	a5,a3,-48
 1be:	0ff7f793          	zext.b	a5,a5
 1c2:	4625                	li	a2,9
 1c4:	02f66863          	bltu	a2,a5,1f4 <atoi+0x44>
 1c8:	872a                	mv	a4,a0
  n = 0;
 1ca:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1cc:	0705                	add	a4,a4,1
 1ce:	0025179b          	sllw	a5,a0,0x2
 1d2:	9fa9                	addw	a5,a5,a0
 1d4:	0017979b          	sllw	a5,a5,0x1
 1d8:	9fb5                	addw	a5,a5,a3
 1da:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1de:	00074683          	lbu	a3,0(a4)
 1e2:	fd06879b          	addw	a5,a3,-48
 1e6:	0ff7f793          	zext.b	a5,a5
 1ea:	fef671e3          	bgeu	a2,a5,1cc <atoi+0x1c>
  return n;
 1ee:	6422                	ld	s0,8(sp)
 1f0:	0141                	add	sp,sp,16
 1f2:	8082                	ret
  n = 0;
 1f4:	4501                	li	a0,0
 1f6:	bfe5                	j	1ee <atoi+0x3e>

00000000000001f8 <hello>:
# generated by usys.pl - do not edit
#include "include/syscall.h"
.global hello
hello:
 li a7, SYS_hello
 1f8:	4885                	li	a7,1
 ecall
 1fa:	00000073          	ecall
 ret
 1fe:	8082                	ret

0000000000000200 <exit>:
.global exit
exit:
 li a7, SYS_exit
 200:	4889                	li	a7,2
 ecall
 202:	00000073          	ecall
 ret
 206:	8082                	ret

0000000000000208 <fork>:
.global fork
fork:
 li a7, SYS_fork
 208:	4891                	li	a7,4
 ecall
 20a:	00000073          	ecall
 ret
 20e:	8082                	ret

0000000000000210 <wait>:
.global wait
wait:
 li a7, SYS_wait
 210:	488d                	li	a7,3
 ecall
 212:	00000073          	ecall
 ret
 216:	8082                	ret

0000000000000218 <exec>:
.global exec
exec:
 li a7, SYS_exec
 218:	4895                	li	a7,5
 ecall
 21a:	00000073          	ecall
 ret
 21e:	8082                	ret

0000000000000220 <dup>:
.global dup
dup:
 li a7, SYS_dup
 220:	489d                	li	a7,7
 ecall
 222:	00000073          	ecall
 ret
 226:	8082                	ret

0000000000000228 <open>:
.global open
open:
 li a7, SYS_open
 228:	4899                	li	a7,6
 ecall
 22a:	00000073          	ecall
 ret
 22e:	8082                	ret

0000000000000230 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 230:	48a1                	li	a7,8
 ecall
 232:	00000073          	ecall
 ret
 236:	8082                	ret

0000000000000238 <write>:
.global write
write:
 li a7, SYS_write
 238:	48a5                	li	a7,9
 ecall
 23a:	00000073          	ecall
 ret
 23e:	8082                	ret

0000000000000240 <read>:
.global read
read:
 li a7, SYS_read
 240:	48a9                	li	a7,10
 ecall
 242:	00000073          	ecall
 ret
 246:	8082                	ret

0000000000000248 <close>:
.global close
close:
 li a7, SYS_close
 248:	48ad                	li	a7,11
 ecall
 24a:	00000073          	ecall
 ret
 24e:	8082                	ret

0000000000000250 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 250:	48b1                	li	a7,12
 ecall
 252:	00000073          	ecall
 ret
 256:	8082                	ret

0000000000000258 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 258:	48b5                	li	a7,13
 ecall
 25a:	00000073          	ecall
 ret
 25e:	8082                	ret

0000000000000260 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 260:	48b9                	li	a7,14
 ecall
 262:	00000073          	ecall
 ret
 266:	8082                	ret

0000000000000268 <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
 268:	48bd                	li	a7,15
 ecall
 26a:	00000073          	ecall
 ret
 26e:	8082                	ret

0000000000000270 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 270:	1101                	add	sp,sp,-32
 272:	ec06                	sd	ra,24(sp)
 274:	e822                	sd	s0,16(sp)
 276:	1000                	add	s0,sp,32
 278:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 27c:	4605                	li	a2,1
 27e:	fef40593          	add	a1,s0,-17
 282:	fb7ff0ef          	jal	238 <write>
}
 286:	60e2                	ld	ra,24(sp)
 288:	6442                	ld	s0,16(sp)
 28a:	6105                	add	sp,sp,32
 28c:	8082                	ret

000000000000028e <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 28e:	715d                	add	sp,sp,-80
 290:	e486                	sd	ra,72(sp)
 292:	e0a2                	sd	s0,64(sp)
 294:	fc26                	sd	s1,56(sp)
 296:	f84a                	sd	s2,48(sp)
 298:	f44e                	sd	s3,40(sp)
 29a:	0880                	add	s0,sp,80
 29c:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 29e:	c299                	beqz	a3,2a4 <printint+0x16>
 2a0:	0605cf63          	bltz	a1,31e <printint+0x90>
  neg = 0;
 2a4:	4881                	li	a7,0
 2a6:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 2aa:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 2ac:	65800513          	li	a0,1624
 2b0:	883e                	mv	a6,a5
 2b2:	2785                	addw	a5,a5,1
 2b4:	02c5f733          	remu	a4,a1,a2
 2b8:	972a                	add	a4,a4,a0
 2ba:	00074703          	lbu	a4,0(a4)
 2be:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 2c2:	872e                	mv	a4,a1
 2c4:	02c5d5b3          	divu	a1,a1,a2
 2c8:	0685                	add	a3,a3,1
 2ca:	fec773e3          	bgeu	a4,a2,2b0 <printint+0x22>
  if(neg)
 2ce:	00088b63          	beqz	a7,2e4 <printint+0x56>
    buf[i++] = '-';
 2d2:	fd078793          	add	a5,a5,-48
 2d6:	97a2                	add	a5,a5,s0
 2d8:	02d00713          	li	a4,45
 2dc:	fee78423          	sb	a4,-24(a5)
 2e0:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 2e4:	02f05663          	blez	a5,310 <printint+0x82>
 2e8:	fb840713          	add	a4,s0,-72
 2ec:	00f704b3          	add	s1,a4,a5
 2f0:	fff70993          	add	s3,a4,-1
 2f4:	99be                	add	s3,s3,a5
 2f6:	37fd                	addw	a5,a5,-1
 2f8:	1782                	sll	a5,a5,0x20
 2fa:	9381                	srl	a5,a5,0x20
 2fc:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 300:	fff4c583          	lbu	a1,-1(s1)
 304:	854a                	mv	a0,s2
 306:	f6bff0ef          	jal	270 <putc>
  while(--i >= 0)
 30a:	14fd                	add	s1,s1,-1
 30c:	ff349ae3          	bne	s1,s3,300 <printint+0x72>
}
 310:	60a6                	ld	ra,72(sp)
 312:	6406                	ld	s0,64(sp)
 314:	74e2                	ld	s1,56(sp)
 316:	7942                	ld	s2,48(sp)
 318:	79a2                	ld	s3,40(sp)
 31a:	6161                	add	sp,sp,80
 31c:	8082                	ret
    x = -xx;
 31e:	40b005b3          	neg	a1,a1
    neg = 1;
 322:	4885                	li	a7,1
    x = -xx;
 324:	b749                	j	2a6 <printint+0x18>

0000000000000326 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 326:	711d                	add	sp,sp,-96
 328:	ec86                	sd	ra,88(sp)
 32a:	e8a2                	sd	s0,80(sp)
 32c:	e4a6                	sd	s1,72(sp)
 32e:	e0ca                	sd	s2,64(sp)
 330:	fc4e                	sd	s3,56(sp)
 332:	f852                	sd	s4,48(sp)
 334:	f456                	sd	s5,40(sp)
 336:	f05a                	sd	s6,32(sp)
 338:	ec5e                	sd	s7,24(sp)
 33a:	e862                	sd	s8,16(sp)
 33c:	e466                	sd	s9,8(sp)
 33e:	e06a                	sd	s10,0(sp)
 340:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 342:	0005c903          	lbu	s2,0(a1)
 346:	26090363          	beqz	s2,5ac <vprintf+0x286>
 34a:	8b2a                	mv	s6,a0
 34c:	8a2e                	mv	s4,a1
 34e:	8bb2                	mv	s7,a2
  state = 0;
 350:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 352:	4481                	li	s1,0
 354:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 356:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 35a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 35e:	06c00c93          	li	s9,108
 362:	a005                	j	382 <vprintf+0x5c>
        putc(fd, c0);
 364:	85ca                	mv	a1,s2
 366:	855a                	mv	a0,s6
 368:	f09ff0ef          	jal	270 <putc>
 36c:	a019                	j	372 <vprintf+0x4c>
    } else if(state == '%'){
 36e:	03598263          	beq	s3,s5,392 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 372:	2485                	addw	s1,s1,1
 374:	8726                	mv	a4,s1
 376:	009a07b3          	add	a5,s4,s1
 37a:	0007c903          	lbu	s2,0(a5)
 37e:	22090763          	beqz	s2,5ac <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 382:	0009079b          	sext.w	a5,s2
    if(state == 0){
 386:	fe0994e3          	bnez	s3,36e <vprintf+0x48>
      if(c0 == '%'){
 38a:	fd579de3          	bne	a5,s5,364 <vprintf+0x3e>
        state = '%';
 38e:	89be                	mv	s3,a5
 390:	b7cd                	j	372 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 392:	cbc9                	beqz	a5,424 <vprintf+0xfe>
 394:	00ea06b3          	add	a3,s4,a4
 398:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 39c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 39e:	c681                	beqz	a3,3a6 <vprintf+0x80>
 3a0:	9752                	add	a4,a4,s4
 3a2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 3a6:	05878363          	beq	a5,s8,3ec <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 3aa:	05978d63          	beq	a5,s9,404 <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 3ae:	07500713          	li	a4,117
 3b2:	0ee78763          	beq	a5,a4,4a0 <vprintf+0x17a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 3b6:	07800713          	li	a4,120
 3ba:	12e78963          	beq	a5,a4,4ec <vprintf+0x1c6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 3be:	07000713          	li	a4,112
 3c2:	14e78e63          	beq	a5,a4,51e <vprintf+0x1f8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 3c6:	06300713          	li	a4,99
 3ca:	18e78a63          	beq	a5,a4,55e <vprintf+0x238>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 3ce:	07300713          	li	a4,115
 3d2:	1ae78063          	beq	a5,a4,572 <vprintf+0x24c>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 3d6:	02500713          	li	a4,37
 3da:	04e79563          	bne	a5,a4,424 <vprintf+0xfe>
        putc(fd, '%');
 3de:	02500593          	li	a1,37
 3e2:	855a                	mv	a0,s6
 3e4:	e8dff0ef          	jal	270 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 3e8:	4981                	li	s3,0
 3ea:	b761                	j	372 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 3ec:	008b8913          	add	s2,s7,8
 3f0:	4685                	li	a3,1
 3f2:	4629                	li	a2,10
 3f4:	000ba583          	lw	a1,0(s7)
 3f8:	855a                	mv	a0,s6
 3fa:	e95ff0ef          	jal	28e <printint>
 3fe:	8bca                	mv	s7,s2
      state = 0;
 400:	4981                	li	s3,0
 402:	bf85                	j	372 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 404:	06400793          	li	a5,100
 408:	02f68963          	beq	a3,a5,43a <vprintf+0x114>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 40c:	06c00793          	li	a5,108
 410:	04f68263          	beq	a3,a5,454 <vprintf+0x12e>
      } else if(c0 == 'l' && c1 == 'u'){
 414:	07500793          	li	a5,117
 418:	0af68063          	beq	a3,a5,4b8 <vprintf+0x192>
      } else if(c0 == 'l' && c1 == 'x'){
 41c:	07800793          	li	a5,120
 420:	0ef68263          	beq	a3,a5,504 <vprintf+0x1de>
        putc(fd, '%');
 424:	02500593          	li	a1,37
 428:	855a                	mv	a0,s6
 42a:	e47ff0ef          	jal	270 <putc>
        putc(fd, c0);
 42e:	85ca                	mv	a1,s2
 430:	855a                	mv	a0,s6
 432:	e3fff0ef          	jal	270 <putc>
      state = 0;
 436:	4981                	li	s3,0
 438:	bf2d                	j	372 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 43a:	008b8913          	add	s2,s7,8
 43e:	4685                	li	a3,1
 440:	4629                	li	a2,10
 442:	000bb583          	ld	a1,0(s7)
 446:	855a                	mv	a0,s6
 448:	e47ff0ef          	jal	28e <printint>
        i += 1;
 44c:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 44e:	8bca                	mv	s7,s2
      state = 0;
 450:	4981                	li	s3,0
        i += 1;
 452:	b705                	j	372 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 454:	06400793          	li	a5,100
 458:	02f60763          	beq	a2,a5,486 <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 45c:	07500793          	li	a5,117
 460:	06f60963          	beq	a2,a5,4d2 <vprintf+0x1ac>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 464:	07800793          	li	a5,120
 468:	faf61ee3          	bne	a2,a5,424 <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 46c:	008b8913          	add	s2,s7,8
 470:	4681                	li	a3,0
 472:	4641                	li	a2,16
 474:	000bb583          	ld	a1,0(s7)
 478:	855a                	mv	a0,s6
 47a:	e15ff0ef          	jal	28e <printint>
        i += 2;
 47e:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 480:	8bca                	mv	s7,s2
      state = 0;
 482:	4981                	li	s3,0
        i += 2;
 484:	b5fd                	j	372 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 486:	008b8913          	add	s2,s7,8
 48a:	4685                	li	a3,1
 48c:	4629                	li	a2,10
 48e:	000bb583          	ld	a1,0(s7)
 492:	855a                	mv	a0,s6
 494:	dfbff0ef          	jal	28e <printint>
        i += 2;
 498:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 49a:	8bca                	mv	s7,s2
      state = 0;
 49c:	4981                	li	s3,0
        i += 2;
 49e:	bdd1                	j	372 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 10, 0);
 4a0:	008b8913          	add	s2,s7,8
 4a4:	4681                	li	a3,0
 4a6:	4629                	li	a2,10
 4a8:	000be583          	lwu	a1,0(s7)
 4ac:	855a                	mv	a0,s6
 4ae:	de1ff0ef          	jal	28e <printint>
 4b2:	8bca                	mv	s7,s2
      state = 0;
 4b4:	4981                	li	s3,0
 4b6:	bd75                	j	372 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4b8:	008b8913          	add	s2,s7,8
 4bc:	4681                	li	a3,0
 4be:	4629                	li	a2,10
 4c0:	000bb583          	ld	a1,0(s7)
 4c4:	855a                	mv	a0,s6
 4c6:	dc9ff0ef          	jal	28e <printint>
        i += 1;
 4ca:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 4cc:	8bca                	mv	s7,s2
      state = 0;
 4ce:	4981                	li	s3,0
        i += 1;
 4d0:	b54d                	j	372 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4d2:	008b8913          	add	s2,s7,8
 4d6:	4681                	li	a3,0
 4d8:	4629                	li	a2,10
 4da:	000bb583          	ld	a1,0(s7)
 4de:	855a                	mv	a0,s6
 4e0:	dafff0ef          	jal	28e <printint>
        i += 2;
 4e4:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 4e6:	8bca                	mv	s7,s2
      state = 0;
 4e8:	4981                	li	s3,0
        i += 2;
 4ea:	b561                	j	372 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 16, 0);
 4ec:	008b8913          	add	s2,s7,8
 4f0:	4681                	li	a3,0
 4f2:	4641                	li	a2,16
 4f4:	000be583          	lwu	a1,0(s7)
 4f8:	855a                	mv	a0,s6
 4fa:	d95ff0ef          	jal	28e <printint>
 4fe:	8bca                	mv	s7,s2
      state = 0;
 500:	4981                	li	s3,0
 502:	bd85                	j	372 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 504:	008b8913          	add	s2,s7,8
 508:	4681                	li	a3,0
 50a:	4641                	li	a2,16
 50c:	000bb583          	ld	a1,0(s7)
 510:	855a                	mv	a0,s6
 512:	d7dff0ef          	jal	28e <printint>
        i += 1;
 516:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 518:	8bca                	mv	s7,s2
      state = 0;
 51a:	4981                	li	s3,0
        i += 1;
 51c:	bd99                	j	372 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 51e:	008b8d13          	add	s10,s7,8
 522:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 526:	03000593          	li	a1,48
 52a:	855a                	mv	a0,s6
 52c:	d45ff0ef          	jal	270 <putc>
  putc(fd, 'x');
 530:	07800593          	li	a1,120
 534:	855a                	mv	a0,s6
 536:	d3bff0ef          	jal	270 <putc>
 53a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 53c:	65800b93          	li	s7,1624
 540:	03c9d793          	srl	a5,s3,0x3c
 544:	97de                	add	a5,a5,s7
 546:	0007c583          	lbu	a1,0(a5)
 54a:	855a                	mv	a0,s6
 54c:	d25ff0ef          	jal	270 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 550:	0992                	sll	s3,s3,0x4
 552:	397d                	addw	s2,s2,-1
 554:	fe0916e3          	bnez	s2,540 <vprintf+0x21a>
        printptr(fd, va_arg(ap, uint64));
 558:	8bea                	mv	s7,s10
      state = 0;
 55a:	4981                	li	s3,0
 55c:	bd19                	j	372 <vprintf+0x4c>
        putc(fd, va_arg(ap, uint32));
 55e:	008b8913          	add	s2,s7,8
 562:	000bc583          	lbu	a1,0(s7)
 566:	855a                	mv	a0,s6
 568:	d09ff0ef          	jal	270 <putc>
 56c:	8bca                	mv	s7,s2
      state = 0;
 56e:	4981                	li	s3,0
 570:	b509                	j	372 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 572:	008b8993          	add	s3,s7,8
 576:	000bb903          	ld	s2,0(s7)
 57a:	00090f63          	beqz	s2,598 <vprintf+0x272>
        for(; *s; s++)
 57e:	00094583          	lbu	a1,0(s2)
 582:	c195                	beqz	a1,5a6 <vprintf+0x280>
          putc(fd, *s);
 584:	855a                	mv	a0,s6
 586:	cebff0ef          	jal	270 <putc>
        for(; *s; s++)
 58a:	0905                	add	s2,s2,1
 58c:	00094583          	lbu	a1,0(s2)
 590:	f9f5                	bnez	a1,584 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 592:	8bce                	mv	s7,s3
      state = 0;
 594:	4981                	li	s3,0
 596:	bbf1                	j	372 <vprintf+0x4c>
          s = "(null)";
 598:	00000917          	auipc	s2,0x0
 59c:	0b890913          	add	s2,s2,184 # 650 <printf+0x5e>
        for(; *s; s++)
 5a0:	02800593          	li	a1,40
 5a4:	b7c5                	j	584 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 5a6:	8bce                	mv	s7,s3
      state = 0;
 5a8:	4981                	li	s3,0
 5aa:	b3e1                	j	372 <vprintf+0x4c>
    }
  }
}
 5ac:	60e6                	ld	ra,88(sp)
 5ae:	6446                	ld	s0,80(sp)
 5b0:	64a6                	ld	s1,72(sp)
 5b2:	6906                	ld	s2,64(sp)
 5b4:	79e2                	ld	s3,56(sp)
 5b6:	7a42                	ld	s4,48(sp)
 5b8:	7aa2                	ld	s5,40(sp)
 5ba:	7b02                	ld	s6,32(sp)
 5bc:	6be2                	ld	s7,24(sp)
 5be:	6c42                	ld	s8,16(sp)
 5c0:	6ca2                	ld	s9,8(sp)
 5c2:	6d02                	ld	s10,0(sp)
 5c4:	6125                	add	sp,sp,96
 5c6:	8082                	ret

00000000000005c8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5c8:	715d                	add	sp,sp,-80
 5ca:	ec06                	sd	ra,24(sp)
 5cc:	e822                	sd	s0,16(sp)
 5ce:	1000                	add	s0,sp,32
 5d0:	e010                	sd	a2,0(s0)
 5d2:	e414                	sd	a3,8(s0)
 5d4:	e818                	sd	a4,16(s0)
 5d6:	ec1c                	sd	a5,24(s0)
 5d8:	03043023          	sd	a6,32(s0)
 5dc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 5e0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 5e4:	8622                	mv	a2,s0
 5e6:	d41ff0ef          	jal	326 <vprintf>
}
 5ea:	60e2                	ld	ra,24(sp)
 5ec:	6442                	ld	s0,16(sp)
 5ee:	6161                	add	sp,sp,80
 5f0:	8082                	ret

00000000000005f2 <printf>:

void
printf(const char *fmt, ...)
{
 5f2:	711d                	add	sp,sp,-96
 5f4:	ec06                	sd	ra,24(sp)
 5f6:	e822                	sd	s0,16(sp)
 5f8:	1000                	add	s0,sp,32
 5fa:	e40c                	sd	a1,8(s0)
 5fc:	e810                	sd	a2,16(s0)
 5fe:	ec14                	sd	a3,24(s0)
 600:	f018                	sd	a4,32(s0)
 602:	f41c                	sd	a5,40(s0)
 604:	03043823          	sd	a6,48(s0)
 608:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 60c:	00840613          	add	a2,s0,8
 610:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 614:	85aa                	mv	a1,a0
 616:	4505                	li	a0,1
 618:	d0fff0ef          	jal	326 <vprintf>
 61c:	60e2                	ld	ra,24(sp)
 61e:	6442                	ld	s0,16(sp)
 620:	6125                	add	sp,sp,96
 622:	8082                	ret
