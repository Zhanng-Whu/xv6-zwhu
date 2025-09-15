
# 第一章 RISC-V引导与裸机启动

Docker启动流程

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

**1. 核心状态与信息 (Core Status & Information)**

这些是描述CPU自身状态和身份的寄存器。

- **`mstatus`**: **机器状态寄存器**。这是最重要的一个，是M-mode下的“总控制台”，控制着全局中断使能（MIE）、前一个权限模式（MPP）等。
- **`misa`**: **机器ISA寄存器**。记录了该CPU核心支持哪些指令集扩展（比如`I`, `M`, `A`, `F`, `D`, `C`等）。
- **`mvendorid`, `marchid`, `mimpid`**: CPU的“身份证”，分别记录了供应商ID、架构ID和实现ID。
- **`mhartid`**: **硬件线程ID**。每个CPU核心的唯一编号，我们在 `start.c` 中看到的代码就是读取它来区分不同核心。

**2. 异常与中断处理 (Trap Handling)**

当发生中断或异常时，M-mode使用这些寄存器来处理。

- **`mtvec`**: **机器陷阱向量基地址寄存器**。存放M-mode下中断处理程序的入口地址。当发生M-mode需要处理的异常时，CPU会跳转到这里。
- **`mepc`**: **机器异常程序计数器**。保存发生异常的那条指令的地址。`mret` 指令会用它来返回到被中断的程序。
- **`mcause`**: **机器原因寄存器**。记录了发生异常或中断的**原因**（是一个数字代码，比如“非法指令”或“时钟中断”）。
- **`mtval`**: **机器陷阱值寄存器**。记录与异常相关的额外信息，比如发生缺页异常时的目标地址。
- **`mscratch`**: **机器临时寄存器**。专门给M-mode中断处理程序使用的一个“草稿本”寄存器。

**3. 中断委托与管理 (Interrupt Delegation & Management)**

- **`mideleg`** 和 **`medeleg`**: **机器中断/异常委托寄存器**。这是M-mode下放权力的关键。`start.c` 通过设置这两个寄存器，将大部分中断和异常的处理权委托给了S-mode。
- **`mie`**: **机器中断使能寄存器**。控制哪些中断源在M-mode下是开启的。
- **`mip`**: **机器中断挂起寄存器**。显示当前有哪些中断正在等待处理。

**4. 物理内存保护 (PMP)**

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

这里是riscv程序的两种模型，分别是medlow(Medium Low Model)和medany(Medium Any Model)分别对应比较小的程序和大的程序。

```c
 // disable paging for now.
  w_satp(0);

  // delegate all interrupts and exceptions to supervisor mode.
  w_medeleg(0xffff);
  w_mideleg(0xffff);
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
```

satp是Address Translation and Protection寄存器，是控制虚拟内存的开关，这里关闭了分页的功能，确保接下来进入Smode的main函数直接使用了物理地址。

在RISC-V的默认设计中，所有的trap无论发生在哪一个权限级，都需要由M-mode来处理，这里通过medeleg Machine Exception Delegation寄存器，将异常委托出去。这个寄存器的每一位都是一种类型的异常，比如第8位对应“来自U-mode的系统调用”，第12位对应“取指缺页异常”，第15位对应“存储缺页异常”等。这里的0xffff意味着将常见的16种异常全部委托出去。

而mideleg也差不多，是Machine Interrupt delegation,代表着负责外部中断的处理。

然后是sie寄存器，是Interrupt Enable,监督者终端使能寄存器，只有打开这个寄存器，Smode才能真正接收到中断。后面的两个标志位是SIE_SEIE(**S**upervisor **E**xternal **I**nterrupt **E**nable)和`SIE_STIE`(**S**upervisor **T**imer **I**nterrupt **E**nable) (虽然我记得时钟中断也是一种外部中断)，这里代表着在原来的基础上开启这两种中断。

```c
// configure Physical Memory Protection to give supervisor mode
// access to all of physical memory.
w_pmpaddr0(0x3fffffffffffffull);
w_pmpcfg0(0xf);
```

