module top (
    input logic clk, reset
);

// CONSTANTS
const int PC_increm = 4;

// PC & ADDER
logic [31:0] PC_curr;
logic [31:0] PC_next;
logic [31:0] PC_plus4;
logic [31:0] PC_target;
logic [31:0] PC_target_src;
logic [31:0] PC_target_sel;


// INSTURCTION MEMORY 
logic [31:0] instruction;

// REGISTER FILE
logic [31:0] write_data;
logic reg_write;
logic [31:0] RD1;
logic [31:0] RD2;

// SIGN IMMEDIATE EXTENSION 
logic [31:0] imm_exten;
logic [1:0] imm_exten_sel;

// ALU 
logic [31:0] ALU_result;
logic [2:0] ALU_ctrl;
logic [31:0] ALU_srcA;
logic [31:0] ALU_srcB;
logic zeroFlag;

// DATA MEMORY
logic [31:0] read_data;
logic mem_write;
logic [31:0] result;

// intersystem connections
assign ALU_srcA = RD1;
assign write_data = RD2;


prog_count prog_count_instance (
    .clk(clk),
    .reset(reset),
    .addin(PC_next),
    .addout(PC_curr)
);

instr_mem instr_mem_instance (
    .address(PC_curr),
    .instruction(instruction)
);

reg_file reg_file_instance (
    .clk(clk),
    .WE3(reg_write),
    // base reg for I & S type
    .A1(instruction [19:15]),
    // source reg for sw
    .A2(instruction [24:20]),
    // dest reg for lw
    .A3(instruction [11:7]),
    .WD3(result),
    .RD1(RD1),
    .RD2(RD2)
);

sign_extn sign_extn_instance (
    .sign_ex_in(instruction [31:0]),
    .sign_ex_select(imm_exten_sel),
    .sign_ex_out(imm_exten)
);

alu alu_instance (
    .a(ALU_srcA),
    .b(ALU_srcB),
    .select(ALU_ctrl),
    .ALUResult(ALU_result),
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
    .current_address(PC_curr),
    .increm(PC_increm),
    .next_address(PC_plus4)
);

adder PC_target_adder (
    .current_address(PC_target_src),
    .increm(imm_exten),
    .next_address(PC_target)
);

// Muxes & Control Signals

logic ALU_src;
logic [1:0] result_src; 
logic [31:0] inter_mux;
logic PC_src;
logic jump;

mux ALU_mux (
    .a(RD2),
    .b(imm_exten),
    .sel(ALU_src),
    .y(ALU_srcB)
);

// use 2 2:1 mux to make 3:1 mux for result_mux
mux result_mux_a (
    .a(ALU_result),
    .b(read_data),
    .sel(result_src[0]),
    .y(inter_mux)
);

mux result_mux_b (
    .a(inter_mux),
    .b(PC_plus4), // saves address for j-type
    .sel(result_src[1]),
    .y(result)
);

mux PC_mux (
    .a(PC_plus4),
    .b(PC_target),
    .sel(PC_src),
    .y(PC_next)
);

mux PC_target_mux (
    .a(RD1),
    .b(PC_curr),
    .sel(PC_target_sel),
    .y(PC_target_src)

);

// Control Unit

control_unit control_unit_instance (
    .control_op(instruction[6:0]),
    .funct3(instruction[14:12]),
    .funct7(instruction[30]), // only funct7[5]
    .zero(zeroFlag), 
    .PC_src_sig(PC_src),
    .result_sig(result_src),
    .mem_write_sig(mem_write),
    .ALU_ctrl(ALU_ctrl),
    .ALU_src_sig(ALU_src),
    .imm_exten_src_sig(imm_exten_sel),
    .reg_write_sig(reg_write),
    .jump_sig(jump),
    .PC_target_src_sig(PC_target_sel)
);




endmodule
