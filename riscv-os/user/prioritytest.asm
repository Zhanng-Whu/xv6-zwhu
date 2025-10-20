
user/_prioritytest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "include/fcntl.h"
#include "include/user.h"


int main(int argc, char const *argv[])
{
   0:	1101                	add	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	add	s0,sp,32
    int forknumber=atoi(argv[1]);
   c:	6588                	ld	a0,8(a1)
   e:	180000ef          	jal	18e <atoi>
    int status;

    for(int i=0;i<forknumber;i++)
  12:	06a05263          	blez	a0,76 <main+0x76>
  16:	892a                	mv	s2,a0
  18:	4481                	li	s1,0
  1a:	a839                	j	38 <main+0x38>
    {
        status=fork();
        if(status)
		{
	    	set_priority(status, i%4+1);   //在父进程中，将每个子进程的优先级设置为i%4+1.
  1c:	41f4d79b          	sraw	a5,s1,0x1f
  20:	01e7d79b          	srlw	a5,a5,0x1e
  24:	009785bb          	addw	a1,a5,s1
  28:	898d                	and	a1,a1,3
  2a:	9d9d                	subw	a1,a1,a5
  2c:	2585                	addw	a1,a1,1
  2e:	218000ef          	jal	246 <set_priority>
    for(int i=0;i<forknumber;i++)
  32:	2485                	addw	s1,s1,1
  34:	04990163          	beq	s2,s1,76 <main+0x76>
        status=fork();
  38:	1ae000ef          	jal	1e6 <fork>
        if(status)
  3c:	f165                	bnez	a0,1c <main+0x1c>
  3e:	02800593          	li	a1,40
    for(int i=0;i<forknumber;i++)
  42:	6789                	lui	a5,0x2
  44:	71078613          	add	a2,a5,1808 # 2710 <digits+0x20c8>
  48:	6685                	lui	a3,0x1
  4a:	38868693          	add	a3,a3,904 # 1388 <digits+0xd40>
  4e:	8732                	mv	a4,a2
  50:	87b6                	mv	a5,a3
        }
        if(status==0){
	    	for(int count=0;count<40; count++){
		    	for(int k=0;k<10000;k++){
					int result=0;
					for( int j=0; j<5000; j++){
  52:	37fd                	addw	a5,a5,-1
  54:	fffd                	bnez	a5,52 <main+0x52>
		    	for(int k=0;k<10000;k++){
  56:	377d                	addw	a4,a4,-1
  58:	ff65                	bnez	a4,50 <main+0x50>
	    	for(int count=0;count<40; count++){
  5a:	35fd                	addw	a1,a1,-1
  5c:	f9ed                	bnez	a1,4e <main+0x4e>
                        result=result*j;
                        result = result+result/j;
					}
		   		}
            }
            printf("进程 %d 完成任务，准备退出。\n", getpid());
  5e:	1d0000ef          	jal	22e <getpid>
  62:	85aa                	mv	a1,a0
  64:	00000517          	auipc	a0,0x0
  68:	5ac50513          	add	a0,a0,1452 # 610 <printf+0x40>
  6c:	564000ef          	jal	5d0 <printf>
            exit(1);
  70:	4505                	li	a0,1
  72:	16c000ef          	jal	1de <exit>
        }
    }
    return 0;
  76:	4501                	li	a0,0
  78:	60e2                	ld	ra,24(sp)
  7a:	6442                	ld	s0,16(sp)
  7c:	64a2                	ld	s1,8(sp)
  7e:	6902                	ld	s2,0(sp)
  80:	6105                	add	sp,sp,32
  82:	8082                	ret

0000000000000084 <start>:
#include "include/user.h"


void
start(int argc, char **argv)
{
  84:	1141                	add	sp,sp,-16
  86:	e406                	sd	ra,8(sp)
  88:	e022                	sd	s0,0(sp)
  8a:	0800                	add	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  8c:	f75ff0ef          	jal	0 <main>


  exit(r);
  90:	14e000ef          	jal	1de <exit>

0000000000000094 <itoa>:
{
  char temp[16];
  int i = 0;
  int j = 0;

  if (n == 0) {
  94:	cd25                	beqz	a0,10c <itoa+0x78>
{
  96:	1101                	add	sp,sp,-32
  98:	ec22                	sd	s0,24(sp)
  9a:	1000                	add	s0,sp,32
    buf[1] = '\0';
    return;
  }
  
  // Generate digits in reverse order
  while (n > 0) {
  9c:	fe040693          	add	a3,s0,-32
  int i = 0;
  a0:	4701                	li	a4,0
    temp[i++] = (n % 10) + '0';
  a2:	4829                	li	a6,10
  while (n > 0) {
  a4:	48a5                	li	a7,9
    n /= 10;
  }
  temp[i] = '\0';

  // Reverse the string to get the correct order
  for (j = 0; j < i; j++) {
  a6:	4601                	li	a2,0
  while (n > 0) {
  a8:	04a05c63          	blez	a0,100 <itoa+0x6c>
    temp[i++] = (n % 10) + '0';
  ac:	863a                	mv	a2,a4
  ae:	2705                	addw	a4,a4,1
  b0:	030567bb          	remw	a5,a0,a6
  b4:	0307879b          	addw	a5,a5,48
  b8:	00f68023          	sb	a5,0(a3)
    n /= 10;
  bc:	87aa                	mv	a5,a0
  be:	0305453b          	divw	a0,a0,a6
  while (n > 0) {
  c2:	0685                	add	a3,a3,1
  c4:	fef8c4e3          	blt	a7,a5,ac <itoa+0x18>
  temp[i] = '\0';
  c8:	ff070793          	add	a5,a4,-16
  cc:	97a2                	add	a5,a5,s0
  ce:	fe078823          	sb	zero,-16(a5)
  for (j = 0; j < i; j++) {
  d2:	04e05463          	blez	a4,11a <itoa+0x86>
  d6:	fe040793          	add	a5,s0,-32
  da:	00c786b3          	add	a3,a5,a2
  de:	87ae                	mv	a5,a1
    buf[j] = temp[i - 1 - j];
  e0:	0006c703          	lbu	a4,0(a3)
  e4:	00e78023          	sb	a4,0(a5)
  for (j = 0; j < i; j++) {
  e8:	16fd                	add	a3,a3,-1
  ea:	0785                	add	a5,a5,1
  ec:	40b7873b          	subw	a4,a5,a1
  f0:	377d                	addw	a4,a4,-1
  f2:	fec747e3          	blt	a4,a2,e0 <itoa+0x4c>
  f6:	fff64793          	not	a5,a2
  fa:	97fd                	sra	a5,a5,0x3f
  fc:	8e7d                	and	a2,a2,a5
  fe:	2605                	addw	a2,a2,1
  }
  buf[j] = '\0';
 100:	95b2                	add	a1,a1,a2
 102:	00058023          	sb	zero,0(a1)
}
 106:	6462                	ld	s0,24(sp)
 108:	6105                	add	sp,sp,32
 10a:	8082                	ret
    buf[0] = '0';
 10c:	03000793          	li	a5,48
 110:	00f58023          	sb	a5,0(a1)
    buf[1] = '\0';
 114:	000580a3          	sb	zero,1(a1)
    return;
 118:	8082                	ret
  for (j = 0; j < i; j++) {
 11a:	4601                	li	a2,0
 11c:	b7d5                	j	100 <itoa+0x6c>

000000000000011e <strcpy>:

void strcpy(char *dst, const char *src) {
 11e:	1141                	add	sp,sp,-16
 120:	e422                	sd	s0,8(sp)
 122:	0800                	add	s0,sp,16
    while ((*dst++ = *src++) != '\0');
 124:	0585                	add	a1,a1,1
 126:	0505                	add	a0,a0,1
 128:	fff5c783          	lbu	a5,-1(a1)
 12c:	fef50fa3          	sb	a5,-1(a0)
 130:	fbf5                	bnez	a5,124 <strcpy+0x6>
} 
 132:	6422                	ld	s0,8(sp)
 134:	0141                	add	sp,sp,16
 136:	8082                	ret

0000000000000138 <strlen>:

uint
strlen(const char *s){
 138:	1141                	add	sp,sp,-16
 13a:	e422                	sd	s0,8(sp)
 13c:	0800                	add	s0,sp,16
  int n;
  for(n = 0; s[n]; n++);
 13e:	00054783          	lbu	a5,0(a0)
 142:	cf91                	beqz	a5,15e <strlen+0x26>
 144:	0505                	add	a0,a0,1
 146:	87aa                	mv	a5,a0
 148:	86be                	mv	a3,a5
 14a:	0785                	add	a5,a5,1
 14c:	fff7c703          	lbu	a4,-1(a5)
 150:	ff65                	bnez	a4,148 <strlen+0x10>
 152:	40a6853b          	subw	a0,a3,a0
 156:	2505                	addw	a0,a0,1
  return n;
}
 158:	6422                	ld	s0,8(sp)
 15a:	0141                	add	sp,sp,16
 15c:	8082                	ret
  for(n = 0; s[n]; n++);
 15e:	4501                	li	a0,0
 160:	bfe5                	j	158 <strlen+0x20>

0000000000000162 <strcmp>:

uint
strcmp(const char *p, const char *q)
{
 162:	1141                	add	sp,sp,-16
 164:	e422                	sd	s0,8(sp)
 166:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 168:	00054783          	lbu	a5,0(a0)
 16c:	cb91                	beqz	a5,180 <strcmp+0x1e>
 16e:	0005c703          	lbu	a4,0(a1)
 172:	00f71763          	bne	a4,a5,180 <strcmp+0x1e>
    p++, q++;
 176:	0505                	add	a0,a0,1
 178:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 17a:	00054783          	lbu	a5,0(a0)
 17e:	fbe5                	bnez	a5,16e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 180:	0005c503          	lbu	a0,0(a1)
}
 184:	40a7853b          	subw	a0,a5,a0
 188:	6422                	ld	s0,8(sp)
 18a:	0141                	add	sp,sp,16
 18c:	8082                	ret

000000000000018e <atoi>:
int
atoi(const char *s)
{
 18e:	1141                	add	sp,sp,-16
 190:	e422                	sd	s0,8(sp)
 192:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 194:	00054683          	lbu	a3,0(a0)
 198:	fd06879b          	addw	a5,a3,-48
 19c:	0ff7f793          	zext.b	a5,a5
 1a0:	4625                	li	a2,9
 1a2:	02f66863          	bltu	a2,a5,1d2 <atoi+0x44>
 1a6:	872a                	mv	a4,a0
  n = 0;
 1a8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1aa:	0705                	add	a4,a4,1
 1ac:	0025179b          	sllw	a5,a0,0x2
 1b0:	9fa9                	addw	a5,a5,a0
 1b2:	0017979b          	sllw	a5,a5,0x1
 1b6:	9fb5                	addw	a5,a5,a3
 1b8:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1bc:	00074683          	lbu	a3,0(a4)
 1c0:	fd06879b          	addw	a5,a3,-48
 1c4:	0ff7f793          	zext.b	a5,a5
 1c8:	fef671e3          	bgeu	a2,a5,1aa <atoi+0x1c>
  return n;
 1cc:	6422                	ld	s0,8(sp)
 1ce:	0141                	add	sp,sp,16
 1d0:	8082                	ret
  n = 0;
 1d2:	4501                	li	a0,0
 1d4:	bfe5                	j	1cc <atoi+0x3e>

00000000000001d6 <hello>:
# generated by usys.pl - do not edit
#include "include/syscall.h"
.global hello
hello:
 li a7, SYS_hello
 1d6:	4885                	li	a7,1
 ecall
 1d8:	00000073          	ecall
 ret
 1dc:	8082                	ret

00000000000001de <exit>:
.global exit
exit:
 li a7, SYS_exit
 1de:	4889                	li	a7,2
 ecall
 1e0:	00000073          	ecall
 ret
 1e4:	8082                	ret

00000000000001e6 <fork>:
.global fork
fork:
 li a7, SYS_fork
 1e6:	4891                	li	a7,4
 ecall
 1e8:	00000073          	ecall
 ret
 1ec:	8082                	ret

00000000000001ee <wait>:
.global wait
wait:
 li a7, SYS_wait
 1ee:	488d                	li	a7,3
 ecall
 1f0:	00000073          	ecall
 ret
 1f4:	8082                	ret

00000000000001f6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 1f6:	4895                	li	a7,5
 ecall
 1f8:	00000073          	ecall
 ret
 1fc:	8082                	ret

00000000000001fe <dup>:
.global dup
dup:
 li a7, SYS_dup
 1fe:	489d                	li	a7,7
 ecall
 200:	00000073          	ecall
 ret
 204:	8082                	ret

0000000000000206 <open>:
.global open
open:
 li a7, SYS_open
 206:	4899                	li	a7,6
 ecall
 208:	00000073          	ecall
 ret
 20c:	8082                	ret

000000000000020e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 20e:	48a1                	li	a7,8
 ecall
 210:	00000073          	ecall
 ret
 214:	8082                	ret

0000000000000216 <write>:
.global write
write:
 li a7, SYS_write
 216:	48a5                	li	a7,9
 ecall
 218:	00000073          	ecall
 ret
 21c:	8082                	ret

000000000000021e <read>:
.global read
read:
 li a7, SYS_read
 21e:	48a9                	li	a7,10
 ecall
 220:	00000073          	ecall
 ret
 224:	8082                	ret

0000000000000226 <close>:
.global close
close:
 li a7, SYS_close
 226:	48ad                	li	a7,11
 ecall
 228:	00000073          	ecall
 ret
 22c:	8082                	ret

000000000000022e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 22e:	48b1                	li	a7,12
 ecall
 230:	00000073          	ecall
 ret
 234:	8082                	ret

0000000000000236 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 236:	48b5                	li	a7,13
 ecall
 238:	00000073          	ecall
 ret
 23c:	8082                	ret

000000000000023e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 23e:	48b9                	li	a7,14
 ecall
 240:	00000073          	ecall
 ret
 244:	8082                	ret

0000000000000246 <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
 246:	48bd                	li	a7,15
 ecall
 248:	00000073          	ecall
 ret
 24c:	8082                	ret

000000000000024e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 24e:	1101                	add	sp,sp,-32
 250:	ec06                	sd	ra,24(sp)
 252:	e822                	sd	s0,16(sp)
 254:	1000                	add	s0,sp,32
 256:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 25a:	4605                	li	a2,1
 25c:	fef40593          	add	a1,s0,-17
 260:	fb7ff0ef          	jal	216 <write>
}
 264:	60e2                	ld	ra,24(sp)
 266:	6442                	ld	s0,16(sp)
 268:	6105                	add	sp,sp,32
 26a:	8082                	ret

000000000000026c <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 26c:	715d                	add	sp,sp,-80
 26e:	e486                	sd	ra,72(sp)
 270:	e0a2                	sd	s0,64(sp)
 272:	fc26                	sd	s1,56(sp)
 274:	f84a                	sd	s2,48(sp)
 276:	f44e                	sd	s3,40(sp)
 278:	0880                	add	s0,sp,80
 27a:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 27c:	c299                	beqz	a3,282 <printint+0x16>
 27e:	0605cf63          	bltz	a1,2fc <printint+0x90>
  neg = 0;
 282:	4881                	li	a7,0
 284:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 288:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 28a:	64800513          	li	a0,1608
 28e:	883e                	mv	a6,a5
 290:	2785                	addw	a5,a5,1
 292:	02c5f733          	remu	a4,a1,a2
 296:	972a                	add	a4,a4,a0
 298:	00074703          	lbu	a4,0(a4)
 29c:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 2a0:	872e                	mv	a4,a1
 2a2:	02c5d5b3          	divu	a1,a1,a2
 2a6:	0685                	add	a3,a3,1
 2a8:	fec773e3          	bgeu	a4,a2,28e <printint+0x22>
  if(neg)
 2ac:	00088b63          	beqz	a7,2c2 <printint+0x56>
    buf[i++] = '-';
 2b0:	fd078793          	add	a5,a5,-48
 2b4:	97a2                	add	a5,a5,s0
 2b6:	02d00713          	li	a4,45
 2ba:	fee78423          	sb	a4,-24(a5)
 2be:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 2c2:	02f05663          	blez	a5,2ee <printint+0x82>
 2c6:	fb840713          	add	a4,s0,-72
 2ca:	00f704b3          	add	s1,a4,a5
 2ce:	fff70993          	add	s3,a4,-1
 2d2:	99be                	add	s3,s3,a5
 2d4:	37fd                	addw	a5,a5,-1
 2d6:	1782                	sll	a5,a5,0x20
 2d8:	9381                	srl	a5,a5,0x20
 2da:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 2de:	fff4c583          	lbu	a1,-1(s1)
 2e2:	854a                	mv	a0,s2
 2e4:	f6bff0ef          	jal	24e <putc>
  while(--i >= 0)
 2e8:	14fd                	add	s1,s1,-1
 2ea:	ff349ae3          	bne	s1,s3,2de <printint+0x72>
}
 2ee:	60a6                	ld	ra,72(sp)
 2f0:	6406                	ld	s0,64(sp)
 2f2:	74e2                	ld	s1,56(sp)
 2f4:	7942                	ld	s2,48(sp)
 2f6:	79a2                	ld	s3,40(sp)
 2f8:	6161                	add	sp,sp,80
 2fa:	8082                	ret
    x = -xx;
 2fc:	40b005b3          	neg	a1,a1
    neg = 1;
 300:	4885                	li	a7,1
    x = -xx;
 302:	b749                	j	284 <printint+0x18>

0000000000000304 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 304:	711d                	add	sp,sp,-96
 306:	ec86                	sd	ra,88(sp)
 308:	e8a2                	sd	s0,80(sp)
 30a:	e4a6                	sd	s1,72(sp)
 30c:	e0ca                	sd	s2,64(sp)
 30e:	fc4e                	sd	s3,56(sp)
 310:	f852                	sd	s4,48(sp)
 312:	f456                	sd	s5,40(sp)
 314:	f05a                	sd	s6,32(sp)
 316:	ec5e                	sd	s7,24(sp)
 318:	e862                	sd	s8,16(sp)
 31a:	e466                	sd	s9,8(sp)
 31c:	e06a                	sd	s10,0(sp)
 31e:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 320:	0005c903          	lbu	s2,0(a1)
 324:	26090363          	beqz	s2,58a <vprintf+0x286>
 328:	8b2a                	mv	s6,a0
 32a:	8a2e                	mv	s4,a1
 32c:	8bb2                	mv	s7,a2
  state = 0;
 32e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 330:	4481                	li	s1,0
 332:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 334:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 338:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 33c:	06c00c93          	li	s9,108
 340:	a005                	j	360 <vprintf+0x5c>
        putc(fd, c0);
 342:	85ca                	mv	a1,s2
 344:	855a                	mv	a0,s6
 346:	f09ff0ef          	jal	24e <putc>
 34a:	a019                	j	350 <vprintf+0x4c>
    } else if(state == '%'){
 34c:	03598263          	beq	s3,s5,370 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 350:	2485                	addw	s1,s1,1
 352:	8726                	mv	a4,s1
 354:	009a07b3          	add	a5,s4,s1
 358:	0007c903          	lbu	s2,0(a5)
 35c:	22090763          	beqz	s2,58a <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 360:	0009079b          	sext.w	a5,s2
    if(state == 0){
 364:	fe0994e3          	bnez	s3,34c <vprintf+0x48>
      if(c0 == '%'){
 368:	fd579de3          	bne	a5,s5,342 <vprintf+0x3e>
        state = '%';
 36c:	89be                	mv	s3,a5
 36e:	b7cd                	j	350 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 370:	cbc9                	beqz	a5,402 <vprintf+0xfe>
 372:	00ea06b3          	add	a3,s4,a4
 376:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 37a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 37c:	c681                	beqz	a3,384 <vprintf+0x80>
 37e:	9752                	add	a4,a4,s4
 380:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 384:	05878363          	beq	a5,s8,3ca <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 388:	05978d63          	beq	a5,s9,3e2 <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 38c:	07500713          	li	a4,117
 390:	0ee78763          	beq	a5,a4,47e <vprintf+0x17a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 394:	07800713          	li	a4,120
 398:	12e78963          	beq	a5,a4,4ca <vprintf+0x1c6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 39c:	07000713          	li	a4,112
 3a0:	14e78e63          	beq	a5,a4,4fc <vprintf+0x1f8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 3a4:	06300713          	li	a4,99
 3a8:	18e78a63          	beq	a5,a4,53c <vprintf+0x238>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 3ac:	07300713          	li	a4,115
 3b0:	1ae78063          	beq	a5,a4,550 <vprintf+0x24c>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 3b4:	02500713          	li	a4,37
 3b8:	04e79563          	bne	a5,a4,402 <vprintf+0xfe>
        putc(fd, '%');
 3bc:	02500593          	li	a1,37
 3c0:	855a                	mv	a0,s6
 3c2:	e8dff0ef          	jal	24e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 3c6:	4981                	li	s3,0
 3c8:	b761                	j	350 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 3ca:	008b8913          	add	s2,s7,8
 3ce:	4685                	li	a3,1
 3d0:	4629                	li	a2,10
 3d2:	000ba583          	lw	a1,0(s7)
 3d6:	855a                	mv	a0,s6
 3d8:	e95ff0ef          	jal	26c <printint>
 3dc:	8bca                	mv	s7,s2
      state = 0;
 3de:	4981                	li	s3,0
 3e0:	bf85                	j	350 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 3e2:	06400793          	li	a5,100
 3e6:	02f68963          	beq	a3,a5,418 <vprintf+0x114>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 3ea:	06c00793          	li	a5,108
 3ee:	04f68263          	beq	a3,a5,432 <vprintf+0x12e>
      } else if(c0 == 'l' && c1 == 'u'){
 3f2:	07500793          	li	a5,117
 3f6:	0af68063          	beq	a3,a5,496 <vprintf+0x192>
      } else if(c0 == 'l' && c1 == 'x'){
 3fa:	07800793          	li	a5,120
 3fe:	0ef68263          	beq	a3,a5,4e2 <vprintf+0x1de>
        putc(fd, '%');
 402:	02500593          	li	a1,37
 406:	855a                	mv	a0,s6
 408:	e47ff0ef          	jal	24e <putc>
        putc(fd, c0);
 40c:	85ca                	mv	a1,s2
 40e:	855a                	mv	a0,s6
 410:	e3fff0ef          	jal	24e <putc>
      state = 0;
 414:	4981                	li	s3,0
 416:	bf2d                	j	350 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 418:	008b8913          	add	s2,s7,8
 41c:	4685                	li	a3,1
 41e:	4629                	li	a2,10
 420:	000bb583          	ld	a1,0(s7)
 424:	855a                	mv	a0,s6
 426:	e47ff0ef          	jal	26c <printint>
        i += 1;
 42a:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 42c:	8bca                	mv	s7,s2
      state = 0;
 42e:	4981                	li	s3,0
        i += 1;
 430:	b705                	j	350 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 432:	06400793          	li	a5,100
 436:	02f60763          	beq	a2,a5,464 <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 43a:	07500793          	li	a5,117
 43e:	06f60963          	beq	a2,a5,4b0 <vprintf+0x1ac>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 442:	07800793          	li	a5,120
 446:	faf61ee3          	bne	a2,a5,402 <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 44a:	008b8913          	add	s2,s7,8
 44e:	4681                	li	a3,0
 450:	4641                	li	a2,16
 452:	000bb583          	ld	a1,0(s7)
 456:	855a                	mv	a0,s6
 458:	e15ff0ef          	jal	26c <printint>
        i += 2;
 45c:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 45e:	8bca                	mv	s7,s2
      state = 0;
 460:	4981                	li	s3,0
        i += 2;
 462:	b5fd                	j	350 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 464:	008b8913          	add	s2,s7,8
 468:	4685                	li	a3,1
 46a:	4629                	li	a2,10
 46c:	000bb583          	ld	a1,0(s7)
 470:	855a                	mv	a0,s6
 472:	dfbff0ef          	jal	26c <printint>
        i += 2;
 476:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 478:	8bca                	mv	s7,s2
      state = 0;
 47a:	4981                	li	s3,0
        i += 2;
 47c:	bdd1                	j	350 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 10, 0);
 47e:	008b8913          	add	s2,s7,8
 482:	4681                	li	a3,0
 484:	4629                	li	a2,10
 486:	000be583          	lwu	a1,0(s7)
 48a:	855a                	mv	a0,s6
 48c:	de1ff0ef          	jal	26c <printint>
 490:	8bca                	mv	s7,s2
      state = 0;
 492:	4981                	li	s3,0
 494:	bd75                	j	350 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 496:	008b8913          	add	s2,s7,8
 49a:	4681                	li	a3,0
 49c:	4629                	li	a2,10
 49e:	000bb583          	ld	a1,0(s7)
 4a2:	855a                	mv	a0,s6
 4a4:	dc9ff0ef          	jal	26c <printint>
        i += 1;
 4a8:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 4aa:	8bca                	mv	s7,s2
      state = 0;
 4ac:	4981                	li	s3,0
        i += 1;
 4ae:	b54d                	j	350 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4b0:	008b8913          	add	s2,s7,8
 4b4:	4681                	li	a3,0
 4b6:	4629                	li	a2,10
 4b8:	000bb583          	ld	a1,0(s7)
 4bc:	855a                	mv	a0,s6
 4be:	dafff0ef          	jal	26c <printint>
        i += 2;
 4c2:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 4c4:	8bca                	mv	s7,s2
      state = 0;
 4c6:	4981                	li	s3,0
        i += 2;
 4c8:	b561                	j	350 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 16, 0);
 4ca:	008b8913          	add	s2,s7,8
 4ce:	4681                	li	a3,0
 4d0:	4641                	li	a2,16
 4d2:	000be583          	lwu	a1,0(s7)
 4d6:	855a                	mv	a0,s6
 4d8:	d95ff0ef          	jal	26c <printint>
 4dc:	8bca                	mv	s7,s2
      state = 0;
 4de:	4981                	li	s3,0
 4e0:	bd85                	j	350 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 4e2:	008b8913          	add	s2,s7,8
 4e6:	4681                	li	a3,0
 4e8:	4641                	li	a2,16
 4ea:	000bb583          	ld	a1,0(s7)
 4ee:	855a                	mv	a0,s6
 4f0:	d7dff0ef          	jal	26c <printint>
        i += 1;
 4f4:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 4f6:	8bca                	mv	s7,s2
      state = 0;
 4f8:	4981                	li	s3,0
        i += 1;
 4fa:	bd99                	j	350 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 4fc:	008b8d13          	add	s10,s7,8
 500:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 504:	03000593          	li	a1,48
 508:	855a                	mv	a0,s6
 50a:	d45ff0ef          	jal	24e <putc>
  putc(fd, 'x');
 50e:	07800593          	li	a1,120
 512:	855a                	mv	a0,s6
 514:	d3bff0ef          	jal	24e <putc>
 518:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 51a:	64800b93          	li	s7,1608
 51e:	03c9d793          	srl	a5,s3,0x3c
 522:	97de                	add	a5,a5,s7
 524:	0007c583          	lbu	a1,0(a5)
 528:	855a                	mv	a0,s6
 52a:	d25ff0ef          	jal	24e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 52e:	0992                	sll	s3,s3,0x4
 530:	397d                	addw	s2,s2,-1
 532:	fe0916e3          	bnez	s2,51e <vprintf+0x21a>
        printptr(fd, va_arg(ap, uint64));
 536:	8bea                	mv	s7,s10
      state = 0;
 538:	4981                	li	s3,0
 53a:	bd19                	j	350 <vprintf+0x4c>
        putc(fd, va_arg(ap, uint32));
 53c:	008b8913          	add	s2,s7,8
 540:	000bc583          	lbu	a1,0(s7)
 544:	855a                	mv	a0,s6
 546:	d09ff0ef          	jal	24e <putc>
 54a:	8bca                	mv	s7,s2
      state = 0;
 54c:	4981                	li	s3,0
 54e:	b509                	j	350 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 550:	008b8993          	add	s3,s7,8
 554:	000bb903          	ld	s2,0(s7)
 558:	00090f63          	beqz	s2,576 <vprintf+0x272>
        for(; *s; s++)
 55c:	00094583          	lbu	a1,0(s2)
 560:	c195                	beqz	a1,584 <vprintf+0x280>
          putc(fd, *s);
 562:	855a                	mv	a0,s6
 564:	cebff0ef          	jal	24e <putc>
        for(; *s; s++)
 568:	0905                	add	s2,s2,1
 56a:	00094583          	lbu	a1,0(s2)
 56e:	f9f5                	bnez	a1,562 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 570:	8bce                	mv	s7,s3
      state = 0;
 572:	4981                	li	s3,0
 574:	bbf1                	j	350 <vprintf+0x4c>
          s = "(null)";
 576:	00000917          	auipc	s2,0x0
 57a:	0ca90913          	add	s2,s2,202 # 640 <printf+0x70>
        for(; *s; s++)
 57e:	02800593          	li	a1,40
 582:	b7c5                	j	562 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 584:	8bce                	mv	s7,s3
      state = 0;
 586:	4981                	li	s3,0
 588:	b3e1                	j	350 <vprintf+0x4c>
    }
  }
}
 58a:	60e6                	ld	ra,88(sp)
 58c:	6446                	ld	s0,80(sp)
 58e:	64a6                	ld	s1,72(sp)
 590:	6906                	ld	s2,64(sp)
 592:	79e2                	ld	s3,56(sp)
 594:	7a42                	ld	s4,48(sp)
 596:	7aa2                	ld	s5,40(sp)
 598:	7b02                	ld	s6,32(sp)
 59a:	6be2                	ld	s7,24(sp)
 59c:	6c42                	ld	s8,16(sp)
 59e:	6ca2                	ld	s9,8(sp)
 5a0:	6d02                	ld	s10,0(sp)
 5a2:	6125                	add	sp,sp,96
 5a4:	8082                	ret

00000000000005a6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5a6:	715d                	add	sp,sp,-80
 5a8:	ec06                	sd	ra,24(sp)
 5aa:	e822                	sd	s0,16(sp)
 5ac:	1000                	add	s0,sp,32
 5ae:	e010                	sd	a2,0(s0)
 5b0:	e414                	sd	a3,8(s0)
 5b2:	e818                	sd	a4,16(s0)
 5b4:	ec1c                	sd	a5,24(s0)
 5b6:	03043023          	sd	a6,32(s0)
 5ba:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 5be:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 5c2:	8622                	mv	a2,s0
 5c4:	d41ff0ef          	jal	304 <vprintf>
}
 5c8:	60e2                	ld	ra,24(sp)
 5ca:	6442                	ld	s0,16(sp)
 5cc:	6161                	add	sp,sp,80
 5ce:	8082                	ret

00000000000005d0 <printf>:

void
printf(const char *fmt, ...)
{
 5d0:	711d                	add	sp,sp,-96
 5d2:	ec06                	sd	ra,24(sp)
 5d4:	e822                	sd	s0,16(sp)
 5d6:	1000                	add	s0,sp,32
 5d8:	e40c                	sd	a1,8(s0)
 5da:	e810                	sd	a2,16(s0)
 5dc:	ec14                	sd	a3,24(s0)
 5de:	f018                	sd	a4,32(s0)
 5e0:	f41c                	sd	a5,40(s0)
 5e2:	03043823          	sd	a6,48(s0)
 5e6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 5ea:	00840613          	add	a2,s0,8
 5ee:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 5f2:	85aa                	mv	a1,a0
 5f4:	4505                	li	a0,1
 5f6:	d0fff0ef          	jal	304 <vprintf>
 5fa:	60e2                	ld	ra,24(sp)
 5fc:	6442                	ld	s0,16(sp)
 5fe:	6125                	add	sp,sp,96
 600:	8082                	ret
