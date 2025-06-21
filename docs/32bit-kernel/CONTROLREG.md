### Control Registers Table (32-bit mode)

| Register | Bit(s) | Name / Flag              | Meaning / Function                                                                        |
| -------- | ------ | ------------------------ | ----------------------------------------------------------------------------------------- |
| **CR0**  | 0      | PE (Protection Enable)   | Enables Protected Mode when set to 1                                                      |
|          | 1      | MP (Monitor Coprocessor) | Controls interaction of WAIT/FWAIT instructions with TS flag                              |
|          | 2      | EM (Emulation)           | When set, no x87 FPU present; FPU instructions generate #UD (Undefined Instruction)       |
|          | 3      | TS (Task Switched)       | Set by CPU on task switch to control FPU context saving                                   |
|          | 4      | ET (Extension Type)      | Set to 1 for 387 math coprocessor                                                         |
|          | 5      | NE (Numeric Error)       | Enables internal x87 floating-point error reporting (if clear, uses PIC exception)        |
|          | 16     | WP (Write Protect)       | When set, supervisor mode cannot write read-only pages                                    |
|          | 18     | AM (Alignment Mask)      | Controls alignment checking (if AM=1 and AC flag in EFLAGS=1, enables alignment checking) |
|          | 29     | NW (Not Write-through)   | Controls cache write-through or write-back for paging                                     |
|          | 30     | CD (Cache Disable)       | When set disables internal caches                                                         |
|          | 31     | PG (Paging)              | Enables paging when set                                                                   |

\| **CR1**  | —             | Reserved                    | Not used                                                                                            |

\| **CR2**  | 0-31          | Page-fault Linear Address    | Stores the linear address that caused the last page fault                                          |

\| **CR3**  | 0-11          | Reserved                    | Must be zero                                                                                         |
\|          | 12-31         | Page Directory Base (PDBR)  | Holds physical address of the page directory (aligned on 4KB boundary)                             |

\| **CR4**  | 0             | VME (Virtual-8086 Mode Extensions) | Enables V86 mode extensions                                                                         |
\|          | 1             | PVI (Protected-mode Virtual Interrupts) | Enables virtual interrupts in protected mode                                                        |
\|          | 2             | TSD (Time Stamp Disable)     | If set, disables RDTSC instruction in user mode                                                    |
\|          | 3             | DE (Debugging Extensions)    | Enables I/O breakpoints using debug registers                                                      |
\|          | 4             | PSE (Page Size Extensions)  | Enables 4MB pages                                                                                   |
\|          | 5             | PAE (Physical Address Extension) | Enables 36-bit physical addressing                                                                  |
\|          | 6             | MCE (Machine Check Exception) | Enables machine check exceptions                                                                    |
\|          | 7             | PGE (Page Global Enable)     | Enables global pages                                                                                 |
\|          | 8             | PCE (Performance-Monitoring Counter Enable) | Enables RDTSC instruction at all privilege levels                                                |
\|          | 9             | OSFXSR (Operating System Support for FXSAVE/FXRSTOR) | Enables support for SSE instructions                                                             |
\|          | 10            | OSXMMEXCPT (Operating System Support for Unmasked SIMD Exceptions) | Enables unmasked SIMD floating-point exceptions                                                   |

