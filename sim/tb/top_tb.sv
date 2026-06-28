module top_tb;
    logic clk, reset;


    top top_instance (
        .clk(clk),
        .reset(reset)

    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial 
        begin

            reset = 1;
            @(posedge clk);
            @(posedge clk);
            reset = 0;
            repeat(20) @(posedge clk);
            

            $display("Test finished");
            $finish;
            
        
        end

endmodule
