module top_tb;
    logic clk, reset;
    logic [31:0] pc_out, instruct_out, RD1_out, RD2_out;

    top top_instance (
        .clk(clk),
        .reset(reset),
        .pc_out(pc_out),
        .instruct_out(instruct_out),
        .RD1_out(RD1_out),
        .RD2_out(RD2_out)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial 
        begin

            reset = 1;
            @(posedge clk);
            @(posedge clk);
            reset = 0;
            repeat(3) @(posedge clk);
            
        
        end

endmodule
