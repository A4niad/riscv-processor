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

sim_control:
	$(IV) -o $(SIM)/tb_control $(TB)/tb_control.v $(SRC)/control.v $(SRC)/defines.v
	$(VVP) $(SIM)/tb_control

sim_alu_control:
	$(IV) -o $(SIM)/tb_alu_control $(TB)/tb_alu_control.v $(SRC)/alu_control.v $(SRC)/defines.v
	$(VVP) $(SIM)/tb_alu_control

sim_pc_reg:
	$(IV) -o $(SIM)/tb_pc_reg $(TB)/tb_pc_reg.v $(SRC)/pc_reg.v $(SRC)/defines.v
	$(VVP) $(SIM)/tb_pc_reg

sim_imem:
	$(IV) -o $(SIM)/tb_imem $(TB)/tb_imem.v $(SRC)/imem.v $(SRC)/defines.v
	$(VVP) $(SIM)/tb_imem

sim_dmem:
	$(IV) -o $(SIM)/tb_dmem $(TB)/tb_dmem.v $(SRC)/dmem.v $(SRC)/defines.v
	$(VVP) $(SIM)/tb_dmem

# Run all tests in sequence
sim_all:
	$(MAKE) sim_alu
	$(MAKE) sim_regfile
	$(MAKE) sim_imm_gen
	${MAKE} sim_control
	${MAKE} sim_alu_control
	${MAKE} sim_pc_reg
	${MAKE} sim_imem

# ── Waveforms ───────────────────────────────────────────────

wave_alu:
	gtkwave $(SIM)/waves_alu.vcd

wave_regfile:
	gtkwave $(SIM)/waves_regfile.vcd

wave_imm_gen:
	gtkwave $(SIM)/waves_imm_gen.vcd

wave_control:
	gtkwave $(SIM)/waves_control.vcd

wave_alu_control:
	gtkwave $(SIM)/waves_alu_control.vcd

wave_pc_reg:
	gtkwave ${SIM}/waves_pc_reg.vcd

wave_imem:
	gtkwave $(SIM)/waves_imem.vcd

wave_dmem:
	gtkwave $(SIM)/waves_dmem.vcd

# ── Cleanup ─────────────────────────────────────────────────

clean:
	rm -f $(SIM)/*.vcd $(SIM)/tb_*