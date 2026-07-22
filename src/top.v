// src/top.v
`include "src/defines.v"

module top(
    input wire clk,
    input wire reset
);

    wire [31:0] pc_next, pc;

    pc_reg u_pc_reg (
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc(pc)
    );

    wire [31:0] inst; 

    imem u_imem (
        .addr(pc),
        .inst(inst)
    );

    wire [6:0] opcode;
    wire [4:0] rs1_addr, rs2_addr, rd_addr;
    wire [2:0] funct3;
    wire [6:0] funct7;

    assign opcode   = inst[6:0];
    assign rd_addr  = inst[11:7];
    assign funct3   = inst[14:12];
    assign rs1_addr = inst[19:15];
    assign rs2_addr = inst[24:20];
    assign funct7   = inst[31:25];

    wire        reg_write, alu_src, mem_write, mem_read, mem_to_reg, branch, jump;
    wire [1:0]  alu_op;

    control u_control (
        .opcode(opcode),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .branch(branch),
        .jump(jump),
        .alu_op(alu_op)
    );

    wire [31:0] rd1, rd2, wr_data;

    regfile u_regfile(
        .clk(clk),
        .rst(reset),
        .rg_wren(reg_write),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rd_addr(rd_addr),
        .rd_data(wr_data),
        .rs1_data(rd1),
        .rs2_data(rd2)
    );

    wire [31:0] imm;

    imm_gen u_imm_gen (
        .inst(inst),
        .imm_out(imm)
    );

    wire [3:0] alu_ctrl;

    alu_control u_alu_control (
        .alu_op(alu_op),
        .funct3(funct3),
        .funct7(funct7),
        .alu_ctrl(alu_ctrl)
    ); 

    wire [31:0] alu_b;

    assign alu_b = alu_src ? imm : rd2;

    wire [31:0] alu_result;
    wire alu_zero;

    alu u_alu (
        .a(rd1),
        .b(alu_b),
        .alu_op(alu_ctrl),
        .result(alu_result),
        .zero(alu_zero)
    );

    wire [31:0] dmem_read;

    dmem u_dmem (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .addr(alu_result),
        .write_data(rd2),
        .read_data(dmem_read)
    );

    assign wr_data = mem_to_reg ? dmem_read : alu_result;

    wire [31:0] pc_branch = pc + imm;
    wire [31:0] pc_plus4 = pc + 32'd4;

    wire branch_taken = (branch & alu_zero  & (funct3 == 3'b000))
                  | (branch & ~alu_zero & (funct3 == 3'b001));

    assign pc_next = jump        ? (opcode == `I_JALR_TYPE ? alu_result : pc_branch)
                    : branch_taken ? pc_branch
                    :                pc_plus4;

endmodule