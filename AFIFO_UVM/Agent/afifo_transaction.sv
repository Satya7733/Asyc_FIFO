class afifo_seq_item extends uvm_sequence_item;
 randc logic [DSIZE-1:0] wr_data;
 bit wr_clk, wr_rst, wr_inc;
 bit rd_clk, rd_rst, rd_inc;
 logic [DSIZE-1: 0]rd_data;
 logic [DSIZE-1: 0]rd_data_refModule;
 bit rd_empty,wr_full;

`uvm_object_utils_begin(afifo_seq_item)

`uvm_field_int(wr_data, UVM_ALL_ON)
`uvm_field_int(wr_clk, UVM_ALL_ON)
`uvm_field_int(wr_rst, UVM_ALL_ON)
`uvm_field_int(wr_inc, UVM_ALL_ON)
`uvm_field_int(rd_clk,UVM_ALL_ON)
`uvm_field_int(rd_rst,UVM_ALL_ON)
`uvm_field_int(rd_inc,UVM_ALL_ON)
`uvm_field_int(rd_data,UVM_ALL_ON)
`uvm_field_int(rd_data_refModule,UVM_ALL_ON)
`uvm_field_int(rd_empty,UVM_ALL_ON)
`uvm_field_int(wr_full,UVM_ALL_ON)
`uvm_object_utils_end


function new(string name= "apb_seq_item");// create deep copy
//copy = new();
//copy.wr_data = this.wr_data;
//copy.rd_data = this.rd_data;
//copy.rd_empty = this.rd_empty;
//copy.wr_full = this.wr_full;
//copy.rd_data_refModule = this.rd_data_refModule;
// return copy;
super.new(name);
endfunction: new
 
endclass: apb_seq_item
