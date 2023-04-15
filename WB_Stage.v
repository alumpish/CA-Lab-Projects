module WB_Stage (
    input clk, rst, MEM_R_EN,
    input[31:0] ALU_res, mem_out,

    output[31:0] WB_value
);

    Mux mux(
        .a(ALU_res),
        .b(mem_out),
        .sel(MEM_R_EN),
        .c(WB_value)
    );

endmodule