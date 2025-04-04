module fifo_memory #(parameter DATA_SIZE = 8, parameter ADDR_SIZE = 4)(
	input [DATA_SIZE-1:0] wr_data,
	input [ADDR_SIZE-1:0] wr_addr, rd_addr,
	input en, wr_full, clk, rd_inc, rd_clk,
	output reg [DATA_SIZE-1:0] rd_data);

	localparam DEPTH = 1<<ADDR_SIZE; //depth of fifo
	reg [DATA_SIZE-1:0] mem [0:DEPTH-1];
	
	always @(posedge rd_clk) begin
		if (rd_inc)rd_data = mem[rd_addr];
	end

	always @(posedge clk) begin
	if(en && !wr_full) begin 
		mem[wr_addr] <= wr_data;
	//	$display($time,"[DUT: FIFO MEM] Data written, Mem[%0d] = %0h \n",wr_addr,wr_data);
	//	$display($time,"[DUT: FIFO MEM] Data read, Mem[%0d] = %0h \n",rd_addr,mem[rd_addr]);
	`ifdef DEBUG
		$display($time," Data read, Mem[%0d] = %0h \n",rd_addr,mem[rd_addr]);
		$display($time," Data written, Mem[%0d] = %0h \n",wr_addr,wr_data);
		for(int i = 0; i< DEPTH; i++)begin
			$display($time," Mem[%0d] = %0h \n ",i,mem[i]);
		end
		$display("\n");
	`endif

	end
	end

endmodule
