rm -f boot.img.lock

# OS files
nasm -f bin ./src/boot.asm -o ./bin/boot.bin
nasm -f bin ./src/loader.asm -o ./bin/loader.bin
nasm -f elf64 ./src/kernel.asm -o ./bin/kernel.o

# Libs
nasm -f elf64 ./src/kernel/mem_lib.asm -o ./bin/mem_lib.o

# Kernel files
gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c ./src/kernel/main.c -o ./bin/main.o
gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c ./src/kernel/print_lib.c -o ./bin/print_lib.o
# Linking
ld -nostdlib -T ./src/link.lds -o ./lib/kernel ./bin/kernel.o ./bin/main.o ./bin/mem_lib.o ./bin/print_lib.o
objcopy -O binary ./lib/kernel ./bin/kernel.bin

# Image Updating
dd if=./bin/boot.bin   of=boot.img bs=512 count=1 conv=notrunc
dd if=./bin/loader.bin of=boot.img bs=512 count=5 seek=1 conv=notrunc
dd if=./bin/kernel.bin of=boot.img bs=512 count=100 seek=6 conv=notrunc