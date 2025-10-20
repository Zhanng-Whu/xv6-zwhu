
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
   e:	17c000ef          	jal	18a <atoi>
    int status;

    for(int i=0;i<forknumber;i++)
  12:	06a05063          	blez	a0,72 <main+0x72>
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
  2e:	214000ef          	jal	242 <set_priority>
    for(int i=0;i<forknumber;i++)
  32:	2485                	addw	s1,s1,1
  34:	02990f63          	beq	s2,s1,72 <main+0x72>
        status=fork();
  38:	1aa000ef          	jal	1e2 <fork>
        if(status)
  3c:	f165                	bnez	a0,1c <main+0x1c>
  3e:	02800613          	li	a2,40
    for(int i=0;i<forknumber;i++)
  42:	3e800593          	li	a1,1000
  46:	1f400693          	li	a3,500
  4a:	872e                	mv	a4,a1
  4c:	87b6                	mv	a5,a3
        }
        if(status==0){
	    	for(int count=0;count<40; count++){
		    	for(int k=0;k<1000;k++){
					int result=0;
					for( int j=0; j<500; j++){
  4e:	37fd                	addw	a5,a5,-1
  50:	fffd                	bnez	a5,4e <main+0x4e>
		    	for(int k=0;k<1000;k++){
  52:	377d                	addw	a4,a4,-1
  54:	ff65                	bnez	a4,4c <main+0x4c>
	    	for(int count=0;count<40; count++){
  56:	367d                	addw	a2,a2,-1
  58:	fa6d                	bnez	a2,4a <main+0x4a>
                        result=result*j;
                        result = result+result/j;
					}
		   		}
            }
            printf("进程 %d 完成任务，准备退出。\n", getpid());
  5a:	1d0000ef          	jal	22a <getpid>
  5e:	85aa                	mv	a1,a0
  60:	00000517          	auipc	a0,0x0
  64:	5a050513          	add	a0,a0,1440 # 600 <printf+0x34>
  68:	564000ef          	jal	5cc <printf>
            exit(1);
  6c:	4505                	li	a0,1
  6e:	16c000ef          	jal	1da <exit>
        }
    }
    return 0;
  72:	4501                	li	a0,0
  74:	60e2                	ld	ra,24(sp)
  76:	6442                	ld	s0,16(sp)
  78:	64a2                	ld	s1,8(sp)
  7a:	6902                	ld	s2,0(sp)
  7c:	6105                	add	sp,sp,32
  7e:	8082                	ret

0000000000000080 <start>:
#include "include/user.h"


void
start(int argc, char **argv)
{
  80:	1141                	add	sp,sp,-16
  82:	e406                	sd	ra,8(sp)
  84:	e022                	sd	s0,0(sp)
  86:	0800                	add	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  88:	f79ff0ef          	jal	0 <main>


  exit(r);
  8c:	14e000ef          	jal	1da <exit>

0000000000000090 <itoa>:
{
  char temp[16];
  int i = 0;
  int j = 0;

  if (n == 0) {
  90:	cd25                	beqz	a0,108 <itoa+0x78>
{
  92:	1101                	add	sp,sp,-32
  94:	ec22                	sd	s0,24(sp)
  96:	1000                	add	s0,sp,32
    buf[1] = '\0';
    return;
  }
  
  // Generate digits in reverse order
  while (n > 0) {
  98:	fe040693          	add	a3,s0,-32
  int i = 0;
  9c:	4701                	li	a4,0
    temp[i++] = (n % 10) + '0';
  9e:	4829                	li	a6,10
  while (n > 0) {
  a0:	48a5                	li	a7,9
    n /= 10;
  }
  temp[i] = '\0';

  // Reverse the string to get the correct order
  for (j = 0; j < i; j++) {
  a2:	4601                	li	a2,0
  while (n > 0) {
  a4:	04a05c63          	blez	a0,fc <itoa+0x6c>
    temp[i++] = (n % 10) + '0';
  a8:	863a                	mv	a2,a4
  aa:	2705                	addw	a4,a4,1
  ac:	030567bb          	remw	a5,a0,a6
  b0:	0307879b          	addw	a5,a5,48
  b4:	00f68023          	sb	a5,0(a3)
    n /= 10;
  b8:	87aa                	mv	a5,a0
  ba:	0305453b          	divw	a0,a0,a6
  while (n > 0) {
  be:	0685                	add	a3,a3,1
  c0:	fef8c4e3          	blt	a7,a5,a8 <itoa+0x18>
  temp[i] = '\0';
  c4:	ff070793          	add	a5,a4,-16
  c8:	97a2                	add	a5,a5,s0
  ca:	fe078823          	sb	zero,-16(a5)
  for (j = 0; j < i; j++) {
  ce:	04e05463          	blez	a4,116 <itoa+0x86>
  d2:	fe040793          	add	a5,s0,-32
  d6:	00c786b3          	add	a3,a5,a2
  da:	87ae                	mv	a5,a1
    buf[j] = temp[i - 1 - j];
  dc:	0006c703          	lbu	a4,0(a3)
  e0:	00e78023          	sb	a4,0(a5)
  for (j = 0; j < i; j++) {
  e4:	16fd                	add	a3,a3,-1
  e6:	0785                	add	a5,a5,1
  e8:	40b7873b          	subw	a4,a5,a1
  ec:	377d                	addw	a4,a4,-1
  ee:	fec747e3          	blt	a4,a2,dc <itoa+0x4c>
  f2:	fff64793          	not	a5,a2
  f6:	97fd                	sra	a5,a5,0x3f
  f8:	8e7d                	and	a2,a2,a5
  fa:	2605                	addw	a2,a2,1
  }
  buf[j] = '\0';
  fc:	95b2                	add	a1,a1,a2
  fe:	00058023          	sb	zero,0(a1)
}
 102:	6462                	ld	s0,24(sp)
 104:	6105                	add	sp,sp,32
 106:	8082                	ret
    buf[0] = '0';
 108:	03000793          	li	a5,48
 10c:	00f58023          	sb	a5,0(a1)
    buf[1] = '\0';
 110:	000580a3          	sb	zero,1(a1)
    return;
 114:	8082                	ret
  for (j = 0; j < i; j++) {
 116:	4601                	li	a2,0
 118:	b7d5                	j	fc <itoa+0x6c>

000000000000011a <strcpy>:

void strcpy(char *dst, const char *src) {
 11a:	1141                	add	sp,sp,-16
 11c:	e422                	sd	s0,8(sp)
 11e:	0800                	add	s0,sp,16
    while ((*dst++ = *src++) != '\0');
 120:	0585                	add	a1,a1,1
 122:	0505                	add	a0,a0,1
 124:	fff5c783          	lbu	a5,-1(a1)
 128:	fef50fa3          	sb	a5,-1(a0)
 12c:	fbf5                	bnez	a5,120 <strcpy+0x6>
} 
 12e:	6422                	ld	s0,8(sp)
 130:	0141                	add	sp,sp,16
 132:	8082                	ret

0000000000000134 <strlen>:

uint
strlen(const char *s){
 134:	1141                	add	sp,sp,-16
 136:	e422                	sd	s0,8(sp)
 138:	0800                	add	s0,sp,16
  int n;
  for(n = 0; s[n]; n++);
 13a:	00054783          	lbu	a5,0(a0)
 13e:	cf91                	beqz	a5,15a <strlen+0x26>
 140:	0505                	add	a0,a0,1
 142:	87aa                	mv	a5,a0
 144:	86be                	mv	a3,a5
 146:	0785                	add	a5,a5,1
 148:	fff7c703          	lbu	a4,-1(a5)
 14c:	ff65                	bnez	a4,144 <strlen+0x10>
 14e:	40a6853b          	subw	a0,a3,a0
 152:	2505                	addw	a0,a0,1
  return n;
}
 154:	6422                	ld	s0,8(sp)
 156:	0141                	add	sp,sp,16
 158:	8082                	ret
  for(n = 0; s[n]; n++);
 15a:	4501                	li	a0,0
 15c:	bfe5                	j	154 <strlen+0x20>

000000000000015e <strcmp>:

uint
strcmp(const char *p, const char *q)
{
 15e:	1141                	add	sp,sp,-16
 160:	e422                	sd	s0,8(sp)
 162:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 164:	00054783          	lbu	a5,0(a0)
 168:	cb91                	beqz	a5,17c <strcmp+0x1e>
 16a:	0005c703          	lbu	a4,0(a1)
 16e:	00f71763          	bne	a4,a5,17c <strcmp+0x1e>
    p++, q++;
 172:	0505                	add	a0,a0,1
 174:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 176:	00054783          	lbu	a5,0(a0)
 17a:	fbe5                	bnez	a5,16a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 17c:	0005c503          	lbu	a0,0(a1)
}
 180:	40a7853b          	subw	a0,a5,a0
 184:	6422                	ld	s0,8(sp)
 186:	0141                	add	sp,sp,16
 188:	8082                	ret

000000000000018a <atoi>:
int
atoi(const char *s)
{
 18a:	1141                	add	sp,sp,-16
 18c:	e422                	sd	s0,8(sp)
 18e:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 190:	00054683          	lbu	a3,0(a0)
 194:	fd06879b          	addw	a5,a3,-48
 198:	0ff7f793          	zext.b	a5,a5
 19c:	4625                	li	a2,9
 19e:	02f66863          	bltu	a2,a5,1ce <atoi+0x44>
 1a2:	872a                	mv	a4,a0
  n = 0;
 1a4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1a6:	0705                	add	a4,a4,1
 1a8:	0025179b          	sllw	a5,a0,0x2
 1ac:	9fa9                	addw	a5,a5,a0
 1ae:	0017979b          	sllw	a5,a5,0x1
 1b2:	9fb5                	addw	a5,a5,a3
 1b4:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1b8:	00074683          	lbu	a3,0(a4)
 1bc:	fd06879b          	addw	a5,a3,-48
 1c0:	0ff7f793          	zext.b	a5,a5
 1c4:	fef671e3          	bgeu	a2,a5,1a6 <atoi+0x1c>
  return n;
 1c8:	6422                	ld	s0,8(sp)
 1ca:	0141                	add	sp,sp,16
 1cc:	8082                	ret
  n = 0;
 1ce:	4501                	li	a0,0
 1d0:	bfe5                	j	1c8 <atoi+0x3e>

00000000000001d2 <hello>:
# generated by usys.pl - do not edit
#include "include/syscall.h"
.global hello
hello:
 li a7, SYS_hello
 1d2:	4885                	li	a7,1
 ecall
 1d4:	00000073          	ecall
 ret
 1d8:	8082                	ret

00000000000001da <exit>:
.global exit
exit:
 li a7, SYS_exit
 1da:	4889                	li	a7,2
 ecall
 1dc:	00000073          	ecall
 ret
 1e0:	8082                	ret

00000000000001e2 <fork>:
.global fork
fork:
 li a7, SYS_fork
 1e2:	4891                	li	a7,4
 ecall
 1e4:	00000073          	ecall
 ret
 1e8:	8082                	ret

00000000000001ea <wait>:
.global wait
wait:
 li a7, SYS_wait
 1ea:	488d                	li	a7,3
 ecall
 1ec:	00000073          	ecall
 ret
 1f0:	8082                	ret

00000000000001f2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 1f2:	4895                	li	a7,5
 ecall
 1f4:	00000073          	ecall
 ret
 1f8:	8082                	ret

00000000000001fa <dup>:
.global dup
dup:
 li a7, SYS_dup
 1fa:	489d                	li	a7,7
 ecall
 1fc:	00000073          	ecall
 ret
 200:	8082                	ret

0000000000000202 <open>:
.global open
open:
 li a7, SYS_open
 202:	4899                	li	a7,6
 ecall
 204:	00000073          	ecall
 ret
 208:	8082                	ret

000000000000020a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 20a:	48a1                	li	a7,8
 ecall
 20c:	00000073          	ecall
 ret
 210:	8082                	ret

0000000000000212 <write>:
.global write
write:
 li a7, SYS_write
 212:	48a5                	li	a7,9
 ecall
 214:	00000073          	ecall
 ret
 218:	8082                	ret

000000000000021a <read>:
.global read
read:
 li a7, SYS_read
 21a:	48a9                	li	a7,10
 ecall
 21c:	00000073          	ecall
 ret
 220:	8082                	ret

0000000000000222 <close>:
.global close
close:
 li a7, SYS_close
 222:	48ad                	li	a7,11
 ecall
 224:	00000073          	ecall
 ret
 228:	8082                	ret

000000000000022a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 22a:	48b1                	li	a7,12
 ecall
 22c:	00000073          	ecall
 ret
 230:	8082                	ret

0000000000000232 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 232:	48b5                	li	a7,13
 ecall
 234:	00000073          	ecall
 ret
 238:	8082                	ret

000000000000023a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 23a:	48b9                	li	a7,14
 ecall
 23c:	00000073          	ecall
 ret
 240:	8082                	ret

0000000000000242 <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
 242:	48bd                	li	a7,15
 ecall
 244:	00000073          	ecall
 ret
 248:	8082                	ret

000000000000024a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 24a:	1101                	add	sp,sp,-32
 24c:	ec06                	sd	ra,24(sp)
 24e:	e822                	sd	s0,16(sp)
 250:	1000                	add	s0,sp,32
 252:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 256:	4605                	li	a2,1
 258:	fef40593          	add	a1,s0,-17
 25c:	fb7ff0ef          	jal	212 <write>
}
 260:	60e2                	ld	ra,24(sp)
 262:	6442                	ld	s0,16(sp)
 264:	6105                	add	sp,sp,32
 266:	8082                	ret

0000000000000268 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 268:	715d                	add	sp,sp,-80
 26a:	e486                	sd	ra,72(sp)
 26c:	e0a2                	sd	s0,64(sp)
 26e:	fc26                	sd	s1,56(sp)
 270:	f84a                	sd	s2,48(sp)
 272:	f44e                	sd	s3,40(sp)
 274:	0880                	add	s0,sp,80
 276:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 278:	c299                	beqz	a3,27e <printint+0x16>
 27a:	0605cf63          	bltz	a1,2f8 <printint+0x90>
  neg = 0;
 27e:	4881                	li	a7,0
 280:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 284:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 286:	63800513          	li	a0,1592
 28a:	883e                	mv	a6,a5
 28c:	2785                	addw	a5,a5,1
 28e:	02c5f733          	remu	a4,a1,a2
 292:	972a                	add	a4,a4,a0
 294:	00074703          	lbu	a4,0(a4)
 298:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 29c:	872e                	mv	a4,a1
 29e:	02c5d5b3          	divu	a1,a1,a2
 2a2:	0685                	add	a3,a3,1
 2a4:	fec773e3          	bgeu	a4,a2,28a <printint+0x22>
  if(neg)
 2a8:	00088b63          	beqz	a7,2be <printint+0x56>
    buf[i++] = '-';
 2ac:	fd078793          	add	a5,a5,-48
 2b0:	97a2                	add	a5,a5,s0
 2b2:	02d00713          	li	a4,45
 2b6:	fee78423          	sb	a4,-24(a5)
 2ba:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 2be:	02f05663          	blez	a5,2ea <printint+0x82>
 2c2:	fb840713          	add	a4,s0,-72
 2c6:	00f704b3          	add	s1,a4,a5
 2ca:	fff70993          	add	s3,a4,-1
 2ce:	99be                	add	s3,s3,a5
 2d0:	37fd                	addw	a5,a5,-1
 2d2:	1782                	sll	a5,a5,0x20
 2d4:	9381                	srl	a5,a5,0x20
 2d6:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 2da:	fff4c583          	lbu	a1,-1(s1)
 2de:	854a                	mv	a0,s2
 2e0:	f6bff0ef          	jal	24a <putc>
  while(--i >= 0)
 2e4:	14fd                	add	s1,s1,-1
 2e6:	ff349ae3          	bne	s1,s3,2da <printint+0x72>
}
 2ea:	60a6                	ld	ra,72(sp)
 2ec:	6406                	ld	s0,64(sp)
 2ee:	74e2                	ld	s1,56(sp)
 2f0:	7942                	ld	s2,48(sp)
 2f2:	79a2                	ld	s3,40(sp)
 2f4:	6161                	add	sp,sp,80
 2f6:	8082                	ret
    x = -xx;
 2f8:	40b005b3          	neg	a1,a1
    neg = 1;
 2fc:	4885                	li	a7,1
    x = -xx;
 2fe:	b749                	j	280 <printint+0x18>

0000000000000300 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 300:	711d                	add	sp,sp,-96
 302:	ec86                	sd	ra,88(sp)
 304:	e8a2                	sd	s0,80(sp)
 306:	e4a6                	sd	s1,72(sp)
 308:	e0ca                	sd	s2,64(sp)
 30a:	fc4e                	sd	s3,56(sp)
 30c:	f852                	sd	s4,48(sp)
 30e:	f456                	sd	s5,40(sp)
 310:	f05a                	sd	s6,32(sp)
 312:	ec5e                	sd	s7,24(sp)
 314:	e862                	sd	s8,16(sp)
 316:	e466                	sd	s9,8(sp)
 318:	e06a                	sd	s10,0(sp)
 31a:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 31c:	0005c903          	lbu	s2,0(a1)
 320:	26090363          	beqz	s2,586 <vprintf+0x286>
 324:	8b2a                	mv	s6,a0
 326:	8a2e                	mv	s4,a1
 328:	8bb2                	mv	s7,a2
  state = 0;
 32a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 32c:	4481                	li	s1,0
 32e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 330:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 334:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 338:	06c00c93          	li	s9,108
 33c:	a005                	j	35c <vprintf+0x5c>
        putc(fd, c0);
 33e:	85ca                	mv	a1,s2
 340:	855a                	mv	a0,s6
 342:	f09ff0ef          	jal	24a <putc>
 346:	a019                	j	34c <vprintf+0x4c>
    } else if(state == '%'){
 348:	03598263          	beq	s3,s5,36c <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 34c:	2485                	addw	s1,s1,1
 34e:	8726                	mv	a4,s1
 350:	009a07b3          	add	a5,s4,s1
 354:	0007c903          	lbu	s2,0(a5)
 358:	22090763          	beqz	s2,586 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 35c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 360:	fe0994e3          	bnez	s3,348 <vprintf+0x48>
      if(c0 == '%'){
 364:	fd579de3          	bne	a5,s5,33e <vprintf+0x3e>
        state = '%';
 368:	89be                	mv	s3,a5
 36a:	b7cd                	j	34c <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 36c:	cbc9                	beqz	a5,3fe <vprintf+0xfe>
 36e:	00ea06b3          	add	a3,s4,a4
 372:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 376:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 378:	c681                	beqz	a3,380 <vprintf+0x80>
 37a:	9752                	add	a4,a4,s4
 37c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 380:	05878363          	beq	a5,s8,3c6 <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 384:	05978d63          	beq	a5,s9,3de <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 388:	07500713          	li	a4,117
 38c:	0ee78763          	beq	a5,a4,47a <vprintf+0x17a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 390:	07800713          	li	a4,120
 394:	12e78963          	beq	a5,a4,4c6 <vprintf+0x1c6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 398:	07000713          	li	a4,112
 39c:	14e78e63          	beq	a5,a4,4f8 <vprintf+0x1f8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 3a0:	06300713          	li	a4,99
 3a4:	18e78a63          	beq	a5,a4,538 <vprintf+0x238>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 3a8:	07300713          	li	a4,115
 3ac:	1ae78063          	beq	a5,a4,54c <vprintf+0x24c>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 3b0:	02500713          	li	a4,37
 3b4:	04e79563          	bne	a5,a4,3fe <vprintf+0xfe>
        putc(fd, '%');
 3b8:	02500593          	li	a1,37
 3bc:	855a                	mv	a0,s6
 3be:	e8dff0ef          	jal	24a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 3c2:	4981                	li	s3,0
 3c4:	b761                	j	34c <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 3c6:	008b8913          	add	s2,s7,8
 3ca:	4685                	li	a3,1
 3cc:	4629                	li	a2,10
 3ce:	000ba583          	lw	a1,0(s7)
 3d2:	855a                	mv	a0,s6
 3d4:	e95ff0ef          	jal	268 <printint>
 3d8:	8bca                	mv	s7,s2
      state = 0;
 3da:	4981                	li	s3,0
 3dc:	bf85                	j	34c <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 3de:	06400793          	li	a5,100
 3e2:	02f68963          	beq	a3,a5,414 <vprintf+0x114>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 3e6:	06c00793          	li	a5,108
 3ea:	04f68263          	beq	a3,a5,42e <vprintf+0x12e>
      } else if(c0 == 'l' && c1 == 'u'){
 3ee:	07500793          	li	a5,117
 3f2:	0af68063          	beq	a3,a5,492 <vprintf+0x192>
      } else if(c0 == 'l' && c1 == 'x'){
 3f6:	07800793          	li	a5,120
 3fa:	0ef68263          	beq	a3,a5,4de <vprintf+0x1de>
        putc(fd, '%');
 3fe:	02500593          	li	a1,37
 402:	855a                	mv	a0,s6
 404:	e47ff0ef          	jal	24a <putc>
        putc(fd, c0);
 408:	85ca                	mv	a1,s2
 40a:	855a                	mv	a0,s6
 40c:	e3fff0ef          	jal	24a <putc>
      state = 0;
 410:	4981                	li	s3,0
 412:	bf2d                	j	34c <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 414:	008b8913          	add	s2,s7,8
 418:	4685                	li	a3,1
 41a:	4629                	li	a2,10
 41c:	000bb583          	ld	a1,0(s7)
 420:	855a                	mv	a0,s6
 422:	e47ff0ef          	jal	268 <printint>
        i += 1;
 426:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 428:	8bca                	mv	s7,s2
      state = 0;
 42a:	4981                	li	s3,0
        i += 1;
 42c:	b705                	j	34c <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 42e:	06400793          	li	a5,100
 432:	02f60763          	beq	a2,a5,460 <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 436:	07500793          	li	a5,117
 43a:	06f60963          	beq	a2,a5,4ac <vprintf+0x1ac>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 43e:	07800793          	li	a5,120
 442:	faf61ee3          	bne	a2,a5,3fe <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 446:	008b8913          	add	s2,s7,8
 44a:	4681                	li	a3,0
 44c:	4641                	li	a2,16
 44e:	000bb583          	ld	a1,0(s7)
 452:	855a                	mv	a0,s6
 454:	e15ff0ef          	jal	268 <printint>
        i += 2;
 458:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 45a:	8bca                	mv	s7,s2
      state = 0;
 45c:	4981                	li	s3,0
        i += 2;
 45e:	b5fd                	j	34c <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 460:	008b8913          	add	s2,s7,8
 464:	4685                	li	a3,1
 466:	4629                	li	a2,10
 468:	000bb583          	ld	a1,0(s7)
 46c:	855a                	mv	a0,s6
 46e:	dfbff0ef          	jal	268 <printint>
        i += 2;
 472:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 474:	8bca                	mv	s7,s2
      state = 0;
 476:	4981                	li	s3,0
        i += 2;
 478:	bdd1                	j	34c <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 10, 0);
 47a:	008b8913          	add	s2,s7,8
 47e:	4681                	li	a3,0
 480:	4629                	li	a2,10
 482:	000be583          	lwu	a1,0(s7)
 486:	855a                	mv	a0,s6
 488:	de1ff0ef          	jal	268 <printint>
 48c:	8bca                	mv	s7,s2
      state = 0;
 48e:	4981                	li	s3,0
 490:	bd75                	j	34c <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 492:	008b8913          	add	s2,s7,8
 496:	4681                	li	a3,0
 498:	4629                	li	a2,10
 49a:	000bb583          	ld	a1,0(s7)
 49e:	855a                	mv	a0,s6
 4a0:	dc9ff0ef          	jal	268 <printint>
        i += 1;
 4a4:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 4a6:	8bca                	mv	s7,s2
      state = 0;
 4a8:	4981                	li	s3,0
        i += 1;
 4aa:	b54d                	j	34c <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4ac:	008b8913          	add	s2,s7,8
 4b0:	4681                	li	a3,0
 4b2:	4629                	li	a2,10
 4b4:	000bb583          	ld	a1,0(s7)
 4b8:	855a                	mv	a0,s6
 4ba:	dafff0ef          	jal	268 <printint>
        i += 2;
 4be:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 4c0:	8bca                	mv	s7,s2
      state = 0;
 4c2:	4981                	li	s3,0
        i += 2;
 4c4:	b561                	j	34c <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 16, 0);
 4c6:	008b8913          	add	s2,s7,8
 4ca:	4681                	li	a3,0
 4cc:	4641                	li	a2,16
 4ce:	000be583          	lwu	a1,0(s7)
 4d2:	855a                	mv	a0,s6
 4d4:	d95ff0ef          	jal	268 <printint>
 4d8:	8bca                	mv	s7,s2
      state = 0;
 4da:	4981                	li	s3,0
 4dc:	bd85                	j	34c <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 4de:	008b8913          	add	s2,s7,8
 4e2:	4681                	li	a3,0
 4e4:	4641                	li	a2,16
 4e6:	000bb583          	ld	a1,0(s7)
 4ea:	855a                	mv	a0,s6
 4ec:	d7dff0ef          	jal	268 <printint>
        i += 1;
 4f0:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 4f2:	8bca                	mv	s7,s2
      state = 0;
 4f4:	4981                	li	s3,0
        i += 1;
 4f6:	bd99                	j	34c <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 4f8:	008b8d13          	add	s10,s7,8
 4fc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 500:	03000593          	li	a1,48
 504:	855a                	mv	a0,s6
 506:	d45ff0ef          	jal	24a <putc>
  putc(fd, 'x');
 50a:	07800593          	li	a1,120
 50e:	855a                	mv	a0,s6
 510:	d3bff0ef          	jal	24a <putc>
 514:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 516:	63800b93          	li	s7,1592
 51a:	03c9d793          	srl	a5,s3,0x3c
 51e:	97de                	add	a5,a5,s7
 520:	0007c583          	lbu	a1,0(a5)
 524:	855a                	mv	a0,s6
 526:	d25ff0ef          	jal	24a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 52a:	0992                	sll	s3,s3,0x4
 52c:	397d                	addw	s2,s2,-1
 52e:	fe0916e3          	bnez	s2,51a <vprintf+0x21a>
        printptr(fd, va_arg(ap, uint64));
 532:	8bea                	mv	s7,s10
      state = 0;
 534:	4981                	li	s3,0
 536:	bd19                	j	34c <vprintf+0x4c>
        putc(fd, va_arg(ap, uint32));
 538:	008b8913          	add	s2,s7,8
 53c:	000bc583          	lbu	a1,0(s7)
 540:	855a                	mv	a0,s6
 542:	d09ff0ef          	jal	24a <putc>
 546:	8bca                	mv	s7,s2
      state = 0;
 548:	4981                	li	s3,0
 54a:	b509                	j	34c <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 54c:	008b8993          	add	s3,s7,8
 550:	000bb903          	ld	s2,0(s7)
 554:	00090f63          	beqz	s2,572 <vprintf+0x272>
        for(; *s; s++)
 558:	00094583          	lbu	a1,0(s2)
 55c:	c195                	beqz	a1,580 <vprintf+0x280>
          putc(fd, *s);
 55e:	855a                	mv	a0,s6
 560:	cebff0ef          	jal	24a <putc>
        for(; *s; s++)
 564:	0905                	add	s2,s2,1
 566:	00094583          	lbu	a1,0(s2)
 56a:	f9f5                	bnez	a1,55e <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 56c:	8bce                	mv	s7,s3
      state = 0;
 56e:	4981                	li	s3,0
 570:	bbf1                	j	34c <vprintf+0x4c>
          s = "(null)";
 572:	00000917          	auipc	s2,0x0
 576:	0be90913          	add	s2,s2,190 # 630 <printf+0x64>
        for(; *s; s++)
 57a:	02800593          	li	a1,40
 57e:	b7c5                	j	55e <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 580:	8bce                	mv	s7,s3
      state = 0;
 582:	4981                	li	s3,0
 584:	b3e1                	j	34c <vprintf+0x4c>
    }
  }
}
 586:	60e6                	ld	ra,88(sp)
 588:	6446                	ld	s0,80(sp)
 58a:	64a6                	ld	s1,72(sp)
 58c:	6906                	ld	s2,64(sp)
 58e:	79e2                	ld	s3,56(sp)
 590:	7a42                	ld	s4,48(sp)
 592:	7aa2                	ld	s5,40(sp)
 594:	7b02                	ld	s6,32(sp)
 596:	6be2                	ld	s7,24(sp)
 598:	6c42                	ld	s8,16(sp)
 59a:	6ca2                	ld	s9,8(sp)
 59c:	6d02                	ld	s10,0(sp)
 59e:	6125                	add	sp,sp,96
 5a0:	8082                	ret

00000000000005a2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5a2:	715d                	add	sp,sp,-80
 5a4:	ec06                	sd	ra,24(sp)
 5a6:	e822                	sd	s0,16(sp)
 5a8:	1000                	add	s0,sp,32
 5aa:	e010                	sd	a2,0(s0)
 5ac:	e414                	sd	a3,8(s0)
 5ae:	e818                	sd	a4,16(s0)
 5b0:	ec1c                	sd	a5,24(s0)
 5b2:	03043023          	sd	a6,32(s0)
 5b6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 5ba:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 5be:	8622                	mv	a2,s0
 5c0:	d41ff0ef          	jal	300 <vprintf>
}
 5c4:	60e2                	ld	ra,24(sp)
 5c6:	6442                	ld	s0,16(sp)
 5c8:	6161                	add	sp,sp,80
 5ca:	8082                	ret

00000000000005cc <printf>:

void
printf(const char *fmt, ...)
{
 5cc:	711d                	add	sp,sp,-96
 5ce:	ec06                	sd	ra,24(sp)
 5d0:	e822                	sd	s0,16(sp)
 5d2:	1000                	add	s0,sp,32
 5d4:	e40c                	sd	a1,8(s0)
 5d6:	e810                	sd	a2,16(s0)
 5d8:	ec14                	sd	a3,24(s0)
 5da:	f018                	sd	a4,32(s0)
 5dc:	f41c                	sd	a5,40(s0)
 5de:	03043823          	sd	a6,48(s0)
 5e2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 5e6:	00840613          	add	a2,s0,8
 5ea:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 5ee:	85aa                	mv	a1,a0
 5f0:	4505                	li	a0,1
 5f2:	d0fff0ef          	jal	300 <vprintf>
 5f6:	60e2                	ld	ra,24(sp)
 5f8:	6442                	ld	s0,16(sp)
 5fa:	6125                	add	sp,sp,96
 5fc:	8082                	ret
