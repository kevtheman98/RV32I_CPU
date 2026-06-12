module alu (
    input logic [31:0] a, b,
    input logic [3:0] select,
    output logic [31:0] result,
    output logic zeroFlag

);

always_comb 
    begin
        case (select)
            4'b0000 : result = a + b; // add
            4'b0001 : result = a - b; // sub
            4'b0010 : result = a & b; // and
            4'b0011 : result = a | b; // or
            4'b0100 : result = a ^ b; // xor
            4'b0101 : result = a << b[4:0]; // sll
            4'b0110 : result = a >> b[4:0]; // slr
            4'b0111 : result = a >>> b[4:0]; // sar
            4'b1000 : result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0; // slt
            4'b1001 : result = (a < b) ? 32'd1 : 32'd0; // sltu
 
            default : result = 32'bx;
        endcase

        if(result === 0)
            zeroFlag = 1;

        
    end

endmodule





