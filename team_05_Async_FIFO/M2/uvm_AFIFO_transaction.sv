import uvm_pkg::*;
`include "uvm_macros.svh"

class uvm_AFIFO_sequence_item #(parameter DSIZE = 8) extends uvm_sequence_item;
	 randc logic [DSIZE-1:0] wr_data;
	 bit wr_clk, wr_rst, wr_inc;
	 bit rd_clk, rd_rst, rd_inc;
	 logic [DSIZE-1: 0]rd_data;
	 logic [DSIZE-1: 0]rd_data_refModule;
	 bit rd_empty,wr_full;

	function new(string name = "");
          super.new(name);
     endfunction: new

	`uvm_object_utils_begin(uvm_AFIFO_sequence_item)
	    `uvm_field_int(wr_data, UVM_ALL_ON)
	    `uvm_field_int(rd_data, UVM_ALL_ON)
	    `uvm_field_int(rd_data_refModule, UVM_ALL_ON)
	    `uvm_field_int(rd_empty, UVM_ALL_ON)
	    `uvm_field_int(wr_full, UVM_ALL_ON)
	    `uvm_field_int(wr_clk, UVM_ALL_ON)
	    `uvm_field_int(wr_rst, UVM_ALL_ON)
	    `uvm_field_int(wr_inc, UVM_ALL_ON)
	    `uvm_field_int(rd_clk, UVM_ALL_ON)
	    `uvm_field_int(rd_rst, UVM_ALL_ON)
	    `uvm_field_int(rd_inc, UVM_ALL_ON)
	`uvm_object_utils_end
endclass : uvm_AFIFO_sequence_item
