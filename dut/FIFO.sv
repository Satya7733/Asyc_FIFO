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

fifo_memory #( DSIZE, ASIZE) fifo_mem (.wr_data(wr_data)
		,.wr_addr(wr_addr)
		,.rd_addr(rd_addr)
		,.en(wr_inc)
		,.wr_full(wr_full)
		,.clk(wr_clk)
		,.rd_data(rd_data));

rd_empty #(ASIZE) fifo_empty(.rd_clk(rd_clk),                // Clock signal for read
    .rd_rst(rd_rst),                // Reset signal for read
    .rd_inc(rd_inc),                // Increment signal for read pointer
    .wr_q2_ptr(wr_q2_ptr),          // Write pointer signal (2nd copy)
    .rd_ptr(rd_ptr),                // Output for read pointer
    .rd_addr(rd_addr),              // Output for read address
    .rd_empty(rd_empty)             // Output signal indicating if the FIFO is empty
);

wr_full #(ASIZE) fifo_full(    .wr_q2_rptr(rd_q2_ptr),        // Write pointer signal (2nd copy) from the read side
    .wr_inc(wr_inc),               // Write pointer increment signal
    .wr_clk(wr_clk),               // Clock signal for write
    .wr_rst(wr_rst),               // Reset signal for write
    .wr_full(wr_full),             // Output indicating if the FIFO is full
    .wr_addr(wr_addr),             // Output for the write address
    .wr_ptr(wr_ptr)                // Output for the write pointer
);

ff_sync #(ASIZE + 1) r2w(.dq2(rd_q2_ptr)
		,.din(rd_ptr)
		,.clk(wr_clk)
		,.rst(wr_rst)); 

ff_sync #(ASIZE + 1) w2r(.dq2(wr_q2_ptr)
		,.din(wr_ptr)
		,.clk(rd_clk)
		,.rst(rd_rst));

endmodule
