module ripple_carry_adder_tb();

    logic [15:0] a; 
    logic [15:0] b; 
    logic        cin;
    logic [15:0] sum; 
    logic        cout;

    ripple_carry_adder rca(
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    initial begin

        $monitor("Time=%0t | a=%h, b=%h, cin=%b | sum=%h, cout=%b", $time, a, b, cin, sum, cout);

        // all zeros
        a = 16'h0000; b = 16'h0000; cin = 0; #5;
        
        // normal addition 
        a = 16'h0005; b = 16'h000A; cin = 0; #5;
        
        // ripple effect, this forces a carry to ripple all the way from bit 0 to bit 15
        a = 16'hFFFF; b = 16'h0001; cin = 0; #5;
        
        // addition with a Carry In
        a = 16'h0010; b = 16'h0020; cin = 1; #5;

        $finish;
    end

endmodule