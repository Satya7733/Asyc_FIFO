import AFIFO_Pkg::*;

class AFIFO_Driver #(parameter DSIZE = 8, parameter ASIZE = 3);

// ========== Instantiation ==========

 virtual AFIFO_Interface vif;
 AFIFO_Transaction tr;
 mailbox #(AFIFO_Transaction) mbx_gen2drv; //generator to driver
 mailbox #(bit [DSIZE-1:0]) mbx_drv2sco;    // driver to scoreboard

// ========== Event Declaration ==========
event driver_done;
 
// ========== Constructor ==========

 function new(mailbox #(AFIFO_Transaction) mbx_gen2drv, mailbox #(bit [DSIZE-1:0]) mbx_drv2sco);
 
 this.mbx_gen2drv = mbx_gen2drv;
 this.mbx_drv2sco = mbx_drv2sco;

 endfunction
	
// ========== RESET STATE ==========
task reset(); // Test Case :1
 $display("[DRV] : Entered Reset state");
 vif.rd_rst <= 1'b0; //Active Low Reset
 vif.wr_rst <= 1'b0;
 
 $display("[DRV] : RESETING FOR 5 WRITE CLK CYCLES");
 repeat(5) @(posedge vif.wr_clk);
 vif.rd_rst <= 1'b1;
 vif.wr_rst <= 1'b1;
 $display("[DRV] : Reset Done");
 $display("----------------------------------------");
endtask

// ========== WRITE TASK ==========

task write(input int drv_repeat_count); // Test Case :2

 
 $display("%tns, [DRV] :DEBUG WAITING FOR GEN COMPLETE", $time);
 ->drv_nxt; 
 //@gen_done;
//wait(gen_done.triggered);

 $display("[DRV] : WRITE for %d times",drv_repeat_count);
 vif.wr_rst <= 1'b1;
 
 repeat(drv_repeat_count) begin
 	@(posedge vif.wr_clk);

 	if(mbx_gen2drv.try_get(tr)) $display("[DRV: DEBUG] [GET SUCCESS] Retrieved from mailbox");
	else  $display("[DRV: DEBUG] [GET FAILED] Mailbox Empty");

	$display("[DRV] : Mailbox.get done, gen2drv");
 	vif.wr_data = tr.wr_data;
	vif.wr_inc = 1'b1;
	$display("[DRV] : Data Written to wr_data = %d" ,tr.wr_data);
 	//drv_wr_data_q.push_back(tr.wr_data);
	mbx_drv2sco.put(tr.wr_data);
	$display("[DRV] : Mailbox.put done, drv2sco");
	@(posedge vif.wr_clk); //Experimental
	vif.wr_inc = 1'b0;
	->driver_done;
 end

endtask

task read(input int drv_repeat_count);
 $display("[DRV] : READ for %d times ",drv_repeat_count);
 vif.rd_rst <= 1'b1;

 repeat(drv_repeat_count) begin
 	@(posedge vif.rd_clk);
 	//mbx_gen2drv.get(tr);
	//$display("[DRV] : Mailbox.get done, gen2drv");
 	//vif.wr_data <= tr.wr_data;
	vif.rd_inc <= 1'b1;
	$display("[DRV] : Data Read to rd_data");
	//mbx_drv2sco.put(tr.wr_data);
	//$display("[DRV] : Mailbox.put done, drv2sco");
	@(posedge vif.rd_clk); //Experimental
	vif.rd_inc <= 1'b0;
 end
endtask

task testcase1();
	$display("[DRV] : [Test Case 1] Reset");
 	reset();
endtask
task testcase2(); //test case 2
	$display("[DRV] : [Test Case 2] START: Writes and Reads");
 	reset();
	fork 
    begin
		$display("[DRV] : ENTERED TASK WRITE");

        write(20); // Start writing
		$display("[DRV] : EXITED TASK WRITE");

    end
    begin
       repeat(7) @(posedge vif.wr_clk); // Wait for 7 write clock cycles
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
testcase2();
testcase3();
testcase4();
testcase5();
$finish;
endtask

endclass
