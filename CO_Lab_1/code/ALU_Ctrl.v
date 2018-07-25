//Subject:     CO project 1 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Yu-Chien Hsiao
//----------------------------------------------
//Date:        2018/7/19
//----------------------------------------------
//Description:
//--------------------------------------------------------------------------------

module ALU_Ctrl(funct_i, ALUOp_i, ALUCtrl_o);

  //I/O ports
  input      [6-1:0] funct_i;
  input      [3-1:0] ALUOp_i;

  output     [4-1:0] ALUCtrl_o;

  //Internal Signals
  wire       [4-1:0] ALUCtrl_o;

  //Parameter


  //Select exact operation
  assign ALUCtrl_o = ({ALUOp_i,funct_i} == 9'b000_100001 | ALUOp_i == 3'b001)
                                                        ? 4'b0001 :  // 1.addu,addi
                   ({ALUOp_i,funct_i} == 9'b000_100011) ? 4'b0010 :  // 2.sub
                   ({ALUOp_i,funct_i} == 9'b000_100100) ? 4'b0011 :  // 3.AND
                   ({ALUOp_i,funct_i} == 9'b000_100101 | ALUOp_i == 3'b110)
                                                        ? 4'b0100 :  // 4.OR,ORi
                   ({ALUOp_i,funct_i} == 9'b000_101010 | ALUOp_i == 3'b010)
                                                        ? 4'b0101 :  // 5.slt,sltiu
                   ({ALUOp_i,funct_i} == 9'b000_000011) ? 4'b0110 :  // 6.sra
                   ({ALUOp_i,funct_i} == 9'b000_000111) ? 4'b0111 :  // 7.srav
                    (ALUOp_i == 3'b011)                 ? 4'b1000 :  // 8.beq
                    (ALUOp_i == 3'b100)                 ? 4'b1001 :  // 9.bnq
                    (ALUOp_i == 3'b101)                 ? 4'b1010 :  // 10.lui
                                                          4'b0000 ;  // 0.default

endmodule
