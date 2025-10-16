#include "include/types.h"
#include "include/param.h"
#include "include/spinlock.h"
#include "include/riscv.h"
#include "include/defs.h"
#include "include/fs.h"
#include "include/buf.h"


struct {
    struct spinlock lock;
    struct buf buf[NBUF];

    struct buf head;
}bcache;

void binit(void){
    struct buf* b;

    bcache.head.next = &bcache.head;
    bcache.head.prev = &bcache.head;    
    initlock(&bcache.lock, "bcache");
    for(int i = 0; i < NBUF; i++){
        b = &bcache.buf[i];
        initsleeplock(&b->lock, "buf");
        b->next = bcache.head.next;
        b->prev = &bcache.head;
        bcache.head.next->prev = b;
        bcache.head.next = b;
    }
}