
#ifndef DEFS
#define DEFS
struct spinlock;
struct PCB;
struct cpu;
struct context;


// uart.c
void uartinit();
void uart_putc(char c);
void uart_puts(char *s);
void uartputc_sync(int c);

// console.c
void consoleinit(void);
void consputc(int c);


// spinlock.c

    // 开关中断
    void push_off(void);
    void pop_off(void);

    // 锁操作
    void initlock(struct spinlock* lk, char* name);
    void acquire(struct spinlock* lk);
    void release(struct spinlock* lk);

    int holding(struct spinlock* lk);



// vm.c

// 内核内存分配的辅助函数, 功能是实现从虚拟地址到物理地址的映射,并且根据perm设置页表项的权限
// 是基于mapPages实现 但是要求不允许分配失败
void kVmMap(pagetable_t kpgtbl, uint64 va, uint64 pa, uint64 sz, int perm);

//分配从内存空间到内核物理地址的映射 
int mapPages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm);

// 输出整个页表的内容
void printPgtbl(pagetable_t pagetable, int level, int to_level);

// 启动内存的分页机制
void kVmInitHart(void);

// 内核虚拟内存的初始化函数
void kVmInit(void);

// 初始化一个用户虚拟内存页表
pagetable_t uVmCreate(void);

// 释放整个用户的虚拟内存空间
void uVmFree(pagetable_t pagetable, uint64 sz);

pte_t* walk(pagetable_t pagetable, uint64 va, int alloc);
void freePgtbl(pagetable_t pagetable);
pagetable_t uVmCreate(void);
void uVmFree(pagetable_t pagetable, uint64 sz);
void uVmUnmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free); 

void kVmMap(pagetable_t kpgtbl, uint64 va, uint64 pa, uint64 sz, int perm);

// proc.c
int cpuid();
struct cpu* mycpu(void);
void proc_mapstacks(pagetable_t kpgtbl);
void procinit(void);
void yield(void);




// printf.c
void panic(char *s);
void printfinit(void);
int printf(char* fmt, ...);
int printf_color(int color, char *fmt, ...);   
void clear_screen(void);
void goto_xy(int x, int y);



// kalloc.c 
void kinit(void);
void kfree(void*);
void* kalloc(void);

// buddy.c
struct list{
    struct list * next;
    struct list * prev;
};
void bd_init(void* start, void* end);


// trap.c
void trapInit(void);            // 中断 软件初始化
void trapInitHart(void);        // 中断 硬件初始化 主要是在寄存器中设置中断向量
void scheduler(void);           // 调度器

// swtch.S
void swtch(struct context* old, struct context* new);  


// plic.c
void plicInit(void);
void plicInitHart(void);
void registerDev(int irq, int priority);
void unregisterDev(int irq);
void enableDev(int irq);
void disableDev(int irq);
int plicClaim(void);
void plicComplete(int irq);

// list.c
void lst_init(struct list*);
void lst_remove(struct list*);
void lst_push(struct list*, void *);
void *lst_pop(struct list*);
void lst_print(struct list*);
int lst_empty(struct list*);


// math.c
int log2(uint64 x);

// string.c
void* memset(void *dst, int c, uint n);

#endif