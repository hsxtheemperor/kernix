### 🧠 **16-bit x86 CPU Registers**

| Register  | Full Name            | Type    | Function / Usage                                                              |
| --------- | -------------------- | ------- | ----------------------------------------------------------------------------- |
| **AX**    | Accumulator Register | General | Main register for arithmetic, logic, and data transfer operations             |
| **BX**    | Base Register        | General | Used for indirect addressing and base pointer in memory access                |
| **CX**    | Count Register       | General | Used as a loop counter and for shifts/rotations (e.g., `LOOP`, `SHL`, `ROR`)  |
| **DX**    | Data Register        | General | Used in multiplication/division and I/O operations                            |
| **SP**    | Stack Pointer        | Special | Points to the top of the stack                                                |
| **BP**    | Base Pointer         | Special | Used to access parameters and local variables in the stack (stack frame)      |
| **SI**    | Source Index         | Index   | Used in string operations (source)                                            |
| **DI**    | Destination Index    | Index   | Used in string operations (destination)                                       |
| **IP**    | Instruction Pointer  | Special | Holds the address of the next instruction to execute                          |
| **FLAGS** | Status Flags         | Special | Stores status flags (Zero, Carry, Sign, Overflow, etc.) for condition control |
| **CS**    | Code Segment         | Segment | Points to the code segment in memory                                          |
| **DS**    | Data Segment         | Segment | Points to the data segment in memory                                          |
| **SS**    | Stack Segment        | Segment | Points to the stack segment in memory                                         |
| **ES**    | Extra Segment        | Segment | Often used in string and memory operations as an extra segment                |

---

### 🔍 Register Naming Convention

Some 16-bit registers can be accessed in parts:

| 16-bit | High Byte | Low Byte |
| ------ | --------- | -------- |
| AX     | AH        | AL       |
| BX     | BH        | BL       |
| CX     | CH        | CL       |
| DX     | DH        | DL       |
