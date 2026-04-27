module half_adder_tb();

logic a ;logic b ;logic sum; logic carry;

half_adder h_adder(
    .a(a),
    .b(b),
    .sum(sum),
    .carry(carry)
);

initial begin
$monitor("Time = %0t | a = %b, b = %b | carry = %b, sum = %b", $time, a, b, carry, sum);
    a=0; b= 0;#3;
    a=0; b= 1;#3;
    a=1; b= 0;#3;
    a=1; b= 1;#3;
    $finish;
end

endmodule