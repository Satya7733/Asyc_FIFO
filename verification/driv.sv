

class driver;

virtual wr_intf wr_vif;
virtual rd_intf rd_vif;
mailbox gen2driv;
int no_transactions;

function new(virtual wr_intf wr_vif, virtual rd_intf rd_vif, mailbox gen2driv);
	this.wr_vif = wr_vif;
	this.rd_vif = rd_vif;
	this.gen2driv = gen2driv;
endfunction

//RESET TASK


task reset;
fork
	begin
		wait(wr_vif.wrst);
		$display("--------- [WRITE_DRIVER] Reset Started ---------");
		wr_vif.DRIVER.driver_cb.wren <= 0;
		wr_vif.DRIVER.driver_cb.idata <= 0;
		wait(!wr_vif.wrst);
		$display("--------- [WRITE_DRIVER] Reset Ended ---------");
	end

	begin
		wait(rd_vif.rrst);
		$display("--------- [READ_DRIVER] Reset Started ---------");
		rd_vif.DRIVER.driver_cb.rden <= 0;
//		rd_vif.DRIVER.driver_cb.odata <= 0;
		wait(!rd_vif.rrst);
		$display("--------- [READ_DRIVER] Reset Ended ---------");
	end
join
endtask	

task drive;
	forever begin
	transaction trans;
	wr_vif.DRIVER.driver_cb.wren <= 0;
	rd_vif.DRIVER.driver_cb.rden <= 0;
	gen2driv.get(trans);
	$display("--------- [DRIVER-TRANSFER: %0d] ---------",no_transactions);

	@(posedge wr_vif.DRIVER.wclk);
	wr_vif.DRIVER.driver_cb.idata <= trans.idata;
//	fork 
	if(trans.wren) begin
		wr_vif.DRIVER.driver_cb.wren <= trans.wren;
		trans.wr_full = wr_vif.DRIVER.driver_cb.wr_full;
		$display("\tWDATA = %0h \tWR_FULL = %0h", trans.idata, trans.wr_full);
		@(posedge wr_vif.DRIVER.wclk);
	end
	
	if(trans.rden) begin
		rd_vif.DRIVER.driver_cb.rden <= trans.rden;
		trans.odata = rd_vif.DRIVER.driver_cb.odata;
		trans.rd_empty = rd_vif.DRIVER.driver_cb.rd_empty;
		$display("\tRDATA = %0h \tRD_EMPTY = %0h", trans.odata, trans.rd_empty);
		@(posedge rd_vif.DRIVER.rclk);
		rd_vif.DRIVER.driver_cb.rden <= 0; 
	end

	$display("-----------------------------------------");
      	no_transactions++;
   	end
endtask

				
endclass
