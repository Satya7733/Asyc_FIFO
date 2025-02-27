`include "uvm_macros.svh"


package uvm_AFIFO_agent_pkg;
import uvm_pkg::*;
    // Include all agent-related components
    `include "uvm_AFIFO_sequence_item.sv" // Transaction class
    `include "uvm_AFIFO_sequence.sv"    // Sequence class
    `include "uvm_AFIFO_driver.sv"      // Driver class
    `include "uvm_AFIFO_monitor.sv"     // Monitor class
<<<<<<< HEAD
//    `include "uvm_AFIFO_sequencer.sv"   // Sequencer class
=======
    //`include "uvm_AFIFO_sequencer.sv"   // Sequencer class
>>>>>>> 524a7a1be47adc9b81b18cebd9972d1dd130ed5b
    `include "uvm_AFIFO_agent.sv"       // Agent class

endpackage: uvm_AFIFO_agent_pkg