module fifo_memory #(parameter DATA_SIZE = 8, parameter ADDR_SIZE = 4)(
	input [DATA_SIZE-1:0] wr_data,
	input [ADDR_SIZE-1:0] wr_addr, rd_addr,
	input en, wr_full, clk,
	output [DATA_SIZE-1:0] rd_data);

	localparam DEPTH = 1<<ADDR_SIZE;
	reg [DATA_SIZE-1:0] mem [0:DEPTH-1];
	
	assign rd_data = mem[rd_addr];

	always @(posedge clk) begin
		if(clk && !wr_full) mem[wr_addr] <= wr_data;
	end
endmodule
