module top (
    input clk, reset
);

// PC & Adder
logic [31:0] pc_out;
logic [31:0] pc_adder_out;


// INSTURCTION MEMORY 
logic [31:0] instruct_out;

// REGISTER FILE
logic [31:0] RD1_out;

// EXTENSION MODULE
logic [31:0] exten_out;

// ALU 
logic [31:0] ALU_result;

// Data memory
logic [31:0] read_data;

prog_count prog_count_instance (
    .clk(clk),
    .reset(reset),
    .addin(pc_adder_out),
    .addout(pc_out)
);

instr_mem instr_mem_instance (
    .address(pc_out),
    .instruction(instruct_out)
);

reg_file reg_file_instance (
    .clk(clk),
    .reset(reset),
    .WE3(WE3),
    .A1(instruct_out [19:15]),
    .A2(A2),
    .A3(instruct_out [11:7]),
    .WD3(read_data),
    .RD1(RD1_out),
    .RD2(RD2)
);

sign_extn sign_extn_instance (
    // convert 12-bit offset to 32 bit
    .sign_addin(instruct_out [31:20]),
    .sign_addout(exten_out)
);

alu alu_instance (
    .a(RD1_out),
    .b(exten_out),
    .select(select),
    .result(ALU_result)
);

data_mem data_mem_instance (
    .clk(clk),
    .WE(WE),
    .address(ALU_result),
    .WD(WD),
    .RD(read_data)
);

pc_adder pc_adder_instance (
    .current_address(pc_out),
    .next_address(pc_adder_out)
);

endmodule
