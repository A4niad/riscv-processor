// tb/tb_alu.v
`include "src/defines.v"
`timescale 1ns/1ps

module tb_alu;

    reg [31:0] a;
    reg [31:0] b;
    reg [3:0] alu_op;

    wire [31:0] result;
    wire zero;

    alu uut (
        .a(a),
        .b(b),
        .alu_op(alu_op),
        .result(result),
        .zero(zero)
    );

    task automatic check;
        input [31:0] expected;
        input [63:0] test_name;
        begin
            if (result !== expected) begin
                $display("Test %s failed: expected %h, got %h", test_name, expected, result);
            end else begin
                $display("Test %s passed: got %h", test_name, result);
            end
        end
    endtask

    initial begin

        $dumpfile("sim/waves.vcd");
        $dumpvars(0, tb_alu);

        // Test ALU_ADD
        a = 32'h00000005; b = 32'h00000003;
        alu_op = `ALU_ADD;
        #10; check(32'h00000008, "ALU_ADD");

        // Test ALU_SUB
        a = 32'h00000005; b = 32'h00000003;
        alu_op = `ALU_SUB;
        #10; check(32'h00000002, "ALU_SUB");

        // Test ALU_AND
        a = 32'h00000005; b = 32'h00000003;
        alu_op = `ALU_AND;
        #10; check(32'h00000001, "ALU_AND");

        // Test ALU_OR
        a = 32'h00000005; b = 32'h00000003;
        alu_op = `ALU_OR;
        #10; check(32'h00000007, "ALU_OR");

        // Test ALU_XOR
        a = 32'h00000005; b = 32'h00000003;
        alu_op = `ALU_XOR;
        #10; check(32'h00000006, "ALU_XOR");

        // Test ALU_SLL
        a = 32'h00000001; b = 32'h00000002;
        alu_op = `ALU_SLL;
        #10; check(32'h00000004, "ALU_SLL");

        // Test ALU_SRL
        a = 32'h00000004; b = 32'h00000002;
        alu_op = `ALU_SRL;
        #10; check(32'h00000001, "ALU_SRL");

        // Test ALU_SRA
        a = 32'hFFFFFFFC; b = 32'h00000002;
        alu_op = `ALU_SRA;
        #10; check(32'hFFFFFFFF, "ALU_SRA");

        // Test ALU_SLT
        a = 32'h00000003; b = 32'h00000005;
        alu_op = `ALU_SLT;
        #10; check(32'h00000001, "ALU_SLT");

        // Test ALU_SLTU
        a = 32'h00000003; b = 32'h00000005;
        alu_op = `ALU_SLTU;
        #10; check(32'h00000001, "ALU_SLTU");

        // Test ALU_SLT with negative numbers
        a = 32'hFFFFFFFE; b = 32'h00000001;
        alu_op = `ALU_SLT;
        #10; check(32'h00000001, "ALU_SLT_NEG");

        // Test ALU_SLTU with negative numbers
        a = 32'hFFFFFFFE; b = 32'h00000001;
        alu_op = `ALU_SLTU;
        #10; check(32'h00000000, "ALU_SLTU_NEG");

        $finish;
    end
endmodule
