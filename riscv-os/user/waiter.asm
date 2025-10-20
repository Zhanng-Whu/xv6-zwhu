
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
   e:	64648493          	add	s1,s1,1606 # 650 <printf+0x4a>
  12:	a021                	j	1a <foreverwait+0x1a>
  14:	8526                	mv	a0,s1
  16:	5f0000ef          	jal	606 <printf>
        int wpid = wait((int *)0);
  1a:	4501                	li	a0,0
  1c:	208000ef          	jal	224 <wait>
  20:	85aa                	mv	a1,a0
        if(wpid < 0){
  22:	fe0559e3          	bgez	a0,14 <foreverwait+0x14>
            printf("进程1离开\n");
  26:	00000517          	auipc	a0,0x0
  2a:	61a50513          	add	a0,a0,1562 # 640 <printf+0x3a>
  2e:	5d8000ef          	jal	606 <printf>
            exit(1);
  32:	4505                	li	a0,1
  34:	1e0000ef          	jal	214 <exit>

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
  46:	62e50513          	add	a0,a0,1582 # 670 <printf+0x6a>
  4a:	1f2000ef          	jal	23c <open>
  4e:	00054c63          	bltz	a0,66 <fdinit+0x2e>
        // 如果没有console设备 那么创建一个
        mknod("console", CONSOLE, 0);
        open("console", O_RDWR);
    }
    dup(0); // stdout
  52:	4501                	li	a0,0
  54:	1e0000ef          	jal	234 <dup>
    dup(0); // stderr
  58:	4501                	li	a0,0
  5a:	1da000ef          	jal	234 <dup>
}
  5e:	60a2                	ld	ra,8(sp)
  60:	6402                	ld	s0,0(sp)
  62:	0141                	add	sp,sp,16
  64:	8082                	ret
        mknod("console", CONSOLE, 0);
  66:	4601                	li	a2,0
  68:	4585                	li	a1,1
  6a:	00000517          	auipc	a0,0x0
  6e:	60650513          	add	a0,a0,1542 # 670 <printf+0x6a>
  72:	1d2000ef          	jal	244 <mknod>
        open("console", O_RDWR);
  76:	4589                	li	a1,2
  78:	00000517          	auipc	a0,0x0
  7c:	5f850513          	add	a0,a0,1528 # 670 <printf+0x6a>
  80:	1bc000ef          	jal	23c <open>
  84:	b7f9                	j	52 <fdinit+0x1a>

0000000000000086 <main>:



