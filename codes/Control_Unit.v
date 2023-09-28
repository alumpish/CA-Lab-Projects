module ControlUnit (
    input [3:0] opcode,
    input [1:0] mode,
    input S_in,
    output reg [3:0] EXE_CMD,
    output reg WB_EN, MEM_R_EN, MEM_W_EN, B, S_out
  );

`define MOV 4'b1101
`define MVN 4'b1111
`define ADD 4'b0100
`define ADC 4'b0101
`define SUB 4'b0010
`define SBC 4'b0110
`define AND 4'b0000
`define ORR 4'b1100
`define EOR 4'b0001
`define CMP 4'b1010
`define TST 4'b1000
`define LDR 4'b0100
`define STR 4'b0100

  always @(mode, opcode, S_in)
  begin
    {EXE_CMD, WB_EN, MEM_R_EN, MEM_W_EN, B, S_out} = 9'b0;

    case(mode)
      2'b00:
      begin
        S_out = S_in;
        case(opcode)
          `MOV:
          begin
            EXE_CMD = 4'b0001;
            WB_EN = 1'b1;
          end

          `MVN:
          begin
            EXE_CMD = 4'b1001;
            WB_EN = 1'b1;
          end

          `ADD:
          begin
            EXE_CMD = 4'b0010;
            WB_EN = 1'b1;
          end

          `ADC:
          begin
            EXE_CMD = 4'b0011;
            WB_EN = 1'b1;
          end

          `SUB:
          begin
            EXE_CMD = 4'b0100;
            WB_EN = 1'b1;
          end

          `SBC:
          begin
            EXE_CMD = 4'b0101;
            WB_EN = 1'b1;
          end

          `AND:
          begin
            EXE_CMD = 4'b0110;
            WB_EN = 1'b1;
          end

          `ORR:
          begin
            EXE_CMD = 4'b0111;
            WB_EN = 1'b1;
          end

          `EOR:
          begin
            EXE_CMD = 4'b1000;
            WB_EN = 1'b1;
          end

          `CMP:
          begin
            EXE_CMD = 4'b0100;
          end

          `TST:
          begin
            EXE_CMD = 4'b0110;
          end

          default:
            EXE_CMD = 4'b0000;
        endcase
      end


      2'b01:
      begin
        EXE_CMD = 4'b0010;
        MEM_R_EN = S_in;
        MEM_W_EN = !S_in;
        WB_EN = S_in;
      end


      2'b10:
      begin
        B = 1'b1;
      end

      default:;
    endcase

  end

endmodule
