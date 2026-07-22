// tb/tb_imem.v
`timescale 1ns/1ps

module tb_imem;

    reg [31:0] addr;

    wire [31:0] inst;

    imem uut (
        .addr(addr),
        .inst(inst)
    );

    task automatic check;
        input [31:0]  expected;
        input [127:0] test_name;
        begin
            if (inst !== expected)
                $display("FAIL: %s | expected %h, got %h", test_name, expected, inst);
            else
                $display("PASS: %s | got %h", test_name, inst);
        end
    endtask

    initial begin
        $dumpfile("sim/waves_imem.vcd");
        $dumpvars(0, tb_imem);

        addr = 32'h00000000;
        #10 check(32'h00000013, "Instruction 0");

        addr = 32'h00000004;
        #10 check(32'h00110093, "Instruction 1");

        addr = 32'h00000008;
        #10 check(32'h00208133, "Instruction 2");

        addr = 32'h0000000c;
        #10 check(32'hfe418113, "Instruction 3");

        $finish;
    end

endmodule