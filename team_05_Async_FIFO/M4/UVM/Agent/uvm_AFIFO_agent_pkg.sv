`include "uvm_macros.svh"
package uvm_AFIFO_agent_pkg;

    import uvm_pkg::*;

    // Include all agent-related components
    `include "uvm_AFIFO_transaction.sv" // Transaction class
    `include "uvm_AFIFO_sequence.sv"    // Sequence class
    `include "uvm_AFIFO_driver.sv"      // Driver class
    `include "uvm_AFIFO_monitor.sv"     // Monitor class
    `include "uvm_AFIFO_sequencer.sv"   // Sequencer class
    `include "uvm_AFIFO_agent.sv"       // Agent class

endpackage: uvm_AFIFO_agent_pkg