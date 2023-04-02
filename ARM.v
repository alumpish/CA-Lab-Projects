module ARM (
    input clk, rst
  );

  wire branch_taken;
  wire [31:0] branchAddr, PC_IF, inst_IF;

  wire wb_en_ID, mem_r_en_ID, mem_w_en_ID, b_ID, s_ID, imm_ID, hazard;
  wire[3:0] exe_cmd_ID, dest_ID;
  wire[31:0] val_rn_ID, val_rm_ID, PC_ID, inst_ID;
  wire[11:0] shift_operand_ID;
  wire[23:0] signed_imm_24_ID;
  wire two_src;

  wire wb_en_EXE, mem_r_en_EXE, mem_w_en_EXE, s_EXE, imm_EXE;
  wire[3:0] exe_cmd_EXE, dest_EXE;
  wire[31:0] val_rn_EXE, val_rm_EXE, PC_EXE;
  wire[11:0] shift_operand_EXE;
  wire[23:0] signed_imm_24_EXE;

  wire[3:0] Dest_MEM;

  wire[31:0] WB_value;
  wire[3:0] WB_Dest;

  wire[31:0] inst_EXE;
  wire[31:0] PC_MEM, inst_MEM;
  wire[31:0] PC_FINAL, inst_FINAL;

  wire WB_WB_EN;

  wire[3:0] status_EXE_in, status_EXE_out, status_ID;

  StatusRegister status_register (
                   .clk(clk),
                   .rst(rst),
                   .status_in(4'b0),
                   .S(s_EXE),
                   .status_out(status_ID)
                 );


  IF_Stage if_stage (
             .clk(clk),
             .rst(rst),
             .freeze(1'b0),
             .branch_taken(1'b0),
             .branch_address(32'b0),
             .PC(PC_IF),
             .instruction(inst_IF)
           );

  IF_Reg if_reg (
           .clk(clk),
           .rst(rst),
           .freeze(1'b0),
           .flush(branch_taken),
           .PC_in(PC_IF),
           .instruction_in(inst_IF),
           .PC_out(PC_ID),
           .instruction_out(inst_ID)
         );

  ID_Stage id_stage (
             .clk(clk),
             .rst(rst),
             .hazard(1'b0),
             .WB_WB_EN(1'b0),
             .WB_Dest(4'b0),
             .WB_Value(32'b0),
             .Status_R(status_ID),
             .Ins(inst_ID),

             .WB_EN(wb_en_ID),
             .MEM_R_EN(mem_r_en_ID),
             .MEM_W_EN(mem_w_en_ID),
             .B(b_ID),
             .S(s_ID),
             .Two_src(two_src),
             .imm(imm_ID),
             .EXE_CMD(exe_cmd_ID),
             .Dest(dest_ID),
             .shift_operand(shift_operand_ID),
             .signed_imm_24(signed_imm_24_ID),
             .Val_Rn(val_rn_ID),
             .Val_Rm(val_rm_ID)
           );

  ID_Reg id_reg (
           .clk(clk),
           .rst(rst),
           .freeze(1'b0),
           .flush(branch_taken),
           .WB_EN_in(wb_en_ID),
           .MEM_R_EN_in(mem_r_en_ID),
           .MEM_W_EN_in(mem_w_en_ID),
           .B_in(b_ID),
           .S_in(s_ID),
           .EXE_CMD_in(exe_cmd_ID),
           .PC_in(PC_ID),
           .Val_Rn_in(val_rn_ID),
           .Val_Rm_in(val_rm_ID),
           .imm_in(imm_ID),
           .shift_operand_in(shift_operand_ID),
           .signed_imm_24_in(signed_imm_24_ID),
           .Dest_in(dest_ID),
           .Status_R_in(status_ID),

           .WB_EN_out(wb_en_EXE),
           .MEM_R_EN_out(mem_r_en_EXE),
           .MEM_W_EN_out(mem_w_en_EXE),
           .B_out(branch_taken),
           .S_out(s_EXE),
           .EXE_CMD_out(exe_cmd_EXE),
           .PC_out(PC_EXE),
           .Val_Rn_out(val_rn_EXE),
           .Val_Rm_out(val_rm_EXE),
           .imm_out(imm_EXE),
           .shift_operand_out(shift_operand_EXE),
           .signed_imm_24_out(signed_imm_24_EXE),
           .Dest_out(dest_EXE),
           .Status_R_out(status_EXE_in)
         );

  EXE_Stage exe_stage (
              .clk(clk),
              .rst(rst),
              .PC_in(PC_EXE),
              .PC(PC_EXE)
            );

  EXE_Reg exe_reg (
            .clk(clk),
            .rst(rst),
            .freeze(1'b0),
            .flush(1'b0),
            .PC_in(PC_EXE),
            .instruction_in(inst_EXE),
            .PC_out(PC_MEM),
            .instruction_out(inst_MEM)
          );

  MEM_Stage mem_stage (
              .clk(clk),
              .rst(rst),
              .PC_in(PC_MEM),
              .PC_out(PC_MEM)
            );

  MEM_Reg mem_reg (
            .clk(clk),
            .rst(rst),
            .freeze(1'b0),
            .flush(1'b0),
            .PC_in(PC_MEM),
            .instruction_in(inst_MEM),
            .PC_out(PC_FINAL),
            .instruction_out(inst_FINAL)
          );
  WB_Stage wb_stage (
             .clk(clk),
             .rst(rst),
             .PC_in(PC_FINAL),
             .PC_out(PC_FINAL)
           );


endmodule
