#pragma once
#include <types.h> // For uint16_t, uint32_t, etc.

// ─────────────────────────────────────────────────────────────
// Structure of an IDT entry (Gate Descriptor)
// Each entry in the IDT is 8 bytes and tells the CPU:
// - Where the interrupt handler is
// - What segment it's in (selector)
// - What type of interrupt gate it is
// - What privileges are needed to call it
// ─────────────────────────────────────────────────────────────
typedef struct {
    uint16_t base_low;   // Lower 16 bits of the handler function address
    uint16_t sel;        // Kernel segment selector (usually 0x08 for code segment in GDT)
    uint8_t  always0;    // This byte is always set to 0 (hardware requirement)
    uint8_t  flags;      // Flags: gate type, privilege level, and present bit (usually 0x8E [8 = Present bit (1), DPL = 00 (Ring 0), Storage Segment = 0E = 32-bit Interrupt Gate (1110)])
    uint16_t base_high;  // Upper 16 bits of the handler function address
} __attribute__((packed)) idt_entry_t;
// __attribute__((packed)) ensures that the compiler doesn't pad the structure in memory.

// ─────────────────────────────────────────────────────────────
// IDT Pointer — This structure is given to the CPU with `lidt`
// It tells the CPU where the IDT is and how big it is
// ─────────────────────────────────────────────────────────────
typedef struct {
    uint16_t limit;  // Size of the IDT in bytes - 1 (i.e., 256 entries = 256*8 - 1 = 2047)
    uint32_t base;   // Address of the first IDT entry (pointer to idt_entry_t[])
} __attribute__((packed)) idt_ptr_t;

// ─────────────────────────────────────────────────────────────
// Function: idt_set_gate
// Sets up a single entry in the IDT
// Params:
//   num  - Interrupt number (index in IDT table)
//   base - Address of the interrupt handler function
//   sel  - Segment selector (usually 0x08 = code segment in GDT)
//   flags- Type and attributes (e.g., 0x8E = present, ring 0, 32-bit interrupt gate)
// ─────────────────────────────────────────────────────────────
void idt_set_gate(int num, uint32_t base, uint16_t sel, uint8_t flags);

// ─────────────────────────────────────────────────────────────
// Function: idt_install
// Sets up the IDT and loads it into the CPU using `lidt`
// You'll define this in `idt.c` where you'll:
// - Create an array of 256 entries
// - Fill them with handlers (or 0 for unused)
// - Load the IDT with `lidt`
// ─────────────────────────────────────────────────────────────
void idt_install();
