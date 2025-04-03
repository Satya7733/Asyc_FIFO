/*******************************************************************************
* File Name: AFIFO_TB_Top.sv
* 
* Description: 
* Top-level testbench module for Asynchronous FIFO verification. This module:
* - Instantiates DUT (FIFO) and verification components
* - Generates clock signals for read and write domains
* - Implements functional coverage for FIFO operations including:
*   - Write/Read data value ranges
*   - Write/Read enable operations
* - Coordinates the verification environment and coverage collection
* - Reports functional coverage statistics
*
* Parameters:
* - DSIZE: Data width (8 bits)
* - ASIZE: Address width (3 bits)
*
* Date: 2/20/2025
*******************************************************************************/

//Imports
import AFIFO_Pkg::*;
`timescale 1ns/1ps

module AFIFO_TB_Top;

// ====== PARAMETER ======
parameter DSIZE = 8;
parameter ASIZE = 3;

// ====== Handle ======
 AFIFO_Interface  vif();

 // ====== EVENT FOR COVERAGE ======
event coverage_done;
 
// ====== Instantiate the FIFO ======
FIFO #(DSIZE, ASIZE) fifo (vif.wr_data, vif.wr_clk, vif.wr_rst, vif.wr_inc,
                        vif.rd_clk, vif.rd_rst, vif.rd_inc, vif.rd_data, vif.rd_empty, vif.wr_full);

initial begin
vif.wr_clk <= 0;
vif.rd_clk <= 0;
end

// ====== Clk for rd and wr ======
always #35ns vif.wr_clk <= ~vif.wr_clk;
always #25ns vif.rd_clk <= ~vif.rd_clk;

// ====== Instantiate the environment ======
AFIFO_Environment en;

// ====== Mailboxes for communication ======
  mailbox #(AFIFO_Transaction) mbx_gen2drv;
  mailbox #(bit [DSIZE-1:0]) mbx_drv2sco;

  // ====== Coverage variables ======
  covergroup fifo_coverage @(posedge vif.wr_clk);
    cp1: coverpoint vif.wr_data {
      bins zero_z = {0};
      bins low_l = {[1:10]};
      bins medium_m = {[11:100]};
      bins high_h = {[101:255]};
    }

 // ====== covergroup read_data_cov @(posedge vif.rd_clk); ======
    cp2: coverpoint vif.rd_data {
      bins zero_z = {0};
      bins low_l = {[1:10]};
      bins medium_m = {[11:100]};
      bins high_h = {[101:255]};
    }

  // ====== covergroup wr_operations_cov; ======
    cp3: coverpoint vif.wr_inc {
      bins write_zero = {0};
      bins write_one = {1};
    }

  //====== covergroup rd_operations_cov; ======
    cp4: coverpoint vif.rd_inc {
      bins read_zero = {0};
      bins read_one = {1};
    }
  endgroup

// ====== HANDLE FOR COVERAGE ======
fifo_coverage f_cg;

// ====== MEMEORY FOR COVERAGE ======
initial begin
f_cg = new();
end

// ====== Instantiate and run the environment ======
initial begin 
 en = new(vif);
 en.run();
        // Start sampling coverage when simulation starts
    forever begin
      @ (posedge vif.wr_clk) begin
        f_cg.sample;  // Sample write data coverage
        f_cg.sample;  // Sample write operation coverage
      end
      @ (posedge vif.rd_clk) begin
        f_cg.sample;  // Sample read data coverage
        f_cg.sample;  // Sample read operation coverage
      end
    end
  end

// ====== Sample covergroups ======
always @(posedge vif.wr_clk) begin
  f_cg.sample;   // Sample write data coverage
  f_cg.sample; // Sample write operation coverage
end

always @(posedge vif.rd_clk) begin
  f_cg.sample;   // Sample read data coverage
  f_cg.sample; // Sample read operation coverage
end

/*
initial begin
#12395404ps;
->coverage_done;
end
*/
// ====== Display coverage ====== 
initial begin
wait(en.dr.coverage_done);
$display(" \n========== FUNCTIONAL COVERAGE ==========");
$display("\nCOVERAGE REPORT: %.2f%%", f_cg.get_coverage());
$display("WRITE DATA: %.2f%%", f_cg.get_coverage());
$display("WRITE OPERAION: %.2f%%", f_cg.get_coverage());
$display("READ DATA: %.2f%%", f_cg.get_coverage());
$display("READ OPERATION: %.2f%%", f_cg.get_coverage());

$finish;
end


endmodule
