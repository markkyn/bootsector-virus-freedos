section .data
Gdt64:
    dq 0
    dq 0x0020980000000000 ; Ambos os segmentos definidos aqui, mas o data nao usamos
    dq 0x0020F80000000000 ; Ambos os segmentos definidos aqui, mas o data nao usamos
    dq 0x0000F20000000000 ; Ambos os segmentos definidos aqui, mas o data nao usamos

Gdt64Len: equ $-Gdt64
Gdt64Ptr: dw Gdt64Len-1
          dq Gdt64


section .text
extern kernel_main
global start
start:
    mov rax, Gdt64Ptr
    lgdt [rax]
    
    mov rax, kernel_entry
    push 8
    push rax
    db 0x48
    retf

kernel_entry:
    mov byte[0xb8000],'K'
    mov byte[0xb8001],0xa

    mov rsp, 0xffff800000200000

    call kernel_main ; Integração com C

End:
    hlt
    jmp End

user_end:
    jmp user_end
