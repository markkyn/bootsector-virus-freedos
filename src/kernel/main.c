#include "stdlib.h"
#include "stddef.h"
#include "headers/mem_lib.h"

typedef void (*boot_ptr)();

// Chamada de Entrada do nosso kernel
void kernel_main(void)
{
    // Em tese isso nao deve carregar
    char *video_mem_ptr = (char *)(0xb8000);

    // video_mem_p[0] = 'M';
    // video_mem_p[1] = 0xa;
    static char origin_data[2];
    char* origin_ptr_test = origin_data;

    origin_ptr_test[0] = 'X';
    origin_ptr_test[1] = 0xa;

    k_memcpy( video_mem_ptr, origin_ptr_test, 2 );

    //boot_ptr jump_to_boot = (boot_ptr)0x200000;
    //jump_to_boot();
}