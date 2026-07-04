module CAM_tb;

    localparam DEPTH      = 4;
    localparam DATA_WIDTH = 8;
    localparam ADDR_WIDTH = $clog2(DEPTH);

    logic                     clk;
    logic                     rst;
    logic [DATA_WIDTH-1:0]    search_key;
    logic                     search_enable;
    logic [DATA_WIDTH-1:0]    write_data;
    logic                     write_enable;
    logic                     match;
    logic [ADDR_WIDTH-1:0]    match_addr;
    logic                     match_multiple;
    logic                     full;

    CAM #(
        .DEPTH(DEPTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) cam_inst (
        .clk(clk),
        .rst(rst),
        .search_key(search_key),
        .search_enable(search_enable),
        .write_data(write_data),
        .write_enable(write_enable),
        .match(match),
        .match_addr(match_addr),
        .match_multiple(match_multiple),
        .full(full)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    int fail_count = 0;

    task write_cam(input logic [DATA_WIDTH-1:0] data);
        write_data   = data;
        write_enable = 1;
        @(posedge clk); #1;
        write_enable = 0;
    endtask

    task search_cam(
        input  logic [DATA_WIDTH-1:0] key,
        input  logic                  enable,
        input  logic                  exp_match,
        input  logic [ADDR_WIDTH-1:0] exp_addr,
        input  logic                  exp_multiple
    );
        search_key    = key;
        search_enable = enable;
        #1;
        if (match !== exp_match || match_addr !== exp_addr || match_multiple !== exp_multiple) begin
            $display("TEST FAILED");
            $display("key=%h enable=%b | match=%b addr=%0d multiple=%b | expected match=%b addr=%0d multiple=%b",
                      key, enable, match, match_addr, match_multiple, exp_match, exp_addr, exp_multiple);
            fail_count++;
        end else begin
            $display("PASS: key=%h enable=%b | match=%b addr=%0d multiple=%b",
                      key, enable, match, match_addr, match_multiple);
        end
        search_enable = 0;
    endtask

    initial begin

        // ── Part 1: core functionality tests ──
        // Start fresh, known state
        rst = 1; write_enable = 0; search_enable = 0;
        write_data = '0; search_key = '0;
        @(posedge clk); #1;
        rst = 0;

        // Fill all 4 rows sequentially
        // After these 4 writes:
        // row 0 = AA, row 1 = BB, row 2 = CC, row 3 = DD
        // write_ptr wraps back to 0
        write_cam(8'hAA);
        write_cam(8'hBB);
        write_cam(8'hCC);
        write_cam(8'hDD);

        // CAM is full — all 4 rows have valid data
        if (full !== 1'b1) begin
            $display("TEST FAILED: full should be 1 after 4 writes into DEPTH=4");
            fail_count++;
        end else begin
            $display("PASS: full correctly asserted after filling all rows");
        end

        // Search for BB — exists at row 1, no duplicate
        search_cam(8'hBB, 1, 1'b1, 2'd1, 1'b0);

        // Search for FF — never written, should not be found
        search_cam(8'hFF, 1, 1'b0, 2'd0, 1'b0);

        // Search for BB with search_enable=0
        // Even though BB genuinely exists at row 1, the gate block
        // forces all outputs to 0 when search_enable is low
        // This verifies the search_enable gating actually works
        search_cam(8'hBB, 0, 1'b0, 2'd0, 1'b0);

        // Write EE — write_ptr is currently at 0 (wrapped after DD)
        // So EE overwrites row 0, evicting AA
        // State after: row 0 = EE, row 1 = BB, row 2 = CC, row 3 = DD
        // write_ptr advances to 1
        write_cam(8'hEE);

        // AA was at row 0, now evicted — should not be found
        search_cam(8'hAA, 1, 1'b0, 2'd0, 1'b0);

        // EE now at row 0 — should be found there
        search_cam(8'hEE, 1, 1'b1, 2'd0, 1'b0);

        // BB, CC, DD untouched — verify each still at original address
        search_cam(8'hBB, 1, 1'b1, 2'd1, 1'b0);
        search_cam(8'hCC, 1, 1'b1, 2'd2, 1'b0);
        search_cam(8'hDD, 1, 1'b1, 2'd3, 1'b0);

        // ── Part 2: multiple match test ──
        // The previous sequence left write_ptr at 1, which means
        // any new write would immediately overwrite BB at row 1 —
        // so we can never safely create a duplicate WITHOUT disturbing
        // the existing BB first.
        // The clean solution: reset and build a controlled scenario
        // from scratch specifically designed to place BB in two rows
        // that are never overwritten before we search.
        rst = 1;
        @(posedge clk); #1;
        rst = 0;

        // Write BB into row 0 — write_ptr advances to 1
        write_cam(8'hBB);

        // Write a throwaway value into row 1 — write_ptr advances to 2
        // This is NOT BB so it doesn't interfere with the search
        write_cam(8'h11);

        // Write BB again into row 2 — write_ptr advances to 3
        // Now BB exists at BOTH row 0 AND row 2
        write_cam(8'hBB);

        // Search for BB:
        // match_array will have bits 0 and 2 both set
        // Priority encoder picks lowest index = 0
        // match_multiple fires because more than one row matched
        // Expected: match=1, match_addr=0, match_multiple=1
        search_cam(8'hBB, 1, 1'b1, 2'd0, 1'b1);

        if (fail_count == 0)
            $display("TEST PASSED");
        else
            $display("%0d TEST(S) FAILED", fail_count);

        $finish;
    end

endmodule