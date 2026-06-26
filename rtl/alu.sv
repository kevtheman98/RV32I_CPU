module alu (
    input logic [31:0] a, b,
    input logic [2:0] select,
    output logic [31:0] ALUResult,
    output logic zeroFlag

);

always_comb 
    begin
        case (select)
            3'b000 : ALUResult = a + b; // add
            3'b001 : ALUResult = a - b; // sub
            3'b010 : ALUResult = a & b; // and
            3'b011 : ALUResult = a | b; // or
            3'b100 : ALUResult = a ^ b; // xor
            3'b101 : ALUResult = a << b[4:0]; // sll
            3'b110 : ALUResult = a >> b[4:0]; // slr
            3'b111 : ALUResult = a >>> b[4:0]; // sar
 
            default : ALUResult = 32'bx;
        endcase

        if(ALUResult === 0)
            zeroFlag = 1;
        else
            zeroFlag = 0;

        
    end

endmodule





