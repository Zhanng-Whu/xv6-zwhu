#include "include/types.h"
#include "include/defs.h"
#include "include/riscv.h"
#include "include/spinlock.h"


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

void consoleinit(){
    initlock(&cons.lock, "cons");
    uartinit();
}