PMP,physical Memory Protection,硬件级内存防火墙，目的是设置S模式的对物理内存的访问限制，在这里为了便于我们的实验，所以这里开放了全部的内存地址。而pmpcfg0是pmp规则的配置寄存器，每个字节都负责配置一个规则，这里是第零号规则，0xf就是对应的RWXA,设定了0号规则可读可写可执行，并且可以运行在TOR规则中。

```c
{
// .....
  // ask for clock interrupts.
  timerinit();

// ...
}


// ask each hart to generate timer interrupts.
void
timerinit()
{
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
}
```

hart,hard-thread,硬件多线程，比如我们常说的，某某CPU16核32线程，这就是硬件多线程，对于xv6,是一个核心对应一个线程，所以hart的数量就是核心的数量。同时还有软件线程，比如使用pthread创建的线程，则是由操作系统管理的。两者是不同的概念。

`mie`和前面的sie概念相同，是mechine Interrupt enable, 这里的 STIE是Super Timer Interrupt Enable，这样来开启中断使能。但是这里有一个疑问，就是前面不是已经开启了sie的中断使能吗，为什么这里还需要设置mie？这里相当于是两个配置，sie的STIE设置是开启发送的权限，而mie的STIE的相当于是接收的权限。

**`w_menvcfg(...)`**: 开启 `sstc` (Supervisor-level timer control) 扩展功能，允许 S-mode 写入 `stimecmp` 寄存器来设置下一次中断时间。

**`w_mcounteren(...)`**: 允许 S-mode 直接读取 `time`（时间计数器）和 `stimecmp`  (**S**upervisor **time** **c**o**mp**are)寄存器。

**`r_time()`**: 读取一个名为 `time` 的特殊寄存器，这个寄存器从CPU加电开始就一直在以一个固定的频率（比如每秒一千万次）递增，像一个永不停歇的秒表。

**`w_stimecmp(...)`**: 写入 `stimecmp` 寄存器。

stimecmp的机制就是，不断将time的时间和这个寄存器的时间比较，当time>=stimecmp寄存器的时候，就会发生一次时钟中断。

为什么这里需要配置一次时钟中断？目的是为了启动调度，调度器本质是一个死循环，其是中断驱动的，但是我们需要第一个中断来启动他，这里为了实现这个功能，我们需要在初始化之前设置一个中断来手动启动他。

但是这里还有一个问题，如果初始化完成之前就发生中断了会怎么办？解决方法在main函数里面的scheduler里面，在这个函数里面有控制中断开关的函数如下：

```c
void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();

  c->proc = 0;
  for(;;){
    // The most recent process to run may have had interrupts
    // turned off; enable them to avoid a deadlock if all
    // processes are waiting. Then turn them back off
    // to avoid a possible race between an interrupt
    // and wfi.
    intr_on();
    intr_off();
```

在初始的时候，其实中断就是关闭的，需要初始化完成后才会打开中断，接着就会发生中断了。

```c
  // keep each CPU's hartid in its tp register, for cpuid().
  int id = r_mhartid();
  w_tp(id);
```

mhartid是Machine Hart ID ,是当前CPU的唯一编号，这句话就是读取当前CPU的唯一编号。

tp，就是通用寄存器中的x4(好小众的寄存器)，tp就是Thread Pointer，这里涉及到每一个基本概念，就是每一个CPU都是有他的寄存器组的，这里保存每一个CPU的hartid到他的tp寄存器中，为了后面调用cpuid()准备。

还有一个问题，这里说的是 each CPU, 这就引出另一个问题，为什么这里是每一个CPU都会设置？说明每一个CPU都执行了这一段代码。但是这个是谁规定的呢？

实际上qemu在模拟的时候，启动完硬件后就是一次把所有的CPU的PC指向0x80000000的位置。让他们同时开始执行，这里看一下Makefile。

