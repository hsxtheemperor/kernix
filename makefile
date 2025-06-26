# === Build Entire OS Image ===
# Target: build everything from source to final OS image

all: bin/os.bin


# === STEP 1: Assemble 16-bit Bootloader ===
# This bootloader starts the system in real mode and sets up for protected mode

bin/boot.bin: src/bootloader/boot.asm
	mkdir -p bin
	nasm -f bin src/bootloader/boot.asm -o bin/boot.bin


# === STEP 2: Assemble 32-bit Assembly Code ===
# These are low-level routines for CPU exceptions and system startup

build/kernel32.o: src/kernel32/kernel32.asm
	mkdir -p build/kernel32
	nasm -f elf -g src/kernel32/kernel32.asm -o build/kernel32.o

build/isr.o: src/kernel32/arch/isr.asm
	mkdir -p build/kernel32/arch
	nasm -f elf -g src/kernel32/arch/isr.asm -o build/isr.o

build/idt.o: src/kernel32/arch/idt.asm
	nasm -f elf -g src/kernel32/arch/idt.asm -o build/idt.o

build/syscall32.o: src/kernel32/sys/syscall32.asm
	mkdir -p build/kernel32/sys
	nasm -f elf -g src/kernel32/sys/syscall32.asm -o build/syscall32.o


# === STEP 3: Compile C Code ===
# These are your C drivers, kernel logic, and interrupt handlers

# Video output (VGA text mode)
build/videodriver32.o: src/kernel32/drivers/videodriver32.c
	mkdir -p build/kernel32/drivers
	i686-elf-gcc -ffreestanding -nostdlib -nostartfiles -nodefaultlibs -Wall -O0 -g \
		-Isrc -Isrc/kernel32 -Isrc/kernel32/drivers -Isrc/kernel32/arch \
		-c src/kernel32/drivers/videodriver32.c -o build/videodriver32.o

# Keyboard driver
build/keyboarddriver32.o: src/kernel32/drivers/keyboarddriver32.c
	i686-elf-gcc -ffreestanding -nostdlib -nostartfiles -nodefaultlibs -Wall -O0 -g \
		-Isrc -Isrc/kernel32 -Isrc/kernel32/drivers -Isrc/kernel32/arch \
		-c src/kernel32/drivers/keyboarddriver32.c -o build/keyboarddriver32.o

# IDT Table Compilation
build/idt_handler.o: src/kernel32/arch/idt.c
	i686-elf-gcc -ffreestanding -nostdlib -nostartfiles -nodefaultlibs -Wall -O0 -g \
		-Isrc -Isrc/kernel32 -Isrc/kernel32/drivers -Isrc/kernel32/arch \
		-c src/kernel32/arch/idt.c -o build/idt_handler.o

# Main kernel entrypoint in C
build/kernel32_main.o: src/kernel32/kernel32.c
	i686-elf-gcc -ffreestanding -nostdlib -nostartfiles -nodefaultlibs -Wall -O0 -g \
		-Isrc -Isrc/kernel32 -Isrc/kernel32/drivers -Isrc/kernel32/arch \
		-c src/kernel32/kernel32.c -o build/kernel32_main.o

# C-side ISR handler
build/isr_handler.o: src/kernel32/arch/isr.c
	i686-elf-gcc -ffreestanding -nostdlib -nostartfiles -nodefaultlibs -Wall -O0 -g \
		-Isrc -Isrc/kernel32 -Isrc/kernel32/drivers -Isrc/kernel32/arch \
		-c src/kernel32/arch/isr.c -o build/isr_handler.o


# === STEP 4: Link All Object Files into Kernel ===
# The linker script ensures correct layout and entry point

bin/kernel32.bin: \
	build/kernel32.o \
	build/isr.o build/idt.o build/syscall32.o \
	build/videodriver32.o build/keyboarddriver32.o \
	build/kernel32_main.o build/isr_handler.o build/idt_handler.o
	mkdir -p bin
		i686-elf-ld -T src/linkerScript.ld -nostdlib -o bin/kernel32.bin \
		build/kernel32.o \
		build/isr.o build/idt.o build/syscall32.o \
		build/videodriver32.o build/keyboarddriver32.o \
		build/kernel32_main.o build/isr_handler.o build/idt_handler.o



# === STEP 5: Create Final OS Image ===
# Concatenate bootloader + kernel. Add 4KB padding for safety.

bin/os.bin: bin/boot.bin bin/kernel32.bin
	cat bin/boot.bin bin/kernel32.bin > bin/os.bin
	dd if=/dev/zero bs=512 count=8 >> bin/os.bin


# === UTILITY COMMANDS ===

# Clean build artifacts
clean:
	rm -rf build/* bin/*

# Run in QEMU for testing
run:
	qemu-system-i386 -drive format=raw,file=bin/os.bin

.PHONY: all clean run
