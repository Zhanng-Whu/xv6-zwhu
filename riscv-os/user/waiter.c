#include "include/types.h"
#include "include/param.h"
#include "include/stat.h"
#include "include/memlayout.h"  
#include "include/spinlock.h"
#include "include/user.h"
#include "include/fs.h"
#include "include/file.h"
#include "include/fcntl.h"


// 用于处理孤儿进程
void foreverwait(){
    for(;;){
        int wpid = wait((int *)0);
        if(wpid < 0){
            hello();
            exit(1);
        }
    }
}


char *argv1[] = { "test", "argv1", 0 };
int main(){

    if(open("console", 0) < 0){
        // 如果没有console设备 那么创建一个
        hello();
        mknod("console", CONSOLE, 0);
        open("console", 0);
    }

    int pid = fork();
    if(pid == 0){
        exec("test", argv1);
        exit(1);
    }

    foreverwait();
    return 0;
}