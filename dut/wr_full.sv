module wr_full #(parameter ADDR_SIZE = 4)(
	input [ADDR_SIZE:0]wr_q2_rptr,
	input wr_inc, wr_clk, wr_rst,
	output reg wr_full,
	output [ADDR_SIZE-1:0] wr_addr,
	output reg [ADDR_SIZE:0] wr_ptr);
	
	reg [ADDR_SIZE:0] wr_bin;
	wire [ADDR_SIZE:0] wr_gray_next, wr_bin_next;
	wire wr_full_val;
	
	always @(posedge wr_clk or negedge wr_rst) begin
		if(!wr_rst) {wr_bin, wr_ptr} <= 0;
		else {wr_bin, wr_ptr} <= {wr_bin_next, wr_gray_next};
	end
	
	assign wr_addr = wr_bin[ADDR_SIZE-1:0];
	assign wr_bin_next = wr_bin + (wr_inc & ~wr_full);
	assign wr_gray_next = (wr_bin_next>>1)^wr_bin_next;   // binary to gray code conversion
	
	assign wr_full_val = (wr_gray_next=={~wr_q2_rptr[ADDR_SIZE:ADDR_SIZE-1], wr_q2_rptr[ADDR_SIZE-2:0]});

	always @(posedge wr_clk or negedge wr_rst) begin
        if (!wr_rst)           
            wr_full <= 1'b0;
        else 
            wr_full <= wr_full_val;
    end
endmodule


