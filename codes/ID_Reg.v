module ID_Reg (
    input clk, rst, freeze, flush,
    input WB_EN_in, MEM_R_EN_in, MEM_W_EN_in, B_in, S_in, imm_in,
    input [3:0] EXE_CMD_in, Dest_in, Status_R_in,
    input [11:0] shift_operand_in,
    input [23:0] signed_imm_24_in,
    input [31:0] PC_in, Val_Rn_in, Val_Rm_in,
    input [3:0] src1_in, src2_in,

    output reg WB_EN_out, MEM_R_EN_out, MEM_W_EN_out, B_out, S_out, imm_out,
    output reg [3:0] EXE_CMD_out, Dest_out, Status_R_out,
    output reg [11:0] shift_operand_out,
    output reg [23:0] signed_imm_24_out,
    output reg [31:0] PC_out, Val_Rn_out, Val_Rm_out,
    output reg [3:0] src1_out, src2_out
  );

  always @(posedge clk, posedge rst)
  begin
    if (rst)
    begin
      PC_out <= 0;
      {WB_EN_out, MEM_R_EN_out, MEM_W_EN_out, B_out, S_out, EXE_CMD_out, Val_Rn_out, Val_Rm_out, imm_out, shift_operand_out, signed_imm_24_out, Dest_out, Status_R_out, src1_out, src2_out} <= 126'b0;
    end
    else if (freeze)
    begin
      PC_out <= PC_out;
      {WB_EN_out, MEM_R_EN_out, MEM_W_EN_out, B_out, S_out, EXE_CMD_out, Val_Rn_out, Val_Rm_out, imm_out, shift_operand_out, signed_imm_24_out, Dest_out, Status_R_out, src1_out, src1_out} <=
      {WB_EN_out, MEM_R_EN_out, MEM_W_EN_out, B_out, S_out, EXE_CMD_out, Val_Rn_out, Val_Rm_out, imm_out, shift_operand_out, signed_imm_24_out, Dest_out, Status_R_out, src1_out, src2_out};
    end
    else if (flush)
    begin
      PC_out <= 0;
      {WB_EN_out, MEM_R_EN_out, MEM_W_EN_out, B_out, S_out, EXE_CMD_out, Val_Rn_out, Val_Rm_out, imm_out, shift_operand_out, signed_imm_24_out, Dest_out, Status_R_out, src1_out, src2_out} <= 126'b0;
    end
    else
    begin
      PC_out <= PC_in;
      {WB_EN_out, MEM_R_EN_out, MEM_W_EN_out, B_out, S_out, EXE_CMD_out, Val_Rn_out, Val_Rm_out, imm_out, shift_operand_out, signed_imm_24_out, Dest_out, Status_R_out, src1_out, src2_out} <=
      {WB_EN_in, MEM_R_EN_in, MEM_W_EN_in, B_in, S_in, EXE_CMD_in, Val_Rn_in, Val_Rm_in, imm_in, shift_operand_in, signed_imm_24_in, Dest_in, Status_R_in, src1_in, src2_in};
    end
  end

endmodule
