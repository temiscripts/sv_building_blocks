module MAC_tb();

    logic        clk;
    logic        rst;
    logic        valid_in;
    logic        clear;
    logic [7:0]  a;
    logic [7:0]  b;
    logic        valid_out;
    logic [31:0] accumulator;

    MAC uut (
        .clk(clk),
        .rst(rst),
        .valid_in(valid_in),
        .clear(clear),
        .a(a),
        .b(b),
        .valid_out(valid_out),
        .accumulator(accumulator)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $monitor("Time=%0t | valid_in=%b valid_out=%b | a=%0d b=%0d | acc=%0d",
                 $time, valid_in, valid_out, a, b, accumulator);

        rst = 1; valid_in = 0; clear = 0; a = 0; b = 0;
        @(posedge clk); #1;
        @(posedge clk); #1;
        rst = 0;

        a = 3;  b = 4;  valid_in = 1;
        @(posedge clk); #1;
        a = 2;  b = 5;
        @(posedge clk); #1;
        a = 6;  b = 7;
        @(posedge clk); #1;

        valid_in = 0; a = 0; b = 0;
        @(posedge clk); #1;
        @(posedge clk); #1;

        a = 3; b = 3; valid_in = 1;
        @(posedge clk); #1;
        valid_in = 0; a = 0; b = 0;

        @(posedge clk); #1;
        @(posedge clk); #1;

        clear = 1;
        @(posedge clk); #1;
        clear = 0;
        $display("After clear — accumulator should be 0: %0d", accumulator);

        a = 5; b = 5; valid_in = 1;
        @(posedge clk); #1;
        valid_in = 0; a = 0; b = 0;
        @(posedge clk); #1;
        @(posedge clk); #1;

        $finish;
    end

endmodule