# 第二章：内核printf与清屏功能实现

本章思路：通过初始化来数理，从上向下逐层解读，然后从底层向上逐步实现。

c

## 通过初始化来梳理逻辑

首先来看一下`printf`是如何初始化的：

1.  首先，先初始化console。

```c
void
consoleinit(void)
{
  initlock(&cons.lock, "cons");

  uartinit();

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
  devsw[CONSOLE].write = consolewrite;
}
```

在`consoleinit()`中初始化了串口，接着设置了一个特殊的结构体`devsw`，他的定义如下：

```c
// map major device number to device functions.
struct devsw {
  int (*read)(int, uint64, int);
  int (*write)(int, uint64, int);
};
```

这里是RISCV的一种规定，它规定了每一个设备必须提供两种函数，一种是“读”的能力，一种是“写”的能力。

而这里提到的devsw是一个数组，他定义在了`file.c`中，定义如下：

```c
struct devsw devsw[NDEV];
```

其中NDEV是一个定义在`param.h`中的参数，定义了最大的外设数量。

这里，所以这个`consoleinit()`实际上只做了三件事，一个初始化串口，一个初始化了一个互斥锁，还有就是配置了控制台的输入输出的函数。

这里的控制台就可以理解为OS虚拟出来的一个基于串口的设备。

2. 初始化`printf`

```c
void
printfinit(void)
{
  initlock(&pr.lock, "pr");
}
```

由此，我们能得出一个依赖的关系表：

```shell
printf()
|
|
v
concole
|
|
v
uart
```

可以理解是网络层，数据链路层，物理层的关系。

3. 使用printf

```c

// Print to the console.
int
printf(char *fmt, ...)
{
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    acquire(&pr.lock);

  va_start(ap, fmt);
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    if(cx != '%'){
      consputc(cx);
      continue;
    }
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
      printint(va_arg(ap, uint32), 10, 0);
    } else if(c0 == 'l' && c1 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
      printint(va_arg(ap, uint32), 16, 0);
    } else if(c0 == 'l' && c1 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
      printptr(va_arg(ap, uint64));
    } else if(c0 == 'c'){
      consputc(va_arg(ap, uint));
    } else if(c0 == 's'){
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c0);
    }

  }
  va_end(ap);

  if(panicking == 0)
    release(&pr.lock);

  return 0;
}
```

这里我们先优先看明白`printf()`的逻辑。

1. 首先检查系统是否处于`panicking`状态。如果不处于，那么独占printf函数的使用权。

2. 接着，处理使用C语言的标准宏处理可变参数函数。
   这里主要有三个宏定义：va_list`, `va_start`,`va_end, `va_arg`,
   他们的作用是用于处理可变参数的情况，，va_list是这里用于处理可变参数的一个结构体，va_start和va_end分别用于初始化结构体和释放结构体，va_arg用于将对应的参数用特定的数据类型读取出来。

   这里有一个很简单的使用例子：

   ```c
   void func(int a, ...){
       va_list args;
       va_start(args, a);
       int sum = 0;
       for (int i = 0; i < a; i++)
       {
           int value = va_arg(args, int);
           sum += value;
       }
       va_end(args);
       printf("Sum: %d\n", sum);
   }
   ```

3. 在循环中，处理输出的情况。

4. 释放`va_end`和互斥锁，返回0。

核心就是上面的步骤三，那么应该如何处理呢？

能注意到在循环中，主要调用了三种函数：`consputc`, `printint`, 和`printptr`,而后面的两都是基于consputc实现的。所以我们应该先实现consputc。

这里还有一个细节：panic函数为什么放在printf.c中？paincing和paniced是什么作用？

这个设计十分巧妙，他保证一个进程死掉后，会安全打印出错误信息后，把整个OS全部卡死。

```c
void
panic(char *s)
{
  panicking = 1;
  printf("panic: ");
  printf("%s\n", s);
  panicked = 1; // freeze uart output from other CPUs
  for(;;)
    ;
}

```

