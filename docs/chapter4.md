# 第四讲

完成完整的内核中断处理逻辑和时钟中断逻辑.

这里,这里特意强调是内核的中断,含义为从内核态到内核态的中断,不包括来自用户态的中断(系统调用`ecall`),主要是外设中断(timer也是一种外设,但是计时器中断在riscv的`sie`<也就是Supervisitor interrupt Exception>寄存器中专门设置了一位用来表示开启计时器中断,而其他的外设共同设置为一位表示开启外设中断)

## 逻辑梳理

先来看到初始化的步骤:

```C
kinit();         // physical page allocator
kvminit();       // create kernel page table
kvminithart();   // turn on paging

procinit();      // process table

trapinit();      // trap vectors
trapinithart();  // install kernel trap vector
plicinit();      // set up interrupt controller
plicinithart();  // ask PLIC for device interrupts

binit();         // buffer cache
iinit();         // inode table
```



注意这里是先初始化进程表,后初始化中断相关的操作.但是进程管理是第五讲的内容,所以这里先跳过这个部分.

关键看到接下来的四个函数的初始化函数:

```c

trapinit();      // trap vectors
trapinithart();  // install kernel trap vector
plicinit();      // set up interrupt controller
plicinithart();  // ask PLIC for device interrupts

```

这里,先简单讲述一下他们四个的逻辑:

### 内核中断设置与处理

- `trapinit()`,按照xv6的逻辑,这种总的初始化一般是软件设置,所以这个函数的唯一功能就是初始化一个自旋锁,用处不大.

