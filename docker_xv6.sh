#! /bin/bash

IMAGE_NAME=zwhu/riscv:base
BASE_PATH=/home/zhanng/文档/GitHub/xv6-zwhu
DIR_PATH=xv6-riscv

docker run -it --rm \
--net=host \
--ipc=host \
--pid=host \
--privileged \
--dns=8.8.8.8 \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-e DISPLAY=$DISPLAY \
-v $HOME/.Xauthority:/root/.Xauthority:ro \
-v $BASE_PATH/$DIR_PATH:/workspace \
$IMAGE_NAME /bin/bash