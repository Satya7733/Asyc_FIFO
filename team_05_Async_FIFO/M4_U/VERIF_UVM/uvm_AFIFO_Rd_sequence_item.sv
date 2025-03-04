
`include "uvm_macros.svh"
import uvm_pkg::*;
import uvm_AFIFO_agent_pkg::*;


class uvm_AFIFO_Rd_sequence_item extends uvm_sequence_item;

	 bit rd_clk, rd_rst, rd_inc;
	 logic [DSIZE-1: 0]rd_data;
// constraint so rdata stays in dsize limit 
	   constraint c_data { rd_data < (1 << dsize); } 

	// logic [DSIZE-1: 0]rd_data_refModule;
	 bit rd_empty;

	function new(string name = "");
		super.new(name);
	endfunction: new


	`uvm_object_utils_begin(uvm_AFIFO_Rd_sequence_item)

	   
	    `uvm_field_int(rd_data, UVM_ALL_ON)
	    //`uvm_field_int(rd_data_refModule, UVM_ALL_ON)
	    `uvm_field_int(rd_empty, UVM_ALL_ON)
	    `uvm_field_int(rd_clk, UVM_ALL_ON)
	    `uvm_field_int(rd_rst, UVM_ALL_ON)
	    `uvm_field_int(rd_inc, UVM_ALL_ON)
	`uvm_object_utils_end
endclass : uvm_AFIFO_Rd_sequence_item
