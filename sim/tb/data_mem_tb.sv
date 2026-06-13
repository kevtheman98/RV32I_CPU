module data_mem_tb
    #(
        // data testing vals 
        parameter logic [31:0] data1 = 32'h0000_ABCD,
        parameter logic [31:0] data2 = 32'h0000_1234,
        parameter logic [31:0] data3 = 32'hABCD_1234
        
    );

    logic WE;
    logic [31:0] address;
    logic [31:0] RD, WD;


    //Generate clk
    logic clk = 0;
    always #5 clk = ~clk;

    // Clocking prevents many NBA & Active race condtions
    clocking cb @(posedge clk);
        default input #1step output #0; // input 1 step before clock, output on nba region
        input RD;
        output address, WE, WD;
    endclocking

    data_mem data_mem_instance (
        .clk(clk),
        .address(address),
        .WE(WE),
        .RD(RD),
        .WD(WD)
    );

    task automatic apply_reset();
        cb.address <= 0;
        cb.WE <= 0;
        cb.WD <= 0;
        repeat(2) @(cb);
    endtask

    task automatic write_mem(input logic [31:0] addressin, input logic [31:0] data_towrite);
        cb.WE <= 1;
        cb.WD <= data_towrite;
        cb.address <= addressin;
        @(cb);
        cb.WE <= 0;
        @(cb);
    endtask

    
    // read_mem not strictly necessary as read is combinationally but gives extra buffer and cleaner logic
    task automatic read_mem(input logic [31:0] addressin);
        cb.address <= addressin;
        @(cb);
    endtask

    int errors;

    // use raw signals for assert without cb because its combinational
    initial 
        begin
            //initialize
            errors = 0;
            WE = 0;
            WD = 0;
            address = 0;
            
            apply_reset();

            // basic write test to mem[0]
            write_mem(32'h0, data1);
            read_mem(32'h0);

            assert (RD === data1)
                else 
                    begin
                        $error("FAILED Write Test");
                        errors++;
                    end
                    
        
            // basic read test mem[1]
            write_mem(32'h0000_0004, data2);
            read_mem(32'h0000_0004);

            assert (RD === data2)
                else
                    begin
                        $error("FAILED Read Test");
                        errors++;

                    end 

            // multiple write to mem[2]
            write_mem(32'h0000_0008, data1);
            write_mem(32'h0000_0008, data2);
            write_mem(32'h0000_0008, data3);
            read_mem(32'h0000_0008);

            assert (RD === data3)
                else 
                    begin
                        $error("FAILED Multiple Write test");
                        errors++;
                    end

            // Write enable disabled overwrite test to mem[3] two parts
            write_mem(32'h0000_000C,data1);
            read_mem(32'h0000_000C);

            assert(RD === data1)
                else 
                    begin
                        $error("FAILED WE disable test [1:2]");
                        errors++;
                    end
            cb.WE <= 0;
            cb.WD <= data2;
            cb.address <= 32'h0000_000C;
            read_mem(32'h0000_000C);

            assert(RD === data1)
                else 
                    begin
                        $error("FAILED WE disable test [2:2]");
                        errors++;
                    end

            $display("Test finished with %d", errors);
            $finish;


        end

    endmodule