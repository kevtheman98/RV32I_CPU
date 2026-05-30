module alu (
    input logic [32:0] a, b,
    input logic [4:0] select,
    output logic [32:0] result

);

always_comb 
    begin
        case (select)
            4'b0000 : result = a + b;
            4'b0001 : result = a - b;
            4'b0010 : result = a & b;
            4'b0011 : result = a | b;
            4'b0100 : result = ~(a || b);
            4'b0101 : result = a << b;
            4'b0110 : result = a >> b;
            4'b0111 : result = a >>> b;
            4'b1000 : result = ($signed(a) < $signed(b)) ? 1 : 0;
            4'b1001 : result = (a < b) ? 1 : 0;

            default : result = 4'b0000;
        endcase
        
    end

endmodule





