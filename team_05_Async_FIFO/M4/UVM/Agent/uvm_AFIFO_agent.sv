class uvm_AFIFO_agent extends uvm_agent;
	`uvm_component_utils(uvm_AFIFO_agent)

	uvm_analysis_port#(uvm_AFIFO_sequence_item) mon2scb;

	uvm_AFIFO_sequence	afifo_seqr;
	uvm_AFIFO_driver	afifo_drvr;
	uvm_AFIFO_monitor	afifo_mon;

	function new(string name, uvm_component parent);
          super.new(name, parent);
	endfunction: new