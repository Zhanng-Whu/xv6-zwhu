#ifndef FILE_H
#define FILE_H


#include "include/spinlock.h"
#include "include/sleeplock.h"

// file是基于进程层面的实现
// file的是由进程的文件描述符实现的
// 并且由系统的打开文件表 ftable 管理
struct file{
    enum { FD_NONE, FD_PIPE, FD_INODE, FD_DEVICE } type;
    int ref; // reference count
    char readable;
    char writable;
    // struct pipe* pipe; // 只有FD_PIPE类型会使用 反正我也不会写 先空着
    struct inode* ip;  // 文件和设备会使用
    uint off;          // 用于文件使用 这里是因为文件是可以随机读写的
                       // 用于记录偏移
    short major;       // 记录设备号 只有FD_DEVICE会使用

};

struct inode{
    // 内存存储
    uint dev;
    uint inum;
    int ref;
    struct sleeplock lock;
    int valid;
    
    // 硬盘存储
    short type;
    short major;
    short minor;
    short nlink;
    uint size;
    uint addrs[NDIRECT+1];
};

struct devsw{
    int (*read)(int, uint64, int);
    int (*write)(int, uint64, int);
};
extern struct devsw devsw[];
#define CONSOLE 1

#endif