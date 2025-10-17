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

struct logheader {
  int n;
  int block[LOGBLOCKS];
};

struct log {
  struct spinlock lock;
  int start;
  int outstanding; // how many FS sys calls are executing.
  int committing;  // in commit(), please wait.
  int dev;
  struct logheader lh;
};


struct log log;

void
log_write(struct buf* b){
    int i;
    acquire(&log.lock);
    if (log.lh.n >= LOGBLOCKS)
        panic("too big a transaction");
    if (log.outstanding < 1)
        panic("log_write outside of trans");

    // 同一个块在同一个周期内可能被多次写入
    // 所以这里如果有相同的直接分配即可.
    for (i = 0; i < log.lh.n; i++) {
        if (log.lh.block[i] == b->blockno)   // log absorption
            break;
    }
    log.lh.block[i] = b->blockno;
    if (i == log.lh.n) {  // Add new block to log?
        bpin(b);
        log.lh.n++;
    }
    release(&log.lock);
}



static void
read_head(void){
    
    // 读取文件头
    struct buf* buf = bread(log.dev, log.start);

    struct logheader* lh = (struct logheader *)(buf->data);
    int i;
    log.lh.n = lh->n;

    for(i = 0; i < log.lh.n; i++){
        log.lh.block[i] = lh->block[i];
    }
    brelse(buf);

}

static void
write_head(void){
    struct buf *buf = bread(log.dev, log.start);
    struct logheader* hb = (struct logheader* )(buf->data);
    int i;
    for(i = 0; i < log.lh.n; i++)
        hb->block[i] = log.lh.block[i];
    
    bwrite(buf);
    brelse(buf);
}


static void
install_trans(int recovering){
    int tail;
    
    for(tail = 0; tail < log.lh.n; tail++){
        if(recovering) {
            printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
        }
        struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
        struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
        memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
        bwrite(dbuf);  // write dst to disk
        if(recovering == 0)
            bunpin(dbuf);
        brelse(lbuf);
        brelse(dbuf);
    }
}

static void 
recover_from_log(void){
    read_head();
    install_trans(1);
    log.lh.n = 0;
    write_head();

}


// 将内存中的数据存入硬盘
static void
write_log(){
    int tail;

    for(tail = 0; tail < log.lh.n; tail++){
        struct buf* to = bread(log.dev, log.start+tail + 1);
        struct buf* from = bread(log.dev, log.lh.block[tail]);
        memmove(to->data, from->data, BSIZE);
        bwrite(to);
        brelse(from);
        brelse(to);
    }
}

static void
commit(){
    if(log.lh.n > 0){
        write_log();
        // 第一次写头是先存储文件头的状态
        // 防止后序操作进行到一半还要等待
        write_head();
        install_trans(0);
        log.lh.n = 0;
        // 这里是日志系统搞完了
        // 所以要把日志头清空
        write_head();
    }
}





void initlog(int dev, struct superblock* sb){
    // 在日志系统中, 整个磁盘中的规划如下:
    // | 日志头 1块 | 日志暂存数据块 30 块 | 
    if(sizeof(struct logheader) >= BSIZE)
        panic("initlog: 日志头不能太大");

    initlock(&log.lock, "log");
    log.start = sb->logstart;
    log.dev = dev;
    recover_from_log();
}


void begin_op(){
    acquire(&log.lock);

    while(1){
        if(log.committing){
            sleep(&log, &log.lock);
        }else if(log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGBLOCKS){
            // 这种情况是 这个操作可能会耗尽日志空间, 所以等待提交
            sleep(&log, &log.lock);
        }else{
            log.outstanding += 1;
            release(&log.lock);
            break;
        }
    }
}

void end_op(){
    int do_commit = 0;

    acquire(&log.lock);
    log.outstanding -= 1;
    if(log.committing)
        panic("log.committing");
    if(log.outstanding == 0){
        do_commit = 1;
        log.committing = 1;
    }else{
        wakeup(&log);
    }
    release(&log.lock);

    if(do_commit){
        // 当前没有其他操作了, 可以提交
        commit();
        acquire(&log.lock);
        log.committing = 0;
        wakeup(&log);
        release(&log.lock);
    }
}