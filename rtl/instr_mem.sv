module instr_mem(
    input logic [31:0] address,
    output logic [31:0] instruction
);

    logic [31:0] ROM [0:1023];

    
    // temp ROM values for testing
    assign ROM[0] = 32'h 01498933; // add s2, s3, s4
    assign ROM[1] = 32'h 40730283; // sub t0, t1, t2
    
    // assign instruction for current address
    assign instruction = ROM[address >> 2]; // address (0x0,0x4,0x8) but ROM is (0x0,0x1,0x2) so divide 4 called (byte adressable)
       
endmodule
