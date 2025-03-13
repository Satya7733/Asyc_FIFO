
#vlog +cover ../RTL/FIFO.sv ../VERIF_UVM/uvm_AFIFO_interface.sv ../VERIF_UVM/uvm_AFIFO_agent_pkg.sv ../VERIF_UVM/uvm_AFIFO_top.sv
#vsim -coverage -voptargs="+cover=sbfcet" +acc work.uvm_AFIFO_top +UVM_TESTNAME=AFIFO_wr_rd
#run -all
# Save coverage data
#coverage save coverage_data.ucdb
# Generate code coverage report
#vcover report -code sbcfet coverage_data.ucdb -output code_coverage.txt \
#	-du=uvm_AFIFO_top -du=FIFO
# Generate functional coverage report
#vcover report -details -cvg coverage_data.ucdb -output functional_coverage.txt
# Generate assertion coverage report
#vcover report -details -assert coverage_data.ucdb -output assertion_coverage.txt



# DELETES IF THERE IS A PREVIOUS WORK DIRECTORY
vdel -all 

# CREATES THE WORK DIRECTORY
vlib work 

# COMPILING ALL THE DESIGN FILES 
vlog -work work ../RTL/*.sv ../VERIF_UVM/uvm_AFIFO_interface.sv

# COMPILING ALL THE Verification FILES 
vlog -work work +cover ../VERIF_UVM/uvm_AFIFO_agent_pkg.sv ../VERIF_UVM/uvm_AFIFO_top.sv

# TO SIMULATE THE TESTBENCH 
vsim -coverage  +acc work.uvm_AFIFO_top +UVM_TESTNAME=AFIFO_wr_rd -voptargs="+cover=bcesft"



# RUN SIMULATION
run -all

# Generate code coverage report
vcover report -code sbcfet coverage_data.ucdb -output code_coverage.txt \
	-du=uvm_AFIFO_top -du=FIFO

# Generate functional coverage report
vcover report -details -code coverage_data.ucdb -output code_1_coverage.txt



