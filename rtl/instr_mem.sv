module instr_mem(
    input logic [31:0] address,
    output logic [31:0] instruction
);

    logic [31:0] mem [0:1023];

    
    initial 
        begin
            $readmemh("instr_mem.mem", mem);
        end
    
    // assign instruction for current address
    assign instruction = mem[address[11:2]]; // address (0x0,0x4,0x8) but ROM is (0x0,0x1,0x2) so remove [2:0] (word-indexed)
       
endmodule
