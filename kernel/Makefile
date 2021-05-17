
TOOLPREFIX = riscv64-unknown-elf-

include ../platform.mk
# platform = QEMU
# platform = K210

QEMU = qemu-system-riscv64
LD = $(TOOLPREFIX)ld
CXX = $(TOOLPREFIX)g++
CC = $(TOOLPREFIX)gcc
OBJCOPY = $(TOOLPREFIX)objcopy
OBJDUMP = $(TOOLPREFIX)objdump
T = ../target

DFLAGS = -D

OBJ_LINK_LIST:=$(CRTI_OBJ) $(CRTBEGIN_OBJ) $(OBJS) $(CRTEND_OBJ) $(CRTN_OBJ)
INTERNAL_OBJS:=$(CRTI_OBJ) $(OBJS) $(CRTN_OBJ)


FLAGS = -Wall -Werror -O -fno-omit-frame-pointer -ggdb -g
FLAGS += -MD
FLAGS += -mcmodel=medany
FLAGS += -ffreestanding -fno-common -nostdlib -mno-relax -fcheck-new
FLAGS += -I./include -I../lib
FLAGS += -fno-stack-protector
FLAGS += -Wno-sign-compare

ifeq ($(platform), K210)
FLAGS += -DK210
link = k210.ld
else
FLAGS += -DQEMU
link = qemu.ld
endif

ifeq ($(submit), true)
FLAGS += -DSUBMIT
endif

LDFLAGS = -z max-page-size=4096

CXXFLAGS = -std=c++11 
# CXXFLAGS += -fno-use-cxa-atexit
CXXFLAGS += -fno-rtti
CXXFLAGS += -fno-exceptions
CXXFLAGS += $(FLAGS)
CFLAGS = $(FLAGS)


# boot
OBJS = \
	boot/entry.o \
	boot/main.o \
	StartOS.o

# common
OBJS += \
	common/printk.o \
	common/string.o \

# # os
OBJS += \
	os/SpinLock.o \
	os/Cpu.o \
	os/trap.o \
	os/Plic.o \
	os/kernelvec.o \
	os/Timer.o \
	os/TaskScheduler.o \
	os/SleepLock.o \
	os/switch.o \
	os/trampoline.o \
	os/syscall.o \
	os/syscallProc.o \
	os/SyscallFile.o \
	os/Exec.o \
	os/Intr.o


#fs:
OBJS += \
	fs/inodefs/BufferLayer.o \
	fs/fat32/Fat.o \
	fs/disk/Disk.o \
	fs/vfs/Vfs.o \
	fs/devfs/DeviceFileSystem.o

# device:
OBJS += \
	device/Console.o

# memory:
OBJS += \
	memory/VmManager.o \
	memory/MemAllocator.o

ifeq ($(platform), K210)
OBJS += \
  driver/spi.o \
  driver/gpiohs.o \
  driver/fpioa.o \
  driver/utils.o \
  fs/disk/Sdcard.o \
  driver/dmac.o \
  driver/sysctl.o
else
OBJS += \
	fs/disk/VirtioDisk.o
endif

-include */*.d

CRTI_OBJ=boot/crti.o
CRTBEGIN_OBJ:=$(shell $(CXX) $(CFLAGS) -print-file-name=crtbegin.o)
CRTEND_OBJ:=$(shell $(CXX) $(CFLAGS) -print-file-name=crtend.o)
CRTN_OBJ=boot/crtn.o
OBJ_LINK_LIST:= $(OBJS) $(CRTI_OBJ) $(CRTBEGIN_OBJ) $(CRTEND_OBJ) $(CRTN_OBJ)

kernel: $(link) $(OBJ_LINK_LIST)
	$(LD) $(LDFLAGS) -T $(link) -o $T/kernel $(OBJ_LINK_LIST) -nostdlib
	$(OBJDUMP) -S $T/kernel > $T/kernel.asm
	@$(OBJDUMP) -t $T/kernel | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $T/kernel.sym

clean: 
	rm -f *.tex *.dvi *.idx *.aux *.log *.ind *.ilg *.d \
	*/*.o */*.d */*.asm */*.sym \
	*/*/*.o */*/*.d */*/*.asm */*/*.sym \
	kernel fs.img *.asm StartOS.o\

.PHONY: clean
