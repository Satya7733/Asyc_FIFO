import uvm_pkg::*;
`include "uvm_macros.svh"
import uvm_AFIFO_agent_pkg::*;

class uvm_AFIFO_Wr_monitor extends uvm_monitor;
// ========== FACTORY REGISTRATION ==========
`uvm_component_utils(uvm_AFIFO_Wr_monitor) 

// ========== Handle ==========
 virtual uvm_AFIFO_interface vif;

// Analysis Port: For sending data to the scoreboard
 uvm_analysis_port #(uvm_AFIFO_Wr_sequence_item) sb_export_mon;

uvm_AFIFO_Wr_sequence_item wr_packet_m2s; // mon to sco packet

// ========== MEMORY CONSTRUCTOR ==========
function new(string name = "uvm_AFIFO_Wr_monitor", uvm_component parent);
    super.new(name,parent);
endfunction: new

// ========== Build Phase: Configure parameters using config_db and get virtual interface ========== 

virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sb_export_mon = new("sb_export_mon", this); // Create the analysis port
        if(!uvm_resource_db#(virtual uvm_AFIFO_interface)::read_by_name("ALL","TB",vif,this)) //Reterving the Interface
        begin
        `uvm_error("WRITE_MON","Problem with the interface")
        end else begin
        `uvm_info("READ_MONITOR", "Successfully retrieved the interface", UVM_LOW);
        end
  
endfunction : build_phase

// ========== RUN PHASE ==========
task run_phase(uvm_phase phase);
    `uvm_info("WRITE_MONITOR", "Run phase started, monitoring transactions...", UVM_MEDIUM);

forever begin
    @(posedge vif.wr_clk);
    if(vif.wr_inc == 1) begin
    #2
    wr_packet_m2s = new();
    wr_packet_m2s.wr_rst = vif.wr_rst;
    wr_packet_m2s.wr_full = vif.wr_full;
    wr_packet_m2s.wr_data = (vif.wr_inc)? vif.wr_data : 1'b0;
    wr_packet_m2s.wr_inc = vif.wr_inc;
    sb_export_mon.write(wr_packet_m2s); // send data to sco
    `uvm_info("Write_Monitor",$psprintf("MONITOR is doing WRITE at data=%0h",wr_packet_m2s.wr_data),UVM_NONE);
    end else begin
            `uvm_info("WRITE_MONITOR", "Waiting for WRITE INC TO BE 1...", UVM_LOW);

end
end
endtask
endclass
