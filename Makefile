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
ASM_SRC = $(ARCH_DIR)/boot.asm $(ARCH_DIR)/gdt_flush.asm $(ARCH_DIR)/idt_load.asm $(ARCH_DIR)/isr.asm
C_SRC = $(KERNEL_DIR)/kernel.c $(KERNEL_DIR)/serial.c $(KERNEL_DIR)/gdt.c $(KERNEL_DIR)/idt.c

# Object files
ASM_OBJ = $(BUILD_DIR)/boot.o $(BUILD_DIR)/gdt_flush.o $(BUILD_DIR)/idt_load.o $(BUILD_DIR)/isr.o
C_OBJ = $(BUILD_DIR)/kernel.o $(BUILD_DIR)/serial.o $(BUILD_DIR)/gdt.o $(BUILD_DIR)/idt.o

# Output
KERNEL_BIN = $(BUILD_DIR)/kernel.bin
ISO_FILE = YggdrasilOS.iso

# Default target
all: $(ISO_FILE)

# Create build directory
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Assemble boot.asm
$(BUILD_DIR)/boot.o: $(ARCH_DIR)/boot.asm | $(BUILD_DIR)
	$(AS) $(ASFLAGS) $(ARCH_DIR)/boot.asm -o $(BUILD_DIR)/boot.o

# Assemble gdt_flush.asm
$(BUILD_DIR)/gdt_flush.o: $(ARCH_DIR)/gdt_flush.asm | $(BUILD_DIR)
	$(AS) $(ASFLAGS) $(ARCH_DIR)/gdt_flush.asm -o $(BUILD_DIR)/gdt_flush.o

# Assemble idt_load.asm
$(BUILD_DIR)/idt_load.o: $(ARCH_DIR)/idt_load.asm | $(BUILD_DIR)
	$(AS) $(ASFLAGS) $(ARCH_DIR)/idt_load.asm -o $(BUILD_DIR)/idt_load.o

# Assemble isr.asm
$(BUILD_DIR)/isr.o: $(ARCH_DIR)/isr.asm | $(BUILD_DIR)
	$(AS) $(ASFLAGS) $(ARCH_DIR)/isr.asm -o $(BUILD_DIR)/isr.o

# Compile kernel.c
$(BUILD_DIR)/kernel.o: $(KERNEL_DIR)/kernel.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -I$(KERNEL_DIR) -c $(KERNEL_DIR)/kernel.c -o $(BUILD_DIR)/kernel.o

# Compile serial.c
$(BUILD_DIR)/serial.o: $(KERNEL_DIR)/serial.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -I$(KERNEL_DIR) -c $(KERNEL_DIR)/serial.c -o $(BUILD_DIR)/serial.o

# Compile gdt.c
$(BUILD_DIR)/gdt.o: $(KERNEL_DIR)/gdt.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -I$(KERNEL_DIR) -c $(KERNEL_DIR)/gdt.c -o $(BUILD_DIR)/gdt.o

# Compile idt.c
$(BUILD_DIR)/idt.o: $(KERNEL_DIR)/idt.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -I$(KERNEL_DIR) -c $(KERNEL_DIR)/idt.c -o $(BUILD_DIR)/idt.o

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
