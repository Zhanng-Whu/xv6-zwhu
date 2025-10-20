
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
   a:	1fa000ef          	jal	204 <wait>
        if(wpid < 0){
   e:	fe055de3          	bgez	a0,8 <foreverwait+0x8>
            exit(1);
  12:	4505                	li	a0,1
  14:	1e0000ef          	jal	1f4 <exit>

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
  26:	5fe50513          	add	a0,a0,1534 # 620 <printf+0x3a>
  2a:	1f2000ef          	jal	21c <open>
  2e:	00054c63          	bltz	a0,46 <fdinit+0x2e>
        // 如果没有console设备 那么创建一个
        mknod("console", CONSOLE, 0);
        open("console", O_RDWR);
    }
    dup(0); // stdout
  32:	4501                	li	a0,0
  34:	1e0000ef          	jal	214 <dup>
    dup(0); // stderr
  38:	4501                	li	a0,0
  3a:	1da000ef          	jal	214 <dup>
}
  3e:	60a2                	ld	ra,8(sp)
  40:	6402                	ld	s0,0(sp)
  42:	0141                	add	sp,sp,16
  44:	8082                	ret
        mknod("console", CONSOLE, 0);
  46:	4601                	li	a2,0
  48:	4585                	li	a1,1
  4a:	00000517          	auipc	a0,0x0
  4e:	5d650513          	add	a0,a0,1494 # 620 <printf+0x3a>
  52:	1d2000ef          	jal	224 <mknod>
        open("console", O_RDWR);
  56:	4589                	li	a1,2
  58:	00000517          	auipc	a0,0x0
  5c:	5c850513          	add	a0,a0,1480 # 620 <printf+0x3a>
  60:	1bc000ef          	jal	21c <open>
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
  72:	18a000ef          	jal	1fc <fork>
    if(pid == 0){
  76:	e105                	bnez	a0,96 <main+0x30>
        exec("filetest", (char *[]){"filetest", 0});
  78:	00000517          	auipc	a0,0x0
  7c:	5b050513          	add	a0,a0,1456 # 628 <printf+0x42>
  80:	fea43023          	sd	a0,-32(s0)
  84:	fe043423          	sd	zero,-24(s0)
  88:	fe040593          	add	a1,s0,-32
  8c:	180000ef          	jal	20c <exec>
        exit(1);
  90:	4505                	li	a0,1
  92:	162000ef          	jal	1f4 <exit>
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
  a6:	14e000ef          	jal	1f4 <exit>

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

00000000000001a4 <atoi>:
int
atoi(const char *s)
{
 1a4:	1141                	add	sp,sp,-16
 1a6:	e422                	sd	s0,8(sp)
 1a8:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1aa:	00054683          	lbu	a3,0(a0)
 1ae:	fd06879b          	addw	a5,a3,-48
 1b2:	0ff7f793          	zext.b	a5,a5
 1b6:	4625                	li	a2,9
 1b8:	02f66863          	bltu	a2,a5,1e8 <atoi+0x44>
 1bc:	872a                	mv	a4,a0
  n = 0;
 1be:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1c0:	0705                	add	a4,a4,1
 1c2:	0025179b          	sllw	a5,a0,0x2
 1c6:	9fa9                	addw	a5,a5,a0
 1c8:	0017979b          	sllw	a5,a5,0x1
 1cc:	9fb5                	addw	a5,a5,a3
 1ce:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1d2:	00074683          	lbu	a3,0(a4)
 1d6:	fd06879b          	addw	a5,a3,-48
 1da:	0ff7f793          	zext.b	a5,a5
 1de:	fef671e3          	bgeu	a2,a5,1c0 <atoi+0x1c>
  return n;
 1e2:	6422                	ld	s0,8(sp)
 1e4:	0141                	add	sp,sp,16
 1e6:	8082                	ret
  n = 0;
 1e8:	4501                	li	a0,0
 1ea:	bfe5                	j	1e2 <atoi+0x3e>

00000000000001ec <hello>:
# generated by usys.pl - do not edit
#include "include/syscall.h"
.global hello
hello:
 li a7, SYS_hello
 1ec:	4885                	li	a7,1
 ecall
 1ee:	00000073          	ecall
 ret
 1f2:	8082                	ret

00000000000001f4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 1f4:	4889                	li	a7,2
 ecall
 1f6:	00000073          	ecall
 ret
 1fa:	8082                	ret

00000000000001fc <fork>:
.global fork
fork:
 li a7, SYS_fork
 1fc:	4891                	li	a7,4
 ecall
 1fe:	00000073          	ecall
 ret
 202:	8082                	ret

0000000000000204 <wait>:
.global wait
wait:
 li a7, SYS_wait
 204:	488d                	li	a7,3
 ecall
 206:	00000073          	ecall
 ret
 20a:	8082                	ret

000000000000020c <exec>:
.global exec
exec:
 li a7, SYS_exec
 20c:	4895                	li	a7,5
 ecall
 20e:	00000073          	ecall
 ret
 212:	8082                	ret

0000000000000214 <dup>:
.global dup
dup:
 li a7, SYS_dup
 214:	489d                	li	a7,7
 ecall
 216:	00000073          	ecall
 ret
 21a:	8082                	ret

000000000000021c <open>:
.global open
open:
 li a7, SYS_open
 21c:	4899                	li	a7,6
 ecall
 21e:	00000073          	ecall
 ret
 222:	8082                	ret

0000000000000224 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 224:	48a1                	li	a7,8
 ecall
 226:	00000073          	ecall
 ret
 22a:	8082                	ret

000000000000022c <write>:
.global write
write:
 li a7, SYS_write
 22c:	48a5                	li	a7,9
 ecall
 22e:	00000073          	ecall
 ret
 232:	8082                	ret

0000000000000234 <read>:
.global read
read:
 li a7, SYS_read
 234:	48a9                	li	a7,10
 ecall
 236:	00000073          	ecall
 ret
 23a:	8082                	ret

000000000000023c <close>:
.global close
close:
 li a7, SYS_close
 23c:	48ad                	li	a7,11
 ecall
 23e:	00000073          	ecall
 ret
 242:	8082                	ret

0000000000000244 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 244:	48b1                	li	a7,12
 ecall
 246:	00000073          	ecall
 ret
 24a:	8082                	ret

000000000000024c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 24c:	48b5                	li	a7,13
 ecall
 24e:	00000073          	ecall
 ret
 252:	8082                	ret

0000000000000254 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 254:	48b9                	li	a7,14
 ecall
 256:	00000073          	ecall
 ret
 25a:	8082                	ret

000000000000025c <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
 25c:	48bd                	li	a7,15
 ecall
 25e:	00000073          	ecall
 ret
 262:	8082                	ret

0000000000000264 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 264:	1101                	add	sp,sp,-32
 266:	ec06                	sd	ra,24(sp)
 268:	e822                	sd	s0,16(sp)
 26a:	1000                	add	s0,sp,32
 26c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 270:	4605                	li	a2,1
 272:	fef40593          	add	a1,s0,-17
 276:	fb7ff0ef          	jal	22c <write>
}
 27a:	60e2                	ld	ra,24(sp)
 27c:	6442                	ld	s0,16(sp)
 27e:	6105                	add	sp,sp,32
 280:	8082                	ret

0000000000000282 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 282:	715d                	add	sp,sp,-80
 284:	e486                	sd	ra,72(sp)
 286:	e0a2                	sd	s0,64(sp)
 288:	fc26                	sd	s1,56(sp)
 28a:	f84a                	sd	s2,48(sp)
 28c:	f44e                	sd	s3,40(sp)
 28e:	0880                	add	s0,sp,80
 290:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 292:	c299                	beqz	a3,298 <printint+0x16>
 294:	0605cf63          	bltz	a1,312 <printint+0x90>
  neg = 0;
 298:	4881                	li	a7,0
 29a:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 29e:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 2a0:	64000513          	li	a0,1600
 2a4:	883e                	mv	a6,a5
 2a6:	2785                	addw	a5,a5,1
 2a8:	02c5f733          	remu	a4,a1,a2
 2ac:	972a                	add	a4,a4,a0
 2ae:	00074703          	lbu	a4,0(a4)
 2b2:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 2b6:	872e                	mv	a4,a1
 2b8:	02c5d5b3          	divu	a1,a1,a2
 2bc:	0685                	add	a3,a3,1
 2be:	fec773e3          	bgeu	a4,a2,2a4 <printint+0x22>
  if(neg)
 2c2:	00088b63          	beqz	a7,2d8 <printint+0x56>
    buf[i++] = '-';
 2c6:	fd078793          	add	a5,a5,-48
 2ca:	97a2                	add	a5,a5,s0
 2cc:	02d00713          	li	a4,45
 2d0:	fee78423          	sb	a4,-24(a5)
 2d4:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 2d8:	02f05663          	blez	a5,304 <printint+0x82>
 2dc:	fb840713          	add	a4,s0,-72
 2e0:	00f704b3          	add	s1,a4,a5
 2e4:	fff70993          	add	s3,a4,-1
 2e8:	99be                	add	s3,s3,a5
 2ea:	37fd                	addw	a5,a5,-1
 2ec:	1782                	sll	a5,a5,0x20
 2ee:	9381                	srl	a5,a5,0x20
 2f0:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 2f4:	fff4c583          	lbu	a1,-1(s1)
 2f8:	854a                	mv	a0,s2
 2fa:	f6bff0ef          	jal	264 <putc>
  while(--i >= 0)
 2fe:	14fd                	add	s1,s1,-1
 300:	ff349ae3          	bne	s1,s3,2f4 <printint+0x72>
}
 304:	60a6                	ld	ra,72(sp)
 306:	6406                	ld	s0,64(sp)
 308:	74e2                	ld	s1,56(sp)
 30a:	7942                	ld	s2,48(sp)
 30c:	79a2                	ld	s3,40(sp)
 30e:	6161                	add	sp,sp,80
 310:	8082                	ret
    x = -xx;
 312:	40b005b3          	neg	a1,a1
    neg = 1;
 316:	4885                	li	a7,1
    x = -xx;
 318:	b749                	j	29a <printint+0x18>

