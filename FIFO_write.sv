`include "pkg_graybin.svh"

module FIFO_write(
input logic wren, wclk, wrst,
input logic [$clog2(DEPTH):0]q2_rptr,
output logic [$clog2(DEPTH):0]wrptr,
output logic [$clog2(DEPTH)-1:0]waddr,
output logic wr_full);

logic [$clog2(DEPTH):0] wrptr_t;

always @(posedge wclk or posedge wrst) begin
	if (wrst) begin
		waddr <= 0;
		wrptr_t <= 0;
		wr_full<= 0;
	end else begin
		if ({~waddr[0], waddr[1:3]} == g2b(q2_rptr)) begin
			wr_full <= 1;
		end else begin
			wrptr_t++;
		end
	end
end

assign wrptr = b2g(wrptr_t);
assign waddr = wrptr[$clog2(DEPTH)-1:0];

endmodule
	
			
			
		
	


