#include "include/types.h"
#include "include/riscv.h"
#include "include/proc.h"
#include "include/param.h"
#include "include/memlayout.h"
#include "include/defs.h"

struct cpu cpus[NCPU];

struct PCB PCBs[NPROC];

struct spinlock wait_lock;
struct spinlock next_pid;
struct PCB* initProc;
void forkRet(void);

// 定义在 trampoline.S中的一段代码段
extern char userret[];
extern char trampoline[];
extern char kernelVec[];

// 创建一个用户页表, 他没有用户内存空间, 但是包含中断向量和中断帧
pagetable_t 
procPagetable(struct PCB* p){
  pagetable_t pagetable;

  // 申请一个页表
  pagetable = uVmCreate();

  if(pagetable == 0)
    return 0;

  if(mapPages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline, PTE_R | PTE_X) < 0){
    uVmFree(pagetable, 0);
    return 0;
  }

  if(mapPages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe), PTE_R | PTE_W) < 0){
    uVmUnmap(pagetable, TRAMPOLINE, 1, 0);
    uVmFree(pagetable, 0);
    return 0;
  }

  return pagetable;
}

void 
procFreepagetable(pagetable_t pagetable, uint64 sz){
  uVmUnmap(pagetable, TRAMPOLINE, 1, 0);
  uVmUnmap(pagetable, TRAPFRAME, 1, 0);
  uVmFree(pagetable, sz);
}

// 彻底释放一个进程
// 处理其页表,内核栈,陷阱帧等
static void
freeProc(struct PCB* p){
  if(p->trapframe)
    kfree((void*)p->trapframe);
  p->trapframe = 0;
  if(p->pagetable)
    procFreepagetable(p->pagetable, p->sz);
  p->pagetable = 0;
  p->sz = 0;
  p->pid = 0;
  p->parent = 0;
  p->name[0] = 0;
  p->killed = 0;
  p->xstate = 0;
  p->state = UNUSED;
}
int cpuid() {
  int id = r_tp();
  return id;
}

struct cpu* 
mycpu(void){
    struct cpu *c = &cpus[cpuid()];
    return c;
}

struct PCB*
myproc(void){
  push_off();
  struct cpu* c = mycpu();
  struct PCB* p = c->proc;
  pop_off();
  return p;
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

  initlock(&next_pid, "next_pid");
  initlock(&wait_lock, "wait_lock");

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

int nextPID = 1;
int allocPID(){
  int pid;

  acquire(&next_pid);
  pid = nextPID;
  nextPID = nextPID + 1;
  release(&next_pid);

  return pid;
}

static struct PCB* 
allocProc(){
  struct PCB* p;

  for(p = PCBs; p < &PCBs[NPROC]; p++){
    acquire(&p->lock);
    if(p->state == UNUSED){
      goto found;
    } else {
      release(&p->lock);
    }
  }

found:
  p->pid = allocPID();

  // 标志进入初始化状态
  p->state = USED;

  // 分配陷阱帧
  if((p->trapframe = (struct trapframe*)kalloc()) == 0){
    freeProc(p);
    release(&p->lock);
    return 0;
  }

  // 分配用户页表
  p->pagetable = procPagetable(p);
  if(p->pagetable == 0){
    freeProc(p);
    release(&p->lock);
    return 0;
  }

  // 初始化上下文
  memset(&p->context, 0, sizeof(p->context));
  p->context.ra = (uint64)forkRet;
  p->context.sp = p->kstack + PGSIZE;
  return p;
}


void setKilled(struct PCB* p){
  acquire(&p->lock);  
  p->killed = 1;
  release(&p->lock);
}




void prepareReturn(){
  struct PCB* p = mycpu()->proc;

  intr_off();

  // 设置陷阱入口
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
  w_stvec(trampoline_userret);

  // 设置陷阱帧
  p->trapframe->kernel_satp = r_satp();
  p->trapframe->kernel_sp = p->kstack + PGSIZE;
  p->trapframe->kernel_trap = (uint64)userTrap;
  p->trapframe->kernel_hartid = r_tp();

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
  x |= SSTATUS_SPIE; // enable interrupts in user mode
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
}



void
forkRet() {
  static int first = 1;
  struct PCB* p = myproc();

  release(&p->lock); 

  if(first) {
    first = 0;
    __sync_synchronize();


  }

  // return to user space, mimicing usertrap()'s return.
  prepareReturn();
  uint64 satp = MAKE_SATP(p->pagetable);
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
  ((void (*)(uint64))trampoline_userret)(satp);

}


void 
userInit(){
  struct PCB* p;

  p = allocProc();

  initProc = p;
  p->state = RUNNABLE;
  release(&p->lock);

}