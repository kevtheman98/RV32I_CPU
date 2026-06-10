module mux (
    input logic [31:0] a, b,
    input logic sel,
    output logic [31:0] y
);

always_comb
    begin
        case(sel)
            1'b0 : y = a;
            1'b1 : y = b;
            
            default : y = '0;
        endcase
    end
endmodule