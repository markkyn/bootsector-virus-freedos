nasm -f bin virus.asm -o ../../bin/virus.bin
nasm -f bin payload.asm -o ../../bin/payload.bin

dd if=/dev/zero of=../../build/floppy.flp bs=512 count=2880
dd if=../../bin/payload.bin of=../../build/floppy.flp bs=512 count=1 conv=notrunc seek=1
dd if=../../bin/virus.bin of=../../build/floppy.flp bs=512 count=1 conv=notrunc