module seven_segment_tb();

    logic [3:0] digit;
    logic [6:0] segments;

    seven_segment uut (
        .digit(digit),
        .segments(segments)
    );

    initial begin
        $monitor("Time=%0t | digit=%h | segments=%b | display=%c",
                 $time, digit, segments,
                 (digit < 10) ? (8'(digit) + 8'h30) : (8'(digit) + 8'h37));

        digit = 4'h0; #5;
        digit = 4'h1; #5;
        digit = 4'h2; #5;
        digit = 4'h3; #5;
        digit = 4'h4; #5;
        digit = 4'h5; #5;
        digit = 4'h6; #5;
        digit = 4'h7; #5;
        digit = 4'h8; #5;
        digit = 4'h9; #5;
        digit = 4'hA; #5;
        digit = 4'hB; #5;
        digit = 4'hC; #5;
        digit = 4'hD; #5;
        digit = 4'hE; #5;
        digit = 4'hF; #5;

        $finish;
    end

endmodule