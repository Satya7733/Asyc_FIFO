class afifo_sequencer extends uvm_sequencer #(afifo_seq_item)

// ========== FACTORY REGISTRATION ==========
    `uvm_component_utils(afifo_sequencer)


// ========== MEMORY CONSTRUCTOR ==========

function new(string name = "afifo_sequencer", uvm_component parent)
    super.new(name,parent);
endfunction: new

endclass: afifo_sequencer
