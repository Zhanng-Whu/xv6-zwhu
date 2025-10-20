#include "include/types.h"
#include "include/param.h"
#include "include/fcntl.h"
#include "include/user.h"

void test_read_and_write(void){
    printf("创建测试文件\n");
    int fd = open("testfile", O_CREATE | O_RDWR);
    if(fd < 0){
        printf("创建文件失败\n");
        return;
    }else{
        printf("创建文件成功，文件描述符： %d\n", fd);
    }


    printf("写入测试数据到文件\n");
    char data[] = "Hello, RISC-V File System!";
    int write_bytes = write(fd, data, sizeof(data));
    if(write_bytes != sizeof(data)){
        printf("写入文件失败\n");
        close(fd);
        return;
    } else {
        printf("写入文件成功，写入字节数： %d\n", write_bytes);
    }

    printf("重新打开文件测试\n");
    fd = open("testfile", O_RDWR);
    if(fd < 0){
        printf("重新打开文件失败\n");
        return;
    } else {
        printf("重新打开文件成功，文件描述符： %d\n", fd);
    }
    printf("读取文件内容进行验证\n");
    char buffer[100];
    int read_bytes = read(fd, buffer, sizeof(data));
    printf("读取到的数据: %s\n", buffer);
    if(read_bytes != sizeof(data)){
        printf("读取文件失败\n");
        close(fd);
        return;
    } else {
        printf("读取文件成功，读取字节数： %d\n", read_bytes);
    }

    printf("测试删除文件\n");
    if(unlink("testfile") < 0){
        printf("删除文件失败\n");
    } else {
        printf("删除文件成功\n");
    }   
}
void
test_concurrent_access_with_array(void)
{
  printf("开始filesystem并发访问测试\n");

  int num_procs = 10; // 测试将创建10个子进程
  int i;
  int pid;

  // --- “大数组”在此定义 ---
  // 这是一个字符指针数组，直接存储了所有需要的文件名。
  char *filenames[] = {
    "test_0",
    "test_1",
    "test_2",
    "test_3",
    "test_4",
    "test_5",
    "test_6",
    "test_7",
    "test_8",
    "test_9",
  };

  // 创建多个进程同时访问文件系统
  for (i = 0; i < num_procs; i++) {
    pid = fork();
    if (pid < 0) {
      printf("fork failed\n");
      exit(1);
    }
    
    if (pid == 0) {
      char *filename = filenames[i];
      int j;

      // 循环100次，高强度地创建、写入、关闭、删除文件
      for (j = 0; j < 100; j++) {
        int fd = open(filename, O_CREATE | O_RDWR);
        if (fd >= 0) {
          // 写入一些数据（这里写入整数j的4个字节）
          if(write(fd, &j, sizeof(j)) != sizeof(j)){
            printf("write to %s failed\n", filename);
            exit(1);
          }
          close(fd);
          unlink(filename);
        } else {
            printf("open %s failed\n", filename);
            exit(1);
        }
      }
      
      // 子进程完成任务后退出
      printf("Child process for file %s finished.\n", filename);
      exit(0);
    }
  }

  for(i = 0; i < num_procs; i++) {
    int wpid = wait(0);
    if (wpid < 0) {
      printf("wait failed\n");
      exit(1);
    }
  }
  printf("并发测试结束，所有子进程已完成。\n");

}

void
test_filesystem_performance(void)
{
  printf("文件IO性能测试\n");
  
  uint start_time;
  int fd, i;
  
  // --- 大量小文件测试 ---
  printf("开始小文件测试 (1000 个文件)...\n");
  start_time = uptime();

  for (i = 0; i < 1000; i++) {
    char filename[32];
    strcpy(filename, "small_");
    itoa(i, filename + strlen(filename));
    
    fd = open(filename, O_CREATE | O_WRONLY);
    if (fd < 0) {
      printf("performance test: open small file failed\n");
      exit(1);
    }
    if (write(fd, "test", 4) != 4) {
      printf("performance test: write small file failed\n");
      exit(1);
    }
    close(fd);
  }

  uint small_files_time = uptime() - start_time;

  // --- 大文件测试 ---
  printf("开始大文件测试 (1 个 4MB 文件)...\n");
  char large_buffer[4096]; // 4KB buffer
  start_time = uptime();

  fd = open("large_file", O_CREATE | O_WRONLY);
  if (fd < 0) {
    printf("performance test: open large file failed\n");
    exit(1);
  }
  for (i = 0; i < 1024; i++) { // 1024 * 4KB = 4MB
    if (write(fd, large_buffer, sizeof(large_buffer)) != sizeof(large_buffer)) {
      printf("performance test: write large file failed\n");
      exit(1);
    }
  }
  close(fd);

  uint large_file_time = uptime() - start_time;

  // --- 打印结果 ---
  printf("\n 性能测试结果 \n");
  // 中文输出
  printf("小文件 (1000x4B) 耗时: %d ticks\n", small_files_time);
  printf("大文件 (1x4MB) 耗时:    %d ticks\n", large_file_time);

  unlink("large_file");

  printf("测试 3 成功完成。\n");
}


int main(int argc, char const *argv[])
{

    test_filesystem_performance();
    return 0;
}
