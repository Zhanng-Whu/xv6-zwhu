# 第七讲 文件系统

实现文件系统的全部接口.

## 逻辑梳理

```c

    binit();         // buffer cache
    iinit();         // inode table
    fileinit();      // file table
    virtio_disk_init(); // emulated hard disk
```

以及`initproc`的初始化的启动文件系统:

```c
    fsinit(ROOTDEV);
```

接下来一个一个看是如何实现的

### 文件系统回忆

- `block` **块**是文件系统与磁盘进行I/O操作的**最小单位**。操作系统最终都必须以“块”为单位来读取或写入整个数据块。在xv6中，一个块的大小通常是1KB.
- `index node`, 存储有一个文件的所有元数据,除文件名之外.
- `buffer cache`, 块缓冲区,它的核心作用是缓存（Cache来自磁盘（Disk的数据块（Block)，以减少缓慢的磁盘I/O次数

### buffercache

`xv6`的内存缓冲管理是基于`LRU`(最近最少使用)算法进行管理(我没有看出来,这里的功能很明显是非抢占式的).下面这一段最关键的一句,一个缓冲区同时只能被一个进程占用

> The buffer cache is a linked list of buf structures holding
> cached copies of disk block contents.  Caching disk blocks
> in memory reduces the number of disk reads and also provides
> a synchronization point for disk blocks used by multiple processes.
>
> Interface:
> * To get a buffer for a particular disk block, call bread.
> * After changing buffer data, call bwrite to write it to disk.
> * When done with the buffer, call brelse.
> * Do not use the buffer after calling brelse.
> * Only one process at a time can use a buffer,so do not keep them longer than necessary.

```c
struct buf {
  int valid;   // has data been read from disk?
  int disk;    // does disk "own" buf?
  uint dev;
  uint blockno;
  struct sleeplock lock;
  uint refcnt;
  struct buf *prev; // LRU cache list
  struct buf *next;
  uchar data[BSIZE];
};


struct {
  struct spinlock lock;
  struct buf buf[NBUF];

  // Linked list of all buffers, through prev/next.
  // Sorted by how recently the buffer was used.
  // head.next is most recent, head.prev is least.
  struct buf head;
} bcache;

void
binit(void)
{
  struct buf *b;

  initlock(&bcache.lock, "bcache");

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
```

首先第一个,`buf` 代表内存中的一个磁盘块的拷贝, 内容如下:

```c
struct buf {
  int valid;      // 数据是否已从磁盘读入？
  int disk;       // 磁盘是否“拥有”此缓冲（即正在读写）？
  uint dev;         // 设备号
  uint blockno;     // 块号
  struct sleeplock lock; // 保护单个缓冲区的睡眠锁
  uint refcnt;      // 引用计数：有多少个进程在用它？
  struct buf *prev; // LRU 链表的前一个指针
  struct buf *next; // LRU 链表的后一个指针
  uchar data[BSIZE]; // 存放块数据的内存区域 (例如4KB)
};
```

这里介绍一下睡眠锁:

```c
// Long-term locks for processes
struct sleeplock {
  uint locked;       // Is the lock held?
  struct spinlock lk; // spinlock protecting this sleep lock
  
  // For debugging:
  char *name;        // Name of lock.
  int pid;           // Process holding lock
};

```

当一个进程尝试获取一个已经被占用的睡眠锁的时候,他会调用`sleep()`函数,并且把自己的状态设置为`SLEEPING`,同时主动让出CPU.

```c

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
}
```

这里看到`sleep()`函数:

```c

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  // Must acquire p->lock in order to
  // change p->state and then call sched.
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
  release(lk);

  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  release(&p->lock);
  acquire(lk);
}
```

原理很好理解,就是这里别忘了进程调度之前这个进程是需要上锁的,他会在`sched()`里面判断,然后在`scheduler`里面释放这个锁.

然后看到这里的释放的函数:

```c

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
        p->state = RUNNABLE;
      }
      release(&p->lock);
    }
  }
}
```



由于磁盘IO的特殊性(特别慢),所以这里通过睡眠锁来实现,避免长时间的中断.

接着,使用一个数据结构管理整个缓冲区:

