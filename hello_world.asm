[BITS 16]
[ORG 0x7c00]

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00

TestDiskExtension:
    mov [DriveId], dl
    mov ah, 0x41
    mov bx, 0x55aa
    int 0x13
    jc NotSupport
    cmp bx, 0xaa55
    jne NotSupport

PrintMessage:
    mov ah, 0x13
    mov al, 0x01
    mov bx, 0x0a
    xor dx, dx
    mov bp, Disk_message
    mov cx, Disk_len
    int 0x10

NotSupport:


End:
    hlt
    jmp End

DriveId:    db 0
Disk_message: db "Disco Suportado", 0
Disk_len: equ $-Disk_message


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