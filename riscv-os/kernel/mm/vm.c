#include "include/param.h"
#include "include/types.h"
#include "include/riscv.h"
#include "include/defs.h"
#include "include/spinlock.h"
#include "include/memlayout.h"

pagetable_t kernel_pagetable;

// kernel.ld里面规定的内核代码段的终止地址
extern char etext[];

// kernel.ld里面规定的中断向量的入口
extern char trampoline[];

void kVmMap(pagetable_t kpgtbl, uint64 va, uint64 pa, uint64 sz, int perm);

// 制作一个直接映射的页表
pagetable_t
kVmMake(void){

    // 设定内核的 kpgtbl
    // kpgtbl的全称是 kernel page table
    pagetable_t kpgtbl;

    // 分配一个空间，并且初始化为0
    kpgtbl = (pagetable_t) kalloc();
    memset(kpgtbl, 0, PGSIZE);

    // 恒等映射 保证虚拟空间也可以正常使用一些外设

    // uart registers
    kVmMap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);

    // virtio mmio disk interface
    kVmMap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);

    // PLIC
    kVmMap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);

    // map kernel text executable and read-only.
    kVmMap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);

    // map kernel data and the physical RAM we'll make use of.
    kVmMap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);

    // map the trampoline for trap entry/exit to
    // the highest virtual address in the kernel.
    kVmMap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);

    // 为每一个进程分配一个系统栈
    proc_mapstacks(kpgtbl);

    return kpgtbl;
    
}

// 想内核页表中添加一个映射
// 仅在启动时使用
// 不刷新TLB或者启用分页
void kVmMap(pagetable_t kpgtbl, uint64 va, uint64 pa, uint64 sz, int perm){

    if(mapPages(kpgtbl, va, sz, pa, perm) != 0)
        panic("kVmmap");

}

// 核心函数
// 有两个功能 取决于alloc是否为0
// 如果alloc为0 那么就是查询虚拟地址va对应的 L0PTE 地址
// 如果alloc为0 那么就是在查询的过程中如果发现缺页就分配一个新的页表页
// walk返回的是L0PTE的地址
// 如果找不到返回0
pte_t*
walk(pagetable_t pagetable, uint64 va, int alloc){
    
    if(va >= MAXVA)
        panic("walk");
    
    for(int level = 2; level > 0; level--){
        

        // 找到当VA对应的level级页表项
        pte_t* pte = &pagetable[PX(level, va)];
        
        // 如果页表页有效 那么提取这一页表项对应的物理地址
        // 也就是找到那个页表
        if(*pte & PTE_V){
            pagetable = (pagetable_t)PTE2PA(*pte);
        }else{
            // 如果页表项无效 并且不需要分配 那么直接返回0
            if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
                return 0;
            // 分配成功之后 将这一页表页清零
            memset(pagetable, 0, PGSIZE);
            // 然后将这个新分配的页表页的物理地址写入到当前的页表项中
            *pte = PA2PTE(pagetable) | PTE_V;
        }
    }
    return &pagetable[PX(0, va)];
}

// 在页表pagetable中添加从va开始的size字节的映射，映射到物理地址pa
// va和size必须内存对齐
// 返回0表示成功，-1表示失败
int
mapPages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm){
    uint64 a, list;
    pte_t* pte;

    if((va % PGSIZE) != 0)
        panic("mappages: 虚拟地址VA没有对齐");

    if((size % PGSIZE) != 0)
        panic("mappages: 大小SIZE没有对齐");
    
    if(size == 0)
        panic("mappages: 大小SIZE为0");
    
    a = va;
    list = va + size - PGSIZE;
    for(;;){
        if((pte = walk(pagetable, a, 1)) == 0)
            return -1;
        
        // 这里的数据一定是没有被分配的
        if(*pte & PTE_V)
            panic("mappages: 重复分配页");
        
        // 标记这一页指向pa
        *pte = PA2PTE(pa) | perm | PTE_V;


        // 分配完成
        if(a == list)
            break;

        a += PGSIZE;
        pa += PGSIZE;
    }
    return 0;
}

// Initialize the kernel_pagetable, shared by all CPUs.
void
kVmInit(void)
{
  kernel_pagetable = kVmMake();
}

// 创建一个空的用户页表
pagetable_t
uVmCreate(void){
    pagetable_t pagetable;

    pagetable = (pagetable_t) kalloc();
    
    if(pagetable == 0)
        return 0;
    
    memset(pagetable, 0, PGSIZE);
    return pagetable;
}


// 切换当前CPU的硬件页表寄存器到内核的页表，并且启用分页
void
kVmInitHart(){
    // 开启内存屏障
    sfence_vma();

    // 切换到内核页表
    w_satp(MAKE_SATP(kernel_pagetable));

    // 刷新TLB中的过期条目
    sfence_vma();
}

void
uvmclear(pagetable_t pagetable, uint64 va){
    pte_t* pte;

    pte = walk(pagetable, va, 0);
    if(pte == 0)
        panic("uvmclear");
    
    *pte &= ~PTE_U;
}

