# Seven Segment Display Decoder

A combinational SystemVerilog module that decodes a 4-bit hex digit (0x0 to 0xF) into a 7-bit segment pattern for driving a seven segment LED display. No clock required — output updates instantly when input changes.

## Architecture Highlights

**Pure combinational logic:** Implemented as an always_comb case statement mapping each hex digit to its corresponding segment pattern. No registers, no clock, no state. Input to output in a single logic level.

**Active high encoding:** A 1 in the output means the segment is on. The 7-bit output maps to segments in the order {g,f,e,d,c,b,a} where bit 6 (MSB) is segment g and bit 0 (LSB) is segment a.

**Full hex support:** Covers all 16 values 0x0 through 0xF. A default case drives all segments off for any undefined input.

## Segment Layout

aaa
f b
f b
ggg
e c
e c
ddd

## Ports

| Signal | Direction | Width | Description |
|---|---|---|---|
| digit | input | 4-bit | Hex digit to display (0x0 to 0xF) |
| segments | output | 7-bit | Segment pattern {g,f,e,d,c,b,a} |

## Segment Encoding

| Digit | segments (GFEDCBA) | Segments On |
|---|---|---|
| 0 | 0111111 | a,b,c,d,e,f |
| 1 | 0000110 | b,c |
| 2 | 1011011 | a,b,d,e,g |
| 3 | 1001111 | a,b,c,d,g |
| 4 | 1100110 | b,c,f,g |
| 5 | 1101101 | a,c,d,f,g |
| 6 | 1111101 | a,c,d,e,f,g |
| 7 | 0000111 | a,b,c |
| 8 | 1111111 | all |
| 9 | 1101111 | a,b,c,d,f,g |
| A | 1110111 | a,b,c,e,f,g |
| B | 1111100 | c,d,e,f,g |
| C | 0111001 | a,d,e,f |
| D | 1011110 | b,c,d,e,g |
| E | 1111001 | a,d,e,f,g |
| F | 1110001 | a,e,f,g |

## Verification
The testbench cycles through all 16 hex values using $monitor to print the digit, raw segment pattern in binary, and ASCII character for easy visual verification.

## Expected Results

| Digit | Expected segments (GFEDCBA) |
|---|---|
| 0x0 | 0111111 |
| 0x1 | 0000110 |
| 0x2 | 1011011 |
| 0x3 | 1001111 |
| 0x4 | 1100110 |
| 0x5 | 1101101 |
| 0x6 | 1111101 |
| 0x7 | 0000111 |
| 0x8 | 1111111 |
| 0x9 | 1101111 |
| 0xA | 1110111 |
| 0xB | 1111100 |
| 0xC | 0111001 |
| 0xD | 1011110 |
| 0xE | 1111001 |
| 0xF | 1110001 |