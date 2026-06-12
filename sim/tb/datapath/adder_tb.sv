module adder_tb;
    logic [31:0] current_address;
    logic [31:0] increment_addr;
    logic [31:0] next_address;
    int errors;


    // FIX-ME made more modular because multiple adders were needed
    adder adder_instance (
        .current_address(current_address),
        .increment_addr(increment_addr),
        .next_address(next_address)
    );

    task automatic check_add(
        input logic [31:0] test_address
        );
        
        current_address = test_address;
        #1;
        assert(next_address === test_address + 4)
        else
            begin
                $display("PC adder failed Input: %h, Output %h", test_address, next_address);
                errors++;
            end
    endtask

    initial 
        begin
            errors = 0;

            for (int i = 0; i < 100; i++) 
                begin
                    check_add($urandom);
                end

            $display("Test finsihed with %d errors", errors);
            $finish;
        end
endmodule