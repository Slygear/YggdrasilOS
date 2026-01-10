#ifndef IDT_H
#define IDT_H

#include <stdint.h>

void idt_init(void);
void exception_handler(uint32_t int_no, uint32_t err_code);

#endif
