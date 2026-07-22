// tb/tb_pc_reg.v
`timescale 1ns/1ps

module tb_pc_reg;

reg        clk;
reg        reset;
reg [31:0] pc_next;
wire [31:0] pc;

pc_reg uut (
    .clk    (clk),
    .reset  (reset),
    .pc_next(pc_next),
    .pc     (pc)
);

    // Clock generator
    initial clk = 0;
    always #5 clk = ~clk;

    task automatic check;
        input [31:0]  expected;
        input [127:0] test_name;
        begin
            if (pc !== expected)
                $display("FAIL: %s | expected %h, got %h", test_name, expected, pc);
            else
                $display("PASS: %s | got %h", test_name, pc);
        end
    endtask

    initial begin
        $dumpfile("sim/waves_pc_reg.vcd");
        $dumpvars(0, tb_pc_reg);

        // Test 1 — reset at startup
        reset = 1; pc_next = 32'h11111111;
        @(posedge clk); #1;
        check(32'h00000000, "Reset at startup");

        // Test 2 — sequential increment
        reset = 0; pc_next = 32'h00000004;
        @(posedge clk); #1;
        check(32'h00000004, "Sequential increment");

        pc_next = pc + 4;
        @(posedge clk); #1;
        check(32'h00000008, "Sequential increment 2");

        // Test 3 — jump to arbitrary address
        pc_next = 32'h00000420;
        @(posedge clk); #1;
        check(32'h00000420, "Jump to address");

        // Test 4 — reset mid-execution
        reset = 1;
        @(posedge clk); #1;
        check(32'h00000000, "Reset mid-execution");

        $finish;
    end

endmodule