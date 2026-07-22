// src/alu_control.v
`include "src/defines.v"

module alu_control (
    input      [1:0] alu_op,
    input      [2:0] funct3,
    input      [6:0] funct7,
    output reg [3:0] alu_ctrl
);
    always @(*) begin
        if (alu_op == 2'b00) begin
            alu_ctrl = `ALU_ADD;
        end else if (alu_op == 2'b01) begin
            alu_ctrl = `ALU_SUB;
        end else if (funct3 == 3'b000 && funct7 == 7'b0000000) begin
            alu_ctrl = `ALU_ADD;
        end else if (funct3 == 3'b000 && funct7 == 7'b0100000) begin
            alu_ctrl = `ALU_SUB;
        end else if (funct3 == 3'b111) begin
            alu_ctrl = `ALU_AND;
        end else if (funct3 == 3'b110) begin
            alu_ctrl = `ALU_OR;
        end else if (funct3 == 3'b100) begin
            alu_ctrl = `ALU_XOR;
        end else if (funct3 == 3'b010) begin
            alu_ctrl = `ALU_SLT;
        end else begin
            alu_ctrl = 4'b0;
        end
    end

endmodule
