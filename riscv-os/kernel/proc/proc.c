#include "include/types.h"
#include "include/riscv.h"
#include "include/proc.h"
#include "include/param.h"
#include "include/memlayout.h"
#include "include/defs.h"

struct cpu cpus[NCPU];

struct proc proc[NPROC];

int cpuid() {
  int id = r_tp();
  return id;
}

struct cpu* 
mycpu(void){
    struct cpu *c = &cpus[cpuid()];
    return c;
}


void 
proc_mapstacks(pagetable_t kpgtbl){
  struct proc* p;
  for(p = proc; p < &proc[NPROC]; p++){
    char* pa = kalloc();
    if(pa==0)
      panic("proc_mapstacks: 内核分配进程栈时空间不足分配失败");
    
    uint64 va = KSTACK((int)(p - proc));
    kVmMap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
  }
}

