`include "uvm_AFIFO_interface.sv"
`include "../RTL/FIFO.sv"
//`include 

module uvm_AFIFO_top;
	import uvm_pkg::*;

	uvm_AFIFO_interface vif();
	
	FIFO #(DSIZE, ASIZE) fifo (vif.wr_data, vif.wr_clk, vif.wr_rst, vif.wr_inc,
        vif.rd_clk, vif.rd_rst, vif.rd_inc, vif.rd_data, vif.rd_empty, vif.wr_full);


	initial begin
		uvm_resource_db#(virtual AFIFO_if)::set(.scope("ifs"), .name("AFIO_if"), .val(vif));

		run_test("uvm_AFIFO_test");
	end

//Variable initialization
	initial begin
		vif.wr_clk <= 0;
		vif.rd_clk <= 0;
	end

	always
		#5 vif.wr_clk <= ~vif.wr_clk;
		#10 vif.rd_clk <= ~vif.rd_clk;
	endmodule