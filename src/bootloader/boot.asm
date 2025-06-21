[BITS 16] ; 16-bit Real Mode
[ORG 0x7c00] ; Set the origin to (starting address) 0x7c00, typical for Bootloaders

CODE_OFFSET equ 0x8

DATA_OFFSET equ 0x10

KERNEL32_LOAD_SEG equ 0x1000
KERNEL32_START_ADDR equ 0x100000
start:
    cli ; Clear interrupts
    mov ax, 0x00
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    sti ; Enable interrupts

; Load Kernel32 (CH, DH, CL, DL-> HARD DISK Head-Cyclider-Sector) [TODO (Drivers Required)]
mov bx, KERNEL32_LOAD_SEG
mov dh, 0x00
mov dl, 0x80
mov ch, 0x02
mov ch, 0x00
mov ah, 0x02
mov al, 8
int 0x13

jc disk_read_error

load_PM:
    cli
    lgdt [gdt_descriptor]
    mov eax, cr0 ; Control Registor 0
    or al, 1
    mov cr0, eax
    jmp CODE_OFFSET:PModeMain

disk_read_error:
    hlt

; GDT Implementation
gdt_start:
    dd 0x0
    dd 0x0

    ; Code segment descriptor
    dw 0xffff       ; Limit
    dw 0x0000       ; Base
    db 0x00         ; Base
    db 10011010b    ; Access byte [(pres, priv, type) , (ECRA)]
    db 11001111b    ; Flags [(GDL(AVL))]
    db 0x00         ; Base

    ; Data segment descriptor
    dw 0xffff       ; Limit
    dw 0x0000       ; Base
    db 0x00         ; Base
    db 10010010b    ; Access byte [(pres, priv, type) , (E(ED)WA)]
    db 11001111b    ; Flags [(GDL<AVL>)]
    db 0x00         ; Base

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; Size of GDT -1
    dd gdt_start ; Base/Location of GDT

[BITS 32] ; 32-bit Kernel Mode

; Protected Mode Setup
PModeMain:
    mov ax, DATA_OFFSET
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov ss, ax
    mov gs, ax
    mov ebp, 0x9c00 ; 32-bit Stack Pointer to not overflow BootLoader
    mov esp, ebp

    in al, 0x92
    or al, 2
    out 0x92, al

    jmp CODE_OFFSET:KERNEL32_START_ADDR

times 510 - ($ - $$) db 0

dw 0xAA55