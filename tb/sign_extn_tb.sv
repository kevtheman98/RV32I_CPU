module sign_extn_tb;
    logic [11:0] sign_addin;
    logic [31:0] sign_addout;
    int errors;

    sign_extn sign_extn_instance (
        .sign_addin(sign_addin),
        .sign_addout(sign_addout)
    );

    task automatic test_sign_extn(
        input logic [11:0] initial_val, 
        input logic [31:0] expected_val
        );

        sign_addin = initial_val;
        #1;
        assert (sign_addout === expected_val)
        else
            begin
                $error("Sign extension failed Initial Val: %h, Output: %h, Expected Val: %h", initial_val, sign_addout, expected_val);
                errors++;
            end
 
    endtask


    initial 
        begin
            errors = 0;
            

            test_sign_extn(12'hFFC, 32'hFFFF_FFFC); // -4
            test_sign_extn(12'h000, 32'h0000_0000); 
            test_sign_extn(12'h0FC, 32'h0000_00FC); // 252
            test_sign_extn(12'hFFF, 32'hFFFF_FFFF); // -1

            $display("Test finished with %d errors", errors);
            $finish;
        
        end
    


endmodule