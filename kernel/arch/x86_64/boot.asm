; boot.asm - Multiboot2 header and bootstrap code
; This file sets up the initial environment for the kernel

section .multiboot_header
header_start:
    ; Multiboot2 magic number
    dd 0xe85250d6                ; magic number
    dd 0                         ; architecture (0 = i386)
    dd header_end - header_start ; header length
    
    ; checksum
    dd 0x100000000 - (0xe85250d6 + 0 + (header_end - header_start))
    
    ; end tag
    dw 0    ; type
    dw 0    ; flags
    dd 8    ; size
header_end:

section .bss
align 16
stack_bottom:
    resb 16384  ; 16 KiB stack
stack_top:

section .text
global _start
extern kernel_main

_start:
    ; Set up stack
    mov esp, stack_top
    
    ; Reset EFLAGS
    push 0
    popf
    
    ; Call kernel main function
    call kernel_main
    
    ; Hang if kernel returns
    cli
.hang:
    hlt
    jmp .hang

; GDT (Global Descriptor Table) for long mode
section .data
align 16
gdt64:
    dq 0                        ; null descriptor
.code: equ $ - gdt64
    dq (1<<43) | (1<<44) | (1<<47) | (1<<53) ; code segment
.data: equ $ - gdt64
    dq (1<<44) | (1<<47)        ; data segment
.pointer:
    dw $ - gdt64 - 1
    dq gdt64
