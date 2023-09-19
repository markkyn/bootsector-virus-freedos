rm -f boot.img.lock
nasm -f bin ./src/boot.asm -o ./bin/boot.bin
nasm -f bin ./src/loader.asm -o ./bin/loader.bin
dd if=./bin/boot.bin of=boot.img bs=512 count=1 conv=notrunc
dd if=./bin/loader.bin of=boot.img bs=512 count=5 seek=1 conv=notrunc
