module alu (
    input logic [31:0] a, b,
    input logic [2:0] select,
    output logic [31:0] result,
    output logic zeroFlag

);

always_comb 
    begin
        case (select)
            3'b000 : result = a + b; // add
            3'b001 : result = a - b; // sub
            3'b010 : result = a & b; // and
            3'b011 : result = a | b; // or
            3'b100 : result = a ^ b; // xor
            3'b101 : result = a << b[4:0]; // sll
            3'b110 : result = a >> b[4:0]; // slr
            3'b111 : result = a >>> b[4:0]; // sar
 
            default : result = 32'bx;
        endcase

        if(result === 0)
            zeroFlag = 1;

        
    end

endmodule





