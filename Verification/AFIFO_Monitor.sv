//imports
import AFIFO_Pkg::*;

//class
class AFIFO_Monitor #(parameter DSIZE = 8);

// Handle
//AFIFO_Transaction tr;
virtual AFIFO_Interface vif;

//Mailbox mon to sco
mailbox #(bit[DSIZE -1 :0]) mbx_mon2sco;

//Constructor
function new(mailbox #(bit[DSIZE -1 :0]) mbx_mon2sco);
 this.mbx_mon2sco = mbx_mon2sco;
endfunction

//Event

//Task
task run();

forever begin
 @(posedge vif.rd_clk); 
 if(vif.rd_inc && !vif.rd_empty) begin
 mbx_mon2sco.put(vif.rd_data);
 $display("[MON] : MBX DATA SENT TO SCO %0d", vif.rd_data);
 end
 if(vif.rd_empty) $display("[MON] : READ EMPTY, Nothing to read in FIFO Mem");
 if(vif.wr_full) $display("[MON] : WRITE FULL, Full FIFO Mem");
 
end

endtask

endclass
