#ifndef _MEMORYMAP_H_
#define _MEMORYMAP_H_

#include "stdint.h"

struct E820 {
    uint64_t address;
    uint64_t length;
    uint64_t type;
} __attribute__((packed));


struct FreeMemRegion {
    uint64_t address;
    uint64_t lenght;
};

void init_memory(void);

#endif