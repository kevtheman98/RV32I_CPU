module top (
    input clk, reset,
    output [31:0] pc_out, instruct_out, RD1_out, RD2_out 

    
);

// CONSTANTS
const int PC_increm = 4;

// PC & Adder
logic [31:0] PC_curr;
logic [31:0] PC_next;
logic [31:0] PC_plus4;
logic [31:0] PC_target;


// INSTURCTION MEMORY 
logic [31:0] instruction;

// REGISTER FILE
logic [31:0] write_data;
logic reg_write;
logic [31:0] RD1;
logic [31:0] RD2;

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

// intersystem connections
assign ALU_srcA = RD1;
assign write_data = RD2;

// Observation Signals for tb
assign pc_out = PC_curr;
assign instruct_out = instruction;
assign RD1_out = RD1;
assign RD2_out = RD2;





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
    .reset(reset),
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
    .sign_ex_addin(instruction [31:7]),
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
    .current_address(PC_curr),
    .increment_addr(PC_increm),
    .next_address(PC_plus4)
);

adder PC_target_adder (
    .current_address(PC_curr),
    .increment_addr(exten_out),
    .next_address(PC_target)
);

// Muxes & Control Signals

logic ALU_src;
logic result_src; 
logic PC_src;

mux ALU_mux (
    .a(RD2),
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
    .y(PC_next)
);

// Control Unit

control_unit control_unit_instance (
    .control_op(instruction[6:0]),
    .funct3(instruction[14:12]),
    .funct7(instruction[30]), // only funct7[5]
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
