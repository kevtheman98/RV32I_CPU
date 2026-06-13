module adder(
    input logic [31:0] current_address,
    input logic [31:0] increment_addr,
    output logic [31:0] next_address
);

always_comb 
    begin
        // byte addressable each address is 32 bit so for normal operations +4 for branch +whichever branch
        next_address = current_address + increment_addr;    
    end

endmodule