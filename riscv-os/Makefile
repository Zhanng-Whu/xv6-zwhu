K=kernel
U=user
S=scripts
I=include

B=boot
F=fs
M=m
P=proc
T=trap
N=net

# --- 1. 自动发现内核源文件并生成目标文件列表 ---
KSRCS_C := $(wildcard $(K)/**/*.c)   # 查找kernel/下所有子目录中的.c文件
KSRCS_S := $(wildcard $(K)/**/*.S)   # 查找kernel/下所有子目录中的.S文件

# 将找到的.c和.S文件名列表，转换成对应的.o文件名列表
KOBJS_C := $(KSRCS_C:.c=.o)
KOBJS_S := $(KSRCS_S:.S=.o)
OBJS    := $(KOBJS_C) $(KOBJS_S)


QEMU = qemu-system-riscv64
TOOLPREFIX = riscv64-unknown-elf-
MIN_QEMU_VERSION = 7.2

# 一些工具的设置
CC = $(TOOLPREFIX)gcc
AS = $(TOOLPREFIX)gas
LD = $(TOOLPREFIX)ld
OBJCOPY = $(TOOLPREFIX)objcopy
OBJDUMP = $(TOOLPREFIX)objdump

# CFLAGS 就是 gcc flags 编译器设置
CFLAGS = -Wall -Werror -Wno-unknown-attributes -O -fno-omit-frame-pointer -ggdb -gdwarf-2
CFLAGS += -MD
CFLAGS += -mcmodel=medany
CFLAGS += -ffreestanding
CFLAGS += -fno-common -nostdlib
CFLAGS += -fno-builtin-strncpy -fno-builtin-strncmp -fno-builtin-strlen -fno-builtin-memset
CFLAGS += -fno-builtin-memmove -fno-builtin-memcmp -fno-builtin-log -fno-builtin-bzero
CFLAGS += -fno-builtin-strchr -fno-builtin-exit -fno-builtin-malloc -fno-builtin-putc
CFLAGS += -fno-builtin-free
CFLAGS += -fno-builtin-memcpy -Wno-main
CFLAGS += -fno-builtin-printf -fno-builtin-fprintf -fno-builtin-vprintf
CFLAGS += -I.
CFLAGS += $(shell $(CC) -fno-stack-protector -E -x c /dev/null >/dev/null 2>&1 && echo -fno-stack-protector)

# Disable PIE when possible (for Ubuntu 16.10 toolchain)
ifneq ($(shell $(CC) -dumpspecs 2>/dev/null | grep -e '[^f]no-pie'),)
CFLAGS += -fno-pie -no-pie
endif
ifneq ($(shell $(CC) -dumpspecs 2>/dev/null | grep -e '[^f]nopie'),)
CFLAGS += -fno-pie -nopie
endif

CFLAGS += -I$(I)

LDFLAGS = -z max-page-size=4096


$(K)/kernel: $(OBJS) $(S)/kernel.ld
	$(LD) $(LDFLAGS) -T $(S)/kernel.ld -o $(K)/kernel $(OBJS)
	$(OBJDUMP) -S $(K)/kernel > $(K)/kernel.asm
	$(OBJDUMP) -t $(K)/kernel | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $(K)/kernel.sym
# --- 4. 更新编译规则，使其更通用 ---
%.o: %.S
	$(CC) $(CFLAGS) -c -o $@ $<

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<


