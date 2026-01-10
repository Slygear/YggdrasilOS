# Build Guide

## Setting Up Development Environment

### 1. Install Cross-Compiler

YggdrasilOS requires a cross-compiler targeting `x86_64-elf`.

#### Linux (Ubuntu/Debian)
```bash
sudo apt-get update
sudo apt-get install build-essential nasm qemu-system-x86 gdb grub-common xorriso mtools
```

#### Building the Cross-Compiler
```bash
cd tools
./build-cross-compiler.sh
```

This will download and compile GCC and binutils for the x86_64-elf target.

### 2. Install QEMU

QEMU is used for testing the OS without real hardware.

```bash
# Ubuntu/Debian
sudo apt-get install qemu-system-x86

# Arch Linux
sudo pacman -S qemu

# macOS
brew install qemu
```

### 3. Install Additional Tools

```bash
# NASM assembler
sudo apt-get install nasm

# GRUB tools
sudo apt-get install grub-pc-bin grub-common xorriso mtools
```

## Building YggdrasilOS

### Basic Build

```bash
# From project root
make
```

This will compile the kernel and create a bootable ISO image.

### Build Targets

```bash
make kernel      # Build kernel only
make iso         # Create bootable ISO
make run         # Build and run in QEMU
make debug       # Build and run with GDB debugging
make clean       # Clean build artifacts
```

## Running in QEMU

```bash
make run
```

Default QEMU options:
- 256MB RAM
- Serial output to stdio
- VGA display

### Debug Mode

```bash
make debug
```

This will start QEMU with GDB server on port 1234. In another terminal:

```bash
gdb kernel.elf
(gdb) target remote localhost:1234
(gdb) break kernel_main
(gdb) continue
```

## Troubleshooting

### Cross-Compiler Issues

If the cross-compiler fails to build, ensure you have all dependencies:
```bash
sudo apt-get install build-essential bison flex libgmp3-dev libmpc-dev libmpfr-dev texinfo
```

### QEMU Display Issues

If QEMU doesn't show graphics:
```bash
make run QEMU_ARGS="-display gtk"
```

## Next Steps

After successful build, check [ROADMAP.md](ROADMAP.md) for development phases.
