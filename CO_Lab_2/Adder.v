//Subject:     CO project 2 - Adder
//--------------------------------------------------------------------------------
//Version:     2
//--------------------------------------------------------------------------------
//Writer: 0616221 Yu-Chen Hsiao
//----------------------------------------------
//Date:   2018/8/2
//----------------------------------------------
//Description:Adder Operation
//--------------------------------------------------------------------------------

module Adder(src1_i, src2_i, sum_o);
  //I/O ports
  input  [32-1:0]  src1_i;
  input  [32-1:0]	 src2_i;
  output [32-1:0]	 sum_o;

  //Internal Signals
  wire   [32-1:0]	 sum_o;

  //Main function
  assign sum_o = src1_i + src2_i;
endmodule
