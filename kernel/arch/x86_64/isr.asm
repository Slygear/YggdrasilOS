; isr.asm - Interrupt Service Routines
; Exception handlers 0-31

global isr0
global isr1
global isr2
global isr3
global isr4
global isr5
global isr6
global isr7
global isr8
global isr9
global isr10
global isr11
global isr12
global isr13
global isr14
global isr15
global isr16
global isr17
global isr18
global isr19
global isr20
global isr21
global isr22
global isr23
global isr24
global isr25
global isr26
global isr27
global isr28
global isr29
global isr30
global isr31

extern exception_handler

; ISR without error code
%macro ISR_NOERRCODE 1
isr%1:
    cli
    push byte 0        ; Push dummy error code
    push byte %1       ; Push interrupt number
    jmp isr_common_stub
%endmacro

; ISR with error code
%macro ISR_ERRCODE 1
isr%1:
    cli
    push byte %1       ; Push interrupt number
    jmp isr_common_stub
%endmacro

; Define ISRs
ISR_NOERRCODE 0
ISR_NOERRCODE 1
ISR_NOERRCODE 2
ISR_NOERRCODE 3
ISR_NOERRCODE 4
ISR_NOERRCODE 5
ISR_NOERRCODE 6
ISR_NOERRCODE 7
ISR_ERRCODE   8
ISR_NOERRCODE 9
ISR_ERRCODE   10
ISR_ERRCODE   11
ISR_ERRCODE   12
ISR_ERRCODE   13
ISR_ERRCODE   14
ISR_NOERRCODE 15
ISR_NOERRCODE 16
ISR_NOERRCODE 17
ISR_NOERRCODE 18
ISR_NOERRCODE 19
ISR_NOERRCODE 20
ISR_NOERRCODE 21
ISR_NOERRCODE 22
ISR_NOERRCODE 23
ISR_NOERRCODE 24
ISR_NOERRCODE 25
ISR_NOERRCODE 26
ISR_NOERRCODE 27
ISR_NOERRCODE 28
ISR_NOERRCODE 29
ISR_NOERRCODE 30
ISR_NOERRCODE 31

; Common ISR stub
isr_common_stub:
    pusha              ; Push all general purpose registers
    
    mov ax, ds
    push eax           ; Save data segment
    
    mov ax, 0x10       ; Load kernel data segment
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    
    call exception_handler
    
    pop eax            ; Restore data segment
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    
    popa               ; Pop all general purpose registers
    add esp, 8         ; Clean up error code and ISR number
    sti
    iret               ; Return from interrupt
