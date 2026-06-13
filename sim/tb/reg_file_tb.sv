module reg_file_tb;
    logic [31:0] expected_reg [31:0]; // score board
    int errors;

    logic reset;
    logic WE3;
    logic [4:0] A1, A2, A3;
    logic [31:0] WD3, RD1, RD2;

    // Generate clock
    logic clk = 0;
    always #5 clk = ~clk;

    // Clocking prevents many NBA & Active race condtions
    clocking cb @(posedge clk);
        default input #1step output #0; // input 1step before clock, output on nba region
        input RD1, RD2;
        output reset, WE3, A1, A2, A3, WD3;
    endclocking
    
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

    task automatic apply_reset();
        cb.reset <= 1;
        cb.WE3 <= 0;
        cb.A1 <= 0;
        cb.A2 <= 0;
        cb.A3 <= 0;
        cb.WD3 <= 0;
        repeat(2) @(cb);
        cb.reset <= 0;
        @(cb);
    endtask

    task automatic write_reg(input logic [4:0] reg1, input logic [31:0] data);
        cb.WE3 <= 1;
        cb.A3 <= reg1;
        cb.WD3 <= data;
        @(cb);
        cb.WE3 <= 0;
        @(cb);

    endtask
    
    task automatic read_reg(input logic [4:0] reg1, reg2);
        cb.A1 <= reg1;
        cb.A2 <= reg2;
        @(cb);
    endtask

    initial
        begin
            errors = 0;
        
            // initialize scoreboard
            apply_reset();

            // verify reset
            for (int i = 0; i < 32; i++) 
                begin
                    read_reg(i, i);
                end
            
            // Stress test
            for (int i = 0; i < 1000; i++) 
                begin
                    cb.A1 <= $urandom_range(0,31);
                    cb.A2 <= $urandom_range(0,31);
                    cb.A3 <= $urandom_range(0,31);
                    cb.WD3 <= $urandom;
                    cb.WE3 <= $urandom_range(0,1);
                    @(cb);
                end
            
                
            // basic read write test to reg 6
            write_reg(6, 32'h 0000_1234);
            read_reg(6, 6);
        
                

            // write multiple times test to reg 2
            write_reg(2, 32'h 0000_5678);
            write_reg(2, 32'h 0000_9ABC);
            write_reg(2, 32'h 0000_DEF0);
            read_reg(2, 2);

                
            // x0 register cant be overwritten test
            write_reg(0, 32'h 0000_1234);
            write_reg(0, 32'h 0000_5678);
            read_reg(0, 0);
        

            // Write enable disabled test to reg 10
            cb.WE3 <= 0;
            cb.WD3 <= 32'h 0000_5678; 
            cb.A3 <= 10;
            read_reg(10, 10);


            $display("Test finished with %d errors", errors);
            $finish;
            
        end
    

    // Scoreboard(expected_reg)
    always@(posedge clk)
        begin
            if(reset) // not cb because outputs cannot be read only driven so it needs to be raw input
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
    always@(negedge clk) // negedge because checker checks active region but dut and scoreboard are nba scheduled
        begin
            if(!reset)
                begin
                    if(expected_reg[A1] !== RD1) 
                        begin
                            $display("[ERROR] Register A1: %d, Expected Result: %d Result: %d Time: %t", A1, expected_reg[A1], RD1, $time);
                            errors++;
                        end
                    if(expected_reg[A2] !== RD2) 
                        begin
                            $display("[ERROR] Register A2: %d, Expected Result: %d Result: %d Time: %t", A2, expected_reg[A2], RD2, $time);
                            errors++;
                        end
                end
        end
endmodule
