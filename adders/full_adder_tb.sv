module full_adder_tb();

logic a ;logic b ;logic cin ;logic sum; logic cout;

full_adder f_adder(
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum),
    .cout(cout)
);

initial begin
$monitor("Time = %0t | a = %b, b = %b , cin = %b | sum = %b, cout = %b",  $time, a, b,cin, sum, cout);
    a=0; b= 0;cin = 0;#3;
    a=0; b= 0;cin = 1;#3;
    a=0; b= 1;cin = 0;#3;
    a=0; b= 1;cin = 1;#3;
    a=1; b= 0;cin = 0;#3;
    a=1; b= 0;cin = 1;#3;
    a=1; b= 1;cin = 0;#3;
    a=1; b= 1;cin = 1;#3;
    $finish;
end

endmodule