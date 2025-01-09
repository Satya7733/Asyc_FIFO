interface wr_mem_intf(input logic wclk, wrst);

logic [DATASIZE-1:0] idata;
logic wren;
logic wr_full;

clocking wr_driver_cb @(posedge wclk or posedge wrst);
	default input #0 output #0;		// why ???
	output idata;
	output wren;
	input wr_full;
endclocking

clocking wr_monitor_cb @(posedge wclk or posedge wrst);
	default input #0 output #0;
	input idata;
	input wren;
	input wr_full;
endclocking

modport wr_DRIVER (clocking wr_driver_cb, input wclk, wrst);
modport wr_MONITOR (clocking wr_monitor_cb, input wclk, input wrst);

endinterface
