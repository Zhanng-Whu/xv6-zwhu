
# 第一章 RISC-V引导与裸机启动

## Docker启动流程

- Qemu初始化，载入xv6核心

在这个过程中，qemu会负责模拟硬件，在载入完成后，机器会执行第一个跳转指令，将PC指向0x80000000的位置，然后就会开始执行xv6自己的程序。

```riscv

# 这里是entry.S的内容

        # qemu -kernel loads the kernel at 0x80000000
        # and causes each hart (i.e. CPU) to jump there.
        # kernel.ld causes the following code to
        # be placed at 0x80000000.
```

这里他说，kernel.ld(Linker Script 链接器脚本)会把所有的.o文件全部组合成一个最终的可执行文件，并且把entry.S放在文件最前面。

- kernel/kernel.ld 中执行连接过程

```ld
OUTPUT_ARCH( "riscv" )
ENTRY( _entry )

SECTIONS
{
  /*
   * ensure that entry.S / _entry is at 0x80000000,
   * where qemu's -kernel jumps.
   */
  . = 0x80000000;

  .text : {
    kernel/entry.o(_entry)
    *(.text .text.*)
    . = ALIGN(0x1000);
    _trampoline = .;
    *(trampsec)
    . = ALIGN(0x1000);
    ASSERT(. - _trampoline == 0x1000, "error: trampoline larger than one page");
    PROVIDE(etext = .);
  }

  .rodata : {
    . = ALIGN(16);
    *(.srodata .srodata.*) /* do not need to distinguish this from .rodata */
    . = ALIGN(16);
    *(.rodata .rodata.*)
  }

  .data : {
    . = ALIGN(16);
    *(.sdata .sdata.*) /* do not need to distinguish this from .data */
    . = ALIGN(16);
    *(.data .data.*)
  }

  .bss : {
    . = ALIGN(16);
    *(.sbss .sbss.*) /* do not need to distinguish this from .bss */
    . = ALIGN(16);
    *(.bss .bss.*)
  }

  PROVIDE(end = .);
}
```
来看看这一段做了什么

```
OUTPUT_ARCH( "riscv" )
ENTRY( _entry )
// 明确告诉链接器，最终要生成的目标文件是 RISC-V 架构的。
// 指定程序的入口点。当内核被加载执行时，CPU将从 _entry 这个标签所标记的指令开始运行。

SECTIONS{ 
  // SECTIONS 块是整个脚本的核心
  // 它定义了最终可执行文件内部各个“段”（Section）的布局和内存地址。
  . = 0x80000000;
  . 就是代表的PC当前所在的内存地址

//这里规定文本块，的内容
// 首先强制将内核的入口点 _entry 放在最前面（0x80000000），
// 然后将所有其他编译好的内核函数代码（.text 段）紧随其后
.text : {
    kernel/entry.o(_entry)
    *(.text .text.*)




// 前面就安排了全部的代码段
// 现在 让.实现一页对齐 (page size = 0x1000 bytes)
// 并且让`_trampoline`变量等于当前的PC
    . = ALIGN(0x1000);
    _trampoline = .;


// 这条指令告诉链接器，去所有输入文件（.o 文件）中寻找名为 trampsec 的段
// 并把它们的内容放在这里
    *(trampsec)


// 再次对齐
    . = ALIGN(0x1000);

// 我也看不太懂 先跳过 
    ASSERT(. - _trampoline == 0x1000, "error: trampoline larger than one page");
    
// 这里是定义最后一个extext的符号
    PROVIDE(etext = .);
  }

  .rodata : {
// 接下来 开始定义read only数据段
// 16字节对其
    . = ALIGN(16);
    *(.srodata .srodata.*) /* do not need to distinguish this from .rodata */
    . = ALIGN(16);
// 获取所有的只读字段
    *(.rodata .rodata.*)
  }

  .data : {
    . = ALIGN(16);
    *(.sdata .sdata.*) /* do not need to distinguish this from .data */
    . = ALIGN(16);
    *(.data .data.*)
  }

  .bss : {
    . = ALIGN(16);
    *(.sbss .sbss.*) /* do not need to distinguish this from .bss */
    . = ALIGN(16);
    *(.bss .bss.*)
  }

  PROVIDE(end = .);
}


```



- 执行 kernel/entry.S，通过call start进入c语言代码。

