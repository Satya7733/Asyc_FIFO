import uvm_pkg::*;
`include "uvm_macros.svh"

import uvm_AFIFO_agent_pkg::*;


class uvm_AFIFO_Wr_sequence_item #(parameter DSIZE = 8, ASIZE = 3) extends uvm_sequence_item;
	 randc logic [DSIZE-1:0] wr_data;
	 bit wr_clk, wr_rst, wr_inc;
	 bit wr_full;

	function new(string name = "");
		super.new(name);
	endfunction: new

	`uvm_object_utils_begin(uvm_AFIFO_Wr_sequence_item#(DSIZE, ASIZE))
	    `uvm_field_int(wr_data, UVM_ALL_ON)
	    `uvm_field_int(wr_full, UVM_ALL_ON)
	    `uvm_field_int(wr_clk, UVM_ALL_ON)
	    `uvm_field_int(wr_rst, UVM_ALL_ON)
	    `uvm_field_int(wr_inc, UVM_ALL_ON)
	`uvm_object_utils_end
endclass : uvm_AFIFO_Wr_sequence_item
