`include "uvm_macros.svh"
import uvm_pkg::*;
import uvm_AFIFO_agent_pkg::*;

class uvm_AFIFO_env extends uvm_env;

    // ========== FACTORY REGISTRATION ==========
    `uvm_component_utils(uvm_AFIFO_env)

    // ========== COMPONENT HANDLES ==========
    uvm_AFIFO_Rd_agent      Rd_agent;      // Agent (contains driver, monitor, and sequencer)
    uvm_AFIFO_Wr_agent      Wr_agent;      // Agent (contains driver, monitor, and sequencer)
    uvm_AFIFO_scoreboard  scoreboard; // Scoreboard for checking DUT outputs

    // ========== CONSTRUCTOR ==========
    function new(string name = "uvm_AFIFO_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    // ========== BUILD PHASE ==========
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Create the agent
        Rd_agent = uvm_AFIFO_Rd_agent::type_id::create("Rd_agent", this);
        Wr_agent = uvm_AFIFO_Wr_agent::type_id::create("Wr_agent", this);

        // Create the scoreboard
        scoreboard = uvm_AFIFO_scoreboard::type_id::create("scoreboard", this);

    endfunction: build_phase

    // ========== CONNECT PHASE ==========
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        Wr_agent.wr_mon.sb_export_mon.connect(scoreboard.imp_wr);	//Connecting Write Monitor and Scoreboard
        Rd_agent.rd_mon.mon_port_cov.connect(scoreboard.imp_rd); //Connectiong Read Monitor and Scoreboard


    endfunction: connect_phase

endclass: uvm_AFIFO_env
