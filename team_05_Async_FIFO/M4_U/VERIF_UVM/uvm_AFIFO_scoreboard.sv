import uvm_pkg::*;
`include "uvm_macros.svh"
import uvm_AFIFO_agent_pkg::*;
`uvm_analysis_imp_decl(_wr)
`uvm_analysis_imp_decl(_rd)

class uvm_AFIFO_scoreboard extends uvm_scoreboard;

	uvm_analysis_imp_wr#(uvm_AFIFO_Wr_sequence_item, uvm_AFIFO_scoreboard) imp_wr;
	uvm_analysis_imp_rd#(uvm_AFIFO_Rd_sequence_item, uvm_AFIFO_scoreboard) imp_rd;
`uvm_component_utils(uvm_AFIFO_scoreboard)
int DSIZE = 8;
bit [7:0] writeQ[$];
bit [7:0] readQ[$];
bit [7:0] write_data;
bit [7:0] read_data;

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
  	imp_wr = new("imp_wr",this);
 	imp_rd = new("imp_rd",this);
endfunction

function void write_wr (uvm_AFIFO_Wr_sequence_item tx);
	writeQ.push_back(tx.rd_data);
	$display("Read_Data is : %h", tx.rd_data);
	tx.print();
endfunction

function void write_rd (uvm_AFIFO_Wr_sequence_item rx);
	readQ.push_back(rx.rd_data);
	$display("Expected Read_Data is : %h", rx.rd_data);
	rx.print();
endfunction

task run_phase(uvm_phase phase);
	forever begin
	wait(writeQ.size()>0 && readQ.size()>0);
	write_data = writeQ.pop_front();
	read_data = readQ.pop_back();

	if(write_data == read_data)
		$display("MATCHED DATA, DATA_IN = %0h, DATA_OUT = %0h", write_data, read_data);
	else begin 
		$display("MISMATCHED DATA_IN = %0h, DATA_OUT = %0h", write_data, read_data); 
	end
	end
endtask

endclass