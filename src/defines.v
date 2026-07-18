// src/defines.v
// Central definitions

`define ALU_ADD  4'b0000
`define ALU_SUB  4'b0001
`define ALU_AND  4'b0010
`define ALU_OR   4'b0011
`define ALU_XOR  4'b0100
`define ALU_SLL  4'b0101
`define ALU_SRL  4'b0110
`define ALU_SRA  4'b0111
`define ALU_SLT  4'b1000
`define ALU_SLTU 4'b1001

`define R_TYPE       7'b0110011
`define I_TYPE       7'b0010011
`define I_LW_TYPE    7'b0000011
`define I_JALR_TYPE  7'b1100111
`define S_TYPE       7'b0100011
`define B_TYPE       7'b1100011
`define U_LUI_TYPE   7'0110111
`define U_AUPIC_TYPE 7'b0010111
`define J_TYPE       7'b1101111