```c
struct {
  struct spinlock lock; // 保护 bcache 结构的锁
  struct buf buf[NBUF]; // NBUF 个缓冲区实体
  struct buf head;      // 链表的头节点,一般不包含任何内容
} bcache;
```

其中`NBUF`的内容是:

```c
#define MAXOPBLOCKS  10  // max # of blocks any FS op writes
#define NBUF         (MAXOPBLOCKS*3)  // size of disk block cache
```

```c

void
binit(void)
{
  struct buf *b;

  initlock(&bcache.lock, "bcache");

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
```

这一段就是把整个缓冲区串联起来,显而易见这里的缓冲区使用循环双链表进行管理.

接着看到这里的各个函数:

- `bget(dev, blockno)` - 获取缓冲区,根据`dev`和`blockno`来查找块,如果没有找到这个块,根据LRU的规则选择一个合适的块准备给上层调用进行替换.

    ```c
    
    // Look through buffer cache for block on device dev.
    // If not found, allocate a buffer.
    // In either case, return locked buffer.
    static struct buf*
    bget(uint dev, uint blockno)
    {
      struct buf *b;
    
      acquire(&bcache.lock);
    
      // Is the block already cached?
      for(b = bcache.head.next; b != &bcache.head; b = b->next){
        if(b->dev == dev && b->blockno == blockno){
          b->refcnt++;
          release(&bcache.lock);
          acquiresleep(&b->lock);
          return b;
        }
      }
    
      // Not cached.
      // Recycle the least recently used (LRU) unused buffer.
      for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
        if(b->refcnt == 0) {
          b->dev = dev;
          b->blockno = blockno;
          b->valid = 0;
          b->refcnt = 1;
          release(&bcache.lock);
          acquiresleep(&b->lock);
          return b;
        }
      }
      panic("bget: no buffers");
    }
    ```

    这里注意上锁的逻辑和没有命中缓存后的`b->refcnt`+1(因为他马上就要被用了)

- `bread(dev, blockno)` - 读取块

    ```c
    // Return a locked buf with the contents of the indicated block.
    struct buf*
    bread(uint dev, uint blockno)
    {
      struct buf *b;
    
      b = bget(dev, blockno);
      if(!b->valid) {
        virtio_disk_rw(b, 0);
        b->valid = 1;
      }
      return b;
    }
    ```

    很简单,这里的`virtio_disk_rw`的第二个参数决定了是写还是读.

- `bwrite(struct buf *b)` - 写回

    ```c
    // Write b's contents to disk.  Must be locked.
    void
    bwrite(struct buf *b)
    {
      if(!holdingsleep(&b->lock))
        panic("bwrite");
      virtio_disk_rw(b, 1);
    }
    ```

- `brelse(struct buf *b)` - 释放缓冲区

    ```c
    // Move to the head of the most-recently-used list.
    void
    brelse(struct buf *b)
    {
      if(!holdingsleep(&b->lock))
        panic("brelse");
    
      releasesleep(&b->lock);
    
      acquire(&bcache.lock);
      b->refcnt--;
      if (b->refcnt == 0) {
        // no one is waiting for it.
        b->next->prev = b->prev;
        b->prev->next = b->next;
        b->next = bcache.head.next;
        b->prev = &bcache.head;
        bcache.head.next->prev = b;
        bcache.head.next = b;
      }
      
      release(&bcache.lock);
    }
    ```
- bpin(struct buf *b) / bunpin(struct buf *b) - 锁定/解锁缓冲区
  

### inode table

在OS中,每一个文件对应一个inode,OS会将Inode从磁盘中载入到内存中暂存.

