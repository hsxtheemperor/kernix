[BITS 32] ; 32-bit Kernel Mode

global _start
extern kernel32_main

_start:
    call kernel32_main ; Call the 32-bit Kernel

    jmp $

times 512 - ($ - $$) db 0