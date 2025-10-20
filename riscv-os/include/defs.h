
#ifndef DEFS
#define DEFS
struct spinlock;
struct sleeplock;
struct PCB;
struct cpu;
struct context;
struct buf;
struct superblock;
struct inode;
struct file;

// uart.c
void uartinit();
void uart_putc(char c);
void uart_puts(char *s);
void uartputc_sync(int c);

// console.c
void consoleinit(void);
void consputc(int c);

// virtio_disk.c
void virtio_disk_init(void);
void virtio_disk_rw(struct buf *b, int write);
void virtio_disk_intr(void);


// spinlock.c

    // 开关中断
    void push_off(void);
    void pop_off(void);

    // 锁操作
    void initlock(struct spinlock* lk, char* name);
    void acquire(struct spinlock* lk);
    void release(struct spinlock* lk);
    int holding(struct spinlock* lk);

// sleeplock.c
void initsleeplock(struct sleeplock *lk, char *name);
void acquiresleep(struct sleeplock *lk);
void releasesleep(struct sleeplock *lk);
int holdingsleep(struct sleeplock *lk);

// bio.c
void binit(void);
struct buf* bread(int dev, int bnum);
void brelse(struct buf* b);
void bpin(struct buf* b);
void bunpin(struct buf* b);
void bwrite(struct buf* b);

// fs.c
void iinit(void);
void fsinit(int dev);
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n);
int writei(struct inode* ip, int user_dst, uint64 src, uint off, uint n);
void ilock(struct inode* ip);
void iput(struct inode* ip);
void uvmclear(pagetable_t pagetable, uint64 va);
void iunlock(struct inode* ip);
struct inode* namei(char* path);
struct inode* nameiparent(char* path, char* name);
struct inode* idup(struct inode* ip);
struct inode* dirlookup(struct inode *dp, char *name, uint *poff);
struct inode* ialloc(uint dev, short type);
void iupdate(struct inode* ip);
int dirlink(struct inode* dp, char* name, uint inum);
void itrunc(struct inode* ip);


// file.c
void fileinit(void);
void fileclose(struct file* f);
struct file* filedup(struct file* f);
struct file* filealloc(void);
int filewrite(struct file* f, uint64 addr, int n);
int fileread(struct file* f, uint64 addr, int n);


// vm.c
uint64 uVA2PA(pagetable_t pagetable_t, uint64 va);
uint64 vmfault(pagetable_t pagetable, uint64 va, int read);
uint64 uVmAlloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz, int xperm);
int copyin(pagetable_t pagetable, char* dst, uint64 srcva, uint64 len);
int iscow_page(pagetable_t pagetable, uint64 va);
int cowalloc(pagetable_t pagetable, uint64 va);

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
void userinit(void);
struct PCB* myproc(void);
void sleep(void* chan, struct spinlock* lk);
void wakeup(void* chan);
void sched(void);
int either_copyout(int user_dst, uint64 dst, void* src, uint64 len);
int either_copyin(void* dst, int user_src, uint64 src, uint64 len);
pagetable_t procPagetable(struct PCB* p);
int copyout(pagetable_t p, uint64 va, void* src, uint64 len);
int copyinstr(pagetable_t pagetable, char* dst, uint64 srcva, uint64 max);
void uFreeUserVM(pagetable_t pagetable, uint64 sz);
void  prepare_return();
int killed(struct PCB *p);
void setkilled(struct PCB *p);
int kkill(int pid);
void kexit(int status);
int kwait(uint64 addr);
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz);
int kfork(void);
int set_priority(int pid, int priority);

// exec.c
// SHIT
int kexec(char* path, char ** argv);

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
void refcnt_inc(void* pa);
int get_refcnt(void* pa);

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
void* memmove(void* dst, const void * src, uint n);
int memcmp(const void *v1, const void *v2, uint n);
int strncmp(const char *p, const char *q, uint n);
int strlen(const char *s);
char* safestrcpy(char *s, const char *t, int n);

// log.c
void initlog(int dev, struct superblock* sb);
void begin_op();
void end_op();
void log_write(struct buf* b);

// syscall.c
void syscall(void);
void argint(int n, int *p);
void argaddr(int n, uint64 *p); 
int argstr(int n, char *buf, int max);
int fetchstr(uint64 addr, char *buf, int max);
int fetchaddr(uint64 addr, uint64 *ip);

// sysproc.c
uint64 sys_exit(void);
uint64 sys_wait(void);
uint64 sys_fork(void);
uint64 sys_exec(void);
uint64 sys_getpid(void);
uint64 sys_uptime(void);
uint64 sys_set_priority(void);

// sysfile.c
uint64 sys_mknod(void);
uint64 sys_open(void);
uint64 sys_dup(void);
uint64 sys_write(void);
uint64 sys_read(void);
uint64 sys_close(void);
uint64 sys_unlink(void);

// number of elements in fixed-size array
#define NELEM(x) (sizeof(x)/sizeof((x)[0]))


#endif