void printPgtbl(pagetable_t pagetable, int level, int to_level){

    static const char padding[][10] = {"        ", "    ", ""};
    if(level > 2 || level < 0){
        return;
    }
    printf("%s%d级页表地址 %p\n", padding[level], level, pagetable);
    if(level <= to_level){
        return;
    }
    uint64 begin = (uint64)pagetable;
    uint64 end = begin + PGSIZE;
    for(;begin < end; begin += 8){
        if(*(uint64*)begin & PTE_V){
            uint64 pte = *(uint64*)begin;
            if(level > 0){
                printf("%s0x%x表项有效,指向0x%x地址\n", padding[level], begin, PTE2PA((uint64)pte));
                printPgtbl((pagetable_t)PTE2PA((uint64)pte), level - 1, to_level);
            }else{
                printf("%s0x%x表项指向0x%x地址,权限为", padding[level], begin, PTE2PA((uint64)pte));
                if(pte & PTE_R) printf("R"); else printf("-");
                if(pte & PTE_W) printf("W"); else printf("-");
                if(pte & PTE_X) printf("X"); else printf("-");
                printf("\n");
            }
        }
    }


}



// 检查这个对应的页表项是否被使用
// 如果没有被使用 那么返回0
// 否则返回1
int
ismapped(pagetable_t pagetable, uint64 va)
{
  pte_t *pte = walk(pagetable, va, 0);
  if (pte == 0) {
    return 0;
  }
  if (*pte & PTE_V){
    return 1;
  }
  return 0;
}

uint64
vmfault(pagetable_t pagetable, uint64 va, int read){
    uint64 mem;

    if(va >= MAXVA)
        return 0;
    
    va = PGROUNDDOWN(va);

    if(ismapped(pagetable, va)){
        return 0;
    }

    mem = (uint64) kalloc();
    if(mem == 0)
        return 0;
    
    memset((void*)mem, 0, PGSIZE);
    if(mapPages(pagetable, va, PGSIZE, mem, PTE_W|PTE_U|PTE_R) != 0){
        kfree((void*)mem);
        return 0;
    }
    return mem;
}

// 只读版的walk函数,专门用于实现用户态程序读取自己的页表
// 根据用户的虚拟地址和页表,读取对应的物理地址
uint64
uVA2PA(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    return 0;

  pte = walk(pagetable, va, 0);
  if(pte == 0)
    return 0;
  if((*pte & PTE_V) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}


// 解除用户页表pagetable中从va开始的npages个页的映射
// 如果do_free为1,则同时释放这些页对应的物理内存
// va必须是页对齐的
void uVmUnmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    uint64 a;
    pte_t *pte;

    if((va % PGSIZE) != 0)
    panic("uvmunmap: not aligned");

    for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
        if((pte = walk(pagetable, a, 0)) == 0) // 虚拟地址对应的页表项不存在
            continue;   
        if((*pte & PTE_V) == 0)  // PTE无效(对应物理地址未被分配)
            continue;
        if(do_free){
            uint64 pa = PTE2PA(*pte);
            kfree((void*)pa);
        }
        *pte = 0;
    }
}

// 释放整个页表
// 必须保证所有的页都已经被释放
// 通过递归实现释放所有空间
void freePgtbl(pagetable_t pagetable){
    for(int i = 0; i < 512; i++){
        pte_t pte = pagetable[i];
        
        // 释放非叶子节点
        if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
            uint64 child = PTE2PA(pte);
            freePgtbl((pagetable_t)child);
            pagetable[i] = 0;
        }else if(pte & PTE_V){
            panic("freePgtbl: 释放页表前应该保证所有的叶子节点都被释放并且对应的物理地址被释放,否则会出现内存泄漏");
        }
    }
    // 释放页表的内存空间
    kfree((void*)pagetable);
}

// 释放用户的虚拟内存空间sz字节
//
// sz不需要页对齐
// 释放之后会释放用户页表

void
uVmFree(pagetable_t pagetable, uint64 sz)
{
  if(sz > 0)
    uVmUnmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freePgtbl(pagetable);
}




// 将用户的内存空间从oldsz扩展到newsz
// newsz必须大于oldsz
// 返回新的内存空间的大小
uint64
uVmAlloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz, int xperm)
{
  char *mem;
  uint64 a;

  if(newsz < oldsz)
    return oldsz;

  oldsz = PGROUNDUP(oldsz);
  for(a = oldsz; a < newsz; a += PGSIZE){
    mem = (char*)kalloc();
    // 如果内存空间不足,那么会杀死整个用户的虚拟内存空间
    if(mem == 0){
      uVmFree(pagetable, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mapPages(pagetable, a, PGSIZE, (uint64)mem, PTE_U|PTE_R|xperm) != 0){
      kfree(mem);
      uVmFree(pagetable, oldsz);
      return 0;
    }
  }
  return newsz;
}

// 缩小内存空间
uint64
uVmDealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz){
    if(newsz >= oldsz)
        return oldsz;
    
    if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
        int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
        uVmUnmap(pagetable, PGROUNDUP(newsz), npages, 1);
    }
    
    return newsz;
}