module RegisterFile (
    input clk, rst,
    input [3:0] WB_Dest, Rs1, Rs2,
    input [31:0] WB_Value,
    input WB_WB_EN,
    output [31:0] Val_Rn, Val_Rm
  );

  reg [31:0] RegFile [0:14];

  integer i;

  initial
  begin
    for (i = 0; i < 15 ; i = i + 1 )
      RegFile[i] = i;
  end

  assign Val_Rn = RegFile[Rs1];
  assign Val_Rm = RegFile[Rs2];

  always @(negedge clk, posedge rst)
  begin
    if (rst)
      for (i = 0; i < 15 ; i = i + 1 )
        RegFile[i] <= i;
    else if (WB_WB_EN)
      RegFile[WB_Dest] <= WB_Value;
  end

endmodule
