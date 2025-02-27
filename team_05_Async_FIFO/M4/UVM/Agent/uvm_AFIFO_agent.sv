
import uvm_pkg::*;
`include "uvm_macros.svh"
import uvm_AFIFO_agent_pkg::*;

class uvm_AFIFO_agent extends uvm_agent;

    // ========== FACTORY REGISTRATION ==========
    `uvm_component_utils(uvm_AFIFO_agent)

    // ========== COMPONENT HANDLES ==========
    uvm_AFIFO_sequencer afifo_seqr; // Sequencer
    uvm_AFIFO_driver    afifo_drvr; // Driver
    uvm_AFIFO_monitor   afifo_mon;  // Monitor

    // Analysis port to send transactions from monitor to scoreboard
    uvm_analysis_port#(uvm_AFIFO_sequence_item) sb_export_mon;

    // ========== CONSTRUCTOR ==========
    function new(string name = "uvm_AFIFO_agent", uvm_component parent);
        super.new(name, parent);
        sb_export_mon = new("sb_export_mon", this); // Create the analysis port
    endfunction: new

    // ========== BUILD PHASE ==========
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Create the monitor (always created, active or passive)
        afifo_mon = uvm_AFIFO_monitor#()::type_id::create("afifo_mon", this);

        // Create the sequencer and driver only if the agent is active
        if (get_is_active() == UVM_ACTIVE) begin
            afifo_seqr = uvm_AFIFO_sequencer::type_id::create("afifo_seqr", this);
            afifo_drvr = uvm_AFIFO_driver#()::type_id::create("afifo_drvr", this);
        end
    endfunction: build_phase

    // ========== CONNECT PHASE ==========
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        // Connect the driver to the sequencer (if active)
        if (get_is_active() == UVM_ACTIVE) begin
            afifo_drvr.seq_item_port.connect(afifo_seqr.seq_item_export);
        end

        // Connect the monitor's analysis port to the agent's analysis port
        afifo_mon.sb_export_mon.connect(sb_export_mon);
    endfunction: connect_phase

endclass: uvm_AFIFO_agent