[ORG 0x1000]


start:
    ; Print("Loader Carregado com Sucesso")
    mov ah, 0x13 ; Write string (EGA+, meaning PC AT minimum) 
    mov al, 0x01 ; Write Mode = True
    mov bx, 0x0a
    xor dx, dx
    mov bp, kernel_message ; Ponteiro de String 
    mov cx, kernel_len     ; Numero de Caracteres
    int 10h

End:
    hlt
    jmp End

kernel_message: db "Kernel File Carregado!", 0
kernel_len: equ $-kernel_message