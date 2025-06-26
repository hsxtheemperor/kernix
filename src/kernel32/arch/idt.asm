; lidt file
global idt_load

idt_load:
    mov eax, [esp + 4] ; argument to function = address of idr_ptr
    lidt[eax]
    ret