```riscv
.section .text
.global _entry
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
        li a0, 1024*4
        csrr a1, mhartid
        addi a1, a1, 1
        mul a0, a0, a1
        add sp, sp, a0
        # jump to start() in start.c
        call start
spin:
        j spin
```

```riscv
.section .text # 告诉汇编器，接下来的代码属于代码段

.global _entry # 将_entry声明为全局符号，便于连接器识别

_entry:
# stack0来自于start.c中的
# __attribute__ ((aligned (16))) char stack0[4096 * NCPU];
# 至于为什么会这样，是编译的时候就处理好了，在start.o中留存了一个全局符号。

la sp, stack0
li a0, 1024*4

# 这一句没有见过，csrr的功能是读取控制状态寄存器（CSAPP）
# mhartid是一个特殊的状态寄存器，存储的是核心数量，可以看一下在param.h中有：
# #define NCPU          8  // maximum number of CPUs
# 规定了最大的核数量
csrr a1, mhartid

# 这里为什么加1？
# 上面说了
# sp = stack0 + ((hartid + 1) * 4096)
addi a1, a1, 1
mul a0, a0, a1

# 到了栈顶
add sp, sp, a0
call start

```

- 进入start.c，从机器模式转换到监督者模式 这里可以看一下是怎么改变机器状态的？

先来了解一下 M S U分别是什么作用？以及 mret, sret 和 uret

三者最大的区别是CSR(Control Status Register)读取状态的差别

- Mechine  可以读写一切状态寄存器， 包括m开头的核心的寄存器，包括但是不限于:

#### **1. 核心状态与信息 (Core Status & Information)**

这些是描述CPU自身状态和身份的寄存器。

- **`mstatus`**: **机器状态寄存器**。这是最重要的一个，是M-mode下的“总控制台”，控制着全局中断使能（MIE）、前一个权限模式（MPP）等。
- **`misa`**: **机器ISA寄存器**。记录了该CPU核心支持哪些指令集扩展（比如`I`, `M`, `A`, `F`, `D`, `C`等）。
- **`mvendorid`, `marchid`, `mimpid`**: CPU的“身份证”，分别记录了供应商ID、架构ID和实现ID。
- **`mhartid`**: **硬件线程ID**。每个CPU核心的唯一编号，我们在 `start.c` 中看到的代码就是读取它来区分不同核心。

#### **2. 异常与中断处理 (Trap Handling)**

当发生中断或异常时，M-mode使用这些寄存器来处理。

- **`mtvec`**: **机器陷阱向量基地址寄存器**。存放M-mode下中断处理程序的入口地址。当发生M-mode需要处理的异常时，CPU会跳转到这里。
- **`mepc`**: **机器异常程序计数器**。保存发生异常的那条指令的地址。`mret` 指令会用它来返回到被中断的程序。
- **`mcause`**: **机器原因寄存器**。记录了发生异常或中断的**原因**（是一个数字代码，比如“非法指令”或“时钟中断”）。
- **`mtval`**: **机器陷阱值寄存器**。记录与异常相关的额外信息，比如发生缺页异常时的目标地址。
- **`mscratch`**: **机器临时寄存器**。专门给M-mode中断处理程序使用的一个“草稿本”寄存器。

#### **3. 中断委托与管理 (Interrupt Delegation & Management)**

- **`mideleg`** 和 **`medeleg`**: **机器中断/异常委托寄存器**。这是M-mode下放权力的关键。`start.c` 通过设置这两个寄存器，将大部分中断和异常的处理权委托给了S-mode。
- **`mie`**: **机器中断使能寄存器**。控制哪些中断源在M-mode下是开启的。
- **`mip`**: **机器中断挂起寄存器**。显示当前有哪些中断正在等待处理。

#### **4. 物理内存保护 (PMP)**

- **`pmpcfg0` - `pmpcfg15`**: PMP配置寄存器。
- **`pmpaddr0` - `pmpaddr63`**: PMP地址寄存器。
- 这一组寄存器共同构成了硬件防火墙，由M-mode设置，用来限制S-mode和U-mode可以访问的物理内存区域。

- Super **操作系统内核**的特权级。xv6中绝大部分代码（`main.c`, `kalloc.c`, `vm.c`, `proc.c`等）都运行在S-mode。
- User  用户模式的特权级

接着 再来看一下mret,sret和uret

什么是mret?他几乎只有一个作用，就是在start.c里面实现跳转到main.c，同时实现从机器模式到内核态的降级。

什么是sret? 这是使用频率最高的ret指令，用户态通过ecall请求系统调用的时候，都是通过这个指令返回

