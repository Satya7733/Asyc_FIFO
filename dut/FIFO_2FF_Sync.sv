module ff_sync #(parameter SIZE = 4)( 
    output logic [SIZE-1:0] dq2,   // Output of the second flip-flop
    input logic [SIZE-1:0] din,       // Input data
    input logic clk, rst            // Clock and reset
    );

    logic [SIZE-1:0] dq1; // Output of the first flip-flop

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dq2<=0;
			dq1<=0;       // Reset the FIFO
		end
        else begin 
            dq1 <= din;
			dq2 <= dq1;  // Shift the data
		end	   
 	end 

endmodule