> 一个 `inode` 描述一个**未命名**的独立文件。
>
> 磁盘上的 `inode` 结构体保存了文件的**元数据（metadata）**：文件类型、文件大小、指向此文件的链接（文件名）数量，以及存放文件内容的数据块列表。
>
> 所有的 `inode` 都连续地存放在磁盘上，起始于超级块（superblock）中 `sb.inodestart` 指定的块号。每个 `inode` 都有一个编号，代表它在磁盘上的位置。
>
> 内核在内存中维护一个**正在使用的 `inode` 表（即 `icache`）**，为多个进程对同一个 `inode` 的并发访问提供一个同步点。内存中的 `inode` 包含一些**不会存回磁盘**的簿记信息：`ip->ref`（引用计数）和 `ip->valid`（有效位）。
>
> 一个 `inode` 及其在内存中的表示，在能被文件系统其他代码使用之前，会经历一系列的状态。
>
> - **分配 (Allocation)**: 如果一个磁盘上的 `inode` 的类型（type）字段非零，那么它就是已分配状态。`ialloc()` 负责分配一个新的 `inode`，而 `iput()` 会在引用计数和链接计数都降为零时，释放这个 `inode`。
> - **在表中被引用 (Referencing in table)**: 如果一个内存 `inode` 表条目的 `ip->ref` 为零，则该条目是空闲的。否则，`ip->ref` 会追踪内存中有多少个指针指向这个条目（例如，打开的文件和当前工作目录）。`iget()` 负责查找或创建一个表条目并增加其 `ref` 计数；`iput()` 则会减少 `ref` 计数。
> - **有效 (Valid)**: 仅当一个内存 `inode` 条目的 `ip->valid` 为1时，它里面的信息（type, size等）才是正确的（即与磁盘同步）。`ilock()` 会从磁盘读取 `inode` 内容并设置 `ip->valid`，而 `iput()` 会在 `ip->ref` 降为零时清除 `ip->valid`。
> - **锁定 (Locked)**: 文件系统代码只有在**首先锁定了 `inode`** 的情况下，才能检查和修改 `inode` 及其内容中的信息。
>
> 因此，一个典型的操作序列是：
>
> ```c
> ip = iget(dev, inum)  // 获取一个内存中的 inode 引用
> ilock(ip)             // 锁定它，并从磁盘读取内容
> ... 检查和修改 ip->xxx ...
> iunlock(ip)           // 解锁
> iput(ip)              // 释放对它的引用
> ```
>
> `ilock()` 与 `iget()` 是分开的，这样系统调用可以**长期持有一个 `inode` 的引用**（例如，一个打开的文件），但只在**很短的时间内锁定它**（例如，在 `read()` 操作期间）。这种分离的设计也有助于在路径名查找期间避免死锁和竞赛条件。`iget()` 会增加 `ip->ref`，以确保 `inode` 停留在内存表中，使得指向它的指针保持有效。
>
> 许多内部的文件系统函数都期望调用者已经锁定了它们所涉及的 `inode`；这使得调用者可以创建多步骤的原子操作。
>
> `itable.lock` 这个**自旋锁**，保护的是对 `itable`（即`icache`）中条目的分配过程。因为 `ip->ref` 决定了一个条目是否空闲，而 `ip->dev` 和 `ip->inum` 决定了一个条目对应哪个磁盘 `inode`，所以在访问这些字段时，必须持有 `itable.lock`。
>
> 每个 `inode` 自己的 `ip->lock` 这个**睡眠锁**，则保护了除 `ref`, `dev`, `inum` 之外的所有 `ip->` 字段。你必须持有 `ip->lock` 才能读写该 `inode` 的 `ip->valid`, `ip->size`, `ip->type` 等等。



```c
struct {
  struct spinlock lock;
  struct inode inode[NINODE];
} itable;


void
iinit()
{
  int i = 0;
  
  initlock(&itable.lock, "itable");
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&itable.inode[i].lock, "inode");
  }
}
```

而inode的内容大致分为两个部分,会被写回硬盘的和不会被写回硬盘的管理信息

```c
// in-memory copy of an inode
struct inode {
  uint dev;           // Device number
  uint inum;          // Inode number
  int ref;            // Reference count
  struct sleeplock lock; // protects everything below here
  int valid;          // inode has been read from disk?

  short type;         // copy of disk inode
  short major;
  short minor;
  short nlink;
  uint size;
  uint addrs[NDIRECT+1];
};
```

上面的`In-Memory Bookkeeping`很好理解

下面的第一个`type`分为有三种种类:

```c
#define T_DIR     1   // Directory
#define T_FILE    2   // File
#define T_DEVICE  3   // Device

```

接着是主次设备号,只有当文件是设备的时候他们才有意义.

然后是硬链接数量,只有这个归零才会真正释放Inode的空间

最后是文件大小和数据指针,这里的数据指针是一个混合指针:

