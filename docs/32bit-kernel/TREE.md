project-root/
├── archive-files/       # External source archives
├── bin/                 # Final compiled binaries
├── build/               # Temporary build files (.o)
├── docs/                # Technical notes, dev guides
├── iso-img/             # Output ISO image versions
├── src/                 # All source code
│   ├── bootloader/      # 16-bit Real Mode bootloader
│   ├── kernel32/        # 32-bit kernel code
│   │   ├── arch/        # Architecture-specific (e.g., x86)
│   │   │   ├── idt.c
│   │   │   ├── idt.h
│   │   │   ├── isr.c
│   │   │   └── isr.asm
│   │   ├── drivers/     # Device drivers (VGA, keyboard, etc.)
│   │   │   ├── vga.c
│   │   │   ├── vga.h
│   │   │   ├── keyboard.c
│   │   │   └── keyboard.h
│   │   ├── sys/         # System interface (syscalls, tasks, etc.)
│   │   │   ├── syscall.c
│   │   │   └── syscall.h
│   │   ├── kernel.c     # Entry point for 32-bit kernel
│   │   ├── kernel.h
│   │   ├── kernel32.asm # Low-level setup routines
│   │   └── linker.ld
├── build.sh             # Build script
├── makefile             # Makefile for compilation
└── README.md
