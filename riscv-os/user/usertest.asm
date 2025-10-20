
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
  12:	7e250513          	add	a0,a0,2018 # 7f0 <printf+0x36>
  16:	7a4000ef          	jal	7ba <printf>

    int count = 0;
  1a:	4481                	li	s1,0
    for(int i = 0; i < NPROCS; i++){
  1c:	03c00913          	li	s2,60
        int pid = fork();
  20:	3a8000ef          	jal	3c8 <fork>
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
  38:	7e450513          	add	a0,a0,2020 # 818 <printf+0x5e>
  3c:	77e000ef          	jal	7ba <printf>

    printf("清理测试\n");
  40:	00000517          	auipc	a0,0x0
  44:	7f850513          	add	a0,a0,2040 # 838 <printf+0x7e>
  48:	772000ef          	jal	7ba <printf>

    int i;
    for( i = 0; i < count; i++){
  4c:	a805                	j	7c <test_processing+0x7c>
            printf("Fork失败 at %d\n", i);
  4e:	85a6                	mv	a1,s1
  50:	00000517          	auipc	a0,0x0
  54:	7b050513          	add	a0,a0,1968 # 800 <printf+0x46>
  58:	762000ef          	jal	7ba <printf>
    printf("创建了 %d 个子进程\n", count);
  5c:	85a6                	mv	a1,s1
  5e:	00000517          	auipc	a0,0x0
  62:	7ba50513          	add	a0,a0,1978 # 818 <printf+0x5e>
  66:	754000ef          	jal	7ba <printf>
    printf("清理测试\n");
  6a:	00000517          	auipc	a0,0x0
  6e:	7ce50513          	add	a0,a0,1998 # 838 <printf+0x7e>
  72:	748000ef          	jal	7ba <printf>
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
  82:	7ea98993          	add	s3,s3,2026 # 868 <printf+0xae>
        int tmppid = 0 ;
  86:	fa042823          	sw	zero,-80(s0)
        int wpid = wait(&tmppid);
  8a:	fb040513          	add	a0,s0,-80
  8e:	342000ef          	jal	3d0 <wait>
  92:	85aa                	mv	a1,a0
        if(wpid < 0){
  94:	04054c63          	bltz	a0,ec <test_processing+0xec>
            printf("子进程 %d 已退出，状态 %d\n", wpid, tmppid);
  98:	fb042603          	lw	a2,-80(s0)
  9c:	854e                	mv	a0,s3
  9e:	71c000ef          	jal	7ba <printf>
    for( i = 0; i < count; i++){
  a2:	2905                	addw	s2,s2,1
  a4:	fe9911e3          	bne	s2,s1,86 <test_processing+0x86>
        }
    }

    if(count == i){
        printf("所有的子进程全部退出\n");
  a8:	00000517          	auipc	a0,0x0
  ac:	7e850513          	add	a0,a0,2024 # 890 <printf+0xd6>
  b0:	70a000ef          	jal	7ba <printf>
  b4:	a891                	j	108 <test_processing+0x108>
            exec("test", (char *[]){"test", "arg1", "arg2", 0});
  b6:	00001797          	auipc	a5,0x1
  ba:	95a78793          	add	a5,a5,-1702 # a10 <printf+0x256>
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
  de:	76e50513          	add	a0,a0,1902 # 848 <printf+0x8e>
  e2:	2f6000ef          	jal	3d8 <exec>
            exit(0);
  e6:	4501                	li	a0,0
  e8:	2d8000ef          	jal	3c0 <exit>
            printf("等待子进程失败\n");
  ec:	00000517          	auipc	a0,0x0
  f0:	76450513          	add	a0,a0,1892 # 850 <printf+0x96>
  f4:	6c6000ef          	jal	7ba <printf>
    if(count == i){
  f8:	fa9908e3          	beq	s2,s1,a8 <test_processing+0xa8>
    } else {
        printf("所有子进程已清理完毕\n");
  fc:	00000517          	auipc	a0,0x0
 100:	7b450513          	add	a0,a0,1972 # 8b0 <printf+0xf6>
 104:	6b6000ef          	jal	7ba <printf>
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
 128:	2d0000ef          	jal	3f8 <write>
    if(res == 0){
 12c:	0c051c63          	bnez	a0,204 <test_write_and_ptr+0xee>
        printf("写入无效指针测试通过\n");
 130:	00000517          	auipc	a0,0x0
 134:	7a050513          	add	a0,a0,1952 # 8d0 <printf+0x116>
 138:	682000ef          	jal	7ba <printf>
    } else {
        printf("写入无效指针测试失败\n");
        printf("错误码: %d\n", res);
    }

    char buffer[20] = "Hello, RISC-V!";
 13c:	00001797          	auipc	a5,0x1
 140:	8d478793          	add	a5,a5,-1836 # a10 <printf+0x256>
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
 17c:	27c000ef          	jal	3f8 <write>
 180:	84aa                	mv	s1,a0
    if(res == -1){
 182:	57fd                	li	a5,-1
 184:	08f50f63          	beq	a0,a5,222 <test_write_and_ptr+0x10c>
        printf("写入无效文件描述符测试通过\n");
    } else {
        printf("写入无效文件描述符测试失败\n");
 188:	00000517          	auipc	a0,0x0
 18c:	7c850513          	add	a0,a0,1992 # 950 <printf+0x196>
 190:	62a000ef          	jal	7ba <printf>
        printf("错误码: %d\n", res);
 194:	85a6                	mv	a1,s1
 196:	00000517          	auipc	a0,0x0
 19a:	77a50513          	add	a0,a0,1914 # 910 <printf+0x156>
 19e:	61c000ef          	jal	7ba <printf>
    }

    // 控指针
    res = write(1, 0, 10);
 1a2:	4629                	li	a2,10
 1a4:	4581                	li	a1,0
 1a6:	4505                	li	a0,1
 1a8:	250000ef          	jal	3f8 <write>
 1ac:	84aa                	mv	s1,a0

    if(res == -1){
 1ae:	57fd                	li	a5,-1
 1b0:	08f50063          	beq	a0,a5,230 <test_write_and_ptr+0x11a>
        printf("写入空指针测试通过\n");
    } else {
        printf("写入空指针测试失败\n");
 1b4:	00000517          	auipc	a0,0x0
 1b8:	7ec50513          	add	a0,a0,2028 # 9a0 <printf+0x1e6>
 1bc:	5fe000ef          	jal	7ba <printf>
        printf("错误码: %d\n", res);
 1c0:	85a6                	mv	a1,s1
 1c2:	00000517          	auipc	a0,0x0
 1c6:	74e50513          	add	a0,a0,1870 # 910 <printf+0x156>
 1ca:	5f0000ef          	jal	7ba <printf>
    }

    res = write(1, buffer, -5);
 1ce:	566d                	li	a2,-5
 1d0:	fc840593          	add	a1,s0,-56
 1d4:	4505                	li	a0,1
 1d6:	222000ef          	jal	3f8 <write>
 1da:	84aa                	mv	s1,a0
    if(res <= 0){
 1dc:	06a05163          	blez	a0,23e <test_write_and_ptr+0x128>
        printf("写入负长度测试通过\n");
    } else {
        printf("写入负长度测试失败\n");
 1e0:	00001517          	auipc	a0,0x1
 1e4:	80050513          	add	a0,a0,-2048 # 9e0 <printf+0x226>
 1e8:	5d2000ef          	jal	7ba <printf>
        printf("错误码: %d\n", res);
 1ec:	85a6                	mv	a1,s1
 1ee:	00000517          	auipc	a0,0x0
 1f2:	72250513          	add	a0,a0,1826 # 910 <printf+0x156>
 1f6:	5c4000ef          	jal	7ba <printf>
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
 20a:	6ea50513          	add	a0,a0,1770 # 8f0 <printf+0x136>
 20e:	5ac000ef          	jal	7ba <printf>
        printf("错误码: %d\n", res);
 212:	85a6                	mv	a1,s1
 214:	00000517          	auipc	a0,0x0
 218:	6fc50513          	add	a0,a0,1788 # 910 <printf+0x156>
 21c:	59e000ef          	jal	7ba <printf>
 220:	bf31                	j	13c <test_write_and_ptr+0x26>
        printf("写入无效文件描述符测试通过\n");
 222:	00000517          	auipc	a0,0x0
 226:	6fe50513          	add	a0,a0,1790 # 920 <printf+0x166>
 22a:	590000ef          	jal	7ba <printf>
 22e:	bf95                	j	1a2 <test_write_and_ptr+0x8c>
        printf("写入空指针测试通过\n");
 230:	00000517          	auipc	a0,0x0
 234:	75050513          	add	a0,a0,1872 # 980 <printf+0x1c6>
 238:	582000ef          	jal	7ba <printf>
 23c:	bf49                	j	1ce <test_write_and_ptr+0xb8>
        printf("写入负长度测试通过\n");
 23e:	00000517          	auipc	a0,0x0
 242:	78250513          	add	a0,a0,1922 # 9c0 <printf+0x206>
 246:	574000ef          	jal	7ba <printf>
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
 272:	14e000ef          	jal	3c0 <exit>

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

0000000000000370 <atoi>:


int
atoi(const char *s)
{
 370:	1141                	add	sp,sp,-16
 372:	e422                	sd	s0,8(sp)
 374:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 376:	00054683          	lbu	a3,0(a0)
 37a:	fd06879b          	addw	a5,a3,-48
 37e:	0ff7f793          	zext.b	a5,a5
 382:	4625                	li	a2,9
 384:	02f66863          	bltu	a2,a5,3b4 <atoi+0x44>
 388:	872a                	mv	a4,a0
  n = 0;
 38a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 38c:	0705                	add	a4,a4,1
 38e:	0025179b          	sllw	a5,a0,0x2
 392:	9fa9                	addw	a5,a5,a0
 394:	0017979b          	sllw	a5,a5,0x1
 398:	9fb5                	addw	a5,a5,a3
 39a:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 39e:	00074683          	lbu	a3,0(a4)
 3a2:	fd06879b          	addw	a5,a3,-48
 3a6:	0ff7f793          	zext.b	a5,a5
 3aa:	fef671e3          	bgeu	a2,a5,38c <atoi+0x1c>
  return n;
 3ae:	6422                	ld	s0,8(sp)
 3b0:	0141                	add	sp,sp,16
 3b2:	8082                	ret
  n = 0;
 3b4:	4501                	li	a0,0
 3b6:	bfe5                	j	3ae <atoi+0x3e>

00000000000003b8 <hello>:
# generated by usys.pl - do not edit
#include "include/syscall.h"
.global hello
hello:
 li a7, SYS_hello
 3b8:	4885                	li	a7,1
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3c0:	4889                	li	a7,2
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <fork>:
.global fork
fork:
 li a7, SYS_fork
 3c8:	4891                	li	a7,4
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3d0:	488d                	li	a7,3
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3d8:	4895                	li	a7,5
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3e0:	489d                	li	a7,7
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <open>:
.global open
open:
 li a7, SYS_open
 3e8:	4899                	li	a7,6
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3f0:	48a1                	li	a7,8
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <write>:
.global write
write:
 li a7, SYS_write
 3f8:	48a5                	li	a7,9
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <read>:
.global read
read:
 li a7, SYS_read
 400:	48a9                	li	a7,10
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <close>:
.global close
close:
 li a7, SYS_close
 408:	48ad                	li	a7,11
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 410:	48b1                	li	a7,12
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 418:	48b5                	li	a7,13
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 420:	48b9                	li	a7,14
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
 428:	48bd                	li	a7,15
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 430:	1101                	add	sp,sp,-32
 432:	ec06                	sd	ra,24(sp)
 434:	e822                	sd	s0,16(sp)
 436:	1000                	add	s0,sp,32
 438:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 43c:	4605                	li	a2,1
 43e:	fef40593          	add	a1,s0,-17
 442:	fb7ff0ef          	jal	3f8 <write>
}
 446:	60e2                	ld	ra,24(sp)
 448:	6442                	ld	s0,16(sp)
 44a:	6105                	add	sp,sp,32
 44c:	8082                	ret

000000000000044e <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 44e:	715d                	add	sp,sp,-80
 450:	e486                	sd	ra,72(sp)
 452:	e0a2                	sd	s0,64(sp)
 454:	fc26                	sd	s1,56(sp)
 456:	f84a                	sd	s2,48(sp)
 458:	f44e                	sd	s3,40(sp)
 45a:	0880                	add	s0,sp,80
 45c:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 45e:	c299                	beqz	a3,464 <printint+0x16>
 460:	0805c163          	bltz	a1,4e2 <printint+0x94>
  neg = 0;
 464:	4881                	li	a7,0
 466:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 46a:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 46c:	00000517          	auipc	a0,0x0
 470:	5e450513          	add	a0,a0,1508 # a50 <digits>
 474:	883e                	mv	a6,a5
 476:	2785                	addw	a5,a5,1
 478:	02c5f733          	remu	a4,a1,a2
 47c:	972a                	add	a4,a4,a0
 47e:	00074703          	lbu	a4,0(a4)
 482:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 486:	872e                	mv	a4,a1
 488:	02c5d5b3          	divu	a1,a1,a2
 48c:	0685                	add	a3,a3,1
 48e:	fec773e3          	bgeu	a4,a2,474 <printint+0x26>
  if(neg)
 492:	00088b63          	beqz	a7,4a8 <printint+0x5a>
    buf[i++] = '-';
 496:	fd078793          	add	a5,a5,-48
 49a:	97a2                	add	a5,a5,s0
 49c:	02d00713          	li	a4,45
 4a0:	fee78423          	sb	a4,-24(a5)
 4a4:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 4a8:	02f05663          	blez	a5,4d4 <printint+0x86>
 4ac:	fb840713          	add	a4,s0,-72
 4b0:	00f704b3          	add	s1,a4,a5
 4b4:	fff70993          	add	s3,a4,-1
 4b8:	99be                	add	s3,s3,a5
 4ba:	37fd                	addw	a5,a5,-1
 4bc:	1782                	sll	a5,a5,0x20
 4be:	9381                	srl	a5,a5,0x20
 4c0:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 4c4:	fff4c583          	lbu	a1,-1(s1)
 4c8:	854a                	mv	a0,s2
 4ca:	f67ff0ef          	jal	430 <putc>
  while(--i >= 0)
 4ce:	14fd                	add	s1,s1,-1
 4d0:	ff349ae3          	bne	s1,s3,4c4 <printint+0x76>
}
 4d4:	60a6                	ld	ra,72(sp)
 4d6:	6406                	ld	s0,64(sp)
 4d8:	74e2                	ld	s1,56(sp)
 4da:	7942                	ld	s2,48(sp)
 4dc:	79a2                	ld	s3,40(sp)
 4de:	6161                	add	sp,sp,80
 4e0:	8082                	ret
    x = -xx;
 4e2:	40b005b3          	neg	a1,a1
    neg = 1;
 4e6:	4885                	li	a7,1
    x = -xx;
 4e8:	bfbd                	j	466 <printint+0x18>

00000000000004ea <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4ea:	711d                	add	sp,sp,-96
 4ec:	ec86                	sd	ra,88(sp)
 4ee:	e8a2                	sd	s0,80(sp)
 4f0:	e4a6                	sd	s1,72(sp)
 4f2:	e0ca                	sd	s2,64(sp)
 4f4:	fc4e                	sd	s3,56(sp)
 4f6:	f852                	sd	s4,48(sp)
 4f8:	f456                	sd	s5,40(sp)
 4fa:	f05a                	sd	s6,32(sp)
 4fc:	ec5e                	sd	s7,24(sp)
 4fe:	e862                	sd	s8,16(sp)
 500:	e466                	sd	s9,8(sp)
 502:	e06a                	sd	s10,0(sp)
 504:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 506:	0005c903          	lbu	s2,0(a1)
 50a:	26090563          	beqz	s2,774 <vprintf+0x28a>
 50e:	8b2a                	mv	s6,a0
 510:	8a2e                	mv	s4,a1
 512:	8bb2                	mv	s7,a2
  state = 0;
 514:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 516:	4481                	li	s1,0
 518:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 51a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 51e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 522:	06c00c93          	li	s9,108
 526:	a005                	j	546 <vprintf+0x5c>
        putc(fd, c0);
 528:	85ca                	mv	a1,s2
 52a:	855a                	mv	a0,s6
 52c:	f05ff0ef          	jal	430 <putc>
 530:	a019                	j	536 <vprintf+0x4c>
    } else if(state == '%'){
 532:	03598263          	beq	s3,s5,556 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 536:	2485                	addw	s1,s1,1
 538:	8726                	mv	a4,s1
 53a:	009a07b3          	add	a5,s4,s1
 53e:	0007c903          	lbu	s2,0(a5)
 542:	22090963          	beqz	s2,774 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 546:	0009079b          	sext.w	a5,s2
    if(state == 0){
 54a:	fe0994e3          	bnez	s3,532 <vprintf+0x48>
      if(c0 == '%'){
 54e:	fd579de3          	bne	a5,s5,528 <vprintf+0x3e>
        state = '%';
 552:	89be                	mv	s3,a5
 554:	b7cd                	j	536 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 556:	cbc9                	beqz	a5,5e8 <vprintf+0xfe>
 558:	00ea06b3          	add	a3,s4,a4
 55c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 560:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 562:	c681                	beqz	a3,56a <vprintf+0x80>
 564:	9752                	add	a4,a4,s4
 566:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 56a:	05878363          	beq	a5,s8,5b0 <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 56e:	05978d63          	beq	a5,s9,5c8 <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 572:	07500713          	li	a4,117
 576:	0ee78763          	beq	a5,a4,664 <vprintf+0x17a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 57a:	07800713          	li	a4,120
 57e:	12e78963          	beq	a5,a4,6b0 <vprintf+0x1c6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 582:	07000713          	li	a4,112
 586:	14e78e63          	beq	a5,a4,6e2 <vprintf+0x1f8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 58a:	06300713          	li	a4,99
 58e:	18e78c63          	beq	a5,a4,726 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 592:	07300713          	li	a4,115
 596:	1ae78263          	beq	a5,a4,73a <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 59a:	02500713          	li	a4,37
 59e:	04e79563          	bne	a5,a4,5e8 <vprintf+0xfe>
        putc(fd, '%');
 5a2:	02500593          	li	a1,37
 5a6:	855a                	mv	a0,s6
 5a8:	e89ff0ef          	jal	430 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5ac:	4981                	li	s3,0
 5ae:	b761                	j	536 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 5b0:	008b8913          	add	s2,s7,8
 5b4:	4685                	li	a3,1
 5b6:	4629                	li	a2,10
 5b8:	000ba583          	lw	a1,0(s7)
 5bc:	855a                	mv	a0,s6
 5be:	e91ff0ef          	jal	44e <printint>
 5c2:	8bca                	mv	s7,s2
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	bf85                	j	536 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 5c8:	06400793          	li	a5,100
 5cc:	02f68963          	beq	a3,a5,5fe <vprintf+0x114>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5d0:	06c00793          	li	a5,108
 5d4:	04f68263          	beq	a3,a5,618 <vprintf+0x12e>
      } else if(c0 == 'l' && c1 == 'u'){
 5d8:	07500793          	li	a5,117
 5dc:	0af68063          	beq	a3,a5,67c <vprintf+0x192>
      } else if(c0 == 'l' && c1 == 'x'){
 5e0:	07800793          	li	a5,120
 5e4:	0ef68263          	beq	a3,a5,6c8 <vprintf+0x1de>
        putc(fd, '%');
 5e8:	02500593          	li	a1,37
 5ec:	855a                	mv	a0,s6
 5ee:	e43ff0ef          	jal	430 <putc>
        putc(fd, c0);
 5f2:	85ca                	mv	a1,s2
 5f4:	855a                	mv	a0,s6
 5f6:	e3bff0ef          	jal	430 <putc>
      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	bf2d                	j	536 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5fe:	008b8913          	add	s2,s7,8
 602:	4685                	li	a3,1
 604:	4629                	li	a2,10
 606:	000bb583          	ld	a1,0(s7)
 60a:	855a                	mv	a0,s6
 60c:	e43ff0ef          	jal	44e <printint>
        i += 1;
 610:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 612:	8bca                	mv	s7,s2
      state = 0;
 614:	4981                	li	s3,0
        i += 1;
 616:	b705                	j	536 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 618:	06400793          	li	a5,100
 61c:	02f60763          	beq	a2,a5,64a <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 620:	07500793          	li	a5,117
 624:	06f60963          	beq	a2,a5,696 <vprintf+0x1ac>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 628:	07800793          	li	a5,120
 62c:	faf61ee3          	bne	a2,a5,5e8 <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 630:	008b8913          	add	s2,s7,8
 634:	4681                	li	a3,0
 636:	4641                	li	a2,16
 638:	000bb583          	ld	a1,0(s7)
 63c:	855a                	mv	a0,s6
 63e:	e11ff0ef          	jal	44e <printint>
        i += 2;
 642:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 644:	8bca                	mv	s7,s2
      state = 0;
 646:	4981                	li	s3,0
        i += 2;
 648:	b5fd                	j	536 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 64a:	008b8913          	add	s2,s7,8
 64e:	4685                	li	a3,1
 650:	4629                	li	a2,10
 652:	000bb583          	ld	a1,0(s7)
 656:	855a                	mv	a0,s6
 658:	df7ff0ef          	jal	44e <printint>
        i += 2;
 65c:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 65e:	8bca                	mv	s7,s2
      state = 0;
 660:	4981                	li	s3,0
        i += 2;
 662:	bdd1                	j	536 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 10, 0);
 664:	008b8913          	add	s2,s7,8
 668:	4681                	li	a3,0
 66a:	4629                	li	a2,10
 66c:	000be583          	lwu	a1,0(s7)
 670:	855a                	mv	a0,s6
 672:	dddff0ef          	jal	44e <printint>
 676:	8bca                	mv	s7,s2
      state = 0;
 678:	4981                	li	s3,0
 67a:	bd75                	j	536 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 67c:	008b8913          	add	s2,s7,8
 680:	4681                	li	a3,0
 682:	4629                	li	a2,10
 684:	000bb583          	ld	a1,0(s7)
 688:	855a                	mv	a0,s6
 68a:	dc5ff0ef          	jal	44e <printint>
        i += 1;
 68e:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 690:	8bca                	mv	s7,s2
      state = 0;
 692:	4981                	li	s3,0
        i += 1;
 694:	b54d                	j	536 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 696:	008b8913          	add	s2,s7,8
 69a:	4681                	li	a3,0
 69c:	4629                	li	a2,10
 69e:	000bb583          	ld	a1,0(s7)
 6a2:	855a                	mv	a0,s6
 6a4:	dabff0ef          	jal	44e <printint>
        i += 2;
 6a8:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6aa:	8bca                	mv	s7,s2
      state = 0;
 6ac:	4981                	li	s3,0
        i += 2;
 6ae:	b561                	j	536 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6b0:	008b8913          	add	s2,s7,8
 6b4:	4681                	li	a3,0
 6b6:	4641                	li	a2,16
 6b8:	000be583          	lwu	a1,0(s7)
 6bc:	855a                	mv	a0,s6
 6be:	d91ff0ef          	jal	44e <printint>
 6c2:	8bca                	mv	s7,s2
      state = 0;
 6c4:	4981                	li	s3,0
 6c6:	bd85                	j	536 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c8:	008b8913          	add	s2,s7,8
 6cc:	4681                	li	a3,0
 6ce:	4641                	li	a2,16
 6d0:	000bb583          	ld	a1,0(s7)
 6d4:	855a                	mv	a0,s6
 6d6:	d79ff0ef          	jal	44e <printint>
        i += 1;
 6da:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6dc:	8bca                	mv	s7,s2
      state = 0;
 6de:	4981                	li	s3,0
        i += 1;
 6e0:	bd99                	j	536 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 6e2:	008b8d13          	add	s10,s7,8
 6e6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6ea:	03000593          	li	a1,48
 6ee:	855a                	mv	a0,s6
 6f0:	d41ff0ef          	jal	430 <putc>
  putc(fd, 'x');
 6f4:	07800593          	li	a1,120
 6f8:	855a                	mv	a0,s6
 6fa:	d37ff0ef          	jal	430 <putc>
 6fe:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 700:	00000b97          	auipc	s7,0x0
 704:	350b8b93          	add	s7,s7,848 # a50 <digits>
 708:	03c9d793          	srl	a5,s3,0x3c
 70c:	97de                	add	a5,a5,s7
 70e:	0007c583          	lbu	a1,0(a5)
 712:	855a                	mv	a0,s6
 714:	d1dff0ef          	jal	430 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 718:	0992                	sll	s3,s3,0x4
 71a:	397d                	addw	s2,s2,-1
 71c:	fe0916e3          	bnez	s2,708 <vprintf+0x21e>
        printptr(fd, va_arg(ap, uint64));
 720:	8bea                	mv	s7,s10
      state = 0;
 722:	4981                	li	s3,0
 724:	bd09                	j	536 <vprintf+0x4c>
        putc(fd, va_arg(ap, uint32));
 726:	008b8913          	add	s2,s7,8
 72a:	000bc583          	lbu	a1,0(s7)
 72e:	855a                	mv	a0,s6
 730:	d01ff0ef          	jal	430 <putc>
 734:	8bca                	mv	s7,s2
      state = 0;
 736:	4981                	li	s3,0
 738:	bbfd                	j	536 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 73a:	008b8993          	add	s3,s7,8
 73e:	000bb903          	ld	s2,0(s7)
 742:	00090f63          	beqz	s2,760 <vprintf+0x276>
        for(; *s; s++)
 746:	00094583          	lbu	a1,0(s2)
 74a:	c195                	beqz	a1,76e <vprintf+0x284>
          putc(fd, *s);
 74c:	855a                	mv	a0,s6
 74e:	ce3ff0ef          	jal	430 <putc>
        for(; *s; s++)
 752:	0905                	add	s2,s2,1
 754:	00094583          	lbu	a1,0(s2)
 758:	f9f5                	bnez	a1,74c <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 75a:	8bce                	mv	s7,s3
      state = 0;
 75c:	4981                	li	s3,0
 75e:	bbe1                	j	536 <vprintf+0x4c>
          s = "(null)";
 760:	00000917          	auipc	s2,0x0
 764:	2e890913          	add	s2,s2,744 # a48 <printf+0x28e>
        for(; *s; s++)
 768:	02800593          	li	a1,40
 76c:	b7c5                	j	74c <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 76e:	8bce                	mv	s7,s3
      state = 0;
 770:	4981                	li	s3,0
 772:	b3d1                	j	536 <vprintf+0x4c>
    }
  }
}
 774:	60e6                	ld	ra,88(sp)
 776:	6446                	ld	s0,80(sp)
 778:	64a6                	ld	s1,72(sp)
 77a:	6906                	ld	s2,64(sp)
 77c:	79e2                	ld	s3,56(sp)
 77e:	7a42                	ld	s4,48(sp)
 780:	7aa2                	ld	s5,40(sp)
 782:	7b02                	ld	s6,32(sp)
 784:	6be2                	ld	s7,24(sp)
 786:	6c42                	ld	s8,16(sp)
 788:	6ca2                	ld	s9,8(sp)
 78a:	6d02                	ld	s10,0(sp)
 78c:	6125                	add	sp,sp,96
 78e:	8082                	ret

0000000000000790 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 790:	715d                	add	sp,sp,-80
 792:	ec06                	sd	ra,24(sp)
 794:	e822                	sd	s0,16(sp)
 796:	1000                	add	s0,sp,32
 798:	e010                	sd	a2,0(s0)
 79a:	e414                	sd	a3,8(s0)
 79c:	e818                	sd	a4,16(s0)
 79e:	ec1c                	sd	a5,24(s0)
 7a0:	03043023          	sd	a6,32(s0)
 7a4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7a8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7ac:	8622                	mv	a2,s0
 7ae:	d3dff0ef          	jal	4ea <vprintf>
}
 7b2:	60e2                	ld	ra,24(sp)
 7b4:	6442                	ld	s0,16(sp)
 7b6:	6161                	add	sp,sp,80
 7b8:	8082                	ret

00000000000007ba <printf>:

void
printf(const char *fmt, ...)
{
 7ba:	711d                	add	sp,sp,-96
 7bc:	ec06                	sd	ra,24(sp)
 7be:	e822                	sd	s0,16(sp)
 7c0:	1000                	add	s0,sp,32
 7c2:	e40c                	sd	a1,8(s0)
 7c4:	e810                	sd	a2,16(s0)
 7c6:	ec14                	sd	a3,24(s0)
 7c8:	f018                	sd	a4,32(s0)
 7ca:	f41c                	sd	a5,40(s0)
 7cc:	03043823          	sd	a6,48(s0)
 7d0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7d4:	00840613          	add	a2,s0,8
 7d8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7dc:	85aa                	mv	a1,a0
 7de:	4505                	li	a0,1
 7e0:	d0bff0ef          	jal	4ea <vprintf>
 7e4:	60e2                	ld	ra,24(sp)
 7e6:	6442                	ld	s0,16(sp)
 7e8:	6125                	add	sp,sp,96
 7ea:	8082                	ret
