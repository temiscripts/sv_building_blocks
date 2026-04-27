# Adders

A collection of adder implementations in SystemVerilog, building from the simplest 1-bit addition up to a cascaded full adder constructed entirely from reusable half adder instances.

## Implementations

**Half Adder**
Adds two 1-bit numbers and produces a sum and a carry. The simplest possible adder, no carry input. Implemented using XOR for sum and AND for carry.

**Full Adder (Direct Logic)**
Adds three 1-bit numbers — two operands and a carry input. This is the chainable building block for multi-bit addition. Implemented directly using XOR and AND/OR logic expressions.

**Full Adder (Cascaded)**
Same behaviour as the direct logic full adder but implemented by instantiating two half adders internally. Demonstrates how complex components are built from simpler reusable ones.

## Ports

| Module | Signal | Direction | Width | Description |
|---|---|---|---|---|
| half_adder | a, b | input | 1-bit | Operands |
| half_adder | sum | output | 1-bit | Result |
| half_adder | carry | output | 1-bit | Overflow bit |
| full_adder | a, b, cin | input | 1-bit | Operands and carry in |
| full_adder | sum | output | 1-bit | Result |
| full_adder | cout | output | 1-bit | Carry out |

## Verification
Each module has a dedicated self-checking testbench that tests all possible input combinations using $monitor to print results automatically on every input change. All outputs were verified against expected truth tables and confirmed correct.