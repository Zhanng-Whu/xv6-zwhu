
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
   c:	00001517          	auipc	a0,0x1
  10:	9c450513          	add	a0,a0,-1596 # 9d0 <printf+0x36>
  14:	187000ef          	jal	99a <printf>
    int fd = open("testfile", O_CREATE | O_RDWR);
  18:	20200593          	li	a1,514
  1c:	00001517          	auipc	a0,0x1
  20:	9cc50513          	add	a0,a0,-1588 # 9e8 <printf+0x4e>
  24:	5ac000ef          	jal	5d0 <open>
    if(fd < 0){
  28:	06054d63          	bltz	a0,a2 <test_read_and_write+0xa2>
  2c:	84aa                	mv	s1,a0
        printf("创建文件失败\n");
        return;
    }else{
        printf("创建文件成功，文件描述符： %d\n", fd);
  2e:	85aa                	mv	a1,a0
  30:	00001517          	auipc	a0,0x1
  34:	9e050513          	add	a0,a0,-1568 # a10 <printf+0x76>
  38:	163000ef          	jal	99a <printf>
    }


    printf("写入测试数据到文件\n");
  3c:	00001517          	auipc	a0,0x1
  40:	a0450513          	add	a0,a0,-1532 # a40 <printf+0xa6>
  44:	157000ef          	jal	99a <printf>
    char data[] = "Hello, RISC-V File System!";
  48:	00001797          	auipc	a5,0x1
  4c:	ba078793          	add	a5,a5,-1120 # be8 <printf+0x24e>
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
  7a:	566000ef          	jal	5e0 <write>
    if(write_bytes != sizeof(data)){
  7e:	47ed                	li	a5,27
  80:	02f50863          	beq	a0,a5,b0 <test_read_and_write+0xb0>
        printf("写入文件失败\n");
  84:	00001517          	auipc	a0,0x1
  88:	9dc50513          	add	a0,a0,-1572 # a60 <printf+0xc6>
  8c:	10f000ef          	jal	99a <printf>
        close(fd);
  90:	8526                	mv	a0,s1
  92:	55e000ef          	jal	5f0 <close>
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
  a2:	00001517          	auipc	a0,0x1
  a6:	95650513          	add	a0,a0,-1706 # 9f8 <printf+0x5e>
  aa:	0f1000ef          	jal	99a <printf>
        return;
  ae:	b7e5                	j	96 <test_read_and_write+0x96>
        printf("写入文件成功，写入字节数： %d\n", write_bytes);
  b0:	45ed                	li	a1,27
  b2:	00001517          	auipc	a0,0x1
  b6:	9c650513          	add	a0,a0,-1594 # a78 <printf+0xde>
  ba:	0e1000ef          	jal	99a <printf>
    printf("重新打开文件测试\n");
  be:	00001517          	auipc	a0,0x1
  c2:	9ea50513          	add	a0,a0,-1558 # aa8 <printf+0x10e>
  c6:	0d5000ef          	jal	99a <printf>
    fd = open("testfile", O_RDWR);
  ca:	4589                	li	a1,2
  cc:	00001517          	auipc	a0,0x1
  d0:	91c50513          	add	a0,a0,-1764 # 9e8 <printf+0x4e>
  d4:	4fc000ef          	jal	5d0 <open>
  d8:	84aa                	mv	s1,a0
    if(fd < 0){
  da:	04054b63          	bltz	a0,130 <test_read_and_write+0x130>
        printf("重新打开文件成功，文件描述符： %d\n", fd);
  de:	85aa                	mv	a1,a0
  e0:	00001517          	auipc	a0,0x1
  e4:	a0850513          	add	a0,a0,-1528 # ae8 <printf+0x14e>
  e8:	0b3000ef          	jal	99a <printf>
    printf("读取文件内容进行验证\n");
  ec:	00001517          	auipc	a0,0x1
  f0:	a3450513          	add	a0,a0,-1484 # b20 <printf+0x186>
  f4:	0a7000ef          	jal	99a <printf>
    int read_bytes = read(fd, buffer, sizeof(data));
  f8:	466d                	li	a2,27
  fa:	f5840593          	add	a1,s0,-168
  fe:	8526                	mv	a0,s1
 100:	4e8000ef          	jal	5e8 <read>
 104:	892a                	mv	s2,a0
    printf("读取到的数据: %s\n", buffer);
 106:	f5840593          	add	a1,s0,-168
 10a:	00001517          	auipc	a0,0x1
 10e:	a3650513          	add	a0,a0,-1482 # b40 <printf+0x1a6>
 112:	089000ef          	jal	99a <printf>
    if(read_bytes != sizeof(data)){
 116:	47ed                	li	a5,27
 118:	02f90363          	beq	s2,a5,13e <test_read_and_write+0x13e>
        printf("读取文件失败\n");
 11c:	00001517          	auipc	a0,0x1
 120:	a3c50513          	add	a0,a0,-1476 # b58 <printf+0x1be>
 124:	077000ef          	jal	99a <printf>
        close(fd);
 128:	8526                	mv	a0,s1
 12a:	4c6000ef          	jal	5f0 <close>
        return;
 12e:	b7a5                	j	96 <test_read_and_write+0x96>
        printf("重新打开文件失败\n");
 130:	00001517          	auipc	a0,0x1
 134:	99850513          	add	a0,a0,-1640 # ac8 <printf+0x12e>
 138:	063000ef          	jal	99a <printf>
        return;
 13c:	bfa9                	j	96 <test_read_and_write+0x96>
        printf("读取文件成功，读取字节数： %d\n", read_bytes);
 13e:	45ed                	li	a1,27
 140:	00001517          	auipc	a0,0x1
 144:	a3050513          	add	a0,a0,-1488 # b70 <printf+0x1d6>
 148:	053000ef          	jal	99a <printf>
    printf("测试删除文件\n");
 14c:	00001517          	auipc	a0,0x1
 150:	a5450513          	add	a0,a0,-1452 # ba0 <printf+0x206>
 154:	047000ef          	jal	99a <printf>
    if(unlink("testfile") < 0){
 158:	00001517          	auipc	a0,0x1
 15c:	89050513          	add	a0,a0,-1904 # 9e8 <printf+0x4e>
 160:	4a0000ef          	jal	600 <unlink>
 164:	00054963          	bltz	a0,176 <test_read_and_write+0x176>
        printf("删除文件成功\n");
 168:	00001517          	auipc	a0,0x1
 16c:	a6850513          	add	a0,a0,-1432 # bd0 <printf+0x236>
 170:	02b000ef          	jal	99a <printf>
 174:	b70d                	j	96 <test_read_and_write+0x96>
        printf("删除文件失败\n");
 176:	00001517          	auipc	a0,0x1
 17a:	a4250513          	add	a0,a0,-1470 # bb8 <printf+0x21e>
 17e:	01d000ef          	jal	99a <printf>
 182:	bf11                	j	96 <test_read_and_write+0x96>

0000000000000184 <test_concurrent_access_with_array>:
void
test_concurrent_access_with_array(void)
{
 184:	7175                	add	sp,sp,-144
 186:	e506                	sd	ra,136(sp)
 188:	e122                	sd	s0,128(sp)
 18a:	fca6                	sd	s1,120(sp)
 18c:	f8ca                	sd	s2,112(sp)
 18e:	f4ce                	sd	s3,104(sp)
 190:	0900                	add	s0,sp,144
  printf("开始filesystem并发访问测试\n");
 192:	00001517          	auipc	a0,0x1
 196:	a7650513          	add	a0,a0,-1418 # c08 <printf+0x26e>
 19a:	001000ef          	jal	99a <printf>
  int i;
  int pid;

  // --- “大数组”在此定义 ---
  // 这是一个字符指针数组，直接存储了所有需要的文件名。
  char *filenames[] = {
 19e:	00001797          	auipc	a5,0x1
 1a2:	d6a78793          	add	a5,a5,-662 # f08 <printf+0x56e>
 1a6:	0007be03          	ld	t3,0(a5)
 1aa:	0087b303          	ld	t1,8(a5)
 1ae:	0107b883          	ld	a7,16(a5)
 1b2:	0187b803          	ld	a6,24(a5)
 1b6:	7388                	ld	a0,32(a5)
 1b8:	778c                	ld	a1,40(a5)
 1ba:	7b90                	ld	a2,48(a5)
 1bc:	7f94                	ld	a3,56(a5)
 1be:	63b8                	ld	a4,64(a5)
 1c0:	67bc                	ld	a5,72(a5)
 1c2:	f9c43023          	sd	t3,-128(s0)
 1c6:	f8643423          	sd	t1,-120(s0)
 1ca:	f9143823          	sd	a7,-112(s0)
 1ce:	f9043c23          	sd	a6,-104(s0)
 1d2:	faa43023          	sd	a0,-96(s0)
 1d6:	fab43423          	sd	a1,-88(s0)
 1da:	fac43823          	sd	a2,-80(s0)
 1de:	fad43c23          	sd	a3,-72(s0)
 1e2:	fce43023          	sd	a4,-64(s0)
 1e6:	fcf43423          	sd	a5,-56(s0)
    "test_8",
    "test_9",
  };

  // 创建多个进程同时访问文件系统
  for (i = 0; i < num_procs; i++) {
 1ea:	4481                	li	s1,0
 1ec:	4929                	li	s2,10
    pid = fork();
 1ee:	3c2000ef          	jal	5b0 <fork>
    if (pid < 0) {
 1f2:	02054b63          	bltz	a0,228 <test_concurrent_access_with_array+0xa4>
      printf("fork failed\n");
      exit(1);
    }
    
    if (pid == 0) {
 1f6:	c131                	beqz	a0,23a <test_concurrent_access_with_array+0xb6>
  for (i = 0; i < num_procs; i++) {
 1f8:	2485                	addw	s1,s1,1
 1fa:	ff249ae3          	bne	s1,s2,1ee <test_concurrent_access_with_array+0x6a>
 1fe:	44a9                	li	s1,10
      exit(0);
    }
  }

  for(i = 0; i < num_procs; i++) {
    int wpid = wait(0);
 200:	4501                	li	a0,0
 202:	3b6000ef          	jal	5b8 <wait>
    if (wpid < 0) {
 206:	0c054263          	bltz	a0,2ca <test_concurrent_access_with_array+0x146>
  for(i = 0; i < num_procs; i++) {
 20a:	34fd                	addw	s1,s1,-1
 20c:	f8f5                	bnez	s1,200 <test_concurrent_access_with_array+0x7c>
      printf("wait failed\n");
      exit(1);
    }
  }
  printf("并发测试结束，所有子进程已完成。\n");
 20e:	00001517          	auipc	a0,0x1
 212:	a9250513          	add	a0,a0,-1390 # ca0 <printf+0x306>
 216:	784000ef          	jal	99a <printf>

}
 21a:	60aa                	ld	ra,136(sp)
 21c:	640a                	ld	s0,128(sp)
 21e:	74e6                	ld	s1,120(sp)
 220:	7946                	ld	s2,112(sp)
 222:	79a6                	ld	s3,104(sp)
 224:	6149                	add	sp,sp,144
 226:	8082                	ret
      printf("fork failed\n");
 228:	00001517          	auipc	a0,0x1
 22c:	a0850513          	add	a0,a0,-1528 # c30 <printf+0x296>
 230:	76a000ef          	jal	99a <printf>
      exit(1);
 234:	4505                	li	a0,1
 236:	372000ef          	jal	5a8 <exit>
      char *filename = filenames[i];
 23a:	00349793          	sll	a5,s1,0x3
 23e:	fd078793          	add	a5,a5,-48
 242:	97a2                	add	a5,a5,s0
 244:	fb07b903          	ld	s2,-80(a5)
      for (j = 0; j < 100; j++) {
 248:	f6042e23          	sw	zero,-132(s0)
 24c:	06300993          	li	s3,99
        int fd = open(filename, O_CREATE | O_RDWR);
 250:	20200593          	li	a1,514
 254:	854a                	mv	a0,s2
 256:	37a000ef          	jal	5d0 <open>
 25a:	84aa                	mv	s1,a0
        if (fd >= 0) {
 25c:	04054d63          	bltz	a0,2b6 <test_concurrent_access_with_array+0x132>
          if(write(fd, &j, sizeof(j)) != sizeof(j)){
 260:	4611                	li	a2,4
 262:	f7c40593          	add	a1,s0,-132
 266:	37a000ef          	jal	5e0 <write>
 26a:	4791                	li	a5,4
 26c:	02f51b63          	bne	a0,a5,2a2 <test_concurrent_access_with_array+0x11e>
          close(fd);
 270:	8526                	mv	a0,s1
 272:	37e000ef          	jal	5f0 <close>
          unlink(filename);
 276:	854a                	mv	a0,s2
 278:	388000ef          	jal	600 <unlink>
      for (j = 0; j < 100; j++) {
 27c:	f7c42783          	lw	a5,-132(s0)
 280:	2785                	addw	a5,a5,1
 282:	0007871b          	sext.w	a4,a5
 286:	f6f42e23          	sw	a5,-132(s0)
 28a:	fce9d3e3          	bge	s3,a4,250 <test_concurrent_access_with_array+0xcc>
      printf("Child process for file %s finished.\n", filename);
 28e:	85ca                	mv	a1,s2
 290:	00001517          	auipc	a0,0x1
 294:	9d850513          	add	a0,a0,-1576 # c68 <printf+0x2ce>
 298:	702000ef          	jal	99a <printf>
      exit(0);
 29c:	4501                	li	a0,0
 29e:	30a000ef          	jal	5a8 <exit>
            printf("write to %s failed\n", filename);
 2a2:	85ca                	mv	a1,s2
 2a4:	00001517          	auipc	a0,0x1
 2a8:	99c50513          	add	a0,a0,-1636 # c40 <printf+0x2a6>
 2ac:	6ee000ef          	jal	99a <printf>
            exit(1);
 2b0:	4505                	li	a0,1
 2b2:	2f6000ef          	jal	5a8 <exit>
            printf("open %s failed\n", filename);
 2b6:	85ca                	mv	a1,s2
 2b8:	00001517          	auipc	a0,0x1
 2bc:	9a050513          	add	a0,a0,-1632 # c58 <printf+0x2be>
 2c0:	6da000ef          	jal	99a <printf>
            exit(1);
 2c4:	4505                	li	a0,1
 2c6:	2e2000ef          	jal	5a8 <exit>
      printf("wait failed\n");
 2ca:	00001517          	auipc	a0,0x1
 2ce:	9c650513          	add	a0,a0,-1594 # c90 <printf+0x2f6>
 2d2:	6c8000ef          	jal	99a <printf>
      exit(1);
 2d6:	4505                	li	a0,1
 2d8:	2d0000ef          	jal	5a8 <exit>

00000000000002dc <test_filesystem_performance>:

void
test_filesystem_performance(void)
{
 2dc:	7159                	add	sp,sp,-112
 2de:	f486                	sd	ra,104(sp)
 2e0:	f0a2                	sd	s0,96(sp)
 2e2:	eca6                	sd	s1,88(sp)
 2e4:	e8ca                	sd	s2,80(sp)
 2e6:	e4ce                	sd	s3,72(sp)
 2e8:	e0d2                	sd	s4,64(sp)
 2ea:	fc56                	sd	s5,56(sp)
 2ec:	f85a                	sd	s6,48(sp)
 2ee:	f45e                	sd	s7,40(sp)
 2f0:	1880                	add	s0,sp,112
 2f2:	72fd                	lui	t0,0xfffff
 2f4:	9116                	add	sp,sp,t0
  printf("文件IO性能测试\n");
 2f6:	00001517          	auipc	a0,0x1
 2fa:	9e250513          	add	a0,a0,-1566 # cd8 <printf+0x33e>
 2fe:	69c000ef          	jal	99a <printf>
  
  uint start_time;
  int fd, i;
  
  // --- 大量小文件测试 ---
  printf("开始小文件测试 (1000 个文件)...\n");
 302:	00001517          	auipc	a0,0x1
 306:	9ee50513          	add	a0,a0,-1554 # cf0 <printf+0x356>
 30a:	690000ef          	jal	99a <printf>
  start_time = uptime();
 30e:	2fa000ef          	jal	608 <uptime>
 312:	00050b9b          	sext.w	s7,a0

  for (i = 0; i < 1000; i++) {
 316:	4981                	li	s3,0
    char filename[32];
    strcpy(filename, "small_");
 318:	797d                	lui	s2,0xfffff
 31a:	f9090793          	add	a5,s2,-112 # ffffffffffffef90 <digits+0xffffffffffffe030>
 31e:	00878933          	add	s2,a5,s0
 322:	00001a17          	auipc	s4,0x1
 326:	9fea0a13          	add	s4,s4,-1538 # d20 <printf+0x386>
    fd = open(filename, O_CREATE | O_WRONLY);
    if (fd < 0) {
      printf("performance test: open small file failed\n");
      exit(1);
    }
    if (write(fd, "test", 4) != 4) {
 32a:	00001b17          	auipc	s6,0x1
 32e:	a2eb0b13          	add	s6,s6,-1490 # d58 <printf+0x3be>
  for (i = 0; i < 1000; i++) {
 332:	3e800a93          	li	s5,1000
    strcpy(filename, "small_");
 336:	85d2                	mv	a1,s4
 338:	854a                	mv	a0,s2
 33a:	1f6000ef          	jal	530 <strcpy>
    itoa(i, filename + strlen(filename));
 33e:	854a                	mv	a0,s2
 340:	20a000ef          	jal	54a <strlen>
 344:	02051593          	sll	a1,a0,0x20
 348:	9181                	srl	a1,a1,0x20
 34a:	95ca                	add	a1,a1,s2
 34c:	854e                	mv	a0,s3
 34e:	158000ef          	jal	4a6 <itoa>
    fd = open(filename, O_CREATE | O_WRONLY);
 352:	20100593          	li	a1,513
 356:	854a                	mv	a0,s2
 358:	278000ef          	jal	5d0 <open>
 35c:	84aa                	mv	s1,a0
    if (fd < 0) {
 35e:	0c054d63          	bltz	a0,438 <test_filesystem_performance+0x15c>
    if (write(fd, "test", 4) != 4) {
 362:	4611                	li	a2,4
 364:	85da                	mv	a1,s6
 366:	27a000ef          	jal	5e0 <write>
 36a:	4791                	li	a5,4
 36c:	0cf51f63          	bne	a0,a5,44a <test_filesystem_performance+0x16e>
      printf("performance test: write small file failed\n");
      exit(1);
    }
    close(fd);
 370:	8526                	mv	a0,s1
 372:	27e000ef          	jal	5f0 <close>
  for (i = 0; i < 1000; i++) {
 376:	2985                	addw	s3,s3,1
 378:	fb599fe3          	bne	s3,s5,336 <test_filesystem_performance+0x5a>
  }

  uint small_files_time = uptime() - start_time;
 37c:	28c000ef          	jal	608 <uptime>
 380:	41750bbb          	subw	s7,a0,s7

  // --- 大文件测试 ---
  printf("开始大文件测试 (1 个 4MB 文件)...\n");
 384:	00001517          	auipc	a0,0x1
 388:	a0c50513          	add	a0,a0,-1524 # d90 <printf+0x3f6>
 38c:	60e000ef          	jal	99a <printf>
  char large_buffer[4096]; // 4KB buffer
  start_time = uptime();
 390:	278000ef          	jal	608 <uptime>
 394:	00050a9b          	sext.w	s5,a0

  fd = open("large_file", O_CREATE | O_WRONLY);
 398:	20100593          	li	a1,513
 39c:	00001517          	auipc	a0,0x1
 3a0:	a2450513          	add	a0,a0,-1500 # dc0 <printf+0x426>
 3a4:	22c000ef          	jal	5d0 <open>
 3a8:	892a                	mv	s2,a0
  if (fd < 0) {
 3aa:	40000493          	li	s1,1024
    printf("performance test: open large file failed\n");
    exit(1);
  }
  for (i = 0; i < 1024; i++) { // 1024 * 4KB = 4MB
    if (write(fd, large_buffer, sizeof(large_buffer)) != sizeof(large_buffer)) {
 3ae:	79fd                	lui	s3,0xfffff
 3b0:	fb098793          	add	a5,s3,-80 # ffffffffffffefb0 <digits+0xffffffffffffe050>
 3b4:	008789b3          	add	s3,a5,s0
  if (fd < 0) {
 3b8:	0a054263          	bltz	a0,45c <test_filesystem_performance+0x180>
    if (write(fd, large_buffer, sizeof(large_buffer)) != sizeof(large_buffer)) {
 3bc:	6605                	lui	a2,0x1
 3be:	85ce                	mv	a1,s3
 3c0:	854a                	mv	a0,s2
 3c2:	21e000ef          	jal	5e0 <write>
 3c6:	6785                	lui	a5,0x1
 3c8:	0af51363          	bne	a0,a5,46e <test_filesystem_performance+0x192>
  for (i = 0; i < 1024; i++) { // 1024 * 4KB = 4MB
 3cc:	34fd                	addw	s1,s1,-1
 3ce:	f4fd                	bnez	s1,3bc <test_filesystem_performance+0xe0>
      printf("performance test: write large file failed\n");
      exit(1);
    }
  }
  close(fd);
 3d0:	854a                	mv	a0,s2
 3d2:	21e000ef          	jal	5f0 <close>

  uint large_file_time = uptime() - start_time;
 3d6:	232000ef          	jal	608 <uptime>
 3da:	41550abb          	subw	s5,a0,s5

  // --- 打印结果 ---
  printf("\n 性能测试结果 \n");
 3de:	00001517          	auipc	a0,0x1
 3e2:	a5250513          	add	a0,a0,-1454 # e30 <printf+0x496>
 3e6:	5b4000ef          	jal	99a <printf>
  // 中文输出
  printf("小文件 (1000x4B) 耗时: %d ticks\n", small_files_time);
 3ea:	85de                	mv	a1,s7
 3ec:	00001517          	auipc	a0,0x1
 3f0:	a5c50513          	add	a0,a0,-1444 # e48 <printf+0x4ae>
 3f4:	5a6000ef          	jal	99a <printf>
  printf("大文件 (1x4MB) 耗时:    %d ticks\n", large_file_time);
 3f8:	85d6                	mv	a1,s5
 3fa:	00001517          	auipc	a0,0x1
 3fe:	a7650513          	add	a0,a0,-1418 # e70 <printf+0x4d6>
 402:	598000ef          	jal	99a <printf>

  unlink("large_file");
 406:	00001517          	auipc	a0,0x1
 40a:	9ba50513          	add	a0,a0,-1606 # dc0 <printf+0x426>
 40e:	1f2000ef          	jal	600 <unlink>

  printf("测试 3 成功完成。\n");
 412:	00001517          	auipc	a0,0x1
 416:	a8650513          	add	a0,a0,-1402 # e98 <printf+0x4fe>
 41a:	580000ef          	jal	99a <printf>
}
 41e:	6285                	lui	t0,0x1
 420:	9116                	add	sp,sp,t0
 422:	70a6                	ld	ra,104(sp)
 424:	7406                	ld	s0,96(sp)
 426:	64e6                	ld	s1,88(sp)
 428:	6946                	ld	s2,80(sp)
 42a:	69a6                	ld	s3,72(sp)
 42c:	6a06                	ld	s4,64(sp)
 42e:	7ae2                	ld	s5,56(sp)
 430:	7b42                	ld	s6,48(sp)
 432:	7ba2                	ld	s7,40(sp)
 434:	6165                	add	sp,sp,112
 436:	8082                	ret
      printf("performance test: open small file failed\n");
 438:	00001517          	auipc	a0,0x1
 43c:	8f050513          	add	a0,a0,-1808 # d28 <printf+0x38e>
 440:	55a000ef          	jal	99a <printf>
      exit(1);
 444:	4505                	li	a0,1
 446:	162000ef          	jal	5a8 <exit>
      printf("performance test: write small file failed\n");
 44a:	00001517          	auipc	a0,0x1
 44e:	91650513          	add	a0,a0,-1770 # d60 <printf+0x3c6>
 452:	548000ef          	jal	99a <printf>
      exit(1);
 456:	4505                	li	a0,1
 458:	150000ef          	jal	5a8 <exit>
    printf("performance test: open large file failed\n");
 45c:	00001517          	auipc	a0,0x1
 460:	97450513          	add	a0,a0,-1676 # dd0 <printf+0x436>
 464:	536000ef          	jal	99a <printf>
    exit(1);
 468:	4505                	li	a0,1
 46a:	13e000ef          	jal	5a8 <exit>
      printf("performance test: write large file failed\n");
 46e:	00001517          	auipc	a0,0x1
 472:	99250513          	add	a0,a0,-1646 # e00 <printf+0x466>
 476:	524000ef          	jal	99a <printf>
      exit(1);
 47a:	4505                	li	a0,1
 47c:	12c000ef          	jal	5a8 <exit>

0000000000000480 <main>:


int main(int argc, char const *argv[])
{
 480:	1141                	add	sp,sp,-16
 482:	e406                	sd	ra,8(sp)
 484:	e022                	sd	s0,0(sp)
 486:	0800                	add	s0,sp,16

    test_filesystem_performance();
 488:	e55ff0ef          	jal	2dc <test_filesystem_performance>
    return 0;
}
 48c:	4501                	li	a0,0
 48e:	60a2                	ld	ra,8(sp)
 490:	6402                	ld	s0,0(sp)
 492:	0141                	add	sp,sp,16
 494:	8082                	ret

0000000000000496 <start>:
#include "include/user.h"


void
start(int argc, char **argv)
{
 496:	1141                	add	sp,sp,-16
 498:	e406                	sd	ra,8(sp)
 49a:	e022                	sd	s0,0(sp)
 49c:	0800                	add	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 49e:	fe3ff0ef          	jal	480 <main>


  exit(r);
 4a2:	106000ef          	jal	5a8 <exit>

00000000000004a6 <itoa>:
{
  char temp[16];
  int i = 0;
  int j = 0;

  if (n == 0) {
 4a6:	cd25                	beqz	a0,51e <itoa+0x78>
{
 4a8:	1101                	add	sp,sp,-32
 4aa:	ec22                	sd	s0,24(sp)
 4ac:	1000                	add	s0,sp,32
    buf[1] = '\0';
    return;
  }
  
  // Generate digits in reverse order
  while (n > 0) {
 4ae:	fe040693          	add	a3,s0,-32
  int i = 0;
 4b2:	4701                	li	a4,0
    temp[i++] = (n % 10) + '0';
 4b4:	4829                	li	a6,10
  while (n > 0) {
 4b6:	48a5                	li	a7,9
    n /= 10;
  }
  temp[i] = '\0';

  // Reverse the string to get the correct order
  for (j = 0; j < i; j++) {
 4b8:	4601                	li	a2,0
  while (n > 0) {
 4ba:	04a05c63          	blez	a0,512 <itoa+0x6c>
    temp[i++] = (n % 10) + '0';
 4be:	863a                	mv	a2,a4
 4c0:	2705                	addw	a4,a4,1
 4c2:	030567bb          	remw	a5,a0,a6
 4c6:	0307879b          	addw	a5,a5,48 # 1030 <digits+0xd0>
 4ca:	00f68023          	sb	a5,0(a3)
    n /= 10;
 4ce:	87aa                	mv	a5,a0
 4d0:	0305453b          	divw	a0,a0,a6
  while (n > 0) {
 4d4:	0685                	add	a3,a3,1
 4d6:	fef8c4e3          	blt	a7,a5,4be <itoa+0x18>
  temp[i] = '\0';
 4da:	ff070793          	add	a5,a4,-16
 4de:	97a2                	add	a5,a5,s0
 4e0:	fe078823          	sb	zero,-16(a5)
  for (j = 0; j < i; j++) {
 4e4:	04e05463          	blez	a4,52c <itoa+0x86>
 4e8:	fe040793          	add	a5,s0,-32
 4ec:	00c786b3          	add	a3,a5,a2
 4f0:	87ae                	mv	a5,a1
    buf[j] = temp[i - 1 - j];
 4f2:	0006c703          	lbu	a4,0(a3)
 4f6:	00e78023          	sb	a4,0(a5)
  for (j = 0; j < i; j++) {
 4fa:	16fd                	add	a3,a3,-1
 4fc:	0785                	add	a5,a5,1
 4fe:	40b7873b          	subw	a4,a5,a1
 502:	377d                	addw	a4,a4,-1
 504:	fec747e3          	blt	a4,a2,4f2 <itoa+0x4c>
 508:	fff64793          	not	a5,a2
 50c:	97fd                	sra	a5,a5,0x3f
 50e:	8e7d                	and	a2,a2,a5
 510:	2605                	addw	a2,a2,1 # 1001 <digits+0xa1>
  }
  buf[j] = '\0';
 512:	95b2                	add	a1,a1,a2
 514:	00058023          	sb	zero,0(a1)
}
 518:	6462                	ld	s0,24(sp)
 51a:	6105                	add	sp,sp,32
 51c:	8082                	ret
    buf[0] = '0';
 51e:	03000793          	li	a5,48
 522:	00f58023          	sb	a5,0(a1)
    buf[1] = '\0';
 526:	000580a3          	sb	zero,1(a1)
    return;
 52a:	8082                	ret
  for (j = 0; j < i; j++) {
 52c:	4601                	li	a2,0
 52e:	b7d5                	j	512 <itoa+0x6c>

0000000000000530 <strcpy>:

void strcpy(char *dst, const char *src) {
 530:	1141                	add	sp,sp,-16
 532:	e422                	sd	s0,8(sp)
 534:	0800                	add	s0,sp,16
    while ((*dst++ = *src++) != '\0');
 536:	0585                	add	a1,a1,1
 538:	0505                	add	a0,a0,1
 53a:	fff5c783          	lbu	a5,-1(a1)
 53e:	fef50fa3          	sb	a5,-1(a0)
 542:	fbf5                	bnez	a5,536 <strcpy+0x6>
} 
 544:	6422                	ld	s0,8(sp)
 546:	0141                	add	sp,sp,16
 548:	8082                	ret

000000000000054a <strlen>:

uint
strlen(const char *s){
 54a:	1141                	add	sp,sp,-16
 54c:	e422                	sd	s0,8(sp)
 54e:	0800                	add	s0,sp,16
  int n;
  for(n = 0; s[n]; n++);
 550:	00054783          	lbu	a5,0(a0)
 554:	cf91                	beqz	a5,570 <strlen+0x26>
 556:	0505                	add	a0,a0,1
 558:	87aa                	mv	a5,a0
 55a:	86be                	mv	a3,a5
 55c:	0785                	add	a5,a5,1
 55e:	fff7c703          	lbu	a4,-1(a5)
 562:	ff65                	bnez	a4,55a <strlen+0x10>
 564:	40a6853b          	subw	a0,a3,a0
 568:	2505                	addw	a0,a0,1
  return n;
}
 56a:	6422                	ld	s0,8(sp)
 56c:	0141                	add	sp,sp,16
 56e:	8082                	ret
  for(n = 0; s[n]; n++);
 570:	4501                	li	a0,0
 572:	bfe5                	j	56a <strlen+0x20>

0000000000000574 <strcmp>:

uint
strcmp(const char *p, const char *q)
{
 574:	1141                	add	sp,sp,-16
 576:	e422                	sd	s0,8(sp)
 578:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 57a:	00054783          	lbu	a5,0(a0)
 57e:	cb91                	beqz	a5,592 <strcmp+0x1e>
 580:	0005c703          	lbu	a4,0(a1)
 584:	00f71763          	bne	a4,a5,592 <strcmp+0x1e>
    p++, q++;
 588:	0505                	add	a0,a0,1
 58a:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 58c:	00054783          	lbu	a5,0(a0)
 590:	fbe5                	bnez	a5,580 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 592:	0005c503          	lbu	a0,0(a1)
}
 596:	40a7853b          	subw	a0,a5,a0
 59a:	6422                	ld	s0,8(sp)
 59c:	0141                	add	sp,sp,16
 59e:	8082                	ret

00000000000005a0 <hello>:
# generated by usys.pl - do not edit
#include "include/syscall.h"
.global hello
hello:
 li a7, SYS_hello
 5a0:	4885                	li	a7,1
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 5a8:	4889                	li	a7,2
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <fork>:
.global fork
fork:
 li a7, SYS_fork
 5b0:	4891                	li	a7,4
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 5b8:	488d                	li	a7,3
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5c0:	4895                	li	a7,5
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5c8:	489d                	li	a7,7
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <open>:
.global open
open:
 li a7, SYS_open
 5d0:	4899                	li	a7,6
 ecall
 5d2:	00000073          	ecall
 ret
 5d6:	8082                	ret

00000000000005d8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5d8:	48a1                	li	a7,8
 ecall
 5da:	00000073          	ecall
 ret
 5de:	8082                	ret

00000000000005e0 <write>:
.global write
write:
 li a7, SYS_write
 5e0:	48a5                	li	a7,9
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <read>:
.global read
read:
 li a7, SYS_read
 5e8:	48a9                	li	a7,10
 ecall
 5ea:	00000073          	ecall
 ret
 5ee:	8082                	ret

00000000000005f0 <close>:
.global close
close:
 li a7, SYS_close
 5f0:	48ad                	li	a7,11
 ecall
 5f2:	00000073          	ecall
 ret
 5f6:	8082                	ret

00000000000005f8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5f8:	48b1                	li	a7,12
 ecall
 5fa:	00000073          	ecall
 ret
 5fe:	8082                	ret

0000000000000600 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 600:	48b5                	li	a7,13
 ecall
 602:	00000073          	ecall
 ret
 606:	8082                	ret

0000000000000608 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 608:	48b9                	li	a7,14
 ecall
 60a:	00000073          	ecall
 ret
 60e:	8082                	ret

0000000000000610 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 610:	1101                	add	sp,sp,-32
 612:	ec06                	sd	ra,24(sp)
 614:	e822                	sd	s0,16(sp)
 616:	1000                	add	s0,sp,32
 618:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 61c:	4605                	li	a2,1
 61e:	fef40593          	add	a1,s0,-17
 622:	fbfff0ef          	jal	5e0 <write>
}
 626:	60e2                	ld	ra,24(sp)
 628:	6442                	ld	s0,16(sp)
 62a:	6105                	add	sp,sp,32
 62c:	8082                	ret

000000000000062e <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 62e:	715d                	add	sp,sp,-80
 630:	e486                	sd	ra,72(sp)
 632:	e0a2                	sd	s0,64(sp)
 634:	fc26                	sd	s1,56(sp)
 636:	f84a                	sd	s2,48(sp)
 638:	f44e                	sd	s3,40(sp)
 63a:	0880                	add	s0,sp,80
 63c:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 63e:	c299                	beqz	a3,644 <printint+0x16>
 640:	0805c163          	bltz	a1,6c2 <printint+0x94>
  neg = 0;
 644:	4881                	li	a7,0
 646:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 64a:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 64c:	00001517          	auipc	a0,0x1
 650:	91450513          	add	a0,a0,-1772 # f60 <digits>
 654:	883e                	mv	a6,a5
 656:	2785                	addw	a5,a5,1
 658:	02c5f733          	remu	a4,a1,a2
 65c:	972a                	add	a4,a4,a0
 65e:	00074703          	lbu	a4,0(a4)
 662:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 666:	872e                	mv	a4,a1
 668:	02c5d5b3          	divu	a1,a1,a2
 66c:	0685                	add	a3,a3,1
 66e:	fec773e3          	bgeu	a4,a2,654 <printint+0x26>
  if(neg)
 672:	00088b63          	beqz	a7,688 <printint+0x5a>
    buf[i++] = '-';
 676:	fd078793          	add	a5,a5,-48
 67a:	97a2                	add	a5,a5,s0
 67c:	02d00713          	li	a4,45
 680:	fee78423          	sb	a4,-24(a5)
 684:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 688:	02f05663          	blez	a5,6b4 <printint+0x86>
 68c:	fb840713          	add	a4,s0,-72
 690:	00f704b3          	add	s1,a4,a5
 694:	fff70993          	add	s3,a4,-1
 698:	99be                	add	s3,s3,a5
 69a:	37fd                	addw	a5,a5,-1
 69c:	1782                	sll	a5,a5,0x20
 69e:	9381                	srl	a5,a5,0x20
 6a0:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 6a4:	fff4c583          	lbu	a1,-1(s1)
 6a8:	854a                	mv	a0,s2
 6aa:	f67ff0ef          	jal	610 <putc>
  while(--i >= 0)
 6ae:	14fd                	add	s1,s1,-1
 6b0:	ff349ae3          	bne	s1,s3,6a4 <printint+0x76>
}
 6b4:	60a6                	ld	ra,72(sp)
 6b6:	6406                	ld	s0,64(sp)
 6b8:	74e2                	ld	s1,56(sp)
 6ba:	7942                	ld	s2,48(sp)
 6bc:	79a2                	ld	s3,40(sp)
 6be:	6161                	add	sp,sp,80
 6c0:	8082                	ret
    x = -xx;
 6c2:	40b005b3          	neg	a1,a1
    neg = 1;
 6c6:	4885                	li	a7,1
    x = -xx;
 6c8:	bfbd                	j	646 <printint+0x18>

00000000000006ca <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6ca:	711d                	add	sp,sp,-96
 6cc:	ec86                	sd	ra,88(sp)
 6ce:	e8a2                	sd	s0,80(sp)
 6d0:	e4a6                	sd	s1,72(sp)
 6d2:	e0ca                	sd	s2,64(sp)
 6d4:	fc4e                	sd	s3,56(sp)
 6d6:	f852                	sd	s4,48(sp)
 6d8:	f456                	sd	s5,40(sp)
 6da:	f05a                	sd	s6,32(sp)
 6dc:	ec5e                	sd	s7,24(sp)
 6de:	e862                	sd	s8,16(sp)
 6e0:	e466                	sd	s9,8(sp)
 6e2:	e06a                	sd	s10,0(sp)
 6e4:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6e6:	0005c903          	lbu	s2,0(a1)
 6ea:	26090563          	beqz	s2,954 <vprintf+0x28a>
 6ee:	8b2a                	mv	s6,a0
 6f0:	8a2e                	mv	s4,a1
 6f2:	8bb2                	mv	s7,a2
  state = 0;
 6f4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6f6:	4481                	li	s1,0
 6f8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6fa:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6fe:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 702:	06c00c93          	li	s9,108
 706:	a005                	j	726 <vprintf+0x5c>
        putc(fd, c0);
 708:	85ca                	mv	a1,s2
 70a:	855a                	mv	a0,s6
 70c:	f05ff0ef          	jal	610 <putc>
 710:	a019                	j	716 <vprintf+0x4c>
    } else if(state == '%'){
 712:	03598263          	beq	s3,s5,736 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 716:	2485                	addw	s1,s1,1
 718:	8726                	mv	a4,s1
 71a:	009a07b3          	add	a5,s4,s1
 71e:	0007c903          	lbu	s2,0(a5)
 722:	22090963          	beqz	s2,954 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 726:	0009079b          	sext.w	a5,s2
    if(state == 0){
 72a:	fe0994e3          	bnez	s3,712 <vprintf+0x48>
      if(c0 == '%'){
 72e:	fd579de3          	bne	a5,s5,708 <vprintf+0x3e>
        state = '%';
 732:	89be                	mv	s3,a5
 734:	b7cd                	j	716 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 736:	cbc9                	beqz	a5,7c8 <vprintf+0xfe>
 738:	00ea06b3          	add	a3,s4,a4
 73c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 740:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 742:	c681                	beqz	a3,74a <vprintf+0x80>
 744:	9752                	add	a4,a4,s4
 746:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 74a:	05878363          	beq	a5,s8,790 <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 74e:	05978d63          	beq	a5,s9,7a8 <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 752:	07500713          	li	a4,117
 756:	0ee78763          	beq	a5,a4,844 <vprintf+0x17a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 75a:	07800713          	li	a4,120
 75e:	12e78963          	beq	a5,a4,890 <vprintf+0x1c6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 762:	07000713          	li	a4,112
 766:	14e78e63          	beq	a5,a4,8c2 <vprintf+0x1f8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 76a:	06300713          	li	a4,99
 76e:	18e78c63          	beq	a5,a4,906 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 772:	07300713          	li	a4,115
 776:	1ae78263          	beq	a5,a4,91a <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 77a:	02500713          	li	a4,37
 77e:	04e79563          	bne	a5,a4,7c8 <vprintf+0xfe>
        putc(fd, '%');
 782:	02500593          	li	a1,37
 786:	855a                	mv	a0,s6
 788:	e89ff0ef          	jal	610 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 78c:	4981                	li	s3,0
 78e:	b761                	j	716 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 790:	008b8913          	add	s2,s7,8
 794:	4685                	li	a3,1
 796:	4629                	li	a2,10
 798:	000ba583          	lw	a1,0(s7)
 79c:	855a                	mv	a0,s6
 79e:	e91ff0ef          	jal	62e <printint>
 7a2:	8bca                	mv	s7,s2
      state = 0;
 7a4:	4981                	li	s3,0
 7a6:	bf85                	j	716 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 7a8:	06400793          	li	a5,100
 7ac:	02f68963          	beq	a3,a5,7de <vprintf+0x114>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7b0:	06c00793          	li	a5,108
 7b4:	04f68263          	beq	a3,a5,7f8 <vprintf+0x12e>
      } else if(c0 == 'l' && c1 == 'u'){
 7b8:	07500793          	li	a5,117
 7bc:	0af68063          	beq	a3,a5,85c <vprintf+0x192>
      } else if(c0 == 'l' && c1 == 'x'){
 7c0:	07800793          	li	a5,120
 7c4:	0ef68263          	beq	a3,a5,8a8 <vprintf+0x1de>
        putc(fd, '%');
 7c8:	02500593          	li	a1,37
 7cc:	855a                	mv	a0,s6
 7ce:	e43ff0ef          	jal	610 <putc>
        putc(fd, c0);
 7d2:	85ca                	mv	a1,s2
 7d4:	855a                	mv	a0,s6
 7d6:	e3bff0ef          	jal	610 <putc>
      state = 0;
 7da:	4981                	li	s3,0
 7dc:	bf2d                	j	716 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7de:	008b8913          	add	s2,s7,8
 7e2:	4685                	li	a3,1
 7e4:	4629                	li	a2,10
 7e6:	000bb583          	ld	a1,0(s7)
 7ea:	855a                	mv	a0,s6
 7ec:	e43ff0ef          	jal	62e <printint>
        i += 1;
 7f0:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 7f2:	8bca                	mv	s7,s2
      state = 0;
 7f4:	4981                	li	s3,0
        i += 1;
 7f6:	b705                	j	716 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7f8:	06400793          	li	a5,100
 7fc:	02f60763          	beq	a2,a5,82a <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 800:	07500793          	li	a5,117
 804:	06f60963          	beq	a2,a5,876 <vprintf+0x1ac>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 808:	07800793          	li	a5,120
 80c:	faf61ee3          	bne	a2,a5,7c8 <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 810:	008b8913          	add	s2,s7,8
 814:	4681                	li	a3,0
 816:	4641                	li	a2,16
 818:	000bb583          	ld	a1,0(s7)
 81c:	855a                	mv	a0,s6
 81e:	e11ff0ef          	jal	62e <printint>
        i += 2;
 822:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 824:	8bca                	mv	s7,s2
      state = 0;
 826:	4981                	li	s3,0
        i += 2;
 828:	b5fd                	j	716 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 82a:	008b8913          	add	s2,s7,8
 82e:	4685                	li	a3,1
 830:	4629                	li	a2,10
 832:	000bb583          	ld	a1,0(s7)
 836:	855a                	mv	a0,s6
 838:	df7ff0ef          	jal	62e <printint>
        i += 2;
 83c:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 83e:	8bca                	mv	s7,s2
      state = 0;
 840:	4981                	li	s3,0
        i += 2;
 842:	bdd1                	j	716 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 10, 0);
 844:	008b8913          	add	s2,s7,8
 848:	4681                	li	a3,0
 84a:	4629                	li	a2,10
 84c:	000be583          	lwu	a1,0(s7)
 850:	855a                	mv	a0,s6
 852:	dddff0ef          	jal	62e <printint>
 856:	8bca                	mv	s7,s2
      state = 0;
 858:	4981                	li	s3,0
 85a:	bd75                	j	716 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 85c:	008b8913          	add	s2,s7,8
 860:	4681                	li	a3,0
 862:	4629                	li	a2,10
 864:	000bb583          	ld	a1,0(s7)
 868:	855a                	mv	a0,s6
 86a:	dc5ff0ef          	jal	62e <printint>
        i += 1;
 86e:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 870:	8bca                	mv	s7,s2
      state = 0;
 872:	4981                	li	s3,0
        i += 1;
 874:	b54d                	j	716 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 876:	008b8913          	add	s2,s7,8
 87a:	4681                	li	a3,0
 87c:	4629                	li	a2,10
 87e:	000bb583          	ld	a1,0(s7)
 882:	855a                	mv	a0,s6
 884:	dabff0ef          	jal	62e <printint>
        i += 2;
 888:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 88a:	8bca                	mv	s7,s2
      state = 0;
 88c:	4981                	li	s3,0
        i += 2;
 88e:	b561                	j	716 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 16, 0);
 890:	008b8913          	add	s2,s7,8
 894:	4681                	li	a3,0
 896:	4641                	li	a2,16
 898:	000be583          	lwu	a1,0(s7)
 89c:	855a                	mv	a0,s6
 89e:	d91ff0ef          	jal	62e <printint>
 8a2:	8bca                	mv	s7,s2
      state = 0;
 8a4:	4981                	li	s3,0
 8a6:	bd85                	j	716 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 8a8:	008b8913          	add	s2,s7,8
 8ac:	4681                	li	a3,0
 8ae:	4641                	li	a2,16
 8b0:	000bb583          	ld	a1,0(s7)
 8b4:	855a                	mv	a0,s6
 8b6:	d79ff0ef          	jal	62e <printint>
        i += 1;
 8ba:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 8bc:	8bca                	mv	s7,s2
      state = 0;
 8be:	4981                	li	s3,0
        i += 1;
 8c0:	bd99                	j	716 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 8c2:	008b8d13          	add	s10,s7,8
 8c6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 8ca:	03000593          	li	a1,48
 8ce:	855a                	mv	a0,s6
 8d0:	d41ff0ef          	jal	610 <putc>
  putc(fd, 'x');
 8d4:	07800593          	li	a1,120
 8d8:	855a                	mv	a0,s6
 8da:	d37ff0ef          	jal	610 <putc>
 8de:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8e0:	00000b97          	auipc	s7,0x0
 8e4:	680b8b93          	add	s7,s7,1664 # f60 <digits>
 8e8:	03c9d793          	srl	a5,s3,0x3c
 8ec:	97de                	add	a5,a5,s7
 8ee:	0007c583          	lbu	a1,0(a5)
 8f2:	855a                	mv	a0,s6
 8f4:	d1dff0ef          	jal	610 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8f8:	0992                	sll	s3,s3,0x4
 8fa:	397d                	addw	s2,s2,-1
 8fc:	fe0916e3          	bnez	s2,8e8 <vprintf+0x21e>
        printptr(fd, va_arg(ap, uint64));
 900:	8bea                	mv	s7,s10
      state = 0;
 902:	4981                	li	s3,0
 904:	bd09                	j	716 <vprintf+0x4c>
        putc(fd, va_arg(ap, uint32));
 906:	008b8913          	add	s2,s7,8
 90a:	000bc583          	lbu	a1,0(s7)
 90e:	855a                	mv	a0,s6
 910:	d01ff0ef          	jal	610 <putc>
 914:	8bca                	mv	s7,s2
      state = 0;
 916:	4981                	li	s3,0
 918:	bbfd                	j	716 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 91a:	008b8993          	add	s3,s7,8
 91e:	000bb903          	ld	s2,0(s7)
 922:	00090f63          	beqz	s2,940 <vprintf+0x276>
        for(; *s; s++)
 926:	00094583          	lbu	a1,0(s2)
 92a:	c195                	beqz	a1,94e <vprintf+0x284>
          putc(fd, *s);
 92c:	855a                	mv	a0,s6
 92e:	ce3ff0ef          	jal	610 <putc>
        for(; *s; s++)
 932:	0905                	add	s2,s2,1
 934:	00094583          	lbu	a1,0(s2)
 938:	f9f5                	bnez	a1,92c <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 93a:	8bce                	mv	s7,s3
      state = 0;
 93c:	4981                	li	s3,0
 93e:	bbe1                	j	716 <vprintf+0x4c>
          s = "(null)";
 940:	00000917          	auipc	s2,0x0
 944:	61890913          	add	s2,s2,1560 # f58 <printf+0x5be>
        for(; *s; s++)
 948:	02800593          	li	a1,40
 94c:	b7c5                	j	92c <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 94e:	8bce                	mv	s7,s3
      state = 0;
 950:	4981                	li	s3,0
 952:	b3d1                	j	716 <vprintf+0x4c>
    }
  }
}
 954:	60e6                	ld	ra,88(sp)
 956:	6446                	ld	s0,80(sp)
 958:	64a6                	ld	s1,72(sp)
 95a:	6906                	ld	s2,64(sp)
 95c:	79e2                	ld	s3,56(sp)
 95e:	7a42                	ld	s4,48(sp)
 960:	7aa2                	ld	s5,40(sp)
 962:	7b02                	ld	s6,32(sp)
 964:	6be2                	ld	s7,24(sp)
 966:	6c42                	ld	s8,16(sp)
 968:	6ca2                	ld	s9,8(sp)
 96a:	6d02                	ld	s10,0(sp)
 96c:	6125                	add	sp,sp,96
 96e:	8082                	ret

0000000000000970 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 970:	715d                	add	sp,sp,-80
 972:	ec06                	sd	ra,24(sp)
 974:	e822                	sd	s0,16(sp)
 976:	1000                	add	s0,sp,32
 978:	e010                	sd	a2,0(s0)
 97a:	e414                	sd	a3,8(s0)
 97c:	e818                	sd	a4,16(s0)
 97e:	ec1c                	sd	a5,24(s0)
 980:	03043023          	sd	a6,32(s0)
 984:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 988:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 98c:	8622                	mv	a2,s0
 98e:	d3dff0ef          	jal	6ca <vprintf>
}
 992:	60e2                	ld	ra,24(sp)
 994:	6442                	ld	s0,16(sp)
 996:	6161                	add	sp,sp,80
 998:	8082                	ret

000000000000099a <printf>:

void
printf(const char *fmt, ...)
{
 99a:	711d                	add	sp,sp,-96
 99c:	ec06                	sd	ra,24(sp)
 99e:	e822                	sd	s0,16(sp)
 9a0:	1000                	add	s0,sp,32
 9a2:	e40c                	sd	a1,8(s0)
 9a4:	e810                	sd	a2,16(s0)
 9a6:	ec14                	sd	a3,24(s0)
 9a8:	f018                	sd	a4,32(s0)
 9aa:	f41c                	sd	a5,40(s0)
 9ac:	03043823          	sd	a6,48(s0)
 9b0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9b4:	00840613          	add	a2,s0,8
 9b8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9bc:	85aa                	mv	a1,a0
 9be:	4505                	li	a0,1
 9c0:	d0bff0ef          	jal	6ca <vprintf>
 9c4:	60e2                	ld	ra,24(sp)
 9c6:	6442                	ld	s0,16(sp)
 9c8:	6125                	add	sp,sp,96
 9ca:	8082                	ret
