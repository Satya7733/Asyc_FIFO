module FIFO_mem #(parameter int DATASIZE = 8, parameter int DEPTH = 8)(
input logic [DATASIZE-1: 0] wdata,
output logic [DATASIZE-1: 0] rdata,
input logic wren, wr_full, rden, rd_empty, wrclk, rdclk,
input logic [($clog2(DEPTH))-1 :0] waddr, raddr);


logic [DATASIZE-1:0] mem [0:($clog2(DEPTH))-1];

always @(posedge wrclk) begin
	if (wren && !wr_full) begin
		mem[waddr] <= wdata;
	end
end

always @(posedge rdclk) begin
	if (rden && !rd_empty) begin
		rdata <= mem[raddr];
	end
end

endmodule
		

	
	

