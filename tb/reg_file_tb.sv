module reg_file_tb;
    logic clk, reset, WE3;
    logic [4:0] A1, A2, A3;
    logic [31:0] WD3, RD1, RD2;
    int errors;
    

    reg_file reg_file_inst (
        .clk(clk),
        .reset(reset),
        .WE3(WE3),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .WD3(WD3),
        .RD1(RD1),
        .RD2(RD2)
    );

    // Generate clock
    initial clk = 0;
    always #5 clk = ~clk;

    logic [31:0] expected_reg [31:0]; // score board
    
    task automatic randomize_input(ref logic [4:0] A1, A2, A3, ref logic [31:0] WD3, ref logic WE3);
        A1 = $urandom_range(31,0);
        A2 = $urandom_range(31,0);
        A3 = $urandom_range(31,0);
        WD3 = $urandom;
        WE3 = $urandom_range(1,0);;
        
    endtask


    initial
        begin
            errors = 0;
            WD3 = 0;
            WE3 = 0;
            A1 = 0;
            A2 = 0;
            A3 = 0;

            // initialize scoreboard
            for (int i = 0; i < 32; i++) 
                    expected_reg[i] = '0;
            

            // Initial reset
            reset = 1;
            @(posedge clk);
            @(posedge clk);

            for (int i = 0; i < 32; i++) 
                begin
                    A1 = i;
                    @(posedge clk) // prevents race
                    if(RD1 !== expected_reg[A1])
                        begin
                            $display("FAILED reset test");
                            errors++;
                        end
                
                end
            
            reset = 0;
            @(posedge clk);


            /*  Stress test
            for (int i = 0; i < 1000; i++) 
                begin
                    randomize_input(A1, A2, A3, WD3, WE3);
                    @(posedge clk);
                    #1;
                
                end
            */
            
            // mid-test reset
            reset = 1;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
                

            // basic read write test
            WE3 = 1;
            A3 = 6;
            WD3 = 32'h 0000_1234; // 4460
            A1 = 6;
            @(posedge clk);
                

            // write multiple times test
            WE3 = 1;

            A3 = 2;
            A1 = 2;

            WD3 = 32'h 0000_1234;
            @(posedge clk)
            WD3 = 32'h 0000_5678;
            @(posedge clk)
            WD3 = 32'h ABCD_0000;
            @(posedge clk);
                
            // x0 register cant be overwritten test
            A3 = 0;
            WE3 = 1;
            WD3 = 32'h 0000_1234;
            A2 = 0;
            @(posedge clk)
            if(RD2 !== 0)
                begin
                    $display("FAILED x0 reg lost value");
                    errors++;

                end
                
        

            // Write enable disabled test
            WE3 = 0;
            A3 = 10;
            A1 = 10;
            WD3 = 32'h 0000_5678; 
            @(posedge clk);

            @(posedge clk); // actual test/check happens at N+1 posedge clk for every test
        
            


            $display("Test finished with %d", errors);
            $finish;
            
        end
    

    // Scoreboard(expected_reg)
    always@(posedge clk)
        begin
            if(reset)
                begin
                    for (int i = 0; i < 32; i++) 
                        expected_reg[i] <= '0;
                end
            else
                begin
                    if(WE3 && (A3 != 0))
                        expected_reg[A3] <= WD3;
                end
                
        end

    

    // Checker
    always@(posedge clk)
        begin
            if(!reset)
                begin
                    if(expected_reg[A1] !== RD1) 
                        begin
                            $display("Register A1: %d, Expected Result: %d Result: %d", A1, expected_reg[A1], RD1);
                            errors++;
                        end
                    if(expected_reg[A2] !== RD2) 
                        begin
                            $display("Register A2: %d, Expected Result: %d Result: %d", A2, expected_reg[A2], RD2);
                            errors++;
                        end
                end
        end
endmodule