**`NDIRECT`**: **直接指针**。数组的前 `NDIRECT` 个（例如12个）元素，直接存储了文件前12个数据块的磁盘地址。

**`+1` (间接指针)**: 数组的最后一个元素是一个**一级间接指针**。它指向的不是一个数据块，而是**另一个磁盘块**。这个“间接块”本身不存储文件内容，而是存储了**另外一批数据块的地址**。通过这种方式，xv6可以支持比直接指针能表示的更大尺寸的文件。

处理这里的`inode`结构体,还有一个`dnode`结构体,表示inode存储在磁盘中的格式,也就是你可以直接用指针赋值的方法将磁盘的内容按照dnode的格式解读.

```c
// On-disk inode structure
struct dinode {
  short type;           // File type
  short major;          // Major device number (T_DEVICE only)
  short minor;          // Minor device number (T_DEVICE only)
  short nlink;          // Number of links to inode in file system
  uint size;            // Size of file (bytes)
  uint addrs[NDIRECT+1];   // Data block addresses
};
```

接下来看到文件系统里面最关键的几个函数.

```c
struct inode* iget(uint dev, uint inum);
void iput(struct inode *ip);
```

获取和释放内存中的`inode`的引用.

### File table

```c
struct file {
  enum { FD_NONE, FD_PIPE, FD_INODE, FD_DEVICE } type;
  int ref; // reference count
  char readable;
  char writable;
  struct pipe *pipe; // FD_PIPE
  struct inode *ip;  // FD_INODE and FD_DEVICE
  uint off;          // FD_INODE
  short major;       // FD_DEVICE
};
```

这里是`file`的结构体,两者有一个重要的区别,就是`inode`是缓存的生命周期,当 `inode->ref` 降为0时，说明这个 `inode` 在内存中已不再被需要，`icache` 可以回收这个位置用于缓存其他 `inode`。而对于`file`的结构体,他是打开文件的生命周期,由系统的打开文件表维护.

对于`file` 他的引用是针对文件描述符而言的. 而`inode`的生命周期包含硬盘上的和内存中的两个部分, 对内存中的, 各种计数都会影响到`inode`的`ref`计数.

对于一个文件指针,他会将文件分为下面的几类:

- `FD_NONE`: 表示这个 `struct file` 条目是空的，可以使用。

- `FD_PIPE`: 表示这是一个**管道**。应通过下面的 `pipe` 指针来访问它。

- `FD_INODE`: 表示这是一个磁盘上的**普通文件或目录**。应通过下面的 `ip` (inode) 指针来访问它。

- `FD_DEVICE`: 表示这是一个**设备文件**（如控制台）。应通过 `ip` 和 `major` 字段来处理。

`struct pipe *pipe;`是一个指向管道的结构体,仅当 `type == FD_PIPE` 时，这个指针才有效。

`struct inode *ip;` 当 `type == FD_INODE` 或 `type == FD_DEVICE` 时有效。它将这个“打开文件”的会话，与文件在磁盘上的**元数据（inode）**关联起来。

`uint off;`仅当 `type == FD_INODE`（即普通文件）时有效。它记录了下一次 `read` 或 `write` 应该开始的位置。

`short major;`仅当 `type == FD_DEVICE` 时有效。它用作 `devsw` 设备开关表的索引，以找到该设备对应的驱动程序（的 `read` 和 `write` 函数）。

### 硬盘驱动

这一块没有要求,内容也比较繁琐,所以我们只需要关系接口就行了

```c
void virtio_disk_init(void); // 初始化函数
```

然后是接口函数:

```c
void virtio_disk_rw(struct buf *b, int write); 
```

**发起一次磁盘块的读取或写入操作**。这是该驱动**最核心、最常用**的接口。由`bread()`和`bwrite()`发起.`struct buf *b`: 一个指向缓冲区的指针。这个结构体里包含了所有必要信息：`b->blockno`: 要操作的**块号**。`b->data`: 对于写操作，这里是**源数据**；对于读操作，这里是用于存放结果的**目标内存地址**。

由于文件系统读取缓慢,这个函数的实现是异步的,会在读取过程中`sleep`,等待读取完成后会发生中断处理,使用`wakeup`唤醒沉睡的进程.



