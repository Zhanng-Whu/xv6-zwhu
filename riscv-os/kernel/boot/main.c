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

    // 输出功能初始化
    consoleinit();
    printfinit();
    printf("\n");
    printf("Hello World\n");

    // 内存初始化
    kinit();
    kVmInit();
    kVmInitHart();

    // 进程初始化
    procinit();

    // 内核中断初始化
    trapInit();
    trapInitHart();
    
    // PLIC注册
    plicInit();
    plicInitHart();

    userInit();
    

    __sync_synchronize();
    started = 1;
  } else {

    while(started == 0)
      ;

    __sync_synchronize();

  }

  scheduler();
}

