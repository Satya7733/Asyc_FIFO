`include "pkg_graybin.svh"
import pkg_graybin::*;

module FIFO_top(
input logic [DATASIZE-1: 0] i_data,
output logic [DATASIZE-1: 0] o_data,
input logic i_wren, i_rden, i_wclk, i_rclk, i_wrst, i_rrst,
output logic w_rd_empty, w_wr_full);

wire w_wr_full_internal;
wire w_rd_empty_internal;

assign w_wr_full = w_wr_full_internal;  // Pass internal signal to output
assign w_rd_empty = w_rd_empty_internal;  // Pass internal signal to output

wire [$clog2(DEPTH):0] w_q2_wptr, w_q2_rptr;
wire [$clog2(DEPTH):0] w_rdptr, w_wrptr;
// wire w_rd_empty, w_wr_full;
wire [$clog2(DEPTH)-1:0] w_waddr, w_raddr;

FIFO_read FIFO_read(.q2_wptr(w_q2_wptr), .rdptr(w_rdptr), .rden(i_rden), .rclk(i_rclk), .rrst(i_rrst), .rd_empty(w_rd_empty_internal), .raddr(w_raddr));

FIFO_2ff rd_2ff(.ptr(w_wrptr), .q2_ptr(w_q2_wptr), .clk(i_rclk), .rst(i_rrst));

FIFO_write FIFO_write(.q2_rptr(w_q2_rptr), .wrptr(w_wrptr), .wren(i_wren), .wclk(i_wclk), .wrst(i_wrst), .wr_full(w_wr_full_internal), .waddr(w_waddr));

FIFO_2ff wr_2ff(.ptr(w_rdptr), .q2_ptr(w_q2_rptr), .clk(i_wclk), .rst(i_wrst));

FIFO_mem FIFO_mem(.wdata(i_data), .rdata(o_data), .wren(i_wren), .rden(i_rden), .wclk(i_wclk), .rclk(i_rclk), .wr_full(w_wr_full_internal), .rd_empty(w_rd_empty_internal), .waddr(w_waddr), .raddr(w_raddr));

endmodule
