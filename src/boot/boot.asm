[BITS 16]
[ORG 0x7c00] // Global Offset do Boot

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00

; Referências da DiskExtension e Loader:
;      https:;en.wikipedia.org/wiki/INT_13H
TestDiskExtension:
    mov [DriverId], dl ; Driver Index
    mov ah, 0x41       ; Wiki AH=0x41 - Test Whether Extensions Are Available 
    mov bx, 0x55aa     ; setado por definição
    
    int 0x13
    
    jc NotSupport
    cmp bx, 0xaa55
    jne NotSupport

Loader:
    mov si, ReadPacket
    mov word  [ si ], 0x10   ; Size
    mov word  [ si+ 2 ], 5      ; Contagem de Setores
    mov word  [ si+ 4 ], 0x7e00 ; Offset
    mov word  [ si+ 6 ], 0      ; Segment
    mov dword [ si+ 8 ], 1      ; Address low
    mov dword [ si+ 0xc ], 0      ; Address High  

    mov dl, [DriverId]
    mov ah, 0x42
    int 0x13
    jc ReadError

    mov dl, [DriverId]  
    jmp 0x7e00

ReadError:
NotSupport: ; Jump de Disco não suportado
    mov ah, 0x13 ; Write string (EGA+, meaning PC AT minimum) 
    mov al, 0x01 ; Write Mode = True
    mov bx, 0x0a
    xor dx, dx
    mov bp, ReadError_message ; Ponteiro de String 
    mov cx, ReadError_len     ; Numero de Caracteres
    int 0x10

End:
    hlt
    jmp End ; Loop Infinito

DriverId:    db 0 
Disk_message: db "Disco Suportado!", 0
Disk_len: equ $-Disk_message
ReadError_message: db "Erro no Carregamento do Loader"
ReadError_len: equ $-ReadError_message
ReadPacket: times 16 db 0


; Padding
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