module MEM_Reg (
    input clk, rst, WB_EN_MEM, MEM_R_EN_MEM,
    input[31:0] ALU_res_MEM, mem_out_MEM,
    input[3:0] Dest_MEM, 

    output reg WB_EN, MEM_R_EN, 
    output reg[31:0] ALU_res, mem_out,
    output reg[3:0] Dest

);

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            Dest <= 0;
        end else begin
            WB_EN <= WB_EN_MEM;
            MEM_R_EN <= MEM_R_EN_MEM;
            Dest <= Dest_MEM;
            ALU_res <= ALU_res_MEM;
        end
    end

endmodule