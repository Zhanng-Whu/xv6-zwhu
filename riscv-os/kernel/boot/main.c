#include "include/types.h"
#include "include/param.h"
#include "include/memlayout.h"
#include "include/riscv.h"
#include "include/defs.h"


volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.



extern char end[];
extern pagetable_t kernel_pagetable;


void
main()
{

  if(cpuid() == 0){
    consoleinit();
    printfinit();
    printf("\n");
    printf("Hello World\n");
    
    kinit();
    kVmInit();
    kVmInitHart();

    __sync_synchronize();
    started = 1;
  } else {

    while(started == 0)
      ;

    __sync_synchronize();

  }

    for(;;)
    ;
}

