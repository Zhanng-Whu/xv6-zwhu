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
            exit(1);
        }
    }
}

void fdinit(){
    
    if(open("console", O_RDWR) < 0){
        // 如果没有console设备 那么创建一个
        mknod("console", CONSOLE, 0);
        open("console", O_RDWR);
    }
    dup(0); // stdout
    dup(0); // stderr
}



int main(){

    fdinit();


    int pid = fork();
    if(pid == 0){
        exec("usertest", (char *[]){"usertest", 0});
        exit(1);
    }

    foreverwait();
    return 0;
}