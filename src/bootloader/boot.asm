[BITS 16]
[ORG 0x7C00]

; Constants
CODE_SEG        equ 0x08
DATA_SEG        equ 0x10
KERNEL_SEG      equ 0x1000
KERNEL_OFFSET   equ 0x0000
KERNEL_LBA      equ 2
KERNEL_SECTORS  equ 8
KERNEL_PM_ADDR  equ 0x100000

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

; === Load 8 sectors from 0x1000:0000 (0x100000 linear) ===
    mov ah, 0x02              ; BIOS: read sectors
    mov al, KERNEL_SECTORS
    mov ch, 0x00              ; Cylinder 0
    mov cl, KERNEL_LBA        ; Sector 2
    mov dh, 0x00              ; Head 0
    mov dl, 0x80              ; Boot drive
    mov bx, KERNEL_OFFSET     ; Offset 0
    mov ax, KERNEL_SEG        ; Move KERNEL_SEG into ax first
    mov es, ax                ; Set ES to 0x1000
    int 0x13
    jc disk_error

; === Enter Protected Mode ===
load_pm:
    cli
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp CODE_SEG:pm_entry

; === GDT Setup ===
gdt_start:
    dq 0x0000000000000000

    ; Code Segment
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10011010b
    db 11001111b
    db 0x00

    ; Data Segment
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10010010b
    db 11001111b
    db 0x00

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

; === 32-bit Protected Mode Entry ===
[BITS 32]
pm_entry:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x9C00

    jmp KERNEL_PM_ADDR

; === Disk Error ===
disk_error:
    hlt
    jmp $

; === Padding ===
times 510 - ($ - $$) db 0
dw 0xAA55
