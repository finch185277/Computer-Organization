//Subject:     CO project 1 - MUX 221
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Yu-Chen Hsiao
//----------------------------------------------
//Date:         2018/7/19
//----------------------------------------------
//Description:  Multiplexer
//--------------------------------------------------------------------------------

module MUX_2to1(data0_i, data1_i, select_i, data_o);

  parameter size = 0;

  //I/O ports
  input   [size-1:0] data0_i;
  input   [size-1:0] data1_i;
  input              select_i;
  output  [size-1:0] data_o;

  //Internal Signals
  wire    data0_i;
  wire    data1_i;
  wire    select_i;
  wire    data_o;

  //Main function
  assign data_o = (select_i == 0) ? data0_i : data1_i;

endmodule
