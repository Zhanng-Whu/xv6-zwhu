
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
  12:	69250513          	add	a0,a0,1682 # 6a0 <printf+0x40>
  16:	64a000ef          	jal	660 <printf>

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
  38:	69450513          	add	a0,a0,1684 # 6c8 <printf+0x68>
  3c:	624000ef          	jal	660 <printf>

    printf("清理测试\n");
  40:	00000517          	auipc	a0,0x0
  44:	6a850513          	add	a0,a0,1704 # 6e8 <printf+0x88>
  48:	618000ef          	jal	660 <printf>

    int i;
    for( i = 0; i < count; i++){
  4c:	a805                	j	7c <test_processing+0x7c>
            printf("Fork失败 at %d\n", i);
  4e:	85a6                	mv	a1,s1
  50:	00000517          	auipc	a0,0x0
  54:	66050513          	add	a0,a0,1632 # 6b0 <printf+0x50>
  58:	608000ef          	jal	660 <printf>
    printf("创建了 %d 个子进程\n", count);
  5c:	85a6                	mv	a1,s1
  5e:	00000517          	auipc	a0,0x0
  62:	66a50513          	add	a0,a0,1642 # 6c8 <printf+0x68>
  66:	5fa000ef          	jal	660 <printf>
    printf("清理测试\n");
  6a:	00000517          	auipc	a0,0x0
  6e:	67e50513          	add	a0,a0,1662 # 6e8 <printf+0x88>
  72:	5ee000ef          	jal	660 <printf>
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
  82:	69a98993          	add	s3,s3,1690 # 718 <printf+0xb8>
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
  9e:	5c2000ef          	jal	660 <printf>
    for( i = 0; i < count; i++){
  a2:	2905                	addw	s2,s2,1
  a4:	fe9911e3          	bne	s2,s1,86 <test_processing+0x86>
        }
    }

    if(count == i){
        printf("所有的子进程全部退出\n");
  a8:	00000517          	auipc	a0,0x0
  ac:	69850513          	add	a0,a0,1688 # 740 <printf+0xe0>
  b0:	5b0000ef          	jal	660 <printf>
  b4:	a891                	j	108 <test_processing+0x108>
            exec("test", (char *[]){"test", "arg1", "arg2", 0});
  b6:	00001797          	auipc	a5,0x1
  ba:	80a78793          	add	a5,a5,-2038 # 8c0 <printf+0x260>
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
  de:	61e50513          	add	a0,a0,1566 # 6f8 <printf+0x98>
  e2:	1b4000ef          	jal	296 <exec>
            exit(0);
  e6:	4501                	li	a0,0
  e8:	196000ef          	jal	27e <exit>
            printf("等待子进程失败\n");
  ec:	00000517          	auipc	a0,0x0
  f0:	61450513          	add	a0,a0,1556 # 700 <printf+0xa0>
  f4:	56c000ef          	jal	660 <printf>
    if(count == i){
  f8:	fa9908e3          	beq	s2,s1,a8 <test_processing+0xa8>
    } else {
        printf("所有子进程已清理完毕\n");
  fc:	00000517          	auipc	a0,0x0
 100:	66450513          	add	a0,a0,1636 # 760 <printf+0x100>
 104:	55c000ef          	jal	660 <printf>
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
 134:	65050513          	add	a0,a0,1616 # 780 <printf+0x120>
 138:	528000ef          	jal	660 <printf>
    } else {
        printf("写入无效指针测试失败\n");
        printf("错误码: %d\n", res);
    }

    char buffer[20] = "Hello, RISC-V!";
 13c:	00000797          	auipc	a5,0x0
 140:	78478793          	add	a5,a5,1924 # 8c0 <printf+0x260>
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
 18c:	67850513          	add	a0,a0,1656 # 800 <printf+0x1a0>
 190:	4d0000ef          	jal	660 <printf>
        printf("错误码: %d\n", res);
 194:	85a6                	mv	a1,s1
 196:	00000517          	auipc	a0,0x0
 19a:	62a50513          	add	a0,a0,1578 # 7c0 <printf+0x160>
 19e:	4c2000ef          	jal	660 <printf>
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
 1b8:	69c50513          	add	a0,a0,1692 # 850 <printf+0x1f0>
 1bc:	4a4000ef          	jal	660 <printf>
        printf("错误码: %d\n", res);
 1c0:	85a6                	mv	a1,s1
 1c2:	00000517          	auipc	a0,0x0
 1c6:	5fe50513          	add	a0,a0,1534 # 7c0 <printf+0x160>
 1ca:	496000ef          	jal	660 <printf>
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
 1e4:	6b050513          	add	a0,a0,1712 # 890 <printf+0x230>
 1e8:	478000ef          	jal	660 <printf>
        printf("错误码: %d\n", res);
 1ec:	85a6                	mv	a1,s1
 1ee:	00000517          	auipc	a0,0x0
 1f2:	5d250513          	add	a0,a0,1490 # 7c0 <printf+0x160>
 1f6:	46a000ef          	jal	660 <printf>
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
 20a:	59a50513          	add	a0,a0,1434 # 7a0 <printf+0x140>
 20e:	452000ef          	jal	660 <printf>
        printf("错误码: %d\n", res);
 212:	85a6                	mv	a1,s1
 214:	00000517          	auipc	a0,0x0
 218:	5ac50513          	add	a0,a0,1452 # 7c0 <printf+0x160>
 21c:	444000ef          	jal	660 <printf>
 220:	bf31                	j	13c <test_write_and_ptr+0x26>
        printf("写入无效文件描述符测试通过\n");
 222:	00000517          	auipc	a0,0x0
 226:	5ae50513          	add	a0,a0,1454 # 7d0 <printf+0x170>
 22a:	436000ef          	jal	660 <printf>
 22e:	bf95                	j	1a2 <test_write_and_ptr+0x8c>
        printf("写入空指针测试通过\n");
 230:	00000517          	auipc	a0,0x0
 234:	60050513          	add	a0,a0,1536 # 830 <printf+0x1d0>
 238:	428000ef          	jal	660 <printf>
 23c:	bf49                	j	1ce <test_write_and_ptr+0xb8>
        printf("写入负长度测试通过\n");
 23e:	00000517          	auipc	a0,0x0
 242:	63250513          	add	a0,a0,1586 # 870 <printf+0x210>
 246:	41a000ef          	jal	660 <printf>
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

00000000000002d6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 2d6:	1101                	add	sp,sp,-32
 2d8:	ec06                	sd	ra,24(sp)
 2da:	e822                	sd	s0,16(sp)
 2dc:	1000                	add	s0,sp,32
 2de:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 2e2:	4605                	li	a2,1
 2e4:	fef40593          	add	a1,s0,-17
 2e8:	fcfff0ef          	jal	2b6 <write>
}
 2ec:	60e2                	ld	ra,24(sp)
 2ee:	6442                	ld	s0,16(sp)
 2f0:	6105                	add	sp,sp,32
 2f2:	8082                	ret

