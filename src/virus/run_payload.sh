# Programa Carregado pelo virus
nasm -f bin ./payload.asm -o ../../bin/virus/payload.bin

# Criando FloppyDusk zerado
dd if=/dev/zero of=../../build/floppy bs=512 count=2880
dd if=../../bin/virus/payload.bin of=../../build/floppy.flp