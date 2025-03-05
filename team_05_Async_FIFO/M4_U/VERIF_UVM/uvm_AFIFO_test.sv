import uvm_pkg::*;
`include "uvm_macros.svh"
import uvm_AFIFO_agent_pkg::*;
`include "uvm_AFIFO_report_server.sv"

class uvm_AFIFO_test extends uvm_test;

// ========== FACTORY REGISTRATION ==========
    `uvm_component_utils(uvm_AFIFO_test)
	uvm_AFIFO_env env;


// ========== LOGGING FILES ==========
  int rd_mon_log, err_log, pkt_log;
  // wr_mon_log,

// ========== MEMORY CONSTRUCTOR ==========
    function new(string name = "uvm_AFIFO_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

// Build phase: Create and configure the testbench environment
	function void build_phase(uvm_phase phase);
     		super.build_phase(phase);
       		env = uvm_AFIFO_env::type_id::create("env", this);
	endfunction: build_phase

function void start_of_simulation_phase(uvm_phase phase);
        uvm_AFIFO_report_server report_server;
        report_server = new();
   super.start_of_simulation_phase(phase);
	`uvm_info("TEST CLASS","start of simulation phase - test",UVM_HIGH);
   
   // Open Log Files
    rd_mon_log = $fopen("rd_monitor.txt","w");

    // Check if Rd_agent and Rd_mon are initialized and connected
    if (env.Rd_agent != null && env.Rd_agent.Rd_mon != null) begin
        env.Rd_agent.Rd_mon.set_report_severity_file_hier(UVM_INFO, rd_mon_log);
    end else begin
        `uvm_error("AFIFO_TEST", "Rd_agent or Rd_mon is not properly initialized.");
    end
    // Set logging actions    
    set_report_severity_action_hier(UVM_INFO, UVM_DISPLAY | UVM_LOG);
    set_report_severity_file_hier(UVM_INFO, pkt_log);   // Info

    err_log    = $fopen("error.txt", "w");
    set_report_severity_action_hier(UVM_ERROR, UVM_DISPLAY | UVM_LOG);
    set_report_severity_file_hier(UVM_ERROR, err_log);  // Errors

    `uvm_info("AFIFO_TEST", "Logging setup complete", UVM_MEDIUM);
	uvm_report_server::set_server( report_server );

endfunction
	function void end_of_elaboration_phase(uvm_phase phase);
 		 uvm_top.print_topology();
	endfunction
endclass

//FIFO Write Test

class AFIFO_wr extends uvm_AFIFO_test;
`uvm_component_utils(AFIFO_wr)

	function new(string name = "", uvm_component parent = null);
      	  super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
	 super.build_phase(phase);
    	 uvm_resource_db#(int)::set("GLOBAL","RPT_CNT_WR",5,this);
	endfunction

    // Run phase: Start the sequence and execute the test case
    task run_phase(uvm_phase phase);
        uvm_AFIFO_Wr_sequence wr_seq;
//	uvm_AFIFO_Rd_seq rd_seq;

        wr_seq = uvm_AFIFO_Wr_sequence::type_id::create("wr_seq", this);
//	rd_seq = uvm_AFIFO_Rd_seq::type_id::create("rd_seq", this);

	phase.raise_objection(this);
	phase.phase_done.set_drain_time(this,100);
		wr_seq.start(env.Wr_agent.afifo_Wr_seqr);
//		rd_seq.start(env.Rd_agent.Rd_sqr);
	phase.drop_objection(this);
	endtask	

endclass

//FIFO Read Test

class AFIFO_rd extends uvm_AFIFO_test;
`uvm_component_utils(AFIFO_rd)

	function new(string name = "", uvm_component parent = null);
      	  super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
	 super.build_phase(phase);
    	 uvm_resource_db#(int)::set("GLOBAL","RPT_CNT_RD",5,this);
	endfunction

    // Run phase: Start the sequence and execute the test case
    task run_phase(uvm_phase phase);
//        uvm_AFIFO_Wr_sequence wr_seq;
	uvm_AFIFO_Rd_seq rd_seq;

//        wr_seq = uvm_AFIFO_Wr_sequence::type_id::create("wr_seq", this);
	rd_seq = uvm_AFIFO_Rd_seq::type_id::create("rd_seq", this);

	phase.raise_objection(this);
	phase.phase_done.set_drain_time(this,100);
//		wr_seq.start(env.Wr_agent.afifo_Wr_seqr);
		rd_seq.start(env.Rd_agent.Rd_sqr);
	phase.drop_objection(this);
	endtask	
    

endclass


//  Write & Read Test
class AFIFO_wr_rd extends uvm_AFIFO_test;
`uvm_component_utils(AFIFO_wr_rd)

	function new(string name = "", uvm_component parent = null);
      	  super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
	 super.build_phase(phase);
    	 uvm_resource_db#(int)::set("GLOBAL","RPT_CNT_RD",30,this);
		 uvm_resource_db#(int)::set("GLOBAL","RPT_CNT_WR",30,this);
	endfunction

    // Run phase: Start the sequence and execute the test case
    task run_phase(uvm_phase phase);
  //  `uvm_info("AFIFO_wr_rd", "Running Test Case 1: Read and Writes", UVM_LOW);
    uvm_AFIFO_Wr_sequence wr_seq;
	uvm_AFIFO_Rd_seq rd_seq;
    wr_seq = uvm_AFIFO_Wr_sequence::type_id::create("wr_seq", this);
	rd_seq = uvm_AFIFO_Rd_seq::type_id::create("rd_seq", this);

	phase.raise_objection(this);
//	phase.phase_done.set_drain_time(this,100);
        //wr_seq.start(env.Wr_agent.afifo_Wr_seqr);
		//rd_seq.start(env.Rd_agent.Rd_sqr);
		fork
        begin 
			//`uvm_info("AFIFO_full_empty", "Running Test Case 1: Read and Writes", UVM_LOW)
			wr_seq.start(env.Wr_agent.afifo_Wr_seqr);
		end
		begin repeat(2) #20
			rd_seq.start(env.Rd_agent.Rd_sqr);
		end
		join

	phase.drop_objection(this);
	endtask	
    
    
endclass

//  Write & Read Test
class AFIFO_full_empty extends uvm_AFIFO_test;
`uvm_component_utils(AFIFO_rd)

	function new(string name = "", uvm_component parent = null);
      	  super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
	 super.build_phase(phase);
    	 uvm_resource_db#(int)::set("GLOBAL","RPT_CNT",8,this);
	endfunction

    // Run phase: Start the sequence and execute the test case
    task run_phase(uvm_phase phase);
  //  `uvm_info("AFIFO_full_empty", "Running Test Case 1: Read and Writes", UVM_LOW);
    uvm_AFIFO_Wr_sequence wr_seq;
	uvm_AFIFO_Rd_seq rd_seq;
    wr_seq = uvm_AFIFO_Wr_sequence::type_id::create("wr_seq", this);
	rd_seq = uvm_AFIFO_Rd_seq::type_id::create("rd_seq", this);

	phase.raise_objection(this);
	phase.phase_done.set_drain_time(this,100);
		forever begin
        begin 
			`uvm_info("AFIFO_full_empty", "Running Test Case 1: Read and Writes", UVM_LOW)
			wr_seq.start(env.Wr_agent.afifo_Wr_seqr);
		end
		begin repeat(2) #20
			rd_seq.start(env.Rd_agent.Rd_sqr);
		end
		end
	phase.drop_objection(this);
	endtask	
    
    
endclass


