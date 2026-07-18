// tb/tb_control.v
`timescale 1ns/1ps

module tb_control;

reg  [6:0] opcode;
wire       reg_write, alu_src, mem_write, mem_read, mem_to_reg, branch, jump;
wire [1:0] alu_op;

control uut (
    .opcode    (opcode),
    .reg_write (reg_write),
    .alu_src   (alu_src),
    .mem_write (mem_write),
    .mem_read  (mem_read),
    .mem_to_reg(mem_to_reg),
    .branch    (branch),
    .jump      (jump),
    .alu_op    (alu_op)
);

task automatic check;
    input [8:0]   expected;
    input [127:0] test_name;
    begin
        if ({reg_write, alu_src, mem_write, mem_read, mem_to_reg, branch, jump, alu_op} !== expected)
            $display("FAIL: %s | expected %b, got %b",
                test_name, expected,
                {reg_write, alu_src, mem_write, mem_read, mem_to_reg, branch, jump, alu_op});
        else
            $display("PASS: %s", test_name);
    end
endtask

initial begin
    $dumpfile("sim/waves_control.vcd");
    $dumpvars(0, tb_control);

    opcode = 7'b0110011; #10; check(9'b100000010, "R_TYPE");
    opcode = 7'b0010011; #10; check(9'b110000010, "I_TYPE");
    opcode = 7'b0000011; #10; check(9'b110110000, "I_LW_TYPE");
    opcode = 7'b1100111; #10; check(9'b110000100, "I_JALR_TYPE");
    opcode = 7'b0100011; #10; check(9'b010100000, "S_TYPE");
    opcode = 7'b1100011; #10; check(9'b000001001, "B_TYPE");
    opcode = 7'b0110111; #10; check(9'b110000000, "U_LUI_TYPE");
    opcode = 7'b0010111; #10; check(9'b110000000, "U_AUIPC_TYPE");
    opcode = 7'b1101111; #10; check(9'b100000100, "J_TYPE");
    opcode = 7'b0000000; #10; check(9'b000000000, "DEFAULT");

    $finish;
end

endmodule
