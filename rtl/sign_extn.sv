module sign_extn (
    input logic [31:20] sign_addin,
    output logic [31:0] sign_addout
);

always_comb 
    begin
        // offset is stored in 12-bit immediate field instr[31:20] 
        sign_addout [31:12] = {20{sign_addin[31]}};
        sign_addout[11:0] = sign_addin [31:20];

    end


endmodule