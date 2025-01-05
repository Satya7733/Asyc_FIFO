`include "pkg_graybin.svh"

module FIFO_2ff #(parameter int DEPTH = 8) (
input logic [0:$clog2(DEPTH)] ptr,
input logic clk, rst,
output logic [0:$clog2(DEPTH)] q2_ptr);

logic [0:$clog2(DEPTH)] q1;

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
	