`panic()`先设置panicing为1, 他保证了可以直接跳过printf的权限控制，直接打印报错信息，在打印完成后，设置panicked为1，这里就可以在中断函数中设置自旋来终止每一个CPU。

## 控制台层解读与串口控制

```c

//
// send one character to the uart.
// called by printf(), and to echo input characters,
// but not from write().
//
void
consputc(int c)
{
  if(c == BACKSPACE){
    // if the user typed backspace, overwrite with a space.
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
  } else {
    uartputc_sync(c);
  }
}
```

首先是`uartputc_sync`，这里其实就是前面我们实现的`uartputc`，不过这里表示的其实是同步写或者阻塞写，本质上是同一个东西。

接着是回退的处理，这里的由于是输出的环境，所以不需要考虑从中间删除的情况，只需要左移，输出空白，左移即可。

那么，来看一下`uartputc_sync`的实现。

```c
void
uartputc_sync(int c)
{
  if(panicking == 0)
    push_off();

  if(panicked){
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    ;
  WriteReg(THR, c);

  if(panicking == 0)
    pop_off();
}
```

中间这一段已经很熟悉了，就是我们的轮询输出。

```c
 // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    ;
  WriteReg(THR, c);

```

而上下这一段则是用来处理之前说的报错和提示的处理，`push_on()`和`pop_off()`是用来开关中断的，但是这里的处理也值得一提：

```c

void
push_off(void)
{
  int old = intr_get();

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    mycpu()->intena = old;
  mycpu()->noff += 1;
}

void
pop_off(void)
{
  struct cpu *c = mycpu();
  if(intr_get())
    panic("pop_off - interruptible");
  if(c->noff < 1)
    panic("pop_off");
  c->noff -= 1;
  if(c->noff == 0 && c->intena)
    intr_on();
}
```

这里的开关中断实际上做了计数的处理，即保证在调用多层的关中断后，需要相应调用多层开中断才能实现功能，并且保证不会出现不合法的配置。

`mycpu()`函数如下：

```c
struct cpu*
mycpu(void)
{
  int id = cpuid();
  struct cpu *c = &cpus[id];
  return c;
}

```

这里的`cpus`的声明如下：

```c
// Per-CPU state.
struct cpu {
  struct proc *proc;          // The process running on this cpu, or null.
  struct context context;     // swtch() here to enter scheduler().
  int noff;                   // Depth of push_off() nesting.
  int intena;                 // Were interrupts enabled before push_off()?
};

```

主要是看`noff`和`intena`这两个，noff是用来计数，`intena`是用来保证中断能够还原到原来的状态的。

`intr_on()`通过直接写入`sstatus`来修改内容，并且返回之前的写入状态。

### 互斥锁实现

现在在这里先实现互斥锁，虽然其涉及到中断的问题，但是到目前为止的设置其实是可以支持到互斥锁的初始化（因为在这里涉及到了cpu结构体，可以通过简化这个结构体来实现。）

```c
struct spinlock{
    uint locked;

    char* name;
    struct cpu* cpu;
};
void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
  lk->locked = 0;
  lk->cpu = 0;
}
```

看看上锁和解锁。

```c

// Acquire the lock.
// Loops (spins) until the lock is acquired.
void
acquire(struct spinlock *lk)
{
  push_off(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // On RISC-V, sync_lock_test_and_set turns into an atomic swap:
  //   a5 = 1
  //   s1 = &lk->locked
  //   amoswap.w.aq a5, a5, (s1)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen strictly after the lock is acquired.
  // On RISC-V, this emits a fence instruction.
  __sync_synchronize();

  // Record info about lock acquisition for holding() and debugging.
  lk->cpu = mycpu();
}
```

这里首先调用一下`holding`

```c
// Check whether this cpu is holding the lock.
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
  return r;
}

```

接着是一个原子交换，TAS函数

```c

  // On RISC-V, sync_lock_test_and_set turns into an atomic swap:
  //   a5 = 1
  //   s1 = &lk->locked
  //   amoswap.w.aq a5, a5, (s1)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    ;
```

  然后是内存屏障

