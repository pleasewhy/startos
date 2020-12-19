
K = kernel
CPUS = 1
TOOLPREFIX = riscv64-unknown-elf-


QEMU = qemu-system-riscv64
LD = $(TOOLPREFIX)ld
CC = $(TOOLPREFIX)gcc
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
  $K/io.o \
  $K/trap.o \
  $K/plic.o \
  $K/kernelvec.o \
  $K/process.o \
  $K/string.o \
  $K/switch.o \
  $K/syscall.o \
  $K/process_assist.o \

fs.img: mkfs/mkfs README
	mkfs/mkfs fs.img README

LDFLAGS = -z max-page-size=4096
$K/kernel: $(OBJS) $K/kernel.ld
	$(LD) $(LDFLAGS) -T $K/kernel.ld -o $K/kernel $(OBJS) 
	$(OBJDUMP) -S $K/kernel > $K/kernel.asm



-include kernel/*.d user/*.d


qemu: $K/kernel
	$(QEMU) $(QEMUOPTS)

.gdbinit: .gdbinit.tmpl-riscv
	sed "s/:1234/:$(GDBPORT)/" < $^ > $@

qemu-gdb: $K/kernel .gdbinit
	@echo "*** Now run 'gdb' in another window." 1>&2
	$(QEMU) $(QEMUOPTS) -S -gdb tcp::$(GDBPORT)

clean: 
	rm -f *.tex *.dvi *.idx *.aux *.log *.ind *.ilg \
	*/*.o */*.d */*.asm */*.sym \
	$U/initcode $U/initcode.out $K/kernel \