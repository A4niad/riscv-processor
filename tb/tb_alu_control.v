// tb/tb_alu_control.v
`include "src/defines.v"
`timescale 1ns/1ps

module tb_alu_control;

    reg [1:0] alu_op;
    reg [2:0] funct3;
    reg [6:0] funct7;

    wire [3:0] alu_ctrl;

    alu_control uut (
        .alu_op(alu_op),
        .funct3(funct3),
        .funct7(funct7),
        .alu_ctrl(alu_ctrl)
    );

    task automatic check;
        input [3:0] expected;
        input [127:0] test_name;
        begin
            if (alu_ctrl !== expected) begin
                $display("Test %s failed: expected %h, got %h", test_name, expected, alu_ctrl);
            end else begin
                $display("Test %s passed: got %h", test_name, alu_ctrl);
            end
        end
    endtask

    initial begin

        $dumpfile("sim/waves_alu_control.vcd");
        $dumpvars(0, tb_alu_control);

        // Check ALU_ADD
        alu_op = 2'b00;
        #10 check(`ALU_ADD, "ALU_ADD");

        // Check ALU_SUB
        alu_op = 2'b01;
        #10 check(`ALU_SUB, "ALU_SUB");

        // Check ALU_ADD W/ FUNCT3 and FUNCT7
        alu_op = 2'b10; funct3 = 3'b000; funct7 = 7'b0000000;
        #10 check(`ALU_ADD, "ALU_ADD W/ FUNCT3 and FUNCT7");

        // Check ALU_SUB W/ FUNCT3 and FUNCT7
        alu_op = 2'b10; funct3 = 3'b000; funct7 = 7'b0100000;
        #10 check(`ALU_SUB, "ALU_SUB W/ FUNCT3 and FUNCT7");

        // Check ALU_AND
        alu_op = 2'b10; funct3 = 3'b111;
        #10 check(`ALU_AND, "ALU_AND");

        // Check ALU_OR
        alu_op = 2'b10; funct3 = 3'b110;
        #10 check(`ALU_OR, "ALU_OR");

        // Check ALU_XOR
        alu_op = 2'b10; funct3 = 3'b100;
        #10 check(`ALU_XOR, "ALU_XOR");

        // Check ALU_SLT
        alu_op = 2'b10; funct3 = 3'b010;
        #10 check(`ALU_SLT, "ALU_SLT");

        $finish;

    end
endmodule
