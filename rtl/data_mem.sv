module data_mem (
    input logic clk, WE,
    input logic [31:0] address, WD,
    output logic [31:0] RD
);

logic [31:0] d_mem[0:1023];

// Write at clk edge
always_ff @(posedge clk) 
    begin
        if (WE && ((address[31:2]) < 1024)) // address within valid range, [31:2] gets rid of 1-4, byte adressable
                d_mem[address[31:2]] <= WD;
    end

// read constantly as long as address valid
always_comb 
    begin
        if(address[31:2] < 1024)
                RD = d_mem[address[31:2]];
        else
            RD = '0; 
    end


endmodule