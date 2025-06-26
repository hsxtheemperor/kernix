#include <kernel32.h>
#include <types.h>

// Declarations from elsewhere
extern void idt_install();       // From idt.c
extern void vga_clear();
extern void vga_print(char*);

void kernel32_main(){
    vga_clear();

    vga_print("Welcome to Kernix OS!\n");
    vga_print("Keyboard driver loaded.\n");

    idt_install();         // Set up IDT and load it

    asm volatile("sti");   // Enable interrupts

    while(1);              // Halt here — input handled via interrupts
}