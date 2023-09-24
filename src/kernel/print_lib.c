#include "stdint.h"
#include "stdarg.h"
#include "headers/print_lib.h"

static struct VideoMemory video_memory = {(char *)0xb8000, 0, 0};

extern void k_write(char ascii, uint8_t attr, int row, int col)
{
    char *video_mem_ptr = video_memory.start_address;

    video_mem_ptr[2 * col] = ascii;
    video_mem_ptr[2 * col + 1] = 0xa;
}

void k_print(const char *format, ...)
{
    char buffer[1024];
}