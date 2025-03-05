import uvm_pkg::*;
`include "uvm_macros.svh"
import uvm_AFIFO_agent_pkg::*;
class uvm_AFIFO_Rd_base_seq extends uvm_sequence#(uvm_AFIFO_Rd_sequence_item);

// ========== FACTORY REGISTRATION ==========
`uvm_object_utils(uvm_AFIFO_Rd_base_seq)

// ========== MEMORY CONSTRUCTOR ==========

function new(string name = "uvm_AFIFO_Rd_base_seq");
    super.new(name);
endfunction: new

// ========== Raising the  Objection && Setting the Drain Time ==========
task pre_body();
 if(starting_phase != null) begin
 	 starting_phase.raise_objection(this);
	 starting_phase.phase_done.set_drain_time(this,100);
 end
endtask

// ========== Drop Objection ==========
task post_body();
 if(starting_phase != null)begin
  starting_phase.drop_objection(this);
	end
endtask
endclass: uvm_AFIFO_Rd_base_seq


class uvm_AFIFO_Rd_seq extends uvm_AFIFO_Rd_base_seq;

// ----- GLOBAL VARIABLES -----
 int repeat_count;
 int DSIZE;
 int ASIZE;

// ========== FACTORY REGISTRATION ==========
`uvm_object_utils(uvm_AFIFO_Rd_seq)

// ========== MEMORY CONSTRUCTOR ==========

function new(string name = "uvm_AFIFO_Rd_seq");
    super.new(name);
endfunction: new

uvm_AFIFO_Rd_sequence_item rd_packet;

	 task body();
 	 if(!uvm_resource_db#(int)::read_by_name("GLOBAL","RPT_CNT_RD",repeat_count,this)) begin
		`uvm_error("Read_Seq","Problem with the interface")
	 end

     //if(!uvm_config_db#(int)::get(null, "", "dsize", DSIZE)) begin
      //`uvm_error("Read_Seq","Failed to get DSIZE from config DB")
    //end

    //if(!uvm_config_db#(int)::get(null, "", "asize", ASIZE)) begin
     // `uvm_error("Read_Seq","Failed to get ASIZE from config DB")
    //end

    `uvm_info("READ_SEQUENCE", $sformatf("repeat_count=%0d, dsize=%0d, asize=%0d", repeat_count, DSIZE, ASIZE), UVM_MEDIUM)

		  repeat((repeat_count+1)) begin
          //rd_packet = uvm_AFIFO_Rd_sequence_item::type_id::create("rd_packet");
          //rd_packet = new();     
        // ----- Pass dsize and asize values to sequence item -----
             //rd_packet.rd_data = $urandom_range(0, (1 << 8) - 1); // Generate data with dsize bits
    		`uvm_do(rd_packet);
        `uvm_info("READ_SEQUENCE", $sformatf("Data_Read = %2h", rd_packet.rd_data), UVM_NONE)

    //start_item(rd_packet);
    //finish_item(rd_packet);

    `uvm_info("READ_SEQUENCE", $sformatf("Data_Read = %2h (dsize= 8 )", rd_packet.rd_data), UVM_NONE)


		end
	 endtask
 endclass






