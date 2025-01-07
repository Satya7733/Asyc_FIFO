`include "pkg_graybin.svh"
import pkg_graybin::*;

module FIFO_read(
input logic rden, rclk, rrst,
input logic [$clog2(DEPTH):0]q2_wptr,
output logic [$clog2(DEPTH):0]rdptr,
output logic [$clog2(DEPTH)-1:0]raddr,
output logic rd_empty);

logic [$clog2(DEPTH):0] rdptr_t;

always @(posedge rclk or posedge rrst) begin
	if (rrst) begin
		rdptr_t <= 0;
	end else if(rden && !rd_empty) begin
			rdptr_t++;
	end
end

assign rdptr = b2g(rdptr_t);
assign raddr = rdptr_t[$clog2(DEPTH)-1:0];
assign rd_empty = (rdptr == q2_wptr);

endmodule
	
