
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
.section .text
.global _entry, test
_entry:
        la sp, stack0
    80000000:	00002117          	auipc	sp,0x2
    80000004:	02010113          	add	sp,sp,32 # 80002020 <stack0>
        li a0, 1024*8
    80000008:	6509                	lui	a0,0x2
        # 对于一个单核系统 这里不需要考虑hartid的数量
        add sp, sp, a0
    8000000a:	912a                	add	sp,sp,a0
        call start
    8000000c:	02e000ef          	jal	8000003a <start>

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

0000000080000020 <main>:

void test();

void
main()
{
    80000020:	1141                	add	sp,sp,-16
    80000022:	e406                	sd	ra,8(sp)
    80000024:	e022                	sd	s0,0(sp)
    80000026:	0800                	add	s0,sp,16
  uartinit();
    80000028:	07a000ef          	jal	800000a2 <uartinit>
  uart_puts("Hello World");
    8000002c:	00002517          	auipc	a0,0x2
    80000030:	fd450513          	add	a0,a0,-44 # 80002000 <userret+0xf64>
    80000034:	0c0000ef          	jal	800000f4 <uart_puts>
    // 啥都别干
  while(1)
    80000038:	a001                	j	80000038 <main+0x18>

000000008000003a <start>:
__attribute__ ((aligned (16))) char stack0[4096 * 3];

// entry.S jumps here in machine mode on stack0.
void
start()
{
    8000003a:	1141                	add	sp,sp,-16
    8000003c:	e422                	sd	s0,8(sp)
    8000003e:	0800                	add	s0,sp,16

static inline uint64
r_mstatus()
{
  uint64 x;
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000040:	300027f3          	csrr	a5,mstatus
  // set M Previous Privilege mode to Supervisor, for mret.
  unsigned long x = r_mstatus();
  x &= ~MSTATUS_MPP_MASK;
    80000044:	7779                	lui	a4,0xffffe
    80000046:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <stack0+0xffffffff7fffc7df>
    8000004a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000004c:	6705                	lui	a4,0x1
    8000004e:	80070713          	add	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80000052:	8fd9                	or	a5,a5,a4
}

static inline void 
w_mstatus(uint64 x)
{
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000054:	30079073          	csrw	mstatus,a5
// instruction address to which a return from
// exception will go.
static inline void 
w_mepc(uint64 x)
{
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000058:	00000797          	auipc	a5,0x0
    8000005c:	fc878793          	add	a5,a5,-56 # 80000020 <main>
    80000060:	34179073          	csrw	mepc,a5
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000064:	4781                	li	a5,0
    80000066:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000006a:	67c1                	lui	a5,0x10
    8000006c:	17fd                	add	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000006e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80000072:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80000076:	104027f3          	csrr	a5,sie

  // delegate all interrupts and exceptions to supervisor mode.

  w_medeleg(0xffff);
  w_mideleg(0xffff);
  w_sie(r_sie() | SIE_SEIE);
    8000007a:	2007e793          	or	a5,a5,512
  asm volatile("csrw sie, %0" : : "r" (x));
    8000007e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80000082:	57fd                	li	a5,-1
    80000084:	83a9                	srl	a5,a5,0xa
    80000086:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000008a:	47bd                	li	a5,15
    8000008c:	3a079073          	csrw	pmpcfg0,a5
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000090:	f14027f3          	csrr	a5,mhartid
  // ask for clock interrupts.
  // timerinit();

  // keep each CPU's hartid in its tp register, for cpuid().
  int id = r_mhartid();
  w_tp(id);
    80000094:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    80000096:	823e                	mv	tp,a5

  // switch to supervisor mode and jump to main().
  asm volatile("mret");
    80000098:	30200073          	mret
}
    8000009c:	6422                	ld	s0,8(sp)
    8000009e:	0141                	add	sp,sp,16
    800000a0:	8082                	ret

00000000800000a2 <uartinit>:
#define LSR 5                 
#define LSR_RX_READY (1<<0)   
#define LSR_TX_IDLE (1<<5)    


void uartinit(void){
    800000a2:	1141                	add	sp,sp,-16
    800000a4:	e422                	sd	s0,8(sp)
    800000a6:	0800                	add	s0,sp,16
    // 关闭读取中断
    WriteReg(IER, 0x00);
    800000a8:	100007b7          	lui	a5,0x10000
    800000ac:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

    // 设置波特率和信息位
    // 这里是一个常用波特率 38400
    // 计算方法是 115200 / 3 = 38400
    // 按照习惯 一次传递一个字节
    WriteReg(LCR, LCR_BAUD_LATCH);
    800000b0:	f8000713          	li	a4,-128
    800000b4:	00e781a3          	sb	a4,3(a5)
    WriteReg(0, 0x03); // LSB
    800000b8:	470d                	li	a4,3
    800000ba:	00e78023          	sb	a4,0(a5)
    WriteReg(1, 0x00); // MSB
    800000be:	000780a3          	sb	zero,1(a5)
    WriteReg(LCR, LCR_EIGHT_BITS);
    800000c2:	00e781a3          	sb	a4,3(a5)

    // 启动缓冲区
    WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800000c6:	471d                	li	a4,7
    800000c8:	00e78123          	sb	a4,2(a5)

    // 开启读写中断 这里先注释掉 需要等后面配置完中断再开启
    // WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);

}
    800000cc:	6422                	ld	s0,8(sp)
    800000ce:	0141                	add	sp,sp,16
    800000d0:	8082                	ret

00000000800000d2 <uart_putc>:


void uart_putc(char c){
    800000d2:	1141                	add	sp,sp,-16
    800000d4:	e422                	sd	s0,8(sp)
    800000d6:	0800                	add	s0,sp,16
    // 等待串口发送完成
    while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800000d8:	10000737          	lui	a4,0x10000
    800000dc:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800000e0:	0207f793          	and	a5,a5,32
    800000e4:	dfe5                	beqz	a5,800000dc <uart_putc+0xa>
    ;
    WriteReg(THR, c);
    800000e6:	100007b7          	lui	a5,0x10000
    800000ea:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>
}
    800000ee:	6422                	ld	s0,8(sp)
    800000f0:	0141                	add	sp,sp,16
    800000f2:	8082                	ret

00000000800000f4 <uart_puts>:

void uart_puts(char *s){
    char* tmp = s;
    while(*s){
    800000f4:	00054783          	lbu	a5,0(a0)
    800000f8:	cf95                	beqz	a5,80000134 <uart_puts+0x40>
void uart_puts(char *s){
    800000fa:	1101                	add	sp,sp,-32
    800000fc:	ec06                	sd	ra,24(sp)
    800000fe:	e822                	sd	s0,16(sp)
    80000100:	e426                	sd	s1,8(sp)
    80000102:	e04a                	sd	s2,0(sp)
    80000104:	1000                	add	s0,sp,32
    80000106:	84aa                	mv	s1,a0
        if(*s == '\n')
    80000108:	4929                	li	s2,10
    8000010a:	a809                	j	8000011c <uart_puts+0x28>
            uart_putc('\r');
        uart_putc(*s++);
    8000010c:	0485                	add	s1,s1,1
    8000010e:	fff4c503          	lbu	a0,-1(s1)
    80000112:	fc1ff0ef          	jal	800000d2 <uart_putc>
    while(*s){
    80000116:	0004c783          	lbu	a5,0(s1)
    8000011a:	c799                	beqz	a5,80000128 <uart_puts+0x34>
        if(*s == '\n')
    8000011c:	ff2798e3          	bne	a5,s2,8000010c <uart_puts+0x18>
            uart_putc('\r');
    80000120:	4535                	li	a0,13
    80000122:	fb1ff0ef          	jal	800000d2 <uart_putc>
    80000126:	b7dd                	j	8000010c <uart_puts+0x18>
    }
    s = tmp;
}
    80000128:	60e2                	ld	ra,24(sp)
    8000012a:	6442                	ld	s0,16(sp)
    8000012c:	64a2                	ld	s1,8(sp)
    8000012e:	6902                	ld	s2,0(sp)
    80000130:	6105                	add	sp,sp,32
    80000132:	8082                	ret
    80000134:	8082                	ret
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
