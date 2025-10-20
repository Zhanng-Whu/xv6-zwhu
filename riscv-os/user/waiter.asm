
user/_waiter:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <foreverwait>:
#include "include/file.h"
#include "include/fcntl.h"


// 用于处理孤儿进程
void foreverwait(){
   0:	1101                	add	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	add	s0,sp,32
        int wpid = wait((int *)0);
        if(wpid < 0){
        printf("进程1离开\n");
            exit(1);
        }else{
            printf("清理了孤儿进程 %d\n", wpid);
   a:	00000497          	auipc	s1,0x0
   e:	65648493          	add	s1,s1,1622 # 660 <printf+0x4e>
  12:	a021                	j	1a <foreverwait+0x1a>
  14:	8526                	mv	a0,s1
  16:	5fc000ef          	jal	612 <printf>
        int wpid = wait((int *)0);
  1a:	4501                	li	a0,0
  1c:	214000ef          	jal	230 <wait>
  20:	85aa                	mv	a1,a0
        if(wpid < 0){
  22:	fe0559e3          	bgez	a0,14 <foreverwait+0x14>
        printf("进程1离开\n");
  26:	00000517          	auipc	a0,0x0
  2a:	62a50513          	add	a0,a0,1578 # 650 <printf+0x3e>
  2e:	5e4000ef          	jal	612 <printf>
            exit(1);
  32:	4505                	li	a0,1
  34:	1ec000ef          	jal	220 <exit>

0000000000000038 <fdinit>:
        }
    }
}

void fdinit(){
  38:	1141                	add	sp,sp,-16
  3a:	e406                	sd	ra,8(sp)
  3c:	e022                	sd	s0,0(sp)
  3e:	0800                	add	s0,sp,16
    
    if(open("console", O_RDWR) < 0){
  40:	4589                	li	a1,2
  42:	00000517          	auipc	a0,0x0
  46:	63e50513          	add	a0,a0,1598 # 680 <printf+0x6e>
  4a:	1fe000ef          	jal	248 <open>
  4e:	00054c63          	bltz	a0,66 <fdinit+0x2e>
        // 如果没有console设备 那么创建一个
        mknod("console", CONSOLE, 0);
        open("console", O_RDWR);
    }
    dup(0); // stdout
  52:	4501                	li	a0,0
  54:	1ec000ef          	jal	240 <dup>
    dup(0); // stderr
  58:	4501                	li	a0,0
  5a:	1e6000ef          	jal	240 <dup>
}
  5e:	60a2                	ld	ra,8(sp)
  60:	6402                	ld	s0,0(sp)
  62:	0141                	add	sp,sp,16
  64:	8082                	ret
        mknod("console", CONSOLE, 0);
  66:	4601                	li	a2,0
  68:	4585                	li	a1,1
  6a:	00000517          	auipc	a0,0x0
  6e:	61650513          	add	a0,a0,1558 # 680 <printf+0x6e>
  72:	1de000ef          	jal	250 <mknod>
        open("console", O_RDWR);
  76:	4589                	li	a1,2
  78:	00000517          	auipc	a0,0x0
  7c:	60850513          	add	a0,a0,1544 # 680 <printf+0x6e>
  80:	1c8000ef          	jal	248 <open>
  84:	b7f9                	j	52 <fdinit+0x1a>

0000000000000086 <main>:



