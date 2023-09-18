[BITS 16]
[ORG 0x7c00]

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00

PrintMessage:
    mov ah, 0x13
    mov al, 0x01
    mov bx, 0x0a
    xor dx, dx
    mov bp, Hello
    mov cx, Hello_len
    int 0x10

End:
    jlt
    jmp End

Hello: db "Hello"
MessageLen: equ $-Hello


times (0x1be - ($-$$)) db 0

    db 80h
    db 0,2,0
    db 0F0H
    db 0FFH, 0FFh, 0FFH
    dd 1
    dd (20*16*63-1)

    times (16*3) db 0

    db 0x55
    db 0xaa 