nasm -f bin payload.asm -o ../../bin/payload.bin
nasm -f bin virus.asm -o ../../bin/virus.bin

dd if=/dev/zero of=../../build/floppy.flp bs=512 count=2880 # Criação do FloppyDisk
dd if=../../bin/payload.bin of=../../build/floppy.flp bs=512 count=1 conv=notrunc seek=1 # Inserção do Payload
dd if=../../bin/virus.bin of=../../build/floppy.flp bs=512 count=1 conv=notrunc # Inserção do virus
