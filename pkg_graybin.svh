package pkg_graybin; 

parameter int DATASIZE = 8; 
parameter int DEPTH = 8;

    function automatic logic [$clog2(DEPTH):0] g2b (input logic [$clog2(DEPTH):0] gray);
        logic [$clog2(DEPTH):0] binary;
        integer i;
        binary = 0;
        for (i = $clog2(DEPTH); i >= 0; i--) begin
            binary[i] = ^(gray >> i);
        end
        return binary;
    endfunction

    // Function to convert binary to Gray code
    function automatic logic [$clog2(DEPTH):0] b2g (input logic [$clog2(DEPTH):0] binary);
        logic [$clog2(DEPTH):0] gray;
        integer i;
        for (i = 0; i < $clog2(DEPTH); i++) begin
            gray[i] = binary[i] ^ binary[i + 1];
        end
        gray[$clog2(DEPTH)] = binary[$clog2(DEPTH)];
        return gray;
    endfunction

endpackage : pkg_graybin
