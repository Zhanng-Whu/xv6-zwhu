
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
.section .text
.global _entry, test
_entry:
        la sp, stack0
    80000000:	00003117          	auipc	sp,0x3
    80000004:	51010113          	add	sp,sp,1296 # 80003510 <stack0>
        li a0, 1024*8
    80000008:	6509                	lui	a0,0x2
        # 对于一个单核系统 这里不需要考虑hartid的数量
        add sp, sp, a0
    8000000a:	912a                	add	sp,sp,a0
        call start
    8000000c:	19e000ef          	jal	800001aa <start>

0000000080000010 <test>:

test:
        li t0, 0x10000000
    80000010:	100002b7          	lui	t0,0x10000
        li t1, 'S'
    80000014:	05300313          	li	t1,83
        sb t1, 0(t0)
    80000018:	00628023          	sb	t1,0(t0) # 10000000 <_entry-0x70000000>
        ret
    8000001c:	8082                	ret

000000008000001e <spin>:

spin:
        call test
    8000001e:	ff3ff0ef          	jal	80000010 <test>
    80000022:	bff5                	j	8000001e <spin>

0000000080000024 <test_printf_basic>:
// start() jumps here in supervisor mode on all CPUs.


#define INT_MIN 0x80000000

void test_printf_basic() {
    80000024:	1141                	add	sp,sp,-16
    80000026:	e406                	sd	ra,8(sp)
    80000028:	e022                	sd	s0,0(sp)
    8000002a:	0800                	add	s0,sp,16
    printf("Testing integer: %d\n", 42);
    8000002c:	02a00593          	li	a1,42
    80000030:	00003517          	auipc	a0,0x3
    80000034:	fe050513          	add	a0,a0,-32 # 80003010 <etext+0x10>
    80000038:	51a000ef          	jal	80000552 <printf>
    printf("Testing negative: %d\n", -123);
    8000003c:	f8500593          	li	a1,-123
    80000040:	00003517          	auipc	a0,0x3
    80000044:	fe850513          	add	a0,a0,-24 # 80003028 <etext+0x28>
    80000048:	50a000ef          	jal	80000552 <printf>
    printf("Testing zero: %d\n", 0);
    8000004c:	4581                	li	a1,0
    8000004e:	00003517          	auipc	a0,0x3
    80000052:	ff250513          	add	a0,a0,-14 # 80003040 <etext+0x40>
    80000056:	4fc000ef          	jal	80000552 <printf>
    printf("Testing hex: 0x%x\n", 0xABC);
    8000005a:	6585                	lui	a1,0x1
    8000005c:	abc58593          	add	a1,a1,-1348 # abc <_entry-0x7ffff544>
    80000060:	00003517          	auipc	a0,0x3
    80000064:	ff850513          	add	a0,a0,-8 # 80003058 <etext+0x58>
    80000068:	4ea000ef          	jal	80000552 <printf>
    printf("Testing string: %s\n", "Hello");
    8000006c:	00003597          	auipc	a1,0x3
    80000070:	00458593          	add	a1,a1,4 # 80003070 <etext+0x70>
    80000074:	00003517          	auipc	a0,0x3
    80000078:	00450513          	add	a0,a0,4 # 80003078 <etext+0x78>
    8000007c:	4d6000ef          	jal	80000552 <printf>
    printf("Testing char: %c\n", 'X');
    80000080:	05800593          	li	a1,88
    80000084:	00003517          	auipc	a0,0x3
    80000088:	00c50513          	add	a0,a0,12 # 80003090 <etext+0x90>
    8000008c:	4c6000ef          	jal	80000552 <printf>
    printf("Testing percent: %%\n");
    80000090:	00003517          	auipc	a0,0x3
    80000094:	01850513          	add	a0,a0,24 # 800030a8 <etext+0xa8>
    80000098:	4ba000ef          	jal	80000552 <printf>
}
    8000009c:	60a2                	ld	ra,8(sp)
    8000009e:	6402                	ld	s0,0(sp)
    800000a0:	0141                	add	sp,sp,16
    800000a2:	8082                	ret

00000000800000a4 <test_printf_edge_cases>:
void test_printf_edge_cases() {
    800000a4:	1141                	add	sp,sp,-16
    800000a6:	e406                	sd	ra,8(sp)
    800000a8:	e022                	sd	s0,0(sp)
    800000aa:	0800                	add	s0,sp,16
    printf("INT_MAX: %d\n", 2147483647);
    800000ac:	800005b7          	lui	a1,0x80000
    800000b0:	fff5c593          	not	a1,a1
    800000b4:	00003517          	auipc	a0,0x3
    800000b8:	00c50513          	add	a0,a0,12 # 800030c0 <etext+0xc0>
    800000bc:	496000ef          	jal	80000552 <printf>
    printf("INT_MIN: %d\n", -2147483648);
    800000c0:	800005b7          	lui	a1,0x80000
    800000c4:	00003517          	auipc	a0,0x3
    800000c8:	00c50513          	add	a0,a0,12 # 800030d0 <etext+0xd0>
    800000cc:	486000ef          	jal	80000552 <printf>
    printf("NULL string: %s\n", (char*)0);
    800000d0:	4581                	li	a1,0
    800000d2:	00003517          	auipc	a0,0x3
    800000d6:	00e50513          	add	a0,a0,14 # 800030e0 <etext+0xe0>
    800000da:	478000ef          	jal	80000552 <printf>
    printf("Empty string: %s\n", "");
    800000de:	00003597          	auipc	a1,0x3
    800000e2:	07258593          	add	a1,a1,114 # 80003150 <etext+0x150>
    800000e6:	00003517          	auipc	a0,0x3
    800000ea:	01250513          	add	a0,a0,18 # 800030f8 <etext+0xf8>
    800000ee:	464000ef          	jal	80000552 <printf>
}
    800000f2:	60a2                	ld	ra,8(sp)
    800000f4:	6402                	ld	s0,0(sp)
    800000f6:	0141                	add	sp,sp,16
    800000f8:	8082                	ret

00000000800000fa <main>:
extern char end[];


void
main()
{
    800000fa:	1101                	add	sp,sp,-32
    800000fc:	ec06                	sd	ra,24(sp)
    800000fe:	e822                	sd	s0,16(sp)
    80000100:	e426                	sd	s1,8(sp)
    80000102:	1000                	add	s0,sp,32

  consoleinit();
    80000104:	148000ef          	jal	8000024c <consoleinit>
  printfinit();
    80000108:	243000ef          	jal	80000b4a <printfinit>
  printf("\n");
    8000010c:	00003517          	auipc	a0,0x3
    80000110:	f9450513          	add	a0,a0,-108 # 800030a0 <etext+0xa0>
    80000114:	43e000ef          	jal	80000552 <printf>
  printf("Hello World\n");
    80000118:	00003517          	auipc	a0,0x3
    8000011c:	ff850513          	add	a0,a0,-8 # 80003110 <etext+0x110>
    80000120:	432000ef          	jal	80000552 <printf>
  kinit();    
    80000124:	5fc010ef          	jal	80001720 <kinit>
  
  void* tmp = kalloc();
    80000128:	62c010ef          	jal	80001754 <kalloc>
    8000012c:	84aa                	mv	s1,a0

  
  printf("kalloc %p\n", tmp);
    8000012e:	85aa                	mv	a1,a0
    80000130:	00003517          	auipc	a0,0x3
    80000134:	ff050513          	add	a0,a0,-16 # 80003120 <etext+0x120>
    80000138:	41a000ef          	jal	80000552 <printf>
  printf("kfree %p\n", tmp);
    8000013c:	85a6                	mv	a1,s1
    8000013e:	00003517          	auipc	a0,0x3
    80000142:	ff250513          	add	a0,a0,-14 # 80003130 <etext+0x130>
    80000146:	40c000ef          	jal	80000552 <printf>
  kfree(tmp);
    8000014a:	8526                	mv	a0,s1
    8000014c:	424010ef          	jal	80001570 <kfree>
  printf("double kfree %p\n", tmp);
    80000150:	85a6                	mv	a1,s1
    80000152:	00003517          	auipc	a0,0x3
    80000156:	fee50513          	add	a0,a0,-18 # 80003140 <etext+0x140>
    8000015a:	3f8000ef          	jal	80000552 <printf>
  kfree(tmp);
    8000015e:	8526                	mv	a0,s1
    80000160:	410010ef          	jal	80001570 <kfree>
  
  for(;;)
    80000164:	a001                	j	80000164 <main+0x6a>

0000000080000166 <timerinit>:


// ask each hart to generate timer interrupts.
void
timerinit()
{
    80000166:	1141                	add	sp,sp,-16
    80000168:	e422                	sd	s0,8(sp)
    8000016a:	0800                	add	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000016c:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000170:	0207e793          	or	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    80000174:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80000178:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    8000017c:	577d                	li	a4,-1
    8000017e:	177e                	sll	a4,a4,0x3f
    80000180:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80000182:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80000186:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    8000018a:	0027e793          	or	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    8000018e:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    80000192:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80000196:	000f4737          	lui	a4,0xf4
    8000019a:	24070713          	add	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000019e:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800001a0:	14d79073          	csrw	stimecmp,a5
}
    800001a4:	6422                	ld	s0,8(sp)
    800001a6:	0141                	add	sp,sp,16
    800001a8:	8082                	ret

00000000800001aa <start>:
{
    800001aa:	1141                	add	sp,sp,-16
    800001ac:	e406                	sd	ra,8(sp)
    800001ae:	e022                	sd	s0,0(sp)
    800001b0:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800001b2:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800001b6:	7779                	lui	a4,0xffffe
    800001b8:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fff742f>
    800001bc:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800001be:	6705                	lui	a4,0x1
    800001c0:	80070713          	add	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800001c4:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800001c6:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800001ca:	00000797          	auipc	a5,0x0
    800001ce:	f3078793          	add	a5,a5,-208 # 800000fa <main>
    800001d2:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800001d6:	4781                	li	a5,0
    800001d8:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800001dc:	67c1                	lui	a5,0x10
    800001de:	17fd                	add	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800001e0:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800001e4:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800001e8:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE);
    800001ec:	2007e793          	or	a5,a5,512
  asm volatile("csrw sie, %0" : : "r" (x));
    800001f0:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800001f4:	57fd                	li	a5,-1
    800001f6:	83a9                	srl	a5,a5,0xa
    800001f8:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800001fc:	47bd                	li	a5,15
    800001fe:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80000202:	f65ff0ef          	jal	80000166 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000206:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000020a:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    8000020c:	823e                	mv	tp,a5
  asm volatile("mret");
    8000020e:	30200073          	mret
}
    80000212:	60a2                	ld	ra,8(sp)
    80000214:	6402                	ld	s0,0(sp)
    80000216:	0141                	add	sp,sp,16
    80000218:	8082                	ret

000000008000021a <consputc>:
    uint w;  // Write index
    uint e;  // Edit index
} cons;


void consputc(int c){
    8000021a:	1141                	add	sp,sp,-16
    8000021c:	e406                	sd	ra,8(sp)
    8000021e:	e022                	sd	s0,0(sp)
    80000220:	0800                	add	s0,sp,16
    if(c == BACKSPACE){
    80000222:	10000793          	li	a5,256
    80000226:	00f50863          	beq	a0,a5,80000236 <consputc+0x1c>
        // if the user typed backspace, overwrite with a space.
        uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    } else {
        uartputc_sync(c);        
    8000022a:	0de000ef          	jal	80000308 <uartputc_sync>
    }
}
    8000022e:	60a2                	ld	ra,8(sp)
    80000230:	6402                	ld	s0,0(sp)
    80000232:	0141                	add	sp,sp,16
    80000234:	8082                	ret
        uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000236:	4521                	li	a0,8
    80000238:	0d0000ef          	jal	80000308 <uartputc_sync>
    8000023c:	02000513          	li	a0,32
    80000240:	0c8000ef          	jal	80000308 <uartputc_sync>
    80000244:	4521                	li	a0,8
    80000246:	0c2000ef          	jal	80000308 <uartputc_sync>
    8000024a:	b7d5                	j	8000022e <consputc+0x14>

000000008000024c <consoleinit>:

