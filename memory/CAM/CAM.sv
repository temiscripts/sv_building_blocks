module CAM #(
    parameter DEPTH      = 16,
    parameter DATA_WIDTH = 8
)(
    input   logic                         clk,
    input   logic                         rst,
    input   logic [DATA_WIDTH - 1: 0]     search_key,
    input   logic                         search_enable,
    input   logic [DATA_WIDTH - 1: 0]     write_data,
    input   logic                         write_enable,
    output  logic                         match,
    output  logic [$clog2(DEPTH) - 1: 0]  match_addr,
    output  logic                         match_multiple,
    output  logic                         full
);

    localparam ADDR_WIDTH = $clog2(DEPTH);

    logic [DATA_WIDTH-1:0] cam_data     [0:DEPTH-1];
    logic [DEPTH-1:0] cam_valid;
    logic [DEPTH-1:0]      match_array             ;
    logic [ADDR_WIDTH-1:0] write_ptr               ;

    logic                  match_int;
    logic [ADDR_WIDTH-1:0] match_addr_int;
    logic                  match_multiple_int;

    always_comb begin
        for (int i = 0; i < DEPTH; i++) begin
            match_array[i] = cam_valid[i] && (cam_data[i] == search_key);
        end
    end

// find match
    always_comb begin
        match_addr_int     = '0;
        match_int          = 1'b0;
        match_multiple_int = 1'b0;

        for (int i = 0; i < DEPTH; i++) begin
            if (match_array[i]) begin
                if (!match_int) begin
                    match_addr_int = i[ADDR_WIDTH-1:0];
                    match_int      = 1'b1;
                end else begin
                    match_multiple_int = 1'b1;
                end
            end
        end
    end

// gate match outputs with search_enable
    always_comb begin
        if (search_enable) begin
            match          = match_int;
            match_addr     = match_addr_int;
            match_multiple = match_multiple_int;
        end else begin
            match          = 1'b0;
            match_addr     = '0;
            match_multiple = 1'b0;
        end
    end

// write
    always_ff @(posedge clk) begin
        if (rst) begin
            cam_valid <= '0;
            write_ptr <= '0;
        end
        else if (write_enable) begin
            cam_data[write_ptr]  <= write_data;
            cam_valid[write_ptr] <= 1'b1;
            write_ptr            <= write_ptr + 1;
        end
    end

// isFull
always_comb begin
    full = &cam_valid;
end

endmodule