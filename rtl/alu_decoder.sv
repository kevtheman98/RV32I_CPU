module alu_decoder(
    input logic [1:0] ALU_op_in,
    input logic op_5_in,
    input logic [2:0] funct3,
    input logic funct7,
    
    output logic [2:0] ALU_ctrl

);

logic [6:0] ALU_bus;

always_comb 
    begin
        
        ALU_bus = {ALU_op_in, funct3, op_5_in, funct7};

        casez (ALU_bus)
            // add for lw sw
            7'b00_???_?? : ALU_ctrl = 3'b000;
            // beq
            7'b01_???_?? : ALU_ctrl = 3'b001;
            // R-type
            7'b10_000_00, 7'b10_000_01, 7'b10_000_10 : ALU_ctrl = 3'b000; // add
            7'b10_000_11 : ALU_ctrl = 3'b001; // sub
            7'b10_010_?? : ALU_ctrl = 3'b101; // slt
            7'b10_110_?? : ALU_ctrl = 3'b011; // or
            7'b10_111_?? : ALU_ctrl = 3'b010; // and
            
            default : ALU_ctrl = 3'bxxx;
        endcase
        
    
    end

endmodule
