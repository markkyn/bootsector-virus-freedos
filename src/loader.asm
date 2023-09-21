[BITS 16]
[ORG 0x7e00] // Global Offset do Boot

start:
    ; Limpeza de Terminal
    mov ah, 0x00
    int 10h ; Na verdade aqui estou setando o video mode

    ; Reajustando o VideoMode para TextMode
    mov ax, 3
    int 10h

    ; Print("Loader Carregado com Sucesso")
    mov ah, 0x13 ; Write string (EGA+, meaning PC AT minimum) 
    mov al, 0x01 ; Write Mode = True
    mov bx, 0x0a
    xor dx, dx
    mov bp, loader_message ; Ponteiro de String 
    mov cx, loader_len     ; Numero de Caracteres
    int 10h

    mov ah, 0x02
    mov bh, 0x00
    mov dh, 1
    mov dl, 0
    
    int 10h

    ; Ativação de Long Mode
    mov [DriveId], dl
    mov eax, 0x80000000
    cpuid
    cmp eax, 0x80000001
    jb NotSupport

    mov eax, 0x80000001
    cpuid

    test edx, (1<<29)
    jz NotSupport
    test edx, (1<<26)
    jz NotSupport
    
    mov ah, 0x13 ; Write string (EGA+, meaning PC AT minimum) 
    mov al, 0x01 ; Write Mode = True
    mov bx, 0x0a
    xor dx, dx
    mov bp, longmode_message ; Ponteiro de String 
    mov cx, longmode_len     ; Numero de Caracteres
    int 10h

; Carregamento do Kernel File
Kernel:
    mov si, ReadPacket
    mov word  [ si ], 0x10          ; Size
    mov word  [ si+ 2 ], 100        ; Contagem de Setores
    mov word  [ si+ 4 ], 0          ; Offset
    mov word  [ si+ 6 ], 0x1000     ; Segment - 1MB
    mov dword [ si+ 8 ], 6          ; Address low
    mov dword [ si+ 0xc ], 0        ; Address High  

    mov dl, [ DriveId ]
    mov ah, 0x42
    int 13h
    jc ReadError

    mov dl, [ DriveId ]  
    jmp 0x1000

; Loop sobre o Mapa de Memoria
MermoryMap: ; Int 15h
    mov eax, 0xE820
    mov edx, 0x534d4150
    mov ecx, 20
    mov edi, 0x9000
    xor ebx, ebx
    int 15h
    jc NotSupport

MemoryMapLoop:
    add edi, 20
    mov eax, 0xE820
    mov edx, 0x534d4150
    mov ecx, 20
    int 15h
    jc MemoryMapDone

    test ebx, ebx
    jnz MemoryMapLoop

MemoryMapDone:
   ; Print("Loader Carregado com Sucesso")
    mov ah, 0x13 ; Write string (EGA+, meaning PC AT minimum) 
    mov al, 0x01 ; Write Mode = True
    mov bx, 0x0a
    xor dx, dx
    mov bp, memorymap_msg ; Ponteiro de String 
    mov cx, memorymap_len ; Numero de Caracteres
    int 10h

    mov ah, 0x02
    mov bh, 0x00
    mov dh, 1
    mov dl, 0
    
    int 10h

ReadError:
NotSupport:
End:
    hlt
    jmp End


DriveId: db 0
ReadPacket: times 16 db 0

loader_message: db "Loader Carregado com sucesso!", 0
loader_len: equ $-loader_message

longmode_message: db "Long Mode Suportado!", 0
longmode_len: equ $-longmode_message

memorymap_msg: db "Memory Map concluído!"
memorymap_len: db "Memory Map concluído!"