00000000000002f4 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 2f4:	715d                	add	sp,sp,-80
 2f6:	e486                	sd	ra,72(sp)
 2f8:	e0a2                	sd	s0,64(sp)
 2fa:	fc26                	sd	s1,56(sp)
 2fc:	f84a                	sd	s2,48(sp)
 2fe:	f44e                	sd	s3,40(sp)
 300:	0880                	add	s0,sp,80
 302:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 304:	c299                	beqz	a3,30a <printint+0x16>
 306:	0805c163          	bltz	a1,388 <printint+0x94>
  neg = 0;
 30a:	4881                	li	a7,0
 30c:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 310:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 312:	00000517          	auipc	a0,0x0
 316:	5ee50513          	add	a0,a0,1518 # 900 <digits>
 31a:	883e                	mv	a6,a5
 31c:	2785                	addw	a5,a5,1
 31e:	02c5f733          	remu	a4,a1,a2
 322:	972a                	add	a4,a4,a0
 324:	00074703          	lbu	a4,0(a4)
 328:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 32c:	872e                	mv	a4,a1
 32e:	02c5d5b3          	divu	a1,a1,a2
 332:	0685                	add	a3,a3,1
 334:	fec773e3          	bgeu	a4,a2,31a <printint+0x26>
  if(neg)
 338:	00088b63          	beqz	a7,34e <printint+0x5a>
    buf[i++] = '-';
 33c:	fd078793          	add	a5,a5,-48
 340:	97a2                	add	a5,a5,s0
 342:	02d00713          	li	a4,45
 346:	fee78423          	sb	a4,-24(a5)
 34a:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 34e:	02f05663          	blez	a5,37a <printint+0x86>
 352:	fb840713          	add	a4,s0,-72
 356:	00f704b3          	add	s1,a4,a5
 35a:	fff70993          	add	s3,a4,-1
 35e:	99be                	add	s3,s3,a5
 360:	37fd                	addw	a5,a5,-1
 362:	1782                	sll	a5,a5,0x20
 364:	9381                	srl	a5,a5,0x20
 366:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 36a:	fff4c583          	lbu	a1,-1(s1)
 36e:	854a                	mv	a0,s2
 370:	f67ff0ef          	jal	2d6 <putc>
  while(--i >= 0)
 374:	14fd                	add	s1,s1,-1
 376:	ff349ae3          	bne	s1,s3,36a <printint+0x76>
}
 37a:	60a6                	ld	ra,72(sp)
 37c:	6406                	ld	s0,64(sp)
 37e:	74e2                	ld	s1,56(sp)
 380:	7942                	ld	s2,48(sp)
 382:	79a2                	ld	s3,40(sp)
 384:	6161                	add	sp,sp,80
 386:	8082                	ret
    x = -xx;
 388:	40b005b3          	neg	a1,a1
    neg = 1;
 38c:	4885                	li	a7,1
    x = -xx;
 38e:	bfbd                	j	30c <printint+0x18>

