#include "include/types.h"
#include "include/param.h"
#include "include/memlayout.h"
#include "include/riscv.h"
#include "include/defs.h"

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

char hex_digits[] = "0123456789ABCDEF";

void uart_putc_c(char c){
    // 等待串口发送完成
    while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    ;
    WriteReg(THR, c);
}

void uart_putc_number(uint64 num){
    // 将数字转换为字符串
    // 打印 "0x" 前缀，这是一种好的编程习惯
    uart_putc_c('0');
    uart_putc_c('x');

    // 一个64位的数字由16个十六进制位组成 (16 * 4 bits = 64 bits)
    // 我们从最高位开始，逐个处理这16个十六进制位
    for (int i = 15; i >= 0; i--) {
        // 1. 计算当前十六进制位需要右移多少位才能到达最低位
        int shift = i * 4;
        
        // 2. 将数字右移，然后通过与 0xF (二进制 1111) 进行“与”运算，
        //    来分离出当前这4个比特位的值（一个0到15之间的数字）
        int digit_value = (num >> shift) & 0xF;
        
        // 3. 以这个值为索引，从“字典”中查出对应的字符并打印
        uart_putc_c(hex_digits[digit_value]);
    }
    uart_putc_c('\n');
}

extern char stack0[];
extern char sbss[];
extern char ebss[];


void test_BSS(){
    
    uart_putc_c('B');
    uart_putc_c('e');

    uart_putc_c('g');
    uart_putc_c('i');
    uart_putc_c('n');

    uart_putc_c('\n');

    
    uart_putc_number((uint64)sbss);
    uart_putc_number((uint64)ebss);
    uart_putc_number((uint64)stack0);

    for(char *p = sbss; p < ebss; p++) {
        if(*p != 0) {
            uart_putc_c('W');
            uart_putc_c(':');

            uart_putc_number((uint64)p);
        }
    }
}