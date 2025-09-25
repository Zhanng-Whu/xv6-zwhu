
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
.section .text
.global _entry, test
_entry:
        la sp, stack0
    80000000:	00002117          	auipc	sp,0x2
    80000004:	20010113          	add	sp,sp,512 # 80002200 <stack0>
        li a0, 1024*8
    80000008:	6509                	lui	a0,0x2
        # 对于一个单核系统 这里不需要考虑hartid的数量
        add sp, sp, a0
    8000000a:	912a                	add	sp,sp,a0
        call start
    8000000c:	168000ef          	jal	80000174 <start>

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
    8000001e:	a001                	j	8000001e <spin>

0000000080000020 <test_printf_basic>:
// start() jumps here in supervisor mode on all CPUs.


#define INT_MIN 0x80000000

void test_printf_basic() {
    80000020:	1141                	add	sp,sp,-16
    80000022:	e406                	sd	ra,8(sp)
    80000024:	e022                	sd	s0,0(sp)
    80000026:	0800                	add	s0,sp,16
    printf("Testing integer: %d\n", 42);
    80000028:	02a00593          	li	a1,42
    8000002c:	00002517          	auipc	a0,0x2
    80000030:	fd450513          	add	a0,a0,-44 # 80002000 <userret+0xf64>
    80000034:	3c4000ef          	jal	800003f8 <printf>
    printf("Testing negative: %d\n", -123);
    80000038:	f8500593          	li	a1,-123
    8000003c:	00002517          	auipc	a0,0x2
    80000040:	fdc50513          	add	a0,a0,-36 # 80002018 <userret+0xf7c>
    80000044:	3b4000ef          	jal	800003f8 <printf>
    printf("Testing zero: %d\n", 0);
    80000048:	4581                	li	a1,0
    8000004a:	00002517          	auipc	a0,0x2
    8000004e:	fe650513          	add	a0,a0,-26 # 80002030 <userret+0xf94>
    80000052:	3a6000ef          	jal	800003f8 <printf>
    printf("Testing hex: 0x%x\n", 0xABC);
    80000056:	6585                	lui	a1,0x1
    80000058:	abc58593          	add	a1,a1,-1348 # abc <_entry-0x7ffff544>
    8000005c:	00002517          	auipc	a0,0x2
    80000060:	fec50513          	add	a0,a0,-20 # 80002048 <userret+0xfac>
    80000064:	394000ef          	jal	800003f8 <printf>
    printf("Testing string: %s\n", "Hello");
    80000068:	00002597          	auipc	a1,0x2
    8000006c:	ff858593          	add	a1,a1,-8 # 80002060 <userret+0xfc4>
    80000070:	00002517          	auipc	a0,0x2
    80000074:	ff850513          	add	a0,a0,-8 # 80002068 <userret+0xfcc>
    80000078:	380000ef          	jal	800003f8 <printf>
    printf("Testing char: %c\n", 'X');
    8000007c:	05800593          	li	a1,88
    80000080:	00002517          	auipc	a0,0x2
    80000084:	00050513          	mv	a0,a0
    80000088:	370000ef          	jal	800003f8 <printf>
    printf("Testing percent: %%\n");
    8000008c:	00002517          	auipc	a0,0x2
    80000090:	00c50513          	add	a0,a0,12 # 80002098 <userret+0xffc>
    80000094:	364000ef          	jal	800003f8 <printf>
}
    80000098:	60a2                	ld	ra,8(sp)
    8000009a:	6402                	ld	s0,0(sp)
    8000009c:	0141                	add	sp,sp,16
    8000009e:	8082                	ret

00000000800000a0 <test_printf_edge_cases>:
void test_printf_edge_cases() {
    800000a0:	1141                	add	sp,sp,-16
    800000a2:	e406                	sd	ra,8(sp)
    800000a4:	e022                	sd	s0,0(sp)
    800000a6:	0800                	add	s0,sp,16
    printf("INT_MAX: %d\n", 2147483647);
    800000a8:	800005b7          	lui	a1,0x80000
    800000ac:	fff5c593          	not	a1,a1
    800000b0:	00002517          	auipc	a0,0x2
    800000b4:	00050513          	mv	a0,a0
    800000b8:	340000ef          	jal	800003f8 <printf>
    printf("INT_MIN: %d\n", -2147483648);
    800000bc:	800005b7          	lui	a1,0x80000
    800000c0:	00002517          	auipc	a0,0x2
    800000c4:	00050513          	mv	a0,a0
    800000c8:	330000ef          	jal	800003f8 <printf>
    printf("NULL string: %s\n", (char*)0);
    800000cc:	4581                	li	a1,0
    800000ce:	00002517          	auipc	a0,0x2
    800000d2:	00250513          	add	a0,a0,2 # 800020d0 <userret+0x1034>
    800000d6:	322000ef          	jal	800003f8 <printf>
    printf("Empty string: %s\n", "");
    800000da:	00002597          	auipc	a1,0x2
    800000de:	00658593          	add	a1,a1,6 # 800020e0 <userret+0x1044>
    800000e2:	00002517          	auipc	a0,0x2
    800000e6:	00650513          	add	a0,a0,6 # 800020e8 <userret+0x104c>
    800000ea:	30e000ef          	jal	800003f8 <printf>
}
    800000ee:	60a2                	ld	ra,8(sp)
    800000f0:	6402                	ld	s0,0(sp)
    800000f2:	0141                	add	sp,sp,16
    800000f4:	8082                	ret

00000000800000f6 <main>:

