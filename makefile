FILES = ./build/kernel32.asm.o ./build/kernel32.o
FLAGS = -g -ffreestanding -nostdlib -nostartfiles -nodefaultlibs -Wall -O0 -Iinc

all:
	nasm -f bin ./src/bootloader/boot.asm -o ./bin/boot.bin
	nasm -f elf -g ./src/kernel32/kernel32.asm -o ./build/kernel32.asm.o
	i686-elf-gcc -I./src $(FLAGS) -std=gnu99 -c ./src/kernel32/kernel32.c -o ./build/kernel32.o
	i686-elf-ld -g -relocatable $(FILES) -o ./build/completeKernel32.o
	i686-elf-gcc $(FLAGS) -T ./src/linkerScript.ld -o ./bin/kernel32.bin -ffreestanding -O0 -nostdlib  ./build/completeKernel32.o

	dd if=./bin/boot.bin >>./bin/os.bin
	dd if=./bin/kernel32.bin >>./bin/os.bin
	dd if=/dev/zero bs=512 count=8 >> ./bin/os.bin

hexedit-boot:
	ghex ./bin/boot.bin
hexedit-kernel32:
	ghex ./bin/kernel32.bin
hexedit-os:
	ghex ./bin/os.bin
hexedit:
	ghex ./bin/*

clean:
	rm -f ./bin/boot.bin
	rm -f ./bin/kernel32.bin
	rm -f ./bin/os.bin
	rm -f ./build/kernel32.asm.o
	rm -f ./build/kernel32.o
	rm -f ./build/completeKernel32.o