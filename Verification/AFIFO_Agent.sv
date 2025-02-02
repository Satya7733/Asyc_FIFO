class AFIFO_Agent;

virtual AFIFO_Interface vif;
AFIFO_Generator gr;
AFIFO_Driver dr;
AFIFO_Monitor mr;
mailbox mbx_gen2drv;
mailbox mbx_drv2sco;

// ========== EVENT DECLARATION ==========
event gen_done;
event sco_nxt;
event drv_nxt;

// ========== CONSTRUCTOR ==========


endclass