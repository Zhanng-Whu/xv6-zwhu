#include "include/types.h"
#include "include/param.h"
#include "include/memlayout.h"
#include "include/riscv.h"
#include "include/defs.h"

volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.


#define INT_MIN 0x80000000

void test_printf_basic() {
    printf("Testing integer: %d\n", 42);
    printf("Testing negative: %d\n", -123);
    printf("Testing zero: %d\n", 0);
    printf("Testing hex: 0x%x\n", 0xABC);
    printf("Testing string: %s\n", "Hello");
    printf("Testing char: %c\n", 'X');
    printf("Testing percent: %%\n");
}
void test_printf_edge_cases() {
    printf("INT_MAX: %d\n", 2147483647);
    printf("INT_MIN: %d\n", -2147483648);
    printf("NULL string: %s\n", (char*)0);
    printf("Empty string: %s\n", "");
}

extern char end[];


void
main()
{

  consoleinit();
  printfinit();
  printf("\n");
  printf("Hello World\n");
  kinit();    
  
  void* tmp = kalloc();

  
  printf("kalloc %p\n", tmp);
  printf("kfree %p\n", tmp);
  kfree(tmp);
  printf("double kfree %p\n", tmp);
  kfree(tmp);
  
  for(;;)
  ;
}

