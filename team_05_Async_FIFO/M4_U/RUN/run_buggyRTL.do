#Delete and create work library
if [file exists "work"] {vdel -all}
vlib work

#Compile the RTL source & Testbench Files
#vlog -source -lint -sv +incdir+../VERIF_UVM/uvm_AFIFO_interface.sv ../RTL/BUGGYRTL ../VERIF_UVM/uvm_AFIFO_agent_pkg.sv ../VERIF_UVM/uvm_AFIFO_top.sv 
vlog -source -lint -sv -cover bcesft +incdir+../RTL ../VERIF_UVM/uvm_AFIFO_interface.sv ../VERIF_UVM/uvm_AFIFO_agent_pkg.sv ../VERIF_UVM/uvm_AFIFO_top.sv


#Optimize and simulate
#vopt uvm_AFIFO_top -o uvm_AFIFO_top_opt 
#vsim -coverage uvm_AFIFO_top_opt -voptargs="+cover=bcesft" +UVM_TESTNAME=AFIFO_wr_rd 
#vsim uvm_AFIFO_top_opt -coverage -voptargs="+cover=bcesft" +UVM_TESTNAME=AFIFO_wr_rd


#trial
vopt uvm_AFIFO_top -o uvm_AFIFO_top_opt +cover=bcesft
vsim -coverage uvm_AFIFO_top_opt \
     -voptargs="+cover=bcesft" \
     +UVM_TESTNAME=AFIFO_wr_rd

#working
#vsim -coverage -voptargs="+cover=bcesft" +acc work.uvm_AFIFO_top +UVM_TESTNAME=AFIFO_wr_rd


#Setup VCD file and Logging
vcd file uvm_AFIFO_top.vcd
vcd add -r uvm_AFIFO_top/*
set NoQuitOnFinish 1
onbreak {resume}
log /* -r

#Run Simulation
run -all

# Generate a coverage report after the simulation
coverage report -details -file coverage_report.txt

#Save Coverage data
coverage save AFIFO_wr_rd.ucdb
#quit -sim

#============================================



