module ARM (
    input clk, rst
  );

  wire branch_taken;
  wire [31:0] branchAddr, PC_IF, Inst_IF, PC_ID, Inst_ID, PC_EXE, Inst_EXE, PC_MEM, Inst_MEM, PC_FINAL, Inst_FINAL;

  IF_Stage if_stage (
             .clk(clk),
             .rst(rst),
             .freeze(1'b0),
             .branch_taken(1'b0),
             .branchAddr(0),
             .PC(PC_IF),
             .instruction(Inst_IF)
           );

  IF_Reg if_reg (
           .clk(clk),
           .rst(rst),
           .freeze(1'b0),
           .flush(1'b0),
           .PC_in(PC_IF),
           .instruction_in(Inst_IF),
           .PC(PC_ID),
           .instruction(Inst_ID)
         );

  ID_Stage id_stage (
             .clk(clk),
             .rst(rst),
             .PC_in(PC_ID),
             .PC(PC_ID)
           );

  ID_Reg id_reg (
           .clk(clk),
           .rst(rst),
           .freeze(1'b0),
           .flush(1'b0),
           .PC_in(PC_ID),
           .instruction_in(Inst_ID),
           .PC(PC_EXE),
           .instruction(Inst_EXE)
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
            .instruction_in(Inst_EXE),
            .PC(PC_MEM),
            .instruction(Inst_MEM)
          );

  MEM_Stage mem_stage (
              .clk(clk),
              .rst(rst),
              .PC_in(PC_MEM),
              .PC(PC_MEM)
            );

  MEM_Reg mem_reg (
            .clk(clk),
            .rst(rst),
            .freeze(1'b0),
            .flush(1'b0),
            .PC_in(PC_MEM),
            .instruction_in(Inst_MEM),
            .PC(PC_FINAL),
            .instruction(Inst_FINAL)
          );
  WB_Stage wb_stage (
             .clk(clk),
             .rst(rst),
             .PC_in(PC_FINAL),
             .PC(PC_FINAL)
           );


endmodule
