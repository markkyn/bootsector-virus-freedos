#include "headers/mmap_lib.h"
#include "headers/print_lib.h"

static struct FreeMemRegion free_mem_region[50];

void init_memory(void)
{
    int32_t count = *(int32_t *)0x9000; // Valor de topo definido aqui e usado lá no loader.asm (MemoryMap)

    uint64_t total_mem;

    struct E820 *mem_map = (struct E820 *)0x9008; // Tem que ler o OsDev umas 4 x pra entender o E820... e mesmo assim...

    int free_region_count = 0;

    for (int32_t i = 0; i < count; i++)
    {
        // Contagem de memoria livre
        if (mem_map[i].type == 1)
        {
            free_mem_region[free_region_count].address = mem_map[i].address;
            free_mem_region[free_region_count].lenght = mem_map[i].length;

            total_mem += mem_map[i].length;
            free_region_count++;
        }
        // printk("free region") // TODO: Ainda nao implementado 100% (preguiça)
    }

        // printk("Memoria Total de Sistema") // TODO: Ainda nao implementado 100% (preguiça)
}