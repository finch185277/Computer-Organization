//Subject:     CO project 1 - ALU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:Yu-Chen Hsiao
//----------------------------------------------
//Date:2018/7/11
//----------------------------------------------
//Description:ALU Operation
//--------------------------------------------------------------------------------

module ALU(src1_i, src2_i, ctrl_i, shamt_i, result_o, zero_o);

  //I/O ports
  input  [32-1:0]  src1_i;
  input  [32-1:0]	 src2_i;
  input  [4-1:0]   ctrl_i;
  input  [5-1:0]   shamt_i;

  output [32-1:0]	 result_o;
  output           zero_o;

  //Internal signals
  wire signed [32-1:0]  result_o;
  wire                  zero_o;
  wire                  isEqual;

  //Parameter

  //Main function
  assign result_o = (ctrl_i == 4'b0001) ? src1_i + src2_i  :
                    (ctrl_i == 4'b0010) ? src1_i - src2_i  :
                    (ctrl_i == 4'b0011) ? src1_i & src2_i  :
                    (ctrl_i == 4'b0100) ? src1_i | src2_i  :
                    (ctrl_i == 4'b0101) ? ((src1_i < src2_i) ? 32'd1 : 32'd0) :
                    (ctrl_i == 4'b0110) ? src2_i >> shamt_i:  // sra
                    (ctrl_i == 4'b0111) ? src1_i >> src2_i :  // srav
                    (ctrl_i == 4'b1010) ? src2_i << 16     :  // lui
                                                    0      ;  // default
  assign zero_o = (ctrl_i == 4'b1000) ? ((src1_i == src2_i) ? 1'b1 : 1'b0) :
                  (ctrl_i == 4'b1001) ? ((src1_i == src2_i) ? 1'b0 : 1'b1) :
                                                              1'b0 ;  // default
  // always @ (ctrl_i) begin
  //   case (ctrl_i)
  //     1  : result_o <= src1_i + src2_i;            // addu, addi
  //     2  : result_o <= src1_i - src2_i;            // sub
  //     3  : result_o <= src1_i & src2_i;            // AND
  //     4  : result_o <= src1_i | src2_i;            // OR
  //     5  : result_o <= (src1_i < src2_i) ? 32'd1 : 32'd0;  // slt, sltiu
  //     6  : result_o <= src1_i >> src2_i;
  //     10 : result_o <= src2_i << 16;
  //     default : result_o <= 32'd0;// default
  //   endcase
  //   case (ctrl_i)
  //     8  : zero_o <= (src1_i == src2_i) ? 1'b1 : 1'b0;
  //     9  : zero_o <= (src1_i == src2_i) ? 1'b0 : 1'b1;
  //     default : zero_o <= 1'b0;
  //   endcase
  // end
endmodule
