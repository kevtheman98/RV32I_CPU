module reg_file_tb;
    logic [31:0] expected_reg [31:0]; // score board
    int errors;

    // Generate clock
    logic clk = 0;
    always #5 clk = ~clk;

    //instantiate interface
    reg_file_if vif (
        .clk(clk)
    );
    

    // uses vif variables and clk
    reg_file reg_file_inst (
        .clk(vif.clk),
        .reset(vif.reset),
        .WE3(vif.WE3),
        .A1(vif.A1),
        .A2(vif.A2),
        .A3(vif.A3),
        .WD3(vif.WD3),
        .RD1(vif.RD1),
        .RD2(vif.RD2)
    );

    task automatic apply_reset();
        vif.cb.reset <= 1;
        vif.cb.WE3 <= 0;
        vif.cb.A1 <= 0;
        vif.cb.A2 <= 0;
        vif.cb.A3 <= 0;
        vif.cb.WD3 <= 0;
        repeat(2) @(vif.cb);
        vif.cb.reset <= 0;
        @(vif.cb);
    endtask

    task automatic write_reg(input logic [4:0] reg1, input logic [31:0] data);
        vif.cb.WE3 <= 1;
        vif.cb.A3 <= reg1;
        vif.cb.WD3 <= data;
        @(vif.cb);
        vif.cb.WE3 <= 0;

    endtask
    
    task automatic read_reg(input logic [4:0] reg1, reg2);
        vif.cb.A1 <= reg1;
        vif.cb.A2 <= reg2;
        @(vif.cb);
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
                    vif.cb.A1 <= $urandom_range(0,31);
                    vif.cb.A2 <= $urandom_range(0,31);
                    vif.cb.A3 <= $urandom_range(0,31);
                    vif.cb.WD3 <= $urandom;
                    vif.cb.WE3 <= $urandom_range(0,1);
                    @(vif.cb);
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
            vif.cb.WE3 <= 0;
            vif.cb.WD3 <= 32'h 0000_5678; 
            vif.cb.A3 <= 10;
            read_reg(10, 10);


            $display("Test finished with %d errors", errors);
            $finish;
            
        end
    

    // Scoreboard(expected_reg)
    always@(posedge clk)
        begin
            if(vif.reset) // not cb because outputs cannot be read only driven so it needs to be raw input
                begin
                    for (int i = 0; i < 32; i++) 
                        expected_reg[i] <= '0;
                end
            else
                begin
                    if(vif.WE3 && (vif.A3 != 0))
                        expected_reg[vif.A3] <= vif.WD3;
                end
                
        end

    

    // Checker
    always@(negedge clk) // negedge because checker checks active region but dut and scoreboard are nba scheduled
        begin
            if(!vif.reset)
                begin
                    if(expected_reg[vif.A1] !== vif.RD1) 
                        begin
                            $display("[ERROR] Register A1: %d, Expected Result: %d Result: %d Time: %t", vif.A1, expected_reg[vif.A1], vif.cb.RD1, $time);
                            errors++;
                        end
                    if(expected_reg[vif.A2] !== vif.RD2) 
                        begin
                            $display("[ERROR] Register A2: %d, Expected Result: %d Result: %d Time: %t", vif.A2, expected_reg[vif.A2], vif.cb.RD2, $time);
                            errors++;
                        end
                end
        end
endmodule
