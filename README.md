## 启动
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
--dns=8.8.8.8 
-v /tmp/.X11-unix:/tmp/.X11-unix \
-e DISPLAY=$DISPLAY \
-v $HOME/.Xauthority:/root/.Xauthority:ro \
-v ~/docker/workspace:/workspace \
$IMAGE_NAME /bin/bash
```


qemu : 7.2.0

ps:qemu的版本问题可能与国内源有关，可以选择使用源码编译 具体步骤查看这里:https://blog.csdn.net/weixin_43793731/article/details/128909831

镜像OS : ubuntu22.04

同时这里对xv6的文件目录进行了一些更改，最终结果如下:

| 文件夹名称    | 文件内容介绍       |
| ------------- | ------------------ |
| kernel        | 内核相关的文件     |
| kernel/boot   | 内核启动相关的文件 |
| kernel/driver | 驱动文件           |
| kernel/lib    | 内核标准库         |
| kernel/trap   | 内核中中断相关文件 |
| kernel/mm     | 内存管理文件       |
| kernel/proc   | 进程管理文件       |
| include       | 各种头文件         |
| scripts       | 脚本文件           |

为此，需要更改一些Makefile的内容，根据AI暴改，不保证后续测试稳定性。



## 阅读笔记 
[阅读第一讲](docs/chapter1.md), 其完整代码储存在fork,boot中。

[阅读第二讲](docs/chapter2.md), 代码在printf分支中。

[阅读第三讲](docs/chapter3.md), 实现了基于bitmap的简单链表的内存管理以及实现了伙伴系统的功能，但是没有接入，在kalloc分支中。 在vm分支中进一步优化物理内存分配和虚拟地址分配。

[阅读第四讲](docs/chapter4.md), 实现了时钟中断,但是没有其他的外设和异常处理,想要放在用户进程管理中实现.

[阅读第七章](docs/chapter4.5.md), 别问我为什么先做第七讲, 看到exec实在看不懂了先来补文件系统.

[阅读第五六章](docs/chapter5&6.md), 系统调用的原理过于简单, 直接放在这里了, 而且`fork`和`exec`补做出来第五章基本没有

## 分支说明
除`main`分支外,其他的从上到下基本为衍生关系
- main 最新的分支
- boot 实现基本的进入系统
- printf 实现串口操作和console的操作
- bss 一个用于验证bss清空的分支
- kalloc 实现了物理分配
- vm 实现了虚拟地址
- trap 实现了时钟中断
- userinit 实现了跳转用户态
- syscall 实现了系统调用
- usertest 完成用户态测试代码
- filetest 完成文件系统测试代码
- priority 实现静态多级反馈队列

