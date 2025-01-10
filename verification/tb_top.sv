`include "pkg_tb.svh"

module tb_top;
	
bit wclk, rclk;
bit wrst, rrst;

always #5 wclk = ~wclk;
always #7 rclk = ~rclk;

initial begin
	wrst = 1;
	rrst = 1;
	# 5;
	wrst = 0;
	rrst = 0;
end

wr_intf wr_intf(wclk, wrst);
rd_intf rd_intf(rclk, rrst);

FIFO_top DUT (
	.i_wclk(wr_intf.wclk),
	.i_rclk(rd_intf.rclk),
	.i_rrst(rd_intf.rrst),
	.i_wrst(wr_intf.wrst),
	.i_data(wr_intf.idata),
	.o_data(rd_intf.odata),
	.i_wren(wr_intf.wren),
	.i_rden(rd_intf.rden),
	.w_wr_full(wr_intf.wr_full),
	.w_rd_empty(rd_intf.rd_empty)
);

test t1(wr_intf, rd_intf);

inital begin
	$dumpfile("dump.vcd"); $dumpvars;
end

endmodule
