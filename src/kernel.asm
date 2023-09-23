[BITS 64]
[ORG 0x200000]

start:
    mov byte[0xb8000],'K'
    mov byte[0xb8001],0xa

    lgdt [Gdt64Ptr]

    retf
End:
    hlt
    jmp End

Gdt64:
    dq 0
    dq 0x0020980000000000 ; Ambos os segmentos definidos aqui, mas o data nao usamos
Gdt64Len: equ $-Gdt64
Gdt64Ptr: dw Gdt64Len-1
          dq Gdt64