### 文件系统初始化

```c
void
forkret(void)
{
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();

  // Still holding p->lock from scheduler.
  release(&p->lock);

  if (first) {
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
```

这里的`ROOTDEV`就是`fs.img`磁盘,这里在第一个进程内初始化磁盘的文件目录.

```c

// Init fs
void
fsinit(int dev) {
  readsb(dev, &sb);
  if(sb.magic != FSMAGIC)
    panic("invalid file system");
  initlog(dev, &sb);
  ireclaim(dev);
}
```

这里首先需要读取超级块

```c
// Read the super block.
static void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
}

```

一般的sb是存在dev的一号block.实际上, `fs.img`的结构如下:

```c
// Disk layout:
// [ boot block | super block | log | inode blocks | free bit map | data blocks]
//
// mkfs computes the super block and builds an initial file system. 
```

这里不需要关系为什么`sb`的结构是在哪里规定的(`mkfs.c`里面), 重点关心一下sb的结构:

```c
// super block describes the disk layout:
struct superblock {
  uint magic;        // Must be FSMAGIC
  uint size;         // Size of file system image (blocks)
  uint nblocks;      // Number of data blocks
  uint ninodes;      // Number of inodes.
  uint nlog;         // Number of log blocks
  uint logstart;     // Block number of first log block
  uint inodestart;   // Block number of first inode block
  uint bmapstart;    // Block number of first free map block
};
```

接着需要初始化一下日志系统,这里的日志系统保证了在调用`begin_op`后会先在内存中的日志区域中写下预想的行为(比如写入块), 等到调用`end_op`后再一次全部写完.

> 一个允许并发文件系统调用的简单日志系统。
>
> 一次日志事务（transaction）可以包含多次文件系统调用的更新内容。日志系统仅在没有任何文件系统调用处于活动状态时，才会进行提交（commit）。因此，永远无需去推断一次提交是否可能会将一个尚未完成的系统调用的更新写入磁盘。
> （这是一种非常简化的设计，保证了事务的完整性）
>
> 一个系统调用应该调用 begin_op()/end_op() 来标记其自身的开始和结束。通常情况下，begin_op() 只是简单地将“正在进行的文件系统调用”的计数器加一然后返回。但如果它认为日志空间即将耗尽，它就会进入睡眠，直到最后一个未完成的 end_op() 执行了提交操作。
>
> 本日志是一个包含完整磁盘块的物理“重做”日志（physical re-do log）。磁盘上的日志格式如下：
>   头块（header block），包含了块A, B, C...的块号
>   数据块 A 的内容
>   数据块 B 的内容
>   数据块 C 的内容
>   ...
> 日志的追加写入是同步的。头块的内容，既用于磁盘上的头块结构，也用于在提交（commit）之前，在内存中追踪已被记入日志的块号。

就是说,`begin_op`是一个计数器,如果你开始文件操作了,就把它加一.`end_op`会对这个计数器-1, 如果发现他是最后一个, 那么直接开始写入即可. 这个做法保证了不会出现写入一半的情况.

日志系统包含两种块,一种是头块,记录写回的数量和块号,另一种是数据块,是要写回的数据的完全复制.

```c
struct logheader {
  int n;
  int block[LOGBLOCKS];
};

struct log {
  struct spinlock lock;
  int start;
  int outstanding; // how many FS sys calls are executing.
  int committing;  // in commit(), please wait.
  int dev;
  struct logheader lh;
};

void
initlog(int dev, struct superblock *sb)
{
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  initlock(&log.lock, "log");
  log.start = sb->logstart;
  log.dev = dev;
  recover_from_log();
}
```

这里都很好理解,看看这个恢复函数是什么

```c

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
}

// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
  brelse(buf);
}

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
  log.lh.n = 0;
  write_head(); // clear the log
}

```

前面提到过,日志文件的一大作用就是在系统崩溃后能够恢复,所以在启动后就需要马上重新从硬盘重新读取之前写入的内容,判断是不是有中断的工作.如果有的话, 那么继续执行上一次执行到一半的工作.

```c
// Copy committed blocks from log to their home location
static void
install_trans(int recovering)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    if(recovering) {
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    }
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    if(recovering == 0)
      bunpin(dbuf);
    brelse(lbuf);
    brelse(dbuf);
  }
}
```

