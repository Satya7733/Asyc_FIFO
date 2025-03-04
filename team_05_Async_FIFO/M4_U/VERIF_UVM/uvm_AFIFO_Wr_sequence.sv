import uvm_pkg::*;
`include "uvm_macros.svh"
import uvm_AFIFO_agent_pkg::*;
//import uvm_AFIFO_sequence_item::*;

class uvm_AFIFO_Wr_base_sequence extends uvm_sequence#(uvm_AFIFO_Wr_sequence_item);

`uvm_object_utils(uvm_AFIFO_Wr_base_sequence) //Factory Reg

//================Memory Constructor =======================
 function new(string name = "uvm_AFIFO_Wr_base_sequence"); 
 super.new(name); 

 endfunction 


task pre_body();
 if(starting_phase != null) begin
 	 starting_phase.raise_objection(this);  //Raised objection
	 `uvm_info("WRITE_SEQUENCE", "OBJECTION RAISED", UVM_MEDIUM);
	 starting_phase.phase_done.set_drain_time(this,100); // added drain time 
 end
endtask

task post_body();
 if(starting_phase != null)begin
    starting_phase.drop_objection(this); //Droped objection
	`uvm_info("WRITE_SEQUENCE", "OBJECTION DROPPED", UVM_MEDIUM);
 end
endtask

endclass

class uvm_AFIFO_Wr_sequence extends uvm_AFIFO_Wr_base_sequence;
`uvm_object_utils(uvm_AFIFO_Wr_sequence) //Factory Reg
//================Memory Constructor =======================
 function new(string name = "uvm_AFIFO_Wr_sequence" ); 
 super.new(name); 
 
 endfunction 

uvm_AFIFO_Wr_sequence_item wr_packet;
int repeat_count;
	 task body();
	 if(!uvm_resource_db#(int)::read_by_name("GLOBAL","RPT_CNT",repeat_count,this)) begin
		`uvm_error("WRITE SEQUENCE","Error while connecting with the interface")
	 end
		repeat(repeat_count) begin
			`uvm_do(wr_packet);// creates obj tr of transaction class, randomizes it and sends: seq->seqr 
						 //start item -> Randomize -> Finish item(sends tr to driver)
    		`uvm_info("WRITE_SEQUENCE", $sformatf("Data_Write = %2h", wr_packet.wr_data), UVM_NONE)
		end
	 endtask

endclass