#include <include/types.h>
#include <include/param.h>
#include <include/memlayout.h>
#include <include/riscv.h>
#include <include/spinlock.h>
#include <include/proc.h>
#include <include/defs.h>


// 中断向量
void kernelVec();

void trapInit(void){
    // do nothing   
}


// set up to take exceptions and traps while in the kernel.
void
trapInitHart(void)
{
  w_stvec((uint64)kernelVec);
}

void 
clockIntr(){

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
      printf("磁盘中断\n"); 
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
  
  printf("Hello");

}