module alu_tb;

    logic [31:0] a, b, result, yexpected;
    logic [3:0] select;
    logic zeroFlag;

    alu alu_instance (
        .a(a),
        .b(b),
        .select(select),
        .zeroFlag(zeroFlag), // FIX-ME test zeroflag
        .result(result)
    );

    function logic [31:0] expected_alu(input logic [31:0] a, b, input logic [3:0] select);
        case(select)
            4'b0000 : expected_alu = a + b; // add
            4'b0001 : expected_alu = a - b; // sub
            4'b0010 : expected_alu = a & b; // and
            4'b0011 : expected_alu = a | b; // or
            4'b0100 : expected_alu = a ^ b; // xor
            4'b0101 : expected_alu = a << b[4:0]; // sll
            4'b0110 : expected_alu = a >> b[4:0]; // slr
            4'b0111 : expected_alu = a >>> b[4:0]; // sar
            4'b1000 : expected_alu = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0; // slt
            4'b1001 : expected_alu = (a < b) ? 32'd1 : 32'd0; // sltu
 
            default : expected_alu = 32'bx;
        endcase     
    endfunction
    
    initial 
        begin
            yexpected = 0;
            for (int i = 0; i < 16; i++) 
                begin
                    a = $urandom;
                    b = $urandom;
                    select = i;
                    #1;
                    yexpected = expected_alu(a, b, select);

                    if(yexpected != result) 
                        $display("Error expected: %h result: %h", yexpected, result);
                    else
                        $display("PASS select: %h", select);
                end
            $finish;
            
            

        
        end
    

endmodule
