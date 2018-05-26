transcript on
if ![file isdirectory verilog_libs] {
	file mkdir verilog_libs
}

vlib verilog_libs/altera_ver
vmap altera_ver ./verilog_libs/altera_ver
vlog -vlog01compat -work altera_ver {c:/intelfpga_lite/17.1/quartus/eda/sim_lib/altera_primitives.v}

vlib verilog_libs/lpm_ver
vmap lpm_ver ./verilog_libs/lpm_ver
vlog -vlog01compat -work lpm_ver {c:/intelfpga_lite/17.1/quartus/eda/sim_lib/220model.v}

vlib verilog_libs/sgate_ver
vmap sgate_ver ./verilog_libs/sgate_ver
vlog -vlog01compat -work sgate_ver {c:/intelfpga_lite/17.1/quartus/eda/sim_lib/sgate.v}

vlib verilog_libs/altera_mf_ver
vmap altera_mf_ver ./verilog_libs/altera_mf_ver
vlog -vlog01compat -work altera_mf_ver {c:/intelfpga_lite/17.1/quartus/eda/sim_lib/altera_mf.v}

vlib verilog_libs/altera_lnsim_ver
vmap altera_lnsim_ver ./verilog_libs/altera_lnsim_ver
vlog -sv -work altera_lnsim_ver {c:/intelfpga_lite/17.1/quartus/eda/sim_lib/altera_lnsim.sv}

vlib verilog_libs/cyclonev_ver
vmap cyclonev_ver ./verilog_libs/cyclonev_ver
vlog -vlog01compat -work cyclonev_ver {c:/intelfpga_lite/17.1/quartus/eda/sim_lib/mentor/cyclonev_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_ver {c:/intelfpga_lite/17.1/quartus/eda/sim_lib/mentor/cyclonev_hmi_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_ver {c:/intelfpga_lite/17.1/quartus/eda/sim_lib/cyclonev_atoms.v}

vlib verilog_libs/cyclonev_hssi_ver
vmap cyclonev_hssi_ver ./verilog_libs/cyclonev_hssi_ver
vlog -vlog01compat -work cyclonev_hssi_ver {c:/intelfpga_lite/17.1/quartus/eda/sim_lib/mentor/cyclonev_hssi_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_hssi_ver {c:/intelfpga_lite/17.1/quartus/eda/sim_lib/cyclonev_hssi_atoms.v}

vlib verilog_libs/cyclonev_pcie_hip_ver
vmap cyclonev_pcie_hip_ver ./verilog_libs/cyclonev_pcie_hip_ver
vlog -vlog01compat -work cyclonev_pcie_hip_ver {c:/intelfpga_lite/17.1/quartus/eda/sim_lib/mentor/cyclonev_pcie_hip_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_pcie_hip_ver {c:/intelfpga_lite/17.1/quartus/eda/sim_lib/cyclonev_pcie_hip_atoms.v}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/anda0/Documents/GitHub/EnDMe-Processor/Project {C:/Users/anda0/Documents/GitHub/EnDMe-Processor/Project/definitions.sv}
vlog -sv -work work +incdir+C:/Users/anda0/Documents/GitHub/EnDMe-Processor/Project {C:/Users/anda0/Documents/GitHub/EnDMe-Processor/Project/reg_file.sv}
vlog -sv -work work +incdir+C:/Users/anda0/Documents/GitHub/EnDMe-Processor/Project {C:/Users/anda0/Documents/GitHub/EnDMe-Processor/Project/pc.sv}
vlog -sv -work work +incdir+C:/Users/anda0/Documents/GitHub/EnDMe-Processor/Project {C:/Users/anda0/Documents/GitHub/EnDMe-Processor/Project/incrementor.sv}
vlog -sv -work work +incdir+C:/Users/anda0/Documents/GitHub/EnDMe-Processor/Project {C:/Users/anda0/Documents/GitHub/EnDMe-Processor/Project/data_mem.sv}
vlog -sv -work work +incdir+C:/Users/anda0/Documents/GitHub/EnDMe-Processor/Project {C:/Users/anda0/Documents/GitHub/EnDMe-Processor/Project/instr_fetch.sv}
vlog -sv -work work +incdir+C:/Users/anda0/Documents/GitHub/EnDMe-Processor/Project {C:/Users/anda0/Documents/GitHub/EnDMe-Processor/Project/top_level.sv}
vlog -sv -work work +incdir+C:/Users/anda0/Documents/GitHub/EnDMe-Processor/Project {C:/Users/anda0/Documents/GitHub/EnDMe-Processor/Project/mux_2.sv}
vlog -sv -work work +incdir+C:/Users/anda0/Documents/GitHub/EnDMe-Processor/Project {C:/Users/anda0/Documents/GitHub/EnDMe-Processor/Project/mux_4.sv}
vlog -sv -work work +incdir+C:/Users/anda0/Documents/GitHub/EnDMe-Processor/Project {C:/Users/anda0/Documents/GitHub/EnDMe-Processor/Project/accumulator.sv}
vlog -sv -work work +incdir+C:/Users/anda0/Documents/GitHub/EnDMe-Processor/Project {C:/Users/anda0/Documents/GitHub/EnDMe-Processor/Project/instr_rom.sv}
vlog -sv -work work +incdir+C:/Users/anda0/Documents/GitHub/EnDMe-Processor/Project {C:/Users/anda0/Documents/GitHub/EnDMe-Processor/Project/controller.sv}
vlog -sv -work work +incdir+C:/Users/anda0/Documents/GitHub/EnDMe-Processor/Project {C:/Users/anda0/Documents/GitHub/EnDMe-Processor/Project/alu.sv}

