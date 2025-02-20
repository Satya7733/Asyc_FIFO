interface AFIFO_Interface #(parameter DSIZE = 8, parameter ASIZE = 4);

    logic [DSIZE-1:0] rd_data;
    logic [DSIZE-1:0] wr_data;
    logic wr_full;
    logic rd_empty;
    logic wr_inc;
    logic rd_inc;
    logic wr_clk;
    logic rd_clk;
    logic wr_rst;
    logic rd_rst;

   // modport writer(input wr_data, wr_inc, wr_clk, wr_rst, output wr_full);
    modport test(input rd_clk, rd_rst, rd_inc, wr_inc, wr_clk, wr_rst, wr_data,
				output rd_data, rd_empty, wr_full );
    
endinterface

