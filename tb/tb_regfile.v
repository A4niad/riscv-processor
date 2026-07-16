// tb/tb_regfile.v
`timescale 1ns/1ps

module tb_regfile;

    reg clk;
    reg rst;
    reg rg_wren;
    reg [4:0] rs1_addr;
    reg [4:0] rs2_addr;
    reg [4:0] rd_addr;
    reg [31:0] rd_data;

    wire [31:0] rs1_data;
    wire [31:0] rs2_data;

    regfile uut (
        .clk(clk),
        .rst(rst),
        .rg_wren(rg_wren),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rd_addr(rd_addr),
        .rd_data(rd_data),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    initial begin
        clk = 0;
        rst = 1;
        rg_wren = 0;
        rs1_addr = 5'b0;
        rs2_addr = 5'b0;
        rd_addr = 5'b0;
        rd_data = 32'b0;

        $dumpfile("sim/waves.vcd");
        $dumpvars(0, tb_regfile);

        #10 rst = 0; // Release reset
    end

    always #5 clk = ~clk; // Clock generation

    initial begin
        // Test writing to register 1
        #10 rg_wren = 1; rd_addr = 5'b00001; rd_data = 32'hDEADBEEF;
        #10 rg_wren = 0; // Disable write

        // Test reading from register 1
        #10 rs1_addr = 5'b00001; rs2_addr = 5'b00000; // Read from reg1 and reg0
        #10;

        // Test writing to register 2
        #10 rg_wren = 1; rd_addr = 5'b00010; rd_data = 32'hCAFEBABE;
        #10 rg_wren = 0; // Disable write

        // Test reading from register 2
        #10 rs1_addr = 5'b00010; rs2_addr = 5'b00001; // Read from reg2 and reg1
        #10;

        // Test writing to register 0 (should not change)
        #10 rg_wren = 1; rd_addr = 5'b00000; rd_data = 32'hFFFFFFFF;
        #10 rg_wren = 0; // Disable write

        // Test reading from register 0 (should still be zero)
        #10 rs1_addr = 5'b00000; rs2_addr = 5'b00001; // Read from reg0 and reg1
        #10;

        $finish;
    end
endmodule   