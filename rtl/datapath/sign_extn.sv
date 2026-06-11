module sign_extn (
    input logic [31:7] sign_ex_addin,
    input logic [1:0] sign_ex_select,
    output logic [31:0] sign_ex_addout
);

always_comb 
    begin
        // sign extended
        sign_ex_addout [31:12] = {20{sign_ex_addin[31]}};

        case (sign_ex_select)

            // offset is stored in 12-bit immediate field instr[31:20] for lw
            2'b00 : sign_ex_addout[11:0] = sign_ex_addin [31:20];

             // offset immediate is stored in instr[31:25] and instr[11:7] for sw
            2'b01 : sign_ex_addout [11:0] = {sign_ex_addin[31:25], sign_ex_addin[11:7]};

            // offset immediate for b type, 13-bit, branch address always will be even, so lsb will always be 0
            2'b10 : sign_ex_addout [11:0] = {sign_ex_addin[7], sign_ex_addin[30:25], sign_ex_addin[11:8], 1'b0};

            default : sign_ex_addout[11:0] = '0;
        endcase
        

        
        

       
        


    end


endmodule