module alu_decoder(
    input logic [1:0] ALU_op_in,
    input logic op_5_in,
    input logic [2:0] funct3,
    input logic funct7,
    
    output logic [2:0] ALU_ctrl

);

always_comb 
    begin
        logic [6:0] ALU_bus;

        ALU_bus = {ALU_op_in, funct3, op_5_in, funct7};

        case (ALU_bus)
            // add for lw sw
            7'b00_xxx_xx : ALU_ctrl = 000;
            // beq
            7'b01_xxx_xx : ALU_ctrl = 001;
            // R-type
            7'b10_000_00, 7'b10_000_01, 7'b10_000_10 : ALU_ctrl = 000; // add
            7'b10_000_11 : ALU_ctrl = 001; // sub
            7'b10_010_xx : ALU_ctrl = 101; // slt
            7'b10_110_xx : ALU_ctrl = 011; // or
            7'b10_111_xx : ALU_ctrl = 010; // and
            
            default : ALU_ctrl = 3'bxxx;
        endcase
        
    
    end

endmodule
