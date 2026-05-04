typedef enum logic [3:0] {
    ADD     = 4'b0000,
    SUB     = 4'b0001,
    AND_OP  = 4'b0010,
    OR_OP   = 4'b0011,
    XOR_OP  = 4'b0100,
    NAND_OP = 4'b0101,
    NOR_OP  = 4'b0110,
    NOT_OP  = 4'b0111
} alu_op_t;

module alu_32_bit(
input logic [31:0] a,
input logic [31:0] b,
input alu_op_t alu_op ,
output logic zero,
output logic negative,
output logic carry,
output logic overflow,
output logic [31:0] result
);




endmodule