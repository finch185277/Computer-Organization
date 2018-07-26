//Description:ALU Operation
//--------------------------------------------------------------------------------

module ALU(src1_i, src2_i, ctrl_i, shamt_i, result_o, zero_o);

  //I/O ports
  input  [32-1:0]  src1_i;
  input  [32-1:0]  src2_i;
  input  [4-1:0]   ctrl_i;
  input  [5-1:0]   shamt_i;

  output [32-1:0]	 result_o;
  output           zero_o;

  //Internal signals
  wire   [32-1:0]  result_o;
  wire             zero_o;

  //Parameter

  //Main function
  assign result_o = (ctrl_i == 4'b0001) ? src1_i + src2_i  :
                    (ctrl_i == 4'b0010) ? src1_i - src2_i  :
                    (ctrl_i == 4'b0011) ? src1_i & src2_i  :
                    (ctrl_i == 4'b0100) ? src1_i | src2_i  :
                    (ctrl_i == 4'b0101) ? ((src1_i < src2_i) ? 32'd1 : 32'd0) :
                    (ctrl_i == 4'b0110) ? $signed($signed(src2_i) >>> shamt_i):  // sra
                    (ctrl_i == 4'b0111) ? $signed($signed(src2_i) >>> src1_i) :  // srav
                    (ctrl_i == 4'b1010) ? src2_i << 16     :  // lui
                                                    0      ;  // default
  assign zero_o = (ctrl_i == 4'b1000) ? ((src1_i == src2_i) ? 1'b1 : 1'b0) :
                  (ctrl_i == 4'b1001) ? ((src1_i == src2_i) ? 1'b0 : 1'b1) :
                                                              1'b0 ;  // default

endmodule
