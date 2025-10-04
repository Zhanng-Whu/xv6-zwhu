#include<include/types.h>
#include<include/param.h>
#include<include/memlayout.h>
#include<include/riscv.h>
#include<include/defs.h>    


void plicInit(void){
    // do nothing
}

// 根据设备和优先读进行注册
void registerDev(int irq, int priority){
    *(uint32*)(PLIC + irq*4) = priority;
}

void unregisterDev(int irq){
    *(uint32*)(PLIC + irq*4) = 0;
}

void plicInitHart(void){
    int hart = cpuid();

    enableDev(UART0_IRQ);
    
    // 设置这个hart的S模式下的优先级阈值为0
    *(uint32*)PLIC_SPRIORITY(hart) = 0;
}

void enableDev(int irq){
    int hart = cpuid();
    *(uint32*)PLIC_SENABLE(hart) |= (1 << irq);
}   

void disableDev(int irq){
    int hart = cpuid();
    *(uint32*)PLIC_SENABLE(hart) &= ~(1 << irq);
}

// 每个hart的PLIC初始化
int plicClaim(void){
    int hart = cpuid();
    int irq = *(uint32*)PLIC_SCLAIM(hart);
    return irq;
}

// 告诉PLIC我们已经处理完这个中断了
void plicComplete(int irq){
    int hart = cpuid();
    *(uint32*)PLIC_SCLAIM(hart) = irq;
}
