module MEM_Stage (
    input clk, rst, MEM_W_EN, MEM_R_EN,
    input[31:0] ALU_res, ST_val, 
    output[31:0] mem_out
);

    
    always @(posedge clk, posedge rst) begin
        
    end

endmodule