module sign_extn (
    input logic [31:0] sign_ex_in,
    input logic [1:0] sign_ex_select,
    output logic [31:0] sign_ex_out
);

always_comb 
    begin

        case (sign_ex_select)

            // I-type 12-bit immediate field instr[31:20] 
            2'b00 : sign_ex_out = {
                {20{sign_ex_in[31]}},
                sign_ex_in [31:20]
            };

             // S-type offset immediate is stored in instr[31:25] and instr[11:7] 
            2'b01 : sign_ex_out [31:0] = {
                {20{sign_ex_in[31]}},
                sign_ex_in[31:25], 
                sign_ex_in[11:7]
            };

            // branch & jump always will always be multiples of 2, so lsb will always be 0

            // B-type 13-bit 
            2'b10 : sign_ex_out [31:0] = {
                {20{sign_ex_in[31]}},
                sign_ex_in[7], 
                sign_ex_in[30:25], 
                sign_ex_in[11:8], 
                1'b0
            };

            // J type 21-bit 
            2'b11 : sign_ex_out [31:0] = {
                {12{sign_ex_in[31]}},
                sign_ex_in[19:12],
                sign_ex_in[20],
                sign_ex_in[30:21],
                1'b0
            };

            default : sign_ex_out[31:0] = 'x;
        endcase
        

        
        

       
        


    end


endmodule