`include "pkg_graybin.svh"
import pkg_graybin::*;
module FIFO_write(
input logic wren, wclk, wrst,
input logic [$clog2(DEPTH):0]q2_rptr,
output logic [$clog2(DEPTH):0]wrptr,
output logic [$clog2(DEPTH)-1:0]waddr,
output logic wr_full);

logic [$clog2(DEPTH):0] wrptr_t;

always @(posedge wclk or posedge wrst) begin
	if (wrst) begin
		wrptr_t = 0;
	end else if (wren && !wr_full)
	begin
		wrptr_t++;
	end
end

assign wrptr = b2g(wrptr_t);
assign waddr = wrptr_t[$clog2(DEPTH)-1:0];
assign wr_full = ({~wrptr_t[$clog2(DEPTH)], wrptr_t[$clog2(DEPTH)-1:0]} == g2b(q2_rptr)); 

endmodule
	
			
			
		
	