0000000000000390 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 390:	711d                	add	sp,sp,-96
 392:	ec86                	sd	ra,88(sp)
 394:	e8a2                	sd	s0,80(sp)
 396:	e4a6                	sd	s1,72(sp)
 398:	e0ca                	sd	s2,64(sp)
 39a:	fc4e                	sd	s3,56(sp)
 39c:	f852                	sd	s4,48(sp)
 39e:	f456                	sd	s5,40(sp)
 3a0:	f05a                	sd	s6,32(sp)
 3a2:	ec5e                	sd	s7,24(sp)
 3a4:	e862                	sd	s8,16(sp)
 3a6:	e466                	sd	s9,8(sp)
 3a8:	e06a                	sd	s10,0(sp)
 3aa:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 3ac:	0005c903          	lbu	s2,0(a1)
 3b0:	26090563          	beqz	s2,61a <vprintf+0x28a>
 3b4:	8b2a                	mv	s6,a0
 3b6:	8a2e                	mv	s4,a1
 3b8:	8bb2                	mv	s7,a2
  state = 0;
 3ba:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 3bc:	4481                	li	s1,0
 3be:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 3c0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 3c4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 3c8:	06c00c93          	li	s9,108
 3cc:	a005                	j	3ec <vprintf+0x5c>
        putc(fd, c0);
 3ce:	85ca                	mv	a1,s2
 3d0:	855a                	mv	a0,s6
 3d2:	f05ff0ef          	jal	2d6 <putc>
 3d6:	a019                	j	3dc <vprintf+0x4c>
    } else if(state == '%'){
 3d8:	03598263          	beq	s3,s5,3fc <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 3dc:	2485                	addw	s1,s1,1
 3de:	8726                	mv	a4,s1
 3e0:	009a07b3          	add	a5,s4,s1
 3e4:	0007c903          	lbu	s2,0(a5)
 3e8:	22090963          	beqz	s2,61a <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 3ec:	0009079b          	sext.w	a5,s2
    if(state == 0){
 3f0:	fe0994e3          	bnez	s3,3d8 <vprintf+0x48>
      if(c0 == '%'){
 3f4:	fd579de3          	bne	a5,s5,3ce <vprintf+0x3e>
        state = '%';
 3f8:	89be                	mv	s3,a5
 3fa:	b7cd                	j	3dc <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 3fc:	cbc9                	beqz	a5,48e <vprintf+0xfe>
 3fe:	00ea06b3          	add	a3,s4,a4
 402:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 406:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 408:	c681                	beqz	a3,410 <vprintf+0x80>
 40a:	9752                	add	a4,a4,s4
 40c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 410:	05878363          	beq	a5,s8,456 <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 414:	05978d63          	beq	a5,s9,46e <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 418:	07500713          	li	a4,117
 41c:	0ee78763          	beq	a5,a4,50a <vprintf+0x17a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 420:	07800713          	li	a4,120
 424:	12e78963          	beq	a5,a4,556 <vprintf+0x1c6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 428:	07000713          	li	a4,112
 42c:	14e78e63          	beq	a5,a4,588 <vprintf+0x1f8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 430:	06300713          	li	a4,99
 434:	18e78c63          	beq	a5,a4,5cc <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 438:	07300713          	li	a4,115
 43c:	1ae78263          	beq	a5,a4,5e0 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 440:	02500713          	li	a4,37
 444:	04e79563          	bne	a5,a4,48e <vprintf+0xfe>
        putc(fd, '%');
 448:	02500593          	li	a1,37
 44c:	855a                	mv	a0,s6
 44e:	e89ff0ef          	jal	2d6 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 452:	4981                	li	s3,0
 454:	b761                	j	3dc <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 456:	008b8913          	add	s2,s7,8
 45a:	4685                	li	a3,1
 45c:	4629                	li	a2,10
 45e:	000ba583          	lw	a1,0(s7)
 462:	855a                	mv	a0,s6
 464:	e91ff0ef          	jal	2f4 <printint>
 468:	8bca                	mv	s7,s2
      state = 0;
 46a:	4981                	li	s3,0
 46c:	bf85                	j	3dc <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 46e:	06400793          	li	a5,100
 472:	02f68963          	beq	a3,a5,4a4 <vprintf+0x114>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 476:	06c00793          	li	a5,108
 47a:	04f68263          	beq	a3,a5,4be <vprintf+0x12e>
      } else if(c0 == 'l' && c1 == 'u'){
 47e:	07500793          	li	a5,117
 482:	0af68063          	beq	a3,a5,522 <vprintf+0x192>
      } else if(c0 == 'l' && c1 == 'x'){
 486:	07800793          	li	a5,120
 48a:	0ef68263          	beq	a3,a5,56e <vprintf+0x1de>
        putc(fd, '%');
 48e:	02500593          	li	a1,37
 492:	855a                	mv	a0,s6
 494:	e43ff0ef          	jal	2d6 <putc>
        putc(fd, c0);
 498:	85ca                	mv	a1,s2
 49a:	855a                	mv	a0,s6
 49c:	e3bff0ef          	jal	2d6 <putc>
      state = 0;
 4a0:	4981                	li	s3,0
 4a2:	bf2d                	j	3dc <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4a4:	008b8913          	add	s2,s7,8
 4a8:	4685                	li	a3,1
 4aa:	4629                	li	a2,10
 4ac:	000bb583          	ld	a1,0(s7)
 4b0:	855a                	mv	a0,s6
 4b2:	e43ff0ef          	jal	2f4 <printint>
        i += 1;
 4b6:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 4b8:	8bca                	mv	s7,s2
      state = 0;
 4ba:	4981                	li	s3,0
        i += 1;
 4bc:	b705                	j	3dc <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4be:	06400793          	li	a5,100
 4c2:	02f60763          	beq	a2,a5,4f0 <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 4c6:	07500793          	li	a5,117
 4ca:	06f60963          	beq	a2,a5,53c <vprintf+0x1ac>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 4ce:	07800793          	li	a5,120
 4d2:	faf61ee3          	bne	a2,a5,48e <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 4d6:	008b8913          	add	s2,s7,8
 4da:	4681                	li	a3,0
 4dc:	4641                	li	a2,16
 4de:	000bb583          	ld	a1,0(s7)
 4e2:	855a                	mv	a0,s6
 4e4:	e11ff0ef          	jal	2f4 <printint>
        i += 2;
 4e8:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 4ea:	8bca                	mv	s7,s2
      state = 0;
 4ec:	4981                	li	s3,0
        i += 2;
 4ee:	b5fd                	j	3dc <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4f0:	008b8913          	add	s2,s7,8
 4f4:	4685                	li	a3,1
 4f6:	4629                	li	a2,10
 4f8:	000bb583          	ld	a1,0(s7)
 4fc:	855a                	mv	a0,s6
 4fe:	df7ff0ef          	jal	2f4 <printint>
        i += 2;
 502:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 504:	8bca                	mv	s7,s2
      state = 0;
 506:	4981                	li	s3,0
        i += 2;
 508:	bdd1                	j	3dc <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 10, 0);
 50a:	008b8913          	add	s2,s7,8
 50e:	4681                	li	a3,0
 510:	4629                	li	a2,10
 512:	000be583          	lwu	a1,0(s7)
 516:	855a                	mv	a0,s6
 518:	dddff0ef          	jal	2f4 <printint>
 51c:	8bca                	mv	s7,s2
      state = 0;
 51e:	4981                	li	s3,0
 520:	bd75                	j	3dc <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 522:	008b8913          	add	s2,s7,8
 526:	4681                	li	a3,0
 528:	4629                	li	a2,10
 52a:	000bb583          	ld	a1,0(s7)
 52e:	855a                	mv	a0,s6
 530:	dc5ff0ef          	jal	2f4 <printint>
        i += 1;
 534:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 536:	8bca                	mv	s7,s2
      state = 0;
 538:	4981                	li	s3,0
        i += 1;
 53a:	b54d                	j	3dc <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 53c:	008b8913          	add	s2,s7,8
 540:	4681                	li	a3,0
 542:	4629                	li	a2,10
 544:	000bb583          	ld	a1,0(s7)
 548:	855a                	mv	a0,s6
 54a:	dabff0ef          	jal	2f4 <printint>
        i += 2;
 54e:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 550:	8bca                	mv	s7,s2
      state = 0;
 552:	4981                	li	s3,0
        i += 2;
 554:	b561                	j	3dc <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 16, 0);
 556:	008b8913          	add	s2,s7,8
 55a:	4681                	li	a3,0
 55c:	4641                	li	a2,16
 55e:	000be583          	lwu	a1,0(s7)
 562:	855a                	mv	a0,s6
 564:	d91ff0ef          	jal	2f4 <printint>
 568:	8bca                	mv	s7,s2
      state = 0;
 56a:	4981                	li	s3,0
 56c:	bd85                	j	3dc <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 56e:	008b8913          	add	s2,s7,8
 572:	4681                	li	a3,0
 574:	4641                	li	a2,16
 576:	000bb583          	ld	a1,0(s7)
 57a:	855a                	mv	a0,s6
 57c:	d79ff0ef          	jal	2f4 <printint>
        i += 1;
 580:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 582:	8bca                	mv	s7,s2
      state = 0;
 584:	4981                	li	s3,0
        i += 1;
 586:	bd99                	j	3dc <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 588:	008b8d13          	add	s10,s7,8
 58c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 590:	03000593          	li	a1,48
 594:	855a                	mv	a0,s6
 596:	d41ff0ef          	jal	2d6 <putc>
  putc(fd, 'x');
 59a:	07800593          	li	a1,120
 59e:	855a                	mv	a0,s6
 5a0:	d37ff0ef          	jal	2d6 <putc>
 5a4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5a6:	00000b97          	auipc	s7,0x0
 5aa:	35ab8b93          	add	s7,s7,858 # 900 <digits>
 5ae:	03c9d793          	srl	a5,s3,0x3c
 5b2:	97de                	add	a5,a5,s7
 5b4:	0007c583          	lbu	a1,0(a5)
 5b8:	855a                	mv	a0,s6
 5ba:	d1dff0ef          	jal	2d6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5be:	0992                	sll	s3,s3,0x4
 5c0:	397d                	addw	s2,s2,-1
 5c2:	fe0916e3          	bnez	s2,5ae <vprintf+0x21e>
        printptr(fd, va_arg(ap, uint64));
 5c6:	8bea                	mv	s7,s10
      state = 0;
 5c8:	4981                	li	s3,0
 5ca:	bd09                	j	3dc <vprintf+0x4c>
        putc(fd, va_arg(ap, uint32));
 5cc:	008b8913          	add	s2,s7,8
 5d0:	000bc583          	lbu	a1,0(s7)
 5d4:	855a                	mv	a0,s6
 5d6:	d01ff0ef          	jal	2d6 <putc>
 5da:	8bca                	mv	s7,s2
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	bbfd                	j	3dc <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 5e0:	008b8993          	add	s3,s7,8
 5e4:	000bb903          	ld	s2,0(s7)
 5e8:	00090f63          	beqz	s2,606 <vprintf+0x276>
        for(; *s; s++)
 5ec:	00094583          	lbu	a1,0(s2)
 5f0:	c195                	beqz	a1,614 <vprintf+0x284>
          putc(fd, *s);
 5f2:	855a                	mv	a0,s6
 5f4:	ce3ff0ef          	jal	2d6 <putc>
        for(; *s; s++)
 5f8:	0905                	add	s2,s2,1
 5fa:	00094583          	lbu	a1,0(s2)
 5fe:	f9f5                	bnez	a1,5f2 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 600:	8bce                	mv	s7,s3
      state = 0;
 602:	4981                	li	s3,0
 604:	bbe1                	j	3dc <vprintf+0x4c>
          s = "(null)";
 606:	00000917          	auipc	s2,0x0
 60a:	2f290913          	add	s2,s2,754 # 8f8 <printf+0x298>
        for(; *s; s++)
 60e:	02800593          	li	a1,40
 612:	b7c5                	j	5f2 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 614:	8bce                	mv	s7,s3
      state = 0;
 616:	4981                	li	s3,0
 618:	b3d1                	j	3dc <vprintf+0x4c>
    }
  }
}
 61a:	60e6                	ld	ra,88(sp)
 61c:	6446                	ld	s0,80(sp)
 61e:	64a6                	ld	s1,72(sp)
 620:	6906                	ld	s2,64(sp)
 622:	79e2                	ld	s3,56(sp)
 624:	7a42                	ld	s4,48(sp)
 626:	7aa2                	ld	s5,40(sp)
 628:	7b02                	ld	s6,32(sp)
 62a:	6be2                	ld	s7,24(sp)
 62c:	6c42                	ld	s8,16(sp)
 62e:	6ca2                	ld	s9,8(sp)
 630:	6d02                	ld	s10,0(sp)
 632:	6125                	add	sp,sp,96
 634:	8082                	ret

