
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


// proc.c
struct cpu* mycpu(void);

// printf.c
void panic(char *s);
void printfinit(void);
int printf(char* fmt, ...);
int printf_color(int color, char *fmt, ...);   
void clear_screen(void);
void goto_xy(int x, int y);