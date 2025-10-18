#include "include/types.h"
#include "include/riscv.h"
#include "include/param.h"
#include "include/defs.h"
#include "include/spinlock.h"
#include "include/fs.h"
#include "include/file.h"

#define BACKSPACE 0x100
#define INPUT_BUF_SIZE 128

struct{
    struct spinlock lock;
    char buf[INPUT_BUF_SIZE];
    uint r;  // Read index
    uint w;  // Write index
    uint e;  // Edit index
} cons;


void consputc(int c){
    if(c == BACKSPACE){
        // if the user typed backspace, overwrite with a space.
        uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    } else {
        uartputc_sync(c);        
    }
}

int 
consolewrite(int user_src, uint64 src, int n){
    char buf[32];
    int i = 0;

    while(i < n){
        int nn = sizeof(buf);
        if(nn > n - i)
            nn = n - i;
        
        // 最大的不同还是需要从用户空间复制字符串到内核空间
        if(either_copyin(buf, user_src, src + i, nn) == -1)
            break;

        // 基于阻塞实现
        for(int j = 0; j < nn; j++)
            uartputc_sync(buf[j]);
        i += nn;
    }

    return i;
}


void consoleinit(){
    initlock(&cons.lock, "cons");
    uartinit();

    devsw[CONSOLE].write = consolewrite;
}