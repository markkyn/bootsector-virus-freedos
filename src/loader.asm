[BITS 16]
[ORG 0x7e00] // Global Offset do Boot

start:
    ; Reajustando o VideoMode para TextMode
    mov ax, 3
    int 10h



    ; Ativação de Long Mode
    mov [DriveId], dl

    mov eax,0x80000000
    cpuid
    cmp eax,0x80000001
    jb NotSupport

    mov eax,0x80000001
    cpuid

    test edx, (1<<29)
    jz NotSupport
    test edx, (1<<26)
    jz NotSupport
    
    mov ah, 0x13 ; Write string (EGA+, meaning PC AT minimum) 
    mov al, 0x01 ; Write Mode = True
    mov bx, 0x0a
    xor dx, dx
    mov dh, 0x01
    mov bp, longmode_message ; Ponteiro de String 
    mov cx, longmode_len     ; Numero de Caracteres
    int 10h

; Carregamento do Kernel File
Kernel:
    mov si,ReadPacket
    mov word[si],0x10
    mov word[si+2],100
    mov word[si+4],0
    mov word[si+6],0x1000
    mov dword[si+8],6
    mov dword[si+0xc],0
    mov dl,[DriveId]
    mov ah,0x42
    int 0x13
    jc  ReadError


; Loop sobre o Mapa de Memoria
MermoryMap: ; Int 15h
    mov eax,0xe820
    mov edx,0x534d4150
    mov ecx,20
    mov edi,0x9000
    xor ebx,ebx
    int 0x15
    jc NotSupport
MemoryMapLoop:
    add edi,20
    mov eax,0xe820
    mov edx,0x534d4150
    mov ecx,20
    int 0x15
    jc MemoryMapDone

    test ebx,ebx
    jnz MemoryMapLoop

MemoryMapDone:
    
    mov ah, 0x13 ; Write string (EGA+, meaning PC AT minimum) 
    mov al, 0x01 ; Write Mode = True
    mov bx, 0x0a
    xor dx, dx
    mov dh, 0x02
    mov bp, memorymap_msg ; Ponteiro de String 
    mov cx, memorymap_len     ; Numero de Caracteres
    int 10h

ProtectedMode:
; Colocaremos GDT em FlatMemoryMode
;Before switching to protected mode, you must:
;   - Disable interrupts, including NMI (as suggested by Intel Developers Manual).
;   - Enable the A20 Line.
;    - Load the Global Descriptor Table with segment descriptors suitable for code, data, and stack.   

    cli ; Desativando Interrupções
    lgdt [GDT_descriptor]
    lidt [IDT_descriptor]
    mov eax, cr0
    or  eax, 1
    mov cr0, eax

    jmp code_seg_len:start_protected_mode 

ReadError:
NotSupport:
End:
    hlt
    jmp End


[BITS 32] ; FINALMENTE ESTAMOS EM 32 BITS!!!!!!
start_protected_mode:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, 0x7c00 ; ponteiro para o carregamento do Boot

    mov al, 'P'
    mov ah, 0x0F

    mov [0xb8000], ax ; 0xb8000 está o VideoMemory


protected_mode_inf_loop:
    hlt
    jmp protected_mode_inf_loop


; Outras Var Globals
DriveId: db 0
ReadPacket: times 16 db 0

; Strings 
loader_message: db "Loader Carregado com sucesso!", 0
loader_len: equ $-loader_message

longmode_message: db "Long Mode Suportado!", 0
longmode_len: equ $-longmode_message

memorymap_msg: db "Memory Map concluido!", 0
memorymap_len: equ $-memorymap_msg

; GDT
GDT:
    null_descriptor:
        dq 0
    code32_descriptor:
        dw 0xffff
        dw 0
        db 0
        db 0x9a
        db 0xcf
        db 0
    data_descriptor:
        dw 0xffff
        dw 0
        db 0
        db 0x92
        db 0xcf
        db 0
GDT_end:
GDT_descriptor:
    dw GDT_end - GDT - 1    ; Tamanho da tabela
    dd GDT                  ; ponteiro para o inicio


code_seg_len equ code32_descriptor - GDT
data_seg_len equ data_descriptor - GDT


IDT_descriptor: dw 0
                dd 0