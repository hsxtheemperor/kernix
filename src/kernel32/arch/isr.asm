; isr.asm - Handles CPU exceptions and sends control to a C function

[BITS 32]                ; Use 32-bit protected mode

; Macro for defining ISRs that do NOT push an error code
%macro ISR_NOERR 1
global isr%1             ; Export the label isrX for use in C/IDT setup
isr%1:
    cli                  ; Clear interrupt flag — disable interrupts temporarily
    push dword 0         ; Push dummy error code (for uniform stack)
    push dword %1        ; Push interrupt number (e.g., 0 for divide-by-zero)
    jmp isr_common_stub  ; Jump to common handler stub
%endmacro

; Macro for defining ISRs that DO push an error code
%macro ISR_ERR 1
global isr%1             ; Export label
isr%1:
    cli
    push dword %1        ; Push interrupt number
    jmp isr_common_stub
%endmacro

; Generate 32 ISRs (CPU exceptions 0–31)
ISR_NOERR 0  ; Divide-by-zero
ISR_NOERR 1  ; Debug exception
ISR_NOERR 2  ; Non-maskable interrupt
ISR_NOERR 3  ; Breakpoint
ISR_NOERR 4
ISR_NOERR 5
ISR_NOERR 6
ISR_NOERR 7
ISR_ERR   8  ; Double fault — pushes error code
ISR_NOERR 9
ISR_ERR  10  ; Invalid TSS
ISR_ERR  11  ; Segment Not Present
ISR_ERR  12  ; Stack-segment fault
ISR_ERR  13  ; General protection fault
ISR_ERR  14  ; Page fault
ISR_NOERR 15 ; Reserved
ISR_NOERR 16 ; x87 FPU Floating-Point Error
ISR_NOERR 17 ; Alignment Check
ISR_NOERR 18 ; Machine Check
ISR_NOERR 19 ; SIMD Floating-Point
; Up to ISR 31
ISR_NOERR 20
ISR_NOERR 21
ISR_NOERR 22
ISR_NOERR 23
ISR_NOERR 24
ISR_NOERR 25
ISR_NOERR 26
ISR_NOERR 27
ISR_NOERR 28
ISR_NOERR 29
ISR_NOERR 30
ISR_NOERR 31

; Shared stub for all ISRs
extern isr_handler      ; C function we will call

global isr_common_stub
isr_common_stub:
    cli                   ; Disable interrupts (defensive)
    
    pusha                 ; Push all general purpose registers: EAX, ECX, EDX, etc
    push ds               ; Push data segment registers to restore later
    push es
    push fs
    push gs

    ; Set segment registers to kernel data segment (0x10 in GDT)
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    push esp              ; Push pointer to register struct
    call isr_handler    ; Call C-level ISR handler
    add esp, 4            ; Clean up stack (argument we pushed)

    ; Exit Code

    ; Restore segment registers
    pop gs
    pop fs
    pop es
    pop ds
    popa                  ; Restore general purpose registers

    add esp, 8            ; Clean up pushed error code and interrupt number
    sti                   ; Re-enable interrupts
    iretd                 ; Return from ISR (pops EIP, CS, EFLAGS, etc)

extern keyboard_handler   ; Keyboard Handler from keyboarddriver32.c
global keyboard_isr
keyboard_isr:
    cli                   ; Disable interrupts
    pusha                 ; Save all general-purpose registers

    call keyboard_handler ; Keyboard Handler from keyboarddriver32.c

    popa
    sti                   ; Re-enable interrupts
    iretd