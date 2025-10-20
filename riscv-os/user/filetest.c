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
  printf("Testing concurrent file access (using pre-defined array)...\n");

  int num_procs = 3; // 测试将创建10个子进程
  int i;
  int pid;

  // --- “大数组”在此定义 ---
  // 这是一个字符指针数组，直接存储了所有需要的文件名。
  char *filenames[] = {
    "test_0",
    "test_1",
    "test_2",
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

}
int main(int argc, char const *argv[])
{
    test_read_and_write();
    test_concurrent_access_with_array();
    return 0;
}
