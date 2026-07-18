# Compiler and simulator
IV = iverilog
VVP = vvp

# Directories
SRC = src
TB = tb
SIM = sim

# ── Simulation targets ──────────────────────────────────────

sim_alu:
	$(IV) -o $(SIM)/tb_alu $(TB)/tb_alu.v $(SRC)/alu.v $(SRC)/defines.v
	$(VVP) $(SIM)/tb_alu

sim_regfile:
	$(IV) -o $(SIM)/tb_regfile $(TB)/tb_regfile.v $(SRC)/regfile.v $(SRC)/defines.v
	$(VVP) $(SIM)/tb_regfile

sim_imm_gen:
	$(IV) -o $(SIM)/tb_imm_gen $(TB)/tb_imm_gen.v $(SRC)/imm_gen.v $(SRC)/defines.v
	$(VVP) $(SIM)/tb_imm_gen

# Run all tests in sequence
sim_all:
	$(MAKE) sim_alu
	$(MAKE) sim_regfile
	$(MAKE) sim_imm_gen

# ── Waveforms ───────────────────────────────────────────────

wave_alu:
	gtkwave $(SIM)/waves_alu.vcd

wave_regfile:
	gtkwave $(SIM)/waves_regfile.vcd

wave_imm_gen:
	gtkwave $(SIM)/waves_imm_gen.vcd

# ── Cleanup ─────────────────────────────────────────────────

clean:
	rm -f $(SIM)/*.vcd $(SIM)/tb_*