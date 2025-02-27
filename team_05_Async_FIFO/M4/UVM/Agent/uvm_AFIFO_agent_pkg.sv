`include "uvm_macros.svh"


package uvm_AFIFO_agent_pkg;
import uvm_pkg::*;
    // Include all agent-related components
    `include "uvm_AFIFO_sequence_item.sv" // Transaction class
    `include "uvm_AFIFO_sequence.sv"    // Sequence class
    `include "uvm_AFIFO_driver.sv"      // Driver class
    `include "uvm_AFIFO_monitor.sv"     // Monitor class
    `include "uvm_AFIFO_agent.sv"       // Agent class
//    `include "../Environment/uvm_AFIFO_scoreboard.sv"       // Scb class
//    `include "../Environment/uvm_AFIFO_env.sv"

endpackage: uvm_AFIFO_agent_pkg