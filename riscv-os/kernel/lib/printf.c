#include <stdarg.h> 
#include "include/defs.h"
#include "include/types.h"
#include "include/riscv.h"
#include "include/spinlock.h"




volatile int panicking = 0; // printing a panic message
volatile int panicked = 0; // spinning forever at end of a panic

static char digits[] = "0123456789abcdef";

static struct{
    struct spinlock lock;
} pr;



// base是进制 sign表示是否有符号
static void
printint(long long xx, int base ,int sign){
    char buf[32];
    int i;

    unsigned long long x = 0;

    // 很巧妙的方法
    if(sign && xx < 0){
        x = -xx;
        consputc('-');
    }else x = xx;


    i = 0;
    // 这里用do while 处理 0 这样的数字
    do{
        buf[i++] = digits[x % base];
        x /= base;
    }while(x);

    while(--i >= 0)
        consputc(buf[i]);
}

static void 
printptr(uint64 x){
    int i;
    consputc('0');
    consputc('x');
    for(i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
        consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
}


int
printf(char* fmt, ...){
    va_list ap;
    int i, cx, c0 ,c1, c2;
    char* s;

    if(panicking == 0)
        acquire(&pr.lock);
    
    va_start(ap, fmt);



   for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    if(cx != '%'){
      consputc(cx);
      continue;
    }
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
      printint(va_arg(ap, uint32), 10, 0);
    } else if(c0 == 'l' && c1 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
      printint(va_arg(ap, uint32), 16, 0);
    } else if(c0 == 'l' && c1 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
      printptr(va_arg(ap, uint64));
    } else if(c0 == 'c'){
      consputc(va_arg(ap, uint));
    } else if(c0 == 's'){
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c0);
    }

  }

  va_end(ap);

  if(panicking == 0)
    release(&pr.lock);
  return 0;
}

// 实现清屏
void clear_screen(){
    printf("\033[2J");
    printf("\033[H");
}

// 光标移动
void goto_xy(int x, int y){
    if(x < 0 || x > 79 || y < 0 || y > 24)
        return;
    printf("\033[%d;%dH", y + 1, x + 1);
}


// 颜色输出
int 
printf_color(int color, char *fmt, ...){

printf("\033[%dm", color);

   va_list ap;
    int i, cx, c0 ,c1, c2;
    char* s;

    if(panicking == 0)
        acquire(&pr.lock);
    
    va_start(ap, fmt);



   for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    if(cx != '%'){
      consputc(cx);
      continue;
    }
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
      printint(va_arg(ap, uint32), 10, 0);
    } else if(c0 == 'l' && c1 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
      printint(va_arg(ap, uint32), 16, 0);
    } else if(c0 == 'l' && c1 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
      printptr(va_arg(ap, uint64));
    } else if(c0 == 'c'){
      consputc(va_arg(ap, uint));
    } else if(c0 == 's'){
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c0);
    }

  }

  va_end(ap);

  if(panicking == 0)
    release(&pr.lock);

   printf("\033[%dm",0);

    return 0;
}



void 
panic(char *c){
    panicking = 1;
    consputc(digits[0]);
    panicked = 1;
    for(;;)
    ;
}

void printfinit(void){
    initlock(&pr.lock, "pr");
}
