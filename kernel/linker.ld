/* linker.ld - Kernel linker script */

ENTRY(_start)

SECTIONS
{
    /* Kernel starts at 1MB */
    . = 1M;

    /* Multiboot header at the beginning */
    .boot :
    {
        *(.multiboot_header)
    }

    /* Text section (code) */
    .text ALIGN(4K) : AT(ADDR(.text))
    {
        *(.text)
    }

    /* Read-only data */
    .rodata ALIGN(4K) : AT(ADDR(.rodata))
    {
        *(.rodata)
    }

    /* Initialized data */
    .data ALIGN(4K) : AT(ADDR(.data))
    {
        *(.data)
    }

    /* Uninitialized data (BSS) */
    .bss ALIGN(4K) : AT(ADDR(.bss))
    {
        *(COMMON)
        *(.bss)
    }
}
