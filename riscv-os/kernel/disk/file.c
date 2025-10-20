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



struct file*
filedup(struct file *f){
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
  release(&ftable.lock);
  return f;
}

void fileclose(struct file* f){
  struct file ff;
  
  acquire(&ftable.lock);

  // 显然文件的内存引用计数不可能小于1
  if(f->ref < 1)
    panic("fileclose");

  // 如果内存引用计数大于1 那么直接减少引用计数然后返回
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  // 准备关闭文件
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

// 所以父子进程是共享读取文件偏移量的
int 
fileread(struct file* f, uint64 addr, int n){
  int r = 0;
  if(f->readable == 0)
    return -1;
  
  if(f->type == FD_PIPE){
    // r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
  }else{
    panic("fileread");
  }


  return r;
}

int 
filewrite(struct file* f, uint64 addr, int n){
  int r, ret = 0;

  if(f->writable == 0){
    return -1;
  }

  if(f->type == FD_PIPE){
    // ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    // 这里不能一次性写完太多数据
    // 因为每次写数据都要进行日志提交
    // 同时内存缓冲区也只有30个块大小
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r != n1){
        // error from writei
        break;
      }
      i += r;
    }
    ret = (i == n ? n : -1);
  }else{
    panic("filewrite");
  }
  return ret;
}

