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

void
main()
{

  consoleinit();
  printfinit();

  printf("HelloWorld");
  printf("%d", INT_MIN);

  test_printf_basic();
  test_printf_edge_cases();

  clear_screen();
  goto_xy(10, 5);
  printf_color(32, "Green Text at (10,5)\n");
  printf_color(31, "Red Text\n");
  printf_color(34, "Blue Text\n");
  printf_color(0, "Default Color Text\n");
  // 啥都别干
  for(;;)
  ;
}

