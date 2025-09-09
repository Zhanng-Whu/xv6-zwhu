防止环境混乱，这里使用Docker帮助构建环境，镜像基于ubuntu:22.04构建。
```shell
docker pull zwhu/riscv:base
```

使用下面的指令启动
```bash
#! /bin/bash

IMAGE_NAME=zwhu/riscv:base

docker run -it --rm \
--net=host \
--ipc=host \
--pid=host \
--privileged \
--dns=8.8.8.8 \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-e DISPLAY=$DISPLAY \
-v $HOME/.Xauthority:/root/.Xauthority:ro \
-v ~/docker/workspace:/workspace \
$IMAGE_NAME /bin/bash
```


qemu : 7.2.0

镜像OS : ubuntu22.04

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


```

- 进入start.c，从机器模式转换到监督者模式


## 任务解答

### 任务1
1. 
- 为什么第一条指令是设置栈指针？

个人理解，编译器优化出来的指令，很多操作指令都与sp有关，程序需要一个合法的栈。

-  `la sp, stack0` 中的stack0在哪里定义？

注释里面说了，在start.c里面定义的。存放在了注册表中。

- 为什么要清零BSS段？

回忆一下CSAPP,.bss是未初始化的全局变量和静态变量，按照C语言标准，需要初始化为0

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