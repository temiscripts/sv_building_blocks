module ripple_carry_adder (
    input  logic [15:0] a,
    input  logic [15:0] b,
    input  logic        cin,
    output logic [15:0] sum,
    output logic        cout
);

    logic [16:0] carry_chain;

    assign carry_chain[0] = cin;

    assign cout = carry_chain[16];

    genvar i;
    generate
        for (i = 0; i < 16; i++) begin : adder_loop
            full_adder fa (
                .a(a[i]),                  
                .b(b[i]),                     
                .cin(carry_chain[i]),         
                .sum(sum[i]),                 
                .cout(carry_chain[i+1])       
            );
        end
    endgenerate

endmodule