000000000000031a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 31a:	711d                	add	sp,sp,-96
 31c:	ec86                	sd	ra,88(sp)
 31e:	e8a2                	sd	s0,80(sp)
 320:	e4a6                	sd	s1,72(sp)
 322:	e0ca                	sd	s2,64(sp)
 324:	fc4e                	sd	s3,56(sp)
 326:	f852                	sd	s4,48(sp)
 328:	f456                	sd	s5,40(sp)
 32a:	f05a                	sd	s6,32(sp)
 32c:	ec5e                	sd	s7,24(sp)
 32e:	e862                	sd	s8,16(sp)
 330:	e466                	sd	s9,8(sp)
 332:	e06a                	sd	s10,0(sp)
 334:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 336:	0005c903          	lbu	s2,0(a1)
 33a:	26090363          	beqz	s2,5a0 <vprintf+0x286>
 33e:	8b2a                	mv	s6,a0
 340:	8a2e                	mv	s4,a1
 342:	8bb2                	mv	s7,a2
  state = 0;
 344:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 346:	4481                	li	s1,0
 348:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 34a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 34e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 352:	06c00c93          	li	s9,108
 356:	a005                	j	376 <vprintf+0x5c>
        putc(fd, c0);
 358:	85ca                	mv	a1,s2
 35a:	855a                	mv	a0,s6
 35c:	f09ff0ef          	jal	264 <putc>
 360:	a019                	j	366 <vprintf+0x4c>
    } else if(state == '%'){
 362:	03598263          	beq	s3,s5,386 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 366:	2485                	addw	s1,s1,1
 368:	8726                	mv	a4,s1
 36a:	009a07b3          	add	a5,s4,s1
 36e:	0007c903          	lbu	s2,0(a5)
 372:	22090763          	beqz	s2,5a0 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 376:	0009079b          	sext.w	a5,s2
    if(state == 0){
 37a:	fe0994e3          	bnez	s3,362 <vprintf+0x48>
      if(c0 == '%'){
 37e:	fd579de3          	bne	a5,s5,358 <vprintf+0x3e>
        state = '%';
 382:	89be                	mv	s3,a5
 384:	b7cd                	j	366 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 386:	cbc9                	beqz	a5,418 <vprintf+0xfe>
 388:	00ea06b3          	add	a3,s4,a4
 38c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 390:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 392:	c681                	beqz	a3,39a <vprintf+0x80>
 394:	9752                	add	a4,a4,s4
 396:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 39a:	05878363          	beq	a5,s8,3e0 <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 39e:	05978d63          	beq	a5,s9,3f8 <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 3a2:	07500713          	li	a4,117
 3a6:	0ee78763          	beq	a5,a4,494 <vprintf+0x17a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 3aa:	07800713          	li	a4,120
 3ae:	12e78963          	beq	a5,a4,4e0 <vprintf+0x1c6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 3b2:	07000713          	li	a4,112
 3b6:	14e78e63          	beq	a5,a4,512 <vprintf+0x1f8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 3ba:	06300713          	li	a4,99
 3be:	18e78a63          	beq	a5,a4,552 <vprintf+0x238>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 3c2:	07300713          	li	a4,115
 3c6:	1ae78063          	beq	a5,a4,566 <vprintf+0x24c>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 3ca:	02500713          	li	a4,37
 3ce:	04e79563          	bne	a5,a4,418 <vprintf+0xfe>
        putc(fd, '%');
 3d2:	02500593          	li	a1,37
 3d6:	855a                	mv	a0,s6
 3d8:	e8dff0ef          	jal	264 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 3dc:	4981                	li	s3,0
 3de:	b761                	j	366 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 3e0:	008b8913          	add	s2,s7,8
 3e4:	4685                	li	a3,1
 3e6:	4629                	li	a2,10
 3e8:	000ba583          	lw	a1,0(s7)
 3ec:	855a                	mv	a0,s6
 3ee:	e95ff0ef          	jal	282 <printint>
 3f2:	8bca                	mv	s7,s2
      state = 0;
 3f4:	4981                	li	s3,0
 3f6:	bf85                	j	366 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 3f8:	06400793          	li	a5,100
 3fc:	02f68963          	beq	a3,a5,42e <vprintf+0x114>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 400:	06c00793          	li	a5,108
 404:	04f68263          	beq	a3,a5,448 <vprintf+0x12e>
      } else if(c0 == 'l' && c1 == 'u'){
 408:	07500793          	li	a5,117
 40c:	0af68063          	beq	a3,a5,4ac <vprintf+0x192>
      } else if(c0 == 'l' && c1 == 'x'){
 410:	07800793          	li	a5,120
 414:	0ef68263          	beq	a3,a5,4f8 <vprintf+0x1de>
        putc(fd, '%');
 418:	02500593          	li	a1,37
 41c:	855a                	mv	a0,s6
 41e:	e47ff0ef          	jal	264 <putc>
        putc(fd, c0);
 422:	85ca                	mv	a1,s2
 424:	855a                	mv	a0,s6
 426:	e3fff0ef          	jal	264 <putc>
      state = 0;
 42a:	4981                	li	s3,0
 42c:	bf2d                	j	366 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 42e:	008b8913          	add	s2,s7,8
 432:	4685                	li	a3,1
 434:	4629                	li	a2,10
 436:	000bb583          	ld	a1,0(s7)
 43a:	855a                	mv	a0,s6
 43c:	e47ff0ef          	jal	282 <printint>
        i += 1;
 440:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 442:	8bca                	mv	s7,s2
      state = 0;
 444:	4981                	li	s3,0
        i += 1;
 446:	b705                	j	366 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 448:	06400793          	li	a5,100
 44c:	02f60763          	beq	a2,a5,47a <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 450:	07500793          	li	a5,117
 454:	06f60963          	beq	a2,a5,4c6 <vprintf+0x1ac>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 458:	07800793          	li	a5,120
 45c:	faf61ee3          	bne	a2,a5,418 <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 460:	008b8913          	add	s2,s7,8
 464:	4681                	li	a3,0
 466:	4641                	li	a2,16
 468:	000bb583          	ld	a1,0(s7)
 46c:	855a                	mv	a0,s6
 46e:	e15ff0ef          	jal	282 <printint>
        i += 2;
 472:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 474:	8bca                	mv	s7,s2
      state = 0;
 476:	4981                	li	s3,0
        i += 2;
 478:	b5fd                	j	366 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 47a:	008b8913          	add	s2,s7,8
 47e:	4685                	li	a3,1
 480:	4629                	li	a2,10
 482:	000bb583          	ld	a1,0(s7)
 486:	855a                	mv	a0,s6
 488:	dfbff0ef          	jal	282 <printint>
        i += 2;
 48c:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 48e:	8bca                	mv	s7,s2
      state = 0;
 490:	4981                	li	s3,0
        i += 2;
 492:	bdd1                	j	366 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 10, 0);
 494:	008b8913          	add	s2,s7,8
 498:	4681                	li	a3,0
 49a:	4629                	li	a2,10
 49c:	000be583          	lwu	a1,0(s7)
 4a0:	855a                	mv	a0,s6
 4a2:	de1ff0ef          	jal	282 <printint>
 4a6:	8bca                	mv	s7,s2
      state = 0;
 4a8:	4981                	li	s3,0
 4aa:	bd75                	j	366 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4ac:	008b8913          	add	s2,s7,8
 4b0:	4681                	li	a3,0
 4b2:	4629                	li	a2,10
 4b4:	000bb583          	ld	a1,0(s7)
 4b8:	855a                	mv	a0,s6
 4ba:	dc9ff0ef          	jal	282 <printint>
        i += 1;
 4be:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 4c0:	8bca                	mv	s7,s2
      state = 0;
 4c2:	4981                	li	s3,0
        i += 1;
 4c4:	b54d                	j	366 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4c6:	008b8913          	add	s2,s7,8
 4ca:	4681                	li	a3,0
 4cc:	4629                	li	a2,10
 4ce:	000bb583          	ld	a1,0(s7)
 4d2:	855a                	mv	a0,s6
 4d4:	dafff0ef          	jal	282 <printint>
        i += 2;
 4d8:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 4da:	8bca                	mv	s7,s2
      state = 0;
 4dc:	4981                	li	s3,0
        i += 2;
 4de:	b561                	j	366 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 16, 0);
 4e0:	008b8913          	add	s2,s7,8
 4e4:	4681                	li	a3,0
 4e6:	4641                	li	a2,16
 4e8:	000be583          	lwu	a1,0(s7)
 4ec:	855a                	mv	a0,s6
 4ee:	d95ff0ef          	jal	282 <printint>
 4f2:	8bca                	mv	s7,s2
      state = 0;
 4f4:	4981                	li	s3,0
 4f6:	bd85                	j	366 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 4f8:	008b8913          	add	s2,s7,8
 4fc:	4681                	li	a3,0
 4fe:	4641                	li	a2,16
 500:	000bb583          	ld	a1,0(s7)
 504:	855a                	mv	a0,s6
 506:	d7dff0ef          	jal	282 <printint>
        i += 1;
 50a:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 50c:	8bca                	mv	s7,s2
      state = 0;
 50e:	4981                	li	s3,0
        i += 1;
 510:	bd99                	j	366 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 512:	008b8d13          	add	s10,s7,8
 516:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 51a:	03000593          	li	a1,48
 51e:	855a                	mv	a0,s6
 520:	d45ff0ef          	jal	264 <putc>
  putc(fd, 'x');
 524:	07800593          	li	a1,120
 528:	855a                	mv	a0,s6
 52a:	d3bff0ef          	jal	264 <putc>
 52e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 530:	64000b93          	li	s7,1600
 534:	03c9d793          	srl	a5,s3,0x3c
 538:	97de                	add	a5,a5,s7
 53a:	0007c583          	lbu	a1,0(a5)
 53e:	855a                	mv	a0,s6
 540:	d25ff0ef          	jal	264 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 544:	0992                	sll	s3,s3,0x4
 546:	397d                	addw	s2,s2,-1
 548:	fe0916e3          	bnez	s2,534 <vprintf+0x21a>
        printptr(fd, va_arg(ap, uint64));
 54c:	8bea                	mv	s7,s10
      state = 0;
 54e:	4981                	li	s3,0
 550:	bd19                	j	366 <vprintf+0x4c>
        putc(fd, va_arg(ap, uint32));
 552:	008b8913          	add	s2,s7,8
 556:	000bc583          	lbu	a1,0(s7)
 55a:	855a                	mv	a0,s6
 55c:	d09ff0ef          	jal	264 <putc>
 560:	8bca                	mv	s7,s2
      state = 0;
 562:	4981                	li	s3,0
 564:	b509                	j	366 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 566:	008b8993          	add	s3,s7,8
 56a:	000bb903          	ld	s2,0(s7)
 56e:	00090f63          	beqz	s2,58c <vprintf+0x272>
        for(; *s; s++)
 572:	00094583          	lbu	a1,0(s2)
 576:	c195                	beqz	a1,59a <vprintf+0x280>
          putc(fd, *s);
 578:	855a                	mv	a0,s6
 57a:	cebff0ef          	jal	264 <putc>
        for(; *s; s++)
 57e:	0905                	add	s2,s2,1
 580:	00094583          	lbu	a1,0(s2)
 584:	f9f5                	bnez	a1,578 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 586:	8bce                	mv	s7,s3
      state = 0;
 588:	4981                	li	s3,0
 58a:	bbf1                	j	366 <vprintf+0x4c>
          s = "(null)";
 58c:	00000917          	auipc	s2,0x0
 590:	0ac90913          	add	s2,s2,172 # 638 <printf+0x52>
        for(; *s; s++)
 594:	02800593          	li	a1,40
 598:	b7c5                	j	578 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 59a:	8bce                	mv	s7,s3
      state = 0;
 59c:	4981                	li	s3,0
 59e:	b3e1                	j	366 <vprintf+0x4c>
    }
  }
}
 5a0:	60e6                	ld	ra,88(sp)
 5a2:	6446                	ld	s0,80(sp)
 5a4:	64a6                	ld	s1,72(sp)
 5a6:	6906                	ld	s2,64(sp)
 5a8:	79e2                	ld	s3,56(sp)
 5aa:	7a42                	ld	s4,48(sp)
 5ac:	7aa2                	ld	s5,40(sp)
 5ae:	7b02                	ld	s6,32(sp)
 5b0:	6be2                	ld	s7,24(sp)
 5b2:	6c42                	ld	s8,16(sp)
 5b4:	6ca2                	ld	s9,8(sp)
 5b6:	6d02                	ld	s10,0(sp)
 5b8:	6125                	add	sp,sp,96
 5ba:	8082                	ret

