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

void kvmmap(pagetable_t kpgtbl, uint64 va, uint64 pa, uint64 sz, int perm);
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm);


// 制作一个直接映射的页表
pagetable_t
kvmmake(void){

    // 设定内核的 kpgtbl
    // kpgtbl的全称是 kernel page table
    pagetable_t kpgtbl;

    // 分配一个空间，并且初始化为0
    kpgtbl = (pagetable_t) kalloc();
    memset(kpgtbl, 0, PGSIZE);

    // 恒等映射 保证虚拟空间也可以正常使用一些外设

    // uart registers
    kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);

    // virtio mmio disk interface
    kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);

    // PLIC
    kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);

    // map kernel text executable and read-only.
    kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);

    // map kernel data and the physical RAM we'll make use of.
    kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);

    // map the trampoline for trap entry/exit to
    // the highest virtual address in the kernel.
    kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);

    // 为每一个进程分配一个系统栈
    proc_mapstacks(kpgtbl);

    return kpgtbl;
    
}

// 想内核页表中添加一个映射
// 仅在启动时使用
// 不刷新TLB或者启用分页
void kvmmap(pagetable_t kpgtbl, uint64 va, uint64 pa, uint64 sz, int perm){

    if(mappages(kpgtbl, va, sz, pa, perm) != 0)
        panic("kvmmap");

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
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm){
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
kvminit(void)
{
  kernel_pagetable = kvmmake();
}
