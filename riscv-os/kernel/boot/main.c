#include "include/types.h"
#include "include/param.h"
#include "include/memlayout.h"
#include "include/riscv.h"
#include "include/defs.h"

volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.


#define INT_MIN 0x80000000

extern char end[];

extern pagetable_t kernel_pagetable;

void
main()
{
  consoleinit();
  printfinit();
  printf("\n");
  printf("Hello World\n");

  kinit();
  kvminit();
  kvminithart();
  print_pgtbl(kernel_pagetable, 2, -1);
  for(;;)
  ;
}

