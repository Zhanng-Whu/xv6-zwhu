# 第三讲

本章要实现内存管理，实现虚拟内存和实现独立的物理内存分配和页表管理系统。

还是要先确定整个系统的内存管理逻辑。依然是从初始化开始理解。

涉及到的主要文件有：

- `kalloc.c` 实现物理内存分配
- `vm.c` 实现虚拟内存管理

```c
kinit();      
kvminit();    
kvminithart();

```

## kalloc.c 物理内存分配实现

```c

void freerange(void *pa_start, void *pa_end);

extern char end[]; 
// first address after kernel.
// defined by kernel.ld.
```

首先看到文件的开头，这里有两个内容，一个是end指针，一个是一个函数`void freerange(void* pa_start, void pa_end)`。这里的end指针定义在连接器脚本中，他的功能就是指定系统内核以后的内存空间。接着是初始化的函数`freerange`，这个函数只在`kinit`中调用一次，作用就是将从`pa_start`开始的地址到`pa_end`的地址按照页进行清理，然后连接成一个大的空闲页面链表。

### 宏定义

然后来看到几个常用的宏，定义在`riscv.h`中。

```c
#define PGSIZE 4096 
#define PGSHIFT 12  
```

注意到$2^{12} = 4096$。

```c

#define PGROUNDUP(sz)  (((sz)+PGSIZE-1) & ~(PGSIZE-1))
#define PGROUNDDOWN(a) (((a)) & ~(PGSIZE-1))
```

此事在树状数组中亦有记载，也就是向上取整还是向下取整。

然后是PTE(Page Table Entry，页表项)的符号位。

先回忆一下什么是页表，每一个用户进程涉及到一个虚拟内存，在用户视角里面就是一个用户进程独占一个完整的内存，那么需要实现用户的虚拟内存到物理内存的转化，而这个转化的地址就存储在页表中。

RISCV中，页表的一个PTE中包含两个部分，低十位是标志位数，第11，12为空白，后面的就是物理页号，所以实现就是这样的宏定义：

```c
#define PA2PTE(pa) ((((uint64)pa) >> 12) << 10)
#define PTE2PA(pte) (((pte) >> 10) << 12)
#define PTE_FLAGS(pte) ((pte) & 0x3FF)
```

还有一些符号位的使用：

```c
#define PTE_V (1L << 0) // valid
#define PTE_R (1L << 1)
#define PTE_W (1L << 2)
#define PTE_X (1L << 3)
#define PTE_U (1L << 4) // user can access
```

### 初始化

```c

struct {
  struct spinlock lock;
  struct run *freelist;
} kmem;

struct run {
  struct run *next;
};

void
kinit()
{
  initlock(&kmem.lock, "kmem");
  freerange(end, (void*)PHYSTOP);
}
```

首先先初始化一个锁，这个锁就是空闲链表结构体中的锁，然后将从end开始（函数里面实现了向上对齐）到整个内存地址的尽头(`0x80000000L + 128MB`)的的位置全部初始化。

```c
void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p);
}
```

这里看一下`kfree`函数，是`kalloc.c`的核心函数。

```c

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}
```

先关心结构是如何组织起来的，简化掉其他的所以内容后，结构如下：

```c
void
kfree(void *pa)
{
  struct run *r;
  r = (struct run*)pa;
  r->next = kmem.freelist;
  kmem.freelist = r;
}
```

他将每一个页的第一个字节指向空闲页链表的首地址，然后让空闲页链表的表头变更为当前的地址。

完整的结构下，会判断当前的地址是否合法，同时对页面的所有字节全部设置成垃圾内容来避免危险的引用：

```c

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

```

综上所述，物理的内存分配主要就是涉及到两个接口：

- `kalloc(void)` 返回一个空闲物理页
- `void kfree()`释放一个页面

### 虚拟内存实现



>The risc-v Sv39 scheme has three levels of page-table
>pages. A page-table page contains 512 64-bit PTEs.
>A 64-bit virtual address is split into five fields:
>
>- 39..63 -- must be zero.
>- 30..38 -- 9 bits of level-2 index.
>- 21..29 -- 9 bits of level-1 index.
>- 12..20 -- 9 bits of level-0 index.
>- 0..11 -- 12 bits of byte offset within the page.

xv6的虚拟内存一共39位，其中分为四个部分，高27位分别对应三级页表，低12位代表页表内部`offset`。

页表的初始化分为两个部分，一个是初始化内核页表，另一个是开启虚拟内存和分页功能。

先来看初始化内核页表。

```c
pagetable_t kernel_pagetable;
void
kvminit(void)
{
  kernel_pagetable = kvmmake();
}

pagetable_t
kvmmake(void){

    // 设定内核的 kpgtbl
    // kpgtbl的全称是 kernel page table
    pagetable_t kpgtbl;

    // 分配一个空间，并且初始化为0
    kpgtbl = (pagetable_t) kalloc();
    memset(kpgtbl, 0, PGSIZE);

    // 恒等映射 保证虚拟空间也可以正常使用一些外设
    kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
	
    
    kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    // 为每一个进程分配一个系统栈
    proc_mapstacks(kpgtbl);
    return kpgtbl;
}



// 向内核页表中添加一个映射
// 仅在启动时使用
// 不刷新TLB或者启用分页
void kvmmap(pagetable_t kpgtbl, uint64 va, uint64 pa, uint64 sz, int perm){
    if(mappages(kpgtbl, va, sz, pa, perm) != 0)
        panic("kvmmap");
}
```