这里的`recoverying`是用来判断当前是否是恢复状态, 在正常情况下,为了防止意外回收,可能把这里的数据块订住, 而恢复模式下则没有这个限制.

在完成这个过程后,就需要把头重新写回磁盘,由此完成了日志系统的初始化.

这里还可以看一下`begin_op()`的实现:

```c
// called at the start of each FS system call.
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
      break;
    }
  }
}


// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
```

`begin_op`的逻辑很简单,就是先判断是否提交或者有缓冲区溢出的风险,如果有的话那么休眠,否则计数+1.

`end_op()`就是判断当前的进程是否是目前的最后一个关闭提交的,如果不是那么唤醒所有的沉睡的进程,否则会设置提交的参数,然后开始提交.

```c
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    install_trans(0); // Now install writes to home locations
    log.lh.n = 0;
    write_head();    // Erase the transaction from the log
  }
}
```

```c
// Copy modified blocks from cache to log.
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from);
    brelse(to);
  }
}
```

首先他会先读取内存中的暂存的数据,然后将它写到硬盘的一块中,接着返回回来释放内存中的块.

然后他会写入日志头,由此就完成了一次硬盘的保存.

接下来他会开始正式的写入,在写入完成后清零,最后再写回日志头.

第二个是`ireclaim()`,他的作用是回收磁盘上的所有无用的`inode`

```c

void
ireclaim(int dev)
{
  for (int inum = 1; inum < sb.ninodes; inum++) {
    struct inode *ip = 0;
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
      printf("ireclaim: orphaned inode %d\n", inum);
      ip = iget(dev, inum);
    }
    brelse(bp);
    if (ip) {
      begin_op();
      ilock(ip);
      iunlock(ip);
      iput(ip);
      end_op();
    }
  }
}
```

这里的`IPB`是一个块里面能存储多少个`inode`

```c
// Inodes per block.
#define IPB           (BSIZE / sizeof(struct dinode))

// Block containing inode i
#define IBLOCK(i, sb)     ((i) / IPB + sb.inodestart)
```

这里表示的是第i个inode对应的`block`

`dinode`是磁盘上的inode的存储格式,可以通过指针操作直接读取:

```c
// On-disk inode structure
struct dinode {
  short type;           // File type
  short major;          // Major device number (T_DEVICE only)
  short minor;          // Minor device number (T_DEVICE only)
  short nlink;          // Number of links to inode in file system
  uint size;            // Size of file (bytes)
  uint addrs[NDIRECT+1];   // Data block addresses
};
```

```c
if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
      printf("ireclaim: orphaned inode %d\n", inum);
      ip = iget(dev, inum);
    }
```

这里表示识别到这个`inode`在被使用,但是没有指针指向他,所以这里就直接删除他就可以.

```c

// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
  struct inode *ip, *empty;

  acquire(&itable.lock);

  // Is the inode already in the table?
  empty = 0;
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&itable.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&itable.lock);

  return ip;
}
```

首先他会在内存中轮询,查询内存中是否有需要的`inode`,同时这个过程中记录第一个遇到的无用的inode,如果在内存中,没有找到,那么就把这个无用的`inode`拿过来使用,准备拿来存储新的inode.

接着,他会调用`ilock`这个函数,他的功能是如果这个`inode`块无效,那么会从硬盘中读取对应的`inode`数据存入其中,然后调用`iunlock`释放这个块的所有权,最后直接调用`iput`释放这个块,这个过程中,由于`inode`的内存引用为0, 所以他会直接被写回硬盘,但是前面我们的判断条件中,发现他的硬链接也是0,所以这一个`inode`在磁盘上被彻底释放,变成`free`的.

```c
// Drop a reference to an in-memory inode.
// If that was the last reference, the inode table entry can
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
  acquire(&itable.lock);

  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    // inode has no links and no other references: truncate and free.

    // ip->ref == 1 means no other process can have ip locked,
    // so this acquiresleep() won't block (or deadlock).
    acquiresleep(&ip->lock);

    release(&itable.lock);

    itrunc(ip);
    ip->type = 0;
    iupdate(ip);
    ip->valid = 0;

    releasesleep(&ip->lock);

    acquire(&itable.lock);
  }

  ip->ref--;
  release(&itable.lock);
}
```





