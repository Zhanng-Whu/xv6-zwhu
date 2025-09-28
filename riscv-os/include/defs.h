
#ifndef DEFS
#define DEFS
struct spinlock;


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



// vm.c

void kvmmap(pagetable_t kpgtbl, uint64 va, uint64 pa, uint64 sz, int perm);
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm);
void print_pgtbl(pagetable_t pagetable, int level, int to_level);
void kvminithart(void);
void kvminit(void);


// proc.c
struct cpu* mycpu(void);
void proc_mapstacks(pagetable_t kpgtbl);

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