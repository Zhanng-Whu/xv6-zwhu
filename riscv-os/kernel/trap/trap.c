#include <include/types.h>
#include <include/param.h>
#include <include/memlayout.h>
#include <include/riscv.h>
#include <include/spinlock.h>
#include <include/proc.h>
#include <include/defs.h>

struct spinlock tickslock;

// 中断向量
void kernelVec();

void trapInit(void){
  initlock(&tickslock, "time");
}


// set up to take exceptions and traps while in the kernel.
void
trapInitHart(void)
{
  w_stvec((uint64)kernelVec);
}

uint64 usertrap();


//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
  extern char uservec[];
  extern char trampoline[];
  
  struct PCB *p = myproc();

  // we're about to switch the destination of traps from
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
  p->trapframe->kernel_trap = (uint64)usertrap;
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()

  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
  x |= SSTATUS_SPIE; // enable interrupts in user mode
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
}

int ticks = 0;

void 
clockIntr(){

  if(cpuid() == 0){
    acquire(&tickslock);
    ticks++;
    wakeup(&ticks);
    release(&tickslock);
  }


  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
}

int devIntr(){
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){

    // 从PLIC那里获取中断号
    int irq = plicClaim();

    if(irq == UART0_IRQ){
      printf("串口中断\n");
    } else if(irq == VIRTIO0_IRQ){
      virtio_disk_intr();
    } else if(irq){
      printf("未知中断号 irq=%d\n", irq);
    }

    // the PLIC allows each device to raise at most one
    // interrupt at a time; tell the PLIC the device is
    // now allowed to interrupt again.
    if(irq)
      plicComplete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    
    // 进入时钟中断
    // 这里重新启用一下次时钟中断

    clockIntr();
    return 2;
  } else {
    return 0;
  }
}

void kernelTrap(void){
  int which_dev = 0;
  uint64 sepc = r_sepc();
  uint64 sstatus = r_sstatus();
  uint64 scause = r_scause();

  if((sstatus & SSTATUS_SPP) == 0)
    panic("kerneltrap: not from supervisor mode");
  if(intr_get() != 0)
    panic("kerneltrap: interrupts enabled");

  if((which_dev = devIntr()) == 0){
    printf("scause %p\n", scause);
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    panic("PLIC传递未知中断号引起错误");
  }

  if(which_dev == 2 && mycpu()->proc != 0)
    yield();
    
  w_sepc(sepc);
  w_sstatus(sstatus);
}


uint64
usertrap(void){


  int which_dev = 0;

  if((r_sstatus() & SSTATUS_SPP) != 0)
    panic("usertrap: not from user mode");  

  w_stvec((uint64)kernelVec);  //DOC: kernelvec

  struct PCB *p = myproc();
  
  p->trapframe->epc = r_sepc();
 if(r_scause() == 8){
    p->trapframe->epc += 4;
    intr_on();
    syscall(); 
  } else if((which_dev = devIntr()) != 0){
    // ok
  } else if((r_scause() == 15 || r_scause() == 13) &&
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
              printf("处理缺页异常成功\n");
    // page fault on lazily-allocated page
  } else {
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());

    setkilled(p); 
  }

  if(killed(p))
    kexit(-1);

  // give up the CPU if this is a timer interrupt.
  if(which_dev == 2)
    yield();

  prepare_return();

  // the user page table to switch to, for trampoline.S
  uint64 satp = MAKE_SATP(p->pagetable);

  // return to trampoline.S; satp value in a0.
  return satp;   
}