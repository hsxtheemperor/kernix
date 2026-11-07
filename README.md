# Kernix

[Repository](https://github.com/hsxtheemperor/kernix)

Kernix is a small 16-bit x86 boot-sector experiment written in NASM Assembly. Its current boot sector initializes real-mode segments and a stack, prints `Hello World!` through the BIOS video teletype service (`INT 10h`), then halts. The source pads the image to a boot-sector-sized 512 bytes and adds the `0xAA55` signature.

The repository also contains notes about BIOS functions, bootloading, and real mode.

## Build

With NASM installed, run `make` from the repository root to assemble `src/bootloader/boot.asm` into `bin/boot.bin`. The repository does not currently document an emulator or hardware boot workflow.

## License

There is no `LICENSE` file or GitHub license declaration in the repository. Reuse permissions are therefore not specified; check with the project owner before reusing the code.
