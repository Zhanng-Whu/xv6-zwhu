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

[阅读第一章](docs/chapter1.md)