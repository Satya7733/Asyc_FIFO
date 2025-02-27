import uvm_pkg::*;
`include "uvm_macros.svh"
import uvm_AFIFO_agent_pkg::*;
//import uvm_AFIFO_sequence_item::*;

class uvm_AFIFO_sequence extends uvm_sequence#(uvm_AFIFO_sequence_item);

	`uvm_object_utils(uvm_AFIFO_sequence)

	function new(string name = "");
		super.new(name);
	endfunction: new

	task body();
		uvm_AFIFO_sequence_item afifo_tx;

	repeat(15) begin		//can be configured through the UVM factory or testbench components
		afifo_tx = uvm_AFIFO_sequence_item#(8,3)::type_id::create(.name("afifo_tx"), .contxt(get_full_name()));

		start_item(afifo_tx); 		//sequence waits for the driver to be ready before sending the transaction
		assert(afifo_tx.randomize());
		finish_item(afifo_tx);		//sequence waits for the driver to complete execution of the current transaction.
	end
	endtask : body

	    // Test Case 1: Reset
    task testcase1();
        uvm_AFIFO_sequence_item afifo_tx;

        `uvm_info("SEQ", "Running Test Case 1: Reset", UVM_LOW)
        afifo_tx = uvm_AFIFO_sequence_item#(8,3)::type_id::create(.name("afifo_tx"), .contxt(get_full_name()));

        start_item(afifo_tx);
        afifo_tx.wr_rst = 1; // Assert write reset
        afifo_tx.rd_rst = 1; // Assert read reset
        finish_item(afifo_tx);
    endtask: testcase1
/*
    // Test Case 2: Writes and Reads
    task testcase2(int write_count = 20, int read_count = 20);
        uvm_AFIFO_sequence_item afifo_tx;

        `uvm_info("SEQ", "Running Test Case 2: Writes and Reads", UVM_LOW)

        fork
            // Write transactions
            begin
                repeat (write_count) begin
                    afifo_tx = uvm_AFIFO_sequence_item#(8,3)::type_id::create(.name("afifo_tx"), .contxt(get_full_name()));
                    start_item(afifo_tx);
                    afifo_tx.wr_data = $urandom(); // Randomize write data
                    afifo_tx.wr_inc  = 1;         // Assert write increment
                    finish_item(afifo_tx);
                end
            end

            // Wait for 7 read clock cycles, then read transactions
            begin
                repeat (7) @(posedge vif.rd_clk); // Wait for 7 read clock cycles
                repeat (read_count) begin
                    afifo_tx = uvm_AFIFO_sequence_item#(8,3)::type_id::create(.name("afifo_tx"), .contxt(get_full_name()));
                    start_item(afifo_tx);
                    afifo_tx.rd_inc = 1; // Assert read increment
                    finish_item(afifo_tx);
                end
            end
        join
    endtask: testcase2

    // Test Case 3: Write Full
    task testcase3();
        uvm_AFIFO_sequence_item afifo_tx;
        int write_count = (1 << 3) + 5; // ASIZE = 3, so 2^3 + 5 = 13

        `uvm_info("SEQ", "Running Test Case 3: Write Full", UVM_LOW)

        repeat (write_count) begin
            afifo_tx = uvm_AFIFO_sequence_item#(8,3)::type_id::create(.name("afifo_tx"), .contxt(get_full_name()));
            start_item(afifo_tx);
            afifo_tx.wr_data = $urandom(); // Randomize write data
            afifo_tx.wr_inc  = 1;         // Assert write increment
            finish_item(afifo_tx);
        end
    endtask: testcase3

    // Test Case 4: Read Empty
    task testcase4();
        uvm_AFIFO_sequence_item afifo_tx;
        int write_count = (1 << 3); // ASIZE = 3, so 2^3 = 8
        int read_count  = (1 << 3) + 5; // ASIZE = 3, so 2^3 + 5 = 13

        `uvm_info("SEQ", "Running Test Case 4: Read Empty", UVM_LOW)

        // Write transactions
        repeat (write_count) begin
            afifo_tx = uvm_AFIFO_sequence_item#(8,3)::type_id::create(.name("afifo_tx"), .contxt(get_full_name()));
            start_item(afifo_tx);
            afifo_tx.wr_data = $urandom(); // Randomize write data
            afifo_tx.wr_inc  = 1;         // Assert write increment
            finish_item(afifo_tx);
        end

        // Read transactions
        repeat (read_count) begin
            afifo_tx = uvm_AFIFO_sequence_item#(8,3)::type_id::create(.name("afifo_tx"), .contxt(get_full_name()));
            start_item(afifo_tx);
            afifo_tx.rd_inc = 1; // Assert read increment
            finish_item(afifo_tx);
        end
    endtask: testcase4

    // Test Case 5: Continuous Writes and Reads
    task testcase5();
        uvm_AFIFO_sequence_item afifo_tx;
        int write_count = (1 << 3) * 2; // ASIZE = 3, so 2^3 * 2 = 16
        int read_count  = (1 << 3) * 2; // ASIZE = 3, so 2^3 * 2 = 16

        `uvm_info("SEQ", "Running Test Case 5: Continuous Writes and Reads", UVM_LOW)

        fork
            // Write transactions
            begin
                repeat (write_count) begin
                    afifo_tx = uvm_AFIFO_sequence_item#(8,3)::type_id::create(.name("afifo_tx"), .contxt(get_full_name()));
                    start_item(afifo_tx);
                    afifo_tx.wr_data = $urandom(); // Randomize write data
                    afifo_tx.wr_inc  = 1;         // Assert write increment
                    finish_item(afifo_tx);
                end
            end

            // Wait for 10 read clock cycles, then read transactions
            begin
                repeat (10) @(posedge vif.rd_clk); // Wait for 10 read clock cycles
                repeat (read_count) begin
                    afifo_tx = uvm_AFIFO_sequence_item#(8,3)::type_id::create(.name("afifo_tx"), .contxt(get_full_name()));
                    start_item(afifo_tx);
                    afifo_tx.rd_inc = 1; // Assert read increment
                    finish_item(afifo_tx);
                end
            end
        join
    endtask: testcase5
*/
		
endclass : uvm_AFIFO_sequence

typedef uvm_sequencer#(uvm_AFIFO_sequence_item) uvm_AFIFO_sequencer;