//Imports
import AFIFO_Pkg::*;

class AFIFO_Scoreboard #(parameter DSIZE = 8);

//Transaction class initialize
AFIFO_Transaction tr_mon2scb;
// Handle
 virtual AFIFO_Interface vif;
 
// Variables
bit [DSIZE-1:0] rd_data_dut; // DUT read data
reg [DSIZE -1 :0] wr_data_drv_q[$]; //Queue Driver to Scoreboard
bit[DSIZE-1 :0] get_wr_data_drv, ref_wr_data_drv;
//Mailbox
mailbox #(AFIFO_Transaction) mbx_mon2sco; // monitor to scoreboard
mailbox #(bit[DSIZE-1 :0]) mbx_drv2sco;  // driver to scoreboard

//Event 
//event sco_nxt;

//Constructor
function new(mailbox #(AFIFO_Transaction) mbx_mon2sco,
	     mailbox #(bit[DSIZE-1 :0]) mbx_drv2sco);
this.mbx_mon2sco = mbx_mon2sco;
this.mbx_drv2sco = mbx_drv2sco;
endfunction

task run();
//
tr_mon2scb = new();
fork 
begin
 forever begin
    mbx_drv2sco.get(get_wr_data_drv);//reference model Queue Implementation
    wr_data_drv_q.push_back(get_wr_data_drv); 

    mbx_mon2sco.get(tr_mon2scb);

    $display("[SCO]:----------------------------------------");
    if(tr_mon2scb.rd_empty) $display("[MON] : READ EMPTY, Nothing to read in FIFO Mem ");
    if(tr_mon2scb.wr_full) $display("[MON] : WRITE FULL, Full FIFO Mem ");

     if(tr_mon2scb.rd_inc && !tr_mon2scb.rd_empty)begin
        ref_wr_data_drv =  wr_data_drv_q.pop_front();
        if(tr_mon2scb.rd_data == ref_wr_data_drv) begin
         $display("[SCO]: SUCCESS, Data Matched : %d",tr_mon2scb.rd_data);
         end
        else begin
        $error("[SCO]: FAILED, Data NOT Matched : [DUT] %d != [DRV] %d",tr_mon2scb.rd_data, ref_wr_data_drv);
         end
     end
     $display("[SCO]:----------------------------------------");
 end
end

begin
    forever begin
         // if reset
    if(~tr_mon2scb.wr_rst || ~tr_mon2scb.rd_rst)begin
     wr_data_drv_q.delete();
    end
    end
end
join 
endtask

endclass
/*
 mbx_drv2sco.get(get_wr_data_drv);//reference model Queue Implementation
 wr_data_drv_q.push_back(get_wr_data_drv);
 mbx_mon2sco.get(rd_data_dut);

  $display("[SCO]:----------------------------------------");

 $display("[SCO]: Mailbox GET Mon -> Sco, rd_data = %d",rd_data_dut);
 if(vif.wr_inc) begin

 $display("[SCO]: Mailbox GET Drv -> Sco, wr_data_drv_q = %p",wr_data_drv_q);
 end
 
 // if reset
 if(~vif.wr_rst || ~vif.rd_rst)begin
 wr_data_drv_q.delete();
 //$display("[In condN]Queue data %d, QUEUE %p",ref_wr_data_drv, wr_data_drv_q );
 end

// if reading then compare
 if(vif.rd_inc && !vif.rd_empty)begin
	ref_wr_data_drv =  wr_data_drv_q.pop_front();
 // $display("Queue data %d, QUEUE %p",ref_wr_data_drv, wr_data_drv_q );
  if(rd_data_dut == ref_wr_data_drv) begin
  $display("[SCO]: SUCESS, Data Matched : %d",rd_data_dut);
  end
  else begin
  $error("[SCO]: FAILED, Data NOT Matched : [DUT] %d != [DRV] %d",rd_data_dut, ref_wr_data_drv);
  end
 end

 $display("[SCO] ----------------------------------");
 */


