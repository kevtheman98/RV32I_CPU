module prog_count_tb;
    logic reset;
    logic [31:0] addin, addout;
    int errors;

    // clock generate
    logic clk = 0;
    always #5 clk = ~clk;

    prog_count prog_count_instance (
        .clk(clk),
        .reset(reset),
        .addin(addin),
        .addout(addout)
    );

    initial 
        begin
            errors = 0;

            for (int i = 0; i < 100; i++) 
                begin
                    addin = $urandom;
                    // test reset
                    reset = 1;
                    // test at negedge, dut samples at posedge
                    @(posedge clk);
                    @(negedge clk); 
                    if(addout !== 0)
                        begin
                            $display("Reset for PC failed Time: %t", $time);
                            errors++;
                        end
                    // test assign    
                    reset = 0;
                    @(posedge clk);
                    @(negedge clk);
                    if(addin !== addout)
                        begin
                            $display("Assignment for PC failed Time: %t", $time);
                            errors++;
                        end
                end
            
        end
    
    
    

endmodule