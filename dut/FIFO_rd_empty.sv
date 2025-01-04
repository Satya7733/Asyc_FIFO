module rd_empty #(parameter ADDR_SIZE = 4)(input logic rd_clk, rd_rst, rd_inc, 
					input logic [ADDR_SIZE-1] wr_q2_ptr, 
					output logic [ADDR_SIZE-1] rd_ptr,
					output logic [ADDR_SIZE-1] rd_addr, 
					output logic rd_empty );

logic [ADDR_SIZE: 0] rd_bin, rd_bin_next, rd_gray_next;
wire rd_empty_temp;
 
always@(posedge rd_clk or negedge rd_rst) begin
if(!rd_rst)begin
	rd_ptr <= 0;
//	rd_addr <= 0;	
// 	rd_empty <= 1;
	rd_bin <= 0;
end
else begin
	rd_ptr <= rd_gray_next;// store gray code in rd_ptr
	rd_bin <= rd_bin_next;
end
end

assign rd_addr = rd_bin[ADDR_SIZE-1 : 0]; //give address for accessing mem
assign rd_bin_next = rd_bin + (rd_inc &  ~rd_empty); // increment the rd_bin_netx if rd_increment is high and mem is not empty
assign rd_gray_next = (rd_bin_next >> 1) ^ rd_bin_next; // convert binary to gray 
assign rd_empty_temp = (rd_gray_next == wr_q2_ptr); // check for empty condition

always@(posedge rd_clk or negedge rd_rst)begin

if(!rd_rst) rd_empty <= 1;
else rd_empty <= rd_empty_temp;
end

endmodule
