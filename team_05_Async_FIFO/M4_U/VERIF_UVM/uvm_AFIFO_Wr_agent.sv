import uvm_pkg::*;
`include "uvm_macros.svh"
import uvm_AFIFO_agent_pkg::*;

class uvm_AFIFO_Wr_agent extends uvm_agent;

    // ========== FACTORY REGISTRATION ==========
    `uvm_component_utils(uvm_AFIFO_Wr_agent)

    // ========== COMPONENT HANDLES ==========
    uvm_AFIFO_Wr_sequencer afifo_Wr_seqr; // Sequencer
    uvm_AFIFO_Wr_driver afifo_Wr_drv; // Driver
    uvm_AFIFO_Wr_monitor afifo_Wr_mon;  // Monitor
    uvm_AFIFO_Wr_cov afifo_Wr_cov;      //Coverage

    // ========== CONSTRUCTOR ==========
    function new(string name = "uvm_AFIFO_Wr_agent", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    // ========== BUILD PHASE ==========
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        afifo_Wr_seqr= uvm_AFIFO_Wr_sequencer::type_id::create("afifo_Wr_seqr",this);
        afifo_Wr_drv= uvm_AFIFO_Wr_driver::type_id::create("afifo_Wr_drv",this);
        afifo_Wr_mon= uvm_AFIFO_Wr_monitor::type_id::create("afifo_Wr_mon",this);
        afifo_Wr_cov= uvm_AFIFO_Wr_cov::type_id::create("afifo_Wr_cov",this);    
    endfunction: build_phase

    // ========== CONNECT PHASE ==========
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    afifo_Wr_drv.seq_item_port.connect(afifo_Wr_seqr.seq_item_export); 
    afifo_Wr_mon.sb_export_mon.connect(afifo_Wr_cov.analysis_export);

    endfunction: connect_phase

endclass: uvm_AFIFO_Wr_agent
