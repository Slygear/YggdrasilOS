# Makefile for YggdrasilOS

# Compiler and tools
AS = nasm
CC = gcc
LD = ld

# Flags
ASFLAGS = -f elf32
CFLAGS = -m32 -ffreestanding -O2 -Wall -Wextra -fno-exceptions -nostdlib -nostartfiles -nodefaultlibs
LDFLAGS = -m elf_i386 -T kernel/linker.ld -nostdlib

# Directories
KERNEL_DIR = kernel
ARCH_DIR = $(KERNEL_DIR)/arch/x86_64
BUILD_DIR = build
ISO_DIR = iso
BOOT_DIR = $(ISO_DIR)/boot
GRUB_DIR = $(BOOT_DIR)/grub

# Source files
ASM_SRC = $(ARCH_DIR)/boot.asm
C_SRC = $(KERNEL_DIR)/kernel.c

# Object files
ASM_OBJ = $(BUILD_DIR)/boot.o
C_OBJ = $(BUILD_DIR)/kernel.o

# Output
KERNEL_BIN = $(BUILD_DIR)/kernel.bin
ISO_FILE = YggdrasilOS.iso

# Default target
all: $(ISO_FILE)

# Create build directory
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Assemble boot.asm
$(ASM_OBJ): $(ASM_SRC) | $(BUILD_DIR)
	$(AS) $(ASFLAGS) $(ASM_SRC) -o $(ASM_OBJ)

# Compile kernel.c
$(C_OBJ): $(C_SRC) | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $(C_SRC) -o $(C_OBJ)

# Link kernel
$(KERNEL_BIN): $(ASM_OBJ) $(C_OBJ)
	$(LD) $(LDFLAGS) -o $(KERNEL_BIN) $(ASM_OBJ) $(C_OBJ)

# Create ISO image
$(ISO_FILE): $(KERNEL_BIN)
	mkdir -p $(GRUB_DIR)
	cp $(KERNEL_BIN) $(BOOT_DIR)/kernel.bin
	cp bootloader/grub.cfg $(GRUB_DIR)/grub.cfg
	grub-mkrescue -o $(ISO_FILE) $(ISO_DIR)

# Run in QEMU
run: $(ISO_FILE)
	qemu-system-i386 -cdrom $(ISO_FILE) -m 256M

# Run with serial output
run-serial: $(ISO_FILE)
	qemu-system-i386 -cdrom $(ISO_FILE) -m 256M -serial stdio

# Debug with GDB
debug: $(ISO_FILE)
	qemu-system-i386 -cdrom $(ISO_FILE) -m 256M -s -S &
	gdb -ex "target remote localhost:1234" -ex "symbol-file $(KERNEL_BIN)"

# Clean build artifacts
clean:
	rm -rf $(BUILD_DIR) $(ISO_DIR) $(ISO_FILE)

# Build only kernel
kernel: $(KERNEL_BIN)

.PHONY: all run run-serial debug clean kernel
