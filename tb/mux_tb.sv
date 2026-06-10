module mux_tb;
    logic a, b;
    logic sel;
    logic y;

    mux mux_instance (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );


    initial 
        begin
            a = 32'h0000_1234;
            b = 32'h0000_ABCD;

            sel = 0;
            #1;
            assert(y === a)
            else
                begin
                    $display("Failed sel 0");
                end


            sel = 1;
            #1 
            assert(y === b)
            else
                begin
                    $display("Failed sel 1");
                end


            $display("Test finished");
            $finish;
        
        end
    






endmodule