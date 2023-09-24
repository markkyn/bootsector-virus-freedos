#ifndef _PRINT_H_
#define _PRINT_H_

#define LINE_SIZE 160
#include "stdint.h"


struct VideoMemory {
    char* start_address;
    int column;
    int row;
};

void k_write(char ascii, uint8_t attr, int row, int col);
void k_print(const char *format, ...);

#endif