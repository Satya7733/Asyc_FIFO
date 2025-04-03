# DELETES IF THERE IS A PREVIOUS WORK DIRECTORY
vdel -all 

# CREATES THE WORK DIRECTORY
vlib work 

# COMPILING ALL THE DESIGN FILES 
<<<<<<< HEAD:team_05_Async_FIFO/M2/CLASS/run.do
vlog -work work FIFO.sv \
FIFO_2FF_Sync.sv \
FIFO_rd_empty.sv \
FIFO_wr_full.sv \
fifo_memory.sv

# COMPILING ALL THE Verification FILES 
vlog -work work +cover AFIFO_Interface.sv \
               AFIFO_Transaction.sv \
               AFIFO_Pkg.sv \
               AFIFO_Generator.sv \
               AFIFO_Driver.sv \
               AFIFO_Monitor.sv \
               AFIFO_Scoreboard.sv \
               AFIFO_Environment.sv \
               AFIFO_TB_Top.sv 
=======
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
>>>>>>> f408578aab148255eb9ad2c3772a3042e0a9bec0:Verification/run.do

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
