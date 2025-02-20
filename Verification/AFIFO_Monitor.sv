//imports
import AFIFO_Pkg::*;

//class
class AFIFO_Monitor #(parameter DSIZE = 8);

//Transaction class initialize
AFIFO_Transaction tr_mon2scb;

// Handle
virtual AFIFO_Interface vif_mon;

//Mailbox mon to sco
mailbox #(AFIFO_Transaction) mbx_mon2sco;
//mailbox #(bit[DSIZE-1:0]) mbx_mon2sco_ref;


//Constructor
function new(mailbox #(AFIFO_Transaction) mbx_mon2sco);
 this.mbx_mon2sco = mbx_mon2sco;
endfunction

//Ref Module
reg [DSIZE -1 :0] wr_data_drv_q[$]; //Queue Driver to Scoreboard
bit[DSIZE-1 :0] ref_wr_data_drv;

//Event
event mon_done;
//Task
task run();
 tr_mon2scb = new();
//forever begin
 /*   
 @(posedge vif.rd_clk); 
 if(vif.rd_inc && !vif.rd_empty) begin
 mbx_mon2sco.put(vif.rd_data);
  $display("[MON]:----------------------------------------");
 $display("[MON]: MBX DATA SENT TO SCO %0d ", vif.rd_data);
 
 end
   $display("[MON]:----------------------------------------");
 if(vif.rd_empty) $display("[MON] : READ EMPTY, Nothing to read in FIFO Mem ");
 if(vif.wr_full) $display("[MON] : WRITE FULL, Full FIFO Mem ");
  $display("[MON]:----------------------------------------");
 */
// @(posedge vif_mon.wr_inc); 
fork
	begin 
	forever begin
	@(posedge vif_mon.wr_clk); 
	if(vif_mon.wr_inc) begin
	$display($time,"[MON]: DATA WRITTEN TO REF MODULE %0d ", vif_mon.wr_data);
	wr_data_drv_q.push_back(vif_mon.wr_data);
	
	end // @(posedge vif_mon.rd_inc); 
	end
	end	

	begin
	forever begin
	@(posedge vif_mon.rd_clk);
	if(vif_mon.rd_inc || vif_mon.rd_empty || vif_mon.wr_full || ~vif_mon.rd_rst || ~vif_mon.rd_rst) begin 
	$display($time,"[MON]:Entered Loop sending Tr class");
	//5ns
	 tr_mon2scb.rd_data = vif_mon.rd_data;
	 tr_mon2scb.wr_inc = vif_mon.wr_inc;
	 tr_mon2scb.rd_inc = vif_mon.rd_inc;
	 tr_mon2scb.wr_rst = vif_mon.wr_rst;
	 tr_mon2scb.rd_rst = vif_mon.rd_rst;
	 tr_mon2scb.rd_empty = vif_mon.rd_empty;
	 tr_mon2scb.wr_full = vif_mon.wr_full;
	 if(vif_mon.rd_inc)begin 
	tr_mon2scb.rd_data_refModule =  wr_data_drv_q.pop_front();
	$display("popped data is: %d",  tr_mon2scb.rd_data_refModule);
	end
	$display($time,"[MON]: rd_inc = %d, wr_inc = %d", tr_mon2scb.rd_inc, tr_mon2scb.wr_inc);
	if(vif_mon.rd_inc)$display($time,"[MON]: MBX DATA SENT TO SCO %0d, and ref MOD : %d ", tr_mon2scb.rd_data, tr_mon2scb.rd_data_refModule);
	 mbx_mon2sco.put(tr_mon2scb);
	if(vif_mon.rd_inc)$display($time,"[MON]: MBX DATA SENT TO SCO %0d, and ref MOD : %d ", tr_mon2scb.rd_data, tr_mon2scb.rd_data_refModule);
	 ->mon_done;
	if(vif_mon.rd_inc)$display($time,"[MON]: MBX DATA SENT TO SCO %0d, and ref MOD : %d ", tr_mon2scb.rd_data, tr_mon2scb.rd_data_refModule);
	//$display("[MON]:----------------------------------------");
	end else begin
	wait(vif_mon.rd_inc || vif_mon.wr_inc);
	end
	end
	end
join_none
//end
endtask

endclass