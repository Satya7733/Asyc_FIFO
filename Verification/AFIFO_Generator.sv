import AFIFO_Pkg::*;

class AFIFO_Generator;

AFIFO_Transaction tr;

mailbox #(AFIFO_Transaction) mbx_gen2drv;

event gen_done;
event sco_nxt;
event drv_nxt;

//int count = 0;

function new(mailbox #(AFIFO_Transaction) mbx_gen2drv);
this.mbx_gen2drv = mbx_gen2drv;
tr = new();
 //this.gen_done = gen_done;
endfunction

task run();

forever begin 
	wait( drv_nxt.triggered);
	 $display("[GEN] ----------------------------------------");
	assert(tr.randomize) else $error("[GEN]: Randomization Failed");
	if(mbx_gen2drv.try_put(tr.copy)) $display("[GEN] [PUT SUCCESS] placed in mailbox"); // Tranfer the randomized values to driver 
	else $display("[GEN] [PUT FAILED]: Mailbox full, could not put ");
	$display("[GEN] Generated Write Data : %0d", tr.wr_data);
	#2;
    //->gen_done;
$display("[GEN] completed");
 $display("[GEN] ----------------------------------------");
	//drvnext.triggered;
	//sconext.triggered;
	
	//@drv_nxt;
	//$display("[GEN] DEBUG Drive Completed");
	//wait( sco_nxt.triggered);
	end	

endtask


endclass
