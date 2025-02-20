//Imports
import AFIFO_Pkg::*;

class AFIFO_Scoreboard #(parameter DSIZE = 8);

//Transaction class initialize
AFIFO_Transaction tr_mon2scb;
// Handle
 virtual AFIFO_Interface vif;
 
// Variables
bit [DSIZE-1:0] rd_data_dut; // DUT read data
//reg [DSIZE -1 :0] wr_data_drv_q[$]; //Queue Driver to Scoreboard
bit[DSIZE-1 :0] get_wr_data_drv, ref_wr_data_drv;
integer i = 1;
//Mailbox
mailbox #(AFIFO_Transaction) mbx_mon2sco; // monitor to scoreboard
mailbox #(bit[DSIZE-1 :0]) mbx_drv2sco;  // driver to scoreboard
//mailbox #(bit[DSIZE-1:0]) mbx_mon2sco_ref; // monitor to
//Event 
event mon_done;

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

 forever begin
   //$display("[SCO]:In forever loop");
   //@(posedge tr_mon2scb.rd_inc);
        @mon_done;
   mbx_mon2sco.get(tr_mon2scb);
   `ifdef DEBUG 
    $display($time,"[SCO]:----------------------------------------");
    `endif 
   //$display("[SCO]:WR INC %d ",vif.wr_inc);

/*
if(tr_mon2scb.wr_inc && !tr_mon2scb.rd_inc) begin
  // $display("[SCO]:Entered ref block Ref Model %p ==================================================== ",get_wr_data_drv);
   mbx_drv2sco.get(get_wr_data_drv);//reference model Queue Implementation
  // $display("[SCO]:Got the data from mbx ref block Ref Model %p ==================================================== ",get_wr_data_drv);
    wr_data_drv_q.push_back(get_wr_data_drv); 
   $display("[SCO]:Data Written in Ref Model %p ========================================================",get_wr_data_drv);
  end else if(tr_mon2scb.rd_inc && !tr_mon2scb.wr_inc) begin
   
    if(!mbx_mon2sco.try_get(tr_mon2scb)) $display("Failed to get the data ==========================================================");
    else $display("SUCCESS to get the data ==========================================================");
  */


  /*
    if(!tr_mon2scb.wr_rst || !tr_mon2scb.rd_rst)begin    
     wr_data_drv_q.delete();
     $display("[SCO] : RESETTING the Reference Module %p ", wr_data_drv_q.pop_front());
    end
  */
@(posedge vif.rd_clk);
`ifdef DEBUG 
   $display($time," [SCO]: gOt the data rd_data = %d ==========================================================",tr_mon2scb.rd_data);
	 $display($time,"tr_mon2scb.rd_inc : %d, tr_mon2scb.rd_empty : %d, tr_mon2scb.rd_clk is : %d ", tr_mon2scb.rd_inc, tr_mon2scb.rd_empty, tr_mon2scb.rd_clk);
`endif 
     if(tr_mon2scb.rd_inc)begin
      //$display("[SCO] : GOT INSIDE the CHECKER LOOP]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]] ");
       // @(posedge tr_mon2scb.rd_clk);
        //ref_wr_data_drv =  wr_data_drv_q.pop_front();
	//$display("Queue popping done");
        if(tr_mon2scb.rd_data == tr_mon2scb.rd_data_refModule) begin
         $display("=================================================");
         $display("[SCB]: [ID = %d] MATCHED, READ DATA : %d", i++, tr_mon2scb.rd_data);
         $display("=================================================");
         end
        else begin
        $display("=================================================");
        $error("[SCB]:  [ID = %d] MISMATCHED, READ DATA : [DUT] %d != [REF MODULE] %d",i++, tr_mon2scb.rd_data, tr_mon2scb.rd_data_refModule);
        $display("=================================================");
          //foreach (wr_data_drv_q[i]) begin
       // $display("my_queue[%0d] = %0d", i, wr_data_drv_q[i]);
        // end
         end
     end 

    if(tr_mon2scb.rd_empty) begin
      $display("=================================================");
      $display("[SCB]: READ EMPTY ");
      $display("=================================================");
    end
    if(tr_mon2scb.wr_full) begin
      $display("=================================================");
      $display("[SCB]: WRITE FULL ");
      $display("=================================================");
    end
   // else $display("[SCO] :rd_inc = %d, rd_emp = %d NOT IN CHECKER LOOP]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]] "
    // ,tr_mon2scb.rd_inc,tr_mon2scb.rd_empty);
    `ifdef DEBUG 
     $display($time,"[SCO]:----------------------------------------");
     `endif
 end

//
//begin
//    forever begin
//         
//    end
//end

join
endtask

endclass

