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
            addin = 0;


            // initial reset
            reset = 1;
            repeat (2) @(posedge clk);
            reset = 0;
            @(posedge clk)

            // stress test
            for (int i = 0; i < 100; i++) 
                begin
                    addin = $urandom;
                    
                    // test assign    
                    @(posedge clk);
                    #1;

                    assert(addin === addout)
                    else
                        begin
                            $error("Assignment for PC failed Time: %t", $time);
                            errors++;
                        end
                end

            // test reset
            reset = 1;

            @(posedge clk);
            #1;

            assert(addout === 0)
            else
                begin
                    $error("Reset for PC failed Time: %t", $time);
                    errors++;
                end

            $display("Test finished with %d errors", errors);
            $finish;
            
        end

endmodule