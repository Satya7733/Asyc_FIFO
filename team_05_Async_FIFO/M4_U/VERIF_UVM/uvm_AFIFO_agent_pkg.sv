`include "uvm_macros.svh"
package uvm_AFIFO_agent_pkg;

//import uvm_pkg::*;

    //Include all components
	`include "uvm_AFIFO_Wr_sequence_item.sv" // Wr Transaction class
	`include "uvm_AFIFO_Rd_sequence_item.sv" // Rd Transaction class
	`include "uvm_AFIFO_Wr_sequencer.sv" // Wr Sequencer
	`include "uvm_AFIFO_Rd_sequencer.sv" // Rd Sequencer

//    `include "uvm_AFIFO_sequence.sv"    // Sequence class
//    `include "uvm_AFIFO_driver.sv"      // Driver class
//    `include "uvm_AFIFO_monitor.sv"     // Monitor class
//    `include "uvm_AFIFO_agent.sv"       // Agent class
//    `include "../Environment/uvm_AFIFO_scoreboard.sv"       // Scb class
//    `include "../Environment/uvm_AFIFO_env.sv"

endpackage: uvm_AFIFO_agent_pkg
