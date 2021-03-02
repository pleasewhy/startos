
K = kernel
U = user
CPUS = 1
TOOLPREFIX = riscv64-unknown-elf-


QEMU = qemu-system-riscv64
LD = $(TOOLPREFIX)ld
CC = $(TOOLPREFIX)gcc
OBJCOPY = $(TOOLPREFIX)objcopy
OBJDUMP = $(TOOLPREFIX)objdump


CFLAGS = -Wall -Werror -O -fno-omit-frame-pointer -ggdb
CFLAGS += -MD
CFLAGS += -mcmodel=medany
CFLAGS += -ffreestanding -fno-common -nostdlib -mno-relax
CFLAGS += -I.
CFLAGS += -fno-stack-protector


QEMUOPTS = -machine virt -bios none -kernel $K/kernel -m 128M -smp $(CPUS) -nographic
QEMUOPTS += -drive file=fs.img,if=none,format=raw,id=x0
QEMUOPTS += -device virtio-blk-device,drive=x0,bus=virtio-mmio-bus.0

GDBPORT = 26000


OBJS = \
  $K/entry.o \
  $K/start.o \
  $K/main.o \
  $K/uart.o \
  $K/console.o \
  $K/plic.o \
  $K/kernelvec.o \
  $K/process.o \
  $K/string.o \
  $K/switch.o \
  $K/printf.o \
  $K/memory/kalloc.o \
  $K/memory/vm.o \
  $K/fs/virtio_disk.o \
  $K/fs/exec.o \
  $K/fs/file.o \
  $K/fs/fs.o \
  $K/fs/buf_cache.o \
  $K/lock/spinlock.o \
  $K/lock/sleeplock.o \
  $K/trap/trampoline.o \
  $K/trap/trap.o \
  $K/trap/syscall.o \
  $K/trap/sysfile.o \

UPROGS =\
	$U/_init\
	$U/_sh\
	$U/_ls\

ULIB = $U/usys.o $U/printf.o $U/ulib.o

_%: %.o $(ULIB)
	$(LD) $(LDFLAGS) -N -e main -Ttext 0 -o $@ $^
	$(OBJDUMP) -S $@ > $*.asm
	$(OBJDUMP) -t $@ | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $*.sym

$U/usys.S : $U/usys.pl
	perl $U/usys.pl > $U/usys.S

$U/usys.o : $U/usys.S
	$(CC) $(CFLAGS) -c -o $U/usys.o $U/usys.S

initcode: $U/initcode.S
	$(CC) $(CFLAGS) -march=rv64g -nostdinc -I. -Ikernel -c $U/initcode.S -o $U/initcode.o
	$(LD) $(LDFLAGS) -N -e start -Ttext 0 -o $U/initcode.out $U/initcode.o
	$(OBJCOPY) -S -O binary $U/initcode.out $U/initcode
	$(OBJDUMP) -S $U/initcode.o > $U/initcode.asm
	od -t xC $U/initcode


LDFLAGS = -z max-page-size=4096
$K/kernel: $(OBJS) $K/kernel.ld fs.img
	$(LD) $(LDFLAGS) -T $K/kernel.ld -o $K/kernel $(OBJS) 
	$(OBJDUMP) -S $K/kernel > $K/kernel.asm

-include kernel/*.d user/*.d

fs.img: mkfs/makefs.c $(UPROGS) $U/usys.o
	gcc -o mkfs/makefs mkfs/makefs.c
	mkfs/makefs fs.img $(UPROGS)


qemu: $K/kernel fs.img
	$(QEMU) $(QEMUOPTS)

.gdbinit: .gdbinit.tmpl-riscv
	sed "s/:1234/:$(GDBPORT)/" < $^ > $@

qemu-gdb: $K/kernel .gdbinit
	@echo "*** Now run 'gdb' in another window." 1>&2
	$(QEMU) $(QEMUOPTS) -S -gdb tcp::$(GDBPORT)

clean: 
	rm -f *.tex *.dvi *.idx *.aux *.log *.ind *.ilg \
	*/*.o */*.d */*.asm */*.sym \
	*/*/*.o */*/*.d */*/*.asm */*/*.sym \
	$K/kernel fs.img mkfs/makefs \
	$(UPROGS) \

.PHONY: clean
