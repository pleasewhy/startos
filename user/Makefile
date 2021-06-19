TOOLPREFIX = riscv64-unknown-elf-

LD = $(TOOLPREFIX)ld
CXX = $(TOOLPREFIX)g++
CC = $(TOOLPREFIX)gcc
OBJCOPY = $(TOOLPREFIX)objcopy
OBJDUMP = $(TOOLPREFIX)objdump

CFLAGS += -MD
CFLAGS += -mcmodel=medany
CFLAGS += -ffreestanding -fno-common -nostdlib -mno-relax
CFLAGS += -I. -I../lib
CFLAGS += $(shell $(CC) -fno-stack-protector -E -x c /dev/null >/dev/null 2>&1 && echo -fno-stack-protector)

LDFLAGS = -z max-page-size=4096


UPROGS =\
	_init \
	_shell \
	_echo \
	_ls \
	_wc \
	_cat \

ULIB = usys.o ulib.o printf.o malloc.o
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
	od -t xC initcode > initcode.txt
	python3 gen_submit_init.py ./initcode.txt >> initcode.txt

submit: _oscmp_init
	$(OBJCOPY) -S -O binary _oscmp_init oscmp_init.bin
	od -t xC oscmp_init.bin > submit.txt
	python3 gen_submit_init.py ./submit.txt >> submit.txt


dst=/mnt
fs.img: $(UPROGS)
	@if [ ! -f "fs.img" ]; then \
		echo "making fs image..."; \
		dd if=/dev/zero of=fs.img bs=512k count=512; \
		mkfs.vfat -F 32 fs.img; fi
	@sudo mount fs.img $(dst)
	@if [ ! -d "$(dst)/bin" ]; then sudo mkdir $(dst)/bin; fi
	sudo cp  this_is_long_name_file.txt $(dst)/this_is_long_name_file.txt
	@for file in $$( ls _* ); do \
		sudo cp $$file $(dst)/$${file#_};\
		sudo cp $$file $(dst)/bin/$${file#_}; \
		echo cp $$file; done
	@sudo umount $(dst)
	@cp fs.img ../fs.img

clean: 
	rm -f *.tex *.dvi *.idx *.aux *.log *.ind *.ilg *.d *.o *.out _* fs.img \
			*.asm *.sym init *.bin

.PHONY: clean initcode