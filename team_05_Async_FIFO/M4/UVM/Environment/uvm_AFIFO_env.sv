`include "uvm_macros.svh"

import uvm_pkg::*;
import uvm_AFIFO_agent_pkg::*;
`include "uvm_AFIFO_scoreboard.sv"

class uvm_AFIFO_env extends uvm_env;

    // ========== FACTORY REGISTRATION ==========
    `uvm_component_utils(uvm_AFIFO_env)

    // ========== COMPONENT HANDLES ==========
    uvm_AFIFO_agent      agent;      // Agent (contains driver, monitor, and sequencer)
    uvm_AFIFO_scoreboard#(8,3) scoreboard; // Scoreboard for checking DUT outputs

    // ========== CONSTRUCTOR ==========
    function new(string name = "uvm_AFIFO_env", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    // ========== BUILD PHASE ==========
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Create the agent
        agent = uvm_AFIFO_agent::type_id::create("agent", this);

        // Create the scoreboard
        scoreboard = uvm_AFIFO_scoreboard # (8,3)::type_id::create("scoreboard", this);

        // Create other components (e.g., coverage collector)
        // coverage = afifo_coverage::type_id::create("coverage", this);
    endfunction: build_phase

    // ========== CONNECT PHASE ==========
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        // Connect the monitor's analysis port to the scoreboard
        agent.afifo_mon.sb_export_mon.connect(scoreboard.sb_export_mon);

        // Connect the driver's analysis port to the scoreboard
        agent.afifo_drvr.sb_export_drv.connect(scoreboard.sb_export_drv);

        // Connect other components (e.g., coverage collector)
        // agent.monitor.analysis_port.connect(coverage.analysis_export);
    endfunction: connect_phase

endclass: uvm_AFIFO_env
