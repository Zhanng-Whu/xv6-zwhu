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
#include "include/proc.h"

struct devsw devsw[NDEV];  

struct {
  struct spinlock lock;
  struct file file[NFILE];
} ftable;

void fileinit(void){
  initlock(&ftable.lock, "ftable");

}

struct file*
filealloc(void){
  struct file* f;

  // 原子的进行file的分配
  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}

// 关闭一个进程的文件
void fileclose(struct file *f){
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE){
    // pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}

struct file*
filedup(struct file *f){
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
  release(&ftable.lock);
  return f;
}