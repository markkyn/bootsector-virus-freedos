[BITS 16]
[ORG 0x100]

section .text

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00

    mov ax, 0x13
    int 10h

    mov ah, 0x0B
    mov bh, 0x00
    mov bl, 0x01

    int 10h

    xor di, di
.loop:


    mov ah, 0x0C
    mov al, 0x0C
    mov bh, 0x00
    mov cx, di
    mov dx, 0
    int 10h
    
    mov ah, 86h
    mov cx, 0
    mov dx, 50
    int 15h


    inc di
    cmp di, 320*200
    je .end
    jmp .loop

.end:
    hlt
    jmp .end

R: db 'R'
r_len: equ $-R

; Imagem da Caveira
img:
    times (200) db 0x0a
    
times (0x1be - ($-$$)) db 0

    db 80h
    db 0,2,0
    db 0F0H
    db 0FFH, 0FFh, 0FFH
    dd 1
    dd (20*16*63-1)

    times (16*3) db 0

    ; Limite do Disco
    db 0x55
    db 0xaa 