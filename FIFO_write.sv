`include "FIFO_mem.sv"

module FIFO_write(
input logic wren, wclk, wrst,
input logic [$clog2(DEPTH):0]q2_rptr,
output logic [$clog2(DEPTH):0]wrptr,
output logic [$clog2(DEPTH)-1:0]waddr,
output logic wr_full);

logic [$clog2(DEPTH):0] wrptr_t;

    function automatic logic [$clog2(DEPTH):0] g2b (input logic [$clog2(DEPTH):0] gray);
        logic [$clog2(DEPTH):0] binary;
        integer i;
        binary = 0;
        for (i = $clog2(DEPTH); i >= 0; i--) begin
            binary[i] = ^(gray >> i);
        end
        return binary;
    endfunction

    // Function to convert binary to Gray code
    function automatic logic [$clog2(DEPTH):0] b2g (input logic [$clog2(DEPTH):0] binary);
        logic [$clog2(DEPTH):0] gray;
        integer i;
        for (i = 0; i < $clog2(DEPTH); i++) begin
            gray[i] = binary[i] ^ binary[i + 1];
        end
        gray[$clog2(DEPTH)] = binary[$clog2(DEPTH)];
        return gray;
    endfunction

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
	
			
			
		
	


