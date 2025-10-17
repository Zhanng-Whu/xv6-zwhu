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
