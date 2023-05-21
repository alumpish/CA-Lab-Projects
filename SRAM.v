module SRAM (
    input clk,
    input rst,
    input SRAM_WE_N,
    input SRAM_UB_N,
    input SRAM_LB_N,
    input SRAM_CE_N,
    input SRAM_OE_N,
    input [17:0] SRAM_ADDR,
    inout [15:0] SRAM_DQ
  );

  reg [15:0] memory[0:511];
  assign #5 SRAM_DQ = SRAM_WE_N ? memory[SRAM_ADDR] : 16'bz;
  always@(posedge clk)
  begin
    if(~SRAM_WE_N)
    begin
      memory[SRAM_ADDR] = SRAM_DQ;
    end
  end
endmodule
