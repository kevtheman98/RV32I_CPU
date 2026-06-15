module instr_mem_tb;
    parameter tb_ROM_0 = 32'h0044A303;
    parameter tb_ROM_1 = 32'h0064A423;
    
    
    logic [31:0] address;
    logic [31:0] instruction;
    int errors;

    instr_mem instr_mem_instance (
        .address(address),
        .instruction(instruction)
    );

    initial 
        begin
            errors = 0;

            // test ROM[0]
            address = '0;
            #1;
            assert(instruction === tb_ROM_0) 
                else begin
                        $error("ROM read failed, Value: %h, Expected: %h", instruction, tb_ROM_0);
                        errors++;
                    end
                
            
            // test ROM[1]
            address = 32'h0000_0004;
            #1;
            assert(instruction === tb_ROM_1) 
                else begin
                        $error("ROM read failed, Value: %h, Expected: %h", instruction, tb_ROM_1);
                        errors++;
                    end

            $display("Test Finished with %d errors", errors);
            $finish;
            
        end
    

endmodule