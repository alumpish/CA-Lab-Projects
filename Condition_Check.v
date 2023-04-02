module ConditionCheck (
    input [3:0] cond,
    Status_R,   // N Z C V
    output reg Is_Valid
  );

  always @ (cond, Status_R)
  case (cond)
    // Z set
    4'b0000:
      Is_Valid = Status_R[2];
    // Z clear
    4'b0001:
      Is_Valid = !Status_R[2];
    // C set
    4'b0010:
      Is_Valid = Status_R[1];
    // C clear
    4'b0011:
      Is_Valid = !Status_R[1];
    // N set
    4'b0100:
      Is_Valid = Status_R[3];
    // N clear
    4'b0101:
      Is_Valid = !Status_R[3];
    // V set
    4'b0110:
      Is_Valid = Status_R[0];
    // V clear
    4'b0111:
      Is_Valid = !Status_R[0];
    // C set and Z clear
    4'b1000:
      Is_Valid = Status_R[1] && !Status_R[2];
    // C clear or Z set
    4'b1001:
      Is_Valid = !Status_R[1] || Status_R[2];
    // N == V
    4'b1010:
      Is_Valid = Status_R[3] == Status_R[0];
    // N != V
    4'b1011:
      Is_Valid = Status_R[3] != Status_R[0];
    // Z==0, N==V
    4'b1100:
      Is_Valid = !Status_R[2] && (Status_R[3] == Status_R[0]);
    // Z==1, N!=V
    4'b1101:
      Is_Valid = Status_R[2] && (Status_R[3] != Status_R[0]);
    // Always
    4'b1110:
      Is_Valid = 1'b1;
    // Never
    4'b1111:
      Is_Valid = 1'b0;
  endcase

endmodule
