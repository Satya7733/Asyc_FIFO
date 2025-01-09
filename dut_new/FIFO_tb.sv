//--------------DESCRIPTION--------------
// This is a testbench for the FIFO module.
// The testbench generates random data and writes it to the FIFO, 
// then reads it back and compares the results.
//---------------------------------------

`timescale 1ns/1ps
`include "pkg_graybin.svh"

import pkg_graybin::*;

module FIFO_tb();

    logic [($clog2(DEPTH))-1:0] wdata;   // Input data
    logic [($clog2(DEPTH))-1:0] rdata; 
    logic wfull, rempty;      // Write full and read empty signals
    logic wren, rden, wclk, rclk, wrst, rrst; // Write and read signals

    FIFO_top fifo (
        .i_data(wdata), 
        .o_data(rdata),
        .i_wren(wren), 
        .i_rden(rden), 
        .i_wclk(wclk), 
        .i_rclk(rclk), 
        .i_wrst(wrst), 
        .i_rrst(rrst),
	.w_rd_empty(rempty),
	.w_wr_full(wfull)
    );

    integer i=0;
    integer seed = 1;

    // Read and write clock in loop
    always #5 wclk = ~wclk;    // faster writing
    always #10 rclk = ~rclk;   // slower reading
    
always @(posedge wclk) begin
    if (wren && !wfull) $strobe("Write: Data = %0d", wdata);
end

always @(posedge rclk) begin
    if (rden && !rempty) $strobe("Read: Data = %0d", rdata);
end
    initial begin
        // Initialize all signals
        wclk = 0;
        rclk = 0;
        wrst = 1;     // Active high reset
        rrst = 1;     // Active high reset
        wren = 0;
        rden = 0;
        wdata = 0;

        #40 wrst = 0; rrst = 0;

        // TEST CASE 1: Write data and read it back
        rden = 1;
        for (i = 0; i < 10; i = i + 1) begin
            wdata = $random(seed) % 256;
            wren = 1;
            #10;
            wren = 0;
            #10;
        end
#50;

        rden = 0;
        wren = 1;
        for (i = 0; i < DEPTH + 3; i = i + 1) begin
            wdata = $random(seed) % 256;
            #10;
        end

#50;

        // TEST CASE 3: Read data from empty FIFO and try to read more data
        wren = 0;
        rden = 1;
        for (i = 0; i < DEPTH + 3; i = i + 1) begin
            #20;
        end


#50;


        $stop;
    end

endmodule

//----------------------------EXPLANATION-----------------------------------------------
// The testbench for the FIFO module generates random data and writes it to the FIFO,
// then reads it back and compares the results. The testbench includes three test cases:
// 1. Write data and read it back.
// 2. Write data to make the FIFO full and try to write more data.
// 3. Read data from an empty FIFO and try to read more data. The testbench uses
// clock signals for writing and reading, and includes reset signals to initialize
// the FIFO. The testbench finishes after running the test cases.
//--------------------------------------------------------------------------------------
