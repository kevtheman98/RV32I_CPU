module pc_adder(
    input logic [31:0] current_address,
    output logic [31:0] next_address
);

always_comb 
    begin
        // byte addressable each address is 32 bit
        next_address = current_address + 4;    
    end

endmodule