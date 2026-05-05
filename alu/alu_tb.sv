import alu_pkg::*;
module alu_tb();

logic [31:0] a;
logic [31:0] b;
alu_op_t alu_op;
logic        zero;
logic        negative;
logic        carry;
logic        overflow;
logic [31:0] result;

alu alu1(
    .a(a),
    .b(b),
    .alu_op(alu_op),
    .zero(zero),
    .negative(negative),
    .carry(carry),
    .overflow(overflow),
    .result(result)
);

initial begin

    $monitor("Time=%0t | op=%b | a=%h b=%h | result=%h | Z=%b N=%b C=%b V=%b",
             $time, alu_op, a, b, result, zero, negative, carry, overflow);

    // ADD: 5 + 10 = 15
    a = 32'h00000005; b = 32'h0000000A; alu_op = ADD; #5;

    // ADD overflow: max positive + 1 = negative
    a = 32'h7FFFFFFF; b = 32'h00000001; alu_op = ADD; #5;

    // ADD carry: max unsigned + 1
    a = 32'hFFFFFFFF; b = 32'h00000001; alu_op = ADD; #5;

    // SUB: 10 - 5 = 5
    a = 32'h0000000A; b = 32'h00000005; alu_op = SUB; #5;

    // SUB: 5 - 10 = negative
    a = 32'h00000005; b = 32'h0000000A; alu_op = SUB; #5;

    // AND
    a = 32'hFF00FF00; b = 32'h0F0F0F0F; alu_op = AND_OP; #5;

    // OR
    a = 32'hFF00FF00; b = 32'h0F0F0F0F; alu_op = OR_OP; #5;

    // XOR
    a = 32'hFF00FF00; b = 32'h0F0F0F0F; alu_op = XOR_OP; #5;

    // NAND
    a = 32'hFF00FF00; b = 32'h0F0F0F0F; alu_op = NAND_OP; #5;

    // NOR
    a = 32'hFF00FF00; b = 32'h0F0F0F0F; alu_op = NOR_OP; #5;

    // NOT a
    a = 32'hFF00FF00; b = 32'h00000000; alu_op = NOT_OP; #5;

    // Zero flag: 5 - 5 = 0
    a = 32'h00000005; b = 32'h00000005; alu_op = SUB; #5;

    $finish;
end

endmodule