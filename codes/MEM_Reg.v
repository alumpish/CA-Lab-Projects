module MEM_Reg (
    input clk, rst, freeze,
    input WB_EN_in, MEM_R_EN_in,
    input[31:0] ALU_res_in, mem_in,
    input[3:0] Dest_in,

    output reg WB_EN_out, MEM_R_EN_out,
    output reg[31:0] ALU_res_out, mem_out,
    output reg[3:0] Dest_out

  );

  always @(posedge clk, posedge rst)
  begin
    if (rst)
    begin
      Dest_out <= 0;
      WB_EN_out <= 0;
      MEM_R_EN_out <= 0;
      ALU_res_out <= 0;
      mem_out <= 0;
    end
    else if (freeze)
    begin
      Dest_out <= Dest_out;
      WB_EN_out <= WB_EN_out;
      MEM_R_EN_out <= MEM_R_EN_out;
      ALU_res_out <= ALU_res_out;
      mem_out <= mem_out;
    end
    else
    begin
      WB_EN_out <= WB_EN_in;
      MEM_R_EN_out <= MEM_R_EN_in;
      Dest_out <= Dest_in;
      ALU_res_out <= ALU_res_in;
      mem_out <= mem_in;
    end
  end

endmodule
