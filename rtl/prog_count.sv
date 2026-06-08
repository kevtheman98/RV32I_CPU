module prog_count(
    input clk, reset,
    input logic [31:0] addin, 
    output logic [31:0] addout);

    always_ff @(posedge clk) 
        begin
            if(reset)
                addout <= '0;
            else
                addout <= addin + 4;
        end

endmodule
    
