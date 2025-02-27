import uvm_pkg::*;
`include "uvm_macros.svh"
`include "uvm_AFIFO_agent_pkg.sv"

class uvm_AFIFO_driver#(int DSIZE = 8, int ASIZE = 3) extends uvm_driver #(uvm_AFIFO_sequence_item);

// ========== FACTORY REGISTRATION ==========
`uvm_component_utils(uvm_AFIFO_driver#(8,3)) 
// ========== Handle ==========
 virtual uvm_AFIFO_interface vif;
//int DSIZE  = DSIZE;
//int ASIZE = ASIZE;
// Sequence Item Port: For receiving sequence items from the sequencer
 uvm_seq_item_pull_port #(uvm_AFIFO_sequence_item) seq_item_port;

// Analysis Port: For sending data to the scoreboard
 uvm_analysis_port #(bit [DSIZE-1:0]) sb_export_drv;

//========== Event ==========
event drv_nxt;
event gen_done;

// ========== MEMORY CONSTRUCTOR ==========

function new(string name = "uvm_AFIFO_driver", uvm_component parent);
    super.new(name,parent);
endfunction: new

// ========== Build Phase: Configure parameters using config_db and get virtual interface ==========  

     function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        seq_item_port = new("seq_item_port", this); // Create the sequence item port
        sb_export_drv = new("analysis_port", this); // Create the analysis port

	//----- Get DSIZE AND ASIZE from config_db -----
	if(!uvm_config_db#(int)::get(this, "", "DSIZE", DSIZE)) begin
	  `uvm_fatal("AFIFO_DRIVER", "DSIZE not set in config_db!")
        end

        if (!uvm_config_db#(int)::get(this, "", "ASIZE", ASIZE)) begin
        `uvm_fatal("AFIFO_DRIVER", "ASIZE not set in config_db!")
        end

	//----- Get the virtual interface from config_db -----
        if (!uvm_config_db#(virtual afifo_if)::get(this, "", "vif", vif)) begin
          `uvm_fatal("AFIFO_DRIVER", "Virtual interface not set!")
        end
    endfunction : build_phase
// ========== CONNECT PHASE ==========

virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    // Connect sequence item port to sequencer
    seq_item_port.connect(sequencer.seq_item_export);

    // Connect analysis port to scoreboard
    analysis_port.connect(scoreboard.sb_export_drv);
        
        // DEBUG STATEMENT
        `uvm_info("DRV", "Driver connected to scoreboard", UVM_LOW)

endfunction

	
	
//Tasks
task reset(); // Test Case :1
 $display("[DRV] ----------------------------------------");
 $display("[DRV] : RESET READ AND WRITE ");
   vif.rd_rst <= 1'b1;
   vif.wr_rst <= 1'b1;
 repeat(5) @(posedge vif.wr_clk);
   vif.rd_rst <= 1'b0; //Active Low Reset
   vif.wr_rst <= 1'b0;
   vif.rd_inc <= 1'b0;
   vif.wr_inc <= 1'b0;
 $display("[DRV] : RESETING FOR 5 WRITE CLK CYCLES");
 repeat(20) @(posedge vif.wr_clk);
   vif.rd_rst <= 1'b1;
   vif.wr_rst <= 1'b1;
 repeat(5) @(posedge vif.wr_clk);
   $display("[DRV] : RESET DONE");
   $display("[DRV] ----------------------------------------");
endtask

// ========== WRITE TASK ==========
task write(input int drv_repeat_count);
  $display("[DRV] ----------------------------------------");
  ->drv_nxt; 
 $display("[DRV][WRITE] : WRITE for %d times",drv_repeat_count);
  vif.wr_rst <= 1'b1;
 
 repeat(drv_repeat_count) begin
 	@(posedge vif.wr_clk);
	if(!vif.wr_full)begin
	uvm_AFIFO_sequence_item seq_item; // Handle for afifo_seq_item
	seq_item_port.get(seq_item); // Receieve item from sequencer


 	vif.wr_data <= seq_item.wr_data;
	vif.wr_inc <= 1'b1;
	$display("[DRV][WRITE] : Data Written to wr_data = %d" ,seq_item.wr_data);

// Send the data to scoreboard using analysis port
	analysis_port.write(seq_item.wr_data);


	@(posedge vif.wr_clk); //Experimental
	vif.wr_inc <= 1'b0;
	->drv_nxt;
	end
 end
 $display("[DRV] ----------------------------------------");
endtask: write

task read(input int drv_repeat_count);
 $display("[DRV] ----------------------------------------");
 $display("[DRV][READ] : READ for %d times ",drv_repeat_count);
 vif.rd_rst <= 1'b1;

 repeat(drv_repeat_count) begin
	@(posedge vif.rd_clk);
	if(!vif.rd_empty) begin
	    vif.rd_inc <= 1'b1;
	    $display("[DRV][READ] : Data Read to rd_data");
	
	    @(posedge vif.rd_clk); //Experimental
//	#5ns;
	    vif.rd_inc <= 1'b0;
	end
 end
  $display("[DRV] ----------------------------------------");
endtask: read


task run;
  testcase1();
  testcase2();// Reads and Writes
  //testcase3(); //Only writes
  //testcase4(); //Only Reads
  //testcase5(); //Continuous Reads and Writes
  $finish;
endtask: run

/*
task testcase1();
    $display("[DRV] : [Test Case 1] Reset");
    reset();
endtask: testcase1

task testcase2(); //test case 2
	$display("[DRV] : [Test Case 2] START: Writes and Reads");
 	reset();
	fork 
    begin
        write(20); // Start writing
    end

    begin
       repeat(7) @(posedge vif.rd_clk); // Wait for 7 read clock cycles
       read(20); // Start reading after 7 cycles
    end
 	join 
$display("[DRV] : [Test Case 2] DONE: Writes and Reads");
endtask: testcase2

task testcase3();// test case 3
    $display("[DRV] : [Test Case 3] START: Write Full");
      reset();
      write((1 << ASIZE) + 5);
    $display("[DRV] : [Test Case 3] DONE: Write Full");
endtask

task testcase4();// test case 4
    $display("[DRV] : [Test Case 4] START: Read Empty");
      reset();
      write(1 << ASIZE);
      read((1 << ASIZE) + 5);
    $display("[DRV] : [Test Case 4] DONE: Read Empty");
endtask: testcase4

task testcase5();// test case 5
    $display("[DRV] : [Test Case 5] START: Continuous Writes and Reads");
      reset();
	fork
          begin
            write((1 << ASIZE) * 2);  // Start write operation immediately
          end

          begin
            repeat(10) @(vif.rd_clk); // Wait for 10 clock cycles
            read((1 << ASIZE) * 2);    // Perform read after delay
          end
	join
reset();
$display("[DRV] : [Test Case 5] DONE: Continuous Writes and Reads");
$display("[DRV] : Drv_nxt");
endtask: testcase5
*/

endclass: uvm_AFIFO_driver