int main(){
  86:	1101                	add	sp,sp,-32
  88:	ec06                	sd	ra,24(sp)
  8a:	e822                	sd	s0,16(sp)
  8c:	1000                	add	s0,sp,32

    fdinit();
  8e:	fabff0ef          	jal	38 <fdinit>


    int pid = fork();
  92:	18a000ef          	jal	21c <fork>
    if(pid == 0){
  96:	e105                	bnez	a0,b6 <main+0x30>
        exec("cowtest", (char *[]){"cowtest", 0});
  98:	00000517          	auipc	a0,0x0
  9c:	5e050513          	add	a0,a0,1504 # 678 <printf+0x72>
  a0:	fea43023          	sd	a0,-32(s0)
  a4:	fe043423          	sd	zero,-24(s0)
  a8:	fe040593          	add	a1,s0,-32
  ac:	180000ef          	jal	22c <exec>
        exit(1);
  b0:	4505                	li	a0,1
  b2:	162000ef          	jal	214 <exit>
    }

    foreverwait();
  b6:	f4bff0ef          	jal	0 <foreverwait>

00000000000000ba <start>:
#include "include/user.h"


void
start(int argc, char **argv)
{
  ba:	1141                	add	sp,sp,-16
  bc:	e406                	sd	ra,8(sp)
  be:	e022                	sd	s0,0(sp)
  c0:	0800                	add	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  c2:	fc5ff0ef          	jal	86 <main>


  exit(r);
  c6:	14e000ef          	jal	214 <exit>

00000000000000ca <itoa>:
{
  char temp[16];
  int i = 0;
  int j = 0;

  if (n == 0) {
  ca:	cd25                	beqz	a0,142 <itoa+0x78>
{
  cc:	1101                	add	sp,sp,-32
  ce:	ec22                	sd	s0,24(sp)
  d0:	1000                	add	s0,sp,32
    buf[1] = '\0';
    return;
  }
  
  // Generate digits in reverse order
  while (n > 0) {
  d2:	fe040693          	add	a3,s0,-32
  int i = 0;
  d6:	4701                	li	a4,0
    temp[i++] = (n % 10) + '0';
  d8:	4829                	li	a6,10
  while (n > 0) {
  da:	48a5                	li	a7,9
    n /= 10;
  }
  temp[i] = '\0';

  // Reverse the string to get the correct order
  for (j = 0; j < i; j++) {
  dc:	4601                	li	a2,0
  while (n > 0) {
  de:	04a05c63          	blez	a0,136 <itoa+0x6c>
    temp[i++] = (n % 10) + '0';
  e2:	863a                	mv	a2,a4
  e4:	2705                	addw	a4,a4,1
  e6:	030567bb          	remw	a5,a0,a6
  ea:	0307879b          	addw	a5,a5,48
  ee:	00f68023          	sb	a5,0(a3)
    n /= 10;
  f2:	87aa                	mv	a5,a0
  f4:	0305453b          	divw	a0,a0,a6
  while (n > 0) {
  f8:	0685                	add	a3,a3,1
  fa:	fef8c4e3          	blt	a7,a5,e2 <itoa+0x18>
  temp[i] = '\0';
  fe:	ff070793          	add	a5,a4,-16
 102:	97a2                	add	a5,a5,s0
 104:	fe078823          	sb	zero,-16(a5)
  for (j = 0; j < i; j++) {
 108:	04e05463          	blez	a4,150 <itoa+0x86>
 10c:	fe040793          	add	a5,s0,-32
 110:	00c786b3          	add	a3,a5,a2
 114:	87ae                	mv	a5,a1
    buf[j] = temp[i - 1 - j];
 116:	0006c703          	lbu	a4,0(a3)
 11a:	00e78023          	sb	a4,0(a5)
  for (j = 0; j < i; j++) {
 11e:	16fd                	add	a3,a3,-1
 120:	0785                	add	a5,a5,1
 122:	40b7873b          	subw	a4,a5,a1
 126:	377d                	addw	a4,a4,-1
 128:	fec747e3          	blt	a4,a2,116 <itoa+0x4c>
 12c:	fff64793          	not	a5,a2
 130:	97fd                	sra	a5,a5,0x3f
 132:	8e7d                	and	a2,a2,a5
 134:	2605                	addw	a2,a2,1
  }
  buf[j] = '\0';
 136:	95b2                	add	a1,a1,a2
 138:	00058023          	sb	zero,0(a1)
}
 13c:	6462                	ld	s0,24(sp)
 13e:	6105                	add	sp,sp,32
 140:	8082                	ret
    buf[0] = '0';
 142:	03000793          	li	a5,48
 146:	00f58023          	sb	a5,0(a1)
    buf[1] = '\0';
 14a:	000580a3          	sb	zero,1(a1)
    return;
 14e:	8082                	ret
  for (j = 0; j < i; j++) {
 150:	4601                	li	a2,0
 152:	b7d5                	j	136 <itoa+0x6c>

0000000000000154 <strcpy>:

void strcpy(char *dst, const char *src) {
 154:	1141                	add	sp,sp,-16
 156:	e422                	sd	s0,8(sp)
 158:	0800                	add	s0,sp,16
    while ((*dst++ = *src++) != '\0');
 15a:	0585                	add	a1,a1,1
 15c:	0505                	add	a0,a0,1
 15e:	fff5c783          	lbu	a5,-1(a1)
 162:	fef50fa3          	sb	a5,-1(a0)
 166:	fbf5                	bnez	a5,15a <strcpy+0x6>
} 
 168:	6422                	ld	s0,8(sp)
 16a:	0141                	add	sp,sp,16
 16c:	8082                	ret

000000000000016e <strlen>:

uint
strlen(const char *s){
 16e:	1141                	add	sp,sp,-16
 170:	e422                	sd	s0,8(sp)
 172:	0800                	add	s0,sp,16
  int n;
  for(n = 0; s[n]; n++);
 174:	00054783          	lbu	a5,0(a0)
 178:	cf91                	beqz	a5,194 <strlen+0x26>
 17a:	0505                	add	a0,a0,1
 17c:	87aa                	mv	a5,a0
 17e:	86be                	mv	a3,a5
 180:	0785                	add	a5,a5,1
 182:	fff7c703          	lbu	a4,-1(a5)
 186:	ff65                	bnez	a4,17e <strlen+0x10>
 188:	40a6853b          	subw	a0,a3,a0
 18c:	2505                	addw	a0,a0,1
  return n;
}
 18e:	6422                	ld	s0,8(sp)
 190:	0141                	add	sp,sp,16
 192:	8082                	ret
  for(n = 0; s[n]; n++);
 194:	4501                	li	a0,0
 196:	bfe5                	j	18e <strlen+0x20>

0000000000000198 <strcmp>:

uint
strcmp(const char *p, const char *q)
{
 198:	1141                	add	sp,sp,-16
 19a:	e422                	sd	s0,8(sp)
 19c:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 19e:	00054783          	lbu	a5,0(a0)
 1a2:	cb91                	beqz	a5,1b6 <strcmp+0x1e>
 1a4:	0005c703          	lbu	a4,0(a1)
 1a8:	00f71763          	bne	a4,a5,1b6 <strcmp+0x1e>
    p++, q++;
 1ac:	0505                	add	a0,a0,1
 1ae:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 1b0:	00054783          	lbu	a5,0(a0)
 1b4:	fbe5                	bnez	a5,1a4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1b6:	0005c503          	lbu	a0,0(a1)
}
 1ba:	40a7853b          	subw	a0,a5,a0
 1be:	6422                	ld	s0,8(sp)
 1c0:	0141                	add	sp,sp,16
 1c2:	8082                	ret

00000000000001c4 <atoi>:


int
atoi(const char *s)
{
 1c4:	1141                	add	sp,sp,-16
 1c6:	e422                	sd	s0,8(sp)
 1c8:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ca:	00054683          	lbu	a3,0(a0)
 1ce:	fd06879b          	addw	a5,a3,-48
 1d2:	0ff7f793          	zext.b	a5,a5
 1d6:	4625                	li	a2,9
 1d8:	02f66863          	bltu	a2,a5,208 <atoi+0x44>
 1dc:	872a                	mv	a4,a0
  n = 0;
 1de:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1e0:	0705                	add	a4,a4,1
 1e2:	0025179b          	sllw	a5,a0,0x2
 1e6:	9fa9                	addw	a5,a5,a0
 1e8:	0017979b          	sllw	a5,a5,0x1
 1ec:	9fb5                	addw	a5,a5,a3
 1ee:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1f2:	00074683          	lbu	a3,0(a4)
 1f6:	fd06879b          	addw	a5,a3,-48
 1fa:	0ff7f793          	zext.b	a5,a5
 1fe:	fef671e3          	bgeu	a2,a5,1e0 <atoi+0x1c>
  return n;
 202:	6422                	ld	s0,8(sp)
 204:	0141                	add	sp,sp,16
 206:	8082                	ret
  n = 0;
 208:	4501                	li	a0,0
 20a:	bfe5                	j	202 <atoi+0x3e>

000000000000020c <hello>:
# generated by usys.pl - do not edit
#include "include/syscall.h"
.global hello
hello:
 li a7, SYS_hello
 20c:	4885                	li	a7,1
 ecall
 20e:	00000073          	ecall
 ret
 212:	8082                	ret

0000000000000214 <exit>:
.global exit
exit:
 li a7, SYS_exit
 214:	4889                	li	a7,2
 ecall
 216:	00000073          	ecall
 ret
 21a:	8082                	ret

000000000000021c <fork>:
.global fork
fork:
 li a7, SYS_fork
 21c:	4891                	li	a7,4
 ecall
 21e:	00000073          	ecall
 ret
 222:	8082                	ret

0000000000000224 <wait>:
.global wait
wait:
 li a7, SYS_wait
 224:	488d                	li	a7,3
 ecall
 226:	00000073          	ecall
 ret
 22a:	8082                	ret

000000000000022c <exec>:
.global exec
exec:
 li a7, SYS_exec
 22c:	4895                	li	a7,5
 ecall
 22e:	00000073          	ecall
 ret
 232:	8082                	ret

0000000000000234 <dup>:
.global dup
dup:
 li a7, SYS_dup
 234:	489d                	li	a7,7
 ecall
 236:	00000073          	ecall
 ret
 23a:	8082                	ret

000000000000023c <open>:
.global open
open:
 li a7, SYS_open
 23c:	4899                	li	a7,6
 ecall
 23e:	00000073          	ecall
 ret
 242:	8082                	ret

0000000000000244 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 244:	48a1                	li	a7,8
 ecall
 246:	00000073          	ecall
 ret
 24a:	8082                	ret

000000000000024c <write>:
.global write
write:
 li a7, SYS_write
 24c:	48a5                	li	a7,9
 ecall
 24e:	00000073          	ecall
 ret
 252:	8082                	ret

0000000000000254 <read>:
.global read
read:
 li a7, SYS_read
 254:	48a9                	li	a7,10
 ecall
 256:	00000073          	ecall
 ret
 25a:	8082                	ret

000000000000025c <close>:
.global close
close:
 li a7, SYS_close
 25c:	48ad                	li	a7,11
 ecall
 25e:	00000073          	ecall
 ret
 262:	8082                	ret

0000000000000264 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 264:	48b1                	li	a7,12
 ecall
 266:	00000073          	ecall
 ret
 26a:	8082                	ret

000000000000026c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 26c:	48b5                	li	a7,13
 ecall
 26e:	00000073          	ecall
 ret
 272:	8082                	ret

0000000000000274 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 274:	48b9                	li	a7,14
 ecall
 276:	00000073          	ecall
 ret
 27a:	8082                	ret

000000000000027c <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
 27c:	48bd                	li	a7,15
 ecall
 27e:	00000073          	ecall
 ret
 282:	8082                	ret

0000000000000284 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 284:	1101                	add	sp,sp,-32
 286:	ec06                	sd	ra,24(sp)
 288:	e822                	sd	s0,16(sp)
 28a:	1000                	add	s0,sp,32
 28c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 290:	4605                	li	a2,1
 292:	fef40593          	add	a1,s0,-17
 296:	fb7ff0ef          	jal	24c <write>
}
 29a:	60e2                	ld	ra,24(sp)
 29c:	6442                	ld	s0,16(sp)
 29e:	6105                	add	sp,sp,32
 2a0:	8082                	ret

00000000000002a2 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 2a2:	715d                	add	sp,sp,-80
 2a4:	e486                	sd	ra,72(sp)
 2a6:	e0a2                	sd	s0,64(sp)
 2a8:	fc26                	sd	s1,56(sp)
 2aa:	f84a                	sd	s2,48(sp)
 2ac:	f44e                	sd	s3,40(sp)
 2ae:	0880                	add	s0,sp,80
 2b0:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 2b2:	c299                	beqz	a3,2b8 <printint+0x16>
 2b4:	0605cf63          	bltz	a1,332 <printint+0x90>
  neg = 0;
 2b8:	4881                	li	a7,0
 2ba:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 2be:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 2c0:	68800513          	li	a0,1672
 2c4:	883e                	mv	a6,a5
 2c6:	2785                	addw	a5,a5,1
 2c8:	02c5f733          	remu	a4,a1,a2
 2cc:	972a                	add	a4,a4,a0
 2ce:	00074703          	lbu	a4,0(a4)
 2d2:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 2d6:	872e                	mv	a4,a1
 2d8:	02c5d5b3          	divu	a1,a1,a2
 2dc:	0685                	add	a3,a3,1
 2de:	fec773e3          	bgeu	a4,a2,2c4 <printint+0x22>
  if(neg)
 2e2:	00088b63          	beqz	a7,2f8 <printint+0x56>
    buf[i++] = '-';
 2e6:	fd078793          	add	a5,a5,-48
 2ea:	97a2                	add	a5,a5,s0
 2ec:	02d00713          	li	a4,45
 2f0:	fee78423          	sb	a4,-24(a5)
 2f4:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 2f8:	02f05663          	blez	a5,324 <printint+0x82>
 2fc:	fb840713          	add	a4,s0,-72
 300:	00f704b3          	add	s1,a4,a5
 304:	fff70993          	add	s3,a4,-1
 308:	99be                	add	s3,s3,a5
 30a:	37fd                	addw	a5,a5,-1
 30c:	1782                	sll	a5,a5,0x20
 30e:	9381                	srl	a5,a5,0x20
 310:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 314:	fff4c583          	lbu	a1,-1(s1)
 318:	854a                	mv	a0,s2
 31a:	f6bff0ef          	jal	284 <putc>
  while(--i >= 0)
 31e:	14fd                	add	s1,s1,-1
 320:	ff349ae3          	bne	s1,s3,314 <printint+0x72>
}
 324:	60a6                	ld	ra,72(sp)
 326:	6406                	ld	s0,64(sp)
 328:	74e2                	ld	s1,56(sp)
 32a:	7942                	ld	s2,48(sp)
 32c:	79a2                	ld	s3,40(sp)
 32e:	6161                	add	sp,sp,80
 330:	8082                	ret
    x = -xx;
 332:	40b005b3          	neg	a1,a1
    neg = 1;
 336:	4885                	li	a7,1
    x = -xx;
 338:	b749                	j	2ba <printint+0x18>

000000000000033a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 33a:	711d                	add	sp,sp,-96
 33c:	ec86                	sd	ra,88(sp)
 33e:	e8a2                	sd	s0,80(sp)
 340:	e4a6                	sd	s1,72(sp)
 342:	e0ca                	sd	s2,64(sp)
 344:	fc4e                	sd	s3,56(sp)
 346:	f852                	sd	s4,48(sp)
 348:	f456                	sd	s5,40(sp)
 34a:	f05a                	sd	s6,32(sp)
 34c:	ec5e                	sd	s7,24(sp)
 34e:	e862                	sd	s8,16(sp)
 350:	e466                	sd	s9,8(sp)
 352:	e06a                	sd	s10,0(sp)
 354:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 356:	0005c903          	lbu	s2,0(a1)
 35a:	26090363          	beqz	s2,5c0 <vprintf+0x286>
 35e:	8b2a                	mv	s6,a0
 360:	8a2e                	mv	s4,a1
 362:	8bb2                	mv	s7,a2
  state = 0;
 364:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 366:	4481                	li	s1,0
 368:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 36a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 36e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 372:	06c00c93          	li	s9,108
 376:	a005                	j	396 <vprintf+0x5c>
        putc(fd, c0);
 378:	85ca                	mv	a1,s2
 37a:	855a                	mv	a0,s6
 37c:	f09ff0ef          	jal	284 <putc>
 380:	a019                	j	386 <vprintf+0x4c>
    } else if(state == '%'){
 382:	03598263          	beq	s3,s5,3a6 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 386:	2485                	addw	s1,s1,1
 388:	8726                	mv	a4,s1
 38a:	009a07b3          	add	a5,s4,s1
 38e:	0007c903          	lbu	s2,0(a5)
 392:	22090763          	beqz	s2,5c0 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 396:	0009079b          	sext.w	a5,s2
    if(state == 0){
 39a:	fe0994e3          	bnez	s3,382 <vprintf+0x48>
      if(c0 == '%'){
 39e:	fd579de3          	bne	a5,s5,378 <vprintf+0x3e>
        state = '%';
 3a2:	89be                	mv	s3,a5
 3a4:	b7cd                	j	386 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 3a6:	cbc9                	beqz	a5,438 <vprintf+0xfe>
 3a8:	00ea06b3          	add	a3,s4,a4
 3ac:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 3b0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 3b2:	c681                	beqz	a3,3ba <vprintf+0x80>
 3b4:	9752                	add	a4,a4,s4
 3b6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 3ba:	05878363          	beq	a5,s8,400 <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 3be:	05978d63          	beq	a5,s9,418 <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 3c2:	07500713          	li	a4,117
 3c6:	0ee78763          	beq	a5,a4,4b4 <vprintf+0x17a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 3ca:	07800713          	li	a4,120
 3ce:	12e78963          	beq	a5,a4,500 <vprintf+0x1c6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 3d2:	07000713          	li	a4,112
 3d6:	14e78e63          	beq	a5,a4,532 <vprintf+0x1f8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 3da:	06300713          	li	a4,99
 3de:	18e78a63          	beq	a5,a4,572 <vprintf+0x238>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 3e2:	07300713          	li	a4,115
 3e6:	1ae78063          	beq	a5,a4,586 <vprintf+0x24c>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 3ea:	02500713          	li	a4,37
 3ee:	04e79563          	bne	a5,a4,438 <vprintf+0xfe>
        putc(fd, '%');
 3f2:	02500593          	li	a1,37
 3f6:	855a                	mv	a0,s6
 3f8:	e8dff0ef          	jal	284 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 3fc:	4981                	li	s3,0
 3fe:	b761                	j	386 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 400:	008b8913          	add	s2,s7,8
 404:	4685                	li	a3,1
 406:	4629                	li	a2,10
 408:	000ba583          	lw	a1,0(s7)
 40c:	855a                	mv	a0,s6
 40e:	e95ff0ef          	jal	2a2 <printint>
 412:	8bca                	mv	s7,s2
      state = 0;
 414:	4981                	li	s3,0
 416:	bf85                	j	386 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 418:	06400793          	li	a5,100
 41c:	02f68963          	beq	a3,a5,44e <vprintf+0x114>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 420:	06c00793          	li	a5,108
 424:	04f68263          	beq	a3,a5,468 <vprintf+0x12e>
      } else if(c0 == 'l' && c1 == 'u'){
 428:	07500793          	li	a5,117
 42c:	0af68063          	beq	a3,a5,4cc <vprintf+0x192>
      } else if(c0 == 'l' && c1 == 'x'){
 430:	07800793          	li	a5,120
 434:	0ef68263          	beq	a3,a5,518 <vprintf+0x1de>
        putc(fd, '%');
 438:	02500593          	li	a1,37
 43c:	855a                	mv	a0,s6
 43e:	e47ff0ef          	jal	284 <putc>
        putc(fd, c0);
 442:	85ca                	mv	a1,s2
 444:	855a                	mv	a0,s6
 446:	e3fff0ef          	jal	284 <putc>
      state = 0;
 44a:	4981                	li	s3,0
 44c:	bf2d                	j	386 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 44e:	008b8913          	add	s2,s7,8
 452:	4685                	li	a3,1
 454:	4629                	li	a2,10
 456:	000bb583          	ld	a1,0(s7)
 45a:	855a                	mv	a0,s6
 45c:	e47ff0ef          	jal	2a2 <printint>
        i += 1;
 460:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 462:	8bca                	mv	s7,s2
      state = 0;
 464:	4981                	li	s3,0
        i += 1;
 466:	b705                	j	386 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 468:	06400793          	li	a5,100
 46c:	02f60763          	beq	a2,a5,49a <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 470:	07500793          	li	a5,117
 474:	06f60963          	beq	a2,a5,4e6 <vprintf+0x1ac>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 478:	07800793          	li	a5,120
 47c:	faf61ee3          	bne	a2,a5,438 <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 480:	008b8913          	add	s2,s7,8
 484:	4681                	li	a3,0
 486:	4641                	li	a2,16
 488:	000bb583          	ld	a1,0(s7)
 48c:	855a                	mv	a0,s6
 48e:	e15ff0ef          	jal	2a2 <printint>
        i += 2;
 492:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 494:	8bca                	mv	s7,s2
      state = 0;
 496:	4981                	li	s3,0
        i += 2;
 498:	b5fd                	j	386 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 49a:	008b8913          	add	s2,s7,8
 49e:	4685                	li	a3,1
 4a0:	4629                	li	a2,10
 4a2:	000bb583          	ld	a1,0(s7)
 4a6:	855a                	mv	a0,s6
 4a8:	dfbff0ef          	jal	2a2 <printint>
        i += 2;
 4ac:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 4ae:	8bca                	mv	s7,s2
      state = 0;
 4b0:	4981                	li	s3,0
        i += 2;
 4b2:	bdd1                	j	386 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 10, 0);
 4b4:	008b8913          	add	s2,s7,8
 4b8:	4681                	li	a3,0
 4ba:	4629                	li	a2,10
 4bc:	000be583          	lwu	a1,0(s7)
 4c0:	855a                	mv	a0,s6
 4c2:	de1ff0ef          	jal	2a2 <printint>
 4c6:	8bca                	mv	s7,s2
      state = 0;
 4c8:	4981                	li	s3,0
 4ca:	bd75                	j	386 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4cc:	008b8913          	add	s2,s7,8
 4d0:	4681                	li	a3,0
 4d2:	4629                	li	a2,10
 4d4:	000bb583          	ld	a1,0(s7)
 4d8:	855a                	mv	a0,s6
 4da:	dc9ff0ef          	jal	2a2 <printint>
        i += 1;
 4de:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 4e0:	8bca                	mv	s7,s2
      state = 0;
 4e2:	4981                	li	s3,0
        i += 1;
 4e4:	b54d                	j	386 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4e6:	008b8913          	add	s2,s7,8
 4ea:	4681                	li	a3,0
 4ec:	4629                	li	a2,10
 4ee:	000bb583          	ld	a1,0(s7)
 4f2:	855a                	mv	a0,s6
 4f4:	dafff0ef          	jal	2a2 <printint>
        i += 2;
 4f8:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 4fa:	8bca                	mv	s7,s2
      state = 0;
 4fc:	4981                	li	s3,0
        i += 2;
 4fe:	b561                	j	386 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 16, 0);
 500:	008b8913          	add	s2,s7,8
 504:	4681                	li	a3,0
 506:	4641                	li	a2,16
 508:	000be583          	lwu	a1,0(s7)
 50c:	855a                	mv	a0,s6
 50e:	d95ff0ef          	jal	2a2 <printint>
 512:	8bca                	mv	s7,s2
      state = 0;
 514:	4981                	li	s3,0
 516:	bd85                	j	386 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 518:	008b8913          	add	s2,s7,8
 51c:	4681                	li	a3,0
 51e:	4641                	li	a2,16
 520:	000bb583          	ld	a1,0(s7)
 524:	855a                	mv	a0,s6
 526:	d7dff0ef          	jal	2a2 <printint>
        i += 1;
 52a:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 52c:	8bca                	mv	s7,s2
      state = 0;
 52e:	4981                	li	s3,0
        i += 1;
 530:	bd99                	j	386 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 532:	008b8d13          	add	s10,s7,8
 536:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 53a:	03000593          	li	a1,48
 53e:	855a                	mv	a0,s6
 540:	d45ff0ef          	jal	284 <putc>
  putc(fd, 'x');
 544:	07800593          	li	a1,120
 548:	855a                	mv	a0,s6
 54a:	d3bff0ef          	jal	284 <putc>
 54e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 550:	68800b93          	li	s7,1672
 554:	03c9d793          	srl	a5,s3,0x3c
 558:	97de                	add	a5,a5,s7
 55a:	0007c583          	lbu	a1,0(a5)
 55e:	855a                	mv	a0,s6
 560:	d25ff0ef          	jal	284 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 564:	0992                	sll	s3,s3,0x4
 566:	397d                	addw	s2,s2,-1
 568:	fe0916e3          	bnez	s2,554 <vprintf+0x21a>
        printptr(fd, va_arg(ap, uint64));
 56c:	8bea                	mv	s7,s10
      state = 0;
 56e:	4981                	li	s3,0
 570:	bd19                	j	386 <vprintf+0x4c>
        putc(fd, va_arg(ap, uint32));
 572:	008b8913          	add	s2,s7,8
 576:	000bc583          	lbu	a1,0(s7)
 57a:	855a                	mv	a0,s6
 57c:	d09ff0ef          	jal	284 <putc>
 580:	8bca                	mv	s7,s2
      state = 0;
 582:	4981                	li	s3,0
 584:	b509                	j	386 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 586:	008b8993          	add	s3,s7,8
 58a:	000bb903          	ld	s2,0(s7)
 58e:	00090f63          	beqz	s2,5ac <vprintf+0x272>
        for(; *s; s++)
 592:	00094583          	lbu	a1,0(s2)
 596:	c195                	beqz	a1,5ba <vprintf+0x280>
          putc(fd, *s);
 598:	855a                	mv	a0,s6
 59a:	cebff0ef          	jal	284 <putc>
        for(; *s; s++)
 59e:	0905                	add	s2,s2,1
 5a0:	00094583          	lbu	a1,0(s2)
 5a4:	f9f5                	bnez	a1,598 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 5a6:	8bce                	mv	s7,s3
      state = 0;
 5a8:	4981                	li	s3,0
 5aa:	bbf1                	j	386 <vprintf+0x4c>
          s = "(null)";
 5ac:	00000917          	auipc	s2,0x0
 5b0:	0d490913          	add	s2,s2,212 # 680 <printf+0x7a>
        for(; *s; s++)
 5b4:	02800593          	li	a1,40
 5b8:	b7c5                	j	598 <vprintf+0x25e>
        if((s = va_arg(ap, char*)) == 0)
 5ba:	8bce                	mv	s7,s3
      state = 0;
 5bc:	4981                	li	s3,0
 5be:	b3e1                	j	386 <vprintf+0x4c>
    }
  }
}
 5c0:	60e6                	ld	ra,88(sp)
 5c2:	6446                	ld	s0,80(sp)
 5c4:	64a6                	ld	s1,72(sp)
 5c6:	6906                	ld	s2,64(sp)
 5c8:	79e2                	ld	s3,56(sp)
 5ca:	7a42                	ld	s4,48(sp)
 5cc:	7aa2                	ld	s5,40(sp)
 5ce:	7b02                	ld	s6,32(sp)
 5d0:	6be2                	ld	s7,24(sp)
 5d2:	6c42                	ld	s8,16(sp)
 5d4:	6ca2                	ld	s9,8(sp)
 5d6:	6d02                	ld	s10,0(sp)
 5d8:	6125                	add	sp,sp,96
 5da:	8082                	ret

00000000000005dc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5dc:	715d                	add	sp,sp,-80
 5de:	ec06                	sd	ra,24(sp)
 5e0:	e822                	sd	s0,16(sp)
 5e2:	1000                	add	s0,sp,32
 5e4:	e010                	sd	a2,0(s0)
 5e6:	e414                	sd	a3,8(s0)
 5e8:	e818                	sd	a4,16(s0)
 5ea:	ec1c                	sd	a5,24(s0)
 5ec:	03043023          	sd	a6,32(s0)
 5f0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 5f4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 5f8:	8622                	mv	a2,s0
 5fa:	d41ff0ef          	jal	33a <vprintf>
}
 5fe:	60e2                	ld	ra,24(sp)
 600:	6442                	ld	s0,16(sp)
 602:	6161                	add	sp,sp,80
 604:	8082                	ret

0000000000000606 <printf>:

void
printf(const char *fmt, ...)
{
 606:	711d                	add	sp,sp,-96
 608:	ec06                	sd	ra,24(sp)
 60a:	e822                	sd	s0,16(sp)
 60c:	1000                	add	s0,sp,32
 60e:	e40c                	sd	a1,8(s0)
 610:	e810                	sd	a2,16(s0)
 612:	ec14                	sd	a3,24(s0)
 614:	f018                	sd	a4,32(s0)
 616:	f41c                	sd	a5,40(s0)
 618:	03043823          	sd	a6,48(s0)
 61c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 620:	00840613          	add	a2,s0,8
 624:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 628:	85aa                	mv	a1,a0
 62a:	4505                	li	a0,1
 62c:	d0fff0ef          	jal	33a <vprintf>
 630:	60e2                	ld	ra,24(sp)
 632:	6442                	ld	s0,16(sp)
 634:	6125                	add	sp,sp,96
 636:	8082                	ret
