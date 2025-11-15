# **RV32I Single-Cycle CPU Core in Verilog**



Hello, I'm Armmy! This is a 32-bit CPU core built from the ground up in Verilog. It was designed as a project to understand and implement the fundamentals of computer architecture.This processor is fully functional and capable of running compiled C code or RISC-V assembly that adheres to the `RV32I` base integer instruction set.





##### **1. Specifications**

* **Instruction Set Architecture (ISA):** `RV32I` (Base Integer Instruction Set)
* **Hardware Structure (HSA):** `Single-Cycle`
* **Memory Architecture:** `Modified Harvard` (separate 32-bit buses for Instruction and Data memory)





##### **2. Core Data Path**

Below is the complete data path diagram for the processor. It shows all major components, MUXes, and the flow of control and data signals required to implement the full `RV32I` instruction set.

!\[alt text]\[logo]

\[logo]: https://github.com/ArmmyC/ArmmyRV32I "Data Path"





##### **3. Implemented Instructions**

This core successfully implements all major instruction types from the RV32I specification:

**R-type**: `add`, `sub`, `sll`, `slt`, `sltu`, `xor`, `srl`, `sra`, `or`, `and`

**I-type**: `addi`, `slti`, `sltiu`, `xori`, `ori`, `andi`

**I-type (Load)**: `lb`, `lh`, `lw`, `lbu`, `lhu`

**I-type (Jump)**: `jalr`

**S-type**: `sb`, `sh`, `sw`

**B-type**: `beq`, `bne`, `blt`, `bge`, `bltu`, `bgeu`

**U-type**: `lui`, `auipc`

**J-type**: `jal` 



##### **4.Project Structure \& Modules**

The processor is built modularly, with all components instantiated and wired together in the top-level RV32I\_Core.v file.

Control Path|| Module | Purpose || ControlUnit.v | The "brain" of the CPU. Decodes the Op\_code to generate all 11 control signals. || ALUControl.v | A helper module that decodes funct3, funct7, and ALU\_op to generate the final 4-bit ALU\_control signal. || BranchLogicUnit.v | A helper module that calculates the branch\_condition\_met signal by checking Z and ALU\_result\[0] against funct3. |Data Path (Execution)| Module | Purpose || ALU.v | The main Arithmetic Logic Unit. Performs all math (add, sub) and logic (and, or, slt) operations. || RegisterFiles.v | Contains the 32 general-purpose 32-bit registers. Supports two asynchronous reads and one synchronous write. x0 is hardwired to zero. || ImmExtender.v | A critical (and complex) module that decodes, reassembles, and sign-extends the immediate values for all I, S, B, U, and J types. || MUXALUSrcA.v | 2-to-1 MUX. Selects the first ALU input (rs1 or PC). || MUXALUSrcB.v | 2-to-1 MUX. Selects the second ALU input (rs2 or Immediate). |Data Path (Memory)| Module | Purpose || InstructionMemory.v | A ROM that holds the program. Reads instruction.mem on initialization. || DataMemory.v | A "smart" RAM that supports lw/lh/lb and sw/sh/sb using a byte\_enable\_mask. || LoadExtender.v | Takes the 32-bit word from DataMemory and correctly selects and sign/zero-extends the byte or half-word for lb, lh, lbu, lhu. || MUXRegisterWrite.v | 4-to-1 MUX. Selects which data is written back to the Register File (ALU\_result, Memory\_data, PC+4, or Immediate\_U\_type). |Data Path (PC Control)| Module | Purpose || ProgramCounter.v | A simple register that holds the address of the current instruction and updates on each clock cycle. || PC4Adder.v | A simple adder that calculates PC + 4. || PCBranchAdder.v | A simple adder that calculates the branch/jump target (PC + Immediate). || MUXPC.v | 3-to-1 MUX. Selects the next PC address from PC+4, BranchTargetAddress, or ALU\_result (for jalr). |



The `ClockDivider.v` module is included to slow down the 100MHz board clock for easier debugging with LEDs.



Hope someone finds this useful!

