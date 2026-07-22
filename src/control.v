// src/control.v
`include "src/defines.v"

module control (
    input  [6:0] opcode,
    output reg        reg_write,
    output reg        alu_src,
    output reg        mem_write,
    output reg        mem_read,
    output reg        mem_to_reg,
    output reg        branch,
    output reg        jump,
    output reg [1:0]  alu_op
);

    always @(*) begin
        case (opcode)
            `R_TYPE:       {reg_write, alu_src, mem_write, mem_read, mem_to_reg, branch, jump, alu_op} = 9'b100000010;
            `I_TYPE:       {reg_write, alu_src, mem_write, mem_read, mem_to_reg, branch, jump, alu_op} = 9'b110000010;
            `I_LW_TYPE:    {reg_write, alu_src, mem_write, mem_read, mem_to_reg, branch, jump, alu_op} = 9'b110110000;
            `I_JALR_TYPE:  {reg_write, alu_src, mem_write, mem_read, mem_to_reg, branch, jump, alu_op} = 9'b110000100;
            `S_TYPE:       {reg_write, alu_src, mem_write, mem_read, mem_to_reg, branch, jump, alu_op} = 9'b011000000;
            `B_TYPE:       {reg_write, alu_src, mem_write, mem_read, mem_to_reg, branch, jump, alu_op} = 9'b000001001;
            `U_LUI_TYPE:   {reg_write, alu_src, mem_write, mem_read, mem_to_reg, branch, jump, alu_op} = 9'b110000000;
            `U_AUPIC_TYPE: {reg_write, alu_src, mem_write, mem_read, mem_to_reg, branch, jump, alu_op} = 9'b110000000;
            `J_TYPE:       {reg_write, alu_src, mem_write, mem_read, mem_to_reg, branch, jump, alu_op} = 9'b100000100;
            default:       {reg_write, alu_src, mem_write, mem_read, mem_to_reg, branch, jump, alu_op} = 9'b000000000;
        endcase
    end

endmodule
