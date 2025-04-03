# This is a run.do file for a Questa simulation

# Remove old work directory
#rm -rf work
vlib work

# Compile source files
vlog -sv FIFO.sv FIFO_2FF_Sync.sv FIFO_memory.sv FIFO_rd_empty.sv FIFO_wr_full.sv

# Compile Testbench files
vlog -sv FIFO_tb_comp.sv

# Load the design into the simulator
vsim -voptargs=+acc work.async_fifo_TB

# Add all signals to the waveform viewer
add wave -position insertpoint sim:/async_fifo_TB/fifo/*

# Start the simulation
run -all

