import uvm_pkg::*;
`include "uvm_macros.svh"
import uvm_AFIFO_agent_pkg::*;

class uvm_AFIFO_Wr_driver extends uvm_driver #(uvm_AFIFO_Wr_sequence_item);

// ========== FACTORY REGISTRATION ==========
`uvm_component_utils(uvm_AFIFO_Wr_driver)
 
// ========== Handle ==========
 virtual uvm_AFIFO_interface vif;
 uvm_AFIFO_Wr_sequence_item wr_packet;

// ===========variable ===============
int repeat_count = 0;
int i = 0;
// ========== MEMORY CONSTRUCTOR ==========

function new(string name = "uvm_AFIFO_Wr_driver", uvm_component parent);
    super.new(name,parent);
endfunction: new

// ========== Build Phase: Configure parameters using config_db and get virtual interface ==========  

     function void build_phase(uvm_phase phase);
        super.build_phase(phase);
      //  wr_packet = uvm_AFIFO_Wr_sequence_item::type_id::create("wr_packet", this);
        if(!uvm_resource_db#(virtual uvm_AFIFO_interface)::read_by_name("ALL","TB",vif,this))
        begin
         `uvm_error("WRITE_DRIVER","Problem with the interface")
        end
        if(!uvm_resource_db#(int)::read_by_name("GLOBAL","RPT_CNT_WR",repeat_count,this)) 
        begin
		      `uvm_error("WRITE_SEQUENCE","Problem with the interface")
        end
    endfunction : build_phase

task run_phase(uvm_phase phase);
   wait(vif.wr_rst == 1);
  forever begin 
	 seq_item_port.get_next_item(wr_packet);
    drive_write_input(wr_packet);
	 //req.print();
    seq_item_port.item_done;
    
   end
   vif.wr_inc = 0;
endtask

task drive_write_input( uvm_AFIFO_Wr_sequence_item wr_packet);

@(posedge vif.wr_clk);
		
    if(!vif.wr_full) begin 
      vif.wr_inc =1;
		vif.wr_data = wr_packet.wr_data;
    
    i++;
    if(i == repeat_count) begin
     @(posedge vif.wr_clk);
     
		vif.wr_inc = 0;
		vif.wr_data = 0;
     end
     end

  `uvm_info("WRITE_DRIVER", $sformatf("Write_EN = %0d, Data_in = %2h", vif.wr_inc, wr_packet.wr_data), UVM_NONE)


endtask

endclass: uvm_AFIFO_Wr_driver
