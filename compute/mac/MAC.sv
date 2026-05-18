module MAC(
    input  logic [7:0]  a,
    input  logic [7:0]  b,
    input  logic        clk,
    input  logic        rst,
    input  logic        valid_in,
    input  logic        clear,
    output logic        valid_out,
    output logic [31:0] accumulator
);

    logic [15:0] temp_result;
    logic        valid_pipe;

    always_ff @(posedge clk) begin
        if(rst) begin
            temp_result <= 0;
            valid_pipe  <= 0;
            valid_out   <= 0;
            accumulator <= 0;
        end else if(clear) begin
            accumulator <= 0;
            valid_pipe  <= 0;
            valid_out   <= 0;
        end else begin
            temp_result <= a * b;
            valid_pipe  <= valid_in;

            valid_out <= valid_pipe;
            if(valid_pipe) begin
                accumulator <= accumulator + temp_result;
            end
        end
    end

endmodule