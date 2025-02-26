import AFIFO_Pkg::*;
`include "uvm_macros.svh"

class afifo_scoreboard extends uvm_scoreboard;

// ========== FACTORY REGISTRATION ==========
	`uvm_component_utils(afifo_scoreboard)

	`uvm_analysis_export #(afifo_transaction) sb_export_mon;	//these will receive transactions from the monitor and driver.
	`uvm_analysis_export #(bit[DSIZE-1:0]) sb_export_drv;

	`uvm_tlm_analysis_fifo #(afifo_transaction) mon_fifo;	//to store and compare transactions
	`uvm_tlm_analysis_fifo #(bit[DSIZE-1:0]) drv_fifo;

	afifo_transaction tr_mon;

// ========== MEMORY CONSTRUCTOR ==========
	function new(string name, uvm_component parent);
		super.new(name, parent);
		tr_mon = new("tr_mon");
	endfunction : new

// ========== BUILD PHASE ==========
	function void build_phase(uvm_phase phase);
	super.build_phase(phase);

		sb_export_mon = new("sb_export_mon", this);
	        sb_export_drv = new("sb_export_drv", this);
	
		mon_fifo = new("mon_fifo", this);
	        drv_fifo = new("drv_fifo", this);
	endfunction : build_phase

// ========== CONNECT PHASE ==========
	function void connect_phase(uvm_phase phase);
		sb_export_mon.connect(mon_fifo.analysis_export);
		sb_export_drv.connect(drv_fifo.analysis_export);

		// DEBUG STATEMENT
		    `uvm_info("SCB", "Scoreboard connected to monitor and driver", UVM_LOW)

	endfunction : connect_phase

	task run();
		forever begin
			bit [DSIZE-1:0] rd_exp;

			mon_fifo.get(tr_mon);
			drv_fifo.get(rd_exp);
			compare(tr_mon, rd_exp);
		end
	endtask : run

	function void compare(afifo_transaction tr_mon, bit [DSIZE-1:0] rd_exp)
	if (tr_mon.rd_data == rd_exp) begin
            `uvm_info("SCOREBOARD", $sformatf("[ID = %d] MATCHED, READ DATA: %0d", tr_mon.id, tr_mon.rd_data), UVM_LOW);
        end else begin
            `uvm_error("SCOREBOARD", $sformatf("[ID = %d] MISMATCHED, DUT: %0d != REF: %0d", tr_mon.id, tr_mon.rd_data, rd_exp));
        end
	endfunction : compare

endclass : afifo_scoreboard