这里的核心函数就是kvmmap函数和walk函数，`int kvmmap（pagetable_t pagetable, uint64 va, uint64 pa, uint64 sz, int perm）`,表示向pagetable中的va的虚拟地址映射到pa的位置，并且顺位分配后面大小为sz的空间，并且设置为perm权限。这里注意，va，pa，sz都需要是页对齐的，并且va的对应的L0页表项应该是没有被分配的。

`pte_t* walk(pagetable_t pagetable, uint64 va, int alloc)`的功能有查询和分配两个，如果alloc=0，那么就会尝试把va对应的L0的页表项返回回来，但是如果这个虚拟地址的页表项不存在，那么就会返回失败，但是如果alloc=1, 那么当PTE不存在的时候，就会直接创造对应的页表项。

```c
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

```

## 任务解答

### Task1

```txt
38	    30 29	21 20	 12 11		 0
| VPN[2] | VPN[1] | VPN[0] | offset |
```

1. 每个VPN段的作用是什么？

对应一段页表

2. 为什么是9位而不是其他位数？

一页为4096字节，那么一个页表项是8字节，所以一页也就是512=$2^9$字节，对应就是9位。

3. 为什么选择三级页表
4. 中间级页表的RWX如何设置？

中间的只需要设置有效位即可，不需要设置R/W/X权限

5. 如何理解"页表也存储在物理内存中"？

这里内核的页表就是一个例子，他是一个地址，先从内存中分配一页，然后从这个页上开始向下散开。

### Task2

1. 研读 kalloc.c 的核心数据结构：

```c
struct run {
    struct run *next;
};
```

空闲链表管理，优点就是十分简单并且高效，并且不需要额外的代价存储，缺点就是难以获取连续的内存空间，同时内部碎片严重，只能以页为单位分配空间。

2. 为什么上面的设计不需要额外的空间存储。

```c
void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}
```

实际上，他直接将内存空间视作一个`struct run*`的指针，直接在内存空间中指向下一个空闲空间。

3. 分析 kinit() 的初始化过程： 如何确定可分配的内存范围？

很简单，在`kernal.ld`中规定了内存空间的完结后的end的标记，对end向上取整，就得到了起始地址，而终止地址是我们事先在`cmake`中设定好了的。

4. 空闲页链表是如何构建的？
5. 为什么要按页对齐？

为了虚拟内存方便使用页表。

6. 理解 kalloc() 和 kfree() 的实现：分配算法的时间复杂度是多少？

`O(1)`

7. 如何防止double-free？

源码中没有提及具体的方法，

8. 如何实现内存统计功能。

最简单的方法是引入bitmap，需要使用元数据来管理，将内容改为下面这样。

```c

struct {
  struct spinlock lock;
  struct run *freelist;
  char* bitmap;
} kmem;
```

在初始化的时候，先统计总的块的数量，然后相应的分配一些空间来给bitmap

```c
void
freerange(void *pa_start, void *pa_end)
{
    char *p;
    p = (char*)PGROUNDUP((uint64)pa_start);

    addr_base = p;

    int cnt = ((char*)pa_end - p + PGSIZE - 1) / PGSIZE;

    printf("内存中一共包含%d个页\n", cnt);
    printf("from 0x%x to 0x%x\n", p, pa_end);
    int meta_sz = (cnt + 8 * PGSIZE - 1) / (8 * PGSIZE);
    printf("%d页的位图空间被分配用于内存管理\n", meta_sz);
    printf("from 0x%x to 0x%x\n", p, p + meta_sz * PGSIZE);
    memset(p, 0, meta_sz * PGSIZE);
    
    p += meta_sz * PGSIZE;
    
    printf("初始化完成\n");
    kmem.bitmap = (char*)addr_base;
    
    memset(kmem.bitmap,0xff, meta_sz * PGSIZE); // 先全部标记为已经使用
    
    for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
        kfree(p);
    }
    printf("初始化完成\n");
}
```

接着，对于`kfree`和`kalloc`在分配的时候加入判断来避免`double_free`

```c


// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;
  if(!list_bit_isset(PAGE_INDEX(pa)))
    panic("kfree: 重复释放内存");

  list_bit_clear(PAGE_INDEX(pa));

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;

  if(r)
    kmem.freelist = r->next;
  release(&kmem.lock);

  list_bit_set(PAGE_INDEX(r));

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
  return (void*)r;
}
```

- 如何检测内存泄漏

反正我写不出来。

- 更高效的分配算法

在`buddy.c`下实现了一个伙伴系统的雏形，但是并没有实际接入。

### Task4

1. 分析 walk() 函数的递归遍历：

   1. 如何从虚拟地址提取各级索引？
      使用了两个宏定义:

      ```c
      PTE2PA(PTE);
      PA2PTE(PA);
      ```

      他们可以实现从PTE中提取对应的物理地址,接着使用递归实现多级页表的查询.

   2. 遇到无效页表项时如何处理？
      对于walk函数,如果遇到了无效的PTE,根据alloc来进行判断,如果`alloc=1`,那么会默认分配一个新的页面,并且实现上一级的PTE指向对应的物理地址.如果为0,那么会直接返回0.

   3. 遇到无效页表项时如何处理？
      如上

2. 研究 mappages() 的映射建立

   1. 如何处理地址对齐？
      强制要求地址对齐,为了实现页式虚拟内存.
   2. 权限位是如何设置的？
      通过函数传入的`int perm`来设置对应的对应的有效状态,并且找到对应的页表项的物理地址后还需要判断地址是否可用.
   3. 映射失败时的清理工作
      哪有什么清理工作,直接panic了


