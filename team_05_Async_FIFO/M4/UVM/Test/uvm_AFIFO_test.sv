import uvm_pkg::*;
`include "uvm_macros.svh"
//`include "uvm_AFIFO_agent_pkg.sv" // Include the sequence file
import uvm_AFIFO_agent_pkg::*;
`include "../Environment/uvm_AFIFO_env.sv"

class uvm_AFIFO_test extends uvm_test;

// ========== FACTORY REGISTRATION ==========
    `uvm_component_utils(uvm_AFIFO_test)


// Handles
uvm_AFIFO_env env;


// ========== MEMORY CONSTRUCTOR ==========
    function new(string name = "uvm_AFIFO_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    // Build phase: Create and configure the testbench environment
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Create and configure the environment, agent, etc. (if needed)
        // Example:
        env = uvm_AFIFO_env::type_id::create("env", this);
    endfunction: build_phase

    // Run phase: Start the sequence and execute the test case
    task run_phase(uvm_phase phase);
        uvm_AFIFO_sequence seq;

        // Create the sequence
        seq = uvm_AFIFO_sequence::type_id::create(.name("seq"), .contxt(get_full_name()));

        // Start the sequence on the default sequencer
        seq.start(env.agent.afifo_seqr);

        // Execute the desired test case
        `uvm_info("TEST", "Running Test Case 1: Reset", UVM_LOW)
        seq.testcase1(); // Run Test Case 1

//        `uvm_info("TEST", "Running Test Case 2: Writes and Reads", UVM_LOW)
//        seq.testcase2(); // Run Test Case 2
//
//        `uvm_info("TEST", "Running Test Case 3: Write Full", UVM_LOW)
//        seq.testcase3(); // Run Test Case 3
//
//        `uvm_info("TEST", "Running Test Case 4: Read Empty", UVM_LOW)
//        seq.testcase4(); // Run Test Case 4
//
//        `uvm_info("TEST", "Running Test Case 5: Continuous Writes and Reads", UVM_LOW)
//        seq.testcase5(); // Run Test Case 5
    endtask: run_phase

endclass: uvm_AFIFO_test