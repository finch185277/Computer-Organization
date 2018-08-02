//Subject:     CO project 2 - ALU
//--------------------------------------------------------------------------------
//Version:     2
//--------------------------------------------------------------------------------
//Writer:      0616221 Yu-Chen Hsiao
//----------------------------------------------
//Date:        2018/8/2
//----------------------------------------------
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

  assign result_o = (ctrl_i == 4'b0000) ? src1_i & src2_i  :
                    (ctrl_i == 4'b0001) ? src1_i | src2_i  :
                    (ctrl_i == 4'b0010) ? src1_i + src2_i  :
                    (ctrl_i == 4'b0011) ? src1_i - src2_i  :
                    (ctrl_i == 4'b1000) ? $signed($signed(src2_i) >>> shamt_i):  // sra
                    (ctrl_i == 4'b1001) ? $signed($signed(src2_i) >>> src1_i) :  // srav
                    (ctrl_i == 4'b1010) ? ((src1_i < src2_i) ? {32{1'd1}} : 32'b0) :
                    (ctrl_i == 4'b1100) ? ({16'd0,src2_i[15:0]})     :  // li
                    (ctrl_i == 4'b1101) ? src1_i * src2_i  :  // mul
                                                   0       ;  // default
  assign zero_o = (src1_i == src2_i) ? 1'b1 : 1'b0;

endmodule
