import AFIFO_Pkg::*;

class AFIFO_Driver #(parameter DSIZE = 8, parameter ASIZE = 3);

// Handle
 virtual AFIFO_Interface vif;
 AFIFO_Transaction tr;

//Event
event drv_nxt;
event gen_done;
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
 $display("[DRV] ----------------------------------------");
 $display("[DRV] : RESET READ AND WRITE ");
  vif.rd_rst <= 1'b1;
 vif.wr_rst <= 1'b1;
  repeat(5) @(posedge vif.wr_clk);
 vif.rd_rst <= 1'b0; //Active Low Reset
 vif.wr_rst <= 1'b0;
 vif.rd_inc <= 1'b0;
 vif.wr_inc <= 1'b0;
 //drv_wr_data_q.delete();
 //$display("[DRV] : RESETED QUEUE (REF MODULE)");
 $display("[DRV] : RESETING FOR 5 WRITE CLK CYCLES");
 repeat(20) @(posedge vif.wr_clk);
 vif.rd_rst <= 1'b1;
 vif.wr_rst <= 1'b1;
 repeat(5) @(posedge vif.wr_clk);
 $display("[DRV] : RESET DONE");
 $display("[DRV] ----------------------------------------");
endtask

task write(input int drv_repeat_count); // Test Case :2
  $display("[DRV] ----------------------------------------");
 //$display("[DRV][WRITE] :DEBUG WAITING FOR GEN COMPLETE");
 ->drv_nxt; 
 //@gen_done;
//wait(gen_done.triggered);
 $display("[DRV][WRITE] : WRITE for %d times",drv_repeat_count);
 vif.wr_rst <= 1'b1;
 
 repeat(drv_repeat_count) begin
 	repeat(5) @(posedge vif.wr_clk);

 	if(mbx_gen2drv.try_get(tr)); //$display("[DRV: DEBUG] [GET SUCCESS] Retrieved from mailbox");
	//else  $display("[DRV: DEBUG] [GET FAILED] Mailbox Empty");

	$display("[DRV][WRITE] : Mailbox.get done, gen2drv");
 	vif.wr_data <= tr.wr_data;
	vif.wr_inc <= 1'b1;
	$display("[DRV][WRITE] : Data Written to wr_data = %d" ,tr.wr_data);
 	//drv_wr_data_q.push_back(tr.wr_data);
	mbx_drv2sco.put(tr.wr_data);
	$display("[DRV][WRITE] : Mailbox.put done, drv2sco");
	@(posedge vif.wr_clk); //Experimental
	vif.wr_inc <= 1'b0;
	->drv_nxt;
 end
 $display("[DRV] ----------------------------------------");
endtask

task read(input int drv_repeat_count);
 $display("[DRV] ----------------------------------------");
 $display("[DRV][READ] : READ for %d times ",drv_repeat_count);
 vif.rd_rst <= 1'b1;

 repeat(drv_repeat_count) begin
 	@(negedge vif.rd_clk);
 	//mbx_gen2drv.get(tr);
	//$display("[DRV] : Mailbox.get done, gen2drv");
 	//vif.wr_data <= tr.wr_data;
	vif.rd_inc <= 1'b1;
	$display("[DRV][READ] : Data Read to rd_data");
	//mbx_drv2sco.put(tr.wr_data);
	//$display("[DRV] : Mailbox.put done, drv2sco");
	@(negedge vif.rd_clk); //Experimental
	vif.rd_inc <= 1'b0;
 end
  $display("[DRV] ----------------------------------------");
endtask

task testcase1();
	$display("[DRV] : [Test Case 1] Reset  ");
 	reset();
endtask
task testcase2(); //test case 2
	$display("[DRV] : [Test Case 2] START: Writes and Reads");
 	reset();
	fork 
    begin
		//$display("[DRV] : ENTERED TASK WRITE");

        write(20); // Start writing
		//$display("[DRV] : EXITED TASK WRITE");

    end
    begin
       repeat(7) @(posedge vif.rd_clk); // Wait for 7 read clock cycles
       read(20); // Start reading after 7 cycles
    end
 	join 
	$display("[DRV] : [Test Case 2] DONE: Writes and Reads");
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
	write(1 << ASIZE*2);
	#100 read((1 << ASIZE)*2);
	join
	reset();
	$display("[DRV] : [Test Case 5] DONE: Continuous Writes and Reads");
	
	$display("[DRV] : Drv_nxt");
endtask

task run;
testcase1();
testcase2();// Reads and Writes
testcase3(); //Only writes
testcase4(); //Only Reads
testcase5(); //Continuous Reads and Writes
$finish;
endtask

endclass
