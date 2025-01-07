`include "pkg_graybin.svh"
import pkg_graybin::*;

module FIFO_2ff(
input logic [$clog2(DEPTH):0] ptr,
input logic clk, rst,
output logic [$clog2(DEPTH):0] q2_ptr);

logic [$clog2(DEPTH):0] q1;

always @(posedge clk or posedge rst) begin
	if(rst) begin
		q1 <= 0;
		q2_ptr <= 0;
	end else begin
		q1 <= ptr;
		q2_ptr <= q1;
	end
end
endmodule
	
