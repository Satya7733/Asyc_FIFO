module FIFO #(parameter DSIZE = 8, 
		parameter ASIZE = 4)(
		input logic [DSIZE-1: 0]wr_data,
		input logic wr_clk, wr_rst, wr_inc,
		input logic rd_clk, rd_rst, rd_inc,
		output logic [DSIZE-1: 0]rd_data,
		output logic rd_empty,wr_full
	);

logic [ASIZE:0] rd_ptr, wr_ptr, rd_q2_ptr, wr_q2_ptr;
logic [ASIZE-1:0] rd_addr, wr_addr;

fifo_memory #( DSIZE, ASIZE) fifo_mem (
		.en(wr_inc)
		,.clk(wr_clk)
		,.*);

rd_empty #(ASIZE) fifo_empty(.*);

wr_full #(ASIZE) fifo_full(.wr_q2_rptr(wr_q2_ptr)
			   ,.*);

ff_sync #(ASIZE + 1) r2w(.dq2(rd_q2_ptr)
		,.din(rd_ptr)
		,.clk(wr_clk)
		,.rst(wr_rst)); 

ff_sync #(ASIZE + 1) w2r(.dq2(wr_q2_ptr)
		,.din(wr_ptr)
		,.clk(rd_clk)
		,.rst(rd_rst));

endmodule
