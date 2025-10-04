#include "include/types.h"
#include "include/riscv.h"
#include "include/proc.h"
#include "include/param.h"
#include "include/memlayout.h"
#include "include/defs.h"

struct cpu cpus[NCPU];

struct PCB PCBs[NPROC];

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
  struct PCB* p;
  for(p = PCBs; p < &PCBs[NPROC]; p++){
    char* pa = kalloc();
    if(pa==0)
      panic("proc_mapstacks: 内核分配进程栈时空间不足分配失败");

    uint64 va = KSTACK((int)(p - PCBs));
    kVmMap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
  }
}


void 
procinit(void){
  struct  PCB* p;

  for(p = PCBs; p < &PCBs[NPROC]; p++){
    initlock(&p->lock, "proc");
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - PCBs));
  }
}

void scheduler(void){
  struct PCB *p;
  struct cpu *c = mycpu();

  c->proc = 0;
  for(;;){
    intr_on();
    intr_off();
  
    int found = 0 ;
    for(p = PCBs; p < &PCBs[NPROC]; p++){
      acquire(&p->lock);
      
      release(&p->lock);
    }
    if(found == 0){
      asm volatile("wfi");
    }
  }
}



void sched(void){
  int intena;
  struct PCB* p = mycpu()->proc;

  if(!holding(&p->lock))
    panic("sched p->lock");
  if(mycpu()->noff != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched RUNNING");
  if(intr_get())
    panic("sched interruptible");

  intena = mycpu()->intena;
  swtch(&p->context, &mycpu()->context);
  mycpu()->intena = intena;
}

void yield(void){
  struct PCB* p = mycpu()->proc;
  acquire(&p->lock);
  p->state = RUNNABLE;
  sched();
  release(&p->lock);
}