## Open() Write()示例

接下来通过`Open()`, `Write()`这一条路径展示一下文件系统操作的一条路径.

系统调用前的路径在[阅读第5章](chapter5&6.md)有提到,这里直接到`sys_open()`这一步开始

```c
int open(char *path, int flags);
```

> **xv6中常见的主要标志 (定义在 `fcntl.h` 中)**:
>
> **A. 访问模式 (Access Modes) - 三选一**:
>
> - **`O_RDONLY` (Read-Only)**: 只读模式。表示你只会从这个文件读取数据。
> - **`O_WRONLY` (Write-Only)**: 只写模式。表示你只会向这个文件写入数据。
> - **`O_RDWR` (Read-Write)**: 读写模式。表示你既要读也要写。
>
> **B. 创建标志 (Creation Flags) - 可选组合**:
>
> - **`O_CREATE`**: **创建文件**。如果 `path` 指定的文件**不存在**，内核会自动为你创建一个新的空文件。如果文件已存在，则此标志无效果。
> - **`O_TRUNC`**: **截断文件 (Truncate)**。如果文件已存在，并且是以**可写模式**（`O_WRONLY` 或 `O_RDWR`）打开的，那么内核会**清空**该文件的所有内容，使其大小变为0。



```c
uint64
sys_open(void)
{
  char path[MAXPATH];
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
  if((n = argstr(0, path, MAXPATH)) < 0)
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
      iunlockput(ip);
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    f->off = 0;
  }
  f->ip = ip;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);

  if((omode & O_TRUNC) && ip->type == T_FILE){
    itrunc(ip);
  }

  iunlock(ip);
  end_op();

  return fd;
}
```

最前面的是参数准备,没什么好说的.

```c
void begin_op();
```

这一句表示开始文件操作

然后就是一个`if-else`

```c
 if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
      iunlockput(ip);
      end_op();
      return -1;
    }
  }
```

这一段的逻辑是:

1. 如果创建访问里面有创建的权限,那么直接创建
2. 如果没有,那么查找有没有这个文件,
3. 如果没有或者创建失败,那么直接返回,
4. 上文件锁
5. 如果文件为文件夹并且文件是只读的,那么直接返回

这里涉及到两个函数,`namei()`和`create`

先来看`create`函数的参数:

```c
create(path, File_TYPE, major, minor);
```

1. 首先会沿着`path`查找当前文件的路径
2. 如果文件已经存在,那么会直接返回文件`inode`
3. 如果文件不存在,`create`会在目录中创建一个新的`inode`并且在目录中添加一个指向inode的条目,然后返回这个新创建的inode
4. 如果`create`创建失败,就会直接返回0,

函数功能如下:

```c

static struct inode*
create(char *path, short type, short major, short minor)
{
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;

  ilock(dp);

  if((ip = dirlookup(dp, name, 0)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0){
    iunlockput(dp);
    return 0;
  }

  ilock(ip);
  ip->major = major;
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      goto fail;
  }

  if(dirlink(dp, name, ip->inum) < 0)
    goto fail;

  if(type == T_DIR){
    // now that success is guaranteed:
    dp->nlink++;  // for ".."
    iupdate(dp);
  }

  iunlockput(dp);

  return ip;

 fail:
  // something went wrong. de-allocate ip.
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
```

首先是获取文件的父目录的`inode`

这里的dp就是`dir`

```c
if((dp = nameiparent(path, name)) == 0)
  return 0;
ilock(dp);
```

这里的`namei`和`nameiparent`是文件系统里面的两个重要的接口函数

```c

// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}

struct inode*
namei(char *path)
{
  char name[DIRSIZ];
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
}
```

- `namei`根据文件路径直接返回对应的文件的`inode`
- `nameiparent`返回文件的父目录的`inode`并且把最后的文件名拷贝到`name`这个缓冲区里面

```c
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

```

首先是对路径进行处理,如果是根目录,将当前的`inode`设置为根目录,否则设置为当前`inode`的目录:`cwd`也就是`current_directory`

接着对路径开始递归处理:

```c

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
```

