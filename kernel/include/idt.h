/*
 * idt.h - Interrupt Descriptor Table header
 */

#ifndef IDT_H
#define IDT_H

#include <stdint.h>
#include "serial.h"

void idt_init(void);
void exception_handler(uint32_t int_no, uint32_t err_code);

#endif
