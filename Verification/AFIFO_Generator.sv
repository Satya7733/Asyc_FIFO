import AFIFO_Pkg::*;

class AFIFO_Generator;

AFIFO_Transaction tr;

mailbox #(AFIFO_Transaction) mbx_gen2drv;

event gen_done;
event sco_nxt;
event drv_nxt;

int count = 0;

function new(mailbox #(AFIFO_Transaction) mbx_gen2drv);
this.mbx_gen2drv = mbx_gen2drv;
tr = new();
endfunction

task run();

repeat(count) begin 
	assert(tr.randomize) else $error("[GEN]: Randomization Failed");
	mbx_gen2drv.put(tr.copy); // Tranfer the randomized values to driver 
	$display("[GEN] Write Data : %0d", tr.wr_data);
	//drvnext.triggered;
	//sconext.triggered;
	wait( drv_nxt.triggered);
	wait( sco_nxt.triggered);
	end	
-> gen_done;
endtask


endclass
