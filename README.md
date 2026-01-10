# YggdrasilOS

A custom x86-64 operating system built from scratch with GUI support, inspired by the Norse world tree that connects all realms.

## 🌳 About

YggdrasilOS is a hobby operating system project developed from the ground up in C (with select components in Rust). The goal is to create a fully functional OS with:

- Custom kernel with memory management
- Process scheduling and multithreading
- Filesystem support
- Device drivers
- Network stack (TCP/IP)
- Graphical user interface
- Desktop environment

## 🚀 Features (Planned)

- [x] Project setup
- [ ] Bootloader (GRUB/Multiboot2)
- [ ] x86-64 kernel bootstrap
- [ ] Memory management (paging, heap allocator)
- [ ] Interrupt handling
- [ ] Process/thread management
- [ ] VFS and filesystem (FAT32)
- [ ] Device drivers (keyboard, mouse, display)
- [ ] GUI framework and window manager
- [ ] Network stack
- [ ] SMP support
- [ ] Userspace applications

## 🛠️ Building

### Prerequisites

- x86_64-elf cross-compiler (GCC)
- NASM assembler
- QEMU for testing
- GDB for debugging
- GNU Make

### Build Instructions

```bash
# Clone the repository
git clone https://github.com/Slygear/YggdrasilOS.git
cd YggdrasilOS

# Build the kernel
make

# Run in QEMU
make run

# Debug with GDB
make debug
```

Detailed build instructions can be found in [docs/BUILD.md](docs/BUILD.md).

## 📚 Documentation

- [Development Roadmap](docs/ROADMAP.md) - Complete development plan
- [Build Guide](docs/BUILD.md) - Setup and compilation instructions
- [Architecture](docs/ARCHITECTURE.md) - System design overview

## 🗂️ Project Structure

```
YggdrasilOS/
├── bootloader/       # Bootloader configuration
├── kernel/           # Kernel source code
│   ├── arch/         # Architecture-specific code
│   ├── mm/           # Memory management
│   ├── proc/         # Process management
│   ├── fs/           # Filesystem
│   ├── drivers/      # Device drivers
│   └── gui/          # GUI subsystem
├── libc/             # Standard C library
├── userspace/        # Userspace programs
├── tools/            # Build tools and utilities
└── docs/             # Documentation
```

## 🎯 Current Status

**Phase:** Initial Setup  
**Progress:** Setting up development environment and project structure

Check the [roadmap](docs/ROADMAP.md) for detailed development phases.

## 🤝 Contributing

This is currently a personal learning project, but suggestions and discussions are welcome!

## 📖 Resources

- [OSDev Wiki](https://wiki.osdev.org/)
- [Intel 64 and IA-32 Architectures Software Developer Manuals](https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html)
- [AMD64 Architecture Programmer's Manual](https://www.amd.com/en/support/tech-docs)

## 📜 License

MIT License - See [LICENSE](LICENSE) file for details

---

**Note:** This is an educational project. Not intended for production use.
