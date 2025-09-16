#include "include/types.h"
#include "include/param.h"
#include "include/memlayout.h"
#include "include/riscv.h"
#include "include/defs.h"

volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.

void test();

void
main()
{
  uartinit();
  uart_puts("Hello World");
    // 啥都别干
  while(1)
  ;
}