int main(){
  86:	7179                	add	sp,sp,-48
  88:	f406                	sd	ra,40(sp)
  8a:	f022                	sd	s0,32(sp)
  8c:	1800                	add	s0,sp,48

    fdinit();
  8e:	fabff0ef          	jal	38 <fdinit>


    int pid = fork();
  92:	196000ef          	jal	228 <fork>
    if(pid == 0){
  96:	e515                	bnez	a0,c2 <main+0x3c>
        exec("prioritytest", (char *[]){"prioritytest", "8", 0});
  98:	00000517          	auipc	a0,0x0
  9c:	5f050513          	add	a0,a0,1520 # 688 <printf+0x76>
  a0:	fca43c23          	sd	a0,-40(s0)
  a4:	00000797          	auipc	a5,0x0
  a8:	5f478793          	add	a5,a5,1524 # 698 <printf+0x86>
  ac:	fef43023          	sd	a5,-32(s0)
  b0:	fe043423          	sd	zero,-24(s0)
  b4:	fd840593          	add	a1,s0,-40
  b8:	180000ef          	jal	238 <exec>
        exit(1);
  bc:	4505                	li	a0,1
  be:	162000ef          	jal	220 <exit>
    }

    foreverwait();
  c2:	f3fff0ef          	jal	0 <foreverwait>

00000000000000c6 <start>:
#include "include/user.h"


void
start(int argc, char **argv)
{
  c6:	1141                	add	sp,sp,-16
  c8:	e406                	sd	ra,8(sp)
  ca:	e022                	sd	s0,0(sp)
  cc:	0800                	add	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  ce:	fb9ff0ef          	jal	86 <main>


  exit(r);
  d2:	14e000ef          	jal	220 <exit>

00000000000000d6 <itoa>:
{
  char temp[16];
  int i = 0;
  int j = 0;

  if (n == 0) {
  d6:	cd25                	beqz	a0,14e <itoa+0x78>
{
  d8:	1101                	add	sp,sp,-32
  da:	ec22                	sd	s0,24(sp)
  dc:	1000                	add	s0,sp,32
    buf[1] = '\0';
    return;
  }
  
  // Generate digits in reverse order
  while (n > 0) {
  de:	fe040693          	add	a3,s0,-32
  int i = 0;
  e2:	4701                	li	a4,0
    temp[i++] = (n % 10) + '0';
  e4:	4829                	li	a6,10
  while (n > 0) {
  e6:	48a5                	li	a7,9
    n /= 10;
  }
  temp[i] = '\0';

  // Reverse the string to get the correct order
  for (j = 0; j < i; j++) {
  e8:	4601                	li	a2,0
  while (n > 0) {
  ea:	04a05c63          	blez	a0,142 <itoa+0x6c>
    temp[i++] = (n % 10) + '0';
  ee:	863a                	mv	a2,a4
  f0:	2705                	addw	a4,a4,1
  f2:	030567bb          	remw	a5,a0,a6
  f6:	0307879b          	addw	a5,a5,48
  fa:	00f68023          	sb	a5,0(a3)
    n /= 10;
  fe:	87aa                	mv	a5,a0
 100:	0305453b          	divw	a0,a0,a6
  while (n > 0) {
 104:	0685                	add	a3,a3,1
 106:	fef8c4e3          	blt	a7,a5,ee <itoa+0x18>
  temp[i] = '\0';
 10a:	ff070793          	add	a5,a4,-16
 10e:	97a2                	add	a5,a5,s0
 110:	fe078823          	sb	zero,-16(a5)
  for (j = 0; j < i; j++) {
 114:	04e05463          	blez	a4,15c <itoa+0x86>
 118:	fe040793          	add	a5,s0,-32
 11c:	00c786b3          	add	a3,a5,a2
 120:	87ae                	mv	a5,a1
    buf[j] = temp[i - 1 - j];
 122:	0006c703          	lbu	a4,0(a3)
 126:	00e78023          	sb	a4,0(a5)
  for (j = 0; j < i; j++) {
 12a:	16fd                	add	a3,a3,-1
 12c:	0785                	add	a5,a5,1
 12e:	40b7873b          	subw	a4,a5,a1
 132:	377d                	addw	a4,a4,-1
 134:	fec747e3          	blt	a4,a2,122 <itoa+0x4c>
 138:	fff64793          	not	a5,a2
 13c:	97fd                	sra	a5,a5,0x3f
 13e:	8e7d                	and	a2,a2,a5
 140:	2605                	addw	a2,a2,1
  }
  buf[j] = '\0';
 142:	95b2                	add	a1,a1,a2
 144:	00058023          	sb	zero,0(a1)
}
 148:	6462                	ld	s0,24(sp)
 14a:	6105                	add	sp,sp,32
 14c:	8082                	ret
    buf[0] = '0';
 14e:	03000793          	li	a5,48
 152:	00f58023          	sb	a5,0(a1)
    buf[1] = '\0';
 156:	000580a3          	sb	zero,1(a1)
    return;
 15a:	8082                	ret
  for (j = 0; j < i; j++) {
 15c:	4601                	li	a2,0
 15e:	b7d5                	j	142 <itoa+0x6c>

0000000000000160 <strcpy>:

void strcpy(char *dst, const char *src) {
 160:	1141                	add	sp,sp,-16
 162:	e422                	sd	s0,8(sp)
 164:	0800                	add	s0,sp,16
    while ((*dst++ = *src++) != '\0');
 166:	0585                	add	a1,a1,1
 168:	0505                	add	a0,a0,1
 16a:	fff5c783          	lbu	a5,-1(a1)
 16e:	fef50fa3          	sb	a5,-1(a0)
 172:	fbf5                	bnez	a5,166 <strcpy+0x6>
} 
 174:	6422                	ld	s0,8(sp)
 176:	0141                	add	sp,sp,16
 178:	8082                	ret

000000000000017a <strlen>:

uint
strlen(const char *s){
 17a:	1141                	add	sp,sp,-16
 17c:	e422                	sd	s0,8(sp)
 17e:	0800                	add	s0,sp,16
  int n;
  for(n = 0; s[n]; n++);
 180:	00054783          	lbu	a5,0(a0)
 184:	cf91                	beqz	a5,1a0 <strlen+0x26>
 186:	0505                	add	a0,a0,1
 188:	87aa                	mv	a5,a0
 18a:	86be                	mv	a3,a5
 18c:	0785                	add	a5,a5,1
 18e:	fff7c703          	lbu	a4,-1(a5)
 192:	ff65                	bnez	a4,18a <strlen+0x10>
 194:	40a6853b          	subw	a0,a3,a0
 198:	2505                	addw	a0,a0,1
  return n;
}
 19a:	6422                	ld	s0,8(sp)
 19c:	0141                	add	sp,sp,16
 19e:	8082                	ret
  for(n = 0; s[n]; n++);
 1a0:	4501                	li	a0,0
 1a2:	bfe5                	j	19a <strlen+0x20>

00000000000001a4 <strcmp>:

uint
strcmp(const char *p, const char *q)
{
 1a4:	1141                	add	sp,sp,-16
 1a6:	e422                	sd	s0,8(sp)
 1a8:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 1aa:	00054783          	lbu	a5,0(a0)
 1ae:	cb91                	beqz	a5,1c2 <strcmp+0x1e>
 1b0:	0005c703          	lbu	a4,0(a1)
 1b4:	00f71763          	bne	a4,a5,1c2 <strcmp+0x1e>
    p++, q++;
 1b8:	0505                	add	a0,a0,1
 1ba:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 1bc:	00054783          	lbu	a5,0(a0)
 1c0:	fbe5                	bnez	a5,1b0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1c2:	0005c503          	lbu	a0,0(a1)
}
 1c6:	40a7853b          	subw	a0,a5,a0
 1ca:	6422                	ld	s0,8(sp)
 1cc:	0141                	add	sp,sp,16
 1ce:	8082                	ret

00000000000001d0 <atoi>:


int
atoi(const char *s)
{
 1d0:	1141                	add	sp,sp,-16
 1d2:	e422                	sd	s0,8(sp)
 1d4:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1d6:	00054683          	lbu	a3,0(a0)
 1da:	fd06879b          	addw	a5,a3,-48
 1de:	0ff7f793          	zext.b	a5,a5
 1e2:	4625                	li	a2,9
 1e4:	02f66863          	bltu	a2,a5,214 <atoi+0x44>
 1e8:	872a                	mv	a4,a0
  n = 0;
 1ea:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1ec:	0705                	add	a4,a4,1
 1ee:	0025179b          	sllw	a5,a0,0x2
 1f2:	9fa9                	addw	a5,a5,a0
 1f4:	0017979b          	sllw	a5,a5,0x1
 1f8:	9fb5                	addw	a5,a5,a3
 1fa:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1fe:	00074683          	lbu	a3,0(a4)
 202:	fd06879b          	addw	a5,a3,-48
 206:	0ff7f793          	zext.b	a5,a5
 20a:	fef671e3          	bgeu	a2,a5,1ec <atoi+0x1c>
  return n;
 20e:	6422                	ld	s0,8(sp)
 210:	0141                	add	sp,sp,16
 212:	8082                	ret
  n = 0;
 214:	4501                	li	a0,0
 216:	bfe5                	j	20e <atoi+0x3e>

0000000000000218 <hello>:
# generated by usys.pl - do not edit
#include "include/syscall.h"
.global hello
hello:
 li a7, SYS_hello
 218:	4885                	li	a7,1
 ecall
 21a:	00000073          	ecall
 ret
 21e:	8082                	ret

0000000000000220 <exit>:
.global exit
exit:
 li a7, SYS_exit
 220:	4889                	li	a7,2
 ecall
 222:	00000073          	ecall
 ret
 226:	8082                	ret

0000000000000228 <fork>:
.global fork
fork:
 li a7, SYS_fork
 228:	4891                	li	a7,4
 ecall
 22a:	00000073          	ecall
 ret
 22e:	8082                	ret

0000000000000230 <wait>:
.global wait
wait:
 li a7, SYS_wait
 230:	488d                	li	a7,3
 ecall
 232:	00000073          	ecall
 ret
 236:	8082                	ret

0000000000000238 <exec>:
.global exec
exec:
 li a7, SYS_exec
 238:	4895                	li	a7,5
 ecall
 23a:	00000073          	ecall
 ret
 23e:	8082                	ret

0000000000000240 <dup>:
.global dup
dup:
 li a7, SYS_dup
 240:	489d                	li	a7,7
 ecall
 242:	00000073          	ecall
 ret
 246:	8082                	ret

0000000000000248 <open>:
.global open
open:
 li a7, SYS_open
 248:	4899                	li	a7,6
 ecall
 24a:	00000073          	ecall
 ret
 24e:	8082                	ret

0000000000000250 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 250:	48a1                	li	a7,8
 ecall
 252:	00000073          	ecall
 ret
 256:	8082                	ret

0000000000000258 <write>:
.global write
write:
 li a7, SYS_write
 258:	48a5                	li	a7,9
 ecall
 25a:	00000073          	ecall
 ret
 25e:	8082                	ret

0000000000000260 <read>:
.global read
read:
 li a7, SYS_read
 260:	48a9                	li	a7,10
 ecall
 262:	00000073          	ecall
 ret
 266:	8082                	ret

0000000000000268 <close>:
.global close
close:
 li a7, SYS_close
 268:	48ad                	li	a7,11
 ecall
 26a:	00000073          	ecall
 ret
 26e:	8082                	ret

0000000000000270 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 270:	48b1                	li	a7,12
 ecall
 272:	00000073          	ecall
 ret
 276:	8082                	ret

0000000000000278 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 278:	48b5                	li	a7,13
 ecall
 27a:	00000073          	ecall
 ret
 27e:	8082                	ret

0000000000000280 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 280:	48b9                	li	a7,14
 ecall
 282:	00000073          	ecall
 ret
 286:	8082                	ret

0000000000000288 <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
 288:	48bd                	li	a7,15
 ecall
 28a:	00000073          	ecall
 ret
 28e:	8082                	ret

0000000000000290 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 290:	1101                	add	sp,sp,-32
 292:	ec06                	sd	ra,24(sp)
 294:	e822                	sd	s0,16(sp)
 296:	1000                	add	s0,sp,32
 298:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 29c:	4605                	li	a2,1
 29e:	fef40593          	add	a1,s0,-17
 2a2:	fb7ff0ef          	jal	258 <write>
}
 2a6:	60e2                	ld	ra,24(sp)
 2a8:	6442                	ld	s0,16(sp)
 2aa:	6105                	add	sp,sp,32
 2ac:	8082                	ret

00000000000002ae <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 2ae:	715d                	add	sp,sp,-80
 2b0:	e486                	sd	ra,72(sp)
 2b2:	e0a2                	sd	s0,64(sp)
 2b4:	fc26                	sd	s1,56(sp)
 2b6:	f84a                	sd	s2,48(sp)
 2b8:	f44e                	sd	s3,40(sp)
 2ba:	0880                	add	s0,sp,80
 2bc:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 2be:	c299                	beqz	a3,2c4 <printint+0x16>
 2c0:	0605cf63          	bltz	a1,33e <printint+0x90>
  neg = 0;
 2c4:	4881                	li	a7,0
 2c6:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 2ca:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 2cc:	6a800513          	li	a0,1704
 2d0:	883e                	mv	a6,a5
 2d2:	2785                	addw	a5,a5,1
 2d4:	02c5f733          	remu	a4,a1,a2
 2d8:	972a                	add	a4,a4,a0
 2da:	00074703          	lbu	a4,0(a4)
 2de:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 2e2:	872e                	mv	a4,a1
 2e4:	02c5d5b3          	divu	a1,a1,a2
 2e8:	0685                	add	a3,a3,1
 2ea:	fec773e3          	bgeu	a4,a2,2d0 <printint+0x22>
  if(neg)
 2ee:	00088b63          	beqz	a7,304 <printint+0x56>
    buf[i++] = '-';
 2f2:	fd078793          	add	a5,a5,-48
 2f6:	97a2                	add	a5,a5,s0
 2f8:	02d00713          	li	a4,45
 2fc:	fee78423          	sb	a4,-24(a5)
 300:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 304:	02f05663          	blez	a5,330 <printint+0x82>
 308:	fb840713          	add	a4,s0,-72
 30c:	00f704b3          	add	s1,a4,a5
 310:	fff70993          	add	s3,a4,-1
 314:	99be                	add	s3,s3,a5
 316:	37fd                	addw	a5,a5,-1
 318:	1782                	sll	a5,a5,0x20
 31a:	9381                	srl	a5,a5,0x20
 31c:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 320:	fff4c583          	lbu	a1,-1(s1)
 324:	854a                	mv	a0,s2
 326:	f6bff0ef          	jal	290 <putc>
  while(--i >= 0)
 32a:	14fd                	add	s1,s1,-1
 32c:	ff349ae3          	bne	s1,s3,320 <printint+0x72>
}
 330:	60a6                	ld	ra,72(sp)
 332:	6406                	ld	s0,64(sp)
 334:	74e2                	ld	s1,56(sp)
 336:	7942                	ld	s2,48(sp)
 338:	79a2                	ld	s3,40(sp)
 33a:	6161                	add	sp,sp,80
 33c:	8082                	ret
    x = -xx;
 33e:	40b005b3          	neg	a1,a1
    neg = 1;
 342:	4885                	li	a7,1
    x = -xx;
 344:	b749                	j	2c6 <printint+0x18>

0000000000000346 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 346:	711d                	add	sp,sp,-96
 348:	ec86                	sd	ra,88(sp)
 34a:	e8a2                	sd	s0,80(sp)
 34c:	e4a6                	sd	s1,72(sp)
 34e:	e0ca                	sd	s2,64(sp)
 350:	fc4e                	sd	s3,56(sp)
 352:	f852                	sd	s4,48(sp)
 354:	f456                	sd	s5,40(sp)
 356:	f05a                	sd	s6,32(sp)
 358:	ec5e                	sd	s7,24(sp)
 35a:	e862                	sd	s8,16(sp)
 35c:	e466                	sd	s9,8(sp)
 35e:	e06a                	sd	s10,0(sp)
 360:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 362:	0005c903          	lbu	s2,0(a1)
 366:	26090363          	beqz	s2,5cc <vprintf+0x286>
 36a:	8b2a                	mv	s6,a0
 36c:	8a2e                	mv	s4,a1
 36e:	8bb2                	mv	s7,a2
  state = 0;
 370:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 372:	4481                	li	s1,0
 374:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 376:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 37a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 37e:	06c00c93          	li	s9,108
 382:	a005                	j	3a2 <vprintf+0x5c>
        putc(fd, c0);
 384:	85ca                	mv	a1,s2
 386:	855a                	mv	a0,s6
 388:	f09ff0ef          	jal	290 <putc>
 38c:	a019                	j	392 <vprintf+0x4c>
    } else if(state == '%'){
 38e:	03598263          	beq	s3,s5,3b2 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 392:	2485                	addw	s1,s1,1
 394:	8726                	mv	a4,s1
 396:	009a07b3          	add	a5,s4,s1
 39a:	0007c903          	lbu	s2,0(a5)
 39e:	22090763          	beqz	s2,5cc <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 3a2:	0009079b          	sext.w	a5,s2
    if(state == 0){
 3a6:	fe0994e3          	bnez	s3,38e <vprintf+0x48>
      if(c0 == '%'){
 3aa:	fd579de3          	bne	a5,s5,384 <vprintf+0x3e>
        state = '%';
 3ae:	89be                	mv	s3,a5
 3b0:	b7cd                	j	392 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 3b2:	cbc9                	beqz	a5,444 <vprintf+0xfe>
 3b4:	00ea06b3          	add	a3,s4,a4
 3b8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 3bc:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 3be:	c681                	beqz	a3,3c6 <vprintf+0x80>
 3c0:	9752                	add	a4,a4,s4
 3c2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 3c6:	05878363          	beq	a5,s8,40c <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 3ca:	05978d63          	beq	a5,s9,424 <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 3ce:	07500713          	li	a4,117
 3d2:	0ee78763          	beq	a5,a4,4c0 <vprintf+0x17a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 3d6:	07800713          	li	a4,120
 3da:	12e78963          	beq	a5,a4,50c <vprintf+0x1c6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 3de:	07000713          	li	a4,112
 3e2:	14e78e63          	beq	a5,a4,53e <vprintf+0x1f8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 3e6:	06300713          	li	a4,99
 3ea:	18e78a63          	beq	a5,a4,57e <vprintf+0x238>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 3ee:	07300713          	li	a4,115
 3f2:	1ae78063          	beq	a5,a4,592 <vprintf+0x24c>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 3f6:	02500713          	li	a4,37
 3fa:	04e79563          	bne	a5,a4,444 <vprintf+0xfe>
        putc(fd, '%');
 3fe:	02500593          	li	a1,37
 402:	855a                	mv	a0,s6
 404:	e8dff0ef          	jal	290 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 408:	4981                	li	s3,0
 40a:	b761                	j	392 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 40c:	008b8913          	add	s2,s7,8
 410:	4685                	li	a3,1
 412:	4629                	li	a2,10
 414:	000ba583          	lw	a1,0(s7)
 418:	855a                	mv	a0,s6
 41a:	e95ff0ef          	jal	2ae <printint>
 41e:	8bca                	mv	s7,s2
      state = 0;
 420:	4981                	li	s3,0
 422:	bf85                	j	392 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 424:	06400793          	li	a5,100
 428:	02f68963          	beq	a3,a5,45a <vprintf+0x114>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 42c:	06c00793          	li	a5,108
 430:	04f68263          	beq	a3,a5,474 <vprintf+0x12e>
      } else if(c0 == 'l' && c1 == 'u'){
 434:	07500793          	li	a5,117
 438:	0af68063          	beq	a3,a5,4d8 <vprintf+0x192>
      } else if(c0 == 'l' && c1 == 'x'){
 43c:	07800793          	li	a5,120
 440:	0ef68263          	beq	a3,a5,524 <vprintf+0x1de>
        putc(fd, '%');
 444:	02500593          	li	a1,37
 448:	855a                	mv	a0,s6
 44a:	e47ff0ef          	jal	290 <putc>
        putc(fd, c0);
 44e:	85ca                	mv	a1,s2
 450:	855a                	mv	a0,s6
 452:	e3fff0ef          	jal	290 <putc>
      state = 0;
 456:	4981                	li	s3,0
 458:	bf2d                	j	392 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 45a:	008b8913          	add	s2,s7,8
 45e:	4685                	li	a3,1
 460:	4629                	li	a2,10
 462:	000bb583          	ld	a1,0(s7)
 466:	855a                	mv	a0,s6
 468:	e47ff0ef          	jal	2ae <printint>
        i += 1;
 46c:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 46e:	8bca                	mv	s7,s2
      state = 0;
 470:	4981                	li	s3,0
        i += 1;
 472:	b705                	j	392 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 474:	06400793          	li	a5,100
 478:	02f60763          	beq	a2,a5,4a6 <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 47c:	07500793          	li	a5,117
 480:	06f60963          	beq	a2,a5,4f2 <vprintf+0x1ac>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 484:	07800793          	li	a5,120
 488:	faf61ee3          	bne	a2,a5,444 <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 48c:	008b8913          	add	s2,s7,8
 490:	4681                	li	a3,0
 492:	4641                	li	a2,16
 494:	000bb583          	ld	a1,0(s7)
 498:	855a                	mv	a0,s6
 49a:	e15ff0ef          	jal	2ae <printint>
        i += 2;
 49e:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 4a0:	8bca                	mv	s7,s2
      state = 0;
 4a2:	4981                	li	s3,0
        i += 2;
 4a4:	b5fd                	j	392 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4a6:	008b8913          	add	s2,s7,8
 4aa:	4685                	li	a3,1
 4ac:	4629                	li	a2,10
 4ae:	000bb583          	ld	a1,0(s7)
 4b2:	855a                	mv	a0,s6
 4b4:	dfbff0ef          	jal	2ae <printint>
        i += 2;
 4b8:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 4ba:	8bca                	mv	s7,s2
      state = 0;
 4bc:	4981                	li	s3,0
        i += 2;
 4be:	bdd1                	j	392 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 10, 0);
 4c0:	008b8913          	add	s2,s7,8
 4c4:	4681                	li	a3,0
 4c6:	4629                	li	a2,10
 4c8:	000be583          	lwu	a1,0(s7)
 4cc:	855a                	mv	a0,s6
 4ce:	de1ff0ef          	jal	2ae <printint>
 4d2:	8bca                	mv	s7,s2
      state = 0;
 4d4:	4981                	li	s3,0
 4d6:	bd75                	j	392 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4d8:	008b8913          	add	s2,s7,8
 4dc:	4681                	li	a3,0
 4de:	4629                	li	a2,10
 4e0:	000bb583          	ld	a1,0(s7)
 4e4:	855a                	mv	a0,s6
 4e6:	dc9ff0ef          	jal	2ae <printint>
        i += 1;
 4ea:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 4ec:	8bca                	mv	s7,s2
      state = 0;
 4ee:	4981                	li	s3,0
        i += 1;
 4f0:	b54d                	j	392 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4f2:	008b8913          	add	s2,s7,8
 4f6:	4681                	li	a3,0
 4f8:	4629                	li	a2,10
 4fa:	000bb583          	ld	a1,0(s7)
 4fe:	855a                	mv	a0,s6
 500:	dafff0ef          	jal	2ae <printint>
        i += 2;
 504:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 506:	8bca                	mv	s7,s2
      state = 0;
 508:	4981                	li	s3,0
        i += 2;
 50a:	b561                	j	392 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 16, 0);
 50c:	008b8913          	add	s2,s7,8
 510:	4681                	li	a3,0
 512:	4641                	li	a2,16
 514:	000be583          	lwu	a1,0(s7)
 518:	855a                	mv	a0,s6
 51a:	d95ff0ef          	jal	2ae <printint>
 51e:	8bca                	mv	s7,s2
      state = 0;
 520:	4981                	li	s3,0
 522:	bd85                	j	392 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 524:	008b8913          	add	s2,s7,8
 528:	4681                	li	a3,0
 52a:	4641                	li	a2,16
 52c:	000bb583          	ld	a1,0(s7)
 530:	855a                	mv	a0,s6
 532:	d7dff0ef          	jal	2ae <printint>
        i += 1;
 536:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 538:	8bca                	mv	s7,s2
      state = 0;
 53a:	4981                	li	s3,0
        i += 1;
 53c:	bd99                	j	392 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 53e:	008b8d13          	add	s10,s7,8
 542:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 546:	03000593          	li	a1,48
 54a:	855a                	mv	a0,s6
 54c:	d45ff0ef          	jal	290 <putc>
  putc(fd, 'x');
 550:	07800593          	li	a1,120
 554:	855a                	mv	a0,s6
 556:	d3bff0ef          	jal	290 <putc>
 55a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 55c:	6a800b93          	li	s7,1704
 560:	03c9d793          	srl	a5,s3,0x3c
 564:	97de                	add	a5,a5,s7
 566:	0007c583          	lbu	a1,0(a5)
 56a:	855a                	mv	a0,s6
 56c:	d25ff0ef          	jal	290 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 570:	0992                	sll	s3,s3,0x4
 572:	397d                	addw	s2,s2,-1
 574:	fe0916e3          	bnez	s2,560 <vprintf+0x21a>
        printptr(fd, va_arg(ap, uint64));
 578:	8bea                	mv	s7,s10
      state = 0;
 57a:	4981                	li	s3,0
 57c:	bd19                	j	392 <vprintf+0x4c>
        putc(fd, va_arg(ap, uint32));
 57e:	008b8913          	add	s2,s7,8
 582:	000bc583          	lbu	a1,0(s7)
 586:	855a                	mv	a0,s6
 588:	d09ff0ef          	jal	290 <putc>
 58c:	8bca                	mv	s7,s2
      state = 0;
 58e:	4981                	li	s3,0
 590:	b509                	j	392 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 592:	008b8993          	add	s3,s7,8
 596:	000bb903          	ld	s2,0(s7)
 59a:	00090f63          	beqz	s2,5b8 <vprintf+0x272>
        for(; *s; s++)
 59e:	00094583          	lbu	a1,0(s2)
 5a2:	c195                	beqz	a1,5c6 <vprintf+0x280>
          putc(fd, *s);
 5a4:	855a                	mv	a0,s6
 5a6:	cebff0ef          	jal	290 <putc>
        for(; *s; s++)
 5aa:	0905                	add	s2,s2,1
 5ac:	00094583          	lbu	a1,0(s2)
 5b0:	f9f5                	bnez	a1,5a4 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 5b2:	8bce                	mv	s7,s3
      state = 0;
 5b4:	4981                	li	s3,0
 5b6:	bbf1                	j	392 <vprintf+0x4c>
          s = "(null)";
 5b8:	00000917          	auipc	s2,0x0
 5bc:	0e890913          	add	s2,s2,232 # 6a0 <printf+0x8e>
        for(; *s; s++)
 5c0:	02800593          	li	a1,40
 5c4:	b7c5                	j	5a4 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 5c6:	8bce                	mv	s7,s3
      state = 0;
 5c8:	4981                	li	s3,0
 5ca:	b3e1                	j	392 <vprintf+0x4c>
    }
  }
}
 5cc:	60e6                	ld	ra,88(sp)
 5ce:	6446                	ld	s0,80(sp)
 5d0:	64a6                	ld	s1,72(sp)
 5d2:	6906                	ld	s2,64(sp)
 5d4:	79e2                	ld	s3,56(sp)
 5d6:	7a42                	ld	s4,48(sp)
 5d8:	7aa2                	ld	s5,40(sp)
 5da:	7b02                	ld	s6,32(sp)
 5dc:	6be2                	ld	s7,24(sp)
 5de:	6c42                	ld	s8,16(sp)
 5e0:	6ca2                	ld	s9,8(sp)
 5e2:	6d02                	ld	s10,0(sp)
 5e4:	6125                	add	sp,sp,96
 5e6:	8082                	ret

00000000000005e8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5e8:	715d                	add	sp,sp,-80
 5ea:	ec06                	sd	ra,24(sp)
 5ec:	e822                	sd	s0,16(sp)
 5ee:	1000                	add	s0,sp,32
 5f0:	e010                	sd	a2,0(s0)
 5f2:	e414                	sd	a3,8(s0)
 5f4:	e818                	sd	a4,16(s0)
 5f6:	ec1c                	sd	a5,24(s0)
 5f8:	03043023          	sd	a6,32(s0)
 5fc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 600:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 604:	8622                	mv	a2,s0
 606:	d41ff0ef          	jal	346 <vprintf>
}
 60a:	60e2                	ld	ra,24(sp)
 60c:	6442                	ld	s0,16(sp)
 60e:	6161                	add	sp,sp,80
 610:	8082                	ret

0000000000000612 <printf>:

void
printf(const char *fmt, ...)
{
 612:	711d                	add	sp,sp,-96
 614:	ec06                	sd	ra,24(sp)
 616:	e822                	sd	s0,16(sp)
 618:	1000                	add	s0,sp,32
 61a:	e40c                	sd	a1,8(s0)
 61c:	e810                	sd	a2,16(s0)
 61e:	ec14                	sd	a3,24(s0)
 620:	f018                	sd	a4,32(s0)
 622:	f41c                	sd	a5,40(s0)
 624:	03043823          	sd	a6,48(s0)
 628:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 62c:	00840613          	add	a2,s0,8
 630:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 634:	85aa                	mv	a1,a0
 636:	4505                	li	a0,1
 638:	d0fff0ef          	jal	346 <vprintf>
 63c:	60e2                	ld	ra,24(sp)
 63e:	6442                	ld	s0,16(sp)
 640:	6125                	add	sp,sp,96
 642:	8082                	ret
