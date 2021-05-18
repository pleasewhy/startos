K = kernel
U = user
T = ./target
CPUS = 2


TOOLPREFIX = riscv64-linux-gnu-
QEMU = qemu-system-riscv64

OBJCOPY = $(TOOLPREFIX)objcopy
OBJDUMP = $(TOOLPREFIX)objdump


include platform.mk

ifeq ($(platform), K210)
RUSTSBI = ./rustsbi/sbi-k210
else
RUSTSBI = ./rustsbi/sbi-qemu
endif

# RUSTSBI:
# ifeq ($(platform), K210)
# 	@cd ./rustsbi/rustsbi-k210 && \
# 	cargo build && cp ./target/riscv64gc-unknown-none-elf/debug/rustsbi-k210 ../sbi-k210
# 	@$(OBJDUMP) -S rustsbi/sbi-k210 > $T/rustsbi-k210.asm
# 	$(OBJDUMP) -t rustsbi/sbi-k210 | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $T/k210-sbi.sym
# else
# 	@cd ./rustsbi/rustsbi-qemu && \
# 	cargo build && cp ./target/riscv64gc-unknown-none-elf/debug/rustsbi-qemu ../sbi-qemu
# 	@$(OBJDUMP) -S rustsbi/sbi-qemu > $T/rustsbi-qemu.asm
# 	$(OBJDUMP) -t rustsbi/sbi-qemu | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $T/qemu-sbi.sym
# endif

QEMUOPTS = -machine virt -bios none -kernel $T/kernel -m 8M -smp $(CPUS) -nographic
QEMUOPTS += -bios $(RUSTSBI)
QEMUOPTS += -drive file=fs.img,if=none,format=raw,id=x0
QEMUOPTS += -device virtio-blk-device,drive=x0,bus=virtio-mmio-bus.0


GDBPORT = 26000

$T/kernel:
	cd kernel;$(MAKE) kernel

.gdbinit: .gdbinit.tmpl-riscv
	sed "s/:1234/:$(GDBPORT)/" < $^ > $@

qemu-gdb: $T/kernel .gdbinit
	@echo "*** Now run 'gdb' in another window." 1>&2
	$(QEMU) $(QEMUOPTS) -S -gdb tcp::$(GDBPORT)



k210-serialport = /dev/ttyUSB0

kernelImg = $T/kernel.bin
k210 = $T/k210.bin


fs.img:
# cd user;$(MAKE) fs.img

oscmp:
	@if [ ! -f "fs.img" ]; then \
	echo "making fs image..."; \
	dd if=/dev/zero of=fs.img bs=512k count=512; \
	mkfs.vfat -F 32 fs.img; fi
	@sudo mount fs.img /mnt
	sudo cp -r submit/riscv64/* /mnt/
	@sudo umount /mnt


sd = /dev/sdb

sd: fs.img
	@if [ "$(sd)" != "" ]; then \
		echo "flashing into sd card..."; \
		sudo dd if=fs.img of=$(sd); \
	else \
		echo "sd card not detected!"; fi


qemu: $T/kernel fs.img
	$(QEMU) $(QEMUOPTS)

all: 
	cd kernel;$(MAKE) kernel
	# $(OBJCOPY) $T/kernel --strip-all -O binary $(kernelImg)
	# $(OBJCOPY) $(RUSTSBI) --strip-all -O binary $(k210)
	# dd if=$(kernelImg) of=$(k210) bs=128k seek=1
	# cp $(k210) k210.bin

k210: $T/kernel
	@$(OBJCOPY) $T/kernel --strip-all -O binary $(kernelImg)
	@$(OBJCOPY) $(RUSTSBI) --strip-all -O binary $(k210)
	@dd if=$(kernelImg) of=$(k210) bs=128k seek=1
	@$(OBJDUMP) -D -b binary -m riscv $(k210) > $T/k210.asm
	# @sudo chmod 777 $(k210-serialport)
	python3 ./tools/kflash.py -p $(k210-serialport) -b 1500000 -t $(k210)

# $HOME/.cargo/bin
clean:
	cd kernel;$(MAKE) clean
	cd user;$(MAKE) clean
	rm -f $T/*.bin $T/*.asm $T/*.sym $T/kernel k210.bin

cleansbi:
	cd ./rustsbi/rustsbi-k210; cargo clean
	cd ./rustsbi/rustsbi-qemu; cargo clean

.PHONY: clean $T/kernel RUSTSB fs.img