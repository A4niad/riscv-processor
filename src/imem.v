// src/imem.v
`include "src/defines.v"

module imem(
    input [31:0] addr,
    output [31:0] inst
);

    reg [31:0] mem [0:255];

    initial begin
        $readmemh("src/program.hex", mem);
    end

    assign inst = mem[addr[31:2]];

endmodule