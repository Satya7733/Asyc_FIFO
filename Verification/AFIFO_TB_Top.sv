//Imports
//`include"AFIFO_Pkg.sv"
import AFIFO_Pkg::*;
`timescale 1ns/1ps

module AFIFO_TB_Top;



//PARAMETER
parameter DSIZE = 8;
parameter ASIZE = 3;
// Handle
 AFIFO_Interface  vif();

FIFO #(DSIZE, ASIZE) fifo (vif.wr_data, vif.wr_clk, vif.wr_rst, vif.wr_inc,
                        vif.rd_clk, vif.rd_rst, vif.rd_inc, vif.rd_data, vif.rd_empty, vif.wr_full);

initial begin
vif.wr_clk <= 0;
vif.rd_clk <= 0;
end

//clk for rd and wr
always #35ns vif.wr_clk <= ~vif.wr_clk;
always #25ns vif.rd_clk <= ~vif.rd_clk;

AFIFO_Environment en;

initial begin 
 en = new(vif);
 en.run();
end


endmodule