```c

  // Tell the C compiler and the CPU to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other CPUs before the lock is released,
  // and that loads in the critical section occur strictly before
  // the lock is released.
  // On RISC-V, this emits a fence instruction.
  __sync_synchronize();
```

这里为什么需要内存屏障？内存屏障的使用就是，禁止这一句后面的任何读写内存指令，提前到这一句之前。

最后，设置这个锁当前的CPU。

## 任务列表

### Task1

#### 核心函数

- printf() 如何解析格式字符串？

通过可变参数来处理，利用<stdarg.h>`中的`va_start`等等宏定义来确认。

- `printint()`如何处理不同进制转换？

使用base来表示进制。

- 负数处理

需要根据sign来判断是否为有符号数。

#### 分层设计

```
printf() -> consputc() -> uartputc() -> 硬件寄存器
```

- 最顶层 printf() 负责直接和用户打交道，提供顶层抽象
- 中间交互层，负责向printf提供输出字符的接口，隐藏字符处理的一些细节
- 向consputc提供输出字符输出接口，隐藏硬件细节，直接和寄存器打交道。

#### 深层思考

- 为什么不使用递归进行数字转换

递归处理的代价更大，相反的使用一个缓冲区能够极大的减少开销。

- printint() 中处理 INT_MIN 的技巧是什么？

这里很细节，对于`INT_MIN`为`0x80000000`,如果直接取负会直接益出，所以这里使用一个`unsigned long long`来处理，避免了溢出的情况。

- 如何实现线程安全的printf？

首先，正常情况下，需要在输出过程中上锁避免中断和uart被抢占引起输出会混乱。

在遇上panic的时候，则会通过panic的设置强行破坏这个结构，让printf强行输出报错内容，然后进入死循环。

### Task2

![image-20250925212144104](/home/zhanng/Documents/GitHub/xv6-zwhu/docs/chapter2.assets/image-20250925212144104.png)

### Task4

```c
void test_printf_basic() {
    printf("Testing integer: %d\n", 42);
    printf("Testing negative: %d\n", -123);
    printf("Testing zero: %d\n", 0);
    printf("Testing hex: 0x%x\n", 0xABC);
    printf("Testing string: %s\n", "Hello");
    printf("Testing char: %c\n", 'X');
    printf("Testing percent: %%\n");
}
void test_printf_edge_cases() {
    printf("INT_MAX: %d\n", 2147483647);
    printf("INT_MIN: %d\n", -2147483648);
    printf("NULL string: %s\n", (char*)0);
    printf("Empty string: %s\n", "");
}
```

#### 任务5

从这里开始就是实现独立的功能。

这里实现了三个功能

![image-20250925222600293](/home/zhanng/Documents/GitHub/xv6-zwhu/docs/chapter2.assets/image-20250925222600293.png)

```c

// 实现清屏
void clear_screen(){
    printf("\033[2J");
    printf("\033[H");
}

// 光标移动
void goto_xy(int x, int y){
    if(x < 0 || x > 79 || y < 0 || y > 24)
        return;
    printf("\033[%d;%dH", y + 1, x + 1);
}


// 颜色输出
int 
printf_color(int color, char *fmt, ...){

printf("\033[%dm", color);

   va_list ap;
    int i, cx, c0 ,c1, c2;
    char* s;

    if(panicking == 0)
        acquire(&pr.lock);
    
    va_start(ap, fmt);



   for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    if(cx != '%'){
      consputc(cx);
      continue;
    }
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
      printint(va_arg(ap, uint32), 10, 0);
    } else if(c0 == 'l' && c1 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
      printint(va_arg(ap, uint32), 16, 0);
    } else if(c0 == 'l' && c1 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
      printptr(va_arg(ap, uint64));
    } else if(c0 == 'c'){
      consputc(va_arg(ap, uint));
    } else if(c0 == 's'){
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c0);
    }

  }

  va_end(ap);

  if(panicking == 0)
    release(&pr.lock);

   printf("\033[%dm",0);

    return 0;
}
```



