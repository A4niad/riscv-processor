// tb/tb_top.v
`timescale 1ns/1ps

module tb_top;

reg clk;
reg reset;

top uut (
    .clk  (clk),
    .reset(reset)
);

// 10ns clock
initial clk = 0;
always #5 clk = ~clk;

task automatic check_reg;
    input [4:0]   reg_num;
    input [31:0]  expected;
    input [127:0] test_name;
    begin
        if (uut.u_regfile.registers[reg_num] !== expected)
            $display("FAIL: %s | x%0d expected %0d, got %0d",
                test_name, reg_num, expected, uut.u_regfile.registers[reg_num]);
        else
            $display("PASS: %s | x%0d = %0d",
                test_name, reg_num, uut.u_regfile.registers[reg_num]);
    end
endtask

initial begin
    $dumpfile("sim/waves_top.vcd");
    $dumpvars(0, tb_top);

    // Reset for 2 cycles
    reset = 1;
    @(posedge clk); #1;
    @(posedge clk); #1;
    reset = 0;

    // Run for 20 cycles — enough to execute all instructions
    repeat(20) @(posedge clk);
    #1;

    // Check register values
    check_reg(1, 32'd5,  "ADDI x1 = 5");
    check_reg(2, 32'd3,  "ADDI x2 = 3");
    check_reg(3, 32'd8,  "ADD  x3 = 8");
    check_reg(4, 32'd2,  "SUB  x4 = 2");
    check_reg(5, 32'd1,  "AND  x5 = 1");
    check_reg(6, 32'd7,  "OR   x6 = 7");
    check_reg(7, 32'd8,  "LW   x7 = 8");
    check_reg(8, 32'd0,  "BEQ skipped x8 = 0");
    check_reg(9, 32'd42, "ADDI x9 = 42");

    // Check data memory
    if (uut.u_dmem.mem[0] === 32'd8)
        $display("PASS: SW mem[0] = 8");
    else
        $display("FAIL: SW mem[0] | expected 8, got %0d", uut.u_dmem.mem[0]);

    $finish;
end

endmodule