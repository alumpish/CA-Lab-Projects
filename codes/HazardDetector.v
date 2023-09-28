module HazardDetector (input forward_en,
                         input [3:0] src1,
                         input [3:0] src2,
                         input [3:0] Exe_Dest,
                         input Exe_WB_EN,
                         input [3:0] Mem_Dest,
                         input Mem_WB_EN,
                         input Two_src,
                         input use_src1,
                         input Exe_Mem_R_EN,
                         output hazard_Detected
                        );

  assign hazard_Detected = !forward_en && ((Exe_WB_EN && (use_src1 && src1 == Exe_Dest)) ||
         (Exe_WB_EN && (Two_src  && src2 == Exe_Dest)) ||
         (Mem_WB_EN && (use_src1 && src1 == Mem_Dest)) ||
         (Mem_WB_EN && (Two_src  && src2 == Mem_Dest))) || Exe_Mem_R_EN && (src1 == Exe_Dest || src2 == Exe_Dest);

endmodule
