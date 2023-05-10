module TB_DE2 ();

  reg clk, rst, forward_en;

  ARM arm (
        .clock(clk),
        .rst(rst),
        .forward_en(forward_en)
      );

  initial
  begin
    clk = 1;
    forward_en = 1;
    repeat (1200)
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
