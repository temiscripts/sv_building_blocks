# sv-building-blocks

A growing collection of reusable hardware components implemented in SystemVerilog. Each module is self-contained, fully verified with a dedicated testbench, and documented. Built during SIWES at ChipMango.

## Structure

| Folder | Description |
|---|---|
| adders | Half adder, full adder, cascaded full adder, 16-bit ripple carry adder, and 4-bit carry lookahead adder |
| alu | 32-bit ALU supporting 8 operations with zero, negative, carry and overflow flags |
| peripherals | Display drivers and interface modules |

## Design Philosophy
Every component in this repo follows the same principles: clean RTL code, explicit port declarations, self-checking testbenches with readable transcript output, and race condition prevention using delays after clock edges where applicable.

## Tools
Simulation: ModelSim Intel FPGA Edition 2020.1
Language: SystemVerilog