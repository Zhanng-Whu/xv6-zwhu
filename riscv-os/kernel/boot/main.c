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


void testPM(){
  printf("Running testPM...\n");
  void* page1 = kalloc();
  void* page2 = kalloc();

  if (page1 == page2)
    panic("testPM: kalloc returned same page twice");
  
  if (((uint64)page1 & 0xFFF) != 0)
    panic("testPM: page1 not page-aligned");

  *(int*)page1 = 0x12345678;
  if (*(int*)page1 != 0x12345678)
    panic("testPM: page write/read failed");

  kfree(page1);
  void *page3 = kalloc();
  // 在xv6的简单kalloc/kfree实现中, 刚释放的page1很可能就是下一个被分配的page3
  if (page1 != page3)
    printf("Note: kalloc did not immediately reuse the freed page.\n");
  
  kfree(page2);
  kfree(page3);
  printf("testPM finished successfully.\n");
}

// 测试页表基本功能
void
test_pagetable(void) {
  printf("Running test_pagetable...\n");

  // 创建一个空的用户页表
  pagetable_t pt = uVmCreate();
  if(pt == 0)
    panic("test_pagetable: uVmCreate failed");
  
  // 测试基本映射
  uint64 va = 0x1000000; // 选择一个虚拟地址
  uint64 pa = (uint64)kalloc(); // 分配一个物理页面
  if(pa == 0)
    panic("test_pagetable: kalloc failed");

  // 将 va 映射到 pa，权限为可读可写
  if(mapPages(pt, va, PGSIZE, pa, PTE_U | PTE_R | PTE_W) != 0)
    panic("test_pagetable: mapPages failed");

  // 测试地址转换
  // 使用 walk (只读模式) 来查找 va 对应的L0 PTE
  pte_t *pte = walk(pt, va, 0);

  // 断言1：PTE应该存在且有效
  if(pte == 0 || (*pte & PTE_V) == 0)
    panic("test_pagetable: walk failed or PTE not valid");

  // 断言2：PTE中存储的物理地址应该与我们映射的 pa 相同
  if(PTE2PA(*pte) != pa)
    panic("test_pagetable: PTE address mismatch");

  // 测试权限位
  // 断言3：检查权限位是否正确设置
  if((*pte & PTE_R) == 0)
    panic("test_pagetable: PTE_R not set");
  if((*pte & PTE_W) == 0)
    panic("test_pagetable: PTE_W not set");
  if((*pte & PTE_X) != 0) // 我们没有设置可执行权限
    panic("test_pagetable: PTE_X should not be set");

  printf("test_pagetable finished successfully.\n");
  
  // 测试完成后清理资源
  uVmUnmap(pt, va, 1, 1); // 解除映射并释放物理页
  freePgtbl(pt);          // 释放页表本身
}

void
main()
{

  if(cpuid() == 0){
    consoleinit();
    printfinit();

    printf("\n");
    printf("Hello World\n");
    kinit();

    // 测试物理内存的正常使用
    testPM();

    kVmInit();
    kVmInitHart();

    // 测试外设和系统能够正常使用
    printPgtbl(kernel_pagetable, 2, 1);


    


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

