module alu_decoder_tb;
    logic [1:0] ALU_op_in;
    logic op_5_in;
    logic [2:0] funct3;
    logic funct7;

    logic [2:0] ALU_ctrl;
    logic [2:0] ALU_ctrl_exp;

    int errors;

    alu_decoder alu_decoder_instance (
        .ALU_op_in(ALU_op_in),
        .op_5_in(op_5_in),
        .funct3(funct3),
        .funct7(funct7),
        .ALU_ctrl(ALU_ctrl)
    );

    task automatic drive (
        input logic [1:0] ALUop, 
        input logic [2:0] f3, 
        input logic op5, 
        input logic f7
        );

        // drives dut
        ALU_op_in = ALUop;
        funct3 = f3;
        op_5_in = op5;
        funct7 = f7;

        // add for lw, sw
        if(ALUop === 2'b00)
            ALU_ctrl_exp = 3'b000;
        // beq
        else if(ALUop === 2'b01)
            ALU_ctrl_exp = 3'b001;
        // R-type
        else if (ALUop === 2'b10)
            begin
                if ((f3 === 3'b000) && (~(op5 || f7)))
                    ALU_ctrl_exp = 3'b000; // add

                else if ((f3 === 3'b000) && (op5 & f7))
                    ALU_ctrl_exp = 3'b001; // sub

                else if (f3 === 3'b010)
                    ALU_ctrl_exp = 3'b101; // slt

                else if (f3 === 3'b110)
                    ALU_ctrl_exp = 3'b011; // or

                else if (f3 === 3'b111)
                    ALU_ctrl_exp = 3'b010; // and
            end

        else
            ALU_ctrl_exp = 3'bxxx;

    endtask

    task automatic check(input string type_op);
        #1;


        assert(ALU_ctrl === ALU_ctrl_exp)
        else
            begin
                $display("FAILED for %s", type_op);
                $display("Expected Val = %b DUT Val = %b", ALU_ctrl_exp, ALU_ctrl);
                errors++;
            end



    endtask
    
    
    initial 
        begin
            errors = 0;
            
            
            drive(2'b00, 3'bxxx, 1'bx, 1'bx);
            check("add for lw & sw");
            

            drive(2'b01, 3'bxxx, 1'bx, 1'bx);
            check("beq");


            // R-type
            drive(2'b10, 3'b000, 1'b0, 1'b0);
            check("add 00");
            drive(2'b10, 3'b000, 1'b0, 1'b1);
            check("add 01");
            drive(2'b10, 3'b000, 1'b1, 1'b0);
            check("add 10");

            drive(2'b10, 3'b000, 1'b1, 1'b1);
            check("sub");

            drive(2'b10, 3'b010, 1'bx, 1'bx);
            check("slt");

            drive(2'b10, 3'b110, 1'bx, 1'bx);
            check("or");

            drive(2'b10, 3'b111, 1'bx, 1'bx);
            check("and");

            $display("Test finished with %d errors", errors);
            $finish;
        
        
        end
    
    
endmodule