00000000000005bc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5bc:	715d                	add	sp,sp,-80
 5be:	ec06                	sd	ra,24(sp)
 5c0:	e822                	sd	s0,16(sp)
 5c2:	1000                	add	s0,sp,32
 5c4:	e010                	sd	a2,0(s0)
 5c6:	e414                	sd	a3,8(s0)
 5c8:	e818                	sd	a4,16(s0)
 5ca:	ec1c                	sd	a5,24(s0)
 5cc:	03043023          	sd	a6,32(s0)
 5d0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 5d4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 5d8:	8622                	mv	a2,s0
 5da:	d41ff0ef          	jal	31a <vprintf>
}
 5de:	60e2                	ld	ra,24(sp)
 5e0:	6442                	ld	s0,16(sp)
 5e2:	6161                	add	sp,sp,80
 5e4:	8082                	ret

00000000000005e6 <printf>:

void
printf(const char *fmt, ...)
{
 5e6:	711d                	add	sp,sp,-96
 5e8:	ec06                	sd	ra,24(sp)
 5ea:	e822                	sd	s0,16(sp)
 5ec:	1000                	add	s0,sp,32
 5ee:	e40c                	sd	a1,8(s0)
 5f0:	e810                	sd	a2,16(s0)
 5f2:	ec14                	sd	a3,24(s0)
 5f4:	f018                	sd	a4,32(s0)
 5f6:	f41c                	sd	a5,40(s0)
 5f8:	03043823          	sd	a6,48(s0)
 5fc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 600:	00840613          	add	a2,s0,8
 604:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 608:	85aa                	mv	a1,a0
 60a:	4505                	li	a0,1
 60c:	d0fff0ef          	jal	31a <vprintf>
 610:	60e2                	ld	ra,24(sp)
 612:	6442                	ld	s0,16(sp)
 614:	6125                	add	sp,sp,96
 616:	8082                	ret
