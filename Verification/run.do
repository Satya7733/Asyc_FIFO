# DELETES IF THERE IS A PREVIOUS WORK DIRECTORY
vdel -all 

# CREATES THE WORK DIRECTORY
vlib work 

# COMPILING ALL THE DESIGN FILES 
vlog -work work /u/aakashbh/ECE-593/Asyc_FIFO/dut/*.sv

# COMPILING ALL THE Verification FILES 
vlog -work work +cover /u/aakashbh/ECE-593/Asyc_FIFO/Verification/AFIFO_Interface.sv \
                /u/aakashbh/ECE-593/Asyc_FIFO/Verification/AFIFO_Transaction.sv \
                /u/aakashbh/ECE-593/Asyc_FIFO/Verification/AFIFO_Pkg.sv \
                /u/aakashbh/ECE-593/Asyc_FIFO/Verification/AFIFO_Generator.sv \
                /u/aakashbh/ECE-593/Asyc_FIFO/Verification/AFIFO_Driver.sv \
                /u/aakashbh/ECE-593/Asyc_FIFO/Verification/AFIFO_Monitor.sv \
                /u/aakashbh/ECE-593/Asyc_FIFO/Verification/AFIFO_Scoreboard.sv \
                /u/aakashbh/ECE-593/Asyc_FIFO/Verification/AFIFO_Environment.sv \
                /u/aakashbh/ECE-593/Asyc_FIFO/Verification/AFIFO_TB_Top.sv 

# TO SIMULATE THE TESTBENCH 
vsim -coverage -voptargs="+cover=bcesft" +acc work.AFIFO_TB_Top

# RUN SIMULATION
run -all

# SAVE COVERAGE DATABASE
coverage save coverage.ucdb

# GENERATE COVERAGE REPORTS AFTER SIMULATION
coverage report -codeAll
coverage report -details -codeAll -file COVERAGE_REPORT
coverage report -details -codeAll -html COVERAGE_REPORT_web
