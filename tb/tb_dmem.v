// tb/tb_dmem.v
`timescale 1ns/1ps

module tb_dmem;

reg        clk;
reg        mem_read;
reg        mem_write;
reg [31:0] addr;
reg [31:0] write_data;

wire [31:0] read_data;

dmem uut (
    .clk       (clk),
    .mem_read  (mem_read),
    .mem_write (mem_write),
    .addr      (addr),
    .write_data(write_data),
    .read_data (read_data)
);

// Clock generator
initial clk = 0;
always #5 clk = ~clk;

task automatic check;
    input [31:0]  expected;
    input [127:0] test_name;
    begin
        if (read_data !== expected)
            $display("FAIL: %s | expected %h, got %h", test_name, expected, read_data);
        else
            $display("PASS: %s | got %h", test_name, read_data);
    end
endtask

initial begin
    $dumpfile("sim/waves_dmem.vcd");
    $dumpvars(0, tb_dmem);

    // Initialise all inputs low
    mem_read = 0; mem_write = 0;
    addr = 0; write_data = 0;

    // ── Test 1: Basic write then read ─────────────────────
    // Write 0xDEADBEEF to address 0x00000000
    addr = 32'h00000000; write_data = 32'hDEADBEEF;
    mem_write = 1; mem_read = 0;
    @(posedge clk); #1;
    mem_write = 0;

    // Read it back
    mem_read = 1; #1;
    check(32'hDEADBEEF, "Basic write then read");

    // ── Test 2: Write enable gating ───────────────────────
    // Try to overwrite with mem_write=0 — value should not change
    addr = 32'h00000000; write_data = 32'h12345678;
    mem_write = 0; mem_read = 0;
    @(posedge clk); #1;

    // Read back — should still be 0xDEADBEEF
    mem_read = 1; #1;
    check(32'hDEADBEEF, "Write enable gating");

    // ── Test 3: Read enable gating ────────────────────────
    // mem_read=0 should output 0 regardless of what's stored
    mem_read = 0; #1;
    check(32'h00000000, "Read enable gating");

    // ── Test 4: Different addresses are independent ────────
    // Write 0xCAFEBABE to address 0x00000004
    addr = 32'h00000004; write_data = 32'hCAFEBABE;
    mem_write = 1; mem_read = 0;
    @(posedge clk); #1;
    mem_write = 0;

    // Read address 0x00000004 — should be 0xCAFEBABE
    mem_read = 1; #1;
    check(32'hCAFEBABE, "Write to second address");

    // Read address 0x00000000 — should still be 0xDEADBEEF
    addr = 32'h00000000; #1;
    check(32'hDEADBEEF, "First address unchanged");

    $finish;
end

endmodule