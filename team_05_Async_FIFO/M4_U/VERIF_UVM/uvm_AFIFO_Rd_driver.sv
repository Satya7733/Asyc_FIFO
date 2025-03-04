import uvm_pkg::*;
`include "uvm_macros.svh"
import uvm_AFIFO_agent_pkg::*;

class uvm_AFIFO_Rd_driver extends uvm_driver#(uvm_AFIFO_Rd_sequence_item);

int DSIZE, ASIZE;

// ========== FACTORY REGISTRATION ==========
`uvm_component_utils(uvm_AFIFO_Rd_driver)

// ========== Handle ==========
 virtual uvm_AFIFO_interface vif;
uvm_AFIFO_Rd_sequence_item rd_packet;
// ========== MEMORY CONSTRUCTOR ==========

function new(string name = "uvm_AFIFO_Rd_driver", uvm_component parent);
    super.new(name,parent);
endfunction: new

// ========== Build Phase: Configure parameters using config_db and get virtual interface ==========  

     function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //rd_packet = new("rd_packet", this);
        `uvm_info("Read Driver", "Inside the build phase of driver", UVM_NONE);
 // ----- Reterving the Interface -----
 if(!uvm_resource_db#(virtual uvm_AFIFO_interface)::read_by_name("ALL","TB",vif,this)) 
  begin
   `uvm_error("Read_DRV","Problem with the interface")
  end
// ----- Get DSIZE AND ASIZE from config_db -----
	if(!uvm_config_db#(int)::get(this, "", "DSIZE", DSIZE)) begin
	  //`uvm_fatal("AFIFO_DRIVER", "DSIZE not set in config_db!")
        end

    if (!uvm_config_db#(int)::get(this, "", "ASIZE", ASIZE)) begin
       // `uvm_fatal("AFIFO_DRIVER", "ASIZE not set in config_db!")
        end

    endfunction : build_phase

// ========== RUN PHASE ==========

 task run_phase(uvm_phase phase);
  wait(vif.rd_rst == 1);
  forever begin 
    seq_item_port.get_next_item(rd_packet);
      drive_tx(rd_packet);
    seq_item_port.item_done;
  end
 endtask

 task drive_tx(uvm_AFIFO_Rd_sequence_item rd_packet);
   @(posedge vif.rd_clk);
   	if(!vif.rd_empty) begin
	    vif.rd_inc <= 1'b1;
        `uvm_info("READ_DRIVER", $sformatf("Read_INC = %0d",  vif.rd_inc), UVM_NONE)
	    @(posedge vif.rd_clk); //Experimental
	    vif.rd_inc <= 1'b0;
        `uvm_info("READ_DRIVER", $sformatf("Read_INC = %0d",  vif.rd_inc), UVM_NONE)
    end
 endtask
endclass: uvm_AFIFO_Rd_driver

