module rd_empty #(parameter ADDR_SIZE = 4)(input logic rd_clk, rd_rst, rd_inc, 
					input logic [ADDR_SIZE:0] wr_q2_ptr, 
					output logic [ADDR_SIZE:0] rd_ptr,
					output logic [ADDR_SIZE-1:0] rd_addr, 
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
//$display($time,"\n Read INC = %d\n",rd_inc );
if(!rd_rst) rd_empty <= 1;
else rd_empty <= rd_empty_temp;
end

/*
  reg [ADDR_SIZE:0] rbin;                     // Binary read pointer
    wire [ADDR_SIZE:0] rgray_next, rbin_next;   // Next read pointer in gray and binary code
    wire rempty_val;                            // Empty flag value

    // Synchronous FIFO read pointer (gray code)
    always @(posedge rd_clk or negedge rd_rst) begin
        if (!rd_rst)                // Reset the FIFO
            {rbin, rd_ptr} <= 0;
        else begin
            {rbin, rd_ptr} <= {rbin_next, rgray_next};  // Shift the read pointer
	$strobe($time,"[rd_empty]\n Read ptr = %b\n",rd_ptr); end
    end

    assign rd_addr = rbin[ADDR_SIZE-1:0];                 // Read address calculation from the read pointer
    assign rbin_next = rbin + (rd_inc & ~rd_empty);         // Increment the read pointer if not empty
    assign rgray_next = (rbin_next>>1) ^ rbin_next;     // Convert binary to gray code

    // Check if the FIFO is empty
    assign rempty_val = (rgray_next == wr_q2_ptr);       // Empty flag calculation

    always @(posedge rd_clk or negedge rd_rst) begin
        if (!rd_rst)                // Reset the empty flag
            rd_empty <= 1'b1;
        else 
            rd_empty <= rempty_val;  // Update the empty flag
$strobe($time,"\n Read INC = %d\n",rd_inc );
    end

*/
endmodule
