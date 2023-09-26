[BITS 16]
[ORG 0x7c00] // Endereço do Bootsector

start:
    cli
    mov byte [DriveId], dl
    mov sp, 0xFFF8
    xor ax, ax
    mov ds, ax
    mov es, ax

    xor di, di
disk_loop:
    mov dl, [disk_codes+di]
    cmp dl, [DriveId]
    je next_disk



DriveId db 0


dw 0xAA55