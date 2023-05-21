module ARM (
    input clk, rst, forward_en,
    inout[15:0] SRAM_DQ,
    output[17:0] SRAM_ADDR,
    output SRAM_WE_N,
    output SRAM_UB_N,
    output SRAM_LB_N,
    output SRAM_CE_N,
    output SRAM_OE_N
  );

  wire ready;

  wire branch_taken;
  wire [31:0] branchAddr, PC_IF, inst_IF;

  wire wb_en_ID, mem_r_en_ID, mem_w_en_ID, b_ID, s_ID, imm_ID, hazard;
  wire[3:0] exe_cmd_ID, dest_ID;
  wire[31:0] val_rn_ID, val_rm_ID, PC_ID, inst_ID;
  wire[11:0] shift_operand_ID;
  wire[23:0] signed_imm_24_ID;
  wire two_src, use_src1;

  wire wb_en_EXE, mem_r_en_EXE, mem_w_en_EXE, s_EXE, imm_EXE, WB_en_out;
  wire[3:0] exe_cmd_EXE, dest_EXE, src1_ID, src2_ID, src1_EXE, src2_EXE;
  wire[31:0] val_rn_EXE, val_rm_EXE, PC_EXE, ALU_res_EXE, val_rm_EXE_out;
  wire[11:0] shift_operand_EXE;
  wire[23:0] signed_imm_24_EXE;

  wire wb_en_MEM, mem_r_en_MEM, mem_w_en_MEM;
  wire[31:0] ALU_res_MEM, val_rm_MEM, mem_out_MEM;


  wire[3:0] Dest_MEM;

  wire[31:0] WB_value;
  wire[3:0] WB_Dest;

  wire[31:0] inst_EXE;
  wire[31:0] PC_MEM, inst_MEM;
  wire[31:0] PC_FINAL, inst_FINAL;

  wire WB_EN_WB, MEM_R_EN_WB;
  wire[31:0] ALU_res_WB, mem_out_WB;

  wire[3:0] status_EXE_in, status_EXE_out, status_ID;

  wire [1:0] sel_src1, sel_src2;

  StatusRegister status_register (
                   .clk(clk),
                   .rst(rst),
                   .status_in(status_EXE_out),
                   .S(s_EXE),
                   .status_out(status_ID)
                 );


  IF_Stage if_stage (
             .clk(clk),
             .rst(rst),
             .freeze(hazard | ~ready),
             .branch_taken(branch_taken),
             .branch_address(branchAddr),
             .PC(PC_IF),
             .instruction(inst_IF)
           );

  IF_Reg if_reg (
           .clk(clk),
           .rst(rst),
           .freeze(hazard | ~ready),
           .flush(branch_taken),
           .PC_in(PC_IF),
           .instruction_in(inst_IF),
           .PC_out(PC_ID),
           .instruction_out(inst_ID)
         );

  ID_Stage id_stage (
             .clk(clk),
             .rst(rst),
             .hazard(hazard),
             .WB_WB_EN(WB_EN_WB),
             .WB_Dest(WB_Dest),
             .WB_Value(WB_value),
             .Status_R(status_ID),
             .Ins(inst_ID),

             .WB_EN(wb_en_ID),
             .MEM_R_EN(mem_r_en_ID),
             .MEM_W_EN(mem_w_en_ID),
             .B(b_ID),
             .S(s_ID),
             .Two_src(two_src),
             .use_src1(use_src1),
             .imm(imm_ID),
             .EXE_CMD(exe_cmd_ID),
             .Dest(dest_ID),
             .shift_operand(shift_operand_ID),
             .signed_imm_24(signed_imm_24_ID),
             .Val_Rn(val_rn_ID),
             .Val_Rm(val_rm_ID),
             .src1(src1_ID),
             .src2(src2_ID)
           );

  ID_Reg id_reg (
           .clk(clk),
           .rst(rst),
           .freeze(~ready),
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
           .src1_in(src1_ID),
           .src2_in(src2_ID),

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
           .Status_R_out(status_EXE_in),
           .src1_out(src1_EXE),
           .src2_out(src2_EXE)
         );

  EXE_Stage exe_stage(
              .clk(clk),
              .rst(rst),
              .EXE_CMD(exe_cmd_EXE),
              .MEM_R_EN(mem_r_en_EXE),
              .MEM_W_EN(mem_w_en_EXE),
              .PC(PC_EXE),
              .Val_Rm_in(val_rm_EXE),
              .Val_Rn(val_rn_EXE),
              .ALU_res_f(ALU_res_MEM),
              .WB_val_f(WB_value),
              .imm(imm_EXE),
              .Shift_operand(shift_operand_EXE),
              .Signed_imm_24(signed_imm_24_EXE),
              .status_IN(status_EXE_in),
              .sel_src1(sel_src1),
              .sel_src2(sel_src2),

              .ALU_res(ALU_res_EXE),
              .Br_addr(branchAddr),
              .Val_Rm_out(val_rm_EXE_out),
              .status(status_EXE_out)
            );

  EXE_Reg exe_reg(
            .clk(clk),
            .rst(rst),
            .freeze(~ready),
            .WB_en_in(wb_en_EXE),
            .MEM_R_EN_in(mem_r_en_EXE),
            .MEM_W_EN_in(mem_w_en_EXE),
            .ALU_res_in(ALU_res_EXE),
            .ST_val_in(val_rm_EXE_out),
            .Dest_in(dest_EXE),

            .WB_en(wb_en_MEM),
            .MEM_W_EN(mem_w_en_MEM),
            .MEM_R_EN(mem_r_en_MEM),
            .ALU_res(ALU_res_MEM),
            .ST_val(val_rm_MEM),
            .Dest(Dest_MEM)

          );

  MEM_Stage mem_stage(
              .clk(clk),
              .rst(rst),
              .WB_en(wb_en_MEM),
              .MEM_W_EN(mem_w_en_MEM),
              .MEM_R_EN(mem_r_en_MEM),
              .ALU_res(ALU_res_MEM),
              .ST_val(val_rm_MEM),

              .mem_out(mem_out_MEM),
              .WB_en_out(WB_en_out),
              .ready(ready),
              .SRAM_DQ(SRAM_DQ),
              .SRAM_ADDR(SRAM_ADDR),
              .SRAM_WE_N(SRAM_WE_N),
              .SRAM_UB_N(SRAM_UB_N),
              .SRAM_LB_N(SRAM_LB_N),
              .SRAM_CE_N(SRAM_CE_N),
              .SRAM_OE_N(SRAM_OE_N)
            );

  MEM_Reg mem_reg(
            .clk(clk),
            .rst(rst),
            .freeze(~ready),
            .WB_EN_in(WB_en_out),
            .MEM_R_EN_in(mem_r_en_MEM),
            .ALU_res_in(ALU_res_MEM),
            .mem_in(mem_out_MEM),
            .Dest_in(Dest_MEM),

            .WB_EN_out(WB_EN_WB),
            .MEM_R_EN_out(MEM_R_EN_WB),
            .ALU_res_out(ALU_res_WB),
            .mem_out(mem_out_WB),
            .Dest_out(WB_Dest)
          );

  WB_Stage wb_stage(
             .clk(clk),
             .rst(rst),
             .MEM_R_EN(MEM_R_EN_WB),
             .ALU_res(ALU_res_WB),
             .mem_out(mem_out_WB),

             .WB_value(WB_value)
           );

  HazardDetector hazard_unit(
                   .forward_en(forward_en),
                   .src1(src1_ID),
                   .src2(src2_ID),
                   .Exe_Dest(dest_EXE),
                   .Exe_WB_EN(wb_en_EXE),
                   .Mem_Dest(Dest_MEM),
                   .Mem_WB_EN(wb_en_MEM),
                   .Two_src(two_src),
                   .use_src1(use_src1),
                   .Exe_Mem_R_EN(mem_r_en_EXE),
                   .hazard_Detected(hazard)
                 );

  ForwardingUnit FU (
                   .forward_en(forward_en),
                   .src1(src1_EXE),
                   .src2(src2_EXE),
                   .MEM_WB_en(wb_en_MEM),
                   .MEM_dest(Dest_MEM),
                   .WB_WB_en(WB_EN_WB),
                   .WB_dest(WB_Dest),

                   .sel_src1(sel_src1),
                   .sel_src2(sel_src2)
                 );


endmodule
