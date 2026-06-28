module control_unit (
    input logic [6:0] control_op,
    input logic [2:0] funct3,
    input logic funct7,
    input logic zero,


    output logic PC_sig,
    output logic [1:0] result_sig,
    output logic mem_write_sig,
    output logic [2:0] ALU_ctrl,
    output logic ALU_src_sig,
    output logic [1:0] exten_src_sig,
    output logic reg_write_sig,
    output logic jump_sig
);

    logic [1:0] ALU_op;
    logic branch;

    main_decoder main_decoder_instance (
        .main_op_in(control_op),
        .reg_write_sig(reg_write_sig),
        .exten_src_sig(exten_src_sig),
        .ALU_src_sig(ALU_src_sig),
        .mem_write_sig(mem_write_sig),
        .result_sig(result_sig),
        .branch_sig(branch),
        .ALU_op_out(ALU_op),
        .jump_sig(jump_sig)
    );

    alu_decoder alu_decoder_instance (
        .ALU_op_in(ALU_op),
        .op_5_in(control_op[5]),
        .funct3(funct3),
        .funct7(funct7),
        .ALU_ctrl(ALU_ctrl)
    );

    assign PC_sig = jump_sig || (branch && zero);


endmodule