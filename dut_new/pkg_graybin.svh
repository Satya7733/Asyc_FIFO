package pkg_graybin; 

parameter int DATASIZE = 8; 
parameter int DEPTH = 8;

    function automatic logic [$clog2(DEPTH):0] g2b (input logic [$clog2(DEPTH):0] g);
        logic [$clog2(DEPTH):0] b;
        integer i;
	b[$clog2(DEPTH)] = g[$clog2(DEPTH)];
        for (i = $clog2(DEPTH)-1; i >= 0; i--) begin
            b[i] = b[i+1]^g[i];
        end
        return b;
    endfunction

    // Function to convert binary to Gray code
    function automatic logic [$clog2(DEPTH):0] b2g (input logic [$clog2(DEPTH):0] b);
        logic [$clog2(DEPTH):0] g;
        integer i;
	g[$clog2(DEPTH)] = b[$clog2(DEPTH)];
        for (i = $clog2(DEPTH)-1; i >= 0; i--) begin
            g[i] = b[i+1] ^ b[i];
        end
        
        return g;
    endfunction

endpackage : pkg_graybin
