module Data_Mem (
    input clk, rst, MEM_W_EN, MEM_R_EN,
    input[31:0] address, data,
    output[31:0] out
  );

  reg[31:0] memory[0:63];

  wire[7:0] i = (address - 1024) >> 2;

  assign out = MEM_R_EN ? memory[i] : 32'b0;

  always @(posedge clk)
  begin
    if (MEM_W_EN)
      memory[i] <= data;
  end

endmodule
