//Subject:     CO project 1 - ALU_1bit
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:Yu-Chen Hsiao
//----------------------------------------------
//Date:2018/7/18
//----------------------------------------------
//Description:Adder Operation
//--------------------------------------------------------------------------------


module ALU_1bit (result_o, carry_out, inA, inB, operation, carry_in)
  output wire        result_o;
  output wire        carry_out;

  input wire         inA;
  input wire         inB;
  input wire  [4-1:0]  operation;
  input wire         carry_in;
  input wire         less;

  wire               add_result, add_carry;
  wire               sub_result;
  wire               inB_com;

  nor   inB_com, inB, $zero;


  Full_Adder  Add(add_result, carry_out, inA, inB, carry_in);
  FULL_Adder  Sub(sub_result, carry_out, inA, inB_com + 1'b1, carry_in);

  assign  result = (operation == 4'b0001) ? add_result :       // addu
                   (operation == 4'b0010) ? sub_result :       // subu
                   (operation == 4'b0010) ? inA & inB :        // AND
                   (operation == 4'b0110) ? inA | inB :        // OR
                   (operation == 4'b0111) ? less :

  assign  carry_out = (operation == 4'b0000) ? carry_out :
                      (operation == 4'b0001) ? carry_out :
                      (operation == 4'b0010) ? 0 :
                      (operation == 4'b0110) ? 0 :
                      (operation == 4'b0111) ? carry_out :
endmodule
