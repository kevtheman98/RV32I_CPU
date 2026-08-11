module top_tb;
    logic clk, reset;
    string mem_file;


    top top_instance (
        .clk(clk),
        .reset(reset)

    );

    initial clk = 0;
    always #5 clk = ~clk;

    function automatic string get_file_name(string path);
        int len = path.len();
        
        for(int i = len-1; i >= 0; i--) begin
            if(path[i] == "/") 
                begin
                    return(path.substr(i+1, len-5)); // Extract the file name without extension
                    
                end
        end


        
        return path; // return the original path if no '/' found
    endfunction


    initial 
        begin

            if(!$value$plusargs("MEMFILE=%s", mem_file))
                $display("No MEMFILE arg");

            // GTK waveform generation
            $dumpfile($sformatf("%s.vcd", get_file_name(mem_file)));
            $display(get_file_name(mem_file));
            $dumpvars(0, top_tb);
            
            $display("Using memory file: %s", mem_file);
            $readmemh(mem_file, top_instance.instr_mem_instance.mem);

            reset = 1;
            @(posedge clk);
            @(posedge clk);
            reset = 0;
            repeat(20) @(posedge clk);

            $display("Test finished, checking results...");
            $display("Data memory location 511: %h", top_instance.data_mem_instance.d_mem[511]);
            
            // test status mem location 1 for pass, 0 for fail

            if(top_instance.data_mem_instance.d_mem[511] === 32'h1)
                    $display("TEST PASSED");
            else
                $display("TEST FAILED");

            $finish;
            
        
        end

endmodule
