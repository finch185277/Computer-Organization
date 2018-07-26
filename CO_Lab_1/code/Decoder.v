//Description: Decoder(Controller)
//--------------------------------------------------------------------------------

module Decoder(instr_op_i, RegWrite_o, ALU_op_o, ALUSrc_o, RegDst_o);

  //I/O ports
  input  [6-1:0] instr_op_i;

  output         RegWrite_o;
  output [3-1:0] ALU_op_o;
  output         ALUSrc_o;
  output         RegDst_o;

  //Internal Signals
  wire           RegWrite_o;
  wire   [3-1:0] ALU_op_o;
  wire           ALUSrc_o;
  wire           RegDst_o;

  //Parameter


  //Main function
  //ALU control signal
  assign ALU_op_o = (instr_op_i==6'b000000) ? 3'b000 :  // 0.R-type
                    (instr_op_i==6'b001000) ? 3'b001 :  // 1.addi
                    (instr_op_i==6'b001011) ? 3'b010 :  // 2.sltiu
                    (instr_op_i==6'b000100) ? 3'b011 :  // 3.beq
                    (instr_op_i==6'b000101) ? 3'b100 :  // 4.bnq
                    (instr_op_i==6'b001111) ? 3'b101 :  // 5.lui
                    (instr_op_i==6'b001101) ? 3'b110 :  // 6.ori
                                              3'b111 ;

  // Don't need to read data: beq, bne
  assign RegWrite_o = (instr_op_i == 6'b000100 | instr_op_i == 6'b000101) ? 0 : 1;
  // Read immediate or offset from register file: lw, sw, *i, beq, bnq, lui
  assign ALUSrc_o = (instr_op_i == 6'b000000 |
                     instr_op_i == 6'b000100 |
                     instr_op_i == 6'b000101) ? 0 : 1;
  // Set Rd(1) or Rt(0) as destination : lw, sw, *i;
  assign RegDst_o = (instr_op_i == 6'b000000) ? 1 : 0;

endmodule
