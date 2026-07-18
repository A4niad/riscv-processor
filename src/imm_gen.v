// src/imm_gen.v
`include "src/defines.v"

module imm_gen(
    input [31:0] inst,
    output reg [31:0] imm_out
);
    always @(*) begin
        case(inst[6:0])
            `R_TYPE: imm_out = 32'b0;
            `I_TYPE: imm_out = {{20{inst[31]}}, inst[31:20]};
            `I_LW_TYPE: imm_out = {{20{inst[31]}}, inst[31:20]};
            `I_JALR_TYPE: imm_out = {{20{inst[31]}}, inst[31:20]};
            `S_TYPE: imm_out = {{20{inst[31]}}, inst[31:25], inst[11:7]};
            `B_TYPE: imm_out = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
            `U_LUI_TYPE: imm_out = {inst[31:12], 12'b0};
            `U_AUPIC_TYPE: imm_out = {inst[31:12], 12'b0};
            `J_TYPE: imm_out = {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
            default imm_out = 32'b0;
        endcase
    end

endmodule
