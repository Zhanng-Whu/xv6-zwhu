
#ifndef PROC

#define PROC

#include <spinlock.h>
#include <param.h>

struct context {
  uint64 ra;
  uint64 sp;

  // callee-saved
  uint64 s0;
  uint64 s1;
  uint64 s2;
  uint64 s3;
  uint64 s4;
  uint64 s5;
  uint64 s6;
  uint64 s7;
  uint64 s8;
  uint64 s9;
  uint64 s10;
  uint64 s11;
};


enum procstate { UNUSED, USED, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };

// Per-CPU state.
struct cpu {
  struct PCB *proc;          // The process running on this cpu, or null.
  struct context context;     // swtch() here to enter scheduler().
  int noff;                   // Depth of push_off() nesting.
  int intena;                 // Were interrupts enabled before push_off()?
};

struct PCB{
  struct spinlock lock;        // 进程锁
  enum procstate state;        // 进程状态  
  int pid;                     // 进程ID
  pagetable_t pagetable;       // 用户页表
  struct context context;      // 内核的外设中断中保存的上下文
  uint64 kstack;               // 内核栈的虚拟地址

};

extern struct PCB PCBs[NPROC];

#endif