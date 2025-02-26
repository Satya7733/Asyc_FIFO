class uvm_AFIFO_sequence extends uvm_sequence#(uvm_AFIFO_transaction);

	`uvm_object_utils_begin(uvm_AFIFO_sequence)

	function new(string name = "");
		super.new(name);
	endfunction: new

	task body();
		uvm_AFIFO_transaction afifo_tx;

	repeat(15) begin		//can be configured through the UVM factory or testbench components
		afifo_tx = uvm_AFIFO_transaction::typeid::create(.name("afifo_tx"), .context(get_full_name()));

		start_item(afifo_tx); 		//sequence waits for the driver to be ready before sending the transaction
		assert(afifo_tx.randomize());
		finish_item(afifo_tx);		//sequence waits for the driver to complete execution of the current transaction.
	end
	endtask : body
		
endclass : uvm_AFIFO_sequence

typedef uvm_sequencer#(uvm_AFIFO_transaction) uvm_AFIFO_sequencer;