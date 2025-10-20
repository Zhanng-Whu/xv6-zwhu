
user/_usertest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <test_processing>:
#include "include/param.h"
#include "include/user.h"

#define NPROCS 60

void test_processing(){
   0:	715d                	add	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	fc26                	sd	s1,56(sp)
   8:	f84a                	sd	s2,48(sp)
   a:	f44e                	sd	s3,40(sp)
   c:	0880                	add	s0,sp,80
    printf("Fork测试");
   e:	00000517          	auipc	a0,0x0
  12:	69250513          	add	a0,a0,1682 # 6a0 <printf+0x38>
  16:	652000ef          	jal	668 <printf>

    int count = 0;
  1a:	4481                	li	s1,0
    for(int i = 0; i < NPROCS; i++){
  1c:	03c00913          	li	s2,60
        int pid = fork();
  20:	266000ef          	jal	286 <fork>
        if(pid < 0){
  24:	02054563          	bltz	a0,4e <test_processing+0x4e>
            printf("Fork失败 at %d\n", i);
            break;
        }
        if(pid == 0){
  28:	c559                	beqz	a0,b6 <test_processing+0xb6>
            exec("test", (char *[]){"test", "arg1", "arg2", 0});
            exit(0);
        
        }
        count++;
  2a:	2485                	addw	s1,s1,1
    for(int i = 0; i < NPROCS; i++){
  2c:	ff249ae3          	bne	s1,s2,20 <test_processing+0x20>
    }

    printf("创建了 %d 个子进程\n", count);
  30:	03c00593          	li	a1,60
  34:	00000517          	auipc	a0,0x0
  38:	69450513          	add	a0,a0,1684 # 6c8 <printf+0x60>
  3c:	62c000ef          	jal	668 <printf>

    printf("清理测试\n");
  40:	00000517          	auipc	a0,0x0
  44:	6a850513          	add	a0,a0,1704 # 6e8 <printf+0x80>
  48:	620000ef          	jal	668 <printf>

    int i;
    for( i = 0; i < count; i++){
  4c:	a805                	j	7c <test_processing+0x7c>
            printf("Fork失败 at %d\n", i);
  4e:	85a6                	mv	a1,s1
  50:	00000517          	auipc	a0,0x0
  54:	66050513          	add	a0,a0,1632 # 6b0 <printf+0x48>
  58:	610000ef          	jal	668 <printf>
    printf("创建了 %d 个子进程\n", count);
  5c:	85a6                	mv	a1,s1
  5e:	00000517          	auipc	a0,0x0
  62:	66a50513          	add	a0,a0,1642 # 6c8 <printf+0x60>
  66:	602000ef          	jal	668 <printf>
    printf("清理测试\n");
  6a:	00000517          	auipc	a0,0x0
  6e:	67e50513          	add	a0,a0,1662 # 6e8 <printf+0x80>
  72:	5f6000ef          	jal	668 <printf>
    for( i = 0; i < count; i++){
  76:	4901                	li	s2,0
  78:	08905063          	blez	s1,f8 <test_processing+0xf8>
    int count = 0;
  7c:	4901                	li	s2,0
        int wpid = wait(&tmppid);
        if(wpid < 0){
            printf("等待子进程失败\n");
            break;
        } else {
            printf("子进程 %d 已退出，状态 %d\n", wpid, tmppid);
  7e:	00000997          	auipc	s3,0x0
  82:	69a98993          	add	s3,s3,1690 # 718 <printf+0xb0>
        int tmppid = 0 ;
  86:	fa042823          	sw	zero,-80(s0)
        int wpid = wait(&tmppid);
  8a:	fb040513          	add	a0,s0,-80
  8e:	200000ef          	jal	28e <wait>
  92:	85aa                	mv	a1,a0
        if(wpid < 0){
  94:	04054c63          	bltz	a0,ec <test_processing+0xec>
            printf("子进程 %d 已退出，状态 %d\n", wpid, tmppid);
  98:	fb042603          	lw	a2,-80(s0)
  9c:	854e                	mv	a0,s3
  9e:	5ca000ef          	jal	668 <printf>
    for( i = 0; i < count; i++){
  a2:	2905                	addw	s2,s2,1
  a4:	fe9911e3          	bne	s2,s1,86 <test_processing+0x86>
        }
    }

    if(count == i){
        printf("所有的子进程全部退出\n");
  a8:	00000517          	auipc	a0,0x0
  ac:	69850513          	add	a0,a0,1688 # 740 <printf+0xd8>
  b0:	5b8000ef          	jal	668 <printf>
  b4:	a891                	j	108 <test_processing+0x108>
            exec("test", (char *[]){"test", "arg1", "arg2", 0});
  b6:	00001797          	auipc	a5,0x1
  ba:	80a78793          	add	a5,a5,-2038 # 8c0 <printf+0x258>
  be:	6390                	ld	a2,0(a5)
  c0:	6794                	ld	a3,8(a5)
  c2:	6b98                	ld	a4,16(a5)
  c4:	6f9c                	ld	a5,24(a5)
  c6:	fac43823          	sd	a2,-80(s0)
  ca:	fad43c23          	sd	a3,-72(s0)
  ce:	fce43023          	sd	a4,-64(s0)
  d2:	fcf43423          	sd	a5,-56(s0)
  d6:	fb040593          	add	a1,s0,-80
  da:	00000517          	auipc	a0,0x0
  de:	61e50513          	add	a0,a0,1566 # 6f8 <printf+0x90>
  e2:	1b4000ef          	jal	296 <exec>
            exit(0);
  e6:	4501                	li	a0,0
  e8:	196000ef          	jal	27e <exit>
            printf("等待子进程失败\n");
  ec:	00000517          	auipc	a0,0x0
  f0:	61450513          	add	a0,a0,1556 # 700 <printf+0x98>
  f4:	574000ef          	jal	668 <printf>
    if(count == i){
  f8:	fa9908e3          	beq	s2,s1,a8 <test_processing+0xa8>
    } else {
        printf("所有子进程已清理完毕\n");
  fc:	00000517          	auipc	a0,0x0
 100:	66450513          	add	a0,a0,1636 # 760 <printf+0xf8>
 104:	564000ef          	jal	668 <printf>
    }

}
 108:	60a6                	ld	ra,72(sp)
 10a:	6406                	ld	s0,64(sp)
 10c:	74e2                	ld	s1,56(sp)
 10e:	7942                	ld	s2,48(sp)
 110:	79a2                	ld	s3,40(sp)
 112:	6161                	add	sp,sp,80
 114:	8082                	ret

0000000000000116 <test_write_and_ptr>:

void test_write_and_ptr(){
 116:	7139                	add	sp,sp,-64
 118:	fc06                	sd	ra,56(sp)
 11a:	f822                	sd	s0,48(sp)
 11c:	f426                	sd	s1,40(sp)
 11e:	0080                	add	s0,sp,64
    char* invalid_ptr = (char*)0x1000000000;
    int res = write(1, invalid_ptr, 10);
 120:	4629                	li	a2,10
 122:	4585                	li	a1,1
 124:	1592                	sll	a1,a1,0x24
 126:	4505                	li	a0,1
 128:	18e000ef          	jal	2b6 <write>
    if(res == 0){
 12c:	0c051c63          	bnez	a0,204 <test_write_and_ptr+0xee>
        printf("写入无效指针测试通过\n");
 130:	00000517          	auipc	a0,0x0
 134:	65050513          	add	a0,a0,1616 # 780 <printf+0x118>
 138:	530000ef          	jal	668 <printf>
    } else {
        printf("写入无效指针测试失败\n");
        printf("错误码: %d\n", res);
    }

    char buffer[20] = "Hello, RISC-V!";
 13c:	00000797          	auipc	a5,0x0
 140:	78478793          	add	a5,a5,1924 # 8c0 <printf+0x258>
 144:	7398                	ld	a4,32(a5)
 146:	fce43423          	sd	a4,-56(s0)
 14a:	5798                	lw	a4,40(a5)
 14c:	fce42823          	sw	a4,-48(s0)
 150:	02c7d703          	lhu	a4,44(a5)
 154:	fce41a23          	sh	a4,-44(s0)
 158:	02e7c783          	lbu	a5,46(a5)
 15c:	fcf40b23          	sb	a5,-42(s0)
 160:	fc040ba3          	sb	zero,-41(s0)
 164:	fc040c23          	sb	zero,-40(s0)
 168:	fc040ca3          	sb	zero,-39(s0)
 16c:	fc040d23          	sb	zero,-38(s0)
 170:	fc040da3          	sb	zero,-37(s0)
    // 测试无效文件描述符
    res = write(-1, buffer, 20);
 174:	4651                	li	a2,20
 176:	fc840593          	add	a1,s0,-56
 17a:	557d                	li	a0,-1
 17c:	13a000ef          	jal	2b6 <write>
 180:	84aa                	mv	s1,a0
    if(res == -1){
 182:	57fd                	li	a5,-1
 184:	08f50f63          	beq	a0,a5,222 <test_write_and_ptr+0x10c>
        printf("写入无效文件描述符测试通过\n");
    } else {
        printf("写入无效文件描述符测试失败\n");
 188:	00000517          	auipc	a0,0x0
 18c:	67850513          	add	a0,a0,1656 # 800 <printf+0x198>
 190:	4d8000ef          	jal	668 <printf>
        printf("错误码: %d\n", res);
 194:	85a6                	mv	a1,s1
 196:	00000517          	auipc	a0,0x0
 19a:	62a50513          	add	a0,a0,1578 # 7c0 <printf+0x158>
 19e:	4ca000ef          	jal	668 <printf>
    }

    // 控指针
    res = write(1, 0, 10);
 1a2:	4629                	li	a2,10
 1a4:	4581                	li	a1,0
 1a6:	4505                	li	a0,1
 1a8:	10e000ef          	jal	2b6 <write>
 1ac:	84aa                	mv	s1,a0

    if(res == -1){
 1ae:	57fd                	li	a5,-1
 1b0:	08f50063          	beq	a0,a5,230 <test_write_and_ptr+0x11a>
        printf("写入空指针测试通过\n");
    } else {
        printf("写入空指针测试失败\n");
 1b4:	00000517          	auipc	a0,0x0
 1b8:	69c50513          	add	a0,a0,1692 # 850 <printf+0x1e8>
 1bc:	4ac000ef          	jal	668 <printf>
        printf("错误码: %d\n", res);
 1c0:	85a6                	mv	a1,s1
 1c2:	00000517          	auipc	a0,0x0
 1c6:	5fe50513          	add	a0,a0,1534 # 7c0 <printf+0x158>
 1ca:	49e000ef          	jal	668 <printf>
    }

    res = write(1, buffer, -5);
 1ce:	566d                	li	a2,-5
 1d0:	fc840593          	add	a1,s0,-56
 1d4:	4505                	li	a0,1
 1d6:	0e0000ef          	jal	2b6 <write>
 1da:	84aa                	mv	s1,a0
    if(res <= 0){
 1dc:	06a05163          	blez	a0,23e <test_write_and_ptr+0x128>
        printf("写入负长度测试通过\n");
    } else {
        printf("写入负长度测试失败\n");
 1e0:	00000517          	auipc	a0,0x0
 1e4:	6b050513          	add	a0,a0,1712 # 890 <printf+0x228>
 1e8:	480000ef          	jal	668 <printf>
        printf("错误码: %d\n", res);
 1ec:	85a6                	mv	a1,s1
 1ee:	00000517          	auipc	a0,0x0
 1f2:	5d250513          	add	a0,a0,1490 # 7c0 <printf+0x158>
 1f6:	472000ef          	jal	668 <printf>
    }

}
 1fa:	70e2                	ld	ra,56(sp)
 1fc:	7442                	ld	s0,48(sp)
 1fe:	74a2                	ld	s1,40(sp)
 200:	6121                	add	sp,sp,64
 202:	8082                	ret
 204:	84aa                	mv	s1,a0
        printf("写入无效指针测试失败\n");
 206:	00000517          	auipc	a0,0x0
 20a:	59a50513          	add	a0,a0,1434 # 7a0 <printf+0x138>
 20e:	45a000ef          	jal	668 <printf>
        printf("错误码: %d\n", res);
 212:	85a6                	mv	a1,s1
 214:	00000517          	auipc	a0,0x0
 218:	5ac50513          	add	a0,a0,1452 # 7c0 <printf+0x158>
 21c:	44c000ef          	jal	668 <printf>
 220:	bf31                	j	13c <test_write_and_ptr+0x26>
        printf("写入无效文件描述符测试通过\n");
 222:	00000517          	auipc	a0,0x0
 226:	5ae50513          	add	a0,a0,1454 # 7d0 <printf+0x168>
 22a:	43e000ef          	jal	668 <printf>
 22e:	bf95                	j	1a2 <test_write_and_ptr+0x8c>
        printf("写入空指针测试通过\n");
 230:	00000517          	auipc	a0,0x0
 234:	60050513          	add	a0,a0,1536 # 830 <printf+0x1c8>
 238:	430000ef          	jal	668 <printf>
 23c:	bf49                	j	1ce <test_write_and_ptr+0xb8>
        printf("写入负长度测试通过\n");
 23e:	00000517          	auipc	a0,0x0
 242:	63250513          	add	a0,a0,1586 # 870 <printf+0x208>
 246:	422000ef          	jal	668 <printf>
 24a:	bf45                	j	1fa <test_write_and_ptr+0xe4>

000000000000024c <main>:

int main(int argc, char const *argv[])
{
 24c:	1141                	add	sp,sp,-16
 24e:	e406                	sd	ra,8(sp)
 250:	e022                	sd	s0,0(sp)
 252:	0800                	add	s0,sp,16
    test_processing();
 254:	dadff0ef          	jal	0 <test_processing>
    test_write_and_ptr();
 258:	ebfff0ef          	jal	116 <test_write_and_ptr>
    return 0;
}
 25c:	4501                	li	a0,0
 25e:	60a2                	ld	ra,8(sp)
 260:	6402                	ld	s0,0(sp)
 262:	0141                	add	sp,sp,16
 264:	8082                	ret

0000000000000266 <start>:
#include "include/user.h"


void
start(int argc, char **argv)
{
 266:	1141                	add	sp,sp,-16
 268:	e406                	sd	ra,8(sp)
 26a:	e022                	sd	s0,0(sp)
 26c:	0800                	add	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 26e:	fdfff0ef          	jal	24c <main>


  exit(r);
 272:	00c000ef          	jal	27e <exit>

0000000000000276 <hello>:
# generated by usys.pl - do not edit
#include "include/syscall.h"
.global hello
hello:
 li a7, SYS_hello
 276:	4885                	li	a7,1
 ecall
 278:	00000073          	ecall
 ret
 27c:	8082                	ret

000000000000027e <exit>:
.global exit
exit:
 li a7, SYS_exit
 27e:	4889                	li	a7,2
 ecall
 280:	00000073          	ecall
 ret
 284:	8082                	ret

0000000000000286 <fork>:
.global fork
fork:
 li a7, SYS_fork
 286:	4891                	li	a7,4
 ecall
 288:	00000073          	ecall
 ret
 28c:	8082                	ret

000000000000028e <wait>:
.global wait
wait:
 li a7, SYS_wait
 28e:	488d                	li	a7,3
 ecall
 290:	00000073          	ecall
 ret
 294:	8082                	ret

0000000000000296 <exec>:
.global exec
exec:
 li a7, SYS_exec
 296:	4895                	li	a7,5
 ecall
 298:	00000073          	ecall
 ret
 29c:	8082                	ret

000000000000029e <dup>:
.global dup
dup:
 li a7, SYS_dup
 29e:	489d                	li	a7,7
 ecall
 2a0:	00000073          	ecall
 ret
 2a4:	8082                	ret

00000000000002a6 <open>:
.global open
open:
 li a7, SYS_open
 2a6:	4899                	li	a7,6
 ecall
 2a8:	00000073          	ecall
 ret
 2ac:	8082                	ret

00000000000002ae <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2ae:	48a1                	li	a7,8
 ecall
 2b0:	00000073          	ecall
 ret
 2b4:	8082                	ret

00000000000002b6 <write>:
.global write
write:
 li a7, SYS_write
 2b6:	48a5                	li	a7,9
 ecall
 2b8:	00000073          	ecall
 ret
 2bc:	8082                	ret

00000000000002be <read>:
.global read
read:
 li a7, SYS_read
 2be:	48a9                	li	a7,10
 ecall
 2c0:	00000073          	ecall
 ret
 2c4:	8082                	ret

00000000000002c6 <close>:
.global close
close:
 li a7, SYS_close
 2c6:	48ad                	li	a7,11
 ecall
 2c8:	00000073          	ecall
 ret
 2cc:	8082                	ret

00000000000002ce <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 2ce:	48b1                	li	a7,12
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2d6:	48b5                	li	a7,13
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 2de:	1101                	add	sp,sp,-32
 2e0:	ec06                	sd	ra,24(sp)
 2e2:	e822                	sd	s0,16(sp)
 2e4:	1000                	add	s0,sp,32
 2e6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 2ea:	4605                	li	a2,1
 2ec:	fef40593          	add	a1,s0,-17
 2f0:	fc7ff0ef          	jal	2b6 <write>
}
 2f4:	60e2                	ld	ra,24(sp)
 2f6:	6442                	ld	s0,16(sp)
 2f8:	6105                	add	sp,sp,32
 2fa:	8082                	ret

00000000000002fc <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 2fc:	715d                	add	sp,sp,-80
 2fe:	e486                	sd	ra,72(sp)
 300:	e0a2                	sd	s0,64(sp)
 302:	fc26                	sd	s1,56(sp)
 304:	f84a                	sd	s2,48(sp)
 306:	f44e                	sd	s3,40(sp)
 308:	0880                	add	s0,sp,80
 30a:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 30c:	c299                	beqz	a3,312 <printint+0x16>
 30e:	0805c163          	bltz	a1,390 <printint+0x94>
  neg = 0;
 312:	4881                	li	a7,0
 314:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 318:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 31a:	00000517          	auipc	a0,0x0
 31e:	5e650513          	add	a0,a0,1510 # 900 <digits>
 322:	883e                	mv	a6,a5
 324:	2785                	addw	a5,a5,1
 326:	02c5f733          	remu	a4,a1,a2
 32a:	972a                	add	a4,a4,a0
 32c:	00074703          	lbu	a4,0(a4)
 330:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 334:	872e                	mv	a4,a1
 336:	02c5d5b3          	divu	a1,a1,a2
 33a:	0685                	add	a3,a3,1
 33c:	fec773e3          	bgeu	a4,a2,322 <printint+0x26>
  if(neg)
 340:	00088b63          	beqz	a7,356 <printint+0x5a>
    buf[i++] = '-';
 344:	fd078793          	add	a5,a5,-48
 348:	97a2                	add	a5,a5,s0
 34a:	02d00713          	li	a4,45
 34e:	fee78423          	sb	a4,-24(a5)
 352:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 356:	02f05663          	blez	a5,382 <printint+0x86>
 35a:	fb840713          	add	a4,s0,-72
 35e:	00f704b3          	add	s1,a4,a5
 362:	fff70993          	add	s3,a4,-1
 366:	99be                	add	s3,s3,a5
 368:	37fd                	addw	a5,a5,-1
 36a:	1782                	sll	a5,a5,0x20
 36c:	9381                	srl	a5,a5,0x20
 36e:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 372:	fff4c583          	lbu	a1,-1(s1)
 376:	854a                	mv	a0,s2
 378:	f67ff0ef          	jal	2de <putc>
  while(--i >= 0)
 37c:	14fd                	add	s1,s1,-1
 37e:	ff349ae3          	bne	s1,s3,372 <printint+0x76>
}
 382:	60a6                	ld	ra,72(sp)
 384:	6406                	ld	s0,64(sp)
 386:	74e2                	ld	s1,56(sp)
 388:	7942                	ld	s2,48(sp)
 38a:	79a2                	ld	s3,40(sp)
 38c:	6161                	add	sp,sp,80
 38e:	8082                	ret
    x = -xx;
 390:	40b005b3          	neg	a1,a1
    neg = 1;
 394:	4885                	li	a7,1
    x = -xx;
 396:	bfbd                	j	314 <printint+0x18>

0000000000000398 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 398:	711d                	add	sp,sp,-96
 39a:	ec86                	sd	ra,88(sp)
 39c:	e8a2                	sd	s0,80(sp)
 39e:	e4a6                	sd	s1,72(sp)
 3a0:	e0ca                	sd	s2,64(sp)
 3a2:	fc4e                	sd	s3,56(sp)
 3a4:	f852                	sd	s4,48(sp)
 3a6:	f456                	sd	s5,40(sp)
 3a8:	f05a                	sd	s6,32(sp)
 3aa:	ec5e                	sd	s7,24(sp)
 3ac:	e862                	sd	s8,16(sp)
 3ae:	e466                	sd	s9,8(sp)
 3b0:	e06a                	sd	s10,0(sp)
 3b2:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 3b4:	0005c903          	lbu	s2,0(a1)
 3b8:	26090563          	beqz	s2,622 <vprintf+0x28a>
 3bc:	8b2a                	mv	s6,a0
 3be:	8a2e                	mv	s4,a1
 3c0:	8bb2                	mv	s7,a2
  state = 0;
 3c2:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 3c4:	4481                	li	s1,0
 3c6:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 3c8:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 3cc:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 3d0:	06c00c93          	li	s9,108
 3d4:	a005                	j	3f4 <vprintf+0x5c>
        putc(fd, c0);
 3d6:	85ca                	mv	a1,s2
 3d8:	855a                	mv	a0,s6
 3da:	f05ff0ef          	jal	2de <putc>
 3de:	a019                	j	3e4 <vprintf+0x4c>
    } else if(state == '%'){
 3e0:	03598263          	beq	s3,s5,404 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 3e4:	2485                	addw	s1,s1,1
 3e6:	8726                	mv	a4,s1
 3e8:	009a07b3          	add	a5,s4,s1
 3ec:	0007c903          	lbu	s2,0(a5)
 3f0:	22090963          	beqz	s2,622 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 3f4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 3f8:	fe0994e3          	bnez	s3,3e0 <vprintf+0x48>
      if(c0 == '%'){
 3fc:	fd579de3          	bne	a5,s5,3d6 <vprintf+0x3e>
        state = '%';
 400:	89be                	mv	s3,a5
 402:	b7cd                	j	3e4 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 404:	cbc9                	beqz	a5,496 <vprintf+0xfe>
 406:	00ea06b3          	add	a3,s4,a4
 40a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 40e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 410:	c681                	beqz	a3,418 <vprintf+0x80>
 412:	9752                	add	a4,a4,s4
 414:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 418:	05878363          	beq	a5,s8,45e <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 41c:	05978d63          	beq	a5,s9,476 <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 420:	07500713          	li	a4,117
 424:	0ee78763          	beq	a5,a4,512 <vprintf+0x17a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 428:	07800713          	li	a4,120
 42c:	12e78963          	beq	a5,a4,55e <vprintf+0x1c6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 430:	07000713          	li	a4,112
 434:	14e78e63          	beq	a5,a4,590 <vprintf+0x1f8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 438:	06300713          	li	a4,99
 43c:	18e78c63          	beq	a5,a4,5d4 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 440:	07300713          	li	a4,115
 444:	1ae78263          	beq	a5,a4,5e8 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 448:	02500713          	li	a4,37
 44c:	04e79563          	bne	a5,a4,496 <vprintf+0xfe>
        putc(fd, '%');
 450:	02500593          	li	a1,37
 454:	855a                	mv	a0,s6
 456:	e89ff0ef          	jal	2de <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 45a:	4981                	li	s3,0
 45c:	b761                	j	3e4 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 45e:	008b8913          	add	s2,s7,8
 462:	4685                	li	a3,1
 464:	4629                	li	a2,10
 466:	000ba583          	lw	a1,0(s7)
 46a:	855a                	mv	a0,s6
 46c:	e91ff0ef          	jal	2fc <printint>
 470:	8bca                	mv	s7,s2
      state = 0;
 472:	4981                	li	s3,0
 474:	bf85                	j	3e4 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 476:	06400793          	li	a5,100
 47a:	02f68963          	beq	a3,a5,4ac <vprintf+0x114>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 47e:	06c00793          	li	a5,108
 482:	04f68263          	beq	a3,a5,4c6 <vprintf+0x12e>
      } else if(c0 == 'l' && c1 == 'u'){
 486:	07500793          	li	a5,117
 48a:	0af68063          	beq	a3,a5,52a <vprintf+0x192>
      } else if(c0 == 'l' && c1 == 'x'){
 48e:	07800793          	li	a5,120
 492:	0ef68263          	beq	a3,a5,576 <vprintf+0x1de>
        putc(fd, '%');
 496:	02500593          	li	a1,37
 49a:	855a                	mv	a0,s6
 49c:	e43ff0ef          	jal	2de <putc>
        putc(fd, c0);
 4a0:	85ca                	mv	a1,s2
 4a2:	855a                	mv	a0,s6
 4a4:	e3bff0ef          	jal	2de <putc>
      state = 0;
 4a8:	4981                	li	s3,0
 4aa:	bf2d                	j	3e4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4ac:	008b8913          	add	s2,s7,8
 4b0:	4685                	li	a3,1
 4b2:	4629                	li	a2,10
 4b4:	000bb583          	ld	a1,0(s7)
 4b8:	855a                	mv	a0,s6
 4ba:	e43ff0ef          	jal	2fc <printint>
        i += 1;
 4be:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 4c0:	8bca                	mv	s7,s2
      state = 0;
 4c2:	4981                	li	s3,0
        i += 1;
 4c4:	b705                	j	3e4 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4c6:	06400793          	li	a5,100
 4ca:	02f60763          	beq	a2,a5,4f8 <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 4ce:	07500793          	li	a5,117
 4d2:	06f60963          	beq	a2,a5,544 <vprintf+0x1ac>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 4d6:	07800793          	li	a5,120
 4da:	faf61ee3          	bne	a2,a5,496 <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 4de:	008b8913          	add	s2,s7,8
 4e2:	4681                	li	a3,0
 4e4:	4641                	li	a2,16
 4e6:	000bb583          	ld	a1,0(s7)
 4ea:	855a                	mv	a0,s6
 4ec:	e11ff0ef          	jal	2fc <printint>
        i += 2;
 4f0:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 4f2:	8bca                	mv	s7,s2
      state = 0;
 4f4:	4981                	li	s3,0
        i += 2;
 4f6:	b5fd                	j	3e4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4f8:	008b8913          	add	s2,s7,8
 4fc:	4685                	li	a3,1
 4fe:	4629                	li	a2,10
 500:	000bb583          	ld	a1,0(s7)
 504:	855a                	mv	a0,s6
 506:	df7ff0ef          	jal	2fc <printint>
        i += 2;
 50a:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 50c:	8bca                	mv	s7,s2
      state = 0;
 50e:	4981                	li	s3,0
        i += 2;
 510:	bdd1                	j	3e4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 10, 0);
 512:	008b8913          	add	s2,s7,8
 516:	4681                	li	a3,0
 518:	4629                	li	a2,10
 51a:	000be583          	lwu	a1,0(s7)
 51e:	855a                	mv	a0,s6
 520:	dddff0ef          	jal	2fc <printint>
 524:	8bca                	mv	s7,s2
      state = 0;
 526:	4981                	li	s3,0
 528:	bd75                	j	3e4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 52a:	008b8913          	add	s2,s7,8
 52e:	4681                	li	a3,0
 530:	4629                	li	a2,10
 532:	000bb583          	ld	a1,0(s7)
 536:	855a                	mv	a0,s6
 538:	dc5ff0ef          	jal	2fc <printint>
        i += 1;
 53c:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 53e:	8bca                	mv	s7,s2
      state = 0;
 540:	4981                	li	s3,0
        i += 1;
 542:	b54d                	j	3e4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 544:	008b8913          	add	s2,s7,8
 548:	4681                	li	a3,0
 54a:	4629                	li	a2,10
 54c:	000bb583          	ld	a1,0(s7)
 550:	855a                	mv	a0,s6
 552:	dabff0ef          	jal	2fc <printint>
        i += 2;
 556:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 558:	8bca                	mv	s7,s2
      state = 0;
 55a:	4981                	li	s3,0
        i += 2;
 55c:	b561                	j	3e4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 16, 0);
 55e:	008b8913          	add	s2,s7,8
 562:	4681                	li	a3,0
 564:	4641                	li	a2,16
 566:	000be583          	lwu	a1,0(s7)
 56a:	855a                	mv	a0,s6
 56c:	d91ff0ef          	jal	2fc <printint>
 570:	8bca                	mv	s7,s2
      state = 0;
 572:	4981                	li	s3,0
 574:	bd85                	j	3e4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 576:	008b8913          	add	s2,s7,8
 57a:	4681                	li	a3,0
 57c:	4641                	li	a2,16
 57e:	000bb583          	ld	a1,0(s7)
 582:	855a                	mv	a0,s6
 584:	d79ff0ef          	jal	2fc <printint>
        i += 1;
 588:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 58a:	8bca                	mv	s7,s2
      state = 0;
 58c:	4981                	li	s3,0
        i += 1;
 58e:	bd99                	j	3e4 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 590:	008b8d13          	add	s10,s7,8
 594:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 598:	03000593          	li	a1,48
 59c:	855a                	mv	a0,s6
 59e:	d41ff0ef          	jal	2de <putc>
  putc(fd, 'x');
 5a2:	07800593          	li	a1,120
 5a6:	855a                	mv	a0,s6
 5a8:	d37ff0ef          	jal	2de <putc>
 5ac:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5ae:	00000b97          	auipc	s7,0x0
 5b2:	352b8b93          	add	s7,s7,850 # 900 <digits>
 5b6:	03c9d793          	srl	a5,s3,0x3c
 5ba:	97de                	add	a5,a5,s7
 5bc:	0007c583          	lbu	a1,0(a5)
 5c0:	855a                	mv	a0,s6
 5c2:	d1dff0ef          	jal	2de <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5c6:	0992                	sll	s3,s3,0x4
 5c8:	397d                	addw	s2,s2,-1
 5ca:	fe0916e3          	bnez	s2,5b6 <vprintf+0x21e>
        printptr(fd, va_arg(ap, uint64));
 5ce:	8bea                	mv	s7,s10
      state = 0;
 5d0:	4981                	li	s3,0
 5d2:	bd09                	j	3e4 <vprintf+0x4c>
        putc(fd, va_arg(ap, uint32));
 5d4:	008b8913          	add	s2,s7,8
 5d8:	000bc583          	lbu	a1,0(s7)
 5dc:	855a                	mv	a0,s6
 5de:	d01ff0ef          	jal	2de <putc>
 5e2:	8bca                	mv	s7,s2
      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	bbfd                	j	3e4 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 5e8:	008b8993          	add	s3,s7,8
 5ec:	000bb903          	ld	s2,0(s7)
 5f0:	00090f63          	beqz	s2,60e <vprintf+0x276>
        for(; *s; s++)
 5f4:	00094583          	lbu	a1,0(s2)
 5f8:	c195                	beqz	a1,61c <vprintf+0x284>
          putc(fd, *s);
 5fa:	855a                	mv	a0,s6
 5fc:	ce3ff0ef          	jal	2de <putc>
        for(; *s; s++)
 600:	0905                	add	s2,s2,1
 602:	00094583          	lbu	a1,0(s2)
 606:	f9f5                	bnez	a1,5fa <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 608:	8bce                	mv	s7,s3
      state = 0;
 60a:	4981                	li	s3,0
 60c:	bbe1                	j	3e4 <vprintf+0x4c>
          s = "(null)";
 60e:	00000917          	auipc	s2,0x0
 612:	2ea90913          	add	s2,s2,746 # 8f8 <printf+0x290>
        for(; *s; s++)
 616:	02800593          	li	a1,40
 61a:	b7c5                	j	5fa <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 61c:	8bce                	mv	s7,s3
      state = 0;
 61e:	4981                	li	s3,0
 620:	b3d1                	j	3e4 <vprintf+0x4c>
    }
  }
}
 622:	60e6                	ld	ra,88(sp)
 624:	6446                	ld	s0,80(sp)
 626:	64a6                	ld	s1,72(sp)
 628:	6906                	ld	s2,64(sp)
 62a:	79e2                	ld	s3,56(sp)
 62c:	7a42                	ld	s4,48(sp)
 62e:	7aa2                	ld	s5,40(sp)
 630:	7b02                	ld	s6,32(sp)
 632:	6be2                	ld	s7,24(sp)
 634:	6c42                	ld	s8,16(sp)
 636:	6ca2                	ld	s9,8(sp)
 638:	6d02                	ld	s10,0(sp)
 63a:	6125                	add	sp,sp,96
 63c:	8082                	ret

