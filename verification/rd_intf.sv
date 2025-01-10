`include "../dut_new/pkg_graybin.svh"
import pkg_graybin::*;

interface rd_mem_intf(input logic rclk, rrst);

logic [DATASIZE-1:0] odata;
logic rden;
logic rd_empty;

clocking rd_driver_cb @(posedge rclk or posedge rrst);
	default input #0 output #0;		// why ???
	input odata;
	output rden;
	input rd_empty;
endclocking

clocking rd_monitor_cb @(posedge rclk or posedge rrst);
	default input #0 output #0;
	input odata;
	input rden;
	input rd_empty;
endclocking

modport rd_DRIVER (clocking rd_driver_cb, input rclk, rrst);
modport rd_MONITOR (clocking rd_monitor_cb, input rclk, input rrst);

endinterface
