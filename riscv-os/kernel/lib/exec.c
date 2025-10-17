#include "include/types.h"
#include "include/param.h"
#include "include/memlayout.h"
#include "include/riscv.h"
#include "include/spinlock.h"
#include "include/proc.h"
#include "include/defs.h"
#include "include/elf.h"

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    int perm = 0;
    if(flags & 0x1)
      perm = PTE_X;
    if(flags & 0x2)
      perm |= PTE_W;
    return perm;
}

// Load an ELF program segment into pagetable at virtual address va.
// va must be page-aligned
// and the pages from va to va+sz must already be mapped.
// Returns 0 on success, -1 on failure.
static int
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = uVA2PA(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
      return -1;
  }
  
  return 0;
}


int kexec(char* path, char ** argv){
    char* s, *last;
    int i, off;
    uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;

    struct elfhdr elf;
    struct inode *ip;
    struct proghdr ph;
    pagetable_t pagetable = 0, oldpagetable;
    struct PCB *p = myproc();


    // 先找到可执行文件
    begin_op();

    // Open the executable file.
    if((ip = namei(path)) == 0){
        end_op();
        return -1;
    }
    ilock(ip);

    // 读取ELF头
    if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
        goto bad;

    // 确认是ELF文件
    if(elf.magic != ELF_MAGIC)
        goto bad;   
    
    // 为进程分配页表
    // 实际上之前的程序已经分配过一次页表
    // 这里再分配一次 就像fork后使用exec一样
    // 原来的页表也会销毁
    if((pagetable = procPagetable(p)) == 0)
        goto bad;


    // 把程序加载到内存
    // 反正我看不懂
    for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
        if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
            goto bad;
        if(ph.type != ELF_PROG_LOAD)
            continue;
        if(ph.memsz < ph.filesz)
            goto bad;
        if(ph.vaddr + ph.memsz < ph.vaddr)
            goto bad;
        if(ph.vaddr % PGSIZE != 0)
            goto bad;
        uint64 sz1;
        if((sz1 = uVmAlloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
            goto bad;
        sz = sz1;
        if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
            goto bad;
    }

    // 这里复制完成了;
    // 后面inode就不重要了 所以把它放回去
    iunlock(ip);
    iput(ip);
    end_op();
    ip = 0;

    // 这里是兼容fork的设置
    p = myproc();
    uint64 oldsz = p->sz;   


    // 分配栈空间
    sz = PGROUNDUP(sz);
    uint64 sz1;
    if((sz1 = uVmAlloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
        goto bad;
    sz = sz1;
    // 清空栈空间
    uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    sp = sz;
    stackbase = sp - USERSTACK*PGSIZE;


    // 将参数复制到ustack上
    for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
        goto bad;
    sp -= strlen(argv[argc]) + 1;
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    if(sp < stackbase)
        goto bad;
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
        goto bad;
    ustack[argc] = sp;
    }
    ustack[argc] = 0;

    // 复制到栈上面
    sp -= (argc+1) * sizeof(uint64);
    sp -= sp % 16;
    if(sp < stackbase)
        goto bad;
    if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    goto bad;

      p->trapframe->a1 = sp;

    // Save program name for debugging.
    for(last=s=path; *s; s++)
        if(*s == '/')
        last = s+1;
    safestrcpy(p->name, last, sizeof(p->name));
        
    // Commit to the user image.
    oldpagetable = p->pagetable;
    p->pagetable = pagetable;
    p->sz = sz;
    p->trapframe->epc = elf.entry;  // initial program counter = ulib.c:start()
    p->trapframe->sp = sp; // initial stack pointer
    uFreeUserVM(oldpagetable, oldsz);

    return argc; // this ends up in a0, the first argument to main(argc, argv)

bad:
    if(pagetable)
        uFreeUserVM(pagetable, sz);
    if(ip){
        iunlock(ip);
        iput(ip);
        end_op();
    }
    return -1;
}