module ID_Reg (
    input clk, rst, freeze, flush,
    input [31:0] PC_in, instruction_in,
    output reg [31:0] PC_out, instruction_out
  );

  always @(posedge clk, posedge rst)
  begin
    if (rst)
    begin
      PC_out <= 0;
      instruction_out <= 0;
    end
    else if (flush)
    begin
      PC_out <= 0;
      instruction_out <= 0;
    end
    else if (~freeze)
    begin
      PC_out <= PC_in;
      instruction_out <= instruction_in;
    end
  end

endmodule
