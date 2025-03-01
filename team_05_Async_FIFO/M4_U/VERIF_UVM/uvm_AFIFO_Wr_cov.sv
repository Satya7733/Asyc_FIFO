
import uvm_pkg::*;
`include "uvm_macros.svh"
import uvm_AFIFO_agent_pkg::*;

class uvm_AFIFO_Wr_cov extends uvm_subscriber#(uvm_AFIFO_Wr_sequence_item);

    uvm_AFIFO_Wr_sequence_item wr_packet_m2c; // monitor to coverage
    // ========== FACTORY REGISTRATION ==========
    `uvm_component_utils(uvm_AFIFO_Wr_cov)

   covergroup wr_cg;
    option.per_instance = 1;
    
    // Cover points
    cp_data: coverpoint wr_packet_m2c.wr_data {
      bins valid_data[] = {[0:255]};
    }
    cp_w_en: coverpoint wr_packet_m2c.wr_inc {     
      bins enabled = {1'b1};
    }
    cp_wrst_n: coverpoint wr_packet_m2c.wr_rst {
      bins reset = {1'b0};
      bins no_reset = {1'b1};
    }
    cp_full: coverpoint wr_packet_m2c.wr_full {
      bins full = {1'b1};
      bins not_full = {1'b0};
    }
    // Cross coverage
    cross_burst_idle: cross cp_data, cp_w_en; 

  endgroup

function new(string name= "uvm_AFIFO_Wr_cov",uvm_component parent);
  super.new(name,parent);
  wr_cg= new();
endfunction



function void write(uvm_AFIFO_Wr_sequence_item t);
	$cast(wr_packet_m2c,t);
	wr_cg.sample();
endfunction

endclass: uvm_AFIFO_Wr_cov
