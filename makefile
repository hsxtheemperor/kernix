all:
	nasm -f bin ./src/bootloader/boot.asm -o ./bin/boot.bin

hexedit:
	ghex bin/boot.bin

clean:
	rm -f ./bin/boot.bin