- `trapinithart()`,也很简单,就是将stvec(Supervisior Trap Vector)的数值设定为`kernevlvec.S`中的`kernelvec`的地址,而这个文件的内容也很简单,如下:

  ```asm
  .globl kerneltrap
  .globl kernelvec
  .align 4
  kernelvec:
          # make room to save registers.
          addi sp, sp, -256
  
          # save caller-saved registers.
          sd ra, 0(sp)
          # sd sp, 8(sp)
          sd gp, 16(sp)
          sd tp, 24(sp)
          sd t0, 32(sp)
          sd t1, 40(sp)
          sd t2, 48(sp)
          sd a0, 72(sp)
          sd a1, 80(sp)
          sd a2, 88(sp)
          sd a3, 96(sp)
          sd a4, 104(sp)
          sd a5, 112(sp)
          sd a6, 120(sp)
          sd a7, 128(sp)
          sd t3, 216(sp)
          sd t4, 224(sp)
          sd t5, 232(sp)
          sd t6, 240(sp)
  
          # call the C trap handler in trap.c
          call kerneltrap
  
          # restore registers.
          ld ra, 0(sp)
          # ld sp, 8(sp)
          ld gp, 16(sp)
          # not tp (contains hartid), in case we moved CPUs
          ld t0, 32(sp)
          ld t1, 40(sp)
          ld t2, 48(sp)
          ld a0, 72(sp)
          ld a1, 80(sp)
          ld a2, 88(sp)
          ld a3, 96(sp)
          ld a4, 104(sp)
          ld a5, 112(sp)
          ld a6, 120(sp)
          ld a7, 128(sp)
          ld t3, 216(sp)
          ld t4, 224(sp)
          ld t5, 232(sp)
          ld t6, 240(sp)
  
          addi sp, sp, 256
  
          # return to whatever we were doing in the kernel.
          sret
  ```

  其他的很简单,各种乱七八糟的是上下文保存,最后的`sret`和前面见过的`mret`内容很类似.

  这里的`kerneltrap`就是一个处理各种类型的中断的函数,由于在我们中断的时候,特定的寄存器会设置中断的位置,原因等等信息,这个函数就会直接从这些寄存器中读出数值来判断中断的原因,从而使用不同的方式处理,函数的内容如下:

  ```c
  
  // interrupts and exceptions from kernel code go here via kernelvec,
  // on whatever the current kernel stack is.
  void 
  kerneltrap()
  {
    int which_dev = 0;
    uint64 sepc = r_sepc();
    uint64 sstatus = r_sstatus();
    uint64 scause = r_scause();
    
    if((sstatus & SSTATUS_SPP) == 0)
      panic("kerneltrap: not from supervisor mode");
    if(intr_get() != 0)
      panic("kerneltrap: interrupts enabled");
  
    if((which_dev = devintr()) == 0){
      // interrupt or trap from an unknown source
      printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
      panic("kerneltrap");
    }
  
    // give up the CPU if this is a timer interrupt.
    if(which_dev == 2 && myproc() != 0)
      yield();
  
    // the yield() may have caused some traps to occur,
    // so restore trap registers for use by kernelvec.S's sepc instruction.
    w_sepc(sepc);
    w_sstatus(sstatus);
  }
  
  ```

  看到这里的三个寄存器,分别是`sepc`(Exception Programmer Counter),`sstuatus`和`scause`的关键寄存器的数值.

  然后是两段安全检查:

  ```c
    if((sstatus & SSTATUS_SPP) == 0)
      panic("kerneltrap: not from supervisor mode");
    if(intr_get() != 0)
      panic("kerneltrap: interrupts enabled");
  
  ```

  这里是三个断言,第一个的SPP代表Supervisor Previous Privilege,表示在发生中断前的系统状态是不是内核模式,如果这个是0,说明中断违反了设计的初衷,所以会中断.

  第二个是判断当前的程序是关闭了中断,如果程序关闭中断了还跳到了这个函数,代表有严重的逻辑错误.

  ```c
  
    if((which_dev = devintr()) == 0){
      // interrupt or trap from an unknown source
      printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
      panic("kerneltrap");
    }
  ```

  接下来,是判断中断的来源,这里是通过devintr()函数来实施的,他会读取`scause`的内容来判断中断来自哪一个外设,内容如下:

  ```c
  int
  devintr()
  {
    uint64 scause = r_scause();
  
    if(scause == 0x8000000000000009L){
      // this is a supervisor external interrupt, via PLIC.
  
      // irq indicates which device interrupted.
      int irq = plic_claim();
  
      if(irq == UART0_IRQ){
        uartintr();
      } else if(irq == VIRTIO0_IRQ){
        virtio_disk_intr();
      } else if(irq){
        printf("unexpected interrupt irq=%d\n", irq);
      }
  
      // the PLIC allows each device to raise at most one
      // interrupt at a time; tell the PLIC the device is
      // now allowed to interrupt again.
      if(irq)
        plic_complete(irq);
  
      return 1;
    } else if(scause == 0x8000000000000005L){
      // timer interrupt.
      clockintr();
      return 2;
    } else {
      return 0;
    }
  }
  ```

  首先,开始的判断是一个riscv的规范:

  > **`0x8...`**: 最高位为1，表示这是一个中断。
  >
  > **`...9`**: 末尾的9是RISC-V规范中为**“监督者外部中断 (Supervisor External Interrupt)”**定义的编码。
  >
  > **含义**: 这种中断来自于CPU核心**外部**的设备，并且是通过 **PLIC** (平台级中断控制器) 路由过来的。常见的如串口、磁盘、网卡中断都属于这一类。
  >
  > **`...5`**: 末尾的5是RISC-V规范中为**“监督者时钟中断 (Supervisor Timer Interrupt)”**定义的编码。
  >
  > **含义**: 这种中断来自于CPU核心旁边的CLINT（核心本地中断器），是周期性发生的，用于驱动操作系统进行进程调度。

  

  这里的PLIC是 **Platform-Level Interrupt Controller**, 平台级中断控制器,是现代OS中管理所有外部硬件中断的管理器.

  在确认了是监督者外部中断后,需要向PLIC确定中断的类型.

  ```c
  
  // ask the PLIC what interrupt we should serve.
  int
  plic_claim(void)
  {
    int hart = cpuid();
    int irq = *(uint32*)PLIC_SCLAIM(hart);
    return irq;
  }
  ```

  这里先看一下设备中断,这里需要根据当前的CPU核型来判断中断的类型,因为每一个CPU在PLIC上都有独有的寄存器表示中断的外设,同时注意,这里的寄存器由于不是CPU的寄存器,所以依然是通过内存映射访问的.

  然后根据不同的设备号来处理不同的设备中断,

  处理完成后,如果中断的类型存在,那么需要告诉PLIC我们已经处理了中断,PLIC收到了这个完成的信号后,就会清除这个中断的"正在处理中"的状态.

  > 引自Gemini
  >
  > ### 为什么必须调用 `plic_complete`？
  >
  > 如果您忘记调用 `plic_complete`，将会发生一个致命的后果：**该设备将永远无法再次产生中断**。
  >
  > - **比喻**: 想象一个只有一个呼叫队列的紧急调度中心（PLIC）。
  >   1. UART设备（求助者）打来电话，`plic_claim()`（接线员）接听了电话，队列中的这个呼叫被标记为“通话中”。
  >   2. 内核处理了这个呼叫（执行了 `uartintr()`）。
  >   3. 如果内核**忘记**了调用 `plic_complete()`（接线员忘记挂断电话），那么在PLIC看来，这个呼叫**永远处于“通话中”状态**。
  >   4. 之后，即使UART设备又遇到了新的紧急情况想再次呼叫，PLIC会发现它的线路一直被占用，因此**永远不会再把UART的呼叫接进来**。
  >
  > **最终结果**：您的系统将对那个设备后续的所有中断都“失聪”。例如，如果忘记对UART中断进行`complete`，您的控制台将只能再接收一次键盘输入，之后就再也无法响应了。

  接下来再看时钟中断:

  ```c
  
  void
  clockintr()
  {
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
  ```

  xv6约定,只有0号CPU才能管理全体的时间管理,这里的wakeup是用来处理`sleep`之类的函数的管理.

  然后,会设置下一次中断的时间,这个就和STM32的中断后需要再次开启中断是一样的.

  接着,返回处理函数中.

  ```c
    
  
    if((which_dev = devintr()) == 0){
      // interrupt or trap from an unknown source
      printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
      panic("kerneltrap");
    }
  
    // give up the CPU if this is a timer interrupt.
    if(which_dev == 2 && myproc() != 0)
      yield();
  
    // the yield() may have caused some traps to occur,
    // so restore trap registers for use by kernelvec.S's sepc instruction.
    w_sepc(sepc);
    w_sstatus(sstatus);
  ```

  这里的`yield()`是用来处理进程调度的,表示CPU放弃当前的进程,切换到下一个进程来运行.

  最后,由于在执行切换的过程中,寄存器的状态肯定发生变化,所以这里通过在开头存储寄存器的原始数据实现恢复返回地址和系统状态的功能.

