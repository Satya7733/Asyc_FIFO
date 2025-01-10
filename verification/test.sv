
`include "pkg_tb.svh"
program test(wr_intf wr_intf, rd_intf rd_intf);

environment env;

initial begin
	env = new(wr_intf, rd_intf);

env.gen.repeat_count = 10;

env.run();
end

endprogram
