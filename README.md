# RISC-V Single-Cycle Processor

A single-cycle RV32I processor built from scratch in Verilog. This started as a summer project to get serious about RTL design — the goal was to understand how a processor actually works at the hardware level, not just conceptually.

Every module was written and verified independently before being wired together into a working CPU. The whole thing runs on Icarus Verilog and GTKWave, no proprietary tools needed.

---

## What it does

Implements the RV32I base integer instruction set — fetch, decode, execute, memory, and writeback all happen in a single clock cycle. It's not fast, but it's correct and it's simple enough to reason about every signal in the datapath.

**Supported instructions:**

| Type | Instructions |
|------|-------------|
| R-type | ADD, SUB, AND, OR, XOR, SLT |
| I-type | ADDI, ANDI, ORI, XORI, SLTI, LW, JALR |
| S-type | SW |
| B-type | BEQ, BNE |
| J-type | JAL |
| U-type | LUI |

---

## Project structure

```
riscv-single-cycle/
├── src/
│   ├── defines.v        — opcodes, ALU ops, shared constants
│   ├── alu.v            — arithmetic and logic unit
│   ├── alu_control.v    — decodes funct3/funct7 into ALU operation
│   ├── control.v        — main control unit (opcode → control signals)
│   ├── regfile.v        — 32 general-purpose registers, x0 hardwired to 0
│   ├── imm_gen.v        — sign-extends immediates across all instruction formats
│   ├── pc_reg.v         — program counter with async reset
│   ├── imem.v           — instruction memory, loaded from hex file
│   ├── dmem.v           — data memory for loads and stores
│   └── top.v            — top-level datapath, wires everything together
├── tb/
│   ├── tb_alu.v
│   ├── tb_regfile.v
│   ├── tb_imm_gen.v
│   ├── tb_control.v
│   ├── tb_alu_control.v
│   ├── tb_pc_reg.v
│   ├── tb_imem.v
│   ├── tb_dmem.v
│   └── tb_top.v         — runs a full test program through the processor
├── sim/                 — compiled simulation outputs (git-ignored)
├── src/program.hex      — test program loaded into instruction memory
└── Makefile
```

---

## How to run it

**Prerequisites:**
```bash
# Fedora
sudo dnf install iverilog gtkwave

# Ubuntu/Debian
sudo apt install iverilog gtkwave
```

**Run all testbenches:**
```bash
make sim_all
```

**Run just the full processor test:**
```bash
make sim_top
```

**Open waveforms for any module:**
```bash
make wave_top       # full processor
make wave_alu       # just the ALU
make wave_regfile   # just the register file
# etc.
```

---

## How it works

The datapath follows the standard single-cycle RISC-V design — every instruction completes in one clock cycle, with five stages happening combinationally:

```
         ┌─────────┐     ┌─────────┐     ┌─────────┐     ┌─────────┐     ┌──────────┐
PC ────▶ │  Fetch  │────▶│ Decode  │────▶│ Execute │────▶│ Memory  │────▶│ Writeback│
         │  imem   │     │regfile  │     │   alu   │     │  dmem   │     │ reg write│
         └─────────┘     │imm_gen  │     │alu_ctrl │     └─────────┘     └──────────┘
              │          │control  │     └─────────┘
              │          └─────────┘
              ▼
         PC + 4 / branch target / jump target
```

The control unit decodes the opcode and drives seven signals (`reg_write`, `alu_src`, `mem_write`, `mem_read`, `mem_to_reg`, `branch`, `jump`) that configure the rest of the datapath for each instruction. The ALU control unit handles the finer decoding of `funct3`/`funct7` for R-type and I-type arithmetic.

PC next logic handles three cases:
- **Sequential**: PC + 4 (default)
- **Branch**: PC + imm (when BEQ/BNE condition is met)
- **Jump**: PC + imm for JAL, rs1 + imm for JALR

---

## Test program

The full processor test (`tb_top.v`) loads a hand-assembled RV32I program into instruction memory and checks register values after execution:

```asm
addi x1, x0, 5       # x1 = 5
addi x2, x0, 3       # x2 = 3
add  x3, x1, x2      # x3 = 8
sub  x4, x1, x2      # x4 = 2
and  x5, x1, x2      # x5 = 1
or   x6, x1, x2      # x6 = 7
sw   x3, 0(x0)       # mem[0] = 8
lw   x7, 0(x0)       # x7 = 8
beq  x1, x1, skip    # branch forward — skip next two instructions
addi x8, x0, 99      # skipped
addi x8, x0, 99      # skipped
skip:
addi x9, x0, 42      # x9 = 42
jal  x0, 0           # infinite loop / halt
```

Expected output:
```
PASS: ADDI x1 = 5
PASS: ADDI x2 = 3
PASS: ADD  x3 = 8
PASS: SUB  x4 = 2
PASS: AND  x5 = 1
PASS: OR   x6 = 7
PASS: LW   x7 = 8
PASS: BEQ skipped x8 = 0
PASS: ADDI x9 = 42
PASS: SW mem[0] = 8
```

---

## Tools

- [Icarus Verilog](http://iverilog.icarus.com/) — simulation
- [GTKWave](http://gtkwave.sourceforge.net/) — waveform viewer
- GNU Make

---

## Background

Built this during summer before 3rd year of B.E. EEE at BITS Pilani Hyderabad, as part of preparing for VLSI/chip design roles. The goal was to go beyond coursework and actually implement something real in RTL — understanding the datapath at the signal level, writing testbenches, and debugging with waveforms rather than just reading about how CPUs work.
