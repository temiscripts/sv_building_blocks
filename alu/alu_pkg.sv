package alu_pkg;
    typedef enum logic [3:0] {
        ADD     = 4'b0000,
        SUB     = 4'b0001,
        AND_OP  = 4'b0010,
        OR_OP   = 4'b0011,
        XOR_OP  = 4'b0100,
        NAND_OP = 4'b0101,
        NOR_OP  = 4'b0110,
        NOT_OP  = 4'b0111,
        MUL     = 4'b1000
    } alu_op_t;
endpackage