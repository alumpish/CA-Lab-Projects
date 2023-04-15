module ID_Stage (
    input clk, rst,
    input hazard, WB_WB_EN,
    input [3:0] WB_Dest, Status_R,
    input [31:0] Ins, WB_Value,

    output WB_EN, MEM_R_EN, MEM_W_EN, B, S, Two_src, imm, use_src1,
    output [3:0] EXE_CMD, Dest, src1, src2,
    output [11:0] shift_operand,
    output [23:0] signed_imm_24,
    output [31:0] Val_Rn, Val_Rm
  );

  wire stop, WB_EN_CU, MEM_R_EN_CU, MEM_W_EN_CU, B_CU, S_CU;
  wire [3:0] EXE_CMD_CU;

  wire [3:0] cond = Ins[31:28];
  wire [1:0] mode = Ins[27:26];
  wire I = Ins[25];
  wire [3:0] opcode = Ins[24:21];
  wire S_in = Ins[20];
  wire [3:0] Rn = Ins[19:16];
  wire [3:0] Rd = Ins[15:12];
  wire [3:0] Rm = MEM_W_EN ? Rd : Ins[3:0];
  assign shift_operand = Ins[11:0];
  assign signed_imm_24 = Ins[23:0];

  ConditionCheck CC (
                   .cond(cond),
                   .Status_R(Status_R),

                   .Is_Valid(Is_Valid)
                 );

  RegisterFile RF (
                 .clk(clk),
                 .rst(rst),
                 .Rs1(Rn),
                 .Rs2(Rm),
                 .WB_WB_EN(WB_WB_EN),
                 .WB_Dest(WB_Dest),
                 .WB_Value(WB_Value),

                 .Val_Rn(Val_Rn),
                 .Val_Rm(Val_Rm)
               );

  ControlUnit CU (
                .opcode(opcode),
                .mode(mode),
                .S_in(S_in),

                .EXE_CMD(EXE_CMD_CU),
                .WB_EN(WB_EN_CU),
                .MEM_R_EN(MEM_R_EN_CU),
                .MEM_W_EN(MEM_W_EN_CU),
                .B(B_CU),
                .S_out(S_CU)
              );

  assign imm = I;
  assign Dest = Rd;
  assign stop = hazard || !Is_Valid;
  assign {EXE_CMD, WB_EN, MEM_R_EN, MEM_W_EN, B, S} = stop ? 9'b0 : {EXE_CMD_CU, WB_EN_CU, MEM_R_EN_CU, MEM_W_EN_CU, B_CU, S_CU};

  // assign Two_src = MEM_W_EN || (!I && mode == 2'b00);
  assign Two_src = MEM_W_EN || !I;
  assign use_src1 = opcode != 4'b1101 && opcode != 4'b1111 && mode != 2'b10;
  assign src1 = Rn;
  assign src2 = Rm;


endmodule