void
main()
{
    800000f6:	1141                	add	sp,sp,-16
    800000f8:	e406                	sd	ra,8(sp)
    800000fa:	e022                	sd	s0,0(sp)
    800000fc:	0800                	add	s0,sp,16

  consoleinit();
    800000fe:	110000ef          	jal	8000020e <consoleinit>
  printfinit();
    80000102:	0d9000ef          	jal	800009da <printfinit>

  printf("HelloWorld");
    80000106:	00002517          	auipc	a0,0x2
    8000010a:	ffa50513          	add	a0,a0,-6 # 80002100 <userret+0x1064>
    8000010e:	2ea000ef          	jal	800003f8 <printf>
  printf("%d", INT_MIN);
    80000112:	800005b7          	lui	a1,0x80000
    80000116:	00002517          	auipc	a0,0x2
    8000011a:	ffa50513          	add	a0,a0,-6 # 80002110 <userret+0x1074>
    8000011e:	2da000ef          	jal	800003f8 <printf>

  test_printf_basic();
    80000122:	effff0ef          	jal	80000020 <test_printf_basic>
  test_printf_edge_cases();
    80000126:	f7bff0ef          	jal	800000a0 <test_printf_edge_cases>

  clear_screen();
    8000012a:	572000ef          	jal	8000069c <clear_screen>
  goto_xy(10, 5);
    8000012e:	4595                	li	a1,5
    80000130:	4529                	li	a0,10
    80000132:	592000ef          	jal	800006c4 <goto_xy>
  printf_color(32, "Green Text at (10,5)\n");
    80000136:	00002597          	auipc	a1,0x2
    8000013a:	fe258593          	add	a1,a1,-30 # 80002118 <userret+0x107c>
    8000013e:	02000513          	li	a0,32
    80000142:	5b8000ef          	jal	800006fa <printf_color>
  printf_color(31, "Red Text\n");
    80000146:	00002597          	auipc	a1,0x2
    8000014a:	fea58593          	add	a1,a1,-22 # 80002130 <userret+0x1094>
    8000014e:	457d                	li	a0,31
    80000150:	5aa000ef          	jal	800006fa <printf_color>
  printf_color(34, "Blue Text\n");
    80000154:	00002597          	auipc	a1,0x2
    80000158:	fec58593          	add	a1,a1,-20 # 80002140 <userret+0x10a4>
    8000015c:	02200513          	li	a0,34
    80000160:	59a000ef          	jal	800006fa <printf_color>
  printf_color(0, "Default Color Text\n");
    80000164:	00002597          	auipc	a1,0x2
    80000168:	fec58593          	add	a1,a1,-20 # 80002150 <userret+0x10b4>
    8000016c:	4501                	li	a0,0
    8000016e:	58c000ef          	jal	800006fa <printf_color>
  // 啥都别干
  for(;;)
    80000172:	a001                	j	80000172 <main+0x7c>

0000000080000174 <start>:
__attribute__ ((aligned (16))) char stack0[4096 * 3];

// entry.S jumps here in machine mode on stack0.
void
start()
{
    80000174:	1141                	add	sp,sp,-16
    80000176:	e422                	sd	s0,8(sp)
    80000178:	0800                	add	s0,sp,16

static inline uint64
r_mstatus()
{
  uint64 x;
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000017a:	300027f3          	csrr	a5,mstatus
  // set M Previous Privilege mode to Supervisor, for mret.
  unsigned long x = r_mstatus();
  x &= ~MSTATUS_MPP_MASK;
    8000017e:	7779                	lui	a4,0xffffe
    80000180:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <cpus+0xffffffff7fff953f>
    80000184:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000186:	6705                	lui	a4,0x1
    80000188:	80070713          	add	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000018c:	8fd9                	or	a5,a5,a4
}

static inline void 
w_mstatus(uint64 x)
{
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000018e:	30079073          	csrw	mstatus,a5
// instruction address to which a return from
// exception will go.
static inline void 
w_mepc(uint64 x)
{
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000192:	00000797          	auipc	a5,0x0
    80000196:	f6478793          	add	a5,a5,-156 # 800000f6 <main>
    8000019a:	34179073          	csrw	mepc,a5
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000019e:	4781                	li	a5,0
    800001a0:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800001a4:	67c1                	lui	a5,0x10
    800001a6:	17fd                	add	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800001a8:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800001ac:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800001b0:	104027f3          	csrr	a5,sie

  // delegate all interrupts and exceptions to supervisor mode.

  w_medeleg(0xffff);
  w_mideleg(0xffff);
  w_sie(r_sie() | SIE_SEIE);
    800001b4:	2007e793          	or	a5,a5,512
  asm volatile("csrw sie, %0" : : "r" (x));
    800001b8:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800001bc:	57fd                	li	a5,-1
    800001be:	83a9                	srl	a5,a5,0xa
    800001c0:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800001c4:	47bd                	li	a5,15
    800001c6:	3a079073          	csrw	pmpcfg0,a5
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800001ca:	f14027f3          	csrr	a5,mhartid
  // ask for clock interrupts.
  // timerinit();

  // keep each CPU's hartid in its tp register, for cpuid().
  int id = r_mhartid();
  w_tp(id);
    800001ce:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800001d0:	823e                	mv	tp,a5

  // switch to supervisor mode and jump to main().
  asm volatile("mret");
    800001d2:	30200073          	mret
}
    800001d6:	6422                	ld	s0,8(sp)
    800001d8:	0141                	add	sp,sp,16
    800001da:	8082                	ret

00000000800001dc <consputc>:
    uint w;  // Write index
    uint e;  // Edit index
} cons;


void consputc(int c){
    800001dc:	1141                	add	sp,sp,-16
    800001de:	e406                	sd	ra,8(sp)
    800001e0:	e022                	sd	s0,0(sp)
    800001e2:	0800                	add	s0,sp,16
    if(c == BACKSPACE){
    800001e4:	10000793          	li	a5,256
    800001e8:	00f50863          	beq	a0,a5,800001f8 <consputc+0x1c>
        // if the user typed backspace, overwrite with a space.
        uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    } else {
        uartputc_sync(c);        
    800001ec:	0de000ef          	jal	800002ca <uartputc_sync>
    }
}
    800001f0:	60a2                	ld	ra,8(sp)
    800001f2:	6402                	ld	s0,0(sp)
    800001f4:	0141                	add	sp,sp,16
    800001f6:	8082                	ret
        uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800001f8:	4521                	li	a0,8
    800001fa:	0d0000ef          	jal	800002ca <uartputc_sync>
    800001fe:	02000513          	li	a0,32
    80000202:	0c8000ef          	jal	800002ca <uartputc_sync>
    80000206:	4521                	li	a0,8
    80000208:	0c2000ef          	jal	800002ca <uartputc_sync>
    8000020c:	b7d5                	j	800001f0 <consputc+0x14>

000000008000020e <consoleinit>:

void consoleinit(){
    8000020e:	1141                	add	sp,sp,-16
    80000210:	e406                	sd	ra,8(sp)
    80000212:	e022                	sd	s0,0(sp)
    80000214:	0800                	add	s0,sp,16
    initlock(&cons.lock, "cons");
    80000216:	00002597          	auipc	a1,0x2
    8000021a:	f5258593          	add	a1,a1,-174 # 80002168 <userret+0x10cc>
    8000021e:	00005517          	auipc	a0,0x5
    80000222:	fe250513          	add	a0,a0,-30 # 80005200 <cons>
    80000226:	003000ef          	jal	80000a28 <initlock>
    uartinit();
    8000022a:	00c000ef          	jal	80000236 <uartinit>
    8000022e:	60a2                	ld	ra,8(sp)
    80000230:	6402                	ld	s0,0(sp)
    80000232:	0141                	add	sp,sp,16
    80000234:	8082                	ret

0000000080000236 <uartinit>:


extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void uartinit(void){
    80000236:	1141                	add	sp,sp,-16
    80000238:	e422                	sd	s0,8(sp)
    8000023a:	0800                	add	s0,sp,16
    // 关闭读取中断
    WriteReg(IER, 0x00);
    8000023c:	100007b7          	lui	a5,0x10000
    80000240:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

    // 设置波特率和信息位
    // 这里是一个常用波特率 38400
    // 计算方法是 115200 / 3 = 38400
    // 按照习惯 一次传递一个字节
    WriteReg(LCR, LCR_BAUD_LATCH);
    80000244:	f8000713          	li	a4,-128
    80000248:	00e781a3          	sb	a4,3(a5)
    WriteReg(0, 0x03); // LSB
    8000024c:	470d                	li	a4,3
    8000024e:	00e78023          	sb	a4,0(a5)
    WriteReg(1, 0x00); // MSB
    80000252:	000780a3          	sb	zero,1(a5)
    WriteReg(LCR, LCR_EIGHT_BITS);
    80000256:	00e781a3          	sb	a4,3(a5)

    // 启动缓冲区
    WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000025a:	471d                	li	a4,7
    8000025c:	00e78123          	sb	a4,2(a5)

    // 开启读写中断 这里先注释掉 需要等后面配置完中断再开启
    // WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);

}
    80000260:	6422                	ld	s0,8(sp)
    80000262:	0141                	add	sp,sp,16
    80000264:	8082                	ret

0000000080000266 <uart_putc>:


void uart_putc(char c){
    80000266:	1141                	add	sp,sp,-16
    80000268:	e422                	sd	s0,8(sp)
    8000026a:	0800                	add	s0,sp,16
    // 等待串口发送完成
    while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000026c:	10000737          	lui	a4,0x10000
    80000270:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000274:	0207f793          	and	a5,a5,32
    80000278:	dfe5                	beqz	a5,80000270 <uart_putc+0xa>
    ;
    WriteReg(THR, c);
    8000027a:	100007b7          	lui	a5,0x10000
    8000027e:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>
}
    80000282:	6422                	ld	s0,8(sp)
    80000284:	0141                	add	sp,sp,16
    80000286:	8082                	ret

0000000080000288 <uart_puts>:

void uart_puts(char *s){
    char* tmp = s;
    while(*s){
    80000288:	00054783          	lbu	a5,0(a0)
    8000028c:	cf95                	beqz	a5,800002c8 <uart_puts+0x40>
void uart_puts(char *s){
    8000028e:	1101                	add	sp,sp,-32
    80000290:	ec06                	sd	ra,24(sp)
    80000292:	e822                	sd	s0,16(sp)
    80000294:	e426                	sd	s1,8(sp)
    80000296:	e04a                	sd	s2,0(sp)
    80000298:	1000                	add	s0,sp,32
    8000029a:	84aa                	mv	s1,a0
        if(*s == '\n')
    8000029c:	4929                	li	s2,10
    8000029e:	a809                	j	800002b0 <uart_puts+0x28>
            uart_putc('\r');
        uart_putc(*s++);
    800002a0:	0485                	add	s1,s1,1
    800002a2:	fff4c503          	lbu	a0,-1(s1)
    800002a6:	fc1ff0ef          	jal	80000266 <uart_putc>
    while(*s){
    800002aa:	0004c783          	lbu	a5,0(s1)
    800002ae:	c799                	beqz	a5,800002bc <uart_puts+0x34>
        if(*s == '\n')
    800002b0:	ff2798e3          	bne	a5,s2,800002a0 <uart_puts+0x18>
            uart_putc('\r');
    800002b4:	4535                	li	a0,13
    800002b6:	fb1ff0ef          	jal	80000266 <uart_putc>
    800002ba:	b7dd                	j	800002a0 <uart_puts+0x18>
    }
    s = tmp;
}
    800002bc:	60e2                	ld	ra,24(sp)
    800002be:	6442                	ld	s0,16(sp)
    800002c0:	64a2                	ld	s1,8(sp)
    800002c2:	6902                	ld	s2,0(sp)
    800002c4:	6105                	add	sp,sp,32
    800002c6:	8082                	ret
    800002c8:	8082                	ret

00000000800002ca <uartputc_sync>:


void uartputc_sync(int c)
{
    800002ca:	1101                	add	sp,sp,-32
    800002cc:	ec06                	sd	ra,24(sp)
    800002ce:	e822                	sd	s0,16(sp)
    800002d0:	e426                	sd	s1,8(sp)
    800002d2:	1000                	add	s0,sp,32
    800002d4:	84aa                	mv	s1,a0
  if(panicking == 0)
    800002d6:	00002797          	auipc	a5,0x2
    800002da:	f227a783          	lw	a5,-222(a5) # 800021f8 <panicking>
    800002de:	cb89                	beqz	a5,800002f0 <uartputc_sync+0x26>
    push_off();

  if(panicked){
    800002e0:	00002797          	auipc	a5,0x2
    800002e4:	f147a783          	lw	a5,-236(a5) # 800021f4 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800002e8:	10000737          	lui	a4,0x10000
  if(panicked){
    800002ec:	c789                	beqz	a5,800002f6 <uartputc_sync+0x2c>
    for(;;)
    800002ee:	a001                	j	800002ee <uartputc_sync+0x24>
    push_off();
    800002f0:	74e000ef          	jal	80000a3e <push_off>
    800002f4:	b7f5                	j	800002e0 <uartputc_sync+0x16>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800002f6:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800002fa:	0207f793          	and	a5,a5,32
    800002fe:	dfe5                	beqz	a5,800002f6 <uartputc_sync+0x2c>
    ;
  WriteReg(THR, c);
    80000300:	0ff4f513          	zext.b	a0,s1
    80000304:	100007b7          	lui	a5,0x10000
    80000308:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    8000030c:	00002797          	auipc	a5,0x2
    80000310:	eec7a783          	lw	a5,-276(a5) # 800021f8 <panicking>
    80000314:	c791                	beqz	a5,80000320 <uartputc_sync+0x56>
    pop_off();
}
    80000316:	60e2                	ld	ra,24(sp)
    80000318:	6442                	ld	s0,16(sp)
    8000031a:	64a2                	ld	s1,8(sp)
    8000031c:	6105                	add	sp,sp,32
    8000031e:	8082                	ret
    pop_off();
    80000320:	7a4000ef          	jal	80000ac4 <pop_off>
}
    80000324:	bfcd                	j	80000316 <uartputc_sync+0x4c>

0000000080000326 <printint>:



// base是进制 sign表示是否有符号
static void
printint(long long xx, int base ,int sign){
    80000326:	7139                	add	sp,sp,-64
    80000328:	fc06                	sd	ra,56(sp)
    8000032a:	f822                	sd	s0,48(sp)
    8000032c:	f426                	sd	s1,40(sp)
    8000032e:	f04a                	sd	s2,32(sp)
    80000330:	0080                	add	s0,sp,64
    80000332:	84aa                	mv	s1,a0
    80000334:	892e                	mv	s2,a1
    int i;

    unsigned long long x = 0;

    // 很巧妙的方法
    if(sign && xx < 0){
    80000336:	c219                	beqz	a2,8000033c <printint+0x16>
    80000338:	06054263          	bltz	a0,8000039c <printint+0x76>
printint(long long xx, int base ,int sign){
    8000033c:	fc040693          	add	a3,s0,-64
    80000340:	4701                	li	a4,0


    i = 0;
    // 这里用do while 处理 0 这样的数字
    do{
        buf[i++] = digits[x % base];
    80000342:	00002597          	auipc	a1,0x2
    80000346:	e6658593          	add	a1,a1,-410 # 800021a8 <digits>
    8000034a:	863a                	mv	a2,a4
    8000034c:	2705                	addw	a4,a4,1
    8000034e:	0324f7b3          	remu	a5,s1,s2
    80000352:	97ae                	add	a5,a5,a1
    80000354:	0007c783          	lbu	a5,0(a5)
    80000358:	00f68023          	sb	a5,0(a3)
        x /= base;
    8000035c:	87a6                	mv	a5,s1
    8000035e:	0324d4b3          	divu	s1,s1,s2
    }while(x);
    80000362:	0685                	add	a3,a3,1
    80000364:	ff27f3e3          	bgeu	a5,s2,8000034a <printint+0x24>

    while(--i >= 0)
    80000368:	02064463          	bltz	a2,80000390 <printint+0x6a>
    8000036c:	fc040793          	add	a5,s0,-64
    80000370:	00c784b3          	add	s1,a5,a2
    80000374:	fff78913          	add	s2,a5,-1
    80000378:	9932                	add	s2,s2,a2
    8000037a:	1602                	sll	a2,a2,0x20
    8000037c:	9201                	srl	a2,a2,0x20
    8000037e:	40c90933          	sub	s2,s2,a2
        consputc(buf[i]);
    80000382:	0004c503          	lbu	a0,0(s1)
    80000386:	e57ff0ef          	jal	800001dc <consputc>
    while(--i >= 0)
    8000038a:	14fd                	add	s1,s1,-1
    8000038c:	ff249be3          	bne	s1,s2,80000382 <printint+0x5c>
}
    80000390:	70e2                	ld	ra,56(sp)
    80000392:	7442                	ld	s0,48(sp)
    80000394:	74a2                	ld	s1,40(sp)
    80000396:	7902                	ld	s2,32(sp)
    80000398:	6121                	add	sp,sp,64
    8000039a:	8082                	ret
        x = -xx;
    8000039c:	40a004b3          	neg	s1,a0
        consputc('-');
    800003a0:	02d00513          	li	a0,45
    800003a4:	e39ff0ef          	jal	800001dc <consputc>
    800003a8:	bf51                	j	8000033c <printint+0x16>

00000000800003aa <printptr>:

static void 
printptr(uint64 x){
    800003aa:	7179                	add	sp,sp,-48
    800003ac:	f406                	sd	ra,40(sp)
    800003ae:	f022                	sd	s0,32(sp)
    800003b0:	ec26                	sd	s1,24(sp)
    800003b2:	e84a                	sd	s2,16(sp)
    800003b4:	e44e                	sd	s3,8(sp)
    800003b6:	1800                	add	s0,sp,48
    800003b8:	84aa                	mv	s1,a0
    int i;
    consputc('0');
    800003ba:	03000513          	li	a0,48
    800003be:	e1fff0ef          	jal	800001dc <consputc>
    consputc('x');
    800003c2:	07800513          	li	a0,120
    800003c6:	e17ff0ef          	jal	800001dc <consputc>
    800003ca:	4941                	li	s2,16
    for(i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
        consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800003cc:	00002997          	auipc	s3,0x2
    800003d0:	ddc98993          	add	s3,s3,-548 # 800021a8 <digits>
    800003d4:	03c4d793          	srl	a5,s1,0x3c
    800003d8:	97ce                	add	a5,a5,s3
    800003da:	0007c503          	lbu	a0,0(a5)
    800003de:	dffff0ef          	jal	800001dc <consputc>
    for(i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800003e2:	0492                	sll	s1,s1,0x4
    800003e4:	397d                	addw	s2,s2,-1
    800003e6:	fe0917e3          	bnez	s2,800003d4 <printptr+0x2a>
}
    800003ea:	70a2                	ld	ra,40(sp)
    800003ec:	7402                	ld	s0,32(sp)
    800003ee:	64e2                	ld	s1,24(sp)
    800003f0:	6942                	ld	s2,16(sp)
    800003f2:	69a2                	ld	s3,8(sp)
    800003f4:	6145                	add	sp,sp,48
    800003f6:	8082                	ret

00000000800003f8 <printf>:


int
printf(char* fmt, ...){
    800003f8:	7131                	add	sp,sp,-192
    800003fa:	fc86                	sd	ra,120(sp)
    800003fc:	f8a2                	sd	s0,112(sp)
    800003fe:	f4a6                	sd	s1,104(sp)
    80000400:	f0ca                	sd	s2,96(sp)
    80000402:	ecce                	sd	s3,88(sp)
    80000404:	e8d2                	sd	s4,80(sp)
    80000406:	e4d6                	sd	s5,72(sp)
    80000408:	e0da                	sd	s6,64(sp)
    8000040a:	fc5e                	sd	s7,56(sp)
    8000040c:	f862                	sd	s8,48(sp)
    8000040e:	f466                	sd	s9,40(sp)
    80000410:	f06a                	sd	s10,32(sp)
    80000412:	ec6e                	sd	s11,24(sp)
    80000414:	0100                	add	s0,sp,128
    80000416:	8a2a                	mv	s4,a0
    80000418:	e40c                	sd	a1,8(s0)
    8000041a:	e810                	sd	a2,16(s0)
    8000041c:	ec14                	sd	a3,24(s0)
    8000041e:	f018                	sd	a4,32(s0)
    80000420:	f41c                	sd	a5,40(s0)
    80000422:	03043823          	sd	a6,48(s0)
    80000426:	03143c23          	sd	a7,56(s0)
    va_list ap;
    int i, cx, c0 ,c1, c2;
    char* s;

    if(panicking == 0)
    8000042a:	00002797          	auipc	a5,0x2
    8000042e:	dce7a783          	lw	a5,-562(a5) # 800021f8 <panicking>
    80000432:	cb8d                	beqz	a5,80000464 <printf+0x6c>
        acquire(&pr.lock);
    
    va_start(ap, fmt);
    80000434:	00840793          	add	a5,s0,8
    80000438:	f8f43423          	sd	a5,-120(s0)



   for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000043c:	000a4503          	lbu	a0,0(s4)
    80000440:	22050263          	beqz	a0,80000664 <printf+0x26c>
    80000444:	4981                	li	s3,0
    if(cx != '%'){
    80000446:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    8000044a:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    8000044e:	06c00b93          	li	s7,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    80000452:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80000456:	07800c93          	li	s9,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    8000045a:	07000d13          	li	s10,112
      printptr(va_arg(ap, uint64));
    } else if(c0 == 'c'){
    8000045e:	06300d93          	li	s11,99
    80000462:	a01d                	j	80000488 <printf+0x90>
        acquire(&pr.lock);
    80000464:	00005517          	auipc	a0,0x5
    80000468:	e4450513          	add	a0,a0,-444 # 800052a8 <pr>
    8000046c:	612000ef          	jal	80000a7e <acquire>
    80000470:	b7d1                	j	80000434 <printf+0x3c>
      consputc(cx);
    80000472:	d6bff0ef          	jal	800001dc <consputc>
      continue;
    80000476:	84ce                	mv	s1,s3
   for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000478:	0014899b          	addw	s3,s1,1
    8000047c:	013a07b3          	add	a5,s4,s3
    80000480:	0007c503          	lbu	a0,0(a5)
    80000484:	1e050063          	beqz	a0,80000664 <printf+0x26c>
    if(cx != '%'){
    80000488:	ff5515e3          	bne	a0,s5,80000472 <printf+0x7a>
    i++;
    8000048c:	0019849b          	addw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80000490:	009a07b3          	add	a5,s4,s1
    80000494:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    80000498:	1c090663          	beqz	s2,80000664 <printf+0x26c>
    8000049c:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    800004a0:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    800004a2:	c789                	beqz	a5,800004ac <printf+0xb4>
    800004a4:	009a0733          	add	a4,s4,s1
    800004a8:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    800004ac:	03690763          	beq	s2,s6,800004da <printf+0xe2>
    } else if(c0 == 'l' && c1 == 'd'){
    800004b0:	05790163          	beq	s2,s7,800004f2 <printf+0xfa>
    } else if(c0 == 'u'){
    800004b4:	0d890463          	beq	s2,s8,8000057c <printf+0x184>
    } else if(c0 == 'x'){
    800004b8:	11990b63          	beq	s2,s9,800005ce <printf+0x1d6>
    } else if(c0 == 'p'){
    800004bc:	15a90463          	beq	s2,s10,80000604 <printf+0x20c>
    } else if(c0 == 'c'){
    800004c0:	15b90c63          	beq	s2,s11,80000618 <printf+0x220>
      consputc(va_arg(ap, uint));
    } else if(c0 == 's'){
    800004c4:	07300793          	li	a5,115
    800004c8:	16f90263          	beq	s2,a5,8000062c <printf+0x234>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    800004cc:	03591b63          	bne	s2,s5,80000502 <printf+0x10a>
      consputc('%');
    800004d0:	02500513          	li	a0,37
    800004d4:	d09ff0ef          	jal	800001dc <consputc>
    800004d8:	b745                	j	80000478 <printf+0x80>
      printint(va_arg(ap, int), 10, 1);
    800004da:	f8843783          	ld	a5,-120(s0)
    800004de:	00878713          	add	a4,a5,8
    800004e2:	f8e43423          	sd	a4,-120(s0)
    800004e6:	4605                	li	a2,1
    800004e8:	45a9                	li	a1,10
    800004ea:	4388                	lw	a0,0(a5)
    800004ec:	e3bff0ef          	jal	80000326 <printint>
    800004f0:	b761                	j	80000478 <printf+0x80>
    } else if(c0 == 'l' && c1 == 'd'){
    800004f2:	01678f63          	beq	a5,s6,80000510 <printf+0x118>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800004f6:	03778b63          	beq	a5,s7,8000052c <printf+0x134>
    } else if(c0 == 'l' && c1 == 'u'){
    800004fa:	09878e63          	beq	a5,s8,80000596 <printf+0x19e>
    } else if(c0 == 'l' && c1 == 'x'){
    800004fe:	0f978563          	beq	a5,s9,800005e8 <printf+0x1f0>
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80000502:	8556                	mv	a0,s5
    80000504:	cd9ff0ef          	jal	800001dc <consputc>
      consputc(c0);
    80000508:	854a                	mv	a0,s2
    8000050a:	cd3ff0ef          	jal	800001dc <consputc>
    8000050e:	b7ad                	j	80000478 <printf+0x80>
      printint(va_arg(ap, uint64), 10, 1);
    80000510:	f8843783          	ld	a5,-120(s0)
    80000514:	00878713          	add	a4,a5,8
    80000518:	f8e43423          	sd	a4,-120(s0)
    8000051c:	4605                	li	a2,1
    8000051e:	45a9                	li	a1,10
    80000520:	6388                	ld	a0,0(a5)
    80000522:	e05ff0ef          	jal	80000326 <printint>
      i += 1;
    80000526:	0029849b          	addw	s1,s3,2
    8000052a:	b7b9                	j	80000478 <printf+0x80>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000052c:	06400793          	li	a5,100
    80000530:	02f68863          	beq	a3,a5,80000560 <printf+0x168>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80000534:	07500793          	li	a5,117
    80000538:	06f68d63          	beq	a3,a5,800005b2 <printf+0x1ba>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000053c:	07800793          	li	a5,120
    80000540:	fcf691e3          	bne	a3,a5,80000502 <printf+0x10a>
      printint(va_arg(ap, uint64), 16, 0);
    80000544:	f8843783          	ld	a5,-120(s0)
    80000548:	00878713          	add	a4,a5,8
    8000054c:	f8e43423          	sd	a4,-120(s0)
    80000550:	4601                	li	a2,0
    80000552:	45c1                	li	a1,16
    80000554:	6388                	ld	a0,0(a5)
    80000556:	dd1ff0ef          	jal	80000326 <printint>
      i += 2;
    8000055a:	0039849b          	addw	s1,s3,3
    8000055e:	bf29                	j	80000478 <printf+0x80>
      printint(va_arg(ap, uint64), 10, 1);
    80000560:	f8843783          	ld	a5,-120(s0)
    80000564:	00878713          	add	a4,a5,8
    80000568:	f8e43423          	sd	a4,-120(s0)
    8000056c:	4605                	li	a2,1
    8000056e:	45a9                	li	a1,10
    80000570:	6388                	ld	a0,0(a5)
    80000572:	db5ff0ef          	jal	80000326 <printint>
      i += 2;
    80000576:	0039849b          	addw	s1,s3,3
    8000057a:	bdfd                	j	80000478 <printf+0x80>
      printint(va_arg(ap, uint32), 10, 0);
    8000057c:	f8843783          	ld	a5,-120(s0)
    80000580:	00878713          	add	a4,a5,8
    80000584:	f8e43423          	sd	a4,-120(s0)
    80000588:	4601                	li	a2,0
    8000058a:	45a9                	li	a1,10
    8000058c:	0007e503          	lwu	a0,0(a5)
    80000590:	d97ff0ef          	jal	80000326 <printint>
    80000594:	b5d5                	j	80000478 <printf+0x80>
      printint(va_arg(ap, uint64), 10, 0);
    80000596:	f8843783          	ld	a5,-120(s0)
    8000059a:	00878713          	add	a4,a5,8
    8000059e:	f8e43423          	sd	a4,-120(s0)
    800005a2:	4601                	li	a2,0
    800005a4:	45a9                	li	a1,10
    800005a6:	6388                	ld	a0,0(a5)
    800005a8:	d7fff0ef          	jal	80000326 <printint>
      i += 1;
    800005ac:	0029849b          	addw	s1,s3,2
    800005b0:	b5e1                	j	80000478 <printf+0x80>
      printint(va_arg(ap, uint64), 10, 0);
    800005b2:	f8843783          	ld	a5,-120(s0)
    800005b6:	00878713          	add	a4,a5,8
    800005ba:	f8e43423          	sd	a4,-120(s0)
    800005be:	4601                	li	a2,0
    800005c0:	45a9                	li	a1,10
    800005c2:	6388                	ld	a0,0(a5)
    800005c4:	d63ff0ef          	jal	80000326 <printint>
      i += 2;
    800005c8:	0039849b          	addw	s1,s3,3
    800005cc:	b575                	j	80000478 <printf+0x80>
      printint(va_arg(ap, uint32), 16, 0);
    800005ce:	f8843783          	ld	a5,-120(s0)
    800005d2:	00878713          	add	a4,a5,8
    800005d6:	f8e43423          	sd	a4,-120(s0)
    800005da:	4601                	li	a2,0
    800005dc:	45c1                	li	a1,16
    800005de:	0007e503          	lwu	a0,0(a5)
    800005e2:	d45ff0ef          	jal	80000326 <printint>
    800005e6:	bd49                	j	80000478 <printf+0x80>
      printint(va_arg(ap, uint64), 16, 0);
    800005e8:	f8843783          	ld	a5,-120(s0)
    800005ec:	00878713          	add	a4,a5,8
    800005f0:	f8e43423          	sd	a4,-120(s0)
    800005f4:	4601                	li	a2,0
    800005f6:	45c1                	li	a1,16
    800005f8:	6388                	ld	a0,0(a5)
    800005fa:	d2dff0ef          	jal	80000326 <printint>
      i += 1;
    800005fe:	0029849b          	addw	s1,s3,2
    80000602:	bd9d                	j	80000478 <printf+0x80>
      printptr(va_arg(ap, uint64));
    80000604:	f8843783          	ld	a5,-120(s0)
    80000608:	00878713          	add	a4,a5,8
    8000060c:	f8e43423          	sd	a4,-120(s0)
    80000610:	6388                	ld	a0,0(a5)
    80000612:	d99ff0ef          	jal	800003aa <printptr>
    80000616:	b58d                	j	80000478 <printf+0x80>
      consputc(va_arg(ap, uint));
    80000618:	f8843783          	ld	a5,-120(s0)
    8000061c:	00878713          	add	a4,a5,8
    80000620:	f8e43423          	sd	a4,-120(s0)
    80000624:	4388                	lw	a0,0(a5)
    80000626:	bb7ff0ef          	jal	800001dc <consputc>
    8000062a:	b5b9                	j	80000478 <printf+0x80>
      if((s = va_arg(ap, char*)) == 0)
    8000062c:	f8843783          	ld	a5,-120(s0)
    80000630:	00878713          	add	a4,a5,8
    80000634:	f8e43423          	sd	a4,-120(s0)
    80000638:	0007b903          	ld	s2,0(a5)
    8000063c:	00090d63          	beqz	s2,80000656 <printf+0x25e>
      for(; *s; s++)
    80000640:	00094503          	lbu	a0,0(s2)
    80000644:	e2050ae3          	beqz	a0,80000478 <printf+0x80>
        consputc(*s);
    80000648:	b95ff0ef          	jal	800001dc <consputc>
      for(; *s; s++)
    8000064c:	0905                	add	s2,s2,1
    8000064e:	00094503          	lbu	a0,0(s2)
    80000652:	f97d                	bnez	a0,80000648 <printf+0x250>
    80000654:	b515                	j	80000478 <printf+0x80>
        s = "(null)";
    80000656:	00002917          	auipc	s2,0x2
    8000065a:	b1a90913          	add	s2,s2,-1254 # 80002170 <userret+0x10d4>
      for(; *s; s++)
    8000065e:	02800513          	li	a0,40
    80000662:	b7dd                	j	80000648 <printf+0x250>

  }

  va_end(ap);

  if(panicking == 0)
    80000664:	00002797          	auipc	a5,0x2
    80000668:	b947a783          	lw	a5,-1132(a5) # 800021f8 <panicking>
    8000066c:	c38d                	beqz	a5,8000068e <printf+0x296>
    release(&pr.lock);
  return 0;
}
    8000066e:	4501                	li	a0,0
    80000670:	70e6                	ld	ra,120(sp)
    80000672:	7446                	ld	s0,112(sp)
    80000674:	74a6                	ld	s1,104(sp)
    80000676:	7906                	ld	s2,96(sp)
    80000678:	69e6                	ld	s3,88(sp)
    8000067a:	6a46                	ld	s4,80(sp)
    8000067c:	6aa6                	ld	s5,72(sp)
    8000067e:	6b06                	ld	s6,64(sp)
    80000680:	7be2                	ld	s7,56(sp)
    80000682:	7c42                	ld	s8,48(sp)
    80000684:	7ca2                	ld	s9,40(sp)
    80000686:	7d02                	ld	s10,32(sp)
    80000688:	6de2                	ld	s11,24(sp)
    8000068a:	6129                	add	sp,sp,192
    8000068c:	8082                	ret
    release(&pr.lock);
    8000068e:	00005517          	auipc	a0,0x5
    80000692:	c1a50513          	add	a0,a0,-998 # 800052a8 <pr>
    80000696:	48e000ef          	jal	80000b24 <release>
  return 0;
    8000069a:	bfd1                	j	8000066e <printf+0x276>

000000008000069c <clear_screen>:

// 实现清屏
void clear_screen(){
    8000069c:	1141                	add	sp,sp,-16
    8000069e:	e406                	sd	ra,8(sp)
    800006a0:	e022                	sd	s0,0(sp)
    800006a2:	0800                	add	s0,sp,16
    printf("\033[2J");
    800006a4:	00002517          	auipc	a0,0x2
    800006a8:	ad450513          	add	a0,a0,-1324 # 80002178 <userret+0x10dc>
    800006ac:	d4dff0ef          	jal	800003f8 <printf>
    printf("\033[H");
    800006b0:	00002517          	auipc	a0,0x2
    800006b4:	ad050513          	add	a0,a0,-1328 # 80002180 <userret+0x10e4>
    800006b8:	d41ff0ef          	jal	800003f8 <printf>
}
    800006bc:	60a2                	ld	ra,8(sp)
    800006be:	6402                	ld	s0,0(sp)
    800006c0:	0141                	add	sp,sp,16
    800006c2:	8082                	ret

00000000800006c4 <goto_xy>:

// 光标移动
void goto_xy(int x, int y){
    if(x < 0 || x > 79 || y < 0 || y > 24)
    800006c4:	04f00793          	li	a5,79
    800006c8:	02a7e863          	bltu	a5,a0,800006f8 <goto_xy+0x34>
    800006cc:	0005879b          	sext.w	a5,a1
    800006d0:	4761                	li	a4,24
    800006d2:	02f76363          	bltu	a4,a5,800006f8 <goto_xy+0x34>
void goto_xy(int x, int y){
    800006d6:	1141                	add	sp,sp,-16
    800006d8:	e406                	sd	ra,8(sp)
    800006da:	e022                	sd	s0,0(sp)
    800006dc:	0800                	add	s0,sp,16
        return;
    printf("\033[%d;%dH", y + 1, x + 1);
    800006de:	0015061b          	addw	a2,a0,1
    800006e2:	2585                	addw	a1,a1,1
    800006e4:	00002517          	auipc	a0,0x2
    800006e8:	aa450513          	add	a0,a0,-1372 # 80002188 <userret+0x10ec>
    800006ec:	d0dff0ef          	jal	800003f8 <printf>
}
    800006f0:	60a2                	ld	ra,8(sp)
    800006f2:	6402                	ld	s0,0(sp)
    800006f4:	0141                	add	sp,sp,16
    800006f6:	8082                	ret
    800006f8:	8082                	ret

00000000800006fa <printf_color>:


// 颜色输出
int 
printf_color(int color, char *fmt, ...){
    800006fa:	7171                	add	sp,sp,-176
    800006fc:	fc86                	sd	ra,120(sp)
    800006fe:	f8a2                	sd	s0,112(sp)
    80000700:	f4a6                	sd	s1,104(sp)
    80000702:	f0ca                	sd	s2,96(sp)
    80000704:	ecce                	sd	s3,88(sp)
    80000706:	e8d2                	sd	s4,80(sp)
    80000708:	e4d6                	sd	s5,72(sp)
    8000070a:	e0da                	sd	s6,64(sp)
    8000070c:	fc5e                	sd	s7,56(sp)
    8000070e:	f862                	sd	s8,48(sp)
    80000710:	f466                	sd	s9,40(sp)
    80000712:	f06a                	sd	s10,32(sp)
    80000714:	ec6e                	sd	s11,24(sp)
    80000716:	0100                	add	s0,sp,128
    80000718:	8a2e                	mv	s4,a1
    8000071a:	e010                	sd	a2,0(s0)
    8000071c:	e414                	sd	a3,8(s0)
    8000071e:	e818                	sd	a4,16(s0)
    80000720:	ec1c                	sd	a5,24(s0)
    80000722:	03043023          	sd	a6,32(s0)
    80000726:	03143423          	sd	a7,40(s0)

printf("\033[%dm", color);
    8000072a:	85aa                	mv	a1,a0
    8000072c:	00002517          	auipc	a0,0x2
    80000730:	a6c50513          	add	a0,a0,-1428 # 80002198 <userret+0x10fc>
    80000734:	cc5ff0ef          	jal	800003f8 <printf>

   va_list ap;
    int i, cx, c0 ,c1, c2;
    char* s;

    if(panicking == 0)
    80000738:	00002797          	auipc	a5,0x2
    8000073c:	ac07a783          	lw	a5,-1344(a5) # 800021f8 <panicking>
    80000740:	c79d                	beqz	a5,8000076e <printf_color+0x74>
        acquire(&pr.lock);
    
    va_start(ap, fmt);
    80000742:	f8843423          	sd	s0,-120(s0)



   for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000746:	000a4503          	lbu	a0,0(s4)
    8000074a:	22050263          	beqz	a0,8000096e <printf_color+0x274>
    8000074e:	4981                	li	s3,0
    if(cx != '%'){
    80000750:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80000754:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80000758:	06c00b93          	li	s7,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000075c:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80000760:	07800c93          	li	s9,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80000764:	07000d13          	li	s10,112
      printptr(va_arg(ap, uint64));
    } else if(c0 == 'c'){
    80000768:	06300d93          	li	s11,99
    8000076c:	a01d                	j	80000792 <printf_color+0x98>
        acquire(&pr.lock);
    8000076e:	00005517          	auipc	a0,0x5
    80000772:	b3a50513          	add	a0,a0,-1222 # 800052a8 <pr>
    80000776:	308000ef          	jal	80000a7e <acquire>
    8000077a:	b7e1                	j	80000742 <printf_color+0x48>
      consputc(cx);
    8000077c:	a61ff0ef          	jal	800001dc <consputc>
      continue;
    80000780:	84ce                	mv	s1,s3
   for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000782:	0014899b          	addw	s3,s1,1
    80000786:	013a07b3          	add	a5,s4,s3
    8000078a:	0007c503          	lbu	a0,0(a5)
    8000078e:	1e050063          	beqz	a0,8000096e <printf_color+0x274>
    if(cx != '%'){
    80000792:	ff5515e3          	bne	a0,s5,8000077c <printf_color+0x82>
    i++;
    80000796:	0019849b          	addw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    8000079a:	009a07b3          	add	a5,s4,s1
    8000079e:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    800007a2:	1c090663          	beqz	s2,8000096e <printf_color+0x274>
    800007a6:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    800007aa:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    800007ac:	c789                	beqz	a5,800007b6 <printf_color+0xbc>
    800007ae:	009a0733          	add	a4,s4,s1
    800007b2:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    800007b6:	03690763          	beq	s2,s6,800007e4 <printf_color+0xea>
    } else if(c0 == 'l' && c1 == 'd'){
    800007ba:	05790163          	beq	s2,s7,800007fc <printf_color+0x102>
    } else if(c0 == 'u'){
    800007be:	0d890463          	beq	s2,s8,80000886 <printf_color+0x18c>
    } else if(c0 == 'x'){
    800007c2:	11990b63          	beq	s2,s9,800008d8 <printf_color+0x1de>
    } else if(c0 == 'p'){
    800007c6:	15a90463          	beq	s2,s10,8000090e <printf_color+0x214>
    } else if(c0 == 'c'){
    800007ca:	15b90c63          	beq	s2,s11,80000922 <printf_color+0x228>
      consputc(va_arg(ap, uint));
    } else if(c0 == 's'){
    800007ce:	07300793          	li	a5,115
    800007d2:	16f90263          	beq	s2,a5,80000936 <printf_color+0x23c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    800007d6:	03591b63          	bne	s2,s5,8000080c <printf_color+0x112>
      consputc('%');
    800007da:	02500513          	li	a0,37
    800007de:	9ffff0ef          	jal	800001dc <consputc>
    800007e2:	b745                	j	80000782 <printf_color+0x88>
      printint(va_arg(ap, int), 10, 1);
    800007e4:	f8843783          	ld	a5,-120(s0)
    800007e8:	00878713          	add	a4,a5,8
    800007ec:	f8e43423          	sd	a4,-120(s0)
    800007f0:	4605                	li	a2,1
    800007f2:	45a9                	li	a1,10
    800007f4:	4388                	lw	a0,0(a5)
    800007f6:	b31ff0ef          	jal	80000326 <printint>
    800007fa:	b761                	j	80000782 <printf_color+0x88>
    } else if(c0 == 'l' && c1 == 'd'){
    800007fc:	01678f63          	beq	a5,s6,8000081a <printf_color+0x120>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80000800:	03778b63          	beq	a5,s7,80000836 <printf_color+0x13c>
    } else if(c0 == 'l' && c1 == 'u'){
    80000804:	09878e63          	beq	a5,s8,800008a0 <printf_color+0x1a6>
    } else if(c0 == 'l' && c1 == 'x'){
    80000808:	0f978563          	beq	a5,s9,800008f2 <printf_color+0x1f8>
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    8000080c:	8556                	mv	a0,s5
    8000080e:	9cfff0ef          	jal	800001dc <consputc>
      consputc(c0);
    80000812:	854a                	mv	a0,s2
    80000814:	9c9ff0ef          	jal	800001dc <consputc>
    80000818:	b7ad                	j	80000782 <printf_color+0x88>
      printint(va_arg(ap, uint64), 10, 1);
    8000081a:	f8843783          	ld	a5,-120(s0)
    8000081e:	00878713          	add	a4,a5,8
    80000822:	f8e43423          	sd	a4,-120(s0)
    80000826:	4605                	li	a2,1
    80000828:	45a9                	li	a1,10
    8000082a:	6388                	ld	a0,0(a5)
    8000082c:	afbff0ef          	jal	80000326 <printint>
      i += 1;
    80000830:	0029849b          	addw	s1,s3,2
    80000834:	b7b9                	j	80000782 <printf_color+0x88>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80000836:	06400793          	li	a5,100
    8000083a:	02f68863          	beq	a3,a5,8000086a <printf_color+0x170>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    8000083e:	07500793          	li	a5,117
    80000842:	06f68d63          	beq	a3,a5,800008bc <printf_color+0x1c2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80000846:	07800793          	li	a5,120
    8000084a:	fcf691e3          	bne	a3,a5,8000080c <printf_color+0x112>
      printint(va_arg(ap, uint64), 16, 0);
    8000084e:	f8843783          	ld	a5,-120(s0)
    80000852:	00878713          	add	a4,a5,8
    80000856:	f8e43423          	sd	a4,-120(s0)
    8000085a:	4601                	li	a2,0
    8000085c:	45c1                	li	a1,16
    8000085e:	6388                	ld	a0,0(a5)
    80000860:	ac7ff0ef          	jal	80000326 <printint>
      i += 2;
    80000864:	0039849b          	addw	s1,s3,3
    80000868:	bf29                	j	80000782 <printf_color+0x88>
      printint(va_arg(ap, uint64), 10, 1);
    8000086a:	f8843783          	ld	a5,-120(s0)
    8000086e:	00878713          	add	a4,a5,8
    80000872:	f8e43423          	sd	a4,-120(s0)
    80000876:	4605                	li	a2,1
    80000878:	45a9                	li	a1,10
    8000087a:	6388                	ld	a0,0(a5)
    8000087c:	aabff0ef          	jal	80000326 <printint>
      i += 2;
    80000880:	0039849b          	addw	s1,s3,3
    80000884:	bdfd                	j	80000782 <printf_color+0x88>
      printint(va_arg(ap, uint32), 10, 0);
    80000886:	f8843783          	ld	a5,-120(s0)
    8000088a:	00878713          	add	a4,a5,8
    8000088e:	f8e43423          	sd	a4,-120(s0)
    80000892:	4601                	li	a2,0
    80000894:	45a9                	li	a1,10
    80000896:	0007e503          	lwu	a0,0(a5)
    8000089a:	a8dff0ef          	jal	80000326 <printint>
    8000089e:	b5d5                	j	80000782 <printf_color+0x88>
      printint(va_arg(ap, uint64), 10, 0);
    800008a0:	f8843783          	ld	a5,-120(s0)
    800008a4:	00878713          	add	a4,a5,8
    800008a8:	f8e43423          	sd	a4,-120(s0)
    800008ac:	4601                	li	a2,0
    800008ae:	45a9                	li	a1,10
    800008b0:	6388                	ld	a0,0(a5)
    800008b2:	a75ff0ef          	jal	80000326 <printint>
      i += 1;
    800008b6:	0029849b          	addw	s1,s3,2
    800008ba:	b5e1                	j	80000782 <printf_color+0x88>
      printint(va_arg(ap, uint64), 10, 0);
    800008bc:	f8843783          	ld	a5,-120(s0)
    800008c0:	00878713          	add	a4,a5,8
    800008c4:	f8e43423          	sd	a4,-120(s0)
    800008c8:	4601                	li	a2,0
    800008ca:	45a9                	li	a1,10
    800008cc:	6388                	ld	a0,0(a5)
    800008ce:	a59ff0ef          	jal	80000326 <printint>
      i += 2;
    800008d2:	0039849b          	addw	s1,s3,3
    800008d6:	b575                	j	80000782 <printf_color+0x88>
      printint(va_arg(ap, uint32), 16, 0);
    800008d8:	f8843783          	ld	a5,-120(s0)
    800008dc:	00878713          	add	a4,a5,8
    800008e0:	f8e43423          	sd	a4,-120(s0)
    800008e4:	4601                	li	a2,0
    800008e6:	45c1                	li	a1,16
    800008e8:	0007e503          	lwu	a0,0(a5)
    800008ec:	a3bff0ef          	jal	80000326 <printint>
    800008f0:	bd49                	j	80000782 <printf_color+0x88>
      printint(va_arg(ap, uint64), 16, 0);
    800008f2:	f8843783          	ld	a5,-120(s0)
    800008f6:	00878713          	add	a4,a5,8
    800008fa:	f8e43423          	sd	a4,-120(s0)
    800008fe:	4601                	li	a2,0
    80000900:	45c1                	li	a1,16
    80000902:	6388                	ld	a0,0(a5)
    80000904:	a23ff0ef          	jal	80000326 <printint>
      i += 1;
    80000908:	0029849b          	addw	s1,s3,2
    8000090c:	bd9d                	j	80000782 <printf_color+0x88>
      printptr(va_arg(ap, uint64));
    8000090e:	f8843783          	ld	a5,-120(s0)
    80000912:	00878713          	add	a4,a5,8
    80000916:	f8e43423          	sd	a4,-120(s0)
    8000091a:	6388                	ld	a0,0(a5)
    8000091c:	a8fff0ef          	jal	800003aa <printptr>
    80000920:	b58d                	j	80000782 <printf_color+0x88>
      consputc(va_arg(ap, uint));
    80000922:	f8843783          	ld	a5,-120(s0)
    80000926:	00878713          	add	a4,a5,8
    8000092a:	f8e43423          	sd	a4,-120(s0)
    8000092e:	4388                	lw	a0,0(a5)
    80000930:	8adff0ef          	jal	800001dc <consputc>
    80000934:	b5b9                	j	80000782 <printf_color+0x88>
      if((s = va_arg(ap, char*)) == 0)
    80000936:	f8843783          	ld	a5,-120(s0)
    8000093a:	00878713          	add	a4,a5,8
    8000093e:	f8e43423          	sd	a4,-120(s0)
    80000942:	0007b903          	ld	s2,0(a5)
    80000946:	00090d63          	beqz	s2,80000960 <printf_color+0x266>
      for(; *s; s++)
    8000094a:	00094503          	lbu	a0,0(s2)
    8000094e:	e2050ae3          	beqz	a0,80000782 <printf_color+0x88>
        consputc(*s);
    80000952:	88bff0ef          	jal	800001dc <consputc>
      for(; *s; s++)
    80000956:	0905                	add	s2,s2,1
    80000958:	00094503          	lbu	a0,0(s2)
    8000095c:	f97d                	bnez	a0,80000952 <printf_color+0x258>
    8000095e:	b515                	j	80000782 <printf_color+0x88>
        s = "(null)";
    80000960:	00002917          	auipc	s2,0x2
    80000964:	81090913          	add	s2,s2,-2032 # 80002170 <userret+0x10d4>
      for(; *s; s++)
    80000968:	02800513          	li	a0,40
    8000096c:	b7dd                	j	80000952 <printf_color+0x258>

  }

  va_end(ap);

  if(panicking == 0)
    8000096e:	00002797          	auipc	a5,0x2
    80000972:	88a7a783          	lw	a5,-1910(a5) # 800021f8 <panicking>
    80000976:	cb85                	beqz	a5,800009a6 <printf_color+0x2ac>
    release(&pr.lock);

   printf("\033[%dm",0);
    80000978:	4581                	li	a1,0
    8000097a:	00002517          	auipc	a0,0x2
    8000097e:	81e50513          	add	a0,a0,-2018 # 80002198 <userret+0x10fc>
    80000982:	a77ff0ef          	jal	800003f8 <printf>

    return 0;
}
    80000986:	4501                	li	a0,0
    80000988:	70e6                	ld	ra,120(sp)
    8000098a:	7446                	ld	s0,112(sp)
    8000098c:	74a6                	ld	s1,104(sp)
    8000098e:	7906                	ld	s2,96(sp)
    80000990:	69e6                	ld	s3,88(sp)
    80000992:	6a46                	ld	s4,80(sp)
    80000994:	6aa6                	ld	s5,72(sp)
    80000996:	6b06                	ld	s6,64(sp)
    80000998:	7be2                	ld	s7,56(sp)
    8000099a:	7c42                	ld	s8,48(sp)
    8000099c:	7ca2                	ld	s9,40(sp)
    8000099e:	7d02                	ld	s10,32(sp)
    800009a0:	6de2                	ld	s11,24(sp)
    800009a2:	614d                	add	sp,sp,176
    800009a4:	8082                	ret
    release(&pr.lock);
    800009a6:	00005517          	auipc	a0,0x5
    800009aa:	90250513          	add	a0,a0,-1790 # 800052a8 <pr>
    800009ae:	176000ef          	jal	80000b24 <release>
    800009b2:	b7d9                	j	80000978 <printf_color+0x27e>

00000000800009b4 <panic>:



void 
panic(char *c){
    800009b4:	1101                	add	sp,sp,-32
    800009b6:	ec06                	sd	ra,24(sp)
    800009b8:	e822                	sd	s0,16(sp)
    800009ba:	e426                	sd	s1,8(sp)
    800009bc:	1000                	add	s0,sp,32
    panicking = 1;
    800009be:	4485                	li	s1,1
    800009c0:	00002797          	auipc	a5,0x2
    800009c4:	8297ac23          	sw	s1,-1992(a5) # 800021f8 <panicking>
    consputc(digits[0]);
    800009c8:	03000513          	li	a0,48
    800009cc:	811ff0ef          	jal	800001dc <consputc>
    panicked = 1;
    800009d0:	00002797          	auipc	a5,0x2
    800009d4:	8297a223          	sw	s1,-2012(a5) # 800021f4 <panicked>
    for(;;)
    800009d8:	a001                	j	800009d8 <panic+0x24>

00000000800009da <printfinit>:
    ;
}

void printfinit(void){
    800009da:	1141                	add	sp,sp,-16
    800009dc:	e406                	sd	ra,8(sp)
    800009de:	e022                	sd	s0,0(sp)
    800009e0:	0800                	add	s0,sp,16
    initlock(&pr.lock, "pr");
    800009e2:	00001597          	auipc	a1,0x1
    800009e6:	7be58593          	add	a1,a1,1982 # 800021a0 <userret+0x1104>
    800009ea:	00005517          	auipc	a0,0x5
    800009ee:	8be50513          	add	a0,a0,-1858 # 800052a8 <pr>
    800009f2:	036000ef          	jal	80000a28 <initlock>
}
    800009f6:	60a2                	ld	ra,8(sp)
    800009f8:	6402                	ld	s0,0(sp)
    800009fa:	0141                	add	sp,sp,16
    800009fc:	8082                	ret

00000000800009fe <holding>:


// 检查是否持有这个锁
// 要需要提前关闭中断
int holding(struct spinlock* lk){
    return (lk->locked && lk->cpu == mycpu());
    800009fe:	411c                	lw	a5,0(a0)
    80000a00:	e399                	bnez	a5,80000a06 <holding+0x8>
    80000a02:	4501                	li	a0,0
}
    80000a04:	8082                	ret
int holding(struct spinlock* lk){
    80000a06:	1101                	add	sp,sp,-32
    80000a08:	ec06                	sd	ra,24(sp)
    80000a0a:	e822                	sd	s0,16(sp)
    80000a0c:	e426                	sd	s1,8(sp)
    80000a0e:	1000                	add	s0,sp,32
    return (lk->locked && lk->cpu == mycpu());
    80000a10:	6904                	ld	s1,16(a0)
    80000a12:	160000ef          	jal	80000b72 <mycpu>
    80000a16:	40a48533          	sub	a0,s1,a0
    80000a1a:	00153513          	seqz	a0,a0
}
    80000a1e:	60e2                	ld	ra,24(sp)
    80000a20:	6442                	ld	s0,16(sp)
    80000a22:	64a2                	ld	s1,8(sp)
    80000a24:	6105                	add	sp,sp,32
    80000a26:	8082                	ret

0000000080000a28 <initlock>:

// 锁初始化
void 
initlock(struct spinlock* lk, char* name){
    80000a28:	1141                	add	sp,sp,-16
    80000a2a:	e422                	sd	s0,8(sp)
    80000a2c:	0800                	add	s0,sp,16
    lk->name = name;
    80000a2e:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
    80000a30:	00052023          	sw	zero,0(a0)
    lk->cpu = 0;
    80000a34:	00053823          	sd	zero,16(a0)
}
    80000a38:	6422                	ld	s0,8(sp)
    80000a3a:	0141                	add	sp,sp,16
    80000a3c:	8082                	ret

0000000080000a3e <push_off>:
    pop_off();
}

void
push_off(void)
{
    80000a3e:	1101                	add	sp,sp,-32
    80000a40:	ec06                	sd	ra,24(sp)
    80000a42:	e822                	sd	s0,16(sp)
    80000a44:	e426                	sd	s1,8(sp)
    80000a46:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000a48:	100024f3          	csrr	s1,sstatus
    80000a4c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000a50:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000a52:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    80000a56:	11c000ef          	jal	80000b72 <mycpu>
    80000a5a:	593c                	lw	a5,112(a0)
    80000a5c:	cb99                	beqz	a5,80000a72 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000a5e:	114000ef          	jal	80000b72 <mycpu>
    80000a62:	593c                	lw	a5,112(a0)
    80000a64:	2785                	addw	a5,a5,1
    80000a66:	d93c                	sw	a5,112(a0)
}
    80000a68:	60e2                	ld	ra,24(sp)
    80000a6a:	6442                	ld	s0,16(sp)
    80000a6c:	64a2                	ld	s1,8(sp)
    80000a6e:	6105                	add	sp,sp,32
    80000a70:	8082                	ret
    mycpu()->intena = old;
    80000a72:	100000ef          	jal	80000b72 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000a76:	8085                	srl	s1,s1,0x1
    80000a78:	8885                	and	s1,s1,1
    80000a7a:	d964                	sw	s1,116(a0)
    80000a7c:	b7cd                	j	80000a5e <push_off+0x20>

0000000080000a7e <acquire>:
acquire(struct spinlock* lk){
    80000a7e:	1101                	add	sp,sp,-32
    80000a80:	ec06                	sd	ra,24(sp)
    80000a82:	e822                	sd	s0,16(sp)
    80000a84:	e426                	sd	s1,8(sp)
    80000a86:	1000                	add	s0,sp,32
    80000a88:	84aa                	mv	s1,a0
    push_off(); // 关闭中断 避免死锁
    80000a8a:	fb5ff0ef          	jal	80000a3e <push_off>
    if(holding(lk))
    80000a8e:	8526                	mv	a0,s1
    80000a90:	f6fff0ef          	jal	800009fe <holding>
    80000a94:	e10d                	bnez	a0,80000ab6 <acquire+0x38>
    while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000a96:	4705                	li	a4,1
    80000a98:	87ba                	mv	a5,a4
    80000a9a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000a9e:	2781                	sext.w	a5,a5
    80000aa0:	ffe5                	bnez	a5,80000a98 <acquire+0x1a>
    __sync_synchronize();
    80000aa2:	0ff0000f          	fence
    lk->cpu = mycpu();
    80000aa6:	0cc000ef          	jal	80000b72 <mycpu>
    80000aaa:	e888                	sd	a0,16(s1)
}
    80000aac:	60e2                	ld	ra,24(sp)
    80000aae:	6442                	ld	s0,16(sp)
    80000ab0:	64a2                	ld	s1,8(sp)
    80000ab2:	6105                	add	sp,sp,32
    80000ab4:	8082                	ret
        panic("acquire");
    80000ab6:	00001517          	auipc	a0,0x1
    80000aba:	70a50513          	add	a0,a0,1802 # 800021c0 <digits+0x18>
    80000abe:	ef7ff0ef          	jal	800009b4 <panic>
    80000ac2:	bfd1                	j	80000a96 <acquire+0x18>

0000000080000ac4 <pop_off>:

void
pop_off(void)
{
    80000ac4:	1101                	add	sp,sp,-32
    80000ac6:	ec06                	sd	ra,24(sp)
    80000ac8:	e822                	sd	s0,16(sp)
    80000aca:	e426                	sd	s1,8(sp)
    80000acc:	1000                	add	s0,sp,32
  struct cpu *c = mycpu();
    80000ace:	0a4000ef          	jal	80000b72 <mycpu>
    80000ad2:	84aa                	mv	s1,a0
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000ad4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000ad8:	8b89                	and	a5,a5,2
  if(intr_get())
    80000ada:	e79d                	bnez	a5,80000b08 <pop_off+0x44>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000adc:	58bc                	lw	a5,112(s1)
    80000ade:	02f05c63          	blez	a5,80000b16 <pop_off+0x52>
    panic("pop_off");
  c->noff -= 1;
    80000ae2:	58bc                	lw	a5,112(s1)
    80000ae4:	37fd                	addw	a5,a5,-1
    80000ae6:	0007871b          	sext.w	a4,a5
    80000aea:	d8bc                	sw	a5,112(s1)
  if(c->noff == 0 && c->intena)
    80000aec:	eb09                	bnez	a4,80000afe <pop_off+0x3a>
    80000aee:	58fc                	lw	a5,116(s1)
    80000af0:	c799                	beqz	a5,80000afe <pop_off+0x3a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000af2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000af6:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000afa:	10079073          	csrw	sstatus,a5
    intr_on();
    80000afe:	60e2                	ld	ra,24(sp)
    80000b00:	6442                	ld	s0,16(sp)
    80000b02:	64a2                	ld	s1,8(sp)
    80000b04:	6105                	add	sp,sp,32
    80000b06:	8082                	ret
    panic("pop_off - interruptible");
    80000b08:	00001517          	auipc	a0,0x1
    80000b0c:	6c050513          	add	a0,a0,1728 # 800021c8 <digits+0x20>
    80000b10:	ea5ff0ef          	jal	800009b4 <panic>
    80000b14:	b7e1                	j	80000adc <pop_off+0x18>
    panic("pop_off");
    80000b16:	00001517          	auipc	a0,0x1
    80000b1a:	6ca50513          	add	a0,a0,1738 # 800021e0 <digits+0x38>
    80000b1e:	e97ff0ef          	jal	800009b4 <panic>
    80000b22:	b7c1                	j	80000ae2 <pop_off+0x1e>

0000000080000b24 <release>:
void release(struct spinlock* lk){
    80000b24:	1101                	add	sp,sp,-32
    80000b26:	ec06                	sd	ra,24(sp)
    80000b28:	e822                	sd	s0,16(sp)
    80000b2a:	e426                	sd	s1,8(sp)
    80000b2c:	1000                	add	s0,sp,32
    80000b2e:	84aa                	mv	s1,a0
    if(!holding(lk))
    80000b30:	ecfff0ef          	jal	800009fe <holding>
    80000b34:	c105                	beqz	a0,80000b54 <release+0x30>
    lk->cpu = 0;
    80000b36:	0004b823          	sd	zero,16(s1)
    __sync_synchronize();
    80000b3a:	0ff0000f          	fence
    __sync_lock_release(&lk->locked);
    80000b3e:	0f50000f          	fence	iorw,ow
    80000b42:	0804a02f          	amoswap.w	zero,zero,(s1)
    pop_off();
    80000b46:	f7fff0ef          	jal	80000ac4 <pop_off>
}
    80000b4a:	60e2                	ld	ra,24(sp)
    80000b4c:	6442                	ld	s0,16(sp)
    80000b4e:	64a2                	ld	s1,8(sp)
    80000b50:	6105                	add	sp,sp,32
    80000b52:	8082                	ret
        panic("release");
    80000b54:	00001517          	auipc	a0,0x1
    80000b58:	69450513          	add	a0,a0,1684 # 800021e8 <digits+0x40>
    80000b5c:	e59ff0ef          	jal	800009b4 <panic>
    80000b60:	bfd9                	j	80000b36 <release+0x12>

0000000080000b62 <cpuid>:
#include "include/proc.h"
#include "include/param.h"

struct cpu cpus[NCPU];

int cpuid() {
    80000b62:	1141                	add	sp,sp,-16
    80000b64:	e422                	sd	s0,8(sp)
    80000b66:	0800                	add	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000b68:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000b6a:	2501                	sext.w	a0,a0
    80000b6c:	6422                	ld	s0,8(sp)
    80000b6e:	0141                	add	sp,sp,16
    80000b70:	8082                	ret

0000000080000b72 <mycpu>:

struct cpu* 
mycpu(void){
    80000b72:	1141                	add	sp,sp,-16
    80000b74:	e422                	sd	s0,8(sp)
    80000b76:	0800                	add	s0,sp,16
    80000b78:	8712                	mv	a4,tp
    struct cpu *c = &cpus[cpuid()];
    80000b7a:	2701                	sext.w	a4,a4
    80000b7c:	00471793          	sll	a5,a4,0x4
    80000b80:	8f99                	sub	a5,a5,a4
    80000b82:	078e                	sll	a5,a5,0x3
    return c;
}
    80000b84:	00004517          	auipc	a0,0x4
    80000b88:	73c50513          	add	a0,a0,1852 # 800052c0 <cpus>
    80000b8c:	953e                	add	a0,a0,a5
    80000b8e:	6422                	ld	s0,8(sp)
    80000b90:	0141                	add	sp,sp,16
    80000b92:	8082                	ret
	...

0000000080001000 <_trampoline>:
    80001000:	14051073          	csrw	sscratch,a0
    80001004:	02000537          	lui	a0,0x2000
    80001008:	357d                	addw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000100a:	0536                	sll	a0,a0,0xd
    8000100c:	02153423          	sd	ra,40(a0)
    80001010:	02253823          	sd	sp,48(a0)
    80001014:	02353c23          	sd	gp,56(a0)
    80001018:	04453023          	sd	tp,64(a0)
    8000101c:	04553423          	sd	t0,72(a0)
    80001020:	04653823          	sd	t1,80(a0)
    80001024:	04753c23          	sd	t2,88(a0)
    80001028:	f120                	sd	s0,96(a0)
    8000102a:	f524                	sd	s1,104(a0)
    8000102c:	fd2c                	sd	a1,120(a0)
    8000102e:	e150                	sd	a2,128(a0)
    80001030:	e554                	sd	a3,136(a0)
    80001032:	e958                	sd	a4,144(a0)
    80001034:	ed5c                	sd	a5,152(a0)
    80001036:	0b053023          	sd	a6,160(a0)
    8000103a:	0b153423          	sd	a7,168(a0)
    8000103e:	0b253823          	sd	s2,176(a0)
    80001042:	0b353c23          	sd	s3,184(a0)
    80001046:	0d453023          	sd	s4,192(a0)
    8000104a:	0d553423          	sd	s5,200(a0)
    8000104e:	0d653823          	sd	s6,208(a0)
    80001052:	0d753c23          	sd	s7,216(a0)
    80001056:	0f853023          	sd	s8,224(a0)
    8000105a:	0f953423          	sd	s9,232(a0)
    8000105e:	0fa53823          	sd	s10,240(a0)
    80001062:	0fb53c23          	sd	s11,248(a0)
    80001066:	11c53023          	sd	t3,256(a0)
    8000106a:	11d53423          	sd	t4,264(a0)
    8000106e:	11e53823          	sd	t5,272(a0)
    80001072:	11f53c23          	sd	t6,280(a0)
    80001076:	140022f3          	csrr	t0,sscratch
    8000107a:	06553823          	sd	t0,112(a0)
    8000107e:	00853103          	ld	sp,8(a0)
    80001082:	02053203          	ld	tp,32(a0)
    80001086:	01053283          	ld	t0,16(a0)
    8000108a:	00053303          	ld	t1,0(a0)
    8000108e:	12000073          	sfence.vma
    80001092:	18031073          	csrw	satp,t1
    80001096:	12000073          	sfence.vma
    8000109a:	9282                	jalr	t0

000000008000109c <userret>:
    8000109c:	12000073          	sfence.vma
    800010a0:	18051073          	csrw	satp,a0
    800010a4:	12000073          	sfence.vma
    800010a8:	02000537          	lui	a0,0x2000
    800010ac:	357d                	addw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800010ae:	0536                	sll	a0,a0,0xd
    800010b0:	02853083          	ld	ra,40(a0)
    800010b4:	03053103          	ld	sp,48(a0)
    800010b8:	03853183          	ld	gp,56(a0)
    800010bc:	04053203          	ld	tp,64(a0)
    800010c0:	04853283          	ld	t0,72(a0)
    800010c4:	05053303          	ld	t1,80(a0)
    800010c8:	05853383          	ld	t2,88(a0)
    800010cc:	7120                	ld	s0,96(a0)
    800010ce:	7524                	ld	s1,104(a0)
    800010d0:	7d2c                	ld	a1,120(a0)
    800010d2:	6150                	ld	a2,128(a0)
    800010d4:	6554                	ld	a3,136(a0)
    800010d6:	6958                	ld	a4,144(a0)
    800010d8:	6d5c                	ld	a5,152(a0)
    800010da:	0a053803          	ld	a6,160(a0)
    800010de:	0a853883          	ld	a7,168(a0)
    800010e2:	0b053903          	ld	s2,176(a0)
    800010e6:	0b853983          	ld	s3,184(a0)
    800010ea:	0c053a03          	ld	s4,192(a0)
    800010ee:	0c853a83          	ld	s5,200(a0)
    800010f2:	0d053b03          	ld	s6,208(a0)
    800010f6:	0d853b83          	ld	s7,216(a0)
    800010fa:	0e053c03          	ld	s8,224(a0)
    800010fe:	0e853c83          	ld	s9,232(a0)
    80001102:	0f053d03          	ld	s10,240(a0)
    80001106:	0f853d83          	ld	s11,248(a0)
    8000110a:	10053e03          	ld	t3,256(a0)
    8000110e:	10853e83          	ld	t4,264(a0)
    80001112:	11053f03          	ld	t5,272(a0)
    80001116:	11853f83          	ld	t6,280(a0)
    8000111a:	7928                	ld	a0,112(a0)
    8000111c:	10200073          	sret
	...
