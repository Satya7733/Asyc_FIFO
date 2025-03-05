#Delete and create work library
if [file exists "work"] {vdel -all}
vlib work

#Compile the RTL source & Testbench Files
vlog -source -lint -sv +incdir+../RTL ../VERIF_UVM/uvm_AFIFO_agent_pkg.sv ../VERIF_UVM/uvm_AFIFO_top.sv

#Optimize and simulate
vopt uvm_AFIFO_top -o uvm_AFIFO_top_opt +acc +cover=sbfec
vsim uvm_AFIFO_top_opt -coverage +UVM_TESTNAME=AFIFO_wr_rd

#Setup VCD file and Logging
vcd file uvm_AFIFO_top.vcd
vcd add -r uvm_AFIFO_top/*
set NoQuitOnFinish 1
onbreak {resume}
log /* -r

#Run Simulation
run -all

#Save Coverage data
coverage save AFIFO_wr_rd.ucdb
quit -sim

#============================================



