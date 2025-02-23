import AFIFO_Pkg::*;
`include "uvm_macros.svh"

class afifo_monitor extends uvm_monitor;
// ========== FACTORY REGISTRATION ==========
`uvm_component_utils(AFIFO_Monitor) 

// ========== Handle ==========
 virtual AFIFO_Interface vif_mon;
 int DSIZE;
 int ASIZE;

// Analysis Port: For sending data to the scoreboard
 uvm_analysis_export #(AFIFO_Transaction) analysis_export;


// ========== MEMORY CONSTRUCTOR ==========

function new(string name = "afifo_monitor", uvm_component parent);
    super.new(name,parent);
    analysis_export = new("analysis_export", this); // Create the analysis port
endfunction: new

// ========== Build Phase: Configure parameters using config_db and get virtual interface ========== 

virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Get DSIZE from config_db
        if (!uvm_config_db#(int)::get(this, "", "DSIZE", DSIZE)) begin
            `uvm_fatal("AFIFO_MONITOR", "DSIZE not set in config_db!")
        end

        // Get the virtual interface from config_db
        if (!uvm_config_db#(virtual AFIFO_Interface)::get(this, "", "vif", vif_mon)) begin
            `uvm_fatal("AFIFO_MONITOR", "Virtual interface not set!")
        end

endfunction


// ========== CONNECT PHASE ==========

virtual function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  analysis_export.connect(scoreboard.analysis_import);
endfunction


// ========== RUN PHASE ==========

task run();
  afifo_seq_item seq_item;

  //Ref Module
  reg [DSIZE -1 :0] wr_data_drv_q[$]; //Queue Driver to Scoreboard
  bit[DSIZE-1 :0] ref_wr_data_drv;
  
        // Forever loop for monitoring the signals
        fork
            // Monitoring the write cycle
            begin
                forever begin
                    @(posedge vif_mon.wr_clk);
                    if (vif_mon.wr_inc) begin
                        $display($time, "[MON]: Data written to ref module: %0d", vif_mon.wr_data);
                        wr_data_drv_q.push_back(vif_mon.wr_data);
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
                        seq_item = afifo_seq_item::new();

                        // Set the sequence item fields based on DUT signals
                        seq_item.rd_data = vif_mon.rd_data;
                        seq_item.wr_inc = vif_mon.wr_inc;
                        seq_item.rd_inc = vif_mon.rd_inc;
                        seq_item.wr_rst = vif_mon.wr_rst;
                        seq_item.rd_rst = vif_mon.rd_rst;
                        seq_item.rd_empty = vif_mon.rd_empty;
                        seq_item.wr_full = vif_mon.wr_full;

                        // Push the driver data to the sequence item if read increment is active
                        if (vif_mon.rd_inc) begin
                            seq_item.rd_data_refModule = wr_data_drv_q.pop_front();
                            $display("Popped data is: %0d", seq_item.rd_data_refModule);
                        end

                        $display($time, "[MON]: rd_inc = %d, wr_inc = %d", seq_item.rd_inc, seq_item.wr_inc);

                        // Send the sequence item to the scoreboard via analysis export
                        if (vif_mon.rd_inc) begin
                            $display($time, "[MON]: Sequence Item sent to SCO %0d, and ref module: %0d", seq_item.rd_data, seq_item.rd_data_refModule);
                            analysis_export.write(seq_item); // Send sequence item via analysis export
                        end

                        -> mon_done; // Trigger event for completion
                    end else begin
                        // Wait for read or write increment to occur
                        wait(vif_mon.rd_inc || vif_mon.wr_inc);
                    end
                end
            end
        join_none // Wait for both processes to run indefinitely
    endtask

endclass: afifo_monitor

