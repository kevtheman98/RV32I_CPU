module main_decoder_tb;
    logic [6:0] main_op_in;
    logic reg_write_sig;
    logic [1:0] exten_src_sig;
    logic ALU_src_sig;
    logic mem_write_sig;
    logic result_sig;
    logic branch_sig;
    logic [1:0] ALU_op_out;
    int errors = 0;


    main_decoder main_decoder_instance (
        .main_op_in(main_op_in),
        .reg_write_sig(reg_write_sig),
        .exten_src_sig(exten_src_sig),
        .ALU_src_sig(ALU_src_sig),
        .mem_write_sig(mem_write_sig),
        .result_sig(result_sig),
        .branch_sig(branch_sig),
        .ALU_op_out(ALU_op_out)
    );


    task automatic check(
        input string test_name,
        input logic reg_write_exp,
        input logic [1:0] exten_src_exp,
        input logic ALU_src_exp,
        input logic mem_write_exp,
        input logic result_exp,
        input logic branch_exp,
        input logic [1:0] ALU_op_out_exp
    );
        if(
            reg_write_exp === reg_write_sig &&
            exten_src_exp === exten_src_sig &&
            ALU_src_exp === ALU_src_sig &&
            mem_write_exp === mem_write_sig &&
            result_exp === result_sig &&
            branch_exp === branch_sig &&
            ALU_op_out_exp === ALU_op_out
        )
            begin
                $display("Test for %s passed", test_name);
            end
        else
            begin
                $error("[@%t] Test for %s failed", $time, test_name);
                errors++;
            end
            

    endtask


    
    initial 
        begin

            main_op_in = 7'b000_0011;
            #1;
            check(
                "lw",
                1'b1,
                2'b00,
                1'b1,
                1'b0,
                1'b1,
                1'b0,
                2'b00
            );

            main_op_in = 7'b010_0011;
            #1
            check(
                "sw",
                1'b0,
                2'b01,
                1'b1,
                1'b1,
                1'bx,
                1'b0,
                2'b00
            );

            main_op_in = 7'b011_0011;
            #1
            check(
                "R-type",
                1'b1,
                2'bxx,
                1'b0,
                1'b0,
                1'b0,
                1'b0,
                2'b10
            );

            main_op_in = 7'b110_0011;
            #1;
            check(
                "Branch",
                1'b0,
                2'b10,
                1'b0,
                1'b0,
                1'bx,
                1'b1,
                2'b01
            );

            main_op_in = 7'b111_1111;
            #1;
            check(
                "default",
                1'b0,
                2'b00,
                1'b0,
                1'b0,
                1'b0,
                1'b0,
                2'b00
            );

            $display("Test finished with %d errors", errors);
            $finish;


            



        
        end
    

endmodule
