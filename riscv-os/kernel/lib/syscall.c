#include "include/types.h"
#include "include/param.h"
#include "include/memlayout.h"
#include "include/riscv.h"
#include "include/spinlock.h"
#include "include/proc.h"
#include "include/syscall.h"
#include "include/defs.h"

// Fetch the uint64 at addr from the current process.
int
fetchaddr(uint64 addr, uint64 *ip)
{
  struct PCB *p = myproc();
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    return -1;
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    return -1;
  return 0;
}

static uint64
argraw(int n){
    struct PCB* p = myproc();
    switch (n)
    {
    default:
    case 0:
        return p->trapframe->a0;
    case 1:
        return p->trapframe->a1;
    case 2:
        return p->trapframe->a2;
    case 3:
        return p->trapframe->a3;
    case 4:
        return p->trapframe->a4;
    case 5:
        return p->trapframe->a5;
    }

    panic("argraw");
    return -1;
}

int fetchstr(uint64 addr, char* buf, int max){
    struct PCB* p = myproc();
    if(copyinstr(p->pagetable, buf, addr, max) < 0)
        return -1;
    return strlen(buf); 
}

void
argint(int n, int* ip){
    *ip = argraw(n);
}

void argaddr(int n, uint64* ip){
    *ip = argraw(n);
}

// 读取字符串需要从用户的地址上面都读取 这里使用either_copyin来实现
int 
argstr(int n, char* buf, int max){
    uint64 addr;
    argaddr(n, &addr);
    return fetchstr(addr, buf, max);
}

static uint64
sys_hello(void){
    printf("Hello, world!\n");
    return 0;
}

static uint64 (*syscalls[])(void) = {
[SYS_hello]    sys_hello,
[SYS_exit]     sys_exit,
[SYS_wait]     sys_wait,
[SYS_fork]     sys_fork,
[SYS_exec]     sys_exec,
};


void 
syscall(void){
    int num;
    struct PCB* p = myproc();

    num = p->trapframe->a7;
    if(num > 0 && num < NELEM(syscalls) && syscalls[num]){
        p->trapframe->a0 = syscalls[num]();
    } else {
        printf("%d %d: unknown sys call %d\n", p->pid, cpuid(), num);
        p->trapframe->a0 = -1;
    }

}