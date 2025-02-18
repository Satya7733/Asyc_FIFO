import AFIFO_Pkg::*;

class AFIFO_Environment #(parameter DSIZE = 8);

// Handle
AFIFO_Driver dr;
AFIFO_Generator gr;
AFIFO_Monitor mo;
AFIFO_Scoreboard sco;

//events
//event sco_nxt;
event nextgd;
event next_gen;

//Mailbox
mailbox #(AFIFO_Transaction) mbx_mon2sco; // monitor to scoreboard
mailbox #(AFIFO_Transaction) mbx_gen2drv; //generator to driver
mailbox #(bit [DSIZE-1:0]) mbx_drv2sco;    // driver to scoreboard

//Interface
virtual AFIFO_Interface vif;

//Constructor Function
function new(virtual AFIFO_Interface vif);

mbx_mon2sco = new();
mbx_gen2drv = new();
mbx_drv2sco = new();

dr = new(mbx_gen2drv, mbx_drv2sco);
gr = new(mbx_gen2drv);
mo = new(mbx_mon2sco);
sco = new(mbx_mon2sco,mbx_drv2sco);

this.vif = vif;
dr.vif = this.vif;
mo.vif_mon = this.vif;
sco.vif = this.vif;

gr.drv_nxt = nextgd;
dr.drv_nxt = nextgd;
gr.gen_done = next_gen;
dr.gen_done = next_gen;
endfunction
 
task run();
fork 
gr.run();
dr.run();
mo.run();
sco.run();
join_any 

endtask

endclass
