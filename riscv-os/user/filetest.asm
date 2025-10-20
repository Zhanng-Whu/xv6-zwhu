
user/_filetest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <test_read_and_write>:
#include "include/types.h"
#include "include/param.h"
#include "include/fcntl.h"
#include "include/user.h"

void test_read_and_write(void){
   0:	7171                	add	sp,sp,-176
   2:	f506                	sd	ra,168(sp)
   4:	f122                	sd	s0,160(sp)
   6:	ed26                	sd	s1,152(sp)
   8:	e94a                	sd	s2,144(sp)
   a:	1900                	add	s0,sp,176
    printf("创建测试文件\n");
   c:	00000517          	auipc	a0,0x0
  10:	6d450513          	add	a0,a0,1748 # 6e0 <printf+0x3e>
  14:	68e000ef          	jal	6a2 <printf>
    int fd = open("testfile", O_CREATE | O_RDWR);
  18:	20200593          	li	a1,514
  1c:	00000517          	auipc	a0,0x0
  20:	6dc50513          	add	a0,a0,1756 # 6f8 <printf+0x56>
  24:	2bc000ef          	jal	2e0 <open>
    if(fd < 0){
  28:	06054d63          	bltz	a0,a2 <test_read_and_write+0xa2>
  2c:	84aa                	mv	s1,a0
        printf("创建文件失败\n");
        return;
    }else{
        printf("创建文件成功，文件描述符： %d\n", fd);
  2e:	85aa                	mv	a1,a0
  30:	00000517          	auipc	a0,0x0
  34:	6f050513          	add	a0,a0,1776 # 720 <printf+0x7e>
  38:	66a000ef          	jal	6a2 <printf>
    }


    printf("写入测试数据到文件\n");
  3c:	00000517          	auipc	a0,0x0
  40:	71450513          	add	a0,a0,1812 # 750 <printf+0xae>
  44:	65e000ef          	jal	6a2 <printf>
    char data[] = "Hello, RISC-V File System!";
  48:	00001797          	auipc	a5,0x1
  4c:	8b078793          	add	a5,a5,-1872 # 8f8 <printf+0x256>
  50:	6390                	ld	a2,0(a5)
  52:	6794                	ld	a3,8(a5)
  54:	6b98                	ld	a4,16(a5)
  56:	fcc43023          	sd	a2,-64(s0)
  5a:	fcd43423          	sd	a3,-56(s0)
  5e:	fce43823          	sd	a4,-48(s0)
  62:	0187d703          	lhu	a4,24(a5)
  66:	fce41c23          	sh	a4,-40(s0)
  6a:	01a7c783          	lbu	a5,26(a5)
  6e:	fcf40d23          	sb	a5,-38(s0)
    int write_bytes = write(fd, data, sizeof(data));
  72:	466d                	li	a2,27
  74:	fc040593          	add	a1,s0,-64
  78:	8526                	mv	a0,s1
  7a:	276000ef          	jal	2f0 <write>
    if(write_bytes != sizeof(data)){
  7e:	47ed                	li	a5,27
  80:	02f50863          	beq	a0,a5,b0 <test_read_and_write+0xb0>
        printf("写入文件失败\n");
  84:	00000517          	auipc	a0,0x0
  88:	6ec50513          	add	a0,a0,1772 # 770 <printf+0xce>
  8c:	616000ef          	jal	6a2 <printf>
        close(fd);
  90:	8526                	mv	a0,s1
  92:	26e000ef          	jal	300 <close>
    if(unlink("testfile") < 0){
        printf("删除文件失败\n");
    } else {
        printf("删除文件成功\n");
    }   
}
  96:	70aa                	ld	ra,168(sp)
  98:	740a                	ld	s0,160(sp)
  9a:	64ea                	ld	s1,152(sp)
  9c:	694a                	ld	s2,144(sp)
  9e:	614d                	add	sp,sp,176
  a0:	8082                	ret
        printf("创建文件失败\n");
  a2:	00000517          	auipc	a0,0x0
  a6:	66650513          	add	a0,a0,1638 # 708 <printf+0x66>
  aa:	5f8000ef          	jal	6a2 <printf>
        return;
  ae:	b7e5                	j	96 <test_read_and_write+0x96>
        printf("写入文件成功，写入字节数： %d\n", write_bytes);
  b0:	45ed                	li	a1,27
  b2:	00000517          	auipc	a0,0x0
  b6:	6d650513          	add	a0,a0,1750 # 788 <printf+0xe6>
  ba:	5e8000ef          	jal	6a2 <printf>
    printf("重新打开文件测试\n");
  be:	00000517          	auipc	a0,0x0
  c2:	6fa50513          	add	a0,a0,1786 # 7b8 <printf+0x116>
  c6:	5dc000ef          	jal	6a2 <printf>
    fd = open("testfile", O_RDWR);
  ca:	4589                	li	a1,2
  cc:	00000517          	auipc	a0,0x0
  d0:	62c50513          	add	a0,a0,1580 # 6f8 <printf+0x56>
  d4:	20c000ef          	jal	2e0 <open>
  d8:	84aa                	mv	s1,a0
    if(fd < 0){
  da:	04054b63          	bltz	a0,130 <test_read_and_write+0x130>
        printf("重新打开文件成功，文件描述符： %d\n", fd);
  de:	85aa                	mv	a1,a0
  e0:	00000517          	auipc	a0,0x0
  e4:	71850513          	add	a0,a0,1816 # 7f8 <printf+0x156>
  e8:	5ba000ef          	jal	6a2 <printf>
    printf("读取文件内容进行验证\n");
  ec:	00000517          	auipc	a0,0x0
  f0:	74450513          	add	a0,a0,1860 # 830 <printf+0x18e>
  f4:	5ae000ef          	jal	6a2 <printf>
    int read_bytes = read(fd, buffer, sizeof(data));
  f8:	466d                	li	a2,27
  fa:	f5840593          	add	a1,s0,-168
  fe:	8526                	mv	a0,s1
 100:	1f8000ef          	jal	2f8 <read>
 104:	892a                	mv	s2,a0
    printf("读取到的数据: %s\n", buffer);
 106:	f5840593          	add	a1,s0,-168
 10a:	00000517          	auipc	a0,0x0
 10e:	74650513          	add	a0,a0,1862 # 850 <printf+0x1ae>
 112:	590000ef          	jal	6a2 <printf>
    if(read_bytes != sizeof(data)){
 116:	47ed                	li	a5,27
 118:	02f90363          	beq	s2,a5,13e <test_read_and_write+0x13e>
        printf("读取文件失败\n");
 11c:	00000517          	auipc	a0,0x0
 120:	74c50513          	add	a0,a0,1868 # 868 <printf+0x1c6>
 124:	57e000ef          	jal	6a2 <printf>
        close(fd);
 128:	8526                	mv	a0,s1
 12a:	1d6000ef          	jal	300 <close>
        return;
 12e:	b7a5                	j	96 <test_read_and_write+0x96>
        printf("重新打开文件失败\n");
 130:	00000517          	auipc	a0,0x0
 134:	6a850513          	add	a0,a0,1704 # 7d8 <printf+0x136>
 138:	56a000ef          	jal	6a2 <printf>
        return;
 13c:	bfa9                	j	96 <test_read_and_write+0x96>
        printf("读取文件成功，读取字节数： %d\n", read_bytes);
 13e:	45ed                	li	a1,27
 140:	00000517          	auipc	a0,0x0
 144:	74050513          	add	a0,a0,1856 # 880 <printf+0x1de>
 148:	55a000ef          	jal	6a2 <printf>
    printf("测试删除文件\n");
 14c:	00000517          	auipc	a0,0x0
 150:	76450513          	add	a0,a0,1892 # 8b0 <printf+0x20e>
 154:	54e000ef          	jal	6a2 <printf>
    if(unlink("testfile") < 0){
 158:	00000517          	auipc	a0,0x0
 15c:	5a050513          	add	a0,a0,1440 # 6f8 <printf+0x56>
 160:	1b0000ef          	jal	310 <unlink>
 164:	00054963          	bltz	a0,176 <test_read_and_write+0x176>
        printf("删除文件成功\n");
 168:	00000517          	auipc	a0,0x0
 16c:	77850513          	add	a0,a0,1912 # 8e0 <printf+0x23e>
 170:	532000ef          	jal	6a2 <printf>
 174:	b70d                	j	96 <test_read_and_write+0x96>
        printf("删除文件失败\n");
 176:	00000517          	auipc	a0,0x0
 17a:	75250513          	add	a0,a0,1874 # 8c8 <printf+0x226>
 17e:	524000ef          	jal	6a2 <printf>
 182:	bf11                	j	96 <test_read_and_write+0x96>

0000000000000184 <test_concurrent_access_with_array>:
void
test_concurrent_access_with_array(void)
{
 184:	715d                	add	sp,sp,-80
 186:	e486                	sd	ra,72(sp)
 188:	e0a2                	sd	s0,64(sp)
 18a:	fc26                	sd	s1,56(sp)
 18c:	f84a                	sd	s2,48(sp)
 18e:	f44e                	sd	s3,40(sp)
 190:	0880                	add	s0,sp,80
  printf("Testing concurrent file access (using pre-defined array)...\n");
 192:	00000517          	auipc	a0,0x0
 196:	78650513          	add	a0,a0,1926 # 918 <printf+0x276>
 19a:	508000ef          	jal	6a2 <printf>
  int i;
  int pid;

  // --- “大数组”在此定义 ---
  // 这是一个字符指针数组，直接存储了所有需要的文件名。
  char *filenames[] = {
 19e:	00000797          	auipc	a5,0x0
 1a2:	7ba78793          	add	a5,a5,1978 # 958 <printf+0x2b6>
 1a6:	faf43c23          	sd	a5,-72(s0)
 1aa:	00000797          	auipc	a5,0x0
 1ae:	7b678793          	add	a5,a5,1974 # 960 <printf+0x2be>
 1b2:	fcf43023          	sd	a5,-64(s0)
 1b6:	00000797          	auipc	a5,0x0
 1ba:	7b278793          	add	a5,a5,1970 # 968 <printf+0x2c6>
 1be:	fcf43423          	sd	a5,-56(s0)
    "test_1",
    "test_2",
  };

  // 创建多个进程同时访问文件系统
  for (i = 0; i < num_procs; i++) {
 1c2:	4481                	li	s1,0
 1c4:	490d                	li	s2,3
    pid = fork();
 1c6:	0fa000ef          	jal	2c0 <fork>
    if (pid < 0) {
 1ca:	00054d63          	bltz	a0,1e4 <test_concurrent_access_with_array+0x60>
      printf("fork failed\n");
      exit(1);
    }
    
    if (pid == 0) {
 1ce:	c505                	beqz	a0,1f6 <test_concurrent_access_with_array+0x72>
  for (i = 0; i < num_procs; i++) {
 1d0:	2485                	addw	s1,s1,1
 1d2:	ff249ae3          	bne	s1,s2,1c6 <test_concurrent_access_with_array+0x42>
      printf("Child process for file %s finished.\n", filename);
      exit(0);
    }
  }

}
 1d6:	60a6                	ld	ra,72(sp)
 1d8:	6406                	ld	s0,64(sp)
 1da:	74e2                	ld	s1,56(sp)
 1dc:	7942                	ld	s2,48(sp)
 1de:	79a2                	ld	s3,40(sp)
 1e0:	6161                	add	sp,sp,80
 1e2:	8082                	ret
      printf("fork failed\n");
 1e4:	00000517          	auipc	a0,0x0
 1e8:	78c50513          	add	a0,a0,1932 # 970 <printf+0x2ce>
 1ec:	4b6000ef          	jal	6a2 <printf>
      exit(1);
 1f0:	4505                	li	a0,1
 1f2:	0c6000ef          	jal	2b8 <exit>
      char *filename = filenames[i];
 1f6:	00349793          	sll	a5,s1,0x3
 1fa:	fd078793          	add	a5,a5,-48
 1fe:	97a2                	add	a5,a5,s0
 200:	fe87b903          	ld	s2,-24(a5)
      for (j = 0; j < 100; j++) {
 204:	fa042a23          	sw	zero,-76(s0)
 208:	06300993          	li	s3,99
        int fd = open(filename, O_CREATE | O_RDWR);
 20c:	20200593          	li	a1,514
 210:	854a                	mv	a0,s2
 212:	0ce000ef          	jal	2e0 <open>
 216:	84aa                	mv	s1,a0
        if (fd >= 0) {
 218:	04054d63          	bltz	a0,272 <test_concurrent_access_with_array+0xee>
          if(write(fd, &j, sizeof(j)) != sizeof(j)){
 21c:	4611                	li	a2,4
 21e:	fb440593          	add	a1,s0,-76
 222:	0ce000ef          	jal	2f0 <write>
 226:	4791                	li	a5,4
 228:	02f51b63          	bne	a0,a5,25e <test_concurrent_access_with_array+0xda>
          close(fd);
 22c:	8526                	mv	a0,s1
 22e:	0d2000ef          	jal	300 <close>
          unlink(filename);
 232:	854a                	mv	a0,s2
 234:	0dc000ef          	jal	310 <unlink>
      for (j = 0; j < 100; j++) {
 238:	fb442783          	lw	a5,-76(s0)
 23c:	2785                	addw	a5,a5,1
 23e:	0007871b          	sext.w	a4,a5
 242:	faf42a23          	sw	a5,-76(s0)
 246:	fce9d3e3          	bge	s3,a4,20c <test_concurrent_access_with_array+0x88>
      printf("Child process for file %s finished.\n", filename);
 24a:	85ca                	mv	a1,s2
 24c:	00000517          	auipc	a0,0x0
 250:	75c50513          	add	a0,a0,1884 # 9a8 <printf+0x306>
 254:	44e000ef          	jal	6a2 <printf>
      exit(0);
 258:	4501                	li	a0,0
 25a:	05e000ef          	jal	2b8 <exit>
            printf("write to %s failed\n", filename);
 25e:	85ca                	mv	a1,s2
 260:	00000517          	auipc	a0,0x0
 264:	72050513          	add	a0,a0,1824 # 980 <printf+0x2de>
 268:	43a000ef          	jal	6a2 <printf>
            exit(1);
 26c:	4505                	li	a0,1
 26e:	04a000ef          	jal	2b8 <exit>
            printf("open %s failed\n", filename);
 272:	85ca                	mv	a1,s2
 274:	00000517          	auipc	a0,0x0
 278:	72450513          	add	a0,a0,1828 # 998 <printf+0x2f6>
 27c:	426000ef          	jal	6a2 <printf>
            exit(1);
 280:	4505                	li	a0,1
 282:	036000ef          	jal	2b8 <exit>

0000000000000286 <main>:
int main(int argc, char const *argv[])
{
 286:	1141                	add	sp,sp,-16
 288:	e406                	sd	ra,8(sp)
 28a:	e022                	sd	s0,0(sp)
 28c:	0800                	add	s0,sp,16
    test_read_and_write();
 28e:	d73ff0ef          	jal	0 <test_read_and_write>
    test_concurrent_access_with_array();
 292:	ef3ff0ef          	jal	184 <test_concurrent_access_with_array>
    return 0;
}
 296:	4501                	li	a0,0
 298:	60a2                	ld	ra,8(sp)
 29a:	6402                	ld	s0,0(sp)
 29c:	0141                	add	sp,sp,16
 29e:	8082                	ret

00000000000002a0 <start>:
#include "include/user.h"


void
start(int argc, char **argv)
{
 2a0:	1141                	add	sp,sp,-16
 2a2:	e406                	sd	ra,8(sp)
 2a4:	e022                	sd	s0,0(sp)
 2a6:	0800                	add	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 2a8:	fdfff0ef          	jal	286 <main>


  exit(r);
 2ac:	00c000ef          	jal	2b8 <exit>

00000000000002b0 <hello>:
# generated by usys.pl - do not edit
#include "include/syscall.h"
.global hello
hello:
 li a7, SYS_hello
 2b0:	4885                	li	a7,1
 ecall
 2b2:	00000073          	ecall
 ret
 2b6:	8082                	ret

00000000000002b8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2b8:	4889                	li	a7,2
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <fork>:
.global fork
fork:
 li a7, SYS_fork
 2c0:	4891                	li	a7,4
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2c8:	488d                	li	a7,3
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2d0:	4895                	li	a7,5
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 2d8:	489d                	li	a7,7
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <open>:
.global open
open:
 li a7, SYS_open
 2e0:	4899                	li	a7,6
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2e8:	48a1                	li	a7,8
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <write>:
.global write
write:
 li a7, SYS_write
 2f0:	48a5                	li	a7,9
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <read>:
.global read
read:
 li a7, SYS_read
 2f8:	48a9                	li	a7,10
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <close>:
.global close
close:
 li a7, SYS_close
 300:	48ad                	li	a7,11
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 308:	48b1                	li	a7,12
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 310:	48b5                	li	a7,13
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 318:	1101                	add	sp,sp,-32
 31a:	ec06                	sd	ra,24(sp)
 31c:	e822                	sd	s0,16(sp)
 31e:	1000                	add	s0,sp,32
 320:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 324:	4605                	li	a2,1
 326:	fef40593          	add	a1,s0,-17
 32a:	fc7ff0ef          	jal	2f0 <write>
}
 32e:	60e2                	ld	ra,24(sp)
 330:	6442                	ld	s0,16(sp)
 332:	6105                	add	sp,sp,32
 334:	8082                	ret

0000000000000336 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 336:	715d                	add	sp,sp,-80
 338:	e486                	sd	ra,72(sp)
 33a:	e0a2                	sd	s0,64(sp)
 33c:	fc26                	sd	s1,56(sp)
 33e:	f84a                	sd	s2,48(sp)
 340:	f44e                	sd	s3,40(sp)
 342:	0880                	add	s0,sp,80
 344:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 346:	c299                	beqz	a3,34c <printint+0x16>
 348:	0805c163          	bltz	a1,3ca <printint+0x94>
  neg = 0;
 34c:	4881                	li	a7,0
 34e:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 352:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 354:	00000517          	auipc	a0,0x0
 358:	68450513          	add	a0,a0,1668 # 9d8 <digits>
 35c:	883e                	mv	a6,a5
 35e:	2785                	addw	a5,a5,1
 360:	02c5f733          	remu	a4,a1,a2
 364:	972a                	add	a4,a4,a0
 366:	00074703          	lbu	a4,0(a4)
 36a:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 36e:	872e                	mv	a4,a1
 370:	02c5d5b3          	divu	a1,a1,a2
 374:	0685                	add	a3,a3,1
 376:	fec773e3          	bgeu	a4,a2,35c <printint+0x26>
  if(neg)
 37a:	00088b63          	beqz	a7,390 <printint+0x5a>
    buf[i++] = '-';
 37e:	fd078793          	add	a5,a5,-48
 382:	97a2                	add	a5,a5,s0
 384:	02d00713          	li	a4,45
 388:	fee78423          	sb	a4,-24(a5)
 38c:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 390:	02f05663          	blez	a5,3bc <printint+0x86>
 394:	fb840713          	add	a4,s0,-72
 398:	00f704b3          	add	s1,a4,a5
 39c:	fff70993          	add	s3,a4,-1
 3a0:	99be                	add	s3,s3,a5
 3a2:	37fd                	addw	a5,a5,-1
 3a4:	1782                	sll	a5,a5,0x20
 3a6:	9381                	srl	a5,a5,0x20
 3a8:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 3ac:	fff4c583          	lbu	a1,-1(s1)
 3b0:	854a                	mv	a0,s2
 3b2:	f67ff0ef          	jal	318 <putc>
  while(--i >= 0)
 3b6:	14fd                	add	s1,s1,-1
 3b8:	ff349ae3          	bne	s1,s3,3ac <printint+0x76>
}
 3bc:	60a6                	ld	ra,72(sp)
 3be:	6406                	ld	s0,64(sp)
 3c0:	74e2                	ld	s1,56(sp)
 3c2:	7942                	ld	s2,48(sp)
 3c4:	79a2                	ld	s3,40(sp)
 3c6:	6161                	add	sp,sp,80
 3c8:	8082                	ret
    x = -xx;
 3ca:	40b005b3          	neg	a1,a1
    neg = 1;
 3ce:	4885                	li	a7,1
    x = -xx;
 3d0:	bfbd                	j	34e <printint+0x18>

00000000000003d2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 3d2:	711d                	add	sp,sp,-96
 3d4:	ec86                	sd	ra,88(sp)
 3d6:	e8a2                	sd	s0,80(sp)
 3d8:	e4a6                	sd	s1,72(sp)
 3da:	e0ca                	sd	s2,64(sp)
 3dc:	fc4e                	sd	s3,56(sp)
 3de:	f852                	sd	s4,48(sp)
 3e0:	f456                	sd	s5,40(sp)
 3e2:	f05a                	sd	s6,32(sp)
 3e4:	ec5e                	sd	s7,24(sp)
 3e6:	e862                	sd	s8,16(sp)
 3e8:	e466                	sd	s9,8(sp)
 3ea:	e06a                	sd	s10,0(sp)
 3ec:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 3ee:	0005c903          	lbu	s2,0(a1)
 3f2:	26090563          	beqz	s2,65c <vprintf+0x28a>
 3f6:	8b2a                	mv	s6,a0
 3f8:	8a2e                	mv	s4,a1
 3fa:	8bb2                	mv	s7,a2
  state = 0;
 3fc:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 3fe:	4481                	li	s1,0
 400:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 402:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 406:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 40a:	06c00c93          	li	s9,108
 40e:	a005                	j	42e <vprintf+0x5c>
        putc(fd, c0);
 410:	85ca                	mv	a1,s2
 412:	855a                	mv	a0,s6
 414:	f05ff0ef          	jal	318 <putc>
 418:	a019                	j	41e <vprintf+0x4c>
    } else if(state == '%'){
 41a:	03598263          	beq	s3,s5,43e <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 41e:	2485                	addw	s1,s1,1
 420:	8726                	mv	a4,s1
 422:	009a07b3          	add	a5,s4,s1
 426:	0007c903          	lbu	s2,0(a5)
 42a:	22090963          	beqz	s2,65c <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 42e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 432:	fe0994e3          	bnez	s3,41a <vprintf+0x48>
      if(c0 == '%'){
 436:	fd579de3          	bne	a5,s5,410 <vprintf+0x3e>
        state = '%';
 43a:	89be                	mv	s3,a5
 43c:	b7cd                	j	41e <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 43e:	cbc9                	beqz	a5,4d0 <vprintf+0xfe>
 440:	00ea06b3          	add	a3,s4,a4
 444:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 448:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 44a:	c681                	beqz	a3,452 <vprintf+0x80>
 44c:	9752                	add	a4,a4,s4
 44e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 452:	05878363          	beq	a5,s8,498 <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 456:	05978d63          	beq	a5,s9,4b0 <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 45a:	07500713          	li	a4,117
 45e:	0ee78763          	beq	a5,a4,54c <vprintf+0x17a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 462:	07800713          	li	a4,120
 466:	12e78963          	beq	a5,a4,598 <vprintf+0x1c6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 46a:	07000713          	li	a4,112
 46e:	14e78e63          	beq	a5,a4,5ca <vprintf+0x1f8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 472:	06300713          	li	a4,99
 476:	18e78c63          	beq	a5,a4,60e <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 47a:	07300713          	li	a4,115
 47e:	1ae78263          	beq	a5,a4,622 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 482:	02500713          	li	a4,37
 486:	04e79563          	bne	a5,a4,4d0 <vprintf+0xfe>
        putc(fd, '%');
 48a:	02500593          	li	a1,37
 48e:	855a                	mv	a0,s6
 490:	e89ff0ef          	jal	318 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 494:	4981                	li	s3,0
 496:	b761                	j	41e <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 498:	008b8913          	add	s2,s7,8
 49c:	4685                	li	a3,1
 49e:	4629                	li	a2,10
 4a0:	000ba583          	lw	a1,0(s7)
 4a4:	855a                	mv	a0,s6
 4a6:	e91ff0ef          	jal	336 <printint>
 4aa:	8bca                	mv	s7,s2
      state = 0;
 4ac:	4981                	li	s3,0
 4ae:	bf85                	j	41e <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 4b0:	06400793          	li	a5,100
 4b4:	02f68963          	beq	a3,a5,4e6 <vprintf+0x114>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4b8:	06c00793          	li	a5,108
 4bc:	04f68263          	beq	a3,a5,500 <vprintf+0x12e>
      } else if(c0 == 'l' && c1 == 'u'){
 4c0:	07500793          	li	a5,117
 4c4:	0af68063          	beq	a3,a5,564 <vprintf+0x192>
      } else if(c0 == 'l' && c1 == 'x'){
 4c8:	07800793          	li	a5,120
 4cc:	0ef68263          	beq	a3,a5,5b0 <vprintf+0x1de>
        putc(fd, '%');
 4d0:	02500593          	li	a1,37
 4d4:	855a                	mv	a0,s6
 4d6:	e43ff0ef          	jal	318 <putc>
        putc(fd, c0);
 4da:	85ca                	mv	a1,s2
 4dc:	855a                	mv	a0,s6
 4de:	e3bff0ef          	jal	318 <putc>
      state = 0;
 4e2:	4981                	li	s3,0
 4e4:	bf2d                	j	41e <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4e6:	008b8913          	add	s2,s7,8
 4ea:	4685                	li	a3,1
 4ec:	4629                	li	a2,10
 4ee:	000bb583          	ld	a1,0(s7)
 4f2:	855a                	mv	a0,s6
 4f4:	e43ff0ef          	jal	336 <printint>
        i += 1;
 4f8:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 4fa:	8bca                	mv	s7,s2
      state = 0;
 4fc:	4981                	li	s3,0
        i += 1;
 4fe:	b705                	j	41e <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 500:	06400793          	li	a5,100
 504:	02f60763          	beq	a2,a5,532 <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 508:	07500793          	li	a5,117
 50c:	06f60963          	beq	a2,a5,57e <vprintf+0x1ac>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 510:	07800793          	li	a5,120
 514:	faf61ee3          	bne	a2,a5,4d0 <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 518:	008b8913          	add	s2,s7,8
 51c:	4681                	li	a3,0
 51e:	4641                	li	a2,16
 520:	000bb583          	ld	a1,0(s7)
 524:	855a                	mv	a0,s6
 526:	e11ff0ef          	jal	336 <printint>
        i += 2;
 52a:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 52c:	8bca                	mv	s7,s2
      state = 0;
 52e:	4981                	li	s3,0
        i += 2;
 530:	b5fd                	j	41e <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 532:	008b8913          	add	s2,s7,8
 536:	4685                	li	a3,1
 538:	4629                	li	a2,10
 53a:	000bb583          	ld	a1,0(s7)
 53e:	855a                	mv	a0,s6
 540:	df7ff0ef          	jal	336 <printint>
        i += 2;
 544:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 546:	8bca                	mv	s7,s2
      state = 0;
 548:	4981                	li	s3,0
        i += 2;
 54a:	bdd1                	j	41e <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 10, 0);
 54c:	008b8913          	add	s2,s7,8
 550:	4681                	li	a3,0
 552:	4629                	li	a2,10
 554:	000be583          	lwu	a1,0(s7)
 558:	855a                	mv	a0,s6
 55a:	dddff0ef          	jal	336 <printint>
 55e:	8bca                	mv	s7,s2
      state = 0;
 560:	4981                	li	s3,0
 562:	bd75                	j	41e <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 564:	008b8913          	add	s2,s7,8
 568:	4681                	li	a3,0
 56a:	4629                	li	a2,10
 56c:	000bb583          	ld	a1,0(s7)
 570:	855a                	mv	a0,s6
 572:	dc5ff0ef          	jal	336 <printint>
        i += 1;
 576:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 578:	8bca                	mv	s7,s2
      state = 0;
 57a:	4981                	li	s3,0
        i += 1;
 57c:	b54d                	j	41e <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 57e:	008b8913          	add	s2,s7,8
 582:	4681                	li	a3,0
 584:	4629                	li	a2,10
 586:	000bb583          	ld	a1,0(s7)
 58a:	855a                	mv	a0,s6
 58c:	dabff0ef          	jal	336 <printint>
        i += 2;
 590:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 592:	8bca                	mv	s7,s2
      state = 0;
 594:	4981                	li	s3,0
        i += 2;
 596:	b561                	j	41e <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 16, 0);
 598:	008b8913          	add	s2,s7,8
 59c:	4681                	li	a3,0
 59e:	4641                	li	a2,16
 5a0:	000be583          	lwu	a1,0(s7)
 5a4:	855a                	mv	a0,s6
 5a6:	d91ff0ef          	jal	336 <printint>
 5aa:	8bca                	mv	s7,s2
      state = 0;
 5ac:	4981                	li	s3,0
 5ae:	bd85                	j	41e <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5b0:	008b8913          	add	s2,s7,8
 5b4:	4681                	li	a3,0
 5b6:	4641                	li	a2,16
 5b8:	000bb583          	ld	a1,0(s7)
 5bc:	855a                	mv	a0,s6
 5be:	d79ff0ef          	jal	336 <printint>
        i += 1;
 5c2:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c4:	8bca                	mv	s7,s2
      state = 0;
 5c6:	4981                	li	s3,0
        i += 1;
 5c8:	bd99                	j	41e <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 5ca:	008b8d13          	add	s10,s7,8
 5ce:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5d2:	03000593          	li	a1,48
 5d6:	855a                	mv	a0,s6
 5d8:	d41ff0ef          	jal	318 <putc>
  putc(fd, 'x');
 5dc:	07800593          	li	a1,120
 5e0:	855a                	mv	a0,s6
 5e2:	d37ff0ef          	jal	318 <putc>
 5e6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5e8:	00000b97          	auipc	s7,0x0
 5ec:	3f0b8b93          	add	s7,s7,1008 # 9d8 <digits>
 5f0:	03c9d793          	srl	a5,s3,0x3c
 5f4:	97de                	add	a5,a5,s7
 5f6:	0007c583          	lbu	a1,0(a5)
 5fa:	855a                	mv	a0,s6
 5fc:	d1dff0ef          	jal	318 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 600:	0992                	sll	s3,s3,0x4
 602:	397d                	addw	s2,s2,-1
 604:	fe0916e3          	bnez	s2,5f0 <vprintf+0x21e>
        printptr(fd, va_arg(ap, uint64));
 608:	8bea                	mv	s7,s10
      state = 0;
 60a:	4981                	li	s3,0
 60c:	bd09                	j	41e <vprintf+0x4c>
        putc(fd, va_arg(ap, uint32));
 60e:	008b8913          	add	s2,s7,8
 612:	000bc583          	lbu	a1,0(s7)
 616:	855a                	mv	a0,s6
 618:	d01ff0ef          	jal	318 <putc>
 61c:	8bca                	mv	s7,s2
      state = 0;
 61e:	4981                	li	s3,0
 620:	bbfd                	j	41e <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 622:	008b8993          	add	s3,s7,8
 626:	000bb903          	ld	s2,0(s7)
 62a:	00090f63          	beqz	s2,648 <vprintf+0x276>
        for(; *s; s++)
 62e:	00094583          	lbu	a1,0(s2)
 632:	c195                	beqz	a1,656 <vprintf+0x284>
          putc(fd, *s);
 634:	855a                	mv	a0,s6
 636:	ce3ff0ef          	jal	318 <putc>
        for(; *s; s++)
 63a:	0905                	add	s2,s2,1
 63c:	00094583          	lbu	a1,0(s2)
 640:	f9f5                	bnez	a1,634 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 642:	8bce                	mv	s7,s3
      state = 0;
 644:	4981                	li	s3,0
 646:	bbe1                	j	41e <vprintf+0x4c>
          s = "(null)";
 648:	00000917          	auipc	s2,0x0
 64c:	38890913          	add	s2,s2,904 # 9d0 <printf+0x32e>
        for(; *s; s++)
 650:	02800593          	li	a1,40
 654:	b7c5                	j	634 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 656:	8bce                	mv	s7,s3
      state = 0;
 658:	4981                	li	s3,0
 65a:	b3d1                	j	41e <vprintf+0x4c>
    }
  }
}
 65c:	60e6                	ld	ra,88(sp)
 65e:	6446                	ld	s0,80(sp)
 660:	64a6                	ld	s1,72(sp)
 662:	6906                	ld	s2,64(sp)
 664:	79e2                	ld	s3,56(sp)
 666:	7a42                	ld	s4,48(sp)
 668:	7aa2                	ld	s5,40(sp)
 66a:	7b02                	ld	s6,32(sp)
 66c:	6be2                	ld	s7,24(sp)
 66e:	6c42                	ld	s8,16(sp)
 670:	6ca2                	ld	s9,8(sp)
 672:	6d02                	ld	s10,0(sp)
 674:	6125                	add	sp,sp,96
 676:	8082                	ret

0000000000000678 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 678:	715d                	add	sp,sp,-80
 67a:	ec06                	sd	ra,24(sp)
 67c:	e822                	sd	s0,16(sp)
 67e:	1000                	add	s0,sp,32
 680:	e010                	sd	a2,0(s0)
 682:	e414                	sd	a3,8(s0)
 684:	e818                	sd	a4,16(s0)
 686:	ec1c                	sd	a5,24(s0)
 688:	03043023          	sd	a6,32(s0)
 68c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 690:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 694:	8622                	mv	a2,s0
 696:	d3dff0ef          	jal	3d2 <vprintf>
}
 69a:	60e2                	ld	ra,24(sp)
 69c:	6442                	ld	s0,16(sp)
 69e:	6161                	add	sp,sp,80
 6a0:	8082                	ret

00000000000006a2 <printf>:

void
printf(const char *fmt, ...)
{
 6a2:	711d                	add	sp,sp,-96
 6a4:	ec06                	sd	ra,24(sp)
 6a6:	e822                	sd	s0,16(sp)
 6a8:	1000                	add	s0,sp,32
 6aa:	e40c                	sd	a1,8(s0)
 6ac:	e810                	sd	a2,16(s0)
 6ae:	ec14                	sd	a3,24(s0)
 6b0:	f018                	sd	a4,32(s0)
 6b2:	f41c                	sd	a5,40(s0)
 6b4:	03043823          	sd	a6,48(s0)
 6b8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6bc:	00840613          	add	a2,s0,8
 6c0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6c4:	85aa                	mv	a1,a0
 6c6:	4505                	li	a0,1
 6c8:	d0bff0ef          	jal	3d2 <vprintf>
 6cc:	60e2                	ld	ra,24(sp)
 6ce:	6442                	ld	s0,16(sp)
 6d0:	6125                	add	sp,sp,96
 6d2:	8082                	ret
