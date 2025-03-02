class uvm_AFIFO_Rd_cov extends uvm_subscriber#(uvm_AFIFO_Rd_sequence_item);
uvm_AFIFO_Rd_sequence_item seq_item;
`uvm_component_utils(uvm_AFIFO_Rd_cov)

covergroup rd_cg;
    // Coverpoint For Data 
    option.per_instance = 1;
    data_depth: coverpoint seq_item.rd_data {
      bins depth_bins = {[0:255]}; // Assuming data depth is 8 bits as per FIFO depth analysis
      bins depth_zero = {0}; // Directly specify the value for depth 0
    }

    // Coverpoint for read enable signal to capture read operations
    rd_inc: coverpoint seq_item.rd_inc {
      bins read_increment = {1};
    }

    // Coverpoint for empty signal to monitor FIFO empty status
    rd_empty: coverpoint seq_item.rd_empty {
      bins empty = {1};
      bins not_empty = {0};
    }

     // Coverpoint for tracking the reset signal	
	 reset: coverpoint seq_item.rd_rst {
      bins reset_not_active = {1};
    }

    // Cross coverage between read increment and FIFO empty status
    read_inc_vs_fifo_empty: cross rd_inc, rd_empty;



  endgroup

function new(string name= "",uvm_component parent = null);
super.new(name,parent);
rd_cg= new();
endfunction

function void write(uvm_AFIFO_Rd_sequence_item t);
	$cast(seq_item,t);
	rd_cg.sample();
endfunction


endclass