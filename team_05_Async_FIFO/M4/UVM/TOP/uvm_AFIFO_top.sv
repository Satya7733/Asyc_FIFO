`include "uvm_AFIFO_interface.sv"
`include "../RTL/FIFO.sv"
`include "../RTL/FIFO_2FF_Sync.sv"
`include "../RTL/FIFO_rd_empty.sv"
`include "../RTL/FIFO_wr_full.sv"
`include "../RTL/fifo_memory.sv"
`include "../Test/uvm_AFIFO_test.sv"
//`include "../Environment/uvm_AFIFO_env.sv"
//`include "../Environment/uvm_AFIFO_scoreboard.sv"
//import uvm_AFIFO_agent_pkg::*;
//`include //design file

module uvm_AFIFO_top;
	import uvm_pkg::*;

	uvm_AFIFO_interface vif();
	
	FIFO #(8,3) fifo (vif.wr_data, vif.wr_clk, vif.wr_rst, vif.wr_inc,
        vif.rd_clk, vif.rd_rst, vif.rd_inc, vif.rd_data, vif.rd_empty, vif.wr_full);


	initial begin
		uvm_config_db#(virtual uvm_AFIFO_interface#(8,3))::set(null, "*", "vif", vif);

		run_test("uvm_AFIFO_test");
	end

//Variable initialization
	initial begin
		vif.wr_clk <= 0;
		vif.rd_clk <= 0;
	end

	
		always #5 vif.wr_clk <= ~vif.wr_clk;
		always #10 vif.rd_clk <= ~vif.rd_clk;
	endmodule