# --- 5. 更新 etags 规则 ---
tags: $(KSRCS_C) $(KSRCS_S) $(I)/*.h
	etags $(KSRCS_C) $(KSRCS_S) $(I)/*.h


ULIB = $U/ulib.o $U/usys.o $U/printf.o

_%: %.o $(ULIB) $U/user.ld
	$(LD) $(LDFLAGS) -T $U/user.ld -o $@ $< $(ULIB)
	$(OBJDUMP) -S $@ > $*.asm
	$(OBJDUMP) -t $@ | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $*.sym

$U/usys.S : $U/usys.pl
	perl $U/usys.pl > $U/usys.S

$U/usys.o : $U/usys.S
	$(CC) $(CFLAGS) -c -o $U/usys.o $U/usys.S

$U/_forktest: $U/forktest.o $(ULIB)
	# forktest has less library code linked in - needs to be small
	# in order to be able to max out the proc table.
	$(LD) $(LDFLAGS) -N -e main -Ttext 0 -o $U/_forktest $U/forktest.o $U/ulib.o $U/usys.o
	$(OBJDUMP) -S $U/_forktest > $U/forktest.asm


mkfs/mkfs: mkfs/mkfs.c $I/fs.h $I/param.h
	gcc -Wno-unknown-attributes -I. -o mkfs/mkfs mkfs/mkfs.c

# Prevent deletion of intermediate files, e.g. cat.o, after first build, so
# that disk image changes after first build are persistent until clean.  More
# details:
# http://www.gnu.org/software/make/manual/html_node/Chained-Rules.html
.PRECIOUS: %.o

UPROGS= \
	$U/_test \
	$U/_waiter \
	$U/_usertest \
	$U/_filetest \
<<<<<<< HEAD
	$U/_prioritytest \
	$U/_cowtest \
=======
>>>>>>> parent of 4565b58 (<feat>:<优先级调度>)

fs.img: mkfs/mkfs  $(UPROGS)
	mkfs/mkfs fs.img $(UPROGS)

DEPS :=  $(wildcard $(K)/*.d) $(wildcard $(K)/**/*.d) $(wildcard $(U)/*.d)
-include $(DEPS)

clean:
	rm -f $(K)/kernel $(K)/kernel.asm $(K)/kernel.sym mkfs/mkfs fs.img .gdbinit
	rm -f $(UPROGS) $(addsuffix .asm,$(UPROGS)) $(addsuffix .sym,$(UPROGS))
# 使用 OBJS 列表精确删除所有内核目标文件和依赖文件
	rm -f $(OBJS) $(OBJS:.o=.d)
# 清理用户程序的目标文件和依赖文件
	rm -f $(U)/*.o $(U)/*.d

# try to generate a unique GDB port
GDBPORT = $(shell expr `id -u` % 5000 + 25000)
# QEMU's gdb stub command line changed in 0.11
QEMUGDB = $(shell if $(QEMU) -help | grep -q '^-gdb'; \
	then echo "-gdb tcp::$(GDBPORT)"; \
	else echo "-s -p $(GDBPORT)"; fi)
ifndef CPUS
CPUS := 1
endif

QEMUOPTS = -machine virt -bios none -kernel $K/kernel -m 256M -smp $(CPUS) -nographic
QEMUOPTS += -global virtio-mmio.force-legacy=false
QEMUOPTS += -drive file=fs.img,if=none,format=raw,id=x0
QEMUOPTS += -device virtio-blk-device,drive=x0,bus=virtio-mmio-bus.0

qemu: check-qemu-version $K/kernel fs.img
	$(QEMU) $(QEMUOPTS)

.gdbinit: .gdbinit.tmpl-riscv
	sed "s/:1234/:$(GDBPORT)/" < $^ > $@

qemu-gdb: $K/kernel .gdbinit fs.img
	@echo "*** Now run 'gdb' in another window." 1>&2
	$(QEMU) $(QEMUOPTS) -S $(QEMUGDB)

gdb:
	riscv64-unknown-elf-gdb -x .gdbinit

print-gdbport:
	@echo $(GDBPORT)

QEMU_VERSION := $(shell $(QEMU) --version | head -n 1 | sed -E 's/^QEMU emulator version ([0-9]+\.[0-9]+)\..*/\1/')
check-qemu-version:
	@if [ "$(shell echo "$(QEMU_VERSION) >= $(MIN_QEMU_VERSION)" | bc)" -eq 0 ]; then \
		echo "ERROR: Need qemu version >= $(MIN_QEMU_VERSION)"; \
		exit 1; \
	fi