000000000000063e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 63e:	715d                	add	sp,sp,-80
 640:	ec06                	sd	ra,24(sp)
 642:	e822                	sd	s0,16(sp)
 644:	1000                	add	s0,sp,32
 646:	e010                	sd	a2,0(s0)
 648:	e414                	sd	a3,8(s0)
 64a:	e818                	sd	a4,16(s0)
 64c:	ec1c                	sd	a5,24(s0)
 64e:	03043023          	sd	a6,32(s0)
 652:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 656:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 65a:	8622                	mv	a2,s0
 65c:	d3dff0ef          	jal	398 <vprintf>
}
 660:	60e2                	ld	ra,24(sp)
 662:	6442                	ld	s0,16(sp)
 664:	6161                	add	sp,sp,80
 666:	8082                	ret

0000000000000668 <printf>:

void
printf(const char *fmt, ...)
{
 668:	711d                	add	sp,sp,-96
 66a:	ec06                	sd	ra,24(sp)
 66c:	e822                	sd	s0,16(sp)
 66e:	1000                	add	s0,sp,32
 670:	e40c                	sd	a1,8(s0)
 672:	e810                	sd	a2,16(s0)
 674:	ec14                	sd	a3,24(s0)
 676:	f018                	sd	a4,32(s0)
 678:	f41c                	sd	a5,40(s0)
 67a:	03043823          	sd	a6,48(s0)
 67e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 682:	00840613          	add	a2,s0,8
 686:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 68a:	85aa                	mv	a1,a0
 68c:	4505                	li	a0,1
 68e:	d0bff0ef          	jal	398 <vprintf>
 692:	60e2                	ld	ra,24(sp)
 694:	6442                	ld	s0,16(sp)
 696:	6125                	add	sp,sp,96
 698:	8082                	ret
