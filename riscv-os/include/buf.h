#ifndef BUF
#define BUF

#include <include/sleeplock.h>
#include <include/fs.h>

struct buf{
    int valid;
    int disk;
    uint dev;
    uint blockno;
    struct sleeplock lock;
    uint refcnt;
    struct buf* prev;
    struct buf* next;
    uchar data[BSIZE];
};


#endif