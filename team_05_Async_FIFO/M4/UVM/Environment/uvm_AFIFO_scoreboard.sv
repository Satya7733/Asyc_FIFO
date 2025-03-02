import uvm_pkg::*;
`include "uvm_macros.svh"
//`include "uvm_AFIFO_agent_pkg.sv"
import uvm_AFIFO_agent_pkg::*;

class uvm_AFIFO_scoreboard#(DSIZE, ASIZE) extends uvm_scoreboard;
	`uvm_component_utils(uvm_AFIFO_scoreboard#(8,3))

	uvm_analysis_export #(uvm_AFIFO_sequence_item) sb_export_mon;	//these will receive transactions from the monitor and driver.
	uvm_analysis_export #(bit [DSIZE-1:0]) sb_export_drv;

	uvm_tlm_analysis_fifo #(uvm_AFIFO_sequence_item) mon_fifo;	//to store and compare transactions
	uvm_tlm_analysis_fifo #(bit [DSIZE-1:0]) drv_fifo;

	uvm_AFIFO_sequence_item tr_mon;

	function new(string name, uvm_component parent);
		super.new(name, parent);
		tr_mon = new("tr_mon");
	endfunction : new
	
	function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("SCOREBOARD", "Inside the build phase of scoreboard", UVM_NONE);
		sb_export_mon = new("sb_export_mon", this);
	        sb_export_drv = new("sb_export_drv", this);
	
		mon_fifo = new("mon_fifo", this);
	        drv_fifo = new("drv_fifo", this);
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
	`uvm_info("SCOREBOARD", "Inside the connect phase of scoreboard", UVM_NONE);
		sb_export_mon.connect(mon_fifo.analysis_export);
		sb_export_drv.connect(drv_fifo.analysis_export);
	endfunction : connect_phase

	task run();
		forever begin
			bit [DSIZE-1:0] rd_exp;

			mon_fifo.get(tr_mon);
			drv_fifo.get(rd_exp);
			compare(tr_mon, rd_exp);
		end
	endtask : run

	function void compare(uvm_AFIFO_sequence_item tr_mon, bit [DSIZE-1:0] rd_exp);
	if (tr_mon.rd_data == rd_exp) begin
            `uvm_info("SCOREBOARD", $sformatf("[ID = ] MATCHED, READ DATA: %0d", tr_mon.rd_data), UVM_LOW); //, tr_mon.id removed
        end else begin
            `uvm_error("SCOREBOARD", $sformatf("[ID = ] MISMATCHED, DUT: %0d != REF: %0d", tr_mon.rd_data, rd_exp));
        end
	endfunction : compare

endclass : uvm_AFIFO_scoreboard
