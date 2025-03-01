import uvm_pkg::*;
`include "uvm_macros.svh"
import uvm_AFIFO_agent_pkg::*;
class uvm_AFIFO_Rd_monitor extends uvm_monitor;
// ========== FACTORY REGISTRATION ==========
`uvm_component_utils(uvm_AFIFO_Rd_monitor) 

// ========== Handle ==========
 virtual uvm_AFIFO_interface vif;
// uvm_AFIFO_scoreboard scoreboard;
// int DSIZE;
// int ASIZE;
//
// Analysis Port: For sending data to the scoreboard
 uvm_analysis_port #(uvm_AFIFO_sequence_item) sb_export_mon;


// ========== MEMORY CONSTRUCTOR ==========

function new(string name = "uvm_AFIFO_Rd_monitor", uvm_component parent);
    super.new(name,parent);
endfunction: new


// ========== Build Phase: Configure parameters using config_db and get virtual interface ========== 

virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sb_export_mon = new("analysis_port", this); // Create the analysis port
        `uvm_info("Read Monitor", "Inside the build phase of monitor", UVM_NONE);

// ----- Reterving the Interface -----
 if(!uvm_resource_db#(virtual uvm_AFIFO_interface)::read_by_name("ALL","TB",vif,this)) 
  begin
   `uvm_error("Read_MON","Problem with the interface")
  end
	//----- Get DSIZE AND ASIZE from config_db -----
	if(!uvm_config_db#(int)::get(this, "", "DSIZE", DSIZE)) begin
	  `uvm_fatal("AFIFO_MONITOR", "DSIZE not set in config_db!")
        end

        if (!uvm_config_db#(int)::get(this, "", "ASIZE", ASIZE)) begin
        `uvm_fatal("AFIFO_MONITOR", "ASIZE not set in config_db!")
        end
	
endfunction : build_phase

// ========== RUN PHASE ==========

task run();



  uvm_AFIFO_sequence_item seq_item;

  //Ref Module
//  reg [DSIZE -1 :0] wr_data_drv_q[$]; //Queue Driver to Scoreboard
  bit[DSIZE-1 :0] ref_wr_data_drv;
  
        // Forever loop for monitoring the signals
        fork
            // Monitoring the write cycle
            begin
                forever begin
                    @(posedge vif_mon.wr_clk);
                    if (vif_mon.wr_inc) begin
                        $display($time, "[MON]: Data written to ref module: %0d", vif_mon.wr_data);
                       // wr_data_drv_q.push_back(vif_mon.wr_data);

                        // send data to scb

			sb_export_mon.write(seq_item);
                    end
                end
            end

         // Monitoring the read cycle and sending sequence items
            begin
                forever begin
                    @(posedge vif_mon.rd_clk);
                    if (vif_mon.rd_inc || vif_mon.rd_empty || vif_mon.wr_full || ~vif_mon.rd_rst) begin
                        $display($time, "[MON]: Entered loop sending sequence item");

                        // Create a new sequence item
                        seq_item = uvm_AFIFO_sequence_item::new();

                        // Set the sequence item fields based on DUT signals
                        seq_item.rd_data = vif_mon.rd_data;
                        seq_item.wr_inc = vif_mon.wr_inc;
                        seq_item.rd_inc = vif_mon.rd_inc;
                        seq_item.wr_rst = vif_mon.wr_rst;
                        seq_item.rd_rst = vif_mon.rd_rst;
                        seq_item.rd_empty = vif_mon.rd_empty;
                        seq_item.wr_full = vif_mon.wr_full;

                        // Push the driver data to the sequence item if read increment is active
                        //if (vif_mon.rd_inc) begin
                            //seq_item.rd_data_refModule = wr_data_drv_q.pop_front();
                            //$display("Popped data is: %0d", seq_item.rd_data_refModule);
                        //end

                        $display($time, "[MON]: rd_inc = %d, wr_inc = %d", seq_item.rd_inc, seq_item.wr_inc);

                        // Send the sequence item to the scoreboard via analysis export
                        if (vif_mon.rd_inc) begin
                            $display($time, "[MON]: Sequence Item sent to SCO %0d, and ref module: %0d", seq_item.rd_data, seq_item.rd_data_refModule);
                            sb_export_mon.write(seq_item); // Send sequence item via analysis export
                        end

//                        -> mon_done; // Trigger event for completion
                    end else begin
                        // Wait for read or write increment to occur
                        wait(vif_mon.rd_inc || vif_mon.wr_inc);
                    end
                end
            end
        join_none // Wait for both processes to run indefinitely
    endtask

endclass: uvm_AFIFO_monitor

