
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
  12:	79250513          	add	a0,a0,1938 # 7a0 <printf+0x36>
  16:	754000ef          	jal	76a <printf>

    int count = 0;
  1a:	4481                	li	s1,0
    for(int i = 0; i < NPROCS; i++){
  1c:	03c00913          	li	s2,60
        int pid = fork();
  20:	360000ef          	jal	380 <fork>
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
  38:	79450513          	add	a0,a0,1940 # 7c8 <printf+0x5e>
  3c:	72e000ef          	jal	76a <printf>

    printf("清理测试\n");
  40:	00000517          	auipc	a0,0x0
  44:	7a850513          	add	a0,a0,1960 # 7e8 <printf+0x7e>
  48:	722000ef          	jal	76a <printf>

    int i;
    for( i = 0; i < count; i++){
  4c:	a805                	j	7c <test_processing+0x7c>
            printf("Fork失败 at %d\n", i);
  4e:	85a6                	mv	a1,s1
  50:	00000517          	auipc	a0,0x0
  54:	76050513          	add	a0,a0,1888 # 7b0 <printf+0x46>
  58:	712000ef          	jal	76a <printf>
    printf("创建了 %d 个子进程\n", count);
  5c:	85a6                	mv	a1,s1
  5e:	00000517          	auipc	a0,0x0
  62:	76a50513          	add	a0,a0,1898 # 7c8 <printf+0x5e>
  66:	704000ef          	jal	76a <printf>
    printf("清理测试\n");
  6a:	00000517          	auipc	a0,0x0
  6e:	77e50513          	add	a0,a0,1918 # 7e8 <printf+0x7e>
  72:	6f8000ef          	jal	76a <printf>
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
  82:	79a98993          	add	s3,s3,1946 # 818 <printf+0xae>
        int tmppid = 0 ;
  86:	fa042823          	sw	zero,-80(s0)
        int wpid = wait(&tmppid);
  8a:	fb040513          	add	a0,s0,-80
  8e:	2fa000ef          	jal	388 <wait>
  92:	85aa                	mv	a1,a0
        if(wpid < 0){
  94:	04054c63          	bltz	a0,ec <test_processing+0xec>
            printf("子进程 %d 已退出，状态 %d\n", wpid, tmppid);
  98:	fb042603          	lw	a2,-80(s0)
  9c:	854e                	mv	a0,s3
  9e:	6cc000ef          	jal	76a <printf>
    for( i = 0; i < count; i++){
  a2:	2905                	addw	s2,s2,1
  a4:	fe9911e3          	bne	s2,s1,86 <test_processing+0x86>
        }
    }

    if(count == i){
        printf("所有的子进程全部退出\n");
  a8:	00000517          	auipc	a0,0x0
  ac:	79850513          	add	a0,a0,1944 # 840 <printf+0xd6>
  b0:	6ba000ef          	jal	76a <printf>
  b4:	a891                	j	108 <test_processing+0x108>
            exec("test", (char *[]){"test", "arg1", "arg2", 0});
  b6:	00001797          	auipc	a5,0x1
  ba:	90a78793          	add	a5,a5,-1782 # 9c0 <printf+0x256>
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
  de:	71e50513          	add	a0,a0,1822 # 7f8 <printf+0x8e>
  e2:	2ae000ef          	jal	390 <exec>
            exit(0);
  e6:	4501                	li	a0,0
  e8:	290000ef          	jal	378 <exit>
            printf("等待子进程失败\n");
  ec:	00000517          	auipc	a0,0x0
  f0:	71450513          	add	a0,a0,1812 # 800 <printf+0x96>
  f4:	676000ef          	jal	76a <printf>
    if(count == i){
  f8:	fa9908e3          	beq	s2,s1,a8 <test_processing+0xa8>
    } else {
        printf("所有子进程已清理完毕\n");
  fc:	00000517          	auipc	a0,0x0
 100:	76450513          	add	a0,a0,1892 # 860 <printf+0xf6>
 104:	666000ef          	jal	76a <printf>
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
 128:	288000ef          	jal	3b0 <write>
    if(res == 0){
 12c:	0c051c63          	bnez	a0,204 <test_write_and_ptr+0xee>
        printf("写入无效指针测试通过\n");
 130:	00000517          	auipc	a0,0x0
 134:	75050513          	add	a0,a0,1872 # 880 <printf+0x116>
 138:	632000ef          	jal	76a <printf>
    } else {
        printf("写入无效指针测试失败\n");
        printf("错误码: %d\n", res);
    }

    char buffer[20] = "Hello, RISC-V!";
 13c:	00001797          	auipc	a5,0x1
 140:	88478793          	add	a5,a5,-1916 # 9c0 <printf+0x256>
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
 17c:	234000ef          	jal	3b0 <write>
 180:	84aa                	mv	s1,a0
    if(res == -1){
 182:	57fd                	li	a5,-1
 184:	08f50f63          	beq	a0,a5,222 <test_write_and_ptr+0x10c>
        printf("写入无效文件描述符测试通过\n");
    } else {
        printf("写入无效文件描述符测试失败\n");
 188:	00000517          	auipc	a0,0x0
 18c:	77850513          	add	a0,a0,1912 # 900 <printf+0x196>
 190:	5da000ef          	jal	76a <printf>
        printf("错误码: %d\n", res);
 194:	85a6                	mv	a1,s1
 196:	00000517          	auipc	a0,0x0
 19a:	72a50513          	add	a0,a0,1834 # 8c0 <printf+0x156>
 19e:	5cc000ef          	jal	76a <printf>
    }

    // 控指针
    res = write(1, 0, 10);
 1a2:	4629                	li	a2,10
 1a4:	4581                	li	a1,0
 1a6:	4505                	li	a0,1
 1a8:	208000ef          	jal	3b0 <write>
 1ac:	84aa                	mv	s1,a0

    if(res == -1){
 1ae:	57fd                	li	a5,-1
 1b0:	08f50063          	beq	a0,a5,230 <test_write_and_ptr+0x11a>
        printf("写入空指针测试通过\n");
    } else {
        printf("写入空指针测试失败\n");
 1b4:	00000517          	auipc	a0,0x0
 1b8:	79c50513          	add	a0,a0,1948 # 950 <printf+0x1e6>
 1bc:	5ae000ef          	jal	76a <printf>
        printf("错误码: %d\n", res);
 1c0:	85a6                	mv	a1,s1
 1c2:	00000517          	auipc	a0,0x0
 1c6:	6fe50513          	add	a0,a0,1790 # 8c0 <printf+0x156>
 1ca:	5a0000ef          	jal	76a <printf>
    }

    res = write(1, buffer, -5);
 1ce:	566d                	li	a2,-5
 1d0:	fc840593          	add	a1,s0,-56
 1d4:	4505                	li	a0,1
 1d6:	1da000ef          	jal	3b0 <write>
 1da:	84aa                	mv	s1,a0
    if(res <= 0){
 1dc:	06a05163          	blez	a0,23e <test_write_and_ptr+0x128>
        printf("写入负长度测试通过\n");
    } else {
        printf("写入负长度测试失败\n");
 1e0:	00000517          	auipc	a0,0x0
 1e4:	7b050513          	add	a0,a0,1968 # 990 <printf+0x226>
 1e8:	582000ef          	jal	76a <printf>
        printf("错误码: %d\n", res);
 1ec:	85a6                	mv	a1,s1
 1ee:	00000517          	auipc	a0,0x0
 1f2:	6d250513          	add	a0,a0,1746 # 8c0 <printf+0x156>
 1f6:	574000ef          	jal	76a <printf>
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
 20a:	69a50513          	add	a0,a0,1690 # 8a0 <printf+0x136>
 20e:	55c000ef          	jal	76a <printf>
        printf("错误码: %d\n", res);
 212:	85a6                	mv	a1,s1
 214:	00000517          	auipc	a0,0x0
 218:	6ac50513          	add	a0,a0,1708 # 8c0 <printf+0x156>
 21c:	54e000ef          	jal	76a <printf>
 220:	bf31                	j	13c <test_write_and_ptr+0x26>
        printf("写入无效文件描述符测试通过\n");
 222:	00000517          	auipc	a0,0x0
 226:	6ae50513          	add	a0,a0,1710 # 8d0 <printf+0x166>
 22a:	540000ef          	jal	76a <printf>
 22e:	bf95                	j	1a2 <test_write_and_ptr+0x8c>
        printf("写入空指针测试通过\n");
 230:	00000517          	auipc	a0,0x0
 234:	70050513          	add	a0,a0,1792 # 930 <printf+0x1c6>
 238:	532000ef          	jal	76a <printf>
 23c:	bf49                	j	1ce <test_write_and_ptr+0xb8>
        printf("写入负长度测试通过\n");
 23e:	00000517          	auipc	a0,0x0
 242:	73250513          	add	a0,a0,1842 # 970 <printf+0x206>
 246:	524000ef          	jal	76a <printf>
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
 272:	106000ef          	jal	378 <exit>

0000000000000276 <itoa>:
{
  char temp[16];
  int i = 0;
  int j = 0;

  if (n == 0) {
 276:	cd25                	beqz	a0,2ee <itoa+0x78>
{
 278:	1101                	add	sp,sp,-32
 27a:	ec22                	sd	s0,24(sp)
 27c:	1000                	add	s0,sp,32
    buf[1] = '\0';
    return;
  }
  
  // Generate digits in reverse order
  while (n > 0) {
 27e:	fe040693          	add	a3,s0,-32
  int i = 0;
 282:	4701                	li	a4,0
    temp[i++] = (n % 10) + '0';
 284:	4829                	li	a6,10
  while (n > 0) {
 286:	48a5                	li	a7,9
    n /= 10;
  }
  temp[i] = '\0';

  // Reverse the string to get the correct order
  for (j = 0; j < i; j++) {
 288:	4601                	li	a2,0
  while (n > 0) {
 28a:	04a05c63          	blez	a0,2e2 <itoa+0x6c>
    temp[i++] = (n % 10) + '0';
 28e:	863a                	mv	a2,a4
 290:	2705                	addw	a4,a4,1
 292:	030567bb          	remw	a5,a0,a6
 296:	0307879b          	addw	a5,a5,48
 29a:	00f68023          	sb	a5,0(a3)
    n /= 10;
 29e:	87aa                	mv	a5,a0
 2a0:	0305453b          	divw	a0,a0,a6
  while (n > 0) {
 2a4:	0685                	add	a3,a3,1
 2a6:	fef8c4e3          	blt	a7,a5,28e <itoa+0x18>
  temp[i] = '\0';
 2aa:	ff070793          	add	a5,a4,-16
 2ae:	97a2                	add	a5,a5,s0
 2b0:	fe078823          	sb	zero,-16(a5)
  for (j = 0; j < i; j++) {
 2b4:	04e05463          	blez	a4,2fc <itoa+0x86>
 2b8:	fe040793          	add	a5,s0,-32
 2bc:	00c786b3          	add	a3,a5,a2
 2c0:	87ae                	mv	a5,a1
    buf[j] = temp[i - 1 - j];
 2c2:	0006c703          	lbu	a4,0(a3)
 2c6:	00e78023          	sb	a4,0(a5)
  for (j = 0; j < i; j++) {
 2ca:	16fd                	add	a3,a3,-1
 2cc:	0785                	add	a5,a5,1
 2ce:	40b7873b          	subw	a4,a5,a1
 2d2:	377d                	addw	a4,a4,-1
 2d4:	fec747e3          	blt	a4,a2,2c2 <itoa+0x4c>
 2d8:	fff64793          	not	a5,a2
 2dc:	97fd                	sra	a5,a5,0x3f
 2de:	8e7d                	and	a2,a2,a5
 2e0:	2605                	addw	a2,a2,1
  }
  buf[j] = '\0';
 2e2:	95b2                	add	a1,a1,a2
 2e4:	00058023          	sb	zero,0(a1)
}
 2e8:	6462                	ld	s0,24(sp)
 2ea:	6105                	add	sp,sp,32
 2ec:	8082                	ret
    buf[0] = '0';
 2ee:	03000793          	li	a5,48
 2f2:	00f58023          	sb	a5,0(a1)
    buf[1] = '\0';
 2f6:	000580a3          	sb	zero,1(a1)
    return;
 2fa:	8082                	ret
  for (j = 0; j < i; j++) {
 2fc:	4601                	li	a2,0
 2fe:	b7d5                	j	2e2 <itoa+0x6c>

0000000000000300 <strcpy>:

void strcpy(char *dst, const char *src) {
 300:	1141                	add	sp,sp,-16
 302:	e422                	sd	s0,8(sp)
 304:	0800                	add	s0,sp,16
    while ((*dst++ = *src++) != '\0');
 306:	0585                	add	a1,a1,1
 308:	0505                	add	a0,a0,1
 30a:	fff5c783          	lbu	a5,-1(a1)
 30e:	fef50fa3          	sb	a5,-1(a0)
 312:	fbf5                	bnez	a5,306 <strcpy+0x6>
} 
 314:	6422                	ld	s0,8(sp)
 316:	0141                	add	sp,sp,16
 318:	8082                	ret

000000000000031a <strlen>:

uint
strlen(const char *s){
 31a:	1141                	add	sp,sp,-16
 31c:	e422                	sd	s0,8(sp)
 31e:	0800                	add	s0,sp,16
  int n;
  for(n = 0; s[n]; n++);
 320:	00054783          	lbu	a5,0(a0)
 324:	cf91                	beqz	a5,340 <strlen+0x26>
 326:	0505                	add	a0,a0,1
 328:	87aa                	mv	a5,a0
 32a:	86be                	mv	a3,a5
 32c:	0785                	add	a5,a5,1
 32e:	fff7c703          	lbu	a4,-1(a5)
 332:	ff65                	bnez	a4,32a <strlen+0x10>
 334:	40a6853b          	subw	a0,a3,a0
 338:	2505                	addw	a0,a0,1
  return n;
}
 33a:	6422                	ld	s0,8(sp)
 33c:	0141                	add	sp,sp,16
 33e:	8082                	ret
  for(n = 0; s[n]; n++);
 340:	4501                	li	a0,0
 342:	bfe5                	j	33a <strlen+0x20>

0000000000000344 <strcmp>:

uint
strcmp(const char *p, const char *q)
{
 344:	1141                	add	sp,sp,-16
 346:	e422                	sd	s0,8(sp)
 348:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 34a:	00054783          	lbu	a5,0(a0)
 34e:	cb91                	beqz	a5,362 <strcmp+0x1e>
 350:	0005c703          	lbu	a4,0(a1)
 354:	00f71763          	bne	a4,a5,362 <strcmp+0x1e>
    p++, q++;
 358:	0505                	add	a0,a0,1
 35a:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 35c:	00054783          	lbu	a5,0(a0)
 360:	fbe5                	bnez	a5,350 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 362:	0005c503          	lbu	a0,0(a1)
}
 366:	40a7853b          	subw	a0,a5,a0
 36a:	6422                	ld	s0,8(sp)
 36c:	0141                	add	sp,sp,16
 36e:	8082                	ret

0000000000000370 <hello>:
# generated by usys.pl - do not edit
#include "include/syscall.h"
.global hello
hello:
 li a7, SYS_hello
 370:	4885                	li	a7,1
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <exit>:
.global exit
exit:
 li a7, SYS_exit
 378:	4889                	li	a7,2
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <fork>:
.global fork
fork:
 li a7, SYS_fork
 380:	4891                	li	a7,4
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <wait>:
.global wait
wait:
 li a7, SYS_wait
 388:	488d                	li	a7,3
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <exec>:
.global exec
exec:
 li a7, SYS_exec
 390:	4895                	li	a7,5
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <dup>:
.global dup
dup:
 li a7, SYS_dup
 398:	489d                	li	a7,7
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <open>:
.global open
open:
 li a7, SYS_open
 3a0:	4899                	li	a7,6
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3a8:	48a1                	li	a7,8
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <write>:
.global write
write:
 li a7, SYS_write
 3b0:	48a5                	li	a7,9
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <read>:
.global read
read:
 li a7, SYS_read
 3b8:	48a9                	li	a7,10
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <close>:
.global close
close:
 li a7, SYS_close
 3c0:	48ad                	li	a7,11
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3c8:	48b1                	li	a7,12
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3d0:	48b5                	li	a7,13
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3d8:	48b9                	li	a7,14
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3e0:	1101                	add	sp,sp,-32
 3e2:	ec06                	sd	ra,24(sp)
 3e4:	e822                	sd	s0,16(sp)
 3e6:	1000                	add	s0,sp,32
 3e8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ec:	4605                	li	a2,1
 3ee:	fef40593          	add	a1,s0,-17
 3f2:	fbfff0ef          	jal	3b0 <write>
}
 3f6:	60e2                	ld	ra,24(sp)
 3f8:	6442                	ld	s0,16(sp)
 3fa:	6105                	add	sp,sp,32
 3fc:	8082                	ret

00000000000003fe <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3fe:	715d                	add	sp,sp,-80
 400:	e486                	sd	ra,72(sp)
 402:	e0a2                	sd	s0,64(sp)
 404:	fc26                	sd	s1,56(sp)
 406:	f84a                	sd	s2,48(sp)
 408:	f44e                	sd	s3,40(sp)
 40a:	0880                	add	s0,sp,80
 40c:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 40e:	c299                	beqz	a3,414 <printint+0x16>
 410:	0805c163          	bltz	a1,492 <printint+0x94>
  neg = 0;
 414:	4881                	li	a7,0
 416:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 41a:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 41c:	00000517          	auipc	a0,0x0
 420:	5e450513          	add	a0,a0,1508 # a00 <digits>
 424:	883e                	mv	a6,a5
 426:	2785                	addw	a5,a5,1
 428:	02c5f733          	remu	a4,a1,a2
 42c:	972a                	add	a4,a4,a0
 42e:	00074703          	lbu	a4,0(a4)
 432:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 436:	872e                	mv	a4,a1
 438:	02c5d5b3          	divu	a1,a1,a2
 43c:	0685                	add	a3,a3,1
 43e:	fec773e3          	bgeu	a4,a2,424 <printint+0x26>
  if(neg)
 442:	00088b63          	beqz	a7,458 <printint+0x5a>
    buf[i++] = '-';
 446:	fd078793          	add	a5,a5,-48
 44a:	97a2                	add	a5,a5,s0
 44c:	02d00713          	li	a4,45
 450:	fee78423          	sb	a4,-24(a5)
 454:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 458:	02f05663          	blez	a5,484 <printint+0x86>
 45c:	fb840713          	add	a4,s0,-72
 460:	00f704b3          	add	s1,a4,a5
 464:	fff70993          	add	s3,a4,-1
 468:	99be                	add	s3,s3,a5
 46a:	37fd                	addw	a5,a5,-1
 46c:	1782                	sll	a5,a5,0x20
 46e:	9381                	srl	a5,a5,0x20
 470:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 474:	fff4c583          	lbu	a1,-1(s1)
 478:	854a                	mv	a0,s2
 47a:	f67ff0ef          	jal	3e0 <putc>
  while(--i >= 0)
 47e:	14fd                	add	s1,s1,-1
 480:	ff349ae3          	bne	s1,s3,474 <printint+0x76>
}
 484:	60a6                	ld	ra,72(sp)
 486:	6406                	ld	s0,64(sp)
 488:	74e2                	ld	s1,56(sp)
 48a:	7942                	ld	s2,48(sp)
 48c:	79a2                	ld	s3,40(sp)
 48e:	6161                	add	sp,sp,80
 490:	8082                	ret
    x = -xx;
 492:	40b005b3          	neg	a1,a1
    neg = 1;
 496:	4885                	li	a7,1
    x = -xx;
 498:	bfbd                	j	416 <printint+0x18>

000000000000049a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 49a:	711d                	add	sp,sp,-96
 49c:	ec86                	sd	ra,88(sp)
 49e:	e8a2                	sd	s0,80(sp)
 4a0:	e4a6                	sd	s1,72(sp)
 4a2:	e0ca                	sd	s2,64(sp)
 4a4:	fc4e                	sd	s3,56(sp)
 4a6:	f852                	sd	s4,48(sp)
 4a8:	f456                	sd	s5,40(sp)
 4aa:	f05a                	sd	s6,32(sp)
 4ac:	ec5e                	sd	s7,24(sp)
 4ae:	e862                	sd	s8,16(sp)
 4b0:	e466                	sd	s9,8(sp)
 4b2:	e06a                	sd	s10,0(sp)
 4b4:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4b6:	0005c903          	lbu	s2,0(a1)
 4ba:	26090563          	beqz	s2,724 <vprintf+0x28a>
 4be:	8b2a                	mv	s6,a0
 4c0:	8a2e                	mv	s4,a1
 4c2:	8bb2                	mv	s7,a2
  state = 0;
 4c4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4c6:	4481                	li	s1,0
 4c8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4ca:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4ce:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4d2:	06c00c93          	li	s9,108
 4d6:	a005                	j	4f6 <vprintf+0x5c>
        putc(fd, c0);
 4d8:	85ca                	mv	a1,s2
 4da:	855a                	mv	a0,s6
 4dc:	f05ff0ef          	jal	3e0 <putc>
 4e0:	a019                	j	4e6 <vprintf+0x4c>
    } else if(state == '%'){
 4e2:	03598263          	beq	s3,s5,506 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 4e6:	2485                	addw	s1,s1,1
 4e8:	8726                	mv	a4,s1
 4ea:	009a07b3          	add	a5,s4,s1
 4ee:	0007c903          	lbu	s2,0(a5)
 4f2:	22090963          	beqz	s2,724 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 4f6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4fa:	fe0994e3          	bnez	s3,4e2 <vprintf+0x48>
      if(c0 == '%'){
 4fe:	fd579de3          	bne	a5,s5,4d8 <vprintf+0x3e>
        state = '%';
 502:	89be                	mv	s3,a5
 504:	b7cd                	j	4e6 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 506:	cbc9                	beqz	a5,598 <vprintf+0xfe>
 508:	00ea06b3          	add	a3,s4,a4
 50c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 510:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 512:	c681                	beqz	a3,51a <vprintf+0x80>
 514:	9752                	add	a4,a4,s4
 516:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 51a:	05878363          	beq	a5,s8,560 <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 51e:	05978d63          	beq	a5,s9,578 <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 522:	07500713          	li	a4,117
 526:	0ee78763          	beq	a5,a4,614 <vprintf+0x17a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 52a:	07800713          	li	a4,120
 52e:	12e78963          	beq	a5,a4,660 <vprintf+0x1c6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 532:	07000713          	li	a4,112
 536:	14e78e63          	beq	a5,a4,692 <vprintf+0x1f8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 53a:	06300713          	li	a4,99
 53e:	18e78c63          	beq	a5,a4,6d6 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 542:	07300713          	li	a4,115
 546:	1ae78263          	beq	a5,a4,6ea <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 54a:	02500713          	li	a4,37
 54e:	04e79563          	bne	a5,a4,598 <vprintf+0xfe>
        putc(fd, '%');
 552:	02500593          	li	a1,37
 556:	855a                	mv	a0,s6
 558:	e89ff0ef          	jal	3e0 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 55c:	4981                	li	s3,0
 55e:	b761                	j	4e6 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 560:	008b8913          	add	s2,s7,8
 564:	4685                	li	a3,1
 566:	4629                	li	a2,10
 568:	000ba583          	lw	a1,0(s7)
 56c:	855a                	mv	a0,s6
 56e:	e91ff0ef          	jal	3fe <printint>
 572:	8bca                	mv	s7,s2
      state = 0;
 574:	4981                	li	s3,0
 576:	bf85                	j	4e6 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 578:	06400793          	li	a5,100
 57c:	02f68963          	beq	a3,a5,5ae <vprintf+0x114>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 580:	06c00793          	li	a5,108
 584:	04f68263          	beq	a3,a5,5c8 <vprintf+0x12e>
      } else if(c0 == 'l' && c1 == 'u'){
 588:	07500793          	li	a5,117
 58c:	0af68063          	beq	a3,a5,62c <vprintf+0x192>
      } else if(c0 == 'l' && c1 == 'x'){
 590:	07800793          	li	a5,120
 594:	0ef68263          	beq	a3,a5,678 <vprintf+0x1de>
        putc(fd, '%');
 598:	02500593          	li	a1,37
 59c:	855a                	mv	a0,s6
 59e:	e43ff0ef          	jal	3e0 <putc>
        putc(fd, c0);
 5a2:	85ca                	mv	a1,s2
 5a4:	855a                	mv	a0,s6
 5a6:	e3bff0ef          	jal	3e0 <putc>
      state = 0;
 5aa:	4981                	li	s3,0
 5ac:	bf2d                	j	4e6 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ae:	008b8913          	add	s2,s7,8
 5b2:	4685                	li	a3,1
 5b4:	4629                	li	a2,10
 5b6:	000bb583          	ld	a1,0(s7)
 5ba:	855a                	mv	a0,s6
 5bc:	e43ff0ef          	jal	3fe <printint>
        i += 1;
 5c0:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c2:	8bca                	mv	s7,s2
      state = 0;
 5c4:	4981                	li	s3,0
        i += 1;
 5c6:	b705                	j	4e6 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5c8:	06400793          	li	a5,100
 5cc:	02f60763          	beq	a2,a5,5fa <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5d0:	07500793          	li	a5,117
 5d4:	06f60963          	beq	a2,a5,646 <vprintf+0x1ac>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5d8:	07800793          	li	a5,120
 5dc:	faf61ee3          	bne	a2,a5,598 <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5e0:	008b8913          	add	s2,s7,8
 5e4:	4681                	li	a3,0
 5e6:	4641                	li	a2,16
 5e8:	000bb583          	ld	a1,0(s7)
 5ec:	855a                	mv	a0,s6
 5ee:	e11ff0ef          	jal	3fe <printint>
        i += 2;
 5f2:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f4:	8bca                	mv	s7,s2
      state = 0;
 5f6:	4981                	li	s3,0
        i += 2;
 5f8:	b5fd                	j	4e6 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5fa:	008b8913          	add	s2,s7,8
 5fe:	4685                	li	a3,1
 600:	4629                	li	a2,10
 602:	000bb583          	ld	a1,0(s7)
 606:	855a                	mv	a0,s6
 608:	df7ff0ef          	jal	3fe <printint>
        i += 2;
 60c:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 60e:	8bca                	mv	s7,s2
      state = 0;
 610:	4981                	li	s3,0
        i += 2;
 612:	bdd1                	j	4e6 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 10, 0);
 614:	008b8913          	add	s2,s7,8
 618:	4681                	li	a3,0
 61a:	4629                	li	a2,10
 61c:	000be583          	lwu	a1,0(s7)
 620:	855a                	mv	a0,s6
 622:	dddff0ef          	jal	3fe <printint>
 626:	8bca                	mv	s7,s2
      state = 0;
 628:	4981                	li	s3,0
 62a:	bd75                	j	4e6 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 62c:	008b8913          	add	s2,s7,8
 630:	4681                	li	a3,0
 632:	4629                	li	a2,10
 634:	000bb583          	ld	a1,0(s7)
 638:	855a                	mv	a0,s6
 63a:	dc5ff0ef          	jal	3fe <printint>
        i += 1;
 63e:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 640:	8bca                	mv	s7,s2
      state = 0;
 642:	4981                	li	s3,0
        i += 1;
 644:	b54d                	j	4e6 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 646:	008b8913          	add	s2,s7,8
 64a:	4681                	li	a3,0
 64c:	4629                	li	a2,10
 64e:	000bb583          	ld	a1,0(s7)
 652:	855a                	mv	a0,s6
 654:	dabff0ef          	jal	3fe <printint>
        i += 2;
 658:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 65a:	8bca                	mv	s7,s2
      state = 0;
 65c:	4981                	li	s3,0
        i += 2;
 65e:	b561                	j	4e6 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 16, 0);
 660:	008b8913          	add	s2,s7,8
 664:	4681                	li	a3,0
 666:	4641                	li	a2,16
 668:	000be583          	lwu	a1,0(s7)
 66c:	855a                	mv	a0,s6
 66e:	d91ff0ef          	jal	3fe <printint>
 672:	8bca                	mv	s7,s2
      state = 0;
 674:	4981                	li	s3,0
 676:	bd85                	j	4e6 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 678:	008b8913          	add	s2,s7,8
 67c:	4681                	li	a3,0
 67e:	4641                	li	a2,16
 680:	000bb583          	ld	a1,0(s7)
 684:	855a                	mv	a0,s6
 686:	d79ff0ef          	jal	3fe <printint>
        i += 1;
 68a:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 68c:	8bca                	mv	s7,s2
      state = 0;
 68e:	4981                	li	s3,0
        i += 1;
 690:	bd99                	j	4e6 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 692:	008b8d13          	add	s10,s7,8
 696:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 69a:	03000593          	li	a1,48
 69e:	855a                	mv	a0,s6
 6a0:	d41ff0ef          	jal	3e0 <putc>
  putc(fd, 'x');
 6a4:	07800593          	li	a1,120
 6a8:	855a                	mv	a0,s6
 6aa:	d37ff0ef          	jal	3e0 <putc>
 6ae:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6b0:	00000b97          	auipc	s7,0x0
 6b4:	350b8b93          	add	s7,s7,848 # a00 <digits>
 6b8:	03c9d793          	srl	a5,s3,0x3c
 6bc:	97de                	add	a5,a5,s7
 6be:	0007c583          	lbu	a1,0(a5)
 6c2:	855a                	mv	a0,s6
 6c4:	d1dff0ef          	jal	3e0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6c8:	0992                	sll	s3,s3,0x4
 6ca:	397d                	addw	s2,s2,-1
 6cc:	fe0916e3          	bnez	s2,6b8 <vprintf+0x21e>
        printptr(fd, va_arg(ap, uint64));
 6d0:	8bea                	mv	s7,s10
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	bd09                	j	4e6 <vprintf+0x4c>
        putc(fd, va_arg(ap, uint32));
 6d6:	008b8913          	add	s2,s7,8
 6da:	000bc583          	lbu	a1,0(s7)
 6de:	855a                	mv	a0,s6
 6e0:	d01ff0ef          	jal	3e0 <putc>
 6e4:	8bca                	mv	s7,s2
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	bbfd                	j	4e6 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 6ea:	008b8993          	add	s3,s7,8
 6ee:	000bb903          	ld	s2,0(s7)
 6f2:	00090f63          	beqz	s2,710 <vprintf+0x276>
        for(; *s; s++)
 6f6:	00094583          	lbu	a1,0(s2)
 6fa:	c195                	beqz	a1,71e <vprintf+0x284>
          putc(fd, *s);
 6fc:	855a                	mv	a0,s6
 6fe:	ce3ff0ef          	jal	3e0 <putc>
        for(; *s; s++)
 702:	0905                	add	s2,s2,1
 704:	00094583          	lbu	a1,0(s2)
 708:	f9f5                	bnez	a1,6fc <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 70a:	8bce                	mv	s7,s3
      state = 0;
 70c:	4981                	li	s3,0
 70e:	bbe1                	j	4e6 <vprintf+0x4c>
          s = "(null)";
 710:	00000917          	auipc	s2,0x0
 714:	2e890913          	add	s2,s2,744 # 9f8 <printf+0x28e>
        for(; *s; s++)
 718:	02800593          	li	a1,40
 71c:	b7c5                	j	6fc <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 71e:	8bce                	mv	s7,s3
      state = 0;
 720:	4981                	li	s3,0
 722:	b3d1                	j	4e6 <vprintf+0x4c>
    }
  }
}
 724:	60e6                	ld	ra,88(sp)
 726:	6446                	ld	s0,80(sp)
 728:	64a6                	ld	s1,72(sp)
 72a:	6906                	ld	s2,64(sp)
 72c:	79e2                	ld	s3,56(sp)
 72e:	7a42                	ld	s4,48(sp)
 730:	7aa2                	ld	s5,40(sp)
 732:	7b02                	ld	s6,32(sp)
 734:	6be2                	ld	s7,24(sp)
 736:	6c42                	ld	s8,16(sp)
 738:	6ca2                	ld	s9,8(sp)
 73a:	6d02                	ld	s10,0(sp)
 73c:	6125                	add	sp,sp,96
 73e:	8082                	ret

0000000000000740 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 740:	715d                	add	sp,sp,-80
 742:	ec06                	sd	ra,24(sp)
 744:	e822                	sd	s0,16(sp)
 746:	1000                	add	s0,sp,32
 748:	e010                	sd	a2,0(s0)
 74a:	e414                	sd	a3,8(s0)
 74c:	e818                	sd	a4,16(s0)
 74e:	ec1c                	sd	a5,24(s0)
 750:	03043023          	sd	a6,32(s0)
 754:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 758:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 75c:	8622                	mv	a2,s0
 75e:	d3dff0ef          	jal	49a <vprintf>
}
 762:	60e2                	ld	ra,24(sp)
 764:	6442                	ld	s0,16(sp)
 766:	6161                	add	sp,sp,80
 768:	8082                	ret

000000000000076a <printf>:

void
printf(const char *fmt, ...)
{
 76a:	711d                	add	sp,sp,-96
 76c:	ec06                	sd	ra,24(sp)
 76e:	e822                	sd	s0,16(sp)
 770:	1000                	add	s0,sp,32
 772:	e40c                	sd	a1,8(s0)
 774:	e810                	sd	a2,16(s0)
 776:	ec14                	sd	a3,24(s0)
 778:	f018                	sd	a4,32(s0)
 77a:	f41c                	sd	a5,40(s0)
 77c:	03043823          	sd	a6,48(s0)
 780:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 784:	00840613          	add	a2,s0,8
 788:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 78c:	85aa                	mv	a1,a0
 78e:	4505                	li	a0,1
 790:	d0bff0ef          	jal	49a <vprintf>
 794:	60e2                	ld	ra,24(sp)
 796:	6442                	ld	s0,16(sp)
 798:	6125                	add	sp,sp,96
 79a:	8082                	ret
