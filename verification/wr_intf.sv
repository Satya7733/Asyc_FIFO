`include "../dut_new/pkg_graybin.svh"
import pkg_graybin::*;

interface wr_mem_intf(input logic wclk, wrst);

logic [DATASIZE-1:0] idata;
logic wren;
logic wr_full;

clocking driver_cb @(posedge wclk or posedge wrst);
	default input #0 output #0;		// why ???
	output idata;
	output wren;
	input wr_full;
endclocking

clocking monitor_cb @(posedge wclk or posedge wrst);
	default input #0 output #0;
	input idata;
	input wren;
	input wr_full;
endclocking

modport DRIVER (clocking driver_cb, input wclk, wrst);
modport MONITOR (clocking monitor_cb, input wclk, input wrst);

endinterface
