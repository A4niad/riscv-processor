// tb/tb_imm_gen.v
`timescale 1ns/1ps

module tb_imm_gen;

reg  [31:0] inst;
wire [31:0] imm_out;

imm_gen uut(
    .inst(inst),
    .imm_out(imm_out)
);

task automatic check;
    input [31:0] expected;
    input [63:0] test_name;
    begin
        if (imm_out !== expected)
            $display("FAIL: %s | expected %h, got %h", test_name, expected, imm_out);
        else
            $display("PASS: %s | got %h", test_name, imm_out);
    end
endtask

initial begin
    $dumpfile("sim/waves_imm_gen.vcd");
    $dumpvars(0, tb_imm_gen);
    $display("Starting tests...");

    inst = 32'h00510093; #10; check(32'h00000005, "I-Type Positive");
    inst = 32'hFFB10093; #10; check(32'hFFFFFFFB, "I-Type Negative");
    inst = 32'h00812183; #10; check(32'h00000008, "I-Type LW");
    inst = 32'h00312423; #10; check(32'h00000008, "S-Type Positive");
    inst = 32'hFE312C23; #10; check(32'hFFFFFFF8, "S-Type Negative");
    inst = 32'h00208463; #10; check(32'h00000008, "B-Type");
    inst = 32'h123450B7; #10; check(32'h12345000, "U-Type");
    inst = 32'h008000EF; #10; check(32'h00000008, "J-Type");
    inst = 32'h003100B3; #10; check(32'h00000000, "R-Type");
end

endmodule
