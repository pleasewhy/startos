TOOLPREFIX = riscv64-unknown-elf-

LD = $(TOOLPREFIX)ld
CXX = $(TOOLPREFIX)g++
CC = $(TOOLPREFIX)gcc
OBJCOPY = $(TOOLPREFIX)objcopy
OBJDUMP = $(TOOLPREFIX)objdump

CFLAGS = -Wall -Werror -O -fno-omit-frame-pointer -ggdb
CFLAGS += -MD
CFLAGS += -mcmodel=medany
CFLAGS += -ffreestanding -fno-common -nostdlib -mno-relax
CFLAGS += -I.
CFLAGS += -fno-stack-protector

LDFLAGS = -z max-page-size=4096


UPROGS =\
	./_init\

ULIB = usys.o ulib.o printf.o
.PRECIOUS: %.o

_%: %.o $(ULIB)
	$(LD) $(LDFLAGS) -N -e main -Ttext 0 -o $@ $^
	$(OBJDUMP) -S $@ > $*.asm
	$(OBJDUMP) -t $@ | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $*.sym

usys.S: usys.pl
	perl usys.pl > usys.S

usys.o: usys.S
	$(CC) $(CFLAGS) -I../kernel/include -c -o usys.o usys.S


initcode: initcode.S
	$(CC) $(CFLAGS) -march=rv64g -nostdinc -I. -I../kernel/include -c initcode.S -o initcode.o
	$(LD) $(LDFLAGS) -N -e start -Ttext 0 -o initcode.out initcode.o
	$(OBJCOPY) -S -O binary initcode.out initcode
	$(OBJDUMP) -S initcode.o > initcode.asm
	od -t xC initcode

dst=/mnt
fs.img: $(UPROGS)
	@if [ ! -f "fs.img" ]; then \
		echo "making fs image..."; \
		dd if=/dev/zero of=fs.img bs=512k count=512; \
		mkfs.vfat -F 32 fs.img; fi
	@sudo mount fs.img $(dst)
	@sudo cp README.txt $(dst)/README.txt
	@if [ ! -d "$(dst)/bin" ]; then sudo mkdir $(dst)/bin; fi
	@for file in $$( ls _* ); do \
		sudo cp $$file $(dst)/$${file#_};\
		sudo cp $$file $(dst)/bin/$${file#_}; done
	@sudo umount $(dst)
	@mv fs.img ../fs.img

clean: 
	rm -f *.tex *.dvi *.idx *.aux *.log *.ind *.ilg *.d *.o *.out _* fs.img \
			*.asm *.sym

.PHONY: clean