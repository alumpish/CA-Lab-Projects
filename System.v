module System (
    input clock, rst, forward_en
  );

  wire [15:0] SRAM_DQ;
  wire [17:0] SRAM_ADDR;
  wire SRAM_WE_N;

  FreqDivider FD(
                .clk(clock), .rst(rst),
                .en(1'b1), .co(clk)
              );

  ARM arm (
        .clk(clk),
        .rst(rst),
        .forward_en(forward_en),
        .SRAM_DQ(SRAM_DQ),
        .SRAM_ADDR(SRAM_ADDR),
        .SRAM_WE_N(SRAM_WE_N),
        .SRAM_UB_N(SRAM_UB_N),
        .SRAM_LB_N(SRAM_LB_N),
        .SRAM_CE_N(SRAM_CE_N),
        .SRAM_OE_N(SRAM_OE_N)
      );

  SRAM sram (
         .clk(clk),
         .rst(rst),
         .SRAM_ADDR(SRAM_ADDR),
         .SRAM_DQ(SRAM_DQ),
         .SRAM_WE_N(SRAM_WE_N),
         .SRAM_UB_N(SRAM_UB_N),
         .SRAM_LB_N(SRAM_LB_N),
         .SRAM_CE_N(SRAM_CE_N),
         .SRAM_OE_N(SRAM_OE_N)
       );
endmodule