```makefile
ifndef CPUS
CPUS := 3
endif

QEMUOPTS = -machine virt -bios none -kernel $K/kernel -m 128M -smp $(CPUS) -nographic
QEMUOPTS += -global virtio-mmio.force-legacy=false
QEMUOPTS += -drive file=fs.img,if=none,format=raw,id=x0
QEMUOPTS += -device virtio-blk-device,drive=x0,bus=virtio-mmio-bus.0

qemu: check-qemu-version $K/kernel fs.img
	$(QEMU) $(QEMUOPTS)

```

**`-machine virt`**

- **解读**：“机器类型为 `virt`”。
- **作用**：告诉 QEMU 模拟我们在之前讨论过的那个**标准的、通用的虚拟机器平台**。这是 xv6 运行的硬件基础。

**`-bios none`**

- **解读**：“不使用 BIOS”。
- **作用**：指示 QEMU **不要加载任何默认的BIOS或UEFI固件**。这个选项通常与 `-kernel` 配合使用，意味着我们将绕过传统的启动流程，直接由 QEMU 加载操作系统内核。

**`-kernel $K/kernel`**

- **解读**：“内核文件为 `kernel/kernel`”。
- **作用**：这正是我们反复提到的“快捷方式”规则。它告诉 QEMU 将编译好的 xv6 内核文件（`kernel/kernel`）直接加载到虚拟机的内存中（`0x80000000` 地址）。

**`-m 128M`**

- **解读**：“内存大小为 128 MB”。
- **作用**：为虚拟机分配 128MB 的物理内存（RAM）。

**`-smp $(CPUS)`**

- **解读**：“对称多处理，核心数为 `$(CPUS)`”。
- **作用**：告诉 QEMU 启用多核模拟，核心（harts）的数量由 `CPUS` 变量的值决定（默认为3）。

**`-nographic`**

- **解读**：“无图形界面”。
- **作用**：不模拟显卡和图形化窗口。相反，它会将虚拟机的**串行端口（UART）重定向到我们当前正在使用的宿主机终端**上。这就是为什么你可以在运行 `make qemu` 的同一个终端窗口里输入命令并看到 xv6 输出的原因。

**`-global virtio-mmio.force-legacy=false`**

- **解读**：“全局参数：强制 virtio-mmio 不使用旧版接口”。
- **作用**：这是一个比较技术性的细节。VIRTIO 是一套 I/O 虚拟化标准，它有新旧两个版本。较新版本的 xv6 使用的是现代的 VIRTIO 规范，所以需要用这个参数告诉 QEMU **不要**提供旧版的（legacy）接口，以确保 xv6 的 virtio 驱动能和 QEMU 模拟的设备正确匹配。

**`-drive file=fs.img,if=none,format=raw,id=x0`**

- **解读**：“定义一个驱动器后端”。
- **作用**：这行命令本身**只定义**了一个存储介质，但还没有把它连接到虚拟机上。
  - `file=fs.img`: 存储介质的数据来源是宿主机上的 `fs.img` 文件。
  - `if=none`: `if` 指 `interface`（接口）。`none` 表示先不要为它附加任何标准的控制器接口（如IDE, SCSI等）。
  - `format=raw`: 声明 `fs.img` 是一个原始的二进制镜像文件。
  - `id=x0`: 为这个驱动器分配一个唯一的ID，名为 `x0`，以便下一条命令可以引用它。

**`-device virtio-blk-device,drive=x0,bus=virtio-mmio-bus.0`**

- **解读**：“创建一个设备，并连接上一步的驱动器”。
- **作用**：这条命令才真正地在虚拟机里**创建**了一个硬件设备，并将 `fs.img` 连接上去。
  - `-device virtio-blk-device`: 创建一个 **VIRTIO 块设备**，也就是一个虚拟硬盘。
  - `drive=x0`: 将 ID 为 `x0` 的驱动器（即 `fs.img`）连接到这个虚拟硬盘上。
  - `bus=virtio-mmio-bus.0`: 将这个新创建的虚拟硬盘设备，挂载到 `virt` 机器的主 I/O 总线上。

