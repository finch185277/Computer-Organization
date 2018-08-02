//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      0616221 Yu-Chen Hsiao
//----------------------------------------------
//Date:        2018/8/2
//----------------------------------------------
//Description:
//--------------------------------------------------------------------------------

module Decoder(
              instr_op_i,
              RegWrite_o,
              Branch_o,
              MemToReg_o,
              Branch_Type_o,
              Jump_o,
              Jal_o,
              MemRead_o,
              MemWrite_o,
              ALU_op_o,
              ALUSrc_o,
              RegDst_o
              );

  //I/O ports
  input  [6-1:0] instr_op_i;
  output         RegWrite_o;
  output         Branch_o;
  output [2-1:0] MemToReg_o;
  output [2-1:0] Branch_Type_o;
  output         Jump_o;
  output         Jal_o;
  output         MemRead_o;
  output         MemWrite_o;
  output [4-1:0] ALU_op_o;
  output         ALUSrc_o;
  output         RegDst_o;

  //Internal Signals
  wire           RegWrite_o;
  wire           Branch_o;
  wire   [2-1:0] MemToReg_o;
  wire           Jump_o;
  wire           Jal_o;
  wire           MemRead_o;
  wire           MemWrite_o;
  wire   [4-1:0] ALU_op_o;
  wire           ALUSrc_o;
  wire           RegDst_o;

  //Parameter


  //Main function
  assign ALU_op_o = (instr_op_i==6'b100011) ? 4'b0000 :  // lw
                    (instr_op_i==6'b101011) ? 4'b0001 :  // sw
                    (instr_op_i==6'b000000) ? 4'b0010 :  // R-type
                    (instr_op_i==6'b001000) ? 4'b0011 :  // addi
                    (instr_op_i==6'b000100) ? 4'b0100 :  // beq
                    (instr_op_i==6'b000101) ? 4'b0101 :  // bnez(bnq)
                    (instr_op_i==6'b001111) ? 4'b0110 :  // li
                    (instr_op_i==6'b001101) ? 4'b0111 :  // ori
                    (instr_op_i==6'b001011) ? 4'b1000 :  // sltiu
                    (instr_op_i==6'b000110) ? 4'b1011 :  // ble
                    (instr_op_i==6'b000001) ? 4'b1101 :  // bltz
                                              4'b1111 ;

  // Don't need to read data
  assign RegWrite_o = (instr_op_i == 6'b101011 |  // sw
                       instr_op_i == 6'b000100 |  // beq
                       instr_op_i == 6'b000101 |  // bnez
                       instr_op_i == 6'b000110 |  // ble
                       instr_op_i == 6'b000001 |  // bltz
                       instr_op_i == 6'b000010 )  // j
                                   ? 0 : 1;
  // Branch
  assign Branch_o   = (instr_op_i == 6'b000100 |  // beq
                       instr_op_i == 6'b000101 |  // bnez
                       instr_op_i == 6'b000110 |  // ble
                       instr_op_i == 6'b000001 )  // bltz
                                   ? 1 : 0;
  // Data memory to register
  assign MemToReg_o = (instr_op_i == 6'b100011) ? 2'b01 : // readData_DM
                                                  2'b00 ; // result
  // Branch Type
  assign Branch_Type_o = (instr_op_i == 6'b000100) ? 2'b00 :  // beq
                         (instr_op_i == 6'b000101) ? 2'b01 :  // bnez
                         (instr_op_i == 6'b000110) ? 2'b10 :  // ble
                         (instr_op_i == 6'b000001) ? 2'b11 :  // bltz
                                                     2'b00 ;  // default
  // Jump : j, jal
  assign Jump_o = (instr_op_i == 6'b000010 | instr_op_i == 6'b000011) ? 0 : 1;
  // Jal
  assign Jal_o = (instr_op_i == 6'b000011) ? 1 : 0;
  // Load word
  assign MemRead_o = (instr_op_i == 6'b100011) ? 1 : 0; // lw
  // Store word
  assign MemWrite_o = (instr_op_i == 6'b101011) ? 1 : 0;  // sw
  // Read readData2 or offset from register file
  assign ALUSrc_o   = (instr_op_i == 6'b000000 |          // R-type
                       instr_op_i == 6'b000100 |          // beq
                       instr_op_i == 6'b000101 |          // bnez
                       instr_op_i == 6'b000110 |          // ble
                       instr_op_i == 6'b000001 ) ? 0 : 1; // bltz
  // Set Rd(1) or Rt(0) as destination
  assign RegDst_o   = (instr_op_i == 6'b000000) ? 1 : 0;  // R-type

endmodule
