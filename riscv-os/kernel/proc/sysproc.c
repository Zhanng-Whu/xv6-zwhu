#include "include/types.h"
#include "include/riscv.h"
#include "include/defs.h"
#include "include/param.h"
#include "include/memlayout.h"
#include "include/spinlock.h"
#include "include/proc.h"
#include "include/vm.h"


uint64 
sys_exit(void){
    int n;
    argint(0, &n);
    kexit(n);
    return 0;
}
uint64
sys_set_priority(void){
    int pid, priority;
    argint(0, &pid);
    argint(1, &priority);
    return set_priority(pid, priority);
}

extern int ticks;
extern struct spinlock tickslock;

uint64
sys_uptime(void){
  acquire(&tickslock);
  int x = ticks;
  release(&tickslock);

  return x;

}

uint64
sys_wait(void){
    uint64 p;
    argaddr(0, &p);
    return kwait(p);
}

uint64 
sys_fork(void){
    return kfork();
}
uint64
sys_getpid(void){
  return myproc()->pid;
}

uint64
sys_exec(void)
{

  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);


  if(argstr(0, path, MAXPATH) < 0) {
    return -1;
  }
  memset(argv, 0, sizeof(argv));


  for(i=0;; i++){
    if(i >= NELEM(argv)){
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
      goto bad;
    }

    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
      goto bad;
  }

  int ret = kexec(path, argv);

  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    kfree(argv[i]);

  return ret;

 bad:
 printf("exec bad\n");

  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    kfree(argv[i]);
  return -1;
}