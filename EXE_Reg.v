module EXE_Reg (
    input clk, rst, WB_en_in, MEM_R_EN_in, MEM_W_EN_in, 
    input[31:0] ALU_res_in, ST_val_in,
    input[3:0] Dest_in, 

    output reg WB_en, MEM_R_EN, MEM_W_EN,
    output reg[31:0] ALU_res, ST_val, 
    output reg[3:0] Dest
);

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            ALU_res <= 32'b0; 
            ST_val <= 32'b0;
            Dest <= 4'b0;
            WB_en <= 1'b0; 
            MEM_R_EN <= 1'b0; 
            MEM_W_EN <= 1'b0;
        end else begin
            ALU_res <= ALU_res_in; 
            ST_val <= ST_val_in;
            Dest <= Dest_in;
            WB_en <= WB_en_in; 
            MEM_R_EN <= MEM_R_EN_in; 
            MEM_W_EN <= MEM_W_EN_in;            
        end
    end

endmodule