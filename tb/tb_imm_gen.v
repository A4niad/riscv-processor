// tb?tb_imm_gen.v
`include "src/imm_gen.v"
`timescale 1ps/1ns

module tb_imm_gen;

    reg [31:0] inst;

    wire imm_gen;

    imm_gen uut(
        .inst(inst),
        .imm_gen(imm_gen)
    );

    task check;
        input [31:0] expected;
        input [63:0] test_name;
        begin
            if (imm_gen !== expected) begin
                $display("Test %s failed: expected %h, got %h", test_name, expected, result);
            end else begin
                $display("Test %s passed: got %h", test_name, result);
            end
        end
    endtask

    initial begin
        $dumpfile("sim/waves.vcd");
        $dumpvars(0, tb_alu);

        // Test I-type Positive
        inst = 32'h00510093;
        #10 check(32'h00000005, "I-Type Positive");

        inst = 32'hFFB10093;
        #10 check(32'hFFFFFFFB, "I-Type Negative");

        inst = 32'h00812183;
        #10 check(32'h00000008, "I-Type LW");

        inst = 32'h00312423;
        #10 check(32'h00000008, "S-Type Positive");

        inst = 32'hFE312C23;
        #10 check(32'hFFFFFFF8, "S-Type Negative");

    end

endmodule
