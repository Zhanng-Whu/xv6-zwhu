#include "include/types.h"
#include "include/riscv.h"
#include "include/proc.h"
#include "include/param.h"
#include "include/memlayout.h"
#include "include/defs.h"
#include "include/spinlock.h"

struct cpu cpus[NCPU];

struct PCB PCBs[NPROC];

struct PCB* initproc;


// 用于PID分配的锁
struct spinlock pid_lock;
struct spinlock wait_lock;


extern char trampoline[]; // trampoline.S

static int nextpid = 1;

int cpuid() {
  int id = r_tp();
  return id;
}

struct cpu* 
mycpu(void){
    struct cpu *c = &cpus[cpuid()];
    return c;
}

struct PCB* myproc(void){
  push_off();
  struct cpu *c = mycpu();
  struct PCB *p = c->proc;
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

// 使用一个lock来实现进程的睡眠与唤醒
// 这个锁在进入之前必须被持有
// 一般是这样使用的:
// void f(){
//   acquire(&lk);
//   while(条件不满足)
//     sleep(&chan, &lk);
//   // 条件满足
//   release(&lk);
// }

void sleep(void* chan, struct spinlock* lk){
  struct PCB* p = myproc();

  if(lk == 0)
    panic("sleep");

  acquire(&p->lock);
  release(lk);

  p->chan = chan;
  p->state = SLEEPING;

  sched();

  p->chan = 0;

  release(&p->lock);
  acquire(lk);
}

void wakeup(void* chan){
  struct PCB* p;
  for(p = PCBs; p < &PCBs[NPROC]; p++){
    // 因为当前的进程是唤醒其他进程的进程 所以不应该被检查
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan){
        p->state = RUNNABLE;
      }
      release(&p->lock);
    }
  }
}

void 
procinit(void){
  struct  PCB* p;

  initlock(&pid_lock, "nextpid");
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
      if(p->state == RUNNABLE){
        p->state = RUNNING;
        c->proc = p;
        swtch(&c->context, &p->context);
        c->proc = 0;
        found = 1;
      } 
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

int allocpid(){
  int pid;

  acquire(&pid_lock);
  pid = nextpid++;
  release(&pid_lock);
  return pid;
}


// 根据页表和虚拟内存大小释放进程的页表
void 
uFreeUserVM(pagetable_t pagetable, uint64 sz){

  // 这里 uVmUnmap有一个保护机制 即使没有分配也不会出错
  // 这里的这两个是特殊的映射 不是直接映射到最低位 而是直接映射到最高位
  uVmUnmap(pagetable, TRAMPOLINE, 1, 0);

  uVmUnmap(pagetable, TRAPFRAME, 1, 0);

  // 这个是从0地址开始的
  // 释放sz字节的内存
  // 最后还会释放页表本身
  uVmFree(pagetable, sz);
}

static void
uFreeProc(struct PCB* p){
  if(p->trapframe)
    kfree((void*)p->trapframe);
  p->trapframe = 0;
  if(p->pagetable)
    uFreeUserVM(p->pagetable, p->sz);
  p->pagetable = 0;
  p->sz = 0;
  p->pid = 0;
  p->parent = 0;
  p->name[0] = 0;
  p->killed = 0;
  p->xstate = 0;
  p->chan = 0;
  p->state = UNUSED;
}

pagetable_t procPagetable(struct PCB* p){
  pagetable_t pagetable;

  pagetable = uVmCreate();
  if(pagetable == 0)
    return 0;

  if(mapPages(pagetable, TRAMPOLINE, PGSIZE,
              (uint64)trampoline, PTE_R | PTE_X) < 0){
      uVmFree(pagetable, 0);
      return 0;
  }

  if(mapPages(pagetable, TRAPFRAME, PGSIZE,
              (uint64)(p->trapframe), PTE_R | PTE_W) < 0){
      uVmUnmap(pagetable, TRAMPOLINE, 1, 0);
      uVmFree(pagetable, 0);
      return 0;
  }    
  
  return pagetable;
}

void forkret(void){
  extern char userret[];
  static int first = 1; 
  struct PCB *p = myproc();

  release(&p->lock);

  if(first){

    fsinit(ROOTDEV);

    first = 0;
    __sync_synchronize();
    

    // 最牢的一句
    p->trapframe->a0 = kexec("/test", (char *[]){ "/test", 0 });
    if (p->trapframe->a0 == -1) {
      panic("exec");
    } 


  }

  prepare_return();
  uint64 satp = MAKE_SATP(p->pagetable);
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
  ((void (*)(uint64))trampoline_userret)(satp);
}



// 在进程的所有PCB中找到一个状态为UNUSED的PCB，分配给新进程使用
// 如果找到了 那么进行初始化并且返回这个PCB，并且这个PCB的锁是被持有的
// 如果没有找到或者内存分配失败 返回NULL
static struct PCB*
allocproc(void){
  struct PCB* p;
  for(p = PCBs; p < &PCBs[NPROC]; p++){
    acquire(&p->lock);
    if(p->state == UNUSED){
      goto found;
    } else {
      release(&p->lock);
    }
  }
  return 0;

found:
  p->pid = allocpid();
  p->state = USED;
  // 分配用户的trapframe
  // 用于保存用户态的寄存器

  if((p->trapframe = (struct trapframe*)kalloc()) == 0){
    uFreeProc(p);
    release(&p->lock);
    return 0;
  }

  p->pagetable = procPagetable(p);
  if(p->pagetable == 0){
    uFreeProc(p);
    release(&p->lock);
    return 0;
  }

  memset(&p->context, 0, sizeof(p->context));
  p->context.ra = (uint64)forkret;
  p->context.sp = p->kstack + PGSIZE;

  return p;
}


// 实现从内核地址空间向用户地址空间复制数据
// 需要根据页表来进行逐个的页复制
// 返回0表示成功 -1表示失败
int copyout(pagetable_t pagetable, uint64 va, void* src, uint64 len){
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    va0 = PGROUNDDOWN(va);
    if(va0 >= MAXVA)
      return -1;
    
    // 获取物理地址
    pa0 = uVA2PA(pagetable, va0);
    if(pa0 == 0){
      // 如果对应的物理地址在页表中不存在 通过缺页异常尝试获取
      if((vmfault(pagetable, va0, 0)) == 0)
        return -1;

    }

    pte = walk(pagetable, va0, 0);
    if((*pte & PTE_W) == 0)
      return -1;

    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (va - va0)), src, n);

    len -= n;
    src += n;
    va = va0 + PGSIZE;
  }
  return 0;
}

int 
either_copyout(int user_dst, uint64 dst, void* src, uint64 len){
  struct PCB* p = myproc();
  if(user_dst){
    return copyout(p->pagetable, dst, src, len);
  } else {
    memmove((char*)dst, src, len);
    return 0;
  }
}

void 
userinit(void){
  struct PCB* p;

  p = allocproc();
  initproc = p;

  // 这里的cwd是一个inode 
  // 就是指向当前的工作目录的inode
  // 具体实现很麻烦 但是比较重要
  // 涉及到整个系统读写和字符串算法
  // 是整个文件系统的核心接口之一
  p->cwd = namei("/");

  printf("Test124\n\n\n");
  p->state = RUNNABLE;



  release(&p->lock);

}