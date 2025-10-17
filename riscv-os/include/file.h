#ifndef FILE_H
#define FILE_H

struct file{


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


#endif