这里的`skipelem`是一个辅助函数,负责将下一段路径赋值给`path`并且将下一段路径设置拷贝到name中,比如对于

```c
char path[] = "/a/b/c/d";
```

那么会把a拷贝进name,同时将"b/c/d"赋值给path.

> // Examples:
> //   skipelem("a/bb/c", name) = "bb/c", setting name = "a"
> //   skipelem("///a//bb", name) = "bb", setting name = "a"
> //   skipelem("a", name) = "", setting name = "a"
> //   skipelem("", name) = skipelem("////", name) = 0
> //

```c
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
    }
```

这一段是递归调用,在当前的目录下查找名为`name`的文件,如果文件深度不够用,那么直接失败

```c
// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
      // entry matches path element
      if(poff)
        *poff = off;
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
```

这里的逻辑很简单,就是遍历当前文件夹下的所有文件,查找当前文件夹下的所有文件,逐个比对文件名称,找到了就直接返回对应的`inode`块

注意,在目录中,文件其实可以理解为一个指向`inode`的指针,存储有文件的名称,inode号等等内容,这里就是存储在`struct dirent `

```c
struct dirent {
  ushort inum;
  char name[DIRSIZ] __attribute__((nonstring));
};
```

这里的readi是一个重要函数,表示从`inode`的位置读取数据

```c
int
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    return 0;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
  }
  return tot;
}
```

他的参数有5个 含义如下:

- `struct inode* ip`表示从ip的位置读取数据
- `user_dst`, 表示目标地址是属于用户地址还是内核地址
- `dst`内存地址
- `off`表示读取的偏移
- `n`表示读取的字节数

对于不同的权限,会使用不同的复制方法,如果是内核空间,那直接使用`memove`实现高效复制即可,但是对于用户空间,需要使用`copyout`实现页表的按页映射,这里使用的就是虚拟地址了,从`char* src`赋值`len`字节的数据到`dstva`的用户页表空间

```c
// Copy from kernel to user.
// Copy len bytes from src to virtual address dstva in a given page table.
// Return 0 on success, -1 on error.
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len){
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    va0 = PGROUNDDOWN(dstva);
    if(va0 >= MAXVA)
      return -1;
  
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0) {
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
        return -1;
      }
    }

    pte = walk(pagetable, va0, 0);
    // forbid copyout over read-only user text pages.
    if((*pte & PTE_W) == 0)
      return -1;
      
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);

    len -= n;
    src += n;
    dstva = va0 + PGSIZE;
  }
  return 0;
}
```

终于找到了对应的目录后,查找这个目录下的所有文件,如果文件存在,那么直接返回就行,否则就分配一个`inode`

```c

// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode,
// or NULL if there is no free inode.
struct inode*
ialloc(uint dev, short type)
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  printf("ialloc: no inodes\n");
  return 0;
}
```



```c

  if(type == T_DIR){  // Create . and .. entries.
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      goto fail;
  }
```

如果你要创建的文件是文件夹,那么这里需要使用`dirlink`这个函数来实现映射:

```c
int
dirlink(struct inode *dp, char *name, uint inum);
```

这个函数的功能是在`dp`这个文件中,将`name`这个文件名和`inum`这个文件联系起来,

```c

// Write a new directory entry (name, inum) into the directory dp.
// Returns 0 on success, -1 on failure (e.g. out of disk blocks).
int
dirlink(struct inode *dp, char *name, uint inum)
{
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    return -1;

  return 0;
}
```

为了尽可能避免改变目录文件的大小,这里会尽可能查找有没有空闲的目录项.如果没有找到,则需要在文件末尾写入一个新的表项

这里看到`writei`函数

```c
// Write data to inode.
// Caller must hold ip->lock.
// If user_src==1, then src is a user virtual address;
// otherwise, src is a kernel address.
// Returns the number of bytes successfully written.
// If the return value is less than the requested n,
// there was an error of some kind.
int
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
      brelse(bp);
      break;
    }
    log_write(bp);
    brelse(bp);
  }

  if(off > ip->size)
    ip->size = off;

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);

  return tot;
}

```

这里的`bmap`的功能是将一个文件内部的逻辑块号转换为他的物理地址,如果这个块的逻辑地址尚未分派,`bmap`还会生成一个新的物理块.

