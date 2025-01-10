`include "../dut_new/pkg_graybin.svh"
import pkg_graybin::*;

class transaction;

rand bit [DATASIZE-1:0] idata;
rand bit 		wren;
rand bit 		rden;
bit 			wrst;
bit			rrst;
bit			wclk;
bit 			rclk;
bit 			wr_full;
bit 			rd_empty;
bit 			[DATASIZE-1:0] odata;

endclass : transaction

