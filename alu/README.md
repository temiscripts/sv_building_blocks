# 32-bit ALU

A 32-bit Arithmetic Logic Unit (ALU) implemented in SystemVerilog. The ALU is the computational core of a processor i.e it performs arithmetic and logical operations on two operands and produces a result alongside status flags describing the outcome. This implementation supports 8 operations selected by a 4-bit opcode defined in a shared package.

## Architecture Highlights

**Parallel computation with late selection:** All 8 operations are computed simultaneously in combinational logic. An always_comb case statement acting as a multiplexer selects the correct result based on the opcode. Computing in parallel and selecting at the end is faster than sequentially deciding which operation to run first.

**Two's complement subtraction:** Subtraction is implemented as A + (~B) + 1 using the same adder as addition. No separate subtractor needed. The carry in is set to 1 to complete the two's complement negation of B.

**33-bit intermediate results for ADD and SUB:** Addition and subtraction results are stored in 33-bit signals to capture the carry out in bit 32. This bit directly feeds the carry flag without any additional logic.

**Package-based opcode definitions:** Opcodes are defined using a SystemVerilog typedef enum inside a dedicated package (alu_pkg.sv). Both the design and testbench import this package, giving access to named constants like ADD, SUB, AND_OP. This is the standard approach for sharing types across multiple files in real chip design projects.

**Separate 1-bit status flags:** Flags are individual 1-bit outputs rather than a bundled bus. More readable, more flexible, and easier for downstream logic to consume.

## Operations

| Opcode | Operation | Description |
|---|---|---|
| 0000 | ADD | A + B |
| 0001 | SUB | A - B via two's complement |
| 0010 | AND_OP | Bitwise AND |
| 0011 | OR_OP | Bitwise OR |
| 0100 | XOR_OP | Bitwise XOR |
| 0101 | NAND_OP | Bitwise NAND |
| 0110 | NOR_OP | Bitwise NOR |
| 0111 | NOT_OP | Bitwise NOT of A |

## Ports

| Signal | Direction | Width | Description |
|---|---|---|---|
| a | input | 32-bit | First operand |
| b | input | 32-bit | Second operand |
| alu_op | input | 4-bit | Operation selector |
| result | output | 32-bit | Operation result |
| zero | output | 1-bit | High when result is zero |
| negative | output | 1-bit | High when result is negative (MSB = 1) |
| carry | output | 1-bit | High when unsigned overflow occurs in ADD or SUB |
| overflow | output | 1-bit | High when signed overflow occurs in ADD or SUB |

## Status Flags

**Zero:** result is all zeros. Used by processors for equality checks. If A - B sets the zero flag, A equals B.

**Negative:** MSB of result is 1. In two's complement this means the result is a negative signed number.

**Carry:** bit 32 of the internal 33-bit result is 1. Indicates unsigned overflow, the result exceeded the 32-bit unsigned range.

**Overflow:** both operands have the same sign but the result has a different sign. Indicates signed overflow — the result exceeded the 32-bit signed range. Carry and overflow are independent and can occur separately.

## Verification
The self-checking testbench covers all 8 operations with meaningful input values. Special cases tested include unsigned carry overflow (0xFFFFFFFF + 1), signed overflow (0x7FFFFFFF + 1), subtraction producing a negative result, and subtraction producing zero to verify the zero flag. All results verified against expected values and confirmed correct.

## Simulation Output
![ALU Waveform](images/waveform.png)