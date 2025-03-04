import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../RTL/FIFO.sv"
`include "../RTL/FIFO_2FF_Sync.sv"
`include "../RTL/FIFO_rd_empty.sv"
`include "../RTL/FIFO_wr_full.sv"
`include "../RTL/fifo_memory.sv"

import uvm_AFIFO_agent_pkg::*;


`include "uvm_AFIFO_interface.sv"
`include "uvm_AFIFO_agent_pkg.sv"
`include "uvm_AFIFO_Wr_cov.sv"
`include "uvm_AFIFO_Wr_driver.sv"
`include "uvm_AFIFO_Wr_monitor.sv"
`include "uvm_AFIFO_Wr_sequence_item.sv"
`include "uvm_AFIFO_Wr_sequencer.sv"
`include "uvm_AFIFO_Wr_sequence.sv"
`include "uvm_AFIFO_Rd_cov.sv"
`include "uvm_AFIFO_Rd_driver.sv"
`include "uvm_AFIFO_Rd_monitor.sv"
`include "uvm_AFIFO_Rd_seq.sv"
`include "uvm_AFIFO_Rd_sequence_item.sv"
`include "uvm_AFIFO_Rd_sequencer.sv"
`include "uvm_AFIFO_scoreboard.sv"
`include "uvm_AFIFO_Wr_agent.sv"
`include "uvm_AFIFO_Rd_agent.sv"
`include "uvm_AFIFO_env.sv"
`include "uvm_AFIFO_test.sv"
// check if all necessary files included

module uvm_AFIFO_top;
	
	uvm_AFIFO_interface vif();
	
	FIFO #(8,3) fifo (vif.wr_data, vif.wr_clk, vif.wr_rst, vif.wr_inc,
        vif.rd_clk, vif.rd_rst, vif.rd_inc, vif.rd_data, vif.rd_empty, vif.wr_full);

		always #5 vif.wr_clk = ~vif.wr_clk;
		always #10 vif.rd_clk = ~vif.rd_clk;


	initial begin
		uvm_resource_db#(virtual uvm_AFIFO_interface#(8,3))::set("ALL", "TB",in,null);	
	end

//Variable initialization
	initial begin
		vif.wr_clk = 1;
		vif.rd_clk = 1;
		vif.wr_rst = 1;
		vif.wr_inc = 0;
		vif.rd_data = 0;
		vif.rd_clk = 0;
		vif.rd_rst = 1;
		vif.rd_inc = 0;
		repeat(2)@(posedge vif.wr_clk);
		vif.wr_rst = 0;
		vif.rd_rst = 0;
	end

	initial begin
		run_test();
	end

		endmodule