什么是uret? 我也不知道 用的不多 先跳过。

那么，接下来就来看start.c . start.c只做了一个事情，就是把CPU控制权从 M-mode 移交给权限较低的监督者模式（S-mode），并开始执行内核主函数 `main()`。

```c
unsigned long x = r_mstatus();
x &= ~MSTATUS_MPP_MASK;
x |= MSTATUS_MPP_S;
w_mstatus(x);
```

先看看这里的 `r_mstatus()`是什么

```c
static inline uint64
r_mstatus()
{
  uint64 x;
  // csrr 就是 Control and Status Register Read 指令
  // 就是读取mstatus中的寄存器 然后将其数值复制到%0的这个寄存器的位置
  // 那么，mstatus是什么？
  // 全称是 Machine Status Register (机器状态寄存器)
  // 寄存器内部由许多不同的位字段（bit-fields）组成，每个字段都有特定的功能。具体的内容后面遇到了再分析
  // 那么 后面的 :"=r" (x) 是什么？
  // 这是操作数约束部分，是内联汇编最复杂也最关键的部分
  // 第一个冒号 : 用来分隔汇编模板和输出操作数。
  // (x): 表示这个汇编操作数与C语言中的变量 x 相关联。
  // "=r": 是对这个操作数的约束字符串。
  // "...": 字符串定界符。
  // 表示这是一个输出操作数（write-only）。也就是说，汇编指令会写入这个操作数。
  // 表示约束类型为“任意通用寄存器”。它告诉编译器：“你可以随便选择一个通用的寄存器（比如t0, a1等）来完成这个任务。”


  asm volatile("csrr %0, mstatus" : "=r" (x) );
  return x;
}
```

那这句话就很好理解了，实际上就是把mstatus寄存器的内容读取出来并且塞到x里面去。然后在start里面 对M模式做一个掩码，对S模式或一下 然后写入到mstatus中。

但是这里还是有一个问题，明明在这里就更改了寄存器，为什么还是可以使用mret?

其实，直到mret前，一直处在M模式，为什么？

举个类似的例子;

```
user 调用 ecall -> 切换为S膜质 -> 执行系统调用 -> sret -> 切换为用户模式
```

模式的切换实际上只在返回的时候发生，只有在mret的时候，才会开始读取mstatus寄存器，这个知识点可以查阅一下RISC-V的指令集得知。

https://blog.csdn.net/weixin_42031299/article/details/136844715

因为这种ret是发生在陷入的时候的，mstatus中会记录陷入之前的模式，称之为MPP( **Machine Previous Privilege**),在发生陷入的时候，会先记录当前的模式，保存在mstatus的MPP字段，然后将mepc的字段+4移动到下一个指令，然后等待陷入后，读取MPP字段恢复模式，并且跳转到mepc的位置(话说这个命名太抽象了 M mode Exception programmer counter).现在知道了那个MPP是啥了吧（

还有一个细节，在xv6里面只有M模式下才能直接改mepc,所以他可以直接改正返回的位置实现任意的跳转（耍赖嘛 谁不会）

然后是下一句

```c

  // set M Exception Program Counter to main, for mret.
  // requires gcc -mcmodel=medany
  w_mepc((uint64)main);

```

这里值得注意的就是 `gcc -mcmodel=medany`是个啥东西

这里是riscv程序的两种模型，分别是medlow(Medium Low Model)和medany(Medium Any Model)分别对应比较小的程序和大的程序


## 任务解答

### 任务1
1. entry.S相关
- 为什么第一条指令是设置栈指针？

个人理解，编译器优化出来的指令，很多操作指令都与sp有关，程序需要一个合法的栈。

-  `la sp, stack0` 中的stack0在哪里定义？

注释里面说了，在start.c里面定义的。存放在了注册表中。

- 为什么要清零BSS段？

回忆一下CSAPP,.bss是未初始化的全局变量和静态变量，按照C语言标准，需要初始化为0
虽然一个版本我找不到清空.bss区的地方（

- 如何从汇编跳转到C函数

`call start`调用start函数，在start.c中定义好了。

```c

// entry.S jumps here in machine mode on stack0.
void
start()
{
    ...
}
```

2. kernal.ld相关
- ENTRY(_entry) 的作用是什么？
设置入口函数

- 为什么代码段要放在0x80000000？

这里是qemu的一个约定的位置，具体的代码在Makefile中。
