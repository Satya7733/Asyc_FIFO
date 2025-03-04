
`include "uvm_macros.svh"
import uvm_pkg::*;

package uvm_AFIFO_agent_pkg;


    //Include all components
 

	`include "uvm_AFIFO_Rd_sequence_item.sv" // Rd Transaction class
	`include "uvm_AFIFO_Rd_sequencer.sv" // Rd Sequencer
    `include "uvm_AFIFO_Rd_seq.sv" // Rd Sequence class
    `include "uvm_AFIFO_Rd_driver.sv"      // Driver class
    `include "uvm_AFIFO_Rd_monitor.sv"     // Monitor class
    `include "uvm_AFIFO_Rd_cov.sv"		//Coverage class
    `include "uvm_AFIFO_Rd_agent.sv"  

    `include "uvm_AFIFO_Wr_sequence_item.sv" // Wr Transaction class
    `include "uvm_AFIFO_Wr_sequencer.sv" // Wr Sequencer
    `include "uvm_AFIFO_Wr_sequence.sv"    // Sequence class
    `include "uvm_AFIFO_Wr_driver.sv"      // Driver class
    `include "uvm_AFIFO_Wr_monitor.sv"     // Monitor class
	`include "uvm_AFIFO_Wr_cov.sv"		//Coverage class
    `include "uvm_AFIFO_Wr_agent.sv"       // Agent class
    
    `include "uvm_AFIFO_scoreboard.sv" // Scb class
    `include "uvm_AFIFO_env.sv"  
    //`include "uvm_AFIFO_test.sv"  
  
//    `include "../Environment/uvm_AFIFO_env.sv"

endpackage: uvm_AFIFO_agent_pkg
