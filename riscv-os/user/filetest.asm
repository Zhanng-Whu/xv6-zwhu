
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
  10:	9e450513          	add	a0,a0,-1564 # 9f0 <printf+0x3a>
  14:	1a3000ef          	jal	9b6 <printf>
    int fd = open("testfile", O_CREATE | O_RDWR);
  18:	20200593          	li	a1,514
  1c:	00001517          	auipc	a0,0x1
  20:	9ec50513          	add	a0,a0,-1556 # a08 <printf+0x52>
  24:	5c8000ef          	jal	5ec <open>
    if(fd < 0){
  28:	06054d63          	bltz	a0,a2 <test_read_and_write+0xa2>
  2c:	84aa                	mv	s1,a0
        printf("创建文件失败\n");
        return;
    }else{
        printf("创建文件成功，文件描述符： %d\n", fd);
  2e:	85aa                	mv	a1,a0
  30:	00001517          	auipc	a0,0x1
  34:	a0050513          	add	a0,a0,-1536 # a30 <printf+0x7a>
  38:	17f000ef          	jal	9b6 <printf>
    }


    printf("写入测试数据到文件\n");
  3c:	00001517          	auipc	a0,0x1
  40:	a2450513          	add	a0,a0,-1500 # a60 <printf+0xaa>
  44:	173000ef          	jal	9b6 <printf>
    char data[] = "Hello, RISC-V File System!";
  48:	00001797          	auipc	a5,0x1
  4c:	bc078793          	add	a5,a5,-1088 # c08 <printf+0x252>
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
  7a:	582000ef          	jal	5fc <write>
    if(write_bytes != sizeof(data)){
  7e:	47ed                	li	a5,27
  80:	02f50863          	beq	a0,a5,b0 <test_read_and_write+0xb0>
        printf("写入文件失败\n");
  84:	00001517          	auipc	a0,0x1
  88:	9fc50513          	add	a0,a0,-1540 # a80 <printf+0xca>
  8c:	12b000ef          	jal	9b6 <printf>
        close(fd);
  90:	8526                	mv	a0,s1
  92:	57a000ef          	jal	60c <close>
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
  a6:	97650513          	add	a0,a0,-1674 # a18 <printf+0x62>
  aa:	10d000ef          	jal	9b6 <printf>
        return;
  ae:	b7e5                	j	96 <test_read_and_write+0x96>
        printf("写入文件成功，写入字节数： %d\n", write_bytes);
  b0:	45ed                	li	a1,27
  b2:	00001517          	auipc	a0,0x1
  b6:	9e650513          	add	a0,a0,-1562 # a98 <printf+0xe2>
  ba:	0fd000ef          	jal	9b6 <printf>
    printf("重新打开文件测试\n");
  be:	00001517          	auipc	a0,0x1
  c2:	a0a50513          	add	a0,a0,-1526 # ac8 <printf+0x112>
  c6:	0f1000ef          	jal	9b6 <printf>
    fd = open("testfile", O_RDWR);
  ca:	4589                	li	a1,2
  cc:	00001517          	auipc	a0,0x1
  d0:	93c50513          	add	a0,a0,-1732 # a08 <printf+0x52>
  d4:	518000ef          	jal	5ec <open>
  d8:	84aa                	mv	s1,a0
    if(fd < 0){
  da:	04054b63          	bltz	a0,130 <test_read_and_write+0x130>
        printf("重新打开文件成功，文件描述符： %d\n", fd);
  de:	85aa                	mv	a1,a0
  e0:	00001517          	auipc	a0,0x1
  e4:	a2850513          	add	a0,a0,-1496 # b08 <printf+0x152>
  e8:	0cf000ef          	jal	9b6 <printf>
    printf("读取文件内容进行验证\n");
  ec:	00001517          	auipc	a0,0x1
  f0:	a5450513          	add	a0,a0,-1452 # b40 <printf+0x18a>
  f4:	0c3000ef          	jal	9b6 <printf>
    int read_bytes = read(fd, buffer, sizeof(data));
  f8:	466d                	li	a2,27
  fa:	f5840593          	add	a1,s0,-168
  fe:	8526                	mv	a0,s1
 100:	504000ef          	jal	604 <read>
 104:	892a                	mv	s2,a0
    printf("读取到的数据: %s\n", buffer);
 106:	f5840593          	add	a1,s0,-168
 10a:	00001517          	auipc	a0,0x1
 10e:	a5650513          	add	a0,a0,-1450 # b60 <printf+0x1aa>
 112:	0a5000ef          	jal	9b6 <printf>
    if(read_bytes != sizeof(data)){
 116:	47ed                	li	a5,27
 118:	02f90363          	beq	s2,a5,13e <test_read_and_write+0x13e>
        printf("读取文件失败\n");
 11c:	00001517          	auipc	a0,0x1
 120:	a5c50513          	add	a0,a0,-1444 # b78 <printf+0x1c2>
 124:	093000ef          	jal	9b6 <printf>
        close(fd);
 128:	8526                	mv	a0,s1
 12a:	4e2000ef          	jal	60c <close>
        return;
 12e:	b7a5                	j	96 <test_read_and_write+0x96>
        printf("重新打开文件失败\n");
 130:	00001517          	auipc	a0,0x1
 134:	9b850513          	add	a0,a0,-1608 # ae8 <printf+0x132>
 138:	07f000ef          	jal	9b6 <printf>
        return;
 13c:	bfa9                	j	96 <test_read_and_write+0x96>
        printf("读取文件成功，读取字节数： %d\n", read_bytes);
 13e:	45ed                	li	a1,27
 140:	00001517          	auipc	a0,0x1
 144:	a5050513          	add	a0,a0,-1456 # b90 <printf+0x1da>
 148:	06f000ef          	jal	9b6 <printf>
    printf("测试删除文件\n");
 14c:	00001517          	auipc	a0,0x1
 150:	a7450513          	add	a0,a0,-1420 # bc0 <printf+0x20a>
 154:	063000ef          	jal	9b6 <printf>
    if(unlink("testfile") < 0){
 158:	00001517          	auipc	a0,0x1
 15c:	8b050513          	add	a0,a0,-1872 # a08 <printf+0x52>
 160:	4bc000ef          	jal	61c <unlink>
 164:	00054963          	bltz	a0,176 <test_read_and_write+0x176>
        printf("删除文件成功\n");
 168:	00001517          	auipc	a0,0x1
 16c:	a8850513          	add	a0,a0,-1400 # bf0 <printf+0x23a>
 170:	047000ef          	jal	9b6 <printf>
 174:	b70d                	j	96 <test_read_and_write+0x96>
        printf("删除文件失败\n");
 176:	00001517          	auipc	a0,0x1
 17a:	a6250513          	add	a0,a0,-1438 # bd8 <printf+0x222>
 17e:	039000ef          	jal	9b6 <printf>
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
 196:	a9650513          	add	a0,a0,-1386 # c28 <printf+0x272>
 19a:	01d000ef          	jal	9b6 <printf>
  int i;
  int pid;

  // --- “大数组”在此定义 ---
  // 这是一个字符指针数组，直接存储了所有需要的文件名。
  char *filenames[] = {
 19e:	00001797          	auipc	a5,0x1
 1a2:	d8a78793          	add	a5,a5,-630 # f28 <printf+0x572>
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
 1ee:	3de000ef          	jal	5cc <fork>
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
 202:	3d2000ef          	jal	5d4 <wait>
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
 212:	ab250513          	add	a0,a0,-1358 # cc0 <printf+0x30a>
 216:	7a0000ef          	jal	9b6 <printf>

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
 22c:	a2850513          	add	a0,a0,-1496 # c50 <printf+0x29a>
 230:	786000ef          	jal	9b6 <printf>
      exit(1);
 234:	4505                	li	a0,1
 236:	38e000ef          	jal	5c4 <exit>
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
 256:	396000ef          	jal	5ec <open>
 25a:	84aa                	mv	s1,a0
        if (fd >= 0) {
 25c:	04054d63          	bltz	a0,2b6 <test_concurrent_access_with_array+0x132>
          if(write(fd, &j, sizeof(j)) != sizeof(j)){
 260:	4611                	li	a2,4
 262:	f7c40593          	add	a1,s0,-132
 266:	396000ef          	jal	5fc <write>
 26a:	4791                	li	a5,4
 26c:	02f51b63          	bne	a0,a5,2a2 <test_concurrent_access_with_array+0x11e>
          close(fd);
 270:	8526                	mv	a0,s1
 272:	39a000ef          	jal	60c <close>
          unlink(filename);
 276:	854a                	mv	a0,s2
 278:	3a4000ef          	jal	61c <unlink>
      for (j = 0; j < 100; j++) {
 27c:	f7c42783          	lw	a5,-132(s0)
 280:	2785                	addw	a5,a5,1
 282:	0007871b          	sext.w	a4,a5
 286:	f6f42e23          	sw	a5,-132(s0)
 28a:	fce9d3e3          	bge	s3,a4,250 <test_concurrent_access_with_array+0xcc>
      printf("Child process for file %s finished.\n", filename);
 28e:	85ca                	mv	a1,s2
 290:	00001517          	auipc	a0,0x1
 294:	9f850513          	add	a0,a0,-1544 # c88 <printf+0x2d2>
 298:	71e000ef          	jal	9b6 <printf>
      exit(0);
 29c:	4501                	li	a0,0
 29e:	326000ef          	jal	5c4 <exit>
            printf("write to %s failed\n", filename);
 2a2:	85ca                	mv	a1,s2
 2a4:	00001517          	auipc	a0,0x1
 2a8:	9bc50513          	add	a0,a0,-1604 # c60 <printf+0x2aa>
 2ac:	70a000ef          	jal	9b6 <printf>
            exit(1);
 2b0:	4505                	li	a0,1
 2b2:	312000ef          	jal	5c4 <exit>
            printf("open %s failed\n", filename);
 2b6:	85ca                	mv	a1,s2
 2b8:	00001517          	auipc	a0,0x1
 2bc:	9c050513          	add	a0,a0,-1600 # c78 <printf+0x2c2>
 2c0:	6f6000ef          	jal	9b6 <printf>
            exit(1);
 2c4:	4505                	li	a0,1
 2c6:	2fe000ef          	jal	5c4 <exit>
      printf("wait failed\n");
 2ca:	00001517          	auipc	a0,0x1
 2ce:	9e650513          	add	a0,a0,-1562 # cb0 <printf+0x2fa>
 2d2:	6e4000ef          	jal	9b6 <printf>
      exit(1);
 2d6:	4505                	li	a0,1
 2d8:	2ec000ef          	jal	5c4 <exit>

00000000000002dc <test_filesystem_performance>:

void
test_filesystem_performance(void)
{
 2dc:	ba010113          	add	sp,sp,-1120
 2e0:	44113c23          	sd	ra,1112(sp)
 2e4:	44813823          	sd	s0,1104(sp)
 2e8:	44913423          	sd	s1,1096(sp)
 2ec:	45213023          	sd	s2,1088(sp)
 2f0:	43313c23          	sd	s3,1080(sp)
 2f4:	43413823          	sd	s4,1072(sp)
 2f8:	43513423          	sd	s5,1064(sp)
 2fc:	43613023          	sd	s6,1056(sp)
 300:	46010413          	add	s0,sp,1120
  printf("文件IO性能测试\n");
 304:	00001517          	auipc	a0,0x1
 308:	9f450513          	add	a0,a0,-1548 # cf8 <printf+0x342>
 30c:	6aa000ef          	jal	9b6 <printf>
  
  uint start_time;
  int fd, i;
  
  // --- 大量小文件测试 ---
  printf("开始小文件测试 (50 个文件)...\n");
 310:	00001517          	auipc	a0,0x1
 314:	a0050513          	add	a0,a0,-1536 # d10 <printf+0x35a>
 318:	69e000ef          	jal	9b6 <printf>
  start_time = uptime();
 31c:	308000ef          	jal	624 <uptime>
 320:	00050b1b          	sext.w	s6,a0

  for (i = 0; i < 50; i++) {
 324:	4901                	li	s2,0
    char filename[32];
    strcpy(filename, "small_");
 326:	00001a17          	auipc	s4,0x1
 32a:	a1aa0a13          	add	s4,s4,-1510 # d40 <printf+0x38a>
    fd = open(filename, O_CREATE | O_WRONLY);
    if (fd < 0) {
      printf("performance test: open small file failed\n");
      exit(1);
    }
    if (write(fd, "test", 4) != 4) {
 32e:	00001997          	auipc	s3,0x1
 332:	a4a98993          	add	s3,s3,-1462 # d78 <printf+0x3c2>
  for (i = 0; i < 50; i++) {
 336:	03200a93          	li	s5,50
    strcpy(filename, "small_");
 33a:	85d2                	mv	a1,s4
 33c:	ba040513          	add	a0,s0,-1120
 340:	20c000ef          	jal	54c <strcpy>
    itoa(i, filename + strlen(filename));
 344:	ba040513          	add	a0,s0,-1120
 348:	21e000ef          	jal	566 <strlen>
 34c:	02051593          	sll	a1,a0,0x20
 350:	9181                	srl	a1,a1,0x20
 352:	ba040793          	add	a5,s0,-1120
 356:	95be                	add	a1,a1,a5
 358:	854a                	mv	a0,s2
 35a:	168000ef          	jal	4c2 <itoa>
    fd = open(filename, O_CREATE | O_WRONLY);
 35e:	20100593          	li	a1,513
 362:	ba040513          	add	a0,s0,-1120
 366:	286000ef          	jal	5ec <open>
 36a:	84aa                	mv	s1,a0
    if (fd < 0) {
 36c:	0e054063          	bltz	a0,44c <test_filesystem_performance+0x170>
    if (write(fd, "test", 4) != 4) {
 370:	4611                	li	a2,4
 372:	85ce                	mv	a1,s3
 374:	288000ef          	jal	5fc <write>
 378:	4791                	li	a5,4
 37a:	0ef51263          	bne	a0,a5,45e <test_filesystem_performance+0x182>
      printf("performance test: write small file failed\n");
      exit(1);
    }
    close(fd);
 37e:	8526                	mv	a0,s1
 380:	28c000ef          	jal	60c <close>
  for (i = 0; i < 50; i++) {
 384:	2905                	addw	s2,s2,1
 386:	fb591ae3          	bne	s2,s5,33a <test_filesystem_performance+0x5e>
  }

  uint small_files_time = uptime() - start_time;
 38a:	29a000ef          	jal	624 <uptime>
 38e:	41650b3b          	subw	s6,a0,s6

  // --- 大文件测试 ---
  printf("开始大文件测试 (1 个 10KB 文件)...\n");
 392:	00001517          	auipc	a0,0x1
 396:	a1e50513          	add	a0,a0,-1506 # db0 <printf+0x3fa>
 39a:	61c000ef          	jal	9b6 <printf>
  char large_buffer[1024]; // 1 KB buffer
  start_time = uptime();
 39e:	286000ef          	jal	624 <uptime>
 3a2:	00050a1b          	sext.w	s4,a0

  fd = open("large_file", O_CREATE | O_WRONLY);
 3a6:	20100593          	li	a1,513
 3aa:	00001517          	auipc	a0,0x1
 3ae:	a3650513          	add	a0,a0,-1482 # de0 <printf+0x42a>
 3b2:	23a000ef          	jal	5ec <open>
 3b6:	892a                	mv	s2,a0
  if (fd < 0) {
 3b8:	44a9                	li	s1,10
 3ba:	0a054b63          	bltz	a0,470 <test_filesystem_performance+0x194>
    printf("performance test: open large file failed\n");
    exit(1);
  }
  for (i = 0; i < 10; i++) { // 10 * 1KB = 10Kb
    if (write(fd, large_buffer, sizeof(large_buffer)) != sizeof(large_buffer)) {
 3be:	40000613          	li	a2,1024
 3c2:	bc040593          	add	a1,s0,-1088
 3c6:	854a                	mv	a0,s2
 3c8:	234000ef          	jal	5fc <write>
 3cc:	40000793          	li	a5,1024
 3d0:	0af51963          	bne	a0,a5,482 <test_filesystem_performance+0x1a6>
  for (i = 0; i < 10; i++) { // 10 * 1KB = 10Kb
 3d4:	34fd                	addw	s1,s1,-1
 3d6:	f4e5                	bnez	s1,3be <test_filesystem_performance+0xe2>
      printf("performance test: write large file failed\n");
      exit(1);
    }
  }
  close(fd);
 3d8:	854a                	mv	a0,s2
 3da:	232000ef          	jal	60c <close>

  uint large_file_time = uptime() - start_time;
 3de:	246000ef          	jal	624 <uptime>
 3e2:	41450a3b          	subw	s4,a0,s4

  // --- 打印结果 ---
  printf("\n 性能测试结果 \n");
 3e6:	00001517          	auipc	a0,0x1
 3ea:	a6a50513          	add	a0,a0,-1430 # e50 <printf+0x49a>
 3ee:	5c8000ef          	jal	9b6 <printf>
  // 中文输出
  printf("小文件 (50x4B) 耗时: %d ticks\n", small_files_time);
 3f2:	85da                	mv	a1,s6
 3f4:	00001517          	auipc	a0,0x1
 3f8:	a7450513          	add	a0,a0,-1420 # e68 <printf+0x4b2>
 3fc:	5ba000ef          	jal	9b6 <printf>
  printf("大文件 (1x10KB) 耗时:    %d ticks\n", large_file_time);
 400:	85d2                	mv	a1,s4
 402:	00001517          	auipc	a0,0x1
 406:	a8e50513          	add	a0,a0,-1394 # e90 <printf+0x4da>
 40a:	5ac000ef          	jal	9b6 <printf>

  unlink("large_file");
 40e:	00001517          	auipc	a0,0x1
 412:	9d250513          	add	a0,a0,-1582 # de0 <printf+0x42a>
 416:	206000ef          	jal	61c <unlink>

  printf("测试 3 成功完成。\n");
 41a:	00001517          	auipc	a0,0x1
 41e:	a9e50513          	add	a0,a0,-1378 # eb8 <printf+0x502>
 422:	594000ef          	jal	9b6 <printf>
}
 426:	45813083          	ld	ra,1112(sp)
 42a:	45013403          	ld	s0,1104(sp)
 42e:	44813483          	ld	s1,1096(sp)
 432:	44013903          	ld	s2,1088(sp)
 436:	43813983          	ld	s3,1080(sp)
 43a:	43013a03          	ld	s4,1072(sp)
 43e:	42813a83          	ld	s5,1064(sp)
 442:	42013b03          	ld	s6,1056(sp)
 446:	46010113          	add	sp,sp,1120
 44a:	8082                	ret
      printf("performance test: open small file failed\n");
 44c:	00001517          	auipc	a0,0x1
 450:	8fc50513          	add	a0,a0,-1796 # d48 <printf+0x392>
 454:	562000ef          	jal	9b6 <printf>
      exit(1);
 458:	4505                	li	a0,1
 45a:	16a000ef          	jal	5c4 <exit>
      printf("performance test: write small file failed\n");
 45e:	00001517          	auipc	a0,0x1
 462:	92250513          	add	a0,a0,-1758 # d80 <printf+0x3ca>
 466:	550000ef          	jal	9b6 <printf>
      exit(1);
 46a:	4505                	li	a0,1
 46c:	158000ef          	jal	5c4 <exit>
    printf("performance test: open large file failed\n");
 470:	00001517          	auipc	a0,0x1
 474:	98050513          	add	a0,a0,-1664 # df0 <printf+0x43a>
 478:	53e000ef          	jal	9b6 <printf>
    exit(1);
 47c:	4505                	li	a0,1
 47e:	146000ef          	jal	5c4 <exit>
      printf("performance test: write large file failed\n");
 482:	00001517          	auipc	a0,0x1
 486:	99e50513          	add	a0,a0,-1634 # e20 <printf+0x46a>
 48a:	52c000ef          	jal	9b6 <printf>
      exit(1);
 48e:	4505                	li	a0,1
 490:	134000ef          	jal	5c4 <exit>

0000000000000494 <main>:


int main(int argc, char const *argv[])
{
 494:	1141                	add	sp,sp,-16
 496:	e406                	sd	ra,8(sp)
 498:	e022                	sd	s0,0(sp)
 49a:	0800                	add	s0,sp,16

    test_read_and_write();
 49c:	b65ff0ef          	jal	0 <test_read_and_write>
    test_concurrent_access_with_array();
 4a0:	ce5ff0ef          	jal	184 <test_concurrent_access_with_array>
    test_filesystem_performance();
 4a4:	e39ff0ef          	jal	2dc <test_filesystem_performance>
    return 0;
}
 4a8:	4501                	li	a0,0
 4aa:	60a2                	ld	ra,8(sp)
 4ac:	6402                	ld	s0,0(sp)
 4ae:	0141                	add	sp,sp,16
 4b0:	8082                	ret

00000000000004b2 <start>:
#include "include/user.h"


void
start(int argc, char **argv)
{
 4b2:	1141                	add	sp,sp,-16
 4b4:	e406                	sd	ra,8(sp)
 4b6:	e022                	sd	s0,0(sp)
 4b8:	0800                	add	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 4ba:	fdbff0ef          	jal	494 <main>


  exit(r);
 4be:	106000ef          	jal	5c4 <exit>

00000000000004c2 <itoa>:
{
  char temp[16];
  int i = 0;
  int j = 0;

  if (n == 0) {
 4c2:	cd25                	beqz	a0,53a <itoa+0x78>
{
 4c4:	1101                	add	sp,sp,-32
 4c6:	ec22                	sd	s0,24(sp)
 4c8:	1000                	add	s0,sp,32
    buf[1] = '\0';
    return;
  }
  
  // Generate digits in reverse order
  while (n > 0) {
 4ca:	fe040693          	add	a3,s0,-32
  int i = 0;
 4ce:	4701                	li	a4,0
    temp[i++] = (n % 10) + '0';
 4d0:	4829                	li	a6,10
  while (n > 0) {
 4d2:	48a5                	li	a7,9
    n /= 10;
  }
  temp[i] = '\0';

  // Reverse the string to get the correct order
  for (j = 0; j < i; j++) {
 4d4:	4601                	li	a2,0
  while (n > 0) {
 4d6:	04a05c63          	blez	a0,52e <itoa+0x6c>
    temp[i++] = (n % 10) + '0';
 4da:	863a                	mv	a2,a4
 4dc:	2705                	addw	a4,a4,1
 4de:	030567bb          	remw	a5,a0,a6
 4e2:	0307879b          	addw	a5,a5,48
 4e6:	00f68023          	sb	a5,0(a3)
    n /= 10;
 4ea:	87aa                	mv	a5,a0
 4ec:	0305453b          	divw	a0,a0,a6
  while (n > 0) {
 4f0:	0685                	add	a3,a3,1
 4f2:	fef8c4e3          	blt	a7,a5,4da <itoa+0x18>
  temp[i] = '\0';
 4f6:	ff070793          	add	a5,a4,-16
 4fa:	97a2                	add	a5,a5,s0
 4fc:	fe078823          	sb	zero,-16(a5)
  for (j = 0; j < i; j++) {
 500:	04e05463          	blez	a4,548 <itoa+0x86>
 504:	fe040793          	add	a5,s0,-32
 508:	00c786b3          	add	a3,a5,a2
 50c:	87ae                	mv	a5,a1
    buf[j] = temp[i - 1 - j];
 50e:	0006c703          	lbu	a4,0(a3)
 512:	00e78023          	sb	a4,0(a5)
  for (j = 0; j < i; j++) {
 516:	16fd                	add	a3,a3,-1
 518:	0785                	add	a5,a5,1
 51a:	40b7873b          	subw	a4,a5,a1
 51e:	377d                	addw	a4,a4,-1
 520:	fec747e3          	blt	a4,a2,50e <itoa+0x4c>
 524:	fff64793          	not	a5,a2
 528:	97fd                	sra	a5,a5,0x3f
 52a:	8e7d                	and	a2,a2,a5
 52c:	2605                	addw	a2,a2,1
  }
  buf[j] = '\0';
 52e:	95b2                	add	a1,a1,a2
 530:	00058023          	sb	zero,0(a1)
}
 534:	6462                	ld	s0,24(sp)
 536:	6105                	add	sp,sp,32
 538:	8082                	ret
    buf[0] = '0';
 53a:	03000793          	li	a5,48
 53e:	00f58023          	sb	a5,0(a1)
    buf[1] = '\0';
 542:	000580a3          	sb	zero,1(a1)
    return;
 546:	8082                	ret
  for (j = 0; j < i; j++) {
 548:	4601                	li	a2,0
 54a:	b7d5                	j	52e <itoa+0x6c>

000000000000054c <strcpy>:

void strcpy(char *dst, const char *src) {
 54c:	1141                	add	sp,sp,-16
 54e:	e422                	sd	s0,8(sp)
 550:	0800                	add	s0,sp,16
    while ((*dst++ = *src++) != '\0');
 552:	0585                	add	a1,a1,1
 554:	0505                	add	a0,a0,1
 556:	fff5c783          	lbu	a5,-1(a1)
 55a:	fef50fa3          	sb	a5,-1(a0)
 55e:	fbf5                	bnez	a5,552 <strcpy+0x6>
} 
 560:	6422                	ld	s0,8(sp)
 562:	0141                	add	sp,sp,16
 564:	8082                	ret

0000000000000566 <strlen>:

uint
strlen(const char *s){
 566:	1141                	add	sp,sp,-16
 568:	e422                	sd	s0,8(sp)
 56a:	0800                	add	s0,sp,16
  int n;
  for(n = 0; s[n]; n++);
 56c:	00054783          	lbu	a5,0(a0)
 570:	cf91                	beqz	a5,58c <strlen+0x26>
 572:	0505                	add	a0,a0,1
 574:	87aa                	mv	a5,a0
 576:	86be                	mv	a3,a5
 578:	0785                	add	a5,a5,1
 57a:	fff7c703          	lbu	a4,-1(a5)
 57e:	ff65                	bnez	a4,576 <strlen+0x10>
 580:	40a6853b          	subw	a0,a3,a0
 584:	2505                	addw	a0,a0,1
  return n;
}
 586:	6422                	ld	s0,8(sp)
 588:	0141                	add	sp,sp,16
 58a:	8082                	ret
  for(n = 0; s[n]; n++);
 58c:	4501                	li	a0,0
 58e:	bfe5                	j	586 <strlen+0x20>

0000000000000590 <strcmp>:

uint
strcmp(const char *p, const char *q)
{
 590:	1141                	add	sp,sp,-16
 592:	e422                	sd	s0,8(sp)
 594:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 596:	00054783          	lbu	a5,0(a0)
 59a:	cb91                	beqz	a5,5ae <strcmp+0x1e>
 59c:	0005c703          	lbu	a4,0(a1)
 5a0:	00f71763          	bne	a4,a5,5ae <strcmp+0x1e>
    p++, q++;
 5a4:	0505                	add	a0,a0,1
 5a6:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 5a8:	00054783          	lbu	a5,0(a0)
 5ac:	fbe5                	bnez	a5,59c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 5ae:	0005c503          	lbu	a0,0(a1)
}
 5b2:	40a7853b          	subw	a0,a5,a0
 5b6:	6422                	ld	s0,8(sp)
 5b8:	0141                	add	sp,sp,16
 5ba:	8082                	ret

00000000000005bc <hello>:
# generated by usys.pl - do not edit
#include "include/syscall.h"
.global hello
hello:
 li a7, SYS_hello
 5bc:	4885                	li	a7,1
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 5c4:	4889                	li	a7,2
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <fork>:
.global fork
fork:
 li a7, SYS_fork
 5cc:	4891                	li	a7,4
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 5d4:	488d                	li	a7,3
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <exec>:
.global exec
exec:
 li a7, SYS_exec
 5dc:	4895                	li	a7,5
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5e4:	489d                	li	a7,7
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <open>:
.global open
open:
 li a7, SYS_open
 5ec:	4899                	li	a7,6
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5f4:	48a1                	li	a7,8
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <write>:
.global write
write:
 li a7, SYS_write
 5fc:	48a5                	li	a7,9
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <read>:
.global read
read:
 li a7, SYS_read
 604:	48a9                	li	a7,10
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <close>:
.global close
close:
 li a7, SYS_close
 60c:	48ad                	li	a7,11
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 614:	48b1                	li	a7,12
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 61c:	48b5                	li	a7,13
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 624:	48b9                	li	a7,14
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 62c:	1101                	add	sp,sp,-32
 62e:	ec06                	sd	ra,24(sp)
 630:	e822                	sd	s0,16(sp)
 632:	1000                	add	s0,sp,32
 634:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 638:	4605                	li	a2,1
 63a:	fef40593          	add	a1,s0,-17
 63e:	fbfff0ef          	jal	5fc <write>
}
 642:	60e2                	ld	ra,24(sp)
 644:	6442                	ld	s0,16(sp)
 646:	6105                	add	sp,sp,32
 648:	8082                	ret

000000000000064a <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 64a:	715d                	add	sp,sp,-80
 64c:	e486                	sd	ra,72(sp)
 64e:	e0a2                	sd	s0,64(sp)
 650:	fc26                	sd	s1,56(sp)
 652:	f84a                	sd	s2,48(sp)
 654:	f44e                	sd	s3,40(sp)
 656:	0880                	add	s0,sp,80
 658:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 65a:	c299                	beqz	a3,660 <printint+0x16>
 65c:	0805c163          	bltz	a1,6de <printint+0x94>
  neg = 0;
 660:	4881                	li	a7,0
 662:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 666:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 668:	00001517          	auipc	a0,0x1
 66c:	91850513          	add	a0,a0,-1768 # f80 <digits>
 670:	883e                	mv	a6,a5
 672:	2785                	addw	a5,a5,1
 674:	02c5f733          	remu	a4,a1,a2
 678:	972a                	add	a4,a4,a0
 67a:	00074703          	lbu	a4,0(a4)
 67e:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 682:	872e                	mv	a4,a1
 684:	02c5d5b3          	divu	a1,a1,a2
 688:	0685                	add	a3,a3,1
 68a:	fec773e3          	bgeu	a4,a2,670 <printint+0x26>
  if(neg)
 68e:	00088b63          	beqz	a7,6a4 <printint+0x5a>
    buf[i++] = '-';
 692:	fd078793          	add	a5,a5,-48
 696:	97a2                	add	a5,a5,s0
 698:	02d00713          	li	a4,45
 69c:	fee78423          	sb	a4,-24(a5)
 6a0:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 6a4:	02f05663          	blez	a5,6d0 <printint+0x86>
 6a8:	fb840713          	add	a4,s0,-72
 6ac:	00f704b3          	add	s1,a4,a5
 6b0:	fff70993          	add	s3,a4,-1
 6b4:	99be                	add	s3,s3,a5
 6b6:	37fd                	addw	a5,a5,-1
 6b8:	1782                	sll	a5,a5,0x20
 6ba:	9381                	srl	a5,a5,0x20
 6bc:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 6c0:	fff4c583          	lbu	a1,-1(s1)
 6c4:	854a                	mv	a0,s2
 6c6:	f67ff0ef          	jal	62c <putc>
  while(--i >= 0)
 6ca:	14fd                	add	s1,s1,-1
 6cc:	ff349ae3          	bne	s1,s3,6c0 <printint+0x76>
}
 6d0:	60a6                	ld	ra,72(sp)
 6d2:	6406                	ld	s0,64(sp)
 6d4:	74e2                	ld	s1,56(sp)
 6d6:	7942                	ld	s2,48(sp)
 6d8:	79a2                	ld	s3,40(sp)
 6da:	6161                	add	sp,sp,80
 6dc:	8082                	ret
    x = -xx;
 6de:	40b005b3          	neg	a1,a1
    neg = 1;
 6e2:	4885                	li	a7,1
    x = -xx;
 6e4:	bfbd                	j	662 <printint+0x18>

00000000000006e6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6e6:	711d                	add	sp,sp,-96
 6e8:	ec86                	sd	ra,88(sp)
 6ea:	e8a2                	sd	s0,80(sp)
 6ec:	e4a6                	sd	s1,72(sp)
 6ee:	e0ca                	sd	s2,64(sp)
 6f0:	fc4e                	sd	s3,56(sp)
 6f2:	f852                	sd	s4,48(sp)
 6f4:	f456                	sd	s5,40(sp)
 6f6:	f05a                	sd	s6,32(sp)
 6f8:	ec5e                	sd	s7,24(sp)
 6fa:	e862                	sd	s8,16(sp)
 6fc:	e466                	sd	s9,8(sp)
 6fe:	e06a                	sd	s10,0(sp)
 700:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 702:	0005c903          	lbu	s2,0(a1)
 706:	26090563          	beqz	s2,970 <vprintf+0x28a>
 70a:	8b2a                	mv	s6,a0
 70c:	8a2e                	mv	s4,a1
 70e:	8bb2                	mv	s7,a2
  state = 0;
 710:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 712:	4481                	li	s1,0
 714:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 716:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 71a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 71e:	06c00c93          	li	s9,108
 722:	a005                	j	742 <vprintf+0x5c>
        putc(fd, c0);
 724:	85ca                	mv	a1,s2
 726:	855a                	mv	a0,s6
 728:	f05ff0ef          	jal	62c <putc>
 72c:	a019                	j	732 <vprintf+0x4c>
    } else if(state == '%'){
 72e:	03598263          	beq	s3,s5,752 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 732:	2485                	addw	s1,s1,1
 734:	8726                	mv	a4,s1
 736:	009a07b3          	add	a5,s4,s1
 73a:	0007c903          	lbu	s2,0(a5)
 73e:	22090963          	beqz	s2,970 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 742:	0009079b          	sext.w	a5,s2
    if(state == 0){
 746:	fe0994e3          	bnez	s3,72e <vprintf+0x48>
      if(c0 == '%'){
 74a:	fd579de3          	bne	a5,s5,724 <vprintf+0x3e>
        state = '%';
 74e:	89be                	mv	s3,a5
 750:	b7cd                	j	732 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 752:	cbc9                	beqz	a5,7e4 <vprintf+0xfe>
 754:	00ea06b3          	add	a3,s4,a4
 758:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 75c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 75e:	c681                	beqz	a3,766 <vprintf+0x80>
 760:	9752                	add	a4,a4,s4
 762:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 766:	05878363          	beq	a5,s8,7ac <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 76a:	05978d63          	beq	a5,s9,7c4 <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 76e:	07500713          	li	a4,117
 772:	0ee78763          	beq	a5,a4,860 <vprintf+0x17a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 776:	07800713          	li	a4,120
 77a:	12e78963          	beq	a5,a4,8ac <vprintf+0x1c6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 77e:	07000713          	li	a4,112
 782:	14e78e63          	beq	a5,a4,8de <vprintf+0x1f8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 786:	06300713          	li	a4,99
 78a:	18e78c63          	beq	a5,a4,922 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 78e:	07300713          	li	a4,115
 792:	1ae78263          	beq	a5,a4,936 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 796:	02500713          	li	a4,37
 79a:	04e79563          	bne	a5,a4,7e4 <vprintf+0xfe>
        putc(fd, '%');
 79e:	02500593          	li	a1,37
 7a2:	855a                	mv	a0,s6
 7a4:	e89ff0ef          	jal	62c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 7a8:	4981                	li	s3,0
 7aa:	b761                	j	732 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 7ac:	008b8913          	add	s2,s7,8
 7b0:	4685                	li	a3,1
 7b2:	4629                	li	a2,10
 7b4:	000ba583          	lw	a1,0(s7)
 7b8:	855a                	mv	a0,s6
 7ba:	e91ff0ef          	jal	64a <printint>
 7be:	8bca                	mv	s7,s2
      state = 0;
 7c0:	4981                	li	s3,0
 7c2:	bf85                	j	732 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 7c4:	06400793          	li	a5,100
 7c8:	02f68963          	beq	a3,a5,7fa <vprintf+0x114>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7cc:	06c00793          	li	a5,108
 7d0:	04f68263          	beq	a3,a5,814 <vprintf+0x12e>
      } else if(c0 == 'l' && c1 == 'u'){
 7d4:	07500793          	li	a5,117
 7d8:	0af68063          	beq	a3,a5,878 <vprintf+0x192>
      } else if(c0 == 'l' && c1 == 'x'){
 7dc:	07800793          	li	a5,120
 7e0:	0ef68263          	beq	a3,a5,8c4 <vprintf+0x1de>
        putc(fd, '%');
 7e4:	02500593          	li	a1,37
 7e8:	855a                	mv	a0,s6
 7ea:	e43ff0ef          	jal	62c <putc>
        putc(fd, c0);
 7ee:	85ca                	mv	a1,s2
 7f0:	855a                	mv	a0,s6
 7f2:	e3bff0ef          	jal	62c <putc>
      state = 0;
 7f6:	4981                	li	s3,0
 7f8:	bf2d                	j	732 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7fa:	008b8913          	add	s2,s7,8
 7fe:	4685                	li	a3,1
 800:	4629                	li	a2,10
 802:	000bb583          	ld	a1,0(s7)
 806:	855a                	mv	a0,s6
 808:	e43ff0ef          	jal	64a <printint>
        i += 1;
 80c:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 80e:	8bca                	mv	s7,s2
      state = 0;
 810:	4981                	li	s3,0
        i += 1;
 812:	b705                	j	732 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 814:	06400793          	li	a5,100
 818:	02f60763          	beq	a2,a5,846 <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 81c:	07500793          	li	a5,117
 820:	06f60963          	beq	a2,a5,892 <vprintf+0x1ac>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 824:	07800793          	li	a5,120
 828:	faf61ee3          	bne	a2,a5,7e4 <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 82c:	008b8913          	add	s2,s7,8
 830:	4681                	li	a3,0
 832:	4641                	li	a2,16
 834:	000bb583          	ld	a1,0(s7)
 838:	855a                	mv	a0,s6
 83a:	e11ff0ef          	jal	64a <printint>
        i += 2;
 83e:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 840:	8bca                	mv	s7,s2
      state = 0;
 842:	4981                	li	s3,0
        i += 2;
 844:	b5fd                	j	732 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 846:	008b8913          	add	s2,s7,8
 84a:	4685                	li	a3,1
 84c:	4629                	li	a2,10
 84e:	000bb583          	ld	a1,0(s7)
 852:	855a                	mv	a0,s6
 854:	df7ff0ef          	jal	64a <printint>
        i += 2;
 858:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 85a:	8bca                	mv	s7,s2
      state = 0;
 85c:	4981                	li	s3,0
        i += 2;
 85e:	bdd1                	j	732 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 10, 0);
 860:	008b8913          	add	s2,s7,8
 864:	4681                	li	a3,0
 866:	4629                	li	a2,10
 868:	000be583          	lwu	a1,0(s7)
 86c:	855a                	mv	a0,s6
 86e:	dddff0ef          	jal	64a <printint>
 872:	8bca                	mv	s7,s2
      state = 0;
 874:	4981                	li	s3,0
 876:	bd75                	j	732 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 878:	008b8913          	add	s2,s7,8
 87c:	4681                	li	a3,0
 87e:	4629                	li	a2,10
 880:	000bb583          	ld	a1,0(s7)
 884:	855a                	mv	a0,s6
 886:	dc5ff0ef          	jal	64a <printint>
        i += 1;
 88a:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 88c:	8bca                	mv	s7,s2
      state = 0;
 88e:	4981                	li	s3,0
        i += 1;
 890:	b54d                	j	732 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 892:	008b8913          	add	s2,s7,8
 896:	4681                	li	a3,0
 898:	4629                	li	a2,10
 89a:	000bb583          	ld	a1,0(s7)
 89e:	855a                	mv	a0,s6
 8a0:	dabff0ef          	jal	64a <printint>
        i += 2;
 8a4:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 8a6:	8bca                	mv	s7,s2
      state = 0;
 8a8:	4981                	li	s3,0
        i += 2;
 8aa:	b561                	j	732 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 16, 0);
 8ac:	008b8913          	add	s2,s7,8
 8b0:	4681                	li	a3,0
 8b2:	4641                	li	a2,16
 8b4:	000be583          	lwu	a1,0(s7)
 8b8:	855a                	mv	a0,s6
 8ba:	d91ff0ef          	jal	64a <printint>
 8be:	8bca                	mv	s7,s2
      state = 0;
 8c0:	4981                	li	s3,0
 8c2:	bd85                	j	732 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 8c4:	008b8913          	add	s2,s7,8
 8c8:	4681                	li	a3,0
 8ca:	4641                	li	a2,16
 8cc:	000bb583          	ld	a1,0(s7)
 8d0:	855a                	mv	a0,s6
 8d2:	d79ff0ef          	jal	64a <printint>
        i += 1;
 8d6:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 8d8:	8bca                	mv	s7,s2
      state = 0;
 8da:	4981                	li	s3,0
        i += 1;
 8dc:	bd99                	j	732 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 8de:	008b8d13          	add	s10,s7,8
 8e2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 8e6:	03000593          	li	a1,48
 8ea:	855a                	mv	a0,s6
 8ec:	d41ff0ef          	jal	62c <putc>
  putc(fd, 'x');
 8f0:	07800593          	li	a1,120
 8f4:	855a                	mv	a0,s6
 8f6:	d37ff0ef          	jal	62c <putc>
 8fa:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8fc:	00000b97          	auipc	s7,0x0
 900:	684b8b93          	add	s7,s7,1668 # f80 <digits>
 904:	03c9d793          	srl	a5,s3,0x3c
 908:	97de                	add	a5,a5,s7
 90a:	0007c583          	lbu	a1,0(a5)
 90e:	855a                	mv	a0,s6
 910:	d1dff0ef          	jal	62c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 914:	0992                	sll	s3,s3,0x4
 916:	397d                	addw	s2,s2,-1
 918:	fe0916e3          	bnez	s2,904 <vprintf+0x21e>
        printptr(fd, va_arg(ap, uint64));
 91c:	8bea                	mv	s7,s10
      state = 0;
 91e:	4981                	li	s3,0
 920:	bd09                	j	732 <vprintf+0x4c>
        putc(fd, va_arg(ap, uint32));
 922:	008b8913          	add	s2,s7,8
 926:	000bc583          	lbu	a1,0(s7)
 92a:	855a                	mv	a0,s6
 92c:	d01ff0ef          	jal	62c <putc>
 930:	8bca                	mv	s7,s2
      state = 0;
 932:	4981                	li	s3,0
 934:	bbfd                	j	732 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 936:	008b8993          	add	s3,s7,8
 93a:	000bb903          	ld	s2,0(s7)
 93e:	00090f63          	beqz	s2,95c <vprintf+0x276>
        for(; *s; s++)
 942:	00094583          	lbu	a1,0(s2)
 946:	c195                	beqz	a1,96a <vprintf+0x284>
          putc(fd, *s);
 948:	855a                	mv	a0,s6
 94a:	ce3ff0ef          	jal	62c <putc>
        for(; *s; s++)
 94e:	0905                	add	s2,s2,1
 950:	00094583          	lbu	a1,0(s2)
 954:	f9f5                	bnez	a1,948 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 956:	8bce                	mv	s7,s3
      state = 0;
 958:	4981                	li	s3,0
 95a:	bbe1                	j	732 <vprintf+0x4c>
          s = "(null)";
 95c:	00000917          	auipc	s2,0x0
 960:	61c90913          	add	s2,s2,1564 # f78 <printf+0x5c2>
        for(; *s; s++)
 964:	02800593          	li	a1,40
 968:	b7c5                	j	948 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 96a:	8bce                	mv	s7,s3
      state = 0;
 96c:	4981                	li	s3,0
 96e:	b3d1                	j	732 <vprintf+0x4c>
    }
  }
}
 970:	60e6                	ld	ra,88(sp)
 972:	6446                	ld	s0,80(sp)
 974:	64a6                	ld	s1,72(sp)
 976:	6906                	ld	s2,64(sp)
 978:	79e2                	ld	s3,56(sp)
 97a:	7a42                	ld	s4,48(sp)
 97c:	7aa2                	ld	s5,40(sp)
 97e:	7b02                	ld	s6,32(sp)
 980:	6be2                	ld	s7,24(sp)
 982:	6c42                	ld	s8,16(sp)
 984:	6ca2                	ld	s9,8(sp)
 986:	6d02                	ld	s10,0(sp)
 988:	6125                	add	sp,sp,96
 98a:	8082                	ret

000000000000098c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 98c:	715d                	add	sp,sp,-80
 98e:	ec06                	sd	ra,24(sp)
 990:	e822                	sd	s0,16(sp)
 992:	1000                	add	s0,sp,32
 994:	e010                	sd	a2,0(s0)
 996:	e414                	sd	a3,8(s0)
 998:	e818                	sd	a4,16(s0)
 99a:	ec1c                	sd	a5,24(s0)
 99c:	03043023          	sd	a6,32(s0)
 9a0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9a4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9a8:	8622                	mv	a2,s0
 9aa:	d3dff0ef          	jal	6e6 <vprintf>
}
 9ae:	60e2                	ld	ra,24(sp)
 9b0:	6442                	ld	s0,16(sp)
 9b2:	6161                	add	sp,sp,80
 9b4:	8082                	ret

00000000000009b6 <printf>:

void
printf(const char *fmt, ...)
{
 9b6:	711d                	add	sp,sp,-96
 9b8:	ec06                	sd	ra,24(sp)
 9ba:	e822                	sd	s0,16(sp)
 9bc:	1000                	add	s0,sp,32
 9be:	e40c                	sd	a1,8(s0)
 9c0:	e810                	sd	a2,16(s0)
 9c2:	ec14                	sd	a3,24(s0)
 9c4:	f018                	sd	a4,32(s0)
 9c6:	f41c                	sd	a5,40(s0)
 9c8:	03043823          	sd	a6,48(s0)
 9cc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9d0:	00840613          	add	a2,s0,8
 9d4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9d8:	85aa                	mv	a1,a0
 9da:	4505                	li	a0,1
 9dc:	d0bff0ef          	jal	6e6 <vprintf>
 9e0:	60e2                	ld	ra,24(sp)
 9e2:	6442                	ld	s0,16(sp)
 9e4:	6125                	add	sp,sp,96
 9e6:	8082                	ret
