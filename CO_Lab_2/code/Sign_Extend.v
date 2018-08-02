//Subject:     CO project 1 - Sign extend
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:       0616221 Yu-Chien Hsiao
//----------------------------------------------
//Date:         2018/7/19
//----------------------------------------------
//Description:  finish
//--------------------------------------------------------------------------------

module Sign_Extend(
    data_i,
    data_o
    );

//I/O ports
input   [16-1:0] data_i;
output  [32-1:0] data_o;

//Internal Signals
reg     [32-1:0] data_o;

//Sign extended
always @ (data_i) begin
  data_o[16-1:0] = data_i;
  data_o[32-1:16] = {16{data_i[16-1]}};
end

endmodule
