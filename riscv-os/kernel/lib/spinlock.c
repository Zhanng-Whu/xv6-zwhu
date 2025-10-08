#include "include/types.h"
#include "include/riscv.h"
#include "include/defs.h"
#include "include/proc.h"
#include "include/spinlock.h"


// 检查是否持有这个锁
// 要需要提前关闭中断
int holding(struct spinlock* lk){
    return (lk->locked && lk->cpu == mycpu());
}

// 锁初始化
void 
initlock(struct spinlock* lk, char* name){
    lk->name = name;
    lk->locked = 0;
    lk->cpu = 0;
}




void 
acquire(struct spinlock* lk){
    push_off(); // 关闭中断 避免死锁
    if(holding(lk))
        panic("acquire");

    // RISC-V的sync_lock_test_and_set会变成一个原子交换操作
    // a5 = 1
    // s1 = &lk->locked
    // amoswap.w.aq a5, a5, (s1)
    while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
        ;

    __sync_synchronize();

    lk->cpu = mycpu();
}

void release(struct spinlock* lk){
    if(!holding(lk))
        panic("release");

    lk->cpu = 0;

    __sync_synchronize();
    __sync_lock_release(&lk->locked);

    pop_off();
}

void
push_off(void)
{
  int old = intr_get();

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    mycpu()->intena = old;
  mycpu()->noff += 1;
}

void
pop_off(void)
{
  struct cpu *c = mycpu();
  if(intr_get())
    panic("pop_off - interruptible");
  if(c->noff < 1)
    panic("pop_off");
  c->noff -= 1;
  if(c->noff == 0 && c->intena)
    intr_on();
}