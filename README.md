# Microprocessor 

## Overview

The custom microprocessor is designed to find the closest and farthest hamming pairs from a list of signed 32 bit integers provided by the testbench. The processor features a simple RISC architecture.

## Machine Specifications

### Instruction Set Architecture (ISA)

- **Instruction Width:** 9 bits
- **Data Path Width:** 8 bits
- **Instruction Memory:** Up to 2^12 entries, but typically limited to 2^10 for this project.
- **Data Memory:** 256 bytes (2^8 entries)
- **Registers:** 8 general-purpose 8-bit registers

### Instruction Formats

- **Opcode (3 bits):** Specifies the operation.
- **Operand1 (3 bits):** First operand, usually a register.
- **Operand2 (3 bits):** Second operand, which can be a register or an immediate value.
