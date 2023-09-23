rm -f boot.img.lock
nasm -f bin ./src/boot.asm -o ./bin/boot.bin
nasm -f bin ./src/loader.asm -o ./bin/loader.bin
nasm -f elf64 ./src/kernel.asm -o ./bin/kernel.o
gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c ./src/kernel/main.c -o ./bin/main.o
ld -nostdlib -T ./src/link.lds -o ./lib/kernel ./bin/kernel.o ./bin/main.o
objcopy -O binary ./lib/kernel ./bin/kernel.bin
dd if=./bin/boot.bin of=boot.img bs=512 count=1 conv=notrunc
dd if=./bin/loader.bin of=boot.img bs=512 count=5 seek=1 conv=notrunc
dd if=./bin/kernel.bin of=boot.img bs=512 count=100 seek=6 conv=notrunc