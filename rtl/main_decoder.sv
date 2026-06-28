module main_decoder(
    input logic [6:0] main_op_in,
    output logic reg_write_sig,
    output logic [1:0] exten_src_sig,
    output logic ALU_src_sig,
    output logic mem_write_sig,
    output logic [1:0] result_sig,
    output logic branch_sig,
    output logic [1:0] ALU_op_out,
    output logic jump_sig
    
);

always_comb begin
    case (main_op_in)

        // lw
        7'b000_0011 :   begin
                            reg_write_sig = 1'b1;
                            exten_src_sig = 2'b00;
                            ALU_src_sig = 1'b1;
                            mem_write_sig = 1'b0;
                            result_sig = 2'b01;
                            branch_sig = 1'b0;
                            ALU_op_out = 2'b00;
                            jump_sig = 1'b0;
                        end
        // sw
        7'b010_0011 :   begin
                            reg_write_sig = 1'b0;
                            exten_src_sig = 2'b01;
                            ALU_src_sig = 1'b1;
                            mem_write_sig = 1'b1;
                            result_sig = 2'bxx;
                            branch_sig = 1'b0;
                            ALU_op_out = 2'b00;
                            jump_sig = 1'b0;
                        end
        // R-type 
        7'b011_0011 :   begin
                            reg_write_sig = 1'b1;
                            exten_src_sig = 2'bxx;
                            ALU_src_sig = 1'b0;
                            mem_write_sig = 1'b0;
                            result_sig = 2'b00;
                            branch_sig = 1'b0;
                            ALU_op_out = 2'b10;
                            jump_sig = 1'b0;
                        end
        // branch
        7'b110_0011 :   begin
                            reg_write_sig = 1'b0;
                            exten_src_sig = 2'b10;
                            ALU_src_sig = 1'b0;
                            mem_write_sig = 1'b0;
                            result_sig = 2'b00;
                            branch_sig = 1'b1;
                            ALU_op_out = 2'b01;
                            jump_sig = 1'b0;
                        end
        // addi
        7'b001_0011 :   begin
                            reg_write_sig = 1'b1;
                            exten_src_sig = 2'b00;
                            ALU_src_sig = 1'b1;
                            mem_write_sig = 1'b0;
                            result_sig = 2'b00;
                            branch_sig = 1'b0;
                            ALU_op_out = 2'b10;
                            jump_sig = 1'b0;
                            
                        end
        
        // jump & link
        7'b110_1111 :   begin
                            reg_write_sig = 1'b1;
                            exten_src_sig = 2'b11;
                            ALU_src_sig = 1'bx;
                            mem_write_sig = 1'b0;
                            result_sig = 2'b10;
                            branch_sig = 1'b0;
                            ALU_op_out = 2'bxx;
                            jump_sig = 1'b1;

                        end
        

        default :   begin
                        reg_write_sig = 1'bx;
                        exten_src_sig = 2'bxx;
                        ALU_src_sig = 1'bx;
                        mem_write_sig = 1'bx;
                        result_sig = 1'bx;
                        branch_sig = 1'bx;
                        ALU_op_out = 2'bxx;


                    end
    endcase

    
end

endmodule