void consoleinit(){
    8000024c:	1141                	add	sp,sp,-16
    8000024e:	e406                	sd	ra,8(sp)
    80000250:	e022                	sd	s0,0(sp)
    80000252:	0800                	add	s0,sp,16
    initlock(&cons.lock, "cons");
    80000254:	00003597          	auipc	a1,0x3
    80000258:	f0458593          	add	a1,a1,-252 # 80003158 <etext+0x158>
    8000025c:	00006517          	auipc	a0,0x6
    80000260:	2b450513          	add	a0,a0,692 # 80006510 <cons>
    80000264:	135000ef          	jal	80000b98 <initlock>
    uartinit();
    80000268:	00c000ef          	jal	80000274 <uartinit>
    8000026c:	60a2                	ld	ra,8(sp)
    8000026e:	6402                	ld	s0,0(sp)
    80000270:	0141                	add	sp,sp,16
    80000272:	8082                	ret

0000000080000274 <uartinit>:


extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void uartinit(void){
    80000274:	1141                	add	sp,sp,-16
    80000276:	e422                	sd	s0,8(sp)
    80000278:	0800                	add	s0,sp,16
    // 关闭读取中断
    WriteReg(IER, 0x00);
    8000027a:	100007b7          	lui	a5,0x10000
    8000027e:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

    // 设置波特率和信息位
    // 这里是一个常用波特率 38400
    // 计算方法是 115200 / 3 = 38400
    // 按照习惯 一次传递一个字节
    WriteReg(LCR, LCR_BAUD_LATCH);
    80000282:	f8000713          	li	a4,-128
    80000286:	00e781a3          	sb	a4,3(a5)
    WriteReg(0, 0x03); // LSB
    8000028a:	470d                	li	a4,3
    8000028c:	00e78023          	sb	a4,0(a5)
    WriteReg(1, 0x00); // MSB
    80000290:	000780a3          	sb	zero,1(a5)
    WriteReg(LCR, LCR_EIGHT_BITS);
    80000294:	00e781a3          	sb	a4,3(a5)

    // 启动缓冲区
    WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000298:	471d                	li	a4,7
    8000029a:	00e78123          	sb	a4,2(a5)

    // 开启读写中断 这里先注释掉 需要等后面配置完中断再开启
    // WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);

}
    8000029e:	6422                	ld	s0,8(sp)
    800002a0:	0141                	add	sp,sp,16
    800002a2:	8082                	ret

00000000800002a4 <uart_putc>:


void uart_putc(char c){
    800002a4:	1141                	add	sp,sp,-16
    800002a6:	e422                	sd	s0,8(sp)
    800002a8:	0800                	add	s0,sp,16
    // 等待串口发送完成
    while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800002aa:	10000737          	lui	a4,0x10000
    800002ae:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800002b2:	0207f793          	and	a5,a5,32
    800002b6:	dfe5                	beqz	a5,800002ae <uart_putc+0xa>
    ;
    WriteReg(THR, c);
    800002b8:	100007b7          	lui	a5,0x10000
    800002bc:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>
}
    800002c0:	6422                	ld	s0,8(sp)
    800002c2:	0141                	add	sp,sp,16
    800002c4:	8082                	ret

00000000800002c6 <uart_puts>:

void uart_puts(char *s){
    char* tmp = s;
    while(*s){
    800002c6:	00054783          	lbu	a5,0(a0)
    800002ca:	cf95                	beqz	a5,80000306 <uart_puts+0x40>
void uart_puts(char *s){
    800002cc:	1101                	add	sp,sp,-32
    800002ce:	ec06                	sd	ra,24(sp)
    800002d0:	e822                	sd	s0,16(sp)
    800002d2:	e426                	sd	s1,8(sp)
    800002d4:	e04a                	sd	s2,0(sp)
    800002d6:	1000                	add	s0,sp,32
    800002d8:	84aa                	mv	s1,a0
        if(*s == '\n')
    800002da:	4929                	li	s2,10
    800002dc:	a809                	j	800002ee <uart_puts+0x28>
            uart_putc('\r');
        uart_putc(*s++);
    800002de:	0485                	add	s1,s1,1
    800002e0:	fff4c503          	lbu	a0,-1(s1)
    800002e4:	fc1ff0ef          	jal	800002a4 <uart_putc>
    while(*s){
    800002e8:	0004c783          	lbu	a5,0(s1)
    800002ec:	c799                	beqz	a5,800002fa <uart_puts+0x34>
        if(*s == '\n')
    800002ee:	ff2798e3          	bne	a5,s2,800002de <uart_puts+0x18>
            uart_putc('\r');
    800002f2:	4535                	li	a0,13
    800002f4:	fb1ff0ef          	jal	800002a4 <uart_putc>
    800002f8:	b7dd                	j	800002de <uart_puts+0x18>
    }
    s = tmp;
}
    800002fa:	60e2                	ld	ra,24(sp)
    800002fc:	6442                	ld	s0,16(sp)
    800002fe:	64a2                	ld	s1,8(sp)
    80000300:	6902                	ld	s2,0(sp)
    80000302:	6105                	add	sp,sp,32
    80000304:	8082                	ret
    80000306:	8082                	ret

0000000080000308 <uartputc_sync>:


void uartputc_sync(int c)
{
    80000308:	1101                	add	sp,sp,-32
    8000030a:	ec06                	sd	ra,24(sp)
    8000030c:	e822                	sd	s0,16(sp)
    8000030e:	e426                	sd	s1,8(sp)
    80000310:	1000                	add	s0,sp,32
    80000312:	84aa                	mv	s1,a0
  if(panicking == 0)
    80000314:	00003797          	auipc	a5,0x3
    80000318:	1c47a783          	lw	a5,452(a5) # 800034d8 <panicking>
    8000031c:	cb89                	beqz	a5,8000032e <uartputc_sync+0x26>
    push_off();

  if(panicked){
    8000031e:	00003797          	auipc	a5,0x3
    80000322:	1b67a783          	lw	a5,438(a5) # 800034d4 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000326:	10000737          	lui	a4,0x10000
  if(panicked){
    8000032a:	c789                	beqz	a5,80000334 <uartputc_sync+0x2c>
    for(;;)
    8000032c:	a001                	j	8000032c <uartputc_sync+0x24>
    push_off();
    8000032e:	081000ef          	jal	80000bae <push_off>
    80000332:	b7f5                	j	8000031e <uartputc_sync+0x16>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000334:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000338:	0207f793          	and	a5,a5,32
    8000033c:	dfe5                	beqz	a5,80000334 <uartputc_sync+0x2c>
    ;
  WriteReg(THR, c);
    8000033e:	0ff4f513          	zext.b	a0,s1
    80000342:	100007b7          	lui	a5,0x10000
    80000346:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    8000034a:	00003797          	auipc	a5,0x3
    8000034e:	18e7a783          	lw	a5,398(a5) # 800034d8 <panicking>
    80000352:	c791                	beqz	a5,8000035e <uartputc_sync+0x56>
    pop_off();
}
    80000354:	60e2                	ld	ra,24(sp)
    80000356:	6442                	ld	s0,16(sp)
    80000358:	64a2                	ld	s1,8(sp)
    8000035a:	6105                	add	sp,sp,32
    8000035c:	8082                	ret
    pop_off();
    8000035e:	0d7000ef          	jal	80000c34 <pop_off>
}
    80000362:	bfcd                	j	80000354 <uartputc_sync+0x4c>

0000000080000364 <lst_init>:
// fast. circular simplifies code, because don't have to check for
// empty list in insert and remove.

void
lst_init(struct list *lst)
{
    80000364:	1141                	add	sp,sp,-16
    80000366:	e422                	sd	s0,8(sp)
    80000368:	0800                	add	s0,sp,16
  lst->next = lst;
    8000036a:	e108                	sd	a0,0(a0)
  lst->prev = lst;
    8000036c:	e508                	sd	a0,8(a0)
}
    8000036e:	6422                	ld	s0,8(sp)
    80000370:	0141                	add	sp,sp,16
    80000372:	8082                	ret

0000000080000374 <lst_empty>:

int
lst_empty(struct list *lst) {
    80000374:	1141                	add	sp,sp,-16
    80000376:	e422                	sd	s0,8(sp)
    80000378:	0800                	add	s0,sp,16
  return lst->next == lst;
    8000037a:	611c                	ld	a5,0(a0)
    8000037c:	40a78533          	sub	a0,a5,a0
}
    80000380:	00153513          	seqz	a0,a0
    80000384:	6422                	ld	s0,8(sp)
    80000386:	0141                	add	sp,sp,16
    80000388:	8082                	ret

000000008000038a <lst_remove>:

void
lst_remove(struct list *e) {
    8000038a:	1141                	add	sp,sp,-16
    8000038c:	e422                	sd	s0,8(sp)
    8000038e:	0800                	add	s0,sp,16
  e->prev->next = e->next;
    80000390:	6518                	ld	a4,8(a0)
    80000392:	611c                	ld	a5,0(a0)
    80000394:	e31c                	sd	a5,0(a4)
  e->next->prev = e->prev;
    80000396:	6518                	ld	a4,8(a0)
    80000398:	e798                	sd	a4,8(a5)
}
    8000039a:	6422                	ld	s0,8(sp)
    8000039c:	0141                	add	sp,sp,16
    8000039e:	8082                	ret

00000000800003a0 <lst_pop>:

void*
lst_pop(struct list *lst) {
    800003a0:	1101                	add	sp,sp,-32
    800003a2:	ec06                	sd	ra,24(sp)
    800003a4:	e822                	sd	s0,16(sp)
    800003a6:	e426                	sd	s1,8(sp)
    800003a8:	1000                	add	s0,sp,32
    800003aa:	84aa                	mv	s1,a0
  if(lst->next == lst)
    800003ac:	611c                	ld	a5,0(a0)
    800003ae:	00a78c63          	beq	a5,a0,800003c6 <lst_pop+0x26>
    panic("lst_pop");
  struct list *p = lst->next;
    800003b2:	6084                	ld	s1,0(s1)
  lst_remove(p);
    800003b4:	8526                	mv	a0,s1
    800003b6:	fd5ff0ef          	jal	8000038a <lst_remove>
  return (void *)p;
}
    800003ba:	8526                	mv	a0,s1
    800003bc:	60e2                	ld	ra,24(sp)
    800003be:	6442                	ld	s0,16(sp)
    800003c0:	64a2                	ld	s1,8(sp)
    800003c2:	6105                	add	sp,sp,32
    800003c4:	8082                	ret
    panic("lst_pop");
    800003c6:	00003517          	auipc	a0,0x3
    800003ca:	d9a50513          	add	a0,a0,-614 # 80003160 <etext+0x160>
    800003ce:	740000ef          	jal	80000b0e <panic>
    800003d2:	b7c5                	j	800003b2 <lst_pop+0x12>

00000000800003d4 <lst_push>:

void
lst_push(struct list *lst, void *p)
{
    800003d4:	1141                	add	sp,sp,-16
    800003d6:	e422                	sd	s0,8(sp)
    800003d8:	0800                	add	s0,sp,16
  struct list *e = (struct list *) p;
  e->next = lst->next;
    800003da:	611c                	ld	a5,0(a0)
    800003dc:	e19c                	sd	a5,0(a1)
  e->prev = lst;
    800003de:	e588                	sd	a0,8(a1)
  lst->next->prev = p;
    800003e0:	611c                	ld	a5,0(a0)
    800003e2:	e78c                	sd	a1,8(a5)
  lst->next = e;
    800003e4:	e10c                	sd	a1,0(a0)
}
    800003e6:	6422                	ld	s0,8(sp)
    800003e8:	0141                	add	sp,sp,16
    800003ea:	8082                	ret

00000000800003ec <lst_print>:

void
lst_print(struct list *lst)
{
    800003ec:	7179                	add	sp,sp,-48
    800003ee:	f406                	sd	ra,40(sp)
    800003f0:	f022                	sd	s0,32(sp)
    800003f2:	ec26                	sd	s1,24(sp)
    800003f4:	e84a                	sd	s2,16(sp)
    800003f6:	e44e                	sd	s3,8(sp)
    800003f8:	1800                	add	s0,sp,48
  for (struct list *p = lst->next; p != lst; p = p->next) {
    800003fa:	6104                	ld	s1,0(a0)
    800003fc:	00950e63          	beq	a0,s1,80000418 <lst_print+0x2c>
    80000400:	892a                	mv	s2,a0
    printf(" %p", p);
    80000402:	00003997          	auipc	s3,0x3
    80000406:	d6698993          	add	s3,s3,-666 # 80003168 <etext+0x168>
    8000040a:	85a6                	mv	a1,s1
    8000040c:	854e                	mv	a0,s3
    8000040e:	144000ef          	jal	80000552 <printf>
  for (struct list *p = lst->next; p != lst; p = p->next) {
    80000412:	6084                	ld	s1,0(s1)
    80000414:	fe991be3          	bne	s2,s1,8000040a <lst_print+0x1e>
  }
  printf("\n");
    80000418:	00003517          	auipc	a0,0x3
    8000041c:	c8850513          	add	a0,a0,-888 # 800030a0 <etext+0xa0>
    80000420:	132000ef          	jal	80000552 <printf>
}
    80000424:	70a2                	ld	ra,40(sp)
    80000426:	7402                	ld	s0,32(sp)
    80000428:	64e2                	ld	s1,24(sp)
    8000042a:	6942                	ld	s2,16(sp)
    8000042c:	69a2                	ld	s3,8(sp)
    8000042e:	6145                	add	sp,sp,48
    80000430:	8082                	ret

0000000080000432 <log2>:
#include "include/memlayout.h"
#include "include/riscv.h"
#include "include/defs.h"


int log2(uint64 x){
    80000432:	1141                	add	sp,sp,-16
    80000434:	e422                	sd	s0,8(sp)
    80000436:	0800                	add	s0,sp,16
    int k = 0;
    while(x > 1){
    80000438:	4705                	li	a4,1
    8000043a:	00a77b63          	bgeu	a4,a0,80000450 <log2+0x1e>
    8000043e:	87aa                	mv	a5,a0
    int k = 0;
    80000440:	4501                	li	a0,0
        k++;
    80000442:	2505                	addw	a0,a0,1
        x >>=1;
    80000444:	8385                	srl	a5,a5,0x1
    while(x > 1){
    80000446:	fef76ee3          	bltu	a4,a5,80000442 <log2+0x10>
    }
    return k;
}
    8000044a:	6422                	ld	s0,8(sp)
    8000044c:	0141                	add	sp,sp,16
    8000044e:	8082                	ret
    int k = 0;
    80000450:	4501                	li	a0,0
    80000452:	bfe5                	j	8000044a <log2+0x18>

0000000080000454 <power>:

// 返回a的n次方 使用快速幂
int power(int a, int n){
    80000454:	1141                	add	sp,sp,-16
    80000456:	e422                	sd	s0,8(sp)
    80000458:	0800                	add	s0,sp,16
    int base = a;
    int sum = 1;
    while(n){
    8000045a:	cd99                	beqz	a1,80000478 <power+0x24>
    8000045c:	87aa                	mv	a5,a0
    int sum = 1;
    8000045e:	4505                	li	a0,1
    80000460:	a031                	j	8000046c <power+0x18>
        if(n & 1) sum *= base;
        base *= base;
    80000462:	02f787bb          	mulw	a5,a5,a5
        n >>= 1;
    80000466:	4015d59b          	sraw	a1,a1,0x1
    while(n){
    8000046a:	c981                	beqz	a1,8000047a <power+0x26>
        if(n & 1) sum *= base;
    8000046c:	0015f713          	and	a4,a1,1
    80000470:	db6d                	beqz	a4,80000462 <power+0xe>
    80000472:	02a7853b          	mulw	a0,a5,a0
    80000476:	b7f5                	j	80000462 <power+0xe>
    int sum = 1;
    80000478:	4505                	li	a0,1
    }
    return sum;
    8000047a:	6422                	ld	s0,8(sp)
    8000047c:	0141                	add	sp,sp,16
    8000047e:	8082                	ret

0000000080000480 <printint>:



// base是进制 sign表示是否有符号
static void
printint(long long xx, int base ,int sign){
    80000480:	7139                	add	sp,sp,-64
    80000482:	fc06                	sd	ra,56(sp)
    80000484:	f822                	sd	s0,48(sp)
    80000486:	f426                	sd	s1,40(sp)
    80000488:	f04a                	sd	s2,32(sp)
    8000048a:	0080                	add	s0,sp,64
    8000048c:	84aa                	mv	s1,a0
    8000048e:	892e                	mv	s2,a1
    int i;

    unsigned long long x = 0;

    // 很巧妙的方法
    if(sign && xx < 0){
    80000490:	c219                	beqz	a2,80000496 <printint+0x16>
    80000492:	06054263          	bltz	a0,800004f6 <printint+0x76>
printint(long long xx, int base ,int sign){
    80000496:	fc040693          	add	a3,s0,-64
    8000049a:	4701                	li	a4,0


    i = 0;
    // 这里用do while 处理 0 这样的数字
    do{
        buf[i++] = digits[x % base];
    8000049c:	00003597          	auipc	a1,0x3
    800004a0:	d2458593          	add	a1,a1,-732 # 800031c0 <digits>
    800004a4:	863a                	mv	a2,a4
    800004a6:	2705                	addw	a4,a4,1
    800004a8:	0324f7b3          	remu	a5,s1,s2
    800004ac:	97ae                	add	a5,a5,a1
    800004ae:	0007c783          	lbu	a5,0(a5)
    800004b2:	00f68023          	sb	a5,0(a3)
        x /= base;
    800004b6:	87a6                	mv	a5,s1
    800004b8:	0324d4b3          	divu	s1,s1,s2
    }while(x);
    800004bc:	0685                	add	a3,a3,1
    800004be:	ff27f3e3          	bgeu	a5,s2,800004a4 <printint+0x24>

    while(--i >= 0)
    800004c2:	02064463          	bltz	a2,800004ea <printint+0x6a>
    800004c6:	fc040793          	add	a5,s0,-64
    800004ca:	00c784b3          	add	s1,a5,a2
    800004ce:	fff78913          	add	s2,a5,-1
    800004d2:	9932                	add	s2,s2,a2
    800004d4:	1602                	sll	a2,a2,0x20
    800004d6:	9201                	srl	a2,a2,0x20
    800004d8:	40c90933          	sub	s2,s2,a2
        consputc(buf[i]);
    800004dc:	0004c503          	lbu	a0,0(s1)
    800004e0:	d3bff0ef          	jal	8000021a <consputc>
    while(--i >= 0)
    800004e4:	14fd                	add	s1,s1,-1
    800004e6:	ff249be3          	bne	s1,s2,800004dc <printint+0x5c>
}
    800004ea:	70e2                	ld	ra,56(sp)
    800004ec:	7442                	ld	s0,48(sp)
    800004ee:	74a2                	ld	s1,40(sp)
    800004f0:	7902                	ld	s2,32(sp)
    800004f2:	6121                	add	sp,sp,64
    800004f4:	8082                	ret
        x = -xx;
    800004f6:	40a004b3          	neg	s1,a0
        consputc('-');
    800004fa:	02d00513          	li	a0,45
    800004fe:	d1dff0ef          	jal	8000021a <consputc>
    80000502:	bf51                	j	80000496 <printint+0x16>

0000000080000504 <printptr>:

static void 
printptr(uint64 x){
    80000504:	7179                	add	sp,sp,-48
    80000506:	f406                	sd	ra,40(sp)
    80000508:	f022                	sd	s0,32(sp)
    8000050a:	ec26                	sd	s1,24(sp)
    8000050c:	e84a                	sd	s2,16(sp)
    8000050e:	e44e                	sd	s3,8(sp)
    80000510:	1800                	add	s0,sp,48
    80000512:	84aa                	mv	s1,a0
    int i;
    consputc('0');
    80000514:	03000513          	li	a0,48
    80000518:	d03ff0ef          	jal	8000021a <consputc>
    consputc('x');
    8000051c:	07800513          	li	a0,120
    80000520:	cfbff0ef          	jal	8000021a <consputc>
    80000524:	4941                	li	s2,16
    for(i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
        consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000526:	00003997          	auipc	s3,0x3
    8000052a:	c9a98993          	add	s3,s3,-870 # 800031c0 <digits>
    8000052e:	03c4d793          	srl	a5,s1,0x3c
    80000532:	97ce                	add	a5,a5,s3
    80000534:	0007c503          	lbu	a0,0(a5)
    80000538:	ce3ff0ef          	jal	8000021a <consputc>
    for(i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000053c:	0492                	sll	s1,s1,0x4
    8000053e:	397d                	addw	s2,s2,-1
    80000540:	fe0917e3          	bnez	s2,8000052e <printptr+0x2a>
}
    80000544:	70a2                	ld	ra,40(sp)
    80000546:	7402                	ld	s0,32(sp)
    80000548:	64e2                	ld	s1,24(sp)
    8000054a:	6942                	ld	s2,16(sp)
    8000054c:	69a2                	ld	s3,8(sp)
    8000054e:	6145                	add	sp,sp,48
    80000550:	8082                	ret

0000000080000552 <printf>:


int
printf(char* fmt, ...){
    80000552:	7131                	add	sp,sp,-192
    80000554:	fc86                	sd	ra,120(sp)
    80000556:	f8a2                	sd	s0,112(sp)
    80000558:	f4a6                	sd	s1,104(sp)
    8000055a:	f0ca                	sd	s2,96(sp)
    8000055c:	ecce                	sd	s3,88(sp)
    8000055e:	e8d2                	sd	s4,80(sp)
    80000560:	e4d6                	sd	s5,72(sp)
    80000562:	e0da                	sd	s6,64(sp)
    80000564:	fc5e                	sd	s7,56(sp)
    80000566:	f862                	sd	s8,48(sp)
    80000568:	f466                	sd	s9,40(sp)
    8000056a:	f06a                	sd	s10,32(sp)
    8000056c:	ec6e                	sd	s11,24(sp)
    8000056e:	0100                	add	s0,sp,128
    80000570:	8a2a                	mv	s4,a0
    80000572:	e40c                	sd	a1,8(s0)
    80000574:	e810                	sd	a2,16(s0)
    80000576:	ec14                	sd	a3,24(s0)
    80000578:	f018                	sd	a4,32(s0)
    8000057a:	f41c                	sd	a5,40(s0)
    8000057c:	03043823          	sd	a6,48(s0)
    80000580:	03143c23          	sd	a7,56(s0)
    va_list ap;
    int i, cx, c0 ,c1, c2;
    char* s;

    if(panicking == 0)
    80000584:	00003797          	auipc	a5,0x3
    80000588:	f547a783          	lw	a5,-172(a5) # 800034d8 <panicking>
    8000058c:	cb8d                	beqz	a5,800005be <printf+0x6c>
        acquire(&pr.lock);
    
    va_start(ap, fmt);
    8000058e:	00840793          	add	a5,s0,8
    80000592:	f8f43423          	sd	a5,-120(s0)



   for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000596:	000a4503          	lbu	a0,0(s4)
    8000059a:	22050263          	beqz	a0,800007be <printf+0x26c>
    8000059e:	4981                	li	s3,0
    if(cx != '%'){
    800005a0:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    800005a4:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    800005a8:	06c00b93          	li	s7,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    800005ac:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    800005b0:	07800c93          	li	s9,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    800005b4:	07000d13          	li	s10,112
      printptr(va_arg(ap, uint64));
    } else if(c0 == 'c'){
    800005b8:	06300d93          	li	s11,99
    800005bc:	a01d                	j	800005e2 <printf+0x90>
        acquire(&pr.lock);
    800005be:	00006517          	auipc	a0,0x6
    800005c2:	ffa50513          	add	a0,a0,-6 # 800065b8 <pr>
    800005c6:	628000ef          	jal	80000bee <acquire>
    800005ca:	b7d1                	j	8000058e <printf+0x3c>
      consputc(cx);
    800005cc:	c4fff0ef          	jal	8000021a <consputc>
      continue;
    800005d0:	84ce                	mv	s1,s3
   for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800005d2:	0014899b          	addw	s3,s1,1
    800005d6:	013a07b3          	add	a5,s4,s3
    800005da:	0007c503          	lbu	a0,0(a5)
    800005de:	1e050063          	beqz	a0,800007be <printf+0x26c>
    if(cx != '%'){
    800005e2:	ff5515e3          	bne	a0,s5,800005cc <printf+0x7a>
    i++;
    800005e6:	0019849b          	addw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    800005ea:	009a07b3          	add	a5,s4,s1
    800005ee:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    800005f2:	1c090663          	beqz	s2,800007be <printf+0x26c>
    800005f6:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    800005fa:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    800005fc:	c789                	beqz	a5,80000606 <printf+0xb4>
    800005fe:	009a0733          	add	a4,s4,s1
    80000602:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80000606:	03690763          	beq	s2,s6,80000634 <printf+0xe2>
    } else if(c0 == 'l' && c1 == 'd'){
    8000060a:	05790163          	beq	s2,s7,8000064c <printf+0xfa>
    } else if(c0 == 'u'){
    8000060e:	0d890463          	beq	s2,s8,800006d6 <printf+0x184>
    } else if(c0 == 'x'){
    80000612:	11990b63          	beq	s2,s9,80000728 <printf+0x1d6>
    } else if(c0 == 'p'){
    80000616:	15a90463          	beq	s2,s10,8000075e <printf+0x20c>
    } else if(c0 == 'c'){
    8000061a:	15b90c63          	beq	s2,s11,80000772 <printf+0x220>
      consputc(va_arg(ap, uint));
    } else if(c0 == 's'){
    8000061e:	07300793          	li	a5,115
    80000622:	16f90263          	beq	s2,a5,80000786 <printf+0x234>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    80000626:	03591b63          	bne	s2,s5,8000065c <printf+0x10a>
      consputc('%');
    8000062a:	02500513          	li	a0,37
    8000062e:	bedff0ef          	jal	8000021a <consputc>
    80000632:	b745                	j	800005d2 <printf+0x80>
      printint(va_arg(ap, int), 10, 1);
    80000634:	f8843783          	ld	a5,-120(s0)
    80000638:	00878713          	add	a4,a5,8
    8000063c:	f8e43423          	sd	a4,-120(s0)
    80000640:	4605                	li	a2,1
    80000642:	45a9                	li	a1,10
    80000644:	4388                	lw	a0,0(a5)
    80000646:	e3bff0ef          	jal	80000480 <printint>
    8000064a:	b761                	j	800005d2 <printf+0x80>
    } else if(c0 == 'l' && c1 == 'd'){
    8000064c:	01678f63          	beq	a5,s6,8000066a <printf+0x118>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80000650:	03778b63          	beq	a5,s7,80000686 <printf+0x134>
    } else if(c0 == 'l' && c1 == 'u'){
    80000654:	09878e63          	beq	a5,s8,800006f0 <printf+0x19e>
    } else if(c0 == 'l' && c1 == 'x'){
    80000658:	0f978563          	beq	a5,s9,80000742 <printf+0x1f0>
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    8000065c:	8556                	mv	a0,s5
    8000065e:	bbdff0ef          	jal	8000021a <consputc>
      consputc(c0);
    80000662:	854a                	mv	a0,s2
    80000664:	bb7ff0ef          	jal	8000021a <consputc>
    80000668:	b7ad                	j	800005d2 <printf+0x80>
      printint(va_arg(ap, uint64), 10, 1);
    8000066a:	f8843783          	ld	a5,-120(s0)
    8000066e:	00878713          	add	a4,a5,8
    80000672:	f8e43423          	sd	a4,-120(s0)
    80000676:	4605                	li	a2,1
    80000678:	45a9                	li	a1,10
    8000067a:	6388                	ld	a0,0(a5)
    8000067c:	e05ff0ef          	jal	80000480 <printint>
      i += 1;
    80000680:	0029849b          	addw	s1,s3,2
    80000684:	b7b9                	j	800005d2 <printf+0x80>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80000686:	06400793          	li	a5,100
    8000068a:	02f68863          	beq	a3,a5,800006ba <printf+0x168>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    8000068e:	07500793          	li	a5,117
    80000692:	06f68d63          	beq	a3,a5,8000070c <printf+0x1ba>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80000696:	07800793          	li	a5,120
    8000069a:	fcf691e3          	bne	a3,a5,8000065c <printf+0x10a>
      printint(va_arg(ap, uint64), 16, 0);
    8000069e:	f8843783          	ld	a5,-120(s0)
    800006a2:	00878713          	add	a4,a5,8
    800006a6:	f8e43423          	sd	a4,-120(s0)
    800006aa:	4601                	li	a2,0
    800006ac:	45c1                	li	a1,16
    800006ae:	6388                	ld	a0,0(a5)
    800006b0:	dd1ff0ef          	jal	80000480 <printint>
      i += 2;
    800006b4:	0039849b          	addw	s1,s3,3
    800006b8:	bf29                	j	800005d2 <printf+0x80>
      printint(va_arg(ap, uint64), 10, 1);
    800006ba:	f8843783          	ld	a5,-120(s0)
    800006be:	00878713          	add	a4,a5,8
    800006c2:	f8e43423          	sd	a4,-120(s0)
    800006c6:	4605                	li	a2,1
    800006c8:	45a9                	li	a1,10
    800006ca:	6388                	ld	a0,0(a5)
    800006cc:	db5ff0ef          	jal	80000480 <printint>
      i += 2;
    800006d0:	0039849b          	addw	s1,s3,3
    800006d4:	bdfd                	j	800005d2 <printf+0x80>
      printint(va_arg(ap, uint32), 10, 0);
    800006d6:	f8843783          	ld	a5,-120(s0)
    800006da:	00878713          	add	a4,a5,8
    800006de:	f8e43423          	sd	a4,-120(s0)
    800006e2:	4601                	li	a2,0
    800006e4:	45a9                	li	a1,10
    800006e6:	0007e503          	lwu	a0,0(a5)
    800006ea:	d97ff0ef          	jal	80000480 <printint>
    800006ee:	b5d5                	j	800005d2 <printf+0x80>
      printint(va_arg(ap, uint64), 10, 0);
    800006f0:	f8843783          	ld	a5,-120(s0)
    800006f4:	00878713          	add	a4,a5,8
    800006f8:	f8e43423          	sd	a4,-120(s0)
    800006fc:	4601                	li	a2,0
    800006fe:	45a9                	li	a1,10
    80000700:	6388                	ld	a0,0(a5)
    80000702:	d7fff0ef          	jal	80000480 <printint>
      i += 1;
    80000706:	0029849b          	addw	s1,s3,2
    8000070a:	b5e1                	j	800005d2 <printf+0x80>
      printint(va_arg(ap, uint64), 10, 0);
    8000070c:	f8843783          	ld	a5,-120(s0)
    80000710:	00878713          	add	a4,a5,8
    80000714:	f8e43423          	sd	a4,-120(s0)
    80000718:	4601                	li	a2,0
    8000071a:	45a9                	li	a1,10
    8000071c:	6388                	ld	a0,0(a5)
    8000071e:	d63ff0ef          	jal	80000480 <printint>
      i += 2;
    80000722:	0039849b          	addw	s1,s3,3
    80000726:	b575                	j	800005d2 <printf+0x80>
      printint(va_arg(ap, uint32), 16, 0);
    80000728:	f8843783          	ld	a5,-120(s0)
    8000072c:	00878713          	add	a4,a5,8
    80000730:	f8e43423          	sd	a4,-120(s0)
    80000734:	4601                	li	a2,0
    80000736:	45c1                	li	a1,16
    80000738:	0007e503          	lwu	a0,0(a5)
    8000073c:	d45ff0ef          	jal	80000480 <printint>
    80000740:	bd49                	j	800005d2 <printf+0x80>
      printint(va_arg(ap, uint64), 16, 0);
    80000742:	f8843783          	ld	a5,-120(s0)
    80000746:	00878713          	add	a4,a5,8
    8000074a:	f8e43423          	sd	a4,-120(s0)
    8000074e:	4601                	li	a2,0
    80000750:	45c1                	li	a1,16
    80000752:	6388                	ld	a0,0(a5)
    80000754:	d2dff0ef          	jal	80000480 <printint>
      i += 1;
    80000758:	0029849b          	addw	s1,s3,2
    8000075c:	bd9d                	j	800005d2 <printf+0x80>
      printptr(va_arg(ap, uint64));
    8000075e:	f8843783          	ld	a5,-120(s0)
    80000762:	00878713          	add	a4,a5,8
    80000766:	f8e43423          	sd	a4,-120(s0)
    8000076a:	6388                	ld	a0,0(a5)
    8000076c:	d99ff0ef          	jal	80000504 <printptr>
    80000770:	b58d                	j	800005d2 <printf+0x80>
      consputc(va_arg(ap, uint));
    80000772:	f8843783          	ld	a5,-120(s0)
    80000776:	00878713          	add	a4,a5,8
    8000077a:	f8e43423          	sd	a4,-120(s0)
    8000077e:	4388                	lw	a0,0(a5)
    80000780:	a9bff0ef          	jal	8000021a <consputc>
    80000784:	b5b9                	j	800005d2 <printf+0x80>
      if((s = va_arg(ap, char*)) == 0)
    80000786:	f8843783          	ld	a5,-120(s0)
    8000078a:	00878713          	add	a4,a5,8
    8000078e:	f8e43423          	sd	a4,-120(s0)
    80000792:	0007b903          	ld	s2,0(a5)
    80000796:	00090d63          	beqz	s2,800007b0 <printf+0x25e>
      for(; *s; s++)
    8000079a:	00094503          	lbu	a0,0(s2)
    8000079e:	e2050ae3          	beqz	a0,800005d2 <printf+0x80>
        consputc(*s);
    800007a2:	a79ff0ef          	jal	8000021a <consputc>
      for(; *s; s++)
    800007a6:	0905                	add	s2,s2,1
    800007a8:	00094503          	lbu	a0,0(s2)
    800007ac:	f97d                	bnez	a0,800007a2 <printf+0x250>
    800007ae:	b515                	j	800005d2 <printf+0x80>
        s = "(null)";
    800007b0:	00003917          	auipc	s2,0x3
    800007b4:	9c090913          	add	s2,s2,-1600 # 80003170 <etext+0x170>
      for(; *s; s++)
    800007b8:	02800513          	li	a0,40
    800007bc:	b7dd                	j	800007a2 <printf+0x250>

  }

  va_end(ap);

  if(panicking == 0)
    800007be:	00003797          	auipc	a5,0x3
    800007c2:	d1a7a783          	lw	a5,-742(a5) # 800034d8 <panicking>
    800007c6:	c38d                	beqz	a5,800007e8 <printf+0x296>
    release(&pr.lock);
  return 0;
}
    800007c8:	4501                	li	a0,0
    800007ca:	70e6                	ld	ra,120(sp)
    800007cc:	7446                	ld	s0,112(sp)
    800007ce:	74a6                	ld	s1,104(sp)
    800007d0:	7906                	ld	s2,96(sp)
    800007d2:	69e6                	ld	s3,88(sp)
    800007d4:	6a46                	ld	s4,80(sp)
    800007d6:	6aa6                	ld	s5,72(sp)
    800007d8:	6b06                	ld	s6,64(sp)
    800007da:	7be2                	ld	s7,56(sp)
    800007dc:	7c42                	ld	s8,48(sp)
    800007de:	7ca2                	ld	s9,40(sp)
    800007e0:	7d02                	ld	s10,32(sp)
    800007e2:	6de2                	ld	s11,24(sp)
    800007e4:	6129                	add	sp,sp,192
    800007e6:	8082                	ret
    release(&pr.lock);
    800007e8:	00006517          	auipc	a0,0x6
    800007ec:	dd050513          	add	a0,a0,-560 # 800065b8 <pr>
    800007f0:	4a4000ef          	jal	80000c94 <release>
  return 0;
    800007f4:	bfd1                	j	800007c8 <printf+0x276>

00000000800007f6 <clear_screen>:

// 实现清屏
void clear_screen(){
    800007f6:	1141                	add	sp,sp,-16
    800007f8:	e406                	sd	ra,8(sp)
    800007fa:	e022                	sd	s0,0(sp)
    800007fc:	0800                	add	s0,sp,16
    printf("\033[2J");
    800007fe:	00003517          	auipc	a0,0x3
    80000802:	97a50513          	add	a0,a0,-1670 # 80003178 <etext+0x178>
    80000806:	d4dff0ef          	jal	80000552 <printf>
    printf("\033[H");
    8000080a:	00003517          	auipc	a0,0x3
    8000080e:	97650513          	add	a0,a0,-1674 # 80003180 <etext+0x180>
    80000812:	d41ff0ef          	jal	80000552 <printf>
}
    80000816:	60a2                	ld	ra,8(sp)
    80000818:	6402                	ld	s0,0(sp)
    8000081a:	0141                	add	sp,sp,16
    8000081c:	8082                	ret

000000008000081e <goto_xy>:

// 光标移动
void goto_xy(int x, int y){
    if(x < 0 || x > 79 || y < 0 || y > 24)
    8000081e:	04f00793          	li	a5,79
    80000822:	02a7e863          	bltu	a5,a0,80000852 <goto_xy+0x34>
    80000826:	0005879b          	sext.w	a5,a1
    8000082a:	4761                	li	a4,24
    8000082c:	02f76363          	bltu	a4,a5,80000852 <goto_xy+0x34>
void goto_xy(int x, int y){
    80000830:	1141                	add	sp,sp,-16
    80000832:	e406                	sd	ra,8(sp)
    80000834:	e022                	sd	s0,0(sp)
    80000836:	0800                	add	s0,sp,16
        return;
    printf("\033[%d;%dH", y + 1, x + 1);
    80000838:	0015061b          	addw	a2,a0,1
    8000083c:	2585                	addw	a1,a1,1
    8000083e:	00003517          	auipc	a0,0x3
    80000842:	94a50513          	add	a0,a0,-1718 # 80003188 <etext+0x188>
    80000846:	d0dff0ef          	jal	80000552 <printf>
}
    8000084a:	60a2                	ld	ra,8(sp)
    8000084c:	6402                	ld	s0,0(sp)
    8000084e:	0141                	add	sp,sp,16
    80000850:	8082                	ret
    80000852:	8082                	ret

0000000080000854 <printf_color>:


// 颜色输出
int 
printf_color(int color, char *fmt, ...){
    80000854:	7171                	add	sp,sp,-176
    80000856:	fc86                	sd	ra,120(sp)
    80000858:	f8a2                	sd	s0,112(sp)
    8000085a:	f4a6                	sd	s1,104(sp)
    8000085c:	f0ca                	sd	s2,96(sp)
    8000085e:	ecce                	sd	s3,88(sp)
    80000860:	e8d2                	sd	s4,80(sp)
    80000862:	e4d6                	sd	s5,72(sp)
    80000864:	e0da                	sd	s6,64(sp)
    80000866:	fc5e                	sd	s7,56(sp)
    80000868:	f862                	sd	s8,48(sp)
    8000086a:	f466                	sd	s9,40(sp)
    8000086c:	f06a                	sd	s10,32(sp)
    8000086e:	ec6e                	sd	s11,24(sp)
    80000870:	0100                	add	s0,sp,128
    80000872:	8a2e                	mv	s4,a1
    80000874:	e010                	sd	a2,0(s0)
    80000876:	e414                	sd	a3,8(s0)
    80000878:	e818                	sd	a4,16(s0)
    8000087a:	ec1c                	sd	a5,24(s0)
    8000087c:	03043023          	sd	a6,32(s0)
    80000880:	03143423          	sd	a7,40(s0)

printf("\033[%dm", color);
    80000884:	85aa                	mv	a1,a0
    80000886:	00003517          	auipc	a0,0x3
    8000088a:	91250513          	add	a0,a0,-1774 # 80003198 <etext+0x198>
    8000088e:	cc5ff0ef          	jal	80000552 <printf>

   va_list ap;
    int i, cx, c0 ,c1, c2;
    char* s;

    if(panicking == 0)
    80000892:	00003797          	auipc	a5,0x3
    80000896:	c467a783          	lw	a5,-954(a5) # 800034d8 <panicking>
    8000089a:	c79d                	beqz	a5,800008c8 <printf_color+0x74>
        acquire(&pr.lock);
    
    va_start(ap, fmt);
    8000089c:	f8843423          	sd	s0,-120(s0)



   for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800008a0:	000a4503          	lbu	a0,0(s4)
    800008a4:	22050263          	beqz	a0,80000ac8 <printf_color+0x274>
    800008a8:	4981                	li	s3,0
    if(cx != '%'){
    800008aa:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    800008ae:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    800008b2:	06c00b93          	li	s7,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    800008b6:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    800008ba:	07800c93          	li	s9,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    800008be:	07000d13          	li	s10,112
      printptr(va_arg(ap, uint64));
    } else if(c0 == 'c'){
    800008c2:	06300d93          	li	s11,99
    800008c6:	a01d                	j	800008ec <printf_color+0x98>
        acquire(&pr.lock);
    800008c8:	00006517          	auipc	a0,0x6
    800008cc:	cf050513          	add	a0,a0,-784 # 800065b8 <pr>
    800008d0:	31e000ef          	jal	80000bee <acquire>
    800008d4:	b7e1                	j	8000089c <printf_color+0x48>
      consputc(cx);
    800008d6:	945ff0ef          	jal	8000021a <consputc>
      continue;
    800008da:	84ce                	mv	s1,s3
   for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800008dc:	0014899b          	addw	s3,s1,1
    800008e0:	013a07b3          	add	a5,s4,s3
    800008e4:	0007c503          	lbu	a0,0(a5)
    800008e8:	1e050063          	beqz	a0,80000ac8 <printf_color+0x274>
    if(cx != '%'){
    800008ec:	ff5515e3          	bne	a0,s5,800008d6 <printf_color+0x82>
    i++;
    800008f0:	0019849b          	addw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    800008f4:	009a07b3          	add	a5,s4,s1
    800008f8:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    800008fc:	1c090663          	beqz	s2,80000ac8 <printf_color+0x274>
    80000900:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80000904:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80000906:	c789                	beqz	a5,80000910 <printf_color+0xbc>
    80000908:	009a0733          	add	a4,s4,s1
    8000090c:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80000910:	03690763          	beq	s2,s6,8000093e <printf_color+0xea>
    } else if(c0 == 'l' && c1 == 'd'){
    80000914:	05790163          	beq	s2,s7,80000956 <printf_color+0x102>
    } else if(c0 == 'u'){
    80000918:	0d890463          	beq	s2,s8,800009e0 <printf_color+0x18c>
    } else if(c0 == 'x'){
    8000091c:	11990b63          	beq	s2,s9,80000a32 <printf_color+0x1de>
    } else if(c0 == 'p'){
    80000920:	15a90463          	beq	s2,s10,80000a68 <printf_color+0x214>
    } else if(c0 == 'c'){
    80000924:	15b90c63          	beq	s2,s11,80000a7c <printf_color+0x228>
      consputc(va_arg(ap, uint));
    } else if(c0 == 's'){
    80000928:	07300793          	li	a5,115
    8000092c:	16f90263          	beq	s2,a5,80000a90 <printf_color+0x23c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    80000930:	03591b63          	bne	s2,s5,80000966 <printf_color+0x112>
      consputc('%');
    80000934:	02500513          	li	a0,37
    80000938:	8e3ff0ef          	jal	8000021a <consputc>
    8000093c:	b745                	j	800008dc <printf_color+0x88>
      printint(va_arg(ap, int), 10, 1);
    8000093e:	f8843783          	ld	a5,-120(s0)
    80000942:	00878713          	add	a4,a5,8
    80000946:	f8e43423          	sd	a4,-120(s0)
    8000094a:	4605                	li	a2,1
    8000094c:	45a9                	li	a1,10
    8000094e:	4388                	lw	a0,0(a5)
    80000950:	b31ff0ef          	jal	80000480 <printint>
    80000954:	b761                	j	800008dc <printf_color+0x88>
    } else if(c0 == 'l' && c1 == 'd'){
    80000956:	01678f63          	beq	a5,s6,80000974 <printf_color+0x120>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000095a:	03778b63          	beq	a5,s7,80000990 <printf_color+0x13c>
    } else if(c0 == 'l' && c1 == 'u'){
    8000095e:	09878e63          	beq	a5,s8,800009fa <printf_color+0x1a6>
    } else if(c0 == 'l' && c1 == 'x'){
    80000962:	0f978563          	beq	a5,s9,80000a4c <printf_color+0x1f8>
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80000966:	8556                	mv	a0,s5
    80000968:	8b3ff0ef          	jal	8000021a <consputc>
      consputc(c0);
    8000096c:	854a                	mv	a0,s2
    8000096e:	8adff0ef          	jal	8000021a <consputc>
    80000972:	b7ad                	j	800008dc <printf_color+0x88>
      printint(va_arg(ap, uint64), 10, 1);
    80000974:	f8843783          	ld	a5,-120(s0)
    80000978:	00878713          	add	a4,a5,8
    8000097c:	f8e43423          	sd	a4,-120(s0)
    80000980:	4605                	li	a2,1
    80000982:	45a9                	li	a1,10
    80000984:	6388                	ld	a0,0(a5)
    80000986:	afbff0ef          	jal	80000480 <printint>
      i += 1;
    8000098a:	0029849b          	addw	s1,s3,2
    8000098e:	b7b9                	j	800008dc <printf_color+0x88>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80000990:	06400793          	li	a5,100
    80000994:	02f68863          	beq	a3,a5,800009c4 <printf_color+0x170>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80000998:	07500793          	li	a5,117
    8000099c:	06f68d63          	beq	a3,a5,80000a16 <printf_color+0x1c2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    800009a0:	07800793          	li	a5,120
    800009a4:	fcf691e3          	bne	a3,a5,80000966 <printf_color+0x112>
      printint(va_arg(ap, uint64), 16, 0);
    800009a8:	f8843783          	ld	a5,-120(s0)
    800009ac:	00878713          	add	a4,a5,8
    800009b0:	f8e43423          	sd	a4,-120(s0)
    800009b4:	4601                	li	a2,0
    800009b6:	45c1                	li	a1,16
    800009b8:	6388                	ld	a0,0(a5)
    800009ba:	ac7ff0ef          	jal	80000480 <printint>
      i += 2;
    800009be:	0039849b          	addw	s1,s3,3
    800009c2:	bf29                	j	800008dc <printf_color+0x88>
      printint(va_arg(ap, uint64), 10, 1);
    800009c4:	f8843783          	ld	a5,-120(s0)
    800009c8:	00878713          	add	a4,a5,8
    800009cc:	f8e43423          	sd	a4,-120(s0)
    800009d0:	4605                	li	a2,1
    800009d2:	45a9                	li	a1,10
    800009d4:	6388                	ld	a0,0(a5)
    800009d6:	aabff0ef          	jal	80000480 <printint>
      i += 2;
    800009da:	0039849b          	addw	s1,s3,3
    800009de:	bdfd                	j	800008dc <printf_color+0x88>
      printint(va_arg(ap, uint32), 10, 0);
    800009e0:	f8843783          	ld	a5,-120(s0)
    800009e4:	00878713          	add	a4,a5,8
    800009e8:	f8e43423          	sd	a4,-120(s0)
    800009ec:	4601                	li	a2,0
    800009ee:	45a9                	li	a1,10
    800009f0:	0007e503          	lwu	a0,0(a5)
    800009f4:	a8dff0ef          	jal	80000480 <printint>
    800009f8:	b5d5                	j	800008dc <printf_color+0x88>
      printint(va_arg(ap, uint64), 10, 0);
    800009fa:	f8843783          	ld	a5,-120(s0)
    800009fe:	00878713          	add	a4,a5,8
    80000a02:	f8e43423          	sd	a4,-120(s0)
    80000a06:	4601                	li	a2,0
    80000a08:	45a9                	li	a1,10
    80000a0a:	6388                	ld	a0,0(a5)
    80000a0c:	a75ff0ef          	jal	80000480 <printint>
      i += 1;
    80000a10:	0029849b          	addw	s1,s3,2
    80000a14:	b5e1                	j	800008dc <printf_color+0x88>
      printint(va_arg(ap, uint64), 10, 0);
    80000a16:	f8843783          	ld	a5,-120(s0)
    80000a1a:	00878713          	add	a4,a5,8
    80000a1e:	f8e43423          	sd	a4,-120(s0)
    80000a22:	4601                	li	a2,0
    80000a24:	45a9                	li	a1,10
    80000a26:	6388                	ld	a0,0(a5)
    80000a28:	a59ff0ef          	jal	80000480 <printint>
      i += 2;
    80000a2c:	0039849b          	addw	s1,s3,3
    80000a30:	b575                	j	800008dc <printf_color+0x88>
      printint(va_arg(ap, uint32), 16, 0);
    80000a32:	f8843783          	ld	a5,-120(s0)
    80000a36:	00878713          	add	a4,a5,8
    80000a3a:	f8e43423          	sd	a4,-120(s0)
    80000a3e:	4601                	li	a2,0
    80000a40:	45c1                	li	a1,16
    80000a42:	0007e503          	lwu	a0,0(a5)
    80000a46:	a3bff0ef          	jal	80000480 <printint>
    80000a4a:	bd49                	j	800008dc <printf_color+0x88>
      printint(va_arg(ap, uint64), 16, 0);
    80000a4c:	f8843783          	ld	a5,-120(s0)
    80000a50:	00878713          	add	a4,a5,8
    80000a54:	f8e43423          	sd	a4,-120(s0)
    80000a58:	4601                	li	a2,0
    80000a5a:	45c1                	li	a1,16
    80000a5c:	6388                	ld	a0,0(a5)
    80000a5e:	a23ff0ef          	jal	80000480 <printint>
      i += 1;
    80000a62:	0029849b          	addw	s1,s3,2
    80000a66:	bd9d                	j	800008dc <printf_color+0x88>
      printptr(va_arg(ap, uint64));
    80000a68:	f8843783          	ld	a5,-120(s0)
    80000a6c:	00878713          	add	a4,a5,8
    80000a70:	f8e43423          	sd	a4,-120(s0)
    80000a74:	6388                	ld	a0,0(a5)
    80000a76:	a8fff0ef          	jal	80000504 <printptr>
    80000a7a:	b58d                	j	800008dc <printf_color+0x88>
      consputc(va_arg(ap, uint));
    80000a7c:	f8843783          	ld	a5,-120(s0)
    80000a80:	00878713          	add	a4,a5,8
    80000a84:	f8e43423          	sd	a4,-120(s0)
    80000a88:	4388                	lw	a0,0(a5)
    80000a8a:	f90ff0ef          	jal	8000021a <consputc>
    80000a8e:	b5b9                	j	800008dc <printf_color+0x88>
      if((s = va_arg(ap, char*)) == 0)
    80000a90:	f8843783          	ld	a5,-120(s0)
    80000a94:	00878713          	add	a4,a5,8
    80000a98:	f8e43423          	sd	a4,-120(s0)
    80000a9c:	0007b903          	ld	s2,0(a5)
    80000aa0:	00090d63          	beqz	s2,80000aba <printf_color+0x266>
      for(; *s; s++)
    80000aa4:	00094503          	lbu	a0,0(s2)
    80000aa8:	e2050ae3          	beqz	a0,800008dc <printf_color+0x88>
        consputc(*s);
    80000aac:	f6eff0ef          	jal	8000021a <consputc>
      for(; *s; s++)
    80000ab0:	0905                	add	s2,s2,1
    80000ab2:	00094503          	lbu	a0,0(s2)
    80000ab6:	f97d                	bnez	a0,80000aac <printf_color+0x258>
    80000ab8:	b515                	j	800008dc <printf_color+0x88>
        s = "(null)";
    80000aba:	00002917          	auipc	s2,0x2
    80000abe:	6b690913          	add	s2,s2,1718 # 80003170 <etext+0x170>
      for(; *s; s++)
    80000ac2:	02800513          	li	a0,40
    80000ac6:	b7dd                	j	80000aac <printf_color+0x258>

  }

  va_end(ap);

  if(panicking == 0)
    80000ac8:	00003797          	auipc	a5,0x3
    80000acc:	a107a783          	lw	a5,-1520(a5) # 800034d8 <panicking>
    80000ad0:	cb85                	beqz	a5,80000b00 <printf_color+0x2ac>
    release(&pr.lock);

   printf("\033[%dm",0);
    80000ad2:	4581                	li	a1,0
    80000ad4:	00002517          	auipc	a0,0x2
    80000ad8:	6c450513          	add	a0,a0,1732 # 80003198 <etext+0x198>
    80000adc:	a77ff0ef          	jal	80000552 <printf>

    return 0;
}
    80000ae0:	4501                	li	a0,0
    80000ae2:	70e6                	ld	ra,120(sp)
    80000ae4:	7446                	ld	s0,112(sp)
    80000ae6:	74a6                	ld	s1,104(sp)
    80000ae8:	7906                	ld	s2,96(sp)
    80000aea:	69e6                	ld	s3,88(sp)
    80000aec:	6a46                	ld	s4,80(sp)
    80000aee:	6aa6                	ld	s5,72(sp)
    80000af0:	6b06                	ld	s6,64(sp)
    80000af2:	7be2                	ld	s7,56(sp)
    80000af4:	7c42                	ld	s8,48(sp)
    80000af6:	7ca2                	ld	s9,40(sp)
    80000af8:	7d02                	ld	s10,32(sp)
    80000afa:	6de2                	ld	s11,24(sp)
    80000afc:	614d                	add	sp,sp,176
    80000afe:	8082                	ret
    release(&pr.lock);
    80000b00:	00006517          	auipc	a0,0x6
    80000b04:	ab850513          	add	a0,a0,-1352 # 800065b8 <pr>
    80000b08:	18c000ef          	jal	80000c94 <release>
    80000b0c:	b7d9                	j	80000ad2 <printf_color+0x27e>

0000000080000b0e <panic>:



void 
panic(char *c){
    80000b0e:	1101                	add	sp,sp,-32
    80000b10:	ec06                	sd	ra,24(sp)
    80000b12:	e822                	sd	s0,16(sp)
    80000b14:	e426                	sd	s1,8(sp)
    80000b16:	e04a                	sd	s2,0(sp)
    80000b18:	1000                	add	s0,sp,32
    80000b1a:	84aa                	mv	s1,a0
    panicking = 1;
    80000b1c:	4905                	li	s2,1
    80000b1e:	00003797          	auipc	a5,0x3
    80000b22:	9b27ad23          	sw	s2,-1606(a5) # 800034d8 <panicking>
    printf("\n!!!\npanic:\n");
    80000b26:	00002517          	auipc	a0,0x2
    80000b2a:	67a50513          	add	a0,a0,1658 # 800031a0 <etext+0x1a0>
    80000b2e:	a25ff0ef          	jal	80000552 <printf>
    printf("%s\n!!!\n", c);
    80000b32:	85a6                	mv	a1,s1
    80000b34:	00002517          	auipc	a0,0x2
    80000b38:	67c50513          	add	a0,a0,1660 # 800031b0 <etext+0x1b0>
    80000b3c:	a17ff0ef          	jal	80000552 <printf>
    panicked = 1;
    80000b40:	00003797          	auipc	a5,0x3
    80000b44:	9927aa23          	sw	s2,-1644(a5) # 800034d4 <panicked>
    for(;;)
    80000b48:	a001                	j	80000b48 <panic+0x3a>

0000000080000b4a <printfinit>:
    ;
}

void printfinit(void){
    80000b4a:	1141                	add	sp,sp,-16
    80000b4c:	e406                	sd	ra,8(sp)
    80000b4e:	e022                	sd	s0,0(sp)
    80000b50:	0800                	add	s0,sp,16
    initlock(&pr.lock, "pr");
    80000b52:	00002597          	auipc	a1,0x2
    80000b56:	66658593          	add	a1,a1,1638 # 800031b8 <etext+0x1b8>
    80000b5a:	00006517          	auipc	a0,0x6
    80000b5e:	a5e50513          	add	a0,a0,-1442 # 800065b8 <pr>
    80000b62:	036000ef          	jal	80000b98 <initlock>
}
    80000b66:	60a2                	ld	ra,8(sp)
    80000b68:	6402                	ld	s0,0(sp)
    80000b6a:	0141                	add	sp,sp,16
    80000b6c:	8082                	ret

0000000080000b6e <holding>:


// 检查是否持有这个锁
// 要需要提前关闭中断
int holding(struct spinlock* lk){
    return (lk->locked && lk->cpu == mycpu());
    80000b6e:	411c                	lw	a5,0(a0)
    80000b70:	e399                	bnez	a5,80000b76 <holding+0x8>
    80000b72:	4501                	li	a0,0
}
    80000b74:	8082                	ret
int holding(struct spinlock* lk){
    80000b76:	1101                	add	sp,sp,-32
    80000b78:	ec06                	sd	ra,24(sp)
    80000b7a:	e822                	sd	s0,16(sp)
    80000b7c:	e426                	sd	s1,8(sp)
    80000b7e:	1000                	add	s0,sp,32
    return (lk->locked && lk->cpu == mycpu());
    80000b80:	6904                	ld	s1,16(a0)
    80000b82:	6bd000ef          	jal	80001a3e <mycpu>
    80000b86:	40a48533          	sub	a0,s1,a0
    80000b8a:	00153513          	seqz	a0,a0
}
    80000b8e:	60e2                	ld	ra,24(sp)
    80000b90:	6442                	ld	s0,16(sp)
    80000b92:	64a2                	ld	s1,8(sp)
    80000b94:	6105                	add	sp,sp,32
    80000b96:	8082                	ret

0000000080000b98 <initlock>:

// 锁初始化
void 
initlock(struct spinlock* lk, char* name){
    80000b98:	1141                	add	sp,sp,-16
    80000b9a:	e422                	sd	s0,8(sp)
    80000b9c:	0800                	add	s0,sp,16
    lk->name = name;
    80000b9e:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
    80000ba0:	00052023          	sw	zero,0(a0)
    lk->cpu = 0;
    80000ba4:	00053823          	sd	zero,16(a0)
}
    80000ba8:	6422                	ld	s0,8(sp)
    80000baa:	0141                	add	sp,sp,16
    80000bac:	8082                	ret

0000000080000bae <push_off>:
    pop_off();
}

void
push_off(void)
{
    80000bae:	1101                	add	sp,sp,-32
    80000bb0:	ec06                	sd	ra,24(sp)
    80000bb2:	e822                	sd	s0,16(sp)
    80000bb4:	e426                	sd	s1,8(sp)
    80000bb6:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bb8:	100024f3          	csrr	s1,sstatus
    80000bbc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bc0:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bc2:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    80000bc6:	679000ef          	jal	80001a3e <mycpu>
    80000bca:	593c                	lw	a5,112(a0)
    80000bcc:	cb99                	beqz	a5,80000be2 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bce:	671000ef          	jal	80001a3e <mycpu>
    80000bd2:	593c                	lw	a5,112(a0)
    80000bd4:	2785                	addw	a5,a5,1
    80000bd6:	d93c                	sw	a5,112(a0)
}
    80000bd8:	60e2                	ld	ra,24(sp)
    80000bda:	6442                	ld	s0,16(sp)
    80000bdc:	64a2                	ld	s1,8(sp)
    80000bde:	6105                	add	sp,sp,32
    80000be0:	8082                	ret
    mycpu()->intena = old;
    80000be2:	65d000ef          	jal	80001a3e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000be6:	8085                	srl	s1,s1,0x1
    80000be8:	8885                	and	s1,s1,1
    80000bea:	d964                	sw	s1,116(a0)
    80000bec:	b7cd                	j	80000bce <push_off+0x20>

0000000080000bee <acquire>:
acquire(struct spinlock* lk){
    80000bee:	1101                	add	sp,sp,-32
    80000bf0:	ec06                	sd	ra,24(sp)
    80000bf2:	e822                	sd	s0,16(sp)
    80000bf4:	e426                	sd	s1,8(sp)
    80000bf6:	1000                	add	s0,sp,32
    80000bf8:	84aa                	mv	s1,a0
    push_off(); // 关闭中断 避免死锁
    80000bfa:	fb5ff0ef          	jal	80000bae <push_off>
    if(holding(lk))
    80000bfe:	8526                	mv	a0,s1
    80000c00:	f6fff0ef          	jal	80000b6e <holding>
    80000c04:	e10d                	bnez	a0,80000c26 <acquire+0x38>
    while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c06:	4705                	li	a4,1
    80000c08:	87ba                	mv	a5,a4
    80000c0a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c0e:	2781                	sext.w	a5,a5
    80000c10:	ffe5                	bnez	a5,80000c08 <acquire+0x1a>
    __sync_synchronize();
    80000c12:	0ff0000f          	fence
    lk->cpu = mycpu();
    80000c16:	629000ef          	jal	80001a3e <mycpu>
    80000c1a:	e888                	sd	a0,16(s1)
}
    80000c1c:	60e2                	ld	ra,24(sp)
    80000c1e:	6442                	ld	s0,16(sp)
    80000c20:	64a2                	ld	s1,8(sp)
    80000c22:	6105                	add	sp,sp,32
    80000c24:	8082                	ret
        panic("acquire");
    80000c26:	00002517          	auipc	a0,0x2
    80000c2a:	5b250513          	add	a0,a0,1458 # 800031d8 <digits+0x18>
    80000c2e:	ee1ff0ef          	jal	80000b0e <panic>
    80000c32:	bfd1                	j	80000c06 <acquire+0x18>

0000000080000c34 <pop_off>:

void
pop_off(void)
{
    80000c34:	1101                	add	sp,sp,-32
    80000c36:	ec06                	sd	ra,24(sp)
    80000c38:	e822                	sd	s0,16(sp)
    80000c3a:	e426                	sd	s1,8(sp)
    80000c3c:	1000                	add	s0,sp,32
  struct cpu *c = mycpu();
    80000c3e:	601000ef          	jal	80001a3e <mycpu>
    80000c42:	84aa                	mv	s1,a0
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c44:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c48:	8b89                	and	a5,a5,2
  if(intr_get())
    80000c4a:	e79d                	bnez	a5,80000c78 <pop_off+0x44>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c4c:	58bc                	lw	a5,112(s1)
    80000c4e:	02f05c63          	blez	a5,80000c86 <pop_off+0x52>
    panic("pop_off");
  c->noff -= 1;
    80000c52:	58bc                	lw	a5,112(s1)
    80000c54:	37fd                	addw	a5,a5,-1
    80000c56:	0007871b          	sext.w	a4,a5
    80000c5a:	d8bc                	sw	a5,112(s1)
  if(c->noff == 0 && c->intena)
    80000c5c:	eb09                	bnez	a4,80000c6e <pop_off+0x3a>
    80000c5e:	58fc                	lw	a5,116(s1)
    80000c60:	c799                	beqz	a5,80000c6e <pop_off+0x3a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c62:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c66:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c6a:	10079073          	csrw	sstatus,a5
    intr_on();
    80000c6e:	60e2                	ld	ra,24(sp)
    80000c70:	6442                	ld	s0,16(sp)
    80000c72:	64a2                	ld	s1,8(sp)
    80000c74:	6105                	add	sp,sp,32
    80000c76:	8082                	ret
    panic("pop_off - interruptible");
    80000c78:	00002517          	auipc	a0,0x2
    80000c7c:	56850513          	add	a0,a0,1384 # 800031e0 <digits+0x20>
    80000c80:	e8fff0ef          	jal	80000b0e <panic>
    80000c84:	b7e1                	j	80000c4c <pop_off+0x18>
    panic("pop_off");
    80000c86:	00002517          	auipc	a0,0x2
    80000c8a:	57250513          	add	a0,a0,1394 # 800031f8 <digits+0x38>
    80000c8e:	e81ff0ef          	jal	80000b0e <panic>
    80000c92:	b7c1                	j	80000c52 <pop_off+0x1e>

0000000080000c94 <release>:
void release(struct spinlock* lk){
    80000c94:	1101                	add	sp,sp,-32
    80000c96:	ec06                	sd	ra,24(sp)
    80000c98:	e822                	sd	s0,16(sp)
    80000c9a:	e426                	sd	s1,8(sp)
    80000c9c:	1000                	add	s0,sp,32
    80000c9e:	84aa                	mv	s1,a0
    if(!holding(lk))
    80000ca0:	ecfff0ef          	jal	80000b6e <holding>
    80000ca4:	c105                	beqz	a0,80000cc4 <release+0x30>
    lk->cpu = 0;
    80000ca6:	0004b823          	sd	zero,16(s1)
    __sync_synchronize();
    80000caa:	0ff0000f          	fence
    __sync_lock_release(&lk->locked);
    80000cae:	0f50000f          	fence	iorw,ow
    80000cb2:	0804a02f          	amoswap.w	zero,zero,(s1)
    pop_off();
    80000cb6:	f7fff0ef          	jal	80000c34 <pop_off>
}
    80000cba:	60e2                	ld	ra,24(sp)
    80000cbc:	6442                	ld	s0,16(sp)
    80000cbe:	64a2                	ld	s1,8(sp)
    80000cc0:	6105                	add	sp,sp,32
    80000cc2:	8082                	ret
        panic("release");
    80000cc4:	00002517          	auipc	a0,0x2
    80000cc8:	53c50513          	add	a0,a0,1340 # 80003200 <digits+0x40>
    80000ccc:	e43ff0ef          	jal	80000b0e <panic>
    80000cd0:	bfd9                	j	80000ca6 <release+0x12>

0000000080000cd2 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cd2:	1141                	add	sp,sp,-16
    80000cd4:	e422                	sd	s0,8(sp)
    80000cd6:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cd8:	ca19                	beqz	a2,80000cee <memset+0x1c>
    80000cda:	87aa                	mv	a5,a0
    80000cdc:	1602                	sll	a2,a2,0x20
    80000cde:	9201                	srl	a2,a2,0x20
    80000ce0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000ce4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000ce8:	0785                	add	a5,a5,1
    80000cea:	fee79de3          	bne	a5,a4,80000ce4 <memset+0x12>
  }
  return dst;
}
    80000cee:	6422                	ld	s0,8(sp)
    80000cf0:	0141                	add	sp,sp,16
    80000cf2:	8082                	ret

0000000080000cf4 <addr>:
#define BLK_SIZE(k)   ((1L << (k)) * LEAF_SIZE)     // 第k种索引的块的大小
#define HEAP_SIZE     BLK_SIZE(MAXSIZE)             // 整个内存空间的大小 当然这里就是最大的种类的大小
#define NBLK(k)      (HEAP_SIZE / BLK_SIZE(k))      // 第k种索引的块的数量
#define ROUNDUP(n, sz)  (((((n)-1)/(sz))+1)*(sz))   // 向上取整

void* addr(int k, int bi){
    80000cf4:	1141                	add	sp,sp,-16
    80000cf6:	e422                	sd	s0,8(sp)
    80000cf8:	0800                	add	s0,sp,16
  int n = bi * BLK_SIZE(k);
    80000cfa:	6785                	lui	a5,0x1
    80000cfc:	00a797b3          	sll	a5,a5,a0
  return (char*) bd_base +n ;
    80000d00:	02b787bb          	mulw	a5,a5,a1
}
    80000d04:	00002517          	auipc	a0,0x2
    80000d08:	7e453503          	ld	a0,2020(a0) # 800034e8 <bd_base>
    80000d0c:	953e                	add	a0,a0,a5
    80000d0e:	6422                	ld	s0,8(sp)
    80000d10:	0141                	add	sp,sp,16
    80000d12:	8082                	ret

0000000080000d14 <blk_index>:

// 计算地址addr在第k种索引中的块的编号
int 
blk_index(int k, void *addr) {
    80000d14:	1141                	add	sp,sp,-16
    80000d16:	e422                	sd	s0,8(sp)
    80000d18:	0800                	add	s0,sp,16
  return ((uint64)addr - (uint64)bd_base) / BLK_SIZE(k);
    80000d1a:	00002797          	auipc	a5,0x2
    80000d1e:	7ce7b783          	ld	a5,1998(a5) # 800034e8 <bd_base>
    80000d22:	8d9d                	sub	a1,a1,a5
    80000d24:	2531                	addw	a0,a0,12
    80000d26:	00a5d533          	srl	a0,a1,a0
}
    80000d2a:	2501                	sext.w	a0,a0
    80000d2c:	6422                	ld	s0,8(sp)
    80000d2e:	0141                	add	sp,sp,16
    80000d30:	8082                	ret

0000000080000d32 <bit_isset>:

int 
bit_isset(char* bitmap, int index){
    80000d32:	1141                	add	sp,sp,-16
    80000d34:	e422                	sd	s0,8(sp)
    80000d36:	0800                	add	s0,sp,16
  char b = bitmap[index/8];
  char m = (1 << (index % 8));
    80000d38:	0075f793          	and	a5,a1,7
    80000d3c:	4705                	li	a4,1
    80000d3e:	00f7173b          	sllw	a4,a4,a5
  char b = bitmap[index/8];
    80000d42:	41f5d79b          	sraw	a5,a1,0x1f
    80000d46:	01d7d79b          	srlw	a5,a5,0x1d
    80000d4a:	9fad                	addw	a5,a5,a1
    80000d4c:	4037d79b          	sraw	a5,a5,0x3
    80000d50:	953e                	add	a0,a0,a5
  return (b & m) == m;
    80000d52:	00054503          	lbu	a0,0(a0)
    80000d56:	8d79                	and	a0,a0,a4
    80000d58:	0ff77713          	zext.b	a4,a4
    80000d5c:	8d19                	sub	a0,a0,a4
}
    80000d5e:	00153513          	seqz	a0,a0
    80000d62:	6422                	ld	s0,8(sp)
    80000d64:	0141                	add	sp,sp,16
    80000d66:	8082                	ret

0000000080000d68 <bit_set>:

void bit_set(char* bitmap,int index){
    80000d68:	1141                	add	sp,sp,-16
    80000d6a:	e422                	sd	s0,8(sp)
    80000d6c:	0800                	add	s0,sp,16
  char b = bitmap[index/8];
    80000d6e:	41f5d79b          	sraw	a5,a1,0x1f
    80000d72:	01d7d79b          	srlw	a5,a5,0x1d
    80000d76:	9fad                	addw	a5,a5,a1
    80000d78:	4037d79b          	sraw	a5,a5,0x3
    80000d7c:	953e                	add	a0,a0,a5
  char m = (1 <<(index % 8));
    80000d7e:	899d                	and	a1,a1,7
    80000d80:	4705                	li	a4,1
    80000d82:	00b7173b          	sllw	a4,a4,a1
  bitmap[index / 8] = (b | m);
    80000d86:	00054783          	lbu	a5,0(a0)
    80000d8a:	8fd9                	or	a5,a5,a4
    80000d8c:	00f50023          	sb	a5,0(a0)
}
    80000d90:	6422                	ld	s0,8(sp)
    80000d92:	0141                	add	sp,sp,16
    80000d94:	8082                	ret

0000000080000d96 <bit_clear>:

// Clear bit at position index in array
void bit_clear(char *bitmap, int index) {
    80000d96:	1141                	add	sp,sp,-16
    80000d98:	e422                	sd	s0,8(sp)
    80000d9a:	0800                	add	s0,sp,16
  char b = bitmap[index/8];
    80000d9c:	41f5d79b          	sraw	a5,a1,0x1f
    80000da0:	01d7d79b          	srlw	a5,a5,0x1d
    80000da4:	9fad                	addw	a5,a5,a1
    80000da6:	4037d79b          	sraw	a5,a5,0x3
    80000daa:	953e                	add	a0,a0,a5
  char m = (1 << (index % 8));
    80000dac:	899d                	and	a1,a1,7
    80000dae:	4785                	li	a5,1
    80000db0:	00b797bb          	sllw	a5,a5,a1
  bitmap[index/8] = (b & ~m);
    80000db4:	fff7c793          	not	a5,a5
    80000db8:	00054703          	lbu	a4,0(a0)
    80000dbc:	8ff9                	and	a5,a5,a4
    80000dbe:	00f50023          	sb	a5,0(a0)
}
    80000dc2:	6422                	ld	s0,8(sp)
    80000dc4:	0141                	add	sp,sp,16
    80000dc6:	8082                	ret

0000000080000dc8 <blk_index_next>:

// 计算地址addr在第k种索引中的下一个块的编号
int 
blk_index_next(int k, void *addr) {
    80000dc8:	1141                	add	sp,sp,-16
    80000dca:	e422                	sd	s0,8(sp)
    80000dcc:	0800                	add	s0,sp,16
    80000dce:	872a                	mv	a4,a0
  return ((uint64)addr - (uint64)bd_base) / BLK_SIZE(k);
    80000dd0:	00002797          	auipc	a5,0x2
    80000dd4:	7187b783          	ld	a5,1816(a5) # 800034e8 <bd_base>
    80000dd8:	8d9d                	sub	a1,a1,a5
    80000dda:	00c5079b          	addw	a5,a0,12
    80000dde:	00f5d7b3          	srl	a5,a1,a5
    80000de2:	0007851b          	sext.w	a0,a5
    int n = blk_index(k, addr);
    if(((uint64)addr - (uint64)bd_base) % BLK_SIZE(k) != 0)
    80000de6:	6785                	lui	a5,0x1
    80000de8:	00e797b3          	sll	a5,a5,a4
    80000dec:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000dee:	8fed                	and	a5,a5,a1
    80000df0:	c391                	beqz	a5,80000df4 <blk_index_next+0x2c>
        n++;
    80000df2:	2505                	addw	a0,a0,1
    return n;
}
    80000df4:	6422                	ld	s0,8(sp)
    80000df6:	0141                	add	sp,sp,16
    80000df8:	8082                	ret

0000000080000dfa <bd_initfree_pair>:

// 如果一个块被标记为已经分配并且他的伙伴没有被分配，
// 那么把他的伙伴放在放在第k的伙伴列表上
// 如何两者都没有被分配，那么直接跳过并且返回空间 0
int
bd_initfree_pair(int k, int bi) {
    80000dfa:	7139                	add	sp,sp,-64
    80000dfc:	fc06                	sd	ra,56(sp)
    80000dfe:	f822                	sd	s0,48(sp)
    80000e00:	f426                	sd	s1,40(sp)
    80000e02:	f04a                	sd	s2,32(sp)
    80000e04:	ec4e                	sd	s3,24(sp)
    80000e06:	e852                	sd	s4,16(sp)
    80000e08:	e456                	sd	s5,8(sp)
    80000e0a:	e05a                	sd	s6,0(sp)
    80000e0c:	0080                	add	s0,sp,64
    80000e0e:	8a2a                	mv	s4,a0
    80000e10:	84ae                	mv	s1,a1
  int buddy = (bi % 2 == 0) ? bi+1 : bi-1;
    80000e12:	0015f793          	and	a5,a1,1
    80000e16:	e7a5                	bnez	a5,80000e7e <bd_initfree_pair+0x84>
    80000e18:	00158b1b          	addw	s6,a1,1
  int free = 0;
  // 检查在两个伙伴之间在bitmap中的状态是否相同。
  if(bit_isset(bd_sizes[k].alloc, bi) !=  bit_isset(bd_sizes[k].alloc, buddy)) {
    80000e1c:	005a1793          	sll	a5,s4,0x5
    80000e20:	00002917          	auipc	s2,0x2
    80000e24:	6c093903          	ld	s2,1728(s2) # 800034e0 <bd_sizes>
    80000e28:	993e                	add	s2,s2,a5
    80000e2a:	01093a83          	ld	s5,16(s2)
    80000e2e:	85a6                	mv	a1,s1
    80000e30:	8556                	mv	a0,s5
    80000e32:	f01ff0ef          	jal	80000d32 <bit_isset>
    80000e36:	89aa                	mv	s3,a0
    80000e38:	85da                	mv	a1,s6
    80000e3a:	8556                	mv	a0,s5
    80000e3c:	ef7ff0ef          	jal	80000d32 <bit_isset>
  int free = 0;
    80000e40:	4a81                	li	s5,0
  if(bit_isset(bd_sizes[k].alloc, bi) !=  bit_isset(bd_sizes[k].alloc, buddy)) {
    80000e42:	02a98363          	beq	s3,a0,80000e68 <bd_initfree_pair+0x6e>
    free = BLK_SIZE(k);
    80000e46:	6585                	lui	a1,0x1
    80000e48:	014595b3          	sll	a1,a1,s4
    80000e4c:	00058a9b          	sext.w	s5,a1
    if(bit_isset(bd_sizes[k].alloc, bi))
    80000e50:	02098a63          	beqz	s3,80000e84 <bd_initfree_pair+0x8a>
  return (char*) bd_base +n ;
    80000e54:	036585bb          	mulw	a1,a1,s6
      lst_push(&bd_sizes[k].free, addr(k, buddy));   // put buddy on free list
    80000e58:	00002797          	auipc	a5,0x2
    80000e5c:	6907b783          	ld	a5,1680(a5) # 800034e8 <bd_base>
    80000e60:	95be                	add	a1,a1,a5
    80000e62:	854a                	mv	a0,s2
    80000e64:	d70ff0ef          	jal	800003d4 <lst_push>
    else
      lst_push(&bd_sizes[k].free, addr(k, bi));      // put bi on free list
  }
  return free;
}
    80000e68:	8556                	mv	a0,s5
    80000e6a:	70e2                	ld	ra,56(sp)
    80000e6c:	7442                	ld	s0,48(sp)
    80000e6e:	74a2                	ld	s1,40(sp)
    80000e70:	7902                	ld	s2,32(sp)
    80000e72:	69e2                	ld	s3,24(sp)
    80000e74:	6a42                	ld	s4,16(sp)
    80000e76:	6aa2                	ld	s5,8(sp)
    80000e78:	6b02                	ld	s6,0(sp)
    80000e7a:	6121                	add	sp,sp,64
    80000e7c:	8082                	ret
  int buddy = (bi % 2 == 0) ? bi+1 : bi-1;
    80000e7e:	fff58b1b          	addw	s6,a1,-1 # fff <_entry-0x7ffff001>
    80000e82:	bf69                	j	80000e1c <bd_initfree_pair+0x22>
  return (char*) bd_base +n ;
    80000e84:	029585bb          	mulw	a1,a1,s1
      lst_push(&bd_sizes[k].free, addr(k, bi));      // put bi on free list
    80000e88:	00002797          	auipc	a5,0x2
    80000e8c:	6607b783          	ld	a5,1632(a5) # 800034e8 <bd_base>
    80000e90:	95be                	add	a1,a1,a5
    80000e92:	854a                	mv	a0,s2
    80000e94:	d40ff0ef          	jal	800003d4 <lst_push>
    80000e98:	bfc1                	j	80000e68 <bd_initfree_pair+0x6e>

0000000080000e9a <bd_initfree>:

// 将bd_left到bd_right之间的所有空间标注为没有使用
int 
bd_initfree(void* bd_left, void* bd_right){
    80000e9a:	711d                	add	sp,sp,-96
    80000e9c:	ec86                	sd	ra,88(sp)
    80000e9e:	e8a2                	sd	s0,80(sp)
    80000ea0:	e4a6                	sd	s1,72(sp)
    80000ea2:	e0ca                	sd	s2,64(sp)
    80000ea4:	fc4e                	sd	s3,56(sp)
    80000ea6:	f852                	sd	s4,48(sp)
    80000ea8:	f456                	sd	s5,40(sp)
    80000eaa:	f05a                	sd	s6,32(sp)
    80000eac:	ec5e                	sd	s7,24(sp)
    80000eae:	e862                	sd	s8,16(sp)
    80000eb0:	e466                	sd	s9,8(sp)
    80000eb2:	1080                	add	s0,sp,96
  int free = 0 ;

  for(int k = 0; k < MAXSIZE; k++){
    80000eb4:	00002717          	auipc	a4,0x2
    80000eb8:	63c72703          	lw	a4,1596(a4) # 800034f0 <nsizes>
    80000ebc:	4785                	li	a5,1
    80000ebe:	06e7d463          	bge	a5,a4,80000f26 <bd_initfree+0x8c>
    80000ec2:	8aaa                	mv	s5,a0
    80000ec4:	8b2e                	mv	s6,a1
    80000ec6:	4901                	li	s2,0
  int free = 0 ;
    80000ec8:	4a01                	li	s4,0
  return ((uint64)addr - (uint64)bd_base) / BLK_SIZE(k);
    80000eca:	00002c17          	auipc	s8,0x2
    80000ece:	61ec0c13          	add	s8,s8,1566 # 800034e8 <bd_base>
  for(int k = 0; k < MAXSIZE; k++){
    80000ed2:	00002b97          	auipc	s7,0x2
    80000ed6:	61eb8b93          	add	s7,s7,1566 # 800034f0 <nsizes>
    80000eda:	a039                	j	80000ee8 <bd_initfree+0x4e>
    80000edc:	2905                	addw	s2,s2,1
    80000ede:	000ba783          	lw	a5,0(s7)
    80000ee2:	37fd                	addw	a5,a5,-1
    80000ee4:	04f95263          	bge	s2,a5,80000f28 <bd_initfree+0x8e>
    int left = blk_index_next(k, bd_left);
    80000ee8:	85d6                	mv	a1,s5
    80000eea:	854a                	mv	a0,s2
    80000eec:	eddff0ef          	jal	80000dc8 <blk_index_next>
    80000ef0:	89aa                	mv	s3,a0
  return ((uint64)addr - (uint64)bd_base) / BLK_SIZE(k);
    80000ef2:	000c3483          	ld	s1,0(s8)
    80000ef6:	409b04b3          	sub	s1,s6,s1
    80000efa:	00c9079b          	addw	a5,s2,12
    80000efe:	00f4d4b3          	srl	s1,s1,a5
    80000f02:	2481                	sext.w	s1,s1
    int right = blk_index(k, bd_right);
    free += bd_initfree_pair(k, left);
    80000f04:	85aa                	mv	a1,a0
    80000f06:	854a                	mv	a0,s2
    80000f08:	ef3ff0ef          	jal	80000dfa <bd_initfree_pair>
    80000f0c:	01450cbb          	addw	s9,a0,s4
    80000f10:	000c8a1b          	sext.w	s4,s9

    if(right <= left)
    80000f14:	fc99d4e3          	bge	s3,s1,80000edc <bd_initfree+0x42>
      continue;
    free += bd_initfree_pair(k, right);
    80000f18:	85a6                	mv	a1,s1
    80000f1a:	854a                	mv	a0,s2
    80000f1c:	edfff0ef          	jal	80000dfa <bd_initfree_pair>
    80000f20:	00ac8a3b          	addw	s4,s9,a0
    80000f24:	bf65                	j	80000edc <bd_initfree+0x42>
  int free = 0 ;
    80000f26:	4a01                	li	s4,0

  }
  return free;
}
    80000f28:	8552                	mv	a0,s4
    80000f2a:	60e6                	ld	ra,88(sp)
    80000f2c:	6446                	ld	s0,80(sp)
    80000f2e:	64a6                	ld	s1,72(sp)
    80000f30:	6906                	ld	s2,64(sp)
    80000f32:	79e2                	ld	s3,56(sp)
    80000f34:	7a42                	ld	s4,48(sp)
    80000f36:	7aa2                	ld	s5,40(sp)
    80000f38:	7b02                	ld	s6,32(sp)
    80000f3a:	6be2                	ld	s7,24(sp)
    80000f3c:	6c42                	ld	s8,16(sp)
    80000f3e:	6ca2                	ld	s9,8(sp)
    80000f40:	6125                	add	sp,sp,96
    80000f42:	8082                	ret

0000000080000f44 <bd_mark>:

// 将[start, stop)范围内的内存标记为已经分配
void
bd_mark(void *start, void *stop)
{
    80000f44:	711d                	add	sp,sp,-96
    80000f46:	ec86                	sd	ra,88(sp)
    80000f48:	e8a2                	sd	s0,80(sp)
    80000f4a:	e4a6                	sd	s1,72(sp)
    80000f4c:	e0ca                	sd	s2,64(sp)
    80000f4e:	fc4e                	sd	s3,56(sp)
    80000f50:	f852                	sd	s4,48(sp)
    80000f52:	f456                	sd	s5,40(sp)
    80000f54:	f05a                	sd	s6,32(sp)
    80000f56:	ec5e                	sd	s7,24(sp)
    80000f58:	e862                	sd	s8,16(sp)
    80000f5a:	e466                	sd	s9,8(sp)
    80000f5c:	1080                	add	s0,sp,96
    80000f5e:	8b2a                	mv	s6,a0
    80000f60:	8bae                	mv	s7,a1
  int bi, bj;

  if (((uint64) start % LEAF_SIZE != 0) || ((uint64) stop % LEAF_SIZE != 0))
    80000f62:	00b567b3          	or	a5,a0,a1
    80000f66:	17d2                	sll	a5,a5,0x34
    80000f68:	c799                	beqz	a5,80000f76 <bd_mark+0x32>
    panic("bd_mark");
    80000f6a:	00002517          	auipc	a0,0x2
    80000f6e:	29e50513          	add	a0,a0,670 # 80003208 <digits+0x48>
    80000f72:	b9dff0ef          	jal	80000b0e <panic>

  for (int k = 0; k < nsizes; k++) {
    80000f76:	00002c17          	auipc	s8,0x2
    80000f7a:	57ac2c03          	lw	s8,1402(s8) # 800034f0 <nsizes>
    80000f7e:	07805763          	blez	s8,80000fec <bd_mark+0xa8>
    80000f82:	4901                	li	s2,0
    80000f84:	4981                	li	s3,0
  return ((uint64)addr - (uint64)bd_base) / BLK_SIZE(k);
    80000f86:	00002c97          	auipc	s9,0x2
    80000f8a:	562c8c93          	add	s9,s9,1378 # 800034e8 <bd_base>
    bj = blk_index_next(k, stop);
    for(; bi < bj; bi++) {
      if(k > 0) {
        // 这里很好理解 如果一个块被分配了
        // 那么他肯定不能再分割了
        bit_set(bd_sizes[k].split, bi);
    80000f8e:	00002a97          	auipc	s5,0x2
    80000f92:	552a8a93          	add	s5,s5,1362 # 800034e0 <bd_sizes>
    80000f96:	a815                	j	80000fca <bd_mark+0x86>
      }
      bit_set(bd_sizes[k].alloc, bi);
    80000f98:	000ab783          	ld	a5,0(s5)
    80000f9c:	97ca                	add	a5,a5,s2
    80000f9e:	85a6                	mv	a1,s1
    80000fa0:	6b88                	ld	a0,16(a5)
    80000fa2:	dc7ff0ef          	jal	80000d68 <bit_set>
    for(; bi < bj; bi++) {
    80000fa6:	2485                	addw	s1,s1,1
    80000fa8:	009a0c63          	beq	s4,s1,80000fc0 <bd_mark+0x7c>
      if(k > 0) {
    80000fac:	ff3056e3          	blez	s3,80000f98 <bd_mark+0x54>
        bit_set(bd_sizes[k].split, bi);
    80000fb0:	000ab783          	ld	a5,0(s5)
    80000fb4:	97ca                	add	a5,a5,s2
    80000fb6:	85a6                	mv	a1,s1
    80000fb8:	6f88                	ld	a0,24(a5)
    80000fba:	dafff0ef          	jal	80000d68 <bit_set>
    80000fbe:	bfe9                	j	80000f98 <bd_mark+0x54>
  for (int k = 0; k < nsizes; k++) {
    80000fc0:	2985                	addw	s3,s3,1
    80000fc2:	02090913          	add	s2,s2,32
    80000fc6:	03898363          	beq	s3,s8,80000fec <bd_mark+0xa8>
  return ((uint64)addr - (uint64)bd_base) / BLK_SIZE(k);
    80000fca:	000cb483          	ld	s1,0(s9)
    80000fce:	409b04b3          	sub	s1,s6,s1
    80000fd2:	00c9879b          	addw	a5,s3,12
    80000fd6:	00f4d4b3          	srl	s1,s1,a5
    80000fda:	2481                	sext.w	s1,s1
    bj = blk_index_next(k, stop);
    80000fdc:	85de                	mv	a1,s7
    80000fde:	854e                	mv	a0,s3
    80000fe0:	de9ff0ef          	jal	80000dc8 <blk_index_next>
    80000fe4:	8a2a                	mv	s4,a0
    for(; bi < bj; bi++) {
    80000fe6:	fca4c3e3          	blt	s1,a0,80000fac <bd_mark+0x68>
    80000fea:	bfd9                	j	80000fc0 <bd_mark+0x7c>
    }
  }
}
    80000fec:	60e6                	ld	ra,88(sp)
    80000fee:	6446                	ld	s0,80(sp)
    80000ff0:	64a6                	ld	s1,72(sp)
    80000ff2:	6906                	ld	s2,64(sp)
    80000ff4:	79e2                	ld	s3,56(sp)
    80000ff6:	7a42                	ld	s4,48(sp)
    80000ff8:	7aa2                	ld	s5,40(sp)
    80000ffa:	7b02                	ld	s6,32(sp)
    80000ffc:	6be2                	ld	s7,24(sp)
    80000ffe:	6c42                	ld	s8,16(sp)
    80001000:	6ca2                	ld	s9,8(sp)
    80001002:	6125                	add	sp,sp,96
    80001004:	8082                	ret

0000000080001006 <bd_mark_data_structures>:

// 将从bd_base到p的全部空间标记为已经使用
// 唯一的用处就是用来处理bd_sizes本身所占用的空间
// 返回这一段空间的大小
int
bd_mark_data_structures(char *p) {
    80001006:	7179                	add	sp,sp,-48
    80001008:	f406                	sd	ra,40(sp)
    8000100a:	f022                	sd	s0,32(sp)
    8000100c:	ec26                	sd	s1,24(sp)
    8000100e:	e84a                	sd	s2,16(sp)
    80001010:	e44e                	sd	s3,8(sp)
    80001012:	1800                	add	s0,sp,48
    80001014:	84aa                	mv	s1,a0
  int meta = p - (char*)bd_base; 
    80001016:	00002997          	auipc	s3,0x2
    8000101a:	4d298993          	add	s3,s3,1234 # 800034e8 <bd_base>
    8000101e:	0009b583          	ld	a1,0(s3)
    80001022:	40b5093b          	subw	s2,a0,a1
  printf("伙伴系统的从%p开始的%d字节为,总大小为%d字节的内存的元数据\n", (char*)bd_base, meta, BLK_SIZE(MAXSIZE));
    80001026:	00002797          	auipc	a5,0x2
    8000102a:	4ca7a783          	lw	a5,1226(a5) # 800034f0 <nsizes>
    8000102e:	37fd                	addw	a5,a5,-1
    80001030:	6685                	lui	a3,0x1
    80001032:	00f696b3          	sll	a3,a3,a5
    80001036:	864a                	mv	a2,s2
    80001038:	00002517          	auipc	a0,0x2
    8000103c:	1d850513          	add	a0,a0,472 # 80003210 <digits+0x50>
    80001040:	d12ff0ef          	jal	80000552 <printf>
  bd_mark(bd_base, p);
    80001044:	85a6                	mv	a1,s1
    80001046:	0009b503          	ld	a0,0(s3)
    8000104a:	efbff0ef          	jal	80000f44 <bd_mark>
  return meta;
}
    8000104e:	854a                	mv	a0,s2
    80001050:	70a2                	ld	ra,40(sp)
    80001052:	7402                	ld	s0,32(sp)
    80001054:	64e2                	ld	s1,24(sp)
    80001056:	6942                	ld	s2,16(sp)
    80001058:	69a2                	ld	s3,8(sp)
    8000105a:	6145                	add	sp,sp,48
    8000105c:	8082                	ret

000000008000105e <bd_mark_unavailable>:

// 这里直接把最后一段内存提取出来标记为无用
// 这里传入的两个参数是 自由空间的起始位置和他右侧的元数据的大小
int bd_mark_unavailable(void* end, void * left){
    8000105e:	7139                	add	sp,sp,-64
    80001060:	fc06                	sd	ra,56(sp)
    80001062:	f822                	sd	s0,48(sp)
    80001064:	f426                	sd	s1,40(sp)
    80001066:	f04a                	sd	s2,32(sp)
    80001068:	ec4e                	sd	s3,24(sp)
    8000106a:	e852                	sd	s4,16(sp)
    8000106c:	e456                	sd	s5,8(sp)
    8000106e:	0080                	add	s0,sp,64
    int unavailable = BLK_SIZE(MAXSIZE)-(end-bd_base);
    80001070:	00002717          	auipc	a4,0x2
    80001074:	48072703          	lw	a4,1152(a4) # 800034f0 <nsizes>
    80001078:	377d                	addw	a4,a4,-1
    8000107a:	6785                	lui	a5,0x1
    8000107c:	00e797b3          	sll	a5,a5,a4
    80001080:	00002717          	auipc	a4,0x2
    80001084:	46873703          	ld	a4,1128(a4) # 800034e8 <bd_base>
    80001088:	8d19                	sub	a0,a0,a4
    8000108a:	9f89                	subw	a5,a5,a0
    8000108c:	0007849b          	sext.w	s1,a5
    if(unavailable > 0)
    80001090:	00905d63          	blez	s1,800010aa <bd_mark_unavailable+0x4c>
        unavailable = ROUNDUP(unavailable, LEAF_SIZE);
    80001094:	37fd                	addw	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001096:	41f7d49b          	sraw	s1,a5,0x1f
    8000109a:	0144d49b          	srlw	s1,s1,0x14
    8000109e:	9cbd                	addw	s1,s1,a5
    800010a0:	40c4d49b          	sraw	s1,s1,0xc
    800010a4:	2485                	addw	s1,s1,1
    800010a6:	00c4949b          	sllw	s1,s1,0xc
    printf("bd: 0x%x bytes unavailable\n", unavailable);
    800010aa:	85a6                	mv	a1,s1
    800010ac:	00002517          	auipc	a0,0x2
    800010b0:	1bc50513          	add	a0,a0,444 # 80003268 <digits+0xa8>
    800010b4:	c9eff0ef          	jal	80000552 <printf>

    // 标记可以使用的内存
    // 这里的 unavailable就是 由于需要向上取整而实际上无效的空间
    void *bd_end = bd_base+BLK_SIZE(MAXSIZE)-unavailable;
    800010b8:	00002a17          	auipc	s4,0x2
    800010bc:	430a0a13          	add	s4,s4,1072 # 800034e8 <bd_base>
    800010c0:	00002a97          	auipc	s5,0x2
    800010c4:	430a8a93          	add	s5,s5,1072 # 800034f0 <nsizes>
    800010c8:	000aa783          	lw	a5,0(s5)
    800010cc:	37fd                	addw	a5,a5,-1
    800010ce:	6985                	lui	s3,0x1
    800010d0:	00f997b3          	sll	a5,s3,a5
    800010d4:	8f85                	sub	a5,a5,s1
    800010d6:	000a3903          	ld	s2,0(s4)
    800010da:	993e                	add	s2,s2,a5

    printf("%p\n", bd_end);
    800010dc:	85ca                	mv	a1,s2
    800010de:	00002517          	auipc	a0,0x2
    800010e2:	24a50513          	add	a0,a0,586 # 80003328 <digits+0x168>
    800010e6:	c6cff0ef          	jal	80000552 <printf>

    bd_mark(bd_end, bd_base+BLK_SIZE(MAXSIZE));
    800010ea:	000aa783          	lw	a5,0(s5)
    800010ee:	37fd                	addw	a5,a5,-1
    800010f0:	00f999b3          	sll	s3,s3,a5
    800010f4:	000a3583          	ld	a1,0(s4)
    800010f8:	95ce                	add	a1,a1,s3
    800010fa:	854a                	mv	a0,s2
    800010fc:	e49ff0ef          	jal	80000f44 <bd_mark>
    
    
    return unavailable;
}
    80001100:	8526                	mv	a0,s1
    80001102:	70e2                	ld	ra,56(sp)
    80001104:	7442                	ld	s0,48(sp)
    80001106:	74a2                	ld	s1,40(sp)
    80001108:	7902                	ld	s2,32(sp)
    8000110a:	69e2                	ld	s3,24(sp)
    8000110c:	6a42                	ld	s4,16(sp)
    8000110e:	6aa2                	ld	s5,8(sp)
    80001110:	6121                	add	sp,sp,64
    80001112:	8082                	ret

0000000080001114 <bd_init>:


void bd_init(void* start, void* end){
    80001114:	715d                	add	sp,sp,-80
    80001116:	e486                	sd	ra,72(sp)
    80001118:	e0a2                	sd	s0,64(sp)
    8000111a:	fc26                	sd	s1,56(sp)
    8000111c:	f84a                	sd	s2,48(sp)
    8000111e:	f44e                	sd	s3,40(sp)
    80001120:	f052                	sd	s4,32(sp)
    80001122:	ec56                	sd	s5,24(sp)
    80001124:	e85a                	sd	s6,16(sp)
    80001126:	e45e                	sd	s7,8(sp)
    80001128:	e062                	sd	s8,0(sp)
    8000112a:	0880                	add	s0,sp,80
    8000112c:	8c2e                	mv	s8,a1
    char*p =(char* ) PGROUNDUP((uint64)start);
    8000112e:	6905                	lui	s2,0x1
    80001130:	fff90a13          	add	s4,s2,-1 # fff <_entry-0x7ffff001>
    80001134:	9552                	add	a0,a0,s4
    80001136:	77fd                	lui	a5,0xfffff
    80001138:	00f574b3          	and	s1,a0,a5
    initlock(&lock, "buddy");
    8000113c:	00002597          	auipc	a1,0x2
    80001140:	14c58593          	add	a1,a1,332 # 80003288 <digits+0xc8>
    80001144:	00005517          	auipc	a0,0x5
    80001148:	48c50513          	add	a0,a0,1164 # 800065d0 <lock>
    8000114c:	a4dff0ef          	jal	80000b98 <initlock>
    
    // 计算一下能够管理的块的种类的多少，比如最小的种类就是一个完整的页 
    // 最大的是一整个剩余的空间
    nsizes = log2(((char *)end-p)/LEAF_SIZE) + 1;
    80001150:	409c09b3          	sub	s3,s8,s1
    80001154:	43f9d513          	sra	a0,s3,0x3f
    80001158:	01457533          	and	a0,a0,s4
    8000115c:	954e                	add	a0,a0,s3
    8000115e:	8531                	sra	a0,a0,0xc
    80001160:	ad2ff0ef          	jal	80000432 <log2>

    if((char*)end-p > BLK_SIZE(MAXSIZE)) {
    80001164:	00a91933          	sll	s2,s2,a0
    80001168:	1d394863          	blt	s2,s3,80001338 <bd_init+0x224>
    nsizes = log2(((char *)end-p)/LEAF_SIZE) + 1;
    8000116c:	0015059b          	addw	a1,a0,1
    80001170:	00002997          	auipc	s3,0x2
    80001174:	38098993          	add	s3,s3,896 # 800034f0 <nsizes>
    80001178:	00b9a023          	sw	a1,0(s3)
        nsizes++;  // round up to the next power of 2
    }
    printf("伙伴系统初始化，包含%d个级别,最小的单位为%d\n", nsizes, LEAF_SIZE);
    8000117c:	6605                	lui	a2,0x1
    8000117e:	00002517          	auipc	a0,0x2
    80001182:	11250513          	add	a0,a0,274 # 80003290 <digits+0xd0>
    80001186:	bccff0ef          	jal	80000552 <printf>
    printf("from %p to %p\n", p, end);
    8000118a:	8662                	mv	a2,s8
    8000118c:	85a6                	mv	a1,s1
    8000118e:	00002517          	auipc	a0,0x2
    80001192:	14250513          	add	a0,a0,322 # 800032d0 <digits+0x110>
    80001196:	bbcff0ef          	jal	80000552 <printf>

    bd_base = (void*)p;
    8000119a:	00002797          	auipc	a5,0x2
    8000119e:	3497b723          	sd	s1,846(a5) # 800034e8 <bd_base>
    // 为每一级别的分配和分裂情况分配空间
    bd_sizes = (Sz_info *) p;
    800011a2:	00002797          	auipc	a5,0x2
    800011a6:	3297bf23          	sd	s1,830(a5) # 800034e0 <bd_sizes>
    p += sizeof(Sz_info) * nsizes;
    800011aa:	0009a603          	lw	a2,0(s3)
    800011ae:	00561913          	sll	s2,a2,0x5
    800011b2:	9926                	add	s2,s2,s1
    memset(bd_sizes, 0, sizeof(Sz_info) * nsizes);
    800011b4:	0056161b          	sllw	a2,a2,0x5
    800011b8:	4581                	li	a1,0
    800011ba:	8526                	mv	a0,s1
    800011bc:	b17ff0ef          	jal	80000cd2 <memset>

    // 为每一级别的列表分配空间
    for(int k = 0; k < nsizes; k++){
    800011c0:	0009a783          	lw	a5,0(s3)
    800011c4:	06f05763          	blez	a5,80001232 <bd_init+0x11e>
    800011c8:	4981                	li	s3,0
        lst_init(&bd_sizes[k].free);
    800011ca:	00002b17          	auipc	s6,0x2
    800011ce:	316b0b13          	add	s6,s6,790 # 800034e0 <bd_sizes>

        // printf("第%d类有%d个块\n", k + 1, NBLK(k));
        // printf("每一个块大小为0x%x字节\n", BLK_SIZE(k));    

        //这里的sz表示在alloc，也就是bitmap中需要分配多少字节 
        int sz = sizeof(char)* (ROUNDUP(NBLK(k), 8)) / 8;
    800011d2:	00002a97          	auipc	s5,0x2
    800011d6:	31ea8a93          	add	s5,s5,798 # 800034f0 <nsizes>
    800011da:	6a05                	lui	s4,0x1
        lst_init(&bd_sizes[k].free);
    800011dc:	00599b93          	sll	s7,s3,0x5
    800011e0:	000b3503          	ld	a0,0(s6)
    800011e4:	955e                	add	a0,a0,s7
    800011e6:	97eff0ef          	jal	80000364 <lst_init>
        int sz = sizeof(char)* (ROUNDUP(NBLK(k), 8)) / 8;
    800011ea:	000aa783          	lw	a5,0(s5)
    800011ee:	37fd                	addw	a5,a5,-1
    800011f0:	00fa17b3          	sll	a5,s4,a5
    800011f4:	013a1733          	sll	a4,s4,s3
    800011f8:	02e7c7b3          	div	a5,a5,a4
    800011fc:	17fd                	add	a5,a5,-1
    800011fe:	43f7d493          	sra	s1,a5,0x3f
    80001202:	889d                	and	s1,s1,7
    80001204:	94be                	add	s1,s1,a5
    80001206:	98e1                	and	s1,s1,-8
    80001208:	04a1                	add	s1,s1,8
    8000120a:	808d                	srl	s1,s1,0x3

        // printf("第%d类有%d个块\n", k + 1, NBLK(k));
        // printf("每一个块大小为0x%x字节\n", BLK_SIZE(k));    

        bd_sizes[k].alloc = p;
    8000120c:	000b3783          	ld	a5,0(s6)
    80001210:	97de                	add	a5,a5,s7
    80001212:	0127b823          	sd	s2,16(a5)
        memset(bd_sizes[k].alloc, 0, sz);
    80001216:	2481                	sext.w	s1,s1
    80001218:	8626                	mv	a2,s1
    8000121a:	4581                	li	a1,0
    8000121c:	854a                	mv	a0,s2
    8000121e:	ab5ff0ef          	jal	80000cd2 <memset>
        p += sz;
    80001222:	9926                	add	s2,s2,s1
    for(int k = 0; k < nsizes; k++){
    80001224:	0985                	add	s3,s3,1
    80001226:	000aa703          	lw	a4,0(s5)
    8000122a:	0009879b          	sext.w	a5,s3
    8000122e:	fae7c7e3          	blt	a5,a4,800011dc <bd_init+0xc8>

    }

    for(int k = 1; k < nsizes; k++){
    80001232:	00002797          	auipc	a5,0x2
    80001236:	2be7a783          	lw	a5,702(a5) # 800034f0 <nsizes>
    8000123a:	4705                	li	a4,1
    8000123c:	06f75063          	bge	a4,a5,8000129c <bd_init+0x188>
    80001240:	02000a13          	li	s4,32
    80001244:	4985                	li	s3,1
        int sz = sizeof(char)* (ROUNDUP(NBLK(k), 8)) / 8;
    80001246:	6a85                	lui	s5,0x1
        bd_sizes[k].split = p;
    80001248:	00002b97          	auipc	s7,0x2
    8000124c:	298b8b93          	add	s7,s7,664 # 800034e0 <bd_sizes>
    for(int k = 1; k < nsizes; k++){
    80001250:	00002b17          	auipc	s6,0x2
    80001254:	2a0b0b13          	add	s6,s6,672 # 800034f0 <nsizes>
        int sz = sizeof(char)* (ROUNDUP(NBLK(k), 8)) / 8;
    80001258:	37fd                	addw	a5,a5,-1
    8000125a:	00fa97b3          	sll	a5,s5,a5
    8000125e:	013a9733          	sll	a4,s5,s3
    80001262:	02e7c7b3          	div	a5,a5,a4
    80001266:	17fd                	add	a5,a5,-1
    80001268:	43f7d493          	sra	s1,a5,0x3f
    8000126c:	889d                	and	s1,s1,7
    8000126e:	94be                	add	s1,s1,a5
    80001270:	98e1                	and	s1,s1,-8
    80001272:	04a1                	add	s1,s1,8
    80001274:	808d                	srl	s1,s1,0x3
        bd_sizes[k].split = p;
    80001276:	000bb783          	ld	a5,0(s7)
    8000127a:	97d2                	add	a5,a5,s4
    8000127c:	0127bc23          	sd	s2,24(a5)
        memset(bd_sizes[k].split, 0, sz);
    80001280:	2481                	sext.w	s1,s1
    80001282:	8626                	mv	a2,s1
    80001284:	4581                	li	a1,0
    80001286:	854a                	mv	a0,s2
    80001288:	a4bff0ef          	jal	80000cd2 <memset>
        p += sz;
    8000128c:	9926                	add	s2,s2,s1
    for(int k = 1; k < nsizes; k++){
    8000128e:	2985                	addw	s3,s3,1
    80001290:	000b2783          	lw	a5,0(s6)
    80001294:	020a0a13          	add	s4,s4,32 # 1020 <_entry-0x7fffefe0>
    80001298:	fcf9c0e3          	blt	s3,a5,80001258 <bd_init+0x144>
    }


    p = (char *) ROUNDUP((uint64) p, LEAF_SIZE);
    8000129c:	fff90493          	add	s1,s2,-1
    800012a0:	80b1                	srl	s1,s1,0xc
    800012a2:	0485                	add	s1,s1,1
    800012a4:	04b2                	sll	s1,s1,0xc
    
    // 到这里为止，bd_sizes的所有空间的都分配完成了，剩下的内容就是真正的自由的内存
    // 但是在这里，还需要先对前面的内存打上标签，因为他们也是属于伙伴系统的一部分 

    int meta = bd_mark_data_structures(p);
    800012a6:	8526                	mv	a0,s1
    800012a8:	d5fff0ef          	jal	80001006 <bd_mark_data_structures>
    800012ac:	8a2a                	mv	s4,a0
    // 这里测试一下 可以发现最高的一位实际上已经使用了 这是很符合直觉的
    //printf("%d", bd_sizes[MAXSIZE].alloc[0] & 0xff);

    // 由于分配内存的时候需要向上取整，很明显最后需要多出一段内存
    // 这里直接使用对应的方法处理[end + 128MB, HEAP_SIZE)的空间
    int unavailable = bd_mark_unavailable(end, p);
    800012ae:	85a6                	mv	a1,s1
    800012b0:	8562                	mv	a0,s8
    800012b2:	dadff0ef          	jal	8000105e <bd_mark_unavailable>
    800012b6:	89aa                	mv	s3,a0

    void *bd_end = bd_base+BLK_SIZE(MAXSIZE)-unavailable;
    800012b8:	00002a97          	auipc	s5,0x2
    800012bc:	238a8a93          	add	s5,s5,568 # 800034f0 <nsizes>
    800012c0:	000aa783          	lw	a5,0(s5)
    800012c4:	37fd                	addw	a5,a5,-1
    800012c6:	6905                	lui	s2,0x1
    800012c8:	00f917b3          	sll	a5,s2,a5
    800012cc:	8f89                	sub	a5,a5,a0

    int free = bd_initfree(p, bd_end);
    800012ce:	00002597          	auipc	a1,0x2
    800012d2:	21a5b583          	ld	a1,538(a1) # 800034e8 <bd_base>
    800012d6:	95be                	add	a1,a1,a5
    800012d8:	8526                	mv	a0,s1
    800012da:	bc1ff0ef          	jal	80000e9a <bd_initfree>

    if(free != BLK_SIZE(MAXSIZE)-meta-unavailable){
    800012de:	000aa783          	lw	a5,0(s5)
    800012e2:	37fd                	addw	a5,a5,-1
    800012e4:	00f91633          	sll	a2,s2,a5
    800012e8:	41460633          	sub	a2,a2,s4
    800012ec:	41360633          	sub	a2,a2,s3
    800012f0:	04c51763          	bne	a0,a2,8000133e <bd_init+0x22a>
      printf("free %d %d\n", free, BLK_SIZE(MAXSIZE)-meta-unavailable);
      panic("bd_init: free mem");
    }

    printf("伙伴系统可用空间从%p到%p\n", p, (char*)bd_base+BLK_SIZE(MAXSIZE)-unavailable);
    800012f4:	00002797          	auipc	a5,0x2
    800012f8:	1fc7a783          	lw	a5,508(a5) # 800034f0 <nsizes>
    800012fc:	37fd                	addw	a5,a5,-1
    800012fe:	6605                	lui	a2,0x1
    80001300:	00f61633          	sll	a2,a2,a5
    80001304:	413609b3          	sub	s3,a2,s3
    80001308:	00002617          	auipc	a2,0x2
    8000130c:	1e063603          	ld	a2,480(a2) # 800034e8 <bd_base>
    80001310:	964e                	add	a2,a2,s3
    80001312:	85a6                	mv	a1,s1
    80001314:	00002517          	auipc	a0,0x2
    80001318:	ff450513          	add	a0,a0,-12 # 80003308 <digits+0x148>
    8000131c:	a36ff0ef          	jal	80000552 <printf>

}
    80001320:	60a6                	ld	ra,72(sp)
    80001322:	6406                	ld	s0,64(sp)
    80001324:	74e2                	ld	s1,56(sp)
    80001326:	7942                	ld	s2,48(sp)
    80001328:	79a2                	ld	s3,40(sp)
    8000132a:	7a02                	ld	s4,32(sp)
    8000132c:	6ae2                	ld	s5,24(sp)
    8000132e:	6b42                	ld	s6,16(sp)
    80001330:	6ba2                	ld	s7,8(sp)
    80001332:	6c02                	ld	s8,0(sp)
    80001334:	6161                	add	sp,sp,80
    80001336:	8082                	ret
        nsizes++;  // round up to the next power of 2
    80001338:	0025059b          	addw	a1,a0,2
    8000133c:	bd15                	j	80001170 <bd_init+0x5c>
      printf("free %d %d\n", free, BLK_SIZE(MAXSIZE)-meta-unavailable);
    8000133e:	85aa                	mv	a1,a0
    80001340:	00002517          	auipc	a0,0x2
    80001344:	fa050513          	add	a0,a0,-96 # 800032e0 <digits+0x120>
    80001348:	a0aff0ef          	jal	80000552 <printf>
      panic("bd_init: free mem");
    8000134c:	00002517          	auipc	a0,0x2
    80001350:	fa450513          	add	a0,a0,-92 # 800032f0 <digits+0x130>
    80001354:	fbaff0ef          	jal	80000b0e <panic>
    80001358:	bf71                	j	800012f4 <bd_init+0x1e0>

000000008000135a <firstk>:

// 对于我们的需求，找到第一个满足要求的k索引
int firstk(uint64 n){
    8000135a:	1141                	add	sp,sp,-16
    8000135c:	e422                	sd	s0,8(sp)
    8000135e:	0800                	add	s0,sp,16
  int k = 0;
  uint64 size = LEAF_SIZE;

  while(size < n){
    80001360:	6785                	lui	a5,0x1
    80001362:	00a7fb63          	bgeu	a5,a0,80001378 <firstk+0x1e>
    80001366:	872a                	mv	a4,a0
  int k = 0;
    80001368:	4501                	li	a0,0
    k++;
    8000136a:	2505                	addw	a0,a0,1
    size *= 2;
    8000136c:	0786                	sll	a5,a5,0x1
  while(size < n){
    8000136e:	fee7eee3          	bltu	a5,a4,8000136a <firstk+0x10>
  }
  return k;

}
    80001372:	6422                	ld	s0,8(sp)
    80001374:	0141                	add	sp,sp,16
    80001376:	8082                	ret
  int k = 0;
    80001378:	4501                	li	a0,0
    8000137a:	bfe5                	j	80001372 <firstk+0x18>

000000008000137c <bd_malloc>:

void* bd_malloc(uint64 nbytes){
    8000137c:	7119                	add	sp,sp,-128
    8000137e:	fc86                	sd	ra,120(sp)
    80001380:	f8a2                	sd	s0,112(sp)
    80001382:	f4a6                	sd	s1,104(sp)
    80001384:	f0ca                	sd	s2,96(sp)
    80001386:	ecce                	sd	s3,88(sp)
    80001388:	e8d2                	sd	s4,80(sp)
    8000138a:	e4d6                	sd	s5,72(sp)
    8000138c:	e0da                	sd	s6,64(sp)
    8000138e:	fc5e                	sd	s7,56(sp)
    80001390:	f862                	sd	s8,48(sp)
    80001392:	f466                	sd	s9,40(sp)
    80001394:	f06a                	sd	s10,32(sp)
    80001396:	ec6e                	sd	s11,24(sp)
    80001398:	0100                	add	s0,sp,128
    8000139a:	84aa                	mv	s1,a0
  int fk, k;
  acquire(&lock);
    8000139c:	00005517          	auipc	a0,0x5
    800013a0:	23450513          	add	a0,a0,564 # 800065d0 <lock>
    800013a4:	84bff0ef          	jal	80000bee <acquire>

  fk = firstk(nbytes);
    800013a8:	8526                	mv	a0,s1
    800013aa:	fb1ff0ef          	jal	8000135a <firstk>
  for(k = fk; k < nsizes; k++){
    800013ae:	00002797          	auipc	a5,0x2
    800013b2:	1427a783          	lw	a5,322(a5) # 800034f0 <nsizes>
    800013b6:	02f55b63          	bge	a0,a5,800013ec <bd_malloc+0x70>
    800013ba:	8baa                	mv	s7,a0
    800013bc:	00551913          	sll	s2,a0,0x5
    800013c0:	84aa                	mv	s1,a0
    if(!lst_empty(&bd_sizes[k].free))
    800013c2:	00002997          	auipc	s3,0x2
    800013c6:	11e98993          	add	s3,s3,286 # 800034e0 <bd_sizes>
  for(k = fk; k < nsizes; k++){
    800013ca:	00002a17          	auipc	s4,0x2
    800013ce:	126a0a13          	add	s4,s4,294 # 800034f0 <nsizes>
    if(!lst_empty(&bd_sizes[k].free))
    800013d2:	0009b503          	ld	a0,0(s3)
    800013d6:	954a                	add	a0,a0,s2
    800013d8:	f9dfe0ef          	jal	80000374 <lst_empty>
    800013dc:	c105                	beqz	a0,800013fc <bd_malloc+0x80>
  for(k = fk; k < nsizes; k++){
    800013de:	2485                	addw	s1,s1,1
    800013e0:	02090913          	add	s2,s2,32 # 1020 <_entry-0x7fffefe0>
    800013e4:	000a2783          	lw	a5,0(s4)
    800013e8:	fef4c5e3          	blt	s1,a5,800013d2 <bd_malloc+0x56>
      break;
  }

  if(k >= nsizes){
    release(&lock);
    800013ec:	00005517          	auipc	a0,0x5
    800013f0:	1e450513          	add	a0,a0,484 # 800065d0 <lock>
    800013f4:	8a1ff0ef          	jal	80000c94 <release>
    return 0;
    800013f8:	4c01                	li	s8,0
    800013fa:	a85d                	j	800014b0 <bd_malloc+0x134>
  if(k >= nsizes){
    800013fc:	00002797          	auipc	a5,0x2
    80001400:	0f47a783          	lw	a5,244(a5) # 800034f0 <nsizes>
    80001404:	fef4d4e3          	bge	s1,a5,800013ec <bd_malloc+0x70>
  }

  
  char *p = lst_pop(&bd_sizes[k].free);
    80001408:	00549993          	sll	s3,s1,0x5
    8000140c:	00002917          	auipc	s2,0x2
    80001410:	0d490913          	add	s2,s2,212 # 800034e0 <bd_sizes>
    80001414:	00093503          	ld	a0,0(s2)
    80001418:	954e                	add	a0,a0,s3
    8000141a:	f87fe0ef          	jal	800003a0 <lst_pop>
    8000141e:	8c2a                	mv	s8,a0
  return ((uint64)addr - (uint64)bd_base) / BLK_SIZE(k);
    80001420:	f8a43423          	sd	a0,-120(s0)
    80001424:	00002597          	auipc	a1,0x2
    80001428:	0c45b583          	ld	a1,196(a1) # 800034e8 <bd_base>
    8000142c:	40b505b3          	sub	a1,a0,a1
    80001430:	00c4879b          	addw	a5,s1,12
    80001434:	00f5d5b3          	srl	a1,a1,a5
  bit_set(bd_sizes[k].alloc, blk_index(k, p));
    80001438:	00093783          	ld	a5,0(s2)
    8000143c:	97ce                	add	a5,a5,s3
    8000143e:	2581                	sext.w	a1,a1
    80001440:	6b88                	ld	a0,16(a5)
    80001442:	927ff0ef          	jal	80000d68 <bit_set>
  for(; k > fk; k--) {
    80001446:	049bdf63          	bge	s7,s1,800014a4 <bd_malloc+0x128>
    // split a block at size k and mark one half allocated at size k-1
    // and put the buddy on the free list at size k-1
    char *q = p + BLK_SIZE(k-1);   // p's buddy
    8000144a:	6d85                	lui	s11,0x1
    bit_set(bd_sizes[k].split, blk_index(k, p));
    8000144c:	8d4a                	mv	s10,s2
  return ((uint64)addr - (uint64)bd_base) / BLK_SIZE(k);
    8000144e:	00002c97          	auipc	s9,0x2
    80001452:	09ac8c93          	add	s9,s9,154 # 800034e8 <bd_base>
    char *q = p + BLK_SIZE(k-1);   // p's buddy
    80001456:	8aa6                	mv	s5,s1
    80001458:	34fd                	addw	s1,s1,-1
    8000145a:	009d9b33          	sll	s6,s11,s1
    8000145e:	9b62                	add	s6,s6,s8
    bit_set(bd_sizes[k].split, blk_index(k, p));
    80001460:	000d3a03          	ld	s4,0(s10)
  return ((uint64)addr - (uint64)bd_base) / BLK_SIZE(k);
    80001464:	000cb903          	ld	s2,0(s9)
    80001468:	f8843783          	ld	a5,-120(s0)
    8000146c:	41278933          	sub	s2,a5,s2
    80001470:	00ca859b          	addw	a1,s5,12
    80001474:	00b955b3          	srl	a1,s2,a1
    bit_set(bd_sizes[k].split, blk_index(k, p));
    80001478:	013a07b3          	add	a5,s4,s3
    8000147c:	2581                	sext.w	a1,a1
    8000147e:	6f88                	ld	a0,24(a5)
    80001480:	8e9ff0ef          	jal	80000d68 <bit_set>
    bit_set(bd_sizes[k-1].alloc, blk_index(k-1, p));
    80001484:	1981                	add	s3,s3,-32
    80001486:	9a4e                	add	s4,s4,s3
  return ((uint64)addr - (uint64)bd_base) / BLK_SIZE(k);
    80001488:	2aad                	addw	s5,s5,11
    8000148a:	015955b3          	srl	a1,s2,s5
    bit_set(bd_sizes[k-1].alloc, blk_index(k-1, p));
    8000148e:	2581                	sext.w	a1,a1
    80001490:	010a3503          	ld	a0,16(s4)
    80001494:	8d5ff0ef          	jal	80000d68 <bit_set>
    lst_push(&bd_sizes[k-1].free, q);
    80001498:	85da                	mv	a1,s6
    8000149a:	8552                	mv	a0,s4
    8000149c:	f39fe0ef          	jal	800003d4 <lst_push>
  for(; k > fk; k--) {
    800014a0:	fb749be3          	bne	s1,s7,80001456 <bd_malloc+0xda>
  }
  release(&lock);
    800014a4:	00005517          	auipc	a0,0x5
    800014a8:	12c50513          	add	a0,a0,300 # 800065d0 <lock>
    800014ac:	fe8ff0ef          	jal	80000c94 <release>

  return p;


    800014b0:	8562                	mv	a0,s8
    800014b2:	70e6                	ld	ra,120(sp)
    800014b4:	7446                	ld	s0,112(sp)
    800014b6:	74a6                	ld	s1,104(sp)
    800014b8:	7906                	ld	s2,96(sp)
    800014ba:	69e6                	ld	s3,88(sp)
    800014bc:	6a46                	ld	s4,80(sp)
    800014be:	6aa6                	ld	s5,72(sp)
    800014c0:	6b06                	ld	s6,64(sp)
    800014c2:	7be2                	ld	s7,56(sp)
    800014c4:	7c42                	ld	s8,48(sp)
    800014c6:	7ca2                	ld	s9,40(sp)
    800014c8:	7d02                	ld	s10,32(sp)
    800014ca:	6de2                	ld	s11,24(sp)
    800014cc:	6109                	add	sp,sp,128
    800014ce:	8082                	ret

00000000800014d0 <list_bit_set>:
void* addr_base;

#define PAGE_INDEX(addr) (((uint64)addr - (uint64)addr_base) / PGSIZE)

// 从 addr_base 的第几个空间开始
void list_bit_set(int index){
    800014d0:	1141                	add	sp,sp,-16
    800014d2:	e422                	sd	s0,8(sp)
    800014d4:	0800                	add	s0,sp,16
    int c = index / 8;
    800014d6:	41f5579b          	sraw	a5,a0,0x1f
    800014da:	01d7d79b          	srlw	a5,a5,0x1d
    800014de:	9fa9                	addw	a5,a5,a0
    int b = index % 8;
    kmem.bitmap[c] |= (1 << b);
    800014e0:	4037d79b          	sraw	a5,a5,0x3
    800014e4:	00005717          	auipc	a4,0x5
    800014e8:	12473703          	ld	a4,292(a4) # 80006608 <kmem+0x20>
    800014ec:	97ba                	add	a5,a5,a4
    800014ee:	891d                	and	a0,a0,7
    800014f0:	4685                	li	a3,1
    800014f2:	00a696bb          	sllw	a3,a3,a0
    800014f6:	0007c703          	lbu	a4,0(a5)
    800014fa:	8f55                	or	a4,a4,a3
    800014fc:	00e78023          	sb	a4,0(a5)
}
    80001500:	6422                	ld	s0,8(sp)
    80001502:	0141                	add	sp,sp,16
    80001504:	8082                	ret

0000000080001506 <list_bit_clear>:

void list_bit_clear(int index){
    80001506:	1141                	add	sp,sp,-16
    80001508:	e422                	sd	s0,8(sp)
    8000150a:	0800                	add	s0,sp,16
    int c = index / 8;
    8000150c:	41f5579b          	sraw	a5,a0,0x1f
    80001510:	01d7d79b          	srlw	a5,a5,0x1d
    80001514:	9fa9                	addw	a5,a5,a0
    int b = index % 8;
    kmem.bitmap[c] &= ~(1 << b);
    80001516:	4037d79b          	sraw	a5,a5,0x3
    8000151a:	00005717          	auipc	a4,0x5
    8000151e:	0ee73703          	ld	a4,238(a4) # 80006608 <kmem+0x20>
    80001522:	973e                	add	a4,a4,a5
    80001524:	891d                	and	a0,a0,7
    80001526:	4785                	li	a5,1
    80001528:	00a797bb          	sllw	a5,a5,a0
    8000152c:	fff7c793          	not	a5,a5
    80001530:	00074683          	lbu	a3,0(a4)
    80001534:	8ff5                	and	a5,a5,a3
    80001536:	00f70023          	sb	a5,0(a4)
}
    8000153a:	6422                	ld	s0,8(sp)
    8000153c:	0141                	add	sp,sp,16
    8000153e:	8082                	ret

0000000080001540 <list_bit_isset>:

int list_bit_isset(int index){
    80001540:	1141                	add	sp,sp,-16
    80001542:	e422                	sd	s0,8(sp)
    80001544:	0800                	add	s0,sp,16
    int c = index / 8;
    80001546:	41f5579b          	sraw	a5,a0,0x1f
    8000154a:	01d7d79b          	srlw	a5,a5,0x1d
    8000154e:	9fa9                	addw	a5,a5,a0
    int b = index % 8;
    return (kmem.bitmap[c] >> b) & 1;
    80001550:	4037d79b          	sraw	a5,a5,0x3
    80001554:	00005717          	auipc	a4,0x5
    80001558:	0b473703          	ld	a4,180(a4) # 80006608 <kmem+0x20>
    8000155c:	97ba                	add	a5,a5,a4
    8000155e:	0007c783          	lbu	a5,0(a5)
    80001562:	891d                	and	a0,a0,7
    80001564:	40a7d53b          	sraw	a0,a5,a0
}
    80001568:	8905                	and	a0,a0,1
    8000156a:	6422                	ld	s0,8(sp)
    8000156c:	0141                	add	sp,sp,16
    8000156e:	8082                	ret

0000000080001570 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80001570:	1101                	add	sp,sp,-32
    80001572:	ec06                	sd	ra,24(sp)
    80001574:	e822                	sd	s0,16(sp)
    80001576:	e426                	sd	s1,8(sp)
    80001578:	e04a                	sd	s2,0(sp)
    8000157a:	1000                	add	s0,sp,32
    8000157c:	84aa                	mv	s1,a0
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    8000157e:	03451793          	sll	a5,a0,0x34
    80001582:	eb99                	bnez	a5,80001598 <kfree+0x28>
    80001584:	00006797          	auipc	a5,0x6
    80001588:	e4c78793          	add	a5,a5,-436 # 800073d0 <end>
    8000158c:	00f56663          	bltu	a0,a5,80001598 <kfree+0x28>
    80001590:	47c5                	li	a5,17
    80001592:	07ee                	sll	a5,a5,0x1b
    80001594:	00f56863          	bltu	a0,a5,800015a4 <kfree+0x34>
    panic("kfree");
    80001598:	00002517          	auipc	a0,0x2
    8000159c:	d9850513          	add	a0,a0,-616 # 80003330 <digits+0x170>
    800015a0:	d6eff0ef          	jal	80000b0e <panic>

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    800015a4:	6605                	lui	a2,0x1
    800015a6:	4585                	li	a1,1
    800015a8:	8526                	mv	a0,s1
    800015aa:	f28ff0ef          	jal	80000cd2 <memset>

  r = (struct run*)pa;
  if(!list_bit_isset(PAGE_INDEX(pa)))
    800015ae:	00002517          	auipc	a0,0x2
    800015b2:	f4a53503          	ld	a0,-182(a0) # 800034f8 <addr_base>
    800015b6:	40a48533          	sub	a0,s1,a0
    800015ba:	8131                	srl	a0,a0,0xc
    800015bc:	2501                	sext.w	a0,a0
    800015be:	f83ff0ef          	jal	80001540 <list_bit_isset>
    800015c2:	c121                	beqz	a0,80001602 <kfree+0x92>
    panic("kfree: 重复释放内存");

  list_bit_clear(PAGE_INDEX(pa));
    800015c4:	00002517          	auipc	a0,0x2
    800015c8:	f3453503          	ld	a0,-204(a0) # 800034f8 <addr_base>
    800015cc:	40a48533          	sub	a0,s1,a0
    800015d0:	8131                	srl	a0,a0,0xc
    800015d2:	2501                	sext.w	a0,a0
    800015d4:	f33ff0ef          	jal	80001506 <list_bit_clear>

  acquire(&kmem.lock);
    800015d8:	00005917          	auipc	s2,0x5
    800015dc:	01090913          	add	s2,s2,16 # 800065e8 <kmem>
    800015e0:	854a                	mv	a0,s2
    800015e2:	e0cff0ef          	jal	80000bee <acquire>
  r->next = kmem.freelist;
    800015e6:	01893783          	ld	a5,24(s2)
    800015ea:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    800015ec:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    800015f0:	854a                	mv	a0,s2
    800015f2:	ea2ff0ef          	jal	80000c94 <release>
}
    800015f6:	60e2                	ld	ra,24(sp)
    800015f8:	6442                	ld	s0,16(sp)
    800015fa:	64a2                	ld	s1,8(sp)
    800015fc:	6902                	ld	s2,0(sp)
    800015fe:	6105                	add	sp,sp,32
    80001600:	8082                	ret
    panic("kfree: 重复释放内存");
    80001602:	00002517          	auipc	a0,0x2
    80001606:	d3650513          	add	a0,a0,-714 # 80003338 <digits+0x178>
    8000160a:	d04ff0ef          	jal	80000b0e <panic>
    8000160e:	bf5d                	j	800015c4 <kfree+0x54>

0000000080001610 <freerange>:
{
    80001610:	7139                	add	sp,sp,-64
    80001612:	fc06                	sd	ra,56(sp)
    80001614:	f822                	sd	s0,48(sp)
    80001616:	f426                	sd	s1,40(sp)
    80001618:	f04a                	sd	s2,32(sp)
    8000161a:	ec4e                	sd	s3,24(sp)
    8000161c:	e852                	sd	s4,16(sp)
    8000161e:	e456                	sd	s5,8(sp)
    80001620:	e05a                	sd	s6,0(sp)
    80001622:	0080                	add	s0,sp,64
    80001624:	892e                	mv	s2,a1
    p = (char*)PGROUNDUP((uint64)pa_start);
    80001626:	6a05                	lui	s4,0x1
    80001628:	fffa0713          	add	a4,s4,-1 # fff <_entry-0x7ffff001>
    8000162c:	953a                	add	a0,a0,a4
    8000162e:	77fd                	lui	a5,0xfffff
    80001630:	00f579b3          	and	s3,a0,a5
    addr_base = p;
    80001634:	00002a97          	auipc	s5,0x2
    80001638:	ec4a8a93          	add	s5,s5,-316 # 800034f8 <addr_base>
    8000163c:	013ab023          	sd	s3,0(s5)
    int cnt = ((char*)pa_end - p + PGSIZE - 1) / PGSIZE;
    80001640:	413587b3          	sub	a5,a1,s3
    80001644:	97ba                	add	a5,a5,a4
    80001646:	43f7d493          	sra	s1,a5,0x3f
    8000164a:	8cf9                	and	s1,s1,a4
    8000164c:	94be                	add	s1,s1,a5
    8000164e:	84b1                	sra	s1,s1,0xc
    80001650:	2481                	sext.w	s1,s1
    printf("内存中一共包含%d个页\n", cnt);
    80001652:	85a6                	mv	a1,s1
    80001654:	00002517          	auipc	a0,0x2
    80001658:	d0450513          	add	a0,a0,-764 # 80003358 <digits+0x198>
    8000165c:	ef7fe0ef          	jal	80000552 <printf>
    printf("from 0x%x to 0x%x\n", p, pa_end);
    80001660:	864a                	mv	a2,s2
    80001662:	85ce                	mv	a1,s3
    80001664:	00002517          	auipc	a0,0x2
    80001668:	d1450513          	add	a0,a0,-748 # 80003378 <digits+0x1b8>
    8000166c:	ee7fe0ef          	jal	80000552 <printf>
    int meta_sz = (cnt + 8 * PGSIZE - 1) / (8 * PGSIZE);
    80001670:	67a1                	lui	a5,0x8
    80001672:	37fd                	addw	a5,a5,-1 # 7fff <_entry-0x7fff8001>
    80001674:	9fa5                	addw	a5,a5,s1
    80001676:	41f7d49b          	sraw	s1,a5,0x1f
    8000167a:	0114d49b          	srlw	s1,s1,0x11
    8000167e:	9cbd                	addw	s1,s1,a5
    80001680:	40f4d49b          	sraw	s1,s1,0xf
    printf("%d页的位图空间被分配用于内存管理\n", meta_sz);
    80001684:	0004859b          	sext.w	a1,s1
    80001688:	00002517          	auipc	a0,0x2
    8000168c:	d0850513          	add	a0,a0,-760 # 80003390 <digits+0x1d0>
    80001690:	ec3fe0ef          	jal	80000552 <printf>
    printf("from 0x%x to 0x%x\n", p, p + meta_sz * PGSIZE);
    80001694:	00c4949b          	sllw	s1,s1,0xc
    80001698:	00048b1b          	sext.w	s6,s1
    8000169c:	9b4e                	add	s6,s6,s3
    8000169e:	865a                	mv	a2,s6
    800016a0:	85ce                	mv	a1,s3
    800016a2:	00002517          	auipc	a0,0x2
    800016a6:	cd650513          	add	a0,a0,-810 # 80003378 <digits+0x1b8>
    800016aa:	ea9fe0ef          	jal	80000552 <printf>
    memset(p, 0, meta_sz * PGSIZE);
    800016ae:	2481                	sext.w	s1,s1
    800016b0:	8626                	mv	a2,s1
    800016b2:	4581                	li	a1,0
    800016b4:	854e                	mv	a0,s3
    800016b6:	e1cff0ef          	jal	80000cd2 <memset>
    printf("初始化完成\n");
    800016ba:	00002517          	auipc	a0,0x2
    800016be:	d0e50513          	add	a0,a0,-754 # 800033c8 <digits+0x208>
    800016c2:	e91fe0ef          	jal	80000552 <printf>
    kmem.bitmap = (char*)addr_base;
    800016c6:	000ab503          	ld	a0,0(s5)
    800016ca:	00005797          	auipc	a5,0x5
    800016ce:	f2a7bf23          	sd	a0,-194(a5) # 80006608 <kmem+0x20>
    memset(kmem.bitmap,0xff, meta_sz * PGSIZE); // 先全部标记为已经使用
    800016d2:	8626                	mv	a2,s1
    800016d4:	0ff00593          	li	a1,255
    800016d8:	dfaff0ef          	jal	80000cd2 <memset>
    for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    800016dc:	9a5a                	add	s4,s4,s6
    800016de:	03496163          	bltu	s2,s4,80001700 <freerange+0xf0>
    800016e2:	84da                	mv	s1,s6
    800016e4:	77fd                	lui	a5,0xfffff
    800016e6:	993e                	add	s2,s2,a5
    800016e8:	41690933          	sub	s2,s2,s6
    800016ec:	00f97933          	and	s2,s2,a5
    800016f0:	9952                	add	s2,s2,s4
    800016f2:	6985                	lui	s3,0x1
        kfree(p);
    800016f4:	8526                	mv	a0,s1
    800016f6:	e7bff0ef          	jal	80001570 <kfree>
    for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    800016fa:	94ce                	add	s1,s1,s3
    800016fc:	ff249ce3          	bne	s1,s2,800016f4 <freerange+0xe4>
    printf("初始化完成\n");
    80001700:	00002517          	auipc	a0,0x2
    80001704:	cc850513          	add	a0,a0,-824 # 800033c8 <digits+0x208>
    80001708:	e4bfe0ef          	jal	80000552 <printf>
}
    8000170c:	70e2                	ld	ra,56(sp)
    8000170e:	7442                	ld	s0,48(sp)
    80001710:	74a2                	ld	s1,40(sp)
    80001712:	7902                	ld	s2,32(sp)
    80001714:	69e2                	ld	s3,24(sp)
    80001716:	6a42                	ld	s4,16(sp)
    80001718:	6aa2                	ld	s5,8(sp)
    8000171a:	6b02                	ld	s6,0(sp)
    8000171c:	6121                	add	sp,sp,64
    8000171e:	8082                	ret

0000000080001720 <kinit>:
{
    80001720:	1141                	add	sp,sp,-16
    80001722:	e406                	sd	ra,8(sp)
    80001724:	e022                	sd	s0,0(sp)
    80001726:	0800                	add	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80001728:	00002597          	auipc	a1,0x2
    8000172c:	cb858593          	add	a1,a1,-840 # 800033e0 <digits+0x220>
    80001730:	00005517          	auipc	a0,0x5
    80001734:	eb850513          	add	a0,a0,-328 # 800065e8 <kmem>
    80001738:	c60ff0ef          	jal	80000b98 <initlock>
  freerange(end, (void*)PHYSTOP);
    8000173c:	45c5                	li	a1,17
    8000173e:	05ee                	sll	a1,a1,0x1b
    80001740:	00006517          	auipc	a0,0x6
    80001744:	c9050513          	add	a0,a0,-880 # 800073d0 <end>
    80001748:	ec9ff0ef          	jal	80001610 <freerange>
}
    8000174c:	60a2                	ld	ra,8(sp)
    8000174e:	6402                	ld	s0,0(sp)
    80001750:	0141                	add	sp,sp,16
    80001752:	8082                	ret

0000000080001754 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80001754:	1101                	add	sp,sp,-32
    80001756:	ec06                	sd	ra,24(sp)
    80001758:	e822                	sd	s0,16(sp)
    8000175a:	e426                	sd	s1,8(sp)
    8000175c:	1000                	add	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    8000175e:	00005497          	auipc	s1,0x5
    80001762:	e8a48493          	add	s1,s1,-374 # 800065e8 <kmem>
    80001766:	8526                	mv	a0,s1
    80001768:	c86ff0ef          	jal	80000bee <acquire>
  r = kmem.freelist;
    8000176c:	6c84                	ld	s1,24(s1)

  if(r)
    8000176e:	cc95                	beqz	s1,800017aa <kalloc+0x56>
    kmem.freelist = r->next;
    80001770:	609c                	ld	a5,0(s1)
    80001772:	00005517          	auipc	a0,0x5
    80001776:	e7650513          	add	a0,a0,-394 # 800065e8 <kmem>
    8000177a:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    8000177c:	d18ff0ef          	jal	80000c94 <release>

  list_bit_set(PAGE_INDEX(r));
    80001780:	00002517          	auipc	a0,0x2
    80001784:	d7853503          	ld	a0,-648(a0) # 800034f8 <addr_base>
    80001788:	40a48533          	sub	a0,s1,a0
    8000178c:	8131                	srl	a0,a0,0xc
    8000178e:	2501                	sext.w	a0,a0
    80001790:	d41ff0ef          	jal	800014d0 <list_bit_set>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80001794:	6605                	lui	a2,0x1
    80001796:	4595                	li	a1,5
    80001798:	8526                	mv	a0,s1
    8000179a:	d38ff0ef          	jal	80000cd2 <memset>
  return (void*)r;
    8000179e:	8526                	mv	a0,s1
    800017a0:	60e2                	ld	ra,24(sp)
    800017a2:	6442                	ld	s0,16(sp)
    800017a4:	64a2                	ld	s1,8(sp)
    800017a6:	6105                	add	sp,sp,32
    800017a8:	8082                	ret
  release(&kmem.lock);
    800017aa:	00005517          	auipc	a0,0x5
    800017ae:	e3e50513          	add	a0,a0,-450 # 800065e8 <kmem>
    800017b2:	ce2ff0ef          	jal	80000c94 <release>
  list_bit_set(PAGE_INDEX(r));
    800017b6:	00002517          	auipc	a0,0x2
    800017ba:	d4253503          	ld	a0,-702(a0) # 800034f8 <addr_base>
    800017be:	40a00533          	neg	a0,a0
    800017c2:	8131                	srl	a0,a0,0xc
    800017c4:	2501                	sext.w	a0,a0
    800017c6:	d0bff0ef          	jal	800014d0 <list_bit_set>
  if(r)
    800017ca:	bfd1                	j	8000179e <kalloc+0x4a>

00000000800017cc <walk>:
// 如果alloc为0 那么就是查询虚拟地址va对应的 L0PTE 地址
// 如果alloc为0 那么就是在查询的过程中如果发现缺页就分配一个新的页表页
// walk返回的是L0PTE的地址
// 如果找不到返回0
pte_t*
walk(pagetable_t pagetable, uint64 va, int alloc){
    800017cc:	7139                	add	sp,sp,-64
    800017ce:	fc06                	sd	ra,56(sp)
    800017d0:	f822                	sd	s0,48(sp)
    800017d2:	f426                	sd	s1,40(sp)
    800017d4:	f04a                	sd	s2,32(sp)
    800017d6:	ec4e                	sd	s3,24(sp)
    800017d8:	e852                	sd	s4,16(sp)
    800017da:	e456                	sd	s5,8(sp)
    800017dc:	e05a                	sd	s6,0(sp)
    800017de:	0080                	add	s0,sp,64
    800017e0:	84aa                	mv	s1,a0
    800017e2:	89ae                	mv	s3,a1
    800017e4:	8ab2                	mv	s5,a2
    if(va >= MAXVA)
    800017e6:	57fd                	li	a5,-1
    800017e8:	83e9                	srl	a5,a5,0x1a
    800017ea:	00b7e563          	bltu	a5,a1,800017f4 <walk+0x28>
walk(pagetable_t pagetable, uint64 va, int alloc){
    800017ee:	4a79                	li	s4,30
        panic("walk");
    
    for(int level = 2; level > 0; level--){
    800017f0:	4b31                	li	s6,12
    800017f2:	a825                	j	8000182a <walk+0x5e>
        panic("walk");
    800017f4:	00002517          	auipc	a0,0x2
    800017f8:	bf450513          	add	a0,a0,-1036 # 800033e8 <digits+0x228>
    800017fc:	b12ff0ef          	jal	80000b0e <panic>
    80001800:	b7fd                	j	800017ee <walk+0x22>
        // 也就是找到那个页表
        if(*pte & PTE_V){
            pagetable = (pagetable_t)PTE2PA(*pte);
        }else{
            // 如果页表项无效 并且不需要分配 那么直接返回0
            if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001802:	060a8263          	beqz	s5,80001866 <walk+0x9a>
    80001806:	f4fff0ef          	jal	80001754 <kalloc>
    8000180a:	84aa                	mv	s1,a0
    8000180c:	c139                	beqz	a0,80001852 <walk+0x86>
                return 0;
            // 分配成功之后 将这一页表页清零
            memset(pagetable, 0, PGSIZE);
    8000180e:	6605                	lui	a2,0x1
    80001810:	4581                	li	a1,0
    80001812:	cc0ff0ef          	jal	80000cd2 <memset>
            // 然后将这个新分配的页表页的物理地址写入到当前的页表项中
            *pte = PA2PTE(pagetable) | PTE_V;
    80001816:	00c4d793          	srl	a5,s1,0xc
    8000181a:	07aa                	sll	a5,a5,0xa
    8000181c:	0017e793          	or	a5,a5,1
    80001820:	00f93023          	sd	a5,0(s2)
    for(int level = 2; level > 0; level--){
    80001824:	3a5d                	addw	s4,s4,-9
    80001826:	036a0063          	beq	s4,s6,80001846 <walk+0x7a>
        pte_t* pte = &pagetable[PX(level, va)];
    8000182a:	0149d933          	srl	s2,s3,s4
    8000182e:	1ff97913          	and	s2,s2,511
    80001832:	090e                	sll	s2,s2,0x3
    80001834:	9926                	add	s2,s2,s1
        if(*pte & PTE_V){
    80001836:	00093483          	ld	s1,0(s2)
    8000183a:	0014f793          	and	a5,s1,1
    8000183e:	d3f1                	beqz	a5,80001802 <walk+0x36>
            pagetable = (pagetable_t)PTE2PA(*pte);
    80001840:	80a9                	srl	s1,s1,0xa
    80001842:	04b2                	sll	s1,s1,0xc
    80001844:	b7c5                	j	80001824 <walk+0x58>
        }
    }
    return &pagetable[PX(0, va)];
    80001846:	00c9d513          	srl	a0,s3,0xc
    8000184a:	1ff57513          	and	a0,a0,511
    8000184e:	050e                	sll	a0,a0,0x3
    80001850:	9526                	add	a0,a0,s1
}
    80001852:	70e2                	ld	ra,56(sp)
    80001854:	7442                	ld	s0,48(sp)
    80001856:	74a2                	ld	s1,40(sp)
    80001858:	7902                	ld	s2,32(sp)
    8000185a:	69e2                	ld	s3,24(sp)
    8000185c:	6a42                	ld	s4,16(sp)
    8000185e:	6aa2                	ld	s5,8(sp)
    80001860:	6b02                	ld	s6,0(sp)
    80001862:	6121                	add	sp,sp,64
    80001864:	8082                	ret
                return 0;
    80001866:	4501                	li	a0,0
    80001868:	b7ed                	j	80001852 <walk+0x86>

000000008000186a <mappages>:

// 在页表pagetable中添加从va开始的size字节的映射，映射到物理地址pa
// va和size必须内存对齐
// 返回0表示成功，-1表示失败
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm){
    8000186a:	711d                	add	sp,sp,-96
    8000186c:	ec86                	sd	ra,88(sp)
    8000186e:	e8a2                	sd	s0,80(sp)
    80001870:	e4a6                	sd	s1,72(sp)
    80001872:	e0ca                	sd	s2,64(sp)
    80001874:	fc4e                	sd	s3,56(sp)
    80001876:	f852                	sd	s4,48(sp)
    80001878:	f456                	sd	s5,40(sp)
    8000187a:	f05a                	sd	s6,32(sp)
    8000187c:	ec5e                	sd	s7,24(sp)
    8000187e:	e862                	sd	s8,16(sp)
    80001880:	e466                	sd	s9,8(sp)
    80001882:	1080                	add	s0,sp,96
    80001884:	8b2a                	mv	s6,a0
    80001886:	84ae                	mv	s1,a1
    80001888:	8a32                	mv	s4,a2
    8000188a:	8ab6                	mv	s5,a3
    8000188c:	8bba                	mv	s7,a4
    uint64 a, list;
    pte_t* pte;

    if((va % PGSIZE) != 0)
    8000188e:	03459793          	sll	a5,a1,0x34
    80001892:	e395                	bnez	a5,800018b6 <mappages+0x4c>
        panic("mappages: 虚拟地址VA没有对齐");

    if((size % PGSIZE) != 0)
    80001894:	034a1793          	sll	a5,s4,0x34
    80001898:	e795                	bnez	a5,800018c4 <mappages+0x5a>
        panic("mappages: 大小SIZE没有对齐");
    
    if(size == 0)
    8000189a:	020a0c63          	beqz	s4,800018d2 <mappages+0x68>
        panic("mappages: 大小SIZE为0");
    
    a = va;
    list = va + size - PGSIZE;
    8000189e:	77fd                	lui	a5,0xfffff
    800018a0:	9a3e                	add	s4,s4,a5
    800018a2:	9a26                	add	s4,s4,s1
    a = va;
    800018a4:	89a6                	mv	s3,s1
    800018a6:	409a8ab3          	sub	s5,s5,s1
        if((pte = walk(pagetable, a, 1)) == 0)
            return -1;
        
        // 这里的数据一定是没有被分配的
        if(*pte & PTE_V)
            panic("mappages: 重复分配页");
    800018aa:	00002c97          	auipc	s9,0x2
    800018ae:	bb6c8c93          	add	s9,s9,-1098 # 80003460 <digits+0x2a0>

        // 分配完成
        if(a == list)
            break;

        a += PGSIZE;
    800018b2:	6c05                	lui	s8,0x1
    800018b4:	a089                	j	800018f6 <mappages+0x8c>
        panic("mappages: 虚拟地址VA没有对齐");
    800018b6:	00002517          	auipc	a0,0x2
    800018ba:	b3a50513          	add	a0,a0,-1222 # 800033f0 <digits+0x230>
    800018be:	a50ff0ef          	jal	80000b0e <panic>
    800018c2:	bfc9                	j	80001894 <mappages+0x2a>
        panic("mappages: 大小SIZE没有对齐");
    800018c4:	00002517          	auipc	a0,0x2
    800018c8:	b5450513          	add	a0,a0,-1196 # 80003418 <digits+0x258>
    800018cc:	a42ff0ef          	jal	80000b0e <panic>
    if(size == 0)
    800018d0:	b7f9                	j	8000189e <mappages+0x34>
        panic("mappages: 大小SIZE为0");
    800018d2:	00002517          	auipc	a0,0x2
    800018d6:	b6e50513          	add	a0,a0,-1170 # 80003440 <digits+0x280>
    800018da:	a34ff0ef          	jal	80000b0e <panic>
    800018de:	b7c1                	j	8000189e <mappages+0x34>
        *pte = PA2PTE(pa) | perm | PTE_V;
    800018e0:	80b1                	srl	s1,s1,0xc
    800018e2:	04aa                	sll	s1,s1,0xa
    800018e4:	0174e4b3          	or	s1,s1,s7
    800018e8:	0014e493          	or	s1,s1,1
    800018ec:	00993023          	sd	s1,0(s2)
        if(a == list)
    800018f0:	05498163          	beq	s3,s4,80001932 <mappages+0xc8>
        a += PGSIZE;
    800018f4:	99e2                	add	s3,s3,s8
    for(;;){
    800018f6:	015984b3          	add	s1,s3,s5
        if((pte = walk(pagetable, a, 1)) == 0)
    800018fa:	4605                	li	a2,1
    800018fc:	85ce                	mv	a1,s3
    800018fe:	855a                	mv	a0,s6
    80001900:	ecdff0ef          	jal	800017cc <walk>
    80001904:	892a                	mv	s2,a0
    80001906:	c901                	beqz	a0,80001916 <mappages+0xac>
        if(*pte & PTE_V)
    80001908:	611c                	ld	a5,0(a0)
    8000190a:	8b85                	and	a5,a5,1
    8000190c:	dbf1                	beqz	a5,800018e0 <mappages+0x76>
            panic("mappages: 重复分配页");
    8000190e:	8566                	mv	a0,s9
    80001910:	9feff0ef          	jal	80000b0e <panic>
    80001914:	b7f1                	j	800018e0 <mappages+0x76>
            return -1;
    80001916:	557d                	li	a0,-1
        pa += PGSIZE;
    }
    return 0;
}
    80001918:	60e6                	ld	ra,88(sp)
    8000191a:	6446                	ld	s0,80(sp)
    8000191c:	64a6                	ld	s1,72(sp)
    8000191e:	6906                	ld	s2,64(sp)
    80001920:	79e2                	ld	s3,56(sp)
    80001922:	7a42                	ld	s4,48(sp)
    80001924:	7aa2                	ld	s5,40(sp)
    80001926:	7b02                	ld	s6,32(sp)
    80001928:	6be2                	ld	s7,24(sp)
    8000192a:	6c42                	ld	s8,16(sp)
    8000192c:	6ca2                	ld	s9,8(sp)
    8000192e:	6125                	add	sp,sp,96
    80001930:	8082                	ret
    return 0;
    80001932:	4501                	li	a0,0
    80001934:	b7d5                	j	80001918 <mappages+0xae>

0000000080001936 <kvmmap>:
void kvmmap(pagetable_t kpgtbl, uint64 va, uint64 pa, uint64 sz, int perm){
    80001936:	1141                	add	sp,sp,-16
    80001938:	e406                	sd	ra,8(sp)
    8000193a:	e022                	sd	s0,0(sp)
    8000193c:	0800                	add	s0,sp,16
    8000193e:	87b6                	mv	a5,a3
    if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001940:	86b2                	mv	a3,a2
    80001942:	863e                	mv	a2,a5
    80001944:	f27ff0ef          	jal	8000186a <mappages>
    80001948:	e509                	bnez	a0,80001952 <kvmmap+0x1c>
}
    8000194a:	60a2                	ld	ra,8(sp)
    8000194c:	6402                	ld	s0,0(sp)
    8000194e:	0141                	add	sp,sp,16
    80001950:	8082                	ret
        panic("kvmmap");
    80001952:	00002517          	auipc	a0,0x2
    80001956:	b2e50513          	add	a0,a0,-1234 # 80003480 <digits+0x2c0>
    8000195a:	9b4ff0ef          	jal	80000b0e <panic>
}
    8000195e:	b7f5                	j	8000194a <kvmmap+0x14>

0000000080001960 <kvmmake>:
kvmmake(void){
    80001960:	1101                	add	sp,sp,-32
    80001962:	ec06                	sd	ra,24(sp)
    80001964:	e822                	sd	s0,16(sp)
    80001966:	e426                	sd	s1,8(sp)
    80001968:	e04a                	sd	s2,0(sp)
    8000196a:	1000                	add	s0,sp,32
    kpgtbl = (pagetable_t) kalloc();
    8000196c:	de9ff0ef          	jal	80001754 <kalloc>
    80001970:	84aa                	mv	s1,a0
    memset(kpgtbl, 0, PGSIZE);
    80001972:	6605                	lui	a2,0x1
    80001974:	4581                	li	a1,0
    80001976:	b5cff0ef          	jal	80000cd2 <memset>
    kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000197a:	4719                	li	a4,6
    8000197c:	6685                	lui	a3,0x1
    8000197e:	10000637          	lui	a2,0x10000
    80001982:	100005b7          	lui	a1,0x10000
    80001986:	8526                	mv	a0,s1
    80001988:	fafff0ef          	jal	80001936 <kvmmap>
    kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000198c:	4719                	li	a4,6
    8000198e:	6685                	lui	a3,0x1
    80001990:	10001637          	lui	a2,0x10001
    80001994:	100015b7          	lui	a1,0x10001
    80001998:	8526                	mv	a0,s1
    8000199a:	f9dff0ef          	jal	80001936 <kvmmap>
    kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    8000199e:	4719                	li	a4,6
    800019a0:	040006b7          	lui	a3,0x4000
    800019a4:	0c000637          	lui	a2,0xc000
    800019a8:	0c0005b7          	lui	a1,0xc000
    800019ac:	8526                	mv	a0,s1
    800019ae:	f89ff0ef          	jal	80001936 <kvmmap>
    kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800019b2:	00001917          	auipc	s2,0x1
    800019b6:	64e90913          	add	s2,s2,1614 # 80003000 <etext>
    800019ba:	4729                	li	a4,10
    800019bc:	80001697          	auipc	a3,0x80001
    800019c0:	64468693          	add	a3,a3,1604 # 3000 <_entry-0x7fffd000>
    800019c4:	4605                	li	a2,1
    800019c6:	067e                	sll	a2,a2,0x1f
    800019c8:	85b2                	mv	a1,a2
    800019ca:	8526                	mv	a0,s1
    800019cc:	f6bff0ef          	jal	80001936 <kvmmap>
    kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800019d0:	4719                	li	a4,6
    800019d2:	46c5                	li	a3,17
    800019d4:	06ee                	sll	a3,a3,0x1b
    800019d6:	412686b3          	sub	a3,a3,s2
    800019da:	864a                	mv	a2,s2
    800019dc:	85ca                	mv	a1,s2
    800019de:	8526                	mv	a0,s1
    800019e0:	f57ff0ef          	jal	80001936 <kvmmap>
    kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800019e4:	4729                	li	a4,10
    800019e6:	6685                	lui	a3,0x1
    800019e8:	00000617          	auipc	a2,0x0
    800019ec:	61860613          	add	a2,a2,1560 # 80002000 <_trampoline>
    800019f0:	040005b7          	lui	a1,0x4000
    800019f4:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800019f6:	05b2                	sll	a1,a1,0xc
    800019f8:	8526                	mv	a0,s1
    800019fa:	f3dff0ef          	jal	80001936 <kvmmap>
    proc_mapstacks(kpgtbl);
    800019fe:	8526                	mv	a0,s1
    80001a00:	060000ef          	jal	80001a60 <proc_mapstacks>
}
    80001a04:	8526                	mv	a0,s1
    80001a06:	60e2                	ld	ra,24(sp)
    80001a08:	6442                	ld	s0,16(sp)
    80001a0a:	64a2                	ld	s1,8(sp)
    80001a0c:	6902                	ld	s2,0(sp)
    80001a0e:	6105                	add	sp,sp,32
    80001a10:	8082                	ret

0000000080001a12 <kvminit>:

// Initialize the kernel_pagetable, shared by all CPUs.
void
kvminit(void)
{
    80001a12:	1141                	add	sp,sp,-16
    80001a14:	e406                	sd	ra,8(sp)
    80001a16:	e022                	sd	s0,0(sp)
    80001a18:	0800                	add	s0,sp,16
  kernel_pagetable = kvmmake();
    80001a1a:	f47ff0ef          	jal	80001960 <kvmmake>
    80001a1e:	00002797          	auipc	a5,0x2
    80001a22:	aea7b123          	sd	a0,-1310(a5) # 80003500 <kernel_pagetable>
}
    80001a26:	60a2                	ld	ra,8(sp)
    80001a28:	6402                	ld	s0,0(sp)
    80001a2a:	0141                	add	sp,sp,16
    80001a2c:	8082                	ret

0000000080001a2e <cpuid>:

struct cpu cpus[NCPU];

struct proc proc[NPROC];

int cpuid() {
    80001a2e:	1141                	add	sp,sp,-16
    80001a30:	e422                	sd	s0,8(sp)
    80001a32:	0800                	add	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001a34:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001a36:	2501                	sext.w	a0,a0
    80001a38:	6422                	ld	s0,8(sp)
    80001a3a:	0141                	add	sp,sp,16
    80001a3c:	8082                	ret

0000000080001a3e <mycpu>:

struct cpu* 
mycpu(void){
    80001a3e:	1141                	add	sp,sp,-16
    80001a40:	e422                	sd	s0,8(sp)
    80001a42:	0800                	add	s0,sp,16
    80001a44:	8712                	mv	a4,tp
    struct cpu *c = &cpus[cpuid()];
    80001a46:	2701                	sext.w	a4,a4
    80001a48:	00471793          	sll	a5,a4,0x4
    80001a4c:	8f99                	sub	a5,a5,a4
    80001a4e:	078e                	sll	a5,a5,0x3
    return c;
}
    80001a50:	00005517          	auipc	a0,0x5
    80001a54:	bc050513          	add	a0,a0,-1088 # 80006610 <cpus>
    80001a58:	953e                	add	a0,a0,a5
    80001a5a:	6422                	ld	s0,8(sp)
    80001a5c:	0141                	add	sp,sp,16
    80001a5e:	8082                	ret

0000000080001a60 <proc_mapstacks>:


void 
proc_mapstacks(pagetable_t kpgtbl){
    80001a60:	715d                	add	sp,sp,-80
    80001a62:	e486                	sd	ra,72(sp)
    80001a64:	e0a2                	sd	s0,64(sp)
    80001a66:	fc26                	sd	s1,56(sp)
    80001a68:	f84a                	sd	s2,48(sp)
    80001a6a:	f44e                	sd	s3,40(sp)
    80001a6c:	f052                	sd	s4,32(sp)
    80001a6e:	ec56                	sd	s5,24(sp)
    80001a70:	e85a                	sd	s6,16(sp)
    80001a72:	e45e                	sd	s7,8(sp)
    80001a74:	e062                	sd	s8,0(sp)
    80001a76:	0880                	add	s0,sp,80
    80001a78:	8a2a                	mv	s4,a0
  struct proc* p;
  for(p = proc; p < &proc[NPROC]; p++){
    80001a7a:	00005917          	auipc	s2,0x5
    80001a7e:	f5690913          	add	s2,s2,-170 # 800069d0 <proc>
    char* pa = kalloc();
    if(pa==0)
      panic("proc_mapstacks: 内核分配进程栈时空间不足分配失败");
    80001a82:	00002c17          	auipc	s8,0x2
    80001a86:	a06c0c13          	add	s8,s8,-1530 # 80003488 <digits+0x2c8>
    
    uint64 va = KSTACK((int)(p - proc));
    80001a8a:	8bca                	mv	s7,s2
    80001a8c:	00001b17          	auipc	s6,0x1
    80001a90:	574b0b13          	add	s6,s6,1396 # 80003000 <etext>
    80001a94:	040009b7          	lui	s3,0x4000
    80001a98:	19fd                	add	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001a9a:	09b2                	sll	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++){
    80001a9c:	00006a97          	auipc	s5,0x6
    80001aa0:	934a8a93          	add	s5,s5,-1740 # 800073d0 <end>
    80001aa4:	a03d                	j	80001ad2 <proc_mapstacks+0x72>
    uint64 va = KSTACK((int)(p - proc));
    80001aa6:	417905b3          	sub	a1,s2,s7
    80001aaa:	858d                	sra	a1,a1,0x3
    80001aac:	000b3783          	ld	a5,0(s6)
    80001ab0:	02f585b3          	mul	a1,a1,a5
    80001ab4:	2585                	addw	a1,a1,1
    80001ab6:	00d5959b          	sllw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001aba:	4719                	li	a4,6
    80001abc:	6685                	lui	a3,0x1
    80001abe:	8626                	mv	a2,s1
    80001ac0:	40b985b3          	sub	a1,s3,a1
    80001ac4:	8552                	mv	a0,s4
    80001ac6:	e71ff0ef          	jal	80001936 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++){
    80001aca:	02890913          	add	s2,s2,40
    80001ace:	01590a63          	beq	s2,s5,80001ae2 <proc_mapstacks+0x82>
    char* pa = kalloc();
    80001ad2:	c83ff0ef          	jal	80001754 <kalloc>
    80001ad6:	84aa                	mv	s1,a0
    if(pa==0)
    80001ad8:	f579                	bnez	a0,80001aa6 <proc_mapstacks+0x46>
      panic("proc_mapstacks: 内核分配进程栈时空间不足分配失败");
    80001ada:	8562                	mv	a0,s8
    80001adc:	832ff0ef          	jal	80000b0e <panic>
    80001ae0:	b7d9                	j	80001aa6 <proc_mapstacks+0x46>
  }
    80001ae2:	60a6                	ld	ra,72(sp)
    80001ae4:	6406                	ld	s0,64(sp)
    80001ae6:	74e2                	ld	s1,56(sp)
    80001ae8:	7942                	ld	s2,48(sp)
    80001aea:	79a2                	ld	s3,40(sp)
    80001aec:	7a02                	ld	s4,32(sp)
    80001aee:	6ae2                	ld	s5,24(sp)
    80001af0:	6b42                	ld	s6,16(sp)
    80001af2:	6ba2                	ld	s7,8(sp)
    80001af4:	6c02                	ld	s8,0(sp)
    80001af6:	6161                	add	sp,sp,80
    80001af8:	8082                	ret
	...

0000000080002000 <_trampoline>:
    80002000:	14051073          	csrw	sscratch,a0
    80002004:	02000537          	lui	a0,0x2000
    80002008:	357d                	addw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000200a:	0536                	sll	a0,a0,0xd
    8000200c:	02153423          	sd	ra,40(a0)
    80002010:	02253823          	sd	sp,48(a0)
    80002014:	02353c23          	sd	gp,56(a0)
    80002018:	04453023          	sd	tp,64(a0)
    8000201c:	04553423          	sd	t0,72(a0)
    80002020:	04653823          	sd	t1,80(a0)
    80002024:	04753c23          	sd	t2,88(a0)
    80002028:	f120                	sd	s0,96(a0)
    8000202a:	f524                	sd	s1,104(a0)
    8000202c:	fd2c                	sd	a1,120(a0)
    8000202e:	e150                	sd	a2,128(a0)
    80002030:	e554                	sd	a3,136(a0)
    80002032:	e958                	sd	a4,144(a0)
    80002034:	ed5c                	sd	a5,152(a0)
    80002036:	0b053023          	sd	a6,160(a0)
    8000203a:	0b153423          	sd	a7,168(a0)
    8000203e:	0b253823          	sd	s2,176(a0)
    80002042:	0b353c23          	sd	s3,184(a0)
    80002046:	0d453023          	sd	s4,192(a0)
    8000204a:	0d553423          	sd	s5,200(a0)
    8000204e:	0d653823          	sd	s6,208(a0)
    80002052:	0d753c23          	sd	s7,216(a0)
    80002056:	0f853023          	sd	s8,224(a0)
    8000205a:	0f953423          	sd	s9,232(a0)
    8000205e:	0fa53823          	sd	s10,240(a0)
    80002062:	0fb53c23          	sd	s11,248(a0)
    80002066:	11c53023          	sd	t3,256(a0)
    8000206a:	11d53423          	sd	t4,264(a0)
    8000206e:	11e53823          	sd	t5,272(a0)
    80002072:	11f53c23          	sd	t6,280(a0)
    80002076:	140022f3          	csrr	t0,sscratch
    8000207a:	06553823          	sd	t0,112(a0)
    8000207e:	00853103          	ld	sp,8(a0)
    80002082:	02053203          	ld	tp,32(a0)
    80002086:	01053283          	ld	t0,16(a0)
    8000208a:	00053303          	ld	t1,0(a0)
    8000208e:	12000073          	sfence.vma
    80002092:	18031073          	csrw	satp,t1
    80002096:	12000073          	sfence.vma
    8000209a:	9282                	jalr	t0

000000008000209c <userret>:
    8000209c:	12000073          	sfence.vma
    800020a0:	18051073          	csrw	satp,a0
    800020a4:	12000073          	sfence.vma
    800020a8:	02000537          	lui	a0,0x2000
    800020ac:	357d                	addw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800020ae:	0536                	sll	a0,a0,0xd
    800020b0:	02853083          	ld	ra,40(a0)
    800020b4:	03053103          	ld	sp,48(a0)
    800020b8:	03853183          	ld	gp,56(a0)
    800020bc:	04053203          	ld	tp,64(a0)
    800020c0:	04853283          	ld	t0,72(a0)
    800020c4:	05053303          	ld	t1,80(a0)
    800020c8:	05853383          	ld	t2,88(a0)
    800020cc:	7120                	ld	s0,96(a0)
    800020ce:	7524                	ld	s1,104(a0)
    800020d0:	7d2c                	ld	a1,120(a0)
    800020d2:	6150                	ld	a2,128(a0)
    800020d4:	6554                	ld	a3,136(a0)
    800020d6:	6958                	ld	a4,144(a0)
    800020d8:	6d5c                	ld	a5,152(a0)
    800020da:	0a053803          	ld	a6,160(a0)
    800020de:	0a853883          	ld	a7,168(a0)
    800020e2:	0b053903          	ld	s2,176(a0)
    800020e6:	0b853983          	ld	s3,184(a0)
    800020ea:	0c053a03          	ld	s4,192(a0)
    800020ee:	0c853a83          	ld	s5,200(a0)
    800020f2:	0d053b03          	ld	s6,208(a0)
    800020f6:	0d853b83          	ld	s7,216(a0)
    800020fa:	0e053c03          	ld	s8,224(a0)
    800020fe:	0e853c83          	ld	s9,232(a0)
    80002102:	0f053d03          	ld	s10,240(a0)
    80002106:	0f853d83          	ld	s11,248(a0)
    8000210a:	10053e03          	ld	t3,256(a0)
    8000210e:	10853e83          	ld	t4,264(a0)
    80002112:	11053f03          	ld	t5,272(a0)
    80002116:	11853f83          	ld	t6,280(a0)
    8000211a:	7928                	ld	a0,112(a0)
    8000211c:	10200073          	sret
	...
