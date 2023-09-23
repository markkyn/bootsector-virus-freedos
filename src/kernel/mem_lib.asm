section .text

global k_memcpy
global k_memset

k_memcpy:
    ; Parâmetros
    ;   edi: endereço de destino
    ;   esi: endereço de origem
    ;   ecx: quantidade de bytes

    cld
    mov ecx, edx

    .loop:
        cmp ecx, 0
        je .done

        mov al, [esi] ; Origem para Registrador
        mov [edi], al ; Registrador para Destino

        inc edi
        inc esi
        dec ecx

        jmp .loop

    .done:
        ret


k_memset:
    ; Parâmetros
    ;   edi: endereço de destino
    ;   esi: novo byte
    ;   ecx: quantidade de caracteres

    .loop:
        cmp ecx, 0
        je .done

        mov [edi], esi
        inc edi
        dec ecx

    .done:
        ret