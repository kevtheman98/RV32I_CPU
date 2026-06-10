module top (
    input clk, reset
);

// PC & Adder
logic [31:0] pc_out;
logic [31:0] pc_adder_out;


// INSTURCTION MEMORY 
logic [31:0] instruct_out;

// REGISTER FILE
logic [31:0] write_data;
logic reg_write;
logic [31:0] RD2_out;

assign RD2_out = write_data;

// SIGN EXTENSION 
logic [31:0] exten_out;
logic sign_sel;

// ALU 
logic [31:0] ALU_result;
logic [2:0] ALU_ctrl;
logic [31:0] ALU_srcA;
logic [31:0] ALU_srcB;

// Data memory
logic [31:0] read_data;
logic mem_write;
logic [31:0] result;



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
    .WE3(reg_write),
    // base reg for I & S type
    .A1(instruct_out [19:15]),
    // source reg for sw
    .A2(instruct_out [24:20]),
    // dest reg for lw
    .A3(instruct_out [11:7]),
    .WD3(result),
    .RD1(ALU_srcA),
    .RD2(RD2_out)
);

sign_extn sign_extn_instance (
    .sign_ex_addin(instruct_out [31:7]),
    .sign_ex_select(sign_sel),
    .sign_ex_addout(exten_out)
);

alu alu_instance (
    .a(ALU_srcA),
    .b(ALU_srcB),
    .select(ALU_ctrl),
    .result(ALU_result)
);

data_mem data_mem_instance (
    .clk(clk),
    .WE(mem_write),
    .address(ALU_result),
    .WD(write_data),
    .RD(read_data)
);

pc_adder pc_adder_instance (
    .current_address(pc_out),
    .next_address(pc_adder_out)
);

// Muxes & Control Signals

logic ALU_src_sig;
logic result_src; 

mux ALU_mux (
    .a(RD2_out),
    .b(exten_out),
    .sel(ALU_src_sig),
    .y(ALU_srcB)
);

mux result_mux (
    .a(ALU_result),
    .b(read_data),
    .sel(result_src),
    .y(result)
);


endmodule
