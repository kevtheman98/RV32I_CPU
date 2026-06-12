module top (
    input clk, reset
);

// CONSTANTS
const int PC_increm = 4;

// PC & Adder
logic [31:0] PC_out;
logic [31:0] PC_in;
logic [31:0] PC_plus4;
logic [31:0] PC_target;


// INSTURCTION MEMORY 
logic [31:0] instruct_out;

// REGISTER FILE
logic [31:0] write_data;
logic reg_write;
logic [31:0] RD2_out;

assign RD2_out = write_data;

// SIGN EXTENSION 
logic [31:0] exten_out;
logic exten_sel;

// ALU 
logic [31:0] ALU_result;
logic [2:0] ALU_ctrl;
logic [31:0] ALU_srcA;
logic [31:0] ALU_srcB;
logic zeroFlag;

// Data memory
logic [31:0] read_data;
logic mem_write;
logic [31:0] result;



prog_count prog_count_instance (
    .clk(clk),
    .reset(reset),
    .addin(PC_in),
    .addout(PC_out)
);

instr_mem instr_mem_instance (
    .address(PC_out),
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
    .sign_ex_select(exten_sel),
    .sign_ex_addout(exten_out)
);

alu alu_instance (
    .a(ALU_srcA),
    .b(ALU_srcB),
    .select(ALU_ctrl),
    .result(ALU_result),
    .zeroFlag(zeroFlag)
);

data_mem data_mem_instance (
    .clk(clk),
    .WE(mem_write),
    .address(ALU_result),
    .WD(write_data),
    .RD(read_data)
);

adder PC_adder (
    .current_address(PC_out),
    .increment_addr(PC_increm),
    .next_address(PC_plus4)
);

adder PC_target_adder (
    .current_address(PC_out),
    .increment_addr(exten_out),
    .next_address(PC_target)
);

// Muxes & Control Signals

logic ALU_src;
logic result_src; 
logic PC_src;

mux ALU_mux (
    .a(RD2_out),
    .b(exten_out),
    .sel(ALU_src),
    .y(ALU_srcB)
);

mux result_mux (
    .a(ALU_result),
    .b(read_data),
    .sel(result_src),
    .y(result)
);

mux PC_mux (
    .a(PC_plus4),
    .b(PC_target),
    .sel(PC_src),
    .y(PC_in)
);

// Control Unit

control_unit control_unit_instance (
    .control_op(instruct_out[0:6]),
    .funct3(instruct_out[14:12]),
    .funct7(instruct_out[30]), // only funct7[5]
    .zero(zeroFlag), 
    .PC_sig(PC_src),
    .result_sig(result_src),
    .mem_write_sig(mem_write),
    .ALU_ctrl(ALU_ctrl),
    .ALU_src_sig(ALU_src),
    .exten_src_sig(exten_sel),
    .reg_write_sig(reg_write)
);




endmodule
