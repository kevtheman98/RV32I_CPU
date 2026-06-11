module main_decoder(
    input logic [6:0] main_op_in,
    output logic reg_write_sig,
    output logic [1:0] exten_out_sig,
    output logic ALU_src_sig,
    output logic mem_write_sig,
    output logic result_sig,
    output logic branch,
    output logic ALU_op
    
);

always_comb begin
    case (main_op_in)

        // lw
        7'b000_0011 :   begin
                            reg_write_sig = 1'b1;
                            exten_out_sig = 2'b00;
                            ALU_src_sig = 1'b1;
                            mem_write_sig = 1'b0;
                            result_sig = 1'b1;
                            branch = 1'b0;
                            ALU_op = 2'b00;
                        end
        // sw
        7'b010_0011 :   begin
                            reg_write_sig = 1'b0;
                            exten_out_sig = 2'b01;
                            ALU_src_sig = 1'b1;
                            mem_write_sig = 1'b1;
                            result_sig = 1'bx;
                            branch = 1'b0;
                            ALU_op = 2'b00;
                        end
        // R-type 
        7'b011_0011 :   begin
                            reg_write_sig = 1'b1;
                            exten_out_sig = 2'bxx;
                            ALU_src_sig = 1'b0;
                            mem_write_sig = 1'b0;
                            result_sig = 1'b0;
                            branch = 1'b0;
                            ALU_op = 2'b10;
                        end
        // branch
        7'b110_0011 :   begin
                            reg_write_sig = 1'b0;
                            exten_out_sig = 2'b10;
                            ALU_src_sig = 1'b0;
                            mem_write_sig = 1'b0;
                            result_sig = 1'bx;
                            branch = 1'b1;
                            ALU_op = 2'b01;
                        end

        default :   begin
                        reg_write_sig = 1'b0;
                        exten_out_sig = 2'b00;
                        ALU_src_sig = 1'b0;
                        mem_write_sig = 1'b0;
                        result_sig = 1'b0;
                        branch = 1'b0;
                        ALU_op = 2'b00;


                    end
    endcase

    
end


endmodule