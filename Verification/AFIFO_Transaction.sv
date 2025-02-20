class AFIFO_Transaction #(parameter DSIZE = 8);
 randc logic [DSIZE-1:0] wr_data;
 bit wr_clk, wr_rst, wr_inc;
 bit rd_clk, rd_rst, rd_inc;
//Why do we need to declare the c=output data here
 logic [DSIZE-1: 0]rd_data;
 bit rd_empty,wr_full;

function AFIFO_Transaction copy();// create deep copy
copy = new();
   /* if (copy == null) begin
        $fatal("ERROR: Memory allocation failed for copy!");
    end else begin
        $display("DEBUG: Memory allocated successfully for copy()");
    end*/
copy.wr_data = this.wr_data;
copy.rd_data = this.rd_data;
copy.rd_empty = this.rd_empty;
copy.wr_full = this.wr_full;
 return copy;
endfunction
 
endclass
