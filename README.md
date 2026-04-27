# sv-building-blocks

A growing collection of reusable hardware components implemented in SystemVerilog. Each module is self-contained, fully verified with a dedicated testbench, and documented. 

## Structure

| Folder | Description |
|---|---|
| adders | Half adder, full adder, and cascaded full adder implementations |

## Design Philosophy
Every component in this repo follows the same principles: clean RTL code, explicit port declarations, self-checking testbenches with readable transcript output, and race condition prevention.

## Tools
Simulation: ModelSim Intel FPGA Edition 2020.1
Language: SystemVerilog