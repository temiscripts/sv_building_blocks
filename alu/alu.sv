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

logic [32:0] add_result;
logic [32:0] sub_result;
logic [31:0] and_result;
logic [31:0] or_result;
logic [31:0] xor_result;
logic [31:0] nand_result;
logic [31:0] nor_result;
logic [31:0] not_result;

assign and_result = a & b;
assign or_result = a | b;
assign xor_result = a ^ b;
assign nand_result = ~(a&b);
assign nor_result = ~(a | b);
assign not_result = ~a;

assign add_result = {1'b0, a} + {1'b0, b};
assign sub_result = {1'b0, a} + {1'b0, ~b} + 1;

always_comb begin
    case (alu_op)
        ADD :     result = add_result[31:0];
        SUB :     result = sub_result[31:0];
        AND_OP  :  result = and_result;
        OR_OP   :   result = or_result;
        NAND_OP : result = nand_result;
        XOR_OP  : result = xor_result;
        NOR_OP  : result = nor_result;
        NOT_OP  : result = not_result;
        default: result = 32'b0;
    endcase
end

endmodule