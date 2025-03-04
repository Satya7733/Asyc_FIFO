import uvm_pkg::*;
`include "uvm_macros.svh"
import uvm_AFIFO_agent_pkg::*;

class uvm_AFIFO_Rd_monitor extends uvm_monitor;

// ========== FACTORY REGISTRATION ==========
`uvm_component_utils(uvm_AFIFO_Rd_monitor) 

// ========== Handle ==========
 virtual uvm_AFIFO_interface vif;
uvm_AFIFO_Rd_sequence_item seq_item;

// uvm_AFIFO_scoreboard scoreboard;
 int DSIZE;
 int ASIZE;
//
// Analysis Port: For sending data to the coverage
 uvm_analysis_port#(uvm_AFIFO_Rd_sequence_item) mon_port_cov;


// ========== MEMORY CONSTRUCTOR ==========

function new(string name = "uvm_AFIFO_Rd_monitor", uvm_component parent = null);
    super.new(name,parent);
endfunction: new


// ========== Build Phase: Configure parameters using config_db and get virtual interface ========== 

 function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_port_cov = new("mon_port_cov", this); // Create the analysis port
        `uvm_info("Read Monitor", "Inside the build phase of monitor", UVM_NONE);

// ----- Reterving the Interface -----
 if(!uvm_resource_db#(virtual uvm_AFIFO_interface)::read_by_name("ALL","TB",vif,this)) 
  begin
   `uvm_error("Read_MON","Problem with the interface")
  end
	//----- Get DSIZE AND ASIZE from config_db -----
	if(!uvm_config_db#(int)::get(this, "", "DSIZE", DSIZE)) begin
	//  `uvm_fatal("AFIFO_MONITOR", "DSIZE not set in config_db!")
        end

    if (!uvm_config_db#(int)::get(this, "", "ASIZE", ASIZE)) begin
    //    `uvm_fatal("AFIFO_MONITOR", "ASIZE not set in config_db!")
        end
	
endfunction : build_phase

// ========== RUN PHASE ==========

task run_phase(uvm_phase phase);

    forever begin
        @(posedge vif.rd_clk);
            if (vif.rd_inc==1 || vif.rd_empty == 1 ) begin
                seq_item = uvm_AFIFO_Rd_sequence_item::new();
                `uvm_info("READ_MONITOR", "Seq item object created ", UVM_MEDIUM)
            end   
      //  @(posedge vif.rd_clk);

            if (vif.rd_inc || vif.rd_empty || vif.wr_full || ~vif.rd_rst) begin
                `uvm_info("READ_MONITOR", $sformatf("Monitoring signals... rd_inc=%b, wr_inc=%b, rd_empty=%b", vif.rd_inc, vif.wr_inc, vif.rd_empty), UVM_MEDIUM)

                // Set the sequence item fields based on DUT signals
                seq_item.rd_data = vif.rd_data;
                seq_item.rd_inc = vif.rd_inc;
                seq_item.rd_rst = vif.rd_rst;
                seq_item.rd_empty = vif.rd_empty;

                mon_port_cov.write(seq_item); // Send sequence item via analysis export

                `uvm_info("READ_MONITOR", $sformatf("Sent sequence item: rd_data=%0h, rd_empty=%b", seq_item.rd_data, seq_item.rd_empty), UVM_MEDIUM)
                                            
            end 
                        
    end
endtask

endclass: uvm_AFIFO_Rd_monitor

