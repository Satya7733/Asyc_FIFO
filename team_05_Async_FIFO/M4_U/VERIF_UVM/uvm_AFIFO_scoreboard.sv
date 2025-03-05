import uvm_pkg::*;
`include "uvm_macros.svh"
import uvm_AFIFO_agent_pkg::*;
`uvm_analysis_imp_decl(_wr)
`uvm_analysis_imp_decl(_rd)

class uvm_AFIFO_scoreboard extends uvm_scoreboard;

	uvm_analysis_imp_wr#(uvm_AFIFO_Wr_sequence_item, uvm_AFIFO_scoreboard) imp_wr;
	uvm_analysis_imp_rd#(uvm_AFIFO_Rd_sequence_item, uvm_AFIFO_scoreboard) imp_rd;
`uvm_component_utils(uvm_AFIFO_scoreboard)

function new(string name = "uvm_AFIFO_scoreboard", uvm_component parent = null); 
 super.new(name,parent);
 endfunction 


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
	if(tx.wr_inc == 1 & !tx.wr_full )writeQ.push_back(tx.wr_data);
	$display("Data Written is : %h", tx.wr_data);
	if(tx.wr_full == 1)`uvm_info("SCOREBOARD", $sformatf("[SCB]: WRITE FULL"), UVM_NONE) //$display("[SCB]: WRITE FULL ");
	tx.print();
endfunction

function void write_rd (uvm_AFIFO_Rd_sequence_item rx);
	if(rx.rd_inc == 1 & !rx.rd_empty)readQ.push_back(rx.rd_data);
	$display("Expected Read_Data is : %h", rx.rd_data);
	if(rx.rd_empty == 1)`uvm_info("SCOREBOARD", $sformatf("[SCB]: READ EMPTY"), UVM_NONE) //$display("[SCB]: READ EMPTY ");
	rx.print();
endfunction

task run_phase(uvm_phase phase);
	forever begin
	wait(writeQ.size()>0 && readQ.size()>0);
	write_data = writeQ.pop_front();
	read_data = readQ.pop_back();
	
	
	if(write_data == read_data)
		//$display("MATCHED DATA, Data Written (Ref Module) = %0h, DATA_READ = %0h", write_data, read_data);
		`uvm_info("SCOREBOARD", $sformatf("MATCHED DATA, Data Written (Ref Module) = %0h, DATA_READ = %0h", write_data, read_data), UVM_MEDIUM)
	else begin 
	//	$display("MISMATCHED DATA Written (Ref Module)= %0h, DATA_READ = %0h", write_data, read_data); 
		`uvm_error("SCOREBOARD", $sformatf("MISS-MATCHED DATA, Data Written (Ref Module) = %0h, DATA_READ = %0h", write_data, read_data))
	end
	end
endtask

function void check_phase(uvm_phase phase);
        super.check_phase(phase);
        `uvm_info("SCOREBOARD", $sformatf("Functional Coverage at End: %0.2f%%", $get_coverage()), UVM_MEDIUM)
endfunction

endclass