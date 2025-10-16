#include "include/types.h"
#include "include/riscv.h"
#include "include/defs.h"
#include "include/param.h"
#include "include/stat.h"
#include "include/spinlock.h"
#include "include/proc.h"
#include "include/sleeplock.h"
#include "include/fs.h"
#include "include/buf.h"
#include "include/file.h"

struct{
    struct spinlock lock;
    struct inode inode[NBUF];
} itable;


void 
iinit(){
    int i = 0;

    initlock(&itable.lock, "itable");
    for(i = 0; i < NBUF; i++){
        initsleeplock(&itable.inode[i].lock, "inode");
    }
}