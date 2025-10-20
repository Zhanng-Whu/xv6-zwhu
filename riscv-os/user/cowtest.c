#include "include/types.h"
#include "include/param.h"
#include "include/user.h"

int func(int a, int b){
    int c = a + b;
    return c;
}

void test_cow(){
    for(int i= 0; i < 40 ;i++){
        int pid = fork();
        if(pid < 0){
            printf("Fork失败 at %d\n", i);
            break;
        }else if(pid == 0){
            for(int i = 0; i < 10000; i++){
                func(i, i+1);
            }
            exit(1);
        }
    }

    for(int i = 0; i < 40; i++){
        int wpid = wait(0);
        if(wpid < 0){
            printf("等待子进程失败\n");
            break;
        } else {
            printf("子进程 %d 已退出\n", wpid);
        }
    }

    printf("COW测试成功\n");
}

int 
main(int argc, char const *argv[])
{
    test_cow();
    return 0;
}
