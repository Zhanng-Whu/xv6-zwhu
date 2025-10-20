
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


struct trapframe {
  /*   0 */ uint64 kernel_satp;   // kernel page table
  /*   8 */ uint64 kernel_sp;     // top of process's kernel stack
  /*  16 */ uint64 kernel_trap;   // usertrap()
  /*  24 */ uint64 epc;           // saved user program counter
  /*  32 */ uint64 kernel_hartid; // saved kernel tp
  /*  40 */ uint64 ra;
  /*  48 */ uint64 sp;
  /*  56 */ uint64 gp;
  /*  64 */ uint64 tp;
  /*  72 */ uint64 t0;
  /*  80 */ uint64 t1;
  /*  88 */ uint64 t2;
  /*  96 */ uint64 s0;
  /* 104 */ uint64 s1;
  /* 112 */ uint64 a0;
  /* 120 */ uint64 a1;
  /* 128 */ uint64 a2;
  /* 136 */ uint64 a3;
  /* 144 */ uint64 a4;
  /* 152 */ uint64 a5;
  /* 160 */ uint64 a6;
  /* 168 */ uint64 a7;
  /* 176 */ uint64 s2;
  /* 184 */ uint64 s3;
  /* 192 */ uint64 s4;
  /* 200 */ uint64 s5;
  /* 208 */ uint64 s6;
  /* 216 */ uint64 s7;
  /* 224 */ uint64 s8;
  /* 232 */ uint64 s9;
  /* 240 */ uint64 s10;
  /* 248 */ uint64 s11;
  /* 256 */ uint64 t3;
  /* 264 */ uint64 t4;
  /* 272 */ uint64 t5;
  /* 280 */ uint64 t6;
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
  uint64 kstack;               // 用户内核栈 用于保存内核态的寄存器与临时状态
  struct trapframe *trapframe; // 用户态的寄存器


  char name[16];               // 进程名字
  int killed;                  // 进程是否被杀死
  struct PCB *parent;          // 父进程
  void* chan;                  // 进程睡眠的等待chan
  int xstate;                  // 进程退出状态
  uint64 sz;                   // 进程内存大小

  // 调度优先级
  int priority;

  // 文件系统
  struct file *ofile[NOFILE];  // 打开的文件
  struct inode *cwd;           // 当前目录
};

extern struct PCB PCBs[NPROC];

#endif