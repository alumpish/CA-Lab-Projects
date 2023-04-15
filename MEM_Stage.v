module MEM_Stage (
    input clk, rst, MEM_W_EN, MEM_R_EN,
    input[31:0] ALU_res, ST_val, 
    output[31:0] mem_out
);

    DataMemory data_mem(
        .clk(clk),
        .rst(rst),
        .MEM_W_EN(MEM_W_EN),
        .MEM_R_EN(MEM_R_EN),
        .address(ALU_res),
        .data(ST_val),
        .out(mem_out)
    );    


endmodule