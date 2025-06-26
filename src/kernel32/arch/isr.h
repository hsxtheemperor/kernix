#pragma once

#include <types.h>

/*
 * Structure representing the state of the CPU during an interrupt.
 * This is passed from assembly to the C-level ISR handler.
 * It mirrors the exact stack layout after pushing registers and calling from isr_common_stub.
 */
typedef struct {
    uint32_t ds;          // Data segment selector pushed manually

    // Pushed by pusha instruction (order matters)
    uint32_t edi;
    uint32_t esi;
    uint32_t ebp;
    uint32_t esp;         // User ESP (not kernel stack)
    uint32_t ebx;
    uint32_t edx;
    uint32_t ecx;
    uint32_t eax;

    // Interrupt number and error code
    uint32_t int_no;      // Pushed manually: which ISR was triggered (0–31)
    uint32_t err_code;    // May be dummy 0 or actual CPU error code

    // Automatically pushed by the processor on interrupt
    uint32_t eip;         // Instruction pointer when interrupt occurred
    uint32_t cs;          // Code segment selector
    uint32_t eflags;      // CPU flags register
    uint32_t useresp;     // Stack pointer if ring change occurred
    uint32_t ss;          // Stack segment if ring change occurred
} registers_t;

/*
 * This is the main C handler for all ISRs.
 * It receives a pointer to the `registers_t` struct, containing full context.
 */
void isr_handler(registers_t* regs);