最后，使用`asm volatitle("mret")`, 正式进入main.c中。




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

- etext 、 edata 、 end 符号有什么用途？

按照实验的设计，内存的布局如下

```txt
低地址
  ^
  |   +------------------+
  |   | .text (代码段)    |
  |   +------------------+ <--- etext (代码段的末尾)
  |   | .rodata (只读数据)|
  |   +------------------+
  |   | .data (已初始化数据)|
  |   +------------------+ <--- edata (数据段的末尾, 也是BSS段的开始)
  |   | .bss (未初始化数据)|
  |   +------------------+ <--- end (整个内核静态映像的末尾)
  |   |                  |
  |   | 内核堆 (Heap)      |
  |   | (由 kalloc 管理)   |
  |   |      ...         |
  v
高地址
```

他们用来区分各个地址的开头和结束。

### 任务2。

我们回到本章的任务：确定最小启动流程，并且输出Hello OS。

为了只实现这个任务，我们可以大幅度简化启动流程，可以去掉很多main.c里面关于抢占多线程和轮转调度的配置，只保留基本的特权级设置。

- 启动流程规划

  1. 上电，qemu模拟，将程序入口放在0x80000000,同时在qemu运行之前，就已经将入口设置为_entry,并且放在这个位置了。
  2. entry.S设置sp指针的位置,并且跳转到start.c中开始退出特权级
  3. start.c中完成特权级的转换，同时设置内存防火墙和和完成CPU的id配置，接着跳转到main函数中，值得注意的是，我们目前不需要抢占式调度，所以我们可以先不配置时钟(也就是timerinit()),但是可以稍微配置一下外部终端，因为我们可以不实现抢占，但是一定要实现外部输入，所以需要配置medeleg和SEIE的配置。
  4. main函数中，完成UART的配置，由此实现printf的配置
  5. 打印Hello OS
  6. 退出程序

  - 内存布局

  这里有一个问题，低内存布局都是什么东西？

  对于这个，可以在memlayout.h里看到，内容如下：

  ```c
  // Physical memory layout
  
  // qemu -machine virt is set up like this,
  // based on qemu's hw/riscv/virt.c:
  //
  // 00001000 -- boot ROM, provided by qemu
  // 02000000 -- CLINT
  // 0C000000 -- PLIC
  // 10000000 -- uart0 
  // 10001000 -- virtio disk 
  // 80000000 -- qemu's boot ROM loads the kernel here,
  //             then jumps here.
  // unused RAM after 80000000.
  
  // the kernel uses physical memory thus:
  // 80000000 -- entry.S, then kernel text and data
  // end -- start of kernel page allocation area
  // PHYSTOP -- end RAM used by the kernel
  
  // qemu puts UART registers here in physical memory.
  #define UART0 0x10000000L
  #define UART0_IRQ 10
  
  // virtio mmio interface
  #define VIRTIO0 0x10001000
  #define VIRTIO0_IRQ 1
  
  // qemu puts platform-level interrupt controller (PLIC) here.
  #define PLIC 0x0c000000L
  #define PLIC_PRIORITY (PLIC + 0x0)
  #define PLIC_PENDING (PLIC + 0x1000)
  #define PLIC_SENABLE(hart) (PLIC + 0x2080 + (hart)*0x100)
  #define PLIC_SPRIORITY(hart) (PLIC + 0x201000 + (hart)*0x2000)
  #define PLIC_SCLAIM(hart) (PLIC + 0x201004 + (hart)*0x2000)
  
  // the kernel expects there to be RAM
  // for use by the kernel and user pages
  // from physical address 0x80000000 to PHYSTOP.
  #define KERNBASE 0x80000000L
  #define PHYSTOP (KERNBASE + 128*1024*1024)
  
  // map the trampoline page to the highest address,
  // in both user and kernel space.
  #define TRAMPOLINE (MAXVA - PGSIZE)
  
  // map kernel stacks beneath the trampoline,
  // each surrounded by invalid guard pages.
  #define KSTACK(p) (TRAMPOLINE - ((p)+1)* 2*PGSIZE)
  
  // User memory layout.
  // Address zero first:
  //   text
  //   original data and bss
  //   fixed-size stackQ
  //   expandable heap
  //   ...
  //   TRAPFRAME (p->trapframe, used by the trampoline)
  //   TRAMPOLINE (the same page as in the kernel)
  #define TRAPFRAME (TRAMPOLINE - PGSIZE)
  ```

  这里就是内存映射IO,将外设中的寄存器映射到了一块内存地址上，说白了，这一段“内存”实际上是外设的SRAM,而不是内存的DRAM。我们后面的uart的使用实际上就是向这个内存地址里面发送一个字节，然后就会发送到对应的外设的寄存器中，然后就会将其打印到终端上（这个串口实际上被qemu选择映射到终端上了）

  一个很简单的例子是这样的:

  ```c
          # qemu -kernel loads the kernel at 0x80000000
          # and causes each hart (i.e. CPU) to jump there.
          # kernel.ld causes the following code to
          # be placed at 0x80000000.
  .section .text
  .global _entry, _test
  _entry:
      # set up a stack for C.
      # stack0 is declared in start.c,
      # with a 4096-byte stack per CPU.
      # sp = stack0 + ((hartid + 1) * 4096)
  
  	call _test
      la sp, stack1
      li a0, 1024*4
      csrr a1, mhartid
      addi a1, a1, 1
      mul a0, a0, a1
      add sp, sp, a0
      # jump to start() in start.c
      call start
  
  _test:
  	li t0, 0x10000000 
  	li t1, 'S' 
  	sb t1, 0(t0)
  	ret
  
  spin:
          j spin
  
  ```

  对于剩下的内存布局，则在链接器件中设置了OS的低地址（也就是0x80000000）开始的内存，包括启动的boot(entry.S),.data .rodata .text 等等内容 而更高的地址中则是完全是空白的，这些内存必须要等OS初始化完成后由内存调度来管理。

  - 列出必需的硬件初始化步骤

  有什么步骤？

  - 设置sp寄存器
  - 配置特权级
  - 配置tp
  - 设置起始地址
  - 配置中断
  - 配置uart

  没了，对于我们需要输出一个内容，只需要这么多。

