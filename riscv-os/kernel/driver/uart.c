#include "include/types.h"
#include "include/param.h"
#include "include/memlayout.h"
#include "include/riscv.h"
#include "include/defs.h"


// 先来定义几个工具宏

// UART 的IO基本地址

#define Reg(reg) ((volatile unsigned char *)(UART0 + (reg)))

#define ReadReg(reg) (*(Reg(reg)))
#define WriteReg(reg, v) ((*(Reg(reg)) = (v)))

// 接着一堆的宏定义
#define RHR 0                 
#define THR 0                 
#define IER 1                 
#define FCR 2                 
#define ISR 2                 
#define LCR 3                 
#define LSR 5                 
#define IER_RX_ENABLE (1<<0)
#define IER_TX_ENABLE (1<<1)
#define FCR_FIFO_ENABLE (1<<0)
#define FCR_FIFO_CLEAR (3<<1) 
#define LCR_EIGHT_BITS (3<<0)
#define LCR_BAUD_LATCH (1<<7) 
#define LSR_RX_READY (1<<0)   
#define LSR_TX_IDLE (1<<5)    


extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void uartinit(void){
    // 关闭读取中断
    WriteReg(IER, 0x00);

    // 设置波特率和信息位
    // 这里是一个常用波特率 38400
    // 计算方法是 115200 / 3 = 38400
    // 按照习惯 一次传递一个字节
    WriteReg(LCR, LCR_BAUD_LATCH);
    WriteReg(0, 0x03); // LSB
    WriteReg(1, 0x00); // MSB
    WriteReg(LCR, LCR_EIGHT_BITS);

    // 启动缓冲区
    WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);

    // 开启读写中断 这里先注释掉 需要等后面配置完中断再开启
    // WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);

}


void uart_putc(char c){
    // 等待串口发送完成
    while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    ;
    WriteReg(THR, c);
}


void uart_puts(char *s){
    char* tmp = s;
    while(*s){
        if(*s == '\n')
            uart_putc('\r');
        uart_putc(*s++);
    }
    s = tmp;
}


void uartputc_sync(int c)
{
  if(panicking == 0)
    push_off();

  if(panicked){
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    ;
  WriteReg(THR, c);

  if(panicking == 0)
    pop_off();
}




