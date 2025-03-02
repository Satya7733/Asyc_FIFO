import AFIFO_Pkg::*;

class AFIFO_Driver #(parameter DSIZE = 8, parameter ASIZE = 3);

// Handle
 virtual AFIFO_Interface vif;
 AFIFO_Transaction tr;

//Event
event drv_nxt;
event gen_done;
event coverage_done; // Once all the test cases are done then to print the coverage report
// Variables
//logic [DSIZE-1:0] drv_wr_data_q[$];

//////////////* Mailbox*//////////////////
 mailbox #(AFIFO_Transaction) mbx_gen2drv; //generator to driver
 mailbox #(bit [DSIZE-1:0]) mbx_drv2sco;    // driver to scoreboard
 
//Constructor
 function new(mailbox #(AFIFO_Transaction) mbx_gen2drv,
		mailbox #(bit [DSIZE-1:0]) mbx_drv2sco);
 this.mbx_gen2drv = mbx_gen2drv;
 this.mbx_drv2sco = mbx_drv2sco;
// gen_done = new();
 endfunction
	
//Tasks
task reset(); // Test Case :1
`ifdef DEBUG
 $display("[DRV] ----------------------------------------");
 $display("[DRV] : RESET READ AND WRITE ");
 `endif
  vif.rd_rst <= 1'b1;
  $display("[DRIVER] : DRIVING RESET (5 WR_CLK) READ AND WRITE TO DUT");
 vif.wr_rst <= 1'b1;
  repeat(5) @(posedge vif.wr_clk);
 vif.rd_rst <= 1'b0; //Active Low Reset
 vif.wr_rst <= 1'b0;
 vif.rd_inc <= 1'b0;
 vif.wr_inc <= 1'b0;
 //drv_wr_data_q.delete();
 //$display("[DRV] : RESETED QUEUE (REF MODULE)");
 `ifdef DEBUG
 $display("[DRV] : RESETING FOR 5 WRITE CLK CYCLES");
 `endif 
 repeat(20) @(posedge vif.wr_clk);
 vif.rd_rst <= 1'b1;
 vif.wr_rst <= 1'b1;
 repeat(5) @(posedge vif.wr_clk);
 `ifdef DEBUG
 $display("[DRV] : RESET DONE");
 $display("[DRV] ----------------------------------------");
  `endif 
endtask

task write(input int drv_repeat_count); // Test Case :2
`ifdef DEBUG
  $display("[DRV] ----------------------------------------");
`endif 
 //$display("[DRV][WRITE] :DEBUG WAITING FOR GEN COMPLETE");
 ->drv_nxt; 
 //@gen_done;
//wait(gen_done.triggered);
 $display("[DRIVER][WRITE] : WRITE for %d times",drv_repeat_count);
 vif.wr_rst <= 1'b1;
 
 repeat(drv_repeat_count) begin
 	repeat(1) @(posedge vif.wr_clk);
	if(!vif.wr_full)begin
 	if(mbx_gen2drv.try_get(tr)); //$display("[DRV: DEBUG] [GET SUCCESS] Retrieved from mailbox");
	//else  $display("[DRV: DEBUG] [GET FAILED] Mailbox Empty");
	`ifdef DEBUG
	$display("[DRV][WRITE] : Mailbox.get done, gen2drv");
	`endif 
 	vif.wr_data <= tr.wr_data;
	vif.wr_inc <= 1'b1;
	
	$display("[DRIVER][WRITE] : WRITE INCREMENT HIGH, DATA = %d" ,tr.wr_data);
 	//drv_wr_data_q.push_back(tr.wr_data);
	mbx_drv2sco.put(tr.wr_data);
	`ifdef DEBUG
	$display("[DRV][WRITE] : Mailbox.put done, drv2sco");
	`endif 
	@(posedge vif.wr_clk); //Experimental
	vif.wr_inc <= 1'b0;
	->drv_nxt;
	end
 end
 `ifdef DEBUG
 $display("[DRV] ----------------------------------------");
 `endif 
endtask

task read(input int drv_repeat_count);
`ifdef DEBUG
 $display("[DRV] ----------------------------------------");
 `endif
 $display("[DRIVER][READ] : READ for %d times ",drv_repeat_count);
 vif.rd_rst <= 1'b1;

 repeat(drv_repeat_count) begin
	@(posedge vif.rd_clk);
	if(!vif.rd_empty) begin
 	
 	//mbx_gen2drv.get(tr);
	//$display("[DRV] : Mailbox.get done, gen2drv");
 	//vif.wr_data <= tr.wr_data;
	vif.rd_inc <= 1'b1;
	
	$display("[DRV][READ] : READ INCREMENT HIGH");

	//mbx_drv2sco.put(tr.wr_data);
	//$display("[DRV] : Mailbox.put done, drv2sco");
	@(posedge vif.rd_clk); //Experimental
	#5ns;
	vif.rd_inc <= 1'b0;
	end
 end
 `ifdef DEBUG
  $display("[DRV] ----------------------------------------");
  `endif 
endtask

task testcase1();
	$display("[DRIVER] : [Test Case] Reset  ");
 	reset();
endtask
task testcase2(); //test case 2
	$display("[DRIVER] : [Test Case] START: Writes and Reads");
 	reset();
	fork 
    begin
		//$display("[DRV] : ENTERED TASK WRITE");

        write(20); // Start writing
		//$display("[DRV] : EXITED TASK WRITE");

    end
    begin
       repeat(7) @(posedge vif.rd_clk); // Wait for 7 read clock cycles
       read(30); // Start reading after 7 cycles 37
    end
 	join 
	$display("[DRIVER] : [Test Case] DONE: Writes and Reads");
endtask

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
endtask

task testcase5();// test case 5
	$display("[DRV] : [Test Case 5] START: Continuous Writes and Reads");
 	reset();
	fork
//	write((1 << ASIZE)*2);
//	#1000ns read((1 << ASIZE)*2);
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
endtask

task run;
testcase1();
testcase2();// Reads and Writes
testcase2();
testcase2();
`ifdef OnlyWrite
testcase3(); //Only writes
`endif
`ifdef OnlyRead
testcase4(); //Only Reads
`endif
`ifdef ReadWrite
testcase5(); //Continuous Reads and Writes
`endif
->coverage_done; //event to print to coverage
//$finish;
endtask

endclass
