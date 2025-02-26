class afifo_sequence extends uvm_sequence#(afifo_transaction);

	`uvm_object_utils_begin(afifo_sequence)

	function new(string name = "afifo_sequence");
		super.new(name);
	endfunction: new

	task body();
		afifo_transaction afifo_tx;

	repeat(15) begin		//can be configured through the UVM factory or testbench components
		afifo_tx = afifo_transaction::typeid::create(.name("afifo_tx"), .context(get_full_name()));

		start_item(afifo_tx); 		//sequence waits for the driver to be ready before sending the transaction
		assert(afifo_tx.randomize());
		finish_item(afifo_tx);		//sequence waits for the driver to complete execution of the current transaction.
	end
	endtask : body
		
endclass : afifo_sequence

typedef uvm_sequencer#(afifo_transaction) uvm_AFIFO_sequencer;