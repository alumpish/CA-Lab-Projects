module TB_DE2 ();

  reg clk, rst;

  ARM arm (
        .clk(clk),
        .rst(rst)
      );

  initial
  begin
    clk = 1;
    repeat (200)
    begin
      #50;
      clk = ~clk;
    end
  end

  initial
  begin
    rst = 0;
    #20 rst = 1;
    #10 rst = 0;
  end

endmodule