### 任务3

直接暴改一下entry.S 和 start.c

```assembly
.section .text
.global _entry
_entry:
        la sp, stack0
        li a0, 1024*8
        # 对于一个单核系统 这里不需要考虑hartid的数量
        add sp, sp, a0
        call start

spin:
        j spin
```

```c
#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "defs.h"

void main();

// 分配3 * 4096字节的栈空间
__attribute__ ((aligned (16))) char stack0[4096 * 3];

// entry.S jumps here in machine mode on stack0.
void
start()
{
  // set M Previous Privilege mode to Supervisor, for mret.
  unsigned long x = r_mstatus();
  x &= ~MSTATUS_MPP_MASK;
  x |= MSTATUS_MPP_S;
  w_mstatus(x);

  // set M Exception Program Counter to main, for mret.
  // requires gcc -mcmodel=medany
  w_mepc((uint64)main);

  // disable paging for now.
  w_satp(0);

  // delegate all interrupts and exceptions to supervisor mode.

  w_medeleg(0xffff);
  w_mideleg(0xffff);
  w_sie(r_sie() | SIE_SEIE);

  // configure Physical Memory Protection to give supervisor mode
  // access to all of physical memory.
  w_pmpaddr0(0x3fffffffffffffull);
  w_pmpcfg0(0xf);

  // ask for clock interrupts.
  // timerinit();

  // keep each CPU's hartid in its tp register, for cpuid().
  int id = r_mhartid();
  w_tp(id);

  // switch to supervisor mode and jump to main().
  asm volatile("mret");
}
```

