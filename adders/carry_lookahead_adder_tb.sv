module carry_lookahead_adder_tb();

    logic [3:0] a;
    logic [3:0] b;
    logic       cin;
    logic [3:0] sum;
    logic       cout;

    carry_lookahead_adder cla(
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    initial begin
        $monitor("Time=%0t | a=%b, b=%b, cin=%b | sum=%b, cout=%b", $time, a, b, cin, sum, cout);

        a = 4'b0000; b = 4'b0000; cin = 0; #5;
        
        a = 4'b0011; b = 4'b0101; cin = 0; #5;
        
        a = 4'b1111; b = 4'b0001; cin = 0; #5;
        
        a = 4'b1010; b = 4'b0101; cin = 1; #5;

        $finish;
    end

endmodule