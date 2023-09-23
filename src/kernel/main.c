#include "stdlib.h"
#include "stddef.h"

// Chamada de Entrada do nosso kernel
void kernel_main(void)
{
    char *video_mem_p = (char *)(0xb8000);

    video_mem_p[0] = 'M';
    video_mem_p[1] = 0xa;

}