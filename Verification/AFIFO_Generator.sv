import AFIFO_Pkg::*;

class AFIFO_Generator;

AFIFO_Transaction tr;

mailbox mbx_gen2drv;

event gen_done;
event scb_done;
event driver_done;

int count = 0;

function new(mailbox mbx_gen2drv);
	tr = new();
	this.mbx_gen2drv = mbx_gen2drv;
endfunction

task run();
$display("[GEN] : INSIDE GENERATOR");

repeat(this.count) begin
	if(tr.randomize)
	$display("[GEN]: Randomization Done");
	else
	$error("[GEN]: Randomization Failed");

// PUTTING THE GENERATED VALUES
mbx_gen2drv.put(tr); 
	$display("[GEN] Generated Write Data : %0d", tr.wr_data); // PRINTING THE GENERATED WRITE VALUE

	$display("[GEN]: Waiting for driver to get completed"); // debug

	@(driver_done);

	$display("[GEN]: Driver got completed"); // debug

	#5 scb_done.triggered;

	#10 $display("[GEN]: Scoreboard got completed"); // debug
end

-> gen_done;

$display("[GEN] Generation completed");

endtask
endclass
/*
	assert(tr.randomize) else $error("[GEN]: Randomization Failed");
	if(mbx_gen2drv.try_put(tr.copy)) $display("[GEN: DEBUG [PUT SUCCESS] placed in mailbox"); // Tranfer the randomized values to driver 
	else $display("[GEN: DEBUG] [PUT FAILED]: Mailbox full, could not put ");
	$display("[GEN] Generated Write Data : %0d", tr.wr_data);
	#2;
    -> gen_done;
$display("[GEN] completed");
	//drvnext.triggered;
	//sconext.triggered;
	wait( drv_nxt.triggered);
	//@drv_nxt;
	$display("[GEN] DEBUG Drive Completed");
	//wait( sco_nxt.triggered);
	end	

endtask


endclass*/
