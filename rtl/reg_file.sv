module reg_file(
    input clk, reset, WE3,
    input [4:0] A1, A2, A3,
    input [31:0] WD3,
    output [31:0] RD1, RD2
);


logic [31:0] reg_bank [31:0]; // 32 element x 32 bit registers

assign RD1 = reg_bank[A1];
assign RD2 = reg_bank[A2];

always_ff @(posedge clk) 
    begin
        if(reset)
            for (int i = 0; i < 32; i++) 
                    reg_bank[i] <= '0;
        else
            if(WE3 && (A3 != 0)) // x0 register is always 0 so A3 cannot be x0 register
                reg_bank[A3] <= WD3;
    
    end
endmodule
