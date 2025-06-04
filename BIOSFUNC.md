Here's a comprehensive **BIOS Function Table** organized by:

* **Interrupt Number (INT)**
* **Function Selector (AX / AH)**
* **Input Registers (BX, CX, DX, ES\:BX, etc.)**
* **Output Registers (AX, Flags, etc.)**
* **Description (Function Name)**

This covers commonly used BIOS interrupts like **INT 0x10 (video services)**, **INT 0x13 (disk services)**, and others like **INT 0x12, 0x15, 0x16, 0x1A, 0x11**, which are relevant for OS/bootloader-level work.

---

### 📺 INT 0x10 — Video Services

| AX / AH  | Input Registers                                  | Output Registers    | Description                                      |
| -------- | ------------------------------------------------ | ------------------- | ------------------------------------------------ |
| AH=00h   | AL = video mode                                  | None                | Set video mode                                   |
| AH=01h   | CH = row, CL = column                            | None                | Set cursor position                              |
| AH=02h   | BH = page, DH = row, DL = col                    | None                | Set cursor position                              |
| AH=03h   | BH = page                                        | DH = row, DL = col  | Get cursor position                              |
| AH=06h   | AL = #lines, BH = attr, CH/DH = row, CL/DL = col | AL = lines scrolled | Scroll up area                                   |
| AH=07h   | Same as 06h                                      | AL = lines scrolled | Scroll down area                                 |
| AH=09h   | AL = char, BH = page, BL = attr, CX = count      | None                | Write character & attribute at cursor            |
| AH=0Eh   | AL = char, BH = page, BL = color                 | None                | Teletype output (TTY), writes character          |
| AX=4F00h | ES\:DI = buffer ptr                              | AX = status         | VESA Get SuperVGA info                           |
| AX=4F01h | CX = mode, ES\:DI = ptr                          | AX = status         | VESA Get mode info                               |
| AX=4F02h | BX = mode                                        | AX = status         | VESA Set VBE mode                                |
| AX=4F0Ah | BL = function, BH = page                         | AX = status         | VESA Set/Get display start (panning, split line) |

---

### 💽 INT 0x13 — Disk Services

| AX / AH | Input Registers                                                             | Output Registers                 | Description          |
| ------- | --------------------------------------------------------------------------- | -------------------------------- | -------------------- |
| AH=00h  | DL = drive                                                                  | AH = status                      | Reset disk system    |
| AH=01h  | DL = drive                                                                  | AH = status                      | Get disk status      |
| AH=02h  | AL = sectors, CH = cyl, CL = sector, DH = head, DL = drive, ES\:BX = buffer | AH = status                      | Read sectors (CHS)   |
| AH=03h  | Same as 02h                                                                 | AH = status                      | Write sectors (CHS)  |
| AH=08h  | DL = drive                                                                  | CH, CL, DH = geometry, AH = type | Get drive parameters |
| AH=15h  | DL = drive                                                                  | AH = status                      | Get disk type        |
| AH=41h  | BX = 55AAh                                                                  | BX = AA55h, AH = major version   | Check for Extensions |
| AH=42h  | DL = drive, DS\:SI = DAP                                                    | AH = status                      | Extended Read (LBA)  |
| AH=43h  | DL = drive, DS\:SI = DAP                                                    | AH = status                      | Extended Write (LBA) |

---

### ⌨ INT 0x16 — Keyboard Services

| AH     | Input Registers | Output Registers      | Description                        |
| ------ | --------------- | --------------------- | ---------------------------------- |
| AH=00h | None            | AH = scan, AL = ASCII | Read key (waits)                   |
| AH=01h | None            | ZF set if no key      | Check for keystroke (non-blocking) |
| AH=02h | None            | AL = shift flags      | Get shift flags                    |

---

### ⌛ INT 0x1A — RTC & BIOS Time Services

| AH     | Input Registers | Output Registers                              | Description         |
| ------ | --------------- | --------------------------------------------- | ------------------- |
| AH=00h | None            | CX\:DX = ticks since midnight                 | Get BIOS time ticks |
| AH=02h | None            | CH = hour, CL = min, DH = sec                 | Get RTC time        |
| AH=04h | None            | CH = century, CL = year, DH = month, DL = day | Get RTC date        |
| AH=0Bh | None            | AL = status                                   | Get RTC status      |

---

### 🖱 INT 0x33 — Mouse Services

| AX       | Input Registers | Output Registers              | Description               |
| -------- | --------------- | ----------------------------- | ------------------------- |
| AX=0000h | None            | AX = 0xFFFF if present        | Mouse installed check     |
| AX=0001h | None            | AX, BX = buttons, CX/DX = pos | Show mouse pointer        |
| AX=0003h | None            | BX = buttons, CX/DX = pos     | Get mouse position/status |
| AX=0004h | CX = x, DX = y  | None                          | Set mouse position        |

---

### 📄 INT 0x12 — Get Conventional Memory

| AH  | Input Registers | Output Registers | Description                           |
| --- | --------------- | ---------------- | ------------------------------------- |
| N/A | None            | AX = KB size     | Get conventional memory (up to 640KB) |

---

### 🧠 INT 0x15 — System Services (Advanced BIOS)

| AX / AH  | Input Registers                           | Output Registers              | Description                       |
| -------- | ----------------------------------------- | ----------------------------- | --------------------------------- |
| AH=86h   | CX\:DX = µs delay                         | CF set if unsupported         | BIOS wait (pause in microseconds) |
| AX=E820h | EDX = 534D4150h, EBX = 0, ES\:DI = buffer | EAX = SMAP, EBX = next offset | Get memory map (Modern BIOS)      |
| AH=87h   | ES\:SI = DMA buffer                       | CF = failure flag             | Move memory block (DMA)           |
| AH=C0h   | None                                      | AL = ID string                | Get System ID                     |

---

### 🧱 INT 0x11 — Equipment List

| AH  | Input Registers | Output Registers     | Description               |
| --- | --------------- | -------------------- | ------------------------- |
| N/A | None            | AX = equipment flags | Detect system peripherals |

---

### 🧠 INT 0x19 — Bootstrap Loader

| AH  | Input Registers | Output Registers | Description                |
| --- | --------------- | ---------------- | -------------------------- |
| N/A | None            | Never returns    | Load boot sector & execute |

---

### 🖧 INT 0x60-0x67 — User Defined

| INT      | Input Registers | Output Registers | Description                                  |
| -------- | --------------- | ---------------- | -------------------------------------------- |
| INT 60h+ | Varies          | Varies           | Often used by TSRs or custom BIOS extensions |

---

### ✅ Legend and Notes

* `AH/AX` = Function selector (depends on interrupt)
* `CF` = Carry flag (error if set)
* `ES:BX` or `DS:SI` = Pointers to memory buffers
* `CHS` = Cylinder-Head-Sector (older disk geometry)
* `LBA` = Logical Block Addressing (modern disks)
* `VESA` = VBE extensions (video BIOS extension)
* `SMAP` = System Memory Address Map (used by OS)
