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
    

struct buf*
bget(int dev, int bnum){
    struct buf* b;
    
    acquire(&bcache.lock);

    for(b = bcache.head.next; b != &bcache.head; b = b->next){
        if(b->dev == dev && b->blockno == bnum){
            // 一个小细节 放在这里更合适
            b->refcnt++;
            release(&bcache.lock);
            acquiresleep(&b->lock);
            b->refcnt++;
            return b;

        }
    }
    for(b = bcache.head.next; b != &bcache.head; b = b->next){
        // 这里思考一下 一个refcnt 为 0 的块真的被写回了硬盘吗?
        // 这里是一定的 首先假设整个系统都没有关闭过, 那在磁盘操作的时候
        // 一定会先使用日志系统
        // log_write
        // 这里会使用 bpin 把 这个块钉住 
        // end_op写回后 再用 bunpin放开
        if(b->refcnt == 0){
            
            b->dev = dev;
            b->blockno = bnum;
            b->valid = 0;
            b->refcnt = 1;
            release(&bcache.lock);
            acquiresleep(&b->lock);
            return b;
        }
    }

    panic("bget: 没有空闲内存块了捏(悲)");
    return 0;
}

void 
brelse(struct buf *b){
    if(!holdingsleep(&b->lock))
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
}


struct buf* 
bread(int dev, int bnum){
    struct buf *b;
    b = bget(dev, bnum);
    
    if(!b->valid){

        virtio_disk_rw(b, 0);

        b->valid = 1;
    }
    return b;

}


void 
bwrite(struct buf *b){
    if(!holdingsleep(&b->lock))
        panic("bwrite");
    virtio_disk_rw(b, 1);
}   

void bpin(struct buf *b){
    acquire(&bcache.lock);
    b->refcnt++;
    release(&bcache.lock);
}

void bunpin(struct buf *b){
    acquire(&bcache.lock);
    b->refcnt--;
    release(&bcache.lock);
}