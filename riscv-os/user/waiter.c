#include "include/types.h"
#include "include/user.h"


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

    int pid = fork();
    if(pid == 0){
        exec("test", argv1);
        exit(1);
    }

    foreverwait();
    return 0;
}