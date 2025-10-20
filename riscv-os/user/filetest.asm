
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
  10:	a3450513          	add	a0,a0,-1484 # a40 <printf+0x3a>
  14:	1f3000ef          	jal	a06 <printf>
    int fd = open("testfile", O_CREATE | O_RDWR);
  18:	20200593          	li	a1,514
  1c:	00001517          	auipc	a0,0x1
  20:	a3c50513          	add	a0,a0,-1476 # a58 <printf+0x52>
  24:	610000ef          	jal	634 <open>
    if(fd < 0){
  28:	06054d63          	bltz	a0,a2 <test_read_and_write+0xa2>
  2c:	84aa                	mv	s1,a0
        printf("创建文件失败\n");
        return;
    }else{
        printf("创建文件成功，文件描述符： %d\n", fd);
  2e:	85aa                	mv	a1,a0
  30:	00001517          	auipc	a0,0x1
  34:	a5050513          	add	a0,a0,-1456 # a80 <printf+0x7a>
  38:	1cf000ef          	jal	a06 <printf>
    }


    printf("写入测试数据到文件\n");
  3c:	00001517          	auipc	a0,0x1
  40:	a7450513          	add	a0,a0,-1420 # ab0 <printf+0xaa>
  44:	1c3000ef          	jal	a06 <printf>
    char data[] = "Hello, RISC-V File System!";
  48:	00001797          	auipc	a5,0x1
  4c:	c1078793          	add	a5,a5,-1008 # c58 <printf+0x252>
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
  7a:	5ca000ef          	jal	644 <write>
    if(write_bytes != sizeof(data)){
  7e:	47ed                	li	a5,27
  80:	02f50863          	beq	a0,a5,b0 <test_read_and_write+0xb0>
        printf("写入文件失败\n");
  84:	00001517          	auipc	a0,0x1
  88:	a4c50513          	add	a0,a0,-1460 # ad0 <printf+0xca>
  8c:	17b000ef          	jal	a06 <printf>
        close(fd);
  90:	8526                	mv	a0,s1
  92:	5c2000ef          	jal	654 <close>
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
  a6:	9c650513          	add	a0,a0,-1594 # a68 <printf+0x62>
  aa:	15d000ef          	jal	a06 <printf>
        return;
  ae:	b7e5                	j	96 <test_read_and_write+0x96>
        printf("写入文件成功，写入字节数： %d\n", write_bytes);
  b0:	45ed                	li	a1,27
  b2:	00001517          	auipc	a0,0x1
  b6:	a3650513          	add	a0,a0,-1482 # ae8 <printf+0xe2>
  ba:	14d000ef          	jal	a06 <printf>
    printf("重新打开文件测试\n");
  be:	00001517          	auipc	a0,0x1
  c2:	a5a50513          	add	a0,a0,-1446 # b18 <printf+0x112>
  c6:	141000ef          	jal	a06 <printf>
    fd = open("testfile", O_RDWR);
  ca:	4589                	li	a1,2
  cc:	00001517          	auipc	a0,0x1
  d0:	98c50513          	add	a0,a0,-1652 # a58 <printf+0x52>
  d4:	560000ef          	jal	634 <open>
  d8:	84aa                	mv	s1,a0
    if(fd < 0){
  da:	04054b63          	bltz	a0,130 <test_read_and_write+0x130>
        printf("重新打开文件成功，文件描述符： %d\n", fd);
  de:	85aa                	mv	a1,a0
  e0:	00001517          	auipc	a0,0x1
  e4:	a7850513          	add	a0,a0,-1416 # b58 <printf+0x152>
  e8:	11f000ef          	jal	a06 <printf>
    printf("读取文件内容进行验证\n");
  ec:	00001517          	auipc	a0,0x1
  f0:	aa450513          	add	a0,a0,-1372 # b90 <printf+0x18a>
  f4:	113000ef          	jal	a06 <printf>
    int read_bytes = read(fd, buffer, sizeof(data));
  f8:	466d                	li	a2,27
  fa:	f5840593          	add	a1,s0,-168
  fe:	8526                	mv	a0,s1
 100:	54c000ef          	jal	64c <read>
 104:	892a                	mv	s2,a0
    printf("读取到的数据: %s\n", buffer);
 106:	f5840593          	add	a1,s0,-168
 10a:	00001517          	auipc	a0,0x1
 10e:	aa650513          	add	a0,a0,-1370 # bb0 <printf+0x1aa>
 112:	0f5000ef          	jal	a06 <printf>
    if(read_bytes != sizeof(data)){
 116:	47ed                	li	a5,27
 118:	02f90363          	beq	s2,a5,13e <test_read_and_write+0x13e>
        printf("读取文件失败\n");
 11c:	00001517          	auipc	a0,0x1
 120:	aac50513          	add	a0,a0,-1364 # bc8 <printf+0x1c2>
 124:	0e3000ef          	jal	a06 <printf>
        close(fd);
 128:	8526                	mv	a0,s1
 12a:	52a000ef          	jal	654 <close>
        return;
 12e:	b7a5                	j	96 <test_read_and_write+0x96>
        printf("重新打开文件失败\n");
 130:	00001517          	auipc	a0,0x1
 134:	a0850513          	add	a0,a0,-1528 # b38 <printf+0x132>
 138:	0cf000ef          	jal	a06 <printf>
        return;
 13c:	bfa9                	j	96 <test_read_and_write+0x96>
        printf("读取文件成功，读取字节数： %d\n", read_bytes);
 13e:	45ed                	li	a1,27
 140:	00001517          	auipc	a0,0x1
 144:	aa050513          	add	a0,a0,-1376 # be0 <printf+0x1da>
 148:	0bf000ef          	jal	a06 <printf>
    printf("测试删除文件\n");
 14c:	00001517          	auipc	a0,0x1
 150:	ac450513          	add	a0,a0,-1340 # c10 <printf+0x20a>
 154:	0b3000ef          	jal	a06 <printf>
    if(unlink("testfile") < 0){
 158:	00001517          	auipc	a0,0x1
 15c:	90050513          	add	a0,a0,-1792 # a58 <printf+0x52>
 160:	504000ef          	jal	664 <unlink>
 164:	00054963          	bltz	a0,176 <test_read_and_write+0x176>
        printf("删除文件成功\n");
 168:	00001517          	auipc	a0,0x1
 16c:	ad850513          	add	a0,a0,-1320 # c40 <printf+0x23a>
 170:	097000ef          	jal	a06 <printf>
 174:	b70d                	j	96 <test_read_and_write+0x96>
        printf("删除文件失败\n");
 176:	00001517          	auipc	a0,0x1
 17a:	ab250513          	add	a0,a0,-1358 # c28 <printf+0x222>
 17e:	089000ef          	jal	a06 <printf>
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
 196:	ae650513          	add	a0,a0,-1306 # c78 <printf+0x272>
 19a:	06d000ef          	jal	a06 <printf>
  int i;
  int pid;

  // --- “大数组”在此定义 ---
  // 这是一个字符指针数组，直接存储了所有需要的文件名。
  char *filenames[] = {
 19e:	00001797          	auipc	a5,0x1
 1a2:	dda78793          	add	a5,a5,-550 # f78 <printf+0x572>
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
 1ee:	426000ef          	jal	614 <fork>
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
 202:	41a000ef          	jal	61c <wait>
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
 212:	b0250513          	add	a0,a0,-1278 # d10 <printf+0x30a>
 216:	7f0000ef          	jal	a06 <printf>

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
 22c:	a7850513          	add	a0,a0,-1416 # ca0 <printf+0x29a>
 230:	7d6000ef          	jal	a06 <printf>
      exit(1);
 234:	4505                	li	a0,1
 236:	3d6000ef          	jal	60c <exit>
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
 256:	3de000ef          	jal	634 <open>
 25a:	84aa                	mv	s1,a0
        if (fd >= 0) {
 25c:	04054d63          	bltz	a0,2b6 <test_concurrent_access_with_array+0x132>
          if(write(fd, &j, sizeof(j)) != sizeof(j)){
 260:	4611                	li	a2,4
 262:	f7c40593          	add	a1,s0,-132
 266:	3de000ef          	jal	644 <write>
 26a:	4791                	li	a5,4
 26c:	02f51b63          	bne	a0,a5,2a2 <test_concurrent_access_with_array+0x11e>
          close(fd);
 270:	8526                	mv	a0,s1
 272:	3e2000ef          	jal	654 <close>
          unlink(filename);
 276:	854a                	mv	a0,s2
 278:	3ec000ef          	jal	664 <unlink>
      for (j = 0; j < 100; j++) {
 27c:	f7c42783          	lw	a5,-132(s0)
 280:	2785                	addw	a5,a5,1
 282:	0007871b          	sext.w	a4,a5
 286:	f6f42e23          	sw	a5,-132(s0)
 28a:	fce9d3e3          	bge	s3,a4,250 <test_concurrent_access_with_array+0xcc>
      printf("Child process for file %s finished.\n", filename);
 28e:	85ca                	mv	a1,s2
 290:	00001517          	auipc	a0,0x1
 294:	a4850513          	add	a0,a0,-1464 # cd8 <printf+0x2d2>
 298:	76e000ef          	jal	a06 <printf>
      exit(0);
 29c:	4501                	li	a0,0
 29e:	36e000ef          	jal	60c <exit>
            printf("write to %s failed\n", filename);
 2a2:	85ca                	mv	a1,s2
 2a4:	00001517          	auipc	a0,0x1
 2a8:	a0c50513          	add	a0,a0,-1524 # cb0 <printf+0x2aa>
 2ac:	75a000ef          	jal	a06 <printf>
            exit(1);
 2b0:	4505                	li	a0,1
 2b2:	35a000ef          	jal	60c <exit>
            printf("open %s failed\n", filename);
 2b6:	85ca                	mv	a1,s2
 2b8:	00001517          	auipc	a0,0x1
 2bc:	a1050513          	add	a0,a0,-1520 # cc8 <printf+0x2c2>
 2c0:	746000ef          	jal	a06 <printf>
            exit(1);
 2c4:	4505                	li	a0,1
 2c6:	346000ef          	jal	60c <exit>
      printf("wait failed\n");
 2ca:	00001517          	auipc	a0,0x1
 2ce:	a3650513          	add	a0,a0,-1482 # d00 <printf+0x2fa>
 2d2:	734000ef          	jal	a06 <printf>
      exit(1);
 2d6:	4505                	li	a0,1
 2d8:	334000ef          	jal	60c <exit>

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
 308:	a4450513          	add	a0,a0,-1468 # d48 <printf+0x342>
 30c:	6fa000ef          	jal	a06 <printf>
  
  uint start_time;
  int fd, i;
  
  // --- 大量小文件测试 ---
  printf("开始小文件测试 (50 个文件)...\n");
 310:	00001517          	auipc	a0,0x1
 314:	a5050513          	add	a0,a0,-1456 # d60 <printf+0x35a>
 318:	6ee000ef          	jal	a06 <printf>
  start_time = uptime();
 31c:	350000ef          	jal	66c <uptime>
 320:	00050b1b          	sext.w	s6,a0

  for (i = 0; i < 50; i++) {
 324:	4901                	li	s2,0
    char filename[32];
    strcpy(filename, "small_");
 326:	00001a17          	auipc	s4,0x1
 32a:	a6aa0a13          	add	s4,s4,-1430 # d90 <printf+0x38a>
    fd = open(filename, O_CREATE | O_WRONLY);
    if (fd < 0) {
      printf("performance test: open small file failed\n");
      exit(1);
    }
    if (write(fd, "test", 4) != 4) {
 32e:	00001997          	auipc	s3,0x1
 332:	a9a98993          	add	s3,s3,-1382 # dc8 <printf+0x3c2>
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
 366:	2ce000ef          	jal	634 <open>
 36a:	84aa                	mv	s1,a0
    if (fd < 0) {
 36c:	0e054063          	bltz	a0,44c <test_filesystem_performance+0x170>
    if (write(fd, "test", 4) != 4) {
 370:	4611                	li	a2,4
 372:	85ce                	mv	a1,s3
 374:	2d0000ef          	jal	644 <write>
 378:	4791                	li	a5,4
 37a:	0ef51263          	bne	a0,a5,45e <test_filesystem_performance+0x182>
      printf("performance test: write small file failed\n");
      exit(1);
    }
    close(fd);
 37e:	8526                	mv	a0,s1
 380:	2d4000ef          	jal	654 <close>
  for (i = 0; i < 50; i++) {
 384:	2905                	addw	s2,s2,1
 386:	fb591ae3          	bne	s2,s5,33a <test_filesystem_performance+0x5e>
  }

  uint small_files_time = uptime() - start_time;
 38a:	2e2000ef          	jal	66c <uptime>
 38e:	41650b3b          	subw	s6,a0,s6

  // --- 大文件测试 ---
  printf("开始大文件测试 (1 个 10KB 文件)...\n");
 392:	00001517          	auipc	a0,0x1
 396:	a6e50513          	add	a0,a0,-1426 # e00 <printf+0x3fa>
 39a:	66c000ef          	jal	a06 <printf>
  char large_buffer[1024]; // 1 KB buffer
  start_time = uptime();
 39e:	2ce000ef          	jal	66c <uptime>
 3a2:	00050a1b          	sext.w	s4,a0

  fd = open("large_file", O_CREATE | O_WRONLY);
 3a6:	20100593          	li	a1,513
 3aa:	00001517          	auipc	a0,0x1
 3ae:	a8650513          	add	a0,a0,-1402 # e30 <printf+0x42a>
 3b2:	282000ef          	jal	634 <open>
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
 3c8:	27c000ef          	jal	644 <write>
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
 3da:	27a000ef          	jal	654 <close>

  uint large_file_time = uptime() - start_time;
 3de:	28e000ef          	jal	66c <uptime>
 3e2:	41450a3b          	subw	s4,a0,s4

  // --- 打印结果 ---
  printf("\n 性能测试结果 \n");
 3e6:	00001517          	auipc	a0,0x1
 3ea:	aba50513          	add	a0,a0,-1350 # ea0 <printf+0x49a>
 3ee:	618000ef          	jal	a06 <printf>
  // 中文输出
  printf("小文件 (50x4B) 耗时: %d ticks\n", small_files_time);
 3f2:	85da                	mv	a1,s6
 3f4:	00001517          	auipc	a0,0x1
 3f8:	ac450513          	add	a0,a0,-1340 # eb8 <printf+0x4b2>
 3fc:	60a000ef          	jal	a06 <printf>
  printf("大文件 (1x10KB) 耗时:    %d ticks\n", large_file_time);
 400:	85d2                	mv	a1,s4
 402:	00001517          	auipc	a0,0x1
 406:	ade50513          	add	a0,a0,-1314 # ee0 <printf+0x4da>
 40a:	5fc000ef          	jal	a06 <printf>

  unlink("large_file");
 40e:	00001517          	auipc	a0,0x1
 412:	a2250513          	add	a0,a0,-1502 # e30 <printf+0x42a>
 416:	24e000ef          	jal	664 <unlink>

  printf("测试 3 成功完成。\n");
 41a:	00001517          	auipc	a0,0x1
 41e:	aee50513          	add	a0,a0,-1298 # f08 <printf+0x502>
 422:	5e4000ef          	jal	a06 <printf>
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
 450:	94c50513          	add	a0,a0,-1716 # d98 <printf+0x392>
 454:	5b2000ef          	jal	a06 <printf>
      exit(1);
 458:	4505                	li	a0,1
 45a:	1b2000ef          	jal	60c <exit>
      printf("performance test: write small file failed\n");
 45e:	00001517          	auipc	a0,0x1
 462:	97250513          	add	a0,a0,-1678 # dd0 <printf+0x3ca>
 466:	5a0000ef          	jal	a06 <printf>
      exit(1);
 46a:	4505                	li	a0,1
 46c:	1a0000ef          	jal	60c <exit>
    printf("performance test: open large file failed\n");
 470:	00001517          	auipc	a0,0x1
 474:	9d050513          	add	a0,a0,-1584 # e40 <printf+0x43a>
 478:	58e000ef          	jal	a06 <printf>
    exit(1);
 47c:	4505                	li	a0,1
 47e:	18e000ef          	jal	60c <exit>
      printf("performance test: write large file failed\n");
 482:	00001517          	auipc	a0,0x1
 486:	9ee50513          	add	a0,a0,-1554 # e70 <printf+0x46a>
 48a:	57c000ef          	jal	a06 <printf>
      exit(1);
 48e:	4505                	li	a0,1
 490:	17c000ef          	jal	60c <exit>

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
 4be:	14e000ef          	jal	60c <exit>

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

00000000000005bc <atoi>:
int
atoi(const char *s)
{
 5bc:	1141                	add	sp,sp,-16
 5be:	e422                	sd	s0,8(sp)
 5c0:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5c2:	00054683          	lbu	a3,0(a0)
 5c6:	fd06879b          	addw	a5,a3,-48
 5ca:	0ff7f793          	zext.b	a5,a5
 5ce:	4625                	li	a2,9
 5d0:	02f66863          	bltu	a2,a5,600 <atoi+0x44>
 5d4:	872a                	mv	a4,a0
  n = 0;
 5d6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 5d8:	0705                	add	a4,a4,1
 5da:	0025179b          	sllw	a5,a0,0x2
 5de:	9fa9                	addw	a5,a5,a0
 5e0:	0017979b          	sllw	a5,a5,0x1
 5e4:	9fb5                	addw	a5,a5,a3
 5e6:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 5ea:	00074683          	lbu	a3,0(a4)
 5ee:	fd06879b          	addw	a5,a3,-48
 5f2:	0ff7f793          	zext.b	a5,a5
 5f6:	fef671e3          	bgeu	a2,a5,5d8 <atoi+0x1c>
  return n;
 5fa:	6422                	ld	s0,8(sp)
 5fc:	0141                	add	sp,sp,16
 5fe:	8082                	ret
  n = 0;
 600:	4501                	li	a0,0
 602:	bfe5                	j	5fa <atoi+0x3e>

0000000000000604 <hello>:
# generated by usys.pl - do not edit
#include "include/syscall.h"
.global hello
hello:
 li a7, SYS_hello
 604:	4885                	li	a7,1
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <exit>:
.global exit
exit:
 li a7, SYS_exit
 60c:	4889                	li	a7,2
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <fork>:
.global fork
fork:
 li a7, SYS_fork
 614:	4891                	li	a7,4
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <wait>:
.global wait
wait:
 li a7, SYS_wait
 61c:	488d                	li	a7,3
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <exec>:
.global exec
exec:
 li a7, SYS_exec
 624:	4895                	li	a7,5
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <dup>:
.global dup
dup:
 li a7, SYS_dup
 62c:	489d                	li	a7,7
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <open>:
.global open
open:
 li a7, SYS_open
 634:	4899                	li	a7,6
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 63c:	48a1                	li	a7,8
 ecall
 63e:	00000073          	ecall
 ret
 642:	8082                	ret

0000000000000644 <write>:
.global write
write:
 li a7, SYS_write
 644:	48a5                	li	a7,9
 ecall
 646:	00000073          	ecall
 ret
 64a:	8082                	ret

000000000000064c <read>:
.global read
read:
 li a7, SYS_read
 64c:	48a9                	li	a7,10
 ecall
 64e:	00000073          	ecall
 ret
 652:	8082                	ret

0000000000000654 <close>:
.global close
close:
 li a7, SYS_close
 654:	48ad                	li	a7,11
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 65c:	48b1                	li	a7,12
 ecall
 65e:	00000073          	ecall
 ret
 662:	8082                	ret

0000000000000664 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 664:	48b5                	li	a7,13
 ecall
 666:	00000073          	ecall
 ret
 66a:	8082                	ret

000000000000066c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 66c:	48b9                	li	a7,14
 ecall
 66e:	00000073          	ecall
 ret
 672:	8082                	ret

0000000000000674 <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
 674:	48bd                	li	a7,15
 ecall
 676:	00000073          	ecall
 ret
 67a:	8082                	ret

000000000000067c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 67c:	1101                	add	sp,sp,-32
 67e:	ec06                	sd	ra,24(sp)
 680:	e822                	sd	s0,16(sp)
 682:	1000                	add	s0,sp,32
 684:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 688:	4605                	li	a2,1
 68a:	fef40593          	add	a1,s0,-17
 68e:	fb7ff0ef          	jal	644 <write>
}
 692:	60e2                	ld	ra,24(sp)
 694:	6442                	ld	s0,16(sp)
 696:	6105                	add	sp,sp,32
 698:	8082                	ret

000000000000069a <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 69a:	715d                	add	sp,sp,-80
 69c:	e486                	sd	ra,72(sp)
 69e:	e0a2                	sd	s0,64(sp)
 6a0:	fc26                	sd	s1,56(sp)
 6a2:	f84a                	sd	s2,48(sp)
 6a4:	f44e                	sd	s3,40(sp)
 6a6:	0880                	add	s0,sp,80
 6a8:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 6aa:	c299                	beqz	a3,6b0 <printint+0x16>
 6ac:	0805c163          	bltz	a1,72e <printint+0x94>
  neg = 0;
 6b0:	4881                	li	a7,0
 6b2:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 6b6:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 6b8:	00001517          	auipc	a0,0x1
 6bc:	91850513          	add	a0,a0,-1768 # fd0 <digits>
 6c0:	883e                	mv	a6,a5
 6c2:	2785                	addw	a5,a5,1
 6c4:	02c5f733          	remu	a4,a1,a2
 6c8:	972a                	add	a4,a4,a0
 6ca:	00074703          	lbu	a4,0(a4)
 6ce:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 6d2:	872e                	mv	a4,a1
 6d4:	02c5d5b3          	divu	a1,a1,a2
 6d8:	0685                	add	a3,a3,1
 6da:	fec773e3          	bgeu	a4,a2,6c0 <printint+0x26>
  if(neg)
 6de:	00088b63          	beqz	a7,6f4 <printint+0x5a>
    buf[i++] = '-';
 6e2:	fd078793          	add	a5,a5,-48
 6e6:	97a2                	add	a5,a5,s0
 6e8:	02d00713          	li	a4,45
 6ec:	fee78423          	sb	a4,-24(a5)
 6f0:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 6f4:	02f05663          	blez	a5,720 <printint+0x86>
 6f8:	fb840713          	add	a4,s0,-72
 6fc:	00f704b3          	add	s1,a4,a5
 700:	fff70993          	add	s3,a4,-1
 704:	99be                	add	s3,s3,a5
 706:	37fd                	addw	a5,a5,-1
 708:	1782                	sll	a5,a5,0x20
 70a:	9381                	srl	a5,a5,0x20
 70c:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 710:	fff4c583          	lbu	a1,-1(s1)
 714:	854a                	mv	a0,s2
 716:	f67ff0ef          	jal	67c <putc>
  while(--i >= 0)
 71a:	14fd                	add	s1,s1,-1
 71c:	ff349ae3          	bne	s1,s3,710 <printint+0x76>
}
 720:	60a6                	ld	ra,72(sp)
 722:	6406                	ld	s0,64(sp)
 724:	74e2                	ld	s1,56(sp)
 726:	7942                	ld	s2,48(sp)
 728:	79a2                	ld	s3,40(sp)
 72a:	6161                	add	sp,sp,80
 72c:	8082                	ret
    x = -xx;
 72e:	40b005b3          	neg	a1,a1
    neg = 1;
 732:	4885                	li	a7,1
    x = -xx;
 734:	bfbd                	j	6b2 <printint+0x18>

0000000000000736 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 736:	711d                	add	sp,sp,-96
 738:	ec86                	sd	ra,88(sp)
 73a:	e8a2                	sd	s0,80(sp)
 73c:	e4a6                	sd	s1,72(sp)
 73e:	e0ca                	sd	s2,64(sp)
 740:	fc4e                	sd	s3,56(sp)
 742:	f852                	sd	s4,48(sp)
 744:	f456                	sd	s5,40(sp)
 746:	f05a                	sd	s6,32(sp)
 748:	ec5e                	sd	s7,24(sp)
 74a:	e862                	sd	s8,16(sp)
 74c:	e466                	sd	s9,8(sp)
 74e:	e06a                	sd	s10,0(sp)
 750:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 752:	0005c903          	lbu	s2,0(a1)
 756:	26090563          	beqz	s2,9c0 <vprintf+0x28a>
 75a:	8b2a                	mv	s6,a0
 75c:	8a2e                	mv	s4,a1
 75e:	8bb2                	mv	s7,a2
  state = 0;
 760:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 762:	4481                	li	s1,0
 764:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 766:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 76a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 76e:	06c00c93          	li	s9,108
 772:	a005                	j	792 <vprintf+0x5c>
        putc(fd, c0);
 774:	85ca                	mv	a1,s2
 776:	855a                	mv	a0,s6
 778:	f05ff0ef          	jal	67c <putc>
 77c:	a019                	j	782 <vprintf+0x4c>
    } else if(state == '%'){
 77e:	03598263          	beq	s3,s5,7a2 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 782:	2485                	addw	s1,s1,1
 784:	8726                	mv	a4,s1
 786:	009a07b3          	add	a5,s4,s1
 78a:	0007c903          	lbu	s2,0(a5)
 78e:	22090963          	beqz	s2,9c0 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 792:	0009079b          	sext.w	a5,s2
    if(state == 0){
 796:	fe0994e3          	bnez	s3,77e <vprintf+0x48>
      if(c0 == '%'){
 79a:	fd579de3          	bne	a5,s5,774 <vprintf+0x3e>
        state = '%';
 79e:	89be                	mv	s3,a5
 7a0:	b7cd                	j	782 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 7a2:	cbc9                	beqz	a5,834 <vprintf+0xfe>
 7a4:	00ea06b3          	add	a3,s4,a4
 7a8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 7ac:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 7ae:	c681                	beqz	a3,7b6 <vprintf+0x80>
 7b0:	9752                	add	a4,a4,s4
 7b2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 7b6:	05878363          	beq	a5,s8,7fc <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 7ba:	05978d63          	beq	a5,s9,814 <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 7be:	07500713          	li	a4,117
 7c2:	0ee78763          	beq	a5,a4,8b0 <vprintf+0x17a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 7c6:	07800713          	li	a4,120
 7ca:	12e78963          	beq	a5,a4,8fc <vprintf+0x1c6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 7ce:	07000713          	li	a4,112
 7d2:	14e78e63          	beq	a5,a4,92e <vprintf+0x1f8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 7d6:	06300713          	li	a4,99
 7da:	18e78c63          	beq	a5,a4,972 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 7de:	07300713          	li	a4,115
 7e2:	1ae78263          	beq	a5,a4,986 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 7e6:	02500713          	li	a4,37
 7ea:	04e79563          	bne	a5,a4,834 <vprintf+0xfe>
        putc(fd, '%');
 7ee:	02500593          	li	a1,37
 7f2:	855a                	mv	a0,s6
 7f4:	e89ff0ef          	jal	67c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 7f8:	4981                	li	s3,0
 7fa:	b761                	j	782 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 7fc:	008b8913          	add	s2,s7,8
 800:	4685                	li	a3,1
 802:	4629                	li	a2,10
 804:	000ba583          	lw	a1,0(s7)
 808:	855a                	mv	a0,s6
 80a:	e91ff0ef          	jal	69a <printint>
 80e:	8bca                	mv	s7,s2
      state = 0;
 810:	4981                	li	s3,0
 812:	bf85                	j	782 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 814:	06400793          	li	a5,100
 818:	02f68963          	beq	a3,a5,84a <vprintf+0x114>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 81c:	06c00793          	li	a5,108
 820:	04f68263          	beq	a3,a5,864 <vprintf+0x12e>
      } else if(c0 == 'l' && c1 == 'u'){
 824:	07500793          	li	a5,117
 828:	0af68063          	beq	a3,a5,8c8 <vprintf+0x192>
      } else if(c0 == 'l' && c1 == 'x'){
 82c:	07800793          	li	a5,120
 830:	0ef68263          	beq	a3,a5,914 <vprintf+0x1de>
        putc(fd, '%');
 834:	02500593          	li	a1,37
 838:	855a                	mv	a0,s6
 83a:	e43ff0ef          	jal	67c <putc>
        putc(fd, c0);
 83e:	85ca                	mv	a1,s2
 840:	855a                	mv	a0,s6
 842:	e3bff0ef          	jal	67c <putc>
      state = 0;
 846:	4981                	li	s3,0
 848:	bf2d                	j	782 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 84a:	008b8913          	add	s2,s7,8
 84e:	4685                	li	a3,1
 850:	4629                	li	a2,10
 852:	000bb583          	ld	a1,0(s7)
 856:	855a                	mv	a0,s6
 858:	e43ff0ef          	jal	69a <printint>
        i += 1;
 85c:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 85e:	8bca                	mv	s7,s2
      state = 0;
 860:	4981                	li	s3,0
        i += 1;
 862:	b705                	j	782 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 864:	06400793          	li	a5,100
 868:	02f60763          	beq	a2,a5,896 <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 86c:	07500793          	li	a5,117
 870:	06f60963          	beq	a2,a5,8e2 <vprintf+0x1ac>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 874:	07800793          	li	a5,120
 878:	faf61ee3          	bne	a2,a5,834 <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 87c:	008b8913          	add	s2,s7,8
 880:	4681                	li	a3,0
 882:	4641                	li	a2,16
 884:	000bb583          	ld	a1,0(s7)
 888:	855a                	mv	a0,s6
 88a:	e11ff0ef          	jal	69a <printint>
        i += 2;
 88e:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 890:	8bca                	mv	s7,s2
      state = 0;
 892:	4981                	li	s3,0
        i += 2;
 894:	b5fd                	j	782 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 896:	008b8913          	add	s2,s7,8
 89a:	4685                	li	a3,1
 89c:	4629                	li	a2,10
 89e:	000bb583          	ld	a1,0(s7)
 8a2:	855a                	mv	a0,s6
 8a4:	df7ff0ef          	jal	69a <printint>
        i += 2;
 8a8:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 8aa:	8bca                	mv	s7,s2
      state = 0;
 8ac:	4981                	li	s3,0
        i += 2;
 8ae:	bdd1                	j	782 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 10, 0);
 8b0:	008b8913          	add	s2,s7,8
 8b4:	4681                	li	a3,0
 8b6:	4629                	li	a2,10
 8b8:	000be583          	lwu	a1,0(s7)
 8bc:	855a                	mv	a0,s6
 8be:	dddff0ef          	jal	69a <printint>
 8c2:	8bca                	mv	s7,s2
      state = 0;
 8c4:	4981                	li	s3,0
 8c6:	bd75                	j	782 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8c8:	008b8913          	add	s2,s7,8
 8cc:	4681                	li	a3,0
 8ce:	4629                	li	a2,10
 8d0:	000bb583          	ld	a1,0(s7)
 8d4:	855a                	mv	a0,s6
 8d6:	dc5ff0ef          	jal	69a <printint>
        i += 1;
 8da:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 8dc:	8bca                	mv	s7,s2
      state = 0;
 8de:	4981                	li	s3,0
        i += 1;
 8e0:	b54d                	j	782 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8e2:	008b8913          	add	s2,s7,8
 8e6:	4681                	li	a3,0
 8e8:	4629                	li	a2,10
 8ea:	000bb583          	ld	a1,0(s7)
 8ee:	855a                	mv	a0,s6
 8f0:	dabff0ef          	jal	69a <printint>
        i += 2;
 8f4:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 8f6:	8bca                	mv	s7,s2
      state = 0;
 8f8:	4981                	li	s3,0
        i += 2;
 8fa:	b561                	j	782 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 16, 0);
 8fc:	008b8913          	add	s2,s7,8
 900:	4681                	li	a3,0
 902:	4641                	li	a2,16
 904:	000be583          	lwu	a1,0(s7)
 908:	855a                	mv	a0,s6
 90a:	d91ff0ef          	jal	69a <printint>
 90e:	8bca                	mv	s7,s2
      state = 0;
 910:	4981                	li	s3,0
 912:	bd85                	j	782 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 914:	008b8913          	add	s2,s7,8
 918:	4681                	li	a3,0
 91a:	4641                	li	a2,16
 91c:	000bb583          	ld	a1,0(s7)
 920:	855a                	mv	a0,s6
 922:	d79ff0ef          	jal	69a <printint>
        i += 1;
 926:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 928:	8bca                	mv	s7,s2
      state = 0;
 92a:	4981                	li	s3,0
        i += 1;
 92c:	bd99                	j	782 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 92e:	008b8d13          	add	s10,s7,8
 932:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 936:	03000593          	li	a1,48
 93a:	855a                	mv	a0,s6
 93c:	d41ff0ef          	jal	67c <putc>
  putc(fd, 'x');
 940:	07800593          	li	a1,120
 944:	855a                	mv	a0,s6
 946:	d37ff0ef          	jal	67c <putc>
 94a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 94c:	00000b97          	auipc	s7,0x0
 950:	684b8b93          	add	s7,s7,1668 # fd0 <digits>
 954:	03c9d793          	srl	a5,s3,0x3c
 958:	97de                	add	a5,a5,s7
 95a:	0007c583          	lbu	a1,0(a5)
 95e:	855a                	mv	a0,s6
 960:	d1dff0ef          	jal	67c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 964:	0992                	sll	s3,s3,0x4
 966:	397d                	addw	s2,s2,-1
 968:	fe0916e3          	bnez	s2,954 <vprintf+0x21e>
        printptr(fd, va_arg(ap, uint64));
 96c:	8bea                	mv	s7,s10
      state = 0;
 96e:	4981                	li	s3,0
 970:	bd09                	j	782 <vprintf+0x4c>
        putc(fd, va_arg(ap, uint32));
 972:	008b8913          	add	s2,s7,8
 976:	000bc583          	lbu	a1,0(s7)
 97a:	855a                	mv	a0,s6
 97c:	d01ff0ef          	jal	67c <putc>
 980:	8bca                	mv	s7,s2
      state = 0;
 982:	4981                	li	s3,0
 984:	bbfd                	j	782 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 986:	008b8993          	add	s3,s7,8
 98a:	000bb903          	ld	s2,0(s7)
 98e:	00090f63          	beqz	s2,9ac <vprintf+0x276>
        for(; *s; s++)
 992:	00094583          	lbu	a1,0(s2)
 996:	c195                	beqz	a1,9ba <vprintf+0x284>
          putc(fd, *s);
 998:	855a                	mv	a0,s6
 99a:	ce3ff0ef          	jal	67c <putc>
        for(; *s; s++)
 99e:	0905                	add	s2,s2,1
 9a0:	00094583          	lbu	a1,0(s2)
 9a4:	f9f5                	bnez	a1,998 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 9a6:	8bce                	mv	s7,s3
      state = 0;
 9a8:	4981                	li	s3,0
 9aa:	bbe1                	j	782 <vprintf+0x4c>
          s = "(null)";
 9ac:	00000917          	auipc	s2,0x0
 9b0:	61c90913          	add	s2,s2,1564 # fc8 <printf+0x5c2>
        for(; *s; s++)
 9b4:	02800593          	li	a1,40
 9b8:	b7c5                	j	998 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 9ba:	8bce                	mv	s7,s3
      state = 0;
 9bc:	4981                	li	s3,0
 9be:	b3d1                	j	782 <vprintf+0x4c>
    }
  }
}
 9c0:	60e6                	ld	ra,88(sp)
 9c2:	6446                	ld	s0,80(sp)
 9c4:	64a6                	ld	s1,72(sp)
 9c6:	6906                	ld	s2,64(sp)
 9c8:	79e2                	ld	s3,56(sp)
 9ca:	7a42                	ld	s4,48(sp)
 9cc:	7aa2                	ld	s5,40(sp)
 9ce:	7b02                	ld	s6,32(sp)
 9d0:	6be2                	ld	s7,24(sp)
 9d2:	6c42                	ld	s8,16(sp)
 9d4:	6ca2                	ld	s9,8(sp)
 9d6:	6d02                	ld	s10,0(sp)
 9d8:	6125                	add	sp,sp,96
 9da:	8082                	ret

00000000000009dc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9dc:	715d                	add	sp,sp,-80
 9de:	ec06                	sd	ra,24(sp)
 9e0:	e822                	sd	s0,16(sp)
 9e2:	1000                	add	s0,sp,32
 9e4:	e010                	sd	a2,0(s0)
 9e6:	e414                	sd	a3,8(s0)
 9e8:	e818                	sd	a4,16(s0)
 9ea:	ec1c                	sd	a5,24(s0)
 9ec:	03043023          	sd	a6,32(s0)
 9f0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9f4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9f8:	8622                	mv	a2,s0
 9fa:	d3dff0ef          	jal	736 <vprintf>
}
 9fe:	60e2                	ld	ra,24(sp)
 a00:	6442                	ld	s0,16(sp)
 a02:	6161                	add	sp,sp,80
 a04:	8082                	ret

0000000000000a06 <printf>:

void
printf(const char *fmt, ...)
{
 a06:	711d                	add	sp,sp,-96
 a08:	ec06                	sd	ra,24(sp)
 a0a:	e822                	sd	s0,16(sp)
 a0c:	1000                	add	s0,sp,32
 a0e:	e40c                	sd	a1,8(s0)
 a10:	e810                	sd	a2,16(s0)
 a12:	ec14                	sd	a3,24(s0)
 a14:	f018                	sd	a4,32(s0)
 a16:	f41c                	sd	a5,40(s0)
 a18:	03043823          	sd	a6,48(s0)
 a1c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a20:	00840613          	add	a2,s0,8
 a24:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a28:	85aa                	mv	a1,a0
 a2a:	4505                	li	a0,1
 a2c:	d0bff0ef          	jal	736 <vprintf>
 a30:	60e2                	ld	ra,24(sp)
 a32:	6442                	ld	s0,16(sp)
 a34:	6125                	add	sp,sp,96
 a36:	8082                	ret
