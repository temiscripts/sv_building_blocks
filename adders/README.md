# Adders

A collection of adder implementations in SystemVerilog, progressing from the simplest 1-bit addition up to a carry lookahead adder. Each implementation builds on the previous, demonstrating how hardware arithmetic works at the gate level and how classical optimisation techniques improve performance.

## Implementations

**Half Adder**
Adds two 1-bit numbers and produces a sum and a carry out. No carry input. Implemented using XOR for sum and AND for carry. The simplest possible adder and the foundational building block for everything above it.

**Full Adder (Direct Logic)**
Adds three 1-bit numbers, two operands and a carry input. Chainable across bit positions. Implemented directly using XOR and AND/OR logic expressions derived from the carry out truth table.

**Full Adder (Cascaded)**
Identical behaviour to the direct logic full adder but implemented structurally by instantiating two half adders internally.

**16-bit Ripple Carry Adder**
Chains 16 full adder instances using a generate loop, with each stage's carry out feeding the next stage's carry in. Simple and area efficient but has a critical path that grows linearly with bit width. Each stage must wait for the previous carry to settle before computing its own result.

**4-bit Carry Lookahead Adder (CLA)**
Eliminates the ripple carry delay by computing all carry signals in parallel before any sum is calculated. Uses two precomputed signals per bit position — Generate (G = a AND b) meaning this bit will unconditionally produce a carry, and Propagate (P = a XOR b) meaning this bit will pass an incoming carry through. All carries are resolved in a single logic level from the original inputs, making the CLA significantly faster than ripple carry for the same bit width.

## Ports

| Module | Signal | Direction | Width | Description |
|---|---|---|---|---|
| half_adder | a, b | input | 1-bit | Operands |
| half_adder | sum | output | 1-bit | Result |
| half_adder | carry | output | 1-bit | Overflow bit |
| full_adder | a, b, cin | input | 1-bit | Operands and carry in |
| full_adder | sum | output | 1-bit | Result |
| full_adder | cout | output | 1-bit | Carry out |
| ripple_carry_adder | a, b | input | 16-bit | Operands |
| ripple_carry_adder | cin | input | 1-bit | Carry in |
| ripple_carry_adder | sum | output | 16-bit | Result |
| ripple_carry_adder | cout | output | 1-bit | Carry out |
| carry_lookahead_adder | a, b | input | 4-bit | Operands |
| carry_lookahead_adder | cin | input | 1-bit | Carry in |
| carry_lookahead_adder | sum | output | 4-bit | Result |
| carry_lookahead_adder | cout | output | 1-bit | Carry out |

## Verification
Each module has a dedicated self-checking testbench. Combinational modules use $monitor to print results automatically on every input change. Test cases cover normal addition, overflow conditions, carry propagation across all bit positions, and addition with carry in. All outputs verified against expected values.

## Key Insight
The progression from ripple carry to CLA, simplicity versus performance. Ripple carry is smaller and easier to understand but slow. CLA is faster but requires more gates to compute the lookahead logic. In practice, neither is used alone for wide adders, real designs use tree-based prefix adders such as Kogge-Stone or Brent-Kung which extend the CLA principle hierarchically to minimise both delay and gate count.