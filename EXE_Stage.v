module EXE_Stage (
    input clk, rst,
    input[3:0] EXE_CMD,
    input MEM_R_EN, MEM_W_EN,
    input[31:0] PC,
    input[31:0] Val_Rm, Val_Rn,
    input imm,
    input[11:0] Shift_operand,
    input[23:0] Signed_imm_24,
    input[3:0] status_IN,

    output[31:0] ALU_res, Br_addr,
    output[3:0] status
);

    wire[31:0] Signed_imm_32 = { {6{Signed_imm_24[23]}}, Signed_imm_24, 2'b00};
    wire mem = MEM_R_EN || MEM_W_EN;
    wire[31:0] Val2;

    VALUE2_Generator value2_generator(
        .Shift_operand(Shift_operand),
        .RM_value(Val_Rm),
        .imm(imm),
        .mem(mem),
        .Val2(Val2)
    );

    ALU alu(
        .input1(Val_Rn),
        .input2(Val2),
        .carry_in(status_IN[1]),
        .command(EXE_CMD),
        .out(ALU_res),
        .carry_out(status[1]),
        .V(status[0]),
        .Z(status[2]),
        .N(status[3])
    );

    Adder adder(
        .a(PC),
        .b(Signed_imm_32),
        .res(Br_addr)
    );

endmodule