import uvm_pkg::*;
`include "uvm_macros.svh"
import uvm_AFIFO_agent_pkg::*;

class uvm_AFIFO_Rd_agent extends uvm_agent;

    // ========== FACTORY REGISTRATION ==========
    `uvm_component_utils(uvm_AFIFO_Rd_agent)

    // ========== COMPONENT HANDLES ==========
    uvm_AFIFO_Rd_sequencer Rd_sqr; // Sequencer
    uvm_AFIFO_Rd_driver    Rd_drvr; // Driver
    uvm_AFIFO_Rd_monitor   Rd_mon;  // Monitor
    uvm_AFIFO_Rd_cov       Rd_cov; // Coverage

    // Analysis port to send transactions from monitor to scoreboard
  //  uvm_analysis_port#(uvm_AFIFO_sequence_item) sb_export_mon;

    // ========== CONSTRUCTOR ==========
    function new(string name = "uvm_AFIFO_Rd_agent", uvm_component parent ); 
      super.new(name,parent); 
    endfunction 


    // ========== BUILD PHASE ==========
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        
        Rd_sqr = uvm_AFIFO_Rd_sequencer::type_id::create("Rd_sqr", this);
        Rd_drvr = uvm_AFIFO_Rd_driver::type_id::create("Rd_drvr", this);
        Rd_mon = uvm_AFIFO_Rd_monitor::type_id::create("Rd_mon", this);
        Rd_cov = uvm_AFIFO_Rd_cov::type_id::create("Rd_cov", this);
    
    endfunction: build_phase

    // ========== CONNECT PHASE ==========
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        Rd_drvr.seq_item_port.connect(Rd_sqr.seq_item_export); // Read Driver to Read Sequencer
        Rd_mon.mon_port_cov.connect(Rd_cov.analysis_export); // Read Monitor to Read Coverage

    endfunction: connect_phase

endclass: uvm_AFIFO_Rd_agent
