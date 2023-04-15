module HazardDetector (input [3:0] src1,
                         input [3:0] src2,
                         input [3:0] Exe_Dest,
                         input Exe_WB_EN,
                         input [3:0] Mem_Dest,
                         input Mem_WB_EN,
                         input Two_src,
                         input use_src1,
                         output hazard_Detected
                        );

  assign hazard_Detected = (Exe_WB_EN && (use_src1 && src1 == Exe_Dest)) ||
         (Exe_WB_EN && (Two_src  && src2 == Exe_Dest)) ||
         (Mem_WB_EN && (use_src1 && src1 == Mem_Dest)) ||
         (Mem_WB_EN && (Two_src  && src2 == Mem_Dest));

endmodule
