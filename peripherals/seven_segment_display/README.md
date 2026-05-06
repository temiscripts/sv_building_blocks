# Seven Segment Display Decoder

A combinational SystemVerilog module that decodes a 4-bit hex digit (0x0 to 0xF) into a 7-bit segment pattern for driving a seven segment LED display. No clock required — output updates instantly when input changes.

## Architecture Highlights

**Pure combinational logic:** Implemented as an always_comb case statement mapping each hex digit to its corresponding segment pattern. No registers, no clock, no state. Input to output in a single logic level.

**Active high encoding:** A 1 in the output means the segment is on. The 7-bit output maps to segments in the order {a, b, c, d, e, f, g} where bit 6 (MSB) is segment a and bit 0 (LSB) is segment g.

**Full hex support:** Covers all 16 values 0x0 through 0xF, not just decimal digits 0-9. A default case drives all segments off for any undefined input.

## Segment Layout
aaa
f   b
f   b
ggg
e   c
e   c
ddd

## Ports

| Signal | Direction | Width | Description |
|---|---|---|---|
| digit | input | 4-bit | Hex digit to display (0x0 to 0xF) |
| segments | output | 7-bit | Segment pattern {a,b,c,d,e,f,g} |

## Segment Encoding

| Digit | segments | Segments On |
|---|---|---|
| 0 | 1111110 | a,b,c,d,e,f |
| 1 | 0110000 | b,c |
| 2 | 1101101 | a,b,d,e,g |
| 3 | 1111001 | a,b,c,d,g |
| 4 | 0110011 | b,c,f,g |
| 5 | 1011011 | a,c,d,f,g |
| 6 | 1011111 | a,c,d,e,f,g |
| 7 | 1110000 | a,b,c |
| 8 | 1111111 | all |
| 9 | 1111011 | a,b,c,d,f,g |
| A | 1110111 | a,b,c,e,f,g |
| B | 0011111 | c,d,e,f,g |
| C | 1001110 | a,d,e,f |
| D | 0111101 | b,c,d,e,g |
| E | 1001111 | a,d,e,f,g |
| F | 1000111 | a,e,f,g |

## Verification
The testbench cycles through all 16 hex values and uses $monitor to print the digit, raw segment pattern in binary, and the ASCII character representation for easy visual verification.

## Expected Results

| Digit | Expected segments |
|---|---|
| 0x0 | 1111110 |
| 0x1 | 0110000 |
| 0x2 | 1101101 |
| 0x3 | 1111001 |
| 0x4 | 0110011 |
| 0x5 | 1011011 |
| 0x6 | 1011111 |
| 0x7 | 1110000 |
| 0x8 | 1111111 |
| 0x9 | 1111011 |
| 0xA | 1110111 |
| 0xB | 0011111 |
| 0xC | 1001110 |
| 0xD | 0111101 |
| 0xE | 1001111 |
| 0xF | 1000111 |