0000000000000636 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 636:	715d                	add	sp,sp,-80
 638:	ec06                	sd	ra,24(sp)
 63a:	e822                	sd	s0,16(sp)
 63c:	1000                	add	s0,sp,32
 63e:	e010                	sd	a2,0(s0)
 640:	e414                	sd	a3,8(s0)
 642:	e818                	sd	a4,16(s0)
 644:	ec1c                	sd	a5,24(s0)
 646:	03043023          	sd	a6,32(s0)
 64a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 64e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 652:	8622                	mv	a2,s0
 654:	d3dff0ef          	jal	390 <vprintf>
}
 658:	60e2                	ld	ra,24(sp)
 65a:	6442                	ld	s0,16(sp)
 65c:	6161                	add	sp,sp,80
 65e:	8082                	ret

0000000000000660 <printf>:

void
printf(const char *fmt, ...)
{
 660:	711d                	add	sp,sp,-96
 662:	ec06                	sd	ra,24(sp)
 664:	e822                	sd	s0,16(sp)
 666:	1000                	add	s0,sp,32
 668:	e40c                	sd	a1,8(s0)
 66a:	e810                	sd	a2,16(s0)
 66c:	ec14                	sd	a3,24(s0)
 66e:	f018                	sd	a4,32(s0)
 670:	f41c                	sd	a5,40(s0)
 672:	03043823          	sd	a6,48(s0)
 676:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 67a:	00840613          	add	a2,s0,8
 67e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 682:	85aa                	mv	a1,a0
 684:	4505                	li	a0,1
 686:	d0bff0ef          	jal	390 <vprintf>
 68a:	60e2                	ld	ra,24(sp)
 68c:	6442                	ld	s0,16(sp)
 68e:	6125                	add	sp,sp,96
 690:	8082                	ret
