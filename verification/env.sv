`include "trans.sv"
`include "gen.sv"
`include "driv.sv"

class environment;

	generator gen;
	driver driv;

	mailbox gen2driv;

	event gen_ended;

	virtual wr_intf wr_vif;
	virtual rd_intf rd_vif;
	
	function new(virtual wr_intf wr_vif, virtual rd_intf rd_vif);
		this.wr_vif = wr_vif;
		this.rd_vif = rd_vif;
		
		gen2driv = new();

		gen = new(gen2driv, gen_ended);
		driv = new(wr_vif, rd_vif, gen2driv);
	endfunction

	task pre_test();
		driv.reset();
	endtask
	
	task test();
	fork 
		gen.main();
		driv.drive();
	join_any
	endtask

	task post_test();
		wait(gen_ended.triggered);
		wait(gen.repeat_count == driv.no_transactions);	
	endtask

	task run;
		pre_test();
		test();
		post_test();
		$finish;
	endtask	
	
endclass
