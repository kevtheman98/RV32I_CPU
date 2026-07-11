module instr_mem_tb;
    logic [31:0] address;
    logic [31:0] instruction;
    int errors;

    instr_mem dut (
        .address(address),
        .instruction(instruction)
    );

    

    initial 
        begin
            errors = 0;

            $readmemh("default.mem", dut.mem);

            // test ROM[0]
            address = '0;
            #1;
            assert(instruction === dut.mem[0]) 
                else begin
                        $error("ROM read failed, Value: %h, Expected: %h", instruction, dut.mem[0]);
                        errors++;
                    end
                
            
            // test ROM[1]
            address = 32'h0000_0004;
            #1;
            assert(instruction === dut.mem[1]) 
                else begin
                        $error("ROM read failed, Value: %h, Expected: %h", instruction, dut.mem[1]);
                        errors++;
                    end

            $display("Test Finished with %d errors", errors);
            $finish;
            
        end
    

endmodule