### PLIC设置

```c
plicinit();      // set up interrupt controller
plicinithart();  // ask PLIC for device interrupts
```

接着,是两个PLIC的初始化,在前面的过程中,肯定会有一些疑问,比如,PLIC如何管理设备的优先级别等等.在这里就是为了解决这个设置问题.

```c
void
plicinit(void)
{
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
}
```

PLIC 内部有一组连续的32位（4字节）寄存器，每个寄存器都用来存放一个中断源的优先级。比如第十号寄存器就是用来管理uart0中断的优先级的,我们这里选择1写入这个寄存器,代表把uart0的中断优先级别设置成1.

接着,是PLIC在CPU中的设置.

```c
void
plicinithart(void)
{
  int hart = cpuid();
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
}
```

这个函数你会发现不只有CPU0进行了调用,而是所有的CPU都需要处理(在main.c中),因为PLIC需要给所有的CPU发送中断信号,所以必然会在寄存器上做出一些些设置.

```c
*(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
```

> **`PLIC_SENABLE(hart)`**: 这个宏会计算出PLIC硬件中，专门用于**当前核心**的**“S模式中断使能（Supervisor Enable）”寄存器**的地址。每个核心都有一个自己独立的使能寄存器。

接着是设置中断屏蔽的寄存器,这里把中断屏蔽寄存器设置成0,代表着所有的大于0 的中断都可以打断内核.

```c
  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
```

