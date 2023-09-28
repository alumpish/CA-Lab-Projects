module IF_Stage (
    input clk, rst, freeze, branch_taken,
    input [31:0] branch_address,
    output [31:0] PC, instruction
  );

  wire [31:0] PC_reg_in;
  reg  [31:0] PC_reg_out;

  Mux mux (
        PC,
        branch_address,
        branch_taken,
        PC_reg_in
      );

  Adder pcAdder (
          PC_reg_out,
          4,
          PC
        );

  Ins_Mem instruction_mem (
            PC_reg_out,
            instruction
          );

  always @(posedge clk, posedge rst)
  begin
    if (rst)
      PC_reg_out <= 0;
    else if (~freeze)
      PC_reg_out <= PC_reg_in;
  end

endmodule
