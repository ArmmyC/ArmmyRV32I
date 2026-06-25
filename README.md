<!-- prettier-ignore -->
<div align="center">

# ArmmyRV32I

*A modular single-cycle RV32I processor core written in Verilog.*

![Verilog](https://img.shields.io/badge/Verilog-RTL-8a2be2?style=flat-square)
![RISC-V](https://img.shields.io/badge/RISC--V-RV32I-283272?style=flat-square)
![Architecture](https://img.shields.io/badge/Architecture-single--cycle-0f766e?style=flat-square)
![Simulation](https://img.shields.io/badge/Simulation-VCD-475569?style=flat-square)

[Overview](#overview) • [Features](#features) • [Get started](#get-started) • [Supported instructions](#supported-instructions) • [Project structure](#project-structure) • [Notes](#implementation-notes)

</div>

ArmmyRV32I is a 32-bit RISC-V processor core built for learning, simulation, and FPGA experimentation. It implements the main integer arithmetic, load/store, branch, jump, and upper-immediate instructions from the RV32I base ISA using a readable, module-by-module Verilog design.

> [!NOTE]
> This is an educational processor core, not a production CPU. It focuses on a clear single-cycle datapath and inspectable simulation behavior.

## Overview

The processor uses a Harvard-style organization with separate instruction and data memories. [`src/RV32I_Core.v`](./src/RV32I_Core.v) wires together the program counter, instruction memory, decoder/control path, register file, ALU, immediate generation, branch logic, data memory, load extension, and write-back selection.

```verilog
module RV32I_Core(
    input clk_in,
    input reset
);
```

The top-level clock enters through `clk_in`. [`ClockDivider`](./src/ClockDivider.v) is configured for a 100 MHz input clock and generates a 1 MHz internal processor clock.

![RV32I single-cycle datapath](./pic/RV32IDataPathByArmmy.drawio.png)

## Features

- **Single-cycle RV32I datapath** with modular RTL blocks.
- **32 general-purpose registers** with `x0` hardwired to zero.
- **Separate instruction and data memories**, each addressed as 1,024 32-bit words.
- **Byte, half-word, and word memory operations** for signed and unsigned loads and stores.
- **Branch and jump support** for conditional branches, `jal`, and `jalr`.
- **Upper immediate support** through `lui` and `auipc`.
- **Waveform-oriented testbenches** for the ALU, instruction memory, and integrated core.

> [!IMPORTANT]
> System instructions, fence instructions, exceptions, interrupts, privilege modes, and CSRs are not implemented.

## Get started

### Prerequisites

Use an RTL simulator or FPGA toolchain that supports Verilog, `$readmemh`, and VCD waveform output. The project layout works well with Vivado-style RTL projects, and the testbenches can also be run with tools such as Icarus Verilog.

Common options:

- AMD Vivado for FPGA project setup and simulation.
- Icarus Verilog plus GTKWave for lightweight local simulation.

### Configure program memory

The instruction memory is initialized from [`src/instruction.mem`](./src/instruction.mem). The file contains one 32-bit hexadecimal instruction per line.

The bundled program loads two constants, adds them, stores the result at data-memory address `0`, then loops forever:

```text
addi x1, x0, 5
addi x2, x0, 10
add  x3, x1, x2
sw   x3, 0(x0)
jal  x0, 0x10
```

> [!WARNING]
> [`src/InstructionMemory.v`](./src/InstructionMemory.v) currently uses the original author's absolute Windows path in `$readmemh`. Before simulating on your machine, replace it with a path that resolves locally, for example `src/instruction.mem` or an absolute path in your workspace.

### Run a simulation

With Vivado:

1. Add all `.v` files in `src/` as design sources.
2. Add `src/instruction.mem` as a memory initialization file.
3. Add one file from `testbench/` as a simulation source.
4. Select the matching testbench module as the simulation top.
5. Run simulation and inspect the generated `.vcd` waveform.

With Icarus Verilog, create a build directory and compile a testbench with the required RTL sources:

```bash
mkdir -p build

# ALU smoke simulation
iverilog -g2012 -o build/tb_ALU src/ALU.v testbench/tb_ALU.v
vvp build/tb_ALU

# Full core simulation
iverilog -g2012 -o build/tb_RV32I_Core src/*.v testbench/tb_RV32I_Core.v
vvp build/tb_RV32I_Core
```

Open the generated VCD file with your waveform viewer.

> [!TIP]
> For the full-core testbench, the input clock period is 10 ns. That matches the divider's expected 100 MHz input clock.

## Supported instructions

| Category | Instructions |
| --- | --- |
| Register-register | `add`, `sub`, `sll`, `slt`, `sltu`, `xor`, `srl`, `sra`, `or`, `and` |
| Register-immediate | `addi`, `slli`, `slti`, `sltiu`, `xori`, `srli`, `srai`, `ori`, `andi` |
| Loads | `lb`, `lh`, `lw`, `lbu`, `lhu` |
| Stores | `sb`, `sh`, `sw` |
| Branches | `beq`, `bne`, `blt`, `bge`, `bltu`, `bgeu` |
| Jumps | `jal`, `jalr` |
| Upper immediates | `lui`, `auipc` |

## Architecture

```text
InstructionMemory ──> ControlUnit ──┐
        │                            │
        v                            v
ProgramCounter ──> RegisterFiles ──> ALU ──> DataMemory
        │              │              │          │
        └─ PC adders <-┴─ immediates <-┴── load/write-back muxes
```

Key modules:

| Module | Purpose |
| --- | --- |
| [`RV32I_Core`](./src/RV32I_Core.v) | Top-level processor integration |
| [`ControlUnit`](./src/ControlUnit.v) | Opcode decode and datapath control signals |
| [`ALUControl`](./src/ALUControl.v) | `funct3`/`funct7` to ALU operation decode |
| [`ALU`](./src/ALU.v) | Arithmetic, logical, shift, and comparison operations |
| [`RegisterFiles`](./src/RegisterFiles.v) | 32-entry register file with protected `x0` |
| [`InstructionMemory`](./src/InstructionMemory.v) | `$readmemh`-initialized program memory |
| [`DataMemory`](./src/DataMemory.v) | Data RAM with byte-enable store handling |
| [`ImmExtender`](./src/ImmExtender.v) | I, S, B, U, and J immediate generation |
| [`LoadExtender`](./src/LoadExtender.v) | Signed and unsigned byte/half-word load extension |
| [`BranchLogicUnit`](./src/BranchLogicUnit.v) | Branch condition evaluation |
| [`ClockDivider`](./src/ClockDivider.v) | 100 MHz to 1 MHz clock division |

## Testbenches

| Top module | File | What it checks |
| --- | --- | --- |
| `tb_ALU` | [`testbench/tb_ALU.v`](./testbench/tb_ALU.v) | Steps through ALU control values and emits `waveform.vcd` |
| `tb_InstructionMemory` | [`testbench/tb_InstructionMemory.v`](./testbench/tb_InstructionMemory.v) | Reads sequential instruction addresses and emits `InstructionMemory.vcd` |
| `tb_RV32I_Core` | [`testbench/tb_RV32I_Core.v`](./testbench/tb_RV32I_Core.v) | Resets and runs the integrated processor, emitting `waveform.vcd` |

These are stimulus and waveform testbenches. They are useful for inspection, but they do not currently include self-checking assertions.

## Project structure

```text
.
├── pic/
│   └── RV32IDataPathByArmmy.drawio.png
├── src/
│   ├── RV32I_Core.v
│   ├── ControlUnit.v
│   ├── ALU.v
│   ├── ALUControl.v
│   ├── RegisterFiles.v
│   ├── InstructionMemory.v
│   ├── DataMemory.v
│   ├── ImmExtender.v
│   ├── LoadExtender.v
│   ├── BranchLogicUnit.v
│   ├── ClockDivider.v
│   ├── MUX*.v
│   ├── PC*.v
│   └── instruction.mem
└── testbench/
    ├── tb_ALU.v
    ├── tb_InstructionMemory.v
    └── tb_RV32I_Core.v
```

## Implementation notes

- The core uses separate 1,024-word instruction and data memories. Address bits `[11:2]` select a word.
- Register reads are asynchronous. Register and data-memory writes are synchronous.
- The design does not currently trap unsupported opcodes or misaligned memory accesses.
- `jalr` selects the raw ALU result as the next PC; it does not explicitly clear address bit `0`.
- The top-level core exposes only `clk_in` and `reset`; there is no external memory bus, debug interface, or memory-mapped I/O.
