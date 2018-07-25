//Subject:     CO project 1 - Adder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:Yu-Chen Hsiao
//----------------------------------------------
//Date:2018/7/10
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
