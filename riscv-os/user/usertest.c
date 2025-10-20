#include "include/types.h"
#include "include/param.h"
#include "include/user.h"

#define NPROCS 60

void test_processing(){
    printf("Fork测试");

    int count = 0;
    for(int i = 0; i < NPROCS; i++){
        int pid = fork();
        if(pid < 0){
            printf("Fork失败 at %d\n", i);
            break;
        }
        if(pid == 0){
            exec("test", (char *[]){"test", "arg1", "arg2", 0});
            exit(0);
        
        }
        count++;
    }

    printf("创建了 %d 个子进程\n", count);

    printf("清理测试\n");

    int i;
    for( i = 0; i < count; i++){
        int tmppid = 0 ;
        int wpid = wait(&tmppid);
        if(wpid < 0){
            printf("等待子进程失败\n");
            break;
        } else {
            printf("子进程 %d 已退出，状态 %d\n", wpid, tmppid);
        }
    }

    if(count == i){
        printf("所有的子进程全部退出\n");
    } else {
        printf("所有子进程已清理完毕\n");
    }

}

void test_write_and_ptr(){
    char* invalid_ptr = (char*)0x1000000000;
    int res = write(1, invalid_ptr, 10);
    if(res == 0){
        printf("写入无效指针测试通过\n");
    } else {
        printf("写入无效指针测试失败\n");
        printf("错误码: %d\n", res);
    }

    char buffer[20] = "Hello, RISC-V!";
    // 测试无效文件描述符
    res = write(-1, buffer, 20);
    if(res == -1){
        printf("写入无效文件描述符测试通过\n");
    } else {
        printf("写入无效文件描述符测试失败\n");
        printf("错误码: %d\n", res);
    }

    // 控指针
    res = write(1, 0, 10);

    if(res == -1){
        printf("写入空指针测试通过\n");
    } else {
        printf("写入空指针测试失败\n");
        printf("错误码: %d\n", res);
    }

    res = write(1, buffer, -5);
    if(res <= 0){
        printf("写入负长度测试通过\n");
    } else {
        printf("写入负长度测试失败\n");
        printf("错误码: %d\n", res);
    }

}

int main(int argc, char const *argv[])
{
    test_processing();
    test_write_and_ptr();
    return 0;
}
